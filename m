Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE00710FC45F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 00:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80346B0005; Wed,  8 Apr 2026 20:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09E16B0088; Wed,  8 Apr 2026 20:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAAF16B008A; Wed,  8 Apr 2026 20:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A663E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:21:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 541E0140315
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 00:21:33 +0000 (UTC)
X-FDA: 84637113666.03.FC9B0B1
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6EB5A180003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 00:21:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NToT2hko;
	spf=pass (imf16.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.201.42 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775694090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=buMWAHi7yIFQAWQoPHARW58KDDrq76ic0QVHmO9xzd0=;
	b=XwgHGFNSHwnG/1E+KaMSW+OavfyX8JFdd4PBPGtpT23Y8YqPo17LOWm9vEO3o8f9NGAOe0
	03Nhd03UiqL7gSzSTaY1pZSGsqfT4/ZpGR2jsvrfjwURpAZyUh2G70KYsAXMj3iQ3ymuLV
	8Ai6NLSwso6N68XBPKnWVYHBuxuWsQo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NToT2hko;
	spf=pass (imf16.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.201.42 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775694090; a=rsa-sha256;
	cv=pass;
	b=zv73LMcVpZ8GX/V5uKUDfKVBHr7Sgotv3GJ/YXYyX3ibhWSegAJis3MK+tU4MVVk6RJ2Ho
	+yi5GJwGzpi/IeRddBW569eZzTZROXhpX1Metw9rL1dzBH3W1ohkdQhSQoJJ3AwySk8MKo
	bFdShrxNQQxHwOFq35VV7AcFiOTaPN0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFXCrmn0OJdjxXL9Z+BDdJCCxzHWRa84EM2A8YI0RBdjDZzmPvs5/HkJPHvy3eeCOniMT6TCTu1hI5/xEO+9af7VTC06edK5/EgEFPhCOIStz7IOVMhW9DWjjf2smHNFBXJ1F5XNawX2exI/YcUKp83WHuNd/93CJKCq0gNj9Px4ShbmVRxpGIFChR9VAI5TOtj6xrhjJXwRo5YXd71IH0KZ5PB1/cQ93nTGgHVWl6CpOy1G4fKbfwKaruHb5qe654gN7IQ17EovsfDWJI0RdRoLL+vcIKjLpTCwvEUnRPBKDWXB8DYYlsma3siGbxC9ad9tLt3CRlqZ7CM44cAxOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buMWAHi7yIFQAWQoPHARW58KDDrq76ic0QVHmO9xzd0=;
 b=atLQq3ufenbckkAt66jQyQ0tR0Era2TvNCEkKpE4x/roJnzGO0MIseQ7HuTSOR9cfJZoDYrgAWgq5xGL+Zalwaa7CJRTArvGUTtKmcl0F82tVg/ZEJC+kJifGRc0SIZ4E1kz3+Spq0wCo2CLYeo7ex8Lerb3MjuahHbqwfyLZvCN/oXsda5c0HzlwWjD/BDEUEibv2PQMM4ubuP9RS4ISP4JeaPulPiTHndZoUY2odiBMc8AmumlBtneFDlZuszPe6G7AGLnXdp4RKgvLjuTp4AX2LOvfPfG3HJY3+JWMQclhoM2ng6iqOC4d0Po3Xrtjtp6jY+OLJtgYdADLDkkKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buMWAHi7yIFQAWQoPHARW58KDDrq76ic0QVHmO9xzd0=;
 b=NToT2hkoo4fCw5xWYkdn5yu1EI4WKNs7IjxDRB9Yr00q6XjsfKxPNVRPF2hCajtgvEz96oGTmyPz+T+wEtDcEgHAhw8sc7jazIw4Tze2GXAcvDWr6G14oozWMCsPZXbbWsoCZq+tnx8SJCOXPer862bkQFWQvUOtubOKuc+E6mAHFDgRwUbdLQ/MeDK7Ig603O+aYR1n0fYVtdawNhtEJvqbl3l9qa8GlU/RBkUIK9F9eWYB1omFua8cp3zc2JjKMq8F0Kc9fwz3uKFxI6SPJHnL3dWQrf+cdWAC0B7tZ/2F3HNVHkyl0KK8t5PppAYUhptcl2t5KVcW2n2f7NzPtQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 9 Apr
 2026 00:21:20 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.20.9769.020; Thu, 9 Apr 2026
 00:21:19 +0000
Message-ID: <70fd648a-efa1-465a-8e6a-51411dfd50b8@nvidia.com>
Date: Wed, 8 Apr 2026 17:21:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
To: Tal Zussman <tz2294@columbia.edu>, Matthew Wilcox <willy@infradead.org>,
 Axel Rasmussen <axelrasmussen@google.com>
Cc: Gregory Price <gourry@gourry.net>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
 Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>,
 "T . J . Mercier" <tjmercier@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
 <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
 <acX8_XMQYA0-NGUW@casper.infradead.org>
 <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:254::10) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 4206f10a-f633-4235-3b3e-08de95cdec08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EoJa9Yu79+zlNflV6BU0tU5NkJw2lgW8CTFmpS5aN1o+lGma/p0NrAAR/vok5XASVQX/F1o1fBbqMXm4oWHbbO0lvL2NRKRNPpA/Bh/DXEs40rGCrKVLJTZMlI34i+eU6+qgzrmWsVGfF3ksXoVmTX2MJuS3Xhtf+Mdp0ZopNXXHmoF37EtRjkUUBdr0/6v3ARoH/AM99pkWtmCt4Oa3T6eHM0MUpIZQe+TvR23kBac69v+vABM4ziNqRVy3WqSmXW9BhEmPxZK9fONQFoWuTcxIlcH6Eq47S3GAP/DI4tM0yQ2jEAeVCtIOwRJIQL3AeRcnq1HnNPemYoYFyuvVPeUP4WM8FF8I0YRpBNfIJnXPy4TT6msreLFaDOVF8p8BY1VU1OQV84t7f6lB1JePnm77XnNwLB7BwqQAbQkKsze54C76Yn0a3bhPn4K9iVUzlcR+q8FE9l/zCLY8zezOeyfWkOEyoyaMIhfNBEKKsOItsCr3BbxJCVTAud5Q9iTWo59EJzxQ9EPVOlWJqZnm5kHJjliTFrI5Oz0IuTGl258RlxBGI9eBiS3Eo0y/uWrG8mH6rSi/TCUE0Pw+6Qyq9GrJtFj5quEPqormQLbZEiL3uBwIVmOuShFtrgH6uUbY9JrBR1j7tDQa8v+rEf0TwmbboZg36W2eLV/1ajokJfs9E3bK8NTNsCfZN9xWJJq77vRPuWeBKTFOvseyCIEqHpfigWypJlhjuhZP8YsTo9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDBYT0hxdTVYVTFuK0NJSGtJMjJiL0dSWnJEbHNtWTg1UVRsMS9zejcwV0xK?=
 =?utf-8?B?eHJjWDdEUlRPemhzTXh6d2wvaEIyNXRwZU9CZ2dWaFJJRnc4ZnlwWGh0TWky?=
 =?utf-8?B?VXRqeWc3Q29ZM2xoWTZvTHlreVdsbkdiODduMFZzWkFHU1pkT29nTDl6bWtk?=
 =?utf-8?B?cVdGWGV1UXRub0ZaNE9PdzhVV3YxeHkwU0hVd2xFeWhudEVKT0RodStZSmp6?=
 =?utf-8?B?c3ZCVmt1NUdTUnV2d2w3QnYwWjM2MmxkS3hsM2pOdFYvMnl5ZUZlL0N2QkI5?=
 =?utf-8?B?anBHbXU1Qjl0V0ZhVjNtMzRqVGhITkhOK282bTFYVWRIZ2ZpbHl6Ym9mQ1BV?=
 =?utf-8?B?c2FkY3dXWUpZOFIyYlJVQTRpbGdUWUxZL090bHFnb3NFaHJTc2h3Um9NbWJS?=
 =?utf-8?B?UFdmNSttU3hIRTNtNzV0ZE5JdG1KYStCRHc3ZWg2STU5aUl4bm5iUUxjNTJV?=
 =?utf-8?B?dmFmNFBqRmtkUERKY1BzbkhRUzZVcU5CejdBVzZEQ2hpUVN1R1F3UCtqTDUz?=
 =?utf-8?B?Mng5WGZUMmd5eHNMVHBmVkdmcDdFYWo0aG5JeXZGRXhvM0N1Mjg2VnVBSVNI?=
 =?utf-8?B?Y0h0WmY0MmxHZ0JobFY4NDE0UG5YK1p2QklueE1iSmkrLzRXWlhQWFVvaEV5?=
 =?utf-8?B?ZUp1aGZEdGFGcXcyQjNWakxaUDh2LzlBL2gvRUg5V1VkbmxLMjFXc2ZQZXlL?=
 =?utf-8?B?YlczRytMOFJCcHFSVE5rMkJJTzg1eHoyU2VFb0M0RGhGbTh2VS91a0ZWSVNw?=
 =?utf-8?B?U2RudzgwSjdNc2I4NTZFQ0swVldhVDV6TGpZNkhVOVZ2UjBPUloxSWorSUI0?=
 =?utf-8?B?aFhta0QwUy8xQ3NhemtUSE04aHFjQ2FtYnRUTUx4YmhGTStiSlRBZnlRaEdD?=
 =?utf-8?B?VllQNXRrenZ1UXkzMS9LUzJXWlkwQnZwZGRwRVRvdmMyOU5Pc2k1S3RkR3Bh?=
 =?utf-8?B?UDdhTkF6M2pKK3ZKMDFybTZJYlY2MUdKQWFtcFRGMUwyOThFVC9CZnhnS1F2?=
 =?utf-8?B?c1FqYWt2czNCUFFjRjVSWWliRkVMdU5pUkdGcjdyUDFHSERFTWE0UkllODZx?=
 =?utf-8?B?TGdsRkc1YmJGaU1RaXB1clNUeERZakJmdDh1V1RoR3ljNkIwbUtMa21HU2FZ?=
 =?utf-8?B?V002TVhzY0V4V1JoMEtvMXRtR2xaaW5RVVFQOGNvdkFMOFpaL2JEam5JbGdp?=
 =?utf-8?B?djlaSVV2RWZHT0RQSjFGUnV3S1hmWWdIOUVtRU9yaGZuZGVveDNaMVpMWXlh?=
 =?utf-8?B?alRBRXhoZjVWemZvcldUaURUM0J4Z2ZPQjFGS0I4VExaYU1pbzk5OWZKdVpL?=
 =?utf-8?B?TGdKVEh5THJXZ0Q0MmFnWHZveUlueldDNVlHTGt2TG14UHY3MHp1MHNHMlVr?=
 =?utf-8?B?YzRuMUhPQ0N5Ym02TnJBZFZQMCsybml4TVE1ajNIN1NtczdWLzVtaXFoNjR4?=
 =?utf-8?B?WkluRUFWalZwZDZ6aGp4cmtKc2NxSVRCZm1FMHRYcEVqd1BUVGI0QXhsdE9M?=
 =?utf-8?B?c25UUExXSnRHQno5NGJaWnhWMXhkei9GRE50R1JhK0M1d3R0TW1xWWlTc2I0?=
 =?utf-8?B?Yk9lQUMwWW0vNHduVFk5UmdvbzVVMHozcU1IYmdDUE1wcVM4OFJzdUU3MTlX?=
 =?utf-8?B?Y3VzVmxlNDJGeGtRazRSK2RJK2FEVjdsT01aRHBjaWdNNlI4UkQwamFLb0Qx?=
 =?utf-8?B?TFFPTXc0MTJWNGpvSUpqM3Flc1A3bHFvNFhua1BjVGFOWmhZazdDZi9YOWZO?=
 =?utf-8?B?dHBlL2hSSGpXZTREVy9UVVVJV284WWkzMGdnR0dGZkdHVDAwRzFPOFN1cFBZ?=
 =?utf-8?B?QjJMbUREREdsbDgwelBsSUt1Mnl2b1MrVStoZ3UvUVNyT3Jpb20wc3dSZVFQ?=
 =?utf-8?B?N3c0cks0RjNqV29zYzZCWC8vcUJ3SDhLR1h2aDIyQ3VCa1B6Z1JkVHAzYWw0?=
 =?utf-8?B?MWE4UmQzNml6KzQ1aGJ3U1FhSnF3emhhOFBreXNGRVRYR1VacXg0bUJNWisx?=
 =?utf-8?B?djhyQjlrRnB0blRXL3cyUVcveTNFanhwZ2dNU3h3aEdwYmVYelR2TXhWbkdX?=
 =?utf-8?B?SzVLYW13anUzWW1MNW1MTnpHdG1WVDI0RmVqMW5GSkhqSjB4OU94bm5hSzRj?=
 =?utf-8?B?eVJJcSt2eURKYk5vbDBBbHY4TEJNTmYyV0pDYUlkSExGTExZTWhacU9oWVg0?=
 =?utf-8?B?dUVlM2U4R0ppTkJsWkk0a1A1QjNlbzhjUTZBU2cwRnFsOXVHS1NxcDZGMVMx?=
 =?utf-8?B?UHdUSXBDM3BXZkNFd1A2Q0lGSmdGWklFbVJCdW85cWpBY0Y1RHZMbU9vN08z?=
 =?utf-8?B?RisrTWdadk1tZjRESWZzaU80SFplSzZhOG9mT0NPRnhHK1Evd2VJZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4206f10a-f633-4235-3b3e-08de95cdec08
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 00:21:19.5380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rd57xuXQaQ1EluFHb//NTK0Q+hM2O+0YDV4oRHr/Pte8ET5uMD38RsB704gTKR0c1rPZlt1t3ZWL+DIMBUztNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572
X-Rspamd-Queue-Id: 6EB5A180003
X-Stat-Signature: tzfof1iwep3oxjia5rcdkotmp6jqzpca
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775694090-800833
X-HE-Meta: U2FsdGVkX19/wNxZhjsbFypYUHvb+g3psWMt94o9lIr5Q1x4Ze8A+3gnvQWaLFwm3N7GcYExKnrApADV2R8PmvDXuSxcvbkPSf+CSLeODFwHWXskdqIP6M/qijOnc0sPymDMMWzOgMJVOzLvx4CMV9VbavxaglHe98vFrzuzXfvP1rEMqUy/DyThIknLj+x6+zQzKEoailM8wJjZw6odjCKkji7SXTEFcV9CElMJN8lLuTy0XiJPRbhmT8ace9Yb0IT+ileGFB7Vq7lyI3LMtKWYEqUErVtRhN5XTBahQxxXxfjBFfyepOYiE288GQs6h5tL/qHOtoUVZbkpgFLsM7k9hyvXaQOR3sEnkJa9+QJ1ovLrAobbZR7pJekIMWQWidmFuJE1sCO2fJWrIEmp6/S9vxd3k9HDEbpJ+L2UOBL0zp+8dT0gopJD3laM5ZlKKX0tbGXN7elSNj5U6OHIT3LWqBz3iLieWf+Kwe8qVyNk8umXYkpyDVwcMlElTVej3rwUGS+HhFf+upJXxCaxCNCA5rluxquh7Pv1dzRjF5bpJ5BehP2lo6d9U4M5G3LXfyv8KzKMlLNpx5o0gMKcJFjrQifBzMmV/xL7IyO966rKYRSHfmA5yxVcm/D0saJbCg9uINHhDyeNDaqE6ov7gSVbpDPts7Lm2h7ZWgvlYtGfinlYajgH3Mpjajmz5MMXX4y9MiDRLmpbgY7xC8ld+pgh4jB/f9hH5N5tSdnqQ9ysUo+aVkSqJrE2iwudvAEsoy6KDmCu6H6cRV/nP8HFRt8vxDn0MzWHq6mEFz0YwzjLrF1aqTnQ7v0RXZIiaTKQxyipdKpQUK//qvB7kHXZfmfyPPT9vp4tdtNvu/wr4N+q+Oqi6JqNmodHcrirJJtib2Wo7xqjE5cIZ/jUDXk+uSnj6k1xtmRrneRWcBKDwpb9xrCsmm0zLZObHKVDJ3qOAG3SI4evDRmpukVnCai
 XxTsv9ll
 fWKbWuORjBbTYod3gFAXGcVbG6ho9bXFx6xChCo2Q65Jy2nD9HyMuGQNZX9qT6ZdLNUfGwivB2X5uJQz+OkzqCW1O27RO4xiGFC1Jqroi4j9E6eNQWhXOlPQXwx8cB1DIFngUy3lY4O5LGHBmT0bRpwJRBlRQgi713uzLdTls8p8gdOiOtZ/ZH4uFiUaExbwJMZCZdUD9lst1GpgoUAjpS6kiQ9IT802MFFkK+rK1MUlM6N3snNnLN47faMYAb+7sfk3haXL89naBNHRnagnrpOcgoiyed6ziSCCpeUK3//XLn6cbuy6hwBe95l9WQDYB+AMwzfLSz/HwW+ZAThzMGlPtg4H580wvHA25TY35X4u0epislKu7BPoenQMtqDFYf7r4mQJ8BYH0Wc8KoTgqbHtaxeX4pIXxrtTknZ+o5FpyMIxzbcB3boA1CIq5vreVArj03/rn5O01iXkg2Y7ioihQKlvgjaFzcS3RCIsj5OOrCE6x/iQSwkb1L+pvog2+RLK7nnhgTYRcXikjvsu1JJ+3Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 12:12 PM, Tal Zussman wrote:
> On 3/26/26 11:43 PM, Matthew Wilcox wrote:
>> On Thu, Mar 26, 2026 at 01:47:43PM -0700, Axel Rasmussen wrote:
>>> On Thu, Mar 26, 2026 at 1:30 PM Gregory Price <gourry@gourry.net> wrote:
...
> Yeah, unfortunately it's not so straightforward. As a simple illustrative
> example, consider a file-search workload, where you search through a large
> number of files over and over again (e.g., a poor kernel developer trying to
> understand how the page cache works). This follows an MRU, rather than LRU,
> pattern, and readahead doesn't help much, leading the active/inactive and
> MGLRU policies to have similar performance (~40s runtime in a specific
> benchmark we ran). In comparison, using cache_ext (our eBPF-based caching
> framework), we can run an MRU policy and it goes down to 20s.

That's dramatic!

...
> It's been well-known in the academic realm for a while that there isn't
> really a "one-size-fits-all" policy that works *best* for all workloads.

I think that that point has been less clear, outside of academia. In fact,
MGRLU (to the extent that we believed we would eventually get rid of LRU,
in favor of MGLRU) doubled down on the idea of one size fits all. So this
is interesting.

> Yes, you can make a general policy that works *well*, but if you really care
> about a workload's performance and want to squeeze out the last 10-20% (or
> more) of performance, you need to be able to (1) experiment and (2) take
> advantage of application-level insights. Being able to extend reclaim (in
> our case with eBPF) enables that.
> 
> We wrote a paper about this that was published a few months ago [1]. Happy
> to answer any questions and continue the discussion!
> 
> [1] https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
> 

Excellent work, I was delighted to find a well-balanced description of
both older and more recent history of the Linux page cache there. 

It's helpful to read this, even if we go with a non-eBPF approach.


thanks,
-- 
John Hubbard


