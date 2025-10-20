Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E2B4CCD1A4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4C08E000B; Mon, 20 Oct 2025 12:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC7F8E0002; Mon, 20 Oct 2025 12:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB468E000B; Mon, 20 Oct 2025 12:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A97278E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:15:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 566071601ED
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:15:27 +0000 (UTC)
X-FDA: 84018992694.06.DDC25B3
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012049.outbound.protection.outlook.com [40.107.200.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80CE3100013
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:15:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ejj7qNPH;
	spf=pass (imf05.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760976924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41BckvWFoxtxO3VDpMnCNqa2ITtixMnH9ptSvTm8t7E=;
	b=WmE0s3f4kutrggAWam6jzR/sZ+E1kKQEKWFnnlqLdbd+ym/jzC6mZxjOPAcimcSaQRzaMU
	37WPpd5bqH5wG1dPnvW9HCdrm2c9WEB1ARj2M1SCr3436pBUMKGDE+R1/RLQwcwER2WnGv
	2X5tkkswkWc5+Ytxz+h6ZlPrDgjS85M=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ejj7qNPH;
	spf=pass (imf05.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760976924; a=rsa-sha256;
	cv=pass;
	b=tkFhDKnxzfgbq/msefG6sHYTAZwG0XeSXlsDqgBjTkSqP32EIlcN6wU1kg3TKfXlBCh9gK
	ePKofaCzSGbeSupC3PJGpUIjPQO7gvYp4v8tj8o9QFhukc/NeE4/mNbTNjZv/9NJM4kkV0
	GZnyrK9Gzw0bYmKQKbb2L/KkHwBD4aU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SAEHSMCczvkRZJV8nX+6Be9Y5k8NXHEiW+p7b/iVLnONxcqSix5S8Qw6M8oe2Z4nHTYhO6GG+p51dMyb2/gqlAeelkvwD9sfcEdTDChLmiT0MU1tTwrUV8XAVjvcFDcikJ73RkWVtlchp2840JYs0Yuzh9uLzThRM5DtsQku52c3OEX7Inc/zvbJDJz/3JNBcrFMFBUfsarbQTVC4A/5QQ/DOWSFifnW69TI/hGWMqXmTDC+Z4/eOR3HasQmMQHu1Vkm3oAS4nJ6qFIYSWIAGe1UjDmLRfTrJOwFmc+/qu/3/9El+j+tPM23VHdhLZTHKG0LMg6oMTFtlc45oeRVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41BckvWFoxtxO3VDpMnCNqa2ITtixMnH9ptSvTm8t7E=;
 b=jJe8rog/cAN6fvJYVr33+fJBf94ysvg2bKsK5rcylyWYvzv7X74sOwzYp9sKLHK6RoauR13iS7ihHm0o1mTJX1glvMfDf1NNW8liA2XwtA4lWe4P4JDtQ3umaDp0STmT59BA6n01ZRJJYomp2iQdt+FxeBup9DSsyLvzAPv0DwvbM/g8QCptFYZTVyVdmBwCDATdsiiuv7KAJRWVKKwBmf0Zpuz2WJITgN/lP7kpI204S7lQFDJ46o59iizt4DIhRBdph6/nfGz6T3ijyXX47lFCPs8gNnLIZUIFLrLIAam0zvPhCQFn6LznVNorcdla5XsRG4JAo/g0R3dI2nlFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41BckvWFoxtxO3VDpMnCNqa2ITtixMnH9ptSvTm8t7E=;
 b=ejj7qNPHzIFwhnmBmbnaXhMyHoLXBIvph4BHmiZgwARsZqDDDFTRUbaRSHHGNk+gUzop/xOziHPGhsnoc9beN6yGQgdvyt90QMG01/iBAVPmlYQjH6a7E/CAoXbhOUruUuRf7AjfEphtypLp2ljm81tOA5vVTnpbLtSQlKaPiWCFHqC8vSjI5NfCG5BlBpdOarytKsNWXoFGJ4i7MshOhJ+m4xszZP7N3a3riPGq801qK3+x5+m66KnDTBWLouMdUydeOdWtGPseQWb2Qwm8/01Zb9ZzqcH4+WIuLrJz+Z3xU1hpfMjTCtw4QV82OhW+kCXV0XIN7tKiH8b0kvLM9Q==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6116.namprd12.prod.outlook.com (2603:10b6:208:3e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.15; Mon, 20 Oct
 2025 16:15:18 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 16:15:18 +0000
Date: Mon, 20 Oct 2025 13:15:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251020161516.GU316284@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251017130249.GA309181@nvidia.com>
 <20251017161358.GC6199@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017161358.GC6199@unreal>
X-ClientProxiedBy: SN1PR12CA0102.namprd12.prod.outlook.com
 (2603:10b6:802:21::37) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 22484875-c16f-4d04-0dc6-08de0ff3dc7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WCibGPCoML6CUG4RAp6YCyNBe9v0/WqeKC+0MgzqAUyzcbL4aM0fw+IxiOUt?=
 =?us-ascii?Q?LytaloekNIqNtc7Pmxuyjb5uoliN9J8G8R2rWGyvaLDWOocyttOAt0xvN1NM?=
 =?us-ascii?Q?sRRb0Q5hNK1l9zUSjtEP9C0rf9t5VnThYDosQJ9Vxyfb2xwLeEcqkkA6MYuX?=
 =?us-ascii?Q?gLoiWwOUl0SIWj2AU0Z2DabiPkKp/7L0fxtCnBTGWvmd0O7rTSxqxeQyMhoD?=
 =?us-ascii?Q?1naVvUfqrZxI3KqN2TDtb0qSMVA8QXwt0pLRtmqbWJ+V1oUYrqaZREon3qLS?=
 =?us-ascii?Q?W5VSbYPeMlsMCMw9Rh6xa0f12Scjdk62z1WTb3SeqkZj7WPQFROHC4K8g3zE?=
 =?us-ascii?Q?L9A53sSuk8C1FxvTRq3kTG/oq+0heB4mF8zxy4E51BrjLZrVfL6f3hL5vViu?=
 =?us-ascii?Q?mozC0HOTiPoZdkHb3nwHYTENVq4b2zhIWIwTgID7KaI1cWoz7R4I66tvNdQx?=
 =?us-ascii?Q?hZpxarEDE/ETtxQpGVNTq4oiv9lB73O9IdVWsGkq8Ro3W/dIV0NLY4u2SL1h?=
 =?us-ascii?Q?mbD9ZZKnUj0PskcjT6i+ziSvMraM22TiObuRWah0bQt3iOvC1/MvcdIDG8j0?=
 =?us-ascii?Q?aKym556WhWEWBGZVyYtmb0aVDw3Abbej2Qzbzuj45kWp1v/TTyQIcEMfxp9j?=
 =?us-ascii?Q?Vv3RGEuzrRHKwqtRiT/AiG8OSn7aIZGECLlNKlvDIqDvP0jln2JGYHtGs0PO?=
 =?us-ascii?Q?5h1PF1GnhGs+da2GklE5YZTYQsuBNl44cEeIb8nbSIkJSDPRMKo9PyV5VQQd?=
 =?us-ascii?Q?rkwuk9RxV174nStoGOjp6hHAaBbLIDTM0N2/maj6d3aWo0ScSgIm+c7HN1Xc?=
 =?us-ascii?Q?SHuSx/XAkKqXL0tSCpfrlYK8eVmmW54bZYWjfA/LoFq4Ae83avfTK812HoFy?=
 =?us-ascii?Q?FzH6Ut5/WSXsyzznlA4LBsrgxxGos1unjlurARR+2+nZi+Tr0d/oZx3W6qoC?=
 =?us-ascii?Q?PGrPPMukgiH4S2mmuC8GBpYCsX7xta4snast8+Zx7TyoBSZS+HkUm6Uf+pUP?=
 =?us-ascii?Q?lzilcTaV8JOQkcnh09rKHP37Xx/R/3bXTkOEoeozLFoaGU9hwyLyjU4GrGaX?=
 =?us-ascii?Q?LmK8CiVp5si0GgR6qkLqhEJbJIe/KfCcyW+0ImfZFW6VLArIDbyh3QozJp/g?=
 =?us-ascii?Q?qE9j+UnA6RFvI5tC93qAjK2Kkd8YCMqYPAhO3e62eSs/u2iAnd6+IFFgDsXf?=
 =?us-ascii?Q?s6WkOA7JwuEgQ5jbUilfkd+JfvtXoSM3XSU87+LS0YW4aC6oUnJyMJwupsjR?=
 =?us-ascii?Q?suWUUccS4ryjSZuCsMTcopyR4o8a31tysGlIoZvvOl6FDV+uIbZA8O5yMuwa?=
 =?us-ascii?Q?VCAXCiuW7oR4JqWvGbPzmvgws3B2gTDTfuPsrf+VBFGaz/IlpIe5Ebba2PR1?=
 =?us-ascii?Q?BkwCjSggH9T03Fh2kmEvNZAa9fuBMnPo2WOu5V2jUtn49REmEiQdnB9UJYlp?=
 =?us-ascii?Q?cy3384ai+Zgh6d9yFYBPhkAMcNAIqF2v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fnHtS5OGX+sJVKxIRNbBNm5l/e12Uv6f423Aq171zzthSjLrpDH33clq+k4r?=
 =?us-ascii?Q?DrVt4j7CO8+LCO5uW4pGV+zr+vRvStk/t0uwzkwYMRbXksEgiASXmxAIGJq8?=
 =?us-ascii?Q?kPvsVmNkCu5tCDuxkPxg/z+mLdfYUZIw+QUXpceAHvf9TQPSwBuwRe5NemV4?=
 =?us-ascii?Q?0V0xPLQ/qc2CPitoQJwVxpgtEGletx+g4SHr9R/X5wIulacul1UdbNjymPOt?=
 =?us-ascii?Q?663tinKt2XeIXCwSmiZnVnn73NZAiCZhVUUnlhRMdoP8ZoFauw+NcUsNP58d?=
 =?us-ascii?Q?F/jlOORuiOd5CXN/pOsdHVUyl+GcV3DbS1FC+8vNEaHNZHVXgHKHTALBRkSE?=
 =?us-ascii?Q?dtzIxfcqTQXQij83r9hhi5SY44mPLu2Nd6isuE2krXtH7eqfO266bbylPWPm?=
 =?us-ascii?Q?Vo9cn55bAf+ITx+V++Mpn1ZakO+1G3GZbEwfbNHeWb8NhRFv8xp/AWykNBM1?=
 =?us-ascii?Q?DMXvJ6EsDYjWKEq8inmU8gowNkdJKW3C2tNe9N2KYERhkiMGtjn7Fen6EAtR?=
 =?us-ascii?Q?rz1T/DJYcfVXXZkP1lygcvSY40V0HZA8+l1VuhbY69ei6/b7cHaej6dgGh1m?=
 =?us-ascii?Q?yH+PnJjcz2dpN9htLYL4alEN8hCz7uVuMkeiBHkNwa6hep36wPQogc0ZYx4t?=
 =?us-ascii?Q?73mru0a3tPDxTnJadKtVEfg5CbJXonJ46miARm4A7rMbfwt6XSb6QaXoOO8b?=
 =?us-ascii?Q?xLY02OPo2GI4D76QhdOqHlG4EToCzuKq/v2qzPJ/7N2zBbR3CyEzJU9U/Qok?=
 =?us-ascii?Q?BqPlkgr+9rmhucc9MkZZobXnusK3XI7vUgTGJcj+fZZ8KqAJ9KZvPxLKrLfu?=
 =?us-ascii?Q?okSDsbtrg5QVkqfJnuancVxLlyrUWfP2ORu91Q7M7rAzEOmqW5n2PKmu7FMg?=
 =?us-ascii?Q?usx15tIyl5vjdNB26f5Z0FkGN+eg+Mqz9mW3b48WkB4Y4xxOEJtDiFpny704?=
 =?us-ascii?Q?rStJhsFCZdOEaYVDKgWGouePPULikv1loFTWK/OkGflZUfrY22PNuVWBSMDt?=
 =?us-ascii?Q?m967dagyUfCLC2V1IuNbgf/GjF0ucYKvz4j+mcBExzjn1ltWdHhhACvIIMGa?=
 =?us-ascii?Q?8/57UBUeEYM3VqX7zNagkINKadUFop5KvYmxmoLpEW7cPipWohCy9SlMUpz5?=
 =?us-ascii?Q?2bgHhiHVj8GySMbI4FFlKPZeQf/l9GIuiwa/8ENO7/+w7KuGEjV33Hb9fhJm?=
 =?us-ascii?Q?njjfTPU6eNaynTS1Nb+yt9OWo0c1884T7GAKh70h2cZ5JryHZ94YF0Bebx4q?=
 =?us-ascii?Q?8SUByLglMhhwAG9wYYN+s54qBGvOWM50XZ593Wzgv8WpFC28ahMbvxHzjvAO?=
 =?us-ascii?Q?TBvxyxw0pg2+GaQwTF5+xWZQA6F40DBdtibWQrQ6GuNl1S0drNNJnwwSUi5t?=
 =?us-ascii?Q?FMDcKvUlpkso0+LG8u//Rpez+hYyNkugo6HGl7v2O6KZhNHe414rrNdCK1XR?=
 =?us-ascii?Q?thjacfPxnTm6HCPe4aB7UESL1d8mQMYT5FyDrfCZjQR+p8959v0b/Y1WjKat?=
 =?us-ascii?Q?Nwu1X4LrrVfL9njXEMBX2KjmElgQPyY6Ml5zT6CJepy1GX1HJ3/GoseSrlHG?=
 =?us-ascii?Q?32JSIfiUGA2VUQ0iVhahvRzzicul4SAE5C0dtjTF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22484875-c16f-4d04-0dc6-08de0ff3dc7e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 16:15:18.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiL/HSY102ZKuwLeHYbLe5MeOv9HdJPOOFtLl6XMpQkPlXzaeAj9hdnAzpCw6x+U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6116
X-Stat-Signature: 38c3ifc6mtpxr46t75kr6axa8y7th5uc
X-Rspamd-Queue-Id: 80CE3100013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760976924-376470
X-HE-Meta: U2FsdGVkX18zL5+Q9xlSApoz9wzqOiXLkt1gJPSEAKMN8nKVexB9I92mX8qpzPBmyjXbYyiKpckhSDJNGXuDeT9pfF8M544BTXcQjwI2lqd9i/Y9sPA/XJseqW4BCsywjaZPDv8GzvEGQ6sSf0+Ea6NvXLdDQWXiJSSzvpP6FdLzf/E/JYUtlZtuaa/41ebbWSMSfuzFThflB6BbebOw0+KY20LjobG0Ax+Oy/KVxd4UTefcY/Xk8NtkVeJYL4lGmp4jHaD7NJjVWE7KC3Qx/FY0vNI8aIuXIcmieTts9CmP+dBl+9p9B4U918KpJtv9BWd2xqxbfEZdIpBhVxriVhJBcq1vekkTg4XGN0LU0Yu3JMYE3fr9wvgjMsvo8HnS3h+M6oDgFP/Ic5H1wMKLGPVuUDMaDg7rjqwcQ8L+gzKImmb1qQn3XBl2/U0DrYf38+GE9hILN17ga/MeoMVi+RHiiH3d3XswfdQt+BMW8RWdj51UILhFt4vZeNR5Ic44M/UDaMhHMWgRIVZjrEiHyTHJ9BGMgupVQGsmT3azxYOQJVyIO1xv/wV6WMmmYO2DuZTjGwXybUGsRqvwLOyHBKdiCr/lGJr29aGT5es8yLIDrmZ8F6xAAtoiau1I2IF9PAEpft4UhgfnXgEyr3HJi1OSic5yTLh5HsydiWYQHx8Yu/LDxjrgAWHL44+I6K6bDziVjY2GffK5Ll4rZmKwdzOqRt+0yOk/ozongPx2shV+a9SPt4iOAqUUZZX8RCQNU8IBHeG/vOGrb6YxIl77CorG77JfUGEXDAVW6TzzD8FMlyRJlyZ4GjNY+9lOu0QnjaKbBTIWmesd4vDG+64ZArqmUE1yMvm1GomhEud3mR0/FB5IrH5WApQOCBAVifS6lXPQlaAvlQlcyR5YfSMIR5n/f+s6Skmog/EuK6uDmGEKf5AcBYQEeDC23YeC5cg0P11PCn+yFKLc6kF+gVz
 hEfUWwlM
 3qVO/wmiiIvpoSOlU2NoV7VyEnmyAycsGRlXjdAB7kPjfrvgCNDguFb6jXvG87aubx/XFXPESfgN0EzTQxbU7g87Y1oDg8ytKrbo8AwvAcCs2UlF5nQRYlYT+DPSFbVd+tj4GF+MDLr0psdeaMw2rxZ37hOTQikVsk+3rMXOn9XTQnqwUNGS8tb2sZkP6fHjZfcWHjyyXYwUXWpg/tBb2wc1w6opmj3aR2Nj/utuZV8DsN9feSphLtFfGd8RoweSCcZ7iRRpRcSQXKWK/g1kVGps6AbckZDGJwbZsTPVDVGvnQrgP7eDzcnGIUxnZ7i72kLoNSJPkWSk8pLqPYoLrqezTYZcB9zEJpfvhER14TBJiWQfGtp+kShFGyx3mMrh8zNZ6Edc2JtkZn6JZt/dgzajrrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 07:13:58PM +0300, Leon Romanovsky wrote:
> > static int dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > 				  struct vfio_device_feature_dma_buf *dma_buf,
> > 				  struct vfio_region_dma_range *dma_ranges,
> > 				  struct p2pdma_provider *provider)
> > {
> > 	struct pci_dev *pdev = priv->vdev->pdev;
> > 	phys_addr_t len = pci_resource_len(pdev, dma_buf->region_index);
> > 	phys_addr_t pci_start;
> > 	phys_addr_t pci_last;
> > 	u32 i;
> > 
> > 	if (!len)
> > 		return -EINVAL;
> > 	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > 	pci_last = pci_start + len - 1;
> > 	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > 		phys_addr_t last;
> > 
> > 		if (!dma_ranges[i].length)
> > 			return -EINVAL;
> > 
> > 		if (check_add_overflow(pci_start, dma_ranges[i].offset,
> > 				       &priv->phys_vec[i].paddr) ||
> > 		    check_add_overflow(priv->phys_vec[i].paddr,
> > 				       dma_ranges[i].length - 1, &last))
> > 			return -EOVERFLOW;
> > 		if (last > pci_last)
> > 			return -EINVAL;
> > 
> > 		priv->phys_vec[i].len = dma_ranges[i].length;
> > 		priv->size += priv->phys_vec[i].len;
> > 	}
> > 	priv->nr_ranges = dma_buf->nr_ranges;
> > 	priv->provider = provider;
> > 	return 0;
> > }
> 
> I have these checks in validate_dmabuf_input(). 
> Do you think that I need to add extra checks?

I think they work better in this function, so I'd move them here.

Jason

