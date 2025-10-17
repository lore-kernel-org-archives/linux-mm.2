Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44CDCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 12:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4A68E003C; Fri, 17 Oct 2025 08:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EB48E0006; Fri, 17 Oct 2025 08:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E7B8E003C; Fri, 17 Oct 2025 08:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E33648E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:46:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F8F5117E92
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:46:51 +0000 (UTC)
X-FDA: 84007580622.09.7C12652
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0414420004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:46:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qw9hJogi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xqpcYlCD;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760705208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oI061dAy8vsrxlC0Z0wPC3REZJnjXCHWEy6h0Lna4zs=;
	b=I/MN9oSe6AzJVxD0OeAGpGzFzdSZOuUFjp5CqZKNR/i5/NW1AWwmCeydo9B8hlYEslSKxg
	mix+L7YHDi12Mf226+NGCV4HlpVevnePtuhm8oEcFvdrBbR6XodVRNjLhZRj7yp3aP2P6k
	uhhEbvCoGQRc9Ud0+pzgQOeJfAh9lb0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qw9hJogi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xqpcYlCD;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760705208; a=rsa-sha256;
	cv=pass;
	b=HdU0CJ+/jyi84MTz4Ga1RvXrNuzTU7QkaBw7vOU13W/PcairU3ryB5HnqvRdqfAIp2KYS3
	eZo5MtluR7spG9WRfGrRPPVSwNckTUWw/Z+3q5D0Y5jLijv6UbJ/gqU5eLJlS6R4lDgnW0
	EgCIYwHmo/eFkqVZoQfuo/pzXIa2Pb8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdZYZ019395;
	Fri, 17 Oct 2025 12:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oI061dAy8vsrxlC0Z0
	wPC3REZJnjXCHWEy6h0Lna4zs=; b=qw9hJogiVM1OosFztlA3vcIeDwG6RnStxB
	aljILJD609euUKdCS5YwmXPe8tGrGeCcmJ3FM2Y2Q7Q/h2FIAtNj+Wc/UIQQe0xM
	reR0+3yTic9rmGb4RzGptXD+9cpyH2imJa9RxrRSmsXHxwSVclg8mWUdNx7IDSjc
	W89hQRUPzJOxcxz5RsrF/nfqskCFH0fQVPtVBfZUG9m7Iq2/XT2habbPOaqjkRRI
	uRy+VwJPy3aMub9uqI28QnkSCjn7yWwMj7qnOeHIk1BCq3IbpwmYve4Hn4koge1L
	GkE3y8FEyPlKo/7TPr3SkHrYFAbtzhn4e7cuhuU9dwspwvxuEwuQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59jwaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 12:46:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCag8r000649;
	Fri, 17 Oct 2025 12:46:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpd1ftt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 12:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o6yHbbY6DLxJVTAmOaPL0lSsud6KNTmo/dqjmGuKwwVHDkFpmzhyCcn5qdbcvY/5mB8SLePCCt3OmGq7bO7z0UsfevnBG17ikhZfZub2wJuV/vivDWzkqEo5af5r4ZRiFNuMoKwv3B6jgxqS+ipZeBHgq5qw7xp2bLAzRMX9MeIcGRlO+1D70mIV+BY0wp/GA9ch0LqAV1let/jhUGXYymWCAqwKge62PUXEtLsODIuCUKMuqfxZNS/4HL41NBZF83rod3GFPgJWFm1N5wTAU4h9edD+5YGhuY/diJGKkfgvnDYBzrH0BJnO3lanVklgF/UeAXtlpwMmfmiS94Fgrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oI061dAy8vsrxlC0Z0wPC3REZJnjXCHWEy6h0Lna4zs=;
 b=NVnzlgvhrfGnEXlKYsNtLUQE/+YhIUtjEjilzFTH1lW7RWtzIeADq69PzCIqfRVZt8Qlc31DvPe/pEkzLranU9K3kuPuMqzYD4W6KVHZr4KyTJG4HrWJtr4YgCRmQTHWflh5O0pJJCqxLAMci5iMWgnvYjOLqs3TRV94eP8e08GL/0ow14Aqp6JfvwU/GJhc0idE6TrsiA/CQDSnNYUkE2aLQ7sx7n3ReDRdewe2wYVMKH6eVTq/DD2PZ19VfGxDhRInGrm0JNrHEtd9R59WfRcigiLYooQBnznWs4gLYdnCNQE0aW/pshrfzhqEM8ISidjB9LLhfLAioSGS/igorA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oI061dAy8vsrxlC0Z0wPC3REZJnjXCHWEy6h0Lna4zs=;
 b=xqpcYlCDf5uv4AYt1N2vs6fqyBjljB1J+oO+B3TuxJGy12oHkCV/GvsSeQDM0AdEZDH3DdFtFDTGsOU8/v2Vf2f5y9GiMhfUTVJeDRD7Tu8qCdnp4FH3J6NLmx66Mr3+f2McyjYqeTsIPyb/BUmO7krCbylzkbGhZetll1jkygc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CYYPR10MB7627.namprd10.prod.outlook.com (2603:10b6:930:be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Fri, 17 Oct
 2025 12:46:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 12:46:23 +0000
Date: Fri, 17 Oct 2025 13:46:20 +0100
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
Subject: Re: [PATCH v4 11/14] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-ID: <c64e017a-5219-4382-bba9-d24310ad2c21@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <e5532a0aff1991a1b5435dcb358b7d35abc80f3b.1758135681.git.lorenzo.stoakes@oracle.com>
 <aNKJ6b7kmT_u0A4c@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
 <aPI2SZ5rFgZVT-I8@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPI2SZ5rFgZVT-I8@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-ClientProxiedBy: LO2P265CA0149.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CYYPR10MB7627:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e644385-67e4-40c3-db52-08de0d7b2dab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QPLeEIcJ/w59HVFnCTEmNLMUIwdU5nhIfjMZH7IyCC464BQ2EmzZ8h6HCZwx?=
 =?us-ascii?Q?ZQcPhNWDSvIWr0uuVwnO6YN3XGzmYuAbtSyakg0SfsyMM8erwgTYCqCHUu2g?=
 =?us-ascii?Q?E0wwjZXVRU6KhguU/Bm2hEvYDx7OsLqfOhqeq3igTcG1oLBOVBQY2Shq/1XA?=
 =?us-ascii?Q?6OcZKPWI17ch7uTlRjull11omF/iw3L/dit8gduJY/+fPDIrHWBKhaWJMQSP?=
 =?us-ascii?Q?fS8lUAbf1pM5VtQQf58gZW9DV5YReEGrpy/aH60WlLeTggBCzILJrWeA/k4Y?=
 =?us-ascii?Q?vRh+O7rxb7YMvKa3LfhjdyLFNNfWHHuqXexjDS4lZvRPsPzAiIOebGa5utVz?=
 =?us-ascii?Q?nssfIcpZUbday1FH2MPn22zJk5xDkx7C254i58QP1tzNsAU+c1DNckIiDHBR?=
 =?us-ascii?Q?Mt3oQl6pT1JpSQBZWhcAn1gj4tcFBG7b1ZtFgICII0HMyjDHMUB40YTgI+9Y?=
 =?us-ascii?Q?wczQusQwwUNGg8UdgLy1qAqCCgQVlBQlKmAi/V2VATGgzFSPfeKB5SDg66J7?=
 =?us-ascii?Q?tm/6Yx6MgcMWwqT0gT2Irip05m5rkLX9mkyflGuR7kaT0gbR4rb9lxquGToX?=
 =?us-ascii?Q?GSddsciv2cCf0i9iLfwP2/2wuSwDIV7uXA8+ivK2DLmMIexIkeKh/BiI3bZl?=
 =?us-ascii?Q?UWTvO1GBg8zXR3mUL9OW9/MOIiFX11I72eKqr2Xtk8np8Cl4mGeqV8x/0wpb?=
 =?us-ascii?Q?2UC3+8gvTuXjt1G1Jx6nCptXV4d1BnsWZzEGaYQETRJqfwxJYSy1Ky0M5dbA?=
 =?us-ascii?Q?rExdemD5X39GaNyEoPsga+q8UIZHmDCA+tGdMJEijg/EXQLnLbxjSTHzT4ZJ?=
 =?us-ascii?Q?+svYIh3HJ35mgpTB1yJVI23qEMDy3GxXnuKEWnQuYMofnB9c+q3N9eQFnr/6?=
 =?us-ascii?Q?3le56jFz9vHACRMyOMfRUE7sSt3ede0JxaGDYSqYGCA3YxdouTbYmybVzSGQ?=
 =?us-ascii?Q?aOHaN/LsyJx5BzXu8LVhWxPJMxWEiOP4c8zsvUbCMX0L76neXyy0VWDDWEYN?=
 =?us-ascii?Q?S0IaTZwvREmzfLP1YOMDCvgGlAIV50fM+csbz7uTmpwGGprb8X//2DwQU5Yf?=
 =?us-ascii?Q?kha6rxm6wtjfQpYQhccjT4RDMQhrlyzeGk3M1DoiUe5/DKMLn83Rv+PY2j65?=
 =?us-ascii?Q?2z0Ek62D1/RqOISu+jsofJfzXbnZr01fOhDbjjS6Fp1c27WTTZh9sBhFibf7?=
 =?us-ascii?Q?Sx13g62oEbaa+Xzb2SGxN82SAYhZiJlN26BQa2dpcHxpeIK/dqTSPDDNsYSj?=
 =?us-ascii?Q?1jCWeb91N9N+8d6JD3MB5gaIuNq4LCYw6/XXXpLg0nASqow+unX4hwoZGrn+?=
 =?us-ascii?Q?E7TtSfNJj/hiGpxJlxKEs74MR5slhPy5+UWc2OEuWEBPQ7FTs8GsXGyOgpWd?=
 =?us-ascii?Q?aiGOcdtcbM6bUSFhpS9HPdE7uk6KkPLcFDhUUcRmZObUR7BOiAUzL6WPm9G9?=
 =?us-ascii?Q?YIyWlog8HPnpjn3ZFFp0qKAKzzmTK0VQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H/w3MGCmG8RFh9h2aXw4RCdESHRsDE8VGfOXPQjXlTC12qyM1V/hxm19kzNJ?=
 =?us-ascii?Q?GxMTBeYtKgYLWntC2C217SIhs4gZYXRbyyU3uDt8FxMbXT+vTalloCnEdY3B?=
 =?us-ascii?Q?nQ+sENoUSn/FCHRQWszFO9m8NwUjxiVC+lKo5+Rftw6i1FqMBjsrcAx3eoKe?=
 =?us-ascii?Q?+qJCZISuVbKMsBahtAM+zbPwZOonGAiLgwgDNMiZgHi47FjNm0dC0+MSumEY?=
 =?us-ascii?Q?uPBLyv1tSqEjkpyOVxGhPUVRSsxGLirpOg2bUA9ooGmGyiC8p1D1q0TDadAi?=
 =?us-ascii?Q?fvfBS3yjjVxU2NAV78eye4cMtp/LlLnVnL4x5LzqTytBMwPVLRQuThb5La8S?=
 =?us-ascii?Q?BZzpyL5nCPElpa4FQ0GPblMcFT4zcmeTV1wB/Chxe5T680xbPo2O3cp4GZ6n?=
 =?us-ascii?Q?Mvq3F1yjNNAuz3GuxeYFQPURbEfKCGw6JaCv1H2wRlmSHREPKgtcFQ0apx16?=
 =?us-ascii?Q?5LwVIhcWr8IfPut0ozAQ+VqLVPuCp1ZmvAMTbU4R+kccBuE4wuBqEEDIpAP8?=
 =?us-ascii?Q?U4ADcRbYoDZdWDywSKZ+S6OcfRLPQK4H0OrvrxpfWQXWh0DDb3kIUs05RtgI?=
 =?us-ascii?Q?H+3IIIPqcRnIt2EGNqF0TIlWsfxf0EygecyZuYr8DVZn01b3g28p4Y0K3LAl?=
 =?us-ascii?Q?BROYvFsh4/phke9jv0b5tuwpZFMEFAlGDwD2W5kGGZ8XIQri9s2BG5ysOBO4?=
 =?us-ascii?Q?8TuX/wnonYcBF5cHnuwDJszMF7U00VMjGF9SWL04hWyBTOxNA22PhdqAvTGO?=
 =?us-ascii?Q?bkMlp9s+Hgugs5xYuEHx3gR83K62Y1hPC8g4spGWFSzmNwd2EYQMkcEz8J3e?=
 =?us-ascii?Q?mBs4Z5oIiXJr3jbHCBBPSwpDvta4WGQuS0rn3PVfdQiGePse2pGvdr1jQMoV?=
 =?us-ascii?Q?LPjMe5LmECVJ8YnSiljzVhX4Hk0QaYbznI7iSD7lkT+FpEjM6MJa11MbNBuR?=
 =?us-ascii?Q?VJSYfqT5M3hEae8K8X1loQREmOWrksd9WYdbW1HzMpVGF5leUsKnd0CuS7EM?=
 =?us-ascii?Q?JSwz/PPDGLGxhSjJBexCOsYPx+vF1Z+kGgJ/MowCdPf3ppFPS8PFpvmZjETv?=
 =?us-ascii?Q?4aUqyV+JcMFZn3+zPpnsS1DUriDvazcLPgJBoDEzLYil/hfCdHUbZDP5GCZ7?=
 =?us-ascii?Q?vJHstp8h7iyoE34S5eVJ7hbNM9yXozVM37Gs4Fu8wl5O2X/PpPX6wKfQvIPs?=
 =?us-ascii?Q?IWlOHiLh+V4JRc3SGG+ZZ+EA/61TDIvKi79I3lWGJLJjq8OkEgZeJXqVLD/i?=
 =?us-ascii?Q?K0NA+l7Y8qDNIMFaC6SUy4Bo1kQ3r52fTJ07YjCk6OIjCErBbG7FJWxvcVU/?=
 =?us-ascii?Q?TdCWP5sHm4B5Pm2XALHSB3Yj6nlI3ChiMsgPZn+4lgB+x6G6p7ox7/mwEU2g?=
 =?us-ascii?Q?LsCqpSkS6HR5C0NFxDbiZuLbgTFz8+bOgD8jqUFr6V1c7/OtWm7X7LOLvbZG?=
 =?us-ascii?Q?xeyZ6y7j76d11fuGOnP23pmGKtURg4PmLzGWDiYILZkpLiRhlguq8XbZu5BK?=
 =?us-ascii?Q?Eq6XgSULp5CZd3R6yGG+/Fq5xJtva6VeLI2DawW8KTQWr+dQpn7gI7hqblb+?=
 =?us-ascii?Q?WAXOgRUzRIxyAxycHXX66KNdu3GBZ6zR1JoYGRzJmj0J8zXqRWCnFtQOfJ5r?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NCUDsCptfdl6NVzE+XRmAcfVB0TCO0kpXJIYms8adXUf22J0h7WZM4IIQd7nCVa1F70dSW1XQFFS4AAYF54RDH2F3aMWjcjcbahwaWKuOFaVO8N7AOo1W42VJaLM2K91sbRYV3Fl2Dke+PSfHAprFZF6wV98Mzuzz4mfzWBzFEPf5q1elBX9i4rYazjn1LsdPZYYPIdtpaA8/CxEK4qd9tgoNwxROINZji6a6T1obs7ArnN3seeZFVn65KgjLsWr/UGmKhr3M+R0smOhWExz+U24dH+tTsyew5TQ1vV50pCgs6MozIUgk+BcbH2jEACMHOX9ndzsi6ss27MIP44Mgw5LuIAtO1o0WlOo6f515vUCKwai+nz6QDrQT8RsiVmy5ZM1ebqHY3hYrXuTmOKIdP8124X0FpBYoXA8ASV/uoEuLithP7pJw5x8aujv2gOcrRUs7zETEwsOdhqBNvHJmiHUSHjJBwQPjxfYxpp3Gk+MczXRLdHqBCcrnUA/YjIBEr2DYazVyWKousL4/raMwtgmxhibM3sZoZwoprBgx2j/7ZjdfqhYUOktLnSqjqgWkt523qYg5SMtL8feCFCd+qG+y5F4cOZmlJNfc3SPG9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e644385-67e4-40c3-db52-08de0d7b2dab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 12:46:23.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyLZpbdgkkaBS3MV9WFDbMuMpa0JedZDiK/jFohQfYTWt+VxXKJUsZBh2gIbhpo1iV3p4pNO+fQcbUE206exI9rSpTuPe9vvF3+pqNs1fXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX3CdVs5SExetr
 yYo6EN3KDVrGoeTEdYk5fuIcEIIn0CT6zD1IeIJhsnYZGyqOnxxbkOqcpu40PCqlO2a1oYhrpmp
 x+n53pSct9KOct8ZXC2VMx4n4NZUKpkQdrZSBAcTkXPN7nH9H4lXTt15raRoMUF1eNpCY692sr4
 JMMc34YULLv0Zh1J+HBTbZfh8qB1EbDkN7JtDOObIHRFaS3DuQZKtjRZ/ff0bgaRN4ZbtkzNdfM
 ZTnY3s4sxeeL8UsBO04vvO0aTNFT7qT/51swibZ//2a2O1pAtLzIPeoDWPvoHnKZ5NNav+Sem7s
 YEyc2mfgbHWRTULBj4vAvk21A0iVSAymDW8TQfyFIrKrBZ0fRc940Gw5b1MbCXb3YurPx4vsK13
 9GzrxUE6CRJORmob6d8Kijfw9C+W3A==
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68f23aa3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=eWYn1dIeHkTF74O058IA:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: 0ATmMJrwdHoEuzfB9kMIKut0xlYxjzQs
X-Proofpoint-GUID: 0ATmMJrwdHoEuzfB9kMIKut0xlYxjzQs
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0414420004
X-Stat-Signature: szjkoe9bk9t6xzipnjpwzai3ic7kkfup
X-Rspam-User: 
X-HE-Tag: 1760705207-839798
X-HE-Meta: U2FsdGVkX18z1dBFLtFZruyz8abLXYqkSIjOqHBK3PWTMYs8hJI7BGm69e4yzWOVvW+eLok6mZGdByiqjNFXHAPrMSJSVhUwfh/P6oVHU2W5b3RusaMhgyBo1WU+4q7asTy98RrvlQ4OFO6Lnh3wF1f+lPMPOENJ/lIGMPz0P2se6EPmGBFPWB4Zr3ICTelbMHs9ceNDp9x+9SK5sbtCz+PTBfNCFk9Afyn95poWYqB68HCRuGlSk+2tPZXXU6PJ33mHMcw8h/hL+m9HlZCCrn0JUYVevZ4VHdSBEtyTNRrXsEbGuzDJ+0dCCwV95EX5T2yUT26waTWHHJSdbh6DHrROW4B+hHx7Kg2JfC4vbSjqJDp9aeA4ZTVDUSUOv+ShRdlQwRbDqI4m5TH86JT9xdV6G/nIA6LkAiwlBW08cwxaZH/l78pohi/M/KNMMrmR34r+PlMcH7eO9aO+Z8lCwea9jMZRKUB2HGOyzU7cuVFMXamC5+75WzhmXhDF9h1Bxz8N8xRHLorliB/oV6DRAuHkTxmrDADh4Ab0KERwaBTzFkeY3g/6iWPxBiPKSmuCG+etDycJUNuZMfAVC6vw7z4vdGV1Xp/d/KS3NWiL72JoR5+7bAxO4W48U4cfVfkB6mK7c4bCurc+Bik+CPAjCZzXzWYy5If9L4BQgVD3LA3v7o1m1uX8QZAS5VCHJhxWR9rE7S1nyHrreSazDLMVqUZLvpgSRdUEWIMDy612t4azx72dNLu5Pjb/UbIwO1JX0i0yl0PbNFw80nw/fwv6BKXTQwi+tuVWZNUZdrXbIzCELx54AHIZ6W9+fRS4hnxTtAl0vCA93s01GxKoVdRIvz0+Oa0y8KOkKMLyqKDjW4esvkLR+dMOHwUwHwLG5Xe7W/oAmila4tomNlGftbKXW/x8UvnwZC88QWiaGx2fG5Ko/EMk8G74ska8oAr4zFexSU4AwZtjihVoKJVGAS1
 S7EAr2x3
 8ongCpZwqoq6Phk0Q3nAMn6uZmmcSCcAzHsEO3o49A60iYm/jakrfKi8K7aYOcJULmnVWNFSACftGMvOn8P1VQ271DuaLG3OlBiAd8hf/rFJ/VuW+ItsMy3OucEpdRyrtM6V4i2TKo9XbKZQTfUOy0DVUF0j6C4P6n50bAkDFUF62Lnf1o4VV1jIAgzW2EAN003b7kYpzUtGyJyiT/hpByo11jqNev4HzlNFUe162F1ktGai4TJI4G3SZMnCcFXfDBFqYAx51tMqoi0Riik9rOVY1B6/4kWYlVqkWPdmGK4BRdbhy8R0zZTbL42eYyonYfxdbsTzONO5fo0tlIQ/9tnTREm9s/FzzBkEHBoQXHTQc/UqV6a/hdlaWG6J9519gn1xQ3cE9Iku4H9I9PiS4CCzx6w3LoBkyfBpMeZEOq+Pj6i4sUOpNqryzRZ09B/nfeVdU0J5vfLxKgxFjVHQ5iZmly15IZFFwC2mA0EzKN4D26tpFU685GisE6ZIcrsOXQyAMhaEelj9A7SYCJ8xircTjVqHeHZHgLs5/D6+gb8eGfenEcij7UOiGam5+4G60ieZogDRINYhejJJpX5UN800Jpqz4SUmKqnT8KcYq0QhxnMdZUKnTMOO4+Tn4dv8SY3C93OK8iL5+JOUmLyDgPFHyB8XA8ypUFsI3kWgpOn4fMx7tvht+aS9+pIg3W5qXAoMz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 02:27:53PM +0200, Sumanth Korikkar wrote:
> On Tue, Sep 23, 2025 at 02:17:04PM -0700, Andrew Morton wrote:
> > On Tue, 23 Sep 2025 13:52:09 +0200 Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:
> >
> > > > --- a/fs/hugetlbfs/inode.c
> > > > +++ b/fs/hugetlbfs/inode.c
> > > > @@ -96,8 +96,15 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
> > > >  #define PGOFF_LOFFT_MAX \
> > > >  	(((1UL << (PAGE_SHIFT + 1)) - 1) <<  (BITS_PER_LONG - (PAGE_SHIFT + 1)))
> > > >
> > > > -static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> > > > +static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> > > >  {
> > > > +	/* Unfortunate we have to reassign vma->vm_private_data. */
> > > > +	return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> > > > +}
> > >
> > > Hi Lorenzo,
> > >
> > > The following tests causes the kernel to enter a blocked state,
> > > suggesting an issue related to locking order. I was able to reproduce
> > > this behavior in certain test runs.
> >
> > Thanks.  I pulled this series out of mm.git's mm-stable branch, put it
> > back into mm-unstable.
>
> Hi all,
>
> The issue is reproducible again in linux-next with the following commit:
> 5fdb155933fa ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare")

Andrew - I see this series in mm-unstable, not sure what it's doing there
as I need to rework this (when I get a chance, back from a 2 week vacation
and this week has been - difficult :)

Can we please drop this until I have a chance to respin?

Thanks, Lorenzo

