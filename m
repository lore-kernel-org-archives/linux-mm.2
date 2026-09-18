Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8499BC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CCE6B0088; Fri, 18 Sep 2026 16:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754686B008A; Fri, 18 Sep 2026 16:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6427E6B009B; Fri, 18 Sep 2026 16:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 344576B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:56:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A36C1A07EB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:56:46 +0000 (UTC)
X-FDA: 85228092012.24.9B98583
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012068.outbound.protection.outlook.com [40.93.195.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id CAB351A0007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:56:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D27g3fCz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9+7mbsKLC8q2sd3IhGOcEdI+JtyIX6X8QqCW4xSooo=;
	b=J6L/YrnzvquLQwLF4G9HPx2/TcHIitacMu7uNS7/cGlXXaLQwIybP53lB2Qy5HYsSavUXi
	xDdySHvU9CVE/KQJCmhm31BVT3HmWaZPe/X23toE/jJa4t+kRoCYCRVFuOfdjtyII374OT
	jeVbZ9rd0uQNqUYgUkDoj4PuLt0fC80=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D27g3fCz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789765004;
	b=ELDOjh1E48dmybVbHTVIqie5NeR/S2dkkSfG9D3tKtJYS2ddq+x3uOoI4/vHglSmrvSGkd
	j04idu5pRCZgTDNAs+VguY8y3V04AqjAmuLyEuC/A+wBgQoOdu/Bw+53j5hXW6zXtHSvCp
	Azn0gj1VgBL4hV+K6fKYpXiXTBq0iKM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMVkfzUyE5nXkU9rY/T7PciHye1zhfNRlO26BLCZwsgptEflFvrsohEM4/vjIOfbNtkcdNjjScPtkNvDhk36RkeqLVYQh2P7Wg2fUDZRtVyankmLJUwImNVA7viH4IxBS+WWCFV3mAHviOSorl+t8PEpd5of2ndinc2vbvDagyohaMvlbBTjhP+ergatPfXP6zUdHwOIVkQOUJ7yDHGKS9/lDpx0ZKoJRaLvjd0Gn9LHzp1kxlqaMYLoXu7dGXvuRE3PqUiAP4E2B3glmggbScGM1dpyC1HLr7CLHLX1MN+C17LDoPv5ZvYTN/p70SeYvUdnaBRttzk5t3a3fS4TUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9+7mbsKLC8q2sd3IhGOcEdI+JtyIX6X8QqCW4xSooo=;
 b=bIn2rnihGcda66nH2Qtff1tdl04FwyL8LpZSJUmEY+DgM4CYWLDWzchBuqlL5l7AoFsC5A8FikgsQhm0ePMU2X2T58imuBiNvXTMABeuD4RVdRdmxK5gYlGqpRpXNdS5Q4qImSt+6CkDvcjmlniNzwvyopMNcZmGMJ0C4KFndRvGmrg0FZfpNFuziTdL1ccYsNna2agdkGvv8b54bev1C/1s0NU2QvUHHqUv78rEzABOVtDq3LMnlIxGeQECAOizRI9EVfO0EllntMYWBfesR0EBYkx4tW/a6uiB7gUHyxtx5xyKa+8QYCMSx1ReTfKKvICSCEJpS2gL1GkPWzcVHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9+7mbsKLC8q2sd3IhGOcEdI+JtyIX6X8QqCW4xSooo=;
 b=D27g3fCz8Z4PeI8bM6ylg+1HRH1Okr4UDkf15El9j5qKq75q5JtINw1mNUo9Chk3d+H06+o0iRW5nRHtnW0x5PYzSeeDC/3Jc0b1+lQs/ebZqx5a/ZLLgOEfuAXDERn91fFudv7xU5rqXoB5HVyErN/R3YRU0MdcGotHQ7b5k8WhmUpEAawR0wDb3jYHSOwQKBc7IQuNOTkgOHPqbka3E7qWZDh+l2PgbQmNd4B4k7HEZYDa9eqlQM8GM8MLU3QR8em7n+5cd+inkl435EpfQ4SIlPcW8oJa51R8bd8vvjPIUwD3xnLL/+qqllfGrzGCKZp41Qe5FW2tffwEMcdIzw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7376.namprd12.prod.outlook.com (2603:10b6:510:214::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Fri, 18 Sep
 2026 20:56:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 20:56:37 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Sep 2026 16:56:34 -0400
Message-Id: <DLIQQNUL2RTD.IGN8MYHYMW1E@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating
 promotion
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kernel-team@meta.com" <kernel-team@meta.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org"
 <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>, "bsegall@google.com"
 <bsegall@google.com>, "mgorman@suse.de" <mgorman@suse.de>,
 "vschneid@redhat.com" <vschneid@redhat.com>, "kprateek.nayak@amd.com"
 <kprateek.nayak@amd.com>, "baolin.wang@linux.alibaba.com"
 <baolin.wang@linux.alibaba.com>, "nico.pache@linux.dev"
 <nico.pache@linux.dev>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "usama.arif@linux.dev" <usama.arif@linux.dev>, "kas@kernel.org"
 <kas@kernel.org>, "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
 <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "jannh@google.com" <jannh@google.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>, "osalvador@suse.de"
 <osalvador@suse.de>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "raghavendra.kt@amd.com" <raghavendra.kt@amd.com>
To: "Gregory Price" <gourry@gourry.net>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20260911001826.2109390-1-gourry@gourry.net>
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
X-ClientProxiedBy: YQBPR0101CA0329.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7376:EE_
X-MS-Office365-Filtering-Correlation-Id: 12f027c2-bc9e-4b1f-b741-08df15c7549d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|56012099006|5023799004|11063799006|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	SVVJwJEl4kZ+EzrWJZuiIipM1MLt9ocgyD4V5G9M1yXkStXnWMUifoS0XEiHzO+PXsQrZYwlNaySl+ikL4o4krDdK+6nKWddH06JyH/+lp5j9P+wF0NVtnyvKPrqtDt+jlVpP2r8N1kKxCuJKKynjI6mZuBTFfxeGgB4R3A+y9kyQ32A1JObAGKKgTeZaldpEqiSUOCf1PPMyAmygI1AxeViz98z0e664oEra2EaXFcGDxhqK2QWDEke8bLIFcgEhqR0TIxouLYa8+sJ7wOxSrUZNz0AcsjfLMIiCIhJqVfuWupM7ovGcUvx02DMdgTdo+uBArsY7RzdWW1aMu0dZcZ6Mjw3OKdRO84VNRUG22KyihdO75uddlOEV+Te7FLkOprK2mR8iKhi0OugcjeHRdR1mBxd2yul4rG8OfPmUf6BuIeis1zBd19alkbw7K6MHAjnNOjtN0cDZJAi+mPS/99jCYDNtk76rwwc8ZtkvbTMtcsAXDlg2ROyUeeMkbZwC1KbomPJUDq8mi/Ttd+Ad6rJ9RCWdxqpEEnVvi1O+XQKpSk3pmyUAMGCrVSmi8sTlhOHDIvRAjuVTbH5l9HM4Zq9orCLAuLtES43XukJg+WfKv+nS5i7/eZV1s08lZekRq2UHZQxJut6ig+F5R8MnyIrsXGZoPV7jcAtW8f0NtA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(56012099006)(5023799004)(11063799006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2o5YUxiKzdKVzd4TGlhTjkxUFc4dFB4WUVZVC92UEV5Y2piTWxzRnJzS2Zp?=
 =?utf-8?B?L0VBQnVVc0RYN2hRQUxiZlZWZnNobTlqS3kxM08rWm43SmlLVEVpcElpb0hX?=
 =?utf-8?B?bi81aVR1WVE0UnlvUkN5NFZMaW9xM1F0NnBzbkJyQVRKVEE0dWRJV1dKZGpE?=
 =?utf-8?B?UnIwdEdTMFhKNzluYVI5M1d6MXQyL2dnSlQ2b2FiT2VIaWxrNnY4aC91NktP?=
 =?utf-8?B?NkZsWGptV3BYNnQyeVovRCtSamNpZG12TkgxdzdBOXY4bmU3Y2FwME5ZV0F5?=
 =?utf-8?B?RHRvL3loQlRrYVNGajc1L3N1NjQxaGNFTmhCbXpMWW01K0tDS2IrM0djVHpB?=
 =?utf-8?B?dDl6dW1NU3JQcHoxUFM0UUFtczNON1BGbXFMVzJOdkt6VGk5MUhNMWxYcHBG?=
 =?utf-8?B?TUFLakFzUi9XVnVEZ2NlakxmMnBOamMya3dXWjUzS2dKOGd2enhlek1GS1NQ?=
 =?utf-8?B?VXJhQStVMTFoWnZLNVpXbkNoamk0ZmlZWlQrbFBVZ0hHVWxjZUJWbmlwNDFk?=
 =?utf-8?B?RjVhR3MydE5SWXVxbGJxd1lmSys1WDd4VVY5RUxsYnFoK01DTGJMVDNrK3h1?=
 =?utf-8?B?eVB2TWhwQlpxOG80TlhFbkRjRmgxQlZXU09XY3pjNkRTeDhrT21NR0xqcVNr?=
 =?utf-8?B?VUVoaUdmUHhhZmYwdGs3YnZUNFNsYVZxcXR4cWhnWUl0UEQ0NkRVMC9WcmdM?=
 =?utf-8?B?T2FQWVc1SXY0YmNZREVtejFLbi8wSzRjcnplM1NQOVAybWFOWDNnZ3Uya2JK?=
 =?utf-8?B?QVJFMDRaV3BDSHI0eDBqRzdQSVlPeVpibEx5czdadmRsdnNWWnFPNVNCZzg4?=
 =?utf-8?B?TjlwYTVTMmI1QkF4YVlPZHlLWEJ1TzB1a2RkUTZONlJHdjkrMSszSVVacVpR?=
 =?utf-8?B?SVY2OVYwbm5ZcXNtVTBNWFFOd1FaSVhLU0t2UzdqcTlwMno1Y09WU1B1dkJl?=
 =?utf-8?B?Sy9JNVUveU9WU2UwSFBTa24ralJMU0JxaWtIeStzeTNIMkZZeVdwTFZGRXdm?=
 =?utf-8?B?bldPTjgxa3J3SUpXSnRBTDBTbHB6eStMUnNLNXJGajNCdjRnZnFRTWZvUW05?=
 =?utf-8?B?YmJCOUFGbVRicnQ5RlRMU2VCYWJpSTEwdnpKNDZ4Qnp0b2lFeDFsUUc0RW5l?=
 =?utf-8?B?cTJzVnFmWDQ5akpBdDNUQjJCcXB3OXNTOEljckhIbGMvK2pnUmhsNVpFTldh?=
 =?utf-8?B?SDRDMUpScVpsRnZhL1Nxc3QxMmkrZXRLUVR6TkhTbmF6dUovRW5XcHp3YlZI?=
 =?utf-8?B?d0Q4U2FyM09zdElmcG13T0M2U1VILzVrM1ZyOW85SUlES1RnRTA2RjF5cmRo?=
 =?utf-8?B?ZUV1NzNWbWIzS0EvK0xtVnVOQWZkeHVKQ1Y2RjJMKzU1bU5IY2tGZCtrV2xV?=
 =?utf-8?B?ZzRhODFyY3ZoSFl0WXI5Q0ZVOElKb1U3WVpVNGNUcVJoMkkxbm9aVUxCdkpq?=
 =?utf-8?B?eGlYd3pQcHlTWHlqMGJsQmdtYVZKUWwyNk1iNEtsSWswZWdMdjVjYXhKT3lE?=
 =?utf-8?B?RWpEaUYvdnY3R2xJZHpYbGJSTnF4aVA2NTdrcjZLNnhnYXpGTzBMc25pOFhT?=
 =?utf-8?B?YzUrbFF1akJSa1hCcy9HSDVZQjZqOEwyWnA2dndhQUNPaklxMXhCVVZ5MC82?=
 =?utf-8?B?N1pYaWFKdmo2ZkdGaVNmWDh3M0NWNmF0NUNXenRreDhrVTFhdVNmZktlNzJn?=
 =?utf-8?B?dkNkYlFuUi9ZZ0ZvdXRhTTF1ckNZYktrdFE0RjlNaGdVQjVQd1RCUk5XMUlt?=
 =?utf-8?B?bWpneXUrRGJKNWRVbEFwampvVVoyOS9wckdlVUZpUlg5WUtLSXR6c2R6QmFG?=
 =?utf-8?B?THpWTm9XUDQ5Wk11QWZXZ2NoYSsvTFdhRkV6cEZQRWxhWUZtcWxDQUJ1QkFo?=
 =?utf-8?B?aXA3VWV0Z1o2VldBeldBWnhKSWNUZUJLb0VZd3hDdE1RcVoxcVo0c1Q5Rjg5?=
 =?utf-8?B?ZkxEd2QxcmdWamFnTHA3SFNPWFhacm9wZSt4Yi9GT255TEpMaEtKemJNc09J?=
 =?utf-8?B?UmE2emJmMGJ3TXBBaFZJT0Y3V1oxOC92VkhtRXZNazNEc0ZMZlc4ZE1KUE5O?=
 =?utf-8?B?Y000VmUvTVdNNlRETUJGbDN6MHJkVS9RK1djdUYyN3FjcU4rZDJBTW92QzZv?=
 =?utf-8?B?dlhLT1lYcFdOQThGamlsK2RxYTBnRFMxL0J0UU1VQUthNmNmYi93MnVUamhu?=
 =?utf-8?B?dExBSyt5UHJvY0RpNTZnY1hHYWhrUUxnRytzN1VBeTI5NFZDdC9VUjBrODFY?=
 =?utf-8?B?RDFwbnk3eUpqZnZ5ODZPaUFZaGxwQVFzcGFzVEptVE1lU2w2SVZWYmdtWkxV?=
 =?utf-8?Q?zrOf80fFRyyYgvngcF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f027c2-bc9e-4b1f-b741-08df15c7549d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 20:56:37.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDOqyUD6ki1gqa0cPB/bBT1xiHpoaOkmEfoU4MOp07cKOvJIW/DGNguba0bpSWPW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7376
X-Rspam-User: 
X-Stat-Signature: xt6q4wxp9hgy99xxdjroscq4oogc3wdm
X-Rspamd-Queue-Id: CAB351A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789765003-729843
X-HE-Meta: U2FsdGVkX18MS2/axb+amNHoX+HEzLaEtvxri3LKsuximUz09LtGCwf6LI1XtiWz3bfHyp4eTXcooAtFU5ho2cJWDZHhpVhL1lO+GA+NEJp9tXe7Z21uqc3A8h49AavyCrm60jnSstJMlPDzCFko29QWyaeE7VJokuOuqeoxWrfMPSA5cU8yY1dMK4BnsV2HaSSUJY8jtCSwLEki4eY+pIOezSJ5D4UEDBAtfeq2T85xiDIe2hJfqLxIJVrzPfd0UK3j2C6oC40C2FUa3KO5AS431ePxkyYeEaCzgWLpfJbEAln9SQHkqvinpZA0MK4+cSqMbH4cnXejZP/0Z5O6BpPpHVkv8RurtEXaE31Iz5rRyRxPEqIzwa+TH/Rgs8wNLno+bEed01T5tXElwLjZAts8uVlX7NyrRdntdCZWHkzUAdRrSIlTxp/QqBzAiSKlqI5RbDZutQ63tagIEaVYLyQwf28Qvt7yPhhhW/szoduETVOqMyyFlyRwI4TNn339/aR0ksjP7LdpV/nt9R+3tL9eGf+WTRM3MmbKWAPm/whjOo/XPWFhjx6AZxuJ2arSBke2e4kzxwYbkW0QW1zGeZYvXs8xY6/IPsnmKt9LE1WODwalovN5FWBB3TQQkM0VUri67ESc7XX9Vh3JzwV5z0zEcts3HDE6bL6N5q3p4PfIR+ZtXvs5IIIb4Oj9m6bJDcBhVKJWCW9l13zhP5caFzR+2K30OfP2n56piihMuXOFKuaBaJKGCuC2wVE83GmF0/4YO4bKH/dE5g8XRil7QgiJnTCLq0Jcq76A6h95FCoKxBJw6y1iPvgXQBFhs4kO6j7ORoFeCfpBGglcYXs8tGgql1Un8uVWpOfYHMFV+UyZrn+y0KBSdha6ebXr5JX24ln7pUFzE3eYFSM+dhHxbzpOn0yodGwnZoPAcUtn6Fz1Ig/RwaNzNaKGYuzuLXE/5Gpgc80Fx3ti/cTs2va
 ztvXu3c5
 2s5cfuCn9Xkc4pGERXH8sO8v3JrMVjNv9n4dr3qa2/jkAzfMKbIii85TDBmGwfT7AiWHl+4gm6amZ7sDtYCBWk8UnXhe9QUpa9D9LUF7bRD+6iUdo8anD9lVK/zPb9k5tGduq+ozmoseEzHywlBkXoK71335B9ZAFn+fVqJskf6BuKHHetyGQkFDqiCj0T064uuZwr0BLFSmQzsvrThAXqF16ol99GLPgdGu9j5XRAUGBU1E7heEeWYt6A3/zM4wQ+769nm8w04MRkmmVxfGvajgVFAlBgNYtTHaHpp/kltbtN19aJ7diGDIsEiCz8xSZevgsLg2giQ9b83AiQ+0G0dyWnwu4QoZ5LJtyWjQuHc+v4nhBGROZoH2VJDVdjdIiOeGkD/pBXdhtU+6SIgpDp+vIkVOZ2/HzJ7SJQRMdcoxGvl5J3AZc/stnLJVuhPvuSib4dDedUl/m36mfOhTwTiiGBfxf5tVgKl2WCSkoN93R8p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:18 PM EDT, Gregory Price wrote:
> NUMA balancing uses hinting faults for both task placement and memory-tie=
r
> promotion. Several filters designed to avoid unproductive socket-placemen=
t
> faults can also prevent promotion.
>
> Read-only file mappings and VMAs without recent PID activity may never be
> scanned, while lower MM layers reject some shared folios. Hot memory in
> these mappings can therefore remain on a slow tier indefinitely.
>
> Separate promotion-only scans from socket-placement scans.
>
> MM_CP_PROT_NUMA_PROMO_ONLY carries that choice for one protection walk, s=
o
> the PTE and PMD paths can restrict hinting faults to promotion candidates=
.
> Keeping this transient state in the protection flags avoids per-mm state =
and
> its associated lifetime, concurrency, and VMA identity problems.
>
>   - Allow eligible shared folios to be promoted to a fast tier.
>   - Scan read-only file mappings and PID-inactive VMAs for promotion
>     without re-enabling placement sampling.
>   - Track the last placement scan separately so promotion-only scans
>     cannot postpone the existing placement-starvation fallback.
>
> The series is ordered as follows:
>
>   1. Add promotion-only NUMA protection walks without changing behavior.
>   2. Permit eligible shared folios to be promoted to a fast tier.
>   3. Scan read-only file mappings using promotion-only scans.
>   4. Scan PID-inactive VMAs for promotion and account for placement scans
>      separately.
>
> Tested on a host with 768GB/256GB DRAM/CXL.
> Ran 2 ~430GB database workloads with large (>300GB) shmem VMAs.

Do you just launch them without any additional NUMA control or NUMA
policy configuration, like using numactl? Just want to understand the
scope of the issue and how well the fixes are tested. It might be good
to have a list of expected behaviors for people/AI to check against.

>
> Before change:
>   - 150-200GB/s DRAM bandwidth usage
>   - 40-45GB/s CXL bandwidth usage (maxed out)
>   - request latencies over 5ms (longer tails)
>
> After chage:
>   - 250GB/s+ sustained DRAM bandwidth usage
>   - ~10GB/s sustained CXL bandwidth usage
>   - request latencies 800us-2ms.
>
> Functional observation:
>   A 20 GB hash table VMA that previously remained entirely on CXL was
>   split evenly between DRAM and CXL after the changes - and tier
>   residency tracked hotness.  This was previously affected by the
>   stavation issue caused by the "unaccessed VMA" filter.
>
> Gregory Price (Meta) (4):
>   mm: support promotion-only NUMA hinting scans
>   mm: allow shared folios to be promoted to a fast tier
>   sched/numa: scan read-only file mappings in tiering mode
>   sched/numa: do not let VMA PID activity gate promotion
>
>  include/linux/mm.h       |  4 ++-
>  include/linux/mm_types.h |  7 ++++
>  kernel/sched/fair.c      | 72 +++++++++++++++++++++++++++++-----------
>  mm/huge_memory.c         |  3 +-
>  mm/internal.h            |  5 +--
>  mm/mempolicy.c           | 30 +++++++++++------
>  mm/migrate.c             |  6 ++--
>  mm/mprotect.c            |  4 ++-
>  8 files changed, 93 insertions(+), 38 deletions(-)




--=20
Best Regards,
Yan, Zi


