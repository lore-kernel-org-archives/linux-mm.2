Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD93CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D826B0007; Mon,  8 Sep 2025 12:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE956B000E; Mon,  8 Sep 2025 12:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F446B0010; Mon,  8 Sep 2025 12:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 606336B0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:03:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 023C31DBFF6
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:03:15 +0000 (UTC)
X-FDA: 83866552392.08.25DC942
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13C64A001D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:03:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pHEY7zKD;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757347393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dt9aTliZZuhRAufB663nCCMSTejhkiKkCRfqIGP2850=;
	b=JzNxhKAUESv1clnuK/q3GBsOmD6XUqauBe2cIODQNUL+QSASnNuG0baOOArabJhUdxEneO
	38X1n8aTlnGO4pPe0lbzM91OEFva1lCxskFdimpzo1C8d7LM3VozZe96wSw7h9n4XekENL
	6KbqDlOzm83/nemzGhy80UNNC8H/14k=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pHEY7zKD;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757347393; a=rsa-sha256;
	cv=pass;
	b=1wyijyRzC0nTazJTppbB0WqvI94rK1NT16VWi920Bnvayz8PHOEKsUj4nSgwvdNZ5lxfcz
	6u/9aYTJK43TvcyQZy1/Mjv3WamhPELq+mdXT+/mrhyF+Dr77iZ+o/oNGkvbvysn/m9UYJ
	DybLX8Ag3YeCsYbpbabOjmjnHb4eT+Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q00R0vvdxZ0D8Fhbc+CvT0111kr+RW98NYlUbHYS5vQaGqLHoWzXvkL5yW1kVoZiUQG0U6qE73y8HTcR/gf60UDKPcnEk3UqtbkjYY73S14ErvHf3ceHk/3nsD8hi9fu5u9YjkzcPaTt/Lu8chssk0AvgE4COd/XgCcnnxyYlYQvAAnb7+Ccdd0wkjm/WP3RGn1b/QgoANCXhUE6UkpjFM74Kfw6PjREh6lqyGmuJ9YLrmPJtnbye/udkyyTP/PtFTZDCo7QSd9d58Df2gzHMJoD02uQOy15e2BsQW/QbbndOqlqyyq7RjXIqFPyC+eITb/obMPxfyabMzfHtFnP+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dt9aTliZZuhRAufB663nCCMSTejhkiKkCRfqIGP2850=;
 b=DuASmmh6gvaUqLkCWws861uUKneJ4YVNhvg/Afmn41h2x+Ntjzm1EYtrzI7458zieeoPqPkLryi6s8jM/kBxeCF9j/PTtI7EIyDFFvHOLHWgJMNxrY6liKwG74vrlDzw1btCMIh5LHmoF0fpY1/SkhsiU5wTGk+Z6oc6e3lhMwsnxLxsK7cx8ufJlZdzYcuniT/NhCPSwEm/s6niLTJi5tZyOrPt4qS7otolzB7ogjC7ysI7gmg7/r0gRI9GZRDFRiHKZb+A5Go6EDQ90gkAzHVuqkQdyEfFoc/eeXYuEQYYUuN1zf0+LeEiFetVphKm63lv1srmv9YsOwLQ4AVJbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dt9aTliZZuhRAufB663nCCMSTejhkiKkCRfqIGP2850=;
 b=pHEY7zKDffAM83ldzimYMI6uUcrKcXUFWBctVZl+0A+cBUiDpw8sRQZOVOIfDNXvEm5av1dpKBIBptzkGhhIz5bYGXwrSpsurkFZeTVEj7hXO+AKO2upTyBDW2dbhmoO400hw0bLdw0EHFRPpJo5lSAduXIwBB2z78r0FQmWiyssBIZx7UQMviJNMeiJwetevHeDLkixP57ZdajbPf0yVdIJR0ZecGr6FUV/kl2nOGYYo+iBVbr4KPKk9Nf1YaRzrFNMhYB/eL44HOkSkIswWZ1dK/kNLfU6lgB5CfQDDlkO3+Exj1Ci3ahyiC9g/qHUtqkEWU5lMWNf8HGz1E4kBg==
Received: from BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15)
 by CY5PR12MB6574.namprd12.prod.outlook.com (2603:10b6:930:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 16:03:07 +0000
Received: from BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2]) by BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 16:03:07 +0000
Date: Mon, 8 Sep 2025 13:03:06 -0300
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
Subject: Re: [PATCH 08/16] mm: add remap_pfn_range_prepare(),
 remap_pfn_range_complete()
Message-ID: <20250908160306.GF789684@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <895d7744c693aa8744fd08e0098d16332dfb359c.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908130015.GZ616306@nvidia.com>
 <f819a3b8-7040-44fd-b1ae-f273d702eb5b@lucifer.local>
 <20250908133538.GF616306@nvidia.com>
 <34d93f7f-8bb8-4ffc-a6b9-05b68e876766@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34d93f7f-8bb8-4ffc-a6b9-05b68e876766@lucifer.local>
X-ClientProxiedBy: YT1PR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::24) To BL1PR12MB5753.namprd12.prod.outlook.com
 (2603:10b6:208:390::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_|CY5PR12MB6574:EE_
X-MS-Office365-Filtering-Correlation-Id: 811f0150-4e55-4e79-a8ad-08ddeef13323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KKh8P+a9TrV9/bNZP3bmGQUYmu/tVxXfQkL3mUdrFuZxJ88zVPRZJmiC7CQ9?=
 =?us-ascii?Q?SI/J+ad6uBVjJtw6GaFTWv+DjDM1z0sgH6/9kW0y50w3ecvJyfruv2oZD8hS?=
 =?us-ascii?Q?FcHgKoL/DlmrmPxd4EB7XcOGOi0edlaJQxALx19rjQ2RPmEbuwaS3eROMaMQ?=
 =?us-ascii?Q?XcwxvfnH26cuK8dRGfF00N0LDORNQHVRz9/1LVbUN1L72N/S3l/q/dfrnYJ6?=
 =?us-ascii?Q?/iA5s5IQftPfBaRZIoGDXcXgUtowbr/fv9FgM+s8SZ/y/r/sib8BFPMKfML+?=
 =?us-ascii?Q?rn1Mq51Yo0T0HslDDDtyQDJuWIfb8azAQOM865XUXEFlYgb6GGrrx4ZJm6IE?=
 =?us-ascii?Q?WL+NHFgncmGZNK2IQn69Uw4JSa6T0lGTBBTRNyMiXk0pwNtGq5AU4Q3EaInG?=
 =?us-ascii?Q?URWwsyoOazZuFerSJikZnhn+DATT+asI2D5t86lqlgDzJuqYw085NKYaOzcu?=
 =?us-ascii?Q?HWdsaVycWVnk3PpAXyRPUlLg1eZKVI+c04nTfO0U9sJaE4XeW+AUUc4ysPoq?=
 =?us-ascii?Q?YS14+4La4oUJ9uSVLUAh1bsLN85E5rLkOlFU4IaBIRtg++gPFDiEncv5euFf?=
 =?us-ascii?Q?YqhsK0A7QvVK3SocGJcNg7gUCmRpL827WqoF4LwrZP2xFEo8p07PrmsFPaOI?=
 =?us-ascii?Q?efMse+MAMUxt/UqGsA2VduYGQSnhSXa86jK9mXTrXeG+cFaqy5v4dtUPUmzZ?=
 =?us-ascii?Q?rNeoYI5yLGOc16/pVKPVtEV4wTB7ers/62hMANj27/zPDMCgyyDxvlUkP97x?=
 =?us-ascii?Q?L3UE3CZX6CeTsj7dhNsSglFYMQMKxziVst6sSSzpL/vCH97b4OoHJ9Mi1jYn?=
 =?us-ascii?Q?C5JVTVeHi8Parf4rCLLw1HUVbIKBnXwJsiNJGjaxNp3FvUqenje1ZYeij/uj?=
 =?us-ascii?Q?KnRsXjzdpOjpIjt+wcevtIo3P4Dh4tzjk3+xp1i26QDepxbZKxV+2jK1JDuw?=
 =?us-ascii?Q?GeUIKyzskhpWIBHpWV1oRXp46hAiZMiCkFt9B0Dnwat1h5OVTPfRTqeCkEht?=
 =?us-ascii?Q?Nb1m+salO5yRmykN0s6QG5h/GSscd8ebpat4hafg/f+/QJg//Th2aHItXwDi?=
 =?us-ascii?Q?w+u7FLLbjMwZ9wGh5P24Q9G70nMseTerExnxc4vqeCqRRhbzT9P4FW8/p02M?=
 =?us-ascii?Q?WACdGbBWHkOheh/GFxFFBO6NksJ5zjSwNA8huuzhoG0TDzSuCVboT3l7SaxX?=
 =?us-ascii?Q?JcPRMz9yBaI53gAWLbSWbGLYWjEj9ChWfScveqPSyEpIxEhC/7xtheUTUfjE?=
 =?us-ascii?Q?fNXh5FIJ10epuMDgN4pnpbT+SjVAgOmqqiSHTd12UEaomQUbdBEWvZKrktjL?=
 =?us-ascii?Q?VcupuiGY22ukog4VdyIsUnuKsx8KXH+1kpq+7FyfjXqQfJDW7R1SLzcvehBb?=
 =?us-ascii?Q?hUI8LyUMgr2X8fdqzlZM4XFPyASZTJrg2ZSaYV849Wt+E8Fiz6sS+65ohs7V?=
 =?us-ascii?Q?4K/zF/azRFM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Di7+HYoZhHLGiOzcljW44OE/k8IMzE5L8NHJubYEvzqECa0m0qTN+LvvCoPQ?=
 =?us-ascii?Q?DJGzrKTLiJAQNTFAaewrBdrushviRZyIIeUJgGuJvc1qlJGAfkJ1PFi8gEvQ?=
 =?us-ascii?Q?OwP2/fIFoHpg8dg1TqXQL8FoQ3iw45uPHX4NmfuArBkiiLojgNQ3s2IGNxCI?=
 =?us-ascii?Q?8cwzoqZiyQ46/UCx98uR8jht+oJVaQbjovpHtp0k/4Iut61meU1zRuDztHta?=
 =?us-ascii?Q?pGxxlQv/vxuqkmCIdXt8Evso6MiXxxTFURpzmrX5AfCpISGuYWihD/l7CuTI?=
 =?us-ascii?Q?kUn//E/McDsvF0EYlwxGrA/ExyWx4KAjhH65O6rqwvkvKfOjyjLfH28PDjyV?=
 =?us-ascii?Q?a2cKSsLPAXXDB3PDunAbZJ1gPz0uJ7vYbCHbhUBVn31W6teyIo+Q+z56VvAr?=
 =?us-ascii?Q?Wik+O92ECIfiusR312tm95/0qtkvV4zwd8272XCyVFB1mR1Hgt3Oj0BMb2yP?=
 =?us-ascii?Q?ZjculdsL6uvKG4VBLkonpeAPK7tgf3Fand49i3tVwwxJtZGAS8Hkw194RJHd?=
 =?us-ascii?Q?OkMsW2axpbSDc1ogGaG7I/9irWJ7SuultRqIyyXbWnxjaQzQLn6/C4JjJQ7p?=
 =?us-ascii?Q?Zt7RNmjMgRcePy2CW2N22+/A8wQazIx0pmCJDc0BbNRFiqW3dgk6/TOjSyvE?=
 =?us-ascii?Q?TGnjynoJNdO1yWWCN0XY1cwCrZSl2y5HXCgfDS/MMpZ9MWfABlv3IjkAv/77?=
 =?us-ascii?Q?MnaSo34ndYk1Y2o9iS/d3S3jqC0EvfSqj6LH2RMjmezMksLp7b7URmR16TD/?=
 =?us-ascii?Q?6JU7U4ecSpsZKeUeHroXjumhyhOOwDy7SFwpfShhZNItsa/VTsn/1WrC4JLn?=
 =?us-ascii?Q?kD91iuKCdBiZfsFRNAT9G1QUYfn6jMztlBUPFHiLKyvActrRMp5+T9W9X9L7?=
 =?us-ascii?Q?qP5maWnsbwZgf2jWu42C7EW1gAu+8qYkpAIU61wMdy37YDx3Jph+Tz7WEJXY?=
 =?us-ascii?Q?Wt0Wo4Xq7o+SFHH9sHzEhDwFrshv1zYM2S7Fre0eIi2HD7d7Xz+3yo8B0BrW?=
 =?us-ascii?Q?prd1SJ/3qxKkZOUqrxpQn6lMbzwlHnc9HRss9yzRq3AeBfOfD6CNtrjAcwbC?=
 =?us-ascii?Q?gNgJRFXteSgMQZdO3BM9DsLh7/l9yqCAXo7T68+WOJFqcelCas6HeCn6U9CX?=
 =?us-ascii?Q?j407Bb15QBzHNDd3Pvbm3v0fWjbxauaNxqXCxRDWeGHE0pdvmYegQY8x3cvu?=
 =?us-ascii?Q?XTaMFhpUUP9cmwuoTH/vul662VRuCszhow3DHgQZTU6W1yWHAGj3KcK9RMVf?=
 =?us-ascii?Q?FjHcXr4zFRs+1rRtisju7KL6/TgI9Pf/80fpSY3PIpx/eqZw3qtLWP1C81Eq?=
 =?us-ascii?Q?xIJ4mjMECxjMuLQNsLjvbUsRKizQ1VCrApu59PwJfnZn/tog76CtxaphBqR3?=
 =?us-ascii?Q?4db+cBpmROKQsoIQ/mF5qsGxbJ2cLZolnVauvwTKhHjlSD76evWpZwIjTKl9?=
 =?us-ascii?Q?U9IOQTBSa08vB/d6uhCBCGmP/dRRvK1UD2xhJeBZuPn+g90INMNGjs4Ez8Kf?=
 =?us-ascii?Q?s+xR+vxp2EK8fmfbwfLlDRIhMc4Ajz1hNgqysZVOA0tF9tcva8kvbxYtQipe?=
 =?us-ascii?Q?MCNOWtLBGUL1PhJxBhI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811f0150-4e55-4e79-a8ad-08ddeef13323
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 16:03:07.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oskmkHeAse2jgaCJUs2Yfl8HL0NEQXj+7yIdF/4uJciqoXgC3qRiBgsqz9TIjNS+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6574
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 13C64A001D
X-Stat-Signature: ycx81ad8ixu5twdixqa5n91np4i9k8gt
X-HE-Tag: 1757347392-185579
X-HE-Meta: U2FsdGVkX19pMnF7iYdvMldQoHlmJnBo5nn5OJFksKy+IoDc1TRMvfJJbPYj425RX94Ha89qSj6r2a0UX10bpUYEP861MK+Qfz8xeXCBZY/c7DRU35i6z5q3sjhZ/9NYiGzreVuES9nXIT8XBjFFbr3XRg6bZ7ddUEVsj6jc568YPvugy1wiggbZnoJy+pO+sD444RIobXUng42A8RJLmjpKwG4Y5zgbL3VI3oiIxtti33147DpjegMys4KPWzEjcBLDwOXnI1pGuZvLZgSBK5qttMbx3thBbMdc1ftoXw99ZHxNuD4m0gHIjux+8LuM5tUnNtB5yAp9usdoXF0+/OCTwiRPgP8B+hYVVcmKqQvunVdO8xRG/2JS0brTmMU2UnQrESK4RwfVrYvgX2HnylwH3zwK6cIcmlry1XObgxRwGnrUW42s1hZfh64acg0hZFkGg1JQ2F6r2oRIw03w3mEEpLgJiLZoAyb/aUP/EOjWo+ZqvRZBxTL1AhEewA4zHi1D61BrxTq6SIeO2XIGAWLVpeXSwdWpg171Ot8Rf9rXAlX1zj+nfucWASWOWelHLuMEPKh1uzKYgLyXeFsfunvz/s0tMXwz/SeJkbWGjCMe6qQARKUU/Kv0MlEI8tyd4n/+LmXh/gW2Tge9ksBesUQ7fouNYdvL4CNvxMRHykcMHtp1D3CZhJd2+zadM5Zw8LDSvzI1nbzWDbHb1V5O1aJ33J7Jpy9rUnwNppTyYFMZwDe9EnFonCn737wPzGnz9cUlhOKHF5TT3LP0CfEYdo5KtJ3KfJe6KevUnN8eXr7zTQwrkbhe5SWcaqDPqy23LDGxmGqZB/vfml1/7EDZXG9NqCdbQuNXjCac8i4bDE/Akyms1OSM+DvproVTTmOS4ZOpob/oMQG87L034K2T5p4AFL0NfionsMqgJNXBhIKRPSzZQ+70Uc/aFvoaJQbNpfPB1ctkxEUPKoM02bl
 0l8w/oAf
 lEoBZZKktLJ2NUoIcoUoYYjJ61gJJiWwJWOOSWG0w4Ar0sDU6mfRNM698SJVZ3V/EkuxPRypCEScYLGXdHdCvl/fsT3xTeA+xsZFL9QF4+syoZtnp7/XvqTlqIPH2bKAYIR21pGmkFQWf/rBzDdlVdsKrMIzwlCf1xT9hJxMVhYQOhzDz5qUBhOWJOEJQYJj2e4sEGxXJYR0x3eAgN7B4v+iEMipt6OalytgaWVrFFN5X58XU2+2l0iGpAk3n5pwpXj1iXSlvSnV9yEbsOogkMSPzeHpwyzGw+7awvyklqfOiHnoakvOBa7jyruMe0La0FO0zFbdUzJLyQu+surWs45YwlraIzyBNRV9FnKE3OX9YUYZDzJocoh0rUhL7TOj+Srq14NdI9YUoXDdrrL3i+E08aGhmYuZexsHEaWKkiccu6oEuVMUVUinKRkvPGbijlK3asqEUKprixS8o6TpFwr8ss2aZpktvlxxv4dy8U3+VZGJEt14J7DxAv8dKkroZsG0ESSYZXweOVc+XvLVWp2QImt/uJ35V/POiTzrhDII3KwiwC6oW3iiHV3OX91ARYSzQIhPEUDNUYzVSJSYVGNRWaJYUTumVsOs6lP+5Ot7yBz6YBjkQXttPsKLmlcVqmgAG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 03:18:46PM +0100, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 10:35:38AM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 08, 2025 at 02:27:12PM +0100, Lorenzo Stoakes wrote:
> >
> > > It's not only remap that is a concern here, people do all kinds of weird
> > > and wonderful things in .mmap(), sometimes in combination with remap.
> >
> > So it should really not be split this way, complete is a badly name
> 
> I don't understand, you think we can avoid splitting this in two? If so, I
> disagree.

I'm saying to the greatest extent possible complete should only
populate PTEs.

We should refrain from trying to use it for other things, because it
shouldn't need to be there.

> > The only example in this series didn't actually need to hold the lock.
> 
> There's ~250 more mmap callbacks to work through. Do you provide a guarantee
> that:

I'd be happy if only a small few need something weird and everything
else was aligned.

Jason

