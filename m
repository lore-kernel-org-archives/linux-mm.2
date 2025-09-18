Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A58BCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C7D8E00BC; Thu, 18 Sep 2025 02:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B639D8E0093; Thu, 18 Sep 2025 02:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B648E00BC; Thu, 18 Sep 2025 02:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 900A18E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:10:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 433111607D3
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:10:29 +0000 (UTC)
X-FDA: 83901346578.16.360988A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 008B5120006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:10:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gdPJKKnG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CE+ZZUFw;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758175826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8voVqakbKhMst0kGVvkQXgJx+Eb3V/U+OIQSjraWkB8=;
	b=r7rYNT8TQu6jrpb53QHx+cx/oB+AYEy2mrcnkXS9o+XE5Hr9XrlMHD7eWB61IJC01I830i
	jqBqkIFBq2ytS8Voi/pVeT5NkJ2dF51v1film0+PwaRpOZcnqDBTGx1ajVxWwYeZai0k3Q
	yIhnL4kM5Uhe/GLIjxNqRO9y1CnqLQA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gdPJKKnG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CE+ZZUFw;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758175826; a=rsa-sha256;
	cv=pass;
	b=mP6lBdbD/b7mYz/2DnyLJ2vSujvnxgivuvvGOa5CB6zeAFFSzl2hX1fDN3uGfvhfjKqp/l
	aOIyGxCZRTsjL22jGRcpbYcTZfFOpB0NWueKgpGQKlG+5lFW6D9ii9v/vJBsCPbgGiKKg+
	fw1KcNmRLBDD6Sv3tJBZ52clnG6fq4c=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HMqtCf007341;
	Thu, 18 Sep 2025 06:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8voVqakbKhMst0kGVv
	kQXgJx+Eb3V/U+OIQSjraWkB8=; b=gdPJKKnGujM2QQxZ4ipwCYnEGR1l09PjWK
	fN3HYc42Hx5qGV2mMkJXT8fwfm7KSHc6pyb8i59U06/S7u+URvHIsBM/fILiFtOu
	wSavgWgZQi2/rs4HtMJccX6h2uVA68xeQSeKzvMQcib56/z8Kionr2KXBXy5SrLo
	rVj3/B46BH1wPxZBERqMyBHca9JA5MgZyV69ErBgttlTU5HNBEKnwyEt4BVzLXiV
	gHx3uPw/UaUGJ8z1ga5OY5sTvl/bcend8TTFwtQ9r3rGI1Awfhl+LVJZFsl+M7yK
	WdgYwj6CAKU0k9TmFiNfAKQdJj166DekjYxbURz+ChNuXu6E+AFw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx92qdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 06:10:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I4VPtA001512;
	Thu, 18 Sep 2025 06:10:06 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ewanj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 06:10:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zog1FydjdiIwZl3So4BXJvZTU/DC1hwpuOX5WlTqjIv8rlxsX6ybeLx6MpO3VNG9+GekePmMX4aZRlKU1ClKNfM5zZ4W26tIl9Lpagwsqkgti6q0gb72RK9/4D+ain7fZ+BHwTIbDdd9xPRff9LdjEmHNjEVGTHrEgfTN7V/TEBnlnOhMM+EUsnTEYd4KySw7NS8Jmro0m1Jpe4VrDmZe7wF0Inyvm4R0FuV6n1L7k9PggVCctSgrydRjSk1dUbS8zGc/f1AC3sjEcOSBs2QLTnhY6p6yWdTmOfJ5y0g3rDock943tK+fd4b5A+e4jtl+O5hkLpGDVuPntsiIO0D/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8voVqakbKhMst0kGVvkQXgJx+Eb3V/U+OIQSjraWkB8=;
 b=M0t24630HfW5WQBe0UrJrAzJYbWsdcQQ2nIIfxlPfIJmp3RXnZ4Oc6lBe+kfQ2/kC7gUGVLLfVoMkYQ/U+WbSKJ95r//Lq7OMmpw2ttOU/sgqgpu9fsUqmrqLB2jeYJWon+/lvDTZ/T1ZxOfgfFgn87Pd7SxlhtntenzEzPp1zo45yQYbmH0Bx+ib4J1LJfrIh1ZYeTjR1VSWZ9qnPHBmwPoK3mI/JcBNNWhUiP1lVjwyWq6JA6ZzIo7R1DJ25QOAtubkuK/xGqtMkLUmyJsv5vkFzZPQ2C2v0908Amv21pIOZF4P9iaSG6Bi8V85JmifYgW+/i/Om8rURyN9oopGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8voVqakbKhMst0kGVvkQXgJx+Eb3V/U+OIQSjraWkB8=;
 b=CE+ZZUFwXW2KTgmZ9de52sSaAskOVIb8eDBS8ed6MdBtchtQ7BplB5UamMorxD+6Hsgkxpm2lk/bB6rNpQJq8PJUPRh2Qa6LkBvUpXBGRbnOMnGbKG0u9r9o1oS66PPVlmu82QiKB2dtrJv3HOn9jJ/Ol3+sC6mN06BFBsj3zD0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5199.namprd10.prod.outlook.com (2603:10b6:5:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 06:10:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 06:10:03 +0000
Date: Thu, 18 Sep 2025 07:09:59 +0100
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
Subject: Re: [PATCH v4 06/14] mm: add remap_pfn_range_prepare(),
 remap_pfn_range_complete()
Message-ID: <5d177369-3c0b-4c31-9383-aaa52b7e9185@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <ad9b7ea2744a05d64f7d9928ed261202b7c0fa46.1758135681.git.lorenzo.stoakes@oracle.com>
 <20250917213209.GG1391379@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917213209.GG1391379@nvidia.com>
X-ClientProxiedBy: LO2P265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: cb16baee-64ad-4ea8-46dd-08ddf67a0192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9+PuUUKaxxWaIPphDobBdJXJ4ZYgo0zcVLWBfI1eXLDc96jepc/5GTi32m0Q?=
 =?us-ascii?Q?BswMwj87aXuw1qo0/zQ5orVlQ2zP7oqOUaKWhPvejRynarbrsza3IBNOTdYP?=
 =?us-ascii?Q?j386tWzZYhpGV3NZwPzqnanTfgydgEOPOh+obFarrwX+HB513c8oKUIQzZvp?=
 =?us-ascii?Q?t0O3sxKEY0eatFteO27bRcQZSMuuUgLISXjbEi//QOLZKvhLpHdzs/4dWzCU?=
 =?us-ascii?Q?dtwzXfDs3olkZNNwXHlTUQZh9vCGgO3Cp0JruWeneEBm/PnVqmQLsBEsWO4X?=
 =?us-ascii?Q?kUZyy2TH6FXsLycTL/L+w9DC4Ipa63dSRqcIkP6WRYzE/ALe7FDmg6vS8uMl?=
 =?us-ascii?Q?WoixASrTEVbQ0Y+ECG/Bej8hSC2oMGG6JTReMR0dAjxDFHt/wwljda4Kug86?=
 =?us-ascii?Q?OwAHBfz0bq7qJiOs/tE/nTJUioQ/XIHUSQu49DFiQDRY5zaPw2u9TqNJgScr?=
 =?us-ascii?Q?4LsOlwS42hdF7q+LgXjjMAWy0/eG589cUYnQ4aY67npO6SUuZ23YDumgKkVw?=
 =?us-ascii?Q?MKjxA3rduy3a43dHQ9vx3bojvxOLKmeqDjs+TAQGPg3j8ZGdEuy4p5Bqso1B?=
 =?us-ascii?Q?p2bNTYSSLFbDjYoz6QMDx5yEU+IjDp0khsachNOWeF1sYj5VaczEH5oDrd7c?=
 =?us-ascii?Q?GQOzAwaqZRag1tvExnb5G3XxTYbIBMYylodB8SAzma2+7vPNjrf7KIqzJrgb?=
 =?us-ascii?Q?dK9ix7EbEBgsrWgUTRdEaOD98zcqacA3vm2ZG5a5XjZZlJPL4zdA8+9iiO+i?=
 =?us-ascii?Q?jK+mId9v4Ssz6qL09EM30HQ6vEaoMGU997SlbGv5x5PrqVQ7YIgJ0OHekM/U?=
 =?us-ascii?Q?KKsoTp8kt0AowKk9hj5c8TNq6Rouc1jOAZOkiB4GurqOBsbr3T7jYXaHsQNW?=
 =?us-ascii?Q?BSEDEJezZjhDnnTqoZKmzuBQZdxGDh13xKcB/hE+y3xdBQzRcF6FJYUOqkct?=
 =?us-ascii?Q?OpJ/wdL6BAIVliQ6RVilkcU1N4fE+YLbaW4voRmUNZ1gaePN9Nmw23/cn5aC?=
 =?us-ascii?Q?3TMsEflzoU6jSE8W+rGZEx6QEDqNLglsczvZWMeZoF8/u8nOUGAH39QKlD5O?=
 =?us-ascii?Q?b8nq8yDUsWpigrpuIHCk2sWXRG5IVPPOcNlhRKZunytCybpJdNHPjV/C7hNU?=
 =?us-ascii?Q?iwulf7Q8J2t2ztC3sW1F6t9xGNTUHN5KWFltMcLpawhSbC9ElImtvlLLhFJV?=
 =?us-ascii?Q?8TRjyqbz4Kpp8DGC4xq8Gu1K8qeFplo4BLgZCNkaAoc8zym+UdBxRQHfSNWM?=
 =?us-ascii?Q?EBNHKmMmeGze75Vqc2xEu0qRiXjs3fo8MQY6KmuRMZj/l2Xp4yMMMhjiXtff?=
 =?us-ascii?Q?4uOyQCr2suKzT/StMyLnlwdQTyH5q017L1BXX3tupMAxiaqarVq2k+1yv9rF?=
 =?us-ascii?Q?tInCUS/c8Hi3NfWLrCuW+fNPPI8Zrn5Npq/lk9ONqjvUYPcfRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GG21t53Q5RzVqQS44vpVvMwDQFvcrDani/WMQgpDpMyJOVUTg931LrlV6MYh?=
 =?us-ascii?Q?ydQUrUUola5tPgGk27fl0LQlUMfeKv+78kLM7sBU9q6eFVvCKbOLxnjwOzM7?=
 =?us-ascii?Q?Jqf2dw9pQe5kfXqH8lKwQt2i8FxjtFnCusgIwB24IMXKe7RlCHMMCo3VxyPf?=
 =?us-ascii?Q?FK2KIeQYKvqvzBFPautchEYOrqAtHSRzq0nBi6+Af9K50xBQSc41LfQcaQ5x?=
 =?us-ascii?Q?3vzG5FWXE3YTHUAgYqfNj+3gxVSROJVyiqgccqADV7zW6F6spA+5dwnFJ3Kx?=
 =?us-ascii?Q?tTH2O9pIr6Ng/+guhAxUWzusOEazlm0iEGklvL+hMMbiSwlTBxWzdhSEji6Z?=
 =?us-ascii?Q?26Ct9PYPdzeD20ARSLS3hxwJd6jMy01q/h+BSD/CFGPasXW+6ZOeix/91PgT?=
 =?us-ascii?Q?MPpwZJ7telZ32z7Id9QOzT+gXcdJmf0cgK266o35e74GB3R4rz453e8g7lHu?=
 =?us-ascii?Q?LCa8Xhj0T0I3c4A2NzJ+vK/8diWypagtX4m9ukz3X2mrYUSZBFdqUZVfIYvU?=
 =?us-ascii?Q?ZvefMqwDdEcxmiMc6ZhkipBI26Z3YKYQ3o19UZoXM1pJzImxzshfOg+py9Sy?=
 =?us-ascii?Q?AJc3SMgCPxBTlV2g5ZWHaLKwG8vU8YON01GSto6azW/FMGYhwqkUTxxImkg+?=
 =?us-ascii?Q?FKN7HzSRnE2C1Dce4Ip3EiSnnhph2V0SLxob3Pm9+4paWqtfCvidTpEy72mR?=
 =?us-ascii?Q?XHwnBZbuQl7eHBJs97p6Ks7Qd3+4PVhuTHfdcrJZcgi1vMIh7KGdfE1F9IHz?=
 =?us-ascii?Q?Y63HnB9NV8DEt5JcvdCIRs3Lnh0RbWZzyA03ic05PDZNweSPOrYzzahUynqs?=
 =?us-ascii?Q?/CnfO+cFmgahGMxcbCjmHSrGY+IfaBxdphExFIzCdJoBfX2cfgyxxEJZIMs9?=
 =?us-ascii?Q?ZkskFGym+SIsdAGONzIseZZocRWiDWN1FKr21ULAexiLRUChuWIlAIuMryCX?=
 =?us-ascii?Q?G8VX2lBKgY6idqZ8QCMGAd/0Lpa/a+bc6pDKGnIOsanPy0cVAkCSDQr5J9H5?=
 =?us-ascii?Q?VhXtzQTS4MZfcyGNw8x8woA0Nd/WN25zyOXaCcvu61R+rEDmk6O0bF3FsrJh?=
 =?us-ascii?Q?eBsKHmmV/88to0raxmQjteTYpwp7dWgUVQlzHZNf1+b8s09RDlKRtTY9dksu?=
 =?us-ascii?Q?v6a0HV0sw71wbYguFWTRrAXs+Kfn1yaTwKyp46l34kqpBlIk2DzslY6lrm+u?=
 =?us-ascii?Q?wC9PU7lwymO3fsbZqM7sUO0DC5+82xcQgFNsxy5XImmurjYOHk8LXHvKSKsS?=
 =?us-ascii?Q?+8piat4kxtnux22AlK/CE+xCry48bO0kSiFys6ct4IikQebQxRP+aPCYG6Gv?=
 =?us-ascii?Q?su53dTYCByAw2Ku7v3+VNPjJ4aCx4dSYnY0pxZJIWIDtpTERBnXALexfhV15?=
 =?us-ascii?Q?I5JV7GxU+Iae/41F6lKAFmr+6Els5LWK/H47Hle3N4kLw+WFwQISor2iXX+R?=
 =?us-ascii?Q?dS0wozkJtNBsLRmfrYMjOA+wRxK0EJIptwQRssyGOlDo4tmUGHtnAmQlYXUL?=
 =?us-ascii?Q?GHA/yWtmviegiHWJJpFbtgvFjsGGFQ/lPALNKeorl1ZQTUZ7dnOPdDxmLSyP?=
 =?us-ascii?Q?B4q4t0rBtMsl5IM2qffTsdsZyUbKMPM6ibTzzt+k3Ymq29vC+zj5HpKDdmEZ?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lNXnrabH4oz5JSb/PBGfk7Mvo6G+TtAnCyRItcXtLnIHayx+1C/2iYhifB8IJFgj5XZ2mHqNHkC5Yt2QHl6ogxfxvjztezlkpsvfykCunFuDLHk0cnjYvjJZMZ4fkItCaRHxeF1iIaReZdQwsjZHLFh177zCoIIItvHrJHAizSslRTHCpVzzO36bScmeSXPxIxkm2AlPBosdIhTjNFAP+zWllAhbDQ4Q0IzdDX0wEohuXUcPwV3R0qv6zhLcRJ9LvRTWIlg14RCGJdQl+/9pot1o7HP6jnxUedYjlpyI9zFd0FeKLGIVMJ4+uG7Y/k+qp5zOcByBXVbTNCsJl2XnkaJM69yjRoapvjOSc27EaDdXPxnrGy0KTKct0OSFCv1+ditjpIsjlQvCUDCwdQjnDPN/t1uwQ0UyaV+YZIeX9PLY3bTmrDqjbxOXw/Qmip4yIZnuFjNryFuC0OPl1ZInphcM4Qx8MCNQx7QgvRsjtB4AH3W2G4DJonYtMXmVaPkoCm3ggZkX4KSpbooq1ur9QMi2ZD6kGud7cUJUOG25c6/zP2m+zNoJu96b+/HwkLSqDvGfimKM1B1vxBEPd9eyhoAnZx3nkS3jvmS2gywjl64=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb16baee-64ad-4ea8-46dd-08ddf67a0192
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 06:10:02.9971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2iBWoLPwNGqPUs71DTaUiHw2lM+UwEKrLYEF2mMucZtqXYtP8gIT4SkjPjLohUKzO19yCe2oVre2TMfMKxHD3lhXF3H6xSldKXFcEfj5LA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=901 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180054
X-Proofpoint-ORIG-GUID: XQUK8Fp3w93o9sXmhL8-P7hpJlUecf4e
X-Proofpoint-GUID: XQUK8Fp3w93o9sXmhL8-P7hpJlUecf4e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX6oO8PlZClBcq
 yTvSHn4Ch9zNNjTjzHMgKJ1uNnPBlUXn4U1ZlqJuwyYvmr3D0TM1IsU0/5GmULYiOB9vBIzhhK1
 Qgo/wqkvyDtlqQpzVfVNOVKV+/LfqF1xus8f2L5VMUpN18zLAXGGbaNrhz/FrIy9yqwhejBs5sl
 FUNCXUwsY9EBwFQvwyQoRyP823AgeQsCNgqbqCjjmSIQbu7vNQ0q524RzY2z8LyWTOeBwSBY/Ex
 12F46oHp24WnXFF8dK50LMqe3299YlJfQUHLDVsvTl0ZvRlcIUPik/ESnjuL5CjRYMYnn+pO+Qd
 so8TAj0ek6wxspgm852/ET685lVI8fNL3DAc4Mc97DcXCSWYD4oh9YVUe7TIMzP0yln/tYKU97t
 eTkQWBsz
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cba240 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=kJZqd6n6nhv6pOpVBv4A:9
 a=CjuIK1q_8ugA:10 a=UzISIztuOb4A:10
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 008B5120006
X-Stat-Signature: 47ea76qzs7uddkub3wqtyhex1ww6995z
X-HE-Tag: 1758175825-721779
X-HE-Meta: U2FsdGVkX1/9ypr4IcrvsUVoSdO9svCAaf//Lhl+ACA8XEZU0JTHOnmBN3JznQA+ab6q84qbD+g8NY4De4H/sd8W5+2/P82/LRgcNHf/dphtv/7EYXkGOPO5+BOb+4RUj3oWkurUs7kAM9dbR3uyrer8pNsArVtPI3K9hfJ76h4SFCK3dFiSRlLP3n3OyLvyRLGTosHz6OExuqXDouRugdNQs1qVfCIxcV3uJ6scv/C75EobHEIH5tLMUPJd6eHVz0h6/MprDixA+idtgmECYsg+8RM/WGXDmbFCnVJeWsnx8rlW5EMpHvy1h2u3Mr++4J94lliaTm+YfM+JdL64/HkME5a8061fT1QQptA9qeTi83o8+mdB94PERb5kG6CnnUdHB4Ps1QTsAiAJ71SwEf762iwWupsKY5KxmgOyXIwX8gC3y9UqPVP/5iog2EZaF2vm2NGBZ6ZfjX62DIkDkQIAxK8VEPwaC6LQeRshwXw0ugdGggMtmLQXK/NVWpFKJKx97whT9oZcSphB3a88e53V4/W7pR/+b/KwAU19fY1KrsTcGREd5/xHr/lYIWCSZ0F3bvPw0999uCXfy24/vZonUlU8ZXjijQr9OhpNvWbTHXEXAutO4donyS/EHXNYEmZx1T8mdHVUYv87r4b0rewZktKxuN/LYB1lHW/MWNv02moZ2XeBRCxO/IEBhLv4gxc9FkJWgmflTB5R3RDr5D6XzMg636COWpzLiK9boghfV96/cgs7fVcyB2icjIcGYDlU5hwQ6ShqOCM8nmCDhbBeAQIInd9+KWJ4AnGu1dWQLZlhmEwqgN21OuKdFYzjDWtBJcJaXmqRfKiaBGuL/uDBw9kc5F/pyAZCU2iuSIinoojUZKthvo9gGffImrSF4bXg3CkHIxtJKkyicSXrqjcN8vHGgeNpeRjr2RJXC4eqbEBLw83aB9SWqNPBlR3KBziSh6Mc8qxiD+vTZJs
 YrFttdoW
 sPVRJrB3XVVISJG76ZmNWilLCnw6icgfi/EYXZq3dkAogcxRjDAR/NJSej5PWch54ea0tQkwmN0zSiHERUArTLOLnUiX9gbB0Eo1Ly9ttqy0SEnrHNbtg4F9OW6yWXVsq4vY4YV8UY0zNVGMiSzSUFTnqzIHWEmAMketX8IYW2ZyQj1fdMMMvJIY9VWNROq5ifPcE1BXs4kDnik1rARkA1hZI9NU9UQ7mZRhcEEWuuZCqManCVTB1PJd1gZMTpeHABduk1xBBW5JfVvVLMVcQqTlUGf9YIWC1SWUmSKoDjM/eY/aggnl45YPqsnBI1l09j6UREnUuEhwevR2/uCtCypoFkRAfcftZ77REyKLCZTXt7wRpg27vvpbdQd7V6IjhckRgAyeOwp+FNSoAGnuTKLZyw/+q16Ql9545wvSKDox/Eh4ZFX7LJXcCXZOlg0wz3ECtrySV47+0XraTWU+FNnj6nYEiFy/jECy6Cg1um+UjIu6t/c5O305P8XU7BIlVp5MbLlVdsBaJLIwX39P8bhh42Bk2wZhDb6S34LKx9dJu6qH3byoe+A7ercAgRIqfR8vgcsNhchE74Reu1PEJKWxF1+RirjVYqDGcyjnU3T/uI+xmDWdLBSNNWNUwhAF+3i3AnN9E/dnNO4aHXajgBHt00TXGDwClMVWJrrNjsL9lZts+X567IUmH2mdTp7nIDbJk+0wVfb4Jq6QZ3PgcvX2SC3XSJd2nro8k3AvqjjU6MBjayrpJQ2DG4uMZWJwMpvAvAiRUwmL49vjp66fEI7OqeJzfbfEfgpJ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 06:32:09PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 17, 2025 at 08:11:08PM +0100, Lorenzo Stoakes wrote:
> > -int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
> > +static int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
> >  		unsigned long pfn, unsigned long size, pgprot_t prot)
> >  {
> >  	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
> > -
> >  	if (!error)
> >  		return 0;
>
> Stray edit

Andrew - can you fix that up? I can send a fix-patch if needed. Just accidental
newline delete. Thanks.

>
> Jason

