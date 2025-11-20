Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B595CF64B0
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC836B0026; Wed, 19 Nov 2025 23:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4276B0027; Wed, 19 Nov 2025 23:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2B16B0029; Wed, 19 Nov 2025 23:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31F076B0026
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:28:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBDD1140760
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:28:45 +0000 (UTC)
X-FDA: 84129704610.18.CE6E302
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012012.outbound.protection.outlook.com [52.101.53.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0688414000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:28:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B5axb8rX;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763612923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfKfWYUYVqselmWHWkrmooGB4QAjt6gWIB68LOYex9g=;
	b=unUMFIwM9Ntn9wgHTPzAoDrpToY2TXeBFi8VZl5ncMQcltbETNVYmKKH/6d6COIb+d1K8v
	/F8nIZ507j24JKXwGYLNJnm7hCMyrhqVu+dlga0nY5wSW8dEUUMROykR8KD+A0V6pxyXZY
	MY52SaKau8V2p+NFUQt8qmJvyq7QO7E=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B5axb8rX;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763612923; a=rsa-sha256;
	cv=pass;
	b=BkuXY5+PT1PhZogY4yv5zIia1b1ZDV0dR6W4oIzkFlSooWFjjVSkNDQbufjM+XXTUEMM5Z
	WsI+MOdhRqILOeB6ScIZdYI+SAYjstVZgxXTKFAqmVOC1CyxNjc5BCIBupfzfb+ytgusae
	09KtJtXq72n2MhQNWoragNyQZqBVnuc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o5svhwAO2LOXaXGKwZ2KiThI5oMEmeKhhed84yLqH59LFHv38OxuK6opppz63QN9HiVs7p10kjmzgPwxadHwSODwFTrb0hG7K8bsmD/OkxRpp0lVFVjPOe2jY/zVs7khOx2aDYnf5NSxXY6uRX5idFoVdud58FwbVnUmsYs6WEuF2CnWogfoJer8q6AGtx875dqmFOQBNXOYbiNjo2H+PuET1a0JYjc6gmQqy+UKSVBs62R0oTW6SrhwEEQ8T2HZ9uuaqdmyi1xOEijzsQVYWL8rGJereYLcOIO1VlOqGOhDYECo20SyBTjuvRzLgLVJlNvX9tj/UbPi0BpNSZDdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfKfWYUYVqselmWHWkrmooGB4QAjt6gWIB68LOYex9g=;
 b=IHK5XeV9XrP6RhpvdeWenwcHJzVDiibWB6V291KKFWXiJ415z5Wv/8bgponWLK4f5BcXX+qNE8O52isNVqJxX07c0zyZt/F/jlgffh6IUvujU8mMS2k34/ScZx+K9JssHdNWgpvkHzs4d4INdxm5/1m5ZQg//hT52CiVkQ+POd+30/llgaCPKMxWq4J43KlZQPDhLBf324pmJOSeJivtknncMj38dWzzuTllIhojRN9S3WRWCmxeuTocLIummXcWHnxTnsoPyWTOuf88KeZDSahyb+myE0YuC7Bi76BSkLPWEtsvsgiIfDkff7ivsqNETbPky6fqdVWN08oplDyuSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfKfWYUYVqselmWHWkrmooGB4QAjt6gWIB68LOYex9g=;
 b=B5axb8rXom+EVK1Viiy1u7trDQLIy3yNtDEL6mQpg9E8dcJ82OKdpvoohygxy372zwBwbPzPvnHqgsRp9osuXX9WL5EDvxN+/0tmSsQL24niG3gKnU4izYN77Wx2+hvlCFx+tby45b/cL6m7on+JrzBNlhjnnf0E0QKw3smaCjWrHVlGke+WIROo9mTUtq+YGCmPoD2hRy3ZitRkDlAi8pGPrfWi9/hYbYF/WGc5vZqCaVSo4bOUR+fsa3oe4WbHa+dM0aMFTh2GO2nlv60OOOF2kgDaPxJLVljmsRtOrQNQa7dL0jf6WjF0yFovDEzpTZJZJawo5xKSbSn4ZtdgBQ==
Received: from SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7)
 by IA0PR12MB7774.namprd12.prod.outlook.com (2603:10b6:208:430::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 04:28:40 +0000
Received: from SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::ea7d:e30d:fd74:c9e2]) by SA1PR12MB7272.namprd12.prod.outlook.com
 ([fe80::ea7d:e30d:fd74:c9e2%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:28:40 +0000
Message-ID: <010f0f19-8b87-4537-8c0b-bc8f9263aab4@nvidia.com>
Date: Thu, 20 Nov 2025 15:28:33 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251120035953.1115736-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::16) To SA1PR12MB7272.namprd12.prod.outlook.com
 (2603:10b6:806:2b6::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB7272:EE_|IA0PR12MB7774:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b08748-f05f-495a-ef3f-08de27ed47ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDdNRmo2Y1BYMWprRXM5MVV2MkRKN1hrR2cyYVF2OGR4UkZka3BHd3Fwa1h6?=
 =?utf-8?B?K1J0YUNra2dPS3BkZnBHMjR2ZlJNdk1pQWJ6MWRPQ05QNmlqVDNDeW9icXVy?=
 =?utf-8?B?Z3dxVUhvQWlYb25mWHhmQXZscmo4czIxaVFQTHR1SlZVdHZBOVM0aWF0L2s1?=
 =?utf-8?B?c2pYbXVXNk9Pb2VjQ3U1REgvcG5pcFVxSlFhL0w1M3l0dlpRbUJxRElHTUxY?=
 =?utf-8?B?RWR6NmpObzRkcUdxZG9vZi9MTnBKSE5MNHNDTG83cThUVnJoWFNtM1ZOeGw0?=
 =?utf-8?B?emdWKzU3Q3JIQlFaUS9ocG0wMDYyVFkwdHhTUTQ3U0NWbkg3NWRBeG5iMWFK?=
 =?utf-8?B?elhoeHdXOHkzcW54ckRqR21ZbDhXb25tYjZrY0xVd0Q3NlVYV2wzcFVxU2Ey?=
 =?utf-8?B?dm5DbmVpMmtPWkJNOTR3STBaWllaVXNpRlVCTEo4bFlDQ3RicEJNTGlMM2pL?=
 =?utf-8?B?RGNGbTVVYWFRMExRa1ppVUFORjQyaTF6cjJZWWQ0MmhLUFFUaFkycUJzRVNP?=
 =?utf-8?B?Qm9LZy9WYjh3ZFcxSDlkZ3Z5WmZmeWRTRVEwM29Yc2lzV3lJTWNuT0VFcmV2?=
 =?utf-8?B?THhwWkZ1ZEo1TFN6SUVZUm9oTGhsZk44WmlJK3h0SUxCU0VySHh1NmIrbUxx?=
 =?utf-8?B?UHd0SWxBeFV2MlNqdmNPeXRaRjNFZDdyd1VSK1NzRVRtWUpsbmdtNDc1NzlO?=
 =?utf-8?B?U084T1VsNWhQbkZVYmNsdksrSzJkQzV4SzExdTE3UTRhM056Uko1MXJTb2dB?=
 =?utf-8?B?QkgwU295MUF0WTIva1E3L0xXa0NXV2lsQ2k3dXA1WnZkZTVOK3h6VmFjVGhH?=
 =?utf-8?B?cWZwWndmT3RtK3k4Sm91aTBCOUx1eEY2TDBjcmk5TU54YVVvMm9qMElYZTFs?=
 =?utf-8?B?MDE2VFVUSnNibkF6bkhPTXJycm02a0l6UGhETlhCczdMTVRub0ZZVlJCV2Jn?=
 =?utf-8?B?bXpUNWFZMjB4L2ZwTWVhWVpReVpuRzgwWG5NZ0drRWhTdGlvYkZyOU1tRi81?=
 =?utf-8?B?bEFKYkptRG9VbGdONGpwSmR4WWMvTHR1QnBDYU5zU2owNFpRdUJqNGc4VHN5?=
 =?utf-8?B?QmE2bWNRSkJhQnJNZFBpSFpyeFlDMGxzaGxtUTE1aFRQb1RqdW12eWU0ZFlW?=
 =?utf-8?B?R2R5THN3ZlRZTENEQVEvVkY0SGxnTitDS3NZQTM3TVNKelREK2phQ0NHSXVK?=
 =?utf-8?B?UzNET0psZVQzNTIxQ3hUY0Vrd0hiN05SL3dtRkYxdHNyMWJkN2pzQUZMVXFw?=
 =?utf-8?B?Uk1NemsvejNma1lvSGtDTGdUYlhOSTZ6WmZvMHVrdlkyY1dyMllTT1dRUGZL?=
 =?utf-8?B?NlJaK2NoZ2NWWGU5V3pqTTdtNjRyWlBKK25ZODZMc2xMck5mTmx3c3AyRUth?=
 =?utf-8?B?Q1ZKTVFRUGlOZnpYVEdhMTZvUDYvNm56TW9OT2xvakxjUFFFQ20zbWRoQks4?=
 =?utf-8?B?eklpcDRqNE5ERFhHL1FxbThya3ZmS1ZFaDlBYXRzZEs1RXh3UzIwbTM2bG1Z?=
 =?utf-8?B?WndRRzZ6amtJNVhyYzZFQklIYm9lS052c2pSRnEvTDZuV08wdUlhb2wydHNi?=
 =?utf-8?B?a2FxVEdIWWorS1daaUNyVjQyWXJTOTdqZEtLN3ZrRHdVL29HNWVDT0NSeFlT?=
 =?utf-8?B?UzF4ZEw3eUUxOVNxQmIwMVI4VnlaaDYrT2ZERlF6b3l2d2NES1ZoOXlFdWtz?=
 =?utf-8?B?L2tjV09RTHZDak5HcUM2RC9GaGowdjVPMEE3Z1l4c0FxalYzNVFERldUNWNL?=
 =?utf-8?B?eWlBZnVWSm40WXZ4Y0l6a0dna1hxOFcvTk5FYkY2L2Npam00R0lBOFAzNllW?=
 =?utf-8?B?eGRhcngzRjM4MjJBWGhYaDROZXF4VVM2YVRrNTArV3U4RVFkeTl3aFFpN1Nn?=
 =?utf-8?B?THNGZzc0MGVKNVhCZVRWMHhTZkFhblVrOWxLSDR1VFZRWERrNGJVUUFDdmhv?=
 =?utf-8?Q?jjRxS6WCrYCjcf2BxBW2WVC+AxLBDlmh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7272.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlhqZnJvMXhjd21jL3JGSFNBaGY1NzdGZWNDSk9ya3RqbjllRGJsSFJiL3FJ?=
 =?utf-8?B?OERLZU5NbEpuM1h0ZVc3amlEMjd2SjhWS1Fvc0RqOVdJU3RjbHRwK290M2Nh?=
 =?utf-8?B?Q2FubTZKVjQvMDZhQ0RXZ29Ed29ka0V1SmpLbzRCbTRDNjZZL0NtZHd2Rnlz?=
 =?utf-8?B?azEvU3R0OEozYklvVHNkVnRHTk1aQmYvbDlMcXcyZzZjamtEVUg5YkVhaERU?=
 =?utf-8?B?bGxHKzVxZWtmeE9sZ0tCREtHT0kvY0ZtZnd1eXBmL1F5T04remc0WXpuSVA2?=
 =?utf-8?B?UFJPaGpSUTlMem5aN3FDYTFXOUNGNnY3QVk0cGtWcXFnMm43dFFkZEJBdkdN?=
 =?utf-8?B?eFZoVDdsaFhEWEZ3a1V1eThmRHlET1dWZ285blVKVUhYdmpLZDRzZzgvdFAx?=
 =?utf-8?B?TmZtRnJQWXlxRnpHUWI5WUhuVDlkN0xWTUNvTkEzZzdzekcxUnZJRWV4U2Q4?=
 =?utf-8?B?R0krWEZnUzJmYnhpWFNSb3B5M3lOQk4rQnk3RzlpV2x0YUFKZlZhdzlTcDZz?=
 =?utf-8?B?N0hiczRJTEVrbVhGRHZyT05KejhoWmU0K21OQWJMempsb2xodFMwN1NYK0lq?=
 =?utf-8?B?aC93SnRGZGo4U3huRnpCc2k3QjVTOXY2WTYxREg0cWliM016b3JUVkNTamhj?=
 =?utf-8?B?TUNEbEN1UXhLUnhZdGhWZ1FDWmlqVnQ3ZmVEWFpyUTY2TDc0MkE5R3AvTVpL?=
 =?utf-8?B?Z0RvY0lCS0UyUlpWcXJsdDVCOEFCVDNuRXA5UGVMQ3E5cmg2OGhObjNGVlZP?=
 =?utf-8?B?eXlzbjlpckFiTTNxZlU4MnlWY0JiZjdtdVBEeUE5QzRtT0F5VnRhVzM2V0Ix?=
 =?utf-8?B?OEVvdHVOcS9VdlBMNkFmZW5KUFdwcXB5OWNWb0JiR0xHUjRUNTJOejBkWG1z?=
 =?utf-8?B?MFpuMFJXajZkUzg2dFNjdDhCSVdtNUN1N3h5ZjliWjNEWVNlRGo4ZG5NNGxU?=
 =?utf-8?B?NzRtSjM1UEV5THBucXE1Y29wN2xFanJkRVQxWThVWmRzN09YeTFkaVVIQ05K?=
 =?utf-8?B?Ykd5MS9Fd3ZXTE1YWWl6VzZoOGRCVzFIOE4rbEY1TlgrdjJ2MTBObzJEOFRk?=
 =?utf-8?B?eXV5RzU1am5qOGVidjhPQXltVmJ6NmdxdDFxR0NKNUlpdEoxbUM0NkxIZUlR?=
 =?utf-8?B?MWJmaWMyZHh1SFBwLzhoelMvRlg2TkdmazVUT0hpckxyNnVyaEhtVGxodCsz?=
 =?utf-8?B?NGVjWmJ3QU5PWUpKdmtldnQwNlM0YTFvKy9hVGJBNHRpZU1UY1NwU2cxaU5M?=
 =?utf-8?B?bWNUTTlXRVpSVm9RSmx1Qk0rTE5rNWV5eWUrLzZSOWdPNXVFL3FGMjM2elVj?=
 =?utf-8?B?aGZtaS9ZRkJad0lxU04zd2lwUVFpaDl4S21hVHhtYmRxckcxcVVyeVFIL2E0?=
 =?utf-8?B?RmJJTVdqTjh5aHFaR3pRM25QWWZDMEZKbE9EeDQzSzRKYWRpWlMzLzJycmlx?=
 =?utf-8?B?WmF5Q0Vnc09OOHBkMEZiYUR1ZFg1em5EMFYwZmdZNHRiTDhLRkFvQll3WDVt?=
 =?utf-8?B?cHhJZVV3QmoveDhTczlDWnhzSE50d1ozMTBadTJpejN5NU9iU2hPenVZMGt1?=
 =?utf-8?B?M0QyVWt4T1FWQW9UV2dsZHNlS0x6bG5NUGFLRjU3QnJGWlZJY3B0d1VSK1lN?=
 =?utf-8?B?QkF4M3gzM2NKSGIvUEJyQVZDcU5nNzROTHNHMDhzVlJoS3FYY3FrOGxmYllk?=
 =?utf-8?B?cVlvRjZsNGxHTThETk85WUVMMm85L2dhcktCUENYSWN5d2tMaFVjYjRiZVdO?=
 =?utf-8?B?dUtycFpPS3hFVWVOZkFWeHoydTIrYnZ2RXZXbmVMTXVTc0ZxdjJLL3RodC8w?=
 =?utf-8?B?YjJpM1BvNkJQWS9OeGhaT0YzNEtHSk9hWnRuZE1YZWR3UEVKbWlPZW51c0p4?=
 =?utf-8?B?Nm5RRUNWQkc2MHU4NnVubEpjSWx0M1NHV2RSMlZ0Z241RmZKcjBLOS92dkNl?=
 =?utf-8?B?VVprWCs3Nkh6VUpKWmh2ZjRqbkhXeEJDeW5NOTZkSU1HaUFPeGFzR2hZc3ZZ?=
 =?utf-8?B?OU54SUtpdTZlcWhDYkFIYmZMNnJWK0dqNFFBN2Nob1lDc28xWDMyOW1Ud3RI?=
 =?utf-8?B?blkwUkUwRDQ0VXhQM3p4OU9kbVNaMDROUnBoL1BBVEp1b3BVZnNUMFo2c2xH?=
 =?utf-8?B?eFV4RWNzUXc2eGdsTTdJSk9MTjJrQWhaQXhpVzhlN1pzVENLQVpnNDJvSWNN?=
 =?utf-8?Q?UvEWiRTWiPVngKWJu3lV72x7eatfDyanCmkv16xxVpoC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b08748-f05f-495a-ef3f-08de27ed47ee
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7272.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:28:40.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnHFSGXBdO0npWILmztjWvnBOOOjNX+1uamKqSpDdQqeHW0DH5UrO7t+PicC2MGNUIfoJl6NInIc90V3z3yCeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7774
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0688414000A
X-Stat-Signature: zmou3mh13ec3w6tnpweqprm1q9ac5x7u
X-Rspam-User: 
X-HE-Tag: 1763612922-987598
X-HE-Meta: U2FsdGVkX19BakDTYtqdqNXyhVPmKmmA0YrjQyGrzZ1uWuVON5qaV+gX9VdDmt5d0RzaULUESxP13csyTKKxgD1oDyMV9k8Pv/EJrYHEtAOgBMggViIU50oEeS+FR+hUq1Wtdp9VB3Ux+HnmlJaVsf4hr458aoG1c0LpT62ai2w/KpLenVOikC7dc3cIW9q0Fjw4M30Y0B3nOtyoBtf1G8xftuJtaLi431AoE0ltLsDSvBL8w3n1S315lRhOGZsLES2KiFcUl6kwBmzvTNu15K46Hz5BAwHC9dbQVd34U1WJzaXdzOYB+Ldf9VBlt/oJu9gkzSQZ7o05zYup5DKHgjGmA0yAzw0L/Z8+7iSfb8l2h70qTxVFWr6Dt1c+H7fTCe3haW3qGaeaEYkpK2z1LzhN1PAjoUDf+zSrxdobvCxOuW6jA0GUgrYcGmxhQMyUgRMBL1lmCTpFkXY0ubnTOag3HlcV5cnlngbLzaEbqHpaqyv0y/rgTir3s8am4yqvASotyWLmmFFx+RfLyOVOL1RGtemtMFe01I+6IGTtTDfE9ni28zZ0NsZjW+ookgYFVId1oMkNgb+outMSyG44EuKlec3NelJGXiOcFe0uFVAlyh+C6PzS27/ZbPaj43/gfTo6gcWLt2+mpP5tFobsOIx4AZ3I+ELmkSlCGfuzZIYgzb7vLAQ3ZujHFUx00/HeEkOwmyWz8Jm1wEnn2zEzAkaGjHtuwPyiaqSzIcCSXJGK1B1lJa0mQ/muu0Yc3ZV4hBfSj7IT+HIVb5K0sVZJ2f3YXynF9eFwd/mUm6vMUpdMgbY5nZpAsvOwaOwaf/bOGj8Zq2cWftTqN/VJ1c44LibiwZmhkHItUE4NA3wgbkHkLHkQv9Okhv9RKsM0WQ0+rbm68+Rn8VWexpnZRkqJNzZQ12vG0whqg97BLGRhSA68x/Hn0FaWC5RK4ji6+Vz1jDlZi0jH+PQ3Y7l5oEm
 na0EjtUY
 SIfhjy+WCGjylndoqSjQLqcbVtnI1+qhW+qrzZ9GPNk+Xqh3SgZDP7kYXZ55J5dBqXVh3Kx9lV1zx76E6rKkJ06ccpv0mYJXYZ5AZI/AW8xTIo8rWopmfcPM9olueUvTgInJ71hjhpJQnkR8cIiRPwsgBlSsR9AefWQLG0oYaIQuIQGebqFSWA7grb38nPcMninlL7deKnXvvjsD/KmAOvxdFB1yAtXp+WXms4Y3ksgcRIyDP4jJvcTsxW7atqUSq5MciiWBBk5wtubXHJcGG+h9yJOcV/jXy6vl2EhNQ+6l45yCpcz/j0j2hDyew4JendTvCc03iOL84mCzZz8FNh2WKxupVfvdz7i1leINAp1KYGIiufKkREEsHxQxx88rHG56y/xQOJfruLNFdmC7rS8wlzfWFCrMXuZZKstgXsgYAD2a0j4YaINGvkmRh+6RvCR7HKMZN8dWQdyskSIFMOTJlGq2TRCkuunFY6H0G3hU/Y2oCoURbxF/Q6/2AW3+ofI+mmnynAN/J8JERepF4jZGn7nyMGd5uPeyyuojMliOXAws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 14:59, Zi Yan wrote:
> folio_split_supported() used in try_folio_split_to_order() requires
> folio->mapping to be non NULL, but current try_folio_split_to_order() does
> not check it. Add the check to prevent NULL pointer dereference.
> 
> There is no issue in the current code, since try_folio_split_to_order() is
> only used in truncate_inode_partial_folio(), where folio->mapping is not
> NULL.
> 

Just reading through the description does not clarify one thing

What is the race between just truncated and trying to split them - is there a common lock 
that needs to be held? Is it the subsequent call in truncate_inode_partial_folio()
that causes the race?

IOW, if a folio is not anonymous and does not have a mapping, how is it
being passed to this function?

> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1d439de1ca2c..0d55354e3a34 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>  static inline int try_folio_split_to_order(struct folio *folio,
>  		struct page *page, unsigned int new_order)
>  {
> +	/*
> +	 * Folios that just got truncated cannot get split. Signal to the
> +	 * caller that there was a race.
> +	 */
> +	if (!folio_test_anon(folio) && !folio->mapping)
> +		return -EBUSY;
> +
>  	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
>  		return split_huge_page_to_order(&folio->page, new_order);
>  	return folio_split(folio, new_order, page, NULL);


