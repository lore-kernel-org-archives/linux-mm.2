Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24352CCD1A7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE588E0028; Mon, 20 Oct 2025 10:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F118E0002; Mon, 20 Oct 2025 10:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1968E0028; Mon, 20 Oct 2025 10:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30D798E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:14:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCDC11DC767
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:14:07 +0000 (UTC)
X-FDA: 84018686934.30.3359A8F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77941140015
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:14:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PmY4CW7M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VoP00omB;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqJP5LSlTyqWEKn83Vhqv5Rb1/W3bmdqnsXgdwjN7Dg=;
	b=D3CCzTmhs5zluyBJBdzaYgoJBZsf7zDX9uwhxZnaLksBpm1+2uFwGV+deaZ+ORv16acA+V
	pa3bWrm8dy8WfXC7MVSt62I2nOOZlYx52TXU7Xh62ByMsLQ8Q1B5aZHc23RxMf3DGgO19K
	mwNHus+WB5rlRHdsfz6N2VOJPP+l7B4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PmY4CW7M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VoP00omB;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760969644; a=rsa-sha256;
	cv=pass;
	b=TvVydDeJvUH9+lyJJk2yRPzTsNQC8wqqH9W0/F0LzhkXzkpXipfVB7sga3Z/iGnucIxp1H
	pZy6U6fsiJ7fa9xcLaPK9FPdfNAdqMae8Rb6SC3xeJJQuE/R43tjllYASOXHAvyk0xFCce
	uDKz8/vvtFvdZk7SmWcdMSV8TGgn3YI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SIqP028347;
	Mon, 20 Oct 2025 14:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RqJP5LSlTyqWEKn83V
	hqv5Rb1/W3bmdqnsXgdwjN7Dg=; b=PmY4CW7MOKTmceYi6Zu7tKlOHFc9Rjosdf
	M/ljHpkD9D/gfZH/EC8TNG38gKB9Zhu1IGzD7fzL8EjWFu4PEAE9yi5h0x1RTRNI
	sc7EGhPh6+YJlWEAwbT0uaKLtKYjxc8onr+0qy4bjieHC1/TWaaaACVie3cZLPel
	q7hYwu5/E6RgWj+9H+FzHgpNyrmIjuUXQurAnp1aY44HUqtBbxsoha+loANm6zgo
	i5xz4T5HY/WbqaSuh2fNd9tgsDWS1t6ErTg15dMwr2QF4q/3wfLYQxNlmnPSuGDX
	QblFtQoYhGQx8pEWFRNcaizgnmhdvqWZ00stV475hCR3IyJr3YDw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2yptb92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:13:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KE4qG5013125;
	Mon, 20 Oct 2025 14:13:38 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010018.outbound.protection.outlook.com [52.101.46.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1baqk36-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:13:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9VC2pClXQ5rb/VXJN9N7U+xeEVNpDF4n5v2EAFmGZQBeAC2+ZDThH9xyRC2HpfMTsUlRoX9PVt6eA9ZZJH3N3lt443sDTEeamzsZZ5HwYiDT20XF/vUSfplGtrep+UcUa5akz4ouxkMAwPQEqCRzElIEfE0eoFzB4tgciVB+fsrVglwXKzB2YgPZYF3iNUhHUna6Y+F/0Mzn6quT1rnPHLjxsNqdXHJnKfC1VwCl6/R2nUNTx26bTEBS9GFjwJL1NubKSkIp18fy6ZGkXThxgDEoncc8Dj/EAP1wEaKcXIUiPXj1dcXVnznMQ8W9G+ILMMrii/MQezYHoMdpzafXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqJP5LSlTyqWEKn83Vhqv5Rb1/W3bmdqnsXgdwjN7Dg=;
 b=J2p7CUONsC0oCsLb4ZNSGz24fa8W9LlpVshi4dOfym/rIiVMHdAJtQaoC9JREddrv6TiRYO3+Sk0zLVryUs30t+G+FWHvwiW7rOXR7w5HXjVMG7FdmXl2YCKZU0mtQuJv8okB0BuZqPny13a9r5TK4UHp+VS4tvQVHof7lu+iFAUV1jc5/j/iXAzg8HRyarkt3s/Cke+fQ0KyGh1cjqhsaHoVKfLjykBXolvKP7Mhzyjjon5dU2cQgB5oanM59ThnMtAN99V0aw3OKWkVNv3AC8K1PorVdLYEB3HwAmD/aQxU224HignqdWZYykVLzu5TibvNDcDk/DQ0DaCIR5xOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqJP5LSlTyqWEKn83Vhqv5Rb1/W3bmdqnsXgdwjN7Dg=;
 b=VoP00omBlJiUAGHqDp+N0KMykcZJDClFTkMoFwsaz+smiAdpYUklNmLiMXz04xS6i+QAxwBFSAy7+V8xBTvqA+xUjDe3sOqjL8GKko/xFBwsvwLWRPiMAj3L3W+VPKpUO6SBnAd02jpCSGyJyLPwA8hsJ0c/FbAZbhYDsaZxhcI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7669.namprd10.prod.outlook.com (2603:10b6:a03:542::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:13:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 14:13:33 +0000
Date: Mon, 20 Oct 2025 15:13:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
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
        David Hildenbrand <david@redhat.com>,
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
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v5 12/15] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-ID: <270738c1-e2e5-4e23-83d9-7709601e2e40@lucifer.local>
References: <cover.1760959441.git.lorenzo.stoakes@oracle.com>
 <b1afa16d3cfa585a03df9ae215ae9f905b3f0ed7.1760959442.git.lorenzo.stoakes@oracle.com>
 <aPY7eQec0bB9847x@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPY7eQec0bB9847x@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-ClientProxiedBy: LO4P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db3c880-40dd-4012-195b-08de0fe2da91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mHRSZkotvQpWpzKPJGyiMxEW4vWHE0CFIOGfv1lwdVjQ2nnpaTKMli5N93bj?=
 =?us-ascii?Q?qcjvQjGJ9UR1LHc2Gq5Yc/0lh3AqrKpnTrmDOTZp26o0vlqeJWw6kHSKa6r3?=
 =?us-ascii?Q?0hgeprbnYe9wvJNgsnUW4bdVN/icn+a2pCzfAT/PKBzcdyyySQlVTUp1i8g4?=
 =?us-ascii?Q?8IsmCswzd7IAvurzzhrQIXIWsyjKpufEhUZy5nJTNG5xTByMFiYyex18vDLd?=
 =?us-ascii?Q?upiCQ7Esab/zH1gO/lQr5494KxLw/OnzZsTcp3VMunCOKczUljoKRgH8xLdk?=
 =?us-ascii?Q?GM1biSN08Kov9yDugfnSAqz5FbE5mSs2FT/CCNEFsvqobowCygx1bNQO73ed?=
 =?us-ascii?Q?IJPI6z0X6NA3vXY+7BCi3LKTosrmq8TBhSDNdR5CcI0Rs+cGqPA2N9AZr6kd?=
 =?us-ascii?Q?kRJ1TMoUM5fTIpFDY4lsmH0Bt+C4YVNsHBw75K9/SmxG6KS4GP94zGS1fEPl?=
 =?us-ascii?Q?9mhetllstg+7nCaRkM4xKOg4lZxWo04MQtiZHRZq6BUCr0yJnCyv71IDyhFz?=
 =?us-ascii?Q?gYGOI4mQve4YhYhX6YUuC0lZp243nxoEnLMVZtfBj2UmiCUFVre9Cy7RByuH?=
 =?us-ascii?Q?CxMZo2H/Nwss+fhjiy5/0XBXKKQ7RfGFSftueG9xKYwrqW9pclgrbwzEdwui?=
 =?us-ascii?Q?KzS4t3c+zo1yDGuI+jU7B1sepol5vo4SpAMO0Ekmk4jFqsvhW/2dBBqPmrAG?=
 =?us-ascii?Q?inE340TroKE9n1b7izuMkmYezz8SrhAv2UZiihrhZzCZ4bhVW+JKk4nS97Wk?=
 =?us-ascii?Q?v8x5kZGgCPbnAbXYMWjr5Ms7I+41H3E7VIwKaNPmXE38SIv2tO5+iK8YsZRH?=
 =?us-ascii?Q?J8hC26JA9kaThb9hpe8cLGTUmPJD3giq6EQAVtzh86WED2HYbZimlG9CTsuG?=
 =?us-ascii?Q?wsKTVPiMHhOIac7BMCALT00T2r8ibCJf7z+6k8uv2+WS0fOxzgg6DncD0rJB?=
 =?us-ascii?Q?Zi550ulHhNLiXc90tQk6m/LOeATUr8w1DOkGP6M1oaLxK/M692Fs7EvpN1nn?=
 =?us-ascii?Q?CGLxJBszVK8wXs43XG+a7j/5N/NwP/xvScpbxFGsxSMV24i9+KCUX/uZZggt?=
 =?us-ascii?Q?/qfpEt5h3Dx20T9TGnxPmAxHOIOf5wiPCtus9prywilxm3F/0TiOdjTBmqWH?=
 =?us-ascii?Q?j8QWtt9iJyTHFrdS0cQPLMHwix3Db3uIEm2M4kMLaxVhK54mAorijno934Ui?=
 =?us-ascii?Q?1BRcXALOSZSOeJt7B+vAGbBun52zUZCvG7INc+Y6W9jIzmfCORv3mq53mgWF?=
 =?us-ascii?Q?02lMnWTMcZtELIQ2F5xNoWfzFnUWICB8C99CNHsZVwdTbGl6LfSDsCqUcK0u?=
 =?us-ascii?Q?Gj/P8qmwcNsq3hVq7IfCckz/d3OHTyJ7voUZMYY22HQozyBX7j2IGjxSATIv?=
 =?us-ascii?Q?5BPmWvxJuOxEOSr64J/woxn9tVtZm3QI7iCKJF3r9J9SlaJ5wok7TyrJe4Ca?=
 =?us-ascii?Q?XIZVlHtIbDTkYTFcnR+JQSDM4hMr7y3j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M1l69Ii4h73OVG+aq9YKj+syhqEQStHaBNWsPyhSFmrr/Il/ay4fTun2iLDp?=
 =?us-ascii?Q?EkhEtFgKSdI6VQ7RNx9rgQhCRYxteS+o6WBCd2sXyr0I6WuP2y1McypdFDYZ?=
 =?us-ascii?Q?q/1gKtrr/UBpIqVE6j0JKBqyTuJ3Z5BXOu4TVYCJRFFKul0eVih8qGbPbO3d?=
 =?us-ascii?Q?932bMS7ut7jng+nSQKizj5mC/SI/3xi24ACLyhIAQ9B0q23r1vn2yFr0rzs7?=
 =?us-ascii?Q?Ph6fN9Cl0LcgJAA15/biN+3hDrGrsGtxdq1p32SAU2pJ9pLhjsi7h9LWnCSn?=
 =?us-ascii?Q?EcqXGqeaJtAUbKT7taHEnnCGk2P//F6lPBLvwkvfJdf9EryBZrRTu9A6rupU?=
 =?us-ascii?Q?5/e3qZWUg1sfThZj/IK2rcMw0KWRvOYdkqq6SVEmHSYO+2SHtHDkq/M/hcAT?=
 =?us-ascii?Q?YfEBKBpMRKRNVcacPYWe+01hceyHIEQ7ZSQ7V7IjH544Lszcp/+HzqfT20Yy?=
 =?us-ascii?Q?oQms1xsLxvV5Tlb3BK2QbsHzCXINrP/q2tweBWdQksE9BwzdTyZFGW2ponas?=
 =?us-ascii?Q?zfsBcKqSvOHRKxOssxYN13JlqvichnjiVDlmEmdsVP1R+E/haYT5W6w8u3aP?=
 =?us-ascii?Q?CzASjsB3TIvElX4t7IDxY88+C2xGe9OUSdjeHZaoN5xD6x/3IbCa+yhZ/1l7?=
 =?us-ascii?Q?hUJQa1jiAauya9PQ8yWVNsOfl863GBHH9fgaP6MSysMxya6RgLe5DM2bfL+M?=
 =?us-ascii?Q?moqFQCaoFAxJ8SaMVul1fhUmcdR9XfDNTwi3UOCAcfDTgFpEgvOuUE9EiVNh?=
 =?us-ascii?Q?PbxRK5DlpvQ1HCdVGq8W1f4yGX/csUQs6iXHOsIjcKJS7eO50c2GJABI+5Rq?=
 =?us-ascii?Q?hbAj3xg5gePGKSe1HeX2tIkxQKnw5ieIp6jlnfBB6jyr/kh6C3G/WxzyKENZ?=
 =?us-ascii?Q?cRgyl9k1xoU8s2te1Y/CE6/RisEWcuPu5hkL31NFKHoddeXG6PLvcMQw/wSL?=
 =?us-ascii?Q?w+PGg1HiqtIRB7OqTxqrKva069baK6LToAElrSA4BFP4EtVLF/PKjgIPKWyl?=
 =?us-ascii?Q?jEswUOYv7r9cbUxSC9WD0z0Tpb67DIJqlmH3faLtKVpVfapI/Z0RiFEaLyef?=
 =?us-ascii?Q?r4Oj261b149unMDXGAsIuKnx4ZcgH46lnFumpV1IhXMEAEl5WS8Qxk1Ngd2u?=
 =?us-ascii?Q?BEitIdGgHpLHOSSpl/Gkr3vxN/7Bj4XVhbYk5o34Qojvae6IsfaCCM71Qpfg?=
 =?us-ascii?Q?uN28BLUA7gBOcNMe90M2xTAqCAsHCr9dN/0f3dnaHOCbPMIOMrkaO7ns5CR+?=
 =?us-ascii?Q?7quRXQKrwWiA/ZTvyFBXc5CjBlwzTeMMYHp3oZB4jZNTV/jUGeMw8J2BBAnW?=
 =?us-ascii?Q?49f2Na4I+56FPvvstfHStubUxT3d/ZlNSpgJD29gio716M4A//Nqoddyn3E6?=
 =?us-ascii?Q?ezGCVAA2v49HTicib9IBqMS5xxLPLJhBX8BTKtn0ViPKeAX5BTCLtFfEGd6S?=
 =?us-ascii?Q?35W6nOA1CwWy4WCuLy7YDeIgyB4UKGu3qEbzMVuNjXw7hEVlMfyk9L7sNSJy?=
 =?us-ascii?Q?490Pkv4o9DPGzgRNdPqoOkIzUlBXx7svndsKq1w2WDoNUHfYp8muNMNjE5iD?=
 =?us-ascii?Q?V5PHg6SDUeBS+vw5XPumn/cjz3yNIADtdUSD6aaPyM4bSY/9ulXwGF4g3aWQ?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9OrfgLaeo4e7nQv1QSqz9WYZSb+tvBLr+2GdNhEyopKaScu+82/8k9M/bFCXlGrq9WkIUuKiRlLAk0RYBtc4vXK08jPTABIwVYSAnKMpRcS7atV8XYj1wuY4sLLBFpoDSVMjURcQqHYezK1IDdJ/VD34xqUh/SUVnXs07s+jJNopaSVWSDQrIoM4T8RS5G/9GYBVsmbosSG0ROMNZ2kRMHEsINTcC8fm1QxMAgZwdm72VSzwaDvwVlDybT+wxmIHSmBSq72RHdtc2JMab2kIJShzo5avPNbbhfJD+1VMIgd12vAA8jjU8sPu/OBFY4guwlDnGxmM2O8HUvpF466Lf6Qfw+Et/UP4EmwZlCos75XmeHCwrzXcsv0BrLzQyKJrPyTnbCeIIfoWk9nO46OBpTjI63/zrV+QDgaWgzea8LfhZnUWDHMU9LcjyBbLklvQGbhVqxxJ1tHY/Y4T7pRkrJ9/GmYatOLaK/868VRiiW37PuV8kWXgYRFZB6KpfN2Dn+h9LZuum3EungvZlkuxLlihLzYFty0OPbK3DdfJTEJF9yrx3uxgZXMpGog0O/hqBub5uujFR4JUHDC+I+7t0S3maSaU19O3EPpE0yoZLq8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db3c880-40dd-4012-195b-08de0fe2da91
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:13:33.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HblqPGAzpES/8gt70k9aBo4q+2hrJGbyv/ETRLlQnMzN7VYV16SA8G9THs4iBz7iWC3d42dcjXZ4vmUUVyw9MtWbVzSreBbiyCYU9Cf5ghg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX8nyhQpg6YVWW
 xikZyxVmIUJGKK+HUa5GlhOl+B0F/QvURzab3589+9+diScp6v1HcTNUVpeV0t/rByxWjsM49x+
 Y/EPCVIovhtlWooi732XkIvrlYu9Gt7xn7f/0Y3bu7ETqquWf62bqORiBwOq3lLTo/7u/VE1slA
 iR4129GQPIooYNBg98GujvFveIzPTjema3kr8EE/O7J3rmnRdVSoYhqjplpQIboD7cNjRSr/fjf
 IJjYFSiCh9wuNtJ3GcznfIfT6qanOtRAZMjU1FAzQBYofMTNEdGGUgFCp4mgU0j17SvocSWOe87
 wbVVwzEOQ1cxmTulVqdLwdgiSqaAT1iIKMFJOOxt9ueRliqaT1FrH1xf8yT2La2PEFVEbpAgap5
 sFuaI4mpi9aC6tIvmPV6PUevuElt+g==
X-Proofpoint-GUID: kdkqV7_Qjde75NJU4d95VnZyxM6-vws5
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f64393 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8 a=seDGfn6Nqulq7RY4adYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: kdkqV7_Qjde75NJU4d95VnZyxM6-vws5
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77941140015
X-Stat-Signature: jtgy4foqkxximewehsscebqr8b9r9dew
X-Rspam-User: 
X-HE-Tag: 1760969644-874453
X-HE-Meta: U2FsdGVkX1/qQJX9OvvIb7d32mGOOE9Hmy0qtQBuyeaia9diJtrsTRfxfNTM9u7FdmQm1fMmbMLuk5JevNiqSo9xxCUIDinWbLEakuTDdPwKdnJsBmqPRtuUbW+D3hI6rU50NSZJ7mcMFEdIREi27nOjw0Ul2lDBNvVBPUp54fwlBaPNSqe7PEmqzoQCdEsb5bvsaUneknaDbhZGb/Nu1al//goBDonwnKdqHem7pAoL9mWKiReSiCmTyjZD66vxZW29HL5PH3WReGoM/TcpBBiGm50K9GBU+mtyEVJrqANSHskD/VhVNG0uVg/iSMsW9QMOhdOWYwbk+ZFOKoUzS9Ntpe/k8hOecNSbnI5Q+KUG6MnrgQ4BtsPWPrfcAUsYaFLmJKvqyrouueqsRprZa00ozgo70RWPC7FkOpswIaXI8HfgTybLXxl8XeNrASfrdq+oB/iGMs9vtDMZrroEUaxkXTN0U2Sbu/5wg4OWQaNC4CxUYj2+/ANUq6raOE4SP0VYieLUR+VyNvduhzNDsQ7kwcheB7OmBM9ftsp6vQC7d/dvqa1BFfkNH8kctn9/2U2I7jD0m/fVZvsPPY5H0ea44/wGlBM9SAJ0a4ATa10+9NRrbb8MSoBObWc1mmFB4/l13Dyyh6tTj/gVhTAB4+6jcsuPkOtLRTc2fZavcrjyaQHusNcWow17NYK/W6UjVrepvQBI+VBHaUR5d9NTYCbhdwrr24F/N/lSoL1gIEPMdL5JNezCThgy8gcEGmro6PTyIiLkH0RiO29qjrVchqkLMPqvcjJVknVrAI4SXoJIFVYbV2BAz1fvzX9d0yrXgobSHGn3Q3KHxNjp6hxM+cYXcH3e7/8B6Fy+QJY6rIMBXzmu59ScaQnzuB8YYg4elkMa1EHWdkaN6ApxENQeT8TLpXwabETU+Ms8nGz2CWfy18WcoDZ9fKaSxUHZOOpp40gIqByamTydebfhzqs
 ETXne5VK
 2bkCb5vay8VTl+zsgU/bTkaCOYQhSNtcAUzyhgTpp3zcyeTjL48M378uYLZ5ySEOY3LMsRGpT4jFVUICu0ktsQfRxTNW3/A7Tz+Hz2DTkGT09ogAAvruGmyuvGpBFs22J7iv2mJAd+PAJEqVZhbaVy2PPmDi8hPIxzyMJLfIcekH4ob4zJ4E4yRpIpyIpj1/HkrL04TZlnSd4ZN2/nG2qxPPS7mKaUaVV73yctzBb1DsTSgKkgCmsHTcv6Wo6z+UzICUgEFnJ7EN7G0sFRD48WnOyiX+7dWix0BEe2ioGYjPWzc40Cc9TkbVaPSgQkhOSqTf0PtxpPzxVq82NHQXt+bDdB2nSjOaZaGhR02bznJ1PoYP5BeJgN8JDfAQX+RscWv0N/few17XQipfDxV/Ll+7yx2M1L4FQlumNgse3+UFo1NH5TaxerDAqrAXQVBbJ6gu1J9nJD8kj2BlxyXSwP8BLWcpM/3BC4f5eWU/LcgGb0kRJYBOEABEwhIZE+E/hG9OioEFmUQafX/RRZXDf3bWAmfIweyenq84YO3C+dVPpdVXXOg/1YfCK4zVlENFgEzOKi2pCYSGTWVPUvxTaQ7VjqSO20j+vaMicnHArFl6eO0qiBMc6iJzvVTGwcTKDhagqId8YwFeR3FyNQESFP4EsZolyKEZFjm3jf9i10FLUbANrHm8mOpO1i03DjQNxTCd4KZ4rz6ia6SOKE7Sho1lM0xAjRU4mYc0aZKSqQeQ2CbAdsG7YVLYfMF1pLnM0tPwtoaL/9QCXGCRJgsn5K7POHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:39:05PM +0200, Sumanth Korikkar wrote:
> On Mon, Oct 20, 2025 at 01:11:29PM +0100, Lorenzo Stoakes wrote:
> > Since we can now perform actions after the VMA is established via
> > mmap_prepare, use desc->action_success_hook to set up the hugetlb lock
> > once the VMA is setup.
> >
> > We also make changes throughout hugetlbfs to make this possible.
> >
> > Note that we must hide newly established hugetlb VMAs from the rmap until
> > the operation is entirely complete as we establish a hugetlb lock during
> > VMA setup that can be raced by rmap users.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Hi Lorenzo,
>
> Tested this patch with libhugetlbfs tests. No locking issues anymore.
>
> Tested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
>
> Thank you

Thanks! I managed to repro very consistently locally so was able to also confirm
on my end, nice to get external confirmation also! :)

Cheers, Lorenzo

