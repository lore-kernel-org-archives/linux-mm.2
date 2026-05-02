Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D46CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 00:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68B56B0005; Fri,  1 May 2026 20:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B195E6B008A; Fri,  1 May 2026 20:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1256B008C; Fri,  1 May 2026 20:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88FA56B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:59:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22D10C183F
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:59:50 +0000 (UTC)
X-FDA: 84720672540.12.C3DF383
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by imf17.hostedemail.com (Postfix) with ESMTP id 419E540005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:59:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A2Rc04L5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777683587; a=rsa-sha256;
	cv=pass;
	b=XqAdzQC9QXZZMSEyP9MQGYjrCE37iZcGw0Wit/EtgWQGVHyvUp3QvXeSoE2gB/QSlwW/mV
	+P590prK5m9c8/OxX6YcgNkT0hW0IfBDcQk032fj/VKLTo1t5+qHCGL1jsOmuri+D+7JOk
	hObzYqsDAXKH2mIME3tRuBjD8WUwO/A=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A2Rc04L5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777683587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVBfBacp1PgLFHHnvX4pjT1PRJoHjpOWsK1F3V4bFRQ=;
	b=dARiWGKduIYmrRLtqWNVPdv8I4PeUs98j7AkXj2UBMLVp/fVDEiIQxxo0kcDLRdbIRxNti
	MPJmZyL+rKrbmyFVjJsGdgtPp4dMNhjmRq+Hszb+k2YrtreRVLNGN1uAzotNre5+ns8aWu
	ue72jdDcB9BHWBkAkfaFGpghMCqddjI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccmWx12fQw/ofR5g2qm/aaWUnKNIcWBk5GW5C+D1xOwh5y1wgcejTn/ZBVn7ej3u/Uk5bfG3DgEPPgjH0LWjVwsG6zdgfu/gucz5SSyJm9sn7hwd8iBi33Lwpu4N3DSJJ2ucGGASXwmRJHkMv2qeJ5ivjE/yfFhwjeUeBWEeggGjvVKJVLnWN15L8WoVF4cPuUgdwJ85VPvom6/wY0/W/1Fk2FzWmSI30DDtQUv9QoCTMXcFGFDWfu/EbmX2czeLfU4s++/j0ptOfhVyCmjYeRukh/nld7ulwIaqyY7S8i6GUuy58tT8U5eFEXAu3V2W/jxfrDUD22D8UzSEx+zL7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVBfBacp1PgLFHHnvX4pjT1PRJoHjpOWsK1F3V4bFRQ=;
 b=ehWSMYvIztdQ+ts2yue5kXi7RMjYDrndjOwNWhABxA6qHsCWSFQX1xZuh0tsSTc1vf++L95nCXrCHfGQKt9+1NiFRL4hjUY/fLh6jCADPvRN09OnoYv7CvBlH/TJiy5iZ/TGO2Zr8TbFBlfJ4E8IUFBCLKmX1p1Icf55NnbYL6OmDQu8qxeDT4s/aqXB+lB+kcsTtvrCcKdldHHb5Sizo2DZL5CqqGLLzJnpVoMSIC/S72qk/8HFaySyICzFszvoJqcJ53WEObg5O9pOfu9JfKpRnr9W+KHb8SvCsyuAmNH46l1BzOtQOtTHy54WduJNZZCZsjvkY5wc2/3i9hLXfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVBfBacp1PgLFHHnvX4pjT1PRJoHjpOWsK1F3V4bFRQ=;
 b=A2Rc04L5l3RzU9hU59824ZpZ+wMTNPtQxDgb34HZum3Vu81kQRLUMO52NL2vfYksGAHqIVs/I9jvHjapcchoa7Zag1WMIgwr83E/TJ+YZR+qHIskYVJYr7PIlvlZoeh5+naRrnTpiB5Xqvppn6fT6ROPXu7SnK9Nc5Lka74avCvZSTvqS8oW1tNMbLBS+XHaqYhh1R0EP8kffGUCi8ksYRrWXx03bRQpdVYiMg7c+lSUDbIwc5pqiPVW5dgKhvCVh/hGtj5Z7zETIx2A8x49lb/0x1YhPX3nw4JVeu0FY0hHjpJwYojFPnxthzmPPk7Axnre96Az3gKM7P46AY2mgQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Sat, 2 May
 2026 00:59:42 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9870.022; Sat, 2 May 2026
 00:59:41 +0000
Message-ID: <4c3eb1b4-1ea6-46ea-b04d-b218ef266c7f@nvidia.com>
Date: Sat, 2 May 2026 10:59:33 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
From: Balbir Singh <balbirs@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
 <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
 <5b25ef69-ffd1-49f3-a340-db70dcc96b29@nvidia.com>
Content-Language: en-US
In-Reply-To: <5b25ef69-ffd1-49f3-a340-db70dcc96b29@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P282CA0109.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:235::30) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: b87b9ada-17f3-4b55-a040-08dea7e617ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|10070799003|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	G6oueGoc3FExF8+Azim6ZXkH1MJtYKvux+Ual/o8ocxdlqslbMW1+/8YcJB6se3Ig8ASm6NJ8mszXPr/BnV6DFXFHICMG1kjBIQC+D4wAk7ZNo5xOhNoyjwYaHcazMexBpCTqzjM6POKcSE7am2YZabR1XDVO49xVYfdPUcqmkHskpb/CkmAqE2PE00Yeg3WG3HK1/h3ETFNkDeVS45zHw//xYD6OyxL/XtcdJzWVOFMDJ2QQW94WcbKtcEwZJquQNIb0mGVjif7A7qoaJIHc3fbvUjwlF6qVpdh0EyVaIGg8AUcL4RrU3ldv1MCkujf1iczOT/Azi4bM2+2hCCyK1rhZ8miTOC4Nj5ZwGoNGo8w14MPhKmv7mGRGZHztWr/tSkFuDMr2xGz9Pi8QsZspAIbZIK8TB6Jep7TAHDgPNez1pNv1IWnfeVI9BeNXn25nKNLUx38cuSsUz2ssTkErPg3VaTOaol2KaNDjffFoOTQW1/kTTX/18ygO8Uxh9tIRs8IbFWznEHOck5Vm1pGSUGYfpFV5c4gbYFGc0ZK9qK3pBXdatwT03W818UEEhQrl7NBonufgbYr/LCNKsspWJuENQmOo8GmvdGMT3ZHur84Jkq0G7bFaw30egMdCV++RqQxU5AUROs8DC5bv9scncMCDRHyWmZdPTDQ62I0POoLNgc5QrR/bbAnafso+QY2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(10070799003)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2MySW11UzJQQ0xlUkRZUGJXM2RNZkx3aVRJdTc2VE1zVGZ2eUduWVZtVGhO?=
 =?utf-8?B?Ri8xYWc3SHZkRDdQeVdDNzAvOXBqMDJyL1AxM3JXUTFpL09lQTJlNVhmZ0NB?=
 =?utf-8?B?Q3VVTHEzYUt0cS9SbUduRHhnUUkzcFlDNWh2WXZ0N29LT1AvYmxhV1RwWVZM?=
 =?utf-8?B?bmFsNVh5bEZoWU9rOEFKRVRkRXRaM1FMQjhlL2RydjhzZ0tGSXVIaWgxWUlH?=
 =?utf-8?B?MGNJUEQ1OW9FNjdaSlBBM2FaeWZXNkl0SnMrdVF3REQwZFc0SHJyWmJ0VC9y?=
 =?utf-8?B?UXdnckd6WDdSdktRQkVpUUlTQUtRWjRyc0xVSGcyaUxUUjlrK0xYTWdmZk5Z?=
 =?utf-8?B?WFR1SDlpZCtXYmlyeEdKOGVFTW9ua3BOTldFQ3YvMWxJLzUva1gremZKOHRq?=
 =?utf-8?B?NnpYNXJhNWFkeVNFSlpRYmZueS92QkNmOG10VS9qckVUWjkxWHQ4TW51ZHJQ?=
 =?utf-8?B?SXZlZnJMTkVjK1pwbHRlVlFvTXpTSEhUcmtMaWQ5OUFsZnZ2R2dsN2JxMUpw?=
 =?utf-8?B?T2poQkJKM2ZISXZFbkNVckRITzBLbU9vVG1OVHYrWkhNc0JDTFVRa0FHekor?=
 =?utf-8?B?MC84RTNFOVlwWjBoUnNHdFl4RkRDdEVVdHFXSUV3OWFBZEJmU1VEbSt6a1Rq?=
 =?utf-8?B?b2Z5Rjd3ZWhrR0ZxSmIxNzdTbHNOWUoydFRrbVA1M1M4VVBGYlVtZTJISWI0?=
 =?utf-8?B?S0RxVW43RUlhaUFYV2pmOUJjK3hJWVF4QktBZ3l5ekxBV0tFQ2oxK2RUc09S?=
 =?utf-8?B?T1hhc2c2dVQ1VEFOc3NRTnN6RG04SUl6RWNpTVZ0TlhIbDZ3dnVNZDRXL2pP?=
 =?utf-8?B?bEUxdDBmYkFKZVFPdXhWV0s3aWZ5bDJ1WGxHWG85Mkp3MlJ1ZU8yU0F4RXlP?=
 =?utf-8?B?YlBYK0NvVmVpRWpIaVhnTEVXVmJqMXdwejRnbzRkVEhnNU82Y2xGL0Z2RXhm?=
 =?utf-8?B?dllrRENoaDJjcHdaaTZFcW1yQ2VoL3YwUU1GYnhlNzJaem53TU5hS2laNXBJ?=
 =?utf-8?B?QXVVSjRtL0I0c0ZycFZzU0NXd0gxN3V6bUtNektNRE1NYmh4OEFCVUVWdWE4?=
 =?utf-8?B?N2MwSHRoNDlua1RxbVI4aWp6dWFLcnl6UTFKT0RDOXZyL2VRUW4vSGNERjgy?=
 =?utf-8?B?dmlsa25NaXg2N1p4aUJjOFBOQXpBQlc2QlE4RU96RXJxampJRGdMMHkyVURu?=
 =?utf-8?B?Zm9adnE1dWd5cXRaTXJHOHhaVmVDRVdhVjN4aDI0a01laDRTMTZOUnBUUmw3?=
 =?utf-8?B?RzZsVWo4eEIwREgvdHhic1lZa2JqUGk3V3JYdkNMQjVCb2tIWmZNM1A4SXFM?=
 =?utf-8?B?NE9icDZUK2pvSHp2MUxBcnBSS05neEhkYTRvdWRWRTBoeHQvcnZXdTdua0ds?=
 =?utf-8?B?WEpYaWQxRkpZZkMwMDU5SHFweGlsSDk2Zmc2enNPOVd4cHVzVkxGMDYrdWpC?=
 =?utf-8?B?d01oelI0M2gyMjBDZ0VoRWZXV1VzeGE4NDlpOXoyNnZMZEdvTFkvSENUQlRr?=
 =?utf-8?B?R3hnUTlDcEw0RGdIZW1CRnFjQnZSZlpMTUozQUNrRis0NmM2T1lnMDFNSFBn?=
 =?utf-8?B?WTRuL255ODVaaXBlaGtUSEFYRmZxc3FMNm5yZHcyS25mR0Z3cUdyV3hjMVIw?=
 =?utf-8?B?NEFLU3RsdFdOTURvWUphMlVDUVE1S2xobDBsVlhEcHlnWHlnYmJ1N0lRaksr?=
 =?utf-8?B?REVkM3p3M0V0anI4MzZvMlJGREZLV3hPNWlCdnVBUTFHZjZLQ3RxQnorQ21i?=
 =?utf-8?B?bm9OL0pNOXgra2hKdURwSFZ2QzVZaGlWNEhvdFpVcmZrSzVDL0d0aXZkV3dG?=
 =?utf-8?B?aTBsNW1ZSUtNZ1I3R1JFdmRFL1JuT3dPUW9JYThqSUdxNkg2Ykp5L3pTWFcr?=
 =?utf-8?B?VmFsVmV1T29LZGhZZm1lRndYY1FUSHlSZWQ2LzVBT1RmbzVmaXFQbjRkeXVm?=
 =?utf-8?B?aTVjczd0bERyUFFrMDBrQTBUV2hobThicFVTK25jUG5zZjdrUW8veGJGa1hv?=
 =?utf-8?B?MlFncHI5K0o5K1p3VmhSbjJhdTk2ZjRYYVBINXExSmxkNXFxRm1lL29VeW42?=
 =?utf-8?B?UVRqcXVXNnJkZ3FneXgyM00zKzVhUjJQWUFhMTlDWC9veXZwMkplQllORHQ5?=
 =?utf-8?B?WEh1QlZIMFR0L0p5bmE5ZktjcDRwbzJBNEtGUTBKTzRYVnV1dml0U1hIRHQy?=
 =?utf-8?B?T0VDS3RPeUI0SHVGS3RRMXdiN1Q0U0xrcjBPSjJTZC9BNkMyYUtabGFST2Rn?=
 =?utf-8?B?cHBvMFZtS3hHbmdBVi8wMUQrcDgvSGhYbndidklEUmp6N3Z5MXdvU0JhbnNT?=
 =?utf-8?B?TkdGUjhwb3NPK1BZYUxoVWdmU1ViUlZVQkdWdm13T3krNENHKzFiMkd3K0xX?=
 =?utf-8?Q?CnEyt9C8qdkDphjnBoNnZGBxaoNdJpsfv+36Uo0d2w2mA?=
X-MS-Exchange-AntiSpam-MessageData-1: 5q5KZKcFtYQ0QQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87b9ada-17f3-4b55-a040-08dea7e617ae
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2026 00:59:41.5807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FW5MRu5hxZ/W5fPgCxSlGEpRoomtPfjQi62Ekcqt/26S4KBMGRQjA8H3JWcPfUztXSfRPXMhGxlPFMEoHtbZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851
X-Stat-Signature: 5e3a7nsiodjnz7qgeqdbf5dtoepik76t
X-Rspam-User: 
X-Rspamd-Queue-Id: 419E540005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777683587-438515
X-HE-Meta: U2FsdGVkX19qJWxLEHTmUPJ2d9Z/mLdYOLfwZ3SOkzH/mDKz418HXdPqT1wGPx1fEigjf3gV5evc7IuXapNe5jBGE03MdoCnCz8YNjxmeblzVJmFS9N/4SalHYKO+tUEMAFMDXRCxJBa0TC5FVTg804W4u68y+2+LHuM4uwpTDRsIhgv4kBH8RFv84kxwrUqUWZJuNuBc09oAICLesS+btDw+LCmen8CI5Er71r73en9d16P3Xpx86R+rpXG2GqvPv3ZwyIiUy2j+rvdYzYeG9pMRGCOP7eWApAIt3GwWA2TwuCDC9Ff/ggRqYb3PKsdBxUjXFSYv1v56VnGPm9pWOWtjyUJ6NwwImF4E42Q5j3JU6ye6J/znauCh8Hw2oPu707iq5/r1HsC7QGlhL4F+RmVg8s24m6dgm/BGfjutZ9ZLCKsSv1C/cA63hpkU857TPEOH4/DQgY87OhRbLb+upz0iHwEpmNGJGU0XG2RnOpM9IwACOTI4lWuiDx00ILa6iPAiRehUGki49ULMqfqKEIMEcU5a1NKfMg+NqYp6zl4aYNDMkpKRBXi81SE+xJE1L00M/c7ZwA2htmioS/HBo4x2YWOrDgFfZ3kgPFjRxybQ7TYL8chwB6Hred1Te9H9jSJz4JXK5iJJ0jwOZzUeWFmVFbFy7aymSMjmONlGn3+5ZJkuP4qnD8hsK+aEUfSBFwLpJbBxiqme5Hw+obM2S5k+xi4fyDj2wVvAabIJEkDQuz7XPssvhixvkg0j7jRKy/3HOeaJQ0lO+efX74yEJnjJORBTiW3ZnQYQBQ5nxS4Zc5aEvRj2ERi85jcnHy03XsmaD9XIsrQCTZEKoEarAk4DpTDlikgtGlm4ik1EHoPtUKpzj9wSFxNSiYjQDa27ZSW6pVRAtNxCeVcAKV3VwOQ2+w3G3kxDwieba/qDrYXDXRDepUXC8gb8BO86fLXdBv9KUsVpcR7GngkGP7
 lC+Wc9G+
 XhUjZsuzdE/55DDIiuJYaUxgF6bA1is0Jy0McRdFn0Kk5HO3c38m4/4eQTI1eCUD4XkdrbRaL25BbQYjC16a538FpryIe4BT+X8LaWHz2II6aFepczjA+EysIyhrwM6T78olyWdhW4WyBu7WjTs40FwSX9SdD9rHFP2jJkv6OpZtENdHrHSY0WWyv42IAdwkbb0EueFK3fAynl0EHeyDhTBPR7OHs1DkJWtAnCQAN07elmqLFOndVO87TeKnReimjBPIaf388YBsnZq1t1Cnv11bnq5i2ANgtD69uybd9Kx/7H5hoZSCfgXK8cLMo9Fn/rzJuSkUZK/8WxZ1CZxNxU7LS9yJ808Ln68teIAzoyEU7l5FLfrOtMusFcqatbw1C0v4JLEvdv5Ohr07H0z2RPPmvWHym+guAQlRbI5WOhMuU2nrhbvlmbrANFwDDAJmUh8y2gw1z1C+FofWnsz9SG9LaG0ZYUcMWvt/KuprC0lidztZFzYbn+jVIrZTWRyCc1OJfe//ylGP5bHFzfFu+ljNnNb4qTqoGLUr24w2x2Y4d7BW6yudsdBmGOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/2/26 10:47, Balbir Singh wrote:
> On 5/1/26 22:44, Andrew Morton wrote:
>> On Fri,  1 May 2026 17:21:16 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
>>
>>> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
>>> to a PMD check failure, the pgtable allocated earlier via
>>> pte_alloc_one() is never freed, causing a memory leak.
>>>
>>> Added free_abort label to release the pgtable in error path.
>>>
>>> ...
>>>
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  	} else {
>>>  		if (folio_is_zone_device(folio) &&
>>>  		    !folio_is_device_coherent(folio)) {
>>> -			goto abort;
>>> +			goto free_abort;
>>>  		}
>>>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
>>>  		if (vma->vm_flags & VM_WRITE)
>>> @@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  
>>>  unlock_abort:
>>>  	spin_unlock(ptl);
>>> +free_abort:
>>> +	pte_free(vma->vm_mm, pgtable);
>>>  abort:
>>>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>>>  		src[i] &= ~MIGRATE_PFN_MIGRATE;
>>
>> Yikes, we leak that page on several error paths.
>>
>> Thanks, I'll retain David's ack from the v2 patch.
>>
>> Balbir, please review?
> 
> 
> The issue can be reached if we try to migrate a non private/coherent folio (I assume DAX/P2PDMA)
> pages. Even migrate_vma_insert_page() has a similar pattern. Creating the pud/pmd/pte structure
> there is unnecessary (but not allocations occur, depends on pmd_none() for example), do we want
> to clean up all of it (need to think through)?
> 
> I'll re-review and send fixes as needed. Looks like David sent some fixes out, will review
> those as well.
> 

I checked migrate_vma_insert_page() is no affected.

Balbir

