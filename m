Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 106B7EE57CE
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 02:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582696B0088; Tue, 30 Dec 2025 21:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506AD6B0089; Tue, 30 Dec 2025 21:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3DA6B008A; Tue, 30 Dec 2025 21:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 282816B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:59:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B46E6C1D63
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:59:24 +0000 (UTC)
X-FDA: 84278260248.15.8A2E6BA
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3213180003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:59:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hM3KVAmN;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767149962; a=rsa-sha256;
	cv=pass;
	b=woFcynmbdNG6Q0N1vDUjojjsT2G23kdvZ3H6CJUP+wTGuZl1NX5LjbFYvR3U/FtlAU4y/v
	wLsywCiDBA7kyHX5VaJUIqMEdZI2DZTGNJ7VKSfhLaky7Cz7/FzxP+Vo4YT+pMx7vVzrmL
	EBeZXN4jtgz0E1YOcCL+yLWM0AmvD0o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hM3KVAmN;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767149962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aXGXiOZ4FdfOjZbriDRLFS1OnjnXqjvy7Md77gzoww=;
	b=tMfPgbA+fOfHhJv20tUrf0JZ9m2JtxcInIRrgr9zM5PmZIgFsU6C12i++3DGX9Zd9IDZgt
	ATr18Xqinux/1SkGd9cLBQKAzkfVZWxkmIQgx/MC8lYWAD2DNqnlT/lIus9FVs2twUG5ah
	TSXonAc++f/4XsgFrhkAot0+VDDG1PM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+0U0x58VP8//JNsnt27uUQkQazS4fqAIp/9tIThFLekV3Xj9/K506eLzYHZMpQhAnNbZ1rTmVyauoKhTCUXAAKZkc1WgxDnjXFw83RXQ/14qLTWafgA70vLGenm2Jec+NKZ5frDGqSDNS4T7RXL10tjcOl22Bu7OjoHgOgOnWny8Gf7lQSiv/o9HadFUL2k7balX8nh9B3PAmbQAF9hUOJQyVt/na39FILV3UbunhOxSy2SfVNOp4T9I9K+GeHiXXHJLmxwsTImxfsTknQsFFU/i40AYuj42iHF06eLpjYSSr89FOIeAMNkXa1+dJ7Wv/lNbqlwTfYfLNwyOo50VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aXGXiOZ4FdfOjZbriDRLFS1OnjnXqjvy7Md77gzoww=;
 b=DvWSSzSCmOsOBllh/8qd7JvNdSdAP2iS4xN4nx+LD3/CmloKbIMGkSvc4GO2NO59J+3qWKksYnd2fCUCUxD1XIYX7AkN3NX2BvjrGm0Vehk0LRZp2vEth6P842ut3MhkNZ3tGsyfyfE+NYLlaxdDTNId9UCswEdZYgj7xR3UgkHBQI+Bs8xMDbPOKUFSN/QaXkcJaKxjGMHsGzmMN5tjyDFuIGvnDa+mispgTLRpS5R0X8dnvzAyZbhU7xSXSjg/B+wcSE2Vhlz+5cFHQlMWTHJxOCXtMIRaBDXznFkJCBqLy9H1lU04KAVW8etN8F83f91nNd5ieULW7IMz5EIdNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aXGXiOZ4FdfOjZbriDRLFS1OnjnXqjvy7Md77gzoww=;
 b=hM3KVAmNKoZs9B8NC0DVNuE6Hwk+jRyrZXBbpPjpdUi9odkwiC3QFu9Bd1nQklWI2qN/TuWe4Pa6JE3itDhp9Gb1gRCqfbhCMetwnupAmqcll2yq7UH286e9iHoqEiuc4DWLMmhtVTz//QB1QVZCROHvdMea1BejXL7H6P7k4CMrS/721P9SHNAoH46PmP3GQp79OI7Mq0H5NgLQvxm4M3t2+YLqgTbu5zGFjXJ3UPBebGWNmne+yd97mVHPAXnE07ozxbDiokYCt+ImSIDYmpL1SM8tUO6dIDgWvUNNRxFs2XM+HfMAqGhnDGESjnsxu/SrGM5a214y8f9lFysSLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 02:59:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 02:59:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Tue, 30 Dec 2025 21:59:16 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <9B3B8DF1-DE26-4320-95B5-7F0E4BF25335@nvidia.com>
In-Reply-To: <20251230072422.265265-6-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0250.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa69a7b-8feb-434d-807a-08de4818972b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XAj/KtMFSev8vJxmZar0AbgoYSBjnGZIap1zyrluUSfYoTQdL2RJi5F2O8eI?=
 =?us-ascii?Q?9OckV5uH9mxmxcTX6VVB58iEBzUrmA58oCXi1mWa92RJgUxMsEBHC6pXVfDv?=
 =?us-ascii?Q?gMFSPtFUI6EuqLF3mO2ffSRuyQ1+6tE/SSeff8jP29Cv748hkSa/qqc36HKM?=
 =?us-ascii?Q?KY5efs0jJGPPiYEMR3clkGDEA1gmwqaXfFHV8os6iioC2Bb+gxAsAz8DT5fd?=
 =?us-ascii?Q?tzJlru8Ct2Wh2wL0J0eR0MnZURKgqVOX9wRIZdqT3NiwOuczVvZ3gVq0KWRi?=
 =?us-ascii?Q?Y5ICF3RUfEdSjbvVq5hDFCMdvkzjJrb+mndkat4+35WEXSdFARpLs5vkwj18?=
 =?us-ascii?Q?YgBQvf/mylzzjjHrVZsQ8mqyVyosqp3TY/wQ9lpUMt/Ns3JKkjXPapAazchX?=
 =?us-ascii?Q?Pe4+x0MRwdPOIcu2gnU8srVo0vw18n0uwJWEqeywpxnQT/5SBvQrG0CKwLkQ?=
 =?us-ascii?Q?E+E2E4vZ+ytOmDspHZfaXKnFoJ5J16h2fUajLZGqVJ7KApRxKRJTYQkuaLSH?=
 =?us-ascii?Q?cVWij9gYCe9/odLycmEZlI/ALRwhb4Oday6M3mvFw3snI9Dx+H6QyPSBFFHU?=
 =?us-ascii?Q?+HuoTkyirk5rFGUqspZBUdX90An/++8JpICPw+Gmk6bQYWZh0KHDbeEBvXY7?=
 =?us-ascii?Q?hOiqBIJjxa26vAvAjka38Hw6srOdIsonUSnfvVz0EK1mKSKij/C24L06Q+ZB?=
 =?us-ascii?Q?ePY9peKU7/1BE79YWFawCVLBQMREu4nYb3appfP+xKO3mT7uMMPXoM77eCwV?=
 =?us-ascii?Q?C18t8s8HnG/YUkX+7Hv1eMMhTwLLpB55RZhuJgHxs+YFZLku6/Fr/pB2zPwb?=
 =?us-ascii?Q?7HdA+IdQmy9VA7Dw0X02+TlMAXby80YLwTNowEAPW+XRZbWC9tCFg4DYuE2s?=
 =?us-ascii?Q?dwUbtwj6QqVcCD1KkbKAOglhPpr7QTAT65l7zk2FlVlmiyjLSE9tEBoBkmiL?=
 =?us-ascii?Q?yWZWiAAusiNMzBv6nGY5STELZQlrvwIdQuzGzm1nT6FtBNgJxshqK4XpfN+0?=
 =?us-ascii?Q?nhl7XnwxUp/wFvIa8xYKr4OKGqtSHwqS0okRMlc3jON5uto3DcA2xALLQ9uq?=
 =?us-ascii?Q?6UuvvaHZlv3vrc/9oerV7L32Lca8q5AxlnkL6kEbicmodgHuwGMyDExKVPS+?=
 =?us-ascii?Q?XmhBTeyoIrt3CycC3SDfZjA5n59xjq0UnF5lqL4g7J57UaaMd9mGDQtpjlW6?=
 =?us-ascii?Q?gtaPb8bmgvdhUgnBk/G7SghpsYQsWRHrOtIfFrlLjadr+PhLx7irWs/zvn5j?=
 =?us-ascii?Q?itIjkoDpkZR1Er5NvzdLuMTnlqm2NxjyKNogGoNQ8YpR5XXPUx3FKDY98r8O?=
 =?us-ascii?Q?S7Hv0bLL9nxNyvcgFRCs/p4SPPfrH67c87ngE1tUGpCkZ8Va3BYufg1/Jr4A?=
 =?us-ascii?Q?1RLuqba1zlbP9E7UN+ZVQzcJiZ4PFMx2zjAKXgSoCYd/ldHUzTgYutf19U20?=
 =?us-ascii?Q?aVFNjUjiqfDDzQjF50rwWSLM0dwDdmUf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vcXcp+2w45cRevKfUcx/PKRVoqJIQz6SJSjfDQU71jnh9sKu7JmUr/wuCgbM?=
 =?us-ascii?Q?6uoMaxfyODe3CaMrfY2y7/yiwACft8EXaKYWSWor+HMlT2KK4psqSeZ/sbu/?=
 =?us-ascii?Q?pBStTdLvnvhigPXoMR0BLKCbnfBkrmrYTGg3hANwOEFGUWFAfTMkr5UlRIj8?=
 =?us-ascii?Q?8Rvd//nbovsNOjyNwo8IfAfSZO4RC7mrHtUKDHwPH2JrVbXhrk8pKDc3EifS?=
 =?us-ascii?Q?I8QaNcwn6MmV+MY54J9aM7CcRhi6RfoAkpqKRR5liAEaDKcNQHkvswCA1JMR?=
 =?us-ascii?Q?1I9qHdQxPP8B2e3LNyEqPzoA4xRVnLdJ+jBWOHGM8Di8lW+q3WY09gtkouq4?=
 =?us-ascii?Q?kv3bawOS0qMnQSIGtli2REqoM2+WWUWD88zwZW6WjCC1Q9GqR2A/U9sk4STp?=
 =?us-ascii?Q?KbloXFuJrJ6dtLh54cJzt6LxlDlGnFNu/7qnQGXrfZ2g34wykE2e7BJuf0jU?=
 =?us-ascii?Q?2FGmL4ppvWXUL9cKRZQRIBgKXOgNEr82l8UsmXZ9tUq5sAQNWTRgNcfoqWIg?=
 =?us-ascii?Q?BJafwmfqDxZMzn+4IW0gfVKGIB2acHoHYVPcxNwxbZhhxdNVlGpFn0Fy3ZYR?=
 =?us-ascii?Q?lhLxn6xuSrN/+2lG0/IXT/U/d4A4Go/LPaG4q6ufylLusghK/VLRIGDPbatX?=
 =?us-ascii?Q?PXvd1gbH7+NfXe6MG6uKPPpMGyxzi0GINuMd3gWYInwbRXyuldF5f8CgjOI2?=
 =?us-ascii?Q?nq5aIgbd+2hssEU9MEDj2Z5KaG3/ae58B+Li2p90YQflQGbiqsmibpnYrVW9?=
 =?us-ascii?Q?08lvbd4KEZx9/1ARDMsusGuJj2tzTsKSL1C+0QkwfDo8Zjx7ukRzqDJDPW2G?=
 =?us-ascii?Q?cgBjRBNxfSd7qCy1wkrZZLst0n/Il2bryPmWqFJBkV2Z0yMT1k+THdKFFBz6?=
 =?us-ascii?Q?CXeEtv51DBFmvkcMVfSDeE6MFc3kkkn5GZFyma8jYAz5eS1elFtyGDu2jaFo?=
 =?us-ascii?Q?BBKlIhQbWYz8U6Aq/XAnaM9yxYxXajT0YZ8stxWFKm0vdR3G0c39YhWvWqBw?=
 =?us-ascii?Q?nuq2UWK5VYkGFD/nOHSBNWRCubnX1VbV0UT2GDdAHMoVoJC3lByLL0DJ1xJg?=
 =?us-ascii?Q?P740g1Z1ULOqieu7pB3UlVU38Jd1e0Sy5OWS0EuqS27j6Hmw/exVe8EkUAfc?=
 =?us-ascii?Q?D1gu6diEdsxRRiaPXwUqL1Vqk4QlevMUDJb9XWKJBjb3PFAa0HkdQJz9G8XY?=
 =?us-ascii?Q?DGbYdrqsZYunFCaXV7kL2sHW9kCJ/wq6A7LaH0hqiryn4kfbIQ7EN6627DEn?=
 =?us-ascii?Q?vFg25WTgs9/EX77TBGvSFkZlk2sX1whQEEKbFra1WcNGzkEQtip4wZUx+H7V?=
 =?us-ascii?Q?ggNak/s4X2XHp+TJVMqMHPpnuBHZgDpZwIegF1WLkvg4uC7Le0/WqRYvi8n3?=
 =?us-ascii?Q?64qAWEiAE+Ml4ORwu3uy3JUIz83WcHrUXoNFpHz7yeLxOeJ4w7lRQVd509/y?=
 =?us-ascii?Q?xmYB6nB6sHiTfy1et6nLIjx9bI/dcoOutrY+leQRGyX8l2i2kH3C7HsdVZqV?=
 =?us-ascii?Q?VUA9kIy3pxpJ7cymYlbd2P8SCQkO+VMon06n1dqvViqbcO1Th//9VrPqsaFP?=
 =?us-ascii?Q?JD+TDbGGX7cS56GzWR6VL35//VES1kFYwHjEkNC7uYhOG7XR/dqCAN8BS2h/?=
 =?us-ascii?Q?ExNpn0rWPpLZyrpCXuh8lOblpE4HJ39jPkbDASik1wgnK8eOBSg25nsofMvV?=
 =?us-ascii?Q?mKy9sTXf+2jhgdh4I0V0RCehpt/USVtnnCgW4fZsUCl4u915?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa69a7b-8feb-434d-807a-08de4818972b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 02:59:18.6658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2bqhDogk1H+KhkizsszOQmqS4+Wn/+N7yeYBJQHKTrEfGuAuRO9t2b0Z4i0uEWj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752
X-Rspam-User: 
X-Rspamd-Queue-Id: F3213180003
X-Rspamd-Server: rspam04
X-Stat-Signature: e51413ngqghnqjugh7nahojbh4he8opo
X-HE-Tag: 1767149961-498974
X-HE-Meta: U2FsdGVkX1830h6MJhD8X6guwXEKWItbHXGcfDdSumLn2n293a5FUEkeQoV8kZ2KTNy4WCOkd+ho52iiTAAArbmmiwuu4WFp/HFA/cxhWIsRurzW7D+2yIJhfNSvvpCNKIGwZ44LJF/mKTjEW9ip9+9f2I4YplwIh6w1Zarp1ELCMSNANOM4X87zh0XoyNgdOUCV4fdBbZ8Eyn9fXfTqNE2DAXf/PgG0Fmm3RVc9xy61LsSdIc+qA5qXbdYNpMWsCnt29TIinf1Yd7BDKQqquLkWP8C79YFYe2wX0BuQrt2nTrUUnTSiAmbjjMsLjfaLKkjBekDWZI76dlz8beQEoKtCAB30zH+j7FgveIDOcsoy87UfOqGyY6ZQY8pzlYfnvhR9s1h6W6yzcwnlyXnUdTcFkRwogRqr6oE6I0jyVR8N87VfVoX0QYNzdMdJFFYuFidj0OM2thdpcLgTUJNNXTrXMgWIYpdmubo98Qz2V5/yeN5MATepXsWFXjyXGjb9VhY823Aay50sf09c9Lz4H4s5OJIZSlnu03Z5qjkTGwplkh4qMc4ytTpX3gKVZYN4xCSYas6epPooOmBi+G+Ej/1V+KkVlP9h43lGkJDLwFq3BrMLTiLafx3N13NdIwke02D3ghUk6Ztl4mb8yeum4SCtiR4ZooqbdZGsir/C+vJ3p6VfZTmQrSujpch8bi8jOhEwgkH/1egcsp2w4x5rMDuRbn9x9MSJDCtNF7DqU359G3g7wyP+gqR3YeqjAiN3cuuFFT6YK1MLB1XnJkNeqfRyunvN4RHLfj3BjsrX6/Gb7iFpQ0fga5L0vCe80FktLV8PQa/t+MDMdJYchFN9tww5UqICr4h5TtnhJe4Mr+xiZ3pTPEFAnHKP/BPQZoE1+fMksSMMUo7NKocRla935AmS1c1NbyfJFIpoZs0bHS5hDr+SnAITlwLwtwGcCfBFBlxzSWrc1nhTNd0EHRN
 kowHFiFG
 YV30KuuFEO+Fq2ZyAC69m59wQjDRIG73kvhgyQb7e0SlSctexVmWB9p2byZKaIoS/h9oujPQ3YxLweptRUV+jZoqA4/4WWTNUGOnxf0EnlmdFkc27vpxBOSIkzd5ZeY7kg0Cz/INAzFWMGV0w4HwRWrzdDmxnOWrrDJOdYR94mOIcxvXjhoH5QA9QL35z+HFAIKSOaGnsn5iBxbSle00v+czCUmjdi7cvZudHaIMlTYvLa8iRQiB1UP4eR28HCiNLqMGBUc+sXtO1jURWwnD1vmKPFXLM/1UEXL6R3I8fUMMz0wr+NT2Pbcxp8mwrHUNuduhhW9+yE26fzKx2ilsBEJ7wxbJDbduu0o/xKPSRC4HOJggFDJ3SEhP9XsxxGcErAB9/tqAOySM6hoZtJKka+X/uzBIB5MbIPrZn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Dec 2025, at 2:24, Kefeng Wang wrote:

> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
> incrementing their refcount, then convert hugetlb cma to use the
> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
> into mm/internal.h since no outside user.
>
> The set_pages_refcounted() is only called to set non-compound pages
> after above changes, so remove the processing about PageHead.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/cma.h |  26 +++--------
>  mm/cma.c            | 107 +++++++++++++++++++++++++++++---------------
>  mm/hugetlb_cma.c    |  24 +++++-----
>  mm/internal.h       |  10 ++---
>  4 files changed, 97 insertions(+), 70 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

