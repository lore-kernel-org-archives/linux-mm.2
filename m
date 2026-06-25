Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB567CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9687A6B012B; Thu, 25 Jun 2026 07:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9411F6B012C; Thu, 25 Jun 2026 07:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F8C6B012D; Thu, 25 Jun 2026 07:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 560C56B012B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:56:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCB151A0615
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:56:11 +0000 (UTC)
X-FDA: 84918281742.07.DCD66DB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011026.outbound.protection.outlook.com [52.101.57.26])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFB6640004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:56:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=citrix.com header.s=selector1 header.b=S82Tjqbi;
	spf=pass (imf12.hostedemail.com: domain of andrew.cooper@citrix.com designates 52.101.57.26 as permitted sender) smtp.mailfrom=andrew.cooper@citrix.com;
	dmarc=pass (policy=reject) header.from=citrix.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782388569;
	b=NKPPdezsVGs6O36trHDWP0s0Um1sbAW+vzypwP+mzSF7dzPptEKvLYdy6A5e3A2FHnytX7
	ShzP5aIMePP6no/KPav8Ue64aY5AwaNUwkFzjFO1Y1+L0KOzruvbr2hR7MJPNSzhlKUAU9
	NVSruFhjKe11Op+zQ/6kQ75BcOMnyz4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZAEGAmpuTKi/CBOluA4qpppGfBRN+xz+BQ7Rf78v0M=;
	b=Ug+mhx5HZXgH0ls4GRkzOM02iAQOsMyhkJuQG18pL7EZGBwBEOpPW6X8RUGK4NXdklhteW
	dEAJDG/DqsQvlz1a0uV4s411sryjo2e2m4UgcEVk1RVbL5OxFfKCr2pe6iiCpI2nPqqMdo
	s74aaesPxiZ/7RVtTUS18IcXGc1hVe8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=citrix.com header.s=selector1 header.b=S82Tjqbi;
	spf=pass (imf12.hostedemail.com: domain of andrew.cooper@citrix.com designates 52.101.57.26 as permitted sender) smtp.mailfrom=andrew.cooper@citrix.com;
	dmarc=pass (policy=reject) header.from=citrix.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJ0BYdlaHl+cK8m8xo8yDWgCF5iU+IZhWyKo/WW1+cQTZGDNI/qTWdYirvV7llBFAq0V/qFrdaz06Qmde3Pci16nwwLtgzGzFOQBOQHahVvSZnD8SUXiWNGvvCzsF2kdRhLsk3ucDJKEJi1TePSqYipe2Q9X+Knz5SJyczS44QKc3Fu5MgktY5eBW899QgzynpR5wR69VTOMq3uop/cX+hH7gOE4yNOyjRJETXMdBgVUUBp0r1i/g8KmuGGrFbc8Nv1deMhov8ZpUbdw09xqT/2NLwWf1egfdbzjoslWZhfWOMv/cEn/CIZ0WiQ0nxbD8cShInlp6E1L+51NLjkNKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZAEGAmpuTKi/CBOluA4qpppGfBRN+xz+BQ7Rf78v0M=;
 b=mmMPkP2/36DJWWa/0g+na7PAQpE5a2jCPPvX1bxzqniwJ35J3zkaLyDxtN3tE3zJSB0wC85de2+FWcOEQqkHPzx/erZu53PsKbynpeFvW0Sm9fN9s3c0djK5cuwxU4Ey/BlPPNdfUQrzZpVtUEFiA+dEpTe/9n/Jl9DycT9ameMCOquHjbFx+YazqIMTYqpkjEjj/Vfi1V2a+ihJkcTK9j8tmqcE8LBcY7lcX3qSVLrB7Sg+IFA30G6sgRiS1t8CiHGUPYkhd7KceAIHB9iWBworrsoITovCgMasjHcZM+in7+ZeWbAmvhxq2kOiiFMp5XE1Qgiz/PXGJK6gkV6GnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZAEGAmpuTKi/CBOluA4qpppGfBRN+xz+BQ7Rf78v0M=;
 b=S82TjqbidfyJU1JlcDWyUfMf6OeVCWqas7e+llgqpXAlTPWmfXp48dH8s4QnnviOB+Xbn1shQRLfhwyru45G18ZFMY+hUu2+8CRe1pQ6Nt/22snHwL/RbY9yOdFrm0/4phG/pg4NUwAJ4MLyVI3AZiMagA0P4Yu/k5P+7VkdLUY=
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS4PR03MB8373.namprd03.prod.outlook.com (2603:10b6:8:32a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Thu, 25 Jun
 2026 11:56:06 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 11:56:06 +0000
Message-ID: <bfb0fea2-ce59-4c10-8597-58e495ad6d81@citrix.com>
Date: Thu, 25 Jun 2026 12:56:00 +0100
User-Agent: Mozilla Thunderbird
To: zokeefe@google.com
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com,
 kees@kernel.org, linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, luto@kernel.org, mhocko@suse.com,
 mingo@redhat.com, pasha.tatashin@soleen.com, peterz@infradead.org,
 qperret@google.com, rppt@kernel.org, stevensd@google.com, surenb@google.com,
 tglx@kernel.org, urezki@gmail.com, vbabka@kernel.org, willdeacon@google.com,
 x86@kernel.org, xin@zytor.com
References: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P302CA0016.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::6) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS4PR03MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a6cccf4-587d-4c1d-0ca8-08ded2b0bd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iX8WOHwo7/SmxkVG0TP8GrmAcvT86xwXGBmpXIEYGBCSXamjaM13guQUIS1fGEjUwiq3YdYx4VQUOsMmXyKg+KjNla1iO/+dGyjN4GXr8yZtHEXVDAnWDoerGMv8HkewVdvJm5X2N5B2FjdbYfxD7nOUVpvVoSFHxDZUwF+lnTjKq3uu9a/zII7O/A15G10uHyw3YkfI2Eh9g+KNMJgKFtzN6grrquVWFG/pHqLNiOEvZjbKrFPAGbZ5k6tETd/RY4MfVLnisRK05WyrrJsEeUu00sFZe5xUj/6e5wJicTjGA4SV39d47XJDgDVe82Wgco7r/tWaf7W3v0Fr41QeXkRdc5iMm/3uFVJzI4Nr2gUi0V2gEqkRjA1Ns4X16felDSLfn8eJtU+WLqV87R32U4FGL3SqI+4SBe8PNsxlwqrm4RGdOB4QtLN83XRWLnf75Jo+oxq7gTRpxnH72I0nvAMiIKI8N0qddBz3IILIpKgUZr0PgnLPMT6l4ow3N9bIb3WUxGr7Vt0AjHJGg6cqLk31PsngK2IpXN5dpHSuBISDKs5Eq4b4hQETQ4nVDCmsT29a+poECouJYAYUIXYZTdbPvf9GWsrlCiMZjxPf2Giv99bbWDyxo2WixId3Wdpz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzliYTNURXpoNG9TS3JmTVN1ZzFQdGZ3S1YzSngxdGU2RHc1K2RUOXpVaHpn?=
 =?utf-8?B?U1Z1Y0lsSThTc1ZlZTBhU21ETmtVbmZLdU1Ieml6M3VEbjAwcllRMVo3N3lu?=
 =?utf-8?B?TlFxaDRiZm1DVURxNUxCTFRwd0xNbWhLUms0R0xrcVliTjJlRHh5VVRkS0lS?=
 =?utf-8?B?MVZpb2VONTVka05BY1R2eXhXbDVtdEE2bHlZRjBDRmgyenRWZEdXdkZZK1lO?=
 =?utf-8?B?M01mYTJKdU8wQjlGZUIwSEsvVW90UkwrVUJlQ21xTU9SMlpYeHNoQmpvdCtw?=
 =?utf-8?B?Z2FEcnh2T2pmL2ZNd2V4bEMxejZXYVVLdkZ4TDM0SUlqai9RcUtDM3BWL3Bw?=
 =?utf-8?B?aitoQ0JuVlNGNE1lc0ZLa1JHUkFwelBLQ3U5KzBJcXB0Q21lUzRTOVJrdlhY?=
 =?utf-8?B?N1dTTnNJaCs0bGdseTFVclBpRTBZRGpYY2pmTmQxa2pwaVBqL1JUVDlmMmdy?=
 =?utf-8?B?VU1kSjdMdDFPamdFOFZiem9uOXhTNXVxeXJSNno5c0c1alJ2MjJsdnVBeHpE?=
 =?utf-8?B?SEZPRW03UGsxQUN1c1kycXNMV2lreXc3UmZtZ2VtV0sxQWgxYlJJSnBYQzli?=
 =?utf-8?B?K1RzY2dIdmNXcDNEellSbm1TbkFMMDFiblZXdWVOQnpVSGZiUlltYWdKZXlT?=
 =?utf-8?B?RE01eUVEWmdiMTdOMHBkRmozVmcwNVpZenZRcmdmeGUxeFBjd2NmSkJKTmJO?=
 =?utf-8?B?OW1rcDZxVHBoa00xamVjYTNZT01kT0tXRmpMUmhybGtVVVBYWWNqemZEZUlF?=
 =?utf-8?B?b3o1RHpTZEZQOXB0ZVUrKytabE90cWo5K2Q3bUFVKzY0ck8rdlN4TU1LdGxP?=
 =?utf-8?B?QUplZkdET1d4VmNCaTJCc2ViTkEzejdyNjYzbHBHRHcvQnpqZkJFVTl0NWVN?=
 =?utf-8?B?WFVKSzBhYUZ0T1VQMS84cGZVcmpVc0pXRWFSRTVNeTRPWUllemcwZWRoaFh4?=
 =?utf-8?B?VGtLZmJSVkVFR1JYUWpSZG9heS90c0J5R3V1VitOUEt0amdwNjBsbzlYRktu?=
 =?utf-8?B?SlBySlVtRWlwdDI0S0V5dTdjVTM2TmF4TUpMdm1TNUltU1NCcUM2ejVuMlFN?=
 =?utf-8?B?SnA0MTlwWWdaT0wwOXM3ZGIxVHlqNDFaa3BqUWJ0WWJvU1ZZQWJiWjFvYW5q?=
 =?utf-8?B?WStWNlZNNnZBY3pQU3ZlOGc0ek5nK0NFeDZvdWtYV1czM0dLaTJSdmdZazdW?=
 =?utf-8?B?R3JSbzFScXMwV2owQ0h3elRRNUYzK0VkRnZ6RmpDTFhCN01SQS95Yy9PTXR0?=
 =?utf-8?B?N0lsUkpRdnRCSzc2QXdTNEZyenpYQ0dqSVdKcWhlR1U2WUpsbkdQWnFkVkZ0?=
 =?utf-8?B?MzFUWnFNU2dnVkdadEN3RktCQi9RQzZNUSt1T09aZndmV0xZZzRCRVZKcldB?=
 =?utf-8?B?ZU5YV1RxNXNnZWhFdElvY1l3Vk5pd2J4LzU0Zk9ReStmR0VaK2tmMzIwOGUr?=
 =?utf-8?B?bFFtNWlmTkxjUXUxYVhJTWhWejY4Y3lGM2NyQXFDOUhyTUNVSEZnbGRFUnl0?=
 =?utf-8?B?VmJZYjQxSUFCQzZjN2FISU4zY2pGc2Zibk1KS3FuTExzL1I4bEtXbzVmazJM?=
 =?utf-8?B?YjI2NXBPOWFmWnExMmNPenBxbmZhejI3TUtJMmRJU3ZwUm51ekpZY2xiNzJI?=
 =?utf-8?B?NS9rcTU5T2x0RWpvNXZoUjJKbkJrY1p5N1N2SUFCV1laSDNhWjk0aFN1Q2ht?=
 =?utf-8?B?WVl0bHRrNUJSRXd2U0I3eVRHMUpVSUNkNXhrL01JQnhxODhrcC9PenFlMDAz?=
 =?utf-8?B?MVhzMTZlQTcxTllLa3ZhblpkTnZsclluMTR1VVc5Q0tlVnpnb0Z6d2taMkVt?=
 =?utf-8?B?dzIzYlErb1hRa0dCY29YV3pZOHZocDBSRTlONXNBWTRTZlk1elk3RjR0SzI0?=
 =?utf-8?B?SGVxTytqV3FqZnh2OW9ETWlIbUowb1pnNDNIeWVQTDVtQ3M4SkJmeDJ4bjlY?=
 =?utf-8?B?bitCMDJpWW80dUh4YkxaRC9vQWVabDNEUEZoVVM0ODU1eGl3dlJIWWV3VlU1?=
 =?utf-8?B?d2xmMUh1b0ZobEFObUY0VEFKVktkVlJ5SzlYMklvNXpmbi8zaFBvcHBzUHRM?=
 =?utf-8?B?U2tPc2FyN1FOUEFRczVlNlNNK0lhK2V2ZXhETlpxd2J5ZjBEbnJVV0J4SDZs?=
 =?utf-8?B?Nm0waU5YR1MzcFZTWUlReUZPY1lWWEdFV2RCb09vdnJqZzQyVUR2MlpxblNP?=
 =?utf-8?B?WGJkblU3RUZZMmNpQ0JVM0pXMllEcWszeVdNbkIya2RtblMvYXlEUUhkWnJt?=
 =?utf-8?B?cjlMa0R6RklOdmFiV3czRGo3U09OSXN4ZkhUdWZJS0o2S3ZXazAza0ZOTDhB?=
 =?utf-8?B?NUpwZ2xWbGQ2UGFjb3RvQ1ZlRUpHbUc3eXZsRDIxR2ZVMnI2VlBNdz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6cccf4-587d-4c1d-0ca8-08ded2b0bd03
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 11:56:06.1193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8cYyUOP1+cxSbUUv6G8hjhH8IU8qY+TYtLBS6SuNcn99p/+c/XmK5mqX0xK4ybK2a5gJO3XfKFY+Ez5Tb88EzFXqDvGZyS/BLt3eXFF7V4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR03MB8373
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFB6640004
X-Stat-Signature: nreuh5wq34enre7rn45c1ehyi7t4nmqd
X-HE-Tag: 1782388568-923604
X-HE-Meta: U2FsdGVkX1+KyHKdc1OxqzaxYABNuy0ojIlIHAq671aKTHrJg/Hf5wKUzpkf0XE9yU2gl3HW+eduh46TtmmQqnC7T4JBW8Z8lmChxfn2T6onPc02t+99nAfyctW5NWpqinmoNotAkBSWx3NN+dVtVqLyPg99EUN4P9yvII15XfgDnge9hTrCU4i7xvHB6gGe/cnAFTyRyektI/QGwrYKc3my3CDXHPJCRsvnz/PtXrNDepn07lQoIZqe3PsmLhipB3G9kcCyvTlax64Ye3qWxNZc69Mr/wp1qdssUyqCTIaFVhmQXP8UDrZDMXW2nmgIQxvCN1xbUO0ZlH99ZkahtU6/NqRlKvgJ2bZYA3EJkNp3Zx+t+wpB8c1A74o3t9zHXkr9qOegZsaN/wA9G+B6vibSsjU0MGmRG4L4kfoG/47+NWrr9fiNJDqYx1qoJzgTpUsC94usa2VYAfgM/QMnjTWyzEjp78MiyrQcr5wArQTm/z8tScg+TkFLvQRYy+mQ+YxPUAe1oZLV2+JhTWZqgw8itMJze3Y5YtSDLnebtiV3CSJN9NO+UXjBJWWEyNyfHUPESiuzGUJNOFA1omlRY4M6khKcSw8jK+uHiXB9JWM5y7wLDOLjUNNkX3HTBQt4pvRX3fmOBfxUDxH2eJhDrorFd3g46SIB0LGb43Xl9aBzFgBPWOFPuKWYyiuxrgxfbQuf+YurArR+q4RNaWkYuhqGYs7wM0NBC1XLDjsryEaxsIy/bJQDZiZPAAC8PJZ9qAOEyHZcACZrQOBGwtbVLzOtx7ayZpzLvptUC/DNcfobEDH3whF7FxVw1sP3oG/LJj8kqIYlcKLn3XpY3w/mMfs+OlGFUwBhR3rgbTDvvBvh761jJkWDaGjqRiu5+KpAKbqgPm4qLdfdLkEQFdjh9C2LA+ZkQs5e6+aAcQMcoOaeqw3gmku/sly3W7IWbQPvHfS68RdYjRlEHPmVjKt
 9IYESbHK
 SzOmcj8LwSzhHTv8qnlzdt4pWqDfs0O70RYsucTdM3IbapgG3VV9X17OGayLdWGnS91GjmgkEaN6x++lyXQLNIr6Xa1XLaQUl6P1YgkHuT1utvrAVJgTiJhUiFths7XxNqSXXoq1aVUMl2LxcrxO6MTDQIr0Ry+gQRTGpcP5CH1HulQ5gaT/qS6JDy2g627IGcy6oOSInQce4z6YaL4EO10lzR/+6GXsj1/KAy663oP4dV0Jy7bUsZ0IWKrACVVrRBdIK1SUciG3MzuZ193Et7abbp1R/ywiIEyn5bwdF8s9flTRolWNi9HM7QvM5mwBUxyqBa53snsyQkzKfxg+f3rowHms5FQZY2q8x5xwKRyCEsIiKIrWejX7h5vNwpmFO3mL+0q18U16WSujnZjhmMRT3fkXwo0a+WiMzS8mDFCMx50897uQXRGUsepGg64lnJlgJdPXmGqbfeIfiYudnoT3ubCfuSmAnQ4YL26cdr8KRzjpER8drxkTZCzwHG42DZTC49RNDLCKp+2QJWi0J42okndN1ziDUTMIjz+0MvWDFFuY4COLJEUiGJLZHqEEoV+YaAD3yDasfQXYeGzVqfCSD2b5Qp0Vw4VC5TkXpcNd1ZJCprxGmThqIkNz/rU9INrhu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> However, I'd still like to work with you to understand what feasible
> path forward you see, hoping you can proactively steer us away from
> some of the bigger headaches.
>
> I think we are fine being forward-looking, and only supporting this
> for FRED (which is on our doorstep). That said, understanding the
> issues you foresee with the IST approach

For IST, read
https://docs.google.com/document/d/1hWejnyDkjRRAW-JEsRjA5c9CKLOPc6VKJQsuvODlQEI/edit?usp=sharing

This was written prior to the first public drafts of FRED and SEE specs,
and FRED evolved quite a lot from the first draft to where we are today.

>  would still be valuable, as
> it might save us internal trouble should we choose to carry it
> temporarily to bridge the gap with FRED.

A lot has been said about the invasiveness and tradeoffs.  I don't wish
to dwell on or rehash that.

There is one critical point which has not been made as far as I can tell:

In x86, if delivering an interrupt (NMI or INTR) causes an exception
(any exception, not just pagefault), the original interrupt is lost.

If you are aware of this, then in principle you can look at the LAPIC
state to figure out when an INTR was missed.  However there is no
ability at all to figure out when an NMI was missed.  Worse, it is both
vendor and IDT-vs-FRED specific as to whether NMIs are blocked following
a missed NMI, and that too is state you cannot recover.

If you wish to make dynamic stacks works, then you *must* find a
non-fault based approach on x86.

~Andrew

