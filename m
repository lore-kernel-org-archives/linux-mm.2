Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD0AC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 13:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786DC8E0005; Thu,  7 Aug 2025 09:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711158E0002; Thu,  7 Aug 2025 09:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589978E0005; Thu,  7 Aug 2025 09:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41EFD8E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:45:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15690C0DB9
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:45:42 +0000 (UTC)
X-FDA: 83750084124.16.8C595AF
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B0D440014
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:45:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e1cuXmoH;
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.83 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754574339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqFmusTHMkkxrcuxFXcvb9JKzx3GQS2+1TQSkSQmtJ8=;
	b=jIpNx0JjwrQrNkeI/UK7/KD7mYiNvZrTotYgOA6b/EuGX7L8r1gpuKxrilWFdwKYNlDb8l
	W/vM8cNeyna+jLZ3BrXQ0VKIbfAGvkKhBZ+Mq6Cu2HTHNjvTekTxCIYKhBbeL4sZRlw+CG
	R4LLbFq1t+Cys/X/d4EujdMm+xg52hE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e1cuXmoH;
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.83 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754574339; a=rsa-sha256;
	cv=pass;
	b=oGAPESSFe4uzcaW5Pl/UgKNnwW+F+AZWj7v1PKIIecjWZeOsRVztuv8UKS1IY/ySV2IBnM
	nu8VrmI51BM64KbMGkPI2Td0t1g3u3GdfSVXW1jE9GCeA3TgyTTkf2jEJJ1k4vzFPn0+bv
	fugdMjrhk6EMKxWSbkEkb2uBQL4NtAE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wyPo4KZx1mo4QWXFJhOemGlhQ0nGX1Ev42fztgGvIhBIaWQUfOWPbsaAfrZ9mUl5L5gSc0ru/bDbZs6ytMod5hKqeVSatYKWSNuPDdu+qJRHj5LV4d3ofbLFANbU+qYQmU16FYm/v9/6+oY/2SiR7c88L9uPNMOn8SmLwDiFr7TQ5vNZi1Y1my8JcJkELECA73uxCtAsQ6soCd6MBPKEkGSi2PYnPKzhDaey2I0OgVRntSR0U3TlDOM8g1+66H0aJMweX2ApsSuOuuIsoWLmq6vPfJUBDutY1O4L3jePQGc0ayAhZfEu4R5oemeGKRRZEeAAm5kuhGgPv0JD3mgBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqFmusTHMkkxrcuxFXcvb9JKzx3GQS2+1TQSkSQmtJ8=;
 b=bV5NWJNRbBciaVnywm3XVzKQOdmouKrcuLgG8M2+inVQXL3Di23KJT45Yiu9wcFVbrgijTdw2JjAgRWYcVfBkXZ0AHuQQVf5tzyBRM1z6M1gNrFcncF8nxfJH4utXGj0rEMNy7CRo1Wl2jXYvWd147mNPSRdvOWjLF1NrAU9OX4CeFpRAhOomtV+9gvTASrhFd4h+SIYbOdeDpsNz56erpOvvicif1h561hizzpEWXUDsIwhGYAehDFHZcEuWXAUt9RMWA8wWSHik3zO33e//3c+iC4+erf0heO6vQtAJ8p8pQvUEj50FW8oQGCjCYON35mdvpSlCtLNSySaghXYwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqFmusTHMkkxrcuxFXcvb9JKzx3GQS2+1TQSkSQmtJ8=;
 b=e1cuXmoHKlPncJOfhxM0EK5STNf/i/W8HLj1PN7oh9DZUNgV9SVfoPg2iv8freUD1azJcfct2BSl+aucuJzbX36Sjme8g2cPsrwgDwy5qN4xnDEHS+x2WSJSkliRJZTcpzRXaOiEKc08AP0eTsFtnl+pktbRyE8Uqn0FjBbZuJZDyQJpXS6lhDaL57G2QqkLv7pAxriuS9bHb+kV227B8mg2mgtfKuFdUihWnqHyknLUlQ+U8rUqh2aq2dIVeFuxQl775rhEo0nKCbAsQzOtrJz4/zytof4RCcT6mbGA+Zd/9PabNyFquXoE2UvHomjTDotY0H3qqvzlmBiwKy3D7g==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Thu, 7 Aug
 2025 13:45:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.017; Thu, 7 Aug 2025
 13:45:34 +0000
Date: Thu, 7 Aug 2025 10:45:33 -0300
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
Subject: Re: [PATCH v1 16/16] nvme-pci: unmap MMIO pages with appropriate
 interface
Message-ID: <20250807134533.GM184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <5b0131f82a3d14acaa85f0d1dd608d2913af84e2.1754292567.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b0131f82a3d14acaa85f0d1dd608d2913af84e2.1754292567.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0366.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA0PR12MB4397:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e4fe19-3ccc-4d01-7dae-08ddd5b8af04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WDXvgPGUhS8WpBtlERwsgCYjRKS8Gfx/cjnHty7Q28G4eDSzV9wvqstcw6yw?=
 =?us-ascii?Q?4jfdhirce6xAw/pUbWg3fbu6nHGHyliFkKC9QDf1/ugii2Ei2+Vt0wpphiZY?=
 =?us-ascii?Q?aj4Nrly39ao1YlPg/VaPLQfHxaEoSaTgsoJCECUBIOjPO/QRSvPnFe/dSJMm?=
 =?us-ascii?Q?2uSEY726Har14PSd94XC/dZXlhatbVDjW26+7noxHKuRbNlOSyrdph10h922?=
 =?us-ascii?Q?H49ihXeT9u7QnmflupsSg/8AA6riMyH+fnr5JF59MTFwuNPEG2KPejhDlFsW?=
 =?us-ascii?Q?UQ1ZCjbx6MtvXJf1i+q91VDYUKGmgua3T61eVEbBKmuhsRX0O9qeZyBI2cjW?=
 =?us-ascii?Q?3lXGvTAysEYtawHM6UrdwDS/RiqE9MmYcIG81xSwc7jk/3gx5SKdBpdI5M5u?=
 =?us-ascii?Q?cHFOo1xFGbehxgBp5HLJgDChohFM/uyPRjbLcCKK3Bt4a0lDD0F/UEBVci62?=
 =?us-ascii?Q?qUcWzxDznPoUFBTU2xbJRI4elzPfnEAGc7PKT5OVjO4kmVoYdevktyHVlm9X?=
 =?us-ascii?Q?R6U80lTflsE8pkcZREytNdRvWz1LeLhh+yniYjqYtrx95pMjSPxyPL9Yl8r8?=
 =?us-ascii?Q?TcZhwTLyQMTe5V1NFnq0P8+0ZypVRxN1zbrB7hQMaMTtrHoYEdJU8GNHmToZ?=
 =?us-ascii?Q?aFD9hDD7obzuiUuATRs+PgE2LocXp/6b/vqjAu+iWu5EwebEQRRlwGjiyYhv?=
 =?us-ascii?Q?ybU6OeHsPkfw5DzhD1fvbQ8PqJrV9u2a4YYQsVMMSfuCNivbhlVgEU2Y2+Gq?=
 =?us-ascii?Q?QobKltiJ5+7iWYpfX7BYBIOkQxjgWeg9B67eZmPbJyIrEsUgu6AZx+S9t5Vf?=
 =?us-ascii?Q?xlNvfRerWFyk5Jo7VztKY7NXaS2SVgztXRcfSqefmGOkPNW/Fg5a0YJ1omE4?=
 =?us-ascii?Q?C56pKQn6BgULSoa2XbBpV9Qtko6gcNXUMDNepZsirersNub1k2FQVF8g9TR+?=
 =?us-ascii?Q?EnZdk85xrW3usda8JzmhlO/7bki/ARqgj/gI8zQcRQpNvLXWqmkpL/co6TLw?=
 =?us-ascii?Q?8Emj6s7KSTJx/THFAYF/KVVCEmw/2vQ3cZMdS3UMgalseKK237M5ioEIM0KP?=
 =?us-ascii?Q?PDd/WHWoBQ+Cy7dagZxx6LToQDxTPNDU7MOsRhNoiAzT+NUgcp8b9JklDKNT?=
 =?us-ascii?Q?7XWp1bJ5QnKGVGY6gAe5q7gbj+kMgp2iJbH4zoTHVTg91gDPcdp9/NAiwg3a?=
 =?us-ascii?Q?XRIdRCbeNhPzZaFWSbIFBA/saT91G3GnZGBXU1xQbPQGwI+l5glIegQQTXmZ?=
 =?us-ascii?Q?Llw91xo+W+2hGNGQ/hMD5QTVwtuQTQ8x0J8MXzzc296wQj7bExU8jncVqvFv?=
 =?us-ascii?Q?APhndbVrMQukd7LWC9/D9icY9CA4Rq+/nTh/amGPWSdKtkdSuum5rE7FL6fY?=
 =?us-ascii?Q?Qr3bIPoStYraRAe6EktVj33PwN8klTIuDqo4Wvg7SwfW8PSfL/JKrU3pjaNI?=
 =?us-ascii?Q?LRULsD5Cvuc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1UQX6TFMBcy6Vs+trTNtXib2FJeK9rtIhNCBceB4mjYhsDlm8RlLJE+/3YqU?=
 =?us-ascii?Q?NbEL3CVunkrrN+XY/L+YoKG47Xj+WtrQ79A6M6RaVD0SooEQp7A6DFOucKiv?=
 =?us-ascii?Q?KMe3PCuB9xxyFwSEiNP79JtO+ffkE8sN2nODlc/1eUZoszWsIn8+7zj4dfcc?=
 =?us-ascii?Q?INRXn6Bk1Ti1gpwzbhCwGWdw2IaAIFqxo1D+935OJ/3sREtvFKnd/CZgPw9X?=
 =?us-ascii?Q?cEx+tdXJFgyCVhX6Sfky+JpBeqG6aWrZ6WZoOm09ipkrCVFfIPlCGn5NNeSe?=
 =?us-ascii?Q?qSYN/KFyVtT28gPfKPtB6QT0xbLhMnBGSB+sHGrfOL0eR2LSnuMhFc8zsBFO?=
 =?us-ascii?Q?e3FIiQELp2lMet8pirel0YnwgKuIYmflzJ5t73L0KZVYii/C0APxPOck453m?=
 =?us-ascii?Q?CkdOHLWVXwizjQGIoMgXngtrShcYYwNADzjNLagLg0XeWFa2nIsJc5BqkMdq?=
 =?us-ascii?Q?EUqHMS0UXFZaVUcZa9Cb5iwFbUG0kq//aUK++pXzR2CODwXmMI5yZ1dD3UYP?=
 =?us-ascii?Q?EHrpvfaLYQHK995WzjZ8EIJ4otP/ebDucVwBjI3Ktffc1/9o8O+SNuuoWUM5?=
 =?us-ascii?Q?gHrqw4clcI4/OchmuM6aASyllQJnGRCtKHCUZFfDqAvYM2WCdP8BZCCvntck?=
 =?us-ascii?Q?Vc501vzs+o38MGfq18fXE0Gn7IwQGlGuq8kh80dVMN0jjGRjYe8OAWW7vWOE?=
 =?us-ascii?Q?6f10j64Vj31KZ6niN3FHHbPHqxrG8Oexr5dhz+/2ZLmSTaeKDs/gxB5q9HeC?=
 =?us-ascii?Q?PbZfpcmWARFDn2H03mjMoo1FbKHPVQSn78HOr+ZXdK97oi5swsKb3K9N/c1t?=
 =?us-ascii?Q?6Ojj1/QCre75J9p5ifpFyXVvTc31dY2kykDbII75dD3JyHMDn4F48V8EHlHA?=
 =?us-ascii?Q?hKakMmdO2KvfwZV2J7ZQMefKQg1MEdvWnz20raKOEtTfEnnwlqGk37Eujnpm?=
 =?us-ascii?Q?s8BTDEu547J+qOkK6B8AyuAdTNOsY+l8EZ1uOUSk+499rTVW4BH7QxrskJi9?=
 =?us-ascii?Q?3LQREu73jz7GJ3i8eRr4/OSgF0bx1uOyJuSTyCJyxvQsiyM3Q66kPMmDNOg2?=
 =?us-ascii?Q?zYQx+ezbZOABwR1PD+97X20i0ufTZp8AJaJlhb1/CGDAwSBggQsLBjAH/PL7?=
 =?us-ascii?Q?Gl2nwK+E66SH+FY6GsKqAEWTYf733qg2Orwuss2yPzEv4V/efxjNvHxFEfok?=
 =?us-ascii?Q?bLIoQPcjsJOxZCiaSX+ZMdInJENJGuCsRxG9gtieicufQqE/4QLPY9TtF9jD?=
 =?us-ascii?Q?JaPUxs6XhFDje/6mIS/2+xYzBfxNTENRN1+b028GqSc++LiOlGKTk0kucdOQ?=
 =?us-ascii?Q?i+J5mVsJgXlT6uU9fdk71HGmoH2SBDiSKrUx4FcIkR23BaV8Aa4d5m8LShgN?=
 =?us-ascii?Q?AnfrpcQ3Z+UHGUdTQV2s7BZlzl+tNG26a45wcsj1STZu8d/BeApaB3RaUX0Q?=
 =?us-ascii?Q?or3atunX0aL1YwD6kd/k8QuuBxhnDtglAopiolpH5JgiXzgo0+79zj6LmbUk?=
 =?us-ascii?Q?yKXaKol+waFIOYy1llv+zijOATP73oox90sNk6cTZrkvFotnMsv/4o/cYPiB?=
 =?us-ascii?Q?AZlMssGxT0v5NtcFpn8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e4fe19-3ccc-4d01-7dae-08ddd5b8af04
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 13:45:34.5501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQXX17i367Y+FuswGMUuSDPrOAkEDNqGpfqZ4jQggDW/X3Rs51lZS9V9SpsgjtzN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B0D440014
X-Rspamd-Server: rspam06
X-Stat-Signature: edj8p9tg5r54x4g45ru4xa4sot97tmrr
X-HE-Tag: 1754574338-352157
X-HE-Meta: U2FsdGVkX1/MtCIrqTvm0RzIQlUfyCEgmvPPnyiAjTCfvdcVwkoCqZvs20v2ec+HqGfL2Ezv+CeYFyGpeODY+r16k7phwWu0h1xWG6BOwcVljbyx4j52Cm1gz2P/EJnjAqUiqe0sAxuMVD3uHR7nJffT4Y8qtI1kFNrdf+p8ky9VDibIJFlJv8Ol7YsdX52iw8KXK6DLLTtqmoYXZHUQffISZp9Kc45E6DhtzPHRQB1A3PfMXpJH/GuSCLVB95hI1U1r6rT2N0PPw5KYTDV9h10PesbQkK/hZ/uyjBctuFhLOA4LhACB6c+Yb38ps8egK65G4IylByJJDTO4X3RSP9oLpe6cu4dcR8Hv8RpHTYKLkwMl1Cxb46SxSG3Eix23+alSqTVGoeowHXPG1J8w3ZoaRGaMjHbWZCkjOOmKSq08cm+MaJtuqWY2IREn3comPeRrPuKznj2WN/1jXUy2SL7DGdilox3q+AI4baItLy3XVRE/9n3GRbw68SKdozg4kaDUrd/fvu9GGa05xlTVSQSyEA0qtPor4/4XF7juLXT1ul7h81eBysfWaLJhNxahwSoJ+tCMpLOMK9NJ4bdv2j4YwdL8nSoIqaVXmAGbW6S6Unnfv4Gi+6J6P7XZYoKU9LfpSHIohAMZG2kLJcW3qmE5KeLGD4J+CUHSpXf2migDr9UvGgWbciAcIRvbHrKfidLSrDOOvAEQ/iZYl/SoxcQ9DyrHkbSXElCdoed6hrg1q/4v3TC40k9otjXBnvqkkKU8q+OVz28hhKAnq5vfoGe/O3rXYWgbx8c/gDpmsfkKa0HAD8iDU4t9zHqLdI3JOPtD5e57dSx5m9bGt6GqPz14F5ebmTxj4P4RBipGNFB3uoUIOwekql3JjOHd1U5NVuqNVREkpxscf1Da5pFYU/Y6wS/mVmmtkr8fKPsedIXlpJ1XhfxBG8mNdIt5G3QX9n4Kbff5AP0dPL9wgli
 7DjkGwOp
 SedO4XXn5EWsQr4ccnMmez1Nehe50U13ImxO4NdjfHO/s/PsGz4xz5ZUFjhvdtGt93orgHCjCH3xuhKP6+rNx8BIfpDPReT1994ngE4Nd3xQBAIBbF33CYZG1UE6JJYHcuGVRD6e/BxFhBzqiG9sg7nZF7qp8Xkc0k7QRD019JWwoLUvCYYq9P0l5cynCiOCWG91L4Un/jGZL2Lemn5EV0OEsjd/MzLpfjc9EaWseWVfrvw7PFFDWL/ajp16H8z9/uUSyGwCVynMa0W8txMxZ5HD/lRGVvRb1Zee5Wf4coXru8Of4bUM8vm5MqM2C99IcrXmZBvEWUIJfGeOVtopgKPOUt/RUCRM7nilPVnyfMrvlnuitbNqrcB+MDb3RJPVpfBSjr/mYdF/ihAYNOOZaDwR/z09FmEIDIHMuqdZLj6+KUiq2sC9jREELHs/uIqkWsoID5AeLaMOBZBPVLjqAkemUkLD2GgVD7AyCjKOT/8o94/oy4wl0VkpRouDc1h+uuTC74Wv86qmBb42HK/7ZOdoDpu8N2nA1SCuprUabvolXj1kFacaZFmNIqiPmOWbhb3D6unZpfypjJfT7P1fXJJK3HdvdytyJDzt8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 03:42:50PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Block layer maps MMIO memory through dma_map_phys() interface
> with help of DMA_ATTR_MMIO attribute. There is a need to unmap
> that memory with the appropriate unmap function.

Be specific, AFIACT the issue is that on dma_ops platforms the map
will call ops->map_resource for ATTR_MMIO so we must have the unmap
call ops->unmap_resournce

Maybe these patches should be swapped then, as adding ATTR_MMIO seems
like it created this issue?

Jason

