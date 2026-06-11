Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F2FCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4806B00A6; Thu, 11 Jun 2026 12:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2973A6B00A7; Thu, 11 Jun 2026 12:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F7B6B00A8; Thu, 11 Jun 2026 12:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D675B6B00A6
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4DDE1C27B8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:11 +0000 (UTC)
X-FDA: 84868148862.01.2371824
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011058.outbound.protection.outlook.com [52.101.65.58])
	by imf18.hostedemail.com (Postfix) with ESMTP id A25A01C000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=CtTaCVBb;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194928;
	b=CULKEUt3ZJo73w4AgodwdvdX8SzhWki7KF8sYamAqBYUHnaxtS85FLD9E/65f7akLPUld5
	xhTyLfsZsOc+/IiBX8l7Y3cuY3t80R+4P6kXJcCdJn8gnG7viz41b/rWLB4GJlB/rZOa5U
	NtZxBzwJqer5woA2SD4Vr+pa148CQpo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=CtTaCVBb;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psY6a90e3/sLp+Oj5S4FiGYhmUJhRZQVAjwBzfCgPHU=;
	b=Gv4Fd2BmRAsMpQteukrA1PqUL2cOqrmjYwYa9LjKnZpWAbXh8eWye5i0gOR6G1+vW1DpFt
	VnyzJADnqXvqhmvc6uHtO0BwXzrarsU0FHtpY+B1GWoCzxbsLosaj1qwhQp+oFVjR+RYsF
	2qZrEIGyPMOeeytir3Jo7QGQBgiZhCc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=frPrbC5IEkI2ApUDjmJOTqYZuz2RBKPWgMC2TmA84EsJUrYG/a9BSaqQUCQAtEr74kGi7bjPn/S1h8h8Lbas/0wgGyQScQx6+WEp35IQzYQHqyt2wWlNI1oOqKxTkpbY9lNqpxP5t32p10DLd4+q2kS1KZsAiZBLdiK3qghE5fSTsUbC6Zr1i2aTBzUZtc3sGf30/AiritkopI8fAdBfiEpgLx37HSX7X7fIchj3RVKVrqdGDTykDu2jL3W3Uiri+l0ubDNipWXCOrRIqMBDyHMAai0r2gUstgoz5JZ/+6FjPTixhrfIlvsWPEi0wLMMroGJ7e+uV/U31Q1J4mLddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psY6a90e3/sLp+Oj5S4FiGYhmUJhRZQVAjwBzfCgPHU=;
 b=K1pap0lZUjM8y8xTTCmKiItjGn+IM+L4flrCWHkw8Mo2r0uK9UQsQ64IVjB+j62W9MPxqXRV8NZP4eRb9QLqsPP6O+IfmU8/ABC5AeJWfC0aoHpLtSpZ9eiX0G0LMk8AurqdKkqdsRvak1CMa3DazM1XmwUa25zlkvnisBvw6uvWtXNdTk7HQvd/CLQ/n9WTnww26jR5KKe/emkrrUzO0/KoRxbyqcwt4Ut8zIWhrVB1b2Nebq3VHA+Bwsk3pR6tAOsIFXasLWc/p/jE5GOr8EEYxag3O6ajUKg56bA+vZVd+Dd+fVgrZSFWNDtvYvHXWJIt8WLZ37PLgyFudD4yAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psY6a90e3/sLp+Oj5S4FiGYhmUJhRZQVAjwBzfCgPHU=;
 b=CtTaCVBblVnx/w6HwDxzBjibcgvsRSCE49u8IH75LRohIiq8TgFWPrulRQeROVYYYUiR5QPkJhHdfWzk7NnkKUij9JWJZQ4kvQBEH6Oirs0OxL1dPzsk4JqKrHJwbWmaDdkj1ixKHN02R3rdrMfgvGKtKQwxJ8yjyiAawiAKaOE4jNOz0VOQHZn/vQymtF/O2NU4Sj+eQfdTcG2IEZNWWMXyoWCJaoTMFKQLC3GFDcY4gDkRdqoC6ddPzES7BiUd/9Flp8MrdkVFK+8LgxmL47Va7Q5+Zmlkvr8FfVSQWGcPHlDY+4PTTE1geMSWWvMo+/hH0kIeGgILCHTKB/DejQ==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:58 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:58 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:14 +0200
Subject: [RFC PATCH v2 12/14] selftests/kcov_dataflow: add
 rust_ffi_contract test module
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-12-0a261da3987c@est.tech>
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
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=9250;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=YNHRJxU7pBEgkggxGz5sDX5HG43rBjCaNfca9paR2Fk=;
 b=8cDztotREPor/G6xcbhmpILOlAgxGYlwU+i7il0yY4g3T/qI7SskicjdN3rMs9iPkQOnDAMXs
 HVC5MntnHluDLOk1wOBp80N2giabqVzG2JcEh5HlMCqyBCo5hq4mJ2L
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBF0.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::315) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: de428a95-98ca-42db-ea15-08dec7d58f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ITX49KV1ZIsoniDnALyWs8CIWp9pf2nzwcRph/luzxZthhe+gQzLHQ3EfnQfaTYZDjKtylOPYADPh2Ygy6Ag58S+35iBUkR0e/5dNXKMCYUM8hwvV4UfeWUgo3Go/EY2GoA8T1S7cR4Iq6I1BHM/Nobu8aHac4/l7hdLN1ON/B+CzduarPmI+uNFJL/vzjOpyoNNuMagPNjORM/S6noA6vC7SYwdfjlOWGbXTWH7CEJ/D8dF5x6ivXrJpYKq4yccVWDRjP7HCjXs712qvImsWHiy+jxA0PWUVgNNkXikYHVwRHPkytTG/UNMhQ7IiVJprmWrgQjgCJRu0w609qWnbhJ7mFy2Bc9vhwNG/vdjExXGIH96ULagL/e2tqXfHlTCYt0OG/blS+pZP6DmOuicxDK1ew22GXr8NFwblC6eG9IhK2nmHKZVtgeexJfBtggjihca74JX0Ay20Awa/fLsJMtXDlAjte7PbDtxAfnRLQHHeET2zYc9EAU8R7JC+ZS4E5kfvux/1/muYSYM48LhAGYz5YZCFtvhI07m8i6yEWeUITJydkOqyWzh9c7N0QsUlVcffRVBTWMglMweH1xPqD1dbY9Ge/M76+j7SMTSovwDoSlJYKoiL8O5o2wYRQfI96MRPozuW8CdQ+gL9Aacm3lkfL7sJAebx3qdgr/9fqscKhn+5abHBWm5Uuh9i90AczUvhWFovPFbpMW4kVHG6s0NFebGimnwyRDfGWniD9zs6x17ECy8aT3g0TEwLVS1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHg4RGc3ekdvR25zWjhQRUZPbUtMSXp4Q0d2dk1oU3UzdHk4YmVLUUZFakRL?=
 =?utf-8?B?UXM4SklDdlcxUnd1RWZ5MGR3ZEVzdGRrQm1LZmMwWDB6NkE2NnArSkdnVzVG?=
 =?utf-8?B?anYyNFY4WlhpOVU0TU41b0tML092aVRlSmpGNVgrclhsWkl6UkxNZDBOQWtm?=
 =?utf-8?B?YVNuTDQ4TS93M0pkN1RXeXVRclFibmk0L3dmc25ya2RRNFJwWUhLb1NzZmJN?=
 =?utf-8?B?MVJHeHFZbVRqOUNvbFRRNDIvLzdUQmhrVnpJem14SmtyN2FZV2Nrd3JPdWdu?=
 =?utf-8?B?cDVncEhncG5jN3QvZjZ1NjhiaFhJZVVCYkRURFZzallQRlFxZWtBMWEzOE5Q?=
 =?utf-8?B?QW9rYWxqVURvY1hLaHNMbnZleHBTQkNXMXExeEU3SlVrbEI4RDZNRWNPeWI3?=
 =?utf-8?B?a0kySUIybGlSMHBnZGkxNzRBWUdmZVJrUy9GaXNGR0kyN3NJcFdRTXFwMk1s?=
 =?utf-8?B?UTB1NWphMCtQM1U2aFNvT0drYjFqSFBDZWw0bDFqbXhkOHFITk10QTJ3YzJO?=
 =?utf-8?B?bFBmOGdqMzZIQXlUR3p0OHJuazdOeUNxSXZQdnozcDFoRFBNODJHTC9pQmJu?=
 =?utf-8?B?QUlyczR2ZnBLa3BMbEpyTGphU2ROSGJBaFVrL0F2VDJ4OXptd2hHRVp3d1hZ?=
 =?utf-8?B?Y3FXVHBQTTFCS0xIKzE2TEhRRlJHRzhsS29LK2tsbkJ1TlRDckhZSGFjRWVw?=
 =?utf-8?B?RVd0M0VEME9OWnhTeUhHQUg1TG9ucnVDa2lhMkQxanFLM2V1SUhORVYvVkU0?=
 =?utf-8?B?Mk1nblVLZU5WM2ltcUlZU0IrZ2lBZWVHY2tQSDFJbWhHNTZ4S1ZWNnU4U2VF?=
 =?utf-8?B?dDNmWnkxeDVHcXFjMnNKcjJodENmbEIzMDI2bUk1eDRFRVZ4WGJyZ05ncStx?=
 =?utf-8?B?NnEvME9vWjBWT0tZUDArRGhiY0NEZHBmK1lZbERuKzU1a3NSeE1jb2l0MFNM?=
 =?utf-8?B?SnFKbFozM2VoaWV0YjIxazhCYXI4MmhheVZhVXdIQUZTcWhxWTMzTWZ2SEVF?=
 =?utf-8?B?TXUvNExJTEE4VVhLOGpObUl5ckZuNExqeHdxZ2loQUZWSy8rVncwWGJ5ejND?=
 =?utf-8?B?WXpicGc3QTczUVVvUnpPOHNySDlodEZFbVFZYTBvaCtuRzVEODdDd3Ezay9B?=
 =?utf-8?B?ejZUVlZvK013bTFSbjJTKzBCZ1V2S2I4eFlNR3VHWkpJL0VkM3R2ZWtWazll?=
 =?utf-8?B?MldtYmlkZDdiZzlKSnkvYjc1TVlwcnlJLzhpQSs5VG1CSUo3SmpkL0FWM2Na?=
 =?utf-8?B?bzZ2YmRwVG9VeWg0K0NBSUdBcHlVVk52K1NlZms2aGNSY2MxNzZrYm84ckFa?=
 =?utf-8?B?OGYzaUFXQmVOOHVWOFZodDBBNHpYK3Z6aFhiWER5R3h6c0JXSGNYaGJvMys5?=
 =?utf-8?B?MmN5cTRzVTk1Ukd0VUs5QXI3U3NnNjloOXZDWmhKd2R0MmpLMGxZTmdBRm5K?=
 =?utf-8?B?NFpFRW53aVRCSG5Id2pUVUk1UWpGNEFyVXVoZnhLQzdRa01hVnloczNaQ1dm?=
 =?utf-8?B?T0hObmdrQkFaZDBxbnJpZUFCZmhnTGhPbStPcFJvTnZFYmloYldaajRTQldi?=
 =?utf-8?B?TUYxVXdvVW5ZZDA0VzhvRytRVXJuNTlIenhiMG9PSzBWWEt3dVU0OGxpZ09Q?=
 =?utf-8?B?Z0dDUmRHS2p0dytuMGVlTGhFSTVWOTZBeEE1NlMxNENHRGxieE1hZEhwRFov?=
 =?utf-8?B?ZmRqU2VkeWRKWTNEOVU3Y2trS2piZk1TWGtoS3cxQW9YYVpUMWlGYmx0Zy9N?=
 =?utf-8?B?cWNkeG1LZDVFdUpSN0FoREw3bWcwY1FIanR6MFlVZ01ibjB4RzBZMkk0Q0xE?=
 =?utf-8?B?MXhUS2gzYnFIWjhTcUpLbDJyWGVWMlN2dThXdllwRzF1SVI0T3E1WWNIa1Mz?=
 =?utf-8?B?WFhIMHlIRUpTVG5sVmJmT1JSRkFJMTl3SnBOeTdyb2VzM285cW1Ub2N2OURR?=
 =?utf-8?B?WSt6aDRUMUlnSVpGNjVxbW9vV2liWTVkM2dkWVBBTVBJa283dUg1dis5eEdD?=
 =?utf-8?B?VERnOHEydTZXN0NVN3puVTRGMDBOUVBLMnlHbkd3dW82QUZuSmpFVWFBakJs?=
 =?utf-8?B?STlXV0JvVlNWdmhmYzg2NzdrQjRDSFI1aXJsVElBYnpFZWwyM2JuT0VQNXRk?=
 =?utf-8?B?ajNNZGRRU1UzRkRmNTNTbU05b2tFSzdaZE5jRlBSL29ybTdzZGxOMGhoOXV6?=
 =?utf-8?B?dTMzU0lIL1FIYnRiYk9mTkwxNEFOUHMvTk5PbnVwUUpEbmVWT3h2RGxBSzZz?=
 =?utf-8?B?Qm1EQWRCS2FGWTFQazlqRllCcHYvaXRMT0NqYmhCaVVkakNMVWo4dHE0UHcv?=
 =?utf-8?B?QzJMYUVhOTQ0TUltT3VCaXlUTDlna2c2TFNxMEttbE9zeU9ZSlVBUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: de428a95-98ca-42db-ea15-08dec7d58f8b
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:58.4696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1q0q3A/Pd4ORrgMRBq3SzXpnXk0SNH0Xs70vb5CJoJvf7dvb/t3FIpACY2fmjV8zAEAbI5A3xCziuIu5Y2pefw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Queue-Id: A25A01C000E
X-Stat-Signature: jsy3qdfy41f155zdg9u8peb17xdc1gxg
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781194928-216577
X-HE-Meta: U2FsdGVkX180VJSRSi4Irsav73hWOJJO9Ce4EhUS6bRVBndSds5bPzfU6fgKyYi5yxrk2/3WtISTaEQyS0J2l+u5Ka7049jrsAZVMbitr+uBnVOuks7P4VyHn5VhF0FR+GRlo0s2XqIrnj6aDTo6XQHaPR+arBL1yUvsg0k9f9PGS9XPKhbJmb+Sfouq6VQ1kswEL46VCzRzUOLW2J+B8IXl88PQ0YXebFPjDnxW9MK2g++MPn6DBcDPNaoqul2HqprfxOUs52dSEsCmu9Er1jKMgji9rqGPdN99GUZydRolwcWpE8uGZhaUODqMGT1HiqxbN3IqljmxU4QbvRysSz861mOWRtEbU4AS4ClDm3gdOlg3Tz90RSAj4/jrd+pdE5XTlupa0HnR6xBIkr8nKsXEVnJYof7kZAggS1HRKj5JY5zza7B7ZRpx9maSwtBBR0+KisArMDn3pvJoquKISoyNayiDkbwgVnHlAzSkxzU1nu4gXlMUJgGRJ+qms9gnoq/BtFSVdyZnG0MpQOPvyDOTcvyD2LsQW+MJMdzNk7blmDsKP6Hn5UK8J1uG686DT2F4jhgB3EgSXbYjWzoQXNlTFlmdYQNllBBin4TL8RkdMRZHTQScqKn8Y3eulEYBfjrQN3jbn4OPtM4kNQnHPqmAjPDFbUTvsqWBkmlalaSpYc2eg3KN67qJdn7IzXvjez904bwvKQ68Yy9irmmiDArEQsrKQmstUF4h+azITl+3vGVK4nLzQRgTSmzTsqmJ5IZCXx2hJNyRebXDJfrD7WUJvN64M1jUlrlnaZ/N4yd8HytH9rvGls3pOLJPSSNmq55w/+EvIZ+yda6nkzB11nfqe+8eU+TMzA8/5ZcFzkb7aJXa654PG2Bs4PP9HD3KzdS2P0GNQYEB3XOgnp5hlXMYPXsnT0yDufHcdAiaLMgDMtePuLLt9+Um5Vv4/znqgBMpc25HWBmphpe5id1
 cGmdOcQx
 GbVZE4x6u+QZxlZ2ZkQmP7QtE703I4Wg++WvYaAGL6X+SnmCSat4XwV/x3JnYL1PkO7k8i/6kiEAk1p6LCtC+497CPHAbtARlxFAQPG3BKZgT4O/MIOe8aGEzsLMx3//UnZO/CaC9W2J100yJJiWPNFAqIgUcHAW0jWMNvEcu7zQQd6mMKV58y3a3p7cidQj7xRu9TzN4UvNyXBH6tRxMGbR4jyqeg3cXwdCPJDkhY0NSj0FUZvFuh499V/QITe7EEkxUw01M52+kHke0PR5LAY1+pItWPdsKN+a72nzPYbIym4TESVPqHoe2pPcFIl5pKTFLATXu/irn5gQ6yEUffDD0l39dDHy7z/wVLoDhvFj0V5S+tkrTNEx9Qu0NqTmifZy/KVX1FKJdje8AjXUA0BFoMHN4IykV4cDCJYWXVgAFouON/cTmsmS0ZQAXDNYK3DGscYGxsUWlbuXuzBkYDDsxZYFr61F5PNH6ME57XOeBWOFJc0Wsmy7I4tCITRAAnbCEUM7sTh5khdbq7pNc+7ZBJjEeInEocwSIo1cHX6klV8fU/Q3E/cBp2kX0Q5J+r7G7bHJDknW3ewzN3aS4aYW7MJwpBhALZUSngtUJE2ShfOwvgcAtc5z0LwClE9KlattOMQjFZY4SF9nX8LYe7jbwqPbSL0Z1ty2v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Demonstrates FFI contract violation detection. A C callee returns
success (0) but leaves buffer=NULL, violating the postcondition
"ret==0 implies buffer!=NULL". kcov_dataflow captures struct fields
at the boundary proving the violation without a crash or KASAN report.

Test:

  make LLVM=1 CC=clang \
    M=tools/testing/selftests/kcov_dataflow/rust_ffi_contract modules
  vng --user root --exec \
    "python3 tools/testing/selftests/kcov_dataflow/trigger-view.py \
      rust_ffi_contract -C 8 --ko \
      tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.ko"

Result:

  vfs_write(0x0)
  0x0 = full_proxy_write()
  full_proxy_write(0x0, 0x1, 0x0)
  0x8200080 = __debugfs_file_get()
  __debugfs_file_get(0x0)
  0x0 = __debugfs_file_get()
  0x0 = rust_ffi_trigger_write [rust_ffi_contract]()
  rust_ffi_trigger_write [rust_ffi_contract](0x0, 0x1, 0x0)
    ffi_alloc_buf [rust_ffi_contract](0xffffffff912288ad, 0x100, 0x0, 0x1)
    0x0 = ffi_alloc_buf [rust_ffi_contract]()
    _printk(0x6f635f6966663601)
      vprintk(0x6f635f6966663601, 0x8)
        vprintk_default(0x6f635f6966663601, 0x8)
          vprintk_emit(0x0, 0xffffffff, 0x0)
          0x0 = panic_on_this_cpu()
        0x0 = _prb_read_valid()
      0x0 = prb_read_valid()
    0x0 = console_unlock()
  0x3f = vprintk_emit()
  0x3f = vprintk_default()
  0x3f = vprintk()
  0x3f = _printk()
  ffi_check_result [rust_ffi_contract](0x0)
    _printk(0x6f635f6966663301)
      vprintk(0x6f635f6966663301, 0x8)
        vprintk_default(0x6f635f6966663301, 0x8)
          vprintk_emit(0x0, 0xffffffff, 0x0)
          0x0 = panic_on_this_cpu()
        0x0 = _prb_read_valid()
      0x0 = prb_read_valid()
    0x0 = console_unlock()
  0x3f = vprintk_emit()
  0x3f = vprintk_default()
  0x3f = vprintk()
  0x3f = _printk()
  0xfffffff2 = ffi_check_result [rust_ffi_contract]()
  0x1 = rust_ffi_trigger_write [rust_ffi_contract]()
  0x1 = full_proxy_write()
  0x1 = vfs_write()
  0x1 = ksys_write()
  0x1 = __x64_sys_write()
  0x0 = fpregs_assert_state_consistent()
  0xba5748 = __x64_sys_close()
  file_close_fd(0x4)
  0x0 = file_close_fd()

Cc: Alexander Potapenko <glider@google.com>
Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Link: https://github.com/yskzalloc/kcov-dataflow/actions
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 tools/testing/selftests/kcov_dataflow/Makefile     |   2 +-
 tools/testing/selftests/kcov_dataflow/README.rst   |   8 ++
 .../kcov_dataflow/run_rust_ffi_contract.sh         |  35 +++++++
 .../kcov_dataflow/rust_ffi_contract/Makefile       |   3 +
 .../rust_ffi_contract/rust_ffi_contract.c          | 111 +++++++++++++++++++++
 5 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcov_dataflow/Makefile b/tools/testing/selftests/kcov_dataflow/Makefile
index 3a42c54e954d..6412c90edfa1 100644
--- a/tools/testing/selftests/kcov_dataflow/Makefile
+++ b/tools/testing/selftests/kcov_dataflow/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_GEN_PROGS := user_ioctl/user_ioctl
-TEST_PROGS := run_eight_args_c.sh
+TEST_PROGS := run_eight_args_c.sh run_rust_ffi_contract.sh
 include ../lib.mk
diff --git a/tools/testing/selftests/kcov_dataflow/README.rst b/tools/testing/selftests/kcov_dataflow/README.rst
index 61a41f3bd596..06a0c805cc74 100644
--- a/tools/testing/selftests/kcov_dataflow/README.rst
+++ b/tools/testing/selftests/kcov_dataflow/README.rst
@@ -48,3 +48,11 @@ eight_args_rust/
 
         make LLVM=1 CC=clang M=tools/testing/selftests/kcov_dataflow/eight_args_rust modules
         python3 trigger-view.py eight_args_rust
+
+rust_ffi_contract/
+    Demonstrates FFI contract violation detection. A callee returns
+    success but leaves buffer=NULL. kcov_dataflow captures struct
+    fields proving the violation::
+
+        make LLVM=1 CC=clang M=tools/testing/selftests/kcov_dataflow/rust_ffi_contract modules
+        python3 trigger-view.py rust_ffi_contract
diff --git a/tools/testing/selftests/kcov_dataflow/run_rust_ffi_contract.sh b/tools/testing/selftests/kcov_dataflow/run_rust_ffi_contract.sh
new file mode 100755
index 000000000000..8662e532296b
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/run_rust_ffi_contract.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Test rust_ffi_contract module capture via kcov_dataflow
+DIR="$(dirname "$0")"
+KO="$DIR/rust_ffi_contract/rust_ffi_contract.ko"
+
+if [ ! -f "$KO" ]; then
+	echo "SKIP: $KO not found"
+	echo "Build: make LLVM=1 CC=clang M=...rust_ffi_contract modules""
+	exit 4  # kselftest SKIP
+fi
+
+if [ ! -e /sys/kernel/debug/kcov_dataflow ]; then
+	echo "SKIP: kcov_dataflow not available"
+	exit 4
+fi
+
+OUTPUT=$(python3 "$DIR/trigger-view.py" rust_ffi_contract --ko "$KO" --raw 2>&1)
+RC=$?
+
+if [ $RC -ne 0 ]; then
+	echo "FAIL: trigger-and-view exited with $RC"
+	echo "$OUTPUT"
+	exit 1
+fi
+
+RECORDS=$(echo "$OUTPUT" | grep -c "^\[ENTRY\]\|^\[RET")
+if [ "$RECORDS" -gt 0 ]; then
+	echo "PASS: captured $RECORDS records from rust_ffi_contract"
+	exit 0
+else
+	echo "FAIL: no records captured"
+	echo "$OUTPUT"
+	exit 1
+fi
diff --git a/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/Makefile b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/Makefile
new file mode 100644
index 000000000000..d2a0261070b1
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := rust_ffi_contract.o
+KCOV_DATAFLOW_rust_ffi_contract.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.c b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.c
new file mode 100644
index 000000000000..9cbb17c42195
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * rust_ffi_contract.c - Demonstrates kcov_dataflow detecting an FFI
+ * contract violation at a function boundary.
+ *
+ * The pattern: caller passes a struct pointer to callee. Callee's
+ * contract says "returns 0 implies out->buffer is valid". A bug in
+ * the async path returns 0 but leaves buffer=NULL.
+ *
+ * kcov_dataflow captures:
+ *   [ENTRY] ffi_alloc_buf(alloc={.buffer=NULL, .data_size=0}, 256, 16, 1)
+ *   [RET]   ffi_alloc_buf() = 0
+ *   [ENTRY] ffi_check_result(alloc={.buffer=NULL, ...})
+ *                             ^ proves contract violated
+ *
+ * Write to /sys/kernel/debug/kcov_dataflow_test/rust_ffi_trigger to run.
+ */
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("FFI contract violation detection via kcov_dataflow");
+
+struct ffi_alloc {
+	void *buffer;
+	u64 data_size;
+	u32 free_async;
+	u32 flags;
+};
+
+/* Prototypes */
+int ffi_alloc_buf(struct ffi_alloc *alloc, u64 data_size,
+		  u64 offsets_size, int is_async);
+int ffi_check_result(struct ffi_alloc *alloc);
+
+/*
+ * Callee with contract: returns 0 implies alloc->buffer is valid.
+ * BUG: async path with free_async==0 returns 0 but buffer stays NULL.
+ */
+noinline int ffi_alloc_buf(struct ffi_alloc *alloc, u64 data_size,
+			   u64 offsets_size, int is_async)
+{
+	if (!is_async) {
+		alloc->buffer = kmalloc(data_size, GFP_KERNEL);
+		if (!alloc->buffer)
+			return -ENOMEM;
+		return 0;
+	}
+	/* BUG: returns success but buffer is NULL when pool empty */
+	if (alloc->free_async == 0) {
+		alloc->buffer = NULL;
+		return 0; /* contract violation */
+	}
+	alloc->buffer = kmalloc(data_size, GFP_KERNEL);
+	alloc->free_async--;
+	return 0;
+}
+EXPORT_SYMBOL(ffi_alloc_buf);
+
+/* Caller that trusts the contract */
+noinline int ffi_check_result(struct ffi_alloc *alloc)
+{
+	if (!alloc->buffer) {
+		pr_err("ffi_contract: VIOLATION detected - buffer is NULL after success\n");
+		return -EFAULT;
+	}
+	kfree(alloc->buffer);
+	return 0;
+}
+EXPORT_SYMBOL(ffi_check_result);
+
+static struct dentry *test_dir;
+
+static ssize_t rust_ffi_trigger_write(struct file *f, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	struct ffi_alloc alloc = { .buffer = NULL, .data_size = 0,
+				   .free_async = 0, .flags = 0 };
+	int ret;
+
+	/* Trigger the bug: is_async=1, free_async=0 */
+	ret = ffi_alloc_buf(&alloc, 256, 16, 1);
+	pr_info("ffi_contract: ffi_alloc_buf returned %d, buffer=%p\n",
+		ret, alloc.buffer);
+
+	if (ret == 0)
+		ffi_check_result(&alloc);
+
+	return count;
+}
+
+static const struct file_operations rust_ffi_trigger_fops = {
+	.write = rust_ffi_trigger_write,
+};
+
+static int __init ffi_contract_init(void)
+{
+	test_dir = debugfs_create_dir("kcov_dataflow_test", NULL);
+	debugfs_create_file("rust_ffi_trigger", 0200, test_dir, NULL,
+			    &rust_ffi_trigger_fops);
+	return 0;
+}
+
+static void __exit ffi_contract_exit(void)
+{
+	debugfs_remove_recursive(test_dir);
+}
+
+module_init(ffi_contract_init);
+module_exit(ffi_contract_exit);

-- 
2.43.0


