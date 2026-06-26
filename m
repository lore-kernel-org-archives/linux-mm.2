Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D895C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4848F6B00AC; Fri, 26 Jun 2026 14:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B756B00B0; Fri, 26 Jun 2026 14:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B6A6B00B2; Fri, 26 Jun 2026 14:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0672D6B00AC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:58:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94E98120576
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:58:36 +0000 (UTC)
X-FDA: 84922975032.07.4464EE9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	by imf02.hostedemail.com (Postfix) with ESMTP id CBF3F80002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:58:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iwcxAtgV;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782500313;
	b=wL3zZaUpJ4ZtBJerLnGxI3rN1XMzUbmCJwTJWfpcjuc1LUuxhrp7UnXj4NxE4siNKXnEXZ
	iqbOMARBgYxlLXSHanqGmLfupoeDywwAeh14IrviIvVCuUWtwkr6EcLbBXp6ptnf+xbtOE
	6GjkMQbUqy8WT5iGWF2UUFEszJ6taLQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+SD3Gax5r9j5ImwGmopmZl+7ZNi++BXBkEfqcl9un4=;
	b=yQUthftdL/Ts28oxVYS8tAm5YEPCGq/onR0MOqj/ek7U5Lc4ChkXOYWR+N56h5wOsIZADy
	bMafvgmyweEH22wMS66IYMcv2kIWnJtrs+JzMgJHDFdNAAUWCIWv+WttfODQjWy4ycXlby
	mu5fON5s4Y+zzLhnEn4k3VXjZ+Oa3uo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iwcxAtgV;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x8hy4lvDTnREi255f13l/MrSzjW7MuXV+NrZKY8Fqfx7TKvW7SwehO+5tYYRkxzUeJsXeHB6uUpoIcWLebPfSRPfr2Ya8kh+UNVyV/vT1VDzz5+KOGnmuJIB035pgfbhq6PAS+m5GmlqYtlKjcTMKjwU0AmBgYGAZp8Upghf6lfbOel/kjWhYNY5rUoFt5fOkfKwBIU+TgowdG6kub52psb69KAGc0/CKWbLIUpF94GzLY+QCcoQTD0YigKCcxv55DZ9a5+kfSNdz6HWtR4jvOPufYtaIKbvQpKH7ccdTkbj6xZ6sas2JGOeJ9lCV9W1RxVN2TvBoruMF9ocH7KojQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+SD3Gax5r9j5ImwGmopmZl+7ZNi++BXBkEfqcl9un4=;
 b=BVpLKR4QW5ctVVOzdYIc11cjboqinoYPmCh7CXg+kLl9YVYddh6tTsJXUTBKOtfgv6qqma70tFy2S1+es9KrOQDc8vtc8uLzaNjUrq7wb8JmPkho7C1xOoqPwCB5DT3k25iib8q1juGnOfAHh2LdNCyNA+YGX7yJ5ky5CqYgFh3FsQoyUgydDAsfG5oKVq+YdscByqNHCCJjE1l1AZWWXYamUucBN12kvVfrilS7/ZsvbhCc0HnMdQm9i1MLIKHNRJ3JuQjOWxSKbSOBT+HJ4NwCx6jMVUKOthWMTOiEcuLzuQKgju+4eVp1pif34Ha3Yp4kgmwt0IK8SUrPsu2ayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+SD3Gax5r9j5ImwGmopmZl+7ZNi++BXBkEfqcl9un4=;
 b=iwcxAtgVgyvTGiZUe+mvOOT4Fo6O+do4mnQLNy/HBQ7rhtBCt2/mqVwMNjx5z2KqctPc9yos0t+C+/7nctzyFJWQvf/fUQgWx7GsrpjFYp5T+eTP7ANN6b+HShy1bh+xQDqJxQGqTH3MHP6hRaGOyk3IhaOnI/YHZz7aQb1GM/o4OQW1ms+6S4BzaEbMxhwonaVa4N3UzOMuNQ4aB8p7ywfXOPt8rBrj2nGBHOzHppHkbeA+rgyBv7IJWRdyMTDdT2y4XxdxWQYTJqy1WNCFPl386dGhNMFGGxR9u/i00klO0LvClAZM1ksNbZUWiZibBIQQBHjq2SMXVnhDNChYag==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9109.namprd12.prod.outlook.com (2603:10b6:408:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 18:58:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:58:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:58:25 -0400
Message-Id: <DJJ7MFN3MFYT.1G7LHDONYZX26@nvidia.com>
Subject: Re: [PATCH 3/3] mm/migrate: use migrate_info field instead of
 private
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Jonathan Cameron"
 <jic23@kernel.org>
To: "Shivank Garg" <shivankg@amd.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
 <20260626-migrate-cleanups-prep-v1-3-a95933af7619@amd.com>
In-Reply-To: <20260626-migrate-cleanups-prep-v1-3-a95933af7619@amd.com>
X-ClientProxiedBy: BL1PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9109:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f17f75b-be13-44f3-85a1-08ded3b4e745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|18002099003|4143699003|22082099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	VDdAyLMMym/3hP/Hc0Z16yRULQw0S7+DTg17YLiLbxpO0UgZEafAS1O8zwJ2x0n3s10AnC8kMGGZaNSw+px/o8kkxRZuzEos+OrpOZH4mv0SqVOyZ1Qy5wGrCgdPeSq7A4H2ItVJd77UGCrOZnkpfL6RI0jKasgqCIzlfeA0HczrPra8M6C8gCzQwNW6sHBaB6XzUBX1Okk44CkBuRHalQTsigtbd7hRLH8pLqhlaUz53KlZHhnVqkXQcgrBzl/Nq6VSfLQOIp0iqihs+cl4yAsdgihv+HfL3kbw6Zz2uSDi09SuGQmbyjjbHwZWxKIynaPl11lXFiCrwDyX6q5umDKFAunU5uKXrWh473h5dNx/jAmRxmJ+3pnmncqB2Fk+kNCkNjebDAyu3fFUSTTDcgJUd5CRnkEjGc7KZ6BF1aq+SWoMUgoJh9Nxo1eFyqvXP/h31IngYOYEA5pa39Fq/Cy7tJDdIGG+8LX/NuLtAmz2PlxsnZZF3mB3fGTBojHxZYc+/kqoa5Vru3RU3HwTJqMC+KCPvxhsYCE2RJ+G0Fb7rQqor0YtxypS6Sjs53zP1uY2VZESgSG0zhMj8/frFp+9C0FCNwM3wYEvbHCu4qhNsfXYP1Yrzu5cpzPywgkVGRGBhnxyuol6BqIW3+zoRRrxsx4bAbTWYVvjDym7h3Mf6wj1zs5vwbPzSTnxmJ8czXQiBMIIkiu0mjsVndnSrA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(18002099003)(4143699003)(22082099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S09DcWZQZENJdHQ5ekFvVmZTV1N3UFZhZmdCVTVJNlpacXRxdTlhRUdtaktJ?=
 =?utf-8?B?YzRpeE92ZmU3QWdtTGg2UW5TQndHM1JwOGN0THYvU1RxOFdaYVNQeGEwKzBv?=
 =?utf-8?B?TXZ4OXJHTUt2MDZ1N3VMdCtMWUxoWXJaV0hDZWhML1NoUHlWWmFHeklEWkRY?=
 =?utf-8?B?amtHTFVJQ0tGM0d0TTdxQUg2ei9rTEZMVTRGRThvay82Z29Ub3REYktURTlL?=
 =?utf-8?B?RFgxbjlLa1RadC8wRDd6UnU5d1JialdVWmRITnlscFhYWVBzaFhrZW1HeFhm?=
 =?utf-8?B?Q21xMUFNT0RvM2tpeWZwcElrMVJjWFZkK3c1NnRYMUlmOGlFSE8rd3N0Vkty?=
 =?utf-8?B?d1o1azZTWDZJd0NMdE54THZsYzFrSlNMWmFoUFJxYnNMZWkxYWhzYUFiVVFn?=
 =?utf-8?B?aWFwRmdSWm92U3IwaGNOTndrTHkzTUs0U2xFTEovR2ZUV1VoNjJEWUFvSFdw?=
 =?utf-8?B?eHhIaXh5M0tLQS9ZRmFKQnVIYm9uRmZha01wM3VUbFhaQUlVVHFiOTFObUJn?=
 =?utf-8?B?YzZteHJ3TU5acno0RFhvSEgzaHlYYVMxeUUwM0FhNUJOSGRQMVdLYlBRRzll?=
 =?utf-8?B?OVlFNkpIMDF2c2IrT3drajR1WmQ0OUhpb1dURW1TdzlCek5sUEluYitLWHh3?=
 =?utf-8?B?UEc2dktzYWc1VlEvbERDVXNtaWNtdmFuRExRdUN3eFRBblFmY2laV3RHMFg5?=
 =?utf-8?B?SFdkM2QvcldQaElzRHFuQjhsUmFHbGxVWVBrZ1MwQVYxSEg0V0duemdSZ3lY?=
 =?utf-8?B?THppU0tBNmQwSGg3ZGhQNlNoQmpSWkNwbE1EOFoyb3FmaFBBcFJmdTFOMEQy?=
 =?utf-8?B?c1NxZlNJZkpTVTI3aXh3T3RHM0JEZFVTYWpQY0E1Wi9iL2dqZHJIcklkVVAv?=
 =?utf-8?B?RUhzSXZFQXdvSEtxR1JZRGh3bEg2WDBRczFqQXBlRlkrcUhyM2RkRTEvSTJh?=
 =?utf-8?B?OXpDWlY2T2JRV1BLTWxWUFMxSlEvZDZIK3JnUWdVVHRSWnJrTmxqM3ZEWXU1?=
 =?utf-8?B?RVp3UXhTbXB3WlVSbmNPampGSGJYNmRJb09LZjdOdm4veUpoZ3A0ZGpqa3Fr?=
 =?utf-8?B?YzlYRnVnTmJCWDNzdHBHVkFDQUlYd2NKSHBZUkx0ODJ6bGJOQXV4aXRUWjFJ?=
 =?utf-8?B?Zk8zalB3VXJLcTYwVmhva2cxVUgwME5pNU1semNBR0UzVERoN1RSMHQvUDUw?=
 =?utf-8?B?SlRHbUhqRFFRWDAxNXkxZW44TkRCWFRRUTNsM05hNXNWdlhtVXZVeWY2LzJU?=
 =?utf-8?B?Mjlob1BtdGR6Y3FSM01FWGRZSkpQSXdxdTE2K0JobXhsOWRZMk9kT0wwT3RF?=
 =?utf-8?B?dWxQYWxUQ3R6NEg0clNzeTVGSWV6N2hrMStGWDlKZVUvVk1TMjI3ZXVJbnBJ?=
 =?utf-8?B?SU80dDc3ZUxJbVkxOUxMeVZXNitpRFlEdUFtYjhJeTNBcnBVUTkvc2hXN1dp?=
 =?utf-8?B?bkEzcjRjNnVYSDc1MVE3RDZVV1dJR3djUE1ESVJpdzZiekdrVDFQaVl1UzNO?=
 =?utf-8?B?bnhsQWJkalZqNVFscGtLRThOeWJoSk51Z3Q2NTVZMzE2UFFlVzBJakRCWjlx?=
 =?utf-8?B?ZjhEWm54bHlRakRWNnAzNm50SndpTmxhY1ZEQzVTcy9PQlB6Y0w2NmFDTVdN?=
 =?utf-8?B?Z1MwR0VDSGh4emphYjdpdEExR2lCRmIzSlhpcTFSRjluRU5kK2NwaVJtZFNI?=
 =?utf-8?B?Mi9EblpjZVMwaURnWkdwYytGSjY0d2tOV0xoOE1wNm1SaVB5ejdYZDljanlw?=
 =?utf-8?B?TjVXUVd3b0t1VVJZMDlMbTAwb3c3YTYvK01JQjhTLzF1YXoxMTNtQ3VEU3Rx?=
 =?utf-8?B?ZFdySmJ3K1JyM20wallMU243WVl6SzV1c0ovbE1DTDhtdktrMkc3TFFXeEkx?=
 =?utf-8?B?RFJ0eG9oUUFRdFp6NDNqM1BGTmxQUkgzZk5PWGw2aFBBV3RYa1d5a0ZIQnZl?=
 =?utf-8?B?ejducnlsNUdFTGRZdHpSaUlJRSswUmFzV3RlMjBRQTEzdTVIR3Yxb2VNNjBx?=
 =?utf-8?B?c1dCdWJ4eWw4bWxZUzlaSTRmME5DSmwvbmtVeFBYamtHNUt2TGlwd2pwMnVo?=
 =?utf-8?B?Q0RDdXR1eURBeGVHNDlGenUxR3ZZL0hWRTZ0VzRwZlBvaVFJcTZucFB6M3BV?=
 =?utf-8?B?ZGlLdHp3cUFPVXhpbkhFanNyRlJoNEVOZ3N2VlljaHEzM1ZQZWYyVWpPVDZH?=
 =?utf-8?B?UUFLc09mZms5QzN0bTEwdllXVVVrNjdmaUxVeTdUN2IxVlFNdE8vcXN3bTho?=
 =?utf-8?B?QS9rY2VrWFNWR3hsVTM1R1N6WFdNeVVnQjhnSmF5TUk1SURaMXJIYVE0VHZR?=
 =?utf-8?Q?g/ViXJEr7TsLOzpKRN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f17f75b-be13-44f3-85a1-08ded3b4e745
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:58:26.1994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8lLkwSAl+4eWDjTIWTIIA45VeIkEhJZXg7vMZgkCnbE7LCCgkMdfmMMdqibS3hu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9109
X-Rspamd-Queue-Id: CBF3F80002
X-Stat-Signature: fw8wkndw6b1kdhihhh6oczfyuouixeqm
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782500313-974244
X-HE-Meta: U2FsdGVkX18IXe8U7lDWPwTozfCvtCsdfP0dodpHEpgjfqDvB5lcIyN9h5ZLWBKKviwUCcsN00X2xKyN1m9dgfNWW6hzDQwlQ+nbu4czIOkk2lZjnUBD/eUz6vgk1keT1nA7DbzPUm6dKuuggikXCqjkkUTTlW72snSPACSEW/51DX27d9rCA/IMAmudx9cmuYJ8xwCVM/oD+QOA3I8ndO4Wtub4mYJ9CIgqb/AMXK76EVLoALSmsYrBKAwdhw9/HeLMB2kqCa9YDAhmBU5HYLhlNWfBJmcTL09XTuKEXPaN1wLtAC1w9ysctcaAt1xL6BqryAqVqzMIH3gLrGAyMArDobqqlkKtarWHk1qrfpYHjWECVxLG8jV8NV6ZEwZaM3BSeL++5dLYDDGQMoBUEbb0hv2al/GsmJUXViqMTLt1RA0zYDbfYMZaHso6guPZpPwtzWcPOjHmOvXLAcIBAydZAE4iDT8+vbtGd7yCSe42U8KHP5SgCiusZNj4+n/EgehmtXTx0r0eV6Zr/QeulzGCc9QCfJkcNYm11M7+hesEY1MQP4N8opOmZdyBCWuJo0yauezEbgCEQS+i1fvw/3TbBGB3dhYQodHp/m8512uY2affj3awLx+VUKDfYJnL5to8GgtG3kRUihDEKU0LR5gA7IgiqKoR0zi0ZKjkBjC5698pmJlNX6YcoJqW+dSxgfFK2pRIpCCG4R5CiXLl/GIilQpYvCusF2j1atkFl7TByLfFRLaG5LuJbyux4POOahC1Z6pYXuZky4nVGW59rb9g7/6vx37XM4ytzQQ5HNtph6plU76lBE2F42Oya2pcJmDOvsCqeB7LMjgUaZSFU+f6bJrVcT+kq+GY2w1DqYzk4ZTxQxvdaaMrrlq3JKYU76lIJyVwWVHrZUGmgz1nrgedc0wZM+tLmt6QpskfaxHY+sHVYaSI57P0RjRbJ3pQWAAEsY2sA54yHBXTqUC
 aL3GO/QO
 4Rftl5TcrMcEXicwKhwkI7ajSiBy1IL/oYFCSwNNLJsPhXpNk3MAq69lnXyj/PVG0MIKp085JIUcE7k1PJeOsFsy6XYGrvsQspZZfMGL79CaXRn/oZ9mcQ32rSJiFdsvw3OUGUaNyjAZbHIj50zdEWfC1gxKliniq7E9wsTA/3s/xNagW3WIXu8+TxQs1tDcK0do/tFU1uLZAub2GM9IBbqmIuwutPXTgxILjkw/N70s8kLt4we/dc6A80SCcH+/2sChG/zXnF4A7PjC6h4iWa5nLXL5TFq5Larz5wA0yF/EKQSipRvRwQsSSQfK/wHQGSjJDK615Nb/zNHxHckrAwoWHA9PI5AXx3WzAD2OaJHOVLNQZVbPIl2+O8fdN/VMLaLiwf1yopgU6tJhovloZBRNCaGlqcw7vzD2YdTpkKMTrGh1V6+h0xLEHaGsSB4cpAD4hnoOWrfLDzUiVSEB3VAAo5l5tgq4WutqS1G2cvRGsfAdoQij3sqSiY9Bfen2CSGCx9bvwEeqNAcWDU1BmRedu70th2PPD5kqSXG7ta+lHzXiizrpRbE3S/5iFfo0IBt8wQQgcS5GtjYY3rdA0wyHOzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 26, 2026 at 5:37 AM EDT, Shivank Garg wrote:
> Add an unsigned long migrate_info member to the struct folio union and
> use it to store migration state (anon_vma pointer and FOLIO_WAS_*
> markers) instead of using folio->private. While at it, switch to bitwise
> OR.
>
> No functional change.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/mm_types.h |  1 +
>  mm/migrate.c             | 14 +++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
LGTM.
Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


