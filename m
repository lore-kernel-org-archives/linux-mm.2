Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83D5C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 23:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD286B0088; Mon, 28 Jul 2025 19:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E066B0089; Mon, 28 Jul 2025 19:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25586B008A; Mon, 28 Jul 2025 19:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C408A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:11:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CA1EC039B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 23:11:16 +0000 (UTC)
X-FDA: 83715221352.03.E458466
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	by imf24.hostedemail.com (Postfix) with ESMTP id 418DC180008
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 23:11:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OrfHBCK2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.86 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753744273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m52sxFj78e0QN5ExokcDQPmMw1vKoylYLwKN85lhdko=;
	b=ykyDmeMzdxPnhTMMQrCuQoEbOb5dTb55G0B7yKDfGGsU/ku8qO24tqyS/CTaUDPsdfngjd
	EwYN1ujvKRZ8Oae1NDxDFIF2YJMYpY0Y31zPQBxPenjpP+I9zSzBTJJn3mHkfC80ZMsrHF
	LJPTgXVzQ8SsEvBRSeRZYKD1cyfFqhY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753744273; a=rsa-sha256;
	cv=pass;
	b=VHq0aFaqe/WbTsEpCYMC69qKhjZG/PyGo/NlKnB0Z65WHORRaUA0dJCaQobSmRyuk+LgZL
	AUlD3ZiQVQxXUeJiX6jSCK4heLP6uoUNN0jKi1oPgdxrEGZyrplLxcWWTmADHi4l+DOdlj
	5YVs3/E5sqRZNKYtnXIKETw/tFk58FU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OrfHBCK2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.86 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czOuQgNXe6/6Tr29oO7jOIef1kP/XKwulX6mWK7aMkctkerguJ2m4XJQ5ep042qb5i+hgr+/VvwjzkRAVCZNrRmAQadcv38u0yldC39u2W9fw1jCsq003VA3TXxedSYg8QGBPX2nP8FPvb/0aH/pkbDN/+WkppSSJnO5UzXJkN+RIJbJD0rA/pa59YWMXLbKnllOWruGVlESBaGBBGEOWW7+dTPPBEsmgQcFuw1TbpG3xCSF0A1TkztMheUphMoWV4ZgJL/FXv2Gi4UB4G0JP7mOY203wJRKc6lUH3xRS5EhQdsfNKWB4BTo8Bm6qxd+LTVpC0VjeoGb4Y1T8mMqrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m52sxFj78e0QN5ExokcDQPmMw1vKoylYLwKN85lhdko=;
 b=Syv9CIGqKXrVzYml2QErhEVN70odYVRoHDAQ7SdkE7bYf0OjxmCbleimc3oPaRCoK0RJdTMntQgUBzD7Ccr5dtPIfctNSpgZkXMGsMXhS6FWuJFoJRkbRxWfrA7JkyrtBJkL1gqErery16/Nh+Tq7md7npJRvf1ARi/qaGmjS5P+R7/TGhQ0mTKhKRvMSXycTi5g/nT9Dr66tDjiZQAEK0OX4escU9Qq7+cbIUR/lUtnL/YtwR4Ab37FrWkul0K6+h+juI501AWMmcZsZXVNY5vH/SBxZR/oJQFot8dMBJoQ7uHx4dUqxl3IoKWxQ5dojCOdcEsanrMNBKoAHQlA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m52sxFj78e0QN5ExokcDQPmMw1vKoylYLwKN85lhdko=;
 b=OrfHBCK2M2t4Th6IO0tdxAU0GCpONFfHClOl9jUa9Ig14d3VtztFOTswAhsc7kbA4ZkyJgX2JpW+M7upvuD3TbqxpWpNq8ajoDJKCJ0sDEwqI67PaHDy1ZYZZMoJWOhMXJAfMQPPY9H6aIYu9gUUs5lgjPmbPtJVenZFyO1aWsg57wheW8IqCcP1ITA8sE7qM7vSYduBH5XpimxmYa/BoxpSOUPK/0e6lW8B/Qu8NsLo7KcKO+U56Wf8jyNdZeRMLYvPYYc9S2J4U1KJgR4iNZzHlnrMuicB7hX1/zih9Ovf0YjFYUSiMN3W9ae1EPaUPrg9Ze4c9BaLh0CX4ly/gA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA5PPF530AE3851.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Mon, 28 Jul
 2025 23:11:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Mon, 28 Jul 2025
 23:11:08 +0000
Date: Mon, 28 Jul 2025 20:11:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250728231107.GE36037@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
 <20250728164136.GD402218@unreal>
 <d3c8c573-f201-4450-9400-cc3ccafd2c04@deltatee.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3c8c573-f201-4450-9400-cc3ccafd2c04@deltatee.com>
X-ClientProxiedBy: YT4P288CA0014.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA5PPF530AE3851:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa0d37c-a687-4cd4-e853-08ddce2c092f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1V95ZcpNwem0nwCQE/ASgxjRPrVYfVpjDhBwb0kv1NWDntQL3QVrueOMQbLv?=
 =?us-ascii?Q?y27AgyaxmxKNYppfrjjQZAmQb09TjfWgRyGCNyJVF9N0RZFrI3Jg3mpVjDbP?=
 =?us-ascii?Q?qoGRD5pCWRFQhJv7PbsUNmKtXeqJqQ8lMGfoy7u7OgaeYdXptXhhJxaDAJZf?=
 =?us-ascii?Q?g9zKMtAKDo2e/0yR7vIdAkMd9cuYdQYx/e75c2MZUmTBbknqpGqrLl/7Swld?=
 =?us-ascii?Q?h0Y7cMRlBhpEVn61YTWb2kC2zvLAz/boMISLNBUqUL8VWKcrTq2aGoRDE0g7?=
 =?us-ascii?Q?Z6WwQxKzXxD1sJsC9Yoo/joDZMZZ342stRqx14gXTUwZoyS5wvdajoL22jqT?=
 =?us-ascii?Q?EizxFVSeeNtx4dgz5DH93Ca50gjOvKgL9TuGXNMohFuFKmIHpCuYbfTLgPgh?=
 =?us-ascii?Q?1dZ99qKbTjp8MLpRq55fLpVkz0ld5xdLYkKhuaSByhC7fwYwDH5kPWTcKa1c?=
 =?us-ascii?Q?zUxgBNB2/GrFCnv2EtbcpeiW0/irU8gccGyQSoStOQ1bg4PwHav4EF8grsHo?=
 =?us-ascii?Q?Ldv6dyrAL5De1T29huL8grcKWoIGTiCK45t4cunIUU1JUJ5g7ZZHrVCS18UM?=
 =?us-ascii?Q?H2dIiiYSKo1YaAkQ4ilA7OwuncxWOSDevqyrSGGnGWVS4teeXDw62pEZDAb+?=
 =?us-ascii?Q?rr+SrBIwCFqqjrN0WJoHO6+GrSN9UKCEGy8T+QcHw10CtHbFk3Qs5hAg0BAk?=
 =?us-ascii?Q?uj+ggfZJCSWRo1LDe0fz+m8tKzHWImz3pTcNOhf01N+KEclv9Fguobs4uY7r?=
 =?us-ascii?Q?NMtbhoqQBqsRw3joZwzK0mH1fC7kdHoMk2KW4KvZW6u9DiGVwxEdnneHbF4h?=
 =?us-ascii?Q?SA6QJpLT/c4jSf7Spus9PVQ/oIBUjWwsZlSGrIp0GEO2H2n/VYY8R34HmE+g?=
 =?us-ascii?Q?BIes/NuLu6lOKRoq+a2zGXdG6T3mv5ny42nXnVoCbyJiV1pKbZ6A7PeWoEHc?=
 =?us-ascii?Q?i1uamdRoThlbEGyA+uUrGHxC/V8BSczNa82i41B3DmHtrIHH9SGouQNZ+IQz?=
 =?us-ascii?Q?ER754XBQiivrLZ/+qfXP9O7b0lfyJQ+4UAeZZ7mgccsZeIBleOpSZ7tpRgxT?=
 =?us-ascii?Q?0tkQMIti+YxtnGqkumm4Y+X5B67AaCNRWhundHvytwwaPnotIEyQGDEL3wWT?=
 =?us-ascii?Q?zKFMLA7PjrC7JvpSEmQV+tpf7hT79ZIWuJiXYaDUeDmLltww/ox/jdE/RrAA?=
 =?us-ascii?Q?q2vXACW4iicmFRPuJKrP9hjFrT0kFM+42j7Ed01cUFvQ8j/JsK4oWMX8SgG/?=
 =?us-ascii?Q?tp5lsG83olYhdY6xbzRoM0d6xwh6T+sJdOwvNTbIT0B4og8kt4zb55hZaVqj?=
 =?us-ascii?Q?LEy2zX5rgrCnuBZmeW9FyYeWzWXJJSNVD64WA9mR6ivah3gR2ZiSFy7NwA8C?=
 =?us-ascii?Q?BtR5/rYm039JlsE55r6m2I54jbAGaHAi2rRwR8V3Yg3L8ct2iYJWdcOdzqXe?=
 =?us-ascii?Q?QrMI4crqUrE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x7t4llgeWUhtjbVE/SDbkijvP3QB2JXxh1NohEIZAty5latPfHzvzC8agoWW?=
 =?us-ascii?Q?4/wMweV7g9zB2h7FLPVdW3Z+MXbJ/pr7JXH6jftJlz8sJSj7wI5x1QEYWkEN?=
 =?us-ascii?Q?lY60tbQ7KrhDNhPN9h/0WXrETJMbxSDpglUjwaxoRSQzXdkrBzKsLbFEYBK7?=
 =?us-ascii?Q?vsoZtYWtIJD37qeeQY7WaduKUof9d7v+6iPl1ptFkUjc+B4U17pCYVnIObOY?=
 =?us-ascii?Q?SeXweU2bjM6uBOOpEpZz2b0DdEfA+W86kvCv13or/qQLEAGNLvUqgf0QCA77?=
 =?us-ascii?Q?HXo637tj207V9oul/hOISYMAvvqFevpyQcwC2Pm3xrGobX9Nro5kk5pO2tK5?=
 =?us-ascii?Q?evHvqXDvYMNLJUl9LOtTKdh/5w29pC7dh4Qhg3ZT9OpkxCZQS/FzNMpcPjME?=
 =?us-ascii?Q?jBbb7bEq6VjbKcMlEnjynQnTL3dDEdntsfIDho697JDLLQHkur0bjWdPKpV1?=
 =?us-ascii?Q?CRBVZ7SzXtIDcnvR0XiwJE47a6Lej8oqKKmQ0N/LJCRAleWC1UHZUhONdJrd?=
 =?us-ascii?Q?4KKHWRMYukfLYrOYG/mn4iKWSHCloENtRRNoIA4c0jun/xw4e4O5FlYUY0hM?=
 =?us-ascii?Q?pO55RYJuEiaPK7JMijOsnR8nQ2FiU/QULys6KHlCnoLcPB/kFQuJOihgKXvc?=
 =?us-ascii?Q?qZCl51/Y5vZUlh8+02Gjo1MdjNVl2CFtbaPtK8EcrLu9ybQhYtsCrKZYrTdH?=
 =?us-ascii?Q?WKW7y23+B0fvJSc7ftmihNHwNKWbqAyVT1bDuoTVB3nNxAdOrFxsfKsgVoNm?=
 =?us-ascii?Q?omX5aNvIAX7Tgn9Mgig2HDKFoHRasurtDPffVbHfBOxcgKOKnYQOVxOGpDzV?=
 =?us-ascii?Q?K/pvFU/2zWj6C3MVWNQpA09zoib3wOwSBqUPVH6PgsWchHg1ZwI7AHAazj5q?=
 =?us-ascii?Q?uzsTkWbtjwnl98PI5Vl5s2eYit2XMjK6Euk+ZgK3hYn2PCWqs3mcQoikuxKg?=
 =?us-ascii?Q?MHp+cPinxw9sxDnV2grrnC/rrbh6bOzq4KiKOiTo7ZKkU8rOYIAWJSuv6MAO?=
 =?us-ascii?Q?hTLEqHGZr6gfJ0zmRKP6uOUlLbpfoBDDGgwslZ7dTG34SldzW/1fk0cYPfH1?=
 =?us-ascii?Q?WejFcIGWlXIjBO/pFz+Ys1kAad0MtJXKk0sIeWe8SujM7tDv29FnR/EIWuk1?=
 =?us-ascii?Q?UDiKCK1WXt/R4LcrzgUfvKNsxcD3wk39BFizNsSA0AlAGA8+5ZF0czYRUZFG?=
 =?us-ascii?Q?mYfb6c1jzTKsQk+/TaJLlWXqhf3HcRl1okdfYnI7nmH3HOih4g7Tv3OaDvTq?=
 =?us-ascii?Q?drstECOsYDq2jpQtS27uiM6zm8MR6XDh7hweP9jPmD/EEmSUVAB9vxNTk+h8?=
 =?us-ascii?Q?M29REKXFWwlQCL2GVYWGwSf1uOwxQBv9F/PBZPKh2fzHRSvLRwmsrMy/eQQB?=
 =?us-ascii?Q?JB6609Yp+rDI8xXbbiqZIuqN/A58RaWIuTrdh3sReT+2n8BMnbreu3VFcDUs?=
 =?us-ascii?Q?+C2+fOr1bn5rwmORwH3F4eY7/N52UFYMbgbzQ4Vw5mpW9+fd0bsg/MN/NY2O?=
 =?us-ascii?Q?Jeos1lQ2ydFT1GC2FHEPXMQtL1h2LVEv8scn+P7SFPf6wq2xWorDtCBvOH3K?=
 =?us-ascii?Q?cj/LuNeCteSettkAbhg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa0d37c-a687-4cd4-e853-08ddce2c092f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 23:11:08.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8PLJwAJYurpqEqiuBcFzp/gpfXoc79RU1xbPgFRfaiy8p1KYB+Hbf/5DDpCYjX7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF530AE3851
X-Stat-Signature: awe3z8agz154jjo6au4tgmyg8gwi3b6f
X-Rspamd-Queue-Id: 418DC180008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753744272-237038
X-HE-Meta: U2FsdGVkX183a392tiGx3w074uqSuJJe0YezOXBYhPFJTJ7GhE2SmWnRRTMwVLz5toRzI9JkhSuw/9wEEeq25DJROA3XUs2CBkokLZ/C4OMYFu+wkbLwY56DqdVNnaiRpurrJ1uPOHCmoQFVMtt0OWxbbErOWQGWb3bXq0m4cjlA4Fo2ISRagVPf1FJwc6ESPH9w+Pd7cF4I7KwNlaRPmb2Wqlua6UFaUzXe+UqxmG037O0qRt2NQZW8NJB/P12QoACAIMXvhFBoP6bOqis2JlQH/X3OYfjYtGQDk96PwrektzN6p4hoON0skdlZYbTRSMvatqCiPvChaIyaGuy7FHLRmazpYPt9USom3NL6kth8qU+qghEQ8n+72WowQVrJkX80Zje5lviC9yr9ywT3+yOq+RVdBQe8TLam2F9Zjxr/ynOjwjOQ5UDf/wXUlIWc7Mnmi1jTbG77xBuRu+7hXUC+mm2qNEAhZW5qCsaH16vDTWC+cRCvnAlfhPm7+5vh2OHczA4+fYDiZlsKHFzUWespCvuBRYGt1l/D2FcoutOtSuJ3BOt4KrxfSeTwlEzfBz8X6aA2oX/Pun7PcD+h91tG6ScDl3ftcGaR4VMn64jqnio8AT53zj17XXmfJ+KEzGcusgmaawxxJqQjWZ69eW7OHJVfqb8EYYR46a1CcctCYjjiA/Ww44xqe+zR+XwWvgKuLRsnCcDg01fZ1+JwnqonUJWG/tmChHuJUAI5hEdQ0icoawW5gCFhYPqGmvehby7ympuPa6jxp2BG2qvEDxMIs06WFoSErWIpyTxAiumLLef2puFStjSJqblTZ0cI08lqSprVqoB4lWXGXi1Vm4Yg0kgJUAdERt6kApYBSIf0/t7PoeDlcfi5PmU2yj3/UypArMC48FgXygCiSMlyEmSfQloY0F+424iWtdmYKwQOTa3sd3NXxqQ3z0i0qzvogNFeV2lOGcxW5X2wexV
 XSX3iHmU
 oqrplY2fJJxnlKuOvLkfir9w6l2sY7kwnAB3Epba4MfeOLIgvkhiI9Iyt6rK/4DVNVwH/aGM6BGYwiz9f1SwmMM6uj3BjZVlRsNCEmu3Bff+So+BlpSDQezGn/iWOz7584mdq16bV4nnheWv+5fpoiquUxO2jJZGBHuid7fDEdQcxtPtGrkBV0XAfMcYxCqxrTmXuDQIXwyRXIruBAXYBm9aJVFmfWIIEcIGE6RQ8ugv8qOq60Dpx/Mt5+wQunW6WLSz9ZL3hZ6Y/I3jNHyXhi+VHCohtoGHXt0C8c0U67TPnh/aJGnbgcRjqMIeKfCp8C/Bv/PxZBrJ/kAvef9sr0w0fzVI60cQnK+LoFvk8K9OBNUIgZZ41eLc5PEJAbkEXrF6siOt3/SC5ILYu05FfQK+tJ+CowOCLRXqh3oCmX+kZ70m8qbipm4gzLx5K5VUBCWholYfTqGBnhRl9AJAE+SE3IcbP5IIWWOI/lGWMamCiD9fDMpjIrMinwk9eibK3+1FrpMxd0YJBxxFH9Tl8PpXO37S6Sd5wM57y4Ew+OaxhBFH6UiUfdVxhktjJFDLWJ31N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 11:07:34AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-28 10:41, Leon Romanovsky wrote:
> > On Mon, Jul 28, 2025 at 10:12:31AM -0600, Logan Gunthorpe wrote:
> >>
> >>
> >> On 2025-07-27 13:05, Jason Gunthorpe wrote:
> >>> On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
> >>>>
> >>>>
> >>>> On 2025-07-24 02:13, Leon Romanovsky wrote:
> >>>>> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> >>>>>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> >>>>>>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>>>>>
> >>>>>>> Export the pci_p2pdma_map_type() function to allow external modules
> >>>>>>> and subsystems to determine the appropriate mapping type for P2PDMA
> >>>>>>> transfers between a provider and target device.
> >>>>>>
> >>>>>> External modules have no business doing this.
> >>>>>
> >>>>> VFIO PCI code is built as module. There is no way to access PCI p2p code
> >>>>> without exporting functions in it.
> >>>>
> >>>> The solution that would make more sense to me would be for either
> >>>> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> >>>> P2PDMA case.
> >>>
> >>> This has nothing to do with dma-iommu.c, the decisions here still need
> >>> to be made even if dma-iommu.c is not compiled in.
> >>
> >> Doesn't it though? Every single call in patch 10 to the newly exported
> >> PCI functions calls into the the dma-iommu functions. 

Patch 10 has lots of flows, only one will end up in dma-iommu.c

vfio_pci_dma_buf_map() calls pci_p2pdma_bus_addr_map(),
dma_iova_link(), dma_map_phys().

Only iova_link would call to dma-iommu.c - if dma_map_phys() is called
we know that dma-iommu.c won't be called by it.

> >> If there were non-iommu paths then I would expect the code would
> >> use the regular DMA api directly which would then call in to
> >> dma-iommu.
> > 
> > If p2p type is PCI_P2PDMA_MAP_BUS_ADDR, there will no dma-iommu and DMA
> > at all.
> 
> I understand that and it is completely beside my point.
> 
> If the dma mapping for P2P memory doesn't need to create an iommu
> mapping then that's fine. But it should be the dma-iommu layer to decide
> that.

So above, we can't use dma-iommu.c, it might not be compiled into the
kernel but the dma_map_phys() path is still valid.

> It's not a decision that should be made by every driver doing this
> kind of thing.

Sort of, I think we are trying to get to some place where there are
subsystem, or at least data structure specific helpers that do this
(ie nvme has BIO helpers), but the helpers should be running this
logic directly for performance. Leon hasn't done it but I think we
should see helpers for DMABUF too encapsulating the logic shown in
patch 10. I think we need to prove it out these basic points first
before trying to go and convert a bunch of GPU drivers.

The vfio in patch 10 is not the full example since it only has a
single scatter/gather" effectively, but the generalized version loops
over pci_p2pdma_bus_addr_map(), dma_iova_link(), dma_map_phys() for
each page.

Part of the new API design is to only do one kind of mapping operation
at once, and part of the design is we know that the P2P type is fixed.
It makes no performance sense to check the type inside the
pci_p2pdma_bus_addr_map()/ dma_iova_link()/dma_map_phys() within the
per-page loop.

I do think some level of abstraction has been lost here in pursuit of
performance. If someone does have a better way to structure this
without a performance hit then fantastic, but thats going back and
revising the new DMA API. This just builds on top of that, and yes, it
is not so abstract.

Jason

