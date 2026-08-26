Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC35C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6C96B0088; Wed, 26 Aug 2026 12:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6F96B0092; Wed, 26 Aug 2026 12:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95F86B0096; Wed, 26 Aug 2026 12:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B07A46B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:34:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38EA0A0186
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:34:58 +0000 (UTC)
X-FDA: 85143969876.18.A2571B9
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012032.outbound.protection.outlook.com [52.101.48.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 574EA14000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:34:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="o7/lGbUy";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787762095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3wdiYMff+zOVKYMJAs6nLjaKyXuSNz8qjUccEL5KRs=;
	b=4cQxuOdzDCs+A1ijM2nAggsjozBXrhc2iRk3sNxQasGm5Vw5V6RqLBFh3WDZhD5QbTdw47
	MYmoXjF1yBRmhXTgOAF74e9e/KYgO2y/72uyvDNaKeqJKBY/2JaH0W98umuykNjJi9dQg+
	Tb7AHHUGKzG6BcDDIqblXTnkQdRJb6Q=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="o7/lGbUy";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787762095;
	b=u6NTWXgNDgEGONLiPpIfPSNpyN0Bq3uz3G163h9OU7biO/+ZRB0vjY59WSj9IL3etVbASp
	QKljnPlHGNS2nEJKL2egOWfBOyMI3AR1lswCvgBeSUlEdCRYg3lkh6/5DNXCvMlNS0BeQe
	jwmkV4yzcyOmqrDtJ0XbsEy21xEek4M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPqcSi7Q3p1qP4D4xzCTo7GKXD6B4pK2G+sTZWGYlKDMlCFIOhdwXOGyz1cgbYbQKQ+oKa2UppT9KZiRH4127CJ218jy6Spp+Yl/ksMamLLG4DygrUDOtm0qqQVY6NNbFSzBRwfijS3T/X8TVbZlt7e9Rl6pdmvZqopm1u3uiSstd+a4b4rJM2KYAx7M4odVKSaxkdipkbdVYiUbRNSI1Sk2+CjjVvr5L6amX/A4jECthb8NS9IrSq6QqEar3M5o0Flnk3tM1PG2x/SK36IbY0+6f76/DZRvxa9YTJ0kMDjF2iu0YUWiAci163hEMrUaj3yWIEqM2bTtWOxPjohj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3wdiYMff+zOVKYMJAs6nLjaKyXuSNz8qjUccEL5KRs=;
 b=KjNX1U7145Qw2AP5iMgXiiGsPCx8l4qYtOXrLbsHDl0xMQiBpnouYMUSiFawHpKoRF6pnHlsrSFzafNRpNQK73EY8fZ7X/Uezp8BQ++LRXEakS14g8qnA245DYSJsRo7hfsNOF8RFUh9YqBORXiqCvAq/I/PpRUKHeP8PssFrHpdCyHhSsdsxJbqYO8b5Hq10Uo1T+HX2cZR4JehJgNZb1n91C1fKg/6YSGM65gkrEkyC5HivFNgDbDIAIh5jEGOsTMMNW7sJf6sjRKinlVKzhtgMjXA9/36EiMdEHEQqKcZb3GAMMABAR+eGYXVXoAcayPObQ+LlpB0xInzjcsjpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3wdiYMff+zOVKYMJAs6nLjaKyXuSNz8qjUccEL5KRs=;
 b=o7/lGbUyZRF/itNrBsd5MtRP6yPsEsPvzOxF013leL+IDeUgT48HzF5LXkNnDNBVjOI9q1szMuzJWiuEuBcI3u2Q4fd7IC64MBW6Nwd1GzgIi1EEqulgpeYwIm0K7Y0kjyclHwYop2FgXORPRcFyjxK/S5FZsTCFTdWFFT0wRAxX/gvRUKOo9PrsEYLm5u3xPou6qYSbyIUkx1DlzDCSTWmNOFY49NXUQLMPWfMn/Q8l3j22bNECG6Hgzt4bCKgNiVjQ2iwH8j8sagqm5KSqxGKSeYtS7qVqZOkykUwSAzMuJ+0qCxecWwNy+lpcrQ99otE2o/3UemwScN7al7EKBg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7886.namprd12.prod.outlook.com (2603:10b6:510:26e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 16:34:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 16:34:49 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Aug 2026 12:34:47 -0400
Message-Id: <DKZ0RP174ZWV.1DP8KKRE1LQ6Y@nvidia.com>
Subject: Re: [PATCH 3/5] mm/huge_memory: reduce indent level in
 __folio_freeze_and_split_unmapped()
Cc: <lance.yang@linux.dev>, <hughd@google.com>,
 <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <dev.jain@arm.com>, <ryan.roberts@arm.com>,
 <balbirs@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <hannes@cmpxchg.org>,
 <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-4-kirill@shutemov.name>
In-Reply-To: <20260826162101.1314941-4-kirill@shutemov.name>
X-ClientProxiedBy: YQBPR0101CA0078.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 82392067-11a9-423e-42f0-08df038ff29d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	42D5QiT+7C37uQOhnd2uMmVHkdiGW3B8hqKyh1u3sCu+exxfyLo2snWAUd8QDFgowIuNMe5OljafNPxHkm1PUSVBLeRrFD8Yb3A6w6t81Jhbhw0v0qxOqcaYRM78t49zCqc/K6djd71jEqJsVGTvuxYRjzi3ni43h8U6M3CCAVzg/V9i9KfN0u/CEDcNyrVvuelVzTicnWmp4KwBSBkkwxYCDKS/rqninvSTSfs9Oe2s7Cqa4iJuJQZdWhcMKHqLAmgDYfoDz82CUJj3gMuFNEJAqLuzRmX+RpUTQpvqcbOH5GP1nnulwqR7JXKz+B4iN6MTHCBplrkbl2FGHA7TM0bUYZGcSeTJtw4fFzrqwd/9Fihnquigsis/jYHSN0ImXKBuTp7RfNg2cqXcTvFpWqUEyjasysw5a14g3q3CKtzZUIKwy72KjgKxculeYdc0flCuuszBQSnY7DgJQHjURzfmys5L2TStifK6ui5rWOFvgYJaPcdygd74Vxzy4CMkXcZQKDssqSlVZgDbkqEMWjultZ7I+QOXbD1Sz6BLRE4d6P1Zom3ZEDl4HJFsVyqypUOoORWwhIzAwIcmBrXZ+nH2GOPiaMQxX5cuG4iNcU6ewrWtTRTbCh6xKEHT3uIjvGT1j0UBBLTkpY9Stjx3yXC4R05Z3/JATfJ5A+SGGTE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2xqUjJ0NHJkejJ1TjJkQUdCV3lNb1diSnF1emNkQVoyZFhBMS9HSHh4SEV4?=
 =?utf-8?B?QVlSMkJDRGYzZDB3aHNGSE9hUC9vTVY3ZWNxL21qZmtQd2ZkU3dpajJEcG5n?=
 =?utf-8?B?UkRRdythUnZHeU9hem9GVnRMNEpZNS9hOGhEK0hjcjk0Wk9haGZ2YzdQWkZh?=
 =?utf-8?B?WnlvOUkwR1k4YzJqMlF4QW5kR1V1bk9XMm9FcFNMZDdpQWcxRjlydG1PRHlJ?=
 =?utf-8?B?SC8vVnF1V0xrcjlQUzhuNGVLaXJFRHFmU2s1eXRlTXozN0h0UWJqVno2RXl5?=
 =?utf-8?B?UE1FNkp2WnBtZGlDVXMvOHo5dzdwVjhJOXdjdGRkU2wvL0dybXlGWjd5T1Ev?=
 =?utf-8?B?OUgvdjZiaVZieURaZ1pNaFU2Nm5tbVkrTmEzQ0dYV2h4UEhIbFE2Y2VpcGps?=
 =?utf-8?B?dTAyekp6THZqdDdHVkZQOFJJem1ScGlFbHd3SDhVRGp0RGhTK1pOWjNUeWkx?=
 =?utf-8?B?N0k3SHJ3Q2hFbEh2Q3ExMVpIOVFoaFErN21HWXlHbmdtS3U3eWlhRjFYUU9C?=
 =?utf-8?B?ZnNqMGpHUGJXSUx1czlPVXNWL3I0R1BzQzVvNExBRUw0dW5GSkgvWVdEcWRN?=
 =?utf-8?B?MEVQSXZPNndSTTFYUyt3blpkZHZZaEt3YVVCUzZ3WjJzVW1Ra3laY0xsV2Q1?=
 =?utf-8?B?M1M0SFpaZ0FPWnFneStIR2tuTVNHTTRSekQzMUpXSEtHdFhhQ2ptNGFCQ21I?=
 =?utf-8?B?NFA2WWFqd01SWjRNSThXYmlaTUpVSCtPU2ZvNzhzcGd1Q29NWnQ4OFRSaVc0?=
 =?utf-8?B?RUFVSjFLaXBLZEhFT29ZcjZhL0NwTk5MM0pEQ1MxcFNrWldlZGpkTG5iUjV1?=
 =?utf-8?B?ZW5MR0xURElINjBQall6MWhTNklkQjFSUWZtVzdNUkNPdEhLVmhLRXExNFNi?=
 =?utf-8?B?djF6NXRUUkxlRThMc1Y1NENXdGE0ZGk0STJ0Q2RsbXQxMC82VVpSOG1IN1po?=
 =?utf-8?B?N3hNQmdWbHlrNFlkOUlmSDZodkI2NjRUQUJDQWdjYWlVVWJWNEs4T3paQmlE?=
 =?utf-8?B?dHg4M2FhQUFWWDY0MzNwU0pTSmV2V1Z0eG5BN21KYWY1b3VYNmhac2syM0VI?=
 =?utf-8?B?bmZiMzYrcmpLU21EZndIOFVpMXpnZHJidnJsYnZlQkxzc2NXYkRQMXVKNDVT?=
 =?utf-8?B?YndiN1JmVlJ5ekVIbmlDeFdoU08vaXI0OGZKTThDdGJYZmJyc1d1V2IzUWlz?=
 =?utf-8?B?UHVlWGhuS3FxZmY1T3NnUWwvMnhhWDVHVHU5ZFlqclZuMUxpTXk0TTVkMzQx?=
 =?utf-8?B?MzVBQ1B0dnpyd0cyYmlqTEwzVGhtS1paci9VRHdkOHJzcFJQaFU3cm81b0Jk?=
 =?utf-8?B?Zm9lcG96aU9QV3pOYUFtclV4SFRFU0VkMFRGOXVmVXZoT3pmZ2dqVjRINkRD?=
 =?utf-8?B?c3Awd3VHQU9QN05aOWxzMjlJeDJzQUNoZU1QSkpjb05FdWxLQ0FzM1lIbzdE?=
 =?utf-8?B?TmQ0YTZEb2dCTk1LWGg3bitxOTVLcWZqYllMSzd4VS9ESEdzQ2Q5T05zL0t1?=
 =?utf-8?B?Q0FiOXU5WUc1ZjFpLzgxMW5xZ0NveGRyZzdtQ0NSTVYza0NMNFF0cC9rdUd3?=
 =?utf-8?B?M0FHVGJjNWhhTzdmTVdxYjl3OFoyS0J0cWJHWnh4UzlqeDBCS2ZtTFJZWmYv?=
 =?utf-8?B?a0xBUXFpTEpnS0tnSVhLdEVJdDV0N2lTbHFPOEZZZDJHMUtXQWhlNWROcTcw?=
 =?utf-8?B?cENONFF4YVpraUl3L2JmcHl2aUtQR2dhSTI3TS92M2JvcmRWVVo2ZTFhL3BY?=
 =?utf-8?B?aTEydHNjUTNKSFp1NWM5RnRlS21QYUYzVkZJa0VlTW5Ddjk0R25QbUMzUDBi?=
 =?utf-8?B?dzhLa3doZy9Jbk45SzczbG0xSlNla2hnSk5aWldmMmgvcm5UY244ek0vM2ll?=
 =?utf-8?B?YWlqZURlSFdXb1hKREZjSUFkbEFGa3J3dTBjR0NDcEYxejI5RTRaR3crVVhQ?=
 =?utf-8?B?RmpYNjkwWVh3ckhhby83ajE0c1J3ZzAxNjFMTDJRanB5R0dOVGE5dGV0TWZZ?=
 =?utf-8?B?WkZndGJmV09XTzQ0bkVlb0tvQVZ3YmcxTnR0OEpla3VEOWhMSU1rZGFsdDkw?=
 =?utf-8?B?ekpDR21qNStxSndOUUplNjFTVVY5SWdVMzRtWE16WEtqQWN3eXJncit5eW5N?=
 =?utf-8?B?M2Jyck1ZNHh1U2tkckVEMGUwYzFxYUVGcHlPYkxOVDgzNmQyU0NRazdpZytr?=
 =?utf-8?B?SmNDb0JwS2Y2SXZ6RW5YemxyUExSVXIvUkpVM2dIMktNS2g4Q2Vva3VXQUZt?=
 =?utf-8?B?YmM3UUxyQ2krNkVOVXlldk1vRStGQ1RHOXk4ajJmMGo4bHlvYVFiWlRmVHEv?=
 =?utf-8?Q?f+r9FB3hk80UNe6Cjz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82392067-11a9-423e-42f0-08df038ff29d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 16:34:49.7541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zC9tHvKUV/J0xg98opYqcukhVw+6pdD/CpZRiKYTcw1HP0dvEx974ICRE2mHstK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7886
X-Stat-Signature: cg5t33gpbfdqwxeago73mu1csssomioe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 574EA14000C
X-Rspam-User: 
X-HE-Tag: 1787762095-425849
X-HE-Meta: U2FsdGVkX1+fCH+/0Ebxm7Rbx+DM5VeCegRphqGCHgJCelc5C4NON3xApY3p3P9MGXblNTKb7In7VOD3a3K6P8F1ezG68nYzNlP94hHgJKFJ756gOk0IOspmnpaW84Ecr6g93PuO2cwLPOA8gR4hdWFcK8giIaungGCysUJYsOaUfrfTQoaDImCZGayDCLHCCqdjTF/hDrO8QSNFSRVvPSxAYuTeSrJwZ7HElzEk15CCdzWLN9Z6jELSTcGxAZtMtzDU6Mjm0Y1Vv7pR3mDrMROpPzwvsmeiNo8+ciRVhSmIyhKMSs9nJ0yrji1v3ANEmuL669uGefQfYys4HQU0IR9L0z263PSwCs7TBB0+71RlaM9Oytcgye26OSYowwZ2SLH7BswEuHPFHLtKNhTmSUoTv/MFPL8mdSNg8NQCw5CqTrqg24tzxvvGsTjgGeaJghwJsEeUCnV3/Jrln3IcFI8Dd93USaFc8yEn7zDt9GokVEfzJ/7Rz1V0g4mzfbFj6TUkZnxCx6qx9+T/PniiGhbesvmjbenEK43SOxu4MJ6CRHV+SI1fPbFma+85uwD/Qvxmrktoq3QiHOBgH5m+TphUnhex+RxJrCvgJ6/b6Wgk2F+1jgdA3kiP/6J7pOCkWi5oPNUymAoJY4mTZwQd5R3hbcATRkb4CNp12f7z5+sHpoSULFMPQPibU4SQJ1BX2HroZJx2fGLQI1vNeoNv2mOpI9Ffho9JTVT6RAJKMbjk2tDa244buT2sIaUyj1Rb3qpJV/Y/emK/kqXX4AdojTPq2VUTcgrJ0W/OaBrB9KrKID7TNUgQGdkQ03RL0DkRqZbp8i7Cl7SQ4c+N35JTKfhgV+tWR4DcNJutjV6+pmNfqOxs9Eg/l6q2D9N8ZEMjCe7s6diV8m5SW+a0tDWbZO9v/GFjT/d7wp38gxx9uXPoP0lRFRSi7mLzGf7/n24W2L58O8tZbZF1zCQd/hL
 t+MKWJ4A
 T1aIsWNkAwFhq1ezyL2oACVt1jm9Dx4HmQy8eeWc5LjoSnJkZTQcDqMxfAQ0m6xjKqGYXtyugxh+3/YEGoPHbLcUGgzI+FFh7qMemrZNoYK1cg7eQGuCok7jDL0uuE9yBz85o93Gs/CjkaAyUv4HnMYTk3XO9iL5bfpI3DXzs6VNfk547Xvn0HJJNwXMkn++P2Ac0hmLyEWaMZPdfFHHPkDUHj8SJr+S8ISDUtqMnzzQqwDY3FdLonOX/1ZzedLc1hHMxgY1PrfMw8ebZxQzOYkSUNhhVxhO6kyYiOGUV8kgdnFOxcrkSDzSy3rxHdRDiiFBjoRPh6iQOCNxvYiMqNUaIH949dTYVZtN9PtmCYfunxXiIPfL5npI4Qw3x3P11VpRJ5+ME+MZp2zW9cap7G6exsZp5Z4+VHBDEP002RQ2eNr1OUh+oRIDQPOdLVXddC6gxwJooL08msEnwvnu8l8PVNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 26, 2026 at 12:20 PM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Trivial cleanup: short-circuit the function if folio_ref_freeze() fails.
> It save an indent level for the whole function.
>
> No functional change intended.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/huge_memory.c | 233 +++++++++++++++++++++++------------------------
>  1 file changed, 115 insertions(+), 118 deletions(-)
>

Kairui has a series that cleans up __folio_split()[1]. It seems that your
patch 3, 4, and 5 overlap with his changes (e.g., your patch 3 is the
same as his patch 3).


[1] https://lore.kernel.org/all/20260821-swap-thp-cleanup-v3-0-9b43f5163238=
@tencent.com/

--=20
Best Regards,
Yan, Zi


