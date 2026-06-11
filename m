Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C68DCD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D79B6B008C; Thu, 11 Jun 2026 12:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF6A6B0092; Thu, 11 Jun 2026 12:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EEB6B0096; Thu, 11 Jun 2026 12:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62DC66B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:21:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BF1F90D17
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:50 +0000 (UTC)
X-FDA: 84868147980.17.BCCFDE7
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 01F2640002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=o9bTbThj;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykymMcAu6TaoUphll+d5xN0zCASLhJgyre1+aoosNG0=;
	b=YUJu0zG6BQh3kIInwAhx4RnhTF/Wn/IAr5phSpxzvrmp3oCt7fm9n3dZUvDNgDTri4Kl5K
	eUtybC7YYosKICpNQ+KHc9oC+v4jy1Yi3pBxpsl92iphRopCRdKs10y9jHDJjB4ionLI/3
	0rbE1CHK/Mjks3550WswUHUkC1+h9js=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=o9bTbThj;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194907;
	b=RMjBiPrC1cjQ+qDMs+1OPOahX7nDB0sBcYsUjkYTUC3CRbcm2QxvuaUUJutKRSjbR7IeQz
	pbvcanZK8drx4VN8VMUAop49Qy9yyd1H69yPXVhMLa81QB0i2G3qoDPUkTlRc+ttzM2kD/
	DmQ2p9Wu90NUJWLro3s7L9GoeJXsTtc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kz1kt5SzMdhpFTN696+6It61eJBfET2LZvp3Y3aogH8wZC8J39zGXejo5Z1khR7FCmyG2Oriou4g5BXbIIgGky2+fwaHfr/LsaNRGRe9ysZHDsNd0u9fnhMNbIy6F+CkOa9YozwXSyTIj/AUu/ZgtMwg9qYWl5bm5M2t5jdEJ57elZxYqIAxczsQY7B6dIN0ikMsGeA3M/slO1GgWtecpxpURTWTjc8/4dts/NiljtgQVZ+SsPcynzNe/D1ZPx8xmiBtRnlt/hlKaUbwBqWfSCeWlKnHQe5gBKvU2fWu2U1dk3z0RWjMdanKKsk3aLYVo8iv0n1nIzeyQiPuj+gaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykymMcAu6TaoUphll+d5xN0zCASLhJgyre1+aoosNG0=;
 b=b4JjL4NscQkHBML5ylC3xbEAJouk8MnA8wlGB+l+/Wk2Pyz+4RKhqB8B30QjVD9kEqvvbKt1vry/yojmvkHhfwkOtLTTCdE19L3VL3TOb5tgBsHl2ZZLDvQFA7bkx8qucYGx7P6wSAJlXNslQ5I+iu4P4umFs8vRIUCuRLaPvBHNGgBM+l0220CFic4B6h/98nyofI1PgAzGhVwE3OrTafLDDwI2Odk6aGKcfsDeWqr1DkeTKj5+1znJaTKj8rcKBVR5iMGyRJDObKs+J79WslhPSb+z8UgdyRKEzRGmnWN1X4oVEU7ctK/vWZr6QjUHnv+Jn+6pir3TWXrkkmMnzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykymMcAu6TaoUphll+d5xN0zCASLhJgyre1+aoosNG0=;
 b=o9bTbThj7Cs9cOvKKJ9+fQaYVLXL1vRvvH0EKDays9LqXfS52n2+hNcXOMmHlbuhNjYYkcFzxUpyoJCP6MD/V5271YsO2B37OMacHJmYWFBVSm89i+WVa2pb7puMM4fRySwJOCzSNgZPJB7/CEynumapnwMoNdIjTWSTe17FwfZFo86+YYMn9j2Har1B9lBejFHcmN/GWzUJ21G1PKCEI+sf8xVE2TksYLTzmWqfD933/qi63xQqnFQjllxY9JNW0QL+43d1n7e4UgcCo4rMzOFynkKJbx4Y1/Fh5dOk9Un/Payxed90VlzONZ60AE9UxVGoMW6Z446FpAJwaOuF4g==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:40 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:40 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:03 +0200
Subject: [RFC PATCH v2 01/14] kcov: add per-task dataflow tracking for
 function arguments/return values
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-1-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=18822;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=6gLp7Xt1Cvztml9jUcTHT2/9sFmnVWopPE4KHagWO04=;
 b=RXRYMg3txdwLjcwiUsXthD9aGyIBdJSM8jalIKzGCGbk15v6DP6vDBcnSkRIr7oh9bx7X87/M
 7gdTo2FY7rsBUzJ0qEf/TFOEC/YMgNrnWQ9FrDJtNZGJsvkm+tGFic5
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBB4.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::6f7) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: a92c7a71-3894-4472-11e2-08dec7d58501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	e2gCpVWImf8qM1ftzDqYzClGSEEGcUpx1OZ8O5M6kggjPpMcbWj2xHNvJKr2L/d9BStCLTbYkaJ5dxX1bOTJxNgD6orN0RW94UxUaAuewP/j77ZttvjKyGWPRDQKrlcoUX4dPHly22EBxVUP8/QjJBPMXLzgPa/zUdoJLJyElFWGW+c4I1Wfrr0d/b5185Yx5jWpO8iUHulIOOE7+HpgXxKT/BPq5w8fBuT8NzxaRSqy00e7X/51gDsLirNHVlqwGCJmrKymf99UKEIJwsAnEFyutXH68P7KPhR3K1utTqkBP19aL1M2L0qnyvA2pNFzTge22I+5FdwS9liayCD2PdRrkY1spdSSQ3Hb2G23VTqfOP/R890vFp7yIVCJ/i3n1NFTzM4cCDiN8xVoNzpUbxlq/U/LOk+6eHS6yW/FSrbMoWOReCA0CLJe1d6KN8gGE89V74IkbFV6kJ8znuzROqK09acaziGiiJhUrsjfgYweBDrT7YQZKcXxN13VbXGzAj37fQFBVXKWO/5iqNahtmZGFIbWHn61ejLfMs6bw3zcZWcrHexXAmTTadA88le2KAGODg1rlRvVV8qjoP8xZYvdulmaLK5kdVK4N3nuCvDC45jcAIj/xzEwn4jgfP+llA0jDy/VwVDvH+d60KPjo91mDZvzKh6j3ZMXQ8cEXEfSjzYXPrEvVZaiUzoUEHIaTuAuwlZIuXq41T0kw6qnON2CMIeWQhhHEWCGyhrwPwtHyiwxZlPW5I2l+A4Otu2p
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUNJQ0NweEdweTBZMjBTeHAyZHRzNE5BZXhhK29NZUxNQkxPcGh3aW9pNWJM?=
 =?utf-8?B?RDh5NHY2aEVQODVCNk54N2JtZE9uMGlyWEhkSFpNQTJUMGRBODIreUY0NkJt?=
 =?utf-8?B?Z3VZWVEyOFo3VGErdmkrUTFMYTN0VGVDNUJoRHJPRUc3Y3BjbFl6N0tja2V3?=
 =?utf-8?B?QkRRL0lnVlRDaTBsOFYyYmM0NWF4UVFpK0xQdjVjOFQxRE5ZOGs2U3JtaENl?=
 =?utf-8?B?eG1Cam91czl4Q2s4TTlnQW9Lci9wR2M0Q2c4YXgvV0FKTmhmVUVaYjMxWldE?=
 =?utf-8?B?YUwxcGxLNjczM2VHY09Fd3RkMEF2cWVha2VPTG1PY3hMKzdyN0lrVk5nNk44?=
 =?utf-8?B?NS9DdlZtRDdHdnNhODloZXcrRDlrWktERTBDUUhnRjF3Qi9welgzNlRKQlZY?=
 =?utf-8?B?elNMWnlmU0dvc2dSaDhVaitWakhmaEdkRXpnZ2tuLzBIQm8vS2pqOEgzbm1P?=
 =?utf-8?B?dzk0T2k4eE0wYlRQVk94ckphd1prT3I2SEtWejBxVVNsWG92aVpGMXJzS1hk?=
 =?utf-8?B?VlltL0F4WnFuWTVMQThFMll4SExlR2dMWGo4N1RRR2tUbUZic0R5TjV2dzBY?=
 =?utf-8?B?UDlRZGZsbjNHTi8vZlFUeU9VU0F6QTJleWFuT2dkcTZTRU11UVZnaC9zbVZY?=
 =?utf-8?B?MVlNMUN0bklNa3BGWnRSRkRWQW94RVljNHhCdTA2OFBXMUwrZUUrcGR1VERu?=
 =?utf-8?B?UGtySUFSZTd5OUpnZEpPcTJuV3RXQWQ4dUk2bm52Nk5zNjhMMURPYXFpWjQy?=
 =?utf-8?B?NHI3NmhGZEIvRmgrZUhUQ2hyS0hZZEt6TFh5VGhDYi8vNGptSVAxUHVVVnVM?=
 =?utf-8?B?NmtIY2RrTGxuMk40RlVlR0ZNOHlWQlh6cHZQdGRsN3VzbHkzcVN2ZlZKVU51?=
 =?utf-8?B?ZDRVdVBqdXRkcStnYzdpVHlEMndNbDdZZE8reTIrOXh1WW9qTU9Rek14ZXBB?=
 =?utf-8?B?OXF5OGxOTEJwdFRLUjhKUW5IUUs0SjV3bjFwT0hwMFhuZlQ2OUlUK1p5bXdu?=
 =?utf-8?B?b0J6akhrUHptRVlicjc5MXJ0cWcyT0RsTXNrK2xRcG1JZ0htRzJCa2JOWFJz?=
 =?utf-8?B?bnUvSVVPdXdQdkN6ZEVidlhwMzVxbmpudk50KzVUbVMwZitvOWRLR1ZNKzZ2?=
 =?utf-8?B?L2VZWVhTZldqWW5FSGZwRmY0ZzRTVFNQWlpEeGl3VXc2T25EQVVYTmZ5bC85?=
 =?utf-8?B?a1c4QVBoUU9Sdkd4ZWwwZTYxa1NSVklKMWlWV25lT1phSDVneHVaNEZmODBy?=
 =?utf-8?B?RUlYdVRmZUx4R3pOZXl5SVFjbFZUb3VmVy9aeUxwV3dZZzNQK0ZQT295SlZz?=
 =?utf-8?B?a0dsQklCeW1WLzRrb1hQMFBDRzRtNVhBbENZWWZsK3dWMi9VL3NnNThEeHRs?=
 =?utf-8?B?QzAyYVUwZ2VlVDVlcGZ5VEdFM0hqVzEzbTU4SGZaZSt4WTN3NU1yTzY5NmY1?=
 =?utf-8?B?bGVzcHFtUjhkS3F0WVRMSVp5RStUS1BnbFVoSVZpeFBBZDR6RW8yUkZVYXdO?=
 =?utf-8?B?ZVh6MHROUHN0dzllMUh6d2lJWUJQci96d2xJTHlybjRtR3Q1MjFZN01iMVVI?=
 =?utf-8?B?M2lJbWp5RnZMN2NpV2ZIMitvbG1iNUtLWnp2bG05aVl1UFY4QlVlYnFVWGlt?=
 =?utf-8?B?OXhaTnVReDdCWWtTS2phc1lxQzV6Qi8wandoQW0wWFpJSGFjUnVnSGVveHU2?=
 =?utf-8?B?eEtRaGVWc3VoUjZzWWdIWTNlWGkrNHVYTVFUOStjMzdzRUVSZDlOQTdIVS9o?=
 =?utf-8?B?TTlaWFg1My9wcFVZNm1YNDJzdVZlUlZUVm51QXhXTWF5SmR6Q0ZTZ1JnOHAr?=
 =?utf-8?B?RDNhanRDZmpxdDZvUHU1MjVpbEs1YTNwZFlRbk9ETTlyMGVMdWtsTzR3VHBj?=
 =?utf-8?B?Zi8rRGI3cGFMRVZISmtFS2RFQktWYnZ2RXZJOVJJTWQrSnZsWjdTWjBBQUFD?=
 =?utf-8?B?SWZRRnF1QnkrV0JSa1AyMnNZQlVLeEFPcVo3aUhTODV5aFh4S1B6SDB2WFd6?=
 =?utf-8?B?cmdFRncrOU9TL0U0SVFLVWF0amp2RWhucXRkbFlsV2NBRDF0dXM5d2hDaW16?=
 =?utf-8?B?R0hNRHBRMGVqaTBMeHZGZjExa09TRmYraDlXbUdyUUJJZStSd3MxZUhSS3ZL?=
 =?utf-8?B?bG9CSWhWOEN6TUl4QVJuZlBRTURKaTVET3M5QmY4OVJiNHdVM1p1NU9FVVF5?=
 =?utf-8?B?WWhlcG9VZTEyMkNFdmVKVDRxd0xEc1R1TStPRVZJaElObDRpTDRrK1ErMnNF?=
 =?utf-8?B?T1Jobkk3UmxOWDBqNEVOeUg4U05kQjNtM1R5YmJ1aGYyaGJWcTRkVnJKTXo5?=
 =?utf-8?B?b2dvMjhKRTR0NjVFRFlsK0xUb0cycys1Z3lqUzBnRXBxbE5tUU9hdz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: a92c7a71-3894-4472-11e2-08dec7d58501
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:40.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMhrWz7ra/msmvqxm1fqMkjRU2VCXK9uSehTlpuWaXDBL7GSlOGO4q28MdUXoSp9Err3be8fv//d1EDClb5QuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ny3c3grhims9mf71dggj1wyfy1ebs7mr
X-Rspamd-Queue-Id: 01F2640002
X-HE-Tag: 1781194906-27050
X-HE-Meta: U2FsdGVkX18312rG+Z2sG6F3FOfpjclS1t0YcbuSP3iO8seaRCud44n0UOIHNvGoxHiQ1ac6cL6s+/aNOYFpGR9qZHrxMsJEXsqdP8/O5jJXjCI086TwIR3YfXuL9SBPe9tishGJlEyIEQvaj9rcrHQOMrnInuVbGMZGyaNTJXn94k+fIZ6hmc53vD4NI1jkyWEfovFEtW4+jf/SB6X80FAiFkRvtJ7VqqSLdkXMjFQZ49h4FVgCJfEnCol+pkdAwzra3hbyYqSWZGI/lEWOgGT60SGKun6OhhvL27WA3I2JBN50EmxV7+9+cMXVNfjMUqk5401hKvdf/yZORedt0o7MZTvMdG9JcwmBZlMPrEtT8kID5xeINtUiPhG3xwRewBJ3DDVy9dZNAcqxZBd2pWhv5e1VmLynFmCR6DtRaUUrqHwnu1ACXzW/TKNnOtJWeZMmHOvmVX0BAALabW6OAFQ/AK7r5hLCpMAZUxhetEAJj/aLMHxBRC8uJl+Vf2pRwtuKoGCyArpx6w6tO6aPR2oSYxwrTwmYcnUSQCNrmK7QadzSFOaEDqp4gB+vip3Rhd42xu0+6jBAdbYawqtScviIw4AffSw+HNiJM+88871RHkUKEyiLUyxKbbZjiTwan1ljBVOAQPF8ymFiWzwHOhZD2Q/RsshhQaiv+TWMCVmSMuJYEyzCMamKCIhsHz+HitGcQR5ir+MaxFnxcYLcOeO2kubTjdLpTCXc6MJdpk+CwC/XAIFwZW8i9QTf269f69etF5qgBfGtCZEuJGwimeeEG0YlviIK+wxEzoH4U/YQGbQRAMIM1Hf0WpLELo0FG/8aNYJuTy2HLFJavBV7ie7TEQBVMLRSg9m5jnZrulJakEwY9Whnrkr1rQ8CAiyXCPKpZvlHOiupHoZMapPJOB+A0mOHX0A+PiqJh0t4HB4yzbfEY6TrlwM9ejlHnpgkswBWvDQGRaHTHfD+Xbv
 CI/1rh31
 6THYOeK9FS5AfHophUmoeC6ZJhLA94f3byX2mZ3HwMZqvO8XPZJvfgGmCTcqP+D26jzs9peTFxk5HFUs47nJjQL7a3OP9r2AqhlHOlvHSdtMofWBOdgsrMEjPmYHZWzzGkToq+IfYbfxfiF9xJtgQHk9B/lB+EVfZpOCD6/tqZXZVcKW4xmpn44K9Gzzt9RUoOtzmPbIElDqz3QEJnr3xXF9q3CMMCPILTMJHCQpaccwrJ/rgIxeiNXqCwb6EgbJncb8NQRdqduatR8C9zXIppVz/ieclyEwd6ZLpVsJM9FYT0YzJLRPPwbgIC75t++4gdHTLoMOViDhg0CT3ZPhjXFSgysnOWpzGae1q3G0WeXuxQRthdnEQFYl9HzNA/TKpZs+UVzL0jZIaAxPHDNnkmyZ8RcGA1EferDUG0p8/KoGh8oPHb1OxqgxlaYW534vMJ87/+bAzMlJWE0O6tmE0dhoTZc52sMCTYXjEq009yQG+JVrYtMP1JBx4C9Jp9GMwrG1AokD4lnhwuRa/6hfKMIrZTrI8hNdUb5NQD7Aumrb1B3vi7SPs7aXsl0AavqtUxxbF5FE/azivHnYNwc+U2GxAOhmxttzwQXyjRiPwtd4rFeK+HJagYjy/N5IbfWUQy6Epa7CreN++PqnKxq7dSCcqzax4CDAw4g9R9Plhzj7kpxzbXAhscT8sULwTAE1fSEjiazfc6APqPAiDgTUtZ5oX1WTG0WR1HY/s4TSAPA16coKP6PSAJh7D/dsBFm+9dXADFlgcNiCMhFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new tracking mechanism that captures function arguments/return
values at instrumented function boundaries via submitted as an LLVM
RFC SanitizerCoverage callbacks:

  __sanitizer_cov_trace_args
  __sanitizer_cov_trace_ret

This requires a custom LLVM/Clang build with the trace-args/ret passes:

LLVM RFC:

  https://discourse.llvm.org/t/rfc-sanitizercoverage-add-fsanitize-coverage-trace-args-trace-ret/91026

LLVM PR:

  https://github.com/llvm/llvm-project/pull/201410

Clone and build toolchain:

  git clone --recursive --depth 1 --shallow-submodules \
    --jobs `nproc` https://github.com/yskzalloc/kcov-dataflow.git
  cd kcov-dataflow

  cd llvm-project
  cmake -S llvm -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_LLD=ON \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_TARGETS_TO_BUILD="X86;AArch64"
  ninja -C build
  cd ..

Build and boot kernel (using virtme-ng):

  export PATH=$PWD/llvm-project/build/bin:$PATH
  cd linux
  vng --build \
    --configitem CONFIG_KCOV=y \
    --configitem CONFIG_KCOV_DATAFLOW_ARGS=y \
    --configitem CONFIG_KCOV_DATAFLOW_RET=y \
    --configitem CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y \
    --configitem CONFIG_DEBUG_INFO=y \
    --configitem CONFIG_RUST=y # for rust module kselftest
    LLVM=1 CC=clang

Core implementation in kernel/kcov_dataflow.c (separating from kcov.c
as Alexander's request):
  - Per-task lock-free ring buffer via debugfs kcov_dataflow device
  - READ_ONCE/WRITE_ONCE atomic pattern (tested on arm64)
  - copy_from_kernel_nofault() for safe struct field reads
  - in_task() guard rejects interrupt context
  - Bit-31 recursion guard prevents INSTRUMENT_ALL re-entry

Build system (scripts/Makefile.kcov, scripts/Makefile.lib):
  - CFLAGS_KCOV_DATAFLOW: -fsanitize-coverage=trace-args,trace-ret
  - RUSTFLAGS_KCOV_DATAFLOW: -Cllvm-args=-sanitizer-coverage-trace-args/ret
  - Per-file opt-in: KCOV_DATAFLOW_file.o := y
  - Respects KCOV_INSTRUMENT := n for noinstr exclusion
  - CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL for whole-kernel

Kconfig (lib/Kconfig.debug):
  - CONFIG_KCOV_DATAFLOW_ARGS / CONFIG_KCOV_DATAFLOW_RET
  - Depends on CONFIG_KCOV and CONFIG_DEBUG_INFO
  - CONFIG_KCOV_DATAFLOW_NO_INLINE (default n)
  - CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL

Also fix rust/kernel/str.rs unused import (flags::* -> flags::GFP_KERNEL)
which newer rustc (1.98-nightly) rejects as a hard error.

Rust support requires rustc built against the custom LLVM with
trace-args/ret passes compiled in:

  https://github.com/yskzalloc/rust

Link: https://github.com/yskzalloc/kcov-dataflow/
Cc: Alexander Potapenko <glider@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 include/linux/sched.h  |  10 ++
 kernel/Makefile        |   3 +
 kernel/kcov.c          |   2 +
 kernel/kcov_dataflow.c | 324 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug      |  43 +++++++
 rust/kernel/str.rs     |   2 +-
 scripts/Makefile.kcov  |  12 ++
 scripts/Makefile.lib   |   9 ++
 8 files changed, 404 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d1..4b8aa73b3b67 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1541,6 +1541,16 @@ struct task_struct {
 	/* KCOV sequence number: */
 	int				kcov_sequence;
 
+#if defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET)
+	/* KCOV dataflow per-task sequence counter for TLV records: */
+	u32				kcov_df_seq;
+
+	/* KCOV dataflow: separate buffer for trace-args/trace-ret */
+	unsigned int			kcov_df_size;
+	void				*kcov_df_area;
+	bool				kcov_df_enabled;
+#endif
+
 	/* Collect coverage from softirq context: */
 	unsigned int			kcov_softirq;
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 1e1a31673577..b70e524c4074 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,6 +98,9 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o audit_watch.o audit_fsnotify.o audit_tree.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_KCOV) += kcov.o
+ifneq ($(CONFIG_KCOV_DATAFLOW_ARGS)$(CONFIG_KCOV_DATAFLOW_RET),)
+obj-y += kcov_dataflow.o
+endif
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_FAIL_FUNCTION) += fail_function.o
 obj-$(CONFIG_KGDB) += debug/
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1df373fb562b..0a859ee8334f 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -353,6 +353,8 @@ void notrace __sanitizer_cov_trace_switch(kcov_u64 val, void *arg)
 EXPORT_SYMBOL(__sanitizer_cov_trace_switch);
 #endif /* ifdef CONFIG_KCOV_ENABLE_COMPARISONS */
 
+
+
 static void kcov_start(struct task_struct *t, struct kcov *kcov,
 			unsigned int size, void *area, enum kcov_mode mode,
 			int sequence)
diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
new file mode 100644
index 000000000000..721f742cbfe5
--- /dev/null
+++ b/kernel/kcov_dataflow.c
@@ -0,0 +1,324 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KCOV Dataflow: per-task function argument/return value capture.
+ *
+ * Exposes /sys/kernel/debug/kcov_dataflow, completely independent from
+ * /sys/kernel/debug/kcov. Own buffer, own ioctl, own mmap.
+ *
+ * TLV record layout (all u64):
+ *   area[0]: total u64 words written (counter)
+ *   [pos+0]: type_and_seq (0xE=entry, 0xF=return in upper 4 bits)
+ *   [pos+1]: PC
+ *   [pos+2]: meta (arg_idx | arg_size | ptr)
+ *   [pos+3..N]: field values read via copy_from_kernel_nofault()
+ */
+#define pr_fmt(fmt) "kcov_dataflow: " fmt
+
+#define DISABLE_BRANCH_PROFILING
+#include <linux/atomic.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/preempt.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/refcount.h>
+
+#define KCOV_DF_TYPE_ENTRY	0xE0000000ULL
+#define KCOV_DF_TYPE_RET	0xF0000000ULL
+#define KCOV_DF_MAGIC_BAD	0xBADADD85ULL
+#define KCOV_DF_IS_ERR(p)	((unsigned long)(p) >= (unsigned long)-4095UL)
+
+/* Ioctl commands for /sys/kernel/debug/kcov_dataflow */
+#define KCOV_DF_INIT_TRACK	_IOR('d', 1, unsigned long)
+#define KCOV_DF_ENABLE		_IO('d', 100)
+#define KCOV_DF_DISABLE		_IO('d', 101)
+
+struct kcov_dataflow {
+	refcount_t	refcount;
+	spinlock_t	lock;
+	unsigned int	size;	/* in u64 words */
+	void		*area;
+	struct task_struct *t;
+};
+
+static void kcov_df_put(struct kcov_dataflow *df)
+{
+	if (refcount_dec_and_test(&df->refcount)) {
+		vfree(df->area);
+		kfree(df);
+	}
+}
+
+/*
+ * Core write function for dataflow records.
+ * Uses the same READ_ONCE/WRITE_ONCE pattern as write_comp_data() in kcov.c.
+ */
+static noinline notrace __no_sanitize_coverage void
+kcov_df_write(u64 type_marker, u64 pc, u64 meta, void *ptr,
+	      u64 *offsets, u32 num_fields)
+{
+	struct task_struct *t = current;
+	u64 *area;
+	unsigned long count, start_index, end_pos, max_pos;
+	u32 record_len, seq, i;
+
+	if (!t->kcov_df_enabled)
+		return;
+
+	if (!in_task())
+		return;
+
+	/*
+	 * Prevent recursion: functions called by this callback
+	 * (copy_from_kernel_nofault) may be instrumented. Use the
+	 * sequence counter's high bit as a per-task guard.
+	 */
+	if (t->kcov_df_seq & (1U << 31))
+		return;
+	t->kcov_df_seq |= (1U << 31);
+
+	area = (u64 *)t->kcov_df_area;
+	if (!area)
+		goto out;
+
+	max_pos = t->kcov_df_size * sizeof(u64);
+
+	/* Record: header(1) + pc(1) + meta(1) + fields or scalar(max 1) */
+	record_len = 3 + (num_fields > 0 ? num_fields : 1);
+
+	count = READ_ONCE(area[0]);
+
+	start_index = 1 + count;
+	end_pos = (start_index + record_len) * sizeof(u64);
+	if (unlikely(end_pos > max_pos))
+		goto out;
+
+	WRITE_ONCE(area[0], count + record_len);
+	barrier();
+
+	seq = ++t->kcov_df_seq;
+	area[start_index] = type_marker |
+			    ((u64)(record_len - 3) << 24) |
+			    (seq & 0x00FFFFFFULL);
+	area[start_index + 1] = pc;
+	area[start_index + 2] = meta;
+
+	if (num_fields == 0) {
+		u64 val = 0;
+		u32 sz = (meta >> 48) & 0xFF;
+
+		if (sz > sizeof(val))
+			sz = sizeof(val);
+		if (ptr && !KCOV_DF_IS_ERR(ptr))
+			copy_from_kernel_nofault(&val, ptr, sz);
+		area[start_index + 3] = val;
+	} else {
+		if (KCOV_DF_IS_ERR(ptr)) {
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
+			if (sz <= sizeof(val))
+				copy_from_kernel_nofault(&val, fa, sz);
+			else
+				copy_from_kernel_nofault(&val, fa, sizeof(val));
+			area[start_index + 3 + i] = val;
+		}
+	}
+out:
+	t->kcov_df_seq &= ~(1U << 31);
+}
+
+#ifdef CONFIG_KCOV_DATAFLOW_ARGS
+noinline void notrace __no_sanitize_coverage
+__sanitizer_cov_trace_args(u64 pc, u32 arg_idx, u32 arg_size, void *arg_ptr,
+			   u64 *offsets, u32 num_fields);
+
+noinline void notrace __no_sanitize_coverage
+__sanitizer_cov_trace_args(u64 pc, u32 arg_idx, u32 arg_size, void *arg_ptr,
+			   u64 *offsets, u32 num_fields)
+{
+	u64 meta = ((u64)arg_idx << 56) | ((u64)arg_size << 48) |
+		   ((u64)(unsigned long)arg_ptr & 0xFFFFFFFFFFFFULL);
+	kcov_df_write(KCOV_DF_TYPE_ENTRY, pc, meta, arg_ptr,
+		      offsets, num_fields);
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
+	u64 meta = ((u64)ret_size << 48) |
+		   ((u64)(unsigned long)ret_val & 0xFFFFFFFFFFFFULL);
+	kcov_df_write(KCOV_DF_TYPE_RET, pc, meta, ret_val,
+		      offsets, num_fields);
+}
+EXPORT_SYMBOL(__sanitizer_cov_trace_ret);
+#endif
+
+/* File operations for /sys/kernel/debug/kcov_dataflow */
+
+static int kcov_df_open(struct inode *inode, struct file *filep)
+{
+	struct kcov_dataflow *df;
+
+	df = kzalloc(sizeof(*df), GFP_KERNEL);
+	if (!df)
+		return -ENOMEM;
+	spin_lock_init(&df->lock);
+	refcount_set(&df->refcount, 1);
+	filep->private_data = df;
+	return nonseekable_open(inode, filep);
+}
+
+static int kcov_df_close(struct inode *inode, struct file *filep)
+{
+	struct kcov_dataflow *df = filep->private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&df->lock, flags);
+	if (df->t == current) {
+		current->kcov_df_enabled = false;
+		current->kcov_df_area = NULL;
+		current->kcov_df_size = 0;
+		df->t = NULL;
+	}
+	spin_unlock_irqrestore(&df->lock, flags);
+	kcov_df_put(df);
+	return 0;
+}
+
+static int kcov_df_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct kcov_dataflow *df = filep->private_data;
+	unsigned long size, off;
+	struct page *page;
+	unsigned long flags;
+	void *area;
+	int res = 0;
+
+	spin_lock_irqsave(&df->lock, flags);
+	size = df->size * sizeof(u64);
+	if (!df->area || vma->vm_pgoff != 0 ||
+	    vma->vm_end - vma->vm_start != size) {
+		res = -EINVAL;
+		goto out;
+	}
+	area = df->area;
+	spin_unlock_irqrestore(&df->lock, flags);
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
+	spin_unlock_irqrestore(&df->lock, flags);
+	return res;
+}
+
+static long kcov_df_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	struct kcov_dataflow *df = filep->private_data;
+	unsigned long flags;
+	unsigned long size;
+	int res = 0;
+
+	spin_lock_irqsave(&df->lock, flags);
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
+		spin_unlock_irqrestore(&df->lock, flags);
+		df->area = vmalloc_user(size * sizeof(u64));
+		if (!df->area)
+			return -ENOMEM;
+		spin_lock_irqsave(&df->lock, flags);
+		df->size = size;
+		break;
+
+	case KCOV_DF_ENABLE:
+		if (!df->area || df->t) {
+			res = -EINVAL;
+			break;
+		}
+		df->t = current;
+		current->kcov_df_area = df->area;
+		current->kcov_df_size = df->size;
+		current->kcov_df_seq = 0;
+		barrier();
+		current->kcov_df_enabled = true;
+		break;
+
+	case KCOV_DF_DISABLE:
+		if (df->t != current) {
+			res = -EINVAL;
+			break;
+		}
+		current->kcov_df_enabled = false;
+		barrier();
+		current->kcov_df_area = NULL;
+		current->kcov_df_size = 0;
+		df->t = NULL;
+		break;
+
+	default:
+		res = -ENOTTY;
+	}
+	spin_unlock_irqrestore(&df->lock, flags);
+	return res;
+}
+
+static const struct file_operations kcov_df_fops = {
+	.open		= kcov_df_open,
+	.unlocked_ioctl	= kcov_df_ioctl,
+	.compat_ioctl	= kcov_df_ioctl,
+	.mmap		= kcov_df_mmap,
+	.release	= kcov_df_close,
+};
+
+static int __init kcov_dataflow_init(void)
+{
+	debugfs_create_file_unsafe("kcov_dataflow", 0600, NULL, NULL,
+				   &kcov_df_fops);
+	return 0;
+}
+device_initcall(kcov_dataflow_init);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e2f976c3301b..a402f829f9f9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2261,6 +2261,49 @@ config KCOV_SELFTEST
 	  On test failure, causes the kernel to panic. Recommended to be
 	  enabled, ensuring critical functionality works as intended.
 
+config KCOV_DATAFLOW_ARGS
+	bool "Enable KCOV dataflow: function argument capture"
+	depends on KCOV
+	depends on DEBUG_INFO
+	depends on $(cc-option,-fsanitize-coverage=trace-args)
+	help
+	  Captures function arguments at entry via /sys/kernel/debug/kcov_dataflow.
+	  Struct pointer arguments are auto-expanded using compiler DebugInfo
+	  metadata, recording individual field values at runtime.
+	  Enable per-module with: KCOV_DATAFLOW_file.o := y in the Makefile.
+	  Requires clang with -fsanitize-coverage=trace-args support.
+
+config KCOV_DATAFLOW_RET
+	bool "Enable KCOV dataflow: return value capture"
+	depends on KCOV
+	depends on DEBUG_INFO
+	depends on $(cc-option,-fsanitize-coverage=trace-ret)
+	help
+	  Captures function return values via /sys/kernel/debug/kcov_dataflow.
+	  Struct pointer returns are auto-expanded using compiler DebugInfo
+	  metadata, recording individual field values at runtime.
+	  Enable per-module with: KCOV_DATAFLOW_file.o := y in the Makefile.
+	  Requires clang with -fsanitize-coverage=trace-ret support.
+
+config KCOV_DATAFLOW_NO_INLINE
+	bool "Disable inlining for dataflow-instrumented files"
+	default n
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
 config DEBUG_AID_FOR_SYZBOT
        bool "Additional debug code for syzbot"
        default n
diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index a435674f05ea..f447a25c67c9 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -3,7 +3,7 @@
 //! String representations.
 
 use crate::{
-    alloc::{flags::*, AllocError, KVec},
+    alloc::{flags::GFP_KERNEL, AllocError, KVec},
     error::{to_result, Result},
     fmt::{self, Write},
     prelude::*,
diff --git a/scripts/Makefile.kcov b/scripts/Makefile.kcov
index 78305a84ba9d..a459c119795f 100644
--- a/scripts/Makefile.kcov
+++ b/scripts/Makefile.kcov
@@ -9,3 +9,15 @@ kcov-rflags-$(CONFIG_KCOV_ENABLE_COMPARISONS)	+= -Cllvm-args=-sanitizer-coverage
 
 export CFLAGS_KCOV := $(kcov-flags-y)
 export RUSTFLAGS_KCOV := $(kcov-rflags-y)
+
+# KCOV dataflow: trace function args and return values
+kcov-dataflow-flags-y := -fsanitize-coverage=trace-args,trace-ret
+kcov-dataflow-flags-$(CONFIG_KCOV_DATAFLOW_NO_INLINE) += -fno-inline
+
+# Rust: only add the trace-args/ret llvm-args (sancov-module pass and level=3
+# are already provided by RUSTFLAGS_KCOV since KCOV_DATAFLOW depends on KCOV).
+kcov-dataflow-rflags-y := -Cllvm-args=-sanitizer-coverage-trace-args
+kcov-dataflow-rflags-y += -Cllvm-args=-sanitizer-coverage-trace-ret
+
+export CFLAGS_KCOV_DATAFLOW := $(kcov-dataflow-flags-y)
+export RUSTFLAGS_KCOV_DATAFLOW := $(kcov-dataflow-rflags-y)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0a4fdd8bd975..b64fabb88ab9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -88,6 +88,15 @@ _c_flags += $(if $(patsubst n%,, \
 _rust_flags += $(if $(patsubst n%,, \
 	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(if $(is-kernel-object),$(CONFIG_KCOV_INSTRUMENT_ALL))), \
 	$(RUSTFLAGS_KCOV))
+# KCOV dataflow respects KCOV_INSTRUMENT := n (noinstr exclusion)
+_c_flags += $(if $(patsubst n%,, \
+	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(if $(is-kernel-object),y)),$(if $(patsubst n%,, \
+	$(KCOV_DATAFLOW_$(target-stem).o)$(KCOV_DATAFLOW)$(if $(is-kernel-object),$(CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL))), \
+	$(CFLAGS_KCOV_DATAFLOW)))
+_rust_flags += $(if $(patsubst n%,, \
+	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(if $(is-kernel-object),y)),$(if $(patsubst n%,, \
+	$(KCOV_DATAFLOW_$(target-stem).o)$(KCOV_DATAFLOW)$(if $(is-kernel-object),$(CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL))), \
+	$(RUSTFLAGS_KCOV_DATAFLOW)))
 endif
 
 #

-- 
2.43.0


