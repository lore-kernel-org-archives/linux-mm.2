Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E93CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE1B80196; Tue, 28 Oct 2025 13:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F228013F; Tue, 28 Oct 2025 13:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E83880196; Tue, 28 Oct 2025 13:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15E5C8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:37:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD55759491
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:37:16 +0000 (UTC)
X-FDA: 84048229272.30.FFD5E92
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4CA8C20005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:37:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GXLz6j4e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LkoYEjmo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oiBnaMrxa7UtUfHkRAaEYBcRNFdVE6jcJg03sWPZZU=;
	b=PYSbtwRP3WkFRBYOR8FOxboMnS9m4C4DV+ZE2YoC55vJhe5jQ7bKVk9SbHQ8+GMsG3HNzz
	zDtlHVTmvoMPXWtXSP2x+O+Y1VFOZ8IzmJaZcU1NPa7utkDEj4IB4ZAKH0tXmckqWOgPeH
	+nDRV56gZo74D8Gy0uR0EZGPgv/IuMg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GXLz6j4e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LkoYEjmo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761673033; a=rsa-sha256;
	cv=pass;
	b=rNKjb0xjYpB7J+FxmVTNhlhxnjk8v1OZSg1uNyx1NjztCm2tydoRLTbYNDtG5Lr6r0aDdB
	C/ZfdhkjeEysmZ54lmGU/30X3EFis5KLU/mFaK6mtRfTwATorfYX2i2xxIa+mmjZGvn2X8
	KrSzJZJQuKmkven590SBCt14Jq7hi1E=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHW6Bh009972;
	Tue, 28 Oct 2025 17:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9oiBnaMrxa7UtUfHkR
	AaEYBcRNFdVE6jcJg03sWPZZU=; b=GXLz6j4e5+/Azu6BW09ZcS9thffgEhGf8V
	gDsKBbdAAf6FmH5LHsuMjerYDQ9oFnMltGqNTd3Y4xjw0WdFJQVgvvFgRu2JNr4Y
	2PU/QIM21BXGmvlNf3eaa6BGWSINIognlJ4QsEpuweo81O0CN2ZRoOhP+4yVLj8Q
	pfvfjeZNnHF0SMkOJDfypI0i7w7XMBgViV+E7WzRRPkFtYDtDx6Vliuxe7ek+q0f
	ZNwxxucDyh5BD8zwRPgaASCX9wBBqIBg4zGVyvvBwDWU+Fa6eJHkow3AcnE2LNcs
	46r0HZQpgXP6U+foh6n/O181XBpw8RMwSaR0U01a+sTia3ZEHx6w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0q3s6rar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:36:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SG93Af009871;
	Tue, 28 Oct 2025 17:36:55 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08ry2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zxu2va7T9E/vNvY9R7KkZk5EJXpyTFS4b5c0Nh4I2I3basKnFUd3w5cuiePB9jerdf17t7LGoGS5BBTPuIbn9es2/M4jOm3BwHro0XEkqMaNNGT5vWapJGfSQbAgkTNS3haYj2d8hAFH4tYzpj+bA7ZHPI6fg2z9Ujgr1nJGBGlVjnsBOon5soL/spe8uZNBxCdiB7EWF2f4w4wQhSwt+wFSdG2gKE7x/YtTE8nS7mT1m47A3z2g6ssvEYEAg6Hby6l5wxZvmcWhdmShpsSiyIDwsLqrI5jfuMF0R/Ucy8+x4UrLj7d1OTgeyvkg9Y3hjqYAT0lZ62OHNYY2jCfUig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oiBnaMrxa7UtUfHkRAaEYBcRNFdVE6jcJg03sWPZZU=;
 b=hA6kkH3zIH16yzz6xs/oBQaLMygnQJarEdAXEFwXkNvKaC6WxFIp+I04RPyAbvJQVCGxgTeGzeiNWHlx7YwCUs95w0kLXY1NcZme1lZmH7cpn8VZRKt4iwVCdfh3x+DobmS2uCJxHIwFiuycNWTrGxUVWKXPNbUe4uTH1EevfZamL+7pW5QcJLCoNkLndkkLkNqrc0ET5sQnbLA48UQC5JKxx46PkEzC6TeutIZdAfGACF26Qygld2jG0iuwA71Xtck3MF7SA2rHnQAd6xKq03Xwm54oQIPluZQ4y796pBjYQSZ92l/nT1FMnnthtpXTI4AEf/q9kztxbJUrYIOZfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oiBnaMrxa7UtUfHkRAaEYBcRNFdVE6jcJg03sWPZZU=;
 b=LkoYEjmoHcTl9FXgRKy7xQ5RNbetjC/0TkzNN2RTQzSP5siEgwkvv5ZabGeTnje/gE7N8KqR6T3PkDr+3kRN9SpB5/N2oSWTGKvbP+ttlPkVxcVlsePMeReVKFbaVxZHCWZNwe2sB8b3iqCFWd0BI7wtuigkc4akvmiBZrhwJe0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4807.namprd10.prod.outlook.com (2603:10b6:510:3f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 17:36:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 17:36:50 +0000
Date: Tue, 28 Oct 2025 17:36:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Gregory Price <gourry@gourry.net>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
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
        Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>,
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
Message-ID: <d52d9c7b-4c3c-475e-9293-2b13dcf63e24@lucifer.local>
References: <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
 <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
 <dac763e0-3912-439d-a9c3-6e54bf3329c6@redhat.com>
 <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
 <20251028125244.GI760669@ziepe.ca>
 <aQDAbcpO8_SeDh_c@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQDAbcpO8_SeDh_c@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4807:EE_
X-MS-Office365-Filtering-Correlation-Id: a777325a-09a9-4395-5c94-08de16489379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LGv2HFRlgQ9HDTtINqJw6/P/mWPGxxKZTRvqZB9bu3wi2/M6YP1lVByVCQSG?=
 =?us-ascii?Q?/uUvGLoHO00vTRMQfpDRIdu8YxHwirFV4fhMw0GSSQCue/p0uInls0z0sQZp?=
 =?us-ascii?Q?u3zPZKrf+AI7L1QB/E7U5EAox4gIkwEqk6DD8//QG7jTgos5GF9Jv+1VfYP3?=
 =?us-ascii?Q?LjpAT6DXmR0rTgMaUgPX5SAyE+D3r/AQnC/pii9PQHbhpCcHX4C4iJOzhMz9?=
 =?us-ascii?Q?aeBdqbcfGZVB7bxjl/RgoABTIAg2/aQ2GW3Un689lyd3SjZTncWRuVHVmCTt?=
 =?us-ascii?Q?d6mFQIFmhuDMSJLMx1EQFSuIt0n+PTM50Z6IMpu1NFltlYp6zgKhaCC799Nd?=
 =?us-ascii?Q?LCxIsLjqPPSDQfkoVFN+KJ/GGtxyrx8yGDfG1Yt5TbrEig76wmL61nbSxUzA?=
 =?us-ascii?Q?90mXyCXspS18PlmBsSNbIJGh5qjV7oVjRwmNKRUPA2pg4e4Lsdhe4+NnFHLS?=
 =?us-ascii?Q?Qz8wh0sXojHBoPp6dXxG7F9vlzKxi9jEVKvTQAziPbGU1sITz2JiojTr1dD8?=
 =?us-ascii?Q?JuOEH5WRsBRGcvfF4JFH1f+Bs0ldhaSBzAen1oV9577OkCAv7n23wCrV0H18?=
 =?us-ascii?Q?3GfW1SH2gzYdjhmcFwoGaq1PBu+gzeGBreaDAeJk5kroi4Af42vIkAk0iJpH?=
 =?us-ascii?Q?Tzil4wEgJX+gdN4LIuCye+1KI6myF0laCBcM2qJqgue51Q8A9lo+zq2BBEDu?=
 =?us-ascii?Q?oM/xtH6Yc0hZ6ZDPl8tab+EdNCeZAJpqi057H3SPH7k8OpwQOuFMz/tI7hnR?=
 =?us-ascii?Q?VFSCM/07fhRo5qqKyhawcZITyyp/rgh6pvEziSWEEZdaR4WCh+81SgFRG7yR?=
 =?us-ascii?Q?GsnJHHlLbct37MwLf2K9/DPppNWLM6tA3iWqYMwnmLmA2HZOrvQF7Risjjtw?=
 =?us-ascii?Q?96H6OCubyYq9FT1yLrenSLKW4Dcy48HVqxrlx50HGH2VC2D+DtqCSCV4SMLd?=
 =?us-ascii?Q?V+MH/9ikZwcTUrU69R2glFFsuL4GHmeCBTYYKvwaqRK05WzyVeEbYVybowxw?=
 =?us-ascii?Q?CFI8ESdfkGi1ktXoymf0o27avbFy1o3vXFGBrlLAOP0avPnsdht2q8poOnRI?=
 =?us-ascii?Q?NYUX6q2Ag+ipN4NSvS9bCxF/kvb8fmemY7ERJYyaDxBH0pfaaICogKmCpOfd?=
 =?us-ascii?Q?tIL681f/73UDbFBYnLhkStQeEdDpSKmP9w/XzymHh1wygkCjVYZcyDgt6JAK?=
 =?us-ascii?Q?jASep59maDY7ZAa0FFA8eGPjBA25DB+Kzpu6q2u2SQMxUsbXcf9rXQ54O5re?=
 =?us-ascii?Q?mnXNXJokz3MK4hWajW/TGJIrG7iJzLLjgbWrlwXiNSzCvSs9uXP8k2F5mQvT?=
 =?us-ascii?Q?KPhr0TqlwNztvXbI7HjcF61hGE1nXl/g6FnsX27477k+MoUUQ/JcWQc8Jfnu?=
 =?us-ascii?Q?dsHxOL7J90DQ+y+Lrmpohv5J2tLU+P9zpVJOSGjHlQzBQ6pjgM3mzf0tcpAB?=
 =?us-ascii?Q?dK//XttRdWERsEiS7IJkjP2v9udqK69s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pEJHMYhfBq0x97ljvvjr/ssCGj5JCw1T7iuQLPFWwmItbgGf19oucPKlUIZ/?=
 =?us-ascii?Q?kplLx/LQSPvgMARvDCUOluAH1u84wm7c2LecsAEnZyYb4a7BPt6gs+AEBKn0?=
 =?us-ascii?Q?tpAciZaEpnyMyS+AjP9wZUNrVCZiUtFbE20F3EemKK+Bz6D1I+Q9PaAOYAZ/?=
 =?us-ascii?Q?v0p4tXLvBoibEw5OkzYs3n8pnhehliRnyrgjQqzCGoLv0qTmjPiBQpLCYYrx?=
 =?us-ascii?Q?SC1Kmc91Cdw5ShIub29cOHGzH0Z99jAKSLQx1EmDWeq7256ZdcY+TxkHehX0?=
 =?us-ascii?Q?c1N57qONNUHCjhtO04YAKTTd6JffpbnJaFNILsAEO8IfF7tbuggIJT9v0CSe?=
 =?us-ascii?Q?KpEPmYO8KHO9ph4GzOy7Juo2MKA9PLzUUWmmLMH3tUfb7n2cyimkXl2/wv6F?=
 =?us-ascii?Q?bMVdZj3KOTgFF8r2JXGr37+QzbAu2Zs+KV88sIvJ0h9aDqK9RJjPfQFph9ng?=
 =?us-ascii?Q?xjurymYVsit6ZlMAYK8uelNdT7iFUm4R1OrnyS24EAJ7KCKaJ5SBeaxkj2Wv?=
 =?us-ascii?Q?Kh2Kt3ld3x+3rPG8mLnunfm11qZjLNnWfGIYXcgpJQQOrLUD5xX0jzMLZbJh?=
 =?us-ascii?Q?QquKdhjMKsUYlrv+ZtMjJThVcuO1PJZapmniBbyTDL+y5HWjwFVTj0+4RgHD?=
 =?us-ascii?Q?DsDsBXGBIpqt7W8cno1FDjgc+FZWeRFfW+DGcUNnh08HCAkce57W8YHaa1oy?=
 =?us-ascii?Q?hIVzpQJsz+NbaJkW5iJ/qPup5VUZsZur+yssWPcri1Ujw7LSjfwF2O1WTZDu?=
 =?us-ascii?Q?Hsj7XKL37va0lpgi0DrgZ6vkGYgVnxu2I1fySyB+rYo5q2SMwzLlpHX+lAz/?=
 =?us-ascii?Q?+u7LdqxmT2R6DGDlF6KjeEfpJCuhcx8/NOrN5uUJhV33bx131dC/O0LqhUVR?=
 =?us-ascii?Q?+x/ZHJfQT0XHJcZb7i5Vdjn0kn2mfFZrHH0UZlIXWP4G5HVlYIaTUoDu8HjD?=
 =?us-ascii?Q?tsEdRkhMWe4GcIq1KlQ42l250a8MasS03cJFqdd/6GDb3z3Sm1amU1UFigXn?=
 =?us-ascii?Q?vbjO06Zib1m3o599K6kqvNDCA71DLlaPg/DQKJnvKNtCvz3r1PPBl3k4dAhA?=
 =?us-ascii?Q?lvdDpJ+oYGdaQw2ZeIVAH+dT29MOV4rJJvahLugAMyeXJygwENJSz/OdOk5S?=
 =?us-ascii?Q?e/fR2G7Aw5u3dyNcPtQV9qUZf9Z7brKly0BJd31TkObyBv/FxDr4ZpeTSuwv?=
 =?us-ascii?Q?R7L8JQ13O8AcGPdCaj2zGBecYf4eCrekUhigBpICOYtX0Z4mrmjXFX+U7l2X?=
 =?us-ascii?Q?yz8a+UND8R6g4ysBwcpvWrTS+eQnM3rpRTiN64e1xhQWFbjZh79G63SVzX7Q?=
 =?us-ascii?Q?91NMi81FKdNUvyNNlxPc+xpD46ZrII5gFRhdFnoJtVvHkIVokOpu0GI7MMNj?=
 =?us-ascii?Q?XrUA0rX9xj5AdJjcqF/eWoqNBf4IgZ90QYh5qsZoqEkksRItni/CSWkgXW5V?=
 =?us-ascii?Q?ckv2YZYYO3SMXDEMlLwu2nH0s5ZcLuoBmlTmxzRtaGPBYb4knEdFJW2dHlpB?=
 =?us-ascii?Q?VBEOppOIcARSmz4PHjYHAi84siQZg7yUIlyps3p6El/IK/aPNYNvzOKOzj6e?=
 =?us-ascii?Q?eHMU1JKj9S8lvrCIgMKqkJVY9a3XJ14hq3q6BsuUVMYQuNSlRYw1P59LtFoZ?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XWpWcGa3zn1LTB/4Jw48Dg67S7VGj5kEurd7VaK7pd/j3aNH+E8ODctcmofPiM/NaZYNXztIly7Mq+GZ6iIZ5FY4E/6DGVgSssfXvZq7dt5JaFqpRMic7CzogccGQgOrmgSZEoyA6kmWFWhPIi3PRkYee8v12zspoYJyE+rpdveuA0OvScsdkj/EirLnHIJDeacLalN39RxBxF5c41TgrNIbNTytr48/TZpcMi5ApX9yMXt641WhqzsSG7P6sjFiHgtF9Te4jfxvAotKj9fYRBzUjLpHyW2pWpjacB2S/ME19NXlldxiTcAdJSKBeZyuoncXEMB4cKeEgi0Uyf/m/xuOZYOBRzGSVKFVt5z06fOc754lnD0b11K7XK2LWQHAj+pYpze8qc1XyhxHnabAiLl+1RBd4i6FMoY918eSIBbfILIibPzOYKijwGxOByD1BwHIvj6H6PI486rcCokjjHOtsETxQRZxuV1KPNgbs8V0tZFmmSMkkrzrSpKr1yHwED9RfrtG7mqsB2E1MUyqQMD1L1TU1EGJVd6aIkZdm9fu4oaDRPm56Q+nOgewB6v04zSj64ppOntFNmGUXOizA6ECIGn+Y7ZdSMvlX698v1s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a777325a-09a9-4395-5c94-08de16489379
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:36:50.1529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Hbw+bn1+BCeARD3fo6X5n2Gqduvx5rw2NLcmjYmnUwD2tTyHHIENazaUSpYiRvP8rirvqqo9Ivqr8gLQo9ArHmyFuKCX07SOdvr2Erp0DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280149
X-Proofpoint-ORIG-GUID: D2RJulEiGklWyoqGkeZj-_jOeqS-gEOA
X-Proofpoint-GUID: D2RJulEiGklWyoqGkeZj-_jOeqS-gEOA
X-Authority-Analysis: v=2.4 cv=Q57fIo2a c=1 sm=1 tr=0 ts=6900ff37 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QleBFsyc-yqDIk7nl7IA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAzMSBTYWx0ZWRfX/K33C1K9s12h
 JyUR6TdpbjrSviYrKCL1+Px5AXR57ThTy4Qc33PQxdDciaIdBCk1ZM26VaDIrGlKuDWc6O7gQj1
 XB4/vYtoXUi+MgiQCAjlxmdyJknMs4Uujf67ywY+r/c7oU7EM3K1sKqQK2JsjDI8VeSxvTXbedS
 BF6d10DKhelyeK2mj9r37YJEsJ5GUzEaLEt+0xrpVCJWNiSK3xYptHwYC8FXd+Xnhq8HKmXpwEB
 ZhKnplSV8QCLiraH+KP3kMYq3dS9/j13mw/ne2Ud8bRhF1wDc2R7Y/sKzag3aYMtp8BBl2E6oWC
 8g6sMzPigOXvIOO4PFIs2hJ92sWPB0so1CLdTxyIjblMHeObivv86Kee/+2ryMlt0lEkZi0XF+W
 nWzIp6Bn0qfclmjNp901EpfVvPxzMw==
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CA8C20005
X-Rspamd-Server: rspam03
X-Stat-Signature: cp1tmqcc8z5qfbh9qmz3xbxacmamtydn
X-HE-Tag: 1761673033-898625
X-HE-Meta: U2FsdGVkX1/2DBNIXZleVDqUp65RyYwtkmeiXJmwaePVV83zCdsWj/RVvTalwJeWb/cXACrvdpIq7jOMvZ33eLUJKxCSLfmMToTkzhjhLuE5T0i5gDcyrONwyKxkzbP4sUvoYmVYrhK9Lw6LNS6cPHCHRQe/ZxMQYkD1JYtPAR+jwIPQnjv9thsTb6OPIza/XVT9ZvoXYhzPA3awPi1xuhi2lrHjHeZlEKynbZMuWCRCWJWgSrutUlMo1/nElUSglTGk4iiDi3DPwLe0TpMQRc0GWp1PVjmqkGl34GoyLYIwKzGMMXQ/n0zk5cmbiCIpGe6plDVWZ0c4IQJ39N/TqZZwwvyOWIg2w25Ht2AYEcB5Dq64d1rOFUoXrCc1RFqbSL0bN2mU7MKzjERsEWx6wlRCA9xsMZoYajF/uFVCSkNJt0S9DXbvTmZV1Qx2vG0IWOqlKO+JOMnRWiF4Z9rSxg6unRGTKGNGAktMnG5TtIaNTUZsSQSx0Xt470iCZiW8KcEZ5Krc26t6YEVEi+nTIrIxsB+/hr46jNw1mrhefyHunKwRyCNgThvEtGO32pKUMfV3k5ou8rcmvKoWRCdVHYveKAnDIHRyQlmGrWss+whVRvyRuh/H9CStl/9wQttFsDKtMuDP+GcKd/8mChvj2PHOKPuL6R6B2tITDCXLRpdcWzCZDT8eMs9aR6+jczNyzz4llAUPA8kfY/1GL8S8YrHFQlFljsyRYdS2B06X0Y9n8rqVAcFp6i9SKCoNE/tF3LSqGe0YuEsQeGGDPDPhezSYumPZKfDBxIBcb2p4pla9zRkUqdGsj6Z/GmGEIkj1n0uvN1tSvYmEAzifCXauEvvSKrFv7JzVNyR9bHYZWRutDnxzyq6o/YCKBLmnV65RaBTciDvXNJLmoW5O7yVN0pi4+5pF2fQFfMwsiX0fgX1PRLMGZWRNTvxFfndK8pKO+RUtjzwcAZdahPSpd2V
 TuGqY2Oa
 FovxccawGW2lJZaSUfF6H/9seqTKWjxmYpKrYFko/E0TUSj5Hw3TTpZzKsVJ5RtUnDuOWHZsjhXuODv3rNH+Ufw2W6szPZNdJNYfJjjIFwlFfb70MN+5dWBzWd/VeV0zR1bF0argIs742myXh2o95H1yzBN/AmzEUykt8hZpxaH8riMw5vP28ugzC5OXEJekLaB973XRu4XCXDggxPt8o3mCqwEPRTyWrff+GskLUu70Y3eqXAxH5II95P2A7Lknke7Fqb1c/WtkqwdpR1jlHemWnnE59ULHvZpU6weD+d16wpJ7txXa3QymZjYoEPjJHUHNiSpvd4oeuwVO1fbOs38gc87zg8sg8M3P1GlpJQrmg7WHJ4BcYFHpyww9tETukl+OT1VARGfwORM73FWvWwAuL0TRpttDOvWhrn4oiGEWDZak04CulfYjn83dcqaVT0z5hvO/GivHVFkqerUik9OqWTloz6A/MRplsVdyQzpFx8/dLyR5Up0y+1/tzcBdoXvui6pgc8OmvoyrjQoByT1JEi8NpTJ6oeE8RhNRtM9tdtHJV8elbFa7IzFZWFGk8ctguL81u16KqyvXmWrTBhnUaepsTGJ1AvGkCdMRht8qB5Vmb/e1M+nb1U6d232Isurbhk3GxFIcsHs8DnSYUmofs23FOh7xgWCW/yWiol9EttPYIcEWuNWWq9Am1GwxXxulN5bu4v387fVtaDYDb3OKNgLY7nh0QEAEzHG/MfxjRVik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:09:01AM -0400, Gregory Price wrote:
> On Tue, Oct 28, 2025 at 09:52:44AM -0300, Jason Gunthorpe wrote:
> > On Mon, Oct 27, 2025 at 04:38:05PM +0000, Lorenzo Stoakes wrote:
> >
> > The union helps encode in the type system what code is operating on
> > what type of the leaf entry.
> >
> > It seems pretty simple.
> >
>
> My recommendation of a union was a joke and is anything but simple.
>
> Switching to a union now means every current toucher of a swp_entry_t
> needs functions to do conversions to/from that thing as it gets passed
> around to various subsystems. It increases overall complexity for no
> value, i.e. "for negative value".

This is the point I was trying to make yes.

>
> Please do not do this, I regret making the joke.

Never joke on list is the lesson here :)

I have had to learn that the hard way myself...

>
> Regards,
> Gregory

Cheers, Lorenzo

