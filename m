Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5772CCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96E26B009B; Thu, 11 Jun 2026 12:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47A16B009D; Thu, 11 Jun 2026 12:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36926B009E; Thu, 11 Jun 2026 12:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9323C6B009B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13311C27FF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:59 +0000 (UTC)
X-FDA: 84868148358.01.410FDA8
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2184440002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=nsOPupXe;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DcjJJICF13QlleMB9TTboTYw5ZFMT80D83okJYoZLs=;
	b=jiogtMrB7PM8NlG2qXHEsPtItEJvmaK1/9wsiuNq+LcTeK+ybcbkRXVqzjyVBDzJRoqA50
	aoZuueXpXDEtAKQtM0A4bYYDcAfKuyDfb+OLrJbdU7y518AKOpOYF0sOcq7EuID03RmqaI
	ok+0DuEXJkT2RjB7vpTb44EG7NafGO8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=nsOPupXe;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194916;
	b=j4CmcA/XLjYVssISepH5eGLZ+SB8YAMKNi4C2ssP75dhlwS7l5GU0ApPu53C1H2oTwSzW2
	53RvP+DgSpGHaqBfBPZQlv8TFOnGJAD+3Jc9oRjFe8iKUAhof1ojlvTWoTn8+J0rZiWcBy
	fszOgq+4JrTok8jA0slc/Qm7uWdkL9Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gYBjQyQULH5EJxNnaLfjmnG7Wyd+CgLzOscxHUaydvmYmFof6g4ZYyQYwqMQ1QDPq3lxlbdguaDzny734QwqKDkqyyOH+yUKHmimlyV9iW5FgInSpkmVvXvmUF4/CVnbMm5F0v6RgNiIGypjSLezGXeOKBzmmf6acQV+2JxtMXct1j1/XDRCAyf3aDA5OUkHOpGd+E7IYp+b1qURa8PNgPtLQC/X7yqw1YZmQB4ucnsBPpnORrvCRyDfwgqBGUmPiMDRgYtOpGNiQaplBwGhw/fCLEtQ+Z5Re8UVJAwtJOxiGxPB7zt9+Le1HjU9VwrrSsFWR7D1sGrbLX1mr018Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DcjJJICF13QlleMB9TTboTYw5ZFMT80D83okJYoZLs=;
 b=kFYb+kHzaUaEqpHP6zpJHS4sxm3Pw6nKgg+bE9mIriokQ38AMUnWyhdkDltLnoLWrEPUM7UQiRkLf1+5DVGXBJkafMflOVE9ML097QWpRlNkazXMnPZKSO16glfNMTPVgALZWizFS9gEsPKLIwoqlTNH/PQwA0r6Kv/gf8rb/OL04N7xhdF6hV8MjzLAsOn/C1JEyGBZATtwZcB40Daf9fe7QA0ABZOssEYDWRkCZioMySLDRe16ROcUBmkIoEB8oGfAB8pmZ+N37YdDSUlmal8WbloHCucfVKDtqyb45br4NUHSsvM74Y3feoDBD5NNBl79SobbHz8y30r2+cEpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DcjJJICF13QlleMB9TTboTYw5ZFMT80D83okJYoZLs=;
 b=nsOPupXei2Hk5j6qn8kEP8rfLFDmGV+l6TgJcRl6Ek3HIjwEvGnZUnyY68IFSBShdeO1z6j3qUU6cFIhycncb2iJAKiD/OwJ1D0kIh4ZSQtg646e6tSR1NjINlNqeTObHdbOycorWr8rET7AlQ70iXhfl50TyJq7uv/JuvqJVfbiFYrEvFf3RyBr9kQAwD57AQXRjPv0SZ9TBsDyXHVI0Q05QGCrn+SIPpWh3DvusUTOH4pn8qfloy/JFWhHUs2DLU+nXc/rGM2DQPVo1f0dod0cJzCAkqx64qwr0LCxkvgbcCXrK3sMe1bHffydchV8T+UPPkoftqvjiLG0EpdCGA==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:45 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:45 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:06 +0200
Subject: [RFC PATCH v2 04/14] kcov: reject enable on multiple dataflow fds
 simultaneously
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-4-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=1107;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=XSHe8vY0Ve68XUnibvBYYD9uBYIxECRAW5jYSSDgvdw=;
 b=7BuxcA5kqODHyzk3q5zvlCtXW91Hq/pjdzu81lfJJN13nx58HmFJUwAGdHkzePXC9VfuG8hor
 TlGiJCiWaa8BC5RBIFRJDJHuB/FRov1gQVKNzCLufEgQiZk3OtUFOjb
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GVX0EPF0005F6AB.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::289) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: 8db0e22e-c732-49de-e0d7-08dec7d587e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TinHYOQ6URFbQXH/jiT+fGZYJtTACA/zt6ktbg8m0aD+EY2pjlHx8biZl+GjeTjTRBjTr0+GMb892944Z8WfS8IwAHDUM95LF0TDp+rcdWXj7FBZUhDeY3KudASG9VDpNnm2oEzgLu9ZpofhSc4Przh4FSXM+5dSXuVo//jxxyTjGmniDoRCRZvLi8RF5WvQmdP6g+j/lY8IhCOxEshSyi4hEAmWOIKDEuqXjO8RWyx4yOCwu2VjkjXmYDIyRNaaYCP9PtlTti5C626yk2WNuIP6mmvqmOsIB1GfYGIrFuVelyFR6DOukzwn6eofx19iayESkPyOKQEnB/DD4514i/FGQwIEL9NmwbgmTFXGTFmC+5kuYGgsbyPEqIIZSB20RII8TtzrlDILs5OJMR/xjvMDXsYWzJapauqRVSLmxBZLWb+KJwgapfJKdfFUwuVM5HzWF6lbpXkBMMKsAVSibvWfZJq7lbA6nyVvUi6T8w+DJCF5g/A99swbN9ukldH+uAVV82NJtdqKWKH+OsmArFQMZOb0QbEaDbEqIxqUWamhzVav/iKQNNv6hv5gOnBYgyJN6SNT4X13LLD8xFUVDr3zaH7H/I28inGeHbzqm2IT5JW+rZvrwnXS0KPEy57e/gZxIypsZ/22cfPx1pMofhYGy5CeaAFu4/25vvMM25IYgDQ8Xk53wjBmQkpMTUVp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um9rSFI4WFgrTkxRZWNlYlRiN0ZkUWowOGFkQkUxMm93MHE5MTZ0WmN6VGlr?=
 =?utf-8?B?elk0MCtQdmZtMmg4RE1DVTI5WStacjFVWHFNdTR4YTArVW8vVC8vckRNdXg1?=
 =?utf-8?B?aTF6YlR0NmhHUDZXUU5ZVXpwOFlONng4bzNqNC9KRW16dTdMMzhoTkUzS0da?=
 =?utf-8?B?RHpUSUFRb09CQStpL0EyaXFjS2NPdlBzUGY3RDNjZVhnZGJWTFM2NW5raGxy?=
 =?utf-8?B?Ni94QnhsdHM2Qm5hS0tQUFFuSFdQVmNoZ1d2TVRnT01HWjJ1Y1BqdG1sM3Bs?=
 =?utf-8?B?OUlKaDQ0bUIvNDVRZzVHOVBzand4cXlRbDRzU005Q1pSWGpDZkhudEp6N2t4?=
 =?utf-8?B?TnlUOEJWb3I4WEZyZVcwM1gyNG1UMCtyQzdDQ0xZaGhscEJpWmo3ME8wWldR?=
 =?utf-8?B?VmJoZzM5U2ZKc2lOUVZzODZmcDdUU0g4ViswSUdmelFBUVNDazE2K0p4anVY?=
 =?utf-8?B?bWhqZHA5YXc5c3ZYUzVTU3ZDM2dsNFNSTTgvTjJrVHNDekVjcldwbGNISW1C?=
 =?utf-8?B?UDhneHc4dWlXcTBxc3A0L2tja0Z5bnNiemE5WnhEV21Lc0FTS0dCQ2gvN3ZE?=
 =?utf-8?B?bmNpNjNuVlpkVjN1RjNFVnJkQW1jaUZXNG5uNVp5V3BDVldGanFWaG10WTJL?=
 =?utf-8?B?eXpoTHNmWFdiblVoMlhjTmlORUtqK3ByYTdXaWlkY3pRTVB2UVZid2lKU2ZP?=
 =?utf-8?B?Nys3T2F5Y3p3ODU3MCt6MmsyOFVxK2ZyTEUyM2tjVGFzRTUxMnNtVVR6VHN1?=
 =?utf-8?B?YjQ5YWVFcHlxYXlJRWgrT3d0b3VCdEd2blEwMDB3eTRxYWIwaXk3OXk3QUpk?=
 =?utf-8?B?a0c4QVZFRXMzN0QydnhxQksveGFlYzJOYXVsL1g5UWJlUFZGUXNYcFZ2QkFR?=
 =?utf-8?B?TUkyN05EaFd0MWYyTUw3Ylh3MXFTaVFiOGs3UWlET0s1R3lRUWZoMzZhMWhK?=
 =?utf-8?B?cDVlelBDc3FQYVhMakVJbXh2dDFUVzlMblFzTm5uSVI0MTdpTkg1Rzd4U2VV?=
 =?utf-8?B?UFJQbTdHZnd0b2R2eVM5QU13N2RlbElHSFFyOTVSNWREenhxWHB5NkljRXh4?=
 =?utf-8?B?cnhIZlRtR1Q4aFFQeWg3ZGZDVmJtYVBFMVJLVTdBS0tnSjBvTnN1citINXlD?=
 =?utf-8?B?VXlFK29oVitBK2RuTkJIbDNwZ1hKZXY5WTBOWUw0VkczZEcrZEtyV0FGaGRa?=
 =?utf-8?B?aUVwbk45SjdvL0xJUkJaQVhTbmRlbWNleHNQRWtuTGg1ZG9CblNlMWV3SWpn?=
 =?utf-8?B?dkhXcStneFBPUWs3UHlPMGVWdUYzeXZFS0xFMWRHTEQwQ0RLVjZyWTh2SmVU?=
 =?utf-8?B?dkg1OGR6YkcxWDFHYXJLb2FUYVd6THBlUlo2Nzl3R2lnY0FOK21PY3FUNmkz?=
 =?utf-8?B?YnpqQkM3WHZiVm9oenR2SFlLbmRUTFlqdm1QYkJqK0xsUHc5dlVjTUtOQjBP?=
 =?utf-8?B?ei9vOUs1eDZuK3k4bjl0b0dMNlZmL3Q4L243NVVWNmE4Z1FzeXNpa01hOFhD?=
 =?utf-8?B?Wk4rZHZGbFpYMmVDTW9iYmx0ZFI2RFFlZUZyNHk4YnZrcEVYWk5sQVBYdlY3?=
 =?utf-8?B?OTNMTzE0c1p2UlBCMTNxRU1BVE9IaVkwMXIvRFl4dks1UVIwQTBva3l1WVlJ?=
 =?utf-8?B?U2YrMnNMQi9WRm1RbkVtMm55U3NlRkRiVXV4MnFUcXVSVmJpemtMUk1ocEhV?=
 =?utf-8?B?M1I2d2tib1dHQWlLa2VNK0FWT0toZFBTbExsVG1QcFAvMkdTcFJkU0gyRUxQ?=
 =?utf-8?B?ODRUdStpdWRvQ0szeXkxek1PbFZFUTBEUDlyZDJIS2RvaEhIZ29Bc24xSUoz?=
 =?utf-8?B?TEhoVFRYUWtoOHp4ZmFwbDZjQnpWSjFvZmN4azBkQWFLME1Zb3MvTW9BQVRH?=
 =?utf-8?B?MEtWVlRlQVRGWDhrcm4zbG5IWWthTDhmanFZaWJ0c1VHMTE0ZkNrSHFTb2Y0?=
 =?utf-8?B?QU56dW5OZEU4czc2bm9FeXhVekY1R1BwWUFNeWUxc1lIWEtCNWloZnlWc3V0?=
 =?utf-8?B?dFZjM0xnUWE4U3cybUQ3bTRpRkpRenF4MUhZNENoZWtaYnpYVC9JNmErdVNK?=
 =?utf-8?B?MFJjbWcwNnprT1B0MVRTc1VBVHRyWDR3TlptbythNXlEOW5pTklRbGdCRHZR?=
 =?utf-8?B?TFdFR3VnL1QxT0k5V3hnaXJNa25ZbXAyWUJ5QURqRzBkVGFYdjhEMjYwUlF3?=
 =?utf-8?B?TTUwdnZTMEY2Zkg1WDRhcFNiN09hTU51UDNrUDR2c0Fxcjh1OWM0NFB0cjR5?=
 =?utf-8?B?eDdWSXZrajJkdllKcTVUUktocFNJZ2xKRWs0ZURwMnJibEpTaDJRZ0tPdStO?=
 =?utf-8?B?N0FTRVpSbnhIWGlVR0FyNWxiN09PMndlenN4YWZ3ZFlBNk9EbEFSZz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db0e22e-c732-49de-e0d7-08dec7d587e0
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:45.6234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfVxmb+5wb98Q/0tZOEsc3HncXupO0r5yXzAxMt+cc8dFkgHew464+34El9Hs7C30FUa6LuC5c95RL8kexPuwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9k4fh36z3ge9btk6r9kdqs63kqg5af3j
X-Rspamd-Queue-Id: 2184440002
X-HE-Tag: 1781194916-230582
X-HE-Meta: U2FsdGVkX1/V4MZbHsJAn0TOt1AowEhHBAliHn5fplLmLfdjyr4QFUs9gvSBkahVtcn6nuL16ve7Uroh2e4VJPHSrSjqFc2RS2sz5joWWhxKNwNL+NGnVpi39kvh4O//5ZFbl2VBjQ+vy7ghTp9D7AYo9DEyL1aI4nggrywhkk2ywlG5HSPYQBxBoyQ0aUVSIPyPEHtIpta5HvLqZWQVpgfkTb4IaiHVUtRYNZojjhW7f2B+BcwBc7RCdFPkzIpFLljN1nZFprnQ8Bwf4hdxRssljxquh5916jArbQDXwH8flob78zqoOJRy+Ws3/dGuoZ7VwTCda4rKNOH1F//pjmJaW1Rs70VURWoOGGoe1WSS6jAqyD6PzWACdjU29FIFUie6N0dz4zvXyiGfcdCfmhN7z/7bi/9DeK7wscMMv9JNESkKi/Cs3v6dG+Ff3/cxLkgoJR18I019V8kMfQMR3+qHlTP2l2WxFkSDIeCp/E9L3LQkQUHxZ2fSWUU99vkID6qUhltKXgZaeC3m2NccsVkV+ShVUqGKT9TocuWZSWavcGBnRROmbJzT8vfW4F9jC902+tSWj6yXRf6FrUjFtjfxIV2tAk/hfiVCjvDuGSDh6M9IxnWzoLOH9+elM39cqbeAr0dhNKRbbHseISNx3Ed0H0R88NXJt2s8Tk/3L2aT+3nU4CXX9HM+HgY4BYkG9BueohnX2T7QYpPXdKtlqNYsrJgcnfc1L/gHPb45Ib9n0uTJbYgSKzAgsQxRofeq7Fd4BYKhmgvK2Hm9WU6fSDeHXUE8f2jFLDZPBtRbOu9XFx5QcG5xNTB+F86ay+eVVwvDGoIzlH3tgdHbQZDCT9VOsqezp/JaATOZVT+ut9ueQYzoBWTVnzTLbr2Vl35+0YEeqqjcWIRj1lAgCPoWk10/yfO2ayHm1OWIpD8KgAefseaPAulLyRcuRJrpdelZQNxBeXx05q6UFzInsyQ
 AbccgKwS
 X9aKbK7oobideQqMyEo9tzLWT4db7X2Y5YprMsDulVTso5h1M+MQ9DYp+M985cqN/uJh1rTu/g05zoWqlbcXu6IJNES3LaQoBiqXhsFYBll55FafMymTqqG0dY0Q2T0fObkZWvUd1vGThbV0ApjssjjgbiUtn9SDn9FaSwse2e0rgCDgCB6wLoq7IGqDb/aeHMRQudbzSh+iAFgCZ4iFfflvpnvXR7PJA1sV4W79w38iyn0imRzkWY2hflBqz440Fs6klNuth8DX6CF58aRBWst86kkJ+e5yg4l3eVbFjlGIVH5NWKqqtxL4XcNh+qFGKTnT4ECsTisDTwq3VjAaVCmFL34WkhQer5PsHP8oNeQ7UdOZqQgTY28fxSMrM7m+azg5WvIBMS4gGTH4U1wBvtgl7p4YMmO2P7nfguNNi3Xt7XLHum21m5qP+iQPAkHBajGXDYZJ1k/FHoEnwCzAjDEzJH+oSJo5uCx4qvOifkQKnZkX5zIlJESmuuC9O+d+Eej3PkNevPDzY089G6I+wd0tFB8cB3p1Gy77UDtQWzCj/VWyM8ZkYwAftXt1Qxmt5onsLWMAAFx8MKBReU+tIXX8/LChyqlTJEppO4zqWaubvppF3mMstFkWL2VJyb66cuth0+yw622BPNPzx6SSlqMN0r/gGHKV8gdv+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A task could enable tracing on multiple kcov_dataflow file descriptors,
corrupting the internal tracking state when one is subsequently closed.

Check current->kcov_df_enabled before allowing KCOV_DF_ENABLE and
return -EBUSY if already active. This matches kcov's check of
t->kcov != NULL in the KCOV_ENABLE path.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-20260603-v2-0-fee0939de2c4%40est.tech
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 kernel/kcov_dataflow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
index 5248293280d5..27587b8ceeab 100644
--- a/kernel/kcov_dataflow.c
+++ b/kernel/kcov_dataflow.c
@@ -287,8 +287,8 @@ static long kcov_df_ioctl(struct file *filep, unsigned int cmd, unsigned long ar
 		break;
 
 	case KCOV_DF_ENABLE:
-		if (!df->area || df->t) {
-			res = -EINVAL;
+		if (!df->area || df->t || current->kcov_df_enabled) {
+			res = -EBUSY;
 			break;
 		}
 		df->t = current;

-- 
2.43.0


