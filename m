Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DC9CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 22:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2503A8E0007; Tue, 23 Sep 2025 18:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228048E0001; Tue, 23 Sep 2025 18:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117BC8E0007; Tue, 23 Sep 2025 18:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2F548E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:22:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6ED6877C5
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:22:25 +0000 (UTC)
X-FDA: 83921939850.10.447D110
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011027.outbound.protection.outlook.com [40.93.194.27])
	by imf11.hostedemail.com (Postfix) with ESMTP id 07BBF40005
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:22:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o6lXNIV2;
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.27 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758666143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hQxSPueRjqivytB2WxD4yT9ZIay1EdItgh7HO++yOU=;
	b=lmoueJDVnRjfWVYzRgCOLutcJOPcyaliXg+38ke1De6eptJp/YGqVLgKlz4IZV6/ndYynt
	X48DdTGmRLUIMdCRi1e+9oLm4HYqU2Id2+U739fghGEusCKZUJTotgbYUuekxSgUZOsIRB
	ykChAG8cBHV+HW/ffwdMLl7Q2XS+Ygc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758666143; a=rsa-sha256;
	cv=pass;
	b=Xele3tQyBOqYnl/sqecsggSmKPpnQmOvWt2xp9qiMhYzOoWLztYfbp9edhOz5nwj/P7+0N
	5D/8t0W2/Ag8lYuordpeWF78bePsXWxYGqpXh5D7MzgIyZG3xvVje/jiR7uaqkbcEBvoML
	VcLz7vfz8UCjM9qUgRsNuy4aAR0ecLI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o6lXNIV2;
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.27 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iAi4sSpYU9zuO+eSlj02D1mT2vZrlCE9aXEYDzIMmitSqBQN+2VX1ibr/mnZKWw3OrO8UObY54jLJ8nPhouBUlHrKK0TI/5UrLPi6iTMXVIMSDrwPXT54A/HWJST6s9TH8x4fuVHLPtNeQ/GPsgSm8G6Cxrm0oPjOp/dv4CQ2FIev4ns7z6x7ZSAqa/50wrjuoBY13BrPTMGIIvubM/9cKpAyI2F6Zb8ZiHjmKJKykdT6ZCs6cS1iCCfGtYQXg+uE12N+DopvzfWy7JkzScecOd/cT8esGFZZGJblulMzMY7qLbqcAgFogLzfmhiy8juUJnIyLO5vYIHPKdQx4SEBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hQxSPueRjqivytB2WxD4yT9ZIay1EdItgh7HO++yOU=;
 b=HvIek/lX0cBUYLNPcCkNtxHIxjUBoUl+vCN0NfSnVju3LMp/5msW9gaUGEMk5/HjQWrwPTvU+XIafpSQR75SjAXzCdycH2xD5Vo7bKXuWS3d6I6o7hXuO6lgfG/UrY1JiYp77HsUFLrqxGVq9z4Vb+SH9Q3OYbx4wSR67er4Fp6XCmObaF2iUzMgSxtdPrYx803AN9Pn1acmlVMd1vGI4t2mkGIw9plvILU4jU8XIgIj5o4cWItiXzHgn5+o/iohSI4ff//MX5KCr6Ds3GVi9FCNG5jJOyJgmIs+DqXz1JQI0S7uqoyfvYwo4O7QqfiLZtU1nU4iYSnmvum6bIq+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hQxSPueRjqivytB2WxD4yT9ZIay1EdItgh7HO++yOU=;
 b=o6lXNIV2qcDbOVBz3hScRzhykjeJrAvH7uSY94JvgF+nxPIuz0abEbY8ZddkS1WLHE8Xj5MaFxug5Mn8T0Up/ObnQ01ZScIvPOLF/LI8trb/QBejrpCBAsKZXBny0IbHrhbe/p6FJgiesrH8kpLwKipC9Hqiy3t5qi5JIiGG2KOv1tcExgLAzKLXArBLQv2ck5tJtncJzhYxKwESG4lSQpaG1tpUCzf+5p6CloJTmHQBvMBH25Y8qSO84C8Mib4pJUIQeNAhMniB/ntJWYePSk40kipGvmTUOOL6iz3CpmaFQ5IxbBOy+hkdElhG352ld4WLKDZpkALEgbB2VuMWiw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB7353.namprd12.prod.outlook.com (2603:10b6:510:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 23 Sep
 2025 22:22:19 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 22:22:18 +0000
Date: Tue, 23 Sep 2025 19:22:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <20250923222216.GC2617119@nvidia.com>
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
 <cover.1757423202.git.leonro@nvidia.com>
 <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
 <20250912090327.GU341237@unreal>
 <aM1_9cS_LGl4GFC5@kbusch-mbp>
 <20250920155352.GH10800@unreal>
 <aM9LH6WSeOPGeleY@kbusch-mbp>
 <20250923170936.GA2614310@nvidia.com>
 <aNLnXwAJveHIqfz0@kbusch-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNLnXwAJveHIqfz0@kbusch-mbp>
X-ClientProxiedBy: SA9PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:806:27::6) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB7353:EE_
X-MS-Office365-Filtering-Correlation-Id: 52108b48-523e-4f64-a2fa-08ddfaefa842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HiFBaYaRi7DKEeQsmk6X/SYEgHfzNbu+M4du3xz9VIsxZ0oTPo570go6akJ4?=
 =?us-ascii?Q?2Or3ISNvnQmC1mSqyVZmAV0T2v/xkUXeqZHTEw57a5SxJS8OEIZVRvbzA3M4?=
 =?us-ascii?Q?zUeDxw3aXP1TqOHp/iiZ2FpshQBy2l8J+Nw9WjaXA/oolcCTguOEMyxKwMt1?=
 =?us-ascii?Q?VQvnaXFAXLHFEtkOWiUc9U3JBFrQn626RugY1Kx9u1+zZsLfZwURSftiRyJ2?=
 =?us-ascii?Q?AbRMek5TJ7C/C84eUmGjJf4cI3Fm03XZR7ptnfD76nofpP49hHMx7bOJwLf0?=
 =?us-ascii?Q?AK87VzDSV2liyg0oxstJCPZJ6zjUzy+pFSI1LRXSIL1mEi2bipw1u0pIvevb?=
 =?us-ascii?Q?21wu0KiRuiYmYHdR98L56KVV2qvGXUeT0OWnIrXpR6/tJnK0InA4JAK+q5YB?=
 =?us-ascii?Q?+PNqDo6n/Dz+1BJEAop5huCiDGVdEMB6IUMbGBAAViw6vt+9DYyU+fARydRv?=
 =?us-ascii?Q?VebmValwMPP+ipL63zSb+8coNQCLdhuzjejtPsEFbmo7sFWdRUHZ+SQicAB/?=
 =?us-ascii?Q?by9BGvHbm8YEYES6o68SKe0MRz7M/8DLLJWiGy1FEsX08mAJClRA25ASHqOn?=
 =?us-ascii?Q?9qbt998ToEEpx10C9M08G8UMWKk5IYX9hEmhM6W1XCF3FuIRhHlDniLnnyB/?=
 =?us-ascii?Q?Y0OBUif48DiAy4Qgmx6adV5z4hqXyOAyDd6xu9HSAjwsEbMv7ebhagxAbaJ8?=
 =?us-ascii?Q?tbqGDJJwMHSenWkE8Sp7/kTJx4UYgN1N7X6Pe+3Uw3P+yHCuKVhKmY2E+6Zk?=
 =?us-ascii?Q?r3NpokqBnTBOt6qYL/QF1p/Z/x6u1sKKXW24wlsjStbZNcrk/Ic4iZTA0yp8?=
 =?us-ascii?Q?Ado4kY7x1S6Ce+/bE9t5OGEIHKqSu1XJZaQY2/SC6J9sGb9xY6arvDY/e9yP?=
 =?us-ascii?Q?RWMNN2GEO9PPVY7GQ5mGRFbNn9+jd5o2/Pvz+sPyLUjTtng+O5eji2+cuvtZ?=
 =?us-ascii?Q?t68MCCJgoOVFIxQ4ClfY9/Yu+dqAGIa/AeO+mSDGiCjp4lL5TBWsZdWTubA8?=
 =?us-ascii?Q?5TkQ1oa6XRJcZrXjCwA30d/52w/7HPD57aOxIeQElVE28aV2LTvn2L60eEb1?=
 =?us-ascii?Q?X+ahd1MEFeQy+S/eh00gdgnBmIo5mwR+ubove1EtAoBvfJZQq8fJHRrmPQJu?=
 =?us-ascii?Q?URGBj3q0D1/sVUM+qLwM+taVSl2Q7LWKpCL2sm7O6JkFMotz6AfTRpbA9Xtp?=
 =?us-ascii?Q?R2sdQvjZ0ZX8/+XlV1oRvcz1DrFf2f+xbcy+McKo8J29DmvfmH+cKe1otjcU?=
 =?us-ascii?Q?TmSTeKKjU1L1dBbqDD+Ku+EM5WV4FzyWYRDFGQ1b8mL1qdim6VFY0yN/TAcH?=
 =?us-ascii?Q?DDRNlp83lJc+hT93VKW/mY0ScUrjh61HDhCiPtfRAB43+1vHo7KGLEwIMFwV?=
 =?us-ascii?Q?vvVy7B2jYyZakP+T8+su0vdooier05WIvIUvvLxjdw5XvhJ/DbrG2Rv2rvUk?=
 =?us-ascii?Q?aG+ybpQ9Iz8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eVGNJdmby9Ocx1dT6CLNPZSYywtZ5BQQPj0z919YXfiHa+uvZCqKScTu7K+h?=
 =?us-ascii?Q?TEhVf3NybTrETxq9+DUNdWg6sUmVul7WgplkbHU8WxcPyscVyqucyWj39Iq9?=
 =?us-ascii?Q?DIBRmS3r1wvzR+ThMQaAl9M3yWH4pN6WhLRib2oK1rlh4sIZv594wK3XES/i?=
 =?us-ascii?Q?ppzmrzxmupDAqwLzMdIybgoOe4Q3FHGa1+jpzZQmCa1PqrEWAgXz8w1OxdMD?=
 =?us-ascii?Q?RqiJd4P4iHVUuNPwNV61LALwTpaQ8wb43sdHVIGPh+WXBNVbn36vYHACN7Wh?=
 =?us-ascii?Q?lEMAUmtTbu8hqVLBIZ727iR6GXDpGJy90XKuqQmGOTzfpqAKdH5s5nAVm68g?=
 =?us-ascii?Q?gCekI4E+feogQTAbMMlwcIR8I5D/NvIhwo6poYenL0IgTSapHG5nXBtDBgy+?=
 =?us-ascii?Q?hLp0loRIWvIQz2FsUDFcxkfGG158SXFVwEmQ7zyKcnwngO3FKZi3ghsoLqQJ?=
 =?us-ascii?Q?h8Hb/47//9zgVehIZ57TYxVhDgNbwBGmJYxSn5ZPB15AUL2LzYZSqWaOaVVs?=
 =?us-ascii?Q?1pH0qxN8vFtk8M0Z3zUjIs8wRAZ2ZnT460HWvYV1B0VGgeCFtU7BdJVfxR2P?=
 =?us-ascii?Q?x4phMDLxNk8HiFuJTLkUvo4PYEeNnO1HWc2Kp6Vt/uQ6K4yuyRFhTO+x0FBf?=
 =?us-ascii?Q?0IpY4BLkzsCYfaApAZtbvUQzIxbIojvg6D1JOBUoD3azc5mW0NKSrI197gYA?=
 =?us-ascii?Q?GJBqME/8N/RhwtzSW/tU9Djna9U8SbbeOjM1A+z4ADhfzf4Tz5Y++RN58UQ1?=
 =?us-ascii?Q?7BneyeEdGNqb3T9E1i4PsGbfTYOREYyhWED0aS4Af4zMcxxZx2yhGsa0hqqT?=
 =?us-ascii?Q?jDFDoe3YmI5+6T8UAwCbiVMixiVSqn01f603+7MB9V76s3Vfyhw+XR8mVpvl?=
 =?us-ascii?Q?NrFMuOvp4BECPmrykWHZzeyE6WKEGSxcZ/ES2liREp9ffszRLshxPBH+TC9A?=
 =?us-ascii?Q?6m7h5pYOfEpB7IMYNxYWiPCtgJ9Gtee/Um9osjzrExO+me55q3Yag8zswFgZ?=
 =?us-ascii?Q?we1jHVNJPK6WenRlpnFTpkW/mxoLeYL8gNcg6JWDNN6eZr1PEycYp8QIgCBV?=
 =?us-ascii?Q?RjiWXfHybAR2sszZ58LyRJkQlICq5jDSB0d4ghx0FGv6J24o6O/DcxJS64Of?=
 =?us-ascii?Q?C5eSS00vfQ/Ydb0l45BZ9TUED86C+Ikm2JIdhnzuuC3Qr4laf95QDbqzWuqH?=
 =?us-ascii?Q?0kRFLVYcKLGqPsWFAM9ExzmqsaxNXvbAytZ2BvK3RdHvgfciBvrB+4csMTIz?=
 =?us-ascii?Q?sQDOIiMdUjkn1dtEnC5Z7O5d142aAKRB/RlkMxYETjhYybWAS7qAvgql/Y4e?=
 =?us-ascii?Q?FQhGrarH+Y0W9rSIm39edFyxw3IMIVAmJ276+/BQYroKqeQ0Swe1Ie87k032?=
 =?us-ascii?Q?DZvlfF55aIXBy9F5zH57lQbqtVteAYQM1eN9kz2jVVXfTsuGiv2tZY/60JCo?=
 =?us-ascii?Q?EagVYUGYoylHGbdohYaptXBcK92YyzJmWukOI7tEEIL0SHsClNhzvktkLOMy?=
 =?us-ascii?Q?bLcjUSWcf6NJUoO+Nz7g3di1JPENGEj44yIOJtSxez3StVK2pe18DCj7Zcld?=
 =?us-ascii?Q?ncLYB5SOSnXrQKAyoRZJT9Q9bI+rqWwmBAZlW0l2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52108b48-523e-4f64-a2fa-08ddfaefa842
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 22:22:18.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGLYkxWEuDdqsEtURp8syALj/D+W0jy8uzr92XEQX0IUKCZEPeugcvMAO9ufQqtp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7353
X-Rspamd-Queue-Id: 07BBF40005
X-Stat-Signature: d7dc91jj5sw4fzppyxwjfkc5j7dsb3qd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758666142-695988
X-HE-Meta: U2FsdGVkX18YMh/KY3g75H4yiwT+HzqmxXA87iL1slCVq5SmHrdAAOCY+yVgYqjfQbE+grjbphA5oTXKY6bjNTj6Z8C/XVqRt3Wc8jg6Nf4haRjl42VxJeB5vSl98auaDaRy1A7GXBP5d+YTUBx0MfNb3KTkbCUZJkQh1wxkRW6W8dzlYkogBrUOl70NpzCaTMlnQPeET21mhQiGQw5Jkrr+KdS4y84Xq/foHgA48c4clV4CCWU8PG+y5eqUpGmtNKjlrgqaYhFrtCyJirsK06Uvm0tO7Q2+f+Y6NnRbm9UHLY4i8xJKbTAOrC03N1k09DQepqdSY+pYAAbWtO0QMBYxg0LDXdAl/q1H/9Y/7s6ymZzxK0iwiHXU5JPcexTFy+s1zC46558Xr9DJzFqdX58pISiA6yzgT9SfsabZp++w9wqY98YKlmUiv4SeWWG8zQA4r8ROmozln9GA3rNvEcV8dbcbCwY2eq7ql04KuiQjqIEwCCLS1VmQViLJ4QeZK36+jQbA/kxbUa56zzEgh+LkEcAN8KBZj09ixGQSGQeSXj2/wP9+oSomQAYI8XPcnKnLXhgzH/pqp0khhDlDsfjs4TI2HK/bxFJaSdXwhL3MeHQIgwC8DA2WRszW8kUZOysTMhz7IOeP+Mq+K5B/qHU9xPw94HKRomR1rGoCQyn/WODknMdkLPDEPS5Gsg9rDogsDta581ajFqzS4pdrENcno0JcFc04RfWAdGhcb8y+HstWX2HzG3H3y2COAZjZoj+z0pLQLfco/cueYUyGsbTezZDmxcnW35xPAgsxINIBXJmEErurGkqI5x67g8/cB6WQnHZTLdwpqaWPSZcrdB1+MASIc5jSWLJRlOVbOA8LMeuAJk/OTfRGdCSlJq2gpv46nmdTVCwnoxcog5tqvf7DihLr9bJ74n5y3mRDY1Dk8tXOTY284dkhxGODPhwFQnGTjWcpZWeh3iXoipu
 9gUAWYDY
 pB7xT74ho66IdHD34sbl0n7cFV0Kh3baBssL9iNu1qalCvq/6fPibqYhxDdaleQAQ9gydK23i1puqm/jAR9cRIlHNv8xDemF4ZUNYRBASjOHdROwr67Tg+NKBh5NGleP/qXtheTj14wP2vtEASEd4SCJYby0+tXx0CoVLMQcUf8oZypY7R88LKcWw5riYpKIs2SRhGrEbkGWb6i4drfsEAJlNQfL2vDpr6TZTVeqmC6A900i8aF2+/bNe0+4cLjEOil66CP7PmZj5z76+96RNgTAUmt1VyYHdqzk57H74gpzMZkll7e35LDUV5ZgZwU9Dfw0DWdLaMAWvhN2keR6ve4TMEazKewakoEsCYC0VocWGkQnSweU/MFnBLH9LNysTr95tCaV2pWAnQkQ8acA/9zqJag1nmnvUz68Es0oZx8ZlJYYQwsfC4NFBv9T9j2YCmPC6RzK5Uoizy4QFR5rDctYaEUiy43zwic3RXjV8fbyWWAIBF7GjNHcubQIMWHp0uGCre5boi9IiZmjYhLxsvvSbpr3VLy2sPpfouqgj5tuS50HgSkapsYURb2zITEbwOmwe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 12:30:55PM -0600, Keith Busch wrote:
> I don't have a system in this state at the moment, so we checked
> previous logs on machines running older kernels. It's extermely
> uncommon, but this error was happening prior to this series, so I don't
> think this introduced any new problem here. I'll keeping looking, but I
> don't think we'll make much progress if I can't find a more reliable
> reproducer.

Okay, that's great. It needs to get resolved but it is not this series
at fault.

Very rare is a different perspective, I mis-thought it was happening
reproducible all the time..

It seems to me it is actually a legitimate thing for userspace to be
able to trigger this cache line debug. If you do concurrent O_DIRECT
to the very same memory it should trigger if I read it right..

So it may not even be an actual bug???

Jason

