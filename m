Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B449CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9808E0017; Tue,  9 Sep 2025 05:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880DF8E0015; Tue,  9 Sep 2025 05:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748D68E0017; Tue,  9 Sep 2025 05:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFE48E0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:04:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2519C1402CE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:04:32 +0000 (UTC)
X-FDA: 83869125984.28.576AC57
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id C54F2C0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:04:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gR+SbYYA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cbZ+YCrx;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8+NnwcdF6pCN7ItqA6l6osNNL2OzU605fxy98/w7no=;
	b=JbhzCZdnlfwsa2fkmNKZvrmk8RMLkDR/0fNx8hx7DoqmySARPHCCmWonaeOFMH9h9LpPAR
	gq1uznhZfABCia9c7nphfuCSJ/cyKk4KpkoYjvTs6cWPBxM0ZWyWJulVOxyqh/4tCKn6Ze
	1fcWm0CJjd8tOHZ4EqSHrf9hfmjmK0A=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gR+SbYYA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cbZ+YCrx;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757408668; a=rsa-sha256;
	cv=pass;
	b=XGQYgmhXnqW+0b3NkMFktfxMKmaYrrxo/bNvDrhWlvIiDPsKmUGRVn/XOMT5AMO2iWbXy1
	qsljxnxY+dQi8g/SnYO5s7mGVAHy6+bB8/ZJhlskEpv4xy3My/1UYLWkQN2itF4rkdzAL1
	Npj6/M31hW6UIfjVKK1wkVNiJ2MdaGA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897g1PG009625;
	Tue, 9 Sep 2025 09:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z8+NnwcdF6pCN7ItqA
	6l6osNNL2OzU605fxy98/w7no=; b=gR+SbYYAOp7xJL53jb8Fksr1NXlxmRCFBt
	UQWIbwfosUIg8iXUF4Qp7xPmZywRKed6Q1r+q5Bh1RZTyekkxrq74Lf+lX6RuACF
	+z9L9v8+HYP2Tb14jwSvsoxMwiAtKzC4obNl3ChrSIvtUv7bY+x57ub4oQMN6kYn
	ZsYwcDEm/SwJfP1eq33XeN1e+0pc+8ZDs4bdpKk6gGchivT5/IT5Pv7MBUdzHgz7
	0SwvUsg+slbvqYk2UKXRy4ql3SPDnx2nw5Cqw5tb4YFhcHiu4BVzVDnbz0VVDFRl
	8Tdff2NbyYMTgwNfAf4NGfOkz1SnCm5hqgNcybI2P8IXC1Shz09w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgsdf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:04:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5898UJAg032837;
	Tue, 9 Sep 2025 09:04:08 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdaaw0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:04:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XrJfnmLNUH4xKUsUtcncRI3d+xxM2Wjd5NCqpVBEbZDQNTZHaoQrkWGb5SezxSH/kA0aFNy5tj0hIdtxHmd1z6C0gvRltCB67e2uJV6Mg+R5jEJggGH45E0rgR4wuGn4Xk1zfuT/x2YtGspadPjzQVZWh1HTKi8k2PKhxd5C0+HXM3oZjX6FKZtI8X+LL8o7VSdodml52zgs5Z6zZEuZP2d7I1K4vT7gXOwEZFgTSYwEzD8qIOuHx4YqwBKjgeMx+kZiLMy7bN6RqY7xbHi1WsAQqYampirlVdFfu56GfBVzGFEkcTxxY18JvmckCobvvgoUW5480zpHk7+bqAwtxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8+NnwcdF6pCN7ItqA6l6osNNL2OzU605fxy98/w7no=;
 b=u5rd2N0O6dmJzY/p3xsdAJMN3Yj6OY4KR6q80FrsCkJsTy2pinQzwxSx/Ic0iIge9WmE6AcM1l/1mFKeX4Y2R51mlgWajOI0mFRWODoy7LVF6uWtKBoltwsi4ar/dFTwEVuTqVL1T3jkzrt6aOK+O8e7JzO0crDwT0YC9C/hFQgwbTne1EFg3hlNGSN43rggKUJdsknu4FOARPCEGMJRr5aZ2cY5ybvYvuw55r/9zsYzuOtrobZRNb4HAGrOf1cLe9im21s7d4whAfiu4K/J5qJE9D1c//4TDBW+9Veqd1kCGbyiIputkAW1TOSbBcS3O0PN55Hr+ZB6WWMi1IQt2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8+NnwcdF6pCN7ItqA6l6osNNL2OzU605fxy98/w7no=;
 b=cbZ+YCrxyrciQ9S0K5ERG95GIKcU4udhyJBXZLTtbBXdyGg+Q9sWlWn03Cx6p15p2MXZDcqPS04oALIEjA7w6dpWpH8b1ab4NXlBf4PQwBnDJV1th3l7PXCpoVPQffAwtfSayu2pLGQjyXBI90E6oUyQaSvjgkxyYmyvx1TqPh8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPFD7011BF84.namprd10.prod.outlook.com (2603:10b6:518:1::7c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 09:04:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 09:04:04 +0000
Date: Tue, 9 Sep 2025 10:04:00 +0100
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
Subject: Re: [PATCH 05/16] mm/vma: rename mmap internal functions to avoid
 confusion
Message-ID: <dacfa550-df12-481e-a47f-068c440e6a8b@lucifer.local>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <626763f17440bd69a70391b2676e5719c4c6e35f.1757329751.git.lorenzo.stoakes@oracle.com>
 <07ea2397-bec1-4420-8ee2-b1ca2d7c30e5@redhat.com>
 <a8fe7ef8-07e5-45af-b930-ce5deda226d9@lucifer.local>
 <225a3143-93de-4968-bfc5-6794c70f3f82@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <225a3143-93de-4968-bfc5-6794c70f3f82@redhat.com>
X-ClientProxiedBy: AM0PR06CA0130.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPFD7011BF84:EE_
X-MS-Office365-Filtering-Correlation-Id: 24a52fa0-f087-4af3-0392-08ddef7fd32b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZKJ7pwZx6vT5F3bq0DsvgNEhdbQXij17wE7pX0pEnvIxg0ZHEFIk154EZuDk?=
 =?us-ascii?Q?3bnhBnuzQhr0LAJNuDxRLDrKYC3LGFfH1xV89ggiT1k6fOXvaC8fatuTUbeS?=
 =?us-ascii?Q?HMoF8ViYeZ7sVCwNE245qJ4nH+oN6fFDFLirBvl6nYMhokvaX9fFG9MoQCnx?=
 =?us-ascii?Q?2IsDy+nwn1gxz7NDHzqYQgbs150J7tINdUnMjIKbfMKrZ2sqewRZdo+j3ZU7?=
 =?us-ascii?Q?9iHhJeZZx+gDdyNrQi78hEOULBTdCKk3J52IJvomMqfrCA7sMKNDpEL5k857?=
 =?us-ascii?Q?lbgFaODXmD9vhB6t3P8qmqaln7qLVBQbwKtaa2rrKJakRhTj8luvHg7FtK2W?=
 =?us-ascii?Q?DvTPTEuS6kHK/D08+5ZkB2PojuMOPmjQZPKSZLGdyjdzTuDE7J99ThzAC+tV?=
 =?us-ascii?Q?XTb93iQSvZIfYI6x8L2lMUJp9oA1jbsfN5eXgouZo83kfL3RullUfQOu/BNO?=
 =?us-ascii?Q?AGZu1zWu9E8OoZUVHkEJbIZw3j5BPvmr6h3Jm/dqaTHHsAJhVdibejh7p+tU?=
 =?us-ascii?Q?AIdPLqNFYobl4vnTi940oE9WOEr8EV9APG4k2nwptNemEtgbHnMRWH7aC3dK?=
 =?us-ascii?Q?JJGmk5AsvCXfZVMdyoDPkqRvnIO1hYPAjCDanU4m8AVpDNcty56YdvEmFcRT?=
 =?us-ascii?Q?rt4C//QJrSBY1yoQu887n6S7V0bdkmHU5GQvAz+oMNqM3Wiqhu7IhDT7BC28?=
 =?us-ascii?Q?BYe2IQG9i79pXNFng12cFOUzGpF+vRnBGc8jK82gQVLpVzhPrYiCcRD4YLlj?=
 =?us-ascii?Q?VHlc/YmV+oc+NkL0MkjoxkNoTWdE0dyJIwZiLHVoIOCsyovJCWaL3t/9Arg6?=
 =?us-ascii?Q?oCIMe4jlq/rlitwTWnDJhyIvg9a6AR8xIshrpJ5cd/PmQCC0qGsAFNK6CtaH?=
 =?us-ascii?Q?0xHeWqAj3Ok9u+PX9RgWYUPxG2tQCoKwjFNIBe4gt8zHiMqLxEWfRF2KDVrq?=
 =?us-ascii?Q?f6PN22VIQuLqI4iiU8SiPXmMr7n7BZVoPqgH6wsL5ywn6g4v3A9gJe8rbgyM?=
 =?us-ascii?Q?AA5zWZ/+O/8SsVx2O8Me+eEBkEtYamfMQqPForgmbs4dbjrpxqLxYA3NPxE8?=
 =?us-ascii?Q?aeTihL+TH5iMw1e/q6xSOP+7T/nMNBd+IysbEsOEcQRA1JymN3l1Qq6nQ+Cw?=
 =?us-ascii?Q?WnvY4hxI/hp4NdzbXbXVWWjOTXWsBATYtnbk7Xd2kovdQpMZuA4UDK5vauoj?=
 =?us-ascii?Q?K1/RB4YL2vROxIFfWFfgyozuw1QhMqbXyWHCPyJUjGTO5RViG+UW+y2gfRnH?=
 =?us-ascii?Q?G1XZwt7hyD3asLy7suvnKPlwsqWZFvCkBrssMJv4dN4PZsu5pkEbpsD5giic?=
 =?us-ascii?Q?wUqpRv1XP9Gv3QF/0jKOWCRxsdCUhBNj8tmJw3EJiGig8g6U+YqxqfaZDBWk?=
 =?us-ascii?Q?T+CBJycbJkQmJrKeKX9pHEpmPsj8FafVLCjuzWqABLosSiEMzf8bfcrKl7TA?=
 =?us-ascii?Q?XvP/uF5iK5g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mg3HRGywhIv2azhgo2OZ04NecRp5y9YzI+ef3dMJisd2MK7FbJerHlZUZrd+?=
 =?us-ascii?Q?P0f+RyD9a8lAR1SUt1HUu9BcQ8wtUuNhEQoZsXFHyggV/PRjODR9YagMF/wC?=
 =?us-ascii?Q?dgWK1lFwpOmbSsJfLcpBoShgzhGyp5ngonrNXiiUK2h+jJ8xMi3BNKiEgfYY?=
 =?us-ascii?Q?aSd4lMf+FlBupCm1p/wx+pbfVSo89XHCj0WKHpfmDdsenfZrdF8zccyoFyPC?=
 =?us-ascii?Q?IrzaSBMSNx+J8q/ViQTVcrXmvA6DEbuCL0d+DrbSxE8HstbMts1azDrj6ADv?=
 =?us-ascii?Q?e42cED0YXtQ0k6nR9UcMDr/mGgKx0X03SYXzSz2VIDWwSsevgGiAZIWv12T0?=
 =?us-ascii?Q?h8xwnONNJSK6tkzmq9ELl1R2KrcmEnlSYWj5ef0WknYv/7qLkZ0DxVH5uyTr?=
 =?us-ascii?Q?MkGKBsKWWtu+Gc1GHD/0ptRmiy4Yu45hotbH+Nt5s+IeDB8M9I0MvkLtIKNs?=
 =?us-ascii?Q?m0S82+XHieIQZjsjUmSvNsU2vtMkCtcE1oeHqx4ZAL5mdqNTszeWg/gW7l5j?=
 =?us-ascii?Q?UCm1E3t6cct2jy1AFMFpJUEb8P9r+FHOfMzYvdnD1ojXh+CbMXN2SwW6gNOB?=
 =?us-ascii?Q?+xn+Uojau7TI3HwMFjkZJoxZcOWbFIO1REo7Og96xwgqgXLuKXXfU9mK57Ia?=
 =?us-ascii?Q?QA8t5NWtuLHJMA8a44d3RWlqEKbkK56DQ+BbZ/2n58bCWJPHx4YO8ideDsuy?=
 =?us-ascii?Q?EeAdk+cmnAbaL98SJqMcv6gloo6aTs0p2C43fgoS33G62b8V2o8Lap6WlYoW?=
 =?us-ascii?Q?q0ZrC80XH6PPMbNwRKO7KT9toBlZt7u1xLdIHKzgyWo85v+9ONtRvzvh7nux?=
 =?us-ascii?Q?hZ1/eE4pFoeiAZR0JyIJA2hHvDQeT49JOsCWPg8W+PchqW2AomMoUJ8eWmyc?=
 =?us-ascii?Q?otJccO7HEOmZuhXKS0Ms281H9P2fU8uSI9F06Wxj9jMxjSvOf4FXSrcTl1Ke?=
 =?us-ascii?Q?+OjovU7SLp9b5xQcoPF1UV2QV48OWhoNY4tPNxKp4DIMLLDTY38cBdAGXn2m?=
 =?us-ascii?Q?Hcbmao0cO5vLQ3L/O5yuC46bjGE/TtyCtWc9Cg51z9viv9EYTqYLIXuv5HEF?=
 =?us-ascii?Q?O1YXcDZiMFmiOgnRCulfBNeUO0W6gpW4wiDgOGJpHFgfOwE2uHwGynMrfMs3?=
 =?us-ascii?Q?091HFMAtwu9QUBtsWiHBxjk0s/j9zb8AQ6usYgHPYsKHOwLk0JlQH+2Bwp5w?=
 =?us-ascii?Q?Vpjs/jhlf9wnu8HuvFEpU1SnuAa6kZpanIWn0/Jo1D3wyn/Lp+9ZC809XYU1?=
 =?us-ascii?Q?AvMqcMDeRgfOTnwJnibAZx1QkAz3EQfEEC61IP9LtiBhEFpbP5z+JqILUfnt?=
 =?us-ascii?Q?X1/K1OtDduX7rYDtLp3S2wR4huFRalOIS7Qgt971JNunPY1qgV2A3tGPQHGO?=
 =?us-ascii?Q?84ETBkN1W6W+IfhVHj2uoA/o76C4sG5ygbrcARjvGNUdyds2WEvOb5dUZnvs?=
 =?us-ascii?Q?p1sdHO9G1rbge5J55wVxGHa0IRN4oUTrv/0VtPBFy1j6CeqDOH7Nvz63fpo4?=
 =?us-ascii?Q?HVIeRBl2ltWMj21CzkB6ocppO8+ANErcQgLh7GDHE195Yu8hKew+QOoG5nWA?=
 =?us-ascii?Q?mp95dEY4OHykQPEEUrHy6K2ih77W8LYcHY3oJ9lw/3IoSvOsWnsIQKGwjYu4?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	36Pf14rwLufn9PGFSbY098eIhPaogQd+mRxDdyDLLctgrJ9BkcCeDtaESsZsU41cZZ9YQsR/WpKgInhOCkf3b1fe2qya6P96MUH7b5AgGMBzWWPGoGEY+FzcnQYaHfL1sK4n/uLSFPNWLyIKqUKgVZ8VVHtQ1m3JZK50Fp7L/TB4TfMtmxsSEXbsQ7qKn2ynuNulT7c7D5/9DHGJVAEBiqwAzFm7jywnFv26V+pzklx3jNaVKdG8LZY3cxRB7e+MhjuovIBl5wUP/945NicxjweI/tVDhbt/1JLZme7HpmnmBiSOIEch3cP7L+TOgb6F6VcI2UXvnBD0IMHk9EYsRQJbu/hS6oq8ppK7U3cMUHMyv2WOPLUqr2elwSycn/UGymlohylkxLwWQDEh975l8w6mySZ/BnrOwy/gUiHeUVBN7p3GGjdka+r/KZec4geNlbtyLQ7ieScj1kTI2QWyXWvAwV509m4Ohef7zsy2qwd+t5i99S+CYCYkFqq4oOnzxu9C95MalbgnGP9Yr6edg8y/6803mUyBNVts76ejXWpCuziFT2FlJDNh2Bx1hMpmezfe0ChJ3RG3NVXvsB5IrHgNY4DGoKc6KHb+voglbWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a52fa0-f087-4af3-0392-08ddef7fd32b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 09:04:03.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2xjt+KBRDpp3XOF6i9I+mw+TJaGSe29G9trE1p2rNZLMk1qp/+ge8MHKOSq1WEsXN8whZGYXldudGS9nDxFxFz8mqnvjx51/3bW/D4I7Co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD7011BF84
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090089
X-Proofpoint-ORIG-GUID: P5x6t0CgYSOdBKo1CrTAwMuGKUY3I1FN
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68bfed8a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=gCCswXOMG9V64mD6cYEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: P5x6t0CgYSOdBKo1CrTAwMuGKUY3I1FN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfXyd/Qx6ybAQbh
 7Dj8UwskNE/S5odziWFy/3fYV1fKhcbnEw1/3qK0EBcklozh+3hPp8mkL6wYDXZYeTSSxWZzve8
 5h/SgfUANUf+aAQsu0aAZdgyodP3dVdOU+gFZLkG21cVGywj1M3uGGO857hYVnhEmxEjUukXcoW
 vhFjUeukeUd7cWB31tBK8cgDTYrkxLxVaoEpmtHHGjUEvMje20+sI8+oXSZiLonI92t5nYmVkGq
 KcJtQ2CBW2WzGb+MNKc8Sn+7RRyGfyCedTNDwkSV/ggPP3TrpMd6DxrlKV0j1eaf91XQ0jSyRJ/
 yqEZxW/qspnLQNwYjhSPGpu1O/2tk0CFOAU394nuw/5c2WJQ/ebf5lIUT1hcWb5Y9SNXH2tX2V7
 +r7EMv43
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C54F2C0003
X-Stat-Signature: 39iprsh91r6837pz7mki1m3wxb6yxiqw
X-HE-Tag: 1757408668-202892
X-HE-Meta: U2FsdGVkX19QgWL0lLejAdkx3Ktscd0p7W3MiSSRMFjYnDSiIlcyfyx9PSCERbWbegoWsUvlJ4W/Jwmu3MhxSdYuSZ/eYlDSPfdgdryb+yFH8UoGX8yP+FS4+0xYJnucN2GIA/8BP2FV1XbwC227YOB1Ekgxs66MA5weBhVfXcMOMdh3LjBMefE9JtpbJX28/uKfv0n7aRzN0Kjh+yOVx/SqN5at/hncTY/8tqcOvDv8YFyR9Kc3w3PujYW6ryq0BNRrNV0f0fJN0S6UTQj69vBSFg+wa72mf7ZnRGO+1G+LnOIwG0NOIf1xffatLRZnONejzHO/mH/oSZ0fqbnJQHCRbgJ2LNgo9UWFU7VAIcARy7ei6TjMZWiSnpp1xDPDY2YL7H7uRdG+hqdlfwYaBUdxfCduGXK5ulzqVIRNPOVln+/joBtsFam8lEZMTPH1t/gBkWufcAYW4mWtuJZmIc/gf64ucnDaDbQHc+q9UJyL15Tsh66Xd41c2SScgwjTM1DGbsQJRBCOohJLRG+BczUXUgFk2lcj6FvoT2lwCXimQ7/GGJOyWgiCmm8Am7tLYMwpc/tS2JeTrJ5YreLVrkJYNmxxM5/vy5yTm61fB+4uloHShlliZiF5rmsmKOnX5S4bKOrBTR6vXYlcQAK3ZOOK6HkV1i6NA60GxcD/kncp8p4LwPHyNAYSRL5WqK6VRQfHOQiEUyeaPOBb4XxrJv39zTq8U4RYg767oYA1F1Oa75SEd6bwyH/y5kOZGFgLKkurUnpB3wtNyweyW6y4e1MDX2ePsTwIdr9RA/cLTzy7FsEfhcGAm1K1hjmmQg1joI5QV6EaPMNNT3LIRHxWmeAruxRUNYW8DZMF1I7nxSD8D/uCf8evMMt7co4nKGQhwWq6OmCsGsgAq1LADMl9haeSpxs2RSopjU+UFmEfeBuQyeCf0cNYOYqlCgr4SQrZr0HIghjcpHX+MDLB87d
 zw1Oocsb
 7oLmv8FEU9QYaa0Jz56lpsUj6KL/eHWOEVUhpiaF0QsBP6MbmeT3XSx8ICI6pzKYwHdrNchuysOPzWNL+Xmo+c6O2MOCrqLIK5RvARdEKdj324pNAv8jcL0yziJq6YXqpmSY9xfut9ZuquEDtX7ZaqS3GUZo8cxSnq79MZW9Ux07R5niOS0/JJ4KSmC5X3puiIBnnquaszxbgE6aHG+1EU40vYyHCXkovpOeoEPqfP/YekLaLlJgirYRpIDD/G+DxImEKrrM0Cgt1T4UoYu6tJUJDCdwZp9jy2N6AznWR9EQJEVYd5QSsA3ZKH+ZuqLr6xdmnbjrxX/yGFsJCGk1JfO5TVSW1YWqS49IprByMvyX/dO+qVSE8xv9usDNrE1s+TJAiPSomqBxdc5FV2Tk3IWNOPX1wcKNPYdKX+QGL4yb2iZw598ZO9442cr09qW+BVY4wtmWSNlNDrl4q/EVpccDLWU1a/k+X3gDYkmmCg8SM5n2c0gIHD1GdoJZsJxFA3E0I0+Bq2nAvwA9URnaMOvLiduiLA6G2viTdlJbMOWhxmRtjGKTMNtEKwzuxFCtEma/VXEHTRd3EJnD9cmUuvdW7wHRMNxQJhNXwb48WmMfe7Ho2lml6LHtatsDoEKI6HsK8L4rP0A+MauHiRRIYjshJhwAjPMDHklNuQflk8y9DE5lz5Tj6rcz7G0AJoaZMIOSictm/G3VusoZfzaTHb6k2Yw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 07:38:57PM +0200, David Hildenbrand wrote:
> On 08.09.25 17:31, Lorenzo Stoakes wrote:
> > On Mon, Sep 08, 2025 at 05:19:18PM +0200, David Hildenbrand wrote:
> > > On 08.09.25 13:10, Lorenzo Stoakes wrote:
> > > > Now we have the f_op->mmap_prepare() hook, having a static function called
> > > > __mmap_prepare() that has nothing to do with it is confusing, so rename the
> > > > function.
> > > >
> > > > Additionally rename __mmap_complete() to __mmap_epilogue(), as we intend to
> > > > provide a f_op->mmap_complete() callback.
> > >
> > > Isn't prologue the opposite of epilogue? :)
> >
> > :) well indeed, the prologue comes _first_ and epilogue comes _last_. So we
> > rename the bit that comes first
> >
> > >
> > > I guess I would just have done a
> > >
> > > __mmap_prepare -> __mmap_setup()
> >
> > Sure will rename to __mmap_setup().
> >
> > >
> > > and left the __mmap_complete() as is.
> >
> > But we are adding a 'mmap_complete' hook :)'
> >
> > I can think of another sensible name here then if I'm being too abstract here...
> >
> > __mmap_finish() or something.
>
> LGTM. I guess it would all be clearer if we could just describe less
> abstract what is happening. But that would likely imply a bigger rework. So
> setup/finish sounds good.

Ack will fix on respin!

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

