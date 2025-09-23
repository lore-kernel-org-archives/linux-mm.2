Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A01CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3BB8E0008; Tue, 23 Sep 2025 13:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB538E0001; Tue, 23 Sep 2025 13:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6730F8E0008; Tue, 23 Sep 2025 13:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52AAB8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:43:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC7A4876B0
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:43:43 +0000 (UTC)
X-FDA: 83921237526.13.8F61EE5
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011015.outbound.protection.outlook.com [52.101.62.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D90E4000E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:43:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EaWxsYjh;
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.15 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQUh9mweLCM541Cy/QMXzIeHtphgwjD4nkBl8XQfyWs=;
	b=CP5Yo8FxZ4jU7CnYMiuuhIz4n8r9XON2cxupL1IypQbGN1XYWGQGYipCN4Yhxl1ghYLZhQ
	4Fg/1qz2aLvXC/VsaQ5gQU/M1M5B9Ja3njbghjr48hW1mAahygqBYowITUgeqlHHnG2YEu
	OgqQQuAlYP6OzuJoXfOJso98tcAz8Kw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EaWxsYjh;
	spf=pass (imf04.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.15 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758649421; a=rsa-sha256;
	cv=pass;
	b=M6C+feuwJc1VFYO4ae6alOjE66JlpDULEzH7ndNctDcUcJW0fPdT0GSSI0sZai2Bbd6fuZ
	lyrGVnQUrT72vPGzNO9y9wtPv75X/U5v3sF//b7HiFgrRfGTbTJhRGSzhA306FYg3UapYl
	sVqcMf4GQSAC9MhnZIhZOgFANv4wp+8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Du0RYRFBCpSbdAbgESBcYV+wI/TJS2Ta6twbcoip1O8k7VxO7aTGyz8hrR37MpzzdIRcTVBefzIOW+sXcfEy4QNrBcd2eu6jIgzssUbmh/edr9t2oy3bQQDuJHTc+6HMJzxC9mZsrN9E2SxnvrWeIdDz9vaY9/N3ibtkjWnlYvdxXnE4pG001+kuQ/9ABjaBjThPSwlhwvL0eDLYHwqye3c8RFul3qpjY0LM4mM24xE5ShOqAyDyJV+hzPfdXT5hFLUquIZSSVDg3VBekIEVVGjS7bdzjTG2dA0RqEPW5JC88qgedpeqB+BnrD26VwyTyizcVhQbj9Ibzts++XYNNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQUh9mweLCM541Cy/QMXzIeHtphgwjD4nkBl8XQfyWs=;
 b=dkv/fvuZPTdDJoqsPdMuXmcSkD9PadBD6g2NWekNH4D12T3KUqMDPqrOHWs9AzYUOEgq8hzsGP5tdUZ+k0OKOC1atNeTwiIEyj+AZKD3QTrD9dI7jpCk6D790YqW6fGMCMKrqfg5A9Mqsdaf/I0IbNEjjcWFkJPbWL3LChIcg/ENcydQtBxoXBphZEeKDPzPhQoJ9YKbFcsExRIpp1OSLsGXD9RugtjdR8oLfEXw1Op/nQYn3VroC1tbtYfsToslNAYFLc42hBwGumo6HW2kucbMmvuUNsVvhcrWcZzfXXLLFLRZk0wExnidhXqpELecmVz/2sSEvL9C/VLCzUXmqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQUh9mweLCM541Cy/QMXzIeHtphgwjD4nkBl8XQfyWs=;
 b=EaWxsYjhFdRAgJ2EpRkUHtF4Beby7fT+ypTCHP5cxxF5eNER4/TdkcvEC99C/nuw2bba8/+25CQ7TQIu32MSKWapOpaJOt3JKrzf8s+TvJZSBGmXxc+nqop2MfZA5KeNviF5AxxQ2FKw8rKvSyEgn2nSHPlC45VmN/QOgwpG6o3z/guDWGXdsWqC+uNLNNimtUW0kfmKyjshDZhlXMAtFQusqofGWzZSQa2V6mITGBibV9O4ndjnHZaITK9E4vtizpCUMqIwVj57xG+AH8aqIO4TldVhoqogc3PbmkOsRccLtgVe1TM5PBoeduypKIVEiYhDUr5amVnACd5Vk3MaWw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA3PR12MB8045.namprd12.prod.outlook.com (2603:10b6:806:31d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 17:43:35 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 17:43:35 +0000
Date: Tue, 23 Sep 2025 14:43:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
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
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250923174333.GE2608121@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
 <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
 <20250922150032.3e3da410.alex.williamson@redhat.com>
 <20250923150414.GA2608121@nvidia.com>
 <20250923113041.38bee711.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923113041.38bee711.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR08CA0070.namprd08.prod.outlook.com
 (2603:10b6:a03:117::47) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA3PR12MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: cd92416e-4b78-405b-5d65-08ddfac8b881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0jwefVbBhfCuKzCx4n0Pg8AOBqjBzpKGN4i8l/7K/BateORZTJcOOv2U3mN8?=
 =?us-ascii?Q?GuKAseV4GT2/+7rl8jm1S61Hnn1+I+tyJbaxHWIBRuH1+eqkb/DU9TGYCVsz?=
 =?us-ascii?Q?KqmUKQsv324IwHNfpzyG2SxBjORJPTpfVNRAXUyQVtMWowjbveaFDm3JouU/?=
 =?us-ascii?Q?9aSSwqojb1tPHCnt2RzBc8BjMFEm+NwQhn8aJyzDrfv1i4vlcmceGeRx04FO?=
 =?us-ascii?Q?1dDCvZjI/NmbRG/oBj1ToGW9AtxT5vRalqHFb4g0jn8qCqzf2K8XVv3LT+/x?=
 =?us-ascii?Q?+qnjzs3ck5I33flZtlRwXOBRVo5ey+0o+gsJ9kY1M7ppbk1Tm3e2tSYtBAHW?=
 =?us-ascii?Q?fSqTSpLpwXJt0EUNZuKbJgvL948FWywjDkHASzM9VJw+uwKnoCqvaDl20YKo?=
 =?us-ascii?Q?q88eZrDI9oOnZgIb8Sgsn9Hx+NUzboQ/SwN5cwP/c1IV+nPqx9/j2nU8fgUW?=
 =?us-ascii?Q?i2DKtKfhyDKrR5er8REmXoRDsUbXi3/8x6M0b0VmadzzslIUG2Iskv4G2WMG?=
 =?us-ascii?Q?URoE048AuZbmsojNAfO7JO6qs1poAaz0gpAXtyIK/6pp6PWCBxAqtXPAUzM3?=
 =?us-ascii?Q?+PabFXsK/zkY8zttthF4Qrk6hZ7dia85apKMdxcARtfHAAr0a8jHXpBfe7/X?=
 =?us-ascii?Q?/Dr0Vmmq64nMKqrPlfXGPpV01Ab2eRZCy1paq8PXBSaH0Nhtjeu66ix3vT8H?=
 =?us-ascii?Q?b4UM2om8/pXnnQHSLSU2u0Iz/ecCPsdfyfsNsGi6FpiiRoaPJGGz7klxo0ez?=
 =?us-ascii?Q?2N78cW8cDZ+EwX11A2Zcu1xpdN7SWSljsNmObXjlQIVLRQCKtZ6fUnPBnmFe?=
 =?us-ascii?Q?aRe57WwR7QqOF7Q3EIIEC2JaIGMj4v6K2qDY6aEclL6sh7W2FTY/MBOiWntt?=
 =?us-ascii?Q?q/z9Sfegw1os0dmWrU9wcSwXPgqvrqJ/5DdYUcepg8QpVsgoWbNdPAdGEs8j?=
 =?us-ascii?Q?EOdN2efts4V20PuDNTMx0Oy26QjG6DNrMQ6IpxNiRS7qskzrB3qUZTUl2G9C?=
 =?us-ascii?Q?0tWz9JpElkZLCD0ghgpzYK3RTx1sEFFc0KiMbbtqLcq6HZJLi8MvbcRcYLPp?=
 =?us-ascii?Q?MgApCPH2lFzRK7w9KRHNY6wFCXcY2iDrUAMQ32+doO0evCmLDl7Ns1+nRs7x?=
 =?us-ascii?Q?FohohlMn4SmqGAb7WLemqahpLkbnwuEsyp1Z/n5z4msVShoGE7F5A/omhSL6?=
 =?us-ascii?Q?tksFJocZbtQMC5SI+W7ZiF2k25mWlUD0UJI+uUDjaPIQhoFKgyH9o9iINXV9?=
 =?us-ascii?Q?T1O3LbEjjLXXg2li5hRGvNrPs3D7Popg7n7nL6vb4vW0IicTnItITeslsLpu?=
 =?us-ascii?Q?yc3SHz0o1kasyWpNHQlfpi5Y5tVSfndru39+s9UJs4qMC2hlZZtgc1/y40Vs?=
 =?us-ascii?Q?/IH99uXYQAXVcKmuPpT90DBZLAoGA3tG+ZYhEpJlOF0EJy2kNta4Fa8OUS18?=
 =?us-ascii?Q?pxHNQBP5PQ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1GHagwMpjjQQyA95vx6sBGw7kZYNp6GYdqLXCgrw2nB9DQ2PwwEzqVjqGlHQ?=
 =?us-ascii?Q?Zry8FZUGq/GtA2qi27sq9A5qoL/kEIjo4dzFLtM+Uh3Qb55PDD9wBYgsFxnW?=
 =?us-ascii?Q?+NoqHvwgv9+Vjpm+sJPPlkh2fp1CMPMN4eXPQaQKoizmlz3Nuv3CEiAW0QN1?=
 =?us-ascii?Q?ahDjmP+35t/x8ezFO1hnfXWkFUZFk9nfOafdZSKTHoNj7IuMb+d0UK2FHEmD?=
 =?us-ascii?Q?i2mztw85/vsxMEIh2ZnfsEXxPnrLehktQT77PE1YLlqkDuAAatn1exREnUx7?=
 =?us-ascii?Q?ZpUmrby/cPmA2+OqL46iVK9urirGcqFWeMtNVPn8Isf6KpeUddsKLcI8lPX0?=
 =?us-ascii?Q?H3PKAaMYswirLZ0IqL+ojHgK5TpDftfM642Hyfz5igzTJfDcMwpnVJ35MSr4?=
 =?us-ascii?Q?48iXhKOpiW0c3+x1rPh5RK4ZaGLH68lIE3NYmHinynd7O54rD2iFEOUlzIX6?=
 =?us-ascii?Q?c7EtNe6/nxChDj+zj/9wwQgGIqs9lkINqFOMMfFopdgzv6e/XWCQ0UD0oLvU?=
 =?us-ascii?Q?LYq4IZy5QzWp9/LOAg3oMoO8KwzuGjXaHwv8BRX6i8P1AjUKwDukjTzS0t7r?=
 =?us-ascii?Q?cPcrQ4TFYPaHh4uFdthZJVYg5+TcLAbqSSqYNQHbew2ECQkX0T9VRtWD+5E3?=
 =?us-ascii?Q?oZXyLEFJU5gBk7bOZTwsI0IVAYGQLepSb0R2aQaqpFEuASZC883rIShO/6TW?=
 =?us-ascii?Q?bM9kp0l6lyIcHmSOf+N5hbfhLKjVUKToTDytjiDCBA4bt63Z8eHcKJm+Y7DR?=
 =?us-ascii?Q?roljuh4crxVuNl7eaF/EycL6Nu7dvl60l5tDvSCxOzlXCmtj//gUukaNzDnS?=
 =?us-ascii?Q?eL4wIDEFGxPWUo1fQzM86GQ56QQS1K5bVgbi3YVRpCnHLJki+ETI2r5bQ5D9?=
 =?us-ascii?Q?OGNGo5uildPDNazU2sPqjalTQU6P1k8CyMYX5234lz3fSO6EjQxjDd7qGF4I?=
 =?us-ascii?Q?E2fKZoRbKNpFnJjYAGBUsRZrRjbPgL0FfvifHNCq69rPVN3mN7Tukfaf8KIN?=
 =?us-ascii?Q?83WmL4bN7ks1eWRBqG6BAkzB2cWRJqdxeana4OTNuG8W/vxEjB6RX+Q/+d/+?=
 =?us-ascii?Q?7kPTlKJ4tl8PO7LljSB3AgiYJRulzpY9dQOyYBKowsKHNoh/oKrH08zXI/Rz?=
 =?us-ascii?Q?jcSopyABQ/YvNiuLPB5tWZ6ggw/CpfNka5dr6v4Qxy8GG0Ln7p7KM/t/UCOx?=
 =?us-ascii?Q?jAATu9j2TP44TrKL+1Q4adO2MvD8AUOqVxwN7NgObUOqNME8vS057e4D2/Xj?=
 =?us-ascii?Q?g8eVjYaBf7Mdt0pHG/G15uxckMDdOLk+2sGy+/kzxb9qM75B++bO9/9yrPtJ?=
 =?us-ascii?Q?gfCWIFDg0EGfPE02F4IUGOSJEFMVhGrwtJf42I7ZXmWK0xtn6UBue1XnhoLt?=
 =?us-ascii?Q?E6uVknK9iuwunRLrOE+3fb/p19m80jzStT9h7coCvZ8AlyP1lOKPWddHcFko?=
 =?us-ascii?Q?d5jUpYRIMLOQ0Ixol3xZQWgvBrPo6vwUw9wYKG9hT19Ty8g7vO41OqkH8UDf?=
 =?us-ascii?Q?a4v3XNME3Ji/mY975CdKuukejksb6tRqu5eUiko/IcVQdErsCRAyy8bdWK0m?=
 =?us-ascii?Q?IBV3bfKMv4ZQRMIJLQVEyo/ZvG23TdV9zCelh4O+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd92416e-4b78-405b-5d65-08ddfac8b881
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:43:35.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2xEDAyO0jvobdvQD0MaTXiLy780iTjibHmisclshFOvk9Kf3cywfpNEv+MNKWfl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8045
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D90E4000E
X-Stat-Signature: b1s3thq5t3qzieoadx5drk8ndf499ycx
X-HE-Tag: 1758649421-550708
X-HE-Meta: U2FsdGVkX1/H3BGnMEb7ZoqT3aTFkSn8BiU6KkpkbAYtnRuqCTApxojXvk/ndmWERa91VHwCM2+YOrzW0/ievwcm+7iYBZk7+qzGbOPbjDpUpm184M9oxLdzOPw5Qm6mQUEosUmvgUA2XAZb988XKZ04HDKvAKnK1rXA4Zr8zI4dMum7iVn2SG7MC0/2duqOy9tZx4vIOW14m+2VRDOuvIxNr+jNfoYWTZCi3NMtY6JM1Z18gpa0SroU+pXuNZtQji8PhEh/n2L9WC2sJKQhlxm5hud8bQabrHoAfO0xnNR47UkE7IsO8a/Cfz9OTqMybDMAZSImuEaqHN3mY0PAH3i1VVpV4On9EUEcDkTQLSvV5g9kg8tV9YlJjezogNzgpfGikMrAcJN3RV6TNkLew0OkBgwWB8QzhMi2H90DQF5ZpZRpsgf+IFsMgJI3vpD3ZT6QU5WyKMXuWufy1xmgK5KKIayRqy162zKHPBmpWeUeN2HVr1m1VlZTmZW35+kSKal7f598YTPuckXXkjxNE+uzxrMQYGsgpPFSnbodAToIFKf7TiO/fruRVz6dm6H3s/xPQg7rM5LYAdLS829RpDRKDrYxUyV7FR9GGzd952kR4ezccwaYmgbW9fBiq8Qnr9HwkUXgVlrN8iOEhkl+AwLZ7veQcFKEPKMEhENs9H/O1ps43JTjVcXPX/5FaqCrNMviEV06whCNo1As8y+IDvoaH1gCdTZ8TfVcMx6VyvPwCBYj++r4oXSkXA1W+emckxkyBxTBfXSo6PQ1GL8S5Fz3ZzmZ8AWZgDQSQDje0b8Fu/WOydfPmqJ4Oi0ZchHzwiBIIr1U34ZrBG3wxG7m8u9jWjo2kOpCuhRv0P27qfvx6DXqSliFcAT49UZtuJ3RRAPWj1wIneO3W2w+NaEp0+uXpGiz4hqai/q9GECTVyscKc/RCrON9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 11:30:41AM -0600, Alex Williamson wrote:
> On Tue, 23 Sep 2025 12:04:14 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:
> > > But then later in patch 8/ and again in 10/ why exactly do we cache
> > > the provider on the vfio_pci_core_device rather than ask for it on
> > > demand from the p2pdma?  
> > 
> > It makes the most sense if the P2P is activated once during probe(),
> > it is just a cheap memory allocation, so no reason not to.
> > 
> > If you try to do it on-demand then it will require more locking.
> 
> I'm only wondering about splitting to an "initialize/setup" function
> where providers for each BAR are setup, and a "get provider" interface,
> which doesn't really seem to be a hot path anyway.  Batching could
> still be done to setup all BAR providers at once.

I agree it is a weird interface, but it is close to the existing weird
interface :\

> However, the setup isn't really once per probe(), even in the case of a
> new driver probing we re-use the previously setup providers.  

It uses devm to call pci_p2pdma_release() which NULL's pdev->p2pdma.

Jason

