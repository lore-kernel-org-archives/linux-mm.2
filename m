Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7FECAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D8B8E0005; Tue, 16 Sep 2025 13:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDF88E0001; Tue, 16 Sep 2025 13:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738238E0005; Tue, 16 Sep 2025 13:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFB78E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:38:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1ED7A856EF
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:38:26 +0000 (UTC)
X-FDA: 83895822612.20.6AA6308
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8E13A40003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:38:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rp3nw1i5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DctidhIK;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758044302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxapfRc7HQovadVMarQt0MupoTPzMNCVucnOfihB7/Y=;
	b=mJOGkMIk4WQC/rbVdg4dqKNnnqs7+6dbFqcLDXcK/hKVSpt9LTQMdlk8z/3AcjzuM9Nmps
	xCilVUxebZxNolxQ3Ghu5F7t8HFWrqTYkEaiumXYvsjGw+ILdMRo+k1fftf4QmNu+FsYt9
	hGsvpOz0shLEejPDg9VkcVAj4CBHhP8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758044302; a=rsa-sha256;
	cv=pass;
	b=8NoOLiv1c43QxqAFxAx4CVkbAACHCUy83j11P1IAc7lrBC0kGc8xyHXhlPBhR1AGfmrG48
	LeIcP/M8IrCi557v1ZSw/Yiw/EtP+fH5TNW2g+nkpRlEKCSyXqNDqY4P/h7X9ry/YLfPhi
	62cC/MYzqk4Uwdk10eOcfxg9gdepMtA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rp3nw1i5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DctidhIK;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGNEdU014342;
	Tue, 16 Sep 2025 17:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uxapfRc7HQovadVMar
	Qt0MupoTPzMNCVucnOfihB7/Y=; b=rp3nw1i5frLSS7Lk4+BJeKfkdKf7h6n5Ld
	l4zrD3IWQOL6BHDbfTVhOQEC428ME2Awq9SXG3F6zJhV5s9NjRyUGwCLQv/kvVUR
	UnInFiEc+ijlo3nBISEL6IllUohlGXGSQYEEDhwi43pvJsD6Fmx1gLxeD/8jOXR7
	lYRibY1Gocq///lMG5Nbr41rDzYEVEomzPNtv6BV4UbNg/B79uf5pC5r6F/Z35/l
	QpuNqUMUyDEH6euNkhDATgU11Rlo5+3vJgUqHJlWn0m5VpnVicCiVYJI1Mm4u1Jt
	Sq47Q2RzMPxbmZhiU/bSMbba/0W+tzukIlA/NHLm8841HydeP9bQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950nf59ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:38:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGkHCx036751;
	Tue, 16 Sep 2025 17:38:03 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2cqyeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:38:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ei+8PCWKqogccjLH/9v/KDI1LALdaQwmlGsTkGaE2earS/foCkCxUrp0dEG/wntRXpsjwo09UB9b7Y3JMhQMOPiztIOIyHYQds+morPxv6WAHV+EJv8F+ubbBhSamrFYXezozNu4W8/iI+HaJwqtF81AuTwkZOp8Yb0cWyBJv0rRy/6rhEW5r62CKZb3JyW1VYHKwc34FCt25SsIFcXBW2NmongpSFM343bAlVKlJERU2r9Se1GGVSHN91CtFllPSzAv7+SD1nNwirBJZGDDiBMfiQavX9WiOblFwb3LiPjmUK33EpqX5Y/dC61nemiO6uL875uRO2TiYudSn7fuyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxapfRc7HQovadVMarQt0MupoTPzMNCVucnOfihB7/Y=;
 b=GCuPlE3BgQ3cd3fPdDpVVmJ5N/A5gw2xAeIIHw2AwEPvYyT5P5yPAap4+uvImP1xsziOj0ckFMeF/zcRBePd5pv04j6ylcOV7Y79fSwRfmueSJpsGPIZ1b1FcHGCVgzD+BWXC/hz2RauoGdqsPfJH7Q+kx7dUMzSCBR2STVWqoofolPcn85UIK62fL4YGnmEsD/v+Mp44pnKdva+XjkVn6lo3WaGqoPR0Z+M9oc+1t71oQhq8fh7B6/rVUyqfilwnsCqFfL1mMNpnCj8gPWT1d+UrTuMImpCeKM4lkPGseeHZIRsWDUgpA5TA79PGenSF9XNuV7SpUGBD5l+hYXOOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxapfRc7HQovadVMarQt0MupoTPzMNCVucnOfihB7/Y=;
 b=DctidhIKIoSSqB1PkLn4EpIrd0aM100wabzGPDK/wYdYFI2LQxNIEQ6EjygLjJhD/mDzeNaLCkS1VLrRd/F97RShPLeDKP0QC0xIKYhwqBbcORhBF+MrRjcrbbe9judgYxR7JkgNotVrkL1sc382Z15mRR8pQP3wSm2NIZ5EzJc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB7377.namprd10.prod.outlook.com (2603:10b6:930:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 17:37:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 17:37:59 +0000
Date: Tue, 16 Sep 2025 18:37:57 +0100
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
Subject: Re: [PATCH v3 06/13] mm: add remap_pfn_range_prepare(),
 remap_pfn_range_complete()
Message-ID: <19ec3d37-46c4-4921-933d-4d554a351ef2@lucifer.local>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <7c050219963aade148332365f8d2223f267dd89a.1758031792.git.lorenzo.stoakes@oracle.com>
 <20250916170723.GO1086830@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916170723.GO1086830@nvidia.com>
X-ClientProxiedBy: LO6P265CA0020.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB7377:EE_
X-MS-Office365-Filtering-Correlation-Id: 64505f58-b98a-4574-9d48-08ddf547c730
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cYTlBbdDE0xLygR8T38KMp8aIwqEz93e8pQKc1WMNKBG4hOG/p0G+E6hXLdy?=
 =?us-ascii?Q?NTWiXUwA4L3OFj+hKQpiFJMdUTLPXF3ViQl0Eob/aeYPWsoggtstW2SNNr5e?=
 =?us-ascii?Q?/C7AewL1X0/mGVCuhYzBCXJ3ESTu5e/jr68g/5zu87a4DlTJ+jMwhw//uXF8?=
 =?us-ascii?Q?YcjhwZXA6Bg+4z85AG1/mFgyNvuHSgiVvy/6omufGnruDHM+KKc0cT3IoUXt?=
 =?us-ascii?Q?kfBccnaZWPp2nZWD46ykyM+BHnWh1VQ2L1NNW4KuXcrYvjuW9g6UsBlSiccs?=
 =?us-ascii?Q?boKlbDKxAQnOfvq80cv80aTKAtbrHWC8ZsjzSFHz3bQpMf1kaeJMT+OeAmwK?=
 =?us-ascii?Q?p+GBlKTqC0psy8ghZBL9395kPGD89KRUcynnk0e8nkWNH3/loOq+f5z5865L?=
 =?us-ascii?Q?aykp+kxpis1tSKnIJ3G9uL6bqg7029kW8HnNnmXovpa1qW09TSr5YJ3dhUR2?=
 =?us-ascii?Q?D6ldV40rApzTh5DMFsqlPs+ZqgXD7xJl+E269OawUB7x7awnVO280CLqQI+C?=
 =?us-ascii?Q?dDYg3l2HqPCXvJ5YHoO9iyMYQ1fJjBKxCElFVnifxfStjm7gr5GYdiNFak92?=
 =?us-ascii?Q?0mVGWtmSw8EL5+vuigDrb8XpTcHYUYf/HrzliunKT9Zq9H/t2fVlIC9VQj8Z?=
 =?us-ascii?Q?PUJsLcC/hWoVP+YQQz+IgFHST7GvElDkXCQpqaCdfsXEATzPjDBw50WOx9Pi?=
 =?us-ascii?Q?gRZC3TkxfUB89gbg+74P/ctUixbCXjuuABchBojqX0XQuxjo05JgGKOzUxwL?=
 =?us-ascii?Q?TkClffID8rNELx0a5X7L7gpjTrxxt+yk1LDSkhnOixxXp96Tn8j5hjluWw3F?=
 =?us-ascii?Q?LyhCkLMgXNuCtiKQX3cr2MFeTLoD5SYFWE9dipnvSIxV6oVsanCjXzmin05n?=
 =?us-ascii?Q?xduoavOu4220XUwu4nndNQwLTj8DM+9ZMRAPugn4hcw46wi7++eeTd6hYT71?=
 =?us-ascii?Q?MF7WrO7nv1fTjjXVGrO0AS8yCig/bm7At+Mo4XCJdI0FE+ulMneAbTghjcRk?=
 =?us-ascii?Q?DbWc/A8sY4GkUWJpPQ3Mq0TM/y7eCPI236kidn7QGrxLYLP4/yenCPxoo0aF?=
 =?us-ascii?Q?A1imp7jQcQOxbe1H3bp7aE3+yaN1L6RC/ETcdZxV7z2r6pPSm6e/G5gD+Cvk?=
 =?us-ascii?Q?OelOpX9NcAEBb7wBshpcCBQBTP41nE3h8U91nmCp6Un8RucvEuPE/KecE9lF?=
 =?us-ascii?Q?Lxj9llIBqfRIwpIZzXlzS8nEt5tdPFUiV/RKILGrkiH5HpYhQgYhIsUyKwcm?=
 =?us-ascii?Q?U8LyY5hlaZF0MuSh8Fm+oC41yOUU6SsqnB5W3ah9EirwjLJlwMy645vrkf7I?=
 =?us-ascii?Q?OhlKRTy52cvjQm1nQVGSm8SrfqHb+Y/yobyK6BsmpaPDQ8OgUzXKww+9Cj3l?=
 =?us-ascii?Q?xSccyQzfnQ+bfHMey0sAsCEI3KUAX3V1ceWDOPo20HhmNboq/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fw8Fi2/t9QD57poRstxiDnpnisOEg1id0oQ2rbQ0AEjjQxnYJUkyBXIurohn?=
 =?us-ascii?Q?i7+zywd/3fs6DJPXVY0ZLmaV2c4fhGgUPUq6t3WG4Rgo8r7Gx8Z1hnQElEQH?=
 =?us-ascii?Q?N8MokEFfsggMLQncRPnJEoIRApDLcXZ585z5pHMAeQmlEf2J+Eo8jxMGO18+?=
 =?us-ascii?Q?XomFhAOb5rNDW5sX4VEVZW9LQIZx0nFZbV4cabPeUAgAaLyPeGyE+EixwLhg?=
 =?us-ascii?Q?MBpjghHnfSs7p1Q5btSP2wctBbF0vd1XTDYs952sYBNLpuYM/E0hPtslt4wX?=
 =?us-ascii?Q?5ZUHR4Na3JxQa/i46vqt9dHs986NyCywOgTFCdr28mVQcH17ymKtRvLWYwxQ?=
 =?us-ascii?Q?nMNP7FdfSWB5Oz3LZYruVb6p8QQUEV2TvA3Nzbj8nE33B9VrLmoSutOPM2Pu?=
 =?us-ascii?Q?UCjJBvUqvUcqIYpeieRbSiyjowIC+L2276VJGex3+HjvnGGMuDoe26pO4gRG?=
 =?us-ascii?Q?LsCHUWNgRtTAtAyi6fKySJgsheVmv9Q/2/hZQncz6kbTRFMO/+pceOCAVhQE?=
 =?us-ascii?Q?K16joH9W+VE3Ua2kzozblDYzuHTRwyLE0KwJ9jkcQXivfiy7SPAkSwYCjtSU?=
 =?us-ascii?Q?S5Lqa5i/niDEPZD1ebNWQuqI4Fk9wG/n/DUG5udNPrTM/TqVfCW0SGqrftjp?=
 =?us-ascii?Q?vdjZLwqWyv8fZqQiQPkU8QKvZlA6tsenDY0NDzjSaXVG3MNFbKsu/brkDnpO?=
 =?us-ascii?Q?wNSdGQ6g815QT3t0zW3Ce1tfwJNXAunronmGMoFEQNVwxDpF9KSARE2gLna2?=
 =?us-ascii?Q?oEIdJP8FcE8MaXo5yF/2jnc1WFg5f2e1LjzMwsZHqo2mzkLYCu28bDCQXxyj?=
 =?us-ascii?Q?eC9404kxTgX5VAre/6QZ0fAGrMt+YN4VD3fr7MRGtuTYkghtbuYohn2g42Yc?=
 =?us-ascii?Q?Rrst+BPxRcI6CRcQa82RFOk1AMTYcQSaVWMmMiex4FMSgtb5SL50A9g0Anx0?=
 =?us-ascii?Q?XUtEOsvPwAFVQVoDABV5l1zeM3IPr8MPhjRVX83G69tAVMjRMfcleR93PPPX?=
 =?us-ascii?Q?CUZrYe77NxTVNIga4iEyspjYpJ+uBaUZRyk+UpxPSIOcjDT2ySawcHybpTGy?=
 =?us-ascii?Q?1AfG6xTyhs3RdMRdSo88MnBMu6Mgz8plYKZwZVI+fm4TdCCk3dSteo75AJ8f?=
 =?us-ascii?Q?9h0fcaULahiGBiviE3fFF3b6wu+NpqBgNrIEPnXw8km7AtvhBf+Rwq8petZJ?=
 =?us-ascii?Q?ZtOgXvCeDWoK5v2h/kGAo7jjAZkKipfiRH150Znq8Mi289gCLvOWUzm9bYWW?=
 =?us-ascii?Q?bVRMTdgXnIPFGUWfOW4XdOWH3frMiB1g762CbruoPqopvwX25eSL9yyAiF59?=
 =?us-ascii?Q?vcJjGeV06/Kvv4Cp3IV/KUWQM54hjQ8zI8OgsmY58AFMb3eU5mtNUiIJfFbz?=
 =?us-ascii?Q?fQQ0IEaYI4agMBQ/TjgZq3CMKVH9YA024XgbOGT1rJVqF1WTJfpjUGBQfy4s?=
 =?us-ascii?Q?JweMK5Updmv9orP4uDNU5wl+Y2X2/UXhZudVxoFK7jwsOuNI2DWnHxMb5rux?=
 =?us-ascii?Q?rMBaH6k2EBLHPa28xjZwhQNk+hAK0LosjfOF/w3XdSlkdWPbhnk9T0zokn61?=
 =?us-ascii?Q?W5wcwlcAjBs1gjwhJrRhl3eDsRcKrSshwA3079o8DSc9KhTWdalUVA8sC0Jq?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Os6hWf9h3734TiK4kaQuQSEbtWms0hkfTU6hcBpth4XCpsxTJ9ws3i7efrZcdCXfUiUS13s4W7U3iwLIymF2TXynLurYecQY36/mV6R9rRHZODy5QFBZvmB650j+I3PZC1/WFMC12D/3OmmQk6dB4YbOllVDtBtTlH1rjhQvOlX85b9nhdp93WOGoO5r2IAhV7CO4FVuBlbS+fE55Afxg9Fg4DDwO0LbU4sWwZISGf9ENRmEVUhRF8QjP6LEkuP9WdgCaxsBP3eFyS4IzGjh7m9i/fRtpAJ8eott+9oWOVrxoVh7UM3Vd+zSEMswD8RbokPO2m1esnTL3gPOeugdGo7QCriDbimigf66CrR+RSNjJZS5t/Is/5hz9bZHZFenshgU4mSko1P5kBi+B6EUNPtD2xGuTdAypPM8O/HWO3stYSJmI2BKIsSKke7F6giVrfIEhf1uMl2nbxdsj8tk1m/2v5Er578P/fynm7UnWyFTKaRqtz10ErstR1fwDyWm4QyKbPhHgy6GyqHd7jhe6wa78faWxjv+3LL6zYjepdhOkHk0GnF0d+sboOXrcxgJQObrvOTHxaQMEiX0palICD8QVkbLASNkzQ6l2+h27n4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64505f58-b98a-4574-9d48-08ddf547c730
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 17:37:59.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKjt8Ea3+9X3Wxse2HJatFY3rgPmvHIU1FAttbmWo27h8+DL35IsDoemvwMm10sq3SGvIU6rQVcFdOyg8V9ye1FoihDRSRI0o7px87cxVeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160163
X-Authority-Analysis: v=2.4 cv=S7vZwJsP c=1 sm=1 tr=0 ts=68c9a07c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=RV78GzlOPR0tUAWTfhgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyOSBTYWx0ZWRfXzsstSIRoWpbK
 WN1s2OCzqh6gA23+diKBjpwh7e4P6VUGh7TUjSKddFO6w5r7S2rjjKl4gdptAbmwjByaIptDnJV
 FE/s1Z1ZVtBThNomgABtku3L2mtILexSCWvLTBObjZGjOl2MubHiftZz/NUVVDhYKpPJb63ASi7
 l8n3acz2V/E7kgyxdZWeQ3lwAxqQji2yQh4+qIR8Wgkq0sKrW4Ehh4fLteEoni+r9yhAiP3C24A
 3C3UhTEYhELTE3eVbtmwcWF6BlirbSToS+h41I36WWKQzYBEIRfQyiO/bQFTR7g77IWqJpflSU5
 mjKUxtpcQjB3EyvXWGVeyiZNO0ECyKO7QvGyjK8KgCfLTsoUs5yyOICNms4Mx2dtyBD0nstvlTO
 PQilGy09PK1xTHRAQM0tD8vlssokyA==
X-Proofpoint-ORIG-GUID: H1b_nVzTbGyMunA6BzqGx0lh-p-J-3hp
X-Proofpoint-GUID: H1b_nVzTbGyMunA6BzqGx0lh-p-J-3hp
X-Stat-Signature: b9f9ei9z1ru5owc4ph9a9ritqm5c3daw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E13A40003
X-Rspamd-Server: rspam10
X-HE-Tag: 1758044302-431045
X-HE-Meta: U2FsdGVkX1+t9AZ3L1SkZB8Z0E54VbIvLmSH4b0criNJudX/FjUaRo3RHxS1sSm6U7m65rFWQmGEkBMkP7dv+ePJ+NlgKdI6vIloYrfBctl5zKmx/wIiydBHBQsPKUtLZ605rPjDdLTMkojy70AlcyVnAuMVrIBnBh/myV4VlApLKeHwVAKUZXKV2pCHuD7r6t5hdXyTJkuWF6ie0SOkbWPS++Pz2U/fooKq6y8JdFdUs888BCTMEgto8PmHRAdOUACGXs1a7DswnWvgUYfrXGN748lskmYEr7NZ3T4+vmzndLi9UBmQlOfDtwfn/yoSd9hCcnEs8AonH53FlNCMr5Irb7/Xv6H0p9KiEhINJoBAyXrBhDvlEIDXAzzw/07QInSlfEUq8u14eZedLB2ega0KzzYPztYe18rNqVZxVWe9XnYLQfcH/rGSQGxIpIEpj3LHzg5mHJ9djgqXQ9Xtl6/mEy7NiKRMpagCgdJNv3lAGdOaT07bFlWsbY8Ha0yMWfzFNgcZnhkIzxjdRNS4LFR1lMz/d2emG7tJxA63A9FNqZT8kF2z49RpUFxdghswIrJZ860KDD4ox3U9/FL5UenzUrGLlHPpgrKI+ys2nsNl0tHzYhyW8Kqq4NEzcssJzytdc27kZBhZ68B8b43jSdJ/xLNzUOXLew9F1RGAH8c5AIVMZwutWJbJ2HLH9AADKiM3sJtq95D7ciHQrtZf4nkPQEXTIRQLXpLkfN+8OaIk86IhUyyAKShYOTmOjxM4bi2NemW6GQ85sUx4VS/J4nVc3eRHKY8VF+dzprL+Ndu2bGFdKz/OLeMaFCBTT6Ii2hfYy+LtKZo4CwOsLYoixWuKzO+jqjWSJh7k9Jj4KSIfsOJio3EbgHYxqoODVzT/lIIXmpOLhZnCUEtUPGy/FAdRfl9d3Ye4wh5ImHKYMz5P/yCHexAbOWlWQtkdEFVePYdyHbN9gQNtAciduXU
 IswMWMsr
 ybyPiiER2HHR8cYdCiMbhA92p/cAvEMaLK+ShpDb+d+UI3OYbOuyrQBi540VlzwlvZpGTLV2vIu88DLf35vth6LMaq2MG9MSYX++KWbJkN9Z6USFnqJb8fOPB9Rsd/NpZ6DNgt7LpWXY9Ihv8O+7xpA/rhwS0R5FPo52ckE+2+k2mxngj8nVmOPEYwDGwejokKWNydT555kdd3utFC0uwOOO/DM43zatnykQMa/lX7aBml/lLtE0w/W9FUk9ZVYQQxGqDBt472BnipnSx5QHIwOzywLq7OYNpDKOdZX31tUafotoyZf6FlSj3/LICZ8QL7GWy9D/5fzaVMjqZIydfpYMzMhXG00q2Ye8swnHUrHsFOZAbCBlzWumMyM6e3Ov7sBiAjZF7+7dzSvSNXg1aeSkFAetT4aXVsBfgDpG3fJX5STumHYYiykHQ7+mSox0Haa9kYVM0VB7kXBH3t3XpxdJ7QLk2NmG68cu6rXJE2quZbZ7HUGL1f0sV7nMxszPnfqJHBRICToU6/0nF9Nmncrwpf/GT9/DGrH2h2orRjbr2fnpGS85N/PObe1u9jUPLe7GUH5nc9aCbG0fTetzMiKTMqAqYMJUizihWJ8y+CbCkaORkxJwd8eZD/R8NMgrHevCIRaz5jSGK7jYCDWehLUjAN22/548kPeUCehqQEz6gyAkNF/R6XVIoR9eCVrJM0ZAsfTE66ucDS1iWw1qsoaabaDLEycfSohz79A/6eN1FmuoWLziHWaIc+xU9NGFmQTQ7MGC1b+nh9xxusSOP9tAiUtuLIpY2X89YJw9iXrLzmYsTQ8IKuw3v2/xQLi/Ky2h/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 02:07:23PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 16, 2025 at 03:11:52PM +0100, Lorenzo Stoakes wrote:
> > We need the ability to split PFN remap between updating the VMA and
> > performing the actual remap, in order to do away with the legacy
> > f_op->mmap hook.
> >
> > To do so, update the PFN remap code to provide shared logic, and also make
> > remap_pfn_range_notrack() static, as its one user, io_mapping_map_user()
> > was removed in commit 9a4f90e24661 ("mm: remove mm/io-mapping.c").
> >
> > Then, introduce remap_pfn_range_prepare(), which accepts VMA descriptor
> > and PFN parameters, and remap_pfn_range_complete() which accepts the same
> > parameters as remap_pfn_rangte().
> >
> > remap_pfn_range_prepare() will set the cow vma->vm_pgoff if necessary, so
> > it must be supplied with a correct PFN to do so.  If the caller must hold
> > locks to be able to do this, those locks should be held across the
> > operation, and mmap_abort() should be provided to revoke the lock should
> > an error arise.
>
> It looks like the patches have changed to remove mmap_abort so this
> paragraph can probably be dropped.

Ugh, thought I'd caught all of these, oops. Will fixup...

>
> >  static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long addr,
> > -		unsigned long pfn, unsigned long size, pgprot_t prot)
> > +		unsigned long pfn, unsigned long size, pgprot_t prot, bool set_vma)
> >  {
> >  	pgd_t *pgd;
> >  	unsigned long next;
> > @@ -2912,32 +2931,17 @@ static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long ad
> >  	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
> >  		return -EINVAL;
> >
> > -	/*
> > -	 * Physically remapped pages are special. Tell the
> > -	 * rest of the world about it:
> > -	 *   VM_IO tells people not to look at these pages
> > -	 *	(accesses can have side effects).
> > -	 *   VM_PFNMAP tells the core MM that the base pages are just
> > -	 *	raw PFN mappings, and do not have a "struct page" associated
> > -	 *	with them.
> > -	 *   VM_DONTEXPAND
> > -	 *      Disable vma merging and expanding with mremap().
> > -	 *   VM_DONTDUMP
> > -	 *      Omit vma from core dump, even when VM_IO turned off.
> > -	 *
> > -	 * There's a horrible special case to handle copy-on-write
> > -	 * behaviour that some programs depend on. We mark the "original"
> > -	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
> > -	 * See vm_normal_page() for details.
> > -	 */
> > -	if (is_cow_mapping(vma->vm_flags)) {
> > -		if (addr != vma->vm_start || end != vma->vm_end)
> > -			return -EINVAL;
> > -		vma->vm_pgoff = pfn;
> > +	if (set_vma) {
> > +		err = get_remap_pgoff(vma->vm_flags, addr, end,
> > +				      vma->vm_start, vma->vm_end,
> > +				      pfn, &vma->vm_pgoff);
> > +		if (err)
> > +			return err;
> > +		vm_flags_set(vma, VM_REMAP_FLAGS);
> > +	} else {
> > +		VM_WARN_ON_ONCE((vma->vm_flags & VM_REMAP_FLAGS) != VM_REMAP_FLAGS);
> >  	}
>
> It looks like you can avoid the changes to add set_vma by making
> remap_pfn_range_internal() only do the complete portion and giving
> the legacy calls a helper to do prepare in line:

OK nice, yeah I would always prefer to avoid a boolean parameter if possible.

Will do something similar to below.

>
> int remap_pfn_range_prepare_vma(..)
> {
> 	int err;
>
> 	err = get_remap_pgoff(vma->vm_flags, addr, end,
> 			      vma->vm_start, vma->vm_end,
> 			      pfn, &vma->vm_pgoff);
> 	if (err)
> 		return err;
> 	vm_flags_set(vma, VM_REMAP_FLAGS);
> 	return 0;
> }
>
> int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
> 	    	    unsigned long pfn, unsigned long size, pgprot_t prot)
> {
> 	int err;
>
> 	err = remap_pfn_range_prepare_vma(vma, addr, pfn, size)
> 	if (err)
> 	     return err;
>
> 	if (IS_ENABLED(__HAVE_PFNMAP_TRACKING))
> 		return remap_pfn_range_track(vma, addr, pfn, size, prot);
> 	return remap_pfn_range_notrack(vma, addr, pfn, size, prot);
> }
>
> (fix pgtable_Types.h to #define to 1 so IS_ENABLED works)
>
> But the logic here is all fine
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks!

>
> Jason

Cheers, Lorenzo

