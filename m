Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29679C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 11:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43B16B009A; Tue,  5 Aug 2025 07:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4416B009C; Tue,  5 Aug 2025 07:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894F56B009D; Tue,  5 Aug 2025 07:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72B916B009A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 07:58:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0226213543B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:58:20 +0000 (UTC)
X-FDA: 83742556002.21.0CEB5D5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B0F640014
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:58:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UpK1hTZf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mzOJ7aXz;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754395097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Br4evy9UdsVulZUwy3Kz83a+ogwVfxISu/Mka65lVvc=;
	b=pQViLxdlKWeCRIprMqJ2Z2HhG4kDb9Euqm9UNDfpxIW8nl+Dj9wdsrAJjYPCbmLl5FbsW1
	YVMQEkYn4KAZoQ9bcnRFL/OLwPGyLgxQr/Hc5ENu8H/YYZhRHRjWMsO11TU7YNATVeOLUV
	WDMSl9OaKBDaXY84yw6RtPUQB+2ka7U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754395097; a=rsa-sha256;
	cv=pass;
	b=6KwkzXSQh/Tj7PrBFmp/Q28svrYQu2fp79p74rv2kw0cImVw5yl0pYdjiNF3Nf6wTtzEzD
	5O+CObA+E6Q7NP0L92TU4xX2P6bmDILNTKwrS5Jq6DUDPqjrzzbudItH542nT94HBE0uYQ
	3JthEjcIPIv3ChtN9/itc/eHOSIl0ns=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UpK1hTZf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mzOJ7aXz;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5759H3CR025851;
	Tue, 5 Aug 2025 11:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Br4evy9UdsVulZUwy3
	Kz83a+ogwVfxISu/Mka65lVvc=; b=UpK1hTZff3KVlVJzVs7iF92DWGXPGohjv1
	Sg5ZFRjcFBeahqDJXmxn8oscCMrtVLKs5yobUWLnh/la8fx34IumOzsCtu9fV1WG
	L67qp4+eicPZ03+T/FwKmLG8ZmiEKGUgyi0pKzUn29WuxcIzUxhCO9tj2VRDw0AQ
	AWKSKpvBHfNFEhhL8+D6tLBwGwSQLUB0jSMfVpx7CcZwyqdm2hpMGVGar8wV/ZMt
	4pCuK/hEdFZkTqpwg7qtFZm0uy9afy3ttLy0VnveFISr/0+L1iNFDse4FBS5VOFt
	usevZaLZIf+e8zU1gXX2UzFGFyXWtinOC5SxTNMUIbBrq8773UXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48993fvhfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 11:58:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5759qbcj031879;
	Tue, 5 Aug 2025 11:58:02 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jvtwe7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 11:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SH9Yip7P/AIjMCIIGLew2e6+IeilLcx+tmfECWGyRfF2dim9gtfrLD9pxXRHLEvcvb3U20SyTsRffWsRiODtqWVs2OPyoBPfPPvBH1PnrVwcxogr7dOeACahTrVBUPdZhUkkfvyODOa1EvInlD5GMv55tBsGprNIFje3wmv3b6DlnQF7z7yWamUhCHSC1UkVX6Tf6XJY5BchqLPuKQC2tOdnXS+ks5nh5H4XHk0Whcn+fBDxenKEWKso8MjsxaHuVqtGizInOd8R0W9V5KWN6pZgkZ5r1eC50RatOmX5U8rIH0cAGk/KFtNiRrKt89Z5XMeb+81c6/VnTKtIyZIo4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Br4evy9UdsVulZUwy3Kz83a+ogwVfxISu/Mka65lVvc=;
 b=B+SlbkUCUevRePCU271NwjWZcIJKS3ry8ffIgzgl9WvRHW+1JP7gH2MoBhWDW9o6au7BfS36ZmlQCFe2cZDbGq8dQjUVWB698ZHpmGgTFzMG+MgSgZWmK8Aj5t2tPtC39fNVRGwjhoYXOGgu3rkAzT2QR3zUQVPqEullJOTxOprO/CuoVkaMw28GWh39zqn2vZaCFC6lYN2VHhIbtVrfE0z+27rdYh7dbN4l+XEVQNo5bSi17tg7tp9WEozawsyQ/1UkqhUxJINU8lt9NsAkp2Ph7RKjXu0G/6bd4ks4r6clsffuMqrJ2azLP83YFOcn613BuLhU2uiwZefyvY+w6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br4evy9UdsVulZUwy3Kz83a+ogwVfxISu/Mka65lVvc=;
 b=mzOJ7aXzEc6wFSXCiVSSVTVBy5UJPAZpasTfO/oSnApg9JpT8dwbWo9FIjQx6HS7OWVBB+B1La4dY198FmbJFj8seabTpzWVIQ+VcVcOd3uygd7jqAadsGUKyud1xXL0aaXyd4J1qtibeAsoJEqaSk9ZRjw5dsOh4ub1E+/g7OI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB4527.namprd10.prod.outlook.com (2603:10b6:a03:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 5 Aug
 2025 11:57:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 11:57:58 +0000
Date: Tue, 5 Aug 2025 20:57:38 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/slab: save memory by allocating slabobj_ext array
 from leftover
Message-ID: <aJHxsvU-77D3pfhJ@hyeyoo>
References: <20250613063336.5833-1-harry.yoo@oracle.com>
 <00e91300-c6e6-5330-f514-4628ae2ba696@gentwo.org>
 <aExkJhM_P8mnLC12@hyeyoo>
 <bdf0af50-2e1d-4627-9775-ae62e2dee509@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdf0af50-2e1d-4627-9775-ae62e2dee509@suse.cz>
X-ClientProxiedBy: SE2P216CA0190.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB4527:EE_
X-MS-Office365-Filtering-Correlation-Id: 3237586d-4f2b-4bbe-ab20-08ddd41751d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EntGy8PuPYP1LDWPK6hNEJK4zZSfpw602CKcQ9buYhbthGsCrLpf5+QOWyiJ?=
 =?us-ascii?Q?qFE2OPl9BkYO17sOEm1klCExc32G8AUWnHN420LrIQfD3WmnstjPcUP94XYT?=
 =?us-ascii?Q?rlcpE+KUXXcJSBJB878+QC0mBbkFYMWI55vZq5+YWNG/q0fgQY01Q92s5XLY?=
 =?us-ascii?Q?jPWQjyRD8VtGXRU5TupOShLj8q9N182l0+kTlU27itVz5iwEV+U3mQvttHFr?=
 =?us-ascii?Q?UiPjlC9MQwwvZ+bz4gLcQr0/+9twskdx4GIOQZGGd1FDZ38fwa7S3hmCvSsw?=
 =?us-ascii?Q?38fQDUlvEnnhu5avD+wXTPgIb2RTDyYGUYU6wIcUlabggOVuG9o1p2FD1u5O?=
 =?us-ascii?Q?N7t2P5hl+Qwo8hmj6lGZMfyOycxUAKZU6aozJtYoNLgzFq+p2YfAUHelixpl?=
 =?us-ascii?Q?xaOzN380Oc9BKAT4lDlIo93w6VcPV3vOPGYySVDcyDrQB/erIl4J48ExmMco?=
 =?us-ascii?Q?v7d8pvVnakUC9wumjp9WaCQjzTDZlIETqxUx33yZyC8IS+iNEj2bLUyDMKXQ?=
 =?us-ascii?Q?zbj2tQkGb48vy3d3FDaKj1jqP7Qx/teKJ4AgMEcJLzbW5UmgBEEuOdbOl3Sb?=
 =?us-ascii?Q?FMgwjAAZuq/0dBF4pJ8bYnD5BG+xv1GgZq1Cst7NQTdVY7uzssAJRhzzqkPJ?=
 =?us-ascii?Q?juntkXmovg8X24xSOkehoGol3ZWDYCL8ztN/q9fPTB7812kKRsWNlWTovW3f?=
 =?us-ascii?Q?7wv2CutCWDmP0352khoIBF98dVwyl2Kuoq6JQpfMKjidpLiuCwpEAIOVeboM?=
 =?us-ascii?Q?Ifl2ngbHIbKS2EVNYOWToqlkFjVo04JJgNp8sT6U+z907Nhpy+2MmyEx3IfP?=
 =?us-ascii?Q?/vqXZrtmeZX637YZj3UmBs9RsvoDkM/hkNCjjfXvhcjCQNJk1zbsmRGc/CiD?=
 =?us-ascii?Q?z+Batw8kajzi0Gu/4mYAHXDJ4ZC9IJ2pDruKo0faUQlVzK166G0cd5d6wRMn?=
 =?us-ascii?Q?EGg+ODoYSdrma19YeuaC/erUW9tGHmrIAKvWbWoOU61d1oQzWA6AXPIAvD9z?=
 =?us-ascii?Q?B3xJHgN6ybReReOkBiaqnSwr/SounuUCFnFEe71E+VImGE+2/zgM7KzD+vUE?=
 =?us-ascii?Q?ZKZg1JGVH85WJiawnQ4kE74TjaunEHeE8RPtITafgxkyYNtDSdnb93km8kAB?=
 =?us-ascii?Q?kHPAC3+QXyy5VrbRkMFBtV2fqkTXr5X5RdgBYovohs7g2rNfsVNwIifI9/6l?=
 =?us-ascii?Q?nkd6ekuZFLKo7CVHV31ppQQDMRBJn7GitW1UI4iJHHUE3Vuzf/vZMs/GQjbS?=
 =?us-ascii?Q?meM49uy/i3SlUBBlYa6DNkVuqJUdnpXDCy1PtwEVRnaGniC/XP97Yva4rPlG?=
 =?us-ascii?Q?eZhNo/nzKoVFQV950v/esykNECr5zPnvhiP1uqZWQ2gxLQR9j4CJqZfLfbqf?=
 =?us-ascii?Q?lOHtAUhd9YBgdr1aWpoddwM3uN1gt3oPJpFo7203ToPJlZ+uhrGZy2MTDipO?=
 =?us-ascii?Q?18awVnMEJ7w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FzWr6bpcdwSX42sviU0z9rrk/5N/dFH4GPmDJpSO/WwfszlZZ7XbfnjTnxtJ?=
 =?us-ascii?Q?USrT/GGzydbg+W+mlQjqKS59/VN5BQSGA/xzBK7oVEjrxqoYsFTUBhAnkGyz?=
 =?us-ascii?Q?Yizp83yAdBSPW8kpaJm43s7xyUKIgpIeVUIpevB7a/qUEasrQGbQjskQjGKH?=
 =?us-ascii?Q?psjk70fy0e1qGm7v87s081memzNToC/zlE8ZjG2UvO/RQtWNCZXhdmpCJ7N2?=
 =?us-ascii?Q?i8lEx4Huzwim6S4G3U7PggE0SpNBoGuoWFRGDEZ0/kCJhKFynS/ycn8jVjR4?=
 =?us-ascii?Q?ODYijPv/LEJshPgXR4ASaK2E2VEYDFdhv+xXTT8k29UxIlsZ4h1NKs5PR6Pm?=
 =?us-ascii?Q?3lymsKoE8GPM1NDSF8zbUvH+OT2nXdQidApFdd0c6w0y40dEwmx9nMg2bxpy?=
 =?us-ascii?Q?g+Hk0brJXiFv+saiWZFq+f4U/qsZ4q6WqfEUB1j33eNkFdBp24D+46jGh+HG?=
 =?us-ascii?Q?sPngxvZU7e/wxYX2DJGLwRvEm0F3RZDEGmGd5CJEU2V8dHmaw9TT657qoz+G?=
 =?us-ascii?Q?VrdoW5t7HO3vOYNdBSnIzRJH4Awx1l8kXw1iwx8J/nS9Hxj0heGXiRR190+C?=
 =?us-ascii?Q?/Uv4qd/Bz++9SQq+qwiIrUJQ0ZjuhcvPx90ijvdb55cLOv/QsJyrFnDbDRkd?=
 =?us-ascii?Q?v3/0ix6SFk+lXlxppJNefThJXdoC0NeVZa2QqAMRypvv/kowdVmST1GA1wIy?=
 =?us-ascii?Q?QSNjzbc9NYAv+2BF3DbJo82G85qYYh6twJg+Ui2UCRvppaUAYBaLwC2WC6bm?=
 =?us-ascii?Q?30lfEn4bEBz23RO/WN9YSGgdLPhMCrVGntGl6uxf1eyIEkwWgbNfDq89rL9S?=
 =?us-ascii?Q?U+UeeLd4jSeV+CoTygyZkPHezDzGTMRoYw1SthbAMGjrCi/nfKJFdX21O3f3?=
 =?us-ascii?Q?QJMCDVKIU6x9O1c2Lf1kjYqRTQCmMlyfl4WwGFL73o8G4nfcA8LXs24WZ+dh?=
 =?us-ascii?Q?RBH+sCPWNdp+H2x7hS6UQPOi9IUyG+dYW303D0JvKQ1tbqnrGPZiZ8cJZy9A?=
 =?us-ascii?Q?FIItCVI5dgHWe27ewLf/02vh8+O/rFYvhGmkI2YONEiWywQc1lL+fyNqZB1u?=
 =?us-ascii?Q?gZQybPWFqGITiqYNkoypboG73Db8ia3u1X6fhCgVRQ6ZAr6+D3/X9K6wfEye?=
 =?us-ascii?Q?RsCfE7ztMp5N4oZGTZAff7i9OKR2YQcqhjm7nausKgZB8wsRRxsdTdtDjVtN?=
 =?us-ascii?Q?o845Rz0XaqVdPc1wYC8RuiW4FhyrfQaGlxYDOV7/LioLVOImd0n6yjKN1p98?=
 =?us-ascii?Q?LiYDuY9FjpRwTuTG9NeeyLqxXzBEgCumZAV8nlNFZsQhmL1rBuyNtY15p+Ws?=
 =?us-ascii?Q?1b6MJdlaYGa6uJfzIs+rMovdkRlcadvimP5K9cGnuh+ZYHO4wWzwT1RSbS2m?=
 =?us-ascii?Q?/hIwrItaIKTBbbpbo/ZqqiansRnj50pSWkFntx29eeCSsU72LetfhYqMOoHX?=
 =?us-ascii?Q?gWfkpXhxYHvB4FiSxg41mFnlqXLaysEzLvTX2xA8Xd2D8TgdMWzTWj/1t7md?=
 =?us-ascii?Q?EDfv8LqIe49SajU90kEnG4SBlgg3NA9gV3IIuVJCAdEPF47d6jz2bHBCz0Fm?=
 =?us-ascii?Q?xqf21PXbjDxEoy4xix6SB2fpvqTgDwaWYVCPIrqH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lYbtxt9GY1e7kOvYiCsYE6wC9xDXHHThUWtjcp9l1ZLD9uh8+EDsQnvg6oZ+h7lpHi34RkQzLEEAolpqApIjjlJi7Iv1pQUoLQFIaqnOJhOZ8RdkvSuF5CIMZhSpMfGsNv+qdKznNEToqKZ0bFPA+JdntMT+0bfj8WLRsG+2NuO+QGv3b/+e8NzkGf4bKseGkY5DL/odqmsr5eHCHtm/f0aPJ8isDucmLkGOVPGDzUbk4O9dSLHzD3wyzJbGTl1JQ/Nr3GifGedPaSeEUUTPr+3TR+OTw4GT4hs3pnhrQcn95WLCHdQX85GeInM1EnS01cRBeM3Q1v2Mn4ML3M/C7uI1oUx80delvZ62COCKtqE9WqM8I94aIKqtpiKxbr6vq2Uq+ozNkHmdl1RM4k15NWJzzukHlSo0cnSCleYSwfQaCgrPYLMoLf4/CbG8oiI05WD9WcRjIHjw9x8svNyyv9MhvK/kLDCVu7oVF4SsfU6V0Juq5kL3u9blGCy/Wb/aACJaJreSiwED4LDNfXXDOEvDhhtt9QJMV7wQewKTYhjBsBk5MZ2Eiq/9GcxftLAxTQADpi4TFsaZFsGLEiokGRLV3sf0Et2UqBd06HajJxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3237586d-4f2b-4bbe-ab20-08ddd41751d5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 11:57:58.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8EcBjsB/9gAhCrz4tjrfSGfPBLltHlzgNplaW2CDgz+j0F7xy4VcS0rp009D6EaofS//9UJf76iRqjDsQU/Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508050087
X-Proofpoint-ORIG-GUID: YVJXTZL5qxqDaXhR6gxhLGcMlq7bSCp1
X-Authority-Analysis: v=2.4 cv=bYxrUPPB c=1 sm=1 tr=0 ts=6891f1cb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=MYDmd-AlD0hlEJJLBA0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: YVJXTZL5qxqDaXhR6gxhLGcMlq7bSCp1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA4NyBTYWx0ZWRfX0oBJ404wYO6B
 c2vENssVPntsOM7U3UIWLhodwCvWsp8H+/BsTE6lq2gx2xDab5LDfSysQhm2S30128iL7NG/W/W
 xZXvXyN56lUcJYg98tU/BNeMJrceA0Uo/SEPjbTlBiUWL/Q/edh7fbIuk58KFRXwdXtoghi9+M3
 FmAam5Wxml9sTmzmx6Qr4X6+590QXuplboXB/wrUQLXZgIPc8fX+f0Ql5a7Q3kderyBGEPcA12n
 gLtCkyXLrHI39e4X6SkGoYGzzg7DwvvwL4IgSSeRbuhSlRiZFYn3avS9jyOk/TOe8jH2M9FWebz
 yqFlRH5tKCFKacbpIw28BY5lBwIs+eV32OxuPIUIavTzO6rLo0QgOxz4IZxcaF0hi/zRe/L+qsw
 1LH+V2luzDzJFLSrCldLlK5hsQhrdE35GpOygItQXaxpwIc+K/JbeKsgkxn3s7d4l6VKjQXO
X-Rspamd-Queue-Id: 8B0F640014
X-Stat-Signature: pxtddp97ccdfj77rfqj3nzanwdsc84qd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754395097-332800
X-HE-Meta: U2FsdGVkX1/OogRC9pLvV6Er7b0GATFK3a9FWkoIh4XUYdsdk4t+2FMv+whuDPEvhbpDxS194a3f2cIooRyB/mwl2Qu8nEIm9z3UrJp29iw/coJeM9ZsOcLGa3lyfCKbGjQmWZrfgtgzODmA8+kwCr5TNrk4hYBVPxnEVDDhxzQ9JKng9ax/Cmmpv3ab2ztgdSWW104L+B78jWou//hFDGl9PVtzka/T+0c+ccxA03a2US3DxFMoC6l5U+Enpel20pOvyjgTnlJcPannF9FkQruoK/W0luxiw9nT90z3Q5KzXqYxnigJE7Ge1HO9wfu7vdDdWzFuFqC8e7pH72gUXVY4Bb8ei6mFY181jhRyTujnrnD/gDdnEiorjIDsW5tHqFc9W98yp4mZbukgTKrXQdTBJrBa1SO3HkZ+LcB5KZX7lE0rZu5t5tJr08FcJKrs/shB44J4MnQ2BU7G2Up+sP1OvY2bsHrCeUww1f3WO01gKZZDybMBk8Q42mahP2P3dea6E+AvSIDgyYp0BOvzv0zRNoY5rUfLCT2XUdRqxMvRP9ga6zftLaFDBaFkSeaSf/P4dq0r2d+LQwfc/26KczTKIF7+miiVBhwDiQKgAnk8DKLUF+FvM9E3NDfp6PdZSL9K5xXz9PjFwcQJ27QanZOIVM8RCPwZ6Eo/5dVEE3diLjCNoji2kvQd+Yn4Nk++oNFeaele/HYNGXP104xUTF/Eo7iudpQ17L5t2It94Msp4xEfOxrn9tbCsgMWIIXtBU2HpMTauKpNJ6lanYcy2S17qlqXqx3/a3MlDyKPiy80cO3v8f5R0zcDdcjyYR20hdLHMvGEuCIc1d74CuegeSDU701AXiCRRB7JzS9sKEYphKMxorMfD4CDAxpjvwE33r9ogfxLGDIlWwcL2VQDifX+GDH8xhQ5CEiPleKtttwRYoOmBaCxb0RnnmQJJ4uBzXvZgYdQh1cizJ5zYTL
 eJFvc6IU
 fwpBRe5GwL9tvFvjVWq3gfR90BE5B7si9t+YIRc3ZjNvOOLSpJbLudeJZFZmz5bow4uSqFbI0e1MdPwXidWOnH3JIZJ02heLzD7+oMYwv/yPSasKBIju1jMi/nFggOEfDUQ0MXQR5Sodflt8vYLC2XXFIhdbCE3s66SEW3ms/NpOZUQ2IafeATd0cNkw6yLHdPWTYnveHvejk71MFGXoSXbZVJcY36yeTlsy0UCY753h6lxE0gvv24waj6FQV6hd098RO5+D95EHq+36s/4L0waHQEltp+ABplj1NE+LZp04OwhpBIqw1Cm/GdAwaM7uYfhKu3qFNXXgfyNxcT1FD72ii4zbcf++EevY5DoLwfUl2mh+oRtk0cO4MlodqiEEb940FilvlXJ14XH3ALJpfEr/VuWgb3ZSPGkH8PsSVe9RXLEbuP/N9DTjcHLcuLbpSWNPb7/sCHOFvJm2T67fLqR9JjRTBbft/7lVN9hBmDyA8G+cOYZV9aDwDDV224zTpP/0XkyjkqUcxfL9Hhvs7pbHySkhPxsFY/qMynRBuFFO+A3NOpZJ4qqN2vcCp+t3ZIjlEM9tVgkDXXCe670zUBmbkzI5XMsEY+R2WR/5hckl6gbjf798xXt5GA7iEQQmrUVdk7D86uYAOdeFw64C4neluIJPFynS4t8HnLhotmb6GEJYVKvN/ZYm+eSadSweuHTbjHfmgpfA8jeULtLFv9gFT+ciC2a8KKSXNYFEUtpiP2PjDz7Nyqxb/VZNbwxnBRjCSKhzX6JkATch1VRDvHHobfaDEe2Zi/7Ft2EjYifZbGuoxM7yZwj6C+n0n8KJgl0gGruShAD1X1dOBsKSCUfjwRjEcbFrqxn7UuDHV9eGR++F1WOw+sRqrgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 19, 2025 at 09:56:59AM +0200, Vlastimil Babka wrote:
> On 6/13/25 19:47, Harry Yoo wrote:
> > On Fri, Jun 13, 2025 at 09:04:34AM -0700, Christoph Lameter (Ampere) wrote:
> >> On Fri, 13 Jun 2025, Harry Yoo wrote:
> >> 
> >> > Allocate slabobj_exts array from this unused space instead of using
> >> > kcalloc(), when it is large enough.
> >> 
> >> How does slab debug work in this case? The object layout gets a bit
> >> complicated with other metadata there as well.
> > 
> > Oh, the 'leftover' space I mentioned the cover letter refers to the
> > wasted space after the last object in a slab, not unused bytes within
> > objects.
> > 
> > There is no per-object metadata stored there and SLUB simply poisons the area.
> > I taught slab_pad_check() to skip checking the slabobj_exts array.

Apologies for the late reply. I was sidetracked with multiple things :(

This is definitely worth optimizing, so let me make some progress
even if it's a bit slow.

> I can imagine going further with this in case where leftover space in slab
> isn't enough.

Right.

> - indeed use per-object padding to store only single object's slabobj_ext,

I think the most conservative approach is to not increase object_size
but use wasted area when ALIGN(size, align) is bigger than object_size.

A good candidate for that is xfs inode cache.

> if it doesn't lead to memory waste

You mean increasing object size but without decreasing the number of
objects per slab?

...or (maybe) reducing the number of objects but without increasing
the size of the remainder (same as calculated in calc_slab_order())?

> - if not possible, but object size is small enough so there are many per
> slab, maybe have one less object per slab to store the array?

If object size is small the array likely does not fit in one object...

> - once we have struct slab decoupled from struct page, it could be part of
> struct slab directly (but it would mean struct slab isn't fixed size)

It can be tried, but variable struct slab size may or may not work.
That'll depend on the implementation details of how we allocate struct slab
in the future.

> Of course having multiple variants would risk slower code, so fast paths
> should not be affected 

I agree that affecting fastpath is not great.

> we could have pointer to the 0th slabobj_ext (we
> already have) and now also stride (to support the "per-object padding case"

> - there's still space in struct slab right?)

which space are you referring to, maybe lower 16 bits of page_type?

> and then the object alloc/free
> case could be oblivious to the storage method, with just a bit more
> arithmetic (stride). Slab folio alloc/free would be more complicated but are
> not fath path.

So it would be something like (please correct if I misunderstood):

index = obj_to_index(s, slab, object)
(the struct slabobj_ext pointer for the object at given index)
  == slab->obj_exts + stride * index

slab->obj_exts, stride are determined depending on the case:

- In the normal case (the array is allocated from kmalloc caches),
  stride = sizeof(struct slabobj_ext)
  slab->obj_exts = (the address of the buffer allocated from kmalloc)

- In "the obj_exts array is stored in the leftover space" case,
  stride = sizeof(struct slabobj_ext)
  slab->obj_exts = (the start address of the leftover space)

- In "per-object padding" case,
  stride = s->size
  slab->obj_exts = slab_address(slab) + s->red_left_pad +
                       (offset of slabobj_ext);

Ok, I think it will work. Great idea!

> Also some variants would be wasteful if they need to be decided upfront (the
> 2nd and 3rd above) and then the array is unused

Right.

> so would be only applicable
> with SLAB_ACCOUNT caches (if kmemcg is active) or when memalloc profiling is
> active.

Right.

> Shouldn't be a big issue as ad-hoc __GFP_ACCOUNT is handled by
> different cache selection for kmalloc() and I don't know if anyone is
> actually doing ad-hoc __GFP_ACCOUNT on named caches.

A while ago I was thinking of getting rid of ad-hoc __GFP_ACCOUNT usage
for slab allocations, but at least xarray cache appears to use it in
an ad-hoc manner. (See xas_nomem()).

In that case, not all allocations to the same cache has
__GFP_ACCOUNT flag set.

-- 
Cheers,
Harry / Hyeonggon

