Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F20C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 10:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBFB8E006A; Thu, 24 Jul 2025 06:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3638E0051; Thu, 24 Jul 2025 06:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292AF8E006A; Thu, 24 Jul 2025 06:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 155908E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:01:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92A63131877
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:01:50 +0000 (UTC)
X-FDA: 83698716780.13.ED3C205
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012008.outbound.protection.outlook.com [40.107.75.8])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EA98C0014
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:01:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=ELleoyH0;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf22.hostedemail.com: domain of link@vivo.com designates 40.107.75.8 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753351307; a=rsa-sha256;
	cv=pass;
	b=EzF2TRdj5+s4jKUNbe5lQBkHFfB2qXYmz4cygoqM6iqLxcgKhZ3E+EJ3n+Izdy1sMNgDCu
	8jHnbjsPXZjORt7lxMOCMfTG2sSyQdsFaeHpTX8Z1701kLMqTjLrJb5WHJn2TtwcfKnxzZ
	JFkFV8tS7SlVmw+8RaBUYaN6D4R8k8I=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=ELleoyH0;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf22.hostedemail.com: domain of link@vivo.com designates 40.107.75.8 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753351307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3C9R4jl3GsCdZu295tvsEcCGkD7WiHsUqV/cbDeyHw=;
	b=rU6o9FBPF2BVQlSv2fVg2bFFKKp74LCEZSAyg+imEXYpXzCqXEXRUeWX7zjXFwdQDRcDa4
	P3haogav2qk+wSC0IfilGOYbCfeWmxZ8QDH+k348eWzeciW1UvWaNBynNN64PBOMeEX+Jm
	jIPibk5IX3/JaquJEsca22IUHu2OHB4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qyn5ddpVpCZWGbyMHRm2Rk+6oOqTGnQ2VK+kLMMczo8rYGDzqfoL1aPueyuOT2LNb9wrj7iILNQSPe6kT8a8n3OUOQpo5uuPr8tjFGmkd3p0GKJQK7/9oVzX0gxPoEho5lixODu1ZwEnWBuZmFb/xnpGnP1xleT/MHKFP42rmfNcrXbxrdAz377GNICktm6o+fQ6GkmN2lXgx14NjoSvy+Q4QJJYUqkiqhvXmi/1ni4N/IMVDzXyvwKTkmRrTa0mFrfehhTHAtK95GFX/4/PRbtPCtAIjZGtLwm7PPCQR8B1imRJzTKLIKlJ566wGhD4oo44ugm5LqjbynxaD+Gsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3C9R4jl3GsCdZu295tvsEcCGkD7WiHsUqV/cbDeyHw=;
 b=IOYnw0FJnnUqv1Laeb/x5BJ4dQNpWoYyZoCpknN8JGEnoKv5y5yCfiMwdXtWvakMnhJObBfhgRsrUT3Aimuu/iRGxqHt6nFYwHFOCQCDWy4NhNe7qcV6LpWXEG0oRjC7NHXrCl2tyyEjSl+vyC5Pth7SlmkAvK8J2s6l1dR7xcwtjFoVlH3tSb/y6MgMEGnMvQo/HX0mufq0CcM5gbZ6yy5Kj8P7jkbT2a9utTIor6cUKabAapNDNPugRi3lONoszrhTINslz0QPqK4MuM1FiUZI/osV4TdvEg5D1n5TFtLBF0f57Opv0mEvr1t8asbbVZa5tJ3rTJ7x+5CZi2TuGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3C9R4jl3GsCdZu295tvsEcCGkD7WiHsUqV/cbDeyHw=;
 b=ELleoyH0p+gsOmNunCnyevsi6Wc6yjtzedxrw7Xq2sbbWM9pWe2s+PQ7J1GcwBdR4QatPb9AtAr+zU90bqBIdRhrhbSYFljdWOI2B/yBreW5GOjXKNKuWOdWwJvqlkXhYoIgghS2vwZ54k96LZde3u2JvWIajBjk6+BLeYQQl4IGIJMrvDBxyK1nmmD+FF9ebMO3RwLoNW8NnUKS2uO0UDaKym8TNTl9CZYuXMKWiwxMIz19HQMMyFnIrXfp5/dJ9J7IXsnHgg9jnAGrq6soYWrCydWQGrDu3Oq2jyM8akg+oQh5QpNL7WmVwprqxuH6OGtSfIphT5F7MkAUObjpKw==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by TYZPR06MB6022.apcprd06.prod.outlook.com (2603:1096:400:340::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 10:01:41 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 10:01:41 +0000
Message-ID: <4917880f-df55-4c5e-af06-95b408021b71@vivo.com>
Date: Thu, 24 Jul 2025 18:01:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
 <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
 <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
 <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
 <23b986e2-80d6-432f-8188-7a11d6915c9f@redhat.com>
 <cd253bcb-3ffa-4871-ae11-59d158fafada@vivo.com>
 <f21b75f9-0650-44c2-bf47-516390364a8b@lucifer.local>
 <10484264-e863-46e9-9797-d2d76a531557@vivo.com>
 <a7f8b628-14f0-49ae-bf71-14c4a3f4fd89@lucifer.local>
From: Huan Yang <link@vivo.com>
In-Reply-To: <a7f8b628-14f0-49ae-bf71-14c4a3f4fd89@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|TYZPR06MB6022:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f13eb4e-63e9-4dbf-7fb8-08ddca9916ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vi9iV1hOOTNmTGI0ZDhLeWJGL0hUTzZGTUFGZ1NEQ0JCcUp2M0xFYW16M3J6?=
 =?utf-8?B?ejBwOHByZ3lkbExHeW5PdUxTRHZ6Wi9RL2FodVgrYjc3bWdtN0hvNUVFMWZk?=
 =?utf-8?B?RktJNWVLMGI1Z2F4WGxGVmdSbmdqTXBTd3luRjFuall1Q2p6UkpnaTU5TENm?=
 =?utf-8?B?d3hyL0hPSU9PVWNraCs5endhY0puUWgxRk1KMGlITTZ4c00rcjFUNW1CODRP?=
 =?utf-8?B?UGhLM2x1TW5WQldjdVpPZlgxRDhHeTltRXVNNzJzK3Uvais5V1lvSFFmbEFP?=
 =?utf-8?B?dWNsR3pVZUJKeTc2RFp4aVlRYU9DWExNTTdIZjU3SG5PRUJQSFpmZXJFTW9u?=
 =?utf-8?B?YVhqSmMzK2tndTZUUVIybWVOM2RtMXF1ZFJpb1NNenpGTTZ3TjV2a0JjMUR2?=
 =?utf-8?B?M3duQ1pSeHI2N0tSVVZ0Sm1ZRHVRQlhKbC8yYUlDOXZqSDJMaEJxRm9Jb0FS?=
 =?utf-8?B?YlBUY2V1bktqKyt3YldFdU96YndDL296ekN4b3VTQjN0anpuVzRpT2J2RDVm?=
 =?utf-8?B?K0ZiakdXQ01QV0w2d3JlMXl5RGpaZnBXb0xCQ2hHM2t3VG5LMEtHcU9hbEJS?=
 =?utf-8?B?aUc3a1BYN2xzdytkZDVMWGI2MTJxYnlGOGczWXRsMGRyK2ZaeExlcHJIaDAz?=
 =?utf-8?B?dzBDZzI5QTAzQTJ1YmNSOENjSnE4ekVsNVZLVzNCVFFRclZQcW04UllBTG1L?=
 =?utf-8?B?UUtzaFFRaGkzMVlwZmhoZUFOUUthd2lXUEdBbEZHaFlON3hwWmpSYXZFOWdT?=
 =?utf-8?B?TFRaaWFYRW9sb2RxSDVIKzFmYTIrVzhWTi9UU3MvVFhkV3hRNHNpa1hPOXFV?=
 =?utf-8?B?Mmp5Qy94Q1B3eEVsZEJ0a01RODVqVGJEaFM4aXhWbnB3MVdlQVR0bytCY2lx?=
 =?utf-8?B?MW90L0t0dVZWM3dOcVVuL1J0Zll1R1phNGJHcU0yejhBTmFRT1NEeHRINms0?=
 =?utf-8?B?clZpUG0xS1dMaGV2WE1TY0ZsMDEzUWtwdk9tUFVYRlhtSnRJZmFiWU9Uc1pP?=
 =?utf-8?B?QWlCMFMvQko3U2hTUFVZSVdLY2JjMzYvYlJ5RVNQc1gvTytaNVVWdHJURVdS?=
 =?utf-8?B?em54UmZnVTF0WXFCWVo0YWRBS1Y2NUtwYjhjeFE1empvb0o2YlAreHAwRjBT?=
 =?utf-8?B?aU1jOXZjblhMUjBkeDc0Y3p5VWNscXdMN21ubFJiRGIxN01xQWpST1BRMDlT?=
 =?utf-8?B?ZjZLa3pVaElSbDR1VnlCaDdXLzFGL0RGUk5XMm44QXRwRkVFcTIyWGxlSStH?=
 =?utf-8?B?M00wRWVmbXVjVkE3WFh1bm16akpJY0xJclZrSVdNZFpjOUpMdEp5STVRRENJ?=
 =?utf-8?B?SUVwR2h2SXhjMnd4Nis5Njc4Vk94T2JxWUluenErUGw5MERHRXFrNmF5S3ZK?=
 =?utf-8?B?VjBLd3RGczFYNmZPN2ZtcW14MWhhMlFoNlA1bzNBQU42K0xhaVlpeWlyZnB4?=
 =?utf-8?B?R0prTExVcjRDbW9uRk1oeWJDQytOTTZ2SjNSTVhpVjVGRXJjNmFFakU4N2lx?=
 =?utf-8?B?c25EanZLQkU5d2Nsa05BRkpTTlRpbS9EQ0tSdEdWcGgzMlVHOWJIYStNczJ1?=
 =?utf-8?B?VWo1WnNtemdDQ3E2akxNT0RQUUdWS24xblpwWjdqQlR1eCtXSm53b2c0MmNT?=
 =?utf-8?B?L29RbDNjRlRHRWFvZjRxNlgrWU9FL3d6MytldUdNOUdOdDFaaHI4WU1za3dK?=
 =?utf-8?B?bFgzbEp6UmU5czhuays0NElJbG41Z1pnQUxOb2lMY09oWG1ncllDT0JpWTE2?=
 =?utf-8?B?TlFNenFIdkJCejZWQlJmQTJidkdqem0rMWJENTB1TjNZM1NadnBML0Npc0gr?=
 =?utf-8?B?cUpUU0xpSmhWMEFyZytVa3VaVEFpVHM4ZTE4OHVabE1EOFJudXQyZGo5bEYz?=
 =?utf-8?B?ZWQ3UTVEdkJlYVduNzN1ZFpvU0hGQXlHc2J2dTBTOGg1ZTZSa05QdkFpVHFD?=
 =?utf-8?B?V25idkZtSFlVR1drMzdoaUJqRzZNMzJraWFCeHkvTkExWFVzblFwZEFaNVo3?=
 =?utf-8?Q?9S9MF/v3FhBP2W8eBi6mgsqnipRU38=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEJNOTN0Tzdrdjg5dEhHWDV5Zm1KUTBtMjNHTjk5dFg4WUxSeWVISm9JaVA3?=
 =?utf-8?B?NGZ1U2JpTXF3djY2WWJVRUt3NDN5MGxSeTRIeEZLejBFVDNoMkViL3A2dmJI?=
 =?utf-8?B?SmdIVURFUnZyTHRZUHo3MkhLWkxLdnJuSnV1OEZxanhKdEdLZjNJZHdKRDhw?=
 =?utf-8?B?T3JEVTdHbG5Rd2g4b0Z6TWthT3ZlNnBpS2VYam1zQ0hITE1rcVpOc0V0eklR?=
 =?utf-8?B?RWFsSFRMdENwMkR3SHltbzk5cmhYTDdZdTFrWFhTSkJzWk81b0ltTGM1dmk4?=
 =?utf-8?B?YjhPeFlzRVZCWXhad3I3UVBjSVd1c2RncnZZMkpPbzUwTGZId00zSXNLY1Q0?=
 =?utf-8?B?a080Um5obGp1K2lrRzB6cUJ5ZTMzM0krc0g1MDlaK0Yrdy9iWm9pblh4U3hn?=
 =?utf-8?B?TGsrWlJ4UmVXczhKL3VwMGF0RG93VnZpei9QaWhySHIwRS9CNTVyc1pnRWJm?=
 =?utf-8?B?d2xoT0ZIK0JrMVhkSUNaM2szQmNuMXdSL3FDY1dQUmpVSVZ1TGZnc0svZld6?=
 =?utf-8?B?b2R4ZWtDZnVzZ0pYWEh5bmd5ek81V2hmY240ZUJkdS9tc0pIdjFpbmtzcmVX?=
 =?utf-8?B?QjFFRzlRbkVOWlVLb2pFOWlLUk1FbHdJcW94SUxvM0I4ZVhKRnZEaUdjNEsy?=
 =?utf-8?B?ckFERFdEY2drNStRUXd6aklvQnQycmVZUGgzeWtreTRGUnZIcDVrODhMNzdt?=
 =?utf-8?B?SzZGYTJCNExzSThpRXIwUVlWQkJpR3hsaUVqeXd0V1FBTktjREVXb1g5RitY?=
 =?utf-8?B?L1hmYzJnQUhjZ3ppV0t2N1MvZXVXalF3Z0pOcFpuaS9kTHhMY24rQXVqVysz?=
 =?utf-8?B?M0wwdE9XbGxZeU1GZTRHdFg5b2VtTFpkZVUzWlEzZ0hZenRXYklvUzIwWkhx?=
 =?utf-8?B?TWdobUdlTHNmaC9TVmNkTElieE1uYm5GZ2VWTGF4eXAxRURGdEdhMlpLOFAw?=
 =?utf-8?B?U0ZIcmZOVHFPSXNLYXR4MG0yaVVuQjJiTkUwRnM0Z3FwRkNnY0kzV1dmQ2RI?=
 =?utf-8?B?S2pUbVdLeWZid2RYajhEYU80Sk4vY2NqMWl1VmdzTVJ4c3pzZHFoWXZvZEVK?=
 =?utf-8?B?S2kxTTkzZ1RmMThqVU00eGtXTFNvT0lkODQrZE1TMUJiM0kvcDdmemowSXFT?=
 =?utf-8?B?cXl3UU05SFZrSFhhREM4VElTbnF6OVBHbzlIME5TeEtNTjdkaUs1a2laTzAx?=
 =?utf-8?B?RGZXLzlBRmRMTXB4akRJVHJWSVlBdkIyUGpZRVVjb29YRCtjR3UzYW1nWk1P?=
 =?utf-8?B?VGFFaE0rMm9TVS81WEpqUUU1bjl5SnRVSy82bkg3Z1paV2pjK2VDUDMrSFlW?=
 =?utf-8?B?bnBWK09FK1BzamVBamtGYnJvSmdkb2NsendwbDZtMHB3bC9xM0ZnQVFDZWlV?=
 =?utf-8?B?OFBNNkcxMFlFV1E2ajBtRmV5MVhWMTZXVXgvMktNa0NwbitES1o0MUtiV1ZY?=
 =?utf-8?B?L2JobzFVWElHMlVrUkVkWlU0Q2RxbGU4dUxsUStPOEFEVERtQTlkOGpaTkRm?=
 =?utf-8?B?ZGNiM3diUDhkNHk2ZDltZ0pNYlRwNDlWNzJVSVJ0SWVYZWdpUHFmYzAvbEZn?=
 =?utf-8?B?U0E4eW80eW81YWVMZm1FWHdIQ2NPallVSXFoOHAvZjVVSHVKaTdPK2dZL21E?=
 =?utf-8?B?amlERTRGUWlnWFo4OWNudFhXNjVXS3ZJaGFaYUxCNmg5bU9IS28wUlREZ1dC?=
 =?utf-8?B?eFZHKzA1dzQ2VHJzcHo4NmU5VDJRTWJ3VjZlWGMvOXJ3OU9DTzNuOWtrNC81?=
 =?utf-8?B?Q1NYNTFsRndPSjBTaEIrb2xzUVNUV1FyaGxma0xaRmloeVFOOEdxVS80cm5z?=
 =?utf-8?B?TFhvenlkZjdWUzFLb2E1K1k1eFN2QzdkeHZMaGk2blBJc1FOYy9ucFpWT3pG?=
 =?utf-8?B?V2d0NjJkV1dtV1FrNTBLOXRMVTVkUjR4eXA5ZUdHbDZ4T1IzeXlzb2IyeVgy?=
 =?utf-8?B?NkJjbnYxOVB6SXhPY001UTNLUEhNWEFUVk4reVpZRmRhdUl1eUUrVXk1Um9Y?=
 =?utf-8?B?ZWtOYTY1VkVkVXVkVk5nSTdlUnZFejdQZFdtV3Qxc3ZhS1NhZ2hUMGlIaHNk?=
 =?utf-8?B?enBVUXdvVzhlZzYybUZjTkI1TEszMGs4bGZIeVI0WnBkazYzQXZkMFVtL0J3?=
 =?utf-8?Q?GpJbUfY2/T19vpNp86BoZN4aB?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f13eb4e-63e9-4dbf-7fb8-08ddca9916ac
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 10:01:41.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spMd5hH4x7xpgh7BD2rQkqqcxDpIu7SC8cG5pj6oeGF8GMKp9j15ZkH+cFjZEwQ+meWE45kN9M389WpfSGUHgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6022
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9EA98C0014
X-Stat-Signature: 8gktuwpfgf7mij9kkpezd8ig9tsqcc3t
X-HE-Tag: 1753351307-968945
X-HE-Meta: U2FsdGVkX1/54ASwWQJqJV1z1DvgPPA/fJsWWNxr094LGUz3Qf+3hIQlf98G0mjo/rmC3pu1WWEIfAL86KNTmdGz64PiChxrmxWBv9yhPYiItUNeYvx/QrFk+iSgWwuNdEXHBzBFhsHEhV/7UAHMHX88pz2VwjVITlmo8UUUW0MILnXHyjFMfi01n6Kw9ohm2EDBgcTq8W14ejn945Cblb/ma0+09m9kzxsfh2f3wRWqRDSgVdKcsvyOSFhx08xx3YZjwMd3HwKJeac+ruANlzCiMZ97/V3Kj5wd4DgdUTXWW5xPkcRqYV4XlkfEqcruIv3u7Jn2E/zTdXEP1Sf6xy3MNkMzBe8o1H1nFCfKymivmTifnovKlKVEJdwKZvJp0ARaAWLCdyiIsNtfmy492pEIDTkY+N4RJf+fgnlyewv9fUkG4cmYD0puyUiisDe3vtnupWrcu6FTfSiVm7Tjll3H3XjNHrafz4Jqaqc2TQ81D8A1cAE8YmBKqAHVw9CJ4h2A8Vmo6auvmKgmIgh/wZI6DMTbA1zBF9jYiljpubrWWY8mYkc+B7uhVIMWMJrlo3nwzzeQkPhEJUZoQQZUDk1s/WTlYoh78BL298ls3iwrZoOo+oqQnT9KvitAABdyQApakh425CG8/gJ67rZMarCHUaewUv0vINO7Hx2bVWga47f6kIt+NotzKmttIKUapCs4/kuozkaujLUg1FT0vHxvdnmotNdYf3Ww/lPUsLhR0NsV7iROiF/pW5dfyRlH9zvCjN5KTW28KGzTyD2YNcNNbmaDOU5774xrwScDpbc51q7uRyoF0AL3wnPvikgjK1dtXpXMJixSByxwmB0AswTzPxFhCpW+1lyS7x30TVX//SY0/H5oep1jlEpNFh0TvwWiMhEvaIyRU7RnM6otRC6x15iTp+2f9ohDv/YwjwWXdlPChXii+ldkjQQqOgfYT/XCmUZD4jyGTDf2NjT
 E6I5M1sv
 /u5y+E8Do2PYt450qXhyzIHdVNHuadf+ry9Oj9prM9thyhwCOzZwLrfgLsuWU4Ur/BMEO79BP0YD3W84fYomQN5pOMCRY8eMZrzvKfbvZX6MBt+VJa/GgFA/jQtlsPcfJivYhE5pSkcx0cjRW7qxvDMXVhJVkkLXaMmAHVxIC8deL2WNQ2nIOdU31lTQefQjErdrnyapgaNpkWvIF1u/nDyXfTmFeHRs6Z8T8adFUOA6erXi1lg1EqjIyn2HqiqRdnfJ6Y+Dm4kQMEzC4t/xc7tX/8dJFMwgWzX7osfogmxGRWOva4EqfduZNpELNc3OsB4aXf9HLQwa42zxgW7ak/OlzGC2qvrxCm01C8BVtDlAVqypkQoJIcl3ihBVlDOgI9VuBTKnNcmVQAAS5ZVHyK3njSFFaVZeqasWqdbmQDI5yfI/T5ABgVdK4DuiF2qOeV+kK4MzsJ3ZWpM4yxRE4nvPAAnZDY9Sf4OmkccC6g4k+lgYTClhMDa86AOVfS9pEDKT34wpwYmQthekeVm1oaU2GlR0tYv6QHFLW7+33W48XA7cJENMiPZ05Ex4xWIMkkr1QfgPW0XT0hwTNktvWwOaGIJkDeWWtmuQ8eLMALZulfSJgH3jbtAFP1UxPWowLqjGavQK/CBl15CGqkXDdy+emeAVEbeFT0Cbim9+PGsqw8CpWmzi7XHHSq8gghHPimZZMv5JsDKlGWk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/24 17:58, Lorenzo Stoakes 写道:
> On Thu, Jul 24, 2025 at 05:56:09PM +0800, Huan Yang wrote:
>> 在 2025/7/24 17:45, Lorenzo Stoakes 写道:
>>> Having looked at anon rmap in detail, I have come to think the only sensible way
>>> forward is something fairly bold.
>> Woo, that's really interesting. I'm looking forward to this.
> Haha thanks, I found the one person in the world who's excited by anon rmap :P
>
> Or rather, the only OTHER person ;)

Not only is this interesting, but the efficiency of anonymous page 
reclamation also frequently affects the performance of our products.

In our flame graphs, we can see that many anonymous page reverse mapping 
paths are among the hotspots.

Therefore, please continue your work—I’m really looking forward to the 
results.

Additionally, if there’s anything I can do to help, I’d be happy to 
participate.

Thanks.

>
> Cheers, Lorenzo
>

