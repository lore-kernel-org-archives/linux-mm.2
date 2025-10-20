Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2F0CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 12:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F39B8E001E; Mon, 20 Oct 2025 08:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5208E001A; Mon, 20 Oct 2025 08:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710F98E001F; Mon, 20 Oct 2025 08:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4495E8E001A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:12:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1230B1A0137
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:12:33 +0000 (UTC)
X-FDA: 84018380586.21.189099B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8C8F94000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:12:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Tl6upWuQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ytDKCpsK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760962349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkRcJW/M+dm4jZPhiYSCwFh0exw6KGwB9L8LT71tBDc=;
	b=6Vm0k0PdM+xUXpvcIrDS55MCcW9JwIPYdFJIeHliCbK0OgE2gKd3hGctkKMzLRmcGjcceu
	jGvjPB3IEHt+qOHx6PrtP0R7xyBLPy9iFgFoCjAh4hhtsEZyuaGaHT78I463BsyaM6ly53
	mYS2fN8RzAFWVaQzm9p0okpWJEOoX/Y=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Tl6upWuQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ytDKCpsK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760962349; a=rsa-sha256;
	cv=pass;
	b=QA2SAb75n9lVQW8unSgAsau6xCdLwsmX9lTkOL0LumUBpsi1qPEJqKaYg0dBOdqog91G2v
	lGZzAQhSVxBYecHOe/V9iuARszRHhxAp1BrEKjbHoFGHEoDgDNbNUfnth2tp/e7iCPDXVU
	D4A8UR+pVlRTJcEDOPZlJ+ezpo27Bn8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8RmX2005909;
	Mon, 20 Oct 2025 12:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hkRcJW/M+dm4jZPhiYSCwFh0exw6KGwB9L8LT71tBDc=; b=
	Tl6upWuQ+rOEiI3CPy569jp3Tdfgdx9Uozcr5veaFFIPYOyzEuGnfAyAf8x3kLeT
	nGlxPFYZ2r/TahZ9F4GN48AruMAY0KZKTIVakymgkxgVVmkCZ8a+139WuuwVhyTh
	UVzYyvcLiuV9/A4rE2x0RRfeRVN29YoeMF47ZMrhcgTECNDYPepzTkFcLJSGgzC8
	pME8XjyAfeEXaAVM7uwjaJcU4PWB/kgebt8KDSXE0P6AnXGi5rZdve308rasefJa
	zo7xWTgvdlflYFH5mpCpl30EdcIQF83IWUU+zvKdD27igdZslFw7JvWFA4+4tMI1
	4nhVb3iaXtCkWsh9cF/Sug==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vvt4bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 12:12:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KBVZKn013696;
	Mon, 20 Oct 2025 12:12:13 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bam2vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 12:12:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OUw3aLiCEHKDHfBlrcPhkoueV14z1AfmfTKq23giWxbucFJWws+gHqjRQERw7kVKMgtxZFjau8Ejd1vcx1jnb1HCMC2i9Jfj+6bqKOtBYeArOko1GavW9DrkSld4dKpJKTdYHLeM9rZVs3rbjWAJHAjs8jcEUo9GtXETnJ7jMMafKuwbyRB/SIr8K8T8KcRs+tC+25bxGPXlTkDx5Wc3Wdjr9rThfz/dj52V5PaEFImgBOiFvD75w7x0ZDExKIuFcQqUWGPnVe7hEeR0ZqsDezKO1OTrgOZDeRry1R14GVpxaxxV8X2B2sbEMtzYqp4XLG3RJ6jC0rapDN7q/LYmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkRcJW/M+dm4jZPhiYSCwFh0exw6KGwB9L8LT71tBDc=;
 b=EvX5mYvrnXsmerihstlI+WtNJvgkaf5E0LfHvr8XnzJTxyuknoF78gmfEFxIb/eWwNSzYxjdrewIAg1Gv+PqAxOGrihQol3DAb2C3TwOW7q5P5RrK/AgGCwV18yeaioZdA0pMD1nD8HHqknbC9378kUdGvYrMe/PvZ6DjKFDRETo9kcQGm6WuAS7sfZxafgPNjOIChq0Ds/BLwwBaBwRINJHR2nFUPj+zKiIhAL60ISFD6puzlHnuYhg9S+hHAylDyO6YvYeIeenAQhrGrw35kttJJPszCmo2CKuPkPCxljiwjjxsIuhyzSEYmfDhr2ScjRHqNSwqZ6BNpmI3JVriA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkRcJW/M+dm4jZPhiYSCwFh0exw6KGwB9L8LT71tBDc=;
 b=ytDKCpsK//S9LDRqhV/ltJdM+D6gk9RD7BTXSh1KSTpMHRT7zi9d+anwHtIfq5xuPPWCkE7NrAeeUExXWNwMj0AIw9cT7nFTPt5emyZ0+LpCcx3PFaJVGNfMZq1AsW5A8OCPxwzBbQrkSZ4kjCO3TaONacncycfT7c6ZkFoAlMQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6364.namprd10.prod.outlook.com (2603:10b6:806:26c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 12:12:09 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 12:12:09 +0000
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
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH v5 14/15] mm: update mem char driver to use mmap_prepare
Date: Mon, 20 Oct 2025 13:11:31 +0100
Message-ID: <48f60764d7a6901819d1af778fa33b775d2e8c77.1760959442.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760959441.git.lorenzo.stoakes@oracle.com>
References: <cover.1760959441.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ae2b0e1-9976-4ec6-d340-08de0fd1e47b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BaT8ZtWt5cScVHR2EKv57M3wA/dMw1URiB7tQJEZ/iMgTrd6yD0MtJ2T0oNA?=
 =?us-ascii?Q?SBxfdykhsmy7P5UqbfLhgBAd4LoVSmv0anRda7PhbyAHAttZhF2AqEWXTuhi?=
 =?us-ascii?Q?a0qOyycQJGIAux61l9xgORqpWPgEB0tVDTSXQ2hIyOyR6Gs6xSKsOba0+Bkl?=
 =?us-ascii?Q?b4NhSXprn/Qip2PEeyOghTJzf6JUi+n/YDeGuPCi6k73j76Kbe6BCDAyd4bY?=
 =?us-ascii?Q?MyI28YdLHgiFhQT0QjOQ5kgIJE6Wb1WIkwiltIRkLVfBg3vo10D+LqK1QwI5?=
 =?us-ascii?Q?QTNBkFWmXXacUsLTOps4OlKwLlZBgi/K9IbGRTaHUrSsBkvb8cGZYZLyvrkH?=
 =?us-ascii?Q?lNx5CSb5Q9cV8DUsgmrxRMbRto/qR5/CImauFQrPsE1+x9hMO+RrRqZoAQEk?=
 =?us-ascii?Q?YeygsLPyj3N4Q6E9Bw8q1tG5qYqZpwi4iBHy+euYTHp0DWb4RMcUnesA29DY?=
 =?us-ascii?Q?pVdh6KfWNg1O6Mhe+e7ej1lFexrQk7xLn2GwnDCrJQDbZ3VqtfS8F1lpmS2l?=
 =?us-ascii?Q?1Gb1dcGhSVyBCIwXeLsPrjong8WdP8TD/JB77+2n92g9GfCcgFFcX4ptdR7X?=
 =?us-ascii?Q?w8oVPffWrjmSiKtW+lPcDzHrjIqARSFR4/WekU7vRGnasi1/n2dBwIXLA1zO?=
 =?us-ascii?Q?x28uCtzcjUHDYJwiOyQQdfmkR+UnFBwP60aIz0UoC+rshbx03Roy7H+lD4v1?=
 =?us-ascii?Q?oexSTeByww09p3m4Ao/REvzCgG8WBfBfoLSIdPtNZXTAB6o3MMJQitDXV6oK?=
 =?us-ascii?Q?TdjklYSoFz9BRjIYR7c7GWI7NeUMPQSK8e1itAaa27bN9lQYhXRP5t1VKqGE?=
 =?us-ascii?Q?QszXQlaeUpf3L670ScedVx81xO+vuP9Rv7vFtF8ktAP1vZ+AgG/mrpnRevdC?=
 =?us-ascii?Q?6yb4DIUjdGQQm7KxCRip0XOFWl0LvOIda3IUPNV0kfGcblU1SPZLbPOoy/wm?=
 =?us-ascii?Q?0bxPgv5ptF+I1EGrYjFY1tXhfjNFCdkp72Osj6Z6FvdFt9dh00IFeYNYO+ZC?=
 =?us-ascii?Q?Ikk0T5WZ5zKpcz0imE3J5Chw/9Vp46tV5NqyZ9o2Y94Y3a+I0mQTFsxwsPMX?=
 =?us-ascii?Q?vg5cL7BFRFgjVzvJTDCmd7NLKGc2OSTE8ahyoIbbpLFlkvVznIw9Fgl9aBLA?=
 =?us-ascii?Q?iwJ+YYQi/NfIz1hlyzafRT0wt2wd4ebbY6+GFple9+qAVOc6dbiCvirPnifK?=
 =?us-ascii?Q?4ibrS2FFiEadWNdYq/2CpF1ez92nu/3+IWa7HnKMrurRpsu3cYSp6TLGY+hi?=
 =?us-ascii?Q?WEg1d2Nz/GLSq/jC2urndDcLdHlD4UWg1q0kBGMDQ+wWBei4my6DfmA5iH0o?=
 =?us-ascii?Q?+ZxYiae8XUp4Hi2Cboyo2/gIv9qRvg/8JUyfhXBH7fhjOUuxSv5kvajvUKXI?=
 =?us-ascii?Q?UUPPS0Rg+GFz82tdrhRn2+2DX391yQEL1l+MxEJWNtcxUfKy2EloH3qglHON?=
 =?us-ascii?Q?Ll+UHMOt62cHC3dgGaRagZ5PvkVEt0OE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kltK42oOcyCr9kHpt/wufyp5JDGncXM2zQMkyC+GBybMya8UJep+oB94Pw/s?=
 =?us-ascii?Q?qjvtknMPmP97SltFwGKGzePh0tIlmH5/cFEbAd34iTN8DyxPiBRLooBNgKzW?=
 =?us-ascii?Q?2Q/xp1yuTDBys8SE/eakGqnpkbw3JmRy02bwUShOoQJoazqwM384pKMLZ6Hr?=
 =?us-ascii?Q?VtJ9NSAvbkVMjXXnukzNnV5GFaC5Dj/LlKeiKn0BRiJLzurX37ZFQebGbwZR?=
 =?us-ascii?Q?tH+vlKWwAFLzYe0RKjNWhy9bqHfETbtsE0Galm1QrC0clp8pt618NJnG1rwR?=
 =?us-ascii?Q?I6NITNhl7BE4nPawl8vSW76ls+vnVv7YvJicU2kGCpwYAZt1SnoGOEO3/WOz?=
 =?us-ascii?Q?qP40G1FgnA5Em2KB/xGDMrhaGdxhIICZE3bz5cZnAaiuq0jF6WF5HsrqAzeO?=
 =?us-ascii?Q?XeQKyKQhz/1mBhdK7S188jEB2N4VKs6hv10NLw/hwTgF+wBVoEOj80zAuAQv?=
 =?us-ascii?Q?9y/sGOJJip8POwgkUIiM1NNWqcKZUnrm9Cs0Uj+h2bW5DosQmmlCb9N0WHrX?=
 =?us-ascii?Q?T00FxcuAUaHk7/2TJXr46rLBd11ZTMxGGPWHb7o6bqkFEbC/fLw6ijySX3eL?=
 =?us-ascii?Q?63mfOgA2pJJ7upQtD1a9a4FiDZGgMol4AKltKlk7fHDr9x4myNjHFiYymicQ?=
 =?us-ascii?Q?xl3+aMTAV3WbUb2sPiXT+yX8mZxa7T+L3WdMW8HPCED7zHR9P8cIcpI20yHY?=
 =?us-ascii?Q?ppQo8JPMQ5k6Q78W2kUmDa2cteSDVeiQAm6Y3N/ApuPCJBWpEJY9mJLw40W8?=
 =?us-ascii?Q?I1ji5Yk3bymCko9/utFs+oeSXp61RLLCbH/dIb2HlRY0VtJxTCsnSGHvO7rI?=
 =?us-ascii?Q?aYO5AimgsglPoB6vOSzgSOTmoBUyDg4reo5Ug5sTQYVo4ZIJW+nFfZZ/bffv?=
 =?us-ascii?Q?fm5mcygmXMIR4QEmNR9MxrFjNseoXoPtQ0MvH+JiYA41xFOZWeay8j5nrE1K?=
 =?us-ascii?Q?Dy+5bMlYM7n7mnePWzaFieqVVECc1PvwPwyrR4eogeb7fe4Q8IKh2xGYzYE1?=
 =?us-ascii?Q?UTBJICjdJCRTAzN7SyYyeQt/Eo4X4CEoHTLtjPLYlczDmi6r4MB9EKmSyPbv?=
 =?us-ascii?Q?T6LXheCb7p7PE+RX46vhXdDuZBtY+5xWAwSZMv2uwTA6tOfHpsKF6r2xGuQH?=
 =?us-ascii?Q?iMAhjB/FrVD7THe5ZRXfADDKfzpYndVpSmAbGqC+5CtdfNcoPssgWL/H3sM4?=
 =?us-ascii?Q?Te/016rnXASAjrdvJhqoiKX0LMcyj2HrB6XQLIzr2y1QAT6KKi6nuiyEVTOz?=
 =?us-ascii?Q?D06ULtjy4+tRmryOc5aD3HNtzw0FzcK6bVMKBuRFomprzWe/K+azYIjaCIAo?=
 =?us-ascii?Q?xT20u/GetfjiNxlt4xHcnIHd/iT0oXALdBt5AOWqbw/935u4/bvCvXwmi0TX?=
 =?us-ascii?Q?6N8QBPFRQ/KTYLCHtG2dyicIb2U3Orod3aN4D74YQwkgRYO8QOL7FdS8FcnH?=
 =?us-ascii?Q?bs39xB/i1dTlLrXVKxMNlQzOpt9Kk9unUCT9AOg3ajINlZyDf4mEDgUqW4d4?=
 =?us-ascii?Q?rEzePK3PGv2ufFNgMap1o2RAWbMkBMmyW7ckNLnbo2lM08e8CDr/0YhhEP0O?=
 =?us-ascii?Q?r0wyIVnT39aEc/2fG3xCgdWy3SiXeCcrzAXqzb23cjLiZ/nxZIxV/9iC6IR9?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0yC9KRzVoSQJ43apYJaXCuvWIacPkrRmG6nJafThA+lvRmH1OWMrJR/l/+shPbNxE37If6wSouFK19nT6v4oRAVMHxELaotm63ca7i+C1OPyBw86c/Tmo9QBWH85d28LQHakzI8eUpEvAcY4AOULVEEgtfBbsV/7eWGPBCWa7mUm7hrOM4tJgOixl0xoxaYf9aBSy5Km+hxFC7wE4bJ9oA2IntuW0z3FtaAoNyGVQoohuVkTMNJ8DXpOXBCHBitztLPfOfORkXuO4NSpYa+RYT0DtbeB/xo5/IwWxRIH8pRPeEdpgva1STh/LUjnKQiTEZpJd4aewQIpmsYHvdZPTBEtTThf/62ohzzuY1jRY7ydqildzabu8TzrqDfdo6EjcDaOOvfvYPcb/FC8rfTMoqq1BoyW7qiMZhcSWE58qAjDo7dJp6mRMeSw2SuC5e+E6Ti4hIQ8yn0IgtVPZw0ltyq0bGi3/Tnxocni1d5jNEz1Ljb6tQtJ4noER8tu3Gu4yKifP5TdN8YW4FOO9eVsVROL2G7eGKinvIy7zdkcdXIVQ4s0g4VwV1VylfXcxw741VdyEfMagBgLAf//ZMsnZ92BkPjjriLQIM8PX8rXdEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae2b0e1-9976-4ec6-d340-08de0fd1e47b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 12:12:08.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toXgtYSUIy5eEDHCSteL18qvRi5ZWCCHWp0piU2y5y3zKyBzO/oyest+VX6of35QhRubNBE2szdmkPw5BySDpmLSnvZO9FquDqOvvQoCa3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6364
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX/fxK+cFQZqB3
 N8MvmRIWxG9lcWH9RsSVNoMWFeifTfyDY7RtNDl1pf0AyB7EvLO19rcaiO888hJiASPDetfc1NM
 1zMtCA8VGy8COnz4sx5YWvc1zOqMnAMzhmAZxb8BXFhu1eyz7maElRxzB1wYDTFqDox5o2I17vk
 I+hx1vhmbgybFRjWfm4GLSWpbe8xoGZNB54Z7bTQP9c+l7QnkecsFP8a3fmQNyBV6+Fv6KlD8G0
 lFsMQML8Syj8SkT3deMzvpjyfdH4KQ9FftKVTeTdjH8feDl4LAFSejhqq/pO1jm0RpO1Bmgz0KW
 6kSWWL54XVizgKMzZ5Ptg27sRGtB6u9XDJzCe0Ag2IYmxdGCvTqh4BSNfMhrmrrYlcyR6ANjZd2
 HVYBZSEjj4+DIFBYCTAydA+GXRVU0Q==
X-Proofpoint-ORIG-GUID: FMPXVgvLnBq8x6JlQz5_u5TYslZA8D5A
X-Proofpoint-GUID: FMPXVgvLnBq8x6JlQz5_u5TYslZA8D5A
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f6271e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8
 a=x0R6ikhiTiIxgpotQrQA:9
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C8F94000B
X-Rspamd-Server: rspam03
X-Stat-Signature: crq996ogr51e3e6knb7w63zt9dg9sc7i
X-HE-Tag: 1760962349-458937
X-HE-Meta: U2FsdGVkX1+oTkC2npik328Qo/sYOAXTE2PHFEoJdAeAipIdyf6F1/RTZhR4CdpvqMtF8ScM52nxfXczKwrv2ZSziKRndBwS1AnZFp6EGa4uI6w+IOPFcYqLO1l316Qm4gTZAZaiP5yyLp/2h8rcn83neoFEYJ8Nzeout58Iy5V2aNO5cVywFuDPIn67qPRj6ziHMzg0AJEQ3741bJWZD2rkiRprAIflXvuJviavyl2map5m59FxkPLZCugZfC/82IKXhERR7g1hm0qVWcFMPrrikomtqcjXpU0F3WR9pDEbasL9XECrrdoYXTDrJuTTa4pgNVzFXeJGQEKyHycBWaf8xACCCEfJsArke9eaQ/r0diigX8PFeWScyo3LuDjt0oafZFAp/ZMkD5pm/j7sYWwfc2sU8ToSef+xEQ+4pEFlNor55KiREQIKA2//pFpCYkmjfBGln4UrcZl/MKUnfgCylOqvJ8XevG0XGJNiCgyqNn0owzVGj5LZHEUFXoKt0eUAhRwkFi503tgQZ4LEyJiS5GfJaTIWC7tBfbs0s0r+5BQvIKNKp1YtZmVpp1k/z6ATJ5/8oZYBt0jqaLmSKhJSM9eGjKeqLOPwK5cGEqcyQ5YiIhm/39hj3nkW7DGRnNZgRZutaHgC5J1YJaQZymhcgVsLCQqDBgMckfsBzqT5mXRCusK59RcS1jL/+hygrKFgKJ7Toe4+j198+Cq5XOREI3vDmxHizY3Shx8NHvywEqGc7X1YuCAYer2r6Oya2DaYFwDXkv0H6j/rQAcQhGwSZErgZcuL0JPqwsSYDb6b2+0DiDnWM7cagl1P6s/sP79uiSVZV1mFoypXr46XcBE5+K0P3kiW9bzWF1tD+8a0rsstB0/OkQFBLVRWZfokuNNONtMHCTpPhfMbdU9kvob5eX9kC+gACrLLJvuUi5c6Hmuma64vWZ7EEjJpN6oj2u98G/4wf/R6rTjMZq/
 6HUY6Qwu
 SO3+5IYNx9Spj/HLzR/8QH+Pht53/DyDf675ARpO7sKO6JgmIMMT9ihUSEEMajfKSchSM+voPLDdcLxEE17VCrs/dayzrU1nGCBMbqOiFIrjsRvv7mTweb4s62aEUxut/R9X3HMWMn4PkmtfeyfLGwaxzMqW3BOoF3m6OB8fpFKLIzEP+IjYC7eaHMvEwoIY7obtb4eqmpykCyUJcJ9tX2AHHw7jFw6774E7mlZA8k72oE5LVa0lkJm1Pd51koxx6EVesskFLDEqnHC2cLGUasKe7qdj09+RWfDmsOvL0fx2AdwhmJOrM6PF2p2HL3rZIR7DkzWNYdtx5+NZIy+EfBmjT6deEsIg1RUvIHb6HQb4JHM/f8QcD7Rk6judCoEVRpjqa0PmJGdTSnWrFeEC+vqz91DkAQwssuitNsTN+Xg81Sy98PGqysBKOEqWY+fAR8NvOrkYn6ehSa0XJ+BVMHwp5xjdBpr7EuqWBAGZ8lyyw8V7GNEtjkHFNs+dxsqKjJlb7Rb1oBpV4Qhcp20y069T1AfocreQSYefQIqrhBNiJgQfc91vJ5hE3VBHhepMLP7UJoIV/jgT0tyNM1pMu/5TBjD8kukCFyduY+853PLURI40vEbrOVQfzO5jf6f2sXCs4XlTgjDaMtxOvOtTPQdAaJdgrbJbeQ7k/n19NC15gWa10DJhdgNKWxN3AzZtGr5TZr5ami7FXRv4X951GoSnxmSDpnLsZnwvBeCeLOwFwMjskaO2UrigjaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the mem char driver (backing /dev/mem and /dev/zero) to use
f_op->mmap_prepare hook rather than the deprecated f_op->mmap.

The /dev/zero implementation has a very unique and rather concerning
characteristic in that it converts MAP_PRIVATE mmap() mappings anonymous
when they are, in fact, not.

The new f_op->mmap_prepare() can support this, but rather than introducing
a helper function to perform this hack (and risk introducing other users),
utilise the success hook to do so.

We utilise the newly introduced shmem_zero_setup_desc() to allow for the
shared mapping case via an f_op->mmap_prepare() hook.

We also use the desc->action_error_hook to filter the remap error to
-EAGAIN to keep behaviour consistent.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/char/mem.c | 84 +++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index db1ca53a6d01..52039fae1594 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -304,13 +304,13 @@ static unsigned zero_mmap_capabilities(struct file *file)
 }
 
 /* can't do an in-place private mapping if there's no MMU */
-static inline int private_mapping_ok(struct vm_area_struct *vma)
+static inline int private_mapping_ok(struct vm_area_desc *desc)
 {
-	return is_nommu_shared_mapping(vma->vm_flags);
+	return is_nommu_shared_mapping(desc->vm_flags);
 }
 #else
 
-static inline int private_mapping_ok(struct vm_area_struct *vma)
+static inline int private_mapping_ok(struct vm_area_desc *desc)
 {
 	return 1;
 }
@@ -322,46 +322,49 @@ static const struct vm_operations_struct mmap_mem_ops = {
 #endif
 };
 
-static int mmap_mem(struct file *file, struct vm_area_struct *vma)
+static int mmap_filter_error(int err)
 {
-	size_t size = vma->vm_end - vma->vm_start;
-	phys_addr_t offset = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
+	return -EAGAIN;
+}
+
+static int mmap_mem_prepare(struct vm_area_desc *desc)
+{
+	struct file *file = desc->file;
+	const size_t size = vma_desc_size(desc);
+	const phys_addr_t offset = (phys_addr_t)desc->pgoff << PAGE_SHIFT;
 
 	/* Does it even fit in phys_addr_t? */
-	if (offset >> PAGE_SHIFT != vma->vm_pgoff)
+	if (offset >> PAGE_SHIFT != desc->pgoff)
 		return -EINVAL;
 
 	/* It's illegal to wrap around the end of the physical address space. */
 	if (offset + (phys_addr_t)size - 1 < offset)
 		return -EINVAL;
 
-	if (!valid_mmap_phys_addr_range(vma->vm_pgoff, size))
+	if (!valid_mmap_phys_addr_range(desc->pgoff, size))
 		return -EINVAL;
 
-	if (!private_mapping_ok(vma))
+	if (!private_mapping_ok(desc))
 		return -ENOSYS;
 
-	if (!range_is_allowed(vma->vm_pgoff, size))
+	if (!range_is_allowed(desc->pgoff, size))
 		return -EPERM;
 
-	if (!phys_mem_access_prot_allowed(file, vma->vm_pgoff, size,
-						&vma->vm_page_prot))
+	if (!phys_mem_access_prot_allowed(file, desc->pgoff, size,
+					  &desc->page_prot))
 		return -EINVAL;
 
-	vma->vm_page_prot = phys_mem_access_prot(file, vma->vm_pgoff,
-						 size,
-						 vma->vm_page_prot);
+	desc->page_prot = phys_mem_access_prot(file, desc->pgoff,
+					       size,
+					       desc->page_prot);
 
-	vma->vm_ops = &mmap_mem_ops;
+	desc->vm_ops = &mmap_mem_ops;
+
+	/* Remap-pfn-range will mark the range VM_IO. */
+	mmap_action_remap_full(desc, desc->pgoff);
+	/* We filter remap errors to -EAGAIN. */
+	desc->action.error_hook = mmap_filter_error;
 
-	/* Remap-pfn-range will mark the range VM_IO */
-	if (remap_pfn_range(vma,
-			    vma->vm_start,
-			    vma->vm_pgoff,
-			    size,
-			    vma->vm_page_prot)) {
-		return -EAGAIN;
-	}
 	return 0;
 }
 
@@ -501,14 +504,26 @@ static ssize_t read_zero(struct file *file, char __user *buf,
 	return cleared;
 }
 
-static int mmap_zero(struct file *file, struct vm_area_struct *vma)
+static int mmap_zero_private_success(const struct vm_area_struct *vma)
+{
+	/*
+	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
+	 * of /dev/zero anonymous, despite it not being.
+	 */
+	vma_set_anonymous((struct vm_area_struct *)vma);
+
+	return 0;
+}
+
+static int mmap_zero_prepare(struct vm_area_desc *desc)
 {
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (vma->vm_flags & VM_SHARED)
-		return shmem_zero_setup(vma);
-	vma_set_anonymous(vma);
+	if (desc->vm_flags & VM_SHARED)
+		return shmem_zero_setup_desc(desc);
+
+	desc->action.success_hook = mmap_zero_private_success;
 	return 0;
 }
 
@@ -526,10 +541,11 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 {
 	if (flags & MAP_SHARED) {
 		/*
-		 * mmap_zero() will call shmem_zero_setup() to create a file,
-		 * so use shmem's get_unmapped_area in case it can be huge;
-		 * and pass NULL for file as in mmap.c's get_unmapped_area(),
-		 * so as not to confuse shmem with our handle on "/dev/zero".
+		 * mmap_zero_prepare() will call shmem_zero_setup() to create a
+		 * file, so use shmem's get_unmapped_area in case it can be
+		 * huge; and pass NULL for file as in mmap.c's
+		 * get_unmapped_area(), so as not to confuse shmem with our
+		 * handle on "/dev/zero".
 		 */
 		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
 	}
@@ -632,7 +648,7 @@ static const struct file_operations __maybe_unused mem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_mem,
 	.write		= write_mem,
-	.mmap		= mmap_mem,
+	.mmap_prepare	= mmap_mem_prepare,
 	.open		= open_mem,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = get_unmapped_area_mem,
@@ -668,7 +684,7 @@ static const struct file_operations zero_fops = {
 	.write_iter	= write_iter_zero,
 	.splice_read	= copy_splice_read,
 	.splice_write	= splice_write_zero,
-	.mmap		= mmap_zero,
+	.mmap_prepare	= mmap_zero_prepare,
 	.get_unmapped_area = get_unmapped_area_zero,
 #ifndef CONFIG_MMU
 	.mmap_capabilities = zero_mmap_capabilities,
-- 
2.51.0


