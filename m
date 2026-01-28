Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0925ED25B78
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC7F6B0088; Wed, 28 Jan 2026 08:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440246B0089; Wed, 28 Jan 2026 08:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F70E6B008A; Wed, 28 Jan 2026 08:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6F76B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:30:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5AFA13B68C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:30:55 +0000 (UTC)
X-FDA: 84381458070.19.705A02F
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020098.outbound.protection.outlook.com [52.101.196.98])
	by imf02.hostedemail.com (Postfix) with ESMTP id C15DE80006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:30:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=n4t1bTA2;
	spf=pass (imf02.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.98 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769607053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCKLJ6uinYhk/7da3OMfNhK+0YreNEOH1b/QHp9nX4w=;
	b=YIrR8EyIQJ2en9r7SlyTgaHbmdbEh74vefTzy5d2EEA5m4XgvyNhT4k4Bf9D4nnXkjRlno
	l4Gl4uhLTTdrHicRF66ob/I93x5+91SjwfG5CuzJYJLzFskPxhUp4hIkd816WQOOxFB425
	vEyUEX61mQIjRb7fPsZqtaxZ1h4/+Fw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=n4t1bTA2;
	spf=pass (imf02.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.98 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769607053; a=rsa-sha256;
	cv=pass;
	b=F3jaY6z8jcM1OE8GIfpAI5kGyVLY/MgpUnbPVKWHErNyLjvm1KP3JLnkJKXj3GsSe5Lj1H
	3DwKvHq25Vtwy/B8PuZQRzTSRmZrbY8VW3ms0Tl+mGDrggsFGIC0Z/zFI4FWLm3M3SD3qw
	ScJ6irhtKe38uR/vzKZsdYI5yqLQKvA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GYKqIxXBhkjkvHhkeYNqURPUFrtcQIKijhDhQ+/2VsN8jy8ec5c1n6q/B/5Qp3hCDcubyWsv7qaNOsq5/lEYZ+T5PhM4mZfmBVM3m+OzB0a2E4+B9aKcC6d+T2kOsv3EWuirbfe1bzr1ClZdvNbqQE7sHbstQ4p3gG5ONSFwuF+ersHQzG7w0/xl7+6iWgDOZh6p0fQDDmobTp2UI8M8DIORkJ4FQS8ZRMR7Lh5VAfYucW2WZ3PyDTG16OwHFZ7/fNCqRItNPIXdz+cdV7apJpO6M0eQVUxhgji0d0iBmc0RmmmQLwv/wLywud8UoKIToHDVs/V6ENirqOZd9nakrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCKLJ6uinYhk/7da3OMfNhK+0YreNEOH1b/QHp9nX4w=;
 b=px1skiiTCgA6ZgT7zN/fh+SvT+aGicsdP3BmMSbLivUMlfaiDNh706eiFcoKmqShf9VOXyhKFYQJkkOdGZdgd0SnIU2gaOwjmVxujFKwZe3MaRa/tPVlzwr5PV/6DvPLGiedI4hKesXWpzDDUF6LGa8SQ6ocH5caDjGeepOmNaTn3E8c+EvHbjNa4vCGPFXS2Ic75gAcVDC0mlDh/7GEaTW7AbRXZ53xIJh+80Fh4uznva3ndl9aA0JQl+1h1LvkEqvK3ZlqhKp5KIC7EB03GRpY8Qt+viENQap9ij8tL2ADnAcRFlwCgXPRBnsj503vcJ3gfV0bt6cxpYn4/znzjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCKLJ6uinYhk/7da3OMfNhK+0YreNEOH1b/QHp9nX4w=;
 b=n4t1bTA2TwYH+6oaA6rGMAbactqzexfUP4nOFuuJCiVoX/jlZlj1C4o5TnPipqVDwhECOe0NsNYvdCbg7cVt9+/qfIWrhREx8pxdGSnvXQcuGiAwWibAU1WP9X+UeEd529B8BzUz4JuZHaRBGoBsi08jmlyfovtYPo2iqliu/Kc=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWLP265MB2146.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:65::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 13:30:49 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 13:30:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Jan 2026 13:30:48 +0000
Message-Id: <DG09CF1T9SQA.2LKBUV75ZPS1P@garyguo.net>
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl"
 <aliceryhl@google.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>
Cc: <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: add `from_raw()`
X-Mailer: aerc 0.21.0
References: <20260128-page-from-raw-v1-1-b837bd3e0545@kernel.org>
In-Reply-To: <20260128-page-from-raw-v1-1-b837bd3e0545@kernel.org>
X-ClientProxiedBy: LO4P123CA0359.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::22) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWLP265MB2146:EE_
X-MS-Office365-Filtering-Correlation-Id: 97bee4e6-49c4-43b1-0b4b-08de5e7172e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHBnRnZ6UFZVM3ZHNjlVUWRCNlBGWThMRGtSK1FRcHY5bXUwZHJLSVJmY2dI?=
 =?utf-8?B?VEU4MUJsV2pvSW5GVTdUQi9BdG9DaU5ZUHBEa2s4cVFNaWRISDdUWHgrckNH?=
 =?utf-8?B?S2I1SHdDb0xDamJYWXlpZ1BDcGhjMittSWRkZDJ0bE1qVWxhbDh3MDBoQkp4?=
 =?utf-8?B?Y0lxSVhxSS90SURZNlBPcjhxQjR6TU9UcVpqak43YVpZN2RVZWJzaUkzOHVX?=
 =?utf-8?B?b05YeEg3SFN1enMzbWdqMUtkK0FLZ0NhSmlNdHh0T3c2RjBLNFZsdnZ1SWR6?=
 =?utf-8?B?MmNzY2RUMHluemhpM3dlNmdGRFZvNGtjU0xOZUY2Q3hPMDJPZzZZcUpxTzNP?=
 =?utf-8?B?QzRVQ3dqSXJ1YjUxZFFXaVU1L25jQkxYcnlyZkZHS0xqYm9xeFRYM3laVkR5?=
 =?utf-8?B?dFlUdlBUUncyVGJFQk1QRFQ1M1cwcXVQbzQvZW1iZSsyZFZqZW9CS2NBZTdi?=
 =?utf-8?B?Q0hkMDhKWjRhcWVVSWVTdU5MOUFLRjVWMW1kckN4a2tvRXF3VnppbWhHT2xk?=
 =?utf-8?B?NzhhZ2tWWG5pSWJMa3lCR201Y295akNMSFQ3bFdKbkMxZlducHBGQ3pjVEpa?=
 =?utf-8?B?VGxTL1FZNTVHZ3hkNjVHVEIxdlFtZ0FqZ1ZhSFMvVU5CM0R5Q1g3NExWVmcw?=
 =?utf-8?B?eU1SOUdHSGUweTY0c2lTV20zbDNsWG1SaFgxWkF1MHdUUm15bXVYaWhlUjha?=
 =?utf-8?B?TU5vS3JEbnFNc1pad1dKZUthWnd3RnVWanJWTVZUMy9mQlNhTzVacXhvRmlm?=
 =?utf-8?B?Qjh0aUtCVTlzdkE2MEYvZjAyS3JNRmNsbHJZYVF2SVdaMzg5U0o4QlZadWNX?=
 =?utf-8?B?MXZQL09vbVl0Z0o1ZW5hS3lsWWRxR2dhZVJFVHdOc0NTZFcweXIyQmNBKzZL?=
 =?utf-8?B?KzdXYm1NQ0FjR2ovZ21hampDMXlFZWFxTXV2U2VUUTE3UlBiK01VRnU0TWxr?=
 =?utf-8?B?MTFtWGNSMlN1a2JISzVoRFI5OGZtOU5NU1F4dVZFa1p4VUhKQVA1WW1VOVVa?=
 =?utf-8?B?dkdKYmN5SEdRMTNRWDkxYzNFeTc3dGh1dktRbzEvTER6VU1hbGVNU0ttSVBr?=
 =?utf-8?B?QjhESUVxczJLaWZEbFdjK1p6M0xXeGIwZzZ5dzl1NC85WVZ3aGVhUlRHMTJF?=
 =?utf-8?B?bXltRWZ5c0xlZGl4b1kyejZ3N1RIdzVLQ1lkcUtVSThqWU4vWHNEQW5tNXgx?=
 =?utf-8?B?UEl0RnhKMjBuRkYxcVQvRFRScVYwb3pLQkJEOHhXUnZkcmJzemdhR2x5VjFK?=
 =?utf-8?B?SkYxaC85UFRtUXp0WWs1cUZCaHdVdEdmQ0RiNFhGTG1ZYXphbFdxbDk0QVd1?=
 =?utf-8?B?YlpaTDZCclRiY1dLbHduMVVCN0RWMzBGTEZVei9yclZmZEEzQ09CVVpILzVN?=
 =?utf-8?B?N05kM05uZDcyZzV5cUVtZTF2YnpkdWt4WWJvdUxwNjRScHZQamxZQ091bmNZ?=
 =?utf-8?B?ODVyZTVJaVRxK0UvTlVmUHVaS3EyN2Q0TDlWUW9pYWxvdkNzUlBWbFJPNkhI?=
 =?utf-8?B?d3hhSmlvanpkdjA1RzRvUURxQ3BtbzNlZ2ljeHVPSmtOOWsxaEdnMVNLcWRx?=
 =?utf-8?B?K01zYjk5cXVncHE5ZkY2Z1dhbkRiQXZYS3hNV3dud24rTXJOVThUb1BudGpq?=
 =?utf-8?B?OGYrUEluWjdaaWxNRGZwbTV0Vk5qczdJUGp5WDk0K0hPS3hrK211MnZHQnhw?=
 =?utf-8?B?MG5tOGlWZXFSM25uVWVTWHNtVy83OHAvczljUmkvdElUU0E0M0QrU2NRMlZa?=
 =?utf-8?B?ZlhMTHRFaHhCR1BrYmV3S1VBYStrQmNqQ2ZSdldCVWR4V1dqQktLdTd1Vm1y?=
 =?utf-8?B?SkdqVUEvNGJqa3lHVFVQeVZXM2ZZZXFKeER0YU1oTXlleWhzcU1vanp2TFNS?=
 =?utf-8?B?Q1Vvb3B6UVdvK2N5NlA4clZuUXd3WHNYNE5SZVJkN1FTcEh3SWo5TTdCTVNU?=
 =?utf-8?B?OEtCamxCSFVXWFEvZFlhZXdWY2lkVTVteStyUDAyd0NDT0dPRWMxZjdZUTZ2?=
 =?utf-8?B?Z1NNMC81cnltM212ZE9WWkRUL0huMUROSjFoRkFEay9Gc080MGprL1V5QXhF?=
 =?utf-8?B?VHI1bHkzZUZGM1ZxYThFV3kwVGZKTlAwenB0dEdUbkVOUjRlN1k4SVJRQTZw?=
 =?utf-8?B?OVBoNTRFUXJqdHUyaW5EbThIU1M4VFJzMkE3R2NuSUcxL0VRQlNHeHAyZHV4?=
 =?utf-8?B?WGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVRWdUlPNHM1UkZWOUkyUjMvL0lSWHRuU01qWC9EMnE2RVBwcUJPOVlVMG14?=
 =?utf-8?B?UFpnYzdIeGJKYjNZaHdxWWYxdHlSVG84R1RHVTk5SUNvemVpOXUvSi8zVnk5?=
 =?utf-8?B?MGUrR0tlVmdJc3BpakZoUXczVjZwck1XcmhpUFgzQ2FHWDE3VGx6Vlo2dVJK?=
 =?utf-8?B?L1ltZGY5bzk2S2xhdnhvdGFORU9tb1JQY1A3bGRhSE0zWHNKV1p3bFVFUTVl?=
 =?utf-8?B?UXRZd2xlZjZZZjdJeEZZSWpCV3hIQkxqamJ2b1A1YWI4WWFBTEJXeERkNWdV?=
 =?utf-8?B?cFdYS2N3YUVLb0pCSzVjODlvNDF5ZzRjS3FocEE0MlIxdUNLaExHSTMzSTFN?=
 =?utf-8?B?enNicThzaXMxTm9UQ0h4R0Z2OXlOUVdLYXpNZURtZHJTUS8zSy82ZXZidXJG?=
 =?utf-8?B?cUNWVHE2QXRPdHNiYjNqRGk2VjZBU080dXVXTVoxSHErU1JwWi9qdHN1aDU0?=
 =?utf-8?B?QzZFZG5hQWJUdWhoT2xSRmdFRkxvM21PNVU2ZndUWXJyZmJvRUxYUWg2SFE5?=
 =?utf-8?B?ZmtCaDhFakVjZnJvZFJ2NHBCL2x5TGxKRlNyNUdsa1pZOCtFVU9pRGl0UW1P?=
 =?utf-8?B?STEydHdYYzlVbURyQk5Zb0dCSmdwSUpSV0U5M29VR0JkcnVHUmJzcHM5a2JY?=
 =?utf-8?B?M21nbXhtOEROTFJWSjMyT1FaUzFPcDdpdUdGckd5aEQweDcxSWlmazFHTEdr?=
 =?utf-8?B?OXdncFVzSEdLNGFGNHRNeHJGdGIwQzFudGNBYUtseWhKdFhzT0NaQUl5V2Fo?=
 =?utf-8?B?ZUI0ck5TZEdPd1p5YlE0N25mL1BoTVg2bDBQWTZ3eWQrMXlIejYxOFdJUmt6?=
 =?utf-8?B?bFptN1ZHUC9aanRqZlAyQkJFakFiY21qek12YWJDTnhVRW5qUTRFWVhISkNS?=
 =?utf-8?B?OXBnWHFzZXJLelBuS1gya3Fhb1kxZzlXTk1ZVmxiRHo0aXNQSmsraW9OR1ZG?=
 =?utf-8?B?K0wwMEx5QllYeGF5SnlRSG9rblZCdkNHOUducnFlcFlNZ09BYzBVZ0RVZFVU?=
 =?utf-8?B?YUlaM0dJdURrV3E5bGtWMXJjU1JKeksvRzdKSEhaOEpMOHRTRFpLWW5NbXRG?=
 =?utf-8?B?a2FQbnlwTnVuRUdUVU9RbG5RbGt0bHBDMk5iWHFVYjhtT2VuL0ZPckpmVDBm?=
 =?utf-8?B?OGR2clllQVNOMnk3WndqMmtYZHFZZDE2QXhMci9pM2wwaStBNmwyN09WcG1q?=
 =?utf-8?B?eFUyYjhXVmtteGIyamduaUZxQldVUnJSZmZDaE81OHR6b0VHV0FWNHdXYkdz?=
 =?utf-8?B?QzBFeEtNNzRVYmFJUDhzSjA4Zmx6S1NjQmJlemhCdHFLT29meHd2Smo5SHVx?=
 =?utf-8?B?Y2lrbjNPMGt4QmI3NmordndjZm16M0NiOSszTTNoYkRYZVJQNG9OTkZNZW5N?=
 =?utf-8?B?dTcxRFFGKys2ZkJxcXlJai91UVB5d0p1dVVGcGJzcU5CcWw5Z3R2U2Zzc1U2?=
 =?utf-8?B?U3VHNlorMHIwN2FMUTBSLzZaeGNOaFIxNUh5RkxtdmEyck5mYzR1RHdzVzR6?=
 =?utf-8?B?bEh6MCs4Mlc1bHBocWxIVFFuc2FXRXlvRlBaS2tGSHQycGt5RHRGUkJSQk9B?=
 =?utf-8?B?R0FQajBEZXFaWkpBM1F1RExYc0hYVnJEVGhwRjdWTkI1aXFZQnVsZGxpK0Yz?=
 =?utf-8?B?UTVoWDl1czZjWHYxOGxQUTZydUdyOWJHRGEvWFcxZHhHTFp1eWdnZUkwOGFr?=
 =?utf-8?B?NHZ0REsxVjBLQ3A3VGpZUUVCVG41aGpERkV0REJQbTJGdnExYTlXcWNkN2hT?=
 =?utf-8?B?eTR1Z0J3cGZRSk9mbUNYRTd0L1hQU083NGZHSXlMTGNONkNoUHZUYU1OQU42?=
 =?utf-8?B?YlJQUWJDVUZieC9kTmYvZXJDTkcrcmRWbzAvejlFSlJZbGN0YWdDOFkxaXJ5?=
 =?utf-8?B?UWVyWU4xS2F4Q0FHU3FFK3F3dXZmQ0NLQ29halRDMlRidXU1eUs0dzNzQm9k?=
 =?utf-8?B?SGwvWVpRSTRzVi96QTNtV2p0ZjVyUDRNczRlTVNkZkxzNWsyejk3NW9QV2po?=
 =?utf-8?B?cDJKTWlObThoY28rUlIwV25KcW1DcjFtYWp6UlkzZ2VkQ0t5czgzS0YrK1lU?=
 =?utf-8?B?TFNiSkpQZ0ZCZHZ3QnkyKzlRYXpoQ3ZLb2JGa0R3cmFWRzBlVnRhSnlzWGpt?=
 =?utf-8?B?aXRWNHc4Z0Z6aGtjNXI2R3NQQ21UZklvTkovN1N4bDg3RHNOOHdJUVd5NC9P?=
 =?utf-8?B?Y3kvK3o4dXMwNHgvZWhScDFaczFDcUxFRWk4ektCMCtTYVRHRitVN0hxNFN1?=
 =?utf-8?B?VUFETXNmSDdZbVZQWnFqU1JKcE54dE9xZWZpbkVTWVZqRFNZSnJaaEZkZm8r?=
 =?utf-8?B?VVFZd3QzcjhaSXN4MnJmKzYxV3ZWUFZKSVFEeW51QVRNa2JMNDR6Zz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 97bee4e6-49c4-43b1-0b4b-08de5e7172e0
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 13:30:48.5741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2ZAmKu7CTvp6nLpkqq4npiDQzN94ym9y5Ax89l2WKEZ/Z3zCG5TT3FGsPDgSP+V5+i45gbQdUVHGy2Qe1lMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2146
X-Stat-Signature: m88whafjg9sp9iqzb8g6f5uw3cof34gx
X-Rspamd-Queue-Id: C15DE80006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769607052-47287
X-HE-Meta: U2FsdGVkX19dzZBOC7pFSzFGfrhlZyQWnnVoFP5/dUI/4Vwk4kFRaVy3go93etNkpKxY2AYFFukOyR/6IXQNlf/VC/q2tALEDa6wdCIv4kjlPxqGaCvgnUy1kvMaXDKlD/cs2mEZMUCPmGDIH6otYBycLaald8EUPE45CuEw2yFlwDaA80Q/UC9ObL0GC/tRObRAbZ/qsIrh2BrOJN3MsUcaAdTF0svq6ojHxgz6h4ssfEwOOGJNWrs3LV4lxzgFsBB/bYOZBx0fVnl/4jjqurcFgJXwa6fPZaxx06wzTmehmbYDykdaoiIUVJzOUgGIYf+/RbVU5dYgp+TEf7ISFbULaj1hXHPVKiMpnJifmsHDbb1lT9SOu3Cmcyoz8tu7On3KlwiaiSB7FYizuPex0LomGX4cADql6xOiwUBE4XSQnVnlQefZKrHaO1nHVRu5om2DxOgVgkq6TpfpYfC1JJPQyX/Onv9lYu3NhYaxKMx2775iw52qpxDyB25sP5mPAQuqxFi+w/zUiymA1o/sGEMR/R4MwbsmKexhuG4PP/wx+2pJdToHI9dmOT6FPwtP2oGZq+JuOX/Xsy1UAPtHvJE7xoNKTITxvqfatWdOteStS5gGrCnJ0GucLCAGsJQrqPPhY1vAcxNa7iWdDgkxZFSUCax6qm2L0GkiF3bobHW0q6yHaMNIbSkR1ThwX0PrbChzoxrZtZFCueDC9ttBK6/C7zfDeiywRWGPSvefGKK42czSexy23gvg/Xd9y1nRoflvQ1R415mQgPnZF/eOs0Xf0TofslXzKsD8pRjwAeCFXLvjozj1NcI2XakZVEuVGqbiiqJGr9caq4F+URnMO3LZzdqMz7UMv17S5oFcEIW8VkqBtVN7f9NRhjae0XG4+rc2M9u4/W7p5fQcbnfFO4E83oYe4n41hJKXaqH1T3BxDxscijXMllDNnF1j4vbyOPDUosMNVtefcaVIpfI
 Pxsiwi1d
 Sw49IncTxRqRmtBCKHxREVqqsA3Viq/XOJCnT3R0/s2Ztk2n9lYNmtUfKcBHdkZvCq+GFFz9HCM61X/3LjLRtsL21nu9+dBpTaJtBYME+bYb/gT1yASYM32pSGRgOHkhWYFslIN+1ejNho+YrqhywRhRa2iLp73iAC9hIo3p5Azjmm0GmXbjcZwLP93U/fXCDctmfyKKhy3+mqnMLVVfcaHO5bbXrk8VLGJPpSYx948PntgjBF8mZYMi0fg6tx3/J1CnWASDIo+/e8lR2cyMSy4ZhNeHEgF+tlV90ORxuttDuwA2a5ar2CGTNYvLtkvxNiVq4tV2V7VNIJMwB5Z0ayWg4zKbli3HqaxwatlCGvRJXMT0vNu803ZfTWGuvWId3ZZA7btv5/V9YTMLysFSPV2swRAxvUsOR7+jz0pkFFKfi5uzf5cx9wwTOoVWoVv8l6u2GBXqkkrV9ZUU19BSinT3eBe9PF99H2359kSKhudVnuycyKYX5fI0RV6u1td5DconJPJNO6086W2ujs/mE7/GpNtM+YBabGNRt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jan 28, 2026 at 1:22 PM GMT, Andreas Hindborg wrote:
> Add a method to `Page` that allows construction of a reference instance
> from `struct page` pointer.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
> ---
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/page.rs | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 432fc0297d4a8..f666c92fcf451 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -176,6 +176,17 @@ pub fn nid(&self) -> i32 {
>          unsafe { bindings::page_to_nid(self.as_ptr()) }
>      }
> =20
> +    /// Create a `&Page` from a raw `struct page` pointer
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must be valid for use as a reference for the duration of `=
'a`.
> +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::page) -> &'a Self {
> +        // SAFETY: By function safety requirements, ptr is not null and =
is
> +        // valid for use as a reference.
> +        unsafe { NonNull::new_unchecked(ptr).cast().as_ref() }
> +    }

This is wrong. `Page` is a wrapper of `struct page*`, not `struct page`.

Best,
Gary

> +
>      /// Runs a piece of code with this page mapped to an address.
>      ///
>      /// The page is unmapped when this call returns.
>
> ---
> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> change-id: 20260128-page-from-raw-e8e1f14e3f6d
>
> Best regards,


