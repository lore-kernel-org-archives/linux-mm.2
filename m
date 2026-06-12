Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9F6CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 13:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9022F6B008C; Fri, 12 Jun 2026 09:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2F66B0092; Fri, 12 Jun 2026 09:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A646B0093; Fri, 12 Jun 2026 09:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688876B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:11:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18BE41C23BB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:11:40 +0000 (UTC)
X-FDA: 84871297560.04.9C3383C
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011010.outbound.protection.outlook.com [40.107.130.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3034E140013
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:11:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=R93ruRrr;
	spf=pass (imf23.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.130.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781269897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3Tfb03njXf+/e/LLWRMFEGwgElERiVP25dEeg4DjSc=;
	b=7CbJlo96W/++JurtKiGtfqaH19ktf206C+4a5OgpsnHBApqPRuNWA6cNgWVhWiyXhm4KRP
	zUaJlCKl96+XHLId0ZHOAW4KiyxcST5pyVmUqAczoFb8geoJH2p9vmDCvJ9dF2p8ETp/fE
	2TnoDQPxPyQrqXDojb0TyUqRGG60Hfk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=R93ruRrr;
	spf=pass (imf23.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.130.10 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781269897;
	b=GYuAV0iIn/2Ba+fJjD8QnKJPGx/g5ieCtmz/T5Jy1SM202PkW3DVBZQO5FIcSU6XMj+47x
	OFtROhb8NyNKb5elxPDzP1bFAxdkLYFY9SedpVUKoDhDNXw1uav+x7n9HKaCKvC29UaTEQ
	cbZf9Mp0A5kWUruXHw0I8yXIWH6CZdk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHTk3v0H7C2/JOahRdHIqg03H0kURjJFwuElMph5osEOzxJYyCh/q8RLqUXN7RZGps6+eymf6R1Jj1rFdk6oK44rcpjVfJSWgHgldJNNYCYOlYcirKWKNmqTIXnotNBwmb1sxzkL+xqMyQS7EZf2UoqV7g4S3Af4gta26RaPUHwSI7OuGxI29TdlMtIOhZCtNagmhaR4gFkGfKChAAt2AHwikxUJJg46/gnNIlxNpN9DnlS2Wk5/d75JeNs2N47UXZQEKXUq6Z944XoCYsjID+sZ6srwUR9MSfIgzYmQmxgHqXlGDORbkOALkWmlazgQMcyxj7xt58SgsjVIj6QW2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3Tfb03njXf+/e/LLWRMFEGwgElERiVP25dEeg4DjSc=;
 b=bYAUhqBFAZFJnjyy1UZyv4b/OBzY47bD+IanCqHDbhBCCLuuZn+VvisyiCB2/K3s7gWtJ8YYkX8He2dQ6rxuNKAZUwopMskV9CFZVZaYJsrG6pg+DnF2IJJsJWhhBNBa22sKM6Tq984/WC7mgy+iDdgAIBpLCNWrvu4WtDuJb6D/HKUHEZ11l9dPpplgEZ5cNhKAhbyijunqThzcnCtTHp6Hg0tldJXLoauXtRX3DhjMwv+JxxqyLGSelcpevdmGusbhI78wjzt55kE7vPBNhVVAmvdS71BoepXtK0a+plZ2ZO2QnY1BOtsx2qQfOZZNACTu+LX7/NMEdZkCwl28vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3Tfb03njXf+/e/LLWRMFEGwgElERiVP25dEeg4DjSc=;
 b=R93ruRrrhsac4RHK7l6UzcRn5d6j3Kp/61QEDdAk3UR0Jptwz2P6DBIDEbBzgLLG14c6WUdkvuHGb+ylBT0fB7L928DaTpfnxCyde8kXQq6w8xL+BKZ5WqP/cR7Qr2Kfyg0HI5gCmcul4oTkTvVmyeTwIbKErH/wBR7L4tre82YlAfVga+svtLbx4zdRqSsp18ITY8qpv9Thy3FVgWN6YIphHyCTw4hvE/EuP9xx5lX6MwUuo1cm2odD0dN8yjDdaF2fpytNLlXN6pmFLbaq/RGg8RctILzMwMu5BWIW7i5t1whslifnv4JE6iGrSeP10SDF2XrqFogZhuTjN76x8w==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by DB9P189MB2025.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:390::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 13:11:31 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 13:11:31 +0000
Message-ID: <de02f0dc-8840-446d-8661-928a49bb2caa@est.tech>
Date: Fri, 12 Jun 2026 15:11:27 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/14] kcov: fix INIT_TRACK race in kcov_dataflow
To: Alexander Potapenko <glider@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
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
 Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org,
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>,
 sashiko-bot <sashiko-bot@kernel.org>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
 <20260611-b4-kcov-dataflow-v2-v2-2-0a261da3987c@est.tech>
 <CAG_fn=V1+_xLgCZgdLnT7Y-muRO0CXkrNKkC8AzrqzWoL4eR8w@mail.gmail.com>
 <5fa7a528-a4c5-4fdb-9a17-1b0992e955b3@est.tech>
 <CAG_fn=XB7_zbjGzpgwEzm5dqcwehqvB+=SpJhHvw9QdETberAg@mail.gmail.com>
From: Yunseong Kim <yunseong.kim@est.tech>
Content-Language: en-US
In-Reply-To: <CAG_fn=XB7_zbjGzpgwEzm5dqcwehqvB+=SpJhHvw9QdETberAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU7P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::21) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|DB9P189MB2025:EE_
X-MS-Office365-Filtering-Correlation-Id: 023d9b6a-e6db-4a07-7f21-08dec8841ec3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wDbgI3n6vNz81aIr8zy8kaXv+0aEjafBO0NBeAz4ANYqVcKfvLKpVQlouJtuvUXbqD2GgcstNw0/AyfYeHiQiOGgK2POzKVsAxsoB7aaANQEN/ErIxeZmE3UmQiMcN9M+vuUXp3G89LUqxwXxrO17tjQMcUhNEpq3ntpaogXE4kF8JbK/Xzol/2MRypXVHFrY5M4tCQ4VNEQ29JbrMPj4imsc5g4+rAkqiMHIeiMcx7Yx3QWbWBk6S+tDxHIPHtka4OKBwBvDt6eBbEITU4gasToTSCVLVWn+dpFAkwUte7PYSEwebFNzepMnCn85XCVWhBlRu+5YzhEb5WhMTn6tBiwwVKDK+W5VSq5GPWodywdqvi53fetR8RR+vk5LR0G/e+xUtgDsfmcX8sPWte9oQopdGFeCRYPDpJ6DX9bcKpEUrudDjDiNuwkDo/1Yv8cHwpzIMT0k6ix7KyBkCDXvCEonLAxzKPQ/3hOP5cATdCZZCAWTzUjzRU2owt7JyIGmgArPrz1DXXofc20QULqPnCu4aj0rKeUaoxmU1rIyl3/BfcjC/T9D4zGz6ELpqd7WInON62+KhDJpP3MZMS9EbccaSXc2l8FP+UrAHRQkSrpzDUo0+pyyWjyzhhjau1rfRMDOAOOvhTzArM/u8MkTRnGvbNUMHCR11v5JBQGn5HSgjbn13vxlgBdOutrX46T
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGlQaUdzU2tYS2tlK2xwb3RIY0NTSWxtUGRwaXdzVUV5NU5Xci9LR2pPMU4x?=
 =?utf-8?B?MG5DMzdLYTFqcEFGVXNpVWVNZ3FHVkZycUlTeDRLbi9leWdrVTFZeUEvQ3lW?=
 =?utf-8?B?ZmhLUHZCTGhEUmVuK2dIS3grSFlMR2ErM2lGbjJZbGNaN1RTN2xpTzJLcDRZ?=
 =?utf-8?B?TU9NcExYWmRlMEVRSmN5NTBJTC9uS0REY3ZxZmFuM05ZdktlOXhVT1AwelBH?=
 =?utf-8?B?UXNtaHNReGhUYzY5STRoZmFVU2NXY1hMdlpzSHNjR3dMUmNobWpPekFTakJn?=
 =?utf-8?B?cUNmY2JVaWgxZ2ZKd05rVVgvbS8rbUVPT09aRWVEUjdTcm53R21JR3hTOUVT?=
 =?utf-8?B?MHp3dGtoU2hGYmFuRm45ZUdnOENIYWJDSmJJYmVwbnVWRDRBR2VaL2ErZXhw?=
 =?utf-8?B?ZE9ZWEROdndQbmMyVGRKNnRUenI1RENiUlhYMUI3V2duWjU4eEkySHhCY2w2?=
 =?utf-8?B?Q0FWRUVFRUt4anhuZW9yZExhc2ZVTnd3UWM4L2NWUjE4TFIvYnRReXRmV0hx?=
 =?utf-8?B?c1VSR2w0TXg1anRjaWIvSE9mMzlyVFV5a0ROMWU2TTM0d1FlZGVEUWdEbGZE?=
 =?utf-8?B?cnB5dXhFYnJhZHRhcksrMCsxRjJ6L0RNdUxldmZWalU4ZnhuYmV1ZEF0ZjVF?=
 =?utf-8?B?L21Cb2NvdGMyejhaV1JTODd4dEY5aFZybko1c3c0ejZFZE82bTlLcXZiTG1t?=
 =?utf-8?B?OHJpQ0M3TElTdFVsQXBmZ01BY1ZTQkxLVTFaaEJUVFJhV3BrT1h2azFjUFlu?=
 =?utf-8?B?K3FlWmVaY05kL0hLclltZVZzQVRVK0RqRVNrRUpiWkE3T3g0TURBbzlrWDZE?=
 =?utf-8?B?UWtNMTlwOE1wMWJqMGdHZ1hWUTJZV3h3WE0rbjRrTG94RGVQTWtSZ0pBOHIv?=
 =?utf-8?B?MXFhZy9FTkFYc0NJOElpNWlXbkhKcjVTbUlqb2dJbkJqbjJ2a2xoMDUxNEFY?=
 =?utf-8?B?QWVFQzBPVlZ2U1ozTzdIYUxFc1daSWtHWkxMenVsYm9IVHYzbzd1YU45TFFw?=
 =?utf-8?B?bjUrcjhONG5BNnJFcmYzRWRsbHJBL1kyOThtZEMvVFk3Nm5FaGh4WFBoZVgy?=
 =?utf-8?B?R1ZSWGpVNGUyVWI0QWRpR3h5SzQxVXl6eW9CY1FBRFowY3RMRjhiNGt5MENl?=
 =?utf-8?B?V01OVS9yUU1ZK3JSOWZGTWtQbVFLM3dBNVhZVlh5WFIyY3o4cXE4cGNCcWZH?=
 =?utf-8?B?R2dNb1dKbTB5NEtKSG1BY0tRSDN4Uyt4eGxETTk0ZVZUVVR4dWNnNHRac2Nu?=
 =?utf-8?B?ZkV5SVlnRDZaTSt6cXQwdVduYTJuWWlnS1oyYzFCYWJPVmRUQ3YyMytiVHlC?=
 =?utf-8?B?eUdWdjBWRTVFbWEwdDVmeFFWaGtBaVV5MmZBU0RoM1hlbTBaeDlla1hNRXlx?=
 =?utf-8?B?ZE81UEUrTVdaVWdSWmhGMkVleG55OVE5bzRrZVNHbWFoSGI2VHJUMUcxQmZM?=
 =?utf-8?B?ZFpiNUJVWG5tNndrblFIZjZ6VlhhNWNRVWFxRExQTjBVT09YUkROQ0JWOFU3?=
 =?utf-8?B?dVBUbjJvRVlKeEYzMkp6amF3MllUbDRRUStBOEQ0cGpSWkNiYnJvOEltcGpl?=
 =?utf-8?B?VXd4a1dnbTJ5enYyOUxwK2h2Q2RJUFEvRDhQS3hRM3hxNW9zczhoZDc4VkRh?=
 =?utf-8?B?eHNLd1JxV2dGVTJaMlo0Z2RPREF3Sy9vWExjdkVUYmE0bSs5eFlqalVkR2lk?=
 =?utf-8?B?dEwvYWhLUGpPTFZFY1lLZ0xIK3g2dVB5OEVHT3EzV055OTJTZ2MrUjV0VW1m?=
 =?utf-8?B?NnF5T0tJMy96MG5VVkNhcXFtMTA5eU5BVnhRc3FWYXc5U1FEUnRHSUlhajYv?=
 =?utf-8?B?S2tCa3BFZndJM0lZam5ObVBEYTlJMFlFRXVOVlFnZ1F4NjRWUGFNYkU5eWpy?=
 =?utf-8?B?cUNaNkV4cHRCSk5uZEl4SEN2bklDNTBMS2VIZnhEVG1qRFRGOHNuOVYxY3Rp?=
 =?utf-8?B?eHFWUWJMZ2Z2NDhVT0c0OGppUGFRdE83TzVXMFFvcGFIKzQrTmdMYlNCdVRM?=
 =?utf-8?B?OUN4azhlMGhZKzE4Z1BCRnd6TjdTMDg5QzhsNndDeDhCZFVTaE9YbHdRek5v?=
 =?utf-8?B?MWFLWExQbWlrVVZMSHZ3Q0ZYcGFDTTMxa0txRDIxVmh0Wm9HRW90ZFBqb2Vp?=
 =?utf-8?B?V1UwUkFGL0dEYzNKNXZyOVBZYjdBZU5ucW96TzMxY08ybEVJaHJDL1hjQ3pm?=
 =?utf-8?B?ZmxtM3hRQ1V4OVFkNk5jREdDcXdjcWdZWjQ0YS9BanFNVEIzZmU2bm15dG93?=
 =?utf-8?B?cXVUdE1OdkpMR21XbnNHNDQ0VmJ1Tm5JaXJYNkFESnBCWnZBTHcrR0hrY3Bw?=
 =?utf-8?B?Y3NjUHBJQlFwb3pXcUgyanhnMXJuN1h0enRRNnY5bjFnNWVLNC9vUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 023d9b6a-e6db-4a07-7f21-08dec8841ec3
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 13:11:31.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZaBvngE+jWO8OmOKJbYaVnQO2G6ot5zAc1NzGJ3RuoAjJG0P5RjTpNdCLmsvpPDRX89pyEL7rX0W7UZ0BmQmGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P189MB2025
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3034E140013
X-Stat-Signature: zene18wb3re5uns3os5abqmgnj4k5z3a
X-Rspam-User: 
X-HE-Tag: 1781269897-265618
X-HE-Meta: U2FsdGVkX19TWfKAJnytIdy6DrIfObWz1qa4WBqEZuMSNw4ePpBEHcKISJLDU9CCy06I5fLs4RTlmUBkkBduEpryy95YnxeSARUNQCBgbQKwHFq76NNxPeaPVYUL7RTBNsaPV2r+Y/5gMmdREe7CiRZZ7CGZTZyTpxB9UB5QhPuan/Ay/IuR9GtFj45034YdTCANm8uIfQRu60dzq4fGzRdSV/G1jBocmqvg0VmS7JYBNUiWM8RRBuQ2k9qlIhZg+cbdeTYO8RjU0WytTwPOgXvosZVoC+9RJDTvARiTOP6xydLHGU4PKVj3K4T6wNuOkhl2fCvsk/e09KcQpoudNf9zHfibiPcjpU77WxQzYUKMh6df62TwZTbbSXxgxLoao5+18RA7KZXPiYepW07WVLQL8xjbqi6BpaWkDFuz68y5YoPuiGmf3q68IHFkVGs4e/fabpdf6r1hdsdfbRQuj24ZZTsp9LP92qqCkPeEKRVK6HXVK/pkeXEs4RlxV5t0L1J8uQN3Fi4eKFIwyGDjl0jRT49aSe0e//6RtWlqrCyGgPgS+zzPeBxNa7K/16zsjdfiujPSC/mrz9rYOry7Jfu/tBP4Ae3AjGPqUlVOU5sq0SlsH3TNg7b/RRZ/MPXgsHK471zDQ19cPcN9KwbGxJgjMEFFd492vBC0QPQtgNANbRZw2NJXOHmefa5MdM/41Zci/pD6aoOBXfeQALg74CimoaubasoERt12t16DJsCmUlj4aa+pm0kHiUGG5hHqRvUTQfUkVz3QYzkay+F0yld7JbuOiHnl3ZSIAOqDBBrqidOmBsDAGE+ReKgyEJH6eHX3DloPJ2eVjaq3KsCtONmMGMXlVkB6VJQboNY6ppyylij27ouQtyweJVMhCUNF9cvnG97c5zROr1DzoMSRO2N++uCjlu2KzbAehLnJ7HX2NfkWWAnjHcPe4fNyMaHhlZd7pOUvh2bzuAPPV7S
 kIuv0apQ
 Y7KmpdS2B7XSMGGAiR3wfa3IRYJ3XtNLhffYUeBqaS81Z2WmFTXLW10/Qg9f4FFPPoQcB5JnteTO594HDhF8/ti2oA85IVeMI1lLIRgYh7c6p3IJeuKlo9Gl/ZF/9ToUS62nHWJHth5+mEWyD5X3DQbCVTWSn3eSV0ronC1nTy/eYWoZIrZ7Dny9pGm6PtrTU/kOvU9oE7cXO0wo7CC7m0j+9bMCczZdXucQrkDKhAhBUX+2XdhFZ1UAGOEkAIyVm5sGVG9a9ahdKzWx8DB/KwLmSr27jyQDqtpeLSH1ndQcu39zKazt4C0mHLbBxyikBRsselItPoepu5bd70f/w09Vijg7PkcZpUMnpumvl2Qly/XXKRkTWOvZwpvZutAILrT3RtYgLIRE/gO4iCOreUedlB6yly1p83id3TP6hSLmhazpmHjaDVIPJlw0SlOc8siFSADZkrxPQx5u+RPC1pCyP7DIVowtxwRobR6iO4e4X8KH4Zj9Kn8VYg3TqhEeAkukNV70sd72uQfAOkpSWjyiOCWMUL3utbP8WG3FDVXfemm7hqAJoTV+x8FfPUl0V5v1+6Z9Y3/LRdsMKNDaFHKudkKF3rfY0Tr+bNnf5/QZIcnVP9umZkRKId5cywUGqoum/VDqscDXM4V/kuF80WI7fnlatnJ27rfigLGY+j3RKk8Gzitlrnhr8tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

> On Fri, Jun 12, 2026 at 9:25 AM Yunseong Kim <yunseong.kim@est.tech> wrote:
>>
>> Hi Alexander,
>>
>>> On Thu, Jun 11, 2026 at 6:21 PM Yunseong Kim <yunseong.kim@est.tech> wrote:
>>>>
>>>> [snip...]
>>
>> Thank you for your guide. I'll remove it in the next patch set.
> Also please make sure to update the patch version. It's really hard to
> distinguish between "[RFC PATCH v2 n/6]" and "[RFC PATCH v2 m/14]"
> when both series pop up in the inbox.


My apologies for the noise in the v1 (Mistakenly sent v2).

I will ensure the v3 patch is thoroughly cleaned up before submitting.

Thank you again, for the review.

Best regards,
Yunseong


