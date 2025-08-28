Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF02CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4E38E0001; Thu, 28 Aug 2025 11:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B818E002E; Thu, 28 Aug 2025 11:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988D28E0001; Thu, 28 Aug 2025 11:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 815EE8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:18:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E4821A024A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:18:22 +0000 (UTC)
X-FDA: 83826522444.01.FBBA381
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	by imf18.hostedemail.com (Postfix) with ESMTP id 655F71C0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:18:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KsbQQi04;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.78 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756394299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShzJl56LtBJiyc6AvhGBzUtrjJqdBYzQ4xRpuGpa/mA=;
	b=MiDSbVQ6R2qnMFh8HW/PMJDqP57Rm1AVtnl4AM72B9dMvRP0eW9ywInFYet87dRXpAL9Iw
	RyUELJAJKYgSlLhbJnerIHzF6iwGYBLUhX1HHeqS6HEuPvKctsbYXtFI5iQNJklboZqgUw
	mOAQIrDbr4LY49R32QsOWhuqv4t5/ac=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756394299; a=rsa-sha256;
	cv=pass;
	b=rIAOjc3RvH13i2bf7nKPwXniEP85hYJbxpY1Jls9dQ4zU7Rzx1O2hGpKwmw5fhorC+G90g
	BrvafDwCo4AxLD3KBQoQ+oo6J8O/XQSiktq2GUV8EOd6Ys8Vp/8OaZpIvATTFGyxtvPRoF
	L/eJOiJcaHUhKwbvYSvnO8/Mh1gA8E4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KsbQQi04;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.78 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkSjHrXPQJ5QevAHuZHJ/1ZwysYAMlC7WLt2JCr7Ib0Dydjs7sKLrTxQSSaq9nl+JVVSxyHw0Kfpfu/Z4GIRbSJCKw3HQMGLAItWwxkac7jZhJ3Nl3dGY0Yir2Oc/Pp09/aLRfP4lc+mpPwSeMadoqiTX3csI9w5yHYRwmvFEp6CnmJurYj1hK2HH7XM4NwqCT9iGJfNmr1p3RPibLOhjbmZeJJmv0q6RYwXGKrZkxbIFS3nw+VChZJ6yEp5vffLQbvxcrNfAv4jRN5WhS32p6E/KS7CGL/Lb97c+Mccf9SrP+3+3W8rSj3q10nK2ztu0H2pf/pO5QE9DqexMha15A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShzJl56LtBJiyc6AvhGBzUtrjJqdBYzQ4xRpuGpa/mA=;
 b=OHiOqUdHm0E05MtpTY4RH3OHpFQ5fKxczpNO/mQKtc3e+nGtntYnzGc164HvBvuMoAuYQGr6pa4n1fmav+/ZZ9nWSVTWg7qtZdITSOP4bWOtxk3CAcIQ8bCx13rcVCsyfMzsbx0g7ea+wa2uT2I8TM2zHa/K36+CM5zUYVZS7u57MAIXobqtceaR8Srk3Wr9EWFy9HZI90DNDBZ+JJ/G73Q5qwNts0s9rr7R6Qnf9J+3Jbg4QPIpHYDDw/3fhdJanulZo/2E2I8I2OrLpt126W+b26WnCHm3kcip0J1VuJdh4JIFxLtP7Qwe1y5i5wqVoNJp17Kfijn0H4c9LlJd4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShzJl56LtBJiyc6AvhGBzUtrjJqdBYzQ4xRpuGpa/mA=;
 b=KsbQQi04w5SQpVCOeNANBYpgQiyJY62prH1NVBUsc3pYx5vRLata6nrv/vv2k3tUQ3jolIs+3wyqpZyd109pNKsOm/RoBjXIPUnjkjruSXm51GRvNIqLfrTreD71AwGnYRVoCkdvUchnnqwFiBHo+r6jcXRLV2IHAIR7r5cTKRKzlsLD8SCHF2ws873zlwnW5E7qXKXY3zDF/eoLUDDN8ckhJXGzqG5sYHPIr0GXcq1UQOK48ePgeERnTjl59WGDe/TdDNgWaaFrkDFHTi7HksLDKlxb2eb2gQFhxRvFEw0YuxZktFZyeZIpKTiJBQUEFLHpBIPrVLTOuXZvfHwPgA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 15:18:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 15:18:07 +0000
Date: Thu, 28 Aug 2025 12:18:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
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
Subject: Re: [PATCH v4 10/16] xen: swiotlb: Open code map_resource callback
Message-ID: <20250828151806.GI9469@nvidia.com>
References: <cover.1755624249.git.leon@kernel.org>
 <babeeb62fcfbafa39f352da1040a5dfa9d2a2719.1755624249.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <babeeb62fcfbafa39f352da1040a5dfa9d2a2719.1755624249.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a8fe0e-ab8a-4b0e-9c1c-08dde64617ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oqSoLix/bZqS47pHIAGHVakZEvG5PSc8iYv/rmXgsfkYORsMBVjbq18sAgdd?=
 =?us-ascii?Q?JpJDdM8tXa0kdShcYqB6KAwmvHTd4TLJKGG9vtlxgEO1gTJES3Xope2wf0+Z?=
 =?us-ascii?Q?PurpTn8Tim2ec0HMoXDAc102Gz1jtY/GxQJplLKGRIK5/+fJ2Xs3f0zlNONR?=
 =?us-ascii?Q?TgLDEJb8NPzYuAbfx+RH9/zLE4goolhrIRCy0dS/lp+0hdeoc9tqjswL1SBi?=
 =?us-ascii?Q?4y0mtVWW1XyTOchcXnnp166l23c63mi6lAfJdTYe4038WfjF+wSslahP9C+n?=
 =?us-ascii?Q?l7H4E0Hwyr8/BkA47Tdf6r9BR6g7L4wCmJGjg8kU2fW2zd1vZ8u59bZvYRg1?=
 =?us-ascii?Q?b0nci2jQ4l7SgbZISC4v7IaQG+L/FM48n2mTlMJ1Lqv//SNV3EOwWpcGVvIl?=
 =?us-ascii?Q?9dOrHg6H0jqvwdiuoGZtBKqGlfgW+d3puwbsSKM1FN1gufdZoWMODRLpzZBg?=
 =?us-ascii?Q?8gk30CXhiEcPevSP62jWIcbBB73Pb8MipOf90GU+al4rHVY2110H1bkpHAmO?=
 =?us-ascii?Q?tV2WHUrcGblYKtPx6XqVy13zUlx9h4oFp5yCou+IIkzHBbNG49La+0V4o8Z4?=
 =?us-ascii?Q?JovufQO8cfEC/Mm2Nl+qSv//iVYD0UUaBAIZP3toe5MIHuDCZO3NlVmhrF4U?=
 =?us-ascii?Q?qr7vpAnE+SqHmn+2uygfOLj23NMar/5tgQFmJM+2PuULLcKpiu3/72y2JzP6?=
 =?us-ascii?Q?wzG8IaDPhSttMjbCg5ERwNV4hD7FD6nDv940DhboyiTG4Ebn/VPraIJiByzj?=
 =?us-ascii?Q?Fzpq9eN1HHRjJN0C9UH+J3ZZFHGe6POmqmFxHM4yhpni818t3EnbXfpIH1Lv?=
 =?us-ascii?Q?u+6DerHqDv6jwhJmbS1ppHca8CFNpY9SUlnh4biMi9MdR+U/7+a6UAQP+fy5?=
 =?us-ascii?Q?oLkD3TV+3SE+TUI+7FewYdStGaIMoSZt9VmzG+85mTMd3beXQochnuiSnFpD?=
 =?us-ascii?Q?Vmo+stGI/evpj/N/zUidySQ9BF/rJ51OsyEjlxjm/2kLdCFfgtOx/L1aIU8G?=
 =?us-ascii?Q?psXNMQq6GGRtFbwB/iniuxeOOdh7YrNJJ4TnQzd7HgneLiNYK8BEG/1cxSSI?=
 =?us-ascii?Q?rn+GY9vx2shgiIrTMQR3kveX65m1rFdDc68dIWEuXKAv/t4LvsBv+Moj0sxL?=
 =?us-ascii?Q?zaXzbz6QiETi/sLmzDdbMGJrQIrUv9CAJCDQCYSWQrbywJ+vM4ha4mL2RK+V?=
 =?us-ascii?Q?s+s0zDyzB/ZsdtDN9ZotHVPK1OLNBoSUBfc36/qc2VEj3gVwTpKeEIJ4hEL4?=
 =?us-ascii?Q?y0hxqabJCAktbd+Ijp5Ep9uAD284Qw3QRc3cU4pbyzo3cZMrpqs4m2aKaE2J?=
 =?us-ascii?Q?F6iXkFZyIz96/Hb8GvidWBUzgeOslT9ItcOu+fYmCCfn1x4tR1Ke0JrQuSdf?=
 =?us-ascii?Q?49Qav6F45JGc19e7b3PJyyArLIqH3b/CpnICeVdUyDis9UgfrENHRcpMufqe?=
 =?us-ascii?Q?2KLbDfqMUXI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LwdE8kNQDkMKKJ5rXqpqVvkwqMB9l8K6/oWhNiANt6Z4Y/ZnePMfu5HEFkyy?=
 =?us-ascii?Q?jr0zoaTniBJgxtRnfrumXkBdLmv0ru7UodNZcWt/DsTkdWUu7rAs80J6BqMp?=
 =?us-ascii?Q?ZywTLUTGmDBZcc4DewUK0cI1XvolLo3ttcm62/7P53kAgoHnyWx5sTIC/zxK?=
 =?us-ascii?Q?59UMpMQa6t4SfM6gkDIcHfYyXWtVetuYZGNufECsCocFaRCYnhXNYXets9t5?=
 =?us-ascii?Q?f2QSuV1zoSPS4FjfR9frHj5v/uFOg62C/QTnnk9/lDP53nlPUBNWI4GlqoKV?=
 =?us-ascii?Q?ULi1kWY4kczaRMaQb8WL59uqp4eKbAYVEuX0qG5W3NvgVSapHXBctoUaweS0?=
 =?us-ascii?Q?fEEscsNkUj3m6y5zyzJRUj5Zd7MTM2ZU5BXJ5s1VehJx/879JXa9ZpGVTLPl?=
 =?us-ascii?Q?PbJ+1zwxyje7KkOavPstP+NHmbykhHHCu+8NKq2MqXxjfqA/g8KDa4c+xzS8?=
 =?us-ascii?Q?rUrlw7xa/KCbyrd0EULbUiq4ZoyE99ja+zyfmXRgR8aivNjyV4TQvr/r6FWv?=
 =?us-ascii?Q?gMLMFyyT0Kbvcw2HYc5uzKdmXmd8/V9NAJt68riy5pVEFXbHFTzKFHVMTGrM?=
 =?us-ascii?Q?4FSfkJvP6AZClojotovAHVkOTxQ6snacKtW04e6OAVUiZghnrzLhRH2uD0XD?=
 =?us-ascii?Q?fkwvh/6SHZ2liUnfaEAgVYCmF0akKHWE7z6t/cqgVeE25ZBpyoh+VYtsrVkE?=
 =?us-ascii?Q?B1jexYP1TfS0wWvroBwMOU9DysMREcTgJrsaI/M+9wXtV192ss1eyFvTyUPF?=
 =?us-ascii?Q?CzvS8ZmGi+W1pk0HiYa1GQf2K6Zwk8lBZQwuhnYQ0BJ4aC0jZ0piHGHbJCXb?=
 =?us-ascii?Q?2uz9v+PZ7LWh0TnXJ6pp3aHS4u221oipY7ZBQpRD88E7m+hoO/Pq5TZp5/wf?=
 =?us-ascii?Q?PXRKbUtKTKij/2LQTlKt5Y6jFQs+oX7lGX9zh6PX4nD6PX/Uso9uvc6xfkLU?=
 =?us-ascii?Q?hH4skOlX0nlTlRdaMFmAHFbGVOwouiR2Zb/fgBdPf2UC7t6t7MyfSrn4jtbM?=
 =?us-ascii?Q?SkQgkI6xJdj14vpV2mvZV2PG6H2hmA4P2efJdbDDUZu0ihpxbiFsMs7Jrg/b?=
 =?us-ascii?Q?i5m5kZpgtu0v51alc0DPrdiae7NqRYJ2TX5U/MNkkcurCXarEm2GO9ppw4CX?=
 =?us-ascii?Q?nU0n4A7Pe8dTlZdfyiNyM/DcRz5zWwevHv4Of71DTuy0lBvjgJlYs4Bn8602?=
 =?us-ascii?Q?rgSYtsV55kMA7oikMFgn/IKtaOvvm673iFH0LKD1jWXtaRHU0o/LJjgosaXN?=
 =?us-ascii?Q?Fjpkk2QJwpavQgK52/mzYeKO5Fs5GFIxuEAPVe7xbV7DUM8nSGwhb1KyH8ey?=
 =?us-ascii?Q?nMcop9oYFaDdb7bGQ6yAcbmvyNAfnkDI6Zz6dPZGjm1oUkIowdZZxBFIipK1?=
 =?us-ascii?Q?6/T1GJrlZg7nfwJ2AJRsVkV/ASnPv4XVMMdYSg1x/uR6MPlWHiHnFWiVOfPd?=
 =?us-ascii?Q?xOFz3rHVyyL8ahYblMs+6Tyg3a7m8ftAa2CIxmxwFhsCa8F+e0qQFI4S3ovv?=
 =?us-ascii?Q?ZZXC8Wy6N04pOM6MFqtIQ4rPl1tUAj2YLUxVA8rGFk3n29eQcDnW0rsr4HWJ?=
 =?us-ascii?Q?8nmuh6lwpWFzoV5Zk/I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a8fe0e-ab8a-4b0e-9c1c-08dde64617ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:18:07.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QlZhJ6HzsDCusgLC65y89JvqHplC/ffmSYiANNkGEgk5HivPxH1g+zuer3/GiDLW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 655F71C0003
X-Stat-Signature: op5brhpmj8jjmpg677m4nfyzhtg9nt85
X-Rspam-User: 
X-HE-Tag: 1756394299-331993
X-HE-Meta: U2FsdGVkX1//gXbUfXbvScSuEFvulUZYSU1oEHpjFR0rONuUs4DnY8rdFyzA/JVHaaUoYETX9qLsTUMRg56u9obOzpyrSkAo2xL81Bfe001MPoOwkWn6SBkgohheES2yGyufEFH/nVFBZX+CEf/4fD7twFMuuL4Ircz0fG9LkjMJBr7vtKB4LQmddGyDF1nZZPh325pW34nBmuAKND8ejFa9AJdbMnZ9QGE/+dx7kjQkmV8u0aGUnzoUb+2IqJjiJmPMVxktwQH2kERhIJvU1ymwchgJ73spgKUqQYSXaJtM5xAO/A5YHLPnVkgV3QetRxLQ2/VMbmSAeoK3a6bRi1cgfp22vUNCmJfPMV1pP4WoXdIkf8cI8u6OXC766P8MRwWWbMLa9Js2nAB8iNO16CSAowf0HeIijzuQMQmP4DvfjMmFQ806pryrV7/CBKK1OTcTJqV/hq9ve5/UeS2nw/mSsFSDovZgMzevqNubAxHC/eu0XXUioq4MuuI69ccN0s5mx0cs+cfKsD287jhqDX3RGNoNTHXixfAOgAC+JzwnXu2BN291mZnZQj3nU1ieyjyJAGXsS2zG0X1y8fbn5qkg2AlFqy9TDM8QdhgG6UmhX3puXJ+MdTdEHeeeZ4cziTTlWsZ7rij+1Q55cqkQZxIWWJlr9CAbrobV7FtmoaTef/RST2nAafICM2dlomqTz21z/5X5MuUuNzTkJGZ7rIqHb9hSBTZtOEjrf2c62PtcpzYuR+Im40apRtVq2BAUdo+c8EXiSz8gskceY8i7aKWLeTdahHSV4DHNLNwzkyQl812YpZG18q3XnGqkY4RwAakK/Gg9Sh5iafh7b3wRlkNrbWVjyvz4uk09/XNHV0WvevXYMpT1oSdtsjYkIyZ5CkaZXfDKEzBkrQRkDoRx51nLC62p4+qlCVVvV0BKrDzSfzGnEuBkqlXk95J4ViG0t1rKGmry12dSKRPP32J
 EjZ8vgjJ
 yQYjY/mq2Bx9uL1ciOAkQDzaa1d8vQ/z67TdZerzPaK+Uan1VyroPGf38zYw6ON2WR8F4sTShR+BWXGlaE4/yOhDYikI9CXDfRt9On63VTyAu7toZE99iiMd/kz0P/WWOvszlG07ypn5U5IHeiFnfSzfWoK0TRw99Fm6OKA+omB3y3BHikGr2PPpYV6gV5yP65H7Lx70ru2LgtvrV081wiuQWoVCt44MD/YS8rgbRUmCkdk/LB+4+BwUh1vG1wSYMyPPLwH2/Jd6JOnQpqeeNLW1Meniw/h6A6pcoiC70FYjY/97w5eEJcnkbTYB5ATD7hCIvjox2rqHC/VSdopiBS3vJkULgm/w2GES6sMe+nBY/1bN4EsVkcZw10UBo/bpH5o6K5vyWvX5brTKsdVFPshiINePw54YxCcfUTD7qhOqrPMLMekp/8eCenzOJ4wIdzPcaF7+LPtwSmjV0wYYbJC1C95ZR1kuR1RWO9kt6FBImdiYSoWOzIw+ehn4Y9MkT12V5EUx18IllpsqLdQ4wWjIg9AvVokMkzD/BDOfq+3SzN5VUh88CRwja7USXFIeb7njlqTlE/fydpsu6aOicglbuGvZObZwR/92vSq6MdiCcS+VOLV4qzx4M/fZ8vizXz5VopVDKOZbhw2TSVeZR1rxRtGbnWD8REr4E/hS5TD6BqmQYWkXwE6d85+ntuzkCznTI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:54PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> General dma_direct_map_resource() is going to be removed
> in next patch, so simply open-code it in xen driver.
> 
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/xen/swiotlb-xen.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

