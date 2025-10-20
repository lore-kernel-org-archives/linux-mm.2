Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A50CCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B8C8E002F; Mon, 20 Oct 2025 10:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72F78E0002; Mon, 20 Oct 2025 10:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61D28E002F; Mon, 20 Oct 2025 10:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C57FE8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:29:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BAB985689
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:29:36 +0000 (UTC)
X-FDA: 84018725952.21.886C477
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9A5EA000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:29:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qO0Jbhva;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.22 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsMmPL0B1dv21zWKq0SP3H5Pfnn4OCXqUBOCLME+SwY=;
	b=3wYkOx6kQjK9TmNVNJ0Jtief3ET4kxt4fPP9axbe4guHpbuEcgA9hoBTwcktGTbhnhWzD1
	b5UOYnwohDV08nvSXItLGRCOm24+ZGOC4IrJTayQyBcxZuL95gezRtJiwAJ82ssJSHNZAs
	2m2kvSbNpuSrVBx7h8iR3QJGm+gcg2I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760970573; a=rsa-sha256;
	cv=pass;
	b=RnfAxv0RVUV4WE8R44a0n62TaY7tDxjukqRHIOFehhqmsMoaFm10UDTnZQEREXWYFRkogz
	BOMFvyXSeUJ7A5KUfdQxoHgPgzobrYLm30StpjgRDLqXNhPsmFFNqzRpPeFJAjVgALcwTT
	CJ0KaO4Kj0n3wY4VN2wIa05KSjZ/I1k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qO0Jbhva;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.22 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xyPdfwS7RCgsS5UoWtJmfoaZlsMUUzGBE8lSnQ4Qx8Xv+NfUuW7hbqu2VeiYdf0llVY/ccxGuvKLnqkjdNKqmzat+euQiNvvpU9Q0wMWaA2jPWscAo07gjLQKkg2ethFp62ucCFfooYmelKAuaNPiO5IMs/mhMkUTuZdBMm9tgClGVtiQeTtBkOryTAv/OviKCPDRI7gKcArW3lFc+ZvI/tIajGX3LQA+Pe+//FZphhOu2w8FyQcQ604I+mC+70ZqvQodpJnc19bVNNGVlXG4VpVTXuGbOhNoBMUHAUdsvpuhNEgYb+1Ruj7vDeMri1D1xzJvYfnvkZUmChMCDcRUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsMmPL0B1dv21zWKq0SP3H5Pfnn4OCXqUBOCLME+SwY=;
 b=ZmUkQAniUW+TpVliRYcDGfE/949uVf3APtK2H19fQUyyqRh5DFU8P8y8CH5aXH1z17yX6nruf4mPaG5Zu1hWje9R002Y5nED5pJVVxtHoCF/yS8lwC0DGB8w+iJw0ktcvU4RV5RFZb0XIUOifm0hZnCRO/0ahKDFYGcNPG8LqeQkpDz8ueQJkfwEofX4vDJzguL8neNnyiPJI1Sm/W9vli+5mqYsPW/Tl6ck0QepCQ5s74b2UO6N3uGdWPBXxpKEsSNxaZpJgXVIlQ/r9OqzJdjpmeaojKYvQf5eK9iphFutHBHuFLJNMQYg7FNhnQqoxlqWsyeQlb254tteFgyqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsMmPL0B1dv21zWKq0SP3H5Pfnn4OCXqUBOCLME+SwY=;
 b=qO0JbhvaRJO6wC0PG8AY4xPdcVVIglhiap7bvWHvUT20wGXqdPctb3skxhOwSjCbVPR2zLzHb3jc4ryr05eZoDkQhXsx4ncACR0gDHejkU8lvfl9QhCTKZszWBg/+1W6Qp8qkjSotFmJ+47p6Fh1uQLpGjo09LsNOudlbhAq7XRLfVb18ztPui2UJk4xKpueTzHKcNtMvTeHcyZ8SiZ98k0ilP37JAw8WZFNGrHw3LgLItidkOt8WRTP6aXdOaP/+zapNHFFxZS2mwHuFtFFtF57/AJR2cb6EIlnNEu2PBY8Y5otm0uRBswXhhG9EthJkcv1PJb6RIJIXXtRH85xbA==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ1PR12MB6097.namprd12.prod.outlook.com (2603:10b6:a03:488::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:29:28 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 14:29:27 +0000
Date: Mon, 20 Oct 2025 11:29:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com, hughd@google.com, skhawaja@google.com,
	chrisl@kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
Message-ID: <20251020142924.GS316284@nvidia.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <mafs0ms5zn0nm.fsf@kernel.org>
 <CA+CK2bB6F634HCw_N5z9E5r_LpbGJrucuFb_5fL4da5_W99e4Q@mail.gmail.com>
 <20251010150116.GC3901471@nvidia.com>
 <mafs0bjm9lig8.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0bjm9lig8.fsf@kernel.org>
X-ClientProxiedBy: BN9P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::19) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ1PR12MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fe638e3-dc55-4aec-8a54-08de0fe51233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jY81ke9d7g3z4y0OuOlwqPv7Mlvb3FMfeXhbvQ3T0BkcL2GGE3xiEDdO6/jM?=
 =?us-ascii?Q?xx68h+Dds+GCgWkNRSb7glTqlRZAD4GU0FRTonLF4nCXWUX69BY9dpaUVwH/?=
 =?us-ascii?Q?z6PGpDyQG9Dx1/VtuuZcbm0Bi87hP6jc5SprJLIWNG8oPsZ8UAbeRMRwjpLD?=
 =?us-ascii?Q?GqtaMVuk/Hyo3dttbai3NoWX4VsvultpXgC8dUQfPSdoUVbwDN3SSqh6v0Ae?=
 =?us-ascii?Q?GsO6QkYkfHo1uX36jlFjcDYppuRuN+vwC3rXcjTXIyOpB1uPLWxF2DuuDD4m?=
 =?us-ascii?Q?3+Mr1OXKt263nkhKkgzYHsamIHW9JqzwnSBW7lvtSL8sSum83fsaIU227OiB?=
 =?us-ascii?Q?E4wU8SUSjFSVRQxUrwB3eRiP0Nzhhcw0YLVS1W0ENBsxaDx2ilRVUesGJ8/4?=
 =?us-ascii?Q?qOLjpweXDZIbbP0BKqaDdZ3/oh71wswgDrKXtE23WRDRUuJCfFh3pDS7tsjT?=
 =?us-ascii?Q?8/BOUZ9BQzUBZ8CxJPl5sAoNkyZDHjBFaGuRSIZPmtvuuuGQLNKdI0hxFVwU?=
 =?us-ascii?Q?kA0TdTarZMMicC9hZGTW66LFGtUL8eFKT88XWalVnT7kxITKPV0C/7FAdVjM?=
 =?us-ascii?Q?xswh+c2TdYRJnx2+fyzPLg5YljaT/udBb61h9uVjPUDCSz5k2V20XBuh4RE6?=
 =?us-ascii?Q?q5D32su9xKNyb4t07nJIhd+3wMw2ZCPoBLkfP0K59Gdh8Shua3lXsrJTVu5O?=
 =?us-ascii?Q?E2O58fIKv34hCr4xjn/u9pM97BuYeczYwvtzXWs9+ELS7ol/Uvrgs2eN7L3K?=
 =?us-ascii?Q?lSFQKAbixStTS6YhWEp7h9iITsv2SbgxPG/5FqMT/zU4KnmiU4Wvx6iTJNPY?=
 =?us-ascii?Q?GJaWeLjJxgcz+jFqGGIDJS104fOCLYDTMCPIvAKnLEMAJQzUE/z5at9URbbH?=
 =?us-ascii?Q?EzPnP2Eg5QHEFQOsAzskMrrBIoT2wN8iV+NJJZjl+xXuGCCVEtEmAAfLLcke?=
 =?us-ascii?Q?+RN7i8ccDpcu+n/4J9QnmNvIXjI5bHHYwpisiuvXCrGpFYql4JkrPMlPnW6w?=
 =?us-ascii?Q?i+uuwDoxZM7JU8CpkPpu/7G1cISIgsPfdF9gFHQppd+IlCHL7DaANmNR1Jru?=
 =?us-ascii?Q?+R90h9itbC42echjppiLzdAQiHPjULjqFcWM2BtH7isnhJL9TXVPhRLSBR67?=
 =?us-ascii?Q?q/YlqRg3IyC2GGZxLYnwL0/JR7QS3h0JxGLbGBFZ+LY8gosGtWVy7aBxQkt4?=
 =?us-ascii?Q?cSbR+YaeIsRuAb3oU7YXVgFzkXdOFeIUWP1d8lBl0zWQhYzB0c8jGtgF/CTe?=
 =?us-ascii?Q?PFR5XPeTNuRjCUcb/78D68Mz+Oa3Wia7kab3J1mbaHSEbhbv8/wIZPfGX6dz?=
 =?us-ascii?Q?xDwO1tYdg0szphzvaMAZvQ8x4vZ9an44A/LpQsdi0FY9spXlhiyUOVbbVVkS?=
 =?us-ascii?Q?MFi5kZahOP24cVvr888UOGPixP/p13A44wOvRPH9g3aCTBV9Vs65Bhq2YNzZ?=
 =?us-ascii?Q?DcoYCyeF0tLdi2yMcnx+viMT8ObsBIyv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+ulWhDlEwbITlISOXreuXGyvNnDPYoHUEQd8N8zYYp9Lrzqr65NVX3fROgwB?=
 =?us-ascii?Q?BDaJv4VqJ808vd/hel0NO58OrahwMrKrvUZEb7aKOT1QFwqor5JNRYpcHJ6t?=
 =?us-ascii?Q?AV0GQwfBkwISdSrRDjeXDJGWa/YxWi0f92MicnwajBZvkdKm172Ro7HLnwFa?=
 =?us-ascii?Q?M14rcu3yYXR6a5ArUYoaBe45iw0Q/0d7STfrEYUsw2mhYEuQ5+yMhJP1JZwy?=
 =?us-ascii?Q?iWreGOaq2sAL9UUNwIiy+6Ml4sLWRfNtzYTjgzbrD1hepgEhF3BVQ/ZAFa89?=
 =?us-ascii?Q?7Qz3TdXjSdzmz2oICSzXDtMhCTo0sWkz2ssSkH9C+4NpQkj2ZQm6cow4YNHG?=
 =?us-ascii?Q?xCd7RG2ciWMxAJSWq4Cfj7aebcsuM3LcvCKqTavFP1++vSHZ7Yx+txokiLEn?=
 =?us-ascii?Q?PRwkyN3ArDiHYFEAiG2Scnmd12ULYMYeHsCIwwqO7ZW25gAKsdzri6FdHxPO?=
 =?us-ascii?Q?aVf6Py72LS0NMUhx2hg8uqZXEkhg4ZUpgPIp79wzd/urQ/vo/gGttHrQJIXS?=
 =?us-ascii?Q?zvCQAUF5CznKJZwmrYJiEQ1vwnAtYZDs4RsTCbGzWokcOr1LQuIS2wvxVm9Q?=
 =?us-ascii?Q?n6wNz40Bga47AkFReEdHJDqgOhuKmstUxIlnaMPXr4aWF2WBvERE9wnCLQ2d?=
 =?us-ascii?Q?LVYjKglJ7zieyg6wd6d+nYp4dWOzhrZ7G7nuvt9wvpNAXjregcqkl2kZsE3L?=
 =?us-ascii?Q?gHFIuX2z0NOx5tDCfD7AfAdpo3XsOkdCOTAVugKwJHbWioiqrXpNXJkvffgT?=
 =?us-ascii?Q?imejGdXCu4WODrPD7bwMz2xXd9459FcQmzhxECiXoIKRFhTp6UGT97UA+13V?=
 =?us-ascii?Q?2OxRLErducnUEyJTgBWENyr8zdGREoQcIAxZgC+QX22UBfBTHvniVkJpXQla?=
 =?us-ascii?Q?2ZumGN1u+ZNRbc2IpO+n3DNteFO7FiatYWZwLvYJLAkhwzjE9YiztNfne7/m?=
 =?us-ascii?Q?y3r4IavbmxPuyHOSvAYkajY425E95xZ+TicqyXk3KEUCAxD0THBov0KMLxIP?=
 =?us-ascii?Q?Tacu2oQiUpckSJIPjTQrEIc3sTUb6gGtyRatAfo76zFCp58W264ltWm9j3hY?=
 =?us-ascii?Q?jcSaV2LT3bfIH/ZtPA1bq3YM0oXM7aXFa12ZiV+XZwZpT04K/kmPDoqbnawC?=
 =?us-ascii?Q?ddjVNxYT7cY+8m6PmmheuaQ3yucfs4OQxaZxmkNJCs5Pl598eE9ga+gcE80u?=
 =?us-ascii?Q?3YTmlL5dsLfljcCxt5zKl1GozdcXQ1frlC7QNZ6S3LfkZFPYeRgrLwv1wH6F?=
 =?us-ascii?Q?+TQZOQPVstFuJzhBqlw885zDhD4hYGAIXQV9y20s4V/d94i0rCYNKzUiMOlS?=
 =?us-ascii?Q?RWeTFoPngesi7WucS9xjnPaoidRpaQy5Ysf5QJoo8SgbjQb1mT5+o7Hcybu7?=
 =?us-ascii?Q?E8XWEjrnC9Cw2cOSVt2lEnweU7cangcDFu7HM205t3iWCaEgNFOkboU9gGpv?=
 =?us-ascii?Q?oO/BmZR8kNFAqHVL6nn3KbkDbk+p0oNru+nfrB3UiZ51i53O8sO+UMAa8VGh?=
 =?us-ascii?Q?2L0dtGN/WhPgfuT7Q0/twBZjGC64Mri9MNIItzmRXQgRaL8n4ccBA6BeDMX1?=
 =?us-ascii?Q?J5mR7cY+BI7MqkDhXTQw0+1q/z2Bi6we9/KL9yMv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe638e3-dc55-4aec-8a54-08de0fe51233
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:29:27.3891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PECpX9WTVRiG2LFS4ZVh8Hgl4eseTKF7mQZPw2Q4Sb7OPMA5VrMFScDDxrYgMl7s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6097
X-Rspamd-Server: rspam05
X-Stat-Signature: xqd8dq13c9kngbpuuh8nd5zceyg4ning
X-Rspam-User: 
X-Rspamd-Queue-Id: C9A5EA000A
X-HE-Tag: 1760970573-850152
X-HE-Meta: U2FsdGVkX18gvZ6v0Q7mrA95J4YEssibOCnfqu29vkpgU3hD/fGgW5S91j13TDIoO1F7L72bqMBOxrteSy0a+DkWxzchb+60Q/jQJlh8dlnu3Nal/F7PIAq6yLwIIL4HXooVc2+LAsXsCMGSTa5ntTOtP383lRr83XMZsJHf0fwj3Hu1j3OHOJFOEhkua5M35aQsz1ruHoqgbA93pkWFccTxfuGEtS1Vq6xcvFw8iAMJ0eVdLprZdXN+R7ODTnMvGjfXEvcYmoQFlQN3BlLduqPawNPF4PZoGxu8ZugVofhc8YOz1IVKFR/+OqHhGr7bbkEheUDczH5Su6gDRFQ5gWOyARnsd5XTKMCQxjZm1hVQoF6PQ69vN+2408DLyDd/vdHAFdWzxpdpqNzXW0P1NWJ0eqEwXesaobwajuMcjoTyd5oimm61/X6xkW40UZwnKYB2+iSqwFt080V+8S8d5LhzWuMZsXvdLG2tnoNEpGvRrAO34BzGhqmiszl8lwirgNDy4utvyVkqHMDH47PMZGHN7C28yJJzSGPBzKpvxH4EB7E9sz4Cd5SyzMP0lJi5V2wMTp4MkxE3nwvXauhIGyOxeDOAOP4y3wDmkRcVafkztmqtV05LiRu01USOhypRuRs1L4TdMJK7CZSL0ocorRi2KO3rU/CkCitWKYueyFxY1+Moy7yh9aGMSX9HqBqUjNcrSJYJrWiMkcp8mcDJCJILkEAQoSFjAyz5zdvgrUYi1NYzc/qMl67B02qSt3M34DyJCkC81D6y3n0mvilq8vQ7pfAA7e6mIyPJkPz8zrbxgOWSZfoOxR3Qz0bzlOC13pLJ4MSgX3q3g78MMkh2L7PRJMsXLg/1iTtcId/LVfOLLA/wRhrW9fxJp+oFaYIqSsgCZ+c16AwzL//WRPMZVaTmkeR+qXrqhHMT9ETdswqoDBCzkTdkJ2k2qSeoQNCWoE+jc3KZ0KDeBcJXIS4
 yZTqc0Tf
 HNZeNGWRsn3iS4kjRePzmVUNu9iJa+WLwsheOCQLZuDzXR4hguYUIxEx24+PMWAZcJjUMwpfqGd3m+wf29ak86H9uOwI9Ru+g3iEH9YN3yLCphJW+kTm2RXiIi/LSPB7p1PGf15upCW/MsQ3XcazPu5J0P6UGohGgoD3Uyi+UbQ5XmAjSXzM/7yVTZKNqDJvW2DUcMZnjTZl6J1U6/qrckYpUin43uU5wRLOdX2nZF0i1miWs00EvVbspfG4PnuZY/m9iJkIu9hcUGvjWjJiG6Lro8SiZLreRId3wkDUC+f3FxWJjtwCG8Xzjt+bT36oxofTa2/xjNGPOffoSm/nuj+vZwt1BWM6dXBdJVFzeqDbzj+ePwRFpKQEG7cOpjVpexvbgA2OrwUiq04ESkEYP5gRAo73z0YWLqVHbStdlEbtVylbLatrLz1gR9rGAqdHSw+QZ597NBsm4TGiudc65XqCghGk5l372c96j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 03:29:59PM +0200, Pratyush Yadav wrote:
> > 1) Use a vmalloc and store a list of the PFNs in the pool. Pool becomes
> >    frozen, can't add/remove PFNs.
> 
> Doesn't that circumvent LUO's state machine? The idea with the state
> machine was to have clear points in time when the system goes into the
> "limited capacity"/"frozen" state, which is the LIVEUPDATE_PREPARE
> event. 

I wouldn't get too invested in the FSM, it is there but it doesn't
mean every luo client has to be focused on it.

> With what you propose, the first FD being preserved implicitly
> triggers the prepare event. Same thing for unprepare/cancel operations.

Yes, this is easy to write and simple to manage.

> I am wondering if it is better to do it the other way round: prepare all
> files first, and then prepare the hugetlb subsystem at
> LIVEUPDATE_PREPARE event. At that point it already knows which pages to
> mark preserved so the serialization can be done in one go.

I think this would be slower and more complex?

> > 2) Require the users of hugetlb memory, like memfd, to
> >    preserve/restore the folios they are using (using their hugetlb order)
> > 3) Just before kexec run over the PFN list and mark a bit if the folio
> >    was preserved by KHO or not. Make sure everything gets KHO
> >    preserved.
> 
> "just before kexec" would need a callback from LUO. I suppose a
> subsystem is the place for that callback. I wrote my email under the
> (wrong) impression that we were replacing subsystems.

The file descriptors path should have luo client ops that have all
the required callbacks. This is probably an existing op.

> That makes me wonder: how is the subsystem-level callback supposed to
> access the global data? I suppose it can use the liveupdate_file_handler
> directly, but it is kind of strange since technically the subsystem and
> file handler are two different entities.

If we need such things we would need a way to link these together, but
I'm wonder if we really don't..

> Also as Pasha mentioned, 1G pages for guest_memfd will use hugetlb, and
> I'm not sure how that would map with this shared global data. memfd and
> guest_memfd will likely have different liveupdate_file_handler but would
> share data from the same subsystem. Maybe that's a problem to solve for
> later...

On preserve memfd should call into hugetlb to activate it as a hugetlb
page provider and preserve it too.

Jason

