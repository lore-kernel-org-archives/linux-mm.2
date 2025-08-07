Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F91C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 13:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F108E0007; Thu,  7 Aug 2025 09:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36668E0006; Thu,  7 Aug 2025 09:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7428E0007; Thu,  7 Aug 2025 09:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7868E0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:15:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24D151A0BC3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:15:06 +0000 (UTC)
X-FDA: 83750007012.13.3B3CFD6
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BBDCC000F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:15:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hRuZURXL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754572503; a=rsa-sha256;
	cv=pass;
	b=gUlWdhatQVInhcAFMHZOvYyWOKpaWW5NCPXTVKmNSZToe73bTrRsFFhRIsWdEk28CjYpJe
	1uz03ccSeSJasH4valqdrHXDsZyGxa93l5zklSuHaZKZo7Iat16v8aZDh2vgzbiE6znoj4
	3oOmLnBpT6my5PVsVTYiiukA2JGNgM0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hRuZURXL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.107.92.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754572503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhrpJXFQJ413bVBg/dYiA6Su59FLs9ca9I3Q/eQtjEk=;
	b=xDIoQQaAkhylISbauJtcNJ8F3sf0Li9VPXxHX6qCusRSB06nP7IHHstugjSXxekHzL50mS
	A7xryoQ4juWvd9tvWjn2wkf30DbECR7dF/V/ZhdlabJn868VLPzlFwyYjV/xYYTzD440HZ
	ZJdJ9TxtA/skhsDccyVF/NzXG6VDiS4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wo7k/uTJcp855ED3LJ2trHqYOTev4jBcYYE5YCzT2lh6ZrTAiSZnK6310k5CwU2DX10KGyyyMZKZBU8RMc5vPnCUrXZ75/vrnILosqT52b0KVH5q9zE8A4M5Rwvmz9MtWNd7qxKnJ2PJbQaEVj+yzxHyEJ8kCvuCefO9Ww9d5NaSKaNRQaLHCygKxRzuBAmOGUT8kuX4N6Lm5YS5EXO+L8UOfUGCf7+tmb/xnK/rzrG+vjOLVIThtuO4YGYEYXs+xyfjnuuOFbK3vRkOaoziwWcicM0MdtajbyNIgdgnQ9B895Gx2eXja2Jdm23RboMkhF3jUyeex9YxhdtqrEmCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhrpJXFQJ413bVBg/dYiA6Su59FLs9ca9I3Q/eQtjEk=;
 b=EHGeulZn/cEjtXGORzllVslfrrFvgrgMnl/ePhrHnBOHldTAU8S8irht6EJwWSYJKvMe1oo3TlyGX7HHg89opsTeE9+b/k5ud81AEpmH4nGwg6JRWUHwXbHjisHW4FLEvfXhT+2gWLCYc9LS1Zep8h6WJa134oN59w6WfAzyDVPGU5EKTIYoLEOhmEscKKmBs/1eHdLnbaJ/4RKp5qM+xm9RJuhwkIXsK9OnATvBAdfkKdp0FvwkVOsEo3pEzyEaqwKhuKj6a2ct20xIOkVenCjiCIZcP//vJOlO1JkbQIZk32YdvShMWKBhXz+Bw25fXOrSXffAm5e7mG7YvvXQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhrpJXFQJ413bVBg/dYiA6Su59FLs9ca9I3Q/eQtjEk=;
 b=hRuZURXLK+zmTbd9v35xpwN73YrZJmzpo6AohN1GdvatI0CQeIaAvaF2e7/fshyFGm/sFxcxDnGai5zoVbgqmz6fqFdwhVvOWWZoi3JmCc+Wod51RqwLJPaGBcifo2mL/pyA6TKZ2cuibWLWy9ZK8Dw6+fjlPqRmkp+n/NdBuyOJplcEl/OjMyTarZxlQu/1JjdFptZTshnQeonCEnwSKQENPqRMBNPfv19CulsZKLx+ZO+twSitmWu+5m6czW6wMVJWKPj0V2vcBTWXMQrvBc6JzDZo3jwFDyZrNXvwQGf99enE7yZ6tmEIiVP8HyRBiTo0SgS0s8i6bAGqbA1oMw==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB7848.namprd12.prod.outlook.com (2603:10b6:a03:4ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 13:14:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.017; Thu, 7 Aug 2025
 13:14:59 +0000
Date: Thu, 7 Aug 2025 10:14:58 -0300
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
Subject: Re: [PATCH v1 12/16] mm/hmm: migrate to physical address-based DMA
 mapping API
Message-ID: <20250807131458.GK184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <6d5896c3c1eb4d481b7d49f1eb661f61353bcfdb.1754292567.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d5896c3c1eb4d481b7d49f1eb661f61353bcfdb.1754292567.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0453.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB7848:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a07515f-ddaa-4ac5-b3a8-08ddd5b46965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GSImJahfz0YNnt1fwDp+mBc8ssN50vC6AfMAVhkIOcvn/O3sKKoVm/4ksk+C?=
 =?us-ascii?Q?ocO/j51p/V7ugnNBtvoABaUqHrSIHA9Hm3UvgFM8lP6vQxcc6ItyQVS8sL+1?=
 =?us-ascii?Q?AFJZ2QOJt7mdJGm1fDtTNPXa0+l/bFsl4GGBxccS/ZBCMRWwW6kOnrInWdhN?=
 =?us-ascii?Q?83XGe+RKzaNtVWcHVBFBaBo56C/aGBb5C+9EM6ZUTolx2BRnrpu86JJU/wly?=
 =?us-ascii?Q?9szly7j+qUXn/j4XVZcOHY5lDECADNx528PGUctcbByhNzn1Nb1j9ruTOZq+?=
 =?us-ascii?Q?mS0giz6+NtlYc7Sj5f39bXIjYeyXMDM+3/5HOLSrKpEO7nkBUtlg7hVlfYKB?=
 =?us-ascii?Q?0XwxqyC+ToKBhD4XgCtw+Iq+U8Mo0KraoFrBPq+1wyov3kpH0c8gjn5r6K3W?=
 =?us-ascii?Q?j3BHaQxj+rE9iX6vsQJDexzC1wmVL/mrIxtKjiFoM5HcDocs3VBn2jPVMLJ3?=
 =?us-ascii?Q?BdwIUdxEwiEfV0GpNoRxxguI0E0FYCcuf/MKIAW3891CA5OFHWqirQlpsgDY?=
 =?us-ascii?Q?XkURAwqUb0dWLrOxoL5l1X1/NqGr0QT4Suj4DNnf4ohQmbMpToCrPb2zl8EB?=
 =?us-ascii?Q?q1viVoNJz8xho2ph51Tdx9z+bDtkvRC1kXGyv7sI8UEgJt/f99Cxpgtx7g77?=
 =?us-ascii?Q?vnX2EJLvSGKe3KSusQvb55iJieU6kCocSj/sIXxsDZq3RKVn8Ne04l+MHgU6?=
 =?us-ascii?Q?CMmGigO1sUjkKIYoUiZeOYP4AlwB1yCIMR3GAr/99Nuoc370O35GK1mGVfuY?=
 =?us-ascii?Q?e5Wiv3u/K9vUiSL2kX+g43gTTZAdICuCcJz204KRJttcQl79pgkqkxi/EIvA?=
 =?us-ascii?Q?sTFGuLo4MafZMKHhqgEtiJxm/b5gtT+nRMhxgVUSObDw3JIp2bvXm75dYN/w?=
 =?us-ascii?Q?6l5nyT/xIRGSEitQu/Lr2FHKQKHn9MHFRQNRWp0DSTUG+3qXMxQad5hJvV5n?=
 =?us-ascii?Q?dWqC71GofP4YKjxsIZ0c/H3MDQ8nkezQjLX/dCrCvLwkNlzb6m0AgT7K2jqx?=
 =?us-ascii?Q?9R6bD2ZfdnvuXjOGyJ6fhlN4SLJQbtPufxDLKQTfQB05olRPoAUqIBiCO5bW?=
 =?us-ascii?Q?yH7Pe2lbyALqgNdWAIp/EqvK6E4Thye+lVnh6zwiLrDMa65lu8lekZ4aiXIi?=
 =?us-ascii?Q?c/b6ljhCYqJfdsScF1CbUScdoN0Ap1gfOL7Vuu8zQoVZqupoIt/yxUbtfQ4A?=
 =?us-ascii?Q?tZaSCbtFmaRduYZYpoPmB5tyb6mpkhRYiwdd6eaAJU0ybvtQ0OKqyLXxeiQv?=
 =?us-ascii?Q?OWjcSpaA7rvKBbgiXM0giidUJTWnVU6jrP6WmyNtYgMrKTzflx6Tgz6pe/l7?=
 =?us-ascii?Q?4AvALcXlgU4yOMOFDaKMZS5SK/bTKr96s0QiJhGb3mzDbYBU3EgfkOp0Jxr3?=
 =?us-ascii?Q?pFlomqRCIkf/qHucrTbTlGSNMnPQq8DSC6J2iHHFV4+igvw8ctO77QccHuvG?=
 =?us-ascii?Q?BSNvcvV7iDM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uVQwG2u0CVNbXDDS+5ZdwxowmLZ5OHkQuEUxGqmleC+7gjjEVrPza8qdCu2H?=
 =?us-ascii?Q?DqmgrtbTEojW6zJDsVFIcNi1mJtxn/lW5SIBCCh4cx4QK6iHT6bCoistEIsr?=
 =?us-ascii?Q?V81Ce1X6q1kOGhUq4wgeXBtDhahFfmTQ5ljjrt1UI+qnmP4Ilj/Zcc7yLrts?=
 =?us-ascii?Q?4iDSIZoTfHlAI5W7hlopIAm7a4w63jWe4fKj71k1Qumik5Nh6xIYj7zfpR3r?=
 =?us-ascii?Q?i5uOwuhZ3HvtWgwSuJhT1aS7m5u41Ag2I2lrRUwqL0AVtiIjLPjwX/qK6Zrq?=
 =?us-ascii?Q?KO41KlW1eTh02FnnoO1GT/Ib+kl0sV39jUP4abkPVRba2S63iWWmInlZ+xzW?=
 =?us-ascii?Q?ujOMQ9ef4P240ZAM4NRcuIMcQRURHa1gE+rjuzIMMEDO4pLl7/pzjlZdn6lq?=
 =?us-ascii?Q?MznwkkeNxk6uvq487o4jFJpPpsUdZz2nEzvUuBx/rPzAaCFQNNNC0RQN7svm?=
 =?us-ascii?Q?dhMy0qzKzFQXhQh65YVbx6AzQmkyN5Uk2APUSFJjGWZY4Az3xQTMtf2NXZnB?=
 =?us-ascii?Q?nzR8e0xSr3JS3DKhLaWw530AwSv4hpYooUcrB0NnM8F6A+0woOQdR0VaT+iC?=
 =?us-ascii?Q?Vadjw9RX4KbqHbKVGsoKSjkTk+bA57fulc3p/bWQIHlEn8Kyxi1eGatWiFK/?=
 =?us-ascii?Q?jHdn0+a3csJUb5cBRLs+rVWoY+1AqrvRqbg+U08UNpCurQBWF6i5J087gACH?=
 =?us-ascii?Q?LW2aYjif9bGLKfmDzee3sqwJ5AJkGUmbB6UKRJFW1+HCxZBnOqUwx+HsA7EB?=
 =?us-ascii?Q?zOLqpjCMVfm49rgIfbh8WSfJPplF9WKE0FZWXrSxYOofC7kDOSj/W5e0Y3Dr?=
 =?us-ascii?Q?6GJ+XRM0WEAXZQzPzSWJ+jLw7tbuNqCuEDn7e8h5uCpfXo2ppikWX2hZbwW3?=
 =?us-ascii?Q?xgrQ3DesCQzZLLs2caRCHXivsYaNx938WILpK9WWFsgmSoyhc8MGyNESDvJb?=
 =?us-ascii?Q?4qvLGxLu4SfHFaPcYHm209mQY6xpelBXVSXJA442Yp+hJm7e3p9IMFi8RoBP?=
 =?us-ascii?Q?MmAZ4EjmfuSqZXz/PL11o/ynTW1D1jHmnKn3HIqrahsFm4/JoYyOlQZP4UHq?=
 =?us-ascii?Q?YfregCimSaNIXwVWh108NkwU5pbdz3yPazMSYvuL45kMcHa/70fUn0/9tjkZ?=
 =?us-ascii?Q?/fJSdzrrdW9cUHpkHtiOQXTckFjVfNpxgXDuS4tvv6cLaDbscTAfeiW8RVgf?=
 =?us-ascii?Q?HRFm5YF4KRqmY4ZEgrsyGu7clCF7UXAFWGnbmM11qCj7cImhrJAYXMDQ2b0Z?=
 =?us-ascii?Q?4UkpZKzb552akcXznmWtJe5aSm9v5fj7+ipUL1EuxH3aI0Bg6mF3EUzbLH9A?=
 =?us-ascii?Q?umBxh3cGpH+Mdf0Uka6xf4IPU5USIcPJWKiyNaQXVSAXsm9PlUfTLQdcc/ld?=
 =?us-ascii?Q?WhI2SVYFqbI/1QXzwljSHsxSi8jYAMow6c0+uff7K5biL+6kvgE5khgWhjcO?=
 =?us-ascii?Q?FX/WHQsGoZXDDdOGj3cexmCiGtYwnzdnHV/f0WHDVT6/xj7SB1e5mL5hFpTQ?=
 =?us-ascii?Q?1AltKpMuPum0qbcYABG//OJr8UX1BsZ8/wiz2T/B2maxJTItHhJS/pj5YFQq?=
 =?us-ascii?Q?xY1T4eXY8Gl9xBE6JQM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a07515f-ddaa-4ac5-b3a8-08ddd5b46965
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 13:14:59.7997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aRilX0OJKybLQvXrxDL1luTg64hyjr54mJCIoCxuOa64E1WkO3f40ZTT12LJxHyK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7848
X-Stat-Signature: m5z97he7oxswx4g7r9bmpsmsceo6mcuo
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BBDCC000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754572503-799464
X-HE-Meta: U2FsdGVkX1/klfKmIvnrooWUW+TRiR9YLAa/YbfLgpOCQ9aPvQr+A7/ZXf29OD8enz840KmMhncNWurI+Kq78mfhd1IjxqRSCBNP/xSdU33mwCJlRQh1LkE57B2cLSw0l295lS3IHkrc680kt8vcbP+NDLKRTYtsHLxAKgiMnvPcLOG79h+Zvf0Fzi+QIftzXkpEhlHRgGrJ4SDtIOP4MWUgO6adY2YZoodwv19kJsUDiVANrsJeVPBjs2PK2nUva3KlEA2MgZ5bgKtdCxjiZY6O9L848vx/B3Ul61nyxKk2Rjm2GOrEsFxejD3ZHnsbjidq57GmQAxieQhn5ALQcqLq3tpPNZOsL8x0EgtLdy0wfVVmmNYmFvtfIjvwq8BVEhdegzIBZ8Ohi58kk9/NGmP3AU/Pu3RD2D/iSC6w0ZdEIqxbJHeJ84rIuQuL+azQuj1I29gWCylUablFSC32LoEC/9yi/zpHuhHJ+sC9HIfhMXXvmhUclhTaN9ZgsPxE3fURVOIFGnR745HuUJq0T1Cq+j+wgL0tpylt069asOvIk1XKm3COQY0bqwQp+ihmPupwZ9yX3z+Q6mIghleKLe4Sa2vLEIY79LF7ALFGseq6kqty8RkxN4qZAJ836gZWDnEKw2Y7gx45JfaOVmw9TRZMG5JpVErxTuQ1FA7m7/XxJgp0ej1aT6ffzTS9lEDd4vN7HwVQhaHMWEDlqmgV0iL10LQImY/OAgMtl8eeWo7OD1y4koiKIpw3IGeH4UPGqjBLFrVqhbdsHU88ZN2ZTp9MnlqeCtgNHLJAlfQQK8mCRNTbyBjB55hkKFeV48nkvRuByjI/5eHRrq2y6MqZQZLs7ueGK/BYJceZIshJN5egRGGBgHU2uWSKKhgz7G4KOYBiL6Zo2OtVGGoJJLO5zfh9+6X+Nq90iCDMA3PBdDb2VylbPhWrWqw33PjX7nRsmQSCZ70HJjVpbuLCnb6
 mmkV7eb9
 VeaXqdpT1ZyGNk33aPZKJKwhTqD0TS3la1KqsiWm/A8ZMKxonB8O1aSXmST/KfDFRqWWgVOFgo7pc2EHUQnr5KuUOeH242pqJBu4PmGotDRofAUjUqlNd0Vmuad4zgfsufJfgPLXiUsA4Sd/tx5rcAAPPo97ayHm/b2E8sE6nBu/j96lhO1tui3KDvUorL8Oau6Qnv30PwrfITP+5zIyMKrFsoqW1eQZFVz4/rzwD71jE/oix1qSfcDCerl029KLr5K9tcmRrKy1+bJc8xvkTh4Np2Ws7KTTuj/qn3c1fX/iP4ovx9k4XYjq6KbfM9mIfuDZKuhooC2CtYO7hU14Us0o0EfGLO5NdmYqykD3h2nhOdxGFSHi9Keue5gwfj1Ao9k/eMmvq9ZBzvr4mJCIAsjVmyFqYQ+NZ59yVOCBV9oRjXihg8sxhHEZY5WdP5Cm6oY9+G/lY6L5tEnQIon6WjPjAG4mZON3wG6ehIrHVr9x8V5Nv6u3h9oydcjK2tVBdgUzLu+6JLTjVY2iGxixL0VGth5JD1u4azCCKSIW5JN6phIO6R6E3k916QmVxItgoelJVxIW7aASogpDFnygEBuwIxEQwJoBz/+hM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 03:42:46PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Convert HMM DMA operations from the legacy page-based API to the new
> physical address-based dma_map_phys() and dma_unmap_phys() functions.
> This demonstrates the preferred approach for new code that should use
> physical addresses directly rather than page+offset parameters.
> 
> The change replaces dma_map_page() and dma_unmap_page() calls with
> dma_map_phys() and dma_unmap_phys() respectively, using the physical
> address that was already available in the code. This eliminates the
> redundant page-to-physical address conversion and aligns with the
> DMA subsystem's move toward physical address-centric interfaces.
> 
> This serves as an example of how new code should be written to leverage
> the more efficient physical address API, which provides cleaner interfaces
> for drivers that already have access to physical addresses.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  mm/hmm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Maybe the next patch should be squished into here too if it is going
to be a full example

Jason

