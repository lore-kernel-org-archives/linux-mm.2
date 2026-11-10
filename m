Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED475606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=injd+8VG
Received: by kanga.kvack.org (Postfix)
	id 0CC9A6B05BD; Mon,  9 Nov 2026 22:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D846B05BE; Mon,  9 Nov 2026 22:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86BE6B05BF; Mon,  9 Nov 2026 22:54:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B363B6B05BD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:54:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F1BEA8432
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:54:51 +0000 (UTC)
X-FDA: 85417843182.09.D32E076
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D22680004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:54:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=injd+8VG;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794282888;
	b=vocPQkUeCfPJ5FqCCiP0pp+cCY3Q28jfcTrJeKwItqV27t52fnDkQRTQpxEuozo3HY9VCN
	/6o/7cesOGQWf5IDLJBISL8uy9sgQo0OSczb59caQkD/E8t6JtFilH5d1HgcIadXQc8C+T
	278udAustjUySrPfaQaAPqX1AQiwEh4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=injd+8VG;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Z9s25FNRdbI6zI2tVH5EAf6aZyC1sgcomoLPNQb5Aw=;
	b=BFoagw9XgC8EliOFyzoFwc7btoROqxnT4WeTVhS7DK9cBKZKF4eLRkQR6T+NXrEvo9dknO
	GH6WqJAOJNM6siaRz+zZJdzT6X3VdEtoUmuGFuYw5jTmV7Fr/oSNepF3d9gPgK4PbA/pKw
	W2Z5OhHE6/rSnAQWoBRhxtRHFkyIOTI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhKesV9b3177PUVSmJMvkN75vvwT2DMrrU2REdBcx2q1HhwF1Qga8xkKEyccCYOyF22u7zhdMyaFoO0d4iHY2qSU8DKhZjkGhRvQRFmMhWLsG2BGvj3HZHH2O3OLukHI4//vs5QuLg/cpTnKTyirCZ2JcS+zPQjuL/hDDfNYA2/OpBCT2janYWb14PIJmr8pg8YzYujcGBJU/WBFu8Wm0uvg5d8eO3hfd7JFr/iog/FwvBrRuPVod+O6IpC3e0FcTrZLG/nYYJ3KnFv2u+8NjIgV4FRwyiLYQ9k1U/fHPZcAfb71fU5gPGM4ydSmf2z/CQZ08gHwApmEWowFnoPz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Z9s25FNRdbI6zI2tVH5EAf6aZyC1sgcomoLPNQb5Aw=;
 b=S7b4QUE08DKnpyXfsG7VvUK2UwkoYm0s0nLdOCJ9I4eLfjjadM540IyOAWAsg4E10m83uhgJp2oAkPWky8AvQzEVHEnQfpO40supOzFIm32LOoP6wZKy2Qm+1aep0LXdQEtq/kGq1A1MKlHPAiI8d2XMqGracVBYutmUTSJGd9hWPUlxLdVaZU3WWRLHuaDAs0MbhkSQ9c6RqrEattUmMBlzaDDtwJjOZYJvdpvzrtxORCifti19OC2kLzAtOsqxRCJsYxt05NLpEYUEpVMxGF8K8bupcD/z3sE0exDSMDopdNCWO0bZYzx33dsPTFk3hk6LJhrQS4pCn3xr2KmnSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Z9s25FNRdbI6zI2tVH5EAf6aZyC1sgcomoLPNQb5Aw=;
 b=injd+8VGe4AHkkYGwMap6JEkdrnYjGEDUmdbtyNlq9FOvSgWO+33S1mnfntzlXj5srZf+1vYogOobpRZ2CxFvby5Hw9GRDNC6u5J+ZCa689sOIvPHV1Ktucx3jg7ileLtaioX5IleIZA3Ldmk139RIsyN6PSGpehxi7QRJfsjO2ErNUqIEG6LgE7HWcTYM3dE91zYzbHJWMT8PB29U1Eo0duKEEVSDzO1tYSkxtpb8NogdtxBWL8YntiQI8qHn2stgNbXsb6/vDarRveUhbHW+ADxGJRJHmSqNu676f9D2G5e+7pjYLici1vZqDbq+fxNLZf1GoGPCsIHLEHymJo4w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB7116.namprd12.prod.outlook.com (2603:10b6:510:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 03:54:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 03:54:43 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 22:54:41 -0500
Message-Id: <DMR874E7OJFG.160T3TW5FF6PL@nvidia.com>
Cc: <baohua@kernel.org>, <usama.arif@linux.dev>, <hannes@cmpxchg.org>,
 <kas@kernel.org>, <alex@ghiti.fr>, <baolin.wang@linux.alibaba.com>,
 <liam@infradead.org>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <lance.yang@linux.dev>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <willy@infradead.org>, <linux-mm@kvack.org>
To: "Joanne Koong" <joannelkoong@gmail.com>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 1/4] mm/huge_memory: scale thp_underused() to the
 folio size
X-Mailer: aerc 0.22.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-2-joannelkoong@gmail.com>
In-Reply-To: <20261103212004.1356327-2-joannelkoong@gmail.com>
X-ClientProxiedBy: YQBPR0101CA0314.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f265d93-3b52-4adb-f0a9-08df3ede5a6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|261028144727099003|11063799006|4143699003|261021123027099003|261021121427099003|261026140227099003|261009223027099003|56012099006|261026121527099003|261022105027099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ku/a80i+bEJ38K6UfhOyvtb1gIORGoy5unhlIG5ieScYPGSHt7M+d2Dz3RH02coXj7ka3SoNUfw2rn9SH+MnZLW6tn8TCE8fnW+4FlAJpbtcYMKyaiyl92Iu6my39Mh19rVVUzvJq9fEBHFXFXoy9F6JFHDplVnSmLYoIviW9bHyc5wrTByjzMQLCyRL6yPFIG66lIWvv8kcSUZkzAbdy2MP7wRvo1soutInYBKuJm3870OVEvoaBMUcI7HO8gxVWbrJ1syDV64XvwnTKH4PHB2orPICuL0Ni6/bR6cw1fzootbKEEVAJe0qrHbCTOU7jcldxV9eB4ovmA0xhqob8pGEOXuI/Y7e63bVVjr/mJMwHLGXKH3s9nusbM00mnp+opJYNaXu0FhhM2zKMN3UKWdaSv0vvAfUzr5ZgQRNKf6HnRLNr7pqYSLnQd+RDiv0ttg7TWEdooQmPmxj8w5qByr5oIynQkTLIJK9OdTtykTITcwrQCmBrWgppMMnoB4dQsKDt9+z69eWVNVUOanns1PCIzPOZFt/vBBg0I8t4NiMqZ4Xf8uA8v/9mZkpWc5fy6ORImcVugxf5y0XS1/DYBpivF+5lX5aNskp/cJ7Vgtr09Ntd26pYsFiASythVUJkt9i852fWrcatEVmksnV99gGMZqiQq8butruAjDTZUw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(261028144727099003)(11063799006)(4143699003)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003)(56012099006)(261026121527099003)(261022105027099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHJrUnhtbVJJdFVRQmp2bWc3Z2k5ZE9WeWJCZExsV0wxbDJCYldzRWhNRHB3?=
 =?utf-8?B?SVRSa2JsL0c1MHVYM2t1ejRmZmZGRGowMFV6KzZZbGY1LzNZMUhwM1IxSDRy?=
 =?utf-8?B?c3VPUUVQWTFrQ2FYbHdNd2crV3ZidnVCWjhSc2NZVFBhVUpLWnlpc3JSNy9S?=
 =?utf-8?B?K1o1YzF6ZXhXNnNPRUg2cjFWZHdzSFZZcVBSU2RScEp3V1Q5L0d4RnMxZlZP?=
 =?utf-8?B?emRjSG9Rd2pGYUowZ1hmRGZtbzUyNzlxNUhyR0Q0UnY1L29CNjdObTVVeGZj?=
 =?utf-8?B?RWdWRWlCUlJkYWwrVE9Cb3hqZkpXdDE3ZUlHVWRWR2Npamgwdi90WkdUOXE4?=
 =?utf-8?B?ZENXWlp5TTNHS2pYNm5Kb2xyU1JZQzBiSkRYSHRtNVU3QXFCOU5FVDRoYzNF?=
 =?utf-8?B?aHN2bWFqd2d1RjVKWUVkTEhwVTMyQWJuM2RFNkcycEVpNlNQdlpReEt2UTBK?=
 =?utf-8?B?YU9XcnVoRVJZNXhObFp0UkRLYUlEOHF4YlFNNmdlcjlHRHRjdGIrMjgrMFpk?=
 =?utf-8?B?S21nQzBvMlVVTTM0Y0ZDVmV6amhpcEFJRVI3eUlZNktBb2hXNlozN2lIMkk4?=
 =?utf-8?B?clpRTWs1Y054Z1JGZmVGNHJDZjZ6ZXJWdSs0aTNpazUydmtQdWpMZmI3MU9I?=
 =?utf-8?B?WUxla0crY1dZd2hUSlRqTytzQUdNTFFHY2JocnVYalVWRUo4S0RCNEYxSlRI?=
 =?utf-8?B?WW90S3BjTXIwVlJiVGtLdnlheVVhQkFlUU4zOCtKNFN3TURDYkIrSnBrZ3BV?=
 =?utf-8?B?N3hKb2x5Vmc0cGNQREhldG5iYkZHd0NjSlgzekVZZ3NWZjJqWnRHU3hXaUpC?=
 =?utf-8?B?TElPSVpReEYzd29aeGZidHErb3I3THI5TjBaeDVOanVOMVk0Ung0YTcxL0JN?=
 =?utf-8?B?dUdHS0lPL1ZUa01LcG9EMWl6S3hadk1YSkVwMnNITWV1dW5sdnJ2dEJzdVhU?=
 =?utf-8?B?MFliRTVFY3pwbjF1aGF1bTdhcHVQSlN0S3A0SDN6Ylh3bDVIS2J6VzdGU3Aw?=
 =?utf-8?B?UDZ1cUZXbTZTcXBoQlJreklPa2J1R3BNczF2anMrbW9EU3lVV0FmT3hZWDJ4?=
 =?utf-8?B?cXZGS2tFNUVUN0F2UEU1OVZNekt1V1Y5ZmxQemo5UmoxNFI0UXdpOVBGaUtk?=
 =?utf-8?B?dldybm5mT2p2emYwRTZJRzVBcC8rbDFoMmhkOGFVWktMZ3ZQeFdEdm94L1A3?=
 =?utf-8?B?eXlCVldxeVRmK3dnRkZjZXNsd05SUlhPRjRYWEd4c3JpSEZmSFdlYXN5R1pD?=
 =?utf-8?B?cnc1RHREZFI5SDk3cmJDUDN6S0RyTmJ1TE1BV2dUR2FoRlE5aDBHNmQ1eld3?=
 =?utf-8?B?T28yWTRZcWtYaHY3MmhtL3FYQkxjWGl1M2VHbHhxaHhtdTY2b01ucTZ1Y01W?=
 =?utf-8?B?OWFXdlZmcW41VjhmMDBKaFdtTE02TVY4YmpUS2trc1JUd21EMTdsT29mL3VY?=
 =?utf-8?B?TGlnZ2RJNjFIZWExeC9vU0N2Ny9jcm5RWUhUR29BRlVMb1ZMZXhTcTJpdlp4?=
 =?utf-8?B?ZFJTd0hRZEIvRDJWZ3pkbmFwNk1KVUR3TUcvTk04RjRMNkt4OU04c0dKSG5w?=
 =?utf-8?B?TWFZeFFUZzVGUlkxN0VWbk1pei9vU2NIbXFuc2k5dm5KbkV4aVlBZmZvbUVm?=
 =?utf-8?B?dVp6NG1mN1lqNy9HYkErMXUrSUp2U0FGalJkRjhhc2tlYWEwK0ZCbUpsVE9D?=
 =?utf-8?B?dUZua1RKcm00Yklyemw3SFlvWHg5ZnMxeGZkd0VjdHhyWXY3cTdFSmFWeDZJ?=
 =?utf-8?B?WjdMTEVzWGRzQXB3ZVk0Q1pHYzU5a1BZdm5aQ0o4Q2w5NVh4bWlWQUxsdCs3?=
 =?utf-8?B?TTFkdlpUbkl4M0xpTW1HYU5sS1ZLQ2p0R3lVN3pwNlRONDlEakFVQ0hJRHFW?=
 =?utf-8?B?QzNkTnF0TTluY3VrMCtRS2srWEFBQzhJOGc4UGM1QjFpNEN1Syt1Wm5xY3lz?=
 =?utf-8?B?clRUQmFkM2NrdUk2bWhjR2hPQkU2NERYcTZCK29Sa1FDS010WnpKYkk4dFo0?=
 =?utf-8?B?RG50clBqZFNyTHhzdU4rZnFQUmVYemxyV0Z0Rnk1Nmh6RjRVakJuUE9QWjg3?=
 =?utf-8?B?QitWMXlxeGNPNjZkTTdjTENiWjF4aURrei9mZ3dEdkdrYnJiaXJpenJtZ3Ey?=
 =?utf-8?B?NXdyUDlISVUwT2YzWC9VMld3UWNJSUpMS1dsYVRRZ2tMeDdmcW4rTWFsQjU2?=
 =?utf-8?B?QllDSURjVXNLZmxXV0lYTkQvbU8rWmVXN1UzY3RkSjFpRk5HTW9GbmlCZnQ4?=
 =?utf-8?B?aFNwNlRRK1dhVkplWWpmRGtNMnU3ME5saFg2bTVHeHJYWUFsSmgzc1FJUnE4?=
 =?utf-8?Q?nDtCEer40HLqnO7YXR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f265d93-3b52-4adb-f0a9-08df3ede5a6e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 03:54:43.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvJS1EFKlqjXR6nevU0SVhv5JRmpCgxhtnQvHkWgjFiQpdXs5YlDLZGnRo+rMvZw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7116
X-Stat-Signature: ko7ygigwi57jhqh4e4tccj96k5ficmb3
X-Rspamd-Queue-Id: 2D22680004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794282888-660399
X-HE-Meta: U2FsdGVkX181uf/GBu77bRZASRf2y5gjHdXdM5S5d0ElTBmr9zgL3P3m7M7QrbTEXfBiyBPUmszK02IulyIO+h2qaydsq5FoH6yapJRgFOUcPQ095GKwHvkP/QuU0iPuVTpUY35iYncUC/BEx0o3ZoLBGutm1XO+xo2bqxEx4XEax8HHPGH1Qa3PV/EW24nDepoN07eXs6Rh0wGEBHgy9qqNFkaBbzMQ53ia5m9DK8uZPUzRT+v1oM+W883NvIdTMjdGbMdwNyDwRwGzpoowkiBMhhY4NY5NDTlNuWaa2BlN+1rHMvoWdEva94fRGX3X12g4A4893ie5E8v+CWf7AQ6+mRQTf1HRRdEsImywPilfitwSg47lk6VjM4/n+INtavtgFDrqjS4oxhjzpGOgT46YzejPzUMlNBEytuAxxkaUNVvX5OaQz8HFmsNDm1Eagvuvc1g+tUGRzk7Ow1Diuo2M05Hko01j1MnBfwMshss39fZ7gUkm1y+FOj5iAggyOu/fiaZ4p0/e6yuosiRuUKQMjCKgLXV4JLqMsYq9Wj60JV8WftnxhDu4pbL4njcoDpA0Da3gPzbbz0o/dkBakvt97yPF2/j5C7PDLovWJP2K8C6F5QolMT0bVhqNzCtN7aGvUNF7yqci2b9G/3rZVtMqzQcofoWfDC9g1tgeH6zbiBOlNXKBHRE3Is/spnTkFHu/eMyNcoo4spyMXfS9z3akLgZRSFHema0cvbGSQrmGnBFIfegVW9wgapbikjJB9GmO0mcPsg7rYWIU1l/3Zyj9xRi3KMAp5mJa2WGwg1Zx1kznnybiMev6ozdo3B3cX18+6HjZI3ypXuP1iJ56DB6OO10BjL5wbjkZFWNE9aGtpqAD7qIkB3AHu2/LPpiLMTFpMD6lfepP1LA1bTo1G0Skj3bWtWS6vaUInzn4ZJ/TAKPwnxOO6l9f0qKI1BGJETpFUukx30q4OeDNl8g
 noPTMADp
 9YP6MKJ2oKnMWeFhz1ADwCQRjJfKBOELqwZQ0kuHgwBSvI/hrAIN79QNjUrgmkivWE33AR5mvvsBuauF+kCNDNRlvqo5SYP5zr6x6p9ZesdS1yMvDNoFOPlseL1VZSrSgmwHQ8oo9FMU7EouTNY04K7DlUaE44iW79I5TG4OLChRdsVGqJsOPpYHim4i5VdZn33AyTLP+rDExsofQ8E3a8f8NqYwcPoUZEZFSOHngUamQCdfrA/4V6hFjgcCM8qBM+YnOUvSl05qEJ5SsA2DNnscQW65DsmZqGpBmogWC3w1Mc8bFj7qM6XlWrtKPoQqaTO06BB/ixiWRcsFvXYn+VkcCZZJ8Z0H57lhlKRyBhMlNio0KAyfbbG6AIs3KnjLMWzUuAO05xiCb7mMLpMIao/NN8EnSwWth5oSI5NkvcUm3wmy004kiH6r7NJsRh65x9qh44Z+D4yB7plTDHnPQp1nO9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 3, 2026 at 4:20 PM EST, Joanne Koong wrote:
> thp_underused() decides whether a large folio on the deferred split list
> is underused and should be split so that its zero-filled subpages can be
> reclaimed.
>
> Today it only ever runs on PMD-sized folios, so it assumes that the
> folio has HPAGE_PMD_NR pages and compares the zero-filled page count
> directly against khugepaged_max_ptes_none. A later patch will queue
> anonymous mTHP folios onto the deferred split list as well, at which
> point that assumption will no longer hold.
>
> Make thp_underused() folio-size-aware, and scale
> khugepaged_max_ptes_none proportionally to the number of pages in the
> folio (eg every folio tolerates the same fraction of zero-filled pages
> the user configured for a PMD-sized folio).
>
> khugepaged deliberately doesn't scale intermediate values when
> collapsing to mTHP orders (to avoid the memory footprint creeping up
> through repeated collapses), but if/when collapse later gains support
> for intermediate values, a folio that khugepaged collapses won't then be
> split right back by the shrinker (and vice versa) since both collapse
> and split would use the same threshold for a given folio size.
>
> There is no functional change for PMD-sized folios, as for those,
> nr_pages is HPAGE_PMD_NR.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/huge_memory.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 14599d0fff01..3720c12bdb0d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4625,25 +4625,33 @@ static unsigned long deferred_split_count(struct =
shrinker *shrink,
> =20
>  static bool thp_underused(struct folio *folio)
>  {
> -	int num_zero_pages =3D 0, num_filled_pages =3D 0;
> -	int i;
> +	const unsigned long nr_pages =3D folio_nr_pages(folio);
> +	unsigned long num_zero_pages =3D 0, num_filled_pages =3D 0;
> +	unsigned long max_ptes_none =3D khugepaged_max_ptes_none;
> +	unsigned long i;
> =20
> -	if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> +	if (max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>  		return false;
> =20
>  	if (folio_contain_hwpoisoned_page(folio))
>  		return false;
> =20
> -	for (i =3D 0; i < folio_nr_pages(folio); i++) {
> +	/*
> +	 * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD_NR.
> +	 * Scale it to this folio's size.

It is better to document max_ptes_none is different from what khugepaged do=
es,
especially khugepaged_max_ptes_none is mentioned above.

> +	 */
> +	max_ptes_none =3D max_ptes_none * nr_pages / HPAGE_PMD_NR;
> +
> +	for (i =3D 0; i < nr_pages; i++) {
>  		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> -			if (++num_zero_pages > khugepaged_max_ptes_none)
> +			if (++num_zero_pages > max_ptes_none)
>  				return true;
>  		} else {
>  			/*
>  			 * Another path for early exit once the number
>  			 * of non-zero filled pages exceeds threshold.
>  			 */
> -			if (++num_filled_pages >=3D HPAGE_PMD_NR - khugepaged_max_ptes_none)
> +			if (++num_filled_pages >=3D nr_pages - max_ptes_none)
>  				return false;
>  		}
>  	}

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


