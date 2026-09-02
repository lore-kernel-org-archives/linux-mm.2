Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DF8C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766796B00B3; Wed,  2 Sep 2026 12:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E3D6B00B5; Wed,  2 Sep 2026 12:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B5A6B00B6; Wed,  2 Sep 2026 12:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158266B00B3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6ED33402A8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:11 +0000 (UTC)
X-FDA: 85169359422.15.D00E30C
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	by imf07.hostedemail.com (Postfix) with ESMTP id 21A8440003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=G4SMmdBS;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6WaK65Cg/PsV4QAJ/ma5BfcIEQxsCenJyh4g6dpJ2U=;
	b=6OJ+FqPfA/Md4+KpC4XMcW1Ah9tvi44ZZRboXDz0OGfqDE3WKueMoKMHAu2jsSTrMUCJqB
	fGuwb0XKNbKnBuVXah0JXBtxCx+PFkD4fH7d4d6ldgkqcYgDUvRS/xNBPymnIiobOuQFsg
	Xl4xASJ12s6QeIRb793taGNVgQ078ww=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366608;
	b=U8qJD6beGd1FC6TCXCsM9uJZJHCOIroO6QfYEfSZdz14QFhiW7ddyPlXFoXfy1IEcRv31O
	Ek3C9XpKJLfbQWtLBZfcnWf/IUz7bomj47EGW306I5a5/U5kS310JEnIFQIQq7/q2AFq+w
	xKrcVWjzMzRIQpNUZ66lXU506BhESqo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=G4SMmdBS;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v399ZPzjja1dqcKm9sqRV/+bHtLd1cnLSbNP8pogySZ1GVPQai6kn4kX/JIPubCKAuVUX7xrD5wRguJqG3d/vaiRFer3VDK6j9StXtDghE1GvjgCuwfL1YKiN/Xrin0UZ1AqOfVdyi4JbiASO1O4eJ3H4T2zw4iC6ffH8erb0rZzUFGy1sfyo6yFQlxgpJqrK2i8lYww+szG1kAsbsmb0cQOgiquKbYa6pmhydlz8wubL+LmpxkGf+4AHJQXQsTpGqzueQcXf1/8Acz5vFTJPc/fS1hJTw5ii2mqShpGgo4zFnT/BoxkBLADEJVtMFamPsZ3nHdYcxJAoWkdnv9ZnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6WaK65Cg/PsV4QAJ/ma5BfcIEQxsCenJyh4g6dpJ2U=;
 b=DdGGMZ7VEibIbNQrWdE3LGZOXpnF0kJhAHVATqZVb70lrSOxhrKTUGX4GT4oAGqtDw5co945hlfslkS8JRHJP7Ffe7iISf8y6DJT9ry7uhfVEzd7oaL57HoCbNdehIU8jG6FFrzfCRECDJv1e2Gz/KXTigEIya+pMMjaY/iZH9wHMSLxFhuzcEV3qwkjKR8cYXDRR2gZt+Ry8yCpgvEgD/SIfnkb20Vqe2rQv7HGmNUwYoKEqjdyPbYU9dAdGXXDLU90V6DVMDr9wHrLr7+zKeuzBR4eMMfTOxQJz+lQMFIGWDrpYMKSI1PhKj/8ud3KaL7md7XOZXjJKUNqSTIwOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6WaK65Cg/PsV4QAJ/ma5BfcIEQxsCenJyh4g6dpJ2U=;
 b=G4SMmdBSNBn1rBai7GHjkAA/nruwbLwsT/5cfRxM3+6U90n+znHww44fun7YvTC4/nxH91N4625UJ4tns5R5aLS61XYbGd3InUjz6E4laI7iIvsRD5nS9kcFLHjIkOCdw87wTmomcBaMpI8DMksnuKZXc8QapYAcIdONEIwSQqxIBwkMno5Xs2eNgfM3Vz6Rlmh9ir3Ql8VYF8Y13kw0ymlvzJ7v9gd/5rqZgtXfF9LK0ueOEu8fYkxROcNtYm/G6SpYjua79YDGIXca18vgX63kJiPoIfP7UgiO1npYeZ64PaElMmC1XnCdUm5IzVPTNgyCPukfuDtzayKOOVMcFw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by BESP189MB3209.EURP189.PROD.OUTLOOK.COM (2603:10a6:b10:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Wed, 2 Sep
 2026 16:29:55 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:29:55 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:34 +0200
Subject: [PATCH RFC v3 1/8] kcov: add per-task dataflow tracking for
 function arguments/return values
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-1-824609f279f5@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=72144;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=6dEfxCmsf2tZTjRi6UBzYLAGnYbAIxnliyHHXt66DiY=;
 b=bw2TLuD26AS/rnHW9YPPm1rdTLQGSTYmPmhhRy3cptZzHmaHckrsM/FU7h2nR/j5eXAyiCpHM
 hSLWF7wtv8QBzW6X3usNTmVGySLX65eAAq0j6VpsPAUa6rTim5TUF91
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: DU2PR04CA0055.eurprd04.prod.outlook.com
 (2603:10a6:10:234::30) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|BESP189MB3209:EE_
X-MS-Office365-Filtering-Correlation-Id: abd6353e-cc22-4a88-8eb6-08df090f6bfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|22082099003|18002099003|3023799007|11063799006|5023799004|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	DDLYwUiVi/14a63KfygY4JjHR9v41dvBQQ4wFcPGVOyG4RgXPtPZJo8HgPu/+vvnBOOA+4hD3Y6DohSRTvbSy5U5VJSpuGw+1OWEpSpW/XdoEW5axF3nUNGFhxheIlFVQUGmgaQIM43z7+DvUfDAu++VLFOEdSmGRX0PwBPVUXAOMeZ0s3GaM7l6oLG+ZwLbTT3hmtbnKacdS3SiX3seVTIWw6SdQMeR53zOPFkaklSeF+rirQ7IoNKtP4zQWFrwbVNlBBhrZotJcBd3IuFBvzDhewJpl+irN5TQK4a8pZznQChhFzLJLNb9LJ1kImGOybHrBthSmLOnHzSKikoGBghQAIQQOfgDBE9+wGV+BWuIkFXxeV2mjIGyt5DNCgH5d3kobOmlTU0S8w7AM75yFc/nenBpo5eLhyjAWaVLYShGvvhZuShZs8z1QLvmFFSv7+/0RiO+ut0KP6Pc4qgZjOnQ56iA0nBB7hDfJ6MkGStx0a/mVL5+ZwJwHG2pdu6rnboPOWogZalwqAYdA8ysheNdduebS/CmgLyVvDgYpqVyeDdkOnhcVb8SSXY2tLLGvHTRPmx7vR5SC05qT2arMcfl4Ui9cj2yAPVzi2ha0J6qnVC4RI4451B5zPKBKLbFswXRu1gIDHnwwMweXVU0xehFOuWLnPryezx6y/MXszo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(3023799007)(11063799006)(5023799004)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHBnaWNoR1h0Q3RScld6TERWWkxMK1NrdnNtekxSZTU1eXR4MmZnOUVhL3ZC?=
 =?utf-8?B?WUU2SGJwdVJpdVlPaUFXb2ExUGo1VnZpVDhYaGxmU0ZpdEJVc1hHbHVXemNH?=
 =?utf-8?B?anJWd2l1aFduYU1zRlR2WkVvOXkxeHdaMG84ZFVibXpKQ1N1b1ZKVDBma3FF?=
 =?utf-8?B?LzFjeUJGU0VGeXBaS3RJcEwydFZYRmYvNi9lLzBsTFhlTmlJbXlWWmhpeGVN?=
 =?utf-8?B?K1NZOHBIQnAxKzFoOGpFcDkyOGhYNjh2UG5RMVZ1am9wNnhPVWdEZUhBQmNL?=
 =?utf-8?B?SkVhbEdPWThIc2VnUUxYTXNjakJRcDdmak5kcDI1dXFxM1VsUGowdWxBVDFa?=
 =?utf-8?B?aVhyVHV0dUU0Tmx4OHV1VmEzd0dzYlhWak5DK2xmQ0NTSjFsR1o4YmEyR0hh?=
 =?utf-8?B?RzZ1emRTeEM1U2I1QTFZY2ZoYk5oNE5Id1hxOVZ4UlJXZm8xK3RrMWk2ZllS?=
 =?utf-8?B?ZzUvVU15UER4dklaZ0dOMEJrOElEeE0vYXVFMVRoK2FkOUlQdWZ2b0x4UEFl?=
 =?utf-8?B?YXR5bDFQQW4vNllQYU1IV1lPNFZ5cXRqS3RoVElpN2NNaHB4T1VVZmhCNjRv?=
 =?utf-8?B?Mk9UTWhBamxzVDlFeTFJZGw2eEZHYUdzcFA5TjMyaTFWRDVUUG4rSW9QbEp0?=
 =?utf-8?B?aVhwQ3p5Z3FHamZ5QlBBbFM5U3JkMGE4dFIyTEFrY2twN2NJamQ3aE55THZX?=
 =?utf-8?B?YS8vMGNRb1RucXkvL2xSd0dCUFFpY3pITjdXMytITDA1cFpWOHFVRm5CVHVU?=
 =?utf-8?B?QjkyRFltNHJkMTJ4S0x4STA4VVZuK0Y2S1duNXBLa2o1SnJaNm15eDlacENM?=
 =?utf-8?B?aE81ME02N0F5cWEzODdZWFpYVnpFS3NvM0w0Wk9lUFQxd2xtM1VJcVF4dGRh?=
 =?utf-8?B?eHFNamNWMVIyQ2EvL1JXL29mYksxanREdnJxUVBGVHdDbVZXN3RUekpmTkox?=
 =?utf-8?B?WXp5dGQ1WDF0VWhhZGs5TjlacFIxT0htNWJuVnYwM2tqVEJGY0J6UUZTb3ZG?=
 =?utf-8?B?T24yMjlvQ3RQZk5HK3dybS9aYnRsdDB5c0d1Sk9KR2x0cHlBUStqS1NxMDNB?=
 =?utf-8?B?RXNPWFVwVlN1d1AxUEdYU20waGVJRHU4QjhJQmJaV2dSQkVIaTdOczc1Z1M2?=
 =?utf-8?B?UG9jRW5JOHU1d0RiTm9ka01oR0JsS01xUTU2em9ZZWZxR3M4L2dOL3U4L1Z5?=
 =?utf-8?B?V1lvb1Z3NTZqYnc5Q3ZnR3BhWkRKTWhPUWNRWkhxMWtwcTc0dldNUW12WmE5?=
 =?utf-8?B?QlBMTlZzVjJlUFF0VDhkaVo1QmNEc1g2ZWMwMXJ4SmEvN2VxM0dNK0w5eDJo?=
 =?utf-8?B?MFM5SnBtbXhtSWkrQXJ6NUlSMHU2OEd4S3VGUWZUcFZScG85RE1nMzMrTUVi?=
 =?utf-8?B?dmFYYnRKTk02SUJEKzFaNklQMGFWSlJNdko4R3l0am5XRHIva2xreVR3TVNw?=
 =?utf-8?B?MVQvaEJ0bm1IV0JGa202ZE5xREg4ZDBWQlRrMXg1S3F6ek5NN0d4UG5nM3VM?=
 =?utf-8?B?NklmWDNJZUJKSVhsdGxSdDNYNVZ0V3RPMFdva0VxSWxpdmpPR3Vhdm9Cc0do?=
 =?utf-8?B?SjY5bmVmeTJPMHo5R2pDekFjajhvVjRwTUhDMjcwYmFLaHc2QmxXY3plYk5h?=
 =?utf-8?B?S09nUE1ycEt0MnJZbHpVTlRYWlhtZnZFdGhqNFhScmF2Y3MrZHBLYnYwbE9Q?=
 =?utf-8?B?TXoyM1dqaFRTczVHejZzOHZlOS9rd056TWMyTVl0OFk1OGxGSmM3UStWQXRB?=
 =?utf-8?B?RnVEbEdnRmk4UmNveUVGb2JYeHllZFR5SFFLdzJKMHVoZmFybjNaS2JoU1pt?=
 =?utf-8?B?TjZybzBFNm56NGVCQ01hWUV4cUplcmI4RFNEV3VRMmtaaWNrdlVEVXAweVJH?=
 =?utf-8?B?V0hNejhjV1dHTkZxbTZHMVp3MTdabjdlV1YrUXQ3WVhKSHYwT3NvUCtRREtT?=
 =?utf-8?B?RGRzVVdqMzRabDFsNHZoSDRsLzFsaEpielBWeUZpQ2F5M2lWcWYvUjl2L3R5?=
 =?utf-8?B?eXRFR1JXSUgzUHR6ZkEyYXNuVHNvZVhkczRoemsxZjY5c0o1aUcvbWpLWjBt?=
 =?utf-8?B?VGtGUHo1eGlUalNmY25uaGl5Mm1keEdHU0ZlVmhPY3RuUzVHYkRYNFYxRU5C?=
 =?utf-8?B?K3ZWVzVBdHR1elA0VTBQbEhaeVJLNEU5OFBsR1ZRK0NSUFYweE9JTUMxS0xE?=
 =?utf-8?B?TDI5S2c0QWluTTgrRTIzMVZGUHRCSG4ySkhnbmY3U0dQMFdQVkttdFJlODQ4?=
 =?utf-8?B?WHg1c2tzQ0tGYk92L3p4aXJ2UDJSMWlkNU5NM3pYSGxKRFN1NmJ5YU9tQlVZ?=
 =?utf-8?B?aGg5UThHeWhaRFAyQ0hzU3YwQWU3MXVON1JnUU5qUDZBZWJ0WEx6Zz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: abd6353e-cc22-4a88-8eb6-08df090f6bfb
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:29:55.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yW7GHte09RdZsPzyIBs5HZxKsLubs/7Tl/RtD4jyiHuRC5GQGsoD9fyW0lXmHv74ZFKNaTz5a5FELJGFBHCHwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESP189MB3209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21A8440003
X-Stat-Signature: m3kgpxyguscojfwu3bcr361ccsse8tba
X-HE-Tag: 1788366608-974910
X-HE-Meta: U2FsdGVkX19uRqoUpp7wExaAS4DIfr03lFlFkqcU7ZJXnWOxe6Y2RG12CsL1MqOjzkHo0dRmIefcwhoAAhKHthPOvR0knOyfbsgyokumpLiPiXlXkxpIeILCiyZ3Zr252q0bX9LrXqlsYXpD8cGWoX1rL+4+z9ouZvDlj0lbfuLXBCM+gLDUGgY7o4QKEC7wM/HItCqopV0C17JujnY+yDxR8gVpO72uRcFemZZ3GCTtLfRGHX4eDRFxZKp0DoL4GHwWdOHfeX7Yt3m7Ezn3DwxI1aSAMD1+zet7arczai0vCG2xo2UzlXMXjHTsJoCAb3aSDTBMl7zwBQKAtsJEBc9gIWpDJx4l4zLZRPKYrbVQMRXe5KJFhCTN130mRCyhJUNMBBTjBHFYSUrQveLH/MY31Fi9CTyHkEPr+msChVTSGvADholbaG7VpCvauRXCCJeg/w8abP0v+RbFMRFtxPWVknMRjpzxkD06FpCSOvyB3GYTrcudODoLgGYAl+6eKaAbD43RfSdmA9SFziiorJgiwYgTIwFFKSINRHMz3v2qyN0/zHpcOUd5te8lbNrXqf3dt5EusPbW4MRqXNIzmg/WIL2PJlKvFMiFiftIudw8QhmJwUByfCrovNCMIklEnKaOrvo4duBL4z4idhNDv7h4HfTKLycFKqLpkJ3XcO9quvP/vMh8TmVZGOPUPkayIQLtzCIz1jOboTSTqNjbPgZO77HGVDNj0DG+a5os10kuSRpAwx9T5gbKXmgvJ5KNf48MWdO5+lP/m8ZQEF/lAfJ0lwg6Gf8kivpc/mzodyn7deGIr3qbYFj/Jnfwpj2xWTKBRnZs41asMJ41qPZ0PoTBt1HfDYncmqSPpikM3oxv2IcbdP6m79kDwT5j4F0jWsZB7W7iHLCx+vXudOPc8shdGNE3oFgCqz7I9v6I/ZgHaA2pilp9q3qSFOG5/pFWFLmH9iemB+SMsD+1QaG
 3l7HqFAQ
 uV9k4xw1tqPl09Gftv1NiMU3maAZkZVkvLtiklC68IxZC9WrhZr9ef1TQwBuG8kbQBrs/5VSzqa8SraFgpifLnkkys4rOwbUkkD8hwBm26VC28cDCNw1GowyV/MhnYmzmVAz3fia10wy3ht+YQ6GpAKFluVdcGAUjYLPY44apoQSiEAzpKmcQVkCGNwkYOqbBLQnUDEf+pY2wXk/gSqts574qD/1z2pwiW5A9U2FW1n9qETQAY+rlm+lSmKu/RhiHcJ86Bk300sZU0sul8D/4Rd8rR4s+pI5XEoRwuUOw6A7HKgoPK+VHwURSf4tDqc1dcLy6YkiKfmYQESwziqfDjIbx2uuwXnx13iqllR56sCJZOw2C6IPV6iGUAdwF4S4GbVTbQoY2iwGNMhHsGZkCXRH7r5MeHUDPl4u4Is8snQyIBwKW2hUZg6OU90UqnQAPXZe/XjkzYzhrgQjYFWr4SxxKES7Egy9ie4LZGXQn7BVTqCGta2OgB0iXUtJXJlBEjXxG/HR88SrwjaFBOyta8Xc3hsFTUo4KIlrAft6ZlGMbbAxtUn9fgGQUsOzqVfh8IDM9yTL+iMBi8yQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCOV records which code a task reached. kcov_dataflow records what values
flowed through it: the arguments an instrumented function was called with
and the value it returned, per task, in execution order. This gives a
coverage-guided fuzzer a signal that plain edge coverage cannot provide
two calls to the same function with different arguments look identical to
edge coverage but differ here.

The values come from two SanitizerCoverage callbacks the compiler inserts
at function boundaries:

  __sanitizer_cov_trace_args   at entry, once per argument
  __sanitizer_cov_trace_ret    at return

For a pointer to a struct the callback passes the field offset table the
compiler derived from DWARF, and the kernel expands the struct into its
individual field values rather than recording an opaque address. Reads of
traced memory use copy_from_kernel_nofault() (a typed get_kernel_nofault()
for the 1/2/4/8-byte scalar cases), so a NULL or ERR_PTR the callee
received is recorded as KCOV_DF_MAGIC_BAD instead of faulting.

The passes are not upstream; they need a clang/rustc built with the
trace-args/trace-ret RFC [1]. When a task has no session enabled
the whole path is one boolean check.

Core (kernel/kcov_dataflow.c, split out of kcov.c on request):

 - Own debugfs device /sys/kernel/debug/kcov_dataflow with its own ioctl
   namespace ('d') and per-task mmap'd buffer, independent of KCOV, so
   both can run at once.
 - The session is a refcounted object (kcov_df_get/put) with a
   back-pointer from the task, mirroring mainline kcov's t->kcov: fd close
   from a sibling thread, a forked child, and task exit can no longer race
   into a use-after-free. task_struct gains kcov_df and the small
   kcov_df_* working set (include/linux/sched.h); fork clears it
   (kernel/fork.c) and exit tears any session down (kernel/exit.c).
 - Local (KCOV_DF_ENABLE) writes reserve buffer space with a plain area[0]
   update; remote (KCOV_DF_REMOTE_ENABLE) writes merge with a bounded
   atomic64_try_cmpxchg() loop. The two are mutually exclusive on one
   buffer, so they never both update area[0].
 - kcov_df_inert_context() rejects !in_task() and, crucially,
   pagefault_disabled() context. The trace-cmp callback is reachable from
   the ORC unwinder that KASAN runs on every slab free
   (stack_trace_save()); copy_from_kernel_nofault() brackets its loads
   with pagefault_disable(), so gating on that flag contains a whole class
   of self-instrumentation storms that would otherwise trip the
   soft-lockup watchdog, with no coverage exclusion needed in mm/ or arch/.
 - A per-task sequence guard (bit 31) suppresses re-entry nested inside
   our own callback under INSTRUMENT_ALL.

uapi (include/uapi/linux/kcov_dataflow.h): area[0] counts the record words
that follow; each record is a header word (sequence, type, value count,
size, argument index), the instrumented PC with the KASLR offset removed
like the PCs mainline kcov records, the traced pointer (ENTRY/RET) or the
comparison type (CMP), then the value words.

kcov.c: the __sanitizer_cov_trace_cmp*() / trace_switch() callbacks now
route their operand pairs through kcov_trace_cmp() in <linux/kcov.h>,
which feeds both the existing KCOV_MODE_TRACE_CMP buffer and, when a
dataflow session is live, the dataflow buffer; kcov.c itself no longer
references dataflow. kcov_check_handle() moves to <linux/kcov.h> as a
static inline so kcov_dataflow.c can validate KCOV_DF_REMOTE_ENABLE
handles with it.

objtool (tools/objtool/check.c): list kcov_df_trace_cmp() and the two
trace-args/ret entry points in uaccess_safe_builtin[], next to their
mainline peer write_comp_data(). The compiler emits the cmp callbacks
inside user_access_begin()/end() regions, and calling out of such a region
is only allowed to listed functions. They qualify on the same grounds:
notrace, __no_sanitize_coverage, no locks, no allocation, storing only
into the task's own buffer; kcov_df_reserve() is __always_inline so the
property does not depend on an inlining decision.

Build system (scripts/Makefile.kcov, scripts/Makefile.lib):

 - CFLAGS_KCOV_DATAFLOW = -fsanitize-coverage=trace-args,trace-ret (plus
   -fno-inline under CONFIG_KCOV_DATAFLOW_NO_INLINE), and the matching
   RUSTFLAGS for Rust objects.
 - Per-file opt-in KCOV_DATAFLOW_<obj>.o := y, or whole-kernel with
   CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL; KCOV_INSTRUMENT := n still excludes
   noinstr objects.
 - kcov_dataflow.o is built without KCOV, KASAN, KCSAN, UBSAN or KMSAN
   instrumentation to keep the collector from tracing itself.

Kconfig (lib/Kconfig.debug): CONFIG_KCOV_DATAFLOW_ARGS / _RET (depend on
KCOV, CC_IS_CLANG, DEBUG_INFO and the cc-option/rustc-option probe for the
pass), CONFIG_KCOV_DATAFLOW_NO_INLINE and
CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL. Because the options gate on
cc-option, a stock clang simply leaves them unset rather than failing.

[1] https://discourse.llvm.org/t/rfc-sanitizercoverage-add-fsanitize-coverage-trace-args-trace-ret/91026
[2] https://github.com/llvm/llvm-project/pull/201410
[3] https://github.com/llvm/llvm-project/pull/218254
[4] https://github.com/llvm/llvm-project/pull/218265

Link: https://github.com/yskzalloc/kcov-dataflow/
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 include/linux/kcov.h               |  116 ++++
 include/linux/sched.h              |   34 +
 include/uapi/linux/kcov_dataflow.h |   92 +++
 kernel/Makefile                    |    9 +
 kernel/exit.c                      |    1 +
 kernel/fork.c                      |    1 +
 kernel/kcov.c                      |   56 +-
 kernel/kcov_dataflow.c             | 1193 ++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                  |   52 ++
 scripts/Makefile.kcov              |   17 +
 scripts/Makefile.lib               |   14 +
 tools/objtool/check.c              |    4 +
 12 files changed, 1558 insertions(+), 31 deletions(-)

diff --git a/include/linux/kcov.h b/include/linux/kcov.h
index 895b761b2db15..55e1405bc4bc4 100644
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -3,6 +3,7 @@
 #define _LINUX_KCOV_H
 
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 #include <uapi/linux/kcov.h>
 
 struct task_struct;
@@ -28,6 +29,14 @@ enum kcov_mode {
 void kcov_task_init(struct task_struct *t);
 void kcov_task_exit(struct task_struct *t);
 
+#if defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET)
+void kcov_dataflow_task_init(struct task_struct *t);
+void kcov_dataflow_task_exit(struct task_struct *t);
+#else
+static inline void kcov_dataflow_task_init(struct task_struct *t) {}
+static inline void kcov_dataflow_task_exit(struct task_struct *t) {}
+#endif
+
 #define kcov_prepare_switch(t)			\
 do {						\
 	(t)->kcov_mode |= KCOV_IN_CTXSW;	\
@@ -43,6 +52,29 @@ void kcov_remote_start(u64 handle);
 void kcov_remote_stop(void);
 struct kcov_common_handle_id kcov_common_handle(void);
 
+/*
+ * Validate a remote handle: it must be a well-formed kcov_remote_handle()
+ * encoding, and each caller states which subsystem/instance combinations it
+ * accepts. Shared by KCOV_REMOTE_ENABLE and KCOV_DF_REMOTE_ENABLE so both
+ * collectors take handles from the same partitioned namespace.
+ */
+static inline bool kcov_check_handle(u64 handle, bool common_valid,
+				     bool uncommon_valid, bool zero_valid)
+{
+	if (handle & ~(KCOV_SUBSYSTEM_MASK | KCOV_INSTANCE_MASK))
+		return false;
+	switch (handle & KCOV_SUBSYSTEM_MASK) {
+	case KCOV_SUBSYSTEM_COMMON:
+		return (handle & KCOV_INSTANCE_MASK) ?
+			common_valid : zero_valid;
+	case KCOV_SUBSYSTEM_USB:
+		return uncommon_valid;
+	default:
+		return false;
+	}
+	return false;
+}
+
 static inline void kcov_remote_start_common(struct kcov_common_handle_id id)
 {
 	kcov_remote_start(kcov_remote_handle(KCOV_SUBSYSTEM_COMMON, id.val));
@@ -107,4 +139,88 @@ static inline void kcov_remote_start_usb_softirq(u64 id) {}
 static inline void kcov_remote_stop_softirq(void) {}
 
 #endif /* CONFIG_KCOV */
+
+/*
+ * kcov_dataflow remote API. The collector is a separate object from mainline
+ * kcov and is only linked in when at least one of the two capture modes is
+ * configured (see kernel/Makefile), so gate the declarations the same way
+ * kcov_dataflow_task_init() above is gated; a caller that brackets a region for
+ * both collectors then still builds on a KCOV-only config.
+ */
+#if defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET)
+void kcov_df_remote_start(u64 handle);
+void kcov_df_remote_stop(void);
+#else
+static inline void kcov_df_remote_start(u64 handle) {}
+static inline void kcov_df_remote_stop(void) {}
+#endif
+
+/*
+ * Handle-typed wrapper mirroring kcov_remote_start_common(), so a subsystem that
+ * already routes its mainline kcov remote sections by struct
+ * kcov_common_handle_id can open a dataflow section on the very same handle
+ * without knowing how it is encoded. The two collectors keep separate per-task
+ * state and separate handle tables, so a section of each may be nested around
+ * the same region; user space registers the identical handle value with
+ * KCOV_REMOTE_ENABLE and KCOV_DF_REMOTE_ENABLE to collect both.
+ *
+ * Unlike kcov_remote_start(), the dataflow section may only be opened from
+ * sleepable task context: kcov_df_remote_start()/kcov_df_remote_stop() take a
+ * mutex and may allocate or free the worker's scratch area. Both are no-ops in
+ * softirq/hardirq context, so a softirq-bracketing call site collects no
+ * dataflow records rather than misbehaving. A call site that is only
+ * sometimes atomic (spinlock held, preemption or irqs disabled) must not use
+ * this wrapper; CONFIG_DEBUG_ATOMIC_SLEEP reports such a caller.
+ *
+ * Without CONFIG_KCOV the handle carries no value (see struct
+ * kcov_common_handle_id), and dataflow depends on KCOV, so this is a no-op.
+ */
+#ifdef CONFIG_KCOV
+static inline void kcov_df_remote_start_common(struct kcov_common_handle_id id)
+{
+	kcov_df_remote_start(kcov_remote_handle(KCOV_SUBSYSTEM_COMMON, id.val));
+}
+#else
+static inline void kcov_df_remote_start_common(struct kcov_common_handle_id id)
+{
+}
+#endif
+#if defined(CONFIG_KCOV_ENABLE_COMPARISONS) && \
+	(defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET))
+/*
+ * CONFIG_KCOV_ENABLE_COMPARISONS provides ONE trace-cmp instrumentation shared by
+ * mainline kcov and kcov-dataflow. kcov.c's __sanitizer_cov_trace_cmp*() callbacks
+ * route each operand pair through kcov_trace_cmp() below, which fans it out:
+ * mainline kcov always sees it (write_comp_data() records only when the task is
+ * in KCOV_MODE_TRACE_CMP), and a task with a live dataflow session gets a copy in
+ * its dataflow buffer as well. The two collectors are independent fds with no
+ * cross-exclusion, so a task may collect for both at once, and a dataflow-side
+ * drop (inert context, full buffer) never costs mainline kcov a record. kcov.c
+ * never references the dataflow side, one cmp symbol feeds both collectors, and
+ * there is no separate df_cmp symbol or compiler change.
+ *
+ * The dataflow branch is gated by a static key so that, while no dataflow session
+ * is live, this whole-kernel hot path is a patched-out NOP that costs nothing on
+ * top of mainline write_comp_data() (kcov_df_cmp_key is inc'd on dataflow enable
+ * in kcov_dataflow.c).
+ */
+DECLARE_STATIC_KEY_FALSE(kcov_df_cmp_key);
+void write_comp_data(u64 type, u64 arg1, u64 arg2, u64 ip);
+void kcov_df_trace_cmp(u64 type, u64 arg1, u64 arg2, u64 ip);
+static inline notrace void
+kcov_trace_cmp(u64 type, u64 arg1, u64 arg2, u64 ip)
+{
+	write_comp_data(type, arg1, arg2, ip);			/* mainline kcov */
+	if (static_branch_unlikely(&kcov_df_cmp_key) && current->kcov_df_enabled)
+		kcov_df_trace_cmp(type, arg1, arg2, ip);	/* kcov-dataflow */
+}
+#elif defined(CONFIG_KCOV_ENABLE_COMPARISONS)
+/* Comparisons without a dataflow build: route straight to mainline kcov. */
+void write_comp_data(u64 type, u64 arg1, u64 arg2, u64 ip);
+static inline notrace void
+kcov_trace_cmp(u64 type, u64 arg1, u64 arg2, u64 ip)
+{
+	write_comp_data(type, arg1, arg2, ip);
+}
+#endif
 #endif /* _LINUX_KCOV_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 83416924701e8..49e506fd616c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1553,6 +1553,40 @@ struct task_struct {
 	/* KCOV sequence number: */
 	int				kcov_sequence;
 
+#if defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET)
+	/*
+	 * KCOV dataflow per-task record sequence counter (24 bits used) plus,
+	 * in bit 31, the recursion guard held while a callback is running:
+	 */
+	u32				kcov_df_seq;
+
+	/* KCOV dataflow: separate buffer for trace-args/trace-ret */
+	unsigned int			kcov_df_size;
+	void				*kcov_df_area;
+	bool				kcov_df_enabled;
+
+	/*
+	 * The kcov_dataflow object this task's session belongs to, NULL when
+	 * no session is active. The task holds a reference on it for the whole
+	 * session, whether local (KCOV_DF_ENABLE, mirrors t->kcov) or remote
+	 * (kcov_df_remote_start()), so the buffer can never be freed under an
+	 * instrumented callback and both task exit and kcov_df_remote_stop()
+	 * reach the exact object without a hash lookup.
+	 */
+	struct kcov_dataflow		*kcov_df;
+
+	/*
+	 * Nesting depth of kcov_df_remote_start() on this task: 0 while no
+	 * remote session is active (including during a local session), 1 for
+	 * a normal bracketed work item. If a buggy caller nests, the inner
+	 * start()s only bump this and the inner stop()s only decrement it, so
+	 * the OUTER session (buffer + ref) is torn down exactly once, at the
+	 * outermost stop -- never early, which would otherwise drop the ref
+	 * and free the buffer out from under the still-running outer worker.
+	 */
+	int				kcov_df_remote_depth;
+#endif
+
 	/* Collect coverage from softirq context: */
 	unsigned int			kcov_softirq;
 
diff --git a/include/uapi/linux/kcov_dataflow.h b/include/uapi/linux/kcov_dataflow.h
new file mode 100644
index 0000000000000..db3112a45832c
--- /dev/null
+++ b/include/uapi/linux/kcov_dataflow.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_KCOV_DATAFLOW_H
+#define _LINUX_KCOV_DATAFLOW_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/*
+ * User space ABI of /sys/kernel/debug/kcov_dataflow, see
+ * Documentation/dev-tools/kcov-dataflow.rst.
+ *
+ * KCOV_DF_INIT_TRACK takes the buffer size in u64 words by value (same
+ * convention as KCOV_INIT_TRACE). KCOV_DF_REMOTE_ENABLE takes a pointer to a
+ * __u64 remote handle encoded with kcov_remote_handle() (linux/kcov.h), so the
+ * full 64-bit value survives 32-bit and compat callers.
+ */
+#define KCOV_DF_INIT_TRACK	_IOR('d', 1, unsigned long)
+#define KCOV_DF_ENABLE		_IO('d', 100)
+#define KCOV_DF_DISABLE		_IO('d', 101)
+#define KCOV_DF_REMOTE_ENABLE	_IOW('d', 102, __u64)
+#define KCOV_DF_REMOTE_DISABLE	_IO('d', 103)
+
+/*
+ * Buffer layout (all u64 words):
+ *
+ *   area[0]                number of record words written after area[0]
+ *   area[1 + n ..]         records, back to back, each:
+ *
+ *     [0] header           see KCOV_DF_HDR_* below
+ *     [1] pc               instrumented location; KASLR offset removed, like
+ *                          the PCs mainline kcov records
+ *     [2] ENTRY/RET: the traced value's address (full pointer); may be a
+ *                    NULL/ERR_PTR value the callee received, in which case the
+ *                    value words hold KCOV_DF_MAGIC_BAD
+ *         CMP:       comparison type, KCOV_CMP_SIZE()/KCOV_CMP_CONST bits
+ *                    (linux/kcov.h)
+ *     [3 .. 3 + nvals)     value words: the scalar (nvals == 1), the expanded
+ *                          struct fields, or the two CMP operands (nvals == 2)
+ *
+ * The header packs:
+ *
+ *   bits  0..23  per-task record sequence number
+ *   bits 28..31  record type, KCOV_DF_TYPE_*
+ *   bits 32..47  nvals, the number of value words that follow word [2]
+ *   bits 48..55  ENTRY/RET: size in bytes of the traced argument/return value
+ *                (clamped to 255)
+ *   bits 56..63  ENTRY: argument index (clamped to 255); RET: 0
+ *
+ * A consumer walks the buffer as
+ *
+ *	pos = 1;
+ *	while (pos < 1 + area[0]) {
+ *		hdr = area[pos];
+ *		nvals = KCOV_DF_HDR_NVALS(hdr);
+ *		...
+ *		pos += KCOV_DF_RECORD_WORDS(nvals);
+ *	}
+ *
+ * area[0] never exceeds the buffer size minus one, and every counted word has
+ * been written, so the walk above stays inside the mapping.
+ */
+#define KCOV_DF_TYPE_CMP	0xC
+#define KCOV_DF_TYPE_ENTRY	0xE
+#define KCOV_DF_TYPE_RET	0xF
+
+#define KCOV_DF_HDR_SEQ_MASK	0x00FFFFFFULL
+#define KCOV_DF_HDR_TYPE_SHIFT	28
+#define KCOV_DF_HDR_TYPE_MASK	0xFULL
+#define KCOV_DF_HDR_NVALS_SHIFT	32
+#define KCOV_DF_HDR_NVALS_MASK	0xFFFFULL
+#define KCOV_DF_HDR_SIZE_SHIFT	48
+#define KCOV_DF_HDR_SIZE_MASK	0xFFULL
+#define KCOV_DF_HDR_ARGIDX_SHIFT 56
+#define KCOV_DF_HDR_ARGIDX_MASK	0xFFULL
+
+#define KCOV_DF_HDR_SEQ(h)	((h) & KCOV_DF_HDR_SEQ_MASK)
+#define KCOV_DF_HDR_TYPE(h)	(((h) >> KCOV_DF_HDR_TYPE_SHIFT) & KCOV_DF_HDR_TYPE_MASK)
+#define KCOV_DF_HDR_NVALS(h)	(((h) >> KCOV_DF_HDR_NVALS_SHIFT) & KCOV_DF_HDR_NVALS_MASK)
+#define KCOV_DF_HDR_SIZE(h)	(((h) >> KCOV_DF_HDR_SIZE_SHIFT) & KCOV_DF_HDR_SIZE_MASK)
+#define KCOV_DF_HDR_ARGIDX(h)	(((h) >> KCOV_DF_HDR_ARGIDX_SHIFT) & KCOV_DF_HDR_ARGIDX_MASK)
+
+/* Words per record: header, pc, pointer/cmp-type, then the value words. */
+#define KCOV_DF_RECORD_HDR_WORDS	3
+#define KCOV_DF_RECORD_WORDS(nvals)	(KCOV_DF_RECORD_HDR_WORDS + (nvals))
+
+/* Largest nvals a record can carry; longer field lists are truncated. */
+#define KCOV_DF_MAX_VALS	KCOV_DF_HDR_NVALS_MASK
+
+/* Value word written when the traced pointer or a field could not be read. */
+#define KCOV_DF_MAGIC_BAD	0xBADADD85ULL
+
+#endif /* _LINUX_KCOV_DATAFLOW_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 1e1a31673577d..307b7fd1e1f96 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -44,6 +44,12 @@ KCSAN_SANITIZE_kcov.o := n
 UBSAN_SANITIZE_kcov.o := n
 KMSAN_SANITIZE_kcov.o := n
 
+KCOV_INSTRUMENT_kcov_dataflow.o := n
+KASAN_SANITIZE_kcov_dataflow.o := n
+KCSAN_SANITIZE_kcov_dataflow.o := n
+UBSAN_SANITIZE_kcov_dataflow.o := n
+KMSAN_SANITIZE_kcov_dataflow.o := n
+
 CONTEXT_ANALYSIS_kcov.o := y
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
@@ -98,6 +104,9 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o audit_watch.o audit_fsnotify.o audit_tree.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_KCOV) += kcov.o
+ifneq ($(CONFIG_KCOV_DATAFLOW_ARGS)$(CONFIG_KCOV_DATAFLOW_RET),)
+obj-y += kcov_dataflow.o
+endif
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_FAIL_FUNCTION) += fail_function.o
 obj-$(CONFIG_KGDB) += debug/
diff --git a/kernel/exit.c b/kernel/exit.c
index 97686af895013..8881661d635ba 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -939,6 +939,7 @@ void __noreturn do_exit(long code)
 		kthread_do_exit(kthread, code);
 
 	kcov_task_exit(tsk);
+	kcov_dataflow_task_exit(tsk);
 	kmsan_task_exit(tsk);
 
 	synchronize_group_exit(tsk, code);
diff --git a/kernel/fork.c b/kernel/fork.c
index 416758c8a3d43..d26b9dd39872e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -985,6 +985,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->worker_private = NULL;
 
 	kcov_task_init(tsk);
+	kcov_dataflow_task_init(tsk);
 	kmsan_task_create(tsk);
 	kmap_local_fork(tsk);
 
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 35420f0ac524d..cac9b69e197ed 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -232,7 +232,14 @@ void notrace __sanitizer_cov_trace_pc(void)
 EXPORT_SYMBOL(__sanitizer_cov_trace_pc);
 
 #ifdef CONFIG_KCOV_ENABLE_COMPARISONS
-static void notrace write_comp_data(u64 type, u64 arg1, u64 arg2, u64 ip)
+/*
+ * Mainline kcov comparison writer: appends to the task's own kcov buffer, and
+ * only in KCOV_MODE_TRACE_CMP. The fan-out that also feeds the kcov-dataflow
+ * buffer lives in kcov_trace_cmp() in <linux/kcov.h>, so kcov.c never references
+ * the dataflow side itself. This writer is only non-static so that header helper
+ * (which the cmp callbacks below call) can reach it.
+ */
+void notrace write_comp_data(u64 type, u64 arg1, u64 arg2, u64 ip)
 {
 	struct task_struct *t;
 	u64 *area;
@@ -267,55 +274,59 @@ static void notrace write_comp_data(u64 type, u64 arg1, u64 arg2, u64 ip)
 	}
 }
 
+/*
+ * The __sanitizer_cov_trace_cmp*() callbacks stay here in kcov.c (one shared,
+ * compiler-emitted symbol per comparison -- no separate df_cmp symbol, no
+ * compiler change). Each routes its operand pair through kcov_trace_cmp()
+ * (defined in <linux/kcov.h>), which records into mainline kcov and, when this
+ * task has a dataflow session, into kcov-dataflow too. kcov.c never names the
+ * dataflow side; that fan-out lives entirely in the header.
+ */
 void notrace __sanitizer_cov_trace_cmp1(u8 arg1, u8 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(0), arg1, arg2, _RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(0), arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_cmp1);
 
 void notrace __sanitizer_cov_trace_cmp2(u16 arg1, u16 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(1), arg1, arg2, _RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(1), arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_cmp2);
 
 void notrace __sanitizer_cov_trace_cmp4(u32 arg1, u32 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(2), arg1, arg2, _RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(2), arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_cmp4);
 
 void notrace __sanitizer_cov_trace_cmp8(kcov_u64 arg1, kcov_u64 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(3), arg1, arg2, _RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(3), arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_cmp8);
 
 void notrace __sanitizer_cov_trace_const_cmp1(u8 arg1, u8 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(0) | KCOV_CMP_CONST, arg1, arg2,
-			_RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(0) | KCOV_CMP_CONST, arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp1);
 
 void notrace __sanitizer_cov_trace_const_cmp2(u16 arg1, u16 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(1) | KCOV_CMP_CONST, arg1, arg2,
-			_RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(1) | KCOV_CMP_CONST, arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp2);
 
 void notrace __sanitizer_cov_trace_const_cmp4(u32 arg1, u32 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(2) | KCOV_CMP_CONST, arg1, arg2,
-			_RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(2) | KCOV_CMP_CONST, arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp4);
 
 void notrace __sanitizer_cov_trace_const_cmp8(kcov_u64 arg1, kcov_u64 arg2)
 {
-	write_comp_data(KCOV_CMP_SIZE(3) | KCOV_CMP_CONST, arg1, arg2,
-			_RET_IP_);
+	kcov_trace_cmp(KCOV_CMP_SIZE(3) | KCOV_CMP_CONST, arg1, arg2, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp8);
 
@@ -344,7 +355,7 @@ void notrace __sanitizer_cov_trace_switch(kcov_u64 val, void *arg)
 		return;
 	}
 	for (i = 0; i < count; i++)
-		write_comp_data(type, cases[i + 2], val, _RET_IP_);
+		kcov_trace_cmp(type, cases[i + 2], val, _RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_switch);
 #endif /* ifdef CONFIG_KCOV_ENABLE_COMPARISONS */
@@ -587,23 +598,6 @@ static void kcov_fault_in_area(struct kcov *kcov)
 		READ_ONCE(area[offset]);
 }
 
-static inline bool kcov_check_handle(u64 handle, bool common_valid,
-				bool uncommon_valid, bool zero_valid)
-{
-	if (handle & ~(KCOV_SUBSYSTEM_MASK | KCOV_INSTANCE_MASK))
-		return false;
-	switch (handle & KCOV_SUBSYSTEM_MASK) {
-	case KCOV_SUBSYSTEM_COMMON:
-		return (handle & KCOV_INSTANCE_MASK) ?
-			common_valid : zero_valid;
-	case KCOV_SUBSYSTEM_USB:
-		return uncommon_valid;
-	default:
-		return false;
-	}
-	return false;
-}
-
 static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 			     unsigned long arg)
 	__must_hold(&kcov->lock)
diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
new file mode 100644
index 0000000000000..641d6bc763864
--- /dev/null
+++ b/kernel/kcov_dataflow.c
@@ -0,0 +1,1193 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KCOV Dataflow: per-task function argument/return value capture.
+ *
+ * Exposes /sys/kernel/debug/kcov_dataflow, completely independent from
+ * /sys/kernel/debug/kcov. Own buffer, own ioctl, own mmap.
+ *
+ * The user-visible ABI:
+ *
+ * ioctls, the record layout and the header bit fields, is defined in
+ * <uapi/linux/kcov_dataflow.h>. In short, every record is
+ *
+ *   [hdr][pc][ptr or cmp type][nvals value words]
+ *
+ * appended after area[0], which counts the record words written so far.
+ */
+#define pr_fmt(fmt) "kcov_dataflow: " fmt
+
+#define DISABLE_BRANCH_PROFILING
+#include <linux/atomic.h>
+#include <linux/bits.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/minmax.h>
+#include <linux/mm.h>
+#include <linux/preempt.h>
+#include <linux/refcount.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/shrinker.h>
+#include <linux/mutex.h>
+#include <linux/hashtable.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/jump_label.h>
+#include <linux/kcov.h>
+#include <uapi/linux/kcov_dataflow.h>
+#include <asm/setup.h>
+
+/*
+ * Comparison capture is shared with mainline kcov; it only exists when both the
+ * trace-cmp instrumentation and the dataflow task state are configured in.
+ */
+#if defined(CONFIG_KCOV_ENABLE_COMPARISONS) && \
+	(defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET))
+#define KCOV_DF_HAVE_CMP 1
+#endif
+
+#define KCOV_DF_IS_ERR(p)	((unsigned long)(p) >= (unsigned long)-4095UL)
+
+/*
+ * Bit 31 of task_struct::kcov_df_seq is the per-task recursion guard, held
+ * while one of the callbacks below runs. The record sequence number lives in
+ * the low 24 bits (KCOV_DF_HDR_SEQ_MASK) and is advanced with kcov_df_next_seq()
+ * so that it wraps inside its own field and can never carry into the guard.
+ */
+#define KCOV_DF_SEQ_GUARD	BIT(31)
+
+/*
+ * Per-worker private scratch size (u64 words), KCOV's remote-area model: a
+ * remote kworker collects into its OWN scratch and merges it into the shared
+ * ->area at kcov_df_remote_stop(). Fixed and small (8 MiB) -- one work item's
+ * coverage, not a whole buffer -- so the pool of recycled scratch areas stays
+ * bounded regardless of how many kworkers churn. Overflowing a scratch just
+ * drops that worker's excess records (same as a full buffer), never corrupts.
+ */
+#define KCOV_DF_REMOTE_WORDS	(1UL << 20)
+
+struct kcov_dataflow {
+	struct mutex	lock;
+	unsigned int	size;	/* in u64 words */
+	void		*area;
+	/*
+	 * Task with a local (KCOV_DF_ENABLE) session on this object, NULL if
+	 * none. Mirrors struct kcov::t: that task holds its own reference (see
+	 * ->refcount) and points back at us through task_struct::kcov_df, so
+	 * KCOV_DF_DISABLE, close() and task exit all unwire the same session.
+	 */
+	struct task_struct *t;
+	/*
+	 * Lifetime refcount (KCOV's struct kcov pattern). The open fd holds one
+	 * ref; the task enabled with KCOV_DF_ENABLE holds one for as long as its
+	 * session lasts (dropped by KCOV_DF_DISABLE, by close() from that task,
+	 * or by task exit -- it cannot be unwired from another task); each
+	 * kcov_df_remote_start() takes one and the matching kcov_df_remote_stop()
+	 * drops it. Whoever drops the LAST ref frees ->area and the object
+	 * (kcov_df_put), so an instrumented callback can never write through a
+	 * freed buffer, whichever task does the final close().
+	 */
+	refcount_t	refcount;
+	u64		remote_handle; /* handle for remote lookup, 0 if not published */
+#ifdef KCOV_DF_HAVE_CMP
+	/*
+	 * Whether this fd holds a ref on kcov_df_cmp_key, tracked SEPARATELY for
+	 * the local (KCOV_DF_ENABLE) and remote (KCOV_DF_REMOTE_ENABLE) sources.
+	 * A single shared flag let a KCOV_DF_DISABLE drop the key while a remote
+	 * handle was still published -- silently losing the live remote workers'
+	 * comparison records. Two flags mean releasing one source never pulls the
+	 * key out from under the other. Both are only touched under ->lock.
+	 */
+	bool		cmp_key_local;
+	bool		cmp_key_remote;
+#endif
+};
+
+/* Which activation source holds the cmp static key (see kcov_df_cmp_key_hold). */
+enum { KCOV_DF_CMP_LOCAL, KCOV_DF_CMP_REMOTE };
+
+#ifdef KCOV_DF_HAVE_CMP
+/*
+ * Static key gating the per-comparison dataflow check in kcov_trace_cmp()
+ * (linux/kcov.h). It is a patched-out NOP until at least one dataflow session is
+ * live, so trace-cmp across the WHOLE kernel costs nothing extra while no
+ * dataflow fuzzing runs; only an active session flips it on. Refcounted: inc on
+ * each source's first enable, dec on its disable/close/exit (idempotent,
+ * tracked per source via cmp_key_local / cmp_key_remote so releasing one never
+ * drops the key from under the other).
+ *
+ * The key is only ever inc'd/dec'd from ioctl, close() and do_exit() context,
+ * under df->lock -- never from kcov_df_remote_stop() or the last kcov_df_put(),
+ * so a subsystem's worker path never ends up under cpus_read_lock() and
+ * jump_label_mutex. The static_branch_{inc,dec}() text-patch is amortised -- it
+ * fires only on the 0->1 and 1->0 transitions, not per fd while sessions overlap.
+ */
+DEFINE_STATIC_KEY_FALSE(kcov_df_cmp_key);
+EXPORT_SYMBOL(kcov_df_cmp_key);
+
+static void kcov_df_cmp_key_hold(struct kcov_dataflow *df, int which)
+{
+	bool *held = which == KCOV_DF_CMP_LOCAL ? &df->cmp_key_local
+						: &df->cmp_key_remote;
+
+	lockdep_assert_held(&df->lock);
+	if (!*held) {
+		*held = true;
+		static_branch_inc(&kcov_df_cmp_key);
+	}
+}
+
+static void kcov_df_cmp_key_release(struct kcov_dataflow *df, int which)
+{
+	bool *held = which == KCOV_DF_CMP_LOCAL ? &df->cmp_key_local
+						: &df->cmp_key_remote;
+
+	lockdep_assert_held(&df->lock);
+	if (*held) {
+		*held = false;
+		static_branch_dec(&kcov_df_cmp_key);
+	}
+}
+
+static bool kcov_df_cmp_key_held(struct kcov_dataflow *df)
+{
+	return df->cmp_key_local || df->cmp_key_remote;
+}
+#else
+static void kcov_df_cmp_key_hold(struct kcov_dataflow *df, int which) {}
+static void kcov_df_cmp_key_release(struct kcov_dataflow *df, int which) {}
+static bool kcov_df_cmp_key_held(struct kcov_dataflow *df) { return false; }
+#endif
+
+/* Remote dataflow: handle-based lookup (follows KCOV's kcov_remote_map pattern) */
+static DEFINE_MUTEX(kcov_df_remote_lock);
+static DEFINE_HASHTABLE(kcov_df_remote_map, 4);
+
+struct kcov_df_remote {
+	u64			handle;
+	struct kcov_dataflow	*df;
+	struct hlist_node	hnode;
+};
+
+static struct kcov_df_remote *kcov_df_remote_find(u64 handle)
+{
+	struct kcov_df_remote *remote;
+
+	hash_for_each_possible(kcov_df_remote_map, remote, hnode, handle) {
+		if (remote->handle == handle)
+			return remote;
+	}
+	return NULL;
+}
+
+/* Unpublish @df's remote handle, if any; no new remote session can start. */
+static void kcov_df_remote_unpublish(struct kcov_dataflow *df)
+{
+	struct kcov_df_remote *remote;
+
+	mutex_lock(&kcov_df_remote_lock);
+	if (df->remote_handle) {
+		remote = kcov_df_remote_find(df->remote_handle);
+		if (remote) {
+			hash_del(&remote->hnode);
+			kfree(remote);
+		}
+		df->remote_handle = 0;
+	}
+	mutex_unlock(&kcov_df_remote_lock);
+}
+
+static void kcov_df_get(struct kcov_dataflow *df)
+{
+	refcount_inc(&df->refcount);
+}
+
+/*
+ * Drop a reference; the last one frees the buffer and the object. Only called
+ * from sleepable task context (ioctl, close(), do_exit(), and remote_stop()
+ * which requires it), so vfree() here is fine. No caller may touch @df after
+ * its own kcov_df_put(). Every path that unwires a session releases its cmp
+ * key ref under df->lock first, so nothing is left to balance here.
+ */
+static void kcov_df_put(struct kcov_dataflow *df)
+{
+	if (refcount_dec_and_test(&df->refcount)) {
+		WARN_ON_ONCE(kcov_df_cmp_key_held(df));
+		vfree(df->area);
+		kfree(df);
+	}
+}
+
+/*
+ * Touch every page of a buffer before a task starts collecting into it, the
+ * same way kcov_fault_in_area() does for KCOV_ENABLE: on configurations with
+ * lazily populated vmalloc mappings the first access would otherwise fault
+ * from inside an instrumented callback, and code on the vmalloc fault path may
+ * itself be instrumented.
+ */
+static void kcov_df_fault_in_area(u64 *area, unsigned long size)
+{
+	unsigned long stride = PAGE_SIZE / sizeof(u64);
+	unsigned long off;
+
+	for (off = 0; off < size; off += stride)
+		READ_ONCE(area[off]);
+}
+
+/*
+ * Pool of recycled per-worker scratch areas (KCOV's kcov_remote_areas). All are
+ * KCOV_DF_REMOTE_WORDS u64s. While parked on the freelist the area's first bytes
+ * hold this list_head; while in use word[0] is the scratch write cursor. Guarded
+ * by kcov_df_remote_lock.
+ */
+struct kcov_df_scratch {
+	struct list_head list;
+};
+static LIST_HEAD(kcov_df_scratch_pool);
+static unsigned long kcov_df_scratch_pool_nr;	/* idle areas parked in the pool */
+
+/* Take a scratch area from the pool, or NULL if empty (caller vmalloc()s one). */
+static void *kcov_df_scratch_get(void)
+{
+	struct kcov_df_scratch *s;
+
+	if (list_empty(&kcov_df_scratch_pool))
+		return NULL;
+	s = list_first_entry(&kcov_df_scratch_pool, struct kcov_df_scratch, list);
+	list_del(&s->list);
+	kcov_df_scratch_pool_nr--;
+	return s;
+}
+
+/* Return a scratch area to the pool for reuse. */
+static void kcov_df_scratch_put(void *area)
+{
+	struct kcov_df_scratch *s = area;
+
+	INIT_LIST_HEAD(&s->list);
+	list_add(&s->list, &kcov_df_scratch_pool);
+	kcov_df_scratch_pool_nr++;
+}
+
+/*
+ * Merge a remote worker's private scratch into the shared ->area, appending its
+ * records at the shared write cursor. This is the ONE many-writers path (several
+ * kworkers merge concurrently), so it claims its region with a cmpxchg loop on
+ * area[0]: the bounds are checked against the value about to be committed, and
+ * the commit only happens when the record fits. area[0] therefore never exceeds
+ * the buffer capacity and every counted word has been written, so a consumer
+ * walking area[0] words stays inside its mapping. A concurrent reset by user
+ * space (writing area[0] = 0 to restart collection) simply makes the cmpxchg
+ * fail and the loop re-read the new cursor; there is no subtract, so the
+ * counter can never go negative or wrap past the bounds check. Each merge claims
+ * a disjoint [start, start+n), so concurrent merges don't overlap and need no
+ * lock. @df is kept alive by the caller's reference, so ->area is stable here.
+ *
+ * ->area is never written through kcov_df_reserve() while a remote handle is
+ * published (KCOV_DF_ENABLE refuses that), so this atomic cursor update never
+ * races a plain read-modify-write of the same word.
+ */
+static void kcov_df_merge(struct kcov_dataflow *df, const u64 *scratch)
+{
+	u64 *area = df->area;
+	atomic64_t *cursor;
+	u64 n, count, capacity;
+	s64 old;
+
+	if (!area)
+		return;
+	/*
+	 * scratch[0] is an EXACT high-water of written words: kcov_df_reserve()
+	 * commits the count only after a record fits, so every counted word was
+	 * really written -- the merge never publishes the unwritten
+	 * (recycled/uninitialized) tail of a pooled scratch. The clamp below is thus
+	 * belt-and-suspenders against a stray count.
+	 */
+	n = scratch[0];
+	if (n > KCOV_DF_REMOTE_WORDS - 1)
+		n = KCOV_DF_REMOTE_WORDS - 1;
+	if (!n)
+		return;
+
+	capacity = df->size - 1;	/* words after area[0] */
+	cursor = (atomic64_t *)&area[0];
+	old = atomic64_read(cursor);
+	do {
+		count = old;
+		/* Full (or a garbage cursor from user space): drop the records. */
+		if (count > capacity || n > capacity - count)
+			return;
+	} while (!atomic64_try_cmpxchg(cursor, &old, count + n));
+	memcpy(&area[1 + count], &scratch[1], n * sizeof(u64));
+}
+
+/*
+ * Reserve @record_len u64 words in the current task's buffer. On success return
+ * true and store the 1-based start index of the record's data region.
+ *
+ * Single-writer discipline, identical to mainline kcov.c: the current task is the
+ * ONLY instrumented writer of @area. In remote mode @area is this kworker's OWN
+ * private scratch; in local (KCOV_DF_ENABLE) mode it is the enabling task's own
+ * mmapped buffer -- and only one task can hold that (the KCOV_DF_ENABLE EBUSY
+ * guard, which also refuses a buffer with a published remote handle, so
+ * kcov_df_merge() never touches this word concurrently). Two tasks never write
+ * the same @area here, so no atomic is needed: validate FIRST and commit the
+ * count (area[0]) only on success, so area[0] is always an EXACT high-water of
+ * written words and no consumer (userspace or kcov_df_merge()) ever sees an
+ * unwritten/recycled slot.
+ *
+ * (Publishing a worker's scratch into the shared ->area is the SEPARATE
+ * kcov_df_merge() path, which DOES reserve atomically because many kworkers merge
+ * concurrently.)
+ *
+ * READ_ONCE/WRITE_ONCE because in local mode userspace may reset area[0] to 0
+ * between operations. That reset can only drive the count to 0, never negative
+ * (there is no subtract), so a racing reset may drop records but can never produce
+ * an out-of-bounds store. This is exactly mainline kcov's contract.
+ *
+ * __always_inline because kcov_df_trace_cmp() below is on objtool's
+ * uaccess_safe_builtin[] list, and objtool rejects any out-of-line call made
+ * from such a function; do not leave that to the optimizer.
+ */
+static __always_inline notrace __no_sanitize_coverage bool
+kcov_df_reserve(struct task_struct *t, u64 *area, u32 record_len,
+		unsigned long *start_index)
+{
+	unsigned long count = READ_ONCE(area[0]);
+
+	*start_index = 1 + count;
+	if (count >= t->kcov_df_size ||
+	    record_len > t->kcov_df_size - *start_index)
+		return false;
+	WRITE_ONCE(area[0], count + record_len);
+	return true;
+}
+
+/*
+ * Contexts where dataflow collection must stay completely inert.
+ *
+ * Beyond the obvious !in_task() case, this bails whenever page faults are
+ * disabled. copy_from_kernel_nofault() -- used by kcov_df_write() below to read
+ * traced pointers, and, crucially, by the ORC stack unwinder that KASAN runs on
+ * every slab free (set_track_prepare() -> stack_trace_save()) -- brackets its
+ * raw loads with pagefault_disable(), and those loads carry trace-cmp/trace-args
+ * instrumentation. Without this bail a single stack walk under a fuzzing + KASAN
+ * workload floods the collector with a callback per load and soft-locks the CPU.
+ *
+ * pagefault_disabled() is true throughout any such nofault region no matter
+ * which instrumented leaf issued the callback, so testing it here contains the
+ * whole class of self-instrumentation storms -- the bit-31 recursion guard below
+ * only covers re-entry nested inside our own callback, not a fresh entry from
+ * the unwinder/KASAN path. Contained entirely to this file: no coverage
+ * exclusion in mm/ or arch/ is needed.
+ *
+ * The trade-off is that records are also dropped inside unrelated
+ * pagefault_disable() regions (kmap_atomic() on HIGHMEM, futex and perf
+ * callchain probes, ...). Those are short and rare on the fuzzing workloads this
+ * targets; a per-task "in nofault region" flag would remove the coupling at the
+ * cost of touching mm/maccess.c.
+ */
+static __always_inline notrace __no_sanitize_coverage bool
+kcov_df_inert_context(void)
+{
+	return !in_task() || pagefault_disabled();
+}
+
+/* Same as kcov.c: record PCs with the KASLR offset removed. */
+static __always_inline notrace __no_sanitize_coverage u64
+kcov_df_canonicalize_ip(u64 ip)
+{
+#ifdef CONFIG_RANDOMIZE_BASE
+	ip -= kaslr_offset();
+#endif
+	return ip;
+}
+
+/*
+ * Advance the task's 24-bit record sequence number, keeping the guard bit set.
+ * Masking the increment keeps the counter from ever carrying into
+ * KCOV_DF_SEQ_GUARD, which would reopen re-entry in the middle of a record.
+ */
+static __always_inline notrace __no_sanitize_coverage u32
+kcov_df_next_seq(struct task_struct *t)
+{
+	u32 seq = (t->kcov_df_seq + 1) & KCOV_DF_HDR_SEQ_MASK;
+
+	t->kcov_df_seq = KCOV_DF_SEQ_GUARD | seq;
+	return seq;
+}
+
+static __always_inline notrace __no_sanitize_coverage u64
+kcov_df_hdr(u64 type, u32 nvals, u32 size, u32 arg_idx, u32 seq)
+{
+	return (type << KCOV_DF_HDR_TYPE_SHIFT) |
+	       ((u64)nvals << KCOV_DF_HDR_NVALS_SHIFT) |
+	       ((u64)min_t(u32, size, KCOV_DF_HDR_SIZE_MASK) <<
+		KCOV_DF_HDR_SIZE_SHIFT) |
+	       ((u64)min_t(u32, arg_idx, KCOV_DF_HDR_ARGIDX_MASK) <<
+		KCOV_DF_HDR_ARGIDX_SHIFT) |
+	       (seq & KCOV_DF_HDR_SEQ_MASK);
+}
+
+/*
+ * Core write function for ENTRY/RET records.
+ * Uses the same READ_ONCE/WRITE_ONCE pattern as write_comp_data() in kcov.c.
+ *
+ * @num_fields is the length of the compiler-supplied @offsets table (pairs of
+ * offset,size) for an expanded struct, 0 for a scalar read directly from @ptr
+ * with width @size. It is clamped to KCOV_DF_MAX_VALS so the record length can
+ * never wrap and the field loop is bounded by the words actually reserved.
+ */
+static noinline notrace __no_sanitize_coverage void
+kcov_df_write(u64 type, u64 pc, u32 arg_idx, u32 size, void *ptr,
+	      u64 *offsets, u32 num_fields)
+{
+	struct task_struct *t = current;
+	u64 *area;
+	unsigned long start_index;
+	u32 nvals, seq, i;
+
+	if (kcov_df_inert_context())
+		return;
+
+	if (!t->kcov_df_enabled)
+		return;
+
+	/*
+	 * Prevent recursion: functions called by this callback
+	 * (copy_from_kernel_nofault) may be instrumented. Use the
+	 * sequence counter's high bit as a per-task guard.
+	 */
+	if (t->kcov_df_seq & KCOV_DF_SEQ_GUARD)
+		return;
+	t->kcov_df_seq |= KCOV_DF_SEQ_GUARD;
+	/* Paired with the barrier() before the guard is cleared at out:. */
+	barrier();
+
+	area = (u64 *)t->kcov_df_area;
+	if (!area)
+		goto out;
+
+	if (num_fields > KCOV_DF_MAX_VALS)
+		num_fields = KCOV_DF_MAX_VALS;
+	/* Record: header + pc + ptr, then the fields or one scalar word. */
+	nvals = num_fields > 0 ? num_fields : 1;
+
+	if (!kcov_df_reserve(t, area, KCOV_DF_RECORD_WORDS(nvals), &start_index))
+		goto out;
+
+	seq = kcov_df_next_seq(t);
+	area[start_index] = kcov_df_hdr(type, nvals, size, arg_idx, seq);
+	area[start_index + 1] = kcov_df_canonicalize_ip(pc);
+	area[start_index + 2] = (u64)(unsigned long)ptr;
+
+	if (num_fields == 0) {
+		u64 val = 0;
+		u32 sz = size;
+
+		/*
+		 * Read the scalar with a compile-time-constant width for the
+		 * common sizes so the compiler folds away copy_from_kernel_
+		 * nofault()'s runtime size loop and alignment branching; fall
+		 * back to the variable-size byte copy for anything else. A
+		 * faulting read leaves val == 0, matching the prior best-effort
+		 * behaviour.
+		 */
+		if (ptr && !KCOV_DF_IS_ERR(ptr)) {
+			switch (sz) {
+			case 8: {
+				u64 v = 0;
+
+				if (!get_kernel_nofault(v, (u64 *)ptr))
+					val = v;
+				break;
+			}
+			case 4: {
+				u32 v = 0;
+
+				if (!get_kernel_nofault(v, (u32 *)ptr))
+					val = v;
+				break;
+			}
+			case 2: {
+				u16 v = 0;
+
+				if (!get_kernel_nofault(v, (u16 *)ptr))
+					val = v;
+				break;
+			}
+			case 1: {
+				u8 v = 0;
+
+				if (!get_kernel_nofault(v, (u8 *)ptr))
+					val = v;
+				break;
+			}
+			default:
+				if (sz > sizeof(val))
+					sz = sizeof(val);
+				copy_from_kernel_nofault(&val, ptr, sz);
+			}
+		}
+		area[start_index + 3] = val;
+	} else {
+		if (!ptr || KCOV_DF_IS_ERR(ptr)) {
+			for (i = 0; i < num_fields; i++)
+				area[start_index + 3 + i] = KCOV_DF_MAGIC_BAD;
+			goto out;
+		}
+		for (i = 0; i < num_fields; i++) {
+			u64 off, sz, val = KCOV_DF_MAGIC_BAD;
+			void *fa;
+
+			if (copy_from_kernel_nofault(&off, &offsets[i * 2], sizeof(off)) ||
+			    copy_from_kernel_nofault(&sz, &offsets[i * 2 + 1], sizeof(sz))) {
+				area[start_index + 3 + i] = KCOV_DF_MAGIC_BAD;
+				continue;
+			}
+			fa = (void *)((unsigned long)ptr + off);
+			val = 0;
+
+			if (sz <= sizeof(val)) {
+				if (copy_from_kernel_nofault(&val, fa, sz))
+					val = KCOV_DF_MAGIC_BAD;
+			} else {
+				if (copy_from_kernel_nofault(&val, fa, sizeof(val)))
+					val = KCOV_DF_MAGIC_BAD;
+			}
+			area[start_index + 3 + i] = val;
+		}
+	}
+out:
+	/*
+	 * Paired with the barrier() after setting the guard at the top.
+	 * Ensures all record writes are complete before we clear the
+	 * recursion guard.
+	 */
+	barrier();
+	t->kcov_df_seq &= ~KCOV_DF_SEQ_GUARD;
+}
+
+/*
+ * The two compiler-emitted entry points are on objtool's uaccess_safe_builtin[]
+ * list, like the __sanitizer_cov_trace_cmp*() callbacks. The trace-args call is
+ * planted before the terminator of the function's entry block (so that every
+ * spilled value dominates it), not at its first instruction: a function that
+ * opens a user access region and then does an unsafe_get_user() -- an asm goto,
+ * hence a block terminator -- gets the callback AFTER the stac, and objtool
+ * reports "call to __sanitizer_cov_trace_args() with UACCESS enabled".
+ *
+ * objtool validates a listed function with AC set and rejects any out-of-line
+ * call from it, and kcov_df_write() calls copy_from_kernel_nofault(), so bracket
+ * the call with user_access_save()/restore(): that clears AC for the whole
+ * record write (the kasan_report() pattern) and keeps SMAP/PAN protection in
+ * force while the collector runs. It compiles to nothing on architectures
+ * without the feature.
+ */
+#ifdef CONFIG_KCOV_DATAFLOW_ARGS
+noinline void notrace __no_sanitize_coverage
+__sanitizer_cov_trace_args(u64 pc, u32 arg_idx, u32 arg_size, void *arg_ptr,
+			   u64 *offsets, u32 num_fields);
+
+noinline void notrace __no_sanitize_coverage
+__sanitizer_cov_trace_args(u64 pc, u32 arg_idx, u32 arg_size, void *arg_ptr,
+			   u64 *offsets, u32 num_fields)
+{
+	unsigned long ua_flags = user_access_save();
+
+	kcov_df_write(KCOV_DF_TYPE_ENTRY, pc, arg_idx, arg_size, arg_ptr,
+		      offsets, num_fields);
+	user_access_restore(ua_flags);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_args);
+#endif
+
+#ifdef CONFIG_KCOV_DATAFLOW_RET
+noinline void notrace __no_sanitize_coverage
+__sanitizer_cov_trace_ret(u64 pc, u32 ret_size, void *ret_val,
+			  u64 *offsets, u32 num_fields);
+
+noinline void notrace __no_sanitize_coverage
+__sanitizer_cov_trace_ret(u64 pc, u32 ret_size, void *ret_val,
+			  u64 *offsets, u32 num_fields)
+{
+	unsigned long ua_flags = user_access_save();
+
+	kcov_df_write(KCOV_DF_TYPE_RET, pc, 0, ret_size, ret_val,
+		      offsets, num_fields);
+	user_access_restore(ua_flags);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_ret);
+#endif
+
+#ifdef KCOV_DF_HAVE_CMP
+/*
+ * Comparison capture (input-to-state). Reached from the shared
+ * __sanitizer_cov_trace_cmp*() callbacks (kcov.c) via kcov_trace_cmp()
+ * (linux/kcov.h), which fans out to mainline kcov and, when this task has a
+ * dataflow session, here as well, so trace-cmp operand pairs land in the SAME
+ * unified TLV buffer as the arg/ret records. Both operands are recorded, so a
+ * userspace consumer can use them for input-to-state matching, complementing
+ * the arg/ret records.
+ *
+ * Record: [header(CMP|nvals=2|seq)][pc][cmp_type][arg1][arg2].
+ * cmp_type carries KCOV_CMP_SIZE()/KCOV_CMP_CONST bits (see linux/kcov.h) so the
+ * consumer knows operand width and whether one side was a compile-time constant.
+ *
+ * On objtool's uaccess_safe_builtin[] list, so this function makes no
+ * out-of-line call (kcov_df_reserve() and the helpers are __always_inline).
+ */
+noinline notrace __no_sanitize_coverage void
+kcov_df_trace_cmp(u64 cmp_type, u64 arg1, u64 arg2, u64 ip)
+{
+	struct task_struct *t = current;
+	u64 *area;
+	unsigned long start_index;
+	u32 seq;
+
+	if (kcov_df_inert_context())
+		return;
+	if (!t->kcov_df_enabled)
+		return;
+	/* Same recursion guard as kcov_df_write(): bit 31 of the seq counter. */
+	if (t->kcov_df_seq & KCOV_DF_SEQ_GUARD)
+		return;
+	t->kcov_df_seq |= KCOV_DF_SEQ_GUARD;
+	barrier();
+
+	area = (u64 *)t->kcov_df_area;
+	if (!area)
+		goto out;
+
+	/* Single-writer exact-count reservation: see kcov_df_reserve(). */
+	if (!kcov_df_reserve(t, area, KCOV_DF_RECORD_WORDS(2), &start_index))
+		goto out;
+
+	seq = kcov_df_next_seq(t);
+	area[start_index]     = kcov_df_hdr(KCOV_DF_TYPE_CMP, 2, 0, 0, seq);
+	area[start_index + 1] = kcov_df_canonicalize_ip(ip);
+	area[start_index + 2] = cmp_type;
+	area[start_index + 3] = arg1;
+	area[start_index + 4] = arg2;
+out:
+	barrier();
+	t->kcov_df_seq &= ~KCOV_DF_SEQ_GUARD;
+}
+EXPORT_SYMBOL(kcov_df_trace_cmp);
+#endif /* KCOV_DF_HAVE_CMP */
+
+/* Called from kernel/fork.c to clear inherited state. */
+void kcov_dataflow_task_init(struct task_struct *t)
+{
+	t->kcov_df_area = NULL;
+	t->kcov_df_size = 0;
+	t->kcov_df_seq = 0;
+	t->kcov_df_enabled = false;
+	t->kcov_df = NULL;
+	t->kcov_df_remote_depth = 0;
+}
+
+/* Called from kernel/exit.c to tear down the exiting task's session, if any. */
+void kcov_dataflow_task_exit(struct task_struct *t)
+{
+	struct kcov_dataflow *df = t->kcov_df;
+
+	if (!df)
+		return;
+
+	if (t->kcov_df_remote_depth > 0) {
+		/*
+		 * A remote kworker exited between kcov_df_remote_start() and
+		 * _stop() (should not happen -- they bracket a single work item).
+		 * Defensive: drop its partial scratch and release the ref so
+		 * neither the buffer nor the object leaks.
+		 */
+		void *scratch = t->kcov_df_area;
+
+		t->kcov_df_enabled = false;
+		t->kcov_df_area = NULL;
+		t->kcov_df_size = 0;
+		t->kcov_df = NULL;
+		t->kcov_df_remote_depth = 0;
+		vfree(scratch);
+		kcov_df_put(df);
+		return;
+	}
+
+	/*
+	 * Local (KCOV_DF_ENABLE) session on the exiting task. Mirror
+	 * kcov_task_exit(): unwire the task, clear df->t so the object never
+	 * keeps a pointer to a freed task_struct (which a later ioctl or
+	 * close() would compare against current), release the cmp key this
+	 * session held and drop the session's reference.
+	 */
+	t->kcov_df_enabled = false;
+	t->kcov_df_area = NULL;
+	t->kcov_df_size = 0;
+	t->kcov_df = NULL;
+
+	mutex_lock(&df->lock);
+	WARN_ON_ONCE(df->t != t);
+	df->t = NULL;
+	kcov_df_cmp_key_release(df, KCOV_DF_CMP_LOCAL);
+	mutex_unlock(&df->lock);
+	kcov_df_put(df);
+}
+
+/* File operations for /sys/kernel/debug/kcov_dataflow */
+
+static int kcov_df_open(struct inode *inode, struct file *filep)
+{
+	struct kcov_dataflow *df;
+
+	df = kzalloc_obj(struct kcov_dataflow, GFP_KERNEL);
+	if (!df)
+		return -ENOMEM;
+	mutex_init(&df->lock);
+	refcount_set(&df->refcount, 1);	/* the open fd's reference */
+	filep->private_data = df;
+	return nonseekable_open(inode, filep);
+}
+
+/*
+ * Unwire the local session that @current holds on @df. Caller holds df->lock
+ * and must drop the session's reference with kcov_df_put() after unlocking.
+ */
+static void kcov_df_disable_local(struct kcov_dataflow *df)
+{
+	lockdep_assert_held(&df->lock);
+	WARN_ON_ONCE(df->t != current || current->kcov_df != df);
+
+	current->kcov_df_enabled = false;
+	current->kcov_df_area = NULL;
+	current->kcov_df_size = 0;
+	current->kcov_df = NULL;
+	df->t = NULL;
+	kcov_df_cmp_key_release(df, KCOV_DF_CMP_LOCAL);
+}
+
+static int kcov_df_close(struct inode *inode, struct file *filep)
+{
+	struct kcov_dataflow *df = filep->private_data;
+	bool put_session = false;
+
+	/* Unpublish from remote hash: no new users can start */
+	kcov_df_remote_unpublish(df);
+
+	mutex_lock(&df->lock);
+	kcov_df_cmp_key_release(df, KCOV_DF_CMP_REMOTE);
+	/*
+	 * Only the enabled task can unwire its own session. If another task
+	 * (a sibling thread, a fork()ed child, an SCM_RIGHTS recipient) does
+	 * the final close(), the enabled task keeps its reference and keeps
+	 * collecting until it exits, exactly like mainline kcov.
+	 */
+	if (df->t == current) {
+		kcov_df_disable_local(df);
+		put_session = true;
+	}
+	mutex_unlock(&df->lock);
+
+	if (put_session)
+		kcov_df_put(df);
+	/*
+	 * Drop the fd's reference. If remote workers or the enabled task still
+	 * hold refs, the LAST of them frees ->area via kcov_df_put() -- no drain
+	 * loop, no lost-decrement wedge. The hash entry was already unpublished
+	 * above, so no new remote user can start on this object.
+	 */
+	kcov_df_put(df);
+	return 0;
+}
+
+static int kcov_df_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct kcov_dataflow *df = filep->private_data;
+	unsigned long size, off;
+	struct page *page;
+	void *area;
+	int res = 0;
+
+	mutex_lock(&df->lock);
+	size = df->size * sizeof(u64);
+	if (!df->area || vma->vm_pgoff != 0 ||
+	    vma->vm_end - vma->vm_start != size) {
+		res = -EINVAL;
+		goto out;
+	}
+	area = df->area;
+	mutex_unlock(&df->lock);
+
+	vm_flags_set(vma, VM_DONTEXPAND);
+	for (off = 0; off < size; off += PAGE_SIZE) {
+		page = vmalloc_to_page(area + off);
+		res = vm_insert_page(vma, vma->vm_start + off, page);
+		if (res)
+			return res;
+	}
+	return 0;
+out:
+	mutex_unlock(&df->lock);
+	return res;
+}
+
+static long kcov_df_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	struct kcov_dataflow *df = filep->private_data;
+	bool put_session = false;
+	unsigned long size;
+	u64 handle = 0;
+	int res = 0;
+
+	/*
+	 * Fetch the remote handle from user space before taking df->lock.
+	 * get_user() may fault and take mmap_lock, but kcov_df_mmap() takes
+	 * df->lock while holding mmap_lock -- doing the copy under df->lock
+	 * would invert that order and deadlock (reported by lockdep).
+	 */
+	if (cmd == KCOV_DF_REMOTE_ENABLE && get_user(handle, (u64 __user *)arg))
+		return -EFAULT;
+
+	mutex_lock(&df->lock);
+	switch (cmd) {
+	case KCOV_DF_INIT_TRACK:
+		if (df->area) {
+			res = -EBUSY;
+			break;
+		}
+		size = arg;
+		if (size < 2 || size > (128 << 20) / sizeof(u64)) {
+			res = -EINVAL;
+			break;
+		}
+		mutex_unlock(&df->lock);
+		{
+			void *area = vmalloc_user(size * sizeof(u64));
+
+			if (!area)
+				return -ENOMEM;
+			mutex_lock(&df->lock);
+			if (df->area) {
+				mutex_unlock(&df->lock);
+				vfree(area);
+				return -EBUSY;
+			}
+			df->area = area;
+			df->size = size;
+		}
+		break;
+
+	case KCOV_DF_ENABLE:
+		/*
+		 * One writer per buffer: refuse if this object already has a
+		 * local session, if this task already has one (on any fd), or
+		 * if the buffer is (or may still be) a remote merge target -- a
+		 * published handle, or workers still in flight after
+		 * KCOV_DF_REMOTE_DISABLE (any ref beyond the fd's own). The
+		 * local reservation is a plain read-modify-write of area[0]
+		 * that must never race kcov_df_merge()'s atomic one.
+		 */
+		if (!df->area || df->t || df->remote_handle ||
+		    refcount_read(&df->refcount) != 1 || current->kcov_df) {
+			res = -EBUSY;
+			break;
+		}
+		kcov_df_fault_in_area(df->area, df->size);
+		kcov_df_get(df);	/* put in KCOV_DF_DISABLE, close() or task exit */
+		df->t = current;
+		current->kcov_df = df;
+		current->kcov_df_area = df->area;
+		current->kcov_df_size = df->size;
+		current->kcov_df_seq = 0;
+		current->kcov_df_remote_depth = 0;
+		/* Publish the session state before the enable flag. */
+		barrier();
+		current->kcov_df_enabled = true;
+		kcov_df_cmp_key_hold(df, KCOV_DF_CMP_LOCAL);
+		break;
+
+	case KCOV_DF_DISABLE:
+		if (df->t != current) {
+			res = -EINVAL;
+			break;
+		}
+		kcov_df_disable_local(df);
+		put_session = true;
+		break;
+
+	case KCOV_DF_REMOTE_ENABLE: {
+		struct kcov_df_remote *remote;
+
+		if (!df->area ||
+		    !kcov_check_handle(handle, true, true, false)) {
+			res = -EINVAL;
+			break;
+		}
+		/*
+		 * One handle per fd (a second one would leak the first entry
+		 * and leave it pointing at a freed object after close()), and
+		 * never while a local session writes the buffer directly.
+		 */
+		if (df->t || df->remote_handle) {
+			res = -EBUSY;
+			break;
+		}
+		remote = kzalloc_obj(struct kcov_df_remote, GFP_KERNEL);
+		if (!remote) {
+			res = -ENOMEM;
+			break;
+		}
+		remote->handle = handle;
+		remote->df = df;
+		mutex_lock(&kcov_df_remote_lock);
+		if (kcov_df_remote_find(handle)) {
+			mutex_unlock(&kcov_df_remote_lock);
+			kfree(remote);
+			res = -EEXIST;
+			break;
+		}
+		hash_add(kcov_df_remote_map, &remote->hnode, handle);
+		df->remote_handle = handle;
+		mutex_unlock(&kcov_df_remote_lock);
+		kcov_df_cmp_key_hold(df, KCOV_DF_CMP_REMOTE);
+		break;
+	}
+
+	case KCOV_DF_REMOTE_DISABLE:
+		kcov_df_remote_unpublish(df);
+		kcov_df_cmp_key_release(df, KCOV_DF_CMP_REMOTE);
+		break;
+
+	default:
+		res = -ENOTTY;
+	}
+	mutex_unlock(&df->lock);
+
+	if (put_session)
+		kcov_df_put(df);
+	return res;
+}
+
+/* Remote dataflow implementation */
+
+/*
+ * Open a remote dataflow section on this task for @handle. Must be called from
+ * sleepable task context (it takes a mutex and may vmalloc() the scratch); in
+ * softirq/hardirq context it is a no-op, as is the matching stop, so the pair
+ * stays balanced for a call site that brackets a softirq-reachable region.
+ */
+void kcov_df_remote_start(u64 handle)
+{
+	struct kcov_df_remote *remote;
+	struct kcov_dataflow *df;
+	void *scratch;
+
+	/* Dataflow remote coverage is collected in task (kworker) context only. */
+	if (!in_task())
+		return;
+	/*
+	 * A task should only run one session at a time (KCOV's rule). If a
+	 * buggy caller nests inside a remote section, don't re-init and don't
+	 * take a second ref -- just count the depth so the matching inner
+	 * stop() leaves the outer session intact (see kcov_df_remote_stop()).
+	 * Coverage from the nested region is attributed to the outer handle,
+	 * which is safe (no corruption, no early free) even though it is
+	 * imprecise. Inside a local (KCOV_DF_ENABLE) session the depth stays
+	 * 0, so the inner stop() is a no-op and the local session's wiring is
+	 * left untouched; its records simply go to its own buffer.
+	 *
+	 * This check comes first so that every early return below only ever
+	 * happens with no session live -- then the matching stop() has nothing
+	 * to tear down and can never truncate an outer section.
+	 */
+	if (current->kcov_df) {
+		WARN_ON_ONCE(1);
+		if (current->kcov_df_remote_depth > 0 &&
+		    current->kcov_df_remote_depth < INT_MAX)
+			current->kcov_df_remote_depth++;
+		return;
+	}
+	if (!handle)
+		return;
+
+	/* mutex_lock()'s might_sleep() reports an atomic (non-sleepable) caller. */
+	mutex_lock(&kcov_df_remote_lock);
+	remote = kcov_df_remote_find(handle);
+	if (!remote || !remote->df || !remote->df->area) {
+		mutex_unlock(&kcov_df_remote_lock);
+		return;
+	}
+	df = remote->df;
+	kcov_df_get(df);		/* keep @df (and ->area) alive until _stop() */
+	scratch = kcov_df_scratch_get();	/* reuse a pooled scratch if any */
+	mutex_unlock(&kcov_df_remote_lock);
+
+	if (!scratch) {
+		scratch = vmalloc(KCOV_DF_REMOTE_WORDS * sizeof(u64));
+		if (!scratch) {
+			kcov_df_put(df);
+			return;
+		}
+	}
+	((u64 *)scratch)[0] = 0;	/* reset the scratch write cursor */
+	kcov_df_fault_in_area(scratch, KCOV_DF_REMOTE_WORDS);
+
+	/*
+	 * Point this task at its OWN private scratch, NOT df->area. It collects
+	 * here while it runs; kcov_df_remote_stop() merges it into the shared
+	 * buffer. So multiple kworkers on one handle never write the same buffer.
+	 */
+	current->kcov_df_area = scratch;
+	current->kcov_df_size = KCOV_DF_REMOTE_WORDS;
+	current->kcov_df_seq = 0;
+	current->kcov_df = df;		/* pocket it for _stop(); no hash relookup */
+	current->kcov_df_remote_depth = 1;
+	/*
+	 * Publish all session state BEFORE the enable flag (mirrors kcov_start()).
+	 * kcov_df_write() gates on kcov_df_enabled and then reads kcov_df_area, so
+	 * the buffer/handle must be visible first; the barrier keeps the compiler
+	 * from hoisting the enable above them.
+	 */
+	barrier();
+	current->kcov_df_enabled = true;
+}
+EXPORT_SYMBOL_GPL(kcov_df_remote_start);
+
+void kcov_df_remote_stop(void)
+{
+	struct kcov_dataflow *df = current->kcov_df;
+	void *scratch;
+
+	/*
+	 * Same context rule as kcov_df_remote_start(): a stop() in softirq
+	 * context pairs with a start() that was a no-op, and must not touch
+	 * the interrupted task's live session.
+	 */
+	if (!in_task())
+		return;
+	/* No remote session (a local session ignores a stray stop). */
+	if (!df || current->kcov_df_remote_depth == 0)
+		return;
+
+	/*
+	 * Unwind a nested start() (buggy caller): only the OUTERMOST stop tears
+	 * the session down. Inner stops just decrement the depth and return, so
+	 * the buffer/ref survive until the worker is really done with them.
+	 */
+	if (--current->kcov_df_remote_depth > 0)
+		return;
+
+	scratch = current->kcov_df_area;
+
+	/*
+	 * Stop writing FIRST: clear the per-task pointers so this task can no
+	 * longer enter kcov_df_write() / touch the scratch. Then it is safe to
+	 * merge and recycle the scratch and drop the ref.
+	 */
+	current->kcov_df_enabled = false;
+	current->kcov_df_area = NULL;
+	current->kcov_df_size = 0;
+	current->kcov_df = NULL;
+
+	if (scratch) {
+		/*
+		 * Publish this worker's records into the shared buffer,
+		 * then return the scratch to the pool for the next worker.
+		 */
+		kcov_df_merge(df, scratch);
+		mutex_lock(&kcov_df_remote_lock);
+		kcov_df_scratch_put(scratch);
+		mutex_unlock(&kcov_df_remote_lock);
+	}
+
+	/*
+	 * Drop the ref taken in kcov_df_remote_start(). If this is the last one,
+	 * kcov_df_put() frees ->area right here -- safe, because no task writes
+	 * ->area directly anymore (workers write scratch; the merge above is
+	 * done). Dropping via the pocketed @df (not a hash lookup) means an
+	 * already-unpublished entry can never strand the count.
+	 */
+	kcov_df_put(df);
+}
+EXPORT_SYMBOL_GPL(kcov_df_remote_stop);
+
+static const struct file_operations kcov_df_fops = {
+	.open		= kcov_df_open,
+	.unlocked_ioctl	= kcov_df_ioctl,
+	.compat_ioctl	= kcov_df_ioctl,
+	.mmap		= kcov_df_mmap,
+	.release	= kcov_df_close,
+};
+
+/*
+ * Reclaim idle per-worker scratch under memory pressure. The pool otherwise only
+ * ever grows to the peak number of concurrent remote kworkers (each area is 8 MiB)
+ * and is never returned to the allocator; a shrinker lets the VM take the idle
+ * (parked) areas back when it needs the memory. Only pooled areas are freeable;
+ * in-use scratch is not on the list. mutex_trylock keeps the shrinker best-effort
+ * and free of any lock-ordering risk.
+ */
+static unsigned long
+kcov_df_scratch_shrink_count(struct shrinker *sh, struct shrink_control *sc)
+{
+	unsigned long nr;
+
+	if (!mutex_trylock(&kcov_df_remote_lock))
+		return 0;
+	nr = kcov_df_scratch_pool_nr;
+	mutex_unlock(&kcov_df_remote_lock);
+	return nr ? nr : SHRINK_EMPTY;
+}
+
+static unsigned long
+kcov_df_scratch_shrink_scan(struct shrinker *sh, struct shrink_control *sc)
+{
+	struct kcov_df_scratch *s, *tmp;
+	LIST_HEAD(victims);
+	unsigned long freed = 0;
+
+	if (!mutex_trylock(&kcov_df_remote_lock))
+		return SHRINK_STOP;
+	/*
+	 * Detach victims under the lock; free them (each 8 MiB) after unlocking
+	 * so the vfree() latency stays off concurrent remote_start()/stop().
+	 */
+	while (freed < sc->nr_to_scan && !list_empty(&kcov_df_scratch_pool)) {
+		s = list_first_entry(&kcov_df_scratch_pool,
+				     struct kcov_df_scratch, list);
+		list_move(&s->list, &victims);
+		kcov_df_scratch_pool_nr--;
+		freed++;
+	}
+	mutex_unlock(&kcov_df_remote_lock);
+
+	list_for_each_entry_safe(s, tmp, &victims, list)
+		vfree(s);
+	return freed;
+}
+
+static int __init kcov_dataflow_init(void)
+{
+	struct shrinker *shrinker;
+
+	debugfs_create_file_unsafe("kcov_dataflow", 0600, NULL, NULL,
+				   &kcov_df_fops);
+
+	shrinker = shrinker_alloc(0, "kcov-df-scratch");
+	if (shrinker) {
+		shrinker->count_objects = kcov_df_scratch_shrink_count;
+		shrinker->scan_objects = kcov_df_scratch_shrink_scan;
+		shrinker->seeks = DEFAULT_SEEKS;
+		shrinker_register(shrinker);
+	} else {
+		pr_warn("scratch shrinker unavailable, idle remote scratch areas will not be reclaimed\n");
+	}
+	return 0;
+}
+device_initcall(kcov_dataflow_init);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6871352681480..1818d3d0147c7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2231,6 +2231,58 @@ config KCOV_SELFTEST
 	  On test failure, causes the kernel to panic. Recommended to be
 	  enabled, ensuring critical functionality works as intended.
 
+config KCOV_DATAFLOW_ARGS
+	bool "Enable KCOV dataflow: function argument capture"
+	depends on KCOV
+	depends on CC_IS_CLANG
+	depends on DEBUG_INFO
+	depends on $(cc-option,-fsanitize-coverage=trace-args)
+	depends on !RUST || $(rustc-option,-Cllvm-args=-sanitizer-coverage-trace-args)
+	help
+	  Captures function arguments at entry via /sys/kernel/debug/kcov_dataflow.
+	  Struct pointer arguments are auto-expanded using compiler DebugInfo
+	  metadata, recording individual field values at runtime.
+	  Enable per-module with: KCOV_DATAFLOW_file.o := y in the Makefile.
+	  Requires clang with -fsanitize-coverage=trace-args support (and,
+	  with CONFIG_RUST, a rustc whose LLVM has the matching pass), plus
+	  debug info: select any CONFIG_DEBUG_INFO_DWARF* option under
+	  "Compile-time checks and compiler options" to satisfy DEBUG_INFO.
+
+config KCOV_DATAFLOW_RET
+	bool "Enable KCOV dataflow: return value capture"
+	depends on KCOV
+	depends on CC_IS_CLANG
+	depends on DEBUG_INFO
+	depends on $(cc-option,-fsanitize-coverage=trace-ret)
+	depends on !RUST || $(rustc-option,-Cllvm-args=-sanitizer-coverage-trace-ret)
+	help
+	  Captures function return values via /sys/kernel/debug/kcov_dataflow.
+	  Struct pointer returns are auto-expanded using compiler DebugInfo
+	  metadata, recording individual field values at runtime.
+	  Enable per-module with: KCOV_DATAFLOW_file.o := y in the Makefile.
+	  Requires clang with -fsanitize-coverage=trace-ret support (and,
+	  with CONFIG_RUST, a rustc whose LLVM has the matching pass), plus
+	  debug info: select any CONFIG_DEBUG_INFO_DWARF* option under
+	  "Compile-time checks and compiler options" to satisfy DEBUG_INFO.
+
+config KCOV_DATAFLOW_NO_INLINE
+	bool "Disable inlining for dataflow-instrumented files"
+	depends on KCOV_DATAFLOW_ARGS || KCOV_DATAFLOW_RET
+	help
+	  Adds -fno-inline to files instrumented with KCOV_DATAFLOW.
+	  This ensures every function boundary is preserved, giving
+	  complete argument visibility. Disable for lower overhead at the
+	  cost of losing argument records for inlined functions.
+
+config KCOV_DATAFLOW_INSTRUMENT_ALL
+	bool "Instrument all kernel code with dataflow coverage"
+	depends on KCOV_DATAFLOW_ARGS || KCOV_DATAFLOW_RET
+	help
+	  Instrument all kernel objects with trace-args/trace-ret
+	  automatically. Individual files or directories can opt out
+	  with KCOV_DATAFLOW_file.o := n or KCOV_DATAFLOW := n.
+	  Warning: significantly increases code size and boot time.
+
 menuconfig RUNTIME_TESTING_MENU
 	bool "Runtime Testing"
 	default y
diff --git a/scripts/Makefile.kcov b/scripts/Makefile.kcov
index 78305a84ba9d2..5fd2aa69d8fd5 100644
--- a/scripts/Makefile.kcov
+++ b/scripts/Makefile.kcov
@@ -9,3 +9,20 @@ kcov-rflags-$(CONFIG_KCOV_ENABLE_COMPARISONS)	+= -Cllvm-args=-sanitizer-coverage
 
 export CFLAGS_KCOV := $(kcov-flags-y)
 export RUSTFLAGS_KCOV := $(kcov-rflags-y)
+
+# KCOV dataflow: trace function args and return values. Each kind is gated by
+# its own Kconfig symbol, matching the #ifdef around the callback it emits calls
+# to in kernel/kcov_dataflow.c (an instrumented object must never reference a
+# callback that is not compiled in). Both variables are empty on a KCOV-only
+# kernel, so a stray per-file KCOV_DATAFLOW_file.o := y is harmless there.
+kcov-dataflow-flags-$(CONFIG_KCOV_DATAFLOW_ARGS) += -fsanitize-coverage=trace-args
+kcov-dataflow-flags-$(CONFIG_KCOV_DATAFLOW_RET) += -fsanitize-coverage=trace-ret
+kcov-dataflow-flags-$(CONFIG_KCOV_DATAFLOW_NO_INLINE) += -fno-inline
+
+# Rust: only add the trace-args/ret llvm-args (sancov-module pass and level=3
+# are already provided by RUSTFLAGS_KCOV since KCOV_DATAFLOW depends on KCOV).
+kcov-dataflow-rflags-$(CONFIG_KCOV_DATAFLOW_ARGS) += -Cllvm-args=-sanitizer-coverage-trace-args
+kcov-dataflow-rflags-$(CONFIG_KCOV_DATAFLOW_RET) += -Cllvm-args=-sanitizer-coverage-trace-ret
+
+export CFLAGS_KCOV_DATAFLOW := $(kcov-dataflow-flags-y)
+export RUSTFLAGS_KCOV_DATAFLOW := $(kcov-dataflow-rflags-y)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0a4fdd8bd975d..b32fa67ce99af 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -88,6 +88,20 @@ _c_flags += $(if $(patsubst n%,, \
 _rust_flags += $(if $(patsubst n%,, \
 	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(if $(is-kernel-object),$(CONFIG_KCOV_INSTRUMENT_ALL))), \
 	$(RUSTFLAGS_KCOV))
+# KCOV dataflow. The outer test only honours an explicit KCOV opt-out
+# (KCOV_INSTRUMENT_file.o := n / KCOV_INSTRUMENT := n, the noinstr exclusions):
+# it does not require a KCOV opt-in, so per-file KCOV_DATAFLOW_file.o := y works
+# for modules and out-of-tree objects too. The inner test is the dataflow opt-in:
+# per-file/per-directory, or every kernel object under
+# CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL.
+_c_flags += $(if $(patsubst n%,, \
+	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)y),$(if $(patsubst n%,, \
+	$(KCOV_DATAFLOW_$(target-stem).o)$(KCOV_DATAFLOW)$(if $(is-kernel-object),$(CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL))), \
+	$(CFLAGS_KCOV_DATAFLOW)))
+_rust_flags += $(if $(patsubst n%,, \
+	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)y),$(if $(patsubst n%,, \
+	$(KCOV_DATAFLOW_$(target-stem).o)$(KCOV_DATAFLOW)$(if $(is-kernel-object),$(CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL))), \
+	$(RUSTFLAGS_KCOV_DATAFLOW)))
 endif
 
 #
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 464f6c9d9ff0b..ae6fe47886395 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1219,6 +1219,10 @@ static const char *uaccess_safe_builtin[] = {
 	"__tsan_unaligned_write16",
 	/* KCOV */
 	"write_comp_data",
+	/* KCOV dataflow */
+	"kcov_df_trace_cmp",
+	"__sanitizer_cov_trace_args",
+	"__sanitizer_cov_trace_ret",
 	"check_kcov_mode",
 	"__sanitizer_cov_trace_pc",
 	"__sanitizer_cov_trace_const_cmp1",

-- 
2.47.3


