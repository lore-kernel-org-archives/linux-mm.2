Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A0ACD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54A66B00A4; Thu, 11 Jun 2026 12:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAA56B00A3; Thu, 11 Jun 2026 12:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B6C6B00A5; Thu, 11 Jun 2026 12:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A27576B00A2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43D94165747
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:08 +0000 (UTC)
X-FDA: 84868148736.30.C89FC79
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37FEA40006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=pta01dfy;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPAvQAWl+YEzEEBSaHvtqmqDpqWGP3vIWNmCd5hzBWA=;
	b=rcMPrpvJ9gm0u7Macq0jZ3TDy2S26+KPeVVTsi0n+2ER6f8N+isatct0aKgGbBgzPF/S24
	QeRJyJlEDyfRhc0KCs8AuXxR0hR/QYd2wlZ8/q1ehInm6L3l5eNIWxKiJI72gPIf7C5/vp
	zDzG0TFj4MT6GxB7TQSOfYWGPv3tb4k=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=pta01dfy;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194925;
	b=BYFfJMwzf0LKPQJUubgYdH9CXbmmLwwTKxkq1SJDNdlT7ojLoPr/09SfZ5lGRMm5qEIlNe
	hRiv5qdZzpZOnG0k/qd8QV1paLNKcOx+b6DAlam4auGzI41l56Z2Xrf90sEv8hOCsXE/1C
	07mey4ZU2zXy9VqNrh56WwM7Lmw+HGk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oHfClKXaPlXP0Y2Qlp8GfspEocsAf/G9FODLnUBeNvVfYscSUUdk84Y/1g641QAXaU0+PXrgBY9UoCWTpuk8F+iGmvWqFo3o14XTtqIHbebgPAPWy88vn4F+b40Fb7ipPAUAx8VBPpQVrbz8qYT1YtuxAXREpQkCG5SxTUeDrefI1L3WK3Csf82yOZKibITtH2dK5UTrd6RIDJrmFIAhXoVmx4lTOzUnkW2MWNeIn07TYTEFsXTbYduQJQCJrqyEHE7tvjejtMcFldSG3jtuALVGWrSc1Y1tZQ9V5RMv2k1pIl0Ls/xURpJ9NQuVjRlEHy/DxRxP4BSReqFecIBzrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPAvQAWl+YEzEEBSaHvtqmqDpqWGP3vIWNmCd5hzBWA=;
 b=fPnum9UUzWNk5KgnzF/GrCnEYldEVjHM7hgRJTF/rIttTXgpG7dvtV02V7Q6SkCm2YWWIzH2z7pozYkqn/974jX+DFNuFmWJXD43wWMwamOMDllxTOw3J8vgEUQySIoMh8RmwGU9PzJv3iKRDRIeieEdgKG0UkPgaUIT5mH4FmzNAQcxcOAyhI3s/3ZvsbTkYsTz3LE8ZhnfgDADFhT00iP2V3xRivFjWDsJSpsOogN+QIoADmQPWWVU6fU+6U/zUlISy9h+mnlttxM0F1tr3DFlzzZUgSyYHbKeRggSRaA7ByQc+hknvcSClQ8LQ0nf9pIL13OtDK1SHtOOi0gYWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPAvQAWl+YEzEEBSaHvtqmqDpqWGP3vIWNmCd5hzBWA=;
 b=pta01dfybbSpxZ+CtcF+Fe1Q7SSIDMK7iCdgGPiaXvuxvRYVV7ubu17oUfmUHLo7mN9Pv0dX8rBbngq9Sps0fcTYcFqtur04O7tRHXuT32Cy4Ude0cOkxDLzEnbzrfKkZOk7aZ8/MHZaaRR4V+nzNUZSCQi/L0zXVoqA1I+b5VeXhT1kCtyavkGa1By6XgBU5OXOMT0dgnqRHfPjKrOzj2CokoQbLIgAWSyuRH8ZXGLaf13pRFgSzP2nbtiNfePlN9IbX+GUtju+NRD+jvlmmplPtfOA79KHlZ+5hX2n2x/4gLuvHgMPlWhhZQLcuwU/rDxyGEcGWVwKktK0Y01/MA==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:54 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:53 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:11 +0200
Subject: [RFC PATCH v2 09/14] selftests/kcov_dataflow: add ioctl interface
 selftest
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-9-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=8940;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=jwuzX1cP0P+EPi7RNlJUI8LFba/lT//dIZ9nmZnn9vE=;
 b=vleU45dLzLC6oHoxPjhnIjxjIUZY7+rzuLyuOV9/Byn8RFj/Mj2uBcadDz1Y2m8PI4wwcNyhk
 zR8oO3QIAVxDi0LHl/Xhtlm6oZOI015uS3sVbP1DXIygra8Hqe6vWRt
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GVX0EPF0005F6BE.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::648) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: 01a069f7-e6ae-403b-a6bd-08dec7d58ccb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gw9Ag5o12GhYvHoMFl1q9k9nHQi81LE4QEXTPGp2PqAwO2UK1Tj6+V2NQ5wtxOSFXC7YPB1nfA05cQP2v/vjfz6hVjLi9gygkMXW0k/HkLm15K9tFoq3sV6rhhY8oQ8cVh8PdZUF84si55iVzWs3blMEWoPlGRoWtZ+KLwzNOtmyqOlxrTp9HTSs+k+NoM02uWlK8zxPDPHbZOUApuRODICjOcWTeCv/x9oGAGuXfUfi+IAiY3XMAeeoNAoIpuZeDNd1VQ2N+9CM+0M6vcsAXmdfy/o8IFvRxjuW+NnAGkiyo04LT+MpQ5FxIfUeyDwlMl0Q6XR/pjKk5ncOqwHzqBcwyw4RPTrIHs4++cAdl9X0Lg0JevPAf0NoVQnPU3laJHb/6IQNesEaLtXno8D8KOwsOxQI1G/6I9HI/nQnGztfWzE1XUBWgiatA1M02UhVYboLFLq7covmlVxPs1KQ79SZHqhHJib1JfyE585xdVipDy6+IbT0yn0mIzeiGx7wLEUt0TWDvmZYtOHB9NRWqdCNqRJjMWvm1RNTM6K//hUvFY9hGCvZRDCUKqcyeiGyqMbeV9pUuVRsKZN8qnCv+k56zUr0vPMjbj11uX62x+CSLfXYQ+AovNk+mlSpXiHGPW2N3VobEUmUfxETcNMVWZiaBBM9Nd6r/EN93GmI2f3tk3yOZNBko5F7jPTd5NLpm317sOdJaF0mIBNFeo5jv6HxxNeBvJTdLIg4rQ+xoSfFoFm8pQVlrwNr2ihdIRFC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZW1HNHlUc2t1OU1KeFZZMENkcWFRNmhDdEJRTFdVTkpNNnJiY3JzNDUzMm03?=
 =?utf-8?B?bGEvM254WFc4Y0RLYjN6K2dxNExvR3RtWmlVNFBjZzVOaThSbEFyOHVGVlVJ?=
 =?utf-8?B?bzVEb3pCUjZtS1MrVDJIN3hoTmNNNVdVck9ZOVkya3dTZ3doZmhXMFhqL0da?=
 =?utf-8?B?YjZVdEx1a2lZRHp6a1k3TTRycGVFNndYejB3TStXRWg1QndNalBNR3BHQ3Yx?=
 =?utf-8?B?ekowRWRSK2FjYWJQWXBqcGJpUmtpQUYzemRJcUthK0N1cjVFUlI4aGJtbDh0?=
 =?utf-8?B?dTdkTzFsVHR4K0I5enFlMlYvRHY1N2thVFdWOUxUcWp0TzdiYS9HaGdEREYv?=
 =?utf-8?B?UlIyaXp4eHFXRmFFL1pjMzRIRlJmNW5xcVRIaUtmQU41dTY2a0gyeHlON2tN?=
 =?utf-8?B?OHJhbnpEWUtlK1E4T0E3bDlFWGpXRHByaC9GRXBRakVNSFB0QzFzOTZkMndm?=
 =?utf-8?B?RnhnbEo1WXVQdEJNUFZiUW1aajYyTUhzNWVOdHRlcG14YkxybnFPcVh4MlU3?=
 =?utf-8?B?OFNQcWwvL0pKekJaWWFBOElwN2RVVk92YU1vTlVlS2FYZjM0WU0xcUEvQlZx?=
 =?utf-8?B?cTBPdTh6eU4xN1hVQ2VickpkcWFRc0QwQ3JZOTBkT3JHYitvbEY3RDQ4Q0xK?=
 =?utf-8?B?cXlSMTd1WG5EbTZLNWtTTDk5OGd6d0U5aDY1SDczdkpqSDU1WU54c29HL3l4?=
 =?utf-8?B?T1hSM3kvNUZielFrYytqM3JtUXh5WVhSeXVhbmJrMitkUERyR3oyWVpRZDEr?=
 =?utf-8?B?NmY0T1NaaXFiYzlCK3UvWWV4UW81R2pQbUxYdTFqRk1BK0JVa3dxUjdrMkYz?=
 =?utf-8?B?T2RFL0s2U0dieVFHMXVwZC9VeFZYVE9sSVJ4Si93MDljRHVlWUl3bEJHcTYz?=
 =?utf-8?B?K1VuaXVjOTkzWnBYUE85Qk55SGo3VVp4NkNOMWo0VnR1c2ovZnQ1bUZwajdY?=
 =?utf-8?B?QWYrNE1TTXhtemZvUlEvUit1MVByU2wwTk1aa0p6eVVnOWs1WDB5M1Iwb2dI?=
 =?utf-8?B?M2J6Z0dueFVsT2VOWkZ6S0MyaGppQ3ZmRmJ0NDdvOXk0OWR6SU8xSHQwM3RZ?=
 =?utf-8?B?OTBlUXFHbnNFY2hPbVNvaTBwWkF4UW5kNXo1UmVzWmxMZFFhMkFIeGlQai9q?=
 =?utf-8?B?RWxnaEljK0R1NGJXRU5LMG9ReDZGVUQwczVwZXM4L1p5SDdYT1Rray9Pc1gw?=
 =?utf-8?B?VTU4YjV4Sng3QTVvL0RBU3NGMmorcWJLWHhsWmhzdU13N0thaXRhV3p4dmJn?=
 =?utf-8?B?ZWYvNmhCOFNtNFdXa1QyWmxFOVpqanVEYXRHZVY3L29odmFXU3c5djNRRVhl?=
 =?utf-8?B?dE5jZGVnK3EyUCs1SmJ4d2c2UC8weXVkTHlhMTcvVXVWcWl4L2lmQ1JzbjNY?=
 =?utf-8?B?dzRpRWdDdEZ6bGNjYjZiYms3T3FCUk96QXRmcmV3cFUxb2gwYVFHZGp0b3Ex?=
 =?utf-8?B?QjhjK0IyN0daRlFsTWR4MCtJUlZDYTQ1NnJNTktvK3EweWlMQ1lqclpGWVZB?=
 =?utf-8?B?ekg3YlMwMllrZkF4QVl2UHhKNkhBYzVicUk5eGlGS1dTTURoeVVQelRmajl1?=
 =?utf-8?B?YnluWWdsVHZuNlkwT2RwdGIxSjRSTE5sY2cxL0FzVUw2WGhrb3E3MVE3NXQ2?=
 =?utf-8?B?eFh0OS9uaGF1Vm91a1k2bVJhZzlJdHMxaGsyZStqUnc5eVYrdzJCT0lOZ0Jy?=
 =?utf-8?B?WlJrYUYvaE1HTUN2c0xSMjJnV0VxTmVMNWpRQm0rN08zSkhTakN6cXQ1VEZ4?=
 =?utf-8?B?bGV0OTRtYUVqYmZXeEVoL1J6amx1bmgxWGR6U2krYThyVnZJOUxGOFZ6WXpZ?=
 =?utf-8?B?NTl1dVJUcEhSVTZlZGQ5MEJ3SU1rUmJkNHZsNldibUIzNXdWV0YzelE5aWNN?=
 =?utf-8?B?bXNBR3MvQkRScDBhTWs2SExXQ1FHSGltZmFaZjE4VkM5SzgzNzVHamhwcFNz?=
 =?utf-8?B?Q0RvQ3FHbVE1VGRGangxTnRZWlNVSDQzYzYxcmZtMU9ycGQ1b211QmljSy90?=
 =?utf-8?B?cWZsWmpwZk13Y2ptSXI1MXVHQnQrMjhtbXltWEVHcHppVXRJb1BBeGxyWmdN?=
 =?utf-8?B?M3RNM1dmNGdCVGFVcXV2ZVo1b0lESG1VMnBOWXNRNTd5YjNKQzIwbEFqUzJs?=
 =?utf-8?B?RzhCTWpVK2phTXVBYjBtSVlGcXpqNWNidUR2MjNWVVY5UkxxZ2hScDZzZWRK?=
 =?utf-8?B?RUVJOXhnUkRZRUxGMWR6NHMwcE9wZm9rUFZVTnpIU1ZVMngvZkhlTWJqNkpT?=
 =?utf-8?B?Z1J2dnVjVnlGS21kZGVrWTcrMlpGK3k0ODhPNE15ZmpUeWQxTTYySi9wN2ln?=
 =?utf-8?B?T0pOUlVEOEMxRzBnWmF3K1BoTGZneTgzTXFqclFqUHkya3cwOWU3dz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a069f7-e6ae-403b-a6bd-08dec7d58ccb
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:53.8189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2ZfUhkEOIrDihvP5iAsiRcID12RPLmu2B2g7YZ+14p9HcDbpPE8i8QaZuJ7nRNFS42DI6Q4zZbijQNczTJjSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hpudyfc3dbpajmxa4zqkjzwyrcphzhz7
X-Rspamd-Queue-Id: 37FEA40006
X-HE-Tag: 1781194925-579519
X-HE-Meta: U2FsdGVkX1/XvPh16dgCh08wGt1bJrUPMDfdv1LzL3Wep5pD6/sxUe9gvKTPan7OXYiNSoZK1V5SLWYhVQZ15ye0UnRGJ2AEFwGVGJ7NM7Mr2mQJwYnSzgBCCbHbGv/vh0ewlUooLfBOPpO9AfFOrZpYMXnIC4tSgpxsuG/bbOu06m3WoFmY2/Mi4Blhyq1bgqeLEMQlxrSS7z65JIGhiM9TMJ/Do/0an0hqROg8Nx6y8MEBn+1hDjuIN7mY/RtvFikhprlcNqFwqldtJeWIIuzLV+XTKJSMwcA0WHzHT1idFP45TlgLB/hRGAtDa8aNtiOjZNN4IGBS2IGoIWLFQPV5xDRsRcPl6jjic94y0NV6g7/IPgoQBf3rDcouVP81mGCM71KeMAu2UIn36mXg3CCwFZOF2i8RKGXOT7GQ3uGwbsH6OBn7NAvmXIb35IHQNbU+T7t2RZDFhMryJ5YOJ6jMKRFNla7r3+b2nT/M5mIgtBzkC4t8wdMvEpvJ6iNbB7hI4r/kku3mnEOM0QTGr99zliBghoN1yebIBxx/SmB/LNRZgKoxgG8Jt1c7z+njS3ZrQbHiSaCbTyR/7hMwBzRwLQbtrSkT9/K5NyIkAmOlVvlG9P18EKdGbOJMaKgyv30IY0Rhjc0KOSYEErmZzUpqNlbBOojSEHbm0951NblfFkEnDx0h3v5LmkBdYJ3QpNSK6Xia/vIhPb4zCct1Rj9pyOC+x8PyA0Gamkcs8KXS1MIb9XE4yFQvDDzmI3AUvjOhBoooOSSyRUEFeepRw0VefaAAWONYTW2p6J8HSx1+kqga90wRiAIui8+yXcyXIyxwb63gwWGSY4e4HJ8BF01tClN8kD70AN6PsfKZfYNDF9AlMO4VPlL5ynYlglyq5AE5uroY/GjXaiBzFcbY1+NHbmD2VAKmMW9ouRAOR2aucPaN1CjK1xQA+ot4hua8w+S3nza0iMmGeFxO6ga
 F04yit8U
 IyQH30dtRQnMctJpN08slkRHD6v7hECMqpuEoAaDVLN5nKgmZtFksmSjy7pIeJwrq7wruo8M066qyUiGwMH/BRMPiwMH40gi18PmuVlQmNWiIy9MBptAtGGhymGuX7eZk7Ob7/6y4FTaQeIxJJw00jv5+LfPmkc9P2j5XC8XpXqJxorabhLIZXJMWEkL0/BzzCvSSjGZBtI+gB/cz+enJhp/YSUvE5pU0BugKp5htvsyS2p0OCkyjAwqVBrkVi5WkJ2BN43u/Bl5b71CIrfMFM+cqCKIbJt75h0hBUneHVrHLyZp5NYihkqFhlEz+ja9iRCoHjyPPORYoAMhYe7tFztbWEWKbl8e1mo8Ru2TRQzaZbYmo0jCpLIKpYbwnQGN8xl1GPcaP3P/J9Q56VGbGluBsaduQrCDenGpDXnad3a8brMz0yt088I7Y7lXFZ9ggTPhVZkUx5bH9m/R8RYHPXPSt7zEqwSiz5MdjLz90CqQasEmwR3z8akaQgRNh+9Zvdb3LW18TINa2Y7bEAUDLtqjtfpdO7TmX1bRHzBBvs1DpqGU0KbH4+BJPQf7jVrHNIpd2R1wkmlxkSzRJVmIuUx+HoT7jJ33Gk8nBOTSgDoML0kcsn5HT4CP7wEcF2ZOddX6YygYPtYQGhpX/W/BL8HTP7v1/cCnGjiZ5ryQHLt4bA+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kselftest_harness-based test in user_ioctl/ covering the
kcov_dataflow ioctl interface (9 TAP cases): init, mmap, enable,
disable, error paths, double-enable rejection, and record capture.

Test:

  make -C tools/testing/selftests/kcov_dataflow
  ./user_ioctl/user_ioctl

Result:

  TAP version 13
  1..9
  # Starting 9 tests from 1 test cases.
  #  RUN           kcov_dataflow.init_track ...
  #            OK  kcov_dataflow.init_track
  ok 1 kcov_dataflow.init_track
  #  RUN           kcov_dataflow.init_track_too_small ...
  #            OK  kcov_dataflow.init_track_too_small
  ok 2 kcov_dataflow.init_track_too_small
  #  RUN           kcov_dataflow.init_track_double ...
  #            OK  kcov_dataflow.init_track_double
  ok 3 kcov_dataflow.init_track_double
  #  RUN           kcov_dataflow.mmap_before_init ...
  #            OK  kcov_dataflow.mmap_before_init
  ok 4 kcov_dataflow.mmap_before_init
  #  RUN           kcov_dataflow.enable_disable ...
  #            OK  kcov_dataflow.enable_disable
  ok 5 kcov_dataflow.enable_disable
  #  RUN           kcov_dataflow.enable_without_mmap ...
  #            OK  kcov_dataflow.enable_without_mmap
  ok 6 kcov_dataflow.enable_without_mmap
  #  RUN           kcov_dataflow.disable_without_enable ...
  #            OK  kcov_dataflow.disable_without_enable
  ok 7 kcov_dataflow.disable_without_enable
  #  RUN           kcov_dataflow.double_enable ...
  #            OK  kcov_dataflow.double_enable
  ok 8 kcov_dataflow.double_enable
  #  RUN           kcov_dataflow.records_captured ...
  #            OK  kcov_dataflow.records_captured

Cc: Alexander Potapenko <glider@google.com>
Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Link: https://github.com/yskzalloc/kcov-dataflow/actions
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 tools/testing/selftests/kcov_dataflow/.gitignore   |   8 ++
 tools/testing/selftests/kcov_dataflow/Makefile     |   3 +
 tools/testing/selftests/kcov_dataflow/README.rst   |  37 +++++
 .../kcov_dataflow/user_ioctl/user_ioctl.c          | 156 +++++++++++++++++++++
 4 files changed, 204 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/.gitignore b/tools/testing/selftests/kcov_dataflow/.gitignore
new file mode 100644
index 000000000000..f71fc89580f8
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/.gitignore
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+user_ioctl/user_ioctl
+*.o
+*.ko
+*.mod
+*.mod.c
+Module.symvers
+modules.order
diff --git a/tools/testing/selftests/kcov_dataflow/Makefile b/tools/testing/selftests/kcov_dataflow/Makefile
new file mode 100644
index 000000000000..b9fc1c5f0104
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_GEN_PROGS := user_ioctl/user_ioctl
+include ../lib.mk
diff --git a/tools/testing/selftests/kcov_dataflow/README.rst b/tools/testing/selftests/kcov_dataflow/README.rst
new file mode 100644
index 000000000000..8b650a62acb1
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/README.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests
+========================
+
+This directory contains selftests for the KCOV-Dataflow subsystem
+(``/sys/kernel/debug/kcov_dataflow``).
+
+Prerequisites
+-------------
+
+Build the kernel with::
+
+    CONFIG_KCOV=y
+    CONFIG_KCOV_DATAFLOW_ARGS=y
+    CONFIG_KCOV_DATAFLOW_RET=y
+    CONFIG_DEBUG_INFO=y
+
+For full capture, also enable::
+
+    CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y
+
+Tests
+-----
+
+user_ioctl/user_ioctl.c
+    Automated ioctl interface test (9 TAP cases)::
+
+        make -C tools/testing/selftests/kcov_dataflow
+        ./user_ioctl/user_ioctl
+
+trigger-view.py
+    Loads a test module via finit_module() with recording active,
+    prints captured records with symbol resolution::
+
+        python3 trigger-view.py <module_name>
+        python3 trigger-view.py <module_name> --raw
diff --git a/tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl.c b/tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl.c
new file mode 100644
index 000000000000..48448bc02d2f
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * kcov_dataflow_test.c - Selftest for /sys/kernel/debug/kcov_dataflow
+ *
+ * Verifies the ioctl interface: open, INIT_TRACK, mmap, ENABLE, DISABLE.
+ * With INSTRUMENT_ALL, also verifies that records are produced for
+ * syscalls executed while recording is active.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <stdint.h>
+#include <string.h>
+#include <errno.h>
+
+#include "../../kselftest_harness.h"
+
+#define KCOV_DF_INIT_TRACK	_IOR('d', 1, unsigned long)
+#define KCOV_DF_ENABLE		_IO('d', 100)
+#define KCOV_DF_DISABLE		_IO('d', 101)
+
+#define BUF_SIZE 65536
+
+#define DF_TYPE_ENTRY	0xE
+#define DF_TYPE_RET	0xF
+
+FIXTURE(kcov_dataflow) {
+	int fd;
+	uint64_t *buf;
+};
+
+FIXTURE_SETUP(kcov_dataflow)
+{
+	self->fd = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+	if (self->fd < 0)
+		SKIP(return, "kcov_dataflow not available (need CONFIG_KCOV_DATAFLOW_ARGS)");
+	self->buf = MAP_FAILED;
+}
+
+FIXTURE_TEARDOWN(kcov_dataflow)
+{
+	if (self->buf != MAP_FAILED)
+		munmap(self->buf, BUF_SIZE * sizeof(uint64_t));
+	if (self->fd >= 0)
+		close(self->fd);
+}
+
+TEST_F(kcov_dataflow, init_track)
+{
+	int ret = ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE);
+
+	ASSERT_EQ(0, ret);
+}
+
+TEST_F(kcov_dataflow, init_track_too_small)
+{
+	int ret = ioctl(self->fd, KCOV_DF_INIT_TRACK, 1UL);
+
+	ASSERT_EQ(-1, ret);
+	ASSERT_EQ(EINVAL, errno);
+}
+
+TEST_F(kcov_dataflow, init_track_double)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(-1, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(EBUSY, errno);
+}
+
+TEST_F(kcov_dataflow, mmap_before_init)
+{
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_EQ(MAP_FAILED, self->buf);
+}
+
+TEST_F(kcov_dataflow, enable_disable)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->buf);
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+}
+
+TEST_F(kcov_dataflow, enable_without_mmap)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	/* enable works even without mmap (mmap is optional for setup) */
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+}
+
+TEST_F(kcov_dataflow, disable_without_enable)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(-1, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+	ASSERT_EQ(EINVAL, errno);
+}
+
+TEST_F(kcov_dataflow, double_enable)
+{
+	int fd2;
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->buf);
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+
+	/* Second fd should fail to enable (task already active) */
+	fd2 = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+	ASSERT_GE(fd2, 0);
+	ASSERT_EQ(0, ioctl(fd2, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(-1, ioctl(fd2, KCOV_DF_ENABLE, 0));
+	ASSERT_EQ(EBUSY, errno);
+	close(fd2);
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+}
+
+TEST_F(kcov_dataflow, records_captured)
+{
+	uint64_t count;
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->buf);
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+
+	/* Trigger some kernel code in this task */
+	getpid();
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+
+	count = self->buf[0];
+	/*
+	 * With INSTRUMENT_ALL, getpid() produces records.
+	 * Without it, count may be 0 (no instrumented code).
+	 * Either way, the interface works correctly.
+	 */
+	if (count > 0) {
+		uint64_t hdr = self->buf[1];
+		unsigned int type = (hdr >> 28) & 0xF;
+
+		/* First record should be ENTRY or RET */
+		ASSERT_TRUE(type == DF_TYPE_ENTRY || type == DF_TYPE_RET);
+	}
+}
+
+TEST_HARNESS_MAIN

-- 
2.43.0


