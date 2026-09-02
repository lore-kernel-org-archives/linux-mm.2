Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45582C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF196B00B7; Wed,  2 Sep 2026 12:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038F16B00B8; Wed,  2 Sep 2026 12:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4C66B00B9; Wed,  2 Sep 2026 12:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF99A6B00B7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4875E402AE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:21 +0000 (UTC)
X-FDA: 85169359842.03.EDD4F41
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3E79A40008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=hXTRif4K;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXPi82nr2yLY3T2FmPVS7N6Yv3R9jk5gRRmuF+2bOA0=;
	b=tp8UOH0lLjtN6COGR/R7+v+twTIKLVb93JnGbr5GMzPH5p1mv3s9AcQlB5fL8MBawsbGLH
	l5gOC3VMYNhPIPixT1iJHgT6Vdj/c6ojfxQiB36J8jnMH7l6AAEASzVCskP2VXle/y0Sj2
	hOP529RA6we0NkX8twmJcUhDWSKvLxc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366618;
	b=FTn+3MaQyaAKW7uEah9aFqileCSKI6k5PMjZ0c6p07DPK1DLECTxGyA8KKdDljv5toTaYl
	rOJLTsfsQpvcn7vCp87AO2fqYGGDMG2eD4EgX7aZkHBwT1EhafIqutXCzvU2SGAlfhq9Ve
	i3s/dHreUkmEdQ9PJnZ/83SkGVERx4A=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=hXTRif4K;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4WMNhn+YNhA69epyzMv7LYHVZQzBCPhT3NLEkwfONUZp5D1U9MfMIxgxjF17wNowj+On4UfFF53SN7rhXrjEhCAyD9cCLbRqudPb2r07Mb/E1mdlHcQMzpe27QmZlQciAuUU54a544HInvxlJ4fd2uWU+FcImuCAXR6sbv7OEfajcR0bPP1RBYes1DP7A2ay3yjSGLv3zWKg1N9LZYe+6/II4JpRi3czB7iS19y5tfhXG04h5MtNRGDs6WbuA9WyaJldNoK6V6D83JH2cZiYsW3y4JcLVMsTgJZR14OQIoU8ufvu32uWg3Zb9t0VLv7nsQg4maXWFfhwOVGQsmxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXPi82nr2yLY3T2FmPVS7N6Yv3R9jk5gRRmuF+2bOA0=;
 b=AWJASv2nEye5v9ENFUp1Zv7LKowLE0yqYLPfokPZNhI2SXAN1knJvFqc5mG2wD/ILWgyXsX6Sy4EUKeCbS1hlh+IF2jOaJUKELBiM9P+qgj7YYNJRDHOJVPUYc8W0cAWbPuSCQbV3qchR6AH/+p/uKh+rufUmnMwBOl7gYlObpMmQ3Te7mIq9mpNPSyo0hKo53KMrNP0D/4VfAJPmURXSl3nn/OcvXdDCNTfEq+8pJSYCsPNfLdYXaAXIpzTxYAguBcKYi+CJe6uQLuqTR7zBHp07NWZ0MhQBZWMVFYs1YBJaobTGDy1DKASW/ScSKxKf0eDXPtDpX+y9KHDEjkCcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXPi82nr2yLY3T2FmPVS7N6Yv3R9jk5gRRmuF+2bOA0=;
 b=hXTRif4KWK7EfaWM4JXDU+h7XYsfmYl5VM44Y9WV2oyDzG0nsWb8fWVdJVaaCKiPWUpSH9Sa/0DlQtWG1V1HzYZ065ibihbyKnydkQGVO4GYOi7mSqPlzsAtC8CJm+B+Sk6+0VnQed5eHTpAJhcxMZv9dJhsDsDDMgMvuVkoizwqPczjCZ+RWvn3EsvHTKjH+wiH+EwSsS+JXB8weF8F5tYRA6VNsZz69wjq4eW6IZMkXR9qnlu7bYLECqcukG5PlAR9uFvuLaFn1paDMkJ1Xa8NtVN0mebu01AHr3kPhy+/l22LojTtKlTVxnt8XJROnfxPf83Z8nydi0PIReK9tw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by BESP189MB3209.EURP189.PROD.OUTLOOK.COM (2603:10a6:b10:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Wed, 2 Sep
 2026 16:30:03 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:30:03 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:37 +0200
Subject: [PATCH RFC v3 4/8] selftests/kcov_dataflow: add rust_ffi_contract
 selftest
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-4-824609f279f5@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=6816;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=D3cMHWxRsXdvSEEkZd7uF/ht64WvuUdr+I0lDJI1zgU=;
 b=i9RFAAfwLU92uBufQxOpA3ZiXZUblob6soak2xdLoqME4qNbdhWA5660Igb81g8NCSTRBEG9w
 yq1q5XLR6f0BWS7SZ4LkGJA/eq5EoXl2S4LcDBOS1gh7EzNsCBZjciK
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: CWXP123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:238::10) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|BESP189MB3209:EE_
X-MS-Office365-Filtering-Correlation-Id: d6cb4f93-c371-47e5-59ac-08df090f7123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|22082099003|18002099003|11063799006|5023799004|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	f6BKUx7r4kWgr7PMsiXEiCAhSikR9DMWsHnv2zhXLPCtgga96Lzkw9r89kAn+9OcGKq4UIy6JKv1VH1427WUI8Mib/IKu1/scu+1KRjA6v/aITZzqKMcLXrkO77jsZyBsB5VYrZ7dz1N0Z1Oq0z+aVRmqCX1JRUDd2VwxHy6HvPrUIeZ25AB1+VsYP6qQhtutDV3H9qZODb9NI6R0i3zUyz8K6PNgyiMhRbhLXLJG/Kk7hRgfXioPYAqE0B+EL2K/Srr/7crsaf1qXAM+z0OzkI+NQdKUDHChF2TBT2FqATANRZ8kCydD4rUGjOmgH9KlljRQ2UMA9JQSnmyJn9xXkyL2NSZJ3ixUd27ofdsc81i6FmCEyt+WuocArh46Snt108EvRM8IWcnsuGOvmJZo0JkzG39JcHFjGtdR11cRQQHR+LnCJcgRKpRR7j65XdK2tLH5Bwu7tJdqS2CfIpXzRvtMq1SptGgJCC/jEvF4RNp+9XlMXGWxptwbswY2fSRddYxxUq4mpRwzRzwyOO9N9Tnot10wxBGd9ijTSXagzNwQxQ66FcXzCcbuDh/DUsU+OdesbwuE+8Ah63ba0sDlsAQ5heMPuCUE6FULdq2klsKDc91oZbBSVGdc9fWgnEGnx7QVQtTxq7DS7+N83YkSzcEHoW58jx0em0FD4FRy6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(11063799006)(5023799004)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDd0Z0R5YVRqYXM1SnJQWnZZWWlVREFNTndkemFYYVFMNE9nRUpTTS9iZ0NK?=
 =?utf-8?B?TWRvZytIN3NrcjltSnJHcW5mYXc5ZWJjRmxyQjNXM3dhcGhyU09rK01Kb09a?=
 =?utf-8?B?VkFKUHNFbVNBYnBzOGwrTkJjL3Y3UFlFQXFrcEJ6QUE5ekxuZjVheFBKSUkr?=
 =?utf-8?B?UWVmN2tIY3o3VjJvSWFpNjJKUUJ3MGtyNVpSbVp2U1dsWHFsSFRQL2hxOEtF?=
 =?utf-8?B?ZWhtdHV1Rk1WL1ZIN0FXMzRlM2JxNTZXWlVYS0MxT05iOXBLdzBSRmRzVHJj?=
 =?utf-8?B?QnJVNENnRUhNbkpTWWxibkFCNnNCaXdSTmJIWm0yTlBrTllyYlI5T0Vnd20w?=
 =?utf-8?B?WThaU3ZuWXVLdURrS1V5bHRBY0ZwRHZPY2pwcDBCZEtLck1CVHd4K1J0dUps?=
 =?utf-8?B?Sm92dkpJNC9aTnVjRURqSDgySzZ6UlZ0MkhjSEI2NHA0TW9XOTlxYW9rZG9h?=
 =?utf-8?B?OXFucmI1MVYvUDRWSU54RE5MT1JTdGMrU0pyR2lGNDMxNmlRSVNKVXhnbmZq?=
 =?utf-8?B?M1Jlek50bzhaOSs0cThDbkQyQWJNbGJuSG5Iay9Ld1FQWWlIQXliZmRmcVBV?=
 =?utf-8?B?clJqTFM1S3pPNkUrWE5ROEJSR1N2aElQbERBekQ5NStMdEN0Vm5WSFZUS3FJ?=
 =?utf-8?B?QVB6YUxRVHZXbE13aTVrSzdQdDkxeGFseXRVUUxHQURsWnpUZ3pWUWFwSFha?=
 =?utf-8?B?enlRRHZlRlZNdER6NFZyNHoydEVoSHZkZ1lwYXI5V1RtV0ZlYldxYUg4SzVj?=
 =?utf-8?B?a0FOWlhyL1BwSHorL1pLaVlMK01YWnFJZjVaNGkrVG90RFpjVENVMHVmWUI0?=
 =?utf-8?B?Nk1wdjJqczBjZXVJYnI0SUtuNkx0Z3cvZVc4azVSMXdBbmV2TzdUVXlpUFcr?=
 =?utf-8?B?OEFUY2VhVnNQcVFMcXFSckc3RU5XNytseFppcTY1V0tkMStHT3BPdFFPVVVx?=
 =?utf-8?B?K1FrbU1FaFZRQlZyS1pqTDUyNC9KR000YjNHV1FjQXJhdzIrdlM0cHFGbmhn?=
 =?utf-8?B?Z1RLWldqRGg0QXJWNGJlQU9SV21FTDE4V241SHErVVM0OXp5WkRhT3BNaUpJ?=
 =?utf-8?B?eG5GS3ZaZzNRMHdlVTkzd1Ura0Y0NFpQbDkydDRYd2tIVzZUVkxRcGhLVWho?=
 =?utf-8?B?UWYzTGpyWjFBTURVSTJ4ZjlTWjFkQkI5d2w5eFh6NmZ0RWNGb0JGNnBQNjA0?=
 =?utf-8?B?TXpVZytEZEEvaGdJT3F0QjdhOUJyUEhKSzgrOXF1SmV6RzZoeTlyQmovek5B?=
 =?utf-8?B?T3puVGkwNkV1TlZaTG9rVTA3cmx3RkpSOVBTUnY5WHhCKy80amdKcHpGOHpa?=
 =?utf-8?B?QlJ1a05JTzdKT09iU0xrL1ROOEF4OVlpRVZWS0NCREErRngvSUJaSk9LN2FV?=
 =?utf-8?B?UTFjVVMwYitveEgwcmYrVnBwMXF0ZE5lQUxtYXNTdCtpcXJjdDhQeVBLenRl?=
 =?utf-8?B?VjZ0YUkzajlDV0pJQm1TZFpuYkZVZjdMKy9MNUxSS0tUOC9XcjBrWDZ4STlP?=
 =?utf-8?B?bG9zUHRQZ2paaDczTkN4dTY0dmVzb25ZbG16WmNKamNCOFhLd0tDblVwbXRv?=
 =?utf-8?B?K0dDYklQejdROUs4MWxBQU91enNYdEYrSFBPWlhZT3V1eEdGeWNTdHo3VTlv?=
 =?utf-8?B?KzdGZzcrOUJpMmV0TG1kMjRRa29qYnVLajBQYjhrd1MrZ2VoR2hZTldHdmUy?=
 =?utf-8?B?aWpXMjdvOXdEcFNnSEMvMmgvaVB2N1haTitTdWtqaTZ5U1FtMC9qKzZWUUE4?=
 =?utf-8?B?QlFXeGdUaTczNVlDYUZQQkdWakpxT1RWemlQSkF4Y0pGSUZQMENBRUdEOXpx?=
 =?utf-8?B?aWpEVHB0dkxDRW9LN1h4Qzl5Z1dDUlVUbFhDTUdkVTJxSjVkdkR1Sk5jUHVG?=
 =?utf-8?B?eVVhS3R5UytsbGV0TForeTYrTkk0ekp5KzRSMXFBUTA4d1VHUUJiVkNoNzBN?=
 =?utf-8?B?Smdwb1ovbjViRTNPOXk4RVJiRDc2VUpaUGpPSE5IajVLVld0c0x1R1RlTHZn?=
 =?utf-8?B?MkhjcFRkWXh0WVJUdVVJSnowTzZITFJjNW43a1U0QlpNbmNwb0FJaUlnZjRi?=
 =?utf-8?B?UWMybmdqbURsZ1lBc1FPbzltTzBEVnRWb0l0U2ptRWdHYk52bmhTZEUxSllh?=
 =?utf-8?B?N3hqR2o4QktoSWgrb2xGQm16S3FSVERMYzJTdnROOXFkUEs0Sld3anZzZTAw?=
 =?utf-8?B?TXgzUmtYNWlCdFN6bCtDaFVucGxtejZrbnp3c3RjSEZJeXhrMVBxWW9DRm9M?=
 =?utf-8?B?QUtwUmpHNHFmbnpudml1TFNrOXo4SnFvUk8ybGRuVE52S0dKMDdTWlIrZEE0?=
 =?utf-8?B?Wm45QllvU2FETnFybkdDZVpENW4yUldiUTBCZzdvWW5YbjYvZVlGUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cb4f93-c371-47e5-59ac-08df090f7123
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:30:03.8388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjMiU49qfzI2973JP2tdBr4J3ZH/INRTQk8GWQac6CO3ATDfHRXvJGTc4+C6xz7VRcDkX0YL2tKYGA1YXQ/0ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESP189MB3209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E79A40008
X-Stat-Signature: 769cajxzgaw896krtyy3o594r49q5b1f
X-HE-Tag: 1788366618-677701
X-HE-Meta: U2FsdGVkX1/PSjXAsNxd38pdfLsAr0mcSZReLwurxViNh9/LXs29UemdVDUqMEDbwyf7kcC8vAhp8JXqgIIhRsXQcQ71EknMktfSYu6wMqjBrW8ROpBW6JRUZTcx5aDTJmw3593T6e9R5OPpGJJNiaGkP9MgDPnRkFPiFL0AEL4TCqwNYKZtlCY+DHFWTdc/gr/LDzmsjCkNjTprRgatbC3/fh1tyVPaFpel9cuKi/iD1kUl6+EIvuF7SfjxgwNH7Ll3UdQJbEeIFny6S8u7WQXuVjMUIyUNpa5lIsNsehpv9tBTycmu+pLV/ApUACM0RJBiOcragr0yMaNCcB1a96XumMaihbOgWl832CtBdH6xMUeY5XqtRFK+CcCQB8nQ0cQ1MUq5i8XlTvSN14LMwB84y0UzP8NLtiWLO2ZRKZEhzAuggRSgXXUbRWVZ7K3rcLCsRHlNj77opBdgL/SP8cWoNnyt9CEI1BQlEGfro9Jl/iGCvV5Sx/WmA/AX5gCOLRphpY5jWTqjsqfY3GiNC3Qlismzqq5+5wVYUY9wgJO6p1IZjnDfYxZEl/FhG9sU7l83c/ea97wvotsQwwMASH5h6yCPuqfV2IC9flbAmioHxSnOkPl4p/qsNJ9UXkATQog7Q/rPo/HwMKvgAbhDIIuc3rCjvFhymtysAzlPESXiLga7YwazDPGS2j7qEqC207k+UzBdW3zgMnGc2sNLmSJh3N5pO/EpuZL7CcOJJujZ8pnC4s+MeJLcCGLxaz4Qvt0BoVdzeI0Hp7KkRnE+yR2DBZvQKGcIGs1+Quru9939qJ1c+1mcSBtcJlu+3BRGpIWJf7FN7jxTPmrfYnjeL0xXihV7USeitHnSusrcud2tFpXQaxo0QK9e494zAOuO/latOZ7pHam0LKf97qIJMBZlQYbLyq9gdadFH8mSD7nSXArHR1hRffOxVFaOEbrpGLu3XCtEurvyWjJjMQz
 0a+YxDmp
 VIzeWlyID+cN6YO1tCBLYnyLR//Tv+yN5Rcxb/AmRcaMVqoBaxNSRUwLq7iuYAoS4DnIDhsaHBmH1TDjviOjt0OlCgugCqjvSrFR8HD5FPMaBPS4H1/Bjb6997qp1pqPOcstKQqp8wT2tVMMrEhYBldaKh5O1+CTfN/AMR+VJgaCFYkSpFulk9WRADdYVrUdutOdyzZPRxLeKa3CeiWy7HF7tMHRhdyDjBVCtqzNlEhJJYILRT396glcZwW9o2kjWQBXY9k55YHR1E+37+yEdmK6wXbL+s+1ne9C7SksJY8YzP+OrA7wlnnvoGXCzEg2rrqzqRLUQXnXIOI3tPh2oWU/uT4GUiFF/BltHFf9eRlwMrdGiTNylI6UcUKRocx/4FKxaKjfE2IFwsXsQeDpGim2Befm+A8JYR547TfAHCHmsL9V5zHs+bu/ILP61EFM6kKL6QNmweXclxNOi4+PHkDU80xt5Kn3cweIq8NLuZxwmLTrHmo2IeZwHSmDH8b580PkZDmYK3LaPQ34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test module that shows kcov_dataflow detecting a function-boundary
contract violation that leaves no crash and no KASAN report.

ffi_alloc_buf() has the postcondition "returns 0 implies out->buffer is
valid", but its async path with an empty pool returns 0 while leaving
out->buffer == NULL. The caller, ffi_check_result(), trusts the contract
and dereferences the buffer. Because kcov_dataflow captures the struct
fields at both boundaries, the violation is visible in the record stream:

  0x0 = ffi_alloc_buf({0x0, 0x0, 0x0, 0x0}, 0x100, 0x10, 0x1)
  0xfffffff2 = ffi_check_result({0x0, 0x110, 0x0, 0x0})
                                 ^ buffer still NULL after a 0 return

The module is opted into instrumentation with
KCOV_DATAFLOW_rust_ffi_contract.o := y and driven through a debugfs
trigger file; kselftest script will check the expanded struct at each
boundary, the scalar arguments (256, 16, 1) and the two return values.

Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 .../kcov_dataflow/rust_ffi_contract/Makefile       |   3 +
 .../kcov_dataflow/rust_ffi_contract/README.rst     |  13 +++
 .../rust_ffi_contract/rust_ffi_contract.c          | 125 +++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/Makefile b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/Makefile
new file mode 100644
index 0000000000000..d2a0261070b1c
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := rust_ffi_contract.o
+KCOV_DATAFLOW_rust_ffi_contract.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/README.rst b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/README.rst
new file mode 100644
index 0000000000000..291621fa799cd
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/README.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests: rust_ffi_contract
+==========================================
+
+FFI contract violation detection: ffi_alloc_buf() returns 0 but leaves
+alloc->buffer NULL, and ffi_check_result() receives that NULL. The test
+checks the expanded ``struct ffi_alloc`` at both boundaries, the scalar
+arguments (256, 16, 1), the 0 return and the -EFAULT from the checker.
+Opted in with ``KCOV_DATAFLOW_rust_ffi_contract.o := y``::
+
+  ./test_modules.py -t rust_ffi_contract
+  ./trigger-view.py rust_ffi_contract -C 8
diff --git a/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.c b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.c
new file mode 100644
index 0000000000000..071bd25dfec11
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/rust_ffi_contract/rust_ffi_contract.c
@@ -0,0 +1,125 @@
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
+ *   [ENTRY] ffi_check_result(alloc={.buffer=NULL, .data_size=0x110, ...})
+ *                             ^ proves contract violated
+ *   [RET]   ffi_check_result() = -EFAULT
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
+	/*
+	 * data_size + offsets_size is used on every path so that the compiler
+	 * keeps offsets_size alive (an unused parameter is dropped at -O2 and
+	 * callers then pass poison, leaving nothing to trace).
+	 */
+	if (!is_async) {
+		alloc->buffer = kmalloc(data_size + offsets_size, GFP_KERNEL);
+		if (!alloc->buffer)
+			return -ENOMEM;
+		return 0;
+	}
+	/* BUG: returns success but buffer is NULL when pool empty */
+	if (alloc->free_async == 0) {
+		alloc->buffer = NULL;
+		alloc->data_size = data_size + offsets_size;
+		return 0; /* contract violation */
+	}
+	alloc->buffer = kmalloc(data_size + offsets_size, GFP_KERNEL);
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
+	/*
+	 * Keep the initializer: the callee provably writes alloc->buffer before
+	 * reading it, so without the barrier the compiler drops the NULL store
+	 * and the ENTRY record would show stack garbage instead of NULL.
+	 */
+	barrier_data(&alloc);
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
2.47.3


