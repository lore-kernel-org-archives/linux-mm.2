Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69AFEEB56D
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 08:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C596B0005; Thu,  1 Jan 2026 03:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9F26B0089; Thu,  1 Jan 2026 03:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EC26B008A; Thu,  1 Jan 2026 03:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26D2F6B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 03:56:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5E90C1AFB
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 08:56:27 +0000 (UTC)
X-FDA: 84282788814.04.7788ACB
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010044.outbound.protection.outlook.com [52.101.56.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id E468AC0002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 08:56:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="DkF/v15H";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf28.hostedemail.com: domain of bharata@amd.com designates 52.101.56.44 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767257785; a=rsa-sha256;
	cv=pass;
	b=EUEeZJz8VkHw0QttchP2zsSaL2YhVi+BYFGfNffonBhtJj4bOyYLU4e53ttWT9b9OiFxBu
	6OBXiLkBn45ID5syaQMywuavlDSMFjR1If9dkHlXktmUwZ00I6RcU+Vk2qlpPgHt6FPOWr
	p0Rm3hTFhpATpm24e5NGu6UvaVTePqI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="DkF/v15H";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf28.hostedemail.com: domain of bharata@amd.com designates 52.101.56.44 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767257785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqvmxHIRaDFKlpuU1tMbx7v2yzB+A6zypo2ZqWCuA6I=;
	b=gYqnAi8WYWE5l0DLS/FLlM54Wawy4GNt518K3xHK6sOLr0htlNgGPe5AZ4/KuohO0OY7pe
	1zMfXJDa4sTKlVxJQbZacmEAzW1Qq6nlkZKp69f0CFIu4qde6OA/cJu7yRYyVBukHrF3eK
	ngwOu1pgX7+C1NPBGhCtvsQlfNi1r0U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YL/B21tcBPw9PtHGZ+8XUJ75otyhwpFlnFI+5L9QvJQZ9jE9YJqdwkIaCcfPgn/r79Ywckh+ujAfTHfPE6pImxp1eHhS4OM9DpoBmdduIE9mEeHtAC9WISuz7/XMq6UmCfPSDO0W7WeoYHVBJtaBeHBYuePYUfQkGq2NS2dWPtOFo4hTKHAue9Sd2dOHbzv7jcH6ZnMgPu3kyaaSybmXOjCKg4zsNwbwWW1xI/Vx4cIUQThJ+EumfeCap4kkGMgLRSI9Ff3DdMmKaAiIQZmpRgoxvJuJQs/s76A19zHP+6nnsgzJJKp4vuquD9dyhPsomL8QilzLfCNRK48dNJ/h+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqvmxHIRaDFKlpuU1tMbx7v2yzB+A6zypo2ZqWCuA6I=;
 b=uMyHxGHSUugKIHp7p6SKfWEFVkp8+5TrShFv5lo84rJ9oraeCfmlhLWpCEflX2bQGxj4DUBpB+A6wVxlXv8N3rjGCV7I3c21yx8N/nCKBTIswIwsH1W6tm++JmJtgUuP3Jtu2JXG82x15DSs/BChrBAAzw1bkEuYHx1wqybB9VL05dFpUAXkrBY9XP1ZClzFo/bKHGWEe1+yKlxq4PVanMF0yTRh9uAArdrEAg+lD+DGgc0puPjUPH6o985QiwvXoorCpxUn7p/kjqx89L7R6JFW2q0ULKHxBxCUf1SZ9s7BuaYzsmo6zdDl2Bvj5DYx5OLb2uoQkswXI+tSvlMv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=samsung.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqvmxHIRaDFKlpuU1tMbx7v2yzB+A6zypo2ZqWCuA6I=;
 b=DkF/v15H+p3ViAmefoLPCCDX8zjATkZWF7fzUEL6S44pBD6+xs2M3cBzaN/UshNI8+VyLxe2sFHv2T7HwuuTrRn/Vox+ox9LERERbAqAB77DoEBk/TIe1Pe2UtNpfwE7fbzsj5WeLN/zDQG7yDSkbYJiZ4mic+i7kfSoyBaixUE=
Received: from CH2PR07CA0046.namprd07.prod.outlook.com (2603:10b6:610:5b::20)
 by LV3PR12MB9188.namprd12.prod.outlook.com (2603:10b6:408:19b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Thu, 1 Jan
 2026 08:56:21 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::16) by CH2PR07CA0046.outlook.office365.com
 (2603:10b6:610:5b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Thu, 1
 Jan 2026 08:56:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Thu, 1 Jan 2026 08:56:20 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 1 Jan
 2026 02:56:20 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 1 Jan
 2026 02:56:19 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 1 Jan 2026 02:56:12 -0600
Message-ID: <79251820-b553-4251-a467-bff87e2bbdfc@amd.com>
Date: Thu, 1 Jan 2026 14:26:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 8/9] mm: sched: Move hot page promotion from
 NUMAB=2 to pghot tracking
To: Alok Rathore <alok.rathore@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <shivankg@amd.com>, <alokrathore20@gmail.com>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
References: <20251206101423.5004-1-bharata@amd.com>
 <20251206101423.5004-9-bharata@amd.com>
 <CGME20251222102716epcas5p45d0893afb074ef3fa4be0c912cd0e237@epcas5p4.samsung.com>
 <1983025922.01766400002783.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <1983025922.01766400002783.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB03.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e8e3423-ba0f-43a0-9a64-08de4913a20f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wk1rKzB4eEVFMFcxMUJJSjlpYWE4b3g3STJBN2c3bER2bUkyRVRsaTg0TjVm?=
 =?utf-8?B?RHo1eStINld0R1ZnZXpwNFhuRlNud200eFp6dlFINWp3ZFlEZjh5ZWkrUTA0?=
 =?utf-8?B?VWc2dnl1Vzk2NU1aTytVeDdhekJIdTgwSTN1MlJtVzZlQWxMWTI4aGZpV1JC?=
 =?utf-8?B?RFdSaWtLVWFPTzBmSVdaTWRhQzBuNFFkWVlrZHpDa210c3pzZlJFOUUyQjVF?=
 =?utf-8?B?dC9HMXh1MThTeUt1QkdLeUJkUTFXU0o4UGRkaWc4M3FnbnlLTkU4M1hnc3Ry?=
 =?utf-8?B?ZjlEWUNNcXF4NzBORU83K2FYMGw5U3lDeUdzWGhleEVremdKR0ZFcDRvVU1U?=
 =?utf-8?B?RjlnaWR2Rzd0T1VqaVRMY1ZidWh2TGMrb2NFY05iQmVpaEFKNGg2NmdoVTBh?=
 =?utf-8?B?VU1HbHY0bk1hUWxHdXlkT2dxdzdBdzJrL0MrRGdOQU5mcE41ajdYMjg3QVlz?=
 =?utf-8?B?WVNTbFFTVXpISkVyeWtMcE84anZSR0tSUjB0Z3FkakFhbjBwQjQ5bkRGcXU5?=
 =?utf-8?B?dmxOaWQvUC8xYysrWDY1UW53RWxpcU13bStabjVEY0NYblREdENDbHQwNkdu?=
 =?utf-8?B?UW45QzF1Z2xVVjJKNzVnWmdPQ0lZaDlZOTVGMUtqMU0wUW1RV2pNNGhzTTEv?=
 =?utf-8?B?aFgvNG9ud2RCT28vQVVjYUg0amdyRmtvMzRDNGJGeWV4RnVIZnYxZTlNMk14?=
 =?utf-8?B?WHJocDJjOXp5QTZIU3Z2NVZiN0J3UG5tb1pMS09qeTUwdHRNZ1NjY1hudjFP?=
 =?utf-8?B?empjNkJRZTFXbm1UZ3FxMEp5WTBCVDE2Q1ZJWk5Jamx0bW1iNVVUMldHd2dv?=
 =?utf-8?B?bVpxVlBXN0g2RUdDd1lTTGpvRjBYOGhTV3hnWXczTUtzTmJIZXJiUng5c2sv?=
 =?utf-8?B?WHNWYXNGM3dndldBelVLZ0M1VDNhbmRBVG5pVGlKMGRGMUY1MlBwNm5uQ0JX?=
 =?utf-8?B?UmhpcjE1b1hIeEltbWtxK2VaRzBsUWhURVZXLzNXbXBOT1VMY0VERmt2YW9B?=
 =?utf-8?B?R3FPK2lYS3Z2L0NXOG1KelRaRCtsOXJRZk1tMHQ1VE50RjIvcFRkZFZvazly?=
 =?utf-8?B?dWJWYUphb1V4cll5OUdLS3EyTW96UzlMWk1KUlNhWEFYVEV2YVpOdUIydDJ5?=
 =?utf-8?B?aXZGYm9meFBNRXVzQlpDcnlRRWNKMk1XdGtmaW9iZWxjeS90ZFU2NG92NHVR?=
 =?utf-8?B?YktJZEl5Q2k0UEptRXZ3SXluVzFFK3pkcmFaMlNoYy9iT3VGV3VQbUJmd1Fh?=
 =?utf-8?B?NGdSZjBqTUJPMUpOMlAyckt1Y3RxcHpJY29CTVJZeW5zT2YyQUxHY0lpdzlq?=
 =?utf-8?B?K2dQZENnYVNMRWdVbHVVRFBuQUdUY3pnOXJiZkVVY1hDSVoxWk02bFFZd01k?=
 =?utf-8?B?OVlKaVE4bW1PMnRaSU5LcXhqTWRwakJCejF2ZG1qekIxWHVHak5nRDRjd2Ev?=
 =?utf-8?B?dTgwUlpYdGZISXNWNWRNZUEyeUZGWUlLcDVrMDEwSHdGMmt2djBFQnBSalcx?=
 =?utf-8?B?b214bEJEQzVEbFl0REh3dFI4dTlQd3VNS2F3TXl2VjB1Y0FHNUpGK1RHaHg0?=
 =?utf-8?B?NEt2ZjdrdGZtRmVCQVo4ZzBKRUhXVUh6emFIUEJRZmsvU01UazFBcFdOWDRh?=
 =?utf-8?B?V1BMTXM5SDRJeFVzRzVSQjEyQlRmcEhIRVNWeGZZTm96ZTdibXdrWGl6Zmdp?=
 =?utf-8?B?cFdKenduZS8wVmpRRTZHaUVmS1pDRHdOd2hES1dod3VOak1MeG5yYmhmUUN2?=
 =?utf-8?B?UFl4bkVnT1o5ejJYay9KU3lSQjNvY0QyVklnK08rbzZJWG0rcnZidHBZR0dG?=
 =?utf-8?B?SGNqODdaYjFRcmpxRXNxSzNoQUM1RndnYmRZMkJuaVV6TnhRUnlwTDRSTjQr?=
 =?utf-8?B?RGxJYUpvZlhpME5VM3BBNTBtbjBtbE14RENEVGlldUJFeGlqcFFPaVlVdklh?=
 =?utf-8?B?a0xpZnBaTENCemFVQVNBaU4vWUhzTXNYRTVPTnNjS016SkRNWmFhUXJYZkE5?=
 =?utf-8?B?d0ZTOTVTc01FKzk5WENaaFU5emo0TzV1SEQ1ZFZmSk92NXpyQlhWZm80bFZF?=
 =?utf-8?B?akZ4cVJ3TUV5Uk1sSHZRQVh5ZG5JRytrUXVzOW1EUmtZSE9GVGRsSDlneVhM?=
 =?utf-8?Q?yAzw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2026 08:56:20.4788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8e3423-ba0f-43a0-9a64-08de4913a20f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E468AC0002
X-Stat-Signature: oqc34mf34nwjgb7hcjazyqpy46d6d9j8
X-Rspam-User: 
X-HE-Tag: 1767257784-35581
X-HE-Meta: U2FsdGVkX1+WkGrKPDpb1lSplvhOOchdh3H4Q6zEKvWTa6G/hjmNKzrvc6JEaneWRFSbmiwCU1/xGepAPBRwm70t04xZwk+IZgEae4P9IIC10xRrUtvwnPuv1oAiEW2yF5iOm9GwNLFxrlpe3BFmV0MPdkSPcBGT5y59Bjy4Mc4TUhpYiTv4nWvTGJI4ZcMMbJu2CySrVMWhQHD+ufCx/IRpu5TiMBpCI/+Gfqb/8Dl3tC/LyFtBJPozKz0jyMfQKxzrSc0KmioxZgdEi4MesvJuiSAVYr4TJJNKMCsLAp7wEw1H2MiDB5YsxBhjH2gotH9DJvJzZYVUEcdh9k4dxcOeJ5UNyfm7/1VGd+nc/IoRpCDIIyioZPkhfnQDvtbRs6XlDXda5qfTZdT4ftHlWSZ88cpp2hbp3s/f8/q19qAgEnzWNq61MMEqwXQQfJK+Lfytk6jbHK1+MMMrHTj5aDSgws0/PYiLMQ9heyoDmlBYibF9wEGXjA4apfHnBdOfzz9pshIe9kmahOGQAizNOahnykDR4O7Gxa4xnp8FsRaSuHjI7/7eT5FzBjaxgyRxs2QQocuTXO3LQaXfLYvL3C2u03DEliZtRe2Fp4in6SMxE35cm6CcGtKHeJ1DOAhJsPNCNBhoVZfuItHOZfW+bBRi3NYkZdZmXCETBjuurW05lwWK3p3F3Jvn+MJNFP2eE0VieDgHr7pFMZYjuSl9lU1KL8fSvJH+BSdbdZsfluOQAily+CaCt7aStIX5IBbnBO1ItbYNlXICBn0EcTR0qEbuDrZrMmX0euZ0V8nMQC/hNawAqCwYj8kDvlGVBtLeQlOLaSg1QWSbcUC9IDqgOHvT77oTVD6AvLV8Qfv5dIshZm5CZ0yYWIPZpzzFB3VAFIl68e8ueK/leaUypgh/SUdoiXqRaNJ7RYz/8bHwxVOBOJSxFMaT6ia1AI1LPaK6K8k9cSskhGs8XYjO9BP
 jlYttWCB
 J6K03dnHo268swLS5BubBQoiUGy0KY16rN2Ym
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22-Dec-25 3:56 PM, Alok Rathore wrote:
<snip>
>> +static bool kmigrated_should_migrate_memory(unsigned long nr_pages, unsigned
>> long nid,
>> +                        unsigned long time)
>> +{
>> +    struct pglist_data *pgdat;
>> +    unsigned long rate_limit;
>> +    unsigned int th, def_th;
>> +    unsigned long now = jiffies;
> 
> now = jiffies & PGHOT_TIME_MASK;
>> +    unsigned long now_ms = jiffies_to_msecs(now);
>> +
>> +    pgdat = NODE_DATA(nid);
>> +    if (pgdat_free_space_enough(pgdat)) {
>> +        /* workload changed, reset hot threshold */
>> +        pgdat->nbp_threshold = 0;
>> +        mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr_pages);
>> +        return true;
>> +    }
>> +
>> +    def_th = sysctl_pghot_freq_window;
>> +    rate_limit = MB_TO_PAGES(sysctl_pghot_promote_rate_limit);
>> +    kmigrated_promotion_adjust_threshold(pgdat, rate_limit, def_th, now_ms);
>> +
>> +    th = pgdat->nbp_threshold ? : def_th;
>> +    if (jiffies_to_msecs(now - time) >= th)
> 
> Setting time in pfn hotness using PGHOT_TIME_MASK in pghot_record_access().
> Therefore
> here also it should be calculated using PGHOT_TIME_MASK. Then it'll be right
> comparision.

That's correct, will fix this in next iteration.

Regards,
Bharataa.

