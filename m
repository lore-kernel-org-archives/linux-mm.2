Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69B2CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008F76B0005; Mon,  8 Jun 2026 15:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC276B0088; Mon,  8 Jun 2026 15:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3986B008A; Mon,  8 Jun 2026 15:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CABDE6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:52:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6958B402A9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:52:37 +0000 (UTC)
X-FDA: 84857792754.19.8943E2C
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012012.outbound.protection.outlook.com [52.101.53.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9837CA0002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:52:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fLNf1lsG;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780948354;
	b=iFXu5s/YKD/cDPdQXV2uJs9wPSNO3xOjWe9EZv+1Rn/hD0DR4hMetLHaNVaXsLmBiPUYiP
	B0jSvNFM/nuoG/aodN3tCKetXnF4MnVIBFOo7QVN+uxO5hw4XAy1W5etff0xxlUYInffUr
	sQtXGgVCYI4FcG2XCf5D9nonIM5TPMA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fLNf1lsG;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lr5TFNWSXBb+Ofo4mjiexGCELXdTF3XnWM841LrVeGo=;
	b=sBB57ImkZxFw9oMc6n5A6Ls0e7XXm6eE14K3gNw6glUGO0Mf386tgGuv96XLQZgkGej6xG
	HlnvnUq7TZlg3udP1MpfrLwj7rYYT0onS4EjeRxh7nf4a2+nqcTMxHdrk7Cb4ky9VM9yHw
	fIvjscYixeVyRAASJLYFXnPRDuQ0zqY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4UrE3/otrBpUP7ncujYgog8QPvvoZ+GDT+V7fT2Cp7BJtopvhVyMavMoZrVzQvUNbAT50GfYKQhPWCcQBdRlR8ZuMQDo+6+kEr1mQu7EBdzSWX0BlIbKQq1KhGEBtsFU0VP1wfkfXfblSRKs5WfaxMscPzCdqcti/HJPw4bWEQsJvvnmr7K0edNG7N573BJ0Jidgig5W70e1AO4cvQMFBbiYZWg50tPz8fDhhgmOmF20QIM+kEPCvO70641cvMwGMJPOAYCWvy1687zu1JHoUvzwUATwZsK9hxzXNZhzUsgL7JngIHNmGViF3vHJWK4ReQQ3F4tXg8i0z/K6WzLGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lr5TFNWSXBb+Ofo4mjiexGCELXdTF3XnWM841LrVeGo=;
 b=a36V8ERK+vKSvEgrvBtnwNoNGS6sIiS+L4wJyIQKqaDS2iJmVIFlFaDUnf7kB5JuBxEA66Imp65D4kQ2CxrsKmubNlXFLaimc1vK5ZFIF4AD1ZXNflQzhqA/r0DwLgvo9hdp8f0MO7AVsUiEi7cJCtcBeaG1NKqL/BCdzcoson6GsE+PF0XxSMszzcNlRhsFfKU9ynhNSFnydfMtxiSZng2qVxT/Fb1Eb6wja69G/6YF01Zp0vgHalixg4xoCpkwQqgCSbKiipOR5/oxD8ewxxZl0S7npdWDsW0SMkhlKZQt3w+3A55T5b9VhuJ58mbpfsNyTTuTi2LP9lhcjtfZtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lr5TFNWSXBb+Ofo4mjiexGCELXdTF3XnWM841LrVeGo=;
 b=fLNf1lsGdD87MROaglpRuKsn2YM1A/gGXJGimSW/hty0Uc93BxZsVR2TbjIjpRAbIaESCCEMB5t2Nor7Li+7JWcbbOOqTrs2/1X3GJqDmsl5gpZLHjgrYy4Ppg10CorsXdZPzrA8rMNVmBxOw3RU9AzCSDLu28J+bw8hK7w0FMqbesuJxFCkwbqsmQFYkMCBiV7Kfh7LnPcDffKEOmB8ubWd0VCIkd4lFvh+5J6kiSmP98FDPvdi0yR5qSeBM83O8oTDTzVpHVNaYKIbvdh7Dyvlyv+/vLblgaAW/8nxdEbXnP2X8APgh/Qf+LilaUqcEWvzpYhuRT3CdCvgxOUqbg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB9242.namprd12.prod.outlook.com (2603:10b6:a03:56f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 19:52:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 19:52:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
Date: Mon, 08 Jun 2026 15:52:20 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8BB8D6E5-8644-4CBC-BAF1-0AA19702E042@nvidia.com>
In-Reply-To: <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
 <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
 <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB9242:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b93c480-b3ec-4aab-c97f-08dec5977628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|4143699003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	RGqEy2T8M9G9aFlGajlYANERdvMMk+gwcwF2ewNM2rT5lHpyBw/YnMKYydDyHr0UoR6li2TYK9qbzXTRql9rvJ7Q2QOjm2iuG6Q56ZkAhz79BZafnyZmENWIfiA5SlkrvqvCRgfA7kVJn0TRipUZW/jv0KvVLs3Whtd2ZL1fK8/b/MFzOMriZhtTQS2bs9Xxwr6Va/7HaOOLRTCxV8e+GBJzJXozg/deIgMfmpGS5ym3f1MTkJa4z3ks5EEpgKRw2WMd/jp/l4IFqXy5EAaGlKtTzu0oNyyCL8z4X8wKb88+XNYC125tSX+nCmm8YZV3MdqRsqHuAHgIGKLEeWzVdfeqm+98N4/TX8ldpMVMKW1sT5wrp/dLx2QO7qY0J1+buWeBsKc8sLUgL2ucRcdew3y3HpQiNvaCey0Z0128LafmpJxP4x7gYj48MNbIqZxr0QhjBORNfiABaqu/S43832je7M/Zx07lUI8VR1WSXiL8eiwtZvxVby0H5Vih7bmJ61q+dAJseJv+WXlFUbetxX4JiuR+MJXW2ho4OPOYavC4jR4kH/M0yaDpgouQNIiT596ipopxKzNIsqVW9C/Ge2fl7geAkbWobOhG9yxCp0puY8bwTgAKJG9LkT+2I7w03kx/pWv05j/vq7OpnNfiNn4IYizI9gtevMruyOP3W/SnByfGbZaWwR1FcuefnYlb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sKvmK45U8Jl8oo32p7B/6Hox4mnmS/ih3xrrfQpkHS3/PDir7WL2FRUg5TZX?=
 =?us-ascii?Q?AyKCrHfO45DiGfpBg8NF5fiviG0swneQkCZRDrPtXJbrLXP7OvFWH7xZWzET?=
 =?us-ascii?Q?o99h7znOPxErDZnFpxBVs/xgk742oKCfIGCvxBVSZ2tK4ObHSi0s//bl2UKJ?=
 =?us-ascii?Q?5oJLOKG395i1AC6EpiV6YPmlvosHlMUx2xG4UseXSubWQIpyfia/Tl9+HLpP?=
 =?us-ascii?Q?fztoNQmj23veTGSug8rpQ6Fh8UrjyboY4HSr/n9u+8w4PvD+8vvzQ37oNkKI?=
 =?us-ascii?Q?Vt4VJHvb2LAypjt9Of+8r0K3/0x7NMgCH73iB570ay6cXU9FIvjBKvFgmfpT?=
 =?us-ascii?Q?eOLOVAUUcyKGeCiUnKwQ6+I8JllqyTbmVGumbjUdASU/8EFquJCGk8G0ADXZ?=
 =?us-ascii?Q?yvnx5VEuhXJevhXdSSVArko9BtrgoKi5tX3fWFRKLiBQTTO4igZ5nqQeFBnP?=
 =?us-ascii?Q?2wx38+gYNa/UbfYY8xENXjRiVe3kpfNbKN0zW3kRoYlNpF57otn6KubMsSdF?=
 =?us-ascii?Q?B2DAYnReWDV7ssn0S6DN6UUmuGaJ8Luk35kADuQRcx5v/7Tx2etB7VE9BFQL?=
 =?us-ascii?Q?m6X9Havru51ATb3oP8NpqFE8484UNjbP0YQs+fs2kY3XpP0MzMXk3J2nFCvq?=
 =?us-ascii?Q?gQk2eHXZ8jrzcwsHRhwjrGiy2vq3L+3tCBNudnfhDAAKfpP9shiiWdAVZiup?=
 =?us-ascii?Q?b6eui3jQj0Co/mRGPZkhpwl/az+AjJxjxSYnU3yIM4waBjtV7cnxp0/Q6S7j?=
 =?us-ascii?Q?ZRcYdjvilM/21H6acgsZTmsr2rkXHYImZBaCKuHgPEMdaUOX7bQ0O4MqC88v?=
 =?us-ascii?Q?2pV14MLX4umNi/U9Gt3zuOjI+oaNGtKvSuQHvfaliOj3lW+BPVyUyxGe1Mpj?=
 =?us-ascii?Q?FDhpvkYVkkjM8il5gozVLNzVhR8SJhjaqZp9b0M37/9mANqsvt7mnxUA8jIJ?=
 =?us-ascii?Q?R2oq0hdsuruljthOQ0RGRAINbudi65hqh3mBwWelyoekJO5OwXBNSgNauyA3?=
 =?us-ascii?Q?TefUHbEgRN/SnfzHuGPD6NKApAY+OWu+078jr2iTqy9SzF26xFLbYqKaD8hQ?=
 =?us-ascii?Q?p4eUOf4PdxLNjwMWJWA3tiAh+DzqT9TgbHtOWIxrpEPSPhAaMoEHtlAm+O3d?=
 =?us-ascii?Q?ckmie3xVx+FXVIo/cBzoqYT8aNsaQ5Q+Zav/5MP6ho5bSU6TltDc60yCTmci?=
 =?us-ascii?Q?mDDZahUR+SS4bLlyXTTnm3oBGZW53wDRkyyyvqbeXvxUmhW/g9WQPSt7Nmpj?=
 =?us-ascii?Q?5GlMaF+VhM1Fcq/WafKmOZtfIo9faqFbE8gGQuQAqtLBznF1eJUqjPa2k39h?=
 =?us-ascii?Q?4cVfISDygjy6Y1pQum44uFTHLVdZZOpg8E2hnk8b1CZ3c/Ck+hwxsuA6MiMQ?=
 =?us-ascii?Q?foPLhVIzB01aSqr6pgBEwVW4jHUIZ/3qE3fG5//rnREtBgHZPz0h2BR3MWWB?=
 =?us-ascii?Q?ZpGRgcp5OzvbOc6CeHQYKOAid0aZQkTimFUAXP0ltUat35KWLzsAseSJSKJP?=
 =?us-ascii?Q?48W0BpmNSrwOKWRN77Dr/Xy7gn1hCw67kxiy1s74UqPvktt0ZZi7yY+r2fzx?=
 =?us-ascii?Q?re0EAk2UCNc+izzs6PX1C+2Hom7ZKiaAzlZYQnLwhuS5MK9RK5xswgMtiO2H?=
 =?us-ascii?Q?GFvGX/A6LBE1V+rhAhXDOZfTdWWtfKgkyJdYq/ws6siJM6Gpex87iFpkCW+w?=
 =?us-ascii?Q?uSfazFFdAcNxuEZu/31mYOJ3EQkKDvxHQUZ/p5ozlQreLKhQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b93c480-b3ec-4aab-c97f-08dec5977628
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 19:52:24.7777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/UCo9184c7tzNNy8y8jcaf2inQugAeWEtRCLxxvL3y45k+ma0PRqAOWjpQqkJeH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9242
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9837CA0002
X-Rspam-User: 
X-Stat-Signature: 4bfnmqmerheg3pakrf566rzgqqbmbsrq
X-HE-Tag: 1780948354-310580
X-HE-Meta: U2FsdGVkX18noDswx86n/U30ipRdc1AmjgKMrdP5v+4MQ1UEiBCi3Zd47WytC9dVrRHIvEgM44MVwKnpvMr2FyBRIPAUYJxDwFgrvHQOQXLzvAQJUhBL7EA1l49ldaZ46cZPdjTV/ffgfBMpDvTdOnfk6llDKw15TrupIW6zmkbjWETrYa/f2P6985ZfqS0jTMph+Hbd7+Ygy1f7YwtxEtL5J2ShD1GwEg6hkP3WdXTD/Z/lM55EL8Neia/dPFwLqjJ9uUcrehPpM429CeUnvMypsa3t+C0ycctGSVAjnXLrWgbHqoTxKFO3jwvgV8ohmiRTFiR9ngG6eybIwoobNmqf8tpT9OOYWi/Vumcyx+TZpYRllcw40BPQM31D1I+qngFWwxNUon1O+LauGrYaQVRYNcOs+kOs+9w0yAK6cm1gP28G2999eJ8rhdlmETQ6/6M14a/rGsZkkuvD8OOY4doxkXHkhUG8TkSbx3FO14DaExOi9C1HfLSlhKIYi6qDfDn7HITJlSxueJf4VhY9OomPrWqjGVafyJL5SrTTjA8f29qY8TwVYDW7e29CcuVT+8JkUt43pfRinSAk2IL3I4HtychwYlIpgzDBWTMLMYjJMJDXY0OrhUkKiVrB8bjWpKWXtAGUPrG8822BGLM/vFiehOzILdsqoBWQscX0RxBIRbym0Fbvqs8i8C+woRIyXfYYf8LVJUGgyKjTiqssraa27GPFQvhRAPzjS6cvlbwfDciX53hW7wyV+MinpyIZ3n2pjn+mHw2YDd1VXFxSKn7sf0wdvVKXl4ZMlkDnlilhAhUaolv9c3WoO2Q4LvEdN130Hq5jR0vZ28jDL4hqjdoKfsNDfq0Lv18Na9kRRdNfshHfrbNOuMB78HcepBdjbJ8/5u5tPL74sxB2cyi8Jox+7Fmi1krpTVTvF91rAxs3VDPLkwH8RccJUT9AL9etorJGCfG/gtcLqFcQU3d
 tv1wFczH
 r7aRYfBNJzQ5m9zfa/R4D5E3zVf2k1NsBYW1LzyD9jSnDE9QFNPmYY3j/tn0yhDqiHxDzVuZJ6lWrH1fEHFNeJmGSLr62g8c4K7pIjB+gYGKhZQK38hPN5S+A63pjw0ZUNciU5MbuSQEH6ELvZT/PLcQQrnLQL6YnwkQ00sCj+jCtKFoTENzXUddWF0XmoYM/Oh4Ed1+J6RiJE2c0bq7sGoOsegFAa38IeDiGj8OxnBxKQ6Zth5P0ecrAKADRD/c9vpD/iWxqNukRd+DLQH6onCTn2VR+Cg6u5heXqvef1bgjKLC1PiIqNof7AdxnBaah+DApgEKgjVLeoImHCAZPK+EGSt+60+QVJ2/dYyjoRfb/YgftM5/9BuEymsGRLBlq3cfz1pc03UAuvAqullcRbPbXvUczjplfFS76HFVedw9k8yWJKAEM6JkJmUxLcgU1lKrycPf1zylvgpUkK4J/nAce9ZfSXTV7zxUASEnJZz5AGos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 15:43, Gregory Price wrote:

> On Mon, Jun 08, 2026 at 08:39:10PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/8/26 17:27, Zi Yan wrote:
>>> On 8 Jun 2026, at 7:08, David Hildenbrand (Arm) wrote:
>>>
>>> Or should we defer zeroing after a page is returned from allocator? So that
>>> user_addr does not need to be passed through irrelevant allocation APIs.
>>> Something like:
>>>
>>> alloc_page_wrapper(gfp, order, user_addr)
>>> {
>>> 	page = alloc_pages();
>>> 	if (gfp & __GFP_ZERO)
>>> 		clear_page(page);
>>> }
>>>
>>
>> Not really sure what's best here. I think we'd want to limit the lifting to some
>> internal API, so it cannot easily be messed up by random kernel code calling
>> into the wrong API and not getting pages cleared.
>>
>
> We're a bit in circles on this.  We discussed explicit interfaces a few
> months back and the trade off was:
>
> a) add user_addr to the existing API and cause churn
>
> or
>
> b) add special interface like above
>    increase the buddy surface
>    leaves open the ability for users to get it wrong easily
>
> If we forget VMs for a moment and break this step out separately, the
> core question is whether page_alloc.c is the right place to be calling
> the folio_user_zero() or whatever it is.

page_alloc.c calling folio_user_zero() is fine, but my question is
whether we should do the zeroing inside post_alloc_hook(), part of
allocation.

What I propose is to lift __GFP_ZERO up as much as possible,
so that most of allocation code does not need to care about it.
We do the zeroing right before the page is returned to callers.

>
> We seem to have agreed "yes", which necessitates the plumbing of the
> address into the allocator.  The question is whether it should churn the
> existing interface for have its own explicit interface.
>
> The implications of getting it wrong are:  a user page doesn't get
> zeroed.  *oof*
>
> I think that's why we thought the churn was better.  But considering
> we're already in the same state now (callers are responsible for calling
> folio_user_zero() or whatever), maybe that's not horrid?

Yeah, some callers think they know better about huge page zeroing and want to
do it differently. That caused double zeroing when init_on_alloc was
introduced and was mitigated by user_alloc_needs_zeroing().

Best Regards,
Yan, Zi

