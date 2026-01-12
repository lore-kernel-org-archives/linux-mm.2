Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA60CF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D776B0005; Mon, 12 Jan 2026 13:59:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7009E6B0088; Mon, 12 Jan 2026 13:59:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5848D6B0089; Mon, 12 Jan 2026 13:59:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42F8F6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:59:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C54CB5C28A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:59:05 +0000 (UTC)
X-FDA: 84324224250.03.DAA7BE8
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010035.outbound.protection.outlook.com [40.93.198.35])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6DF2C0012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:59:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Xmoi/2vI";
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768244343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imp5Rg8GjKQy09882wThPb+rwyfcaCGvnKsPwjFEaXI=;
	b=bqpurQ4nGA+QCtC286E7mVcA4bihhcxPMkZvSsK3/Atu/6ERtxb2MuASRr6FSDFwptIS4G
	ciENXp9Pgc1s+tTsKKnvvnJhxD2yyid21z6Gyg5dMa+Hm7uKweWRBRMfKTBWyJKuWOwNHK
	+COwK7P54lb3lxm7erdAUSaJYGMfGcA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Xmoi/2vI";
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768244343; a=rsa-sha256;
	cv=pass;
	b=pEbXpm/OZPPjzfFUUtOLU3SXvaV8WUxVkw+9Yutn7JGrK/WE45KMtVJmfC6qgtlav4u/MF
	D568783pIPsYJ/ONHx0qiQjABWeKZ9zcd5eYfCC8OXiym1wB+u1TjZOnSqxetowsCXyVra
	DZgGNTSl8QukLU1+Gq4KK7WQwFC7Dss=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/jiW29etrzWKaMs9d04DErldxK6fzRxXXaNMkiVW9tAdtCaCVkRJsa2JY1w1iQbXYzKbzx0D/XnN2BHjvtuYYcaji3s7GRiYiJeS8CnXxC+e+HaEpFcPvunfzOStj42w7uDOiYH5HUtJRoNlH9iLRB6d5dvKZFoTeXrp04KOeqYG1u/4XE6lNATytjijZDwey1rGef40jbtcopnibqRTJNxdnU6F/GvHG8wOCtox5aLwxnLytVHm5yXSkBJjZhgfm+bIF6GFuNHPSFUtLNOmyrKgkSm/ko3xnhYHxMbL/tevH9NjFyX3SDP1OiEJ5ua9UrK1N4fvTCGWdghXNHAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imp5Rg8GjKQy09882wThPb+rwyfcaCGvnKsPwjFEaXI=;
 b=OXUcVDh6lVrqeRispfallYaO6hQxGqLNFNGiMkdh1hk4BoTH37550Uk+TvygvV7L7ESh93yNKsaXry+i8AjZBkHSHCz8rj4Q6MtipaI5j/0P14vUg/so73OwW3xg3Dy/TRz787Nen0yeLrxbLZWng6Lh2zqQ9LZlQ8nd9j8GcsnvG9xaORRq+N6zOuDgaHignjl1lapxIWr12rkGGfXXGNuMWtGn1vbNmbGFAQ5wq81/tszWnk3hNvyR/mpLsF/ep2HEi0PrpneX8PEAP7bpTfzddyWUH/c+57RslaTNLo71A1AD0srWLtqArOMeomJ+SRRsW+O3Uy7XjIJPa6DfzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imp5Rg8GjKQy09882wThPb+rwyfcaCGvnKsPwjFEaXI=;
 b=Xmoi/2vI3yU2s3pM+AGC9UeenEuw8ljJ2MDmwYm72/iKyXs62Wrh+HAP7/HD3YED/UNPW8s/DiJYt8WZWzgsY9yNrXsvC3UcABI3hcRCxhFfnkW5QyJRjMKu0+oV0moOEJ5JolMX7UMrbSVEoF9oUf/L/kWTI9ULFPeN2LY1HyQXgmALnVTfVt/HosNiv5kLJNVdUSOQnpUrLQ1hpGs7h9MxlEGFSxlQOyDoDwgNtQNR4byA6ZdHErrF8FGTS79s92ojwEoJyzkZZu9jcgZXgr8R0lnfFfn9PPrVS9tod9+4Sdry4TRQc3zd7xoM9/UC8hTUDYzBitReUUORTZJJcg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB6939.namprd12.prod.outlook.com (2603:10b6:510:1be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 18:58:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 18:58:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v1 1/2] mm/page_alloc: Optimize free_contig_range()
Date: Mon, 12 Jan 2026 13:58:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <48E7570E-0C7A-4082-902E-52984A7781EB@nvidia.com>
In-Reply-To: <03ce2f9b-9a77-48fe-89bd-0e1e598ed85f@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-2-ryan.roberts@arm.com>
 <A10AC2A5-416C-4820-AF9B-D3B6946E3346@nvidia.com>
 <280a3945-ff1e-48a5-a51b-6bb479d23819@arm.com>
 <700A6B2B-9DD1-4F8D-8A38-17FC8BA2F779@nvidia.com>
 <89dfd2d0-cf28-41c7-be9f-b49963e77aa5@arm.com>
 <21E14DB6-DA70-4F7F-8482-12DFED81153D@nvidia.com>
 <03ce2f9b-9a77-48fe-89bd-0e1e598ed85f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: 33682a5a-7c0d-4f46-2149-08de520ca2d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHczY1VZUFBRcmVrM2I3QStMTUhqWHMzQi9CSDFYMWhOMEJ5WndUUXdva3lH?=
 =?utf-8?B?cWtNYUFiai9oMU1vSEh4TUZJdlhKS0lEd2ZiYUhpOERxWmkzdS9WR0hnZ2s5?=
 =?utf-8?B?QWMwVjZ2bVpUT05BVnlxeUR6bDNJZmw5clpTckNiR0VGVlV0QUFmNG5ZL0g1?=
 =?utf-8?B?WFNJdGtSaHhNN3g3c2dRWTVjS3RlUGNXVFB0azUzMWpNQXNyZnBOTDBYWUJr?=
 =?utf-8?B?NHZHN0Zxb0pMZCtlSlRDMHhBdVpGS1JTaHN5dEJIdVZFMUYwZUY3OC9XQ1l0?=
 =?utf-8?B?QTUvRHZlN2YvUEdmM3IvcGh4YmtNWTEyT1JHdmVwbE1iY0pQd2F2YmRWS2xs?=
 =?utf-8?B?Q3ZuLzd5NmNDR0d6UGJIWFpjdWlHRlJWb2xIQW8zaWNNeU92cEV4V2tRNVdX?=
 =?utf-8?B?TUgyb2Rlc3hvR1U2TUFjQ2hoYWo1K1hoTGVYUXk5Z3B5ZmhncU4yR2tmTktG?=
 =?utf-8?B?cGNyV2ltS3Nnd3ROeTVsMXRVT3ZTa1JlVTZ5MDc1WGNrbWFQejlpRGt2d3pD?=
 =?utf-8?B?ajFzdVl1K04rVkI5dStDeFhsenJpVzNlamd1blgvdXFsVG16RWJUSXcwcWVG?=
 =?utf-8?B?SjhKT3F4WUlmV3FuSmdlNjZRRlBWSU00OXZPK2NPQURrd2g0eGFBdVdyUmYw?=
 =?utf-8?B?b0ZPenpaNTRBUDlha0t3OUt6UDFZYWxSajdmT2pDOEJDL2RhSjV1MFZZZVJp?=
 =?utf-8?B?akRLanVqWVpUR1hIaC9XNVc5c2Jxc0xYbmNodDduUzRCUEhhT1BkUk9QWFdG?=
 =?utf-8?B?Q2c0ejY5UmZsSDRSMGhVbThhVm54bUE3eWJrTnJ1M08yeW53YUVoYkNoZzdH?=
 =?utf-8?B?NjBXWGo1ZHg2VG4zeUNQRmxxUnNacEh0UjA2bzR2cG5BVlJON0p4Q1IrZDl2?=
 =?utf-8?B?M3lqREZvQ2NWWW5ZQ2lZay85UXh2OGh1elA0MDNGZXVvSXU4V0EyY0szanND?=
 =?utf-8?B?QWIxSWdGZlJmcThiTGUrcE0yckg1aEJ5a21iVXkrU1IwYW5iNHFNQVJ1NTFS?=
 =?utf-8?B?SnR1NHRrams2SURLK0tlc29sM0UvM2pXZGV3VkZSdWtQbGtDNFh2ZDNFbUNl?=
 =?utf-8?B?eUZlYlpiR0d1bTFkZkJacGNjWnMrdWU3TEhZdStFdDlOcTBHZjBFcmVvUFRn?=
 =?utf-8?B?S01HZFlpdzVmQk1ub0tUNjZBMHd3NW11cVJsTXozeGNyYjhMNkc3VlVjWVk4?=
 =?utf-8?B?V0NJTEV0V3BjdVhqWTFnV2NQN3B4VUlaaFFDcU9rOVVsNVZ4Rm9iMktZNXBC?=
 =?utf-8?B?S3M2TnZBOEhnOUZjQkFxazBXWGVNcG1TVXZ6S3dBdTc2ckJ4NzZkZWZobEli?=
 =?utf-8?B?ZWZOZkFxT2Mvdlc2T2Z2Tm1vMDF0amMxb3QwRU1YdWpoYkhOTG80TUJCMWov?=
 =?utf-8?B?OFl2NnZUL1dNQm1HazBqMW1paTUxczd5UlRmK0gzZzFhbGJRYlFHZnJXSVVC?=
 =?utf-8?B?aU5qWktkWFBMQ1MxMDE0NTZ4WVIwMllBOTd4VEFHU3N4bG9oR0JoY1NSSlFq?=
 =?utf-8?B?LzhNZFBnMnNQUEJOejhQTmV4dXMxTFhwU1lkLzlxVm9adTJlOE1VUkhZbjlT?=
 =?utf-8?B?aXAyWXE2ZHh4Z0RZY3IvRWpxb2ZmR1VOY2NBR0pXSFRpRzRUdDRXTmhscVBT?=
 =?utf-8?B?TndSMi90cUVpREREQWlwSFY1dG9DR01hMXRkS1dpcE5vVm1iZU5PbU9BWkdE?=
 =?utf-8?B?T2YwZWgzOXBtbk9qQUI3d29leU9acDJxcEk0amJtOGR3TjUyazVIWitZNXUx?=
 =?utf-8?B?QVpMTlgzc2t2T2hPcUxRR29KY3FGeldOQlM5MXZuZ3craTg5c2xFNytuSWM5?=
 =?utf-8?B?U2wvVkZkSy9vRllpb0ZXUmVFNE9DTStSa2MxOUZLOVZPT1VmQk1vNHllVlk2?=
 =?utf-8?B?b1F3TG1peGkxV1hyckVuL2E4Y1BLRjFPVkE0REJpTUhqN3owVmE2aUNZU3Bx?=
 =?utf-8?Q?NOusPFX/xC40+AWZMs+ug5fUfnbifG5H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVpFcUlHYnlsVWd1dXlGU2hkOERvM2wvUTV1U3ZVUExvWHZzaDA4Ni9DNXNR?=
 =?utf-8?B?VXI3dnJ2azJJS1N1dy9jcnltdkZKMUgwOTdJa3VoeEd1WGozelpiNDI4Z0ZZ?=
 =?utf-8?B?ZmpNVkUvTkExOTNCUGZMK1dQV0NtMERjaTF1MWlpOFdEYjl4aFB4d1VKT1JJ?=
 =?utf-8?B?dndIaFJERHYxektpUUhrbVZHZWF3NkFlMHY5ZHJvdUh1V3BxYlpzMGE2RlhP?=
 =?utf-8?B?UmlvejEwQlpWQTNkRVhlWi9UdGRaSjBtRXU1ZFFVT3VHYitsWDBoSWpoMnk4?=
 =?utf-8?B?b1p0MzNKakV1S2JIaWVGbVkvTjRYTzNCaklaaVRRVnhLWkNPSGtyeVlIOWxU?=
 =?utf-8?B?T2l6MGNmcHhteFE2UktobkcrSW9FQkxLMldSWGhOdmsxVUVtbTdBT0xJeFRW?=
 =?utf-8?B?bk90dWFCK3VUWld1amdDSW14b1pNZkZTMXZvUWdOYUJORENnUUJjWFVqTlU3?=
 =?utf-8?B?QjlGRkxoQjdJRmlzU1k3aEhQSFI2MHdVYUF2d3JRbXRCcmtKNkRrL3V4Z1BK?=
 =?utf-8?B?TEV5UjdCSmQwSFVveldqSnppa2g2dHh3a28wUTNiSExWVDNCK0lHTWNMRXZr?=
 =?utf-8?B?Qy9XY21qUERIT3dTNHFNZ0Y0bU1GdEpsYlVHU0VnZ0RCM1Iyb0dGS0gxY0pP?=
 =?utf-8?B?NVFzdnUwN0ZYMi9lTWYzdjY5RXFDeHFVamFyanhiWDRRV2JtL2pYdVNtQWJG?=
 =?utf-8?B?dHYvQ2JUZlkvM0J0eGcveTFYdGdndVRsYnVoL1JZL0Nrb1dZTk95aTNicEhq?=
 =?utf-8?B?VW50Z3V3R2hFbzBFMUhROGFKTFBIK0grOXZrdHFqeEtmZnZ2QS95QVBIcGJ1?=
 =?utf-8?B?QkxkcUJQam1IcW5wTWpINjl4VFlqUVdSZWdqUlF3YjFNWXJQN3VhQnFzQ1J4?=
 =?utf-8?B?d3dQWHErY2MwUHJVdGhHSi9qaWtlenBhS2ZBb1B2cEhqckwxUC93MmxQb1NL?=
 =?utf-8?B?YkRNOFU3K1dJNENJRjFEd1k1VlFVTHlkRkNWV3JrMzh1RllRQ0pqTFB1VGFs?=
 =?utf-8?B?SGFmQmtlUXZTc1RLaWNqUTlKdHMvbkY4WjY5aWRrYjF4dEI5YUpFVjJ6WnBT?=
 =?utf-8?B?bHlZdjB1K2RQa0JmdWtBdmFKZXlxK2lwc0JZb0l5ZGtKZDhBMWsxQzhrSXFP?=
 =?utf-8?B?ZkdDcDhaR08rUzZVMVU1WmZyNXRyNWZqWmFIeWdwTTFsampaQzFMcVM0ckZm?=
 =?utf-8?B?czlYcWN6cUhVU1lWdkxmRlRpR3BiVFhDSXRlblBvQy9kdFl6K2JVU1N0V3M3?=
 =?utf-8?B?ZklQVFMvN1NkU0RoQnp3Mk1EdU9Fb0swYThhdnpSZFRseUp0OGpVRjltN0Ni?=
 =?utf-8?B?WFN1VktiMFYzMEY5ODJmWDMxdHdhQUtUQkdzWHlNeHhmSnQwcWpRTEREdmxa?=
 =?utf-8?B?d1pMdmFnbWhxVFJjR2lIWmJ1N1dLL0R6NzdSTHFaYXNQeTJYeWJJQ3RIdDJF?=
 =?utf-8?B?RFdzZjFkaEl6bmJ4U1ZNVFc1Z25GRGV6azB5NUZwRzFFcjJuYWdXZENyVkx5?=
 =?utf-8?B?NEZMV2FaUjdmbDBnbmlGVnNBQ1YvMDhOdDMwcTNqOUpvcE5wWFpCa1QvSzFk?=
 =?utf-8?B?QlJvUzIxb1NXNUNqVHRCSkJPV0h2QW9QT3lVQjBQSWs2VFVPbVhGWHpOTy9y?=
 =?utf-8?B?bzFoa2ZtZWtDblprd255bXBYazA4M0g1YnU1REJTc0JoYS93OUUrYjNBWloz?=
 =?utf-8?B?U09HR0xjRlU1ajN4QXF3eHhPZDhxdERwUlBkcFlDOEpqcG9HWjVrcThMYk9V?=
 =?utf-8?B?c3Rtakx4cGh3VGtBWlZRQVVwem52RVhTdENTL1FBNEdLMmJiTmlCaVZGbS91?=
 =?utf-8?B?cVRJRU85RHlwdVJTcERsZ0RIY2R1MGtMMzczWmxWTlJOYXhTL1JiN3ZIN3RD?=
 =?utf-8?B?TTRyekRWMUhVR0w4dUxBajRXUGFGVGJyaTBWNWh6eE9ZRVhSUHpCZnN0U2Yz?=
 =?utf-8?B?a1FneXdQamhVeHhEV3ZDcEpMV25ZNkxXSHhSai9LOThocTRWcHhtb2p0T2do?=
 =?utf-8?B?VXJ1MHpQK1FuYVNHcFQ1NjF1OXpUTW0raEZZK01xS0t2Rlh1U3JFNmdzRkkz?=
 =?utf-8?B?YjJBeGJpNUxEVVFIaHVFZEFPbVEzNXlnYkRoblBIY1ZQbnRKTGkvRWU1aWNK?=
 =?utf-8?B?dlJqMVozWWtFSXI0T3FXdHUxbzFWQVBRVEpFejMxMElLWGZPb2cyRkx5ZVcz?=
 =?utf-8?B?SnBTcjFRMVRmWlk5QkUzWC94bW53WkFvdjRIZ3JpbEYra1lTb3VJbU41NDN1?=
 =?utf-8?B?Z2lhRnZqamhIVVdrZFhyTzV1OTNHeXBoNmRoSmdvdi9EeUFxays4K0orUmlK?=
 =?utf-8?Q?jM3f7AnziCAJN4oRib?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33682a5a-7c0d-4f46-2149-08de520ca2d1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 18:58:55.9420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3eVBfbtRdJoRfpiSub5rOd+cyUT6NCZdrC0p5MFkF8sKd9R0Qczuw60kfOLTkH9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6939
X-Rspamd-Queue-Id: E6DF2C0012
X-Stat-Signature: cxzy894wgp7hnfxcru6md1ic915uq3qr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768244342-626651
X-HE-Meta: U2FsdGVkX1+loi3fXwt6mDA5bZf+/F9ktJ2QWdwg6rYBVUlJ0yAF45AJHQ6s/qD54RWA+vyLYAt0hPn8Z9QmuJw10d+qOU5oGmq16mbWNLn6J2R/Q1cjdh8Z5y9KwROIEJq/Sskh5ii3/YyvG/AUVygDMe9/yQ3G6NkIN0JJa9DAvrwYvRJ/e3n1TP+bTFXFD7KVZG/HQSvd0RuVIkNLG/jmugV+Pv51lEJyoZMWOviWBaCl9mkRx4wktNOb8ET0uOw1BtWP8qSeuvCZCfOhxEciXJ195TPM1rHpCOTa6K/V5dy4hZGMDc71yU8BaLz1cgPhlRMSZMFJbbsqC4TGQpu/3oUyyFZWgqplPjxxA2bS1vAfylFbKUl+XiAfbEm+mRC39/gL8Fx5OvGk6HeHt/UwvxwzvxslRcqGMa3ZFt1A8RBlfXxBbZcA6WWWOsAPw6jvX4E7ofeMSKR9EQxnhXRIE5JCiV/+g4dp4B1zaUU6f99fYTCNX7f2rmk9wruyP1vPYP5CEy1Lg9K5PODIIarLOB18MCpVteOxaAtp5/MvBjlz0yZ7lDohG0AOVWh4qELSasf8OwAoD/ddoGE7y3mSeWNZvueb/7xc081LuHf4Ze13BonTa3Pk/N37eY4DfmadVbh+TUPuMnqpuHxZRdkNpKvXJYWxdhiMOn6cIFZI15lWCK2WOc6FFA9hx4rKBTDS3g1gSILzLqNzswBuwMo1ztlGbW61oKpsiAxQMjWUSYqXwwjxC5TWrCs2c4iwtafEY5kABmrpHRY9ZjQGEX3r6eEMVOejnZgC3i6hFcV773VEgWqtrVHbnsMxt0VC0JjWWImIMwvjmcWLyXFuppenkqSElOJ1xaH88SaIhNb0kEkXZoLDYT811lE4MgdlIaeR+wSsE0ZKbKsT1HtSXD7LzdP5V+dIKxEMb1xUntG7/x6r0x+vRHyAeCWt90VPIeq2tz96PKA5qwrN5km
 z1ZpnSA4
 1IbUGIYUKo/IkJwb1/wSIjVoIgzu3kx6mo5ZCKwqXi9NxKJua3u3Yp2R3E7ahICPXtlz1dXpkp+h/RnjTWqtdyKFZYouu9g5dElBYaA2/DLP4Fxl5u4dDz2iBoWK1YIFLC46QnQ0kSEdRHUEQ35gBrvQ0NVeqt6aNhQwB9i01OO11yiW904UZncA1M5vcGy0Dc2tvNVX9XpoRCf+dbKvyM0JV7AySlwVvE151M6Sn1c+nBZKj6bKEXULFPsWLvVtoRs7gDAeFE9qR95CpzhLNMJPPVFh3GE4a8amNw2egcN9QY7Fh/LvEwJkOJpTTTNyfKQTDoUTWAZuu+ygCzedjvSCjXPLQl7JFL0JlKDOO9SZMA/ZuLfryykX0z/J1w6CnpOAbaCbYxG6Rju6Lm1/S2nJCjKiBLx6yYVcvD3n+dIkKhgCPg/POdgR7PzLvd4lNBW5Q1e2Nb8tvR737avljQeJMrkIvClOmAI0OjbAQwPCXG+VirsgY1YNg5VE56RoHWvif/Xap60irpRbSdnTyvRQUWtlkqxaEGMjVvtgk5vqHTb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 13:21, Ryan Roberts wrote:

> On 12/01/2026 15:57, Zi Yan wrote:
>> On 12 Jan 2026, at 8:24, Ryan Roberts wrote:
>>
>>> Hi Zi,
>>>
>>> Sorry for slow response - I had some other high priority stuff come in.=
..
>>>
>>>
>>> On 07/01/2026 03:32, Zi Yan wrote:
>>>> On 5 Jan 2026, at 12:31, Ryan Roberts wrote:
>>>>
>>>>> On 05/01/2026 17:15, Zi Yan wrote:
>>>>>> On 5 Jan 2026, at 11:17, Ryan Roberts wrote:
>>>>>>
>>>>>>> Decompose the range of order-0 pages to be freed into the set of la=
rgest
>>>>>>> possible power-of-2 size and aligned chunks and free them to the pc=
p or
>>>>>>> buddy. This improves on the previous approach which freed each orde=
r-0
>>>>>>> page individually in a loop. Testing shows performance to be improv=
ed by
>>>>>>> more than 10x in some cases.
>>>>>>>
>>>>>>> Since each page is order-0, we must decrement each page's reference
>>>>>>> count individually and only consider the page for freeing as part o=
f a
>>>>>>> high order chunk if the reference count goes to zero. Additionally
>>>>>>> free_pages_prepare() must be called for each individual order-0 pag=
e
>>>>>>> too, so that the struct page state and global accounting state can =
be
>>>>>>> appropriately managed. But once this is done, the resulting high or=
der
>>>>>>> chunks can be freed as a unit to the pcp or buddy.
>>>>>>>
>>>>>>> This significiantly speeds up the free operation but also has the s=
ide
>>>>>>> benefit that high order blocks are added to the pcp instead of each=
 page
>>>>>>> ending up on the pcp order-0 list; memory remains more readily avai=
lable
>>>>>>> in high orders.
>>>>>>>
>>>>>>> vmalloc will shortly become a user of this new optimized
>>>>>>> free_contig_range() since it agressively allocates high order
>>>>>>> non-compound pages, but then calls split_page() to end up with
>>>>>>> contiguous order-0 pages. These can now be freed much more efficien=
tly.
>>>>>>>
>>>>>>> The execution time of the following function was measured in a VM o=
n an
>>>>>>> Apple M2 system:
>>>>>>>
>>>>>>> static int page_alloc_high_ordr_test(void)
>>>>>>> {
>>>>>>> 	unsigned int order =3D HPAGE_PMD_ORDER;
>>>>>>> 	struct page *page;
>>>>>>> 	int i;
>>>>>>>
>>>>>>> 	for (i =3D 0; i < 100000; i++) {
>>>>>>> 		page =3D alloc_pages(GFP_KERNEL, order);
>>>>>>> 		if (!page)
>>>>>>> 			return -1;
>>>>>>> 		split_page(page, order);
>>>>>>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>>>>>>> 	}
>>>>>>>
>>>>>>> 	return 0;
>>>>>>> }
>>>>>>>
>>>>>>> Execution time before: 1684366 usec
>>>>>>> Execution time after:   136216 usec
>>>>>>>
>>>>>>> Perf trace before:
>>>>>>>
>>>>>>>     60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_f=
rom_fork
>>>>>>>             |
>>>>>>>             ---ret_from_fork
>>>>>>>                kthread
>>>>>>>                0xffffbba283e63980
>>>>>>>                |
>>>>>>>                |--60.01%--0xffffbba283e636dc
>>>>>>>                |          |
>>>>>>>                |          |--58.57%--free_contig_range
>>>>>>>                |          |          |
>>>>>>>                |          |          |--57.19%--___free_pages
>>>>>>>                |          |          |          |
>>>>>>>                |          |          |          |--46.65%--__free_f=
rozen_pages
>>>>>>>                |          |          |          |          |
>>>>>>>                |          |          |          |          |--28.08=
%--free_pcppages_bulk
>>>>>>>                |          |          |          |          |
>>>>>>>                |          |          |          |           --12.05=
%--free_frozen_page_commit.constprop.0
>>>>>>>                |          |          |          |
>>>>>>>                |          |          |          |--5.10%--__get_pfn=
block_flags_mask.isra.0
>>>>>>>                |          |          |          |
>>>>>>>                |          |          |          |--1.13%--_raw_spin=
_unlock
>>>>>>>                |          |          |          |
>>>>>>>                |          |          |          |--0.78%--free_froz=
en_page_commit.constprop.0
>>>>>>>                |          |          |          |
>>>>>>>                |          |          |           --0.75%--_raw_spin=
_trylock
>>>>>>>                |          |          |
>>>>>>>                |          |           --0.95%--__free_frozen_pages
>>>>>>>                |          |
>>>>>>>                |           --1.44%--___free_pages
>>>>>>>                |
>>>>>>>                 --0.78%--0xffffbba283e636c0
>>>>>>>                           split_page
>>>>>>>
>>>>>>> Perf trace after:
>>>>>>>
>>>>>>>     10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_=
fork
>>>>>>>             |
>>>>>>>             ---ret_from_fork
>>>>>>>                kthread
>>>>>>>                0xffffbbd55ef74980
>>>>>>>                |
>>>>>>>                |--8.74%--0xffffbbd55ef746dc
>>>>>>>                |          free_contig_range
>>>>>>>                |          |
>>>>>>>                |           --8.72%--__free_contig_range
>>>>>>>                |
>>>>>>>                 --1.56%--0xffffbbd55ef746c0
>>>>>>>                           |
>>>>>>>                            --1.54%--split_page
>>>>>>>
>>>>>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>> ---
>>>>>>>  include/linux/gfp.h |   1 +
>>>>>>>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-=
----
>>>>>>>  2 files changed, 106 insertions(+), 11 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>>>>> index b155929af5b1..3ed0bef34d0c 100644
>>>>>>> --- a/include/linux/gfp.h
>>>>>>> +++ b/include/linux/gfp.h
>>>>>>> @@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(u=
nsigned long nr_pages, gfp_t gfp_
>>>>>>>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_n=
oprof(__VA_ARGS__))
>>>>>>>
>>>>>>>  #endif
>>>>>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long=
 nr_pages);
>>>>>>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>>>>>>
>>>>>>>  #ifdef CONFIG_CONTIG_ALLOC
>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>>> index a045d728ae0f..1015c8edf8a4 100644
>>>>>>> --- a/mm/page_alloc.c
>>>>>>> +++ b/mm/page_alloc.c
>>>>>>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>>>>>>  /* Free the page without taking locks. Rely on trylock only. */
>>>>>>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>>>>>>
>>>>>>> +/* free_pages_prepare() has already been called for page(s) being =
freed. */
>>>>>>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>>>>>>> +
>>>>>>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch =
fields */
>>>>>>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>>>>>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>>>>>>> @@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *pag=
e, unsigned int order,
>>>>>>>  	unsigned long pfn =3D page_to_pfn(page);
>>>>>>>  	struct zone *zone =3D page_zone(page);
>>>>>>>
>>>>>>> -	if (free_pages_prepare(page, order))
>>>>>>> -		free_one_page(zone, page, pfn, order, fpi_flags);
>>>>>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>>>>>> +		if (!free_pages_prepare(page, order))
>>>>>>> +			return;
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	free_one_page(zone, page, pfn, order, fpi_flags);
>>>>>>>  }
>>>>>>>
>>>>>>>  void __meminit __free_pages_core(struct page *page, unsigned int o=
rder,
>>>>>>> @@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page =
*page, unsigned int order,
>>>>>>>  		return;
>>>>>>>  	}
>>>>>>>
>>>>>>> -	if (!free_pages_prepare(page, order))
>>>>>>> -		return;
>>>>>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>>>>>> +		if (!free_pages_prepare(page, order))
>>>>>>> +			return;
>>>>>>> +	}
>>>>>>>
>>>>>>>  	/*
>>>>>>>  	 * We only track unmovable, reclaimable and movable on pcp lists.
>>>>>>> @@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsig=
ned long nr_pages, gfp_t gfp_mask,
>>>>>>>  }
>>>>>>>  #endif /* CONFIG_CONTIG_ALLOC */
>>>>>>>
>>>>>>> +static void free_prepared_contig_range(struct page *page,
>>>>>>> +				       unsigned long nr_pages)
>>>>>>> +{
>>>>>>> +	while (nr_pages) {
>>>>>>> +		unsigned int fit_order, align_order, order;
>>>>>>> +		unsigned long pfn;
>>>>>>> +
>>>>>>> +		/*
>>>>>>> +		 * Find the largest aligned power-of-2 number of pages that
>>>>>>> +		 * starts at the current page, does not exceed nr_pages and is
>>>>>>> +		 * less than or equal to pageblock_order.
>>>>>>> +		 */
>>>>>>> +		pfn =3D page_to_pfn(page);
>>>>>>> +		fit_order =3D ilog2(nr_pages);
>>>>>>> +		align_order =3D pfn ? __ffs(pfn) : fit_order;
>>>>>>> +		order =3D min3(fit_order, align_order, pageblock_order);
>>>>>>> +
>>>>>>> +		/*
>>>>>>> +		 * Free the chunk as a single block. Our caller has already
>>>>>>> +		 * called free_pages_prepare() for each order-0 page.
>>>>>>> +		 */
>>>>>>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>>>>>>> +
>>>>>>> +		page +=3D 1UL << order;
>>>>>>> +		nr_pages -=3D 1UL << order;
>>>>>>> +	}
>>>>>>> +}
>>>>>>> +
>>>>>>> +/**
>>>>>>> + * __free_contig_range - Free contiguous range of order-0 pages.
>>>>>>> + * @pfn: Page frame number of the first page in the range.
>>>>>>> + * @nr_pages: Number of pages to free.
>>>>>>> + *
>>>>>>> + * For each order-0 struct page in the physically contiguous range=
, put a
>>>>>>> + * reference. Free any page who's reference count falls to zero. T=
he
>>>>>>> + * implementation is functionally equivalent to, but significantly=
 faster than
>>>>>>> + * calling __free_page() for each struct page in a loop.
>>>>>>> + *
>>>>>>> + * Memory allocated with alloc_pages(order>=3D1) then subsequently=
 split to
>>>>>>> + * order-0 with split_page() is an example of appropriate contiguo=
us pages that
>>>>>>> + * can be freed with this API.
>>>>>>> + *
>>>>>>> + * Returns the number of pages which were not freed, because their=
 reference
>>>>>>> + * count did not fall to zero.
>>>>>>> + *
>>>>>>> + * Context: May be called in interrupt context or while holding a =
normal
>>>>>>> + * spinlock, but not in NMI context or while holding a raw spinloc=
k.
>>>>>>> + */
>>>>>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long=
 nr_pages)
>>>>>>> +{
>>>>>>> +	struct page *page =3D pfn_to_page(pfn);
>>>>>>> +	unsigned long not_freed =3D 0;
>>>>>>> +	struct page *start =3D NULL;
>>>>>>> +	unsigned long i;
>>>>>>> +	bool can_free;
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * Chunk the range into contiguous runs of pages for which the re=
fcount
>>>>>>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>>>>>>> +	 * free_pages_prepare() fails we consider the page to have been f=
reed
>>>>>>> +	 * deliberately leak it.
>>>>>>> +	 *
>>>>>>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but=
 not
>>>>>>> +	 * vice versa.
>>>>>>> +	 */
>>>>>>> +	for (i =3D 0; i < nr_pages; i++, page++) {
>>>>>>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>>>>>>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>>>>>>> +
>>>>>>> +		can_free =3D put_page_testzero(page);
>>>>>>> +		if (!can_free)
>>>>>>> +			not_freed++;
>>>>>>> +		else if (!free_pages_prepare(page, 0))
>>>>>>> +			can_free =3D false;
>>>>>>
>>>>>> I understand you use free_pages_prepare() here to catch early failur=
es.
>>>>>> I wonder if we could let __free_frozen_pages() handle the failure of
>>>>>> non-compound >0 order pages instead of a new FPI flag.
>>>>>
>>>>> I'm not sure I follow. You would still need to provide a flag to
>>>>> __free_frozen_pages() to tell it "this is a set of order-0 pages". Ot=
herwise it
>>>>> will treat it as a non-compound high order page, which would be wrong=
;
>>>>> free_pages_prepare() would only be called for the head page (with the=
 order
>>>>> passed in) and that won't do the right thing.
>>>>>
>>>>> I guess you could pass the flag all the way to free_pages_prepare() t=
hen it
>>>>> could be modified to do the right thing for contiguous order-0 pages;=
 that would
>>>>> probably ultimately be more efficient then calling free_pages_prepare=
() for
>>>>> every order-0 page. Is that what you are suggesting?
>>>>
>>>> Yes. I mistakenly mixed up non-compound high order page and a set of o=
rder-0
>>>> pages. There is alloc_pages_bulk() to get a list of order-0 pages, but
>>>> free_pages_bulk() does not exist. Maybe that is what we need here?
>>>
>>> This is what I initially started with; vmalloc maintains a list of stru=
ct pages
>>> so why not just pass that list to something like free_pages_bulk()? The=
 problem
>>> is that the optimization relies on a *contiguous* set of order-0 pages.=
 A list
>>> of pointers to pages does not imply they must be contiguous. So I don't=
 think
>>> it's the right API.
>>>
>>> We already have free_contig_range() which takes a range of PFNs. That's=
 the
>>> exact semantic we can optimize so surely that's the better API style? H=
ence I
>>> added __free_contig_range() and reimplemented free_contig_range() (whic=
h does
>>> more than vfree wants()) on top.
>>>
>>>> Using __free_frozen_pages() for a set of order-0 pages looks like a
>>>> shoehorning.
>>>
>>> Perhaps; that's an internal function so could rename to __free_frozen_o=
rder(),
>>> passing in a PFN and an order and teach it to handle all 3 cases intern=
ally:
>>>
>>>  - high-order non-compound page (already supports)
>>>  - high-order compound page (already supports)
>>>  - power-of-2 sized and aligned number of contiguos order-0 pages (new)
>>>
>>>> I admit that adding free_pages_bulk() with maximal code
>>>> reuse and a good interface will take some effort, so it probably is a =
long
>>>> term goal. free_pages_bulk() is also slightly different from what you
>>>> want to do, since, if it uses same interface as alloc_pages_bulk(),
>>>> it will need to accept a page array instead of page + order.
>>>
>>> Yeah; I don't think that's a good API for this case. We would spend mor=
e effort
>>> looking for contiguous pages when there are none. (for the vfree case i=
t's
>>> highly likely that they are contiguous because that's how they were all=
ocated).
>>>
>>
>> All above makes sense to me.
>>
>>>>
>>>> I am not suggesting you should do this, but just think out loud.
>>>>
>>>>>
>>>>>>
>>>>>> Looking at free_pages_prepare(), three cases would cause failures:
>>>>>> 1. PageHWPoison(page): the code excludes >0 order pages, so it needs
>>>>>>    to be fixed. BTW, Jiaqi Yan has a series trying to tackle it[1].
>>>>>>
>>>>>> 2. uncleared PageNetpp(page): probably need to check every individua=
l
>>>>>>    page of this >0 order page and call bad_page() for any violator.
>>>>>>
>>>>>> 3. bad free page: probably need to do it for individual page as well=
.
>>>>>
>>>>> It's not just handling the failures, it's accounting; e.g.
>>>>> __memcg_kmem_uncharge_page().
>>>>
>>>> Got it. Another idea comes to mind.
>>>>
>>>> Is it doable to
>>>> 1) use put_page_testzero() to bring all pages=E2=80=99 refs to 0,
>>>> 2) unsplit/merge these contiguous order-0 pages back to non-compound
>>>>    high order pages,
>>>> 3) free unsplit/merged pages with __free_frozen_pages()?
>>>
>>> Yes, I thought about this approach. I think it would work, but I assume=
d it
>>> would be extra effort to merge the pages only to then free them. It mig=
ht be in
>>> the noise though. Do you think this approach is better than what I sugg=
est
>>> above? If so, I'll have a go.
>>
>> Yes, the symmetry also makes it easier to follow. Thanks.
>
> Having taken another look at this, I'm not sure it's the correct approach=
. We
> would need a bunch of extra checks to ensure the order-0 pages can be saf=
ely
> merged together; they need the same page owner, tag and memcg meta data. =
And we
> need to check stuff like poisoning, etc. Effectively this would turn into=
 all
> the same stuff that free_pages_prepare() already does.

OK, it seems a lot of work. Thank you for looking into it.

>
> So I don't think merging is the way to go; I'd prefer to either do it as =
I've
> done it in this version of the series (call free_pages_prepare() per orde=
r-0,
> then __free_frozen_pages() for the whole block) or call free_pages_prepar=
e()
> once for the whole block but tell it that it has order-0 pages and let it
> ~iterate over them internally.
>
> Can you be convinced?

Either works. I prefer the latter, but has no strong opinion on it.

Best Regards,
Yan, Zi

