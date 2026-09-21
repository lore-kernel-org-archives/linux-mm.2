Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02643C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D838F6B00C3; Sun, 20 Sep 2026 22:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5766B00E4; Sun, 20 Sep 2026 22:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B936B00E4; Sun, 20 Sep 2026 22:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 809DA6B00C3
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20DA11C2973
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:45 +0000 (UTC)
X-FDA: 85236186210.19.B1A40C3
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F76140007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nMS3g1zQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97eh6l6ca/PexFZAn/b073tcJjBasi3c+cVODHPaN4U=;
	b=Mzr4Z0AVuRvVBdl3Ewnf4tQDes5Tos+PElwl3JC7Ft8eKEAPCr/MqJV29UELHRXu66XTIZ
	RXOi7zr/liV0GlP3z6FfRsdoxeZlRfk63jWfKUUL5HSVKlAuOHeu7xFbo6+7pNZF5lXUkD
	snZZepWLLRQnItpcRdUt/ZQ5ausV5Eg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957722;
	b=7EBA8h8NU4MTItT/iDXMkvTdN0uPXo/Tgrs0ntc45cMuRlVDm4OjnoI5NzMH3vQm8fzzYT
	nVnqd00k2VdV05XPAZpZEsgg2MIBuHv9sb0rPmSbQ0Au8bbyluTFnkUypA45mza6X2YUI+
	Q87EjnYfhynI5b2tEHG6VD0vXr392no=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nMS3g1zQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxM5anxAK2KhXA7EARoBUwSkzgPh8hyWPN5Eh18kAnBfAtkLQTdjtzAqVurTSnTw5LgtikD2uiy8NHQDjM8H9lzDnxnHDcTStcK9gzlHMAu0+tEp5qaqZNKIXiyWgii6Wmz+Mt92r5ZO0uitG+Olmz6LHNIHaQNULrJyBdVbrHUePrMxdLWhk/jET9TEIjohmZTzF4WAkvl1vRXZSVFYCpuBFEb9LrXcgJZlFDqnEhC206Dwl4B6Hdk6nIRh8XMcStaq3cHMWb1piJvV0ery2VgSXMWikzrCGBl37SWJ6CJJ+4yvRZW9rujWLjQlPFc2wTF5y2rEJCSLZvjaa+GzkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97eh6l6ca/PexFZAn/b073tcJjBasi3c+cVODHPaN4U=;
 b=qgMOYFuxm7mOC5mjo8A34RHapWLJlkMv/PWg9dApYNzEdIXAsR9E0wnU13RapKJUhGaja+kAyq2G0pEBaqDZYBLfbb72Zn68vgE16XkJH0s1CAJdT2Eybx8tiZ0Qn+tmfFjoDIYxHRxaZQof54ih3RceCINViWKAyewjM5fyYuG8OcRNh5rDrj2ysgRjgAmPORCqn0FzWbbEd58BiXgmlMrbGTfs8ZCKBxHDxz80jMgq04/5KnJIg+P5EJ5Sy5hpCdlknm0C0BqKuA3ISiuCmff9pIE83dpLn6XIz6alinM+oEJSyJw3Bz8/CfSEt/IPtD/92dLDNU+Hw3BkkO36rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97eh6l6ca/PexFZAn/b073tcJjBasi3c+cVODHPaN4U=;
 b=nMS3g1zQ6bJ3BzcLLgFxXfU1EnR7Zrfwc+g2jhCKou+PDNltufVDhtvR0ImuzLAhPwp8a7YHv5fv+KAEALah8Nkx4snS5QA5yCk/3QMTdbKemPq14GWpvIMNSowSnSfXgT42veb+WvDXdpUMY9kKUlxUyGBD0Y7/PJWv7aEpkEWt8hc8Crimry/qNWuMkJYM0C6qOf2WS0i9FqRHP3NF2RRnK1spJ6bZt36XHqjiihl4C0OhYMDZ/gAmGnf7aByeBJKfOxNP7Y56qYwy9ZnIAZa4fclX/HlBjDqEQ9BWPlBQRBmh/3fKgb/MQ4V505zP5ivpuc9KORaa+iVTQch6fA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:25 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:01 -0400
Subject: [PATCH v5 05/17] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-5-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
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
X-ClientProxiedBy: BLAP220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b42c40c-a04e-4220-6a05-08df178803bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Vxez3A1L6u3eP075yRyU4lHAIdv7D23z8uVwqUcbdw9Mlk3j/oviLss7UOrms0EKv7ZnT5iACjU2yOj2keGwKjAX6znG7IcAaNGiG3uxvloEfKiz80zr4JvL6BgDHeYvZRJbQi2YWrI8ddMGGKvZCyHxZfxDcqRvP4XIVAVSWw2n8X+3LG/P1GflRRNWIk4LCZmvO/SxWk09UaMp7St7RXGcNwRE+pAZP+5YDxQSVzf+eAyTvRfAcIjpnpODARG9LABQDyMxbTfr2PTzLZmQWslAcLoOHp6o1DmPI26lpvlBK1wlSPQOhz0cz3q+NEAFaJ4XeEeVwduQZ5DJhxO5EBwt8fQlJJCp5sMPps5S5LokfDTl2XqJyIrHHoXJjRyZt4wAZdg1LXOJEfgxZGsqh84zg0BKLQaLywOX6qIUJ9pBoJ2lSIvTwc1AqRQZbAwMHTPzPvxDHk/3kzyPxQnvxahB0K1OXjTHX4H+f7r0ZMFD8P5SAxczjalyhbDAnGibcxZhronu0FByiBECnoPkeTyYCUZSB3TC8e+/bD96YdwXWnV7PpzbD6JdanhsKgOBtw5TYrVk3woJHyqTvXB8iC1cldwHWAmZTNDFItYBEdlHq0rt/C1xavWFOUpeEDEGA3gSKu0JPrLLGCD+SZx6sPNcCJCGQFQCglPEY2XqSVWhtUM/z3WBSmRS6dL7Gk3q85f1vsv8IqMTBaUxgMkzuQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmFWbHV3bGNlV0JndXpURDFmY0ZzY1VBdmNWRmdmenk5cEU3T05uczJvcWtu?=
 =?utf-8?B?bEJkbS9oc0w4Ulh2WnRwbXZaS0RjVXRnUDlDUGtvaFhZUWczM2FaeXBiMkhN?=
 =?utf-8?B?SWQwSW9PMjh5Z08zeHhZeFR2d2lCdllXQTVndmFqNURsdzBrYmZ4QTNuZ3BL?=
 =?utf-8?B?ME5vKy9qakFSSGVReC83RlFuRVhJc3FFUmMrdEdGamVTbWJqMG9HUzN6NUk1?=
 =?utf-8?B?R09SR0Q0bXF0TkVnWlZ3dytkSGptVTc2L1ZFUUJDVVoxaGdodnN3OEt0VEVC?=
 =?utf-8?B?bTdjc015Sy9BWWpsL1doTU4yUERBbUJVWEVYR0RNOHBPSFFLNXFRMTZLaUZn?=
 =?utf-8?B?OFdwcUFhS01Pdnc5b3J0STNuWTlxOVk0VGlQY2VQaUNvU3hzK3FmZWs3R0Q2?=
 =?utf-8?B?L2ZoTi9uWWRYZU5nMkNNTDFmMU9JdlBOL1BPM3FScEo3dnMxZnNKRVI0Kzdh?=
 =?utf-8?B?dVJmd1BuTTNZbTZJSzJkRUJtaDhEQVN6QkNjS1N6MThvbnJpVTY4MDUzckFQ?=
 =?utf-8?B?bGpyKzNWakhFczNZSnYzQjNEcVJuc0VvcWNVdFJWZkJCTmRhMW9wYTZMcFg4?=
 =?utf-8?B?dkNrZ05Uay9YbnhINDRNaWtIclpiTmpOZVY3UVVvOHNYeE9XWThZT0VKTWor?=
 =?utf-8?B?ckZjYkZRY0E3M0RvREdSaThlVGprMHQ2TlZqWCtFcGtlVi94aTBVbTNoUDlV?=
 =?utf-8?B?ZzBlUkQwMlA4anhoSWRLYTZPcGY4aFhBa2t1QmsvS3h4T1pNc1Q2bWpzZTFR?=
 =?utf-8?B?dTJVZEYrT21vb2lpUy9VNERodjFudlVUS3FaNWxIcURBcGFXSVlJdExGMkRu?=
 =?utf-8?B?NXB4Uy9TZDlLS1YrcWxaZDBYclBMV3NHVTFzaXRrKzB6bHFrWnpXS2x3eWFE?=
 =?utf-8?B?RWpGRXRPL284bklCQ2pQWWNua3h1a2VDU1Zaa3FrK1MyQ3ZXSHNmamphUjY3?=
 =?utf-8?B?eE1ZdEpHb0tOc0sycjhJbFdpakVZc081TmFJa3pEVVRKL1I2UE5ySlZCZE9z?=
 =?utf-8?B?UFQ3RmFpRFdUdlo5ZEhFSzR5VDROWlRaVkUxaWxtZmpRbUFxMU9oZzY2N1lE?=
 =?utf-8?B?R1BIK0lGSTZGYnVwUGxzVWt2YzluSmdMWlU2ejJ1YXVVR0hTK1BlNkdYTUpy?=
 =?utf-8?B?RFlKaFU2VnNMM0ZJU2FadFlMYzZvTnBZOTh3eGs3K0g3K3VVcEFJVXE5MHJk?=
 =?utf-8?B?RDUveFduQzBUc1UvTTdMdTJ0UUFaVXE2alFaMVJDTkhrSGtRbU5rV21mSTdo?=
 =?utf-8?B?cWhvOENZZVRRb0pqY051SXhiZENPUWg3NXVsQ0Q0UXJSR3c3R2xiczhVSHJk?=
 =?utf-8?B?ZENoWENKZ29zTzlyUWxjaElyVktTelZpZGU5WTFFd3R4aUsrS1RuRXVaWDRD?=
 =?utf-8?B?UmlDQ0hoRENwRFZFZVl6M1k3Zk02c0RYTW10STR3RjZ3WStxTU5Gc1dBL3Vq?=
 =?utf-8?B?ZGVuTGIrSjBXUmZaNmp5UkNvNk9ITUVaQUtRTi9TVTdlVmUzWDdzUjJIcXJG?=
 =?utf-8?B?Q1RCdXRFMFlmd2xXRG5KdG4raytsR3dpSG5heXBUdENrazJLc3FUTzUzeXVD?=
 =?utf-8?B?WGs2ZnludEdrd1g2am1NdHplT3pCdjZYRE4wclNEbnFHWlRvekwvZ2R1cmRs?=
 =?utf-8?B?Tm5DV2VzOXpSb1I1NjZWR2RTVnYxNTNha3Bub29BZ0s4Tm9zbDhFRGsyZmNP?=
 =?utf-8?B?cS95VzEyMnNNT0NucmNpaUw0M1U1ZG9UN0JxdFVhSFllNzJQendBbVBLT0w3?=
 =?utf-8?B?cEFLYXh4dmdjS3h3bndlajk0c2xaWVV6NXFFSDJPb0JXQWMxbm9Uc2FxRVZL?=
 =?utf-8?B?emVTWlBHSzA0cm1PWmFQSjdPQ3ZFa2NFSEpvOUV2SDNvTU10MTR1ZGtlajIv?=
 =?utf-8?B?ZHBhRUx1ZTRPYkN6dTQyMDAwZnh1NjhMOUlSSnhmU0tNNWcvZmtmMlI4ajJ0?=
 =?utf-8?B?SDJxSHFTaUM4d1lid3ptRTdqMjhuRERNY0NzQnlYYlVWM0RUQnIwTXF3M29S?=
 =?utf-8?B?ajYrQUlOcEVOOVlqUzVQSmM2M2V1SzZzUWFUdEhkcCtYRnNoQXBuY1lVVzVZ?=
 =?utf-8?B?NXdrVGJZOHQ3K0EzVGtaWSs4RFhGaVBqQkVCaFhsY1ZZelBpUDNGbWZsV0NP?=
 =?utf-8?B?VHV4QnQwcXg5dUgxZFFzMzdkRHdYaFU4eTZUdjJyOHNtTGdiYWZaU3ZUZThu?=
 =?utf-8?B?RnIwaXhIeit1UDRvYXY5M1E0c213SnBFbTM4SHcrVnh4c2lKeXpsUTgyOVVB?=
 =?utf-8?B?TFc1ZVB6ZmFxcVpqa3VtOCtEUWtWd0d4cTl0OWN5M2l2eEtIejR5c1F0WEhL?=
 =?utf-8?Q?XlTvHV93WoTfPhaZRF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b42c40c-a04e-4220-6a05-08df178803bb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:25.7081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aoyc3uThrgPBHCmaZSWhS1Oa7lpHpL/qk50BqEa5v2wuvXyJAwswaHmj9FVHVNjm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F76140007
X-Stat-Signature: ioafgtz1xzg8mooc1f3idud3fcx8fbnu
X-HE-Tag: 1789957722-844615
X-HE-Meta: U2FsdGVkX19Z2PhqC1b1gSM4wUr83ppFPiRtN4C/bbp8hNozV3JQqApE/0Xs2juzlG6wk8rsSXr4cwKxdHQlEe0g7FCsmhOV55ejtMs6rHvvq4fSNOF6Wv9ALSDEhIYUkm3CzmPJyjwPf+8sXpcguunmOEB68RWg4qkHSoRoTSqm98DLVIPYvQaeR3v+68+HVlsYaL1sVl0e1Cm1LJWXlDXj/IKazmLQIKqBNIIg8ef99q9d3O8m5x4xOoi7TKcUn9YPXu8XeFGOjX8UQ5kwJ/QUp5Bb37lsmgAs5nDrldaPlftsSvIXZig3im3t1s+hmWkDAItDFLkj1BUHhA6xoMXHIo8iuN9DyCdYtGc7Fihrtq9vx7IIOZOZ/28N0lcyKfdp0uX6EyA2OhVLKfIK+tzQZ55+HYr3ikI8X6GcUAMHeo4gnEliNOeSrNIOYdp1RSS2b2I7BD2FVTIHutxozzlZLGkmVMAAmvsuzGjjiedx6woz1AfI5mk1DDxoTJKowovxnnBoIvVN2BKDzZgBvbjPWhlqYxy4dJ/ooCfnAt4WMkhkfkl9iXstz1I5v+NcPOhzURZoUOF5005Td/yTq39IXh3OsNIme628U9VbATiPJVsQzcz2767XInyWEiO72gjWYbnUJbYxE12vaDLrcYrXo8dP13CaXH8qNg3NFTAUXplaODTVts+AuyWQogvuxlo+mFEC51Pie/ROkkd3sdanZJLNvq/T/vc7AvTm+QbZ77CaX2YrYXrFeXL/+H6NrlJT9isl7dKSdgp58+9FmcJSdWgUr3+0cJYe4KBAsV3HMKEBwl9u4KK+4luQ1OYcPYMBKAKBjKJrOKxHWg66axP1WDUx4LxOzyOhAo/bmX5iCO5EMQ/KEHcyoik6+7Sv98FY5FJULwER7JOYbZ95Wcxu75F+G3WKki+wcORFa7zBP07amO6IAEsNwRzgHO+bXFPgYldpxZ/plc1vFgf
 hxsLoxtY
 BiteI2BfLm8Cq9v521E1Bm4EFtzGxXi0E77qReAJRk0gzmRx8l80Y/kADL4FZkwjQm6GBJKv6PJY54ziLLESYjJoKxBY4VH9J3jU0f6iYPv2F93ZZccxsJ3vFMDmtWA4xxvw0+KM2Z3q3goJgV1c0El+YR/1RgzU+8NmdJjaPnBjVlacXIu7R7rr9d5Rkyvda6or/yzCjCuITSmZsFKPB/x0+a6PtK2LdMhR9kN/d9r3JTT/n/kYDlL/qKHpgBfpfb7CE/LCLqvmRK6VjVw2VPe3QHlHOsOGIjoebdfs1LINRJyRtAR4w47O6Buz5aTkcwEKrcqD8bSxuaulEMRH3g/5ucrjKGH6A94Xtj5geBOKQDXsDMxqiYfKNAcP3BLNcr62Noxt/8V4/jfBWpD/EOHO7EMY7BIDQvKx+628Eg6JCrrYyLTTvuLgXFBXHage60oK6IgMw2Cr365p7kbV+9ZTFvrAGRgMB6rebaCSlpmqrq6GPMLnuejktgpF1rPIXkr9pIsXguwSllWPaKZosnlNqcw3GgFLVGjssJZFLo78Qf2pg8vuLYjJL2yHrFPV8GInXXIN6mnGtxk+/swjM35oaha/zk9zYGd4Yi5Fsho09zIAq8itHMJQ7Yxqg6qqbC2jSvXJ5kMgSErE=
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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/hugetlb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2003439ea13c6..7b27c3c5c3e58 100644
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


