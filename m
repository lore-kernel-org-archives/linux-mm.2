Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE5EE6BF01
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5B86B009E; Fri, 30 Jan 2026 06:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890656B009F; Fri, 30 Jan 2026 06:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7485C6B00A0; Fri, 30 Jan 2026 06:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 634FF6B009E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:12:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37E9A16066D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:41 +0000 (UTC)
X-FDA: 84388367322.13.E90FEA4
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 768ADC000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bxJZE+Be;
	spf=pass (imf22.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.46 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rD54yMgfMF7FCT1Qj3EdRxemxK6Vha0iIOPny01QeRU=;
	b=OhUMJhx0OMGl810Rsw5lgOOuY15QjySoN/IGSvZTU5G00rDyx8yF95MR/8NgveIeFnCFn7
	irlV6aqPBKZO8MXyla9ApaH2zVONp1RtLhK5KST/YTet6s55N0IDVsflMtNoEDzv5w6iAt
	BYj21yYxUU3EOfBjs40C7H7wNLgBe9c=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bxJZE+Be;
	spf=pass (imf22.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.61.46 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771558; a=rsa-sha256;
	cv=pass;
	b=bS1pORUV/S/suswCsUai8TBqNrNdyUoKGMaSg9wvON6CyvHh1JfSFs0WE7N+9+PPI7fygc
	9pDTknRopH0F2nJsW1yUeoMoiXdlb9IwLYHHVmmpwFSihWMGYf7SqClzKMaoTOQWQT5YW5
	xid0vfPm7HKH6VORygAgoZWpt4ylDZ8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nn3GqSw0lrJh2iSBzXz4LoKGuNPR+ZqWTwgYsbWqdB9LFozscR37prPzQRr29EbJXd5+zUgmjMYYlgbYWkP7h3u1YwqTr7TB8MtMDNniKPu7CWdkmSLG0TjGz3tpXdFY7U2zQg/zbnvJ79uukXkTicVUl1U6vMN/ib+u9CYON7po/6r+O5+oNnXmvfePwEg4cVIFRldSVw4bCWOJfZI4tzuAJ9GmJ7svAVxmXHDKS7wSFHYmtJyzIu05jV1d5KamUkmjyn3vyheiPW+tvQEGKcFOjVCRhr3aYCwml99dMePDi2ZyPkg0/30dex5de3Z//vT05L4ku8aByuSFcYoumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD54yMgfMF7FCT1Qj3EdRxemxK6Vha0iIOPny01QeRU=;
 b=R+ppiR+3r3/bZtNRpym0xg5OAAdsDEEZe5od3lVGShmZxbTiYInN0eyppD7fbJSrVQKCK6j4Rwx5bh5JKrulNywyiU8vM3m67pRkVWosvJ6F6BoFrgd3FtjR9FGYMi2jCC0x9G6NBVvIR4VSSvWrti4T1jcCm8rh9HSPtXUwYRZGHDw9igGW1SKnlsI5AVhEtGNy9u9G9ovLlT/r9OUXdyTKRfDK0OMzp/edb0v71eE/HNxGscru4hS98BcczuasvHd42CQXPrMEqLIxgmEpmUfPmvHXyIzP/yjPvjaBzMZSj8HOV/r60SiFET/xkd1ouFh2pqfB8ObayWHEnTDcFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD54yMgfMF7FCT1Qj3EdRxemxK6Vha0iIOPny01QeRU=;
 b=bxJZE+BerSCjWDGFwogAeaPgV1q9AjuvGdlpV0HSLrYcm0XEtgrnJa6YIw31uREotu9OeFoqT44j2V/hZPqptvts9sIQphEVMLGzrxWzYbGQGk3uOTAAIuzy/syFN0l/Yc2wkvKCYP5GAZHJl7mWbcPXRArBR11uydAJjowh0060DLRLH1frCeY8bc/KKlPdu3mNh0NnEypRPO/lC1MtPeRIyLaQuNVA+Q7OfgN3gpIhKrWKeindgUE9hJpVKdVTBT64KbyXzZ1Lf93dM3MnvNt4vof4NYhEP8hb8qiJkWl5gLoNuJ+qI9hh4+puXJODzLIhDJ5SS+k5KPwrSVlSZQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 11:11:10 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:11:10 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v5 04/13] mm/migrate_device: Add migrate PFN flag to track device private pages
Date: Fri, 30 Jan 2026 22:10:41 +1100
Message-Id: <20260130111050.53670-5-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::30) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: ef453c26-cb8d-4479-5057-08de5ff045eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FEa1QBAA3w5kYjEps3UhH+0C3OdYTFv8/618mrZnpDkAMFKFwBAhSiI36ymA?=
 =?us-ascii?Q?WmEx72CLQVVLjUNQQSxObKMAoYmhONV8emqRrf8/APu3nk9BjW+8seN1uxAx?=
 =?us-ascii?Q?ZVSv+RlfG1pHqBCY3uggPoEY5Sa0rqGFYkgk4vs4JtZIrQjCB2M8baw7YRLx?=
 =?us-ascii?Q?erXeq4dDei15cqWOJK+llz783i4At1DwdpRhOGrniGk8tvM1IgwFob83s5Lh?=
 =?us-ascii?Q?gCZ5+aq2LdMgXnKu0Ue0GkGT2YVov9m2p/UJB9aolMqY+hpfuKKv6+Jk2YsN?=
 =?us-ascii?Q?E6x5/MmJ0hsiW+10z08SsQGwn48oBY+cTeOxTedJqrROIq5azPLCueP+n8HK?=
 =?us-ascii?Q?4CO3XDX4rWVVKevH4cdTdc0qpaWdNuJK5SbBdVYDo77lQ1tFAheSil5iYkzP?=
 =?us-ascii?Q?1utKIMudhy9DBRse9mir42lJs5pmEf8IC2mxczyTqpVXtCnymUyOnm9NKo16?=
 =?us-ascii?Q?3QTrfFz2FJMnWAPxWbGvCviiiWlWAo7wdzZm54U/lsR+Q+XZSicWPQboL5/T?=
 =?us-ascii?Q?sGcpnLwRnvJcKIXOz74pqyuEevNcX8r0KtAVVSZdH8qotsEJjz8RLF/ZPQ2C?=
 =?us-ascii?Q?guXQFMdoJDnuUeLraxT2ej80ytptLNakyvzPWGs3S3/tgXMcKJg73Gq/M7eo?=
 =?us-ascii?Q?/wi0klIqJUxa9loPIfkmmUSUYgnXTEYFZ96BUr9K43VsTvdyizRrCZPp0uM3?=
 =?us-ascii?Q?PiXVEuaSeOTCvZnsiEFIxfzr2J5JwcaVx9ky8ApG9T65jIkJsUFfOZS0Kzss?=
 =?us-ascii?Q?8sdWhnnLgMqDdUMa7SMtEfSUDt0dO5OK/bMFv5cW6/GRKTlHzxMRM313uzdN?=
 =?us-ascii?Q?9SSdGNfsQa5DCLVhKmX3aD0coWo1AzK82jRR5JEHeeduk8dqStraIDX+cgNR?=
 =?us-ascii?Q?usr5EWCreLQo19yKOo7Oz7wa0yuqnmuUGrVP0hJ9/fCuTYi9AkVAfTPfvNAU?=
 =?us-ascii?Q?7jxtRiYj3qY8l3CK0kXAMp2MvTgo3zU8Ypj+Gz5NukY4ovJENZj1rPLv7TXt?=
 =?us-ascii?Q?jsxSjt4UD61yhrR+uUmrvs6m1+Xiay8KASo8c7WpPOSRLSE8ff81UDBWo2uO?=
 =?us-ascii?Q?5LeWSrE4yOF0YC1yG7jMO1ocq7Hi/C2guC2pAGqNPqRaARUO0OxEpOxUahRL?=
 =?us-ascii?Q?SA6SWfyHVL5W58ftml1hT4NmGrBRUcYoLjmA9GRfdekB4N1Irh9fUZz+SEhh?=
 =?us-ascii?Q?TLqmOxvC03o9Q7cS9YYbrJ2Tu2CYyPIfMC2OR2TQPElHsVOzGuvExykSZL9/?=
 =?us-ascii?Q?3Jo7PSt3iessgI5glC65oMgNtYhNfgaoXEZY11WVOaRzuz2bQKbmtpjnsCxH?=
 =?us-ascii?Q?gN8LELxy9HJlP4kRPraSzPkFQwCPgyA2yB4M6USBO5hK/9BsUsTgnXycUn5W?=
 =?us-ascii?Q?gzVF6dxRA1YDU58xurlnrkz2NNuGu9sSzlkcIJi+4UKImZEJzvM4FlDuKU/t?=
 =?us-ascii?Q?d/6iNjuXMiJ3iY1AlnrKDTDaL6xqJIr5TGNXJUhgG+WGJ8bdwhPnUIsgEdJL?=
 =?us-ascii?Q?JhJ/xGS6ROBl2vqznzYB+iU8mFXq46Sx5RudvCgoRkv1tXCMjAi4MaptBDvK?=
 =?us-ascii?Q?IhtMheMa+1vKyU4vxqs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s8lG9Hbvk4O1ZYkSZYR20gw0eecivYclvHdgumtyEbSE7SajFEA0fstkycLR?=
 =?us-ascii?Q?0PD7HK8FbqaBePtBm4dwWJ0ViLR+NT0Iu9NYnhqn8dLajm642Lt17JueTQuN?=
 =?us-ascii?Q?qAUr+V5x/xUK1uvWggBl0flzEbAQdDtkSnFb6YDdw2dSfxs8bkbGOTyBO5cQ?=
 =?us-ascii?Q?9Z8t/FBFFtDKYT7iG6wmZ8egdIYMnxRm5mNdYurqFgXhLEczdL1vPbVDOwBm?=
 =?us-ascii?Q?b4h/WomZAimH5WC5a6xnDfp7LcX/D4Y95qPKoQPYuToI5m0YmvTiq1Zm1ckL?=
 =?us-ascii?Q?38EyKfmegq9F31wAbLzVJvn9gXuklSqgRS8K1tuKwrig3SevvLK/+jODz/D/?=
 =?us-ascii?Q?Ynpmu2PauFYjemPrQ/NvYPRg4Y3dABpRUGNnjg1Dpas3VZrGQKmZmEBBnv54?=
 =?us-ascii?Q?ElYwAF8d4LPCQxBVVXoUul+8dAwjPGFgp0lIFvzvHoTNG1j3QdOhNWq1QSwL?=
 =?us-ascii?Q?vGR/wIFKfXblxRqmSkLM0ciaG2FOrqXBCZRZxSf1ECmame3eg+b4QfCA/5CM?=
 =?us-ascii?Q?hQgi/ZEYznF5x6smLfCEqq0AVDob9eT99LNIv1ZzwFxh0RPYjnUenwoMvJ4l?=
 =?us-ascii?Q?zRkxhl0qPnc+ZwJ3CSc7R4xzFendfRLMb0QV3XIJEfaLlpkR3VdO1+9XXZen?=
 =?us-ascii?Q?H2cFC1UPWd0/qEu9cinj3eTWvjgzKtCMvp9x+7O/xgLmM18zleVRiQ8hgZDt?=
 =?us-ascii?Q?WfLbMO7I9IG3hXLnGWne73TdBevSqrhRTpmH/eEjE7QT9QhGy1ockoG7oigC?=
 =?us-ascii?Q?NBCsISj+4+QW8/RPqgw83WKBWGGYdgMXd0qJed3m42MI6/8rI8kvsUmHGicn?=
 =?us-ascii?Q?GUK1jMkyCNDI8ALtebCYvS4deL+SPfQcoRx3ytN9P6vo0zoHYZWYPl1iooLi?=
 =?us-ascii?Q?fo53shKnkyALzW4UFD07B+EuLy5RIM4NnLpmS8Awalln4+iIGeafp0WvfaTk?=
 =?us-ascii?Q?N83q3QZN69vSPZrR96IRD7CYWw2p3henBBmZOpx8MkO7NkZc6GIfcRKjmKHt?=
 =?us-ascii?Q?hnhRBHsZQfdp8voZW3bXcNbqce/DMEiJ5JdIYpXw2kkMm7JL4UIvUo5+kzLF?=
 =?us-ascii?Q?lLQj2Epgp8lyc8ZPaUGjMT8I0aAPcXG6nFmfkKyurlatT6TdX7wEwg+5t9IJ?=
 =?us-ascii?Q?oQkYAXytD/5R0fIQ4tZDOxKxXdBfQrv8hT2x7d3t0/yfRCdRGyfPSOWdYghW?=
 =?us-ascii?Q?G4HpF9ouRISEO/7w7MNNayeRs3ii5xMRhPBEo8vrkB+IROGFuk560nVfNavU?=
 =?us-ascii?Q?vOq00x00lm8MK1miAOD4L/cHmYwf6v1QoZtIZz6IDqGhHE+mCBoguzEKbKEK?=
 =?us-ascii?Q?uznb1yrjt8lkSwHsSym+3/EpfcYDK4tYR/uMaHgAt6lIkmZhMIbRo9FKzxpC?=
 =?us-ascii?Q?IuT50tvKqlTOgLITNt2UsFU8x+es+JRuEcH/oxislhx2E0KbM3jgohuxd2P1?=
 =?us-ascii?Q?wCxSZVZIyPtTOhFwL3DbJMIY4rPZJ9x+hJDOfyy0EduraVp0mWE8Jyng3dwq?=
 =?us-ascii?Q?2elwRocx0VAZgINDSX0ihnBMSjHCrG8xgeam83tpXZDBM8xS+0621lJ6BfLw?=
 =?us-ascii?Q?UbbaaOD3kUrRwxtkW99Mq8Hz4RmgVKoOJhum1CJe4A+e4buEqsp+nIwXL7Gf?=
 =?us-ascii?Q?+HWLeHmD6mQ3WQa4ZyvLHv1qny6iv+ho7B2dK5iQyMfIl59aqtq38C3hxu+e?=
 =?us-ascii?Q?Xs7USg3YNyKFc1/K+E+ORL3udUJ31V+VLnYxBzvd4Twqjr/u9evj5gBaMRPc?=
 =?us-ascii?Q?EWAwqJ2hmA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef453c26-cb8d-4479-5057-08de5ff045eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:11:10.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjV5SgiAnZUtgJySURGqVeNkOkHBr1ktF5AlXuE+X9zOTOTd/8HaMH+pjtPOTnL4Ngmzrw5bdFBIsekBkM2qEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Rspamd-Server: rspam12
X-Stat-Signature: afc5r5h1cnbzp78th5rqgicsks1ywxoi
X-Rspamd-Queue-Id: 768ADC000D
X-Rspam-User: 
X-HE-Tag: 1769771558-203663
X-HE-Meta: U2FsdGVkX18Q79IpEuLU+HhUGWoUBdz16r4q/8WLjAf91IBLnBVqEnqN7FGhy5J6mcI9sDXWd1+6gfUJSh69a4+8mYGP2Kd5d859lroyM6IkmtYVwSekUl72yUKFyO3lGOeXhTUD6B0rthlkmtUzN1u4h6+2uO7oV8A87A9knz5Gzvbuf0+VU6g3YWjsXfrSSCz7HeAF/ugPyeFCtihelzJc1h783XP12rn6P6S7REhlG17sS5v2I+QbOQoSc2O3djtKqc5yQVSkhtUrMiLPHkaAhw8f3/VlNwWKBkSypP2xYR/WEsorRN9BTlkX6IxypZNtJ5V0Nq5/6yEgri42cx0jDeRSgQ3tUQyL8+xVtfolcATmWHZqIQUHroiYKV8l46LD4WPZl33Iih4+sMZV9lVnMztgAZhhnoJ6EN8RlRBZfKbOecRPyVa42GlZgg4nJDFr8nEJyqcMexfdG+7CTm+o5YRUgKdTsHnBOsGgvTLTOBMgR+nU1ap5VEhvpgFPdym1Tv32EwUasulgbCBCUPNDsaoDNUFcSLfshwWxcU5Z4bfC6+lN5kkPmV3RKZtQ68WTaAu5ECfdcKeuD9AJBYyvx5ogMuiBbZUN6cMbkfnMsigPgLC5VVfb+3IL0lKrIb9HwuSTfIU4PhAOXSS0wv/LGqnZ4A+8JGZzgDV3IlK5on3Sg/iQmLhRdUlt7+61VoFk9EOFB2n/Sb2MRNrP87e68LLHWzvlQCnEJ72Lf+wY43TYJXtg91P0NVj1P6oRjsgDWP8Tu30v09AatQnVE951wfzKYzwL6U6TXqNh7SuN+pttKpnZJ0XJNgYcNra3zfnTUSxBBIII/rkqTBL9pPUFtWplqDXAs13j+grW+xx2cOB5IFbs8k7JZFR8ODpp6MsqFz2Kfun7vrcvpxCSm62n/3+I2DOW4rBpg2MTvdXuCpMB/g1y2i5OuNIUNuzJQdBEhQKKpLDuhpAhNkA
 ppuu9QLX
 K6o4lm2xAuF3ZM9+aCxTi+uYHAWZ7D9D8ik3S5NOdqasAJ84C/LsscQQ0wiWkMxyT2pkLcyW6qPzvbhOya1MU8G9fCL0YFGygks8ZoCGYhlOhgBCe7+d7YXH32ExjlDfpyFkybVyN1qgwiFEBETFlQWtf4zEAGrc5i+2DSx+MK6e07muGc0zv51gSy3Hp6g8OWFd5Xx2A08EXzkgQrEacaxHFmtRj/vKQpzAizl7IDh681T29SG0jFFcfJHeXtS2gCSqcQt/+59YN5LH53qhw2fOyIGt8OueHQktxg0HqqN15On/bKZMnVnIZCTMHQByz4jt2zXsrPxcp6RU1YNlsUxEbOjtcVglOqCUP7dZ2+VIVXM+6ab8jJBHLMdHV8ijjMjhAcmixbKq9364n/ViAIgSKBxb2p4IrjYYy9e2rG5rP5kPgtlbwk1GMEByFFl5KTb7VKVFgFmHFmRRWTawV4IsJlTNgcqTXhR02kd7788TcHZ2FuFCwpQevc1uVjrN6ErX7zEwii/3tOUoxKeTGKnumfRaymBpESI0II0nVdNBXljF2kNBWESq1dLn3kibKX/LBc3CoECAaltM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by adding a MIGRATE_PFN_DEVICE_PRIVATE flag to indicate
that a migrate pfn contains a PFN for a device private page.

Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---
v1:
- Update for HMM huge page support
- Update existing drivers to use MIGRATE_PFN_DEVICE
v2:
- Include changes to migrate_pfn_from_page()
- Rename to MIGRATE_PFN_DEVICE_PRIVATE
- drm/amd: Check adev->gmc.xgmi.connected_to_cpu
- lib/test_hmm.c: Check chunk->pagemap.type == MEMORY_DEVICE_PRIVATE

v3:
- Use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE

v4:
- No change
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  7 ++++++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  3 ++-
 drivers/gpu/drm/xe/xe_svm.c              |  2 +-
 include/linux/migrate.h                  | 14 +++++++++-----
 lib/test_hmm.c                           |  6 +++++-
 5 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 3dd7a35d19f7..5478e41877e5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -212,7 +212,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
 unsigned long
 svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
 {
-	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
+	unsigned long flags = 0;
+
+	if (adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE)
+		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
+	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT) |
+	       flags;
 }
 
 static void
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index bd3f7102c3f9..adfa3df5cbc5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -484,7 +484,8 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 	dma_info = kvcalloc(npages, sizeof(*dma_info), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns,
-			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT),
+			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT) |
+			     MIGRATE_PFN_DEVICE_PRIVATE,
 			     npages);
 
 	for (i = 0; i < npages; i++) {
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index fbf5fd284616..a8aad9e0b1fb 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -770,7 +770,7 @@ static int xe_svm_populate_devmem_mpfn(struct drm_pagemap_devmem *devmem_allocat
 		int i;
 
 		for (i = 0; i < drm_buddy_block_size(buddy, block) >> PAGE_SHIFT; ++i)
-			pfn[j++] = migrate_pfn(block_pfn + i);
+			pfn[j++] = migrate_pfn(block_pfn + i) | MIGRATE_PFN_DEVICE_PRIVATE;
 	}
 
 	return 0;
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d269ec1400be..5fd2ee080bc0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -122,11 +122,12 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
  * have enough bits to store all physical address and flags. So far we have
  * enough room for all our flags.
  */
-#define MIGRATE_PFN_VALID	(1UL << 0)
-#define MIGRATE_PFN_MIGRATE	(1UL << 1)
-#define MIGRATE_PFN_WRITE	(1UL << 3)
-#define MIGRATE_PFN_COMPOUND	(1UL << 4)
-#define MIGRATE_PFN_SHIFT	6
+#define MIGRATE_PFN_VALID		(1UL << 0)
+#define MIGRATE_PFN_MIGRATE		(1UL << 1)
+#define MIGRATE_PFN_WRITE		(1UL << 3)
+#define MIGRATE_PFN_COMPOUND		(1UL << 4)
+#define MIGRATE_PFN_DEVICE_PRIVATE	(1UL << 5)
+#define MIGRATE_PFN_SHIFT		6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
 {
@@ -142,6 +143,9 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 
 static inline unsigned long migrate_pfn_from_page(struct page *page)
 {
+	if (is_device_private_page(page))
+		return migrate_pfn(page_to_pfn(page)) |
+		       MIGRATE_PFN_DEVICE_PRIVATE;
 	return migrate_pfn(page_to_pfn(page));
 }
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index a6ff292596f3..872d3846af7b 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1385,11 +1385,15 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 	unsigned int order = 0;
+	unsigned long flags = 0;
 
 	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
 	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
 
-	migrate_device_range(src_pfns, migrate_pfn(start_pfn), npages);
+	if (chunk->pagemap.type == MEMORY_DEVICE_PRIVATE)
+		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
+
+	migrate_device_range(src_pfns, migrate_pfn(start_pfn) | flags, npages);
 	for (i = 0; i < npages; i++) {
 		struct page *dpage, *spage;
 
-- 
2.34.1


