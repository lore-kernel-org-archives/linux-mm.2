Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C108CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9AA98E0011; Wed,  5 Nov 2025 12:34:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A731D8E0002; Wed,  5 Nov 2025 12:34:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A598E0011; Wed,  5 Nov 2025 12:34:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 810668E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:34:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 561151403D5
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:34:02 +0000 (UTC)
X-FDA: 84077251524.01.2A5BF7B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id E073A4000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:33:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QQgAr7pr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q/nTRDej";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762364039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPwPlAhooBxzdgHN+WZeEBQomMfUmZE8vig9l8WZ2Do=;
	b=VGuB+9r3B3lq/7DHTxpDTty0KqRSIX0zm++TGQfKc2DnbDfb+JsnaFIcavG9Ri/GPGn4jD
	0YmHk9GuCHaEbSpqJ0QR1KYXxjEzaj1UUMJ/fwuuntnObhMMVKkiVkEKuk2GGbh6hlYGPV
	VIab8cTlJ4rp/i7w7vvL7HugGILDqfk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762364039; a=rsa-sha256;
	cv=pass;
	b=GbdvY7ta2XLCYttTIsySrKfTu/Aq8y3PON7VQ/ibJf7fMgbE84z/E9WYA84XZiidHGX1h8
	EUfbP8oFpvf1YvUBWhi0Vn7LqQjVQ6XCEFlMStLIIbXTnX1/eVifK7+7IVHtBV3oi0ChaL
	DIUWtvWB1XAJBhTg+Gef4u7eBo2uzDQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QQgAr7pr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q/nTRDej";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5Gnv1b008486;
	Wed, 5 Nov 2025 17:32:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TPwPlAhooBxzdgHN+W
	ZeEBQomMfUmZE8vig9l8WZ2Do=; b=QQgAr7prEv/uOH68+Ku08KLfQURc+ouP7R
	iKvX0q3WDmwmhJ2xyEiZtRMGbrgfXjmWcE8+D9/0By+2Mug1iWvP6Y6mAmlNPqL/
	J0gPyRSYjc0WHkWqn7WVGLVrmLVIXLBAzqv2JKcGKEqoYaRH2QWzjxqzBqNMKEAG
	yyG4z7MS98CFUE2pgt28yfRg/y1Y7qrWm1qdnW7hbq7/qCTzW/o7+P+v2ayNPYGw
	eJxpLdfRMC/2+24r75b1u7uswTmi1YBaVmwgNGJefplpx0Q5mBlRW2LFUMm+gm3i
	qDvfNmtspqMT4ELFn5aR7lPoF9aTbeYYVba2j9egPyGixyjzZBXA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8aejr38u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 17:32:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5GTGBF014904;
	Wed, 5 Nov 2025 17:32:35 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nb1h22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 17:32:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DD2ONt8dEB03Bo7QNz59eL4ALKt+k7z8fv1rnUryFKZJR1tlpzCd2/EIoxIxee3PWgAloEAMQoZxE8m0HmIS2EnFZIlqwMYH2Bi3QHsmusKAozl6UN7VfNjDwhAfslkBs7hdmqFil+uGkAQ/p3rvjnvPTt6KKqOyjeTiiQETPvMdgxzmnxvM8uABIxj8VjxK7F9Zm61z2NFIw6WoeTCBqPlbOTlOX55AzkB5HGXNUI1k4KV+HCzAtUPpr/zb3M4dX6ScaFpEeHrEfUjSOByEetpsyvw1MvoWWacBgeHE/2/EX+vBC+cAdZYYJSJDDcQaM1EZfxsN51slyxbSkowuIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPwPlAhooBxzdgHN+WZeEBQomMfUmZE8vig9l8WZ2Do=;
 b=kBz/6Y3nBXFSS34yjHBHtIXu2xB58Mdd6VhpcFkFI9vwIMyqIFnRA0XM76Vd+sUEkPYKZQmYd7DdgKxui7FMB8XzBqsVTZZdpNU0Ds+7lkf1HZbZOMKpPDDGk3ycVdpOvsap1mSNVb3P81JbSUIRNP4SE00TnCJ4NXvpWX7r6O+B0jJ4rw+hRk+Tdgszp2kc5d+m8jp4NacwVLyL8JRTznI6G8GwLcCFezIGXJFZkKC7VXgcNFHfh+hLd+QsLvwgZrrQAK5c8j/smRCVvuE1lIcml63bBgNbMJpABzd1lBThbPh/YcmtkPQFN3JVRK5ajQYjURj9+AmHXoubRfyn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPwPlAhooBxzdgHN+WZeEBQomMfUmZE8vig9l8WZ2Do=;
 b=q/nTRDej7UqLONCnIoOnwdbs8h+GQY2EASdmbMw9rlsOfFH4+IE/fBXkAboU0x0cq50CLE9xldfe6AwinofLweJO9Gjyo9/Z/P4X0FMTULbTGDNKC1STgJf/4Opl5KQsrL13eBByrqeboEFSYvqtU3QLVUbSiSz3rhsfT5DrZ60=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5559.namprd10.prod.outlook.com (2603:10b6:806:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 17:32:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 17:32:31 +0000
Date: Wed, 5 Nov 2025 17:32:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gregory Price <gourry@gourry.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
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
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
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
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <03e363c3-638a-4017-99c2-b6668ca8d25a@lucifer.local>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
 <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
 <20251105172115.GQ1204670@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105172115.GQ1204670@ziepe.ca>
X-ClientProxiedBy: LO2P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::36) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5559:EE_
X-MS-Office365-Filtering-Correlation-Id: b7892467-7a30-4c1c-477b-08de1c914cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SEcUyJUQ95vhyMXqXr5LGqLOu2uG/uBB+BqIpYjwMF5PhgJJBiR30rw9AT7+?=
 =?us-ascii?Q?59ZBy9WHNE9xKSJrGxr2mqpzNDnKMxG/AWfH3nAfarcW/9wqFMD/tDN0T+P4?=
 =?us-ascii?Q?dfdGWqj0MW60Yb3/6VBPamfjHQdb9oseM9qlD6JtL2BMvuMBk9xfHV7LVvVE?=
 =?us-ascii?Q?rU52W8SWdfoQr3Apy70X37MBf4v1v7StNKmVC4aA3nr0IfXuLHODF2mG35KG?=
 =?us-ascii?Q?xlcg399D1h7EH2u2j5QhQ+4YxPVsKVfWREFCEP2LS83t9yZ4MnUwPRxIcclI?=
 =?us-ascii?Q?falCdu2dYPTz6zEgtIs/Nzmsl58SyXQ0rlf+3kfu3sdIjRA0WQBO+QugBH55?=
 =?us-ascii?Q?aBcNprA84Ow15gtg13CpqVuH5EJYSOYX1C6CcJ8tsZUhawwcYOG/VH+zq7nE?=
 =?us-ascii?Q?7ajh2DHICNwEu0r56J7jjpNfbiKl2Vl386mErnDwmDWX6QxZc0NVLpHhBypc?=
 =?us-ascii?Q?OxTU5kealvwjCgdB4kngUJFSuO3x0RRltY98tDhJ5x5Y24AO/U4MrCzbYOOv?=
 =?us-ascii?Q?C4yT+ooQSiBUHOJemdAJq2HVp4Hd4J/G+T8MNLfvsiuuAW1B4h7a7Cv9hRyX?=
 =?us-ascii?Q?nJCftgoXisA/lAx8Z1UdxzOvTRUqk304Jw+qYL+Uk4XgalkMs/bGvsActS1D?=
 =?us-ascii?Q?nhsqfQFPj3deuuHdeMhyUuApBhaTOIK7XFH5QgMD4LbGDAIalx7ZyS3KnA66?=
 =?us-ascii?Q?9zBE6HE4WJQ0BMgBLEXomnzyKe4EaSY16nTHG123ysE4YKyttY/aAacqjWgN?=
 =?us-ascii?Q?+FbVzdQTH8amvgl4AXLCd3uyO46L2nrKt/ehA5Z2DVbwUZ8VqEp5pmbIjoio?=
 =?us-ascii?Q?v4mpwlYufWWTmOLezL4FwdbrVjEO4CrP+DpSz3T1msm6QcGBaIalRgZR6uD/?=
 =?us-ascii?Q?sWH14Tri20CBz6wV4iYKhYafzUvtZbPRRYioTi7cCJG+k40Dylzbv9jXQKtO?=
 =?us-ascii?Q?8eOrpmFI/Rb392dcEcS897NgJ0C6We7cBahzuAIPtkN54hlCaij+9McY/+YY?=
 =?us-ascii?Q?+hhKnZTQQtcmMlpgJFMBhpQPQFLFiEGI5eSFGcQiMVdKpE5gYSQwmOpLfEHu?=
 =?us-ascii?Q?2wkXuPRobjc5sX9oq2N4pCFCzYIeoVHmVdmF+phrWw7cIpZHxcnI+sPxONSs?=
 =?us-ascii?Q?EpAhklBvmmUYQHVchDbgYatnOlozFgAbdMEEjmn3dSXSa1qaVrQono+SNniH?=
 =?us-ascii?Q?L9v99TJ2b+gxbhyW9nDa3JwWAgxVlOp04OBchM3OFWjhjDRjRS0lpuVpLrQn?=
 =?us-ascii?Q?NW47ueIsB4+pV0CSlGeXbVYKAXk5SAdPp1gnZM6rT/RxUYEjKi3YH3hWBvkc?=
 =?us-ascii?Q?qn7CqaY5L0NODhfVlVggMJflhtuXCBGG4XpAdZvUnqeEIBiq5UnhU5x0BzFC?=
 =?us-ascii?Q?5JUmZXepEyWMjR1Voe5mvWukacBB2yP9BIhxIun0P+Tqpw4AfO3fH4n18hCB?=
 =?us-ascii?Q?pdOMrBfwLMIucv++8L6scKYiTVYM20Ih?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cbtXPgh2f/o0IUXTdj3yAh1Xg8wdBNjptclNveqD/zFx38ANH6AUp+05qmFz?=
 =?us-ascii?Q?i1r/EA30NFI54/F7gL0yVFfqqcuk3nUesD3GrqwyOM1RrOldIZdQf9o4AkCq?=
 =?us-ascii?Q?kEE4e09XDV+5flhxNbkC0SXKmhSV8/vqJLfBT/dccyliOpfqGbS5fDDT1Brh?=
 =?us-ascii?Q?f0CkBz+FQ9MHbMyKFZSJmKy2MC/lKABUx8kSEGPfnz+OLBtia4AykZPc/2mU?=
 =?us-ascii?Q?9XLX7H2RvhgJVpm6yyZlxdyVV1BPSxWn04QKnhR/IWVV6gj/FnwuFUXZV0Mg?=
 =?us-ascii?Q?YUzNbOgpvVr1MAMh2uy36p19JJSSBg0uHpzOvgr7Bz0s/KsY4gCwFV5i7a1x?=
 =?us-ascii?Q?iyBlW+v01J/PgHSBucR72lSUOS295rpTEUsNlvo72KLuBN040P6spyapEkd2?=
 =?us-ascii?Q?8D5mnNqNy7j3r3Z7yAgmSuK5b9JRAk1E16a7gtP73AX+2aAknF+DMMTVXpYy?=
 =?us-ascii?Q?gzhSvlp3CA9tCQjGkMS73+ABSPXMDm9bYWuArkLe5LZt0fAi09PWt3Ponw8O?=
 =?us-ascii?Q?acc3oRbzRz02xPBm4ZcL2pbSIDqZ+nF62FmMGTRsw659k0aYoIcUgQ3y5Zj9?=
 =?us-ascii?Q?E6RLEnCNx5wIr+LThYylmwSfZRM5VodVBpEiPvl3VN84aFLd7wOgMAXTJXWf?=
 =?us-ascii?Q?cgxeDfVHNtccm24/XT9Biph7EYnx+q+wBqwm9qCzzwCbnn8ojYM/TE/mGkB7?=
 =?us-ascii?Q?Arul+VqNmrG39eBynFPZZgjd7szXFnE0ZieeLBOITcQInInT+un6QJqhVb4w?=
 =?us-ascii?Q?iWqH45EwaAwzSErnFjEj45TjK4dKIv0seu0SBpN0f5jJD3sWLak2t3tIl6V1?=
 =?us-ascii?Q?6/n/h1mNgYwWiI7EPx0L+vpKZ2OwVWbuFb+T4j7HhGcOBNKpbwIdWTG7dmY6?=
 =?us-ascii?Q?Mw21aHP0PAee/FAkvNDXLXMcOurnXRqtlm6nBVZvLortlXax+wmKZa8xWwu1?=
 =?us-ascii?Q?m7V77SlW1J9ALzc6ppDzHR5L8BVl+2nuL5fBxalF3AeG3KiUC8Ymoe3zsip2?=
 =?us-ascii?Q?qGfBR4Qc0v7/onYg2V/lmokcj/jPzPyiq6vdjPNHRlSc+YTjX4+dMhtUP34N?=
 =?us-ascii?Q?LSv1nvVhTWCuXOpSPSqn6DHTod/cC0KrHZQIGhNvwO8UFqtXq7pvr/okATMe?=
 =?us-ascii?Q?qbfZbiwRxvue6b4UOcZKvTy+9qwOEMxnY62HHn5syDX0UuPZdEnSWBmGPeHR?=
 =?us-ascii?Q?RIV6ET+6or/QjFQoyiiswQKBnZaPzZDV7tOdZxUP1Pj/Qzmwndlf43ujx1rt?=
 =?us-ascii?Q?p20xpMtpIiFviGqs/eeADoxslwmXVOIJ2UC6TrJLJkqFfgFRbqFIEk43mH/3?=
 =?us-ascii?Q?yHpG+tgQmVPewHrVpPqk9DYmvpKf5QDFgcbIxbmlQHxRuhDo54L3hxtqvZ4f?=
 =?us-ascii?Q?T/KWfuC/67vRLsXmzApeh7WCEZXXoiIYoE9YjdOhFy859iL1CUFeVuTqUahQ?=
 =?us-ascii?Q?4sbPoDZp1tT2ISypbk7rDVQViBza3Z0XP1p7jHQ0HO31lDKQq7qOQKqVCncT?=
 =?us-ascii?Q?kELT6gMZ5OgpZf31OVNFaDiznErJfxG7InovKzFRmQcqYBc8ASt9UjCYa6OV?=
 =?us-ascii?Q?WWmKomwAb9V54vh0zVnSoQyRTu01unANV3d7crgYROLRls5oP8TlrM7Dze+u?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	haXM1EXVzRaYRBH940YJ7X/xW4YugO71RtHkjznAav4vD8NP+IHbF/jHnnwumQy0cgndVznXidzEZqWCRG5z1w1Lw4myUshJ5Gex6LL/EU+S0NYxzZtr39yFvaF+kIhTIPOPtEuaPM32DcAi0edeW/684dzuKJZzwju00C7M1fpo5fzHcnFMxp3LIN17Lpz6iYBs018kN79cYxhOFvZLMbP6sAdx9kGSwsQiaDG0gXC45pWgzp0gXkylawmnqhCIbyUbveUBeTubw7wTIKF0T5Gul9QBHFTKsJzrqfRHCDp3m88+caEyEv1Yhf9w2fRqgDNdIZ5XlptVHiwuVZDBmKo6X4cnwU2jhs5CzBxqikpZzvgjX2Fw1j1KzaE/TlGFl66bwsYvLh+VvE5gY+RWH/yClG8liBdypT0+mbRQxzr0Mmv46VazEIFc1+eF2Yh43TquXSHbU76p6kLjhq2B13hCquPz9Z9slICMHusecsQgoq34FyxV3aOlGRNZXuaBh/MKV4weh9Tm92eD77vbbl7SIGMY0/sgBfWIdMIUgG423dg/phklYdRibv/p94jqkDe715dMfgt6QmE/AV6DIL0heuLGLYztvONHzeMCKFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7892467-7a30-4c1c-477b-08de1c914cbd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 17:32:31.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPJAWndIijrDRKlpFrEBUbJ+oOXsbzypyBq9xr+/xJLkY3jh1qe4N3zIGWyVdv8mFJImjTFYjF6Lg+kBpyVe+xaOgn/cm3snSF1vcuPwslA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=898 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMCBTYWx0ZWRfXwBM7fUtJtd8l
 PLQQLaJQBBjtdqnc7bzhQ8QqiGk8XCvPdIxV0VcozNBti/b+DGImTflaCkbQyyx1St5BTdRqEhj
 +LKMmshXv+YeAZ5CLxQ9bNywcclVezOqgGY1T26cG24DbPbpGs+BCKgQP5QU4eY5DeMdXd1WjAa
 3jqvGjmHVgHqeUAiHuVmVrLPZfkOKo1ku+Aw9dEP+6zo3FRPILKiAsIXJCIS5spqGq20b0ZQBBh
 dHIr9Nn9vB86ulgcXQBmwPODLBYuXqne1hIXqV0Se0QI8Nv+JTiI3d3YO94RmBXI402vMtz0SK+
 271WRGOgIACTb0TK4EZOBMsgyGuJ71Ei1SNrlXnGvmu6mLB+5q79fDWWZ7O3CxdSKGVCzaLFi6C
 BqJkes2nbMUfv5LfcGW0Zo7p2a52FQ==
X-Authority-Analysis: v=2.4 cv=R8IO2NRX c=1 sm=1 tr=0 ts=690b8a34 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RKclntdzt82Z76TGzbsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: M4-1twG71yTGpoIPYZppQWhlOOKsJtZr
X-Proofpoint-GUID: M4-1twG71yTGpoIPYZppQWhlOOKsJtZr
X-Stat-Signature: b7wbpriikonyceegw1kwq7uu59xkm6g6
X-Rspam-User: 
X-Rspamd-Queue-Id: E073A4000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762364038-345605
X-HE-Meta: U2FsdGVkX1/pIZWic13cFFlRoxdocmLYNBCl9alMQUP5QJiSvMH/fV9nSKQ+vxmqYEhbltYIK91KPan21NfKOiC5/KFLkDuhAbG4j+0yo7OjhYS2mGwNm/F4I0kwzBQ/jSF/liZBIPC5y2VVjYJDxyCORhSIcyJ/9qOb8MB0c7qLSvgl+KWy/u2NSwfYYmbuoRRYQzpxSgXCw1jcBNiLBhlMJg+1wploYAKcA9JrTdD+gCCGN3+o4DRkQyghvugBWWnhR+TYVmuNEMB5x9GxMA+QxfZF5xZiHfm5NubjeoEZM7XCAJskq/GEaIP7DrVoBTcza2XFcF6V9CfFQcX0z5THVDRixd7f8v7P9y6Khx5thSmEKRoIltwrmSKBFc54529MwrFmmRbgxbSMtBRWUNaCPv89CSN7n8FLEZCbzgOzRnOYrMXaAPkWbWY8KclIAXurQED/qTOmDkQX84y+ic0bZdBAnj9XGbO7IdFYTCY3t7R7hfNNuEdP4q+QRaKvcnT6uuKOrdDE3xJ1CubfDw8DNo+f/tg/ddfUg6LFFqF+oi93GjsAYarQAj75cBA+ExWzvkB+tFVd4rWt9w1j2l0+He3sGI0m4tH+aXLszcyftr8anUYEl1EJZ4hJB3FMCQKmJkHLTwNhgS6PiqocggVGcjVqT0mVzmPjFZShcAsixi/4gIEuD5rMrXLFsxPb9koGKFstN0WI8RxzXsmNJ2VJcI4+HpurPhYzwiq9PAI5TFp9+DdYty03P4OMMdMHPTAIT5AVfhINNA2RcyMuJXjhLsD8EpDgPqS11iMK6wlD8w10Sk4ImRqtWAQRsbcp/+Cxe6Ywfg0KZznJt8lhfX4QLZh2UdlOjaelCAQ+SyKoBxg6zAGggeOAK3X0hQTSiodDILGBFpNPfyz0SHYJZ5FlY9ApNBLWvsdHZHkM85OvqzIpJSuiSyA4LXxPaQnEX0s9uewCe8Is1LCy+Bl
 02kTBTrd
 B/bg/43At6fxiBSVV4WHmbSbLDtqC+OCIoQowOuUG1HUfvXZjOTrfrs65qBiqXy/Zn40QWIR+RTk+GeWE4CoKrIP3B/e0Rvob9wPFbiRSIpr1wQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 01:21:15PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 05, 2025 at 09:42:24AM -0500, Gregory Price wrote:
> > On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> > > +typedef swp_entry_t leaf_entry_t;
> > > +
> > > +#ifdef CONFIG_MMU
> > > +
> > > +/* Temporary until swp_entry_t eliminated. */
> > > +#define LEAF_TYPE_SHIFT SWP_TYPE_SHIFT
> > > +
> > > +enum leaf_entry_type {
> > > +	/* Fundamental types. */
> > > +	LEAFENT_NONE,
> > > +	LEAFENT_SWAP,
> > > +	/* Migration types. */
> > > +	LEAFENT_MIGRATION_READ,
> > > +	LEAFENT_MIGRATION_READ_EXCLUSIVE,
> > > +	LEAFENT_MIGRATION_WRITE,
> > > +	/* Device types. */
> > > +	LEAFENT_DEVICE_PRIVATE_READ,
> > > +	LEAFENT_DEVICE_PRIVATE_WRITE,
> > > +	LEAFENT_DEVICE_EXCLUSIVE,
> > > +	/* H/W posion types. */
> > > +	LEAFENT_HWPOISON,
> > > +	/* Marker types. */
> > > +	LEAFENT_MARKER,
> > > +};
> > > +
> >
> > Have been browsing the patch set again, will get around a deeper review,
> > but just wanted to say this is a thing of beauty :]
>
> +1 I thought the same thing. So much clearer what is going on here,
> and I didn't realize we had so many types already..
>
> Jason

Thank you both guys much appreciated :)

Obviously heavily influenced by your great feedback, but I really did try to
build it in a way that tried to simplify as much as possible.

Cheers, Lorenzo

