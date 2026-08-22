Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22962C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC526B0095; Sat, 22 Aug 2026 17:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E6B6B009B; Sat, 22 Aug 2026 17:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C578E6B009D; Sat, 22 Aug 2026 17:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9259A6B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:31:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 197BE1C09A1
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:31:51 +0000 (UTC)
X-FDA: 85130202822.19.759986C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by imf12.hostedemail.com (Postfix) with ESMTP id 072E64000A
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:31:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=M4oar9kE;
	spf=pass (imf12.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787434308;
	b=duyqXLgCgE3NyiDUmT4iiUhkjqNgoBv5rmZYHHVVB/da9qwjOp9jddrXkQevk4RKF7IfwH
	z3zM1X+vsn+vsQn0PWYzALYJ8e9x2sTnX14pTJWbNNs0d/yo+nQk/AygkubjlsIOm1ck1u
	9b2NPQPNSiol9Ikx5D1pL2v3UAxGtTI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=M4oar9kE;
	spf=pass (imf12.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787434308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVOhAXnUUVTH6kl3+1mrtCj0hOyaeWrzB6ZrXluHfrU=;
	b=nFdjklJrZDF1dyzjZ0w4LAn5SnaZsXDG9wYU0bLuAGPBrwnFrcsVLOnQoBbIZvj3gMu257
	EkU6cN1VigLmZXR/ltnJt2W8m+BRJEsGOeNp4rM+VjR8/9ISpZdkSo+08Lorg8QX115xXP
	3UJeyJG64J2QvnoY8RWuC7J9DbIkhN8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oclkiP56ujwyWFBTQG1ETbQupK/GnC+Md6C8xjuppPCPMN0oT9RL5k9O5PUYqvC241F/QIjCpBPbric1QS1RHLWS3foqiMRk/U4WGq2MN8EMcP5UjICkhR9PlhFfpPFgCa7XWMExQGbBWpL+N8FgzUnibTygNS9lCvR0QbRbGtZolxLLiOygtB2BYrocupPrz0AEPiDLFKGU00PJODZ8zBONW1BfUz6e/wE4oE7xvNI173m4HevX5B+RGMwxLgro3Ubdy29O28YNpsXPkZgEBzXUV0YutZ0f4Oslis+8hREvAsJqDNhHLmpte87ddGIdiTiI1uU8fMZ+O9zrhU9xzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVOhAXnUUVTH6kl3+1mrtCj0hOyaeWrzB6ZrXluHfrU=;
 b=roxR1xVe/qxEy0hlhboTcRwN1GhOu/jK1VjcQq4GGl6UGXWkYj6gMYpNy7YX8IPUEPM7O67k+zFO2se6PgQEf+ej6t8mxo9n4JtTYfMPRqo6A33UYF4GDjr69+OWDfxgwQ1bn0vEZeWTW9iYz+LFbCfQESmUpzEKn4cuznyYjoR3JmvJ/i4YliyPZjVzo9FkjLqZoami3h+1ihhKEAc9ama77VSLEiUNu4LWMSFLLGoMiaU0zLRARzagmKCZxk9vIqUymojpG4ydsvXCtLac34aNGw1tg2MeHgJ+7axInffAy4UaOTw74pWYI/zYWaC8/3lzk5j17VzMZFe/gATmmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVOhAXnUUVTH6kl3+1mrtCj0hOyaeWrzB6ZrXluHfrU=;
 b=M4oar9kEPYecHfGg28r9Arm8E+FTQ0yvtaj8UxxGnP5VCF1xB6fUKZvNbSAWWw+vAUwnvNPvH9UkzHXXL6nDrpKm/kCj9ls52X8bcsSinMhlBTP3NWnRAu5fI4EnzIPXQJjldU8+XZOnh51xCiFzF5lDdHrXrB6+ayklyeVrIhKdPuFkRSu1nyIfd4b3rKgHBoAYwt76ZkbfwtTkHwpPpoURR7kvQjGv3OjGY7C4IkZc3H5LjvQpf/AJhMRt1GfO/WdRq6+gZYwEcFX2EqEud7KVEARkXptoPvJcM/6KsvgzlFvZYnRNVddeLEio++hZmLAUV2u238h34xpoNS/Vdw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 PH7PR12MB8155.namprd12.prod.outlook.com (2603:10b6:510:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Sat, 22 Aug
 2026 21:31:44 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0339.010; Sat, 22 Aug 2026
 21:31:42 +0000
Message-ID: <42d8fc20-4ee6-4bed-b2b4-3f968bd29f5d@nvidia.com>
Date: Sat, 22 Aug 2026 14:31:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out of
 follow_page_pte()
To: Rik van Riel <riel@surriel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org
References: <20260811025157.1632867-1-riel@surriel.com>
 <20260811025157.1632867-4-riel@surriel.com>
 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
 <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
 <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
 <ab1661573257d7755d5a48e4f9165ff22febba29.camel@surriel.com>
 <fe9f0bb5-73e3-4509-951d-e529e37011fd@nvidia.com>
 <f86ca125a9b63cdab8edeb3c3b02a29141f18c1a.camel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <f86ca125a9b63cdab8edeb3c3b02a29141f18c1a.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::29) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|PH7PR12MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: 896ca489-9685-4334-597b-08df0094c253
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|23010399003|366016|1800799024|10067099003|11063799006|5023799004|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	E0CsIbX0tNyXMXNTY46GtiR0cMF5z/btESCin0K54CNlvJta9uEVUclmpBe8gBLNl5xQPF1H6l2eQVGx6LftqxyQtlPKeBnJzssIJ8sIiQZcZb4OWeAd/mL2X8fWEaAvmLx006OZbzcn6FkE1KuiCGEugPF2sc9GSB/gF8V4WrCyJ4MeD812b6/AQ/jplYAeOP1bcZIVf6VySaiPlS7dzwptmck5rsy2Xi3F/6swNCg+dhGGpmVp2DO4rub4EO4goI1iZZGnN6+iPEEmcfqByMbn19pwTd3vR1lQDI9sioJwa6GuU7ksA32YHvvBPPw5wuCHpEPTu0gK5TXKd66Q4vacTUmRbhB7CXZhxlcvutkvJ5xvb3xE5tn8MkFCHVEL8Ts54PBYa+2mNzJyC/C1MO/4QyI7L7LZGmAg+gByC6P+EHjnbWkooDdcyE26Rq01FC5HEMmOzm+wVjLcG0A6n76jWOh/GcwwHSTGkM/l9MK0U+MJYj1XwtPotpeVwpinkNw4aVAecydk3I2Ns4f1CkEN1t/Vl4vIk0uZ2l5UE4toRVvCEdUbxy+FzSW0M4nn6yTiupeAPlvlDEC0cRdZ/GC0ABljI1ml4zi7Tx2WXl25yqjp258oedQx3raLd24uWp5guHrZOfnWzBr7UVJrmlcxaf4oor0v7oIny3NW9KY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(23010399003)(366016)(1800799024)(10067099003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkJSdGU5Z28yMjc0SGtndWdQcTBoQ1RISGRLU2lxeExiQ3puM2VFV2lIVUxH?=
 =?utf-8?B?cXhlTzFXV1Z4OUhTUk5UaCtZbU1aRHR3dGNWeURycVhmdDk0b05TWndUZ3M0?=
 =?utf-8?B?RzQ1WGdVcVV0WVNpWm9pNk16WTNKYnJXVHc4R09iRmtqZEgyaEtsWWx3SkFM?=
 =?utf-8?B?QSs2cy9yeHhvbGNnWGN2TUo0am9EMUwwZEs5UzVLSlgyczVSVEljYTNIWHBH?=
 =?utf-8?B?ckMxb09LTnhwZFZuaTFOUG84RzlUTFhYQXpBOGNHUzE4ei9yYnhLbFpTN2RV?=
 =?utf-8?B?OEtHNFNXblNia1BkQ0k1eWlDaXFVVm5JWUUrWWIwMGU0cmZhSnR6MzhETkgx?=
 =?utf-8?B?WkQ4aFN1WjFPOHF6dFFlSlppMDJoemZQdDVtdXJ3N29xeEdaMzZwZzgzOTU3?=
 =?utf-8?B?c3c4K29aS0oxZnlOU2I5bXYwT0hyN0Y2azhOQVEvREJSYXI5dGx1MDBqN2hk?=
 =?utf-8?B?OHc5MlJwQWJOTUhHMlRaNDYzU2hUV09yY0lXZ1VocUhyZjg0VktuWXdDL0tn?=
 =?utf-8?B?NGxFV2tmWFluZHh3cnQzMlRnZmV1dmg1N0kxcy9Xdm1OcWRwbWZyQ0lXQ1cz?=
 =?utf-8?B?SGlYTU5IaUNRZWhhczI2MUpGb3dmMlVpL3RtYWMwandGclhKamU5ajNXOWFm?=
 =?utf-8?B?TGFIVWxMNk9xTGdSMFlsRFk3QkNYVC9ZYURJYTN3cG5mT3lMVUx5U09wWXk4?=
 =?utf-8?B?RVFsOU1sY2cvV01MK0RIVmdTMkF6VlBRZWJDd0k3S25sUTM0RHNjeEkzbG5j?=
 =?utf-8?B?QzBpc2J3elRCWlluMWNnT2l1ODYzd0ZkbDNsQW1iT3ZIV2dOWFJ4dzNjM2p0?=
 =?utf-8?B?dDlqN3R3RmtIQXJ6WTlWeU1pNkZVQmFhVlRNRWtxY0tQZUVWaFd5ZFVyWUJM?=
 =?utf-8?B?WFFtbzBtTDM3Q2hLeEVqZ0x4ekdhMmZBbjBtc3NsK0ovVGJqbVJ2eWF6TVhH?=
 =?utf-8?B?R29jK1gvQWxDSC9ESkhxMm0zZnllT0dSZGVIa1pZYllWYmlmVHA5L2xOekg5?=
 =?utf-8?B?SllITEJwaEYwWHpibXJBNHlnMWk4YWJlTlhYMDJ5SFVtVk9zb0luLzVEZk1r?=
 =?utf-8?B?WEdobXdCeXlpT3hQMkc1citVYmxKbWVKbjY3Q1NGMytyN0F0MllzeEg5ckpl?=
 =?utf-8?B?OERyVithYVlBUUgxUzhrTWNLWnpVa05LMC9PSjBPcEoyZTBHWkxOcHBycEVr?=
 =?utf-8?B?WGtZK3JXRG85alZuc3V1NThwaGxUY0dlK1dRMlRzQS9oOFgwQ3pwQm9lQ0xI?=
 =?utf-8?B?V0RtTWFWWDZXWUl0ekdkd0RQcFBtZkRRVmkvaWc0Z2ROeUpBZFNUeGV5bklx?=
 =?utf-8?B?bWNBakZubGQzNXlwS0YrMkxVWSthZ0VyTWhOaXArMFM5NmFLZy9uR0JUdUw5?=
 =?utf-8?B?MHF0UzBLd3Bydk1OdzhiNm1YcjJ3U1laYlZWeU5YUHZFcjQ4WXNIcm5tYVpX?=
 =?utf-8?B?ZFFQdEk4M2VENFVyRlBrR1AwZ3pqYWszRFo4eE94eXMzQ1NPVWk5UWlhbUlk?=
 =?utf-8?B?V1BLWFZTVitsd3oySVNYcW5PeEowbE1nWXBVcFVibUw3N214WUlRRU1CUDlK?=
 =?utf-8?B?NWsyb0xmS0hNbVZmS0t0TkRWOWR4YkZ2dW1ITTRZK3hsNnZweDBsVWFvSlR1?=
 =?utf-8?B?TDBhM3Z6ODlWY1FKNXJmakVSR2swbkNJVWloaXd5NHgyNktrRHdmL2d6NzRS?=
 =?utf-8?B?eGhJSmUxQzhqdnllMVQ5cFRiVzJZUTMzMHNsZVhNb2NqTHV6dmVrcVZxbWdQ?=
 =?utf-8?B?aDAwTEhsYW1WSzYvcjltaGx6SHV5YjhIZGxWb0Y0bTlpOGVITVE5cUtBeXBH?=
 =?utf-8?B?YVcxOU4ySVFlZEFWN0I2b2dnU204REJ5S3VPc1lNb3AwYlY3U2FhKzh6ekJE?=
 =?utf-8?B?Q2RwUU1TNGFxcUF1TVlBaGt6Tk1OY3l0Qy9vZ2N2anVKUjdOYWFJamlNQ3Mr?=
 =?utf-8?B?VVNabkFMd3h3bmJ2Q2k4aTZ2MlZXTGExa0p0UUJTcC9ZQ0dpTDl4RmFlQ081?=
 =?utf-8?B?Q2VoMmdMRFdpZk81RkpVRGw1L0RlbFdYbDNOT0tKM1FVN0MrRVQ2QUlaTzIv?=
 =?utf-8?B?cHFodFRBaldvc1ZxMUl1a0VhVFA3OUU5K016VjhwRldia1l5bzlwRElGaEZO?=
 =?utf-8?B?YTJrcTRqUnZWS2k3K0ZKeGV1S2ZndkZrSjNlYlo4dTRubkJ6QzA4c0RjQXJJ?=
 =?utf-8?B?S1FYNi8wa0xuT0pVN2FzNWZEdnNQcmMzWTZyTFRBNTFUMUhUY2tLWUh6WElG?=
 =?utf-8?B?TGNEZXpLUmVqbmpyeTJMdnRFTHBidjFqOW00SmYvTGRSUnp3ZkgxNVV5bUdo?=
 =?utf-8?B?MkRZY3RwcjU1dFVXcnk1MlJLdVVIUEd1YkRLdXdaaVRtOW9TMFJ3dTk1ZFBS?=
 =?utf-8?Q?TKD43l7AXPTexXNY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896ca489-9685-4334-597b-08df0094c253
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2026 21:31:42.7004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFoKJ5sI48HVlWUbm1wDja5qXpWKWDijvdfCnGPfkY5nzsEXMicPSWk9W15owQRS1TSo4gyv4dGSjBFlrILW1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8155
X-Rspamd-Queue-Id: 072E64000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: uzphqg61gb8pwatkpuesg8jrie8aofih
X-HE-Tag: 1787434307-815477
X-HE-Meta: U2FsdGVkX1818rI+qFEfsMtFKyvmkqLHpwW1dJmJKgr2d/Vt6hDhY7439xGQg8z9u+qZhk3KVhzNINpSbZuAmiQGVTM00clZkcbFXblFJuoSVUwf9k8XD1clXUkG4AFcvFUX3mo7/bG4AX0FLtG9KmJDeFPnHIGJzj4scvaP5oyVtBQI46D3zYmcv3yzciGNRskvAMRYKEGQmsrKNvzYFxbqWJ7GDF+KX/Lezws5aJXo2LkBPVxl84R3UkjJMONZjiTD0vy5cmz/MCiHLWkn0ab/1CUCj9Oy7UuGH1EHB2n+4m+8c6jNqI+QM1yQHVw6VDWejBV8vxdAip/iaannVWmf2Hx3aKe/JPcAKMpo7ybHVl5BqtT7wjLcjrLMBSevZAn/nd2CoKyTcbqEuAumqwxVGTz5m/ELN6E4zoOer9sN9TBI7uOywIqn5yfhAqtRK8Wq9IPQAeUDyyPYOAh3Ly09lxYOqwNu2VrjJzZwIpfMQPwfabUvvfH3s1h1yJcdJ7SwSqrS4y49KdDwQxjbWbRz8/P5BAn9SZclpZTlOpNqHEF1X+qp7QKTjr9PtK0A81jns1s/hY3+v425j+SOQEWLU/y8drgdqvEJR9wNCWI0kcC1TC/Czq/fSnxfTXE7MKJVLzL2sra1JM/uQAqpdpRc4rso+M/GiRKZqSm/FAX7roTJ9n5ibpHDFN2GucJUpKGkGpL3u6lPyeyzq+wS1YpwoCIdGghv4aeyspLxL33S8KLFxbZywimY/Oijl2q6RKVACM9JR9TORnHNM5WarYQFvTa5q9A02kAhpS+sDS7/JWMDMJWTYC64C1cWHYLXmRt0TGdnWamTFqZUBY2eZSZcVNyuhRyNnjIIMxe0a8vTDcTC2eO27IF9IyUD7YHp+XqpiUySiylZf2kei1QqC2rhYK6yAbqDCs0fggboZ/1GLLWRJ3IDXXMza9tQ+DJ4iDAVCkAep2G2ph7jaG1
 gDs35kfm
 pckXYgxgZs8IJjgVwPzD9KegjZk3BS+9TNGXNR6ieWsQ+WuleGhEBMPAHeWO5MIsCplKVii4hnZMW+DxQIzIJhN/ug0Wh4WGIAY2zv1OfvORyFW2fr5BO3jYedP+LtuAbwNqAOkKjlKGWhm7wRDTxA3FQXt2AviTo9VFhFOxYFNl80LfcNBwuHXs6wGYooFBX1UYhHfzjlh+dXgAfjf93mznZQkyjrs/wICCXyFjkxCHp8U9oARwMfJses/QOYRFIs4titYFZCFJYPvstYw7an7UH70RnM1AEm/jm3nugMpYS9e4OJI/BVaUavpfA9DVMxu2dD6IXETk8UzdZX7QUynTzmv4XErcSvHLIWBg/KIDamKvMg8VxRGCYIRzMBS7CIwGR6DS2UPqkmf+FfWABLYJx1zZRYLTrlZg5gckF4dJeobT+daiUDXbgtRvoLa/3bCQjZyGb0tnAG20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/26 6:20 AM, Rik van Riel wrote:
> On Fri, 2026-08-21 at 15:04 -0700, John Hubbard wrote:
>>
>> You have delved too deep, and now uncovered something that's been
>> a problem for the whole time. :)
>>
>> Specifically, "no, GUP should not be setting folios nor pages
>> dirty", because that generally needs to be done as part of a
>> filesystem
>> coordinated set of steps. If the page is dirty, and the filesystem
>> didn't expect it to be, that leads to problems.
>>
>> This is part of the big, remaining set of required fixes, that
>> launched the creation of pin_user_pages*() and related. Connecting
>> up the filesystems properly is yet to be done. And until then, this
>> is a real defect.
>>
> Not just filesystems.
> 
> I found about two dozen places where drivers
> fail to mark a page dirty after writing to
> it, after obtaining the page from GUP.
> 

Yes, I agree about that problem, but it's not the only one. It turns
out that the only thing worse than failing to mark a page dirty is
marking it dirty without coordinating with the filesystem.

> I'll get out patches for that, unless there's
> some reason I shouldn't.
> 

Well...on a file-backed page, marking it dirty is the *last* step of
a sequence, and a driver cannot run the earlier steps.

ext4_page_mkwrite() into ext4_block_page_mkwrite() runs it in this
order:

	sb_start_pagefault(inode->i_sb);	/* freeze protection */
	file_update_time(vma->vm_file);
	filemap_invalidate_lock_shared(mapping);	/* truncate */
	ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, credits);
	ext4_block_write_begin(handle, folio, 0, len, get_block);
	folio_mark_dirty(folio);
	ext4_journal_stop(handle);
	folio_wait_stable(folio);

A set_page_dirty() at the driver's write site is that
folio_mark_dirty(), but with none of the preparation above it.

ext4 documents this case already, in ext4_journalled_dirty_folio() on
the data=journal path:

  * ... except for the case when someone
  * had the page pinned and dirtied the page through this pin (e.g. by doing
  * direct IO to it). In that case we'd need to attach buffers here to the
  * transaction but we cannot due to lock ordering.

Its workaround is folio_set_checked(), which defers the real work to
ext4_writepages(). If ext4 can't do the preparation from inside the
dirty call, a driver can't either.

So for a file-backed page there's nothing the driver can add. What's
missing is a way for the filesystem to be told before the device
writes, and to revoke the pin when it needs to, which is where the
lease proposals come in. None of that exists today.

And yes, unpin_user_pages_dirty_lock() is in the same awkward mess.

thanks,
-- 
John Hubbard


