Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE70C87FDA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CB78E000B; Wed,  6 Aug 2025 14:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCED8E0002; Wed,  6 Aug 2025 14:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E388E000B; Wed,  6 Aug 2025 14:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 370E58E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:44:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9B14C06E9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:44:50 +0000 (UTC)
X-FDA: 83747209140.15.6B609D7
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5AD1480009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:44:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gi6vwpK5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 40.107.102.79 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754505888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsnX/855VPl+V555Ssmgek9Y1s47JtlT+wpnIJ5f4UM=;
	b=EG3Ja0zaUEPFzUiNVpL+YCtTATFGmcVELEyZOdpK/SNznp65IE2ZfXFZx5Uy8P/eM3bSbv
	vBHQivmJS6UbRGST27tztnxG7S9Ne5gds8WNL7NE9I9kenbl3Z8lkPKE3FTgZ1qRmUHLuj
	eOPl/8MjKorll9rZD0BZPtUnZGkHM1M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754505888; a=rsa-sha256;
	cv=pass;
	b=oaBdEwJuUz9jl/IBfAvGPH1GokXJ4qphEX6F03HXXq+ZXqJU5ROIbPrdu5kOeiLbzk8xHI
	g7vtO+rhMvfNCOnrNv9Pcyixvw62VueT7+MzTq29ZEaMODB9d56ElALKuiawCiLw58oTUl
	cVb4cJN0gddh1dCuxYJmZnvUJ2iBnDU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gi6vwpK5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 40.107.102.79 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOauFcSkTIcu6PD7QaXL2Z0ekh+G12NbVdlqxqSUF329YDRGdMpJsGxQ6P4fut1tX1Ygpb2vcf9dUG0A0MElFOeAQVNP/mC5F81GfWDQgksWCKY3exzISuXthAjUdgIYtHFTj0Owe+9QXSzhnS3Y1Z0hdtVKu1b5yWNh1+UPlVGYgFopNcqoI1Uq2qcC5mCuSNmu76shE9RpAgnwh2k89srZg30ukYjhzkwSwExmvQJIQTZ8T9PTwPhjvA5QuXHLEBQ0RY1nsssiq6+hp7UYpZSSgUxBd/u4jVF4EY/YUnZ2Z4HL7m1UCCzjYywsq+gxEqMOgHHxs+CkjwjL2f0EHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsnX/855VPl+V555Ssmgek9Y1s47JtlT+wpnIJ5f4UM=;
 b=LQ6Jyo8G+G6ShACF49yYeqmyidGB0PDIIqMDs0nKLWlkVU/UmfgLc7T4MJY7TDU1yh8MXPDbtGY20MFTe09zB4nTAV65ukkxyTBPT3tcGVzajUAClpnO+YcvyqJDL7zewB/NQZ1KnCJswCw5Qj0D+5Rrg+EMO/moi7PeQkeV18W3gTe0RKU7fTud9aHwjkkKZMCK615a22skSiCkRjigdQ//IwUVPvF23/WEP+FJ5osRc5NK9c2TfOx49oXxg2vuZwwZBToXedmTA/suZVsxI3Xg2ybxN2iF0LD0baRTaDtd3vQWX/drHxUHP4kHdsnQqefLNOSiML9EABsYRRxRiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsnX/855VPl+V555Ssmgek9Y1s47JtlT+wpnIJ5f4UM=;
 b=gi6vwpK5i9Jx4O9Pk6cIfi9UBlgeHFY5Hf4CRLGXdYp/1NAtrsXAhN/5hLWkN143xMrb1UAUDqxZJUdgN9ZSnTEO1d9Rokd4vDp5ZbhHTfZTyd/WEhNSqkWisD71CJuUAzkVwU9fvS8NL7ZgiZx6cqgGB8p18ccgPwUfZa72/0Vvip0apOrLU8CjtBJzPchTVgnz74mn6tB+wIO1TPha9NpyIkzXKWoZCn5+t9/Rydd308vn/NYmjJZYYyB66ZvPfBShdDHToalZKv4wz5ARxu9ZTe6wxKLN5OoXm119nzoLrxPPIC09n73TdVYV6oxW1x/KVUYVVvdVyMtUKCxqiQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM3PR12MB9389.namprd12.prod.outlook.com (2603:10b6:0:46::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.20; Wed, 6 Aug 2025 18:44:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 18:44:44 +0000
Date: Wed, 6 Aug 2025 15:44:43 -0300
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
Subject: Re: [PATCH v1 05/16] iommu/dma: rename iommu_dma_*map_page to
 iommu_dma_*map_phys
Message-ID: <20250806184443.GD184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <9186ccefda5ea97b56ec006900127650f9e324b5.1754292567.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9186ccefda5ea97b56ec006900127650f9e324b5.1754292567.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0189.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM3PR12MB9389:EE_
X-MS-Office365-Filtering-Correlation-Id: b540726a-1087-4405-7c29-08ddd5194fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DVKK7m2kwbrFdFZ5CLqlkp3pCfT0gAPJfkqrhOJzBqvcXtAOkkMPkBXU7sc2?=
 =?us-ascii?Q?HlPv8+ODQt8Q5OlIqzIGrgF1p47orRrCOtS8kcyGubzJCJWHSvgXFfbNgzrw?=
 =?us-ascii?Q?/hbV1f0thZ7bBK1+ra1Aq/S4ghWekXsp1lWa5ZxaEgJoM6cjrxFNxViHVCTx?=
 =?us-ascii?Q?TFLHB25mCEIL35Hl32dvuQWzbEU0GAEIVAXeJcPoCROymPkl0kkmjQDuHvBq?=
 =?us-ascii?Q?RkZnbgMNgQDJ5hVraqmr3DqGxwMzxY5CuzgTXC97OTldBsMrUA48sPfSRdID?=
 =?us-ascii?Q?tqSf1yn9ePjr7Hy3vLsEgX3F0fYDVHBJtKI9SaZ5L0p+cu7Uc8LFfr3KenOK?=
 =?us-ascii?Q?veB8r0oF8RmSDkboVZYVJ4LxD8KpGeCBlI1IJSOkSZhp4XGn7VEzxR5UaicJ?=
 =?us-ascii?Q?p+DZqdQDosr9FvrmtVsyYhFNf0Y2CCMgoyKiHR0xD9ROFjvV+cl1RfBE0BOa?=
 =?us-ascii?Q?YvmN68/7ccmDS1DD4nBhm8zR6JmvobuG2WYZkzk6+yrKS9xauJWj3D8vvJSG?=
 =?us-ascii?Q?ii403ZJLIjngZYo/rzax6f8v2jfN4Jz1HtN3ZTqbZg0NQCTu85kWr/XhusG8?=
 =?us-ascii?Q?F5hs0NGzJY4IEmIJhJmvxnvKn1HNsXTHNXCHtLh71RhGP8n9SKXQYRLtxCkv?=
 =?us-ascii?Q?8pavmU/3d5KiWUm9ny/KjITJYthuwGGpygrPizbHaBrHquUx3GGBYbggfwoa?=
 =?us-ascii?Q?LMi66WtjB3AYwHRmXlIVUPirRtnF0O2CjHopmmjRrUKzu4uclUBDvVYN8x4X?=
 =?us-ascii?Q?2ROpvPSIJNfSYsU3AAEHC3YyOxDvvBLXnyJqCcf88hehfvMBMBVH0P2drFon?=
 =?us-ascii?Q?+XfyYtM6hVF4OPxaIeAh9YPKm0WxFl2Np8kW/tUzqJewVNeQ/WUIsU4Hizuc?=
 =?us-ascii?Q?277SUZf3nJE1rAykfN8m3DpJw5Jlp7asNbwBPEsJ2BKh7AJdAs8cicqZ+vrG?=
 =?us-ascii?Q?b/jL7tNZV/kmFGInFAGBeRXEhEba3f9GEefwbC9P1BqjLhB2EO7yvQO1WTnF?=
 =?us-ascii?Q?6sddW5eTpyKv0H2raRyInjVjvpPWDDoxfKR0rUXlY9ChanIcCnXTn85sYUKR?=
 =?us-ascii?Q?DrzR2KaplMd0BKRatDtIcigFzcesXkNSQtOAzG1HsKQ7txmWKoQBE1FhduWp?=
 =?us-ascii?Q?hdFKFriNDZB38pm6yKLTLlA1be01LI3JCWrLA42f+bdGiIxnHudbioh7FR5c?=
 =?us-ascii?Q?dnZi+Yl6hOwt5XWRfEzWN9lFDY/Cv7paTTfwrzYaFmCUDkmuGl6P3lTqXmXt?=
 =?us-ascii?Q?W+d+zHryLrLJG5nW9l7UEflk6LbaYe2nqjW7GsuAMzjd7oJm60dj8MZRJM7y?=
 =?us-ascii?Q?QD7MjGm5CTHLyX0co1pLB+az+/asfUfJo2+DFm1tG8cFiM1C2Xx3v1Qr3tM9?=
 =?us-ascii?Q?qNJRj6rUu1FVWh3IOwVptrTBgkcqwQwkFY1H2p9ZJUSixRrIEJPB8s6E+XmY?=
 =?us-ascii?Q?ttj2uhMec8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H5EEEmksxB5nY2IizxojE35HXRRm8/DB/1QSzYsVyyVgI96BpLxbIuv5TDkx?=
 =?us-ascii?Q?nUGpwu2dJU6+r3X915pb8KC9O5dreCxHz158+pG2Fj6dAGBEledNoRSGoX0R?=
 =?us-ascii?Q?hbO65fGcbNBhmktBgZ2vmYBPQBsB0lY2syDGxqUeE0cUd2r9ARBLOsowZs6r?=
 =?us-ascii?Q?TGvou3G03c+uNESEZFI58JjOQ60EdRFWaha/si8J3haXH+axt49E95RcDf57?=
 =?us-ascii?Q?vbmEin9T70GxM/I6kKe9bMKickVzch2GwVucyBZhjx2WYVrYch1nj9TyCpRH?=
 =?us-ascii?Q?D3j0bTzOuFiIpRkZxysQpHON+YOkT3Jo4gWIHSNf6RlgD1bA3wE7ONa3dLnN?=
 =?us-ascii?Q?MQ27zykqOoiFAJf+LhCVKLhRVr7yMezgpp1DhO3HeIzs4+BjizAZMMzRyBE5?=
 =?us-ascii?Q?4VQ5IMsQ2ve0tfUGNIFgDJAzGSmNJBp+nmNckIuz4+Y4UeV9wxAaC6k85kEJ?=
 =?us-ascii?Q?ZyTnGNZMgxjCp2kn9yXy3d3gcYf7k25G7xfdo5+J8yTjS66m8YMMuDBZKLhd?=
 =?us-ascii?Q?+oA4Zz484q0UmlLvbDJWR2YZRO9C5wu4qCvVQyo/cV6Xf23MW47rmjSOSt4i?=
 =?us-ascii?Q?8gyIzgAUlSqrYizSHaM5cTpNNalJdBGbGHEAuZSnUZJPabrYVD8zYlVofvMA?=
 =?us-ascii?Q?5jQ2gxzhomsXJI4XpWFcLHjkPZbl3ReZV2Iv4UV816nGs7RtY9ywpvEEH3M6?=
 =?us-ascii?Q?d37UY82AQkgHJ389AJxpqATWo+7813trld15qO08wOP7wptlSKTBtLxFqyp1?=
 =?us-ascii?Q?p5K5mq4BDwrw4ErAxSXgmqHMJmwrMkBiODHeMV/7BRLuY36DMVyv844QXfcN?=
 =?us-ascii?Q?5JXYB6b0PeVylkrKNvdTrz1aNY3GOeyDWYzbbsnDYKyAO8mjTrOVj0ZCSdxd?=
 =?us-ascii?Q?V1l1olpKmeAMJEJZSxoT4NugVaKwxOfUKz8aTEG8cK7rLgBGKNzwSZvC6E+r?=
 =?us-ascii?Q?TZ60eqsirzXmat2EcjPl25ppMdHGy3IbMnQ/J9sgxmY/z9E9OuwHJWp7bA6X?=
 =?us-ascii?Q?zvjg8HBBbOwzT0WPfDsVKH7X4LiJmimUfgZZmgn0zuXLHlidtJWJeQa8fqgv?=
 =?us-ascii?Q?bqEHDo6ZVh+k/D9MdKr+ZDNQXkGO5ny9caMPWLw42d5z3DncVGuDbtgJ7wUg?=
 =?us-ascii?Q?1GLNNvORRle4a8/329sxw5VCmtaA+NcMj0xHlOg8OkHs+zBaTfknUMZ1S11e?=
 =?us-ascii?Q?Il92mJk32OizprAwz+I6hfDG+f5USQm3BrAz3Fe5DKhO3+Rq+fHW4Updrapg?=
 =?us-ascii?Q?xWKhNg7TXgqka6KKCknRW16XrkrH9wbo07ZPDyRvtjmSI0Kz8389jwNNrVOf?=
 =?us-ascii?Q?OUwZQImlpAEA11s3KKAs/HNdN9uURSwzJkCT55r6laWcFrnQtmKmNQNXh1bb?=
 =?us-ascii?Q?DWShheY2RnxJzO+KOAGR3f97vhXpXHJ+Ku9Wu0v9i+qRbybf1HLv8bXf27LJ?=
 =?us-ascii?Q?oCEXhhTsPvH0NVJ6P73+0jAj/p0R/zyWNg3RaqPhpJO1OCqeXbABd26YLLMw?=
 =?us-ascii?Q?jIP6a6G7UJYSNhOAYVZHG104pJg0qJOHmW7DkhK7vFiCR7az3SJsxBwlslee?=
 =?us-ascii?Q?9D1Cn5vtkBFmiLwdXkc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b540726a-1087-4405-7c29-08ddd5194fa3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:44:44.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0L4SPqUDcaxxJuMXBA+m3YBuJJPuxs4NsJn9UIVDrRqDkc08va7Gss0v4bBIJNIw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9389
X-Rspamd-Queue-Id: 5AD1480009
X-Stat-Signature: krqheojfcesbzqr33kriw1wbkwwf1fns
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754505888-728010
X-HE-Meta: U2FsdGVkX1/kDBlTovJtVgwMXxjI2cUykUB/W7HRzOUAzhSnb4RGuf+VRyJINQywTkOsX8Llof4sssFO7gnyZs+XeJGL+jUcRiCCIdP5U3nYZEt/8C4t/XSOmVtq+clANLe2mxc92wFYDnFlWie4DofFCcfg4+hjg6Fhz98SS2PsvesGU7/hwdtCBadPsFPDhubDib9DGZHfQeNs/7W4gq1xbDUBxnWOCxeRv6vmQmF3Z5O9fWzZMfZV3lugUzd80Y89ja7HcsJjMRsiUnwIakSxhpUlK+TTVzzvXGTRvgPuX+etpptEkEReMoilPViPk/Gah8kd6Ou9btL2MMVEoPiijFtf+MC//m4HRg0EKaZTS07BKQVtwOhewRdluqqYnXL8/aHb4oaB9cJ5vY9C1GVjPOLnjlds+2WbgH7cATtxEBSwrT+fldl7bjIhw63mgPAYc5eClqaDxUTFepwFYe33oX+5dCOT7xqZRFe01WYAgni2up7MniU0F1ylKg+ZQA84KuPPYKAyQTT404SvN6rIPbBr1Jx2ZMWYk5PTjQchFVFicof6WF4OQXM8EkGuGS9wTGa+jJ+Fq6DpmVVSMVoCHbWDz8hHS10admUBMpT1nicyRHKNwB8DrrLqfim72lVp9bA6My08uv2O62S4YsyVgz/MwwqQtZgtPmya46qK4uSYr3yTRrueRwx8KMyI6l/eh6PPXi8srWbKBfGi3a+qWUdBq/M0iXq41ail0eprCOrF6T8iUxMzCm1K3qsweq0dWYdDiGF11olG5ameY+XUZtmYruOmI/0ayMsL8LhoI5sxY6Xex0DKY2/mgv0cwoZqxAY/qSi2mNJOm1C7HXbJFw0MQnEtdgGoQKugZddBfLnASNBqrZKxFygX3q1p0h9UaO+itoAVJpTdpI1x26dyv7Jx82fs/1vdsP3HbVI8WFI2AExlynrqFVNNCAlIhqevFLfTphFREINNdXM
 nJw9NXfU
 EmIa72bSYZUR2CmGaHW6cILva+ZRaln3VazmAb9NgsC8jCOZM2oI9WIkmUnW9E2JMuvRyvefMYQIeJ6uPAZ6uF7Bc5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 03:42:39PM +0300, Leon Romanovsky wrote:
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 399838c17b705..11c5d5f8c0981 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1190,11 +1190,9 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
>  	return iova_offset(iovad, phys | size);
>  }
>  
> -dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
> -	      unsigned long offset, size_t size, enum dma_data_direction dir,
> -	      unsigned long attrs)
> +dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs)
>  {
> -	phys_addr_t phys = page_to_phys(page) + offset;
>  	bool coherent = dev_is_dma_coherent(dev);
>  	int prot = dma_info_to_prot(dir, coherent, attrs);
>  	struct iommu_domain *domain = iommu_get_dma_domain(dev);

No issue with pushing the page_to_phys to the looks like two callers..

It is worth pointing though that today if the page * was a
MEMORY_DEVICE_PCI_P2PDMA page then it is illegal to call the swiotlb
functions a few lines below this:

                phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);

ie struct page alone as a type is not sufficient to make this function
safe for a long time now.

So I would add some explanation in the commit message how this will be
situated in the final call chains, and maybe leave behind a comment
that attrs may not have ATTR_MMIO in this function.

I think the answer is iommu_dma_map_phys() is only called for
!ATTR_MMIO addresses, and that iommu_dma_map_resource() will be called
for ATTR_MMIO?

Jason

