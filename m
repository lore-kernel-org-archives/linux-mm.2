Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E82ACD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25506B0005; Fri, 29 May 2026 01:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD5D6B0088; Fri, 29 May 2026 01:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBD86B008A; Fri, 29 May 2026 01:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF5206B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:58:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FCA9C1FE1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:58:25 +0000 (UTC)
X-FDA: 84819402570.24.6FD5578
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011065.outbound.protection.outlook.com [52.101.70.65])
	by imf21.hostedemail.com (Postfix) with ESMTP id 827A71C0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:58:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qCwavqjh;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qCwavqjh;
	spf=pass (imf21.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.65 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780034301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6gUJQF1z7miW2hZuGtbuy5c/PH1YUxkG69YDL2dfb4=;
	b=PDBSTZRQ80BRWzH6VwUrM1cDbDj8WRrdbNdvahxU3/01ELPvbRuJqqU5nrZxubA2E5gOON
	cBQnfJTgbmo5tisbX6mk1yfCmovUyTlwnwvOEVl8KqW9RXXmsVKGdy5SXueMGQxVeXtPiA
	X/yZk0RJBqUqhbqSH6p7eoZgSiU7T0g=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qCwavqjh;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qCwavqjh;
	spf=pass (imf21.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.65 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1780034301; a=rsa-sha256;
	cv=pass;
	b=c0tSt6xguoEzAzWE3KehR/axrDvQQKQzOFGj6U0kTfbyhsbLL/LnVUi2ZHaUhHqLZeGH3c
	+a4M154EsZ4p65PmyRw6dFgftryZempwiAKmRJFNpw/NeQrZnponrSTc7dD4gaAfqWK8Ef
	3xpgYLAtI6ZPNsEoNuCr6a7VIsUg0AQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nqi5mvy9sxmeFOU/eYbJt/G9Ialz9btXu2gyNCnDJdNwbyqDBB1Mh8a74ZDpHukSdkZri94iCLk64WRWov3v2SJZn1S24hsKJU58kdDwvQWe6utxLlyunV1Hy7zG120JTBZTShq9e0RNJa+pGKRiwrOXttNA5emzoNN9zcwpgF/SH9Mm7xdV3kCgouVSpqnVh4LsUtK/GmrHfVB/8DTkKvDZ0qdN942/RaF3m5UIOa2oN0SJtTd3vce3frjkJ7EE36euIgvTJp3T1/Oy/CzDKh08wmjhJcwDFRs4TgEeVn/gqVfw7v/nucTqEEZrJLiUsaMln17EZbW5F/sctVWtEA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6gUJQF1z7miW2hZuGtbuy5c/PH1YUxkG69YDL2dfb4=;
 b=qtXxQS3QWeACDIeWMjQ7oyQ4E5/BZIuGKwYKPANhA9YUglczx/XPgAejXqj3WzTKQSlNsv/Ahd9dFM9zG56Sb3+5PzDO5aiJ+yKmNL4UCfWSBXZtf4JcQfJdmrNzfHKfr9UlxBGqTmex/rnC4AwHBgq1N8ZR7rv/F/dGbgcZlFd2o2teDtKQDiUaOy/RG9nU5kdOP+qMB59j8B/lnURwSFqauYxV0KOCPCk/gcF9RdQfGzHUztYu+sVBSz4eg/IS0i5vG2jbKjFvzJLqthKYUIXhE/4RnhYLYExIctQJmq0cZ1Rymf0TYkd+JKa8h8Igz78tT/wUvuO+45ZaYhzxFA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6gUJQF1z7miW2hZuGtbuy5c/PH1YUxkG69YDL2dfb4=;
 b=qCwavqjhafRl1rkGkSDyN7RK1fLb7UUyMoO2oalIj2MKAZQJRHcjx2mIghcNaGhWWHYUrHjM5rTVh4p5Ckd54lavq6I8F6Y5u26mDRlOWuJZ5iiXX2HXiYtZlnlNgewUzsrZoXD011gVFBaSEjk0RLqj6B88hf6klCAreL8nkYU=
Received: from DUZPR01CA0086.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::13) by VI0PR08MB11197.eurprd08.prod.outlook.com
 (2603:10a6:800:24f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 05:58:12 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::c) by DUZPR01CA0086.outlook.office365.com
 (2603:10a6:10:46a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.14 via Frontend Transport; Fri, 29
 May 2026 05:58:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.5 via
 Frontend Transport; Fri, 29 May 2026 05:58:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvjRUo77PkZRSIjjDS4+5qzUQGHqs5pXhzaa9C3s5hCpi+MQELsdgCC1kj00mQcc2/tT42Ml4KQkwtsCEFBxyOXPiwYdzcbsnIOsmFZntbXWAa44IeX88ry6uRjpyxNN+niDUUuVvnWz/LzuxQ2h5hxr1yY4MoEwJUm1MbaRq+hBEr1Fn8QIIOM3zOLRmrZb23boVC/YJQ6gJEFit5YTy9Q3dOoPDWHRKZeVZ2u0hsIkVC9MVDskF5/vE4iGoDwO31cHva16tQOCsbV1B6JXbRez4GWFVT/m/yBoSRJYzPpubK05p0aC6QJQ/HhFUranFJ7FqpqM/eXoFMIxF5uXqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6gUJQF1z7miW2hZuGtbuy5c/PH1YUxkG69YDL2dfb4=;
 b=lgnFEk9vswkxvHkH+DYRFMkOr8lJ90sy9fAH4erw0tAxIagVSnj8nmKM0w8LGq/FU3fzirbEr1RmUFn51eAvu2HgnXbqSB2N5PBdlq8OMrVehJpg0a7SeTAtPpMvoUuzyAGrzKePj+YTvHKO86i7LuVQ55P8qJ5779WoV1KdRAB+Ke7yI492d6CtuScO+2GJBQIZVXqAx7Hv5rzlgBYR345LZrFIQqXGsdn9k67ieppFR4011sxqhlkhlpumLQlKpnvw/g2fHfmnHsjRcjvP1eWgIiVWYqO7cZfWO5WiqPGPXhEA0ZGVdBjf4V+ukZcVGqlbcsc4a0vGfkcL2e3oZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6gUJQF1z7miW2hZuGtbuy5c/PH1YUxkG69YDL2dfb4=;
 b=qCwavqjhafRl1rkGkSDyN7RK1fLb7UUyMoO2oalIj2MKAZQJRHcjx2mIghcNaGhWWHYUrHjM5rTVh4p5Ckd54lavq6I8F6Y5u26mDRlOWuJZ5iiXX2HXiYtZlnlNgewUzsrZoXD011gVFBaSEjk0RLqj6B88hf6klCAreL8nkYU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AM8PR08MB6418.eurprd08.prod.outlook.com (2603:10a6:20b:360::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 05:57:09 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 05:57:08 +0000
Message-ID: <3b4176f4-e099-490c-a5e2-6a36d00b1207@arm.com>
Date: Fri, 29 May 2026 11:27:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527114752.cf4dd3e1bda93fb8ebab5a76@linux-foundation.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260527114752.cf4dd3e1bda93fb8ebab5a76@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0194.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b2::7) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AM8PR08MB6418:EE_|DU6PEPF00009523:EE_|VI0PR08MB11197:EE_
X-MS-Office365-Filtering-Correlation-Id: b7393b03-4e1c-4a2f-3e37-08debd47445c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|4143699003|6133799003|11063799006|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 sLloh4YvfIYx2+f5nUTWrM9gjgwXTfwLD4an202+ea2cnYANTt4nkGykmVP4VPHLVE/B7jyYhNe9NC/wRnw2fTayETSBidqYCO/ct6JfzQp7tFYY/pRS3jDMuq4THSSm2AI1AeeG4MLBlPmma4mZQfllf2nu0vUE9PF2+0NQBTthh2YvIvBVvdIVzG/NzO0U2Itok9zGniRfSp5WWbz/l0PABGZN3Wod9zENUgUSbZOn671r8JvnanERTRpa8VXAJFQViWt1JRo02IvRRukDQAafrIGR6MAvRCnLyVYrQ9zGKQFz+JnmPm9QbwsNlsWY/IGc0PGbhIoPNcOUuPkwra/eDZSi72bpjyL0PnILgJ4EgFPi+d7Fc2Zc46kr0vWh9VQFXqG2NC2fq5i6SQKeMntk6N3Z1zmQTpo8j8Nyz1WS0HN5CGJS5ijMb5i19mxmfXKEleYOxIWUFy1O+j9id2P65ewPCuXpE1W/klvemkgtUcWqEjBEvslOIBMgknA6NLXDGJMEgoVe0t4B9JWwbl3HUcybISgGQa8v5uH295Oo+Ji/aWWYAMMYD1NRMoTvpNAB3GI47l4kA0KXqT8STIP/VShZ0BfwkY/zm/+6ZTzFo/WUSdul3mahThmzkAD7WEtasiEnKFngYX7OxXEEdg==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(4143699003)(6133799003)(11063799006)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 cEz9K6Sh6MHrlyFZsJQ1Wx4joO8zIkAaUHhf80/HO5jGyAKIRZDyhkbVwE90xV7rePlsJa53qJbg+oA94Sf//UIGVUNBOGpRhfaUeYRdfjpP+iZ64m9RFpZzj0dBkpnzHaxd16t/t9VuuBGbrlbZr8GEUFvE3mX533cX5BURkcKJLwVUpb7jOUSGpk1jpfh/2ZOcZelRkmKbThmFXPci+m2Y+F40Ozp03DVYqPWDAx7Ublz37IAaP7MlmPXt9shd4NOlBbqq2Sd+7GxIDJGMoZeN5xL5TVmi0yD6I3lFpMilAqqmNQYGQGtKJcjvHz0OIUaLyv6t3pBXyp61YOdFDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6418
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1bb7eade-5dd3-4854-08f5-08debd471e45
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|35042699022|14060799003|36860700016|6133799003|56012099006|4143699003|5023799004|11063799006|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	AQeq/EAjP2mUTh4Wzr5QxlZqPSPoFSWN4ZlD1o7vSCFxO9EIS/sUBv+qu6yWnJXfeXb8xzmKKYEmE95udn6inAWBQLxKdiBelmpjAu9SUKKpL+zj1XBBxKxJqj5Vtbo1zrfPWgePp5uctFxbtYIc2xhQ+0ZizJNYJvpOzgAnJMWfLP57blq78C0kf029JSCKewvn3sNvQDbhtXThAKPVA/GwiKjPFlNekEmSN97Az+lAvTR+i19qUvxtMuEtug+LJJmVTFqmBX9q2o+SMarHJYipHGryHatedTdlBzYJRdkHcoHql8retwQ86m0ZufG5A44dqu+yr4n9sEIKm7AAxAhy/8Q5Y1JWhYCf+ey8ciQ39wQBc3UZcnVVbdvK4/EyOIA2W0zmOceVKNo8HoT2czKSK33QwY0krXAC89yQ5X4IFlIUGaBBrrY2vxSZPdwwxI3a1BckSaaiYnPzhMPE+mJmNvreailE+XV9U5/ZeEr+thT4Q/vk2stOQGyroABxpkxe1GaSiyGi+w53UA5lGdbegDaBVs/cJsXP/d935gASfx3ZFSaF2yn3H9nvF+zmDQ351b6s49eM0QCdOXzKBl1TQ9dGtd5yMMqcLDt3TwNmUecvLlJ0mTQy3ihai0tX1HYi1NT6ISardi1Xc3BMjzlJ31TG+0nblPJeQBnP6jdm8T47FYlpnHxpPDfl1SJJ
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(35042699022)(14060799003)(36860700016)(6133799003)(56012099006)(4143699003)(5023799004)(11063799006)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H3sWLSji2/o7fLdKJqpyroQq6FPw/4LiBmTNQbNJhHf+zTnHpzW6ikeWHSHQTyL8ZxlC37krzX96tQ0wEFHSItkQhcFGex/f6FmI1rGfGNzHuAiEynzdi25lQ4ULj3X0OkWzOZe0l/8VBp8JmV6FHtP+zpgNbXmR1+a0Eb+ANmMMz3DMKorPkLh6xfmkB42FdXWhNahBhqCazcEW93SfbAbqneuxFbfhoi4kQyksDmGZfLlRvMDWOIWThwA4V5n0TBsYjWm7ouUj5YXtK+0P0/XK0NsV4fZb8/lY6k/ps0Fcft2Q7stEr87FMTDXIrBQGwKhecPNsT+WqZEhk1OftUX8+xrhyOrxoarI11j28GWyZr8b2Yvq+ACho1ggLip0+b+UiGyUKfE4ipkSwDyy3MZckJpq68C3fc6DoniOiO3R1cYZ2Z0qLLFUjbtt/PYu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 05:58:11.9436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7393b03-4e1c-4a2f-3e37-08debd47445c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11197
X-Rspamd-Server: rspam12
X-Stat-Signature: 4cd9y6z5ek89scrqxhnrocg8wjw3e6p1
X-Rspam-User: 
X-Rspamd-Queue-Id: 827A71C0007
X-HE-Tag: 1780034301-281510
X-HE-Meta: U2FsdGVkX1+I876U2aIsQ/DwoWzIhT6Xe9I3aZZAbtYt0y4vRjnI+87W6TfZbDyr9yH76u2OY7WoJMNxQSQci+T0nvLM2iBjFMJtb1FbpvF40R6AoM28PHMaLtyELgjkT6lgj1pyqyfWSuzPxj0Pc9L/ChJ37CMd8WytN+p193PbglXm2tlrMlHl5k2DFpdb98fkjbRt/UIF5pxnJ0lTVseOB/isIDU59uQrio0+V5P92fcZICb97TLxU3+7Z/lEaidS/6lqtv3lCmbziOUOfRLbHVjYUPg2z1Yh3wIWSN5oGWxqTPxGDLmahmH1hQGCxghOaNr0cekpPNPZ1Nzc4FPpMxBpsIOy8OF5UGCzYKat/mu4LBDZT/mUfQxWtvyb6IsBLW0K25sHiByW3tRlnGBBUngAnzCEVKC0pF4nyFA2hPZKtuSngjE2AdFnN/cdJwd4yoFWt7BDJBM9KkL05TgO/YXzZJxFtKO3da/ZTNLKIJHTyoDtjvrEVFfqnQk6Au8xOZMoSqt4XstG3h8i+rY00h1K9vnNSDTs89UF1f+MJ4hJULVZdhD4jr6lLIWeQP2FR/fV0lsmGMCIEv25R7BvVJZdwVlk1aO6/7QwH7I/d++qAgiDSn33EZFlN85EIgjSWCCzcyHkAu6KScr4t9U2MzBhWn+DEWrkQfSA1obdx/H5eKHaRLh4bePED53MkrZZta9xsEihJepR4bSnM4xXcxi97p0KxbpLFCpTnnviFukn6Czia8M26khK3j2NcwkabUDEwDpkxi1vuUmIvZdvEm/kKD321r358I+RSD8uOGWFLKjP46orDQgRaRiV1e6GtFW+YuIzpZHg8vVYg+bPWEyvHl7dek3PAQCozHRcmzRmsdoUm15T/e/8W2pkPZwOLkYruxs4hd7TSsAeEai1NMFu9ZGKW76fX30DTntyKtKE6Tz58riEsMXX5BNPV+gPSffXi6+OtPgCubv
 bVhfpp0u
 DnxF6Oqe4/EdcO3JjMSkiKi73bRRM9bVXKj6M8tbc+/P/fq59sSKVwxCOPxzbUyC5p8RSK+fH9lxui+kVBImJZXS+dv6I/U6Ce6KQej2uRaQYvljFfxkgCNsNV+0yZqJvrdQQaFk9TGfhpCI9sOwRK0LHPM+NqpKLT5I7D9rzbdAc3XoIQaBXDsNrZCpylsnYIbzcMm/rdLHvID+l6B8CIHH4W40m9FjMX1w9Flw382bZ0Aw08eDT5YLUZJ3dWImjWfGn2U9yW1OG1icPTIWN1E+U+E1+61wyfQesfBByBKCgk55UKEqIWk4xemktRk//3d9aEmBibhq+fM7vJZNRFiVGcYvoQQHZqfwdiqFond6GSuEMI9JSyvUpqkyYNq1OOL5KDsgdxlPbDDlca1eqzz1oWGFp0eYnbTgnmPzyOH0O96Bb0gyf1LtOJByNXbNuiJLjagIENjRgKNAW6PxJXdE1O999unbzuL7xo+lSK6QLkq5HOxMEBq8v93JhxeJ4XBmTy/g4M+eVMSpqcQuCddsirL5hP61NwmQ+f7w5ZDB7Gq/BeNo34u6RNykzS0GnA4dqiAXRVXsBonuksvHo77Uz3qO2CbYKehBDnqExg5VSJqsQiQZmR/9BSrvVxBCnmaZ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew!

On 5/28/26 12:17 AM, Andrew Morton wrote:
> On Wed, 27 May 2026 19:54:27 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> 
>> gup_test.c currently serves two distinct purposes: microbenchmarking
>> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
>> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
>> DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
>> tests cannot be run or reported individually and run_vmtests.sh must
>> invoke the binary multiple times with different flag combinations to
>> cover all configurations.
>>
>> This patch series separates the two concerns: tools/mm/gup_bench for
>> benchmarking and tools/testing/selftests/mm/gup_test for functional
>> testing. To avoid duplicating HugeTLB and related file helpers, the
>> series first prepares the existing file helpers for sharing, then moves
>> the common helper code to tools/lib/mm/ so it can be shared by both
>> selftests and tools/mm.
> 
> Thanks.  I'll duck this for now, see what reviewers have to say.
> 
> Sashiko still has a couple of nags.  Minor stuff, arguably ignorable.
> 	https://sashiko.dev/#/patchset/20260527142432.230127-1-sarthak.sharma@arm.com

Thanks! I went through Sashiko's review.

Both the points are valid but look very minor to me: one is a temporary
x86 build issue fixed by the next patch and the other is stricter
argument validation for -F in gup_bench.

I don't feel they require a v5 on their own. Let's wait for reviewer
feedback. If a respin is needed then I'll fold these cleanups in as well.


