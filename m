Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D218CCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3CA8E0096; Mon,  3 Nov 2025 09:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374208E005A; Mon,  3 Nov 2025 09:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE2B8E0096; Mon,  3 Nov 2025 09:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 073A68E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:59:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEC5012AA41
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:59:16 +0000 (UTC)
X-FDA: 84069603912.30.0348AAE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47FED180004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:59:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bKkSaDV+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CA4wAAdj;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762181953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/u1Lj0g2vy64wlqr9tN2fKS7HfJvGtuPn+JhED+TXPU=;
	b=XsFifT5XJRADzEOlS44Bo29SrxadqZuXg65AmtKgiOvcOCQXXsF3KwaJ7scGKgGBHo01EQ
	x7Eetcl9YJw/PW7croz/JhQs6GI6GF1EHWj49omB8elfhMH0gNdjvJ0cPMTgXtXn0orLQS
	A/X4Kanr6C4QFPxWdJTrCEjftGisJy4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bKkSaDV+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CA4wAAdj;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762181953; a=rsa-sha256;
	cv=pass;
	b=L8hU0bKMir1xEfpOxkZRwecKtJalmtXCJ38kL+ienw3q56coOITzi0I7jxUoSGJXUwi1K3
	2Scgdl1y4SKdzDp6nVYo2xrpAATKazLIFGI68y/AL2khOXJ7VB0ixRV6zR8joJmY5X7+uz
	m0hKCIrrdScWOQIICYQlYQiQxzU33Dw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3ETb1U022633;
	Mon, 3 Nov 2025 14:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/u1Lj0g2vy64wlqr9tN2fKS7HfJvGtuPn+JhED+TXPU=; b=
	bKkSaDV+oRY0DrVNRktMvPuduNn+fvkgoo1j95XW15YXo56m4xgb8IqVDmaP88IQ
	6bw0VuKYOQmEl9Ks3L1CAjYlu6rIQBoi+yHl1YmJr+hz2o0T2/8bHToqt3PAMP85
	jk8fcqdCWiZ/W6Pt11l8MckDjk7EG29ZjAG/WMgJR0VZKbSoZlleX/Isr/NjzNjV
	fvVthvomxnVsANHzvc/nN+T4vxbe498yGflHCLgDoju0qNCq5z2pH3IDDL8ZBI0d
	FmTnV5PQeTqNn0RcVny2S+URaMAH4rXOCNI2pEBrO+fglatlmlAyipmH9zvelKlW
	KzHEJe6epWEGPKRZSgrtpg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6x6vg317-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 14:59:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3DkjrE020996;
	Mon, 3 Nov 2025 14:59:04 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n88hd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 14:59:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmpLiaHRH9Mhzf8iDQy0/0spdxrMHvbsnrEGs29WAE4mZKo/lOaQBgu9YvFOrAZzvga/JSPsSt+61BIZW+5G9pu4ITEtBVb3Y8RgU1EZnPF8cdfYSaz05THgNnTCGp52xkSE0T6qqWSKujFP15DhrsASK82TiqCMrzaJjHvDikC1q/XyK038WPrnCB5pe9R99AoR197rL+JC/s5t9hUF2pps/96rc/AV/ALgWyda9eaareDgGjnADkohQ75XJPk22XcBLDgq3EDb8mEEF8UtycDt5tavgSmhCmP10IkLntDHp6PoB5WBt/f3qSgXf2XrCe2W96tUK1pOz3WaFmq20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/u1Lj0g2vy64wlqr9tN2fKS7HfJvGtuPn+JhED+TXPU=;
 b=noRqKj3DkrS2kLiLSQbWL7AzGi0ySHkPNBpd4qFvphCbvkY1Za1xq4U1O0t/0dDKwNDWQmU8+Na4IJofYhYou5EzgzByyEWpF59MfRjOTsnfGvZATw4poMsUgomAXUON8zDnh6Iu9cEhhsSaUb4KKtKf8oqdPMzCwnjazXd8+Lm5CTIcjw1BdI8JxQOh7G1RBh2mr8iflzJNVrIZ9uy4LT9Hto0axbcwkvgbPE4LJ7cYNTTP8uvx2Evwqj+7jR4THz1TPNO3xwGMhBFVfw+Lp//N0mGmgfuahNyqQPVq/IEHqCNK/vZk+glNTMxhdQ32w1ddG6b7xw+1dG2p2QPdsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u1Lj0g2vy64wlqr9tN2fKS7HfJvGtuPn+JhED+TXPU=;
 b=CA4wAAdjilFAXi4cVV6OiTCe+fdnQ6JuG/8S+BoCv8ZGZ/aC4TFGJwtWnRM+PMjkHuMU6nEMd6ttAa/QD9+n9FgI6mTavxMgKdQnfsIaF9D5v9J92hqo8vp8F7n6aXvNCm3JyqPdOZbpOEKujlMNFDccAiPRLknZ+3WOniZqOcI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 14:59:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 14:59:01 +0000
Date: Mon, 3 Nov 2025 14:58:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <ecfc09fb-cc4a-488a-bd0b-4f5b3af3a2ac@lucifer.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
 <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0245.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 357f3753-c4f3-472d-2d03-08de1ae98660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejNySVZiZnpWQWtTajdUS25PRUtIOGR6SWpOT0tKeS8rVUdscmJPQUxtOWdJ?=
 =?utf-8?B?Wm90bTJBSWxqTEVEeEVBWU5BNEhyOWZOKzVCK1h6VjZSSUdVUFl5dkNwOWlU?=
 =?utf-8?B?MW1zUGVpK2o5a05ERlczcHZHeUVORi96blhKVnhoSHg3Y0VDcVR3S2pGeTBu?=
 =?utf-8?B?aWlNbjF0SlFHVVpOd3B5Z3RhUVpZTTFIU2VmamxvS2hrNHY1MVFOR0xaM0p3?=
 =?utf-8?B?L3dPS1JFc3RpREhWVEtnN2ZUOHJYRnAyeVZPR1BBblRUVWRySlpkZk5CSEJp?=
 =?utf-8?B?ZmVSakZVTmMxYlNiS0g1ci8wYmtxRldtSzVPbGMvems5N3BxSVNKSC9iYWJS?=
 =?utf-8?B?dlpoQW1NanY1OE0vc3JSMmszdGlHOGtpVEN1V3ZVTTFBRTU3RGl6R0MwUTk0?=
 =?utf-8?B?U0E4YnZWTjg1b1I4T0NRU1BuMVV6STZid2x2VlBlUm4xRmxLckcwZGN0WWJa?=
 =?utf-8?B?ZjJlZ096TzFxZGg1OG1PSDZEaVBVbTFpemNZTUZLc3ZEdWhOVHNmakd5cUZH?=
 =?utf-8?B?aThSZUV4a1o5eTJYaUJGUDJ4Z21CY252bnlYS2k2RHRjRHpjQk1QQzRKZXZB?=
 =?utf-8?B?c1FHM2pCclh0ZFFWZ2RKMHJKUnJPRVFPZzhmZTUwRFh2VXJRcVRpNlZrN2V0?=
 =?utf-8?B?N3orTWY5VTVSRDhBN1FQVlVCdFIyUm9Ec3ZhUDJCR2hXOG9MYlptUkZ2bTJP?=
 =?utf-8?B?WmxhbmNNVWZlcWZ4eHpqeTZwbU9tU0owQitlVVRWUnpTaC8xdFNXQkkxRHVH?=
 =?utf-8?B?NzVSd3JieTFjYmUrejc1Z01BMTY2anZTaVM3T29TSmVBVWFuSGlsRmNNUStP?=
 =?utf-8?B?OHFaNU1CaWw5cStuQnMxc3l4bFU1WVVwRFllNVBXUkpzWnJCN3IxL1NNc1po?=
 =?utf-8?B?NkdTd3dFbDBFTFR1VkEyY0ZzdEpMeXo2RURWNFZMdm1uUEMxRGd2Q2RleHZ6?=
 =?utf-8?B?Y0F0UEVTMSt5NG5zQ1RqaDJwOUFjQ0x2Yjh1YXVJeFB1MzUyM3VZc3g3anZC?=
 =?utf-8?B?QTU5ZGdGYkVYUDdjMnV6Z1YyYWxMb3NPNm01M2ZLdzFYVGM2a3RMUGljaXNH?=
 =?utf-8?B?eCtWQVppMXk0UDVCdEtPUXFTWVBnY3hzekhXVmFQbm41VWFmeWdwa0FJL2Qz?=
 =?utf-8?B?b1ZZZG55ZkRkNkIzUFZqcncxNC9wam45djdNM0NQT20yUHpyRVFSS1R0NktV?=
 =?utf-8?B?TUJlV2lpL3Z6VDNoM0dhSE8zNHJqZmRjYXhka1ZBb0JKVThlSVZjaWg0QzRt?=
 =?utf-8?B?bmpMdVhReWUzNEJwWmtrYTRWenJVdGpON0x6R3pBNHVub1U2ODVubUt2djZC?=
 =?utf-8?B?NFd4VEVjQm9UVG54cEFGLzlZeTBRMUdjNURXOGQ0ZFU0bFVQTTBhZTFsbUEv?=
 =?utf-8?B?YktzODZTV2dUK3Zid2Jjb1lPMGxpTDZISXJTMC9MeElBNUxDanhSWTR6NHVP?=
 =?utf-8?B?ZzF0WmxESHhsTTdjZXNXU3JDQys1di8yWmU4VG4xdzVMRzQxQ3FjNnVNMkUw?=
 =?utf-8?B?c0J6R0lJZWVQQW9sUnV2YjBnMEpvNnc0OXVQY1VoNlhnZE9la0g0VlRwN09K?=
 =?utf-8?B?bXNDMzZVV0xLZVBva1BEeG1YTGZGNkVXMUg2T3VtYk80d1RWbnc0MFJqNXVV?=
 =?utf-8?B?S1phM01EdzEzbE9PVDMxTHZFK01sWUhqeElBNWxFTGJhbWZwSHAva2VtS2NK?=
 =?utf-8?B?eXFWbml2ZlRHS1p2NTNhR0VGVk5CNGpHTVFDYXRNMW5wNU1SWXlUQzBxaDZV?=
 =?utf-8?B?VTM1WEZWZkVjemdBTWxWQ0pkUURZSmtpc0dOTlRaMGJ6TVZISEFCejdwUmZL?=
 =?utf-8?B?d09HMmlSbHBuS2dpL0ZuUzBad1BIVnRzZFlqRENsc3MrbU5nRHZRV3FZdnVV?=
 =?utf-8?B?Qk9SNDBXMnk5U29janZoWGdxenZ6Z2hQSGswbE8vTmk3bU5wTzYyR2lrMGZO?=
 =?utf-8?Q?X29liO8X6IXyfYTWG/Svyo1fv3PqK8z3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUhNclhYQk9naU9KUEJQVDlQazZnRjVFVS9EMzBGbFQ4N3hWYUR3ZVJ0cCth?=
 =?utf-8?B?U0ZlR21jWlo4aWlPNWdkQkoycFYvQjgxakZaMkJxZXh6bGRDTnoyQStoeU1R?=
 =?utf-8?B?U2FmNFZKRFVGSk1Bb3Z0ZjM2dkhpV3U3cG9Dd3lZeGttOVhOOFJKWnRqNU4y?=
 =?utf-8?B?UlpibS9oMndFeUhyTHJldFd6ai91anV6dlVtYWNORWRtdVcvNnMwTnBmcjg3?=
 =?utf-8?B?ZFdLTVErOHd1OG5XWkZLbkM4TnEwNExnQ1Q0U0J6MDhJNG1IeGt4bWVoTlMx?=
 =?utf-8?B?ekpNS1FFeEJCNnBEL2sydnNqb3Z2dkhWaCtma2RScDVESXdXV0NUckRSa3Bk?=
 =?utf-8?B?YnJsc3ZSeWxGWUdmQWtkUURONmVEbmNOcGd4cGY2cW5CQUFZYzdQUWtTVEFM?=
 =?utf-8?B?VDdJYm5zcFpmbXMxUlRTcWZuSWNRcEhaNlAzelF4TDltNEptY1B5M2Jicndo?=
 =?utf-8?B?YWMvaHlON01aMzhCNW5kamlkL2VuamJlU2ZQd0I5T3hVdUQ5Mmd0LytzU3lT?=
 =?utf-8?B?TmszSTE4REdvNHZyWnZDaEtwc3BvRDBMQTMzSXBPZngxRE4vREIrQ3MxZE5Y?=
 =?utf-8?B?b3pCS3NMbEY0UXZVcjV5citjRmVXR0p4Z0o1UkMvWThiWW1Mc3IvcjVlTEVo?=
 =?utf-8?B?WFRvR0lKM0pxQkhkcW44Sy9FdnpONnpub0dDMTRNdis2bjFIYVdnVnhhemFj?=
 =?utf-8?B?RVp0V3hUQlpReDg5NUhzejBJVXZGbXArZWRwdWRJOGNrN3J0TUhjOEFiMjJI?=
 =?utf-8?B?aDUwamc5THg3M0NRRlZrV1lWZVZJcHdWL2NScWpEK0w3ejNZb2h4UXBxTkZ4?=
 =?utf-8?B?Qnk3OFJONDd2emljeHQ5a09vUVBDT2syeTRoRERKaXJwM3ZOblRxbStzd3dh?=
 =?utf-8?B?MjBheGdPZGJiSStpMGV3Z0VsUTlXWHBRSkRDdDB4UGdOdU5kUmJBdGsrTEtw?=
 =?utf-8?B?dklvYmlyaWNCOEMwZTltSzdxU1FXWEdDcVRNNnJlczRCV3k2RTZJKzNhaWd1?=
 =?utf-8?B?UW5JVzZLSVpBV2cxTXJPcUFpc3R6am52YmNoZXZsdkFDaGRIK3pnL28xbGpC?=
 =?utf-8?B?RXpoVmc5LzgvcloxaVBIbWxvZlY1SHFPYWE3czZtWHRSM1hxRlZwQ296MG45?=
 =?utf-8?B?TUVtTmRMNlNUZ1VybmtqWitFazRQZ05WU3hnTEpudDNTOUxjVS9BRllvOGlV?=
 =?utf-8?B?RTkvRHd5SmJGNlV5eEJaM1p6cE9mRGxqTXhNeGF0eFBiTzd6NmJkQk5EaGE1?=
 =?utf-8?B?bDhmVHNCU0lYUHFFUWVtTm81UVEycDJjNmtyOGpQZTYvay9pdC9VdnB2dDJ2?=
 =?utf-8?B?TzRSY2pzQTlyeVRlZ0x1UUtUM3cxVXIrN1RTUm4rNG9NM2hCK0IyVXMrNnVE?=
 =?utf-8?B?Smx0NmZBNHc1NytmWk4xalJnL2JZaTRLaHUyNGJWUnMxM3h2c05pdmRWaFA4?=
 =?utf-8?B?dzhvaWxsZWFFcnBLbW8rWFE2dW9QdnBxUGlkTW12cFozMFpyMk5JSzVZcmhX?=
 =?utf-8?B?RjAxTUhJanJCMjhBakswYjc0VFo1ZVZqbWg2VjhsTkZML2lyN25sd2hqMHkr?=
 =?utf-8?B?bExVc1lRZmxVckUxMXpnUWlXM1JvMXQ3RzVWSmhpbzduWHJ2SVVTek8xRGhI?=
 =?utf-8?B?ZS9WOXk0Nlo5d1FCOElRclZraWRxTEJoMUY1WWUwUm44WldkK1lORlVQMlQ4?=
 =?utf-8?B?MzBMQ2g0cUZuNXE4ZVZwUnl5YWtVeUFFWnBmK1RPVEF0RnoxS0NZbzJyV2Rw?=
 =?utf-8?B?b2xTSUNsdEl2RTFNZmh5VVhPSUJNbkVpd05rQjE3RDZwY1hRUTNLZGdQZTg3?=
 =?utf-8?B?eXVJTEJ3NVNwUTF4Zk8rTWkzeWs2QWRSdy8vZmVIQ3ZPRXZUL0FPeXJCeWd6?=
 =?utf-8?B?UndJTGlFNWdHcUoyTC9rRmp4NTRhbGVkVGJsa0ZZSitiN1ZhMHpidGZqRTl3?=
 =?utf-8?B?cHdrMkdSZ2dZNG51QVptRk5PdjNVWnNlNXVTbEhSVHRIWmlESkVydVYvejJV?=
 =?utf-8?B?VzFyd1c1TUp1WGVIMmVmWithWGF6M0x2bFhwSm5wU08yWjNBYTRyZHVUMHd5?=
 =?utf-8?B?Y21zM3E0KzRUdzR0cDJpUFgrOVd5ajlxVUFBcGxha3dHL21OMnVvTWxtMTBC?=
 =?utf-8?B?ejNQSGt2THUxL0R2cFZPRjNyalNRemF6djJQMWp6NTg3K2FrOHhnbTlvUlRZ?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ow06rux8qK8JkEb0OsWRHEuM3F8HPkF5HD2pJf454JwsIC6IxBlBuSvYbw7WkyAHH9fp21eFRbDD4LKMdUH7RqWuJghmBfbX5QAx3hJ0jeimdW7wXoU7rR5eedS65IlQHfjNWD3IN+qppZDHR+WKYyVQcRHQORZdMc7BdBJIR8YsJQgXioBeJehmBYcol8KFLreRQBsaLd/IqMZLbGbHuqKCHD7u1sjWO1AsJZequfU/XtweW7Z6qVzKtvzhia5Mp1Wm6fOve9KHIU6gXAupU1Vsv1cysj6CSXMcNEEoi704A76sgf21b+yMfpSAqhVkogvGA+23qzPfpimqEh1BsrRj76G+QO0BO2ASqDmi2ZNwVl/XHOyZrbPSHabm0BfuJedm4bxNPldhgDfaOrGq2ty5lHK+cgc2MjYRpXyoxpyo9auECJIMdU16n2ap0VXx8etImjP4tYpjB6eBpy3aIMwRbt0uAmxLSOESuzfS4MOf4szc3wSbsEWxowDdJRKsmbUqoHjemJIF8uWOpfZlembjyLJrDIdnlTqVl0Fba1YhX2fWOtm+WJ52tUuAhRvvdUGIx11odoG8+unzRY3bgTT4mQXJpSMk9UTGHOuCx1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357f3753-c4f3-472d-2d03-08de1ae98660
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 14:59:01.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kl7ayJ67e3MAU3aGCf9GdDHbHkYCJT3DrZD9LGycwOfWMa9I3KpXgUjx1smAHgIArMNoizavuq655Deb7CckJK/Z89kq60vkM7EeTGFYnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_02,2025-11-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030135
X-Proofpoint-GUID: zc9x7THtp1V0ozpAtSnTmgI3ZdX2w__1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDEzMSBTYWx0ZWRfXwwh5RI8n/kqR
 I+y5uECp7YQmAKilkQETMhKDvXD9/YZsMiZsA1rGU0pwPNjgNpW9F+bKearmCM32gJD0T7p29CH
 pabFx2FmI0grDUeC3h29/qb1lQL/ymE3292TprDJakQ8yrgwNyyw72A0Tr5oSbfB3Nm+YcNDx9A
 aT2GuNGy4TrXjy4O1nkAf5wF2nimdwYprU31/D/1i76NPGfGBxeKiMonM0XDQlc3nFDab2KisbU
 PJKYj3dAXXlWdF6DySwj2DN35zZ0OCpeP2mLXqf5Oi2PgGXHytsUPiGZMVVqiMuW5000Xqss9jL
 kqBkqJI5FNMxIr7ZHoKZlDpC4oPQKbY/Ieo5Pq2PN+GCF/oG2nMa6JcBGHJjsUlGKTTkh+W0oUf
 2MjGRctCKfQHpvA+0PMsdjKZRyYO2w==
X-Authority-Analysis: v=2.4 cv=AYy83nXG c=1 sm=1 tr=0 ts=6908c339 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=BK7BuHJ0NDPgJX-H4YsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: zc9x7THtp1V0ozpAtSnTmgI3ZdX2w__1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47FED180004
X-Stat-Signature: amb4k5mzhgzyq4j7xn7kcztap1j5nau7
X-Rspam-User: 
X-HE-Tag: 1762181953-844253
X-HE-Meta: U2FsdGVkX19rjAcCQGbK7k91ZB69n/1d1zLcmDvpf1zj9JFZItvxeQCmhZglZEpHQJqSVpAEKvjUoUSaISgZPW9d1hH1TCyfO73wDDPQHOT8knNxNWU5lgs8k2EPu2WlW7VMrxbEhxdCprH8MEllEh+zV1wuOfKmu/SZyx9gnqQNvU8MJ1INQGNGCcWR4W0NGrFQhom0sKSxz7f7geni/HYxujnWwjM5xRJCev5CAVbkuZKdjt7v86ZB6RmnhEwnuUcydPRn5iUJE2aoQq/W0UMSGEHPWZx+L+ufYaul/LTCvJZW7nA31Qu3TUj3Vf6YpF6ayYIndAdNyWSZ4vFcw9Mcc/BfEWCjzh8GOV5otGHb50YeMhq+fLcTqWhthQrwbycs48SRxrwIqYk/kmtHnwo6Ze/KUTpRI4LSSbK8osLDxa3EO8b2nJntwkPn4MnQZmQ85p87Nrmygjzx6pkNwRUZ1CYnU54IiYcyOk1oMN5VZ9WKwuLrHQrKqe1OvIDqmfS+088R3RyhHJ1nXmZ2bAt+Mx77PtGLQjEKQdrkTfHbXJhEZhEzuJEUcApl18TcdCky+6w86NI1ChZrCedCA5F9tZsrE2/Xobj32h6rn5P75vS3OyCOHv6flcEl7QpsGJFe8dCRwyp+Bjnft3NwbwnbWV7o1QskOwbai51rMoro8J0tWRS8sJOr/Qw7O6+oJRt/bw7Aklbpv4fdZraIKogvY79+Gs1Rq7HsCBxh9sMD07kjVGaODQ8FpkWXIP3XIY2e5CpnqusNrgM23m36vB1POPnWIjovQKzk8p983hgHn46CW4+fNNYb4+TY4YfdD0IPDbDkUQq0dtWbwhaxNzKqN5WNYVd8hxJdtJaVxPIk60PPf3htXZ36DIBgNX6nMGSo4UR12MGU/NPfVO++g7YDpfmX29fs0LtJ5zp0/LelXmjjeR5r4OBCjw5G/FX2WE0M94NVE904UCoarqD
 Rv5/nlqS
 LfGPSLuMLh8v7eKmkZQOqsSAB/06Mc2pKrNzvrPFJZoneipn1c5JU2SPjsT/vDSQrQ2ElzZ4MwlzePfMYoSkSPqpePpGFrHycMCjCPwVyyUx6efIb+stikYvqQrs+wmwh132RA0FsYG16JbfbJkOnwf3QFymyL6hl6sRPicxeo0Of1wowMpt+rEOQ7cDbvRpGZ+LtuhOfMZcL4PvoFvDNogmEQOI51Ct1XftZF9/DXBV9bpgGncWGIqd49L6yS9/00eC2FeJ1IPa3jTHVZdAgr5fPOueGhCITHWvZMWglHYuT4J5RziY5oHaQ+0OvRypZfn0+KMhRqGT2WkS3fWfsWjIf54xMNaY4zQ0rCH/a877mJWEDDqhIcVEAHy62ryfhMFlXXer3qQT78yhsdUn6rdgpACymrpIrpJYCLzUatV09P+sE7nNOo7o0nBdB9tZARy5rWqC2Q9oXOI/5wdw/dYCDUShR299AWuvI8GFxaKz++XRWKERdhLAWj7Pi88sZsX4Y5H//FnBIgy7FjpOLsTbnv0HIrBaC21oc5O5SwgvVqEn+1QdGVSWuaZnZ74HZKHskl7Ne5V+ZGTt2p4jIriCZkmUbT9kQKLus5IpKPiKUilu7nZBXsZAt30aq3gHq3p97/z17Hp5rzdAxDJp2aHp7FNLYy/ISzxn5OzZrzz1DKgqhWi1V66wRvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 10:45:21PM -0700, Lokesh Gidra wrote:
> On Thu, Sep 18, 2025 at 4:57 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Sep 17, 2025 at 10:51:34PM -0700, Lokesh Gidra wrote:
> > > Guarantee that rmap_walk() is called on locked folios so that threads
> > > changing folio->mapping and folio->index for non-KSM anon folios can
> > > serialize on fine-grained folio lock rather than anon_vma lock. Other
> > > folio types are already always locked before rmap_walk().
> >
> > Be good to explain why you're doing certain things, like adding the folio
> > lock to kill_procs_now().
>
> Agreed! I'll add in the next version.

Hi Lokesh,

I realise this was trivial, but it triggered me to hold off on further review on
the basis you'd send another version.

Are you actually planning to do so? As it seems set to merge without me having
completed my review.

I'll try to get to reviewing the rest of this, I just happened to have a look
and wondered why my tags weren't there...

You may as well hold off until I finish review anyway.

Thanks, Lorenzo

