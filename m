Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA42CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD0D8E001D; Mon,  8 Sep 2025 07:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384938E0019; Mon,  8 Sep 2025 07:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B068E001D; Mon,  8 Sep 2025 07:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F06618E0019
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:12:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA3101DF68C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:12:23 +0000 (UTC)
X-FDA: 83865819366.03.837703A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C6F4140008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:12:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="nS4/dgSm";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Pai6d2wD;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757329940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+bpbz/XEdoOaD7LAAFqLvV2lRa6jeLRy5YT4ab+R0c=;
	b=mJudZoWYjBOxVdi8mO2j2/8TUK8ok7u4WK1pJH+ZUhC4So63yjMzMMNE6KDaPxDo1LGt5V
	Ga509jW2PwEvFy9Y6b9A0UT5MFLikh3xNRhm7UC2qWPVP6F2CIb6wHt9Ea+aEMCtyBcZLc
	9qusIWLK3eqOnlpqJAenkWP62YC1P8U=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="nS4/dgSm";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Pai6d2wD;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757329940; a=rsa-sha256;
	cv=pass;
	b=YKWkIZcAYiKLA+u+kKf1QBf1OwRMTqVLqynNm9lT/EX9G4ec6uN9NXm1xOnaeAsaVQEmEx
	7tRPvPBOnZtoh9T6JdtGxoI/MfyIpfZ2LdWshNxhoti+H47fA+PiWjNY2W6LZKXZ399gKX
	xWG1Q0wFK4U8qiChfIYggnH6dZgZ56s=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588AAtRC006140;
	Mon, 8 Sep 2025 11:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D+bpbz/XEdoOaD7LAAFqLvV2lRa6jeLRy5YT4ab+R0c=; b=
	nS4/dgSmJ9phkEQJQ0zvw+kVfjuFIT/sM0DipKa+A+GCVvbBDNe+7JUEOZ81jEf/
	Fg1VBVYrThgijajxgvXUQRqkolc4iPDGckfENG5CoLM/s98Liqv9JKEqwOe1a8LK
	ZHwYvihY/+YILyZJdiseAE5mX1zZLCRyU9sZyY/yBxkf0pfGTOqeO6PXPLHu+xU7
	1gI3C3U40N21fBvlpqXI+DeTkNLmRc30Vmg9kpGMKqMcQRwHczi0X3XACfWjhooj
	6EincTNC7jWTA+Xi2WSMTd7XbMTgMiWFqrU0RfaESMSGci/0KDFs5+OjNng4q5d4
	EWbQPVwYA0NIxGptQrxocg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491w5402xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:12:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588AV27M002883;
	Mon, 8 Sep 2025 11:12:00 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdej0pt-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkhVU5Jv21tzlvyDNuWRXXqt3a6DIIXgLzIYvo40iJ8wEoVuv/gLpdpX6aYBAslxTeB9ERkz2FQnVyElcCEwT5EfsDikKHnvrpiAXLYluQ+/udZPbFiQAm4HTxXm6+lc0HSlso9hqaEoWA5H5NlsHiPY/8zi775NmWfhiXPIo7c7sjwX0izjY/sBa6z1ajO4K70aw/WnJ1EmflqHbEw+/OE911XtP5YuEHkPenrX0YCZ9AwJaCrOl+iCWiTmZ78Ymp1NETOEJ+AaCdAdINAjT4Knn9o5jIju4k1AA+BIsstUPkndfjKwQ7O970pE4b8hsCZShBA865DxX+GGdSwO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+bpbz/XEdoOaD7LAAFqLvV2lRa6jeLRy5YT4ab+R0c=;
 b=oxcJxcCpD08AUgS7aB081NYsj7n+z99pQmjehxp45olEUUvPXySk2fJBmudBCJEx9q3ZiSbGO4+0uRfsLZvrCGBA1amlb3eIlb2KiPQgZ7BZ37sCdVvtaNV5hNrT0Sflo1wioSVz4EA+jB3LMyF96kMxg+lePyayytuvh16j8L1rMUHZgT0U3oP+ndMNSw27U5zPJYUCx1ZMfdFlXJhHndR8frYaSWH2jDUvwLOpLdMB7y3CizcXFyc8j+v+0kKrZ/FGGwli4solfx3ZrfFyc99oTbHZrYUorfPeHtxS5DWs/qDntPwBEwBck9MHKfJZ10IYagqzwUF5herwPhZwnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+bpbz/XEdoOaD7LAAFqLvV2lRa6jeLRy5YT4ab+R0c=;
 b=Pai6d2wDXziDWB2yncVYGJjKZLeoAq4Fr+Qk23G01f+pTMul8mEFMRzGwYfjIBPsnKr4uAtN+zyelFmnAjwEpekE+gX0gB8Y6l72V7mPMFmwccVIiGUP36IqHs0bcNXYhjsWel3TQaxV6ZOcux7NYfIiCw73+LpQXw9+80LwZMk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6588.namprd10.prod.outlook.com (2603:10b6:930:57::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 11:11:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 11:11:54 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
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
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 14/16] fs/proc: add proc_mmap_[prepare, complete] hooks for procfs
Date: Mon,  8 Sep 2025 12:10:45 +0100
Message-ID: <81d1c8ba935dffa6f0a82a5a5ecab6e80f90e6c0.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0032.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 899f12fc-cf09-4d60-18b7-08ddeec88467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XZ30NbbafGroP4mhBMd7BB93CREFdQ9dafNxNkS1l2a8KQ5SAfUTPISP6Eqy?=
 =?us-ascii?Q?vGhXGHD3VCVtpqKBc9jluW9SzDpROYPg+puVTZB6JR2g8KjU+lb3UA8t8UML?=
 =?us-ascii?Q?B/n7ZQDetbQvg71ouRHhpZHJKwQ5I+KMVuPjZM/Nr0KHyfLkt3q9ABC/mMoB?=
 =?us-ascii?Q?tFomjBdiV2Jf7gjtpEvgHmqdKn1N/mGQmRksK4aOnJHqEEW5Ro0pa/TJ+gys?=
 =?us-ascii?Q?Tpi8lvPEdcCMihw3tuH9NWQbzBJ4Gw3QpdieeO3sg1iy6l2RNLKiUdA2QFM/?=
 =?us-ascii?Q?rHPc0XbirkHwf0oEkk7pnoJVqq3MsaEy3D3f3mEzhlziBtvBF/rpR3EvH+Vb?=
 =?us-ascii?Q?hd7KkJMjEfm/JcUi8DJIzD/RigXVchyBt4//2ajfpJWU3zpqJjuvp2galm8j?=
 =?us-ascii?Q?dm+r2y6KNc9RxeStLWZHhNIzExrd9/1mC67NhdXBDfudXKKF0QSO8ydE4nS5?=
 =?us-ascii?Q?ujS79gouXOzwOPFseRiK/eSRWgbFzjKgm+R4WtInTaBEVQL6Y1eWIFpA7dYw?=
 =?us-ascii?Q?xjl8itvlXnAgwr4rh1obCCrHmzBKLxadYYK3n1Hs69udFMgB+U7wibJHtMUI?=
 =?us-ascii?Q?pldhuP9z+kCSircuL/ExDDG3jQDD8l+34iQMs2x2uEheuGocg4Y6KwP5ARQ3?=
 =?us-ascii?Q?I9SD65UYw8HQuSsJjmu+1gaB/LnKOx9hKUhJWViMaD9JmHo0ZU4B0UwIKjB4?=
 =?us-ascii?Q?UUDh84l+G1UgYn5upCqX4JvkOOBQ+kiGnTXilvjCVxuS4CiBqdAOXq/CaIFm?=
 =?us-ascii?Q?KHt6C5R1NqJHih0GO4rUa8AzHbY9yn81IuxGdhWXbBkNgP87ti9S8OCE1K3l?=
 =?us-ascii?Q?rkrnoAVYyh9y1kqXYPWdtOUOniTe01//yP6NXX7QU125iqhqIH1IG/Q9vyDT?=
 =?us-ascii?Q?l6X5Iq5cUruddw7WA39KRIuXJYKcKljK7ucfK2c5DRRF85TcXAiApM0ENuRK?=
 =?us-ascii?Q?9pGukzz23HVF6pBlMCW4jorzLrWv7JSY4KDg4Mp9iKT2r6GSSl+ZPKOXF8tg?=
 =?us-ascii?Q?+13PtGBnFeb5He0Qr0ljqeuispXC7LAn6UjiIy/XL5sGbqlKj7I46dGlUduo?=
 =?us-ascii?Q?P/ig6845iexA2ABFvfmX4WEhq9MGQGn2xgxs8yZUx+fM6K9nOSmlDJmPeVWa?=
 =?us-ascii?Q?SU+PIdEGnpBtozQtuv4jECXFZzcsIxy9hBq4t91k01T0pHJe1U093QYbnGD6?=
 =?us-ascii?Q?NVvigGX5oA3i1bXPVb+BxHMXUphXTT3OrgP0HCgSxY5TysGDkyMh5tgjLhFm?=
 =?us-ascii?Q?h1iLzQisZ8oAEShgwn3rESm9A35foftyGJMHozBp52Cs97Qs8siR1JuEanCK?=
 =?us-ascii?Q?9t7U7okue2CGqRSjm+bti+N/4ajHfEPpEAA4NguxYafgaeFpjpPUha5GZ3LI?=
 =?us-ascii?Q?I3i5ilCqdQc2oic5QmD+Xd05ST+nXlj9te6MuZKsIBkOuKeoLk3hybyAyZ4n?=
 =?us-ascii?Q?JPJZYeRs7so=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZrVBvfjed+t/wJSQ6vtDZLXDpptcD4TwJ71wHqy4pHsGa7D4yUYot+CtPr/9?=
 =?us-ascii?Q?tdUCOIpHBP4y1RlCGceSQuZ7oDD7gpSmklsBFjp0iV6IJ8owAmmcX7i68Z3+?=
 =?us-ascii?Q?jq38aIWADUlJ4f6bOX09AGAWPBUmxXvNaqi5Q7m/MdCpHmCK453dFz1QkAUC?=
 =?us-ascii?Q?1gImaDrxoDUpvEDfJJuyLBkzZVanXwxThG71TUFkwYYNzElbKLftBDEVo0mT?=
 =?us-ascii?Q?PhOpBLYuQatlsZne54roGeBqakP6/2uRfWs2XlvtsoEsG4yqT+SqTXZALXsV?=
 =?us-ascii?Q?zGWmXIk1umDQxAEy2MAwj1PnIbS/4M2yGfSXUn7o38z/sz23llxzi9vpGDPi?=
 =?us-ascii?Q?Fb5Li4jFIKFNJvMqOCD5Xz/VVoVYT+4vGWDGozc9OhULIW2yt+il9RvcRC5n?=
 =?us-ascii?Q?RTVm4Bs1YnOfHDzzZ7z32zKSnplNZ4CpZWK0ei3iNcUcNAxguQq+kXgXMBDJ?=
 =?us-ascii?Q?zEVVKiQjY77dZVApzBDFVRuAfdvHYP3fmUt7BDCa/AKte60Ju3HoaCMMRK7o?=
 =?us-ascii?Q?WCAAV4UANi5aDFQkSkPffeREBNzOoRK0I1tj7C71QVRnCXFVDaaOR6Tr+5P4?=
 =?us-ascii?Q?8wMfgFz0e7NKDQu78AzelVBeNRvtjxuKcf8AlHb4A1bpAhxO7Dd9Opb1MUiA?=
 =?us-ascii?Q?BEj4rEGvtMbqdzj1cFSA0tOWh9SSuKsPjtjT5KKW12VFmiR0LowR5lsPNxr0?=
 =?us-ascii?Q?ZnoiNK/71RFkMFI0Yn4jsX6nnEgOcnoT0uYoMZy7ZynF1nNwlCr3ODaUTQJP?=
 =?us-ascii?Q?GEylTF1ywLRkRQjLjjyyDXI/fbpASI6pIunGaElc8WY/cpixuhCNygWvi92m?=
 =?us-ascii?Q?Rw+9qbLEB565k7JYaSEZSrh/yw7/vQhl1MpMS8GSrShe9IsXXeyrhxyZZR17?=
 =?us-ascii?Q?dDpNwCZBfrA7dGbq5fHwNwwqKEM7CVruwHO71nB3SGekalukfG1r+M04a3jl?=
 =?us-ascii?Q?EG9gaeBPZQRQHXIhfsRnA7SCA3pgqYijQHAzo1+IhfE+PAQSbHzBBgOWWjAz?=
 =?us-ascii?Q?x2IRR7/iAZmWhZ9LDSy8N0wvBcgcfqY/nv+gABFIST6I5xp6S/6HC8e/LAqT?=
 =?us-ascii?Q?hZD9ZYoKtKdrW+4cwh3BG8W3tRjnPYpoWhwSmL/26zDRndxT5/s6FfFey86C?=
 =?us-ascii?Q?otVthygJIDMYJausGWUwVzKEdUue3+YONc+4fGUgBlfBNbgaiHLmGpWRYDQ5?=
 =?us-ascii?Q?njM8Dfi0/8tkuGMhwoVOQ2Ih+FsxOULog+vgHiy00BktIa1kvKqsYPcgU30B?=
 =?us-ascii?Q?zwqr6g9WaK/ZHQK3BNdcGaVlGo5Y9GYGRsg3/LjrnNyxqae2hGl2eBZUgN3Q?=
 =?us-ascii?Q?Ths74w1js2xX9++PMquqM7I44BAida34200sZxuzK03sxMRC5W+2lSgAe4vW?=
 =?us-ascii?Q?Wt7M2qZYkmwPactiSOZcrsQ6/oFV798Ep5OUmfWuhDy1QNomVgNfL3b9MC9Q?=
 =?us-ascii?Q?OilG7GDxLOOgocu8PqfQRVSE3vJpZhL94G865Zn8BWF7nfXnsPMqecHdoWC3?=
 =?us-ascii?Q?yNn2Lv+vsr1+K4Z3BUggZsVlH7LJaefLX8QVlBdGo3JcbTQOy94Q2K+GtqMc?=
 =?us-ascii?Q?OlK/0wLW07ImjckHlX/LM2zAJtn/yKFvVI5r4GiVkP4RUCst/cTsYtt4pCAv?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VgULIEbYXUJne80QErnAPLxdNl1wPJVc4xzLYnZQquIlp7CoCB3PuqiRbj0MZUPw2KBDoRWg8gmCXJ99xNWMFRgjoQn91xAqa7N1VbLuLvuUdlpS8RUEc6/TnaGr/hV3MYtMXqGX+FqkwlSh+K8fHsfwd/UCP08/pFurua2vUV88N935tD0KbwhVNr6a4eCoM1FkOmzCO3xPEGyCvfvqvnQwXec0JiU0UDHDbhHoQw5PqCnOFUoz90eQvwTYmNvS+fkQV47Jq8KWjlg55wVKKDR0IrqwW7QfbybUPWlrqbjTEk0m3TTEFWQV8pZ+fyNUiTCKI59FfRetLek92KAebrkGIymsi0i/ESlnah6t+Vcgoz7a4cbXFFBHNx+X6fZnxcwGzwkhPZZd9epnm+WgKUs5dPGYTDNPUyrNGQRZgno/AgzUI2IVpfWtheWb0dNwTR+zllCzfPDpN7Xag1us78aqACC1qhWgO9cXys299TC3bMT55qvZY3Hlzhe7RSk09NREhO6pCE04WS4daX0pUGmVSXDqU5Tb3i0tG0xPgw6Qt/abaWOHxN4bwKTlG8R5OWiMmZFN/ecGDB7hKgjT/xAX2jnHr/OjvSMvTaBi1Ok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 899f12fc-cf09-4d60-18b7-08ddeec88467
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 11:11:54.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BJ9agbVsjr2ieAvOd77ssaKPp7TcbPODqxvX+/tbrXE1iLProwCCdEMSvLrlB1zcOHglvahaR1SGI7eK7SnGAHFYnC3jMQz1uAGj90HkOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080113
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68beba02 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-GIxZWhuOg30-HT1v9gA:9 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: r0nroLL-q_QDpQPDbGD_YPcSiOcqKRmg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDEwMyBTYWx0ZWRfXxcVdzVUvsLiT
 HanA/yCV0k/w7k1II9LbdRwafr99qxtRmmaq20EMKyc+Kx7xNJzB+LF6kVoeKXEtCaZpjxZt3Cq
 n5dJ2+LsimibYPC+DyqV0WuHrXCbFuyCgcfW6Yfob2b+Bj8R9cJBwTKzv9/sUaY/EN8u0Fqbfnp
 gf4gS6usjvQfUxOn0T85BT+6pL5HuJ2QnBmGUwi/9mZmxSIBPfPTAqDgjXerr4IleAEVpf0QAG1
 msFa6gZaW+1uC2eiPAzrj+Iakyr58vVf0pZdwADfCIOWOaPWHIPQbC4C2Oh6FWDqhPNKktAlp2c
 d203JzXSZNI/IE9TdcHV7rrDsvX9hp9F4j5LLP0dF2/40JCtFUM7Dh9y1DIBM1wUccy8gKHWQAH
 s9pyceSuP0NYpzZQnQouTdGkbRousg==
X-Proofpoint-ORIG-GUID: r0nroLL-q_QDpQPDbGD_YPcSiOcqKRmg
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3C6F4140008
X-Stat-Signature: ijp7ru9cfqix81uj79u4kftm48w3g6ca
X-Rspam-User: 
X-HE-Tag: 1757329940-311238
X-HE-Meta: U2FsdGVkX1+nUDkDQpoN+GSFp223FHafJVcjs4bBt1KG3V8KXtez/I+kcAQIXc5E9w9IkJmRxqIh0vPz0WQ7FsWH9qe4StCFTz/7iXbryWho2dZR5FMHOoqOpIWIe6M1E3OyJf4U1Utsjf+iD3DxJsWwq0IKWLLvo1dIcUISFqKH3kr4zD3C/0AYrDs7SAFPMeNsV1vOFuLrdKlJZZJA0Hm0cydql6MTx1qFgozYQ0rAr6hp1Uwj1j1eiUGrMiUexnaYxhb56aI34l2QEDWGg0ekIx9TSVSxIJqapfpWHIOz5yFwEq3zYWlxhhbagMWGHSJVU/Sp7u0STRaUuTD3wmx4qiBclhxVOsz9tWAa38lEbAEY2dVX7qQXIrD29QtfAHrYqBi2wrB6rNLyy8c3jLyi8HJiJQyH4mnqSt2NwleYwxTA8uaWqq+ZXuRQLu3B9/TbRtSKjDSkoDjw5rK+9iXQV2Awybhsf11chs53ynXqBxnGRaJ8r5AiEbi/mfo9QfEpBe3kS45KgBtWwZDzd3hEnIdoCqbypY4c17lKAPQLPn5aC6DDsE0ItbNb/9uRikGNBYP3wd40NYn7Cs/gIRz1sDGznELa8OsFI3+AJPSB1utD4ARG9qfBtml3S3z6dLvHtsx8RwNEg1aNX9Jlmked+79I3EWZBXb9cI6ZFTBAHwMuwcgZrOvI+x9OsSWydFXcEiuJoxJvNfRxeldueSUrnIYXGiUGRe9m8VRgS1BIKhsTRXF8GabKzRolHTLGg2Nh7yJVOQIJDi9DSLNV27fzjMaGq9P8gk+VQUS1TLidLvXGOC+s2A8+8d1jWDoUECC0TY8bOx8ca9Oih7WHHhjostQ78uvcZwI9Upq6JcC1pPEAE4ERFY0mYwc3BXL0Qe+Z0yMCWcwrwNu9T6TolJ8+FvxGcT6rcgxnhspkbEbejjzWWytrtU9QZIT7Td+a3By9JeFd1TnuY3Oqjpb
 e82GDQ3C
 uGxNEGYFQQfRFP81sf5nNTrkHhOdwsurAtC6MqThl+xwep6j93oAESCQEZNt39/QKCijjvAR1hGsmcSkCKkuKxOjZYFDZo5Dk/u+vrd7NgjjV5bnpyi2nQuQRvr39B2LgUmrhFNw0Vg5EmmzNud/w8ka33WI+Qx74V3pzEBjudKNrc5CHxDrjMCnqh+f2HoaqGtHva/yqcnQ8psVJrzCF8Kd5z/VT8YXCDe2cr9Gs6OVZsr69vsyMSm/2YT8N+3uUYbGwCCox4L3n0BovjmzTeyJYkGvrFdKKz9thOCHNNWI7qLYOWCoLifulNZa3agX617WuVrwHGbueqO0uvIijKYrJWJ680IRA5UUGu761zOjx8/MVUp5v6WKy+UADYFayIFYVXBq8CtkWDtsoSup1xTqAYVEu7l7U1EbZm9KEV9uBUw6PRYodkkiybfAr4QwSJ+WVOz1oZFOI6NAnZWo25CjQeL3D9ohBZk0NaWJZd994aF7Bs7FRv0n+0wrUohxFzDSItXHv1aTI8Zjc5YVjtXvoNVgJSgrACbGYLpqA8r1dBnfDYpw9LXswUbJe+guZh4XN5o1tzVetMdXPNCP2AQHn2DvGxAfg8F/vgFTl/v2EJROMsAPpGxhzOBpifAXzFkt8CqJ556iOjxQf5cZ4bdjUnHAveifvD4hNAl42T+pjx9qh8kaoC6Vrbow8Wd3iLIYC0PS/vWlJSfXJEMaSq12ueqrF3JHLsTVKDGNReyoyGoe4NuligxOPynloKtXrTLODJyWcyjVw3/eryLlh8o+ZXmDhjNSdO4mneOiigH7pCTNMm52PZoE4VR3skLRgRfEYihWSVlVSLG44IG/SG8c+yLfOwIr8wiSS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By adding these hooks we enable procfs implementations to be able to use
the .mmap_prepare, .mmap_complete hooks rather than the deprecated .mmap
hook.

We treat this as if it were any other nested mmap hook and utilise the
.mmap_prepare compatibility layer if necessary.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 fs/proc/inode.c         | 13 ++++++++++---
 include/linux/proc_fs.h |  5 +++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 129490151be1..d031267e2e4a 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -414,9 +414,16 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 
 static int pde_mmap(struct proc_dir_entry *pde, struct file *file, struct vm_area_struct *vma)
 {
-	__auto_type mmap = pde->proc_ops->proc_mmap;
-	if (mmap)
-		return mmap(file, vma);
+	const struct file_operations f_op = {
+		.mmap = pde->proc_ops->proc_mmap,
+		.mmap_prepare = pde->proc_ops->proc_mmap_prepare,
+		.mmap_complete = pde->proc_ops->proc_mmap_complete,
+	};
+
+	if (f_op.mmap)
+		return f_op.mmap(file, vma);
+	else if (f_op.mmap_prepare)
+		return __compat_vma_mmap_prepare(&f_op, file, vma);
 	return -EIO;
 }
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index f139377f4b31..3573192f813d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -47,6 +47,11 @@ struct proc_ops {
 	long	(*proc_compat_ioctl)(struct file *, unsigned int, unsigned long);
 #endif
 	int	(*proc_mmap)(struct file *, struct vm_area_struct *);
+	int	(*proc_mmap_prepare)(struct vm_area_desc *);
+	int	(*proc_mmap_complete)(struct file *, struct vm_area_struct *,
+				      const void *context);
+	void	(*proc_mmap_abort)(const struct file *, const void *vm_private_data,
+				   const void *context);
 	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 } __randomize_layout;
 
-- 
2.51.0


