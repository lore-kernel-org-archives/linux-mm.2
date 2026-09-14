Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D073C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DCE6B009D; Sun, 13 Sep 2026 22:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F26E6B009E; Sun, 13 Sep 2026 22:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7937D6B009F; Sun, 13 Sep 2026 22:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 375856B009D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBA73C0EC0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:35 +0000 (UTC)
X-FDA: 85210774110.12.FC8A7ED
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AEBE120006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jsgEWMlo;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qx2EhSRggahbLLHIlX9eIGMCbcGjmTOBasCV3TIU6I0=;
	b=tUkxwxpV/d2Zv+4hr/eKGPCidq9d6Vda1jTQO242KClYu24lX6JcUBpLfCrgwbUADWIHEH
	8MbzqOIDcNrT/mcA2G8QcVW6PX2qxtVA2gnifBrPO8xRsyBArmBw5JYdbNt7XfavZkkcR+
	xdGc50VMh1DCZzmh3LCnIhkupwnxzh8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352673;
	b=UOxeFpQLfbRUGk9A9DUTusa27c05nEJP6NMO+F06+c8O0wM1qMuhVFTrYQZH8eFrvN8Bt9
	uHwsnUAlTOEUj6wpGMC3Cb3+fA2ONN9ggWYx5emdmTXpVPOx7yyQCzQgMvkWN65gjyElun
	SYAhrh3pXHOim5tWz07NOvdnZtVorS8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jsgEWMlo;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXXu7k32ZyaxfiV6Pj3CEt2lPL3QItDw5oOoCJSnnpjQDmcY8KQxUWnbk2L45JZkpWE3U3SsNiYtuMBjZ+SHYl3xdisGJ5ikxvlKSY450OAVX+qZXNFaeLL8vZZxEDcYLMkkGJba+Nw7CRlyAaGFwMgg56zE5Flph+LFwzqCPVbJfBfE5en9GBtTCN4lU93wsRuj2e8aK+gvOS+f27LgenE/BxL+8DkPsAaxeeitO2IpfE8z7O+aaVmv2Yzy6grwGoP12+L98jYxhN2OwVlAjHhiKyJt04GHoKcmcXmjisBTmMJN9rwUSveCkFmvKpWom1UZpu2uJZk+sUbrXTV21g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qx2EhSRggahbLLHIlX9eIGMCbcGjmTOBasCV3TIU6I0=;
 b=Yg4yjrPeMjUqFsJCcuVY26rDvAHYSU3h/CMpjq4VfJ1DgdU+MwO8/jK6nsw7w+KyXU68/J4fFYbF5kya+Giq7FpcbZIsPyjY+kUJxVQJSFPjfNaGgIbWz/wQjM/iZuIUlNdsywWxZmLUCHQOgdOQOfoKhB498A/yskePT2MRs6w+H6WJBA70mv/q4oX2W2t0fsgXR4rN0EaWdF4nKIDnQKq4/Jr60ZO+A2xomA4V0SIFoHyodrZj76B9bmtEJoWbIDariOihAR6Ptzir1FMtF0xrCXZKOznOelGF/ygESV9CbLOOGTwPSAiqcGBwylwgpggiQ3589rni+lOu3XUhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qx2EhSRggahbLLHIlX9eIGMCbcGjmTOBasCV3TIU6I0=;
 b=jsgEWMloItQcDkRAnYMZto8t421o4HJz7fTiY22Fnr3NzH7FxEyj5nYYEaCOX1Ru0XnGzsH2O0otKysTwt8CPsDCa1rm8NLGOJ803jnLrcEEEF9by8Z9a5JViqcjZlHxq3EklsbFoxWCeoY478sqyMfRNxPElbWHMDkxt5vHLbwKJmjxRXh7JBDMk2O6j7sjq9nEWOo49L/xD/ntV8Ve6NKT0GPH+Mb1NX8/YU736aEYa1Sv3bsyAgncmP81/EFyutV6CnA8xy084VPd9SLx7vqKnf7tZ7RLZfrt6EM6jqouCGuf07AOzuOaPqA8F1p5b/LPz8Qu7wAzr+9mowiumQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:18 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:03 -0400
Subject: [PATCH v4 05/16] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:52f::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e141dcc-bcb6-48c3-885e-08df12074795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	as0/kEE0l1ECvNfYIGH4IaHJoQQPviEQOMxRqQLyAzJtklqfJJqJRkPfnOyVXYCaoBbW9BAbsS2hMr4RcAzqhW3qUpR8+SEGyErTzGl52QlDJGcfE7p6xEDiO+CoxoC41O4Uz+I9RiVNthtuVU1MSm8PSyKNM5LNfzRVr11B+lZ5aCHPVlLEEBjq2qti4ka3PZdMrWkibjCUdwjHAyYaLKicEjtFIFLBkW5c1/g5acPxGHKNovFwj7PNmJ6ouGwkW3JaPtlRT924wHjXNNSJLarEgK2vWk2B3OaIcPWGV4YkACeDRhca1NArHw+noAPfXcwwZ2iMkc24PN1YO4enDbQwZvmhfMzOUZg3W2JEeTxIPkCItNJhDg9NT4LzV2vhr3MwvRY08cs99c4Q2zZpu/j00IO+XPruSud17EPPVpfrhuEIrLttOEs569PANI/a62i77YpYTY4CYhHbkXDKJaas8xp+TwU/rtSg6fnmCZNP5VXjgxDn/+7azuOZtlHtt36cHUMjME6soDNLRqn2r9LiWxi1xKnaHS/b9O7CECh6qbkePLXAoZ5vxKBHxmVp5OJo1KTeyd6k7Pzd5DKi4x3LkPMdhXqPIMGLcrwSrgtLZdc0t676oSSeXRZg11Bgmij++bPolLuZ6zrKzRwTDLuoLFjfAQWyO4YlHeO2WPUj06sdPHDSfky61ocyJu5FhTZFDYIFMrBVLF2n+QbdSQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE42SXNTdTEvSWM0bDFlK2huRGtPOUM0QnBrM2c3VHA3bmh6Wk1objFxMzUy?=
 =?utf-8?B?WGRyWWFlZ013cXZkbWk3Y3M2NXFrRzhMS3NIMERSU3F3Zlh6OEU0V1dCU3I4?=
 =?utf-8?B?MXpTUjltLy9QcTBxTlJHQytuU25PZTlEeTJReGtLaWordStoK0FxKzh4eGxj?=
 =?utf-8?B?SCtEM3hwUUJPR0sycG1WMUVsanY0M1RGNy96QzNpZmZzcEJ6b1dqWkwzU2RO?=
 =?utf-8?B?ajJmaXlPVW9QeGpTelZvRXIzR3JEdEFwNEl2MDVkMyt0K0JuNXV2Y2ZBVUlk?=
 =?utf-8?B?cEd0Z1kzSFRMZ2hHKzVINmcxb3BvVy93bXpDaTBpMmJVVk11dFYvdVZ6TE1z?=
 =?utf-8?B?S1lIcGorWm90aFJmYlUyUGRLZmwyemlFbU5LZWQ1elRtcnF1dFF3UU9SL0VT?=
 =?utf-8?B?TmVGaWJ3a3FVcEp5THludndQSFJ6cUtxTWRlZ1FkcTQ3UVI2Z0RvbFozdnZa?=
 =?utf-8?B?R21oZG81NnlsbWd1VEVMYklZcVRHSlhNS1dRSHAvNEU2OEs2UkxzeXdXVVhz?=
 =?utf-8?B?cW0wTmttdkl3VkdlWThEdU92ejhONHM4MDRqS25CWnVSTlpsbnBQd0NMY21t?=
 =?utf-8?B?NkxWcVRoaDRaRGtIeHg1UkxXWXZYSUVHVnI4MzNidjZtTEM1S0c4WkZOeE9E?=
 =?utf-8?B?MXhaUUM2Rlc0ODZXUFBsQ2lHVTdjbjY1MmJzQ2kyZXAwSkpDQ1U5RnZJNndx?=
 =?utf-8?B?SkNsaHZab0xKbHlmdFM4VE1veGpMTzQ3ZWUyWWJ4THhZSjhzNGNnUmQxdmE0?=
 =?utf-8?B?dG80N3pYK1J0a2cydlBwYTVMaURrZHloc2tJZHJ3Um0yL0JKaEFYaXV3di9Z?=
 =?utf-8?B?d2pLU0EyYWlhUmhDM25nZUxGbHcrUTRyOER6WWFvVk5QY1RCQ2NNaUJoSEJy?=
 =?utf-8?B?MFBLaUxjMmsyczNNYnl1WFZCOVZoZEhGVG1IMHlIZVZpcFpkL1B1azdaNno0?=
 =?utf-8?B?Q3JvWHhkWC8xRDNmUjQxcXVPQ3k4dEZ2NkJkTG1QQUVWRE9MbzVKRTFyR0Vp?=
 =?utf-8?B?MTNmcG9ydENJajB6TEtCc1FPWi95SCtUWXlkalRzMUdtTEVTNVFSNTdlN3o3?=
 =?utf-8?B?b3Zxd0I0Z1FiMnQwWk8xWmZKUVNjT2FCWG8vSGpQUGhLN3pucTVXRUlhMS9O?=
 =?utf-8?B?WkwxbzVHM1JCVWRxRWJBWFlwVzVWNDZleGZFTkdrRXRuUnJuL2F0VlhWL1FK?=
 =?utf-8?B?MzJMQzI2T3plVXBBanJNTVRHSVhpVCtlNlF3RjFjMTJNMXpiUHovTEpMeTI0?=
 =?utf-8?B?YVMvK3d6bXkrMXlRYWJia1Nxa0F2bGRhTzB3aFFzdnVLb1Z6MDVjMFIrVHBl?=
 =?utf-8?B?Mkcwb0xibndkQktOVmR1eG9PclFvL0FFcGtwNWovVVEzUmlIR1BYYlZ3NVB3?=
 =?utf-8?B?NWx0Znd5WHhHbXFBMUdYeTlYTnZhSEdCOVRHWStQeTNVcjMydnd6V2xwQVhV?=
 =?utf-8?B?NWp0c3JjN1MvamZnQTFrbkszRDJIdGJycGMxS3hCRHptNGRKWDVpbXRzOW1h?=
 =?utf-8?B?a21zVHp5MDEzajhPZFVRclg2c05mUmNUUktyWlpxT1B4UlljV21VQ3BWT05m?=
 =?utf-8?B?UVZ4d3ZRYWloSENkUXY0a1BQeGNDWHhJcEVZL3dsV1BDcWVGeTA4NDNvMkM1?=
 =?utf-8?B?VmVqem9tMHF0VDViWjUrOTdtZW4rRjBsUWlTcVhub1hGdFlTa2V3ZE9zaFRM?=
 =?utf-8?B?UGlTL0lhRHZXWWt1ZUtKYndobXIzV1FNamlzQVVYVStodDVDdEtiV3lqREM5?=
 =?utf-8?B?QkoyVEZ3TzVGbHhPR1dMdkp6UkFFd1RTZGVwU2Zab29KRnFFYU8vYUtHdDFC?=
 =?utf-8?B?QVpjTnd5RDFJUVJTM3M2U3BvT1A4YU1LQ0dySDRndzU4Wk1DQVRYandFN1Yx?=
 =?utf-8?B?bUJhY01SOVd4dmVoS3U3Zjh6RWJOU050cWl3S2l2R0hnc2Q2c3RyWk1VR2hk?=
 =?utf-8?B?SDdlNkhpdlhtKzZCcDJnYllmS2ZFeFpHM3BUNDFKSWdRUEpPaE1ldjdVQW9S?=
 =?utf-8?B?Z0hmeUxVL2dNUmNROFo2eHhna2Uxa083M01tcGUxTjlHUk9wT2Z3ZEhwalVl?=
 =?utf-8?B?S0ZaWnp5L2pnaVdweERodnlPSVExeXdwRFpIT0Q2L3hBeVh6elhRRllzaHgx?=
 =?utf-8?B?V0ZaMlFnbXArSm1UQzFIZVhJc3FyNVFERDNKVitGQVJ6V2RIN0I5dkdRMEFW?=
 =?utf-8?B?NkdvUzhlYzNhNXlxRmVybHdvVzlVdVBzUndBK2tQWWkvaWxuRm90SUFncHd4?=
 =?utf-8?B?NERoZkNuNGRMNWFEbSt6NUFCMWJyTVhZYW1HYjRZNlNTNXg2aWNWUk0xZ0pH?=
 =?utf-8?Q?LAAa2y4V4QSzpBamAw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e141dcc-bcb6-48c3-885e-08df12074795
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:18.5960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgsqaK9blfXpEKBITE3Yv3YykxiOd7N2lO5NWEWmuN3FouKxbmyLlw1/K5q5Sxux
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1AEBE120006
X-Stat-Signature: 4h4w15zzgi8i6w4gf467z56u86aexwhj
X-HE-Tag: 1789352672-927416
X-HE-Meta: U2FsdGVkX1+8+SAyq8sCcew0EZk1/gGQollYfBqwxbHsustF7hxayQ0SP0PmoH7eskyQvXBh6bJpFD7AjseEZGADnqxGKks3j4pAjE6/35feyGWAnPhZXBdGwij8hROfkEr9ZtZRley7MZqFmstKjFekVrKLNKfOO2sMV5OpQo91JMNmy64m8EuULncPBnkMq9UBTAqkoBUsA2VQwJ1r4mVUhkxPOvJV4zKS4sCsrK5QtPqFyVGXQG2Vt862hwY8UTdl0NQ4tB15GU5NWzYWN8wCXcY4dovUXgydQKlXk84rZfUc1kphpQnL3P4vor9buFdUh0N/9MiQMgkhLH0HApbDkQrYZjd+3NQql9hCiryV2p3Sfb4bi+ecnFSyRTBrVcuPsJEEOnykkeiTqVDvEKywnKk3rbGoB6JrB2ofg29rZ3iUbXSCSxQqJ+rgNoIV2hsIPb+Ub6Qw84darVUwY4beK3OuHqodx4EtPfA1GOLzURjXWWCFsx61eJK38dhs1BN7TZsBOzPDgH60A/WiCCAKyLviUtJ6RASEowTt4MjmaAjjX7EGZjFNvIKOHxN9eyl9sDgCnyWZrzrJZQEnCHBSHSok70M3UXIuIcZZNRwuFZXHgvnytvRaNPO+ZWMHIdagBDkAZA4iSZrjDIrAzZV08TIBX45xhL7XGzYycJyi/vMITCW1VPf6bqOr/9RYaOT3FqRV9R7w4YnZmeTacyuum0RJWOvllB+JmCV886qOeVnMRELx0vQdbx8/HKQLGdEXaoteRD+rKYv/+tPp5IZt3lFOjLFFjXBqrEsJfislnE/CboytkTFLAz7YozM5SxfBK0k6T6bQ7rsi29bbQ+T1abW7z+VdT/qMpAc4US3EF6AHozK52iD7Pml0IfE2habt8FhxcIA8u1pIRJrby9UcXjJKumForLaQ/x9EOrTVxmm/WevcPMBKrzFrlZNDtmn/1J1y3fK9SjgioTG
 I7DMJKmK
 fKDxQAkfFm5oOOk1dqv4ptI70mQ2TG8N5HGDZqadszgVd6acGuwSUwVxFrPJdmrBSiZJG9S7HCnnT/pabD20TBW3vTG6IHVlgP5kxxHd/vArDB5fya7RKCtfp1DnQgETAJyG7L5R0D+aqARwUoqR2RhLXmhIXDiT+vPHYKIuGlvnB350l84WL0oEOCMXq3SmlwIQ3F6WFc0PygzqyVEenc3rdfzdu0Tc+A/sVQTo5faovKB6qbN/x/gjGacK6DYphdTZS+5RiT0vRZVvxaiI2tadEdW+aWZGvdDqdd6bIPtIBMleBrfi1z8V+mMUQ+gcFr0ZwHESlV3zet6h85oYrSYRDxpqqZFXN1fkcYkTgY1KhHyZXg3OkZmYz+uhVBaiN8D6QuXtrEO//XnD7zTmZDdg0doMkMTksD4qkeNDoGDIYvdyO0vHdiV2A4ZARn5xfamO/gdez1wapNYKHWhYAa2BLGvCxoLLrvlQowuJ37RhkZ8YaO88TGUtDjUUw0OwkSnFKTb8vJdvLx+Lr/bcVE+vQ8IYOHhwKfwgKx/wb7QH3OUZyz5aSnqNa5uBZnjaGAMGwi7p7vaA3vM1ie5rHz4qs+Iuhp4rszbeKxRh6hiCHwjrraOz5vf2d/t3Fq3jgE1wUXt7VZbsul2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_change_private() should be used along with folio_attach_private() and
folio_detach_private(), where adding and remove ->private content requires
folio refcount change. add_hugetlb_folio() simply sets folio->private to
NULL without refcount manipulation. Change it to direct assignment to avoid
semantic confusion.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/hugetlb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d3a0650ff6905..8d551cdaef9db 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	folio_change_private(folio, NULL);
-	/*
-	 * We have to set hugetlb_vmemmap_optimized again as above
-	 * folio_change_private(folio, NULL) cleared it.
-	 */
+	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
+	folio->private = NULL;
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);

-- 
2.53.0


