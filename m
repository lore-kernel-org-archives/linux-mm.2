Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7EBCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618CE6B0092; Thu, 11 Jun 2026 12:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C99D6B0096; Thu, 11 Jun 2026 12:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7F56B0098; Thu, 11 Jun 2026 12:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32CD26B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:21:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0638F1C37BD
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:53 +0000 (UTC)
X-FDA: 84868148106.15.5D7524F
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FCE740002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b="zsOEsUl/";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgCQ7Hx/oHrJLsXa+bC+Kt0ZCr/xp8G5B/LjY4Sh7ng=;
	b=VuDRUOAD+BABzqkC7P5+gFoUcoGT2h8d3Q8u7DwDIDCSVhJa3FCfnTVJv6jGzSfFC/5WDT
	3ZregmcO6vwKGhYUSJgRqTslEgIBH1wyfrOGRnv70aOpohLUd1TXyWlIFbti9R9b+fROFa
	WnltdmY0dFgXc0imhLyfoyD/TN7TCu8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b="zsOEsUl/";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194910;
	b=UaiQr3FKrSNJlPvkgC8aKJPaH/bR3tJoFD3dE25m7bpBN4ZMJf4sS4lisQk/DG7xZFNEAn
	6iw4AHZhAW+3q63b8sBgLDSmT8x3BX1Rude+cXVqroTV15TnJM0fIgTdFNi+QD/Pzn1k7r
	4sdNnQoPuWLW4uVfnSEzsBbcZkfWb8I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Px0BfZlXqGS2xsEfz3ACqWvDNoDPvvqbgsF1PNrBTdcco6xc551suMmTHi5CkufhkgCPONqT1Uw1bZx9PIPvWSZV3HORIqUWWaPzhAJGI0G5ZMSmOzTI45odZs2v7yOW8ZnH9TjXVFRaEdlNNWpQBDKw8ecEK4EqkfusRo+z5/xKNwzIlJ5Tgro+x6pZsWxcEJhPptXBgKFCWry7oWdpJIGL2jbt5Ed4lOLAUV0ZvrLpksDrjtJawsS/lZnlwKNltk3c1fiwoCf6mnlh1O7eB9wjAB7Ppox9FS4gWfzOXoWSvucPqo6pq0N3ylTwfQ9k7Y4YXbWF35ff6pRWJ2iQ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgCQ7Hx/oHrJLsXa+bC+Kt0ZCr/xp8G5B/LjY4Sh7ng=;
 b=YhZ7314XouqH3xSYNG+MThQDQsjWL8eLbppUT27CNfqJEd6YyKQKCpkkjS5Ebtn/d7M0DpQ5RHKeaKTms1SM2KIr7fOsd+Ty4Fl21SNHSO+dZK2Kgs7XBPa8GU68Hg7WSOIwIqD9LmVcIwY281i22WxXsOLUfLO0HfvPtODsv4isn7l3Kf2ea/ikmF08My0nWrsobPR+rQHwyKMaDLJH3HSSiWJN7BPEyZm+ph06fadBTnN2ZDaQ+re+QApB4XfaFUMGhRrjiBW5odTRkMNhZG6HD3Y193eOFsmZXOvM5VScK1bz5rd1U4Ba9ikZ6WjiwAfuNlHtu66bL1e9uQhCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgCQ7Hx/oHrJLsXa+bC+Kt0ZCr/xp8G5B/LjY4Sh7ng=;
 b=zsOEsUl//2CPpd3oce1qMjs0aEAPtlsq496X388UfwsH+Y++1GZVj2S/R1HVQLTapmAj47xhsCu1jpPoLjjTNMvAz/lf9QWEAYGZ566zn4m40Ga1OnDXLKXd1fM05wob9BUATXDBXBx5HUra3bLhPwAYoW3Za+CpSMT6bktwEecjy18ohm3iCf4TvkCN1Zx0WuhnOTPvt3Q6AVB/JH6BvXW+x2iZImIAXDwbsAqNndAv8Yd+lGdMy5Oj54FebBbkqp73Rg7AC2zHGX8godSZ2HHDtgAW5Ijdgg1+LMJ7fmFdWqqRoFwmiKkMboeSmsuxQTRPaomEHP09a/R0nez0/g==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:42 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:42 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:04 +0200
Subject: [RFC PATCH v2 02/14] kcov: fix INIT_TRACK race in kcov_dataflow
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-2-0a261da3987c@est.tech>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Yunseong Kim <yunseong.kim@est.tech>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
 rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 Yeoreum Yun <yeoreum.yun@arm.com>, sashiko-bot <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=1551;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=5j3WkQtjfH2boFmRsdHhDZ28sX+tub4KphkwIkiFKHY=;
 b=K3sNsCZBJ31RVNtWUeY1VmAAs6Af9PvIE2lKEoaab3Cgs2puCiy1U/hkb+oUec3zR5f/ovCFh
 Q53yF0OL4iHCgFnNXzMw2rN6Yygcu07coBV8uy/QgNcEgr9c2oBw3jj
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBAC.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::6ec) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a145ed-2cbd-4725-1e8f-08dec7d58609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mCFcPEBiu7/N+E3e/JhS4CGh5bO1fjxFQI/8gvtv24EubWFuOg5w62gdlKdPgor4iDpzdGV4glf3iHb2HBGA3KjQov9KdchLF93o1lyQnjIw5O0E8OmVAmIdCQ67kr0rPk/dABwNS1gEfAjioEdVIpferpyysQqUPZqtEolnWL7ilhkHKmSfNJe6FiUjDzAuKBc/k+BRtJ28vNoCKe6awD7gryqCd3lB4IHVdj6uHoFg1kxmEHSZoRDnLyP5gNzF3RAbSzHctam5+4faQcA7vIKHZqysfivo2uSHwOhJCPX0Uvsbx3w8V7Ghddgqfqzs55435EyzXYH84UxMZPj69zCr3ZMKF5nDbLFUPvaQXHxCPNQ8ukKk4daICUJnOn9x6TwNH+c8V4R9Bj9QpNKrqHkM5mt+yl/FPUd9hB0/3ICWg6M0LNzVO72im+1MyKMA5nLw/jECv7fwZ5uPQJFe2LCSsit4Kk4jwN+JXFOKWfwnChkFPl9Bg/2VQa5kHKUkk3Czy9cVVgnXyKS+hZTE9uf9HpEL4SGp/gq/SK3yxU5wYhw1j/VUiAGP9pCelsVTKt9C5f6z2EqHbqhdqXGfkH7B88kYQjwU8LQmahOVYyGOLM+mFTWTFLgqx8cA2YdDhgEGqCk2aF4oCdYBF9glJ5uw15kW789pYP/PS8J5l/0m3Tt9WnmFxX469J/oYVnD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEE4R1lZTkZOd2V5b1lCTmJzZm5FNm1COFc1QjloWFFnbEc3b0doWExrUzRV?=
 =?utf-8?B?UnJFbG9BMUwya3FHdWZNZGhYaUd5MVBOdDFJSVVYaFl6WkZyOUN4R0tWSklH?=
 =?utf-8?B?bUc4dTVYM1ZKY0pXU0F1bitiMDJNSXRnc0hSbHdtVWxybHZ0Q2hwVUxqTk02?=
 =?utf-8?B?Q1FDOHdndTlyb1ZNU0ova3RvNG81TlA0UGhjbVc1QW1kRUVnU3N5N2VneGJl?=
 =?utf-8?B?YlhOeHZvNHNQcjZJUDB2Zlh4c091NFpnaFJYc3pZS1M2dFhydkhqU1VKSHJl?=
 =?utf-8?B?ZEFMVllYendmOGc5dUt2eXcyZnlFV043WkRIb1Z0NzFoajMyc3dRUjdNMHJq?=
 =?utf-8?B?YmQzSXZTZWNUNCtFUHc0TEpmODA3UUdzU1B2U3d5eEFQTkhmdDVCOExlOFdJ?=
 =?utf-8?B?U2lIaVUrS0U0NWRWanYvc2c4TlJnU2RGeVRzZGMyZHI3WkpnRitTSENiYmNn?=
 =?utf-8?B?WGs4QlhCZy9yWEd1cmlSYmpwQUJ6dVE3WW5BcWs5eUJwZFllcmp4bThwNVdW?=
 =?utf-8?B?TkN4Rk9DNEtRYnhSeTd4bHJSdDgzaVZwODFFdlBIblpLWndSMEdYakJvdjlP?=
 =?utf-8?B?dTQ0N3JTOThrdjVuZHRuamphRHB2ek1xOGQrNFFteHcySXdNb3UyY2svS2dZ?=
 =?utf-8?B?eHlyZlk5d1VPOHUwdEc4WTU3Q01GUS9ZUTRUVVprbDRlUVBQUndVaGVBUmVs?=
 =?utf-8?B?cXJyamtSTHRybk5LMjRtYy9YWnExTjVwSHVacElvazFhd1JDV3l4UEN3dlMr?=
 =?utf-8?B?Si9EUlp5U0RLa1V4TXV6YkxFKzY3TWVJSTNJaGZhUXBpdWh5UHJmaVlFcG1h?=
 =?utf-8?B?dHp6NHB2NUJjK1ZWYXZobTBPM0dQcm0wK2ZvTFhzNjY5aE9uOWFUWjZMR0dk?=
 =?utf-8?B?ZkdrZkNpNTMyWCt5d3B4dCtwUndyREl0VC9EMkdESTl6QTRHeW03djBYVjRJ?=
 =?utf-8?B?c0o1Z0ZqbkQvS0UxWmtJMlFERTNOZ3pqc2dkNWxxdlc2YWRoeVJ6UWZJQ3NU?=
 =?utf-8?B?RmVKcktnTmFUQTd6NlV2SjRQek1xNjI0UFlvcm8wUlFhbzFuUGpVbUg1R1FN?=
 =?utf-8?B?eE10eEdiZWRJdElRdVhnWlVvUmdVb29OUm1GZFJoTU1oM0o0QVhQK3ZiQ3BZ?=
 =?utf-8?B?VlZ6VktheExQMkptRlZkNGlQUW9nN3BvNjJGR2dOd2FBNklEVmZ5R3ZoOFkr?=
 =?utf-8?B?aTVIc3NyVmtkNmVxa2FhNFpYeDkyNHFkT1hGWnNzamhjUkZGQlBvUHc3U2lp?=
 =?utf-8?B?eGtBQWpVNDY5VkliQTFwZjRGVzVGenZ5N0o4RmZrM2VEa1IwbEtHSDF2OUxx?=
 =?utf-8?B?dXluMjg4T2lmbW1XSlRpU0xhVUt0Skt1WUNiUjFkYXZkWTJlRFQwbVBNK0x0?=
 =?utf-8?B?bFltb0ZlSVRjenh0YjE2Nlk2Sm5ZZVNhYmhoM2d6akhsWHJZaVIvRmdtV3Er?=
 =?utf-8?B?K0hWQ1ZETDlGM0xDZnBFR3ZhSHlDbkx6U3NOd2JwdXpaSzFQQmp5V2E0NEdU?=
 =?utf-8?B?VURIc0g5V1dneVdIZXQyeStLOGh4T1lPUzhoRHZnYTFBbitFVFh3ZjY2VmtC?=
 =?utf-8?B?YUJ0SFJqNFdhek1FdzlqQkFIaU5mOXVOOFpRQWw5VHBMbjFvYmN6NytCYXYy?=
 =?utf-8?B?UVIxd2ZkQTk2VWc2TTJSdThpVDQwMCtDNU5sTUdNMThnYTE0eWk4Qy9rTnBp?=
 =?utf-8?B?UGhEQVplVm9hcUxLNUoydll0MGtvUDBiRk1PZURFcHcybWt0cEMyMC9qa21R?=
 =?utf-8?B?VnJLcXdGYStiYWcrcThuN2RKKzNOS2twMGNkZDB2ZzZXTlVnVVF5Snl2dENh?=
 =?utf-8?B?UlBMWXpDVDVONVRFVkljWVMwbXBvWVdwVE5tNnJTQUNQOCt5U2dGSkpmd1Yw?=
 =?utf-8?B?K0tiSEFSd3Q4ZU5IazlMci9rdDlWd1EvNUd3bFlzRytVODZ5aTVySnl2akh6?=
 =?utf-8?B?NHpVUzZmYTZxZ0lNZmQyczNEc2hBekZxSXE3R2c2ODZqUDFoNWpRUGdEQUlD?=
 =?utf-8?B?TGRIYmVweWpjZ09ZNXVXNk0zQ2F1Q3B3bDNRdGZWRzVYbnRnaVdPNEpYOGd6?=
 =?utf-8?B?UkNZVHJtUXpFU2Mra202YUdPVWFUM29hL0llWVN2MXFqT2dZT25tV0JhK1dP?=
 =?utf-8?B?bXRIK2cvWWlsVitUWUdrQklKKy9ETUNwdUJlNVlVT3ZHTENWMDhXS1NRWkRz?=
 =?utf-8?B?Q2JJQnU0Q2phS1RwWlhmei9kK3VyZVdkZ2lIRmlZc0JaSzJjSnovV1I4ZllR?=
 =?utf-8?B?TGhYMTlDQ1FvR1ovTHVHakczemR0Vjkya2FxbGZJWDk1RVc0bVY2VE02cGtE?=
 =?utf-8?B?TVowNWNUV1Bnbmo4MG1ZbnAyNUo4a0FvTXlJMTJPYkdVN2FQeFNuQT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a145ed-2cbd-4725-1e8f-08dec7d58609
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:42.5120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkJBVpX0xY2+k6lUxLx9Tz69Mf7M1iNCmB2VstpZeVAFYzVszLidAi9tgDkgMNxbNbG1j3N+quiiWKtjQv6Zsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: unne4imx5ura7hm1xe6iye7qx3zpe14s
X-Rspamd-Queue-Id: 1FCE740002
X-HE-Tag: 1781194910-946086
X-HE-Meta: U2FsdGVkX1/ncoWp9VabeyDZOjD/mEF4aYdfDO/nKrz9I+AF4k589O15V9bKVX8+LdNMA+IrEkadztr2F1w24B7WmqYKpaTj2eJMG5xkeRWITVvVRavuBgAdnsnN/zzXtRv+aZM1edYhrCHuMGJzVmKq9sN0/kh2b6voAcm6gd/+qzKszS/B0soborpbrgt+aFWP0Sal2XJdlGIEvtDDz0mdP1Z/Za8RGWfLYJHRU91nfOudZ8gOy1OS3MTU2rQAbNm6IdayGGuhkhXmZ3QzW0I0HhXOX3nwmLSIJYgs5hb/PY4O8WRi1BMx3KLVPqvzLQ/EXFk4a3PWDcABF4QCmdCzaR97W3HC/Rm3EymnB8/2DUhhhlOZs3v37KmGonYjFSuWoHzzJoM3xbXxeg+4fHnu497Jwm/nTinUrZJsZ9y7ctGIPDyulZJZO+cYMAeRV/e9d1xJNaafAHZxRqQrnEEFvm2yXsN1xkWT5/HzCnWLHiZwQ2leWgvVn06QX8yVWadyK7qGM52yIXfRJwquNWZzefnaIS2zI8GWmjnv8/VKxAZ1VVpQYRYjDXQhA7y0BzjqsSl/61hnf1CjPyUGs3aL0tG++BOftmAWH0w3q0UvYAXRZh5kwY/l1jNJJ0kHs1u2t+A2rnMH0Vm0l+70/nwdu5pCZSsPWRNABli+laqTv5zSN4fwPFSHr65qDMDq+gnY45VxTcWJnnTqC9/M746yGhsM2YwUbXiNl6wHNQT3afJ1oI1op29iolhbmvQuMOP5UNW64Eax63e3JYX5o2ryFCB4CfoWm64jetBOSiSSlHphcsmNyhus10R+qCHMBs3C+PkTHZf4N0FIJsQvpVSnaJewkJHArJ+0qV1JAf1TPOCbzKHhgBaqkVQCjZtaSH12FREBnvWjUhyM2t3P4NvH4qvKnlFr+1PdzkOutWfu7/bybGB/nm6aLIqa/mLiRwftI386U81iqFm1Nr+
 CzaCcZqF
 gx9gpKgBFfMlF6D5C071F+5MvjQZv2DBHN69EA3IiS1A6yuTTj6SSm1r6QgpJP8gGpmq/xMxUI9UIM+qDznm5CHg3aHelKihp/WviUM3ICtf4WWS5iYUU9KfPnhJUPGiOIoOk1ainz4rLioMVbnPbFSJJOWBFHayd9ELCYz8lsTcSunMoTTF6sCIv3cPf/T8V816bQXlNl0U8SzsPN2hI/EyG5UqeVPpkwzXn9OIYmaCG3h2Cj/A5vxUmu3rte/pbTzjXfOUMEn5CUhwyspaNwq9i9c+8ycvzYPPKIbY8w2a3QRLj3r1HReuW2w/Xsr3OO+8EI++SodS7XMP8D+E9kNt3Hwc0obzCI/IFh/H/h6ZYim4gXNLlPx4yxoI8irCh02YjYobs+BGCtEmo+JBR2N4Rb9E4iO6uVj+qEHBUZddjDBEuOT2t5ku4YJWuOlWFwwZOs2vvERxqByCeKTPKkAEMOlJTFWhKeYB+lrabAg9x82l5PbIgqpTN+PBesEoLPdHx3kcyfD2xiF7sKR/4XCkV68JevWTx7+77KwcJm+iXM8EOjwm7sIvihY+I8jXI9+Tjn23tzv/KOpGfbWHP6KpA7FMPW1vWDWShzgGWZD67pwxOC1QPisdUFHz6Tx1kSL4xe11JkSK71K3ABSndrva821ieBbmndMjsMW4WfbWgHA1LTi5qackwH/x2Rs7JbprXiSQIXAocD7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two threads calling KCOV_DF_INIT_TRACK concurrently could both observe
df->area == NULL, drop the lock to allocate, and then both assign their
allocation to df->area, leaking one buffer.

Fix by rechecking df->area after re-acquiring the lock. If another
thread won the race, free the allocation and return -EBUSY. This
matches the pattern used by KCOV_INIT_TRACE in kernel/kcov.c.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-20260603-v2-0-fee0939de2c4%40est.tech
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 kernel/kcov_dataflow.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
index 721f742cbfe5..df7e8bf70bfa 100644
--- a/kernel/kcov_dataflow.c
+++ b/kernel/kcov_dataflow.c
@@ -268,11 +268,20 @@ static long kcov_df_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
 			break;
 		}
 		spin_unlock_irqrestore(&df->lock, flags);
-		df->area = vmalloc_user(size * sizeof(u64));
-		if (!df->area)
-			return -ENOMEM;
-		spin_lock_irqsave(&df->lock, flags);
-		df->size = size;
+		{
+			void *area = vmalloc_user(size * sizeof(u64));
+
+			if (!area)
+				return -ENOMEM;
+			spin_lock_irqsave(&df->lock, flags);
+			if (df->area) {
+				spin_unlock_irqrestore(&df->lock, flags);
+				vfree(area);
+				return -EBUSY;
+			}
+			df->area = area;
+			df->size = size;
+		}
 		break;
 
 	case KCOV_DF_ENABLE:

-- 
2.43.0


