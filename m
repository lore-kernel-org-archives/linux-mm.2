Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5D0C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B8F6B007B; Mon,  3 Aug 2026 14:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C5F6B0088; Mon,  3 Aug 2026 14:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6165A6B008A; Mon,  3 Aug 2026 14:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36F3D6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:39:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7459C07B9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:39:08 +0000 (UTC)
X-FDA: 85060820376.21.F17F5A3
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010016.outbound.protection.outlook.com [52.101.84.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 92E7620007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:39:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HM0sdJhY;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HM0sdJhY;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.84.16 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785782345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DS219i8vZ2gEEaKoWVF+TZdPx34WAJSccLR7gpUpijU=;
	b=Vc6DaBy+0QvQwI9BxeLjikC8Vwd1rALJG5G3PgQpp4oMx9yGvsNX8fFqCoBAsvAbQ0GcG0
	N4CTV3A2hCb3Lm+Zkh9VPxELmDp7PwoQiaonJmf5W3Fi1hZ3GWtsQkDaTZpbqtGu1+pF6I
	G0vvBLxjjTS9kxR/ja8SToX++61uFg4=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HM0sdJhY;
	dkim=pass header.d=arm.com header.s=selector1 header.b=HM0sdJhY;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.84.16 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785782345;
	b=lDMYchepe5gu5DUmb6vm6Qt0Q/F4RNnIkvxdsYeOGYzSIC+Ru0CbmHTSCc5VoOJre0G0Lk
	CYC/2d4lAy3ou5NLmNJJCNXmMDrK4h3cHJACwqoojNZsCy9Mu2CMRFTigmDvEbnhXOury3
	pMo6F0B4wot7N+Hu2gbg2u0becu4iHs=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=prBMJgTmrOa6UMUzKY1LtOixnvZrq+o7+hsi+DwlVsyYzMCH3xEqMQajukaVx/nQTHj2X0UMrANtLOpm3YJ4QdzsdR+Kli96zTqbMOECmI0WX5IgUpabjfPMCbaRvfDSnYXqxS+mWPbpplQorpT8lJHWWIzWSQ3R4yRac6xdRNykpMCSkh4ZBYv6QgpwCTCmoas9iB3wXkTtyzfOXPIcMIb8t0JRQFH8b5VpjG3JouMMEvcX+gOLqep2GbqA9CuIixBh4F2V57jf+9g0lfHAXVnwR8AHbOtYvs5AdHyor6qlWBvGDG+ItHSIaCXDaPUouD2CEyBSGS8yWz/b9zxkDQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DS219i8vZ2gEEaKoWVF+TZdPx34WAJSccLR7gpUpijU=;
 b=fabJLG/WxvLonH0fU6LHbFg1BXiDdDBLXsjTYPZJ4FyBXIskmMePl/vGpZ8+vg7/MTL8WFqvO8ben1yCX3M/o6RlGGmUfQk1HgbZAC9jmVnYtgTVT33+4yn6+Os+bKq8pWoxqEq3PJDRurRnjmPIClb2gHX+qb1r4/htzQo/4M0id/ZpkvRLc9qYntsmeEn8oetVqfXGf6xzMFyG9QzvSxqb2M6oQH6mHP0M5Zz+bO8sLTghsFQBG+vZoARRAs8JXOYhePCI7ePVgAUotqcxk3xjQaFQxal5iT1MRnezaoOc+2tw7dUedsphCzSLq1FcbBJejhc7VDN0NTjrG1QnEg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS219i8vZ2gEEaKoWVF+TZdPx34WAJSccLR7gpUpijU=;
 b=HM0sdJhYecJCfUy9+jB6u8DCftwSpKWJa3geObD7WsrZTFMdp+zNZo0J1X5oOCTtVzriqJH54w2bzHbqExo5l1PV3OZFGzXlCX1bG2PQRBQAxiedLMEt4XiHt3woAKUQue5emBbSXMjSkxgFau7dBme6PwwQPMgZ33obYZ0fdwA=
Received: from AS4P189CA0005.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::20)
 by DB4PR08MB9357.eurprd08.prod.outlook.com (2603:10a6:10:3f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 18:38:56 +0000
Received: from DB5PEPF00014B88.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::63) by AS4P189CA0005.outlook.office365.com
 (2603:10a6:20b:5d7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 18:38:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B88.mail.protection.outlook.com (10.167.8.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 18:38:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NXI+RTGyQJWVbRbmJN+BN+kDc6e6v7PaPnMQMeTKeWsLEQp3JmFNZ/S41cQ1oDNrMiOj9VxWf0FWK9HLfRGP31C5uSvUz3YV0i8Z8en50KqdU897LLL/kDTWGwFHXf0RIbeO21DM9rovD30G8vb+McCGKZE2R4i1oPaidWNiLlLaITIcErrxrvOS3giS9O3/EWYlX8ILEEiPRGr9ukuXJ+CUyeMAQGhWE5b76fqLsTLv3tbjG8ukttfWuh5CujyS8egs6BpKmQjxwkS9G+dvKl2DMWukDhO11qsoP+GBZ82ud8zzBRKZASh75JU+tApQsnAMhg52e+2grJ0Q38Xqow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DS219i8vZ2gEEaKoWVF+TZdPx34WAJSccLR7gpUpijU=;
 b=UyyJ8A+vFVL1KhMr4tC7SFnWoUtLHp03c86r7AQ95GtKWHNAJy+C8hup3+DohmKhJVEOW2MLIZW9nV9PHabW1SThKOtd2UhF9Tkwxa2soCnWBBYjZSvwRAElmdPgFjvVKYD2d6Xa7k3J+gVhIoRsPMDxl9vnTkia27hXBLT5qneGlYFrhnnMoBQYfJsmm1++m3XdgM8AutOHGVT9VvVyBZtSBflK/96YUhwSSwjVSnuqvlUNrYq+S8IsunNx3jclJIBYzYcNSOrnFx47sYtU91iIvtE5qk5OO6nfd59XSvcBJqJuy+nq/nyscPSGsICnBq2dkNQbjjzi2vTjh4JnUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS219i8vZ2gEEaKoWVF+TZdPx34WAJSccLR7gpUpijU=;
 b=HM0sdJhYecJCfUy9+jB6u8DCftwSpKWJa3geObD7WsrZTFMdp+zNZo0J1X5oOCTtVzriqJH54w2bzHbqExo5l1PV3OZFGzXlCX1bG2PQRBQAxiedLMEt4XiHt3woAKUQue5emBbSXMjSkxgFau7dBme6PwwQPMgZ33obYZ0fdwA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AM9PR08MB5938.eurprd08.prod.outlook.com (2603:10a6:20b:2da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 18:38:22 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.012; Mon, 3 Aug 2026
 18:38:21 +0000
Message-ID: <70c5d9de-0f04-4ddb-af53-16599c8c0988@arm.com>
Date: Mon, 3 Aug 2026 19:38:19 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] mm: add basic PTE const type-safety
To: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260803164400.531199-1-pfalcato@suse.de>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0445.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::18) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AM9PR08MB5938:EE_|DB5PEPF00014B88:EE_|DB4PR08MB9357:EE_
X-MS-Office365-Filtering-Correlation-Id: a9cd9005-6e52-420f-e8c0-08def18e7987
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|6133799003|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 +jvJl+aVMq1P5LJz03q71WnOA8m61GPLxkMMwzV+oa9+pamGS02Q9KvC1YOC7cKdCT2RSk4dVfkmzi7mKTcJHPKHvUiV3dgkTBDu0kDN1uJbrAiP7Lzqcj6DGME8X1SCc3VRhBIjgemdEW1EKVaYAtVl9N86UjFFZjrgFZJs1ihWE0awRRvZXJic+40tdjC2FqpBFuWYcap8yNiw3u9RZnMoXjZem9cMjaReqZIwEiLVLl+uRMI6AaYEtwEryjFiI3RChyfWfJ9dbBSRuu65YUhZEZ1fTWmsdIr1ISCuE3QkL/Pe1hZPrkQL4ffiISF53QT06BejAAB1AmXhV42uii2XBitVcHn4BmzyUYcZahS4jPwbkNiYw1RkFb4ctuDZiNcg5RuAkum0cz8jLUcVMAa8vZ77/B5UkjDCRupME/l/ZbciGIkgYK3IYMk+A+vxm5J3SdpYZdyq9KecNoPWtKpyGNZB/O2mFXgYF9NCSm/lb9mkUeHFg8H/mkQHYNWFYxNGywmwReZgeHm7tkmiehzl381CWLZlPKHn6w6RyjWqW2VEEwpvIgvIIsl7hObj8Jy6HKxjQnpOP43l+Q+YOvpSPrYbdi0BzJb+m0Ptk3+FxzEtn16Z+rqh32I6Vyn5knMTDqoQl+hQVZGWR9Bo0JuyCFwwRhXm+H2JY3Nc6m8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 sDj3CWXosvv8WNcb74My1jl9jX25o12bEcuWn09C6btseYFINc07nf67c1SWPuuM5ZUdk83BTi1AtQVPNIeBRJpX88+xnod/JqnQRUN8VptUGwt7fzlwYKMqY0r8bVY+7YM8qHZBOH+J2kFtyHxXSc0HWmH+Nfeu7tLcGE+/FnebQWKv38l0rROY/1i3cy8z5OslUs4L7jkaWRNLUXclnhQ69AwMzIZdqksoIyxCGXsU4qnf99yEilYrGtN0fiyhLFg4sHUUN2/PPgtc4VoEdANFC+YXR680J0iVe7hZCIsBl6HgXnz6BLSq+2F8Cz0ET/CSSyqeNZ2fISb0cCjCEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5938
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0d4e808b-00d0-4431-4015-08def18e64dc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|35042699022|376014|7416014|14060799003|36860700016|82310400026|1800799024|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FjkiJH4tlI/X/z0xahFMH9tfPE21Hmfh9E2nS+/iFBGFq/sNrMZPuwb/uZownsw28nhZThIcvn6UpCpAbY83P0MLWnUOHDatLAvOn9HSbqFCGfJe/AMjPNIQRY5YG7JYEEPBKbBLjzUnCwUK3oYRmS1kKbBwPwbCrot8W0b2I34X8p77ng+ewBbw7THjbSTRM8Ij2LlU3GCztPyR5f4NSo+dUFDBuKVqsIJWOl74ZC+IdAiVYTYW0HiJnzPRpk5A/i7sFhRLtx9SpDl/RoE2Umv1oe85mKdyJsHqU6dMqwmNMku5884UW5P05a2HVYYVe290PODkURzJ5zK5GULEixer7Mg65iqMizV2ZoNu+akdXAhGOzz4foAS7GhUVFI77g6ckxJMP24DX1LesQZ3N2B84ltXDvJGY4zugwjzZd8JRTh9k/g3cQr91q47X7F7qfy/0Ff121fP3oaAP6K6ne4saO/bqT+Rcd1gkao/YqUfucaEwCEZLK8+lNwDSZs6k1VE8c6k+CrmAd2lYkRG9eBPhNcTOPKcTDECdkv8V6b6+pOGEKfMDy4yIIF5Ak5V3+B7WDYQWjLfCfdCj5pXjxnqVcC39CSdFW62oo6tqNarvTVXtniOrE9YEmkQHaFMqNiS4DTtp8WZQb70QJQSP6KqqpZHvE5LcfDwg6jhYwW3jaaGP6EOY7tpFqa1HKvMTb6Qq3JHo3r7Qi1+GkvFRA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(35042699022)(376014)(7416014)(14060799003)(36860700016)(82310400026)(1800799024)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OrutTkQ7F1TUY6sIpdJLIv9bJcG6L6DJd/qpcnhRZJKoL+2bd8oP37dOhIuSiPzni3612a8Drr9uEH+NNrYjozxIa1VIC1DZBSjyufH11sXERYTd4wxLd4LTFzzkGkjfk8BKQaOwxeE+k+BG8IoU8CEp4AkSXQX15Lr10zp7cviVo08pqzbz91sZhrTPpEOmlKXyrbT7gRwEsTu/jakIEX5/LKXUNiSq2wYunPIf+t97d1exyJBmiJJal+p19IOroktD5/dEgMbx/YXcR30+R9mCcKQDz/WKanUEE3cPEldN1FAYXU4gSFCdXMrDNgNmNikZuaVzd8+pWQzJNLxRHPO+rMA3Mku8SLj/FLmdLdevzEyVh9/8msfFrKfRNOKKvvZelvbICFNy/slAyGqAai5W6TXlNgZi/cWLA/GPg527oBfnzycxxjVl8TEQ1n/l
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 18:38:55.8772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cd9005-6e52-420f-e8c0-08def18e7987
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9357
X-Rspam-User: 
X-Rspamd-Queue-Id: 92E7620007
X-Rspamd-Server: rspam01
X-Stat-Signature: ar6h3opzrb7hmxawhq4cmbzpk6z56i9o
X-HE-Tag: 1785782344-890265
X-HE-Meta: U2FsdGVkX1/dKrTeOR04fj4Op4M+vIU4xpAyOpuX1MbQW7LiTzs6kIEFzjLELkEk/AwFU6iQAaSWkB2zSQzxdezayVahbSj6VQGbw43SJ0LVxrL4MycXLgj6gXh3RfEhfFuJGZuNciY/nYHpSuoPjRiMAqYsR533/QUuxN5IhCScLJauyWxBlSCE87cfSAFhddSJYiVE3XHZ/ppi/t9A9iHUeKmmXfo3tmAIwVsMAnM/3eeC6XJq3cy/PBgdQvpXaC3gNiISAZ6VZ02rqw+4NAhi1x6AU854T3FUmz8O97TV3HHVHRqPIbVjXfyv8yGGwcxUDHQF3v+onw2SG7nx/o3Jr6polgJAW2AjeOs/ff+XvZkGbQSQyUWI5wjMzulsKpc2KJwwTQ/MyF8IZZ9ZwogeHRF+TEXKljTT/Uuri2ndsAqHlssgPhbpRIqSOw9iptTta0aWlTr49XrPgxA3hrjgdNbi54NEVDXXoJxM5P1U2gSyiFehhBi//QFnFIl0thA3tvFsDmC823LXaFlPFGoFrk54p2PpfCwNZ+FSH3hfH47YwHbkmPybYtSk1/bb0L9VU1zV96IIbHr1FzU7rd5wpI9aIzFsAm8CAoirCn0MD9eEXBlSmRcwe5EDsumZwYLXp0r6AspnZEb3WA93xx96K0leIRuMMOr4SQKvwlRmHMFoubB5/MX2uHSF4c+8VVHiaZnqb4ImA6w8xH4XPSEAtsCqPvASXMKvBIXi9s4dHy3bX1ZJ9Fcc8lSYSDMjzjJ4SVI9IPadv30rgC0jp9lLPLWaAF8XxPzjZetRB/y682CzGmueM6FaJKtXo7R1OwhxQe0VZhZKFJ6qsgsvK91hhcmfQurSCexnuM3tVksrN6xMU+OLpdQWYoTr1TTzLCH1Dj02p+262ZicaQUwcnrjTC3pDyJbG5CFCOngI1d8XhljzvhMW0RnBSBJmab/stc//4Jjui391/Xl4JB
 UIst3Q4x
 Qm3qP8ijHqvO1oqmGvS849r54+Rngl550RVo2zLvAP2Kc1httrYhBujTf7V+crN51/qeApdAODPUk4tT5Oa9z1XHvSPDZXe6TUXHJnQJ197P51ON9mBXkSv5dfy858IASNyPvB4+u/RpcQ0xRouLbRI19PPI++4SYSWZTpWiJHq3rPJMuv6oOMH3yoltY8LIF5/OLCzWKSJqKjtyziObp10ttTY0vomIBra6I0yGrIH95srZMDrnSai+X4IrOGnZD9Z95Edbkh8yCXo49wkN93DblYiprS6BvC/C154vn+QNXnCDHDUtBfKUx1kryq1JP5KepYIkoIEpmh8bORJYxfBvll94pfXSv09UgY3CR7ME2XiznyNSdjHOEa20ktwCmi9KdEdCkX0OrTxvmg97mW+8TeedN8h3+BMadj5pAyyC2RrFhtqoHOfDAwoTcCdomC2gxqM+kAmNNNvsI1wbebuCP12qzMjaaYjF9G0xpGqExZ/q16AV0sRiAcnwQIGtOOITTm6W0m+IqlEwzVPN02TAHceszuegFX7SIvYohFqx+Tn4uCA+iRfmxV1k3FJEMfT9sde4AJn6lWW5IhA1cSlPjrNLFzjptZPcRQZeUnhiOaVzHMsaFJdmhvd+RAhzq8L5e3A8MfxIeisX4JIV5D7bKH0LbI2fWlPgXMaFbVzNBRBdo+sFfKQUpnEkW1Mkf7P+Ufv2jrkzI+FmQhicS0evvp3LbkWzn6X5fycDRhiVuiwXCmhUZARXDEpsGdJSowA7cLbyZu/dTFzB9Gb10GBP88MJaRgqoyogcin3xVKfH0fD2FDMeMD4c5FoPpSgxX9lcg+Bar6u0rZ8MbCmLZ4vywG1uUXzOgkrI1EIi4sloO5T7bjTd6WRZBvx7WxxPgoOBB8+yHMEKUUOdmPb/8uf6IkRRGLcoSZemg/x8E7JYIl9lxDA46MsqMWVdlAvzlekcHwawZLhtKyWAN9mkErO75imR
 8DL6Jql/
 GOf6/0MYxtrdPBM4TxOa+z8oi83a7vTYhokyC4IaoAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/08/2026 5:43 pm, Pedro Falcato wrote:
> Since forever, MM code has thrown pte_t * around with no concern for const
> safety, or typesafety of any kind. This is confusing. Attempt to address it
> by:
> 1) Making sure pte_get*() helpers can cope with const pte_t * arguments
> 2) Constifying the pte_offset_map_ro_nolock() return type, which by definition
> already pledges that users will not write to it.
> 
> These two simple steps were already able to uncover code smell from
> khugepaged + do_swap_page().
> 
> Separate steps could include introducing pte_offset_map_ro_lock() for more
> widespread usage of this.
> 
> Benefits of this include less confusion and better type-safety. It could also
> futurely aid in efforts such as [0] which may want semantic annotation of these
> accesses.
> 
> Based on mm-unstable and compile-tested on a handful of architectures.
> 
> No functional changes intended.
I've reviewed the entire series. Hence:

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

> 
> [CC list editorially trimmed for brevity reasons; apologies if you're not on it]
> 
> Link: https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-0-eaaacdacc67c@arm.com/#t [0]
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> 
> v2:
>  - Small fixups on the arm64 side
>  - Re-order patches in a way such that bisection is preserved
>  - Pick up Helge's patch dropping parisc ptep_get()
>  - Constify s390's ptep_get() as well
> 
> Helge Deller (1):
>   parisc: Drop own implementations for ptep_get() and
>     ptep_test_and_clear_young()
> 
> Pedro Falcato (5):
>   mm/arm64: constify pte_get*() and contpte get logic
>   mm/powerpc/8xx: constify ptep_get() argument
>   mm/s390: constify ptep_get() argument
>   mm: constify generic pte_get*()
>   mm: constify the pte_offset_map_ro_nolock() return value
> 
>  arch/arm64/include/asm/pgtable.h             | 10 +++++-----
>  arch/arm64/mm/contpte.c                      | 11 ++++++++---
>  arch/parisc/include/asm/pgtable.h            | 20 --------------------
>  arch/powerpc/include/asm/nohash/32/pte-8xx.h |  2 +-
>  arch/powerpc/mm/pgtable.c                    |  2 +-
>  arch/s390/include/asm/pgtable.h              |  2 +-
>  include/linux/mm.h                           |  4 ++--
>  include/linux/pgtable.h                      |  8 ++++----
>  mm/filemap.c                                 |  2 +-
>  mm/khugepaged.c                              |  2 +-
>  mm/pgtable-generic.c                         |  4 ++--
>  11 files changed, 26 insertions(+), 41 deletions(-)
> 

-- 
Thanks,
Usama


