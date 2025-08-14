Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CFCCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCAB90010B; Thu, 14 Aug 2025 03:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D4A900088; Thu, 14 Aug 2025 03:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE70890010B; Thu, 14 Aug 2025 03:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A86FC900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:59:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 742BE1DD802
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:59:04 +0000 (UTC)
X-FDA: 83774612208.05.23516FE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0065E40004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:59:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QeM5uQTh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VJILg1yQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755158341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUqqipyVbXIwfu5AkaFzSJoUb080FHOmRCc47JvPFQg=;
	b=AxWmJp2LBYwEbSbmHmL12SrbtEwZiLM3T5/4xzPHT+5+/8jY+CkK6h6+T1nxSaK/fFXOpy
	cIoXiiHi9vOdQY9S9gFVSa5PZL5nRYZ21GUAFbD9PRC4zDsF5kD4czL5kFJlnPMEsd3qTc
	DrwA+WxZyU2RUW6t6mOsIbu6EVsmVUg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QeM5uQTh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VJILg1yQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755158341; a=rsa-sha256;
	cv=pass;
	b=DqCcYcGSL5S9bPfmN8wT+kpkiXoazbND43AqBTuvwAdkCSlw0Jb8O7iNlpBohodkusefQ/
	Y4JcWDG1fyNI/mW8oAZ4OS3FHvs35QfmLQ3h6J2JxJH8iLykf2oCK9cHASi2SOZqN/s3rf
	0KuHb0SUP1VfV4vgR2NMdzqP//t1AiA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57E7u9rp031520;
	Thu, 14 Aug 2025 07:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zUqqipyVbXIwfu5Aka
	FzSJoUb080FHOmRCc47JvPFQg=; b=QeM5uQThf8KyOSlQQLKmAqwGtTnkbkep9e
	csNwAabTkYepv8QAval3qeWjA5T4XYEKWKuJfQbbXQqB9MZi6dMNAWJitJ8NOqO5
	byuC+RuuCPjk9N19V4D+C8cIdrfTPRvIcu10o1tzecP1FnygyoGrBEsUBTXSRdj9
	txqNQI4LYGvg4tKY4Bi+a1I6d+NpmDKPhXgs3VP8SmgXR9JFqLn7cMFBGC0hq4r5
	+FQDruFOjI8ELf5QUkpuMHA3bUR5twEmnijuEGv4zXor1dBW0aiOSORWazSJxflP
	tvdInlZtbXOGVTjSvjfI9HZSc9v4iFDDbI04ZAMCwc2JevTqRaaw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4hb8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 07:58:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E71PnH029998;
	Thu, 14 Aug 2025 07:58:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsce48t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 07:58:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rD1yFRVQ2YilPcKb9i8wo/nh9rXFEMN6t81D1LGKT8x8/ScJ0OrRcUDBCzgQpoiUnR9wB3i+T3eyL/JZv0ZofH+tKJahIdq43THovIwawxVCT3HYY8WGrTKZ3h/yZ42S4woHiLDnwajQKeptOre+z+Ya8eBQ5fuMj4c6dpr+5V9ktdwrL36DSRN5FYlCbf8j7Ljubkoaw4mHwvBXSd0eU6KXlB9Miwv6Wsp1XpsRUUozT+QQMrMFzORb1+W0T7Sg746U7S4qLUcZuWwn3ib7h0im3d1RQBBAkXr/KEcuXufOw+JLt6xjjMbKRlT0uk/XZ30CdKnVP3RxvupqT1Cdmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUqqipyVbXIwfu5AkaFzSJoUb080FHOmRCc47JvPFQg=;
 b=SYBAWcEP8eymjqzwiM3To8pGWW/YTMkuRodPHdVSXy8+ZIim/dEWWT4kHuu48jS9vJGCrbde/mDatf81/kNjNgCOlEG7x4KmsgO8zi5vtpph53AEK0Loood7ot3v5CzRpN9WVZTMbmaEhtDcbpxa13COktWwdLHwVBeHqcukEWl46ojuKOjur/CbVZnW2sipjC8OeZWrEr9PE5JeVUhZ5q5GmQKTkLR0ehpbrmhEkRDiZGESGUEp+RSFa1+Ucj5STv4yig+xceXrvTaxNdNRUFFb5ciFAhBRLbZ/Q3yeRFgfrNmTGrIV+NmrE2ON/2n2CUM38SofPa3yHsCPtHM41g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUqqipyVbXIwfu5AkaFzSJoUb080FHOmRCc47JvPFQg=;
 b=VJILg1yQ4SqHZgjAehkyS6Iq70wVXKpOZ/E9OusAilqLVjIic/11yoPHxy5AORW3Roq+S2z4M8U2+5+D95P+Tr5698nNGSeGVwKGntYurQIE4gdLnaOLVEEhNdOyNqOpPcBF4PqODRUn9CIx7Fb3RLfpmQz54nhjEucyjBfrip0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5098.namprd10.prod.outlook.com (2603:10b6:610:da::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 07:58:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 07:58:51 +0000
Date: Thu, 14 Aug 2025 08:58:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Danilo Krummrich <dakr@kernel.org>,
        Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
        rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: rust: add page.rs to MEMORY MANAGEMENT - RUST
Message-ID: <b42620fb-42a9-48ed-b816-21c08e401aff@lucifer.local>
References: <20250814075454.1596482-1-aliceryhl@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814075454.1596482-1-aliceryhl@google.com>
X-ClientProxiedBy: GV3P280CA0005.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:b::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5098:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a132419-32a2-4e54-7751-08dddb08689a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EeUjYCEc/k4vysFn8wz4Dfv4ysqk+EldlaqWDDO3KnCPMYuMOU4uj2C8Ttuo?=
 =?us-ascii?Q?o3l6fWROHaa/bndYL3xxp0rLaeZWs8pEo2OANkL5O+4/6HRfdi+tXLyCD8dx?=
 =?us-ascii?Q?dKkj3TDHp237yzl69Luq7GdwnmFKfQAXarYtv5e5S8QuM7GO+MO4Vr1FXmtA?=
 =?us-ascii?Q?R3SyAe20EV15Mh5zwPB0lvJx/cviLbjJSYq8KJf1nBYNX5ZGmyOMAQ25Rdwy?=
 =?us-ascii?Q?X/o+czspUQfK+7EozYLLon4K65OawfYvOwz9/BYGiEm/Z5sGvxGzyzeVYi5R?=
 =?us-ascii?Q?2o7rnPeJ5ocyE3KTwB3qQ0PXOjx99YsSBEt625gbqlWXeSDX7a1pobP0n/q3?=
 =?us-ascii?Q?WVDH9wbXncCX/+q7I0mhxGi0/cNwVgD0Kuz2dvNTKVNRfbLmqp6tXIH/Zdvp?=
 =?us-ascii?Q?rOU0jkHi1bBXK86YkdQQrJjR67VXCRZ05B36bxTF4GQWGfPtLSmkLfpFWjV2?=
 =?us-ascii?Q?99FwHTuDu8oUuHf3+V0kJ+kublGauSn+gKttZENQzR79n660SXPv7t/P6Vy4?=
 =?us-ascii?Q?bWJo6sIO0qCYPeb06fRQKeeBcROO2XPKaGW32jWntsJnhW8E7Zvzb1XppGGJ?=
 =?us-ascii?Q?HDUhOjVEl/ltxWi87gA5hRMFtsO1VDOz61HoZCxWzZDLyJkTBzWU2YL2Q8MU?=
 =?us-ascii?Q?vUGy55SisNTEU3Ank6Mwd+G9+1kj4Vo2iX3C7qxKvNpESwCyrrTZpXS6exye?=
 =?us-ascii?Q?BptRNStCNwALszES7uDROjKwdaCf7xxHCsP9o9o7MXHkt0o7kT+LcZmr1Y/8?=
 =?us-ascii?Q?MF9f4R0MRSv1vqnp96dr8KwXkxaiSrm9FkuO8mCpOemn7E0HKUHvewoqHkt/?=
 =?us-ascii?Q?ghriYHzOPvlCg9akEtMoMZIXbWKLMFVwV+xQuVOizu3z9zBCplOoK4JeuHLW?=
 =?us-ascii?Q?fJHhOslzVIhiRZ24PaItk5WnX1kgDolT6+WDLEVftWuGergzH4nTX+FaTh9i?=
 =?us-ascii?Q?zaVC1tCpkkvFuDvzlE4KUPyLDKJwUjbG7WcVg6ue476YaGLlNUDZv1vFATxu?=
 =?us-ascii?Q?pmPlIzn2xbtNa+2N0yV64n2ysx/uFZ/GF4nVOvwbR0B6DRucEZFHjNrFnG25?=
 =?us-ascii?Q?BJ7Tx9SVuXImDHyE0pzYEei1QenwUyW0ZcAzCjsofkI+YTX8ivtpqRKJcJCQ?=
 =?us-ascii?Q?4tVVd35xoyLZ6iNc74hhhlqgbocfpUVTtZEqgmr6di29B+C1VV6VnSA8Iq5S?=
 =?us-ascii?Q?7BBdjr+fq/T8rGABV9ZkivAoATYsn9tnEM3XTYuAwgy8s8vHDlXcpw3OI6XB?=
 =?us-ascii?Q?fz2RzaDg1iE5PJ+zEC5fv68SRR9wJs399cszjzWdiJJDaUWswO1uk1Ivgmmj?=
 =?us-ascii?Q?xxQP0I3p/I1YGAjBalKElGtVgxrvbjpGhH53UHwVbU5cleLR4Mcsp0pZuMGC?=
 =?us-ascii?Q?Thid9IQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nznuNNgyntHXmkXgR7rmD2/85eKzWMxpoDsb6JhNXr4/hRxUjQP+MYx8HBI4?=
 =?us-ascii?Q?rdinbVY5sUFegVaoIvmx3jY1m34zxcwoS7dKueI+dvJEiIyL61i+OINqG2M3?=
 =?us-ascii?Q?S8AcHkk6hE1NtU24ivwVCdURbPA8srj3n54+YslBtBRInM6iLRvU6XBb+wqc?=
 =?us-ascii?Q?OCCqDTJrJudxRlhyzqXkKoe1mRWmRlHB66fFvKfwvzgRvfI0qNqSQqOU4WpO?=
 =?us-ascii?Q?MSr/fqCzogmhpyQLKSywheuPbug84/YwdqB0AYO+GQWd6SiEvtYRSm+pzJ0x?=
 =?us-ascii?Q?F3A/KvBy4XKzjKh+LbVwLEKCTmCJrrvujXSNEvyrQ5sKDXBNjhiDKB1WI7TZ?=
 =?us-ascii?Q?sohpAgNlH0Kg9KXLwUqIbRJKzxaNJwAt00rDLl505xl0pgFUEOJnm0l2zwxT?=
 =?us-ascii?Q?FlY5daegttG4Er2EpBli/9IB5KISNOgcWoz8TFZ3hoso+ecRVrMxUv0sK6QT?=
 =?us-ascii?Q?tBTpQ99GnKi/CXT8P9ufGFGngSRJldRX8aT1GLld+34lG5OIRWC5yGV9RLLI?=
 =?us-ascii?Q?PqdGThM5ZTL1TvANTZ5FfWFH2l6AWCIjv9NeWMa4S+O6OGg7egR6pM905n3J?=
 =?us-ascii?Q?4o3CrjgzURp+5uEXFfwqjOZjZjsAeFnHCYDxpJNSOdhrx6DzSELAirGM0RVg?=
 =?us-ascii?Q?gCJwU8Dw90fjKYH1yKUs88iwIlFza7n5/lB2khm75KTtZPFUQ9pEzs49FdCn?=
 =?us-ascii?Q?uP1YxG6xN+ZZv58ZFH0tlhgRrwIMogtWz0BgHS7ci4ISj0cw0jOaBfAouSLd?=
 =?us-ascii?Q?vqKOZAVf1f//TzEzNfPyRbWu0MehewZ4+Dq381PHrLbvbsup0SPESgWqYs5U?=
 =?us-ascii?Q?IBt0LdUhYIlBDE4LEle6QR5SyRZVqAYETlFFwXpkwQLiMcitHkZlz1nyIDeh?=
 =?us-ascii?Q?mb6kLNXtPQp4EOkXojrK6OGmgLeg9D5j4HxGWZLP34uMVgutn6Ejnr+dndsu?=
 =?us-ascii?Q?7xliFBc0lgSld7D8zq9Zobhcj83FB1sovyzLMK3aG7P7DrCysDZbkjNKXIzB?=
 =?us-ascii?Q?jg0KGk2iUcWsLOXgzO4oBe/3JkEjzdBGRkgagOfxt9hy1LaZkM7xkRc9L2Ve?=
 =?us-ascii?Q?IE+33MwDjQtyQ0rlS3sAsc3OQAJFi90OFk/9tyDDlLwKCc6lJYNQ28YP0Yc3?=
 =?us-ascii?Q?jN4IwyQ+an1M8XxmZahVEfIb0yPpaQYOF4a1wMF8zqG6txC6RR4S52Pmn7Fu?=
 =?us-ascii?Q?q1ajN6DqOObGLOXCezXh3vhes+T1BDegcuEhLYOmxBEkgD0CRvgFnjlIccuN?=
 =?us-ascii?Q?iiw3TSOjy2H5igJbrh1xakCUH/WNGQjgpPtvrtuU1kCiXk8+MV3f1FlqdpUU?=
 =?us-ascii?Q?3kSvNfI4cBTwq/SAWGGo37PtNnwAnGepF1tWiszYdfoRbh4obILwFFpUiCPn?=
 =?us-ascii?Q?K0CnJ2N9TCZdOsK5eDV9HbHvIW09CGYByuWjqQnLe8KSDgd4oL9ChWy1JWB+?=
 =?us-ascii?Q?JHEhocM/016w7aS9uyhVwxZGr3utLuqUiwQpVZNIpfFlthVHc/gTHLxeBva3?=
 =?us-ascii?Q?I8YBC7fA5XZzACOOUOUUXcG2PS4CQRo9GdUTJaj7fjMCj1jWw3iJGbhpUemx?=
 =?us-ascii?Q?F5Ny426wgZYLCXK5M/5prQ2Ifk9zPinXn/s1R9MHZX1cmuEIhyn+sE/8jVAB?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kF3OR2eiel7EjiVaYGSSUUKtmsRCAIf8g9DAYY6aqB8pGLFJBsmCatHY1KKMfWDK7938UyBMg2RgrbPdLLoOEZEc+cq5sgXkwz4wbSoE1UJ12Uin/fHJ91yedXbuFkP3I0bipjHKxoZApUM992V9OiMIk/Q77ozIkPTav/qHtTd6tx+VnAwDQ0xpolI6D4THE+nfFUJ86NPngNcCJbEeNFqcSs2LxQpE6cdge6sKB+DIFznyUW/TYcEG/oJbFqt8Xpl1H17ltvatirrWRbG9MhPJo1OS4X96qpu4P3kIrIn7H7JyePfedvek1ZKy+a/OyfDqymwxeZwS/4EydLiXHM+bslBq7PS9AyJUN/D+4gHkBHAEgrLS/TgC7cwqVLGxLl9P0G9kZwjNjME6fbfsiiuo9lmb4a8FcCnNCBWrFCjUqLfERQQPui7qMtMitnNwUpKX/IBkI5G/aNqkjhwI0NKEi2LdJOVrXTEpGyKpM20Lk75Mhx2e785KiUkA/QMqR+5hPvZldJPC0lSb8XXU2rgCly89p2Iy/IGFscy79lkRoNED3/6ptRppaO3qnVEDI7+mhGtu7SLV3hLz6nqet0nwO958LomKb7gZZ/B9kmU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a132419-32a2-4e54-7751-08dddb08689a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 07:58:51.8278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CTp6mzQDrLJb8qV6MvlUul8jCq6gKSK/NXSwRx5evnLM6DkySScqkty4Y8Q+b1Crx9u8PJvK/P5IvQmoaHCoiGxmSaVYD9ljW5aqVHbnpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508140064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA2NCBTYWx0ZWRfXyWZXt87fNdYd
 yevxoqQjqPJkRwWCKx8M5Y6FwZA5oBFseftrNggygI2iql9uJ+yMDLiJMygpo7R6mb+vI5I6TIq
 hcHbwFeQaj84jAGOOfHVAI8FI1lJTFGpkKz26FeRc3Pcqcj6e9xvK7pY1URD6rDS+pvExg0Zhc5
 GTDB0u23ETkC1iFkWXtW3dtpVGFuG35F+y5CSzVm5LP1KGSy+OvbSc2cAVAMkoDY3c2hPU/6rXn
 6zptopFaDYvRpqojbbpH67Lx+MGQN7s8+whlawbvl6QLl0XK/yJNp0gsY+mB4SckYJ2f9/qROg5
 w7YjA6aBU4ZKy0Nxqzglk3P1zq8qVBgh5/wu8OqgonuvYWUIrjBt2t6ntpqTL/3icFU8sbr6/Rt
 aAZeBYGVMf2mozHYSBcyzzWdhD539rRnD+Yb6+uRdTWic/kmknjlENuCvtjvHqbt+682g0Sl
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689d973e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1-S1nHsFAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=37rDS-QxAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8
 a=WaG9-Ayan1ZUo_Gh08MA:9 a=CjuIK1q_8ugA:10 a=gK44uIRsrOYWoX5St5dO:22
 a=k1Nq6YrhK2t884LQW06G:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: FCQnPqnjv-PNo4AE0w-UMiSmNf7OH-v_
X-Proofpoint-ORIG-GUID: FCQnPqnjv-PNo4AE0w-UMiSmNf7OH-v_
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0065E40004
X-Stat-Signature: u5qc8sfubu5tai8n6kh3db5ot79t6bmg
X-Rspam-User: 
X-HE-Tag: 1755158340-514329
X-HE-Meta: U2FsdGVkX1+F4GfqTe6FJhMAMyscUE8gisZReutwap78njvT41S4Vu0bw82MzWGQXHNdnYe+EEunUUY4FovRX4qSeu+GqbNk365lDkvD5EbdJ5OWjv4h8RHatyfli9lBsszE9P+UcgvNyVuqbJSZuHSX7ETIDI89hfd20eNWrg6lx6zG6lmCcwuwbbn0yRV5oqhCyLt1dQhVPNdNThzI5DS8fDz8ey+UFKEFkr7kJHULpIJnBif7w+KmBdkWBlfWviUnePYENDohnT3CmMGiakAT9AncdWpTKTRgMyPyXQm+hsxsX3r9TI1K6/iyqyoIFFpj3PRglbUNW5PJKnHCITUS1TtAVg1vBLC+35L1bbyyFNKrDpf8h+gTN8SJ7efxI2/SEfihJPVj8PA4I8mp460E8twCWW2o1DcG176XDqJgT26IB3P1FEmZej1CNFPkSZZQU7k0aZrRvZr3Shfrkvi3Orxn2h2mnDORx4EkaHDX8eMWixCTj3PpoBQAm7/GH8Vh20t613VyVpt0NTeMfjQampsdNPmWDD5yKaclpyRyH3xIFBvqflzduv8crdhLLircvZl0s498uh61scFAKIMekZWFYaXZGSOFpQ/KM+D3DkAuW2f9SBUsxwNQ2QzdqVEUPr0NLxbiAU1wo/3ScczN7m0Cikn0jw91X/jOC4DyNtGu7pLWt3HmCWMbVep241V62nBZViBJRTzjH9H2RHehOl319FL6oTI/ftVJZac/YFvgS9xhtNjcgZJBiOarIsdYwZrmPh1uAngeTs4yU3YYlp8XKfd0xzD9kLZXtnXkxMBisaavlMEbuzpuJE8MHMsQ26RXt9l8LNcdHaklnWBai08Q75jhJQQQ7kqwazrtMjkIiaRSnOTx0KARD0AqoW2Q8jjQBD+mIwXNXCK+qaS0eYQg1oq2yZ4lks1uZhFTlRwNl52qvaL3nuMmnLze3p2A9BoU3rs6BjwI/AX
 cnb6lVed
 /rTm5RbTWtc7UjNULcSgWHdSTc3XO/FCKaPl5vn4y2+EG243pLAFQH4hDSNQ8bksx+CPJed8I6v4ELuKCaBSQqQp0rWguMWuzLg4hHq96Y7+Dldtb06+11SPFuJE9rg4kvvPJzzbocpFRMq5nC00eJ0MkFG0kJVfhm4FTRuykfVPFematQe3ojXwmnAOomZoKlipPIUFUcEzHgnW+nJu5fln4vAHMOgDfk1KJinJPV9kBAdk1PWP4OQa8dzhHuXtBMJcz43la3+Dd7B3AThTjubuK1XIhD5BCkv9fthKUJF66I5GvkxonAr7VtfaEcT5Z53XKN5exE2Id0DVwwI26FoIULryvJHaxajOwQQi8cyxcGtEkXjC1O0sRmaiILcxkjOSZoRCKLuokSWuLV1SFs8CUmKL3TILF4D6FFMD6OLDMZL1L3AOmL4IX11i8biswoGKU6rDUVP0YzjUapZkuGJThLKkjzNcmIkC832WpF/U13wyLCqghmXNLEza3WS6ao8bXY1O+hNkaZp3ZJURz0yDyTMRkmTVOy0vNo3NKgtQcRxw0mwQDZw55N+BTnC1cXL01+17Blpn3oW7V5UAlZvyXXlKQLOq9fvevMNfBK52GURxcY+ZunLSyaHewqmPISLjmnVlViWBg1Pfix32V5FWQN1KE0tr/yNsS+zHkBTo02OmwkT/RNJSul2TVErGNeyZPR1vs/XfNR2PEHfYg3F4kJ+NjwmRbX2hOgpy4uH9H2VquEttzWtU3912itNiYVdoZvJTLeTdvozDkEYOyzL1VzmXefNprwyX7IKsQtRhqp0Tz2earABlOZ3IBYyB/cunBwuSi5sVM0eUvGY8Kv9FPkdadODZU2LPgXZTFd+72MEBYfLGwzHlpb3Qv8kOBCSo/2/5U6C6AQUb5qxdukY7QQyWP3M15ioODy04IWm7vU40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 07:54:54AM +0000, Alice Ryhl wrote:
> The page.rs file currently isn't included anywhere, and I think it's a
> good fit for the MEMORY MANAGEMENT - RUST entry. The file was originally
> added for use by Rust Binder, but I believe there is also work to use it
> in the upcoming scatterlist abstractions.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe168477caa4..45f7a21dafd4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16244,15 +16244,17 @@ S:	Maintained
>  MEMORY MANAGEMENT - RUST
>  M:	Alice Ryhl <aliceryhl@google.com>
>  R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>  R:	Liam R. Howlett <Liam.Howlett@oracle.com>
>  L:	linux-mm@kvack.org
>  L:	rust-for-linux@vger.kernel.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	rust/helpers/mm.c
> +F:	rust/helpers/page.c
>  F:	rust/kernel/mm.rs
>  F:	rust/kernel/mm/
> +F:	rust/kernel/page.rs

LGTM!

Apologies I've been a bit quiet on the rust front, is workload-related,
hope to dip in and out when I can :>)

Glad to see it's all moving forward nicely!

>
>  MEMORY MAPPING
>  M:	Andrew Morton <akpm@linux-foundation.org>
> --
> 2.51.0.rc0.215.g125493bb4a-goog
>

