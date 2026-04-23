Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57273F9937A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42216B0005; Thu, 23 Apr 2026 07:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3956B008A; Thu, 23 Apr 2026 07:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAF86B008C; Thu, 23 Apr 2026 07:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABB16B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:29:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07CFF8C005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:29:09 +0000 (UTC)
X-FDA: 84689599218.10.0FB0755
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020143.outbound.protection.outlook.com [52.101.196.143])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24D95C0007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:29:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Wqj0zzD3;
	spf=pass (imf28.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.143 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776943746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Y9CfiEAo9JPu256X0ZlOoF57YMMquVB9JqwOeK03O0=;
	b=T6y3j16xIQBPqhd+KCcBVuFN8J4M9P8kvlZ9bBV1eEV4g9jldVsiLKVG/thtQx7EGmrNlf
	6OKfsSfw4YP4X5WboH5+n5AlmfYP+vq7T6Y9W/I+pMWEnecdHXWY+YpeDT2THdX2uyn6fd
	uKm+s8JK7UjvuF+j4usRx/vRveE3DUc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Wqj0zzD3;
	spf=pass (imf28.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.143 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776943746; a=rsa-sha256;
	cv=pass;
	b=WWeeRH24RtQAjhEGb91+RaR0JZCesl5gkChgpDr9kQin5lNKzLafzjTPSYfkVIBsH/AzZ8
	JL5s4OkVAhtUR3wQWRSsWlWqZnfr8Y4UJbWORji/+rgEsGNo57TR5LDNlab5qgEhpyhOk8
	wMfVrvoJi8NIdxcvihyzzMZB8mXzTeI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0guucL/5g2nEl/88Jm8IV0o142vXb3pn3gDJg+kgYb3F5fmxnhcM8vbIcHbBO0EZzLRPfoxYkesA86ht/5G0Zcu3X/8KAG2epNRicS4R5aE7KGuRctINgDdYuL8nZMW6Ev/ApVOWyE9Zjp9XnVpFyQ7qkP30hmtQ6sFbtWmbX5wxdNnKg7vMsC7K28ZwNa6I5M8EioM/7Glc5xenfCW7wW2mMzZabCqBpUMOc3n5wAxU+DpbnqDIuBY7PCgNo9bd09ziJUIreQB4NPouQnoMfwG/+JvzQGbApkw9XrpEh3/pqPcIGtuuPCZbK8PtLxeIG5z9cDYIPVJcXUBv+qD3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Y9CfiEAo9JPu256X0ZlOoF57YMMquVB9JqwOeK03O0=;
 b=CsmHsnR7EDNKViihys+jztRxspu9cBAGDEPx17EII/0rkmUud53rAgJPuMKilKxJmM4EtLSju196kUsqY3HtzlsWUw8W1+syvWp++YAzZxiydGSjVCJuFZ5MnwvjUs6lGc38rPGvh3rczqExVoYPckhWNbGq/gvkbMeINL+lvGAx2NP7HO/jXIhuaO1/FF2pKcLFt1r5vufRWrZ26McBJb0l7OReDIWSMcOwoDSrm1/v6yfAoz6lSlcNT9/FpY5lXO0gmgqJvPVx2EnjSXQIleX7UGNNONxVln9DBQv+Pcukobz5vQkzYe2F9FQqeQqq+NncyhXI1GQHOOOF8BNHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Y9CfiEAo9JPu256X0ZlOoF57YMMquVB9JqwOeK03O0=;
 b=Wqj0zzD3TuwZqKZe6QfONw5kFVYF7w4kzawRFhNsdpC4FQLREG/SPgBrbeKNl6ipXOWJwLQFN6dkbqAU/NX4cS3u9QGE4MeCWswjAKUP4fARB8eF5ebeY1Ofeq0scX3mWRd62KY5kNgUvEnX+oFlq2Ye3OYIhH34etD1mDU7f/w=
Received: from CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:27c::13)
 by LO9P265MB7859.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:3b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Thu, 23 Apr
 2026 11:29:01 +0000
Received: from CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 ([fe80::6c9e:93c8:10db:e995]) by CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 ([fe80::6c9e:93c8:10db:e995%6]) with mapi id 15.20.9846.016; Thu, 23 Apr 2026
 11:29:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Apr 2026 12:29:00 +0100
Message-Id: <DI0HZGUVBDPI.IMN9NCL0UGZN@garyguo.net>
Cc: "Alexandre Courbot" <acourbot@nvidia.com>, "Eliot Courtney"
 <ecourtney@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Timur
 Tabi" <ttabi@nvidia.com>, "John Hubbard" <jhubbard@nvidia.com>,
 <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH v2] rust: maple_tree: implement Send and Sync for
 MapleTree
From: "Gary Guo" <gary@garyguo.net>
To: "Joel Fernandes" <joelagnelf@nvidia.com>,
 <linux-kernel@vger.kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Alice Ryhl" <aliceryhl@google.com>, "Andrew
 Ballance" <andrewjballance@gmail.com>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260422202813.2990181-1-joelagnelf@nvidia.com>
In-Reply-To: <20260422202813.2990181-1-joelagnelf@nvidia.com>
X-ClientProxiedBy: LO6P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::10) To CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:27c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CW1P265MB8877:EE_|LO9P265MB7859:EE_
X-MS-Office365-Filtering-Correlation-Id: 740a6192-2b54-439f-7915-08dea12b845e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4FW9JzDeglqnD1sXkOlFqgGuycrkh/b49iNWtcbxRfDYmi86so+FvOexwDtLuEraFgzn9X/yrEqkza0wkRJDF7IMAHnL01t8FxmyQuBrymB46GjOVJ+IMsWEqWNquS/MnWi7Xg0jewe1MOyMd4s9PKRutpGs3wDFRGOjtRPnWFNLPMe/eeaLO7vSqH9/KJ5lJX/f/DHMFTvEBTWQTf3byK77dBv1kN8rkpIwlmGxOOkFlWi/hFqa1JGhtUzlg0JGyrBx3Iu8JOJVmfcL4/d2JAeEORGAv1hzOUa6yKLq3EUM3GVL9WFk2uwp6idJTLMmfjdPBlaxmxFmYWI8COmKVYQWqC+igKUyNbDH2cgktCQoct2x2jqSm38E8x+kYCdeqz58n6Chab7WgVS7DLKtmPo1IebROInZSad9iX+2wn0KF7UXv03Ja8smyJrg+SsKjOTqVO2kyXkzuVvXp3prc4POmEPYQGIeNhTt+GQrkbpjwi8gJwKobPDAcG0QmYczS58hvkQKB7CA2cCmedA9BORCcU5I43orXd1TLYNEwx9vvx6eJITk3TgL4CvWDRIAtukct++BoMU2azL3VklSE8r0z/CpsbHp5Ica1U60rihN9XkFz6LXOuLqB93ZI+5GXMxQOCxQlPu99jKviG92hpAE3FTu20aJ3HkKXkXCs7Cq+XVFyl2tVwcFDqx1KVsieiZ6ECyfhMa2I/Z0+HS+TZBhUNXkun4zhWpt9h2mtIWhWe89kwSxFfALx/FyDB7q2YwFc+VeQkXSLRr2SMsZbg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3dCTG5JTElUYlVsd1Z4eE5Ga0ZXa3FiMnpkbEFZclVYd3BZeEpPQ0ZUQmlE?=
 =?utf-8?B?aUw5U2xNd3FaWEdOU0ZiSVNXK09hMllTblNzaEVJODVidmF0d3dTZGt5Y3c5?=
 =?utf-8?B?SjdtaE5GLzlFalZZa1VFazl6dWNTNmFjYzJUa25iMkJXOVFZVVA3R1RZV0M2?=
 =?utf-8?B?MEdNc2kxU2tmYzJlK2x0QVdEeW8rSFpZMGx0RmxWM0kwYy9ma0hXSzQvTlJt?=
 =?utf-8?B?V3lPREgrUmVvbCsxNXRuMExBWkptaEdDdWxidHkrMlJCSktna3JsVzNMenpv?=
 =?utf-8?B?Q3pGenVjR05PSzBNcDZoN0RNNUxLelArb1lHOEZRR29LQVp6WkFURHEwZG1P?=
 =?utf-8?B?eGhia1U5a2tPaUhVaFJacmlyeXdoQmExeUVTZjBzU0hPUTVQdGFQSGJRR0xB?=
 =?utf-8?B?c0NaZ3Y0QXlWU1pQc1FyYTIwRDJGS2VSaWlvWHlLSGZyQU5iYVA0bElidkp6?=
 =?utf-8?B?d3E3eGtsOW1laE4xUkRxOURvanlMVjQrWnhPSkZjTngxMFFJbTlhMndhVGhr?=
 =?utf-8?B?dXBTbnJOQnNxWFhSdHg0NEdpWElSYktkWWMwOE9NdG9ueDFTZzRsNWNQMFNl?=
 =?utf-8?B?M2tzTHpsVTJaaHJBZlV2NWFYTEJWRDNWNmRGZWlsVFIzV2kzODZJNktRVlhY?=
 =?utf-8?B?Yktnck5jTWJlVUlEeUlWcit3bXdxc21RWG5TR1l3TU8raytXL1NuM0FSNXVJ?=
 =?utf-8?B?QWFvWFYwMjFaNHdNK0thOXhTYlJqaWFSK3lycUQvVFhrbWFacFEwR1dENjht?=
 =?utf-8?B?WU9heG81Uk8vQmV4cHk0dVpJREJrd1NHcUtPbWpQYnBaclM4cXRMbTB2ZFBm?=
 =?utf-8?B?c09vWU5raWtPdjJVRU9KZkhFUkJzWmlXanZXNFNZVW0wWkpoNEJ6cmxmWjQy?=
 =?utf-8?B?RStCdkJ4R2RVNnAweU9MS2V3R1RwcW1iYmhrZ0lGN0pJais1UEFZcnRDRHdk?=
 =?utf-8?B?c1lpcWtZSWg4RUtMY1lweTNIOG0wSmEybUlCY2ZjTkFXQWp4TWM2ZERFT2pp?=
 =?utf-8?B?amloQWh6QmlGcUpNSmdjMGxpZjBiM0JrUU80cW5ZTnJmTDRPMW1WdHdLL2F3?=
 =?utf-8?B?Q3V3Uzg0NlRTbVcxRlphaUlDY0xMcjRjbEZSWk1DNk9obEdtL0xXbDlxUFVO?=
 =?utf-8?B?aHhBeTJ6QTkrWnpmU0lUZTBkQVZyd2xNeTVVTGdWTXhCRHEyenkwMFlVbzA5?=
 =?utf-8?B?V2IrMlJrMGdYK1MxMDFMdlVXcld3UUN2S0Y4UXdBRS9MSFRyMkFVcEI1VjF4?=
 =?utf-8?B?ZEEyREc1b0UwM1YzVjlISjhoVWlUSk03VUJQZkMvMEloaG53a2FpdWRJWUJz?=
 =?utf-8?B?by9LOEZ3MG1LYXdKR2dzU2V6QlpPRVVnL3ZLNHd5WkcxdlYxR0EwU2xKMk9S?=
 =?utf-8?B?am1EMVRJRDNWS1FMaTJsM2dTRHdaQ3ArT3lhcFF3MDQ3Z3QyNFZ3OEpiMkkx?=
 =?utf-8?B?MVV4aXR2Q1U3bGUyOUEyaE9tQTRmNkFiZTE5R2dsZGozMGhoSm5IQnBXVUNP?=
 =?utf-8?B?NjVrNDZDcy9Ia2FhTFJmNi9odW5ydnVISURXZXFpRXRxVlJTbzZuZGROVW9Q?=
 =?utf-8?B?SlJkNnpScUVVRi95K2c3T2I4K3E3bDhzejFHbnlNazhDeWdmajFQSlRYVzFo?=
 =?utf-8?B?RmFHbEdwaXhyRGpJQjFEMWw1U004NHlzS2Q1ZktVc0YyU21iRURLY3p4VXUz?=
 =?utf-8?B?RmhPRUtUejJpb1lxU3NvYXlzb2NiOVI4TjRyb1JxM0hMUkw1T0ZUbCtuM3B4?=
 =?utf-8?B?RXNDcUYwY2VoWTdaRDhZVzBack9BaG1EZENhT25qcFNlTmJzUzdHZzMvb0d3?=
 =?utf-8?B?WXRBNDZ1QzNQVEVtd3dUYkJRRXJHUDIrK2s1WjR5VEt4ejYvMHVrTHJvTytI?=
 =?utf-8?B?RnkvTWgyK3NYNjZQcUE2MmpqRWxqU2FORVkybWRjeUg3UENOc1B2VUs4NG1C?=
 =?utf-8?B?NFY2S0g3bnFnQjdETXdWczgybkNRaW9TTExCRXhFeEovUlZkYlRTc2dwSyt5?=
 =?utf-8?B?YkJPY0lIaWZ1NThMb3ZhVnlXS0RyTG5YNEhKTW41dnJCWi96T2NTRUovbEdQ?=
 =?utf-8?B?OUtseWJCQmVvMCtLZ1JNdXFyaDI4cXV1WG5SS0hoVVZsYi9mc1Z6dFlIMWxn?=
 =?utf-8?B?U1NiSzBpbXRQRGdydFgzakoyWnl6eXM3UmloYmVuUC8zUk1MQmZTcG5FRmFv?=
 =?utf-8?B?RWlkMUtMeUs3U1VEaUYyb05Rd1NEaDFaclQrdzc0RXFoaWtLbGh4L1loSHQ4?=
 =?utf-8?B?ei9kOGZVVSt0bm8yTE5ubERSTTdiaGplR0duSHB4VGdtdTEvemRoWjNDZDho?=
 =?utf-8?B?cERpcThIYnFJRmp1aGNia1Z1NFNCSmZNSGhFUG9ybk5adUdPb3FWUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 740a6192-2b54-439f-7915-08dea12b845e
X-MS-Exchange-CrossTenant-AuthSource: CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 11:29:01.1443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfQwmg25FwfSnOnW/pcXZMhwV/lK0xYUbgxpQOrYFKnH79bbP2+4atxes01zgZvdB9WAHdbsZPfhELB9Ds1WKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P265MB7859
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24D95C0007
X-Stat-Signature: 874yjprhw9818b4eingw65qef3kimquu
X-Rspam-User: 
X-HE-Tag: 1776943745-772108
X-HE-Meta: U2FsdGVkX1+uA7WQHgATbJfE7j1dhEXUVeCBx3EzvIYsKUCXF/fqYHhMHL/3XUx1mLoLELefwqdArBP8ueX3fo6Ybud1H7GoMiVy9jqQCz+WK07I6+OjAUhb/QhU3JbhemzZ8Bb//cTC3R9BSEDX2jE+rDQogMYtYVU1PwubYk6suoCvB0wzQAYmI3+6C70t2Im58ubvzoNEUEEdho3UABfWBF8oJSPaFBpaawDfXZAyoEpsemaJafr3hetgEseef1/uqfosnb7iTHemeBNSmaPrRBNPh3+k6kFyCT94TQBKFf8P2FzCDizF9F5MtpUwgxTz5+k+xxfAZ1Qr6JVlYkWQ71N9nDdSCz6rmXhTToUWtprhLWwze3DBhbZJE0G3jMUGRIZANmhVXI41m0oMa/KV3xQ2LqxKWQwH5RrbJZPlKm7vAm0JXVNFRSb3O6GRNOA0+VxllCG+lzbONmW5EG/Qsg21gRvg7JrxjEjkYyZzuAmgPtXrP96NfT9Ye3S8Djg73E5Ri0YKNoz0385DnebQZwwk0HOnPop8ivrc7M9XBXPBG98XwH6UR1xMk7ZSan2AuXb/bG4TUZy0m+/JvO7Ok+sAbhhQTt5u8x2uZnsvA9Vyp4VZGSAh+QhP0hDdbNOXbVsRAm1dBPRSG00DOJmVPKmIbYUJs2qVGKwnS5YR41kYCN0oy9Iu7E789MiS1FthjUmqVVFINx7vTxb41x4Bpx5fxL80qGfrA5/hyMAVUrirWNOSOZclSfC3lYEH1xWa1B3Py/OSxA5sNgpwQcYQVTZOPfeBHuFafEABZk+VpxX5DT6DQHX0PvcZNHz62pMUAKyA1Qubt0c82bLnUf0rs6ut7N7OopKhNbCgTHZbzFmMz1MsTnNYZsdwieUgW96nEW1tVRTZHSCLgc8mvGGAnH9YZbl9U1l2mpoira3pDbHMYWVa9xO/hooYdtm41DvZrVdwXUyOIF99Ruu
 dWyq4Axr
 340FOyJ9pAAW8MiCcjpKSxNPZfuR7hy5HtKaeHRPnbq/OH4wbtIY3yNzQZQiY9sAnYOg1GEeRAcnLFBYF15CR+QzWK4A1DuDWetQW1t9ZBisBUwoombu65K0YnB93ikTz4K21SxszI1V6r1EEPYN9OGHMxaSp82wnzBGXfrlnFyf7saOYIUxhBAM2hcyI3sCXcID1rFyb3+YzMa8o+Oh0JYCK5G7b36eCB6Ps5seX0HDNcU/SG+J5IWmlpYyZnSfCZi8Np0BNiBRtK7+1kvW+Vxkdc7sG3kr9F1Q53fo5w5it1Mn742oevffoVNOiit+2RdP0LdFVqvL9MgcShyGdeTU5aJajtX0cw9eAVxKry8gJxCmtotucGv2Kq3Bo+3e0kj7GF0Gc/Hu9kOKIQiX6lotw5Hm4dKFEGLV/uUcZfjB6ubTgFp3pz2S3JSpfcCQgMJuJ2urZsbmRCzEN1x/hdYnMYtR4j7d87JlpmND41MhiS4IDcjv00OVVLjnAg0huw81H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Apr 22, 2026 at 9:28 PM BST, Joel Fernandes wrote:
> The C maple_tree struct contains a *mut c_void, which prevents Rust from
> auto-deriving Send/Sync. Following is an example error message when using
> MapleTree in nova-core's Vmm.
>=20
> This propagates up through MapleTreeAlloc to Vmm, BarUser, Gpu, and NovaC=
ore,
> causing NovaCore to fail the Send bound required by pci::Driver:
>=20
>   error[E0277]: `*mut c_void` cannot be sent between threads safely
>       --> drivers/gpu/nova-core/driver.rs:77:22
>        |
>   77   | impl pci::Driver for NovaCore {
>        |                      ^^^^^^^^ `*mut c_void` cannot be sent betwe=
en threads safely
>        |
>        =3D help: within `MapleTreeAlloc<()>`, the trait `Send` is not imp=
lemented for `*mut c_void`
>   note: required because it appears within the type `kernel::bindings::ma=
ple_tree`
>   note: required because it appears within the type `Opaque<kernel::bindi=
ngs::maple_tree>`
>   note: required because it appears within the type `MapleTree<()>`
>   note: required because it appears within the type `MapleTreeAlloc<()>`
>        =3D note: required for `Box<MapleTreeAlloc<()>, Kmalloc>` to imple=
ment `Send`
>   note: required because it appears within the type `core::pin::Pin<Box<M=
apleTreeAlloc<()>, Kmalloc>>`
>   note: required because it appears within the type `Vmm`
>   note: required because it appears within the type `BarUser`
>   note: required because it appears within the type `Gpu`
>   note: required because it appears within the type `NovaCore`
>   note: required by a bound in `kernel::pci::Driver`
>       --> rust/kernel/pci.rs:294:19
>=20
> Implement Send and Sync for MapleTree. The tree contains no thread-local
> state, and all shared access goes through the internal ma_lock spinlock.
>=20
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
> v1->v2: Adjusted comments and imports.
>=20
>  rust/kernel/maple_tree.rs | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)


