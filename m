Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EEEC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB176B00F7; Thu,  2 Jul 2026 20:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA28C6B00FC; Thu,  2 Jul 2026 20:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8266B00FD; Thu,  2 Jul 2026 20:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 831056B00F7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 750C5140210
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:34:07 +0000 (UTC)
X-FDA: 84944534934.15.A2ECA52
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011025.outbound.protection.outlook.com [52.101.62.25])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D9538000E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:34:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jJRNH/55";
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783013644;
	b=xXiP8/LP50Lxjp64v92IAfoiLn5cIiK8Fd4oZcCteWKOF59NXCIQTTxpBLI6UtGu+6cOLv
	6BjnfX0uBbF78ULUOOOHQyN6jZPJyqJOps2CAk6zKTuyd2DYBTHBHfybFjAT2ywuCLEsEZ
	BBfQiRZr4zpgU1JQrb06nmskPjRpV4Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AyU8jgp8DFO+4/4o5t0h2KqM9k83CiQMli6/a7lZNzQ=;
	b=IIq0iPPgeKXrIe5rmgvgJ4mhIT4fS4Cgv/0MqQHPPZ8YlqPxTY4NY9MmFa+xSOOxVVFCXP
	qGnk0agOK+lx0kIFc4ecoAX6dee54JVN5d7jhRFyv770qPERlyf5rDhPooX5aFeYTA3E+A
	a8A6wjnmrN9QW+0c8OZgaBg0Hzpct2k=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jJRNH/55";
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4UOC1+nAQ2tDST6ohAm/8DDs7mWrrRaAHT6uqI5xoxytjeyPL7TXB828AwMQd2NuCqty6eOUNrIYEAw9tvZbxouqnJOdnytUNgRrGvN3qonWC+gZutUU3VgPUeh4knkUELcM5DFx0sgDpxDKyneaOpcnTfj7GL8k3/dn4l3E5Zvk3g7V3AO+6jieacD1g6kx9Fsdvp/K5KI/WVH9ZWvVf6PaB/TeuQO20L3Lx98ywIgIiNs6KfIM9w2ZK3u3D957ObPTaKxZHKnvPSVW4paBa3tvB21RKp8MuaUu513mO2jbUGPqA0B1MyAcugEsamUE2v0m0bMrAw7yYZPNt2aKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyU8jgp8DFO+4/4o5t0h2KqM9k83CiQMli6/a7lZNzQ=;
 b=cnDeJZT1amSqZN7JO6XewzhxjwXNpczKlJ9gMCoPsgyhXLG+tEh16hFHeR3eRupOg5jIKXismNFBNa6y/FkQLspaNvcrexDrgUgXJZsW9xajGnKjmxgB6llu02GT9IvAl5Ct4D/nM40HTy7rA24vEo9qQE8kq0vY0pj3vyImnVQw/k2HsB99nrQjML6jrlpaPmRBev8ju/fPEBPNVJrtMsd4vOdOkwOvUMk4R9XJANikZZuRReEHU800W65SDMeCRW4iVQgQQDqupaieSEOr9NeRMREHvTkitVrWEOBq/EzRunA5f1hP/a36O6pYKD3QqNAkhA/55xAb7RgenBoGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyU8jgp8DFO+4/4o5t0h2KqM9k83CiQMli6/a7lZNzQ=;
 b=jJRNH/55LDBgsayi3lwwO09PSdNw5t0K+44PXnHL+tmeDMCGEe2UstObTB86SZUjQUA4GozG/vegp8VUQgxevMPiUOPBBlp/OeBT5h71+v8G7koRBPhETWD8j0+RJNqP6v5DWBvnWWHOJKZHikK0fOZSaH2Wvv6E3aOJC3lUhFrA/1RZMG5uMvM+w9n5EAFQHSPycbTKjkoC9b9B+qC43mmX73cNuV3U6IyFdtfq2Bn1iD0EE8P50IHayhkrGjOcFDZAUqGycH2WcxJN4yjj0XPn8NXUnoiQv+QmLgAKh+N1y04HfznJlPfxfLSe+cLU1ntdFRPaLmZWvJjNvk451g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9395.namprd12.prod.outlook.com (2603:10b6:610:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 17:33:46 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Thu, 2 Jul 2026
 17:33:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Jul 2026 13:33:44 -0400
Message-Id: <DJO9KV3KOPWY.3ESKX5RFMW2M0@nvidia.com>
Subject: Re: [PATCH 2/2] mm/migrate: exclude hugetlb folios from
 MTHP_STAT_NR_ANON accounting
Cc: <ljs@kernel.org>, <willy@infradead.org>, "Oscar Salvador"
 <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>,
 "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>
To: "Nico Pache" <npache@redhat.com>, "Barry Song" <baohua@kernel.org>,
 "David Hildenbrand" <david@kernel.org>, <linux-cxl@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260702172548.37075-1-npache@redhat.com>
 <20260702172548.37075-3-npache@redhat.com>
In-Reply-To: <20260702172548.37075-3-npache@redhat.com>
X-ClientProxiedBy: DS1PR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:8:23e::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9395:EE_
X-MS-Office365-Filtering-Correlation-Id: f2ccbd98-b559-49d8-7071-08ded86011e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|11063799006|4143699003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	DiLI6HT6T6ih440n4QIWA+CpbUyyeht5utNTackNKjoT/MNZaL3I9Z+MObwo6RW7GiKJaqb1ly2i7E/kPmrRV/Y3uBA+69IgbCRpQyCmc3Jo545aoPYShaLTm7x3cfJRqmHOvQqIvReSAuRomr6i1jskhxak8Q93IDgFNnkPU12I4qtxXwYyU17BxSeILZFrcwRwbrK6Rl+9vBntAcDjx9pBdrwLZqu0g6DMXIjnF/n1bADvZar96v33NtQ5kaj1M4JaMR9bd8vSt56SuobVY+jIRm/0XO5S7ePpRdLCtySJLyunJgIXmAbcF0qb2RdFN8FczkSyGglqUiqIPJj5/alTAA84UGONBkMai8vetsLRf4mOR0B/NAfZ7r9f4Vo2+mPqqpxqmJZOUFXIXhLeJqkRr+U5YY6AYXmCLemA40Mdi0fC0cQVhJTg/qbcmD/Wxy/zOZn2u5TLIClf08K4DyNXh0DlTxPJm5bsc1FFhN9yRKt+l7ReRur0f0kkUdO6LDyH2pOhw3yES4RQir70RVCs8Il9HBGMHYd2yPOiB/bIPXGOl+gMlEZ9r2q7jB+CKf71XZ5+Z9TKOyDJkOSTW/w/c32SglWKfemfTFePYhDztIju9DU3lA1dll/M+I5DCjRqDdQ1CAAxFKT9li6lgDwJtuvh8MgDLip/oD5Y3gw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(11063799006)(4143699003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0d3MThORXI1aTROcm5BZko1Z25GM25rRmdsS2RyYVQzbWN5YzFlek10aHBz?=
 =?utf-8?B?UXdxbXR6emlaUFRNTm1LWVEyYUVVZGtpcWJIb1JVK2IrdWovNzBLdTdpRjRH?=
 =?utf-8?B?dEpEbUtqdkx3KzkxbU1ySkZtazgzUnRLaE5RUWxMVlkva0hvWVhOcjdPamdH?=
 =?utf-8?B?R2ZZMXhLYzJHTmZFRkJ0V0w1Uk4zL1lySnVxOXQyZmRYR0Z3TXRySHUrcXE1?=
 =?utf-8?B?UzUvUGlQUnZIMFEwdDFzWEhBUEpHaktYMU54czg4cUZ1TGVRZFYzU25xV3Ji?=
 =?utf-8?B?bUgvQlpyNTBlZ3hsa1Z6VkNla3ZoM2t5SlhwUEdRNEhJeHpIcUdreXBqWGdr?=
 =?utf-8?B?RnJkRlRHeUtWd05ucVhOM2txZjBuWTRDbmdkWEhoRWh2NFoxV1BkaFpRZ1RP?=
 =?utf-8?B?VWpQU1BTUU41M1JXNThlb3B6ZkxsUHVocURKMllxbEk4Q1JIbWJjU0dQTGVO?=
 =?utf-8?B?K2RjRVk2enlqdzJadUhHT2RyTWQ4SHNibDRBVGgxMXZmekpybERxZWFvaDBl?=
 =?utf-8?B?ZjBjSjI3Uzh0ZXE4QUtISUNUS1Nva2pUQTRuYlBITmZUY2JGVzlab0ZteG9B?=
 =?utf-8?B?WWl3aHBjeWZSemNpMkVEYXRPN0RiM2dOUThDTVVML1pNQmdxNkQzNGRCbzdF?=
 =?utf-8?B?WVNKVzZma0lpNHJ5bCtrS1FBdHBqQVovcmZ1Ym9wUHliWk03N1JDc21tMERE?=
 =?utf-8?B?c0E0eXdhcDRoWWlOQ2IwUzR5UkZINDlYcmFOTnJESHlEeFhNTXQ3dlNmNkIy?=
 =?utf-8?B?NWdRV3BxTlJvTnRSMGswdk10ZWYxTmZnMWduVWFDWVdSRFpmZTlTOUx3SDAy?=
 =?utf-8?B?bjExejRPT3Q4aVd1ZlhMd2tTUW9DOGlKeDNGcWVJUVZsMm5oeXdaOWVaTXhk?=
 =?utf-8?B?QjNkOE5Eek9LWUYzTjdBVXJxN2tQd2dBc1YwcGx5YjdzNytxYUJXZEt4a0ZG?=
 =?utf-8?B?MWMrRDhKZjNvTjZoaDFHaUxVY05INnZMYlRKZW5RMWlmenNDSFl2TExzZ04r?=
 =?utf-8?B?NlgvUmgrUkhPUy90anBpb1d0VVB0aDJoQzFYdDN2QTUvajlKRFBHQmtoMGNN?=
 =?utf-8?B?Q1JuNENvcXpJcWRjS2ROUWxlQjFEV0ZCVVhZT3dpMkJoZnRYVERYbkFOZFZO?=
 =?utf-8?B?Tm9zdWhTcUJOY0RKSVlkU0ljbVB4bTNVTHREcmcvMFZyK0hHQjRVSHV5NHEy?=
 =?utf-8?B?a0pzQU9kc2o3WnNONUo1WHJBZlF6aXZhTStqZGFBMVdUREFEd1owcTNEaDhh?=
 =?utf-8?B?VGRETjZ6Uyt6dVBCc0U1Ti9lWllVNkpqQU5ZdGxXZXVURVpVdjk5RGNOb2RS?=
 =?utf-8?B?WGt6azF5eFlJTFFGVlRUV3JmNDRLSndCSUxnVlhwbU1YM3BOcXJXS2dTRWxj?=
 =?utf-8?B?b3duMy9SWE5KamFxeDBNMDFMOUxzMDg1RFR0Ym96S3VoVm12VzdhUElBb0tG?=
 =?utf-8?B?MkNtN0Z1UHQ1MHNtSDQzb0t4SWdtZVZDRlQ4UTVrU0x2TkgxM0ExU2pXc2gy?=
 =?utf-8?B?ZDR5QUo1QWxPUTNqdnpoY3BsczYwejY1Y3lCRDlWRkQzMG5MdjNSQS8vZklB?=
 =?utf-8?B?TXpocmQ1NTk0NGpZcHJVaG5hRldtY0lsUzl0Yk10cjVWeUZ5MUJqU3htNEp1?=
 =?utf-8?B?N25IbEwwSGgxZmdPMVEwVFpEaGhIT2ZwczVKVlgrMUE3MGZvemZMWm9LeGtZ?=
 =?utf-8?B?blk4dllDMUEzTGJiNUliSkxqQjFqbkZJeS9CU21KWVFYdlRZSW83SEJyTHcr?=
 =?utf-8?B?OGx4RHRuU1JYdS9jMEtZa3JvazJBMnZnWUg5a0I5SCtpc2NyR20zRVRZL0dD?=
 =?utf-8?B?U3NZQ3dZYlpUSmhaMWM0Njh4MW9XekVNRjJGQ1pBRXE1VlYreklYdU00Mk4z?=
 =?utf-8?B?NFZXK0l1TFNNdmFlOTQ2WERlM3Y3VEtZejRmbEdWNnZVaHo1SE9zOGhuV200?=
 =?utf-8?B?NVBWVXlSbkJFbjFsbmhaV2lWSWo0L2VNRlNVN1VPRitFaFFNVFhwRm9HMUVz?=
 =?utf-8?B?SnUvdlZtbitBZlNjSjB5R3hPcmZmc2VhbCtNQXZwbER4Y1NvRVNOd3pWZGFT?=
 =?utf-8?B?TlV6TGxyNEFiWHU0enRrRktyQlhEYllLN0plNFFndzYydlBBRHc5WW1PdkF0?=
 =?utf-8?B?NnlaQmt2ajR0dUdtd0s3UWFYejMxZEFqMUlic3ZpRkJqZkVIam1XZkIvRW5m?=
 =?utf-8?B?RmNDZ3RYekRRNHRkMjdsT29pOVdUSXB6YkFmcWZBWFlsQSs1OUk1T2lKN1lL?=
 =?utf-8?B?OWJQUUxLS1pqK2hoY2t2UjdKUUc2WmRua3RKaWVPM0ZYK2RBQWEwZW9Na3c4?=
 =?utf-8?Q?FdXj/duPskIz9YI4LP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ccbd98-b559-49d8-7071-08ded86011e4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 17:33:46.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MknQ9mebtchH99RsfSvdgppzTFSK8Ar9JZG9jbJNOV87DqpZtbrDmuS/899nuf87
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9395
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D9538000E
X-Stat-Signature: myyqgymo74131qtjiryjec9jayu7kt37
X-HE-Tag: 1783013644-299788
X-HE-Meta: U2FsdGVkX1/cXlVauP1E1ajnC4zppC5LSCmeStCvBC24y1bKfK+bqP51YjNUfc78Fdg9VVqhY6+nXLCl4l5pbP53q8/QjsNZbfNMUWNHBNitgqh+3rvW+QBL+QAGOHbbkIS768LjuQYu5q3OPbtT1oHHvVe2/3rvBMlXYOXWyIVG9HGFNDFBsOsSSgRPYJ81G9jkjKnUgSLBG9SNxu3HkNEnTep+C99QvYkTnp+KDkAw49kC5Y+bvSKCR9EAStDyzSwoSyJ565HC6sB1W/K0PHsO7W1WYq0eYXjxLWEyCj+tSAt5a3CoxiJn6EJzD1li1BzhBN7p4lRrWDEo6XgVvdb3ToAKs9yW2SMGbo72nfNMRFii4nWYdacVRSbsIlkwa8Di5WiXuB6AS0jvNNGDOBozi1iic16p1OAIUkWCnFYlnoLRMc0uggInCWqeiS9+oH+FDdFNuRaHojcSfQG6n7bZIgx3Am5AIxfjQdl7g2/+IJIAX9ewk+xvTHFSul1qgA3DSXTKtBLClXgzDWVCeRo7T8KEXg//NnXg9ozL2BSS7HPU4aKXRSnrqHFlPeBqM4UmFF5Jpz31jVuLjGPU0izyGyrtjuQGPhVMgeIdQypeQsU5xuABOvv7KUj3Aap9uf8LL/I9n+mkB4VydpECuSdqwduv2G2A78I6380iOv7vOnCrTa2E7jaR7OpvJ3K00V4dEtlyIsGadNXC/4ppYLubwt547hlm8DPxsMDNPUcser7EX0p9ugrIu58cU83PjpGK8LhJlrZSUAMncJXiLEfL8u4uBUU5+mP4IO76CyKkig4mEO3Cosr3d+pmJM4YpZrmg/Zk09v6S4/3Coc4maATT3V80LMvlNGRPuvVj0vKKxAElGcC3eHaDYpVbV5Jw8ZYIHRNDkqbKN14LtMeAbJLmU8AapJ+CDXxgScyh0RsiQILlgknRVAUfIW6RWFe6RLeDOpZibLoD0KgTk3
 y1QkpKLY
 dlNqxY3hEKAxSag8Y5PvEkI3kS1mKcbT1KDTyTD16itn0QUzAPPchtWn/eSOyYw75BtgLdPBj+phQesPg9k+yhgfgLSYz/t12GdbzOXvzlJgd9P4YtCIhx+JxF+Ko+lLS8tnpZvltAxmCThgtnnjGucwfDiQAylfGjKaTEz7sHxxJQQQ6kpsauynuY2ZNX3P2/fxcKRNwOpR+pdTJW0B2XZckYqanEsPtw6tl6VXvkgPo1FBWYLDxagXIn788ek31TtNTj3pMUSL972xCammF3PSLFd4oysExYAxLUbIwwbhfCA8uktU3j3b9c9KmppjSUHx8ZuKrR7AbU+WAcESz1p/Q8q4JFc7wItFm1tsc21tgDVaZyErz99LtDquMS6DBF/M7Ru7/RN4noaXeEAMkq1rUg0+rNgkoZIc0/YJ+CZgEbxPkmbC2FnjGgY1guCobV4u6THkT6a3YabW5ciTOIhBjrU40f/rrFDG6YrZgym6MlpQ3OzweA05SRxMEaF7mo1WzW4XjJtRv7snGvkTY/7UcZuHuB3dFh7o3NVrylJW4udrTewA/kzaKT2chhjzKJjBc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 2, 2026 at 1:25 PM EDT, Nico Pache wrote:
> __folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the
> destination folio when `folio_test_anon(folio) && folio_test_large(folio)=
`
> is true. However, hugetlb folios satisfy both conditions despite having a
> completely separate accounting system; they use hugetlb_add_anon_rmap()
> which does not touch mTHP stats, and their free path also bypasses the
> mTHP decrement in __free_pages_prepare().
>
> This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb
> migration without a corresponding decrement, permanently inflating the
> nr_anon counter.
>
> Add a !folio_test_hugetlb() check to both places in
> __folio_migrate_mapping() so that only actual mTHP folios are counted.
>
> Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
> Co-developed-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/migrate.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


