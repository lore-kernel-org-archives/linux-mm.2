Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F7EED66B9D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5276B00AC; Wed, 17 Dec 2025 14:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083886B00AD; Wed, 17 Dec 2025 14:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C306B00AE; Wed, 17 Dec 2025 14:38:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D53FD6B00AC
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:38:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64EC513BDF4
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:38:44 +0000 (UTC)
X-FDA: 84229975368.29.AFEC631
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A30B4000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:38:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NTfYodKG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766000321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpEEX4HLPIVabBRdHH+mIP0MEGAdOi7CmO+xikfP77U=;
	b=t6/jMVSs05oqmTRAo3JGSCGNiQP+7IZQUu02F3B0MvX4Zr2oALrxScVbIqxNiKppGI/Pao
	B/zeU+OqcpVY2tT+ddV5GJUZ+deVLZQZE4wZ6KWBEZGhVkGX60TLPYJqWc+qL1e2a4f/nQ
	9h8qwpYvRUvVgXR10gez/d/Pl2YJkRE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766000321; a=rsa-sha256;
	cv=pass;
	b=zdQKz4/GWIay87QjRtNjQldx6MRDsxZ/aPe1rPYysNq0wQ3CKl+5pKu8pGhRxbBFl7pYWm
	Qb4rQagGNT358i7v5/v771/XNNZywx39O5J2wJKYCaM45u0Dzj6xlz0IgxZ7CgKEyrR2YF
	ypACoU/u13eabz0c2zZjfB1zFFaHnCA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NTfYodKG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n++a2lYkS8rOc/RPNiI6HYoP3p2DydrT+12sfk6nNmhdsDmqtA6XyxO6SNmruEJ0PidgxA0hVLGea3rs8Otfht1lWDl4n3HDvbQyobBxd8IFqLGo1nSUqLjZnYRwzHhYNul7k8HcYORMc97YxZ+IFe6yIpEQHW9/1D9iyAT6zv6tAc4ZjpeW3/MYLJNm/+NGgT4Y6BQ7+TKFCV1cHrIhBtYacTUqjg816YsIaOBCpHc5N3HVgXjbJa5lD8jvPP12XPGyUEUFHIhpnEJQMrUX7nK/ZDL9sVgwXV5a6V36Hs/Uf9K/bZIfgTRxOM3UWGnTRt4gxO6tKs2H4bBQQ2qS4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpEEX4HLPIVabBRdHH+mIP0MEGAdOi7CmO+xikfP77U=;
 b=E/k4catLCFFFK4TmmSXE36UIQl4AnGaiwbyadAlZ8HZ0V1M3AeJlLmGGjA3D9NZv2sczEYcWbhrGz2a5VvEevckgt7+fekqbWocpSC9MWWLuj2nORU0M7OkIZVtKjPF+xzlfJ6w+849AOv7fvNwkQRNlZF7SrNxzd713s/ZVsRmW2otcX9OXjKmumTowVbU6oMQQ8x39RJdMyUdsw3lfnGGytVwWELEKVhx5CdH05cx7cA5FXXWUXHr4EmRka257YrmkVMJPE8bgLycmUe7wDwphZTEh9QAw0B4jxJkmPumnZVc2bv/+WiBIZu1MszQ7Lagh7cZRXocBDrDc4v1dBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpEEX4HLPIVabBRdHH+mIP0MEGAdOi7CmO+xikfP77U=;
 b=NTfYodKGKV8RqmRzfFKUk6MGpL6IvO+Vbyw06F5Ngn4xVO71ooUCbZXBS/7U1qZs5fRG16khYtWYPgU+iCy7KMPXCHKKVS5JL1Nff8VQY6zen+paGRXfN9sPDqoZS8pbucsp8M3g3uodlKuOE+atsCLMHULv+6xtZ2F679qZNiB+Q1Mazob6RPjAPZJ+wA3PyR3So505XKEozGu0av5ig/WBHSidgX/HX6Wyvj3MclIq+tVs+oNkVtuREZrytwaD7kHEVzAtp0/2O1ESFbsyVmghv2g3CKrQrguTcx+4YF3dQhmhbghbfzJNEiVeT6eVxww+kUSmCkalTrc5nKoo6g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL4PR12MB9505.namprd12.prod.outlook.com (2603:10b6:208:591::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:38:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 19:38:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Wed, 17 Dec 2025 14:38:33 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A276ED1B-89C8-45A0-8DA9-9D5CA1D8E2FF@nvidia.com>
In-Reply-To: <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
 <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
 <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:408:ec::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL4PR12MB9505:EE_
X-MS-Office365-Filtering-Correlation-Id: c744ee6c-2f11-4909-1bfa-08de3da3deca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUxXNzJBUE1Fdms0U2p6YmowNmY3cEQ2N2NJQklHSUtobzFSYkhRSFdMblNt?=
 =?utf-8?B?WnJHL1lGUWJ2NHJWMTRjdnlKdUFQTDJTbUlHaDhLcUhNS1V4ZDFHdW5vSGsx?=
 =?utf-8?B?T0RxeVlrS1NjbGI5dnpkYW5DY2FvL2tGdFFMZWV2cjBhZDF2UDhFLzgwYWUy?=
 =?utf-8?B?SHRpMHZVWDM1eDR4MnFtZHptWGFmOUN2RU1wWFNERU1Ra3orY2xhTStiUHdH?=
 =?utf-8?B?TGpmdXJ6Mm13ZXEzTXFsaEtkVGx3a1VMTmZPZG1rRWVnVEJnV0w4MEFzT1kx?=
 =?utf-8?B?eVBFUDVXalpmd3NQczNoOGdmS0FONzZBZ2hPMVNUZFZGUVk0QUdLbzU4RVhS?=
 =?utf-8?B?bnlsTkZ4MWFEUENWY0hpVGs2ZkVVQUVENmhNTFJtWXdmaVFTS3JQQUhZYitM?=
 =?utf-8?B?MUtXaWJpZnNiMzJ2NGo0aTJNTHFOMlVLeWJTc24rYkRONEZxc0RHaWxxeFps?=
 =?utf-8?B?emllS0s4UEs1Q0IzQ0p0VmNjVEVMMGhULysxUUpRbzJmQUJPV2owS2Z3OGtD?=
 =?utf-8?B?cm5nKzRaa0Mxc1B5S1hseUJzRndMTkcyc3NrcHJ0c2IzS0JTQ3l0aXQ5YUJq?=
 =?utf-8?B?V25zdWM2c2liYVYwT2VVMml6aHVFd0dIQkFTOVNYUHcrUUZBLzQxL0p2blhD?=
 =?utf-8?B?cDB4cDBCZmt2SDI2VDRQZnZwazJGWThtSTJKSzZjdHdwZDhyOG94YnpheDBC?=
 =?utf-8?B?NHRweDVqcFJrNHRaVG1LSUg1YmN4N1VRZ05Zekt1L1ltckROSlk4RzdWWDl2?=
 =?utf-8?B?UlZ1aHQrVDlUaHRxWDFIR21jOWVKMEd2U1lBRzMvR3FyazVORG8zQnlnVnRx?=
 =?utf-8?B?eUQxeERUSUk5cExJaUNEcUN4NEtuSHd6TXUvcjNEczBwV2preGNhRFk5bjBJ?=
 =?utf-8?B?aW0zRlphSGRZZVBrTnF1SHhSYlBZVnJSSHJDbzcvaGgzbjdUaXBZcTJCeVpE?=
 =?utf-8?B?ZnJvaDNEeS9BOHZQcktjVUFJTWUzZ0Z2TzE5aVFXVEF4YmI0N0xJOWZmbTV6?=
 =?utf-8?B?WTdTd1Ercm1CRGhQUkIrRjZsb09mK1ppWUhVQzFhbEZpYVNmS0NzUHJMcmNY?=
 =?utf-8?B?NmFSbmFnenJlZWh3RldGOExKU0d0djFndEpnMTEvNHV3QTlDajJIalhrUGdR?=
 =?utf-8?B?M21RY2R5YlB6VDlaelNNMkE1bFl5WFQ1bkhmcWUrb2IxeWIvVVZMdU9ScU4r?=
 =?utf-8?B?VVBra2tYcGdkL1lPVjVXYjFSM1Q2ektmK1cveEZ0QldUMmVtR2tqVHdXQzNl?=
 =?utf-8?B?NElzS05Rb00vaU5qR0NLbDJ2MzJ3Skgyak5JcGxObWcrYlRnNUtWaEFxWTY0?=
 =?utf-8?B?NG8rNUxNdm5sOHU5aUwyNVUzUnp2cUZQbHI0NElWNXdkYVBmc3lVbmd4QUc2?=
 =?utf-8?B?d2pDUXJ0V2RkR1Z4UGRvUjhBV2RhZlJBTjVVOXhKV3dBRVZuY2VuOC9iQ2V3?=
 =?utf-8?B?blh2emc3SGM0cEVwSkFKVTlOMFA1MjYyTWk5ZUJ0cjVhOWJ4WkhHRE5Pb0t1?=
 =?utf-8?B?RFB6R29jM2k5Qk93dk11SkdkeUZ2Qm14Q0gxbUZvNi9uZCtZMzc4cUtoNlpK?=
 =?utf-8?B?SUxGWUZTTm9JL29aM1YxTnI3UVpIeW50cWhoNzFvUHk2MDArU28vMXZlcUpj?=
 =?utf-8?B?bENRRWFPVXJrOW9RQ2Z1VnUvUmcxUEczWWVHTmZqL1JZdTVQSkdTZVdVSXBD?=
 =?utf-8?B?eHQvd3orcTBSMHZLVjZtN2RBSkF0ZVBQMk5Lam5mQmtnVTVLZ1dLaXQyTzJt?=
 =?utf-8?B?S1o2ZUFNRjZqQThCR2pmUDVHQ2luMlk3WVVZQWxWSlJ6ZHpHNFRwZTVIZ0pE?=
 =?utf-8?B?RTdqVUhwbU5zTTFFWjJQNzlDbEZLdEZpcngvNWViNE8yQ1pYcU5aZzlrZU8z?=
 =?utf-8?B?Y3hUdUlzMlE5ZGM2RlhLck14bEt2aGJhOWdnSVhCYTV4OVpPcWs1N2hVZTlP?=
 =?utf-8?Q?qOQrtCqCYVDppIt/LpkpJtSOla7xrYAQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGtMY2xqck1jaDVHNS9pTEcwUFJnUlhqS2FaL2VMN3YrMitKdXNuOUNsOXhT?=
 =?utf-8?B?U3BiYlh6VHJZYURjMld5elFBd2lGQ0RGTjloYVRWalMvSm5xQmJXNVpIajFU?=
 =?utf-8?B?TGlEUEJaWW92WXdyMXBLQWM0Wll0T3ZadlNJdEFZWWpOeG5KZG95SWJ4TXkv?=
 =?utf-8?B?Q3E5dG1yeHdZdEhoRWlHNUpQVW1yckpXVUhnWWRyZ09adW8xMUxlZldVYWFD?=
 =?utf-8?B?emV2dVVCZVFnZmFRaDZ2enEwM1hOVjVySmRDRDhaaTlUT2ZpdUM2NFNZSDho?=
 =?utf-8?B?emhRZmNrQ01SUlNoWlArb1ZWZ213NGxTeUJnc3UwanBqeVRwOHBVcTAvMmlo?=
 =?utf-8?B?WWdkUS9TQ3dYVUJZMnVFK3NPYTFFZkxhTU9CcnEySkJoS3hXcVRFZGpqZngw?=
 =?utf-8?B?QUc3ZCtRNWc0TnhVSi9KQWZIeFR0Y3IraFI5VHM5K2Nsc1NlOUpIc2phMjZJ?=
 =?utf-8?B?MjI3L1JGWFEra2s3bUZwTzJSTVk2WTl2SjFFTlRNbStwbDBWeERrMHZLNnlL?=
 =?utf-8?B?cVA3WWFhVUxDamsxL2xTZkUxanhEbjl1TFJMQ3FMTitRaGEva2luV09ZSmFO?=
 =?utf-8?B?L0tkalhUTU5jL0JadDRYR1N2amxWRGRrNkhLV1RjNFhVajhHT2U1OGZzTWVM?=
 =?utf-8?B?Y0lMVUQ4dmFGNjFTbUZVSThIM3N6S1QzMG5RVXNRUnlSSndCWndCSnJPNm9L?=
 =?utf-8?B?OHZFbHh5MENFMDhsdTE2ZDFSajJaUzA1UmJDdFZhMVpzUDhMQU9OZ2xWZTRL?=
 =?utf-8?B?Y0RBWWZNdENIaFdnVC9LdEppVm1CUExHUUlEdHViYVhVZnlEK2RDUDdTekNy?=
 =?utf-8?B?Z0hHWjdXS09QWlo2amRUTXdUN25NYnJYZS81LzhCd3NaUWNKc1dMNmpzenZN?=
 =?utf-8?B?ajZBYi9UMEFaQUlDMVBMMkx4TVJ5NzJQV1lhUHpwbTBRNHRtMWk0MGxFY0s5?=
 =?utf-8?B?WUMzMklSVjd0SGFweUE3cE56Rk5vbTJySEVZaGZJeVYrblZtc1RDTDhZaUlG?=
 =?utf-8?B?eG1OckN0NnZNOGxNbmdGRVJqZWQrcDMrbjNtNklzOGlqQXhUM3VWUmJJYlRk?=
 =?utf-8?B?UXZlaVpoWmh2dG03RG5CRjFlWElrbU9lUmRLYy9KeDE3dWNTbVY1c2o0Rnk1?=
 =?utf-8?B?V240WDB3OVlTcUtlaGl5NlNrYktjdFZzQnNkNit1TlRHeVpoTENIa0dNSFpm?=
 =?utf-8?B?dUk5Wk5lOGI4aGFZWkk0QXVLMkY5MnkwcUJCeXdIK20yNVJTWVlKRG95YUR3?=
 =?utf-8?B?cGJvTFhMVENIYlpuYlZxS0wydDFwT1pDenRjL0JBemQ2WjFUZ01EL2dwVllS?=
 =?utf-8?B?M0JaNWVtWHUxby9tUTFmc3ZLOW5EakFYeEhKZzB0cnJlSk90OU1jVjJ0NUhl?=
 =?utf-8?B?Yy9Mb1haMFpITlhHNDJoczZzS0hpeEZoSDl5alVsck1FSWtRVDdqbkNoV2oy?=
 =?utf-8?B?NlMzRGQ4TE5RSE9Ba3gzYUpuUmxwK084d08rMStnbGthYnVLamM5QnozQ3BW?=
 =?utf-8?B?SUloUEh6K0w3cWNkL3U1OTJ5ZWJjOGliRnVuZ0w2dDhRV1J6amRvZkJVaFp6?=
 =?utf-8?B?Mng0cUllN2hSeXJJcVhUaXd4U3psdi9SM2czWGtIQUM5MVI2eWl3aTc5ZG9r?=
 =?utf-8?B?RlJSWXZNNTJpZUpQNXpWZmUxRjF1Yml4Q3hZUVo2aTlEUThoK1pEWlAxeHJr?=
 =?utf-8?B?MVYyS3FJWWRERUNCVzNaRnRYY21mTmZKQThxVjViZzQwNkdQeTVXNmdVc0pH?=
 =?utf-8?B?dFJSR3hmODI2YkE4RTFQS1Z6cXpZY0RtcU50Y2pNZkxsREVMb3hDNVNQU09R?=
 =?utf-8?B?eHJxMy8zeGNkRTRSeU1VaTVjNW9samRVUytTekFZclEwSUJrK1FBZlAwdDdq?=
 =?utf-8?B?TWlsSUc5TnViZUxIQ1MwOWNzbFMwSllNbGxNOXlMazNDS2o0blRlSzM5ZEg5?=
 =?utf-8?B?c2pySUY4UEhralUwR2dEeTArUnRXL1N5Q3lKSGtHcGdRcVB3WUkyNnBhTEls?=
 =?utf-8?B?UFFsZ0dLZERacm5vd3lwblV3VlEwMUgrbUhIbnhoVlRjc2lxYmVXQ0htbTRn?=
 =?utf-8?B?NVJUYW95dlNILzExcGF3UHgzdURsL0EwWHRoQnR3WExNd2lHaTFPVndlS1hQ?=
 =?utf-8?Q?9+TRL/vusQFSsmGfYlMDNEZSX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c744ee6c-2f11-4909-1bfa-08de3da3deca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:38:36.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcZmJITtTmcs88yuvRSdlYFOc85SKXdaGRgOXCGG1tXq9ThbDMHCmAngY9uzNtTH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9505
X-Stat-Signature: 6jwwod4bob7qhsyef4ibc1czkz1du5wu
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A30B4000C
X-Rspam-User: 
X-HE-Tag: 1766000321-781194
X-HE-Meta: U2FsdGVkX1/duZxbAaw9d6XWYpUXZsvc9F5Til6yqcs1ikabWwN216gnmNop5QT4KjR2x3Z2wkSzsLIeDdIOSNJ65UR3PSm+XjFQjk8yYn+YX5VoQnRUVKz6obSppv4uyoPgTuqT15BCPh3dGJPAC+a+bnE/w83AIrWVUKaQogO4Z4glFt6YT5nlNUCerjRsGpBj0byqPT6aipXAoyUc0AldiG0+t6TwHKWdrjKa1CEiIjH0FwmCdM5W2g5lzMF3XPLWn9frpoV6d9q0SrMnLcoFIgYOealVXIFIrqph+Vt2FHb0qYpTJma7qizdMXE9grMeAK83UkZMp1z5nA+CLmf/uyrd96xm2AnZRsEjnF/a4R7fXyJZQy68Br7AjOeS4dQDFzhPw7HGemw9msjWO5b807ruXffQdDE4XSDrh3rZZj92i9rh9NlhUqG2RrT0KuSSCo0PfQ+Eh1o1vLFEfb3GEv0Eb7+jWjJMk03LIhcSHm080vAua+RDKVlxCYP67RMeXH7rq+oaF2/8mfWTN+eiDFW4s5e2e0BAsBmJlc/otoNR22yxMdeHPnY0EOD36sbUFWETIoEFz3fNfYgW6+c8y/HKBuAcFm8dD3ldTemdx7E80ukipt4xiZaqEsflaIEchUaR+/K6jGa+NFUvQPmS8YwTk6Sr+8y++q1LLxNdoLXXYzoE09BsPM9UhgM/PNLoxVUbVJxvmrAy1YBpiFVqa3/PAUFtLl8TLKkxRkDSrZOr2J5IJ0hW4PhgpZ9g/NCZZ1POsmGm2DJzl40YU9RAm0I4bola5hdcw88zGlpugVU65skoHlaBt1ht+cseAgOcu1gOOdMXURU4H9Sy28d8NDU33OVk2gZK9fFmRaYgFnzm5uy1KSwuTNUE6W7XqSZWjOwZXQH8s3yUOHuvYO566j2MXp85zWmDALj6SiXo2XU7RCWCbCOOJdRmEO075eyYlrb1UVZx7vuv3Xl
 WgufbGjr
 /adqvoijral9vy8/AopamFeSNO7P4RfTP015Ijzqyi1wGXIReP0ZMnrRBgC7U2YzAtSKAro6n43096PjfHfk0EzdYTq/AZp0IMVZJ/kY6BS55TMCFkegXs476UuaEfOag7LYqqpNchvV2ZBj3R7lqN7P6XriERh4s/jHcba7vj7bkqHuqrgv1BHKSc8lYqjbb2qI5Ue+Ag8uhWesTWPVuSob+cPU6lrtZx0PJHnQtdUMri01UHgEgmvNNdiHKYLnkEyTgvQtnPud+D8FG0LsadW1+XnyudF2awkdZrw2FVZ+B/iropaCdaHmdKYmx8m+Gyzgg02Gr4q7/hBrJEBeUVQf8QuYhgKDZkmOxwVrkJEmfLd+4eL/nyelWTC4W8MkzcvSlhO9h/fKne2w//NJO23XrfyETk3XnnK/Elr82XXVQV7R06TakNjPp2kJPpYohtvq2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Dec 2025, at 3:02, Kefeng Wang wrote:

> On 2025/12/17 2:40, Zi Yan wrote:
>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>
>>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>>> incrementing their refcount, then convert hugetlb cma to use the
>>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>>> into mm/internal.h since no outside user.
>>>
>>> The set_pages_refcounted() is only called to set non-compound pages
>>> after above changes, so remove the processing about PageHead.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>   include/linux/cma.h | 26 ++++++------------------
>>>   mm/cma.c            | 48 +++++++++++++++++++++++++-------------------=
-
>>>   mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>>   mm/internal.h       | 10 +++++-----
>>>   4 files changed, 52 insertions(+), 56 deletions(-)
>>>
>
> ...
>
>>>   static bool __cma_release(struct cma *cma, const struct page *pages,
>>> -			  unsigned long count, bool compound)
>>> +			  unsigned long count, bool frozen)
>>>   {
>>>   	unsigned long pfn, end;
>>>   	int r;
>>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const st=
ruct page *pages,
>>>   		return false;
>>>   	}
>>>
>>> -	if (compound)
>>> -		__free_pages((struct page *)pages, compound_order(pages));
>>> +	if (frozen)
>>> +		free_contig_frozen_range(pfn, count);
>>>   	else
>>>   		free_contig_range(pfn, count);
>>
>> Can we get rid of free_contig_range() branch by making cma_release() put
>> each page=E2=80=99s refcount? Then, __cma_relase() becomes cma_release_f=
rozen()
>> and the release pattern matches allocation pattern:
>> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
>> 2. cma_release() manipulates page refcount and calls cma_release_frozen(=
).
>>
>
> Have considered similar things before, but we need manipulates page
> refcount only find the correct cma memrange from cma/pages, it seems
> that no big improvement, any more comments?
>
> 1) for cma_release:
>    a. cma find memrange
>    b. manipulates page refcount when cmr found
>    c. free page and release cma resource
> 2) for cma_release_frozen
>    a. cma find memrange
>    b. free page and release cma resource whne cmr found

Right, I think it makes code simpler.

Basically add a helper function:
struct cma_memrange* find_cma_memrange(struct cma *cma,
		const struct page *pages, unsigned long count);

Then

__cma_release_frozen()
{
	free_contig_frozen_range(pfn, count);
	cma_clear_bitmap(cma, cmr, pfn, count);
	cma_sysfs_account_release_pages(cma, count);
	trace_cma_release(cma->name, pfn, pages, count);
}


cma_release()
{
	cmr =3D find_cma_memrange();

	if (!cmr)
		return false;
=09
	for (; count--; pages++)
		VM_WARN_ON(!put_page_testzero(pages);

	__cma_release_frozen();
}

cma_release_frozen()
{
	cmr =3D find_cma_memrange();

	if (!cmr)
		return false;

	__cma_release_frozen();

}

Let me know your thoughts.


Best Regards,
Yan, Zi

