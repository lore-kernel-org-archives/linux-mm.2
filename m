Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80859D3C928
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FAB6B0008; Wed, 10 Dec 2025 11:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06956B000A; Wed, 10 Dec 2025 11:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5256B000C; Wed, 10 Dec 2025 11:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C04536B0008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:38:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E1E960375
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:38:03 +0000 (UTC)
X-FDA: 84204118446.23.F3C1585
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012031.outbound.protection.outlook.com [52.101.43.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA650A000D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:38:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rziNsxnJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765384680; a=rsa-sha256;
	cv=pass;
	b=AQTAGea5ZuaMGP813PsNg21wIaSkcvoKrTs+CbYNpq2PBdmYYjr/H9pI8M7PoS/Qws4ui7
	xmjbS+gi6PaSKhSysrGoFkcGvEaWJ1q1ANnIM4ZTe52juP53ivPUEv07SlEKIqrUQ0Xl6m
	pX0Mib3UlQPoap8WNxK+BjDwUGBM0As=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rziNsxnJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765384680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58vVcA/zjtkNyGncrSDKI/ACEENeevsjztGDeGfMruU=;
	b=fct/0gui10fvsrM8igP3RZEHdGcSQfLBWA0cwICJyfaP2S4BnwCW+nY8naInLSsuaYrBMN
	ILCcqEVvyT6i5AmiwcL47a301SDU7F2JXiR3J0RzsyXytMeBePtB7x03DRAys5ngMXxHEd
	L8saWxeFpdZPdZntVPK2UL+/fKllzCc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TH2vrgchjmfkQiZCQF9FBHKvAKBVm0l2Hki5iXIjCTtr51PVpu//IJwrVpE1I8063jFL2pH9LqJgLKQ0ZH5Qg3cUI8r+9Bp8SPIqAROKgJ5PcyUrmqT6cr0wWojcTagwNaf1HugSs1qmSImU5X6qVJ4XjmHgqE4NeSx2b4Ggng5BJ43eMBF81VZ0lss7SlICBv5HlTIQXL180QAxx8ATxaAkpZln/O/SX0NHVKobJnAuerqlJEX11RzDu83tYhl1R13sagEGq7PuTiRNiV3KlShXORjnuZhBoMcvm8nuM4PdMKSiPcA+AGOHodA/GonfxRUSDlqytO/knPeUw5tO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58vVcA/zjtkNyGncrSDKI/ACEENeevsjztGDeGfMruU=;
 b=TL57XhNnuV8ZSltFeUKebxCceaV1UN+6BackvUIU7nzYGVen8jNA8zfOYMMWFvmnqtF14pn7cwk28fH8A6nb+nTebhhPCZLuw78ZwcCMaqWZ6h9e9UYhNf65HaL0l5m17/ScKisw7oEwKtW+Wm1fIRIhIKsHzQRSF4IR95xoQZlT2hfxkFId46VTt5w1CVB2Efy/WUwZqhI+XVFZTlxEDm9JY7jYXwGZUFxbDusejo2K+R0rrUQvZaMJdLYJwFpXYKfI3y36vfUeVrqJl3DyIH5q2ieL05VX3G//dg0ZRdsqYj28Q3mOEkLbMMZ76zF5wopuSiNwWDQsILcmGJsqJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58vVcA/zjtkNyGncrSDKI/ACEENeevsjztGDeGfMruU=;
 b=rziNsxnJTcgxdkYB5fj6w25kSgTY5lOmV7FjvEjXLYqryNVzB7BxslNUQNUIviQ+j2Osv9a8yimXV4g1/ztqwdIJL9q7r4AD2SAZQkAl49EicMeD4ARUcWXMScicZGvm/AdA9QXuSiWqYzNG1F1EgVUo3XpTODa2J8gO1p94BKG5ZwEsVp6Fno2rdHcK5lp1Hbv4s7l4vr+K0jwUbHak+x18dBgEQGIp9gYtgLcp0x22xaOevB+NSgTpNtgW59xqWbVyoqlJBQlZzyRAzD0wTzR5+IhFrVEoB57Z8nF1R1UP83Ubh/KVI0Iicx0jdRwyIlMF8fGcis2I1nw/JCmLSw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 16:37:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 16:37:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>,
 Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com,
 tytso@mit.edu
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
Date: Wed, 10 Dec 2025 11:37:51 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D498FB7E-1C57-47A6-BAF4-EA1BAAE75526@nvidia.com>
In-Reply-To: <aTj2pZqwx5xJVavb@casper.infradead.org>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <64291696-C808-49D0-9F89-6B3B97F58717@nvidia.com>
 <aTj2pZqwx5xJVavb@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0012.namprd15.prod.outlook.com
 (2603:10b6:207:17::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a03b19a-5972-4210-9017-08de380a7839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZgkxCnEo8iS97lIgdAi/ad9d3nuwlT6QJ6ghXOC0xJBLAUYzV/4mouvkQvnY?=
 =?us-ascii?Q?zFN5Km00heorORwKrO13eh9lSlNYUyI74czo2/Y1TE0Jxa3jI9sohiRj7yiC?=
 =?us-ascii?Q?nGJrUkYmbXxlzTEkBW2NlSuPEMt02v75zI8wAmcpAEDTT57MT1wP/EAyAnpF?=
 =?us-ascii?Q?cfm3t3qsdG3AdZ32ZY+vt57y0VlEf4Qa3YUwfAz0NnZrqT/HBhxn9XcAMlt5?=
 =?us-ascii?Q?L1D75jnGHt1/jcVjgvJsbbbfMa1GYwqg3Lag2IzamcBB1kbevpeyldCXISuY?=
 =?us-ascii?Q?wdEto/oy9bbxVCJaYQ/+BpJtm2d8H2HAbSiTH1lW8sDuylhNp+fRYA6OiizT?=
 =?us-ascii?Q?sqGDTqsGdVn6bH4ySDafQmZ6VTqMDTmcr2vqw+9TATiEphBJiN/eoyaNCY6/?=
 =?us-ascii?Q?aSjvzS5TXByw0eCax9UE+3JY1hhJjgbfn2wkcpwkgHauAnpN2W+uynqF+DcJ?=
 =?us-ascii?Q?cWSfaHP7TKrELuwUClUjUbd5FXcXAulD3S+EVMx+1JeGLc9nyGNpNms2YtE5?=
 =?us-ascii?Q?ArkJSEyJ6HScDQdjEyfBjLgjcGKL82AvtTYGQkBZU132/ufJGvG767sgDPwl?=
 =?us-ascii?Q?rdwL0oaen2UXz/IycqnPI6MCBCkrtKrS5FqJNylvaP2qJDMj3hFHCpIUYxHY?=
 =?us-ascii?Q?Ympsnb8XJIVDnwOCeVd+GU9W2sFG5EVR8A+3YB5OfQpJeS17qjfGnQcFXQIU?=
 =?us-ascii?Q?7QIx1PEEvQG909BSCam3Oq8lyBInOZ2ntBF92KZu7cFupyfMjo1GQCY4U+5P?=
 =?us-ascii?Q?oPzRiHPUZGglqr/ruj+WPpqMRctdLLwaKQL/NGnKsNXX9y25JZz3H5iXtqvk?=
 =?us-ascii?Q?ZYiDeea4WSbsHPtFw5ENmJ4xM4RCWEcIGVCzXjUygisiH/FFSk+0snBLM1nc?=
 =?us-ascii?Q?HN88G1v9kVllzyxAPW4pN7MyRVPsIA9Qm5GXyN51cofhKINR41EmuhPgiOwD?=
 =?us-ascii?Q?pogdYoSAdKgasLHNd/zjWT4X/baSshfZxjQ3ryJ7OZX6uE2NPwhMeGuMscu4?=
 =?us-ascii?Q?K84NgixUkGVT0ZRsQxDkvoEVkHy/65EdAOllRc/UAGpy0CW4WKjvLcWBGuEH?=
 =?us-ascii?Q?XJ/tO1HmQp6O4XRcHh0nPiw3LJVJYUoBLkhRNHZ4/OkAPKw/RSSJHHus9Sbj?=
 =?us-ascii?Q?HqqrrhvImt5wUH1kK8Ibl5bYULnYcQj4+o6+SwbZ2vVgSovO3/1BVijQPAro?=
 =?us-ascii?Q?5Mks8jHjwgJ1jtbi0KG9Rl5cNR7FZN5SLCiwofB97shI9uQls6ejmC1iOvFH?=
 =?us-ascii?Q?U3FbWT9oUgeHFiWfF3GrT9CXo7CYLb6fpCHWA9eISH5pUGH7Ik2bwvV8L7Kn?=
 =?us-ascii?Q?IzKO7VahHcDCIFWX+DTp/EpOd2R/S0jQKY6Rkn/J2WznG/bR92DtLzhKk98z?=
 =?us-ascii?Q?PtJUZSYNgMAb35T4UDsS9no3a1UEddf3WBC/dWrq5gerffC0lXQiswtfuHo/?=
 =?us-ascii?Q?s508iJ6E39V1kuoJPK5Kccr/7QzJ9++V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9oT/hz/Qyw6YWeU7QPJVJcoTqP+RijeEdrcK1B9DY1YIUw4X4kSGRDVPY+kx?=
 =?us-ascii?Q?CyKoiMvEpr3brMdsBabkErrZzswYPXkOi0Cv0stfvKHDhb2Ft+KRrmiOUGwo?=
 =?us-ascii?Q?TXG7/PnZ6nWVgzZ0C0XsDdJa/josL8q1hU0pRkqI9dDx6CLv2PwDghoss3+V?=
 =?us-ascii?Q?xq7NvhpAMzO8d/KCB9ssPIxUQ8W65fZAVKoUdGoZu7hROvUExEFGDBwdnHPo?=
 =?us-ascii?Q?/vGOTTpxVBO7h0A5/GegrQkyKJSollbWhpK162TrYjUhzq9HTdmTar6UA0GG?=
 =?us-ascii?Q?QueHQU9dzN3tQFjFxhdA1LXQQuu0OWnZ7zbrPSFgzD3TA+r2Lu9TMeGqAEYQ?=
 =?us-ascii?Q?PLd0CLXS/Ens7DTw805Ppyx+0hj2woqAiUUhqG+MBSp16YfQnsdbiNGCN5fb?=
 =?us-ascii?Q?KjSpsGVFw+JTEKOqTHPWs9ndJOUM/+YAyT+3tgCbZuhHpTHc1ENeYZyAIXtD?=
 =?us-ascii?Q?WYTTvB9j0ckKvjMgKqbYaOYbInijUEbj6Ph1F8e6rLqavM0CYBaeIvAuGz5b?=
 =?us-ascii?Q?vANIX/m/yMxkWsXLITQyKJie+xocoW3Xoh6iGKoPlnrjOupvfWRnLzjKFymF?=
 =?us-ascii?Q?IpwSoq1t6yRVB/EPW2B2p2A20MrbGMgyNPHhkCbAQ2v8luba3/087O7GUy9P?=
 =?us-ascii?Q?hDjn0Z/4h3Jxwa/SOKv4OHnm8YR4rgbiGGXcftoSH2HBmY3NuDtEa3OcouZ3?=
 =?us-ascii?Q?JFj+viJWuaKW/bYaX4TTDZgRj9RQTG3PzHgyv8bTTwzEq3Srfm4RqiE6733z?=
 =?us-ascii?Q?aUDKtY9TfaxZEzg7+jIeSqEh1+/JrSJvBReRWg/6lzkHD3/FQaH+1zXPAXmB?=
 =?us-ascii?Q?N/5jssN+i0PV4BY/3iWoDm/lv8xiJmdyPyRoJIQuRJMEAmkBseKyG8EZshDS?=
 =?us-ascii?Q?1TFxD4DdoX5iZcM2DH6qGmRUGrRCHNyWXnpOj4+Xz6odvJ9xtRJorxfkKjWf?=
 =?us-ascii?Q?mLLqYQgfXm89z/zittECAFAFBBMTY5Eu58tSec9JK0OhqhKuHJF1xsG7NDED?=
 =?us-ascii?Q?mJ/czWLpUAbcZl+hlA+35Xgp0e75hoTP7nhxOHb8kl9u7l8YPgF5FRN1srna?=
 =?us-ascii?Q?klirbZoalmhrH1HjRhJ79EnYezdnmS6pXmdvUxbylfWggN7Jg8GO45n4KuCQ?=
 =?us-ascii?Q?GxWjnhCgjtr0CequTKNJrf+7RAW20ZKNBAlKfoaovK/5WGnMtaHqDHsAo+DT?=
 =?us-ascii?Q?Vd1/dfZVh02XXMLJGKbfmr53TEEzJuvfN6ZGPqik+Ykoh4PWM1BKk+rNKKlr?=
 =?us-ascii?Q?siYB/eciMREsRQQ9rBoQTWmVkv+U42eO4F53STLlefeamWG6GqQD6cdI+OtI?=
 =?us-ascii?Q?ggKv3qECTOWVxHpyk4NDLVvzzh1I/Ted3mHncpyKk+jcGhJqe640cDxsriZY?=
 =?us-ascii?Q?UhOkz5pgyXjDiPIN6C1/u60gNHNhIhkd6oi0hlOsMn6egw7+PYseJehP4a1R?=
 =?us-ascii?Q?zV6MTYO7oP3vHtuI6PYk9AomfINA76To06k8P3YecE7nn8OHzMVuFMcSIAIX?=
 =?us-ascii?Q?jGo9W9k0wB9wPwGnhzOfG5zxr2kfdgcsyxBALSetQgGXG+1H6YZxvfu8N7N+?=
 =?us-ascii?Q?dLEZtRbHRs1B7S75MEbw09vrZgdptDvZtupZEnDm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a03b19a-5972-4210-9017-08de380a7839
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 16:37:55.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQnv7Y399rAcNbvZGTgVkPp30Fvg+sdCO6eMJW6KEuPKv123y9SvIFObpv6i51gl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5873
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA650A000D
X-Stat-Signature: 3tcogkya9fsproixc5ahnzenyz7shsno
X-Rspam-User: 
X-HE-Tag: 1765384680-142014
X-HE-Meta: U2FsdGVkX19smse3InLHTMKQeq0AkUFbNNeZHNNwQaaKVrP3Js3mvX/RKxIlyJt+0QebQFaHQ0DQSs9SvBypNlS61Lo9i3eb1euLSisxB5CodoleJgQyZdqVeEB0KwRHmkA0HDgJxBXqxbWgkRdFFOPrnLzssnCpXva1BjkClL8YSI/XzVSWQGV8SDuAK5BNlHl12wP0Aybk+4xy8ZYrr53BJb50TvH4MLlGVC8iXra4J4XqqjOfph7aNUpgc3DA6/NVTik1UIm9FDcCIeh+F4pUbDj6AIg476Q53+rWg5E3XsgyT8YQLFLEDJecr5IayLKjtjcJDn+KYcYfq6dBlceGRcSpEiJ37uXAyeQQZAIjgS0IXqkjGTlT/LwtHnQpJNrNifZ5f+rJqu9a0MH7H6BDq64RVR5dhoOPv2YyorJ6zENP+s8MgblC3QGrFwykAf5XgMmL+NS+SaS7VZ3KXUUfMLHhJnEn45OdsEi3cSPjmoLqJSrd02nxoGIRq7DNcMOpS5OthLF7QntrnqPUhZhC9ZR2HJQg9kDKg0DQyMWe++GxJHSIP9B5zARPOJjhTjtYqxtK6IzqidcuK/O6bBEZ4Wh1DVCjVTU6uSsbJER3VKdaU/HPb+E+Rd/IrkaR711fTrKDJSmFlICDKVgqnH9M51YeRAP5ozpyV8In3dWI5m1ALUc7Km2pw7zyUtGB49dEpKzFNZZvkl3SLPifcvRxSWGy1a0z2tOb86mIi3kDNUIjQkLQb7VnlOSN2dCEkDjsglBVqwnDSIbNh+0tJrThnrIrp22zaTceHM0+cYBaASlaCq6b60qe/MKlxH3CCHB6P7x8K9TU5yVWit9m2iI/CQpO5b7Iil57hQ/nLzvpZHiK7PnlrcFxd/Ey8junyK8R/VvAIbl8Eho+a1OLWPYlLc4NzGqA42eMdFaBVVmPzfERzFwppG10jaPgcizeCILC9MIVEPX4b9Z8c3S
 d7q8cLJ5
 OQpBoTErDCqrKpxb/xsSilVXC9ikbAU0rmmMerPZA/3tlsffpEXKAXiTXOCprUDlcssc9yeKJun7kF8gaQ4KZRlCZniuhZgfBZNX9qoNLSMnif+leyUNFZ9kbkarUjKbUBI2oeCqBBBlTwfwgeyQrd0S7eiAR+qJoLtjfSkcq4WfG4RfpBluNKr+F/jMdMZjow4xafl3YMcnFfoiGXU/f8aoYN3aLLcLYwAdQ3Aqf5Z2OJdoz11Rw98jz0ZTt3YdtXc5URzkT70FeusisIu923UMhFl07x2ua/UfFIuSlYDU86OQXsxMYspVu0Nr46bx6mpUKadxP4sRfkEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Dec 2025, at 23:27, Matthew Wilcox wrote:

> On Tue, Dec 09, 2025 at 11:03:23AM -0500, Zi Yan wrote:
>> I wonder if core-mm should move mTHP code out of CONFIG_TRANSPARENT_HUGEPAGE
>> and mTHP might just work. Hmm, folio split might need to be moved out of
>> mm/huge_memory.c in that case. khugepaged should work for mTHP without
>> CONFIG_TRANSPARENT_HUGEPAGE as well. OK, for anon folios, the changes might
>> be more involved.
>
> I think this is the key question to be discussed at LPC.  How much of

I am not going, so would like to get a summary afterwards. :)

> the current THP code should we say "OK, this is large folio support
> and everybody needs it" and how much is "This is PMD (or mTHP) support;
> this architecture doesn't have it, we don't need to compile it in".

I agree with most of it, except mTHP part. mTHP should be part of large
folio, since I see mTHP is anon equivalent to file backed large folio.
Both are a >0 order folio mapped by PTEs (ignoring to-be-implemented
multi-PMD mapped large folios for now).

Best Regards,
Yan, Zi

