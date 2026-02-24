Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E89E9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780B66B0088; Tue, 24 Feb 2026 06:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F266B0089; Tue, 24 Feb 2026 06:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607396B008A; Tue, 24 Feb 2026 06:55:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9D26B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:55:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12147B9DD2
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:55:35 +0000 (UTC)
X-FDA: 84479195430.19.A7778B0
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012059.outbound.protection.outlook.com [40.93.195.59])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00A321C000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ARK2rWay;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771934132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghvF+d+ecmkzkDVKA55nzb6ZbR85E9mru+H8D9XoK7I=;
	b=0yAwmcryAyFkQ8hTMdft6Za6DVnsQiKGF1xSbdpogMb5rU711rpT1Ed7dl0Dj9nBIJejyS
	6K3YPdX3YFgesofgFBMJk/GMYloifoYVsvv2cb6WeH2xGtxXgD27XsEDki2lCL2gVikanL
	ewBz7wXzYvzjUiwvvMszhcjYde+kAqQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771934132; a=rsa-sha256;
	cv=pass;
	b=cMKfjy0cTq5JVR1FoLP98a98xH2EwHxrL6md0ega1Pl9krYGvxvx1AoOb/SGQLbYETD9oE
	HFq6kjsISHozAuhGDugIfWuuRwmLHsOPtMt2tiZobNYQKqx+098AIod4/G55mT8w2fkrrR
	0wtffG+7hqYiF12A+TPUbG8izME9Jew=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ARK2rWay;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llzq4Gb6mPmOV6ffwSeVXH1ozSHiXnDMh3RFaT2NSrwvyTJ3gLeX7gXczPHtZwg984qKILuDdNdIVL11I+89H+Afl1kIP7jG8p33PF4NLJss5qUAcCql77T01spXfmEmk3qA8lcQw9XxftqnyBnGIDS8yHl+IpjmwJrjO6FbklYUNJYJjNhYOUYOWmd+RPkF3qgpopXdcafw+l07aVbU2UO8nsJroruYRfVRneHCzwMllNSxb7feklrVuaTOpXeW6Fg0NBEPptBKIUa3F5JHSnyvtx90gCulT6a+vynmLOv7XLaUMV+z2BL/lGrlY03onZMWr5GL7O7JovaHbFmPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghvF+d+ecmkzkDVKA55nzb6ZbR85E9mru+H8D9XoK7I=;
 b=ECatujlCzX4slGXaa/o0sBj6rY7qzAA+UT4/fc7MuA/rKQd++ROM59nUPOsSHv40wTcO+JptJyriefF+0M1h7gCTDwWz2VBRSzLzWjmCTXUkdAVvcWEKFlhHLXJ+iVPQoXAVozro+6i1/I6Q5HMmhODcavFJy5eb6RhXhbQ7KypOOiGwv7ycuJxcHz2aZiZPBxRfOaPp/+audGF8mOuTSz1KB+/5pVOdVikYt53o5A5s84HUXSfMNuBdvqn+knOCB8pk8w7Q2pCQg9e63ZlT9HqtpyvokYWCrrh6t6+kRRp6tRKIcTlMGS2pZR0S5HBUkwGNBFGW7DMr1vgbXllblw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghvF+d+ecmkzkDVKA55nzb6ZbR85E9mru+H8D9XoK7I=;
 b=ARK2rWayp+VDSwqmuLl+9jQjtZafn8bSGZDuYovIV8ZU1k1/IT7QP/xOZ4pCZrkwUGHEsfYVxlLB9d5wX/vqaNjx6Odm2OwvW/quhOFPvG5ZJxXpzu5tjKkx8S1wDJup83IlOpaQGvbH+Xo2o1NFHMTxA3mrWNZuCWdmy1JT9qc=
Received: from CY3P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:fb::13)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 11:55:25 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:930:fb:cafe::31) by CY3P220CA0010.outlook.office365.com
 (2603:10b6:930:fb::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 11:55:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 11:55:24 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 05:55:21 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 05:55:21 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 24 Feb 2026 05:55:14 -0600
Message-ID: <7a574665-0a65-46fb-b87d-d2ae28308759@amd.com>
Date: Tue, 24 Feb 2026 17:25:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
To: Gregory Price <gourry@gourry.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
 <a8d1efd6-2ca4-4f1d-9c0a-c8aa17732ee9@amd.com>
 <aZxsBifRchLn2m42@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aZxsBifRchLn2m42@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: b64be310-bdcb-43c9-3f3c-08de739b987c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWhIYkFJN3o2VVlOYjFTNGl1cFM3ZlArNWhnaE5zdlBzKzROVEE5cTV2UE1M?=
 =?utf-8?B?MDFHN0dmek1NQldYMDNCN0YzOVUrQnRUUHdxV1VRS3JWUW5neUZrcWVRZGhC?=
 =?utf-8?B?R3g1QU5Ud3dOZTJkcGQ0ckZiRys3WnNJeWJ5Zmx2NlZianZmWngwbExoUUgx?=
 =?utf-8?B?L1VOSkk3aExhdHlad3h3MEJ2eXlRdk5aMXZ0Qis3N1p0Mm00Q0JkWFRRcmNG?=
 =?utf-8?B?WUlMVG1OSlB5WmVEcjR3S2xjckRNZWVqWDFpY2tSVHJtbFczb2UrTzdDQXUy?=
 =?utf-8?B?cmhRZG9YQkJGT3NiRVVZdVppVEdWR21Zdjh4Ymh6dVV4RW1rc01JeUZFYmNC?=
 =?utf-8?B?R20zVWZvRlpPOXZNeEpZMjIzdG9YdmNEUzVvOHk2VStrQ204eGhzQmxXRDNx?=
 =?utf-8?B?TFgzZXZra2lTcytJMTBKZzFOb1l3NlhEY0lhT0FiRUFlcDkvY3RENGJlUDRL?=
 =?utf-8?B?N0FSOWRtd0wzVndhZStxSXpXL3hzTlYwRHVvbExxMHVJS05QYlI0S2FkVVR1?=
 =?utf-8?B?MG9XTUxLMkdaVHA0KzFDVDRMNUEySUVsanRlVWFoc0hhdkZUeWdKQmN2UGlw?=
 =?utf-8?B?OGg2NWk2algwOXRKUkY5QzlrWjZzUDI4YU9ibGVWdW9RaUtranhjK2t4UlEw?=
 =?utf-8?B?VjRKcUswdjE4Z3lNQ0xqSUxCTnA3K0l5YUJ1YmNESWZjekcwbkcyYTNWMkFn?=
 =?utf-8?B?blJ2MjBXbnlHOFJ6RHVFK0ZnNVVRcTMzM0RndFVOY3UzRXlNY0lPUk80VVJE?=
 =?utf-8?B?RE4rZ1ErRno5UitKMnJrRVJRWUhkQWxsQlFBdEllQ1JYUFpaU3R6ejF1WVpS?=
 =?utf-8?B?SFZZQi9Gd1A5TGliRHVwU281OFVhZFU0akt2MUNxNnA2WUIwODhOMHdSS0FS?=
 =?utf-8?B?OTNKeGZ4YlVrNThFNG5NWTR1cm9NNmtHT014dHZ4QUIxNXNZNDBBQUdnZ3Vt?=
 =?utf-8?B?M2hFeWh4dmJMYnNZZHo3c0xkL09HM2pES1FaOEtGeGtTQm5PTWJxcW96bzdB?=
 =?utf-8?B?dER3WWxZNEpienFid0lWTHc4bjBMQmhveVBBSUdXeHVtOWZQMHpRMTF6bHJo?=
 =?utf-8?B?M2J5N0QxcUlBWG5ISXliWk85T1pmMTdUOFRWOXg1OEJzdURoQ0VLVGdNb3VV?=
 =?utf-8?B?am9DQ29qREVDa3Q0cmZQcWVCNWd5OTlnMHI4VjhOZW4wOUVpWmJMOUNwbEFD?=
 =?utf-8?B?bTh6bzhjTGQ3bkFVSVhtQXZEQ1BFb0pjT09RTkVDZ0liaUhiRHUzSStRNDFM?=
 =?utf-8?B?UTRsRGp1eWxZY1pJM2J6MVh0YkxrNXdHQng3ZXdQU2xhWHdpNnZuY3hQajhp?=
 =?utf-8?B?akswYjNSVmwyZkFJQ2c3azZ1cENKSFNhc3NOSnJCSHdvcXM0ZW9MUkc1aWtH?=
 =?utf-8?B?VmVFS3pleWNzYXBKM0VSRmdaNEg5NitrZ0p1K01CRDhXU0U0SGxhdUo0a2kx?=
 =?utf-8?B?bFdmMTY1MWhoaEdEN1M1QlZWWFB2bHN3cnNSd2ExZHRFMmNqc0JNZCtzV2NU?=
 =?utf-8?B?Qi8wNFhqbGZBZkxudVdkNHFLVGVuajJ6T2dFWHRtWW9xTnQrUXJSK3A1c3kx?=
 =?utf-8?B?Q3BEamZ3Z2ZEM0ZHd0JZNEowLzdnMFRhWVhWTS95SnFKZWpTc2QvUU5SYmJu?=
 =?utf-8?B?QjllbDBsbDZIRHp2RzN1emJkaVYxR0VqQzdwNHVuckdWdEJQMXN5NXk5YXRv?=
 =?utf-8?B?ajM3NEt6clk1R2RWdko2R0RadHRvZlhNVWFaamc0QzFiTlVQZnNYRlNnWURX?=
 =?utf-8?B?Nks2NW9vcWlDRUROdFBueGtRL1RQNi9tVFBodHlRY1RnSDRhYlZVZkl0VGY1?=
 =?utf-8?B?SnI1dWVUejloMjRveDJaaE9hdzkxeHVaSFBYa3BlYzh0L09HalVTK2NLaXpU?=
 =?utf-8?B?SyttYndSakNqcGl4a1dPSk1ZMVA1YVBaem93TXlJUmlEcG12aE0xcmZHQURU?=
 =?utf-8?B?L25iQTczWlp2SFI1b3FQd2hsSnh3SGxTc1FTbm9ibXIyditNU09xcTFoSGU3?=
 =?utf-8?B?cXNjeHJYVllOYmlhODRackpPZnNsMlNGMmNJRWhvMmhRcmt5L0hsdW91YURU?=
 =?utf-8?B?YldTellLU0ZMMnA2L21jTTNiUHlpcWlWM2pFUHRTaWs1bDFNeG11TFpGQmd1?=
 =?utf-8?B?VU9aOGF4cHErckYrRzc0NnlKMXA0elV3c05EMVM3STJtZ2JaWG4wenJ2SVdQ?=
 =?utf-8?B?Sjg4Y0s2dXNBdmpBb3hKdzNTTjlXQzRtTlc1d0k4ekJ1UTF0ajJSQ3RwbS9V?=
 =?utf-8?B?ODhWQWZGQmJLK082ajlJZ2dGYnhBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KYRtYtbrjp3lE+xbTBODgDdCbv1m+i9K5dd00HMOGfEUsmrwTP4DqAGGVhaBra29Bh+v23B3gIe/aS5QKlWPoCKUacV3jD4CZBVK6dbzWDSkr9hYLHREcUV6H8u0dMMqGIx4c/Eqi/x9MTnGAEJiky3dGucv5S8uzQIOwOIFy5UFrZisz6bmFJLtjATYaB7sRaXcbTXkE5NyB4mGhjM6OYlx6Tk1uij3onE02vtidd9nZy+pDS7yrNfsDE3Px4h5hG2Df7xMx86G8bV29HZHaBYD/8rReel+pdi6osmRXC0wr2hc5VfD7Tt91A0dO73tkBC1fKBkrFKd6/BxZv3jSC07OByMeAFwk7ZcQJ8kHkrRV7Rndh9NoIRZYuVjykZjy809ZxNSMG2CQr9dANvtbeE4TiCP4hkFO924kDta+P1j/gcts9QXXhQZWcB3jSyh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 11:55:24.7710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b64be310-bdcb-43c9-3f3c-08de739b987c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Rspam-User: 
X-Stat-Signature: 5pxgpo5kaan1swou5hpb16gc1u8mc4gg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00A321C000E
X-HE-Tag: 1771934131-709030
X-HE-Meta: U2FsdGVkX1+wOie9KxDPA3T2BeP4APvxv4UGAYVzsbuib3ECWtJ9SsgSn39RMS1sOI9KuYLz61Y0FrKFpEY87DJAuOTDDtnzoAtcDqRA7m8f4MbB2l6f6SClj6n5pdRP0WzdKJIPo3QRKR2fYBQJLGa1fShGDfG3gP5K5HKd0/zqEwRGoa7n7opupnwXFjg+qaNaih2kpLZf4q2J7vCrw7JPtwCUM71mh8kAjmNdC5OAEK10sQhaDhgMqkQlm+Z2i620XvFZcR5N9YU8R2hmmskFW01uVxvSPk7hLBOYNKJGgplRZaubLKkMkHnP9LALDzCC488DY0qAMWOqnvCom9XObfWG+ijnW6f5kP8u0lErHiUU4l1wf/3czNDLYYE+oJeH7uE8+bzYrY/VOHU1f3qu74LBhvTxN0gQH30FcVhucjrZs6gPQqWTnmI8GufYb/w//DHE7FXxv0E62b2zq/cle1E7aA4Z0YC15Ne1FrWtRhQziYJyEszd4mWPr1pfuR8xMbd/081dVArC55WAew7kJpRQQi9zawsUONX1qL6YEoiVT20gqLVy9yah7jyE11xEsI+ZSTQuI7nCQB0FkTZvGKQSIBQbkDC1j/WmYeaJuIg0wkWB8d/ohycybTFhZmmblc42qKypFDzNYFPT/4JgYYTa6SRpXNPFKybwxc0wLMrluisNWslbObhqpEXVmKhPX/QBGdPWucoeG0n0tdQZRfWvyEDQlBtnQ/DzKTqep/2KRqBGlIhehGvpavSQmB5BOJp2rHZdVZ1hLJIq23x+jsQpGFXnemkW+vHVXpb0OAKBrCHwga0IudqIjVg4AA+6FF0Z3xQn4DJz6ng8kSVesEGp5NkrqkRqwhk6e2ypshQ1d/ri9uuGhfEmtralGMPeO2UbGKl3UTm6Dg3r9rBaYIFG0/5TJNT76qGrgMQx1/3GT/z1icYyKyqy/E+mihhyACCPagiyS8exo3Z
 4D0Tl0OV
 LjYDDoeVt1TK0XbfvFLUNxLniislzZrSDVACX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23-Feb-26 8:32 PM, Gregory Price wrote:
> On Mon, Feb 23, 2026 at 07:57:39PM +0530, Bharata B Rao wrote:
>>
>> Time in seconds - Lower is better
>> Mop/s total - Higher is better
>> =====================================================================================
>>                         Base            Base            pghot-default
>> pghot-precise
>>                         NUMAB0          NUMAB2          NUMAB2          NUMAB2
>> =====================================================================================
>> Time in seconds         7349.86         4422.50         6219.71         4113.56
>> Mop/s total             53247.66        88493.630       62923.030       95139.810
>>
>> pgpromote_success       0               42181834        248503390       41955718
>> pgpromote_candidate     0               0               577086192       0
>> pgpromote_candidate_nrl 0               42181834        29410329        41956171
>> pgdemote_kswapd         0               0               216489010       0
>> numa_pte_updates        0               42252749        607470975       42037882
>> numa_hint_faults        0               42183772        606540729       41968150
>> =====================================================================================
>>
>> - In the base case, the benchmark numbers improve significantly due to hot page
>>   promotion.
>> - Though the benchmark runs for hundreds of minutes, the pages get promoted
>>   within the first few mins.
>> - pghot-precise is able to match the base case numbers.
>> - The benchmark suffers in pghot-default case due to promotion being limited
>>   to the default NID (0) only. This leads to excessive PTE updates, hint faults,
>>   demotion and promotion churn.
> 
> Wow, this really seems to justify the extra memory usage.
> 
> Is it possible for you to change pghot-default to move the page to a
> random (or round-robin) node on the top tier instead of NID(0) by default?
> 
> At least then pghot-default would be correct 1/N % of the time (in theory).
> I'd be curious to see how close it gets to NUMAB2 with that.

For pghot-default, with target_nid alternating between the available
toptier nodes 0 and 1, the numbers catch up with pghot-precise and base
NUMAB2 case as seen below:
================================
Time in seconds         4337.98
Mop/s total             90217.86

pgpromote_success       42170085
pgpromote_candidate     0
pgpromote_candidate_nrl 42171963
pgdemote_kswapd         0
numa_pte_updates        42338538
numa_hint_faults        42185662
================================

Regards,
Bharata.

