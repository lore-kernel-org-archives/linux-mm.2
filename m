Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F11C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C13E6B00E8; Fri,  3 Jul 2026 09:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A716B00EA; Fri,  3 Jul 2026 09:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DAE6B00EC; Fri,  3 Jul 2026 09:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBC76B00E8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:48:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D56912015D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:10 +0000 (UTC)
X-FDA: 84947594340.12.637FF5E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id B074C10000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FGgJeD9O;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783086487;
	b=F1YQJ9t9OD3ZzndrvYUKHyasuiV/b8oEXCmfdhMM3vn3IDbExda70M377EBiybraKRDOP3
	kxYmvTgGMyzWt57MeVL+y3hEPHBfmgIq/tqXaJf4E+LDk8gZR7Yw96E25KXDnhUPGiDy4s
	OIcRtcMdlKpuAkcdhKxYgpwXvozLhF4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8dTM8gVGY7jgGBZSUBcNClAi/8xjZuLbO2kWr3d704=;
	b=ojvQkiQhsBzDZMoe6mb4sVXK7D8YCLZ7HBiF7yJdap/O2Ya4vJQsyv19GFUho5xMxoaSXf
	O/LQQX7gPcmfyvGFgzouBxy91yeG8OLUpk/QaAw9BUBSaCeuoe76PCHeLSIevomqMSADbA
	rk5kfK63L1Ffbvt1v7EauTvk9lFiRc4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FGgJeD9O;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nkUBj28lrL09zM2I8XFnpCohKYLOvP3eMFRi/u5HmUMWOjlu4TOyFRD9MFwDODDcVJmASfNh/5WUawPkQ8GpM1Z9TsI8tX18d2T7Km7qRZrHGHp+XePcyYf1b/7f+ZUqrBwiUyruUpkvxH4bRFT3+F6WL8SH0yG9q4KbOGzotCOdeFlGPb878NIfoA5PfZhJmVp0Cz8qKaGVHaMwALth/I6VqzzKIYNXE+jKnMsHQm9CUNyGhU2rSDx9gRpoQsGUROQQbqNG0IFrBRQr+MnnyvXAdnODp4M8gMjL/NjD9Oegmg1Vg18/HP+dyKUU8Lo2LYhV5qED3+yp/htNsZ5CYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8dTM8gVGY7jgGBZSUBcNClAi/8xjZuLbO2kWr3d704=;
 b=kWUAe+t1klhzN9JsROccFGfZsAyvwzEp/qedV/DBOCZyReyWvLyLA26nP267ISEnK3NXHS0fU5/7FocyV8Q4V4e1B2d+M6q9g7RXVYDztP3TCHqRlaNYlh4fO/HA0vyMOP6dt6uT+/FMiTj3c2aYJclth5x22kV/Q0v8/DU4fGzaE1XskeOe3Wlpd4L5IL7eiA8B96Cqhqik+rNjA9jA55KDWwaOGxmTTPLn2GLA99r3BXkhuthEyvEZXzJQzRPhmXen8r6MGB6o2Hn/7i2WGDY1aei4NPLlW9HcZPILx1BjvE05DcAjPnzQU7bPCrKbHurZw7qMCNB/cuMLVCAv+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8dTM8gVGY7jgGBZSUBcNClAi/8xjZuLbO2kWr3d704=;
 b=FGgJeD9OfmEv//h6FVJ5O7AkmsSJNnI5+cmSqahcJsmKZ5RxNzT9AK+9yxvP9DPWaUYgOw2q6m6QrdrZFR9WqfhHlkNAGzSncqt2U6tGD76W24+f+PAaF/6DcT/ao2t63cSCce/55IMMGSfa7KbZULdrkoJx3PzKHKg7L5Csjg6JGjkxbkXyAFytylq/nPZug9b8xW+sJkxth/x5MHDamZpY7SGW9xennymox91tvmP3SOk7vwoXbNuAwDoaO30my9hXc9H3hkyqTnwYY8ROyeld/fzKOgrjvyAGfNkAWIakyKM0wwUf3kIg0sNL0XdJM9XyqOlZLcI+StprCFHA3w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 13:47:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 13:47:56 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 03 Jul 2026 09:47:50 -0400
Subject: [PATCH v2 5/5] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260703-keep-subpage-private-zero-at-free-v2-5-2970fe777dd6@nvidia.com>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS7PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c473c10-e439-4288-4d6d-08ded909afb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|921020|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	cp+o9Yuht9wHaBBR5FyJpE1NgmqdGBBIZ4T5aE6FH0oJ71m/5dLwkf2824d+yzBCzXCyH9/dZtGYnnheGzPpBP3I/1n4azyinVcRVJ5aIzppJRazy9O8E4UKxjNSq4sK8wzeFI8SWQg2MnimhYQSYaNpr7mopFs82rFG+dGcdPQKLaGfDNQk/YLdXE1coynpQWlARnAlMdbF4/x1Z6t72KzUkDuJCzVzbGzmoFXJLXidPDORd2m225OFmoCLH75USKThkeFPHEgq7sz+ORMV9yOKVFDpr2yiPQHbEel1zXK7M1G26Xk+AGAN/QZssklVId+bBUFPn+RC1v/tnADzE/s4uV94kjbdxtLwc3bP7p7efZVqCyihOOvdKQBuyfKTjyH5/kCksUiCihWj+Jia0HrgbYO1N5ax58oKJUSfN3Iy3b35/RUl4/dOdlembIDR4ns/HPpf2YOs4vd94/ho0+Lek37JifLWjaU4Mvx2P4GbI4Ifdc02UKVaPGtw8tEy8IGveHdcZPt/eFgNYQ2DOnuz3miW+/L6S+SAanNwuZanVQ0gF3gawujPgM7rXWUyl754xbjVbRLk9jY4yNugZTpvxkEgsVcD7reTgBDeCIoakwWrGuGIzyR8sk5W7T37jXwCUevDZRwo73MyPkD597Wo8SnpFZ32trRb7UnAVa2lfWPF/7Z3OKKiF24VE/TEfyAj00qvtvkvaFEl/MfeRQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFVOeGZHc01ZOFppNjFia2UxcEtueWhRMTJaNFJmSFlhZTZvZ0xLcWFlM2dT?=
 =?utf-8?B?SDBPaGRGU2dJR3BBUzVvdmVtdmt1L2pzSE5KTjBFNzJRRlpmd21MMG93VlB1?=
 =?utf-8?B?aXhVOEZCUTZEM1F0N25uRWxUcmI2SGtzek9Ib1dvOTFlYmM5cEZuUHZvbStY?=
 =?utf-8?B?Wlc5Mk1kL0NvY280KzlNdGdZeGJXT1ltOUtJOUxJWHRWMENidmcwZHd5a1NO?=
 =?utf-8?B?Kzh2U2lZUUhUeDRCODB1SG9rZzU5amlzam5ZdXl4c2s5Y0Z6QWpwZE15Wjh5?=
 =?utf-8?B?QWQya1FxeTRKMnYwOW1jWGNiRWlMb0pQaTEzMWxSSjZnRmQ1dFVuamIyZ2Za?=
 =?utf-8?B?V0JOUGloblZoTTVValFpbUxLQmxBUkFLRm5VbEJ2aWx4ck4yeTFHamVSNUEw?=
 =?utf-8?B?ZE1CaDZuMlhzRlhqUHhrMmR3NE5hMU1INUFseVpoTkpzQlM5VWo2V0UwR3NL?=
 =?utf-8?B?aU81bjQvRE0xbEpvZUkxWS9SNTJIVE5xMlhEQ2xqTUxTZnZhWWhPRjA1TDJw?=
 =?utf-8?B?dlIvWkVtU2U5cmdUeHRjTmlYWFFtcHh1Y0tJYUtQOUpPMWR4andPcCt5S1FF?=
 =?utf-8?B?cXVFdXNCQmtSczY0VDBaY2tudUFqUWhWR3RMMzEyL0NrMFhPcnVRR2dEUHdW?=
 =?utf-8?B?S0RiUlRGa2hSYmd0WkRzdHFoZmhpcHVQWWtVc3NkRmtlZDRsUDNuVUswMVJW?=
 =?utf-8?B?OE0xT2pyMzdmY0luN05Ib2RsT1pqMVVtRExHQWZSN0ZIdWR4S3loYjljQWZJ?=
 =?utf-8?B?emIxa3dTM2pFL3RTaGR1Y1JZTHBkOTg1MUMvZ2lGN1diYU9jVnRNdVVRQzli?=
 =?utf-8?B?RGFxeVMyK2hKdG1ySnN2OC9lVHBycGZvM3dCeWFWbm9QSE9rN2JtQklTa0hK?=
 =?utf-8?B?WW0ydThPdHFWZmVIZGFWMzVEWjlzVzlBeGk2UTNySWcwMjd4RFFBbW5wekc3?=
 =?utf-8?B?Wk81V200MUlia2xWWUF2NVZNWWgxS1VpZXJNdWRabVhWWEJCdkw5Qy8yQjht?=
 =?utf-8?B?enhETXJpbTdSdklrelN2N3d5bXVhZzIzZ1JtMGxzbnJ6MUhaMGpkVFRuMi9S?=
 =?utf-8?B?a3BJRGU0WTBRRHNDSm1lalYzVFh4N3p5TjJBbWlkcHpjN2ZqOHFWN2hMaU9r?=
 =?utf-8?B?MUEzZDZTUDY5VHZSQmMyT3hXYUJvZ2F0K3gzMDZUTU9GaC9ZeUxGVytYSEI4?=
 =?utf-8?B?clRZSDVqT0E3ckxFZGpYeW1MOW9Ud0g0NkRYdXYwcnRWUXgyUmNPTTVwYVRN?=
 =?utf-8?B?b3RVMjlvRXpsbWNyQWhVaE5hVlVWZlBiQVdpRjFFWGF1U2lSVjFvSHFOWGtB?=
 =?utf-8?B?M3kwSTlPOWFOdHgvMEJnbGJ6RVVJSEc1T1NQMDNiRkNjZ3dhUXVxUDdNZ0Zq?=
 =?utf-8?B?TGpBaUZocDNLTXcrTEhUdjR1czFIUkdtbXRHNGx0ZHVvVW1pREdkNXlrV2Fn?=
 =?utf-8?B?SkFMVkQwa3YvRUJlanFCb010d1orQytZbGVPRUp4TjBuRTFQZjlNNFdHNzBt?=
 =?utf-8?B?ck54NEo3K0Zra0FGKzAwekpNbEpuMzBwYUZob3FTMW1MU3dCVTRvaEhQTTlm?=
 =?utf-8?B?M2phZGdsTkVkUHcvNVZ2Yko1Q1o2Z085NWZJcGdralQ1VDdBQnVxcXpPbWZ0?=
 =?utf-8?B?Y25ML1RsbHRMSFR6THhjckVXclhtOWxWelUreVdHZ21IbWhDU1FKeElqbG1L?=
 =?utf-8?B?MjJXKzcxUjJIeEFGSjB1aHVmZHFIYTFxMnhwSGpwcWhDVUt1SUxuTG9XZ2x0?=
 =?utf-8?B?c2dxbFM0TkI2S1BFQlVQcTdxSHFEQnpQM0FVYzZWR1JWYkxYS2QvOFNLTFJK?=
 =?utf-8?B?elB6Q2xxTVd0YWZDdmMwNnNHMHVoTkgxSzZHb2dJNnpuTkRXTFh3ZjhOVkt2?=
 =?utf-8?B?dENvS3VWc2FrTjMyS1BEOXNhTTFxRkdaaU50emZCSFQxSlo4WFhKSHBpb09v?=
 =?utf-8?B?SVVOT04zTzY5VG91Rjhxd1UrNWxVSUFjMjMyNVZCcWxWV24zdWF3ekowMWw4?=
 =?utf-8?B?V0ZOVFlMYkdhVE83VUdROTYwenRWbjlOeXhtZFFkMm45UDZOTmJVL3NldDNR?=
 =?utf-8?B?Y1Q2emdiWVQrTmltZ3ZiOXFJNkJkeXoyQlFFamt0bkM5d1ppNkF3Y0xTdDRk?=
 =?utf-8?B?T1BrcjhXUXoyQVNsN3ZKTmZGR1lYWmpVSnVHa1d4Q1pYRDRTUlBQSW00cTdY?=
 =?utf-8?B?dVJibW9NMkxRVS8zYkZKUnlTZjFpQVFBRXFXQUlDMS9mWjMyRE9zbURDckds?=
 =?utf-8?B?SFlIQUViaTFIcEhKV2FrcWE3ZDRqMzdYamc2eGErVEk5OG5LV3ZsdDZkR2VO?=
 =?utf-8?Q?AK7TtsIdja5Qj4Unzv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c473c10-e439-4288-4d6d-08ded909afb1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:47:55.9843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xibhEGlHIR8FbDmN4Spy6yN7JiQBQjBD9cw6IEwB7SNTpwHpOp1EEwP6xzA38Krt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j85x87wuymjziw66hubqmosoapzjsg9o
X-Rspamd-Queue-Id: B074C10000A
X-HE-Tag: 1783086487-964078
X-HE-Meta: U2FsdGVkX19cFOT8484f9NOSr36/3S1qbSw5a4joNYkkvibecpoJE09KarwCz+7ii4dy9jCjikE01JGXRleUtLdEew3CF1mPvcjIBnEjdEpCdpR1AIY6vfrLXms3AaiJDGUcpt6Zy/c9D+bQfprFMEfVpTDdJq9+PKNHATMfd3hFyd8HiMxluL+vUYoMC35KDVU6ymxil3vyCjW5TVNSaxizON2P1t+6HIIixzZTUCFXFhBxyGn14nY1Pxx024CUoqtsjVliBIeBjiHG8OcirjJHFhfdcHK/Qzs9RSbW6d1EVxdJ/+gS/bEHbMTUnNRIuryV9HWATTNqS8ScP10h0qteWF+/G7E8KGJBXq4W+SN3QzXRcTha9l+B76cXD7B89hQMXEOsKvjYj/bzde8dUnL9VJj2q7b5LaCE943LoafKY6owde+kt9JqQwHytPj7uDzYqZGz/Lex3aoj9GsXFPS+PX0mUdwpQxch3P0cBX0umvgSnU5OLRsgAZxZNF5jcdmzIAv/8ZOlar/drylOzx9anyrP5gzzKBm5JWG1F+V/9yOh8UrmGcvsMcAjQOqyTr4SG2rU2evbGIkBVfsoGsVkYJgaVGBXHOJEKbzbFq2pMoTLFCqUehKonlO+nmBogh3SdmVnIv419/2GwLFQKlOyC9jLvCE16f3KYjFg4Y70t3+ERcHlMr7PqbX+Ug3N+auLdgx1a46CF1xO8MDp6yHJvhevYr5bu1AdjG6JOIQQgJzlNXmbKKVszRyWMCECisQrToPgYBalX66Q75orrsD5afrRN/gMtgDgsYRYLPEMtIpGBpUUOwq40mKMb1Bkz4VoPYFS2hFYO7oZjTzUmSBbBEpxbVRoowyn7H7vOdjxQJZhfdLgo5vy7Gxri2fTlr3bBQqXD7tz2hHiEAmGCf+2x6/nhBZ7WURc0uN9i2qyyC2xoRc1dg+MTBAMhABMnEw2HikMRmk6mfdUMOw
 ckdUFHBr
 MLbqm3x3oWoDbEHq88BDffWIBTBb0oLSBL3wuzyfVOUQf6JjO4XAMCvnjrOVuWfCN6zL94QD6td6ts/62OwRUtw0O5ssLdB5ydkT3z5aP5vBHCam9fegVMdJIElJZyvA47aVb5yvETaDO00mVd7QlIThcblkklEn1eiJV0uXvvZBYH+yn+ZGJxI0UUsj6jC1doBkuA3ic2xSaoAGEBmL/tBYiAoDnvSHth5KPF43E2WazPSn7jaiGowLvH6evKzuYcOYegVc2UPIfib51HRjB1/hZ3VhIMY0osoVfHppcM5OnqCgHT6PJWk9LO040v976end81+IpPA3SA2VceGXkqC1pwhH5wF6cu2Cf1ttVWgHeA92aWaUmV+dP0MGhMKvDaXLDCU2/lG+NCd2a4cJTcYI6ThyXsghcCEgbDoQsUxD1dddijVCjdaqSXROFXCynt+YJMKFOMs4D/trY8EBIAaJrzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tail pages are expected to have (and optionally be checked) zeroed
->private when they are freed. It stays true during subsequent
reallocation, so replace the tail_page->private initialization with a
VM_WARN_ON_ONCE() in compound page preparation.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index fa4fb69444ecd..fbd9fb84341bc 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -902,7 +902,7 @@ static inline void prep_compound_tail(struct page *tail,
 {
 	tail->mapping = TAIL_MAPPING;
 	set_compound_head(tail, head, order);
-	set_page_private(tail, 0);
+	VM_WARN_ON_ONCE(tail->private);
 }
 
 static inline void init_compound_tail(struct page *tail,

-- 
2.53.0


