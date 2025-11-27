Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316A1CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C66E6B0022; Thu, 27 Nov 2025 12:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E606B009F; Thu, 27 Nov 2025 12:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F266B00A2; Thu, 27 Nov 2025 12:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1816B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:45:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 023A157993
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:45:45 +0000 (UTC)
X-FDA: 84157114692.30.74102F1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8CCB0100009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:45:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=df6g8104;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yevy5T52;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764265542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eg7n68erU3qV0EttbvsmG3UugZP45QgCKH5Lx8odVnE=;
	b=sPOtM4wenhJjzP9Yx0FzRdlurCpiyD6/Gy/Zvf2FGptBbVSEiP/1UbC2I7UqvB9RAnYrgI
	Wfpy3tyA463laLHEH1Z4Y2X0NYnsAgwWzKEnhpHFkXaBXv+E+Q+dYkNFf/bSzNHvBI2RXr
	jjUC6ARcPLTw9ozFno8z3V1mpgcNBM4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764265542; a=rsa-sha256;
	cv=pass;
	b=wFmWUiVscE6AWxXuQm/6jYzQ+6Seg4CqO5v9Pd0J/c/TZGM4/2xRS5GzGbVCEMJmpzCOud
	Jffk6ttr8H0HxKgyyHoFznKQ7myTrmB+J/0u3RyQNgtic+BasZ1dcq9uANtOOHFQ6zaE44
	0g2YIJq8hfszVnrzNyExLcJqXi4Q+KU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=df6g8104;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yevy5T52;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR9fTAS355639;
	Thu, 27 Nov 2025 17:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eg7n68erU3qV0Ettbv
	smG3UugZP45QgCKH5Lx8odVnE=; b=df6g81046e/TQC7z5j5rrh00o2M67Hfj5F
	NrEJJcu0Ss5MW7Frk0Kz3quR7XFsEHKqAEe1ZLGbzw9u1ZsVbCsW/KmF53JstJTn
	AYAHhqsU8hLjn4f5Y3bvrVRZPkQ9bbtzr9K1pUiM3v29AIYbFb7JibClyW1HncLH
	BSMYo150L7wj0xeMSk+/lqpc2xnimz+Nzgl0QQGpB/57hQsvu5Moij2sjhhzgIOP
	xKQ+FCE27VOD9lomjQFiRhSlfOq2DzaFW8D/a4MBVQ2Y5Ik9U86mk1AgiFYlfcTK
	ntvO6bkrXJjYLYyz/Iduqc2CZHUPQBIne+zATSND+5rt3/nYM/+Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apm7ugpf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 17:45:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AREnCYq032644;
	Thu, 27 Nov 2025 17:45:23 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013029.outbound.protection.outlook.com [40.93.201.29])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mch1fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 17:45:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qzRkMMTfrtGnVSjJMbXWukIHYurutOODFHBONsZMtU696rVtoSPZNmwEOLiQKUyTjsNA8es3GuZ3Db7ifr5/o914c9YZ8NMWm7KLiX0JorRyMFy+ReOonCV/IRzoRhkBWmbSWZmiGR+QCDXRHtM0v375kvCBD9DNGknInUgaa0venYBIl96M77kmhlHdZQ8YIaBa3IQr2+uSdyCQuJWKQ+co+XNLmkmzm18sASB8h3N/4hE0E+npuooD/3rvBdqwjyndmSsV8Y+8VFBlOhD+uCyhZoPX7SKV+MWn72vxwix0oQe4thcvGPQViy7Muy/J8Tba4DW9GweKhLTaO+l/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eg7n68erU3qV0EttbvsmG3UugZP45QgCKH5Lx8odVnE=;
 b=tdK9w8kDzzhAz7Ahweg96smjF2u8C9uzI26i43VbyBl6nohWBIFwDoi94iTKQzhM/ACZhY9wSQwYKm5/hHeVR7H+vLj9OC+7Ud80gAXVaxvsKMHNjCJg1wHOBd4/YF4IlMnuYZnLYC+uG+g001VjzOiR29wXuMvIxCYJGCGc4lfgInJ47FdEkJ7XMNkbYIlyRljrNV54OHzQX+RlKbAxcZe8M5cIN+NyLC9k5USbvYpXWqsEGSWqIWOZZsvEMN0tY3U/SsRsVxDRcOa5CnhIxJaT0+LZ6egcoTUhV1SLwLGV4F3v/AFkdbf7qagtjflbXnzKGvodODn7jL1NbZ07kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eg7n68erU3qV0EttbvsmG3UugZP45QgCKH5Lx8odVnE=;
 b=Yevy5T52/h724psTYtCPpO38/s+J02IU/orGRob+sT9Co2BLGbMZ2yOOBbX8eYN+HEo+aJKcC2FTQXORlOoXfxfzmT+E7nQgHHXjhPMdWeWiN9SM2wZOhW165SSo9vRb+Wq6Ig6VsUb8rRcSrd7kh8wnKSJrqNDMyvdfveK0pSg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 17:45:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 17:45:19 +0000
Date: Thu, 27 Nov 2025 17:45:17 +0000
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
Subject: Re: [PATCH v3 14/16] mm: remove is_hugetlb_entry_[migration,
 hwpoisoned]()
Message-ID: <66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P123CA0377.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: d966b447-e7de-4e3d-98a8-08de2ddcbb7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mb6uLb7KeBGYoLRC3P+ItDnw2AKQQJKiWKWFcjSN7C0HshOLl9HWudsG1IK5?=
 =?us-ascii?Q?UZQbJXaQ6vP7VxYhXU9i6e0PYKDX/Tst1nSrvSwqpOaUfopKf7Kxp1ryPhQv?=
 =?us-ascii?Q?B43oqMqV49w//TTXcEtNEPtUp8dnSsEDt2fq/vyo+XrdXl59tluJUhL6EOUb?=
 =?us-ascii?Q?wHDkqyScxBeZuQWa9cxbx30t5kMFpHdEsl1jYQPITZlIUrzlq7UoYmfl4XlB?=
 =?us-ascii?Q?efSIW0wzfrj/2QNDwzwyU9XTSX1fE0xkZFPT7f0e+zr/jFSvZiJwrxcha7eZ?=
 =?us-ascii?Q?PlfgdZnTPcF2XuJhxQa+8Q3mxGnhpvZ0xi1OX8UU/1gYeEKwaD1Ho2Kb5gd+?=
 =?us-ascii?Q?tZPx6fM0JruLZ3G33/VI2LtMK2+glr/5QjPKlzx2Kw7NPjnd/SbqN7LP/lMb?=
 =?us-ascii?Q?6NO8xwcsi17pcrgLjqVAYdJShjkvJvBhLsI9JzzRxWZ/wZVD5uNzqUX1L6lw?=
 =?us-ascii?Q?V602jsORNaoWOf0UWcR8JxoSs0BRYT2PNd+bkJoFY/WOgaUrJjoDUKXNsebG?=
 =?us-ascii?Q?KREL0ZjiI0NKOsyWukDygL070YtVhnrtayGelIXJSADsNoEuon6KnYbGeLST?=
 =?us-ascii?Q?/PADaxiKGr6AJMxzURb92bkvRVMkX9qzam7HAQn7Akuj5Z/644kSDlfavJRe?=
 =?us-ascii?Q?csPpDiOj6+QkTT/J0XY2hro9U0BPZegN2viFuKVDfho3aGpH6H78g9DzPvHP?=
 =?us-ascii?Q?TM3BvWSzMVReZ+H+yKAKEF+Rh9344KjH6p5koSw0pdz5j74yG27oltDBWrSP?=
 =?us-ascii?Q?3U7XIiLPnvIowB3s/zSGhm2xAHNYHHcOn9gYa8k0hYCEFy2tRDPlQfAVzx4B?=
 =?us-ascii?Q?UJz3/sLWAqy21UmS32/mO/cbij70J92ilEKIxUW0G/AetQmSkIVnlJ0BZ6cb?=
 =?us-ascii?Q?YowWWCQZ2Mzvv1uCvN9kIhYphzEz+Rb0xw4s71G7O407FWt5BdSfyhFs7xiF?=
 =?us-ascii?Q?KHPwZsQNXu8ldfrsj8+JQEDX/eYev+8E1UIXkjGsM1o/VQ7FUI/9V5XMHhuv?=
 =?us-ascii?Q?jaFs4A8CHx6KVvvalGeLmLtfRx9XzJlzQ8E+PwHuBU0XoMISyTNwJcNTdVA5?=
 =?us-ascii?Q?AMPwj69VdhxVHR6r7QVTXOShKezysmCPKsFBKaGrLltfNiCuNvflP3T8p0PY?=
 =?us-ascii?Q?lWyHy1T0lDQyRXChLtZb9/LcfOx94ER7IqI41SVbNq/YpsLGyro8ccIMwkEW?=
 =?us-ascii?Q?CT9mXaP3XmQ2C7xJGT157QG/PX4anwp3YybKC6SQkj3HoKKQycnG4XGwtW5T?=
 =?us-ascii?Q?bp06DiRQi4/w+nipG3R0gL2wGUDdtd2EcxnHyGQN0E+mqhzEwwYDdiw2zHJI?=
 =?us-ascii?Q?z+9uyD3qmNYdTu6EXdEbO5Cp1J+O5Jnsp/ZLZBp/8gTduW6aSa5hdVWHQt8O?=
 =?us-ascii?Q?LzEY7vyRm+yQc7nNbNxZM+0j0V8LA4ob1rPqrQOComEq0UjuYFHmUexkrP2L?=
 =?us-ascii?Q?j0evwnZG3VXmk+gVmdDM8XYKSEhtgji8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rXefSnYhDfEPReUlM0SUPr31k8L39pH3I4i6aDGn4ysxLsDnYIsQIJyl9SwC?=
 =?us-ascii?Q?t7PEYqlfpQlexUI+tY/JZgzjWxhu9u0z504zOMKp9PHOPBCIhQo//gV/2EhH?=
 =?us-ascii?Q?4tDXkDARCbR1LTZihe0V5vlQs8zEC6KKbOu0WoA/9oyKuAOIwsQWoB9jwQvk?=
 =?us-ascii?Q?ULiU+2eaHuqQFSBUVCHzKTfwXaHaOy0WTHpg3O5n3SG0sG9fYMuwmk5AjFMa?=
 =?us-ascii?Q?eLdFdL/VMrRbvnlFGyR+VTriLKA0GJN6krQdXG4qPwm3SmALnX0KyXoeJnmp?=
 =?us-ascii?Q?ClhMVCWDTuIesWdgy/KqpGRFpqu4+gd5XUR63EnFI2LpRqXyw6QqTLld14U/?=
 =?us-ascii?Q?jHtU8YhAz+Q+CRSJlCjaBbVMCl3fCFY9XI2ZLlPtgsW+DOnadoH10uxRF33m?=
 =?us-ascii?Q?dmlSBdQGzvgDT9ICpTI3w1Mn86i7UHdRXJ0AKIky6HZKTTMAGC7uLpy1sk7L?=
 =?us-ascii?Q?luM0Fb21kJELDkVFv7r/h1BBBH5vzgadenw/eOWWfgUOALvwmEXNlIclN5Yh?=
 =?us-ascii?Q?dE/QJmyfgoWUFVplGgJTQiCFdVsu/gy/TLYB1GKRZE7aEeUy1lLNYQUgtZbb?=
 =?us-ascii?Q?RtPAjNQj31l375uRXRYnddyNeq9UuS6fv8nR6U94wF7GQYBuLwfQFp7vaE7c?=
 =?us-ascii?Q?1sI8TPl/qR6HM/USVb+99yMAFnFxBmKPJjincH0wraVfnTTVtpP9sEUnS4jU?=
 =?us-ascii?Q?LXcCEC0MZopDfA3G9azHEa6ycYpAwksWhruaBGIVVs0BPmBmD7qrulXf4oFQ?=
 =?us-ascii?Q?1u7IIGl0ZFutNaW4XvV736rpbs7oZISciniWMWij+NSQFY7586y1b4ycotdk?=
 =?us-ascii?Q?ukx5AVxr1g/cXFpgQR/VTHdzVQQhnCJJR5NlugXWPZDnwp5TooYVC3IhnLNb?=
 =?us-ascii?Q?47JLas1xkQrEbsNK7lKIayToW/nSMcaXqswcKKuz6wR/vhsrFZ8+DYUQdlUW?=
 =?us-ascii?Q?X9O/Crg/p2CLjKtmQy/oLCa/3pSge2tuEWneUF3PCALFOWJMhLYeWgI3ZFIE?=
 =?us-ascii?Q?I+XhVKar8sv1hoBqHLqvhj6Zmm/SezuZgNInskwkxiYGlX3gldE8VR3kYra2?=
 =?us-ascii?Q?yLUPsPyBLHJ3u/EBIN9z1qjLgOMBzSgaVqMlUOrW4gjqbjNB32/0mvRspI2f?=
 =?us-ascii?Q?cq47UmZxMLyT0gzH9HdDt13y3vyZFflh+sl9E9UACkhdUQ8rTuypehE/zfgX?=
 =?us-ascii?Q?WTNlwlqDiu464ls2qA62ZJleX04H1PTA+7fuWV7AP17jDVxtta/LlLTCAXeR?=
 =?us-ascii?Q?ri9QnXYpsERtUGD+tLIxOEnsH6p047QiUB9bQpYqDKGFtzMYcLX5udsQBEKl?=
 =?us-ascii?Q?CMRdt097YXB2Zwznpl79GyXXB6dehh+6T3pgdF4C6wbk4PQYHiXXay5pS9D8?=
 =?us-ascii?Q?r/bESfEhWdmR/ytvdXIg1KjhR1NkNrldcdl1NXqfBczoZ2/1Wd6wZbiIVfFX?=
 =?us-ascii?Q?w+ZfOZjesdkPrvI/9/u+7Gq2cJMTbGJsU7sls8xVEhokFt80mzgZTxGSaRPP?=
 =?us-ascii?Q?W2bUx6hnp7eYj8y/8lSZQ9FFJ8DS7/cb/82oVn7NUYglh1oy3hJ+DdXvQgTg?=
 =?us-ascii?Q?Tbm2W+Q7f5pNk4ikfatsHV/nmX06RKvL1VDGcZ+VWy1rMe1nJoa7MgMP+ZWp?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9Qn75Rcb8M7nEdTaSKR26IKBl3wlCvEeiADGGKhEJVbaUJN96qdvbcxb2law9xZKfcymU0DdEoyx566NSipoN/cbijEnTx8mg6e/MHn8oUAq+snY4LeLdCU5fzC6ms6HH2OtSqFJsyBWsfLw458b5wHoXiff5uqfgkK0Vf6q8emR1bfwHrfIAuVlUMN67l5y/cNGmd3vT+oq4ewfPgzxxJY0/anZZV1sUiSaQ5Tf5g6n7vI2gmJ8hRb+bsLFbRwIf7zhkWmlX/i5qULy/oVC3pqInsyoSqVpsBr7VrONmiWqYYGEJmvA7qXabwJpBjxjxt+MZZsm3neia5+qV7hzwvSfQHRUbm6I0IZPkYydQe9GFoMujibYIngWPrgpiiTp80CiyvskesMyI/odjEBFNPA2SeB3tNEzdbHnp9c8ZPBGpmGt8qLK4csOH2EK1xoOdOEA3mRj8itgI8N6BUxi4sQSJ0I6nWSoPrtpu97K66PPFN/R3c6ZYtmfFuJe/rKfQlA2Wm1ChapdVYiANju7H/kdu5lro60VLvNthoojK9qZMqivBMlUm/0uVgIoTsKq57141g5cvjSUymtn6BwjqJe8xLJHpDhs5Zhb/02ROqg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d966b447-e7de-4e3d-98a8-08de2ddcbb7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:45:19.5345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XObYGkDqKk/egoc6d8z4XBH7chDjBVLIPGa2/Fnu8dFU/Z+LYzB0zPKbebH6eNGeh1EBKPRiY2ylD+u0H8GPuT2l03R6un0OheoWbnxo0uY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511270133
X-Authority-Analysis: v=2.4 cv=RuHI7SmK c=1 sm=1 tr=0 ts=69288e34 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=3gfsHB_DcYJMU3YXTD0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 0U-yuLL_6p6t598GOZ-IdTITnrcFSW4Y
X-Proofpoint-GUID: 0U-yuLL_6p6t598GOZ-IdTITnrcFSW4Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDEzMyBTYWx0ZWRfX6GR+6f0bZv6T
 roQLRrMtRt0h+ODmC9N/CcIsDbDMuxPq2/kg/P+uSFwZsierbhZkPHDU8782AqzBY1TnR0pqnuo
 TqLBx8wISqJbF2Aq3ucN0svnIwM0OW5OpShDtvvuhxScGCCkkSbm/6AgjdYR6GSOXXziFsyQOlP
 14QYhpxUn6SLu/XT9ra72uE5p8NX1Gg2APlPc9/dMEu0Iqh2VE/g4NZB0WzSa1UxogogzkVUDAF
 uvqWfH1LXBKOYdZK3Q2xfRHu/suK/v0T2krVXWp1srkvOt1kqA1J23e2Wea9Kpsf6GRlOhLnbKn
 1wG4LOscd18halPSR1vojXE/C5lv/zubSrWMK5K3z5yyPE5cCmqpmttZA2BM+XCs0B5I0qAbe1L
 tD4uFhZaL1kRnGFro+YYhF9vASRewg==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CCB0100009
X-Stat-Signature: nyat4onz9rsygsgctjrs49q4xwzo5zfe
X-Rspam-User: 
X-HE-Tag: 1764265542-115181
X-HE-Meta: U2FsdGVkX1+3Qqp+/B5Ejxr47Rk43ZzbrLgd3tJ4i75H2wVt/JSavJLhIKUF5VFX96AC1cB4srb3q+GpFen1AcCUQcDDmrv4vrKXS5/hFIMtOIZGpyyTjeVzTMxuAGQwKnjYKwiR1ovs4XUZ01OtucsZwC6dNidEfIHsSaQ2MBqgI8V82QCdBWGoTUQo6s425Oqtx7e30N/WXMq289tdJGnbnLtGsojt9R5dRw/F+zemTOs4Be02NzSKDwMoin7kNiP22IAGjFzcP2TeDTjGcq8dgJHL0xbZawTL8Q3rUMM1N0bQFqdOzasqUnFeJGk6IIJNj+A1w6UWd1A/ZbH9X47BgQuxrXXVqAZMaUTwJaghF/IS67U4UdP6bZCFFqrCXtNmlj2VDuqK/hR62E308TvTaCeVre60fKFA4feMAb599L+ag6vdzIFmaxGGgHUsKwtAuw0YBI8kxwruy78QKEKOKrEdQctuT+C5U32/Tz5X3uZmHpr7P8TNShfIU9i1UBeXXXJnizb1YRSv4RAOhq1czWX+C1582cVIB3oA+Mr1qiUaEPxwz/zm0+UvDMLv3jVpCxnuDry0KvI40VPN8FIhbMS7eUsMCzvvJaV7HEWI7XPwFQcdA3UCvHDqN3sZO8URYujl7Od4elyQPFzA/1R8ho10BaMpl57gU+QKKcDwlgvomaGZuYFbuSlY4ahVWpuKsD5HGyEFaCipIaX3VtP/IrTfI51WoHLjo5P3F0pfkHD8uVn+NT36/SgwronW9JiJ6Vm1ZIfddmCX6mW7q3tYplIdjkRYOU7RaqDHaja9i6aaM6x5a2kJfporeARVoxaHCDnSUPWWLLWieSr23xFHLvI/aUgsEIVisnCktNF5+z6quk/M7PAFcDytFH1LB+ap0IS/H/51dJgAuoDIcKfCc1V+37yksX46Rw0xB7yHTvhVTZQaivk4IALU/ejBRIMpTvSK55MXbyE7cPH
 XvTjOABq
 7XjmZbKE26JX9VJRdfuvvJBLuQ/KkZPz7DaQxIybdKdrW7oQ79cGsHA+ol3Bs6HICtimvvuJ+5onG8Pr2F2nLhxQc1qejYSgH8tomTaRUN4WDhntwqeocmZWnHDbqim/rjCQ+Hpz3GZ+ZHJ0LfR/dqAvrzmM2/be1OpIhf/a3cEGJeE3oJ/64dPMb2INNsdivVrl3pXoPij/6zdKRsTRI3r7WeSnF3X0ZoiGFZ4VMa074PJjzIt71T652uVlkDOaVBoszQEsiCwYJgSUtEw+plr70M121AViLYXMzy5v/NKCk6yjowDQEE/Bs1IZRCrDFUJsh7tFk7zh383DI7T7Sze6p3xMh43hjqBQXwJcyF7CPIkKjRKtZLkkaBQsDKidTIU2d/HL6L4v5ibNcMTQhiF6KjcUUkQ1enhvi7Z6zHuKcopoVVni1cmUabzpbO1TXlUAN7hFuEugPBOF3PWPHsjRQB1ldSajdlxdbiG+2ReNYsdJzLaj7nrZaYrCRtEBGx5K3//dEi+0015/wdobwxDKm+ufpVb6vig0kvx1uP+7wRIQwj5p2BNTyuFvTTb2FvJhv2zxiNnlFfopC/ImxevQvIc7vXgpJXOaPLX6VKe1pfiwfAzcSIWuJdLUuRJXAsvkxgpzokBKd9wyxyrjYHlDjt9wzr5AhcYfBptn0bMLuMH9A62eLpVxzt+Ie3GkHC5b1fOcomyKwVl/byYvXaLyokQqfTzCaTIQxmSyLqqWv7HFIMihtx82ipw/St3dYaIm1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please apply this fix.

Thanks, Lorenzo

----8<----
From fab663ef70a57f71aef762538a9b31deca811791 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 27 Nov 2025 17:41:49 +0000
Subject: [PATCH] fixup

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 fs/proc/task_mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d00ac179d973..81dfc26bfae8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2500,9 +2500,11 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 	const unsigned long psize = huge_page_size(hstate_vma(vma));
 	softleaf_t entry;

-	if (huge_pte_none(ptent))
+	if (huge_pte_none(ptent)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
+		return;
+	}

 	entry = softleaf_from_pte(ptent);
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
--
2.51.2

