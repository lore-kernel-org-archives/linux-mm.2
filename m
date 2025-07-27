Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC95FC87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 19:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0216B007B; Sun, 27 Jul 2025 15:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161426B0088; Sun, 27 Jul 2025 15:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0286D6B0089; Sun, 27 Jul 2025 15:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E71BE6B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 15:03:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7106611430A
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 19:03:01 +0000 (UTC)
X-FDA: 83710966962.07.2A8661D
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB89020008
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 19:02:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GC0fJCN4;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.85 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753642978; a=rsa-sha256;
	cv=pass;
	b=K3bXjLMLTmadDdVM1W7XTFKixjNzUJqosXIcTleCzBdAByk2ifPaTlyWNM9FqIuKtTa58U
	a8rncow5a7unBkNYlFgSnVUVUIyEihkWD25hYpb5ydFtaykvxgGR9qPfdWDpCuv1mw583z
	wz2YCU0/xKbb+/NdF5JaHUWtyB7QpRY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GC0fJCN4;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.85 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753642978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNYTdkUANLVDWqRM4O2yMm0i0zxCX9UdYAI2WETGpkY=;
	b=SA2qgdOWzx3m5EVRDKPOKP0K+qRMVv1MP857WzyJd1rJXDHs+1fMxMH28Zkwyuot0Tagcb
	mhdCKtdQJHbX+Vs22zIILOsq3olZwYzEDprBewZZOA9I6e1z+s3eMZzwn6LEBvyUhBgtdH
	Pmi5XpVJFiPoC6B7a+IfAS/DG5LuhAI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhMhB26mcak9SMTfRvxXoiUJIL6n0IiUDVMXxZJrcn0/ecvC/tg3JYC+CjlPSEB474TBS0jsssMIoLsKM47hnfunsWwyD+r5oahgqifIqRT7axD3wxWUUKodeup+yyCjKn4wuetEgR66HZPG/h+IOPMH2sAeWBlKNrmOLzLhHqzTEDPOv8Mw2KXWLMzyuGfCxnLgBgVSO4o9McyYurMwOG315WqlWxz3ZzYretOHPNsTtiq48xpEh2z3JPTSNYdEnm5btE/QacZq51MwbqIB7UUt2S9GmNBXxcvKpSvZ8FDuKa/gBTwvuEOVhQ/I0NU9cVRXNrNaNPQiIAsDEli0Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNYTdkUANLVDWqRM4O2yMm0i0zxCX9UdYAI2WETGpkY=;
 b=MB7BfBR2xeQNtR2twpUqKdlWFCHrBQ7jszhsR01jBljStxwtQfu8mcorCR/JgFCCeN4YUFsmwDX4nO/ejxFRhox5Kwe3t891sDznnUVSxtfftcLK/7q56LWuXPxBigoIJCEfB714Y+6qHzYYFaMW1naD1jcVauTWZI7lkxpmDvqng2gy7n3+I1SZK2qz+108ovoQ6Ty3+tCAwhAFQSN9uo84qJTLhkGRqel7W7f0PevYobeIAgK/c82GbOWgNGW7giYaKxd79hFIYERPEQxmZ8YvF58awMB/3IpCcDLVo+Ina+thjFNDFIwOrLkQDMJQgaUwf+mEoyviFnHGqjG+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNYTdkUANLVDWqRM4O2yMm0i0zxCX9UdYAI2WETGpkY=;
 b=GC0fJCN4S4r2nDFwCJ4MdieyP7hEPpkMqenIzZ8c8jr//K8aNSr7JIwHlcq6lMPyGacdp3JCJ+iezBXPLQwzUQAqVuX1/AZSXlKpD7pIqhmUnE0/KPxdFntMkdr1Ki7/NJcq4FrBGqtBS0nDu9LOEzbGgMsYdq/1YS5TWtccTjZvOLhJUmApPHlDAFyhCcLajTv25K4CNn4tJ8v35p+yBMTC6yAKvanggp4dAuyG9sXNviFxi4tYorI/VkePeWXxngD27cy7XiI8gJvKP+NZq08BiNa4hxcr2cCWO9AUAiKDCK6MCpksW/yPZbBIWYepV2VRFXxliP7lPkfg1HzJxQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ5PPF75EAF8F39.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::999) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.42; Sun, 27 Jul
 2025 19:02:54 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Sun, 27 Jul 2025
 19:02:54 +0000
Date: Sun, 27 Jul 2025 16:02:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
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
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250727190252.GF7551@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724080313.GA31887@lst.de>
X-ClientProxiedBy: BL1P223CA0035.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ5PPF75EAF8F39:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bfd248c-30c1-4162-59f8-08ddcd403102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5jKkuphRsUPrQx5rTfK/OB/99C13NS9sUa4qKUGHaQ5aTbQeq5bB7o+X+2/J?=
 =?us-ascii?Q?hxiOQ+eVs7XYbkh/5WWRbD/3yx5I7Mqaf/xynkE74d9rTl0jwoIlm1X+Kx9S?=
 =?us-ascii?Q?wttXBrEf5ycAYR1/WW4Food1aE7GC7KxaRonL4lWPaxhooQXkGDsZhGJgHtp?=
 =?us-ascii?Q?LdMxrDXMgyHjsTr9iyTNsUSyQInB458xL00OE0KqCDi3rNaY0ckfzOjqNDP0?=
 =?us-ascii?Q?h87sFYWHWQqU3DKpntIj8bJMZx3FY2rk1PBUPjR3NZkAZhhP/rL1sfLUKKBo?=
 =?us-ascii?Q?dIZO4ATvABrhMoHlROUJKPCeqkIzhnBjglbOyQaSr1pxYiPP1BQs4zxU8O8y?=
 =?us-ascii?Q?17GNsuzZjydeZm+kg7ySX+CE+Dw+lSN84NJ3XY7xO+/IEBZUfOHlqC66DWdZ?=
 =?us-ascii?Q?Lw0FGu7ROzA3Hlwd8owLM6YLToI14PNNhbf5f3uoP/k0Pbv5PvnAzWa/gUAg?=
 =?us-ascii?Q?CWsxa9eRaVgMx4wgwP/dL++CsI89WesI0X0tcdpGmi6JXgFtzQUzA3X8lPun?=
 =?us-ascii?Q?aEqPf9oS2SyCcc5Udl5Oo42W5278snpSnhE5GbCMOh/5h1W0Quq/kFa+HxzP?=
 =?us-ascii?Q?loaHuOKhG7HZapigRgc479LLqia6a0BIY9itgkq9+kl8Kivo7e5vmCwqvBXV?=
 =?us-ascii?Q?83/FqVsMu57hhrpzE6b0Q26ViSaDVPlu7ViSgotLnwOH3OC9W+gv9lyK/jyq?=
 =?us-ascii?Q?XspzBXtDqO7Fhn9nxEOZiFL0tGc33EwbnfQjSpvpAlMyamBzeuggvnpEcC1P?=
 =?us-ascii?Q?1UvLSVLTlcTI5SC/BL/X0WqiI9SG3ctWNlUtJpigBWi5nIUfPQWuWVXskLyr?=
 =?us-ascii?Q?oGi/aLxzWw0VkBkTIWbpEuuTASLjYSXCs2Att2Yf9dOthSF+M7BFHUJE/EVr?=
 =?us-ascii?Q?MqrFbdEvnkM9EswyE59mFp2Fn3xRU7wvy+REEtYcGjS6ooAt3WR7ZhhLvA6b?=
 =?us-ascii?Q?waA/NpS+nai7odxv2YAtm+QBPgRAygcyc2CcVnw/Rsq1SW8oi55hj+UFzv0M?=
 =?us-ascii?Q?Q67gizr9oxmgQEeuddUfVXsvt8n3RYNjiyoLT1Q+PnEzaqKgvhy/+FkoD4ek?=
 =?us-ascii?Q?O/Fmm3mBIYmThcTHU3rJ76d0XHd0mP4pJE+Vcd973u97/UdmdOoYFoagxafk?=
 =?us-ascii?Q?VGOAwe3r9U3dWpbTZl9TG26AjbTULUEBHWJKb9ZZknpNc4B/dDCMI5y2hiv1?=
 =?us-ascii?Q?yUVkbC9IzllRIMSj7Cad9H1ahFikPRD0q9xSjk5AtfcCg1ZB37HxnufYwoU0?=
 =?us-ascii?Q?J8/kSI9AxxSxhkixaLZf3/VsmTQGu/n4aoFhqxOsed6isc22wchveoaoiuZY?=
 =?us-ascii?Q?RsS4lfD0YSrVGtpaAKBus8QEZpNYSepU8+cuYg6VShN5mtAt/KLrUdQLziNT?=
 =?us-ascii?Q?IRfxbPO2CtWa7uu2wk+Y4ObRW+kPpbLtxaXDwleyZijQeDY573n8AQyfxr+h?=
 =?us-ascii?Q?Ou3hlLuTeaQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MUHa+37NxYHshW2CgFBL7bTORYnxCKmJ4Gpj5A84Xz6PXWITK7SOr3wOYEUc?=
 =?us-ascii?Q?632TgHet37FM2p8rZQT7kK1VzwsVbCiRfZYM+Zmk8viqFTIzbZr+ok3j28bw?=
 =?us-ascii?Q?W+kKTzJQ4P4L6ss8qEARX0l0CL1x27XaNfYL3IU1DAIOk4ojzzYRoynFzkdP?=
 =?us-ascii?Q?WLK+SBvcv0PEA5hSW7SvN4RLtxziv8g6lq0kW3BdA4QavP6i2/jj4JpVfauE?=
 =?us-ascii?Q?/GnN+G8LA0H5AtnZGiobrgQZjYfm6K5De0fwkBuZxKl+dF2k+tGY+VxGs1/t?=
 =?us-ascii?Q?W5tFWoGiw+QZjRTAVZJIQVxjAH7w/+/DAJPEECY2/bYBoTo3Lrq9JIZXXKgB?=
 =?us-ascii?Q?Y6WVc9PQB5kYpiFaDs4crCNCpaG5QfYfMsRgpv6LhtqXDioOvs/GyrtIucrL?=
 =?us-ascii?Q?FvI53Jr7N6VqgF7wMHnMYZ5LCfI+qTZqFXGhxHOuNDt2rKrAQPSYr2XC0OPE?=
 =?us-ascii?Q?QdVNHpdOXk3HqAtQmn7zGKccbNYujv0etpbtURZjzP/rM/4naN0Mnf6u/g/Y?=
 =?us-ascii?Q?RttE9svX6/YlP22u1PCJox2x7sXla706p3d23Wkdy7TYbIWohFvs8h+Ef8jK?=
 =?us-ascii?Q?EUzF3S8kAaZqtLpuYtXMaL6Z5A2+XxXoV2ZObaMzIT3cypLxjiSj8bcUwG1D?=
 =?us-ascii?Q?y7SxdJJeMgLDJftfUn6N9LLi7fSrMELXB7okVjY25b0i56n+X3JSqFKkcBlZ?=
 =?us-ascii?Q?Qqep420FbTeZH/AtL582DjXL4JSmkEc8tpvcp1XmdtLoubAPcz08a2Gv6Guk?=
 =?us-ascii?Q?T2djz5CqDfFYld0WdM4MA42reSkW1uXnO0EMb1Z0JvYH4PRu9cU28j8fnWsc?=
 =?us-ascii?Q?riGgfXsK/b/r1pg7/hrz6WIthNGbqF1kPa7tvZfgQrlAQ0RAxNfgveTmp4oZ?=
 =?us-ascii?Q?VY/PFPpnBNpaZv7xNzHGyc15qflD8KtqoIss8GyfT2sak3Onzplhq4l9ihD9?=
 =?us-ascii?Q?Q1xfqx7MGO9CneJMUXlb/BSBI3+dbrx86W8Qtc+civScwaTQGmSIjEqlRkyG?=
 =?us-ascii?Q?XVnztY0xkqibrzZup0plQvZYa8buN+7ZaLHZlOe054hbr/NqDDjVrdv/Gx40?=
 =?us-ascii?Q?vZbiE7UsahS7F9qlRIBvqsYXKDyEs74HpZbwNxU3QSblkduJoQR6UtqHkqdj?=
 =?us-ascii?Q?AghvfG45wjVye2lEft7p5jWtKfpBafDAuVAV0joPkaiEe+diovqvTF82LsRA?=
 =?us-ascii?Q?famfs19CRtH1Dks0cdQNj5Rkm92Ju/8tQEJxSkgmv13EHkpcaCpm+LLIBwLm?=
 =?us-ascii?Q?Ixl1W8cx6kwp/+CuDjBebBU1UWERIGJK+6JBz1IOsnWfbcfo0tu/ALTtrhac?=
 =?us-ascii?Q?weyAGfXqdQAF1dIT3nYb+W95FSd6x7GWECefeJQNo6ht9rB4YtkJ6Z9wApjD?=
 =?us-ascii?Q?ZAeKCLPGhg+BoXziBM30fhRLJPhEW7TDzbJDbRHi4QSOdFyeGsN9YIR4nLta?=
 =?us-ascii?Q?P9If8vJTRXDu/7XDhAcA4rbWV9chi6hNosprNzNT3RKtWmXDzyjd1Q9CFPw1?=
 =?us-ascii?Q?5Qkxg+41FTj8H1hrRHnq6L5D4RvdMD2zUuWLQGrdE1uchvwJPGTlC886VTpI?=
 =?us-ascii?Q?nuCtWsxZLGX5jqi5Oms=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfd248c-30c1-4162-59f8-08ddcd403102
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2025 19:02:54.2622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBVs5CwUSAmFbaf1zeb4wikMR1WlTDRnk4lKj3IIeixv79h+RgRWMppJ2Jn0Gm1a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF75EAF8F39
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB89020008
X-Stat-Signature: qwb1jn8cswnntbu1xza81re1b9okapdr
X-HE-Tag: 1753642978-278840
X-HE-Meta: U2FsdGVkX18vx+Sj6R/VDgprh5zdA5x+mgWQcaCWg5h6HXnIIgG84+wHvUmhY9mjheOZta76n1IR15Z8wN5Kd9AY+Zvcd0mfGViRU+Lwv2mJDHQJmzX+1DJZZT6t91xqzmBHIeY6C5gdOB/+Nt8uGerDySYhj+2DlUB7ll3gHnYrsMD/01S2RVokHjw7K/xnkDIPOyEDY8RU/5pqL3lnAOqPoUbfucv7j33xcPxuboFzt8+oGlekEI9o0BDw1bD4opjc0zKfdaxSkkXOPMy94C3r2tbaA99Lu4wn3PjBCxPJlvbuiMoJd1QD3B6cDO3X8xLSvzVmufp2hJxETanvDWqMVjoEnhcn8SwLgQuAviwyseXYMksCt5pMWWYjglijJQrpiI0O58Y7zw6O8GN12s5lKE5rM0e6iphpAM7Rf94ZMMNCp1Z/C+1LT7eKRwULIR4jf8GZmDZuLybQAY2GXPM9C43kWTyeL/a9V2Kvmty/0TFfZZdPsFVc9DZMCcRP6GXHEKCwXTsbCuSW1SdbnxJJXCpM4nGPB4zFya9yn4nac3WmOEZBHFqHqfhIIMkaCceePJqZaUaALxtlkERq0SFUyATi2LZfNk9/AnDqyIgQibqoihSjVMhp6LBDM00nwR0hocc3sEcotmdRjrio74GavsMQGm7fVg216o+d1Ej7HPhicKy0ExSTvzudPOz+HbhuHG8/UrWJYVJHiqpFM84L2HqoNbHYYAhUHvgBAjYQpv+XkJKw4GDgkzn3QddqCTo1iHVEAsAAtLS7aVB/Q/tFiObUQxaN6VrsOutT3/fN+qnDuTcRN0cfwrVD0Ii8kxsED8OpnZrQrKiWXGV7UDMmpSbrSmaprwqHlQP7HbzJiKMlwzL7IsBida733W28FvnFXl3+GBoBfWthFUwKNDYn4R1ooKk65VZZ8HyCyZMwRFS2Q+YJhTgkXGd4c9Q5xl3xWCkdyDMqbbIiG7s
 BW5+wkcI
 Pge+qAtiSlCT8Ejg7uJSFRNMHLGMm6WOwWE8u48ozvbpyEV8eZ5U9sPeVryYhfD6zPRdUARqAnm9HnzbPJQ3uOxY7fsiyjWSI49OZ2gEF/7acMKchLYI4uXI8bqxzN+6F02FXockzPafJK27QuMTFmN6+toJKft4EvkvcowerXLo4GCWBE2O1tSwgGyX1xyU9QzqUtUijIz1PTNA4erPyTXz678f6+0KfNdU79KfB51mj+Rb7VNkP6Xh9GgnjiSs0IoRF10low55mqWxlmK2agQdUY12mBH5QGEXzqLROL/XLehjnqvJMwECtsQTlcSF1oIHW+s0DwZP9aPcjKGaAjWITMQR2TdHL0mN2SPPV1/bBAhl4UiPl3p3Nk8AGuuPs+8q6r/EUA+gTHe9fthHSCRDIV1zkE1Jd9YYciPNzrjGrxE+kQYf1Y0Ry06hjMnxere94JuzQSDRpkbDnYI0VtPeNM8LbDXEyoh+80cvbju8RgcXbPZL1NOhvrrnVq7q5euP3mOpzsp6QCICSc2Iz2cIkaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Export the pci_p2pdma_map_type() function to allow external modules
> > and subsystems to determine the appropriate mapping type for P2PDMA
> > transfers between a provider and target device.
> 
> External modules have no business doing this.

So what's the plan?

Today the new DMA API broadly has the pattern:

        switch (pci_p2pdma_state(p2pdma_state, dev, page)) {
[..]
        if (dma_use_iova(state)) {
                ret = dma_iova_link(dev, state, paddr, offset,
[..]
        } else {
                dma_addr = dma_map_page(dev, page, 0, map->dma_entry_size,
[..]

You can't fully use the new API flow without calling
pci_p2pdma_state(), which is also not exported today.

Is the idea the full new DMA API flow should not be available to
modules? We did export dma_iova_link().

Otherwise, the p2p step needs two functions - a struct page-full and a
struct page-less version, and they need to be exported.

The names here are not so good, it would be nicer to have them be a
dma_* prefixed function since they are used with the other dma_
functions.

Jason

