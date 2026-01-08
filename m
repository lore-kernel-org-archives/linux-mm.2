Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A368D1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588156B0088; Thu,  8 Jan 2026 15:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F6B6B0089; Thu,  8 Jan 2026 15:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8496B0092; Thu,  8 Jan 2026 15:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4916B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:01:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C03C4140296
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:01:24 +0000 (UTC)
X-FDA: 84309866088.11.7C339A1
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013043.outbound.protection.outlook.com [40.107.201.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64A87180007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:01:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=D01FOUl0;
	spf=pass (imf16.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.201.43 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767902482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfyGCGzgCYLb1UJLgq32pbWmvKub1j/Gtt+nzP6fT9Y=;
	b=YT17tWlKvp7+djTCV4vcgheRQrIralhKEO3519OGe8Twj6jtvL4sln1dfkjGTa/dgkET+E
	3E4gHAeUls8uZgtOQKMxW2pKUqNtb/qGm1m+8hx5AjbG5jzY8weUIX639u9SiMJEjYfobo
	uD1oNGflxvA3EaW7uekTW8x9LKqbS+k=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=D01FOUl0;
	spf=pass (imf16.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.201.43 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767902482; a=rsa-sha256;
	cv=pass;
	b=6e38FTYIrl62p/oU/QUj1AoroZbF2mhyNhvGWomURm7CPA1BNwoyedpy+I5hHaRU2vz7Rl
	tAJxa4dYW6t5fN6dD1F8ue8Ne55BUVP+b/Jh3hoZ3VJRvBHtWBxVc+y0i57HKcx8+rDFQL
	XkeZPJtS2GYFqZWvFTwyyBXrZK/q3k8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYhSZd6Qr4CSO9SKGIbUecpwM9hwVfbG4Itz8RpG0YokW3LMfZQ+GoYgw72g8tE+PHQKzxcKfApkYIkVOWJX4ySlCDob+TdOb5Ui10nya0o4dbt44OgbRvq6enbSvoLToJQA2+KoggQg33g8XokR4lewVzw5/QqrVWHRatwOA61a4CViczCNiubBRYeRUED+B9ofeMBwN4Td+L1cXJkEq5KhA2kDKHEp7q6d4NnKGM9Sll6ZMq6S2Le5UlO5nLvIebL65gV+JTzF/K3nCXdbyJ2C7fBNEjsTgjb3sUUGbOYTRagVfIGq0TbcK0G3uFgMKMipCeKVvqYCX24T2LoRFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DfyGCGzgCYLb1UJLgq32pbWmvKub1j/Gtt+nzP6fT9Y=;
 b=Kj38UO7B7GYtqawiPh7w1QAAye8hVVk5IbckNrcUQwi3HH9f8Ndbpj5ffoS/oZwnafccHF+lggrzhnrpQPZPj91su9H6obYClyVGRv5+aiP4d+gkn6tRoSAz8ultDj0hQPO08hrmx9qUM8qY7NVRZEPBDxHfK9+hWnQB/YkggzprTysLAMPuZsqa9i7TbvgRlE76uBk15ysYsMN8OI3sMHY8VqP6PQBAuTSTGIpEjeSB1Nf7iOF3G8K5OkzjnQ2BcXtyyBk+1u/rGo7L1Gt+En3/nOC2SsgT7GIC5YBiQsEdXGb8VWJfF+V+3q7mfbFkRtYxmvqE5PCSBiTf3tV9bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DfyGCGzgCYLb1UJLgq32pbWmvKub1j/Gtt+nzP6fT9Y=;
 b=D01FOUl0UmcSRu4Ng7RDTVoGKhxSDXYd22MkFLzL8/iHwwVG7KfdKZ1TWr04QZEp79KTpGc8/V1uSOanhl0p6ofEVOKNiieca/F5Irhk/QJV87mn5yPefFMMxqkCUQ5RQEF/RApsdbridJqnsnuJ4F2k/4f37/5zQzl9z/5ISCc=
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by SN7PR12MB7204.namprd12.prod.outlook.com (2603:10b6:806:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 20:01:16 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81%7]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 20:01:16 +0000
Message-ID: <93449f35-9512-47d2-ad32-0f0efabfb8f5@amd.com>
Date: Thu, 8 Jan 2026 15:01:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] mm/migrate_device: Add migrate PFN flag to track
 device private pages
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-5-jniethe@nvidia.com>
Content-Language: en-US
From: Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <20260107091823.68974-5-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR0101CA0279.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::10) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|SN7PR12MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: adbd1c84-5b7d-4b23-341d-08de4ef0ae57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTFrSWpjMklnU1VwNU83NWJ1UG5YQnRqR2RMOGgydmFZNUdWNVlaMWE0ZVFT?=
 =?utf-8?B?bXVDbWJhaGhVdmVLMHdHQ21CWnZZMTE3K0FuYXRKaUdzMmpIc09WL1AyWkhM?=
 =?utf-8?B?OEpUT1kzSHFQcVNSaU1FNit3OVZkVHpUMDMyckk1WnR0dlh6d1hzeTcxNHVM?=
 =?utf-8?B?TjBHamUvUC9EMEtiTmViWWdJSkZtaEowTTVOOVNyZjBPSUd0REVsWmVQNXRa?=
 =?utf-8?B?R2NsVG9iNzJiaG4vSUc1QXY0ODVBQVZIRXZORjlsc2g5R1lNbnEwZlFTSmdM?=
 =?utf-8?B?Y1V6bzYvckt4RnZMcE1kOCtBNkk1WmdQcFMyM2gxMUhGT3BBdHA5ZS9uSkQ0?=
 =?utf-8?B?bHBUWHV5NXdFN0ZpUEFOdlk1UmkzQnZuUkJwV0gyNWk1d3JlZ1hKRFUxeXJj?=
 =?utf-8?B?RktydW54ZWtPcDkrOFNkME54OGVWcldWcitqVDRwbU90NnI0aFhIMVBUTXZ2?=
 =?utf-8?B?dytEcVhieGROT1VybnAzdDFwL1BQK0hnaFBsU0hRZDZjODZNVVc4Z3ZyMTF3?=
 =?utf-8?B?cXhFVXNTMHFhdUlyZDdtekk2aWFFNmRFa1hUTTdRK0Q4b21Zc2lPZmxsQnJS?=
 =?utf-8?B?dmNSZzFxRG5hVkNLc01vRzNrMFhodS85Wm50dmhNUTNzRnRKYnhaZmc4TC94?=
 =?utf-8?B?MGYzamo1cittaDNZK09DRENxOEQwcDZLV0N0VnlkQk5IZDVMalBJbnlCQ3FP?=
 =?utf-8?B?ekg3TVV4Y3Y3cmEzS1hyQzljK2Rua3o4RnpEUDFSQVdOTlRzbytEZ2k2Ykpu?=
 =?utf-8?B?MGl0QU1xamNKeXA0TGlwK3p4d2F2bmNLMDQySjBkTGF6VlVFT014aFhUbzdU?=
 =?utf-8?B?VE13UUYxcGVIUlhYdEE0bjlxeEFxWHV1VXpBc1pnekdQdDdJM2luWnIxN0Z1?=
 =?utf-8?B?eUVNSWtiRmVlV0xCT2hpemx0enAyTTgwUnNXOFlKNG1EOC9UZnNaRVVscEw3?=
 =?utf-8?B?Uzh4UGx3OUl4VjdXaGFOYlNISG9xOThXNERKMXAwSXMzOVJKYnlpYk0wRWNl?=
 =?utf-8?B?MExoUEVHRzhrU1pybmgvRk4rLzlpeTluYTl4UklFUkZUMksrSnp3czZUSHZx?=
 =?utf-8?B?RVZwWDRLVUZOZkE1d00xMFAxckJIZUVod05LMVBUa0pUNFVuODIvM0Mxc1RU?=
 =?utf-8?B?SXhCNEw3N1F0amNURVlKcmkzVVRuWlgxaXZDL1MrOXRaaUJ6bTNFekU3WE9C?=
 =?utf-8?B?N004Sk1DZXBGZXVnMmpieGVTRW03QjhrYXZ1MXpxblRwd2grb2dFUHhQZVVL?=
 =?utf-8?B?OUpUWkxBWjFHQmZkYW9lc01SZHJwd1Z1eE52V0xHSStHclhmNk52Um94dDUr?=
 =?utf-8?B?RDdEc3RXaEVUcndwZTVCQllOYmUvaEE3amhSM21JZUNVUU1VenZFYnpvZzlW?=
 =?utf-8?B?aVpaczlrY0pnREg5SEFTZWg3SFdzUXdUWC9IZmZ6RUVTZDJIdThVb2w2dVF5?=
 =?utf-8?B?SDBYZG1Zd3I5cE1VUmVkbXZ0aUNBY3crV0tNbUZTSHpFU3p6d3VEMkR6NTQ5?=
 =?utf-8?B?RTA0RXVNZDZmZzV0R0NFdTdyN2VyWVdreWVhU1JlRjE3Z2M5UksrT1kwa01T?=
 =?utf-8?B?TFBBYmpNY0h0RnhnQlVLTGFoRzBLOExyVS9BTkpaTXR5MUc1UFlSUkk0MTd4?=
 =?utf-8?B?QlFPWmFGMyt2QjA0RnczaUlOU2V6WHBHMHlqdUZORjRWcDZKOHFtUCt1NkJP?=
 =?utf-8?B?R3VIV2R6ZEFVY21wWWFpOHNYS0NLOW50alBjVnZFK1ZPUXVjMWtJaE5Ka3JN?=
 =?utf-8?B?NkpJZWFRZ3U4WFpsd0RVNVJGQ2wzaXVXNllxSGRTL2VEcmNxMEo2WE5MN2ZB?=
 =?utf-8?B?QVFyS01IMWpsempsMVlGa0V2VS93NDVqKzlqYnR2cllLRm1WSlFRNUNJc1Rq?=
 =?utf-8?B?WGdjVDExNXpmMmw0dW9JZ0RrOEJJdnZxT3M1dzdsUzZOQ3VyYXJnbjI3RjN0?=
 =?utf-8?Q?ylXbvWL9fptGWUyh4ThnDT4Air2gZkWO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUpaM0hHNU10QkU1YUR3OHdsc3p6QVVnZGZOR2JaWVVGYTZOcWJOUFF5L2tV?=
 =?utf-8?B?a1d3NEdCN3duZmUrb2hhSFZUNUxocWxuaEFsWGFtWnE2R2w0SFFiM3Q0aXRu?=
 =?utf-8?B?NDdtNXFlN0tXNHkvNWh2VTZHc012bUZycllSWVpvb2ZsUTZMTXlqQmFGaVdm?=
 =?utf-8?B?UWJOQjBDNTJOVUdhQUJtbmlyTlcxSHJydVE1ZXZjdVlwcFJiNWpkZXFvWEx1?=
 =?utf-8?B?K0NZRERJVmcxZGxiYTVsZlhyVSt0b280aXBNM3NGQUJraUpJU0RFaEM3K0dD?=
 =?utf-8?B?Sy8zSjBmUTJzS2VQb3R6WDh1N3B0VmIxTC9nWTFaR0E1VERrc3JKQXMrZHJW?=
 =?utf-8?B?TUlrUm9tS1JEai9nV01QZUpKK1Z3VUx0WG9CSTRXc0FJcGRLWWY1TDVscjZx?=
 =?utf-8?B?dlEyemo5QWs1OXBqb0lXMmpmRUdmUno2K2doSEtjWHYxOGxkR0p6aHpwRS9n?=
 =?utf-8?B?cHZpTTN2UlkzSW5HRWJVbDFrYUdsNEZKSm5pSksvbG9NUThTOERnRW13N3kr?=
 =?utf-8?B?VlFCSTBTVFViV0hNbE9CTDJlcHYrRkEvaVE2ZGhGUGptZ2had2Y1TXpubndW?=
 =?utf-8?B?SnFUMXZRQkFXVjIwV2dFT0xLNU9pWjFDaXE0WExkWk9VTlJROWJzNjcxZGxN?=
 =?utf-8?B?aUhlMFdrc0E3U3ZiaEFyNk4wOHFSaklXMTZrMnFOUjU3bDlTYWIwM0RBcGpq?=
 =?utf-8?B?MGxybnFTOURtYS80elk0TUpoTW9PZXI5bjBSMis3RHY1aXNGdE5pWVFWZU1X?=
 =?utf-8?B?Z24xejB5RFR4Z3RJVEM3MndZU2JzQXdrQ21PYXhrak80eHpTdFNEemNyVTZi?=
 =?utf-8?B?czhUcytuZUIxNW5TaFgwUWc5NVJ2L2w3YmZ3SUFmd0x2Y1ZRNDU1eG1qV3dv?=
 =?utf-8?B?ZHdqV25WUVMxamtlV0FhT2IzVDEyQlpYNHJ5UGR5eVROQTdmMEloVUpZWmx6?=
 =?utf-8?B?dGoxS1R6THdiSi9iV1lISzlhRW9DL29XTG9aM2pBZE12ZDJJK0NyVXJxTm5H?=
 =?utf-8?B?Wm5IMGdWc29Nc0lUNGR2OGFoRlFROWtGQW5IUE80RjNzRDAwQ1pTTDRlSkJx?=
 =?utf-8?B?K3VMbmkyemt2NWx1SmhpSmc2dFJqdGR2Z0JFaHFtWnhiUWc5UlpHZTFpcENH?=
 =?utf-8?B?cnNKV21XS0JuRS9iTDBuZjhVV096WEpBUVQ4blBoa0M5YzlGYmpFU0VvMUNX?=
 =?utf-8?B?dWhuRFZFeWQraTZiMXFwS1V4aVhCTndjYjY1MDhRSjdXZ1dNM0hEbUY0ZWh5?=
 =?utf-8?B?RkkySTZNNHhSOVlxaFQ2S1dzM2J5OGh4U3JBL3BPZ2FjNThuQWY0NFRyYzFC?=
 =?utf-8?B?OUdhUHhqMFNJY0N0d1d5eU9CaEQwTlM4RGVyVW1OUkU3L2xVQ3FiQmt3SHJs?=
 =?utf-8?B?NjBZTzFLdyt1NmtCaTd5YVUwenozbUhmRHFzT0UrOUhWZXYwZGVPL0FZQkQy?=
 =?utf-8?B?eGp5MmNxL04rZnljL0xqazd4a3FBZXFnM3pGVmlYMFNOR0FlWHErQzV4NjZu?=
 =?utf-8?B?dCt5UlQ4QnRuS0pyckNjeEpZb1NhT05ZNVhhdHVaY0g0WDhKV0x3aCtLZkpT?=
 =?utf-8?B?WU1HZzB1Tis5MEl4ZXVmbWJOWEdXUnFMUnYwY1pKSVpLdytURTZZa3RzcjBG?=
 =?utf-8?B?d2JvRGhwd044L0x5MFE2T2ZzcFNUZzVNRkZ6U0xlWHlueEtIMlFpV0dMTHNI?=
 =?utf-8?B?b2JsY0pMR3dSWWpYM0g0SFFMd2ZOeDlodHFxMEZlM1psUVUzTUpvWFgwK3Az?=
 =?utf-8?B?ekFpMmNmN0pJanlMMkFOT2xheVBCMHBTNlNuOVFYODNiU0pYcjRLWlBRRWJO?=
 =?utf-8?B?czhyUVFWZTR2UWtoKzZBam1CNTlmL2FRdG1MM1FaY1F4T3JKaWJvRVU3cGNa?=
 =?utf-8?B?WTlxa0FydzhOdExlaU9BRVRvVnAzSTg4QW9YSCtTK3V4S1g4WDJDdW9Pd21k?=
 =?utf-8?B?Y0h6TG9kTmJXNE42b3ZwcXJISUFjUU1zUlBVc2UzUmRLNDlCMnY0eExBcFlF?=
 =?utf-8?B?TVJualFzVjRIemEwcEEzVDVvdUpqd3FkRlRvL1BnV2hsakVBWTRkT2IvNys0?=
 =?utf-8?B?ZjljcFdUTzBNYWxEZ1ZCVmRQM2ExOXFCamtDb2w4WUxZUVRoUlFiWEZqMk9s?=
 =?utf-8?B?Y0ZoaHptMWpxL2dJTmo5ZVJuQkp1ZmhTR2QrSkJtMVgwSWI3ditId1dldWM5?=
 =?utf-8?B?VHRzR0g1RVZRb0NTS3M3NHJEdjBWUWF1T016NW52N1VUaUhlQlVnQW83OFd4?=
 =?utf-8?B?VU5CYWQ2eVBvUEUzQWlEai95VFhVNjJZamI4MTJLQjNiaVN6UzVGT1lINnJX?=
 =?utf-8?B?UEx3ZzFEb1VSSGd2cGpOQThvRzM3MWlkM2o3VGVEaGxjVEJSRzQwdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adbd1c84-5b7d-4b23-341d-08de4ef0ae57
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 20:01:16.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bo071hUwRXII4kZiLWdn3z+tsNiKNcX6QDO/fLIWZPSBq+xbrMJ2HYulRwdddnQIdle7vs13sD3I6R3TI/LdqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7204
X-Rspamd-Queue-Id: 64A87180007
X-Stat-Signature: oc56d6inucm6qyh5cpp9skrps6x9ffho
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767902481-187158
X-HE-Meta: U2FsdGVkX1+6lfNaH7zLnXCVxWustXRHCba55c6i2M9haBf8TKcbn1ixxojauGyiHheWvbRv+gO3V02xIeLCYF8s1VvIa1wwaVjGCNNuOCBKkYKWkMuBrjO2vAl8I3cyEL73s9aRGylrxVT7HX/d1JAwq5Qi2CP/Wn1NlKp3nHPrC7DeGPGetxtbHc220Wibfopo6/56P2VD3wPCZ7jbnTeiM/0gRA2tKErljODeMeILK9j8wg3WRmucdU/Cu9UTztse9PNo+SofmQswaB7Pi7PLB4s1CqlHCHFjFu9DNRj+yuHFXKiWJdDkvZRyIisYaW5MYiBy0KsHUDIgHwXlzXsW5SojHTD2+k/0V5wH/zhZChgQug7hNByrVwJMH+3kYIsgEohgG8oMgj7LYpXVIyh3PqJhIAZoZLakgOXu5PtqFzl1w0WFlZuDr6mkVjr/I0YUiQis+obXkXt5/fztfYISRwZ1PCWKH9phExXptNww536I1MSPvISx8mom7awB2oVNRlY2rdmHdoJx0MLYUyBFgsjFVp+U6Ytdp0dpVnOk4m13+/jqKUVQce+j7MG6lB9Hdze6OkCuKzIUb3M7YJ8UP6l/neshPhVLuXi2kWtBz8c59O7kiJYat7GBb5ZhOfnc8Jhp2R1Dj0GC3otR+3ej1d1cweuO3UtmdoBYbREYvSlBFV/E9awpKiW0T1mjCDzzP/lhkS9sDbSCT13Tn2118I/Pi6i+iQ3NpwQ64b8NJpDiZ+6OP4KgHn0DlS6MJmyqTujohfuQXN13Qk+qqsVEGuPu6Lynjrq2Ne2mpV9Z+m/VccuIzOjqTPl46aRyp0rSJ4yrmE9fI1Ss4EG+05qiGNC9Zf8hwwhqwPQTIcNNAqjKSZOJ2iTHxeixuMFUloIIUK8EfSAd2ZJsX7GIHJyBwddfbOGJIzAdc+Jjgsp33/vfVXTszPE7rzn4FP6L25K9fXXdTWkFyDRwb4L
 sfY5XoQj
 IIdiXHyjtOXKOMt0aERsOi1cL4OTDi5ZWRtz/oHsrqDRN2GD3lshxGclguSVG8zx3VTp2OSY7CHNzC9xGlnv/vx52NslWH28eLLg85QLa+NzZrZtlTXNfqBKuju1fw4glaLhvBToCP7aNupOHWyIS3fm8D8XSGoZ80N/I7UveYvmG8VlQv4PoMzptDwF3d72Gm3tEP/ygoqroX/3YLeS83dK9O8r/F1hZYFlJIWprJR0QvG1kq8lQaGgR2JVY6x0e0LVfvlubxjPCPIkIq8XWf2ey5IudRkQ87cvYyQv3gxTqHZP71Qm5Lku/rY/fxO1Huaq+l5PUJ4Be2xqlPVX9FAc5ys+aERBtXlz2JV6910k23+4Iq0VKogBVzs8+VkPCa6yG/AEf8EaVQISokbLF22tltCshYmWGx2TQk2xtDb5EGuyWVfmfVyJFxGG+TfULGfxv0szNOO1T42IyKn2VmDfxzvpbi0730higJKS6fD3fNOLA7TAa8g9V935xyTGYMADwKC5G4y/n9DwQ8Ai+v0RZfR4P0jaMZ/bN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026-01-07 04:18, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
>
> Prepare for this by adding a MIGRATE_PFN_DEVICE_PRIVATE flag to indicate
> that a migrate pfn contains a PFN for a device private page.
>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>
> ---
> v1:
> - Update for HMM huge page support
> - Update existing drivers to use MIGRATE_PFN_DEVICE
> v2:
> - Include changes to migrate_pfn_from_page()
> - Rename to MIGRATE_PFN_DEVICE_PRIVATE
> - drm/amd: Check adev->gmc.xgmi.connected_to_cpu
> - lib/test_hmm.c: Check chunk->pagemap.type == MEMORY_DEVICE_PRIVATE
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  7 ++++++-
>   drivers/gpu/drm/nouveau/nouveau_dmem.c   |  3 ++-
>   drivers/gpu/drm/xe/xe_svm.c              |  2 +-
>   include/linux/migrate.h                  | 14 +++++++++-----
>   lib/test_hmm.c                           |  6 +++++-
>   5 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> index c493b19268cc..1a07a8b92e8f 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -206,7 +206,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
>   unsigned long
>   svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
>   {
> -	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
> +	unsigned long flags = 0;
> +
> +	if (!adev->gmc.xgmi.connected_to_cpu)

We could probably use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE 
here. This avoids making any assumptions about how KFD decides device 
page type it wants to use, which may change on future HW generations.

Other than that, this looks good to me.

Thanks,
   Felix


> +		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
> +	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT) |
> +	       flags;
>   }
>   
>   static void
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> index bd3f7102c3f9..adfa3df5cbc5 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> @@ -484,7 +484,8 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
>   	dma_info = kvcalloc(npages, sizeof(*dma_info), GFP_KERNEL | __GFP_NOFAIL);
>   
>   	migrate_device_range(src_pfns,
> -			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT),
> +			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT) |
> +			     MIGRATE_PFN_DEVICE_PRIVATE,
>   			     npages);
>   
>   	for (i = 0; i < npages; i++) {
> diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
> index 260676b0d246..f82790d7e7e6 100644
> --- a/drivers/gpu/drm/xe/xe_svm.c
> +++ b/drivers/gpu/drm/xe/xe_svm.c
> @@ -698,7 +698,7 @@ static int xe_svm_populate_devmem_mpfn(struct drm_pagemap_devmem *devmem_allocat
>   		int i;
>   
>   		for (i = 0; i < drm_buddy_block_size(buddy, block) >> PAGE_SHIFT; ++i)
> -			pfn[j++] = migrate_pfn(block_pfn + i);
> +			pfn[j++] = migrate_pfn(block_pfn + i) | MIGRATE_PFN_DEVICE_PRIVATE;
>   	}
>   
>   	return 0;
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index d269ec1400be..5fd2ee080bc0 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -122,11 +122,12 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>    * have enough bits to store all physical address and flags. So far we have
>    * enough room for all our flags.
>    */
> -#define MIGRATE_PFN_VALID	(1UL << 0)
> -#define MIGRATE_PFN_MIGRATE	(1UL << 1)
> -#define MIGRATE_PFN_WRITE	(1UL << 3)
> -#define MIGRATE_PFN_COMPOUND	(1UL << 4)
> -#define MIGRATE_PFN_SHIFT	6
> +#define MIGRATE_PFN_VALID		(1UL << 0)
> +#define MIGRATE_PFN_MIGRATE		(1UL << 1)
> +#define MIGRATE_PFN_WRITE		(1UL << 3)
> +#define MIGRATE_PFN_COMPOUND		(1UL << 4)
> +#define MIGRATE_PFN_DEVICE_PRIVATE	(1UL << 5)
> +#define MIGRATE_PFN_SHIFT		6
>   
>   static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>   {
> @@ -142,6 +143,9 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>   
>   static inline unsigned long migrate_pfn_from_page(struct page *page)
>   {
> +	if (is_device_private_page(page))
> +		return migrate_pfn(page_to_pfn(page)) |
> +		       MIGRATE_PFN_DEVICE_PRIVATE;
>   	return migrate_pfn(page_to_pfn(page));
>   }
>   
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index a6ff292596f3..872d3846af7b 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1385,11 +1385,15 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
>   	unsigned long *src_pfns;
>   	unsigned long *dst_pfns;
>   	unsigned int order = 0;
> +	unsigned long flags = 0;
>   
>   	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
>   	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
>   
> -	migrate_device_range(src_pfns, migrate_pfn(start_pfn), npages);
> +	if (chunk->pagemap.type == MEMORY_DEVICE_PRIVATE)
> +		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
> +
> +	migrate_device_range(src_pfns, migrate_pfn(start_pfn) | flags, npages);
>   	for (i = 0; i < npages; i++) {
>   		struct page *dpage, *spage;
>   

