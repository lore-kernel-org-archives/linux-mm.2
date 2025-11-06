Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7BDCCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 17:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C183C8E0005; Thu,  6 Nov 2025 12:17:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF958E0002; Thu,  6 Nov 2025 12:17:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7248E0005; Thu,  6 Nov 2025 12:17:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 922E28E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:17:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 294411DFA97
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:17:57 +0000 (UTC)
X-FDA: 84080839794.21.EE25B9C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id D11F1140004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:17:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Q7SoGknL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hnf/7SSG";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762449473; a=rsa-sha256;
	cv=pass;
	b=CQyXwizu2pJSaVgRBKFQOI/5iYde40/gWoQ9GtcUtDIETKjSLQxP8xHCFJjl683yHQeJx9
	N4qUWhQyPDQB2l0Wf7vPUissaQKb73hPEZgto2ECDY7feW1PYignzGVlu966XN1dhdd6dq
	jqbagZVdydiJtvdw2nI4azC6gSEQ2rg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Q7SoGknL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hnf/7SSG";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762449473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WA18n6hpiOwGdaxqfcjKpte5ppcAr/xjmDA6FtseNG8=;
	b=aXGhyyCW5akh9dkYRGeFO2Xb7piXF8n+KBkbX5e2aE4SMSNgG/z0DNqHqO00p5Hm7rYXOR
	DIuWO8PchmwSIyrLP8tRvxZ7cekUtROgwHs4P6x3oI0dezqR4vanYTm1R6sHaDMxcmt1Ni
	WPP4jYDY3HFnZprqV33gIrZ0D3NwLxs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CvRBT030458;
	Thu, 6 Nov 2025 17:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WA18n6hpiOwGdaxqfc
	jKpte5ppcAr/xjmDA6FtseNG8=; b=Q7SoGknLRJ/uODkefM1Ulgk21Nq+7kyGfs
	iv/vkCMZsS9L2swpDyvWe4cLxMHqrRW6x4Qh9kxRavH19gU7sajGz6wvLYl38OvV
	6/SpQG0s9nY19SAphQVLVDj7lt4gq227m7v8JzsQ6j9CrYTu+ab04sYpxevMoR+G
	JIwIKmWGj0/tnIvd/04Pv4gvSRlQHTHpEDdtzlP8PdxHrx9nPq11Caa8tjAS3UOM
	f8GG3FtUbyG7bI5hMHk0sMa+m8rybDo5l1tlRommycO4O3GZxUOkmvlmJO9yxsQD
	rbsc7124sByy8E1YWC0ILTeYrrquqh2HkRQPWrm19+PnRUTqCQIQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8anjjh52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 17:17:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HHaHY002685;
	Thu, 6 Nov 2025 17:17:44 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ng9acj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 17:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNgI0K9VtN5K/051bQ2Pb/Z1Ohv/MFbc2j3r+75+olbXT4UPqo0o3V9FUv6a/lN4L69ZqqnW+mtsRPYf3soVXFSYfZqkY/UoodTRZk18LUjaFgScdLhJpVtv8noZEBO4EV0PFUIlonh3TdFIlEFQFRR4bOqW/FnPk589wUImls9910H+f2jwI1fVI5T11toeD545DInAY75nDR3P9t8np9GuIogvqNetfmac0Pfhmq6RVZW1obEyLDQENhTGCAz5hnCgLFHFM+omMbBSTOx6tQdU1eQjFs+Yz9E25zT3AipaUEVtaO0lEUZfudUSi9PVwmApW1Pf0wpEQj+ANiQFaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WA18n6hpiOwGdaxqfcjKpte5ppcAr/xjmDA6FtseNG8=;
 b=V7FPdBC/xirzy445TkNkO8lGsuvGqwkrmC/Pccb2OyQfKxZT0Nh/SJk7WN74rbABtmkmK0jfhgmCABGweRPGnwB8Lwv8bh78BhUI6BX7iK9VtzyExsceYDK7ZaFNiFKo9+I8SuAsYlpBHvnUgyVlJSs/nWEvw7nhQaxhY6/hbBnl7d7gE5ZoRwS7YAcKVgY+ZlSQlMuwHFuf/sy9qKVa9Xa4v/VzfXTqBtcT94pGlBlO+Z3PYj5fjXmVj2O6nYvB+CBmkzqGCALE8qaMZOa2JGwrVjl/sM3di2BxAp7RFa6F3235IxksyZzZcQGdEuiv8/tndZP+jBLCZkEGbfa7sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WA18n6hpiOwGdaxqfcjKpte5ppcAr/xjmDA6FtseNG8=;
 b=Hnf/7SSG1mtokS3bfFuNAStwnd/ukt+EDYXsPRYVuG7fpNI4BGJ/5ObPPL09UTyU1UA2GPlQMZ7o3N2ffjAUWREWgjSjTHvYgyLvKEmTd9eqFpKzxbStv5SPscbY1kuDdvLfr71Q3MQgg9ZbxNjt8yKJFlsVxyKQsqn7IBMYAAs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7271.namprd10.prod.outlook.com (2603:10b6:8:f6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.12; Thu, 6 Nov 2025 17:17:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 17:17:41 +0000
Date: Thu, 6 Nov 2025 17:17:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        "Garg, Shivank" <shivankg@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        zokeefe@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
Message-ID: <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
 <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
X-ClientProxiedBy: LO4P265CA0110.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: dd2f1bb4-8ca5-447d-5904-08de1d586474
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yFnZtVQVVZdFK7EZjzjmfJRuOTUBlKRDxLM1mU4uJlOIuvJC/6WPX1qVCqcl?=
 =?us-ascii?Q?nuFm8iMcE23OFCCcqazzi9FAVbATtIdgp1XcPVyWL3EcL5VjS263KwLrplos?=
 =?us-ascii?Q?fG4nZZy2qSUq6z03VdH734QZKB3zuEpmdP+YXWRBsdZyRrCv5znNBhpRIcGu?=
 =?us-ascii?Q?hElvJ9j4VGBkC3BFYoX3X1+MLkh+GmZFdCeCT/dz8SgJkbSUtZ70MMdsV4/Y?=
 =?us-ascii?Q?r1OoWG3sC9do7D2qK+WlYhsySCVxXu67et+OCD3Q1FIkGcVJL6giRY9mnKyZ?=
 =?us-ascii?Q?VXXG7EppBZWBoMNNaRqjejH1lDn80sUaTVOGvlr5aIw226j/Fw0rXwJ2ny+8?=
 =?us-ascii?Q?G1v4A6gZy49mrU9yuutntTL4v9zGQ7Sae9EsDup/XNYjW3E6LJUvj74os+u9?=
 =?us-ascii?Q?4hCDj2SDBDJuPuKYSnFCKgcy/vc6fbVnMbPb13PMSSkPWYrGghGZjkt10nYV?=
 =?us-ascii?Q?HCvEIyGEL/wPEfgyrAvoMzgYAlnYlVEqAbnEvYPoS4tTkrVtQ/ll4f+1umhk?=
 =?us-ascii?Q?Om86zzSr3x+TLYOMCH4WdqHMp72ewJGELRyPGjdRBSAj1Re3WSZH+kDABZqv?=
 =?us-ascii?Q?nyCEqbjJOnmwdzccikpJyFkaVkjLDxYlexrap95CCHjB30XtOXhAHUBL8jF9?=
 =?us-ascii?Q?PqWg/9rEfD9HhfD5m+LHarTSp6JkU7WJrE/VaIRVhlVGRQalHv0qM+bp7G3+?=
 =?us-ascii?Q?DHIkZb1L12HgD3gBese51eXT5NuNIhFrby0qtTPMWTpuGGEsgc5VnezE4Z5r?=
 =?us-ascii?Q?sdqkt9tFmmpP1cUTbypLLCwBl3hH393LGScyBjtcEyUg15vxOYP7SSROiin3?=
 =?us-ascii?Q?JGLwlfaW/Om4mb41Bud/TP7rdXqgM6kqYxtBN8d4Kt+EPrftNA6gAx0g0GzP?=
 =?us-ascii?Q?jIiff56no0ORFjxLRv+PRoxqXloXvCIU3mBhWYtoJkHSHowoFlsXOwSYfaAZ?=
 =?us-ascii?Q?ea+FfEbkwiAW0v05qkUg1Ch7A1Ba6uhLOvZTs1pBUW6U3QVzMKji32kCBE4D?=
 =?us-ascii?Q?/G5vXy3Ghdkx6J2Lrl66UTSAr4KpJUUOPSg2tjQoyO58pjbv0B+4T6DF/daO?=
 =?us-ascii?Q?QrAidyAOe9sSnY8jFM6guVfW0oTz9I1lCjkIlx8FiP+vlTtgd1X5whdFbNd6?=
 =?us-ascii?Q?/sy2LVQ42aiBgR+QgkRqfIKMho2h68nuAMdTtZkgiWbPHwG2aVw+az5X7uIh?=
 =?us-ascii?Q?Q9zkjrYS2kw3cXhiB3se5eQiQWM5ggy3lKY2pXOzKcH5wvknB1xO18J51AtI?=
 =?us-ascii?Q?mJwsWMgaVh6uQsSmxsgn0rUB7Zx+N6Gd8XQ9KLd68YgpLA64cj2vODD4U3NN?=
 =?us-ascii?Q?jlL79WtGBIcqY67+i+sQY0QEHvWHm4UOrWPw/p0bs3f7lIp7oAMmWjdvW9WI?=
 =?us-ascii?Q?gUGYriLFmyUOPvpzneYBroVQJkzfINFxke5oJ1M4iQPEcepHP8CIn4tLA0bx?=
 =?us-ascii?Q?+gAimKec4gKJmY3pOGSjxBm2hT+xzwysDFdXVbDH50KnwwV51pZ0OFL1DqeU?=
 =?us-ascii?Q?hLhNMPYiEJW0/yA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EP1G7qySE3Va3MPnZyGwN/z540peECgbqeB8wZ0xrEtMLW8EDTgh+t0t/7rD?=
 =?us-ascii?Q?PO6pEH0TKo5N7Qbog6KaRTYbliOcgMBfABflr2ED57bvunhDp8vvssNv74ZR?=
 =?us-ascii?Q?prtsa7RHT58JSV64k0BtDDLb6wSXDtAt/r2bN0Rtxt8PjNyMkEYfOD09Repz?=
 =?us-ascii?Q?0GikG+LH/dXmN7/FcPPVKOjYdNkC/6ywfv8w4DFeLcEQXRzozbcT4KuodGpL?=
 =?us-ascii?Q?B2FQlx1xCFxlB29ylvdqgjxO+4VeCzcc5pWNAC9+LqrUMgtr40A4KgLUWrTC?=
 =?us-ascii?Q?QvwGH9pDTG4uCZ+E648Po35vjlVCIfUxoiaQgZL+GkY1o2jwK8rgDBKi2sxb?=
 =?us-ascii?Q?uHF52aE72c65YFoqdsCdmP5IuCSeJYdC4vKVdVh+RY6dk3QipFxQ4gzM6HzL?=
 =?us-ascii?Q?mf7W2aOIWyYdzoYaIAFJv9nYFDG1uevIRe3XCScNkp2WEqsMNpaRFFqkBsWn?=
 =?us-ascii?Q?rTf+1Moumkjyaicc7S9Boo6/SKh9xhMsVztytfPSFM6arfzs1yfd/EZx330d?=
 =?us-ascii?Q?PNvPqO/4BZbP5VoEjk0XILgI0FyUAZehinRAHLN1kxWPCyKIR7uaxHC43HJs?=
 =?us-ascii?Q?4n1ZI31S/vQKokVTAEEDLyqeuHSzWySGi8QoOCa3u/V8TWn2lAtT9rZT45jn?=
 =?us-ascii?Q?W5oy9lasiUy6hBD8oMT6m5v0GxC2ypGdj2wir0Y82C2ZeZjmvDlQuLPLLh17?=
 =?us-ascii?Q?fL7/JPHqh876bMHJRRIn/AdilIQC4efBan1aqzNL8n9xY9VAfKA46e680ugT?=
 =?us-ascii?Q?sawL9WBoz65xU+syQpM538IYJpe8JeE+W0hQk8eFLmUEaFPVv3qCoiBNITRl?=
 =?us-ascii?Q?xe2j4W36SS7mzVpgW8ASB6Hy8/NJ3P1etB7VhlRalEVGhH3rhSNNycRVXFZU?=
 =?us-ascii?Q?SfNPWGK1iBBsSTwG9Tfzt7IPGe4oFW6J+MxqkHa0/5CsY9+9g69XKOJDZEOf?=
 =?us-ascii?Q?UvEZyscquu/Kh8w8r7BfFcquno/kUfnloRyqdZz9qWjMeRsW3hX8ljvXYZSx?=
 =?us-ascii?Q?rXUuDIw3e+r3JNLHONTjOJhsRyngOMlzihGrenvE0K12nMcLoCzfhRnenDel?=
 =?us-ascii?Q?RozquZT08wLCuAuOJwY0hsN0uvfrGI2X3MuxHIEunal55eATybuKOAZ0s+K9?=
 =?us-ascii?Q?miEBcZJ81aevlL705ReZ3fjWj9NdgVKoSTQXPdw0mjcOJ8LYyFJ6l6WYvsD0?=
 =?us-ascii?Q?C0c1NlgX7Dh11iONEG4eoELllKbqvvQcUARw8AFPuKK28oT7NKNO1DSRXPNH?=
 =?us-ascii?Q?r0bsUqUCzBc3D06MoTZb8sG7fRbN9EDl3pvVehmzPavZSwts+hWzzklxoOFQ?=
 =?us-ascii?Q?1w9uEBGE/JIl0mnJPikd1nmu2pn0k1blyxQ+RKdRTK23Duxf4Azu2/ZgYo6u?=
 =?us-ascii?Q?QMWU2ZiqAlldkN53oPfE+4dcF++qieOKNacMqptrilQ22xRH9ojzLLaKqCSQ?=
 =?us-ascii?Q?jyxS5Owba9GrAel3UP0txHiLlo9tknm7XnYjGCkXEF1vqxyqd5+AV9UXxjzU?=
 =?us-ascii?Q?dcMZu/tVfm0cEAwUMTo3r3L0RAkrRbra8SWNSfOubJr349WJ4AN38SIWzeEv?=
 =?us-ascii?Q?rMgtt1mDRzaS3dUTiOoGyxFD+PHh/cjY+rToTTrQGSFLxfCsGAtewVPtO9bv?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EDETqGTOVnYxmWs2bX0NLSOsvDSBuroDZgJspq6zSJ0kmnSOR1QhkgxcS3GOde5UqqMXQhZkX0v+lPohdMoYD6neM5avrqPTRTUxBWF2gVavjjfNVPxY+cvzniua43lZlCznLMyKiuHMOkuoWdgo6OWINZD04rztEyhqQMewBmJjcSyq72y1pyvJmT/bab3dHGJqVWujUK0gEX9iNuCTe0xstIhQ25l3wG9TZPgIsL/5y296q96lPHxe0ib//t1oW0rf+ibLuLronVmowjkWY+bee1f4NiTst76ytb6fRiCDGwzrDv0ZXktjV18Ljgd6zsJLBNfg5QjvutnRyyho/fT3ZIJbSerGiYCwiioXymG9jBZb6dvOr9I3rZAVplV9Sp/IrO+/jlPys9TcD5wtJMqrrOEs61ykZLgYN4hffD0DYKf9IaDi2ZT5x2SGQ/Nd/5r3dbqa7C7ID3sP7FjpI/13DiCHGZwnVW2RR95NGqLKYV6vGY10wht89TRmm6moKXkoqFwFKGWldo7POlaZCE6wlelCouOtEYezf4e8T/BVSuq723kHxiFIn6xm6xeW/J3unJFI9Eewi+9upOIOlsSecHcum/Ow4e8eQ/kFeYA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2f1bb4-8ca5-447d-5904-08de1d586474
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 17:17:41.4556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICOiIFE8Ud8WI96ROTk+LR6HO/RH+VaFfc+B9Zgg3PISaOIm0/B2u6yGiTvhi3UkEqP8VE7DweKll60FXp4NTHzAoGXTGD/ud3VnCyf/feg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7271
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfX30crbED0q7ap
 mcyY3Xkq0C5dut5jNNIb8RYb1Qa8coHC5pyMrBwXS8/9+AzQruGbuTET3K2XeWILSJ4wBOA2hj4
 ZfaOqdK5NqhggWgVj4BiSBGukjBiLQMrSLtCN4SwOHOz6+vMFm5KsicUxHwWykiaIZ9bCNXVnWv
 myApcsUetWga0z3I54rtuInVLdHd3f/qBYpMxFx/q+d9OoFIZWZ2S3cSHlW/FZxiungKTXuGNja
 fgecTaFqmeSIUFYyeFX9Ss319BXO1mVgoqxM2/SFpu9/SdnyB2RnrYeqy51x0w9CwAya/lCixMW
 wGGul8GfFHvO3NVzFkbTpBqR6zFIEDvF5q5omLZ1rG/w2KkWLilGDWos2syh5LN5WDsO5z019+M
 OaqckUaTs2tvNAOLA2aZtHqJMTcW2RPAB10XSlGipvfK+wLP96U=
X-Authority-Analysis: v=2.4 cv=dfqNHHXe c=1 sm=1 tr=0 ts=690cd839 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7CQSdrXTAAAA:8 a=jOkseGbcl4iAh8OUpOgA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13634
X-Proofpoint-GUID: PnA-HQkK8i8pn3TSLonoWpXaQiAGjMfs
X-Proofpoint-ORIG-GUID: PnA-HQkK8i8pn3TSLonoWpXaQiAGjMfs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D11F1140004
X-Stat-Signature: semu6brzaxajq19yujt1tpyk46k18daf
X-HE-Tag: 1762449473-816870
X-HE-Meta: U2FsdGVkX1/XrLQHYryBj/i2NnAjDxS8HIIeeDUc8l6s+QAlkTPXQCUX3RgoNUIFmJZoyGA+CmPNpoSN1k1PpTFPjzmxJWqUC86H3nIqmqUpEcV+8EmsxFFKvKxaT+eZ2ZUW+WawQeLq/Jy7aSqMma3pli1FNCAGx79UFAHcxuIdvf8UsF/l59j+v73mypxQ50lr3W9djuyGsDxrMOZSMu0mRIvpeHagDWMnemgYT18RXHnfKv6Ai2S8wqBvYlrRi/JPWNDsMz7nd4FTSuHTzDbGF7QByEq0gQR8QgRmly6n8xmCoDTuMDtUeIRFFKC1Po1Im9Px5YvuC3rKNM7OTfXLQIvmI4bWng35p6NV8BCkqADnAfXMx8RiCRjQRuRzh1OKhMWBFzkzvZQ9tgJRnccg8j3b/fLBkzpifM9dOzmsf9uZF452uRKLFUTh8vKLU2eof/gAyM3vTi3pK1tmO3REIg4XokrQjIFQLeUwTp1pfPmstbtC/ynQF3CSwNz2B5ses3djLlPexUCz09Agqwm26r5aeT0wy22aGQoLodpQiqoBPQoz0CesJrbBwgn1O1OXiaONNpOC8RTiojDrr6N8OUnlyB++bQOe471hkULIVcfPX9Hw7RSRk/1bQVhHzC0E0L25IN1PAlb5napKoLQd6vDC97ntfcUk+qwRAXyXF6zGrDcvZExTDjPHMyiflBqKzI4RjPCqLvFgBpIyRXsT0/6vyxczAzXimNw/5cI2GfKfnQzGNYEkHDtlOB/2l/mBxmOk8SXfKbgkmiwn8+nxGIpJjycESpLqax6iFxt2MNQgKJKBjW39mtGBihO2cuGmnxruP0c6t7GP2z2l+p9j9OXpVmHVTUp6FrTJdQlIsqlJFqRZUILGfVPU0w5NBFSzkqNjzfJ447uBKyFH/LnovLiimsNFbJg0Hz7A0ERBcYXtZuG/mwCk2uo2yPQykiLj8No77fJFayXoTRG
 FKc2sMHB
 3j+i7nKX0xq3R9lYK/ABC91hbfoV1of6lehnBZfyDtz9chcLUgjxeZkAMwTkiVmoDBQUkLo+SE0wvg1ypt4cY4qW/FisIxJJuDBcIJ2ofGKbVCvwfmMyR1WArHL6HmlRwiT7B1AUyY9xHDgZ6aMphVsgl4//14S9IHny4qbSwhPQgzXLOlekxucj3DknyAeAecmrqO8wvPBkNEMm2WVM0k1vOIJBCCTYuMJg6aIgzLnSP66rGmqoSdEkdu32dABH4Od9e5l3LPv3a63IgAu7m162YuH0f2wTS5/wo8Q63AsG+UxlXPskXeSHm0QYojN9SPwwFwwzqu1rdp+3XtpSCefeCf5kZGV1zCwMnaDoOLAFxV8W6P28dlMtJ1eonz3QW4un9c9snr8uw4msyl87Qtz2R/fae/1CoKx+yk9KxCb0D7vpLCrZIxly4FsfIeHxE85MlRE7bFNBV1c86m6o32Mg40ttjfdwD/hdxUHe0W/sVvzSPgt+d5lCrJH8cY9flWTRzFq4LUyx1NXOkRWAFTN7v/Hk83JKhXweKLR30CqbX59DBHRwVllsxu2le206pQ2uG0F74Hz90gfiVuShfuJ29sBFJkpKKd7WRELwVG7+1zmv6BD0D9O9Nu2wLDZuEvXDNroOZlGdtSh9JBwOVAo8sWCBj2B/Up2X/ZoEecJIvF+BXt8qY/b07nNMth2AC8YfVFl3trV5K9fZYxo/LJP+ng/K9/rme7HMJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:55:05AM -0500, Liam R. Howlett wrote:
> * Ryan Roberts <ryan.roberts@arm.com> [251106 11:33]:
> > On 06/11/2025 12:16, Garg, Shivank wrote:
> > > Hi All,
> > >
> > > I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT pages
> > > when CONFIG_READ_ONLY_THP_FOR_FS=y is enabled, and would like to discuss the
> > > current behavior and improvements.
> > >
> > > Problem:
> > > When attempting to collapse read-only file-backed TEXT sections into THPs
> > > using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the pages
> > > are marked dirty.
> > > madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and errno = -22
> > >
> > > Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first madvise
> > > attempt triggers filemap_flush() which initiates async writeback of the dirty folios.
> > >
> > > Root Cause:
> > > The failure occurs in mm/khugepaged.c:collapse_file():
> > > } else if (folio_test_dirty(folio)) {
> > >     /*
> > >      * khugepaged only works on read-only fd,
> > >      * so this page is dirty because it hasn't
> > >      * been flushed since first write. There
> > >      * won't be new dirty pages.
> > >      *
> > >      * Trigger async flush here and hope the
> > >      * writeback is done when khugepaged
> > >      * revisits this page.
> > >      */
> > >     xas_unlock_irq(&xas);
> > >     filemap_flush(mapping);
> > >     result = SCAN_FAIL;
> > >     goto xa_unlocked;
> > > }
> > >
> > > Why the text pages are dirty?
> >
> > This is the real question to to answer, I think...
>
> Agree with Ryan here, let's stop things from being marked dirty if they
> are not.

Hmm I wonder if we have some broken assumptions in khugepaged for MAP_PRIVATE
mappings.

collapse_single_pmd()
-> collapse_scan_file() if not vma_is_anonymous() (it won't be)
-> collapse_file()
-> the snippet above.

But that could be running on an anon folio...

Yup given it's CONFIG_READY_ONLY_THP_FOR_FS that is strange. We are confounding
expectations here surely?

Presumably it's because these are MAP_PRIVATE mappings, so this is an anon folio
but then collapse_file() goes into the snippet above and gets very confused.

Do we need to add a folio_test_anon() here?

Unless I'm missing something... (very possible, am only glancing over the code
here)

>
> >
> > What architecture are you running on?
> >
> >
> > > It initially seemed unusual for a read-only text section to be marked as dirty, but
> > > this was actually confirmed by /proc/pid/smaps.
> > >
> > > 55bc90200000-55bc91200000 r-xp 00400000 07:00 133                        /mnt/xfs-mnt/large_binary_thp
> > > Size:              16384 kB
> > > KernelPageSize:        4 kB
> > > MMUPageSize:           4 kB
> > > Rss:                 256 kB
> > > Pss:                 256 kB
> > > Pss_Dirty:           256 kB
> > > Shared_Clean:          0 kB
> > > Shared_Dirty:          0 kB
> > > Private_Clean:         0 kB
> > > Private_Dirty:       256 kB
> > >
> > > /proc/pid/smaps (before calling MADV_COLLAPSE) showing Private_Dirty pages in r-xp mappings.
> > > This may be due to dynamic linker and relocations that occurred during program loading.
> >
> > On arm64 at least, I wouldn't expect the text to be modified. Relocations should
> > be handled in data. But given you have private dirty pages here, they must have
> > been cow'ed and are therefore anonymous? In which case, where is writeback
> > actually going?

Well ther won't be any right? I mean it's fairly normal to modify these
MAP_PRIVATE mapping isn't it for relocations etc.?

You clipped the Anonymous line here, could you share it?

> >
> > >
> > > Reproduction using XFS/EXT4:
> > >
> > > 1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load TEXT segment is
> > >    2MB-aligned and sized to a multiple of 2MB.
> > >   Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
> > > LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000 0x1000000 R E 0x200000
> > >
> > > 2. Create and mount the XFS/EXT4 fs:
> > >    dd if=/dev/zero of=/tmp/xfs-test.img bs=1M count=1024
> > >    losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
> > >    mkfs.xfs -f /dev/loop0
> > >    mkdir -p /mnt/xfs-mnt
> > >    mount /dev/loop0 /mnt/xfs-mnt
> > > 3. Copy the binaries to /mnt/xfs-mnt and execute.
> > > 4. Returns -EINVAL on first run, then run successfully on subsequent run. (100% reproducible)
> > > 5. To reproduce again; reboot/kexec and repeat from step 2.
> > >
> > > Workaround:
> > > 1. Manually flush dirty pages before calling madvise(MADV_COLLAPSE):
> > > 	int fd = open("/proc/self/exe", O_RDONLY);
> > > 	if (fd >= 0) {
> > > 		fsync(fd);
> > > 		close(fd);
> > > 	}

Are you literally madvise()'ing the text portion of the executable?

It's strange this would make a difference in that case hmm...

> > > 	// Now madvise(MADV_COLLAPSE) succeeds
> > > 2. Alternatively, retrying madvise_collapse on EINVAL failure also work.

Hmm that's strange.

> > >
> > > Problems with Current Behavior:
> > > 1. Confusing Error Code: The syscall returns EINVAL which typically indicates invalid arguments
> > >    rather than a transient condition that could succeed on retry.
>
> This is also an issue though.  Reading the documentation on my system,
> EINVAL with collapse has two meanings:
>         EINVAL addr is not page-aligned or length is negative.
>         EINVAL advice is not a valid.
> Neither are right here.
>
> EAGAIN seems to make sense, but the documentation would need to be
> changed too:
>         EAGAIN A kernel resource was temporarily unavailable.

I think these documented error codes are a total fantasy anyway in general for
all system calls, and it'd be silly to try to list every single possible failure
case in the man page. I really wish we didn't even try but there's horrible
inconsistencies and missing entries for _tonnes_ of system calls.

So not sure if it's worth updating.

But obviously be good to have more information than less...

>
> > >
> > > 2. Non-Transparent Handling: Users are unaware they need to flush dirty pages manually. Current
> > >    madvise_collapse assumes the caller is khugepaged (as per code snippet comment) which will revisit
> > >    the page. However, when called via madvise(MADV_COLLAPSE), the userspace program typically don't
> > >    retry, making the async flush ineffective. Should we differentiate between madvise and khugepaged
> > >    behavior for MADV_COLLAPSE?
>
> The collapse documentation states that it works on the existing state of
> the system memory, so it is doing what it says but the EINVAL return on
> dirty pages is not documented, afaict?

It'd be good to document that this will fail if there are dirty pages yes.

>
> > >
> > > Would appreciate thoughts on the best approach to address this issue.
> > >
> > > Thanks,
> > > Shivank
> >

Cheers, Lorenzo

