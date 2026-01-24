Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DE1D715EE
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 18:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8FF6B05C1; Sat, 24 Jan 2026 13:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFCD6B05C4; Sat, 24 Jan 2026 13:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87DF6B05C5; Sat, 24 Jan 2026 13:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A32746B05C1
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 13:37:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F2071A0259
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:37:45 +0000 (UTC)
X-FDA: 84367716090.14.70146AB
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E8F740002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:37:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BTi8e1Xi;
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.24 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769279862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GwET1+JA8ifTA+BxjCSO/C6Vw1EaAXJG68dZ81WbOI=;
	b=Jr0Y9mrQLxA9Ggk/F8g/wiUXWoRxPLI8bWPESUc94E67OcT+wrBPpQu3Bjjij3EwDPT0R7
	ljaBgAHWoDV/mk8/Y2onszFS9a6ZKSc5t0D3XWJ5sGwe8EYcEBNA11ngAmq6Y1/Xv1c7yA
	ehyXUkkXf06tzkhQWwdKnZeL9F04zBo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BTi8e1Xi;
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.24 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769279862; a=rsa-sha256;
	cv=pass;
	b=O8sEDSDn4lnSvwlcr9mvUGNsHnmqTV0sqQfqerhunSXcHpe3CLdQa3l7bqoYa49YmmxszP
	yUz2zlEl1mKwINfsiVVgQo8Ff12vztI5COE4ssJodWEKAKHjsOO3caxGNaYvu2XiXUXvWr
	mWvNOsIlSvHbOrjILRMtfIpVdGGIDco=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLoOV4vQFybZSYXoFcK0W6GmIxpsBXRPLviIBTJkkfRUpHA5XGiibrFi35rNU72Fp/wGoWELQ7i76RbgEjUpJpf+fIRWfEvw/Om1zJZyMOCYUaNJO/s5N94oEx+IJAlpSwYWYgLRvxhcNygaeGLqjG+rRfz1mXGmo6m+8LmvVlvR7EJJAwUbfECHC92RxLtvmeLnP3NK7MbH1aTKArg9VjnM/MuU4yRZEa+QlzR1k2vFvAFV3SQSxKcIKIjPeuuh8m9RIKBcUdNKpbsE2yF310ki39RfkWcnieG/zLJUOYN15Sf9fj2XQ4eYzCogRT8A+HX5LCo2p6KoWdDxpLhewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GwET1+JA8ifTA+BxjCSO/C6Vw1EaAXJG68dZ81WbOI=;
 b=xMbgQoZoqIWiabxj25xnvlI36Tt0C+nVdGowYduqdL06lpAdsqzVfPnE/1E+ZXG5RZe4EYP7gp1V2oM2/yDY4W5GwLeFENN3Ni92Ehm4TXxBhYJNaCho/6TEzMao9LOdWWzkh+TX3Q8wYfNRFcdci10xjqshmH/0CGsjExMIsdcXK0YuqhNc/7ye4wc0sXbBtObscykHyZi8cyYPTUDzeh5z+5uQxQC5XKA3SvVDU5jEwnVS9iOD/1zUkUn8S2+TjQytF4EkFelKEp+8dlXsXDub7UWFf1PxFWZ7M/GNDRHPoVQHQdf3vJX9ZZrPkf1jJnGPSvtdDH0BHdFFtmLw/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GwET1+JA8ifTA+BxjCSO/C6Vw1EaAXJG68dZ81WbOI=;
 b=BTi8e1Xi0c3bcMjwtNMjNrNN501OTJjVHhT9+ljvlnKdc4olAvzsC80BUHZraUpueDXcq6qftHRSX7tzn+T1QvbS5j12m0Q2jFrQsyrLoY2Hkvd3EWLaXqOYnRPfPc0a8/NIxj96n7Gdky4mhEkhlily44uGci50O2Xh04OU1Uc=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by DS2PR12MB9614.namprd12.prod.outlook.com (2603:10b6:8:276::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Sat, 24 Jan
 2026 18:37:36 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 18:37:36 +0000
Message-ID: <cc1d2fc8-5d49-4b80-91df-3e3cf78fbc6e@amd.com>
Date: Sun, 25 Jan 2026 00:07:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
 <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
 <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
 <50da84da-1cd6-4b8b-babd-b6dea405713b@lucifer.local>
 <94c84a3c-8ed9-4bb5-8e64-69bcb8306aba@arm.com>
 <7ac06a41-73c8-4089-873e-7bb4cc1b3e02@lucifer.local>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <7ac06a41-73c8-4089-873e-7bb4cc1b3e02@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXP287CA0007.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::14) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|DS2PR12MB9614:EE_
X-MS-Office365-Filtering-Correlation-Id: ed421427-8745-42d7-eb0a-08de5b77a4bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXpuUFlnTVRmUjJHUVMyVjFnclVlSWp0aUcxYjVwcEhXaDE0ZWxEZVUraUR1?=
 =?utf-8?B?UlR4MnJodTNRT1k1N2xkejJNQm8xenFMc3FvZ2l0ZmdpeVZsdVFPdHFpN051?=
 =?utf-8?B?eUZQQWRTVUtBdFJIOHAzaGNsSTE4NFl0SnBPbzZhZUFtWVVzUG1QSUF6Sldw?=
 =?utf-8?B?dGFPaXVwelRsa1dLWEZwWExkSU51UWp2bDRnYmkyb1dyUEdBcGNZQUtCNFF1?=
 =?utf-8?B?UUhmUTEvWUliTWRWOTNHbDcxZVNtNmJ4SHNCL0JEQ1hkcjg3Rlk1U1NYTHhs?=
 =?utf-8?B?QmhKcUVhWHVzSEt2RElhNGJ5clQ0Nk1CT1dHLzVSVEQycnc4Q0Jnc1UrdEVG?=
 =?utf-8?B?NGl0WnBlREozZksySGZnbmplL2xpVVRhUDhSZFFmNjlNZTRraEljUTl2Z1li?=
 =?utf-8?B?RTk1d0FDbWNQUisvYVRFcVB2SEIxMmFZWHEzSnNDdStDNklRamd0STNqVm9Y?=
 =?utf-8?B?bU9yeTdxajVSRGEwdHhaUU82Y3RVUzRtQ05melNjbkdCQk1tcmhjT0tNcENs?=
 =?utf-8?B?RFZlU0xHdTNQOGhnZUNEL2xwY0U3ejFBYlhyZ2s1M3pFSnorVzB5NkpYZ1pn?=
 =?utf-8?B?Tmhvd2ltZi9jbXFZQ2VhV2U4YXNiNmhaWWpEZ2ZwQnpTZGxkQW5IREFXV3Rk?=
 =?utf-8?B?NUZRbWM1d2ovWDdWQzkvUnVkTFNsb3EzSGR5TGFLMHladnpVQlR5WXFXbjMx?=
 =?utf-8?B?UVJ1RDNqVGRYNCtPL2szRGo3clpiNTNZUkdYQmxCOWc4WlRlanpFM25wZm9E?=
 =?utf-8?B?NHFBaU5zSzFPUVRJUmdWd3EvL0ZjMmt1M1VaRVRHeW94MVRxUUZtbng5WUVs?=
 =?utf-8?B?TmVveEpTejl3QktpbnFhLzlBQ00wU0w4UzNVN0lmVkdvVy9YZTIyVjUvSHM2?=
 =?utf-8?B?ek9PbmJ3bWdrRSt1S1FBWlZnSVhCbzZyV1c5dWMrWWFBR25yV1V1NkN5YzFR?=
 =?utf-8?B?RzFqaTJpc1BxOGltcHRvNWZmQXY3eW42T1VyRTFiY3hEYWZtcTI2R3QwM3U3?=
 =?utf-8?B?RVZKVU5EeXNrOGxpSUZlZUpuZUgxTkVnSmNMaHlSeEJpKzNZSHo1Snl3RCtt?=
 =?utf-8?B?ajZaTFNBZFhCWnhUbHVmZ3dLRE9nVE1Oc1lwUlQ1MkdkdGRnMHNKRzZiMnJD?=
 =?utf-8?B?RkxDdDhmTjQ4SkVFU2xncmRqVEFqVE84OW5qV29tMDRuZ21abDVkUVJ6VnRD?=
 =?utf-8?B?WlNta0FhZklMbzZNTktlRFcvSDFpaW9RNVBOeDhkRDBXRnBqRVNYV0JtK2wz?=
 =?utf-8?B?YmxLVWd4QnFSY3prWkJDTjNGQVNZSVFWZ01HVzMwb0NScWdEek9CMGtKcU94?=
 =?utf-8?B?RGxoeXBDRkFSOVZ5eUorbHNQcXRGVmpPbnRwMGZ5ZVlyMk9WUm9rYW1MeUVh?=
 =?utf-8?B?MENNRmpCRjJjSEFUUGVJK0xYVm4yd1BPTHFob0NmQzVRMGd0Qm9FTnFXK1Fr?=
 =?utf-8?B?VTJObzJGaldXYXJVUzBIVnBTOGduOWdOU0hTeHV3TDA0eUFCeFVCcFNvWnVO?=
 =?utf-8?B?T1phTmcvOVB5WjNTSjBqb2NtQUg4MGk1TDhuRU5QSitLZGRQNlEvNWp1R2xh?=
 =?utf-8?B?OFhxaUp3MW1EbmUydkowN2ZNQnlKdGptZTZNcFNrZDl1QUZSMVVKUTNqZ3Er?=
 =?utf-8?B?Q3lleTA1RDVTV2xoNDBKcUJqUXBlVGpheXEvaVRRcmwyMitJckJNeUlza2s0?=
 =?utf-8?B?STNFR3ROWmo2N3JnZVNQVFRVOVpuWTREZFF1UzhHdEoraGdsamkyMmFDSnVV?=
 =?utf-8?B?bDh3K3llVzNOb0UyS2RrQ0NoWW9NN1RoaDFSa2x4RktJM0RjbnRaeEVDN3lI?=
 =?utf-8?B?M3BwTDRVeSs3YStqTHNLU3RYV3F6Lzcxc3VXSkpwenIvWWlRMi8yMGpaZlIr?=
 =?utf-8?B?cmdvRnVTNmtYOHFMQUxTZndlRVdQUkZneFdtUXMzeVV4ekFmdkYzNWZ5b0NP?=
 =?utf-8?B?MHBycjJOUTFaWlU0RElEM1FCc1VlZEt5VWpMek81aEx0c21rRWx6UHgyaWpM?=
 =?utf-8?B?YU1QMUNlUHZ6cWx1ZlVOWjNzMDNwbG13TCtYeVcxdnlpY0c2TmhzU2RmNmtN?=
 =?utf-8?B?RVk2MEpvM0xSbzFNOTdhVDZrdGdjcjY3TldBbVR0aTkrdHBFNFhFWHB1dWFp?=
 =?utf-8?Q?AKnc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjJtb21ZZlQ0WU9RM3g4MkYrVUVxRjVlSzc3dmZlMUJqOWRnbGJiZzdhM1dE?=
 =?utf-8?B?VmNGRU1VN0FuNCt4czJvbHlUSy9FRVVJWDhzeXBzY3JaZGVLUEpHRkU2bmxE?=
 =?utf-8?B?TmRRdTZuelVjZTRnQWZrWGhpMnNxVmRrQ1Y3WEJESjhoRlA0VXNWOFgzdVp3?=
 =?utf-8?B?NFVsZVZuUVoxM0tuTHRtTFArQXpqbWVSeUJvOGU0VDlhSURLQ1Y1M2U0bnFr?=
 =?utf-8?B?K0dkRVBrM0FrcWQ1UXVlVS9TZVFxMmNjMkx6MTVtVVR3NTBDMkFjaTVvZ3JS?=
 =?utf-8?B?NXlqSDhWRWZ0eUQvSXBDWS9XdFFFbjhoRDcwNXRKdXZ3UGtLeWJxQWlQb0J0?=
 =?utf-8?B?R2ZOcWluRlhxejFNYWwwSSt0dGhxbDgvbEEvZzNJYzZsWlNFUU5HTndBdW12?=
 =?utf-8?B?Y24reERvOVAxbEpyN0VmY0tNT1c5UFNaZFFwS1dvWURZeUJBcjJMbzlIN3hr?=
 =?utf-8?B?TCtWbi9sVkpKbVNabW93UG0wZTQ3bnhTVzAvNXZBSEh0LzNUSUMzQnpxajlX?=
 =?utf-8?B?L0hoN3gyZ00vNUdBUytnanA4YmZJZmRWSE5LVkp4Nk5FdVdyZDAxN3FTT1Rp?=
 =?utf-8?B?U1lDL2lXNlRXSGNPNFdsZ3MyVDF1NTZNanhjVmRURUZPNzVBQmpneEZMam5O?=
 =?utf-8?B?bjdJNGZ6NTkyQ1kwR0hpNzQ3Ylc1TXBWV3ljRUgwcldGRktHVU9Bem1ZQ0xX?=
 =?utf-8?B?S1lNZ3hPZ2hDTkYwZjF3bjF6eTgyZmJ4NnlzNGxYeUJLeEJnNmpESTFjd3Rr?=
 =?utf-8?B?U05rSnFlT2p0aU1TdEFBUmZtMGh0UUkySGd6T3VKV2p4QW9kZlE3QWIydGwv?=
 =?utf-8?B?SFNvQlVrY3E4czVJdEtPc2JhVE9pdmlPcHVJOGlvcHcrT213RE1ROHFJY2xH?=
 =?utf-8?B?dlVDYlFmeHBTK2MzbTZqaURZbkJPWkYrMXAvOXJYUkZvbnFxbElMY3FxNVZj?=
 =?utf-8?B?MVJxdFVLaUNxVjBoOWZxb2ZCbjZrSWJsTFdDOWlQY1lPN0V6dSt4dDBpYkVH?=
 =?utf-8?B?ekFLY3ZZcnFJT09RYWdNcC9UTldNM09ESHlpYjhKYnhPTkJPNTRmbCtmV1Vz?=
 =?utf-8?B?a3gwTExTOHZlVTFnWVdsZzhzRDhpbm1IVTZLTnhtT2lYU0R3UmxNSnRad09k?=
 =?utf-8?B?OGVTclZFT255aEwra1QvM25zTkJtT3RZN254YkhVczlvVzJrQzhWU3dtZW1w?=
 =?utf-8?B?cXlwcVQxbVhpWHhTYlBQOHJDVUNsRTZaT21Qb0N5WFFlaERTenMxWHdXK0Jx?=
 =?utf-8?B?L01WNU1LMHlPb3pucXNveUZLWHVTcE5YYjhEWjZ1Y1R4NFJEVGFVTWtEbURI?=
 =?utf-8?B?OSs5cnd4ZHY1Q1RvVmJRYUovTWYxR2dzdHR2VVgrN0JKMCtzSHFFbExuN1pt?=
 =?utf-8?B?eFNwOXRpYm0xOVRVSjl0REd3azJjelpSM29pQUZmMFhhdTZqamlldk5uZ0R2?=
 =?utf-8?B?Z3k0VXRWdE5sRzRiY1VOSHhaV3E1aDVjblNZN1hmWmtGTXNhZUlaNFlMbFd2?=
 =?utf-8?B?cXJEWWx3WWQ2bzJReXFGZnFwT0xzTENaaUg3L1RpV2I1UURmNk5MSGdrZURw?=
 =?utf-8?B?T3E3a0ZjS0RyZ0NJeUtkdWdoR1VPTzh0SVkyOExKV29EUkUxMC9MQ29ia1pP?=
 =?utf-8?B?UVY5ditoRUgrNVpZaXMxalNDaW92T2xXOVlwUjFaVU5uY2ZsSjR2WStEY0xU?=
 =?utf-8?B?UEdxMTh5b2EySDY2TVQ1b3dORnd5QWxSRGtlU1YzNCtyQndBWEl0OUFxcWpU?=
 =?utf-8?B?cW55VllJZTRDUEppWWNUWUFab0YvV2xKNHY4Vm9uWlBCaVpBUFg3aDdaTU9S?=
 =?utf-8?B?QkdWdk5sNW9sVGZ0NG5vMGQ4SzJ4cHl4RGZHeitwOXR2aUpYaUVvOEVnWXZB?=
 =?utf-8?B?UEV0bktCVTdvczZPOFBJSkd5NTk1RU1JS2x6WUlMQmVSRXFPdUtZTzRIQzNE?=
 =?utf-8?B?cnhLWVdPaCs4N0pWMHRKaUhLeUZnZXkyQk9XQ2haOEh5ZzUxRTh1T1N3S2Jm?=
 =?utf-8?B?Vm1EeGpJc2ZnNGVuWC9rK2F4bEN4ampLclhzMzhVRG1raUMwSW01WEFWKytK?=
 =?utf-8?B?L0lCeHdoN0k2ZHBXMjRFeVZERjV1ekYvZERHU09UOFlOVDB4TnhqOHBNSTMy?=
 =?utf-8?B?RHdJRXVLNk9iS2xwNUlIRUJGSDJlSjNsUXNURmMyTHQyTkRGaVJyQVoybUto?=
 =?utf-8?B?NzFTdENkSUsybVY2ZndHVTM0d2I1bUx3Sm5oOGN4WHdQRDRQRnBkNnA0MzFV?=
 =?utf-8?B?Rm94RHU0Y0Nqc1pLcXdFdVZKejhvZ3EzdXp2dEE0YlZJQ3FST0loZGlwKy9p?=
 =?utf-8?B?QTNpZ1NCd0tnaDU5L3ozcGU0TUFIK0JoNEJsdVI0bFlXN3ZUMFlqQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed421427-8745-42d7-eb0a-08de5b77a4bd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 18:37:35.9648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zaf7brmN3kqGodmGDnNvaOS85FnWtI9gTYL5xpYd9FBCa7tGiKpCi5UCJGtfKLUmI/TEh3J3asHr/zpAteyEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9614
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E8F740002
X-Stat-Signature: w7m8crjpzsb1xfjuiercgx18cgcs146m
X-Rspam-User: 
X-HE-Tag: 1769279862-814732
X-HE-Meta: U2FsdGVkX18YP4iqW8Sea4xPIDTHoNSu436/XJnHz3zn1NV4dMGsvhilEGYgAZHnZVsJP0CFJY67h6haU0iYD96j2e6BvIdQRUtepeuAgkjK8+I4vS9KKLlV+Po8OEtWxP8Xx+eIANlsCCd56KwUIUclaiF3TdRipGs/sz+1Mscvzql4yps0JM2gs9ZXjKuZiEI5N/ro3HYh9c93vhhKYnojlWeEGYFnIYXBV8rul40rSLc4XXXPv0R/jGVrcuqo5ggIeLD1fLNiIJ29JTNf0kVM7nYE5xDvXHaWjDVKXragsg2LL7wncfhIPr0WQP4Yr0+LM6UdWX4tL3O9bSTk7h+iTZAokBW/Q50bkcah/eLUCtRpIpmdcCpDFfS0jqujtkmxyCe0/0hnHCDFTuz2XRImxGe1T8kklYBtSSVrTzufZjhtYa5FN7Mz4zIT9b3+VqM0E4wcaFKn847xQljiboEy6V+QUN3y7ivzaxFpmJYIKYw1J8yqBtR2dI05EwSdfD3KxzMZx0b5ZsdIjDhqOCTt7Jb1NpoFty2wNfo1Ktagwie3SPIxqIvkgTKO01rIk0F0IXEZS7ZwGzbDImGS5ZVG10leQOKyxpWbZs78LKHoQsHux9nc77LMSs8Lvjswf43gquH5u/hqhNOU1hTwHDWGQnrqbY8eK/MqD/SGQaobSetBVDYUJNiFyBjIFKa8IVCWjmDQhpHs3SGCsSa1PJXYfBoCzpf48CntcpMz/7UFcizFD0ud1UizGlpBXsZONXTiY8UFgw/O3X5tmXWuxJ47Q/QLyf8fxhpKzmgStdfxtWAbwYFOvOUIfSQKKd7rrDp55UZNLqAUDGxft2iPNHM8nw/PRC7ejy4VX5RM/tv/Q4KYECLFO+kTIDJOnaay5CSIFJduMVmsrddatkFpRnaP2hwpvVYnE8EupOo8r/2D97ToLuKIIgbtb36TqkFAjo2a7zW6mVto+bSq/xG
 Uo8d3efd
 SpuAUz/XdST+M/yhfkkhlnSIZwJMKhW6Ww8JKBEAfT8eD69DpARADqCnPAGJPQvvboKOFp9rxjLgug00Vxar4f1Fg9za69EocVRPfF/JboraP6Y/gwAbbLslzuKl8sO0nobM1qAnlHI/O4S8KEKGm46yBfPBTuElCwZzlGGxcTKfiO6r6DbjZ/lKMZ5rguvwWkSSGailifxBHj7ltMCABGLl2jaxqZWWQxzSDHNzH4BaTfE2GvlWslPBuI/LgLMVhIBTi5/GFUqDgOb1tfZLdvyPO3l8tK5rih4AEVP+D8lRYMTzHgYMX0hlFxys21OgsNTjyc7OTd5Wo2Do1DnmJgoDK2Zs8yxXYU1jEx+f/zVe8RQ7Z79rHNjJfnW31uNmx2Wg7+eVQH82Xj1J2uxte02z+XBL6nw0geRKopcX2pAzxo2fvz1cGKHsI6PxvZebXjNroE+A0H00nTcdXWdAKFZ0bmgeF1YAW40yVDxJrZT+ImoG9jQnk83xVzBIBC+YKiCnrcnYUZGRPR+XDFkM9vP9Sw2IRoCXgTQBgFvbfcESli1Smt/R45pL7+9EGIg4F6q4rM6c0r5lzSBpG0Ty6BofYKAZntDofBCfYK8iVuSS2IorKThiAs+gid12K/6nloAd9PZ2oXaNd/5ZlJdbMhgROzM2pEthuyOdXJ3IUoKsqLAdFFocFv9g8jXAgXA7S/RdN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/24/2026 5:10 PM, Lorenzo Stoakes wrote:
> On Sat, Jan 24, 2026 at 04:24:24PM +0530, Dev Jain wrote:
>>
>> On 24/01/26 2:31 pm, Lorenzo Stoakes wrote:
>>> NAK to this change....
>>>
>>> On Fri, Jan 23, 2026 at 03:03:58PM +0530, Garg, Shivank wrote:
>>>>
>>>> On 1/23/2026 1:18 PM, Dev Jain wrote:
>>>>> On 22/01/26 2:58 pm, Dev Jain wrote:
>>>>>> On 19/01/26 12:53 am, Shivank Garg wrote:
>>>>>>> The global variable 'khugepaged_collapse_control' is not used outside of
>>>>>>> mm/khugepaged.c. Make it static to limit its scope.
>>>>>>>
>>>>>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>>>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>>>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>>>>> ---
>>>>>>>  mm/khugepaged.c | 2 +-
>>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>> index 1667abae6d8d..fba6aea5bea6 100644
>>>>>>> --- a/mm/khugepaged.c
>>>>>>> +++ b/mm/khugepaged.c
>>>>>>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
>>>>>>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>>>>>>  }
>>>>>>>
>>>>>>> -struct collapse_control khugepaged_collapse_control = {
>>>>>>> +static struct collapse_control khugepaged_collapse_control = {
>>>>>>>  	.is_khugepaged = true,
>>>>>>>  };
>>>>>>>
>>>>>> Will it not be better to just remove this variable? In madvise_collapse,
>>>>>> we defined cc as a local variable and set .is_khugepaged = false. The
>>>>>> same can be done in int khugepaged() - define a local variable and set
>>>>>> .is_khugepaged = true.
>>>>> Since this patch has been stabilized already by 4 R-bs, it may be a headache
>>>>> to now remove this, we can do my suggestion later.
>>>>>
>>>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>>>
>>>>>>
>>>> Thank you Dev for the feedback and review.
>>>>
>>>> I've attached the patch implementing your suggestion and sending this as a separate
>>>> follow-up to avoid disrupting the current series.
>>>>
>>>> I’m happy to queue it for next cycle or if it’s acceptable now, please take it.
>>>>
>>>> Thanks for the suggestion!
>>>>
>>>> Regards,
>>>> Shivank
>>>>
>>>> ---
>>>> From: Shivank Garg <shivankg@amd.com>
>>>> Date: Thu, 22 Jan 2026 12:36:28 +0000
>>>> Subject: [PATCH] mm/khugepaged: convert khugepaged_collapse_control to local
>>>>  variable in khugepaged()
>>>>
>>>> Make khugepaged_collapse_control a local variable in khugepaged() instead
>>>> of static global, consistent with how madvise_collapse() handles its
>>>> collapse_control. Static storage is unnecessary here as node_load and
>>>> alloc_nmask are reset per-VMA during scanning.
>>>>
>>>> No functional change.
>>>>
>>>> Suggested-by: Dev Jain <dev.jain@arm.com>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>>  mm/khugepaged.c | 9 ++++-----
>>>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 9f790ec34400..c18d2ce639b1 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
>>>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>>>  }
>>>>
>>>> -static struct collapse_control khugepaged_collapse_control = {
>>>> -	.is_khugepaged = true,
>>>> -};
>>>> -
>>>>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
>>>>  {
>>>>  	int i;
>>>> @@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
>>>>
>>>>  static int khugepaged(void *none)
>>>>  {
>>>> +	struct collapse_control cc = {
>>>> +		.is_khugepaged = true,
>>>> +	};
>>>>  	struct mm_slot *slot;
>>>>
>>>>  	set_freezable();
>>>>  	set_user_nice(current, MAX_NICE);
>>>>
>>>>  	while (!kthread_should_stop()) {
>>>> -		khugepaged_do_scan(&khugepaged_collapse_control);
>>>> +		khugepaged_do_scan(&cc);
>>>>  		khugepaged_wait_work();
>>>>  	}
>>>>
>>>> --
>>>> 2.43.0
>>>>
>>>>
>>>>
>>>>
>>> Andrew's already commented but this is terribly mistaken.
>>>
>>> The argument against it (why did nobody check...) is that this struct is HUGE
>>> and there's really no benefit to doing this.
>>>
>>> Nico's series makes this struct even bigger (...!)
>>>
>>> Dev - PLEASE use pahole or sizeof(...) or something before suggesting moving
>>> things like this on to the stack, in future e.g.:
>>>
>>> $ pahole collapse_control
>>> struct collapse_control {
>>> 	bool                       is_khugepaged;        /*     0     1 */
>>>
>>> 	/* XXX 3 bytes hole, try to pack */
>>>
>>> 	u32                        node_load[1024];      /*     4  4096 */
>>>
>>> 	/* XXX 4 bytes hole, try to pack */
>>>
>>> 	/* --- cacheline 64 boundary (4096 bytes) was 8 bytes ago --- */
>>> 	nodemask_t                 alloc_nmask;          /*  4104   128 */
>>>
>>> 	/* size: 4232, cachelines: 67, members: 3 */
>>> 	/* sum members: 4225, holes: 2, sum holes: 7 */
>>> 	/* last cacheline: 8 bytes */
>>> };
>>>
>>> Making this static was fine. Leave it as-is.
>>
>> I wasn't suggesting that! When I said
>>
>> "In madvise_collapse, we defined cc as a local variable and set .is_khugepaged = false. The
>> same can be done in int khugepaged() - define a local variable and set .is_khugepaged = true."
> 
> Yeah I would suggest more precision in your language in future :) 'as a local
> variable' and set . not -> is_khugepaged true... I can see why Shivank
> interpreted it at as a stack variable.
> 
>>
>> madvise_collapse does kmalloc() to allocate this large struct. I was suggesting to do the
>> same for khugepaged, to enforce consistency.
> 
> As I said in reply to Andrew, NAK to the kmalloc idea too.
> 
> This consistency argument is nonsense, madvise_collapse() does that because
> _there can be multiple instances_ of the cc around for different processes, you
> literally _have_ to kmalloc there.
> 
> For khugepaged this isn't the case. We're good as we are.
> 

Thank you Lorenzo for explanation on frame-size/pahole and single-instance vs multi-instance pattern.

This was a valuable discussion and I learned a lot from it :)

Best Regards,
Shivank


