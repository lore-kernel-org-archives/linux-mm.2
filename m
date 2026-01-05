Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0243EC2A074
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607396B011F; Mon,  5 Jan 2026 05:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1A66B0121; Mon,  5 Jan 2026 05:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478B16B0122; Mon,  5 Jan 2026 05:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 349456B011F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:43:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE0DB9F466
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:43:35 +0000 (UTC)
X-FDA: 84297573990.22.BABC456
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3831F8000E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:43:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lieo7xcK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oTiJvncB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767609812; a=rsa-sha256;
	cv=pass;
	b=lECV024UFAGGblqNfQxRvjBS0YIwfoUOtUAIf+JUYCsHNRAbiWua97vMhEbxFf4QcCF6uE
	q96L9MZh7BzIh7QJj9ELMdvkhIOj4ZJebrnwMK40ANVLjXcjeFPieo36/qitxDKJj6jkjn
	GDmNzptsMZHRA+Mxp6PvBpsfEeNqUTo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lieo7xcK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oTiJvncB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767609812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8exB+bKXSgacUbdQDRQNpyi+xGKDvP/EFUTmNklUFio=;
	b=lm9WVAFxndbnQaOn4a+CwFpu60I5B5hlL3c0T2nuC71YcoMlovmy4TyZYfZqSI95jOvQ24
	G2E6YI90e725k+/tXuyZaaxHLMTNN9Q+2w8meTcRClWRiHR1x/32EDWbe8ybN9OkDockH/
	g5QrSKpgZQ/VfuHQiUodgQwPIDFi1ms=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6053OBH3298866;
	Mon, 5 Jan 2026 10:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8exB+bKXSgacUbdQDR
	QNpyi+xGKDvP/EFUTmNklUFio=; b=lieo7xcKwRlwjGxKxj/WIgfeTCMzLOrh1x
	2EDrPdzdiZFRCudf+rxb5ibHoaQeTFNZLxnl62DNr5Kkbu0Ol7I2wr8MTGQ5Gnsj
	DQThZPTTGqqW7Ucu+EUrP2qVxaaeD2NdKABcvSdwO99Pv7I2fZoIXShIM6+PZQIc
	kusF/gjHqkN297KV7BnEW8syq1Xic/ooeJe5WcPDRTgKPYdQnN11u07V1XbZ8Uy0
	xbCBqqbfygmtfXOcHaFjpzPX3gTN91dg0tvXOl/EkU4L+khRVnDrXWIwnxqEXaTP
	3LhUaSoq03WBmp4Cv2j/IQ0L0jxz9iUEOOfLH8xZBGF0Mm0Kw16w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev641ge4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 10:43:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605A52II026603;
	Mon, 5 Jan 2026 10:43:26 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj700kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 10:43:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CoK1DNjgXVID/wAv+b4uUQe5wrG3VlQ9Ha+C+1WNhEIVjxY7JPlg9TLGQOyGnZJncyOcPgTIHHDJYZLousJtHrzQSo86duAfUySuJ6Ske1nnqu5IcFJCxk/xPODLC7CvBFpenn3BL1aaA0xWthJN2+ISk0NE6Sj6o/+s4e/Z812qYyDedeP2DiCxm1MO7yeBZEowtKoDcfyb2GbZKw33PXbUgCjrl0VlDYolAWJFe7hMDEnX/sEtZlNs4r/SB8TWQOTQRdzelXD6GLOLCQe0vsS+L/GWvYEvLZO+LhuaMhiGmFoJt+cepiBMQnUsP6lYfIDobVBkR7B5pjk0jzvptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8exB+bKXSgacUbdQDRQNpyi+xGKDvP/EFUTmNklUFio=;
 b=K0g2Ik5p4bCRetEfUl6IPwaWUpg2+r7pYRkKFy8nmV6EVw1bj4aFUMrgNuEK+D5zXf3jEG1YAoh898ehuAZ15FB2vfwbOg6umJYHcLM6zu1g7pX9rZFYdZJLEOf80Kfj3E6cGnGhZWCTlo8JWWE7JTyYF7DrxoVfbgSSSulhP1nvFIN6xVyKK5Pb2ZCxJWN6eJhMwMEQ9opK4U+h9kQk78nQ7qjS5V1+M1K6Te64EVSG8AbDrcq9QEoLluCEmmRthZh9gFQooshCHRdhTI4KgyUsRxkC5YPezzsrukCs5a4oinooLXlMKmca0TJbSoRZ0iOwhkHiXNI5BIzWTOEpFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8exB+bKXSgacUbdQDRQNpyi+xGKDvP/EFUTmNklUFio=;
 b=oTiJvncBkrbHSmuBpDYq/x0jKxHIHEydz5GvbEjFOir/BDdJN9AMXQ0H5Gel8BIoYZV40FlzUL3TNaTEd+JBOn1SNJpDSipvSkNQVuy3X99I8HSQCvKlKdb3lsQcawusCZLZdNHp/YXjbk0LyyVk9Jj8Au03OjQVrWSagt+3G/Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5812.namprd10.prod.outlook.com (2603:10b6:303:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 10:43:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 10:43:24 +0000
Date: Mon, 5 Jan 2026 10:43:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <56c7be10-b223-494e-9ded-14f8037d0017@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
 <0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
 <b6a2a040-288e-4114-b85b-51740c608bb2@lucifer.local>
 <20260103095845.152449636aaa60afb11f6c05@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260103095845.152449636aaa60afb11f6c05@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0417.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fb101b0-9290-4511-4534-08de4c474091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DUOjyaWnFFQQz1EpKH/+dYYWffukeVs7sC0+25go++siUPCjlawVxzlHhcXR?=
 =?us-ascii?Q?Lnca23bxYh7ZU0M2JohRVE5c/rIosJcKximty7Aq6Vhb2519wpHrhfScr3B3?=
 =?us-ascii?Q?i1zyd38E801RHPiUFC+z22zmwMg2qHj60Bumll0kJIHSddr56rMaJS0v22HB?=
 =?us-ascii?Q?1KbvgtZqI+7CAq325ZkBX2uT3C26eo0D2iLlkpRikj9FKS/owi267gzR4Lc0?=
 =?us-ascii?Q?/zyeY55JNy7et5kIeASjOgqrO9Gp0aw9cyOYh4GY4mm590Vg05JeLATjRfFr?=
 =?us-ascii?Q?CYNyCG8eBE5agGD8jYb7ltv3+h+nBguo9Awfg6mMVqDZiC0hP1b0pSHqPE7h?=
 =?us-ascii?Q?d9jklNsUdL6brCwLOMeeYuCFzpM3RdraQrTCdnL4eyrCwMBFGVquN0LOLJ+k?=
 =?us-ascii?Q?soS3pPPrLvc8BfQBIMGb00uJwHNU39obINEDZ/34ydUy903ZjYXOxMc04LGZ?=
 =?us-ascii?Q?n2jFPRUvnY1nx85QSUmSm4vi8QO/65X5FG0rO9/DBXpYQFflqblL02qBWJio?=
 =?us-ascii?Q?Vfxi28ZHsLDUu8kdML34liDbtNUt77Dz/oU3VzJSSSR3+YBRjAwkkR0bGww+?=
 =?us-ascii?Q?DzmfqoaCTF/58zyQYDR1xDiDnfxX8UBDJ9p4vJ3PC5ssLnFT99bhPcdJv8cA?=
 =?us-ascii?Q?F1vBldN80A7ne+24OmYY/sAo3AWni1mGfFYkybmTQnQwaISvWY3L1oxgRqXW?=
 =?us-ascii?Q?EEGJ0bFw2VSD+FjMmsCffd0GAsuP0iwNe5M1SSwzOccP38/V83saYvdGCvwC?=
 =?us-ascii?Q?USD2g3eAo+JAb425dbKVpbDoZcMa+bKwaXm4Uz8Zm31M/RSKA8Rj5MGsms98?=
 =?us-ascii?Q?mTnU2Je3LRvul2a1hInDdFgxiQj/XPgar/oEveeoLPNIZ5qQO9OTF7v1U3Ds?=
 =?us-ascii?Q?kq8N7E++NUFlpbJdByzH+7K5JBgLvuBcSM1fG5d+KZQQzKwElHpSDOfqQxMg?=
 =?us-ascii?Q?KS380/ZRRK+PvfnxNPWOMIc+uWIivZ/rMiYPyb6OMZK9HJg9WBkaPQTN+mNH?=
 =?us-ascii?Q?bGZUrifs4C/Gid/WmUalVqTX8WE1dHZpJSTxBOFvGVT04nU2i62Ns5py4Wlp?=
 =?us-ascii?Q?cMdnF6OCOSB4wgEfBzp4Q7phROVu5cRFidk1tplRX74E9xbPIpYfB2K2gXZs?=
 =?us-ascii?Q?6/WCU9mHB3U8VovEvO6/ebGL0GQkkKv/ErxM6lE98jBXM/hggiLDZ7Q0wxbt?=
 =?us-ascii?Q?/ZdYJQKAX1NIew8FPOsb+gpVWi6DNNCGzyQtlrfBKsyZ4KbTnKhGY0eWgucV?=
 =?us-ascii?Q?FFEbPpsD8YzLcowfIdqbozTUYUtNSkMGymu+kk2+8xHJBf5YmX4mPIbC+dg2?=
 =?us-ascii?Q?40fDJJknSuOk1+cLtYUdpo/Rm1UvkwqcgbL/QAuM6bRjDxH5Ing5vBGVT4Y0?=
 =?us-ascii?Q?8rdkgB7rKyz3sl20wYmcd8xKhmpPudQaQA3Q0SaZHfNqeDhH07h0YZEWr+G+?=
 =?us-ascii?Q?QZU+y4uGa0rHlc6TLqbqBfrx8D35Zkj2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mv6WaNfrS8A3YPopRDUTsB9zZESodes1LllUJ/d+5bTQYrXhZadSTLIVZNF8?=
 =?us-ascii?Q?0dkaCrLjqOdR4i335UoNFIW7uHIqGhpYm1k2BFG+DIm/ovDA1R5Kbqa17H+l?=
 =?us-ascii?Q?HgmA5I3Iws8b8WHAcL+rBiiBCIrYDkGkXWpVHGOcHgOSW59Tv8dtJphp77dg?=
 =?us-ascii?Q?q14UaPCp2ffVIzuxOlTAfUpBJg10Jcc0S0ZF0Y7fidr8JDjhnq1eonlfQ4//?=
 =?us-ascii?Q?8jWSEf0lkEF5rtD8yLeK9eX6+EAfZSRkFjPwAhP7H7mvM9iPrt9NouGNqrP+?=
 =?us-ascii?Q?pFQUx/XjwHXBIOP7xvgM3InQ2jqIs2lRlBaeWgUYAPeLL/EGHTRBiEv/qZPS?=
 =?us-ascii?Q?lP86XDmPOQuuSeu/19A06NkhTz/ZCGqUlb3dErXKsh/WENgrONKrIb4n4WlB?=
 =?us-ascii?Q?BRPTfympVPJNbvUhytoIdVwFd6hds2H7vO3R/u+bQ6ZtvS/nlKyK169XMZZT?=
 =?us-ascii?Q?7+6OmbcJSiamLNRSkMoJMUq2cNWaPstp+2mhMeF6k2+sjOqOzNf33e2+HTyx?=
 =?us-ascii?Q?N50iMeoiX29YxszYEzhdy6Y99xmINhC9OVs6IAw23a9wf8gahPLjCOcxomt2?=
 =?us-ascii?Q?Yx6c3WR8hn4MeefsojI1RafzUtUYU8zdHXCXIAV/+DBJDAlu8ghZOQ/KGSbT?=
 =?us-ascii?Q?xXFbXE8CWn/OjFS+4uQWNZbXvA4Be1Q68n0EKXj/2RjIOC6MJDsSQPONpYqa?=
 =?us-ascii?Q?v/9PLxbL9s3bF1FHT/6v193jHk+1o8ny/ve6LHqfc8Dtjs/BVp0NrQ33oiGE?=
 =?us-ascii?Q?ju6WMLq8I4nbHm3Hk2QO4M6GDDe/wgJZGa82d9IV63RPT0Y7XfDQKmnVlXws?=
 =?us-ascii?Q?8TBa1/QxGcOdRwXb9GFtOEM6x/e7YHKFg1X/zGOkzlSETo/LyX45KrC7aQOV?=
 =?us-ascii?Q?UDs1lcCc2yzMJfo8TAuv3zoQGl0i2ev9Ww4/j94GpJ6rBDiRe5x7aXfW08+U?=
 =?us-ascii?Q?RWtLL7wksqMD8UqoE1tF1LOUUkkMmT2j6Bm/rkZyQa2ZANxS+xchfoWGe9Qo?=
 =?us-ascii?Q?Vjdrkd/3KVMF7V2+zFKdp/+LKd+BNgFdDbMe4auwmo26dkLLHmhtEzQ0Ul0g?=
 =?us-ascii?Q?AyhgB57hcBrsYR0Q4PMhCeb6TGswBc2e63wumMPy5twly+Hawh1iaOd2udLx?=
 =?us-ascii?Q?PdaelGDSBSMC3Y02ME7nT0kRfF+ddw2rwlb6u0+cpVxJtuLmA2KAqudSPlFB?=
 =?us-ascii?Q?U/kplF2A8aUWHEd++KAkmtwXtgXXRsXNMpZinwug3Ef1GB0eksLEzrm7yOIx?=
 =?us-ascii?Q?mzwA+BlnZvz59hV5aA1lBt79tKyy03tmVHh4/hVZeM7R0+cEmicRpbbfaN/y?=
 =?us-ascii?Q?wZw5j+dI6RLDkH6JayLt7LFU47OvX8SLCjVe/hY0kLrlfyudH+pflOxsGVw/?=
 =?us-ascii?Q?BiHP25nKwnt2Ffb5HLZcciZI/yGAbmcHzWixlRTSWsskTHNdNTVywiLTGmhE?=
 =?us-ascii?Q?X5bvIE4y2rnVFaeE6L0Jzb6h2WvvyiCg98El1ZeYOdfJV83s2+psYyeOXCoq?=
 =?us-ascii?Q?o2Zimy9lQ65GOPovFlKS3avlzUXDWIz2zIsuyYDIVb4WqpwyihEK/nJjiRLh?=
 =?us-ascii?Q?HlCOH2X/srE9walL+DyNtlhKASnaVes1paKUSDGdZwviWPvgSUTWpew5YQVw?=
 =?us-ascii?Q?dxS3j8J+y5pHLD7GmJ1YXFc106KTngovWXwBkJgdYfHeaWJcLw2XNzf24nGQ?=
 =?us-ascii?Q?RY09kdai2etjfDgRuUun/KHBsER/TSQaqVYG+nGHMJt0CoCPTuEDhsEucUEt?=
 =?us-ascii?Q?mi2NiVNzpgAhaq8NAD3zl0Rampniajg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xk2PsD4XMNuk3rxhnpYtlU4mDn4x03RrPbLGTB0yMecubYldYV0+1YgfHCP/07OAmpkphTdfHR2QnzzqtIfMOim5AuWoOvRCRlPlhtedZO5XUUQ0JbDb7zrp+GJ3NJybRnC30dfzrHmIkUDaOwjpQC9k2lvNVbbYWN03yNGGnIMMI4EcMai602XKhtEv8et4T9CHmlQ+5rNu0LSGv2OvQfnFzEI0UDGpuy9zo5h/gOgg3B+tnRLkFxsKqtIZqOiK/4/FH2kpJvv8QalOr6C8g5Z7zpmJi9p07y4F/whO9ZqBDYvBU1bWMVYWUvQ1kzl7p0KPrq+E/zQqI7/pHbbHjzI/hQXRMG82Te3eZYxNTMGf0XoIRyz06Cv1jJXSsfO8zDg11kSeppKSQDXIP4iLkl4/zp7YWGooH1D8b3qhAKecVd7MEyNZZA9Gxm8aiIVX6RSEJbEN7D5c5iYSO8fXm0jEWe9cYXTFmNVIHn9VkIEjVg0CCCiLWVH1P/55/+3umgogl3bjK1NMyaHaFw30dVvIQIAsFIiDPBx4yVFCq6vYZ+ofT8z98snDzfaOfHY2pNcrtBhMbJrxmy0Dmdi+1VEFeITxQ0WjXeZMDIovsZ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb101b0-9290-4511-4534-08de4c474091
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 10:43:24.3741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1aqbDK1lVz+ZdXELI+DOiI1puGEldJNjO57Jahe6AoI8PFHO9cq0sDLTJRxI244L2VmB/2HHJ2y0mxvOG7FBAs3nR/a/6HFy0yEnisQfBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=849 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA5NCBTYWx0ZWRfX2jUfJ8PfE1rq
 uu6oAlsAPXANmA6ZqfZPwRnTCVJ0Cv/lUcauPjA4SjjD+jIvhDLpbi4qyB/elrG8kz9eNfE0yew
 6Wofcw9OLYGxEMMnUr6rHQ0tt+IbUqfX0zrj+qYlZpA+SH5F7hOKHMyT2yEA2U6nLCV9Yi+ncJe
 Udg+Q72XZpuholoEn/qmHHjkTkcKtFIrgxiAuo1EpO/TRgQZq5xQrLoNNbNlU2LzU1uMe2FGpqE
 qJtljjDiq+lMs2dTZUzT37X1Qifro/pTE9/h6sMdpmv5+eQ+ukI9cm7bFb1uRwxCZPRIzW9aLoV
 S79Rfhm4bgMTjjoztRhab1vv2DH9yrb9yYQycatztuosdNKzLmi0SbbR3tMNRXlq2sTw4koHOXh
 UpoBZVOcMrjboTKa1VUSqFSx3RaIn17nbUJfKvQTIYwJzN9SoDMFV5hOTn1m6pqVCfjW0cbdZiu
 H+BmHcdP+a85IxIcoVw==
X-Authority-Analysis: v=2.4 cv=W6w1lBWk c=1 sm=1 tr=0 ts=695b95cf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=pnvyUIGGgY5acgWQyWsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 5egL9QHzkTaJpdjCQnlNigikqYuspa1x
X-Proofpoint-ORIG-GUID: 5egL9QHzkTaJpdjCQnlNigikqYuspa1x
X-Rspamd-Queue-Id: 3831F8000E
X-Stat-Signature: uh4j7ujn3fe98hnkfrnn1h5qr1hmbymj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767609812-738053
X-HE-Meta: U2FsdGVkX1/EZv4JWqseYaty6CW89CChg0GKc9pBe1IMrG9ec3e/20C0VYzv0DKn/n/pxWV5i/R1dfwyuXd2/ssv1H3VPB2jWJ2/I9fB/dlXdC/5O8ltg40Q9r4k4FQCisdV6KOHgSBXYEY1Y1f5ZDIz5/8GIbsVxk8FfHVJ4qzAE5J/w5SXzxBNpHqOEBWrIxvVC8Ol8vqs1ZOzr0p3hS9tqe8dTXfzR9qX+5yfHMtoNfnZHltQn0/oaWyor2DeFu7WQxdKCc1pCdn+cJV+2clH1QuWEO50B0AbpgV90v//d2SD3Z+CX1OUsM+mtrU6ncUf7BtCj7Exj6eUFfjzgw7BuvWbPcnPXkypqo5SqYL1hzztOJu/m+02vkJpPn9NEl95Gamdam3hSmbmoPYDF2pQwUx221kL2fZBug4hd2fdYW4vu/jQeClko74Ttlry1lY0R+mTsWAiWafNFV4HcvdW5yKXwujjuVfKPgWz45KM4SQwkAfUfPJaUaG2JqLwLtiuqRvL4eRRGDYgrUhBs/25ra9P7I3gy4S+ondYu05ztMIcouSIy/wKCwRnkRmsrv+sFkk7S13nSe7Dt104Jl7GfiqVP6e4DjhvQFFL1Mrf+f/ImX9vGBNCTIrWkyOwxWpFJEmBw9syf+E3kzK83mv7a0L6at5G9DuCcJq+BmHbh1rSeGja/vmRtxbcHTmGg2Im0sFieqaz7Vd67fT0zUBY2HrHw56cALtb4DGR7xfE4Ug1hHgevQ7DriVlU5IWbGdnRxhNeCVFFdrDiVutdRw46Lqe+oC8GiurDunSC2xxphfaKvlRZ2AVW7TuzudrPN/1V69ut64Dge81Ol3l6bPt/jw88FJqCeOLOoFlDWf2t8tX47CPfayl8wGxVAH460KdebP3HwfmtnkWn1xzfGq2f4foAGiwafYaFyYL5nxghbhjGiw5VANLkY6brMPjChwN5M6w0Znbc08bLGr
 VSfwsgEe
 DsIsHJ7GRT7MVnRyptNN3IgJVftDAStmBgO3blrZUd4nHp7SQUOYwfCfZq3qjQGMVi6QWHWIcH3zQSuidyAPiluIcY3g0Szm/zErTSaWO4QRPPG+NwXW5MrCVzV3w7zheCFVM/qD99xcqxkefh92KzFeyJeyfUHW4sE5gvEvUXdi+gRJKWAPYsI3AKTEomYYHsV+zIvBDxw9vsiqfUlSJ09UyObR5WZ7ys6R06/S+HiKq+i0U9b/v9UOEQ8pe46jXCFQVBdLXq/rxLdiJPKBAwL+ZcOs7k70h2KwYOGh9oLzX2eRCYnTvHvc4F1QJqINEwE+xTke0tRuqWKVj5vjcofcerB4K2cD+oC8OWvHyoCftfo1VBwGVGXKzAdB3+i1ldg6e+8WY1kLusDe1mtgaT2JK6ysbjMDW5Zo15e6hxnTzdxVzHF+xqF7T//ml8f2CNNbZg5o+zzYKkDLxUFybkF9uGKJfQFqATOORaCjzZdIvqvjtJxRFiTbQzY8SBIot3gXXCtXUPDmA3qdwI9bYQYNCIaaIoDouaFWzOe+H4cY9nLMvcGDRRcWHlko9Q+X6CqMb6JKv+VIpEM7goQR4Bei77641/62TxWJK2oANWxVmKPs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 03, 2026 at 09:58:45AM -0800, Andrew Morton wrote:
> On Fri, 2 Jan 2026 19:08:37 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Fri, Jan 02, 2026 at 07:02:40PM +0000, Lorenzo Stoakes wrote:
> > > +cc literally everyone you should have cc'd in mm :/
> > >
> > > Hi Mikulas,
> > >
> > > You really need to check MAINTAINERS, you've sent a patch that changes mm/vma.c
> > > without cc'ing a single maintainer or reviewer of that file. I just happened to
> > > notice this by chance, even lei seemed to mess up the file query for some
> > > reason.
> >
> > Ah yes, it's because this patch breaks the VMA userland tests.
> >
> > You need to modify tools/testing/vma/vma_internal.h and rename signal_pending() to
> > fatal_signal_pending().
> >
> > You can check it by going to the tools/testing/vma directory running make and
> > executing the vma executable.
> >
> > This one I don't blame you for, there were meant to be CI tests for this in mm
> > but for some reason that's just not been done.
> >
> > But this needs fixing. If this is being backported to all human history you
> > probably don't want to do that, but that leaves commits with broken tests in so
> > an alternative would be to add a patch that gets added before this one that adds
> > fatal_signal_pending() to vma_internal.h.
> >
> > But not sure how feasible that is? Andrew?
>
> Not understanding why it requires a separate patch.  Can we modify this
> patch so it makes the necessary alterations to selftests?
>

Because afaict this needs backporting to every single stable kernel (we
need a fixes tag clearly, I reviewed that elsewhere), so doing other stuff
might make it not-backportable or at least very very unreasonably painful.

Thanks, Lorenzo

