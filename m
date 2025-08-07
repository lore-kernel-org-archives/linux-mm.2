Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83273C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 13:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21B18E0006; Thu,  7 Aug 2025 09:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1968E0002; Thu,  7 Aug 2025 09:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9723D8E0006; Thu,  7 Aug 2025 09:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 863CE8E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:38:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BD13140DB5
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:38:56 +0000 (UTC)
X-FDA: 83750067072.19.82AFB78
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	by imf18.hostedemail.com (Postfix) with ESMTP id 677B21C000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:38:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bf0mhOSD;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.60 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754573933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54Px3zvYf4CuEyxVRynpi6iF48N3mew5kEum4tnD5v0=;
	b=hL2SDGFlgrj5RpAmZ9U4bPl8T+PN/5rVBk86jUrjCuLgJGQRsT9yNn4HLRmpT1/IwiFCYV
	VFSlYOsorsz3e7tvKA4lHYHXK38lDhATKvVdCbvF6oh/WGjastTjgKSPRqeUoZ09kh2I8A
	M5V99u9c49kLQLdBZhqhS8YGamXpvwI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754573933; a=rsa-sha256;
	cv=pass;
	b=NR79ntdLN70K9sQKaIFK1vSSY1rkT6xf3UAnd2G10sn+gR33l76Ydlt1+g6HUVbCHZMhBh
	u4WwJD2O/gH50gFKIsKx+swzM+iwCwgiBPysG5WZ1eTI+smfCe97naMrGMMGIpPZPkZmV/
	aQcBLLSZHB3qkEVafEaGfg7NUaxWWT4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bf0mhOSD;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.60 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odOtssjFOkCHYaLHQ+/p9kfwL3oWQqyiWiKZLpw7XJiF0foKdV34qpOhsa1iNCspSxVdxU4gA0WIItvoFQ9sRtdvvhlbhXyTBk5Ca0RXJ3RlP78IzX7daEYxP+3DERHoiEVZUq6MhT6APGT5uklKHYQGIFquSh71x2Puus3T4i8nJPnglcxkCDj+8H6wruHDXuIIsoc9Tm1p4FS/4NhFdVpTORh7rLv1w8bBVZVxzJvWspW37QJRE8JbsVFRKO7JzmyP7iBHI65AgMr19mjmpCkS4hgxSVfHwg581jbnkd35C/EEQ7HPbqjeAMv/llJMdnXVlbhEQw0Qywxz9wytHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54Px3zvYf4CuEyxVRynpi6iF48N3mew5kEum4tnD5v0=;
 b=WHGqL+evN1vHpZ7qbQ6RVVDVkvnpn9fYJEwlKcNw2tuS3UHw/cekUJCZobaYpQw5oT7ZwdVyQKnVpTVWm91I3/g6uByftqmmGJajARVQMwsOO9dqOj08ynUXbkUqDt6SJ5/gtWuR9mLD8+eLzSM5/PNlgbOjQw+WTLl9Q+Wilktn4nmyWf4bk60zuNCZL/pFTfeMO+nffuX/AI27zQBaZMKSFQQb2GELkui8GmIZSdjYczrggAtJANFiIiV2RKlxQg+TV+OCwfC3kU1vxB88biOmpAblynNudTd1fLMHTUoWJN7e0avj0G1kzWej0DCDpJG7TOjvkxlpUnW+JZo5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54Px3zvYf4CuEyxVRynpi6iF48N3mew5kEum4tnD5v0=;
 b=Bf0mhOSD+JdgReLtcb1INqB0/uyZWs8MTJetWOhSwa3/PLkVmbmv/hM6Jl3dg3NDMwPrsdDM/AlzyEUrUBURHkACZ6cjHLXiooKnG2YMGnzXwkRRzEcBCBNXbcVCGh58e12vxDNvxaaYSD3/bhb5e9s0aMvTNDZ9mGcWTWp5Z0O13GK0Lzmffv4MQJjFCGVLtyoFeRFT2sBeSM6zy6Jvlf/218RHAdsr+LCFfAT+PZAJJKhqdojdp/MgjqxqGvZgP7XN2ZxopR4zMA620B+mgkDwCkQXS11WIz7ZuvEqkQWL/b9jGOLORKloIcURxJ7DSXvoNKuXdOWI1COqBddbww==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8768.namprd12.prod.outlook.com (2603:10b6:8:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Thu, 7 Aug
 2025 13:38:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.017; Thu, 7 Aug 2025
 13:38:49 +0000
Date: Thu, 7 Aug 2025 10:38:48 -0300
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
Subject: Re: [PATCH v1 11/16] dma-mapping: export new dma_*map_phys()
 interface
Message-ID: <20250807133848.GL184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <b96c639433d3b614288be4b305ecba3a9fb2c00f.1754292567.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b96c639433d3b614288be4b305ecba3a9fb2c00f.1754292567.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0497.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c6203ba-7b89-4eee-7a5d-08ddd5b7bd5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AMKVoTshkoWihCrrnOUvbEbK3Gi7aXCYIDForZBGpYKryA4uJRbN0UDpbFTN?=
 =?us-ascii?Q?H/nr1xjNK0yCSTAH2/3voqKzqcPQ8JjFMyfvCCv2aMnvNbHTA33B63muGzmW?=
 =?us-ascii?Q?5DuQYeQkxu9Uw2xN2G18A8DecvYxjTEqqa7EJ52Dz0bjjAPXvhQ6AbLFGWBo?=
 =?us-ascii?Q?59GavV3fO9HNdDxXcrP+paneiJa1nxYzUrzHDIscVuUyHiCjrFZNgOHhDikR?=
 =?us-ascii?Q?7wcVcGvgI+hCp9HjXxKQW7tGN8V0FZgKJ/bqXmnsX/x5N/3zlk0pVa9FtJCH?=
 =?us-ascii?Q?CLPxOt79JdMBCRMDwcNL4hI95vmDbD6/mce+8brYWOpRzcZnRWyO0Z5vCBGI?=
 =?us-ascii?Q?JDKz/8pIG7Vb3fuJmFMrtI+6ePyGKdAZgWpMJplKOpaDdL8hONs1XFxGY7VF?=
 =?us-ascii?Q?svLNjoB5HWfHueL7yuniD8+OFfjxkYeo06UE1BdxGED3DIddzKnkvCsYbmy2?=
 =?us-ascii?Q?VVwT75RYTyr6y5rIgz8ZLeboijTMVYkuysX3l8Ek+VqpZpozDcvGgOwi5WrW?=
 =?us-ascii?Q?TLv867KYTn5yifskzFshdlklW2WRDN6LKSXpACxyJQaInAZ5DaBuhGWJmIoI?=
 =?us-ascii?Q?DaBEtwnyLGOS/S1BvFNEUiuqy0i++7tiaJLQxVzGHrqb1qEGEukHyzAMHjZi?=
 =?us-ascii?Q?TDdil9vH++NAqfwB+u16QWc/W04KAsYHH0kgRD1OlGGP4AQ/OWmGu2I69nP3?=
 =?us-ascii?Q?IeWJNgKGb2zPeCIR5L77759PtmgLjN9ZhwxCfwgEgrCcd6CywpMAD2pVM8hu?=
 =?us-ascii?Q?3mZVa0GoXXJgLkCn2cznn+Rk7DSN3JZxQZRyFAC7E5crCHy/caMXV0IW6cKu?=
 =?us-ascii?Q?u34KX7iKGK8KAze/O4LNUcsx+v3h1RnDfd/N/Rou0rM+Z5viJS4XumBIE1Jz?=
 =?us-ascii?Q?SzYPcu8cpkdfVKdtTBdSm0oGs3ugExQh0AgyzrygW3AI/wEbU+hmjREG4iGS?=
 =?us-ascii?Q?qtmNR6urQDwKamP16/n/ls1+o0YkvBPAuhiwtpUP9HOlaORcZB3FN29xVU1v?=
 =?us-ascii?Q?TqXUAq7QjNtdswDx9oAvbvt/vTce4GRKf/wneoIZAVvOjUckgyP6SfE/Y193?=
 =?us-ascii?Q?jwhYRGUwASumZDJM62eTSJoZUQEb7/X0M+i1nPjqPkJP33D4vu3NtK94/gKB?=
 =?us-ascii?Q?wGakF67m/iwQtk5r07m1A/AtX6+j5UjwVztZ34j7mNl+c1EeLAnYfnmrB7aw?=
 =?us-ascii?Q?sJwNviOQtRPsQfeJqQ/GG5CFr4zbQt7E0hoxpBm9rXEMb8O7/x3Nu0rM+YS6?=
 =?us-ascii?Q?rxP5rXjWZsJa9uzk+4HAdEq4C3vazwpTl7fBeNJsDiScIPUUvpC5+7OteGZ3?=
 =?us-ascii?Q?pM8bimM2DTTDvatW94F9tddt+JSq7lKAKgOsbF3YH0ARnXa7VuNBAwsbNsbU?=
 =?us-ascii?Q?Kt8K+jvchAm+kmGcMUFNcXaGLGeT2VGjqdTOqFq/nWWV8fszgKi6LZ8x6BWB?=
 =?us-ascii?Q?oJRmbUVR0z0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MBPINjYfPGiE5jDtZnc+kL6Tem1DGVvWnnr4IAqOJ3QqDGwGQYyBqSEdaTWv?=
 =?us-ascii?Q?rCrkX2y/Sk4d6j61UbByvUXt3nKTkD+MeO8cPgtXL/XPX2sGtHrb8gNrSr/u?=
 =?us-ascii?Q?OEKNTVQZ7CHsvHCdnd9X5FXuoX0i/hrhFXJMhY5OxAO2m5eI/uVKfnRhtNME?=
 =?us-ascii?Q?WfPPxcc0BXNl1H77XG1bbVfLl4VNWDgxX70H0hEofaU4W5E3P1swLrZW9mdQ?=
 =?us-ascii?Q?Feukc/5DifHe2SePpUv2EKDGC4VLP8K0ep5Ci+eTGyK2EaR19DpqUB7DqHVw?=
 =?us-ascii?Q?ocoo7Xx2dFbyGGwWrbx8IanAzYUqZ6w3V2/BwdDcAbpOYtPMk++ubsPaWkJS?=
 =?us-ascii?Q?86KBb6LCEKOCBbnz91YiL8E+jtdRHZk0nVLho1rNXZKq6wB0lX7GySKFPJYi?=
 =?us-ascii?Q?4omNcGV34wSS0K+GJyD46PR/zDcAmDow1riE3YHKDXpojGGSfyFt7iU3pvfH?=
 =?us-ascii?Q?wc8uUrVB+XPvmrMfTcW6f6GhHRWWtb4Dv4kTaBpvPOa+uihaAGvn0nj+7oA0?=
 =?us-ascii?Q?lH1msGlh5aLcnLykZ0KM2VqWGkDwK1aa8TxDl0T7g19lHp/PkCYYEyI4Oydg?=
 =?us-ascii?Q?x36u5MNNY4csSkfMtShIOKMjAXTOfgsV3noFPXKv7GWBj4G63jQRQy7KIztY?=
 =?us-ascii?Q?iPkXT0BhYBwhfcaZNLxAMZv/8/Vpu40Cz3B5loET0MoCiijmOSqhjQdf7GwW?=
 =?us-ascii?Q?D35UMZoK5FjnyeDHRoCkY78/CsRcdqBbRu0V6nzyYh7xTVf8SEmvcU4/IM9+?=
 =?us-ascii?Q?3LW+QVoPsOUarqzKeGJeU5AoFMb/rluC1yy28WSJumduJKF/GZW2yw51wFAB?=
 =?us-ascii?Q?AX9Y4SJw5BaOn58fwEy4isBeUtWN43pvqqdfGWTuVGltm4QnzrrRrmFYQxzo?=
 =?us-ascii?Q?YCfQhh0zaLBvD0u0iYz56hPKffO19tDiR+lPXZxIpIVEszLomukhAvwhOJUW?=
 =?us-ascii?Q?Mw+9j/MEH0hp09oZ3t8tmTi9yYBa4OvVYhtPBCu7s0rvRmL1yCnVTkTlJvQ5?=
 =?us-ascii?Q?l3+N6jLtVsMz+54ZIPO8T0dp0FSwyKmeiM2I57nUM+9+kei6xaLYl/nsyMcS?=
 =?us-ascii?Q?lFDpa4criGr7VWHlF9ecZdlmf8lRoqzbwaY2QJALFxY+Yy8lXP2jKXIhGrlI?=
 =?us-ascii?Q?nsR1LN7f5+rqLOuMwqDQX4KgxOZc2rBg31tXp98jmNTtVA0VPrwb7rTxuXnP?=
 =?us-ascii?Q?K7xw5frFaQTc7Tm/sId0dEa4GdyvSh4TxEDupjoJUpbOPfqqUDwiCgIA8VCG?=
 =?us-ascii?Q?qGb3DHiGYlIQyyN5h8MRnLL5ilAlfSWqxXHhjp5U3+BnT323tDZHc4o4W3Hr?=
 =?us-ascii?Q?xKkMQNzUFeKjJZjncuQgF/AamcRWrEHt26fXixwlZVz+XJNC3GEHrBc+Ri4r?=
 =?us-ascii?Q?0+lMkCA/HXc2Shv8z27rCCJ46nrnGEQEFheADapJYipY4Mc0WWth2NBJ4r/t?=
 =?us-ascii?Q?SM90I4M3q/2GCRG7KRKfbnaRI5P/PHGCBgNBYW/YrXQ62mQggCHMTmkRy/6E?=
 =?us-ascii?Q?aahjgO1NFxrLDGTYgcHOkgZKuqC/j4pfzuZPIHHd7UDLyQf/J9B+7fmCNSfu?=
 =?us-ascii?Q?sxifWglQ0mC+PDduUgw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6203ba-7b89-4eee-7a5d-08ddd5b7bd5f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 13:38:49.1750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONwX7mHa1EuCmMcNdBKJGTu1Z2nQrZWEhwSNbSygKKjIuQb9Rcj66qSQFOkzaU9W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8768
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 677B21C000C
X-Stat-Signature: g47ecbhnhd7uk3attdxtg3b9k4ymhddx
X-Rspam-User: 
X-HE-Tag: 1754573933-692779
X-HE-Meta: U2FsdGVkX192K5h0DmeFQB92/ydql0wOWBORlGVeS4Qz7DjuHk0/L9J1en8axu292aJdmRS4zTr5oGy1KnPmSYb2toc2RwCmsXGqX4Z7Ak8Or26Sc8al2bLm0G1UvypMboRZcrFi12ZhC0RwzrOeU/giPIYIC1Dyi9rfriiaZC49LKkmBL5ySTX29ph/FUNMjVWyPW2cXFFYey54TJhJDSd/GHtTPRSwATej+oTgevCqFMeDULyQjMFa7Cb6MHpFfula/F0WXjim1NNvyQqWHczfozQ1KmC6KLEMVxBdDPZZ7MoOImcP1PmZMNhEnvtphnjbzTMNRJ6xmt1FSN4YoXRG/UWaDBoXdLQpTL4cBLAw9u6N5z1BNO4fRwC5JKnWUXJIBElcnWjSY6w7JhTKcWpjKSQn0HXS68gWtI0sQ2KmI1gb2ioDjvM65q/NWyL9GRx2MGZE959r0HFJroE0/yai0vIE6u12Zi5cKAcGHMdy8EveOpBsolOkYVSj/f6VYtJRckPaAiLA5uEcJkG4Nyvv/zpOJOUTnzOzL5DUngI4PNY26t7HIYbr0wAjbBWoGCbDA0vfdL/HcU/9316jbyIoAJILq0L6OdNY1ymRHACNcdm4sOfEYf2GvKrt5ue4/RBaWpP2EfQpzBoBbkjWVnU5klHUjBSCdTHJ0PYZarPLtq1k5OsnYTGV4Vg9f+WS/xwKBtVDhPFh+pHMx+bYh+onICDqI5/wl9kqREsQSwrSxK38uRjQHVb49v7SAkK/UbHpDEJOyopD3b/k9btXDdIG32hd9TZjsZI9SNxyIWHAB8B3U9AcBAjMzsUc6ho1baoz7gL+lgt+haunfynwri/Q9hVANm+1QJdHKEFFx+EGjJ31JTyJTTZMyjHCw9DhxB35h0llAGjzqgUG0gFGIrT2AsBkxcALgRol0rBu48fBSUfJ08uPrXYvGrMcMYf18A5dgJx7FC2PbcL6NUV
 soV5oryC
 jl8rngbz4xRZ7RhMbOfNedXMbkSmC3tQJUmiLtez0JFOoH2FLfrGNNlOVp8cQ+FVOLjlTzLo5f4i2vC7dMkeBAh3pYj22lh3nAp+I8Q4FFg7YikgQeRcSD/eiDUkIT8QXoXpCaPxDFDKjMNXB5dbZezAn9pix4I14DiPu5426bt9LGXqJcTJI5BJ0TFLalG6MppxUu6Wic3fNCLAi0rcG/qED4dOaXC4rMk9xtpw9snkAAMErIuxo6/82YRX98D9zKV5c+4mJXpZ8mEh/KFBwCpg0s6PtMB1SOo0+8bG2UwfD76nw0yg4W9K4WrtT3e7If5UHaOMGCeNSOE4xEdihJ1SGjFEDUldVGZ0+aLTp48H+K0YNrPhhsU7tM4vqN6wVnNJ3EKlyMqv0w057TYAL5fjo3LEgZxnNQ+WhgV4CT/tii0tWegVgLKSNJyOmXoaRNa5bFmJYYTfVM7EA74eSR/XlCHdQgKa7g/ylFM8CfMAbGbc1draS1xyRg7AepHs3fMAnWIkhhRLn48vsideWAwkVe24XfuFguAbyUZ2EiEzzPDyvC3DbkkC/GeihV0+eVrGZDOy1i1zJB9E1gi+R3QbgL5LVAB2hhAnHVuHgo3ucdQ4ITDAhfABWce/xjr1HTy4osABtQ/PlN3k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 03:42:45PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Introduce new DMA mapping functions dma_map_phys() and dma_unmap_phys()
> that operate directly on physical addresses instead of page+offset
> parameters. This provides a more efficient interface for drivers that
> already have physical addresses available.
> 
> The new functions are implemented as the primary mapping layer, with
> the existing dma_map_page_attrs() and dma_unmap_page_attrs() functions
> converted to simple wrappers around the phys-based implementations.

Briefly explain how the existing functions are remapped into wrappers
calling the phys functions.

> +dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
> +		size_t offset, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs)
> +{
> +	phys_addr_t phys = page_to_phys(page) + offset;
> +
> +	if (unlikely(attrs & DMA_ATTR_MMIO))
> +		return DMA_MAPPING_ERROR;
> +
> +	if (IS_ENABLED(CONFIG_DMA_API_DEBUG))
> +		WARN_ON_ONCE(!pfn_valid(PHYS_PFN(phys)));

This is not useful, if we have a struct page and did page_to_phys then
pfn_valid is always true.

Instead this should check for any ZONE_DEVICE page and reject that.
And handle the error:

  if (WARN_ON_ONCE()) return DMA_MAPPING_ERROR;

I'd add another debug check inside dma_map_phys that if !ATTR_MMIO
then pfn_valid, and not zone_device

> @@ -337,41 +364,18 @@ EXPORT_SYMBOL(dma_unmap_sg_attrs);
>  dma_addr_t dma_map_resource(struct device *dev, phys_addr_t phys_addr,
>  		size_t size, enum dma_data_direction dir, unsigned long attrs)
>  {

> -	const struct dma_map_ops *ops = get_dma_ops(dev);
> -	dma_addr_t addr = DMA_MAPPING_ERROR;
> -
> -	BUG_ON(!valid_dma_direction(dir));
> -
> -	if (WARN_ON_ONCE(!dev->dma_mask))
> +	if (IS_ENABLED(CONFIG_DMA_API_DEBUG) &&
> +	    WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
>  		return DMA_MAPPING_ERROR;
>  
> -	if (dma_map_direct(dev, ops))
> -		addr = dma_direct_map_resource(dev, phys_addr, size, dir, attrs);
> -	else if (use_dma_iommu(dev))
> -		addr = iommu_dma_map_resource(dev, phys_addr, size, dir, attrs);
> -	else if (ops->map_resource)
> -		addr = ops->map_resource(dev, phys_addr, size, dir, attrs);
> -
> -	trace_dma_map_resource(dev, phys_addr, addr, size, dir, attrs);
> -	debug_dma_map_resource(dev, phys_addr, size, dir, addr, attrs);
> -	return addr;
> +	return dma_map_phys(dev, phys_addr, size, dir, attrs | DMA_ATTR_MMIO);
>  }
>  EXPORT_SYMBOL(dma_map_resource);

I think this makes alot of sense at least.

Jason

