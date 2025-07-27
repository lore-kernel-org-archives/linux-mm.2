Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6478C87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 19:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CC66B0089; Sun, 27 Jul 2025 15:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD946B008A; Sun, 27 Jul 2025 15:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBE26B0092; Sun, 27 Jul 2025 15:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22C716B0089
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 15:05:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE5E4C0773
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 19:05:23 +0000 (UTC)
X-FDA: 83710972926.15.AAA2276
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2038420008
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 19:05:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=At3Osj9o;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753643121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppkMvIiK/f3S/DEb4c2LCtYu6jIS22VQe6ZJOIk9tGU=;
	b=Hd2uLw2WH2tYStrFShY5qmYC9PfilY3n8qnYJibn+9R1s630MKyeDS5Ofde87MaRf7mGTr
	JfaM/ctu34qTO4e8YU8u+n07+35DGkSiYljAQWUET9Tgl7kH5GvCnJcuYlwwSRm7P8FkCr
	jdOUdB/vVzRInOEQt+TnjRXjDwMWpFg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753643121; a=rsa-sha256;
	cv=pass;
	b=NvBhAwqMKnLf2QD4fRQJiQmo4hZUG0KfoMaRLMYPdhrR+7ZTFaSxdr9hdUmoq4hCQxc+tu
	A9HssrDU7mDMDY0nDnfCqicrC+pycHn+4rCOwS/+OftfSRijbUA2CwZDY+hR/N6gxlaI7h
	ihkwji9FOyd2ztax3cHIWjRtBCQbPCQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=At3Osj9o;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dg7x66/bUcUMfdR9Ps3MNteFBBiC3RemxRVvCN7U3WeLDf36DDGXpK5koJ1shvLvHZDQUbA02As78VyiX6hVJEkoDV8SUTZWwGubZ8hX98RWPSJhuwd8yeSx/zxYPJJvI5T+yoPGWLv8S6m1tm2I6BULc/jWcri6Ub8avh01HfKinJphsOoHFWtWLppLOdKlgHfqveaOWpX/X4xdp1NB9UvrN2GsGNXf6eq7yySuaxux//xik8Rx/nDPp4OD/s4Jvmt6KWqrHSd7wZZO8FtHkqoJwKk6Kt+Gn+L/ussG4Tvk1FQQ7qUYiOpPoF94hH+twag3H0oFqvB6VNW7EmGXcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppkMvIiK/f3S/DEb4c2LCtYu6jIS22VQe6ZJOIk9tGU=;
 b=pk2GxZX8R0zOwxf7+di8N5nGGaHmH2L+dIoKVS5CiXd1iCTmpucchnhNLE7hWbNZHyc0sRzK/pXcxBn3pkcgSs27HTUGTvjMMNCElYwP009lpD8r1qYgh3YSxv5Ytfeo8ds2uFcl0u6ApxTOV48/BB308Ms/HwnMzhlYWGJUMP6Sd5Q1XaKCduEtVXMfIplld0ULYzwoTafq+JvsBRDHXkK3HIHY8ngS2ZB7/3xM92XeyffeMh3X1dGw8dc88I9OFp9XCtYWMTi148+G1Tltmc8jCNLkbhUxwVuiKtreezu80fij/hXf6rtAr5iCNiVIqefYBe6+xg11IPi5VUApcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppkMvIiK/f3S/DEb4c2LCtYu6jIS22VQe6ZJOIk9tGU=;
 b=At3Osj9oJSlfdkFNnjFm5o5+UkqYaaS3Xsvs/0KfW3iubsw702+3ToE7RSeT+QjT7+0MxVhkOWNg5nZaeAC8bHuPSj386RktUqoa/iQHbIzeKsQnnx9KQ6sHwD9CcKIxm6GfMwlIlelaEm5QuRPfSvU4d9mOcU73kyq3SiJnqdYsbhhx/DxRTUtzDn2aVkQxjkipq58tmlbNjhZBAa8axgzGidNIykrKdOh44H08P3J9AcX7HuAc1y0pb1v0yd9z3CLgCIvVRcJo4pNi3R1bJps7q1SUgbJeD4qpB13tsPa9z8zlH7Y1NFXAFAoU7o9db1kXbDKDuFD1ZO/W86K2HQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ5PPF75EAF8F39.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::999) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.42; Sun, 27 Jul
 2025 19:05:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Sun, 27 Jul 2025
 19:05:16 +0000
Date: Sun, 27 Jul 2025 16:05:14 -0300
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
Message-ID: <20250727190514.GG7551@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
X-ClientProxiedBy: YT4P288CA0031.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ5PPF75EAF8F39:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e512f2-1f99-4108-b6b3-08ddcd40857c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0sZO0eH4QB4Ql8XBONCtg7Ik7or2eFuee7p2ESzhrPusQksNWHWS/gwa875x?=
 =?us-ascii?Q?sdraFj13zZiEr948Y75mXCUX7c2F5PBCQ2kUju4JLGU9NFKdFVAmKfnzpcsd?=
 =?us-ascii?Q?02jN8OjbioANuS7C9mzCTvjemjYLOQ1ZT6i440h/8nsemAoHupTd3+VJKKYd?=
 =?us-ascii?Q?ldKA3kMRQ6/FDZzHI4IYxlCQ0ipiWYRwT17Mrhv3mP5mnmhEz81d1yMG5Vks?=
 =?us-ascii?Q?Z3vj4MpzvFBVto6t6eHmgAcdoLsfd4ZOjmsK5riO6viQ6N5SioCdHit4xVZm?=
 =?us-ascii?Q?J+z+ZfPSJ8vZqhNGNnl7mp0Xm+nu6EJEuZaSHqi27+FoA0NT8xBjvuUvEN+E?=
 =?us-ascii?Q?8nTPH13uvQAhKW1FIQbY5AjdfeY0Rm2jFi/AT4P55zbfGt/bH64qo2kydI7U?=
 =?us-ascii?Q?0F4I/i3ySmqENhKiSRHR3Tdpt9F1VnnwPaxCW15Lz3rMRUfQJ9L1t3KAWMem?=
 =?us-ascii?Q?4d/MivYwlW1e8f4SUJyJJZcALD+87DQvRcr4NbGJxn/RtvroX7udE0275f7k?=
 =?us-ascii?Q?vYEsR2eC3tf4oLkvBSCNLIwErnHTsN/3GfUseC0ilZaCEuJNDpwoyi6qMBir?=
 =?us-ascii?Q?vLy3rBWCrJRMfUExQlZxZNLcD8bPtwN/8Ns8lWTLoEY/X/BIKNrWX+azi02q?=
 =?us-ascii?Q?v+Enj29mr8OoAnGMT44251ETU0PeG7R2ozg/EPS4APl7xmtCsTDTpK2lB62q?=
 =?us-ascii?Q?l9QcS1CUD7dzq2jiS1aexgKgttis7qY6OUi53KDmZ7JcqNz0eZ/PJfu/v5IL?=
 =?us-ascii?Q?//P2eMGXgLAultRszhq2aXjU8TvKlI1duxoebU3VRQ7h4ZeAevQCxF+hC+Y+?=
 =?us-ascii?Q?SHMrzuw54CA8RZPBjEg9QEviXlLRFttoNC0fiaewDvUJYLp+T+mN9PEY69FE?=
 =?us-ascii?Q?sdMqIekidVxErIJ22n1FziQ5ADXqrfVsx+7gjpIcbfB6hpUfPhhPvS8M61nt?=
 =?us-ascii?Q?AWSk+te8JDP2MLigCiJTy33n8G/ZaR1TCtpfjWHcWBKAbdwbwanlzkIEd1Jm?=
 =?us-ascii?Q?6x8POPM36QIv8SvHKfGYjAQxYxxaN7qZIYZTYMcA2DHomWSHg6WZ6j5WWEbM?=
 =?us-ascii?Q?l24rUTmVcv3ftpyTEUD9pwdmi6oIKc4NDjqMBshFecqLcn2ocEyArx2j3MHN?=
 =?us-ascii?Q?BKRBeJFhH1pYf+ZAZzWw/YfrYconUsmd3rkPkDlL6mXbcPu+4PpL6tmUnng6?=
 =?us-ascii?Q?gcxVUOhHH8/ywzrS2DT/GI78+85Hbk17pN4BW1hgH2lWFA1PacyoMrtfyUgm?=
 =?us-ascii?Q?gkMckkE4P++cUGAI9s/oLiG9O7mHcU3fRTB+xF6tfhUlMdgfC7+fPBTLtmcp?=
 =?us-ascii?Q?JRgqjgR787IP5jpx1JZf8ByEUG7TCfL2E412JtJ2itQ0mGO3XKj7ee2W4EaP?=
 =?us-ascii?Q?buEyoiIjm79LnAZVZaI6iJZ4qIRhA58X/2o37OA7/ByziXiJ0Wv2EWie1naZ?=
 =?us-ascii?Q?rOLaegPBtS0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uiQ2rlnFLT7dJLg9vxrZrNnUHrcNf2Z8aXuh48wc7OxC2k0lh5avwbsdSu2b?=
 =?us-ascii?Q?/24rxDA4oO5IhJDl5yyEREhUcr5/42dsG63IUuqkyTKCAf37P2b1/IQI+VCW?=
 =?us-ascii?Q?rXtEJy10fXFELDOt7ed61iINtQJXAv6b+qNMxOQXw7wqieMErwqEjGBXivST?=
 =?us-ascii?Q?6N55Y9utH9MAjn+aEeU8HAz2F2BQ2e242tCmsahVL2DcEl1X/Vi/fXeefZSy?=
 =?us-ascii?Q?pSz+GsAnNy1iZES7HEkVmT+CJXChHVnsMgR+VKAmETH6DLLsCOoxgQJgY6yv?=
 =?us-ascii?Q?YtPF+ggGmqxE0Ej/cltiRW7MIgr0xC1AWrgxChB7cl1VxrmXf1ZF1l22r0IR?=
 =?us-ascii?Q?8PBeOeTlXSyMmH3b7DSm14M8Is9xsKH55gWlzbfEoCvyZB8myFgrDu15iLhu?=
 =?us-ascii?Q?rkrZ3Gd51qju3ihZfM462LSCpXQT+dPVKSDpg2roQE8Zl41AOLuwSwLspw5C?=
 =?us-ascii?Q?T2m0tIUFQU5mJyt6ttLX7XkBR1jVojnCUVerF8yQDIGjo6vLqbsUEaocXjKR?=
 =?us-ascii?Q?bxfE/KzMM4me2azFZG73dOWa+yDp8JcRzF95Ub5zpM6COABmrxJSxvPkFhnh?=
 =?us-ascii?Q?WhjAlgOO5ESYqZoieez2XAzU/LMpV5BO5aF0OUoySUu38e/arrX65R+K3WkA?=
 =?us-ascii?Q?yYxlFo926FcS+Z9dShpFnI15vw29aFo36nXCEUbu6WqT1OJgWsWkf2+LjWEs?=
 =?us-ascii?Q?6T5wXT7h3d7Eil7k0ycSxrh+MYRF1lMgvM7L5sldfekmS1NouY1+ln5mqSCf?=
 =?us-ascii?Q?98w4pz9l/gr/IM8vgMnuy0Ft6zaoBsN+H4zETBhjFBgKWoVO1D70PozUbQ6Q?=
 =?us-ascii?Q?s2GFZBCIDBmJqTgO4zXUtN23dTxtS9KEApHdmknnIfo4kMtBpo8FvSLzwF1o?=
 =?us-ascii?Q?FBI5ilgZxKZ3HObL6glPzr/tbUqCRpiRU2QgCOTuj+xfMy779y5P0VbyzoJl?=
 =?us-ascii?Q?c8TkeekH+z9DFATYGG1inxbk3LQ9XbP5Yo5V8hdXEKAwzG5G3cXGW0NaZQMS?=
 =?us-ascii?Q?59g9zTUZJbNRBmPRcjWVStq3LRsQKlQPssVGhAJCkAra7dHgfRdQsQ4GFSEV?=
 =?us-ascii?Q?GxboMcvvbk7m8/LEU2AmBxW0HyhSw/yWIOWWFonUX8RqRoNUT5y9Hkic7MNI?=
 =?us-ascii?Q?alJxcX+hHZuFjNKIQeEmxTn0ussJGSVh5oGY/psic9Pw6hBZdqzsD/HGzwoX?=
 =?us-ascii?Q?rJDliIbo1Gl2qszjm7+hhipLPt16Wgnr2ShjwogRFivXQCC/CibXliZCqFz6?=
 =?us-ascii?Q?c6cbo3xjjj4NIL+ffB1VR+chg9D6T8bXs1Sr3W581sVf3k6a49QgJCUpYxH1?=
 =?us-ascii?Q?JTSL0y+iVn/tygp8VHQPUtjIEYMv7yKYbbhUSVjh9NFybgytcdtaKVXeX1nT?=
 =?us-ascii?Q?UrRRdmqjTuVP8u5X/llT+p+rPQo9x6WyQs50Xd4PNlJhSiK46qEaZ/ZsQRdt?=
 =?us-ascii?Q?WzHIjdT3OzL+16T+cNNpBuw4UQqn3ghqbQ3RV1N+ZxFRMomUr/hP/8KfS3R2?=
 =?us-ascii?Q?5cW5FTO1IyikRlSU+wXSuFO/ryXyjnOlO8DVDnjgPSasL0/L9QKwKZSHRJda?=
 =?us-ascii?Q?b+ff1pJxjzusL9paLPM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e512f2-1f99-4108-b6b3-08ddcd40857c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2025 19:05:15.9272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNBLRbleK40FGh2k8TFQC8W8ccHWZ0ii31199y9cf0Pk4w+l1bvxqaYV40vAkEk4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF75EAF8F39
X-Stat-Signature: hniykc54xqzejqtsxw33tgsgpdhf5bc5
X-Rspamd-Queue-Id: 2038420008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753643120-333226
X-HE-Meta: U2FsdGVkX1/YO4Nx3iN+72t+XNQUJ7vkQHWZxMPEBWQXYWUxJ8wpQvWIx7GrSQMlkCCEPeEzsKywrgU639kIqhHHP/7vnkiHGKezlJIxim9J/oM04BbNRgzA6Hnit3rQFIHhZlcGmLKYlLTehiZlNku9K+kAFBsMM37VQ7jc01wnw6JE8oJiiL5aRHOCZzN3JhwBlZwz9aYdQZiCRHEUW58SsenlihU6O8Hcl/iuk0Lyf10BMwI7/pf02pyQrCDx9pvPaiOfJeNrYT3GpLo2m2ZaSK3qoxei4j2TisKX3uyzDirumFsSCTpK0R8PX7wII5A9M7L41r/OuWAxMU8e8S23hJVK6cVhZkHQK8qMH1TruTSEn9ejrg1raWlntv2rKbFClteOXhsf42hK6m+mU8bRXYRUwP0ddmItSTkTo1pAT+wxQg9TwTxH94eQFoXttee7++CG4rTIw2tBj2wURlSeCh1vQKiN1Pz5zdn2uOh0EKCzTWS9KvdGkRlB+0vFfogRHAv8BMoiIMlYwxpl4aB9lZLn6eaLGM3CWqIC2diML7vgKdG9AFWBga1XK2U5N2u9DOUUOcyyhiwhHJwULjjqFt7tRVD9jAjskHndeVmhcbdBYDn+tmbrQOK5aZuxpyWRIxxruoai5M5rUujoOIi96pjPIqwlC8NQiASgNjV3TgytSO6G4iVd6dtn3Yh27N750Ep3Fdmeq6qAD4woMB8jp8E+ZL2g+UFq4D9opOQfSZ8QusIoTHXOTNfF9sJI8tiSSBT5Yy2Dh9HRfCRddmrUJpPn+fikkcGvXDSxL8P9qoMRkkIklkbZKLSJHs7aB6r+NxXyoneZXHAa+kCP+UeblDK0q/shbBI9L4ntZ0lazgD+BTlksyeBK4+HmJXxA2t91o3NJcoQOmAIiPaMDghu0UTJHXsXAWvAFZPWHSFaY8ZMA6eduHrQo7B7e+OJcvyaSvs3iNDAY04QQii
 J0shJ96R
 oQ/St/7sjEPQvdM0vMOJAeWlsmAs015s+K9DIdbxTf/kNO4uMjBxYJTdosV+43qgCzMCti00gGOrR5Tt97J87T5f+dC8+QLDQt3FMSLzM2+8LFnso6gcQWhQGm2NqIfIlM75R6q0dWuaulgEv0u7PPtfksiKKC6oWGWaZA7lrNf12kzWTWawv2WAwFTsNnC/Yx+7/3ohpbJ9KzQTyvUMw4QYNgohIe91Szo3By2M/Qgj0dseUJPfshaMUu4HT9DDHdIl/P6BcBSuH0TXe8xlW/4HuNCagqVwcZ0x/Z/21sqbOwqXSFoCzFEa/ROzHepx+VyXWwLfU9JnpJ+cXpaXYlxPFHVleaW+NaCAUl/lraUbXv5bXPdoPWxxT6o+gwYhaKKrPVR56B7KnqWhw1Ca1Zd1CO6IXxbrSqX6lJnK8jojqrAyCxhQfUP1TvuKttyQmN6t2aWyr2xJKOHqV0iYcKdi/6ix5vgGGkHDwiT9gh3JRZeXb2LpdjDxjTXsxAjNDGkSbZqJXgUIWq3FdK4KVJ2t2uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-24 02:13, Leon Romanovsky wrote:
> > On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> >> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> Export the pci_p2pdma_map_type() function to allow external modules
> >>> and subsystems to determine the appropriate mapping type for P2PDMA
> >>> transfers between a provider and target device.
> >>
> >> External modules have no business doing this.
> > 
> > VFIO PCI code is built as module. There is no way to access PCI p2p code
> > without exporting functions in it.
> 
> The solution that would make more sense to me would be for either
> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> P2PDMA case.

This has nothing to do with dma-iommu.c, the decisions here still need
to be made even if dma-iommu.c is not compiled in.

It could be exported from the main dma code, but I think it would just
be a 1 line wrapper around the existing function? I'd rather rename
the functions and leave them in the p2pdma.c files...

Jason

