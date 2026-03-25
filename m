Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2081B109C034
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899556B008A; Wed, 25 Mar 2026 12:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8709A6B008C; Wed, 25 Mar 2026 12:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EC76B0092; Wed, 25 Mar 2026 12:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 607696B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:05:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E295BA09
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:05:03 +0000 (UTC)
X-FDA: 84585059286.18.08F037E
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011066.outbound.protection.outlook.com [52.101.70.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6541140017
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:04:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WjB4pkhP;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WjB4pkhP;
	spf=pass (imf23.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.66 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774454700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zThFxzLyOJM1dPq93mY9ionKZLthRwq4TjQpB9jKlAw=;
	b=Si2aG4GwQQZX7XUHD1Ya6lOhU8xVZOJ9cZd9GsJo6KxIxm5SgYJvKOGQ0kMuD1f0G14IeR
	a1/z+FBePZ+YXyDbK/wi2V4IKGRBeHUsH4S8uwDlDIwFytIQJ8+yqhXM575xwrcyQsqx2g
	EGbz18AtCN/LJ1KOjIxP4aXk2q7bshk=
ARC-Authentication-Results: i=3;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WjB4pkhP;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WjB4pkhP;
	spf=pass (imf23.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.66 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774454700; a=rsa-sha256;
	cv=pass;
	b=JF4N+pSPMJ7B5fPtDXs4Cm8m5xMKwXZN6ZTgGCjMtdHqrUt4oucAym7AO4721M97UwQygU
	xAtrQG/txY3j59nayB4LT5hzR0q17EgSpJ9TD+RXVY4bzKGFzBdf+AyWy8Ssrj/c8WARih
	XoKcnUa4aBK2K8HYyyjeCY126ybBtdI=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NXtSnunWzNcQ8qbnpBc/pMRIse+9P/XNUUFJwDaCwbqzjnDdiJogGjqPC4A5xbqUDA/4UnZZ/1wEhOFJjcnjjHxPKSoW4K21/nLqcMNygEwgsfwehUuWc1tpJWo3KOt7yrrSP2WUBsTMBBdZDnMr6xrNHLvQFvEAiinW+ibckKwPoEEwt57l1SuKjX96Ofx5d5bLEp43tcCby/l+aV2tj1l/xu9ZJiGajbtKhIccRQXOn00xzTtMP4iaqVeiXocB9cZJvKZDu6/1JBxjTGBcICpwI4cs2nKdv4ptCqwbZWYIfSAlBff8GeKmKDEYcWcFfaaBGpffwbSJy9sQdIbGew==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zThFxzLyOJM1dPq93mY9ionKZLthRwq4TjQpB9jKlAw=;
 b=qnbCLxVQpZUH8S+8zWfNDLplVI40HAfgEMdoxSMo46sbg9rZP1R16anpxUfS5qOJakMB97MxB+LdWLeR6QS8KU1AF9ii59DsB0n7JCVTZEDPQQKVLLQg/Nzx9yiYk4qXiHc8qd5ZcTN6y3Y7F1yVBJ7kVsa6RqRpwa1rkubGS2PaiAsBnXO62aww3L7k4+XLiquIrwlJvPob8m0o8GGWlevor4EbFrJ5VBp7cvvJh4iBImGiJR9gBsk6V1bVQiixTUIfnBcVXNNopXBgOoDkDjx+4rlImcMUeRsTc9bQ67l2t9L87F8ySk5L9ODxlTWGRwBxRt2P+KCQc81tyUQomQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zThFxzLyOJM1dPq93mY9ionKZLthRwq4TjQpB9jKlAw=;
 b=WjB4pkhPao5vmpCk4cUk2KlV9g3HTE0q/nsq+y0UoJGFQJ1eTnxSQGPwnL3XqEEJ8rEzn1GnO9wYjlbykQnLdpDe2NjQXt19aYy9jPG06VA0whha5XkhVc0fU+YtW17gPCiF4aOuQqYCBy7JAcAd5RMBVuE/4gn9ehv2hfRqYzI=
Received: from CWLP265CA0375.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5e::27)
 by PAWPR08MB9892.eurprd08.prod.outlook.com (2603:10a6:102:342::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 16:04:50 +0000
Received: from AMS0EPF000001B0.eurprd05.prod.outlook.com
 (2603:10a6:401:5e:cafe::1) by CWLP265CA0375.outlook.office365.com
 (2603:10a6:401:5e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.32 via Frontend Transport; Wed,
 25 Mar 2026 16:04:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B0.mail.protection.outlook.com (10.167.16.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 25 Mar 2026 16:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfB8UWO+gb2J+OrGqWddVrU+2NmF80i7HeZpF+ox7o8yEo8vhWfNEAbdOQpNHFxstI316SjznZXt9uevUJeighQa9EIW9FhT3V95gw/OO6LnoW6rmhPneCpxXQgU1UpQqZd49T9sFdnCeLCcv+k9deSSCOG6PGN/QuoU7t3UGyPpXGVMP55g2F14FRFng6FzcDusu64WAnEw0UNMQomtxaC+WtRSM6T2PtYVGF56CQBzNTNh8bB/i09m6R6n72gl4QqpYkjK+KBtV0rra8/8OzJi7J+dgAkosjBfWWxs9mdbdxdmct/dsGKWK104HU/x6r+jm6IUbAbEYrRXN/15Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zThFxzLyOJM1dPq93mY9ionKZLthRwq4TjQpB9jKlAw=;
 b=wSUwy3rRSZ0I8kVZAIapWsze2TeQvjrh/JMErr1nAwYjAtfPIPhhcHjEa77WbjlKyq3CUUEIJk0ROGoWeaMvFzqRdyfKG9LF9tiJXgM5g/UJOqDBIKZCNRKI7AQk7nwOKwYRSGsvpPgcqJY2pkflKAHW6V7Pqf0vl9SBIjcbxNvEtcx4q4JW9crX8Eiswy4wXCu2eyFKibKEj1cVfCpsVLP5xHkO/gvIvh7d8H1VQNtshEktEOQbzlIOmZm6bfz/9HRAHTCCJ8OsfIe+cLMDHqwNvyBsfInlsqePsMVuWZzu5GKtgXlRgnEEEw520N89tdFniXFFyU4yJmVnu8cUIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zThFxzLyOJM1dPq93mY9ionKZLthRwq4TjQpB9jKlAw=;
 b=WjB4pkhPao5vmpCk4cUk2KlV9g3HTE0q/nsq+y0UoJGFQJ1eTnxSQGPwnL3XqEEJ8rEzn1GnO9wYjlbykQnLdpDe2NjQXt19aYy9jPG06VA0whha5XkhVc0fU+YtW17gPCiF4aOuQqYCBy7JAcAd5RMBVuE/4gn9ehv2hfRqYzI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DB9PR08MB6362.eurprd08.prod.outlook.com (2603:10a6:10:25a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 16:03:47 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Wed, 25 Mar 2026
 16:03:47 +0000
Message-ID: <9cf2198b-71f2-4653-8b6e-62e635757a4b@arm.com>
Date: Wed, 25 Mar 2026 16:03:45 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
Subject: Re: [PATCH v3 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-4-usama.anjum@arm.com>
 <309C0716-A53B-422D-ABDE-E865DE0473BB@nvidia.com>
 <4ca68533-9abf-4d54-ba15-5ab9bc3ed0dc@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <4ca68533-9abf-4d54-ba15-5ab9bc3ed0dc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0437.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37d::19) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DB9PR08MB6362:EE_|AMS0EPF000001B0:EE_|PAWPR08MB9892:EE_
X-MS-Office365-Filtering-Correlation-Id: f38af18e-a4dc-4d8e-8e7d-08de8a883e53
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 5kM4BhYAcdEW8yEJN/+pAE3u8lECftCF8lKzZEwH6kcIZ9qn1YyFBCcbc01t1p04iPulLEcC1o/V0tAjdYn/JzKaL2lS4TBl5M198KWiWyVVhVD+88LpPSTvmd6RFsfsfN+X+0x+DcRVk3pGHiLfXr291UiN67pWDWRjKzeAKd47UlNbjkoVhI1JFmlxOotz5HAKsil1fXcQ34PrsDYXXlcbAFIGJZ+A3wgA/BE8hm1nA1t3E8uDAzcsZUI1Le98bfgP2Wkwpjvw7Zftc0o7vSLE0ynI0FA87UYGaYlSD/ZBuVbtaTOPJRpcTEq6vF6ndz03dhJVhZeHzZoR4cq+4xYFeqSGLEKNPrAAeJn9iZlbs0ERSJcM+p9ZP1nfnepD9ko5p1Et+7FNqpnsN9zaXhjLyB8vrnH/WZAMzoOu/kgHFgAkpQfBCz0EtJaRvQfyBNNPYNkuIGcQH7PwMSKf7OCoRfT3gFWnHbgmM2GP7rd1nwf+QwQ1tWKmKExnbQ3WiSEG7HCqrv+O4VzWI77LVoIWMow9GlF+2RornB4DLjGnOf9aRje1qZK3winbSGY7tMB2O8sMsT0j128sZb7I160eLaw3OdghEscSLxafP/RrJkplZAApzNA8/iv1B6T+wQblBwhJvr4haJYAgAHY3/y0SUdB2xLIPlo+77tjnyiY5K2knYsoQzhf5lM386yMFgXj/GBQYBj6aHQEZUk6f/CFGIvhYnpfLM2hFDpdHoA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 C74YcyI9j5FCz+mxAvudvaYUwZwuES7sI/wGxbjlC3m04FBcUxjjQb79fC5LerjxwyEa1wiVysZxSCtzkvoN889zncm2EP5HqKpgnsq8YoyYk5FLMofvanWwbOeV0aHG3sISam1QJ7V8dt7ZPfR8coMI8Ncc8hQIAY0fdht9uFwzRCRwl1RCJcr6f2WbSX/bjNcosTXyF3EH5AKGemZBeZbnKCUv323OPU7tGhlwNk+afHrd9FdEApJZcYfRr5LFzLYWpevWziGfZkTglUK9sq+KfSHqdaJ/2vl/QFGOivRBPziQmzAQsiSfIskZysryIHTsY7OHEU2JtU3PUAYGug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6362
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B0.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	91fd863b-f0f2-47a4-f5cc-08de8a8818ca
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|36860700016|376014|35042699022|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	GELvDK1yijv7aGLrq/JEHkus1NPCbqbIuL3Vxcj9I2ADjyi6BeKH+qtjtYK+dkQiTEFASYZxiM1VQS8a3BzdO1MP5U9XBUlrNbJA5qpFn8K2MIpavnuGk44HswNk2ej67+ypXOc/V8UefCgmaohnbjzLU1D3AIci3BZ+4Yd3kt7V70D2mE0OqXKvjB79cFkNIRQWUjyHlmqQ3DLt6parcSSDfFbWoJJP3HxNYaKYr3V6PWU2feIGjPd8hDay0IUQ/37anN5CzsGl9kHVseRBXk1/+spItD4S90nTKGmb30PnguYutzflu0stKInBTXWBwIPLGVFhp5sQxVrJEkQSA4qnKgVXnSH7Auwx1b/6RcKL8i6MHlvBS2fBqL+KLPkRtHW/fGhwIINV0ESUCXip3AO/dOOxTxRAlLKlvZMNh7w9VOakm1zsvVfXRxNcSjn+1UKVT/QeJGd0vpyHQJglsAAkPPY1weSyhsvc4RQgYGHBwqskyphFSivPmRtpdjUrkZ2A9Os2j+McWRDKsA3bz2ArmpmCr8MCh9ZsPzpr/7l9YJr1u7hR+NQXxC2dq86Dfr0YWDuTPpjG9vN6q+JGFZh+vrXQwpg4sO+He0EO3Voq+y4PHy3Z4UZGsghNrhPUCpAMpY7I3Hm0dHAiOByW+g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(36860700016)(376014)(35042699022)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SGNo4RPMHXNswEH8VSKX25YjiotSXNDxmL0pm1manqpTWQoanFRMalkx7YTKLJJzNwk8LxMkLZzOyo2tshPtEY6lIQY2szd32Oi71jrHNrAqzwkQHkuDBNHDJYu9QbFaJj+4Di74cpCTHLvdcR1Doe5g5p5EHaFqmEVinUuCv/YTNvuwKsbB+6bDuOq2u23k1HRcjaV1E2yY5sa6OsXOyT1S8Td0xDqrdbf7rtVBV0ohG5tctNHOGAAPixRv6yKiDx/soNQhPRH+WhOEncZcFvW2ZpwcUQhzCKEQ+OMmnMN+qC1g3pTycbSMrGjQknlJ4GDjq5PVVSer3ZuUWcchjKL6jel0gm3jgIvSw9+wz/LhvTZIDKRrHL80+W6a6ovgCflSFu1DpGTVMHcXlaBrMf36xp1JBrX19r1CLP3YC2wpD9AGFN+/ezBGr2MzGkH9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 16:04:49.7160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f38af18e-a4dc-4d8e-8e7d-08de8a883e53
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B0.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9892
X-Rspam-User: 
X-Rspamd-Queue-Id: A6541140017
X-Stat-Signature: mm4esr468ancxs193dcnrgf9qjznbc6c
X-Rspamd-Server: rspam06
X-HE-Tag: 1774454699-209335
X-HE-Meta: U2FsdGVkX19PysBst6itmKCUjQwszpXbiUz1rFduQM8voiTkKeypqa/fqTPHwysGQo8ohc7bbwK5mTb+v7TGo/VKjnQ9ZqwtCfcgKIKggudrU7IOiX6UlDsHIdO8/sK3rvFBYCqxWO0pjkyS4/8bgZG/Nv3zMaqEcdgLR/xXBZfZboyUGDZNglwZimAc8l5mqOLFFTgpJJlGHAUK5Ivjmhc5djIsr/22s+AgBy5i1a1MDtzjjmyYblFoZ8nHbj22SGH+1hPeGXgFOxHWpxQFS1tiPCzj2Ry4NYHrfjAjB/XaETn7j6l5Bib8ICRs7amZu2Us6EcouTonCsSCXFsC0t7LJnqkS7bGElB9fMDYsbfr5aMTxA7LPyQQtfOla+twrF7YeZfucF8nSKs5iwVNP1r8euxHIjg7u9wsiJS7orH8Q2XlOw1koDmOX8hh/w77eS0vbr4RlvuT7hCxk6XLIQz5NOg9YRUBusWhF0vh3RZnVgxNVHvvEy217HrGT2X2z8u0OEGOYGsTI63pn7qlQ4s+0VrXeFjE1UG1xoM95T558nV2PY3Uo8AqLGkee4CE3ouWrLBrvEZaQDG4YzLVLtlsgoqX6ZdxDdx6RFWxgzB7nSbCutSAtgsM0Ub+AN6qkWvxuj7NmmtkUdxtSEymf9k2Y00hzsmuSBHyir2dmfZpnot1ZFe5xnHG1dP1DGiqllwTJ+CuvLSo5vhQWUx2y6oN2aX0+xySFbd3ZWm0mVdpMuyRq4Xf3HwuXWam0takI7iLixCooXZLWXARtvJAPj4FQvuN6SXtzW2dE3M7mSitrK/Qvq7lj2czPmJktobjIYXexUCtIHTgmeRFG8bDrNBAX3jNYLmtBUe70BYFscO3wMVwqPqyX9F6oFVmondMOhHECvNY19rKM8p5QQM1VD3SOKfj2CyNTLWv6s4fFC5beCq2WntTFa13PqnuZobWvDVH38CoR8PtZ1rjbyj
 CNqb8W+G
 Vz1iHE+Vpomj2Xzo61KcXLnP8m964ZxcPkQyAqXXa1K4qZqIdsycCv/cVvMAKIHu/5OlXn1nDxiVSIFh/wzGp+EGzQXIfwDi3FPIcSYlFf5LN9T/NEqC82CMqk+btMtGRnxyetY/1VKAUiGFtOzSMpn6Rg7917MzXwCYdjmUAz8eszhrtzUAxHxUWU678B6un/2rvcgqubs7zvj/YLabXiYWmIu1PDb+MmTpn1lhKBFj055JFf0TtqAwlQcmSmQbUv4L1iTd8o5scrG0FRhvjEdRCvZv5GQJjW5QTITG60n+MrnPvB+Sq72zRkPoPl5fViL6WZyXxYUXz7Hqlti9ZW6k5L1oxCCSSDAofKitHhdl/tw8l3adxggS51AE6Tz6cv5IIUOwXbow+OqE+5gPuEB3yZ08MgD2AyTWWAYxGPZqaVgqlYQ0fbcJ75ooEd8WKMxLz1c4ushE0UXErjoXs3hSBJr4eqgEgOMqvXV7Zacg1pv4lXBHM8Psz9eWuh9KYrG6jPvd6l0+iYiZ9Q/PyszBuBbtLM/nhu4hPRPYAtDoa85hfQ+HerdPmmKsJ8BE1Uw3Op9U7QEkWonsVlK/8MfbX9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<snip>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 250cc07e547b8..26eac35ef73bd 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -7038,8 +7038,30 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>>
>>>  static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>>>  {
>>> -	for (; nr_pages--; pfn++)
>>> -		free_frozen_pages(pfn_to_page(pfn), 0);
>>> +	struct page *page = pfn_to_page(pfn);
>>> +	struct page *start = NULL;
>>> +	unsigned long start_sec;
>>> +	unsigned long i;
>>> +
>>> +	for (i = 0; i < nr_pages; i++, page++) {
>>> +		if (!free_pages_prepare(page, 0)) {
>>> +			if (start) {
>>> +				free_prepared_contig_range(start, page - start);
>>> +				start = NULL;
>>> +			}
>>> +		} else if (start &&
>>> +			   memdesc_section(page->flags) != start_sec) {
>>> +			free_prepared_contig_range(start, page - start);
>>> +			start = page;
>>> +			start_sec = memdesc_section(page->flags);
>>> +		} else if (!start) {
>>> +			start = page;
>>> +			start_sec = memdesc_section(page->flags);
>>> +		}
>>> +	}
>>> +
>>> +	if (start)
>>> +		free_prepared_contig_range(start, page - start);
>>>  }
>>
>> This looks almost the same as __free_contig_range().
>>
>> Two approaches to deduplicate the code:
>>
>> 1. __free_contig_range() first does put_page_testzero()
>> on all pages and call __free_contig_frozen_range()
>> on the range, __free_contig_frozen_range() will need
>> to skip not frozen pages. It is not ideal.
> 
> Right, let's not do that.
> 
>>
>> 2. add a helper function
>> __free_contig_range_common(unsigned long pfn,
>> unsigned long nr_pages, bool is_page_frozen),
>> and
>> a. call __free_contig_range_common(..., /*is_page_frozen=*/ false)
>> in __free_contig_range(),
>> b. __free_contig_range_common(..., /*is_page_frozen=*/ true)
>> in __free_contig_frozen_range().
>>
I'm adding the common version. After the change, I'm thinking about the current functions and if
they can be simplified further:

free_contig_range()	- only calls __free_contig_range()
			- only visible with CONFIG_CONTIG_ALLOC
			- Exported as well

__free_contig_range()	- only calls __free_contig_range_common(is_frozen=false)
			- visible even without CONFIG_CONTIG_ALLOC as vfree() uses it
			- Exported as well (there is no user of this export at this time)

__free_contig_frozen_range()	- only calls __free_contig_range_common(is_frozen=true)

__free_contig_range_common()	- it does the actual work

vfree()->free_pages_bulk()	- calls __free_contig_range()

Should we remove __free_contig_range() and __free_contig_frozen_range() both entirely and
just use __free_contig_range_common() everywhere?
> 
> As long as it's an internal helper, that makes sense. I wouldn't want to
> expose the bool in the external interface.
> 
> Thanks!
> 

Thanks,
Usama



