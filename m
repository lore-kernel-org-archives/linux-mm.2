Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B859E6BF0B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 13:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F1D6B0005; Fri, 30 Jan 2026 08:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D1D6B0089; Fri, 30 Jan 2026 08:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1E36B008A; Fri, 30 Jan 2026 08:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 197386B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:10:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A30191B1997
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:10:29 +0000 (UTC)
X-FDA: 84388664178.20.BD32361
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021106.outbound.protection.outlook.com [52.101.95.106])
	by imf07.hostedemail.com (Postfix) with ESMTP id ADA1D4000C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:10:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="Lnbjn/V9";
	spf=pass (imf07.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.106 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769778627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsNxMFM4nVPBm3vTxgidFT8kVAPmEF338dYvqpw5NTw=;
	b=tjDOxKLmbkgEuvWRvRRu1k2sEEtmElNeEAczvHTrRbZA0+W0IWGm7I/Rs0kNOr/nesrHJB
	3ntmPTwbQYoc5q7GqCRLNQbGLTontXuoZUk/REGV98l6PB9VrZaGkW8O/QZLlNkzxmjOSQ
	WuobBswLHtcmV8GaZfKMXym+eUCWuJI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="Lnbjn/V9";
	spf=pass (imf07.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.106 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769778627; a=rsa-sha256;
	cv=pass;
	b=IjZonbn8uQZ/7CTuRGLCWk4zyz8BhIbijx5iu41GxAZ1MegoVHLivBsk+vGrpcL4xl8WP1
	tSsa443ymUTkiGDTfmuiCuZbhSJWr8tBA4syGowgvR8ezN6l+UJcVdYc9NIiC8mUkH94Gj
	XJxDJ5EHx+b/mer/gvwWTwkc1mGpuRM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CK+BVSLq+KFfj0oPrffi4Ww718HhvvXjPKE3N2LssMVr5NMnp/DUx2JHl0j/bZnXKuy41xmr+4cNz1yAC/dS4HybqiCm+BkvJ1sYCL+BoJqgKDHDM0PWD9k+FJmvSmPaNGR91c9LhpGaFFWi0nJ1uzvC4PnlkqzVU4mG/DRAAvvOqhPyU7Aaan2PHPVp4T4wj/1al+ViFEIzt6bl1z+1B2S1Xr7YaZsXfM8dss86Ubi2aEjp4PrhXKflB9aDZxz73qbDjfNmAPSs9KbWgTi4fjnAGleS1RoKV0KiG4GFJWuTlDvtq58V+EJfwQHOcIc7Jl1JGs5By2X1Rm4EOhXV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsNxMFM4nVPBm3vTxgidFT8kVAPmEF338dYvqpw5NTw=;
 b=nCsKqTD1iOgWq4OKa3o0ozHsXDFhcXMkT31lb11HW8l0DPpzx9pparOwGW4cX1ZfI06JefrdKgYzBwPCVu/REJ4SmMV3vWtkGmB83pCNqug3gaurBhU9dlolZoGYoxgH28TzpDTGVUWYxeD2KZ8oRu2JLzXnnaJiWheqlMG+BlR4JgMlgAW8FiDOZ9/SPH+0hYmx3busQlYenlM5aMblNVfXEdW+NGF5dLtVYExSNp5IGqdtgc0VE1XKNPNoQMfDUJ0bUgx7hCUHZpFqt8nAthvwJaEAI6xSHjmiBh7KUxJ1u54iAxiUGA8bY1J/HxqWG3QzQ3GeNrF4ggX+HYj4Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsNxMFM4nVPBm3vTxgidFT8kVAPmEF338dYvqpw5NTw=;
 b=Lnbjn/V9ZDayJglluAQGk8J9lRDdtrCxOHXxKUXP6UgBZ6ltpOHcXA14HyrqM2E0zlqgxlAmJYEEZkhCEeoruTM1PoAwSyI3ZRhrrZ2TkPd0dA2lW0Z8gZ12BfWRrbHhF7QC1lNhZ/wfMhg03G7Fyu026BJjUu2itzTQV4Is9VE=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB3068.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 13:10:23 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 13:10:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Jan 2026 13:10:22 +0000
Message-Id: <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net>
Cc: <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl"
 <aliceryhl@google.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
In-Reply-To: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB3068:EE_
X-MS-Office365-Filtering-Correlation-Id: 97152da5-54d0-41e7-d0e7-08de6000ed29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHBYTFo4bGdLV0V3cTB4OXlGRVc5UVRnQ0VZLzgvVmdENGgybVdiV0V0UFpN?=
 =?utf-8?B?ZVR2YWNYSkVOb1B6MXJOdDlscDRLUzZBa0N0am9MYytMWWNsZGlJTHMwZzEv?=
 =?utf-8?B?dW5xeFNHUzU1SjBnYnJaN2RGTVUzYmxKTjZYZDNyaHFabGU3U0RmL3NzclBn?=
 =?utf-8?B?aXFwNHBHbmt3RHZ6cjJWQzF6eFNzd2VPaHkyMDdSNnAzUUJxZGlWS25TVU55?=
 =?utf-8?B?MHkzUlVvUk5QNEdJakwwN3ZHdVlaTmNIKzN4L0R0SS9rVjJKNVFIckJLZzhJ?=
 =?utf-8?B?M3Q5Z3BkMXlBOXdmSHpMVE5ZZzVGMlFORGVQV2JJcG04dStudGdFaTR5Zzdi?=
 =?utf-8?B?Ti95cjlLcEtVSW5aTTNsREZDV1JwLzNJQ2pWeEZuNjd3VndwT0V2WFZ5bjIv?=
 =?utf-8?B?OEhKcWpsSGZKbEhXa0Z0Z0ZJY0NhcWx0QlQyaVp0MkZ5YjhmRTVOSlMzNjUx?=
 =?utf-8?B?bGJtMXZWVzRXN2VNRVB2ekJ1N2hYaE1VU2ZSM2hDVjcwRVdOcWphZXM0K3hQ?=
 =?utf-8?B?Q29SOHVuQzljSlE3aVprdlFRZVBaZ2JTNjJwUDY1aEtOVmxtOW9SM1liVjIv?=
 =?utf-8?B?a2NoT1RBa1NYbWhVOEYzWXpIcUJ2aER5SmpJaHJLT2MxdnVDQ2hwemk5dGpi?=
 =?utf-8?B?akp1QlUvbkZva3NTSUo5alppL3dXVkpIQVBmZ1JtS1hYTC9zdDhTeWdPTWEz?=
 =?utf-8?B?QjdUVGxFYjJ5aFB2Rk55TFdwR3hBazJ1WFY5YnphUVhheTJscDlqY0h5cEhk?=
 =?utf-8?B?R1I3NXVUQytBWiszSHNiczVQVk9HeXdHMGp6QkJlYkQ3aDFaeDQ1VkdMQ0Ji?=
 =?utf-8?B?TVZEcys5Yy9XMGJTVGVpd3dsNVRZbS93N1QyMDRmdmVVUWU1WkRRNDZkU0lY?=
 =?utf-8?B?b0dlQWtsQjRLWjltdGpzYUdadFdUcUpQSUswMU1JcXg1a2swWDkxbnVGbE1T?=
 =?utf-8?B?MHJZOVRHMm11VjkvQ1l4cFhRU20zN2RCQzJWVVluUGlOQTJXNFg5MThXcElk?=
 =?utf-8?B?ZWg2dlVXTWtzaDVOOHJ5NjNNckx6eEV5cVZYelNaMUh5OUd5TWprd0RqWnRz?=
 =?utf-8?B?SUs0Qi9rL3lmSzRHd1hZOVM2VER4Y3pPeXplenFvSGszaDZ0QjRUcnJSdW5P?=
 =?utf-8?B?UjZYWWZSRWNIK2NiTzRtZVhFTDZ4WG54TlV5T3FSV1VrdUNqWHM1K0M2b1pl?=
 =?utf-8?B?WXhYTHlGU1c5SGtHQ2VKVnVLdUhIekkyVVBNQjlDMVRyS1U1UFFnQlBkZVVX?=
 =?utf-8?B?ZG1EbzI2MzhwclV1TTZlZVBGdEZocUhFdG1SOFVVdmxwM3lwQXRQN2cwVGFQ?=
 =?utf-8?B?bStuZVF1Z3lkRXByME5aM1J3b2IzbXV6aEJJWmdsYWs4Lzl2Wkkvam1ZWE5C?=
 =?utf-8?B?enVPanIvbkE4Vi9jbzhwWDk0N2dUZ1ZWNDBFd0U5SnZnOTJPK3dHOW1aaDc4?=
 =?utf-8?B?azA3anovNjVYVUNmZzNIQThKeDFLRVJTeGRZUDBnTVBMZ3RSeHEweWVJMWdn?=
 =?utf-8?B?bzlFVWVyUmpSRDlUTFU5WWtzZEpVSXI2OVYxblY5V2F4dFdSeEF4YUxqY1Fw?=
 =?utf-8?B?ZU1yRzIybG1HT2hPQWhFNW9oYVUrT2RaZkJSbFNTVVRWS0VVSDF1b09lb00x?=
 =?utf-8?B?ek5aVTA2bjZ1bTZkdStndmhTRlJ3TW1mN0V1VUZ5NDBQdjVXZW1mRDRxeVpJ?=
 =?utf-8?B?VE9VTEd1Y3lPNVI4U3RmQmFsWXI1MzlJZGdqMjBTeDVpQjBRRXlqMFlMdVMw?=
 =?utf-8?B?Uzc0dlQ5Vi9VbnB4WEVNSWpTMGRXQWE0RllBTnNCUHE4Mmx6MTNmYlRlaksy?=
 =?utf-8?B?bHJxNlByeTlhUU96a2Vma3lUa1NXRSt5bzFvS1oxNkZyUVlEbzBzRjBsK1Qy?=
 =?utf-8?B?UnBoTkYzYXp6eDBQMThUTEhjSW1ya2d6YmNvNW9neUFtZVcza1hadGRBdmpX?=
 =?utf-8?B?MHZXWmhqRzd4elNUMU1IS013Uy9mZVpKREpjOXlCMFVUWXEralh3RUNpSzBB?=
 =?utf-8?B?eHNrTFdaaGQwb1VYUFZ5R0xnSVFJVmk2UGFRVmxCK2NVaFFTT0VMODVla3JB?=
 =?utf-8?B?a0J1TlUyd3ZWQjJsclVScW9zYXVCVWFYQ3BraEw0dkt0VWc5M25PVzgxa2JJ?=
 =?utf-8?B?UGN3dHJFaHpsTHQzVVh4MUM1TzlPYXpQRUUraURURGU5NnordVdVQ3NOM2ov?=
 =?utf-8?B?Wmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTV5Y0JQalg3Y2ZCOUhibld3Tjc4Tk9rWXJ1L2YxQWdvUTJwZy9wRU9MVDJu?=
 =?utf-8?B?V1JOYk5nOUp5N3pvTkRtNG1VZ1lPVXRPVEpzRGdiUzdNTXpRVkY0YmZITEI4?=
 =?utf-8?B?RENUdENxVGUxQlBKRFhSVTVoWndTaTNoMERIQXJGejZmalFxWEI0N2lUM1cr?=
 =?utf-8?B?dTZQeW40cDdoamFaL0RWbjhNQ2ptaUYyNW1Lc1U1SHFYUnVDZ3JLeGwxWm84?=
 =?utf-8?B?eThxRjlyNnNZV2xNVjN2bzVnakhxR2dPaWVKOExra1d0NFRjQUYwenBTNjVu?=
 =?utf-8?B?SkJOVzdrbmtJeXZyalZCNnRYdERSdkZCOXFIWUZ6eFE0dStoNHBoaVcwM09G?=
 =?utf-8?B?a3YwbVpqL096QVBYOWd2SFZYS1ByOG9nUEZlMWxBdnEyT2RxWmkrck9JVVJs?=
 =?utf-8?B?Y2RlZVRSN3Y2bTBTcHF1RHJBU2Y5b1BTVHRpWHhrSU8weUVRRElFczFNSjJ6?=
 =?utf-8?B?VkN4UExsQ0JLd2h2SkZ0SnArekFtRXQ5eVpYRVpKZ1ZybkgvLy82aTdyYlVB?=
 =?utf-8?B?MnMzejBwQXNnUEdhNTN5UlNMRzd2KzY0OFlrc1R5NXhneU45SzVGOGFOMTIz?=
 =?utf-8?B?K05vZlRMQU9XOWdjSVYvc2prVWR0TFVZSU9KaFRLV0RndlVCOUphUXpxSUYw?=
 =?utf-8?B?MWhrcjlic2R1eXpJZzAxbUR6MDdqNmxmUUFCR3o5TEVPdktmbmUxZ1ZWSHVO?=
 =?utf-8?B?L3VJaDdhZWo1d0t6OWdjNnplaFU4dlp4S0VyNXdad2RJQURhUXpJS3h4dlpC?=
 =?utf-8?B?eE9qZHNPbzNNemN2aWFXTHNGVlFpR0drbzF6RE1rMUdiS1d0U09NTnFPT2pz?=
 =?utf-8?B?ZXJZeVpSTEhZSm5ybVU4dkhoZlNJZFlYdGFPNWtOQXBPNVlnaHVDUWlKdUh1?=
 =?utf-8?B?cmVjRGorVlA3NisxV1o4NzVMZ0FUMDlkR0dpT0RIdE5nWHRpN3d3V2tkTUNI?=
 =?utf-8?B?UWtUMk9CRHJoZ1RDRmJaYURuWnZtb3J0R24waTFJZ0p6aVE0TkVRYlN0WmpK?=
 =?utf-8?B?RE9SdEd3MmNEdlNEcWlqSm5OS2hBNTYva1QyWVg5UTVVSjhZVGpGU0xmb0Qy?=
 =?utf-8?B?RU9JQ2FRVkNoTnVjN1EvQkJscy9ISy9STE9Zb2ZOeDg3Z1YrMGMyQXlHdUgy?=
 =?utf-8?B?TjRrQXMxcy9GaDVVMnh1ZW9DU0pvQ2FXWFpGOGtlY2VvMVdJclBZTjJ5cHB5?=
 =?utf-8?B?dkZyTjd0R2U5dm03REFXYVB1bUFQdnFhS0FXczN1V2lvdWNBQjNRdU9HU0Nt?=
 =?utf-8?B?LzQzKzZOaWZWSWtmNE5yUDM3SlorZDh0bFZhMys1MjFGN1hZOVIxWmphZmF2?=
 =?utf-8?B?YWp5YTBWQTNHVHFNL3FZcGEwenZkNE50M2NNaEt1UnpyMllVR1JERWJ0cWFw?=
 =?utf-8?B?dWVpVjRuakFkQlB5MTR6RXR3TUhySlI5emcrYXRtUUE4QVRLN3BnNndRQnRK?=
 =?utf-8?B?UHBnLzRacmVjWnJ4ZFJmVzBGbEpFdndQdlhKamEvVExyemdTbk12cWc0c2VD?=
 =?utf-8?B?YVY5dmZRQTF2WW1VNE5LWHNOTHFkaXdWYlFhMlI4UVkxQWhXN01XNUVENklv?=
 =?utf-8?B?YWkvdkNhNTR6UmhsUWkxZUhJYjhaR3NqVjNjcHJpcG1LTWZNR1AyUmJTalZ1?=
 =?utf-8?B?aFlTSHVZN2NqWHk0WGJxT0diYTY3TXpudDV1SThIOGZPN1dxMnBmLzlCN21K?=
 =?utf-8?B?QXdzVkdoWlhVWGlILzNncSt1cElRc3J0S1RGSTNxN3NUN1hEbm9INjRJTzg5?=
 =?utf-8?B?NUVFSXk5dnNLNzYwUVNDMndLOUs1YS9MS3psaER5NTE0QnZ2dHRxTllFcFlt?=
 =?utf-8?B?VDBGeXJLWTJvcnAvakVWNjlEVFlzMW5kcFRyYStINW1HNlRLVGlTOVhlaEts?=
 =?utf-8?B?TExtbUJLQ2lBR2x1NjZmWmducDdnamtieHhhRDJtcll5MGhzVDV3SUV3ZFpm?=
 =?utf-8?B?ZXdmNVdtd2p1c2RiNkhUVDVhdElsVzJrR1VnY3EwY2RzQTNSN1hZaHkwZFV0?=
 =?utf-8?B?UmY5YU5UdE5FSWlQWlh1ZmY5WFV6ZEhleVI0NkxmcXFGSWpkb0JwMmZZajV6?=
 =?utf-8?B?Tk16RGl4clNCWmhNS1VHVTdPY0Z6Ni82Nk1Va3JTRis2Q2kyNFJnZVhPVlhr?=
 =?utf-8?B?TGlDVjZvd1MxWHNJbnVSamtuZno0a1dvaW9abFBmUFNGWnpXSS9ZSjVHQU9M?=
 =?utf-8?B?dU9VQ0lLc3RpT1hLc3dRY1pkckdjeXFEQTBYN3drRE82aEhybWQxdE1VODVz?=
 =?utf-8?B?Z1k5SnFJWnF1L0RMZkFsVmFHZjgzOU1KNzVYNzNsY05sMGRCdzl4RmdqelBl?=
 =?utf-8?Q?5jZkXS77MS6dAtA052?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 97152da5-54d0-41e7-d0e7-08de6000ed29
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 13:10:22.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O10x0UVdJtYrtMQmX6ME6IamRdA27MwTbtW7WTm/dK319OMO3XbpSxgRFU7U+SCzAiN7XE2bThjmGeTWN3N4QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB3068
X-Stat-Signature: z8fewwtyzfm8bfbfhcnkkogsrmd1km47
X-Rspamd-Queue-Id: ADA1D4000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769778626-951502
X-HE-Meta: U2FsdGVkX19Zqxza5DmaoManNvsTSd4KqyaB3bkuzkoPHz6YwwN9V88pVmDYxiN/S+VxgfFGRAwAzXARP1JWJVq909HAhPqOgNNUX7/hhoQgmLcDrHT5yBUJaO3V803IuirLNRoNsIVsH2nDUqANPp2X9jAZw6zc6OC2Mq7Qmg41n8Rb9nwdRRS9+uYjb3VZ3AuKeoBT9VqrcLCZU5YW7dX6V3Cmys6tiawUFBmPx4BaiJZqUbvm1v6aG7eF1VtCSmlrtidg6nDgSz3gQ1Ubh3mzzMP2dw87scz2K860GB2IJ1rti/UGgnMEcFOU7AIdYCbkMd6YFSWg/O/72El0MWzDkUaLcxE6a6nQ5WfgFTu1DOrn8TxCFC8tcSJ6bHlmXd6iB5XSp0L93ymdd5JflflIVbXqlXZxH9+GFK+QGX/9r/Xn6rzsQUefHIUTqPafPDoQilN3+uczpY3NRm3JK1PgAiKz4rbisYGIa3Ah+yfDkaETl6sHSaLPaF8YCwGD88sN5zZKGVdvxcuDJAca+9di+z7/KCf/asbPn3Pz6plm0bEnO8Btd9u4g569ojasxGEt9YG4ZDFaAkRIVqlzCW9NbrcH39WWA2822mw4jJsuMDMYcIl+QukP2QjBGCjGdLZam3YE2mxWdECiGS1Jv23+ny25Dj05whIWMGjjxK6ZI35tbUqml+si7LBavQRoi9OBH1iKDR9nfz8IYQ4/n71SooGo87OgHG0hJqbszyleTSbbu2WCdcBq/kYcn4eODawkBCfTW9Wh5/PB+QTdiFxji4pQsg+QVwKSiae/qy2Z/zHFzPrhYOPnUUcFf0NNduUCTI2Iwf8NvYMgPzVMd40q1uzJ84m2FMSbr4SO7WCGph1UWfG9+caNcildv963GUJ0Hh5dV0HkC/sdSFylArVrT3AUqCjYY189hvU9dOm6lqVNj5eBZX4ZjpBJ8GUqSCYDMr6h2MYUsvIRvsZ
 k9c48xmR
 29HKbt0mQB7uCTyz4rQHjitAnfruQwBgF63h44t5FPplu8P+SturFBp66YrUSk1Qg+gVYARWKgdY8wETUKpTZHt0AFN345z1N78fHzkS7mA2SWPEJLnCkDnmXt3n40whM8acJFpZkCXt5YC/ZmmCBFd/sby/X+7/9t03tGoYcFHBNWWUIBDj3ceQId0ss1ZPVOD7q/prRUwAqy0N2evudSJMF+vqVOBKFgGUWJxLJeHrMQoB8WoU9d7d0hX6AN672H1AmD/V98K7a59eUe7bZfFsy6OqwZuKS3OOPrIDsXkTlbytPXwa4Hnu+qzscdp5jvu0UywzPOOWSITk8UVxUIiKdCp0z8+adCK2z3VNtAnqKEWFOMdyeS8E9OF+Crwu91egQlAqdsBUw+M119qkv0KpB68MsLWmgF0uqEwZNT2A9AQ+iM0zE8vWGrnmoqeZenHJqXPabjiO3nrf9Jk0ZKp/VtXupat+aDPt4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
> When copying data from buffers that are mapped to user space, or from
> buffers that are used for dma, it is impossible to guarantee absence of
> concurrent memory operations on those buffers. Copying data to/from `Page=
`
> from/to these buffers would be undefined behavior if regular memcpy
> operations are used.
>
> The operation can be made well defined, if the buffers that potentially
> observe racy operations can be said to exist outside of any Rust
> allocation. For this to be true, the kernel must only interact with the
> buffers using raw volatile reads and writes.
>
> Add methods on `Page` to read and write the contents using volatile
> operations.
>
> Also improve clarity by specifying additional requirements on
> `read_raw`/`write_raw` methods regarding concurrent operations on involve=
d
> buffers.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 432fc0297d4a8..6568a0d3b3baa 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -7,6 +7,7 @@
>      bindings,
>      error::code::*,
>      error::Result,
> +    ffi::c_void,
>      uaccess::UserSliceReader,
>  };
>  use core::{
> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>      /// # Safety
>      ///
>      /// * Callers must ensure that `dst` is valid for writing `len` byte=
s.
> +    /// * Callers must ensure that there are no other concurrent reads o=
r writes to/from the
> +    ///   destination memory region.
>      /// * Callers must ensure that this call does not race with a write =
to the same page that
>      ///   overlaps with this read.
>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usiz=
e) -> Result {
> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: =
usize, len: usize) -> Result
>          })
>      }
> =20
> +    /// Maps the page and reads from it into the given IO memory region =
using volatile memory
> +    /// operations.
> +    ///
> +    /// This method will perform bounds checks on the page offset. If `o=
ffset .. offset+len` goes
> +    /// outside of the page, then this call returns [`EINVAL`].
> +    ///
> +    /// # Safety
> +    /// Callers must ensure that:
> +    ///
> +    /// * The destination memory region is outside of any Rust memory al=
location.
> +    /// * The destination memory region is writable.
> +    /// * This call does not race with a write to the same source page t=
hat overlaps with this read.
> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, len:=
 usize) -> Result {
> +        self.with_pointer_into_page(offset, len, move |src| {
> +            // SAFETY: If `with_pointer_into_page` calls into this closu=
re, then
> +            // it has performed a bounds check and guarantees that `src`=
 is
> +            // valid for `len` bytes.
> +            //
> +            // There caller guarantees that there is no data race at the=
 source.
> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cas=
t::<c_void>(), len) };

I feel that this should be a generic utility that integrates with our IO in=
fra
that allows you to copy/from IO to a slice.

Best,
Gary

> +            Ok(())
> +        })
> +    }
> +
>      /// Maps the page and writes into it from the given buffer.
>      ///
>      /// This method will perform bounds checks on the page offset. If `o=
ffset .. offset+len` goes
> @@ -282,6 +309,7 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: u=
size, len: usize) -> Result
>      /// # Safety
>      ///
>      /// * Callers must ensure that `src` is valid for reading `len` byte=
s.
> +    /// * Callers must ensure that there are no concurrent writes to the=
 source memory region.
>      /// * Callers must ensure that this call does not race with a read o=
r write to the same page
>      ///   that overlaps with this write.
>      pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: u=
size) -> Result {
> @@ -295,6 +323,31 @@ pub unsafe fn write_raw(&self, src: *const u8, offse=
t: usize, len: usize) -> Res
>          })
>      }
> =20
> +    /// Maps the page and writes into it from the given IO memory region=
 using volatile memory
> +    /// operations.
> +    ///
> +    /// This method will perform bounds checks on the page offset. If `o=
ffset .. offset+len` goes
> +    /// outside of the page, then this call returns [`EINVAL`].
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that:
> +    ///
> +    /// * The source memory region is outside of any Rust memory allocat=
ion.
> +    /// * The source memory region is readable.
> +    /// * This call does not race with a read or write to the same desti=
nation page that overlaps
> +    ///   with this write.
> +    pub unsafe fn write_raw_fromio(&self, src: *const u8, offset: usize,=
 len: usize) -> Result {
> +        self.with_pointer_into_page(offset, len, move |dst| {
> +            // SAFETY: If `with_pointer_into_page` calls into this closu=
re, then it has performed a
> +            // bounds check and guarantees that `dst` is valid for `len`=
 bytes.
> +            //
> +            // There caller guarantees that there is no data race at the=
 destination.
> +            unsafe { bindings::memcpy_fromio(dst.cast::<c_void>(), src.c=
ast::<c_void>(), len) };
> +            Ok(())
> +        })
> +    }
> +
>      /// Maps the page and zeroes the given slice.
>      ///
>      /// This method will perform bounds checks on the page offset. If `o=
ffset .. offset+len` goes
>
> ---
> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> change-id: 20260130-page-volatile-io-05ff595507d3
>
> Best regards,


