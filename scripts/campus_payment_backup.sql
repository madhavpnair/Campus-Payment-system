--
-- PostgreSQL database dump
--

\restrict oaQccx7cObD7Z9ScIQTuu6qZ4z8gh81nI3LrCmFwTbbigWedWimEQREiui2ZhXJ

-- Dumped from database version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    admin_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    password_hash character varying(255)
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: bank_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_account (
    bankaccount_id integer NOT NULL,
    bank_name character varying(50),
    account_number character varying(50),
    ifsc_code character varying(50)
);


ALTER TABLE public.bank_account OWNER TO postgres;

--
-- Name: bill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bill (
    bill_id integer NOT NULL,
    student_id integer NOT NULL,
    vendor_id integer NOT NULL,
    settlement_id integer,
    total_amount numeric(10,2) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT bill_status_check CHECK (((status)::text = ANY ((ARRAY['completed'::character varying, 'refund'::character varying])::text[]))),
    CONSTRAINT bill_total_amount_check CHECK ((total_amount > (0)::numeric))
);


ALTER TABLE public.bill OWNER TO postgres;

--
-- Name: bill_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bill_item (
    bill_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity integer NOT NULL,
    selling_price numeric(10,2) NOT NULL,
    CONSTRAINT bill_item_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.bill_item OWNER TO postgres;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    inventory_id integer NOT NULL,
    item_id integer NOT NULL,
    vendor_id integer NOT NULL,
    cost numeric(10,2) NOT NULL,
    in_stock boolean DEFAULT true,
    last_update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT inventory_cost_check CHECK ((cost >= (0)::numeric))
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    item_id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: recharge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recharge (
    recharge_id integer NOT NULL,
    student_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT recharge_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.recharge OWNER TO postgres;

--
-- Name: settlement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settlement (
    settlement_id integer NOT NULL,
    vendor_id integer NOT NULL,
    admin_id integer NOT NULL,
    status character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT settlement_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT settlement_status_check CHECK (((status)::text = ANY ((ARRAY['requested'::character varying, 'paid'::character varying])::text[])))
);


ALTER TABLE public.settlement OWNER TO postgres;

--
-- Name: spending_limit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spending_limit (
    limit_id integer NOT NULL,
    student_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    remaining_amount numeric(10,2) NOT NULL,
    CONSTRAINT check_dates CHECK ((end_date >= start_date)),
    CONSTRAINT spending_limit_remaining_amount_check CHECK ((remaining_amount >= (0)::numeric))
);


ALTER TABLE public.spending_limit OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    student_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(50),
    phone character varying(15),
    balance numeric(10,2) DEFAULT 0,
    password_hash character varying(20),
    CONSTRAINT student_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_account (
    bankaccount_id integer NOT NULL,
    student_id integer NOT NULL
);


ALTER TABLE public.student_account OWNER TO postgres;

--
-- Name: vendor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendor (
    vendor_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20),
    password_hash character varying(255) NOT NULL
);


ALTER TABLE public.vendor OWNER TO postgres;

--
-- Name: vendor_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendor_account (
    bankaccount_id integer NOT NULL,
    vendor_id integer NOT NULL
);


ALTER TABLE public.vendor_account OWNER TO postgres;

--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (admin_id, first_name, last_name, password_hash) FROM stdin;
1	Rahul	Desai	e99a18c428cb38d5f260853678922e03
2	Priya	Menon	87d9bb400c0634691f0e3baaf1e2fd0d
3	Amit	Singhania	a3f0f7ee1b82e2e7b85ccb6b7a5a3a41
4	Neha	Reddy	c4ca4238a0b923820dcc509a6f75849b
5	Vikram	Malhotra	c81e728d9d4c2f636f067f89cc14862c
\.


--
-- Data for Name: bank_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_account (bankaccount_id, bank_name, account_number, ifsc_code) FROM stdin;
1	Punjab National Bank	777105802166	PUNB0869603
2	Punjab National Bank	315692151496663	PUNB0802314
3	State Bank of India	11207238756	SBIN0483370
4	ICICI Bank	25877679859	ICIC0164716
5	ICICI Bank	7835936307829964	ICIC0252593
6	Punjab National Bank	34735607306	PUNB0600194
7	Axis Bank	8295754563898	UTIB0118608
8	Axis Bank	8375867201719	UTIB0516714
9	Kotak Mahindra Bank	825774068385984	KKBK0106469
10	Bank of Baroda	60683425052	BARB0388905
11	ICICI Bank	0265674309274	ICIC0652089
12	HDFC Bank	51499794438091	HDFC0905554
13	State Bank of India	1531577919	SBIN0537296
14	State Bank of India	8957991434773547	SBIN0801388
15	Canara Bank	9228678177	CNRB0724652
16	Axis Bank	172895140757	UTIB0498709
17	State Bank of India	89832363575	SBIN0135148
18	Axis Bank	9785458465874831	UTIB0714324
19	Kotak Mahindra Bank	0302872899	KKBK0649110
20	Punjab National Bank	71172431949	PUNB0619288
21	ICICI Bank	468037089918601	ICIC0008408
22	Union Bank of India	79282575897540	UBIN0189602
23	State Bank of India	8851522882220993	SBIN0771575
24	State Bank of India	631830864866518	SBIN0220593
25	Kotak Mahindra Bank	95047839863	KKBK0473309
26	Canara Bank	27209380056	CNRB0175599
27	Kotak Mahindra Bank	8900481016636298	KKBK0996368
28	Bank of Baroda	70703845172	BARB0384466
29	Punjab National Bank	11224436415546	PUNB0509217
30	HDFC Bank	865579999003	HDFC0550621
31	State Bank of India	17505200396	SBIN0508035
32	Punjab National Bank	214345497515766	PUNB0714555
33	ICICI Bank	3806052096	ICIC0982470
34	Canara Bank	6517437249	CNRB0223453
35	Punjab National Bank	5319093346	PUNB0750859
36	Canara Bank	906491051276335	CNRB0494912
37	Union Bank of India	56329001567393	UBIN0315904
38	Punjab National Bank	2431809371	PUNB0390843
39	Axis Bank	267242726484	UTIB0073616
40	Union Bank of India	06645899651728	UBIN0135052
41	IndusInd Bank	52773859565	INDB0512367
42	HDFC Bank	1555033560315	HDFC0073916
43	Kotak Mahindra Bank	898673125037	KKBK0997513
44	Union Bank of India	035207955361	UBIN0111550
45	Union Bank of India	74489499389647	UBIN0939229
46	State Bank of India	407525864838166	SBIN0335506
47	Union Bank of India	3455810008	UBIN0981174
48	State Bank of India	783383789538615	SBIN0950288
49	HDFC Bank	88049677444582	HDFC0188970
50	Kotak Mahindra Bank	2039544184557	KKBK0102081
\.


--
-- Data for Name: bill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bill (bill_id, student_id, vendor_id, settlement_id, total_amount, date, status) FROM stdin;
1	16	4	\N	459.12	2026-02-14	completed
2	14	6	11	1975.97	2026-02-24	completed
3	10	2	11	754.15	2026-02-19	completed
4	3	3	13	342.80	2026-03-08	completed
5	19	9	17	56.00	2026-03-01	completed
6	9	8	16	2356.03	2026-02-22	completed
7	1	10	13	2361.34	2026-02-27	completed
8	27	2	16	490.07	2026-03-11	completed
9	29	7	\N	1696.87	2026-02-10	completed
10	3	5	\N	703.25	2026-03-09	completed
11	10	8	18	92.89	2026-02-23	completed
12	2	10	\N	1541.20	2026-03-11	completed
13	25	4	3	1200.44	2026-02-13	completed
14	13	7	\N	353.66	2026-03-09	completed
15	7	7	15	1779.09	2026-02-27	completed
16	30	8	17	460.51	2026-02-20	completed
17	23	7	4	1246.82	2026-02-28	completed
18	1	9	15	747.24	2026-03-08	completed
19	13	1	19	324.91	2026-02-15	completed
20	3	9	19	562.86	2026-02-12	completed
21	17	4	\N	74.58	2026-02-20	completed
22	23	3	\N	2251.17	2026-03-05	completed
23	16	2	6	404.84	2026-03-06	completed
24	30	3	10	471.29	2026-03-10	completed
25	10	7	14	878.84	2026-02-10	completed
26	8	10	19	653.61	2026-03-05	completed
27	14	1	\N	441.54	2026-03-06	completed
28	13	1	3	454.86	2026-02-25	completed
29	23	6	16	115.59	2026-02-23	completed
30	27	10	\N	1849.95	2026-03-09	completed
31	11	9	13	585.78	2026-03-02	completed
32	13	2	7	1550.86	2026-02-16	completed
33	24	8	\N	336.39	2026-02-24	completed
34	7	6	\N	1230.60	2026-03-09	completed
35	21	4	\N	490.16	2026-02-12	completed
36	10	10	\N	1295.08	2026-02-16	completed
37	1	10	\N	1493.10	2026-03-02	completed
38	16	7	\N	85.78	2026-03-01	completed
39	14	5	18	1776.27	2026-03-10	completed
40	9	8	\N	458.78	2026-02-19	completed
\.


--
-- Data for Name: bill_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bill_item (bill_id, item_id, quantity, selling_price) FROM stdin;
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory (inventory_id, item_id, vendor_id, cost, in_stock, last_update_time) FROM stdin;
1	50	6	284.00	t	2026-03-12 01:32:42
2	9	6	58.00	f	2026-03-12 01:32:42
3	42	9	152.00	t	2026-03-12 01:32:42
4	11	9	108.00	t	2026-03-12 01:32:42
5	19	7	82.00	t	2026-03-12 01:32:42
6	17	6	135.00	t	2026-03-12 01:32:42
7	5	8	89.00	t	2026-03-12 01:32:42
8	26	9	47.00	t	2026-03-12 01:32:42
9	32	3	34.00	t	2026-03-12 01:32:42
10	28	2	16.00	t	2026-03-12 01:32:42
11	44	4	226.00	f	2026-03-12 01:32:42
12	25	5	53.00	t	2026-03-12 01:32:42
13	32	3	232.00	t	2026-03-12 01:32:42
14	40	3	499.00	f	2026-03-12 01:32:42
15	2	8	46.00	t	2026-03-12 01:32:42
16	36	4	444.00	t	2026-03-12 01:32:42
17	21	10	121.00	t	2026-03-12 01:32:42
18	5	5	61.00	t	2026-03-12 01:32:42
19	25	8	143.00	t	2026-03-12 01:32:42
20	6	2	68.00	t	2026-03-12 01:32:42
21	48	4	470.00	t	2026-03-12 01:32:42
22	9	10	26.00	f	2026-03-12 01:32:42
23	28	8	12.00	t	2026-03-12 01:32:42
24	28	10	4.00	t	2026-03-12 01:32:42
25	35	7	408.00	t	2026-03-12 01:32:42
26	49	7	359.00	f	2026-03-12 01:32:42
27	41	1	310.00	t	2026-03-12 01:32:42
28	29	6	11.00	t	2026-03-12 01:32:42
29	15	9	144.00	t	2026-03-12 01:32:42
30	34	2	205.00	t	2026-03-12 01:32:42
31	25	9	44.00	t	2026-03-12 01:32:42
32	16	3	70.00	t	2026-03-12 01:32:42
33	21	3	52.00	t	2026-03-12 01:32:42
34	19	7	129.00	t	2026-03-12 01:32:42
35	42	2	445.00	t	2026-03-12 01:32:42
36	25	5	86.00	t	2026-03-12 01:32:42
37	15	8	38.00	t	2026-03-12 01:32:42
38	31	3	65.00	t	2026-03-12 01:32:42
39	27	1	21.00	t	2026-03-12 01:32:42
40	46	6	275.00	t	2026-03-12 01:32:42
41	43	7	149.00	t	2026-03-12 01:32:42
42	26	8	24.00	t	2026-03-12 01:32:42
43	45	8	261.00	t	2026-03-12 01:32:42
44	18	10	32.00	f	2026-03-12 01:32:42
45	31	1	190.00	t	2026-03-12 01:32:42
46	46	3	48.00	f	2026-03-12 01:32:42
47	37	3	193.00	f	2026-03-12 01:32:42
48	16	5	87.00	t	2026-03-12 01:32:42
49	17	3	67.00	t	2026-03-12 01:32:42
50	14	9	94.00	t	2026-03-12 01:32:42
51	15	7	39.00	f	2026-03-12 01:32:42
52	3	8	26.00	t	2026-03-12 01:32:42
53	17	6	68.00	t	2026-03-12 01:32:42
54	14	10	21.00	t	2026-03-12 01:32:42
55	50	1	197.00	t	2026-03-12 01:32:42
56	15	4	134.00	t	2026-03-12 01:32:42
57	26	10	6.00	f	2026-03-12 01:32:42
58	9	6	12.00	t	2026-03-12 01:32:42
59	32	2	275.00	t	2026-03-12 01:32:42
60	27	2	4.00	t	2026-03-12 01:32:42
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item (item_id, name) FROM stdin;
1	Masala Dosa
2	Veg Maggi
3	Cheese Maggi
4	Samosa
5	Vada Pav
6	Bread Omlette
7	Veg Sandwich
8	Paneer Wrap
9	Filter Coffee
10	Cold Coffee
11	Masala Chai
12	Lemon Tea
13	Mango Juice
14	Watermelon Juice
15	Banana Shake
16	Lassi
17	Butter Milk
18	Oreo Biscuit Pack
19	Good Day Biscuit
20	Hide & Seek Biscuit
21	Dairy Milk Chocolate
22	Kurkure Masala Munch
23	Lay's Classic Salted
24	Aloo Bhujia (50g)
25	Water Bottle 500ml
26	B/W Photocopy A4
27	Color Printout A4
28	Spiral Binding
29	Lamination
30	Scanning Service
31	Dettol Soap
32	Lifebuoy Soap
33	Pears Soap
34	Colgate Toothpaste
35	Pepsodent Toothpaste
36	Shampoo Sachet (Dove)
37	Shampoo Sachet (Clinic Plus)
38	Blue Ballpoint Pen
39	Black Gel Pen
40	Reynolds Trimax
41	A4 Notebook 200pg
42	Spiral Notebook
43	Scientific Calculator
44	Exam Pad
45	Geometry Box
46	A4 Paper Rim
47	Fevistick
48	Eraser & Sharpener Set
49	Pencil Box
50	Sticky Notes
\.


--
-- Data for Name: recharge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recharge (recharge_id, student_id, amount, date) FROM stdin;
1	4	200.00	2026-02-25
2	16	500.00	2026-01-13
3	10	200.00	2026-02-14
4	23	1500.00	2026-01-15
5	3	100.00	2026-03-10
6	14	200.00	2026-02-07
7	19	2000.00	2026-02-14
8	12	100.00	2026-03-08
9	16	2000.00	2026-02-22
10	16	500.00	2026-01-17
11	21	1500.00	2026-01-19
12	16	500.00	2026-02-27
13	20	1000.00	2026-02-03
14	27	100.00	2026-02-23
15	15	2000.00	2026-01-11
16	18	200.00	2026-02-05
17	14	2000.00	2026-01-30
18	29	2000.00	2026-02-26
19	6	500.00	2026-01-14
20	29	200.00	2026-02-05
21	10	1000.00	2026-01-20
22	29	2000.00	2026-02-08
23	19	1500.00	2026-03-10
24	18	1500.00	2026-01-24
25	30	1500.00	2026-02-13
26	3	200.00	2026-01-11
27	2	100.00	2026-02-24
28	27	500.00	2026-02-05
29	11	2000.00	2026-01-20
30	17	1500.00	2026-02-28
31	20	1500.00	2026-02-12
32	22	1000.00	2026-01-31
33	4	2000.00	2026-01-15
34	22	1000.00	2026-02-19
35	24	200.00	2026-03-05
36	2	1500.00	2026-01-28
37	8	200.00	2026-01-23
38	12	2000.00	2026-02-20
39	18	1000.00	2026-02-04
40	23	100.00	2026-01-13
\.


--
-- Data for Name: settlement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settlement (settlement_id, vendor_id, admin_id, status, amount, date) FROM stdin;
1	4	5	paid	1884.00	2026-03-03
2	1	1	paid	1049.00	2026-02-25
3	7	4	requested	745.00	2026-03-05
4	5	3	requested	3473.00	2026-02-17
5	4	1	requested	2257.00	2026-02-25
6	6	3	paid	1160.00	2026-02-12
7	6	2	paid	2641.00	2026-03-05
8	2	5	paid	2089.00	2026-02-22
9	3	5	requested	3083.00	2026-02-27
10	3	3	paid	2539.00	2026-02-14
11	1	1	requested	2895.00	2026-02-16
12	1	2	requested	1758.00	2026-02-13
13	1	5	requested	4156.00	2026-03-09
14	4	5	requested	4722.00	2026-02-15
15	2	2	requested	4335.00	2026-02-24
16	9	3	paid	1397.00	2026-02-27
17	2	4	requested	1816.00	2026-03-03
18	7	3	requested	4498.00	2026-02-17
19	4	2	paid	1402.00	2026-03-08
20	8	1	requested	1409.00	2026-02-28
\.


--
-- Data for Name: spending_limit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spending_limit (limit_id, student_id, start_date, end_date, remaining_amount) FROM stdin;
1	8	2026-02-22	2026-03-24	1500.00
2	21	2026-02-23	2026-03-25	3000.00
3	11	2026-03-10	2026-04-09	1000.00
4	22	2026-03-01	2026-03-31	3000.00
5	24	2026-03-08	2026-04-07	5000.00
6	18	2026-03-07	2026-04-06	2000.00
7	18	2026-02-13	2026-03-15	1500.00
8	22	2026-02-22	2026-03-24	500.00
9	22	2026-03-11	2026-04-10	1500.00
10	20	2026-03-07	2026-04-06	1500.00
11	4	2026-03-09	2026-04-08	1500.00
12	10	2026-02-22	2026-03-24	3000.00
13	24	2026-02-11	2026-03-13	1000.00
14	3	2026-02-21	2026-03-23	500.00
15	25	2026-03-05	2026-04-04	5000.00
16	21	2026-02-11	2026-03-13	500.00
17	1	2026-02-19	2026-03-21	3000.00
18	22	2026-02-18	2026-03-20	3000.00
19	1	2026-02-26	2026-03-28	3000.00
20	23	2026-02-13	2026-03-15	5000.00
21	4	2026-02-19	2026-03-21	1000.00
22	6	2026-02-28	2026-03-30	1000.00
23	6	2026-02-16	2026-03-18	1000.00
24	8	2026-02-14	2026-03-16	1000.00
25	13	2026-03-07	2026-04-06	5000.00
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (student_id, first_name, last_name, email, phone, balance, password_hash) FROM stdin;
1	Falguni	Bhakta	falgunibhakta1@campus.edu	00485130964	1985.16	4fb9e6e97d0d903
2	Chasmum	Choudhary	chasmumchoudhary2@campus.edu	01279746810	1947.39	755706149089e26
3	Gagan	Bir	gaganbir3@campus.edu	+911947126645	844.70	d1ccc7a1705dd30
4	Madhavi	Kalita	madhavikalita4@campus.edu	+910626873372	2480.07	66e1866a206ed7b
5	Damyanti	Ray	damyantiray5@campus.edu	+915633380683	1274.07	170389c2f610de4
6	Lakshmi	Luthra	lakshmiluthra6@campus.edu	03878639549	778.37	a4bc9708dc04b58
7	Yashoda	Saha	yashodasaha7@campus.edu	03171370031	1239.90	aea63b7a54d1e7c
8	Urishilla	Bora	urishillabora8@campus.edu	2632586494	149.34	01f890bbcbb9e2c
9	Pranit	Merchant	pranitmerchant9@campus.edu	07141691161	3645.40	4869bec7930f180
10	Dayita	Sandhu	dayitasandhu10@campus.edu	4479269973	4828.82	3eb74c0a1c4b646
11	Chaaya	Nayar	chaayanayar11@campus.edu	05504695285	846.72	f893f0e75a1c417
12	Prisha	Badal	prishabadal12@campus.edu	+917806702846	1206.64	553fe8408c174d4
13	Ayush	Bhatti	ayushbhatti13@campus.edu	+914412403077	3260.63	c67e13864a30b9f
14	Kavya	Nagy	kavyanagy14@campus.edu	4647431506	3950.36	c0440b246be3b4d
15	Ojas	Sarma	ojassarma15@campus.edu	+916713288684	4925.50	14b8af8e5c94184
16	Caleb	Parmer	calebparmer16@campus.edu	4003421171	2226.94	6048b47fd19fbdb
17	Harsh	Sehgal	harshsehgal17@campus.edu	3795879519	457.78	93260eafd86bf05
18	Wriddhish	Nanda	wriddhishnanda18@campus.edu	3844360656	3938.60	522a7e3f30d38ef
19	Chaaya	Chopra	chaayachopra19@campus.edu	9695660490	3974.97	c0486c1e79f8ac0
20	Xavier	Jaggi	xavierjaggi20@campus.edu	0715727665	4815.33	0686ccdc2e3ce34
21	Harita	Suri	haritasuri21@campus.edu	3648404627	3749.12	9adad953e91e77d
22	Saksham	Narasimhan	sakshamnarasimhan22@campus.edu	01016457497	3192.78	a984088739246b7
23	Aarnav	Mahajan	aarnavmahajan23@campus.edu	+913666187046	4649.94	f6642d3d7232f74
24	Girindra	Kade	girindrakade24@campus.edu	8039007710	3905.67	74ed789e08721ca
25	Gayathri	Dora	gayathridora25@campus.edu	+917823614493	536.64	1611555eb376db8
26	Tanmayi	Nadkarni	tanmayinadkarni26@campus.edu	06208023950	4144.40	800e5cd45e90022
27	Mugdha	Anne	mugdhaanne27@campus.edu	+915827700104	4376.72	4fc415e590932b8
28	Aadi	Sagar	aadisagar28@campus.edu	1551619858	619.60	e1225c3e85619f0
29	Yatan	Raja	yatanraja29@campus.edu	+916758755101	181.67	7ab4666d835fd21
30	Mahika	Raghavan	mahikaraghavan30@campus.edu	05519527643	2123.93	60ee6ad51b90c91
\.


--
-- Data for Name: student_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_account (bankaccount_id, student_id) FROM stdin;
172	1
273	2
450	3
399	4
488	5
143	6
205	7
280	8
475	9
316	10
261	11
299	12
451	13
377	14
129	15
229	16
458	17
314	18
445	19
336	20
184	21
240	22
206	23
341	24
270	25
372	26
420	27
432	28
307	29
397	30
392	3
217	10
309	30
376	11
194	9
122	6
\.


--
-- Data for Name: vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendor (vendor_id, name, email, phone, password_hash) FROM stdin;
1	Manju's Canteen	manjus.v1@campus.edu	+915775391922	e007c249dbeda53
2	Amul Parlour	amul.v2@campus.edu	03992156538	a7f082e80856e45
3	Nescafe	nescafe.v3@campus.edu	+918853358298	6729b1de6ecfb08
4	Kappi Cafe	kappi.v4@campus.edu	9448298065	8985c021e0a4579
5	Xerox & Print Shop	xerox.v5@campus.edu	+917611631734	2f6a764e6d505b7
6	Maggi Point	maggi.v6@campus.edu	5263098527	986dbf6cbf50c56
7	Night Canteen	night.v7@campus.edu	9391260306	e4bec94e8d08339
8	Raju Omelette Centre	raju.v8@campus.edu	+914586080851	40f6f25b18597a3
9	Chai Tapri	chai.v9@campus.edu	8259499401	cdecc2218f8d1d8
10	Fresh Juice Corner	fresh.v10@campus.edu	2348263324	98f815366286ac2
\.


--
-- Data for Name: vendor_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendor_account (bankaccount_id, vendor_id) FROM stdin;
19	1
39	2
8	3
11	4
37	5
24	6
28	7
35	8
33	9
49	10
50	1
7	4
12	10
10	9
\.


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (admin_id);


--
-- Name: bank_account bank_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_pkey PRIMARY KEY (bankaccount_id);


--
-- Name: bill_item bill_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill_item
    ADD CONSTRAINT bill_item_pkey PRIMARY KEY (bill_id, item_id);


--
-- Name: bill bill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT bill_pkey PRIMARY KEY (bill_id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (item_id);


--
-- Name: recharge recharge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recharge
    ADD CONSTRAINT recharge_pkey PRIMARY KEY (recharge_id);


--
-- Name: settlement settlement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settlement
    ADD CONSTRAINT settlement_pkey PRIMARY KEY (settlement_id);


--
-- Name: spending_limit spending_limit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spending_limit
    ADD CONSTRAINT spending_limit_pkey PRIMARY KEY (limit_id);


--
-- Name: student_account student_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_account
    ADD CONSTRAINT student_account_pkey PRIMARY KEY (bankaccount_id);


--
-- Name: student student_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_email_key UNIQUE (email);


--
-- Name: student student_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_phone_key UNIQUE (phone);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- Name: vendor_account vendor_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendor_account
    ADD CONSTRAINT vendor_account_pkey PRIMARY KEY (bankaccount_id);


--
-- Name: vendor vendor_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendor
    ADD CONSTRAINT vendor_email_key UNIQUE (email);


--
-- Name: vendor vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendor
    ADD CONSTRAINT vendor_pkey PRIMARY KEY (vendor_id);


--
-- Name: settlement fk_admin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settlement
    ADD CONSTRAINT fk_admin FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id) ON DELETE CASCADE;


--
-- Name: bill_item fk_bill; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill_item
    ADD CONSTRAINT fk_bill FOREIGN KEY (bill_id) REFERENCES public.bill(bill_id) ON DELETE CASCADE;


--
-- Name: bill_item fk_item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill_item
    ADD CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE CASCADE;


--
-- Name: inventory fk_item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES public.item(item_id) ON DELETE CASCADE;


--
-- Name: bill fk_settlement; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fk_settlement FOREIGN KEY (settlement_id) REFERENCES public.settlement(settlement_id) ON DELETE SET NULL;


--
-- Name: bill fk_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: recharge fk_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recharge
    ADD CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: student_account fk_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_account
    ADD CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: spending_limit fk_student_limit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spending_limit
    ADD CONSTRAINT fk_student_limit FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON DELETE CASCADE;


--
-- Name: bill fk_vendor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fk_vendor FOREIGN KEY (vendor_id) REFERENCES public.vendor(vendor_id) ON DELETE CASCADE;


--
-- Name: inventory fk_vendor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT fk_vendor FOREIGN KEY (vendor_id) REFERENCES public.vendor(vendor_id) ON DELETE CASCADE;


--
-- Name: settlement fk_vendor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settlement
    ADD CONSTRAINT fk_vendor FOREIGN KEY (vendor_id) REFERENCES public.vendor(vendor_id) ON DELETE CASCADE;


--
-- Name: vendor_account fk_vendor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendor_account
    ADD CONSTRAINT fk_vendor FOREIGN KEY (vendor_id) REFERENCES public.vendor(vendor_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict oaQccx7cObD7Z9ScIQTuu6qZ4z8gh81nI3LrCmFwTbbigWedWimEQREiui2ZhXJ

