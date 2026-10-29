Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A626D606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gYYlVPX2
Received: by kanga.kvack.org (Postfix)
	id A57116B00EF; Thu, 29 Oct 2026 03:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07B76B05B1; Thu, 29 Oct 2026 03:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAF36B05B2; Thu, 29 Oct 2026 03:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 615296B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:00:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D49881202CB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:00:07 +0000 (UTC)
X-FDA: 85374764454.29.ACB77EF
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010045.outbound.protection.outlook.com [52.101.85.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id F11FB1C0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:00:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gYYlVPX2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793257205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVhqBPiJdhGZuhd6jFROAK3ZvAO17Z4FadtOewBUeq8=;
	b=tE35j/CuL+gSyHaYsY0zYgDel1tDvtyCJijFmEtM6gtg3H0zUUZakbZYxVocq+lNZ9svfQ
	W7q8GiK3WPRSEQjbtbTd3+xHRA3aftT8BvQd06HpJHbcu/U7KJgcTv3NeLk1W4oQ03SBRo
	W7xV00MFLuSmh4zbSIV74G2T2QMYLjM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gYYlVPX2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.45 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793257205;
	b=HomttseFbLRgS/r+T47b+ss+G1Uhre1mmwuilQPLfPA5m4Hlu6hPJDV+7tAYSUEQRk7uuk
	Bu7mzuVY3GgrjS+v6z6M/6/3rmbKNQuTyJIJUXCDMbROq4u3pnstFntS4eyLtnTuZxnVQ9
	5KgbuI9DeRkQIApWPXGK27rkoGeKI14=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnC9oJxUD9SfEppyJSTm1X+soZH5P+Daw9AjfK2L8G0jAThgh5rlTyO8Xo5boXirD3n3zzQ6onzcGZoTAPd8UbhQzRAo1hrK3cInT4xNy9Lb40j1bJs1OY+qJckdDDL3pFoo/K7H4juT/3YoCPZ3cvSVUlEONYDNI6TWen2yvryPTxtgje2KeYWQA8hbTgC2vI7a8WTJtjiITkgDSgS/PtTHOw1Rt9r/jNYyc8mxWSrJfET/M/LvwvSqAAoEFJML11Dtn8U/dX0ObVZNYsjsdZMqIRSHZfJqvmseB+wywngNLbpLLFvNfHW6+18VyfEaM7S8XQAXfL3KZxhrWE2o2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVhqBPiJdhGZuhd6jFROAK3ZvAO17Z4FadtOewBUeq8=;
 b=A4VVpKIQ/MV7MCzotV9AcumXG5dxTbUD4zdqbaY3RCRWIHrvT97ZsMeQF4RXYlpJjEBEEZyC93T92DUKtF6AiYob1UcLlZcRGjUtysXrxE9vO3D7SrbCiO932BzlpMwsX6um5eB4anWkD5/5L4f6FzSO8lQdkG6TkgoUH60U9Ij+q3TdvmknAPqLEH3EM6hoJnb0MOKSWTE8/XOahpP2hM8QJ5+ZRCdQCNWeWFYmZbVMIYbTNzb1MAMzYiyMVVxLHIX2bzP/FZnEq/3nU0Dl3166Xqk0Sr01rUZeol4K8+TLc/q41OIkuctEAig1rC4it0AUYbr8OlqVfbXNC9jgLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVhqBPiJdhGZuhd6jFROAK3ZvAO17Z4FadtOewBUeq8=;
 b=gYYlVPX2YOpSlLGOYORJkLRveGbHlwsaLWy+QsoGBjPTC2vFeD4iM/McqYSR7OuDLpU9ZPXZa4thwD0qXSEV6l79OY/MhjQV5Df6mREbuzFxtg7sCa888L7w+i+v9YBnDEcOQVTvmHMcIXN5lkcp6DpEKtnChqs3PgIN8Rp09oBwELPoWFmiWjiw7qg0ho/2yE1Ei4jHpgwR+SR/A4mKIZdjKKlnHT/R94UIHX/RGXFPZ2CpQR39ab/ACa1ZjSKJbS2M1QzynHE5NcbTz5jbk2vB/poAlhq3TodVh2rMgxwZY4DQ9xnc9lvcNCxrggOnEwv4jbe+8HLuFGgRKdq36A==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by MW4PR12MB7309.namprd12.prod.outlook.com (2603:10b6:303:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Thu, 29 Oct
 2026 06:59:59 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 06:59:58 +0000
Date: Thu, 29 Oct 2026 17:59:53 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <dgc@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <auLu6XEMZabza7aL@parvat>
References: <20261028171719.2043421-1-hannes@cmpxchg.org>
 <20261028171719.2043421-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028171719.2043421-2-hannes@cmpxchg.org>
X-ClientProxiedBy: ME0PR01CA0021.ausprd01.prod.outlook.com
 (2603:10c6:220:212::16) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|MW4PR12MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: bffc8209-4e4c-4a3f-8df1-08df358a3ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|11063799006|4143699003|56012099006|261009223027099003|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021123027099003|261021121427099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	8yB81I9H+mheCx+n026tQAKVzH1awtznP+w3P4xoFtUYUWwpT0wKNGB66n5B/6YbXP3opG7ZH+FtAr9zW0w9t0twxBHoo/hezd7G2M2hcpCHBO/IfUaNssxyFu8eAiHlF1+f9fdKa+5oXXHGWg5WTRgY327s+Ui+Rctf6wi5D5meHJz0Woz7Bpw9PxTpcx/JA9EmPUv/dFfbhPgOLbdW9A02ETPu89+6dwSSfnly0mNrec1stk8rs+u3qCcVymu4jcgQooGFba3NyiesWbxweAyzl/TN8yggx7+R6tvhaIikfcMONpCA/NsL4zvrxc5wjMIkGlgrS/CeaqRYtpPzfLMsVsQZ2WqyNFQsGBg9HZXFAwqrLj8DBc7aTLobqOfwbnUc9O08+I8Fqb9Kf2crUJkjICFJNW2xvGcU8G6XbOskFFUNsqlIJaEdm5kzEs/clyERLRfvouY6gx1XgGzbxaYK27fH5/sqmpyO7bigZIbX1MbmCCKY0YfulNFYXyh4c5cexR0EU8srpXHzHYQFbM7YqesgHCkpXRKNFzpM7mw6KPl0xQrbhTN1bnZxnFnMuZw6cdsKtJ5dDHUL8xn+FOScfuVESNulN8D0//qsY3MHEb4XNPVyk5ueKg6V8y2RNnecPfHVsmFYQtajguo/VgvVj49CjZ/jeQDK9tjhYyU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(11063799006)(4143699003)(56012099006)(261009223027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021123027099003)(261021121427099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rvmIIs8CuH+795ySnHIXkMF8XZ/KuDc4sV5FwmvlSwGmrdoxIvialUGeZ+rV?=
 =?us-ascii?Q?ttmHXzNANm7YXgX2PCLUj3lDfIUiB8kCugaD2UZUjmEjH26398/UeWSUP2//?=
 =?us-ascii?Q?zOygx0/K/aFhbMs2U6aQy9wL5571YJp2OIwIbvpTQ+XxVyOZFiVHRzgqKwe7?=
 =?us-ascii?Q?NpPtpQTCsRerWTgR8KJPrsJoG7QfRi/6IixzY7Q4iPbTNFXW8vf57E3+FZ0Q?=
 =?us-ascii?Q?7dg0lta8XAKQAPpksqNST0Kmyq23W7daZaZpUg7vo4NQXuwqS2Y3iqEL6l58?=
 =?us-ascii?Q?7uvwlPQHkxYFyoBmB6chwOGMgC3rS4V3sNjDEPvw2tTvor5Tk4XgB0g3PtSo?=
 =?us-ascii?Q?WwNupxVD1+XnrAFMOSUXgnC4z+7M8uZu2lIM2Op1E0O4PoBR9MG2PjnZyJeT?=
 =?us-ascii?Q?1M4FPRwhjmIf/XfgRowgIWJX7NrdDhL5Jgi1Eu29XPAi0BaAeMerx6e2yWhm?=
 =?us-ascii?Q?DFLBowwvE4AhJjfE1gKhgItRqvm06KFnYDb6fqDf/9ckEgFajP8v2zaeJqFZ?=
 =?us-ascii?Q?rAEnJNaz7R9+DgjzkindTEcKj5mC9CXbWD6tcKHv7257e3XcwD3orm1IPUoS?=
 =?us-ascii?Q?TCkq+ko5MMOVtEuIh4c86xaADqut04txNQ0EGxOrZz+0E6103FyTm8/eGFkD?=
 =?us-ascii?Q?USQC97VyGrHyOaLQTMGHI4WheZaYlbp7LzH0R/NTd7Tjmofovq3JL0/AE1UN?=
 =?us-ascii?Q?gW0r7ckawm+UsFBkM9TNBll/OPl0vaNXKM6kvRnFnhcGyQnmpRohRCkvPZ0q?=
 =?us-ascii?Q?IeGfLBADzPow1Ps3jqml+r2cZ7PZ/ESYeMLg1qwCffGMzib41vVd67AovMVK?=
 =?us-ascii?Q?E8TVMu5KBCLF94OGLBW0HlDQarwAtHNeghyqOuNDd/IxzDChrnKejrXvVIDu?=
 =?us-ascii?Q?U/02gS3O9ZtZEHHxWkRxNxwOq4Xe0J4mMB6uu9OUe3fnouicdNCFNhEpe9Xd?=
 =?us-ascii?Q?6U7mG5Aqvfhw4qgK7qHfyPuac6cEa/tLLJA5gxdAl6F2AiCPJ2v4Kt6bdbuw?=
 =?us-ascii?Q?KC7/ZacKny6QpINnsOrNmK58OZQehD5eYmMc6L7o9r0azajSgmyLiNfqobM1?=
 =?us-ascii?Q?jhLoeqgLCMp1TcWuHcOdJDyJKS2AAKTtlSEZP7sTSVYHIOiUj1/Gxg/3oYK/?=
 =?us-ascii?Q?g6TMsveyAW9nOcxtCCcsG4MOanaYSA9hlsdxMjZ9iSL0bfCkAyUGlmEzbHoi?=
 =?us-ascii?Q?s1x+Q5p2s0R4n79tPTMhTvl/3T2oR+BPpl/q2bG5p1Q3WBO5IK15qLOdLaNS?=
 =?us-ascii?Q?Z8lJsLv3SpLnqS1pTQ3t3dP11sPyDuBFyRBcLT7VKKTrh4ErbpAYpOz50Sl1?=
 =?us-ascii?Q?vB7J2OUJItGDrYgfZh1Qh6U0Y62NFc3wW1FHKmNQwsFvQcMe1W8bhU5L2+Vh?=
 =?us-ascii?Q?kXSZWnX5S1pMDF1Ye17RShAAqp7hQeHu6qQpUYUOaDsqeOTtWLcUOpwzx2Rj?=
 =?us-ascii?Q?mQavd7KcvaoVEDbh7oGdYoyoRXzSWqhRACGRNaqZHKl+GMUD6ETw71e9WlH4?=
 =?us-ascii?Q?pA69dlYmeH4aIWxW1SfyX0WuPhVSKPoNq3MhgUl4EDQZtpmAvFpJtaUZ7p/o?=
 =?us-ascii?Q?z+4ZDN+ImoNVQuu8QlwxyGJwarvLx0ZqOrshwmYzgl+2F9ieFi1gjlLztMb5?=
 =?us-ascii?Q?/VP6luHIRoUbNl9fAjfQzIz4jtbakZFy2qpsaz4iUaH5vowhoBaHEfKSD4d6?=
 =?us-ascii?Q?ATV8wLpekCLUjPcKEzh4c/xF+8jYmH/rr9m4tKohHloMHY2j03B0APilfxAj?=
 =?us-ascii?Q?mYBjXqYFRg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffc8209-4e4c-4a3f-8df1-08df358a3ef0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 06:59:58.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae4uBaVwlUOctfcsLlBOm9N+XKHhAsRMyX4+BokKF+z+NoM9FgbExZ3qqglrzsNpuPwPWzKso94+LFdyIjoOaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7309
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F11FB1C0004
X-Stat-Signature: tg4p9fw4h7p3e1rkspp5z9ddaifr9zej
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793257204-819353
X-HE-Meta: U2FsdGVkX19k7B2WvjrPSzjKCzcAKtpvnB/wHxiU59joaNZW13UlMEOpmO1+SP/K1qMXMedTaher0N7C6B2Z+ySkV/p8386PakVQjrVxt5w3PrSp2o/ZKb+ittGlpHeiRsj1yJ2XfT8QmQpPs2XM3mBlB+ehETQDGupPULHAEYKwFmFtEwjYFsgsv+wXvKfXfB6cqvwchV3HzVXL04RlYm6rhePIyfm78kdWYrcI8PLKuaq4BLH3CFIr2OuoV0G9JFyXUTpPtS6hOKlhr/aR8/h9t7quIV5b+zctvQyrc3kT/XOyV7kvsQASNtq/iOFpFAj0wdDCxn0nh6WcUHxm9XFO7wOksIWfxvbLugSXW5Gz+wDI49f/mk/RvVPTLpEQn8FSQ1WgBWVKm4nTiOIu9xLE92gDOYA2JCt18lKzS0Uxcbt5SNwZeMt/gyZVkuD8hNlQBRT1NP9kLkjDNALGz9A5CM/DhCzbXZI8r4dcGy/vb4kYvQ5hL57et0+zvWZGbHlUUgrmB3aW8uj/TcUV1FdPTvEZjDv9yaFJGSUlk6hvp5sIH6x9cS3WUm7q0A3zrrpo/BbxVZSOyZI+HnWLOkpiobV6M4MJjlIn5NQI5uQrSPPH7Ez9yhlMLyuo9sjz8Ja/OSXEoe5BQqJkq6Bs4nm/e9Jja0E1UWKt40Hx83XXVPtBwfAMYICkKdjD7VEMlnPePYYO8bhglnK0OrKn+KZCx5W+XHKQHUsDOBcWwuqVGS6IHChK28b22XaepeKhDG/XPsOBcjru9RhICdD8T2oRF5nLs/iNFAOzIbepCAZwJPmbzWDKigsjzmMJ/Dr+df84tGJ4+9wWy+0Won53vSLDnuu5eiJPT/HLxerjDKwC3WCSkj23qkTFyVe5GedK9XnP6NniSuvKc6r9Q1U2K64sCY4Uhs4UQo29+4zBQUKtnyAyh11wgOqGezYejJVzaNkwgXveolgzheJ7HiU
 k59I/d+H
 1BvuESXtwgLx61rjv2oKcRGFZHdGhuWgw3rh30cmHE4L3YiBB3l9IVvx6juVvhUwvOM/EjKRBPg8TIqLOTU4GETKQMKNZs0Eo9TymhesFBYRd3AwpwakO9EZACtWG1smLRRFP/LT9rKEQnYUiXUkgyjr46SKc0GYQh9FEFv7ILjow6BeoPBff0c2svf2ENt1JMjsGd4yZSeE6LIvrlOH7FassIRyMEggWm+Fk0HrXGvmwY6M5CLgBB04W1fMdPJnItwb1+hbscNEhetPT38MG+i05ZVQzdViITF3r2/CeSRwRI2+qP1orFYiV+gZ2SiZ5gzld9g2nF+hBgUGL5W0qDhonmcdp6sU7OGId3ZKL6itdHYvv9XefA1gCsAjc9fRZUriBdUz8fuaBFvY66PetVdkX8qK6+FcKanVPdwP/RsczRoapmCUhjb1lzpH66ak9p70zKTOo+zIqE2mKWPCFWxZwpPrRZ/XP5bOXYYRbJhHlG3I/iwD9ZQDDEOuREt3MSSakPQpFH2cMECar8ewUPUN0ApOFW0HniPfiJj94J6RkYMQKrK87pqU/3Q4F0ldXrEQKbgg++n2TaBFsYEwJkouXlENai7KCgAeyKHeyOI1MtaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 01:15:53PM -0400, Johannes Weiner wrote:
> 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access
> highatomic reserves") accidentally gave all non-blocking allocation
> requests access to highatomic reserves, which includes GFP_NOWAIT and
> other sites clearing __GFP_DIRECT_RECLAIM.
> 
> While this improved atomic request success rate, it's unintentionally
> broad and can actually worsen highatomic requests by squandering the
> reserves on requests that don't need it.
> 
> There are concurrent efforts to clear __GFP_DIRECT_RECLAIM altogether
> for costly order __GFP_NORETRY requests, which would then also fall
> into this exemption and deplete reserves even faster.
> 
> What GFP_ATOMIC has over the others is __GFP_HIGH, which
> alloc_flags_slowpath() translates to ALLOC_MIN_RESERVE.
> 
> Narrow the exemption to contexts that have both ALLOC_NON_BLOCK |
> ALLOC_MIN_RESERVE.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
> Fixes: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/page_alloc.c | 4 +++-
>  mm/page_alloc.h | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a8cac5e01066..8ac2e2bf14fc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3238,7 +3238,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 * reserves as failing now is worse than failing a
>  			 * high-order atomic allocation in the future.
>  			 */
> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> +			if (!page &&
> +			    ((alloc_flags & ALLOC_OOM) ||
> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
>  
>  			if (!page) {
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index e238ee91ed24..9c3c2830acb0 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -60,6 +60,9 @@
>  /* Flags that allow allocations below the min watermark. */
>  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
> +/* Flags that mean GFP_ATOMIC */
> +#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
> +
>  /*
>   * Structure for holding the mostly immutable allocation parameters passed
>   * between functions involved in allocations, including the alloc_pages*

I feel patch 2 needs to come first, so that
__zone_watermark_unusable_free() accounts correctly.

Acked-by: Balbir Singh <balbirs@nvidia.com>

