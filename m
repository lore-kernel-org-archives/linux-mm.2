Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302FBCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B79A8E0016; Mon, 15 Sep 2025 07:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867F28E0001; Mon, 15 Sep 2025 07:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7082E8E0016; Mon, 15 Sep 2025 07:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 555788E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:14:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AF5C160593
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:14:08 +0000 (UTC)
X-FDA: 83891225376.13.4F97908
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7BCA4180010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:14:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bFBrod3T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="R6Irw/ut";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757934844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jra47+5F6clC1BuEZ1C+65BoHPA6qDhXZf8MjgaYNS4=;
	b=C0aUTls6F/SEHtoC6XkhgeXotUh2inXn0/E78Ja8vmQthR4NsFWzJo9+qnBcVoWQTx8QRM
	NevNf1OWDnTK4Afmd8kEyt/anU9bPMR+kYCT6O01sKSPxmeKCLyAm7t80z9UDoHiscuYDJ
	plPjSjHC3QoxjUyR8oib/e8XuSp6PkQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bFBrod3T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="R6Irw/ut";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757934844; a=rsa-sha256;
	cv=pass;
	b=bUH47Q2d63xuMEKKEvsfRSQOp/HqKV+0kFfYII2XRN5bQH20ebEbwELR2p8625f2HJS2jM
	LirAv0bnoPrrdBEiEWfrmUWQEF9Qkr9OqjSBSrfJ0itZ0Gt4smTQ5Wlq+JlK+Ps2BFtGfZ
	F0+0rPSSCQeF9IgYHKJkJvVwhgdu+hY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAtmfU022585;
	Mon, 15 Sep 2025 11:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jra47+5F6clC1BuEZ1
	C+65BoHPA6qDhXZf8MjgaYNS4=; b=bFBrod3T+vmGtKsiNB2LQsFZwoShlQ3rpU
	dsVUO3GX8NDQy0B1qi1NplHRf1tM/vWJ1z37QmgMRRaupfdvG0NvDM6wOGOVepS8
	whBKVe9xGlTcxjhDLhcrTA8Xij4AbJDzUt8J1k3VPVwbewkwit90jARnEwBn0BWv
	7x3I/PTjpsfylr7O4/oBvPpn8JO+pP+n99CrnwIkuPs4XSq532lktoIXww3ffhjW
	ayTk4H9r/zKQ0g4l9PDEEOwfLGfNXiZ2+RgmDo8/A2moZDYIWVk5pq3/CY47Mzrs
	MzazJ1jgPaVEjrlfCH9T8Qy/MzOzHTvwgwG9xw6lij6dQd9kvDdA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yhd264w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:13:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAOHWf019192;
	Mon, 15 Sep 2025 11:13:43 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b4nne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tu68kmLXVrhD+gVOWv+yqf5stn0MiD5gFzZB+HgrDw3TF/xdKLbyxnUC4mK/0XBLTLSaCOl8YaZHfHFP+CKJfABqOh8oHFRJ05QXKH7hF1hCbbvTbwEvkoiMzWzHJsHN/c9m6scIm07SA9SXCi+Lc+FSyDLFEAMsMt0e+nhgvEODWwUyjS1+WYV3jg+/AaN1F/cWLO+Tjuzh0XlBtOFm1n277Lo+tUDROjB0lidmoDCgUjhMw6nsZFBPzzN4xNjO9OuqbsZKm8T8bq/XFxsKsyHysPLmhbMEzb0B5NLsPHT6L/aaLDxRco7VgEgm331MV5OCw6/H0Pj+mW4j2ZclEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jra47+5F6clC1BuEZ1C+65BoHPA6qDhXZf8MjgaYNS4=;
 b=d0yLoAmlpA5a7mPw8UOJ8hBCX/ep/yoPBRTfhEtOdvxMaQDPVloKEH3YJ+UHpqaxlxudowwqpJQ1QVr8v1IPUZLL417sQ6BeDmR5st7LYVRp79t5d5N2dDZlVCgfWxDJZhZZl3fbY262lSDPN3B9jTAMSVhdcRFmuKBZleuL1QM59BMqDdrYWxh9JN+oqrlXuu92i/whDUe4mRj8uNuHO0usBFF5UswCQ2uDvo6Uo5eQKVuipc54SHqW0LL5BJoysc1KzIP0r+pnroCTL8TJxqttJleySs1y7pvtbMVMFdjaw3vQuVwQtU9CLSm8SnLjlG1ZKciBUf45Rvv2wpAHLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jra47+5F6clC1BuEZ1C+65BoHPA6qDhXZf8MjgaYNS4=;
 b=R6Irw/utRaL5rAPC4QVvNBuoDR0slRP6Mi+842ly8bWeNmwfqXyhouTU9jKD2QI2sx1wgMq45UmthNSjW+Pd1m8/nFqsAEC4CBrVHN5YeXk0yVDsFIznE+uk4WGpIDN1s/w8/2wQOhGsN56I7LpL9PoE2c6MUKL7XOWfJfi9FuQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6201.namprd10.prod.outlook.com (2603:10b6:510:1f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 11:13:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 11:13:40 +0000
Date: Mon, 15 Sep 2025 12:13:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <c2f129c5-7a59-46b7-8fd6-0bb052e597ba@lucifer.local>
References: <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
 <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
 <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
 <5099d9fe-4a07-4acd-95c8-782ffc74df37@lucifer.local>
 <1312fa3e-88dd-490a-9e07-9749c625933b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312fa3e-88dd-490a-9e07-9749c625933b@redhat.com>
X-ClientProxiedBy: LO4P265CA0275.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c48fc42-c606-4ad1-b743-08ddf448ec9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S9Bkev/6etguf4z/nPbKA3aOY0Iw0TAgdhmFY5SAYzt/5CMN/mMZEzNM3BXL?=
 =?us-ascii?Q?PsK6gvnVQUgpzXSFKb6Q8rPZqGnTJ6v6bzf4nL/mcSfWd1R1mlJe9tE/nt12?=
 =?us-ascii?Q?i1Hov5weLGT3UwIQExDjqVhBl79U6+yspg87q6HSti+sjC2GFgupzyC4vZdz?=
 =?us-ascii?Q?7yYxu8c/O892sJrbWta4ps8In6/k3jA65unQQr7/5N5fOjOQPFMvAt+d8ls8?=
 =?us-ascii?Q?xxYwew0cC5JUUuEnNsL5x7tdEybIMrxHh0k66nCm9yDJTFws85A9UVCemzqc?=
 =?us-ascii?Q?eWRY4vHM2mleRRcE6HPv2fmo+LYV4eOBNHroffwGzVRTm/vIazeG7V8va0U0?=
 =?us-ascii?Q?Y/TOCdoLe37LiOqhhDi6HTIaWAiyz6753zf7TLL3qI+y0A/e47mmD/DnCt5Y?=
 =?us-ascii?Q?LFbl6imZ4yWlpGp5sYvSGwTIw5OTPX9L0g0k2jBlN/xJS11yEU8xza3SkRq7?=
 =?us-ascii?Q?l2KVp/2gjWe8uMRdY8LQ2qVXi5dvDHCXLm4lK400Ury61MWg2cPulQGIN9Vf?=
 =?us-ascii?Q?MvgFULWtKWBTs7VokWi9/rt9GTdeo2QXrKJ7nAdPlpez89Nj2+AjX/D7fewC?=
 =?us-ascii?Q?B9yhr2YXBDAG2OiL0GLqxaRuYr/bLzuBWgWVO3J5ZmgCdEmKQdvfVYrF/PoJ?=
 =?us-ascii?Q?pNDnUpe/PtjYt+3a3hM9all14z2fUhHPUoOjjdmFnHcza/J7sdgjZ0eue4Zg?=
 =?us-ascii?Q?w82z7jrfsS1UVGEzSL5LlbByWWaDNKvX6Ik0Ok+6luhppjKyyX8oRoe13RO/?=
 =?us-ascii?Q?bmhhgtZULMOlUy1yzmudf7fkiZAHfT8C4J54z0dZu5gE0HxbjhT5R7Knsq+a?=
 =?us-ascii?Q?a/4DAFbEu4cn//yB0JjKGC9CPtzEk1YCNgKq6PQKCjCorh/dAOVgjXyuM1HL?=
 =?us-ascii?Q?LoPrIGpHCQ0StXME8xTmCyPImZSUBV2TamFGxki7p7Lk6ZMUW6/AMmJHCyJv?=
 =?us-ascii?Q?srCveI6Ts9gPjyqKZqh/6NXVczaf+AcevWMYgsWE7cfLHOOcPBYbbnhZEDqK?=
 =?us-ascii?Q?+a/4RLnMaFftUcoNk+TcbSBeSf0XLenzoI8CjvSYRfFlCnxlC/pVld8V5O46?=
 =?us-ascii?Q?xSwN94ZJtGYrbYbZAvrXrcxs7hP5LMzttDbm5c6RY/odsp+LARa3Ip0MlZAR?=
 =?us-ascii?Q?RbSIay/3AUXXyXPJRkd14AkfDkvAdC6uMAbXOwrl+vIG3vWd1Us4Kb7oL7Dp?=
 =?us-ascii?Q?ANZX44Z2kWmaO4IingRBSw10MmbdT2gr7U6AAuEdLZfy/T6d4c4sIyNTuaMW?=
 =?us-ascii?Q?LTomBauksdG8fbb5sr/ytNqfwKmhoWHTamAoT5MOXMURxumpeGWVRRWhPFcC?=
 =?us-ascii?Q?uWBhsf2YX3RH40mgs0GBpZAnoLLzC5+B2Y25Xj5xFxVC8kS+kwcxOLSvFa1a?=
 =?us-ascii?Q?gJbsgtrI6Wx4fwYUNaT57RYrxJgVjUEszvPCWqJz1K4leEJqW7WMCGRry/EA?=
 =?us-ascii?Q?7oJWqLNRpFs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uragbyK6BeR0EOdl3ONNWnlzAuKcQYXbU9glhXjkZkYbg45rwLRGv8xxZ0PV?=
 =?us-ascii?Q?AMqcyoDHI9QXpEFAu9iaD5G/zSKrII0crTG9dLKoACpbzPEVSo6hvuMF0Jdg?=
 =?us-ascii?Q?KqjV/BlgW51GEBPGDeBueT9c8ccKNs0AlXwfrBktjsl1EFJDZeEOfRic0IXC?=
 =?us-ascii?Q?yJp6QeVq34sAQBAice0rBmd+0I0ScsyHtw/iEUzDbhCmRr4VuaBidlz46XGh?=
 =?us-ascii?Q?UGY1K7UNubD+8ALn8OaL1TBAmJXTHsR2uPRy65BY/syhLzbZ3zm9bYB7Qr6R?=
 =?us-ascii?Q?I6tp9LE3EwR9NgXF/4ssJDFZUfxpgKQwXucy1Whciy0E9Mc+X897aE1JEYNS?=
 =?us-ascii?Q?wa/XfKKHFLNxFCn1NjpvjDCTMH3cEBtRMuefeYvEDbvnJFYint52m3ICJHL4?=
 =?us-ascii?Q?XtRbC8TVpUje4hVTVREnFUyrds1HQyNUag8orzJMHMzxBsR4qy3zG7FWTQ6J?=
 =?us-ascii?Q?4bxWvtZrknoTTdYdEuFgRgL381Ldg3UDpNDwZMek6w2iCTR4pilKq2CJT9ds?=
 =?us-ascii?Q?WSjaaIQ5aPHV4vQSsU929FiDtDAgvKtGSEWDqU3+nH3K8uBlPbG7sloeshSs?=
 =?us-ascii?Q?rI+k10uVzb/ZGqS71BBv1uOskWjvhgoPYPj2Ycjj4jukmmCzrAHJ8QyPSvVu?=
 =?us-ascii?Q?p/4Vjo+5ISvnyGP2Dj+F1Cy75SSoDpIupnnebRBbBw++T28AYgdPwt1EBRDO?=
 =?us-ascii?Q?Y4atu1gYpj592BHotnixfpABUSAs1N6jfXWlTPfybge2ibSZRLsZDGKln1M+?=
 =?us-ascii?Q?AA7LiqDWq+BqePz8uyLGFpDh/u255u9BSZ0vk1GwYCb/hiYCX84aSJjGWzaG?=
 =?us-ascii?Q?unnszNCmIs/+iz0EkEegIcoSJtXqmJ9ziQmH9cpG3pmbY/S0r4DyXtYNjy0l?=
 =?us-ascii?Q?On/AcUfcC1y0Vrt8pyekxb12BtR1KIntnqg5yvk41F8tA4qguVu4qd45hxkJ?=
 =?us-ascii?Q?KZX6ldznLCV2Onpg2htrujn7wiyS+3uhfo82nSlGj1di4G6+UKcQ+Zmmq6Fp?=
 =?us-ascii?Q?uxE/Ye4PNtwvG5otDRQZSDZn0CoiilileWuTxWDDvSTNtWFSB1SEDwX5rBf4?=
 =?us-ascii?Q?FQs9Ykt0yfbS9CNEtWB5wKUFSN4L//VFuxGOKGrGN5Pd4LQWlSg0HlmaqgSD?=
 =?us-ascii?Q?VCAvmINEH/Job32wQ7lNWw4F1bBY6mo2/qp8D6hQ/Sx4WiIzRIH2TVuxbNhF?=
 =?us-ascii?Q?mO0PxRjWzAWICJguinzdyyEDP5578NHQp+/VvC9+O0eog+mbjo74iAw0SJMw?=
 =?us-ascii?Q?X1+LFN3xLxYyIa5fPyfQwRGGk8WsJVl8GUPArRb1vQzEsx4Y1wXd0h6rrucc?=
 =?us-ascii?Q?VHhEM/1NWGAobtO2GoQQJTJzl9qsneJCoo100x3elLDAbEnw4R3ZemO1nRYV?=
 =?us-ascii?Q?CwJbsGIWPAlKF7E1NdtQuvGxDLzlcM41MgG7PoMqwPtyVj4rt0i8JPQ14yam?=
 =?us-ascii?Q?WunQ4ai45YUb/VmksnPus8FMrXD/HDFfdPgCYUc3OjUsAmHO1rA92TDvE5+s?=
 =?us-ascii?Q?vU0b7Zm78hsQwt1sbFGsNJ0pNFCK0S7OWz9ZKKh3SikQRtFr/D+5aaVxmSvB?=
 =?us-ascii?Q?mSkc/lCbwS9q0XW6oBc9rj0hTGbLrnugHEvPCQWiVWgn6GO9zvvbNAJ+hOSm?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9X4NSpvRR7l+aQ5xzpWthmizMiFwvSvI8Huyqu44aTiGUT5hzi9SEEcPib1YxpHOeN1jl8JlovMCJX+8S0JURmydIVrBuYmQEsn76oWsyGmiTgdX+IGU2DSb4yadcWnm7KkGc7rpy94ty82rLj1yzLMa0W5ZVlKOg4/clE+IE5uuBeCmuiphXqvn1+5YyHDRxpaDXVKziMhTeyjkxbFjBKOsax3hFCvoneinNEMXyjBA9MkMSf/qMxdJsbLuctzo1ypwnI3KD2iU9ZzFTJAB/+SpYqQm2OtW4sHI2DY0abU8lKQrM327ZrB5FZ9BbB9ijIzh9sZ6C7XBj+NSxl+4YmPZL6oh6SFoLqiluNHc8FtJ69omEYC+ufTJ46Itc4Nne2f0ZBJXf/vMesJ0InZ59CldqPfFbDEM9TG9s300pOIBvzLlxc72uYsKj7dveSGVMNB/Hm5swKDzO3SprwFryWAkY4NhLBR8q3j9faTVrhefXxPgXpleX1n/+S0aMDe6iJ8MTB0ZUDgSXiU5OadQcU7ocLy/OeB2ZaRxCoSm37bAdMkeBxdhcmsYORHn0mDZEPlJYiycUbAOIBqaSAUUG5Acbv68eC8G63UiCMHC0nQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c48fc42-c606-4ad1-b743-08ddf448ec9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 11:13:40.1676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFzxyL/SoMIQswl7vuCCpPdiME7UjLL0TprU2swS/jDmdGHch++4gqlvOnI1GU1X31deSZjwHR57LttXE1jZ6NsdkVhTK6L4yQCIE+55T3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxOCBTYWx0ZWRfX0yu3f+7VvGk8
 38LBplBxPjDl/SwXQc878AOlWsfiuvS6IxnE7wGBOeaYjdji3uhx1W2chpDW/tJbmc/SYRSkeCv
 BLHeoKhidaefZ4um96rGQB4oMTtq/Iu5G8uXZBS4IuSCbTg5rMynUSpyqFDO/5fPK9gYCmEbWCH
 yBdfvjcu/GrDEx1ErFukP5fBjgG2b2we1flXU0YAYc/dS8U7d1DeOAM2kHphPaRowtRHUacYN6O
 6WD9zlkj5bo/PpK+jTgelR3WQjdnnGdg46+rae4T4GjryRkCMNiJK5FIq6TpikoIxLVYjwkBGOp
 jN9Xm4Hao7bQB9v1W6QWuGKoE8+ELPgY7lT2NsHIZjKGX2ZngIhpSfA2XUIX0LKTRIGwRTlBPPb
 gzJ5KNYl
X-Proofpoint-ORIG-GUID: jGMq9C6y2wXEW74OmKp91wSJtBQ2mG2F
X-Authority-Analysis: v=2.4 cv=YKafyQGx c=1 sm=1 tr=0 ts=68c7f4e8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=rpXw8FcowLafCtWpXJ0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: jGMq9C6y2wXEW74OmKp91wSJtBQ2mG2F
X-Rspamd-Queue-Id: 7BCA4180010
X-Rspamd-Server: rspam05
X-Stat-Signature: 7i93m4o3h9mtxz5q8g9qeag4zwwwfuw5
X-Rspam-User: 
X-HE-Tag: 1757934844-526733
X-HE-Meta: U2FsdGVkX1+iUuSlOOGJvWfRSHgNQ4gQpq+Su5O/PPihwQ/TBEQ9t0wBj+Nw2e0LfNiMDS3WzpCy0KvyoG635FqIPL+ovCahgNqL0tszLU8fmvX+n/XoHjlZpKfquZ8h0ew/gRwV50hXcJEFoJfq3zIeNOxsJ0mYSxWn/6DjVFD/y9vR0iAsJWA5osYUM4xPAg1L40fU2smCnFPyc3rZhKQWKE5kF0eLRvt/p8ltk2MY0bF8qtnVCLPVQwOgJT8ST2P1csVvE6KuyoILYUsf3Lwmhpaff2AeQAQzU0aqaFAmzIbE3j2XajC+PxQgzXnmjjgA4xT+eqvMr47wGjqYe8vVlXOyT3TOMIThAgEWREmf/XLZSXANFZyCB7t7qh3YryQpVsgjuKxlw6Uu3M1qdhwSval1C6OGySF7jFd5JAYMsCkUFA3fwfD+n+NYssU4lLwx7it4bef517qWn+lGob2cLk8tt3wZWojn7/FKrgH4DqIbZ99kZ83CjcmNNECrjMzhFfrPj5qwlwhWWWfVyHrTbpOpWhKU0JgkjNh5dHcep1IKIjAY/1aEkzDRzf6Tx+Pr6pmZ2kspKAwFKYRuR43A9cbaxp0DpVg61gu+6KOqRYvsjmaa3+ufMHaudbqdYZBc5Uftr2di1r3vQHYooR+iYDXqyhlgZEkxTMY5iJ91NOb59Ud1pZdOU7BTSvB4e4L3onze1Agr9xge8QGtblmidHujyZHyJKQlmYeiahztXgDGXB3ZZpEP21EXKk38t9vjjakgU6JxyffajFfTnDPYZ5eKmYIWs9Ha1cubf3DFE9im/FeKR7QkCJhF/W66f/z8LQSh6kOMYpNsAcl9HBOhyhU0PKS5sTHxukjSjcL8xHNWirQvD1rLtg4q0f8aKbQL5h/3N/3quek+iJk/BE1WZn0QuE7GLYFcwupWIahh6WKuVwRNzSKbDpZnuDVqLuIxS0D69Nz/ya+8Im2
 VPS8o8Lv
 fJwYR9IZenBJt+Ye5sMMz839I/bK+fBCncUT3lLyLkBd62t6K6J3PCVV/aXe+Jf29R9bfEs/sCgTrBJUt9Hu0pHWsL6xfhrtbAL+VMvKoI4CAx0+03ULDqWkR3BPdB8JGzKl1TLvcA93kPkrYuEBoTK1GONnzd8N/xDG4bTDIKMu5sP4ziA4nmFhCZJmUV2KBl9rD5ylkCHkiadrqZrpm/9Q+dlwBfqNuB8WjtyVB5xgxEgwf3GBV+JC/nuCBjd+L2E5YGCqjquBI1sYiKPZh44uKMDpyYgJz79x2vF+1DFHDS3sK7ENhqU0MKX/yZ572DkOmsnDBtUtZpVRowjDx/ppDv3CP1zpo0PtbcwNYh8b8vR0X9F8GmeXTmJ9Q62QSau4DX/h0//KbXSPZlfPCr4W1UPajvZHq5wy7juM+Y1p/7XiUECyIqqUUdJzZHMqVsCgU9qpjqYujArrK8UDOUlHSZzGtLy0qzUi6AVUGQ0pmL63TDd/ZTexi7IY95ZcO6+rVL2ERlzmOTpLHuduzfV1eaVfYWGI7RA3JLyxM7yHwmqj5qukad/0E+ErIxFND503DmgJz6mtPxpYtOllQW0W8lUY1vZZstKLws6az0HlDxoM2it0TmezHL4p2K4T33eLLE3WoAgzD8ew4XopRAfpw/tz/WhIcEep8CNrLeerKtFyPEofogJ7gAyIWLkDQrIOhfyzbnZhwMkkWeEtKDAVXRdb0aYxN3ds6iNUuWHljNP7z+LlHgCYstQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 01:10:22PM +0200, David Hildenbrand wrote:
> On 15.09.25 12:59, Lorenzo Stoakes wrote:
> > On Mon, Sep 15, 2025 at 12:52:53PM +0200, David Hildenbrand wrote:
> > > On 15.09.25 12:48, Lorenzo Stoakes wrote:
> > > > On Mon, Sep 15, 2025 at 12:44:34PM +0200, David Hildenbrand wrote:
> > > > > > > > Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
> > > > > > >
> > > > > > > And at different mTHP levels too right?
> > > > > > >
> > > > > >
> > > > > > Another point here, since we have to keep:
> > > > > >
> > > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> > > > > >
> > > > > > Around, and users will try to set values there, presumably we will now add:
> > > > > >
> > > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
> > > > > >
> > > > > > How will we map <-> the two tunables?
> > > > >
> > > > > Well, the easy case if someone updates eagerness, then we simply et it to
> > > > > whatever magic value we compute and document.
> > > > >
> > > > > The other direction is more problematic, likely we'll simply warn and do
> > > > > something reasonable (map it to whatever eagerness scale is closest or
> > > > > simply indicate it as "-1" -- user intervened or sth like that)
> > > >
> > > > I don't love the idea of a -1 situation, as that's going to create some
> > > > confusion.
> > >
> > > swapiness also has a "max" parameter, so we could just say "override" /"
> > > disabled" / whatever?
> >
> > I don't love the user being able to override this though, let's just nuke their
> > ability to set this pleeeease.
> >
> > Because if they can override it, then we have to do some deeply nasty scaling
> > for mTHP again.
>
> There are ways to have it working internally, just using a different "scale"
> instead of the 100 -> 50 -> 25 etc.

Right. I mean with the exponential scale we could just algorithimically figure
out what the eagerness should be.

>
> I am afraid we cannot change the parameter to ignore other values because of
> the interaction with the shrinker that easily .... we might be able to
> detracted at wait a bunch of kernel releases probably.

:(

BTW 'Detracted at wait'? :P You mean we might be able to remove after a few
releases?

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

