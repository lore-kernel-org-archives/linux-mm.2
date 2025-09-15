Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E36CCAC599
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A49D8E0011; Mon, 15 Sep 2025 06:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C728E0001; Mon, 15 Sep 2025 06:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345368E0011; Mon, 15 Sep 2025 06:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA878E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:13:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E194F1DF30A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:13:30 +0000 (UTC)
X-FDA: 83891072580.24.316AD67
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58FE210000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:13:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="KWuj17G/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zS32OWNL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCethUuV17gJFa6OTL14zfdca6W5aNJIDGIsOhmpPTo=;
	b=tqtwrwAHeCiZyKWrvtlIs0MMVskhkNHuuyxMzpKVToYkBp7LrAt6WwyMgWGdNqrSsV3cFB
	EEgCu7LCbbTtcXWu89ZJzu+OTis66iB3Fh7y/QnDDgRGHX4vRgH8xWQd0WjF/kDBwZ5zLY
	zH5yrSgBgm7I8z/TmyRXOSP1h0f5ZLk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757931207; a=rsa-sha256;
	cv=pass;
	b=wXHkQpsu+2fOaE8NnfFqe0nPx3SLbu9U9pQxCXLH5eHlCRYi9HttYssOmpcO/W3rOfKbrZ
	Jtrv2pwp/wNvJVWxjFlbGqqSu3Hg95y1BVodZgkNzlNrcWGFMBxsrWCn9sie0Vc6V7NcPW
	fQ5uCHr00p5c2xuVAiPJr2J+2lHWSXc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="KWuj17G/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zS32OWNL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6gEAv022095;
	Mon, 15 Sep 2025 10:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GCethUuV17gJFa6OTL
	14zfdca6W5aNJIDGIsOhmpPTo=; b=KWuj17G/L5BHF9WAJaiTrDSgfCWmfOwXe4
	0UHLC1aLI0yicqalHPAR9VOnQrISjSjTEBlEVqj24TfJmZklv789tGzyd9pTbivp
	CM5apTH6fMlJxKr3E3NxoDZJ5xDvCPxq8OBz0nC5vPQzGCj7PP/02j2pymsAbJ7r
	dqkO4I+oImXeOWW90NNzkUL7FkB0/KBKgaBIBYfowNKg+12lOrzJKQMtzSsz9K9A
	/GkRSOFB5/vOduOnmEmljaX6ca9uSI9724NeNtdr3nvk5mh4TSTeCf3WS1Ef7Dou
	At88vtaEldmleuzR6zuom7Bzl2BPuuN8NYU4Nb4DxMoBGKxksbQA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yhd22gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:13:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8GIxd015644;
	Mon, 15 Sep 2025 10:13:07 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012064.outbound.protection.outlook.com [40.107.200.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2au1ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fRq0UbydLYml3HrS1mTbFh53+MtIB7Z3XgkbcfbkMPL4USd2/JYS9hPOPkYermj/SfjKKHlHJM8VWbc5ltxVlIAvcW0mEXs2CTHrfa0XJrlbDgBphcgxx0L0uUxetGcXj0RB9Sj1qTK1iVnCOKOLTaE71xttbG9YkhZ6ZXBmqh1CJPmJEsbkjtXNQJqqGHRC/SaglmAIVTHXeMf8W96Wg5L/nift1o07IqWqEmOm/3fHQEYDXv22c+hpjZSp62S4E2rReOLUGXNZWmTLFPvR5SJS/Hh97xcdQfeU4TBP5/8zoj08fy+se+2vnQaWvSEya6LoxJlpwquO5nIowTay/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCethUuV17gJFa6OTL14zfdca6W5aNJIDGIsOhmpPTo=;
 b=aT3iip1idI41es5HWKTAhCBYWtEvzg49TScGUpzFml9MJLUN110J7Z+8xS1wdbpoYNPIrGTbys6VSBv13slXHor/exnI8zTnyx4DYT/qzW8iAVbt0e9WeTxlESPIn00s8RRuvziNPGOsOLkaeTQYnDQIrbYxVT3s451vK72k4HNKo8dhPb5/gyVf568cNfYD/VF9ogtKfz5WU2HHhg5wyLQhob29Yzow+E2CQjUT2xt+QQQFl3CApDLNOKUvj/sOj3NYyIXDJlu1DUGTMaR9CD/2ZVHYtZmO6hfdRA9fiPFTfWoV0wLYqRYDzxqHrGDjZyUCvtVevMDmtePkp7OYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCethUuV17gJFa6OTL14zfdca6W5aNJIDGIsOhmpPTo=;
 b=zS32OWNL1xVGns7XxyDpQ9s0UpeKj6ihT63L8mhJNzhLuX8MmMTRvbMzMuDLJz2yBobcQ0IR07UfIGaceyAiu8QbGI7QzUags0NxHj31/kuoX6X0Hnscsk4BtCc+sVhwHrXUfZOZ6pio5MbnKskrdZ7AiBdX/6boNdcnZLc1e30=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:12:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:12:53 +0000
Date: Mon, 15 Sep 2025 11:12:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 03/16] mm: add vma_desc_size(), vma_desc_pages()
 helpers
Message-ID: <17b6846e-d06e-4a2f-9104-17b147cafc7d@lucifer.local>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <5ac75e5ac627c06e62401dfda8c908eadac8dfec.1757534913.git.lorenzo.stoakes@oracle.com>
 <3f11cb3a-7f48-4fb8-a700-228fee3e4627@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f11cb3a-7f48-4fb8-a700-228fee3e4627@redhat.com>
X-ClientProxiedBy: LO4P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: e5383b1e-e715-4c26-4b98-08ddf4406f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SG35pWArFkPDWZ2PfuQ/4riSlyF0OlxNqCHg1NKEdB6qoQBncO2Tncr8FfX0?=
 =?us-ascii?Q?BgIkknOMvl5zjeHwofjIa1vaxHUzLVlWqce9uSKqnNHwSZBT7wXlBDCUdu//?=
 =?us-ascii?Q?NyQ63c9ctbfcKVdkmew735nl2Xq42/q1pYDqi+1uylRkRh20Ly/wRAyaL4uP?=
 =?us-ascii?Q?skArMKaTJmWXKXf0p0nRcfn4mmfMKXldwaqTH9ib/y9F8IyhTwPW0zF4Z5kI?=
 =?us-ascii?Q?QQ6+gTyQ3JjCdVXAaBlTh1IUfXTwmLlTlgulqsxP08n3Zot69MmAKj4nmajG?=
 =?us-ascii?Q?ac+b7ibRpBemrZIOgdfylzAMCo/hHA1XcL+xTRtRl5vFuz8VyJvr0cH5r5GM?=
 =?us-ascii?Q?iHpWHrftjTt+uKvhiREoE2bRJBkpqtKA0lIQ/0lGAs+CZAruJhh1axoO523B?=
 =?us-ascii?Q?btDpP9JDVMK9MN13QbNvKulc3S5RK3adQ1l/Hhn+/Wa8pZifJdMZtDzCx/g9?=
 =?us-ascii?Q?sG36Yjd9QoKkZKyGxDSYPsmxUC9ZzufZ/zUTTXOJQ8ETVFdxT1xze7fG2JlP?=
 =?us-ascii?Q?jH38JFJB81geeC8l0nFWpydxTq54uqL12Vl9a1oCeEbeysMTH3sVYif2YgZ5?=
 =?us-ascii?Q?SQ8ekXGD1vlB04O1latl2zNyCRcnm4jKraGHCUCR5YJy/jbQ9rOmG1ZudV0x?=
 =?us-ascii?Q?CeNCpAmIPuPPNNljxLHqejt8XSmb9Kt3VLtlWiuQvPQydxAeM/ZBPH6oN9Lu?=
 =?us-ascii?Q?Vl+jbMkvwE7Q7GzsaeZ6pMMbyFVKv5PnTVlleb04l6Gua6DoYjJbyrX5Z7pk?=
 =?us-ascii?Q?MLTzsdb9R/PzXgb2jhD4UQ6yX9S9J2iTxeDMe1SknbRv7BEEGLRS8cJWTOMN?=
 =?us-ascii?Q?CaOxVjq0V2MiFrXSWY3o4tag/QGyDPv+UygCsQGFmlFjfZ3N+Coisqzg6g/Q?=
 =?us-ascii?Q?ceWELZtBmR+BHpYvqgU/KtGOF5HIOjwZtQ6/pGFDOg+ybNEidn4lq84ypmAB?=
 =?us-ascii?Q?uywXGGg9djUEcxdDU/4MSxjT9b7wMxeFi9ZAwyUBpDVCKN5g/Oufcxn+UUIj?=
 =?us-ascii?Q?ZWjkR3KUhogLSXUuap1TwPC3fPrnWPVYu0Y8UaBduEpc47FpU+MNvbGHP7J2?=
 =?us-ascii?Q?95Emt9tmnxJli1UWiemzI4rUNa8C1DmaHw2Qp17X3jkY61sPBbrMoG07RsUX?=
 =?us-ascii?Q?QgQ12ZM6z9qoHVqtdK+XKA0Iuzdlg69VVvBe1wUaXz+wRk8SJMnS5u4GJiW/?=
 =?us-ascii?Q?ZuFUSYP7MoSqtqJwVl/hJBjMdtyzrzY6r6ec4+Xw/+iPDe2mT/ZlJfvctxNK?=
 =?us-ascii?Q?eq3cNFlAz+UIgrnY88Z9R2+67F+PqaisMU2rK0/abEGotdjNRFF4orZANj5U?=
 =?us-ascii?Q?eIxHWElgUBGlpx1UBBq9H2DI8FaeqH22v5Q1vJaFXT8LZCikGbgjzku86isb?=
 =?us-ascii?Q?rm8QZx2kDXt01JhWxIvlbTT5T3DS6wwmPD2mxifoZRmqI8GmSBn6xyjDCM5V?=
 =?us-ascii?Q?G1n6BOtH3xc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lqj/c8ApIm2MFwBVLoluJ6/gypc86b4HTJ5qkSyfMTr/qzSZMeqgblt/P/+O?=
 =?us-ascii?Q?kX5SH2FHPtCAjpH7anNs6I3/HIvJDfKPqfkdX/Ts+5dnbCCUOBQrYqj1XYTt?=
 =?us-ascii?Q?7aFjglgK8vp9ogtMSmZ2SY1mETHm3N+XHGtd4qH0Ec4PNY+/5F64bd3N+AMP?=
 =?us-ascii?Q?9tzHZy/KbU1bG+bKFVXajNWtYXzWh9JrcFoVhHpi/ZAEa6jT+EuHiUkpA2hj?=
 =?us-ascii?Q?x1OwjAyvnuad6zZ/qPB4X1494YaJcEA89eOwMV2PpFWU+p2eisEotUAgIAdM?=
 =?us-ascii?Q?XC+2x1zmIJrRZU1JSej69/COSGN0Jh6nlTHA+9A0rYA+d+cFQwlECotXAwE9?=
 =?us-ascii?Q?Hc1fHkfSZixNNJ7BbDgWhCo7l3nAZlAun1OZR2Mi4viMhUdGRJ5ETrUgDkGK?=
 =?us-ascii?Q?a7ywQwmNl470L2fOGf7f9v3/9gx15a6MEVLf/zjbjXvgWL5GdsjpVe6Ep5ZY?=
 =?us-ascii?Q?gOFywdsZIQImqfnZ5y7Oar9dcvSp497S3lQ8Y3qRJgB60//rTeEhkkzSXcig?=
 =?us-ascii?Q?D4ZFY7/GIUxRDE9n0rxDoZKPxrhD8gOFyMpHPRYjwWUYP9RQlZ9qLFXxB2xj?=
 =?us-ascii?Q?+Kz5K2M7AKkAKpk63XW0AzmrLpqKDYLrelNepP1glfo+8F/xLYxYJBjcYoG+?=
 =?us-ascii?Q?AIbaei9ca+w2lCJXxd25fbMa+gpDbwn17BhrrP/+quDI06jHaxlYGEwDcNPV?=
 =?us-ascii?Q?+/Q141itKYn/XLpzZZNVyrZr2BelDl1QbLqUqR7KLTyQWG/hfizbJs0WNcQe?=
 =?us-ascii?Q?hXcLDskzIxdOdAK4TtAOI6Mn6+9qMvv99C3a6wqZYp4UQZP0vGzu29MwBoYv?=
 =?us-ascii?Q?ND0b3s0+PjUs7Zle70hjOq7tPraOEYyKK3J0m7dF6QBMEyUU6Ii7foWOG1yO?=
 =?us-ascii?Q?W4vPwllvtwD7DY/qFJcBTm1W4yWOKI5uv1xmd5cQ/AIva2P4I3hd14/rSXqP?=
 =?us-ascii?Q?hAHtGWH8wLPpJhjMEtrY+3nLsxL5rBTpbaWv2jxXEutQM9z8+1jH3NR970yw?=
 =?us-ascii?Q?+nf7pu+iPogiJcHBfBscfPIpLyLIlCXHtA3U/sLXH0/O5N7uBeEgX2yHzLds?=
 =?us-ascii?Q?rwHdmFKayvAybaICg/a64TuzMx/ItdIxKEFSFgpq1OMNVieYwbwMeuJL7EDA?=
 =?us-ascii?Q?FT074vcaEtUyh6pBU7jKrl+kVFbkoulF1UgLST0+x03T2b4phL14D0wp2XtI?=
 =?us-ascii?Q?Mo70NbTp5jNSyHgOKefY1WKZfHRdgWFl+vD9YazKBpCWSHKW6XBRW0q9qSR3?=
 =?us-ascii?Q?kpwEa8K3iLuNG4T4DwwV9si0qpnZuQfJaQ7hjRnFwovtWkpJ1EWpafBulMtn?=
 =?us-ascii?Q?dI4/AbWqF5kxQQXKOJS/H5I/Txscl5fnZB/E064PuD7KuD9rkwYASV7jD3dk?=
 =?us-ascii?Q?t19uvc4hz48yGNf0z+ebTGMWcQxCbeTW0w3W6/G9xUmRkhYG7UXCZtxMmKjH?=
 =?us-ascii?Q?m2xUC4+96Hn8JI8gTnDql0zM19Tmkt4PUUi5rGfKWDMPdjIxPkxitGnaFspa?=
 =?us-ascii?Q?GyfbUq8sMN+aPiO2mAOz3976GaQCCMP+NmPqJ4hVPvvj0z7PljO3YC0wgwPG?=
 =?us-ascii?Q?kipSRP392gaje6zeqEqcAehI+C/C39Wq/0CQTgXeVHv/AzHzCA5B6NJvorxV?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2Zhj3AVoDc5Jo17wr/6Du9KM0xqyme4HIFtiJPs66aenf5VpJrnrbgin47UpBS+JVqKY4oUtqyn7FAx0sIGwsbzPnD8FKKEqMBH8DU/jLPuUkqmjEwn7NvlYAjeYXhySBW661t9rF0zO5/oMMizcLyj/BURI7IZluyTeNe/tdSxPCAdxquY52V7ox/NqwbCewY66LHnouLReo24B5YHvVEeDn//CjPG6Fzuwgcg1MTjMr+kVxDcDXuEFBvFB7o6g+UfGJlAtRWHhDCb0+vPXnW8qAdUIzsEXfmjPLY0XGAupM9770AhS5E318q72ReFwDKjiozEvHzqTmSqlAjSNhIdYDfnQoc2WkQ6Jh9qQhFNYjsEwk0vPfJ1RK1yIJ+dU0aRQdUnLWM9cTRFXB2wCqDDmNkx2vRNJXHHoJ+o6M8NaMtladAnoUa2XtJfbfuSe7rHAi5j+nzlE1yzUat+at+vBZfEb6zYD2C4HPqTou5qeAKrG/c8VNJNiWw7177Do8uwpYpiLxtMDICL3WpRvVpyDStB5zB35H+ijs2aeUFNWKyY6j7kendowks3a2a4yw/A0rFY9i6sk8FFstKmfUQccAoWURrplcPZFC5xyWaw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5383b1e-e715-4c26-4b98-08ddf4406f19
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:12:53.6190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHbAWRXsRjPhbZt0MGfxflTq3/KBpdRmgZ3AGrSeRbhE0cX+GkLNd7ztpT7wiDVTsfRce4NvP+7nVt/Op1VDfC1CKIZg5cHy5k3QfjjDDjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxOCBTYWx0ZWRfX0F1TI9micXUH
 5AMBQJGD2j1yb0QS+K4udaWPfMbD18Fenw2eSEDEDDKrxih6aP7cWlN4vGliDaI0fwj+ZOyW1XJ
 Ly34qsxjLp5WrzP21OrWH3rjAznU1yRX3zlMvoRCdAFucShcsgDKO6MTUI31Yf+EF6c+WP9Y59l
 wI/kDUyO0FKQRUJFYxBL9o0YSJnkURhdrSB9aAQVi6iDzRBLeLIyLC3rXbM4wMYm9r0SdjZo/cH
 jG6nn6abh9eWi/qlHoP8X6zXkDpNO7clF7ASXUfp2bcr0PzqrgXAy2/TpZUAu7CrBDDZeJG978E
 0OaO9IUWEqdLpCHgU2fWpMhuHWKOcqm/vF6a2qLiwR1I1zWH9VSmPA/L4NHWfOAZ+A+QYtM4ZZz
 ECp0lt+Vc897HlVm236C3O91L/PHLw==
X-Proofpoint-ORIG-GUID: x1o_KvnXyXvmDZGkSNz-Lqo_8eS4MihF
X-Authority-Analysis: v=2.4 cv=YKafyQGx c=1 sm=1 tr=0 ts=68c7e6b4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=P0_JBuDFtRVjPN4rMcMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: x1o_KvnXyXvmDZGkSNz-Lqo_8eS4MihF
X-Stat-Signature: uzu9hoce5aypcq8kdo7eh816c15ruh67
X-Rspam-User: 
X-Rspamd-Queue-Id: 58FE210000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757931207-643308
X-HE-Meta: U2FsdGVkX19UjK/v77DxDEvNYHIR2med1XVcTAoovG+yvs3IGvkvV+/70J7g4ktJ+hQpfizpXAAY9P128oc+5zveEdvo5CENFedcOBJ/OWSIgi0lLC3vb4gfGuj9ysOkmr59DZjs0nux+S1oD2WEuGlbt8LhvnMDzgrccFgr+pl2T50SbXCF6LuvjZcXBBQdTRGpX00EtDMZ73WfWNjMYJNfATbgSZWjjtAba7elJNp0q/gddLqm+c3UrXTJIu+/LCqGpVte5v1ztp626HouQBsUg3Wqt7gP7nhlhMObV5YDskOWhLqnuwJ/eLI0PnJPQiyvk2PWZxJc0FDcG10iax9MeOtnnGqV8P/Zs1/lp7L4k7Do30xiumipdoBK1tte8tkX8q2nWLlsmEqFVUyHFTZqTmiMCxDx0cl/Dz/mdgTAHpty4IgCUZu0JDjUiFlDAmf4ewKv80ziTLUB3olKKRu2080YhnHH7oTVf8zO5gr4gFxNqzhm6iL77JKIeLX/F7o0OnY8sZjP1wJMWwIf1D/gpmJoUfETsPnTMcErrsJK7GJqlVuaIeU7X1C5f1zGK5qWENdUiAVM5RU4Ezix10r/gcghez+s8LiZFQe47n/4TQ/QbxIqA+MeEnrDGmJUTckVq6xbJMQ3U9U409uivG4IKRFvIOMAtjkyC96E8klPKW8ddqrn2bSEatWGTpFVhxBbXFYu/COv9/JbzGWMkqt7sm6ohEcFEk+wLpBLl5+hh/aP393ew6RyfnMSCWUuGy6iTCffrWFraA7JpeV/v6Q2/1EhkOJl2SPlPZL5tN0N1wPaUOfwyC24Lo+c/qu35Bu9uh1s/2F++dzU3II/lhfgRnCJI4HmZ+F7Lyde1sMQnKcJmfgRErPdu7jBbRL+3BDBwQ4kJyOilDUJEzjFsf7pQ2e0GzbnG6sKlmT5JacAJxI8dNKhxepDuvtp4/P7XK1gxzcNlI5uZ16F1ik
 BwADjKXx
 Ze7VLD+Hb58WZdxeBkaPX7aPwqd8X+RdTE1XhrEVbnuz3N84WML/z5fkfY6GyyasobXasc6XGKLQsanNxpQ5iqKx/FRs21sb966PEgdcEfOpNHm6ujHUeuheyz3DKHy2hfdafD4V2MNYcaS45/b0/kMoraLomz0RhND1j/deVmSqkS3yFRDIadjkQIF2868jI4KnSvceR0cscgVHRIVKshD/MGNS4UBXMnmMO9+ow94uGv9O89PcwgbX5tJTkXk/i3G6PrOEUWCIOf9N0KS7trT8BUolpYKUKKJUvqf4JyvLSxikAdPX8sSrZVyTFwZY/FSL9NqcwaK++NSO0zqrrcYIXU24HhJt2i3hAMisNuBHpyXxTg7UCAaL4ubORlUMyTCjpTTOaduWA+IAOh/5xKd0YheQ6tSlRmYbclro8u2Ppp72Mq3LGvjPI4WY6GPdDdNf8DcoiGBq9iRlRS2rO3NJ7IeHzq0CC7U+ZQaPyp1xCSFwIv/GseD/9P6mVLtZaroaH4sWC1xwyJ2/dGPPPHONoK6WI2i+JJ81Q9AsN7rpi5egz/bGt/ywgg4CqBeP92zKydRtoSXifkYX5TrKCt1PdW2BpRSzPvDi4T2kMU7iSFHt57MJPz8bDUB9xLoWA2rV/J+xdR+1c7JUBx7GEuwnHOK4gHMP191m4dY++zPNsILFf3YqO1lPzA2ksizDYsovqhonB0U44MNVCAf9UaxO+Iy5lUquq3ZV06LuzlvLwx+ujAlJCI/mhFATUWRn93Vjf+sIgk3kg0t2Hv9fyhbADdED+khFRXAOfUhrce0BCgBbSiUfN5Xp9mZD6HKfN6Y0DuPpiJCDalNPEYCv7sIllWO51DgsEA95iMJVvQDSu/0qNobaLIuSO33lEXz48vIC9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 07:56:46PM +0200, David Hildenbrand wrote:
> On 10.09.25 22:21, Lorenzo Stoakes wrote:
> > It's useful to be able to determine the size of a VMA descriptor range used
> > on f_op->mmap_prepare, expressed both in bytes and pages, so add helpers
> > for both and update code that could make use of it to do so.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >   fs/ntfs3/file.c    |  2 +-
> >   include/linux/mm.h | 10 ++++++++++
> >   mm/secretmem.c     |  2 +-
> >   3 files changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
> > index c1ece707b195..86eb88f62714 100644
> > --- a/fs/ntfs3/file.c
> > +++ b/fs/ntfs3/file.c
> > @@ -304,7 +304,7 @@ static int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
> >   	if (rw) {
> >   		u64 to = min_t(loff_t, i_size_read(inode),
> > -			       from + desc->end - desc->start);
> > +			       from + vma_desc_size(desc));
> >   		if (is_sparsed(ni)) {
> >   			/* Allocate clusters for rw map. */
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 892fe5dbf9de..0b97589aec6d 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3572,6 +3572,16 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> >   	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> >   }
> > +static inline unsigned long vma_desc_size(struct vm_area_desc *desc)
> > +{
> > +	return desc->end - desc->start;
> > +}
> > +
> > +static inline unsigned long vma_desc_pages(struct vm_area_desc *desc)
> > +{
> > +	return vma_desc_size(desc) >> PAGE_SHIFT;
> > +}
>
> Should parameters in both functions be const * ?

Can do, will fix up if respin.

>
> > +
> >   /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
> >   static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
> >   				unsigned long vm_start, unsigned long vm_end)
> > diff --git a/mm/secretmem.c b/mm/secretmem.c
> > index 60137305bc20..62066ddb1e9c 100644
> > --- a/mm/secretmem.c
> > +++ b/mm/secretmem.c
> > @@ -120,7 +120,7 @@ static int secretmem_release(struct inode *inode, struct file *file)
> >   static int secretmem_mmap_prepare(struct vm_area_desc *desc)
> >   {
> > -	const unsigned long len = desc->end - desc->start;
> > +	const unsigned long len = vma_desc_size(desc);
> >   	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
> >   		return -EINVAL;
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

