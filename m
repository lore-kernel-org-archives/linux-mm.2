Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C2AC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F97D6B00AD; Thu, 28 Aug 2025 12:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0DA6B00AE; Thu, 28 Aug 2025 12:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4983C6B00B0; Thu, 28 Aug 2025 12:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3310C6B00AD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:57:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D110D139946
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:57:34 +0000 (UTC)
X-FDA: 83826772428.30.389C4A9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8940A100007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:57:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NsyuBEE1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FseBAmCa;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756400251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DG3+BpV2Ob7zD61a4fQsI3PALbK2BlXG4Yll3VePhk=;
	b=hvMes0HlHjx4OAGT8Bv28sTe6IPJrCUuj2u5WM99fRAU+jT1zD+HGVKtMA+PWFoYlDZafh
	VJJsRtxGA7uQ1s+PfxHyHjXSO2Ly641KQa+pAi/Ibp1Xq/0HgxV4vyGpTJEy0F4d2pFqZv
	Z3+hMV6efD9vvjbAXzpHqPHFfv9iy5A=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NsyuBEE1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FseBAmCa;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756400251; a=rsa-sha256;
	cv=pass;
	b=Qj/ifoMxK62bZjY4tBitJN954HKL1u9xGReCpeNawi+ly0ilvAeETr8QodcW9BKwegTAcX
	+ZlMHdpxMrhhGh29S8lrdrEXgcEzN+AoDkZ1kqZ8GJIA+srFpEU4lUgqwBwwfEbgwhs6WV
	T5YjebSp5pt3QC/od/cuDhx9QFjhYas=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SGu2Ec011865;
	Thu, 28 Aug 2025 16:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8DG3+BpV2Ob7zD61a4
	fQsI3PALbK2BlXG4Yll3VePhk=; b=NsyuBEE14g966hL2xt8tsFZ64GBBOGuT1J
	1Nw4ThTxiVqm0qEnmL/QM/qj9+saRpY8Ywx/YUC/rbPtUuFk4NN1y7xxNiLBPw/g
	Ihsi8Px7sMyshQT3ZWUOYGYu2P3CgtpphzgKi4gsyifw9xtT284p5mBRrnBlouMZ
	rw7xUgtdnzz9CVZvWGRDIhn8MBGyOBrYXU+6CoiKbJ5nHKxU8hHldUU/fqru/JSe
	K9uxxQRZE6EFQ/f64uhz+DhkIuyqV5uwQDCzf0H+KPOS2egY7t8OuoUUS+n8m4TQ
	ataRWPeOZcBteAZzxQxrTgz6yICKg7TAsVMhgdrrF6V3/QgNQdyg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt94pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:57:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SGbGjJ026710;
	Thu, 28 Aug 2025 16:57:18 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c0fqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:57:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEIr4IkRZr9KdNmbew8Ue+Z9cBTt9/txyizzfNL6qzJqjVrKeIxSMIDSek0IH7FuKlS43/MX6x8FNY/9Vtjxmg8+xy7eduRWkbCGNM/vsyiFgMXbU32eigcdi0Y8DUBxD9gfDiA3B0LejvlJSjePFFXNNkzbVHAFBCQBrkfIjnG+FmxXdS3qD0eWQslTts4lM9XMvIyKZA4p5nZ9cKfKpTb6VJ15wDRcUf7kpaJ5xqTdMP5NQnUW58E48koSsuNV6BxIzy0T5LOvXk2w2vewIUipfyKpXr+2xJxS+DdRnWH+4Btta/2un587pwJM+lva9GKi5y0m6rAxJP63unO60g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DG3+BpV2Ob7zD61a4fQsI3PALbK2BlXG4Yll3VePhk=;
 b=ZC9XqRHiFfmJG25YjRvHamia6rKrvnKHN90b8V3Y7Hc+hYnKV/1zc2EzyLrfb++2kBDDHDVmawfAr2fJ/xEbEeQBAdy223IrTegk4g+hZXH/TJbZfKgU/8uKdo/Z9l+IgKbJXvlnxnwM3sxQBpKJf9SmIZ0lkKiRoGOYIdsrePcjyq0ImKrQ+BkC97JTIhXsJr9yoyoXJ5or2FOgIEGFMZRrl2UtZILgQGcxCEEUR3TgUooil7Mvgv/l/YoHplKGlMUBshcyYKueczT/x9jzgsCoQLisP2jAa2leBuD2Rv8zYE49dBH9j3EuryvTG6BSUnSFDnLwO3vDFCdu/JOIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DG3+BpV2Ob7zD61a4fQsI3PALbK2BlXG4Yll3VePhk=;
 b=FseBAmCaudX+TgbqqefDQh3rO5AknWkZkQTup/r4ZZZxg1LVhg26WO7hEO3icM4+HlvIHVyaNi8/tCakZE2SF++l3OY6QZW2bwOSpEzwOaPBDD4EBb36yzxvJelfebsUL6hPtMQg80BygXuqIcqcPQ0wUoryplCdRdgVXQDLGIQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4298.namprd10.prod.outlook.com (2603:10b6:5:21f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 16:57:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 16:57:10 +0000
Date: Thu, 28 Aug 2025 17:57:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to
 __flush_dcache_folio_pages()
Message-ID: <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-21-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-21-david@redhat.com>
X-ClientProxiedBy: LO4P302CA0039.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4298:EE_
X-MS-Office365-Filtering-Correlation-Id: ccd7f29a-0806-4e3b-7999-08dde653ee1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vohsKy2NnjwRkINFPQHoEMD+vEyADUxvKd+mitI8Bp0Ub8HEQywD8/vDTUj1?=
 =?us-ascii?Q?MOkiIZ9KgS2e5FJEISOF/Cr2B+5JY8/LDg5spYJ+MmlNHsUHO/ifikWtnM9q?=
 =?us-ascii?Q?G8FZGG4tRO2yiJhRQbpdODSDXcUF4c8GsnyXE+H5Yr+i7O82sBJxaMpXJ633?=
 =?us-ascii?Q?WRk3KpfZ8M8Yzc+2G63Gl1Pko+trkPzWb4kmldcbnipAnvA7JiSnfP0nskzA?=
 =?us-ascii?Q?YfmkcqPn0ACzH/JXch63hHHtUak89zOHgUW4dGXLWxDJ0EM8MBiFBLnhTtde?=
 =?us-ascii?Q?dudqFpTbylZLy1m1eiQn2tvJqzP4OdKAHQQGvkddyI+qZRbXYUaz3fk4Qbcr?=
 =?us-ascii?Q?8nGczcW7DS9b3QlNQHqDura2AOKkQ3xdivord4vzCyW/mPEC3+YJuvvN8gKn?=
 =?us-ascii?Q?riCGnqzAZI7nxtnP/vJf+KM9t5avb4cvMNbIDVGCltbKTFfCQ4o/5NxpGUd3?=
 =?us-ascii?Q?sKNf/+6wmSuAOfBDqrRSNOlNIap/vDoWErmj4gnOJvmitwe0GJOomCYUewfh?=
 =?us-ascii?Q?330UXtSTIONSJ8M81u6ks0iAw8KujCmSBWEvS7oLRLGk8zLiWOBVkndTtHLF?=
 =?us-ascii?Q?P3PNIGqEhfIs5twZB46txaXdGymFrjzPfQlUxk0d/zB6KIcQqZoVzEmYZf46?=
 =?us-ascii?Q?3ARTqKcAN/TfkrIDuy0nyVhxrBV5oTCEsqYIyokfQrZ24owJhJQsNKsLMdkD?=
 =?us-ascii?Q?urcVWJHk3OeKJm/31/u+Dz0Q83FNBipiYKYWKCZOP+suVL7Sze/m0FEODOaR?=
 =?us-ascii?Q?m5CYK+8xL0jVsrzVe7QEwn8R5abN3iPouQHIqO9FDykSibPdFzZT2mX6TZ96?=
 =?us-ascii?Q?yEzQ2FN357ZL3SWcNXDJH17pZacLH/RFK6FwA5zOMpU+4zcNJl/VZCxSnrFg?=
 =?us-ascii?Q?7AnDNNgvMsIcrh+IdpNTxsg2BdeDrNx6a3Bt4fvrRfm3+na8HQM+qlkDoZil?=
 =?us-ascii?Q?V1Ze7Z6a9jRSsxrvRsi9anChE60mdbr6AQBmvP3YxFViovvdv2wxx+gh6a72?=
 =?us-ascii?Q?rsjxl3W47FkUFuNDh3SdVmgWKM0a53leQz96i0pfdwB6AaAxFjjX8vkto4Tl?=
 =?us-ascii?Q?ZxuI17h2r52CA4oB1QLi9WWiebSB1Ki+/9F+/Zxd89xyTgRcnVn+WBcuB4RS?=
 =?us-ascii?Q?vUURb9foeYc2iYfux2Tun0EoqCSv6gQMnigsPMc9cZthq2IAM9gDLQie+HT3?=
 =?us-ascii?Q?/fTELQuS3RCuxBbvXD+YI6ZE2Oc7SJ4uU6MMs3hR42yXGod/kB10iNVylHJh?=
 =?us-ascii?Q?wF6ZdeODCM4Am/0n6IGg7x+upYXB7hvZS3v2CDE9JSsiKbVrbkznMorquJRh?=
 =?us-ascii?Q?Tl7nahXpxgaOQ7RoNQQljzcOTAo3HocRYe9QrnqLiAG4xuElSx7R/mU8Ktvu?=
 =?us-ascii?Q?67vIA36tSWEAfiLRNwdhqFTzNUvx7MeNbgWWeD1fHeYntnh5RMLyjbvkCqyA?=
 =?us-ascii?Q?BX5vk1jhMvQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BP7ejPqcJjNFfMMa8h/PhacnKVN8wlGAnPBvikCORuRb3rYaAbg0McCEwm9U?=
 =?us-ascii?Q?wJcrTiQZMnNtTCtoliNu/EQeKvZwIcGQGJatpSNdFPxgf6XppLOpLa0Yjl/0?=
 =?us-ascii?Q?5H6NFiNy0qFfBWLB2bUvfKWENcKVH9b+WNKJlnizAlazeaXmzfsEffar30HK?=
 =?us-ascii?Q?UmWXfg2r/YbGGc2zq4KSS6P0p5lMnv0YCu1r8QCNf7opstrmLZB7r1TJB78I?=
 =?us-ascii?Q?NXli1Mv1YAiUFTPHNpM80KtwCUbkHGZ3AVTry4xoztneRsJU6rjlCUOjUIFp?=
 =?us-ascii?Q?A4oinon6FtjM7+U4kn3dFi5TJH8tJsJDw1QsGuxVtJgJotHnUf4okuqcHhFn?=
 =?us-ascii?Q?/e9yk5FTtNOzY6kYZE59OyOyG6HRa6x4O6Ehh6/cNXJ8L8m75hSndTC4L9ri?=
 =?us-ascii?Q?mWMXAeGIpqjGQtmNZrYemY8nuwyrIsOC+3Z54IKoXFdr/ACUO4iA8QOL9xOB?=
 =?us-ascii?Q?1GXijv5Xe30fd/5aCwZCeZ+rJAsUArw3c+EVHlF1Br3k3js3TxhXiVIi71aI?=
 =?us-ascii?Q?ogFDt3GVCh6GwBu54dqWVSld7BjLVswEVFlRL6oYh0A3VXmQYtUsH5u824aV?=
 =?us-ascii?Q?j+LEL35HNFDH12VRI4ZxtK0DIyFaj621HyelTGxK+Fv2J8j0mMIDcXBZQGPo?=
 =?us-ascii?Q?9OLhT+8SryW8z6yWHqoh4dl6kgJLdpVjqazmWBLHFq8OUBL4VuhHAo/8N4DB?=
 =?us-ascii?Q?G383DL+6QaN9OVhF3AzS1ZZHGKmNJDj9fT+L8e4HW4P0uecJFMp997wjVefy?=
 =?us-ascii?Q?TtCZXjdkASYJ9AVx6g20pl3qNwEoU1Zis064vBkJIq36xqbRSfoYDrkBcJrN?=
 =?us-ascii?Q?aaslwnh5Np1Et3Nt3z1vl9iSGEjlCXB/lnXG2QexT1olXei2Fa49VM3aVUpk?=
 =?us-ascii?Q?DmpfnxN6+TzUoYqFctA1HXpGlGwbfKo+6vHtbe1Cikz88hhMSnyqwugShslL?=
 =?us-ascii?Q?/IRA8u2pERZhERcDfWjBWsPPlO8xfhvAY+cuNswYgGDpaUAx6LOhbimzjNz5?=
 =?us-ascii?Q?mHKT3CnPvCIDBBde/GthrSCdJ585nVQeJkV2qBCYpdNB/qP0i0RbHgyvNuQw?=
 =?us-ascii?Q?MphUIrO9L+rrNFbHCmbKzkaZfm1K1rCpdkQPNsvBnwNX+2G02HSXIUmmM+W1?=
 =?us-ascii?Q?iz63N1a445a8QfXKu5I00lAW1H/vRzSCAh0+eB2qpcZDbRdtM0f8csQtZtKz?=
 =?us-ascii?Q?l51fRygs+II299fOQtkJSuhXDMztINYhM0ybQkwfCqJhtB5du3pIBVvC+RAE?=
 =?us-ascii?Q?SFv7JM/8t/8tgBWvNjlEQNbAaYTZoNdmeoLjyOQgPG7su+1GgGaLxeHCSwGt?=
 =?us-ascii?Q?flXDOhLl58B3MlbPZOGojiWFnXbiPMowIK0CJifhtO2u+s3JBPXtE1WYHlGq?=
 =?us-ascii?Q?krKLQuJwNEq7Lo6nQ2E6Cz8SrEHYCsSlTk+QUIygQ4AItdacyMNiDn7O6ULC?=
 =?us-ascii?Q?WeUZ8HZItuoyiq0FQDxmvugdW/4sPSqHzNvugl2ue3MmmJZR0OpuXIiICu9R?=
 =?us-ascii?Q?F5Bn5fXQq/DiKjhfXY0F3eWP0PyxzOCGbd28iIkHayexxw70fSpeswRx6+IU?=
 =?us-ascii?Q?cEKkDj1mShpt4+ur9N3Zp6pu/2vnEuPDr4SCXP7JSoleLS6h+3Ps/TKnVFAD?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I6d/s4RmW21l4vAXash0ydHZoFAjeJA66qNqXxuxeWLBeHWqDpFwbzAhUNtT8AXjzcglmz3rpBeH7n67oWRitzRXNyzfIzA6v2Y+8z+eMufZIgGM8y4i+IPD1M7s6T+qb9eX2OyKvG4h4FIg30qt646ChD+C8p4F8rvaQZs5Xwhqc3ceer3iHiwhJO6dxPItiRxvgiWNcI86XYv9z1CiyeVQf+8JXN2dRO8L06KOl0k2R7HA49PQv8ObdlECQBGnrpZL6365zSldXKaPf8ErF4MlD7i8/mrqHeV6KOK4Iv1vHlVURaGHWDVr8KMJZWh4vOKKd7nr51x9GkqfR25RXpP516xoDv9vO/PA/cDVevXNBPqbe4EpEYozxb2SOU7HBMmhlE8dM7rlqWQxog78VE4HlFrd336a/Gxx1VxAuNsmbgNbSXTWpBVy4+o3Me6mKdl86N+BAAOORnUlFS49KEn3BmdJoT1AGBZ/52cX0lAhocpiZnXqwBQlA3AX8mvwPcG9AVmth+EqjKFcx69loXP0kHLlhvTzxWpKgMn8QcEt1LodCw1UOU4Z877pyI+WficRCMkjRCm8JCK5DB1zMp7ODWXorKY+qpb1mE5/XvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd7f29a-0806-4e3b-7999-08dde653ee1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:57:10.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FKqDbDmgCyuYg/CVRIlBMG0hAD3yrS3sKl74qZZpsZoNXQTQKUMjk/pvK0FfD2L+TXKutLXEu+jtPDQuinM2QCJ7FHV92743VJWwC/FG1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=738 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280141
X-Proofpoint-ORIG-GUID: uaCYCPPDLq9Vkve2SqV_TrjJUbptiUp4
X-Proofpoint-GUID: uaCYCPPDLq9Vkve2SqV_TrjJUbptiUp4
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b08a6f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=y92v5ecr0tmxiwlrqRsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX5BQOIODl3dto
 dEWLU8qZaX83bMevhEA3BaeTM8DQ6D+WfIvCEp+K8uVLS0I2Ikm885ccWwjFPrc2AAzumZRC8w7
 KCRZp4UaAlDUIE8EB+tvc3efOlKhdymxWSSSdPa2TqiMEj2l5JS2iqKbGkJyHpgWdz1OeMBpu5g
 QwwXXRIPsbLjmEfL2iMHSFaTZ9oCzmlw4PQAtdAPZpQDPy0WwGK/gKOmUWSWPDZ95yRRFib8ZO3
 D5r3CEsBrBMmrxVee+aQq6KyK5cBRjTRpHdLOn5Erg/s46S02K+hSb28cLFXySHZO2DBCCOkr9p
 KsMD4i+5PoEWryxJaFYrJa8gy7BL3kJxzU8KvxAwmI79WjhUYfQFrcYbPxvqTbXve5jnbLm75Mg
 7KDUxQjj
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8940A100007
X-Stat-Signature: 11mgqr149d14anqukdhoemezjac3acf6
X-Rspam-User: 
X-HE-Tag: 1756400251-503671
X-HE-Meta: U2FsdGVkX19cF61hbRPY2Zr53ZeJ1q7V4kJFG4Vg/DIOWdnoL2Ym0P9k2L4K78sOnV+U4/xHF4hae8NHlXcgdVDxUgt67QmSrTSevDZr8tOG6iey9ddIzxkONXyT7+W9Liyli46yBFp706kLIM60W4QcpwTozLMhmTYxVcNJVtjUuffU4Qv8vF5EIwc0LF2FxIIUF3xig4JmQy0nL4mHYb7Oe+Zp/JFacfjWTblUF77szmMkEzrXb3fnPTX2tWZPD6WL1sL4g7GeCOZMQl9ZCiisDKMerBCvoswinmNlDhXyc1+bG4APYMNmrKGcAaTnLPYT225ldx9NMX/OgLgh0bk1mvcTa36/kQfLXN2n4mGX7UhGT7iwaTYzhOX+f7InnRybzLUXhBmU071sTjiNQgT0X1F4E0ydVzl6IuCjriJ3amwK947s0x+TKizkozs74fo9kKsgJr4/CI+DkbBztJcrqS5d3HgcrkO3GCMeb1PKIn+O61Dq8cG6zhJngzvvxkjmf5eb4tAVxjr74ab2QtMwEokwzFiCbYIJbiM+LbUZ4M/y7l+0tretW1aRxVhDWvmX8xZmpBj2bRqm8KuIhtpi4enqwhF6XaMzABU2OHXgZTLDzmFSeIgbFxT6q1lyRr81jjWMesJVZCy+kKb+LBijgvg3aeXrX515oIs2jZQJsBJjNKwPhnYXRouHg/UIjZ/+E14WKPmq7YjzwthJGczCn9p5c8arX0Fwh6R7op73fREYF93WhDvggUVo9HkfRqqnmpLUJqa0J51RTJ2dcYUvGyT0CaCrE7tldiChY+z4pdtgk+ZYgr3rgZb/4fPrrtevwcRXV05RcwijfqJYMhyUrh51RYE35QP/Pvu/GRV5orCLSK5mPnvTKRmOt0AAqsx3N3XxfN2V8Fb6bhUB571SSXDd7pVZ3JYK7+9gdBOhhiu5s1Awp34aE4nusslicx8oFU7QMmU7dPrvzwb
 TOyaN7qO
 26tOhDsizIUfOtPjYpBwffag/k248fU8K5s7O6HAEGu30PCdSRSBxS3+no/l8VUVYdwOlHC2MkUaj+8sgjI13L/UnNOs/OaFSM5lHVz+C+W997Bft8uQtWBr2HCAX4sEDOtZHBKn/W8fhFho/HtmbsVcxkk1ExmUFw+YlDxXPIKeu1LyNZaSH2tEE28xqNoEwcg7yZiSkq4/KMrihfx6DdzcvTEae5RTKs5kdj+2GiiCwdm6nuQxt7fam1/At9ItAX7X9T/URDCLqx9OqUbi/UxO8oi0n8pJ9O5EgypqBMphn4s5zNF6nVJkXovGhty1ThMJjkLsqLYWBhIR5P0HnSSJKANzLKKVpLpcUi8zx9Z0UiUVdTD29WVKOtJTcIf5z8uVIurgsSi131s5vG2D1HPsSoS2R33tpyc6x3BKXefZV069lzt7WPgM7lyHQ85MXErJoz+8v6dBQdn9fMGS3W98mrMZtUTffFVXM+ZgFX7Ezk+cBFthP/XcDPYu3/aj1hwVdrgUQjgnUs5NqxmX9Gbouwu+po6a7BKTiLxeqt+FFXA7BS/E22D0iiQhtCCRzkAZAipTCioLLo5UHQX8v+wtzLA8IRJPErotLk8bclao6FPKSiXwgCDiMtmWkU4uzgVGu+UXc6yql1UEAu/gJAEYMQ1OQC+IRRVadL+jfBlySgaeKKmGfGjzhij0SkivjslXfaqNFaVwjctrayCo4TUdJlNEjFyOqGL0+uvGDOepCO5HiiS2SNOliEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:24AM +0200, David Hildenbrand wrote:
> Let's make it clearer that we are operating within a single folio by
> providing both the folio and the page.
>
> This implies that for flush_dcache_folio() we'll now avoid one more
> page->folio lookup, and that we can safely drop the "nth_page" usage.
>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/mips/include/asm/cacheflush.h | 11 +++++++----
>  arch/mips/mm/cache.c               |  8 ++++----
>  2 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
> index 5d283ef89d90d..8d79bfc687d21 100644
> --- a/arch/mips/include/asm/cacheflush.h
> +++ b/arch/mips/include/asm/cacheflush.h
> @@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
>  extern void (*flush_cache_range)(struct vm_area_struct *vma,
>  	unsigned long start, unsigned long end);
>  extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
> -extern void __flush_dcache_pages(struct page *page, unsigned int nr);
> +extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);

NIT: Be good to drop the extern.

>
>  #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
>  static inline void flush_dcache_folio(struct folio *folio)
>  {
>  	if (cpu_has_dc_aliases)
> -		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
> +		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
> +					   folio_nr_pages(folio));
>  	else if (!cpu_has_ic_fills_f_dc)
>  		folio_set_dcache_dirty(folio);
>  }
> @@ -64,10 +65,12 @@ static inline void flush_dcache_folio(struct folio *folio)
>
>  static inline void flush_dcache_page(struct page *page)
>  {
> +	struct folio *folio = page_folio(page);
> +
>  	if (cpu_has_dc_aliases)
> -		__flush_dcache_pages(page, 1);
> +		__flush_dcache_folio_pages(folio, page, folio_nr_pages(folio));

Hmmm, shouldn't this be 1 not folio_nr_pages()? Seems that the original
implementation only flushed a single page even if contained within a larger
folio?

>  	else if (!cpu_has_ic_fills_f_dc)
> -		folio_set_dcache_dirty(page_folio(page));
> +		folio_set_dcache_dirty(folio);
>  }
>
>  #define flush_dcache_mmap_lock(mapping)		do { } while (0)
> diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
> index bf9a37c60e9f0..e3b4224c9a406 100644
> --- a/arch/mips/mm/cache.c
> +++ b/arch/mips/mm/cache.c
> @@ -99,9 +99,9 @@ SYSCALL_DEFINE3(cacheflush, unsigned long, addr, unsigned long, bytes,
>  	return 0;
>  }
>
> -void __flush_dcache_pages(struct page *page, unsigned int nr)
> +void __flush_dcache_folio_pages(struct folio *folio, struct page *page,
> +		unsigned int nr)
>  {
> -	struct folio *folio = page_folio(page);
>  	struct address_space *mapping = folio_flush_mapping(folio);
>  	unsigned long addr;
>  	unsigned int i;
> @@ -117,12 +117,12 @@ void __flush_dcache_pages(struct page *page, unsigned int nr)
>  	 * get faulted into the tlb (and thus flushed) anyways.
>  	 */
>  	for (i = 0; i < nr; i++) {
> -		addr = (unsigned long)kmap_local_page(nth_page(page, i));
> +		addr = (unsigned long)kmap_local_page(page + i);
>  		flush_data_cache_page(addr);
>  		kunmap_local((void *)addr);
>  	}
>  }
> -EXPORT_SYMBOL(__flush_dcache_pages);
> +EXPORT_SYMBOL(__flush_dcache_folio_pages);
>
>  void __flush_anon_page(struct page *page, unsigned long vmaddr)
>  {
> --
> 2.50.1
>

