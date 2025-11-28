Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9C9CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A46F6B002F; Fri, 28 Nov 2025 02:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BB16B0030; Fri, 28 Nov 2025 02:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4439A6B0031; Fri, 28 Nov 2025 02:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7376B002F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:58:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD47A5050E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:58:12 +0000 (UTC)
X-FDA: 84159262824.27.40C402F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id B9354180004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:58:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eBhLtmnw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="pTVF4t/o";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764316689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Q7NsCy6RBuBqZ6PaQhQp02x3+bSW+ItINduY91z04c=;
	b=A5suQTvZKk5szXH3tE2rLMq5Pr+F+Jn1dOo0dWmOZdnip0kIyD894E7/v9B6De34H0rHit
	5lqIiGQun50D+DHm1gEVf2QQ+0+0tv4dY0m64woP+ogUxt+ucjG6JFz8NJWzJiENekqalq
	/eiqi4DFBUw7T2tyFqgyHzp8Fsq/fPs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eBhLtmnw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="pTVF4t/o";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764316689; a=rsa-sha256;
	cv=pass;
	b=QSUYqoy/KDuIOWXJkSFid/H+05v+HRUmtRuHV6GqMZ3fugDoP/o2Wc8DinSNUJbvq4c5T1
	f2Q+82UzJBT05KOuFMFz8uFovLmHlcKnTXzPMFBucPMjAtfseaX9fG+nrYNf5pfMUlPf/R
	aX4V2ZYiTvJXgRE3MpYNtuGOTgwTNfY=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS7uVuk3069906;
	Fri, 28 Nov 2025 07:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1Q7NsCy6RBuBqZ6PaQ
	hQp02x3+bSW+ItINduY91z04c=; b=eBhLtmnwHIaB6aaT90i/NDKp+jIgehmZOK
	JfpisWNOqegkmkkzvhg6M7M/r7Grwk5L7w7Fc6kfVBKI0RJ2GuZqoeHSUglWoCCq
	VEeNLBIGiNIMwy3wKc1aMgp6xz9+tdWOT1c0XGft3DMA1EqnDFL4dsT21m7ZqBas
	q/51/mst03t7BJIRB9Mo2kTD6ryYp99ueHDYSDZHZHxrAWKMWi5brfwkqvNCaCJF
	/1VU9tWhswOzNlbMEspVh0oyNkmYgVjSKU64Nfxbtt/mUq2p4YH0Rvhawp1Qlc89
	1YM474N9HMkC3UkjCpO2YcA+txIW9d4TDgKD7w2MWke4KCcdZOmg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aq3m2r829-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 07:57:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AS7DqXM029626;
	Fri, 28 Nov 2025 07:57:26 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mghx2s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 07:57:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VrMNxfnzw9QRfKsa+SXFH2/1Tk5BjNgHa3nIJhzM1VFf6WjwVlGRYguNzIZcDG8vb4vdAiiiYgn6GVc9nVDQmiHxWgSM5qvp/Fqp+HdsciRKRRbhCfc7vVKBoa7w/j1YjWGLnzRemhnzSVvrCxWo8iyHPjXVcz/tq8WsUsgLcbS0M6l9gLf1sKC3KBUGva6hZrbvReQUoLIH4F+cmurbm1BNPxho4y55FwM+QVszv3LOjsN3YAil3vg9jf8c7dl4W5lY86qGmKbVIOjA2whQC9FJHmG3+VPQjBKwURWlblo8NGHed1N4nokGy5+BUgcndYwwci1X1p1AUjsxn6SvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Q7NsCy6RBuBqZ6PaQhQp02x3+bSW+ItINduY91z04c=;
 b=xvwhzC6/NQwRSweOxM53A3adG25RRYnHjDIbhyEIiNLPZz7dlaSxusxOcLNgT0O734lwpYyijW2AuE8UHUv/1muWXSbkkqsa6hl41VoiWfwTEWBKRWPFjaN0JGQqpN3YtAgiwNLCtmN3CRc1GSsFV2Eg1QyIM15XVhGlnCoZuESOfDs2Lcss/a1IvnePWFab3k8YSoD/Xx4YAx5Nr3Whbx8ufF6xn4bNAxStrgOMwhd8AMu91JNKYAdgXQ+JprZH+S2GaZ9yKKQE0B4Bzj5M0JVqvDvxwI9zrMa7bBjUttOewlysXFoAm2TUYNqOXlbDPp3LTUoY+0zwOt2X8yXilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Q7NsCy6RBuBqZ6PaQhQp02x3+bSW+ItINduY91z04c=;
 b=pTVF4t/oC8bRQ9W2+es/hVesa0geh2177XMCtWxZFa7Bdj5EW+dCdv5GS65REsxaQ4P2oX6PjR485LQniiuiNDBHXIbDLVtU2h5gDBCZaXcbxgwM5lmQq03AH6CzxHIOfbgpAkrcOotV8GzfTinxo5ikznnMlZTentYwIL7fXPc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8010.namprd10.prod.outlook.com (2603:10b6:408:282::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Fri, 28 Nov
 2025 07:57:22 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 07:57:22 +0000
Date: Fri, 28 Nov 2025 07:57:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>,
        Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Zi Yan <ziy@nvidia.com>, Liam Howlett <Liam.Howlett@oracle.com>,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com,
        Matthew Wilcox <willy@infradead.org>, Amery Hung <ameryhung@gmail.com>,
        David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Barry Song <21cnbao@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Tejun Heo <tj@kernel.org>, lance.yang@linux.dev,
        Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>,
        bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
Message-ID: <48878c07-6e8c-47eb-bc8e-13366c06762a@lucifer.local>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
 <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
 <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org>
 <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
X-ClientProxiedBy: LO6P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b6fc76c-18d4-4b20-5dbf-08de2e53c320
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?wBdZiMq3URyS5oymKaH/B5kGZRn3dQ0GG+oUI1iq87Matlukq1sRjVatnLGB?=
 =?us-ascii?Q?4NX/3iTx7u8VmllLlNWL2XQCIWWTAiQusqMlJYr0HPZ/k6sGnxMNNDy1CAq8?=
 =?us-ascii?Q?iXR1KWiB3R1JJw2Q2xZeikkIVdQdUBxs4RIGEvMBfY7t+j8rw/ajRqWkXTws?=
 =?us-ascii?Q?vcsPAQV1lIU11Y0iIkeP5D5nyaB8Il6HsllrwKu8I8PzffNFUmFllxIoBlj8?=
 =?us-ascii?Q?tLSpWj9YTC0vUBMmCQLU91Ilw0tUyNjY1qQSh4Z9EsV5YgzzXR10PrEDZw94?=
 =?us-ascii?Q?XteU98XmJ1JRx7fJTq8+9R2WUjVxRSKxNloEIa2MDVWIbJsFerPmTfaKSDxU?=
 =?us-ascii?Q?izH+CFqTUHvt4ebT+mDd4bQRMiD4jz/vmB88l1iXUrJcKQCqj8OpzRb2V+2L?=
 =?us-ascii?Q?B9aGXGvTqJX32jjoUnjdzvgaCPVrxw9CSX+YoTvt0RxaZP1aZJT3retgrxN7?=
 =?us-ascii?Q?uyDPO0KC9EIXIzRlVa82JC9+QY0hEmfxQYC2vFnn2QEKGoKq6SA1k4DskcLV?=
 =?us-ascii?Q?e8nRsnw0GULarDu+HT8r7OOFapMdUmKuCbzjwHWcp6dTqfq8jwZhcOSX3D2E?=
 =?us-ascii?Q?Hzy0es1D7ocvIEFSfTX3ztB47MSRYKBvVz8WG97HobIxXyytm4veN+IHm6JV?=
 =?us-ascii?Q?ZSAONYMtcsR+mEpo+tlQ4Y3eiV4mBKzkq+jCPiws4rg6s5NhnuBaLDXwMUWK?=
 =?us-ascii?Q?oxtQBCRrSiohkXZkmoqa16VQxmg5JLyPb0gbf/gpNJvlsMAW8TAmjYg6mkNu?=
 =?us-ascii?Q?zjN+/zcHFD1sy3ZwCBFVorHa8xQguPKkUHYz89vZEf/XWtCLEvzk3N7FeNmd?=
 =?us-ascii?Q?9jtxMZKkxTOTEoYmcgHy7ESSCD5UBP1fqdUO6Bllj/kDn+WOS/IMUKb6BnhK?=
 =?us-ascii?Q?k/cK15yMdt7wg9jSlaoA7IJIuRhWA9Wab7YWvpiYctLcoAEJp34+EHNHravH?=
 =?us-ascii?Q?0JaaqFKHFcMVA37PsDROkSv/9K9yr5jQBdCtAthv8W/sv76kQuQ2FTlBeCc4?=
 =?us-ascii?Q?XIEnQGouBhGD5HJH3cnvqsGZeoDwTc96Z4DnnKPlTwp5RZZ4uD90baXrEY8B?=
 =?us-ascii?Q?FSudf8BR+3aNdaDmFJ9ukeEQwdFuMW5gfH/BJlN8SlWqFuYgIbP3+cOZtdCE?=
 =?us-ascii?Q?Ag0U5G1/ehK3oS/C2Kjn7CAQJL92NOBLCsj4GvIWPyU3UA0y6nQ5lId8IhOu?=
 =?us-ascii?Q?cBRS7T2OEocZ4t0R+dpPv/dFE2/zgcF3BWcMIUEuIwVq9TR9nEMMtFBHuE16?=
 =?us-ascii?Q?gU4beDFLn3dw4tPaK6to1AJSXoeSGu2U885NIYhDgHmDlHxmIbJjN0gtJMK8?=
 =?us-ascii?Q?JKyzmSsNBAScxtXOE5dIX9Rkn0K68tLxStrqLvkcAOf2hWhIkxzs8UYVhzhN?=
 =?us-ascii?Q?55j/8fUwGi9nEqNJukeH7KqzHGW1KmzuZm5T2DPSIGZvt6pjNJj9U5h8mBKn?=
 =?us-ascii?Q?CSStcKjONpE8nUPtbhOXFpW94PrvUOXg?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?7QRrYH1U9Sa9d89YVvGwVO01UJm4ej9cQwRiuMfm1k2bvGVXSMyPtQlpJc+/?=
 =?us-ascii?Q?d0nUvDGVUqotFUqZBkaUoIqLrdn1miTdKGjcBI+5jcQRtf5M1ySRW4MmiLjB?=
 =?us-ascii?Q?iY9FCO6dX1VzoA+OnUNFZgtCy3wcY6yUKgBnIvHrk9mICWUDv0phgZ0pLWRC?=
 =?us-ascii?Q?upCHscTZlt3hqB4JbfFgrmp39IukxhAc64ZDfR4ijF+8Ftvya/bC718TCqvA?=
 =?us-ascii?Q?QKL2Uxd4vzDKOVyuZvDKD0nk1pWOKUcdxYw7Gq3rIGr5HmVNN1n90nQZ43vf?=
 =?us-ascii?Q?A1bGk1KyaST0Vnry+GUDnXvaX+EYXas+QNJWDfmfsVVi5pSrq4lv0eRKPoUj?=
 =?us-ascii?Q?WhaxYHnOGiKuCXFl/MBuO3TC9RoRO0i/rO0BoaMnAi7UOoBWKuHfs9t33wNp?=
 =?us-ascii?Q?kmC7t42WWNARE7pdasYjoI/4zozPGJy2v1UXbgXGQrJCTGwVUjLt8LxeXm0r?=
 =?us-ascii?Q?fmHVoJvYUeMCpeRho7j3k44lpKBzumsQBIpwgN5eHQlMkMaB7f8BwRg/TEDP?=
 =?us-ascii?Q?Buv/NbVFimxX8erT2ojCeMs906RyQUTkqzu2v59qfR0nUhuunWSxx+Bui5F9?=
 =?us-ascii?Q?BFYfspfxr7P5w7IyaFiWzz6OTJxFAHjZ1N5Ix61fzW9cOzcpD6norESYVxPY?=
 =?us-ascii?Q?H1eedqp+t3NBGFbAsjHA9+rrRn2SiS3NPzBy7zV0JtFnaDUZYeW5S7d+3I66?=
 =?us-ascii?Q?5sv5zUCNW4IFsLi1tEAF1Bi6+CTPtpj5To9couL5ZYo2mpCdZOLUaIaZpE1M?=
 =?us-ascii?Q?3ti/u/RpfoNhZUEBGoNGIZakLYfWIVZQdC1w0dosJlPYHPxS0qsZnaTpQ42x?=
 =?us-ascii?Q?1WHcCp2UcnM4pfAcsE93/PFLZO1bgrtY0y6+ZWo0et+hpYtQFGAAF7P6fpSj?=
 =?us-ascii?Q?1y3WX7SN7h1Um7r847jV2azVr+3B2JrteXpd3+ewrb8P+BM0ihIkyJlRdDlD?=
 =?us-ascii?Q?5waQcPC1PkwrV7N098YgFvLsEPrPnC3AM5fOhhv0f3CsqEqz0uWru1OwOEGh?=
 =?us-ascii?Q?VC/99fAjFWv0wGj1HVQfK6pst09fzZ8RVRhHq/EDsjYMJOx3dR4oMBscWYYI?=
 =?us-ascii?Q?zeiuEBj/ihLM3Fsts8pqZ6LLiKUDBJ29rwmRXpkha4VXb3I6y3Iz5KRqQT5v?=
 =?us-ascii?Q?Cra/X668eCG91c3qp+BrQ3u0T0CPqOqxZ7Ootl64TWAaouO//GGB8VwWCpuU?=
 =?us-ascii?Q?GYLjAiGYTqCEqDCkIpWP+D2UXt47sDT4xd0Vo69PaxDKNTv9OsLVyVFm8ro0?=
 =?us-ascii?Q?SGGrAC8fsAJ9dDA+BD1/TzB0q02BDkUfYYOp615tQShiAVvgqNf53VMYoG3/?=
 =?us-ascii?Q?qP//rlipLzosX6xKe2QXkcU7ENCXqd9yI8qQJ21Uyz4Tn70DaEos7w7YeOon?=
 =?us-ascii?Q?X60WIUkBWZjVIuvWJH0/jd7QTBVcj30/7pFn2VY97EQHT+Gsut9Q7xwKtynT?=
 =?us-ascii?Q?uFRXDRaAjYxKe3x63UnS6yEbJo7hSAGNDezkh+weVKi5KgIkaGAG9ruw6hbr?=
 =?us-ascii?Q?gOcbIxpoG4EdAKBFx4mqiw75bBGUYNtMjdJDvenx+wUg01d0B1W9DSypizXS?=
 =?us-ascii?Q?npt5lgerj74I7rnBpV6g+Ikd0dG4eZV6oBAFeXy8QiWVbbkFP+droYe9m3j0?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IZ207aS9srS4MAhJ1JeenVfqYw+TflpY0D5ND4D/xE2LkezEetoIJYJ0snEsyUxdWMGZfdUIF2Cigwo28SMilSgSqgOzNlbHfBFX4BLhMFvayetQASfiNC9d4jVVywsx6YmhwqDKEnTCoxhnR6QHhreczcy5volQPkC8vEc/krGuddIOJ54Loqds/QJVdUq9iUqjtrE8eHPZZ0r+T7H+NPRSAPfZc5uvfQZwCo4gW+N6HOWg4P0IrhnB42/jIimwpYte78mcjWYQ1VsZEA3GSmRWnaFIKtMcjOxrMFAd+Ea0B+xmnw4RzgNdv5QXmL7H8m5k9WAf4YWtJUwxTS+yMWfoysmZjXsk08FuDK4Ph1lESfF/tbCTcD1HaI90BwHHSiAchVZiWakzcovR2EV++krAINWfhiQK3c2b7MgFbsPQ+dsHzwzd7L1qdaKPUI4DsjJoLvy8FZpmRxIZ47JU/hWi4hctSIIvkaQQx8tbwOvW4JoI1217Yym4Kq3IGFVivP+yseWnQ+XyGhjWFSy10Zfd1A+5UbOaREc/P/iddHw4LFc9uyXKMgW8C/N5bBvoNuUC7aqKetSPmcPDTIRFJk9AspV3fMQUQDLHCL7nblQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6fc76c-18d4-4b20-5dbf-08de2e53c320
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 07:57:22.5047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zik5p5v8GirY/MEPaG5ynio29xDefMNKPb7GzT9zltJmq01IPhHxX5grZblpWWHFONdDAIlYCs65VTtyOPNWYZv8uqNgqEt9i2nvaVt/FkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8010
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511280056
X-Authority-Analysis: v=2.4 cv=adVsXBot c=1 sm=1 tr=0 ts=692955e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7IJZ8jyyfDX2mOoPgkA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA1NyBTYWx0ZWRfXxA8ftgso7lPN
 sCIuQgbG0ImFEzavEHqYo8LbpVhGJ6BC3+XPCZsG5jPuOrHaaHO6xK1BDMiWLEDb2JU+EiYiqH1
 JiahefUJu2WEfX+/2IwjwGUo5byEGIsiwan0dSMPX1MAtZeSk6wLxX8p9dTwNqmfdL+vrb/pah8
 KVKZAULNHgFrJUTWuF0G1O4eTBkPaZQ1v+EYtog0YEhztjc54olR3JwDzZVWCxZBEkjfx0qA+pH
 nWVKDUo0zSlea/oEuS6I8SxJpPt6aP9E7k5gy5jEELNu0Y8i4lc0wxmSsB6YK82QcU9fIwkST57
 L8I2dUA01bkY1PBfWTkuDWnFPeOFkvfEDaN+QI0OOdxO9jGcY+nsn+/a3hRD6oa7yUc1beuoBQc
 vqFBSW8/APcGpKZSx+6mGYrLJeiwSINmVT5q7Bd+xUCajm2i1Iw=
X-Proofpoint-GUID: LWWPDcy5ioG6ykP4O4JscOWjrh5TciFY
X-Proofpoint-ORIG-GUID: LWWPDcy5ioG6ykP4O4JscOWjrh5TciFY
X-Rspamd-Queue-Id: B9354180004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: apuarekgcozdtsi6we11jrom1nyztd6a
X-HE-Tag: 1764316689-62120
X-HE-Meta: U2FsdGVkX1/BfbkwXgh/VNDo+ONGHw0xnrT+OzbUG0Fi65z/2z6M9opVqpaFPHA8lvYnQKa2iR/jnwuPUU2LhsyiwNqVerBH0gZOFZDJ5QhLZ/jv8mL18SgWPX8SbcTfvhMV5mgAfHcjIyeHTAoadEW/gq0RmGtB2m6/1D5UUshjgHyEwLrGTkr/N3KZpwTAduEP5B+Vybx390IWbpLfMpHiQl7K69UlKRSrEx/iRco2SztrBnEXayhEk9yNUM+qvuZXPrrguUQ3nuFfuR6lC0RMy3+gBbxp3JJOiJ6Mly8f/5vLVjUpusQw6VObhCkbfj9a/TU1/H6gplG598yxix/MJ/YHpqvcFAfT9hljwwNpZWhpQk004D57IDpU9P4GAElHd0stDW4N8t5BgsnhnMZQ5pWKEUN/MyiTk4PwamzIxtUtfSiq37G+FwZZY5eL/FdpSr55QIO7kBraOfk6swbTARIFBdq634c7ah0kdy+8ZAtzBJeqH4G9o4FG5a6RF0rV+XUCBCoDzY++4LZhfalMKMeBWdUyPv0iD4HkxKpkBkRPXsRuxKcXxzBdu/tMgF9vj52fvqyGdLYZZawF7crxdYV7cTqqn7qIcpQGD+tKc1cDXXPkah6l5EG99XHA76sQe+6s/J9p0uHs1I+z2X9Hy2WigrKQOmnUHjnhmkip19Pvhu/NlwaImTUsdKEqtTNMrdu9NqXA+ZB/su4/iTY06ZRCS4UgFKBgAN/FWLAcPfqlWJmyiou7LnPEKjhEsIz9qQ10m+sOKH9mYg1hjIK5CC/5Ci8sJBtqSF+MKgdP6sEfAcJnXrnNCs8dvEAzeIRycx95PD5gRT4WcfibeboMrJrtQB9kQjM7ZSRiemvwxRnfjrDe/hjXgWwf/2q8hhkLhhQPFpbuOBVc+s0xaggX2dwRFttCLLKNXYD+RNh+TgnxxnYhQBPQEN0ksr3sinH03F4YyGd+mEJ9YSu
 6YPRYNzN
 kr4dS5xcL1gW/4l2eCpYDrDe9DJ3FEgBsbS55mWEVzMQpdlFy8LobvrhZFGeinJJsJo0bON/b+FbkS61hIk69xlAitjMGYLOH2LZh7tIjjBJKHejnUwfyzjGhBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR - NAK this series as-is.

On Fri, Nov 28, 2025 at 10:53:53AM +0800, Yafang Shao wrote:
> Thank you for sharing this.
> However, BPF-THP is already deployed across our server fleet and both
> our users and my boss are satisfied with it. As such, we are not
> considering a switch. The current solution also offers us a valuable
> opportunity to experiment with additional policies in production.

Sorry Yafang, this isn't how upstream works.

I've not been paying attention to this series as I have been waiting for
you and Alexei to reach some kind of resolution before diving back in.

But your response here is _very_ concerning to me.

Of course you're welcome to deploy unmerged arbitrary patches to your
kernel (as long as you abide by the GPL naturally).

But we've made it _very_ clear that this is an - experimental - feature,
that might go away at any time, while we iterate and determine how useful
it might be to users in general.

Now it seems that exactly the thing I feared has already happened - people
ignoring the fact we are hiding this behind an, in effect,
CONFIG_EXPERIMENTAL_PLEASE_DO_NOT_RELY_ON_THIS flag.

This means that I am no longer confident this approach is going to work,
which inclines me to reject this proposal outright.

The bar is now a lot higher in my view, and now we're going to need
extensive and overwhelming evidence that whatever BPF hook we provide is
both future proof as to how we intend THP to develop and of use to more
than one user.

Again as David mentioned, you seem to be able to achieve what you want to
achieve via the extensions we added to PR_SET_THP_DISABLE.

That then reduces the number of users of this feature to 0 and again
inclines me to reject this approach entirely.

So for now it's a NAK.

>
> In summary, I am fine with either the per-MM or per-MEMCG method.
> Furthermore, I don't believe this is an either-or decision; both can
> be implemented to work together.

No, it is - the global approach is broken and we won't be having that.

>
>
> --
> Regards
> Yafang

Thanks, Lorenzo

