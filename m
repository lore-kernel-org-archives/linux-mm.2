Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2AFCA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37038E000C; Mon,  8 Sep 2025 20:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EBE8E0002; Mon,  8 Sep 2025 20:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FCF98E000C; Mon,  8 Sep 2025 20:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD3E8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:54:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26C30119857
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:54:47 +0000 (UTC)
X-FDA: 83867891814.19.C07236C
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	by imf02.hostedemail.com (Postfix) with ESMTP id 888948000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:54:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VEArffjB;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.102.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6HAdbHkS2pkF/WGcgz/wbDdPRmXBKFowioIPNEaAHQ=;
	b=SCLI8e00Z4BBmDN0zHhHUNqBC6ILxllBrGCjiPJfdSews9ZLuRKEFBbfcf7ioOXDwlCTDX
	pkQ4//4LxCUu/NCMDBgqmU3Vi0RyaMqQHeEAuLY77ztXPYPasIX9E+Fa8xr+tw9ezJB26n
	/BHj4LFsIRh61slPihOyXIx2qGHxzrc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VEArffjB;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.102.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757379284; a=rsa-sha256;
	cv=pass;
	b=O5wje/nOHmgDcs+yopmUII+ac895bpmXUd2j3Q8mkuoIwTMsFh994sushh8tQQKLAoGtRF
	0WNtcUqGur2Ox9O8Pja8WVhXaCVbdwh1e3k7PoXb2YbVEK1Hg1OO8jdqECFSuYkGmhqJVM
	Dy0e+GBKbYEoRyr4qS7/I26Ix2H9tW8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yo+Tifd0XMaK0Ok80bGqgCjEQ3e53cLxjYTA0HDwaTU9WVcBuaW0dYRKttTmo+qfnuRzLlB22dKpEP06s2FPSZ3tJPbCRPBLxXc/XBuyQCge0Nr7HMUUjuiz48jRnhQ+x/bVKclOYqdDgOs3nEaqX9FubuGzXPFmlk0SVBrFKbCGOde/zO3X0lTFsPiphHaFg6NaIB7oUj9bdY51Ue3xJPBImL9jOWn7r+T0cm019JXTqQ/VOxiJSP2zPSTO3jM72+dtEK+Iwz9UtfClb3NxnEorzVSgAj/fuapH5xvLi6Z8ZTb8CKSTM5q7cVK6luQuJB/sUBKRCzv56M6A8tcdsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6HAdbHkS2pkF/WGcgz/wbDdPRmXBKFowioIPNEaAHQ=;
 b=e8Fq0Y1xGYgAxkpT6JPo2OLYONDVUJdeXTU+f+gcUjkg185BWqEw40cmORZuR5cTAC970XzfHatAcg4FAVh/goG7JoJ5No7Ts4S8IW6Sit88FokWQHlJO6hZbwoHrLi8wx3WnSQguqYkPPLaII1lr1nQ2ZV2uYZlRfqjh7xA4qkPBYlXoz9o3oX0cjr8RLFrYjeJ5ZsBo3v1LcR5sVmGSX+iDMADLlqgDYQzmaUbR9c+aoPMA8dmJxnmrSB/FyV19lJN4qGIA+Ah5ePRLis/w5zT7OpVBQEVC2JClUtG8Yl37ZVgFP/5ALP1psMyXSAVe5CrE1CnfXdZo3ZXNuDhmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6HAdbHkS2pkF/WGcgz/wbDdPRmXBKFowioIPNEaAHQ=;
 b=VEArffjBHNCnocvg+cmUlCK34CWVvBrhSQQSSR/pVvDBrNH2mqQa59GOV+4+noHjDOKeI/ahMC9ROVU/ENaDuEedskzqnh9mLRzgSG/8rt4IxNQlZebVAnrsrG1zMRTYWt7jz1JIPwU2gpb1tf6w9eNkou1tVFgfjdmP58ko5jYXy7BdWITSbv6osLPiefs7nkSf8f/Gno645KRVwdLrkVvtw8tXG5fiW8srzhupnlwiatlYvjiNXea1CMMzSf3DcGq/CyxJo/SdLdFU+U7tMRCggTuZqttzPlV4FsL8lp2lsFOyeOm/BGME4Ibc0bYb/dMQZOaJWwoVPYxKDFxaDA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 00:54:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:54:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 1/9] mm: hugetlb: convert to use more
 alloc_fresh_hugetlb_folio()
Date: Mon, 08 Sep 2025 20:54:37 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <A85807AB-D771-40CE-8832-6CE53ACDABBD@nvidia.com>
In-Reply-To: <20250902124820.3081488-2-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:208:256::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: be36efae-1094-425a-ab73-08ddef3b747a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xAwMiQwaaRXp+wH3mBFJkr1L965cSf090PjUHuf7E6kpGg1r5fI8SnRRTYmf?=
 =?us-ascii?Q?iKSSblUqsdXdQASgcWhYJRn2tpli1KOjbfZO/68vs4Lk7X8HK0svzapPNx9O?=
 =?us-ascii?Q?wmZkew/EIUpGN9TM50z0sAFupe5XLVNlTfvVTiZTJN9zsvzZw/g+WHdqjvKw?=
 =?us-ascii?Q?t4gsAVQFIJ+m6QTpwpDdbpkHarfYs74Nvm+VqafthI/wDzW9D4pJARJxDoj3?=
 =?us-ascii?Q?uIjTeoXxop0YcYNI3scKU28LBPCHCO8UfMpjbdM9xozeUON3/Rpfi3qh1hjz?=
 =?us-ascii?Q?1oDK2KlSaLU/rwDzKLd2IcHjwjPlg2vzHbcqWIkR5/ZWIaGPNlIjXdu1BWL5?=
 =?us-ascii?Q?52FTMeU6nQkzL+uEz2XRJzRK6fuJ9y+w5bdzk+JqI7oX/5T/tvC9HsNbxnzB?=
 =?us-ascii?Q?9dhwBHHV/4J7acmbw//FDg1AVgsPalwIMokAdXgCKooQy5YzDuAu+7cF/HTq?=
 =?us-ascii?Q?yvk9YGnyOMGfBRAFgL7ugNhZ5at7T008z2n+dYkgs284r/4Of5JgKelLlpxk?=
 =?us-ascii?Q?LfGhzl6h183oBU8Sn1BZp5R2SY6WPwVUFZIREmxy4K1EIkdb4YCchF/tkpOf?=
 =?us-ascii?Q?SUP63ZTsEHxzMtAHtgC7fVYVMWwzjU3lMBbxcrSd9/YUoEAUwSe9JUo6SbLT?=
 =?us-ascii?Q?pdLFqtO9XaRT2KavT0GgIHQUOZK3OS7MxKeWq6ML5JuYr5cmuwrCZP3m8YFi?=
 =?us-ascii?Q?fRdWb5IZeYCxvk5//rDpuZSfx3/m8LMiuAtictPKzcMiGgasWofNuByhffun?=
 =?us-ascii?Q?p1Fs3/Vb8qS6rX/6+WyUK5VsjeUJ5TNC8fz8FOo7MT1CrVPlFvSOUeSkjv09?=
 =?us-ascii?Q?Xwoy4adc5r/Igl5o+YKWFCHZlJpdJJZmzPtI2OsktH42i2Fn8FmBmJQ55wcJ?=
 =?us-ascii?Q?b7GL+yK/fZti7EfhwN27fOMOWxfdQNlzs9Yqqa4JIlgTjLTuhnnsZDcxDdCM?=
 =?us-ascii?Q?SLCp1Gox94qnOIzD1N+cnIdog3I1oxoHnyCDx0I4zw+vPA4CZ50QVob+cmLF?=
 =?us-ascii?Q?l3TYy42HGfcJyTfB16dyR7CUwfJtx1/l/8HKJ7rDTQP8ukbjJ6XCX6swffvT?=
 =?us-ascii?Q?R3z8xHshfckrzUGgUJth7l8schCXILV5+5IF++/WA7dr5/0xUQ/jDaVk5rFf?=
 =?us-ascii?Q?/UCzV2lkg96h86lnEPdas2gYfxe19w52SFHI001nJmRoeJtmD1CwTk2zT32x?=
 =?us-ascii?Q?JDpgJICU31dieDf31GMK0G4J4WPUYoBJJBo74jibcCCCzC14hnoj5F++fqf0?=
 =?us-ascii?Q?uIrsqXxzDmzFVZilscdglaSyLTpdTEy8P8LTCTwdy2yeG3e2AJj+ev+r2JOm?=
 =?us-ascii?Q?Z5k/FFE7ei3NAIs4KL0Cj0WNj54y6627pHEcp9z8R0L7K4YyibeUb4ZYGFSz?=
 =?us-ascii?Q?SuV3jfTY47q+F2nkQKLRhhT1I4yisIV3UeVPD/v8l2Z7PiSHLU3/OFDx4Fjr?=
 =?us-ascii?Q?/oh59hVdVTs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3UCtlmG2fVx3O98knNdyd1PMnA2nSKkL/hJ6jC0t1O4yBOVhLbM8hxtJHi/R?=
 =?us-ascii?Q?4GbK5mQJh9hxtARbGiDeurLXf7GOWdrj9f9NdLWDQBEM4QKHuhpWMujzFqnm?=
 =?us-ascii?Q?eV6CW4bn6p3kbyHxi7hD3ixN3xWx24BaO6lAxHXjwcQmUFM3bI6KLYQao+pP?=
 =?us-ascii?Q?iSTnxpm1bzjHFQTwekNqdpCaTc4qE1v9hN/JbQtUsgDd6sN9RAemz97/8HdM?=
 =?us-ascii?Q?bOA2dnAyHgGDllnKceM50feLpJfDiXw+U8FuWOQmSi6KB7CMYSxu5jigbbNq?=
 =?us-ascii?Q?TgGVeQNi6i79YQRjQslvo4gg4cxRGI71BeXY4tHuDuINhVDiPnfMPbbIb5V6?=
 =?us-ascii?Q?SD8oyMaVI24XnFNb23d0pxEkB7oPLgXmAj9Cuy59EhrdBgZtjtBJP3T2QHns?=
 =?us-ascii?Q?O3+Beb0NmjPNMjlhABoGVuZQJ7Fey2pi5oa9LC5QiLPj+iQ01Gn14RBkTzIS?=
 =?us-ascii?Q?BiE4xgLW7T/XAYHnob86gsZbay76q18w3eD1rpqZYuftq+EDpqcGrs2bpbEX?=
 =?us-ascii?Q?0Aoo8sQtYC0ZeK82qFJcOtUAkgjJXmFzOcCn5EwZAdDHMSSd6x1gvoiPLiWI?=
 =?us-ascii?Q?dIsRF5rmp9WbzScrzdYvnOgCkb+Eqj8fjL3J41WKQLJziy+oSwPKNLgvA0aO?=
 =?us-ascii?Q?VSxUQ8ILSWDMCOgVqrzjoVIVO2do42J2tKv17wraAKs/X346veeJ+Oz212SH?=
 =?us-ascii?Q?bJO4KVaHYYVjLyZ/uFFsUKTzFMhDHT2w2mx1r/eCG1eaDF9Ek6s9vBrkUeBE?=
 =?us-ascii?Q?6JAoqRZxOBiixSY2xPLzkdeXqjuXHliCKdt2ZY6+8+IJCWvDhxOaGpKgAgDZ?=
 =?us-ascii?Q?M7Gvxv++ZiyIL+9r758c6JbaAIWjS+gY4WLoZbdQo2d+KUs7/7oTHdpCT7Bc?=
 =?us-ascii?Q?mjGKTjIerSzQ3p6achbuXoGQZITzfydBstlX2CFxEg9Wg5Ol5iuEkWhKVYT/?=
 =?us-ascii?Q?kt5sMzIKFdvZXTJE7j59GJMzMnMr2Um37s5PqYs39OufZFqqhgl9iC9CkrGr?=
 =?us-ascii?Q?t7kmFECk4i2+1SdI0IomBZYJ1alq1pbNdDlWKsYbFLDHHMT1jIkWdry2+Z2w?=
 =?us-ascii?Q?ZTcETzpsTC821EsGwffpgnZvf88mfz3hDP8BSnWnTdUMO3r6D6tNGlcB5YnG?=
 =?us-ascii?Q?QI1BcS0wMsyl3/bKkbYvEX4iYDFNZIuOyV9S0qcfl8GObuFiyovWMmDGpaAS?=
 =?us-ascii?Q?zw1fNUSMDC73rsuq0d+LV3EwJ+qpyM7xgIxx6vIFapwCzvmppi2lROpeWh0C?=
 =?us-ascii?Q?boHu5S8LRf0KnD3lbgM7+BXTg6FPBGNp/lReIrjAzIa0elDT7AhbprRe1w0f?=
 =?us-ascii?Q?c7xelTDIczlGDwjZT403auWE8oBZQhTiRDxaB5U7h+vUy7a9SiQc/cN9E9p/?=
 =?us-ascii?Q?fEjGhaC7+MWoO3gvezIcMRTJs2DllLMdN8Bt8shnkXvx54/2lwUHd0YhFeRG?=
 =?us-ascii?Q?arqiLrZZwhGPyxtRaTWLf4+ljR4oiPhMH0LHCDReQxIfCsWypq/hn9kuHV+6?=
 =?us-ascii?Q?0rF0JuJBOeXO/A38mXYrl77kdkTCmRaRAZBjUQzKtgWIHoAX87+xVxnzOuq8?=
 =?us-ascii?Q?PTOO2uQi0LFQm2R3OhWSvhAQNd6gRc+rHP5e5L64?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be36efae-1094-425a-ab73-08ddef3b747a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:54:39.4021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqUc++ZSqWaHog1J54NyQRp5NhSZvi+g9U7qhMQMFp3t+8GXUmhySwK32IllJjQB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
X-Rspamd-Queue-Id: 888948000A
X-Stat-Signature: ho35e8hytz4prrhiupejaws38bg8u98e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757379284-946752
X-HE-Meta: U2FsdGVkX1/UurpshxpVYbyi59dxBH3We9uAKFU6W+4ja/dnXdp7/og/vxWaVfh6M5waM5yykme0JM9XND6/oppGtwdhMHuZYpGVQ31sOwtUzPiabyxMo4QCZjesJ9lIk9N+O2UJ66SBkQwfc09/dpLsxb/rpv6Wy97vafInkGGqPiGGeC0LK3rzHkomlJuHyx3mcCkWVy80g17d9a4S+bexa/7tAT3g6YmaMcMQBmsQThQ9CS7k9ZZj4vxvZGZfODZceIce/cYXFPz6C13yr/a3SUlc895c/DehuVgEqJwWl5D6FojOsQ+K8swAKS2jdaK5sR1kb5iilgg8EoN+aMiM1HpzhEmU/p/qxpBJrI5dT+t5YHzptWRTWXX7hc3Rr5uE35kWsaUCNkRLbXgSn8RTIcD1w0R622/Vi8YEpkR6la4vTAjZWWidzG/jhuwFlL5SluDyqyeUua67LRFIAJirJT0MDRMuOCHCWlegEEB44Znou9FJ4nax97YpqyyHnfCAsxxz15zJU7E0CD+NcSR8TlI1+7zQdIN8KlZcV/s5Y1gFv86yNdBnzlR6hsXVF+5bCPEOVzTVsFSm/N6VdHUpTrcUuTp71nYbVR92KUcE/e/zxKehNOvx0u0MYFFIKUoAnKlHVfNRyLh/nk8WOKhS2Pi+nmJJmcYgrjhaBIDw1iETWpffA+yMgbEBlDQLNDruwxZZQxgT/ZyB7YRmLH3GSlfhazWfzT4wAu1s36SzzI6Nhp2K3ngftS75xfRn1oORAZKF0MwAmekZbGukuXtPWVZMzskqH8ZDsA3uW9tMErnEEsnq3763wUtu1mR+ztuPcEdR5/WWEGILS18YcQai1bRVoVVCYxJC+U+5YBpuVy5KVPBNOEwlq67W4c3DMD0yHrXiy2O8CvhTwp5NT7qHu464SGsG6iZyLQoYyqcAAR0GTOX+NbMlWi1gLNSS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 8:48, Kefeng Wang wrote:

> Simplify alloc_fresh_hugetlb_folio() and convert more functions
> to use it, which help us to remove prep_new_hugetlb_folio() and
> __prep_new_hugetlb_folio().
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c | 44 +++++++++++++-------------------------------
>  1 file changed, 13 insertions(+), 31 deletions(-)
>

LGTM. I agree with Oscar that the accounting code movement needs
a comment, although the change makes hugetlb code more like
core mm code. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

