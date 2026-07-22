Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D4CC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 18:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575B46B00B3; Wed, 22 Jul 2026 14:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5265F6B00B4; Wed, 22 Jul 2026 14:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDCF6B00B5; Wed, 22 Jul 2026 14:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00EF96B00B3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:57:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63A2BA0ACE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:57:54 +0000 (UTC)
X-FDA: 85017322068.06.E0E6424
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 795104000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:57:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="J/Dbd0/h";
	spf=pass (imf01.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.56.16 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784746671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CX8i7FbDHjoLET5/UZuYmEvLMLYGtL9pMrNjlWbLnaE=;
	b=t8w4lkx0gz0CGjg21KpxotTFx/wl2W0C5nl7XeRChVMs8PDw9qNTwvPjE3t9AibHjUufU1
	fHo9YYPw1VIoebEHDnbR5SesgHpa6zOtxj+MmvCBTxMYKvrrQTzRm4iZYvFe4gXRF0l+I8
	0nd/4UjAit9CjpC8tpzxkbP/JdDFE6U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784746671;
	b=L0jjso/emY6DrV3LkVjggJRLbJCaakk+57bDoCbpjigJRR/1pAkHBrYLbe5pDmWJY2+kjO
	3ilWpc6AEb0KkpmEZ05rNvEmBejYROD8xsl5ICBu1/vy4KWZtsZHbtzxEEkQNuUf3WpwAK
	rhsDg2LUYIs/ISHDrsS+EaIITgmY/5U=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="J/Dbd0/h";
	spf=pass (imf01.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.56.16 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqwqAOAuwDNMYKqGPv73/DfhCNPwX3DdfYsm6hHxezrtMBGBUngt0iLLK3GOlEdJyWoWeE5J9/BhJRwjWCp3hOGTVUNoiNedwxxHssgD61gZ/V5BoecemClwGqOGfxh+jX/wuNetmtLxq+lzNeeRB26INy5mxuzIKeT0DuNPwAVgcHpsn4uc8JO9gD5eSv/SIhmforV6uIkQ8hoT27ddlDCECYgipTxAjHdNO8fG/E+jwSCP0xPu8knkXz7VExRRz3Dfdyu0iWnpbD0UirQ4HlYmebVZCBX6pOy0wRY6QU8cor4cmvCtrjaIwntBOwylGeI6dbtK+X9F1vJTieah/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CX8i7FbDHjoLET5/UZuYmEvLMLYGtL9pMrNjlWbLnaE=;
 b=wcvxsGXK1+bchALbubLluz6xSmA8O7qFVmk/ohgWbURK8+BH27e9b/O/bJ7dGL66TLRee3DceFSp5kciDzbhoVZL/feJFZg9rfUxZ4PGyscRaIrJ54PtE7wUccvklqXAKJR4mDPv3GqADGb/13wzF2zAkr6I3AOKKm62GDD5oEY3FQz+liuitncuRW3h7JjqAN8f2Ql6uQADJNk5nty/3SfXyKyRoYxZnDSGyLo+7/xrqy5ai+d1K2lxLD/pVS7fpQOjM3rl0AQ7+Du4+ieB+YMJMsZjaSqIVIYeWgPu8NJhcLVwgpgWEoQrzyNK++PtHJYucUBI1pvSvY5m//oBPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CX8i7FbDHjoLET5/UZuYmEvLMLYGtL9pMrNjlWbLnaE=;
 b=J/Dbd0/hOnH42kJ3jRsgsJYlT5u1mq1Xb4dAOyufkDOOncW4kGyLiT9U3tjMS36qGwhj1l9eg31/Z9if5/omeFqpY9XOVDdldGB+oRVlOU6Z284sg0vh71MCJDO2l8hMuQ21ihVzUw8034V80XbbDrX8bhQK4CANT9fdUPnYHddpmK+i1iqeeqiF4dHltZZrT95bH5r2XgkgDFJXXL6akMQKj+JOSR4I6ZnXxrutnNKJo016ZH2VnBc8Ly+Uo3pfpJJWbIw6E/iKXWZss94ZCMbMFlfEEnGDW14szBL4JCn2yt2FqcvOuDVN7JoRvXchCT7yEgsNoK7kAaZR+0MOsw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 BN3PR12MB9572.namprd12.prod.outlook.com (2603:10b6:408:2ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 18:57:43 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 18:57:43 +0000
Message-ID: <4ad4c2f0-aa6b-435d-b649-a8320a418730@nvidia.com>
Date: Wed, 22 Jul 2026 11:57:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] selftests/mm: make file helpers return errors
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-2-sarthak.sharma@arm.com>
 <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
 <004e11f5-ab21-479d-80a3-64ab89465b85@sirena.org.uk>
 <cefe62b7-0167-46c1-9fe3-fe7efee90a7e@kernel.org>
 <cd539861-5f98-4906-8e36-f2a5a70687a5@arm.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <cd539861-5f98-4906-8e36-f2a5a70687a5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:a03:114::32) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|BN3PR12MB9572:EE_
X-MS-Office365-Filtering-Correlation-Id: fb19e792-206e-4a4d-daca-08dee8231c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Utsb440LDfw+IEfIrNFoy3e5ai14fIKtcQBNfmUKx+7F80zv48fCOpiZ0MNXnbAvtMrKMoABC7cvZnkxLHqMzVckFuavlNSCuShyN+Pc6TJEunaouCEZ1iX67UQEo5Qh8A0pqApi3jKQl29K5C7rtjDzxM249QiBteVg7W1rdcmBjNS3pO4Bcs1OTFz6HsPUGG5vBKtuI8Q/2qHStHsD238A3SwP0unOExtlJKPMkLCQyIslMhs+8rV0sB3Ld59fkY9JIMLe1SFWDvwdQ/CMW++lm2Hv+cHfSWwxs4wHqIvzBJvUoLzBSoGdLVBa4uUdxFDN79sKFDIAQl1jn8217PXg3i1afPrgwQOHGJueyW4Tw7fCUiwF8G9TDi/ZwPdJB1H08XHBwElc9w2txX1ea7BVfDo6Oya5cB0Xu2UZtgiSrBQnbuyIbq/q6UjIOqq/WdB+inqzcMm5t2ezC0IGDuo8UW9Olq/EkO6bxQajGAFZ8qPHEPfOX75TXGD62CndvC8zAEtASfJ90npSYMeVK5zym0KW7c9qFKn86sTqIAbkKmWGxVLeca4H0wxSpVsCO8xhl0lc99GBRT/Kr4SY7lBdc5WrQ2RxlchHDAG53RltfCTaIFByV7TGjzXrhLX318NRykije77A/YM10GHw1IuLaRPXqiL7x9MnOnTY8bI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUlkdHV5eU10L0NDZStxNmRxZmNIbkg1bW5GMmh5ME8rdkZLelBFOEdyb05P?=
 =?utf-8?B?Mmw4SUtqTjk4cjZ4MFo4S0dQRVNZdGVKUTZhTmZLSklOQmZ6S2txOEJQdEht?=
 =?utf-8?B?MzBzV3Jad2U1R3l2aXM2R3NXVFRCYVNxN2VpY2dGanVFeFRhNXU3S2NGTWVz?=
 =?utf-8?B?Q2M5dlByZkZZcEplZ3BDenExakx0RmZOTjRZNjNzd0orZEpzNCtVVU5yV1ZE?=
 =?utf-8?B?WHRyMU5HOS9qMEdnczF4b0pLYVFvM3hOR1c1SS9oNnFwNHpDWEVtRHFiUHlN?=
 =?utf-8?B?aHdLNXVtLzdpL0F1WGJiL29NeXd4WW9YVVJmdUI2UXV2MTJMZW9rMmR3Y0hI?=
 =?utf-8?B?YXQ5Zml3Q2tiNjRNeHRZZ1VsVzZPYTlVZDhPZUtrTzhEMWRBWi8rM1RRbEdl?=
 =?utf-8?B?Vk51MFhLTjMxa2pPOWtkUXBwR0UwQVVrRHBoUmNWQnJRQ3V6VTV0TlVseS9E?=
 =?utf-8?B?TXY4SXFSdmRIWFdiN2N4REFxTEo4L2VKK0hEVnEzM3lISXdxRFpFdzZpTi9p?=
 =?utf-8?B?c1lIVjBYZDlSb0wxYVlJTk94ZGJ5cStaeGlkUjlsRGYyZnZQS25RZjBMZitC?=
 =?utf-8?B?c1BxOS9YWm5VSDQ2cHBWbGZJTjhEeWJ1SFAzejQ2NC81WmFUcTBROXdBbmcy?=
 =?utf-8?B?WnA4MzhJcUc2eWRiRXpaQUREb3BGS1dWbjd3dityRWFsZEo4anhUcXV0S1By?=
 =?utf-8?B?MlRsa1ZFeHB0R3lQSURDTnN5bnYwTmtXUlVXNlJRRFQ2VmFBQ0F6NVQ5dk8z?=
 =?utf-8?B?dDNCNmszV1hSc01TYTZMa24yRVg1VlU0d2F4TEw2WjRsY083TFVxRDV3YzdT?=
 =?utf-8?B?SERKc0FaZSt3T2xNSXRnQm03dDE2MFhYakhMZmRXQW90WWE2eXdBeUFzYkRl?=
 =?utf-8?B?S3FOdlBNN1FLSk4vZloyV1JRaXRxOENyenFEaXg0MHU2Z0pPUmhVd1FEQnRn?=
 =?utf-8?B?NTJaeWt5U083NGhFaW9zQmV3b2hMVlRKMFord21EZVFCMVllSjhhSlFIVUhO?=
 =?utf-8?B?VU1rc0Y5TDVuRmpidzh2Q0ZpZ2NzaGFLbWV3U056TEY1WW80T2k2NGtFUUZW?=
 =?utf-8?B?WHlHOGFSTVoxc0xNWHF1QjFmNVJTcVJhYnBXUWp5SjQzeVZWdC93NVBrQ2VC?=
 =?utf-8?B?U21rMXhhUnJjN2Uwd2Zib2ZyQTJ0ajQzLzYwTHhMeGU5M3dxKzdwbVp0RUFs?=
 =?utf-8?B?Z0xRbjFlTHNCK1BtNDNSbVpPTTFHMElWTzRhd2U1VDRCVmlBaHErSEZUZVNa?=
 =?utf-8?B?MU9kalZnV2xaSzRnclZiNjIyVUhONU9aSUd5aU5kVHNvT1doK1E1K2xiZ0dx?=
 =?utf-8?B?WEdDSUptcWN4b29BeDVueDJtUVIvS3RYdFd2akhiZmJDK0tVRitaQ2FHbEM1?=
 =?utf-8?B?TXpFSFQ1TnN1ZnpJYXhjN0NhdThSakFteUxlSHJIaFgzdFFJbENKTkducnFC?=
 =?utf-8?B?dHZrSjFPTDNZc1ArQ0h1Q1F6VlJWWjBUclBiTDZHRlNrTHRTeS8xa3ZiaDlT?=
 =?utf-8?B?NGtRa0szN0pXYy8rWFY1azFSS1BvY2JJeWx1OThRTG83YUhaWUdWRExKRys1?=
 =?utf-8?B?ZGVvV0RrZHZnU2h3M2c5V3lOQkxpeGl0YXRhUHhZVVdZMkRBWFNnNzVKa3pX?=
 =?utf-8?B?K0RoT0FGcFFZT0xPNU9uWTRBUzhEUTYzcncxekI1S1BYVGZiVlFQd0g0ZDVv?=
 =?utf-8?B?amlYeTVMdjBCQmJQK3BiNGNJdzJVQWN3cEFKTnlOeS85cDZGZng3T1Y1YzE0?=
 =?utf-8?B?UkVKL3owSHlXUnQzYW82VTV0d0pmSm1NMTkyRWJzQXhzM0ZHenNteUlaeEpT?=
 =?utf-8?B?a1Z0bndxZUFCNktmaXJUdklEK1hsdmNmTWRTWXR0aUxza3FsYjdVTjBxbXJH?=
 =?utf-8?B?bzNJL0Z6OVlSR1dxc202c1YxRWNnMEZML25hL2Vqc0tyN3hvTGJ3S213OTZx?=
 =?utf-8?B?clJkY2JkTGo1VEgydk5xOFZ2WlFvZklpWUpxWFRod2FWSWZSam52S09oM3VO?=
 =?utf-8?B?Rlo0Z0N3eklIUHJyOHZyNytuY3dKQTZzTENiM1huUXozZVdNaktXMjVKbFB4?=
 =?utf-8?B?emE5M2ZtMm16Q2I3ZCtxaStxYkxWU2d2WEpCWmE5MGE1YWErSTg5Skc4NzZG?=
 =?utf-8?B?UVFoNXI2VENHSjFWWmVhQWNlN2F0VkFpYTNPbzIvanZGOWtaM0htbUlIcml2?=
 =?utf-8?B?MGg2VnVENUNXdncrT1JGSC91THFmTi8vY2MzNTdrNW1tclZhcUt1ek9kWG1n?=
 =?utf-8?B?NHdQZmhHZUttRTRWQkZWbFFiU1NRVlV4ZW05dXV4MTU3TWErTDd5RnBWZ3Fh?=
 =?utf-8?B?MXB1ZUlaK3JlRld1cTArUnorMFV4YzVJWVBLaUNRcUZuc2hCNmppUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb19e792-206e-4a4d-daca-08dee8231c37
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 18:57:42.9968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nG0ndGTVo/S1aoj1CmXSebvr6iYlWSvvDaVdpBgVF6lDPKIUlSLJnRj7EcXRxjzIDFbchFoXpjBdxNZ6jgeJGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9572
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 795104000D
X-Stat-Signature: zuqjhcyyhrusafkkxk3pqj6p1trozndd
X-Rspam-User: 
X-HE-Tag: 1784746671-865808
X-HE-Meta: U2FsdGVkX1/FKr/B0Yr0DdtfZTDhaLt/6nLPeaJh1bL0H0zeT5iLq22+9Rk5PM+jRWAlOH6cEBT12t7PHYLXyAKWA+sYM/zkn3m2891QydtUKStOk17KDgYRrm/wRQ0R+A31v++LnJ19vcGsHZDnTFQsDRvSR6PfM3NvYn4fRIagGjBDmlU0LxlNaecjC5rhdVsuhTSx/Y4b4VxkDEFVwoQ49zmoVVUF7Q+oZjFqHcq9WWdVLNBwwvAY1TVHgmg6inrE50szir8rx8aWooNkB+/dY+f8nL8rqr9AhGykbKJ29HadD2G0wTWHmfXSObt9UDVbAuUv3T8TvMceEwLvD/ciewdm/pDcKoKlxaZz+XfdkjHxRNXU9eMJ1B7JbWX+GrEHrM+kHlYoW3TAAr4fsdhvcHeott3dge6p0Wx6lTFRqhSqhUUZqD2qEzGZk/4vxB4b0woRYqAIHMkKRuW6o1Z+fA5/nmL212nJjGFZChbT40sszlCKZQbW95zJi2+gf7zIAXVbxiZCIO0YBWi9/svExVl6q5qJsxx33pHbcVYdFChkVMgJEh9WnEwED3whk+CMqVokvtSWlcqcmmrjqdTVgC4R/n3TfkrMtORgKtGjGN84x3J+BQLYI26zvXh72tMo9Tq3aNVeQ+8Z7E37/0cV0AnBk7dQxIBRfN07egWhC90ASL0HK/IZeS1Zw7/Noi/KePjHlUGj7M/AQVRRj3BjQR5Qu+0yOaOoJLt+wDXTYz1/Ba1FN9gE4zR1Ze74BKdfA5OBQOisxf2iyn4wgw65e6ohnjs+Hz43aMQpiLkHJyaMsV3O3PA58m74VElWSrSkIZqZJgAD68efxpn+m8u1VGpzGv4+YsZeASm6pEz0cYiF9C4M6jiAUvdJP0JvESe/dLS8dscp3dYd8Gas8SqqSHZiOgevmgxXL+ERjXsYZH4gnLtgD+fNSB4A12ly2AS9gVtuSBhk1YR6pzh
 bh2zYzcD
 s2VRJU1WAbkdU77SNKMcFb/2eS8HAeqGrb21oDai//s/W9xMdvzwKwgcidTXJRKb8BAlmsBt850kwBnzHMVm3ggucn23S2VzjgfGvKDxuHPum2qWfPIFSiLIth7aVJgxXUvCl/7a7RAY+syxgzclSTEBEBs/yeSA1vwHR3OG1DgM3ank3d3AQDS3v7h8EFGkd530b06804sdbJloYKP75T8I6Bj/+zU73aYud14VpsZXE2dCJhy0QB+QxC+eF666JtD39XAHBlZp0IOzmPqpRCzlAlJN/LpXb6cXiTGbY0djPKo49EYgiYjTZ1Oe8q5WyfVY2L/WfMVZy3VvOxWwrYliqzMGopylrnVZwqdzQKtmNFE63XYtgLfgs8GOvKjLk7SqTX6R5Pe+EijJ+XXHW3ehHZ2PHopu5/2n0MG9CZAxNJpBCQ1n3r7iPcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 10:24 PM, Sarthak Sharma wrote:
> Hi David and Mark!
> 
> On 7/21/26 8:24 PM, David Hildenbrand (Arm) wrote:
>> On 7/21/26 15:48, Mark Brown wrote:
>>> On Tue, Jul 21, 2026 at 03:39:09PM +0200, David Hildenbrand (Arm) wrote:
>>>> On 7/16/26 14:32, Sarthak Sharma wrote:
>>>
>>>>>  	fd = open(path, O_RDONLY);
>>>>> -	if (fd == -1)
>>>>> -		return 0;
>>>>> +	if (fd == -1) {
>>>>> +		int err = errno;
>>>>> +
>>>>> +		printf("# %s: %s (%d)\n", path, strerror(err), err);
>>>
>>>> Shouldn't we be using
>>>
>>>> ksft_print_msg()
>>>
>>>> That does the magic "# " for us.
>>>
>>> Or ksft_perror().
>>
>>
>> Right, and if we want to move this to tools/lib/mm later, maybe we can just not
>> print anything and instead only return expressive errnos.
>>
> 
> Yes, we are not using ksft_* prints here because these functions move to
> tools/lib/mm later in the series.
> 
> Printing errors from the helpers was suggested by Mike [1]. I also think
> this is useful since the diagnostic handling stays at one place, instead
> of duplicating it in every caller.

This is a common pitfall. In fact, the lower ("leaf") routines, *especially*
library-like functions that are called by disparate callers, should be
usually be silent. 

That's because printing is a policy choice, and libraries must refrain
from imposing that policy onto their callers.

Higher up the call stack, the code has more context, and is able to
make more informed choices about whether or not to print something.
And when or if they do print, they may include some of that extra
context, and so you can now see that the printing code is potentially
different at each call site, and now you haven't actually saved any
duplication after all by trying to centralize it.> 
> If we want helpers to be silent, I can change them to return errors and
> let the callers handle the diagnostics. Please let me know how I should
> proceed here.
> 
> [1]
> https://lore.kernel.org/all/178048086818.472368.16811711474077698399.b4-review@b4/

thanks,
-- 
John Hubbard


