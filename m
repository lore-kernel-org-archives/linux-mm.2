Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99AF4F364B1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40586B008A; Thu,  9 Apr 2026 16:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF18D6B008C; Thu,  9 Apr 2026 16:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07266B0092; Thu,  9 Apr 2026 16:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C25B86B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:11:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 434A1C0FB4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:11:22 +0000 (UTC)
X-FDA: 84640112004.17.8831A5F
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5EAE6C000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:11:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hOKpzv2W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.57.36 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK4lbd7X54jUz5WTkLiXiZOX3L4LuHWxoiN3GHQCfLE=;
	b=ROx8WdIUIVLNS4Ntuv28Rk2iK9YqRPqZjteAs98t/8lE4DF4t7duhYwK14odfeAG5+a+hm
	mtzHAXb06thdKJYhzHHYrWOsNnMr6TRzRC1RRVyuoAkY3s3HLesRSh892XcXKH1amSQ4qn
	nUaWJp/LUcc5cVWSo9/yjUuFANHPn2Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775765479; a=rsa-sha256;
	cv=pass;
	b=VSzOTlbSIRbO29SlLBb8dbqHoQsll6U0RE6gx76rSKfitLda3E0FxDd0x0JX914VnQLyv2
	wm8GoQ5ACaalycwxphfRJcJuHFgnVda0sR++BVCR+pTrmk7vDlgjQP3JV2Nv0wnFcl0eVR
	0uJMv0VrN9LTWPQJy1aNA/+nfwABTBw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hOKpzv2W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jonathanh@nvidia.com designates 52.101.57.36 as permitted sender) smtp.mailfrom=jonathanh@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hq5OvUIIZ84B4jfQnM9ennDOng/sDoNBn6OxHCeH6oigqFPIVT/Kd6o5svn8sLpCiALOA4be60UYFLo6yRNkiGItxAdyEROx56VDibctBmRGGr8JFkYrmXZ24yo3/4b9IDL31QLzNCF0KsQ8wu2eaYwe+KZQN+mPkLYcs3GyK4KNDvb7wCFpvZd5HJDDXZ3LG7R5L+h0Ls1khOpB2aX3CMUToc3+BWPTsMvs8QBMSYZINQYQchg7dADTYsiD/4tJkdCEvG0xbp28F5SZHpZIGBzRPV0pXULRwdc4ambKl2+DQGskkmeu78P6a1bKunF6f28mIH1GDT7ncKy8qmnsHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XK4lbd7X54jUz5WTkLiXiZOX3L4LuHWxoiN3GHQCfLE=;
 b=rioXUc1S7b8rDSKJF+IAEIl9fz4QUeWOHkbxJSzkEUS5gy9q8+lf5LIdkhH6dax2VemnBXgfV1ZLc0Che2rjmlehUNceMLoL5Q+z+8R8Dd6F6Y8m2RVAcDN5+l23SuuPnBKXes+5VxIJ5zmpPyriue0ojc8f54t69ZGj9WvPi0GR8emQuDYZOV/GjqrPIjpZUmxNm+7I9jeGoXpmqk2hq7tyE9mAbeA6WxIf+7lsPqAZUeV9kw3Gzg92biBQlA5yuAiGHa9fzKFVFAkaJ6HOdSnMcTJzGh5f95L5lC+/QbMfAqGVzol0ANHtLvwIZJXM0krnZX2OIC25OT0O7NnXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XK4lbd7X54jUz5WTkLiXiZOX3L4LuHWxoiN3GHQCfLE=;
 b=hOKpzv2Wxj8wbSa+sLlSnO2wrEl0HKom0G7663AknoEt8RLHqBxeNhUoxSvyS0swclyZ5Ou16aZZO7RXSJM0erxiffgWavTYnT6UO08UgTWTUeFSGXUdo+UQG7pGk6tuWeexotmpnF2oA4a5sHZi/cHsO66JGZdsFys8Z2OR8bOCsyOn6moDTFgSGItPtZuZD37EbZhZkOPfDztMxNtGxZOTq62qMgXYkrubAPG8xxvpwwioYdB4h5M/S9bqkHQ6Am2nQ3rjZ2YRUM/SFk7ywYi9C+fFKRwiZJ+k8psX2MACJiEhcqRa3aA354uXCMf+jCMmmcUqnCdzvCKUBmGNOQ==
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by SA3PR12MB9197.namprd12.prod.outlook.com (2603:10b6:806:39e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Thu, 9 Apr
 2026 20:11:15 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.041; Thu, 9 Apr 2026
 20:11:15 +0000
Message-ID: <282fd123-9eb4-4c21-b28e-949c36ae00f6@nvidia.com>
Date: Thu, 9 Apr 2026 21:11:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora> <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
 <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com> <adZmtJ0rPgj7OQrc@hyeyoo>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <adZmtJ0rPgj7OQrc@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0430.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::21) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|SA3PR12MB9197:EE_
X-MS-Office365-Filtering-Correlation-Id: eedfa610-74f9-452c-7cdc-08de9674270a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cHs5tXO0XUgK+74cltbw5P7twx2Q0lAU8OitE+Z5cwOc+71FPMO/BjhkzU5xCUEEWA0xHN6RG77IWrrieH+dFnuYgIWgOLTzs24Ce7zJfVpKW1cOZc1o0SevzB6ZV8EwZNU+K0FhF+hbE1vLxDx2kKCl6RMvP5yvebpW5CtjhH6p/19y6HrCt7wx5NUjiGh14sy+WHnupo3cVQIJ3PCC8HVg7hyMSY2h+8yQBAZp9BHnclssgbhtBrylE7RH42mMWSG3EBs1/opTHkQ/KoHK7hojK536Kv60qXJ+01N7nH8ZG//bn9oN70FiQT8gifEzg24r9Tj893DnTNpZyEqPZ4HGNq/N/H0gPD+ud1jzrvhnJ1WrOMeqexDEwhlx1BlW56Kgc+9YpneafOnJOvmFJVF/57AGljEmXIIB5RVgXQi/5RfcCt5xB9UejxNKMDD6LsCgDfjUVsBetKwsNX3gjWkMTkxfrwfzxvEPzUJCs4ebf0vxXH7Z2Ar0MgTz8mk0QrN2ZEKCdY4SOh2yWnLtOfOKhXSn3Wf2YJgqwjhfka9/4zgcAePTLQFqTtSPx/OT0cn2OiuzYEPxENCDmrgO6ZaBuZZ/xezmlFmFLmn5JPhkc1uDNu9c/aoaU0FLjdre1k677JNLAvu9KM1asgKx66m5kPUQEFOwu4/Dr0QxACJ+4LRS13eJZ/LPMfcnD02Ozeul1g73M68WHsCOtIqkWGx33qaJEMUvPfq2R2FHRmmCo5hvNnvLXKdo5+9P4IVW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0d1ZDVqWVZzTjFhQUk4YzYreTlZR2w2enlkbTBCMUxQNDFXVHVqS1RtMnZG?=
 =?utf-8?B?bldzRHl4dWpMZnltS2ZwM3daVWxYSEU1WVg2TDFybWlqeG9ETVRJbWhBWlpG?=
 =?utf-8?B?Nk9HNUllbVhadG9UT2ZQTmtmaGVjUjRjd0ZVQ1RiZzQyNlVzenBuTU5QZW9w?=
 =?utf-8?B?TjBYZUljQmJlYmp1WlVrMWswMUh3TGl2NEhvU1dWU0xMV0ZQK3lWZUtaNEd4?=
 =?utf-8?B?RWZOMUhmVjc1dmQrWGJyZjU5d28wQWpMcWMxVVQ0OTI5NzA2UFM1dUFnNklu?=
 =?utf-8?B?K1g5NmhEaG9oS3g3OHNScHlJRUVvRmtxSnJnVjFsd0FaNjFhRXJFQlpDMjBB?=
 =?utf-8?B?eXhQNDNQNFRTcXJDSkFVZFNWMkN1OVZmQWJER3J5RjMxRUpzOTlsTkNud2lm?=
 =?utf-8?B?LzluQXhhR0FZNEgxcmkybFlQd3Fob2drVXpTR1BYTG1acFg2dnpuVDVPdzNi?=
 =?utf-8?B?eHpQRm5mbUtFVit4dFFzNlMreExIRjg2L2JrcDdSc25PeDg0RS96NkVZOVZv?=
 =?utf-8?B?amM0enQ0Q0JuR0dOeW04YmM3a1IzYkFLdVpRbm1rejZDN2R5djJ6Zlo2NTNx?=
 =?utf-8?B?SmxpM0VJWitUK1Z0ck1jZERZMmd3K1F4TnRJVk1GeG52NHBNUE1QOG9zQnps?=
 =?utf-8?B?WEh6bXBnZTFSSk1Pak02M3B6MGhWejBRenRHb3ZWVjdFY3JWbTA1c2pXczR1?=
 =?utf-8?B?Z0tWVHBWSzYzcFkwSFFaNkY0TDV3a1YwVmMxS2k1Mk5LR3FkbCtiTUpHYkVE?=
 =?utf-8?B?VS9xQldzZnJCYUJ4c2swUm9meEE3N1lJYmhndE9Wemd0UGZCemRuRmVhZStj?=
 =?utf-8?B?QUNTUUFydlVuSm5lU1I5NE1vYmw0QUdXdU43b3VIelVORUhEeGRmZy9QRTFQ?=
 =?utf-8?B?dTU2T0hFMjlUT1k5ci9vSkZxcnBnc1h6RXdvUnAwYzlvbFMwNk1PU3IxMkVM?=
 =?utf-8?B?bUtScFJnRloyQzllWVJSUXNYUTF2cmZEUy8zYmtTaW9sMzlObjVKNDhicHlq?=
 =?utf-8?B?L2V5RDNoY0lYalRhMXZlN0ZmMmpvcWd0bnVTblhDNlVuN3QraUhpYlpaNmQ3?=
 =?utf-8?B?cHpaS0FWRFhTWUVzU1BGTGs3L3pXZVNwRWQ5NDFwTDNWaDVjcWtNVVh2OFky?=
 =?utf-8?B?bWV3dFlCZ1JBanNrUm5LazhuYU5qU3hoNVVtNjYvbmJWM09JL1hpaC90RlRX?=
 =?utf-8?B?dXR3VllUS2YydGNDUVI1UStvRTNtdXBJTGl4UjdTaU5vem85ZjhoZlVBc2NR?=
 =?utf-8?B?QjBnVUJWaUxRSHhHU1BRUXpMNHNRUU00NDZNbUFrUVJoaUxaMlpzaHRZK241?=
 =?utf-8?B?ekhNcHhsWkw2OHVJM3RtNDczSHZtdUc3M2R5OWVKY1VNd01YRkNaMzZNQ0JC?=
 =?utf-8?B?Rm5WcUJJNFVqNVN6ODRUSDlGYmpOMjBrczA5NnJKZWl2eXcyM0pVaStua01Z?=
 =?utf-8?B?UkN5cHRsRjBMME9XWHdGVkRxNjd4dm1TV1VLV1hpZ2dERlpYbDdwSm05dC8z?=
 =?utf-8?B?bHBsdk9JRmN6ZG5WVDM0SVQ0aVVoeUt5SG5NNDV2alBCalkvckM3TWlOUWxW?=
 =?utf-8?B?enpsY2Q0SGc2N1hxTFZDeHlGbXZKZ253UkdtaG5RMUtQWjJEcU9IQ2V2b1pL?=
 =?utf-8?B?Q0ZxOFM4T01UQXJhclF1OTZmUC8xVFp3N2FaQ201UjVmWC92VGxCMXExcVpH?=
 =?utf-8?B?OFlPNHY4UUUwT3p5NnFoRkdtN2ZBSHhPYVR5RFJMTHVKVm1jdnJHRDhkQlha?=
 =?utf-8?B?VFFHUS9UVEhxUVFLT1dnbTZJNlcyR2loSTVRWG8vR3duYXFxTW1CUkNCbWRJ?=
 =?utf-8?B?Z0xndi9PNnpubUFEYXZuOVRBNGZEK2NmNytLbVJVcUJtb0JBODZVV0xrbVVh?=
 =?utf-8?B?bVhnYzJmNEtDbzZZMXBzM2JaVU5jMXVTaHJHS3N3VW1EcGRkc3dTYm9RQmNx?=
 =?utf-8?B?cGJLWjFHeHQ3V0lLOFBNV2ZmM3pGR25La2U1aUYyS3lmTS9KOEswZEN5UVlJ?=
 =?utf-8?B?aG1aN2JEUGwyQXlQV2V4cWI1Y2V6eTYrcEJZTkpLU2NiSGh0Z0FyQjV6WWxo?=
 =?utf-8?B?aTM1ZjJxRXBncWpFWmVQZy9ybVhwZ1ovN0hWRTJyeVBDZnhRMnZDQ2h2Nm0r?=
 =?utf-8?B?Y2NaUWljUjBLeDlMamZ2M25Dd2ZjZzRZaDlrajhEaUV4U3h1RnJVdEhWTmN2?=
 =?utf-8?B?eW5UamhTdU1JcndOMUltRGNqMEdONFZwTzZzSnJFTXpQeWZ4YUw5aEFQR3Ix?=
 =?utf-8?B?R1RzcU92N05TYWlGMWJGTzVhZ3A1SEpLcVRDWFZqMk5NZm9kSWxFcEFEbEp3?=
 =?utf-8?B?OG9XcHR2ZGF2RktncHE1andQQ1Z1RVB2elBob2JCdVQzTi9GckdpNWhObzg3?=
 =?utf-8?Q?MvCtfcZ0TmIKJLCWW9qnSpDAnlgnqG0KWg3MwhrBQwy8h?=
X-MS-Exchange-AntiSpam-MessageData-1: 14H+OcNkXGcOjg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eedfa610-74f9-452c-7cdc-08de9674270a
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 20:11:15.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkfXN3JoDCJk3ndNroMCmPXccAIDtMqBwROAGFVDUWcKFzkYYx046BnzsLbCGkV2EoA/kp3SZRt16r4aGncuRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9197
X-Rspamd-Server: rspam12
X-Stat-Signature: ey6ufm5phzhfmsm3ehndc36ynoa7iss5
X-Rspamd-Queue-Id: 5EAE6C000D
X-Rspam-User: 
X-HE-Tag: 1775765479-643222
X-HE-Meta: U2FsdGVkX192pqhZn0HA/xgQZUCPEUOQvOKz+FC5WpGnJ48RpG4N4q5UxxsHkiV0oLQS89x6OLazb5zeQlae07SV2PF1tlhTwZ36a5IJP4xbpbCbL5nN4t/SB+KIUDPXhams6OpDmC1CVWaGDsBPMhzuhkyk9ynAijrOyPmuhDcc2TGFBuGwklMMaglkAePajqKHEgdDmZysyyzM09jkVyaRHmJvJNdQpDjOhnPakdV6KrIKwHFON41riqTWw/LCLYhnXE55JopkB7m/g2kbkp+sHS+M3VerhQjMfIJTOV0QZI59x0UCgjgLRaw9vP7T4zXnck1v06kCWolf28wIQU8n2eky4f7elfp9yQhSf4531eUAaETNekrxH4axNrPcIuEnyVXvulepKoKv7ThmT9HPtyJ6L/7McTBifBbL7dCfRdP+kWje4fM3OR0LxUypw6ZA5C+gF/yTbBkOu8G7HyzZPIGvqPZr4EMOXkPt+hFIFh8uo3G6TkILNMH3J/q5xUNVU/3Q1bx58eKAljQCe0iyIfS6vZ4Ix5fzKdifeqVmjbAXdRRX1WyCMfHDhkUJVTvduBzerxDJGBrsKfo+v/O8B9pY3vzGMUP1E7QnS7dZ4GV3J4kmcdVC6wYKnr0HN9jq/1tsgcZz85gL5lX2BRICfc2C1GgJHBEaKYDxRothKFLolIixJw1TGRcxImCxtkxD9VHg6OvKIvf2P1yXtPzd4RgwrBW1evwPcTIgCcuYuvQNiifsaSZxHwBhxsPBqVod8kjfHvlT3tGmn4Zv84cVQYpSRpd/QBU07cR1LV8CeVjIwjzeepUt5I6+HXtU3TncjQZgbbPX1Lkmo/XeKBk51r3fH5gkCRl8KeU7T3oMfw155fwkQQcAD8aTQzB5VmC+9xobuvqD4O02kRm2vOw1vDNNgH/fV2nyAEkh3tCfPapAhglUgg/3ynuuFGxoX0+TK+TDrCHORQsnfX5
 guEwS9eJ
 3/nCI3Zjja/AP5DUlXtSzUuuES5zuR4NAv9ZZfTiaMcdDd2PNjw3pRsrrURMv9V3RYHaTWdCuW752I9Cncz1CFULnLx1TSsD+Oqb23l9YSLkPGnS7oGtQbrfd9wrO7rKWPuZq/Ly0Tms9CB+MMVjXcg8PD0bwCLemX8fAqbsYOb3YVPfjb0f3v5WMi+sViDush1Jz3M7ynPxZynewWWrnud2FdbTRNyBnW6xT7gpBB9ZGYbBI5CgWFZEFChKK9Fmykq5em0R3MOxQpL3HJ5Ut7s+qzlP0KwrTR+669YkfhJOjh76GEpnPk5PbmNXjSqH1bBgaEuB5Q9/EOmGKOfL6lciVJaeuax86vlbmWHED8qOnPylnGpTIGRwjWchq6PqrhXVHKssO39X9BZaOmNem9Ur1FS2h2anHllD+MOvEw9ccUelQbaJRs6Ssfit/dxIZpPm9dQc2CgP/VoSrhUdBXQKYy80whVrkjPXUY6WWkMviXIpsGP4DT+EIcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08/04/2026 15:31, Harry Yoo (Oracle) wrote:
> On Wed, Apr 08, 2026 at 02:04:54PM +0100, Jon Hunter wrote:
>> Hi Vlastimil,
> 
> Hi Jon,
> 
>> On 11/03/2026 17:22, Vlastimil Babka (SUSE) wrote:
>>> On 3/11/26 10:49, Ming Lei wrote:
>>>> On Wed, Mar 11, 2026 at 09:25:54AM +0100, Vlastimil Babka (SUSE) wrote:
>>>>> This is the draft patch from [1] turned into a proper series with
>>>>> incremental changes. It's based on v7.0-rc3. It's too intrusive for a
>>>>> 7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
>>>>> hope it's acceptable given it's a non-standard configuration, 7.0 is not
>>>>> a LTS, and it's a perf regression, not functionality.
>>>>>
>>>>> Ming can you please retest this on top of v7.0-rc3, which already has
>>>>> fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
>>>>> allowed"). Separate data point for v7.0-rc3 could be also useful.
>>>>>
>>>>> [1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/
>>>>>
>>>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>>> ---
>>>>> Vlastimil Babka (SUSE) (3):
>>>>>         slab: decouple pointer to barn from kmem_cache_node
>>>>>         slab: create barns for online memoryless nodes
>>>>>         slab: free remote objects to sheaves on memoryless nodes
>>>>
>>>> Hi Vlastimil and Guys,
>>>>
>>>> I re-run the test case used in https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
>>>>
>>>> - v6.19-rc5: 34M
>>>>
>>>> - 815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next: 13M
>>>>
>>>> - v7.0-rc3: 13M
>>>
>>> Thanks, that's in line with your previous testing of "mm/slab: allow sheaf
>>> refill if blocking is not allowed" making no difference here. At least we
>>> just learned it helps other benchmarks :)
>>>
>>>> - v7.0-rc3 + the three patches: 24M
>>>
>>> OK. So now it might be really the total per-cpu caching capacity difference.
>>
>> I have also observed a performance regresssion for Linux v7.0-rc for some
>> graphics related tests we run. I bisected to ...
>>
>> # first bad commit: [e47c897a29491ade20b27612fdd3107c39a07357] slab: add
>> sheaves to most caches
>>
>> I came across Ming's report and hence, found this series. I have also tested
>> the 3 patches in this series and it did appear to help with one test, but
>> overall I am still seeing a ~25% performance regression (the tests are
>> taking about 25% longer to run). I am not the owner or author of these
>> specific tests and I have not dived into see exactly what is taking longer,
>> but I just know they are taking longer to run.
>>
>> Anyway, I have not seen any recent updates on this, and so I am not sure if
>> there are any other updates or what the current status of this is?
> 
> As far as I remember we didn't get to fully recovering the performance
> yet. Interestingly even when most of allocations go through the fastpath
> it didn't fully recover [1].
> 
> [1] https://lore.kernel.org/all/abI9DKxuwl_4Gasj@hyeyoo
> 
> I was suspecting it's probably because of:
>    - false sharing on something (sheaves, obj metadata, etc.), or
>    - suboptimal NUMA placement, or
>    - something outside slab involved
> 
> But I don't have enough data to back up any of these theories yet.
> 
>> If there are any more patches available I will be happy to test.
> 
> Thanks!
> 
> Before diving deeper, could you please share the NUMA topology from
> `numactl -H` on your machine?
> 
> It's probably a NUMA machine? (and hopefully not memoryless ones!)


This is not a NUMA machine, this is a Tegra234 Jetson AGX Orin board [0] ...

$ numactl -H
available: 1 nodes (0)
node 0 cpus: 0 1 2 3 4 5 6 7
node 0 size: 30517 MB
node 0 free: 29263 MB
node distances:
node   0
   0:  10

Jon

[0] 
https://www.nvidia.com/en-gb/autonomous-machines/embedded-systems/jetson-orin/

-- 
nvpublic


