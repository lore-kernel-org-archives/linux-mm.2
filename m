Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D8BEC047F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1A26B00AE; Tue,  3 Mar 2026 04:27:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EDE6B00AF; Tue,  3 Mar 2026 04:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5394D6B00B5; Tue,  3 Mar 2026 04:27:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D14B6B00AE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:27:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2DEE1B7503
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:27:41 +0000 (UTC)
X-FDA: 84504224322.24.8A70ED8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 540A88000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:27:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="pDmB/t8r";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CXQcyClR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UamgVfxNgQJymEJ2ri8JW6MniVgTv9BZSuTdYMJRQF4=;
	b=i7nc1bUHKWbdI7+OvJb5G9NtJWJoIylPqde7+Mbsl5NuG+FND5zwvshkoQ09ZV5UTnqH9+
	aINDIEhYdZ7B9lqxXF2e2NFIMTkCk9QJA5nm7o+SdEwFgdx9wKoj+RL0wvH5XBe079B3Da
	hv8zucqzbmFJCEc19LkvZ1Uda9EW+TM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772530058; a=rsa-sha256;
	cv=pass;
	b=ldJutWnu2x/Omw1ajTyaVyaOJlSozEwIJML0pDSHjz+dkm55O1lgI2KFUK/QBlBeoAxoSr
	pIMt1yWXFr2aVaBzBnt55s5UvNrpLZ1gsQWolJOeESp6jkHaOh8WVXr7jjg80ZM6AXt7Ja
	In3+69V6IKCUyXz/pEnzQtIEwjZDP0M=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="pDmB/t8r";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CXQcyClR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62392YBx046579;
	Tue, 3 Mar 2026 09:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UamgVfxNgQJymEJ2ri
	8JW6MniVgTv9BZSuTdYMJRQF4=; b=pDmB/t8rYti1zimpO06MzgjSnQTQc2fkHw
	k80+QcReKoyL0ld+Nw29HnlD+RPnioN1J3PAuTGNvfz8J86XoG0nwwy0A1K+h6Gj
	Sa3W7A7Ps21CTLJtoaXi4RHbf6Mi/pXo50SvOHXghPqh8uY9uVkF3YOse0yZORp0
	IumlUna7iAK6HjTXEWA+hysfEhOIr5VizVHHZSm/juMTbZAhOVSrvl5QnK2OOQd9
	TL+/moHwcIlTmss6frb/lMUVStemK/oKeJ4zRPzvdOPtku2jECUcTIH6xVUCLhz2
	fEwjagIUQyTy+zAfiBG+cdDMC3PUaANqoq4dWzyIgIoVXYW6Ykog==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnvnn80yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:27:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6238rqBc037736;
	Tue, 3 Mar 2026 09:27:36 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt9ttan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:27:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H9P39XkdqhdZd9BAAp3gyv2ivqBCLyP8h1zxzT9f/JmSuCisE8jL9zFDdc+CHJjEgoarn6ps6zKkvV2NjP5aHhWwc1BM7X3/g8yZgI4+nY7eSHydxnyS5Y0G/xsGfcGGyGr2uW/63Gvcx7nHmeEsoMJKPNP7tiB0sg5JNMiROcI9MxOX3vOjODvnENuqn2vEv9iLHJMYtQ1kWMGy1vFKukcZSNwzr4AznOhhOcaRHVkh4i13xRmH212IO64pyZa3sSn2j3FVfxXbfLLQ+P5IUiaW/CStgPe/q55baBfc3zfk02xjhm7EHrBd/bnEPksg55zSK3TWPWAW92ZfujeoOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UamgVfxNgQJymEJ2ri8JW6MniVgTv9BZSuTdYMJRQF4=;
 b=q/sqz2KpbuQIAAzJlaIPux0itvCAaxlTLQVOKMTNR7dcd8QVLlzjjkni7vDOVAdu7+o1R1ybm6fWNVU0ub9cd97GCJSLJ2rqyR4IyL8WjSQamj7q3nF4B829TW2n0y0jgI/njg8VC9bPAx98b5+eZzMIG2hoiKB4EWv0aLTjxqwm7HGqn4uNTewBbiAztxdj36T+Wq8SV7S5MjSOUHCTGm0Jh3yAHUBNPqb4PSsfIGJkp2/spszZB7QeZBgh5lJ4z9AclgdMXdjT9oqOkDGKibpBUN0Q4m8UKlw4kgNuIuZxmSUfA5AdneMfeS0HQvvhXeyqKfRYmrgwNVXu4MNyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UamgVfxNgQJymEJ2ri8JW6MniVgTv9BZSuTdYMJRQF4=;
 b=CXQcyClRLix19P4kr6jGfZoAAVGlT5Swu/yXsTJXZ3GVnAdsvN7MSMGFG3AXO+8eXrCwGb0an8M3mjIx52DJmCTIxz2Xh7KZsBM0SAp04Zt9pIQ7febYCbCNw+hd4L5HnLrLSjrAM7vpu2rt9ZTXrNtRwl08HyT/hWjX7/Niq6c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB4882.namprd10.prod.outlook.com (2603:10b6:208:30d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Tue, 3 Mar
 2026 09:27:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 09:27:32 +0000
Date: Tue, 3 Mar 2026 09:27:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <597f608a-b253-4594-bad1-9a86b772fd2a@lucifer.local>
References: <20260225232708.87833-1-ak@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225232708.87833-1-ak@linux.intel.com>
X-ClientProxiedBy: LO0P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: bb68310d-617d-40d7-b082-08de7907185b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	iAlBUXJ+6oXbM8X9VkPoqCLrLlX3A5PnR0Ya6dCkoMz1TrCmyaqScpgtfCdXAeGyNSx2YR6X4cB1BHLALznrRAxpsdMUxEFTA69miViEdWO7C3XEzVJj0h2bZu1IJbZMkRRe4TZEQN+26dyawZGUJekAdbQOL3pgvQnQ+tL8Ifv91LHJuCx5KlFU+zQxuSs/hMn3XEhbH5ssCTS6lqR/D6nreNBZD8uMJ/OGvyYbFD3mOM76fg9c1JrvNLCzYQ1O3QYw6obo7KtP5kKe35Ta78SI2FoPQf9Z5N47OmtdjMMFdAkdEWqfbL0F5ENDPk++f+FC5EexPvIYjbnk6E9DMRW4dmM8+9o0lS/4s8Z14++GLyG39CIvSwr2r5HUTy7Y6v42Xs+Yf4LpS5ygr3aZl7FtigfN1dvS+rkHhJwBojAL5lGwbzYV/a8lZqwZupJntj64rlaZGQ2iNgnSLjGDQGmY0NgNrcZa/BitwPa1ghpum9Y3r8FkEWDzp9xmcaHCWGZWUTUZP2zuB4hUhZwU4hwdLpQOEuhlkSOcTYd0QXkeX7akdCs0xZDht0FRhAMSJzYJjQ2UNI2cV+wq3Yoa5gwskoLorsOoL9ruY0ZGuWHN0Wdf843A8hJfllUvlUHreErcQFTfDseDF9H9mEzLdnPjITGwuJLsW1GWcPKuzbfaVZiaOZGRu9jyqKwiK66Lb879gQaHoMIgfWfsuMN1vI+f7L5AMFYBS2UpIajPg+4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kV3v/Tr0XTMmGsLOYpIyrPehC3/uZqSD4xIJeEbXo7uLQRk3MoZRxkuEpFCt?=
 =?us-ascii?Q?i7OQFFSVZ7z/ykkRW22mlwBCACIt/ZA83P+9oFdZls/2t5iMkt9pFQk4mA7Q?=
 =?us-ascii?Q?Nj9X/jwVLBDUoRiUbVeePTSPYzlvAwH47Huyyl5yjpnr0PE+1eEF4IQoYurP?=
 =?us-ascii?Q?Qrgh75B54PGVlc5yoTuDdYExE53ct2KK14NyQWJsTzSUDPy2oPfqX/9Z31zu?=
 =?us-ascii?Q?T447CGQpVV0HMguyh/ThWNzfdxoGcK/eHXJZ8QaouJoJv+Zr3TU2fzcgTkbK?=
 =?us-ascii?Q?WCCJhkQM6fMKMdQqsUkjkRTcD3f6r6tASKkQVbEFdD0hrKzmgIl4aA296gSG?=
 =?us-ascii?Q?DvJQHa/veNVeHGBi1HL/d/BVO7xTsJGMNPxHyUKrzLkNXZ2YdOxWoAFN0jz1?=
 =?us-ascii?Q?Z/hj70hMSFIAyKMpJGY9GP5wEcS/OmJWHHuAZUPfcMzEUT1zY2iTwuTPIDHa?=
 =?us-ascii?Q?MfnXtjp2bMaT8oiyfxQsEMH0VVfzIiuK5jVQIRzdyDiH5zx1N2xF/W4Za7qv?=
 =?us-ascii?Q?7g0X6hRD8JxjnXZFGInsobSJAlej/sUEIZbelfP652Rasa0OMvrNGMBKV0/8?=
 =?us-ascii?Q?zBgqowS07BwQDm2JZ8G7Oo99ElHf256NnpvlbatW0Y4/Q/3O0F8/E290j3ga?=
 =?us-ascii?Q?3+2wxtg8evQGEJSPax1pr1vVvChGa+K7M+kSwRfsdL/uNmm+7RSmCpxIT+vN?=
 =?us-ascii?Q?5KP54+mbh4oVgijnInAUHF65O4G21k91uQ4oslACPpGaZ/p1gcRuksceJ7hc?=
 =?us-ascii?Q?49LBHxzRZujh06FLp3XYAKV3Drhw0uBWyf8lPi95Z2teCb7b9ul4oX7KMNNn?=
 =?us-ascii?Q?gvt5NipGzeje7NoHXgHBH3QMpCEvP4vEHVkSLfFE0T+TUsts2arImA+T0B6L?=
 =?us-ascii?Q?qWzfbnQSCuz4QVTuFake4DYDuRkLVH5MK026SowMjQ8nkRgsVDV5Z3fewCKT?=
 =?us-ascii?Q?hX6wcwIkzlQjqyMuu4AlqUiRRnAFAkypCuctq9sD+8Pk1D1nO+4wdsmMJOJ4?=
 =?us-ascii?Q?STDvxm4P3WHCT0Raw+Nxbm0pbLGn1l/RRonQvORZ5Zlh8splfL5Tf2Z7Vyg1?=
 =?us-ascii?Q?oWkRi9su+j8Slr/IhuNePsq5AsQ9OTSg6OrSry/XsB0eOmm0la+LkdLcIrfH?=
 =?us-ascii?Q?xDK3+now1sfpyYIpOxtZBrtE3fsZ7XORKOLye37FV+NSZNwJjryFi4MLL6gT?=
 =?us-ascii?Q?HDFG09sdsmwL1D3YyVMkoJlPElC/qaULGJ9muPPLYC3OF8ePpodmLKla4/5i?=
 =?us-ascii?Q?lVh2yEOWuQJvcnZ11dlknXZC09sBGQATF9190e8oKB9f17gSx/w3s2DFS6H0?=
 =?us-ascii?Q?qPwfJE0oeC5p4ygHHEk1cU83AVZa3Dp8CZNfHualSuAiMLS+KtdqHCt2DgiT?=
 =?us-ascii?Q?/uPgiWCWhBgmqkG+sUHBWUP2GKXoXMPsbiqvlfDxxrPDnynM5TPCid7gShYS?=
 =?us-ascii?Q?b+Hjc6tpY3RpsnA2vLy3QrDZ7spWWuhsxlnmj/yQLnDCG9O9VUAsmH1xGfs2?=
 =?us-ascii?Q?ZS9vbwXlAssQJBFcn+PvIMBIWqftgZzs3e3bmtUwJwFY2FYO2js6zA3hUnqA?=
 =?us-ascii?Q?6v4S9wdvPzoa9bd4iDhAHcHHEuw4YebvTvPeluG/xAnnfVwNP3kU68zyIU9+?=
 =?us-ascii?Q?xWFJMKtGNEQcr4wUSDYDOrGeOnppU6is+Dho0ANZ1BM2Tmhk8F+mufC3V0B1?=
 =?us-ascii?Q?F2yP1PyCdcxR54R0UfAxG2rsAi9lNmAKtXcTvS81ACybaQb3Q3qDwRnar2aw?=
 =?us-ascii?Q?ztsFh40FSW9Us7r6WGVbZX0Q1VQ6wCw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gHu+7IkhpOnVZWYyYTVMdtIOKOfIVX1q/ujmOsqeKE6k1Zp450W/njOZEr+jbti8bb1REN8mhyV/misbWyg9A6L/9Noq6mSi+HQyCcCbLsSY/GqLl3AE/zRNiwfo0T/aoOpl59UzbJWcUy+usaJUz89J+Kyq4qE/G56rOeTE0xmMHWu51cXZHnTFt0mw5sj2IEBL5/YghknMilDieVzlmq4ilMF4CeHyWbazXyzEdZb6CBM74OZ/TM18yHkrVRWSOCCAWlH62+f+EOHIik9d96r8LSwh5UoZWsIt4UIC+UmxEs0zhb73JYWiV9veLoOya90xNTwjdraU2f0BjeUeR24nx3sdqqL88ttIqfR41TRgVCOOkeT2CxwhXqfpPLF6h9mMmtilbV0x4vaN1jITG7gsBtwnyoK71Ug3lIvOEX6XS4yyamxPQoi7ABH6WNSR43YiR6QzUNJBSPjb27L/CkHLKjTFmPMhnh4Gwu14gapvS+0mKXxOjHiEcd5KZnkXMPTVZOI2RIjrnhCrdvQ5gIC2bjGeKpnXrAJlomsgIfzj4pXXBlBmX8ojzpFZwUpNwjAnLjevgTl1jIyjCGXeHxOaOhDJZi0F6eG/WPbpalk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb68310d-617d-40d7-b082-08de7907185b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:27:31.9576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDHCsjJ+4Se4lvDodmJvEotE3benZcuQU9aUZqtqRtiLIhbVOm97/sv18yhjM8ZUQcNVHYSbPTWCB+UwP9SRBYey9czf7bt26OO4qU2qMRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MCBTYWx0ZWRfX6VBO2DspDhvR
 dj3CSC6dqfPugHubyKfEsKXnFNR8dwc66KlVFee5jGGVsI/H+IdWWAreRUvpxFwQ5XzMxfy75Fo
 A6dn0Sfdy/xu/JtGggRCRUUY+07+nFSEzLeHYEku1qlKN8eoSmmBQNmJo1cTO5jQd6hu/IAQWdt
 ga9dMoqeHnLcepxOffLYXsstLjIlI6zb6FWb37noytW5ALmO0PCV6tk2OubnmDCCye2RF7Pg0M2
 IfQ8sWi6LKhc0Y7f5RUp0JVYDNyZYZLE1xv0Q/if49skswFQ9Si2zcl5eDQmJmW0OjuClTD07Cg
 FE3PZnOpUnAGc2yHmDulnFs1P4imSAwdUIf8lbs8ir9ZihDiZ2HGqtKcwGV9kUnRV8haQqQeT4K
 tP6me+lZVFPfqXfNSN4Mhufx+wxVC7NHUExhnTgFWnCbhrnN6nscr+BzttVvnlk+eT0lLajEjm+
 ljfOiYT9nomW9gEGCIQ==
X-Authority-Analysis: v=2.4 cv=P+k3RyAu c=1 sm=1 tr=0 ts=69a6a989 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=QyXUC8HyAAAA:8
 a=fu3ulHGtE-zrcToToVQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: BXVzeSoybL2lSMpGApo8l1mkX07ViZmC
X-Proofpoint-ORIG-GUID: BXVzeSoybL2lSMpGApo8l1mkX07ViZmC
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 540A88000B
X-Stat-Signature: kp7ggz114wq41tad5dx8qt53ki1aatn3
X-Rspam-User: 
X-HE-Tag: 1772530058-532926
X-HE-Meta: U2FsdGVkX19R3sG6joeH/Bj2ZA8h/l5m30sxSHv/JHpohpudoao4xh58ygn79G7SgojJPkStNtxGdi17jGOwekalXQbFi8UNvukXZFPudsQaJP/D/5CPthQPgph3q5d9/ExQiDD0DG3OuJNn8vRdJNKX9zyrGZ79LjOVt5LONIUPK0McrMwC+5siRwAOCHqH02HJW0+TmhwyYomluxAcqp3B7r3kq+v8rI8848Sh7WUs+MfIYGl65VQsyjhYT8hyGgO78sR1btFt2zNzl2KjWhoQdrrc+EGzbCUlAXIEdcy643SmT7z0FiUwPxKQXNJsAh8vXKQFV65NnsDjMfvs122FDUht6x2msjeMKHc32WtHAD6vjT7RhT4on66jLXoT5GfxTNfl9WohZtPHZP1jpCc3Uz6mN6LGcNJlpM607p9i3qZUpclpOcrczpW6Mt5mpsONRBAq8NWQHoZ/QV9T1eXAVsGBmVbAuIKSeQhhp1A53bzXcEBRrQ1H8yNcjOO4KB5vBazSWQ210ThLZr785ihN6Uj0PGeHNG0/mNO02KRl5mICsxsY7zm1zRWjSOTnaG6DWNX3K4nhW9V1P7wlJpa5m0ODyv8KOEvPGtdkR24bHusyUZ0+NK77rMEfF1BH/zPGGd8fM2RTk4NZ3XBi+s1dKlOMWpzNazjWVhS+MC2ikfLjK+aVvZhRJSwfqkbLhrgS9zCFcMH6OW6V0aZJjB9nfd6uBbz87/mzDQ7WSUu9MA6vUAj1rwWSU/bO68ubLqdGemWD0uxxffiLCObV3yW2ly2/uPzqxS60H4OU74JqaENiLMu+p5oClwFYf1GP/Hc5f5gaosIpX5Ebsg5kSpfZ4O83v/crDPl78dmSMi0InSz5GEW4AEoIByIZO/alted6A88Cb8fQ8hWzYr7gXc3fYQgO99JechE5bxy3Uj6etn671isprjzuGRez2QdYQiq8MOVNJ4vIpNWNidf
 1gspK905
 Sw7NoS0P/17VM2XRL5uXMbIQIc3UYF/GrYZjKHSiBSAHQNe91tXygSaYoyTV/bGD1pHXc8tWeflJTPiZG/Ux9Y3vBJlCzu5ROoT+vOsMUxhVaIZxvGXOc9hdLIT0mKoyyWSuaoUrhqLUIoUPLGcSdNm1tHr2LHBNp429x4iRpn8daAp/r45pPU673aySt0+lNzlWKnIbwngKJTVh9OmV5KPnuTR5TE1z/OEI1HmtaDMoF+mNRW/djB0yD3hElSFU/fIuYJwJBIEllJO0Q9DgxIc90iQiEXGppXVGz/Yw9NnOWY4By4/Hhe+CKVTiODWsN20sc9IR6OXXlO/LwQf3wCWypfGFNglYeinKtVdvOKsl2b8M4ZA/xQwAbHMM2m69TPB6sfpzVa7Lf0W3EuHKR5VKvLNXaDu/Qc2u8FUCzhoiDSlYRkOtRNYy/lvIxUubEM+7vopBgZrK6LDUDaOIXoPyNjhdyi9dh8mvgcdDcVjxxxgRG5qOd/Upb+MYryhFqtRaDSu3K6ekPF/GR7Xg+Oy6IK+ZjB0NMjGIu71HylunNFmVkZEhdfs8DC+fkl7NPmhn1JJpdfcGJvO2HEFzTtxa4SmSD0gM8vDhNlMrhWYnbc68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:27:08PM -0800, Andi Kleen wrote:
> The earlier version of this patch kit wasn't that well received,

Nor this one... NAK!

> with the main objection being non support for mTHP. This variant
> tracks any mTHP sizes in a VMA and reports them with MMUPageSizeN in smaps,
> with increasing N.  The base page size is still reported w/o a
> number postfix to stay compatible.
>
> The nice thing is that the patch is actually simpler and more
> straight forward than the THP only variant. Also improved the
> documentation.
>
> Recently I wasted quite some time debugging why THP didn't work, when it
> was just smaps always reporting the base page size. It has separate
> counts for (non m) THP, but using them is not always obvious.
> I left KernelPageSize alone.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/filesystems/proc.rst |  8 ++++++--
>  fs/proc/task_mmu.c                 | 14 +++++++++++++-
>  2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..c5102ef7a2eb 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -452,6 +452,7 @@ Memory Area, or VMA) there is a series of lines such as the following::
>      Size:               1084 kB
>      KernelPageSize:        4 kB
>      MMUPageSize:           4 kB
> +    MMUPageSize2:       2048 kB

I hate this interface. You're:

a. breaking grepping and probably userland, anything that greps MMUPageSize
b. making the keys a variable as well as the values (yuck)
c. Introducing a horrible Foo2 Foo3 etc. naming convention.

It's a NAK on that alone.

>      Rss:                 892 kB
>      Pss:                 374 kB
>      Pss_Dirty:             0 kB
> @@ -476,14 +477,17 @@ Memory Area, or VMA) there is a series of lines such as the following::
>      VmFlags: rd ex mr mw me dw
>
>  The first of these lines shows the same information as is displayed for
> -the mapping in /proc/PID/maps.  Following lines show the size of the
> +the mapping in /proc/PID/maps (except that there might be more page sizes
> +if the mapping has them)
> +Following lines show the size of the
>  mapping (size); the size of each page allocated when backing a VMA
>  (KernelPageSize), which is usually the same as the size in the page table
>  entries; the page size used by the MMU when backing a VMA (in most cases,
>  the same as KernelPageSize); the amount of the mapping that is currently
>  resident in RAM (RSS); the process's proportional share of this mapping
>  (PSS); and the number of clean and dirty shared and private pages in the
> -mapping.
> +mapping. If the mapping has multiple page size there might be a be multiple
> +numbered MMUPageSize entries.

You're hugely confusing the existing MMUPageSize case as David pointed out,
and again, we're simply not going to add some variable key value.

Also naming something Foo2, Foo3, etc. is additionally horrible, confusing, and
ungreppable.

You can use /proc/$pid/pagemap to figure this stuff out if you really want at
folio level.

And as David pointed out, folios can be split at the folio _and_ the page
mapping level, so a folio order isn't indicative necessarily of what you think
it is.

AnonHugePages is a better measure of that as it looks at actual PMD mappings.

I mean this patch is just a no.

We could do with a better interface, that'd be the better way to expose
something more detailed.

>
>  The "proportional set size" (PSS) of a process is the count of pages it has
>  in memory, where each page is divided by the number of processes sharing it.
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..8bfd8b13c2ed 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -874,6 +874,7 @@ struct mem_size_stats {
>  	unsigned long shared_hugetlb;
>  	unsigned long private_hugetlb;
>  	unsigned long ksm;
> +	unsigned long compound_orders;
>  	u64 pss;
>  	u64 pss_anon;
>  	u64 pss_file;
> @@ -942,6 +943,9 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>  	if (young || folio_test_young(folio) || folio_test_referenced(folio))
>  		mss->referenced += size;
>
> +	mss->compound_orders |=
> +		BIT_ULL(compound ? folio_large_order(folio) : 0);
> +
>  	/*
>  	 * Then accumulate quantities that may depend on sharing, or that may
>  	 * differ page-by-page.
> @@ -1371,6 +1375,7 @@ static int show_smap(struct seq_file *m, void *v)
>  {
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
> +	int i, cnt = 0;
>
>  	smap_gather_stats(vma, &mss, 0);
>
> @@ -1378,7 +1383,14 @@ static int show_smap(struct seq_file *m, void *v)
>
>  	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
>  	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
> -	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
> +
> +	for_each_set_bit(i, &mss.compound_orders, BITS_PER_LONG) {
> +		if (cnt++ == 0)
> +			SEQ_PUT_DEC(" kB\nMMUPageSize:    ", PAGE_SIZE << i);
> +		else
> +			seq_printf(m, " kB\nMMUPageSize%d:   %8u",
> +					cnt, 1 << (PAGE_SHIFT-10+i));
> +	}
>  	seq_puts(m, " kB\n");
>
>  	__show_smap(m, &mss, false);
> --
> 2.53.0
>
>

Thanks, Lorenzo

