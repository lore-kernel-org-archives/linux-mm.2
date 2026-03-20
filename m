Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7371D1099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD356B0115; Fri, 20 Mar 2026 16:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3F26B0116; Fri, 20 Mar 2026 16:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2D16B0117; Fri, 20 Mar 2026 16:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8968D6B0115
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:32:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 357888B317
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:32:17 +0000 (UTC)
X-FDA: 84567588714.21.8FBEA2A
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021125.outbound.protection.outlook.com [52.101.100.125])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4961940005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:32:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=NvDwm4JH;
	spf=pass (imf01.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.125 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774038734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhVls3FCmOMoAyAIvyz4NCrtc357yylpUUsinZKXSQw=;
	b=CuqyJPOsY9rMQHjY0PYK2IuizA+lT+Q+elSnAfM4EsDjrpUrJWtamQOkcTu+ePv49d+I2z
	okdhfzHVtxfUdv/Jg5aKiOGagyIDFHQlEqQ0Kd4CX3a3YQaGyYYjxZV/5JyOHlmJJjXdIf
	RVl/ZpaSL+Irs+Gx4ouefn7/DW9ysuY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774038734; a=rsa-sha256;
	cv=pass;
	b=nb94qfYWj/GfkPv82psPd9TeIcI7A5Rv5Jqw2Yl9pRsWEPpIqir+anwn5LhT9sWDnEUhdm
	QMDo/czx/m2/j5PPc2hBHNZWTprPzX/cnps2Njeam4tZpsmR7htEJDajmTdnu3SQXnZwr4
	Ka0noH13WO4W2TcB+qXNL3LRTQLFxI8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=NvDwm4JH;
	spf=pass (imf01.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.125 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AY8np6cpbnceQoYc7ZLduNMZmHM5mqGJrka6wZLQEiRIw4KIJCLcDwISxpBJ6Y3EGvNgo5qmyBXCzepSBoMER8O4ijD1iSpTaaECkzh6TqxsX+rjtPOudvDxRsuR/uRHblV2rVvG32/1sN5gCvHRgDyHtI2uXGd6VIckCOX2S/liZ827IFt6jahx3e1fS/ETVof8x4RWJpTWlxhRYnI4M/y47/c+15XnfBXWviBUvNjRT6tK9hNsO3K0E4wENDlQXQDPzO+78SJePr9UrpmoWEKNBpIm5aMsEwtlcC1dECMZBfALGN4P5bwzSPH/UMrHcLkQuyBD+NCaXbJHqtLsvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhVls3FCmOMoAyAIvyz4NCrtc357yylpUUsinZKXSQw=;
 b=eqELpb92vt7yvnwwfUh/h8ANUp6ZAzN19ZszFOhRD5kKF9NZ67BF+COEx7bfE1gFcFkUFcZpVIZtl5ZGJZfis25ieYrbRHpe7G2rrMM4zIPxrq/DKHqHqWYs1RLNFT9tPcR3OVwZkWvdVtoxQao4Gx1Vk/fYpbfD1Mwhg+9OW+kjAxKlC0YGe1jUR4Z7Z2gy35bbGK8rdYFkAOAqhoIdfazwp0s+BLCS0jkr3OVLnO2BY3uwhbyMdZmX4JCeehiqs5AwVcCY0E2xreOPaYEoLuv3tAhkVTLho9i9VXDvCucdGu03NLTZJrorDq5Qre/6qPq8bo06zyv7MnKF+Fa5Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhVls3FCmOMoAyAIvyz4NCrtc357yylpUUsinZKXSQw=;
 b=NvDwm4JHVlgteN+dD9Wswjo7Rs26uyS6vCq3qPntMP1fhZePK7qeSuzJnAl9UKAnM8W3PBcL73UOYK4NQfKXjty5G1hVVdDMpRmXKIBMpUg1TTDdtnxjHQLbSZKvAyErr/0oK0ldyqxJmS6jedPFg/vfKw74Yx0OpNjL3rOdG+M=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO7P265MB7849.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:419::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 20:32:10 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9723.022; Fri, 20 Mar 2026
 20:32:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Mar 2026 20:32:10 +0000
Message-Id: <DH7W8TLZAKUB.2E0Q2VS546HBS@garyguo.net>
From: "Gary Guo" <gary@garyguo.net>
To: "Roman Gushchin" <roman.gushchin@linux.dev>, "John Hubbard"
 <jhubbard@nvidia.com>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "rust-for-linux@vger.kernel.org"
 <rust-for-linux@vger.kernel.org>, "Alexandre Courbot"
 <acourbot@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Sashiko.dev for Rust for Linux
X-Mailer: aerc 0.21.0
References: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com>
 <87ldfmtfk7.fsf@linux.dev>
In-Reply-To: <87ldfmtfk7.fsf@linux.dev>
X-ClientProxiedBy: LO4P265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::9) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO7P265MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: b364b3b4-0d43-4d52-9369-08de86bfc339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|10070799003|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	1AyNQ7jqhQaZxAl2NQZTJU5GLJ4BR++baZl0zZsLNLmyOb6uzlwb4t/3hbgEBEFNXtUn4yft+sROKna/puAXIix13y4zmkqqTqJij7NTgxF8tv/rDkRqQl2Iqu4xmPk+/ZGfzt3qzkPjcZGKzcHLx608wkLkkiQHxd8bRi9beFri+DuLHUSWlMsnWaxisMZ0maa8bXICmvrjfPorDJicS1CYp0zu8OcqV03vB1iYG6J7TKMN2FJJa1CUchBbyFjwCd6ttcifzHUuoFfj9F+uErMM0a9sJlbeGGOz9JwwwU062ohP4bF6ZYmy0DpoYwsuZKOx+FL85Tc8/RIfkDPNSMRp8Y5LIR1FfwmOBp3w7F7i+G2TZIIBoX806eB3claUCJKqJcWhA9RMLLiB4Zh3yDsm3hzjuMjuVnHj8Jt4FLYNWEFiV/OTYhTTEAAbdK/1nXCXu0JGCaIjp7cL3UZngD0ugmbZA4jFGmX3n33cu5WFgtvset9R75RUhmBG8OU/WIwKRep/Op6zrQS4mixnbiZd1cZNLJtPtf5RRJ1hyOgu80XjmC6+zTxySfHGQrio3dDhYcCuI/cZPLmtkFa1/K6uXE1hNKgbjyshEvsgGuHTTbf1hLPh/Psnc0t+HBUOYyglMfGTx22E1oqc7TlyfCfbL9hDG0oMn1Zu9usvkuGaOoCOnbi5yw0gfWmLVC/Y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(10070799003)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjY0aFBoejBFMXl3REFpMWt3Z21SMnRQeGo5dTZOQWdBbzZRQ213NmZXazUz?=
 =?utf-8?B?OCszY0FjK1RFNmY0K2ZTN2RrcWlJZUpGam0vbFFRS0JyZTZnUWk3TFdPYWV2?=
 =?utf-8?B?emozSXR4N0k4UWF3VEpVMDI2eUdJc29UdjNTdDBVNEdWaXNwekhGYkR3TWc0?=
 =?utf-8?B?NEF4NVRQS2xXUDFFYjBwcVd1eG1QZEQxKytqTmNhU3dlR0p0enUwczVhelRh?=
 =?utf-8?B?NUdySTFaSTV3VUROYWJJT00zVVBDQ2IyNldxZThPUXI1UVVkcm5jT1NGV083?=
 =?utf-8?B?Y1NpeU1pdllEMklhUWRGSnNEeGxpWnZWWnVOR1hieUxJNzEvV3RmOHh5N3hH?=
 =?utf-8?B?aXZtTG4rNjE1Q1d1QjMzbktUOUphNnVTMXJwWHJncHNIVkg0T0N4KzFobzdU?=
 =?utf-8?B?UWQyYksvUnpuMzRZdEo1cXQzS29RWkpXSWFpenZ3amZ4TVNLSnFZWlQ1M2l6?=
 =?utf-8?B?L2tsR2R2YkZwV0ovY29MSFRSd2ZDVnRtdHNSUFlDcDFPZjlYVnYwQ3JwS0J1?=
 =?utf-8?B?eGFWODVmSkE1blFKalVlM2ZmaUpuQTMrM1V6dy80UEFkSFV0dHZGMzZJbGhR?=
 =?utf-8?B?b1VxTlRXVlpseEhoWlJ2SW5zZExlN09DL1pDczFwSC9IbDkxRlduYWVxWGN5?=
 =?utf-8?B?eWhPRUVRN3o2SzNyZHA2RjlQNmVEdGlaWXJ3SmxzNU4zdjVHQnRpdUZUR0g0?=
 =?utf-8?B?cnRTK2xMejdnV3pHMkx0ZWxJL0NBZWRXKzdsaWFmUXhUOUJodlNrY0xzNHpQ?=
 =?utf-8?B?WXJScEpPZjlYMktEL1IzS0FZN3NYVmZoNllDV3BqSzFSckViMlBqeFlzYW9E?=
 =?utf-8?B?bGl0TFBjdlFsbnM5REhYc2h4aFF6anArMWl2OWFHN294S2V4bndPWTZMelln?=
 =?utf-8?B?RXg5d3QxMHBBT0E2b21YOFNxRWdYNU15ZkM5RVpMZnAxL2lMSjFrSFo5aGVw?=
 =?utf-8?B?b2RrNFpvUG9WbzdrWDUremE1eEoyY2RHN0RGVXFjV1V2blU0clBJTXRCeDBC?=
 =?utf-8?B?S2h3NXkyeDV1ak5Pa2xubWx3ekMrK0dpMzNOeDdlVCtoYTF1Yld6Mm0rVWkr?=
 =?utf-8?B?NjFXMDFSdU5sbzIzcXlBRWprMHJJSFc1dVZPaXliL2dpbS9KZGQzUmFDZ2JH?=
 =?utf-8?B?NWlXUHRyUXRlMjJFdW9BRWVPNmhjekJLMG5BazJMejVzZi9xR25RRTdKenFS?=
 =?utf-8?B?Qk52Y1pZVUlpYWt3cDdOc1hOUnJvWnh1Sk9ZNS8vNWVrbjFVSTkyYk1PNjhl?=
 =?utf-8?B?NDlOb096VGs1amlzUXkxSDA5YVQyVkwwRzlQbUliN01IVzNNU09CcnMxemhM?=
 =?utf-8?B?TTl1eXhLWXNydmR4QTFTZWhvTDdjd0pqVmNNb1l5M3FPYWszSmNYL2lyZUtk?=
 =?utf-8?B?ejFhNTBjNjI5UWY0UklURkpsRS9WQ1Y4STRiVUlJWlNZbjFESFFGT1J6eUlq?=
 =?utf-8?B?cldSeGw2a2NBcVpsZHFTMGMwb1kxUVdjVTUySVJNQWtwbTdZV2VhWVlqa1RR?=
 =?utf-8?B?MWR0NVdEZTdROXVoVm1GSC84d1hJVCtkOENnY2Rudm1Ja3dwdmpZNGxPNjFE?=
 =?utf-8?B?Q3RXUnFQbm9DaHlDWDRZb21xaUlaSUJlTVNlZ1U4Nm1LTTk0VmRRNDNXQjFh?=
 =?utf-8?B?T0p5OUpGdzV1VHdOZXpaUjJHb0FTZGJCd0NERlp4WXFWQVg0eUZTbEEwL2hE?=
 =?utf-8?B?SXExNnVhYkFaNWRMUy9OejV6L1JJd1hpVDNDVzkxL0tLR2sxVkNBazJ1NTAy?=
 =?utf-8?B?czJkMXpiMDkzNFNnTkFQRWVvcHFmSURhWmVkcUF6SzYzSkpCTW83UkFGZDBL?=
 =?utf-8?B?dWszVVhNR2Y5dURINkc0ZUJieDNVd0trUm1QZE4wa1Q2V0xmLzM2SmQ4WkVr?=
 =?utf-8?B?ZzAxNGxDMTNtcVFxR2hwRDlxbWphNXU5RzhrblRYdzZQSjN2R1JYVjR3Z3lQ?=
 =?utf-8?B?NDJ0WHluVzUrWWN2bTB2dGtBeWU5bHdpYzVtU3kyWEc4alorbmJodFBIK0U2?=
 =?utf-8?B?clZEdGhweU9IeFRwYlYxZTdaOUhsVlRHaW9CeXpzVExENGE5ZEoxcmdCZkp2?=
 =?utf-8?B?K3VMNVBJaVF1Rk1wRUNmY2l3UEg4R2QzNW9DVXBQUStUSnNhY1JGellDWlJu?=
 =?utf-8?B?Szc0amdHZ21OZzdCbSt5akdhTGJjRXNnYUZvODhXbjNLQi9BTnIzSFVlUWJv?=
 =?utf-8?B?RDJiOGIrdVJNUDFLeWdHWVk4VWwyTWt6OFlBY09zTXd4bmRiWWJ6RHRRbWJH?=
 =?utf-8?B?Ykl5dUhFYlZlMGlDMm1XbTJ5dS9oa2Y5dzlYRm5PaXV6T0szV09QcmZrQ0Vw?=
 =?utf-8?B?Z0M3bHA2ZkxHVmljZE9COXdKRU51M3ZVWHVjbHdabjQxT2NLdjlYUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: b364b3b4-0d43-4d52-9369-08de86bfc339
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 20:32:10.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: siZAB7ydC1Gs5Gr0ag1AtNLRPKntLX9AvPPaB4nIF/VddOi1TdCiEJPOdpHk/Qjxj/0DDbbLZQPiB6DpKwOatA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO7P265MB7849
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4961940005
X-Stat-Signature: jh4phhs81f5awrs99kpy8uoqcxfi47ot
X-HE-Tag: 1774038734-942058
X-HE-Meta: U2FsdGVkX18vKUHn4GBnyA4GyMeRJeNREDFDee75bK+Syp6bWQGHcmszxrezPiFfGixbgIHQok0gDjWk05ofMmXoALgpnWqKfDfEl0FlKd4lblzXzdze0cDqauXQGWSK2KezyVK/znZEYXSx3QyiX6CF8AF7ylup+lM/vhsF80+CGoCEQm5vjEkzl0KLq+DjNYAldoFN5yyRtFNUUeeWh1s0YQ22Cs8s6TZ/YfrMUdnROTtQPGDxNFmLsap92ON+ZNnfTEwv32w3rYA+wew+0EI6X3fZFIn9S+0ARcWF/eDWxq25BtngEAZFR06pBMGNYVCWFOGqHnuV2F915+DxagY+OVGoRKO4op+edNmq0tdsGsTln++mrnfylIcFD6MbukdK32O0ufhnE2vjVB0kLRQbq3CQxUZdDn38mGjCSgTLZr9VaOM0uuCwt1Mh3i2tXNXv1VbksEWTrqMiJzSiiLNgLcl2d7z5XqBnh6Tv80qkiFl3MO2XJbFk3LGf/Mzw8a+ICSIsiIjRNisN3Xsagjuk+aOJM/TrpqCvkUpZP7I2Pt1wEh9NJADAT76Mm/D/+RTH9VUNxA2vM6kWbpPqVjwKUq3HiT3PoqmzX+5K2PCArWzOG+TqG9iXHdapnAyfDtRWhSa31EnyHUYmP2Uo8A/ni6C5NASFVK8WPdXyRZXcfu3cuP3Iw/fjhxT4TJ2Rw/+EqqR4IVOGqCJY8MLtSQDfX9PVjt+DRUgedlJH6PI5luMcL2o+2LAPYkWZTo05gVS6Idm50rtSKpiamlNesGZozzyhYlK8X9UCtTwATf9FZwWg+LfOStYiO8pcTmpoXVjkH2qree6RjyUSSA8pssmY38DSImOAoE50+JIfZgyZbWrlbco0YUObLjkwCwE8dnhDuRaq6fG1nzojCwKIngG/YCDe9PA5HSzcuI3nO5qsgJnUqI5jevvNx4zXNS02tnwOsQp99OmkjyzefCF
 TU0OgwF9
 uE1nyvvbiSM6xpWiqg7NVjOHwQrdqnt6mnC4q8CbzFuykLSMw6GDqovXf0rmkDB9m8VDlrw0Blitz91HLYwI3ywhjnjzRWVE49Thc8Fz/XrCmZVRRhpZ4cSi83TgG5lQduHp3tN9yhdRjNu3F93WFC0foLIrzAB+nU17dJCPJarhIlK67cQarJJXioQ514OIF6GxbyovhqVFWiXtyxU7Ks7BJ3tG8G+b0Y3EgmYgw0BvK1wIqJsSKfKXAS+hG1OwuH/t2CQQV7+chvLJHYzHpvHeHI3v8unAlA9hehnIq4aBMN5O9lSiKFGnLb3jwLY0PoV6v7DsQNgxkjOl1/e/rBdLIKNgSUEXtl6tiDrSnIYpTVzJq5UxarH8odwMVpSIO8eRN5XHN7+Lq4v5fZUO8iMGZ4ksk1pebgE2FnYnETJ6lfCluwlMdr6/NOc9o2RY1lu0Zp93cgAA3s+AaLv6QINCimQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Mar 20, 2026 at 8:24 PM GMT, Roman Gushchin wrote:
> John Hubbard <jhubbard@nvidia.com> writes:
>
>> Hi Roman, Miguel,
>
> Hi John!
>
>> I was delighted with sashiko.dev after just a very quick peek at a
>> few of its linux-mm reviews. Up until now, the AI code reviewers
>> have often fixated on trivia, but this one goes right to real
>> issues that actually matter. Sweeeet!
>
> Thank you!
>
>> So what would it take to get similar results for Rust for Linux?
>> (A bunch of us are working on drivers/gpu/nova-core and=20
>> drivers/gpu/drm/nova, which are written in Rust.)
>>
>> I'm guessing a combination of "add rust-for-linux to the list
>> of mailing lists", and a whole bunch of new Rules/Skills?
>
> Yes, I'm going to add rust-for-linux (will appear ~tomorrow), but a
> bunch of patchsets which cc'ed lkml have already been reviewed, please,
> take a look.
>
> We don't need any rules/skills to get *some* reviews, but we certainly
> might need some prompts to get *better* reviews, both in terms of bug
> discovery and false positives. If you'll master something, I'm more than
> happy to give it a try.
>
> Thanks,
> Roman

Hi Roman,

First of all, great work. It has already produced useful review on my patch=
sets.

I've seen a few false positives on Sashiko which seems to be that it unders=
tands
the Rust code from an userspace Rust perspective and doesn't know some of o=
ur
unique constructs (most notably, the way we handling bindings/FFI).

I'm preparing some prompt changes locally and am testing these out, to see =
if it
reduces false positives. It appears to me that the prompt for Sashiko is fr=
om
https://github.com/masoncl/review-prompts? If I made a PR there it would
eventually land in Sashiko, too, right?

Best,
Gary

