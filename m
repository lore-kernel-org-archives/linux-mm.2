Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83BBE6BF1B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2457E6B0089; Fri, 30 Jan 2026 10:48:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFCF6B008C; Fri, 30 Jan 2026 10:48:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE6D6B0092; Fri, 30 Jan 2026 10:48:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA36C6B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:48:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1B028B522
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:48:33 +0000 (UTC)
X-FDA: 84389062506.23.678A62C
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021123.outbound.protection.outlook.com [52.101.100.123])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5A4416000C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:48:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="hU/Bz5g6";
	spf=pass (imf08.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.123 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769788111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXH+Kz2NwfGJv8R6ERCguaViescrMMJDuxq1CNUPrp4=;
	b=vOXkr9/P+ZmoxM+FlC6DYh2lgr+9Ssyerb2MgtiIa0rvoVWS1Z+dqUtH3C00G0pD0U+tjj
	IQMKJioyBtw3b61Pa2q9ChPXKhFA+Gsvao/n9CFtlbFR/QOx/cIUfP5vE8dgsE+TeIycbx
	VJHT03ESizbboudPePnZQsv+fVflbpU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="hU/Bz5g6";
	spf=pass (imf08.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.123 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769788111; a=rsa-sha256;
	cv=pass;
	b=ppkbh68Zm8Zjt6FjKuc3T9+Eh0LVynxyix2vn9iRH5XnP3u74qe0DMJPSzRm3tJXS1y+4B
	Q21SCzzQbb9naf8InDk1HVGxfKmo5Z/sgT0tyqEXVoIL/h0hALyOiPl7N/HzCwbwJRJSw5
	RaLhZ6FsuXywj0yUSGFrLc7z+GRpdxQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AGcjmXkE8T9Y+mnGAuj98yEfQjDti/sFLw9pEAxp13/CCY5RS+GuKVChIJ1HwKhpHp8geqMA9QwCaqnQum/H08lAz6HCB/QQ/2RCDJMvtrzQkRROHDsWeiJ9J2pTAsOsq88fOkC4Ybe8c1Hfv94dlhNi/HDU+LRiT36X9myrqxkLuqy1nXyzXv0NAzpSvc1bbymP3ihLiiBfFmLtU4qbKivrqJFrQ5w26CL1KoOSfYbS6fRERBt8waIZ8fONVOc+sebykCYlPLAZqBThRLEo2dHOqoY8vyvwIgYbaeIdUr24Mcc5XNIOlSTa2nuJdXgOR80CypPW54IDWyhpxDK6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXH+Kz2NwfGJv8R6ERCguaViescrMMJDuxq1CNUPrp4=;
 b=ho3qgeGBAxFABZ4g03ngPwhn+H2MYI6CthBQ4jnis9R0GPglCI1MBv8fmqJrWdM67ZCR4RFZFEEXHWXgwSWmgmYZx+r9uAa/Cjn+W6ISzGHss9l53Mz+U0dqkG7qRVKwK2ruqVAtkf3yTs/ey0Hp0kivviTUXB3YKUY066MOmYPEx81yUMyPd/JssD7c/amZN0Go/iSHoNyzbQAh0oK0QMdB1nhsu07UyvMuWmcYpsn9sp7RbLh+6M2rqqCGyBcyZEL9LBqqAohQ7/taNyqm4CozsHoMWTG8N0h/V/phGAgfJz6lX/p2lWy5yQ0w3iYfEuYFQr4bkOH++xBmUYnK6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXH+Kz2NwfGJv8R6ERCguaViescrMMJDuxq1CNUPrp4=;
 b=hU/Bz5g6QKc7RP67GkLTJUwsOVwUY0YHaLPFgW0EpqPH1Pi15qelRg7F/63ZSRtKW9Dt0gxc9yLbkdJsYrrDM21KzIoNjRM7oSNzddpHm4CsiHdJTK8IvLUjqfXuUKfqbciJBAUjyVAP/E5hxKH6zHHNWnTnh9td6NN5JjIIgfA=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO2P265MB3545.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:1b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 15:48:27 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 15:48:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Jan 2026 15:48:26 +0000
Message-Id: <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, "Alice Ryhl" <aliceryhl@google.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich"
 <dakr@kernel.org>
Cc: <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
 <eGcGSx_-fgeLHkPmdfbWgLGhzEcmXunLzIAvS1-X3GqwyFOny9Frz1xN29-fj99sHxxa5_1WrcPxuSSZKxCHhA==@protonmail.internalid> <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net> <877bszrz37.fsf@t14s.mail-host-address-is-not-set> <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid> <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net> <874io3rwl3.fsf@t14s.mail-host-address-is-not-set> <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid> <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net> <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
X-ClientProxiedBy: LO2P123CA0039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::27)
 To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO2P265MB3545:EE_
X-MS-Office365-Filtering-Correlation-Id: c58c49f7-8ad6-4cc8-0bca-08de60170223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmV4VG5GZ0FFY00rbkpvK0hPbC8xNFJCd01STHFGditXakY2VjRLcjJBc1FW?=
 =?utf-8?B?UVBjR2w2TEx0T3prRXlKNGZDWFZqM011aWdGbHpvc2g0OWd6WGF1bE9VSUFX?=
 =?utf-8?B?NjE2cDQ3ZEoxK090R1A4RlJ1SUgrYitEOUMybFQrSWdaMWtHeG5mb2xlNkV0?=
 =?utf-8?B?VG9MRWdiTmJwUkRFd3l0a1lDT2NBWHVsajBzbUFRbTZrS1NHbStrVUw4bFRv?=
 =?utf-8?B?ODBucFNZU2ZvcVAyT091c1JqcjJYKzAyaTdnMlVoQnlUc3htelNucFpoT3pQ?=
 =?utf-8?B?YW1NMVErcE9yc1lmQlRvRG05enQzejF0VG9EWEYvVDFlUlR1SUFKZWVRSU84?=
 =?utf-8?B?bFFXdjhDUEVEWm5mYkk3NXVNeHNRM2lEMWdQV0gyRmQyR08zUE5wWnBJODNo?=
 =?utf-8?B?UEFIeVBqVDZuQWpveGE5c3lOQ3lWYXNJS29hWHlOY2F2Smc0WmovaGVRU01X?=
 =?utf-8?B?bzhlUGw5TXJNL3ovb3NuUmJUcTBVME10RmJrbTN5MWZwRWlqd1FZUUdiVDRv?=
 =?utf-8?B?aHcwMXZWczViWjZjaGg4bnh3bGxkTDlxdHphMkVEaTZKVGV1cGdZMTBzMTVX?=
 =?utf-8?B?ZzBTVDIwaGJnMXQwWHJNVmZneHF0Q0RvOWdLalpoNE96bStrL2pKUUJYckps?=
 =?utf-8?B?ZnRjMDlhZVhYL1RwNjhEbldjVkxVQ0l0YlRFSmNPdno1clVYeXVhSy9CWm5E?=
 =?utf-8?B?MTBVNFAxVTFlNndPamRWMElJZExJNW5PbnUyeWZsQlRoeXBWR3Y3cExvcmhm?=
 =?utf-8?B?SXhIclk1QmlGU21yTEtTWEdUTGtKWmtXOG4xSzB2S1oySWlxMG1qSTZjSzBq?=
 =?utf-8?B?dEVZMXZLczE1QXc3c1pETVEyY3ZGYWRrL1hEM1Q3Mk9VK2FPeEJmeCtmS2Fs?=
 =?utf-8?B?S09RU29oTE4ySXJNWm9CL0xvREx4aTA1YVpBUlRKaDNtbFpJT2MzSDJjODh3?=
 =?utf-8?B?K2Eya01nVldDZnZvVGZsemliMENLK3QwSUhZVG5OREViT2FYRnhHUmlVSXlk?=
 =?utf-8?B?aksrZ0E4ZllkUUdmR09oRHUwVHVwVk1pM2x1VU1sUkVQMFZBVzZHdWNxODRO?=
 =?utf-8?B?V1psT3N6cDdndjdCWGNQd3JXTkJ3aGdkenk5aWlTdlFTbk0vV0x6b2JnTy85?=
 =?utf-8?B?T3ZmQWdDN01KTmJveThMTU5rTG1yaWp3bElhM1JZS1FxTUhWYmNGQjA4aWI5?=
 =?utf-8?B?amJTK1Fpd3M1ZjZsMUdrZkhCeThEUGFnWE5QQTd5aXUveHhhTWtpTVdML2RM?=
 =?utf-8?B?bXpNUERwSFpSNkUzclNMQVdKTTRPQkxrQWVIMHMydkdJcUJZakZsM05uM3p1?=
 =?utf-8?B?VGtlWnZScU8yb0lnM0VTTGFlb2kvMzNqbnBYU3V1SW5QNW9aSko1dnJQbk5R?=
 =?utf-8?B?RHI3SWxNQlp3V09PSjRtRytYdkZwZGd2Ukp0TXpsVDFmMzNFM3BPeTY3Vmgy?=
 =?utf-8?B?a2haeFVFYncvL1hEY1F6Y0p6di9XNVhlOTE2dDVndHBpa0N0Q2gwQ0NkVUV5?=
 =?utf-8?B?S2dKVWIxREJnNDdSbm5OeFZXRElHeGFBdTMxeWw4M056T01vanJ3VzF3VWxm?=
 =?utf-8?B?NFFhU2dnaFBhT3A3Qkx0bWZtd0h3SXBkWWJPSkdsejJXZXVCZ3BoSmlBVEdy?=
 =?utf-8?B?bW82RG4xMlZrSUxlb1pmUkw1M09VYUNMNDBJMm9XYjdGcGsxTVRPanF3QXEv?=
 =?utf-8?B?UTZOeTBPS3g3dHhBMGVlcDNvaWI4bHd0YWN4YTBITFg2bC9nelg0akN0d2R1?=
 =?utf-8?B?Z0Z5MFZBOUhYY1NMZlZKem10VlErYm9zR2hwOW5xenhsZ01RV0J6T3A2WXV5?=
 =?utf-8?B?RUE4Z1dQYnRhNjU0ejFoZmlWOHNsclpibmhMNGNHTFNQeFowOGkvWC9GK1lW?=
 =?utf-8?B?YThLL05pb3ZHR0syZklydHJEc3NxZzNHeXZDb2Joc0w1dkpITngzQWVOQjNx?=
 =?utf-8?B?b1h5ZC9COHhneVBvTDRIM3NyQm8wQWxVWisxQkJ6Nmx6Ni83Z1l1bkxEUkwx?=
 =?utf-8?B?SFpMdnY4dXJxcmFOcnIxdHR4T1U2NTQya1JPZllyL3RSRnp6MS9YRmhKaFlE?=
 =?utf-8?B?cEhqbUptVlFzZ2V6eDhJWUJoUW1KTkswT1Y2OU92WlFuNWJKaXFhSW1LcnV1?=
 =?utf-8?B?VXd4TnNQOE9aOVV3dkxRdThuSzF4Q3FZTUhQUitpYTlLeTBzRllBUm5VNjBX?=
 =?utf-8?B?TVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUx3SmdhMjV2dVllT3lqa0lSTFhPYVRicTgwNU5mZnFPMGhIZ211OTlkOWtU?=
 =?utf-8?B?WTNsbElkUHpoZ3FzVFpCSldaMTZJR2tGN2JWMHZnakpsRFlSOUdHd3BJeVp1?=
 =?utf-8?B?U0t5Q2pxWTlYVGpEYWVqY3lob3psVklpb1cxYXVSRXljS0NmMGhpWUV6QlhI?=
 =?utf-8?B?enZ2dTRZa2NZUmVvdVRZbWJuYmY5bnFPSTNka1RNM013YkJUQ1ZPdlQ2N2tl?=
 =?utf-8?B?Ty9KVzBsNEx0VnRIcHdRaFlnMTJlWi90RDlJT0lBUkx5T3A5T0h1bGFuV3dw?=
 =?utf-8?B?MFZiRXJ1N2R2WXo3N3cxQmJRODhRbVhXbjhrYm9tYi9zZWlIU1MzWERXZXVH?=
 =?utf-8?B?S2F6ckVxNldTajhMQ0g3Y1hGajdwT24rM1dJYUFKVFVuS3c5UnVOakVwRC8y?=
 =?utf-8?B?YkEzV1ZZS1AxUHF5My9HWHA5ZXJOemhaRHVyVXRLUmRVWmVMM09aVk1aeVFl?=
 =?utf-8?B?Z2pLQTFuanF6QzFsT3RnbGVHY2JMc29rYjBPeDArd0NJY2pIbVBhSVdMbTJy?=
 =?utf-8?B?ci9ibjBmb3VNU3JvZ3g2eFNnNVAzZ1NOc0pZR2w4Y1lFWnR3eVZPQ0p6czV5?=
 =?utf-8?B?VWFTOExjQ0JOMDFCOHVqU3huK0FHZk5JUXdER3J3MitZTFJUSE9OU3kzNXpv?=
 =?utf-8?B?ZWFya0hZVTNJNTAvRHpxbEYvTVB6Q1hXT2xYVG83MjZVMXBvS05XVlh6OFpF?=
 =?utf-8?B?Z29UZHE4OVRiMDhUd3Y0MUY2WkVNRjFDdnhtZGZWekpyaytYNTNkM1B5c3NN?=
 =?utf-8?B?L2hmSDU2ZjM4N0FoeEtidFQ0T3RjSXRtSFZnT29JT1NFV2wwSW0zNi9KRU9l?=
 =?utf-8?B?OGJLZFJXSGN4OTk0WVVJLzFEZGZweHVHbGMydklZT3FVMDFFWVprUU1uMU5J?=
 =?utf-8?B?UTRHNjhrYjJxVWx2N0hPN3RhMER5YTBGQUtFSUViOWhXdXpqaXFTTGdKMlZn?=
 =?utf-8?B?RzhBc1E5YzRteXRPekVLaExNeEViMk8wVzlKd3VZSnJJeTlpN3ByS2FEaTBM?=
 =?utf-8?B?cjdKT2doQytSRURIVk5PRllKeXFlMnRIQ2hVY0tQQWRGTG91dXVuRklLZjNa?=
 =?utf-8?B?ZGRHNWhqd1RHbEd5SHo0RnhvWTNwL3MrY3p3UEtyaUc3RGN6ZUNCRklUVDlw?=
 =?utf-8?B?ZDZ3aFdpY2w0YjhlMk9id3hOYlljV2hyN3ZLZUhyZkVpOEpONE0vUUttZDEy?=
 =?utf-8?B?L1lzQnVyeE5meEdlaEJ1cFZYN245SVBycjV2dVpqeDIyY2FCaThINnBCOVZy?=
 =?utf-8?B?MVhvbURQYlNaRm9Pd1RkajM4TFVKWjl3ekZtVlVFUFdNQ2RpYk1HMEtKM1dv?=
 =?utf-8?B?NXk1cEhhQVQrUXg1cXlySTRKMFJrazlYVk0rSDNTT3J5MGl6bldjV3NuSVFX?=
 =?utf-8?B?aGpHaEpZK3RpTDh0dFNrTjNkUk5CSVEwa3hKcG1rQkJYeW10a3k0eG8rZjVk?=
 =?utf-8?B?T2kzZEpKS0FwRk44RXZUMnNRUTdsRVFWL2dyQUtxNkdkOXRuQ0IwZDRRTGt0?=
 =?utf-8?B?Y3lCZDJicXRiWko0anI1dnQxelEwcHdQR2E3alViMTlIbFNxYlY5WUo4bGZi?=
 =?utf-8?B?Ky9FYS8zM09HdEZxQk5YSHBxeWwrTWxjQkxiSHNyZGpSY2JQT29VZGV6L3VD?=
 =?utf-8?B?QkYxYTdrcjUxSlozL2wvZ3hxNTl5MDJ1TW51elZyaTg1aTU2cXNpTGYyN1BE?=
 =?utf-8?B?SW5WN2JkWFdmMFY4SC9ERFdGdXhzM3YrWWVDQ1RHMnQwTC9ZYW9LbTFEZUQ2?=
 =?utf-8?B?MTRqWmVSOTBNcnN2K3JnM1c4MURSNldqV0E3YTdSSDlvVW5kQzdwNTNhWmNS?=
 =?utf-8?B?WG9acHpSWnh5OTBoL3h0Tk1SMjF0aXplK2hCWnFJWDI0WFJxWDRYclFCa21K?=
 =?utf-8?B?MVRYV05LeVBRcmZSNDVUVjErUEd0dTlBN1VSSTY5TUVGM3NpQlpWSEkzejBa?=
 =?utf-8?B?VnI5WWRZMHYyTU5iNWJ4V3VvKzdLTE8vcTlIT1pSQVJad3d6TWJzaFVtcFlL?=
 =?utf-8?B?S1QvWDhRK202T1Qxd1Z2eUJycHpuU1JHS0FUVktvSGgzaDBaK0FsNkFFQmFG?=
 =?utf-8?B?dGlKNGdXMC84dGF0TDlxcWlITHVuNGEvWFgzU1Nwa0F4YWlNc01jekphUVY3?=
 =?utf-8?B?dWN6VEk5cGdrUmJFL1hWV29Rektva2dBc2d1ZmhxZndwY1dYMnYyWG0zb3R1?=
 =?utf-8?B?cFBQczlEVVpjQmFPeGZHeDdQS2NQN2FvbzQrRWhCZGYvSWNsSHdpM2Jha2tV?=
 =?utf-8?B?QmVGNHBDUVBkVkZnQnJCNm95SkJvOEhuaHhiUXphNURBRmdPczhkSjB0aXRp?=
 =?utf-8?Q?y0XUHCj/uvRE1c04Hs?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: c58c49f7-8ad6-4cc8-0bca-08de60170223
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 15:48:27.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ji7xhCs78WJwSrTio+pRcCXsjAR65zg0CdiZjSf3ikBL3F372PEKK+i5SbNvmlZ++DjvpjncN51aZ/9KZPjQdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB3545
X-Rspam-User: 
X-Rspamd-Queue-Id: B5A4416000C
X-Rspamd-Server: rspam07
X-Stat-Signature: tha333t8iow5s5hojhut61cfbhbszxpm
X-HE-Tag: 1769788110-290374
X-HE-Meta: U2FsdGVkX1+jrCUq/wXeI60wTTUb1vSCGdAlvNwZ83gy7jSFNWn7v8fuS6+jNNjj5lJEB6QOBwkWIINbqqeWb319nNZMwc5t2Ha0yQCsn/oDImBhZXq9hmHJqFLbyDnNmqT3dvdylBltBh1W/B0VBR9mi0vfRZeiGBnOdDnrjBpUnLfmIht9VeHXTx5FLkZ7RKuP80XglzBZQ6MGbg9EjXImn32b7EQdkyo7nQjzE/Ce4jfUKoQjLzRKl6ZvhqQharV5Tm/buVlqs03cOsfbwF83os9vHpTwTuotZZStQxegCe75mnk6248OeA7OP+C1kOb2DtoS8us6TbtlHJf9ii1+TCS7nJr1R7NNRXdhoT/Qn7lgFhftemadD+R948L7NioxOkCBXUFuLC8Pcqn5u9F9mpgXC3jsb+lSk8Dkpz9/gCgfAzJ50Kdn7dvl8LBl0mfGEYWFG7Bk4foho7AbXA1Pe6Jc2AfKzJF835WgmZHOiptgZERp5Ir1RCFq+Lt++v4merDIYlX/fk/cmMBJPnFtzoit818zmIlihrmn3eSIgMKyqnI6xD9+x7UE6fSZjlyrTTldY/KfcXiPYrNRMnhP72ezx16BYeEZ/wHkW7aLma03QQBGHq1h7gtn1d5x81QddMyjsmTnBaNz+u4XUvkvtaeFO4OIamMKkwpCs73YO12ntutngttAHdp5d39ZwBecJ6NOeErFEqqBPsYi1CasJulHBBoona5mVjNIVk5JVYUhV9ccOETt2zjORTqukeB0HWS3MT8XgqCy6bnxivc/u2XUaAhB6tX2UVrdj3rUVvbhQmBKqYEf4gKwwAB5v6Q+2EsZQsVm4kfLDg145DMIRpKzEtg11hwgZz8u9j+z8MxO/5kasw6+o8mx9XDtljjwBtJ/5KWWd6pHSM9QvlLg/dQiRzxuCEhKNPnLggsj0GSXffoVAnwslCZ2+eNf2AwwzgCVjn/BxEshlSk
 IYW2/aJ3
 6BXYTGg/5z9HYxQHTXMuxvwltsvECGIbZvYwhwJcBQkjUNq/w+FziVyuuc6/dxN1jextM2n4wk/AAT97K+VvPSbiBWNdSq2toHzPLpop6h6wcmRdlI/u9VsHya+kV3PQkQ7MFAlA9tNd2H3KkhpnwF+KR8K3LaJ12b4l752xhz1WyKGu/ztLZ4dZwaJ31qi56VGtJZSI00sG1q0ZAsIUfKjTcUT21exLrcTIb6zmBmJKBIP0nPbpIDvAD6WcHGPHswyEbyS+fOvmw0LqYjKJbgeWkLgHGxPALnVhpdeADy4rkqXr8gVc2bPf+4iTncgRdNHfvYKlHASWkNpVlwCCV+Ma2XGtUFHd6wldFwPr52gpsPauIJsqSGcgcS8gIJeCe7ikxlNMSljYpFVAFgJ/TwU1UFNrMskUGSUwa87GP4nazExpBox2W8nVj469iO5rs8NOgxrFT9SssCegFLAStFqXMNaLSbVXHOmWEOCen3gQG55Z2w7zkcd3QdiQsxFpi74TCjL23uRQ/93qjsXTkqSpUFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jan 30, 2026 at 3:23 PM GMT, Andreas Hindborg wrote:
> "Gary Guo" <gary@garyguo.net> writes:
>
>> On Fri Jan 30, 2026 at 2:42 PM GMT, Andreas Hindborg wrote:
>>> "Gary Guo" <gary@garyguo.net> writes:
>>>
>>>> On Fri Jan 30, 2026 at 1:48 PM GMT, Andreas Hindborg wrote:
>>>>> "Gary Guo" <gary@garyguo.net> writes:
>>>>>
>>>>>> On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
>>>>>>> When copying data from buffers that are mapped to user space, or fr=
om
>>>>>>> buffers that are used for dma, it is impossible to guarantee absenc=
e of
>>>>>>> concurrent memory operations on those buffers. Copying data to/from=
 `Page`
>>>>>>> from/to these buffers would be undefined behavior if regular memcpy
>>>>>>> operations are used.
>>>>>>>
>>>>>>> The operation can be made well defined, if the buffers that potenti=
ally
>>>>>>> observe racy operations can be said to exist outside of any Rust
>>>>>>> allocation. For this to be true, the kernel must only interact with=
 the
>>>>>>> buffers using raw volatile reads and writes.
>>>>>>>
>>>>>>> Add methods on `Page` to read and write the contents using volatile
>>>>>>> operations.
>>>>>>>
>>>>>>> Also improve clarity by specifying additional requirements on
>>>>>>> `read_raw`/`write_raw` methods regarding concurrent operations on i=
nvolved
>>>>>>> buffers.
>>>>>>>
>>>>>>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>>>>>> ---
>>>>>>>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++=
++++++++++++
>>>>>>>  1 file changed, 53 insertions(+)
>>>>>>>
>>>>>>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>>>>>>> index 432fc0297d4a8..6568a0d3b3baa 100644
>>>>>>> --- a/rust/kernel/page.rs
>>>>>>> +++ b/rust/kernel/page.rs
>>>>>>> @@ -7,6 +7,7 @@
>>>>>>>      bindings,
>>>>>>>      error::code::*,
>>>>>>>      error::Result,
>>>>>>> +    ffi::c_void,
>>>>>>>      uaccess::UserSliceReader,
>>>>>>>  };
>>>>>>>  use core::{
>>>>>>> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>>>>>>>      /// # Safety
>>>>>>>      ///
>>>>>>>      /// * Callers must ensure that `dst` is valid for writing `len=
` bytes.
>>>>>>> +    /// * Callers must ensure that there are no other concurrent r=
eads or writes to/from the
>>>>>>> +    ///   destination memory region.
>>>>>>>      /// * Callers must ensure that this call does not race with a =
write to the same page that
>>>>>>>      ///   overlaps with this read.
>>>>>>>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len=
: usize) -> Result {
>>>>>>> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, of=
fset: usize, len: usize) -> Result
>>>>>>>          })
>>>>>>>      }
>>>>>>>
>>>>>>> +    /// Maps the page and reads from it into the given IO memory r=
egion using volatile memory
>>>>>>> +    /// operations.
>>>>>>> +    ///
>>>>>>> +    /// This method will perform bounds checks on the page offset.=
 If `offset .. offset+len` goes
>>>>>>> +    /// outside of the page, then this call returns [`EINVAL`].
>>>>>>> +    ///
>>>>>>> +    /// # Safety
>>>>>>> +    /// Callers must ensure that:
>>>>>>> +    ///
>>>>>>> +    /// * The destination memory region is outside of any Rust mem=
ory allocation.
>>>>>>> +    /// * The destination memory region is writable.
>>>>>>> +    /// * This call does not race with a write to the same source =
page that overlaps with this read.
>>>>>>> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize=
, len: usize) -> Result {
>>>>>>> +        self.with_pointer_into_page(offset, len, move |src| {
>>>>>>> +            // SAFETY: If `with_pointer_into_page` calls into this=
 closure, then
>>>>>>> +            // it has performed a bounds check and guarantees that=
 `src` is
>>>>>>> +            // valid for `len` bytes.
>>>>>>> +            //
>>>>>>> +            // There caller guarantees that there is no data race =
at the source.
>>>>>>> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), s=
rc.cast::<c_void>(), len) };
>>>>>>
>>>>>> I feel that this should be a generic utility that integrates with ou=
r IO infra
>>>>>> that allows you to copy/from IO to a slice.
>>>>>
>>>>> While that might also be useful, for my particular use case I am copy=
ing
>>>>> between two pages. One is mapped from user space, the other one is
>>>>> allocated by a driver. No slices involved. Pasting for reference [1]:
>>>>
>>>> Then what you need is a byte-wise atomic memcpy, not memcpy_{from,to}i=
o.
>>>
>>> Can you elaborate on how you get to this requirement?
>>
>> Memory that is possibly mapped into userspace is still normal memory, it=
 is not
>> I/O. I/O accessors (and IO memcpy) are specifically used for MMIO, and y=
ou
>> should not be using them for userspace memory.
>>
>> For memory that can be mutated from userspace you can just treat them as=
 a
>> potentially concurrent accessor hence all accesses should be using atomi=
c. When
>> tearing is acceptable, byte-wise atomic is sufficient.
>
> I would treat them the same as DMA regions and MMIO regions. As these
> regions are outside of any Rust allocation, if we never make references
> to them and if we only operate on them with volatile operations,
> behavior of the copy operations like these are defined, as far as I
> understand.

I don't find the argument about these being outside Rust allocation very us=
eful.
Apart from MMIO, I view all other types of memory still within purview of t=
he
abstract machine.

>
> In the last discussions we had on this, the conclusion was to use
> `volatile_copy_memory` whenever that is available, or write a volatile
> copy function in assembly.
>
> Using memcpy_{from,to}io is the latter solution. These functions are
> simply volatile memcpy implemented in assembly.
>
> There is nothing special about MMIO. These functions are name as they
> are because they are useful for MMIO.

No. MMIO are really special. A few architectures require them to be accesse=
d
completely differently compared to normal memory. We also have things like
INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor su=
ch as
readb to perform access on the __iomem pointer. They should not be mixed wi=
th
normal memory. They must be treated as if they're from a completely separat=
e
address space.

Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by =
the
different types of barriers needed to order things correctly for each type =
of
memory region.

Userspace-mapped memory (that is also mapped in the kernel space, not __use=
r) is
the least special one out of these. They could practically share all atomic=
 infra
available for the kernel, hence the suggestion of using byte-wise atomic me=
mcpy.

Best,
Gary

>
>
> Best regards,
> Andreas Hindborg


