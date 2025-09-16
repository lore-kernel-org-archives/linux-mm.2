Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EF8CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432578E0018; Tue, 16 Sep 2025 12:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBC28E0001; Tue, 16 Sep 2025 12:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255938E0018; Tue, 16 Sep 2025 12:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA378E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:46:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C977716024E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:46:45 +0000 (UTC)
X-FDA: 83895692370.13.EBC4563
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1296F8000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:46:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WthhqDh9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758041203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fD9pbvz5idVivI00y4IBedK5vLEhUrKfz9h0Xx+4ku4=;
	b=fP0vq3r6wh8P1YP2YnFrkieDexWonFIt9Rth2eln8uegZfCFVZf6CkLT8o2uzWsS76VU0x
	aVM0a8fosKW6YDvArgg4HDYH4t1jke2T5CQ1De7XpGiNBCvf0XRGeBBUGQRGKsqljA6NbB
	2nJgxb+1wzWp9uka04cXR7B36TSwQq0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WthhqDh9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758041203; a=rsa-sha256;
	cv=pass;
	b=bDkZ4qQuuogiW2PcSfauXyZpEVcYcjyofCKCQc9eKTzMRDfRkcxmPZRNKPApjStW1UQVCf
	229MXNZNoAYx80eIva/aq/nk+1ih2N7XaedMqffl4O9RoAyuBRwOrKabnWhGSTpjw+6Txn
	lVk/lhWyBKDGxmqS+6G5L6PfO+3hpyk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlIw7WZt63CFHbMZGXBeMQdCkHNb+HI8H/puesywKRO+L8ocWThDUCckE2eWT6dCw8pTG3BDfXkZyvdbYmZHtCfun3+rYn75ZRGcSsXfRr0rIUWosWVRgCvsjSw48g1AdwwJ40FoTMMICUKJTfq6F0LAv7iIwjbCPwR+3DplwY273qex0WBkC/7NAkyQB8zA8tIQyIjmdObKr9r5HV35Hatg5tXJJpJ+/goDTG33edveSgoS9kPal4oTYHxqt85Ut1pnQ/+5qaIyegoQeQ3L+qcj04upHUkaWiL+2V6KWVICWYp3GieOzSliDiiLlTEs8ltwLjvD8UEJSgfq4pCG+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fD9pbvz5idVivI00y4IBedK5vLEhUrKfz9h0Xx+4ku4=;
 b=MuF8O00avmFQ+3gJnqLmfYJdcdXcU2XQHYhu3Es5MHc5iPO50Ed/GALUh59co5egkd9TV0v434c80Id9FUy7JFBbThDNcWNqE5EkFC+78MNrrs5Yrm5jods5YYfbr0yNBB8xTzMNvl1IeKrPY+Zj5HKI2/rl/UYIN1izQE2Ch71D6USJ5iTzqMVtyVjonsMisS9X2SBCf9nU54LDAaLHclQXi3jT1SGryJvOeuLZ4iBN8l+41xjJ5kxMOPf+xzB5gmIGhYXu6j8GBFb7L9CPjX7mIIH1tIvLR40DMeLn2zeyHKHaMgOZpo1pFsuyXplJLLfFNt+hGx85L7jg1Ub9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fD9pbvz5idVivI00y4IBedK5vLEhUrKfz9h0Xx+4ku4=;
 b=WthhqDh9tfW1CQugeVZTGrpvzjq7C5CT0omiV/jxCPnHp7uxskV+DX60jVD/vkP2IX/iiNL86tyfTI5+4hhTeCjwz6lbAkHxSfrQXGgP0YvNtQYZgRXeL/bdMXHj8VZSd2THHXnTMPS4aTyVlY68a+dkCSefgYw00+LYloP7MvCHSbtyHFq/3zYp2BplGukyz0WM2Ue2daV7MIWQ175Y20QPSoRQgihVXwpZHG3t7Afo/f1xkYxhH5aUCAOYrAe/7XDTev810WBrQb+nOwzZnnebBnRdEzSVzrjmDPQPlPE1YQSdU86BRvHx9S50xX2TI1UUIsXSs+dYIOpaUJK3Zw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Tue, 16 Sep
 2025 16:46:39 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:46:39 +0000
Date: Tue, 16 Sep 2025 13:46:37 -0300
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
	kasan-dev@googlegroups.com, iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 03/13] mm: add vma_desc_size(), vma_desc_pages()
 helpers
Message-ID: <20250916164637.GL1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <011a41d86fce1141acb5cc9af2cea3f4e42b5e69.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011a41d86fce1141acb5cc9af2cea3f4e42b5e69.1758031792.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: BN9PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:408:f5::26) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: 05ee3b0a-c146-4ce1-7e82-08ddf5409b9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8U4K2L3LdZvOnLMw7JBvJvb9H5ue/hCOzaScbILF2thhIE3LVVseiK3Uuh7M?=
 =?us-ascii?Q?YEsvbWIHJ2xrVKY0S0e61InPuuJvawraafzC2dKoBi7LAxzp0T3YLK0Awh5+?=
 =?us-ascii?Q?KbhBCJJ4IEEFIqe+p6ZEqbzhSKUL/EYU1Z6+TtitBx3xGY0W9zdBlPLGA5wv?=
 =?us-ascii?Q?P1v+K9mW5dubdD6+rrKbQv2UKMDsx0BSyhO0h70ShCOtXloGQ8VeVELoNfB0?=
 =?us-ascii?Q?1BiAivGJqERm16pAYiIxe8kukQA1ljOSd1TNWdV0T3hq6Skd7XH52aeRbGWx?=
 =?us-ascii?Q?UjCHXLLfh/jZJuQbDLgbAC+0HodFCOw+vW34IF5HjG4T19WwJ4zu3l/DR4Wc?=
 =?us-ascii?Q?Mkl6rasAT+ZBPLVqHwYNwMUmnzynH/sNCe9s2Mb/uURXRTHiHCLV6qhJtJ8u?=
 =?us-ascii?Q?DQ2kA9Kcwp+Qv8Nz/lTUBDzUjy9NG541Sd27ob4IS8nbXtX8Z27U9MqMd6wt?=
 =?us-ascii?Q?jsacWeN+A4O0/Zv+v/6vFzfvwMkkEPKT52dymb0y/eUv0tQQm1x9eMAH1wZ3?=
 =?us-ascii?Q?UqwypNcy9Szw7epNleBnriGQI3OavReFNsq99lAJtIyJVuZSdCwyFtgVM2Zi?=
 =?us-ascii?Q?jthoffFiAxfhs9MZOFA9HXMajuCl+OdQPZFLAyRwO0wNh6KQchHIjIVeWWfo?=
 =?us-ascii?Q?E+qa94yunxUZzbPwDfAf8EnCJ4d4WsnogJ4jYT0tQcKl9QBkm4jV6WVRA8Gp?=
 =?us-ascii?Q?/wCnLhJdsTQEdU0ZYTghhQ5I974iBdFMY7j27R/WBKBYCJJtYEsArN8uyIrT?=
 =?us-ascii?Q?R2o+iJmbAYPQL4Ia+nbXRBcolOTlOgxLwRtEJtE48RucG5g4l+irtUTIdCTB?=
 =?us-ascii?Q?DA7azWzphBdUb8wIRk5/u4VJJRBaioW4ywoBwYv0w5emj+H0EpBxVt2/qjId?=
 =?us-ascii?Q?0pwEODHvD7+I3Y8TGEaM+viQfG3Cx2Y7YHCHdWbr3VQpVRQ+2vJY2tbb7SC+?=
 =?us-ascii?Q?HcqZjPT0RfWuyp+WdgGoTADdjr/ZRaLu/wLmETxG4UpmOEnqZL0qATNKk92a?=
 =?us-ascii?Q?1WPpNJS/AQEeR+maZFoMavrnrEwHq3ItW49rhaJa5XojSoIMH3xbGYwXGAI9?=
 =?us-ascii?Q?2GTO3ULeZJvE/Y5ORfj/msKANUIi+Wds8QXgG7bS3xeRGO7yE8MxbtgOWxGb?=
 =?us-ascii?Q?U83EW7ZODj1V3r1SGK0cfK+68U0GzxGs+8oNNKbtF0IgeHQUUgVKhAty0gqV?=
 =?us-ascii?Q?ec8UPNQbIVfBxXd2Kbtx9CBpGvDTzUHrC6gcPnMt8g7C+pHVcDGbF0ss4vzF?=
 =?us-ascii?Q?uD2ZeH2wdKIk31QniN9uZoGoXyxEG0frHHXF9Yodn3N865Itzw2pT/BgFZFz?=
 =?us-ascii?Q?tq2utIDn6kNZZGqZf7/jaigCbhQcn8Ck5ujAwXfXvYk0j6Q+Rcnqjtj6f4ZR?=
 =?us-ascii?Q?9lyesLcFgi9x+Xur1HQOiDEQ50AzVYGreA9HfBAutBrhSOkRWq1/gCkvZr7D?=
 =?us-ascii?Q?GuYJF4knzf4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EMIPA/Q1hjehLU75UDvX2LwzPpgCsTyItNZV0LcS1+m5rvoy2TgDwWyoqukR?=
 =?us-ascii?Q?rRL5d+cHq64wR5ZFopetRZJSE1iyVMAwpqEKFund4w1H6csVWF2DZroreJD0?=
 =?us-ascii?Q?VhIi3s6dQ0WAtSx79hlUOq7nBs1mfSJwuLpgqzNScYbDdas3r7RHoI6py1yu?=
 =?us-ascii?Q?g1/bs26fLeBd5wUkVRp6Fs6iGdUlnTQxBOffR9K6fK8ps2IHZZx64uLLcARc?=
 =?us-ascii?Q?xehIEK3xm8xKZ4ev2FRnNN6FpAdSzQWkVS1CIcPT52JMQlmBwvdU32DkaA9m?=
 =?us-ascii?Q?BIBzJpQYA7TNAROrwuihzgBU57tklVkZIJngIny0P2/hyc1heI8Q2C8gx627?=
 =?us-ascii?Q?MTg1q4K5U0SUQoIKK8VK3TfpnndOu1NKbsFVsPPbIgoxIm5tnmyyIdR3VwmY?=
 =?us-ascii?Q?lBMRZnUMRPMl+rlniHkxZMB15mrS2w/65HfYDMC+oQPKujhVVxXBgHm+sdHA?=
 =?us-ascii?Q?wkNuJIiJ0y3q/NdQY09ZJ50Z+yDKineAzOjZ2WfpltL/sedPxAbdaYXKwePK?=
 =?us-ascii?Q?h6vH0D2pHKdm7ARKPiLRDi/HhmVMM9JgyDZFG5smLXeyu7hkfpyNSQ91vCr1?=
 =?us-ascii?Q?dR4lgDedwAfs3bdgprQjP3DfU5FsLeKgiI4QkRZWLXuXVoaEM9MZVSZypil2?=
 =?us-ascii?Q?cxT/sWa27Lp3FfE045LKOxM30qZ1f8KWXQ9U9ETT39MxNOTCcc/SwV4DjqPc?=
 =?us-ascii?Q?57flG7m8DeMXjlcpvhjjDPnj4VSl1Knr0IjGpVQlP985AlXnDuYaC+OZG1nL?=
 =?us-ascii?Q?sqx0WofSoJgeVScftrIMl5UI7IOvKzbYRPzIkxaxb7mg706AlvTf21eZy+25?=
 =?us-ascii?Q?Nlv2i+2RYWaCgQWV3++GydrlWY8zW53NwYSLjk6/xrp4tSvjpBJxXMixiXSv?=
 =?us-ascii?Q?CYWMXTXH040tqYCNV5IdgkF4rQx/in4lBzRR1e5QXiMqjrV7YuE09C5YgD1/?=
 =?us-ascii?Q?pOrC5rOq5zb+jtBHkmwGCM9GJR61bjUL0piIRWRjPIxNRtKWl1UpO2TiKKqe?=
 =?us-ascii?Q?RvGcC5eRE7YYjuyvtSbgb7UcG2/HAwCMs1/Y7smfE2iNUgXm7NKIvzODzuSX?=
 =?us-ascii?Q?432XwR5Q/uyj3z6qaiztFAOsd2RsziCMq95Ef42TgzpRe9q59qTYSkePtHVq?=
 =?us-ascii?Q?PTqNnua2dzUiRi2Y580TKJAP33XyvLEvQpuS+b4UAnHaCkm4mH8hzrT7p3qm?=
 =?us-ascii?Q?9imYMwTAwbEMiz4EZzb1WE+Axdosx8G29C41bhSR1zEHQZrN3waqh0FY56UQ?=
 =?us-ascii?Q?XXfIIX1A2ahMLmIALrd+hPFn1KDvX6lZWVEZ7SmbLi0H602FDjIGKBxkCuLB?=
 =?us-ascii?Q?ijz8G+zTvupIRcYvbIu5vJQyvG9uzkogm/pTS5RIvWAy7Fadx0JzWYRL41Gf?=
 =?us-ascii?Q?0RTLkmMvXSYI8+NpAlfMBRBZunWcRCB0u4NGVwmrC+1bNjzox71icrezDCIm?=
 =?us-ascii?Q?HnlzvOEEFqOdhTa+ol1dg3wuMZfBu4LP1IC1lMzZkItL69DmsfSo9/NMcKAt?=
 =?us-ascii?Q?zLIINhN/WgIg/GZv6WsWrXMqGa+pPWIlZ6jMzcjV0VRPTWcYh2xzp9WlF6Mo?=
 =?us-ascii?Q?FKEiU7Yp4vsEnbIn4C1qANL8WeKebS3wtrsAGGXL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ee3b0a-c146-4ce1-7e82-08ddf5409b9c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:46:39.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYEwjTCmN5a537Xg/7/eea1z/fHEYq1OuBBBCM1K62t6N8FS1ndcy3+msldZ0Agt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257
X-Rspamd-Queue-Id: 1296F8000E
X-Rspamd-Server: rspam05
X-Stat-Signature: wnwyeq775hpfjtppwf3yqf5pbqqg5qdt
X-Rspam-User: 
X-HE-Tag: 1758041202-216174
X-HE-Meta: U2FsdGVkX197aHYLGC3sxLFNpsEy8gcD9bnPeJCfH3WZqdCY11hq5yjPezmukvnrxOW5Bhe95A+uYVdkrwVffIuNLyEYauYVctWpSQTUK1YXq11ylKzwMWgfEpXQG3lXnJ+j9fix8tt5yKCkLPf6tuYbMGxw3opHrmQEGUtduvuStzrXoZB+ecN5af4351eQ4rtEeAQ+U3MiE9wViXB0FTT8OWvYftEDeTiKDIcRqX4kt359Yg6bkTpeO0141ESbkd2s1sf1SoPmg2gS0B6ZyiFCCnERdPg2eE7Ofv6Ab0Lfs7uJ8NiBvUN521dIMYUHhH9/+dvOylLgj3DwYk+0ycOlXY4oZHGrbgxryNVEUWbxQKkI14s6nNoT+xxXHYWLvF6UAV259jZWK5QvKvNN2CWAu8GkSduX08ts0tzmtOrmjIM879rOUlARcjZnylGq87kyr2EADwIDtRxwTvFqOvNgzBrpDHbz3OSqLgHN58uRpUu3uo2M4X5Sx+kcpGAGj9QZkNc7UhsaDE2CDSViHgblx+/Ks8Ai3BXaXSMgzIv3Yzy5fD777BT6r5R8hUgFd85l5TTvpM0811nF6SInb1/5tnoFDPoNt0nJryeBW0niYIlyqQ2rdNOk6w3Vbt5fh6pUGslXEZjCvn7JEm/koIp/MYeE+8abhSsWOL8W9UQuAnNf1D5h8dS4pAutPC5JM635DvUwon3m9Qi73r3LzsDutAWLVHPhrz9kQvissxw5Sno/ZZu70lY73UqXeEFONNEnPpsB1fFYFkhEiufAT4VbBM9Jz2ZYnsEuTdWtp7dO2/jzDwPNeTabaNSa0Z7v2j9cd3DrDnpUw19fFPorcrVan8xEyY/xrU4uZd4+9a774z/xSiDdUPcB7sjrWkHV6YV9UKOzZMv8W/Q/GAYgSooudbPHBGGERafy/bCTXTb7aljEuiCStxceGQaNdst/FGdMADiepozen/VZs9B
 xPfSeKQ7
 3hoyBmNnoGlb6zO6bH2Dia8SMsivasZONdWaAfXWBG5vmrRWnr1IMcZoIt99FA3qBV0/9mRelqSC7hwwbrE7nq0O4RWo7c4q1FYROkGNF06Uo3vtbL3ettxBcihbTE1vLgCrmJy+z3eiYPxjgpCows7xaM2pH2QkMsp+lqvTIhUsnUJsmgpCZZ5mBNzpqgehCUuf4OtFkkQP4/Dv36C4q3sdxXcDykvdeLAUEPSoGHuJG6qxZhbZEFwLgxK3bq1E7MT+Lb8gXf0cr6SI8FB5ODs8Ad/Wlp77ceuG5cHDB5g6+/dhBmcEPGZRqKNgLKkhRJ/p+6bpcA/5f/TmETJlj38yyGvAwvAAjg2vVxC9jQM7Gda8N/8Y+wIj+fLuJz7rOPqHbuKfk6d3OSVCHWbGpUil8GwUMr87F1YH36EphubZcu1lwqiWX7cfh4mH7GTCJF9SlW2JxZT3xs7akTaJIDwqwLkr+LjN8rFAU28q4jsLKb8TpwWSNHR4tPqdOx0xj7bHNWisDdNTQzV1siJCM6wki7ubyAGJQBJMFG741TdHMOudPcmp7aG/QTawNBi+cmCQWYsRLw/u7sekZt9x/3O3B3KdKmrGpx4gNJjKkbPpi1y+3+v11wO1iGL8T+NJB4+iIOMJjon0IrkVbTPuOsOxwjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:49PM +0100, Lorenzo Stoakes wrote:
> It's useful to be able to determine the size of a VMA descriptor range
> used on f_op->mmap_prepare, expressed both in bytes and pages, so add
> helpers for both and update code that could make use of it to do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  fs/ntfs3/file.c    |  2 +-
>  include/linux/mm.h | 10 ++++++++++
>  mm/secretmem.c     |  2 +-
>  3 files changed, 12 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

