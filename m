Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98DA1CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7E28E0016; Tue, 16 Sep 2025 12:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98318E0001; Tue, 16 Sep 2025 12:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38898E0016; Tue, 16 Sep 2025 12:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB958E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:24:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B453855ED
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:24:01 +0000 (UTC)
X-FDA: 83895635082.15.B942B14
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id C0768100009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:23:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IyUaYU64;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nQ6+JRsh;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758039838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjLMUHSs1uKS5u33xOILwewX43qpHNn4XxpppHrHz10=;
	b=5BSYJmqEctnVKm79du27WXWiw/PvgRAds/c3f9f7nQ5fQ2Kj+fLBwU/6LwXtZ/j8Oquy/x
	Pp1R4ve5bjOvXYMjoHdGVZgt1f4xo6SSJOoxYUkPkq6YsOER4iG+gvwRycj9MmDHfnr2Ko
	NxNekrzQJAj5yS7GRgvDN9Mx0tCrR3g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758039838; a=rsa-sha256;
	cv=pass;
	b=gVihM57VUKiIrU2zULlXwVxOb49EDM6tRFYxd2KOABmlwtAOa2dN4zKfLYt0l1sQcy+bDH
	wL2mCml7iCQqepN7VdIZJgQ6e2os9K4FR8i0UpYweuTgQerJWY2vHm5tDUg230SRgYfv2Z
	PrLpMhd4kaFW+mYQoMWeEwUdIKbT7OU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IyUaYU64;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nQ6+JRsh;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGNIDC025423;
	Tue, 16 Sep 2025 16:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wjLMUHSs1uKS5u33xO
	ILwewX43qpHNn4XxpppHrHz10=; b=IyUaYU64GjvYrNbXTZptmpMPm+RSrJipSX
	WD/ayWnagvluNQR9GLTB5tknQxn/aejOQJJayxUt9Z7yRAxYJVI6uZwh6BkoWCWC
	901wN9Zxb6wVcTmUDVixNmCp3/wDChYLJkhXV1GBjEoS10+8d/L2WE2vFkv/wgob
	oN0Yb2jZQQ81G2SgTViJ9pE8I6Jv1ggjObEcKBdMyoaC1mE8lveL6lsPogGxFpPn
	Qom/hDBa+OLnNU6ersdDB8xS3YzmtFJR7HJX6uTLNDmhuo5TjGqYfNnHXuVpHU1a
	XE3agXCfKFn0MaG8cA4XOV/Bl5H5ffo+kL2eRbnrWnaoaJv7pEIA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v507b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:23:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58GFS58B001468;
	Tue, 16 Sep 2025 16:23:37 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012034.outbound.protection.outlook.com [52.101.48.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2cv4a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:23:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2FVy4H7NfiWj6j2oDXl9MwhYTRVced9o4eSlVGUJVe9PgfOasECdan48gHVKWi5KVC9D8+kOKNDqIIFUlGs4vboDXRvfQ3QIcqABXwFMXgJ1P5p1tedET5M0gfAg0raa9MrbcQDFgi8Wdxsg+MYbhWOhd8iTxDl0Bv8gKZf4aLnlF0VXvcyAgmfRSEG77lyxF6GqKYud1k/IZ0EyFKvspP4mhc01usUEY3Bohn6Nr+QxCv/goEd1Urt63NoCuH7fwL2KG81BTviCGrU3Iw4w3Mnz80YoHa7KtWaF0FDvCAf4Qxem+16PHyHS0rMtPonhQ/iPltB7dy5cc/f8erejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjLMUHSs1uKS5u33xOILwewX43qpHNn4XxpppHrHz10=;
 b=j36tpfbvQmaJ9oQ8sLW/T5WaRGeX7xZV1syWsC9Ei2jHhp2bq92JMJlMmX0HyyR7iMeNF2XFQpqk+v5ir4WkmHuGLe1HsWjZZyDz9qhictp4KZLyVCz8wS67ZFvnNX9RJRMd6sN7zIk5BI+zFZP/AALhmI0FpBbgDfcHrlwItGWbm7cCV0wU5ceILtnNjusQl8TUdFic9xeDUIuF1qxKHsNUzXQdiR61ifSVbPOihDZJiPOehj8NhJ6GCKmp809QFoVXl5hjHBCBvqBd00C9ohqCPei3O0mCgnNQMlZFQj2Ydx+IQozwGWeIsLmI6EVOdM8iDb5ey2v1lyzls7DOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjLMUHSs1uKS5u33xOILwewX43qpHNn4XxpppHrHz10=;
 b=nQ6+JRshCn5bX7Nwyp00BhnIaihtK/+A2ZagFZc4VEIYJc3bE+OWrh1uDAq7M7q9DFDn1Iz3ewm1quDl3LP4w4o4xZ032SPU5X+IVisu41MLP+6N1bORJ40B9O8VmUwRetWlKixBgTtijYP2XVSCKgjCUOc82+owsPgW7MjterU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFBEF84CD53.namprd10.prod.outlook.com (2603:10b6:f:fc00::d46) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 16:23:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:23:33 +0000
Date: Tue, 16 Sep 2025 17:23:31 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
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
        kasan-dev@googlegroups.com, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 13/13] iommufd: update to use mmap_prepare
Message-ID: <a2674243-86a2-435e-9add-3038c295e0c7@lucifer.local>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <59b8cf515e810e1f0e2a91d51fc3e82b01958644.1758031792.git.lorenzo.stoakes@oracle.com>
 <20250916154048.GG1086830@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916154048.GG1086830@nvidia.com>
X-ClientProxiedBy: LNXP265CA0048.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::36) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFBEF84CD53:EE_
X-MS-Office365-Filtering-Correlation-Id: 402d915f-e0dd-42dd-b086-08ddf53d612d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J1QkL5xCQyfrwn7sWLjJuqoFoIuXx5GwanjZW6482mIyIJckPme4Q1+eBVcn?=
 =?us-ascii?Q?IgSLbkh79UeqjZaDCHm6+8qrCGG0bLdbsLRWy9FcQxV9285r4wsTI/Cw8mA9?=
 =?us-ascii?Q?cSSrkx78RIjuekZSv5JGg82SADJwedTRtHaGhX5eAmCXywA9kN9QomR7Q0kv?=
 =?us-ascii?Q?V7EYooQXzuV1Jyi1iYmhEeKdsUXAQ0E5SOGnay1wBJFg/B9JpifodpJ997nr?=
 =?us-ascii?Q?TiZBGFKCO6sj5hQ2QfUZtyqLnoBngtKczzx6sOhKPVG27etixC266mT47TiJ?=
 =?us-ascii?Q?w+1z2jCBsq2p7Q53o5nDWwOvPR6qV82e/SLGbfZaLl1dT57z3+uAkUnOrSXX?=
 =?us-ascii?Q?3G/mNhs/pCtOJ/H8S+tuT1WjanYcAL7iBqrv1UjKIZsoy/gSwz0QQxYM632A?=
 =?us-ascii?Q?/UTkoh5KvAMYc9oubCIsAgrurQKgErgZb+eQoTwxfWDx2mbXcMpddSBKFla/?=
 =?us-ascii?Q?sgSNiukchmJtarRLTufFTzw5TzVsoGMVOb3UcBeIEM1SXtbIULD6ayy8hWJE?=
 =?us-ascii?Q?alRpyVCUaGnW/xbuxRdGn117ga6rFyfAA2DVjhA2tzFloXwjpXl4+Lf5ufzi?=
 =?us-ascii?Q?bcNxpTERONnhqVM28WjGb84QFCK4pn239MtpOzCzgoY6CRsu7Bu79MlvwtmL?=
 =?us-ascii?Q?DL91H1Hp4PWUo/lNNfUxIx9Wl7BOvGRgKqlW1bITIXkCoSMUdCtHoSlpnCsn?=
 =?us-ascii?Q?9keo6hDielOK5uNZARjJEVK4TiYAbGflFiABlwFhXCpaDaIZKpZim8+BVvos?=
 =?us-ascii?Q?Gd4C3GkcBqZeH2wcFVcDbdbmVwdcHZV01vmW/m/mnpaESQZJAtbac5dtedip?=
 =?us-ascii?Q?c4UwNcHFAGD1s3FKnYJ+uvB5zN1c6Lgba83rnC2X73uRRCKiNQqPHm2aL+lQ?=
 =?us-ascii?Q?htIg8OjVTIygsfmKzX46/hEEO758TzVgoN1Y14yqNrAF2GrxjYQLh1qWsucu?=
 =?us-ascii?Q?6R1DNHixb4mGfkQ6SnTy3ZTYCt3CKN1rJJm7uBNMHV0RbwRaSOUr7c9rCQAC?=
 =?us-ascii?Q?lUF0EO8UE2eS5adh8+aSVnpEOMBxPWk9ieUkeQXJUPpE4P7vQSpT82WntvO9?=
 =?us-ascii?Q?Vsrzj7iWmzh3C9Mu7Z+6m+gVZixzdSbcSAMZBYQIdazzcosUhwpW9NSz9YSE?=
 =?us-ascii?Q?V35sn0i4XYGHO0t8IW45NOuPygYnp/40EsGMZ8Z7GRJbCW0TdkjyOl9xf0o5?=
 =?us-ascii?Q?KL1acd5pznkGQI36OQz3ts44lYf6ZQat2TJg8++v3uVOOUpgm1t55iyYXHfd?=
 =?us-ascii?Q?ANnPHh1YHNNGtQ9nyRswWUMaZXyssKp+uh5ZXliMnz7F4kAlLSq7si9hg6SA?=
 =?us-ascii?Q?5y8ikiTGnZJeqVcURnmByFwylRFP7detLQvQpE9tCUuX2P/9HBLfBPjmhTh7?=
 =?us-ascii?Q?uUoo0SuJz6kBBauiRRGNGXibgFjiEFSs9aGmOYeHd4cNU6bsHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6QO/SIwD0Y/QZXTsEOVjKt2DaK/hgjxNKBhT/ly6eu6DS7QZhcwgrCHn0H/z?=
 =?us-ascii?Q?bdgHNMFec8E90lo6RVaXTOeVLBImR5rNFvn0YzESA1RYS9Kq4TmxgEni62Xj?=
 =?us-ascii?Q?JHXXWKXfIZf1mKzJyegW6N1GMbCopV+17uZ8uA9Nfj2U1DCYEwGXzZD7tQeH?=
 =?us-ascii?Q?hHvDmUT3i1SvRMGmk8KKaeKXu+uUo7UT/VjOostMhAN6DTeHsBYyi+3QT3zL?=
 =?us-ascii?Q?rZlmZ+Fwh3jBmEzgomPKZY5sBtOtB3eufMcbJ1igPRpYSmNuT00Nrp6VUwo+?=
 =?us-ascii?Q?W5dr6GFk1UJo6uCU7h05OHZMLNhFNEvhDUIU4Dj/ysxCqSYkEP34JBZdiURD?=
 =?us-ascii?Q?CidoDyBNHeKLJn6ME9iT2drijKDtytZG4qXcK7lDz+0I7vbYOe4Zos1OU+5i?=
 =?us-ascii?Q?LrRLoyrHOgRHOwe+peQxHS1TlJBiUDETQ4TMeMj/23fTu7sNkyOLkJx62QR6?=
 =?us-ascii?Q?pYbBNEg47KhtBuIci/mdUXYCx3f+r9KDMbZlxgF/SklQstKiqBZo2oI39psx?=
 =?us-ascii?Q?vPAHW5NcimU3eGaOTOMyS3EbrtasJAyZPo9sGN5X6xmJa2CIyBqycgEnmy8b?=
 =?us-ascii?Q?sT/em5aOLaTsZTlhckiL0ayTDdozdA6gC/GRXmW2Fv2eYbPuwiKdzujL7DPo?=
 =?us-ascii?Q?Md9U11FiSvf4vuGhcDM5VMQTeoPjV+lwASAiA+UjOIIb02i/tV030tiqnw+t?=
 =?us-ascii?Q?9ujjG5k4hfcZjKQayY+snkmPvGYQb4KElzjEWctrd5NJ+HBgmVRTk+qYwMpf?=
 =?us-ascii?Q?7fNjsyGiKk3qlCoJa6tvPh4GDy4P6VDH/Aw2I8QpGyFxOd50MLFcC3AY1zBo?=
 =?us-ascii?Q?4wb+mb3rljzRHd0TR5JjzCVPEb9M/jdPC7NKXsV96lHtH9ZBrzaz+2Yzw9xv?=
 =?us-ascii?Q?+gR6UNisTAuqfWVCIhcgvSo/BLixYHXD1N4x2i2VYfD7uITjX58bwOF//iwD?=
 =?us-ascii?Q?ekLakguT7+XyMInpKCtLE7ALc1kgQ3JecSKULFtTaNEXX7CfyZTFrKfybic6?=
 =?us-ascii?Q?23mut2X8/aemE2HsuaPcBrjQShQGaWGjFJaZFRtjWMfty62V61+RdB59voDf?=
 =?us-ascii?Q?vv0tCR4qvKnjz03ItaDiLQtncjUAdeNPiPKcjeE2oKne6QCHOahTDrpRmFEx?=
 =?us-ascii?Q?UUNrqefu0wCjiArOxtO9+ZFy3znYrcKp9trsB2OPWyOcb2gLnten8l+abPzv?=
 =?us-ascii?Q?wjJl2hxFwZ0cGQjskOI2fA68KqRbh0BE7/gmQHyuxRtScAcPtb+YCNZ9aIbr?=
 =?us-ascii?Q?4Sz0MejF65siLx5pYvJja27NTPYzD9edJBXkOnzgkA56RVVOZL+CCzEQjb0x?=
 =?us-ascii?Q?dxOgVInBDhXdNWt3dNtoQMQXUtjVCfOYui3R6AR7xF9yfndIrCAJiq8fp4vb?=
 =?us-ascii?Q?kH5lbIKkqYVO0RyAaYRYLtZYcWmAZWJDbEGj33PsNRG1Vf6bYb8RS+3wuXxn?=
 =?us-ascii?Q?sRyJpIGlaEsElVKBKe3P0/nGCqhkFOFIEnosCpruMj8SgAwXye8mDnVi7fkP?=
 =?us-ascii?Q?noVolW5dtH1qszSMCXEBqbcvFvce1K8drUEiNSU2AC+gXdXB5iRsooiJRJ8S?=
 =?us-ascii?Q?HDYlDcfigTDK5OoVyCu+blYcD0WcIJ2RGu2tIVqgwcPP6beRRVgFvXAZyz7P?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9MtJr2bduo7NwHDRJHCa7049pNx63FCcabI3eFqpqqlP5SYuo3V28U1TD9sJfn7cZpr1Qn3j0a4cviqZXd9j9DcPZrOZ1YUNgYRk3G5k48SFqIJZaHARLas1TswVYZJi1xWl8VwYv+n3xOeajaf3+y08TA/seX0iQ/d5kmI0Ql3uanojou3B5DPAo1MOsS2wsZ9vnuOo5w/Ceh49hcJOiu9VIa39saWYGO5W1zEqgZBugAmaeFOSump/TJX+7xmd5KcVQq9ySLUp3LyK4DqOTCziMEyxGE6Vzc7i+zkxvVUM5sYufKWg8Kfvj6bVKuq1u8g5iqvWUKAE+EDNrsd1NpGS61Eoay26wPToh7a2xOekBen3devaeWI02vTV0fwZNFwEdQs1spWOFpR0wlv9bB9fxHUf93eXb3FtUdSx4ALZk0GJeMC5pww/nUPVxT2IE/FbIVtcx3xIrYzCHbfxjUqiCcBUWKOj2NgZf0fZFo47qZYKsd09/muyCZNiIKfMtsrAnCyxYqQcyHArdDTmpJSfpIeVeC+ebhRXtFevIuVpjSvwWftFmrsmqP5IuKTJv4byMvaviGPBXF3VW9yJ1Klgcw039fs4Guv3OqCt/N4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402d915f-e0dd-42dd-b086-08ddf53d612d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:23:32.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgJ73i4YhL2hE6c0IIKvcj0xR6kXYqEooAewvRvUFDbzdbGA/Mi0NV5bUK0frW/RaVM+Zl88PhrZIxXsMhs9k04Jl+6avq0hABbEu2b9ccA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFBEF84CD53
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=717 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509160152
X-Proofpoint-GUID: nAxw8Ie6f6-Muqj6vdXMSJwB48cmcTId
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c98f0a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=cO3NwslvaLH2-759FBMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX8uX6eQkHlfEb
 U61B31eFlOmAx7adC/cEUghr16x633lbUWz3/k0C+oyW0Un5ySQy91N07ZNtWpa5DHQgC2ZTNa5
 IILgIf6XGjN41jReP2G2S1NgCwOwwkFkUbpg7uWnm3p6CCIprccx5WBg1f4A/8BqOFbNNTFNsQw
 iTXE2Nw/yL2lWvREYWwtWW6dU3k/qEQ/gQnMRq+p4+QIAO/E6b7qz8xNLvmWr5wO17QAJr8so0P
 OtBpjput/V6F8KKU4wBxVylmvAS0grRCR5Uj7PoxxQL2huKsL/83ygjiVHrpJh/ukyCUQ+6G6Pa
 6dwyCKpJHAzHUR7VtkPVClHPST+aG3Dh5qJYdJby+bSjd5h90bClKNkP5zZ8ISKiSzgZCFNJrIP
 BBXCe6E1
X-Proofpoint-ORIG-GUID: nAxw8Ie6f6-Muqj6vdXMSJwB48cmcTId
X-Rspamd-Queue-Id: C0768100009
X-Stat-Signature: u77yzxhfsjn1pmn1y9oay8w8ocys1yos
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758039837-494032
X-HE-Meta: U2FsdGVkX19GqGESL7PSEkyIKZcckFtfiJkwFLpJ/LK+F2acEhWfMEvfafz2c8rTMQ2ooWrMSp18NeU0UX+h29U62iQyeOENHQEQ7/vWSfzuHP0eiZi2aTGEKB9OImi1UXljQRQo9+pEY8QIIfhHOOBoX6+piwNwUTFQURRIXpE2hQTPoljQsQ/iBcfQTqvCXZPnimNX/5Ltx37XM/7Ddf/5p7E0AGhkVOnNYP/y0nsapY1wCEBH14E9rqWeHFw4AppfKaG1dAHFn7gWDqudY9EBKT/FaJKiEpxrj7pgQDWC6z2xcv321GXsEk1z7Px+1+MTvjuHK6fGR7V2FSRnGqC0LzPzSg8O4EElQjL02vTR0dFyeD63qeHURWXVGThzLMnXMdyG2CL6nVxbfN3R74rwYA83lO+07DuYQ0yXpYA5JGjyH1o/LbWQda7G5EAw30K80oTr0kLa1C2AeGF2gt7bmdKr2QOtUmLkswu1GXtpwzKR9ySdjkfK9efhO0vZwWY1S+nwnksnpfKTj/R3NNOsuyzpfSMPbYlE+FXcMipnYkKcKOALhDI5PV1Bamufho/lpImFYc1CCYC3FUUrgt0Zyenjbdq7WxWfYN4D1JlLQWT3AtHKlMBPdT2gtjEeT9ZGapHXRn5RrSOy7cea6/CwqhQmQtzZm/knrGVCggKsXe13wwUUs5LUcP1uhlHn7KyruzrBV17ZNExrr2CB9oiEFJtusLnR9AKt+F2RiW7ZLjxXw4lIeAyXLsL6MusthyKHxiU2NPrwtg+vIZIIfhlF42ySAZYOVyDT4bX+ApyzVAyaXr9Gg2fpY8KFZE25uBWOSJuSJarpW2K1iS+67ajm+hFIb/2eihKRA5JyeGWXnMCmwl7nyl6blVEkflC+a+N4InUE+LzxfIEsEvflq/W3eyFDFiyPqHknkdVpGP/FCUfqSKXKWQuPlbcpM0moNnOiC3ePRd+lsKHPkMf
 7LOzLp3S
 KGfF6zDT0j4JbhgovshEC2ccLmP20t+9kyWrVxsVPt4T2ldznsSk4RsCJsY+C8f0aqKEfnomqZMeGA8ro3dD1sNrRijmv3HAYjZQ7CFn0NWWUqD+mLHPaV2ejtn1IcMh04yP++ASS7/fMdSOUfnwcRriMZz/gsad03rvOdwfUYyXKDbTWjhmGCc6NZQoU7jSO6BVY7EM4T7um0b7s80qDGBo+Htsq+GA4p0KJEQfPyCdlqSRrpeeJnn9fkjC1aMH0x8e4W0/a0D3ogs4BhZIi64gP966vT3kJQr9ViCLyukz9qZJb1D9u0xXz3Brzd23KXYyDzdN/CQDORVdwbQfmXQ22cigM39ADJOOt7Vs867NQyDjzZEKYppuV7mv4dygwwVqlcue+rolscq/TwFMwWvSH4gNd1iRJOvH0EFB5mkG76pRupZXElaU3OYtjvUm6hjJOo7cVxeJpTBQfVzi0aNZLYU7+iuoE4hc3s8YAg4XMzKo4ZMme5EF6UMNgqktbXGFAOW86u2OKUPpdJcHeX4kl5XfGumS+QXtVpz3iyzU6/yfs2MBeMTdAdLnhwnPpD+lDygFv4sXrIzCupzMq045caouLF1p2YTh5cxM+LdWWn5oKsmXRUdmgmGBA34aA0oVJ+tgLdzVPUWI3FjQHWdOKMTdjKJ22pWFe0t/LmSpVbVZBjVPlXgDJPOs0oGDIDb3vPRPAxnjhx2h6APBNusJBF2epu41358/Jo6dM8Kt+Ofm6MQ9tN4/GzLpxPlSC8xX20Rx0/qAUEG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - Jason has sent a conflicting patch against this file so it's not
reasonable to include it in this series any more, please drop it.

Sigh.

Thanks, Lorenzo

