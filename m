Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03C7C61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A127A6B0088; Wed, 26 Aug 2026 04:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2D16B008C; Wed, 26 Aug 2026 04:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1546B0095; Wed, 26 Aug 2026 04:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6212E6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:55:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A83161C0C87
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:55:14 +0000 (UTC)
X-FDA: 85142811348.08.6CFF297
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012066.outbound.protection.outlook.com [40.107.209.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9BFA9140005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:55:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AytmZtTR;
	spf=pass (imf09.hostedemail.com: domain of icheng@nvidia.com designates 40.107.209.66 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787734512;
	b=I1zwN6jBCzu/+DzeQnywn7nugR6F2+DxzCGddd22F4198PJSZEl9YxWXTG5NVDDDI6T8/E
	7B1HBcAFDlHDEqcDLI2l5gtfz+Vev4tAEs45JUpn2FEaqoqJkrkMzddE/CtR4rAXH0rwBd
	9kF/jWGKTJea7CrxFPP3DoqoN1KWGXw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AytmZtTR;
	spf=pass (imf09.hostedemail.com: domain of icheng@nvidia.com designates 40.107.209.66 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787734512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/PcoQM+000j5ZL5xZbKXtOzXBL13caCL1lIvDlyxNQ=;
	b=BdN4gbjZy91SebxnzDG1Rs5nv/yh9Inr5gLP+9bypY7LJq6tFDy/z6qXaPZkfv94cCLsEJ
	fVyE+zdQ/MvXmtT/eX0j0u03FP8k7FdLnAvSKNc7+yrYHY/QkaJ9c93DLSb7mCz+CBspBn
	S3MkbSgKYxzJqYJV6XfFoD5+NY+W/t0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EiYREHiHdOZJhpSzmw+tXo3vvv3VMlSkj9wIvB2lyYH7Cf6N7/zb3NCoH6MhEoiNl3bUA4oibZae29dylYhKPY8roKZMp4mxJ7FKl4yyJP8c4v3OA7ovanI/lq/Mwycm8lwfZUL2A0QfbPZxsYpCsZl/zMpRURr2QEK+ljyMTjo2uuaa4JpBGM+E0LdfU50vbR2t5LD/xjF0FWLZEzHq6u0XZSudmJj0QuZS0YrltUmfigZgJtw6ns6X3f34x3QPcCbeqPVBhOF+EJKW8kOT2VbsDCNFxqfL9BkIDxxpxA7eluXb2z5R6WOdMNGq7DcYkg11U5ppP/6dNJrZXo6KtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/PcoQM+000j5ZL5xZbKXtOzXBL13caCL1lIvDlyxNQ=;
 b=SXKhEYY4hejNYWr+wSQH57YCrgqjSt4m5/XS0yPVkOP1oaqkJSqCpMNQY11rEbv2/RdFFS9iwYj6FctIk5O6ye3yURhtQ8ont+ZV3CJZoHrXfE6cXvhBccoB1OzWpjvi0LlP67baOwtUesOFtr2lW4kdQrhj4/bpVYp75VU0yePcMIEkSYuNdSAtN2j2eQBUtvSyQLUzcn2Aw+7h7P+oFzrLA87LQpk47l2bgtHGrEw5zs+5N3f3L+Ahm78Qr8PGqoC8Co7ZCL/1nsL+Wb2dxfe3PGszQkwfBAPoB6diHq05jFH23C2kuzqP/t8IUqaDj9a1PY3tBaAHHmvsnMJ+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/PcoQM+000j5ZL5xZbKXtOzXBL13caCL1lIvDlyxNQ=;
 b=AytmZtTRUIQKiiMRGud6DA/360BZ+/G+8mg4m+rj46xhN19Fp8GgI34PFaXmCeDMDyMqDOZWhL5ncaLX65+FN4/95R0iTJK8A5Uaobp1uqyKFq2oJPivhmb7uPPjhW2C6yBBcvTg1bq5tV69KwF5Rvh8arTHx4mGtqY7NC2NJk0XVDsaxCWq/xNOAdp7cpSL5ibbsB2MZzJFuZTCUJ/nGu3TyYIelKs8py6kB+78pCZK3dtI3dqfRHPvxLq4dsOAfkRGd5nlUy/ovi3C4RZqC0IBdORj5g98d18YiRXU5ez5jmYs7kE5cdaIx6i2Pz2cRqOPF34HNBVRF9wGyHq2Gw==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by CH2PR12MB4039.namprd12.prod.outlook.com (2603:10b6:610:a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 08:55:04 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0360.005; Wed, 26 Aug 2026
 08:55:03 +0000
Date: Wed, 26 Aug 2026 16:54:56 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Cc: linux-cxl@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
	Oliver O'Halloran <oohall@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 11/13] PCI/DPC: Unbind regions for DPC recovery
Message-ID: <ao6oQo8Lo5oy5pIL@MWDK4CY14F>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
 <20260825022628.3651434-12-fabio.m.de.francesco@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825022628.3651434-12-fabio.m.de.francesco@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0027.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::14)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|CH2PR12MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b08072-49db-43bf-60ac-08df034fb7f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|6133799003|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OKeX0gY4WjtQXQ4xI7OkPVUrAZSgfhNObKIQapdVQTgWvhdOQhHLzg4DfHpndU/lONs7brWScCCK1ub2bO2mJM0Kr5RlxCp4CeXI78WkraGdYbSKZk60M0H6VeGxdHxXZFWQAhFMkNKmim5DhF7g1kUIujCFaDb4hwb9n+m4EUSK+s9DTkql/pTlmKbx08jdf0tsEqaAZAmxoor3ns8TRu8VGEUUJx3Ippr1uNwCGCM8uuQSF36uCs0B+Pc8kCS6SIfLFaFeiEavqz22ZTrt71/aUD4DxSEAN+0cS/V3QicvGjIZKwBaEqhmGJUZz48Ufkg+zNF/NU2M83c35o97qw8aaM/esmYsQgNsTTy6T81Y+uZwbEEteGGdgePliF1E5I9AIG3r/0eISQxFZItIUFB28tpW9Hr2RZ0Lb7oaBBdf2rg50cbVaoKuPY8+BSVFGC+RjaGuUwV5i6/rynxF49oE8KHWjl9NcGFrtilYrSNejozwho3SgZI5EyDHat8VAvS2DDe3A4RMJhbjD61F3U6fqWNrL9skdfMgjP5de2gXj1I0aSYFz8XuuY9tYKJ+5Bc5zrDURKtAESCt162lQp/J4mShACxUVIzISCPIQ3Yh2IBNamm3D+ucHIozxXRWflib6x/zUV+8KT1OluvCIgURs71BcJQIAIMrsqp+LB8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(6133799003)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nRyLxjSGtnTXfvxSLj9Ij8gxSnjUTKzn01X3qZBmcImE5pL8er+v8H7OF7gV?=
 =?us-ascii?Q?4j/zAKKVTzgVD9lgAUkmsTHFkg6aywYqPaOdqJFij7/tWpRy2TlQ5WMMp92n?=
 =?us-ascii?Q?XP5KXDyOaeXuc3pKRIYlW1BmaqauuNtp74u30M9UQ0tVATVqvUSM/K9e8fz6?=
 =?us-ascii?Q?X2P8jEF8CJn6STWnscUnK8jhi+KRCK9kGlRzyp+9iexikpDHTWRqyg6Hnxbc?=
 =?us-ascii?Q?1Q1Hu6DmcsKaNPpl9Ax7AxPt0/WkjQ3Jd02C4l9ecRSHcTBCqVU1coC+IaKM?=
 =?us-ascii?Q?CL3tcwiD5m0uFLJ/fhLDKlEEnDwWr3yBnyzPbcAP+3aoY8JsBBJz6Lc9Tnlb?=
 =?us-ascii?Q?2uZt2BwH1YTBqsU6zHzOH5ITz18GiCox2lDKifoCJA38zcsvOtO1D+FmJyFH?=
 =?us-ascii?Q?ap9p7TaE3f3XX6l82P6vu/8YILzEV2EpOcT+hZx4mPz4q76BpTwUKthqTOjF?=
 =?us-ascii?Q?FFlKHQOzis2uGap6Ob3QrywUHLS71z1+D1N4Whf/GlUDtoz/y0fqzmSPPv3j?=
 =?us-ascii?Q?RcDnxoSsi0hE+zBaPxd6bfNNK4/0uMWjHNdZBe8fiVRV1EhaM5pkuOHB+v2x?=
 =?us-ascii?Q?+dK3JiEBleVKi42svErxS68KS69fbmulWmwLFKtG++pNTBBbIliOn/VxjzPh?=
 =?us-ascii?Q?Z9pBcrXva3JriV0d6ZztRz7mlB/fUIs6DnkLDjFYJBHe5LhAItQZtyuo7y1L?=
 =?us-ascii?Q?O5R9rqRuutB1du5EkxkeqCUhzqBOP9+CpRU6i1tZTwDPqoc+ej/Atbvf6UhC?=
 =?us-ascii?Q?hrnBgNNjhlSnSn4yrQlue7uQGXIzyxhXbHrWXzVMrucVT0xcYlVzaTj5rJEW?=
 =?us-ascii?Q?5brbuXL/DWX+oyacEyLN6mSmIuotuK1xzUtzMm1PL1H1z9WGMD9dwNosh0To?=
 =?us-ascii?Q?PX94xMQhnZiVF7fSIDc+iIZoupNo86tijCWSc+l7yjNpmAtmpquF2b8cOkye?=
 =?us-ascii?Q?XsIFsfKIs9tRbPuNWaC4U24zNN5DnHIPanr17SBBx2Pw2y31AWsVaPUexR6s?=
 =?us-ascii?Q?iFSwEI3sBj3f1UmfiDuXzzMklBYgtshHFRDwVG2O1o7D681jaKmBfFvPL6Gy?=
 =?us-ascii?Q?zHpKLfTazk5K5UdC6FsUkCGCHSWTxNFcsZANE7yZp3g6meyAqD1AQGnvUU5M?=
 =?us-ascii?Q?aA6VYMsBKLqM6VThxMMemxrwfO2xy3oJIUMMNTCk5FMowKgJ1IRkCZWgRgof?=
 =?us-ascii?Q?0rym707d1GxC1wbj+M97ty6kF7QOhWDmp9V2OtPCilrQ2thuSoGmA9381Trv?=
 =?us-ascii?Q?IRBiGvRvC+gz7/Q0J7N2xGUHrWM4EfMMYU+ZOdz8CpRj9yym1PAk2C7dmIQ6?=
 =?us-ascii?Q?6cX5geZOjVWxqpZd5ctIp8wLMvYyoQtLNwAqjOup4hX9Qe7kEbgDXrvpNGum?=
 =?us-ascii?Q?k0k0mAelJ8T5BZIGkbKuPIipHSYiNViMytrWxCbvHmu+EQjrMDxxX+kGXk72?=
 =?us-ascii?Q?4NENTSywyiGJxhPXlWYS5s6X/G2I3rTlfN1DyxMJMvDdP4yvfzFJUTVNk3c4?=
 =?us-ascii?Q?IopZj4kntrHM3ehOBdnTGjnVSnxmyGSVD11nVdFGzeKFUmFC9eQ4g5WXDkfq?=
 =?us-ascii?Q?UmP47jiQ+SrO4O83KeTuBZFSYb9uaNWaAAEXJSRn4l7hDq31saPJmF5RqPHw?=
 =?us-ascii?Q?F3J2is1gNfhEYgC5B7zUab737LDmbFaEg3+12AvsxJgBvogrCHbdQIcAiAVM?=
 =?us-ascii?Q?CtLn4oJMXN+bS9Rz4FuS9VmMXcSbNNn9eM3zQMxerQWFb0C02GlIXSJ45mWA?=
 =?us-ascii?Q?CIH+J4L77Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b08072-49db-43bf-60ac-08df034fb7f4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 08:55:03.6168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjqcfCDj15f0Lf7Po6p+zalwYV9BjjedT6eG2cTTvn64Bb+qnWpQvAbrKHN8A9SrKPRpFCcm3XMOqr/vvaw9YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4039
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BFA9140005
X-Stat-Signature: f6ch4oqrxaeig8q7oj1cg6d9f13nxmqm
X-HE-Tag: 1787734511-683011
X-HE-Meta: U2FsdGVkX1+zEtXqnO5C9XdcG0Z8gli2XCm16uP0wpdApXtAW2UonKhQnu7sdX8KPekiGjWaIBGAqj3DSNdApwB+Yx2o43ILlxR/wbJ9zObST2f92Zh6TexfMcFVmMV19OSQYpHncdK/PRK7iAiyu2O/aNx+pm2xUNLfWxmg1zWN9ZZ2j+NSTcoqxk8DxYfDx93Q4TFvSbl94N+UtIX5v67LNPloE2Zu7t1PlEZ34wuD1NiMS2LQ9G4AXnvl1Klod1pOTsbBMJ470v3hfdWEgZn07CfDr+Z1Koybtk5pzXmDXNoyj83JWTqnTp3Jxv84dpx75Q6T8hBOY84YKjixRpIEe/bElYU4u2nJW9WlYglk6GarivUhUR+08hJ8Efzf1SOVZS4FWl5UD+cqh8k5wjD8wYAs6Du7BlluFg5rPUclVMJlWlmUUprQEA1BgAY8PpUY49JvAhM5mYZFtsyf9qhoUNU54Ksjvi4Tmw1AKJBqrSfaPnwX9ThnGpS0RGmxdsfKIyYL+dUZ/cz06s89CvMORwVlpKiSm9wRQql5CgB5pYVXVgefI53mAuagbcbZgh0hzdRWNypvB5rz1Jz2xTfzOVNGC0i7w3CCs9gfvcCsSVxo5mmYZgITkmMVa11Yp/FAPC4h8LCZB4Tm8MiYVkDaM1aLv42mhjQqUSYN8AdYBT+/pTQqLZ5MX4DlYzNTfP0Z0n0anK3BwXUXmIOlBXsruYHQXmWcCNU6EkYVdfh9xTnmJSkrQiqZdDV1gpxUwzJ4C33jRtQ4IiKo96o41hmf1/3ybGejswM7KI1/W/haQyBtWFzO4pDEBRk+5GcLqm85nVxD/Qgy2BTWbJ970gzJwpBDQ2NRz4GKc/8uVyEwhL8bpQyTSm4AJcYwlE94HTee+XITl0VGAeMm6udTAl1SI4Y0t2jcst4/P1itgimVPzK1zBFlMjnRz4upPJwFzwtF66ZvVgoMgaNPobS
 57FGzXpq
 SZWqaNvo0bNCaliXdIHa6USq1O8Toe3VA/wU7RxtJdHf5lkmkhsHH3aWdjcD7tgru6Q1CN7xzzdXbAyB0+lQtZtE60fgDJUMme5eMJt5HIEmtRfRwo16NEFQ5MWI9EFbalwoTUWAO9JFys6j4Yhip9E2A3qOX0bRgnPdfKAib59gydy2N33WgvSChKgfTR1Wqyj/pNphp+bkC7fGNXdIU5m7NfqL1G4HyZG5eVwjLMqU9ttru06ot++QLzSe9Hko+dxo5vn72Icm+fwnJxIIZ3iH22A0ZQswu1Q2VVWzjb6Xi7pB2MwUvA3+Mj/hb902n2qt4dT8gNk0sJWdEUEMUGFz8Lbn0bxsNKjaQEa82oGqflf8uI4GHPohwZ9jGT7emk/JZuCmzREdNP/7+O3j8WTU2tYofd/g9qi5xUI14RguZqO8SVlpTVFVURg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:26:26AM +0800, Fabio M. De Francesco wrote:
> CXL r4.0 sec 8.1.5.1 lists Downstream Port Containment among the
> conditions that reset the Downstream Component's bus number. DPC
> recovery needs to wait for the link to come back up, but if Access
> Control Services Source Validation bit is enables PM Initialization will
> fail to complete. 
> 
> Have dpc_reset_link() reset the secondary bus of a CXL Downstream Port.
> Split pci_bridge_secondary_bus_reset() so the reset takes an action
> saying what to do with the CXL regions routed through the Port, and pass
> the action that unbinds them without offlining their memory. Offlining
> migrates the memory that the memdev back and on a contained link are not
> addressable.  Don't release the memdev driver in cxl_error_detected(). 
>

Hi Fabio,

Do we have any mechanism to prevent CPU or DMA devices from accessing the System RAM
while the link and HDM decoder are unavailable ?

Unbinding the region only tops region managment, it doesn't stop CPU or DMA memory traffic
that's still online.

Unbinding also removes DAX/kmem device while its memory is online.
dev_dax_kmem_remove() can't remove that memory in this state and will leave the resource reserved
until reboot, so the region may not rebind afterward.

Also while DPC link is down, cxl_sbr_save_hdm-state() can't safely read downstream HDM register
through MMIO, I am not sure whether it's correct to save HDM state here.

Best regards,
Richard Cheng.
 
> Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
> ---
>  drivers/cxl/core/dport_sbr.c | 57 ++++++++++++++++++++++++++++++++-
>  drivers/cxl/core/ras.c       | 10 ++++++
>  drivers/pci/pci.c            | 62 ++++++++++++++++++++++++++----------
>  drivers/pci/pci.h            | 15 +++++++++
>  drivers/pci/pcie/dpc.c       | 46 +++++++++++++++++++++++++-
>  include/linux/aer.h          |  9 ++++++
>  include/linux/pci.h          |  3 ++
>  7 files changed, 183 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
> index 2b6f840e22a7..823b63012f45 100644
> --- a/drivers/cxl/core/dport_sbr.c
> +++ b/drivers/cxl/core/dport_sbr.c
> @@ -9,6 +9,30 @@
>  #include <cxl.h>
>  #include "core.h"
>  
> +/*
> + * cxl_region_unbind - take a region out of service ahead of a reset
> + * @cxlr: region routed through the CXL Downstream Port being reset
> + *
> + * Unbind the region driver, which tears down everything built on the region:
> + * the dax region device, its dax device and the driver bound to it. An SBR
> + * zeroes the downstream bus number, so a region left bound would decode to a
> + * device in reset.
> + *
> + * The memory the region hosts is left as it is. A caller that reaches a live
> + * device offlines it first; see cxl_region_disable().
> + *
> + * Context: process context. Driver unbind sleeps, so this cannot run in atomic
> + * context.
> + */
> +static void cxl_region_unbind(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +
> +	device_release_driver(&cxlr->dev);
> +	dev_dbg(&cxlr->dev, "%s: region unbound before reset, HPA %pr\n",
> +		__func__, p->res);
> +}
> +
>  /*
>   * cxl_region_disable - make a region inactive ahead of a Secondary Bus Reset
>   * @cxlr: region routed through the CXL Downstream Port being reset
> @@ -58,7 +82,7 @@ static int cxl_region_disable(struct cxl_region *cxlr)
>  		return rc;
>  	}
>  
> -	device_release_driver(&cxlr->dev);
> +	cxl_region_unbind(cxlr);
>  	dev_dbg(&cxlr->dev, "%s: System RAM offline, region disabled before reset, HPA %pr\n",
>  		__func__, p->res);
>  
> @@ -284,6 +308,36 @@ static int cxl_sbr_disable_regions(struct pci_dev *dport_pci)
>  	return rc;
>  }
>  
> +/*
> + * Unbind the regions routed through the Downstream Port being reset, leaving
> + * their memory online. Used on the DPC recovery path, where dpc_reset_link()
> + * clears DPC Trigger Status and enters the reset without waiting for the link,
> + * so the device may still be unreachable and the page migration that an offline
> + * performs would have no device to read from.
> + *
> + * Unbinding cannot fail, so unlike cxl_sbr_disable_regions() this never aborts
> + * the reset. The memory stays online across the reset with no region decoding
> + * it; cxl_sbr_enable_regions() reprograms the decoders on the way out.
> + */
> +static void cxl_sbr_unbind_regions(struct pci_dev *dport_pci)
> +{
> +	struct cxl_region *cxlr;
> +	struct xarray regions;
> +	unsigned long index;
> +
> +	if (cxl_sbr_save_hdm_state(dport_pci))
> +		pci_warn(dport_pci, "HDM state not saved, decode will not be restored\n");
> +
> +	xa_init(&regions);
> +
> +	cxl_sbr_collect_regions(dport_pci, &regions);
> +
> +	xa_for_each(&regions, index, cxlr)
> +		cxl_region_unbind(cxlr);
> +
> +	cxl_sbr_put_regions(&regions);
> +}
> +
>  /*
>   * Re-enable the regions disabled by cxl_sbr_disable_regions(). Restore the HDM
>   * decode first: a region cannot serve memory through decoders that are not
> @@ -315,5 +369,6 @@ static void cxl_sbr_enable_regions(struct pci_dev *dport_pci)
>  
>  const struct pci_cxl_sbr_region_ops cxl_sbr_region_ops = {
>  	.disable_regions = cxl_sbr_disable_regions,
> +	.unbind_regions = cxl_sbr_unbind_regions,
>  	.enable_regions = cxl_sbr_enable_regions,
>  };
> diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
> index 99fb00949c2f..568a906f3b50 100644
> --- a/drivers/cxl/core/ras.c
> +++ b/drivers/cxl/core/ras.c
> @@ -323,6 +323,16 @@ pci_ers_result_t cxl_error_detected(struct pci_dev *pdev,
>  		}
>  		return PCI_ERS_RESULT_CAN_RECOVER;
>  	case pci_channel_io_frozen:
> +		/*
> +		 * A Port on the path in DPC means dpc_reset_link() is about to
> +		 * reset the link, and that path takes the CXL regions out of
> +		 * service and restores the HDM decode itself. Keep the memdev
> +		 * driver bound so the endpoint and its decoders are still there
> +		 * to restore.
> +		 */
> +		if (pci_dpc_containment_active(pdev))
> +			return PCI_ERS_RESULT_NEED_RESET;
> +
>  		dev_warn(&pdev->dev,
>  			 "%s: frozen state error detected, disable CXL.mem\n",
>  			 dev_name(dev));
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index f3781d1e8f6e..eedd516f8484 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4864,24 +4864,37 @@ struct cxl_sbr_ctx {
>  	u16 command;
>  };
>  
> -static bool is_cxl_dport(struct pci_dev *dev)
> +bool is_cxl_dport(struct pci_dev *dev)
>  {
>  	return pcie_is_cxl(dev) && pcie_downstream_port(dev);
>  }
>  
> -static u16 cxl_port_dvsec(struct pci_dev *dev)
> +u16 cxl_port_dvsec(struct pci_dev *dev)
>  {
>  	return pci_find_dvsec_capability(dev, PCI_VENDOR_ID_CXL,
>  					 PCI_DVSEC_CXL_PORT);
>  }
>  
>  static int cxl_sbr_prepare(struct pci_dev *bridge, u16 dvsec,
> -			   struct cxl_sbr_ctx *ctx)
> +			   struct cxl_sbr_ctx *ctx,
> +			   enum cxl_sbr_region_action action)
>  {
>  	int rc;
>  
> -	/* Abort before touching hardware if the regions cannot be disabled. */
> -	if (cxl_sbr_region_ops) {
> +	/*
> +	 * CXL_SBR_UNBIND: the link is already down, so offlining the regions'
> +	 * memory would take the reads that page migration performs as a machine
> +	 * check. Per PCIe r7.0 sec 2.9.3 the Port answers a Non-Posted Request
> +	 * with an Unsupported Request or Completer Abort completion while it is
> +	 * in DPC. Unbinding never fails, so the reset always goes ahead.
> +	 *
> +	 * CXL_SBR_OFFLINE_AND_UNBIND: the device is reachable, so offline the
> +	 * memory first and abort the reset before touching hardware if that
> +	 * fails.
> +	 */
> +	if (cxl_sbr_region_ops && action == CXL_SBR_UNBIND) {
> +		cxl_sbr_region_ops->unbind_regions(bridge);
> +	} else if (cxl_sbr_region_ops) {
>  		rc = cxl_sbr_region_ops->disable_regions(bridge);
>  		if (rc)
>  			return rc;
> @@ -5003,19 +5016,17 @@ static void cxl_sbr_complete(struct pci_dev *bridge, u16 dvsec,
>  		cxl_sbr_region_ops->enable_regions(bridge);
>  }
>  
> -/**
> - * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
> - * @dev: Bridge device
> - *
> - * Use the bridge control register to assert reset on the secondary bus.
> - * Devices on the secondary bus are left in power-on state.
> +/*
> + * __pci_bridge_secondary_bus_reset - assert Secondary Bus Reset on a bridge
> + * @dev: bridge device
> + * @action: what to do with the CXL regions reached through @dev
>   *
> - * When @dev is a CXL Downstream Port, clear ACS Source Validation and Bus
> - * Master Enable across the reset, per the workaround in CXL r4.0 sec 8.1.5.1,
> - * so that Port Power Management Initialization completes at link-up. The
> - * bits stay cleared until the secondary bus is back, then are restored.
> + * See pci_bridge_secondary_bus_reset(). Pass CXL_SBR_UNBIND when the link is
> + * already down, which leaves the regions' memory online because offlining it
> + * needs a reachable device.
>   */
> -int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
> +int __pci_bridge_secondary_bus_reset(struct pci_dev *dev,
> +				     enum cxl_sbr_region_action action)
>  {
>  	struct cxl_sbr_ctx ctx = {};
>  	u16 dvsec = 0;
> @@ -5028,7 +5039,7 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
>  	if (is_cxl_dport(dev))
>  		dvsec = cxl_port_dvsec(dev);
>  	if (dvsec) {
> -		rc = cxl_sbr_prepare(dev, dvsec, &ctx);
> +		rc = cxl_sbr_prepare(dev, dvsec, &ctx, action);
>  		if (rc)
>  			return rc;
>  	}
> @@ -5042,6 +5053,23 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
>  
>  	return rc;
>  }
> +
> +/**
> + * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
> + * @dev: Bridge device
> + *
> + * Use the bridge control register to assert reset on the secondary bus.
> + * Devices on the secondary bus are left in power-on state.
> + *
> + * When @dev is a CXL Downstream Port, clear ACS Source Validation and Bus
> + * Master Enable across the reset, per the workaround in CXL r4.0 sec 8.1.5.1,
> + * so that Port Power Management Initialization completes at link-up. The
> + * bits stay cleared until the secondary bus is back, then are restored.
> + */
> +int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
> +{
> +	return __pci_bridge_secondary_bus_reset(dev, CXL_SBR_OFFLINE_AND_UNBIND);
> +}
>  EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
>  
>  static int pci_parent_bus_reset(struct pci_dev *dev, bool probe)
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 4469e1a77f3c..b6d873b077ed 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -233,6 +233,21 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vmai,
>  bool pci_reset_supported(struct pci_dev *dev);
>  void pci_init_reset_methods(struct pci_dev *dev);
>  int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
> +
> +/*
> + * What to do with the CXL regions reached through a Downstream Port before it
> + * is reset. Offlining their memory needs a reachable device, so a Port whose
> + * link is already down only unbinds and leaves the memory online.
> + */
> +enum cxl_sbr_region_action {
> +	CXL_SBR_OFFLINE_AND_UNBIND,
> +	CXL_SBR_UNBIND,
> +};
> +
> +int __pci_bridge_secondary_bus_reset(struct pci_dev *dev,
> +				     enum cxl_sbr_region_action action);
> +bool is_cxl_dport(struct pci_dev *dev);
> +u16 cxl_port_dvsec(struct pci_dev *dev);
>  int pci_bus_error_reset(struct pci_dev *dev);
>  int pci_try_reset_bridge(struct pci_dev *bridge);
>  
> diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
> index 2b779bd1d861..ad74086bf82c 100644
> --- a/drivers/pci/pcie/dpc.c
> +++ b/drivers/pci/pcie/dpc.c
> @@ -127,6 +127,44 @@ bool pci_dpc_recovered(struct pci_dev *pdev)
>  }
>  #endif /* CONFIG_HOTPLUG_PCI_PCIE */
>  
> +/**
> + * pci_dpc_containment_active - whether a Port above @pdev is contained by DPC
> + * @pdev: PCI device below the Port
> + *
> + * Per PCIe r7.0 sec 2.9.3 the Port's LTSSM stays in the Disabled state while
> + * DPC Trigger Status is set, and dpc_reset_link() clears that bit only after
> + * pcie_do_recovery() has broadcast error_detected. A ->error_detected()
> + * callback can therefore use this to tell a DPC containment from any other
> + * frozen-channel error, and to know that the link is about to be reset.
> + *
> + * The Port that triggered is on the path to @pdev, because the broadcast walks
> + * that Port's subordinate bus, so test every bridge above @pdev.
> + *
> + * Return: true if a Port on the path to @pdev has DPC Trigger Status set.
> + */
> +bool pci_dpc_containment_active(struct pci_dev *pdev)
> +{
> +	struct pci_dev *bridge;
> +
> +	for (bridge = pci_upstream_bridge(pdev); bridge;
> +	     bridge = pci_upstream_bridge(bridge)) {
> +		u16 status;
> +
> +		if (!bridge->dpc_cap)
> +			continue;
> +
> +		pci_read_config_word(bridge,
> +				     bridge->dpc_cap + PCI_EXP_DPC_STATUS,
> +				     &status);
> +		if (!PCI_POSSIBLE_ERROR(status) &&
> +		    (status & PCI_EXP_DPC_STATUS_TRIGGER))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(pci_dpc_containment_active);
> +
>  static int dpc_wait_rp_inactive(struct pci_dev *pdev)
>  {
>  	unsigned long timeout = jiffies + HZ;
> @@ -149,6 +187,7 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
>  {
>  	pci_ers_result_t ret;
>  	u16 cap;
> +	int rc;
>  
>  	set_bit(PCI_DPC_RECOVERING, &pdev->priv_flags);
>  
> @@ -174,7 +213,12 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
>  	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
>  			      PCI_EXP_DPC_STATUS_TRIGGER);
>  
> -	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC")) {
> +	if (is_cxl_dport(pdev) && cxl_port_dvsec(pdev))
> +		rc = __pci_bridge_secondary_bus_reset(pdev, CXL_SBR_UNBIND);
> +	else
> +		rc = pci_bridge_wait_for_secondary_bus(pdev, "DPC");
> +
> +	if (rc) {
>  		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
>  		ret = PCI_ERS_RESULT_DISCONNECT;
>  	} else {
> diff --git a/include/linux/aer.h b/include/linux/aer.h
> index df0f5c382286..7ac029f01c25 100644
> --- a/include/linux/aer.h
> +++ b/include/linux/aer.h
> @@ -66,6 +66,15 @@ static inline int pcie_aer_is_native(struct pci_dev *dev) { return 0; }
>  static inline void pci_aer_unmask_internal_errors(struct pci_dev *dev) { }
>  #endif
>  
> +#if defined(CONFIG_PCIE_DPC)
> +bool pci_dpc_containment_active(struct pci_dev *pdev);
> +#else
> +static inline bool pci_dpc_containment_active(struct pci_dev *pdev)
> +{
> +	return false;
> +}
> +#endif
> +
>  void pci_print_aer(struct pci_dev *dev, int aer_severity,
>  		    struct aer_capability_regs *aer);
>  int cper_severity_to_aer(int cper_severity);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2feb0e355305..0d9832ce6f3d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1609,10 +1609,13 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
>  /**
>   * struct pci_cxl_sbr_region_ops - CXL region callbacks for a bus reset
>   * @disable_regions: disable the regions below @dport, 0 or errno
> + * @unbind_regions: unbind the drivers of the regions below @dport, leaving
> + *		    their memory online, for a link already contained
>   * @enable_regions: re-enable the regions below @dport
>   */
>  struct pci_cxl_sbr_region_ops {
>  	int (*disable_regions)(struct pci_dev *dport);
> +	void (*unbind_regions)(struct pci_dev *dport);
>  	void (*enable_regions)(struct pci_dev *dport);
>  };
>  
> -- 
> 2.55.0
> 
> 

