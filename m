Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B3FDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6206B00BE; Wed,  2 Sep 2026 12:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878CB6B00C0; Wed,  2 Sep 2026 12:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA746B00C2; Wed,  2 Sep 2026 12:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8C46B00BE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB591C02A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:30 +0000 (UTC)
X-FDA: 85169360220.28.3BD21C9
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011010.outbound.protection.outlook.com [52.101.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74BBF18000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=ksClTUIW;
	spf=pass (imf16.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjgV3WYEbLc8ixpAORQ94HfJvkh72uHnLWjgHxd8vqQ=;
	b=r+7DonKkYjPOCwGS8GF03TTj8GwEOcS4IbpKzY7XRBpsaj0z4i23XNX4NfNw2GdsXz+Nl5
	o6hYChHnBMoJxfPsPYZ4YplqQxJFF+0d2HXlOGPKeAC9KQes0g+elTRMrCD1ae3lP2Rp9j
	Ngv1IBZFi9GRnOkK6rv5jWaWeMQ/r6g=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366627;
	b=OCsxCiFBlJ9acY2Y/tzfbmxSwrPGjB7g8BvBZuYYKZWUY5hmP/xhMkiZiR80qw8BnPjxul
	fBfuL6B+76HyigKyJfaLcif9BYCEfKmH+8sFA0VG/YYE4rPhj5qjoqkA7X26xtQVYoObFQ
	wDymik86Uid1kyH+dsJSdBiPJUv7oUY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=ksClTUIW;
	spf=pass (imf16.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeADizS7KydUJ9bk0FEMmd4rNu0poYn41V49Ar1+1Fv5USTS5tmFcY/dqO/75m8CHnBojnwm6SZmNV1YYYp5msH02fTD5lVrnIv59X+D0Ig3L4Sy2xwYcOWoUNLM1Nu+1/hiSuff0i724vsy3qx7Hvjlwiz4izEAfhXSdWoM0TIukiFz3+Fm+YgEKBO+f7TYdWCyroubwrOFlCyhS56ZSqy2PDhZ7iy6LyRJV2a73qrAuvQmJHRU4oDPbrf3qTp/3oWRFGosZBjY/3CJg8bYvg5YDo6XCsGln9HTd/bmn8QibWxK1d+myE1gA/2mT0Ilr5o1CpQ9LDu/mDeBL1AkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjgV3WYEbLc8ixpAORQ94HfJvkh72uHnLWjgHxd8vqQ=;
 b=rs5MlpiAlh7Z/7BdWYAnWcPPxX5iwpqBwHjBM9hBABc2kixBgmVRpZBED8fY0ZfpAwLh0QajO2BH3BU/hsscvpwrRFZzeGGUYCTPw8G/YItH1InmWqwwNSM6gLXYW1+VnLeYDMElmtbVnzI5p3CqYyhbEHlmPnXv7B1S5eTfHnkcUkSMu3F6gcpggoJj5DE4A7fky4qI9zDeop7AWwuPkhpSjz93TKzxa3VHdJKM7LST0jq/oQWL9OlGtV8lAYeGW+1ZdMDCgNlxa1t1YujGKf1+TNGn+mqrLN+Bt1cf4ChD8lZsBqd8Akdw28xQ15kHJpQvRyo3rW+Rm/2GS6Dntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjgV3WYEbLc8ixpAORQ94HfJvkh72uHnLWjgHxd8vqQ=;
 b=ksClTUIWZjCTmVuihgbQub18CrpvlrR0C+3v0dfpjO8D2uvTkiAxTNyjUWCTPhu+OL7fLZe3WHoAHUtIQJCnvGjXzXviCOfcb+kv2nnUlS/6i8UlDl//13ZdQ19rN/tmA4zb+fzFtGutg63Zp4rD3DVzF0sQcwxvnZnvfBjalsNfofj46vEpgnTjsHAioKWA1+EsopjIq1h7CjU6E58EJ843KKBW/SdTOsoglO5jTFn9li33gVn2DdfKZlR8LiCUKIoUGGRRVPGCEzaasbGDUyOnGuN+kIuxQTwBvBVbSBfsVZkPdw3Fsf7nCk8kBCsT3HIV+VJF4JAr73TEJYNgfw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by VI1P18901MB0638.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:30:17 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:30:16 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:41 +0200
Subject: [PATCH RFC v3 8/8] selftests/kcov_dataflow: add trigger-view.py
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-8-824609f279f5@est.tech>
References: <20260902-b4-kcov-dataflow-rfc-v3-v3-0-824609f279f5@est.tech>
In-Reply-To: <20260902-b4-kcov-dataflow-rfc-v3-v3-0-824609f279f5@est.tech>
To: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kbuild@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, llvm@lists.linux.dev, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Marco Elver <elver@google.com>, 
 Nikita Popov <nikic@php.net>, Matt Arsenault <arsenm2@gmail.com>, 
 Justin Stitt <justinstitt@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, Yunseong Kim <yunseong.kim@est.tech>, 
 Yunseong Kim <ysk@kzalloc.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=48236;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=tswooNWmOgPTK/uzQAJg7hZ1hKBdyHZ8V7aShEccya8=;
 b=SsTG9QZFQaTkmWDZlbpHggybz9ykeHBbl2sK0FOQ+990SuY9jk6H4j3G0MrBCf/XaRuluieFs
 kL34Akv4e56AhvR4hfuCApcebh8in5ioUlkKEWRxgitN3Rk3yJEy5JM
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: FR4P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::6) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|VI1P18901MB0638:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a2c9658-cee1-41ba-d5fb-08df090f78dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|6133799003|56012099006|10067099003|11063799006|9063799003|22082099003|18002099003|3023799007|5023799004;
X-Microsoft-Antispam-Message-Info:
	OuQEG8PYpN07Vp2oxQRyY7fgfzfoW0RACk+ky8vUMS0Q2WNUWAE2VivZmkye/QIrXkK2Ql3gMMTC7ow04oXOh8hMo5v+LAiAiDQfO6pwA6WRXbekwUizuHuaZjLXnMU2uS0syS7ZkWtxIQd/hJ9PCter0n2xnxxygIIOAYVtoIaku4Lb8wgswPJtkkPzzfaMvUyzuyxiD+DAum1Hy2mCc5bdGmR7e2pt4Tnwrh3ynrSpX7qkhsVxkai5yYgtEMGgEgoGiy0GHKliC5GbDwJyTU1xN0UxojrIkIZc2v3PYvXiIRhvb+rVo7AEJ7305fkg8/CVzxc9b/HzTTikVP61jTAKKFjN4jRjPJPYsjzm5WeaDhkpL3zgfZ6QEw0baticV2VZ7cgvvtRZk3igLFwBFyyrXGfD2OwfPq+uPCypYOW7k4er/ItIouvqkqdqlX8yY/80PV7fPxaVpuWBZJTx4bKgV8QaBRHE5MEU81Ye2qh7/Z8FH6GUnLrJT1tCt/VquC7f+Dnezk0pqWd3z3wpd9ZPX4qMVCoq6D57VkAtZSeEeFlCNpZbJ58p0IKJ7CHmE4Fr57vnUyUHK2SM3XXevVsbhdC+1i70+25j9Q/u9aVK0fJsRcbmmsjiBEBi9JRL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(6133799003)(56012099006)(10067099003)(11063799006)(9063799003)(22082099003)(18002099003)(3023799007)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aE9ydTFtakd2MktHSFR5MmkrS1NTdGRpbkcvV1A2Y0t0cTlHVXd5OVpEdGxR?=
 =?utf-8?B?VVEzcXFHSXZldmhidjFySzZRem94bVBJWllLWWJmM1dvNHJ1MFVkMk01aWVw?=
 =?utf-8?B?MnVycXdwa1BsbnYyV200cmI1RFNMVjMvTnhqdHZNVFlyalI4Y3M0RXBrQlNU?=
 =?utf-8?B?eTFpSCtoZmFBQ1UzV0Zqb09nRVpObHowdzZNbERFc2dzTW8ySDk4dUFiT3ZE?=
 =?utf-8?B?SVhwTkJJN1dzd1A3YXJyOHFmVml3YnRkUzQxMm9nOUNpOG9NZVcyczFSODVD?=
 =?utf-8?B?VXJFNHFlWjQ0SWlrNmRFbjJwYUo3WlZ1a0VpRWs5eEEvVEVuMlpGY0FhS2M5?=
 =?utf-8?B?cUpXNDdpVHdOczlKQzBJRUxya0tmTFNLUEpVa2J4NGt6RTRXOUQ2Y0ZqeDly?=
 =?utf-8?B?cFpReG41NkFUeS9PTXpyaHpzcU0wTDZZMG5QWHhqZE9aTFdja0dIQXpBVU9T?=
 =?utf-8?B?WGhWM2ZNWU9PclZyYVp0MEtHU2ZRbWh5d0dsOVlMY2FXYVpRNWszYm1UZy9m?=
 =?utf-8?B?NURqU3lXZ25MNUNna2tzUEhMdkpKdGJqTzk0WDNOekZDZEpnekc5ODFyWG5w?=
 =?utf-8?B?RkR1VEhlOWRmNjJ4b3pxNXJNMzJOWXo3NXFCTW1TRlJhdWxVay9WcW5FVVEw?=
 =?utf-8?B?MndlNDhCT1lIaEVBZUJiNHVIcGY1cFo1c0NWUndsbVR5TzlROEVtTDNnblZB?=
 =?utf-8?B?Y2RsNzFsWFdFbzlzQ0cyYUdsTDhZZHEzbG5BZmFWSDNaaTZJV2lYZDQ5VEIw?=
 =?utf-8?B?MmZSTU0rcWZOOTI4YytsS2R6amovVlNITWNJc2h3V3JZdEptUmtYZ2pVditF?=
 =?utf-8?B?Y0xGZ0tYSHZTcDZJbWh1Qk0vbWNYQXhnaHNIZlhsN1FTQ2kvNnlVY3YyQ2xp?=
 =?utf-8?B?WnR6aGV6RjBBeFVBWkx6NDRWOTdyQTU5TWw0SGtBSlFlRkhSTDJmek1oK1hB?=
 =?utf-8?B?R2lheGVRaWRiaWwyWXJ2akp2dE9hcEhIUGRoSXF6MWFDUWM1aUsvU2Q3VkFn?=
 =?utf-8?B?aXhqMCtZNlRCaE03V2dkWGZiTlRSRnk0SDBLYXFJRlkrVlM0RnRibVlIVmhq?=
 =?utf-8?B?UWxmUkdLaUhwOGhoRWdYb3NrYTV6cUI5a0t5akVqVGszTFl0R3JkemtWZmM3?=
 =?utf-8?B?N1B3eHQzVVI5eEp0TGpCTkJhZGdWdFg3NUQ4S2JkRUtCa3pXaSs2VzBWcWdK?=
 =?utf-8?B?V3FzR0FRVjFHenhqWXFZc25zZU0vNkdQUUxsZjREOG44TUM1dUFzcGRXdWdH?=
 =?utf-8?B?OExhZUlsWkZ4R2ZYd1lMTjdLMktQT0lqcGYrOHpPRzEvUUtyNkpMNTZzSGFr?=
 =?utf-8?B?YTN4SlljbnJkdHg1ekhpVVZtT2R2bHFyT1Jyc2hhUkZ0Ni9sWXJXRXU0NUdq?=
 =?utf-8?B?RHRnVVVveFFBS1pqb1YwclNuNnU2aTFpZEhxV0JGOEttQkxqSlkrRU8vZTVr?=
 =?utf-8?B?Rk5ZZ20xbUUwUTN1WUlUc1VyaVhnMFdKdGxMMm5NK1hXZGN6MnpFZ2RVRWxE?=
 =?utf-8?B?L3BhNkNFUXEzbU9kSVVWYUdSUk9VQi94UlRyT3FYVHhOMTd3KytPKzZucjZx?=
 =?utf-8?B?MFlid1djT3FHMTZYMXM3Z3Y2b3BVbUcvek5FYldoVGY1QlpIb01MWkdaM1RV?=
 =?utf-8?B?WTRKU1pyNFduN2JVRTlCcFU3b0FzWUlmbi9sdGRzK25KQmMxMjlCNzJ1RVBK?=
 =?utf-8?B?Vjc5cWJtUVlDUE1WeHl2eW1xbWMrMEQ2OGxMUHR6Snh0WS92NC9PK3FIMTZk?=
 =?utf-8?B?eVBsVXpJWEk3ejlUMy9EbUphN2llUmVnbWhKQ0NsMmdQcUtNUGtMejEzcnJ4?=
 =?utf-8?B?MHltTXdERVlkRDhpWkwrVXBoTUVYRjROUHhoTTJXWnVZSUNDeWFFTFVjQ0NT?=
 =?utf-8?B?WHR0eHgzNWVUeUduVjF3R0M5aUFKZ0UyMlo1RE9SSTNiNkltMk1TbVBWZnNs?=
 =?utf-8?B?V3ZzMTlIMzRzWDBvTlFrTHNacnJLWWlucnpLSmRkai94ZW1CMEJNbk5xNjMr?=
 =?utf-8?B?VUIxb2N4UU5ZMFJaRGVRTnc2bnZDZy8vY1ovS3A4eHJxdGVLK09YczhKY2Qy?=
 =?utf-8?B?SW5NOGVqSFE3Z1A2YWthQURKUCtlZCswZmJxdUxxZjFmK0NJai91eFdDY201?=
 =?utf-8?B?TWVSaVdwcGhIVTJqWEszU1FXUXRENGF5TU9Qdi8vVWhOQ0NvSkxWMmNwcE8x?=
 =?utf-8?B?TDU1VmxNZWU1MnJMa01ISWQ0KzI1ZU5NZ284K21YcWZuNlQ2eHpjeENBS2U1?=
 =?utf-8?B?L1BUcFdsSldFbk4wd1d1V2VGQ0s4Q21wT0dVM0REc1c4VXdPSk9rN1FhaStP?=
 =?utf-8?B?QW1oSlZCVUFKM2lNTjZhZ1BicVZCYjJSRU1aR1IvbFJMMTlaSDhNUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2c9658-cee1-41ba-d5fb-08df090f78dc
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:30:16.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKRtgzIU2rqVMnPXcd3scxTwSXArFTjeO4UjHkwsyatfSr/VfwpjPBFsIMn4YNuMrEBBxZSeynvQ5opaWEqeMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0638
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74BBF18000C
X-Stat-Signature: mq713ipykahkep1xa5wtyaihti1kica9
X-HE-Tag: 1788366627-116029
X-HE-Meta: U2FsdGVkX18b/CusWtsOKWLHLxZx6Zl2IaG65izQ5omU6zuwnd4MUpSW8AuFXuzLz+i0eODmXYLjphx8/ohKS94zWRWEkUsYjB/lQkyDPDRIpaD9pHqKMzE/StlOV0tg7NgK733sJ4hI+CnxR/+HBc0aK7UmDC+WHgBF9+fcQDLP7Z9a1xuKpIjllqDVYLTjdBHm40MQuldOOl4toNp9llcEoUZ2sYZXOddqMSHY05M1qCBSL9xETpw1FTQD+OGcHn5niapjJ5XvQqqJxWGfxG2j3Lcb54t6T+hj5WhZDnl7UoF2R8CB42DdT0Zd0vg+5mUrTUy8/BO2jUhFQPRelq+20eaw9oicvw2gKqcayy0LbDJeHAcvYRHRP9wN18pH46NLdt9cyGLT+rAjLIsWZbGoen7i+NUGtOf9ZUIAtRzEYFzvkHMQ39zQj6AnemO2izW8lX/8IrnpRi7RuCfuh4h4z9OOYzIcnQ3l9+QaiM5D75M0wrblVJXvL4bL5cJEMSssfNCCB3k1HbT+mFNhb49msAAOQcX+lLfoFJV2+7kxOjI9P+Bw00iguoH7vUJ4EmvZ32DYPM1yTmurTKnOjgyHHgTOzbn3TJgnmJ9Kkot2ML+bPx2TP5NXaILtmaS8OGhxlkoa4XEmZF6iio+IzT/6Jx6U+gRq00O+e86E4Jvo5Tx+w519XGqsy2+kJYhtTEOGFpYIDVpcSLhcwjKWji7pVgY6ercpB+6nwVMlSxO6NTPO7lI5n0svdy8s+SqkHcZjnfr1B7mLTapYiS2p3qctjFi0b9+Zj5pMlpevprMczdmBnRTL13v1sEXlNCbOPKXb38eIJtnw7CC91oomNsL9bKdsigBhqspLUB+saEMdolGtCK30Hoh0Hh55oZfU9tnJSCOa5g1q1G7jQRSah4+ECubx3stmtCbYYXtyCy78UT+4TP2RUTrrpvJnvZ1l8mKcHtgmY4ty+xuSrhh
 WPoKMtMB
 cts0mj1qgB0RjZGAqIu8cn14q2cggqAjzimmiVA0Rs2V2Gh/M9aHyksa6xtxDQye6O8/8AGxJlBpgrAdVw5PpdCEqOADQ0/ta3dDdJkMs94F5fZBVN0UOD/PET7SZ9oi4+xLfh3NLKeVBv/N3g0munsOJYz1n21hQa4WrLa3MtPe36RAQAeTc1dch3ML96gMA/j2ggrzTfvfCgaTorKoHvnhLiENCt6QDHiAEQWKzfErKe/OI9VtVK4m+maMz+p+fp+qew4rAbqrIbm1NixcrLaGay5tGwZitbym8FaWznIIUrvQCA4iShOqedwBV2IpTJOx3chUrTW7FUM307EE5gi/TDlWpFIgN/QzpqLoQmQF+qtl4riY4W4qgtiyUEUWqebN6Qw0JPGFDBzldcsAnMCyyQbTIjeIQoi/xRAdmydWo/ExNZeBbAp+lg6swrfX5Ytcq7HI+I5mIMbTs6Kil4iNnGMguflY751ObTZPrjukjlfxBN2rSqSmYndurduSqeMRV16fjbZ4DG+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire the kcov_dataflow test modules into a standard kselftest target and
add the viewer they are built on.

trigger-view.py loads a module with finit_module(), enables recording
(KCOV_DF_ENABLE, or KCOV_DF_REMOTE_ENABLE with "--remote" argument),
writes the module's debugfs trigger file, unloads it, and decodes
the buffer into a call tree or, with "--raw", a flat record list.
It symbolizes PCs against a vmlinux with addr2line or against
/proc/kallsyms, adding the running kernel's KASLR offset back to
the recorded PCs (runtime _text minus the link-time _text from
System.map / nm / a per-architecture default), and demangles
Rust v0 symbols.

test_modules.py is the KTAP runner: it drives run_capture() from
trigger-view.py for each module and compares the captured arguments,
struct fields and return values against the values the module uses
emitting the module's call tree as diagnostics. A test passes only
when the data came back intact, not merely when records appeared.
Modules that were not built are reported as SKIP.

The Makefile builds user_ioctl and binderfs as ordinary kselftest
programs and the .ko modules via Kbuild against KDIR (the Rust ones only
when the configured kernel has CONFIG_RUST=y); config lists the kernel
options the tests need, and settings raises the per-test timeout for the
in-VM runs. The whole target builds with

  make -C tools/testing/selftests TARGETS=kcov_dataflow \
       LLVM=1 CC=clang [RUSTC=... RUST_LIB_SRC=...]

and runs under run_kselftest.sh.

Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 tools/testing/selftests/kcov_dataflow/.gitignore   |   4 +
 tools/testing/selftests/kcov_dataflow/Kbuild       |  10 +
 tools/testing/selftests/kcov_dataflow/Makefile     |  46 ++
 tools/testing/selftests/kcov_dataflow/README.rst   |  69 ++
 tools/testing/selftests/kcov_dataflow/config       |  11 +
 tools/testing/selftests/kcov_dataflow/settings     |   1 +
 .../selftests/kcov_dataflow/test_modules.py        | 249 +++++++
 .../selftests/kcov_dataflow/trigger-view.py        | 755 +++++++++++++++++++++
 8 files changed, 1145 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/.gitignore b/tools/testing/selftests/kcov_dataflow/.gitignore
new file mode 100644
index 0000000000000..4f2957a017957
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/.gitignore
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+user_ioctl/user_ioctl
+binderfs/binderfs_test
+__pycache__/
diff --git a/tools/testing/selftests/kcov_dataflow/Kbuild b/tools/testing/selftests/kcov_dataflow/Kbuild
new file mode 100644
index 0000000000000..2e19e9008fdca
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/Kbuild
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test modules, built as external modules against the configured kernel tree
+# by the selftest Makefile ("make -C $(KDIR) M=$(CURDIR) modules"). Every
+# directory opts its object into dataflow instrumentation with
+# KCOV_DATAFLOW_<object>.o := y, the same per-file switch in-tree code uses.
+obj-m				+= rust_ffi_contract/
+obj-m				+= eight_struct_args_c/
+obj-$(CONFIG_RUST)		+= eight_struct_args_rust/
+obj-$(CONFIG_RUST)		+= rust_kworker_remote/
diff --git a/tools/testing/selftests/kcov_dataflow/Makefile b/tools/testing/selftests/kcov_dataflow/Makefile
new file mode 100644
index 0000000000000..fc979e2d4ecc3
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/Makefile
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# kcov_dataflow selftests
+#
+# user_ioctl and binderfs are ordinary kselftest programs. The test modules
+# (one per directory, listed in Kbuild) are built by kbuild against KDIR and
+# are loaded, triggered and checked by test_modules.py; trigger-view.py is
+# the interactive viewer the runner is built on.
+#
+# KDIR is the configured kernel build tree. It defaults to the source tree
+# this directory lives in; point it at the O= directory for out-of-tree
+# builds. Pass the same LLVM=1 CC=clang [RUSTC= RUST_LIB_SRC=] the kernel was
+# built with so that kbuild picks the toolchain that has the trace-args and
+# trace-ret passes.
+KDIR ?= $(abspath ../../../..)
+
+TEST_GEN_PROGS := user_ioctl/user_ioctl binderfs/binderfs_test
+TEST_PROGS := test_modules.py
+TEST_FILES := trigger-view.py
+
+CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
+
+# The .ko files kbuild produces for KDIR's configuration, so that they are
+# built by "all" and copied by "install"; the Rust modules need CONFIG_RUST.
+KMODS := rust_ffi_contract eight_struct_args_c
+ifneq ($(shell grep -s ^CONFIG_RUST=y $(KDIR)/.config),)
+KMODS += eight_struct_args_rust rust_kworker_remote
+endif
+TEST_GEN_FILES := $(foreach m,$(KMODS),$(m)/$(m).ko)
+
+include ../lib.mk
+
+ifneq ($(wildcard $(KDIR)/.config),)
+$(TEST_GEN_FILES): modules
+modules:
+	$(Q)$(MAKE) -C $(KDIR) M=$(CURDIR) modules
+clean_modules:
+	$(Q)$(MAKE) -C $(KDIR) M=$(CURDIR) clean
+else
+$(TEST_GEN_FILES):
+	@echo "SKIP $(notdir $@): no configured kernel tree at $(KDIR), set KDIR="
+clean_modules:
+endif
+
+clean: clean_modules
+.PHONY: modules clean_modules
diff --git a/tools/testing/selftests/kcov_dataflow/README.rst b/tools/testing/selftests/kcov_dataflow/README.rst
new file mode 100644
index 0000000000000..1929a357aca47
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/README.rst
@@ -0,0 +1,69 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests
+=======================
+
+Selftests for ``/sys/kernel/debug/kcov_dataflow`` (see
+Documentation/dev-tools/kcov-dataflow.rst).
+
+Layout
+------
+
+Makefile, Kbuild
+    kselftest build: the C programs are built by lib.mk, the test modules
+    (one directory each, listed in Kbuild) by kbuild against ``KDIR``.
+user_ioctl/
+    ioctl interface test (kselftest harness, TAP).
+binderfs/
+    binder ioctls under recording (TAP).
+rust_ffi_contract/, eight_struct_args_c/, eight_struct_args_rust/,
+rust_kworker_remote/
+    test modules; each README.rst says what the module exercises.
+test_modules.py
+    KTAP runner: loads every module, triggers it with recording active and
+    checks the captured arguments, struct fields and return values against
+    the values the module uses. Modules that are not built are SKIPped.
+trigger-view.py
+    Interactive viewer the runner is built on (call tree or ``--raw``
+    records, kallsyms/addr2line symbolization, ``--remote`` capture).
+
+Kernel
+------
+
+The kernel and the modules must be built with a clang that has the
+trace-args/trace-ret passes (and, for the Rust modules, a rustc built
+against that LLVM). The config fragment ``config`` lists what the tests
+need; with virtme-ng::
+
+    vng --build --config tools/testing/selftests/kcov_dataflow/config \
+        LLVM=1 CC=clang RUSTC=$RUSTC RUST_LIB_SRC=$RUST_LIB_SRC
+
+Build
+-----
+
+From the kernel tree, with the same toolchain variables::
+
+    make LLVM=1 headers
+    make -C tools/testing/selftests TARGETS=kcov_dataflow \
+        LLVM=1 CC=clang RUSTC=$RUSTC RUST_LIB_SRC=$RUST_LIB_SRC
+
+``KDIR`` defaults to the source tree; pass ``KDIR=<O dir>`` for out-of-tree
+builds. The Rust modules are built only when ``KDIR/.config`` has
+``CONFIG_RUST=y``. ``make ... install INSTALL_PATH=<dir>`` produces a
+self-contained tree with ``run_kselftest.sh``.
+
+Run
+---
+
+On the target (root, debugfs mounted)::
+
+    vng --user root --exec \
+        "tools/testing/selftests/kcov_dataflow/test_modules.py"
+    tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl
+    tools/testing/selftests/kcov_dataflow/binderfs/binderfs_test
+
+or, from an installed tree, ``run_kselftest.sh -c kcov_dataflow``.
+``test_modules.py -t <module> -C 8`` runs one module and echoes eight
+records of context around each module record; ``trigger-view.py <module>
+[--raw] [-C N] [--remote] [--vmlinux vmlinux]`` shows the capture
+without checking it.
diff --git a/tools/testing/selftests/kcov_dataflow/config b/tools/testing/selftests/kcov_dataflow/config
new file mode 100644
index 0000000000000..7f3a2fda0641d
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/config
@@ -0,0 +1,11 @@
+CONFIG_KCOV=y
+CONFIG_KCOV_DATAFLOW_ARGS=y
+CONFIG_KCOV_DATAFLOW_RET=y
+CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y
+CONFIG_KCOV_DATAFLOW_NO_INLINE=y
+CONFIG_DEBUG_INFO_DWARF5=y
+CONFIG_DEBUG_FS=y
+CONFIG_MODULES=y
+CONFIG_ANDROID_BINDER_IPC=y
+CONFIG_ANDROID_BINDERFS=y
+CONFIG_RUST=y
diff --git a/tools/testing/selftests/kcov_dataflow/settings b/tools/testing/selftests/kcov_dataflow/settings
new file mode 100644
index 0000000000000..694d70710ff08
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/settings
@@ -0,0 +1 @@
+timeout=300
diff --git a/tools/testing/selftests/kcov_dataflow/test_modules.py b/tools/testing/selftests/kcov_dataflow/test_modules.py
new file mode 100755
index 0000000000000..13cb706a06ff6
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/test_modules.py
@@ -0,0 +1,249 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+"""
+test_modules.py - run the kcov_dataflow test modules, one KTAP test each.
+
+Every module is loaded, triggered with recording active and unloaded by
+trigger-view.py's run_capture(). The records that belong to the module are
+then compared with the values its trigger function passes and returns, so a
+test passes only when the instrumented arguments, struct field expansions
+and return values came back intact through the kcov_dataflow buffer. The
+module's call tree is echoed as KTAP diagnostics.
+
+    ./test_modules.py                 # all modules
+    ./test_modules.py -t rust_ffi_contract -C 8 --vmlinux vmlinux
+
+Modules that were not built (no CONFIG_RUST, no toolchain) are reported as
+SKIP; a kernel without /sys/kernel/debug/kcov_dataflow skips everything.
+"""
+import argparse
+import contextlib
+import importlib.util
+import io
+import os
+import sys
+
+HERE = os.path.dirname(os.path.abspath(__file__))
+sys.path.insert(0, os.path.join(HERE, "..", "kselftest"))
+import ksft  # noqa: E402
+
+
+def _load_trigger_view():
+    spec = importlib.util.spec_from_file_location(
+        "trigger_view", os.path.join(HERE, "trigger-view.py"))
+    mod = importlib.util.module_from_spec(spec)
+    spec.loader.exec_module(mod)
+    return mod
+
+
+tv = _load_trigger_view()
+
+
+class Check:
+    """Collects expectation failures for one module."""
+
+    def __init__(self):
+        self.failures = []
+
+    def eq(self, what, got, want):
+        if got != want:
+            self.failures.append(f"{what}: got {fmt(got)}, want {fmt(want)}")
+
+    def true(self, what, cond):
+        if not cond:
+            self.failures.append(what)
+
+
+def fmt(v):
+    if isinstance(v, list):
+        return "[" + ", ".join(fmt(x) for x in v) + "]"
+    if isinstance(v, int):
+        return f"0x{v:x}"
+    return str(v)
+
+
+def entries(cap, recs, func):
+    return [r for r in recs if r["type"] == tv.DF_TYPE_ENTRY and func in cap.funcs(r)]
+
+
+def rets(cap, recs, func):
+    return [r["val"] for r in recs if r["type"] == tv.DF_TYPE_RET and func in cap.funcs(r)]
+
+
+def flat_sum(n):
+    """sf_n() returns a->a + b->b + ... over s1..sn: 0x11 + 0x22 + ..."""
+    return sum(0x11 * k for k in range(1, n + 1))
+
+
+def nested_sum(n, _memo={}):
+    """
+    stf_n()/stpf_n() return field0 (0x11 * n) plus the recursive sums of the
+    embedded st1..st(n-1); the same values are used for the value-nested and
+    the pointer-linked towers.
+    """
+    if n not in _memo:
+        _memo[n] = 0x11 * n + sum(nested_sum(k) for k in range(1, n))
+    return _memo[n]
+
+
+def check_struct_family(cap, recs, c, p, flat_ns, stpf8_runs):
+    """
+    Shared expectations for eight_struct_args_c (p="") and
+    eight_struct_args_rust (p="r"): @flat_ns are the sf_N called by the
+    trigger, @stpf8_runs how often the pointer-linked tower is walked.
+    """
+    for n in flat_ns:
+        ents = entries(cap, recs, f"{p}sf_{n}")
+        c.true(f"{p}sf_{n}: ENTRY records", bool(ents))
+        for k in range(n):
+            # arg k is a struct s(k+1) * whose fields are 0x11, 0x22, ...
+            got = [r["vals"] for r in ents if r["arg_idx"] == k]
+            c.true(f"{p}sf_{n} arg[{k}]: ENTRY record", bool(got))
+            for vals in got:
+                c.eq(f"{p}sf_{n} arg[{k}] expanded fields", vals,
+                     [0x11 * (j + 1) for j in range(k + 1)])
+        # rustc may alias identical bodies (rsf_1 == rstf_1), so the RET
+        # list can carry the alias's calls too: check every value.
+        got = rets(cap, recs, f"{p}sf_{n}")
+        c.true(f"{p}sf_{n} RET values all {fmt(flat_sum(n))}: {fmt(got)}",
+               bool(got) and all(v == flat_sum(n) for v in got))
+
+    for fam, calls in ((f"{p}stf", 1), (f"{p}stpf", stpf8_runs)):
+        for n in range(1, 9):
+            got = rets(cap, recs, f"{fam}_{n}")
+            c.true(f"{fam}_{n}: RET records", bool(got))
+            c.true(f"{fam}_{n} RET values all {fmt(nested_sum(n))}: {fmt(got)}",
+                   all(v == nested_sum(n) for v in got))
+        c.eq(f"{fam}_8 RET count", len(rets(cap, recs, f"{fam}_8")), calls)
+
+    for f in (f"{p}sf_fwd", f"{p}sf_fwd_inner"):
+        c.eq(f"{f} RET", rets(cap, recs, f), [flat_sum(4)])
+
+    c.true(f"{p}sf_ret_struct: ENTRY records",
+           bool(entries(cap, recs, f"{p}sf_ret_struct")))
+    c.true(f"{p}sf_ret_struct: RET record",
+           bool(rets(cap, recs, f"{p}sf_ret_struct")))
+
+
+def check_eight_struct_args_c(cap, recs, c):
+    check_struct_family(cap, recs, c, "", range(1, 9), stpf8_runs=2)
+
+
+def check_eight_struct_args_rust(cap, recs, c):
+    check_struct_family(cap, recs, c, "r", (1, 2, 4, 8), stpf8_runs=1)
+
+
+def check_rust_ffi_contract(cap, recs, c):
+    """
+    ffi_alloc_buf(&alloc = {NULL, 0, 0, 0}, 256, 16, is_async=1) records
+    data_size + offsets_size and returns 0 without filling alloc->buffer;
+    ffi_check_result() then sees {NULL, 0x110, 0, 0}. The records must show
+    the violated contract at both boundaries.
+    """
+    ents = entries(cap, recs, "ffi_alloc_buf")
+    by_arg = {r["arg_idx"]: r for r in ents}
+    c.eq("ffi_alloc_buf ENTRY arg indexes", sorted(by_arg), [0, 1, 2, 3])
+    if 0 in by_arg:
+        c.eq("ffi_alloc_buf arg[0] struct ffi_alloc fields",
+             by_arg[0]["vals"], [0, 0, 0, 0])
+    if 1 in by_arg:
+        c.eq("ffi_alloc_buf arg[1] data_size", by_arg[1]["val"], 256)
+    if 2 in by_arg:
+        c.eq("ffi_alloc_buf arg[2] offsets_size", by_arg[2]["val"], 16)
+    if 3 in by_arg:
+        c.eq("ffi_alloc_buf arg[3] is_async", by_arg[3]["val"], 1)
+    c.eq("ffi_alloc_buf RET (claims success)", rets(cap, recs, "ffi_alloc_buf"), [0])
+
+    ents = entries(cap, recs, "ffi_check_result")
+    c.true("ffi_check_result: ENTRY record", bool(ents))
+    for r in ents:
+        c.eq("ffi_check_result arg[0] {buffer NULL: contract violated, "
+             "data_size, free_async, flags}", r["vals"], [0, 0x110, 0, 0])
+    got = rets(cap, recs, "ffi_check_result")
+    c.true(f"ffi_check_result RET -EFAULT: {fmt(got)}",
+           len(got) == 1 and got[0] & 0xffffffff == 0xfffffff2)
+
+
+def check_rust_kworker_remote(cap, recs, c):
+    """
+    The trigger only queues a work item and waits; the records come from the
+    kworker that called kcov_df_remote_start(REMOTE_HANDLE). All three phases
+    of CompositeStore must show up (v0-mangled names keep the method names).
+    """
+    c.true("records captured from the kworker", bool(recs))
+    names = set().union(*(cap.funcs(r) for r in recs)) if recs else set()
+    for phase in ("populate", "update", "drain"):
+        c.true(f"CompositeStore::{phase} recorded",
+               any("CompositeStore" in n and phase in n for n in names))
+
+
+TESTS = (
+    ("rust_ffi_contract", False, check_rust_ffi_contract),
+    ("eight_struct_args_c", False, check_eight_struct_args_c),
+    ("eight_struct_args_rust", False, check_eight_struct_args_rust),
+    ("rust_kworker_remote", True, check_rust_kworker_remote),
+)
+
+
+def diag_tree(cap, recs, vmlinux):
+    out = io.StringIO()
+    with contextlib.redirect_stdout(out):
+        tv.print_tree(recs, cap.syms, vmlinux, {}, cap.ko_path,
+                      cap.mod_text_start)
+    for line in out.getvalue().splitlines():
+        ksft.print_msg(line)
+
+
+def main():
+    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
+    parser.add_argument("-t", "--test", action="append",
+                        help="run only this module (repeatable)")
+    parser.add_argument("-C", "--context", type=int, default=0,
+                        help="echo N records before/after each module record")
+    parser.add_argument("--vmlinux", help="vmlinux for addr2line and KASLR")
+    args = parser.parse_args()
+
+    tests = [t for t in TESTS if not args.test or t[0] in args.test]
+    ksft.print_header()
+    ksft.set_plan(len(tests))
+
+    skip_all = None
+    if not os.path.exists(tv.KCOV_DF_PATH):
+        skip_all = f"{tv.KCOV_DF_PATH} not available (CONFIG_KCOV_DATAFLOW_ARGS/RET)"
+    elif os.geteuid() != 0:
+        skip_all = "must run as root"
+
+    vmlinux = tv.find_vmlinux(args.vmlinux)
+    for name, remote, check in tests:
+        if skip_all:
+            ksft.test_result_skip(f"{name}: {skip_all}")
+            continue
+        ko = tv.find_module(name)
+        if not ko:
+            ksft.test_result_skip(f"{name}: {name}.ko not built")
+            continue
+        try:
+            cap = tv.run_capture(ko, remote=remote, vmlinux=vmlinux,
+                                 log=ksft.print_msg)
+        except OSError as e:
+            ksft.test_result_fail(f"{name}: {e}")
+            continue
+
+        recs = cap.module_records()
+        ksft.print_msg(f"{name}: {cap.total_words} words, {len(cap.records)} "
+                       f"records, {len(recs)} from {name} "
+                       f"(kaslr_offset=0x{cap.kaslr_offset:x})")
+        diag_tree(cap, cap.context_records(args.context) if args.context
+                  else recs, vmlinux)
+
+        c = Check()
+        check(cap, recs, c)
+        for f in c.failures:
+            ksft.print_msg(f"FAIL {name}: {f}")
+        ksft.test_result(not c.failures, name)
+
+    ksft.finished()
+
+
+if __name__ == "__main__":
+    main()
diff --git a/tools/testing/selftests/kcov_dataflow/trigger-view.py b/tools/testing/selftests/kcov_dataflow/trigger-view.py
new file mode 100755
index 0000000000000..b17e49da402d7
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/trigger-view.py
@@ -0,0 +1,755 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+"""
+trigger-view.py - Load a test module, trigger it with kcov_dataflow
+recording active, then pretty-print the captured records.
+
+Usage:
+    python3 trigger-view.py eight_struct_args_c
+    python3 trigger-view.py rust_ffi_contract --raw -C 8
+    python3 trigger-view.py rust_kworker_remote --remote
+    python3 trigger-view.py <module> --vmlinux vmlinux --kaslr-offset 0x...
+
+run_capture() does the work and is also what test_modules.py drives:
+  1. Opens /sys/kernel/debug/kcov_dataflow, inits and mmaps the buffer
+  2. Loads the module via finit_module() (its init noise is not recorded)
+  3. Enables recording: KCOV_DF_ENABLE for this task, or with --remote
+     KCOV_DF_REMOTE_ENABLE with handle REMOTE_HANDLE, which the module's
+     kworker opens with kcov_df_remote_start(REMOTE_HANDLE)
+  4. Writes the trigger file(s) the module created under TRIGGER_DIR
+  5. Disables recording and unloads the module
+  6. Parses the records (layout: include/uapi/linux/kcov_dataflow.h)
+
+The CLI then prints them as a call tree, or flat with --raw, with kallsyms
+symbol resolution and addr2line source lines (vmlinux / module .ko).
+
+Recorded PCs have the KASLR offset removed (same as mainline kcov), so
+the runtime offset is derived from /proc/kallsyms and System.map / vmlinux
+(or a per-architecture default) and added back for symbolization; use
+--kaslr-offset to override. Records must contain at least one value word
+and one of the three record types, otherwise the parser resyncs word by
+word (e.g. after a userspace reset of area[0] mid-run).
+"""
+import os
+import sys
+import struct
+import ctypes
+import ctypes.util
+import argparse
+import fcntl
+import platform
+import subprocess
+import shutil
+
+# Constants -- must match include/uapi/linux/kcov_dataflow.h
+DF_TYPE_CMP = 0xC
+DF_TYPE_ENTRY = 0xE
+DF_TYPE_RET = 0xF
+MAGIC_BAD = 0xBADADD85
+BUF_SIZE = 1048576  # 1M words = 8MB
+
+# Record header word: bits 0-23 seq | 28-31 type | 32-47 nvals |
+# 48-55 arg/ret size | 56-63 arg index. Word 1 is the pc (KASLR offset
+# removed, like mainline kcov), word 2 the traced pointer (ENTRY/RET) or the
+# comparison type (CMP), then nvals value words.
+def hdr_seq(h):
+    return h & 0x00FFFFFF
+
+def hdr_type(h):
+    return (h >> 28) & 0xF
+
+def hdr_nvals(h):
+    return (h >> 32) & 0xFFFF
+
+def hdr_size(h):
+    return (h >> 48) & 0xFF
+
+def hdr_arg_idx(h):
+    return (h >> 56) & 0xFF
+
+RECORD_HDR_WORDS = 3
+
+# Runtime KASLR offset (see kaslr_offset()); added back to every recorded pc
+# so /proc/kallsyms lookups work, subtracted again for addr2line on vmlinux.
+KASLR_OFFSET = 0
+
+# Ioctl numbers
+def _IOR(t, nr, size):
+    return (2 << 30) | (ord(t) << 8) | nr | (size << 16)
+
+def _IOW(t, nr, size):
+    return (1 << 30) | (ord(t) << 8) | nr | (size << 16)
+
+def _IO(t, nr):
+    return (ord(t) << 8) | nr
+
+KCOV_DF_INIT_TRACK = _IOR('d', 1, 8)
+KCOV_DF_ENABLE = _IO('d', 100)
+KCOV_DF_DISABLE = _IO('d', 101)
+KCOV_DF_REMOTE_ENABLE = _IOW('d', 102, 8)  # arg: pointer to a __u64 handle
+KCOV_DF_REMOTE_DISABLE = _IO('d', 103)
+
+KCOV_DF_PATH = "/sys/kernel/debug/kcov_dataflow"
+
+# Every test module creates its trigger file(s) in this debugfs directory;
+# writing to them runs the instrumented test functions.
+TRIGGER_DIR = "/sys/kernel/debug/kcov_dataflow_test"
+
+# Remote handle registered with KCOV_DF_REMOTE_ENABLE; must match the
+# kcov_df_remote_start(1) call in the rust_kworker_remote test module
+# (KCOV_SUBSYSTEM_COMMON, instance 1).
+REMOTE_HANDLE = 1
+
+# syscall numbers
+_machine = platform.machine()
+if _machine == "aarch64":
+    SYS_FINIT_MODULE = 273
+    SYS_DELETE_MODULE = 106
+else:  # x86_64
+    SYS_FINIT_MODULE = 313
+    SYS_DELETE_MODULE = 176
+
+SELFTEST_DIR = os.path.dirname(os.path.abspath(__file__))
+
+
+def load_kallsyms():
+    """Load kernel symbols for PC resolution."""
+    syms = []
+    try:
+        with open("/proc/kallsyms") as f:
+            for line in f:
+                parts = line.split()
+                if len(parts) >= 3:
+                    addr = int(parts[0], 16)
+                    name = parts[2]
+                    mod = parts[3].strip("[]") if len(parts) > 3 else ""
+                    syms.append((addr, name, mod))
+    except (PermissionError, FileNotFoundError):
+        pass
+    syms.sort()
+    return syms
+
+
+def runtime_text(syms):
+    """Runtime address of _text from kallsyms, 0 if hidden."""
+    return next((a for a, n, m in syms if n == "_text" and not m), 0)
+
+
+# Link-time address of _text per architecture, used only when neither
+# System.map nor vmlinux is available: x86_64 __START_KERNEL
+# (__START_KERNEL_map + CONFIG_PHYSICAL_START), arm64 KIMAGE_VADDR.
+LINKTIME_TEXT_DEFAULT = {
+    "x86_64": 0xffffffff81000000,
+    "aarch64": 0xffff800080000000,
+}
+
+
+def linktime_text(vmlinux=None):
+    """Return (link-time address of _text, source description) or (0, "")."""
+    rel = os.uname().release
+    candidates = []
+    if vmlinux:
+        candidates.append(os.path.join(os.path.dirname(vmlinux) or ".", "System.map"))
+    candidates += ["System.map", f"/boot/System.map-{rel}",
+                   f"/usr/lib/debug/boot/System.map-{rel}"]
+    for sm in candidates:
+        try:
+            with open(sm) as f:
+                for line in f:
+                    parts = line.split()
+                    if len(parts) == 3 and parts[2] == "_text":
+                        return int(parts[0], 16), sm
+        except (OSError, ValueError):
+            continue
+    if vmlinux and shutil.which("nm"):
+        try:
+            r = subprocess.run(["nm", "--defined-only", vmlinux],
+                               capture_output=True, text=True, timeout=300)
+            for line in r.stdout.splitlines():
+                parts = line.split()
+                if len(parts) == 3 and parts[2] == "_text":
+                    return int(parts[0], 16), f"nm {vmlinux}"
+        except (OSError, subprocess.TimeoutExpired):
+            pass
+    link = LINKTIME_TEXT_DEFAULT.get(platform.machine(), 0)
+    return link, f"{platform.machine()} default" if link else ""
+
+
+def kaslr_offset(syms, vmlinux=None):
+    """
+    Runtime KASLR offset: recorded PCs have it removed (kcov's
+    canonicalize_ip()), /proc/kallsyms has it applied. Computed as the
+    runtime _text (kallsyms) minus the link-time _text (System.map, nm
+    vmlinux, or the architecture default). KASLR offsets are 2 MiB aligned
+    on x86_64 and arm64, which is used as a sanity check on the result.
+    """
+    runtime = runtime_text(syms)
+    if not runtime:
+        print("# warning: _text not in /proc/kallsyms (kptr_restrict?); "
+              "PCs will not symbolize", file=sys.stderr)
+        return 0
+    link, source = linktime_text(vmlinux)
+    if not link:
+        print(f"# warning: no System.map/vmlinux and no default _text for "
+              f"{platform.machine()}; pass --kaslr-offset", file=sys.stderr)
+        return 0
+    off = runtime - link
+    if off % (2 << 20):
+        print(f"# warning: kaslr offset 0x{off:x} from {source} is not 2 MiB "
+              f"aligned; check CONFIG_PHYSICAL_START/KIMAGE_VADDR or pass "
+              f"--kaslr-offset", file=sys.stderr)
+    return off
+
+
+# Rust symbol demangling via llvm-cxxfilt or rustfilt
+_demangler = None
+
+def _init_demangler():
+    global _demangler
+    for tool in ["llvm-cxxfilt", "rustfilt", "c++filt"]:
+        path = shutil.which(tool)
+        if path:
+            _demangler = path
+            return
+    _demangler = ""
+
+_demangled = {}
+
+def demangle(name):
+    """Demangle a Rust/C++ symbol name (memoized: one process per name)."""
+    global _demangler
+    if _demangler is None:
+        _init_demangler()
+    if not _demangler or not name.startswith("_R"):
+        return name
+    if name not in _demangled:
+        try:
+            r = subprocess.run([_demangler, name], capture_output=True,
+                               text=True, timeout=2)
+            _demangled[name] = r.stdout.strip() if r.returncode == 0 else name
+        except (OSError, subprocess.TimeoutExpired):
+            _demangled[name] = name
+    return _demangled[name]
+
+
+def find_vmlinux(vmlinux=None):
+    """Locate vmlinux for addr2line: explicit path, else the usual places."""
+    if vmlinux:
+        return vmlinux
+    for p in ["vmlinux", "/boot/vmlinux", "/usr/lib/debug/boot/vmlinux"]:
+        if os.path.exists(p):
+            return p
+    return None
+
+
+def _a2l_target(pc, vmlinux, ko_path, mod_text_base):
+    """(binary, address in it) to symbolize pc with, or None."""
+    if ko_path and mod_text_base and pc >= mod_text_base:
+        return ko_path, pc - mod_text_base
+    if vmlinux:
+        return vmlinux, pc - KASLR_OFFSET  # vmlinux holds link-time addresses
+    return None
+
+
+def resolve_lines(pcs, vmlinux, cache, ko_path=None, mod_text_base=0):
+    """
+    Resolve every pc in @pcs to file:line into @cache, one addr2line run
+    per binary: a DWARF5 vmlinux takes hundreds of ms to open, so one
+    process per record does not scale to thousands of records.
+    """
+    todo = {}
+    for pc in pcs:
+        if pc in cache:
+            continue
+        cache[pc] = ""
+        tgt = _a2l_target(pc, vmlinux, ko_path, mod_text_base)
+        if tgt:
+            todo.setdefault(tgt[0], []).append((pc, tgt[1]))
+    for binary, pairs in todo.items():
+        try:
+            r = subprocess.run(
+                ["addr2line", "-e", binary] + [f"0x{a:x}" for _, a in pairs],
+                capture_output=True, text=True, timeout=300)
+        except (subprocess.TimeoutExpired, FileNotFoundError):
+            continue
+        for (pc, _), loc in zip(pairs, r.stdout.splitlines()):
+            loc = loc.strip()
+            if loc and loc != "??:0" and loc != "??:?":
+                # Shorten path: keep only filename:line
+                cache[pc] = loc.rsplit("/", 1)[-1]
+
+
+def resolve_line(pc, vmlinux, cache, ko_path=None, mod_text_base=0):
+    """Resolve one PC to source file:line using addr2line (cached)."""
+    if pc not in cache:
+        resolve_lines([pc], vmlinux, cache, ko_path, mod_text_base)
+    return cache[pc]
+
+
+def get_kernel_meta():
+    """Collect kernel build metadata."""
+    meta = {"release": os.uname().release}
+    try:
+        with open("/proc/version") as f:
+            v = f.read().strip()
+        meta["version"] = v
+        # Extract compiler version
+        if "gcc" in v.lower():
+            meta["compiler"] = v.split("(")[1].split(")")[0] if "(" in v else ""
+        elif "clang" in v.lower():
+            idx = v.lower().find("clang")
+            meta["compiler"] = v[idx:idx+30].split(")")[0]
+    except OSError:
+        pass
+    return meta
+
+
+def print_kernel_meta(meta, ko_path=None):
+    """Print kernel metadata header/footer."""
+    print(f"# {'=' * 60}")
+    print(f"# Kernel: {meta.get('release', 'unknown')}")
+    print(f"# Build:  {meta.get('version', 'unknown')[:80]}")
+    if meta.get('compiler'):
+        print(f"# Compiler: {meta['compiler']}")
+    # Read rustc version from .ko .comment section
+    if ko_path:
+        try:
+            r = subprocess.run(
+                ["readelf", "-p", ".comment", ko_path],
+                capture_output=True, text=True, timeout=5)
+            for line in r.stdout.splitlines():
+                if "rustc" in line:
+                    ver = line.split("]", 1)[-1].strip()
+                    print(f"# Rustc: {ver}")
+                    break
+        except (OSError, subprocess.TimeoutExpired):
+            pass
+    print(f"# {'=' * 60}")
+
+
+def lookup(pc, syms):
+    """Nearest kallsyms entry <= pc as (name, offset, module) or None."""
+    if not syms:
+        return None
+    lo, hi = 0, len(syms) - 1
+    while lo < hi:
+        mid = (lo + hi + 1) // 2
+        if syms[mid][0] <= pc:
+            lo = mid
+        else:
+            hi = mid - 1
+    addr, name, mod = syms[lo]
+    if addr > pc:
+        return None
+    return name, pc - addr, mod
+
+
+def symbolize(pc, syms):
+    """Find nearest symbol <= pc. Returns (display_name, module_tag)."""
+    hit = lookup(pc, syms)
+    if not hit:
+        return f"0x{pc:x}", ""
+    name, offset, mod = hit
+    dname = demangle(name)
+    display = f"{dname}+0x{offset:x}" if offset else dname
+    return display, f" [{mod}]" if mod else ""
+
+
+def format_val(v):
+    """Format a captured value."""
+    if v == MAGIC_BAD:
+        return "FAULT"
+    if v == 0:
+        return "0x0"
+    return f"0x{v:x}"
+
+
+def find_module(name):
+    """
+    Find the .ko for test @name: <name>/<name>.ko in the source tree, or
+    <name>.ko next to this script in an installed (make install) tree.
+    """
+    for ko_path in (os.path.join(SELFTEST_DIR, name, f"{name}.ko"),
+                    os.path.join(SELFTEST_DIR, f"{name}.ko")):
+        if os.path.exists(ko_path):
+            return ko_path
+    return None
+
+
+def finit_module(ko_path):
+    """Load a kernel module via finit_module syscall."""
+    libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
+    fd = os.open(ko_path, os.O_RDONLY)
+    ret = libc.syscall(SYS_FINIT_MODULE, fd, b"", 0)
+    os.close(fd)
+    if ret != 0:
+        errno = ctypes.get_errno()
+        raise OSError(errno, f"finit_module({ko_path}): {os.strerror(errno)}")
+
+
+def delete_module(name):
+    """Unload a kernel module."""
+    libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
+    ret = libc.syscall(SYS_DELETE_MODULE, name.encode(), 0)
+    if ret != 0:
+        errno = ctypes.get_errno()
+        raise OSError(errno, f"delete_module({name}): {os.strerror(errno)}")
+
+
+def trigger_module():
+    """
+    Write to every trigger file the loaded module created under TRIGGER_DIR.
+    Opened without O_CREAT: debugfs directories have no ->create, so a
+    "w"-mode open of a missing name fails with EOPNOTSUPP, not ENOENT.
+    """
+    try:
+        names = sorted(os.listdir(TRIGGER_DIR))
+    except OSError:
+        names = []
+    hits = []
+    for n in names:
+        path = os.path.join(TRIGGER_DIR, n)
+        try:
+            fd = os.open(path, os.O_WRONLY)
+        except OSError:
+            continue
+        try:
+            os.write(fd, b"1")
+        finally:
+            os.close(fd)
+        hits.append(path)
+    if not hits:
+        raise FileNotFoundError(f"no trigger file under {TRIGGER_DIR}")
+    return hits
+
+
+def parse_records(buf, total_words):
+    """Parse the ring buffer into a list of records."""
+    records = []
+    pos = 1
+    end = min(1 + total_words, BUF_SIZE)
+    while pos + RECORD_HDR_WORDS <= end:
+        hdr = buf[pos]
+        rtype = hdr_type(hdr)
+        num_vals = hdr_nvals(hdr)
+
+        # Every record the kernel writes has nvals >= 1 and a known type;
+        # anything else is garbage (e.g. a userspace reset mid-run): resync.
+        if rtype not in (DF_TYPE_ENTRY, DF_TYPE_RET, DF_TYPE_CMP) \
+                or num_vals == 0 or pos + RECORD_HDR_WORDS + num_vals > end:
+            pos += 1
+            continue
+
+        pc = int(buf[pos + 1]) + KASLR_OFFSET
+        ptr = int(buf[pos + 2])  # ENTRY/RET: traced pointer; CMP: cmp type
+        if rtype == DF_TYPE_CMP:
+            pos += RECORD_HDR_WORDS + num_vals
+            continue
+
+        # Valid records always have a non-zero PC (kernel text address)
+        if pc == 0:
+            pos += 1
+            continue
+
+        vals = [int(buf[pos + RECORD_HDR_WORDS + vi]) for vi in range(num_vals)]
+        records.append({
+            "type": rtype,
+            "seq": hdr_seq(hdr),
+            "pc": pc,
+            "ptr": ptr,
+            "arg_idx": hdr_arg_idx(hdr),
+            "size": hdr_size(hdr),
+            "val": vals[0],
+            "vals": vals,
+        })
+        pos += RECORD_HDR_WORDS + num_vals
+    return records
+
+
+class Capture:
+    """Everything run_capture() collected for one module run."""
+
+    def __init__(self, ko_path, mod_name, records, syms, total_words,
+                 mod_text_start, kaslr_off):
+        self.ko_path = ko_path
+        self.mod_name = mod_name
+        self.records = records
+        self.syms = syms
+        self.total_words = total_words
+        self.mod_text_start = mod_text_start
+        self.kaslr_offset = kaslr_off
+        self.runtime_text = runtime_text(syms)
+        self._mod_syms = any(m == mod_name for _, _, m in syms)
+        # Aliases: rustc's merge-functions makes identical bodies (e.g. the
+        # one-field rsf_1 and rstf_1) share one address, so a PC can carry
+        # several names.
+        self._names = {}
+        for addr, name, mod in syms:
+            self._names.setdefault((addr, mod), set()).add(name)
+
+    def is_module_pc(self, pc):
+        """True if pc lies in the test module (kallsyms, else .text start)."""
+        if self._mod_syms:
+            hit = lookup(pc, self.syms)
+            return bool(hit) and hit[2] == self.mod_name
+        # Fallback: if no module symbols (kptr_restrict), use .text start
+        return bool(self.mod_text_start) and pc >= self.mod_text_start
+
+    def funcs(self, rec):
+        """All raw kallsyms names of the function a record belongs to."""
+        hit = lookup(rec["pc"], self.syms)
+        if not hit:
+            return set()
+        name, offset, mod = hit
+        return self._names.get((rec["pc"] - offset, mod), {name})
+
+    def module_records(self):
+        return [r for r in self.records if self.is_module_pc(r["pc"])]
+
+    def context_records(self, n):
+        """Module records plus n records before/after each of them."""
+        keep = set()
+        for i, r in enumerate(self.records):
+            if self.is_module_pc(r["pc"]):
+                keep.update(range(max(0, i - n),
+                                  min(len(self.records), i + n + 1)))
+        return [self.records[i] for i in sorted(keep)]
+
+
+def run_capture(ko_path, remote=False, vmlinux=None, kaslr_override=None,
+                log=None):
+    """
+    Load @ko_path, record while its trigger file(s) are written, unload it
+    and return a Capture. @remote publishes the buffer for REMOTE_HANDLE
+    instead of enabling recording for this task. Raises OSError.
+    """
+    global KASLR_OFFSET
+    log = log or (lambda msg: print(f"# {msg}"))
+
+    # Ensure kallsyms shows real addresses
+    try:
+        with open("/proc/sys/kernel/kptr_restrict", "w") as f:
+            f.write("0")
+    except OSError:
+        pass
+
+    df_fd = os.open(KCOV_DF_PATH, os.O_RDWR)
+    try:
+        # Init + mmap
+        fcntl.ioctl(df_fd, KCOV_DF_INIT_TRACK, BUF_SIZE)
+        libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
+        libc.mmap.restype = ctypes.c_void_p
+        libc.mmap.argtypes = [
+            ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int,
+            ctypes.c_int, ctypes.c_int, ctypes.c_long
+        ]
+        buf_ptr = libc.mmap(None, BUF_SIZE * 8, 0x3, 0x01, df_fd, 0)
+        if buf_ptr == ctypes.c_void_p(-1).value:
+            errno = ctypes.get_errno()
+            raise OSError(errno, f"mmap: {os.strerror(errno)}")
+        buf = (ctypes.c_uint64 * BUF_SIZE).from_address(buf_ptr)
+
+        # Load module first (its init generates noise with INSTRUMENT_ALL)
+        mod_name = os.path.basename(ko_path).replace(".ko", "")
+        finit_module(ko_path)
+        log(f"Loaded {mod_name}")
+        try:
+            # Module .text address, the PC filter fallback without kallsyms
+            mod_text_start = 0
+            try:
+                with open(f"/sys/module/{mod_name}/sections/.text") as f:
+                    mod_text_start = int(f.read().strip(), 16)
+            except (OSError, ValueError):
+                pass
+
+            # Enable recording AFTER load, BEFORE trigger (no loader noise).
+            # Remote: the handle is passed by pointer (a __u64 in a buffer),
+            # so the full 64-bit value survives 32-bit/compat callers.
+            if remote:
+                fcntl.ioctl(df_fd, KCOV_DF_REMOTE_ENABLE,
+                            struct.pack("Q", REMOTE_HANDLE))
+            else:
+                fcntl.ioctl(df_fd, KCOV_DF_ENABLE, 0)
+            buf[0] = 0
+            try:
+                for path in trigger_module():
+                    log(f"Triggered {path}")
+            finally:
+                fcntl.ioctl(df_fd, KCOV_DF_REMOTE_DISABLE if remote
+                            else KCOV_DF_DISABLE, 0)
+
+            # Read kallsyms while the module is still loaded
+            syms = load_kallsyms()
+        finally:
+            try:
+                delete_module(mod_name)
+            except OSError as e:
+                log(f"warning: {e}")
+
+        if kaslr_override is not None:
+            KASLR_OFFSET = kaslr_override
+        else:
+            KASLR_OFFSET = kaslr_offset(syms, find_vmlinux(vmlinux))
+
+        total = int(buf[0])
+        records = parse_records(buf, total)
+        return Capture(ko_path, mod_name, records, syms, total,
+                       mod_text_start, KASLR_OFFSET)
+    finally:
+        os.close(df_fd)
+
+
+def print_raw(records, syms, vmlinux=None, cache=None, ko_path=None, mod_text_base=0):
+    """Print records in raw format with source line on left."""
+    if cache is None:
+        cache = {}
+    # Pre-resolve all locations (one addr2line run) to find max width
+    resolve_lines([r["pc"] for r in records], vmlinux, cache, ko_path,
+                  mod_text_base)
+    locs = [cache[r["pc"]] for r in records]
+    max_w = max((len(l) for l in locs if l), default=0)
+    max_w = max(max_w, 10)  # minimum width
+
+    for i, r in enumerate(records):
+        name, mod = symbolize(r["pc"], syms)
+        sym = f"{name}{mod}"
+        t = "ENTRY" if r["type"] == DF_TYPE_ENTRY else "RET  "
+        arg_idx = r["arg_idx"]
+        size = r["size"]
+        left = f"{locs[i]:>{max_w}s}" if locs[i] else f"{'':>{max_w}s}"
+        vals = format_val(r["val"]) if len(r["vals"]) == 1 else \
+            "{" + ", ".join(format_val(v) for v in r["vals"]) + "}"
+        print(f"{left}   [{t}] seq={r['seq']:3d} {sym} "
+              f"arg[{arg_idx}]({size}) @0x{r['ptr']:x} = {vals}")
+
+
+def print_tree(records, syms, vmlinux=None, cache=None, ko_path=None, mod_text_base=0):
+    """Print records as indented call tree with source line on left."""
+    if cache is None:
+        cache = {}
+    # Pre-resolve all PCs (one addr2line run) for alignment
+    resolve_lines([r["pc"] for r in records], vmlinux, cache, ko_path,
+                  mod_text_base)
+    max_w = max((len(v) for v in cache.values() if v), default=10)
+    max_w = max(max_w, 10)
+
+    depth = 0
+    call_stack = []  # Stack of (name, mod, args_str, pc) for matching returns
+    i = 0
+    while i < len(records):
+        r = records[i]
+        name, mod = symbolize(r["pc"], syms)
+
+        if r["type"] == DF_TYPE_ENTRY:
+            # Collect all args for this call (same PC, consecutive entries);
+            # order by index, as the pass emits dead-arg traces last.
+            args = []
+            pc = r["pc"]
+            while i < len(records) and records[i]["type"] == DF_TYPE_ENTRY \
+                    and records[i]["pc"] == pc:
+                vals = records[i]["vals"]
+                if len(vals) > 1:
+                    fields = ", ".join(format_val(v) for v in vals)
+                    args.append((records[i]["arg_idx"], "{" + fields + "}"))
+                else:
+                    args.append((records[i]["arg_idx"],
+                                 format_val(records[i]["val"])))
+                i += 1
+            args_str = ", ".join(a for _, a in sorted(args, key=lambda x: x[0]))
+            call_stack.append((name, mod, args_str, pc))
+            depth += 1
+        else:
+            # Pop void calls (no return record) until we find matching PC
+            while call_stack and call_stack[-1][3] != r["pc"]:
+                depth = max(0, depth - 1)
+                indent = "  " * depth
+                vname, vmod, vargs, vpc = call_stack.pop()
+                loc = resolve_line(vpc, vmlinux, cache, ko_path, mod_text_base)
+                left = f"{loc:>{max_w}s}" if loc else f"{'':>{max_w}s}"
+                print(f"{left}   {indent}{vname}({vargs}){vmod}")
+            depth = max(0, depth - 1)
+            indent = "  " * depth
+            ret_size = r["size"]
+            loc = resolve_line(r["pc"], vmlinux, cache, ko_path, mod_text_base)
+            left = f"{loc:>{max_w}s}" if loc else f"{'':>{max_w}s}"
+            if call_stack:
+                cname, cmod, cargs, _ = call_stack.pop()
+                if ret_size == 0:
+                    print(f"{left}   {indent}{cname}({cargs}){cmod}")
+                else:
+                    print(f"{left}   {indent}{format_val(r['val'])} = {cname}({cargs}){cmod}")
+            else:
+                if ret_size == 0:
+                    print(f"{left}   {indent}{name}(){mod}")
+                else:
+                    print(f"{left}   {indent}{format_val(r['val'])} = {name}(){mod}")
+            i += 1
+
+    # Flush remaining void calls on the stack
+    while call_stack:
+        depth = max(0, depth - 1)
+        indent = "  " * depth
+        vname, vmod, vargs, vpc = call_stack.pop()
+        loc = resolve_line(vpc, vmlinux, cache, ko_path, mod_text_base)
+        left = f"{loc:>{max_w}s}" if loc else f"{'':>{max_w}s}"
+        print(f"{left}   {indent}{vname}({vargs}){vmod}")
+
+
+def main():
+    parser = argparse.ArgumentParser(
+        description="Load a test module with kcov_dataflow and view records")
+    parser.add_argument("module", help="Test module name (e.g. eight_struct_args_c)")
+    parser.add_argument("--raw", action="store_true",
+                        help="Print raw records instead of tree")
+    parser.add_argument("--ko", help="Explicit path to .ko file")
+    parser.add_argument("--context", "-C", type=int, default=0,
+                        help="Show N records before/after each module record")
+    parser.add_argument("--vmlinux", help="Path to vmlinux for addr2line")
+    parser.add_argument("--remote", action="store_true",
+                        help="Use KCOV_DF_REMOTE_ENABLE for kworker capture")
+    parser.add_argument("--kaslr-offset", type=lambda x: int(x, 0),
+                        help="Override the runtime KASLR offset added to PCs")
+    args = parser.parse_args()
+
+    ko_path = args.ko or find_module(args.module)
+    if not ko_path or not os.path.exists(ko_path):
+        print(f"Cannot find module for '{args.module}'", file=sys.stderr)
+        print("Build it first: make -C tools/testing/selftests "
+              "TARGETS=kcov_dataflow LLVM=1 CC=clang", file=sys.stderr)
+        sys.exit(1)
+
+    try:
+        cap = run_capture(ko_path, remote=args.remote, vmlinux=args.vmlinux,
+                          kaslr_override=args.kaslr_offset)
+    except OSError as e:
+        print(f"{args.module}: {e}", file=sys.stderr)
+        sys.exit(1)
+
+    print(f"# Captured {cap.total_words} words (kaslr_offset=0x{cap.kaslr_offset:x}, "
+          f"_text=0x{cap.runtime_text:x})")
+    print(f"# {len(cap.records)} records")
+
+    if cap.syms or cap.mod_text_start:
+        if args.context > 0:
+            records = cap.context_records(args.context)
+            print(f"# showing {len(records)} records with context={args.context} "
+                  f"around {cap.mod_name}\n")
+        else:
+            records = cap.module_records()
+            print(f"# {len(records)} from {cap.mod_name}\n")
+    else:
+        records = cap.records
+        print("")
+
+    meta = get_kernel_meta()
+    print_kernel_meta(meta, ko_path=ko_path)
+
+    vmlinux = find_vmlinux(args.vmlinux)
+    show = print_raw if args.raw else print_tree
+    show(records, cap.syms, vmlinux, {}, ko_path, cap.mod_text_start)
+
+    print_kernel_meta(meta, ko_path=ko_path)
+
+
+if __name__ == "__main__":
+    main()

-- 
2.47.3


