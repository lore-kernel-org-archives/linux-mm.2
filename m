Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B85C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1A66B0096; Fri,  8 Aug 2025 10:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99776B0098; Fri,  8 Aug 2025 10:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61406B009A; Fri,  8 Aug 2025 10:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94B616B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:34:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 469E71155D6
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:34:29 +0000 (UTC)
X-FDA: 83753835858.23.286AB38
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5BF8160010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:34:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Us67bFwP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KI76bZJw;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754663666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8GhKcV0cE5uAuuxUl11QtqVZ9N/MpvDViNhSKTY56U=;
	b=oeiuKPMzKkwWjFNidsk1zZhvZFyYacrFxSIW/5wFaCpMKktlGaw0qaBh24fG6+Cz9DQNqf
	mLd1EXoTx4S7kvR7sJO2+6V/hxmbawoK073p98BHsoTJto1yap6IQucpAIOa4JtI79ouMi
	qMcX9HCBT7D+dfhd7uWQ6zlBzhUrkJU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754663666; a=rsa-sha256;
	cv=pass;
	b=B7hk+29Gf0JaaYvrFUUUFL1YJHKWCKZUV61/EyJkVVl08SpvIUMno5XyXsrBVcUyOsKIiF
	7/JLCdP01ic1S1sEtQENDWEfVLbQqax6X4ZMgroCONaMlWCrcOvvpSe1dnxS0o54Pu6Rka
	rFPLPDElS54zB7hJv5uPkbvBdJRujeQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Us67bFwP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KI76bZJw;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNQ8e003908;
	Fri, 8 Aug 2025 14:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a8GhKcV0cE5uAuuxUl
	11QtqVZ9N/MpvDViNhSKTY56U=; b=Us67bFwPhntOqoJ/0DdmYiAGX80ySN9s0D
	zhycgsV3W3wVFFLwzbmmxH890DqidsrgeGcGNRUVi0mXCi00IZwy2Mg6Cj04l4q/
	KGQMqfJXotVHSAOE92uB5ivTPxrd0/3HtBVpkhEQRVD1lasrgJO4K1c0ubsW5S9x
	L6Q9v5TTfq5LECHNLIiOHDfX5bM76naE28k6K/lUaDdvtLrwTOSHKrDDrTRMZJhH
	uzSCCNJgW2VwtcOwXfMUfc2mVIyP4oKuFuAzU93SF9RmWxcJ2KoBpEdYubqcl82p
	ExGCX4PPDZ7z4hJGPxcDV3ZF2Zx2Ei8KdZlWF8NRJO6LSdfDN/fQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvf6ca7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:34:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578DHsjI009695;
	Fri, 8 Aug 2025 14:34:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwptmt7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:34:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIVVK+6HbHx0dnhpKdBAil5jTS/krvaHYRsyeWsWoks+gDI/OOjZjzZ/T2ywIwdfgaa6qstIs8qEcJk999iMq3t0z08Xg/jloDe28tmlQmRVULvRs2qkDxv3/szeN+GKLGhqIziRL+HDMr/U/NpBe/rT+bhnHkZRuzBnsLjxy44Ht+Vg9o6qG7l3JSCOF1zmhNzvPIUGcojAiYov4sdxRE60A39M98iwggS7q+wU7HfnwF610Dh843vdsahF/T+e4Jw2359AYwWxYVORjQzoYv66g9btgS9qDeph0Ph8/mBCTg8lSPritCeBrQJQeR0qQlwq3ytRdAQd7lVBp8yunw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8GhKcV0cE5uAuuxUl11QtqVZ9N/MpvDViNhSKTY56U=;
 b=UapXioT5u1e/m2gfRk/QMsFzTbvZNTgn9fovdo10aPwT+fIilqEHu6vvXmqgt0UkmglBGgy/LTIoeW2CmVHC9m5/ieKrT6vD+ETZstqRx7kkij646jfpdgouLE6ryODi7flu0eS9cPWjo3Jk4aMohz1QK9ciYcV/ZGkJhXQa2+HsNwNP4Pr+XS1S6bMd8eeAlizy4kANmr+LbtOobGDi18hRynvMww9rnwGd0zyh4LXcEMMKN5f1dXbu3AI57UsE5QSCvnoQaxq1HrmNercZv7Ik8pp6LnIqyQhjY6tllX0/8Qr8A89/JU30+gt5o3uZ8nJ3S6Ag7QNpyghuUVR0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8GhKcV0cE5uAuuxUl11QtqVZ9N/MpvDViNhSKTY56U=;
 b=KI76bZJwXUVTGbv3Jmp1I8qaQ79S2ETDf4/tbK/InXUJhYPatoIbDH6cDqFTzfV1jbuzz3UfyQFic5UJwl3XSSMSId8dc7guqQLfPIBIsV/2RZSoaSR0U+KkFkTThrgQF6dNnb/3dJaLk+SMRt3MdEc7yrUvc5wcL8jH63rNJE0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6491.namprd10.prod.outlook.com (2603:10b6:930:5d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Fri, 8 Aug
 2025 14:34:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 14:34:16 +0000
Date: Fri, 8 Aug 2025 15:34:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.17 2/3] mm/mremap: catch invalid multi VMA moves earlier
Message-ID: <52bd8c18-9299-4a91-aec7-670038d90f62@lucifer.local>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
 <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
 <571c0a24-6bdf-47cd-b336-efff34f48010@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571c0a24-6bdf-47cd-b336-efff34f48010@suse.cz>
X-ClientProxiedBy: MM0P280CA0116.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a1904f-a542-4bbf-7725-08ddd688a74c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mB4cEnygLU2GH2tDExoqISzBqPj9/1eyIRE0cwe0sZ3DZ0BoMrvC1ODtwf3w?=
 =?us-ascii?Q?qPxDTFRgc5lmPf/3XySF3deMB7SIWsXhw3mKDOajbkTipjgMe4pRoU9idBG1?=
 =?us-ascii?Q?ln6FLBAvu8vty0US67ycbz0ZqyYVDHIkoIihtjI8cjogJLR4jJik3Trj2db5?=
 =?us-ascii?Q?untGKo9ojhu95K1MePZ7WcoMtc1mvI3jpjSHQG6IIe6XeiWbt8xmjbDqZJGK?=
 =?us-ascii?Q?L1jF/SHC1cmIZgGe7p9Oi+0wYIu8kUeWNYmjlC5wMhiveNwimevY2UdE1Zhf?=
 =?us-ascii?Q?8T6zbpOZ4YgPwB1LUp3OPUCdBikLahHZeXV8OPJ3Oll/WN7K3UN0vxSttV7m?=
 =?us-ascii?Q?rB/7DcZxNgIQPMfjgsr+peFTubrePxGFtPXP6vYIwEK984uyLmN1FyVC4ktI?=
 =?us-ascii?Q?oD/aJNzFg3vgbb1SQKGv14rRVFwJ0SRaVoLEWi4BxSmJHyb4XWj6Nt+v1Vqp?=
 =?us-ascii?Q?FbP+HtgcYjX2kN4vOT1gNtIfskvRAHbyHDmtVegcZu6x+i2mKflEaptw7VeM?=
 =?us-ascii?Q?a5kBgtJWjc+3W11HNDiAolbXade8YLNiAr497BZ9DL36B+QEJg5CzxGFq2/A?=
 =?us-ascii?Q?/LE9GJeYRpmMaHjpHzDCiwFQdOaciLgN3N3f0uZN1pu/OvhxUkeY041Vw9wp?=
 =?us-ascii?Q?GGCJE+nF6Hrk4p4tVMfjwa8S00g5oAz3UbQxWlzGQyqyEu07iVT/0XQiKPjW?=
 =?us-ascii?Q?Ys9JJ/diyijgt6frcd7Lz8wQ6deoz14Gvisl+iMCv0pefuycYP5E536Zb1fD?=
 =?us-ascii?Q?M+QkS+CF8JA7hCr2k/AwDpRJ2P7y5SbqiRpYSyn5UmcH/Ph6/RgaJru5u9mz?=
 =?us-ascii?Q?K8a6lU+uietnJpSYu1sV9m+lg9ODoT/ZYqHWnyFrZEQTX1naxNQE+rPSpN+F?=
 =?us-ascii?Q?452CT23cqEI29MRLV78r91cxWvGoPyypFkT75eEkxLVYAX7eXRo1KdkPRTsw?=
 =?us-ascii?Q?sF00F4rVVtX6VP/RAOi/0M0hy6Tqz0vQ027w1wBPGHpjrBBmGAdD7d/wxY5B?=
 =?us-ascii?Q?u2gi3i9aWdkSac6BAKNV6QE3C1uNFyk5z8Y8XA2wRaAhuUW0Isu8lyghydyQ?=
 =?us-ascii?Q?icbaCBLImMNN02ugCXc13W3yNqib3yrhyNa2QP+ivhOxF8x0Bp7SDQ4WJsur?=
 =?us-ascii?Q?jJELQHEZpoJmj8uvVkkBU4JN00E8+EJ7VlE1mHvC2ALMZLl9zPtR1QTXtygD?=
 =?us-ascii?Q?fQsxerxcGnU2gNpa3scZY96sOyy1YRLO5iEeTdR0q+EPapCYLP0M7R72du1a?=
 =?us-ascii?Q?+kTQJ1NlrQLwuqvt6oe3pd1gncVoCNWfqf5r8Jc6IfHITgrXrFClF3W7KECj?=
 =?us-ascii?Q?WsFFuns9oiFhqW13Y/zJfXOvL/u5jKNrZwgonxu79e6KjuW/8DeFGDWL1HjG?=
 =?us-ascii?Q?8MzNHBEFPK9VXx2vWCB7pjb+kYVdAmqP4q7NVcPrdWktv1X8V8q6djgiyHmd?=
 =?us-ascii?Q?kzbwTExMPFk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9VGP/pK/Zs6Y9KzU/j9GvdYr5YX7LLbRJtXJMREWrg4XOw/HBSFEjEl6F2H8?=
 =?us-ascii?Q?xSJCrJ9JxciLgmFoHF8ve0qwVG6sFvwtBHXpBl1jHaDpgm/G2YMXOHNBrBeS?=
 =?us-ascii?Q?I3ZJABchAFwBXVpHueEWxanIb6jaN3wwyrSYzSBSS/Y8wSkEwvF15dZKl86k?=
 =?us-ascii?Q?QrhkVx9YeekI2wpPMn/zwGtefV/kvPFOR+W6BtSpOayT+6jHH7rxXw6d9X16?=
 =?us-ascii?Q?UfYgJ1LawjlDrviLli1/2d8j5GxSDsZOBAsIcFaY7kpzwQwOi6AO91WJT4l1?=
 =?us-ascii?Q?BxCiLQyEbLctI97QNJXUVp7u9f5artXfwxAYuvIdFlisG6Lx6HPj4bGhj2nF?=
 =?us-ascii?Q?IVJZ+iW8eUgn+TP8I0lWyYK2K1DnN44a5nlKm1H4epL70LjKgtwPaPjWUFbg?=
 =?us-ascii?Q?OnQM6ohgkfE250L6d/lFozVh2JwnQUyyKaaOxsL4KESXp7hK4TnHFRFe1vkx?=
 =?us-ascii?Q?FpPWSltwZauW2CeoDft8iDxdxj+xxO/cBrSJ2XCzKMqqlHjnTngWgqd/bMpn?=
 =?us-ascii?Q?6YoKE4wF3yZgQafgcyZeDTDsp/GlARHZ08qgpTdjF/6cM1PYxmBghi3s6X1q?=
 =?us-ascii?Q?RAHNJOphyyIQ6i+K5cMctFduBPtiqsYFgv+H5hNj+6oYdJetVmeQQGWdJDIw?=
 =?us-ascii?Q?jvqAYMz1hSPI9aQnfD+FOU5D0ubt6a5g71bIoo2phB8OXmVrZbJhe/dkkDJL?=
 =?us-ascii?Q?lNezvSh+jIfVMl/2a/dhSl3lXelL0HRHkkFGJJP6dwOjymFIBRBe9sugMupq?=
 =?us-ascii?Q?cstWiCOTNpokYEwYE3y9Q3xrmvZxNK3bwD36cPnnTlbtEMGUHAvl/IFeaFqM?=
 =?us-ascii?Q?nrsdVKuhgocPFdt9R5WgjjtA4+IkA3YvRlXPML1cUUHDqzwqg+Soizuj5y2P?=
 =?us-ascii?Q?9Mngl1WkGDZodnXoaqWM9Q6GpkIy2L3sTTkoCZlh6QGvO18H4zoj2tTcZXfa?=
 =?us-ascii?Q?jTPkFFjCvnQRkVPbIKQX9vbXhWi6XhRb4GgS2/18hNJaxoFpqOfi0My9KWtY?=
 =?us-ascii?Q?azx83UXC0yJOWiMx/0fNaKgNTrbEPIV+Xw4X5M/IRO8Kc7sZ5LxnfUm4JUyU?=
 =?us-ascii?Q?jA0Ygtifbt8htfGSsUFa6CpV3HSIIBoW50MZeqQBj0ndaKPRPlmabbsLzSgz?=
 =?us-ascii?Q?s7VRinfPWLkQOKxV/He3ytYaLmYB+KJ2arWoel6mSFOTgs7pB3ARMP7z7uRb?=
 =?us-ascii?Q?WKWw4RJlFckFZC8PtoKZJsR1N6GSkAiD4TVE8N3GvuFiYOnocwibUAMHQTw+?=
 =?us-ascii?Q?Xuafa1gkN2OIogPsVP99pIzbzmoKcSHWzkLTg8rXBLrcCMWGGUprc0Kvf51B?=
 =?us-ascii?Q?VPX2lEUzKtWVHzWKwukNljIPJXFAqHI0NPRrZ4WQA1AIY3YC1l6Et6MYmQAt?=
 =?us-ascii?Q?PWjEWqY2wuvdtmoKVNr08daAORbvlk8TOF9umjLiNLe5xS2RDxqmkzNV5BHj?=
 =?us-ascii?Q?h2P1LeoaIUedNqJRvioLv+8FENR92H0hzHz58CwS5BCpBS8PBh6BZvQ3xe8I?=
 =?us-ascii?Q?KpzXNFynBeKq2Tlud6R3PySA0J1sAEqKt6eLVn3KvCxEzhO8RX/AgSZfT+Wh?=
 =?us-ascii?Q?BRQRwp1S7196dg8rWEcbD8btCnkbXSgc0g98xCpGWKdUWKtkbs4mHnprSVPX?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HLit5y5MkCyfffFb18gmJlXsM/NULd/7r+GQTNVZmNtD9Nd1XN3MiQCykvWRFC/Pg1lMv8wm7Kr/cctizhvTRsORZ5VC1jFAqKWTpf9pWao58nLR1LX3lQGxmvBRrrSWKpb5NQNf9swHozrKTwIuHGyseEtB33cH8SNw49+3e4pgnRLwwxxKVPDHo9Klu0XM/k8+WJ4tbLqs8rzaCvHfQ4xlUcQPgDaWTu10KPndPmWm9zZLKnAyomyJy0A9D42hDwVU3efU/DXXRLpFGEde0QyZIGcdBdHcsnirtG+qALQcdxc7QSsmmorpip+WEQ8mH3sgbnsv5kJjqMjiT59FWXRSGmFmVc+ahfLW2SwLniTdbCAGCMg/wM/IJbnmGBVgzgeA8i1+cG4JgZfzKTohxieFdGywnApz15RxRnLDuje6TJtj7WhehJecTheFqqkSsiFuss+9U7dQsQksSX8E7ZnZ1FRdLHBIFYP3vLW0f4tevcMHrFBmfQsF8QEvOlo79r9rQRQx1dwfpAuS/EQhgVAnunjBVDma6yl/lnS94LgvgL9VDP2kThDeUORd5u+hr+8befumIj7Khn1RB5wLmfP97Dib758A1w6LYSL8hyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a1904f-a542-4bbf-7725-08ddd688a74c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:34:16.7994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDPH2qRVTnYF2llOtQabcRhKL2CS0CJMazUkktzk0sR7UtGOEEvxyA2+KLpT9/8PkjVrP/WoW0vJg0wRostG5xfoTKb5lXcKGljCtTgTz7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExOCBTYWx0ZWRfXyGg8p47dVx8Y
 tI9P3VGn9RrMphhzvIcyXFZx8Ln/qjHTjgQYCENOoTxwmQlkeIRqwZJsW1QyWQMshttgASU4Rgz
 WKV59CngbB90Xy0STQQfNzw97Jp9p+GEnjkH/DOlvOO7+anbtXVh5kT3qnTO6ROjLABx9lnoGor
 kivObMWLmY9gueULZH/BeZyM4NTg9mWBqWDKgGZ5AsM3pzNAiAeHhP9PP52C+jsf7u/XmRirdN1
 HTnOYBkh21N1WM856xsODfwgkIbhzIXYEW7pWL1p3+bbl342jC/oyrJcVYx/AEikdqa9zpWo4gj
 dxf9x51vmcDTeNW1DuO5Zeew+oKDHApl6YB1v7RQ/y04DE8JV2F40aUdQ6f8NBpwDTLhhTNukkw
 piLxeJvKcdY5KVWADGK9vErUX745Jdd3eI/BfkePAjnaMKktio+xdi2F28H1VfcVCxRDt0YR
X-Authority-Analysis: v=2.4 cv=RtTFLDmK c=1 sm=1 tr=0 ts=68960aed cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=sDa735sVX2v7Ux9SD80A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: jUdHScigDkYocDxil9ZmzyWCbmhJBbXl
X-Proofpoint-GUID: jUdHScigDkYocDxil9ZmzyWCbmhJBbXl
X-Rspamd-Queue-Id: B5BF8160010
X-Stat-Signature: kitzgwcwyegaoc3fjncxax9pyssb5uwg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754663665-610392
X-HE-Meta: U2FsdGVkX1/o7kHxxlH4Xl/sCGYXt7z5es3d93/xLaHRjoPG2OotTl2CwosRBkjtzCpjsgtx4jdK50yEjmphZE/+ms7b0BCurH/aXVrU/OzDcjZPzq+IF0TshG05JrO6th4m+0SxDnR94H9g68Pn/aMG8HpFH5++l+//AWgKWqnzw1peM9pwm7VYcJwOk8G2ytGOA6jwEahfyso97/7sEGdlc2C7w5GPLCrKjGcgfYTe2eE0QnB98Am9o56nOInRIIYtqlUKQLigUUOvdtSKJqGjID/gPiz/PPNGrbfQnAk7bl3Xj6f3ovl1Ej3STjJsXyaFHjBUyvcAqfPuvyLEGeWxEeNzoBp0g/DXgSIAKT8eXuPrI1Xxkb2CobYS7LivcGSYtMso/QF65E6kklmAsSPRwE/ur4gzQdlMMV1IBY5vCQ/WHkFPuStWmQGLz9afXLAbbEO6mdqiVYm+DjRr0JovNX7/NoYDynR4O5sC+AZXZ4KYCiVMeNIYK7U2uTAZxyDi3ThV9wdmcsjY5uMHGR+gbioqen5fRT7IForYJJZNspfxj9qPvxwtxzA1BRRm0NXN4oJpVPNicW0iGgn4byc7RAxqJMj/0Ts3VSu6f/8XkidUhWx1S0x+JMXI5lL5N2HHpC0avHXDy0voBJ5eEGiGZEtYRJfhfgCh4X4WES3XVt3BQTUN5mhICJSD+Fg5H0GUroXC1tR5ZoIzclXcP+3sI5+oQrR7wtd4wvuwIEteJS30RY4IAJSzgw4q5izs/Z4brRSYnDvnQCNhosUcwos77Y4g2jsj774UJDuvcPLk25KPbb4ojYhEyPNbZgDBKz7WOHIzeW1F/Aq4FKbdGoE+Sz9VmkubsrKDBK2Oqp7thGVNDbanCDG7UjsFuQ4Y2dOVvSgPWhS+hMTbjGhEZfDfCnHCM8TMOyf895zVxqeimwgSa8Z45sjMPK2Z7LBxidhz34ChiFTB+LbSU2U
 SDjh/v0t
 z7WamZxMVF2ynmbL0PawXjLy9guPjvRi04s3FEVrNaxIGnI2adGojC8AhPVusZaAtBMHayC07d4UodnI05WZPbDepHZRYaQvTlXvrywlssDyEHRyUfvNYlVV11Zt/DKjIR8uUh9K2q1w4xQmA9hw5bc8lUgWTujN3nncsAUHRdl8PMUXMAPJZxFO+MhLSwitrGQuVemW7rnvLSd336m4ySo+tywQ1WqD7mggsqerDfC6+MMRCsj7If3nSJ1ds+gAKm33pAFpy7YdAVf3oDfTOdlB9lOnxaJp4Hg00/VO08tSx/iIbeQSKUG4ete+ET7vhH7hNftNiB8m63zaM3ywZmfJ6Z+FN0cSdzEQvdZ9P7R4VtV1w602sPXiM5rCluR4Qf6EvXZcvkfUZ1eTEBUE8ZzE8ss7ijj+QxEbb3qxLdrIrHdCoAL5BESrlphRZq+MJArBFG9fuZE/ePPdaujA+a6QVsD3Q8mDShAxa4lUqNN1DPyQI/dHxboJCD7gi2eduMFwkIZlpopWYTondegw7S3Noh2Ttqar6YQM4Y8uVnFLpw93ZSL+K48OHeefIA5Wr8fxuoN0hRtvc0bAvsvJRznoIzDrnlVA91bxroIhsQMalM+8cvgDbOnA622Ct4TBq/GeoV2XzXvyPZ4oRqXIar+0ilHKYABLMxSFHHfvnV28n2C95Fh/o6wSTtu0ARq4KMlvlsPLXXrmhPRk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 04:19:09PM +0200, Vlastimil Babka wrote:
> On 8/3/25 13:11, Lorenzo Stoakes wrote:
[snip]
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/mremap.c | 20 ++++++++++++--------
> >  1 file changed, 12 insertions(+), 8 deletions(-)
[snip]
> > @@ -1863,9 +1861,14 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
> >  		vrm->new_addr = target_addr + offset;
> >  		vrm->old_len = vrm->new_len = len;
> >
> > -		allowed = vma_multi_allowed(vma);
> > -		if (seen_vma && !allowed)
> > -			return -EFAULT;
> > +		if (!vma_multi_allowed(vma)) {
> > +			/* This is not the first VMA, abort immediately. */
> > +			if (seen_vma)
> > +				return -EFAULT;
> > +			/* This is the first, but there are more, abort. */
> > +			if (vma->vm_end < end)
> > +				return -EFAULT;
>
> Hm there can just also be a gap, and we permit gaps at the end (unlike at
> the start), right?

I don't think we should allow a single VMA with gap, it's actually more
correct to maintain existing behavour in this case.

> So we might be denying a multi vma mremap for !vma_multi_allowed()
> reasons even if it's a single vma and a gap.

This is therfore a useful exercise in preventing us from permitting this
case I think.

>
> AFAICS this is not regressing the behavior prior to d23cb648e365
> ("mm/mremap: permit mremap() move of multiple VMAs") as such mremap() would
> be denied anyway by the "/* We can't remap across vm area boundaries */"
> check in check_prep_vma().

Yup.

And this code is _only_ called for MREMAP_FIXED. So nothing else is impacted.

>
> So the question is just if we want this odd corner case to behave like this,
> and if yes then be more explicit about it perhaps.

We definitely do IMO. There's no reason to change this behaviour.

The end gap thing in multi was more a product of 'why not permit it' but
now is more a case of 'it means we don't have to go check or fail
partially'.

So I think this is fine.

>
> > +		}
> >
> >  		res_vma = check_prep_vma(vrm);
> >  		if (!res_vma)
> > @@ -1874,7 +1877,8 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
> >  			return res_vma;
> >
> >  		if (!seen_vma) {
> > -			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
> > +			VM_WARN_ON_ONCE(vma_multi_allowed(vma) &&
> > +					res_vma != new_addr);
> >  			res = res_vma;
> >  		}
> >
>

I can update the commit msg accordingly...

