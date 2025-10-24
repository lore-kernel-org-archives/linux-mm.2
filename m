Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8383ACCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7C38E00FD; Fri, 24 Oct 2025 16:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF3A8E00C9; Fri, 24 Oct 2025 16:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C971C8E00FD; Fri, 24 Oct 2025 16:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B482B8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:16:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AD77C0B55
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:16:21 +0000 (UTC)
X-FDA: 84034114962.06.AC59001
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9CD914000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:16:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qe087BXN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HKQjmN5W;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761336978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZTijjcURSGMWmIeE5pRypLnRcYtIWzhn5/0BnGnZ5Y=;
	b=b5dCIJAHNrKyI6XOkZNq2fZFAusWKM+/f7TTqMqYFjkwNBm8ScKbnlc7mtJxBYIZ0Mr854
	utv527SyNgMGSfk8cDmPaM/MI4ie42i7qDS1B+Km64mabnzyjOZeUVh9yK7jb7MTz3+06M
	/JH/QbYONf2j+q9+svtPDjxml32aT7o=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qe087BXN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HKQjmN5W;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761336978; a=rsa-sha256;
	cv=pass;
	b=DsAfJ7zpG8s0pTaK6j4eOTLyL4riZsv7NEPk9N69VeIZ4fT4qM6wg8z9od0PUewvNjan41
	FRWtsTw0UrGg7n2BuauFl27fAgakCrA5i4RlK3gZ3+6hMPDCu/yFVq9qK78iEjXboYqxIK
	Vh41url4vkd1TW5Lw91SWJbVxgEVNI0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OIND5k024745;
	Fri, 24 Oct 2025 20:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5ZTijjcURSGMWmIeE5
	pRypLnRcYtIWzhn5/0BnGnZ5Y=; b=qe087BXNF84/eW0O03ImUPFaiMeUb44x0L
	PMvmnHr9atoqsnJ2hIK5lBaikSYouBVtgfjeDmIUL2wu8LzDS0u2SAxh4FIIJzG0
	uESDuwr+rPtqGMuNHyPdVj3N1ZCqnH128574PfFNCj79qnFY4nKXwnV4BJEvN6r+
	/cwxsq5XLuGANViy6TFTTq4twigxJ0Qk0aMs1MiPjIU3GP9+VrxdO1dIV36KbpD4
	QPLAwvelzemTFck/yGqG1BWhcPVBRnukK5TQYx38mUWxYh5QkGEj3xrhsXhPM4jZ
	N2dKSTS6wIW7b98HhHVlez4hbHnd/KJ76LvX264eRM1cgBku5kcQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcydk6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 20:16:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OK2f0j004427;
	Fri, 24 Oct 2025 20:16:05 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgbg28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 20:16:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=an0zu9x5RYiu9DRTEMBvN5NDOVL1jlX4apJPGuvXvULlVTNeeOohzVXDGGdoaQSZ0q2aHWZZxr73CuCsXaJoJr/F4VlMKeKrRab3g21tzaInSpr5qLlvJhJTDRTCi13+mNVt3JeTvOEGQqKhkm+lxbhL4iUpcJ+DRmCaAQHXr/iNP9hvb5Vpd8lkadgpsXJGg2q6rt5Za0IL0XUSBqaxu/MgdqZP5SWT6KkO+lfqMG2wBp57krPo60sQiSj19A9SBXnvHuQhgIhf0JtxyEsgv+p8I5MmJNyVuD747dCMHYOqCdxdEtubbB7CxI3XxlSO7dtF1juZ19/hTaxqrscT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZTijjcURSGMWmIeE5pRypLnRcYtIWzhn5/0BnGnZ5Y=;
 b=JWLLz5o8UBcSgvnMwitEuTi54qcfH3ssXqoqNUUw4xsU91AVnUvbQwNt0NM4XuQaJTDczdeCg8Wmyyzz9AA/w9fC085fPc1zX31UIodopKQJ2iciCKmG0A6KYk0trNytxMou2Ygx/jFYw2S0cYB4vAp4xPjwm3Gc2Jk+Dgk4Vkdd7BbcS73Ic1btc998ibAZq6TKqndRAYqvtDLb7bu4beLre348ZUYtG5yBD/V0YEksIV6Ad5HdWX9gh8ld91yy8e1e4mwy4G5oOimtxl7Ano+ZirxCzhy8O3SAjZHZg+FsmxgVvPMoa88py0zRvn5T1oRRsOwT1tL8++U306PLWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZTijjcURSGMWmIeE5pRypLnRcYtIWzhn5/0BnGnZ5Y=;
 b=HKQjmN5WNZ232zR3Ng/yWlPKgFjo9mm/85bpzCIZs7PubrnbKnvB10DqXnUbV1o0Ig5InoAdVNd6yPHTqQ5QrqsnT79a0TgG6ZXm6FlUEPUrfaad7LsYZRR+iiY3tjGQjzdPpaYanJWDXLGj7SfjPxEnwxw++kkWWPVvuP+VFTs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Fri, 24 Oct
 2025 20:16:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 20:16:01 +0000
Date: Fri, 24 Oct 2025 21:15:59 +0100
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
Message-ID: <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: LO4P123CA0482.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d1c9d0-fa81-461c-4fa1-08de133a26b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ro//7T+OV5jo3dyJ1qj170rAYDOoVrWCG/IcwchykdMgvEr9+WmqIAp31irx?=
 =?us-ascii?Q?fM4Htflf/LhCh+dENYwMcOxsKFogqGBthqD2VB4TAjK7Demw/rs1FTkOwBwP?=
 =?us-ascii?Q?TFn1owUdzwnXQG9iYfv/eA9t9MIpI2bAfdEVZWohPv9Sze7pE4sFNqiquYHI?=
 =?us-ascii?Q?XRAHfTijhzzXfdHndkHmUe0RTBw+OdiE6QGwQ6V6adpU9yTq+aUJl6iswx8K?=
 =?us-ascii?Q?dPg1SUE164zvEaw0g7j1zuwqwMqesTKRtg+Rx4asHSWL1l9m3WGO4g5H7yzu?=
 =?us-ascii?Q?1pfVmXjFcLFKPT1DRoKfcgM313xvKvqhhnkiqCL/Oz8US6cU/jNldew5HF0s?=
 =?us-ascii?Q?GJUf90Tl+3R2ly5kk6AVa5ldtAK4AST8CIy8x7Xsmg9MN51ZhN6jxLnzFVb5?=
 =?us-ascii?Q?e4MTpDyogvE3uJbjdkjUg4iF10a4k42EVQVhfmJCLpNiLofNtm4YmdCPd5ou?=
 =?us-ascii?Q?ABLl3XjcMNJ+AFvznm1IJauMPwnQDW6G88iIoqeYfTylvKuE3K0AbCMsazrc?=
 =?us-ascii?Q?3H3acw4IpDPnj0VbXE8W6zTU8UPKkaw0f3fmGlqG76VOu30qwka2WLZ/bMe0?=
 =?us-ascii?Q?zavhOqSdNGGCSufeo4aXIOzaK6Tmz8IW9aIYZTl+ito2zpUwSCDS89uwVduH?=
 =?us-ascii?Q?jov2soDV4szWwjj+AHKWlVukDS3vDSPAtWI86VdF1BdZBXFQJbUmehNj0OPy?=
 =?us-ascii?Q?ZeqmNm5/ygahK3rFe6leukKcjCfjzunZ6CBaoWsbfvLlTtkEH+SOSVPOKryz?=
 =?us-ascii?Q?WGHfgejI88YgiobsZLwlLDZZY65lYME6253MOvzlMK8+LSh4JMeDn7DQAPHg?=
 =?us-ascii?Q?AX+JZTYp0ip0BUO9EtaSbPUdovnVDBxHmRaswch7D8TT/3Hsab5SbwrKbLKR?=
 =?us-ascii?Q?x7rKArIS0rZu5530BRkUKOkMji1gW9O+8fw/dcEnP10hJB2ZMTwbon8pMQEg?=
 =?us-ascii?Q?XT+r8iKLK90qd91gVWMSWpVAftYxfOSEEw0ttlxaJtPD80k5bRyXQQ/hW6VT?=
 =?us-ascii?Q?94TyW4FvMO8E/m7AotdoT3UhXvPZ4vCHp2b7fMJLxg91nX36U/WtKEIWQ4ce?=
 =?us-ascii?Q?5gkzFRLtfED0hnMM4ixIWE6ibL1lxLI4YgYsa9Qj/oiOSgYxJD42qIljA2Oe?=
 =?us-ascii?Q?Hbq++SjtRbUAWOh006tjBvHoCPPrKX+AvcCjrhxgk3hUeSo+3Oha615nMB/O?=
 =?us-ascii?Q?nf42SFhG1gaSHcr1UdAjz/zM3cIf//YSVRyxHAw5hi5tm9mbnajUEVHYOgAd?=
 =?us-ascii?Q?G/Rjy9fakNFFimKL/Y2Ey3cfTxMZ1/6dxt9MldYeE4wQZswl5SdILHu7lm2q?=
 =?us-ascii?Q?bXhrh8EXBLPM3FcJ+sP5LBW2VJ4EUUJZeQeM0PyPcHdqNyAEgPyMeV0ynffR?=
 =?us-ascii?Q?97v44bSdhUu+ig5kqWykjLW41l+xKvX3KaTfuGuhJ5Y1/UBWY7ztJOHVWIax?=
 =?us-ascii?Q?iXjgcaNv1Bbmjo+oSV1h+5qlXYcfW1Jg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xMZXGKNMEhBIht/1APZ1KulgEqvYDDEKjxSGKSpBUmWFfUvSbjktfMsSseWy?=
 =?us-ascii?Q?tNfhXu2nmleD7D8wpf9mkXtRnIEABihxWcpTkRT1UgyjI8Zp4hOZdSyJ6Et3?=
 =?us-ascii?Q?uCwHBqIMnSg6uVBNUW8hm/g+UL69GUfrJWNEZAYHU9sIfGj5oGC6kDpovLpr?=
 =?us-ascii?Q?8MMjcUhdxRRtaRKHmFe3nPJqE9QlMQqiM3dqHeEsWLzr6d1J/futejTdNe/0?=
 =?us-ascii?Q?iQluzgm1IjekmDIjoCLKKoCiF9g61S2DhHfbZ6U6b0nVUCnCHQt3RXb8fb4H?=
 =?us-ascii?Q?lWw3CdPf+jfDYeEWuUpVxRVedz8QH8zL6WsN/IjMBwbRLpj3JZJ12NvnCfoA?=
 =?us-ascii?Q?TEtUmiNJC/PqknJki5uPtKZUWAml8WF6Se+8frz46vgHcQjHtWw7IpjcjDgR?=
 =?us-ascii?Q?cgoSPcWo7MTyRyIAIp4fNx76BGYMepYzuKz8JAjFATBIneKJm5Zw+a29bT1d?=
 =?us-ascii?Q?FICOdgIjfYNjNrcTdywQm9a8jAc6aYzXazUGwzYpublyHgUf0jWXXdOcsgqJ?=
 =?us-ascii?Q?uHlH2scVFab4p22WLEQh7g+JgaNPSGljin3hyzo516UAhVCf92RzIiFlf7wV?=
 =?us-ascii?Q?GhqA2chfBUUsnVvNbIRJYdVhwzR+3gahw/7w782KwJ9Uc35eWMmAbdfm3lT1?=
 =?us-ascii?Q?TRy81Jz0+q2DzwtBRSwfdesMi7jTO3pZffNy+kLdRA/kNh3C0KMrLmaBrv0e?=
 =?us-ascii?Q?/LO6B6madbBi3bgGoIvw0fttWnLFK7Y9svhDJFo1xn8LFOMCzGDf8fZDi44c?=
 =?us-ascii?Q?k952Lc/P+apksPybCXUBExM07XDZpm6VVCU6xYV7IJEtKdWM3AhCK/jKrX+d?=
 =?us-ascii?Q?uPz3S9MnKJHZrg19swQrSyx3lUVSNqg4DAOWusbqLB6MH1spXQpMrwIPlnDu?=
 =?us-ascii?Q?YWpSRxiRFTJr+R95rmEq+QJBKVhvUq4pnZrum+nFN5hZxn0BhBCvYw3vRzwf?=
 =?us-ascii?Q?qRftP70VM8y1Mv5WhnCUXBgAfcbVwMBTkkg7UndqjbQwQTdOsn5o1EMYkNpz?=
 =?us-ascii?Q?NCDZaCLzWj3gsI09BVzECDGUIyM0HRylrApNnkQiyQpZU5ksjGftS8kxBjEQ?=
 =?us-ascii?Q?Aou9RlzSrw3qBmxAUUoZhmjZFpp+ZdCsLfheIqYikZawJJoX8doYAh+/aIdQ?=
 =?us-ascii?Q?G9RE5X6ql9TtkS7heYJGaaG1h76dTMxAPrHdfTP+3fqXKi9ZrZkAxSooNtNR?=
 =?us-ascii?Q?zfWokEGgHUSheAk2IbAJ3fPJT54Tq602CRpVVlINAs6oHM6mJZLn1LUsqYU0?=
 =?us-ascii?Q?C6qi2VqbsD7B8tt7/5Xeej7JajzOE5iMmh9MPOI5kuJr3F6+N4fuk7aLqEYp?=
 =?us-ascii?Q?HiR+IcnwYxu6WiU2FyEV8tSuzMLyleh5tA+uQVTK61jnG5ruKxucB9RXDpI6?=
 =?us-ascii?Q?6eCVaAf5NkkvUXASNnkYhBD+UlIH3qy6MP2viJmzEXEJ2g4XW8rnd7RAIXPx?=
 =?us-ascii?Q?MhTCflUyEvn6bHWQFXXlXUvobxgeZajeXycUr0H0k6WlnYhbkNRTCh1BVoHe?=
 =?us-ascii?Q?XpxY/Yt0KfCI/idWANgeLTEoz5W0sUSv+qIIMlnwQw3ygFmoe66CTZaaBTpM?=
 =?us-ascii?Q?3j1b9fRFKjSTkAJjUpBhVM/SxSvnUYRHrjMGO5KBrdZOQI1/ItTqTcDrQ934?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0a+x0gVetRNfALKcqkcs0hmHeA/ZUjL1skUCsa4k+UqejTUEZX8BIYzW4ceoC79AiiedqNrnjaL7rtRNhNEktPPRpWmKPSeHfnUk/GD1q4jnwvUbI/huTiRIZb6JulNkqur6Pq5BcRBWSNsc+4NW5oZuW8+I8RHpi3KHhwrcM3F2XtGvr0KVjRR3GhnRLXKjBR3JGKlcozXR691MSVhSLcgJofrVnOjztnKU1jh1HozmmCDKkJFDTsURIVZ8ZUy6y5B0CsIQXl+ouCVTHvftJIlzz3EcLh6zGnsUUGgd0fWMRHi+TQ3FXTqkNKpAvV9hXPgZW4EMlqU84Ss0deLN6oMG1ccNwKBRoPB/zlTzwrIH4ZtgOzrLJlVS1NQ3G67eJtG7NYDS4oBqypNBprdsRoEBPdHVu5AgzFN7lvZtDbijl/fHSwMZXOtKA9XnJES67NHoVd4hNtaMXCbEmp5XMZ1CRZajL1TZbHyZIZInaLU57Tl0tMaVK7lkd9xHXXFJY0x7jEJ7bEO0Gu1oPc3iPmxSIZCUsrKhip+/mODN7UIgaB+WxBazuzPy2VnV4AsZSfuznxdg6vjGj3HPu9qRRCscD3YTuIbs5bBCp8M2Y4k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d1c9d0-fa81-461c-4fa1-08de133a26b9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 20:16:01.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoOWi88DQ4ut/nhlxCNpiSgnVXF2ToFv85cqcghdU6Rk03eeenuGjbb+gvxHcbuOhAU0BOKuFzZLZ6EVl/Syg4yLa49C164tS3wXJdg3qDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240183
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68fbde85 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=tY4l3yYr-_iEL48g82sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX4tpSNxJvMY1b
 ibZo/uXRQci472DSx3vSSlylF4kysO5KsotLzuacdsOklMFVuvy7S1jcmIR+de7C2fr+/vc0FiT
 yVQrS0S+KqnpjC3AjFa4F8Fq1iqPSFJi3bXjUuq7Cv2pde+5isNkW0vVGORANREEoFSynMYW8vq
 PT5R4ki5UdwzLvzjxkv6tEqDtSw+BAL2pnCLRlzL3P7uev8nTc3JZKoiUUOGvRn3PYNNQ4r0Tvn
 JbBVJJffgD/pH29iTF9iNiIE7HdJupLLSpgmkvHjQtDSwTxQ/LqVyeeceHN1UfUk8ARYdwyQ914
 0UxBM6sg+MiJsYzwZevsNfK86TG9eZpRvl95hPWQ2id17/eQKRi3wHvOPwTazmn+NBg2yciq0BE
 rJgj69uHVRX6OnHK2D0goOaL3lWVPQ==
X-Proofpoint-GUID: XTgCPRFGzEDRsnwcClvjzWy8mXcJJUh6
X-Proofpoint-ORIG-GUID: XTgCPRFGzEDRsnwcClvjzWy8mXcJJUh6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9CD914000A
X-Stat-Signature: oxob4ker4iszp1agqhet8zosiy5nzqec
X-Rspam-User: 
X-HE-Tag: 1761336977-91932
X-HE-Meta: U2FsdGVkX192azSudhBUm5H3HyJo3Sr5vpG6AK6eierOvlBUJBXZuvcePWn90d8PsmgnAQLzNIOIgveKNJI9KKZ4cnIwJAuYBQEUW/SWrAREdibzXLXdoYPANwZFdpYyWMMi5lQB87ECWmwLHvOIRsUU3l27hK+IKkiBQ7qclx28iN0c5EMeT46ft6G49AUKWPxXxwDPYgR04PVXTtjT/E7chNqeBdcRTQ8KT63vznBedknQUxBaySKfM6UuIqAUjNYX8YAc5KP2D4R2nFZHj4/afxxWtQvm4Cqc8Q40Y6M1vW5JjUBB1MacxvxEq4YiQYqgmge1QiIFWXLnF6K9CUNxTiVCRRTmmLcQ9BaOjQlzkGB4ejP0GbrCQ6+kCzpWbxNwC2LmTV5KNFT0Rc7+DHlEJiqOe0RRe/kgAqvM3O/YE/XDRnQ02k98yIajXdcIBDZyMb36Ywfbd3MEMD1XTrfvXBfbQCc+1hQllL29doyfA87cIslJMyWEfx3xcsmUQYpaXGq7s84/tt3dEVDYgjUFAtq0MPOiVSzj1Zg9WQciHgW0FoU5J8GdGbDI6ZUxboewhY6EHMnhZXGisrQ7jjSdTQh2sXdRGUTk1XdxwGPO6EM4KY+K9X8UelHSU2s+tkyHivgB3JW99+ZfBR1PbvPuLVxpR5IQ9/ex0WJPO4cvKVDN+Zj78z4AWcMmdQXXivxyLlhpCn1ub9//EFGBaoLYsEKPwceXetQG/Iy/vr1wptXAfqAoP9QY2Jjhv6rvWVLLRoCAXqHQP0VwGfrTwUaqClgrc5PPgiDDCPhd+G1xoAMsBZ845Dm4zsmR469QQ3y+3wNgJk+y6qsX/LuJFdR8b1OZDd0ppehbkJOH5ozUxijCbQasp574aVE6xcfg43fxGhnA0VcZLsANr/tcpBkToW8MPQlQffTBskNpoA8RhvajvrbXA8MdTDZTezgWxmd9RouVLORG5JsHPrA
 EYmbvCe+
 x8hgVcYCp8QI7SEwCtYbvSBoC0EYCJsKOtmgIVAt9UOPtO0R5Q87PcWUvupP8zDbXnxpdSFUhcJB6UYd4PrUib3kGohCId81eomZeiSd0KnCfHLSADxf2oq/DqZfXYrmZ8DHI4sDB3/UjAXEf7G/HaKuNC9D+22ffp9FIGJNGlUQiypIjSWRShNJHUy3qUpjClNLNVOS7QfyEPAORYp6HE0Dp8mXnXTbkYyNoIYyzIYvU/980Wm1AeZt7Pxf9ou0HgST8/RGNGZqrWNj+nzOUZ/Mjf9K+SJdCscDVlVdgu7WlynLhks1c8mDJDkl2/8rmyJS4o0pqU3B/DoYe2gR1fAmGkqrrXAYhYszxHIJu8rXvpkAIKf1gEPbpqcY9CVAYBEyUv7Eo8CgBKbti37+WYJT+EtWOnjYsufckUIKnPNSXsVqvmN3AwJo0xJXjGZYkgVtkwK6BB1eRr6zp6HPhXteGPhPmwTWrx28v3EXqnJrYxeSgsYL8ry8fC7d5MTUWRwe+8pRAzbAu/OZg/K2ePNnAV0VWlRcPftPBwzUPRjyuOwMcaKZSdhO5Dm7Wfly9lCe24Bhhq/RNCO2NPBvW/su8tqRkOUOQcT7oHKDwisJ0lLuLL/IY87502EbQxwyBlhvqj67zlyMGPzLoDiFnsnQqPX0pbiPpyspoup4ErLDJzKdDF1EFl9dtQrpch5+pimI4+xDmP+mE6afrDh5L5WIQw1Zik1kpMEw3WDUpyJabR1E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
> On Fri, Oct 24, 2025 at 07:19:11PM +0100, Lorenzo Stoakes wrote:
> > On Fri, Oct 24, 2025 at 01:32:29PM -0400, Gregory Price wrote:
> >
> > A next step will be to at least rename swp_entry_t to something else, because
> > every last remnant of this 'swap entries but not really' needs to be dealt
> > with...
> >
>
> hah, was just complaining about this on the other patch.
>
> ptleaf_entry_t?

Well you kinda want to differentiate it from a normal present page table leaf,
but I really like 'non-present entry' as a description for (what were) non-swap
entries so that's out.

So maybe actually that isn't too bad of an idea...

Could also be

nonpresent_or_swap_t but that's kinda icky...

Naming is hard :)

>
> :shrug:
>
> keep fighting the good fight
> ~Gregory

Always sir! ;)

Cheers, Lorenzo

