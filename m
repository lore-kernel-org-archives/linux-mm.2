Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0444ACD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 04:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BC06B0005; Wed,  6 May 2026 00:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCA86B0088; Wed,  6 May 2026 00:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB026B008A; Wed,  6 May 2026 00:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9F16B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 00:03:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B68381406BF
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:02:59 +0000 (UTC)
X-FDA: 84735649278.08.230F17A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	by imf27.hostedemail.com (Postfix) with ESMTP id C37CF40003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:02:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MVZpt74U;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.39 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778040176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqv+JWaJ2R7EWDx4s4YAz2+u2baCj+yl7VkjaIy1J58=;
	b=E6cJ2GYIyJa88qRQXMibQhYOvIlecq5EPtMozv2j6x7bHxvMgnRD7fuIxn7Gc5dN4lbTd6
	h2cKimVD7ipqOHM/R+uSjXk29JN8Y4XGIOM5gLPG2tRp8GLAzeF0PkErtZ/wbT7pRudLDx
	4nLWqh5f7w+pUlP+JIMcESzZRq93RMg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MVZpt74U;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.39 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778040176; a=rsa-sha256;
	cv=pass;
	b=XnIgNY5jN7VTJWEf0LQFKxJCe92fIDN8Ry16ARm2JmZmhkJrDGmpFyfG1FwBWu2M73QAAQ
	ZhtQIflOJ0q+qfBzYmJXN6LjuCCIyp+uSss4UENWWdWKbNi1KuvNWgzhpfCiYdPK1gYdBo
	ODZONS0LULrT+dsVp6sLiVYkKT2X0a0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGzltNCRkrohcIeqYQMpndokIhUoULs5i6D7YOcV2YYILz4sZduwWzvMi7iRcT5dZ8uWN0JpyEZfkcZxwNt3xIjkBGtNxCob0rumPtStv8gKPRBJbsU1Yb7ln+vvmIGCF8VUxhLNMAgrztfGbvI4UH0QU/cUtIP6KPN7f9Pv8k6aj6oLpZlMmYHosfBtEHjHN4TsdSIH70NeTIBMRBIrkYNZtdafRdEwJxsfoNB7fKwI4EtAgQsGJZy9CbRsfNEoLuo9JcsPrqZzcaU3LwXhF9gwzu98uaRPJ/m8DtqU4f4b59pOqCehEBmMTytDya/v5bEfawta+cdydqkogWgtPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqv+JWaJ2R7EWDx4s4YAz2+u2baCj+yl7VkjaIy1J58=;
 b=i2UxGwCTddJVNLdK8OHNmdGPzkU+SmK/I84QcltDhhq+mZfhRzDZ3P+Ez8OcOZGDIlEAfFQ/DCLg85+rtU/asL+o6qR3drgvdXtjb5Nfm2O0KPEZR4/kPfAY9DWI5CSa8Np8EHQymKZ2GVK86FluWv+0Dws8dEPZyMLUMl6RoCLT0wD/pvAi6oo2rpLUH/09Lh5+tXzcScS6mD6PxQXLTzu4U/+Nz3Jy+/VFWglYc+r5X6QXbU8v2lOePWY8NusXZCWYRAqQUAS4jKmQtmQIca9gQ8dcqNsCQvI2FiTFkGVKE30Puoq911B4Mgauk6Dngn39lEsThB+tiCk7MyzAFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqv+JWaJ2R7EWDx4s4YAz2+u2baCj+yl7VkjaIy1J58=;
 b=MVZpt74UF6CEmydSaF2Fmstbm9WbFmUO/zQUZDeE6up0xIv1zJHVuU2Z9NFz/yLCxG7tlQO/US37vl00V7qP0N1G2IMXEHZystK3WgLSwMp+TAbG1BJl1N5IdxkWRm/AbvEaXWgbq/MG4QN7xx8BkEGkg4mCZXBe8l15nvNNZN22GKqIUel65PNXeM6wzRZc5Z4TZmiQMHuADCT9Gaa4SCXLrLg6atCD/SCfAFfGY18DINSnzpkSrXZAdNHCIxp2KWRl/vZ14SnDA6Zu4sSTS5f81FYn+KP3KwrceUWkyCERhQ4G+GqAvs+3LygvQj3k+Hn6HSS/qR4tz0xQ3QF3xw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH0PR12MB5632.namprd12.prod.outlook.com (2603:10b6:510:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Wed, 6 May
 2026 04:02:46 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 04:02:45 +0000
Message-ID: <ec42f04b-a60c-4a1e-a7c4-cab12f94c5c5@nvidia.com>
Date: Wed, 6 May 2026 14:02:34 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: Bharata B Rao <bharata@amd.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
 mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
 raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
 sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, akpm@linux-foundation.org,
 david@kernel.org, byungchul@sk.com, kinseyho@google.com,
 joshua.hahnjy@gmail.com, yuanchu@google.com, alok.rathore@samsung.com,
 shivankg@amd.com, donettom@linux.ibm.com
References: <20260504060924.344313-1-bharata@amd.com>
 <afkDNR9yVRjire4T@casper.infradead.org>
 <e5246723-b910-418c-bed8-5222d63d90da@nvidia.com>
 <211a37f8-92a4-4e5a-9d55-b61b25f504a7@amd.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <211a37f8-92a4-4e5a-9d55-b61b25f504a7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::32) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH0PR12MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: 57a67137-e68b-43b5-16b9-08deab24547c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|7416014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Fy3MnXBWN50N+27n1pn8Af/SR6W1JOB/4RkFrvPnf/9MhaEk8JPeoReAulYTxQtth3AFnBtc2TcoIcATc8djX5Mj3JeHImxnon5IMKIw0eKwg0ugxRPCAisc876BnkmfCTH4jdK3FPZHcUjDLtGmq3rK27g2URyYmlIBpZOzy59GrCCbkhxmVlFb//pyxpbCmO/wvgQkjKqDq2mJ8X0u7ODv/lqgE5FauysrC+xtmG+m7wbGxjRl59kWow2qRchRwkd/KFoNZo9MPcYu2oMDY5riiZAuXlcoG7dANjN8hWHKgJlYaTxS7IjeqTf353/0Uyze2LuDYFMcuRs+/YxYJ47Nb9LaReE9el/BeuVF3gOEpNRIFzohD+mdbaa03LXKMidjl9RUyMJJYq//uqrHuC+v6LuPo65rC5U5BJhUkAgxFmf8TCF8ULWxDJlW+3egnZh7/O9T7rixAy3iLy8aIVG4chWZ0oozbp3ARc1QSfZFbmtirevt/PHXPr+bUAlAR3g+NuRmpWaCSH5h56C/hgXN2vCtyWdAoP2lJRoiwkLMgH4uTdCKBg9p4Cf1/ptXHclYeG0K2uIFQn2gbNbkQX+9wBhJNCpKgq1EKg/FFPL2rB8Fw7BoqoGuS8mdPomkdKyqUVYcbzVfuopYnUT64lMb6OjMaE7WvvVyBdzdxorkp/kckpwf/A88H7W2bWZLIuWeMLUgkAkB4ExKNRl7xQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(7416014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVMyNUxUUitBcW5WbTFtVGYwVkIzcW1aWkQveGJDVUNHTTZqeG9Qdi9FVWl4?=
 =?utf-8?B?MHdwRlhjbVcxQXN0dFlOWDdGVzJhbE1qbE4vR05PMVZ0blExSmxwUThHMHRh?=
 =?utf-8?B?ck1HZU96SzlBSXJDWU9IUm9COWpCTkRIdnJlK2RyVmhVOWQ2WEJOS29sRE4v?=
 =?utf-8?B?VlZVWDZ4WjZ4YlZnbUdobmhXTEt5ZjRhNThmcjIyUXZzTytRTUNOUVlyVTZM?=
 =?utf-8?B?VnFsb3dURDBqNHVBNEt4UkdLeXFrVnZIZkJDUFdBU1NUR3NlOVRudEgzQUpz?=
 =?utf-8?B?cnVmS1FabFZuQlArNENGczhVTmNtV3EyenR3SVVEWERXT1F3YWoyVjJiTXdu?=
 =?utf-8?B?WUFFdVZWanNJeWZWdXF5MGtDQlZGc0pPdW43Q1FYWnEycTE1cEk1M1BMRlp5?=
 =?utf-8?B?VUdtazIrT05JT2lNeE9aV3JuNUUvZTRQTW5wSjZ4Q0xaK2ZFbFhZQVNBOGYy?=
 =?utf-8?B?eFpwekxXOFdNekw3K3pPYWZQSzR3d28rK1dDeld1aUpCWGFyUUFFVnBMSk5V?=
 =?utf-8?B?RCtFb1kyTmkrU3I5azJtNWo0WW5RVFg2cmRISm9Zbnp0KzZ2cU1uNzhEZ2ts?=
 =?utf-8?B?Q3oyV2JodTcveEo2QUNYK1Nqb0IzTHgzYTNxVnlIeTI3ODAwcHFqUVVZTXU5?=
 =?utf-8?B?bTdJWjZNTXBEWDBBY3owVWx1Y0xLU08xYkRrWnZiaHlqRXZEcDVMaDZlRi9I?=
 =?utf-8?B?NnFKU0tGbFkyVmtuWWk1bjNySVJ3c1JTc3FlWWtid1Z5NkdFb0ZlTmI3Snhy?=
 =?utf-8?B?VmJxcDZyOVEwbEphQ2h4UVRvUHFNZ1VTQ1h6ejJTK1hHb200ZDh6TEY0YW1P?=
 =?utf-8?B?MjFuWjE1ZnBZOGVZNXk5akVVM1AyRHBUUlNlNkhEcWJuZFdpclZRSWc4ZU14?=
 =?utf-8?B?NHdHaldWTDZDRFZEUE5ON0pDRnVvS3gwd2NEYy9aOTVOT2ZZd3ppSEJ3L0ZK?=
 =?utf-8?B?S3VjZjVFNS9UOHIzOWxkUWxNUk94TitmK3l4ZElDVTZvLzhycC9VUVFWM3BU?=
 =?utf-8?B?dmRQTUp3cVBBK0x4b0dnYnI2RFBCaUlSRWJwKzJaaXFwWGVmbmNDakIyVkRp?=
 =?utf-8?B?V0x1bWxpc1dVekxDSjMxUUxGYzArdUhDSVJLcnFHN0dMYmpyUUJWNDNFcUxy?=
 =?utf-8?B?aFBVMHYrZVN5Q1ZKSjQrOUF0QVZRSGUwNE8zSW9Yekh0c0YyRmtoNS9EeFpJ?=
 =?utf-8?B?MjFMcmNpT2luRE5oM1plRndkUE9tN1c0dlJlNWlhMkpwN1R3RlBoUitHYjl2?=
 =?utf-8?B?L3hXbmxXcUxoL0ljeTlBdHBibFZUaVlHQ0hkZitHNlNRZUx2YVRNU01oNExS?=
 =?utf-8?B?eDFKcm1ibnh1OGtjUlVFdHN3R2VWSk5FTk9IZ2QzanRQNER0UmkrVE84VXdp?=
 =?utf-8?B?ekZ3b0dLWWtqampoMGQ0L1EzSG54c0NxTDBkSFEzWFZQUWpjSjlkd0FLZXRI?=
 =?utf-8?B?emNWYWJMYnFNUklvNU9LNFNPTnVWc3p4TVZmUk81aEtENU9OZXd1ZFU5MnVn?=
 =?utf-8?B?NDBFYzFudGNtNVMvdTZ6Z3hLSHFpZFlVRVExQ2dmSW5GYldsU2hVMnB1bTJP?=
 =?utf-8?B?d0k2MlNEbGpoY1E4WWE3NTFZcUZhYlRZME9FdStmV0dubS9uMkd4SmE4QmVj?=
 =?utf-8?B?YmZLN21URGF4RW1DcmRCc1BpcS95c1FCcWJ3RUlrZkxpTmROS3djS3Zqc1dQ?=
 =?utf-8?B?UEJVdGdrVVI2aDg1L20vcjc0K2RwRWVWbE9iSTQ5RE02SjVSTlFIb1VjNFF0?=
 =?utf-8?B?Wmg2eEdUMk9pTkhyQkxhZDBxM3VVcGZjUDhZMDQwVHpGRDhEMWR5ZHkzd2xk?=
 =?utf-8?B?MkREYjZuZVZENFB4aDFic1B5c1NkZS9DMVhISGlWVXJTdDFHUVJCL0pHRGlJ?=
 =?utf-8?B?QWpYWXdKQW9xditYWTc0SWgyR3pta3BPKzhteXhuZXp0QlI2TFlsaW9XR1Nj?=
 =?utf-8?B?dXR6WnJqa04rTzJMYlptb3VXZWF2dzN3OSt1T1pKMXp1U2VZVVBoTEoxMFZq?=
 =?utf-8?B?U0hnYmo3MGxaUm5LQlM3M1ExT2RVbHJCM240dlRvZ2tKTlRHelBhbWloTlE0?=
 =?utf-8?B?MnpVWmk0b1ZRSnd3MmFvRVkyd0hHelljQlJLUmRwOU1oNWt0SjBJbkV6VXlT?=
 =?utf-8?B?Y1ZURytRWEpoYjV2a3NRaVQwUnNjT0FUSUloNmpDM09RVVlOSVFoUGQ4VVdG?=
 =?utf-8?B?RVAxcFd3Zy9NekRjamdhcU42bXFHL2dSR0RSWUs0Q3Vxa2tTRk9JbEI3TTc3?=
 =?utf-8?B?a28xT1l2UElZbXI3Qno0RU00N3d3RUYzdWpxWHRwMUMxaVZoSTAvQVpzSjlS?=
 =?utf-8?B?enZVOWU0ZFc2d2pnOWllUE1nU1VMZjRuem9sbHQrSnFESjlCMTFSalBZN3hp?=
 =?utf-8?Q?pwSxl1LnWlqvLl6JE12JvWAqT6IyNg0OWuIBgAFsBf9RV?=
X-MS-Exchange-AntiSpam-MessageData-1: b0/mh6WjrajE8A==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a67137-e68b-43b5-16b9-08deab24547c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 04:02:45.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcgdRoyVqatAahsjVmq4R2kMbJvyi5Xxm80DN2h0D010zVupIyhVLtqzO6LjkkqmuyXPhLtjS83E/1jISzXlAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5632
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C37CF40003
X-Rspam-User: 
X-Stat-Signature: j8k6ipsxf9zyhssdqufjs6bk4yuxk6z5
X-HE-Tag: 1778040176-473224
X-HE-Meta: U2FsdGVkX18OJ618yCbUR8wouZCNxxO8CzOlGlTHz8rRROfB6y54amu/8KPGJV0S2Wr5xvHlE1J69pcv3+PIhFoHyjdotbVYv2Tn0tDnwLBFTPq6V5CboBp2m0UwYltY6sTGUE+Do336PSBCcSx7bnjNPhj8Bo9wOBHHZTfdSopV5UezABZ/slvIeQufIt5lK24hA/IMgc/2WOLcoEKsXLv6jwsKR1hvuJY5PsZHqQaOKrGhVHvhNe7iVHXrIjwol3lUhaPuPghYpOprXGS2IgXxKHG389TaUogF8+ILTaQou2raKB/tgG3wCxAt8OJpCrahNGFo1W409TzzBTSJD+BLEknC5tonlJ85ZVRPjBgyCgQkVMnYPfWlGgCSG2RgnioNzzD5ExjFkI7B+lt4LDn7PR0KEXtYNpfbqTBQFf5Lr1YpOhDWLOTX9RC+DjRoOJqZ/AHk6EbqRh/QCOWXP4g7xuVeD3AQYbJUq/7Klix4uKu8p0tf8OSOY+/JLEP9QyhykxXZLeigpw5QwcweduA+v8hzeYfq8ePrMvQZoWQnGzY4IU5HC5keziOUQ+1rWhp4X2YGGzU4aw1yJcKcWbn7xUCCnxeuoAbJY7og/PjNUi9OfxvMoeyruxh8Qw4p2zCg9DYBxtQdvm5lyRJCYKbJhVDwD2/DqYtR/3Wu4kjk+q3xCl3kCj82Asim2MJl9eulrhjDdjf6bXFLpv2YhkOd8o/lz19Kb4uzBj1Y44FMsGexMsFiuNoq3iPwkwLRvpBi7UXySqIYViUhZwCg9vCahVCFoVbUVh48dkKK9aMJ0VLYzPCiODi0B9fOvPcIpccr7bTokLomDJVv3VnsIC/h33SmFHwhKHCLplOujg8cAsl8wuMKf7TokDz56Hr2FwMUnQv+f/zue1YC2vjjLmpC6eUhcAlFsAPQ9LSlUPizvszlxFs6kT8oWjYWv8l1d62WVmLaClDt55qkeVf
 eFm6uvK0
 Qfa0JE4IzVKaCDnhGLbEP2zs0lfbPmAOkur43dkvFu3sJjTEAbbpSUjKCjbCHI6iX6Gzi9eqdSrHnqiiK4UvvBZIQP5jXGWyPtCB4QBOH6MZu6sHjBsJ5U3vN8fyi/wG9wMVRFyFq8mPHK4qZIqZGAYQj1svmpq1DdV8O7VofXL51pNRZtoBeAgQ0zUu385T+VARosr9ssPAOfhDjLJEj8EkmeqYWFd9AeWcPrDp49siYa35kcR281EID09x2tMpPt4DuQmWAQGfFZqjqbVoMYLyb9mZkYgPA0bxYdJGqOiyKvajDw0w/tQhXpMuujiwU9ysTFJwSWXQPHAxQNvODaYvWGeMsRN/MwgSK/ORODq5dzfByGe5BDtiTT/KUCBSO060AhpyghwyDsImF9AMSgLuD/xGj2Bvx7uUo0RbUkNKlSI8QqB3k3kkJd5pdYARqhrfrgNBqScILkIcVUmqnMUD6Kidl6D+uDx5BIpZ79E0EDmRBM5kLwJE069UN7kWfk7mwx11drnOF0KsFWhRDuabRCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 13:43, Bharata B Rao wrote:
> On 06-May-26 3:47 AM, Balbir Singh wrote:
>> On 5/5/26 06:36, Matthew Wilcox wrote:
>>> On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
>>>> This is v7 of pghot, a hot-page tracking and promotion subsystem. The
>>>
>>> I continue to think we should not do this.
>>>
>>
>> I am unclear about the benefits of the patchset, I have not tested
>> it or reviewed the latest revision. My big concern was that top-tier
>> might not always be suitable.
> 
> So you are saying that we should have a capability to promote accessed pages
> from lower tier to an other tier that is not classified as top tier? Is that
> non-top tier node the one which generates accesses?
> 

Yes, a top tier node could be CPU less for example.

>>
>> I see that there are some numbers posted, but I find this weird
>> "After the graph creation, the processes are stopped and data is migrated
>> to CXL node 2 before continuing so that BFS phase starts accessing lower
>> tier memory." Why not allocate everything on CXL node 2?
> 
> In the ideal scenario, the benefit is to see if any pages that land up on lower
> tier get identified as hot and get promoted. That means we need to create an
> over-committed scenario where the pages get demoted first. I have provided

Why do the pages need to get demoted? Why not allocate them from the lower tier
to show that promotion upwards is helpful

> numbers from such cases in my previous versions. The problem with this case is
> that the base hot page promotion (NUMAB2) hasn't shown any benefit at all with
> my micro-benchmark - Ref:
> https://lore.kernel.org/linux-mm/868004d8-bb8e-4800-9fdd-ade48e95fe3b@amd.com/
> 
> Same has been observed with redis-memtier benchmark -
> https://lore.kernel.org/linux-mm/957f2242-56d4-4bf0-8aeb-9d60fbea8c8c@amd.com/
> 
> Instead what I am doing here is to take out demotion from the scenario but still
> retain the access pattern of the benchmark by pushing out the data to lower tier
> when the benchmark reaches steady allocation state.
> 

Balbir

