Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86929C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B1C6B00AF; Wed,  2 Sep 2026 12:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BBDE6B00BD; Wed,  2 Sep 2026 12:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235DC6B00BE; Wed,  2 Sep 2026 12:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E10EF6B00AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F281A02BE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:27 +0000 (UTC)
X-FDA: 85169360094.17.780414B
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011010.outbound.protection.outlook.com [52.101.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6FCD4180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=bjO5sGwP;
	spf=pass (imf16.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcym3x+z6YtN62vQkR8HQUx+CV0uFnFUK0sNY3skKSk=;
	b=6n3+KRxrigqCKjP2dnvfyJoahUmS7u1NJV4QplOsnMsW6zavE7rrv+XhhiIo6DPJ3mi/HH
	LfFiWoL/D9vyJstH3vTZ356Li/zRCVJ7SN312Iab4PLLHsdkVuwJBNhUlG65prs12dFFLP
	QmB8VePWuspoe543NhePalnxWRGhIsk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366624;
	b=hh+VZTPhdfyTBYuA5c3Tlm50VVA6Ei59AXw/T840/EkoBwMtpwzKV/l+IIEWnGPSCLcdzj
	z9eTgPF6Ykt8WsldBcrWH414uLuFwRgUFYP0UOlNEMI6FgXvFCSBiYwtFVcfRDvnTdzJJu
	sR4mB/H6geegZ5TWVnsdBDXjQSYbRXE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=bjO5sGwP;
	spf=pass (imf16.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwkzruXWpVVGpONse0Fa5KA0TVtLu7FCpaI6+wBLrl8YgJ8+V/v275DbkzAiWRBKv9d+a6I1r78K+avQI3T12PgJLd4v5Hm9F3KXrbQ4wnWMOzwjodFcmv8u+d9DoweiCTy3lyUoNQnvRCGFvg4bdJ8pqLyJtVw/wkVAt5/cpqHHXIwBqCZ5P+W2cxc2jEmyfCCbUuQIdWNwU8klRgH9+dlmNJn4PZIRYtiMU8cqwT0VsivA5dFhHV4Hc1EYaqxUxuYJeLXRGK0ISL+678rRET07ZJ4e3CqaorcYC0IpAGfHPFXL1qdzSHpNRXnSUT9sg54ZBAjSl1ExVe2v2U9blQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcym3x+z6YtN62vQkR8HQUx+CV0uFnFUK0sNY3skKSk=;
 b=y7m4c5wboXAjWKK0X+Wh2XZ3PrBG23Wj4SpytBSivz0xmzTBb1LLun+rhXlALMOjPwagKC9VgcyEP0tweMccABy+qhTF/4V+o7ss4v8y9ncmXnEKSLYmghpS8H9ZwUSOBLup5qRJ7yCxcgu3mzZNJBLe6wOFxiFS1b7fF8I+ab2nb9uqPl5sbrS4BJvwgq+15mesI5XDQVLBoulVj0kCNdDoPdx11LSGl6Xi6a8cYUVizHZ1wucfYwzXDBdr//BM1RENIgwZNsLYlTPRu3IhPqFcJkFnn3OxpNHFx2FSiYeyb/CcT19AqZmHY5qbep768yBUtsxowAvsZ2o0S7ptrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcym3x+z6YtN62vQkR8HQUx+CV0uFnFUK0sNY3skKSk=;
 b=bjO5sGwPhOgZqmV0S69qj9wNxBQ4cel+tNedCJjDiO0tP4DfgFO0AM0DsmnqAwbL2QyFNZqZSjyO4mIDTswsdslMYbWaa/TjGqmcSm6dLANNMkEBtUrPh/5PhdAIEIAbKutRTWtbBkuO0Eoe55J9n458MDk1PfEs1ifjB68+r2+3vcPCWKGPc4pzZ1Ogqp/EEkltUYECIjic8v3P/rgbiy3hZk0ru/MF02aJVBlI+vOJcLhWbEQrJJ7L8oVSPcp1vqareAKpz/8rvxhqP2GPXuTUqWbh9LcFJQ+sQlJyaSTshDjAbNO53FsKrJjo6upgghuwJJc9m6QiH69vz8lWig==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by VI1P18901MB0638.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:30:15 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:30:15 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:40 +0200
Subject: [PATCH RFC v3 7/8] selftests/kcov_dataflow: add
 rust_kworker_remote selftest module
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-7-824609f279f5@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=9553;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=2dpfwy+fKa2DY4zvSGoFOd1Icpn+2mxvAA4Dbyk1Isc=;
 b=v5wNLJ8T9ey4yczQKwNrxD7VpPGqqn4ogZ4tslZm1/tNS1R+XbjC1ATmXcfQ8OjWZiCg7TlzC
 aXWXZgO1tXqBIj5D9ujUUWq/BA3RjyCfohFSkLx4cixbHTwArOuODwt
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::12) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|VI1P18901MB0638:EE_
X-MS-Office365-Filtering-Correlation-Id: 8709a1d9-066f-437e-95ee-08df090f77e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hHQyl7Qh9IofgqJK97oSgrWv1LRPdFPefVv/bzSlF7z21cUIo+frEIks7sYVU9OIw5wrFgSUithpOKnvzn0X/RxQbBoKDfHmuFRbOMY7e1axnGsPZ3kNqO4gLBFHYiKBXzGRE6ZZ+6FORgTfktvbqOitChxtjv44ZVwJG2vd4Ne6Qt5J2jNHdidttfcc6ufu8E6jI/c1AhVf0YggQ684C5qq8TjVV32y/5pCWnFsZIN4o7g2jw6OPbjDQcOlXsrrgdK+Cg8gOKnUEg1fEbs5ApF/J+Cl8tx+HnX/F2ZxyrXD14JULwG4DShUMhHXmgb+fT7ksoSLRdBgheuqe8JSBRhaWPYrOulKbhGcwSN3s1BreF07N06EkWia3lppcDU7tltogh9SAApcs1DJuXCkSlnOsfZQFfJdeaBgIG4RvhzkeYJ/VSKCbO5YEH+HKCB8k5NEAsV9IG6jaSvXlMcQwzLV+uJnIRQAPnvmL8Gszvmqct6UJxjNscHHVXyfnumZcZ0hK6Zuk13wr4A6b79/sTHGtJe4cxyVqmjHrIoScgcC4rd9rrg6h2gVmC7Lp46EdQ9ZK0Npq0uVJb7KMfwdC8RK/49dB4fL/tXt3k7lvKDrMi7y96Ud3CSJ8CZ5AXpL7MQ6N0LJCOp6i3NhPrKBvubaIkj3vKEusaClTuBjt9g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUlMeGliVVRaVnRqMFZhQVNZd0YwZDRVSzNCQmpIZlREY3dObStUUHIxdXFU?=
 =?utf-8?B?SjNkQnJkOFdxcDl0Y090dG5FVksyOHlQT1dHSXQ2cmIvWW5ndzl2eTFqVENu?=
 =?utf-8?B?ZjZhNzhUWjV1N2M0ZllhUzFQVklpYUtscWVRV1NEd25NZ1Z4NEN1SGxGYzZK?=
 =?utf-8?B?b2ZyZnI3bHQ3NG5FTk8vV1d6S3l4SXk0WmtzRW9IeDdNT3U3UmRIK3k4Wjli?=
 =?utf-8?B?UkhaUFRaRFVWZTNxNHkzVkMzVTJpY0RSY0htVHppWXd5alZQOGF5UmZyY2tL?=
 =?utf-8?B?TCtUSERSN01zZGQ3YnVmU2JMM2RuWjJsM010TXZWK2E2Yk5Ycnk0YTBBQ1Fq?=
 =?utf-8?B?c1FPekNVV01OdXNRbGQ2ck5zL0xKSUJEempma3Zaa1BxNHZrL3pqMW1PNVM1?=
 =?utf-8?B?Y01sUW5mTFN2amp1TTk0NWx3cVE1TFBqOFpLaCs3WHpRaUkxZmpJSUpmZmRh?=
 =?utf-8?B?VlpCa2tsZ3Y2d0VaM1lldTBtQlp5dC9zUzNxZFZmTzJ4OFFGSnZpYmJ2OFFR?=
 =?utf-8?B?UHlTZHdaaGFFT1RNcEpFanJsOUFkcEVnNWFpOE54dlc1VGd3RHlHYmo5MFdm?=
 =?utf-8?B?MlpXVFg3WVgzNUwvbVdyNzFJbGNJRlVBK3NTV0RIb3dlOUp4emIwWGRVWkdh?=
 =?utf-8?B?VG5jenpLNkdqOG8vb1d4NEozQXZTS2Erai9LSEcyM1RYQmFQc1A0KzZBQ3RC?=
 =?utf-8?B?Ujg4YXVDZ1AvRmhuVmFLRE1yM3VFTGZQTEN4RmMrNitxMEdpZjBnVkYzclZF?=
 =?utf-8?B?c0pEWUU4TjJlODFWS1JxcTNrb0FFdnRjUThNcGZsY3J5ZVIyU3NCaWtqT1Nm?=
 =?utf-8?B?SFkzbExoOXRKeVZWS3UyaFEwVURZdGRjVWc2eHJPZVdETDBmaDJtQi9taW55?=
 =?utf-8?B?YmRGY3BwZ2V2SFkvQUpqejlXYTJTYjlUUGtRM044SmxDUkRkMWVscWkzaHc2?=
 =?utf-8?B?b200UmJQQXF3d0tJVXU2OSszd0JMbUtRY05JYmpTOTlRQm9oZDJZZXRHdGVX?=
 =?utf-8?B?VGorWHVIbDBHa1QrQWdyQUJmVnNMN1FZRFpmMzhjMVBaR3Z3SG96WFV1MFBn?=
 =?utf-8?B?bjhjSSs4SmlYS2ZqbXd0L0xhWmJTekh2UVozVEN0RlZxblBHQUdoMjE4S3J0?=
 =?utf-8?B?S1NuaXpSS0I2NC9kbVRvdTU3QnNQeEJDQ3ZsWGs5aTJxeldnTy9kcmxUVlhx?=
 =?utf-8?B?ZktYYnViM1FqYlRML2VTU1lvUzlFVE5ZRFFnZUpTQ3lWaGdLZmRaZzBoVVBk?=
 =?utf-8?B?a3g2WG1wV2tXeE5CNmkwT2VDQVB2MnBLYzIrcWljVnl2blNSZVJtaFZTclJ5?=
 =?utf-8?B?c3pvdDNaWlQzMmxZR0F3Si9oRjlscTlZSDNOZU5pTWVVUTdkTXlUYWU4OTZW?=
 =?utf-8?B?eVRMQWhDbzBzRjhKSStkSGlVM1hLN3pPYkU1U1pUanFrY3JyMnFYYldndXg5?=
 =?utf-8?B?YWRrN0p3elNrY1E3dWJ2TDc5VmJ6Qnc3ZXhzMjNFdC9sQ3hBZlZFWFBZaDFu?=
 =?utf-8?B?REJqa0VoNjAwK2ZmdlQ2eHBTWjR1QjZTYTE3TjQySWJaTlZJTk5IRzJSdWVu?=
 =?utf-8?B?WWtMLzFmL0hPN05SamRmTnlWYnc4Ukt3a3ZxaVpqMUFRTXFkYldDaDMwVy84?=
 =?utf-8?B?aFloOFZlRS8yTktOKzNMU29wMjVVZE51OHZsQ3h3amdqYUk2TWJWM2dpcWhi?=
 =?utf-8?B?UzRaWUczUTJ6cHZ6UEloZ21xbEN0QkZtRERnUXRsekxMZXpUSDdpRGMwR0tK?=
 =?utf-8?B?Z2Y0a25Wemc4VElldTRLejZmaEt6M1lETzQ3Y003SFhoNlBrWWhrakZuUnNG?=
 =?utf-8?B?V1JOTjRIYk5sZXpsU3hISHBkZ3phSTZYT0VjeVoxSEIzZElkNVMyaFFndHVV?=
 =?utf-8?B?RFJ2bDhiOHFWMGRTM2pGOWtyaTF0c1ZuN28vNk1NK0V6Nko1OHJDZ3lxM2Qy?=
 =?utf-8?B?OXNHOHY5TkNadTdoV2t0UjFqcGZZTzFVOU1kZUt3aEtFOHltdkJtdm9paHhB?=
 =?utf-8?B?SjExRXRHTXByTlVSZGk4ejR1UFNlMVY4eDNnSlhlcTJVVFFJRVczbks5QU56?=
 =?utf-8?B?eGRGcVo4WGlpdUo5c1ZXcVRVclBOUFh0YXBqNm5qWUtzSVQxZUxiSU5ISTB2?=
 =?utf-8?B?NlBKM3ZhQ0FDSWpzSlJvSkFtblpxTjZuc05UZmt0TnVhZlBueDZ0V2FYQnZT?=
 =?utf-8?B?MGlRSk5zWEM3MnYwRXFnUlZ2UXErYThKUmN6a3IvcXlGdEJOWGJxZmZHck5L?=
 =?utf-8?B?a0YzeXNEU0hKNkdMb3Q4d1BYejcxTGVHaWoyWGs5SC9kd083UktmcEtuQ0ZB?=
 =?utf-8?B?SVFzTGR1dVA2RlhUZjdueDZQMy9yeHQxdW9UbVovT1BpQU9kRndhZz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 8709a1d9-066f-437e-95ee-08df090f77e1
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:30:15.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ylb9iiPRTIjy88QDYMf0j+iyw0uSi9GtKHaBuhfWGTUyOcLxkWuczKw6p2lam4NVfMpdn7mQdOAqXwrPIO9cGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0638
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6FCD4180006
X-Stat-Signature: fhepnc5p5gf7i9dqpcby7y7sbmhxzijt
X-HE-Tag: 1788366624-690540
X-HE-Meta: U2FsdGVkX1+g4y9ZOQXSyChhGsPR3C1UpW1f8HcS//YZHeRhXQA0WYZmygQrk+AoU6b2mUPYM9Ibgi0p7UcoxntzFMyUg8OVkgIcDZvg4XS8anhGbWQU0CjEKF83ab1PfzZWgXVi3al3ydUr2Bv9Z9coxDI4eyOE42Mg2ZJ3QuV4wonewbxHzZOCfLZrwSlNpRtWf0wXvY6rRmlWzex8OrxatdIwDQPZCHyAPYtRRF6szTuK0L+cnWwRpbdionBPyWGLgbTk4k2gUHn6TPLQ0EWoSdxnjbM1eh7mN2W5SxC4u//r4Kv+Val9eclGFZGrJlFV93DdT4GnbzN5CPvmHVgr12fI0KQRe2lGqEYR1FsrM5bmVE03rEP1UsDJbzEU+/nQwedl4+tsCbBSmTwvqODSn1pSg6P+hkAMVQbiYF7+cK8pV2qufrurrFalTZFOsCqLxd3fI5i7DUaYUU3Ujd3q0GEqa5Ch4H9F2v5vlyMAPKTjZQsFFLIzWKqVY6f8gP6KlXXdtf8Zzxphvzbk7koNFPBdruJ+od46fg6Q9K6kacb6xbq2w+vyhvdud4bzqT4h7NUKqUKuc6HCRF5sqhdvBhmSXM6fHTICB62vU4/agLO9J20J5WM9i57QgP3/lA2XEgwhAHYZmS97BQeD99oTBqa9l8kosEu7WBsoYAA5pn/uKE+WqQp5EPu0q0iiBhnpfVu3NnCGigIhjvtn9EOL3jjV7G40NyNij/UedA1sBQZAOeNa39QW6jeS7LQIRYM9S5PKFQl0ovxT0E5ZwI6/HAso3u6Yhc3fPWrMk8Z1c0faIIYdmKrZ0jvt8nX/rajIvY5Li0bhD9pHyslozJJncgx6Y2FJZxkIXF5TZsdLrsD0JPEBFKP9NAgfM+shImsGLQvkXQoVvztmNHgCLqrMWUmLfP87vwJU5R0nt02i5bbfZpIqB7mjwNYQcuw+3eHZU5N0JG0OULvfP+Z
 6feCPsba
 JgeR5kNx7kTnm5zPjmY8HcMEx0EBZkscsPBpHHwdBQoK4/p6IsA26Yte1fkcNB+dOtAaI0D7T1T5oMaBAT5so27r2r6zy/5jyQzFZTikTgoaGyjxSAYUtjKLEh3WcRQvsxd7WmdStQKCzcP+DU203hoA/I7S+2n/ZFwKWOrWKC2eSNAOFF+QTkAv8UQpJ6lWKpmxOarWmInvQJUl4LYDqboa9u+vDgBwVrMhugx9UwKCHxPUxSdS/BluKBgpigorXV4PWVuU3e7aKEOFSQIyUlitwp13bJgBXAJS8KxXmh1YeGCKgiqQHyPpVygVXG8dl2klOfV7eCDynvW9OPrwhfZPlP6v+J7EhltVus6Y0rScOJgAgUfBXBVmWEieN8V4YaSTU+8e8ZzF+mZFDVou1J21A7MoW0DpEA7w435l+om1H1l6G4B+CAwL03WxKGT56/10aLWBiBnZ0v8qA2IDSHeF7emuW3JnJ6SfDGHN88Tm216QElu2cJQg1TRCKj3pIiygYeP7QZWGrfns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a Rust module that exercises remote dataflow collection: work a task
queues to a kworker, bracketed with kcov_df_remote_start(handle) /
kcov_df_remote_stop(), is attributed back to the buffer user space
published for that handle with KCOV_DF_REMOTE_ENABLE.

A CompositeStore of three RBTrees (standing in for separate lookup tables)
is driven through three phases on system_wq:

  populate: fill all three trees
  update:   insert new entries, read existing ones, overwrite some
  drain:    remove every entry via a cursor

The work item calls kcov_df_remote_start(1) on entry and
kcov_df_remote_stop() before completing; kselftest script publishe handle
1 (KCOV_SUBSYSTEM_COMMON, instance 1) with KCOV_DF_REMOTE_ENABLE, triggers
the kworker through a debugfs file, waits for completion, and checks that
records from all three CompositeStore phases were captured from the
kworker rather than the triggering task. Needs CONFIG_RUST.

Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 .../kcov_dataflow/rust_kworker_remote/Makefile     |   3 +
 .../kcov_dataflow/rust_kworker_remote/README.rst   |  13 ++
 .../rust_kworker_remote/rust_kworker_remote.rs     | 207 +++++++++++++++++++++
 3 files changed, 223 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/Makefile b/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/Makefile
new file mode 100644
index 0000000000000..cb7392a50b1a9
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := rust_kworker_remote.o
+KCOV_DATAFLOW_rust_kworker_remote.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/README.rst b/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/README.rst
new file mode 100644
index 0000000000000..aff597ab67aea
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/README.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests: rust_kworker_remote
+============================================
+
+Rust module testing kcov_df_remote_start()/kcov_df_remote_stop() from
+kworker context: the trigger queues a work item on system_wq whose three
+phases (populate/update/drain of a CompositeStore of RBTrees) run with
+remote capture on handle 1, which the runner publishes with
+KCOV_DF_REMOTE_ENABLE. Built only with CONFIG_RUST=y::
+
+  ./test_modules.py -t rust_kworker_remote
+  ./trigger-view.py rust_kworker_remote --remote
diff --git a/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/rust_kworker_remote.rs b/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/rust_kworker_remote.rs
new file mode 100644
index 0000000000000..65c5722c383cc
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_kworker_remote/rust_kworker_remote.rs
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Test kcov_df_remote_start/stop from kworker context.
+//!
+//! A composite struct holds three RBTrees (simulating RBTree/XArray/maple_tree
+//! workloads). Three work phases run on system_wq:
+//!   Phase 1 (populate): fill all three trees
+//!   Phase 2 (update): insert new values, read existing, overwrite
+//!   Phase 3 (drain): remove all entries
+//!
+//! User space publishes a buffer with KCOV_DF_REMOTE_ENABLE, writes to
+//! /sys/kernel/debug/kcov_dataflow_test/trigger_kworker_remote, then reads
+//! the captured records.
+
+#![allow(missing_docs)]
+
+use kernel::prelude::*;
+use kernel::sync::{Arc, Completion};
+use kernel::workqueue::{self, impl_has_work, new_work, Work, WorkItem};
+use kernel::rbtree::RBTree;
+use kernel::c_str;
+
+module! {
+    type: RustKworkerRemote,
+    name: "rust_kworker_remote",
+    authors: ["kcov-dataflow"],
+    description: "Test kcov_df_remote capturing from kworker (RBTree composite)",
+    license: "GPL",
+}
+
+// Extern bindings for kcov_dataflow remote API (kernel/kcov_dataflow.c)
+unsafe extern "C" {
+    fn kcov_df_remote_start(handle: u64);
+    fn kcov_df_remote_stop();
+}
+
+/// Composite data structure: three trees with different key ranges.
+/// Simulates a real driver managing multiple lookup tables.
+struct CompositeStore {
+    /// Primary index (keys 0..N)
+    primary: RBTree<u64, u64>,
+    /// Secondary/auxiliary index (keys 100..N)
+    aux: RBTree<u64, u64>,
+    /// Scratch/temp space (keys 200..N)
+    scratch: RBTree<u64, u64>,
+}
+
+impl CompositeStore {
+    fn new() -> Self {
+        Self {
+            primary: RBTree::new(),
+            aux: RBTree::new(),
+            scratch: RBTree::new(),
+        }
+    }
+
+    /// Phase 1: populate all three trees with initial data.
+    #[inline(never)]
+    fn populate(&mut self) -> Result {
+        for i in 0u64..8 {
+            self.primary.try_create_and_insert(i, i * 0x1111, GFP_KERNEL)?;
+        }
+        for i in 100u64..108 {
+            self.aux.try_create_and_insert(i, i * 0x2222, GFP_KERNEL)?;
+        }
+        for i in 200u64..208 {
+            self.scratch.try_create_and_insert(i, i * 0x3333, GFP_KERNEL)?;
+        }
+        Ok(())
+    }
+
+    /// Phase 2: insert more, read existing, overwrite some.
+    #[inline(never)]
+    fn update(&mut self) -> Result {
+        // Insert new entries into primary
+        for i in 8u64..12 {
+            self.primary.try_create_and_insert(i, i * 0x4444, GFP_KERNEL)?;
+        }
+        // Read from aux (get passes &K which is a struct arg)
+        for i in 100u64..108 {
+            let _ = self.aux.get(&i);
+        }
+        // Overwrite scratch entries
+        for i in 200u64..204 {
+            self.scratch.remove(&i);
+            self.scratch.try_create_and_insert(i, i * 0x5555, GFP_KERNEL)?;
+        }
+        Ok(())
+    }
+
+    /// Phase 3: drain all trees.
+    #[inline(never)]
+    fn drain(&mut self) {
+        while let Some(c) = self.primary.cursor_front_mut() {
+            c.remove_current();
+        }
+        while let Some(c) = self.aux.cursor_front_mut() {
+            c.remove_current();
+        }
+        while let Some(c) = self.scratch.cursor_front_mut() {
+            c.remove_current();
+        }
+    }
+}
+
+/// Work item that runs three phases in kworker context with remote capture.
+#[pin_data]
+struct RemoteWork {
+    #[pin]
+    work: Work<RemoteWork>,
+    #[pin]
+    done: Completion,
+}
+
+impl_has_work! {
+    impl HasWork<Self> for RemoteWork { self.work }
+}
+
+impl RemoteWork {
+    fn new() -> Result<Arc<Self>> {
+        Arc::pin_init(pin_init!(RemoteWork {
+            work <- new_work!("RemoteWork::work"),
+            done <- Completion::new(),
+        }), GFP_KERNEL)
+    }
+}
+
+impl WorkItem for RemoteWork {
+    type Pointer = Arc<RemoteWork>;
+
+    fn run(this: Arc<RemoteWork>) {
+        // Enable remote kcov_dataflow capture for this kworker task.
+        // SAFETY: FFI call to exported kernel symbol; no-op if no buffer published.
+        // Handle 1 matches what trigger-view.py passes via KCOV_DF_REMOTE_ENABLE.
+        unsafe { kcov_df_remote_start(1) };
+
+        let mut store = CompositeStore::new();
+        let _ = store.populate();
+        let _ = store.update();
+        store.drain();
+
+        // SAFETY: FFI call to exported kernel symbol; disables capture.
+        unsafe { kcov_df_remote_stop() };
+
+        this.done.complete_all();
+    }
+}
+
+// --- Debugfs trigger (same raw pattern as eight_struct_args_rust) ---
+
+unsafe extern "C" fn write_handler(
+    _file: *mut kernel::bindings::file,
+    _buf: *const core::ffi::c_char,
+    count: usize,
+    _ppos: *mut kernel::bindings::loff_t,
+) -> kernel::ffi::c_long {
+    let work = match RemoteWork::new() {
+        Ok(w) => w,
+        Err(_) => return -(kernel::bindings::ENOMEM as kernel::ffi::c_long),
+    };
+    let waiter = work.clone();
+    let _ = workqueue::system().enqueue(work);
+    waiter.done.wait_for_completion();
+    count as kernel::ffi::c_long
+}
+
+#[repr(transparent)]
+struct SyncFops(kernel::bindings::file_operations);
+unsafe impl Sync for SyncFops {}
+
+static FOPS: SyncFops = SyncFops(kernel::bindings::file_operations {
+    write: Some(unsafe { core::mem::transmute(write_handler as *const ()) }),
+    ..unsafe { core::mem::zeroed() }
+});
+
+struct RustKworkerRemote {
+    dir: *mut kernel::bindings::dentry,
+}
+
+impl kernel::Module for RustKworkerRemote {
+    fn init(_module: &'static ThisModule) -> Result<Self> {
+        let dir = unsafe {
+            kernel::bindings::debugfs_create_dir(
+                c_str!("kcov_dataflow_test").as_char_ptr(),
+                core::ptr::null_mut(),
+            )
+        };
+        unsafe {
+            kernel::bindings::debugfs_create_file_unsafe(
+                c_str!("trigger_kworker_remote").as_char_ptr(),
+                0o222,
+                dir,
+                core::ptr::null_mut(),
+                &FOPS.0,
+            )
+        };
+        Ok(Self { dir })
+    }
+}
+
+impl Drop for RustKworkerRemote {
+    fn drop(&mut self) {
+        unsafe { kernel::bindings::debugfs_remove(self.dir) };
+    }
+}
+
+unsafe impl Send for RustKworkerRemote {}
+unsafe impl Sync for RustKworkerRemote {}

-- 
2.47.3


