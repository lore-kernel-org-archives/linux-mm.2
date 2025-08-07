Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33444C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEF56B00BD; Thu,  7 Aug 2025 08:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE4D6B00BE; Thu,  7 Aug 2025 08:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F236B00BF; Thu,  7 Aug 2025 08:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84C7A6B00BD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:13:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 078595C626
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:13:36 +0000 (UTC)
X-FDA: 83749852032.30.0225895
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 27A5440007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:13:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YZbvDWhX;
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 40.107.95.73 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnd91fTvUuf7SAXkMx8PwNrI+Ba1V4Exo/CmbUm1lhI=;
	b=0bsGU7m+9S48BGbSTEpj+YeopXBDVf8yjwl6tln5/JHOH1uJjQGTR6wrGrcYg81zKrKFFt
	HdhuQ6nrkLUnS8xmD11w4FAdqK6Iu04NgOeDOWjv/0aRo8WsEhoIxgsA9MSs6KzFcUgsEU
	HNVoWFCeoL1XLoUBO6j77nskDsBlG8U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754568813; a=rsa-sha256;
	cv=pass;
	b=yoquvEG+EFJJ8pICf0dEn/q26wzlpb9gPu+VTYLJgLlHgWB1u4F8c1dHtG75sxQI67h2tR
	bDAHY/EobwZWcN4kehqWG3P3qyiTNYB0OX8O7HbeyS9lQIhAlIh7Ta7aOs0HfJu9ood8Im
	PMdeRm6xdmQ7P1Ajg0VZKL8rzU4h26E=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YZbvDWhX;
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 40.107.95.73 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uxP7Pf0ykg70ESQ1qsMAV46ciw3fMetV5ptq9znpdyVeKuYe0CQx684fgoNYUFgJzPJn3+4lFMQwUMWJvnCER9DzlnAjzb7VOcXipnWlrp5Rw4Grsy1HtLACWH7J3Ed33vP8gXCUoLzgPGe3gtIlOAC4O9FyyR/easgliZtJvaFKrNxs0m6aavuCs6iAlt+gGerYf/zavPmSkkgZFgCQ44WhhSIATvspnXnSyxfWAQHaNOTZ/HVPTzz4GEdkjnqvf3kCRPTfrhReWfvFs/DVv4N8LeoSaEhRlihVFXR5bJsdoCD3YcCry8KRM0MFz2+8xSTiZh8WgrQMoUuWsJghuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnd91fTvUuf7SAXkMx8PwNrI+Ba1V4Exo/CmbUm1lhI=;
 b=DmkWUqr9j/Xt1cx/er4RxEftmeONbyeBlY6MYlI9tO6ARDn5qDSq+BE9Rn6KcWTUtkkb06gl26cXmkAlhgowChbxbNfVNKTy6XpUC+DUrHUQ+0ALoktpQmGEx9h5Jh/MukgoYpDzNR/5nD0yI9VF60sAHH9yWSOkMUkrJtsgmEW0AGhr4D7rU5U5OiAfYq7p2Pxf94PFeDtWgTKLn6MvCrf0TyKJwv1xON/D9VEEvWA2ZXuhJbeOnUXdnd63ZCwbhDaxa9qWeUGDfLQYoiGD9vb0uZnbPYHLCim+AOmlGJkL5fz5bLkUcnXmDXqyf6XULntQ+lPLJG0oRnpY7ip/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnd91fTvUuf7SAXkMx8PwNrI+Ba1V4Exo/CmbUm1lhI=;
 b=YZbvDWhXqTABMlt291caIizhKaSFiEKa8rVjOU3j280z6lSSTUTJ9gkgrtbIKNjUrsQvbdgFNoPEl13biMjDnb4IKjqKu+Q6E3Bleyj+Yk8eimX7s07c03eMIRq2ryn00DPvA/mIj1geQ3WKROV5Z+OW7NgNIuSOk0X6VcbxBaIJR+poit62h0A9cFE5RF2wZFG08zqqFKdKQwwvFcceqJezuBLK6X6H3oe+sXA5PM0zi8rUei9xWP+PpGM9HiEGTjuU9B5IotuPd9YVh5NfHW9i9u3G7QmQXRMmGYrmQ44zqlJN8/skK8wix4cQd7GI0arZ4735+Q1zxixJIIixwg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BN7PPFD3499E3E3.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Thu, 7 Aug
 2025 12:13:29 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.017; Thu, 7 Aug 2025
 12:13:28 +0000
Date: Thu, 7 Aug 2025 09:13:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 07/16] dma-mapping: convert dma_direct_*map_page to be
 phys_addr_t based
Message-ID: <20250807121327.GG184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <882499bb37bf4af3dece27d9f791a8982ca4c6a7.1754292567.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <882499bb37bf4af3dece27d9f791a8982ca4c6a7.1754292567.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BN7PPFD3499E3E3:EE_
X-MS-Office365-Filtering-Correlation-Id: b942e929-cfed-4d71-c440-08ddd5abd12a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?axQI8w3VTYtQ5YUSriFu37Q7Ie+PYZ1H4KfTCwRvIpV2kxnY4WC0YXxwLc1M?=
 =?us-ascii?Q?cbMTZRNxCHmOYBy5eTk52kQcR31cLIJacQ+oXZItONC2qt8u2Zu8XIJNpKYr?=
 =?us-ascii?Q?gu0kM7eFZBqOmCJQMScmVxYvkdyFq79o4+asu8uQDBXWpOhKtiTBQ4/5tisb?=
 =?us-ascii?Q?TO1gXmomGnQiCfyhlPKtWUjJWhQFhbqJDXXQEb3XWHf/uds0D1iTj/UUfTfT?=
 =?us-ascii?Q?if/OFKTceOGBXABPR2sFkNv//ZgV2MuYpq373lJwhLmT7LvdSvITw7Dk2TGy?=
 =?us-ascii?Q?zrT16KfExdJ2dogIykgnTAacqFY1GdiloP2yb0mh474ah2q2SWdgy7WGw56y?=
 =?us-ascii?Q?2hDMDaoXNB3+7EJdT+gGGfxan1J9eE3SSZpEo0EAs6iyCvoI3QrsvESzekkS?=
 =?us-ascii?Q?Aq7Ug3SwekNtJvi+h6bEL0HyQL+JO/O8bldy5RAm1U/dSFLxkdFjeooWdhYe?=
 =?us-ascii?Q?bsYjfJ85QBDGi2fzHQKsyoc+8L/rjQmO4svE02zb+8+LABJUkebPFUebZH0I?=
 =?us-ascii?Q?RaDVIVl/B14xPSGwhWIYPkTEYyivT81KwaS91QGcBD25zmAdikz33Xft6bZG?=
 =?us-ascii?Q?lPh0lyooYx8G3l473Bil1oyinXnaB4sWZuy1DuAfZc7o826PRCYqdq4zxy4+?=
 =?us-ascii?Q?kakjsFfEC8Q0qAslgBVUSC6LoRUCk4p3B1HdvZwO0gfQDCkRDJ6lDNgik6cv?=
 =?us-ascii?Q?XDTb3ChTUb/fRynp/7buwxi1ugxtNgbvZGGNnWrl1GWsbsVqsO3F8cTZ4JQt?=
 =?us-ascii?Q?LQu1jS1XNfr+rUCIIuFUrC+qBrsiGSKD1t6zrfaZoQPSEc8PhdmMm4p+nRZH?=
 =?us-ascii?Q?H1094+/bDuXMoCLANgKLaSAIMQF4CdpfEz5LCMQQ68jx8nHrihoK9p4X5P6N?=
 =?us-ascii?Q?jYpsBOBpHVl5lnq75bAXGnoxZ+uw10nHH6iZe7u4kX6ZlfssoZpvdBeyOLnz?=
 =?us-ascii?Q?LtjWmFRu+Jwk/g7XO5D5WQpheth6vm2ElRzni/9d5HHtp5/ZvhjMHcRN6mHO?=
 =?us-ascii?Q?XZBM3ZKiRWuguOnnNngbUY+rO25Z9arZGX/fxnWQ0lIDiw1GOnI7cb5+6ize?=
 =?us-ascii?Q?ZgPXdY/RjlkuwK6Lt6Aox/weShKvRTQB0gf4y/pOw05Ap8GqILFVIk2/dJtH?=
 =?us-ascii?Q?Y8w/rhmP3vMiGMj9PY7cp7p7qb7AZwv8Y2iUTT35R0oTZqCWjpSaTMKH9Nkp?=
 =?us-ascii?Q?bm42bCC9tIArDMLClNbzTHTMKgXi6ZAsJ9/EfCNcg/zNrt0Nul9w6IPKXUyb?=
 =?us-ascii?Q?tM4cmLojMMemwoIaszqe3F0CSUcrb0IzTggrtqUXEAhejPywCBf/Fh+xQYZt?=
 =?us-ascii?Q?E7BC9VeEIfL0ULEsFpq4P1uOG3YGqtIBIlelb5DP6eG6iWO8gPgwPANOHhAb?=
 =?us-ascii?Q?MWaRKqhUyPwrvIdGvNHer0wFh1IBVHE3vsFURjhpYB//6MHcm1cqYt2l9dgN?=
 =?us-ascii?Q?uM/ptoUdCi8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sR6OLO7WGVDrwfr9yuQJ+2KW/03YjBHbOxYbGMYOMCZYOWwxQoNDiL2pKIBU?=
 =?us-ascii?Q?hdkr7lEhol4n7NuO50U7v2uTIhbvOWPEQDMioCAWwI5WQ+BE/3msfWyjn31f?=
 =?us-ascii?Q?x3BGFqLNyI27rcfQLAUyUJHgLOFy0VsbZNJvK91B/cFod3Qf9hYYmBV5YKIt?=
 =?us-ascii?Q?rtVCIS0Ssf3y2Mt+NT5/um6iIc7xBaLkA9NCGFuWfqdHRLjD1VNKw4VXR89R?=
 =?us-ascii?Q?xUOuHBnZotMvkW+kxl9yx7S5XFzhtHlJUdnn2SGKzg5VtU7MsLR3dmI0I9qi?=
 =?us-ascii?Q?qeyHePnBc1XYOGm9LIS716SdiU4ZxVX3i0CmQRym1jcMjuKbyhmH5lUi+FHh?=
 =?us-ascii?Q?uhcbgVzRk7Yg1oR/UqFmRv5fhMBqtAEQq6oJ/tjnZHZFTaRRSDsBfE6fN6NE?=
 =?us-ascii?Q?JKctD2IVBqmaZaHCZRmRzgY1bCzFAueOU6do0G3DAp0/enFSV38HI2OZwZF0?=
 =?us-ascii?Q?SOMIQDdX2Efk8Fwlq3FWMITrXSexSeNHuIi5BnLIXSciAOvKAl3vOP/E3j8Q?=
 =?us-ascii?Q?wYTJJ8sGYGHkhpJ3gv8U6ac64gsoWuWdxKlcf2SiBpHebo3B4IAAzNDVWdIv?=
 =?us-ascii?Q?m9fnfBAtoOQGLt82yRP692KRPCQ+LkLMKn9Njq0KJWwTH8dBJ97Y8czAFS0M?=
 =?us-ascii?Q?d1ciS4Ip6i3DlQs542nVxucomToNBgLMN+JXvkOXTrJirQ+nCgoX3ykqu88b?=
 =?us-ascii?Q?RLcE/JY4nR3HrwLzy5YeXeM47gnfdbZwTpvyitRb2GfXGxn2Hk9uS7EnE4RN?=
 =?us-ascii?Q?x2MbostRNOUsHQVsnUtiSKT9/bpO+lScdGXvK+8hYcE3wypOuw3J4Q+FbMxP?=
 =?us-ascii?Q?bxeB+Ulqhl+1nXeAOfJaksQCBo1N9XCSbg/Tnq3nEXm2O+Tb2neq/mKopK+F?=
 =?us-ascii?Q?oKl+oXuS0TcMkLo/SMlBkaWMsClLVblgaVuhVGUIeQ07K+p7HSHOLTw+Rq03?=
 =?us-ascii?Q?NI1xJUEg9MBat+O3XeFBTbsf/WCudMezEwerfinT/opXWjlz7IchRHWWmm8S?=
 =?us-ascii?Q?bf/No0jewWT9JekdbUbxOp1MwITG05L/7/4XB7uSinax4/JiPV6DFvIFfFio?=
 =?us-ascii?Q?J6UR/vOAto95/JmCKTKcJ75TwpY+W0sPkMqL6S1uXILQWYkNhTbfw5ZN0JsS?=
 =?us-ascii?Q?rPepZ9+uT0ggzsogxf8f88ruPBm6yxFrr9/BZQRlLR/i+lKSnmm1bhlDQJ77?=
 =?us-ascii?Q?hsP3bc3vIpXfuixt+PZTiZYIU+cPc4E6h+mwwY+hjCEwKw8pf5W7Hk/rkJQV?=
 =?us-ascii?Q?FF8V0Ynr39av9YDx+D6kS59laa1QOn4cc80bgCG0lnCGNf0fo4BHjy9EOOab?=
 =?us-ascii?Q?1xtwoH1thASYwHssKN6HWrkfUXlzgk8Zz8LFFvntBeE2dH0lgaXNOMV5j2Se?=
 =?us-ascii?Q?ZbE5hA7pfDc0PavMHn29DccR3V/EeR10JgW2CQyK9o5L2ZP+0BTd0j5Ap1aj?=
 =?us-ascii?Q?VxFJSMoyvW6BiFVDB41ontdUjBXvFTPLQyKwQ0mUYVZDQ0IrJ++4PecmR3QV?=
 =?us-ascii?Q?AOjinVp4kbGo9305fabp1UsvUHAZHAVfK1uzEXRGyTKhD+3Hc7TYU1wS+QSw?=
 =?us-ascii?Q?DPs8HyXYZOpmOcM60GA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b942e929-cfed-4d71-c440-08ddd5abd12a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 12:13:28.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KROhXLqGII19t1me5Y8/lT8ezU6d/PVXc3lHTLvPLyrmNmHxaDMV+xvImfEg9mk1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFD3499E3E3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27A5440007
X-Stat-Signature: ynqxg9roz7shp5da3eh1hroh7u9woxn9
X-Rspam-User: 
X-HE-Tag: 1754568812-158659
X-HE-Meta: U2FsdGVkX183LpMn81kXHCF+BAT8vCVJbOW4T2VYMr7v4++9SYnIggSApftyKsFXFhvX4/9hOJUPT3Zu7a7WRmXFVBcIvcMN1wIMn6mmBJ+dP+rzeZv27rQP9AaXwqxOxB89DibIFwvY++qbVoy/D4Tb8niRgoYvE7oMf6XDOO57W+7K6IJZ6bIcQfJU1jTHeVIFRU5U6/rTV2lcwBW2OGSumfrxnHvB59V3MFSw/+kHvBJEVAYmCFSFqkUuxp/a9Aa6+aUlsV03hM+JGzyIH1Wh7/7fpTjE/A08qR0leBxOTDjTD6ruIvz0EOTefyQIK7SnxLY+934UwAZ+nUFyEheAgKIojMSPywEQPJ6jJzXbZ8d/4+moDMnFO3V/Z95sR5gp6zmqWLnvrMl+PqPP4aKe5T7IZtr7z7cyN+b3bBXcZkOXgqU62bJFugc3ZEBx/Lsc4GG8GpG1vfiJ5bXSnaV2nOa/nBxSg5flWPU7Ez9cIj9+4Lo8id4j2Pym34dZ31Yu0oMknxtSyn975KBJI471DOU+fUirpLyWUam7qH0wdoW4W2UVykjzHojPdEuVFhpxehj3FM8uGymsBEiL92gUOS5u7BfivSmivj4LSVnWRi5uecv1jD6ngzjCNjcipya9MZHyFY8xIQ3JvCgabEy5aZV8LxEMJPjf/OlkxrHiLeuE62X//5WqHONAiWdS5dLfUH9UgJuU+5Q1SqAF+PWcvfAP9u0wyBYwFtCMxEMAP6XLmsOiYzZ2/BH3gwthPDkAsmoakRvh6mbvaawrd5pL6GmxXLTZlz6t0JhX3wdTbthBrsBiP1nxGTO7hVZNqQFMwbMiEaXdFCKd3eKIkh/6YGrm1LuZe8+Q7m9OEo/bscf/J/cHIo5yq6JCoTIFscAcpBybMV4RT4w5f+EO8HLnZZ71FeZQnafP0u0tYH8DtERZS2Zcp1wdG0lzcfN4B06GtiZn0/sBqgwSSta
 1jRLgXF3
 TFMWXsueXofBJXR36sx/gMxUrP4HcvN9h5L9hrrCkKkbKGdYZTtefBL5a+TQeGAi92E9OkjgcdhaiVlSR3TTzAxpzqGddHuPHcb8P4F6AU7Ffe/aBk9yjMzLlESG/kJteCGJC26DOc8v2CRmzLZ2kcybQyVcZSy8JR3w6OWHlOo3bHz62FLjEnpld84ZJyh9rjDzScfikz8o2HTfrSeGyZ4TDylqf8XLbuJur/XoBf/Vl2P5ObD2fg0PbGHOL17mqJbRHd9lpd2glmCZhqtCl2v6PIBusVIfvqOd3QAKdsa670ugSlx5lzR/U5DZF4zUk+oVLHohNwHWnCuxDsa+cmU/4ZRqTqJ3FevFjKOqU3EVoZgoZehTn8oKrcN7plVeKZcKADyfQWENLoJk24GW1ZERn34xNT9OeMvpmryw3puW1EWpYQO1wMYfFZ+0dyzdDYeaYtdwU66D0QXtC1BZ1miJMO+xUUgh60iQHWSjosgF1Ae5I6y7353NDt9Jw4vbrZ946LHoLopB1d1HQ1toyZVgeyXmV7uNmHdrNSl0kWwEBGi0UiHKwCiLFeUcThHVh/9cZKKkXxyixIaiyiyKaVBO9PEdUrhaYp1+LTihASJXAkZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 03:42:41PM +0300, Leon Romanovsky wrote:
> --- a/kernel/dma/direct.h
> +++ b/kernel/dma/direct.h
> @@ -80,42 +80,54 @@ static inline void dma_direct_sync_single_for_cpu(struct device *dev,
>  		arch_dma_mark_clean(paddr, size);
>  }
>  
> -static inline dma_addr_t dma_direct_map_page(struct device *dev,
> -		struct page *page, unsigned long offset, size_t size,
> -		enum dma_data_direction dir, unsigned long attrs)
> +static inline dma_addr_t dma_direct_map_phys(struct device *dev,
> +		phys_addr_t phys, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs)
>  {
> -	phys_addr_t phys = page_to_phys(page) + offset;
> -	dma_addr_t dma_addr = phys_to_dma(dev, phys);
> +	bool is_mmio = attrs & DMA_ATTR_MMIO;
> +	dma_addr_t dma_addr;
> +	bool capable;
> +
> +	dma_addr = (is_mmio) ? phys : phys_to_dma(dev, phys);
> +	capable = dma_capable(dev, dma_addr, size, is_mmio);
> +	if (is_mmio) {
> +	       if (unlikely(!capable))
> +		       goto err_overflow;
> +	       return dma_addr;

Similar remark here, shouldn't we be checking swiotlb things for
ATTR_MMIO and failing if swiotlb is needed?

> -	if (is_swiotlb_force_bounce(dev)) {
> -		if (is_pci_p2pdma_page(page))
> -			return DMA_MAPPING_ERROR;

This

> -	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
> -	    dma_kmalloc_needs_bounce(dev, size, dir)) {
> -		if (is_pci_p2pdma_page(page))
> -			return DMA_MAPPING_ERROR;

And this

Jason

