Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E288CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0E08E0071; Mon,  3 Nov 2025 07:33:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C606A8E006B; Mon,  3 Nov 2025 07:33:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB058E0071; Mon,  3 Nov 2025 07:33:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 907A18E006B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:33:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51A0FAFDAD
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:33:11 +0000 (UTC)
X-FDA: 84069235782.25.80F3A57
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF378160004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:33:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Cwvm+ezk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W6foDy6W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762173188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1f1Webwe6P9DpsQg9iPMHyn4nFICr08ZhIuXFw4tvLM=;
	b=YFZYp1JigHfvsYfqxjRi0UgNxBafXxKt5aRjAwLYrwa2LZiLeT6s4IYADktPPTbBRhIEhV
	ZGLat3qhXqMXX/X7ayMA7OLM88Xs94U/UvhvILtmR7+aO2QqT4SrbzwVW9WPiEXWddXUQF
	/BHwhNrHnElQ15XLa1/Zqx5364pkeWo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762173188; a=rsa-sha256;
	cv=pass;
	b=AIKI9DGmt7qxTdADye6qeVdtk6oAjX56rsq3RB/xYS7UEWT926/UJumss+xqW4ldBx2iX1
	E/aQE/S6+DI8QlCzcOPa1QeaAHPqFWB84P7xTQ0UZjRelmALmD6d/dYU/HHp+1WEVhBOV/
	t4FWht7lySeBqWrBByxKy0MF5RUPZQg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Cwvm+ezk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W6foDy6W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3CU15N012004;
	Mon, 3 Nov 2025 12:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1f1Webwe6P9DpsQg9iPMHyn4nFICr08ZhIuXFw4tvLM=; b=
	Cwvm+ezkdI65DsWjRzzzFLev5K2ip6uemH1Me5DMoFkqprCPcEYS1fIJLOwCR5dc
	ZNoll7VjC4CivILqfBE/mUsTKzXNHPqIHu610dlu/Np+ispJ3X2mkzgXyx2XTmzU
	XxXFoOVF2iykQYADQdsVA4sLHnTQ1sgNz54emHTj7FZX6x7lMdLXTCM/t87Vegpr
	eSmqRiUU05eaMZf4x695kpFI/OJOvWSnZ7ZkKqU90fQlIDNyhGOiYwfGx6BNw/0n
	aKdsms4xqAYHJSNp5r//8nr4g9iuWpezENPX6fuBEYZZHP+BMZnyfmsUhEOgZGn2
	z5Vog2W0f3kM2+tGso6q3w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6vep007r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 12:32:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3BY5jM020996;
	Mon, 3 Nov 2025 12:32:45 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012064.outbound.protection.outlook.com [52.101.43.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n83esg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 12:32:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUAvwquRMGwGw4GlRoh2PGDY62oYO6RgSxBBRjLEUMlmPioysI7WwW5LO4mBHKjFA8f643eumr4voNioNMW57ips1dZ3FU2BlFvXdIfraqN1tyYR8SgwraWpeb23hqteTaN1PVpkh2YEarin1eY1Dsc3i6QYrNMgZURzsW82yA76Ha9ZaqULa2KEclPCydqmAMXQv37EoYSIAk6TnbFPRWdRiPtrN4N2PQRagkVM59MNJRya8uk8NFFDSYWojfElwnpvOYLWaK1gO2eCIAqFi1Da4+8myOc+ZRgzzO/O6GgpWnKGTRGHumheW20Ko6Ju6Q6WP1iJ72I+8aLGDbknMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1f1Webwe6P9DpsQg9iPMHyn4nFICr08ZhIuXFw4tvLM=;
 b=cgskbfnm0zEZnYp1zZ6ZQAERdfWn5kvoqZj06LIebvT3/aR3U2wFKF+UI4a5u8DKEbiaJBLVPbidnR/B5YX9+fcOZhAnZ5oDPjGFIOGxhlKHb1TYvMG4G7jKciDx/wfLYcUN5X8O+QkMiiVTXFn5LGSCgBZTVIJnYgdBTcPo/HrOMjPXJ+LPGcnBIJ/2G+SDataY3q799FPPGcuV5Zb6IMT5k1ggr0LBBwBuIZDuX1KkfGg3sPbXsgms1ac0kyv6YnGZF4cO6YyYuPPfaJz3BKGFvwf5d6EIMLgRJ6J90Uo7ggZq13rcmIofA3kvcIZHiYvj0QdgS6p24BPb9tcZzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f1Webwe6P9DpsQg9iPMHyn4nFICr08ZhIuXFw4tvLM=;
 b=W6foDy6WqBhAGoioOllr+mwxXL68I9qhyoWNu0U99pmieam1OeeM1iifg90s37IXOjO8gnLbtWscPVu5khXLKnps0FXJU546jXACS0ggzDEpN4QCNzbX92I0Y5H9WRTm97BWY4H5gMg8hgOKS+SRZr/AyOh8Z3/54aLHVofoLMg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PR10MB997575.namprd10.prod.outlook.com (2603:10b6:8:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 12:32:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 12:32:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: [PATCH 11/16] mm: introduce pmd_is_huge() and use where appropriate
Date: Mon,  3 Nov 2025 12:31:52 +0000
Message-ID: <a3c353d15edd3e9b3b7f6ef7cc08260300550ee7.1762171281.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0114.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PR10MB997575:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bf3d899-7d0b-4fe8-3ee5-08de1ad5148e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HH/kFa0LhEN11Smg3hLGdGzoTKs/knSMR+CzvxDFha23CMdJBRtdFFSOozMP?=
 =?us-ascii?Q?8Pb48mBO0++kbZoOmXnxF9+GYdcyw1uIPDcnF4myfJTBuZ/XyEKRpBkRDpMK?=
 =?us-ascii?Q?yZsLR5whnGHCA3Ce3zBasuvWq+d4erejUoOv28xs4Y+ooFbVyO/gJb++SGZt?=
 =?us-ascii?Q?uDfcYepsrVpLhbvdoWQZS8+veNbP8YFMjH6y5GKDKsONFECl0VrNK/lJ0dEO?=
 =?us-ascii?Q?mxtor4jTKRuhLnIPShyZm4FMl/uwDvULlewgjM7145oIHwohrM7VlCq/H+GK?=
 =?us-ascii?Q?+sCA3jLDocghxQD3+Z+F5ofBsRirC+Jw6eRoZuvf/1n7umiP9JwYalohNNXf?=
 =?us-ascii?Q?xmWrIfTt5V3niTcFjwiD26mRXyARyvbZb98RAqoFrer7+1vBl4ERFxIFPyXo?=
 =?us-ascii?Q?aacsNWQxOdqWPmWGFSrWd4sSnFeWfJgQnINVbw7Eg7t8ntAE8eFGXrD8Ng9j?=
 =?us-ascii?Q?7WxrV6hnHwCO9vamdo0q3GCscRhjpF12KdrSvKrqJdvVxCuwg0NcNmvj39me?=
 =?us-ascii?Q?vd11Bvul6/Q5dzrD8mY/AxLyTzQX/BvV9lRnC4zTTYY2CTszr+OoYHcbP00D?=
 =?us-ascii?Q?Up6kboJ13eE8WHDeDT7XIpUTI2EReHQqXuYaVbaopXm/XE4pNmF6PTWLICKD?=
 =?us-ascii?Q?qCIg6iPaA88YqEfJikXj8S8xI9TUFxbo4vv83KHxQjIRmDSjHCR/e8NnD6mW?=
 =?us-ascii?Q?Yz7gRJoT4ot6eg2T+0iIDcp2qrQEtIfKikIOGRbv4OPIcPUGlvQxRHoKAzqW?=
 =?us-ascii?Q?N446q2uuAJRwtnpPSxnqKJUgX5jTJ8GBcLa9xWsEYDCmmjYb1/yFXKTuMMHu?=
 =?us-ascii?Q?A3tHcXYY6Fbhfm7LKHJS340tmd4PZIKJHMCNuZ0g4PH3QGImAL53BF6rHLAT?=
 =?us-ascii?Q?ccfqUH/QqEbWT494QEKIUPYUgJ0nBXl7zFCWFUZf0rGWemAX9LpUGB0zJHSM?=
 =?us-ascii?Q?ajfdntemDuf6QJ2TSTo/LLenpMeTzkx1r/BOibCaPu2ZRN7Fp7wELqlKwdTn?=
 =?us-ascii?Q?utRgH4+PUBYlSWuzYJDLyVhP48i4t1k+baFq1houhNJbvn9TqfarIbYfQWTy?=
 =?us-ascii?Q?KSruuHT+BhCL0mzS8HuyJvfoxXCxPQdq3JRa80ZeTgD1LN7lT6DZxq5BcZUz?=
 =?us-ascii?Q?/5JOCQOtHVdKEKXUYsGjmUKiGbi4PO3BRjQrKS0wvLuL2QqaxD3b8wu8iiAb?=
 =?us-ascii?Q?fjV1SusRLwRTkLEG7tqv0FSclcvtO6JqRdTWesu6XAtFLPwPTQffuWlYZLyO?=
 =?us-ascii?Q?Ou/wvY6GdJJv+S4nwt9vsPitijS3SAgXeQXmgVQ2YGMfPxZB366E+aM0ci1C?=
 =?us-ascii?Q?acmrGkigJ0Oh/LlPAWAR9qGiDne0UaY1IIBJKK4S7RdJJcyfyozgyBhd1L1d?=
 =?us-ascii?Q?HRmjzljg+BN4Bmdy+DFXmEkoPiZkEniFnUfwJIbhT+R2n2WxipGwTkSvvRc6?=
 =?us-ascii?Q?ABSm1WRHNzcjs4lqFgCYbNktVmIZyEou?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B2MvbjbbG++9zBbqVmSPlGxqprhRsJCiOyAHlEcSETFBCx0TEgMK0Y0srCoq?=
 =?us-ascii?Q?/aPfMaiAvTyunSuHBn8A2t5tZq27Oic4F654tZgKxUlWBofWdv1JMzHK4PuI?=
 =?us-ascii?Q?hHB47/8ytg2aHZk/w5cSiVnL6NRbehZtS+bSYIYqV/kTnS8PBZZvRyAS8dLD?=
 =?us-ascii?Q?8faN7u02aLnBwd6XHR679lKewZnPWf5gfc3dCI15WBxlanbMr4+Q4kNIvkWq?=
 =?us-ascii?Q?UVwqEYYzWDZTeGEny4smJMG6wXXmr0Z0bwtvz1OhG/SYo68m1ieysi6t3Cm6?=
 =?us-ascii?Q?F3nNH7rVOyylvYCrurUWynWfxPxwXkPr1cQ5FBxQWLWW0B49wIhjhAWWObw6?=
 =?us-ascii?Q?B72y6RCTKianVtm/OasMO3YveNhcQPB7jdxYfdAzN286Vn7nx20aJP+tbvXs?=
 =?us-ascii?Q?rtgSSiaHK/GtvWy55JsQ+qvWIdtQ3IcB7CsJ1bKbXd3N2JHhlWB3UByS+d2r?=
 =?us-ascii?Q?8AekPIevPus0011adnNrF/SI2Tcw2tQklHiZsh70+5t1KofUgwLb1kox4QUq?=
 =?us-ascii?Q?mT4MN32PJs5yKjnjiNvRxr3oIjYvjoqFJZi0kAr4ni3y3a37tN0EYCDn5due?=
 =?us-ascii?Q?3+ngUTo6LcUS/JLRagSbQwZ6zIdVP8t2sE7AWSZbv//joBm1rgXWUbnTS7IE?=
 =?us-ascii?Q?kVUrUGaNsedamycmivcNaMtyewNbCBPPlq9YaILIVJ0T5tsfluvzdsvFxWpY?=
 =?us-ascii?Q?Gxh6qwt19fsKaqDCay6hnyZN6fI+TrlU52AaTtVLFztHQiKywG02weG3LMeE?=
 =?us-ascii?Q?o01uFb6hlVQsQLkY+bT4KhgyGfPfEI9evkuVD6UC2dNPAe81lRM/UQCeXnVc?=
 =?us-ascii?Q?64D9oyTfZghBpYeO+4J8b52SsXrmPJrqKbF23T/FiUqAqBi0QurLW8zjHxaP?=
 =?us-ascii?Q?uNe/np5ZcPkCdNBSx+6fVm12Dyvhh7e9mP5Hu6udpd6VrjGMAaxinE0EHVaf?=
 =?us-ascii?Q?YdHXKTCzn8Y290MAygJVJ6m0TeF8unTDg1xVTYBa8evhqxBVZwWFPXB4T93y?=
 =?us-ascii?Q?FZAfEfYmCGcvcoUzS4pnm8EalszW2s/8WVKjT7Iwpl8liZ6g0r07vv/vFpie?=
 =?us-ascii?Q?6sWxUVX+gIdFu3B4clG7Q1KpgQrg3Oio+EKw/3Pgcnron7LHeTF9blB4w6TE?=
 =?us-ascii?Q?SjxvyyO+PpOUpkwO+IbGJ482J8FDx+mjirx2jldAEcv6ITMDih2hovJmNRAU?=
 =?us-ascii?Q?FErHUzDDYMAhmWeDHyywu+PhQIp7CGpK4qtIPiKHMxUUG+TRTh65x0LMliUP?=
 =?us-ascii?Q?2YkOCRRWH8H0ftd+uZEfqBhk1DmwM0ZHKqNHJt8hPrDyJxlekbf7ublH7Rf0?=
 =?us-ascii?Q?scGdDR9doCrf4pKP0pdKpVw1DbpjvutzC0AsnYKZd67Y5ZRAofpSY5pC/0ZP?=
 =?us-ascii?Q?EDqopr1mSyc77sFJlxXpNFieLIHaMBUUlW7uV7Cne/sDYg901BIVMBPGFSGm?=
 =?us-ascii?Q?xXS9GqIRF3KylWJDEXIEnP9yQ5NUfsi+zw84fmJX5HiNizc7yYzmDE+XR4XV?=
 =?us-ascii?Q?BZ2XYK7j+ErP+qgiyufUWNSpRJWxnG1OE4EDr88NEorCxYb8oe8y9KnDJ4Vj?=
 =?us-ascii?Q?M0saoKnu3qhRxrXVKi1u2xCUt5lnAgIt3SkM85K+t7awIPRkQxiU4NBh8FPi?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N7SMsZ26nojRD1Pl8kCt/WXFw1bWbEK/sWSdykNa/L91wQj2QyuBnm5/Kx2x/jSwQ9K+VNLS1eoxhnfFfEE/MfkMROnh2dnc7VIZr4KI4nE8kBuDhRlcpC6v4OrrtTE2gMoM/cg/r8h6YhLhhg4Xo/4sWxhthMe4TSrlQQkY4r4zee/gP6cvmaE2nm7QjxDJUpvyGMYe8ELiY8GJqU9j0U2muC79LqtjcEyx8qZkfguXh4/afyc+/unor/n4JEgc4XFc7zXSLeHZwTPiIPUU1rmu2Ohw6zWotRTcsM7flhHLBKgSQiU3IExXeHskczs1jlStRp9mck12QZA7uRUsEXuktE+09RtWjVPVqS6o4Kf5y5FGktRMcEj8y+r8Lto9s+rmtJoFFH0QGYlWNFTM9cSE2U1zaHdWtmITgJ042TwH6rrS1WNxvKN7diLRkZUlu3PL/LBKfuuO1Wn7H4pUli7VgI++H0sQMoiMZcGdDMs6+w4yIfwDipMityWkh6TQsJxrjSo1AP9f+5mSikbV9r4nY6vs6wlg9bB/fEepygLU3wC1ytwh8wIKRnKGZSk6TN+Wj3dagDWVSSGDe1spsgxjWnO+G6qIrgEDgE8Th9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf3d899-7d0b-4fe8-3ee5-08de1ad5148e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 12:32:40.9054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCeD2YCN+3KlhK2PgxKBqzRdI7JVDVei82w4mnUoSqi0MSdZw5XCtUaWyPyz0nrJeMNBy6fgWlkIYcNnmZOtvmrqctYZpUF+Xp/I+KHxdkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997575
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_01,2025-11-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030113
X-Proofpoint-GUID: FEQr1aBUwY6_qf20eaVot9DsRWwDGzhK
X-Proofpoint-ORIG-GUID: FEQr1aBUwY6_qf20eaVot9DsRWwDGzhK
X-Authority-Analysis: v=2.4 cv=B9m0EetM c=1 sm=1 tr=0 ts=6908a0ee cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Z_ABK6pF82JkGIUUY4QA:9 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDExNCBTYWx0ZWRfX/PZWDxOUJy28
 1GP8qOPr9TeAE6JZIJSMPbqBF9JV2zOgMmoX8oGLykavfvuy1QVHke2iEN1fFrsVKHTtIZH9tBq
 QixqpEY6voewAXgb7xXEjEINnQ16hbXtmNgLGtwO0/Bkg7jW3gcM0fUySSaMdByVw65ZguCr6dO
 M3yGSlgvHj7nFKml2boYhjdIk53m6+jZ0r+D1RlfZmn8n5+8mq3AyaqYbeD3z1fuhh1fIoh592m
 U1YHUzd/D6x6AqiLjtcJ0VvNU2NcwdYawC97KI9nm/ZCGnAAIe5OMgWYZQEeBmk3Mz+mNZXdADy
 bvBExZY/8oFiZ1WcQe8SF3FFsqxl1Tg01YssQETt5684/WIya79Gjd1jtikbwYtHGUnoGOlXq0R
 8fip6SShG5AQqDDdhPV/Sv50tSTKOg==
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CF378160004
X-Stat-Signature: s7bdmzdu1k31mn8fxnymaawrwsj3ias9
X-HE-Tag: 1762173187-879034
X-HE-Meta: U2FsdGVkX18MrzjXrrgRQIggi0V2TLYMO3CV62INz6M03ZnWbaYVybArIjbMCO+3ifhsB2SsKVR3zBaPQgWZrZwOytjFC/1jdCGHYNnKn1ie8ssQ62kxceQHVPRpgPyncGtw/qjl2zkFUJWETNn+TiQxQCvngGGkDtbocX6FwHMdOF1JDGSuB43hXg7mu1PQx04ywWFTnrq5GR63GIvfLorVrDEvfChIobj5lInAUfxDd4Q8yMNi6klJFgiffEfsFeMZWRKetkhbI2F+/bT4MI/rIWxRqfpt7zZt/mGkf15pd5fhefrT50pfpYJafQheW4HWTU0qdHXV1nYZjIpAaxv98EttYX7c+E3Ge/eo/kPKZI8U7C6BCsMhG/wAzrnnOCa9jisE1MhfqA84GXg5rdhQFn0TKZQ2Zm64TaaG5vT9LV7QR9xeSFot8h0OUtpbficeN+qBSuu4Kf44smVRQtt1obKRzgMsPsfE1lQ3GV0j52PfInX0KML1ICAU98s0btRcBtGIu/JU5Vp44Sv5MivsZupppJsTaGzFaed/f9zdPkJIZRrTMAACuQ8CDSN8x5nXq2gM4lPnnNdBO6Wydu859WTtrz03UKEWSRMZm5S8jfNk5c2CRriqEebTlH/rVriEGt2Ij2dT4Eu0IRI5YCNzgTvemG6eiE9kpw9NFVyvAxJ5Jol1AQ4Dr4l8USzOHR4hHA51PXD3hy/5dC6eF7KX7HtiSrUCHcvqH9L/eKOkbq8jm4oYDinnWV2Jp12/zHFYbmN0hfJQ6908hLgbQq/M8FRaUAhqDZ3PdMzZWSSSV/4b0rq+8PVgR6PfvXwMKm6xXQYTTXnEZlpmKMzLRfNifu9dI9QENA9+CQoYGNteuIHzolnUKyr2VRq4dzaJT3cwwrtcWzJS9IeS5c6z1JMrv0CduoiBzRjplkm2FNqyr4HfdmXfhODY5I8glByX8AgTID+KaIOQbyObRX2
 3yCi+tqz
 8h2qQ21PoCxee5WOxkAazJ76OOY6zvG/AbVXcqtve+K02GwFQMjzKjF9Nqqm8+jFOuUT4dkN+znXrO4gmactoxVDuig7Xm5q16DvE24iJqE+eXDmOnq0PHP9pH6jB3Cj6J/+qexUm5bVkUjmlnvO9xRd86Hp996bOnR1QWYnn7OQmU7FeMwaKAQHec8hbUGsbUhrnhe4piU2j3FwF8dJ6YlQtt6LBhmz1o9JbSNwnl3jmCKEVy9OARjVIK7SNKYXt6gqtHojnoyKeONzXSGTvVwzVspQBAj3gpTfrcWy57HF6qKJvwMAYAbJ7Q61duXefGCSwYpPTGBD0pV/qNRLojZJaVTpbXOLaN5lGZggkSy46mNa7+O8hVRmUj2FJoqHWTUXtYmRlKhrwtZ1IAEttcNu/W5eGIpmBQfviVH7DPSBQLkOrMF9NpMUpXMgeXq2z29D3Y7S4YqppE+M9pbj+z/Bvxw8sUWAt2QsLi/8LiXahNcDM15sY253+WLGEis2Wg6dbK3MC1VUUd3zp6o2WSG9vMMYnZCbAHbAYESSFpxpWT6YYn061BubXnEvjw09+s7FquCxTaygH8/YwC9ru783USJ2UajiY53HPVb9NJJNjFWY7Ap4z+dyXp7XnrrKpaxV0YlI0A7Bzsy3B1+F9a9G78i47zA7ZJHWHQDezsUBN2cbhvPLplbyuoj9pSlvna/Zrs3SeBKBEbJQGdONdI0lD84OEIsOjfEMbcvyNr1LhDr+EF5nT9BddLv/FepXfvya4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The leaf entry PMD case is confusing as only migration entries and
device private entries are valid at PMD level, not true swap entries.

We repeatedly perform checks of the form is_swap_pmd() || pmd_trans_huge()
which is itself confusing - it implies that leaf entries at PMD level exist
and are different from huge entries.

Address this confusion by introduced pmd_is_huge() which checks for either
case. Sadly due to header dependency issues (huge_mm.h is included very
early on in headers and cannot really rely on much else) we cannot
pmd_is_valid_leafent() here.

However since these are the only valid, handled cases the function is still
achieving what it intends to do.

We then replace all instances of is_swap_pmd() || pmd_trans_huge() with
pmd_is_huge() invocations and adjust logic accordingly to accommodate
this.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/huge_mm.h | 39 +++++++++++++++++++++++++++++++++++----
 include/linux/swapops.h |  6 ++++++
 mm/huge_memory.c        |  3 ++-
 mm/memory.c             |  4 ++--
 mm/mprotect.c           |  2 +-
 mm/mremap.c             |  2 +-
 6 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index cbb2243f8e56..a09b6d39f450 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -419,10 +419,36 @@ void reparent_deferred_split_queue(struct mem_cgroup *memcg);
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
 
+/**
+ * pmd_is_huge() - Is this PMD either a huge PMD entry or a leafentry?
+ * @pmd: The PMD to check.
+ *
+ * A huge PMD entry is a non-empty entry which is present and marked huge or a
+ * huge laef entry. This check be performed without the appropriate locks
+ * held, in which case the condition should be rechecked after they are
+ * acquired.
+ *
+ * Returns: true if this PMD is huge, false otherwise.
+ */
+static inline bool pmd_is_huge(pmd_t pmd)
+{
+	if (pmd_present(pmd)) {
+		return pmd_trans_huge(pmd);
+	} else if (!pmd_none(pmd)) {
+		/*
+		 * Non-present PMDs must be valid huge non-present entries. We
+		 * cannot assert that here due to header dependency issues.
+		 */
+		return true;
+	}
+
+	return false;
+}
+
 #define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
-		if (is_swap_pmd(*____pmd) || pmd_trans_huge(*____pmd))	\
+		if (pmd_is_huge(*____pmd))				\
 			__split_huge_pmd(__vma, __pmd, __address,	\
 					 false);			\
 	}  while (0)
@@ -469,10 +495,10 @@ static inline int is_swap_pmd(pmd_t pmd)
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
-	if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd))
+	if (pmd_is_huge(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma);
-	else
-		return NULL;
+
+	return NULL;
 }
 static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 		struct vm_area_struct *vma)
@@ -744,6 +770,11 @@ static inline struct folio *get_persistent_huge_zero_folio(void)
 {
 	return NULL;
 }
+
+static inline bool pmd_is_huge(pmd_t pmd)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index f1277647262d..41cfc6d59054 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -471,6 +471,12 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 }
 
 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+		struct page *page)
+{
+	BUILD_BUG();
+}
+
 static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
 		struct page *new)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4f8d4cd106e8..fa4cad7d512f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2810,8 +2810,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 {
 	spinlock_t *ptl;
+
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(is_swap_pmd(*pmd) || pmd_trans_huge(*pmd)))
+	if (likely(pmd_is_huge(*pmd)))
 		return ptl;
 	spin_unlock(ptl);
 	return NULL;
diff --git a/mm/memory.c b/mm/memory.c
index ce2e3ce23f3b..1412fc84172d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1374,7 +1374,7 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)) {
+		if (pmd_is_huge(*src_pmd)) {
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
@@ -1923,7 +1923,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd)) {
+		if (pmd_is_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				__split_huge_pmd(vma, pmd, addr, false);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ac2cd613f76e..2134e28257d0 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -474,7 +474,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 			goto next;
 
 		_pmd = pmdp_get_lockless(pmd);
-		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd)) {
+		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false);
diff --git a/mm/mremap.c b/mm/mremap.c
index 62b6827abacf..fdb0485ede74 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -850,7 +850,7 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 		if (!new_pmd)
 			break;
 again:
-		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd)) {
+		if (pmd_is_huge(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(pmc, HPAGE_PMD, old_pmd, new_pmd))
 				continue;
-- 
2.51.0


