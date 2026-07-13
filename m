Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D69C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D456B014C; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C961A6B014D; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA126B014F; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE3F6B014C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61796140183
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:21:00 +0000 (UTC)
X-FDA: 84984116280.18.8988486
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011069.outbound.protection.outlook.com [52.101.57.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F51F140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:20:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CYE2Fq7c;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783956057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZsjvjBcYsg6bVeeBR4fcJghfCc6IEm42mKG8K/wWaA=;
	b=ZKn+s135wFg/YL2/AeN4E5+9xqQ/TjhkVdlqOXPyEmkKRjRlQLTZU2/ADRQAzK7w+iIfHu
	xT4/l3djkvlg2sQFaOlonULLRxDmKWQH8gDBOqgthQ554HD+DXD6n81ZtzOvfoRGxqVfRc
	5QX536cog+Iae2HvrGV5GJrU1ZozXbk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CYE2Fq7c;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783956057;
	b=TGyrQOFXAqkL80Ix48mTl3C2OuFxzrTNwuNQSd5IjmzuEzliWY3EFkk7mhmTob9XjEvJ2X
	IJTev+6sK99cyL0mG6F5QS4mexRcW7evFnE2ByBXli+e3C0GTpu20WjXUfaauYJrmdDECK
	hzgQBt86Kzidwt/QNkE0urTBvh+hOgY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQFvZadSkkxz2OL8CPYQf/qN9G1cOm9p2zMxNUSmv3CviiDib4RbUbKfGYDYngh8+sLgWq0/k/stJFRVkenNppwC3FvxHh+bF6Fa+FBTIXdW894hpzeCCEKG9CPskZDpxtnAK3OCZ/60ReABE1l5DtZNO2KxHMyw+MvrviwC6x5CGqsD5VcLzgMvF+ZfeU3VLwafQdqThm3Md04GS+2J2Fk4PorJ4tfODbM0PYYrmFKj8FFcZ/UTxCWqSA1avCRoy2BwxCeKFRtrI4FH00U3iN/V2IN7Y0V/BtlgDuasgOfF+t954JS4NNzzAVHQqpbCaovz2dFpwKHm9JVZwXZx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZsjvjBcYsg6bVeeBR4fcJghfCc6IEm42mKG8K/wWaA=;
 b=Te2tGTw77pwd0wThuEvFV7MHfnp4RhrUzKEoyOxxBPe6PNoh+SN1rP2zgmGqtDD3pQWW0GNC6ba4gAGjrKFL0c8Fg9DuTZGKNbJXKm8gpBepojRlSSLK+gmisGsq1stxTBTswLMvwHNaswKvAYPgpA71ZOK8Ecr09PXLiEy+DQ57cd8KOKD3Hl/50uXs6TrQourq2+zcx1SP4AhP34jMGGh9Hz54TQZlYccxn6Rj2BuOYCM1wcZQJ4nSMbmd5YAr9WhRtmrfJhV6NOVItm/QwFvNgUEs4ttcZae8cou+Zv7yggodIbT85Z+QwtvESpOdZkPmSvtF6ewrq1JbFThLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZsjvjBcYsg6bVeeBR4fcJghfCc6IEm42mKG8K/wWaA=;
 b=CYE2Fq7cuCtQNor/k7p82Of5nDz2z47uOqVdWVvv+3pGHLAe+tpGySAlaxba1NsGcfl4H/cjreSP4k750J//P0qlHE+Y9Padfs5PuIpzcSsUVBgIc74qzrz0QCbCm4o0atkk6b78OFnW0XBtxbjjoNNdI/+Sq+NF6WgeESbMAHaPqCgNIfdsvRGvVvfDKHx/K0cdh83pXlpPhSfln7hZoeq/LqEijOJA064JaUjDeynm2QecOqGMyUZX8E6VPnSg/AMBiyrbpwtFYGF8ZAxroFVBbhpHvXwVMx6LVFv6SLQENekBkZ+eb1/byAeqn0N28lPwDmFlEhXh8alWcX897g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 15:20:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 15:20:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Date: Mon, 13 Jul 2026 11:20:50 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
In-Reply-To: <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
References:
 <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
 <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
 <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
 <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR01CA0064.prod.exchangelabs.com (2603:10b6:208:23f::33)
 To IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4415:EE_
X-MS-Office365-Filtering-Correlation-Id: 0621135d-2773-4a96-4b1d-08dee0f253d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d2ZMIGa1Lw4QzQHNiF8rzwt+2KSDkJeJyOyKGMyQ325dH/2jGOxOt5HNwV9t+bD5M3KVGjKY+roylIQA4SoIQ9vh2eWYj9MMIE90CMNb/F5xodcqVtYDjqCKkIqXuJspSl33AEPNU5igoaHdu2LONFcUzcrChyNOyFq1cJ2X2dkSoC0tAkqtfXBe4yQn0+DnOsupzE7/AXMAoUm/JCxEbTc4byBLp6c/zOaSu+J6Y6fJfwnxQJqN9N73+SJMdjSKrwywT5DS2ke3FNFogHxMVgqv3QCEYAwRKxT2KMys8+pMcgs8RlSboy5RIUbBlybzuPNvnB4RB44ZewpPLRAFKcMfAYx8JRcDpKjdDeXnteIYohtkZOUkBvsFr5bDVGRMsX58CfNcJp0D2TZAsZruhCLMVuM76XzDb6Hr/WxYsvD5Gw7I+5+xlccQTb2d2R/hBuanSpvZ6T7HhUDRA1tRKLLi5yVhPmYdsnZrajHOV73AlcLt0+X18mWmhYaJFZ4QHeN+eiU4kUXK3CyZIO1Yq4HuKxAZ7WsVFUo7VUOOcUtNHwTIpf1OhsdMDcI3E6XJyAJVIafgoUIpiK+7AfduRN9WFDCY1cjtj8nEICQdo300DLUAtNR8ytRMiHtF2Hk5yIz8csD/KGg0ohv1TkRiTGI6EP6QyIQS8P5xdAFcos8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVhPN0IyMzVtRzVGemVIN0lCS1c2d0NWQ3JNMDFJbmFYZW5GVTlkV3JaNGN2?=
 =?utf-8?B?RUxyMUNaanBLcDNWSmUxcGp6dzJBSFV1OTdWcUp0bjBvMHkySlEzbXVSeGlJ?=
 =?utf-8?B?dEFGWXdiZkZ2a3VCWnlJdFVVK2FvaWRwS0pQK1hLeno2dGV6RDJSSlIzRk5P?=
 =?utf-8?B?bGVGbFJQQWJMcWpMQk01dEVhZ3I4OWVad1dZa2pGcTQzeG5mZ0JjWGVROHps?=
 =?utf-8?B?TE1BYSt1REllN2FPNkZ1YWdqbXdxV2xzNDJ4OXUyWjFwdXFVakwzUFI3VUN6?=
 =?utf-8?B?MExyQU5FZ3dackt5bDF4cGlHczVvbmJld1R4NzVRbjhHWnpjYmNxamRwWWdP?=
 =?utf-8?B?dnY1Y2R3L1BhWDJIdjFGODQ5UWJ5dFBhdFBTVTNWTzR3TE1zMDNiWi8yUWY5?=
 =?utf-8?B?Wmc1eStHZ29FZFNVc2VDMEVmMThXTHA4NFJXK2xWVVNqSXNVRjd1OE9OZy9N?=
 =?utf-8?B?enB6ME91V1NleEV1cVcraWJsMDVjQUd5b3V3OUlWcmlZemUyM1VSOHU4TWJq?=
 =?utf-8?B?bEpZYWVuYU5yVHdhYlR3NkljOFpKMi8xdkxmZE9BMHgyZCtjT1RnZFlQeXpw?=
 =?utf-8?B?VTNRMDdGb3prbmhxRDlGdzFIMW5XZTdUOXIvSjczUFRKdzM1L1I4QWhXM0cz?=
 =?utf-8?B?TlFKMTVNUGRwc3VBTGdyT2cxejYxQm9FNDRaM1R3WldERWZjN3Y5UXZ0MExB?=
 =?utf-8?B?K3h3bUdOcTlmNEkvWkloWmtYeFA3YjRoUjh1a0FXcG1jNHdaTkxXcjcxME52?=
 =?utf-8?B?MFh5eVVZNVY5NEIwb25iTHRHZVhtcEhTeGxSSGZmemRMazdoVGE3VWZDY2FW?=
 =?utf-8?B?UG4vVm9HM05QYXhsK0lPUXQ5MlJBakRwYXVkK29ENS9CMlZRL1F3SnhoUXI4?=
 =?utf-8?B?aGl0UnVxUC9NR2lGWmR0a3RNQlVWZEdZVDlXM0pXVFFnMWpUSnJGWXpQdnFo?=
 =?utf-8?B?SjF1T2thY3FYWkVmN0ppZlMzblNZUDJEYUh0ZlhkWjl6a1A3QTRjKy85VjlI?=
 =?utf-8?B?MVdsOXNkR3RUMVlOeThpc21rTnhETFZZNlY0OFBPRTFlR2o0NCs1TWZmc0dS?=
 =?utf-8?B?a1M0M2h2N0xNbXNrYXR5SlNiQVIzclovY3FSYU4vTE83M1gvSEhvWkh1bWdo?=
 =?utf-8?B?YUQ4TC96NEs1b1lKOGJMbFJRazhsVUt5Z2ZxOUtHM3ZjdytVRWE0a2RHWlpG?=
 =?utf-8?B?Qy82VVFqSGVHQkhIdWdWcTFKTmRsQkVmMStWemZKNVBhYWF1VXo1NzdTVzEx?=
 =?utf-8?B?Y0REb3hHMkx4OXNzRHNvQmN0clh3UnN4QlNFK2FuMVFNZXdKRUJyelRnYmdX?=
 =?utf-8?B?UVhqdC9mNHJtWlBCQmRuaW1aYWUra2hkUUhFY2xpekswN1YwMUxjYjNiVzZC?=
 =?utf-8?B?b2FvcVY4aTRnQTBsRVJBT211Y1l5bUVSS2QzdkNsNW9MWnhvd1hHNm5uY0d6?=
 =?utf-8?B?bi9GWTlMQXE5cTVNMEdpUWVlU1BlVVV2eDZOTzk0VmY0dGg2dmQ5MnllQXFN?=
 =?utf-8?B?djBhSU94Vnd2Y3B6cVYwNXRHWFc0QkFtbERTdmVobnlRRVNHb3hYTVhpR1Rx?=
 =?utf-8?B?bzV1dVJ1Z2RKc3pCbmlSNFBYZHdaMXFBR2Y1WmZLc2NpNGExWDlzSnY3SWFZ?=
 =?utf-8?B?VHNZSmlQYXNMVFc0WnRGRldXVEMrMEhVMXlmTFBVNUw0VWRkOFY2TUgrM05F?=
 =?utf-8?B?TmR5K2RZejIvM2tqZGtSVVFYZFMrL0hPSTNQS0pzbTJwejE3YmtMWnRObFhs?=
 =?utf-8?B?NzJvT1NHdk5vMDd1cHVrOGhnS1JFZHhvOGFkbWgwMEd1ZTdhOGlwUnpZa3hH?=
 =?utf-8?B?Qno2eWlOM1diYysyNENjMjgrMWdjSkljaTNqZXBnemh2K05SUFBScXdJdlpq?=
 =?utf-8?B?M0hYdmFUT1ZqZmxsL09tRU4rOXhtWUJDdzk2NEhLQmtOZEFwTXdWcitPek1y?=
 =?utf-8?B?NTFTMWx0VHRucXRVTWtPWnRwZFVPWUx1WHpLMi81QlBYSFErR3FlUlBlTDNi?=
 =?utf-8?B?aFBMUEp0d2Nhc0dJQjZPcGtEQ2dKUHFEbklPQ0VwNHdHRXZYOU5SUHZOMTBI?=
 =?utf-8?B?WGY3UDdqMWtOOGhOVU1LWXYyeTJJZWJXL0p5THVsMms4djlDb0hmeWErZmFr?=
 =?utf-8?B?TTNpWWZsTmtmT1E2K2p0ZUswRGI3NU9YY3hSL0VzR3ZiZ2FPcHBBc29xNmto?=
 =?utf-8?B?bWl4cEd6S2sxWmc4RUw4d3drWFJzME1PNTIvaS80dDc3Y0U1bWtJczFENS9a?=
 =?utf-8?B?ajNpeTdYVVB2ak8wUStxdEp1a0xMU0JnakpBR0RtQ0xPL0YrYjVQNWRubmIw?=
 =?utf-8?Q?0pxuYWgZZXvVNqfDuC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0621135d-2773-4a96-4b1d-08dee0f253d7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 15:20:52.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVoaya8x4MbPzrZIwjU/VD1IU8jAvsZpnkonO8/6KyhOeU5e8lqejEyWud7+o87v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
X-Stat-Signature: 4eq8jg5iix5ngh5uncsj188ta5ht88uc
X-Rspamd-Queue-Id: 6F51F140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783956057-533507
X-HE-Meta: U2FsdGVkX1+9Zo+glm7zPX7+XpE+aTADmWrcKPb5dqZUHI12SkmWG7UNm8yIYyEE0Rm+Hyo0bwEibLCK9phIvB1D0xxFkwTG97QBbvbFU1pNvAUF7eVkD/RUqIrpdp2BTZ9CGkDSGlGDvFEIKrpLYLIOoUAO8TCOPDFVRstgLNZCfLsvIoaF7OOqkovNKNCnwFvHAAw5wdcyTehFKC7L8Pmn7VnjyVuP1v2po1DYPVb1IceDexpe0VX6acbwFNVmNgeVjYk/eldoDnNFJBM9Qm6BT/0PqNPkGJNA35rHRw3DXk0rJ/gwrgWCavu/Igb4kmP91b14rzFG0K/dO8q+7kKoYq32eni5otzCWJQK7lD10HOIBjr0z+0Br2mUU21bNtXiMWHrfrMgzmbrj92rsrYb2HrRe4hCAKop92q/oxL6W23ZkSMPsySswH5KEK7+rHYjSjxSK4FudprsiLd5LU+i6/5lau7cDHEzUIzAGcwQ4UHq8SUiZvp7gH0VBY5aJBhB9XNSJDlCfsOXpFo6n1mqX2bPzk7uRn3k8HVW5N8yN542ww+qjX2j9cJ6FHV8XgpCmX+Y5XbuTH+LUdMEt10QvOallOYLRxAJN6JZf9EAfpvAHkafrRblllkDpsC9zh9CnaEp1319YJxIhTpL2upUq3fZYELl/eMlRsWg3QZNTCBeAS6+C6srcRn50ecdKZ0jgScG0CSGA37XqblgdqlcSqiDYVja/JMaGf0UEtxs5RYIex7oCYmmN8U/Nyeb3keIgftXulYt85zfpZzDCka6oYHYjiBNQjnR25I9IP11O2i0zaHAC8zb761CkPQtj/42Ohpn/X34kb2YQ0H0Qq3ujBySh72wAESuMtH0mCe2+SIGHUoZg4K7hS7OO73qE9yYlynpp0n4GEjW331ZWa9Zw+5BBOR8oOFHL+Rg6SZsgTZ5QbHSHrbEB3GKsFDQ+7her0tVgPdrvfK3M4Q
 kJvorcDv
 0ddGzuVCjVm05CLU5aVlJfi+FPNNGC6BJQFWZU/3iiQrBskZ6l//JSAAArhbUtF8dwhcWlKg8//wF8qkx9gbVFNNxsLEIYEaVumo4BllZ0IWpCjvqb8Uzz0068jcv+UMhBmhSlEy5cxCK0v7K5FyQuqntRbDmpKQ7w8iauP1DMlzYFnZjTDrQmbx9ZFUh7cUaK0cHTAOur9y6zGRMS/G3V5YZ3NbMVrzr0yoiNXE/uCf0qKHs0MyIFADSLK4cgtLBCRkz37X5suwmzixVkgVndRBln0pwVRfJ8QHI8GIzMbNUS/Xlp1cr0TAOTk16/51cJF/ZhXjrO4xNnLL2M4LjNTpgNC+PkjPxOF22iWoPcofGoPDSTPxVSFbdce3g6a3qmQ7FOBxiapJ1J2oAqPb+53tA22a+V6XpO8CumzKjoj7noV7GtchKcwV1Sx9arqw673n1w5hn4i4rZr8clBsUKG6fT5ESQw8gXMs2k+jHoQna8l3lhfzVbkqm1QLp6nl9OwgGDTdx991dgRRiCnDf2lyc+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jul 2026, at 8:57, David Hildenbrand (Arm) wrote:

> On 7/10/26 17:35, Zi Yan wrote:
>> On Fri Jul 10, 2026 at 7:56 AM EDT, David Hildenbrand (Arm) wrote:
>>> On 7/10/26 13:30, Zi Yan wrote:
>>>>
>>>> Hi David,
>>>>
>>>
>>> Hi,
>>>
>>>> Do you think this patch is good to get in? I would like to get ack from
>>>> you.
>>>
>>> I dislike that we fail collecting even though there is something (different)
>>> mapped now.
>>
>> Not all the time. After a folio split and PTE lock is dropped, there are
>> different cases:
>>
>> 1. no page table change, the collection grabs the PTE lock and continues;
>
> Yes.
>
>>
>> 2. some PTE(s) is changed, the same as 1 and the collection continues;
>
> Yes.
>
>>
>> 3. the PMD pointing to the PTE page table is changed to either a leaf
>>    PMD or an invalid PMD, the collection cannot grab the PTE lock to
>>    work on the remaming PTEs, since they are gone. For the collected
>>    PFNs (they are mapped more than once) and folios with elevated
>>    refcount (they are mapped once and unmapped here as an optimization),
>>    they will be processed later in migrate_vma_unmap(). Since
>>    migrate_vma_collect() is best effort, there is no need to revert and
>>    try to recollect from the beginning (to get that possible large
>>    folio or skip).
>
> Yes.
>
>>
>> BTW, recollection will be more feasible if migrate_vma_collect() does
>> not do unmap singly-mapped optimization, since in the case, no PTE is
>> changed, we just need to reset migrate->->cpages and migrate->npages and
>> restart from the beginning.
>>
>>>
>>> In case we stumble over a PMD, there sure are no migration entries on the PTE
>>> level anymore?
>>
>> Right. The PTE page table should be gone and the original PMD, pointing
>> to the PTE page table, becomes a leaf PMD or an invalid PMD, since
>> someone changed it when the PTE lock is dropped.
>
> Right, so I guess we'd have to remember how far to rollback, and rollback would
> mean resetting migrate->->cpages and migrate->npages.

For case 1 and 2, we do not roll back. For case 3, since the PMD is changed,
we just roll back to the start address and set migrate->cpages and migrate->npages
both to 0.

>
> And for the entries we rollback, we have to decide whether to folio_put() and
> whether to folio_unlock() [fault_folio != folio]. That's the confusing bit given
> that the code is rather "interesting".

IMHO, it might be much cleaner to remove the “unmap the mapping if the folio is
only mapped once” optimization, so there is no need to roll back at all.
migrate_vma_collect() is best effort, so there is no hard requirement about
a folio has to be collected. But I am happy to be proven wrong if Balbir,
Alistair, and Matthew give any counterexample.


Best Regards,
Yan, Zi

