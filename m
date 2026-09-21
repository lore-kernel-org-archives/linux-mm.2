Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7CAC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08AF06B00DB; Sun, 20 Sep 2026 22:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1826B00DD; Sun, 20 Sep 2026 22:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81EB6B00DF; Sun, 20 Sep 2026 22:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A63E56B00DB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1155120558
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:33 +0000 (UTC)
X-FDA: 85236185706.22.79AEF04
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id D9E5B1C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GFrTE7qk;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957711;
	b=fVzMB1+fvfvSXzB7HQ/MQalzTH75/jc0Ax9QoyvF9odLCvywVrb8VILp2jG1I/KBzDxSBz
	C9+g9phkHgw04QA1sEKbKOLflgHLXJviZ7Q+wd4PBmrOkNdan0FXBGlqB0HIK5PNfZwQ5r
	r/enu1KdU/y/HzudNSlqeTF7/vtpNy0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GFrTE7qk;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpnw9Gpg4JeqTBKlcim2Ze+bj98VqYRU3sYXsAgbZDY=;
	b=e3/Bc/G1TI5MT/AXlW2+qrcsPaD6m9FIsm05XfuPyy1obMEgHZF0qe9RuDEpd+18kDMb6q
	4MAkVPEa5QuiGCsSOZZsrPJ6ZhhBEmGUpgVuaAZUrAZeK1PiBnan1oVhNUCcotHvEo4tAz
	X5DpjwS6h2uJCPDZ4ZbrqG6LM0ymNBM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ggs2EDfCGpVTrZsdLn6IJVsIs64rGg9TugBMz/gMx1ucU8ZC6QUYAhL0iJ7sRtlaUERIbyPEd6P0tl/739QONWJQbvisra+42J4mr5wq+TeVwL8zF8n6gld4u2DKEAO4+xuXt1oodci+fMhxjn8ef6KT9f9mrFeH3OU0/ujqTS3B4TqTrjj9sEM6IrxVCTuJnmX46cRWTTRymuBwl0KECR+QzN78BGLwIZfOeLec9KaVzTtDR2DTHHkEQZNGpylW0OjTCze60NTuZaOxK5/FsCHCrwKrtLvRTjn9ESi15JrjBQCLZuiDISiSPFWQwSd8hH3CzK06ooi8bYhWis0xhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpnw9Gpg4JeqTBKlcim2Ze+bj98VqYRU3sYXsAgbZDY=;
 b=vBIw5oGpHbF58ghKcykBM3/NH1T6rnXX8dEE6w9tvxdqrgEHCp6zI60Al000hszhS35BihqWxPlFzvhSttYp1jIT5aQg4v2RoMyf1OuUd2rR0EDlN7VMNmf9QTD2NXIA+5BzjYYx8ZomzMmrQXxi8qEB05CUvzSv9DCiDjbT5fUR70GpYNHxg++x5lkw0owhW+IPmHJGcAxbj/MRoM7tcBAvSDcECfvKf0LdFLaO5n5EHaQF7tTr/kPIrXEdyEIV8rt1O0B1SIhplDed4YjiK/+JcpP+0mQFXf3hDkZ38ABPWUZc9nNFibTV80hqD0hjFcX23jc8XbBfYncndEhP1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpnw9Gpg4JeqTBKlcim2Ze+bj98VqYRU3sYXsAgbZDY=;
 b=GFrTE7qkTeg76thzaKrcjPgcwWdwX/besl7dVcHkKyqlcpbaK7kmo9ChyI1NqCs95sCJOkUUBehzWMa28sI//6jwPMlXTIwJvxur3GC+lvsZnSuFPwpJVDTCBAW+6jpf3KH6qQGXksKTVimbATuyLGUHK3Y/dAphhMH04Elwe8eR1kjYNSWmcc7OrcDmtvloDgm76l0eFXgq2D+ETukTZwJ2RgIha4zXTcE+SirTChMOC3mcmucnnVlBy2JwvvHnFvZFPp0p+zCeP5COJ+ZJSJvw05NLfUgq/FovESfbdXBsN9+0QZE3TTmDNoFQf4fn41V1dMHDpAcgI3Hm4grdOg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:21 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:27:58 -0400
Subject: [PATCH v5 02/17] perf/ring_buffer: stop using PG_private as AUX
 page high-order marker
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-2-bb68b6a21869@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 linux-perf-users@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:52f::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff938b0-761c-4f8a-10d8-08df17880173
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|3023799007|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x7haXqulnn0NrzXWHeD894/aas2dxmbwspaDtEpZOSwnzj0omSZBKNLD2pLxhN0geqDumfs2A1Z+dRtqHerSene4txUwQbOrQXrNVklJrba740bAnolu5Yuo7RtdU4aiSouyawpGO4rZfcjwOGYeVK30jzLLODYhE7SAiQdmSItoxmPEQiHDjWuNPHd3UK7rgV1NpC8qkS86tHbW+qJvLmgVfFF2R2ogTVJ6nEntCI8KAs7eaeBOsS2dIoa8Thak2bfDY+wHBKBkSP976mOmj8CPP2c906GSpvr4YoBoddxQXKYgS3mKoBwJMTSVp2e4wwLzgpOVsuQW3RwE8ZjoCqbN56oy5BlZ69HcfXrDilvhAxrYKQZTw/aQ4t6BBMA2JzWcGLZKorG/oc+UX+Jg4AlaNKaWYbqtziymqiBoYDTnK0CIxo+0hsocDRcCx+oW6hBw7Rk39rhWVgVzOchu8dSZCFgpM9/ZBUw8dMLnlO1O0wMiOElQCcWnli+6ZhpAQIXCtz5E7YPPoFuS2Bfe4ixaZwnEy/Kkc8/MzCZdPx6WKVtcW0aheRZZf6cnH0lIe10ZCrWT8IaED7ka9Rdpi1LVsKbJZItLj4RCvmmq43ByJwRsjmT38K17oRocJRrrIyp5JU/MNFro3A5hjKLWIywSpR2iCJ/lqgN2dMgWYIwagJABlStSF9/TEdZQwmFjn0aMkpolFTdaQ1ZghNvDLw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(3023799007)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWV5U0JySlp3THhaNHJBWDVNcnQ0WW84dFRWMlZVU1llZlJRU2tSbUdSK2RO?=
 =?utf-8?B?b2U2aFNSVlRNaG8rek5GQzBhV25hamREVzJxUlZOTVk0WGJoUUozbmg1eUNj?=
 =?utf-8?B?SVJTTnFHNDJINHNuWGNMUDRTOFAyZ2xCVFB3NU15OEVCSmIrVDBGam9kZlRK?=
 =?utf-8?B?aUFuZ0JlZHNRU1hTVUczYmRpL1crVGpXbnA4V01CWENqejB4R3ZBT05VN1hC?=
 =?utf-8?B?YUI5elNRODMrTGJmK0h4aEQrbmNhMmxCZm9Ma3NNZVJUR2JyOTdsbXJ3blZw?=
 =?utf-8?B?amFCTEd3cFBRa1IxcWw0ZGpwY2pOUjFoK0R3ZWxNdnNtSGJaa1ZxWTB3dFls?=
 =?utf-8?B?emFKWm9lMjZEeVdodHA0SnhIQ1YzMTFab1ArdXBUVlF4Wm5LMjBFL2cxYzMy?=
 =?utf-8?B?WEgySkFZV2ZDQ2x3TDVPVlR1TDZCbDhVekFnZVRsTWhSbFJnWGVFQkROcG4y?=
 =?utf-8?B?WUxtc2VBdDhtM1NVWEtGd1c1R1hVYkExTjdxem5LaCsvcUdwYVNYMG8yT3BC?=
 =?utf-8?B?VXJobXhzb09lT2NnQzRVODRVaFZLem9zNmJWRkpmL1BnRUdTMUpDa3ZreTRS?=
 =?utf-8?B?MlJYbmpuQlZHR3RscHo4VTVBRy80dVFRMDBmcVRxWWtIYU9tV1RnOWt1c0xU?=
 =?utf-8?B?czlkQzU3QnhvQm9IRHl0MGg3NStUMGc5bXJXSWcwV2VjTzB4ZTZCR3owOVpj?=
 =?utf-8?B?a1F4ZXppNjRVMEthM3B4VDRSYzhoL0tqNkJXOXBXYzJLbVgwUUVsaU8wcDE0?=
 =?utf-8?B?UTdYdTdiSkdZTFNQUTRPVFJ1WFhQN0xUQ3VnQXV2NXdrYS8ySlZzL2RNc1Rn?=
 =?utf-8?B?QnRPcTlQUUcwbEoveGtyTnIxbkZoV1JpUFNCN0dJQTdheE1hR1FvWjQwdkxj?=
 =?utf-8?B?ejM3bldJbG9QbzZBaG1wTWVZN0hTbFlhQXp5ZGliRTlueEFqS242SFZBcnh0?=
 =?utf-8?B?WTNsKzY2a3VlTjV6Z2JZSlpWL3VXb25NbmxKaUdwTS91bm10WG5NRHBPYWpL?=
 =?utf-8?B?Y0d2cEFsNjQrY01LOXV6QWhLanlhd09iQmYrUG9SZnNEUU5JMHh3NGVKQ2Fy?=
 =?utf-8?B?Tzk1QXZFaFpJbVR5VEdUd1E2KzlJTHBzQnNFdVRFWEljSVZ6VitIRTdENTRr?=
 =?utf-8?B?bEF0Q3lMTzVWRnpyUDRqU0ZjNlUzUVVrYkphclZLNjBqRzk2bW1WbFVwSXZx?=
 =?utf-8?B?RFJ2QkhxRDJlRGtuYTJ2WkxSQmlvcFNKY29TZ0dPMXBhTXh4U2xmbmJVRmJ0?=
 =?utf-8?B?MnZuaGE0WitQQ2hIZWdjajBhU1BoNC9icjZGcHM2bTI5WGNuUjRQa21pMGFz?=
 =?utf-8?B?V3VpTFV1K3U3bVdFL0F1S2hLN0hpZG13Um81RFYwUGt4Q0pDZFpQZGlFVjF5?=
 =?utf-8?B?U0VpNVA3SG1JcjFCUXBYM0Q5SFV5OUd2bWRpM1VsamxwZHQySFFiVFVZKzUy?=
 =?utf-8?B?bm1LMmVReXd4U3VoQjRaWnA1N3VMWW9SdTJPMnFua1JreTkzNjI5UU81NENV?=
 =?utf-8?B?T3MxOXBYeFdIMnZsOHBNQ0N3YXRNZnRmV01CNlByZkFOMUtaY1l1NmlzVmtC?=
 =?utf-8?B?SzAvVVI0emRCQ3hDUE1mL1l4RVZLRGFmYkhrKzdXVEl1OHlGRnhReEkxNDlV?=
 =?utf-8?B?c2lOOHlzWmVmWk1rdHdId1ArbUhsd1dzeW9MWElPT3hkdnM1QjBIZytxa0Ft?=
 =?utf-8?B?Ui9FdmUvRlZ5bmErYld5K3BZbHh5MThJeElKaktiZVg5d0VTbmlsMmVTK1lF?=
 =?utf-8?B?dUdIMlVsR1pxM1pLNGF6enhqSURsZkNkVW1NcUhrcGE3S0IyT1RvUXliRXFE?=
 =?utf-8?B?K2RTOERadldtdnF3bU1mOW13YXpxM2tROFFzcThYbXQ4Qjc3SDBuYkNQVnMv?=
 =?utf-8?B?KzM2NzdDSXY0NjJvTmVnc0dhMml6emtKcjVvandINHJ0N2hGQzVPRzRnYmVM?=
 =?utf-8?B?V0pyN0RFc3hRTzNDQVhVZ2szd2tsa2h2V0dqaXc3N1RwUkNMSCtKZ3M0dVZY?=
 =?utf-8?B?STl6R0xPR0kyb0gyWG5oVmpqNnRmS0NEU2RiOGtkOTZJTG5zeDRjNDlQWDZD?=
 =?utf-8?B?bTVmVXNXNXBtVjhqRkNEcXMyT2FjbGpvMDl0c3d5OFRBNjBNbjBvS0JTT0lz?=
 =?utf-8?B?a2QvWFMwdy95K3lLeGlmWmdzMXdtNTZXOCtNQ3VRdlV6UE82SVhJTGF3bU9z?=
 =?utf-8?B?bWNaQVJLUHNENjI1THVVeWpyRzRvdGVkTXdyZm52eHd5OHZ2ZTZ0Rlhsd1Rz?=
 =?utf-8?B?TXBkUVZJTHVWS21tb3lWaFVOcXBhaDBLT0h0UVM2bmE2T3BzbjNMV1N2T1RS?=
 =?utf-8?Q?WwPQIdP4wlBNC+Z0ZS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff938b0-761c-4f8a-10d8-08df17880173
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:21.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsMroYURnNclzEm3mUc0sBDZ5NZbOh0xs7kzioKBtIcFj7b+BStuV+h9uD1y4fRj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9E5B1C0004
X-Rspam-User: 
X-Stat-Signature: 1oyndob9ci7mwcpqqirfpsmur9c6uwu3
X-HE-Tag: 1789957710-678427
X-HE-Meta: U2FsdGVkX1+DRsdOEepFUbKh1FOr+oAwObSkqr0dAS74hWjzeITinb7BiO83S6wWt56aSzs19ohYVw2XdpM+ldbHl6nOuzcK6WpCZ4vzvBuKpKuR6GMxolMFMvLRr0U0UlUQ8yAdGa+ThQyixPzkZdQFg4TCtU01Th0h8CTX7VCsRWKXJyF3JAkgdoLJlhDVSOHuNEu/gUNNFuBuWqOIwc11u7qEbbMV7RRrinvp7eBkzMFboqT0uxFAFgXLrpSkNckILhNnlp9n2L5tYjxe87jRk8TrIOHPDk1+nfbES+CmAKiByRHoYDyb+SFFslKrbLbYZ1GtmSA3tPJ8rBfAIFQSajfDTo0RtNB6aHhqJC+jH6iI6sKcSrSoDkapmZqm9XBk2Ieso67rD8EuFrt7jtxWFVzchoRKe9EX2s1zmhvhJ9Q+XCJ7mUYVz85mm+nzzhxDH7F+vNFeyU50/arVmobw1ZlT8rqAkdf32+AtRgc0AFK5YPu/3dXx7hOeoObCkYvYhKWpk9Rd+Q8dNd05VyLgYk6Vb/Yhayo7ql7+tP3k30nJ3iTxDHBTqaW0sGtJ4lJ7/zZqjvFGpXSCt/GRBxmoUIHN9HEFAGFKwH8wjMIoogk7iltyMnzOy5A5Y8zVBh84IO2apdHzi2ilgD2dwEplcOEQvqAnn20lCrrs0OFmtFEtKpJfsiYHx3W/Otqdk3KQzVrKdhTisw0sje2cxofPfn8xRs8inxeSumzk1fKM/D4mjz7UKnrDFq/VKwZV6gNelr7wGtJXJe90mu23Rnqn8cNzlmSq7Md+YLNfPVHu6dk9jbhywgz+7xQCrNLtp92rxmR6sQwY9OvSEBVBhPcwJhYuTRM5RjDhoZ0bn3tUYyQIxsQcI+IqNkb8gLuPqD3FAhMT8RIXevpfDTpYJf5/069JmUEac61PWEw3IGTEl34ezJX32nR8+Yx2T7tbWs2O3pO7UONTSP/4A7v
 U1OEZKsa
 LfdmvSkAPmm0H62grlqjUrrymbLZqT76O3OukDQe02XoFIdno0E43CZqNv8YnQSl2LbNjGC3OF0xjjzzW0BQYD4GWzVSql0VnaIgeMx/IyEmi+gE3NFivDONLePcEWKJHE8iB9n25Ndg6HFS5aGFop7Tw6sxe3lhv47NJxfoUApBBxMuZsuzkyB7tPh20QyeMfqAqR1EkniHikxmlrILmHmc/6JSDOaKIyIzf9Pnj8upYalysLrUct7qZAjU4MKcGvwav6OdNxW4kGKpkwLfiGFeqdiyfI2tL6JoMPvckRNOv3LUbfr8eikfZI2SKo0M/3E9FibKn+qx2wjgn5N1xyNaaoDN3oGVOqvjc0PUKpAV3SsPoYpsyORluT+jt1yT7xl3firxhDnv+VG1/63SM8EBYD1cn7Wsmsd42cXxoyOaa2jFQM4wghr3kc/kSwbkeo1t6kjafws7lUwfVO4lpJqXM7nEHXevTMGeYaXdCvLvqfjbbTXQTsUKheyNbL3KRbNgAVkR5GIzB2fmcjW0eV98E3pB72ZQMvBa8XxvytBrrAEhLcrjN16Zvto9Qex7ygy5Zf/J/eRqo2tdJmRiP0owTgWsF/24K4xbM/RsloAcIzvXeAX3FHR6JJ87OlOOCX4dzetS+oEgfqLGtJCOXWYgfYMpm0rHmcbYoOg7csjZVeHEcudUJAXpFj9cFB+8nnH4tgWfgPAQl5OdpzkGcK37r4QVqiWmfpAsE0z0nFLdDjBR0/9iaVLM9HiuAx23TnrK0n+y23t+bxtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A high-order AUX page sets PG_private on its first page and stores the
order in first_page->private. Stop using PG_private and check
first_page->private for AUX page order only in the ring buffer and its
users. This is fine because page->private is 0 for order-0 AUX pages,
matching the page order.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 arch/x86/events/intel/bts.c | 3 ---
 arch/x86/events/intel/pt.c  | 6 ++----
 kernel/events/ring_buffer.c | 7 +++----
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index cbac54cb3a9ec..5849392cf26d5 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -66,9 +66,6 @@ static struct pmu bts_pmu;
 
 static int buf_nr_pages(struct page *page)
 {
-	if (!PagePrivate(page))
-		return 1;
-
 	return 1 << page_private(page);
 }
 
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 5754cd4055628..49349afee6119 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -781,8 +781,7 @@ static int topa_insert_pages(struct pt_buffer *buf, int cpu, gfp_t gfp)
 	struct page *p;
 
 	p = virt_to_page(buf->data_pages[buf->nr_pages]);
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (topa_table_full(topa)) {
 		topa = topa_alloc(cpu, gfp);
@@ -1296,8 +1295,7 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
 	if (!intel_pt_validate_hw_cap(PT_CAP_single_range_output))
 		goto out;
 
-	if (PagePrivate(p))
-		order = page_private(p);
+	order = page_private(p);
 
 	if (1 << order != nr_pages)
 		goto out;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 9fe92161715e0..061b5cb222266 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -630,11 +630,10 @@ static struct page *rb_alloc_aux_page(int node, int order)
 		/*
 		 * Communicate the allocation size to the driver:
 		 * if we managed to secure a high-order allocation,
-		 * set its first page's private to this order;
-		 * !PagePrivate(page) means it's just a normal page.
+		 * set its first page's private to this order, otherwise page's
+		 * private remains zero.
 		 */
 		split_page(page, order);
-		SetPagePrivate(page);
 		set_page_private(page, order);
 	}
 
@@ -645,7 +644,7 @@ static void rb_free_aux_page(struct perf_buffer *rb, int idx)
 {
 	struct page *page = virt_to_page(rb->aux_pages[idx]);
 
-	ClearPagePrivate(page);
+	set_page_private(page, 0);
 	__free_page(page);
 }
 

-- 
2.53.0


