Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E21CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748468E0015; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8968E0008; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C09E8E0015; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44E5D8E0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECC9611ABF5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:36 +0000 (UTC)
X-FDA: 83854845312.29.04497FF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 976BF120015
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ED8lWZze;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n2BO0zZf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7SF/uMykMvE3Un1mRktYiLIVwsi9cIpRglt4XF/BbM=;
	b=woahhnFx+VqjiSmp8iTLE/tYNuI7/y7/nntrwYtT8KMznyAykrIvfAa7wgUClwxLhNmRLd
	BiP1E1/H/QFz7lf5EX0fZ5XL32UIGG2a3gfpGR/FgC1USULj9+1IvhPjhwPnbQgcwJx17c
	3IlbxfqBHby410fLEqMIpliyg7wIZyg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757068653; a=rsa-sha256;
	cv=pass;
	b=akKPrOMo4drL8rMtSwFMR44VFroqJWPQKoj0GC5wc1F+SLHmA0mfbNB8Wmqi8sMNPDmqe1
	OXSVuMLMd8DdrOWgguqlFYun9tqrcgtcCFyvJVdtnFxa9sUFJQO56fqKHrwOhLTboaRdi7
	4y28TRJwH3wJTRA0KWvmZjet9osZxuM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ED8lWZze;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n2BO0zZf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585ANAPX026848;
	Fri, 5 Sep 2025 10:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Y7SF/uMykMvE3Un1mR
	ktYiLIVwsi9cIpRglt4XF/BbM=; b=ED8lWZzesWi7DWrjTdRchdIMDrWMzcGQyf
	YN1LTMe64/tg+Z00RQOE/J+1NeW+kIf1fEeN/Z9op/3r8qoETSR31a+MH48po39g
	Hpoq0XLvdUn5DmmsT0jjeomqEPC8C37ZefuhsOiM1PaMaH3N6Q2oCARjrBECe/xn
	jcB1ORy0lYmCGcWr2HytYQ6T6i96xbo6X6LcWZGqX91mSCen+nVR4s/TcFN6ZkOK
	eA7Vbkv+yMVK/KnqzG+0SXR05hhWhGsWyqnb5jViGIufT7nGk5WrripO10Jl8rDR
	oVPvoyszBN3QtQWotj00EJCwxmEsXEp4W5bq55/RRwCqNLTOSlYQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yx0u80uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 10:37:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5859Ja3x034398;
	Fri, 5 Sep 2025 10:37:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01s0g5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 10:37:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQ4zoDLbfkyaqMNkoKGVjd/bTL1wd2XWeaODsKfsZcwvhUU5X+xU/D1uzd1qIONDeNfCyQULXqt8qOkIY7eAhqSTZOCiF8DyjPnJtlW93cqxrigmOF++V8UWSydQLJpJu2YtGxCtiBGP0qYnudP9/n9VcGtWDTzn3Zuujgm2GutE7EHR2hGAcWnRTQbLP1tLWPODgRVQjZe31fzXZWrBXGGKKCCxM4vZ2VL0sJtURUI4IvCNO3nlGYcCj3yWP9INW8E82PA2k4sFV5zIOEsXa4TsSayL4XA42SV0VhJN6SMcr8hcAyA0KgkQ6RXOEtksYp33De5ZNbQyW2O3B69SSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7SF/uMykMvE3Un1mRktYiLIVwsi9cIpRglt4XF/BbM=;
 b=GXVFfsOUX/vd4ASueQILsS4qJcYsvkL1YV7VF11X183nz5xxyMmpOVeqYrYOglElqs55QlXJEsfNDw5k/Ty90HoSM8e0ydVBzNxbTv2mriwh1oGHp1CN5KeC1RZbZwdATYnDX1w8W34wGrYOSMhrpiBL8kg1+DSzJD+88dVRKA2UIRVEeR9cs+hN2XWHhW1ZVl2bFrJrIRtJmMBrqvcYOiPzKe2fyUpG0lRc9fHHdfoac0W/BcnWUkQ1iv0Iz9J3a7cuj6gQidNfiTMA+rg8J5yn9WPVFHS9CV+oJx3Fx9bSEFlG8MIIf9L3UC0Mslqi2cGUsNgmWpecUTYjCdecOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7SF/uMykMvE3Un1mRktYiLIVwsi9cIpRglt4XF/BbM=;
 b=n2BO0zZf/3ivkNXWPikDXu0hUVV/bJR+iZgaCj2C/fbFkA3wztg851/NRZYEVvRKrnBgrJnx6h/n5abyIWAFgy5fzWKxly8dV1l45pZG0Dzb0irEyyrGqaeZoPHtJFuwvf0joHqBldpzRQApmnCr630WchHuW8GrIj6dk9PAtlY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7175.namprd10.prod.outlook.com (2603:10b6:8:dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 10:37:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 10:37:25 +0000
Date: Fri, 5 Sep 2025 11:37:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
        Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <f229a315-8b76-4d27-97b9-6ec3103a36e0@lucifer.local>
References: <20250904175729.1029735-1-kirill@shutemov.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
X-ClientProxiedBy: LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 61bf1f97-f36d-4883-b39f-08ddec683422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+GYhuaomLTDHvgbDMzOXBktAaKAt8VbeThlLvIG0Oq0+OnIgxLpGUdmg3pSx?=
 =?us-ascii?Q?Bl0snouC1iYLw2DFzoykTNWPFslutb2X/0LyOvhjhurp/HKQC3RbGGjILF5d?=
 =?us-ascii?Q?c5BayrBU3sbsQeJcSA40UiZi136Vrru5GEddUDKEoLF99CK1aoote3LVij2k?=
 =?us-ascii?Q?RPlfxIlbNkj9f3rDxdI0jIV89+P9bJQLB+IjYo6Whu2xmsBChelv/Rn4L/Tb?=
 =?us-ascii?Q?IU62xtqXqHe/DM3fDR4fdROo+77fDRkWv1HqyFtFathb+UFLS73vTm5p+aqI?=
 =?us-ascii?Q?O7jRlY1VPDhlD5mUsmW6KFG/Cs204l2oPh6BIcGL5ZMpMsG4GpLZ4/QCvXYv?=
 =?us-ascii?Q?zvhS5j7IzI30pOdIazK5MhwRklX6uhDQqrIqGukd7aWHiTPOFqSU/uHKkiRI?=
 =?us-ascii?Q?desWVIESXgJ4H5em9N7rdrxTClDEbfOGEe0opwQyr7TIXhhcBzlR63y5Ce+g?=
 =?us-ascii?Q?a6hFRUGJW39j5keAyXUgd2smTRhhNZIsplSf12E6aU7S5PyedtZYgOxgAPEH?=
 =?us-ascii?Q?FoEs2ZsiGjlDP4Re7tAX/UUc4Nurkd0125JlDfsSo3TRzH3PSmj8rMbATMUi?=
 =?us-ascii?Q?grXb7PrWp/4vOiUU45/Uv6urip+P96PQmR0Sbm9gk3RlBlsNkE8KSiLy9P9c?=
 =?us-ascii?Q?5jLxEPXesfAi2UllgQC1SYUrdikVTtu80U0zv9ElZZbQGFyUjfA19BSgtkaa?=
 =?us-ascii?Q?FEP+dWLBNT6J5/2N1u6kgYa9bdc3PxhwFgQh+SHIBKdZzjPSWiUKTRsRb5z7?=
 =?us-ascii?Q?f2ezcIubriSUbxAlElNhV2OVA6VSaxGNVqDyh79EEgBqKF6/NQuz+xTPMd9O?=
 =?us-ascii?Q?ltaWcpKSkIbBtamJHzvxcvVtBEdjRYfCPNoBCl8okTLjTjWRkczcWudcSg7D?=
 =?us-ascii?Q?CcSKpnqSsd0ml6dmz7OEveln10aU/P2Wbe3SiY7mao0Xr8NcCLYxzIBKB4FC?=
 =?us-ascii?Q?GAbypLjWpO5SWdtuT9hTDxtA73Uvlgur6kSVNoTTengfEubCPPj/QuiiAQYJ?=
 =?us-ascii?Q?0NoXia3fsZ6It0Jv25SreNM3ywsLT0pvQ7KgX/EErgrClOUS9u+eFZh/1Mdj?=
 =?us-ascii?Q?yk1Ll2NZ2Y3XmbnBrs/5It+WAnHkSB0m0TdTAa6lJwPoJUXmepHEeluCjKg1?=
 =?us-ascii?Q?9S9sn47k1MtYPIkro5HpnPQ/ptq0tToCXNojOXOKn6fwc2aQ/yGjgI11ArEJ?=
 =?us-ascii?Q?8ou7B1mplGaH/mSvr3xJMKd7AS/8yL5C5pxDqixK8qtrtZ3EXzOJ1/tJUOB3?=
 =?us-ascii?Q?alvXK2DhH0QNAH6BIsSxPkBrc19+/VPaO2Ltu0Y0DgOrYckUcDyvmztDbrvC?=
 =?us-ascii?Q?YlGhGStP4yJ2pDRpV6Nh3rD6WNeRJlC2HAJd6vfPnNnblpFSdtzpFuYjvkUK?=
 =?us-ascii?Q?a3u5p0OSkcKbugMMvdPNNMUkCutSDSaKUZrPMk0LvOQ/4ne47lTT8583SgiI?=
 =?us-ascii?Q?fLcpY/JCBRw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ECO7ZdG679Ds6QO5/tmgqfKRsUhhwhQcRG5cMvqHr+6sayBOXDqW12Eyz6D?=
 =?us-ascii?Q?e1/6Qlzgb4BtsOcV7aKxQfrnln0NsLWA4p9b5efKdd9DvuO7iI9acK/hkyGM?=
 =?us-ascii?Q?rMzolgneh/1hqRVtj3lSt1FXWJUvDh8gDtwwRNi3m7Jtry6eIXkoJsJ7rr99?=
 =?us-ascii?Q?LmUqO+tHHOlCSU7ppTbEdS1+cewraXfgyjrh2RvXUeYjzJMX9cYWVOGq0wRa?=
 =?us-ascii?Q?VUZFXBSX00ZT9Ys+DHzRdRn5SFKnLQ2I4JoqwKaG74Wlnj1cs2jfYTvw5Pb2?=
 =?us-ascii?Q?XyZ/OG1I/MOq7YCoyseVd+u3uDvMVd7Ji/Wj+RVZ8J12yTlomqV4OVEpHo0d?=
 =?us-ascii?Q?NXQpx5nRfLKEz5K19QAO/ttJIUWyVw7tPiHhNaMjqs54ibD2P/TdGgWjECpB?=
 =?us-ascii?Q?04BLtapntnjBARXdAb6wZn44s/b3tTqp4ArjE75A2aYmxMNFU4H9sQmIYkuo?=
 =?us-ascii?Q?9MOnPX0uqzdWO1jgxRSMNFpnxro3DHtQduM9D4XTAm3EbxMXKKtPrbGUTp4J?=
 =?us-ascii?Q?01x7Zykesth83nWjXKyQGJnczoEEvthGfmZ7RKi3Saam5eeSmWKEI9yHSUy+?=
 =?us-ascii?Q?PUTljR5uFWOeQl92kviZJzg2N6dfe0a1/KxMwUyDeT6NaTuFWZ2YqhbzTGiL?=
 =?us-ascii?Q?JbXr4pCIOwC09gHqLd3OvfDCxspf+VV1e8F5PzJCeTkSiRMO/FLLzA5z6G9/?=
 =?us-ascii?Q?Yh8I4f6N93dpIK85d0ToGS+Hp4NdpjE0dWkRK+0xERC70B1fMoB77W43bdKB?=
 =?us-ascii?Q?Pl5g7sTcZOPYNivGFeySdVJx+XjYCtizPBl4Hder8re8MDaQwSkCMZyf3iW2?=
 =?us-ascii?Q?dV/9qyvpazdJm1rFhgM3nZ+wdKXOxlcuANDmuhTZTNbWaqXuky872Ceud/zm?=
 =?us-ascii?Q?hyb0sON7HV0HyZBC1VnAcCv8HbkPUaZIQzjCWWWNWrtGYpSRCHM4ZbAZEmX7?=
 =?us-ascii?Q?Q0CE9EkyHpaNfWT257uYxEuQ5jB+slb7iJhvCn4C6BqBQUjyzJTQHz4+h5B6?=
 =?us-ascii?Q?khr0VwgoHwzyM7PKm6wLtrXit0PzyQG6bNCoIFH8fo8nmhxbBKoO/unV8mAC?=
 =?us-ascii?Q?Fp4sKiwW734padQOobuJbKZ/Urb8b6A5bOBFXTXyAAsaLdg1XHIOi2mfYUZp?=
 =?us-ascii?Q?DGgqWCemccUZn+lSxD72h2o5EwtkUmD2UYytzhLKvu+OWeru3QGCATvQIBOj?=
 =?us-ascii?Q?yF4eyw4CkF2VknJU14wQZxXj+vu3oVIUSUfoGdMO8fgdP7rkVqtlo7Du0S0y?=
 =?us-ascii?Q?KdGGTse/5lNjRlXH89NsZwC41H1nTogiw2BIfesM4JstkqH+ak7Ba1fRxtsC?=
 =?us-ascii?Q?uJuRo/qw4FkkCUHCGvlvaMLcds3BQ0+8wVdswAfGwxkrx9zFYo8HxYXOl6It?=
 =?us-ascii?Q?pCPRs8BENzJhGnBbL+bFsuzqx+JkNcb00yra5QEHFeDlLWiniuUn0aQSylbC?=
 =?us-ascii?Q?2fBHKlic2fb7czxzcXob1BvVHNYTJQBGqn+qA9Z1V5qHTOgrgQmDfgJ7nvdF?=
 =?us-ascii?Q?JsRScj+mRY/FYFL/uxMu7p9du+MEzvxI5hgPhXvHU9sor2wGqrVhITQtbHgA?=
 =?us-ascii?Q?yq538sXYq1RJVgXyCJsQpT16NNRgsYRu+62KJyhJY98S15UBe+m8NrBYjzZp?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4xgoFH8FP3qUZsXJC2pdnWItdNIBnehZqSEwz+/xlCamPX7tPbeT8vXaFxLnkFdZSKH/FQCdC0608kMbO2ifp07rWXvsxM7dP+0HIcFto9ZLL8VhF4szr4+1pAk5dB3MnGeLfmb/7JUpo/Gusxgceenj21W+issxA/zlvT4aEWS88iWDjs89/dm9mTMVKciSwx+50ISQIzTDpod9ebmMB+AolQV/cmX0x0sNUKE4vNo6KgnmCUytQML33JX8tB6cei+T+MsgqWIgfDU023Joi47SDhiFDbzJCwMkAIC8FzAYUW8qCZivc7bCW3oW6JEsvWb3xgy2CKLfSkvX6XZL6pKJ6PUCCAmFiRC76p9BpTAZjyIIlXCfgafDtBk9q3kr+CqeIIeAYsQvhKcZKXQZtV7RxZPuzLbADYxNvxnHh+9wAOSCWFjdcaqyeLICqWXkbqYKqBU0P2sKnG2aTD1OAn/kIkpHmYbm4KBiH6kcEMKW/BMxfWCqLjkbrfdBKMriKOnid9TzQzDFDEsIAlpY5ml5Jfeg0kU2nRfIhi74eqQhI5ly8Gqkm48vA1dUlBticX5FRRpff9t1FhMLCLZGUgjoF2v8Bw4GqSHO+8SZ3LU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bf1f97-f36d-4883-b39f-08ddec683422
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 10:37:25.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jd8lFyUgDY3tdoPogoqySeO2hGZ7Egyd3YPi8tLb5YSvLxhgSjQr5edHnrgcZAK4RkDhldDKoDKz4/cpi3a17HtWMvgh8kGzPzPdEWeC1Sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7175
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_03,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509050103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDA5OSBTYWx0ZWRfX5CHDpcPaxDRn
 Z7owqh0dhWx//u6XlSeJQNvZih0hVPtKUjRAMWC9IrHCtI7vO7mtNQWZ+14/ccbEipTeOlg1PHr
 aDirBj4uLPqlZQOV6jJrFTjRmHSReDV8EX12NF+gXwWfcGj2zqCSNa2vvyfbAQrVJ47rQkGX1f/
 J7AsAWp0Rl9BgfYQh1wUdu/Pwb9YgxMZUxks3E2gV4SIEwob2v+4upiTfYp4emhY7AOMc8+lqcS
 VdidOYMa2n++zy3APIC8AJriar8oKYyzBR6Z4bhEcJ9TeGu7IlQMpheDoxu+wovchkbm/LHrs0X
 9/Nf3Fb3ilau5I6iDWLQUc+IIZ9WRhGHvgc8wQqd775ANVFWpOTpoWRsX/PA4GD2nYS4sZa3KT6
 7huc+Rb4
X-Proofpoint-ORIG-GUID: Bw8S7wuNQyqzG1P5evx22WcMruotyBBD
X-Authority-Analysis: v=2.4 cv=KIxaDEFo c=1 sm=1 tr=0 ts=68babd68 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=JAOYCJikig2dim-R2NEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Bw8S7wuNQyqzG1P5evx22WcMruotyBBD
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 976BF120015
X-Stat-Signature: patf4aojw6rn7crjyss8omteu44uj46j
X-Rspam-User: 
X-HE-Tag: 1757068653-720569
X-HE-Meta: U2FsdGVkX1+QuIjKLarWSIKzzyHZ8vnaezdu8pOffbMpJ95Ua9JXiPl45WPJk/m7Z87gUdvKyDp/L33Qap/jCDaifikZ85Wy4FxSeJVJ4FSGndaDRvj6wWv8HKJjaP561nrScd+oxDoX9nSxOuO7MWOYBkNWuqvHMcUBhQ5CZ4GYXWDWXMfLdEjgoBOgDxnSqwJj//hTM47sExO/3wcDcu87Exiv4Aol8aiJq2fyQUTK3FzkNqO4gyugNAjaYKNHZpGKk6we9tbXjwN0R0mOcBRit/nlUF3sTGc1hpde7xIZoH+7ZAAVTP/qaHt3t8BuJ4/uf46IBkJXmX59wg+zRtPmuIBVWQygMNpf1I1wU9pXj5a3slsjfjeRjbzlKJPHo6dqm3A+S5aGYKJnxe0FD+K1PcfkdPGacMun4YopvUlRqmdpPz3/h8+/kvMHlRp1Bcn+iOrL+NgslVckObZ+F+/YnbXkfq+4np9708gpZ6aK2IYYAOjm0Dus9j8dvB7ATA/Zr15eUC7ha2kONuwLo0CXAsQEXIvgAqN1SHSFXX/E5DMxDk1JIOwYlJaS/7P3Wdx5gawIiicM+BFZQ6JCdZPdVoyVui/nmvNWVbbi+U6jrkbYJroGTydaPlpXf4fgWRm4vznpMyMT7M3h6I62heaVERllrBDpIrHdN7zRJzkHdXVP8grC8EbtXRYu7iopU+vpWop/dsr2wFyK6bv7bFq+BtWaPVX0v+1PNaR7L1lCm85Rqa8aOxzuy7oeacA7Dzlet8kd7brSWur6r8PeiS08dO/NOx5Hw8PQgp5sQCP805bT2XsxkuhGizgAxOrFVG7mPDW/dMRIBJ4vvAXR/QEWkIM6TqqXEv0hTV+YieBzdCoFbN6Zim00RbUWSG2VIVBf8qV3zgECFQVcFX4xW02aBAgCM6JNoA4ZfcLAsOQsZeIxcKDebQrvGLLV+tNpZfCq1VU00PIHUm8xhj0
 FIf8DSZ5
 0745uyR1mz7YW7yNkr96rwvGl6vJye5PSGK8T8gaQKUGdLhpa62SSt3bUwTCqx1+NQh+m8r1RdWDZTGGl7I7+8bBoHgnVKF52Yctw7J3naRGdRJWIccMwrc4tb5ZPzTk6ZV7M1fWSwmX5vutU/s9G98vKCulxkU2hFNcqeatbxTvFgNVvq85mnQ+maGDv699sRtWICoX4SMgfjKTEikoSNRdBnGX/3T4oPxWzPXfRz3C7W6e/9kGZ64RV7gP0lm7H1OfiyuZ4WPYUdLnhTHHSRLxWKFrYvgXyLTB04+cYmn85JXylR5nIwgmGs3++FRQLCvtzUJD0oLG/7Qb4q6u/Pv3JLT+7cxNrFz28uo+g2h+ovmo+cn8iZmXJNxRQorTtMwXdc6ScxppoojK0ei0vbFrWYSIQpK/WQ2phXbgoVVc52mwLci1K+pOCCwizcfmNPeTuFPYENUHmO+I794Bzap8RNbUAgzp3wMZs1vLaRk9C5xgspAEQLLZohw3cC1FFXf5SGjXPsKX7NmCAsKu0kSiHFzCALJmsymGPcOPucIGUGFxncIMHVC9hDSbfsbrwpSJDQmCXUP5S/un/qXQIEiieoF77Ap+xzgEmeatT5FmzQrDGo4wtr8mlwbMaZ88rjPruDpVkfx+DIOdrQ+91BiaXgYFaYTzf7MCr4EAprHKGixxOHwEc7my2oG0XNQAn8DnQLlVKjRz4r2GLBm1K8/klBM6L/6XmYG0M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> Add a simple tool that allows to issue an advice on a process or a file.
>
> It can be useful to experiment with effects of an advice on a workload
> without modifying the workload itself.
>
> Only supports advices available for process_madvise().

It's a mega nit but 'advice' is plural already (also used in the singular
because English is a troll language but there we go!)

>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

This is nice. I really only have nits, so with those addressed LGTM and:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks for doing this, this is useful! :) may use it myself in fact.

> ---
>  tools/mm/.gitignore |   4 +-
>  tools/mm/Makefile   |   2 +-
>  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 2 deletions(-)
>  create mode 100644 tools/mm/madvise.c
>
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index 922879f93fc8..b713fcf4a2e0 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -1,4 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -slabinfo
> +madvise
>  page-types
>  page_owner_sort
> +slabinfo
> +thp_swap_allocator_test

Nice to add this at the same time :)

> diff --git a/tools/mm/Makefile b/tools/mm/Makefile
> index f5725b5c23aa..db315a48adcd 100644
> --- a/tools/mm/Makefile
> +++ b/tools/mm/Makefile
> @@ -3,7 +3,7 @@
>  #
>  include ../scripts/Makefile.include
>
> -BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
> +BUILD_TARGETS= madvise page-types page_owner_sort slabinfo thp_swap_allocator_test
>  INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
>
>  LIB_DIR = ../lib/api
> diff --git a/tools/mm/madvise.c b/tools/mm/madvise.c
> new file mode 100644
> index 000000000000..038b3e1076ea
> --- /dev/null
> +++ b/tools/mm/madvise.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdarg.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/syscall.h>
> +
> +static void usage(void)
> +{
> +	printf("madvise TARGET ADVICE START END\n\n");
> +	printf("Arguments:\n");
> +	printf("\t<TARGET>\n");
> +	printf("\t\tA process ID or a file to give the advice to.\n\n");
> +	printf("\t\tUse \"./\" prefix if the file name is all digits.\n\n");

It kinda sucks to do it this way, why not just default to a file but have a -p
or --pid param for pid?

> +	printf("\t<ADVICE>\n");
> +	printf("\t\tcold\t\t- Deactivate a given range of pages\n");
> +	printf("\t\tcollapse\t- Collapse pages in a given range into THPs\n");

Is MADV_COLLAPSE useful for a file you map and unmap? Maybe make
process_madvise() only?

> +	printf("\t\tpageout\t\t- Reclaim a given range of pages\n");
> +	printf("\t\twillneed\t- The specified data will be accessed in the near future\n");
> +	printf("\n\t\tSee madvise(2) for more details.\n\n");
> +	printf("\t<START>/<END>\n");
> +	printf("\t\tStart and end addressed for the advice. Must be page-aligned.\n\n");
> +	printf("\t\tFor PID case, it is addresses in the target process address space.\n\n");
> +	printf("\t\tFor file case, it is offsets in the file.\n\n");
> +}
> +
> +static void error(const char *fmt, ...)
> +{
> +	if (fmt) {
> +		va_list argp;
> +
> +		va_start(argp, fmt);
> +		vfprintf(stderr, fmt, argp);
> +		va_end(argp);
> +		printf("\n");
> +	}
> +
> +	usage();
> +	exit(-1);
> +}
> +
> +#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> +static unsigned long read_pmd_pagesize(void)
> +{
> +	int fd;
> +	char buf[20];
> +	ssize_t num_read;
> +
> +	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> +	if (fd == -1)
> +		return 0;
> +
> +	num_read = read(fd, buf, 19);
> +	if (num_read < 1) {
> +		close(fd);
> +		return 0;
> +	}
> +	buf[num_read] = '\0';
> +	close(fd);
> +
> +	return strtoul(buf, NULL, 10);
> +}
> +
> +static int pidfd_open(pid_t pid, unsigned int flags)
> +{
> +	return syscall(SYS_pidfd_open, pid, flags);
> +}
> +
> +int main(int argc, const char *argv[])
> +{
> +	unsigned long pid, start, end, page_size;
> +	int advice;
> +	char *err;
> +	int fd;
> +
> +	if (argc != 5)
> +		error(NULL);
> +
> +	pid = strtoul(argv[1], &err, 10);
> +	if (*err || err == argv[1] ||
> +	    pid > INT_MAX || (pid_t)pid <= 0) {
> +		// Not a PID, assume argv[1] is a file name
> +		pid = 0;
> +	}
> +
> +	if (pid) {
> +		fd = pidfd_open(pid, 0);
> +		if (fd < 0)
> +			perror("pidfd_open()"), exit(-1);
> +	} else {
> +		fd = open(argv[1], O_RDWR);
> +		if (fd < 0)
> +			perror("open"), exit(-1);
> +	}
> +
> +	if (!strcmp(argv[2], "cold"))
> +		advice = MADV_COLD;
> +	else if (!strcmp(argv[2], "collapse"))
> +		advice = MADV_COLLAPSE;
> +	else if (!strcmp(argv[2], "pageout"))
> +		advice = MADV_PAGEOUT;
> +	else if (!strcmp(argv[2], "willneed"))
> +		advice = MADV_WILLNEED;
> +	else
> +		error("Unknown advice: %s\n", argv[2]);
> +
> +	page_size = sysconf(_SC_PAGE_SIZE);
> +
> +	start = strtoul(argv[3], &err, 0);
> +	if (*err || err == argv[3])
> +		error("Cannot parse start address\n");
> +	if (start % page_size)
> +		error("Start address is not aligned to page size\n");
> +	end = strtoul(argv[4], &err, 0);
> +	if (*err || err == argv[4])
> +		error("Cannot parse end address\n");
> +	if (end % page_size)
> +		error("End address is not aligned to page size\n");
> +
> +	if (pid) {
> +		struct iovec vec = {
> +			.iov_base = (void *)start,
> +			.iov_len = end - start,
> +		};
> +		ssize_t ret;
> +
> +		ret = process_madvise(fd, &vec, 1, advice, 0);
> +		if (ret < 0)
> +			perror("process_madvise"), exit(-1);
> +
> +		if ((unsigned long)ret != end - start)
> +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);

With a single iovec this should never happen. But I guess no harm in having it.

> +	} else {
> +		unsigned long addr, hpage_pmd_size;
> +		void *p;
> +		int ret;
> +
> +		hpage_pmd_size = read_pmd_pagesize();
> +		if (!hpage_pmd_size) {
> +			printf("Reading PMD pagesize failed");
> +			exit(-1);
> +		}
> +
> +		// Allocate virtual address space to align the target mmap to PMD size
> +		// Some advices require this.
> +		p = mmap(NULL, end - start + hpage_pmd_size, PROT_NONE,
> +			 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +		if (p == MAP_FAILED)
> +			perror("mmap0"), exit(-1);
> +		addr = (unsigned long)p;
> +		addr += hpage_pmd_size - 1;
> +		addr &= ~(hpage_pmd_size - 1);
> +
> +		p = mmap((void *)addr, end - start,
> +			 PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED | MAP_POPULATE, fd, start);
> +		if (p == MAP_FAILED)
> +			perror("mmap"), exit(-1);
> +
> +		ret = madvise(p, end - start, advice);
> +		if (ret)
> +			perror("madvise"), exit(-1);

I mean we exit immediately so it's probably not all that important, but not
munmap()'ing or closing the fd here.

> +	}
> +
> +	return 0;
> +}
> --
> 2.50.1
>
>

