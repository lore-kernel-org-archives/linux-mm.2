Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA223CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 11:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE0B8E000B; Fri, 17 Oct 2025 07:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4DB8E0006; Fri, 17 Oct 2025 07:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3F18E000B; Fri, 17 Oct 2025 07:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7908A8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0FBE1DAF8E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:53:30 +0000 (UTC)
X-FDA: 84007446180.12.10502EE
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013043.outbound.protection.outlook.com [40.107.201.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9643140005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:53:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A4iKTKK7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760702008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27Gv78aElBuonLA+v504SMPOqjIriIvAdUy4o9f81Gc=;
	b=PXhBYkQYYYuuflZbA9luq4MAC8osrXUyE1/trOu00xXZ3ZYfc0xJD7sbEdWmindX3f4u8T
	pUicrRUC8JYR2MqKrFNfOVSZ0ZBNdn3rJnEVBmixZeo40mAd5lpG/hSNGjzWPwxNBdAwcu
	jrY48OWVBqTJ3VvENBAG0ZXxLuAa9ak=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760702008; a=rsa-sha256;
	cv=pass;
	b=uaFFH67WyW1kiIs98zmuMC3ztZiQfcMWtRvRSS5d2FPemvgM5M1MjqY+oFJrW1i3UDbDE0
	RfK2io+Op3BlgboL7aTyxSbjjoEzc2NWftxzFh5+QOGIcl7DwmFNS/kggVoYbfi1bsECO7
	u/33ZVobkAO1EN53v0KcIAuaztfaOAI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A4iKTKK7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.43 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxPmKpTdhYqVK912jz2EV+layQ+ymM+7Laai/RBcvzPyUBU6hFaN5yp0i/Tinmxibnvb7cN4x67j5XtSiN0pvi2WwNMzvqQMOhk8svGmHKUmBTrxsv0FeRFm8MhIjFdX7jwpM2PIZ+qrJ+mZibTJmvNd68yROTc1NMPZiP4kEUXjRtqEZN+XxNPgZ8hHrZ/Hqzh0XzyU5cGZfxFXE+aqCcoU3tp7UFBCbqargOdlrmoaFNX7CdIOPUiONMQJAgKO06XdJl70cJJhWnV7W9vdI3LPqqqe91ulg64sXW/fm55JNrNltDJD87Tf/N7Dj5muRdjLLA6qqE/tMapoOxRWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27Gv78aElBuonLA+v504SMPOqjIriIvAdUy4o9f81Gc=;
 b=u0xWnujkxdtYV5TWtusKVI3qt620N5+UOJmx/7Br0NJQuQXWvhiH+OnVI63svwdtwjzZB6auj4hsPGuYO9SYfZOfUXO8IJUukH8kwg8hsUNigCV8kaBgguYQ7IY8H385ml1LsQ6Z3RBoB45IA7iEYuimFnrA5HgyDWxGMx9lRcn1+xGCvvbQBAXVvcCcV43NbA3UCOaokA57Fl1zy0h/o8Z+ea0xMbcTHaumrRz1/MzTCMFN3uUUjRm9iq68cC8d/QWfFdQaHSse9afRwnIu5YiVGf5W+hAijH7w3mlliZmvL7R6cpSeZ3Hi5z2SsKb5hgFNlOhKzqwu/h1g1ZTvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27Gv78aElBuonLA+v504SMPOqjIriIvAdUy4o9f81Gc=;
 b=A4iKTKK7tXAngqVwnTTOu8yQQWoUGHbNAjfPQLSihno/ximb9W/ZMEnDkDL/eAOnPCXsupwoj1YasLr+kjh3oTbEhOwWWqunJCk04YxGCz2rqggMqGnbR9OB/H46xSY8CLQuRsKjA4myhR3lHzkc/3FkPb1EQlnSMI4/9mQEhucw9pt6thzx/EqRjoH2FVsZQTZq8jftP/nE3EdPjpMqGFZATt2p+LR7sh0caWMBCL1ISpQbokyD3yLKK0TnRgaiQVVlbY9Mv098DjMJVShbOm/890F11mKpLRreC3UQUF88gwmnTWqTut5BVJ6fUlzULdCE1rkGSpNMjjcyY+Asyw==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH8PR12MB6938.namprd12.prod.outlook.com (2603:10b6:510:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Fri, 17 Oct
 2025 11:53:23 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.010; Fri, 17 Oct 2025
 11:53:23 +0000
Date: Fri, 17 Oct 2025 08:53:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <20251017115320.GF3901471@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPHibioUFZV8Wnd1@infradead.org>
X-ClientProxiedBy: SA0PR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:806:d1::23) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH8PR12MB6938:EE_
X-MS-Office365-Filtering-Correlation-Id: 1273d5a0-8c89-47a1-46d6-08de0d73c5c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DrD+CfmFVXOn0+YsJ79duhiCv4MyocnFvbdU9CV/QtEcNt4dBlCyqdS/RPpv?=
 =?us-ascii?Q?vc+56mf3RRwie2JAXqLZBgT34zQHNkeIwqgKortSpd0MfrAd7g6a4RiSRuCH?=
 =?us-ascii?Q?4SwF1PiQRS5CU1LEJb3suc0KydakxkMDLnjAvIOQf0Ucm31BkKHId1W/iMFI?=
 =?us-ascii?Q?1bl/vSMWXEgi0VWsMocHMBB3yHeYzO7LkeRE8r3cRKrIbyK68vlYzfvIvbU2?=
 =?us-ascii?Q?9fdaMsHtDwHGrA5h0BzkYqTlV3IiP/OkMwW4+lmm2R1QlFIgqowVhYwwe1fu?=
 =?us-ascii?Q?rtY8nNflrCc/bbAEcEkfEXVXb7VMDvfvW/8jWb3dOmkZyTrkInsKjEGlX68i?=
 =?us-ascii?Q?m1vI70rq4ml1plweisGkGeC1N8ZFM37vBt4N/sNG0+Kusddf/7mk4JY02CB2?=
 =?us-ascii?Q?mkBfS7bwqu+YANMnZ070RI074ezr5pP3cTvdP195XqxGcajaki+TXBc7Trpf?=
 =?us-ascii?Q?hRNbA9yxGt7kwzOuJcsACNJRFjOqRk9tpkuDF3+03xPEPEEQBItPFspjCdxJ?=
 =?us-ascii?Q?nv5ud/oG3EZvUw6t26d9+nO59dff/+XZcO2eGIsUb2cacuj5CXrb4BxggP2j?=
 =?us-ascii?Q?EyvoS9DfknW32Tph2Y0Q/P5nG6uYEnDQ3tfRypfYaeLjvObg0FYAc5yPZ/x/?=
 =?us-ascii?Q?OBqW/sed1DleH4bNQ0a+ysb17YtdrlR4RGaZKEM3T+MiDUcTda3/dv8ijSVn?=
 =?us-ascii?Q?++OmIcmKHqXVcsS4nd8K6xAU0YPBWeS/uVfST3pYb5YUTRMErgJr4V2W44XS?=
 =?us-ascii?Q?yjHtDAy+lCpzuCbNLVk5e6RqeUTn6FviTMzZU5g/e3UgSP0B6UJnycwpyibB?=
 =?us-ascii?Q?c9luokHDFJoWHiArMZT3GVnH9Wc5m08QQO5R4azgGTWDcsJfjZeqjRiKsdUd?=
 =?us-ascii?Q?s4miRjw+uqLOhtqSpEo5tEF0HyxY8Jn8ZHrdBTEm+kfEBYLtajPm1HA7GYCi?=
 =?us-ascii?Q?Mox2WCyS58qqCrXJwTpdIoHGwN4j/U1ie8jpR2tRH3LaCv10yI1D6nOGxMo4?=
 =?us-ascii?Q?YLacXtTyR2z4GwVW1cQZCNuSKQBWn07HbDkdaEZfkv39FfuN/T0EOcxd2f01?=
 =?us-ascii?Q?FdtUorDIy8BcW1eWCUtxHRWOBY++Tq12l4isZoEScZxPBiCtbYZFfH0qpAPl?=
 =?us-ascii?Q?gHEwyUKgj03yDjumBupLkW01BjAeFUIr5yv8c2zU7/nZf7Mhw3iCszd3bq/H?=
 =?us-ascii?Q?LJqW/7SIPqC2/QrzOQPLJ2Eox+W7a9k7zCZtuz3v/BUTBRzALiBiZ5rHwQxf?=
 =?us-ascii?Q?HzlE68WQXXsKyDvUQaSlVLSaRPdG0Y9RzIao3fiY7tLtvJ8k94NCcUR6F0iq?=
 =?us-ascii?Q?Vu3D075glgB733gU30pbhwHZCLXZj1Xjrf7VNb42GaMwILxP8KLcrU9+FV01?=
 =?us-ascii?Q?2H+GBbPKAc93w1RZhRXjiS0IN7xNZDzwMNrOrOlVc2t8FgqHRK+Jjy9Qh9WW?=
 =?us-ascii?Q?YC7m5zbuDyAw1Foi4Vicrpn/DOBM99BaTJlHOYSm9FEUXJXSdGOPbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pwDyegh6YKnvSYenNn4AsR59Wj495AfmCLlFfHXvi7+HzISHrl/EMAfhwjcD?=
 =?us-ascii?Q?VOSYFnplqBtXYM9ZJq4/65zfMvDfKBI10IbpWjwSNaZng3ioAaNZV9DxV70m?=
 =?us-ascii?Q?et6yzsYCRhXkNgJklpPAr/MyU2aCyx3WJ2GXUTBT5gM84HCJL3/VMeL/9t3S?=
 =?us-ascii?Q?IU/djpwYnholsmTtWMOpgx66OIu+pHj8nKiQDLPjFDY2QLxIGd0I//jWyvpf?=
 =?us-ascii?Q?liMvDBumDrqtseaAG/fchczImzC3ddKrxTQYbkWULV88AHAxYcGj2fK4dGUo?=
 =?us-ascii?Q?YL+i4c8b48Tubip1e+JFFYlPM0bKkBT5vVh+YhO0JFrf9MtSI/1VcZxJ7NBv?=
 =?us-ascii?Q?+oOxAaYVOxXFZL8mYcR2DdrbC9q7qfb1wwDOKu/ou9fISL1slLQP7mFESqSD?=
 =?us-ascii?Q?LeAwO7DZ/1yujhrXVeA991Euok1fEhp9CWGu9uiMt68thhelrG346lmFriRl?=
 =?us-ascii?Q?E5rdYCk1XmnNzMnE6JFKD36lGWyD1atAXmQvoXmAcRIFB67FwNc7EiAnq8XD?=
 =?us-ascii?Q?f+Nb7h4kzYxmVRLAj+UydW4G5O0E1dmOJ3kp7FA49RpZOSeVRbWzFdd9KuCb?=
 =?us-ascii?Q?OKBcBJeVfkPCR8wQos/IyckLYQwNKNiyXvYa9Ss+azcPY9aAO3QBF3E8MJbW?=
 =?us-ascii?Q?tkFpwkI53QGNOBs85rDVKAjQBuasUyXUnKTM5pCK6ti9CBMnRCedkMYruEQP?=
 =?us-ascii?Q?cqQ51mOB/HgWlxjciopPMDeto3/kf6k11Z+nm8z+ZeMobb0gTLOlyYPEFamZ?=
 =?us-ascii?Q?DaMpjaH8dL6Pkx1FL9o721nGdvDYJ/KQ+eLzLUlyZToc1dNaDRvKA1iUh+KG?=
 =?us-ascii?Q?N2EXaU/VZ6bFu1RGXgMqPCIyql0kvIHON1iy1Pb0dJL8zxetzJzJNJ6IW2Ip?=
 =?us-ascii?Q?mXEKgzM0dp7tGo98EUOdvuOC5Z6FotEjI3ghsJ0vxPYK/F/3LjYYYqhskycd?=
 =?us-ascii?Q?1P/ffYCaFdGu5I1MDOThLH0CIXBhbRxX43FwlhmZkYytaf6H0gbp7n4ASED8?=
 =?us-ascii?Q?rzDMBfvmJs68R1u4WU29KCN20fvOxG65Yl1rnTJ71g9Qt9TUdSz3TzHT6Ksq?=
 =?us-ascii?Q?tKw2CkbMLmSSF0McCk4++f7pcYxiDm16KYu6Y0459q5DLwfu0NhKZKZfjYv6?=
 =?us-ascii?Q?L0GSguxqI8h+h0kcU+bYQ6Iw8uFWPQ+FU8VH3sXJDI//JUSfE05mgtN2c/ZM?=
 =?us-ascii?Q?o/ESIgCzeNTJm67tgH13udpor1vkpHpx4nNLlLIIAxUU9ixe8vagzb/l67VP?=
 =?us-ascii?Q?Z+NUTC6KiNT6+Us6oo7Fc99qtmUzI2/aqsXgXUsA1SvJSmRhLraPZy+GUtM7?=
 =?us-ascii?Q?HgFaR1XOOGEPS+Hko7RqxP5rVQzgtZ4XAaNseXJ3yUir1jaNaCpBcWgV4oxf?=
 =?us-ascii?Q?+KJiWQLachiNp6OloDMs0Xcgir9LCns1mZYR6pYvbHTvdBhFm+4BlTNB0zUq?=
 =?us-ascii?Q?Ll/X5kEyymuphogG+x8Ypli+YS602UtGwvpErLvby8GJjmK9uRxC0vjBRe24?=
 =?us-ascii?Q?2facAf2eGFUEf0bFtmmgK4UntwepQI4h9vwhmS0Q7LJcH8LOtEZyUvgOGWRe?=
 =?us-ascii?Q?ACavMyKdmaAmkBjzvqUl252r9z6xH1BVgjutKuTz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1273d5a0-8c89-47a1-46d6-08de0d73c5c5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 11:53:23.5695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhytHHPZ8320KQI8Fyy2p7tWDgsyyn9FG+N8swcrjr5Q+aWvKcn96SHnH0XWgK2y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6938
X-Rspamd-Server: rspam01
X-Stat-Signature: sto8eipimge6zuyymsn6raehr6sdzw7u
X-Rspam-User: 
X-Rspamd-Queue-Id: C9643140005
X-HE-Tag: 1760702007-853451
X-HE-Meta: U2FsdGVkX199eh7VMrhXQ9XodiH7NN9oI94iYKiO3jN3OPN4hvRZrgxXZPwhGO5UM44Xy3U5z6hE72Zf6/nu21TulBtbGgFG7Os1v81+ULR1GlCR50OyoE2jfSUh+6aO/WQz5K7iDzNiklMJKn9iB8uSYBak1FOFsIkhTlZwDKXIPimEqfy/R1WjyyQTH5JeOLeu5xE2rolZgffn2f176dYUAFwdZ0qmJkeDgODgoAvQY6o7POsFhzjMFR96pERqqc3lWuq4suBlkxqVEaAi/J6mJOUiyOW0EtG6Nmc4zt5LakdB3TWzRXXvDbNj4TX7Ke157pMGB5i3HBnfgmWBvbWfseNu1OsN8ZyuGvMwU6AJhlhuwI6ER0PzZDUSWN805qcuBjVggldpi/u+4porWxVHnfLlzGemY86Yr/Ves5iO0Hq0yklXxdBY6/gmqqnB7bhuXm+24kFx6gIpHpBD0Y/kZAOqLRClny4225w8ngLX8bGaSGCxYqsBITVlhIdjnNbdPzWp6hARnJk8jlhllE1vFEsToh5ux+6KgZze5u5Zsgxo12R6Tyz3x67DxmrDwqNGmNKK3pwdgUlCFOttG0mE0bj7A2KCHDWZqvSgYuL0lIx2YThcFryn+qIjpYqTxcHkQITwwcAsPrRtagjLQZVM8M4/DA+Gj92LfMuGRfweriT9yrPpiDl3Lv+xsIwo+PdeZbMhlxDmMNWFZ2S0RFYBRPNWNA0yt7WqNDmgj6wbE0sGpsqMqq9f+Z0eV691PgLDW0Jin8YCQn0rbx+vbK1ZSMtcTDKVCniTZF5QNIqCjNFQU1NC+WQd9vj0vS41bZ6C4AXLL8sLr09e1vwa7f2KSa+63CMrweQRXa3TxbKq8ZNhhMKupfvf3ntlr4ojmvhvL0Q1tJgXz+m1Ls63s+tzVWEwZh7aN28oniatc0rcBsP2kpkkWOS/m2LaD4NSBM91Bp4/GlOq8eK/kiN
 JdlQyTBW
 6pRkK6CBAWlEsYAB3/fVPU6DSE71QS91QAKNQzFfbAkbefwyuu2+QaKFpie2QMrUFSO5n/TbqEQnHwZ4x2Q6ciDhJI9qQg2XkKk2KenZPsRWIMn/wZqqa2TgljDWQqwDgRzPROI5DqDoATefnwp6J1uG3ZWD/jVAlIP1SF29fZp0hCQDqtYmSL0pJuniUvHYlN8B5ckMMqkRPgCBbfEg/wPWfNBHUfAdPvDB3lT2UReSB9j8lQr/gSCKX+Tsks3RxDTYeid9TWyJnXS8tPWYdxuRpfQvC2V614a3lo3hR4gAzHhArKP8rFZJKDM8WBLBfN2nVcr0oXmVOJRXY04mmOofCf6TAwZy5OK7OvkdEuPxDgfKmcW6v9L4mENVnaXkkg25nf1+MF1TdgWElTqgvBPTn4CfPAn9ttnkFtFyJFT8cZUTRqr+cibo6lx2vJFFuqyNNboLC1gccUlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 11:30:06PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> > The DMA API now has a new flow, and has gained phys_addr_t support, so
> > it no longer needs struct pages to perform P2P mapping.
> 
> That's news to me.  All the pci_p2pdma_map_state machinery is still
> based on pgmaps and thus pages.

We had this discussion already three months ago:

https://lore.kernel.org/all/20250729131502.GJ36037@nvidia.com/

These couple patches make the core pci_p2pdma_map_state machinery work
on struct p2pdma_provider, and pgmap is just one way to get a
p2pdma_provider *

The struct page paths through pgmap go page->pgmap->mem to get
p2pdma_provider.

The non-struct page paths just have a p2pdma_provider * without a
pgmap. In this series VFIO uses

+	*provider = pcim_p2pdma_provider(pdev, bar);

To get the provider for a specific BAR.

> > Lifecycle management can be delegated to the user, DMABUF for instance
> > has a suitable invalidation protocol that does not require struct page.
> 
> How?

I think I've answered this three times now - for DMABUF the DMABUF
invalidation scheme is used to control the lifetime and no DMA mapping
outlives the provider, and the provider doesn't outlive the driver.

Hotplug works fine. VFIO gets the driver removal callback, it
invalidates all the DMABUFs, refuses to re-validate them, destroys the
P2P provider, and ends its driver. There is no lifetime issue.

Obviously you cannot use the new p2provider mechanism without some
kind of protection against use after hot unplug, but it doesn't have
to be struct page based.

For VFIO the invalidation scheme is linked to dma_buf_move_notify(),
for instance the hotunplug case goes:

static const struct vfio_device_ops vfio_pci_ops = {
   .close_device	= vfio_pci_core_close_device,

	vfio_pci_dma_buf_cleanup(vdev);

		dma_buf_move_notify(priv->dmabuf);

And then if we follow that into an importer like RDMA:

static struct dma_buf_attach_ops mlx5_ib_dmabuf_attach_ops = {
   .move_notify = mlx5_ib_dmabuf_invalidate_cb,

	mlx5r_umr_update_mr_pas(mr, MLX5_IB_UPD_XLT_ZAP);
	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
	
	    dma_buf_unmap_attachment(umem_dmabuf->attach, umem_dmabuf->sgt,
				 DMA_BIDIRECTIONAL);
               vfio_pci_dma_buf_unmap()

XLT_ZAP tells the HW to stop doing DMA and the unmap_pages -> 
unmap_attachment -> vfio_pci_dma_buf_unmap()
flow will tear down the DMA API mapping and remove it from the
IOMMU. All of this happens before device_driver remove completes.

There is no lifecycle issue here and we don't need pgmap to solve a
livecycle problem or to help find the p2pdma_provider.

Jason

