Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC14FD1D47C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6122B6B0096; Thu,  8 Jan 2026 10:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573CD6B0098; Thu,  8 Jan 2026 10:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C496B0099; Thu,  8 Jan 2026 10:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3493F6B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:36:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7099B62B6
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:36:27 +0000 (UTC)
X-FDA: 84309198414.19.7C1A13C
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDDF0140003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:36:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r9ChSAyd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankita@nvidia.com designates 52.101.48.19 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767886584; a=rsa-sha256;
	cv=pass;
	b=5iii6F0DS6vEKp4gnrErpZiJ8SWTTZ50qz9wTwVwIVYQCxPJkNdVJm6Js8stjDb/NKufdn
	Kft76q/IzjEkduWXWls/yK266S0Yqki+MvtrV9qpPNPU2NXmlcD5tkU5AlHApKKA4SqFA3
	jPWOzuqUIVvNFbRw1Gf4oLlQ6qoulxA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r9ChSAyd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankita@nvidia.com designates 52.101.48.19 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767886584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
	b=Qpgtti1Kx7rSqqaE/meWGT7IoDn4jARs+GezTUicKMIAf183PfVtJ4gXGQHhSsxS7WVSpU
	M1psz6vqCOkZJv4ztii6I8wvWZPjOYZyjxcfk5FyDIrbSUYvjyM4KwEqRuq7p5iT3Duiz3
	ZiSIANYU7WXB8eXVlvVfNUHXciqwQ8Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vF4AxJUNqnurfIrVqLkxobbCrR21V08X+950n0Pq57xrbyRrqlWxEYMhzhxfhko4yP6CPIWOGZ9MIrJoIuIDdlwbm1uQU04X+S0GqQWpw67JAzh9GeqDIffdPyr7Fsmdsj34cfb5l3Gw9E0RomulqBMVmVzMUPQWaQAFZtAcvI8QEM1weYF/76ULV1bwTRb4QzYwTPvIt89lR5hjI8EXqVl/EQwk2tZlUmeGYnW55gBnZ/6s2v9o3BXmUUjvlRx0XhpCl59Q6DEdzvRLRYQ8covFXhO4oDbAfpr01mQiNEIxC7QRawUvQgkbJxk9OcSJDAYKbCTcIo6UaU8lXVSpiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=qrZy5IOSNksQW04LdhnSysGsgyc3/tAsCCwWWuf4n4mDOEx0e++u6Afv95U137QjuuADTCzKQ4aITX9ACYMX9vFcBoWT9j2nAEwpvdNXKBUM7VO4/fJCpDkw3JnyUQdfoq7UYusnD5X3rC9pUuvRatkQKPNce2bh9Wme6JJs925pb594teDmfcHfqQB3w/eKsamxq6P5jVFuR3PwqKAIp2fW9w478p7OIkBWBw3xvx7N1MAcescCCpxqNcuq3BOIaYF3HwYpkd+nOyfg8XfBYf70m58y8lvFX/ROrG+z4s7HOHILzsPqGdK0Cp3/1wRyHT5+FzIMfWcx29kXvMYWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=r9ChSAyd4T6Pb7RPDs6FcrVjwgaylfmQvqEzgBXqFLYetSpe+UKbJTcZoN/ZLcLNSR7a8l0nEOW2ga/7vrqwILzbrHyCTdG0fmPqfwVi5QHDwXntPVo0kfu3ndvV3QGrhyw53VOZhtfC3l/vhGjpvg6PiIlJ8/35a53X24vMF39BddjYPupY651nJbk/2uqwn8G+i7rARLkM5hCbcRvKtKNo30YP8/jeuIBYNGiwiSxzhzq1X5DXQ5PRtGV2a6lecKI7u+lTLuDJah3JbwYrH9Rwy0Z0wc9ozi8ytQMj1lF6ZjKivB1/hJm/EMSyud30Yn3woPzmR4BBpLqPkf1hiA==
Received: from PH8PR02CA0002.namprd02.prod.outlook.com (2603:10b6:510:2d0::11)
 by CYXPR12MB9386.namprd12.prod.outlook.com (2603:10b6:930:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 15:36:11 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::e4) by PH8PR02CA0002.outlook.office365.com
 (2603:10b6:510:2d0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Thu, 8
 Jan 2026 15:36:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 15:36:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:50 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:50 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 8 Jan 2026 07:35:49 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 1/2] mm: add stubs for PFNMAP memory failure registration functions
Date: Thu, 8 Jan 2026 15:35:47 +0000
Message-ID: <20260108153548.7386-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108153548.7386-1-ankita@nvidia.com>
References: <20260108153548.7386-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|CYXPR12MB9386:EE_
X-MS-Office365-Filtering-Correlation-Id: b696db80-f2ba-40cf-46fe-08de4ecba65c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?atX4ALc52W6Sy2JXMjldgG7D8xHRBj0MnzmF/2Hp475iUYFgnnBecN71BGJc?=
 =?us-ascii?Q?BNA0kDiF9oPQu+MxZ7/yTliqVG80UkSkHoReV0sTFhY6qjvo764GeUrLHpT8?=
 =?us-ascii?Q?b1OTWYMF2eOLygJfTjeevX9/eS3UBK90pTjeA5XpHpAORPlI/ciGtMo7mNtR?=
 =?us-ascii?Q?adfn/sRCjHrxV14aUHLsaSJNFPeHJywJ1uk7Oi9PYwy3d6aTjX40a2Fq4cMd?=
 =?us-ascii?Q?hN8I1Kboo3T5HpNt/eFzy6YgDSUb656dwfV9yUa61dbt1LMbyxDeD9aI9vdz?=
 =?us-ascii?Q?CwmzPv9t56aONuY/iYfahbCw07Wr2dU/bbvKwkEEZjvWEh4KpePcp4VbC9HH?=
 =?us-ascii?Q?o0TpuxIrjBUJeiU6hGufeXNVL8O34f6pxv8LOZrTsCkATLoY0ROWZEaXMFMp?=
 =?us-ascii?Q?AiV3yu8+Qj3Qwf7LSAIC87TPKhq2Y0AN14m6AFP+iGBzeOByQt+OOPko7GWb?=
 =?us-ascii?Q?bWdBc6lBC/hXLeaGbMh+NLdYNdGRZb1iXyn89LNZC8jhWn0bwg4rDcNc2OnC?=
 =?us-ascii?Q?+HsnK6Tzp9/xwX+Mq10+VWNnjwu1bLKmMY4xsyAKR8y4SPwKmHpA96CRcKae?=
 =?us-ascii?Q?JJU/d3UfLkwThyY3Php9BRftPIUH98yHOhJ0jQbKHREwRgiMbOuUxjPHfh4D?=
 =?us-ascii?Q?HFmHQnQ8kNblHqeHlNPSUfoOfjPKHW0n/z/9kK9BWxm0ISLOykNmB27mjFKJ?=
 =?us-ascii?Q?eS8+LFdLvvKniQs764vd4kW0cdcTqbcfB8Woj65EcF99O4eO1sEY1a88+04H?=
 =?us-ascii?Q?nULmvGyQsxwLOukYfd9+snIwXLGlPxC9jnW5NlxEZAL2Jy/4CZDXRozQuH0j?=
 =?us-ascii?Q?7uPoZDicVn02oU/UpgxiERV/3uSKYCeyvHfabbGiozHKTs2bYoMu500mOvRD?=
 =?us-ascii?Q?6M8x0L/Ul2UCdY0Ly4Hc9rfYsqr1yMHpmcW+9EBKvfF8ahsoR5qqY6CzMSQH?=
 =?us-ascii?Q?E9dfMvDuedkq13KNbmrfmmliQcUP0hyYaqkAFjFggDKTTghkzC39e5/1sLAm?=
 =?us-ascii?Q?frkjMm/0SKoU3ymzVuqXrSbc+FP3p08f56kUlDeWrcTi2629gBoX+FJAcoiK?=
 =?us-ascii?Q?IvLK1LdPfl1NZSiO4wDKOZmXxgSrRg28IWmq0QOXWrhVb1TzorOi9AWCrEAX?=
 =?us-ascii?Q?xyPX9QbtuzUGWHN94PLUPJA9pnmVoUZlpKoyAu+hwf6A0Eo/DUn/tHvRjqjM?=
 =?us-ascii?Q?BcHuMkvZLFO3NvTgOXq4aM64DA4pLPe8c+OS5Of/MaLohvtHJ6T22NJ97FId?=
 =?us-ascii?Q?8fnjPnfATA6asjbjjwnh/Rxzf6pze9d7gkMDFklRTsLCCwb1w2TTzWYXfYc+?=
 =?us-ascii?Q?/re0XAk2mD7SxEA1joI/xvIRWQGkgfbGVY3zwHCPCI/W+z7+Ern1skd2UhyX?=
 =?us-ascii?Q?tjAptX8zi7VG20lueU2Qa2AZYV/+d0jfBnuH4dN1A+zu/o0cJvBxa8iOjUs0?=
 =?us-ascii?Q?LSzbtmviFZAYA4ReemQceBpyL6Efw6DYBhRl2H3ggq9M+mOk0jBNen4TRRWk?=
 =?us-ascii?Q?K7Bl0t0cFj854z3Htd90uBevmRDg4yv7gMiBfdEpaFLSumO5sVekAVZizeQl?=
 =?us-ascii?Q?kiwbYGiuOQL9QYkXC0M=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:36:10.7961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b696db80-f2ba-40cf-46fe-08de4ecba65c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9386
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CDDF0140003
X-Stat-Signature: r1k98thfhns3i5g3iq1xscjwisiakxzo
X-Rspam-User: 
X-HE-Tag: 1767886584-191768
X-HE-Meta: U2FsdGVkX1/2d2X1bbo1LRD3lo1hHJeMxGzMqpv4AefgKnPNiTlwO41GJdWYAeA8xAdantfL2D8C2Q33wfZOM0M9hR+gjs5mzx88J8TjrowO2wd9BPmby0ymQhBFJjGvka32WYBuH+4IR1TJdxz4Q63vdjHbmisNJ3YUzpkgZw76GFxNo7ivp9mietsz9UozJatWzcUjbMJF0/Vt3EfeBx3IxAlktG+bDDm9E+bycm1/Xugrb+EtQKJ0XF5z0ci6qHc1OU1xXX2Y+rM2bBgHJWwgO6WsjoeveOtnDCOIXTw0iB2Qk+v5v2jS6FvKa1iAFrfuCYZ9xmjsGH6EhaKtpmtawr8Y9O8DCrPoMbIkfRUyHFMDbL9a8spUjASu0aeZffGyjEJiIgTPid169xlO2NSTO0cN7aXnfHEpDzVw4GTCHZ2T4m41G1aNpJvcoDB0K0W/VI+9eM9376tirM/j3nyMOppA0EC7vubf/8R1rvO5lv7TOgXtnXGzsRvNiooSUznzp+CBr605Ux6MpAt6LOynHQmTiVx+7EDvazzCdZR8mfCFjP+yQUb0ZQNEKETWKKo9SKfrh4anrNLC7Y5ELKwUFALo9/fy6eBJsqH6ahPDhskrnurxmuuimpO2v+P/N38fryv8z+qAilTZ0G/eM+arLn7z5cXs6utuGmER7xK1pKcMjlgibo77nI7nPSbLYL8ikYpiopi4SyV8d30lB64Ecz6o9t0zZ1Ha/x/xmTqQvRvJ859P7Qodv2A7arwtvQ4S7o0YOlyhYGlYbpfZw99FklXRSASkS5/pi0678uKiqhI9Ob4npZgf5nwuXqJ5T55/+2+4pvcRP5Dl45eer5EoEm8dZ1YjYXWNPShfroV92Gg66wzpyfFCPLomuIhSqfmQWdNxqPEMCkgjqlqHnewAWsR5AufqGp5DqcQuXE/6cGc29L9LYvXHWb8YGxSHmRfBCHL5NFBfUA99cNG
 Z6zZk22F
 O4Ghld8yCVIwZmmBmQA3lcIX705Swb5A2DRSeXx8v8/Mz2Gln54z0s2wJAucAs0mSy9LeK/CcFjV1L1ODRHqw+Cwmb0N6St3WJWBYIMTvVFIctuMne1zrz67YGLTcA1dehfNZBVqfRLD4pnUkZq2HmOtFiY0WD6M5LZtQLBWMaBRWlsolWAWbnQ5iKe7MzfjZqifyBiwB9x0nRrJOrIga5VvvF4lCh5R+uNf3xfdobwkEoVW8ZVOK1nWcLVN8P+DOvOPtgkn8eXHLQ3KABmmfVT8ks6fo6dW9odnatTLFvURT0Z1xZdMAY1bGL4UuMyVy/pj+KmFBQwEtwe5Edh+WLr13do4fAqGKNC8YLgzqq0A8tUTCmQJ/q1v0NEW9J6XAobCCEcXG+WdoBj8K/71jSeO/o5v2BHCdukvNWEY0vg+su9EHmoQyRguHCwJTinvVI+Z4VqEwkhNM4g3tzZb9HV5DHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

Add stubs to address CONFIG_MEMORY_FAILURE disabled.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index 7b5e11cf905f..d333dcdbeae7 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -4,8 +4,6 @@
 
 #include <linux/interval_tree.h>
 
-struct pfn_address_space;
-
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
@@ -13,7 +11,18 @@ struct pfn_address_space {
 				unsigned long pfn, pgoff_t *pgoff);
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
 void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+#else
+static inline int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+}
+#endif /* CONFIG_MEMORY_FAILURE */
 
 #endif /* _LINUX_MEMORY_FAILURE_H */
-- 
2.34.1


