Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90750CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 12:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C660B6B0005; Fri, 12 Jun 2026 08:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16B66B0088; Fri, 12 Jun 2026 08:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE556B008C; Fri, 12 Jun 2026 08:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7D86B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:51:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E90481658A8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:51:32 +0000 (UTC)
X-FDA: 84871246824.26.F952F1A
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013070.outbound.protection.outlook.com [52.101.72.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0370BA000E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:51:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=zmbFX05k;
	spf=pass (imf25.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.72.70 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781268690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbgjOD9s/DYH429AkZYSZ95JcwLqIKgcINL/rYXrulo=;
	b=XD4lZ+k7xfnau5Hw3tieEU4hgwluNl4RfCVVI8F8twOBxai0Qv/6ijYRUfB+8KO1uXiqNB
	qNB2IXg9raq3OCvB/agiGjnmtexOoCxC+SXX4/rPEsi0JQli3+ih/whGHExfNDdOcs4Y2/
	//M44i35B0dGTgFH8rlGHb+p7SCEH1E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781268690;
	b=OsaUQQJnkGV1JU4mGOjhUH1WyoiYLVgrhgANztQXVyQ8XJ8NTa9kj6++5ZO38L2VnfEpco
	mDvqdJBFIDhKcof3C3aB6lMzImwJq+3Ggfn+e5LBYrs+zKDzs6+oMTnVkQkJPWPsZRpOvB
	G7WSAZ8mkACUVZEEcwDBk/E8UwRKUdg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=zmbFX05k;
	spf=pass (imf25.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.72.70 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPmrRJZwGPiMi4IDVR4jCiBG/juj4CQNgv0rmoikBxN7Oi8xLlHAyUKVn/49nxkBuViMKOAE+ZOimNpGVh0Ic+gSsM7CM80+HgRatg0NiM9pfYyE52mJM/gJ+z4wnNHbGaJdbe0bTGVDaCmTmQ3HiN18C0mXwZKvGMsvP7MlkStTFQ6ulUXuctPFrwCotmnLn8+jxbtyoo4lOI5HgJbWsOwv6e3L0WTt3Kii041ohMeyJftaLJTWamfGdlSHFsifF/U4c5QR4Aj6D7CsoSzNKVxbzwc7X5vuPswJettLA0Eny5RwleLEDBWlHFYeBJ2QDKj7EHfGRIw9VcBNPanUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbgjOD9s/DYH429AkZYSZ95JcwLqIKgcINL/rYXrulo=;
 b=Adu9MsgfSXmlt1vzLZOAVBV/PZtreBg8OSQEOrzA/PMDikoQO1IUrQKyDA2TtXphXnN924/iDlF+ZpfuG2T9n2sWPFFVuaTOZCH+cxPZyC2XGwJlQbO8REkoK3j/Dycaulud2PG2QVmQ5baN23ZefJrnami2/HZpchd63qOREsQvu2jiy0mhgypfRb1Z6o5qEb5l0Z4/Yu0sZ6W/ri3wqXc8nGYrm3PFm8XIMEU1zloH3DyTnLUQDi+MCQ4hq2UW8dxzjJZNvfTfEqyLcSUWiFz0gD8MsuS9oAQ0EQda90J13HrjbbCMZSw5HsD9BOGmefKljrUheteu7hkrr+qinA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbgjOD9s/DYH429AkZYSZ95JcwLqIKgcINL/rYXrulo=;
 b=zmbFX05krU4qDkplw89c5pOp9JeHoCpeLd8xaMD0zNJQstrY5i2AdCvwmz1R/FkaKt5TwbenwffOMhzonAygHgFgUWN6vmgy4nvKlxl4Pl4FjrDLddp6UVW2JDoUFxZKgbAQAvtQDLKs+gIUdnSRxEysUTuAk4o2rlXRWuZBw/cBztaXztRsdTSKEKq5SeQ3klMGfKdbbqAwfeUIkX5rbBXbwSXwJN80P4cKyylYtu4xqhYvuPAbRrAAJyQy8JmAPbHfCthq+EYGsuVskqnNPzXU+L64YkpHOhY74NNcD3A3m3SuCaz+OjFkEw2ZRuiASlsfRGiimof8Lao9UsNCJw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by GV1P189MB2012.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 12:51:24 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 12:51:24 +0000
Message-ID: <9ef3ee07-34dd-419d-86ba-a8217893259e@est.tech>
Date: Fri, 12 Jun 2026 14:51:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/14] kcov: add per-task dataflow tracking for
 function arguments/return values
To: Alexander Potapenko <glider@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
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
 Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org,
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>,
 Yunseong Kim <ysk@kzalloc.com>, Yunseong Kim <yunseong.kim@ericsson.com>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
 <20260611-b4-kcov-dataflow-v2-v2-1-0a261da3987c@est.tech>
 <CAG_fn=WYdnX_09RNs3sTQWn+KZZaw+X9a=s1Uk1bqd3gW04h6Q@mail.gmail.com>
From: Yunseong Kim <yunseong.kim@est.tech>
Content-Language: en-US
In-Reply-To: <CAG_fn=WYdnX_09RNs3sTQWn+KZZaw+X9a=s1Uk1bqd3gW04h6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0651.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::17) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|GV1P189MB2012:EE_
X-MS-Office365-Filtering-Correlation-Id: 64383ddf-c2d4-4971-a1e9-08dec8814f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	19EoHnULwshmmueBRtpd878pOTvpsgCsyUgdRVpEE8nvIxSzSPck73EoQqJw0JNzMSM4xr4dbJ/Dd/+ZfjP5rx9vg+0fvH4//Kupf83DK4qDNUECAlq977kFtxzlr6wMXn/tMoycTFu3vFjmTy1M627xWWM7lsY1OtarUAREA1dYxL2VOuOf1x4wRrVrx6SLH3jiXXQL0Ajpb1UnV7yu4pfyLc290G3BwL6Qk0IeLcIR0SdOmvIlgsKRMwvkUwzw5M7MJ8YWMF4g/43aVO0sjHbRlzlrFANkyfYwSTbto+a1rAdSXBxBRC+EdJX4hbbz4XjuEX0tE7UksGfVQRQM7tG/XnmvR5GvASP7CmcA/o5HniKhLIvDB8o4rK1N9WDwKs9aJrn1R675bVVh9HZxWFuH/rXeGfhh/km6TYPUx+JutPyaNEMPYn0Em5efjq9pTtUOS0ECW1kMSIxCd2uku6oA8l0hnkkrR1auFnH0Et4w37Gtsh+blFchCnhXiPR2mYKfGFTmc2WAfn+yHBg8vRnT3op3dtK2jR5rYN60yKZac42CoOahoeC4gNFikugfvcflN1F6/gaxJQJv9AfsjX8Z89V5Uuu6sJiQU8V/WuakOUJBTDZqXOVrrIXm11Tvwav9f8Zr1GEo1q/mVhm/LGKh5aksSyyyFroPpRcGUtANJTk+b5eQ2oXSlAOaFMXN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2dLSFhtRm04K3lyb1N5TlNKVEg3UU5DMmhua1loNjlMQWpnRlhKQ3pCVWtU?=
 =?utf-8?B?NGw4aE92eVNGeEVhaDZKaFNidWwxRzIxR1lGNko4ckp6eGZmTDQxcjR5NFBq?=
 =?utf-8?B?R3g1dkZqQTNWMGlBaHFDR2tMUjZJVGFlRnBhbGR1QXdPcTNXWEhaSkFQYWhy?=
 =?utf-8?B?Zy9adlhMd1drRkRRQWlVSk5mcGx4RDF6NE5YTjE3SE1sQ2RkZ1lGL2ZsaXRZ?=
 =?utf-8?B?RWhud3Z2ZEF5RkFMSjZKUXRWcElhZTZPQjFzekxVWkxQZEg0UlltNzIrQ0lr?=
 =?utf-8?B?dkxUa1UwRFkxblNrSWtCcDh5aGFhZ3BDQVI4QWNxMmdYTEpMb21qVFc0S1Vp?=
 =?utf-8?B?QXJuZ0NkcHJ1NERCL0FCSW92d2FTTlkxRUUrRHVnZDV1N1Eyd1E4U1JIdUM2?=
 =?utf-8?B?TzVvbEhpWGxpNDQ4cnAyWEh4YWtYekp4ZWVTUDZGdEJjOUVjaGVlbjY3Q3lv?=
 =?utf-8?B?U3FDbmVLSTF4SHp4eTl1V3BKY29yUlhDSUVRVDR5cTdDMS9KVnVqU0pqV2pF?=
 =?utf-8?B?QXNNdzQ2d2VjZWpzN1ZJMGthSDgyei9yT2VCcm5DZnNLcTZhV1k3UUphb2lm?=
 =?utf-8?B?RHVoYTdkbGE1bXpVaW5jc3JSTUlERkpzeWJXVHBDRnluWHVZUmdqWGN0eW9X?=
 =?utf-8?B?RzlVM3BMMjN1UEZiOUEvSGhCKzFGaVpISVpvNVdGc2JHd2RFN1lROGNxdFBL?=
 =?utf-8?B?ZkNmOGN2cEdrN3l5dHREb0NBcjZUakhVMWxUWk5lV1FrZm5YdjJnOUJCVzJV?=
 =?utf-8?B?V3V1U1VNcHY5cXF0STRGMWliWVFjR0VYQmp6MkxucmJhWGovRnQycU9BL3F1?=
 =?utf-8?B?OWx2dnNid3l0a3p6dEZ2SC95SkJySWpYZERMZnN0ZklYMFVVaHB5dElvbkRX?=
 =?utf-8?B?RXNzVkRXWWlkclBWYzdQR0tuektnR2ZpNjloaGlHT2dlOE9paGhVczRNeDdS?=
 =?utf-8?B?bVRFb3JvTUsvOGIrdEhkZ2Qwd05XR1B0QlNRd3dXUXBiaHpXZ05uT3p0TFdF?=
 =?utf-8?B?SE54dlFwK3F6TmRRSG1Fak01blMvK1R3bzk4UzNmUkNaQUkyMXhUUEFNN1FD?=
 =?utf-8?B?eWxIZzJQc242VCtWSno2OU82cFFQVWRZT3NsRndEUFNIYWtjMlB3K0wxUHFH?=
 =?utf-8?B?VU1KU2l4aE1DOEFPOW1lWnJwMmVFcDJZOEZqVzkyWWU0aG9QNFNwZGIyb1Rm?=
 =?utf-8?B?cU9MT0hFQUVtZFFzRmhZVXRnZjM5N0NMbFRFREhiL0twdkRSYzl6bjNRQ0tk?=
 =?utf-8?B?dmdtQlNvN1ZGdGZ3Q3E1SU12Sk9yVlJMWTB3L1kvTHo4dUtNL3RoT2oxOGEw?=
 =?utf-8?B?c3hxUUNoTXVVRHZtYkQ0VmEyVVUrVG5xNk5lWlRFcVhtNXB2SkozVm9rcXlX?=
 =?utf-8?B?QnZTbFpNWDcwa1dNRk9yMnFXeUJsVDJhSTZsZjZ0MlE3cDROenM0QVV4bDVH?=
 =?utf-8?B?OHNlSno0aEcwVm85Y2dMVjhmakJzT1BacUJDQUVLZFUvVEJ2VUpiNllYM3Qr?=
 =?utf-8?B?YkFMWGRnRVBUQVBoR01KQ2NuQzl4ZmtwSXFpL0RRM2krTzR6dkczdjQrRXly?=
 =?utf-8?B?RTA0Ny9TamlkYW85MGRJTmNseU94ZW9RQWI2ZnJPVlJ6QnJsSVIvU0Zla3lS?=
 =?utf-8?B?RXFvNlRRY2lqOUNEN1c1b2FIaUNZY3ZvdjMxSFRheFY5YlRCQ0wzMXFiajhx?=
 =?utf-8?B?STRlb1BuaEJqMDdkZ3RLd0Y1THA5c0FiMkZONzNwajhZUEI0cytvTk1uTkYx?=
 =?utf-8?B?R29pKy8zK3JKSmtVTzZEem83WlY1aWRuY3VzdkFXUkVXTUxQTEhSby9tdHBP?=
 =?utf-8?B?S0dHNWdtVVFMR0h3UWEwWExVQTdSRDRHSkpZQnRwanhMTXI2VWhEOWVPb3R1?=
 =?utf-8?B?U2NnejRJRkZ0U3FjMlpibEY4MzhXemZiZ2czdXBjNDZ0RGwyYzdoNm1OMFBG?=
 =?utf-8?B?VjU1bmpOb0NSZ1BOd2NzNVRtMGdpbEJhR2NHQktRaGo3VFlMT1k3ZUV5WENM?=
 =?utf-8?B?UWtyWHFMdUFFWmIyM1EwWDYvOW54ZEN4WldkS1lvaG9zdTNTUmNUUGEzcTlR?=
 =?utf-8?B?d2FRNFlRVzYyckN4bWpGeDdiNlZrRGVYaWpROGpJekpFNUYzUmlnUFAyM2Vw?=
 =?utf-8?B?cTlvcmZBMXk4UTFGNnVQT2VhYTBzKy9YR2hWWFR6WDVzakZKa0ZmMnBlS0E1?=
 =?utf-8?B?SzB5a28vMUJqdkNYeC9ka3UrNldxVjhLK00wQ2xzQlVnbS90SUtLSjRPeko2?=
 =?utf-8?B?ZjMxdW1vUUtWN1JPYWppcHVuVjQ3ZWpWd0syd2xqMG9qZ0lYMHdvKzljVk5C?=
 =?utf-8?B?Zm9pOXZMOURXbkRDOCtTY2dueUFEeDlmeHpKL25GcG5rU1BSLzF3UT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 64383ddf-c2d4-4971-a1e9-08dec8814f6b
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 12:51:24.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBsOjCgOnvln6gwkfs9miwfsiGao0dy+UTA46WdNuknU+C0+UXUuT5fEFC/pp6TQUK1H6Y0/xFRsJPgdjNQMJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P189MB2012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0370BA000E
X-Stat-Signature: zoseydcatnn7h4co9yh77d8dou5rpnz3
X-HE-Tag: 1781268689-921564
X-HE-Meta: U2FsdGVkX18naFBwKllnGVId9rXZwIx2HfYPeOgMrdwaWXf2Kp1IV5VWH9FXkEQq3SIF5w01rMn+sVdmyOUkWXEdyrBU81D4R+4QwLbXkeim0lBw9P0ZV6c59ZiM1Wlhq1wQ3UhqwSp3pp4ISy5Vq+90vjPOPqL9m0C3OkLE7KRgIDfDCpfFR2ejPHP/UiIam1SaZCFJRb82OZTQlundx7SkKFs7oiDd7vgfjGB+VhlJDmk0TATodzrBC+oYZlwxtsqgjy8oNhMVOTOMLKDtwZIAXtozQf3MpXHjOjRD6gZWnokAirakRIHY6Yqq/s4LdGAIg8uAWPUjikKEVc3ojKyPlpjWtSSrXonktm2SqTuxzd1nLaihx9AwzByhmkwifg6J6f2j9t7rHbwu0tUkNoHL9xbmgpthA2bb3QyJJpvPMjey5bi0ZKnINnCHLAD/oG+IND6qQSxqbMyq5Acc7o2dPA+e9LTNS7O+hKkYVvSl2v+VJRUDypJ7Prf2yu77+5PcoZIE3Y4jDSc5VgwpzdgoW1fExvXY3aFSYYR7HReJqG0N5JQwsdSwj1Ob7heOUQXgraXNzYxgUOFcxv+p8xVUsdmfBTbwojYwP/NPgibT8mzaEmobYmrwi7UUQUbr2EfPeUYsOSRCc7FpyklDr+k6+lLFX4Ct4frxPQWu1ywsYw/WJeiE/q1qLg3tqHlcdsFzZqBT45RHlwl/whsHUqcdgu5fsi8geT6Yl5bRFrBlPqRwbpNqfmgK3Dx2zfkchox54e7wvvoJMcdDvfD5S216GZHLwzxzM5E9olSfTE3XNVKns/eBt7gP6otV2ibwzGLHb/fLToqFxxnDzGCh2m6qeBk4yzaLu6svlRaQgWhyzl4/y6xGscqJzPtKmbt5X0J5547D3aU8KyAKcbSUak8QOwDm0oBsvhoo5BiCEfgtzL6UcqiSCWSMtyQenEO7sKinmSgLBD7X/HUV6x/
 bFNAtAdw
 Na8WevFCLim/jdj07af+uLvR8WithFKU07G/YgTljyIzCh763rJU4fl8kMzg1IXKqfBCuMY7rBeKZsOaBiybxn6XSIcglLGm5phrrXgTyIbg75URd4keHVLYf3U05WnZK0byUX75uBRFfVKWoEJn1vMOpH2UkNSvPyGXSz2WjlqsurqCVbIUCOpctoaL/PXEGQu9lFA/azuTDRQbSDpqQXLpt7jMzTrLPznY6ZyouJDtVF/rmCo2RPjk7Fu0VxQgkzVsXDGN2aUOF3bT7aIpa+V9nzVNGOELiA4Xbc9VX8NbX+rOIr0FJTEnmi7gvTLkvviWvjb2I0lZMFakt+8lO15vMRl3KNlet6WBomcOOTr+3/8zpqUSlbB52d6m2CvCbfk4hfEAdogcfdQeQPtdovNAEaKoAM1BHEPGl4uBIgefcmCjvbJ4whpuTqAHUh+ksEHdVhT2hP3cI1adQYM9SCCknlEwkbkrkz1D8t1EzVQSN5XOmiK61JLe5OoXtkjbVtkSTS3I58lY3j0FtAU5Ejo1ddQEjrX7yMZf/jaW25nCZN+LOovpnEA4xUYFAdK7d9ob79OpcpRQtas2zQ+Is6miUwElViWLToFWR0y8pi6pLZyaBfCf7+r5VfylCpxbN0QJ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

> On Thu, Jun 11, 2026 at 6:21 PM Yunseong Kim <yunseong.kim@est.tech> wrote:
>>
>> [snip...]
>> ---
>>  include/linux/sched.h  |  10 ++
>>  kernel/Makefile        |   3 +
>>  kernel/kcov.c          |   2 +
>>  kernel/kcov_dataflow.c | 324 +++++++++++++++++++++++++++++++++++++++++++++++++
> 
> I think the total size of kcov_dataflow.c doesn't justify splitting it
> in multiple patches.

Thanks for the feedback. I'll combine the changes into a single patch for the              
next version.

Best regards,
Yunseong


