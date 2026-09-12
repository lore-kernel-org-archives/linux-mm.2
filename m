Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329FDC79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 04:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3AA6B0088; Sat, 12 Sep 2026 00:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BCC6B008C; Sat, 12 Sep 2026 00:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDA96B0092; Sat, 12 Sep 2026 00:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2AF6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 00:16:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE1911403BD
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:16:29 +0000 (UTC)
X-FDA: 85203798498.06.AF182A1
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0AA24A0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:16:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cTptUizc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.58 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789186587;
	b=xAloufJj2vvJPe0rdwFCalpSuNheBSJmwv0N7TxuE+NoaFmo5JxxGAG0Hc3dwnaD0RDpPT
	FK+813wjhhBj8Z9Hjqct3NkiobkYkn51EMVO5nkFhfKmrljcUVv5EF+xc6NThfy4dksJ+/
	6R+2z+TrJDpk4KfmgxMPQg4d2FFNaoM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cTptUizc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.58 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789186587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9u0twnv8J3acsNoPcR1srnfI5R0+gbyOPlObcalYjI=;
	b=I6iXwEmeFh+qHZQ4VZcBi4e+UkKj2YFqTmDmEhZ/8DhjxY5OxhsDWqhGbZHyQtTUSeE+bZ
	sFblrk348kVddRLotRY7EjI5e3PBl4QQB/V1oO+7KejekRTwUNAt5UnpXcqfz1Lo4tT7ku
	iPEv2i312X8x6yHdLdc7gtAdu/6Dre0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQh5CoUTrzoOxiQ3xXFE7QVLLtlP3UhHyqEr0WFbiN5GZDazciL1gzUtsKy80hbm/a8d3s/Ui4qI75zyQ2NXZzqFJHYszU5R+VMpRAsYNk5yF0ZuN7MtgMaaFwRsF7oommVDL9SKdtb/Uz80nS91BUDgcMww/dcP8IjEfaPZCilQ+96ErpUZ7RFE+HUaCQj73nsaaPaC1eB5MzzL95PfYGjeeW74fTjrZ8c0xFIQq/WBw14D3wZZaETa6pjYPWK1iVwFL1E6qV4j0YRnW3t6vKKdkgmGFSr+mn6VNff8n/pDpPGqvGtJeVuHVWRQ6YiDWvwBGVSYcS7Kpswv5YZTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9u0twnv8J3acsNoPcR1srnfI5R0+gbyOPlObcalYjI=;
 b=OSQXi6vI0sYKjhYgq2/9rSIUm3tU3GsVqnCQKqKAYSgDAdYy1rau6l9VaXYd7wzsH3wbERJRGh71mQaUHLDwGFxuhgw3TvAh8IGqH+1T6jVlTifwh46vBby2xnvUNoiOFMcWZjLpDFHxUa74lrNHS0WvOBgsocH22JUarjPqT7minvDBLGJPfNUiRm+X9YyFkKGrsxSVn/2xbTIif6AtXgHrAqRuPWPUItQnGE1YguiZHAEJ8Hfz1G4vwmdVfnRpNJHwwAC1Ic040Sjko9PtdjMk2jU/8NXz1y8KCnh/OJZYxQgTrszHxg2z1HvzB2Rth1x1NRV1L/bbyvCItT8MWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9u0twnv8J3acsNoPcR1srnfI5R0+gbyOPlObcalYjI=;
 b=cTptUizcE7HAzfjZyDpbp+L94d5FVRuxpfAwp6ECYtaExEtkUreO0xKG92+CuBHnUjEnIgBQRwnWRY1pOCtcYKYjevbVV5eRctZv+Jez8ifM1PmVjgI6VxfrlDoF34usBvuy7SIyTK7Cf0TvDV86hqRiyH/2/0swMHG8pFiBIHrO+Hwa+iiNN3Od5OxU59HXXKyBP9DGPgJCfiYeTXULgAN860Z+L0YeBdUSAAeUG9i7igET265sxCxA19gei6DtETzU13K9YSlwe0jTcC6i68yQ0Jv/rcGXOuN9mAj8hysglhp1XrTgxcUerSl6Ja3G6/b2/FXZ4llOjBUfLqtu3Q==
Received: from IA1PR12MB9739.namprd12.prod.outlook.com (2603:10b6:208:465::9)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Sat, 12 Sep
 2026 04:16:22 +0000
Received: from IA1PR12MB9739.namprd12.prod.outlook.com
 ([fe80::769e:ca66:82fa:aaf7]) by IA1PR12MB9739.namprd12.prod.outlook.com
 ([fe80::769e:ca66:82fa:aaf7%4]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 04:16:22 +0000
Message-ID: <1ca189d6-5b36-4d70-9dfc-34316591447a@nvidia.com>
Date: Sat, 12 Sep 2026 14:16:12 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: consolidate compound folio handling
To: Hui Su <sh_def@163.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260912034414.1943342-1-sh_def@163.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260912034414.1943342-1-sh_def@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME3P282CA0056.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f3::7) To IA1PR12MB9739.namprd12.prod.outlook.com
 (2603:10b6:208:465::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9739:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d9c125-be13-4d9d-4513-08df10849a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|6133799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	SSKna639MLv7MRelwp1zY/OX/l2HAcbxqp4FpC8Gtht2W0pyUNnAZ7U/XC4gQfTrMBQCTCpvTYr7Bc/5cjGqxoRBKvnUcn9ytq1F8wjD6uuljnNTpKiqA1MjnXYyYjuTtyJZkPv9vJRhinTBCrj//UAqdZ5oCTALtqNSb1Q8WulMayFTPvENpxuUNasMSHFC3DCYyV8FOdsmtCsgXq1ufD22nSQSx9EDDTlpAW5POsAudwWxX4/8dkH0qQg/Km52P5QdnIuYxQWXJIlEK7Rn6QILFmsw9i3u6p6MxEIZix8+Tydu1i5ge+6s605GGDxjxzYxwLui3oxGdDV3S4ONN6XSRKZnb4z2NEEGeVGTKyhIeLaNqR9h/uTi8XMXkhhxVv8r51xkxQxWHTvGW600UgjBz/2jrQe+W0KjgqiHaZf5wgvaKsU/L4smN/TS804DxdseX1Z8YlFQ/OK+tbrkZ55INJ3I7o8ZTyY/M/N4EAQyY5qBG/rE/zlsZHS6MY1OCYZopoRkrHLCVqglf+2JIZj5I0PeuvD0gTk4jNomDFnEEMT+VB4xfsNV0VG1o5kZ2IZg1MTgty/5CkMu2RUgvQaBGKZxea437goSvI3AZO+pnJVJyi3l2CSBsbFutb3z2MkVLczgfkBE+MmgwKFW//gtnAPxqcOKNEZIz2sB+BQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9739.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHBKSHdYUVU2bjAzSVFmcEgwSEVXbVJmdVN4VDFrOEFyNy9FNHVtQ3hNY1Ux?=
 =?utf-8?B?eEd4eWZWR3M2aytGWkdsT05uMFFiYWZ2WXRFTVZjcUFCdExMbU5JWXM5d3JT?=
 =?utf-8?B?c0w4UWgzZTVKWXMxczc5Mmhqdzd5VG5Kdms1ZUFEMCtHQXJuRjYvQ0UwTDdl?=
 =?utf-8?B?eThuTTVQR3k3Z2pRSVFzVURTUTJnODVkNURKZ1hVRDZ4S1U3ajFuR0tVbDNh?=
 =?utf-8?B?MUM2YmVPRFdjVm54VVFFbTRpQWtJNFhkWFQ4NHJITlloc0Y1OFBqdCtwVW9E?=
 =?utf-8?B?akF4MzZWRFBFdFZUV2t4cUxxb0dTVHhieExpZTJFRDlhTG8zNkwwY21lY1U2?=
 =?utf-8?B?c0RyNjVEL0UzMm16Q2dKbWVtVVovM2xLWGhwTzBjQUl1SnRJdnpSZWVuYnZw?=
 =?utf-8?B?aUtldDBtRTdEelFKVjlPbERpRHdYQTdoRW9EVzBRa2I5VElRU1BUbVVxNkp4?=
 =?utf-8?B?UDBBc2Nwbkc3Z1BnVUJrQTZWZFByK2NKaHVQVFdzcXVQbUJFNHRob281NlBZ?=
 =?utf-8?B?M1JCZmxJeDBTaFVMcmF6ZXVwSXhINnBucGI5TlpLcnBWLzdVZjUxK1g4c3gy?=
 =?utf-8?B?bG5tZVE3RDhNUlNkcTdOcE82aGZpUUQ3NU5GZ1NXMDNNMTRuSXZZQ2JYUUtI?=
 =?utf-8?B?Q2dzYnlNUHNvd3NkYXFvazVlU0ZneTYzaDB0dy9WMDdlSDk4MWo1MTRYOFpX?=
 =?utf-8?B?RHRTTURKSUo0S2NNaXo5YlBBOTltZDNGcW8wUFVGMTkyTW12cXR1QXMvU2o4?=
 =?utf-8?B?aHlxdEVTUURXSVFJa0tEeUg5eDV1b2UvV0lHK1NKTWllL1lFYUdlQ01iT2hl?=
 =?utf-8?B?K04xMHE4cjF4czJscGVsenJINW95R2p0bkZJdHgxaWxKZzBVN0RxdmZnR0VX?=
 =?utf-8?B?Mjd2WklZWFh0QmNIMk1FSEN1RzdqYmU5U2xwOXZXNkN3YmM2NnBMRkMwcE0x?=
 =?utf-8?B?RXFnRHpBejZReFJtZUdCYWdVdkE0Qkp2YWcvakVSTEdDS295L0h2QXpZVzNo?=
 =?utf-8?B?MEgyWEVQWENsSHFpRU1pdDU2c3ZWY2lRUkJTZy9mM2ptNFh4OXdVamsvaVgv?=
 =?utf-8?B?VTJKQTc3d3I5UThHeW0vc2FpaGZKV1N3MEpLZkdRVXk4Z2Q3L3JxYlFDQ2Mz?=
 =?utf-8?B?dDM5VjdIOEprcnN1Uk9jVlNtSHlGbElNYnZESWN4WXN5R0JlQi9GdDdmdEVG?=
 =?utf-8?B?MVVTbE90KzhLREl3SGVSaDIxOVZkUHEwcjZXdEdGWVhscVhpZ2ZSUERERUFs?=
 =?utf-8?B?dXJGemFpdUxBQ29rVzEzYW4zVW14aDY2UGdDSlVDSjVLcW5hRUtuNEJhSVpL?=
 =?utf-8?B?WEJCc2pMZ2xOSi9rZld2cTc2REM1dXVKVG8ydnRZdE41cEY5ZktZV3JTT1E5?=
 =?utf-8?B?Q0c4cjNJVm9qb3oramNmNFBKTG9Sb2dPUEpDZkg2MzBoK09nYmREeERVUnpB?=
 =?utf-8?B?OXFTZklSNUI5cXMwUW85U3pReEI3UWJhSGhXWkY1dGFMdzFrb3R6c05Ua2M4?=
 =?utf-8?B?L1VaczdzcU40aGphWGFHZldvVTRneTNuK040eDVpTVBRLzlEN1krcFl2T3Z0?=
 =?utf-8?B?U1hKeld4NlJvYU8rL2pkRkJuTlJNRDZjM2xXR3c3aHFVTDFLTWZwbnh1Nkl6?=
 =?utf-8?B?ZVZNWHRuNlFRWkcyQkk5eGZIMzN1OEF5WmFLS1JIK0xIVmp5WVJWcld0aUNk?=
 =?utf-8?B?VFA2ZmNYU09wVmxpMUMxSUNCZEtKSlVmVDNRWGxRZ01CT2dqZ0Npei84ai93?=
 =?utf-8?B?ZE1RU1dUdkRSelI1aXdnZ1J2STd4UzNaK3ZBSHpBVDJQYTkyU1lTL0FMWEgr?=
 =?utf-8?B?UUhyUGlabVgreHkvZ2xNTjBBVmI2Y1BoUnh0NUNOTW9kRzREaGlHNnJ4T29X?=
 =?utf-8?B?eXVVcEFBbytudFc2WU1xU0g4VVd4R21vSVM2a1ozdm5EdnpmUytsV0xrMTk1?=
 =?utf-8?B?ZDVNVGdqYkJsc3pIRUxNb3dPUE1yd042VXlha1hqVGw2cHRRVitPOW44WHBk?=
 =?utf-8?B?QSt6Tkw1NTlRTWFKNS9RckRBOStHYWJtSlFEcG1tT0V0dk5SMGlHRHBoVFZW?=
 =?utf-8?B?OSs1S3JqcUszRmM2ZW1vT1Z6YXpRN1puR2piTDROTHl6WEFoMjlkaS9pbHRM?=
 =?utf-8?B?M2ZIOVltcGxjdGdjZE41elp4aE1SUUZiZUxGWnEvTm9BTnFGem12czVKYSs5?=
 =?utf-8?B?ZVduY1pQM1gwYmk5SWQvVURTUmZadVVOenBVU3RCUmt4YXQya0lodUhGUFoy?=
 =?utf-8?B?MTBBNGZZVWRVTDg3V3dtSThwNVluRlVuakdMSWNpWVg4MlkyenJsbGtxYyty?=
 =?utf-8?B?cE5PVUNoVlk5dXZiS1hKaHlDd0ZoWHFFQWxTMit6ZS9mQk1RYVlOdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d9c125-be13-4d9d-4513-08df10849a59
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9739.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 04:16:22.2038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIHj7LgHEfiwGpiaaiM4TmanbrYTwEwjFPIAB2ZgFZcSHk3bhFGDdPezSTPaRVACYmgieLzm6mNdHXmbBqPPyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0AA24A0004
X-Stat-Signature: bnrzym6x89dubb5r1e446onuo9ujo38p
X-HE-Tag: 1789186586-855538
X-HE-Meta: U2FsdGVkX1+Ic8B0+Awea3w989OUHf/qs3gpHb02B3I/tJu8J4C3MPSdbOF6AwQ8TtRj+oV01MQ1A3flaiueOnwZs9HudKQldJcOUDavwWuG2znYTqarMkIs2LvfwO08Kns7TGxxUVGq/Qc4WCZ65aQaXQ3EETfDlFW1zNbZbkhTv79Cr3iXUAaCsZgRUmBD3SsQ9JCQpd5ldTP35V0w3jsNSSNhTfR8Re9PBI7bNjF1DnyqRr9VCZmhqPVBfq2EQ9ML2dXyuvCEq9FSWxLun+nU20I01B2DEPsFo7pZ7gsSmB/qunUfeonma1e+Y0Hs4ewhRUmpQF7LW+ffTauVky8k5wiDGNyyOWxK8CXDRe8rOOa0YVZUxobcxUnG+2Gpa/5e5lAeJ4egqguS/1GZkJVhwM17AF+M8bf3mCpwp/5hcVk0lFE2xnanzt1xrxDysduc2roytI7Wz3FfRqdQx6MweDRTO3qGX7sY6vdG5n9WnDxMB4Hz51iYVN+nwVA3zlj/V3Z6pCDC6KxAtfppvss/R4eHVjzqqSjMigfUadNtUQmVwKsOkckFTI02VipTbfpoLnpOsmqC8yjHV7/Ljev1f46zv6yJ2StkALDI7xLuXfz313FbA/w+KdKMfyBDVXXRxTWbcVWG71p41A7JglvMpkXWmn5d1/dyRpM0R0nULLSgHJbQjQELSCoy0BRCxdh3O5cgCWQ6lyys/9N/oBaDwXS52W1uSDFRFAEIQRkl4H1vCPegaPUZNDulxpukvS0PpciipBZRn8K6HVnn355KLWdu2UMph2z/1uVlmpqr/JEE2X52tfqlSWRUlizeyTgkRtPvAbseT8p9ptJQ1f4x7yObdaCaVyB49xDlWANTegUc+ckISFnPeL33/i2WITrtDVR54EPqzp93pEvc/uGbuW9cO8gjoBoLsnpiYM5lV/AJJJerMhUAkoLszmVygX5MxpnuMVY4iZTaz9E
 7eiv34h2
 lzVieG8eZSQ3Iq14JOpWMc4q26D49XKxnlrcKEZ1+k81+hnJ2EXtU36c8uKAuAjnvzlq91E8O+undtSGJ6cIBVmhhX6itPkZr6x8vrlVtcA3kLA+X6+ZfsOR/4GTGnkvsFb0JPS7e7BgiNAfdnMWm77o/j05bvkoa+An2ZV95llsGAC794Khg6/VaBVEYQ9xouj3Hr14zZkwd1xP+7VJthiN2w3UL+l7RJCFA6IGxERisdD3q6kPEOgPEQ3a82iYXkEd1zkGDYD3Zw3Fq5qq8cXuOBGyVpJi4kv8MPNyLZAIn4LiEt3wXRM+U4itBvi5aHvvJh6NDwiKPc6PWhx0av+QT7p7XJpC/cxjt4VXf+vj6Tah0Ix2AWWpVH6xCq7+sGjLz75yk+GU4gofy2LyyTmHcRzonBtLSQbwkJHQMDnnj/pxqAOwSYJWI6r+RYTaj9/MUBDzzvuBaBc/AHygg+xUOjxvingG1935nMNmhBSNcl6EntXmHAJ6BKQokkcF+WmTveklsqcdDRKaLQZGreSO6x2DJuGw7oYFYT3J/Af7+zXDYaD/88n1HPbG095j/cRy5JQE40k8SxXbhm6fcHhA+vxEXePhSAiZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 1:44 PM, Hui Su wrote:
> Commit dc41e961a269 ("mm/migrate_device: avoid out-of-bounds writes for
> compound folios") added handling for compound folios that do not fit in
> the remaining PFN array.
> 
> migrate_device_range() and migrate_device_pfns() duplicate the logic for
> locking device PFNs, encoding compound folios, and handling this boundary
> condition.
> 
> A compound folio cannot be represented partially for migration. Warn when
> one does not fit in the remaining PFN array, while retaining the existing
> defensive handling: release any lock and reference acquired for the
> current folio, clear the remaining entries, and stop collecting.
> 
> Move the shared collection and encoding logic into a helper so both
> interfaces handle compound folios consistently. Also use memset() for
> the compound-folio tail entries instead of open-coding the clearing loop.
> 
> Document that an encountered compound folio must fit entirely in the
> remaining range or PFN array.
> 
> Link: https://lore.kernel.org/r/c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
> 
> Notes:
>     Changes in v2:
>     - Fix the helper parameter indentation and keep the declaration to two
>       lines, as suggested by David Hildenbrand.
> 
>  mm/migrate_device.c | 89 ++++++++++++++++++++++++---------------------
>  1 file changed, 48 insertions(+), 41 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 009bfa8b212d..ace543fd6946 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1392,6 +1392,38 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
>  	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  }
>  
> +/*
> + * Collect a device folio into the page-granular PFN array.
> + *
> + * Return the number of entries consumed, or 0 if the folio does not fit in
> + * the remaining array.
> + */
> +static unsigned int migrate_device_collect_folio(unsigned long *src_pfn,
> +		unsigned long pfn, unsigned long remaining)
> +{
> +	struct folio *folio = page_folio(pfn_to_page(pfn));
> +	unsigned int nr;
> +
> +	*src_pfn = migrate_device_pfn_lock(pfn);

Don't we want to check for *src_pfn == 0?

> +	nr = folio_nr_pages(folio);
> +
> +	if (WARN_ON_ONCE(nr > remaining)) {

Can we please change this to VM_WARN_ON_ONCE?

> +		if (*src_pfn & MIGRATE_PFN_MIGRATE) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		memset(src_pfn, 0, remaining * sizeof(*src_pfn));
> +		return 0;
> +	}
> +
> +	if (nr > 1) {
> +		*src_pfn |= MIGRATE_PFN_COMPOUND;
> +		memset(src_pfn + 1, 0, (nr - 1) * sizeof(*src_pfn));
> +	}
> +
> +	return nr;
> +}
> +
>  /**
>   * migrate_device_range() - migrate device private pfns to normal memory.
>   * @src_pfns: array large enough to hold migrating source device private pfns.
> @@ -1410,35 +1442,22 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
>   * migrating pages that aren't free before unmapping them. Drivers may then
>   * allocate destination pages and start copying data from the device to CPU
>   * memory before calling migrate_device_pages().
> + *
> + * A compound folio must fit entirely in the remaining range.
>   */
>  int migrate_device_range(unsigned long *src_pfns, unsigned long start,
>  			unsigned long npages)
>  {
> -	unsigned long i, j, pfn;
> +	unsigned long i, pfn;
>  
>  	for (pfn = start, i = 0; i < npages; pfn++, i++) {
> -		struct page *page = pfn_to_page(pfn);
> -		struct folio *folio = page_folio(page);
> -		unsigned int nr = 1;
> +		unsigned int nr;
>  
> -		src_pfns[i] = migrate_device_pfn_lock(pfn);
> -		nr = folio_nr_pages(folio);
> -		if (nr > npages - i) {
> -			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> -				folio_unlock(folio);
> -				folio_put(folio);
> -			}
> -			memset(&src_pfns[i], 0,
> -			       (npages - i) * sizeof(*src_pfns));
> +		nr = migrate_device_collect_folio(&src_pfns[i], pfn, npages - i);
> +		if (!nr)
>  			break;
> -		}
> -		if (nr > 1) {
> -			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> -				src_pfns[i+j] = 0;
> -			i += j - 1;
> -			pfn += j - 1;
> -		}
> +		i += nr - 1;
> +		pfn += nr - 1;
>  	}
>  
>  	migrate_device_unmap(src_pfns, npages, NULL);
> @@ -1454,33 +1473,21 @@ EXPORT_SYMBOL(migrate_device_range);
>   *
>   * Similar to migrate_device_range() but supports non-contiguous pre-populated
>   * array of device pages to migrate.
> + *
> + * A compound folio must fit entirely in the remaining PFN array.
>   */
>  int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
>  {
> -	unsigned long i, j;
> +	unsigned long i;
>  
>  	for (i = 0; i < npages; i++) {
> -		struct page *page = pfn_to_page(src_pfns[i]);
> -		struct folio *folio = page_folio(page);
> -		unsigned int nr = 1;
> +		unsigned long pfn = src_pfns[i];
> +		unsigned int nr;
>  
> -		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
> -		nr = folio_nr_pages(folio);
> -		if (nr > npages - i) {
> -			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> -				folio_unlock(folio);
> -				folio_put(folio);
> -			}
> -			memset(&src_pfns[i], 0,
> -			       (npages - i) * sizeof(*src_pfns));
> +		nr = migrate_device_collect_folio(&src_pfns[i], pfn, npages - i);
> +		if (!nr)
>  			break;
> -		}
> -		if (nr > 1) {
> -			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> -				src_pfns[i+j] = 0;
> -			i += j - 1;
> -		}
> +		i += nr - 1;
>  	}
>  
>  	migrate_device_unmap(src_pfns, npages, NULL);
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157


Otherwise, looks good to me

Acked-by: Balbir Singh <balbirs@nvidia.com>

