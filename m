Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D16EF588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8826B0005; Mon, 20 Apr 2026 11:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFDE6B0088; Mon, 20 Apr 2026 11:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5796B0089; Mon, 20 Apr 2026 11:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AED346B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:15:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32403E50A1
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:15:27 +0000 (UTC)
X-FDA: 84679283094.29.03C0155
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021087.outbound.protection.outlook.com [52.101.100.87])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E84840014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:15:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Cv8zPMKy;
	dmarc=pass (policy=none) header.from=garyguo.net;
	spf=pass (imf01.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.87 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776698124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDlZ35tV+Eix/AVD0VOp7HFAE85c0JpQrCf4slxWo8I=;
	b=280mM2mTBrqhYTg7B39ZroSpj/Vn8pTYOxoesqI89K79/w496xja51JY/WZcXnDylwTshn
	YUKs7MFxdKtbeDr9ZCcfsVWyyfmHvTBp2d97NsPPnUMsAa6xuHbyynh9INit3Qjg6kg0gf
	6vdwD95n6PqklhMXCweI/2nXP/G/uH0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Cv8zPMKy;
	dmarc=pass (policy=none) header.from=garyguo.net;
	spf=pass (imf01.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.87 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776698124; a=rsa-sha256;
	cv=pass;
	b=3ghVgi5v0iyK2s/JbefYnVKLXv5JVMD/rXYKj/JnZZDUzSotI6HLEceRYrkBCB9aSAKN4/
	kGS6Pqrq5Lb2zxKSvo5aUNQruScKUnDd66JYMoSFiZQ1T9AiNKptDpoHDqIcjMDrD+mRwj
	Ztn7WiYEsch1neuvZOwVLe20CotPDCE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HcoP03ClPvSliTosWWafSjHX/MUVuSLGu8hP+H0mxtNdq7b18/HnjZNIl7aPkcrZZC71c873wDBDLkxV/OqRtci9qmmMKvA2o+mkaM2qxU31K9eWMjURBsyi19B5e5eCPVGrcRh9vHbaxr3kVLpEfe+Erzm8QPry+X5WbgmBfDokTJPjCWkos0grlSIW2V60LYoAaJpaxlYCIHGvnaZO1DL23maIU0O/2281rIiikRQL1TspkYWvUddwBgyoKu8TH/uOD4wZHXUu8oezuRSkdBUu452xmg5QX/rmXKGBdfBYCkmFkB53qunZc5KuWEY6GTivfbzmRv15Gp8N6osdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDlZ35tV+Eix/AVD0VOp7HFAE85c0JpQrCf4slxWo8I=;
 b=fXpvy3ug4qUDDu4gswzxeFQ8DrZpFk9bb3+P1c4RRv1UFxNjmqZmv9G8XmBp2DCS59EhxWmnF2URJWWUByaSjagAy1E95GyRbadxUm6qR11CjqFY75VumwQJNpoSxx0FT5wmHnVwJxL5jB3GINTbJAIJrZ9YOveB+8bOttwgmppXpFEC+qjZkhVL6gFBGgqtJUS6lWSkcfOqbHyuFlkJBQfe0ystS84yVgZPPEgULn7wxyAle9CvI/P+WuC4t6U0c9skUyYvnMh/XA/SfJtILNbt4cJSTQC7pR/wtlHZjx35heTKfMCAZjYPj1/kcGSWzes9IGNSQb1N8g9NWOMgXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDlZ35tV+Eix/AVD0VOp7HFAE85c0JpQrCf4slxWo8I=;
 b=Cv8zPMKyKAIFByGLIslH1AiVTyOHYhDaxIypOc9dMahSXC/9C8paCibz8NP+Yw+N13zONkUky7J4cTGeGGi1gERNSlBtaffNZ8+9YDJ3AKJ7KQSDneEho3gVbSBDPXGxj3YLSiPwxuxP79+rf08M6n4cWgItB6ZcSBJ9LRfBwFY=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWLP265MB7328.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 15:15:19 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 15:15:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Apr 2026 16:15:19 +0100
Message-Id: <DHY2X44G62PD.3A7IMZ2FAWXLG@garyguo.net>
To: "Alvin Sun" <alvin.sun@linux.dev>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Tamir Duberstein" <tamird@kernel.org>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
X-ClientProxiedBy: LO4P123CA0163.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::6) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWLP265MB7328:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b83141b-76bd-4f36-1bcf-08de9eefa29c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|7416014|1800799024|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	n0cji9gTirhorL/jhxM4MXeT4UibkL/90XWQOB8vjojiEgvw/6ZsDsge5cJoDWCJwBYRxI/l7SGH+cZ3BsyRe99/hO/n1FUOedq8Hy6c1Fj7qel0N1vmCLHczNdLGnF6WRWDDcskae01MyW7M4vz3RPW9nPVKKCX6TItohW7/5ywwD3OptSKX1x3f8n4trzdIzMXSL4KIilGhwvHBRroz2kQAsH6/9k/Lt1peYDNoqvr2Gsc6hr3OXTMMGYI9TRSliy8H/U/ybq4Kak3NoalMInKZabvxV3g6TF+l3HAhNSzMcvUkfiBbhm88q25PYUafaELO6gBYes/9+jx9NDI4Q2fTMeE3XvTxlC6tQm9yWtu+0u6i6Mb37KoAFAc1qmDhQj1iRm2RqvAKTCXXE6ZE8PVrZ+hyE2Y8RKCqtLczDN88zYD+lh/JsV6MotqDPmabgNKH6SsFhsA7HwfJ/lRSz+wO8JkBImMfXe8szU7YFegloeTchuWdFm75HUNHCbZopqKuIUmrnNb5t/+w0jJJNFgUhqFC8bQKRet52Sn94lbQQOSSGA4eSYiVMpmU7/JkmNxQd7AyMUswkb77yEeT7H1Gawj0ygxU+oQlvF7RofOurUU1FinwQ+dFYqMdfa6qUjvr1KwlLH7RyJ03e+XA1tlfkiTZGVT+ahYXYAivBjRLBJMo/guwEQ0UAA6gjvCxEwqy+DOMH7o4GGmAPmtXu+Ksdxsnc1El3+Vdzc4nQS1GL8WLwy9N3U1w4jPBdQ1LNa9SJcMErrWRwCoGKDeEg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(7416014)(1800799024)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czg2Z3plREtmNjZqcVJxaXhPM1lpY2ZmVGZ2NzkxS1lPczlFNVNJMWlSdUF1?=
 =?utf-8?B?SXh6TDRLQVRwOGZvelk3dUxnQnpzRkJ4WFpWMmp1c2V6VFFuOVdHclhHd2Ns?=
 =?utf-8?B?ODM4T2pTZUZ6MlhBWU9WdktzQXNZV0ZIbWdINklGWFlMY2NvTy9KV0JSZjhw?=
 =?utf-8?B?bVJPcVZkN3o4Z1lOUUJUN2hwK0t0Yk45S0gwNGFLbE5icmZhRWQwTW4xSGFr?=
 =?utf-8?B?elV0L21zWU9tcUJlSDhUUUMxaThuS3QwSDFUaXEvaEVnM2JCNEZRNkFiK0h2?=
 =?utf-8?B?UFBMUkJDV2VuVHJ3QUdtYUtpNjl5bG9NZENXRTFHaitYZmVhbmV1QTQ5UlhY?=
 =?utf-8?B?VTFiMFFTczhNQXY2YUFtZWorb25vRGNNMElTbHhHN3lJdXFMbjFSU1JOUUtS?=
 =?utf-8?B?WEtQYnNZNHpXaUlZTm1ZTnROQ1N4S3hYNGNoVFFNa2FrYWF1aHBaLzM4RWNn?=
 =?utf-8?B?enJWR0E5KzZZVFBja3VZLzdRQkQzcTI1aWhPS3V4WFdYVjNrTVR5QkMyMmZT?=
 =?utf-8?B?R1JPakxXWFRRNUt4eE9JY2IwbFRCN2Nha1JneDZ4RWVManA4SWJTVEJOK3NY?=
 =?utf-8?B?SUpBN3ZQSFdlSUh2bHVKS3dpUGZmWnV6b1Z4UkZYRjQ5aHdScmxaUEk1M2Qx?=
 =?utf-8?B?U1JZcWdJMHpmN2pxY2ErVUU3NG5KNStERWxST2ZudDR3aXZ0cXFkNW5McGFR?=
 =?utf-8?B?elFvc2YxVUk4RkR1V2lscmpKS0pybWRCQXJkd0tRSkhiSFoxZ3Y3dXB4UDNm?=
 =?utf-8?B?SjRvcjFucXJJME5XSUFPZVJqMExhWTV1WWlRRmI1bGx1eGQxUFFaVnhLWnZJ?=
 =?utf-8?B?YlJyV1hiTEZPS1pnVWZIalNacUtFcUE5S1RJemhBc0ZkaHJOYU82M3BYS0Jh?=
 =?utf-8?B?dFlwSTFmTGxFbkRSUkNRc25QL1p5T0c3akd5YXZNMXUvRW1uODlEOXdWdWh3?=
 =?utf-8?B?QkgybExBbmVESGI1ODMvRk1pZDd6NitpaFRBK1NFSUN4OFNtbFlFcVp4VjdF?=
 =?utf-8?B?TXlZSHpONWNIZDZVL2FQb3hhSTJkcFUvVmFibGZRbUlXR1FYaDVwdk1XOHNx?=
 =?utf-8?B?aHVFUGlNZFRBMjJWdjRxVWUzMlo5T29tZmV4T2ZFc1piRHVBWTdzcnY3engw?=
 =?utf-8?B?alRzaU9iaTFBcDFjSWdOVHZURHZaK2M4ZlNXQXRtTDJXYmN2c3N0S2xXRUZF?=
 =?utf-8?B?RkNUNFBrZnJSVThzemg4UXltOHFlbTRaMlM3OG50SG90NG5qZzVmWDk3dGp2?=
 =?utf-8?B?UWFSbjBGL0hVQVVPelRVVmhaRUdadnMwWndHN1NVbHlFQjVpeVMzMlZTZHJu?=
 =?utf-8?B?MXlrWFNHdkpOeXRZcldoKzcrTXBNb1pqMTRHa1hFQnFaNkUyY0JPYVk5bjNM?=
 =?utf-8?B?cWM3M1BkZml6MlJoRTZNMFJySi8veG5GQmRZcTdhbDRQNEx5NU91R2k4b0FX?=
 =?utf-8?B?K3pGTE56d1Jkc3lBb1g3RUZ3MXdRaHE0RkZMdHNyNURsQktva0hPUFJFS01p?=
 =?utf-8?B?dkFYK2JKVXE1NEJ6MERMT1FRcy9GemZNd1p2aUdqdnFwbk41c2l2WG9sbFhB?=
 =?utf-8?B?NWVOQjRmaGhNazc3M0puZUdwNXhsYzRVcGhpSkFVMnpwdE9aSy9wN25ObTBo?=
 =?utf-8?B?eG11SzA0Sm1WNWtDdFlDbGNwbDF6OUh3MHdXTFBOanVQd042aG5lVlg4MXZF?=
 =?utf-8?B?VVVKK2hZVXoxMXVHeTEwM2UzeFJITHhBMGYzUnp0ditaNjIyQkZqemgyNXVP?=
 =?utf-8?B?cUZWUG9lWFJEOEREaTdEWmFhQWEzckZYSGIvNW9XRXVPdjRRM0xQNzBNdUNk?=
 =?utf-8?B?NndjNmJ0RHcwaHQwdks2TDE2cjA4S1o5bFVUUjhtb3pFQThsUXE2SXc3a1NY?=
 =?utf-8?B?L2d2Q05PdHJVclV0S1J6N2phM1JOUU5pWnluL3JFZEVQVWJmQ2xuem5LTnZr?=
 =?utf-8?B?Wi83SkZzMDlMZDdQRU5Id3dqYTI2MmdpYjcyZUJwNXE5cnNoMjkySnlEVTE2?=
 =?utf-8?B?djQ1UVEzcnZQZUJKU2lwaHJjNWY0ODBaVnFKNFZkbklLSnJPUmltV2Z6aG9u?=
 =?utf-8?B?UEV3TlZBUkY2bFdNTFJkQTFVckhPanRZVk53OTNaZFJxWVAxR05VbWtvWU9G?=
 =?utf-8?B?c1l4ZDZZaWVsSCtXU2FZVzdmTDVTK2phYTJ3OEZQVmRkTFFPM0pBRm03Z2Iy?=
 =?utf-8?B?V0k5R1krYTJpdkhaOXJUUlpJbU9LaVdYMUF4SjJKZnhOaXcxS2pYWTkrdHZs?=
 =?utf-8?B?WEd5bnFlN0FjcC9GRkRLZ2czNk9YS285WjV2bHlvZkoyTTd1NEZDTFdHejhp?=
 =?utf-8?B?bFZmTnpqbW1NL1NzZ0pqZGpqWXAvNkFOd2JMN0NQK21jVUhQZDdyQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b83141b-76bd-4f36-1bcf-08de9eefa29c
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 15:15:19.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpL3cvuELgKCpOUTAo/FbnvU+ijnZfxVB45EPy6mYvZdjPnQ+FQHRdCxgKr6Jlofv4SxmQ1vOBLWX6ypFsy6CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB7328
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E84840014
X-Stat-Signature: x7uyug5sooi6nuh547nbxuuugt9urb4u
X-Rspam-User: 
X-HE-Tag: 1776698123-251235
X-HE-Meta: U2FsdGVkX19iNTRRQ+YEmIZJ7ORVOyjdnNzIsQ99eIwlEsP5QAGsZKdb8vizZWHJL3CDI3EZrRSgsiisq3k4+LXQb4ioOtjhmIhKc9TXcrJGhHFKSNxQwUEaiG4pG2pM1di8e5ipaYX3TlR0H11eFrVG0JyBOQdy9OCfEnXx105mClzTtNmkMmVox+ESDb4Cxlp8VXFPjFbRnrSUoHWKsFbP08oNLIpz+K6obNaQw2Sjwx7T5JUfZnlrcSlTN93w3BFz2wWJEU7h9+brrTabegA6vH3CWZoVKOeLeSwzWi6NvZoAR75J2eJXQn8LVgsLlGI9sohkJpljO1mXG3iQGEFSx1nTLYbcf4KmDBWcUrnrJyKzLQ7OdeJmxMRSZ64aSbdAUWy632oDCSYsmMmkQ6a+15z6UG1+1zeV7TbR1iPSZ+zFsaSJgDNrxfmbo5THaS5BeZTTQsGiwV2fhD0iqSWtl6ey4ugrKf/qXs0zPJ+LpOBuTK1/5DQ2yHTxWZY87LpfSzKBX2CAswheaguRcf4M/4eYXQLGCrVH8sJnvQBEf9DfmdYRXdJc3idycGrzm9rAdum45gEx9zKRNFmY7iepV15Vc3IZx3ZOfYbeMW4AG78wvJincODUgk13f86wQBGDuJqDi2+nPqvtS5JqrQWOvKex3euYFZaDfrIbifJ4xCkCwaSPkzTwFIyD5vWZONNGvsbj717xa2moX0s2kU5O6Wjy7PvOdhRfw8K0UsayjSIUAyzIIGkvCI/RtW0aXFSWkh1kiJaQA5VD/+Pykhk3zyXwQ2hGr+uyQWFfMEIgmM2qAmauNjk9nNTDkajdrAz7Nbpglh0UcH2dodB4TuiaYX+uKmaImHWK6M7LFhhEmwFBdDYKJPgWFBWOKkDLoxiF2zO1XfUD4/Vedf7LG1H3caXf+pdIi7C0eecgilMF8YnI5GG2NYgUI/sp6MEMcx9lXBMr5i5M2IsDM77
 KhTitQSd
 Tbef/459s9pyK5UdXXEtLCsZqZyUEkw5BUPce4pP+eloBrra/qsOrDByGaY7Hl6BFF899d2p9yJ8K8UuzDyt9jBMoDFnrlcRX9bFeeB9ElKtzVxqtIwxOaO1HG0y96vnTV2c3OMVANfhUume1zoTy/ROcSKYEgMFySSi0482df+/7kJ2R/BVK9jFu3T05TacSL2rkLzTu1kilKavhTK01o1LB13ZTwGchG6+qbJRUn5p2KPHpQ247jP15qg0OKI+Y0oR5QvmhVS2xVIslDrWd30cz+Bae/Zxufm9Sw5S/bJZs8TAU6izpuIXtAcTeebDqO1GpzFKWusdTnqUg2vT4TdoYzbg9Gk4f4iiPDRZHsjI8pFNQwtkhWu7HTFurWNjWnD43qJEtBUBVKvA5XOaPIipR8iyjd9FfeFjyR/8FZffb1II=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Apr 17, 2026 at 2:05 AM BST, Alvin Sun wrote:
> Add SZ_4G constant defined as SZ_2G * 2. This constant will be used by
> the Tyr driver for calculating user and kernel VA layout.
>
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  rust/kernel/sizes.rs | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
> index 661e680d93306..872f5bb181ecf 100644
> --- a/rust/kernel/sizes.rs
> +++ b/rust/kernel/sizes.rs
> @@ -48,3 +48,5 @@
>  pub const SZ_1G: usize =3D bindings::SZ_1G as usize;
>  /// 0x80000000
>  pub const SZ_2G: usize =3D bindings::SZ_2G as usize;
> +/// 0x100000000
> +pub const SZ_4G: usize =3D SZ_2G * 2;

How is this supposed to work with 32-bit arch?

Best,
Gary

