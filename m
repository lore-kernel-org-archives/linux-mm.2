Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F16FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3965A6B00B9; Wed,  2 Sep 2026 12:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346C36B00BE; Wed,  2 Sep 2026 12:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124636B00BD; Wed,  2 Sep 2026 12:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDCBD6B00B8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59A1DA02B3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:24 +0000 (UTC)
X-FDA: 85169359968.27.61349D2
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011010.outbound.protection.outlook.com [52.101.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25B21180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=x5HVGo7g;
	spf=pass (imf16.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSCiurM4Q+HxomS0iR1barVyZnAg50nN9s6DrBUldPs=;
	b=F6dE9oUSX4WWT1XeYoEZEYOZ47UNhZ6201BYRIcW+g6+AE3fNvhqYuhs9D5RuxtTIoySRm
	Q+WeWrkK8CJt/yCGK2vJPZcVJ5GcIOE/BGmdTp/ixy8OR8BeL3NrblZ0cSqRo/qsQlGIRD
	jVfNGgo0fRjfGegY3X7BzPxtdMiUk0o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366621;
	b=pvp6Xat5aaZykI41dwukiQtI9PDUWHWlt7KAXJOdXYATr2JCw2JlT5YKKYkZ9qc+bGjHwN
	8/2g7wVisdvCwYvidSWBLDZ2qksXY287DqQcksiLQXu4j6236rwBv87dhgNxcg2hzTlgWb
	OnEVS4dds0s7Al4eWUfUpA0W09JdWvs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=x5HVGo7g;
	spf=pass (imf16.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GTfuXxoMDzsohO9LDYexJku7q5nh2zzijwhHHxDBE7BjRIzlTMvv6t8LKNsQQr9tBvpNTwJOgU1abvzaIOa3hJZtKfGtxlVLLSk3UsqJ7khhaldU660m5+USmNWJ4yyg0LWd6a4hKedocikjmoX/DShBhIW5RMwLvJYx5DEI0BVhd0ok1ylHCA2L9HyX9FtJ0SJuPfHoMBMnrCgbDj3OzKRKMXpHfLNObVzV3irgQJDLcXEMOSksLe9EZQWg9IbFCiVRgcA3Bw87rMPnDIx0KqoMsSBCiBnf6UYUkjRjdBjPv4HPBsOQ5D2BlvsoUiIS6dDQlv9P4RAz/7RIt4LVRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSCiurM4Q+HxomS0iR1barVyZnAg50nN9s6DrBUldPs=;
 b=ZNaHkOOM7M0EP9kOZ1whPwxrAs6xoBV6kIGkvxvvnF3lXWgTQy4EcegoXgOLZW59jTsRFzbDJQA5kMDpoKE09QIZgwnBgzOE/xQfOMML7WQc2hrb+TDrBVTKhXLbSg04T7DjKFV8fNeQN9jz2u3CJQ3iARKoVKrW4r9HE5NAoVsGTH7SVfgSYnDrzpfDakw2SUuPaL/snjifdHK1eObGssCHS99kfUtQXZbNTmO1Zz2tAz2+IwcrW/yIkKtr7C9ghYCksN7JEbEei4BzommjE7DH/aqD5PD1dycU/vGxW8Vb2gk05zFqUSYp5kIWPZKoCR+tkZqt4akNrbs2+1c/7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSCiurM4Q+HxomS0iR1barVyZnAg50nN9s6DrBUldPs=;
 b=x5HVGo7gNFd1EpVrhPnKjamEAPdzupiohNhb/0lOag1EArZeV2cXc7rocsComdtUGLvZbqFBL9SGQHIHNB0ektMnCPLVXjeVVNOl2BUljVVj3aOavA/o9I0SbjZud/7chMT2fN1u4kJBqCVqVtJkPhndzDHD5FvpxhPpeMoz+qoA9YgjR9H1IQcQtZyJrRw5ifuIv4p7ptD5P26o3hqhhLrdtel4ovJcexDMJx/bshjkcpdbfLk+WCCOQPdwq/yQQ4qXDS8GxkbpmnoRQ0ZeO+l7EqoAlRKz9VQGb6kI6FtyQ0A+/qfPiG6ZnRyjwy/KcDIBP0bp8HH7jsVFsAm2ow==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by VI1P18901MB0638.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:30:13 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:30:13 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:39 +0200
Subject: [PATCH RFC v3 6/8] selftests/kcov_dataflow: add
 eight_struct_args_{c,rust} selftest module
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-6-824609f279f5@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=38874;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=BEHLe+hnyM3ZN+qdP60TF7O5oTJnluzke28O7lhfsu0=;
 b=N5h0tvbK8tN9YPXOcNEofAgP87/eKenRejqpQFop3JlNQdqwK9SE3G/C+teQPZxRP+NcqGA9o
 T/61QmVmIJXBU3tT98h1MP7YX7OnrXlI0VPjvp2BTAV+fOigmbDFpA4
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: DX0P273CA0047.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::20) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|VI1P18901MB0638:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e53fdbd-fbbe-4fdb-465a-08df090f7686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	IZ3q5nHRqbOFhxovvIqIPLSO35ZbZDnIjVCdycwqXThYYcE9wL7jk7t+HbHtW1PFgjyzIpYcbVgKmi3jljOE0dTx17oh8r2va6dOlVZVOKsgDGuVfi288C0YQiPr6XRwqe57xlx1LEozMNMz8PbIMlYeacHQWczlwZ4ttXJsjsPzA44utowbi0pa78qGiFuTPdjCl+zBK+1aW6sgrQhbjbwBlucvF4pkPmS5aX8IGsTvIllVGFWcB7CbLKP2vSpGujYQz9X93D8seMnMb6H3Q8LeQE2ecsINu0XJ3gJIUdYj40fMfKtiW5bsz4+IeSLmP+kBtpgrnU2zIIx9SsyJ53iRrcW5CW1cw2pfRImhfRtXPy9F2LPMPY+itiJcBKkKpZfYu9/VY2iNcZwHTilXijGbG6t99ip31pNUern3Ag5krwQnWR/JB4M/okbZiLWjCDmNVkMgUzrCKdFQPTOzWOxv9gVAnzaL2xwkcxz/qojgpsDPFbBuJ8ySemmE1ZTH9trC+f4FtA1PL8sygZzz3yqXc9MIiM4PGFmuAonVcQ26robVDSuuYQ9lama0pH05kANFUgCWJ6PfKUtTGHTUhvFKBeRqVyMlyULGYmG5uzGaibPGvQpra4DgXOkBoH7PhwERjbQIoqFKt7xcwUK4og5+jab2eZ79hw58AmxL/L4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1Z1cW9KbDRzMVZheXJhdFBvSXp3NjlpQ1Z0R0hxcmppUDRaMmh5WXREZnly?=
 =?utf-8?B?eEgyekdsWVVpSDFtZzA4U1Nkc0pzeUVTelRVdWZJOEZlZUdMRmF6VHlsa3hD?=
 =?utf-8?B?MlhOanJHTFhKcmVRVW5YSDBDc2VOSi9HS1NCTEU1V1dsRWk1UVhlTjB5YjM0?=
 =?utf-8?B?cmQ3ZUNLQ1YybjlkWkhVai9aMmFYa3VvTGpySkMvREdOMlcxSmFtYlEzTTFs?=
 =?utf-8?B?SWpDQVNsd0NnTTZBdkFzSDI1bEo0REtqYkh6dkNyVUxJblZPYklQbGRWR2Y3?=
 =?utf-8?B?R3gvS0xVdzFhUE5hNzNpUHEwR1FLa29JMXhGbENsQTd0MGJKT3ZMcTV2Y1RP?=
 =?utf-8?B?dXlWWU11Rzc1ZmlOVDJsZTJmeW9FOXpTQ2oxSVZFdnlWUW1HWDhIR28zMllz?=
 =?utf-8?B?K3BIWUhsWFF2S1dpVkJ4QTluOTBiQVo2TzFQREVYTjMyYlBZdTFWN21hTXZ2?=
 =?utf-8?B?UDhVVlgyWi9JclRBOXhKYzh1K0xyT1VQYkVaTG9rMjhOOEFvT0JNRFJnVXY1?=
 =?utf-8?B?Y3hoSmRaVk4vT1NvYU8xQytIRUFkMzhxREw5N2pHMGgrK2dHb2xlb1E4b3N4?=
 =?utf-8?B?S2h4eDBlVFBjRzJtSkUySzdGdDN4VVNaV3hZTXZXMXNtNVJRaTRMM1h1a2gy?=
 =?utf-8?B?N09aL0E1dm1yaWtXTmkrOTJzcUYzTG4yRHl0MjlibUNhNkxVcmk2Tmp1V0Ev?=
 =?utf-8?B?K2wwelk0NWxOZ3BIcTVpMFo2bG9sYVVqY3BhRk92dHgwaExHRldWa0FFYkw3?=
 =?utf-8?B?ZFVGMFBYK2NERlNhcm8wc2hvZ0dYNU9MeHhzdkNFK0pTbFE3UXJjbnlCUGUz?=
 =?utf-8?B?Rk1DNHdiYmhDeS9yc2JKcGFlWEpxaTdDd3pLY01PRUZoR1dJbGRpYTdCeE85?=
 =?utf-8?B?VldybC8yNENNREFQb09tYmdENm0zZEg3YnpyU2hNdnp3bndGTGZtdGFSN0Ro?=
 =?utf-8?B?Ym1jSEJ2TmpqRDIycFdZcHB0RnVZSXF3N3I4Mno2a3ROSURQNkI5SDFxRGNU?=
 =?utf-8?B?dW9sMGQ3dHNhRnROdjdXczNwdWJPZ1diRUJ4SlRRQ1ZBaHAxb1hGMVExVlpE?=
 =?utf-8?B?WFd1dm40eE02T0d4Rng5Nkg4QWhDVkZDdGxhMmwzdzJOVGxDK0FtNVdMWExh?=
 =?utf-8?B?aTRNVi9EZWlrVUMzV1hVZGVvRW5EV1FDWWgxQ2JyV056aENNL1lvTjA0Zkg5?=
 =?utf-8?B?cUUvQjdzZ3NqY3BrYmJISm5wcm1jdGNXWkEwRkY1djJKU3FYd1ZEYkIvUFY3?=
 =?utf-8?B?bU1JbFg4Q3N6OVdoSDJudjlCb1Y0L0J6TWJwVTdHNkUrTGZzS1hnV2JCV2hO?=
 =?utf-8?B?cUtKUzVzREpqU09KMXFhWklwMldiQ0w1MEtUMjl2eW15OUFhQy9OWUhoTmlN?=
 =?utf-8?B?emVHSzJLbUhFemYvN1JsSkNFNWtWdURldzlRbm9DMnhGZ0FEQVE3dk5sSVEx?=
 =?utf-8?B?WHdtZUVMRnA2cWRUenZOZEJOYTV6aGxoNWpRTTY0OG9YWHBRNm81VUN1aGpK?=
 =?utf-8?B?WVc2dnUxU1NheWphVXdvK3pxN1BXUTVhb3NsMWt5dVRZS1c2SjFyNEFQY0VD?=
 =?utf-8?B?ek5IWUU0Q29yay8yYTZsdythak1vZ1lCMVdDQ2xNdjJ6SStmTjJaZWdtZDl3?=
 =?utf-8?B?ZE9HYmFIdllWdkdGenJvWk1aVWtqYlAyRFBSQnhTV0xieEZVV3VpWjlTUTdm?=
 =?utf-8?B?azR1Yk5KRnoxL1ZYTHRQcWVldGhPSVJXUmRBcEJDWVg1eDc1MTUrOUh5NnMr?=
 =?utf-8?B?UkNmelQvbHBiNDdEb2d0N29iamZPVS9JRU52UWo0dmlDUzhObGxvQTcrQ1VS?=
 =?utf-8?B?K3NRRVFqNlBzYTZsQjd4eS9YL1RBLy9TQVZWSHF2UWRnSjNjOHZvM01MaVBP?=
 =?utf-8?B?cEEvOWYxSUJLWXBRTDFJSjVmSUdFdW4vYWJPY0hnT3R6V1hxUFFwNklWR0Rx?=
 =?utf-8?B?ejhXSlZLWFVNbUdieERFMmVNOERsRmplNGEvMFpCSFJrb2VaVEJoV3RSRTVs?=
 =?utf-8?B?MlBKaVQ5dzdtckY3MU5CeHBOUnZsWE9wVkk2ajJxZnVzZkZZbE40MzhaSTBs?=
 =?utf-8?B?RUxDdFJUeEx5NzMrZHYrSys1WUFadlRTK3RieTE4bDhxWS9pTmRNY1cyRmFY?=
 =?utf-8?B?V3RkM08zd1Z2cFVSZmxMSnBoZDF5Yk5MWHJXZjI3QlRObmdaSHJyZ054ZWJh?=
 =?utf-8?B?RVdhUTlpZk1TZWdrbjlYb2Iyb21VZnpGTS9iT0pnZXBCd21NSk9oSHRWYUpY?=
 =?utf-8?B?MFBFSTl1OW5LZEwzalA5cnB5MHRacFh6WWlONFpVOFA0MkJCNTEyOVZBaUI1?=
 =?utf-8?B?MEEyNVdRUkdPL1U2dCtnUExKZ2xBZlRXSkNBclVwZkFVMDg1a0todz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e53fdbd-fbbe-4fdb-465a-08df090f7686
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:30:13.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: liHfp3iZVTks6BpJZt9Jm6vFSjCl25IXZaEejS00gnY6j2n+5en8I/LbCjacIXTlPzzH1ICGlcWLY1QyXIuuLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0638
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 25B21180006
X-Stat-Signature: 739wqs7x53re11bsjduq3nj6p8c44ahn
X-HE-Tag: 1788366620-218349
X-HE-Meta: U2FsdGVkX1+aUvBWSSDvdXVncrRPYahPepGpU/bi9qS/LGICp+zrXXHYt9NXL7HIP1wNd/GkuawM4FJ8COZzX4V9S1bbSlc+ySNdym/Nqxr+7rXzWcLxfqU4xYz1Ece5lNM09rWesQfpFAE7vvl6trNbWXpjJ/KABPtQFbPR6RiyFOVwS+9vwU9z0qYOGGlqkmECNQVecxOmMWtavL09WcnY4FFW0Aok2NVoYcIwLFRr3Uk9h3TBop4vNgBEXkmm2qFwIWSGP9BlA9FO/GvjrNtt+MCnZ8f7jprNm4QA/grNs45fVTAjZHRUZhay8IcH+Ey4GEJNiOYrbwQOzFpJvyVDK2kTH60RDvzkBEOZaQA2dizxBW/ByIubOP8IRPsv3ILx/EpBtkbH4lc/CH2aHRyjmr0keoKwZJB366uTuxew/dTzPFMS5nTccty98OOAXvcJzjGy7hTVjS/AvmylctBbs2UWVoJudO1gjiZ9iJDO6d3RSOy2QjRWYlrohF7KohrLl9T7iZpdHfPQxoHeIjw4rzh9z3Ij9OUoLIdEeyHlmEVqWu8MJb/wlC+zGCS5XFhoZJb7Sb8mV5gPhWr/RcKiALIjQFqKOcJ4CLDSmpSs3R5k10tNp2DB7ZTkY7DFgWGT45jTq1nRA/d3nZzGdDVkMyYe3m1yR11CPnTlhs6YYi9Qh2RLMsq6Z9qIp+ihtVKg5BjOl/q+wnNbVP0S7UX9JUFJE+EOf7FnTt+qq2JXDfgL4cUGQg7wBPedqZD5waVprekqwx+PdObk8vX8AfFKlxduOCX2sia4VHV/zTfDO/3ERFIJ8UcoVmJKq6ZWnE+q7fEXx7fdpOBhrEi6Vu5JrPNqvouqu5fewyISaQV9fjZDsakjP17ys8hD2xJMtGW88DK0Ylp6vk/lLn9o/PQGA6aMKYHf5IxgisYfwBnEEdky8lILvx13BmXnKBs7KpZqBFiJoSdbmePcQG2
 6PODyUU2
 6K2CuSTDSGWjz43MYcdTPCt2XCRkmUKyXP93IQi9wcf0bqGg/0mnsev28r6PyewrpcfI8iUC4OE3+hpONelrZlKXDwprnsQRszvud7XRExbZ7Qy+4nuTf/UO+eZ2gXTOE97wwacdl3YeIjISK8yAb6ZJq2j5RyBPZkft6MirMdg/bHaua+IWGuu+vR6mN3nxZDw19zFyIDshC84u47w1j0PWrlsy6wuB6WdORdu1rpgRlj066wV0/COf9GCVBtCDUbP9gNdT5JZx8YI/nyJv75Z8FVW7Cm9gOHbhDPy6g7sqp7JQacr6WCnli4BKeJy8GW7alJifdK2ndfsu3/knTLUK7R0bP57FOrU3W633FqsiAHjwOhviwWP/2H9E4kZqo/2AXtIa1/tkyakN9uYzGeeYTlQ1QTWw5+H2fD+I2L9ky/jnOVjGadTucaPWfnTWfSRRwZb9upkC22a0F+M2oZhR3ulMPB+rzUXOOTJ4+HRa9SeiGFL6TFb1yIlRYWF25BLTV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add C and Rust modules that verify struct-pointer argument expansion, the
part of the collector that turns a pointer into its individual field
values from the compiler's DWARF offsets.

Three families exercise the expansion:

 - Flat sf_1()..sf_8(): sf_N takes N struct pointers (s1*..sN*) whose
   fields are 0x11, 0x22, ...; this covers plain field expansion and
   multiple struct-pointer arguments in one call.
 - Value-nested stf_1()..stf_8(): stN embeds every smaller struct by
   value, so the nesting deepens with N and each level is a distinct
   struct-pointer argument (on-stack; st8 is built on the heap to stay
   under the frame limit).
 - Pointer-linked stpf_1()..stpf_8(): every member is a pointer to a
   separately allocated node, so expansion is followed through the heap;
   run over both kmalloc and vmalloc allocations.

Plus pointer forwarding (sf_fwd -> sf_fwd_inner) and a struct return
value (sf_ret_struct). eight_struct_args_rust mirrors this with no_mangle
rsf_*/rstf_*/rstpf_* exported functions and needs CONFIG_RUST.

Each object is opted in with KCOV_DATAFLOW_<name>.o := y; kselftest script
will trigger them and checks the expanded field values (0x11, 0x22, ...)
per argument and every return value, so the modules validate the
captured data, not merely that records appeared.

Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 .../kcov_dataflow/eight_struct_args_c/Makefile     |   3 +
 .../kcov_dataflow/eight_struct_args_c/README.rst   |  13 +
 .../eight_struct_args_c/eight_struct_args_c.c      | 533 +++++++++++++++++
 .../kcov_dataflow/eight_struct_args_rust/Makefile  |   3 +
 .../eight_struct_args_rust/README.rst              |  11 +
 .../eight_struct_args_rust.rs                      | 646 +++++++++++++++++++++
 6 files changed, 1209 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/Makefile b/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/Makefile
new file mode 100644
index 0000000000000..04ff83f0a9625
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := eight_struct_args_c.o
+KCOV_DATAFLOW_eight_struct_args_c.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/README.rst b/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/README.rst
new file mode 100644
index 0000000000000..62cddee78cd36
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/README.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests: eight_struct_args_c
+============================================
+
+C module with 1-8 struct pointer arguments (flat s1..s8), value-nested
+st1..st8 and pointer-linked stp1..stp8 towers (on stack, kmalloc and
+vmalloc), pointer forwarding and a struct return value. Opted in with
+``KCOV_DATAFLOW_eight_struct_args_c.o := y``; test_modules.py checks the
+expanded fields (0x11, 0x22, ...) and every return value::
+
+  ./test_modules.py -t eight_struct_args_c
+  ./trigger-view.py eight_struct_args_c --raw
diff --git a/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/eight_struct_args_c.c b/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/eight_struct_args_c.c
new file mode 100644
index 0000000000000..c7d06a8e94c38
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_struct_args_c/eight_struct_args_c.c
@@ -0,0 +1,533 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * eight_struct_args_c.c - Verify kcov_dataflow captures struct pointer
+ * arguments with automatic field expansion.
+ *
+ * Three families of structs are exercised:
+ *
+ *  - Flat structs s1..s8: sN has N u64 members side by side; sf_N takes N
+ *    struct pointer args (s1*..sN*). Tests plain field expansion and multiple
+ *    struct-pointer arguments.
+ *
+ *  - Recursively (value) nested structs st1..st8: stN embeds every smaller
+ *    struct by value, so the nesting deepens with N:
+ *        st1 = { u64 field0 }
+ *        st2 = { u64 field0, st1 field1 }             // { v, {v} }
+ *        stN = { u64 field0, st1 field1, ... st(N-1) field(N-1) }
+ *    The deepest chain in st8 is eight levels deep. Used by the stack tests.
+ *
+ *  - Pointer-linked nested structs stp1..stp8: every member is a POINTER to a
+ *    separately allocated object, so the nesting is followed through the heap:
+ *        stp1 = { u64 *field0 }
+ *        stp2 = { u64 *field0, stp1 *field1 }         // { *v, *{v} }
+ *        stpN = { u64 *field0, stp1 *field1, ... stp(N-1) *field(N-1) }
+ *    Used by the dynamic-allocation (kmalloc/vmalloc) tests.
+ *
+ * Write to /sys/kernel/debug/kcov_dataflow_test/trigger_struct to invoke.
+ */
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KCOV dataflow struct field expansion test (flat + nested)");
+
+/* Flat structs: sN has N u64 members. */
+struct s1 { u64 a; };
+struct s2 { u64 a; u64 b; };
+struct s3 { u64 a; u64 b; u64 c; };
+struct s4 { u64 a; u64 b; u64 c; u64 d; };
+struct s5 { u64 a; u64 b; u64 c; u64 d; u64 e; };
+struct s6 { u64 a; u64 b; u64 c; u64 d; u64 e; u64 f; };
+struct s7 { u64 a; u64 b; u64 c; u64 d; u64 e; u64 f; u64 g; };
+struct s8 { u64 a; u64 b; u64 c; u64 d; u64 e; u64 f; u64 g; u64 h; };
+
+/*
+ * Recursively (value) nested structs: stN = { u64 field0; st1 field1; ...;
+ * st(N-1) field(N-1); }. Each stN contains every smaller struct by value, so
+ * the nesting depth grows with N (st8 is eight levels deep along its st7 chain).
+ */
+struct st1 { u64 field0; };
+struct st2 { u64 field0; struct st1 field1; };
+struct st3 { u64 field0; struct st1 field1; struct st2 field2; };
+struct st4 {
+	u64 field0;
+	struct st1 field1;
+	struct st2 field2;
+	struct st3 field3;
+};
+struct st5 {
+	u64 field0;
+	struct st1 field1;
+	struct st2 field2;
+	struct st3 field3;
+	struct st4 field4;
+};
+struct st6 {
+	u64 field0;
+	struct st1 field1;
+	struct st2 field2;
+	struct st3 field3;
+	struct st4 field4;
+	struct st5 field5;
+};
+struct st7 {
+	u64 field0;
+	struct st1 field1;
+	struct st2 field2;
+	struct st3 field3;
+	struct st4 field4;
+	struct st5 field5;
+	struct st6 field6;
+};
+struct st8 {
+	u64 field0;
+	struct st1 field1;
+	struct st2 field2;
+	struct st3 field3;
+	struct st4 field4;
+	struct st5 field5;
+	struct st6 field6;
+	struct st7 field7;
+};
+
+/*
+ * Pointer-linked nested structs: every member is a POINTER to a separately
+ * allocated object. stpN = { u64 *field0; stp1 *field1; ...; stp(N-1)
+ * *field(N-1); }. The dynamic-allocation tests build one of these per allocator.
+ */
+struct stp1 { u64 *field0; };
+struct stp2 { u64 *field0; struct stp1 *field1; };
+struct stp3 { u64 *field0; struct stp1 *field1; struct stp2 *field2; };
+struct stp4 {
+	u64 *field0;
+	struct stp1 *field1;
+	struct stp2 *field2;
+	struct stp3 *field3;
+};
+struct stp5 {
+	u64 *field0;
+	struct stp1 *field1;
+	struct stp2 *field2;
+	struct stp3 *field3;
+	struct stp4 *field4;
+};
+struct stp6 {
+	u64 *field0;
+	struct stp1 *field1;
+	struct stp2 *field2;
+	struct stp3 *field3;
+	struct stp4 *field4;
+	struct stp5 *field5;
+};
+struct stp7 {
+	u64 *field0;
+	struct stp1 *field1;
+	struct stp2 *field2;
+	struct stp3 *field3;
+	struct stp4 *field4;
+	struct stp5 *field5;
+	struct stp6 *field6;
+};
+struct stp8 {
+	u64 *field0;
+	struct stp1 *field1;
+	struct stp2 *field2;
+	struct stp3 *field3;
+	struct stp4 *field4;
+	struct stp5 *field5;
+	struct stp6 *field6;
+	struct stp7 *field7;
+};
+
+/* Prototypes: sf_N takes N struct pointer arguments (s1*, s2*, ..., sN*) */
+u64 sf_1(struct s1 *a);
+u64 sf_2(struct s1 *a, struct s2 *b);
+u64 sf_3(struct s1 *a, struct s2 *b, struct s3 *c);
+u64 sf_4(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d);
+u64 sf_5(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d, struct s5 *e);
+u64 sf_6(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d, struct s5 *e,
+	 struct s6 *f);
+u64 sf_7(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d, struct s5 *e,
+	 struct s6 *f, struct s7 *g);
+u64 sf_8(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d, struct s5 *e,
+	 struct s6 *f, struct s7 *g, struct s8 *h);
+
+/* stf_N takes a pointer to the value-nested stN and sums every reachable field0. */
+u64 stf_1(struct st1 *p);
+u64 stf_2(struct st2 *p);
+u64 stf_3(struct st3 *p);
+u64 stf_4(struct st4 *p);
+u64 stf_5(struct st5 *p);
+u64 stf_6(struct st6 *p);
+u64 stf_7(struct st7 *p);
+u64 stf_8(struct st8 *p);
+
+/* stpf_N follows the pointer-linked stpN and sums every reachable *field0. */
+u64 stpf_1(struct stp1 *p);
+u64 stpf_2(struct stp2 *p);
+u64 stpf_3(struct stp3 *p);
+u64 stpf_4(struct stp4 *p);
+u64 stpf_5(struct stp5 *p);
+u64 stpf_6(struct stp6 *p);
+u64 stpf_7(struct stp7 *p);
+u64 stpf_8(struct stp8 *p);
+
+noinline u64 sf_1(struct s1 *a) { return a->a; }
+EXPORT_SYMBOL(sf_1);
+
+noinline u64 sf_2(struct s1 *a, struct s2 *b) { return a->a + b->b; }
+EXPORT_SYMBOL(sf_2);
+
+noinline u64 sf_3(struct s1 *a, struct s2 *b, struct s3 *c)
+{
+	return a->a + b->b + c->c;
+}
+EXPORT_SYMBOL(sf_3);
+
+noinline u64 sf_4(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d)
+{
+	return a->a + b->b + c->c + d->d;
+}
+EXPORT_SYMBOL(sf_4);
+
+noinline u64 sf_5(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d,
+		  struct s5 *e)
+{
+	return a->a + b->b + c->c + d->d + e->e;
+}
+EXPORT_SYMBOL(sf_5);
+
+noinline u64 sf_6(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d,
+		  struct s5 *e, struct s6 *f)
+{
+	return a->a + b->b + c->c + d->d + e->e + f->f;
+}
+EXPORT_SYMBOL(sf_6);
+
+noinline u64 sf_7(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d,
+		  struct s5 *e, struct s6 *f, struct s7 *g)
+{
+	return a->a + b->b + c->c + d->d + e->e + f->f + g->g;
+}
+EXPORT_SYMBOL(sf_7);
+
+noinline u64 sf_8(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d,
+		  struct s5 *e, struct s6 *f, struct s7 *g, struct s8 *h)
+{
+	return a->a + b->b + c->c + d->d + e->e + f->f + g->g + h->h;
+}
+EXPORT_SYMBOL(sf_8);
+
+/*
+ * Value-nested functions. Each reads its own field0 and forwards the address of
+ * every nested member into the matching stf_k, so the whole recursive tower is
+ * walked and each nesting level is a distinct instrumented struct-pointer arg.
+ */
+noinline u64 stf_1(struct st1 *p) { return p->field0; }
+EXPORT_SYMBOL(stf_1);
+
+noinline u64 stf_2(struct st2 *p)
+{
+	return p->field0 + stf_1(&p->field1);
+}
+EXPORT_SYMBOL(stf_2);
+
+noinline u64 stf_3(struct st3 *p)
+{
+	return p->field0 + stf_1(&p->field1) + stf_2(&p->field2);
+}
+EXPORT_SYMBOL(stf_3);
+
+noinline u64 stf_4(struct st4 *p)
+{
+	return p->field0 + stf_1(&p->field1) + stf_2(&p->field2) +
+	       stf_3(&p->field3);
+}
+EXPORT_SYMBOL(stf_4);
+
+noinline u64 stf_5(struct st5 *p)
+{
+	return p->field0 + stf_1(&p->field1) + stf_2(&p->field2) +
+	       stf_3(&p->field3) + stf_4(&p->field4);
+}
+EXPORT_SYMBOL(stf_5);
+
+noinline u64 stf_6(struct st6 *p)
+{
+	return p->field0 + stf_1(&p->field1) + stf_2(&p->field2) +
+	       stf_3(&p->field3) + stf_4(&p->field4) + stf_5(&p->field5);
+}
+EXPORT_SYMBOL(stf_6);
+
+noinline u64 stf_7(struct st7 *p)
+{
+	return p->field0 + stf_1(&p->field1) + stf_2(&p->field2) +
+	       stf_3(&p->field3) + stf_4(&p->field4) + stf_5(&p->field5) +
+	       stf_6(&p->field6);
+}
+EXPORT_SYMBOL(stf_7);
+
+noinline u64 stf_8(struct st8 *p)
+{
+	return p->field0 + stf_1(&p->field1) + stf_2(&p->field2) +
+	       stf_3(&p->field3) + stf_4(&p->field4) + stf_5(&p->field5) +
+	       stf_6(&p->field6) + stf_7(&p->field7);
+}
+EXPORT_SYMBOL(stf_8);
+
+/*
+ * Pointer-linked functions. Each dereferences its own *field0 and forwards each
+ * (already pointer-typed) nested member into the matching stpf_k, following the
+ * heap-linked tower.
+ */
+noinline u64 stpf_1(struct stp1 *p) { return *p->field0; }
+EXPORT_SYMBOL(stpf_1);
+
+noinline u64 stpf_2(struct stp2 *p)
+{
+	return *p->field0 + stpf_1(p->field1);
+}
+EXPORT_SYMBOL(stpf_2);
+
+noinline u64 stpf_3(struct stp3 *p)
+{
+	return *p->field0 + stpf_1(p->field1) + stpf_2(p->field2);
+}
+EXPORT_SYMBOL(stpf_3);
+
+noinline u64 stpf_4(struct stp4 *p)
+{
+	return *p->field0 + stpf_1(p->field1) + stpf_2(p->field2) +
+	       stpf_3(p->field3);
+}
+EXPORT_SYMBOL(stpf_4);
+
+noinline u64 stpf_5(struct stp5 *p)
+{
+	return *p->field0 + stpf_1(p->field1) + stpf_2(p->field2) +
+	       stpf_3(p->field3) + stpf_4(p->field4);
+}
+EXPORT_SYMBOL(stpf_5);
+
+noinline u64 stpf_6(struct stp6 *p)
+{
+	return *p->field0 + stpf_1(p->field1) + stpf_2(p->field2) +
+	       stpf_3(p->field3) + stpf_4(p->field4) + stpf_5(p->field5);
+}
+EXPORT_SYMBOL(stpf_6);
+
+noinline u64 stpf_7(struct stp7 *p)
+{
+	return *p->field0 + stpf_1(p->field1) + stpf_2(p->field2) +
+	       stpf_3(p->field3) + stpf_4(p->field4) + stpf_5(p->field5) +
+	       stpf_6(p->field6);
+}
+EXPORT_SYMBOL(stpf_7);
+
+noinline u64 stpf_8(struct stp8 *p)
+{
+	return *p->field0 + stpf_1(p->field1) + stpf_2(p->field2) +
+	       stpf_3(p->field3) + stpf_4(p->field4) + stpf_5(p->field5) +
+	       stpf_6(p->field6) + stpf_7(p->field7);
+}
+EXPORT_SYMBOL(stpf_8);
+
+u64 sf_fwd_inner(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d);
+u64 sf_fwd(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d);
+struct s4 sf_ret_struct(struct s1 *a, struct s2 *b);
+
+/* Pointer forwarding: callee receives pointer and passes it to another func */
+noinline u64 sf_fwd_inner(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d)
+{
+	return a->a + b->b + c->c + d->d;
+}
+EXPORT_SYMBOL(sf_fwd_inner);
+
+noinline u64 sf_fwd(struct s1 *a, struct s2 *b, struct s3 *c, struct s4 *d)
+{
+	return sf_fwd_inner(a, b, c, d);
+}
+EXPORT_SYMBOL(sf_fwd);
+
+/* Struct return value */
+noinline struct s4 sf_ret_struct(struct s1 *a, struct s2 *b)
+{
+	struct s4 ret = { .a = a->a, .b = b->a, .c = b->b, .d = a->a + b->b };
+
+	return ret;
+}
+EXPORT_SYMBOL(sf_ret_struct);
+
+/* Allocator shims so run_stp8() can build the pointer tree with either API. */
+static void *t_kmalloc(size_t n) { return kmalloc(n, GFP_KERNEL); }
+static void *t_vmalloc(size_t n) { return vmalloc(n); }
+static void t_kfree(void *p) { kfree(p); }
+static void t_vfree(void *p) { vfree(p); }
+
+/*
+ * Build the pointer-linked stp8 tower with @alloc (each node separately
+ * allocated), run stpf_8() over it, then free every node with @fr. Sub-nodes
+ * are shared (a DAG); each unique allocation is freed exactly once.
+ */
+static u64 run_stp8(void *(*alloc)(size_t), void (*fr)(void *))
+{
+	u64 ret = 0;
+	u64 *l1 = alloc(sizeof(u64));
+	u64 *l2 = alloc(sizeof(u64));
+	u64 *l3 = alloc(sizeof(u64));
+	u64 *l4 = alloc(sizeof(u64));
+	u64 *l5 = alloc(sizeof(u64));
+	u64 *l6 = alloc(sizeof(u64));
+	u64 *l7 = alloc(sizeof(u64));
+	u64 *l8 = alloc(sizeof(u64));
+	struct stp1 *p1 = alloc(sizeof(*p1));
+	struct stp2 *p2 = alloc(sizeof(*p2));
+	struct stp3 *p3 = alloc(sizeof(*p3));
+	struct stp4 *p4 = alloc(sizeof(*p4));
+	struct stp5 *p5 = alloc(sizeof(*p5));
+	struct stp6 *p6 = alloc(sizeof(*p6));
+	struct stp7 *p7 = alloc(sizeof(*p7));
+	struct stp8 *p8 = alloc(sizeof(*p8));
+
+	if (l1 && l2 && l3 && l4 && l5 && l6 && l7 && l8 &&
+	    p1 && p2 && p3 && p4 && p5 && p6 && p7 && p8) {
+		*l1 = 0x11; *l2 = 0x22; *l3 = 0x33; *l4 = 0x44;
+		*l5 = 0x55; *l6 = 0x66; *l7 = 0x77; *l8 = 0x88;
+
+		p1->field0 = l1;
+		p2->field0 = l2; p2->field1 = p1;
+		p3->field0 = l3; p3->field1 = p1; p3->field2 = p2;
+		p4->field0 = l4; p4->field1 = p1; p4->field2 = p2;
+		p4->field3 = p3;
+		p5->field0 = l5; p5->field1 = p1; p5->field2 = p2;
+		p5->field3 = p3; p5->field4 = p4;
+		p6->field0 = l6; p6->field1 = p1; p6->field2 = p2;
+		p6->field3 = p3; p6->field4 = p4; p6->field5 = p5;
+		p7->field0 = l7; p7->field1 = p1; p7->field2 = p2;
+		p7->field3 = p3; p7->field4 = p4; p7->field5 = p5;
+		p7->field6 = p6;
+		p8->field0 = l8; p8->field1 = p1; p8->field2 = p2;
+		p8->field3 = p3; p8->field4 = p4; p8->field5 = p5;
+		p8->field6 = p6; p8->field7 = p7;
+
+		ret = stpf_8(p8);
+	}
+
+	fr(p8); fr(p7); fr(p6); fr(p5); fr(p4); fr(p3); fr(p2); fr(p1);
+	fr(l8); fr(l7); fr(l6); fr(l5); fr(l4); fr(l3); fr(l2); fr(l1);
+	return ret;
+}
+
+static struct dentry *test_dir;
+
+static ssize_t trigger_write(struct file *f, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct s1 v1 = { .a = 0x11 };
+	struct s2 v2 = { .a = 0x11, .b = 0x22 };
+	struct s3 v3 = { .a = 0x11, .b = 0x22, .c = 0x33 };
+	struct s4 v4 = { .a = 0x11, .b = 0x22, .c = 0x33, .d = 0x44 };
+	struct s5 v5 = { .a = 0x11, .b = 0x22, .c = 0x33, .d = 0x44,
+			 .e = 0x55 };
+	struct s6 v6 = { .a = 0x11, .b = 0x22, .c = 0x33, .d = 0x44,
+			 .e = 0x55, .f = 0x66 };
+	struct s7 v7 = { .a = 0x11, .b = 0x22, .c = 0x33, .d = 0x44,
+			 .e = 0x55, .f = 0x66, .g = 0x77 };
+	struct s8 v8 = { .a = 0x11, .b = 0x22, .c = 0x33, .d = 0x44,
+			 .e = 0x55, .f = 0x66, .g = 0x77, .h = 0x88 };
+
+	/* Recursively (value) nested values: each embeds all the smaller ones. */
+	struct st1 t1 = { .field0 = 0x11 };
+	struct st2 t2 = { .field0 = 0x22, .field1 = t1 };
+	struct st3 t3 = { .field0 = 0x33, .field1 = t1, .field2 = t2 };
+	struct st4 t4 = { .field0 = 0x44, .field1 = t1, .field2 = t2,
+			  .field3 = t3 };
+	struct st5 t5 = { .field0 = 0x55, .field1 = t1, .field2 = t2,
+			  .field3 = t3, .field4 = t4 };
+	struct st6 t6 = { .field0 = 0x66, .field1 = t1, .field2 = t2,
+			  .field3 = t3, .field4 = t4, .field5 = t5 };
+	struct st7 t7 = { .field0 = 0x77, .field1 = t1, .field2 = t2,
+			  .field3 = t3, .field4 = t4, .field5 = t5,
+			  .field6 = t6 };
+	u64 sum = 0;
+
+	/* Flat struct tests: sf_N takes N struct pointer args */
+	sum += sf_1(&v1);
+	sum += sf_2(&v1, &v2);
+	sum += sf_3(&v1, &v2, &v3);
+	sum += sf_4(&v1, &v2, &v3, &v4);
+	sum += sf_5(&v1, &v2, &v3, &v4, &v5);
+	sum += sf_6(&v1, &v2, &v3, &v4, &v5, &v6);
+	sum += sf_7(&v1, &v2, &v3, &v4, &v5, &v6, &v7);
+	sum += sf_8(&v1, &v2, &v3, &v4, &v5, &v6, &v7, &v8);
+
+	/* Value-nested struct tests (on-stack) */
+	sum += stf_1(&t1);
+	sum += stf_2(&t2);
+	sum += stf_3(&t3);
+	sum += stf_4(&t4);
+	sum += stf_5(&t5);
+	sum += stf_6(&t6);
+	sum += stf_7(&t7);
+	/*
+	 * st8 is 1 KiB; keeping it on the stack alongside t1..t7 blows the 2048-byte
+	 * frame limit (-Wframe-larger-than). Build it on the heap (member-wise, so no
+	 * 1 KiB compound-literal temporary lands on the stack either).
+	 */
+	{
+		struct st8 *t8 = kmalloc(sizeof(*t8), GFP_KERNEL);
+
+		if (t8) {
+			t8->field0 = 0x88;
+			t8->field1 = t1;
+			t8->field2 = t2;
+			t8->field3 = t3;
+			t8->field4 = t4;
+			t8->field5 = t5;
+			t8->field6 = t6;
+			t8->field7 = t7;
+			sum += stf_8(t8);
+			kfree(t8);
+		}
+	}
+
+	/* Dynamic allocation: pointer-linked stp8, each node separately alloc'd */
+	sum += run_stp8(t_kmalloc, t_kfree);	/* heap/slab */
+	sum += run_stp8(t_vmalloc, t_vfree);	/* vmalloc address space */
+
+	/* Pointer forwarding: sf_fwd receives pointers and forwards to inner */
+	sum += sf_fwd(&v1, &v2, &v3, &v4);
+
+	/* Struct return value */
+	{
+		struct s4 ret = sf_ret_struct(&v1, &v2);
+
+		sum += ret.a + ret.b + ret.c + ret.d;
+	}
+
+	/* Keep every call above from being optimised away (sum is otherwise dead). */
+	OPTIMIZER_HIDE_VAR(sum);
+	return count;
+}
+
+static const struct file_operations trigger_fops = {
+	.write = trigger_write,
+};
+
+static int __init eight_struct_args_init(void)
+{
+	test_dir = debugfs_create_dir("kcov_dataflow_test", NULL);
+	debugfs_create_file("trigger_struct", 0200, test_dir, NULL,
+			    &trigger_fops);
+	return 0;
+}
+
+static void __exit eight_struct_args_exit(void)
+{
+	debugfs_remove_recursive(test_dir);
+}
+
+module_init(eight_struct_args_init);
+module_exit(eight_struct_args_exit);
diff --git a/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/Makefile b/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/Makefile
new file mode 100644
index 0000000000000..3017a24774051
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := eight_struct_args_rust.o
+KCOV_DATAFLOW_eight_struct_args_rust.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/README.rst b/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/README.rst
new file mode 100644
index 0000000000000..06e8f8070f6c2
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/README.rst
@@ -0,0 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests: eight_struct_args_rust
+===============================================
+
+Rust equivalent of eight_struct_args_c (rsf_*, rstf_*, rstpf_* with
+``#[no_mangle]``), built only with CONFIG_RUST=y. Opted in with
+``KCOV_DATAFLOW_eight_struct_args_rust.o := y``::
+
+  ./test_modules.py -t eight_struct_args_rust
+  ./trigger-view.py eight_struct_args_rust --raw
diff --git a/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/eight_struct_args_rust.rs b/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/eight_struct_args_rust.rs
new file mode 100644
index 0000000000000..e5cc3cb87591e
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_struct_args_rust/eight_struct_args_rust.rs
@@ -0,0 +1,646 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Verify kcov_dataflow captures struct pointer arguments with automatic
+//! field expansion for Rust #[repr(C)] structs.
+//!
+//! Rust equivalent of eight_struct_args_c. Two families are exercised:
+//!   - Flat structs S1..S8 (1-8 u64 members) via rsf_N.
+//!   - Recursively (value) nested structs St1..St8, where StN embeds every
+//!     smaller struct by value:
+//!         St1 = { field0 }
+//!         St2 = { field0, field1: St1 }              // { v, {v} }
+//!         StN = { field0, field1: St1, ..., field(N-1): St(N-1) }
+//!     so St8 is eight levels deep along its St7 chain. Each rstf_N reads its
+//!     own field0 and forwards each nested member's address into rstf_k.
+//!   - Pointer-linked nested structs Stp1..Stp8, where every member is a raw
+//!     pointer to a separately allocated object:
+//!         Stp1 = { field0: *const u64 }
+//!         StpN = { field0: *const u64, field1: *const Stp1, ... }
+//!     The heap (KBox) test builds this tower and follows it via rstpf_N.
+//!
+//! Write to /sys/kernel/debug/kcov_dataflow_test/trigger_struct_rust to invoke.
+
+#![allow(missing_docs)]
+
+use kernel::prelude::*;
+use kernel::alloc::KBox;
+use kernel::c_str;
+
+module !{
+	type:EightStructArgsRust,
+	name: "eight_struct_args_rust",
+	authors: ["kcov-dataflow"],
+	description: "Struct field expansion test for kcov_dataflow (Rust)",
+	license: "GPL",
+}
+#[repr(C)]
+pub struct S1 {
+	pub a : u64
+}
+#[repr(C)]
+pub struct S2 {
+	pub a : u64, pub b : u64
+}
+#[repr(C)]
+pub struct S3 {
+	pub a : u64, pub b : u64, pub c : u64
+}
+#[repr(C)]
+pub struct S4 {
+	pub a : u64, pub b : u64, pub c : u64, pub d : u64
+}
+#[repr(C)]
+pub struct S5 {
+	pub a : u64, pub b : u64, pub c : u64, pub d : u64, pub e : u64
+}
+#[repr(C)]
+pub struct S6 {
+	pub a : u64, pub b : u64, pub c : u64, pub d : u64, pub e : u64,
+		pub f : u64
+}
+#[repr(C)]
+pub struct S7 {
+	pub a : u64, pub b : u64, pub c : u64, pub d : u64, pub e : u64,
+		pub f : u64, pub g : u64
+}
+#[repr(C)]
+pub struct S8 {
+	pub a : u64, pub b : u64, pub c : u64, pub d : u64, pub e : u64,
+		pub f : u64, pub g : u64, pub h : u64
+}
+// Recursively nested: StN = { field0, field1: St1, ..., field(N-1): St(N-1) }.
+// Copy so a smaller value can be embedded into every larger one.
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St1 {
+	pub field0 : u64
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St2 {
+	pub field0 : u64, pub field1 : St1
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St3 {
+	pub field0 : u64, pub field1 : St1, pub field2 : St2
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St4 {
+	pub field0 : u64, pub field1 : St1, pub field2 : St2, pub field3 : St3
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St5 {
+	pub field0 : u64, pub field1 : St1, pub field2 : St2, pub field3 : St3,
+		pub field4 : St4
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St6 {
+	pub field0 : u64, pub field1 : St1, pub field2 : St2, pub field3 : St3,
+		pub field4 : St4, pub field5 : St5
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St7 {
+	pub field0 : u64, pub field1 : St1, pub field2 : St2, pub field3 : St3,
+		pub field4 : St4, pub field5 : St5, pub field6 : St6
+}
+#[repr(C)]
+#[derive(Clone, Copy)]
+pub struct St8 {
+	pub field0 : u64, pub field1 : St1, pub field2 : St2, pub field3 : St3,
+		pub field4 : St4, pub field5 : St5, pub field6 : St6,
+		pub field7 : St7
+}
+// Pointer-linked nested: every member is a raw pointer to a separately
+// allocated object. StpN = { field0: *const u64, field1: *const Stp1, ... }.
+#[repr(C)]
+pub struct Stp1 {
+	pub field0 : *const u64
+}
+#[repr(C)]
+pub struct Stp2 {
+	pub field0 : *const u64, pub field1 : *const Stp1
+}
+#[repr(C)]
+pub struct Stp3 {
+	pub field0 : *const u64, pub field1 : *const Stp1,
+		pub field2 : *const Stp2
+}
+#[repr(C)]
+pub struct Stp4 {
+	pub field0 : *const u64, pub field1 : *const Stp1,
+		pub field2 : *const Stp2, pub field3 : *const Stp3
+}
+#[repr(C)]
+pub struct Stp5 {
+	pub field0 : *const u64, pub field1 : *const Stp1,
+		pub field2 : *const Stp2, pub field3 : *const Stp3,
+		pub field4 : *const Stp4
+}
+#[repr(C)]
+pub struct Stp6 {
+	pub field0 : *const u64, pub field1 : *const Stp1,
+		pub field2 : *const Stp2, pub field3 : *const Stp3,
+		pub field4 : *const Stp4, pub field5 : *const Stp5
+}
+#[repr(C)]
+pub struct Stp7 {
+	pub field0 : *const u64, pub field1 : *const Stp1,
+		pub field2 : *const Stp2, pub field3 : *const Stp3,
+		pub field4 : *const Stp4, pub field5 : *const Stp5,
+		pub field6 : *const Stp6
+}
+#[repr(C)]
+pub struct Stp8 {
+	pub field0 : *const u64, pub field1 : *const Stp1,
+		pub field2 : *const Stp2, pub field3 : *const Stp3,
+		pub field4 : *const Stp4, pub field5 : *const Stp5,
+		pub field6 : *const Stp6, pub field7 : *const Stp7
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_1(a : *const S1) -> u64
+{
+	unsafe
+	{
+		(*a).a
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_2(a : *const S1, b : *const S2) -> u64
+{
+	unsafe
+	{
+		(*a).a + (*b).b
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_4(a : *const S1, b : *const S2, c : *const S3,
+			d : *const S4) -> u64
+{
+	unsafe
+	{
+		(*a).a + (*b).b + (*c).c + (*d).d
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_8(a : *const S1, b : *const S2, c : *const S3,
+			d : *const S4, e : *const S5, f : *const S6,
+			g : *const S7, h : *const S8) -> u64
+{
+	unsafe
+	{
+		(*a).a + (*b).b + (*c).c + (*d).d + (*e).e + (*f).f + (*g).g +
+			(*h).h
+	}
+}
+
+// Recursively nested: each reads its own field0 and forwards every nested
+// member's address into the matching rstf_k, walking the whole tower.
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_1(p : *const St1) -> u64
+{
+	unsafe
+	{
+		(*p).field0
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_2(p : *const St2) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_3(p : *const St3) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1) + rstf_2(&(*p).field2)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_4(p : *const St4) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1) + rstf_2(&(*p).field2) +
+			rstf_3(&(*p).field3)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_5(p : *const St5) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1) + rstf_2(&(*p).field2) +
+			rstf_3(&(*p).field3) + rstf_4(&(*p).field4)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_6(p : *const St6) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1) + rstf_2(&(*p).field2) +
+			rstf_3(&(*p).field3) + rstf_4(&(*p).field4) +
+			rstf_5(&(*p).field5)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_7(p : *const St7) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1) + rstf_2(&(*p).field2) +
+			rstf_3(&(*p).field3) + rstf_4(&(*p).field4) +
+			rstf_5(&(*p).field5) + rstf_6(&(*p).field6)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstf_8(p : *const St8) -> u64
+{
+	unsafe
+	{
+		(*p).field0 + rstf_1(&(*p).field1) + rstf_2(&(*p).field2) +
+			rstf_3(&(*p).field3) + rstf_4(&(*p).field4) +
+			rstf_5(&(*p).field5) + rstf_6(&(*p).field6) +
+			rstf_7(&(*p).field7)
+	}
+}
+
+// Pointer-linked: each dereferences its own *field0 and forwards each
+// (already pointer-typed) nested member into the matching rstpf_k.
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_1(p : *const Stp1) -> u64
+{
+	unsafe
+	{
+		*(*p).field0
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_2(p : *const Stp2) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_3(p : *const Stp3) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1) + rstpf_2((*p).field2)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_4(p : *const Stp4) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1) + rstpf_2((*p).field2) +
+			rstpf_3((*p).field3)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_5(p : *const Stp5) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1) + rstpf_2((*p).field2) +
+			rstpf_3((*p).field3) + rstpf_4((*p).field4)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_6(p : *const Stp6) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1) + rstpf_2((*p).field2) +
+			rstpf_3((*p).field3) + rstpf_4((*p).field4) +
+			rstpf_5((*p).field5)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_7(p : *const Stp7) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1) + rstpf_2((*p).field2) +
+			rstpf_3((*p).field3) + rstpf_4((*p).field4) +
+			rstpf_5((*p).field5) + rstpf_6((*p).field6)
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rstpf_8(p : *const Stp8) -> u64
+{
+	unsafe
+	{
+		*(*p).field0 + rstpf_1((*p).field1) + rstpf_2((*p).field2) +
+			rstpf_3((*p).field3) + rstpf_4((*p).field4) +
+			rstpf_5((*p).field5) + rstpf_6((*p).field6) +
+			rstpf_7((*p).field7)
+	}
+}
+
+// Build the pointer-linked Stp8 tower with KBox (each node its own allocation),
+// run rstpf_8 over it, and return the sum. The KBoxes own the storage and hold
+// raw pointers into their siblings; everything is freed when they drop at the
+// end of this function. `?` frees any already-allocated KBoxes on OOM.
+fn build_and_run_stp8() -> Result<u64>
+{
+	let l1 = KBox::new (0x11u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l2 = KBox::new (0x22u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l3 = KBox::new (0x33u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l4 = KBox::new (0x44u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l5 = KBox::new (0x55u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l6 = KBox::new (0x66u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l7 = KBox::new (0x77u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+	let l8 = KBox::new (0x88u64, kernel::alloc::flags::GFP_KERNEL) ? ;
+
+	let p1 = KBox::new (Stp1{ field0: &*l1 },
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p2 = KBox::new (Stp2{ field0: &*l2, field1: &*p1 },
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p3 = KBox::new (Stp3{ field0: &*l3, field1: &*p1, field2: &*p2 },
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p4 = KBox::new (
+		Stp4{ field0: &*l4, field1: &*p1, field2: &*p2, field3: &*p3 },
+		kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p5 = KBox::new (Stp5{
+		field0: &*l5,
+		field1: &*p1,
+		field2: &*p2,
+		field3: &*p3,
+		field4: &*p4
+	},
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p6 = KBox::new (Stp6{
+		field0: &*l6,
+		field1: &*p1,
+		field2: &*p2,
+		field3: &*p3,
+		field4: &*p4,
+		field5: &*p5
+	},
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p7 = KBox::new (Stp7{
+		field0: &*l7,
+		field1: &*p1,
+		field2: &*p2,
+		field3: &*p3,
+		field4: &*p4,
+		field5: &*p5,
+		field6: &*p6
+	},
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+	let p8 = KBox::new (Stp8{
+		field0: &*l8,
+		field1: &*p1,
+		field2: &*p2,
+		field3: &*p3,
+		field4: &*p4,
+		field5: &*p5,
+		field6: &*p6,
+		field7: &*p7
+	},
+			    kernel::alloc::flags::GFP_KERNEL) ?
+		;
+
+	Ok(rstpf_8(&*p8))
+}
+
+/* Pointer forwarding: receives pointers and passes to inner */
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_fwd_inner(a : *const S1, b : *const S2, c : *const S3,
+				d : *const S4) -> u64
+{
+	unsafe
+	{
+		(*a).a + (*b).b + (*c).c + (*d).d
+	}
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_fwd(a : *const S1, b : *const S2, c : *const S3,
+			  d : *const S4) -> u64{ rsf_fwd_inner(a, b, c, d) }
+
+/* Struct return value */
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rsf_ret_struct(a : *const S1, b : *const S2)
+	->S4
+{
+	unsafe
+	{
+		S4
+		{
+a:
+			(*a).a, b : (*b).a, c : (*b).b, d : (*a).a + (*b).b
+		}
+	}
+}
+
+unsafe extern "C" fn write_handler(_file : *mut kernel::bindings::file,
+				   _buf : *const core::ffi::c_char,
+				   count : usize,
+				   _ppos : *mut kernel::bindings::loff_t, )
+	-> kernel::ffi::c_long
+{
+	let v1 = S1{ a: 0x11 };
+	let v2 = S2{ a: 0x11, b: 0x22 };
+	let v3 = S3{ a: 0x11, b: 0x22, c: 0x33 };
+	let v4 = S4{ a: 0x11, b: 0x22, c: 0x33, d: 0x44 };
+	let v5 = S5{ a: 0x11, b: 0x22, c: 0x33, d: 0x44, e: 0x55 };
+	let v6 = S6{ a: 0x11, b: 0x22, c: 0x33, d: 0x44, e: 0x55, f: 0x66 };
+	let v7 =
+	S7{ a: 0x11, b: 0x22, c: 0x33, d: 0x44, e: 0x55, f: 0x66, g: 0x77 };
+	let v8 = S8{
+		a: 0x11,
+		b: 0x22,
+		c: 0x33,
+		d: 0x44,
+		e: 0x55,
+		f: 0x66,
+		g: 0x77,
+		h: 0x88
+	};
+
+	// Recursively nested values: each embeds all the smaller ones (Copy).
+	let t1 = St1{ field0: 0x11 };
+	let t2 = St2{ field0: 0x22, field1: t1 };
+	let t3 = St3{ field0: 0x33, field1: t1, field2: t2 };
+	let t4 = St4{ field0: 0x44, field1: t1, field2: t2, field3: t3 };
+	let t5 =
+	St5{ field0: 0x55, field1: t1, field2: t2, field3: t3, field4: t4 };
+	let t6 = St6{
+		field0: 0x66,
+		field1: t1,
+		field2: t2,
+		field3: t3,
+		field4: t4,
+		field5: t5
+	};
+	let t7 = St7{
+		field0: 0x77,
+		field1: t1,
+		field2: t2,
+		field3: t3,
+		field4: t4,
+		field5: t5,
+		field6: t6
+	};
+	let t8 = St8{
+		field0: 0x88,
+		field1: t1,
+		field2: t2,
+		field3: t3,
+		field4: t4,
+		field5: t5,
+		field6: t6,
+		field7: t7
+	};
+
+	let mut sum : u64 = 0;
+	sum = sum.wrapping_add(rsf_1(&v1 as *const S1));
+	sum = sum.wrapping_add(rsf_2(&v1 as *const S1, &v2 as *const S2));
+	sum = sum.wrapping_add(rsf_4(&v1 as *const S1, &v2 as *const S2,
+				     &v3 as *const S3, &v4 as *const S4));
+	sum = sum.wrapping_add(rsf_8(&v1 as *const S1, &v2 as *const S2,
+				     &v3 as *const S3, &v4 as *const S4,
+				     &v5 as *const S5, &v6 as *const S6,
+				     &v7 as *const S7, &v8 as *const S8));
+
+	// Recursively nested struct tests
+	sum = sum.wrapping_add(rstf_1(&t1 as *const St1));
+	sum = sum.wrapping_add(rstf_2(&t2 as *const St2));
+	sum = sum.wrapping_add(rstf_3(&t3 as *const St3));
+	sum = sum.wrapping_add(rstf_4(&t4 as *const St4));
+	sum = sum.wrapping_add(rstf_5(&t5 as *const St5));
+	sum = sum.wrapping_add(rstf_6(&t6 as *const St6));
+	sum = sum.wrapping_add(rstf_7(&t7 as *const St7));
+	sum = sum.wrapping_add(rstf_8(&t8 as *const St8));
+
+	// Pointer forwarding: rsf_fwd receives and passes to rsf_fwd_inner
+	sum = sum.wrapping_add(rsf_fwd(&v1 as *const S1, &v2 as *const S2,
+				       &v3 as *const S3, &v4 as *const S4));
+
+	// Struct return value
+	let ret = rsf_ret_struct(&v1 as *const S1, &v2 as *const S2);
+	sum = sum.wrapping_add(ret.a + ret.b + ret.c + ret.d);
+
+	// Dynamic allocation: pointer-linked Stp8 tower (each node its own KBox)
+	if let
+		Ok(s) = build_and_run_stp8()
+		{
+			sum = sum.wrapping_add(s);
+		}
+
+	core::hint::black_box(sum);
+	count as kernel::ffi::c_long
+}
+
+#[repr(transparent)]
+struct SyncFops(kernel::bindings::file_operations);
+unsafe impl Sync for SyncFops
+{
+}
+
+static FOPS : SyncFops = SyncFops(kernel::bindings::file_operations{
+	write: Some(unsafe{ core::mem::transmute(write_handler as *const()) }),
+	..unsafe{ core::mem::zeroed() }
+});
+
+struct EightStructArgsRust {
+	dir : *mut kernel::bindings::dentry,
+}
+
+impl kernel::Module for EightStructArgsRust
+{
+    fn init(_module: &'static ThisModule) -> Result<Self> {
+        let dir = unsafe {
+            kernel::bindings::debugfs_create_dir(
+                c_str!("kcov_dataflow_test").as_char_ptr(),
+                core::ptr::null_mut(),
+            )
+        };
+        unsafe {
+            kernel::bindings::debugfs_create_file_unsafe(
+                c_str!("trigger_struct_rust").as_char_ptr(),
+                0o222,
+                dir,
+                core::ptr::null_mut(),
+                &FOPS.0,
+            )
+        };
+        Ok(Self { dir })
+}
+}
+
+impl Drop for EightStructArgsRust
+{
+	fn drop(&mut self)
+	{
+		unsafe{ kernel::bindings::debugfs_remove(self.dir) };
+	}
+}
+
+unsafe impl Send for EightStructArgsRust
+{
+}
+unsafe impl Sync for EightStructArgsRust
+{
+}

-- 
2.47.3


