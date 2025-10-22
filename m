Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718CFCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF058E0003; Wed, 22 Oct 2025 07:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F808E0002; Wed, 22 Oct 2025 07:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847108E0003; Wed, 22 Oct 2025 07:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC418E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:54:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08CD588C68
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:54:33 +0000 (UTC)
X-FDA: 84025592826.24.AC29A7E
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4FF59140008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:54:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a6C+vCy4;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761134070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ib5aqvGaEHdiMdjBTN03WwGhVDjVBo6+8WzwawgQ5JM=;
	b=AjMS6Kyjb/7o2YICKFKV/ENJlGtZw7JnfO7OUIp3DpOyDiRUqjF3ec64kSjlnFd4b/iII8
	KrC2OLESpcTBK8NxIY9rdcL6vz3Xn7rKlWdXbV+tFzbuF8Z8tVLV3eG7tc24gDVyOwYFIh
	iJTB3uXSLHC20MtlQO78lr02bscAqDE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a6C+vCy4;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761134070; a=rsa-sha256;
	cv=pass;
	b=fDyXiX8YKZVjSTos3aWWGI1rtQnXjUNGJo/TXU0cbgblZSD32C7C3jLpCNyNhcr+WNNOY6
	033d1bkHSyME0wfxlUU97AC/Xnw/eSuqA2Zd2ON44OBpsqbxU7Lnko2L6ws8u1JiHaxg1I
	R1HyMMzSsJpWIqCqjtvPgTkPTVJ2h+Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Te9hyPazRwZIZT7aUC3HKjOzBT2Y64eV/dQs09J2LXu2fXOtIvVAD0OAze9mnA4TuWxZglJxQoXd6n/WlfxaSd51XTIgirxK6kIi88zPkx0eYWXx6QLvBR8HDVrqzyAxaMopAzGn6oAPfqgmF3LJF2GG+wRFk2rVbC/+jMSMBdeoy0lecbn7VkoKQpogJvs4zdAO7qvtniNoWqjIlB83x+yWZhHIYXCk/SbVLq9I/5OqutFIgKw4j4WjyC3vnlnf6eLyaTVQSr1baXLcK0sl/jPUdI/OsPU0/31PVm4ByO9X5DxH38P+nmuY3j/yDnH4QMsknGG8A5RQKJUeXyJ9LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib5aqvGaEHdiMdjBTN03WwGhVDjVBo6+8WzwawgQ5JM=;
 b=x3tw/nqjatwbuMmnHs9QQOGWVeaKeIXnFjyFP2N0XrdhPvfivwQno1gbHFi7htSVamYlIm5qfJ4MpGgDkLp9m8CsEvpJcgo7uUd6daDjrmm1BPNIEkbSfIfvxNTmhyXTDl8DQLshqRbY+VoqN1j7AkjMQV0UadMe4jw8V5vBWOJ7WoS1mHb2dIHp6kVYQ4eZFcVFk/w0pgLlSQZFZUrMIqD0LFK9ovI3dMGty1wvUZkP7bGNCgEx5icDxX9gSQMiiZwZE74SmN1BGBNaYguwijjXt8n/gBCNQ3HccoWQUUoOGYdudT4LKV976Ph1JkhgeQRpWQthV6FG+YKITXAibA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib5aqvGaEHdiMdjBTN03WwGhVDjVBo6+8WzwawgQ5JM=;
 b=a6C+vCy4QukRcWXHoUH21hG4kDs5Lywr8v0+gS86pNNOv110BrZH18QZHSXR2Lp0s7rCflcZK5tRKTXSqe8axL8pJbTyVduxqGEOWDxOuCMcrBuWEeCKVPeznttIrIfR1j6wHuk6boRFxVl33LV6rSFFIznGkxR1M0SGXBDZ0xYkFoEZCdgr1rlZmE+QyHNitT493L66Gqx+WQs060vVQsUHA/B/5LSWMAY++saammg4/98ZKXD9rL1ZpC5wVBMcHCFVJTspeKXSWNLGOYIhNIIaYFxRymuA4yYVVpDSZvGjmQwdKSWn/r9ukvjPA/OzLkp1/cfX0hlh5dbWdehcOQ==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Wed, 22 Oct
 2025 11:54:25 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 11:54:25 +0000
Date: Wed, 22 Oct 2025 08:54:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <20251022115424.GA244727@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
X-ClientProxiedBy: MN2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:208:23e::26) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fcb0803-dcd6-4924-6efc-08de1161bf55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VC5kDduGhcmTc//afFoGb7AjHgFkNwGYEU4Z0a9WLwmHv6ulJQ6jXa/Lh7av?=
 =?us-ascii?Q?PNoDa9U85bf3wTdqxZ70gU04Xz5i0YSuUE2Y7/wgjhcBYxfz5RRs6BU5V+NZ?=
 =?us-ascii?Q?2pSBAd/dVaRwwqnxwAugGpjOjAeD/ydBSSy7sZwF+JexDzQcqdQhffqRaTMK?=
 =?us-ascii?Q?pG9T6eKZzVEClT6gSy6R2Ka1PB+fiVpKa1Eb9JOO7gQZlwZFfsFn2voNJR5+?=
 =?us-ascii?Q?DD19bJgniUOL0dqOUoCW23eqLJIBr1TPWxzdHkPw/4vxEobN3EdQ9MT68ta2?=
 =?us-ascii?Q?eXc3A4pSq5rLNn7S7nDYQM09k1FEUoSV24P8K5hoCSkYj9KhTdJLT0qUI60z?=
 =?us-ascii?Q?gUN1wuU3g8a0nN+lyGTjT+A5vYyjSM8GXSVKnFE6h4SEDX67JwrnfrkO48Br?=
 =?us-ascii?Q?qeuPLWSvR/AN6v2z+H5rQymnFcym6Qzhd+JPPHmRYA5faQxUN4OMnNDfPqMO?=
 =?us-ascii?Q?vkzgAPqLV+WCt525QQ2HmyTE0Eb7DfvbMitAU4ay5b5aGT9M49I+GuDEP48S?=
 =?us-ascii?Q?7/Vd44yZqjnBVWGPxSJ8sd6djAC/gs0znjq3l5Dw96cJQNIT8BC58wuneErx?=
 =?us-ascii?Q?7+leKMXfCthOCSrtNUbVnvvrEUSVbtjPZxrJQXUT+sYt87EEt/9OjO/X7CUf?=
 =?us-ascii?Q?iQ6AmbJLkYiVsKVlLmqkMhCFtBxU7g6LXFXfZFJtx+3A9BoItoYRoDuepVG/?=
 =?us-ascii?Q?XzvotERHcn60LamuPj5sGgWrXVs+1x6bJ3Kh6aN4gA2jq2jr69ur7IrohAi2?=
 =?us-ascii?Q?baWW/8OB/P/ujobt5U0tGDK0hbIswJCn3TxUrMXXwPpRY0Ss6fn13wMTPbVf?=
 =?us-ascii?Q?FGhA6n/q1pp4OJJJxLMdn2nPiL0anAeZTe0n637jsYekW87OMpAMZnjyjbcf?=
 =?us-ascii?Q?teez8f3fzg1QTOuBch9EDlYwWK1+bX0fuZYz+P5HjEr3GV+Q7fmxpArIAvWl?=
 =?us-ascii?Q?RDeWYyZoDxWFHPtNtjHxIqGV5V0C69rBtiG7huFAmhSlahOQfEu/xQunCAiv?=
 =?us-ascii?Q?2mocknrKGEhyXcOE4lW8rJngfLkc6C9Hk8QSMIJ9Qnrtu93+4Iy78rbZpFw9?=
 =?us-ascii?Q?UFPPWWifYPJMy11kwi6DBP2eic+Crca0xxKdEoC5X6YJnNmeCJOlurINnPfy?=
 =?us-ascii?Q?C6YMWRJpkjc9QuNOY0rtSFa4Iv388nZ5x2hMcH7XsLIDAguhiFWGvDwpqkbw?=
 =?us-ascii?Q?WaIGdiXS0CZKEdH4ps/+vxDTNlyVbZ3o2z8SyuFw56eOKJUKPRfWcYvGoDCk?=
 =?us-ascii?Q?Zz1wd9eEMDAoDmWXARaGhB+QtdSJy8hcn6hPIsQZnudZR4KsNeJmWN2Y9zTn?=
 =?us-ascii?Q?j4IA+/D9ssdvxIPHAIo5pS+pDGT+PGaWmozVZKUDRaanWaV9K3PMywWh0/Cx?=
 =?us-ascii?Q?VCqkMboY3D+4qRIUpkPs/HstTv0EW6bvKVw4pGZI+9T2RuX+44o/9aPuu1qi?=
 =?us-ascii?Q?82Fepe2zbkBkhLTCVFweWGGpYK1TiDhX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dU8JH+Hf0F3h1kCikd6jc/nrTxHAjUavPYzc13NIFNnRE6e3RpGuGATMUIFM?=
 =?us-ascii?Q?/OZfhgyyjf3JNqe80n4RTAxCkQXRz9XWla0TQg4rvpJN1RQMnghMLMmvxQEp?=
 =?us-ascii?Q?DPV0YHMbo8gybO53jQy4Ro48e7EMdnnDy9KrxBOCDfgRNlbcPw7URlJmSwXF?=
 =?us-ascii?Q?Ntj/wbky7q4p4P0+3IG8oua3G6+Seu4APbQzhQZ2XXcC+wRlbBzZ8ax+8O6f?=
 =?us-ascii?Q?gDqrkrDh5vusGw/kNKwgIyuQl72tzAD8FoBw3PvJCSoKFh1mwIDtyIP2vHmy?=
 =?us-ascii?Q?ulFf4+rBhL92Ztk+PlRTOxt5IrZgTRo0Eu82heA94cXf7Yxx/E+SRkqIMAws?=
 =?us-ascii?Q?Jfhpe203EunOk8tx0Y0FrBOgnfcMvf81KThTfxyFuZAi7u1hPhWHjbyEgONa?=
 =?us-ascii?Q?4seFkX87hmXSNzhUkod1jI6M4oiuu9WZMEYA7LoTWEghP4/T/4XLUN+RnUmg?=
 =?us-ascii?Q?c5N/Ki+rp0CJgVmvgedu10RTjbGLrOXw23lkP23y7+BQw2qJsa8dz7le0YUp?=
 =?us-ascii?Q?911ZT5wC1qXnc0L3ggcfxjwDpdW5L4Yh4IgRRTOvqwAnmG4XtfwsEQk50bGv?=
 =?us-ascii?Q?pEA0xss77Yx//prW048kLytQsi4waHkmmC6OH4qmcMnL2dUzHDFI95nG/DAQ?=
 =?us-ascii?Q?2tgIKDXIHJxZfaBJJnbO17R/nt6YZ83nMboAA/h29czCv2PRLlSKCP8ey4UV?=
 =?us-ascii?Q?65uSedzBrlePWOePJGtz1xUK+SLcubgbUmtlXz4w9VWa0yWhOgE9RmnPrfjA?=
 =?us-ascii?Q?J9JcttgLC2EP4syASICDiqbz3sl+OZXK1dH3DTsdzbLMQh890HABZvJzPJo3?=
 =?us-ascii?Q?wb7693Hv7PC5xTJEVWpJBilfzoRtoc48+CO+Pu2+NeVUcE865fkb7hSBr3F/?=
 =?us-ascii?Q?D9eq39O8nciIxpicGdroT7/p+J01XGtq9cHSQ4gB27UrUx+JzGe5utl648JN?=
 =?us-ascii?Q?hhrwf5hACG54y80j7Znliwl7wuTKvMa4mtRYoVT3+dcd3GOQtkbKdR49iHNu?=
 =?us-ascii?Q?uebE0KjX1Ah6JYKOBEOqXIscAk6DyYi/UAnJHRiCWv2a8VCToOOtHtSd3NwV?=
 =?us-ascii?Q?CtjfMkVIMNOPfoqB6d7wX/w2/VCBJ070rbqNCL/d88NR51vL9eBXnL2JbIPU?=
 =?us-ascii?Q?V7nbTVdvee1Z0hvHVwjcefr9JJFTSAPdy+yAFO6b42HUjMDs6fml+yi2+EiO?=
 =?us-ascii?Q?vhFD4ojI/LlUOhU1E4klbCBnz4T+azBSL9XYdWwO/lD17uhxBGcu3a6vVAto?=
 =?us-ascii?Q?tNIMpFoOswUosenCgUZ/EuRuDegn+oHN9oIfQNpdEdMocPFZChOXBCg4/AxB?=
 =?us-ascii?Q?WopZ4sGz9RveKsWaRT1IA9PJcEqa2qiagEtoNGixqICDv9/s4/W7y3LTnFG8?=
 =?us-ascii?Q?S8aUsf2fJ07QGvep0uREOCCcYgxo80NAW+Brc+4sCexACZI+MtQFoa/uXqdJ?=
 =?us-ascii?Q?D90t6xWWQ2n0sK4glDvYtN/qS9n7YoeGvLZ53vaosuLFFf663GMSTptS6yJt?=
 =?us-ascii?Q?jumTIwSr51nE/yYLurIPM8bZEDZfD7A9LN7Vjtkcf1aaipvBrwIl8dPcAYpY?=
 =?us-ascii?Q?5RV/BJUsW5vCh5j5fqo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcb0803-dcd6-4924-6efc-08de1161bf55
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 11:54:25.5792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGXhoq8V+jCsM9rgSAy7exVCDkN6w2vP2GtEKiwH2hXilixRYO3iVL5NPVru+HnJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FF59140008
X-Stat-Signature: 714epx7smi667g8i6jaq15rusoybxboo
X-Rspam-User: 
X-HE-Tag: 1761134070-309231
X-HE-Meta: U2FsdGVkX1+hCUK3SKynU5Sx/xkXhA93ihqJnbAsEbTSMEqX+8eF0jPz2Z0vvVT2GLwJ4A6Q7EFc92awX7DvQRMHbMXeWFqnuuWWSElrQQOEarOgvdabJpTahoCpmDA151S+U7tgQGqAlW5/CT+6hkLVRzOKZaCuon5ovshrRdHxWpCrlfEqiDfHQRCKNQ4AKrz26eMcoqC3zmhMr9WQz8JZdWfHBE0LtWpSKhbLI5qsahtmZKsFKk2UkcV2F9Ra0nImnCMjWIY0e3khXKHX5uX0EWiaVLft3K7duex/hDbp9GHDjikbDUV1Sod4PQcJgtgKB7Es66WUD8+Bu95VndIusSYq1+nJIxsx/AvAfkwHfTU0yiOP1vENrCAPM7YzKgg1RRfRjMtKHGRbUCQbicQ5vyZoX35tEPa9Ul44J2Ww+NanYMi+2Q+EFNrgDrA1LGWAC8eZLxwyfDUzJ1Z6B2Tc/QOSfX1NPOHqMLm+aOrjnmOWbckldhWmGranUQuJ+fTS0W4KQpNTKppmLcWZksNnhfqd1dvgnwbamPcCrwKFYZgR33EHZVbjEp5d9eWM9QLql+GFvN3nHGIn3sSL9TVdTKP04PRPZqr4QVhlW6pseup7nw6UIJcZUEHhctQhjWPDHIv3Lo7LXgYpDHWM6y4S4JtQGv+ANo86p38/jrZGEZ4ITun+WUCNG5q9+kR4bZqchtFZUiauQUOO+ZnWp0yExsIlqy5k0yvnLF3c1WcWDWiP9WyFRHDVNyqat4AuvD5dqrXlSzLrmr6KExmknIAwY5Z3F+clndASaI6U1Ezf77HCgz6r+9VqZiKHkUYcVfCTqhv2n9zOrB86GqAHneV78zfxLOkf7kPthj8PD7mw2ODB3jEJt5H26+Botm2r/h4ZfONctqs/Z2aksMIZXdcT2s+qXJoKj54x9ul0ym7Y6ZckHqB5B/4QMiEKu5i/v/FtXeMd6VxOgMoc9x3
 pkaAL6bQ
 fshC4le0iTnTKFTTZH5jWC3nXWZKsYLj8jWIPZDdvZZUYe2+pfiRGgFhQgUOKzx76t5mFmx40DqXUw2OzZUII5nuEVjsRGc7P9asJlZz1/nLyUZhyLePoTMJcE3bTD2pkbpv6tNRbrm5TEaUJDNfNqGK/22A2mwgLlTd8BCjGx+dLZnZevtRarUvDGmH7guUlz3EEp93JryBd9G/z2AAVT/LtIasCPgykc3er/M4DysODY06+xKhOtZqs0kBhO331dXrqLgzBODSpec4XJoWKqnPi98LFvpD9oSidpgE6M/rjCaGudj7PSikq+jke/m9iTE9Lyov8I0f6N1oVT34Fbb+76KwZWbP+xoD3oGE6c+CLT0K641rAgPOYtcL8sKJWOuw8zxlBN5Wf80gJAX3N5x/5nOia3S1BTY5Uu4xmKNUnDHEw54myynELxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that all VFIO PCI devices have peer-to-peer capabilities
> enables, so we would be able to export their MMIO memory through DMABUF,

Let's enhance this:

VFIO has always supported P2P mappings with itself. VFIO type 1
insecurely reads PFNs directly out of a VMA's PTEs and programs them
into the IOMMU allowing any two VFIO devices to perform P2P to each
other.

All existing VMMs use this capability to export P2P into a VM where
the VM could setup any kind of DMA it likes. Projects like DPDK/SPDK
are also known to make use of this, though less frequently.

As a first step to more properly integrating VFIO with the P2P
subsystem unconditionally enable P2P support for VFIO PCI devices. The
struct p2pdma_provider will act has a handle to the P2P subsystem to
do things like DMA mapping.

While real PCI devices have to support P2P (they can't even tell if an
IOVA is P2P or not) there may be fake PCI devices that may trigger
some kind of catastrophic system failure. To date VFIO has never
tripped up on such a case, but if one is discovered the plan is to add
a PCI quirk and have pcim_p2pdma_init() fail. This will fully block
the broken device throughout any users of the P2P subsystem in the
kernel.

Thus P2P through DMABUF will follow the historical VFIO model and be
unconditionally enabled by vfio-pci.

Jason

