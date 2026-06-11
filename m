Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD71CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1286B009F; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889296B00A0; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703116B00A1; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE126B009F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29B8A90DFC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:05 +0000 (UTC)
X-FDA: 84868148610.06.031E2EB
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 334E940014
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=Mjlhshnw;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaeM3xQHpXxRiq9fltNVkln/dOccxRMDrYQW+wNikZk=;
	b=Lh+1kRZa3IR7mfHanXI6nTr+aglbJDveiWvvEVOCBCdDI7fs/vuiGI93e3e9cFuYdKRjGH
	0Ppm7O0h2wYSXJLHux8fCKwyMMoY8oeXFpYtWZHrAJShY/l0t5FJb4wNafrZGal328Y94M
	ASQaEDSYNC37ajmQQPhBw/kyC+KBmDo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=Mjlhshnw;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194922;
	b=JV0V5MmSRogCorpPPyQhcdPzkPQXR9auLMEl2BZ6uzlAN6Ty19GOovfKeFgUopYbamOgJX
	J5KRJ6jTgBz2hgj5nLwnyPkYB/TMvCBeNDZOK070VuqXPN3tscTWA6jzN5UuUVyIInGfqY
	QU7jgnZEaS8Vu9heND1mNtcHYpzdnZM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RPyrch2NgrEWB+HjpdLbdBkqeee8dBaKdWmd+K236HUTARMmHVSaLbYGpjBhK95+TNz8pVlcRu/2R2aisVQUwfUkN4d6qBME4VuH4BjefjYweVy+zLTuqGVuUsv73Q2f5dPEXYIC4+UY9RD3WuiuRj12Kw17WMqKRWXQU4L29lxi9ArN0tzZNFKuX78VKDp5NU5DDcSTehDbZbC4mRQ17WWYLWLkxvutgPhAGR6/MIN5yExa9HJhBSu757jBVzsmjY9MBeSWlu5A+XkcClzb7u6mpfgWpVbUY24nws49qjX/xVTD6KaZ2l0RqDLVanKKuMYl9OLUWabpP8tgkwo1fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaeM3xQHpXxRiq9fltNVkln/dOccxRMDrYQW+wNikZk=;
 b=yIgmB6bDKk64cvrYwtXoiu38Z1viqWY+TQaN2HhR8zYjkIpIr6REwTbNbMJnV3Won2CKsTi/NRsUNypxR97IcrsufUTSMc+/BHNyKz9FOtihu4bRz+3QTYGDUNabw56XGVQLZg1sqMIwOIcNqieunBDDasE5AAir3pvsiIImYakS4brS6Qnm6qKOPZyaZ5KAYP7TtNw7uw1TySiXpp/1Rf67dZf0z4dI0PC4dILS2jzXQ8+vPTcZsGGMYUI99pJQj17Gx/fdUcXE7eqyI0yYVD/hqi8PJTaFXbwlpMHCsxk+DR9zcNKPl6G3PhfKF7dfhETPphNNopQf3SfDiVlszg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaeM3xQHpXxRiq9fltNVkln/dOccxRMDrYQW+wNikZk=;
 b=MjlhshnwEKSnL4vjTDV+fxFckR75MImYh/gOad/l3L6YHkElt/L9r4bqjWds6fqiaPOISwb4SjJ7BcAglYlE5kopfJbRShi3IXjitdKP8uMko1GvkzB9bzpdPay6ITskjz1J79LVgTxAjFZ9g38zcxQf2sfqAOS8UkTEdDT+cWfKqzzmmrtUTM6x0NcF1kPsj9BVBylKo2feJsvocdnhcud1YMhGd/msyy2wOOvKZNRvreG38GWd6Ifse8xLFFCm3wWnDQFnJ5HsYDKb4Ft95NLNoiKaYTjC2Kwfed9XBpCZfQZggBYB1K5t/KJewPfJD/CDH74TM+L17F4PbWUANA==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:50 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:50 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:09 +0200
Subject: [RFC PATCH v2 07/14] kcov: exclude kcov_dataflow.o from sanitizer
 instrumentation
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-7-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=922;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=PmtegGlP3oC3YRD6P1kuj8eoKvWyzYU8JTA0aTpc6bM=;
 b=e5xstSMsJXnbXyB+C7adTAPN//7fQTeFH4ATtubzHpMsx0JK0Otu4HT3jDZy6qquKsRKR6sT+
 a4NAYtSFhCGCSzK79P1/f/gwkNtmL/6Rxjw78k/f4CQeCAzAqFPkjdn
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GVX0EPF0005F6D1.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::64e) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: 2454eb6c-da2d-4096-2b13-08dec7d58ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kd8j3nrOOqM2I54A4h2lzfTpkw/heKam5BLD2/SVdnsuNJTypk7CaTl3MR76ZECvPkXT1SLr8zv5tw1O4OG3cyWZZhvRGSfxLneSw28Bw2T/CVu+5Zlz41mJmZ+89hU0+K4MQeY+PtZrOxflJZaCT0dNH6qlMAvE9VMBk8pQeDaxwvlfuUh5hu0bUso5ZpH4+ORwYpbHK6kyE27BcIdQoVrTow/rrY7oew5liD2eXNflJMm7beRtOrCVbGc/cT03rDP30xyfEON109hTVIfqbp3IOF64Ybrjs87H7Rd54V7ew8y7N39wxr5IOj7lSQqk93pUKeyyUIQCxYno1Avw+Mo25mwT0dBk1Zl7Vd64iE/0RiGEtG2ZzDCcVC8ot7g2yzSrkuoephxOP0X8hK7fsZoOIp8yr/PiPlF8d/EcsAQnY5Yh9w2QWjPRiW/h0VJT6VqdnXEp3NU/xmV/mSMqq/SJ0/Fs6kLRthuRjpb6ByTjfHBIsCraR0EQB6p84Wpgl8Q7NAkyA4pGFxzxfFUxWAhz1s3JHE5k3MUGUP8yLdPBopqjm2Zj4S4g9CSZwE3a7b/yVXN9cDZ0DKcAAtlNbbpCXDRsjb/VhkKgtlmtjhTzojpwEHBWkG3FFHKcIoLC80jNhsOvB5HwcVjvOCWpRBhcHGZW4Fxg64gvqj6yDKmcQXrYyFn5CgmgL16SNzyeapnAEelis8wY3OneAXi4RYsqf0G8q7++pOZiW+ZLwbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkJSS0FUVHZBRkw3bWxJeUdDc29nR2FOektaa2tUWitOd2k3MFZvaWNnY29s?=
 =?utf-8?B?SEFsSVZSSnZWZVYwS3h1OHdLL3hISWo4dkJVVlNZM1VuQmg5bWVjdUdwOWlk?=
 =?utf-8?B?RXZoSURZc3V6cTNzb1p2ZCtiNkh1YVhZckNRakl6Rkk1T09waEthcElWb1lS?=
 =?utf-8?B?SWpOamxlMGR4Y2hzRXdoazNKbm1haVZIY0FaUG5Ic1QzTHRKQktCT1Njc3Jv?=
 =?utf-8?B?Y3NUeThIMmpVa2NpVThpVUI0M2ducjMraThXUzhpaWVYVWRQcFFPKzF5OS83?=
 =?utf-8?B?aXhvazFrd0MwTlRTSXhKbGtXcmFnVGZGQkNpTjdoTU9BTjIwbHIvWTBJNVA3?=
 =?utf-8?B?UUVpUmd2NEIrcldMLy91ckJQQ21CR3kzUzduRElrUkE1dmdpb29QTGxCTG1v?=
 =?utf-8?B?cUlaOCsveUlJWDNPZStPUVBVbU1BSUk4WXZ6SGdOWTNRZVBXMWRoanFPN2Fl?=
 =?utf-8?B?VTV6UWVGN0dHOFNKMEl4eXZxa2xWcWNqVm1pT3VHazJYWmdlQTk1azAvaHNH?=
 =?utf-8?B?SGZyc1FJYnZZaUV4Qi8waWNLejV6aktmSzlNM0VYNXNUN1NVY3Bva05YczE3?=
 =?utf-8?B?bjE0UUJkcTdtUHNHYmgxZnFKQ0piRUdKVisvd3MxUHllSzgxR21pTXFzN3dZ?=
 =?utf-8?B?Q2pQU2NkKzFEZmxyV0ttZnJFQnVjSStWWEpzcVdJOGlUeHIwYjFWeFg3T1Zu?=
 =?utf-8?B?NXVyMm9lZHQvbjlIWDFpYVNKalJzZ1ZkQU5RSmFGV29Da0MzQW9jY0tEbXVN?=
 =?utf-8?B?U2NGMmYyWTc2c2k0ZW9TRUhhNTZhS2Jpb29CS0V4QzNRZFJZbXNqNjQzU05z?=
 =?utf-8?B?SytzT2pGU1pGWUoxRGwvOXphRUtLV1J6N2FmNEdENWF4Y0FXSWlBL2hkSXRv?=
 =?utf-8?B?VFBaUTd0SkluSEI3VWM2VTZvaHhOdjQrRXdBYmtvMkM0T0xvakV0clNzb3FN?=
 =?utf-8?B?UTQrcGNHNlN4N1FaQjFxbGdGN3h6UmVSS0RtZFR4RTRlM0VYSmxzbWplSHQ2?=
 =?utf-8?B?VWdtSmRqeXdXUzlDcGFMVVllWlZhNFovVVcxajB5RmlyS2U0ZVZLTjhYQjJn?=
 =?utf-8?B?YUVjMWV4dGxpYVhFTFFDcWlBQzZRK1pZTFFwM2xlbDRzWXRqRGVaUFBXSGlK?=
 =?utf-8?B?TjFoNEYreHZoeXoxOXNJaUlGYjV2QWplQTVBaHlWc3loRThVeWNNQTFLZzJh?=
 =?utf-8?B?M1c2T0NjSzRqTUV2UTZXMGk4NVE0VDczTjZtNFBXZWRtdFRqNVRpUG5pY0RE?=
 =?utf-8?B?Z25OWW1xYXhXM3UxWTRuYUlmcWF2Z29YUXUxN1Nva1RIdHR4SzZTRlJUUkgv?=
 =?utf-8?B?ZjdnM3dFVENmVzBLRnNLekRUdkJ5bktmRDFHZEYvZ2t0V3Z6M0ZuQ2dsc0Yw?=
 =?utf-8?B?Z2NrQnBodHBwb0lrWHczdTJXTWxWUWxCQ1Bwb200Zk5zVlpyaEhEYzVYU0Ft?=
 =?utf-8?B?Q2E5TDZJbDF2ZHV2WHdQRzBhTlYzdDBrbGZXUHlRSlp3bFZpZWNvYVFWelFp?=
 =?utf-8?B?SGFhUVJ6aWdQbllzdm9zUktENWs3NzJOcGhDM2N3WHVDUE5ESnZlUlVhcUdH?=
 =?utf-8?B?VlpsR1MyNnhUVHlWajEyOFBwbGcxNmFTeFNVL1p3a0ZTcjdzWVBXb09lRUdO?=
 =?utf-8?B?L3pranlVZ2ZGVDR2YXFmSTg0ZXZ4RjlkZDdGbzFTNGR6TWt3c3lCcC95QnFK?=
 =?utf-8?B?OURRazhoOGtzUXkrZWxtbk1wSlozNzFlUitIZFZZVGZaRDFKVFRGRFZPeWRC?=
 =?utf-8?B?aWszVHZBRTR0TG1ZTm14MGVNaTFjelo4Nk5EN1dsSVdLRTh4d1k4UlJTblpB?=
 =?utf-8?B?STQxM21xQ013emRGOHM2K0RIMWZuUWwvdlF4ZkhQUk5MUk1Ld3ZuRDZaWEtK?=
 =?utf-8?B?Q1hlZEVEc2lGWlJPeGNNVlo1eUZUR1NUckRBT3daUVpqdUQyQ2JKTDgweS9i?=
 =?utf-8?B?UmNEMWRIL3RHQzhpNEt0TUtiaG5KaFJCbnVnZ0xOM1phU3pmZHVrWHF5NC82?=
 =?utf-8?B?bi9CMlpxb01iMmxaNkx0QjRCK3U3UysrdUxOcHkvcTNBcjk3Wkc5RUs1TFVr?=
 =?utf-8?B?blJvZjBza2RnRmFTNVRsQ1hCUmhocFVma28zcFlEaENZZ2J5dWdISjdsZzNk?=
 =?utf-8?B?S2FkM2wxWXRNZXA0VVNnMXRRVUFtZVR1M25VT2xXaUdWRUd2SEg3c3RsTFNr?=
 =?utf-8?B?eFlTOVYydlhyaWtHOTBWNHJkc1ZFWFViZUVTTk1EQk9iTzdKWjd1RGVJL2xv?=
 =?utf-8?B?ajg4dGtoQnR4ZlJ3dDhuY3NVVkQreHBDeVcvU2NTTkh0UEYzZmRUQTlwdzM1?=
 =?utf-8?B?Nkh4cEFxNStlNEh1bVArb3JndmpQdlp0TnJZLzhrc0dCUHlOWjhkUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 2454eb6c-da2d-4096-2b13-08dec7d58ae8
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:50.6767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUpn7b3SfIdLROAGs2f3S36enjvrUcgw0N14v/k8GTZDqr4OCLE24jiZgG5YBtmET3ATTy9aLbp9L5rbTs2sug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5s9nicptr9bbm8gpqy7o1ucsfdajgy57
X-Rspamd-Queue-Id: 334E940014
X-HE-Tag: 1781194922-651704
X-HE-Meta: U2FsdGVkX18H7iKMzduCsq+t2pj4pa+fWCYSGZmNAY1Pkia/RT/JPlJXFfQ78RVzVeTZRj0QJ2eNnwbzogUPfBy1QRRhrMO6JDqh8CpevXdQLAP/PZ7HO70HQqbU0n//rXCzCUjyblwRccB+Uipc5OHbLM+Jju4SIFqqg0gsF0UnYepEuWHVaZUXMElj0LdkO5owd2fmRs+swXnOjPndsK6I32+Ia/HjASBCJBESbk1GTZHd+mkQfoqx6z2IYaUz97UeqlpvTY+llMeUlYBeLnLfd1gWQmvbEgJ04/25StSrU+ScYTy08RDGA2BoJw/mQGZN4L9aQjVeZhDUMp8oREV5+nrBRki/DbdmkFoaqm1EnDGqTW3JCAvxi+3hXAm4p38L7Nw6Ij+J08xOdD9A3QA8cjIdbzwE6uvAk9zRfDP4r32tpr76G8FKWxs3nphvgvgMiCrPQDXqB6VV6A6ba4lBkO+sEyPEXEtL6nVvhZ6sOMtm/wYqul7b648yMyJrVwCOGqEzLf8ShuOo5i7DmDWKMqtcuTirraFv4vthqUwuyjcYISuGvWMwcgbzs2Xjbx/16zaLkpuTOFnAw4BL4dLZrrEuaYMmD5Qj6bZ2GtLSPsLV/i5is867SCFvhWRVvFp/gyddWiQkmz2x1HuQu4K9I0VKfoRa1n9DKWxWq06eE8xLWG1a0TEzeoWM0yVWveDkbV4iQwDD5BImVwdd50FU84vvOthK7BTOoaGKjJFXHBQKj6gsKIDmc+y+GcgFIhXoyrpESqDLPou70WxGLK3Ft5uLt/UxtRb35sO6KimdBEzGkq587qF9Oa3Rr/dDgEQn7I3dcktpCFmBRcb/9BOdm1IlHK5TaScHZU4suoN7Ql0TeRR9MpwycbTzXSOMzFeFT06cMxsXwGg6g4ly5xhcgHmqo7DOm1c0jsT53SnvlVZj0XcfWtpIzaR2BimP4nFRJ56eXmEldmqmsuN
 +x9awfff
 Qv/SS0fZrgoST1onTA2/mD2wWQzsFWoqx9lEYVQb+Y9Lg8RRjw9zFKZqn4sbgd8PKP66sIJ0UX9PO8KAr1MoWq/LPRg6isUXrE6f8+9fCWtnnVehij1f6KK+6YdqpN/nXDeaBdE8Iu9fIAAJfSZt8A5B/MaHNesYO2YXDUpSbFcwcMDz9j48hnUpXXLR2YslmWC94u2kraEo3NmUMGgfsnwoJvgjYq9f/k++TidEindJgnvOxBIqqBgSCZZDXIAhYXLiNQDLKBTPgvrOQVBuRC506h+9/47jswGLG2MXih5tc33y5QTY1iP6PjwPVoCpjpJW6ZGeev4cc/BvVoGbLorK7Y0CcAb8hot8GWG8OQk0xpmXV2O2SnJstrVMecsiNelbbFD1oFdWyW+A5N3BcZf+acyOEefYzOfECY3KtbufXzGlYn7D5FUdBO8yfRTZlv1wx5zDGWdsc/XYBdR95aRbcpNCarzsx7kL3kTJpNxoezZwvLNPwxAJM63IQjBMeiYvQgC2G/+Ae0vyjNb8ldyYkOFS2nEfUooGUZw6s9YVP+YDkayBAQzwB19VCNfo4CeZvP5xBK/s5l5+k+CoRbG4RD8eWBVnPRsR3azZApcL2nKRYhK+N41z6eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exclude kcov_dataflow.o from KCOV, KASAN, KCSAN, UBSAN, and KMSAN
instrumentation, matching the exclusions already applied to kcov.o.
Without this, sanitizers instrumenting the dataflow callbacks would
cause infinite recursion.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 kernel/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index b70e524c4074..307b7fd1e1f9 100644
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
 

-- 
2.43.0


