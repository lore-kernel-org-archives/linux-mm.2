Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0A6CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9C56B0099; Thu, 18 Jun 2026 12:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90BD6B009D; Thu, 18 Jun 2026 12:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F276B009E; Thu, 18 Jun 2026 12:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 791486B0099
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:04:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 029EE1C3AFD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:04:51 +0000 (UTC)
X-FDA: 84893506824.29.C320166
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	by imf11.hostedemail.com (Postfix) with ESMTP id EADD64001D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:04:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l9+bFuOk;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781798689;
	b=LQah+2D3P4G2UfFPBBVjdoB6zeh6z2ZCUjGdgSwZhRMH3QWHTenxkdruGpzxL11BqroqQz
	s0GB+LC0kxQV3m/Jb58zvpZrax5v2jXsvjDXUvL3rnDtrAX8k6rlf5zQROEgYirgZRhlmk
	nZDf0fjcKOKgmWz4AaLyYibOKJBIf3Y=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l9+bFuOk;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781798689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuBav2AQWuaas117zBus8gV8xoLJdjbrD9TG+TgH0m0=;
	b=Sgztm+ElzG+0dxhvr6j/JVjiyMZECllvaP2l4pqPVN5ItOZL02zWhJ8YiKtzi3+KiElUZL
	+ZFsh9xCtRyYTE3oPpLrPeTEFdx29i2oyBlAJmx9dRY4DbkF9EyNeCC0GL9ggCNhUuicea
	v/LjZlTLWqHKQbUYI0BMR5KWy+n/stk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgGWfW1UH6MnXZBajOC4XZWASyqhpX6mi4WmFSfTmNC93owz8YikVhwzjcAvPmIIKoRvhzLNbhoxQ0lzSa7K0iE8ZgnXX8Lr3T4cMK5XaPFLZW5oa115Aavh6mKox+9LDfSpSZIsQVdVfHT73x8/ujhnfns8pP+QvcoN5IoiT3uusi+OUGtS2MYw3lL5kv1ZcKz3dTAhr2t+R1zniP7OHg5jB29kLFb9IPXgY9S2OQZ+QP1VhToZ7Ilyxjo6nOy3MVuzM+DbwRcLI/mmlADO+q0gz/KAMq6xjLHjL40kkV0+lqH6YGDgy0bV8qIVEnKaaEaqirU/2fSaCTbHls+9fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OuBav2AQWuaas117zBus8gV8xoLJdjbrD9TG+TgH0m0=;
 b=GxvOHHcS8MVr3bIqhDjpRtN3i9YufhhXFKSlyla2o/zQyJx9Vm/1KHa+hQnoLjK83iYF4IpmOUxTBrZj7VSM1atoIfH9z40rEy2JfGUzR7NyGA2EUjivkzK8+VpwHzhZqC3lXtPhvW6rnN8KlVtc+KMvFnRXlB78mj0nZbzAD5e09JX/cIWYtkxJCetWo9OhFdfzo+PyQg2ku/mmYYavmm5kXeR1y07Ocq9b1SNqtHK8GW0ckGIotod2W+o1IxWzHyI/BkDl9I0Yi2PYTm7hYKZI0fCSbxctOXG9iAcyqDVY9MpMysA1/itE3D8Lj7XvpO2yLMIKdEe1sSmx6cxi1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuBav2AQWuaas117zBus8gV8xoLJdjbrD9TG+TgH0m0=;
 b=l9+bFuOkNScMM3QNx9GbJXzEFytKkSAy7NuI2bzPt1yA9d7elOfChXOXmkiwHrTJRREQjRsOetlTMlm8Ij9CdQ6KtZsmDgdIoh9dE5SwcKB2BFeUgULb/EDg1+7eSveb/3z8zF5dvZ4Y7GCX60EwQglLzg91KXqbAb4QKXbh9cypTCpcqOt726N1s2kegcc1RdnoIOpKOwqU1Rbz0DyCcHEzbLqeeAizhJybsCDKsc7mLq+VnYWfZhQ4WDEFz13lfFpdgYIesouqXep9PFFLw4pVeVD/hjM9VauCvE1a6eB0PkN846f6ZPhSFew1VhOBGVmFUedyutQ5cfBifXpS9g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6668.namprd12.prod.outlook.com (2603:10b6:510:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 16:04:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Thu, 18 Jun 2026
 16:04:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 18 Jun 2026 12:04:30 -0400
Message-Id: <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Cc: <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>,
 <jackmanb@google.com>, <hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>,
 <david@kernel.org>, <william.roche@oracle.com>, <tony.luck@intel.com>,
 <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
 <akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
 <rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
 <osalvador@kernel.org>, <willy@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Zi Yan" <ziy@nvidia.com>,
 "Jiaqi Yan" <jiaqiyan@google.com>, "Miaohe Lin" <linmiaohe@huawei.com>,
 <harry.yoo@oracle.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
 <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
In-Reply-To: <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
X-ClientProxiedBy: DS7PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:8:57::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: 3abf0b17-a0b7-4515-5263-08decd534a92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|11063799006|5023799004|4143699003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NAncqoL0kkmEsmC9ANexUJVz9Fzjgo59MIkC9CJqaSsrV+4fF5n+meOaKZFhnv6w5wtGshtWoVXOwlmr9xgxF8KJrycB+Z2fdDuGFwDaDojwrBNJ8kA4qUSpsxA/S6XkDGW8KXA9Myn4QGqbN+4J83w/qYhS+LCWDeGXz5kKmHWGAVqxdbeM+7bdDHuZh2IcAPSa04nXqpW0oHKuw65BjtRidlVzMQq0QDUcM9AlRxOOyzQublCiDDxmpFxPKJZZQmu73NNzPBfScFZj38xO9PDKn5PURvhuXGeIXoDWkaNMkOmRfOP0GvMPhnP8GEA3jSyKCV9PpSoS7lFaV0Pewjkl4evkQ3kpTELGD4dgUtUmovxN0cN4vTmAFHTA6cnpa7EEcdNsqrPN2BFuI9opdUl5iABW8MTcG/E3TsyBPqkHyh21kuGHOuvOMFkiS8ZGIVslFtoOvZnsC+QzcUCRjl4qFn3v+yie8k3ho9K8aisN2l4E6N857aFM70XilSg+sE4vskTEa9aIi2PJ2JRf27YhYxxiznb5Hvov/AhLXs26sXKDUW+rQE5bxs3QLBdJCEz8wJmIjXXh/sOYCpznp3ympgVC7JccbEOKpIN1EiMsv7thqBBxmXPZXAQNabrDZndg8p65q1m/L/WgtSoFMxiaz6dJqPGMyhCPKSJn03zvvWDO0iAfkZnrQBY5Q4Jm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(11063799006)(5023799004)(4143699003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmxxYWtlWExJZ2l4ZlpMS2NBcG1uQ3BJU1liODNWeFFFZmxPcTNjbW1QekxU?=
 =?utf-8?B?Qk5iK28xRkphSGFNdkpMSWw1TXllZnJERUtOcmlxYkxoU0U4bW9iWjFOcHRl?=
 =?utf-8?B?QkRZeFNuTjVqL0dhbzZpdGRxYXBiSTZDdzhobHFtSjd4Qnp3TnphMEpsZG4r?=
 =?utf-8?B?NHFyUk5CM0VzSnR4Ym4xUktGM2hBeUNVMzIwTnpiUGh0RGdEeThUNitkc2x4?=
 =?utf-8?B?OEpIZXgwNHg2eEY3d1VXRS9WZ0RzUVRvQ0NpMDlobHdFTmduYWpXSUlLK0xm?=
 =?utf-8?B?d0xlZHJueSs4RUpFSlFVenp1SDFvenI0aEM0eFhTdEFxU2ZvdnBZWWNCSHVw?=
 =?utf-8?B?Nko1WXE2MHNFaGZyYWNid2Q5bkN5eGRrRVpwL3A3V3kvUjhNNVlDbUtuRE11?=
 =?utf-8?B?elUvc0kyUDhnNTZuOWhCVlpDNnVPNGNFT1dDeVBTdHRFcDlsMEE1VFhOTEVH?=
 =?utf-8?B?Y2pCb0ZQV3FoaGd0MXVvTHMwMmdVYVV3NFhHb0N3TFJhdzFhcktSV2tPWnNC?=
 =?utf-8?B?YU1GWmJIOHZOZ2RtOEtDYjd0SkJhSGxDTkdJZFQ0b2NHSTlobFgxb0xzeE1E?=
 =?utf-8?B?dkdDZDVrZFJuOUtySXI4ek4zYmd4bzMweEQ1THNoampRMGJGTGcyZUZNOU0x?=
 =?utf-8?B?dG9LVnQweEZmcXczN2xiTUY5MTJFblpIN1pXUGpLTytCOHFBcEF2MFJ4dVQr?=
 =?utf-8?B?cE9mQnA5SFBsdVBKSzB1dXpHUUpESXVCSXVaMnVPZjQ1UGx6bkRhVktySDFq?=
 =?utf-8?B?RDdYV1o3a3daTTRHNHRYc25IWjZncit5NW94WnZJNDJ2TkExaXpGSzJlV3Fz?=
 =?utf-8?B?aVA3Z3RSNks2UzZ6TGgveTBLZHk0Q2llaUp1VFhLM1NuNFlYQlEzMkxVUjFX?=
 =?utf-8?B?QjZ1UVVOb3hJQndkRjZtTThHSFFoMURBb0UyU0hTUXNwalBZRVVNbWRZbGtr?=
 =?utf-8?B?eU1zZFpJK3NGZkh1eUZXSzM2b05hTHM0Rlp0WitQTXRWQk9Oc2JJRlNBQmt1?=
 =?utf-8?B?TDM4akF3R1cwcHBaWHZBS2VsTU93Uzc0U0ZUMzV5QmcyVnF0allzQzdZaWxR?=
 =?utf-8?B?VXlWQThLODlSYVR2UUNncnY3QzJkZG9NR1ZtZFpaRWVmbHcyekVPM1MwY3lz?=
 =?utf-8?B?OU5xUUhHVFdEYmczYWpYK09rU3c3bUFaYTJPd25QUmJjUjlTN2Z4VzI1WS9B?=
 =?utf-8?B?dU9vZ1EyZUdMWFAvWE9sNmhSaCtkMDJvb09DcDBML1RJcU1EREN5REh3TUUy?=
 =?utf-8?B?T1BqemRVMjhLMVovMXN0Rm9iNmJ6ckJBNkl4RW1mSEdWdkg2Ym5YaEJQMndl?=
 =?utf-8?B?RVNXQjFCdE5rTUJXWXdRM3dQeFdjQi9Wb2xjUTVjSHVOT0QzME1rMkI1Ujdo?=
 =?utf-8?B?bng1dVZ2cXRNb1B4TGNGYXQyTFJFOTlxVmx2QytxR3doekx4bHd2WXNvejJU?=
 =?utf-8?B?QVpKcnkyODNPbytkMmVzajRsa21jQ09kL0hxVHZJV1hDamZsUFNTWWJqS1Bn?=
 =?utf-8?B?SittM2N3d21WMFJmWWFKZGorWHJQd3ltdTlLWHZad0k3R1Y0Q3JhV2FHeHlV?=
 =?utf-8?B?V3hMK24wcWhGSkozdkZnSEhUamhEY3lRa0FRaXFQaTJMNk9JSko4YmdmOW83?=
 =?utf-8?B?cTJUOUJTalVVNlVuU2NRWm1WNU1CbG9FYlYxdjZaK0FwdEdBNUJ3dGw3V0gr?=
 =?utf-8?B?Y3lkQ0R0RnNEQ1NqbmVKV09NeDE0UGJqZ1Y0R3BHWTN4cERZZ2JrMmxZVk56?=
 =?utf-8?B?SHk4T0JVTmtxY2YweUhRNnpHMWc4c3cyS045aU8vUUY4MExlYnVGaEFPMlAw?=
 =?utf-8?B?OGdPblhTZEgvcHlKdThnUW1vU0J6WVI4WGs1SU9nNTZMbnFEMTdtRjlpeFkw?=
 =?utf-8?B?N1FwSVIzcGI0Z3A3QWtoOXE4YWFzV3AvRTVvYURmRWRKVG0rSVQ2ZUNLd1h3?=
 =?utf-8?B?enBBMVp5b3dHSHVNaHdTYmYyOVNwWG9VQXNkZXpCaTlPU2M2Vmg3L1dkSGR4?=
 =?utf-8?B?L3pXZDJMRzUyYmpnUHp4emVxSmFiU3F4YkhqMWhxTERONm5ib1Vhc0VqT3E1?=
 =?utf-8?B?MDRxaGZ2WThTZDNEa1gvVEVHNHpnK0JxaWdYeGVSZVBxa2JtNjdGSFpkTldJ?=
 =?utf-8?B?dDhlcGYxa3lJZ2M0Y1F5ak5QT1dVMm9rRTczT2N1TzdrMGpZamNLOTdzMG1C?=
 =?utf-8?B?dkVKajNZbTVZWFVqUnNYR25KeFpDeDFnQUlNNVBvR3U0YzFKZ1ZlemVxMWw2?=
 =?utf-8?B?d0h2RkNwYUJhdzlwalYvS095d0NkTStCVDI0WFQ1UkdYemNrMFpocU5rSk5j?=
 =?utf-8?Q?c6Dwnt54aYAbzxucz3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3abf0b17-a0b7-4515-5263-08decd534a92
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 16:04:35.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLMfxdVVmmte9N2hrVklFrIozle81Fylz/zuBKqbRk4u0N9/Ba8XneEZEsqGdiUI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6668
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EADD64001D
X-Stat-Signature: sxrist9yqauzt6wuu6zrxecsnoq68o6i
X-HE-Tag: 1781798688-229385
X-HE-Meta: U2FsdGVkX18KiYWyPoR01p7XDBi1HmD4hp8M5AvKlOOYUqYcUxr1Fiag9L9ayEkaVb/4g8HAx3L4bNCaPZaFV1l4Sm/Ts4ymr3fKlC6xAq05rDffW3rWdz/I5GuT84HmONR2yDOsVmPYo0pBbC+mvdvX5ofu/WOfrORjsYhewPA8hrinmfCAOrTbkI0/uQzYITYogAlk+xZtDzYUEqgJ20cwNcuVzRFU8liMsuX4Bfi57/UCbR/KIgIZ6n8uBW83YnDuh7nREapX5kMcYxv8aNeeDt+rEGAXIy9+EipBngjhOLv9bpxY6JIrLGqmwT2YKXOTURSJ/TZeU598wVLGdW8mu9VPp8/hT8FvmMuWMO6XH9qUVJuQ2+TAUEZsVcuxS6jYK0mXw/RpNSoGmxFTWm7u2tDNHl/ZU2xHDCPZ7HBUlINo1oBZKlrzEFmHVwRIWChmxFa6Sxbl34F+MRCMbnEb6Fmez5zJ/ehDFFVuwm0wXbY/W+SpxX6RShBlYVkqcqetR/3qlLDutzFTUGAllqbSQRBTqT0ETPrUXT91SHn+UgA+NKbcldI/fEmn7Hbow0/uGe1LsSB47KbErRTQjQNdntZWF+oMx/5psFOvN2ygh8iXqfS/1CvBCQBeeJ/NkGCJkHy7tkMjmdYZAijxSPNXNV9F+if+7bER2U4c9gvVcozWAE6kkDdmnyZLKPn0L3MPS0vSghMV2ZhRyt9szJAFY2m3YuZZiPIfA+PJSX/lYv1R8kg9J/cbxONA/sVJb9rhl3+a/FohqqrBZ/ldbdRT+a7OXVO6rWo1laA0jSniDCvwdiIFabE3G/HbqIN43Wt6AG6+2WH88I7kHnAsU6VuzaWWA8MPpYDhsea/eGQdnAyBRAOsIrI+SQt5hn7DeePE8/7fbwFxJKABoGwb+oX4uzMDmP62dDip05GWKPwEufFh/PGvxNgedefY81FcOh+jsZc7g1E5prYIgeb
 NIXqXEJ8
 J+djHvrOprGRpObHSNSh3EtU1d+r/Jsy5T/aek3x15b928EyiPdc9kk5OpOMnB4Q/Z2lfqmZ/dDh458zeQ3R2fuI7+DWk3JikcXYtUfNFXSjE4Yw1Pp8D2AwwJfryelSUWyBjWL3wI2eE69ZjQxJ+rXToJq0B2E+CSC3zY0LJNZxJVzYX5A3r8am6G6ER1Z4Y8vkPnh1rzGx7+Zc54W0nM09typ0ZDTbIM2kE4E/h3djwniVVJLcE5v2I69O+phbXgyBs3U3Wq6KY8vFOsJiFAOIF9J1h3Yiq27j6HQr5M7uEB02JdgZLKIl7GCp6DwizgW4UKCvZyxHlDl83116CgjPcVWhP2wGG02u6kGIn3MjePHflAMsck/mXy56wmZMOxsp8IVyQh6FYXyKDSsC0l74WQbzTNBeDlYSVnR6IX1awwCf05jgNZAwc7X26h40eijUgTqKYak419zYdVTcccPLONI9aI0TRjNtOPPHBk9bvTjFjFFM/CPGzGTzWXCRtc9tKB8ap22vh2fhFLvyi0Ce6bxdoBDHJOrGkLr+nLn2e/5Ww80pG1CMAI2TTMqy4FxgPUELoPUEtPi9ZyskXzcqKLzcA1zf4f0e4U8U8KsY0nb/h2yeT8xGHMi1iH93gCpfJYXvU9VxXzcyVIm4NgTtFEEfeVjqZVeMAyvD2rIQcMb6KaTx2miv64Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 18, 2026 at 10:52 AM EDT, Vlastimil Babka (SUSE) wrote:
> On 6/17/26 03:56, Zi Yan wrote:
>> On Mon Jun 15, 2026 at 11:23 PM EDT, Jiaqi Yan wrote:
>>> On Fri, Jun 12, 2026 at 11:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>>>
>>>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
>>>>
>>>> > On 2026/5/31 13:58, Jiaqi Yan wrote:
>>>> >> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>>>> >> becomes non-HugeTLB, and it is released to buddy allocator
>>>> >> as a high-order folio, e.g. a folio that contains 262144 pages
>>>> >> if the folio was a 1G HugeTLB hugepage.
>>>> >>
>>>> >> This is problematic if the HugeTLB hugepage contained HWPoison
>>>> >> subpages. In that case, since buddy allocator does not check
>>>> >> HWPoison for non-zero-order folio, the raw HWPoison page can
>>>> >> be given out with its buddy page and be re-used by either
>>>> >> kernel or userspace.
>>>> >>
>>>> >> Memory failure recovery (MFR) in kernel does attempt to take
>>>> >> raw HWPoison page off buddy allocator after
>>>> >> dissolve_free_hugetlb_folio(). However, there is always a time
>>>> >> window between dissolve_free_hugetlb_folio() frees a HWPoison
>>>> >> high-order folio to buddy allocator and MFR takes HWPoison
>>>> >> raw page off buddy allocator.
>>>> >>
>>>> >> Another similar situation is when a transparent huge page (THP)
>>>> >> runs into memory failure but splitting failed. Such THP will
>>>> >> eventually be released to buddy allocator when owning userspace
>>>> >> processes are gone, but with certain subpages having HWPoison.
>>>> >>
>>>> >> One obvious way to avoid both problems is to add page sanity
>>>> >> checks in page allocate or free path. However, it is against
>>>> >> the past efforts to reduce sanity check overhead [1,2,3].
>>>> >>
>>>> >> Introduce free_has_hwpoisoned() to only free the healthy pages
>>>> >> and to exclude the HWPoison ones in the high-order folio.
>>>> >> The idea is to iterate through the sub-pages of the folio to
>>>> >> identify contiguous ranges of healthy pages.
>>>> >>
>>>> >> free_has_hwpoisoned() is added in free_pages_prepare() as
>>>> >> a shortcut and is only invoked if PG_has_hwpoisoned indicates
>>>> >> HWPoison page exists and after checks and preparations in
>>>> >> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
>>>> >> can re-use free_prepared_contig_range() [4] to decompose healthy
>>>> >> ranges into the largest possible chunks of different orders.
>>>> >> Every chunk meets the requirements to be freed via free_one_page().
>>>> >>
>>>> >> free_has_hwpoisoned() has linear time complexity wrt the number
>>>> >> of pages in the folio. While the power-of-two decomposition
>>>> >> ensures that the number of calls to the buddy allocator is
>>>> >> logarithmic for each contiguous healthy range, the mandatory
>>>> >> linear scan of pages to identify PageHWPoison() defines the
>>>> >> overall time complexity. For a 1G hugepage having 8 HWPoison
>>>> >> pages, free_has_hwpoisoned() takes around 1ms on average on
>>>> >> a system having 56 Intel Skylake physical cores. This is
>>>> >> 15x to the case of freeing no HWPoison page. The cost is far
>>>> >> from triggering soft lockup, and fair for handling exceptional
>>>> >> hardware memory errors.
>>>> >>
>>>> >> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-em=
ail-mgorman@techsingularity.net
>>>> >> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-em=
ail-mgorman@techsingularity.net
>>>> >> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.=
cz
>>>> >> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anju=
m@arm.com
>>>> >>
>>>> >> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>>> >
>>>> > Thanks for your update. This patch looks good to me while some comme=
nts below.
>>>> >
>>>> >> ---
>>>> >>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++=
++++
>>>> >>  1 file changed, 85 insertions(+)
>>>> >>
>>>> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> >> index e47679e7a9db..03df929abca6 100644
>>>> >> --- a/mm/page_alloc.c
>>>> >> +++ b/mm/page_alloc.c
>>>> >> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BO=
OT_MASK;
>>>> >>  unsigned int pageblock_order __read_mostly;
>>>> >>  #endif
>>>> >>
>>>> >> +static void free_has_hwpoisoned(struct page *page, unsigned int or=
der);
>>>> >>  static void __free_pages_ok(struct page *page, unsigned int order,
>>>> >>                          fpi_t fpi_flags);
>>>> >>  static void reserve_highatomic_pageblock(struct page *page, int or=
der,
>>>> >> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(str=
uct alloc_tag *tag, unsigned int nr)
>>>> >>
>>>> >>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>>> >>
>>>> >> +/*
>>>> >> + * Returns
>>>> >> + * - true: checks and preparations all good, caller can proceed fr=
eeing.
>>>> >> + * - false: do not proceed freeing for one of the following reason=
s:
>>>> >> + *   1. Some check failed so it is not safe to proceed freeing.
>>>> >> + *   2. A compound page has some HWPoison pages. The healthy pages
>>>> >> + *      are already safely freed, and the HWPoison ones isolated.
>>>> >> + */
>>>> >>  static __always_inline bool __free_pages_prepare(struct page *page=
,
>>>> >>              unsigned int order, fpi_t fpi_flags)
>>>> >>  {
>>>> >> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_pre=
pare(struct page *page,
>>>> >>      bool init =3D want_init_on_free();
>>>> >>      bool compound =3D PageCompound(page);
>>>> >>      struct folio *folio =3D page_folio(page);
>>>> >> +    /*
>>>> >> +     * When dealing with compound page, PG_has_hwpoisoned is clear=
ed
>>>> >> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
>>>> >> +     *
>>>> >> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SEC=
OND.
>>>> >> +     * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_ba=
d() will
>>>> >> +     * confuse and complaint that the first tail page is still act=
ive.
>>>> >> +     */
>>>> >> +    bool should_fhh =3D compound && folio_test_has_hwpoisoned(foli=
o);
>>>> >>
>>>> >>      if (fpi_flags & FPI_PREPARED)
>>>> >>              return true;
>>>> >> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_pre=
pare(struct page *page,
>>>> >>
>>>> >>      debug_pagealloc_unmap_pages(page, 1 << order);
>>>> >>
>>>> >> +    /*
>>>> >> +     * After breaking down compound page and dealing with page met=
adata
>>>> >> +     * (e.g. page owner and page alloc tags), take a shortcut if t=
his
>>>> >> +     * was a compound page containing certain HWPoison subpages.
>>>> >> +     */
>>>> >> +    if (should_fhh) {
>>>> >> +            free_has_hwpoisoned(page, order);
>>>> >> +            return false;
>>>> >> +    }
>>>> >
>>>> > When the code reaches here, the hwpoisoned pages have passed through=
 kernel_poison_pages,
>>>> > kasan_poison_pages, kernel_init_pages, arch_free_page... These funct=
ions might write to
>>>> > the hwpoisoned pages. Is it safe to do so?
>>>>
>>>> At least, kernel_poison_pages() writes to the page. It probably should=
 be
>>>> moved up, somewhere like above kernel_poison_pages().
>>>
>>> Writing to HWPoison pages (location having memory error) is usually
>>> safe, as in it doesn't cause a machine check exception. Memory
>>> controller usually just fails the write op and waits for the next read
>>> to raise the MCE / exception for prevent silent data corruption.
>>>
>>>>
>>>> I do not like the shortcut method, since the pages are freed in
>>>> __free_pages_prepare(). This causes confusion. One alternative I can t=
hink
>>>
>>> What exactly is the confusion? or why does freeing has to be done by
>>> __free_pages_prepare()'s caller?
>>>
>>> Harry suggested the shortcut method [1]. Although freeing inline might
>>> surprise the caller, it simplifies things for all callers.
>>>
>>> [1] https://lore.kernel.org/linux-mm/aVy7L-3pc4JUYBEn@hyeyoo
>>=20
>> The function name is __free_pages_prepare(), but the code ends up with
>> freeing the pages if the folio has HWPoison.
>
> It might free some, or leak some (already before this patch). Seems to me
> really the only important part for the caller is if it can proceed freein=
g
> or not.

OK, at least add a comment to __free_pages_prepare() to document all
possible outcomes.

>
>>>
>>>> of is to make __free_pages_prepare() returns a enum
>>>> { FREE_PAGE_PREPARE_SUCCESS, FREE_PAGE_PREPARE_FAIL, FREE_PAGE_PREPARE=
_HAS_HWPOISON}
>>>> and handle the return value in the caller.
>
> Until the callers need to distinguish that, it sounds like an unnecessary
> complication to me.
>

Sure.

>>> Are you worried that a caller of __free_pages_prepare() may see false
>>> returned in the has_hwpoison case, but mistakenly propagate some kind
>>> of error, or doing something under the assumption that folio not
>>> freed? In this case the three enums can be useful. But I checked
>>> current callers of __free_pages_prepare() and they don't have the
>>> above problem.
>>=20
>> Right. Looking at compaction_free() code, if dst gets has_hwpoison (not
>> possible now, but if in the future migration code decides to mark folios
>> when copy fails with EHWPOISON), the next list_add() is going to cause
>
> I think we should fix compaction_free() (as a separate patch preceding th=
is
> one) to not proceed if prepare returns false. It could in theory already
> happen before this patch due to a random memory corruption of struct page
> causing some of the existing checks to fail.

Something like below should do the job, plus
Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory=
 compaction.")

diff --git a/mm/compaction.c b/mm/compaction.c
index b776f35ad0200..b2104cbe63477 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1876,10 +1876,12 @@ static void compaction_free(struct folio *dst, unsi=
gned long data)
 	struct page *page =3D &dst->page;
=20
 	if (folio_put_testzero(dst)) {
-		free_pages_prepare(page, order);
+		if (!free_pages_prepare(page, order))
+			goto skip;
 		list_add(&dst->lru, &cc->freepages[order]);
 		cc->nr_freepages +=3D 1 << order;
 	}
+skip:
 	cc->nr_migratepages +=3D 1 << order;
 	/*
 	 * someone else has referenced the page, we cannot take it back to our

>
>> trouble. Or you can rename the function to
>> __free_pages_prepare_and_free_has_hwpoison()? At least, caller knows the
>> potential side effect.
>
> Uh that's long. All callers are from PAGE ALLOCATOR mm-subsystem, it's no=
t a
> driver API so we'll know what we're doing (famous last words :)

The name above is a half joke. :)

BTW, I do not even trust myself sometimes. ;) Just look at the
compaction_free() issue I introduced myself. But I do not want to be too
pedantic here. So a comment above __free_pages_prepare() should be
sufficient.

--=20
Best Regards,
Yan, Zi


