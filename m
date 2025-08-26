Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AE71CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695AB6B00A4; Tue, 26 Aug 2025 05:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CF06B00A6; Tue, 26 Aug 2025 05:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534A56B00A8; Tue, 26 Aug 2025 05:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC576B00A4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:07:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB0F413994E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:07:54 +0000 (UTC)
X-FDA: 83818331268.13.0DEC6E2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 80C952000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:07:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F+p4ZZMT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XprvEKkF;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756199271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAaxcsuiFvUy+NP4INf8Y7BXxsdBEevZZB6+c2hzW9Q=;
	b=0M30yhPMJunUMAoyZaZVIgqeeyRprQITPWfdhqaX+GhM6y7G+Y+/LU2j+Q/Xm/1QfIddgI
	IeOwyDxvD8GQOszlGBDnEsPcQr3tab0bwN7O/LRWM1PtxRSLaoiHSVd62JqPjwKcn/vT6W
	39dfE7Wdu986JuJFhH/9/C+cswpH4Yg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F+p4ZZMT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XprvEKkF;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756199271; a=rsa-sha256;
	cv=pass;
	b=GvUW9OnJ/WdVJ9zuMTDeneghG+jWDhz0I/RZbJfxPGW6D4Ib9XvNGjrMnBBe0nQMP85LPu
	G5lC1uJd5CM1PQz1+GEiZwqEtKzNrHcLqjAZVakWAr2Fh5q7pU60kW/Wfkz6ard4tUaz3i
	Hs2CUU96wJw9Pt9l8GU4QBWsonXHIXI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8mBBh007090;
	Tue, 26 Aug 2025 09:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HAaxcsuiFvUy+NP4IN
	f8Y7BXxsdBEevZZB6+c2hzW9Q=; b=F+p4ZZMTm5+cCOP6RvmR0OWWPjnjyFfJ1n
	9Q+KXov6xPXybeTF34TvXESsLGXBiEHWgMmEJoOwGMMKvLcU57XwLl+P4f370VBd
	jep68gqBHlRHBMr72457ax3OnzViiJWuXSfNoqVUiw6sJWQ3nbFVzo6jixl6KNe4
	bpW1oVDGaVBgOn4V8h8R6guwju4It+u1zdpWwBseIGOotZnf+vpSo6+pOp3+l1Fq
	V+bsFKFA7l4IAJ82uJO3q7jS6UpB7EpO1Dyj9mXDaXVurU81hOLY2VjQzbFUHa5/
	t6aQcmOF0Rk7mG19fmq7viLbwkcXOFQ6Ig7vsv+dbvAV1XInF5QQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jakydt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:07:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q7vWJ1012167;
	Tue, 26 Aug 2025 09:07:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43997j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gVfs+1hqDE3UXTRSuIY59I796P2TVWn7amslVBKStPxtBhNAHmLLGobMawMw+7NKr7YeRWCNNxYuenkHQBmrxAE0rueQVFUj2aZVQz0QtiPROiIRoIcfv6te0ZAZ+KT/h39CX/ust6WI02FgQ7GLth28ld4mQnFbDnjNYj76/J/0ehXvLJQsvgfU6fgK/1VkM5jnbpH4yorYaaLSssPShanM/oBRGRrfNDtboie+Y0Kbu/nr6MHiKWjWwkijKA4QqZ8A7fIAnUVPTTtNpNy3021nd4FjFCqIMhOH7Ke5UCDmCdv6IvqXYkHKWFaaVkEtYT8x2ZFJVDAKxvUyHi4rsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAaxcsuiFvUy+NP4INf8Y7BXxsdBEevZZB6+c2hzW9Q=;
 b=f50dF+hmrSVVb8Q7sUOUnlgJmPaZSY3rhG2ifvfUehdYlgOQjeqaPNcIprHjqTlXxPn77N9se96zlXm/5gl4MxFWMd8gwnFODkwZCJRVjQjowjQA4K+xQ7v140PhCcM5K3Wei1gQJWBvE4RJHxFfF9wU7txwbtANq5JhG5reAl95f0dqmxpc+bprCY8zizozwXAfUmeVdhYUV9QAj0QH5/r5WiCCy3vQ2uVkWG+WSSa78t4evpuUky/Vhmi9PkUV2W8bYLg9jSNGr06eUxkCHxdfZEhY4LmhcW3xyxiIq8Dm1/nmIl4aWSjW3hpgzz61b1FKDuvvZ9YMMMSdmQlLTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAaxcsuiFvUy+NP4INf8Y7BXxsdBEevZZB6+c2hzW9Q=;
 b=XprvEKkFYPE9bIjp2PYd6JdD56SgkjFcbNVC1LY2KkMnx/eJqRToO9Z1SLOcfTxZEYMxtHJcvqaca7fCrti8jgMaOlsu6/IhM/vpBqNYnBezqDCG6HrFMnvlMs1NRpQq9Eodk1SaC+Z5zKcfscRPqsrw/yUhcwfXk34PcJ1QlKs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5109.namprd10.prod.outlook.com (2603:10b6:408:124::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 09:07:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 09:07:39 +0000
Date: Tue, 26 Aug 2025 10:07:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
Message-ID: <cd8097d0-2b84-4aab-a42d-1cde1d5bd613@lucifer.local>
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822063318.11644-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0105.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5109:EE_
X-MS-Office365-Filtering-Correlation-Id: f6efd3fd-06ef-4612-6ef7-08dde480020c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AWOFbiJuCm0CAB2d8pHBqLO7ehbkrNQ6IxOaZKIlDgtHhZ6cYEfDNLf+Q9KS?=
 =?us-ascii?Q?4x2N4ow5jeqLbLA7Hf3qN177j4AOuMpTLE5ILYVlxQpx487Lpw86uDUULQH2?=
 =?us-ascii?Q?Cbri1s1KX1ht0tLfG1bNEVOH8OJbh4SVCAV0av0StdKsKiYA9F6i4lHIRxsI?=
 =?us-ascii?Q?kJLkF8VpZDQZTVEklDaMLMtE1AsDy8SK7WEHBBlbQbW/S3Lf6hJbfkX3KDrS?=
 =?us-ascii?Q?E3Oc3cxWEtAehjeF3RhfQM0XlkhIYjZQ9m1zEciIhd/WUvlkAwb66JTCsDUO?=
 =?us-ascii?Q?3zUqzCWiBXhukzf0Wjw6zizRT65GZx6USviWF0eibcJ/FurRKlTFBHxVfxlt?=
 =?us-ascii?Q?mfFltgig6eXapemM+eRR5QuBlx9s+UjKInnmlKLhb38qx5WXhMsTJg7oNX3F?=
 =?us-ascii?Q?ME31EizlUxwieIhBvSQJTmPRGcP/rTKhDnewbiN5ccvv3L+W1rZCWhJtoZyO?=
 =?us-ascii?Q?PplpVgwFpe6/4y/8/+vC1TpCFRYSLT6e+RGFB9qS9ptDgjxfH4C2CdrHohcd?=
 =?us-ascii?Q?tbcs3dgoZ59DhTz4xKvyNC5pq8d7vwdHiw9mwHyB1vf/pQrY7uM2gq8T4OJt?=
 =?us-ascii?Q?9quUM6b3LK3qMVjUQiSwV6+SwYuO2HpTVsgAoFMxjN9cq+vwySQlxT34TVeD?=
 =?us-ascii?Q?3x5KFtUp2BlJo4OAqx2YxzKs3s6zFU9oB5xsCrqcElSX2J+0BUJY2OljQZmI?=
 =?us-ascii?Q?64i+83Z4tMvNjWIR0BRoxEVNSOhMuq+beeuFhXjVR388qrzHG/25DVNw43TK?=
 =?us-ascii?Q?dXrmRuQj/yak1T127xu5kXyVGUIA4bseYir9JvZszwY9KERsUq/0X7ApoAp3?=
 =?us-ascii?Q?5KGgHKhT5nKPucx8J8U8MvK5FPQ0ty6pybmfcHsSHDgVVEp7vGpsPiZz4aom?=
 =?us-ascii?Q?/JYc4463jiCcyFXmtcQLvgdA2JI/0RzhL08dZ1Yg2jN6/FO7Uz24Eupsy4rX?=
 =?us-ascii?Q?Cct+iDTJjvXCmEQoLkkvhldTHcY/S0HCjtdCAzosv3uCpDHRAKM2+/i6N05Y?=
 =?us-ascii?Q?+nyh7laM2r885iWy6rBAt4ZY/ebnRWtkUDewpFvEMwCTn9Z+F1a+rMBhwmPK?=
 =?us-ascii?Q?1oKgzI9i7D5VpDiECb1OCe2x0gAe6Htht17S8LZtGdaJhPgu0RDOtaVu6Re/?=
 =?us-ascii?Q?FLAuj9KPUP7n+XUD5MEtw8cVN+tVUbhCFQOBokbSWxADMFh16CAZUpYIzfC0?=
 =?us-ascii?Q?lzaySCbh7Qjd4pVbQ5p5D1eqbGODQ6HfUomdM1DOV4nQC7888lUQ4XrtUnzj?=
 =?us-ascii?Q?Zwwk0G14VyuIXRYVgOa8qyWR5FNAqovoYHp8dDpOJ5p0UES5zrxZ0ycLPasi?=
 =?us-ascii?Q?p+I0BVvr7KnXrfg/fgvNVl2+24ogK7yGu9/cdOqEuXIjKlIEJwc7OaNwU9g3?=
 =?us-ascii?Q?fr25O4wEOtMkIkk86ND1LzbtORyPvt2ubU6lvV3i9ruTQUdJbA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OSbFNp4AV2o/gpppnfs/pY+AuusJDO7jpq/o3QvrA4z7A5xx+XKMF/4gZcRj?=
 =?us-ascii?Q?ELQh7N6XfuU4gJe7ExQs5xBo/DBHGS0BD6IezJxHZ/Huc42/lAZaqtqkriZA?=
 =?us-ascii?Q?tKM/15zXTFcnfw5QGMlfyfvcFYunKhAL6yZI+gw19gwu0d0XbF9BZWNsPacZ?=
 =?us-ascii?Q?dl7rc/coLGgcF0xLu0z4CiFgdTwm7Mt5XJHI42N2ASdq+5a4HRr9fbgj2gCS?=
 =?us-ascii?Q?/IDNaIGQ4+5bqoVQpCF3CE2jKy+/5I0o26CkAA7GzAPaEP9NQDTvNg7GFUS6?=
 =?us-ascii?Q?tjORbuKQ9ehEzfBZHoQRPVRgBfDchbogkc4JqJejsvcbJ/7DtdWyTL/cYuCb?=
 =?us-ascii?Q?eGfdSje64mmmSM0FMhWD78URLOHuiJ2W1VlCGLJPPOYkQr5oULyTq8rXqPez?=
 =?us-ascii?Q?lAlK2DTZbqtyDRXdbfhEXt2ZNJ9QptL5GvZpzs8YNlBw9B/v0bMCBSycQ6Qj?=
 =?us-ascii?Q?w01WWjFFdCu86ZLVsK6cuFMm8blA8+KcPNWraF7qgjixy1aGTt9HaxzQLIqJ?=
 =?us-ascii?Q?Y8nx2+X7jXZ0k7nzO2xGhIQ8rvBIqmFQY/PJqk/fMfaT7Gn4u7nXAEAO1Qh8?=
 =?us-ascii?Q?do7V72SWaJ2zMxuDsZgYDDYWoajEF2kZu6H3fYJHYhys6UJGcxdq8VvWLBBs?=
 =?us-ascii?Q?tgtl6nKS9mniSga75fAwejtU3BoZ4cY7lXN2/ZeLXm7FbmPI/yA3caH3NDHJ?=
 =?us-ascii?Q?5eaRzZ+PJ3/aDbEIY9FLlyhDaTRcUgaMFkZXKLVWwVcScUBKpnWzg+XWmrKi?=
 =?us-ascii?Q?IqLTqsHbsafpRK5/5dUttYZmAU65f7NsdDDmoHn8VieVSi7BEsieaWdLpwho?=
 =?us-ascii?Q?2aUGkkqZ7FgtsB3A3hjXXqigtT0Q53RhvmH9O+5YfsQluFEgTkbOLLYGPvhv?=
 =?us-ascii?Q?fv5Fcz1wONoFx+jpSMAK3dinj2haqHOD+3WQw41YfZG9YnzVZdrnCGP0lGfy?=
 =?us-ascii?Q?dDSO66uHO41eOXvkMMd62Lyj4Ycixm0yv9q+TtQXmR0lNVG3IIW82lgBpdni?=
 =?us-ascii?Q?Fn/8rP91TpFyJmQ8tv7f10FY/KB0tTyTD5VBVyJTmADkXU0G+2ufjZmRmDpw?=
 =?us-ascii?Q?pdAN31htzPY50ehKPqsCUUmgmVB3+PPynSMA8WdWVVc7p2menGaru/LUW3Ln?=
 =?us-ascii?Q?ObJ0WlfGTbvQzhG0k+AsRjXdzJAl4W+gMkKFrAkRNZopl07vDbdsK88UqO7V?=
 =?us-ascii?Q?hsJ+ZQGex9mJrNF53ASumrWzBT6X7cehzCJ6hNhwGKKphR2qMG8qAdC0qcbZ?=
 =?us-ascii?Q?VQ5WDQhM1oFexWxGrOrnikyFzaBpn1B10Ye6OVYAiz3oaxZRkL52s4ULgAMO?=
 =?us-ascii?Q?kUrFXotwmlBFoYSV0ZxL3IchimInz3qgl15j1pVIylKvJ2gHdtpxfujiUWD6?=
 =?us-ascii?Q?atTc1OWD5e2dGpIA5sdwUxLxSh3Q1rJU/S6A8XbPIlIqh9t4qF/WSSrY1JEG?=
 =?us-ascii?Q?VU8XGPdsaSCY6KsMlfR/UrWM3yN4Y5/JxBA7m5HGgApfqz1pxRVl03+07nnk?=
 =?us-ascii?Q?wQDhIgiD8o77ab8Pi0eWQyWMupjYVngaxidesN3z0ASjgkvcFvvxq7yVFtFj?=
 =?us-ascii?Q?J8bPqFzuGv/6x3dKyvLwyNXduwVj5EbdTVc6NXFBLZpozEaalyrrGpWPG9+m?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OmRQ5O81qZrJmyteKy0sDuRaD0jjN1XXtP4E68tNY6sLHRtQQbXc5Tikx4muGWiI3Hh4LUFszCmMDWN0RGwapzNQ+kMxtgT9U9hyWsv85VtNU/oW4jGfbiwIzgPAOEqexKcyJWTkiLQz17viaRJ+NxmnpI2+DaqXHFh+77cwif272pYXG5pX1LgFgb4Ct8QKZfrKkZeiAQjZuG6oGDstb9QX7P1VbNsUf+4B4p39/ACyeROOm2+sNNzvxKUaSE1bxxMEY1fK75kYMdibjvSQy5xRGzB+TjDfQkfU2hybOrLHkBEKcs+HsDNHVIBDJ0J3KwMsXjh+31pTFLHOmwv1I+9cekK5YD9e9fAd5pw8AvEvvyuKkFv60oLBluGHMKSHIyz5PmrvlOhCOli0a6Mu1uGGMlVEkIN53l2YzEzCCucXGIvcfyC3kyKsnzG1YGp73uOWJSs3ee5GCUh415bQE7Jqw0HUslLrMSdU9LAr2C00NrqMIQuIKW7L1h4/hcurW7sLZPznwfkfyp01jPpoZT5YY5jBtd6QhQ/INpYDK5fpDUIsQnpcrFowGxK3YxNMrb00OgpMuSoFOFmxwWuX9p21RnoZo71fFyp+LU28k5w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6efd3fd-06ef-4612-6ef7-08dde480020c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 09:07:39.9442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9u7+d/zLL6tsiWRJBmEdBcos2WagJZ3+y3FFAYfBO3jSqIB064LrQnzriDHBMMp2/CVu9Dnro6mZfE9oyX8d2u6ieBFCMu6prCWVy9Dufyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXxQW7fQxlJod2
 rU95o9/CR3NrRk1ycdkql4wRyWSY/BfFAuqI2FQUm8FWf+SwLCO9E1py2k3SETU6f9ijdTldf3T
 NoHvaT1eBKfdjcgo7waTGojMnAWBv0JmOTSW6BW72Ox0hBxMenCTmnCP2X7O9XM/K/w/zPQCcnV
 cir10N+hKdFh7LjxOjlStdBC6UbfLkRbz8s/z8Iyc1VxvL5aJnC5zc7nERpfMBQUcbVc5e3IvGC
 3K3ghBNNFD642ZaEXTJweOydQfQs/6eRwydkmi4uwxbcTwN1PjzECehCYI45SJVqY4Ui2+Tenz8
 Ni+YXiRJzonYEB7eM6CDFYnKghrwN0vuSDRRKTgpFdq/uOZOUYrbvE1kj1s/kWYzzRai8T9PolZ
 0mV8aQJq0z3RKW6GI2LIjbZrYH2VIw==
X-Proofpoint-GUID: U0JYdj7EkaHhQCokJghFVe_MKjAJMBdS
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68ad7960 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8
 a=VwQbUJbxAAAA:8 a=RvvMqbcd8f4qOTfuvEwA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: U0JYdj7EkaHhQCokJghFVe_MKjAJMBdS
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80C952000A
X-Stat-Signature: j6x5ouzfnqd49drdkqc93bdyiz77y5f4
X-Rspam-User: 
X-HE-Tag: 1756199271-82452
X-HE-Meta: U2FsdGVkX19IJUCHe8KwWpu/+c/zCFtT30fwvfvoMVsaes7duGexe017XPlTZokE0GiJMHm+3msq0aUJ8Nuy/iZle1y+xrdGe/3F4KTveBTp/+BgvP9TdC9GacWUUFH0tqsJE67V//Og50LL3EK3+QtSYWYbBZUGdYHFlsL5oXb7q3BWwzUCrpIwRgbXUVdwjqbad87GfXaR5Bm+fMfDv6J8XVY4YyvcM/Ba16zY0eb7HoI5MUTKLVDQr11fCtUAiuEF+cmSpdEtPpGS0ofMwuPWBGi9snuCMRt1AxKrE3SWswrVDGb1udPsT3vbJ8uuMY02j0bKW5UoGcnF0deH1bUnma0FiZDqvWNEPghcksy9pe86WB/qyBr3CzsZxwzzlF3vHez/AIp+gC1sc4CEuUtFIs6RQPgvjn8+7k9siqq5Woeltu0NPW6QRVRKSejyqi4BiMys+lgj47JJfgNHvh5iIrWL6ZVtPAheF4dN4bPdgQoMc3jj1AZg2dHMU4FPp+N1qUdvsYX1Qpu6C6Js3zSHpmNyqvWvNVWep/Bq0L2Q5Qalvy+dqMvuYlP4VLBTZYbwTGLYnwfJZSqokNxzPC69y1OQKuPHsbgg3IRYjBtor8V1kNcFKjg8PqGE+r5FG5w92jFKbzgK/dmQvtr/LLhICzvUELJ6VZF3jbVtNu8XyHbNjN+uEel/nvD6+gJRdyIgv9tghbSiyFJ0tAZZzPHi+HZy8BV6Xq/KOrelaMmDZPl/35kCTRSPJEDrZIqQsdliT9NskXXbb/LnUyZ0HhyNex2cTBabAUr+/j03YsmFDtzQEGZ6IZFQxjv+PEann3p/k3Zn9PQJyDSmsKEhw/R4K2dpIxqwbwxQ33+5JvAM/qrhCi7uiAiaeyAH+5d19Fkp/c/nAVqyNxgjLZnT7qmBvBpM+vl4FUEljLJnGDuV8iYL3iBzfjaIXqusVMGFt1McnkIX421V8IpUHCZ
 kzNw7xEk
 9kFPi7xNdN0NxxEh/Qji2amDh1SXPMfdufcOHUmX2ywEmwIVTgbBvTLn+H7Ml+u28hCaJxqVCTwSL8z1DuxaxuermTHOlAethV0JbJSwh5ionCraDPrNkUCW/4Ey9Rk3V+QhP7uiMLCsfNfIseAPsz5T5FTfTLpmztAs+xOwCB5qHVIHXGZs+pBFQ1L49Aamb4/IEd0psDSvSj0ys4pMUDZ4vxxW7jgdGDZlO50+pDOPT0yq0LEiCNRTpri4e7FqF6WcqZxygF3MhDaGijrE+nF2TN1hd85Vq8kfQBySxvERsw9vq9CzH1jBjJDoM56mQhjih8aVPiEwjFi9cJRLxSDBSKmycF+0Y3ubuoJ+1WgkpBddUFcbsO+ixaB8Hv6ucK/UuqgPRLURtKYGvwHgGGhKp08+VX0PmWh3inOF4YFOCHJgbufDj44ogygOxfrdlS0kjrv8zoChwmm+Rm+hjFsEb1RBDEpiljOs1zsZrnR7PybLTeswXzTfAwWBRpyNTyATRoRwANg+oAm2sBYKTXarTuo3OvT4YoA3aurmfEWnX0a93jNP+bvaM9k9roBet6FItXqYnR8gX9VL0GWsM3FwEk/DEeQjKbViWdc3gjr0nZnnvMjgt89R4LAIxaQn08hpKKxFESCYyg9KdFvVafVDlKCDmdL63YtZG4CkmMsUbCZdndpelC/drzUEHXkbng1l/6bRSIeEu5RU/jY88PrXOY5Q7RSzc+GrSsS5Dv1jCSaV2LO5q5wjqvFTU7XLaAfm4kLkm+FVljcaI7gw2B4oJ7Hei3Cr1DlpnqGYyFO7nws7epHjAdoGXIaVQ2waTbv2CXI6HXgSe8CfEWyYkwjGGtzWDtQiIbIwXSeZ6bw4+6Cjibo9tHmwyZkVdKNlYx8vCq8RFiy5fbK9ge5qA7C9FLFi3RIMZzlSvFJvX80PYE5ArJ2kqHiC+4CTJzDe54Acy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 06:33:18AM +0000, Wei Yang wrote:
> Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
> mmu_notifier_test_young(), but we should pass the address need to test.
> In xxx_scan_pmd(), the actual iteration address is "_address" not
> "address". We seem to misuse the variable on the very beginning.
>
> Change it to the right one.
>
> Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> CC: <stable@vger.kernel.org>

Good spot. This code is beyond belief.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

>
> ---
> The original commit 8ee53820edfd is at 2011.

Oopsies!

> Then the code is moved to khugepaged.c in commit b46e756f5e470 ("thp:
> extract khugepaged from mm/huge_memory.c") in 2022.
> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 24e18a7f8a93..b000942250d1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1418,7 +1418,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		if (cc->is_khugepaged &&
>  		    (pte_young(pteval) || folio_test_young(folio) ||
>  		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
> -								     address)))
> +								     _address)))
>  			referenced++;
>  	}
>  	if (!writable) {
> --
> 2.34.1
>

