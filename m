Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBF8EDEC01
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 03:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932E96B0088; Tue,  3 Mar 2026 22:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5F96B0089; Tue,  3 Mar 2026 22:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D9C6B008A; Tue,  3 Mar 2026 22:05:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63E8C6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:05:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DCE81B7D8D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:05:40 +0000 (UTC)
X-FDA: 84506890440.05.44E1D86
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD0911C0014
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:05:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PH3Fxwpk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k6tnMS3G;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772593536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huDcWyfrpC9jHQ+1OIUgRF37Gw7Qq8Sv4QxSLKAlvBw=;
	b=76/TMWsTq/hBBwC2Viytzb+pnAWML9Tx6//+N2UpfaIfmCqz+rRN+/8PS3UyK25yvrzFDk
	gvC5V1ZEzWotUw+ta+P0NuNm+jqdWZq7pt9q/iXqfCuxryZ+MVfm04ZOgbZ6KGNOgixtDu
	uHiDOKQAR0UBh163S4pXTD/OKJufNq8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772593536; a=rsa-sha256;
	cv=pass;
	b=7UMuQAifgSVU0itvegI5tLhP3UpAYxIbIHRF0FpQHTfti9WOvirVWMi3HuRc9UJVI9Kr1f
	DZ8RaUZkCSjL3InEalNcWZWZafYfzNRqzB5uwrj215yMwUTkMc90I0oVoTWW/s3h3px/XH
	NdCf9i3A4Io1jO74OuYpayDMJeXMEII=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PH3Fxwpk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k6tnMS3G;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6242Nnkt1503451;
	Wed, 4 Mar 2026 03:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=huDcWyfrpC9jHQ+1OI
	UgRF37Gw7Qq8Sv4QxSLKAlvBw=; b=PH3FxwpkMxe7s7pqQlJW5slPEV16d6wsvT
	ik6aMdIfsq6Pzqlsf8EwpXmpBOVjOdeAucZGp1M+rxFgkZOCSHBqGUxlimNffv9O
	fkjB7gLXd5h5LVLcz5VxKHdDtLMqZ2PiUzj+I8VjRyI35iKF/sXvq6q60zqZdVbU
	uoughuMINr7RPzzVYexYyO0ETJtVNbf4BjVXGz6DBLtboDZNcYa4syVkLEGUz8M9
	AuLkRzMTbLQxWl0pHMNOuK7JNRpM4sNkNWH1U/Su9sxw4jqTufe442B3usvmc0lN
	Xhb7r7ziujlbTAiryOAKAvyJqUV96+1jBJSkFEWqtciTh/+YztKA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpbw780ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 03:05:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6241LNeN034818;
	Wed, 4 Mar 2026 03:05:30 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011068.outbound.protection.outlook.com [52.101.62.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptf7430-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 03:05:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WdQYx0LuS8HGtOOF51v2adzaTjllYQUOkuTtBKNSnmi77ruSHYU6fRquxwESnaQlXK5xNnbYZ9mTYq/KqzHKHduD3n/p8qxCDloqBiHEeZmYKoOpkE6RfWZ8hrzZMfwYXkKrojNSBTaceV3srnk6/T4o70W9g/a3tQ4hUMZot2BMYSpAXN9AZoYIfgmpW1oqvwoWnPdz2pTb9MuR1vaf3Ft6ZJQcA3YJCzd28cLPwkGSJtljCTuwX6rcduie+ttNIlUiOglB9kwjowlm/CvJiL6/b/BJZMCZ5Zi207auN2MrnkL1JTZxgp+bsl2L7VuepDGimJeJdFOMTGTZdTa8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huDcWyfrpC9jHQ+1OIUgRF37Gw7Qq8Sv4QxSLKAlvBw=;
 b=TG2SLgRPPeeHkWs5lP7VLrZXJR4RAuY+Jl+j0PicWQP3NJ6A6NGGM9zFzJJ0m92kMzjpbKlow7UBSJs4ZOK56+7GEM5k5jlQnzyq5DfKcnDM6/7sgJuP/sb/qcBitmwlLkiVSDR2Q5Dd/UG0CbYAoxSKjeGSZjrZi9rxkcNd3C+CDV6tQjJ7G6Dlf9M/6wq3P8i+Es33IZkh1YHrqhrL6xfiF88tbjNG5N0cCN716SpZYGFlWUAZPj+uKpZSRGkOXq8FMMpYqxq+O0NrCD+K7m/KagJvB/rNCbodZLaUdg/ggl8d9T9lmbnINpXQBnhJLVH1hwUaH5WHpLm+x1bzHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huDcWyfrpC9jHQ+1OIUgRF37Gw7Qq8Sv4QxSLKAlvBw=;
 b=k6tnMS3GLm5BebZFj2R1gWCzLKpMOd3Cn3zfLJCFMiDUmTbIqqM58sLVw+n2E0Tiifpvw4JkIHR0iSqraaABwzEMn0mEErAprH8qKzc8JduVyFBcUwkIoqTT43D7+Ve1gLG1keV9GAmt+KQJfNVVMQ+vuy+rXApHMcM7DwSVojo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY5PR10MB5985.namprd10.prod.outlook.com (2603:10b6:930:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 03:05:27 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 03:05:27 +0000
Date: Wed, 4 Mar 2026 12:05:19 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if
 blocking is not allowed
Message-ID: <aaehb5EwDKygrXGW@hyeyoo>
References: <20260302095536.34062-2-vbabka@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302095536.34062-2-vbabka@kernel.org>
X-ClientProxiedBy: SE2P216CA0175.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY5PR10MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: c3257ac8-24b7-4df6-47f2-08de799ae2e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	bBOZiFZqwSeL4BQffCLgVpLVJfdfYFwU0RxjW33sWoNvBVjkXDMU2ffqw/mwtk5+oCCDC0l8ja+rHcmKsooOJt5wJNC8Gl/XThvFyPP3/+/yVbFt4sZat0o0X7BJ3TPmHzSL3qH833MT/L/U31bZQK7AeRW10W2c99U9nGLureSY4k5oifiAV9BqLkkjCcYRhZkYvrp8mjDExr/sidDklwSRnYLJvCfgQLc892zntboNSCIViq1w2WMXcRTjw6o8b0oL406XDLglNtw93JH+s0zyICZNwFPsbz3frDcE1A+59KAdncYQw9zADPcTDXJf+CqmEA0YEKv2+oPT+1rZlIjV35pn9Z33k7GQYJIdsIf3+bYBR2ZYd/MLd4f54MVDS32d1bOod3O1qAgQwA3DTtCD7MvmNAZYeHvPj/pzjGblsA9Wsy2CfBuiT3Ex+kt8yR4ImWzLdbGxDI4wqm7NK2SccSDIBj/oy1mapNibF9WrGFnYmxKp+YCAc4Lzcjli1eF2DagwgwLE7N944sSzaOMRfKj7XMjjAZFMLmFOqQ7yoD0RnAUQ+1+xzQsLaMa1SOTi55PUoVNb69s4OYauCwLMD/d/wBzRO9tXPnCWdi/O7FEu/EtqAve5fnXDyJeWswpqVa/GEqkKW0HyTQwb29JjRsXhJ06tRAuZ5H/LQxemxnCY+7Tlpvz16C3/+XbXMkrkkfZG9E1VXUt8YdmnmRfEVs/KTYqGk1pT9ET8YB8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9510NncPGk79JAukDQcGiwVGOdkSLtpsNklJexJS9j25sX9OLrlrVm8K0F1p?=
 =?us-ascii?Q?ToWxoJKqZKrxKiApyvyH8eXAXNN19PhsH0M3a3ZMC9XVAAfycitfs5nadyPG?=
 =?us-ascii?Q?kqrJWH4z01yB3GM4IepahTUvmZlzaf+nDJdigAUHRZIw7eg+Uflnw/xaZrrx?=
 =?us-ascii?Q?g83fQERmC26p4EnAQpniJRKZVnwsg4Hm5PWwcsjTZ/amaPJd8ivuiijLw7ip?=
 =?us-ascii?Q?+r7EDczi3dDhfNgoQR8ZRA1NwY8C5qAJC35RqTEasGsxw7JTkw8KiTLZj9pF?=
 =?us-ascii?Q?V7i5zckwov60bfhP/vQts9DHe5mV0oM9WZyETpVONuRHOCvX65vTcfp5m45h?=
 =?us-ascii?Q?VAmgl3JXJeaHiurBNo9t7UtQHb3PuAcbDfpZqPYLlS88EMl16D+J+0rsblYk?=
 =?us-ascii?Q?XhOkJyLmATglgr6j/cJCnX2ORvYUO6q6OUgDeNYl1JJ1rSyph/xGV+n61qVN?=
 =?us-ascii?Q?T6up6lDeoD9FAdA5QvK3E16PIoj2VfVYvxaPsL+WOkSq5F0Hwb5SmgV+LQJi?=
 =?us-ascii?Q?/fALHrU4xYGA9u6GbW+2+rxTS31A2CygqsXje/Xynj8r7bzbKLUJeGQQLjzs?=
 =?us-ascii?Q?ue1fPnZRaoLae0aIY4Rd2bF4K61E98+sDHJc5qzRE29UaA6jpFlS9DoZXIdr?=
 =?us-ascii?Q?6iGo3l1yLF0GivzZ+q5DrA062c26L8eBOMHNOsjhPVrRV44nIYFeGaPj7/yu?=
 =?us-ascii?Q?9waNymovhSXnmcg3BRkZlNVkVM83vcQ/FkKIKV2huME3/UsNJr0GgxpDo09D?=
 =?us-ascii?Q?HSQ+fViWcTEqtIwzlKJbtLoijdaQgUWoQXDfVN2eDTH3kHM1pFpYnC3KtDPm?=
 =?us-ascii?Q?wwtw8iC4elVkQsLNU8VzmflNwCTJWsD/EYPtigVNupx+HMONXGqurvtUkhGp?=
 =?us-ascii?Q?01eUgNyKDWItig4vV/DS/3ivgo/AWIClS2IflMbRjkdTFzFRna+2F4KYDJYj?=
 =?us-ascii?Q?0pL0T9xjmzlGPUFVA37fl6SaIAb3JcDCkC+ZDGeWyKalCSmxb6uSsvUT/803?=
 =?us-ascii?Q?EXIa44msCug1do0H9BBkkfwsIg9ZgmhiIHB79KOKBIGbdVqkgB6M/0gOu0Bt?=
 =?us-ascii?Q?gG59l9QfixqVuF8bE02/XuEfO5Lqi8yRhsFvo4wQtmDR9U1W/yI+KebvI7vg?=
 =?us-ascii?Q?26SxCojs1/G3HUo0Y929UN2wKkcveTGA+Cnc6HjA7fpgUZRfZCXbYhP27pg+?=
 =?us-ascii?Q?YBtSJDJ0dhkFc7bcbD25poF0YPn/BjnkAWNR+NLGvfRS4bYDkd7VBMtNnmtf?=
 =?us-ascii?Q?KpWYShMTO1by/HxK/pcYuTIzYUDS/FR4YiErm/82nf/pwFwVc3NYQBDgwek5?=
 =?us-ascii?Q?St5013SEcjibaMD+vff7vRCcjd6Ib1D9HRCQ3QrqCEI/YqwkQZkd0V32ELH8?=
 =?us-ascii?Q?UxcsXPfv9XoGpYJvNXLyzhyfy5YTrowAP4FSAGf9+n4xd8MoXj9m3yxZOzls?=
 =?us-ascii?Q?83tme3e6b4dtQttt6btIv6vqtNI2lR4yAbIGjFwWKeBKig0XgSnF+1QsTIT6?=
 =?us-ascii?Q?HGF8b5yeinLNcQB4TGoD0iNEkB+mHgzsHSqpkv97vTDiSc75M1cV4J8nUQlf?=
 =?us-ascii?Q?ITb2KZ9U1Jxh3VucTf3P8E/mADVjxALBcS3BUWvN6O6cbRE/PZfWb0feZmDU?=
 =?us-ascii?Q?UJdXTAhlYvh5rKdheRh+U5Pqu2c0hM7mSvVdm+uQn20iBrZyxjbZnZ6ciFUA?=
 =?us-ascii?Q?/1nb+LZy2Zo3Qu3SyaF3avIJpyz8p72r8KusbWbHf2ULtfl2tQCuBnEMWvju?=
 =?us-ascii?Q?vNoIWLyqCA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MiDVWGm5S2zFFPN2sO7IxxSpE3rOD3piDudYLAwfQ8AZUxurEnZvdXv7fDE8IoiSkM+3CROMk3JBQytav3FBQ9nrwXUCKlbSlEgp5d31kH2jU/GSL7ZckOdFCgy+Z1Gz+rR1ctHggnUqrJuMa1AoLxEtNtDxxNmG/TJr+e8sbECb7fu5Kj7sUTFKgujHziSzIbSR4br6C5wsnPBkWSVigQZyzh1QdD+UDVOlW/08x70iVp0cRMcU/I5JE1TbPnjdwwC7AMKA3DIh7+T0iE4cxH1oh4p99A4dikRr6g7GszL21EPGlZl8HUe3bCbuuo409jpJZ0JDTKaMHGKweOpUx6lDj7WXnaelrJH7dsExIZp63PF80XVSCY+sqUl/jsYDK4lQ4j2UEHH8+SlSgV4u8ZtzttTg5uO3ZaZ+oyzDMg8uly+wZgiXU+loDmMhh2X2ok/r8vO0YBvUveIy/yavbKvjiWv5n82Oq43MLhbms/iBY8+2C2lU3vNpb7HUKBjsazVnCKOjRX8SEYaRy/eZyG2aQQ8XSvRHwEjUWxKu0lpkyFXq0quSZb5DZewwBEan+6yW8iUkCPCKHDK9sFtBnEUGPqvN+UeXH7ftRhu97WI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3257ac8-24b7-4df6-47f2-08de799ae2e2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 03:05:27.3275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UeV6ALrfsbgk88o9zoiwGZ73npN4kTURiOmUVI48aOYnKiFPf5FmiGqjE9cVJyCX9SU65uVovaXpCjDv+nAJNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5985
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_01,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603040024
X-Proofpoint-GUID: 0kt5XYqmejg_YmstHUt3MBtFeoaysWTq
X-Authority-Analysis: v=2.4 cv=IbOKmGqa c=1 sm=1 tr=0 ts=69a7a17b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=_o4rwPvblE4JVLxn1T0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12266
X-Proofpoint-ORIG-GUID: 0kt5XYqmejg_YmstHUt3MBtFeoaysWTq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDAyNCBTYWx0ZWRfX1UnvQHOLDs/H
 ioJvypegg81caUc9aZy1NVFBn6AvuUjRYHiRtcHfYrZSWBD/F3hGPgX2RYLirU6q2z+b84P/Poy
 VG5Q4DtRouw8iZV9ipQkTR6WymzyrC+Asy8TT2mUQa/abHg3I+ZKnrgfZsFbH1cJwII/tSYUZWN
 8/vYBLlgCoU9DHEzOZjiQKefujooxI3bf1P15xOJBMCLlmlf/t/ZWTF83/bsfvSMlT0uL+9uC8a
 bRIZcuKCLC7NIdoQmW99JDkHUlArM2dlb4GkFpm2WNsfwvii/zvqOKT9J12mZp9GDunB+DEQ3dB
 JZID0emhX8Xh4pfI7F/2v7kNn9OPsVD3V6ful63JG3v/bVO+0GJjVet7dRZr0rLmhIGOha8dvvv
 5a4GfZyDyzquq5NBIenzGPIJpElN8RZ/05MQrstYfaaiExiyWjDm8i3XyW02P/PIczDsRgT1TWo
 5M3kL5bE8NHuGE2/CNxdrI8xqd02TWCkVvnJ6BDY=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD0911C0014
X-Stat-Signature: 1ucs8idy7oseay5qmhdxyfwb19e9h17t
X-Rspam-User: 
X-HE-Tag: 1772593536-192131
X-HE-Meta: U2FsdGVkX19qXmqX3IjJpIyiWUGXw9Q+6TmPQtbe0CHb3SY+phc+oz2tzlmL56KVW/2OdsbXke+Is6XL/N7e8a6w3K2k07wNI6gPrqPIR++VVYN9lW1m5gWGIdfoyadEfmMu6e5TLO/gPDmFmPpJ5VHgY6z/CGa+/vU1urQOsE/Lghp8BOrcJV8SyJq6pIcrDd3ZDwrgEJm856271/p/sbkCISoifn+pjq9DgDuvxhFsKILmJPgyOmk15xNmtF+La6HDOZdVN839HAKninCcYfjN2XHq8FNDMflk57BsKHtqF6hypXI14AYQ5JIbc+poGnH0gZZVs19pBGDNvV0NLMUWghO62LszAog0G+iPONReXdRmyjVKI+xXAAxfVm65brFbvI0B2W+aCjfuvl1wKHtrkY/oYknw/CO4pOp1mdkDb7lT1bl8HTN9JL/8T39+0Y692H4+3xfqYVYu4kwwmXoeWiBAr56NFGHqLUm4Ip2BrMytbhS494EdX0yrHDwXGz9xMJCF0jjadYUr0yQC5xiG3wyjhQic94+9DVWdNaFpm4jPawK3AyQXDUJHs2gXEe7FuoQIwsBMm1QSy0BPe+u45s123esJuQTTWvIfs+cTsci3zyigF9qMBWe2c+v+lN3CiEtY1NhX/siwNruv07sn2kkbrdGie6/FtHWsgG3Q/fAnaQlDc0mMgIrh3vyX/MtA7DRqTdVMTnWI9+2o5Q4MXel4FMCeFOXcB2FdX6XFRpUbTZZLhmKfOXJ+/f2FIwqWUkNP1cuNHHa94TBki8LJzyYlMfzWwITJZ7zvN6+kcxGPZv7Sou41+p5t4BN29UTtspcW8QyBipS4k/nT8TFTGUNIPezjRKgc5G9SlXUtOz1jX7D0gyOIRFfwq/5ARkV26LFDOvuqQWJ3WwWw/rmjMVvSL5OEElqYpUa2YqaQ4dcVPYXvAmo0Dv8gqKjhXfEHZfGD3jf0TgAinjv
 mQxUjLK6
 k0e4MhNmyU0t/smjJcgvT1hxmxPL2nKmbK3FP6cJbR0lqZXDzZf05WUR5kJeMEBcGRIyqz2/AbNF5E9nWpRpNlbIFnnReL7qQylxiGmSJPOJImB1hIIEzqUNUt7L9o3G6hnnwlroX0U5ZwMAbpTZM+2RMWNmk5zUaAb2q82mXjZWb2H/IZ2kqfewx7c0rT93ricjzqwRRSA75qRg64VPzYDprHqwz5QFjjMW4gN/ADEFTeUCX/JU2pA/vcOZOtlAoWWT/9SmTRDzrpBBIP/s8ZVYOQzP+3rdgmL7bvvF43k/82Id8hMOe0zZkcL8n/212li26f+xVepawFJvqNONd3LWuIiezzyA54EYI6upFxCeixhA9wvTvQHVcq3x/g2d1LLAYu4NpidU3hSP2rcjV9PuBW4XjfZLswysC6G37daJik9PCjBI/B3aMR9T4P92+gmuubGoYXpdOGnLbnUdTlVcfbZ6RtugC1S0SucDXfD4urFw1k+N9H+3YW6zJuWeoK/0TzcgGB0aVH2SOE5vqGXZumo2EVbNGgYBQPQSaOwm2iE1atE/MslUHEZrY86i28VW/To+7rtvQ/8DIWIIr0NV5tvXvvXmukjcyNCjjLl0qAlUut/FVpN1QfSJzPOfry0y2Dqgnd2na+IDPwA1pfr8FHHtGS0PrOS8GwReYVGIwSrLyHSAXw/iBjUQ63SyV6TnyVVeBlv1PU10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:55:37AM +0100, Vlastimil Babka (SUSE) wrote:
> Ming Lei reported [1] a regression in the ublk null target benchmark due
> to sheaves. The profile shows that the alloc_from_pcs() fastpath fails
> and allocations fall back to ___slab_alloc(). It also shows the
> allocations happen through mempool_alloc().
> 
> The strategy of mempool_alloc() is to call the underlying allocator
> (here slab) without __GFP_DIRECT_RECLAIM first. This does not play well
> with __pcs_replace_empty_main() checking for gfpflags_allow_blocking()
> to decide if it should refill an empty sheaf or fallback to the
> slowpath, so we end up falling back.
> 
> We could change the mempool strategy but there might be other paths
> doing the same ting. So instead allow sheaf refill when blocking is not
> allowed, changing the condition to gfpflags_allow_spinning(). The
> original condition was unnecessarily restrictive.
> 
> Note this doesn't fully resolve the regression [1] as another component
> of that are memoryless nodes, which is to be addressed separately.
> 
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Fixes: e47c897a2949 ("slab: add sheaves to most caches")
> Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b1e9f16ba435..17b200695e9b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4632,11 +4631,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	if (!full)
>  		return NULL;
>  
> -	/*
> -	 * we can reach here only when gfpflags_allow_blocking
> -	 * so this must not be an irq
> -	 */
> -	local_lock(&s->cpu_sheaves->lock);
> +	if (!local_trylock(&s->cpu_sheaves->lock))
> +		goto barn_put;

My AI buddy says (don't worry, I filtered it):
| When local_trylock() fails above, the function jumps to barn_put and returns
| pcs without holding the lock. This appears to violate the function's contract
| documented in the comment at the beginning of __pcs_replace_empty_main():
| 
|     "If not successful, returns NULL and the local lock unlocked."
| 
| The caller in alloc_from_pcs() checks for NULL to detect failure:
| 
|     if (unlikely(pcs->main->size == 0)) {
|         pcs = __pcs_replace_empty_main(s, pcs, gfp);
|         if (unlikely(!pcs))
|             return NULL;
|     }
| 
| If the trylock fails and pcs (non-NULL) is returned, the caller proceeds
| without realizing the lock was never re-acquired. This leads to accessing
| pcs->main without the lock and later trying to unlock a lock that isn't held.

And the analysis sounds correct to me.

perhaps it should be:

if (!local_trylock(&s->cpu_sheaves->lock)) {
	pcs = NULL;
	goto barn_put;
}

>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  
>  	/*
> @@ -4667,6 +4663,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  		return pcs;
>  	}
>  
> +barn_put:
>  	barn_put_full_sheaf(barn, full);
>  	stat(s, BARN_PUT);

-- 
Cheers,
Harry / Hyeonggon

