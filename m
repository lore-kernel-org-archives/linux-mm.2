Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A326BCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A626A6B0005; Mon, 18 May 2026 04:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13406B0088; Mon, 18 May 2026 04:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902586B008C; Mon, 18 May 2026 04:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF0B6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:34:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09537C2AAC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:34:46 +0000 (UTC)
X-FDA: 84779879772.18.3DEA048
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id F11D440003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:34:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="f/mk6jGI";
	spf=pass (imf11.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779093283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbJWtxhKyylnCW3eIbSl6zsvAO/O2ItTfyuzbb6Kjrw=;
	b=g8vCA2PV0edDsT3ncveVDwbzNWdXl/qvFiR/Mho43wGVQiniRjs4qUoAGkrjOGA0ZOgyTw
	7C5IADyeN8iyWCCxL02yIvcYV/tTznJ1KutCgdp9x9+vaJZJfr1I/K4/JNyiz3fSLOTzSL
	q15PkQMm5YqYrCIFUg4a3yCdUOhmPpg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="f/mk6jGI";
	spf=pass (imf11.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779093283; a=rsa-sha256;
	cv=pass;
	b=b/9RZY0rduW5CAcY0BT3242YBB0Wfvr4bKm3ztIoY4u9v7Zgil67UyCGHpqVJbtHo8Pef8
	3DNm6/fq2OMSMxNUHFFj1VzihtOz3ertKaREH2TADH3XKe+0JKwfWyBmW4FmgaMrdLhe4h
	c/a0IR8Uxv19CNFKaupiHcS+PISw8Oo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0+QOs7wn5hA+ktPGcu9wcaBnNEbCNTwmWwHr+ps8yRB4r/vee5+eyoJyuR2I2VGJCfDI4I+52FhkUBAlGWokdn3TqBA5qvsepRyiuC7uzs2OKrZztZ5cKzd7OG1RFOQ5hXAXi5OzncLmpnpbVvVjVnpFBclQgPFBsZgiFJPCnCKUnRnhCHaLiGmtUAnDtFWnkb9+p5a5u0Gb1nijD9z8VpJIgxq1x8w5y09JA56CBBrqJo9SzpzSHCKKlZMVZMtKKt6ht0EoMDZuyXXwt3gbrOnLF3XqTKvnJ7j6gioCG06GFt1j5q5TgpWCXR1saemf+UG57cbXLtlbflggdPIPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbJWtxhKyylnCW3eIbSl6zsvAO/O2ItTfyuzbb6Kjrw=;
 b=Rlpu16PCMlBIxql95Wtztl0wnS5Vke5knQvsmCqho5vR4aeIfFl4JzPUdeaCYbn9JbuMM2GTcZrU+AP6Vpkk/gCLizo043aKCf9BIFY3sD4808ozXR7Boj2ZckvDWb5dHfPht1jTVFDy0cHX5EWc2VtKtyy5NHZ6DPAGwdM1IFtBT6m8G37iXWq+bEzlAOzAXCPXz2vbGitxVR6RHfs/qb+/PMvbNouOt6+Am/2h66Ts0Vu9vdFVjmB+xVlAE1lAq9pzqQUmxnpkn226wIi166Xqn9PO3noM6ID26FUp3LFnfYckqwJQ3xzqih5cgUN79CvlZ82LAeBkvoZMZnM8VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbJWtxhKyylnCW3eIbSl6zsvAO/O2ItTfyuzbb6Kjrw=;
 b=f/mk6jGIIZ1QVyCb52ZHODTFkPKbovHz0+FcrR+5FKJ5KZv+6ZG1UUYIwu3P+4xF8ksbv2JwXE8dgAc1I5vxYTBnCPeL5w5Lo9rdAQ9Xue0mKDRR04f42s8IIeS2FIdrVTUwnrqhr7bBS26FA2M3eoUQmy8oadBpCZxly+Dt6gs=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Mon, 18 May
 2026 08:34:36 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 08:34:36 +0000
Message-ID: <4e0657dd-4175-456c-badd-de1c67069504@amd.com>
Date: Mon, 18 May 2026 10:34:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
 <0ba9bc77-ace1-4077-a193-4540880b242b@amd.com>
 <c2881d16-a12c-4598-8f8d-3b6523266fcc@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <c2881d16-a12c-4598-8f8d-3b6523266fcc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::19) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e09a6f-fc30-467c-ed11-08deb4b84b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|11063799003|18002099003|56012099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	RuWpdKaUPmt8OtkhWm6gjzbjr5okvkEmDZA46I74cLcBkIf2u6RcfnhJRACG6UUBtDlSATTIMBIUnlYKdcy37BXisUMB+4L8itOUPXm2J+vmrCLuE9/O8ZTyv6u4qwdaUmX7Rjvjf/oqXORoOLTYhTw7Bq5y2WdYWzkSfrRxmI1mWwyJJrCLUtY5M8EJiVJog88luCCQX+WhkPgOqUuR5UOxe4xA14oVnLDstzfliEHPzkIfvHMceagoB1kTHMUCMqvSSmzgvdBkcNgXAt6upt7kiFJXdNtyoTAMpwzqxyR2SDv9fAvO4uf0gJFRGWl3ivSWQc2vdb+BOiASNmWr/lhSzKJgOl5aEilXqzVDwJM4PTmdNWjp1DfXbf+lRehmkmP/XBpwJ+7gGUVk+qOqWC95ez986HPOhQlXhhMOJx9F4HtEIyS2O06f+n3kp64YQRUd1U8st3ObbRpmcDe00I/FYispts8uj+9VUZ9dl7dXZazSLmhRmd8815m+2JAwvsmEoWzx+QAH2SLZEMKfbNRoHQUrbT3PtF6pnJOGz7Xb1PimchJ1zHsQyCyDZ692m7quBncY0HhTpDG8XUM/MjiA4boy17H/jQ+qd2j9XqP8643eHPC5lQnBdiA7xMc6E4TtPir17+A44QwF0sCNpDNBChVr1ZJR9D9/NCMoGwJT4sGxVELptTgE81v0u5cw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(11063799003)(18002099003)(56012099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmcxRnE4Q09qRWFPaUxLOHh6azhiWkZuTFVibXptL3daWjJKeTJpaTI5NldO?=
 =?utf-8?B?M2NhclRVRXY4aXZhdTVJb2pKZndpb2tWTzFLdy9kcXQ1ditTTmd4TmFVb2kr?=
 =?utf-8?B?aHE3MnEvOWhSUmpBU3FpWDNzcHYwSUkrdm5hS3U0UE95cmJlUE9iV2JNV3pj?=
 =?utf-8?B?Q2x6ckhPOWdoRGVkQWpBQmJVemxoM0pWeGlmbDhENnpEb3M0akpIMk00MHZQ?=
 =?utf-8?B?Nmd3NWMwQWVXZVJwRW16WEVHd05Ma0lQclpJdzZnYTZCb2k2WlRYNWxkK1pS?=
 =?utf-8?B?V2lFb2psdFhJRW42eHo4NnI2OVYxa0FoM2FLWUp0THk0b0VKdEN4aHNCQWF5?=
 =?utf-8?B?SHNKVDZ5SCtiRXFyMGdRWFRjcXN6UFBGTjdhZThQMUNjbXdSQ211N0VJNEFD?=
 =?utf-8?B?NC9CUUdGREJWWm9rWUFzK1Q1Kzk2SXF1dEVIZlRSK3pLZ0xDU2RrY3F0R3Zw?=
 =?utf-8?B?b0tvWC9qcCtUOW83elBNWGhla2VxL1JkQ25pUlFLMHV5SjNZZFR4TktPdXBz?=
 =?utf-8?B?bFJoM1gvdUVSaUtxaWx4dmR6S3gvbWpwVm8wYURsSjFFSFo4RFFTU0ZCc3FV?=
 =?utf-8?B?Yk91U3NmTklUNDdPbGxpVU55ejE4c0tBS005d0pSU0dLdVBlTy9sOUN4TWpH?=
 =?utf-8?B?TDVvQ0grLzNKeENZTk5aMXZqRk9GNGtrQXp5b1BKWnpWQisrNElZcFFrSktj?=
 =?utf-8?B?VnBFa29nV0syN1BGdU4zWENiWVpjSFREd29ERHRMSjQ0bjFtNVdSNXRQdCti?=
 =?utf-8?B?RkcvUDJxYktLbUwrNTNhdVQ5MFZMZjlCeEtnQWdOWlZub1dicWlZb0JwOUgz?=
 =?utf-8?B?ZDJVd3NubHcwWDY0cWNiRkorUFo5cm1PRjExRGFXRmZmVEk1WDUxb2IvL0Q5?=
 =?utf-8?B?c3JTclVOcEMwdmk5KzhhQTRjc0E0Q1V6cndlVVBJV3hHenE2amFOc2haZUF1?=
 =?utf-8?B?aDhsTDJiSkp1ekQ0TVFqM0E1WGhqL1hNY2Y0S2tjcFZOZGh5My9adWI3UXVC?=
 =?utf-8?B?REhOY1ZYWWdTVlhzZUZIMzF4OGNDNTI3NEZHa0d3ZWltbEZva012SEFWUzdF?=
 =?utf-8?B?ZnRLSUdTSDhMbTdURmNKR3RGL2FRalJkMW5JZEJaVlV1U044dHpSK1N5Tnl3?=
 =?utf-8?B?djgybWgwQk83NXZwR0hRZjU5OTJiNGozVFNKTnJpNlM4cjQ5TEwrSTJYaWVD?=
 =?utf-8?B?bS9MRUN0S3VkbENqUzZ3U2RQRDQ2ZDVUNTRnRmdKNjhxd0dDWTZnQWRyZ3Vs?=
 =?utf-8?B?c2ZwQWQzVmdGZXEvUjVMUXVYaVNFeHFpcS9rbnhiNytSbEFON2sxVThwUVNR?=
 =?utf-8?B?SEV2ZU91OVJSQUdiODkxYXV3MlJNR2lXYTg2VVlrTGJ2MEFObTg0bmJabk4z?=
 =?utf-8?B?ZXFtUHFwWVFMaGJxNWtwdHNQZTlDU3VqWVJ1aUZkcFRsWmNIclcwOVpJQ2lq?=
 =?utf-8?B?bGpzblFMRGt5anA2V3NqOXMyV1owU3dDTm1VWmxBUTZXMzgxVW1lS3h6QWt1?=
 =?utf-8?B?ZXNqRjdmaFhJMWxTSWh5MHpJTUp5OTd1ZklpcmxsOHhLU2tSWXVUUHVyM2lZ?=
 =?utf-8?B?VGFPS0JHbFZTTXNkdkVkTE5lWUc4QjRaQjd0NGpCTTNBcGdxcGtUbWtuY0hO?=
 =?utf-8?B?ZE8xSitjN1dpZGhiNWdIa1gyYyt0ZmNZOEltbUk3ZmtiVWJwRGRQMlZ5ckpJ?=
 =?utf-8?B?YkxFLyt1c1Y3aC9sVlRvbDJuME96cjFyN0tBOFg5NDZGRGhLUnhyR29iSmFW?=
 =?utf-8?B?cUJTZXBRa2ZLMjdEYTU2Q3BrQUwrZ0lWcWkvMUladDJjT3kxTnAxTXlFWmFz?=
 =?utf-8?B?YU9Nc1orN1RJU3B2ZDZoZUJySXphanFGbVBWMkFlTWkvWC9VN2dWTmhnMmN4?=
 =?utf-8?B?OERha2pCN3JQODJCYUFHS1VBaFZJSUhrYVVsYmkrZVFxbnR6L2k3bXh2NlBT?=
 =?utf-8?B?cUJtdEtWZXlGT2pvUndCeVFRUFdpcm5UMjV0NmRkZEl6UnZHVE1KTDBTNDBY?=
 =?utf-8?B?Q1d1bHRWVExQZThLU1ZITGtpTlowbW9ybnhvYVZBRTBsWmh1bko0MmJiNzl5?=
 =?utf-8?B?NFpITU5Lb0UzQTIvTGY4NFFpV0o1dmREZlFXVXZneFpPYzRVU2R1alRJRjda?=
 =?utf-8?B?b01TalpKS0dnUTF2WjVVYmd1ZDRFU0k4eEI4SG0wM3I5R3VNWjRxY2pEUEpQ?=
 =?utf-8?B?MWlEVkg3RnVYQ2Fuc2x4K2JaWHpVM3JDNDhNaXBzK0o3SXhCemdoYkw1cUZD?=
 =?utf-8?B?RkJsU3o3dzQvT21tRjZBODRqYzM4cXJ3c0VzSzdKdTVNelJYaXRtWmdjTXRo?=
 =?utf-8?Q?DDV9/zPzxuXCuWVghn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e09a6f-fc30-467c-ed11-08deb4b84b5f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 08:34:36.6477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nsr60HNI4jDvIReV6kGTjRC9hn2TsXdoMVUNMmZp9U+FyAuKFhAtlP5/K/1JG2gB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F
X-Stat-Signature: kfj4wi4szgcmhd3rkfdgyi31qjayro8a
X-Rspamd-Queue-Id: F11D440003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779093282-218659
X-HE-Meta: U2FsdGVkX19zXMhXnjyjl36nsbXzRczKFsMJZd0SSfvVwFDUnk1Df2tEK/hOhJp4pcx6Pa75T70qo5awav0JMdHw3NQFoql5hwDJ6orgR6aVrvBEUfzjfJBBtbyda1lPhqSKy1QBdgHJxF0e9Da3bKbsX5qPLOnOzeCNVlibEqikx0UjQ6mAlx+xPBQVMYqGIJQHt9LJ5ppqQS2xO2FBrMj5/QBDdlfiGgC/G+5ZdlTSk5XvlxNgL34Af2eHDerAXcM06GNeC/Z+Iin5EkuR3yff0rj5gumNnB7hHbfIupu4Jhv9aQ7NgFVBcTbXePlfeP8tajuKced4skjYZpXhLSu5OfIdrCkBeNJhfvaN4Lyc5Rh0PsBDOKtxSm5RMiNHtXtamS2eidC6PczyUjNHMSbYR77/BBLpXybfW661PKwNvEGuO91gKzkiFEFa2l+7ecy8UmnLwVEupr9mL9qDFLdaVB/fdGgxla1hjOkodZK/nLbxjA/A+ToL8NDT7XLT6z4GLabU5SxJYX/wdD6uScjQ4Fz2JDgWYpDH/bzoGlAU8dmXRhrcBpZIztQrNCq/qTVM7TfY0cAnF8wQHLXaOqA0/7LZexgmX9u7wsGJDLqVc4GTRF/tF3NcEeUweXdIfuHqOCIhOv6Vl/mQbwWyHOY5RtJJy1EssUD2B+WnQKbtuaZDSqJ43W2+g3qhJ+IEkbhbSkffZ7LbnHUM7QCvz4aks02pHaaPsYf8N687qDw70JGWWlEOwZ85kccjzguqlHdei6w8mhuLiN1+e1CYWYUJKBkPg7uDL5/iXvjhRUwmVgYDas1d9oxjb+kx+v5sDd+OSSYxXjg1GRwh5LPInYlmGWwzEtJrHkxnJb1q4430hb7qZDcdgpvmvBmi5/Onidx4B6RxbRGICyfIMCmdrcEfuvCeffCZ5j4uKvMQnYVJ883LewjWKnbKPxfvgPTqQZtIzu73L0aNueIYkjw
 +4bBDhXX
 VZQsaS5Sh92UVNTDVSzPhGqOtCXolv6/k9v7SWYgmgWGdceXBPIZRPy2cow+X91+cAfdMJ0EMztoGA7ftXlZ/Y1wsWVHblquHApEfAFiiHmOwwfuyITvB3FHs/gDOKstNdaeZ2bAaYE7/k3O4bFmT/UI0YcPjzJp4UbNub8ONLZYPBEiYfmmMF/hhtPb3ozsWboBd/rQsyYOQdlx/VGfYRrQ69Nrm86+dOUEtITxHnKuulbRd2C8N/N/FTwwiON+nQXDKxPQdi6EknTMgdRDOzPjjV701xFq9eMieyX6Uezpp8Dr73/draJKImdX+TXbx7/7pWkJ0buYrOVrXAJBJ4O4N9Dvk+SbpLwlTbb7PppK7ISlh12cJISoI1cQVbcBaVe6W1PDtGqfhOyG2J3su4VCu3WHzxFzZdz/Bcj4yYnpc92Ddi2dovEeLXo+dz5sMKQkH9rpu0LM/0ntcgZzgL1B4VaZlqRNLA5Z2JCvkpoaMheG/ba91fX3MV5U2caQ6eZb7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 21:43, David Hildenbrand (Arm) wrote:
> On 5/13/26 13:54, Christian König wrote:
>> On 5/13/26 10:37, David Hildenbrand (Arm) wrote:
>>> On 5/13/26 09:47, Christian König wrote:
>>>> Hi David & Thomas,
>>>>
>>>> ...
>>>>
>>>> Exactly that is one of the major reasons why we aren't using a shmem as backing store for TTM buffers in the first place.
>>>
>>> What was the problem with that the last time this was considered?
>>>
>>> shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).
>>>
>>> For internal mounts, it must be enabled accordingly
>>> (/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).
>>>
>>> Some distributions still default to "never". I guess if an admin enables it, you
>>> would just get THPs.
>>
>> Yeah, exactly that is not acceptable. We have some customers who already use that approach through udmabuf, so we already have some experience with it.
>>
>> And I can't count how often I had to explain that it's a configuration issue and that the admin has to enable THP to get decent performance.
> 
> A lot of concern with shmem and THP is around memory waste.
> 
> But the DRM use case of shmem is really different than ordinary shmem usage, in
> particular when it can steer the folio size used (and better control memory
> waste I assume?).

Yeah memory waste is absolutely no concern for this use case.

The problem why THP often causes memory waste is because applications tend to over allocate and the kernel compensates for that by doing on demand allocation. In other words you only allocate the memory on first page fault and when you switch to 2MiB allocations it can easily be that you waste a lot of that.

But here we explicitly allocate X amount of memory, so what drivers do when they get an 49MiB allocation request is to allocate 24x2MiB and then fill the remaining 1MiB with the biggest order available or just 4KiB pages.

So for this use case here there is no memory waste at all.

>>> If "distro default" is the only problem, I guess we could think about how to
>>> improve that. For example, just let internal GPU DRM objects allocate any folio
>>> size available and supported etc.
>>
>> Mhm, that sounds not so bad.
>>
>> I think what drivers really need is that they can give the order to shmem_read_folio_gfp() and get a folio with that order or -ENOMEM as return.
> 
> Is it really helpful to fail and not make progress on a fragmented system?

Yeah that is pretty much a must have. Background is that THP is a best effort feature, e.g. you try to archive the best performance possible but it's ok if you can't because of fragmentation.

But in this use case here the caller does want to kick of defragmentation and wait for it to finish before you fail or fallback to smaller orders.

> I'd assume you'd want the largest folio up to a specific order. Not larger,
> because it would waste memory. But maybe smaller to make progress.

What is possible would be to give a more complex structure than just order+gfp flags which completely describes the requirement of what to do before returning memory.

But I think that this just makes the interface more complicated for a rather narrow use case. The gfp flags already give the ability to say that a certain allocation can fail without a warning and that seems to be sufficient.

>>
>> In other words we need to enforce it and if the desired page size doesn't work we can then still decide if we want a fallback or not based on the use case the driver tries to implement.
> 
> In which use case would you not want to fallback? Would it be something to
> tackle separately later?

Well basically every use case which wants to guarantee rendering performance. E.g. everything real time.

For a simple example just think of virtual reality, you rather want a black screen instead of laggy rendering which causes motion sickness.

Regards,
Christian.

>>
>>> Would that make it possible to just use shmem natively? (e.g., how would this
>>> interact with shmem features like folio migration, would that be workable with
>>> DRM objects?).
>>
>> Mostly, I mean there is still the use case for UC and USWC memory but at least for AMD GPUs that is mostly negligible (we need it for a handfull of workarounds for HW bugs etc...).
> 
> Thanks!
> 


