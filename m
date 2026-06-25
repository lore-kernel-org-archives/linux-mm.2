Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11EFCDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7706B00D7; Thu, 25 Jun 2026 15:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767C16B00D8; Thu, 25 Jun 2026 15:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FA96B00D9; Thu, 25 Jun 2026 15:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 321FB6B00D7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:24:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A68351C5C5B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:24:13 +0000 (UTC)
X-FDA: 84919410786.04.61046E2
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE33F180013
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:24:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GYZYgANW;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782415451;
	b=XC9EpMmZ4mJT0C/EMbfxnUN98s0muwXO3Q8VmXPYkvV+6HPf7AKupF4dYmm22M/tOZ0rLt
	pvmZClB58SYnBeweEZpND5YsYJ80r1euVMuwhvRIQbeufgtsgQxRnmEzTGtR9K11TR0xMt
	u2IR65MaKopPAhIG9zM1pu/FmG4Oarc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782415451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdqNgWd37D3SKy5LGbTgJzitmjItzPDQm0eseC9Or4o=;
	b=dlt/UY0+mh9PLO9Wq0pLiAsCQOx6Z74KnPHkoJTvHfR04L8+dGbQODLmr5XYpZC1KmrypL
	W/7qxS36iete3AxkGlWHaPJnYchWCtnQtB7rI+VEThlYN8ZLoXzEWTtKfOtAJ5kYpKZK7u
	UWNes6g63GxG/CZXMj2zziokCoE49yw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GYZYgANW;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hfm+D91j4D6fQhHhMLbAAFOyJKqKpT7VoE3JfG/eRW3VoSr2vKs3+PgQGRWbqjQeCwgNsCFwbD9PSPt+vHxVzIT9EY48D63+0qrQEQ7JdTV9vfiEozo6NEXjb7xs2mIDiB+IVjPuqHlghfZRBaybazjn2YPOWEl9BugNr/1+Xxn81+fas2CMh/EoNPiehyzLc1AKQPeAvkRoFICyp3egmJWTLLTYF8NrbFLE+D4V5XrZk2TcdMGEw+idSrydmw4RcMyZUm/8Bs0cSyeLYvmRa7LA4u7a7KclhmIlusMFDv4U2imUbqc02oRXmBlImsfP755/tEvHX9BAxnztITZPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdqNgWd37D3SKy5LGbTgJzitmjItzPDQm0eseC9Or4o=;
 b=ve9zNI88qdqd7xRUeGmKGsVy0NrTRaa02BpIvsVavFxbXIkkfkTo4fPWGIxDxY4G6RcUPHTSg97k/1YTVaBSgL8MfdcvIiWMB2HTxPXiqzwmN3tRcmTR8qIPFJuJyceqoX7cE7mHJdoKm1X/zEosqCI+wr5jqUnGBcoXa/FqAwPtwDx70kRwbpRbz13PBHnqG6qFVeUxR8vofpH19oQTolad2iq2W+X4xQcs+5YD7kzOgfb3UZp6LdUjt44/t/zGPBn821Ahuf3eslX/TstdGcOr7sc0NEU3MdewpeuGnVLBwEZ835PpCEp3UYT9zl+V1ld2LxN1284cSMDOhFKKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdqNgWd37D3SKy5LGbTgJzitmjItzPDQm0eseC9Or4o=;
 b=GYZYgANWkV5PiuRCVU1FTySj0d2pV/0k1HLRI6QcE2YJHxNNba9cU+4Y/FvZvM2O1/tMcLxSgTWSTJ+PEFm3rVUv4/O5IrWzvZFH8qovJNF4sOlCCygCrD/n9s2L9F4V2Bjrda1EpKQIea1rhEIaOq2YVvNlJD8rcxWyNwMfzU1vF5uOGdtrqUrvKDha9R4VYtHrnJqmPlFsS64dmM85E8WjAWiFkk0kknQyucZqDbK/ObpPE+ByHJmfldBPswM+sBT7de0gV8l1UqDNpbtU6spPguJVrpe8hmjqKeXGLQCoK/5PZTlGc+uDACcmR6jg4dqaEb3HScw1InPbKxS0OA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5781.namprd12.prod.outlook.com (2603:10b6:510:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Thu, 25 Jun
 2026 19:24:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 19:24:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
Date: Thu, 25 Jun 2026 15:24:03 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <1EB1B920-FCF1-49F5-B602-DAACF3B97A30@nvidia.com>
In-Reply-To: <20260625122030.c036caf02435810b5ba0e291@linux-foundation.org>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
 <DJICBQ0OIM2I.3VWL2AQBX12F5@nvidia.com>
 <20260625122030.c036caf02435810b5ba0e291@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:208:236::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff64b82-7ac0-40c3-5300-08ded2ef51c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|3023799007|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	uyQXiZEBLV1DyKgsSis5U6ey4QA8PC87lZYb1glHDbnLhutRiyhU9w3PyTE4HSBi9y7xsanvqSQJFjywBiVuZmGpKoIGAo3kLkM+6L2K+6mrUiULUB8+Yk6Squ0JZBqgZIpuRFgOuzbo1yNzR6vL7TFT4WcEp7uDCaFkzkoANuekx81MOtZgXXShyK2bbheLGF4vbrNIGyauJdWKTniTaZfP21ON4aUCQa6QleMQ1AAThIWCehV5THFG1822GhojYdipswSVl7FIZml8HA+lWblZsJ6BboMq2g2mgYjR0wa46rDfcH8F/0n6kbj3VOqwPt37dON7bFQBpFB/6QMDutxZyRs1R2LHfIRDfG5qnFug3/+0ZwTJCLJ6DAxhR7BYw6/rzCpNQNztvFwcv+/xVUkhkB1Kfji69ngZSmwxEUItncAGN0iU6eq58U2ayzpfwSt31kErN9OIecSBXu26qCpfWYRjusO3HuAAwT0sbBbf8ubf6c9pF6T2y/cfSxh+5XeCuh5VkE0VHUuMURTXdKneYlhh+Pxm3rA9kk2gzaP+QE9yqRYy9x0HJbVBOwaa6KqEEgU3q/1XQdxBYef/kCIhuvNC2qyJM0SrBz5HFj8Zl4/ES/8iUa6xZwpbJ0FZ3cBj1Q99UbKza1hldANzxmiYHKsrJjDnY17hbz3Dd2w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(3023799007)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k8O03t96uT7Nn7y5txrIyNzekhLgDeli7My0f+IVrcGOtfXnDeUlx9cXSnle?=
 =?us-ascii?Q?Etdb7JgR7iF4whhZWFbCPhNyVw7G5YQYkRCgYZdrBJbFs/JoFAY3Ockuug8R?=
 =?us-ascii?Q?ecQFYJ7mSrkrutHubHAvWfDupdRIGTEtNDWXOMK3/wk24BpnoN4ulxgZ3TEv?=
 =?us-ascii?Q?7eRHUFto2h7dwCIvjD/MqirS3zDoVvjv76s5yrT2ovdGms+YDtPPC/Wa1mCN?=
 =?us-ascii?Q?QDAhR8ELFfE8HPve3kh3IUGbSo+pDdUq5ntZ9grjQjluQ/6APS0gu3lhmYFv?=
 =?us-ascii?Q?DzKQ35yeZjAAPlLsSYVx1DLQt6Yy5Eat80nGjX5L+5UKLB+MJjog8HJS64/X?=
 =?us-ascii?Q?IDDWB8moY3LRL+nZLLq1GTK9XKEaYGilM6omJ4VKc6WrmKGfLoLNvAizGavk?=
 =?us-ascii?Q?GnBZ508RBUKtRY1lbCZlkDIhSEPqJkyjAmX8Q/1ywkYN8afzILVpsqLe+9Zt?=
 =?us-ascii?Q?lve7w4jwn4C079HB/YCfFPdWgy2MvO0wTgGdRrVHt0kQCMasZ+XS1759PCWq?=
 =?us-ascii?Q?bFi+pZWVV7trZwUBTup4jfbiCz43inrAjYI5u3NnDuB749+OZJ/9uNLCoRRd?=
 =?us-ascii?Q?ULc+pjPzk3ye27YkODL0PAI95SYJpkfVcK3H6U6qtpsomRD18alrHBtxNP/M?=
 =?us-ascii?Q?0SChCrPkLG/ElJfXG9gWG5Jy2ypESFkGFfhadsPPSfl0q9kC4K0Rh+Mpih4k?=
 =?us-ascii?Q?ghNxqdxnRO14hR6kq99YT3NBhuDhXfSQk1p8X8cXQVIWuEdNSPFl2MHS7C6T?=
 =?us-ascii?Q?twl2FDfH3vqEuKNraMEr8BdYhRX7TtrDxMszNXvesbgX6u6O0K4XR07XTO+U?=
 =?us-ascii?Q?J1EOXI0p3GeMdtwSK8Rdwix4T0G4J+qFvrNuhMd2m/vhKZ2c6yRSdH+He5oM?=
 =?us-ascii?Q?GS9x/eHY+j/f5YQQXYAN9S2SBvzAHUM18x2lyEtfO2OHBt4xBnlDsGXraSPZ?=
 =?us-ascii?Q?8BDn89x9iM6FLCTNG1RJYyIftEsvZh7NMhUZDhYyIV1tM5KIBI7ga7nWqfEW?=
 =?us-ascii?Q?kt0YrsZVB97AaGA+A9mJfLUUGVgsEqV87yCg2jbkjEP41t1Gr9LIZXC395+j?=
 =?us-ascii?Q?B0rTE9gBvufwnkSTsdhqBMts8tyJ11qF9QnDE0m3CD41VdtyNoJBOThEuj7t?=
 =?us-ascii?Q?Utr7Ep8tGth5MvMpJco63vagcFwkYoAPjjUJTk1vrGqjc7TXr78akUaIGYW2?=
 =?us-ascii?Q?B2UAWrLAMmOi6v1tooO7sCyVMqrQTFqMzNUk+/833L9jd9RtDmz2ahiL6S4/?=
 =?us-ascii?Q?UDHi418K0z9uRYovvs2lokht5khhLgUKhdrTRVrUselutyg4oYlp/0u9q8i7?=
 =?us-ascii?Q?SI+ELg3aA+FBSvrB0CCLWdXVaMvAmQOI9nXZ+odp1UhMOhqjFg/9eGc7lyxr?=
 =?us-ascii?Q?4GGDyjjpqTargY6E08xUsNS5CHztnr0bjTJbbfghFayrKUDS43JZwh+AOriL?=
 =?us-ascii?Q?zVHCj7nAq5fgX7j32rBz7mOTnbDPIUTXK+hx4xDnpuKVtEInGTrKzINZRO0g?=
 =?us-ascii?Q?040Fn9rDSbZ32y5i09uy37dcjUX/D9sWiDWSOVT2I+AvMZ5AX5AwK22hj+Fw?=
 =?us-ascii?Q?amJ7DQHbb/0WbcQfR+Rst9RtVlyvmMtJvW02g/pmiMmC9RB0L+FgcyA9XWVA?=
 =?us-ascii?Q?PlfE5bmDb26vYswrGF9t5dHy4LD/amPUjUYKG6aCAVstPN/gRVSAU59PG7qR?=
 =?us-ascii?Q?M3NZv2Pj8Re0G+Z1FCgk4Fcek671iG5CX0cNUE4YWNs4nXe9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff64b82-7ac0-40c3-5300-08ded2ef51c6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 19:24:04.5257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWvdstHj6HIA78oL8MF56E94NEI8Neiyhvk5OxwX6VPxOUCC4w9ZLOaXS83qAHyE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5781
X-Rspamd-Queue-Id: DE33F180013
X-Stat-Signature: er5fmw3oierfxhmh119w38fshdrmdb3q
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782415450-183371
X-HE-Meta: U2FsdGVkX19ZIygCTv0ObYMlWRKpLNACGTjMmPjjg8qXDlysrqS6ds51p+SY1charP2JKP2Y3a1CZIkChvoeTZf1u2qzASjcuGW2lw4+7rsdzLVIZzUpooEygPVNuDCj9UCFA1iOSeBzMg9OJp2XBIqbBLR9hsGoYjY3Sg7WHnv3ak97wIv12mbJMjjWg9LLo/k8jJKGQZiub9zjIqFoqkQfzkbsCHFg79zeHQTy39CkB3cX4LKcS/uuNVuMNIVn7v9LPKHBkV55L+fzqXrWnk9S1zNOIhrec+BIIPkw8WpscLMdBdLP6KNRoqcURxU1ks4ZTrNFyBnKbmwwGYZlI+YNIibmWEzLBdQuswwIbMBtOHjv/CX0dkuAqThU7WqHXZvr3FByHgcie3i0IinpdtYCkViFCU+qZw7XZ6UQIgmxy0mhl5gDWJFIgRg3ooMKoxfye6L5QxMhak/r/PTdyhtLGL15JRZ//G3I2H2hPN6h676jDUMe2Xj+ymr1T6zMLa+SK6m/cW7EYkYDpnx/6SqJC1X5ipJQEo67FYR+Lin1Yv+5TX8dzWw0RO3ncGy08lFJ4oAR2skRSjW6Xfop3HuF3PthIyvUy44kM9Q9Wis7SZDxSQf9IuvqM/oQZ/q2EQmCi451ECyRZHjBuPZMQFfCqoFHm2Phzg3E3+ThriPogFyyjpGSYiFcRVJitpTK1oons43G0kcreCm9RSe4S5dxFCzXeB24DgRFliYZ/lnOW3NC6PyRJhyPZw0XKQ/egUjcqrQDmSB/BvGiU+aF0tJ7Nw2mW72rwRnq7uA+HIkq/hIqL6dOWGjRA6ttGodw7yLeYAnJJhQvxmp5UotYjrPLqra6pDs/g8pPprXu/Iz/xCfOcj/zv6PUejTPRxCr6prPA7ZcTdwZax6AC4GwahJrgz8KnAbVbCfmD6lK7iLf2zeSLstgedOTfEpquQgTFI7GmyFtUt7PCNmSLYp
 1vCwtk2n
 embtHjcUgNJftajax/uab5RBCLVP0CyrNWGWhKN2GppTYuGRMx66zfi7+qfp2xzQN8aFjT2gL8mMtfdiRFhjSI1Ql6DX56XPlUD4EcrOaHViYc4Vv0N+wXFrw4m1m3BKAfDN8J21XTc2dHYKzsOXSlgbD/iIhSY5rBA9auQgNQbTkA0v5wjyNsSmmpHVjJrJzed5pe7E5eEtMNPZRzPG80DWew/VwhIWswgucf4JiPqlZQ/WQ3zOVav+1gC0fVpmXdUBsK9l0KA6jO7Xs+3QLODKRN6d9MR+unRGYgRdc3xPqE/z1JwNNKUHoacfakyDNgRLgX3g24K1HzA96IPL0c+IrPkBZl5EsMAoCZMDrKgXwa6aFcmcDRVlTrHg0p58ptEDFGvmik/TOWhXohMRBX6V/ZL1vrFhS7L4BCVsrWwxQOGp0TTXh9hA8Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Jun 2026, at 15:20, Andrew Morton wrote:

> On Thu, 25 Jun 2026 14:26:51 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
>
>>> +static ssize_t page_owner_write(struct file *file,
>>> +				 const char __user *buf,
>>> +				 size_t count, loff_t *ppos)
>>> +{
>>> +	char *kbuf;
>>> +	char *orig;
>>> +	char *token;
>>> +	int ret;
>>> +	size_t max_input_len;
>>
>> This can be const size_t max_input_len = 32 with the comment above it.
>
> I don't think that local adds any value, really.  How about
>
> --- a/mm/page_owner.c~mm-page_owner-add-print_mode-filter-fix
> +++ a/mm/page_owner.c
> @@ -933,7 +933,6 @@ static ssize_t page_owner_write(struct f
>  	char *orig;
>  	char *token;
>  	int ret;
> -	size_t max_input_len;
>  	struct page_owner_filter_state *state = file->private_data;
>  	enum page_owner_print_mode new_print_mode;
>  	unsigned long flags;
> @@ -942,9 +941,7 @@ static ssize_t page_owner_write(struct f
>  	 * Maximum input length for filter commands:
>  	 * 32: print_mode command max length is 17 ("mode=stack_handle").
>  	 */
> -	max_input_len = 32;
> -
> -	if (count > max_input_len)
> +	if (count > 32)
>  		return -EINVAL;
>
>  	kbuf = memdup_user_nul(buf, count);
> _

Looks good to me.

Best Regards,
Yan, Zi

