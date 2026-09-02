Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2E5C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9F96B008C; Wed,  2 Sep 2026 12:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C256B00B3; Wed,  2 Sep 2026 12:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6726B00B5; Wed,  2 Sep 2026 12:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAC26B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EFF480262
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:08 +0000 (UTC)
X-FDA: 85169359296.24.446488F
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	by imf07.hostedemail.com (Postfix) with ESMTP id E2F5240011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=mvDDNCQF;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C7gqgI433YiV3xqUR4oCmAVGIPcQCU2ifNfBvo1rH0w=;
	b=fsQAStk43VDHV7L+XFEe9KFcDq9TINDKjK3/ZwMeYmFbdA9plKVbC3cQ5rxVduYDWeCOdm
	gYiqPtxkwjLANnZr3tVhFhNW5dzIDpJu51ZI59vbu357uIo/6drkM32zJRXs+U/moS+r0z
	YmDG2PORW5qcGSQUsM1zDbuVXxJybwg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366605;
	b=bTeIks9pJQIvHSIrcdqeRkAm6nyfXa4kaA11VDOkyWxyi49SzR610vIjkfQFHp5IAKoUab
	q0EkT6Bq6x5+FIlSJBkLvIGBhNuktHJkg5sR7C/pDN6Wfv8A+y6kI7oRXJ/+FCxtK9tV1Q
	+0XBWMjE8k9QQwDFe0yEcnstHB/UmTY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=mvDDNCQF;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTW3F2rYEE+y4kZYMEmNU0GO2Gg+1r525lg7sXKYh6tzLU1dcRMlVU9+yofTxFWgylmfBF0xUunrgk7qQJ5GVxHTCj/4NfhxH5Xfqiyx/o9x7FblXCHwA///Ypv74mTXDH//x98o50T4V16Ss3t8XINqfbDrFr8xsGpMDjH4z2lMF4I/zndceRMSvSsJUI4Ymvj463XHxYV+WdihMmjovQFx4C36sLxPHrymfSni6yQKCYid39wnySDfLvoyw9xsJKPYKRPUqpwRqW1AsLk48jA3fuVomzp5ja2O4nYItSMN/JxK6MNErUMgo5GT8j3Q7xg9Hj4LIR/91Bj7CkVeKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7gqgI433YiV3xqUR4oCmAVGIPcQCU2ifNfBvo1rH0w=;
 b=i+Ri9ARNkIP4z+bfC0QmyfaHfGlub3CfcEF/4pZ9uMMK4KfAypg9MGRxJY2FrtmY039YjsQ7zcCossUI0bfvgof3rIQR8HV3SfZheospBOkcq3rjq/mjg0wyuk25BPrveZQyfdIB1TdZwJpqSHnQevFp58FHitp7SkbXEyFar/ColRv1Wc/YK53v9pPBLtOnfT4FQlUKqL+XDgQhA3pVBa9fSqRVpZrCj/GlnZ6HJI+DntjaDXBrypsQugn+5abb8HX/J7RCNvQfIf6oihg4fn+iqN0rbvqxFjlN8PmDAgJgsRQ5USCf6I7uVobBfeB8pztxq1RIyfDaLfcLMCR1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7gqgI433YiV3xqUR4oCmAVGIPcQCU2ifNfBvo1rH0w=;
 b=mvDDNCQFdrl/m86HUXwQqySrnb/PMsDXtvIA1eDfblmJHpFC0XXQjj4+P/qxcXpbaWDydFybQ+QlzpcR/vtl5LikAbrYy/c59rZq/3hgrxHAk5XaRks6T/ENrKE7FmxlpU+5LWV6lo88PA1hbtEY9KB7a7Aa7DHm1Hlu5nmhCUkXtkpqb0b1FSb9zOQ+RU8Q6ubx/MTI2x/QUB4ok7mNz+5Y+f1QSVO9rf98hYO9UusuL8+9hcFM2subnTbnhps1Ga6Rgh7RIFqipTSEamN9Xu/noiBOQSPrWrN+pd3pO5g6zWK22cbEu6lvO4LH2nckWvHUFZgwR3tkS2+8S6rJbw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by BESP189MB3209.EURP189.PROD.OUTLOOK.COM (2603:10a6:b10:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Wed, 2 Sep
 2026 16:29:53 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:29:53 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Subject: [PATCH RFC v3 0/8] kcov: add per-task dataflow tracking for
 function arguments/return values
Date: Wed, 02 Sep 2026 18:29:33 +0200
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-0-824609f279f5@est.tech>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQrCMBAAv1L27EKa1Eq9Cj7Aq/SQpLu6Ko0kb
 RRK/27U4wzMLJAoCiXYVwtEypIkjAXMpgJ/teOFUIbCoJVuVac0ugbvPmQc7GT5EV4Y2WM2yKb
 trNtt67phKPUzEsv7dz7D6XiA/i/T7G7kp+8T1vUDIARWh4AAAAA=
X-Change-ID: 20260902-b4-kcov-dataflow-rfc-v3-f369ab75114f
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=18744;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=iBNIJUjApWJ6S7wtwRt+glDjl+exHUdbDQGmPkDjAv8=;
 b=af5h+QlZ9MWXeUZQNiyPkd5n0VXWruxAL4h9Bc38Sen4F+lCvHrZ5nq4xB05LL9qGOOxREuEj
 INY6hjYdyHkAqCKqoxjkkcxB8PDho1V/Nx6JQBbsEROJn4Hugs27GrV
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: DU7P191CA0011.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::18) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|BESP189MB3209:EE_
X-MS-Office365-Filtering-Correlation-Id: 13834fcd-e17c-4cb9-0e17-08df090f6ab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|18002099003|13003099007|11063799006|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZhOkNRW0uHYctEt1vQVVdXpkq9Z8Yc3Cvz52OlHlkN0BXKuCwz4mI9odfqk41HsLsB739/NtZ+6EFX2blb4br+rwT/DzXjMmf5FGLu9dyFkxA8Gl9StTrfiByvU2AYT6LFN5qnbptIwIXDHP76DyWf5luKXknEkDvky9fzEEhNbVqlFhrNKIe1N+JwenQgRZsND3HbM0XWbO24d+oGLtkpvxHsDalh62ngNzdowohH5xccb/8R4s9TqPuVoW9vo2+M2HN0FuigCGUqyE+K7hmW/N+3hf6gzKwfCezRG7m2o/H8I8D/yN29K7X9LSXune866o5ioCVp6zSYEksXa9BZYyFuO8h2PWdmZduR9ZXeTYeLKla5/mYNnxd+V0Ms2ERNy/77XcUNt09i3qZTc2nEmxiHm5YVCgZb3QNyLBTyXN5u+rAfBR/GSyUsy1BDQUjk57oQy8zJLIhGSTz9OVv/xzMzG65j0KsSztcfH2mgW3M7pCSuA25+rvOAuOp226ctWRVdUgXwUBh2WzXBuMiZlBelETckd+P+rtRRQfVZvk2kKhjX427O30feKTF8zdBiITWhpKhGCnhwgL1K2h4EbqVhxEyAQED66BxVedyV79ZY13tUziB2ig06AiZWQX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(18002099003)(13003099007)(11063799006)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2lRRzhlbnNxT2RoUTNSV1lEYkxKT2lnY2tGekZaMjRwenFYbnY1amVPV3ov?=
 =?utf-8?B?Z1VsSjNad2tNTG41bHZCaEdLRWFaZnlHZGxWYlNMUmhYYkNCb0xsQ09pSUpB?=
 =?utf-8?B?UnRXaEJybm92czgzQTBWV1d0UnhiU204eFdjRDNrZENpTWY0d1JqMmp4aU9C?=
 =?utf-8?B?bGh1RU5oTVJzVyt1elpzQm0rTENMRG9SQlROS25BbU96TUFoU1NTcDU0Qy9y?=
 =?utf-8?B?b2VNRm02YzVCdnR5bzNmdTNYZkNjV1kvWDFjZU9OMjJzK0NFbGcwWlVMVUcy?=
 =?utf-8?B?Zko0Zy95WEhIc1hiSGhDN2piT0JGeFZPOEtMNmIwL1g0aENDM1NteFovS0lk?=
 =?utf-8?B?RTlReGUzZ29mYVYzMzUrMHNpTDc2eFcrY05FSkJJQjVxK3dBMzIrR3JlbHZw?=
 =?utf-8?B?dllLNnE2aDhHdnhNcDczZ2pOTCtqYUdwOTlOUDV0TzZRR2NYOTRxOFAzTUtZ?=
 =?utf-8?B?ajNnQWJVQzdqZVdwV3Q1ZGl3MHJDWVlpeHlob3F1TENORTlaeUtORndzRWZM?=
 =?utf-8?B?eDJTTlU0R0hMdllrY2dIbG1EbDRLaU9ObXFWK3JDRER1VGFpYkg5dkZ1bXR6?=
 =?utf-8?B?bjFWNTN5VHhkTVdwNC9yS0ROZ3dDRlVFcW5NQnVQdC9PbnB6S0srZTVrSmd6?=
 =?utf-8?B?MW5ZZGJRbmJnb0ZYaGdKRHp3eUVMTUVKc1JiKzZYNXArQlQ5dnIxVXhuYVpX?=
 =?utf-8?B?eUxsbTExWEhHdnVmWXVsVnd1MVZvVk53WDVpS0czM3JwczNHWlk4UThXWnhx?=
 =?utf-8?B?SHM2K29uTWVRUmNGb2JvbWZHNUVMZHVCaHloZjJFVk5XSFpSckJING93RmJU?=
 =?utf-8?B?c0tYODBPVHVkZWQ5ekhGT2h2Wm1RRlpRWXluT0liNkZabHJuak1OZGxuVDFY?=
 =?utf-8?B?ZFVLNXJYaXl0UG15dk5vaUdGWjEyOVd5RUt0dFlZS1NpQ1pVSkVTQnhPRlhu?=
 =?utf-8?B?QWN1MzBiTGRUNG9WaWVzcXpRUWxIdDJvNXVOb0xZK09DeklPWTJ1TUVZZzBn?=
 =?utf-8?B?Uk1KNVRvVmt0a0tDQU5CdGVXY2xBWjdTZk9ESDR0RXNMTzJmYW43eTJGNnl4?=
 =?utf-8?B?Sm94QW5JZUxXcG9ETVB2ZkRxejExSzgxY1A3TlduS3JIaThvcldIc2tQYitq?=
 =?utf-8?B?cUNLMzBSNkdCU2x6d1grc28yNFlxcC82UFBJalY4RGlteEJEMGdja1VHNnRV?=
 =?utf-8?B?OUNtWitmRllhZXJoRTRNeFdiTEp3Rnk4ajVJZnN3bmNqaldDaUE1MCtIS1FD?=
 =?utf-8?B?SzJ2U2wwaGZDSTZUYUo0TUZSYUx4MDE1bW9VV0NOTW1MclhISFJ3SmJDK0R1?=
 =?utf-8?B?cm15WXh4d0FESWZ4S3JwRW4rZW9wellEaGtBQlMrbzQ3ZjlvQkl1N20vdWxG?=
 =?utf-8?B?SjI3am8yRGFXV09mWHZJQ1lsZVNVWWxxTXl5UjdMNlBmc1c5YXM2Z1hDK2N3?=
 =?utf-8?B?dTBlbFlhRzdlUnYrUTYwUlZiWHRISWpCZDNOc01DNTdqcy9RT1oyQmV2cWNR?=
 =?utf-8?B?UlpDbEh2OXd4cjBMT2VSRkRuS3lQZHlGeTN6WjhIS0lINEJXM0w4QWFlUmow?=
 =?utf-8?B?MitIeGc3dEJaWTNCTUVNZHpUcC9OVjlPM0FlU0I4aFNxZnlZTzVIeXlwdkZC?=
 =?utf-8?B?OEpNMkFqOEtYTkVyMkl3eWx2VDNSQjBWZ2ZXTVA1TW9kekRmRHJXSG55Szgv?=
 =?utf-8?B?cThMWi94UFErSmtTeDNLM3lKRkpMVEVla3JnUzhZS05PM1c3R2tVR2lSRTRE?=
 =?utf-8?B?d2czcTVWY29RdUtkQmYwcDJyWWEvK1JySDg1VlcyRk81bGNSS2N6aTdiUlNY?=
 =?utf-8?B?SW9vdE56QUlLZVoxUitVZlFwZHFIUHpsYXhBSXc4VFkvVHlaNXZHRlFJUHNR?=
 =?utf-8?B?OU84VVRBc1hIa0JocFI2Z29PdFdnZjdNeXIzN2JxdjduOTFyQWpITmF6TVZK?=
 =?utf-8?B?YUhrbk03bzh4MThCTGhpQlFxbDNnQmc2QTk1ZHovRXduQUFpYzRhbDFhbU94?=
 =?utf-8?B?T0VMUjhKMlEyN0JuQXdZaVd3eUdNUVFVSHU1aEFKVlg2UVJtVG9UaDVIWTZN?=
 =?utf-8?B?QXl2cnhoa1dkaFQvZTZVdkE1WlhJV1l2VDJwVGY4MjRWbkN0aFlFaXUrR1ZU?=
 =?utf-8?B?SXp6Vzh4VFVLaGpQc0Nrc2ZSdXp3eFpLYmtkcGxwQWhvaG1VOHJ5a29WbjB3?=
 =?utf-8?B?UmtRY0ZranIycnBrdDR6a3l6THlwZ1pMQ25vb213SldmQ2JSeWpTWGdwVkNO?=
 =?utf-8?B?Znk1cHJheldYSkQ1WHFpWlhwMVVSU0FLZTJPRm5MLzdXVStPamlKcmxNeHpJ?=
 =?utf-8?B?ekhzRmV2NlRkTEJGOFpPbXZaWjZHbGNZL21qUzJCblpDRFJCQVcwdz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 13834fcd-e17c-4cb9-0e17-08df090f6ab8
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:29:53.1464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIMpyTiSCSAWG61bSrzdfwxXR0J/j8ehd3GJE8napgmj80a11qsZ1CVtfwRjW0kpYa0X/zpflztRoaMUAMudJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESP189MB3209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2F5240011
X-Stat-Signature: c5yc3nox6cazbs558nequofbhoctr9ew
X-HE-Tag: 1788366604-569896
X-HE-Meta: U2FsdGVkX18vHJ9p19lvwNnz+v3MNcwugb3bBQGOHwyTfma8I9faheFOWzFchyd/6kYhgqRa0pNznc6iu4flex4J73l8Cmc3G29DBOPAbkz0iEUvx4Rk2kWFjdI2LZitrsm0n+gvBgvjJuuH5aJ8yyuwZJ4i5jhM1LymUKde5vBVr/gae2fu/7zaeldPi7b8qzs8yTa4+T8wzZM0AQbN03f8CsbulqGBw4rhFeCeOX7TSD92jaqE0XIJhypK2MxRuHzXbjtBsd8Dk/6nJaEWFHzgdRgoyv4wiLILcVKJ9tVzfuxAXYDTLZKj0JhVQmGEapJZeW9p8oDz/yhc/n3MrL7wxfouOwRbbQt6i2DO4LHWsazfJvaJThM/zxCeBP8hcQxSSCDlGKRRK9Ff7T/+fuxBXpIqpqY9iSma21z0sRiFVBN+pydBi/WqBgMRb1mk/QVuKPj8SclnxG9IUL6HF8ESwlBjz5dCq/vxX9aVBsKS9iSDcaQRMZ2sBSKhGfD+/KSo9MPyUCz6Ahswup9Jqg9DgnGXA57eBto4Ug5ruBMYqeYivfYGQQE/bQSwW0sGIBFdunzfTVc++SaA+UPq9PbVsFjOvjETj//hgpGzr3OCr81KD4u0PSWIlapCOQHtZ+dnRIxLvXCvtt0Xcp+tLtfuys08uZRUgqQWbCaZq+ZStFLB6nOM3k2jVPagpSMjHViljoSF0uppDKdfj9vMdVZEaniA4d+7hf1yQCS2rMgTxou6b2sEionmaP2W6yb1Lk3SaOBCs5jeRdGopiKVf5KPH1YgqHGLtNWD8CSNmKzN1ABenvucZWGbc/nYT/CyHJXpfy36CxnnyuSI5M/pgbwtR+QEMHkjZa7H3uyUYTytXcB5P8FC7ovb09FDlGZJ8UhchF/j6VXdKUtj4xRy3/eBDIL/a5BHUQfkhTycrrvHINv/chpht1eiqHb5TyrjQ7TlzK6aDLIDYypiO5q
 FpMyS3Jq
 9fXl+MmV0v8LLFnemG07jyfZ33pWXo8g92OEY8rByFFjrODfHEsoEtFwSiLSro0PZ7jOql2Lr48beYEyrkwuj3pcEsNC8fTjLbunM3egq7PX1dNWNFcmKVwPlbnhl1M6+TODT4Nu/OvbIwXg7vAq22Rrj+SByvE6xPYi7OZ8A58XgM7nnP1pgoCChEbr89mQxH0gwKkdhegYLAMQ/T7WWF+Ybzir7wDZgO/CnRe/EBq0xRcf3Igs4GgIVuLsamrVBWluCPKwEym6FcYj+cxYiopJbX8InsK4p+brgdou1ILN9TDJzErfbgdyxRgxwSuROj0MM/P4Fzi9FDA9ELaPuXJnY5msFFeNs8xD5XjqZSVMgbsIceJ211lrloYoxNz4dCXSZ83vH1J4Z+2AAxhJN10Hkx00rd1yFq6IRs3mYieew4r8jAe8hjuUGI+pjVfJ1kXu8v+Ym1c8GSaZG7mZP2gSDON6iWbbkXqhwaFjmZmxVNROdTmDlkz6nFNZ7pERoTlNJDga4c+DhYFpFuKT6ikCrd4Fs0jsfz1zuid4V2X+9+FdUud796JDMcWSxhqsBOjd2g7li8ImIXpRB3a+9ij9ymzwHwmLBMo2nLy2nORQqbPZplI6kVoP+d+zMC5hIyhHUdRAY5KpNH0xjMcl/364sH/B/VduHs/dQra04HCs7hOG9ZoOtxBsVV4cE52UFMRtPmwQYzJJzcEOz5pHLWCRNF9n+moeF9nIWbCbu80NKiewsWOyLmUM522jV5gPBEFaJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds kcov_dataflow, a per-task mechanism that records the
argument values a kernel function is called with and the value it
returns, at instrumented function boundaries. Where KCOV tells you which
code ran, kcov_dataflow tells you what values flowed through it.

It is built on a SanitizerCoverage pass that inserts two callbacks,
__sanitizer_cov_trace_args() at entry and __sanitizer_cov_trace_ret() at
exit, so it needs a clang/rustc built with that pass [1][2]. When a task
has no session enabled the cost is one boolean check.

This is still an RFC: The compiler-side review is ongoing [2]. I am posting
it to get the kernel-side design and the uapi reviewed in parallel with
the LLVM work.

Motivation
==========

Coverage-guided kernel fuzzers use KCOV edge coverage as their only
feedback signal, which cannot distinguish two executions of the same
function called with different argument values. Fuzzers plateau on
stateful subsystems whose security-relevant behaviour depends on runtime
values rather than control-flow topology.

The existing tracing tools each miss part of this:

- ftrace / kprobes / eBPF patch global kernel text, so a probe fires on
  every task on every CPU; per-task selection is a post-trigger filter,
  not a property of the instrumentation.

- FTRACE_REGS_MAX_ARGS is limited to 6, but many functions still take
  more than 7th+ arguments, even after inlining by compiler.

- Rust is only partially reachable: rustc emits -mfentry stubs, but
  idiomatic types (generics, slices) do not lower to the repr(C) shapes
  that pahole/BTF-based argument printing expects.

- Inlined code has no function boundary to trace at all without an
  explicit noinline / #[inline(never)].

kcov_dataflow is per-task, follows the task through execve, works
uniformly for C and Rust, and (with CONFIG_KCOV_DATAFLOW_NO_INLINE) can
keep the boundaries of otherwise-inlined functions.

This idea originated from post-mortem auditing of reproducible exploit PoCs,
including those from kernel and KVM CTFs, with a focus on evaluating the
remaining kernel attack surface after security mitigations.

Approach
========

The pass inserts a callback at each function entry that reports every
argument and one at each return that reports the returned value. For a
a struct, the kernel expands it field by field using the offsets
the compiler emits from DWARF, so a struct argument is recorded
as its individual members rather than an opaque address. The kernel
backend reads the traced memory with copy_from_kernel_nofault() (a typed
get_kernel_nofault() for the 1/2/4/8-byte scalar cases), so a NULL or
ERR_PTR the callee received is recorded as a poison marker instead of
faulting.

Records go into a per-task mmap'd buffer over a dedicated debugfs device
/sys/kernel/debug/kcov_dataflow, in execution order.

Example
=======

eight_struct_args_c calls stf_1()..stf_8(), where stf_N takes N struct
whose fields are 0x11, 0x22, ...; the viewer prints one call per
line, source location on the left, and shows each expanded struct and the
return value [5]:

  eight_struct_args_c.c:228     0x11 = stf_1(0x11)
  eight_struct_args_c.c:232     0x33 = stf_2({0x22, 0x11})
  eight_struct_args_c.c:238     0x77 = stf_3({0x33, 0x11, 0x22})
  eight_struct_args_c.c:244     0xff = stf_4({0x44, 0x11, 0x22, 0x33})
  eight_struct_args_c.c:251     0x20f = stf_5({0x55, 0x11, 0x22, 0x33, 0x44})
  eight_struct_args_c.c:258     0x42f = stf_6({0x66, 0x11, 0x22, 0x33, 0x44, 0x55})
  eight_struct_args_c.c:265     0x86f = stf_7({0x77, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66})
  eight_struct_args_c.c:273     0x10ef = stf_8({0x88, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77})

The same works for Rust modules.

  eight_struct_args_rust.rs:101               0x11 = rstf_1(0x11)
  eight_struct_args_rust.rs:130               0x33 = rstf_2({0x22, 0x11})
  eight_struct_args_rust.rs:136             0x77 = rstf_3({0x33, 0x11, 0x22})
  eight_struct_args_rust.rs:142           0xff = rstf_4({0x44, 0x11, 0x22, 0x33})
  eight_struct_args_rust.rs:151         0x20f = rstf_5({0x55, 0x11, 0x22, 0x33, 0x44})
  eight_struct_args_rust.rs:160       0x42f = rstf_6({0x66, 0x11, 0x22, 0x33, 0x44, 0x55})
  eight_struct_args_rust.rs:169     0x86f = rstf_7({0x77, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66})
  eight_struct_args_rust.rs:179   0x10ef = rstf_8({0x88, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77})

Because the values cross the function boundary, kcov_dataflow can catch
an FFI/contract violation that leaves no crash and no KASAN report. In
rust_ffi_contract, ffi_alloc_buf() returns success (0) but leaves
out->buffer == NULL; the caller then trusts the broken postcondition:

  rust_ffi_contract.c:47   0x0 = ffi_alloc_buf({0x0, 0x0, 0x0, 0x0}, 0x100, 0x10, 0x1)
  rust_ffi_contract.c:70   0xfffffff2 = ffi_check_result({0x0, 0x110, 0x0, 0x0})
                                                          ^ buffer still NULL

The {0x0, ...} first field at the second boundary is the NULL buffer the
contract said could not happen after a 0 return.

Global enablement (INSTRUMENT_ALL): records captured during single
copy.fail exploit reproduction:

  https://github.com/yskzalloc/kcov-dataflow/blob/main/copy.fail/origin/converted.txt

Design
======

- Independent from /sys/kernel/debug/kcov: its own device, ioctl
  namespace ('d') and per-task buffer, so it can run alongside KCOV.
  Core lives in kernel/kcov_dataflow.c (split out of kcov.c on request).
- Session lifetime mirrors mainline kcov: a refcounted object with a
  back-pointer from the task, so fd close from a sibling thread, a forked
  child, and task exit cannot race into a use-after-free.
- Local (KCOV_DF_ENABLE) writes reserve buffer space with a plain
  area[0] update; remote (KCOV_DF_REMOTE_ENABLE) writes merge with a
  bounded atomic64_try_cmpxchg() loop. The two paths are mutually
  exclusive on one buffer, so they never both touch area[0].
- Safe reads via copy_from_kernel_nofault() / typed get_kernel_nofault().
- kcov_df_inert_context() (in_task() and !pagefault_disabled()) rejects
  interrupt/NMI context and, crucially, any nofault region: the trace-cmp
  callback is reachable from the ORC unwinder that KASAN runs on every
  slab free, and without this a live session turns one stack walk into a
  self-instrumentation storm that trips the soft-lockup watchdog.
- uapi record format (include/uapi/linux/kcov_dataflow.h): area[0] counts
  the record words that follow; each record is a header word (sequence,
  type, value count, size, argument index), the instrumented PC with the
  KASLR offset removed like mainline kcov, the traced pointer (or the
  comparison type for CMP records), then the value words.
- Build: -fsanitize-coverage=trace-args,trace-ret, per-file opt-in
  (KCOV_DATAFLOW_file.o := y) or CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL,
  honouring KCOV_INSTRUMENT := n. kcov_dataflow.o is excluded from KCOV,
  KASAN, KCSAN, UBSAN and KMSAN to avoid recursion. objtool lists
  kcov_df_trace_cmp() in uaccess_safe_builtin[] next to its mainline peer
  write_comp_data(), since the compiler emits the cmp callbacks inside
  user_access_begin()/end() regions.

Remote coverage
===============

Work a task queues to a kworker can be attributed back to it:
kcov_df_remote_start(handle) / kcov_df_remote_stop() bracket a region in
kernel code (kcov_df_remote_start_common() takes the common handle), and
user space publishes a buffer for that handle with KCOV_DF_REMOTE_ENABLE
(the handle is passed by pointer, so the full 64-bit value survives
compat callers). rust_kworker_remote exercises this from RBTree work on
system_wq.

Rust kworker coverage is also captured through remote coverage,
as shown by the rust_kworker_remote module test:

  rust_kworker_remote.rs:58   <rust_kworker_remote[...]::CompositeStore>::populate({0x0, 0x0, 0x0})
  rust_kworker_remote.rs:73   <rust_kworker_remote[...]::CompositeStore>::update({0xffff0000055f09c0, ...)
  rust_kworker_remote.rs:92   <rust_kworker_remote[...]::CompositeStore>::drain({0xffff0000055f09c0, ...)

Findings
========

The following commits fix issues found by ksmbdzzer, a KCOV data-flow-based
fuzzing engine for ksmbd and SMB Direct. The issues include one CVE with
a CVSS score of 8.8.

  e7188199eff4 ksmbd: fix use-after-free in __close_file_table_ids() (CVE-2026-74522)
  7405d0ba2943 ksmbd: fix slab-out-of-bounds read in ksmbd_alloc_user()
  fe2c0cacbcff smb: smbdirect: free completion queues with ib_free_cq()
  383a9480f5f4 smb: smbdirect: destroy QP before mem pools on accept failure
  76fa42c004eb smb: smbdirect: avoid recursive listen.lock during cleanup
  db82fbe4bb68 smb: smbdirect: release pending child sockets outside the handler lock
  e9b33376bd07 ksmbd: validate ipc response length before dereferencing its fields
  b0148dc5625d ksmbd: serialize oplock close with pending break ownership

Performance
===========

Numbers from the v2 measurement [7]; the fast paths are unchanged in v3.

Per-module instrumentation, recording active:
  +8.3% on instrumented paths, ~27 ns per callback.

Global instrumentation (INSTRUMENT_ALL), recording disabled:
  .text +9.5%, .data +44%, boot +71%, syscall latency +133%.

INSTRUMENT_ALL is a debugging/fuzzing configuration; per-module opt-in is
the intended production use.

Toolchain
=========

Requires a clang built with the trace-args/trace-ret passes:

  git clone --recursive --depth 1 --shallow-submodules \
    --jobs $(nproc) https://github.com/yskzalloc/kcov-dataflow.git
  cd kcov-dataflow/llvm-project
  cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64"
  ninja -C build

  export PATH=$PWD/../llvm-project/build/bin:$PATH
  cd ../linux
  vng --build LLVM=1 CC=clang
    --configitem CONFIG_KCOV=y \
    --configitem CONFIG_KCOV_DATAFLOW_ARGS=y \
    --configitem CONFIG_KCOV_DATAFLOW_RET=y \
    --configitem CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y \
    --configitem CONFIG_DEBUG_INFO_DWARF5=y

For the Rust modules also build a rustc against that LLVM [4] and add
CONFIG_RUST=y with RUSTC=<.../stage1/bin/rustc> RUST_LIB_SRC=<.../library>.
The Kconfig options gate on $(cc-option,-fsanitize-coverage=trace-args),
so a stock clang simply leaves them unset rather than failing to build.

Testing
=======

Built with clang/LLVM and rustc from the fork [3], on x86_64 (Intel)
and Arm64 under virtme-ng; The selftests build as a normal kselftest target
(make -C tools/testing/selftests TARGETS=kcov_dataflow) and run under
run_kselftest.sh:

- user_ioctl: 9 kselftest_harness cases (init, mmap, enable/disable,
  double-enable -EBUSY, record validity).
- test_modules.py: loads each module, triggers it with recording active,
  and checks the captured arguments, struct fields and return values
  against the values the module uses (not merely that records appeared)
  for eight_struct_args_{c,rust}, rust_ffi_contract and, from kworker
  context, rust_kworker_remote.
- binderfs: argument records at the binder ioctl boundaries.

Links
=====

[1] LLVM RFC: https://discourse.llvm.org/t/rfc-sanitizercoverage-add-fsanitize-coverage-trace-args-trace-ret/91026
[2] LLVM stacked PR:
    1. [sancov] Add -fsanitize-coverage=trace-args,trace-ret
       https://github.com/llvm/llvm-project/pull/201410
    2. [Clang][SanitizerCoverage] Add trace-args and trace-ret instrumentation modes
       https://github.com/llvm/llvm-project/pull/218254
    3. [compiler-rt][SanitizerCoverage] Add userspace runtime for trace-args/ret 
       https://github.com/llvm/llvm-project/pull/218265 
[3] Repo:     https://github.com/yskzalloc/kcov-dataflow/
[4] rustc:    https://github.com/yskzalloc/rust
[5] CI:       https://github.com/yskzalloc/kcov-dataflow/actions
[6] Paper:    https://arxiv.org/pdf/2606.00455
[7] RFC v2: https://lore.kernel.org/all/20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech/
[8] LPC 2026: https://lpc.events/event/20/contributions/2402/

Changes
=======

RFC v2 -> RFC v3:

Core / review feedback (from the v2 posting):
* Convert the spinlock-with-IRQ-disabled design to a mutex-based mechanism,
  focusing on reproducible future LPE PoC tracking. (Yeoreum)
* Fix potential memory leak kcov_df_ioctl() (Yeoreum)
* Rework the session lifetime into a refcounted object mirroring mainline
  kcov (kcov_get/put), with a back-pointer from the task, so close() from
  a sibling thread or a forked child, and task exit, can no longer race
  into a use-after-free; the v2 fork/exit cleanup was ad-hoc.
* Make the barriers real: v2 documented "paired barriers" that were only
  comments. Enable/disable and the sequence guard now use actual
  barriers, and buffer-space reservation uses a bounded
  atomic64_try_cmpxchg() loop so the local and remote write paths never
  both update area[0].
* Add kcov_df_inert_context() (also bailing on pagefault_disabled()) to
  contain the KASAN-unwinder self-instrumentation storm, instead of
  excluding files in mm/ and arch/.
* Typed get_kernel_nofault() fast path for 1/2/4/8-byte scalar reads.
* objtool: list kcov_df_trace_cmp() in uaccess_safe_builtin[] and make
  its helper __always_inline (fixes the "call ... with UACCESS enabled"
  warning under INSTRUMENT_ALL).

Support Remote kcov dataflow collection:
* Add kcov_df_remote_start()/stop() and kcov_df_remote_start_common() for
  kworker attribution, with a new kselftest with rust_kworker_remote.

New record ABI:
* include/uapi/linux/kcov_dataflow.h is now a real uapi header. Each
  record carries its type, value count, size and argument index in the
  header word, followed by the traced pointer and the value words; PCs
  are stored KASLR-canonical, like mainline kcov. Documented in
  kcov-dataflow.rst. KCOV_DF_REMOTE_ENABLE now takes the handle by
  pointer.

kselftest restructuring:
* Restructure as a standard kselftest target (Kbuild + per-module
  directories built against KDIR) driven by one KTAP runner
  (test_modules.py) that checks captured argument/return values rather
  than record counts; trigger-view.py is split out as the interactive
  viewer.
* Change the scalar arguments basic test from eight_args_{c,rust}
  -> eight_struct_args_{c,rust} and drop the ad-hoc scripts.

* RFC v2: https://lore.kernel.org/all/20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech/

RFC v1 -> RFC v2:

Apply feedback from Sashiko’s code review:
* Fix INIT_TRACK race, fork cleanup, task exit cleanup
* Add recursion guard barriers (Peter)
* Reject concurrent enable on multiple fds

kselftest refinements (Alexander):
* Move from tools to kselftest adding:
  user_ioctl, eight_args_c, eight_args_rust, rust_ffi_contract, binderfs_test
* Separate patch regarding kcov-dataflow Documentation

Series:
* Split into core / Documentation / one selftest per patch. 

* RFC v1 (I mistakenly referred to it as RFC v2):
  https://lore.kernel.org/all/20260603-kcov-dataflow-next-20260603-v2-0-fee0939de2c4@est.tech/

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
Yunseong Kim (8):
      kcov: add per-task dataflow tracking for function arguments/return values
      Documentation: add kcov-dataflow.rst
      selftests/kcov_dataflow: add ioctl interface selftest
      selftests/kcov_dataflow: add rust_ffi_contract selftest
      selftests/kcov_dataflow: add binderfs selftest
      selftests/kcov_dataflow: add eight_struct_args_{c,rust} selftest module
      selftests/kcov_dataflow: add rust_kworker_remote selftest module
      selftests/kcov_dataflow: add trigger-view.py

 Documentation/dev-tools/index.rst                  |    1 +
 Documentation/dev-tools/kcov-dataflow.rst          |  449 ++++++++
 Documentation/userspace-api/ioctl/ioctl-number.rst |    2 +
 MAINTAINERS                                        |    2 +
 include/linux/kcov.h                               |  116 ++
 include/linux/sched.h                              |   34 +
 include/uapi/linux/kcov_dataflow.h                 |   92 ++
 kernel/Makefile                                    |    9 +
 kernel/exit.c                                      |    1 +
 kernel/fork.c                                      |    1 +
 kernel/kcov.c                                      |   56 +-
 kernel/kcov_dataflow.c                             | 1193 ++++++++++++++++++++
 lib/Kconfig.debug                                  |   52 +
 scripts/Makefile.kcov                              |   17 +
 scripts/Makefile.lib                               |   14 +
 tools/objtool/check.c                              |    4 +
 tools/testing/selftests/kcov_dataflow/.gitignore   |    4 +
 tools/testing/selftests/kcov_dataflow/Kbuild       |   10 +
 tools/testing/selftests/kcov_dataflow/Makefile     |   46 +
 tools/testing/selftests/kcov_dataflow/README.rst   |   69 ++
 .../selftests/kcov_dataflow/binderfs/Makefile      |    5 +
 .../selftests/kcov_dataflow/binderfs/README.rst    |   13 +
 .../kcov_dataflow/binderfs/binderfs_test.c         |  195 ++++
 tools/testing/selftests/kcov_dataflow/config       |   11 +
 .../kcov_dataflow/eight_struct_args_c/Makefile     |    3 +
 .../kcov_dataflow/eight_struct_args_c/README.rst   |   13 +
 .../eight_struct_args_c/eight_struct_args_c.c      |  533 +++++++++
 .../kcov_dataflow/eight_struct_args_rust/Makefile  |    3 +
 .../eight_struct_args_rust/README.rst              |   11 +
 .../eight_struct_args_rust.rs                      |  646 +++++++++++
 .../kcov_dataflow/rust_ffi_contract/Makefile       |    3 +
 .../kcov_dataflow/rust_ffi_contract/README.rst     |   13 +
 .../rust_ffi_contract/rust_ffi_contract.c          |  125 ++
 .../kcov_dataflow/rust_kworker_remote/Makefile     |    3 +
 .../kcov_dataflow/rust_kworker_remote/README.rst   |   13 +
 .../rust_kworker_remote/rust_kworker_remote.rs     |  207 ++++
 tools/testing/selftests/kcov_dataflow/settings     |    1 +
 .../selftests/kcov_dataflow/test_modules.py        |  249 ++++
 .../selftests/kcov_dataflow/trigger-view.py        |  755 +++++++++++++
 .../selftests/kcov_dataflow/user_ioctl/Makefile    |    5 +
 .../selftests/kcov_dataflow/user_ioctl/README.rst  |   11 +
 .../kcov_dataflow/user_ioctl/user_ioctl.c          |  168 +++
 42 files changed, 5127 insertions(+), 31 deletions(-)
---
base-commit: 89c07d98716a13454ec3fd9f97689e812cc71bd4
change-id: 20260902-b4-kcov-dataflow-rfc-v3-f369ab75114f

Best regards,
--  
Yunseong Kim <yunseong.kim@est.tech>


