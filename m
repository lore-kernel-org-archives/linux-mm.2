Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E0BC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2806B008A; Wed,  5 Aug 2026 19:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072D66B0092; Wed,  5 Aug 2026 19:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EC26B0093; Wed,  5 Aug 2026 19:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03816B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:30:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EB0C160199
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:30:54 +0000 (UTC)
X-FDA: 85068813228.29.16CE5AF
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011025.outbound.protection.outlook.com [40.93.194.25])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E3CF8000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:30:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aeLh2LTR;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.25 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785972651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Vnb3mDPGhiqAz5H2pGl3XQDYS5tAoP/c+MTxiTwzjc=;
	b=cTmcOWIukGhy/JRdrPqcz9VtIXLYLNkU8iW+4kdFKaL2DLpwHVUP44UDEx9yuPoioHcqhV
	RKSb9+xm6f9P3rxpA8u9kANRGv4ceCQ6QfLOa89lR4frSkQ95OPAXxtaJVNIkbUSdAxOs/
	JkMvZihMGrcVbdCwhMMOdrtxIixniv0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785972651;
	b=RvIObsVnZbkDagdYed5vN3ltwY/AoDt0/VtHvvJQA5/58ap3wK/yJ9IblCGd1Zd32Y37V/
	LRltxAmm8Ye8dNA7N90npEaToO5S1zvUoEtMHw9kuj2twHgaus1984/lmYIle96YqnnT/m
	xFDBSZadfVAwzhhu7+yDCsJhl9C0NaE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aeLh2LTR;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.25 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=osMQr3432q9GLGMfX9LLJvtnAcf4c8MI4vBg69dSmSvCTgFHBzEDZy/oKvKnFpoQnbNyWJl0hDOkCQrkrZzJRnhPiZdXLCkE8r6ljjEpv27piTWQt5K/bFeEYwzJqfuXYaTb6pLM43hmDmTwEWKsc0nY01ObA43HEQI8LRVdoYnSKSCL3ntW/UTr0YK3Ajd2q/s8aEFi0/t1q0zp8xMg19DaPno1isWdgOpeh/s94i5DFjb/4p+x4ntgb/o9ydqaSRw6Ht59b5bxnzzEpduRqN4qOz/mUOUqP4Nm/1x/wQWB5Vwd6AXS8tv6SLQ6i5vpZ/HIb1kxfv7K7zIhk9DE8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Vnb3mDPGhiqAz5H2pGl3XQDYS5tAoP/c+MTxiTwzjc=;
 b=W62A0OQIxmGgKLs5NVYBAv5SZl6lDBzyQTuYemjOtPA238IAouagRYiZ5speTxuGqklxKy1pANWBgCANR6AA5kvvt7xdXJdZqNcH9RjqIUeLYb+6njvJE5eIukOwA4SURc/jz4c4WCXfoMHn0NCxP0w/FYNiHGi7w5l0quQh8COVOFz8G4Khn1ULJn6NRyGHYW0T6mLvuoRcwMkAPWZ9b3xvMFaVUdQfOzUQ7bS1OcT9/tzsu1hOgBOzHySFQVNqBSK4zlzyHN3agBt3RPHnIHA3z6ZcmJ+65te2lP+h6RY5dnHGMAkWpamSJ4SOACRXhcs6CO09pT6R6owY+4o+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Vnb3mDPGhiqAz5H2pGl3XQDYS5tAoP/c+MTxiTwzjc=;
 b=aeLh2LTR4pYLfrRhhoqEqUetqw1l+X6ucZU/KSEw5DOATnM0R1GLTmDgpMRFbwBf7gA2VtvOBy2gLf3mgTWqiAq/Qi1MTDof2bz//TNbffHnycb7mAfW7ofwxdxOMF87m4eOB8YZehark711hCQIHfIPpb9O0zVTlukZZMeDTy2duXyBEnLpDdDvum1+cyyhz450P5Tnnos3fDygJ6m5qbVc8wfa/5SNHqL3z/xGfzm3tsp/0INS5ZOzsSNgPqSNZYBeHv9URPOwc7magv9VyMeQL5/I+xDmPKZe82WnwpeWy61S3ltkrTlEt2ugAUVc4MXCWBFzcRFfgupytV68XQ==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by CH2PR12MB9460.namprd12.prod.outlook.com (2603:10b6:610:27f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Wed, 5 Aug
 2026 23:30:37 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 23:29:32 +0000
Message-ID: <9d0dd5ab-8d30-45f7-a523-90d3df8dd5bd@nvidia.com>
Date: Thu, 6 Aug 2026 09:29:19 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/migrate_device: Do not write past the end of
 the src_pfns array
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Francois Dugast <francois.dugast@intel.com>, stable@vger.kernel.org
References: <20260805231041.3791771-1-matthew.brost@intel.com>
 <20260805231041.3791771-3-matthew.brost@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260805231041.3791771-3-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0091.ausprd01.prod.outlook.com
 (2603:10c6:220:1ce::16) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|CH2PR12MB9460:EE_
X-MS-Office365-Filtering-Correlation-Id: c60498c0-c280-4cb6-d06e-08def34966ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Xr8EBQiox+wqyJH7Udv9Ja2NFezwTYovpCCe6Q8DzdcBtCHRUyHi80/mWvd+laPg15EvJJx6mcyAlOChO1kDFGyP1RxknbtmF89DmES85awqdZx7G2mRDRCdFWoAcVGO0Pp+3r1TMF1ibClLP232NP9/BD6T0XyQmI13VfvU9P2P9A8iiPweC2LJK2x06QioXXAoYoW+u/6yK8Xwqqfx1ROgDZlsXj5dtQDwumSKdyba/tXu2Pm8B/y5J8+xBOvhUayRAPk7qBXVeauKwDmCszlKI4GWDg/HuKmrIrPhzy5se/LZ4v9f5/gWSdK8+bYmodXbQqkj1sHjBx1IN7GfCyBxFdDfBL8LafG8Hk6u/2Kv8RQLEMzdiU4/2GFHa/YC3l7TpHy/aYn0WXA8YTn7QcC21aOagg9FLfxDXSExsgFADACzZhWLc5YEO3PNLgn+p+AaK81b8W2gjNmE1r17t5orxs+X3piTSgLdO24PWHJ8iIsJt8COFmHkYkaxpDLBGdDY4JDY2NJHprbunn24BZdhe9HCBlryE8p3STUnSS6TCSOlFvgxO5dMk9nSgF39bOb4KtpwkDM4OJAEnADuEjJja3waoyq33BsL+wbZp0WbsyDGc7N1vv644AfnsqX6cG0ccJDohNoygyQuL6kA9JQ7HPWCFL6zHlgWt7KBxi8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXJLQnpDMjJFTWFUQS9kdXpnSGdvNlNPOVdHNWRMVVNNcnJmN2Z3YytCck5B?=
 =?utf-8?B?SStoNDdOVk9aME1XODh6RGVtSFJJU3pQdzl0NWtDL1FZaHY1MUFXT0s4THVZ?=
 =?utf-8?B?Yk8rdFNzdEJWaEozalZyNjF3ZXZuSkFXWk1vNUMxSzd1MHFDNDJKZ01KVW50?=
 =?utf-8?B?SWVmZlhkd1JMelFYWkcrSkFqSHlTVWdWdnRNWkhDb1IwSk5hQTlCeHg4Z29E?=
 =?utf-8?B?ME54YXRNS0M5L2ZYNjE1dzZaUE9IQkluS2d1aWZwWXFKZDZUNGtnRDBQelM2?=
 =?utf-8?B?U1luUkZOclpKUitsVEZHWWY3ajRBTzNJQ0prL3UrczNYQmlqWGt0UC95WUkr?=
 =?utf-8?B?OThLblJXTE5lVWVvQjNzVDZmaWFBK1FjV2ZhSkw2bktVajB3SS96YnlTUi8r?=
 =?utf-8?B?cUVOb3lxdUhXRklaZTBweUtlQnRIWnR3eHpoS2NZVmpvU2FyZk83cGZ6bUlt?=
 =?utf-8?B?dlpTQ2ZWZnFHcis5V3FBb1dPUkE3czNOVHBsNGp2WW5TMzVQcmp5L0piSktG?=
 =?utf-8?B?SkgvUUlOeW1xRHNiSTFVTUozY3lLL1drUnZoWHZwd3o5ZlY1UGpUdmlxZ3lH?=
 =?utf-8?B?T3hGREtoSllpQnFjRHVKMlpja2J1YStLaFM2UDdUVnBZd3RBOXpOUWFOMHR1?=
 =?utf-8?B?bjU3QjdxVHNJWDh4LzIxMk1CeW4xaVg3cjJqeU9LV0NVcjVKZGFRd1lGTE5Z?=
 =?utf-8?B?T0FaeFpWTEtURkpmV1RkVDU2L3VJTlM2RzB1bXkxTHJ4K2MveTNzaUx5emw1?=
 =?utf-8?B?bE51OGt4dVlOS2wvTGdscWFWTDFYKzAzOHpXdHBocjBVVGxPWXZ5bmFHUU1E?=
 =?utf-8?B?QXkrc3dONVdxV2xhVDdwb3VKSzZEMDBZNENjZjZHNWN2YlRHWnhqTXB4Vmdh?=
 =?utf-8?B?VklQRmZIaThMWW1YQTNpOHdMOTMvSEhMeTFoU0ppLytxanhsVnRvckJHWXZG?=
 =?utf-8?B?a2xNa3lXUWRJT3FNK2dPZDNNeGRFeEhGSi84dmhuWGh5dnU4UDJzSEYwMnBE?=
 =?utf-8?B?amltUXFKTHJGRnJZVUxsU1c0bVJtS21JSytYVjVaRGc3SXBEVE1RK2VoSXU1?=
 =?utf-8?B?SmhnN0RLQXI1T0l6ZFJnYUpFWThlUktiZzlpanZxRjNMZnNSNzlycHlQSWFM?=
 =?utf-8?B?NjhlWG9JcERlbXZMODRYbmNDZmZmRlI4S1NHTEJuMk9uc0p6OEdnMmJ2WXNZ?=
 =?utf-8?B?VG9LaXMrL09RVmt0aXdGMXJuTUwzN2IvSTJDd2VpNzJCNkZnZ2hmZURPMlBZ?=
 =?utf-8?B?OHFqdGdxb3BhdnFwOEtLcGRJRTlQM0RmODluMmZtajU1eDE5TlY1eWdNdzc0?=
 =?utf-8?B?MmcrSDRjQXBBYTBpMTh1d1JBM3M4Q2x2S2tiVi9ER3ZBM0k1MWxrQnR3RVBy?=
 =?utf-8?B?VC9oeDJOaFpTaWRzbUJSQTZqdkt4UUFBTEdjYzVWLy9QQjlwWE16VVF1UlB2?=
 =?utf-8?B?SWQ5d0VnZk9CV0RZay9vNlcvWS9PQzJMeXJPSjFGTm1kS2lSd3V4S1FrM1M5?=
 =?utf-8?B?T3dvT0h1M0ZIc3VSVHF2UWk5UWJDbWk3MDU0eFJ1UFMxUkhGc3dnYnhFb3lS?=
 =?utf-8?B?a3NsWDY1dkZyQnAxNFk0TUVMSjVzUlhkbGRSK1FOdGpyRnJIcVZFOXk5cUxP?=
 =?utf-8?B?ZVRnZzdUZ0ZGMUxVTDR1ZGdQYjFqU2NVa0F3QytYRXI4em82WkwzRDErL1h5?=
 =?utf-8?B?Tm53bFBIVVNJSHZqMkR4UzBxN2pURFNVWElubTEwOG9BWUhUQVlVcXRJaFRp?=
 =?utf-8?B?NkFwT05HazJJWkp5OFpNeTRzVmNHSVBlRStEWmJXbTlEMUFBc29zK3JjWnVq?=
 =?utf-8?B?dDM1VUwzWkZ4T3dBazVoem9UTE1OYm4xN1VUVmpjRHZ1S0pva2FOaFlsN2Ey?=
 =?utf-8?B?N2l5b08xOGhLYlBtd3cxSWxWYlRTZ2dBckRkQTRicElxU1Q4MGY4Tno5Mk5P?=
 =?utf-8?B?bktTQUNvK0FwYXdick5lb2tndXZNZE5GL3pDa0VoakhhTXBBd0cvL2NOT3Uv?=
 =?utf-8?B?MEhTaU1za21IakJHa0Y1QUo5N1h2bzBtdytDM0E3MkgwVEdPQVNOdlRjb0gw?=
 =?utf-8?B?V0xhcFNaNU5EVmlwQkY4M0czaDdSbXZjUEhaRmpXeWx2cHZWZTkzM0RCVTlC?=
 =?utf-8?B?YWcrN3VEM1h0WThTc29xVGxxK2s1cU9jNWhWaEJ5N1NpWTJEL3lURjdkQzdw?=
 =?utf-8?B?OEo2dTBYZWE5bTliM1RscGNEby9tWDRKNUhVYksvL1doYXJCZjVER1ozaFdy?=
 =?utf-8?B?cUpqSnI5Nlhla0tTTGlhb2hLNy9QOFdDa1NnQVN5R0Y0bHlKQzZaejBYQVhV?=
 =?utf-8?B?SHhQTmxMZ3VQc251RHkrcm5SbTlIYnNtTWUrUlJDNSs3dE1OZHQ3UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60498c0-c280-4cb6-d06e-08def34966ca
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 23:29:31.9423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZY2MxpiBh+ZqMQ3I1IH5IDUUOu+l6ogQ5k3nZbP9YEgktBGtHUISGZCcYGBXoDhlF0ryKR+67BEUUrCN+GpfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9460
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: s7zqf6spsw7h54cnw95ty9ge7w66ty3t
X-Rspamd-Queue-Id: 2E3CF8000C
X-HE-Tag: 1785972651-53196
X-HE-Meta: U2FsdGVkX1/hti5iywqa8PfuU7DeeJwfgtRBS0RY2qHH4Ug9Yp9+Sxjv+VZnGp6sNzhKt3IFBUUcMH6rAu4rMBeDXiF3sIN9Kj54DuUH3fQddP9Lk36lFa11cdeENIkIzZGG7FTpK2Jn6CsCRlnviP928rYwJ0/UkvrbM33ZvBRoArb2/xuGa5VAXmeTRIqkU57flJK11nCiNS4XtITc9S/IX+aThyAKNuSeiUMwfdwff+RnBfifwqndgpvSG+sDrnWwU1CZ0ewXXVrfXoHGN/zhySZOVf4EBJ8aBwuBIgNxkNPy5FAiCJacptiiWjulNgJ73FhVBwpkF+mmX32CDWeVBAAsWCX/YTFtdOjN/Kt1/+qaYU1Kfijyq+980BdcQnrR+UHyDMi9bzRJTUo4nV1uqZVVq9zvzJVeOlPeNZOn8W85mS0GfiDuVguEdAQtLwBKtayhGluBvZNIlUzKG3TKIqospLhl+vYDUZz7kBj8/sPO197BlyyppNAwJPdxBIiBdtlnndCGInYwqZNSWVpzfqVS4C26mb0TWsNC6A1gFtqjU42HOxCklVa+X44pFyidkYdjGkDgIUIDJDz81dedEnf66zKWyRCWuiztYjNvpXKc7YPssY2T2XimTTfGKCo7dwRxsSJYsl9PIGsWAZL6jfQbNcdeEEUMbSN0c4ItJR6qq4bOrbseJ07/xhiFi4ve6w3XwpjP6gX6mh2ElHECjkHKsgFO1Pjknqdt+6cCAwByzX/FUOWFM4b0YNifffMhdHQ3yj/BdzczJ5+e4QzMgidpCnIMbXdrnc9K9O9A3fuDQXP+JTZiwNvf67vsvmxSJ9dOpLXafVWo6kMIXF2d+SZN53v4kgG5WKF/rsWnXp1+i3A3YawVU1PGfvmBYcCe2xkpn2g2dnNEjQT/rFqIoHuLb5kWk8tRZQc2NPOeD191KycHcdTGpACdkVyDsNd8S86QRtp6v6lrws9
 c0vFi4PM
 kLm8EmTacoquAspT1mGQGYBV9XoI1XJkvpiPaBFDwrspi50nnJrnmLRQYSIq6o0CFMpyxVza3doP6ITazJ40BnbOhv6bjQuIRs9PadMUIYp3BcOsQwbo8a9dIRjW5j7ZCVQJnKq/9IhDyEWmPD69EKeLl3gl10X0fhR9L5ABt9NycYSl+3mN6757TYRuPlYySZ9hD3XqjMYzzsid3b/V2nU/Qw/zXKfA5/5/8nSyx4sy5J5MbSYnCx4ddqNG8KFckFdQ1g2HGO0uVTwPd9Tdxf5/2aXFODShdxyEGMBptZIsOgca6K3o3+iOasewHgI9bNnwkwZ18OX3Q59mCNGyt6R8tsBI7hTYpKS/GWB2Bcs1zCfaIFHqw9hXrhDV3kARp+VpLid9akNPlBZoSnYgS359OAJYMcmKv4QQ7DNT1bKrODrFi4Q6zG3XeuJzqewq0tK9+Z1rALf5GbVV53eL9Q+kiVENUDvGQzPDzI8/TEm/R5Gdw5Z40HBfjujQdQEhVEXoeho2efIpNQi98BEQXW09DqW9rzyGRiHVA0Y28aY5v9MgM95lgOsixiYMsf2og8XVpczW7XNn36M32qnFbbCFmLLByDK5bgGUxvchilmlzn4OtCd4J67cmRGlWgF9vOftTpqwdmdmQcTCXlMn0juDfW4RzHN/+2D94gdndiwN6A3JBR3EwklDhw3sGgvNlVbiPHKvlDb43YMXSSayMk6wMPZ6Xm9c+Xg0BYfGweJvau7IMkWLj5OvsdPRrJERX2WrCMHdFpkjLOKt/qzOobLYCqMsLyJSoBmBWHkm06IUWKlcuuVOjrYKdUcWgCmWLQpQJR74mGQdVcu8s/VRMXul0rNmH70E0GMEk0esjDH49Oo/+Smvhrozb3KYmiwlzUUUpV21wv+wqMQAxvPdFkNwTA1CW3ONZUvql1SyPCOI/ZKJUJ3C7aOKY+wxEbXcTKPHLPdQT+JNTSJTc+mKfCEjxbp+f
 zoV/3X7g
 OdycB/OeRmrBEjoqdPqPdEry8tivs30XhGPCAVGVQo9GTCRyZMiSme5ROsl2dRi7u7lU7dwpxEsEsezGXtH2CPAgkNynazE6P6gfuSJZywy+Sc/5ToqZwx9sLNNjY0SK9MxdqI6qHXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 9:10 AM, Matthew Brost wrote:
> migrate_device_range() and migrate_device_pfns() zero the tail entries
> of a large folio without checking them against @npages:
> 
> 	for (j = 1; j < nr; j++)
> 		src_pfns[i+j] = 0;
> 
> @nr comes from the folio, not from the array, so a folio that extends
> past the end of the range being migrated writes beyond src_pfns[].
> Callers size that array for @npages entries, so this corrupts whatever
> follows it.
> 
> Bound the loop by @npages. The subsequent "i += j - 1" still terminates
> the outer loop correctly: on a bounded exit j is @npages - i, leaving i
> at @npages after the increment.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Assisted-by: GitHub_Copilot:claude-opus-5
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>  mm/migrate_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 162d29b2807a..ae9027421b80 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1415,7 +1415,7 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
>  		nr = folio_nr_pages(folio);
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> +			for (j = 1; j < nr && (i + j) < npages; j++)
>  				src_pfns[i+j] = 0;

I have a similar patch lined up in my clean ups (that I am yet to send out), but
the patch was more along the lines of

  		nr = folio_nr_pages(folio);
+		if (nr > npages - i) {
+			migrate_device_folio_unlock(folio);
+			src_pfns[i] = 0;
+			continue;
+		}
+

This prevents partial selection, migrate_device_unmap() does take npages as an
argument. We could change the increment of i here to skip past the entire folio.

I am OK with this change as well

>  			i += j - 1;
>  			pfn += j - 1;
> @@ -1449,7 +1449,7 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
>  		nr = folio_nr_pages(folio);
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> +			for (j = 1; j < nr && (i + j) < npages; j++)
>  				src_pfns[i+j] = 0;
>  			i += j - 1;
>  		}

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

