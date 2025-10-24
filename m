Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E79CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 18:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B368E00EB; Fri, 24 Oct 2025 14:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4778E00C9; Fri, 24 Oct 2025 14:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07758E00EB; Fri, 24 Oct 2025 14:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3B888E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:19:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56DE049514
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:19:37 +0000 (UTC)
X-FDA: 84033820794.13.9740F4B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id D86E912000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:19:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IVpGUuUw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lTLPmEs9;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761329974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SaCFlKPSBLB3w6/FQ5/wHAJTgH7H/5yyjwDi7rbwKJo=;
	b=WH+4L88vaHIQ2YMl/KFKfSSdtc9kQmRLIKwq3x/mZhXMHKvaFCubOlQimAyfdmF4Vxg06/
	D+ojVv6V4RkJekWSt/OpPfx4PlGRTfCJGvT+QEO4RUFnhDt6dcN/t5OZ2YYyEAUgE7uqzU
	PsoEjKuLkN7a5YZFcJdAMu7k+RpT0b4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IVpGUuUw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lTLPmEs9;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761329974; a=rsa-sha256;
	cv=pass;
	b=7Vgg/kztcfijXvaiKuwJ8IIeLRYB+q8JSBmkxndFyhO2gp+p1JgZyIITIBDA+R3BLqE5SU
	9VGHwrSZ5dqIYMS4XPH0gh3P5KznrXugLtLS5bbskX6lp+XpD5Ppi24d1juSoiLVkIt/NZ
	++Gd7HothcblVLy3ZpFAUYUFJLlKtNk=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OGumrj019824;
	Fri, 24 Oct 2025 18:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SaCFlKPSBLB3w6/FQ5
	/wHAJTgH7H/5yyjwDi7rbwKJo=; b=IVpGUuUw1lNbcmKRaitB3MCSOHthwJX8jJ
	d66L7lq1rxbSV5n4sazP4k8F7P079Ashiz5yuMOiFiN7/7KcFF8ULnaLkdkit4ET
	4hdsWPNRowUwVVVPEGKqXJ7HKOBM2Vz0InS/hqPT44XNqI7fL3Uwn/j7ELSZ4Sdy
	uUrpTo2Pi1FX+zAGEtPnWw1tOzUQG5DjsfBOwAuFbsWT6YgOHUCleWyry6G9Qic2
	PtwGgVOCXF8y8Clq0fyBqAuy8/9FGLYVv3pUwvJAFGtIHpqEnOODM6vdqPzOEs5e
	VuVYH/B591eQ14rSVHyOf6OQwmPF9SO30laUlEEQrbcm39jUpOnA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcydd5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 18:19:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OHmswY007766;
	Fri, 24 Oct 2025 18:19:17 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgg8dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 18:19:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rzd71Vlij4tQcdPm2KMsXNUOINkvXqzH5Rmi35C+/h2d+BdIFuFo4J4DSgu58wlVWQSw6qXEMhX9MRu2q8NMMEKANRGm83+qxgqKekaZni1/RbG6ThHWf+8zi5Imq7jdzb9egOJ8Btqt9TjpeOuBKOYZs/NMuQh1u76plX88rKzPT5vMxmd4Rrvwp864DXwmJhdOsrO0wToIIKbpd27bPQmbn8q7VWIZjKAUteY5VBZMPrfTM7TRsKGOGYSfNVOBLRiImtOF3jtKd5MFWG/VX37k8hjNcisxW0y5Om1FNF6ATKVkrWhnmtkIn392HT23Eju6kLZKFHVIJHdQF9HY8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaCFlKPSBLB3w6/FQ5/wHAJTgH7H/5yyjwDi7rbwKJo=;
 b=vrCYdZVFYyIeaF6qT0DHthISmE8Nx9PM60A1pxsemlc/8SMHYxE1RHAN4CBNk86PwrbW/RN5q293olK7yj4d6P5Zp6Y8ixAUlWOm7ZevJwbr6aVnq9AmDHAcBq/NWhIWo3YhMXvm/9YcEJ4JMGkne/hnAf50TfljmpiL9N94mYaMN9nenhB1T7mJnhpfQxwDkIhv47TR3WquzydEjWmXPRIvMG0zAi8GOQQUpp3Mf9GtL4bpNID8wBxN8kwMkYa++iHg6rKeb3ztFqYXq64yO75cHdXx+Uu6QIk39FWNbBft5Y9cr99rgKBFBXP9PSt9blcVmMSodfjuwQDUrzyIJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaCFlKPSBLB3w6/FQ5/wHAJTgH7H/5yyjwDi7rbwKJo=;
 b=lTLPmEs92FpsVYRn1iJ8zWbIUJ5teK0Xb3N/U44g7zYddVDd5GR8D+4FcICrMJazEYOBbxG7XeG8msiYi6G1XI281g6VVayG9NzYCiriTFZU7UmEhIUG1ItO/zuYrxts/lg7zcfw6+Vbq2HoFs4Lm+I4th6taIrglMn+WWlATN0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7026.namprd10.prod.outlook.com (2603:10b6:510:289::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 18:19:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 18:19:14 +0000
Date: Fri, 24 Oct 2025 19:19:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: LO4P123CA0660.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: 926eeb1d-0aab-4bfd-9b7c-08de1329d60b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U7fv3pKH4avkAv+DES2LmA9Ww/vZaHtkWg/sEXcyWyXeRooGpL0mVngLi2PX?=
 =?us-ascii?Q?Rcd8fJm4XD9Dvs2hAw6damjk0ZULa39+sl7e0QmGUidY7UPWhbz/ebmV/pmk?=
 =?us-ascii?Q?xSc9zGKu8wnbIdBvELN2X+q9yuPvi49I4J6bGX7rKaFK8yhHdMAUHhHkT/Og?=
 =?us-ascii?Q?5rYHVnzYNngfg2GRBFXLlaODZst8zyFJywLmvchlnxV2RcuUF2rr6KSNP577?=
 =?us-ascii?Q?jhmZg+708OZho2htAF5XvMwC2fFMfsH9rKRFdYYCGUXZ1i+/2OaTUpRcXd/J?=
 =?us-ascii?Q?Fk3pQYOoZPGjiuF9INvEoKj4b7lHYyTWOiInjhWDGcrTplQQnxuSzMpWFCDG?=
 =?us-ascii?Q?DZWX/21PKfXQiM7P2l+wTHwVCxRVjdEuAOIl3Zu/Ly4EMnYm/i5REZu78kpv?=
 =?us-ascii?Q?6wnH3hgr6xwiU7KKEspu+/HBTwgYOL4n94cT7G8k7XiIk4lIB5oHcWLftJ5a?=
 =?us-ascii?Q?uD0Sjlhv/AP36B1PUyld7u9YbKNPqNbedeG9a4nxjgqGq2Un9TyEn2kgU3d6?=
 =?us-ascii?Q?H0HTzXKo+ctR3Wt9VigQwAYPqHINrxz3EyM1niVGfwOcnpfzLcB+T7e80Vz1?=
 =?us-ascii?Q?yuOfALsM32UJkAduZeuJJlBLxRlRgpA9Za733l8wmrrxLcGrxO5Je/vtpAQA?=
 =?us-ascii?Q?wReD77fdD47P4Wu5CjimLjVMIsayWGXXjLvlVrokmzCXh1nqilKildwQxh6Z?=
 =?us-ascii?Q?dlFVdj3OiYMlKetaiLRwpy7lT4oPmbKtwLXqGAfjRnr5nQ4+TNlHvXsgQUzO?=
 =?us-ascii?Q?W/qOdHT35aCmMJbWEbOZfKChmTP5a5f2S/qwNUIrRRdk+QAku6Dpt1ng8B0r?=
 =?us-ascii?Q?brCeF+8WYTJ0ANk3TZ1z/FKGxrx4PjxKb8An5KJ53XgTZcqqwe9U2LyJDf+L?=
 =?us-ascii?Q?Mp5fMWwuKqmc9MCp5faPtta3RpApr1tEfbkwpHwLVlyYhT3e3XDsaKcVe5UJ?=
 =?us-ascii?Q?MxM/Hzybf6DRzoIQfskwyCUcwCz/E6R5zLg9Kgk1+wx131JSTUTHxe0o+5ro?=
 =?us-ascii?Q?C+ZvQcdYzfmJmea3kOLqbMCThhc9fNKhoF//STb1/eF72prFaEnd5ZC/FyuD?=
 =?us-ascii?Q?AHmNOAnvsyAbo8VOxkXEA1rrMWvSDI61FkLpI2Dpng6ZxMH8Y0kI8WYXHhnA?=
 =?us-ascii?Q?0bJk7M9m+PDkARCMNTtalPBhtrgralnmqPphjU8uOJFJGgrcfvX8n9eaGr6S?=
 =?us-ascii?Q?DpvxwN9Zesok5XXARSvR+SdujlxbC33lCF1DC9LFLecy3BGwzgFRZnOswJtJ?=
 =?us-ascii?Q?KpesF2DXus+OAcSmMp+ZrEAVJLEf6fb8aqb6dIsId7PXGQ3Mb6CIk80febdY?=
 =?us-ascii?Q?Daoj9jAa/mWA8aH4mMEX62KLKbivWTwJhbpsOvuG4daQY9leqfTAoYE2HoLK?=
 =?us-ascii?Q?gsswega1vh/+j1VtTEoi6CMq2V1x3bP+kM41JSv2O3m6kfghHvIrz1Dlwgsr?=
 =?us-ascii?Q?9zSPEXc13/eOxT2fpbatXyD7dLT5lE3L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fXwEinoTW/0XcLmACuK/uHhXpC/jsgptIei23xWopEtvRSnfTSVJNlBc9v+q?=
 =?us-ascii?Q?usfMAKjUiUTSxPQNUMhkcM9i2D/mKNdc8HWFeezQMf4YGEc0KmA7jJk/oWVQ?=
 =?us-ascii?Q?v1jMCoXE8doPEvqYaPHtFOQAZ8k3VCgx+QahiXlh1yQRTC4mdaawVYehC6Gh?=
 =?us-ascii?Q?GKTtYb2aO4K666ckEOmlbBQ9jVVBHtaswjlRbzDlVKrzEVcMTqqo2bYzy0MM?=
 =?us-ascii?Q?sYOvSY2iEow4pbBlLHRGouw0BASg8gM5WAb7wQruPupXfrqQymgNKIfdgcUE?=
 =?us-ascii?Q?PtU6R94PuR82nl8mPnSFqMAqfpdv2U3G4OYKQNN9/8/AYIdtsLChYJSptuQE?=
 =?us-ascii?Q?RL/2RntIPJzloypxmhq2PLbEe8P94yGz+vA7Ww7285Iprq8WQ5Pb/oRNc2d3?=
 =?us-ascii?Q?qQ5g9A0uoWqZNlTYuWasdyQXztraGyF6OptZZt5tQrFRdj6IyTBWCrIGDp7m?=
 =?us-ascii?Q?nzboA48DMfRH1bYuRlE5M/fdyu+hqzrrTs8ehr7Li+IW3EB5/LNenv0B73sr?=
 =?us-ascii?Q?7srpSiUS/Kyp/FfhuBR7buSmcN57W+8m7glbUqIsPlR65W38U6CYqEUamUYI?=
 =?us-ascii?Q?wpKHDNTlHA3K2OIVsT3zGsBAITkz2+4fPoZKja6ry6KxpSAGZpFt/Z9cPHC3?=
 =?us-ascii?Q?LeEOZy/9CPUkalfdpGSRvIkQr1SpODiGlHqE77aueVqx3bJHWt4kXeHhh3gv?=
 =?us-ascii?Q?0XEVApzVkCiaQGX9dJ/XNWWAlZ4Iv3IpFQ1TwGkRa5kvOr6rRAGsNwOxWVK7?=
 =?us-ascii?Q?qlzaCIgn1+rGVdVV/17YoOuVHd2D3/2rnSNyubkNVBFfiSbR38ptKMxp5f7b?=
 =?us-ascii?Q?8TPi+Iz/i7BPaUVJXTGOHsbBEOgwZ4tDRIK2Y6J1Pu6p53r4RRy1tE7vk1Vm?=
 =?us-ascii?Q?w+XlgjFLu4emVz8Sxpe15TLOkUlrWwf1Dm+EnD70N7T09NcfTF1v9zDPzZE8?=
 =?us-ascii?Q?2nfMcR39e7nA23EHmL1FTNsgkGdalJ0T93UvNSlUCljmYd6MvGSKyZLv1zz/?=
 =?us-ascii?Q?wVQ5FMiK6Av7t9SS4htM5aX6ufx6GJAc+xHllCoqA1WwgsCRioLK9lUQzlib?=
 =?us-ascii?Q?YXZOjHnnJKQHfq0R27C6c6hxyy8FnXaxEcGjI7HVY/31+oBueP/WSjb16WH2?=
 =?us-ascii?Q?N/isEUYXJXli6s8T3l4lNVaKGcOsRV0NxSNBQ2wuVjp1Y/uJzL5Qx4p8sqLY?=
 =?us-ascii?Q?W0xc+3sKeBRskZQ8fwEdHLBbY/XmIAI3SeWb22Lgmc+/KXr5+q3GIBW1wqza?=
 =?us-ascii?Q?96d1kEnDVdIgOKkua9Syk3z3svmdAvDNx4DN4PsjbXwgVRgKy6h6M0smMKSN?=
 =?us-ascii?Q?j5u7OK5ua5SzMT8SqyHXU7W001urg8BHM+4TTsFPAEQhqbD07NI3uMeofYGX?=
 =?us-ascii?Q?8C/kqS9q4cKhlUcZWKwt+P6o+yR9J4k6sw6qyv5Rxsw5a0BanTSTiQRvnDj7?=
 =?us-ascii?Q?4mbTMKyhiCuvB+NZW7PEKI9GaDNWP7xbK+CraTn1Is/AC/nZSPlqb1vkk1Wl?=
 =?us-ascii?Q?9qtcjV8NpMM3tw3DNT67S1R2eBfOk3FVCKsILdc+JtWKC4cP4XtPMaLEVHLW?=
 =?us-ascii?Q?hov+Isgdg/DeWdT3fnf2fr8wT2D5jfAxhyoTgqIPdj8IVZyogPkSbTPlZ9W6?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2irQlPN0PPYGv84u3zSfiwz6iV7Q6or1bqZWGF/Dvj8ueSiYAImEaGitXEI6x96Re5BEVc6nX+dM1Xzsjj7ca9cMA+Ye2Orj0HrxB3pVS9lpEhamsFuyoGAG86MJASqT3OwPt8xB3P1f7Dp/23XGLiuFV7SOvd57/2MH+6BKnPRSesYJR9jtKUW1r1zpvBpPfF8rRypahrXHfay/HuLQF6SjF8nI/gsciezJtqU+5WRuL1NFYjfbmRovBrbqlhUD79cEfRcG68TAqLW4KLFi9UpLWBnkn8memI3eO1tLCstPQl22Dfk7SnJdHeJIFcDk6yq9Hjx0/vq3WRr8Mt03KCYpxRLzfhkqlSv+UCuf5mjGiiTE852wASJK/hympzJTPRlYEkpNOtEBiqubR9VAIkgAlBBXm9u8wzj96yfq+PagadYSSf7nztFoG3ncLQDjIkCJvvt0Y3K1d6ineeoFZ2BCNjGJlVpzXlidv/Ox4YokGiTllasIwaZvShBqdpuNDHgE0Kk7fyBzG9PVFcFLrOFzZNm30S2RjogQseA14TeJDIhCCzBQhBAxOj/w9yekzlD1vLIh264zwa7SG3Ili47npbLi+nkaTviWT01NaLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926eeb1d-0aab-4bfd-9b7c-08de1329d60b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 18:19:13.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRW56hwHFFp8P6vTQIO9PtQRffXm7lhc9KcsxoUmJDgH9u9D5a6ziLFNANawCZCec8M+ycw0W71wZjwlTSebQWV9PSdTQIC7WODokEqlmuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7026
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240166
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68fbc326 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=3kpFq599d_1Ake4Ty3gA:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX46g0Y62YI0XZ
 bG4NAealrUt0fV6LJBjVg3/udyC3kQbJ9ZbJkZFN088SdfaTiqW2EBeo1Xv+nL9Go3ABTv43XOU
 gME/qlXQKS6KnQHZEYALj0DFl/UBCm1/SEBsq/+AhrQc2j+p3GY7KrfL+zNh9j7Zi1zSXVHJd13
 PwuFuI4KwDnw5eWjNT7XZi3Vy6DRXL0upbhoPwOFli/KS1iR5Slda8rFeEsxDvbUbcBqHnPL/a/
 WLCO5eQfSEQJyJ6NE97mmiiztZFV1+RT+vfIujjPmY9xv63RV1VbECuviAUl1MWwQowcgBxecMW
 NWxT94vv5AJ4iBIFLHSRgVh0aLZRZdOrewZ6Ju0wtBvZ8N9zkMOB0CS4NaGN7lUStAAKerHzc2d
 p5sFFZEsXl3hzZVe92e1wlhaFLNmGg==
X-Proofpoint-GUID: zA3-onAkovmB2HfIzpZoCc7DMXGY3MEM
X-Proofpoint-ORIG-GUID: zA3-onAkovmB2HfIzpZoCc7DMXGY3MEM
X-Rspamd-Queue-Id: D86E912000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rraum4yqrsjq7k3x957qmgwm7n36igiy
X-HE-Tag: 1761329973-478341
X-HE-Meta: U2FsdGVkX19rri7CDDrvmtyCfX7ttmz5wAt/pRunRbaGi60tWNbBV6qxRyF+d3wrklEvURQjpvGgpacvnvL/pbVO1Lfyw1bzfTeUUyx6uPWRxNPy26/qiJsbNjAZk0fGqR59uxuMdT7OAFKpx+g2U7Kdyx2avxp9dKLK0fi6FBrRmlpENGoebl3ww9g2u38OCR48qQ8M3HlcuIjpSJg8QB+C/gFpyLh6pzakFGDSH4JjNo9d9GHamXNXPRCcg5IZm+iBXcJb92q6wIemYKDp/E+YrCvb15x2rfxc3IWCtOkk3UHszb1pXt9Uekk3e8jH9yBQvLnwfBRW4pVMP1VNhGkWj4qYOTY6b5psLTJZz93PVHg/KJbN29j+GB4tN7LmtJt0FJMDEYoSzX9X6Ntl4+AwFAW1iEmtt7jnC752ccjSiJM1m40J8iqxtONToiEja3YlKgNmE+Raq9SO7iZdJ367EoItgYsAh9Sqb7+9LIZvZAR5z77y7CXOjRzIsA5FQeGbUzImzpqV59Et3qSsM0n00FDYqE8vc+KVf/cAWK3zsoIiuFH+AtNSAPIvOfMXIweYCn6nht+pbyU+hNm75crVEInpwj+uFF6JhZwFMAhJKpMi1uickGZqUeGa/n4mxCiiGt1J96bO6uFfSamBzy2YZ2EgA2ue+kzqpanvJS+tbvmH1/MSbK4KKejHA55dqUCrmTxTZZAXZ3dfob8RKnjoyktu8aH4GyLRw9lv8YmTe29BgF6iLaw39GDJym2IkJM2uaIupNrd0mzrhoQlrUBREIlXBbK0fMtx6AsJLhZwN0ESQPE+EwpCiOfUhriN8uHM5efVw1rtgGCHaeSpHCpaLRGgqGdmhdyTQvi5wMuFDSxOQsxmpSS4k7orQUQ/2+hcsqyQYPbUt379camHx4hIzoEb3BzEUcsp6yBOG6FcVSe9zDXbyzvuYRVTK/mZ9i7Yde1hyJnSDk4qxNN
 8GayhDSp
 hEI6QQ00tgWaHgiS0QcMmGFlDHJboOvCW7ztgVOGXBembZUvfQjgANjVljD/TpehbLiGCnlYeszf/d0UhabZ+jkAxY7KSzk1Vt942GA1GkUcu/2M2MeE/BX3risZ87Tc9uK4e4CmB7j9qUnvVx47gu68Z5+jMnAfOkXjzu+/hQH08P5aMK94iIDzk0XUzNtlFD797CVb7P8693Rm9cNhX410Qh8Pd2gDbb534MNEMRtctq1RYSUVMJyZ3V8Zkt+AfbKmJpFrSA1vTEoskr3OlKaq5ZLmRY7L1nEMX0KVDuMrIx+JmO+BbJbpK9DYg1O0FmMsmC8oP/7fsCcUi6bb9DADwlK0A/m5BXJ/MjFy0gjUcpzKhWnN9MWCs7/uCCBYEFSbblWbMQUuSf2Jo406ZKxdGyiD0iilUyDxT/QpgZ89WllvvtVHqr/7T5xLnVRv7reXEmmrAM8Pp/BYRDxyIFORiApvPo86Mu8rBHhVzPUVKGetn+1takw/jMXW56LB/jUK4hQcVtQHAkbwZ/DxBEJwjK5eiizSPyH7dBQxMW3WkvJiIYwC/KBmQHPxjqKt/rdmfhsR5+ljc1nXK+P0FR5fzyiNUk5HUCzE4mFxAGuAwXvUwvooVbOcnkhG+a3/wMocMm417d/cKbk3vdrc9IKFNqENtrdUVUvKVQSpD6bacFyt/+Wx4sGH0ybSyApVHa48vECnkVRZiSAyIX0n3F4ddRqNssWn0pgFS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 01:32:29PM -0400, Gregory Price wrote:
> On Fri, Oct 24, 2025 at 08:41:21AM +0100, Lorenzo Stoakes wrote:
> > Separate out THP logic so we can drop an indentation level and reduce the
> > amount of noise in this function.
> >
> > We add pagemap_pmd_range_thp() for this purpose.
> >
> > While we're here, convert the VM_BUG_ON() to a VM_WARN_ON_ONCE() at the
> > same time.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ... >8
> > +static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
> > +			     struct mm_walk *walk)
> > +{
> > +	struct vm_area_struct *vma = walk->vma;
> > +	struct pagemapread *pm = walk->private;
> > +	spinlock_t *ptl;
> > +	pte_t *pte, *orig_pte;
> > +	int err = 0;
> > +
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	ptl = pmd_trans_huge_lock(pmdp, vma);
> > +	if (ptl)
> > +		return pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
> > +#endif
>
> Maybe something like...
>
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> ptl = pmd_trans_huge_lock(pmdp, vma);
> if (ptl) {
> 	err = pagemap_pmd_range_thp(pmdp, addr, end, vma, pm, ptl);
> 	spin_unlock(ptl);
> 	return err;
> }
> #endif
>
> and drop the spin_unlock(ptl) calls from pagemap_pmd_range_thp?

Ah yeah that's a good idea, will do that on respin!

>
> Makes it easier to understand the locking semantics.

Absolutely.

>
> Might be worth adding a comment to pagemap_pmd_range_thp that callers
> must hold the ptl lock.

Ack will do!

>
> ~Gregory
>
> P.S. This patch set made my day, the whole non-swap-swap thing has
> always broken my brain.  <3

Thanks :) yeah this came out of my advocating _for_ is_swap_pte() on a series,
because hey - if you're going to operate on PTEs based on them being 'xxx', and
you have a predicate 'is_xxx()' it follows that you should only do those
operations if you have applied the predicate right?

But of course we largely don't do that, so we end up with horrible confusion
between a convention that not-none, not-present = swap entry + this predicate.

PLUS on top of that, we have the 'non-swap swap entry' so we have not-none,
not-present = swap, or swap that is not swap but also swap but hey definitely
isn't and and... :)

A next step will be to at least rename swp_entry_t to something else, because
every last remnant of this 'swap entries but not really' needs to be dealt
with...

Anyway this goes a long way to getting there :)

Cheers, Lorenzo

