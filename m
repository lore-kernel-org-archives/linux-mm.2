Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D138CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2508E0099; Fri, 24 Oct 2025 10:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773188E0042; Fri, 24 Oct 2025 10:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613C18E0099; Fri, 24 Oct 2025 10:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 499228E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:02:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5DCD1A0EDB
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:02:58 +0000 (UTC)
X-FDA: 84033174036.03.CED1123
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 47BC5180013
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:02:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LhQ6qEP6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SEX+wCmg;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761314575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dxtGacJ/6I+FjWgq4PAGW8Ut+6wtTOMTyrGyKTCi/Q=;
	b=Ik5X07oyUxftiKhwEKQsopILhlEY+7DCvoOzXiDwoJWG7XPsQT4C1URn2xdVF01TYj7o70
	UOwxJZ8HbmEx7rgRxmBFsjl9rdysDgTWxEKCVTgiCRITcvNgIoY04eBUPLpjsLk2GU8MaV
	JipZ/G+AuGVWkES4v4Qf3dXEMwnzbmI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LhQ6qEP6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SEX+wCmg;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761314575; a=rsa-sha256;
	cv=pass;
	b=eCa+mK0NoxUEN1/ZoC2oqsrqzFvlxkt5IdLVRLplVoDDjFJ4tJt6f4UjS/+HixbLHYmFca
	bZ2YDQ3j59/j2kSfzVoXeVjgjGza9s4/g0egy2Yd2/DwRaeljNnjHNRRaGCFbs1rLfSFFg
	Hyl0jxFzlwQXvRltNXcv1jNK9vje1iw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NQto021633;
	Fri, 24 Oct 2025 14:02:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1dxtGacJ/6I+FjWgq4
	PAGW8Ut+6wtTOMTyrGyKTCi/Q=; b=LhQ6qEP6xUTr26pYyJQ9qG83x4gvjNUrtN
	GwnD7bu6+XkWE01hw76ac9DKD4mX17GpGrs449rGk1pw54ENiTswRtSh88p7POz0
	I2Wr7WIOYekm8XPGO9gqG05Z3cEUEN5PQdf5IoFvUiYUHwLpVtMQIFoKLwh/3/mB
	tawtNn+BR8POhMMJeqWiW7QkZdP4LAU40+8Pz3hjnBDQ5Myzv+oOE8plP47DSrWV
	eViJek4rFBag8Z8X7blJ8zuoEZBiwqAAXQh7MXuBXIZij/DpGSB4GeQCV5PDLA16
	q9xlPLCsXBvJ2PcmPi3aHKTJZ+kEskQfpieWrT1GZgJ9GJxVEVdA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3k4v0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:02:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OC5qWo030450;
	Fri, 24 Oct 2025 14:02:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bh01dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:02:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HScPmFt+w6NV+53gXseTnKsjBE/7z1/R3qBqdQDDTS+jIgWTmPcfvQCllbl0OCuDURNbAd7uGETCtFNJcsmPXFnj/+b3ViTUcwfvM8d5Yoqjt6ZfYDFVJAjCAHSsHb1VVJo/waummk2TYNerqe27OSko04kxYo2hAEL/vxhEm5T/Evqt1mi3x0Oc2/H2rvdy8wKO9N1jIbZgMZR7dBQtgmF2gDpYUb44BWEtSLy0IHyOC2AkEOyNDuto2zz8JhbRu9AkjY4PsCMMEbWSeticx6lGrRuDamHD4JquVuK4KNhqozXxV2bE6zpvPfQAKaK2oX7pRw1oyCMCfS05AJj7qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dxtGacJ/6I+FjWgq4PAGW8Ut+6wtTOMTyrGyKTCi/Q=;
 b=hKyw/a2DsVsER/lJhJBSoDhr2x9JgbNA+HSl8+DnUz5qmx7obh3jhGg/TT21XkG103eRkcniyxxsDUQBDp+3GNu4ODT2QTkmVkj4Iyju5X5oy2Y93i89SkyAd96QKh+4JKDbDeNUfWm4f6i++CTLxuMPnrmsHLu0hWEwZFADQiZepXiCnp8ekqnuYBdc/ZBHe99hdOthNAxGdPejjBh0dS150L7pgUXMQe0hIY9hjEKzlNo/gS4pv2OmZSQvgT66UvAJvOAwQbkubsCjcCNCHMPh7zIBwsCV7j3+3U5LplX7IJ5E7JUbdgydEOWrG11POlfFBT21JC3IyzDOkjDmKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dxtGacJ/6I+FjWgq4PAGW8Ut+6wtTOMTyrGyKTCi/Q=;
 b=SEX+wCmgFcvM/QDJ4PnoimSh9o6e5fxt2hmZeZRNYt9thgbWEbXHPjaEthCJFtDkzI2Vbgo0+EalpuN0IpiztahaiRAgnlxhdphSi8rddLS3PzvkxmMQe1Ddj6DbFiaW5OqPPvkI3uYI3aIk1PZjZztM7nKQnVfaDGJrPOP4uPs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5642.namprd10.prod.outlook.com (2603:10b6:510:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 14:02:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 14:02:39 +0000
Date: Fri, 24 Oct 2025 15:02:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>, Dev Jain <dev.jain@arm.com>,
        David Hildenbrand <david@redhat.com>, Barry Song <baohua@kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        Mariano Pache <npache@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
Message-ID: <88d5ad81-04b0-4f2e-8099-807f1d32e54e@lucifer.local>
References: <20251023065913.36925-1-ryncsn@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023065913.36925-1-ryncsn@gmail.com>
X-ClientProxiedBy: LO2P265CA0097.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: 947cb0bd-eb9a-4b1b-987b-08de1305fdef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8LgTHMJlkFVU3LH/y8G0aeKTrJN8tik4fnUC8S7LmyFTQEJYRVDEfNQZXpMh?=
 =?us-ascii?Q?TlsOihXOOlSoodklovdMcLOWiwYngt4Ps9lYRzWiBrxMuEYTPwO70oz0kvaC?=
 =?us-ascii?Q?rQgbM87xGkZm7Y04KoULevZMPK+7hiW6ABgEvvZhtp3ykbmAcdO7f+z6+Mip?=
 =?us-ascii?Q?HrSTQoYKnTWFKAtb4DyvroP768ZLq66bTu+62YnUFGrmbhDvsGHS1pbjyV6B?=
 =?us-ascii?Q?xK4b8ceEipJ51785X0OeVbwpBC0OPM7jGXpqDOQErodSSE6udP//S5IkHhCW?=
 =?us-ascii?Q?dZLyRu8PV1O3u4Gh5NwbB0JgDcptc7KqCbH/KYF1kgV4s9QLHM3WyZDLBeeA?=
 =?us-ascii?Q?4KsBdCTIF4LyzCEO9vukxw3rYiq0XaaYNvafS5WwcikDeQPjYENJlsPpnq3W?=
 =?us-ascii?Q?0L0M3MEBCaYlNBMHXNlyFRqKcyKByiMGMhB5Y4TAOo02uhNLIccpUY26m6ln?=
 =?us-ascii?Q?SjMacK3/DUvi87PiVzD5DVxlXkajgOIccNks5289KEB9lH3Vla/TBOINQcRN?=
 =?us-ascii?Q?CBv4SDuqkK47wyTQvAWfmBs+QxF6ZD2LeA+STMMHJtNCKknReo16fRrsNjCK?=
 =?us-ascii?Q?CejorRVez2EGXjRNGYsZPmIaHxWk5CyXpPqEmNRl6WMqReIZCnXMj0WI4fFb?=
 =?us-ascii?Q?Q9ZCA1PFtmeK8ljspLW5Bn/+7s+X5vxAe/GfI9n4RbCngH1zsQbhBAmCM6yE?=
 =?us-ascii?Q?55l8+f2hN+dS/a1ETqaqgneQyZrnyri3CgioLtQ7m0Sd0+eDy71F5oyX1XY1?=
 =?us-ascii?Q?+77kbNpQesnx/+LXqENIzUTV78InOjKYn6NswB5BkMK0Ph1YXKjh0WCAgCmD?=
 =?us-ascii?Q?6p7i13w1Oo1dpxN2KHvaDX0hEHyaWnvElFRtn6MDhDOUFMegbusjQBNqUCZn?=
 =?us-ascii?Q?LqLr5IX8N5ERkb5m+vU1MNZ2kb+wucX59wlI/C4ioTNl6n7jR2H5ciZfs7aD?=
 =?us-ascii?Q?gN4X6eSvmwn8OzkmV1ejl/cgL6YIw9rL4E5PF5INFY3AralLNORk0x75q+qT?=
 =?us-ascii?Q?RRVRaiC5y9l9iN1oyt1fmhFtd/2nLt/ULEx77gnWL8H5TDcxdmOwqd4IfXkl?=
 =?us-ascii?Q?EgXIdOiXleWZsuqPcVuG2t7ZafCqy+Qb/ykgkswawpnMkcJtWPoEssT5z14t?=
 =?us-ascii?Q?M06oIg9VhuG+oNqTahHuSkDCa2RHtBuBT2aB2lbbgTSHriOl9+rOd9xTITpQ?=
 =?us-ascii?Q?yMQLZP7+eTeQnD7cdfMex5er3mSgf/w9fWPIyVtYrxa0HcLaH3/EfJgA+7rY?=
 =?us-ascii?Q?0QYwjMBcuM4/iykJgSBxBkxE8gjhspNyaGw7OzH4piEYsd3tR7FCFh5lH23K?=
 =?us-ascii?Q?9Au19NW6PSNS4PhMpx/WcQAJXHM9Tgb5qmoVQp2spMQv7oGUR9pxe0EaCTiK?=
 =?us-ascii?Q?Eda10O1Dp33gvGh30ps/18qHnT9T/wh1Q21s3k/+PSNUqchGpp7r86QzIz/B?=
 =?us-ascii?Q?7Do5cBoWzvCngT1FMhyk5jYqPm8VIxTfjgRk35jDfjvfYFPHJS0KxQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HFpsEzfHc6842SVcoZch3lCQBw6H2+0OQ7ov3A0QKtJKkEGJvyoPnzDZob8k?=
 =?us-ascii?Q?G8u8rJLq481Dq0idNXyGzzdVg/da8XHdTO3VfMJ2bwo3aZ3Yz0MFptNaltir?=
 =?us-ascii?Q?4Vh5On0GnMFn5hZxG/Jq/DzzijpPQTeuiMyOZNmCSbF37iubOG/Lv78Fn9jH?=
 =?us-ascii?Q?2IQy28ggz9/UpqRtUWrDHTy6yKTSao/qgf9oitRl2Y1EjfhhSuCZBrAJBFY6?=
 =?us-ascii?Q?Edyk/zSBw/Zd+Wyfji2dNTHm58QorRWeksP3TAujx3Co6E29C+tayG5n1w98?=
 =?us-ascii?Q?XsHLchy8C8av0QkdlS6IwWV7p5L0wDi35/vYnmoyuxSwJfybGpzfO1Krv+hO?=
 =?us-ascii?Q?cefE2yewM5F9AJRi36U1CG78hWRBSlD/4fK+7HoaBN+U51h235m4qBrAfFOO?=
 =?us-ascii?Q?OVY6QoDSRbdn5h5kIzylutFg3uYrcshnAktTmNHKfbmQvYF9VRAG3Km78KQg?=
 =?us-ascii?Q?Lyz/K1TnYGrf6jNW61m6INSUkXRhqkLmIgzKoxc/doWD9UfzZJyMQD7QL709?=
 =?us-ascii?Q?9YUvAnu3m0Zmtz0cDZ9I4T40hN0Eh/+BcYOMVDsvVg/mnV+uA+YH0gC+mvd+?=
 =?us-ascii?Q?D0Q3R0TKXuByESpN6zbr8qSDhaGJ0WBtVP3eFEo+iksIxxc1oCczdNL70Xcu?=
 =?us-ascii?Q?5h6lxu22Sq5pUUwkahJNCHpZYyusN/8okNKi2JdwX8okIdmEhv4IRzg3CqB2?=
 =?us-ascii?Q?9T6zQvkB1F0VbC5Zc5TMtpO8y63Gi4hKjM7NyiP73kKqdYaq24s82A++HpYq?=
 =?us-ascii?Q?Uxbpz7FMQYoiNHYmTMFePDeLL2kBZnL8ZzbEVburY9Y3GmYKOYWf++c0PPfv?=
 =?us-ascii?Q?gNF0H/MXaU0eSMUhWnEL5sfUEx2pUlGRW4NhNDRhzQXnOrFuMqHU0Ap8kcu8?=
 =?us-ascii?Q?Ubk6L4U03oAFzloadejaTGyJsIlupTPCPoPpgE088uE9acQ/Jpjf+oKRvncW?=
 =?us-ascii?Q?WTyZc1mCWhSN7dWJ6Nz7ybGsMnO27F4If8bm0DCciBHLF86zprcGeguhnKfr?=
 =?us-ascii?Q?3GiLNn0PyV0qcRlqG5Gt+1MqZI4nZlmUqG5aQvAxspLQ+CsoOoP+kTGLey7r?=
 =?us-ascii?Q?Gpu2+SGvLcI5XBS50YjMdd9YqkWGD77c3g1j4VWZ/x5fC93egTpKIf3PYcV3?=
 =?us-ascii?Q?Xb43ZBhSGVGUB/AuWG42mE1Jzg0H1xNNzdZfDBZ076H9I3eDekMAgVafnHXW?=
 =?us-ascii?Q?W+woW8UPaujxMryBd3QwcJarP3mlT2PX8RDSgsFDR8mns/ZEKThjC2xhQHgf?=
 =?us-ascii?Q?IWiSIsoEb/wJURcSqyAteibZszi8LEK0Qj9iKhp0YTWj1OA0zYkbo3yRmGKI?=
 =?us-ascii?Q?Omt/nGizjieSNm9q6kmbTe0587qyqhLyJ/hcVrd5zabTXVq1/AWCppOBZsh4?=
 =?us-ascii?Q?VtlAAYJyUrEhd9y95oEJ/q0b+6pCAtMuUucjg+lfaVuhlbKGn3yevkgMeap9?=
 =?us-ascii?Q?agmT4OLKLpTAy78k88WmSxLgZ4062G8RB7+yvSGAPo0IR5juq0ERieplru9H?=
 =?us-ascii?Q?bE8RwxZIx7WRud7zRlFJ1yBg3dPGScSZTb22JaAfrtQAszA39pQS70Xkfr4r?=
 =?us-ascii?Q?BBoGOuj8eyET2UPxiU5cdmUirCi9Dl73bQ33ss88q51kElUU20Y28m7N/WbA?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cpnyPqw9JBGDiRMmqrLRUOJihAWA2WIuableMNsaqy3FRz/NQ6js4rD4C/EP6My/yG30i7sKEfinoSx/580C/uWepG3g2pLyVYx9t642RmfxwHkO1Lqsw80nj9X8Hv1HgzBxVxYTCxajlFmloIfGtCfQc7wJZGk5i1rES3eLFPNxqLd/7puoOex0e67HhhHMDoe9BcElRNwVXun5OxpsYDT0LRDCfTTsiAg/smrX+sJekg1sFIy4gaLhgAZtjqqs//VMhHpvwU1TV/fQSnfjMoJIV/4PCOI8Bgp6KIMS7nKKkUL+xwscirTJqx6zi/ng2BhhjqJCy9kKQAeKMDywaxNc3PDfn3P0sXr6jAtA+WHKDxUcEosaw7bKGO454sU4eTxfZr79z9bm35EuoZXwdHcVTmJQf8IKerbMrykT97/UbRMmg/C3Abi87VvIrzCaCYMhuaJ977520u2afbMeIK+tYOCunktkfarmBcXsWKMeI1GtS3tZwMNkJMTSed6Sm/D4ODydrEnYCsHgyWou2P5NmM7ImVCipHd6pNtB+yl0ubRmt9lxh5wBho7lHr2hMDOMi9fb4tPBfHDtTYahwxUNgnHCEawFw98Z0Be41zI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947cb0bd-eb9a-4b1b-987b-08de1305fdef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 14:02:38.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETsq9PBgpvIUdldq1MtRIZ6Qz2SE8tw4ApzDH2qfhjZ1Dxpr1j+pa9bR+Qg/51HS6+VjFGucXsfoLvwOpNdL8RsfyAY4iPWwp4alMRuESUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240125
X-Proofpoint-GUID: V-kXp9xJ9tOM9BMwa2uTli40QQWzcsY0
X-Authority-Analysis: v=2.4 cv=bLgb4f+Z c=1 sm=1 tr=0 ts=68fb8702 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=yPCof4ZbAAAA:8
 a=xF0YQ4EhFT9RxdQdIY0A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX8iudhU/diMIV
 dDE9xn/AB/YoYTkbzEnNNyhC5IQtBmnvC1qOdeO0wgl8K7YHeeqstsnHHiyi/FfjvJrOZgDygFI
 MP1jyHcqsTzzTQUaYqbQHRO1HygOFA8zi3kBeqr+PazJwIIGv+yavBPuZrFP+cpYi5E85WMPtbm
 ZEY6HYO9aHUsZBjZVthTWSupynNbxuqyJBGJ+F7NC7J6z8D2hM9fzDUOkrUFD4nQtDGaOQZCKUF
 hY1wSLAXBjJg7HUSfPywQBAwsy81n72a6ly1A1Ap5r02mBJDSv+O1Hag434jX6A4ujHSYscmw3i
 /EERMBuR6Z/RCt+s3eBOZ3E35/kr4cdrr3y/5XluLYb908bdoiaYpI1aukkxdHTDBgpg6AisKci
 pi4BVnfemNb3GW4ISgsFszd1E4swf0IhWOqPetQcT2GYrEQQjJM=
X-Proofpoint-ORIG-GUID: V-kXp9xJ9tOM9BMwa2uTli40QQWzcsY0
X-Rspamd-Queue-Id: 47BC5180013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4yhd3xy1cwhn3uhkgh9hzrmf8ew4tacm
X-HE-Tag: 1761314575-284707
X-HE-Meta: U2FsdGVkX1+PMKlyKfWULPV/SHz8L1uumm5zTXrYohSY+CSYTDVoHL2R2r1YHOY/kxHRofVa1rsUBtPKOlmfPrJInZsjgwFbooepQwK4z4Idu2YMcKY7Pke4y12NIzCU1y41m5/CCttvteyxVb2C+11NO2czouK0STAqGM7iwahx5/Sa//HeetSjVL5P7Py3dxJXMYwDiGfUCZ+RmHBYjiZ66rkMI3cYXnigTzQNIkk38Ym0RyPT9jf1YbHZBKWhzaCvMnMkerhLbbuel3cnA9ioTTj65vSIvWJzl/vnfcrdfLbwJkWshWwqI+5lZyvTff6kEkTuKzCRFm3IgYzaRBG7soT+RsMaypvjCp1cNghWEjcsiZ7AGUFBSr9mIIFZSCuWvkLHjUipeaQveY67ExGiHrHRoW2zkYwbbhlHxrR5qMJglmGiDqpBdpajtX9mOUDg4NSp4f9dvxdOhicnx5w9eWtzwToVqm1pyBHtqVUj89LslaP/SwqjSLBOOsc2k3mWIvALhVq3MOymXYS53s+l/TUF5x7lQASuH5fBLRVXEsilY6n6pslAPsqLJkRG1tc/TsR7Ed1psLY+3N3wqNy+mSNdZnHTvYl859x0yLIuB/Dx16LRPSnkRtcJ01NtzFKvzIofk+pW6ApXP91BUlIUO/msGcfvbP6nytATxkfCF4j6mSbJR1EFynQFq+Zqg2Fxu9yVbBbNk6CkosqOcQHq4cBtw14ntjw7OBkkrHDSoSfVOWh2hf/m3rgRHJgBQW//4ymGpjinL/x0tXn2PKjzQkj6+aE8dLXvoazR2xOkMDgP/XcOtCrHs12l+DLjIN54fIpba926Bvg4OgFMGT2fjDtbMCi7TMOfoklNWdOtNJCheUi1mFCuMKnxJI9pvvy63+7hVOmxSZD8s6aoXAzne/ChHynFxPXP2+JvMst+n2bbwsR/gbAH81jpmcySLsAGrQAuAkVSzlD9a37
 BFmYs/ES
 YyUKWYq8VC5o1cWzdIbGlW4oMDBq+S92wQzjY9dpQBVUWs0GgO7eMBGaGrQQ9aB1fgtiZ2kMgDQuAyJi1KHxLPO4JaVJrqimW3znesLW6/h/FSCD//SI2cloGY1EkI+wmzlvEAy+VOdtzdbeCactApoxMwSv7us2iTW0T+lBYn74/vVZN/QXU8TPxwMF/8niICORuKClweC5Yl+Me6hxaqNCJhRE/EiVGsFnuYSS4vtjpbf67ZvheL3AzKFZ6YFZ4HhUTSz7AwOJ3fRAZDifVqU7DYvBLP0poo4g4S38X0ZIcqu3scjpyAihvAgEVq+g8ePsRtr/nUI8tp/EZMGR56ADk3plA8ig1LFNWh9si/C1QQJ1wQfdY30bN5s3CAPeOUccUK6Llyt+6eFmup280hi/FAnrfl5PtwJMBEvLRGH/o8jnoJqSk7EHK1J1xEgLgrGznWnuD5MdgJYUSGE89DnhofADPJE8yua1IUPgSXRGxNC+/wOkSZQKjN5Pi7Bpo9gQ2i5l3AkGGATyl6u+ZL0bJGLD9ZE90BdrJ3QU9bwnNohfJYtctfBnmLKRyg6B0bsMp/3qGmKdht7ZgHFWwEbtLWKRZNuJR43oot4ly4CMcD3leSDhZWxGTKQn9SGDSs57g7JQ5eAyr9/jwshH6xY6ADdm2IYkBdjFXG51+AUsmCLS622aEcCOz2PPGzO8lr72FxUxHm1Id5W6+mTLUhVhoeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 02:59:13PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The order check and fallback loop is updating the index value on every
> loop, this will cause the index to be wrongly aligned by a larger value
> while the loop shrinks the order.
>
> This may result in inserting and returning a folio of the wrong index
> and cause data corruption with some userspace workloads [1].
>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
> Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
> Signed-off-by: Kairui Song <kasong@tencent.com>

Yikes... LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

See below for a small nit.

>
> ---
>
> Changes from V2:
> - Introduce a temporary variable to improve code,
>   no behavior change, generated code is identical.
> - Link to V2: https://lore.kernel.org/linux-mm/20251022105719.18321-1-ryncsn@gmail.com/
>
> Changes from V1:
> - Remove unnecessary cleanup and simplify the commit message.
> - Link to V1: https://lore.kernel.org/linux-mm/20251021190436.81682-1-ryncsn@gmail.com/
>
> ---
>  mm/shmem.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b50ce7dbc84a..e1dc2d8e939c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>  	struct shmem_inode_info *info = SHMEM_I(inode);
>  	unsigned long suitable_orders = 0;
>  	struct folio *folio = NULL;
> +	pgoff_t aligned_index;

Nit, but can't we just declare this in the loop? That makes it even clearer
that we don't reuse the value.

>  	long pages;
>  	int error, order;
>
> @@ -1895,10 +1896,12 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>  		order = highest_order(suitable_orders);
>  		while (suitable_orders) {
>  			pages = 1UL << order;
> -			index = round_down(index, pages);
> -			folio = shmem_alloc_folio(gfp, order, info, index);
> -			if (folio)
> +			aligned_index = round_down(index, pages);
> +			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
> +			if (folio) {
> +				index = aligned_index;
>  				goto allocated;
> +			}
>
>  			if (pages == HPAGE_PMD_NR)
>  				count_vm_event(THP_FILE_FALLBACK);
> --
> 2.51.0
>

