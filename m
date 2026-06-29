Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8943CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6771C6B0111; Mon, 29 Jun 2026 11:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FBE6B0112; Mon, 29 Jun 2026 11:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E066B0116; Mon, 29 Jun 2026 11:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2521D6B0111
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:03:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 901698B746
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:03:47 +0000 (UTC)
X-FDA: 84933269694.01.DB58B8B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010013.outbound.protection.outlook.com [52.101.193.13])
	by imf03.hostedemail.com (Postfix) with ESMTP id B542620013
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:03:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YiHj4qoW;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782745424;
	b=zuUF478c8P42ih2Ot51t1URELclgtAEOo58fq5ETqYU2VXh0P92aLLXvFCoRR0hy60yUx1
	IXzcjAmH/LHMjt/S/5H4AdlPBoK3VUbOVRwt4z3m5JQ0p+0BlzZti1DJPSQnyjyWl4qtzq
	ZCE8HlzAO8p5/CeMJd8162kXIVTZiU8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6K90pZSfJWU8xJmLqocD0fGt15EHtm32vR2Kr7HiP8=;
	b=eQBDZjOJqxwLDWpJgdICIPgl4wOVlyauzroimtZUekJc/0EPb3n9VKa92SeFJAA3Ge7lyz
	0w8b69BVTnFaYPAEy1KMws6NoT8lGmuw/SOMllQaro4/iGvd/5I+NeRHG2C/wfvFpkaTg9
	sIuZmVi0cJTZbNZLkE3IZxaalSJp2pE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YiHj4qoW;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBPk2BYWylt0QrUFtF98/udXiT8plKaYjHi/+dXDNDvWqwZOPuOLbxOrzMZLQprho5DWrFRdS/JalDAG9JIbWFmf3nqs6LuooTz1uZdKyJKiHJuhr+XpH141WGNJv/HaTjIdx4M2xdnTL/D7ywymftFHTjFe3kJzZExuf9pqRUTR56AMyniI1BFWI8WgJrgGoJTANAwrbPrS+b7Ot0ALssOwxr622OciM2PodYkj9N8JHn0aysGDFaunCpgFMvna+jlFFdMtYZnBj2n3jpsYuhQz5YWQFtE9R7/noOGGlt0VX6QoPusFtlY7kODd8AEt/PHHTDAsA9QcWT7ANcv6sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6K90pZSfJWU8xJmLqocD0fGt15EHtm32vR2Kr7HiP8=;
 b=PIaLvTklvu5oM2Lq8yYVfLpz8tNJIJ354mttgDqOSZG2YaTO+gF4YsVeH8DDs7R0+3NmUMaxXSlApsqoL5qusBVeiFlheQkYaoL7koMOL1ool2ncTabQ3W8GPQ4E8K2nBG+yX5QIPTuBbMmZR7gmFpN+sq4oV4+YZzDorwwnGTTj6vxL5pOqilqfFjIo6r19pbi8jCPjaNaNOiZDZYcX4KtRpr26vevAPv1lH8RqmCFyfzXMXt5z/ZmbE6BRRn+iUb/JpA//7GS2RX+Goi7RVItswO3nzZmLi3FBGM3bCjEffp3f7ak7uf/8HEOVbsyEfyQFLOXffMHDLY6JI0eN1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6K90pZSfJWU8xJmLqocD0fGt15EHtm32vR2Kr7HiP8=;
 b=YiHj4qoWqboni7N41bYCh8iOCaRf3wTq/8gQAIEz9J6dZsmLtBCr/4BaSN9i7UpP8mp4l7vhkXGOkc6j3ZJ01t9i4qgShdXKqvR7g+rv6VqatzLJs1+VEMZdoF2yC+QMzJVvfMGWIr734J1dsNEOPwjtnYlg9/65Ud60jhKMrNoZ72K/z56HIkRO93bj5yVa0Q+Jjk6TId9ifnQol6jwZcmKtx6xBbdRjzk3QvYeZGmmlNIzS051QS3N4vpSMJoSd1mZOE56hvHU6+9L5mEHR2Os+gj7lXu/iVPpZfGuVQ0lpcrkHpIW7MVzIMaNZfcGEPI3BPSEUmOTq8MmaBk9YA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB999103.namprd12.prod.outlook.com (2603:10b6:8:2fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 15:03:40 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 15:03:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/compaction: stop recording free page order in
 page->private
Date: Mon, 29 Jun 2026 11:03:38 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <4CD1FE9D-3860-4A55-ABCE-13C97DB205BC@nvidia.com>
In-Reply-To: <220774cb-ba5b-4a12-a649-955c83bfc704@kernel.org>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
 <220774cb-ba5b-4a12-a649-955c83bfc704@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:208:2be::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB999103:EE_
X-MS-Office365-Filtering-Correlation-Id: 73201922-ad59-436b-4f00-08ded5ef9a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|22082099003|18002099003|56012099006|6133799003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	B0k2AgBSilynUtWKMJoZGLaw3BYy5m0N0ba+yS8epWyCJobUY5cZBVZCIfquaWbF5D+pCwHXQ8Lx88fkDYMblr2qFGw5c0sRpCI44Nmqfd9qyjOF/BbaCqshvo9dcHSWY0bIUQWOJJyW297mHzbSzk6yMJhzpUmO1SFp2aGk9H/5aTmUlfwWrgxlA2sMrN86zyqNGEA18fyzDvBiY58Z7uUNfgarQ171oSLkqILc6MHfuzJ5AWiE9yyzpNlDQ9BCXMB1miQwEOZDNMlOhrUPCPfM3ffryLUM/HJsrpqOG5RYCDwhmEkI0snZOzfkXcH4t7K/iwx62CyDGnDV2xm/gDXGRyeMJpFpZ6cykX3tj29eoEQpZPA6BR2sWoRaqbSQqqUnMBF9HSHLpMXKZ75xxQFKpD+ULXGYHq9+RJuFwAFqqHUNIc77QlrXgsEWnSfm4Tzoq98U8m4VL5F9QepzWmoj4qVDKzOt4ldbCmsiTtKEd+f6x6s2qn0ixcFkU47RoZBbwZ9QUboMgH6rodfQTWHMScUJWIg8TycmptaZLNEToscgHLrUXz+sGzTyQ7+1I4aCtvVlrJwZvJL1qd64P103thHcCN5ONBLfG/bMr4b07dIs5k7taNNYyIhHUc1iovJirJBZS6YEF6sKqhM876yoBFGYW5166r/S7qMzGw4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(6133799003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z4T8r32oL7Y0n5kve72EaGLjiF6iZfnnbLxyMKCJeKg1qT8nqdAg2LtO94Ju?=
 =?us-ascii?Q?AP1Z9bLzMuEr89n+Vfx3scoRx3hbRYJE8sgEE6l2ewAM3eVDVbcP1k6Mqa9o?=
 =?us-ascii?Q?0DBMdMqdXWZxAbny7sKu2ciJZ7lgEGu8U4KKr3MtfqDYCT8NpE0Jhx6tT8qQ?=
 =?us-ascii?Q?bD6KPTe4RSL8sXZFl5aV/V0FAIiMNj3PGixkQV2vqXmw6xPy3qEhx4uk9GR8?=
 =?us-ascii?Q?oYg3hZhhwwJaErU4Nw7N6caeDp6mnc6UmxaGLEnmQz0ldxzlRlEXLdi60YMx?=
 =?us-ascii?Q?kegHwA9muOaXkB3AjZRiO+SCBclPsCUPmLgTC+b/llLYymfI2d9OYUv9Q+P0?=
 =?us-ascii?Q?djSrkgeD/t2z7eXFPs1RuU4s3uDd0QLmwWAldDU9TByYBFF5TvdMyhcjmdu7?=
 =?us-ascii?Q?7P91GFkQyHeNePcKc99EjSfIMC/WPDvFSGcw9zMoQPHI0LZpeTP7cuqrQdPm?=
 =?us-ascii?Q?UpHFfySw8J0VDjdBARQjRmH2kuR5rk9dm5/GJTbko0Ssa4iMfUQWbsPQhhyl?=
 =?us-ascii?Q?AeJ2B+ywnTPedpf59BhuZFhGWaavdbhpfWcpw4E1p0MIpy4bI7qhgLcEUQL/?=
 =?us-ascii?Q?9eTIv7gYlcs9DZ7U/CDThrXRjB5SqvvVJ0+qSMi8d7x0NJ3HYzlvwaB/afZ9?=
 =?us-ascii?Q?wAoNdfPtpO3GzqORbQN8wiTRTLFi8wY6n/q/68LK8Ai8rpGmjBSTa1hI6YHa?=
 =?us-ascii?Q?c4BEXJ15TkhTdu1H5HyqTetYohcYNt/uwePySHv5pftFSHchtwDZ6hM2svB+?=
 =?us-ascii?Q?im1UkJtQsv2YFXls9ipJXWj71nPpd7CUnXj1hsbUAWjMFxJMwo7eTobC3vl6?=
 =?us-ascii?Q?sPYsoWgHcXCoXy2NLMAl95dOv+wY2V3Ty9agAvrPrf4vXS6ro1Y/lLDnF/fK?=
 =?us-ascii?Q?dZl9en0l+NvZ+DvXs3awWkwlNSTee6mKuILIbT05S9CWdRDua1jf3GRO8g7w?=
 =?us-ascii?Q?OD8ljnMg9wQU6GL0rPQpK8XGNO7cohPpg2NO6BE66vhXDVsyDtYphhONK8vS?=
 =?us-ascii?Q?gEs22oiH5gIUVNMNtK3jrGs54KjYM16rwFIe1ILvRvt966RDuvzJDfssJNeC?=
 =?us-ascii?Q?B69Cs/OdR1py/yU3pLlzDyByH/6YnwoJoHsE78oI43zIsGZDu6rBpsa/lIez?=
 =?us-ascii?Q?q0vIE5yQdeILsWgeAyt6vpkVX1jWQPQQxqxuCFSq8sGnRzEdkiu6LRs0u7aX?=
 =?us-ascii?Q?DqPdTt5vkVoqh/eKIq1LBIfX+Lvh+Oa9LDdqlkAltZNh02/GquI3CsmPARK8?=
 =?us-ascii?Q?TwUmLTujFt9XTxeuZr0FEnPm15dI0Pv+DPoE+gDXEme+FkRoX4dGIH5nEQUK?=
 =?us-ascii?Q?9gHrKfmTHrwsdUAf+bu5tN3RdoWvnFDUUnvy9XRfzZjcJifwuvf7GEwHFdFS?=
 =?us-ascii?Q?kIeNDTKEAzrLM/Pw4eo0NTLRh6Nqkcq8XE/PPDv6H4C9vZMcozwSKe0xzVg9?=
 =?us-ascii?Q?IyQfCxzQuHTpXObI4qfi/3UZsq7jUM8O4d1bJX73VYB2ci8dK1hl1JJxpdmh?=
 =?us-ascii?Q?q1kKg9TX6M18H3znKidKrJ4LgqH3apvgMUlKRrQ0emP70D6ETbGy6BKGasNN?=
 =?us-ascii?Q?/AzR2XHa+4+HMbfvBo+/o4w2UY/NFHAjLMBChZ+CHDBudSr/GHP/sws7mGI1?=
 =?us-ascii?Q?C5m63TpBjV6mpqej8i7OB2NjwyuNz/Tv1BoRCmmV7FmrYouMlefUcKNCArhL?=
 =?us-ascii?Q?qHxW+tn3OMwNLvLhLdTHk4K7Yi85x9YuE23uEz66BUFPHJ7q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73201922-ad59-436b-4f00-08ded5ef9a7a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 15:03:40.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSLWax/TGUJVVhhK5GjofCYdAsEazr9RONh0hOeoGazy2yB6yHG5M1HAeb6L07FE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999103
X-Rspamd-Queue-Id: B542620013
X-Stat-Signature: h8imdj8iz767ytp7qoxyg9uhwikijq19
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782745424-716656
X-HE-Meta: U2FsdGVkX18f3oDQHfhMcXfqt7/+sy02+LrbwNvfoaREYp7UVDSfFiTvGrrkqUlJ4Anbjuzcrre0AXBhoYPeS98mKv+FoSpv30PzjgVbKWm95Ks+cDt0VCPIrI95IhNnG4VRftJiEULyqR+2lIUjeWIkd6LvoTTNkIKOSHesk/PxC/akx+TsADP6QdaGTMLxg05nv33BVQJnmT6Qg8dNQU8pFA1WkKSiqAzy3eyKBZ/IAX8jjNwQ7wSiZ+lSWl8RexBhPjZOkTxRdCMeLLic0GzcjsEVpicEgylu4/8SpiPiBNmn5ferSrNrMlmZbs37GHlWU73FW3afAsoE7o3oR37rOrJev9UljchK5t05n2AGVztObJYGQ4xQ80B6819EYpfwerNmycOCbplt+6tR0OC7+QqsFMxLi+GKrU64k1kCL8uUo3FzUQdmmo+gYjLgQW5xyY6vc69ZiriXpWnS3/47xMXKJRdAqRHeBt/XZuuSi7zslyOP0Gh/09N7THFD1PjG/y5PATWjTaKIlkRso3VCqrOj6YIdYx+QLYW94em3Choi/BnPJXyoxgCJSGleyUJkBu79ubBdGna0mETKhhjI3bPGzEUKf5zr7c2wn+trHEHxj0WV8ek2tiSmA9Nt/gxi9SHfjdVe41H6govu0+ZfZMSfUaerRzHNWHD91HV6TLWpJ+brzOV2w3oATAminIddQwnukjdYMrlnKNeINPpnX948vI/CZ9Rtuj2aZBfee+0lQpSsMXTXsLfVE0SnhFpDUQMFb4jQRSo3Dor7KcQo6Q1c7yoznw2qAYPtCRK6fo+U/rtuw6qleUflYdodPngTIpzFJStIuypeLBcsEvP2Ghs/DRak2UBLMJqILQaPfEL3+nevrKZIakGd0pIiNNMXvcAj2Kr7Wjd2ErHuiIL43njg6UX1M3xvqJ7oAMSwuklNqLZcyPlBSHVcDgetSFrKtGWy29LeZmfHA/m
 0eEw+4nI
 cQM7LbCb2+V4Z4fkChrdJwTTly/dB3YFteiYPcCJ78tPmXppvUEP/i+Hzi4TI4co7JUN1NZQ1UBX0C7k9obLViTc2E35x6tr8cLGgm6Mf5M8NBV4bO9mHCdDN0h3VYjnK5PN75wtc8++33ZMUfljEyMDcRaG3z3WrE/sAGr5n0MXw5mhw0gOIzjYFYIMFXIlWu8+h25zRv3O/OS6RerUmCqi8N8HX9jHBuAcKpONAPRNJo7PJO11S2lJ8W5a7OLHoQJHLty8HQwbRGxTKi3t3AS6EiRsV6Vwg3D3twqxT0r26zJLpCIDjhkrKA/ywhjLsk003j6K66VEFzY0zSuVkWi7jdbEfe3Z8zZydrrG2em++zpg6Nps/Tnq+yCrLpViH//QagrGYS1of4uM+0Gl4T983xGPXz9iqk1XP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Jun 2026, at 10:28, Vlastimil Babka (SUSE) wrote:

> On 6/29/26 04:56, Zi Yan wrote:
>> Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
>> memory compaction.") stores isolated free pages in an array indexed by free
>> page orders, it is no longer needed to store the order in each page's
>> ->private field. And there is no code using the stored order. Stop doing
>> that.
>
> Ah, great observation. Cool.
>
>> It also prepares for an upcoming change that ensures subpage->private is
>> zero at page free time and the removal of set_page_private(0) from
>> prep_compound_tail(). In alloc_contig_frozen_range_noprof(),
>> isolate_freepages_range() is used to grab free pages from buddy allocator
>> and it leaves the aforementioned page->private set until
>> either split_free_frozen_pages() or prep_new_page() is called.

>> That
>> triggers the upcoming subpage->private nonzero check along once
>> set_page_private(0) is removed from prep_compound_tail(), which is called
>> via prep_new_page().
>
> I'm not sure it needs to be said here (or in such detail?)

Will move it to the cover letter.

>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.


Best Regards,
Yan, Zi

