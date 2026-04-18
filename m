Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE39FF99C72
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8366B017A; Fri, 17 Apr 2026 22:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598D56B017C; Fri, 17 Apr 2026 22:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460B86B017D; Fri, 17 Apr 2026 22:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0736B017A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:45:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEDB8160401
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:07 +0000 (UTC)
X-FDA: 84670134654.09.609A123
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13D59140005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tJuEcytl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776480305; a=rsa-sha256;
	cv=pass;
	b=7gu2AK2mspjD0bt81cilZM3Bg25rMMBzfLxt/5Sayym1XunZLcscxoBbDbVGbL3JStYVFi
	kneTNuGBRN9efS8+l2MNNBZZYRVed0aZTjZdIaTBvR8T52w05o6MHCLghMlEVmGqgm0g0k
	qln4RcvzdmLmEsoHOgJmbvUG7EMDGes=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tJuEcytl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776480305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HO8ICQiUFQkzLBg9SgSYwDDAN3DeRitz+/rI4C14BQ4=;
	b=Pv24Jr3KIwLqJ2QSjoDphK5dqy5O6rWOy/TbGDwZDRr2L2KA1OZgaQhgfHRi7rAMql6gub
	6nJatTC4aZezITOyxHFjlrDxIgVuYeIWHe2hT/jVzl1lYcUK+ImJLCg6MEtO91Crh0E+f+
	gcCaVjcOWkcNeC2NGKMehBOSX3zjiEE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UBGJfGPDum3m6776KlxZ2JidZX7AL4NxFvKcdnVoSJULx5OTr5A6KCeGdcNnwWWab7LvtRFT+qcFz7bHyyDuJhdkuwwhXrBKQa3kp/SKPMbqlXDRtuzQVyyeCyIEfbrcSaoMzi9fV+JRiu78iFgR5vj3Ra/+L7o02JTtjYo/ViNhnxJ12H8ophYUetzU3L9bC3rVTzDG2v0HgLOeIcFpm8gRmJiVYKuw9IHlJso3gD53X64wGNb0ocjYAF9RlLzi7fcrSkL4PI0H2tBCrOSbgDlCx+C2HPiQ5DTjrA0c6ZJM/3fiGYiieQBQUP0o8XFfwnOFKcLfIRMh3QwhO1AmCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HO8ICQiUFQkzLBg9SgSYwDDAN3DeRitz+/rI4C14BQ4=;
 b=uU9nfYqAt2UIzJQJ3N/197u5MMEcFAJKqmuFCm9veTVtzOHy3IcjqTMM0+xdj80jnnQFtlb0v0CE4+Rb20uaGmVdM1qyrMN6hHHWlGVlO3vQQ77RWJSNwAw1tXYaqk7DEiCCGEg/1qBipp5P4qd2NJgjrAQ0hO6SaKSxzLgYyFNYShrK50b3rs1HbdMON4nTCj5181IgJ6OpG87+nKbAK4OP/KpTqeJ0Mfq9BF2M2TAH3gcWxT+dfAy1l9JeC+4Zl1ZB7LPECZrLzodIW6HScbyBknkoAFK2o4Jw0e2ty/c6kbsrk+w53RULtOG2uq0vIZFmDvmftfRI6VPXXDLkUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HO8ICQiUFQkzLBg9SgSYwDDAN3DeRitz+/rI4C14BQ4=;
 b=tJuEcytlxNL6IZZYgcDeNBOzXUP1sLsJ8NnSNV8KfxAwUdlUn1f060IJv5/yuSGBiTRLzpAfviTSBDdcCkl2s9fEf7DL3EP47DK5XQkPYeYZmeXZ5UM4j49XVFNtDGUluRC2SN7Vc/sP03h+PeocGS1hjcHWWbyqooG12o8Fw9pEVUjyaf0kqk813pPKvOhz0AUVFWe/wMZ5negBR8dIq29kzAckqxXlbt6J121KzRfueoVBqzwGGRR14o4BYeAV6JOa+FVrRYxwouB59hEHj1iw7VgT0cKxrSZMf23/JrUntxY9YJDgQjoTbNwLyEeIlEhkQ4xQYr7gdh4299ZhZA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v3 02/12] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Fri, 17 Apr 2026 22:44:19 -0400
Message-ID: <20260418024429.4055056-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: fa97c46f-016c-493b-35db-08de9cf46d48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	U6o4h9SA4r1cDcGWWupV2fAPiYV/oPgjDky4ArIbSE0FKMUDr4u5mHOB8Yvg5pxEVdq/xHMjvXR1nyQe9EpGP7kg/73bYRJnjs0MBYBwL6M2AvVYdgatW5mRHCYKWiXpzXMdD7RXjyOWCOZ6Rcnv4iRMfyD5gI5f8g5dElkvmFz7CfJkKAGEF8hyLN0ku47sHqZeNFeTD+rOnCNFrfqKYOcUPuia3CYLJEq6DhOZJGrEoDSF+KJfmsFMX9JCXZTqo4ABF1htc8ckfidASqcP89J4r5qLcZNLzLLMdmCwMYjcY/ib2KLNq2WV3NIdB3ByaetnRoR7puokHW3JZi2vx8M7+fu69g77dA8Avw+kc9Ow7jzEc8pz+hAeSZ4MUXmSU9+HYyVSkLvJi67cRLOM++2TBsvEnJA0ZrWbsWxJ/WzV17VDn/TZ/NI4vqlqoXbqUTrQOYg+Inyr6zNJnzW8l8Y39AwiEWtYLjJuUjewQIn007zkW6ejDKtPxVKekEPRkuDBuL2tmprNvH70A8XVXu4KZO7XhiE1eOpjq7xnn/OUR6meRIfRcS1FiiApULb5ytXPhtMcrNUh4RT/9sK1zc7FGhHkuFrvQhrNZniNIrjuFUYdh8g++Mq9qx+1ceb00KLdJ6HOu0J3CXrwDp32mOgW+ATczKvjDPu2FHuI+B9HOScXcfhXdcilG+BUTjI5Xpyvg8hKdCnpNysw49TJ3cY3au1iADqUfbT+QhTkamI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nHu2isgWdNSGnHPl9Ml3MddaMjyiSmDBsm0luWhLJFR9hXW6+QkGjkJoq75r?=
 =?us-ascii?Q?9AKCJu+Q3pddHkvZHuTJkjJ6b46AWh0l7uDC3r8eWx3o5Q2tDOelELh6lFsT?=
 =?us-ascii?Q?ojzj/cej6bhAB4ZKWrqJPV2JdbQ1zbngx0z8XtbaSSSsRgcNbxpQd5uoxSvp?=
 =?us-ascii?Q?FOQshvMnZBcGseJiYlyvTIZW0OxLjjfyspzq5f1OnrdsdnHe6c0Gp0rxDsYd?=
 =?us-ascii?Q?cSKR+rIPm3a6NSg7QBg5QwWKSJSUjAd+sUu8aUj9+ttriwlxtoD8fDFx991Z?=
 =?us-ascii?Q?gQp6vxpmsOtTjQWIOw7qMswTdqaP1JhRexlEMP067d1Ej+ueizo4MotvCdd5?=
 =?us-ascii?Q?YKoofaYH8ap6yk9l1+grnwLdslEiZtr9cTSOII/jqctYYLlQArzJ4jPOmJdv?=
 =?us-ascii?Q?xCEGkFhugcKDRZzV1GoSHZJ/OodFoaellKMKSwJ6PqmOuWYYPjx+lBMHg+ji?=
 =?us-ascii?Q?cqCQ60TYW2GO3qwA7UiNmNEK7DcqbOX1TvILCkM45WHLj/tVl8X92bXI6Zxw?=
 =?us-ascii?Q?7BY8m2csuUgoZG+URtkOixX1PCTaALnd3+D7kasqS17wX3r1p0DqURTttDp+?=
 =?us-ascii?Q?BVuPkSIcmbvoLbU88jWFd4F4hi/Xv+xLdTvIqtH4ZskMEAjVxtp73fNRRe+V?=
 =?us-ascii?Q?mHMea8eB4AL4h8hvyOqabqKPpBTZxZI2YZBH9eYhCE7cGdSRTGUjv2DJCjSh?=
 =?us-ascii?Q?EG8jH7tWCXa3+iNMtmrQjJa1CsBf9W2OwVQ8hPFiJbyfFsprcwne2PfXbOIv?=
 =?us-ascii?Q?qgDZQMP4vTv7giD+7uMUm4Iv5FstRqcym9ndX9u7NlATSqzT6t5XUII12/sa?=
 =?us-ascii?Q?ITiM59IMx1BRr8Zuq8JlJKZ5p0yeFDtvlR8qGy8GzcTHmSIq9sNg0JPIwt+s?=
 =?us-ascii?Q?Sx6RNRIF84jeZI4wxqC/nsCJ9RblS6yDOdJRx6DNY+UCU4LtoyClMVcSYjRz?=
 =?us-ascii?Q?ikA0orDDZYydn1Fs9YiSGuvjNeqHi7GwivSxvhHTA5LVizouS6EWZOYRbed9?=
 =?us-ascii?Q?H983+EeQodcdhf0UMCe0iqA6kLM/tXx8YgxQMwxv//ekb5mM+GAqh73EkcJS?=
 =?us-ascii?Q?z2f0uPjWyPJ+jugI1tWh7Js+peIGf6TAxPDAxro4NTMMxWcKbifHXZFaDrsf?=
 =?us-ascii?Q?q6e/MsCTIr9Os+0YdbeQOHWiDFLthxy6Ff0TvQHTLbFePh/gXdmj93st8Hf3?=
 =?us-ascii?Q?Y6e6UZ30pU64KTZl4YqPiThDrN9r2xNEbf3d0ayKWvC66X2YlRcF0E0PghBM?=
 =?us-ascii?Q?N9aIivZRcaiqa2CjYGVa78EuQKGrZCCWaLgrd8vUfnwupvIAORdt1//sW+iS?=
 =?us-ascii?Q?H1uN9khIfN1ko8YU5+mc6h7KQC0c/TQXy80VzJJw81td798YyozwZidXyuu0?=
 =?us-ascii?Q?F9sv6gh3x0v5/wiiB31/mS//N3cgM/rRSfzGahmVgE8bBo4qAxkh5wAEekIa?=
 =?us-ascii?Q?QSunqrkskZYXi98hhSeqoLfu/4bmMK/Xjaz6z6RDr+CRNFavZMrp9761qxYA?=
 =?us-ascii?Q?+SJ9jKk1gKZSm5txL5nDTKY0lwIMgZhrzthVDoVJ+7+6W5xYPad4+IhV+F+i?=
 =?us-ascii?Q?LPk819b8nYk5vMwH0kvRnlfmp+Si9S3gxl6JRYuex3nJr+GKBf5KkjRSRkQj?=
 =?us-ascii?Q?L7F6qJLTofvvFjm3s0VQh/+ZGZuCpU9RM/X1Lco1evLHxFhED/Kfet0HAU/L?=
 =?us-ascii?Q?0ne/bKppJ4NuzTC+LeWGMXClUS0kr4A/AxfiNE2j1h1YNj1T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa97c46f-016c-493b-35db-08de9cf46d48
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:35.3538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Z6MpALSbSDkphoW6j38eMRjhS921+njYGxhtEPBkYTqOkJLTJ06KNozWwfAlPvL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Rspamd-Queue-Id: 13D59140005
X-Rspamd-Server: rspam12
X-Stat-Signature: 67o43ek7ckxd395ygyy8wxddnsxw5u4d
X-Rspam-User: 
X-HE-Tag: 1776480304-709724
X-HE-Meta: U2FsdGVkX1/gAb69sLaA1Eo9KH1rIwBUlDvQvCRbApN5dxgmN+9LtdmXbokYeRjsZfzcWCiy2FyQShHKA15TnZxhGwo1YzjaUl3ouPd0smE64H+t10LfPt7EIsXfZf6Z1wpJwmAA4cPnYyu5EPU/xtbTJlmbdSkQR3Y6txVctY8gByPUKPO/MdMm5vuFkZivMPOrynqRWKpf0m65+J8h3VbH3+Dl8cILd8ywkbOnwUExsERcW1F2XthMzAdKbVGR5Csit0jVyEKGPWEmU0qcas7YjQsuJGeaZ/lV1Kry4NcHO28Z7L++jQ71cfDHQHvZEBrCqiV2mRC/W97E3pfU6esB2Isg3hw5ntkd9K7r9YXdyw7THgbjmBXeV06iPnJaDnFhkt85E3mi0NkgDf4oUoRP2KZTPi4CJNoOsUWgfNGC/UzC8CedePRO5drU2ieE5Lv5qV+TU1PjSUg80nak4n0Mo/X65m4LPShLgOfDn4CZvZZoIZA0FNX4DSJP9C1uoo1EA5ccbl+LXFoJpGtdmjFGGrEp69sBfvMsms0aWtDdQCvO6cezBcSKNRhuuUbHRXkItJQfYflzkTw9uhS1sDCZaUFiJJrRBuDUl91CkyZYdD8z0TOkHarG2uVa3yvAeJW9TNEI0uN/dtzqjyDZcysM+8iy91Mf7JxiztX/a0kF8LloXNhapiTMYfaf8i2STilpm+ztNV+PnpqdawwcASGRfFpP1s+Y8oOfbzTGscbeUiOhGbNRvESWEmXIk/DvpYK9iXxHm2YBHrpc5ml80i7GYxiW7L6bF2sceqGEZyw9La4SnchWXsxq7tE2yv9bVXezXZx/LehyystT/JJvrtlH6JHn2h9vQSsPU9rPGcN6LGlTl5bCe66x1SHNCfSHBvfA2DIWK9eKz73aAS2m/bpa505a0zo+6Z7UQyclikEpnMpYvF3pJ6BVJCIBff1Exe3UZ5qTBEDSvX5ZRbn
 JwxSi1iu
 HjiOvqcWtCn2cBV6jGyEVFhLok4kHQjWOEEXrWRAspahuMol+YxvfD9e5UQF0FPcLFItM9usQV/hnNeiBH/2Mz+1twJvkAwfKeVIh49+OBCp0luynmuWmGqo2jk5En87h1Dm3DlxvcX0kGU81vMcCWm0WxcpOh+CS9s+F/NyGWB2DbbqLc7UusRep98d7zaal2YotWLfUhaOjtazYdmlfX8oJndZaWGxyDYnVDbAKG3KS3QDdW2GbLIBG/Hz1/hkoRXL6wp54wClJm2fv6fAZBXNBMcgH/W9lT21Iv3wUANJZXuoNC55v9BYEhExKxACz/tEDQFR6cFVoCGS1Zk3xyYiduMQd/mmGq+IqoABIHzP/Mj3j8Z55i3Fu/cTqEm+fZXiYflpnX/NA7U56K5GqZGSMEMamsmdcYMqv+rwQ4pttaKXCOFwRSrZMFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This check ensures the correctness of collapse read-only THPs for FSes
after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
PMD THP pagecache.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too. To ensure khugepaged functions
as expected after the changes, skip if any folio is dirty after
try_to_unmap(), since a dirty folio means this read-only folio
got some writes via mmap can happen between try_to_unmap() and
try_to_unmap_flush() via cached TLB entries and khugepaged does not support
writable pagecache folio collapse yet.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3eb5d982d3d3..1c0fdc81d276 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1979,8 +1979,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2038,8 +2037,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
-			 * khugepaged only works on read-only fd, so this
-			 * folio is dirty because it hasn't been flushed
+			 * khugepaged only works on clean file-backed folios,
+			 * so this folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
@@ -2083,6 +2082,24 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/*
+		 * At this point, the folio is locked, unmapped. Make sure the
+		 * folio is clean, so that no one else is able to write to it,
+		 * since that would require taking the folio lock first.
+		 * Otherwise that means the folio was pointed by a dirty PTE and
+		 * some CPU might have a valid TLB entry with dirty bit set
+		 * still pointing to this folio and writes can happen without
+		 * causing a page table walk and folio lock acquisition before
+		 * the try_to_unmap_flush() below is done. After the collapse,
+		 * file-backed folio is not set as dirty and can be discarded
+		 * before any new write marks the folio dirty, causing data
+		 * corruption.
+		 */
+		if (!is_shmem && folio_test_dirty(folio)) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto out_unlock;
+		}
+
 		/*
 		 * Accumulate the folios that are being collapsed.
 		 */
-- 
2.43.0


