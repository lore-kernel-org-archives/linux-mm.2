Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741DDD778AE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FEC6B0556; Fri, 23 Jan 2026 15:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7AA6B0558; Fri, 23 Jan 2026 15:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9206B0559; Fri, 23 Jan 2026 15:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4F3D6B0556
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:12:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8012AD3730
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:47 +0000 (UTC)
X-FDA: 84364326774.03.E009574
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E8E2C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WDJQLxd2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VUiCFOky;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kM2lpEQfJIcO/tRo7yAr119RzyDph4SO6OLNh3Kkjzw=;
	b=a6U3Z0JpoEIJpG653YTsFDUFcIbTkzlbQkjpehZkidP+0NH5BrhR8KcA4fxX+OBe+8DSFu
	ul1/DkH2OQrVP34X4VlSQbRjHq8Wpu+G+RB1ue20btryerxF/01Ki+Gt6JgD8zjyBlu5wg
	q0GzThlHSeYm8xU30aHBB95sDAwEWOk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WDJQLxd2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VUiCFOky;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199164; a=rsa-sha256;
	cv=pass;
	b=uat0RE6MeTps5VdC7dDciPio7GkiPpzAVGpOKPO/YdBW688nutmbGV5ftIx/mWUOVEutak
	3PCHtw9JE3jp8c7pL1qK+q/2lCZ2u+4KGjXxlV8ejNTVbhXRE7ng3UDrZ+Fi0oVqFkZw4G
	WDaFnvgHgjRa+/3c6NzqT7Hxz0SZcqM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NEeHlC2974134;
	Fri, 23 Jan 2026 20:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kM2lpEQfJIcO/tRo7yAr119RzyDph4SO6OLNh3Kkjzw=; b=
	WDJQLxd2S/eblogJlZyRzaqrHVpL3U8rVvvRJcu0mXY8E8t8fn6QsuZAQthm9gfP
	8Rk6NAmk2/CiZUX+JsDyI5F2VNbTZLXYZt/LaImvk9gb7ih6nlaww8wgyrpVri4t
	uGzGgDPWVJOuzaSGqI3zkZDbsqU/Yc8dPmb1dSvj8Ja3THc1cuBz3jbNZVbDvtD3
	6BEMjc9OCF237gQ4MGjSziHcjk0aB3bbeJYUdE01RKcAwavVqg2GEAgWurHTUSuw
	XWGn8NgH0DsOLAl6gyNoLsyHwNoCMsIWlg++QbpdR8T5J0IyUX2b35faCrkaAopd
	4itmNbj3kltSRFIwkCbBEQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcynpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NK0RVS013617;
	Fri, 23 Jan 2026 20:12:34 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4butv0w87s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYpYXDPvjRSkAYS/C6vDA2AQfAj6dh8CQOB19i3qZy2NvYUFY2ASYl3ql8/nllkzzVQm+HqAmfl3eG+rfLXj+QqID8XxbPNmnp/bv/GuVuv0p484KL9kvtyg6UDmxE3tI4y7idaxpI5lw/pXpURrwQNPmC4rPobz335D6AaaFXRVET9kjMtvv5q9MwvnMZseRkrE0et6V1S68SNQGiTV52Kz5c/4YQdo22Dj80N51N7waoN3LFG0AQCY8UKBvZiAiWMQ0k1yaI3EHFE3XUJLX+njHyp8x97QSTvuTTfVF09HBmrYxRnspC8WEgLM5kKldVg+wzXZbH+9qXvbl6wNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kM2lpEQfJIcO/tRo7yAr119RzyDph4SO6OLNh3Kkjzw=;
 b=Rwo1FjmX0PwFu05S6emkVOaDs4BOOPKJP2GXSBGkcvG2JMfCMPVtmX1kWwkiJ2tfuzE01VEcbNeQuK/dHFXHmsySuTTU9ONP8HwdnFO4blIMYhwqSzu0ZJuLDoxVvtVy1kQzZgazpKlhePdd0M4i9YvHKl5OXwhdplf/sq3mQMlExpfuEJtPXQa9mBlAYqJ1m3juYvt6a8O0Dw1Ucno3Rv1V+p/IKOd2qs07tRrGY1zO10IBNB8O2qH32eN7GHw8xlOuwT2hL4KMcLvxCmCje0wRYqhv0W9csAgpqwaYj8vKufDQ/R56MlgaSrc9wBszL7sC1GL+hA/GhOZ6td76Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kM2lpEQfJIcO/tRo7yAr119RzyDph4SO6OLNh3Kkjzw=;
 b=VUiCFOkyN9IZuH+6HIGFxN6G/eL2P6JcgEun29uBHoALAB+K+/Y6/dy1YyzPMW2D6yz97TUftU0yRvaQbj8uJfZ4cxht++yzSJ8+zOI93AZxR1+STLWfzBLpSCnM3wOvdLNf5rNJtbkA5zZ0p2SMJFJZ9i3ANKlFzfOdmARRPAs=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6877.namprd10.prod.outlook.com (2603:10b6:208:423::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:31 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 05/10] mm/vma: de-duplicate __vma_enter_locked() error path
Date: Fri, 23 Jan 2026 20:12:15 +0000
Message-ID: <c9759b593f6a158e984fa87abe2c3cbd368ef825.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0081.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::21) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4ffaf0-9a01-4f6c-75a8-08de5abbbd21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZXxN1BjRVz2rAFMquncrXty88LdlEYIhl3W9Oo4FKtHvysrQtYgWPVddn9WD?=
 =?us-ascii?Q?v740qmeJnKazFen7vxjVu5+it6HTQqPh/DWfLAayMqKbJpMYz6AdhWAuhtnM?=
 =?us-ascii?Q?tUgbz6bLEuOjVp/Vu4Wa2yg1l888zkJ1ztS4T9pfyeZWFxN61Q694Kd/Gzps?=
 =?us-ascii?Q?YYk6oxpMfatUH87qbfSlpiOqUDn3AsuMzwv62VZjPlev9A9knGTd7+cWjdFv?=
 =?us-ascii?Q?XqWQyhWTnvRoReOs3lxgdE9WL2q24Zft2tKUgruda7mtsEx1eBwHdCE2Mkyu?=
 =?us-ascii?Q?fcygF7MskeJDR897c2kkZoc60lZFBACzMY+8U4waxhacL6NaH9dzsjeGHDH8?=
 =?us-ascii?Q?kiDz4DTHMZHDey4mw4kLQ0aiOqKGwyMmHcTu2XKq+I3JXqsEdmgeXyU5prYU?=
 =?us-ascii?Q?CT7cHPDr3zMMtloPj4QAYqY1SDxKGFyG6k/0f8uSq6WpESbZPwoXdnwXgx2m?=
 =?us-ascii?Q?e8CDrv9bu4sSA3sqbl1jV3rwkvIgKo1MRcpmBWkC5xEA/Hp4anUrsFKZiDvK?=
 =?us-ascii?Q?LDeZRswj0uVLpSzYeouMORt5HGFHqHII+RbwwxJqDA2oeVXlmkbIbZmJIsTy?=
 =?us-ascii?Q?S/M5ad9irc+PJupjLXkekFRwn4y6ZfOXzs8FXDC00p4Od+Z0FmfmnoEjvSWF?=
 =?us-ascii?Q?ru0hORDtbShDV6qMOBMZEzxpxavHLrxmJTMvcddysH/9m8+WEYIjVP4Eo6rI?=
 =?us-ascii?Q?Eg99zY2cCR9SXsfhU/4yw7CfgA7KPnbJMuFBmLAUp0gjUP35HVrRlqnCShQe?=
 =?us-ascii?Q?u2HJZKYeK8JYIHbFac9Z4beW7Ph2QHlD+gGVGUtOqAh78/vhli5hadVFMmoR?=
 =?us-ascii?Q?9GRin7re6aJj6uQVM6W3JxRDDOOOSSXVHukGQvGM9a3ZYUFhVWl7ADaNNBtj?=
 =?us-ascii?Q?wtolo1qYFESUJx/a6uilmzGt60TuuP4CkLtRr0dPs5Z410IA0Wtwx7hOXutn?=
 =?us-ascii?Q?INfYGIKBrqeq40BziS/r/ITp9vDVoUrwz1MXORH3jTcVONZgJfX9EurCpcbF?=
 =?us-ascii?Q?1iEEOqZyge1v+xl/eLzX8a/bpJLjxMNeWf9hU4S8mu1kaNVNbWQiYyZILQQn?=
 =?us-ascii?Q?Aqq94fBfFLPQ39pCHGxSYW0GwspzHcacqVP1Vtyf5Gt+4UnO75ygF6Xb3jHr?=
 =?us-ascii?Q?+nnv/+3Q3JsDqzdukj3FSf3QvhKcP1kdumsi24KMoqgSyOVILn+EMkYjWCGw?=
 =?us-ascii?Q?EEgqzxBuXI3b7pHV3ON+KpxCNujwDGQAsx8N+RRfur6Hy51WEPO0TD6wmFoi?=
 =?us-ascii?Q?FdtnqMjBjTz0nXCfpD6hBL6GRgkPZ3i2eTJmZNW3bt2kFiDTcHdGbj8R4pau?=
 =?us-ascii?Q?c3pHQF1TBsLfeYms0m1YPMXmfcsb5MXYM2tgmZUbQESLbKx1qSfOFoUmWSj7?=
 =?us-ascii?Q?MRMrQlN/kIn/hP/UVuE0j0joWQH6OIhoa3DfSTfu0kOtwVGiYcpu6KUoiont?=
 =?us-ascii?Q?6U9FLAmEcOrQzBSzekuOzUxm6KAWmslsZX9LGscY3/OVrBOY/GS+CQnWIhOv?=
 =?us-ascii?Q?cA0D0SzU7jRmdvJcSVXPfZIHmSfehaPAJuhe7ynUyG6H2r7qqv4dYSrVTrej?=
 =?us-ascii?Q?cEPk+kqBfF2byBOIyz4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IxOHU7giDq9/GYcnx94nwHEqGBIbr0RijHLSTqT8qe6CESO/JuJX9/TKgwAW?=
 =?us-ascii?Q?fFF2bv+tpFfpLN3CUTIHb7b3TM08KJvgMBZESI1VZXk92rzFg1s6TRAPJ4tx?=
 =?us-ascii?Q?6lO0c7xPKZ4nmH7KX9JHI9OE//Ua2ACG9SDU7qjRUhb5AvoXoeKFJDWRqqkd?=
 =?us-ascii?Q?liPZEJ0k2C6Ann9eM/V3moBr3vrAnkH9E/z58PoQ3MIK3iacr6ZQvgqbIRAD?=
 =?us-ascii?Q?hti42RIdoV6+6meEFhEPwKICO+MP4Jy8dhztG6TlZRlJ0Y/7eKxxjgGYEng8?=
 =?us-ascii?Q?nBRI1Hfh7tTM8BmFEV4OP/ISWhcHsHrtNcNMLL6I5KivwjiY1dRYv6xbo0ov?=
 =?us-ascii?Q?56oYYqvXhNBS1c1ZCUOwHQkqDnBYxTebO7RpQcEvMHg3RJpgH3u6wh2gC9EK?=
 =?us-ascii?Q?wTfzxER4ZZhMrnPD6vN3AeQfzvP/64z/PzGcviDYihoFCUsf3QFXHk3ppZpP?=
 =?us-ascii?Q?3HjV/14gL0TMMPw7923ibIVgTacqyu4sYTdQwIgunty7+0wXJUoVEjqrcqdB?=
 =?us-ascii?Q?+nv7rXOL11kUur4/DyPKVOPb33mFTmeYX/CeRC9gOcayyj28gv7x32uhAwU4?=
 =?us-ascii?Q?cM/W076183ZReK1UrlMVJGyzk9GI56EE3nEvaYPblsWFIFMmP05BCuKRAQkA?=
 =?us-ascii?Q?TRnZTmq9nTHqCwOyIarmA7UzPD4D5ZHK9SVqkN3Xd9zuyc2XXwKedxAXJ881?=
 =?us-ascii?Q?+F9aol3wqwQlWVFERggCo+mh5U+5yLUiRpOWfPO/S6wfABrq46nuFVt+GRxr?=
 =?us-ascii?Q?oy31mQ9oKKUgzK4KPtRz/Hm7qdN2hJ7nxwcEcCRxT8i7PWSmVZQT4prBxrjY?=
 =?us-ascii?Q?AbHF5y7eWbTkRpiwt1V3M7zIz7jdoR1gzT9h0YW0/vcdxjCbYJvD9BskCq40?=
 =?us-ascii?Q?QmEVtTutfJ17Tn4o9cnNt0bvurNJQ0WStGO4OL/oVLrdPgmVGuP9NZOiRLOx?=
 =?us-ascii?Q?PgrMiJORYzIc+mWqTzRQ7/Zdmxl8Uf6h5TZqaRO+UCgWtBx2CO2sUjCdfEjD?=
 =?us-ascii?Q?yuA9l4PBmLjn34uVaTbOi5RjwppDDVpoy0ka5KuhuGX2l8nyKjGm9IbXzez5?=
 =?us-ascii?Q?tdWEEZYlweRimdNDGofkkGCw7D217lFA82FXM8F7M+VysAUsgxFnYesgHIVT?=
 =?us-ascii?Q?4kJdCzyizuh5smPxQ7xjK0g4c0eCjDfNsaYMtFmAG34FAkSFug0V1PAHRSck?=
 =?us-ascii?Q?K4p1mZn+XptoO6TS/gwTBicQlQd1CpFFU4VZx4PZpFAmknglH25mAjYreDil?=
 =?us-ascii?Q?xYy5SHLv7YsMf4o5k/5CjmQJAr7/kGf3WFFA7Uh7Ex2u7ktoVlfnnxDOBRus?=
 =?us-ascii?Q?++2iT2WkupBWfUKYOSMe+twA5hEbGPmKX2uJi9QNYuXC/DYV4HH+4PPAUUIM?=
 =?us-ascii?Q?jwo8vFma9PG/85lq+IM3umfffdwDVch/4uJ2F6XJ7CEA0BdS3+tZVxjSz5+o?=
 =?us-ascii?Q?jc4VdbVyrhgmFT3PXAeH1y9fvIaOILkKwcDpl3I2uilEZAu4qafS0YygKiCT?=
 =?us-ascii?Q?B5SbNCuBWhi+QHhlEP1k37k3keP1bZlbobxCdcegDrqr9ZOsB+abX08nQCvb?=
 =?us-ascii?Q?grgaMpS7jSmI3sLFryZ9BtBnSoM5xeodM7NwKVKO01iSz3XRDR0nU9Tr/DMv?=
 =?us-ascii?Q?yVycJECqsX2yAp0erhYrP27n9fcMP74J5HlMK0irgAErDU6JUj5XusoKPouP?=
 =?us-ascii?Q?IiWet28J2xcFSCeunXcnhElU9f/WjYT0P7o9X+905OhIHPEClxvZyfd97wIz?=
 =?us-ascii?Q?kUsGFvDRQBpNJP9qXUeb8HEVNmfjOMA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y05wSU+DX0gSMzMS9mxuZUxViQfKjTwKJKjq1L/zktlO/Jmy/jZQD+vDPxCpQjaqTkfZ8+iDEjRU2dw56kNNKiIkN6JCgwp33EmQl7isaqrJ35QVi9JyY4fUWN6uEtLYK2MtcfwVA3PVL4balOYfdxyJIqiWS7nkQ/b6dbobfsgxfKX4KaAhPB1G6qeyqbZazp8yHUvtC5iqJ74V8JUlwu/I290L7g/w8W+d4T8dJk5fBxPmW+NDR5gXF/DAn1GUq/KK/8WfYhS/QeDliz4qoYRteFIEq0B+AtYf43lNGLQcxEcyiqyVoGcJ7QHgwJJyI5qLuyVp+rjAgE157X4Jb1DgVCDHaafODi3nVW9UQc/x6QzCnBZvYSNhhmCwmNvk0NenKgBTxLDiJ+DgPgngNGkCnDDXmnXUUUEqSK1vnEimHASMNHR/v9a6CyiTGaF9qSOI3Lf2KUt+DsB+RnSIq456vDaZsVVm+A66fJ2HjiOZgxSZHeQiLdr/ZhqzC+zF5zymnJo6odNuo2ZYceX8pVBcGWEomwKhHyelyQKPy9M19LABbEJZ62YkJwvPS/ohLKXLzOHPeHvJ8soMYnFjngnIjtnrG9iyqlv0GzORsFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4ffaf0-9a01-4f6c-75a8-08de5abbbd21
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:31.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uX6xl3SY7PXoWXwiMjqHjuLqIq7V5CYHo+UXfJ7zJkg4BpF9B4aCix4w82i089sciirHyvcdVoeopxoIcjk3HZ0bcW0HZKyRXpOiDLNlUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230154
X-Proofpoint-ORIG-GUID: t_3Q4fiaWoNGwVyn2biDHBdGkszab9UD
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=6973d633 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=3lrxA4fjdKnX_o0fwtQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfXwXbRVMQk8Qmf
 UnH1eXwIrCXsEumhvvUEYzjZpWMlIGrZo5DyEEVFRlUyfVvxrXMVNk4MLwdHbeQvAfvaD1eSciE
 K6GWdtapMSuhf+rImVXw7dRCBXY6sXSotdgQBhWUFNKT3S5AYADeyK9aaH8xkCFGg0m+vETZcAP
 yBazGFzI7F9mNwD61LM2tUCBhA6hsmxLBh9bZOVnenoaBM5Ahx4cThoE2KcfWuGaD926xdj2Zfw
 6jqzSO9JseuraEo7d89dRFM+NmVtSEMzqP69Bfcx3cw5LJmHWhZe8pWmFx9v5xDwMHAmunNzS0x
 SDIsNl8hwAIgsMv07XGBc/QXZDAUJfWMtvvb93IGYtsgkyuleJq1TnTJpphhFl8pg2NIp6DhVLl
 C04pfdtIjBaUOAmPjFLBL4CbhHNxS56h2gA1gUR0zjVoX2NqlVCMMgRcHyZ0/VqtVd3SdQX/aYZ
 xFdN99OGnV/ILwFaxdQ==
X-Proofpoint-GUID: t_3Q4fiaWoNGwVyn2biDHBdGkszab9UD
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E8E2C0004
X-Stat-Signature: 56iunyabgn1c8c8mstkyef3mn7n3ctmd
X-Rspam-User: 
X-HE-Tag: 1769199164-512986
X-HE-Meta: U2FsdGVkX19ZCa306g36E5YFOFb1EpQ2HWoRn8YiO6kdbrJ3ca/8tv6NtTBg+XKe4yCia14S2UZGF/GyuwgXlq/nEIDTpx9hRvMECTDUIsQlVG3GI85mlRN5/KR2F+5m6uySzAsGN5qLEtUTPZDRZOjCphoXZaaRQJypr685f9TeaBoY7amBPP2aJwZGOFtCOd68tsXXiGNrmTx4cA0wwdHMYP0MK6MMCVuQSAtSukSSw4/K+EDP6JJ6uQxi8rlmEiN4m9iQ2oiDnxau9501X++AVxOWH+T7ri2TP7Qp7r5yhOwKKZWWfxEdQcrkP91auAF/UeGFdurvDrZsnOxyR2oc4+TgAagGt37f5wzCWdBHHlsy0wkE4tBAYBFXwRkysBJozCFVP0ax1UjwQKB94DmupGW3ZREFgxK4Yz+OrrW0Izl3awEwPZt1pzqmBqnyLkYZ3zsHhnSYYz1o9k49ZxDUJqIpABJ3G9dSrt2T914eIlWEzfhn8yyn1xHKvcbMdg0accHCirKRpdeOYl18V/9Yg0gn7QmO03ZrmImK3peeOk8rzj9aoUyJgBn/YVkI9ZWWDow89b9I+1WrBDtIvKUDGzjXszWjoA2r8DeUjHlIz5FtovpQlMoKS5iXIh28zpnxoz0Ukbw+8qI5Mw+/V8gnLFsUxafB0hFw5mcZfsMb68zDsn2jOJCEcfL+AHJImaQ31D1MaIL/WfWr1xLlKNKxnNdCWiRQCAvlztfH5fNlAbL6svtbUcSnakM5knZyaqkzYBc+O/MWi2HM4hxkqHXSomqY+6YrzHZLxOnECkl1GkkhwHEm47y0xfLNd1t/ez+2cw3MCap5KYcyEo425NyZztMqhmB6rTEjLMebruCqFVcpslGJCTQMObvsFoejA5AXI1CfWUoG9sfYXAlySv/2dh+4DxSr85oKIfmMgpqfFyp1Rm7j3eQAfoqXV82hHeXwHrfyBrsq/Hiy/Yi
 +Qzy5A3B
 PpAmh0fj77/6iw31j2+Zic9w7whluWOr4TX6K04Su0whvdLlgCOjmsCrbmFg9tzAQE2YFVdKTRmMXveFpiIOJcgXDADKJfU18YG6q2TQhniXL5reumBaHc2fbdq1f7+e96sdbxRT20nkZfdHC0iGd/pcAIUR9i2l+O2HQI2NGso5EhlRvyIGKhrhqaFVHYHkHuia6ZeV5oTtsGVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're doing precisely the same thing that __vma_exit_locked() does, so
de-duplicate this code and keep the refcount primitive in one place.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mmap_lock.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 85b2ae1d9720..1fabda07c922 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -45,6 +45,14 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
+
+static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+{
+	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					  &vma->vm_refcnt);
+	__vma_lockdep_release_exclusive(vma);
+}
+
 /*
  * __vma_enter_locked() returns 0 immediately if the vma is not
  * attached, otherwise it waits for any current readers to finish and
@@ -77,7 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		bool detached;
+
+		__vma_exit_locked(vma, &detached);
+		if (detached) {
 			/*
 			 * The wait failed, but the last reader went away
 			 * as well.  Tell the caller the VMA is detached.
@@ -85,7 +96,6 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
 	__vma_lockdep_stat_mark_acquired(vma);
@@ -93,13 +103,6 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	return 1;
 }
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
-{
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
-	__vma_lockdep_release_exclusive(vma);
-}
-
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
-- 
2.52.0


