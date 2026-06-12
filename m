Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F21ECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 12:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AEF6B0092; Fri, 12 Jun 2026 08:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7144E6B0093; Fri, 12 Jun 2026 08:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5466B0095; Fri, 12 Jun 2026 08:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47B396B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:56:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A5271C2D34
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:56:02 +0000 (UTC)
X-FDA: 84871258164.25.6417FA7
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013048.outbound.protection.outlook.com [52.101.83.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2241E100007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:55:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=NNGEDVxb;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.83.48 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781268959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eO/6LqX1ou4Z3VRKAIDsM3acu8fUnJgiHoFfOZKSXGY=;
	b=3K/fYHMrdaQpABOFgH+ZPx4eZOZA0USKtuxXHRqLoIHNQBw0bFi+kOgVKM6cidfIRnsFlz
	0E6riaMkTVW8F/b2p1wiQJWV/mJ7ERjrU2vwMDzdhbvhdDD1WVDb9u7V3cHKKr+cSTutpo
	+9TX6eZSySbliK1ksdHCdZUS7dK0A1A=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=NNGEDVxb;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.83.48 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781268959;
	b=12PdnkryqxE0CdecLglPRRrX1gXbgUx2bTKaL2PIQEXFDLhg/Et1BnpBzJddFt/fexKgSa
	6KWPUn5JTGOedLfvbx+IR+GjjJm2Ya//hgq1BN7Qoa0CptA/ILzdPzCt+yU/yf/8A0Q1sf
	JnblkzkSZ7c1RPseCS1596JuHDK6OTE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tDf5xsKvC5bzSBWImMZFlWpFsQZhddHtOgbRZ1shV7O75XAKrYEWNRacxff3tSJ3kchlkaYnS17wA5vxfXwM7UM8ir6PiYW4w4WMs8Yz7vR2kOV0hvOLb5MrerConRbT3I9oDlAfAcHT/IKdBJ1rqJKN2DWhu0WcqGlj+qJNQ5bJZwn1y2/CQAOiRq9xbyO7CuPGx4hKT9N1s5+ZzOLz47v2AJWmyTTbpV+XY2sYPoZ46OKgO8XY/N+T2BUTa9udIoL5FYFdvGGyqPb3mgZv6bqdAsfWFaZpOkQEHP3lVoTrwPE1JxB+igCjaTD1wr7BzfFqawycqKikYQIJYah3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eO/6LqX1ou4Z3VRKAIDsM3acu8fUnJgiHoFfOZKSXGY=;
 b=I4IfMNb3iO1UzmRpC6YJbF/6tDI0bcSWfDu0QYTiWnrKypsuA2+B0fIbLBCOq3J1r/lv9qhoYCq61sE7OPGYBb45w1yL9hW1aHlfrYRFEptTOUMCQZatqL9YpgvuArSac87ntz4hFMxUsrL6MnGMiyDnBnX+gkSS28DVlYWAbtZsvkm1wquaWcLPBM4e6n1ZYBwXSVHOH7xHDwmzrkHTEHm8K4pIHobpE4mOYLf4uxk3FxyDOlD5QmuP7hCJKMxS9gF8ElT782taujccEVbSGJGiMnfcIhF7AHXxGSbE8TLxAcWYhK+oz//DoEAlxQtBCBBQu4zC5gMo3VyoxWk/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO/6LqX1ou4Z3VRKAIDsM3acu8fUnJgiHoFfOZKSXGY=;
 b=NNGEDVxb83KibfO2+9+QsrD+wUQ0Xto3ua0ky92PSloglX9CkQ+Cgl03FLKj71OGVO9t4fAK4K5u09bUMZ7a215Gxz66RrrrZneHdCq75Y0UCPalfdKYsQ4XsxsnmMPeToaDMznNQqu7RMS2ib8coSoXTok2VgsH6x6O3kqAXn9IHn2awm1GSvCsa3rJ9F3UCbMmuuj0TWNH3D8/Am66niXb+Yb5WEVHbiyr92u1mZe2F6TgK6ADNRi/uCRc1KYhAlpHL+GX7XGU6LzMBGjTBU/PmxesbbqwC8m3zaCK8MeRfflJpIaYNV0wPDbTPzOnkeuk+3XjpK8wgOUW4pyPMA==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by VI0P189MB3236.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:2b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 12:55:54 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 12:55:53 +0000
Message-ID: <56f7bd56-db01-475e-83e6-65963974f613@est.tech>
Date: Fri, 12 Jun 2026 14:55:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/14] kcov: add barriers to recursion guard in
 kcov_df_write
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
 Yunseong Kim <ysk@kzalloc.com>, Yunseong Kim <yunseong.kim@ericsson.com>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
 <20260611-b4-kcov-dataflow-v2-v2-3-0a261da3987c@est.tech>
 <CAG_fn=XRzSuFrxtFbz2t9jjY8HPUUhhnU3iWJiSV-X4+hg66cw@mail.gmail.com>
From: Yunseong Kim <yunseong.kim@est.tech>
Content-Language: en-US
In-Reply-To: <CAG_fn=XRzSuFrxtFbz2t9jjY8HPUUhhnU3iWJiSV-X4+hg66cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0082.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::15) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|VI0P189MB3236:EE_
X-MS-Office365-Filtering-Correlation-Id: 21059141-36fb-4598-f95f-08dec881f026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|6133799003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	mBaOhkZLAGjNnmH3Tu8rXvMAuxONazSJ0VCfMd6Q5qTheCXEt/ZTGFv8G2SStr+FYlDtC+U68Dt4CpRZ1NTjRN5atCx2ZZchnZ6MLlcgGut6e+GmbY6c0PizUc1fENSV5kymfxMiW2l071h2BMcV8ttbhwNZ17WbvrJocyOdIKD6Iq++v63jCggGSVxBDSSKQ9e3l/bJOyz2Lxx7MuSmGcrGf7jXXznppJZjCkKx1RKwTc+ggSRFezzobBBqhRlVfvzg4msMZR0Dsd1uCI644uQbCFnAGg2AdfX0zUxk5SMy8f7F7EwAuql+7S2cITir6+Q1/O7KTKQTuAQ07HK73Z/D0wkpSH7fgeoqrPfpwPQZSS1JD7aMw4P3F8OXpJn7zimB/G6FgZFCVvi6f7kZGPpjLNwMvSXYYeNYZ5U3wIFPXGIhhvegvppBsupQCZG+hTmtgD4rXgE+kl26sgsPkSjDeVRvWrUVn5Ar432+wDuadt0Sjekgq/elWGkqXkuE2lAIGaaB+KBm/1hVHPhqgapQn653io05WQOOpB3r6bcgOkMeRP05sQx+ZBX/Y4BmnwN2DLoVNeyotCWNSXQvOws8HB63gPL8ciDZhY0fDKHZtw45rlc6PGr2VyiQwFy4IY3/Wnj2EVyy9R/zGjcT60semWJ76LC3PR6stTzXdLJy5GU5UjpFGGYC0kiYsm/C
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(6133799003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekpxcWVWU3J4dW96aHFETks4M3k0VGpuQzI5ZDFGeWxrL2l0M0NoUXQ5Wllr?=
 =?utf-8?B?SWhYOTBXblMvV2RsalpmZkdZcjJkaEJPSTRYWjNGeFk0NExzOTFYeUtnQW9B?=
 =?utf-8?B?Y3NvUS9UdU1Da1pJc0FtQkx1ZEhXUmthQTFXV01UaEtJZVJ6YVBGbk1NdVhP?=
 =?utf-8?B?ZmFMOGdXTmd1N3dXeWJLcHFIU1l5V1NIeWpMVDJKUEk2ZlBhZVJBZForWVpV?=
 =?utf-8?B?ZlBjQU5BdWgvbnAyZmRseGRGQTk1WWsvYXEyZzlpZmMxMzhkRGtaZUQwOWs5?=
 =?utf-8?B?eDBCR1l0eGU5K1JzL3o0Zm5sTDErN2hZeXVscHNGdko5WmdMd010MVY5cXVp?=
 =?utf-8?B?Z0cvMG1uQ041cmxMRExCU1NHZ203d1dRTllsaDBlYjA0Z1BrZ2FObXFvNTZu?=
 =?utf-8?B?Slk1ak1mS1l2YzR2SDNmYzZEa2lmMDc4emRnR2lvY3dEL2lUeUhJZ3ZPVHdO?=
 =?utf-8?B?YWc3STRwa3BRQ3Vpam1GU2xvN285SjZLMWdnZGFEQVg5MEZCK1hxeUdnVVRZ?=
 =?utf-8?B?dTdSZTZzU3RYOEpIWEZsUVl1VSt2UktjQnV6VW5sdFRHY08rNlF5NnlBcThs?=
 =?utf-8?B?SGY1eHJqbFI5bEhCd0tDUjdqUTRTTUM4NHRqU3dqVnJiOU1oZHVYZTZubDZl?=
 =?utf-8?B?TFNGWCtZUG9iZDkzbXdyYy9JQWdyVDMyZkc5QkloaHdlZ29xZ2VhVkVMQThU?=
 =?utf-8?B?QkNldzEyRmdZdjRSd1YreE8weVp3djVQTXVFV3FUZFlJU0dnMktJaGRKcnJX?=
 =?utf-8?B?Q0VCZnE1NFM1ZVlGcUpUNXA0QXpkekRPRENCeVo5QWxTTmNSWU4rZkdIWXRN?=
 =?utf-8?B?WVgyMWxGanhUQ1hIdWZMUE5Lb0dhWlcxaS9wQ2tnMUxkQW5sYWFKMlNETnhn?=
 =?utf-8?B?bGRCcDRBdW1qNFMrckJRdkQzdVV3NWdLSnkyU2p6NU4ycjlXWlN5MzRsVG5l?=
 =?utf-8?B?UEJBUkpPdlI2NDdYZCtOcFBvVk5va0svanI5bjkyb1NJR1RISVBMV3lBT3pM?=
 =?utf-8?B?bGpjL0VKV2p4WWk2RVBsSG4xdG05K245NVRuRTlWN0F0ZjN1YWgydzRXOHpR?=
 =?utf-8?B?NlhKb0NPcWtmUGh0Mnl3TXFKQXpxN0FzOHJ2TXNCR3VROVk3OVV0MnVudzQr?=
 =?utf-8?B?MHFsbjF6aCtxcllsTjVGc20xQlhhWFo1N3locWpvK1BJRHhncUNndzg3UHh4?=
 =?utf-8?B?WU12QURvNE9JbGZMSlkxOFFGOXJzZE9xd1FUd25Qdm5nZXpuUlBkRG9waXl2?=
 =?utf-8?B?MGRGVDFjeUc0ZUFhODNNcGxFNWJ3WEMvZ1cxSVd4NGtLOUsxNVhUcFFkM3BM?=
 =?utf-8?B?S2lEc3pYTWw3YXgzaUxYRlU1djlHVUR0eVpXRzRHVmdrRW55bTFodlNtWXVt?=
 =?utf-8?B?VWs1aXFlamNLY2lJQm9WSFJMV3lqYmZxTFlid3hqT010TG1IYnZ5VjZta2xQ?=
 =?utf-8?B?RzNiZEJTcnNBaTBPNGlHbUdQeVp5Rmpia3d4K2hTbnV1R1lxUFBoR2VvUUhk?=
 =?utf-8?B?UXlOMnk5czdsejJCL2VBdjBpdkxaTXdsM24rWWtQZjU2Tzdib3pGY0VUWnRZ?=
 =?utf-8?B?eCtSeDZUZ1M2ZjliZ21PbzNuRUVmeXpxTDlJdWpNRngrdWJvNEhsSyt5Uk9B?=
 =?utf-8?B?QnE4ZjFybGlVRXRscWJ0eEIwekl0N3RxR2llQUpkaTV1WXQvUVVTUVhBOXM3?=
 =?utf-8?B?eTdsc2ppVmsyTkZRUXNWRlUxTGxXWHZYelllVVFlcHhrT0pSekxhb251M1Fz?=
 =?utf-8?B?VURHUitNQTVKOXNyNndWNUFJL2dSTUFWRFpqaStUclRieXBleVNQWDBlOWR1?=
 =?utf-8?B?eXRKVCtRQUY3dUU0NHU1VkJvNi9TRGQyckNYY3lHYzM5cWtVdU1Vdm5XdElZ?=
 =?utf-8?B?OHgwWU5wc0RQZnp2OWVaZndXcWQ5aG5ZMU93Y2pBMFU5d1lmTmoxdEpzaytT?=
 =?utf-8?B?T2hBc0QwSlF6NkFEVDN5Rm1kZW5TVE56RjYxczc0Z3I3OTdyYTIrMUdnamJH?=
 =?utf-8?B?OTl2b3pidzlnSkV4M1I3eDEwemVyNHl6NnNqSjB5VlQxUGpiZlBUNFFzc2Vr?=
 =?utf-8?B?M0ZpeUF3dVFxMHdJSFdWa3czOTIyU1N2QXhZYU4vbFZjblp1QVZzQXc2KzFE?=
 =?utf-8?B?RzZPZDVncVNOcWwzMW82dzB3WFdHOGdkTHBUVDFxUU1yR1BiMUFzcERnMnNC?=
 =?utf-8?B?Z0ZoNks4UXFrc2JLenRVcnI1RFlIRnR3MjdvYU9SQXk3cDNmL3J5VXdBQzho?=
 =?utf-8?B?Q2xPRS8wZWpYaGlFenBvbmJZaHVFU0dBZllwUFhsWkhmL3FhWDEwYStUNWtT?=
 =?utf-8?B?K3k5dkF4byszRmhRZmZJVjlpVjhsV0c0NEEycjcxbFNsM0FQU2lqZz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 21059141-36fb-4598-f95f-08dec881f026
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 12:55:53.9566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZL1jHNSJseZfzeNrUNcvuzkLiXvCzovV7SbsVJKhprtiKwUZ79sUjryNmA09XdqIpTjqFAvAOp3512qLqgKjdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0P189MB3236
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2241E100007
X-Stat-Signature: z7p58wyby1cx5n8ymuu44zj5866wxbgy
X-HE-Tag: 1781268958-963931
X-HE-Meta: U2FsdGVkX18fg7ruJUmYVkWeVtZXPKTRg2mYHrzCSi7Ik39VdPkNuwW7l+CNo0bKVEXQvvBNWFncF5z5VNBD5yDJDLOss87cgPka7Rq5mRua8673qPsho7Kx/WcwfMzEC9QURMih3GN7xk7PVoP9FL1jc2IAJZiypEyaDQJ2IlBv1MaCH5TZcoPCsl4CQ/6w2ys2fyxFuvzv+GcYX1WzlkA/zbKQgYT64xc9IWPfVqNIpOu61GSeqI5LkV2iQnGlk7ddmqR+7sSMeyh7eSOHYptzXv4XtiJ9sh9XiMzTJV5xz7KjPUV93TARiCFV6JjdorDyIFkkXsFBdmWZ5eUIfX1pJINGRMU1rkligEabOYxcMR1+rM29RAooS4G4hcqL8RBKyxrdPPoBxuEvCl1T1Q2fN+wxVOMEW9WfghdCv8aJy2HxEflaTFErf4p8D2ZIEeGKD+3xnETrM1HuYf6/WXytcoIr/z0t1g3etZOsR6t36xlc5WTsZwIyAQWPTOb8gqSkYrsbgziET8yRCPXycN2e4Wvkkxcgggl0aKUWpBdJ5Iud3oeduHotohqJCgxNl9vqB1fuwZDnT99HAabwY6cGFpEyydIdrKkVrbke4rAVv84KIR8IwhVJTJlr31C55Nn49zmzkQHaftmQrVSlbwbGUG6JWsGH0z5MoIRtLt6On9+3exRQ7RvGfzefsa2bYoL/Vkx9JYr0XJ+S0u4Z7ikoozNeDWG9SGrQgilSl52OA+QrrMTs9RX1wAqz21g1SKSJgB4dDU+ri3Y0PYNgQVviKUxPJQ6l9guzehNshKU8I6qrM6X0V3LYAeKyfTmPp2TG7SUrlIVKzeShxEXBoS4L6BcxjkfmnxP00pdgjZi/DRFWeEEBrH8cufuBwJup8uyW4eMw+5PVK08dppbY15ck/V1YRloQ7Ts+Hhw5gDYXbVjLdHC7M6BIbU7V51l+R6TRmBrY1Q9du0r4jz5
 uMJj4LUm
 TXYuwZCCbtdKMdxteGS9dRUzsuTiB3Ow1S+UHYAinIlCVRYwRZDBganU0/uKgRIqH9oJqAj1A6t2SEqo+61NXOslU4YRhTjGhYHAAGIsnmvJ9FSo1FhJU5q1nVPA7fpvyFDXBGEyLVM/58ZOfTAaIaSdvq5Fw+bIgG9btMNOniNhQZFh2xrdazR1nfqRcG2E/6WBkOtbt1SfDPzshlrFTPZpFYDMjJrH8vlfsTDAENzUIwGeRQXRzwcUsTCT3HzxWPuZF5YLK9kAP/uGt9BcsTMuFhp3fOl76vymzzFea/RTMumSvNVAIIHgGZLo2MtHgI36BUSVWKfto96Bybopmdw4IxgUt6MtJ6yICRHWV8SWxMg0AulyymzkLDyCqxW9ESIndjKmYyjZcFzJPigtrtPKundbZureGKErZHTr0b9Bb+9K5AP05/OiDH/94lcl7HgFSaPQElAzUinh2ZaigEAJhUgMpuNiFXBSyaaxSkMn4+tTAzVzdrYtvDuOFZXHMjxYZij8mMqHopSZ9oOxOs2YeCFqV2Kyuu7uYihJjpUeyOknGyMv0AEgV5jQu42hyETeEfxPeUKmX0oyTPzVJs0u+XGk5mLVrW/E7Jz2gyQZad9+r9ysSQ7JtpxioR7UrBeg3k1fJC0AB2eCDiOeePtbaDE906eFqkXk9TlsyW7fw2xRGE8jIlMhancHQMi7qe3wYLJWenDRe8+oAW/7MZqJnTzibO1wQgq4+AcUHgR1SWkQfZW+e+JP9ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

> On Thu, Jun 11, 2026 at 6:21 PM Yunseong Kim <yunseong.kim@est.tech> wrote:
>>
>> The recursion guard (bit-31 of kcov_df_seq) prevents reentry when
>> copy_from_kernel_nofault() or other called functions are instrumented
>> with INSTRUMENT_ALL. Without compiler barriers, the guard set/clear
>> can be reordered relative to the function body, making the protection
>> ineffective under optimization.
>>
>> Add barrier() after setting the guard and before clearing it, ensuring
>> the compiler does not move instrumented operations outside the guarded
>> region.
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
>> ---
>>  kernel/kcov_dataflow.c | 2 ++
> 
> Please merge this patch into the one introducing kcov_dataflow.c
> 

Understood. I'll merge them in v3.

>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
>> index df7e8bf70bfa..5248293280d5 100644
>> --- a/kernel/kcov_dataflow.c
>> +++ b/kernel/kcov_dataflow.c
>> @@ -86,6 +86,7 @@ kcov_df_write(u64 type_marker, u64 pc, u64 meta, void *ptr,
>>         if (t->kcov_df_seq & (1U << 31))
>>                 return;
>>         t->kcov_df_seq |= (1U << 31);
>> +       barrier();
> 
> Please make sure barriers have comments explaining which barriers they
> pair with (see kernel/kcov.c)

Thanks for the pointer. I see the existing implementation now and will align
my changes with it.

Best regards,
Yunseong

