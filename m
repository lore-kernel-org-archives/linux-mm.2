Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B3AC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF8E6B0088; Thu, 27 Aug 2026 11:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7876C6B008A; Thu, 27 Aug 2026 11:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F276B008C; Thu, 27 Aug 2026 11:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 342D16B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:39:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B21E5A0464
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:39:00 +0000 (UTC)
X-FDA: 85147457640.20.6BD5D26
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012034.outbound.protection.outlook.com [52.101.53.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id E810E8000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:38:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L6p32YtR;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787845138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFatwpLJ3wuT3UO7t4Mt4XxYFCr/8qeij9gI8Q78dBE=;
	b=g5I1WpyIa9dNFptznivtJhNrlvwOQE1j1+erd+co8qv1EvOs87vvT7H5GVdNbvuLF/BvNl
	5q7pCd6ZgClQddgQTfDVHMcawEt7L76ZKRybCrnj7qoLulgt4TwAhNwIIXSAb6m+s+Nfy2
	cYjscpk9HlZzuqqD8RwAdwxuBLVZ/ok=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787845138;
	b=fW3aUiVqAAC353DpvVAJxRvN7GYEjCYKN2u2eoWGptEvoyJAgbQrWEmXdrd5cHI7OpyY7D
	YTFiB5pL721tlCVmnYn+QQOPSm3ezQwD3qoFOe4ewYWtUJ0gVTDEIy3JQk+5i9nxf0vyYD
	WVzA6+xteOiiFIvBxRzNqsuqKEGGj5I=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L6p32YtR;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vadX95kZVOrIL48SSlzPd34XDgoWuevmOM0kTRYujRsncervx9tnnlBjCnybsjcYtt48vuyZ7VDN2IvTAkDrDwKVbU4VR7gcrV/P40PpOFrmUZUqGrmHM6PStV/9msVe+vEo/D3Q46AP6GjoRaRwbhNMmWBY3TAfeCDWbDXUqNGnTIBls1BJ0kzrn5SMBB7ktb+MhgVrZZJ6Rv0vzyi6Mir5IeE/w8svl2QFKRTIqvzN8VyLHsfS6DMsfsyDuQMLSARHHdD2VfUI5TkeF7Us/jFBfyepZsbqIUdBRlPhcP/baldx9i+3+HKTG+m1QSncy1aLsTdZN8ceQ3Gc59nM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFatwpLJ3wuT3UO7t4Mt4XxYFCr/8qeij9gI8Q78dBE=;
 b=JzaHumqJOzm8fQPaEDsZ5p9ExKexNMpo9oE9SC4fv5VsdE9+PugFPgXSQVhauylnIm+vBe3v3dIybjQaGZhLQt1NvyD6iOIP8AziK/k4m4ORMk/hZd/PIK0y3wyDgPcqKpwJTo4GRntM8o8yO/RzjyAYQHc0bhum/ITPkLaYSflnD+AYWwd1Ol2aLFVyqlS3i65kR/I3EFmSMpZmo83/stz5/8sUM26Paa75VM9f/O4EqOgHYEEW335iTsAruYDTOJAUumTc+yo3qDbVliBZEMZPM1lP0C9ffgMY19Hpo+OGC63Xj3a7dOZPK35JTKM0JFcXnktJiFPgjxZ0nKfTIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFatwpLJ3wuT3UO7t4Mt4XxYFCr/8qeij9gI8Q78dBE=;
 b=L6p32YtRTzpKUfOqL/omHsMClt/3LmmO7xwR+DP39fNwY0xnXSDyWxZp7adYP3RlDlzkLwpVRlL9xLbPV66bpG7a/jPUblD5BnHmOpf54GbSbbJPC9MfIMd1CpLogiCtUgq8SGixASdqnsxbg2cjj6b/nbMeuH973Xhk0HqvsR0/4mB6pdnoANeiYzfEUoEuDJK7H1TatRtw/4Wm+1AdnADcGXkQJhwQWxjGynkNGRAd9FuswZYBnSL5xzWkUNXmZF6uMcmN907KM6iVAYa7DenVGraz6RD9YUPutn9dbZcOQVzIcx8qU43MmugaBMOu266T1eD9RHGGRIABnWk17w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS5PPF23E22D637.namprd12.prod.outlook.com (2603:10b6:f:fc00::647) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 15:38:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 15:38:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org, usama.arif@linux.dev,
 lance.yang@linux.dev, hughd@google.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, liam@infradead.org, nico.pache@linux.dev,
 dev.jain@arm.com, ryan.roberts@arm.com, balbirs@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
Date: Thu, 27 Aug 2026 11:38:45 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <50FDE99F-3E71-47B8-BD88-05AD771C4BDF@nvidia.com>
In-Reply-To: <c3f16d64-ffe3-46aa-9596-b233f9294fcb@kernel.org>
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-2-kirill@shutemov.name>
 <c3f16d64-ffe3-46aa-9596-b233f9294fcb@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:408:e6::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS5PPF23E22D637:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e626c73-189d-44a0-2df8-08df0451490e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|56012099006|5023799004|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5oIaqptr7bIyqJDVuBZlQFgeTTyiHXXRts+uI+KJZ2rot0MrFkaayU4GnqUQtQV8zAnFNoTuvRi96eJNKZSGlKZ15baon/2foMfM2r0EtspwEbVzvWCZpLqXDZqsWotJXRZXU4rWXb+cb+HBmPGfpr+lnjGnSr5+Iyv5tye7VlKbFmyPxdyRGrHF/kYKKOIxoIWfug3xnGCAqyEqUyo98hPgsOXLJya4MVRbhyx7AQdeD1CnbWweeriiaQ2cDHhoCjIzcAdXKmMi9n6In2xRLZojQXda+5DWS+hIZHRfgztVed34Yq6O07LpCNmcRjYLNZjXOCG8tphHkldDlNaijT86ObReOdboVPCX8jONHV18BTyxg00FPdQIDGFDC6cwjCYLxSdYIDv6Vsi+7mnw1Duwb99Wbau55JxMHeHdJRZjipQvgZ95utjGqSrXsWoES2eHNt9Yl0hDadKmg8/z6o0hl0Yfq8lgUQTdhT142mG9bzZCYHNjmuTw7o6qkFxNbsgjnKxflLLaaRlKyQlsL7F3Y9plo4onq7i2AtiXJkGCABkCLgQeqNc9VuvGN8Kk4tScsanAfho8txF0mkq+Sfkfm1zqkZRAYJzVZ8HIb1n8ZxSWMe6LnmfPrxW3ME+0F+QTo99Nris5eSZ54NqDYkY9Kc0MJkfNhSJ6rLszRXI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PfY+hJGVmvkW9mBQaVl9jxs+6XG1EqxW7ZoTCLKnMc4V1dj8pUrcbKk/YixF?=
 =?us-ascii?Q?eGDBOUyhvAaU9BU7e+10P5cQZVK+2EFyOG1JM6bfX3furXfU5WjMmosBskxb?=
 =?us-ascii?Q?aCKyn1u4f8IDQOgLBkP9cw+iz4IZDArwJxPQGIrGsYvtfHhdVt9khRse8N0l?=
 =?us-ascii?Q?qAu/tl137vdLbCMFJGfZx0Sfsav2YD6ZGRjM2WI5UKTPNZInpoVF4lMb1V86?=
 =?us-ascii?Q?7BBKTj4SGKC5NPmgJpj/GbEnIvcMlcDoAP5uJ99+2yKlJuwHJk3S97V/TYLV?=
 =?us-ascii?Q?gOVI2ycv71eI4iWdB4SE5eNmYqskdfbmi52U6D6kTiraiMaFuS1HdR+2nMwo?=
 =?us-ascii?Q?3NnqWRCxye5LPtNfRDkSQxk5sEv3fW7LgWJvWXK+QSDmbcJahRIdQLMLnKWu?=
 =?us-ascii?Q?Q/gkYenF+0Y4B+CJr+pTh8idREHH2ZlAswas+25zS8GcpyMRo67b2hLzub0q?=
 =?us-ascii?Q?LBGG3EW+59+mbfeWUb7pSftApLDaLExuqRvBjVTkjPJxeYps01VMLA9jrf/d?=
 =?us-ascii?Q?MYD3nl0go66RFyvYX8FCByQFtcdafk2mZw6JsVm3hl30zBYW0MTH9xwfuCQj?=
 =?us-ascii?Q?nzneKV/MaPccG+ftgULuE48LBSs0LrokSzd2CPkMO6fbfhg2nJxVxZ3BkeA7?=
 =?us-ascii?Q?ZYuPlPRUjdJXO8TQVO/w65lmcHU+ifgYJRick1vmnCVTwEKLY3rhr4fEX/PV?=
 =?us-ascii?Q?XWfGY4mjn4uAqoYnvuFyd9S5YpNSoM4kzpdZU7EgyWUfRZozXZiD/TQlrPbl?=
 =?us-ascii?Q?j6lejPuStxiwbB4qdh4DCDikb3S9jyxHxHp54XgymPnkNTdk9tdHTnoo21cg?=
 =?us-ascii?Q?u3m37x2uolip8meuOLOkjWGC06MlLxlgGnW8C4T78ePDhPO11g1rjE91AFd2?=
 =?us-ascii?Q?bnf2BcQFuIvV79msHPz/leZlygzs5eKasm2bW8D7MwikFAAaRczT+yjDB3ZQ?=
 =?us-ascii?Q?IO+QCssJb3lx2dojnaRxdRupBAnkLGMKJLE+jGSP++q0aj3HIY8niiJ+sHig?=
 =?us-ascii?Q?4QofVRkWnFGx0tmvtyVf+DXMNbpu0EepehneG2QlB4NaAyRUUPulPe4iO8lX?=
 =?us-ascii?Q?VpySCFwpTMuL+ndBnm8UPl09Ekn0uAd3z1X2T2rOr8BQvrH0ewPAEhQlQ1jM?=
 =?us-ascii?Q?mth+3wjC9Urq9Dn/ZBzgZExmqm1OhD360rpax5XIYRVxTaQi/cXV/z2+IPZP?=
 =?us-ascii?Q?vSJGlfcQU0wQ8DjuGPWuN9uAhL1q3gKMcHGQn4UJP1kx4LRDad63lZg0U1jM?=
 =?us-ascii?Q?Q3+VO6C00QFAhVkLz39uixQTODZtzGHLLmjNwnCybyZXkmqb4sliLHXYiTSc?=
 =?us-ascii?Q?meD3b0GdLRWXfzmGYTBOQBSIRbYpwpUs/s4/LTww/IkShTSWIh/+YSmrd5HW?=
 =?us-ascii?Q?HanM4dv3YSnayZqTIifHwDV7LkToXV8O9rAsK+dcWL3McHpLtG5h3937rB67?=
 =?us-ascii?Q?nGIykltDJI/YyWHI5kLVAfHCj/hlWC+2rUukZE1tx6RVeORo1oagvnhdVdut?=
 =?us-ascii?Q?lwWKoWoyPp2TeJivr+u5UNUn44Ce+E9rFvKy34xWIIguSvShXiC+G2VQC3xN?=
 =?us-ascii?Q?yDuqhAr1gsuzdHzUtkg3XScPvDGQTk2qh3ZuPfW5yZXW1kA1H+XFrnU6680r?=
 =?us-ascii?Q?xnDFj5IuVbic14+AGvZOZ+KgF/kPOeiVCZEIkEm8mdZVxBhg7wIBZlRDkkQ4?=
 =?us-ascii?Q?GaYFKm+Pr8GkHe/dJ5w69HZ0XNJ3eb2ItYIHv0eiMrL84aV02uMF2SEjier1?=
 =?us-ascii?Q?gfsz9uHpOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e626c73-189d-44a0-2df8-08df0451490e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 15:38:47.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIEDQ8wtVGr+29P1ZpolY0r9A74RuLTuLP+YauvXgcY9draP219EXjvj06JJe5iT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF23E22D637
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E810E8000C
X-Stat-Signature: ea4wa68g6nqe9txwaiitn93ty3cxbdiw
X-HE-Tag: 1787845137-804996
X-HE-Meta: U2FsdGVkX1854vzHiPUie6l4UiH/ur4DoTZsCrKSmMEPVm6T5QPqsfEWlR39SpAIWhdGZwwJiyRWhQaeC+yCWRP3VyccLT3kVEJxbTimDc9Wy+lRO2j6N/mHO/cwQFjdvZrrQgmgAB9Q3GRCm+9r5aCHIvn8LWOQEkPTUHQsnknfOvc75kDp4ICyNEfFyhBr4baZx3+igGTURUmaVGnXHnZ74GWkl3Z92edSjwsEmanZN2pCMgKc6loTE9eyUL/Ckw0YIjlYe2XiCQVUQvaanq+VzEXMS+6e2K8xR57z8VLjJpjJwpT9iIv22tTjDVj65xR+mXiaB7gBA52LgPVPm6Q6N0v0Fhukt0UchQs7jEqA94Ln+YRClMFyjeCFrrGBHK8AqaLK1O3u6HxAECwmdMUB0NF71AJSuAtHvn9IRZchQivTKcviYSJpJtSWGHgcKLePHPQfrc18/23SJmYkbwpz9AJhzvR05VQ12TLIwRD6BqtZTGVkNm1K6IFuO75337TmzRR5AhW5EPUNRKvWpQtbR6hZwDdlrMwGGHs0lXg/GjBNJMPzx42FBCGpbNu2zrDBVerWoUNJCOnB6T1p+J3SBjkhjeSST7ioyCu2u5lqx3e9++5G2ar0KohLG187TeQI9NbKu14ZS8LBbFS6DUPZnqt6DT0wrOmjC8GwxxrLm0VxXUOpvxZEhOrru+9A/oF0VoTb7v5yGLoV0aYninL4EM7IuJo+8LmCtEjCuYBt133CMfN9oaw3MmDLtunETxUaFmfZinImQSTDS7I6DIGyFThtfN/mNeUtGBMu5eWkGB4/fVDW2Od0/CLBhRtQ/xkZ8RkioOaXov7HY/KteuYvwpsK3yMFlfDKyhZrIodiWRKpKOVaZTJpWqe2/BWV4SXGdhGNtcSEsr5tfWaW6LiabVBE2XrV3aGZxskgE4J/hk6dEX+lPb+UIp4CQ+DZVaqsnq5TBJuwkJeMSni
 q24lFFdv
 ym5aXK0Q5jHk9Z2XRyH/omCBca3tppdwJrqOQ1HEAUX0zjCVib25ensPjdfe0Tgpe4kPcDpgjQzTDyEqXsXap/C9JpF/fmoQsTHrDTB0C0iJsWXlYOnoIESpAzgpjXuy+GXRZNO9dZFTTvQcQ2YqD5v2/+GY6EFNawxvT/x+gMSK2tSRcmvODbs0AXXbK9nR/NfD5MawvibGaLuIOuJiiY74Ypk2KTHp4ShpqOyigeGj16AFCpYomIfIVYDuuCTnkMaOMuwyZzw26p0nYsboKpD+lPMfjjbuKtQvE+Fak+pEoE3PVUFB1RfAMTyD5/1z4pn0M7B66MlVRF6Y40RAapBBYqA/w1O+CXbAV6IxoBq9lNHaSsFexZWoNsj/ySom7LrrbNUFPDwkK9u2imCdjAeoXHB4zDMdIRu7iVzF7LR9S9GQ1KIG27N/0vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Aug 2026, at 11:23, David Hildenbrand (Arm) wrote:

> On 8/26/26 18:20, Kiryl Shutsemau wrote:
>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>
>> deferred_split_isolate() probes each queued folio with folio_try_get()=
=2E
>> folio_try_get() failure is treated as a lost race with folio_put(): cl=
ear
>> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
>> the folio off the queue.
>>
>> The folio_put() race is the most common case for !folio_try_get(), but=

>> it is not the only option. Another scenario is folio_ref_freeze().
>>
>> A zero refcount in such cases does not mean the folio is going away.  =
It
>> means "don't touch me" and current deferred_split_isolate() doesn't
>> respect it. It can lead to unqueueing folios from the deferred list fo=
r
>> no reason:
>
> Yes.
>
>>
>>     CPU 0                            CPU 1
>>     ---------------------------      ------------------------------
>>     freeze a mapped folio            deferred_split_scan()
>>       folio_ref_freeze()               folio_try_get() fails
>>                                        folio_clear_partially_mapped()
>>                                        NR_ANON_PARTIALLY_MAPPED--
>>                                        folio off the queue
>>     give up, put it back
>>       folio_ref_unfreeze()
>>
>> The folio is still partially mapped, but it is no longer a split candi=
date.
>> Nothing queues it again until part of it is unmapped once more.
>>
>> Skip the folio instead: whoever freezes the folio, owns it and owner i=
s
>> responsible for its fate. It also covers the folio_put() case:
>> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
>>
>> Reported-by: Lance Yang <lance.yang@linux.dev>
>> Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@li=
nux.dev/
>
> Fixes?
>
>> Assisted-by: Claude-Code:claude-opus-5
>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> ---
>>  mm/huge_memory.c | 19 ++++---------------
>>  1 file changed, 4 insertions(+), 15 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ced400f72d43..6281ed993243 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4590,22 +4590,11 @@ static enum lru_status deferred_split_isolate(=
struct list_head *item,
>>  	struct folio *folio =3D container_of(item, struct folio, _deferred_l=
ist);
>>  	struct list_head *freeable =3D cb_arg;
>>
>> -	if (folio_try_get(folio)) {
>> -		list_lru_isolate_move(lru, item, freeable);
>> -		return LRU_REMOVED;
>> -	}
>> +	/* Lost race to folio_put() or the folio is under folio_ref_freeze()=
 */
>> +	if (!folio_try_get(folio))
>> +		return LRU_SKIP;
>>
>> -	/*
>> -	 * We lost race with folio_put(). Read folio state before the
>> -	 * isolate: folio_unqueue_deferred_split() checks list_empty()
>> -	 * locklessly, so once removed the folio can be freed any time.
>> -	 */
>> -	if (folio_test_partially_mapped(folio)) {
>> -		folio_clear_partially_mapped(folio);
>> -		mod_mthp_stat(folio_order(folio),
>> -			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> -	}
>> -	list_lru_isolate(lru, item);
>> +	list_lru_isolate_move(lru, item, freeable);
>>  	return LRU_REMOVED;
>>  }
>>
>
> Who will clean up the stats that we used to clean up? That should be me=
ntioned
> in the commit log, otherwise it looks like some piece of the puzzle is =
missing.

It is kinda implied in the last paragraph in the commit log (copied below=
),
but I agree that stating it explicitly is better.

|> Skip the folio instead: whoever freezes the folio, owns it and owner i=
s
|> responsible for its fate. It also covers the folio_put() case:
|> __folio_put() unqueues the folio via folio_unqueue_deferred_split().



Best Regards,
Yan, Zi

