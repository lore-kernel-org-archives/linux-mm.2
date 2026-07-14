Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A40C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F80C6B00A5; Mon, 13 Jul 2026 21:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9576B00A6; Mon, 13 Jul 2026 21:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BF06B00A7; Mon, 13 Jul 2026 21:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE69B6B00A5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:56:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 388CD120210
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:56:33 +0000 (UTC)
X-FDA: 84985717866.23.74AA901
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3353514000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:56:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s0QJz47E;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783994190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCE2okdspJbiqm22ESkQBt68d9E90Q5Gl7NjCY5YCVk=;
	b=5I7tYAsuRm8c1+iOeHje06W6u0plDYmxhYHVKC9jjFs+N2obIaH1UIVSCaLvxo451Hy4Bt
	zD3uyTljwh9cA89lmK8oPHATJ9+VVBPfGljf+fbYeoBVgKYiH0dqjtmnCbx3Bhlu9ZuyKj
	y3LG2pNVP3aIOIGDME2asCQpEFU/C1Q=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783994190;
	b=6CBraThyPNK9+chW9uMV3NSValX+N2NBFNp7C2Zu/Hle4em40w0Kg3sRiutPZIkkzo9UCI
	9rnuO7kXNFaDdov/M/EX81UPISSki8Nf3g+AemCtBPjxNESJ4W/PkXYscsS9AZXVU7jv9G
	pEH5BACXReQY8B+9fNfFxX5OX2EHCQM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s0QJz47E;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GRFUZKt/lY8h35TMOLQatqd7i61rVkH2xGVMdmIJmlQPZNaWhZrTJ0gsSocIsfqur7ZAByBahCkr9uf3A3zdo7UOd34vnF2KUg9xcEutYghT3L6ahipMsjzSK9dxxn2L5K6GA1J/DHBQ/HD/UhXWT7jTNIOZFTf2Fu2vPdtGyecMe24VxtPBVOA595oBvQEdraJTRpLAgCre+3vDV/BChUDYU8t3tJBCI7GVX7SwMXoijw0WFw/ARLnU4o4Xz/e01SJhl24N8QCOrt58UA3UX3VwRH2rqppYwOQK08Me/Pr+o96jR1uUcBonsbmjeAaUGaZYIKKBbCWX26EXA4B+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCE2okdspJbiqm22ESkQBt68d9E90Q5Gl7NjCY5YCVk=;
 b=Ik+ingxlNRWJDPAbBQrnF5bm2Tlz8EF4oVsO0P1i0YDjqgcSVGMBwPSkMDPu2R/XJz99rkxQNlIaGzan86ALAlyCskg5V1oBJuAPTBD8MAcfYOuOkpfxOLxivmA0V9SefxdqawvP//y5i+tqc3AiLr828OM69hkjO1YE2QQiRhBxGO5oBPDmbZveAGM0g57+2WUTikzl9EgetBVxmlaD+Oex+RDGtzkr6+9ad5hMIZdKLjsCU6JEZIPe8ALr45xNrt2nUga7HfryYC8bQF/L29BTFpQ/9j7Hf6aLIu3T1VuirLi17fTDcDlMqhvCHk5lZyfKQVcsLQaGzViicoM/dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCE2okdspJbiqm22ESkQBt68d9E90Q5Gl7NjCY5YCVk=;
 b=s0QJz47EBeMiNEHlEnvFyO7ksiMsp5Y5ELVf0QP+e0NptJqZa5LQnCtp1JI9p76OxCpcuMBIRXrbgI5LEDk+eunxbuwU1dpfyem1mFkWv0YEjdlLHgEkYbPVZMZezg7MYccs1ZS9WnC6zo5r3lEgN7MB10J22cr80+utrYVFp5B0udXZgZmV5DHv7CnOW5Z41eiHZxrpaLn0Mzwczn1eUVjZ8bg4ra69MUAn8T3sI4W4q1RRKe1nKKl55TdqTOxtm+A9Jb8DbNwzE9/x0jUIGoQt4OIEu2fLNezefmBx8QuiDNVg9jxr0dDc01Mzh6dM6b8tIYkUS5plSOc6BCTXcw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5735.namprd12.prod.outlook.com (2603:10b6:510:1e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 01:56:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Tue, 14 Jul 2026
 01:56:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 9/9] mm/page_owner: use memcg_data snapshot to avoid
 TOCTOU in print_page_owner_memcg()
Date: Mon, 13 Jul 2026 21:56:24 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <39DA14C3-A353-43B3-B6B7-CFAE99C3B0F1@nvidia.com>
In-Reply-To: <20260714015117.78351-10-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-10-ye.liu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0PR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:208:530::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5735:EE_
X-MS-Office365-Filtering-Correlation-Id: 33797a8f-abb8-45d8-df43-08dee14b1d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	G0zha+7IJc2X3WTSEWKt6s19KrgjA0quKPlZrWdR8B2UVn8QxcU936/DQZVmTDn2QAUvK4JRGpIYN9ugCoOfQZUUOS2EbBAZmGR9s3tXveLwJs9vopL5B42f36i2SALWyuzslFwAn3cybIpvZaO4xJlYHw0OIw5OCTarPsjIrDxgLaiW6lb80JDPB+duTZ0tTcuqhmRKBzPFFZfGNVd1WP2/bzBOEHCpystprcxC8o0Bzr+Znc9x0EjQnbD3fHfROKLz5D0B59icrozSgiVYgO/JZUuzG65DCcN4FOe+/QrnENHvqrCVO0PNSfjI2yXG3WZFgC8ctLIjH5uQRyYuW+xipAW3GdfDMvzx26DVRXrLsidp+PXHZ2NSfg4dd3sJoLZ8DejuF3JB64m0vwa0UG7ajBxcuRmGsNZWjSdgSdMyLmADd7RKDlQS69xzcG29OtRHhnmRBysrwFcwrt+NezyXQ709YVZ1pUg5Ihz0r/bAF+0LyN2Qwa5GtWvpVUeNAWDpQSuncSXKxC3Xs0zLP7DHtm93QIpLlQ/vCqD7o1bBIcFV3nL1g1UpvaXecDqkLndUga26ylbGF6nKgnelb9HZZeJiqDIjRxi8+b4ijJJBspWoWr3kSqieMqAy2rAlnGKX6D/+H7yOrUaLv4xV/luqRqNj/s8CsOY4by+dnTo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzUzSlpaWkVYSGQ3LzVRamZjU0RmYXZEQklTTkZESzM1dzVYeVdzbFlScDdt?=
 =?utf-8?B?ei96dS90NG9yMXR0Ly85YkRaa3Q2Zkg3Q2ZCbm8zTmhjQ2dNWEpGZ2xLWVdy?=
 =?utf-8?B?VGlQakhHeWhMQ2RvUnRMTUFuVGlka1JNUVZhbkFMQjBKOThJQlFGYlc5aGlO?=
 =?utf-8?B?S3RqWGZDUUUzTG9hM0ZJWE1DZ2NzNXZrc3B3K1p4MHZCZ0lYY3dqUUlyMzlV?=
 =?utf-8?B?NjJNajRkZEhtMG15WHJSM0x1Zzk0M25pWnBrWFYrQ2RLMUR0VWRKeHoyc2NZ?=
 =?utf-8?B?OXlZYlJBclczblIydzBrRlRvdStmZHJuSDZjb1F5T2R3OTNzbEJZRkVFVyt4?=
 =?utf-8?B?bW5aSVd5enpBeE02RkZHVFNab2plcjdsOFo2Um1SZVhFVkc4Q2ROdjcrTUpW?=
 =?utf-8?B?SThKYkNJclNpbUFiMWZhWTlMcWNNN0N3YVl1RWt5TkpiaFdhMHpOaFNnKzdu?=
 =?utf-8?B?KzF6Vyt5a3BCZmJQZ21ZSDRMZnZwUnMvUXgrSWk2NzFydmxZSnFuL25EZ1Np?=
 =?utf-8?B?VU5YcWdYZkFhSG9ESjRPREtwcE95LzNRMVVIeEYyWkFZcE9Sd0VMNHFOYWF3?=
 =?utf-8?B?RmtTR3FmeGJPblZBdCtqbEp3LzQ4MGRmTHQ0bkU2VkRtSGJISm9RcnBpd3Rw?=
 =?utf-8?B?WjdjMHBNYUw5eGlJZlM4V0NvNE9QdGNrSFprNGxBZWlTd3BmalRUUm1ZSytl?=
 =?utf-8?B?b21iQ0JWUlJZS3JtL2JIQ1VpbEJPOU8yT000N3dnNzVrVUdpdm1FZ2xOTzRZ?=
 =?utf-8?B?NTZ1MklQM1p3UlRjTThTdm1LdjIzR090NWx6ZWhvVFRtYnA5aVFoRmg3RldC?=
 =?utf-8?B?bWN6Qm1kUm1hcmRsaCtDMGdqL2I0Y3ZpbzBuYUd1aW8wQW4zTDBienVjRFp2?=
 =?utf-8?B?SWxaemkwWDgwR3FtR0lhbXRuNW1kMjFhK2lmWm92cStGOXExTDg4Mk81RGRm?=
 =?utf-8?B?NGdpNE0vSFhUYkU5bHFHQkNRMW9idVNVSlRXV3NHeGxTcEN5U3ZhS0lOTDd2?=
 =?utf-8?B?U3NwK3lxY1RBbVNoU2MwcHNwTHUydHJEVlJLclQ3bE5MdFppSThOM09IekV2?=
 =?utf-8?B?ZXdkb3lUODllUStNQnVkL2p1ZGc5K2lvZTNUdi80alhyL1ltVWp5eWtXcWZx?=
 =?utf-8?B?a1lVekVoL2l0d0dja25MYzZ5Z2dPUWErQ0FINVNESzk3dWFySG9QUVdXcytI?=
 =?utf-8?B?NmpwQSt6RHhtV29RUkRnYkpkZUxTZTFiYVhuLzF2WDRjZXA1eXNHMEMxQ0tl?=
 =?utf-8?B?SzVkLzhlczBOLzJhYTB5U0w0UE1BYzZ5QmxZcGpRQmpDTVg2OWdMM1NkTFBV?=
 =?utf-8?B?NUpBMFpqQnlLSUJGc2hMOWJUQXk3RkNuOW1BLzlQdUI4bzVRZUU3VDBzSy91?=
 =?utf-8?B?OXZ6NzNxUElZbDJJYUVHNi8rcDUybGVCTFN5a2hQekg2ZWl0eUlhdkI0YU9V?=
 =?utf-8?B?SFJ0dHNCYVNSanI0dkdwK1JTQnZYMWFJdk1RMXRZUmZWK00ydmYvcFRxN2l6?=
 =?utf-8?B?Mkcxd1ZwdnlBQm9vaFZKSGNoZWR2SVhlN09yN2tGRi84cGd2elp5Q29nY2hx?=
 =?utf-8?B?bWtkZFhyMndIYWx6UmFuaitGSm44bUlmNFoyRjVnV2pQZkFzU01sSjBnY1lS?=
 =?utf-8?B?ZnlOQ2lRVkphNEtKNlA3Vk9icCtaNGdzbkkvejFyb2tDRWJxcHUxR3ZaQWhC?=
 =?utf-8?B?bGhyZmtDb1NXcHlDN2p1eFFzMU1PL3d4Zzh1WDM5UlU1YTlDNGJOaGFqWnBs?=
 =?utf-8?B?VldWN0Z5OEV1R1ErM3Y3cTZSU2FHN0tmbmVpUmJmU3RjU2I4cHByWldSQVRz?=
 =?utf-8?B?enlmNUtGWWo4TnBKSzFucHJNV1poTTloT1ZKbzFvU09YZ3hBU2VFNzBQNjRh?=
 =?utf-8?B?NkR5WVkyNUZPVnlqelpHZSt4aXJnZERETkxrR0JrK1BHMVJoOThUWHQ0VDVl?=
 =?utf-8?B?M05wanAvTjh0MXV6V3dkYWJPbmVsRjF3QTluak1BQjJUOHFCRm9oamdFK3hl?=
 =?utf-8?B?VWwwaGJHZy93cTZFVnZ1YSsrdU9JajJKZjhvRFVyZkV0ZFY3UURxdzV0b0xv?=
 =?utf-8?B?cU9CNWx6NGpVbmc5UUtwMWV3Q0NCWkNUaUJYT2o5ZDJVVnVBTkxDc1p2bTJI?=
 =?utf-8?B?dlVnaExRVFFwZ2p0ZnphbTlBWjV1NjRoMTcwWTA2eC9DQk9FUHovMldDaUVO?=
 =?utf-8?B?S0Y4K21HRlJIZ2F2U2I4UlBVNDc4MGVmVXQvdHpTSFhuaXNtajJYSitidGto?=
 =?utf-8?B?YzhWUmxGYTJBb0N1c0ZPVmpkcGVqYTFyRHRhdnRpS252L2lsbEdLeUZrUGIv?=
 =?utf-8?Q?S625SzUzKCZ7cJDHVA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33797a8f-abb8-45d8-df43-08dee14b1d0f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 01:56:26.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Se7TOD7iNWWQ7NVi8kkoTvzkr/pv82epn7mZXlDx85m1di7DeE25lT5Q9OYhvUUR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5735
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3353514000B
X-Stat-Signature: buyuee5ohjapmo4ysak7ttqodihpat8h
X-HE-Tag: 1783994190-537846
X-HE-Meta: U2FsdGVkX19pDCoy7Qpf12noStwln7S0lxZ1CpaLZR1zC02UpSqikl3LJFP0+Ghm9j/9yXiUUisRG42vi07SQFnPlCffq62Ib18bFGjyjMZWsO6Ozmf9i6I9UoTX5DPeFxwCQFjxUp6GdYqghRRsbLAamL5sPvL+JPnN2Fjd0sZD6/ji02fVaFfN9dMfijpQZf9mfqEum3soy2BWwYA2OAKvAuKjjBkFYaixOsWwj8AwXnsxB/5Q4IutBm2Wpd56b8sC9rQADczboxiZDMAj09uA4Bi7XuCxxoE6MfdamRfvSyfN/sZQG6bRHjCzv+oGCwmBV1hSEVIvr+ivXgMvBCDf8WzXspMZ2qF5jsXhaRgf1ghdu3wDTT89QRMRFW6q5R7v5lyqhALAyDuty08lI+f0HAxyWr2FeJedLeJJyZJiIyr4kvy3V6enFkGH70vfWO/b/+F86Gib411F5WjDTTNM4s52ulJLv30iAnt4dA78A1tlXWU/7mYFRELS9G1DO0Jq3vuPoWFya1MrWuVuKgNuRXnc0yJAJo4qnhK0qNo04SLOSXCi2g8MzrseQLggplSrFsQLJmFE3TswcmlOkBQyZBqEcs0CxBrEMVt03HHkDS2hTKrkHrHIWFa9K0tBj0f3FMILN53apNXL/Vflmc6t3kw4bordKLRK1Kj5Ti+fhzHV7NAp8cAtzHWRKE3kgP1e4pRDlmhrrchHUtNoVuSC098Vqyp/ENqn2NK8wqh+UfcjLRKaIQdyJQzMd1B2x3eiMOCrxuqbGNERtiRUrkSTfjZOdPAnNBHWV6VKvQAyY5Y4KMNekH5v+qc2DgROT/zMWWEy/z2HLP/lacdROPN/jnRXaue3GaS+DzMa7tGf2r6DikngBjP9P9BtqNgisWUMz7Flnjhuy5davJSjXJHWQAAt9B2tqVTd804P8WtiPo5dsFLIMlIyqTHvb2jHSq/JAgte0RXRJmUyizE
 qih56h0W
 m1XSGjhqaRVDpSs2narcPkS/U93+GoXAg7/avOFFW5TyhRi72V+SFzsZMVWjPxX+OUSRhzY5pxN3KQTj/ot9I9sXcLruhl3ihqAAcnnYuSdERxA3w19ay/7EkVqoVQY+Cc5imsK+RQbnQjE+1dsBLPwYjZmP230u4NLj5P53iP59x85M6xNCzzRsd6sIpBpBPCIvwI/7b6f0hzTRgGnJmWc7KJn54zgtrDWOM62RhIavDcwhbLaJAqvb00h9AFaxmRj1bj9n5lhC3TsBF0/2iclYFhmYOOheoi93rPVENfkGAgOOeie2hG1N8zmAwSI7AC5qB1F6R1U/w9GZLl2ZFRDqi8j7HwiHt+TYHxp3lbI1wthL36PHBOnQKGoqu8LBopj0PZsRzpAk12RylRkcNagQ2/3u+eam7ybhuKW0NWx6zy4CZlIZV6CYIYwrZS9pFCP2qI5Fn+Veoy7Fbm40sS6/zLekuw9QG4rQCEaCY+BeM48o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jul 2026, at 21:51, Ye Liu wrote:

> print_page_owner_memcg() takes a snapshot of page->memcg_data via
> READ_ONCE at the top of the function and guards against tail pages and
> NULL memcg_data.  However, it later calls two functions that re-read
> page->memcg_data locklessly:
>
>   1) page_memcg_check(page) — re-reads page->memcg_data;
>   2) PageMemcgKmem(page) — calls folio_memcg_kmem(), which re-reads
>      folio->memcg_data and folio->page->compound_head, wrapping both
>      in VM_BUG_ON assertions:
>
>         VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>         VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>
> If the page is concurrently freed and reallocated as a THP tail page
> or a slab page between the initial guards and these later calls, the
> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
> causing a kernel panic.
>
> Fix both TOCTOU issues by using the memcg_data snapshot throughout:
>   - Extract objcg from the snapshot via objcg = (void *)(memcg_data &
>     ~OBJEXTS_FLAGS_MASK) instead of calling page_memcg_check(page);
>   - Test (memcg_data & MEMCG_DATA_KMEM) instead of calling
>     PageMemcgKmem(page), which is semantically equivalent:
>     PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data &
>     MEMCG_DATA_KMEM.
>   - When memcg_data has MEMCG_DATA_OBJEXTS set, early-return after
>     printing "Slab cache page\n" since objcg != memcg for slab pages
>     and there is no meaningful cgroup to look up.
>
> This avoids both TOCTOU windows and the assertions entirely.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
> Changes in v6:
> - Rename patch to cover both TOCTOU fixes rather than only
>   PageMemcgKmem().
> - Also replace page_memcg_check(page) with extracting objcg from the
>   memcg_data snapshot to fix a second TOCTOU issue.
> - Add early return for the MEMCG_DATA_OBJEXTS (slab) case since
>   objcg != memcg for slab pages and there is no cgroup to look up.
> - Update commit message to cover all changes.
> - Link: https://lore.kernel.org/all/20260701061101.344679-10-ye.liu@linux.dev/
>  mm/page_owner.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

