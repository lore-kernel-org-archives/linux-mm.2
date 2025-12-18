Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EB3D6ACD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FADE6B0089; Thu, 18 Dec 2025 04:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF376B008A; Thu, 18 Dec 2025 04:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7796B008C; Thu, 18 Dec 2025 04:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59BD56B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:37:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 281261A0CCB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:37:26 +0000 (UTC)
X-FDA: 84232088892.18.D6E9816
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F8EA120003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:37:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bJs9AxP3;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bJs9AxP3;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf29.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.49 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1766050642; a=rsa-sha256;
	cv=pass;
	b=JBh6KQAn+bnx0IBs+fDRcB/hVTn4/UVk2J2fLYlq3rZ4Hm+gFeZqfwvgLYMEowYdHQmpde
	k+k8WTrCP0jnWzCj6MRqqDk6n3+2tZgSgKEA8iCo5ocy17f7SOMRFq84jOWYzz7HShzLlD
	XhzTlapMkPBKfqllqGHgrmEJsC7vQ90=
ARC-Authentication-Results: i=3;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bJs9AxP3;
	dkim=pass header.d=arm.com header.s=selector1 header.b=bJs9AxP3;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf29.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.49 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc9RsHmXLp7J2E9Jmd1OLs5+LUDFCtN3KxnidYNxNaM=;
	b=c72VftKNVNNMYLlEzEhpDw1ypA7b0E8qDM7WYAsssD3/VXxwkbcMk10yRecMLvtAEPBDce
	GPv2YJxTXa9k5a8TX1XrCQwtprG3sb7zM75bkyMF6aVrsmnVrUBKqZ545sdKLeVvJEa2Fi
	Dncl6VVVOOAhWjn7q9dxJ4mvUtSbQUY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=V7/xdQWJVhGESUFHCbauBa1myd72g5mhAi34Wid9MPnIfiTUGImn2dLFKQCtBQvi0rooxPIhWNuamWe5QJOkxo6+HJOdFO344oxOB0lT05zP7qNNNcm4u7wWBUtfXfF5/xiSl71MfypEgi9GyDxPM2MFTvKUMBvAIFEAOZD3z0H2aQW9fJfj0kMajLd0MOkznMPjKHJOOG7DRdwM47pEBsPh4Qsi+Yc2i/04zvX46QzCnvEseJy1tMS8ksf2lFefS1HD2quqMEM+jxwcJFv8gdRwlYiECUAoUfQvx5aAqoSEsHmo0Yt91CvYiHncfUK/US3fatvmAMiBky+7Y01cSQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rc9RsHmXLp7J2E9Jmd1OLs5+LUDFCtN3KxnidYNxNaM=;
 b=PBj7ailWGvaudbW5aBi7YecT0tbVm7palvdL0n3rOnZiZM6ZOpiE+m+ML3nf9csNLtXsIb2bXzj+yteesDdunZcyC6xMKYqZPpXGbDES4akEXxzBekBmnxMnFrTCwn75QVvwPn2VXaUPaJ9awvQzNb4nAukNVeRbp8GVTaiLoQo2clffKkWb+0nd19J21CR6MVPhg/v26srvMCdOuHnYCnvX9mpZ+H4y3rAe114svqQq6V76tAqSHQA3oywju0B09I4koQKLTRXxm8H/DAA6pvKyqju0mQcwbaD0nWkUo8XNX6iZAS3iWI9luh4OcKjCQleGT3epO3DQnNOnBQmnvw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc9RsHmXLp7J2E9Jmd1OLs5+LUDFCtN3KxnidYNxNaM=;
 b=bJs9AxP33SqBNnHXVz33iDulibsfB3wzyKUndvWt6EHmnBnPd0D30UhDMxB8Fv3ufWMXm1VF8OrkcV6zoYzzQ7yq9qfVx/6pxy9j0F9QcsK5cKl9By/E1+H12OIbnPgQUJxm93jm8Fi+T4JcEpjVMYG6b6wLBi/tBYmgnEvt5Us=
Received: from AS4P195CA0039.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::15)
 by DU0PR08MB9510.eurprd08.prod.outlook.com (2603:10a6:10:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Thu, 18 Dec
 2025 09:37:16 +0000
Received: from AM3PEPF0000A796.eurprd04.prod.outlook.com
 (2603:10a6:20b:65a:cafe::e) by AS4P195CA0039.outlook.office365.com
 (2603:10a6:20b:65a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Thu,
 18 Dec 2025 09:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A796.mail.protection.outlook.com (10.167.16.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Thu, 18 Dec 2025 09:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEnIHDg/ApnTzByna+jEhGlmYdL5EGntl2BXA3n/MvjIjqMpysZauO3+hXEIyXL0m//P5vC+THWaE49lq1B9goZtg3MgdW0dd+nv+QuED4/1sUMDi0e+TKM1eg4M9n/6rbeIT2CcOaxl/KyaYO79CAPArLa9cXQj6OQyIEkX2d6zxK6Wg7cNR+++TT93kY0LFzLMXUIqNsyYu2uG+TdyEIIm7HSK8QOlOXOcC8CnNvzWHWmhxksBPzwh0zvRAF8yvh9SMX8Z2e+S/T3OVt9jX84c0WbMDdALsD8snL0VC6aTgD2Z6s1MbZ1zzxX8X1WbigV0GXMWs/HfxCrZP2q2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rc9RsHmXLp7J2E9Jmd1OLs5+LUDFCtN3KxnidYNxNaM=;
 b=Mus2mz0NEQQg1U+BIpRfFYXhCpSfyKtMSXRdI/+lufWCzLZim0nAx+IZYylJdQJThww/8xJOD9QN36UzBpGEbcS0KOjocUWRtU8QUU6Jr1T+PsEFQT9QlZFpL9cVDcSM9Jug77rXGTsuToObKwXug5Ede8vWBQV0RT04GwARguHu/Y7U0AlBnUzjVqTsjyyF5JopIgZl2oi9MgcNmE672zI4lNgOviaRHF0+9/ixfBmq4aczOqzD34P9k4+l6S0q7aEXIt0axhC0dcWWcO/N3hA2Vwb8C1XQD74PxbWup5BsIA57FyHkjoD/tjKLBzFTKw/w+kXL9X0a+Wo2C+GDTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc9RsHmXLp7J2E9Jmd1OLs5+LUDFCtN3KxnidYNxNaM=;
 b=bJs9AxP33SqBNnHXVz33iDulibsfB3wzyKUndvWt6EHmnBnPd0D30UhDMxB8Fv3ufWMXm1VF8OrkcV6zoYzzQ7yq9qfVx/6pxy9j0F9QcsK5cKl9By/E1+H12OIbnPgQUJxm93jm8Fi+T4JcEpjVMYG6b6wLBi/tBYmgnEvt5Us=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM7PR08MB5319.eurprd08.prod.outlook.com
 (2603:10a6:20b:dc::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 09:36:12 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 09:36:11 +0000
Date: Thu, 18 Dec 2025 09:36:08 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
	rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com, dev.jain@arm.com,
	yang@os.amperecomputing.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while
 stop_machine()
Message-ID: <aUPLCPAyxkPeBaoD@e129823.arm.com>
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <aUPJuZINNuNxddRX@tiehlicka>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUPJuZINNuNxddRX@tiehlicka>
X-ClientProxiedBy: LO4P123CA0514.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::21) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM7PR08MB5319:EE_|AM3PEPF0000A796:EE_|DU0PR08MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e0e470d-b78b-4116-ec62-08de3e190793
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?FD9c7HPXgTst84GI9s7Mxq+lRzgyGu1vkGn9t1EVKIvcfo4y7hkJnNvS0vnP?=
 =?us-ascii?Q?W3GpJf+oG28mez2QPyrrlBvVGEXRTaVHKq22YMujE7hCvvzbr+pah2lc/ypI?=
 =?us-ascii?Q?k9MoQ5T3ji8hGb1j62IPG7VHYcbTswJ7EDyuY9R76e/mwnYWqqaSdEE4jrcR?=
 =?us-ascii?Q?QUzy7W1Ek9LiZ55EI5v1M4gfXMlOgWKJdsCA22KheZxOpYDmVD9b4ZssA8Nx?=
 =?us-ascii?Q?zF5BAllIH+Apsq6KgwrYqExElm3xyi7laa+oeGDauMZ9aLYNnCZkzD4j+BtH?=
 =?us-ascii?Q?UTB634bfvkB37fHleRlDe+CqVd5ThhNozey7HvEhyvr3jXREgEmVGhqeGr63?=
 =?us-ascii?Q?qjPy2qw1YpScKDUDsaLwSS5pkla/Enq34qZMCOJ1EAVl+84OghfSsA44XiBW?=
 =?us-ascii?Q?w3ixiIIj1pxzvwVhRah82s3jRXyLZtl8eU8zIottuITm+ZiCx+yvPlIuk3Ss?=
 =?us-ascii?Q?GKKssjep/urieXMlkW144TkNNRfyvEjNnV6y+qey/tUUReIv8BMQtnXMbwIj?=
 =?us-ascii?Q?SzpV/gPV48XYduJ7EDWQ7WZGC+CS2pNuq5sYkgdchvNNSv1pgRQVkJ5r69J4?=
 =?us-ascii?Q?E6mq5QAbvINoKDdCQp8gWiIXW1gb9edG/SCvJGsZCKg7oxK96M5JSz64We88?=
 =?us-ascii?Q?DfruAyrw38ZyPsZTnWSHO99h5iHXSDw8huy7KYD8ZQrg/X8n7l0LBpbMzrru?=
 =?us-ascii?Q?VE7URuyafKv60qZXhyFfYbjSeyqFgar9r+h9W7abbSv1RF+uPDhdMpyk+cBk?=
 =?us-ascii?Q?62MOMp7o0ePljJYhv6VA7dvMY8Jb7LBihl/OVUMnTBVKbKoQeHqut/4qEj1Z?=
 =?us-ascii?Q?wF1Q4L2lyalO3choy04WvAK+uhxXaMRZVPhkMS6N4n3bknC+9nIeV0Izc563?=
 =?us-ascii?Q?asBwYQqjNp7dR83qnXIVlK0uBlm3IvzPuhdX1kJM1wWS7P3u7o/pJH6KwPGZ?=
 =?us-ascii?Q?fGszlC9P8HtRZW7yAbXcAzdGAmGPkcnLnyHhe5WGIfSf/WXWCEw9HVvhAS8I?=
 =?us-ascii?Q?UzYMQyiPqvNcBlhuG81is8s2naa5fq92S6SnGSS2QtF2IPg63/ALO9VQElL9?=
 =?us-ascii?Q?Pa6QCz5DrQpdsYzb6S/7QPHbw9TUj4pYPAVEW7ne/+uH2AyqSOCmzxMU1Y4i?=
 =?us-ascii?Q?ohdKG0LRo5gnt7jAPt8Ewz2XlutXCfJDyoM5R952gcUTpaqb7z4YuEhm3jbO?=
 =?us-ascii?Q?cd9Pd55DP5P5LHZv2Qyg6PwGV4xWArga7icH2gwQ+c3c+80/xEb1W2oDj4GM?=
 =?us-ascii?Q?S5Zw6fk5u9A4f3RBEJO/qvNthRyL8P6B4zg7h0IaHtPBueQzR8W9z48s+Adr?=
 =?us-ascii?Q?s4iaRAqz5rOTQE2FqPPzm5H06ADrdaa11PE/Jo5V8VKTVP5c8SeWT4xLyT2K?=
 =?us-ascii?Q?pSS8IHDT1KwgYUirhiTWo/4N4DGy1P5DAkf/RneS73K4AGzCC2LakAmgWMnr?=
 =?us-ascii?Q?EdvZRmBC5oFvhYgRuSVupll1muglTW/m?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5319
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f2e89b67-7475-4695-ab77-08de3e18e15b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|14060799003|82310400026|35042699022|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mXQ6MwBlfPRQdqAhHbxvdXaaopDCe2/Hs+Dx6zQD9mZu/XKEGUctooLpL1Pt?=
 =?us-ascii?Q?IOfQVnWJiMo/xxApJ4OcSt9gW7yAAv5P9gJv8xgxzDm+j0QtYfuta8IKKabU?=
 =?us-ascii?Q?bZhWidlY7BLnHLNFeEKcqsw7Y44WRX5dkDcLggjAHtUFmvSliZ2mM0tU0h07?=
 =?us-ascii?Q?58y0ZzLL5zzW4h0tqcr4r4KPzSuXNS8wiW+2GYQeFNTCOMrM6/iWkWWMQDvS?=
 =?us-ascii?Q?de6AA0289s+BE2yVu7Wyt0yHCnqVsuDpmsdpfkyispM++iq4XWUFEeAhVdVS?=
 =?us-ascii?Q?AECC0eeDLlbCVN5EDNNywh2/kY91xvvMJvPg9sxDWHfq0nsAGr6F99AGfXrL?=
 =?us-ascii?Q?ltCzprXXpy9/yt3Xnn5MCzVkuPRuHUloVhNl/fgqq0Hwe3rOKkWNvu4sAhvV?=
 =?us-ascii?Q?JuyOeg1GlotR9GNQsPCi31J+XSIl/9XUwXq9C9ortYC81o0VhLGpStdeuebn?=
 =?us-ascii?Q?nq790kjQmqlEPXdc41LLw9nWiCDhrFnh7IBUxFJlT4DAKACvJLz9kWgE97pP?=
 =?us-ascii?Q?EdUT195R1WBEKpIyhpVD2Q51pmxbDLs0B++dBR/nppE2Iy0tNH14B0UbabNe?=
 =?us-ascii?Q?VvdA9Ndb6/AWikjMKXzx6ek+qI4OByqOMA17PGMUcdgxpx1J/1gRQnekZqay?=
 =?us-ascii?Q?6rQxA/3lJKSlWi2tF1t5c5/z3dsRQohDhDQ78vI/1k35Cw8vhWN1pFDs5Cwe?=
 =?us-ascii?Q?5QKqRm04MHkYGgCKOea4xEmzyBez9ae6LtBTkYocoGlW51tpQ8ADcmazsjc5?=
 =?us-ascii?Q?qBzVUOPTUFV5JH2mXrZ6+Nw7DlU44rb0300V4AUv66eKN6nFq2y3b2neMqM/?=
 =?us-ascii?Q?GdJcbDUlpZfGOXoADJQHmMbopi03DO+Yz4xK4Aczve8hjwAC+O5Xor2yEKPv?=
 =?us-ascii?Q?qKfSWwh7O5UIojitzXPXBQUczLvvPqSy3WTxv2zZd0RPOleoQtA8rFlzng1F?=
 =?us-ascii?Q?FT92MW4A3J+ylqq2F8v+jNjoRoUomy3EqLWRmyx2ASfgj8kenPVJGt/AuTkQ?=
 =?us-ascii?Q?+cGVrlK2wAN88G5pVVZzkmK2TYHRcKKetapOx/8Zt+2HHbYoShc1kKPZq/FP?=
 =?us-ascii?Q?38M+5xj9t/c7f/KPI6vk978zLjxvxgqm+IM+9a8qY2RHLj5iAHqB8TJufhb0?=
 =?us-ascii?Q?5DM8/uVdmJxbMHsWatg76jOTxSz0vSFr4Ce4ALTC6KXHdNluc/OPGWf281RY?=
 =?us-ascii?Q?UeZlfY9xTyGGc+LM1SHTvss+w0Pw1E1QL1bhpcSNSSysla0jxGEfCIFVlfTD?=
 =?us-ascii?Q?Sfk1Nicit+CFk6jdcQgs5RmmuD0mPgrLTuqgU8DjdXdEDcGY/xZlxjOM+Bim?=
 =?us-ascii?Q?h3/RV7di9FkC+4eiyNkrAqpMrdlFBICt96R/R5r5a4mbzO1QUOp8h0xT1Qwv?=
 =?us-ascii?Q?LMJ3LCVDhbVcNXscVKykm0aJOH2vNuiHtyLvsGuOmoGyFHJuTJfzSK7L2wWt?=
 =?us-ascii?Q?J3CTtIQcwdIE0BeyrBcA/v5GRVnVX7UyqCFzA1OCXUH/nuGsTh47W866jPD3?=
 =?us-ascii?Q?6okJQyQakFK19VnKmj++bWNXV8YIctP8QOEk71E/dblWcbgyOgfQMHi5g36n?=
 =?us-ascii?Q?GwUp/S4KY3Hluj/P3t4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(14060799003)(82310400026)(35042699022)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 09:37:15.4836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0e470d-b78b-4116-ec62-08de3e190793
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A796.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9510
X-Rspamd-Queue-Id: 4F8EA120003
X-Stat-Signature: 4r58gfbpr7pbyez7csc1opjyq685ssub
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766050642-618409
X-HE-Meta: U2FsdGVkX1+kMUCL1dgiG0qvNIBPXaW5gdLjQJBUdqN8JXHvFvcqn3IitACU+0HDX7Wf+JYNfyzXF18kOIVATUGVPy/I4wpyXCKn++elg0fvRCnBo9iR5vWCiRMTKBFy8Kv2+VIqqMWA8txoILIJqhbYuRyRr9yQ2m0H6g+ixA0ANMk0nk1DA4LBYaHoi/mkbkMBeC6dWvikNeaZzOglzNyXwUqJ0L486mNG5s1XEgTCsuxuOKqsfQU33qxgonbkG4NqzXw5aYhF78E89m2qpMIq2OZ6GN93jZnkdjjh/bgmZxKJ3SO50UtRkteKTtcl7Ko8kAwoWtqRiQQsxQW7N7Wcwri0hUXSBqjj3k6g49o5NJL16bufEhUgcJvYnQ5sXaDsH4AJFFOAPOeI3rqdHkLvuV4gAkrNYtXTefZG53tyK5aem0L24/At3vCtH9Ojud/FTgOsMsfDax4uyU+IuFdV7iWxT+DAl6jt29i0hfOyFg+3CzSgDfaBZix6NpATEP4qBOxjvPETyBgBdoSnHJvWYqxf46WpzA5LgLxNHXphFG2lA0Ixa+4m8hCqdmZYETEMVEmVR1YfbE/CHxd9W2gnwt8LxjVqGLWdaahEoad5HzFAgc12Ymn3HJwXB1MtpDj+Zo3JhV+TRmeiiXBrjHc8qqSPyqpkS18FX0G0Su8lUj1AyJOtin8FM7AEBDzPTXtPzM34dIg7+SsChK6yKNjVR1VHLVlLbvjwYzyBokci9/Y7HfN3HNc1a40oMuLdbmcea/bYlOjRsvkHSy8ImukKbSYlTcDmZG4OLELgQPD2CBJWhcO+uyT158EYDmz2kiQKlw8zOZitgnpO+bINO2pZ/D2fBL+AHugyRJEhYQacEZMGyhC+KF6sI1kNRKTO1pLVjZFax4dpZFM5ze5L2+7gvFIZpD+QFmXp/AQlCoPSSYJYLNjGOfvTH2izSagIOVJYEDn2nezCRDwTX1b
 oI6QNztW
 fSoERhMDbfvl9TCGMPcSp406J1/kSPPfWoVOXk5CTlKTiKlImbFC3LSKcr3Xh5BsB9CJDVRQRX5qvB6QRVnh6ATY01n1zhNoHGi7aQDv1sA/BdJ520CWYtp3EI0n94EVlvybl4wUKkgam5dHHLu3G9HZaR49BaTEDDwy9M5DvgLBtzHCKxIMlSmpK9UbQCJFLqdj5Mb7zqaUdx2SXXswxEJArqWLu6dfCnvUHdjtMuGSbDXBpQoO1k7LlzSnWP/KITTyPN+9k0Et52doUpiTpj7oPO+vvq7Qzr0hfRmQ0XQG4GBJtm0QQuHgumfd0NVbZGL5XD1zsa5SJrJzyVn1Rb7czV6DMybyOVq9KcMzj38qFmuEfM/2O7uO6aRxER8MY4z4IEAErE8HRBP+7wfoLnWlNTRoOzOCrFDcyOLCT05q4VwN6yg3iY0U2E9nXhU5ZtsabqqT6LjobHsK/NlTAIVzAzotKLtD58jJEQcedB0B5nJPHETevfZcM765u6np1kncDTxel65FZinQY3PahGy7obCr8AyYd8UU3LdwmbN9uchsJt+j6luGr1k/ouqmfru1h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,
> On Fri 12-12-25 16:18:32, Yeoreum Yun wrote:
> > linear_map_split_to_ptes() and __kpti_install_ng_mappings()
> > are called as callback of stop_machine().
> > That means these functions context are preemption disabled.
> >
> > Unfortunately, under PREEMPT_RT, the pagetable_alloc() or
> > __get_free_pages() couldn't be called in this context
> > since spin lock that becomes sleepable on RT,
> > potentially causing a sleep during page allocation.
> >
> > To address this, pagetable_alloc_nolock().
>
> As you cannot tolerate allocation failure and this is pretty much
> permanent allocation (AFAIU) why don't you use a static allocation?

Because of when bbl2_noabort is supported, that pages doesn't need to.
If static alloc, that would be a waste in the system where bbl2_noabort
is supported.

When I tested, these extra pages are more than 40 in my FVP.
So, it would be better dynamic allocation and I think since it's quite a
early time, it's probably not failed that's why former code runs as it
is.

--
Sincerely,
Yeoreum Yun

