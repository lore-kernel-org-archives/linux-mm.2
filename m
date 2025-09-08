Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D30ACAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10848E0014; Mon,  8 Sep 2025 08:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7BC8E000F; Mon,  8 Sep 2025 08:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6688E0014; Mon,  8 Sep 2025 08:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDADA8E000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:51:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5146B16012C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:51:13 +0000 (UTC)
X-FDA: 83866068426.08.24244D6
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D2051C0009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:51:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q04TGYks;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OSHuO/Vc5BKJ5cHo5+Vst34M23kDq4EdFQN0zPkUWU=;
	b=N1QHRHAPLpj5a/3pLMWcD53hjgdWdaFm91teRnfisteCWy4BTr4vkZkxsSnsSk5KrD+OHe
	iwt7geCku817iQc/N1etI+cCWc1ZaV9G8Aikb+0jy4Ei7l5n1/NqAxWqHefG4CpZvAOHSX
	35bRzl04X7MoYJwybH2ZzLNAgLJiZyI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q04TGYks;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757335870; a=rsa-sha256;
	cv=pass;
	b=u0pDiAsUjVLdEP2E/QU3cd02Vwq1Ko22qofz01q1xY09+NwYgQeni1oX2TrLnoHaBRrBut
	458ZBAiq/rDP2Qq3534/H3YSRxgUhJqtC1vMXsbdZTCUBw/9phTMzGbFn9bB8O0r1JWdu4
	Kf2G9pcZgDccvEXGw8rs1SSdMs2dCls=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMvaxhUHleRxntZGYNAQ6oYMMU1JbeUP44toucYGKbizGwaVMRXKNbkyUFUPdd0e5Cx1IPl7vdp6NNOfeScVoPrEkHkhyxvyg4Z3WGpwprovcRWpUbAKPj3LpU3yLKYEGI4N/IBMz8V4RdV88lY/2ZC6Xue21KFvFMzNVqI//cN0BaviWdnunZkApyGcUGQYPnAfZT2SAd0F2w5Bh3reSRHld3eTwjTzhHpyuc9FBQOxUCbwFN4OtNc3B1ZiAyEbVcyqhEP5hi8KOmS/QIwrn/1kwgtzi/wnDJRZhlfqlp2fv4jY8SPduKV85cq+NgFbmtVBMuxznJWsv+Kl/L4G8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OSHuO/Vc5BKJ5cHo5+Vst34M23kDq4EdFQN0zPkUWU=;
 b=mAunikoQejeLXAvW4UoM/ycWFNsazJgGlsg2fFTcvhHr61/n9tobPBooHxj3TwWiuVwbSxm+AGM9klT5+AuulVxt82iMD+bqYOPay2LMN6Ls/xLRH5tMO6XW6R8SCwTGnLOYkS786s5iFd8HhFP8FgGqQK1nu/tRrY3hs+ZxLXc1GPyp0jAO9I2FD22OG0sVxSlQz+Cui+g2Oh0RartMJkUtDClkC0e1hCGEwoGk+bGiYer6erlnkqX2KXhpOBAKk6XGemXPUeOSV94gPD5qIE4/4g139jRdQ5kWOa+kqk26RabCHPWwcwiGEbQK6CJe/dcp4u4ZP4nWHjEKIfUt+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OSHuO/Vc5BKJ5cHo5+Vst34M23kDq4EdFQN0zPkUWU=;
 b=Q04TGYksIpFK4xKfPRXEpzDwggj1q0h+qYk0d7ZqmiIFm/0+DHpNdDkdmeqzhhmXNAxK6tDOsuNUGRIWSKaYTIG5AMBKPLb881wYG9gDr+uKXm6pyN+i5BynVcOpCxZ2Xj9hLjy2NgxwMI148lzpdn8BjAPTFj0x2TjA/p7nkI88Eop1JBFS7YAKe198Ojyk3/5COGrqsFV0lY0oDkcIyIBQgaxVlt23FiO/RU/LEHPqbSl1ax0qIjVoD7hcjBGQApcFaHSnC50dJZrkJjDEZ6kUPkw+ig62UravuzYtDCPVW6GSljOVxfg+blItmKBPDto7qLkD4i/X8iMtCzzmJw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MW5PR12MB5623.namprd12.prod.outlook.com (2603:10b6:303:199::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 12:51:03 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Mon, 8 Sep 2025
 12:51:03 +0000
Date: Mon, 8 Sep 2025 09:51:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	ntfs3@lists.linux.dev, kexec@lists.infradead.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
Message-ID: <20250908125101.GX616306@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: YT4PR01CA0026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::11) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MW5PR12MB5623:EE_
X-MS-Office365-Filtering-Correlation-Id: 4535ed58-2ad9-4ee8-9dcc-08ddeed65ea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RK/YBv5RNmNrwTy3JLCS1Y1nfiWysNq4+ETCGrZ4WZi0XuFOccD62zIDAlil?=
 =?us-ascii?Q?nUIP8RZbII+RXqNS05kjw5UbPaF/PQU6Be88QsX5mxma/KsXEZF7cvvkHZO2?=
 =?us-ascii?Q?rdqeSeZr5YraoB+Cr/Qk+akQ3NZ2HayLh/VudWRzntdZ0xpxUPq6FIO8Kile?=
 =?us-ascii?Q?s5FE9Qjp0kv25LidB6vAS9HybJ3yEyF9t2rnW2VpddB1fNKdEZe56IS6eX6E?=
 =?us-ascii?Q?CNOT3HxG3Wn988IPGJ4oKmmJ773At2GItnm/lEMmWSvBJ/UlzQfVoKODwdLA?=
 =?us-ascii?Q?YHPKlBwJG72E7OotPbX9Y7qXLKi5smIS/C06uKbhWECr8idy/CU122C7Yl2b?=
 =?us-ascii?Q?XD/RcFNqYQKzWVGzR8QrSIdDPn2FcmtrBcApFeOEdixuVlIm4s42RCtTm/g2?=
 =?us-ascii?Q?xoVhUsJ/N9dBbVIisQWF5AllOd5e1+XYYdxIR5Kt1QkwioLJ0KyTEDeCTFGy?=
 =?us-ascii?Q?lUQSASAg7/1Hj0swNb0t1Ed25d3dBPWK42qlFjWUlSpl7P7+on6HWCSw7J+e?=
 =?us-ascii?Q?4evEH2DAzAcbmbaUfUXVlalDx8ckqV5vjEcDB8DUEZGowI4ViyWSEC9K3W1q?=
 =?us-ascii?Q?IS3Qx84Oi7NAkm+WfOV8kYFaOogHkT0ts40/8aEY31D0fzCIK1ELHnrHzNkm?=
 =?us-ascii?Q?pUho4uxM3CqCKWfugqZ0JFUHkK8PnIcJR8ya3hxr125S1jpyIiFAGA216uw9?=
 =?us-ascii?Q?t8xdXPAmkOsIbHGh4QhvB/xbPrYwie4HqCCIIRIZxW2paXWxmBgo1PR1RU8e?=
 =?us-ascii?Q?MWbad7VZbjodBwhrL8xGFZd2vvOuHcfbJQGo5q0Ep4zMsQgxP+kQ4LiLCE0j?=
 =?us-ascii?Q?IuGz+MOgY6XXyZuwzp/P1xdHoTpT8M2XwdxuYR8BxH1N5m8PW/HS2dH4TVco?=
 =?us-ascii?Q?VNUc83r6YFKFeighj5ALqEIsRZ17wUbCbYZ2ri2+pDTwKh0bubzc86Tu+9LG?=
 =?us-ascii?Q?kVTyxhhlS/kRr6ASBt0DKNl17jpla7l+MAXu0TOJiDcBvGx/UdnF7JJ+GwSv?=
 =?us-ascii?Q?v4MDkLqydrts2aOb+01r6FIi55aETunKug+Es4+4nRMT4ptW5icztTsEv6W9?=
 =?us-ascii?Q?24ZT6eRRiIikbgND645qTHgusuaJ3aoQh4Ls6apYRamNS8yax+yeynAo4jZ4?=
 =?us-ascii?Q?rO1fa2RoFM25adezfrSsYLS5lRFOWPfVW5iNIrUfNnVpCiJONDJJ968TLeaP?=
 =?us-ascii?Q?IiBCfqG4Exa36ZYdyC06vfK50GLf2FK7OjtjYkKdqOwC4QoRwoTlcPawz03o?=
 =?us-ascii?Q?gYAmipXzZVQ6otp2+Rnr+DIPRziuykb3ofJH6c20nxZlHmIqaapEiH8V2hXG?=
 =?us-ascii?Q?mNf5NZQncmdcuZ4E2h/txc7MswUwwwhSNPG/zJXwB169zPSwpKTXduIf8wCL?=
 =?us-ascii?Q?zO5m8DSRVMxSCZNcagD8yJrV5fMymM7BQeMJQLjj47O/uoc4a4qBg/ug4B/Y?=
 =?us-ascii?Q?xFwDFI1zPwo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YOgrbUOulWOusbdk/vwY/I6Z0hEnYRMIwKYZWRYlkMsXhv0unFY8GITjYHEW?=
 =?us-ascii?Q?FnoYUxSTvZfH+MbxKuG8wvPbmhco82reC6g7tADJQk/Ne/1S81ZpK1+qlZfD?=
 =?us-ascii?Q?6r1tXru1+1lkTFks5IiZU5uNdIkDtH3gKk1cMyhFPNNlLcaTSUxy3wHKtOIT?=
 =?us-ascii?Q?ONWrZmv0N8y5ZrAEe0bjSPpBkRWfA9gLXs8aoL/+fqWNNTsF7Ytv6yiDWEL3?=
 =?us-ascii?Q?c8JBkZgNXWp33U1/D8XCrMtNxeGGECxEQklzrNYwXQv5Zfm3WcjN//xwIWIz?=
 =?us-ascii?Q?6YTjg9IEV5hfrKr+uvzpsMEMT0ws5155Z0dJkdyoQ02LwQ5AQACKhh2hcUNs?=
 =?us-ascii?Q?OkYpZIu1LiG3M6bi1ezhol1hGrg29Tn8OdoZVPRrItimWlN5V+r6tmE58NfD?=
 =?us-ascii?Q?ooDp9ZT7dklMIKGRsL0PPbxXJ+8qQ9BETZNakHq/EQWunHRDuCbz0G/bIH41?=
 =?us-ascii?Q?/klUb/zRAKYQoU22ga5sIoPqi/OzPKt+d0um5OobjK6BIN9r/XzddQEa+TsZ?=
 =?us-ascii?Q?a/GVUuzPC87G/4dV36GMj7j6f0C8DQEuLUNbs83zQ0T+E9wvun1/sEwJUuiG?=
 =?us-ascii?Q?gvfijF6fhL8wNQoD/lYo1kzQRrWRfsDzI/ywhPEUANQyo1rTcYEccgEqaiFs?=
 =?us-ascii?Q?lbWpTI2agTB3i3XmPyJw7KG6SzrN4OIIeslybDy7xA826vEstw8ro+gQDXO+?=
 =?us-ascii?Q?2sjqodoscdkfv3a8x+X9zgEisXkTTwhqO0eayayzehCwNKZs1GTxBzWucVJK?=
 =?us-ascii?Q?s22no0ChtnK24gCSESJApYtZAn5D/go5ATo3i3OtAc1Oi2YxRIuWr6Nkm0q4?=
 =?us-ascii?Q?eDxkbPA5lehfuCPidPixQoghqmDqqPIo6vvQBkK9DuqhTjrYlFDNaYdfj6D/?=
 =?us-ascii?Q?AfDc+aROynD+8LQScdbXCy6FrRqr/YarM8tKdVJjK+UMotbYGicjMHd95UFW?=
 =?us-ascii?Q?h501mXq1jmhhQZ2R/IW3LQTNdszvKZV9hg9WuFBEidHEkT5RSUGrgp6bosAX?=
 =?us-ascii?Q?/cgE4rtBChfs8qOWdd/RrwfdBT0fE6so+0nSI4GeOb57wwtKAxWqAShaHLF1?=
 =?us-ascii?Q?f0GsySe1WFciFtdY7OQSwzK2T7Z8T/SZNoGEqngNSQ0Yr+iXN3OcuORMBHbw?=
 =?us-ascii?Q?GXO3y8XI4U2Ab6laC8IbG4E9dZu8fDBBoEdkaAGrNZ7s+UfP3GFDy0j19FWR?=
 =?us-ascii?Q?VyNR59v23zZ6ZVdtMoYTT9cNJHloAZ9jPdrUYDTGVesEoYxEBtlHBYc6yOgG?=
 =?us-ascii?Q?QM3OCOxzWNSqbgFfZOHkyeSBwUDkgr1r+7+9bW6GX6+r6g7n7BBeTZBCsrJO?=
 =?us-ascii?Q?hr5cc0JW2YZetLCZ+OEWv5beZ8ksNlcnDTuu0Lydd4Opj8sUASzCLaaYqFt7?=
 =?us-ascii?Q?ZC2yXeFf8vUhJ6m4qv33HWVMd1wBmOqtDgU7i/DWmD/LSLrbmUoJYUmOkf7F?=
 =?us-ascii?Q?kOJZ0vqoxjg47Gt/Y4il4nlQioOgNhdhsCq4ojUuORoHXL4spuE2y4YSRggx?=
 =?us-ascii?Q?CnAhL7Ev9UBO1vyGa6isplhSj+Ke/CpF8hqBx4gCEqS+gAUqGYr+06lH3PP2?=
 =?us-ascii?Q?ZdmjeAbLBE+QQVTIYYE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4535ed58-2ad9-4ee8-9dcc-08ddeed65ea1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 12:51:03.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPSYzFEjHMyzJ4cZEzUHXo0bko3ctFNuaC/vuTYRitLPN1OBS4RYznmP/7soLPCh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5623
X-Stat-Signature: howxxmcaccnyju7ansyj4kfnbxtob3um
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D2051C0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1757335870-38172
X-HE-Meta: U2FsdGVkX1/WFwy+Y5FhMuAa6tS4n/dZ1ELIrF15zbDNSMsNMRYxoWV3MS4xTgcd0ginp6N/UBpISarK3M/FyjPh0Bi5z0nNGIsdMxBiPctU5nylMVjVCAZtFg8nTfPe3Cu0044wLYw9R0aWNdkRrVhpOZlki8DSqwjMsrQ1HAPJq9TBjLuY3Lo9/ieOTPn1W4NjNsvX1/T9uEheljd3jLVLx5eodVm1/l4daQ8W9QyEzk1fQgI6XXREli2vt0x6vgsuXXwvBWTvC/pLJBV/Jh6tKd6bhP/8X27qojqcfcfyku6wjt+OO8FYsy5w5mhyKQDM8Po8y2lnxGxf8l6qhJEIOc3Befkno79qyqtmChaEvh948U55ntDe9QYmD/pZ7nCqBzvuBbv8ErA4t5rkUFmw8L00zJlTsrB2dVAyJvu9yF1yHnq9uxST6Sx6yyGnnbkfTITFAyK1FXE/ZXoz5hDj88b6DI09R5P9A811D8K4rC2bBkeXsDs8MGiwTI/5nk4y4/22CWWDHtspkAfjP9CftskZ9KfShhUFXBqmlX3woGaJFoJcFttUmjmKbj5y7Ik1MU3ro/DDL1ehfe8rcYoqjXlLWx7W+scYmxU1r8v3sYUA1RfuCA8a/ZckToWbAv+Th6PDoZSmTTa2H5pe/FsNCo53LJujkpE15aXQqGDXsoqB7FXFfFDDrNQicPEWMGQ+sWJpEom/oYFhQHhOgVJxahRkaZ/zyPxLURjRFIUgmMSBN6pQWMhAcTOjAOFL0Wk6pVnA435i/LrT0b9lVGgSBZAAZgNc5BK0uNJsF4AK0rL3CdHeL0QoWI6my8mUeH/hcEoVCUaFE1R2p7OMyGdhMkMcOs5hAQu60huM6y+J2W6PgHgBmn5EfJsFpYff61SyRrMOO8R2ye/r2ltzwTIyVm3VnJ0o07it29QObioVgZnwP8KaqBGiWUE3wPZPyiL37KTR4Klpz9PHX0g
 Qgqg6w//
 p4MFW6vkA6GYHnbKdkJPWEFGIEXKWGxpZ+j46OURMjZVAKsTXpC/OWpo1ieM0EigPxab/cx2B5PEPXuWvDMhrY5pHGbprbMcEKwmRnA9y0QdXRvFsZ886Z5kxWntCuTeruTD4KOAFec2v5FqO55tu8bQ6zLR/J2xuQSfRsXY+ebiGiNOGxgs5wEL/TSSSuyByZ6aYNtZu51g4r6pg4khClGTbYGFUnLCx1tV0bogHRdbY0Yd9MbsOlxGr3jhxuasNPkKvIciPbI+EqZ2GCF8ZbSjDBETWf78qjF0Wgz31AUEEZynCZukICW+wD9pf4vJdC67VhvNMp+1KdWVb2t4N1OtaPEVUlc8O9h72KokXv775Xzdm4Mo3RlPSp6o+ahD4XA0xRyiLZdasN+q/zGN9228pW8uBP9mIuhlJobG0qqgz5hQ3idkJ9HtZnQsT5cGBX2pGamB+cwf3LnZZ+KbFLBcz24ioT44urEjIrMFbokXiggNe7aASl0/502DV862g3+YMeZ78af1QZ5V4gTkTgz9mx36zQ6dO2h2/4dAZMDD+npOE8DsVUp9fXd2C4s8RB7rPjHghyyg5a+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 12:10:34PM +0100, Lorenzo Stoakes wrote:
>  static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	const unsigned long len = desc->end - desc->start;
> +	const unsigned long len = vma_desc_size(desc);
>  
>  	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
>  		return -EINVAL;

I wonder if we should have some helper for this shared check too, it
is a bit tricky with the two flags. Forced-shared checks are pretty
common.

vma_desc_must_be_shared(desc) ?

Also 'must not be exec' is common too.

Jason

