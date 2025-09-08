Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589D4CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29FD6B0012; Mon,  8 Sep 2025 09:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8F86B0022; Mon,  8 Sep 2025 09:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952EB6B0028; Mon,  8 Sep 2025 09:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED536B0012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:12:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 374E21D8752
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:12:30 +0000 (UTC)
X-FDA: 83866122060.11.1250658
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id A8C88180007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:12:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aVWI7bsU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OuP1uHjV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757337146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YU+Tu05/qHr4538krBA/Kl4wclo2Q1y0o2qsoqpFs78=;
	b=1kTWSYcrV0/nNRhYRu7yY8+jpTPVVEAdZ+omjk1o/iufCijN0/917cyVJZsQRJ3SVZseI6
	C/grMvSUet8JhXgvCw2cjYFy9Hj073vHIeEKG1FOfXD7jfmBbTv37+v+wVzvuZ7pFqoyhz
	9eIi9sr9q09EZKmhMDfOkDj7ubn+8I8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757337147; a=rsa-sha256;
	cv=pass;
	b=bgGF8UW+FUU7YYYfOy1Lw5kca0f4VJ4OfPuXHhpUPIA7TZ2j6dmEu6d9xXcNLdtATpbqY+
	N+blcLjx/Not1whl38NM0k113da/l/Va6P3dPF9bqEVfDkXxyv9brCWQoJq188Fe32LgrS
	bzNH2GXvEcKj8drgMePiVKYmIZ8cNVo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aVWI7bsU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OuP1uHjV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588D0laT005678;
	Mon, 8 Sep 2025 13:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YU+Tu05/qHr4538krB
	A/Kl4wclo2Q1y0o2qsoqpFs78=; b=aVWI7bsU92q5HoaotGSTNKi3yo5F/aaZ/R
	TzLpCHmF/569Tm1OKDdU97NdxL6SCceWKUzbvNBlFxZTtX8xcDqdc9xHHJBn2+Xk
	VbJUCmbdw+PICIw+3mkyhjepBWd5WVCVDGHZCCVEVN+oZb4YcDpUscycrxdqMAZr
	TP7zxP9HeWc2611A+CmFd7wqJzm8eVDZbMg1DrrT+bwl1yYmPpZ6Rgp5A4U/freH
	SuXCiucyohIZy9fX4YVeRk+ll8Y0+7ObZapZeA2pHpSOvfDBkIguoZsmUCBHKYy8
	snX7C2On58A1IRWyDJ/Sru+4Sd7aGIzhsQ+baZm366G6k/0wT9Dw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491y4br3bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:12:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588C2iI3030831;
	Mon, 8 Sep 2025 13:12:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd85ny1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j23QdWw3/auCbAxNg4zz82h1Gdi3HEmOStSTbMaZh+nglKe73Dg0S93haclLnaMn3Vt87v27unkQq4pJDSdiNATczb5PpARqGQdtIUhceJEw0E/L9X2oVyMQfhAswfk0WDg/HYRC9pJeWUqkkPjcwf+qhlnlhOS8M9rw5/9E7VL5YaiPHY5GNDzH+tOd+gDW+oKyTsbcD/sMoo6Alyv1rN/JSkZaqjxK6gtzLkq9p5F2X92iG6UV5bwlnttZWrExjMW9OtUKfqzZWCOVS5tnPFpJOwnUjxsXPiu4S13UhRnvwqLYzARVD3EBZj3Xso0vF8ImQP3fWLGmFfAXG4wfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YU+Tu05/qHr4538krBA/Kl4wclo2Q1y0o2qsoqpFs78=;
 b=Wh1/zn2Y3h9bOv0XEOEv2da8agtenqDqIPDZSM21u6oR3rh9U/wbsI5L9e3y3pQDEDSXNYMX6nTo7JGGumyRN8VqvN/aOzIR9TXw29Zuj0fbLc8MKphLbTyA/2embO4Vz9I1R54wfmJQc4/5oq+ZacSabTL13/zjpjPn1mELv1tDnt/xtSKp9bbAwWnVWyFK020SZIi8Ud6xFxOrUR1lcRZa7fiuoNLrluDeG+2o2J8tykM1CeARuivGGC6WUlp4EVeYJpZ1vpupM1UMmWyFl1Ak4+D9kreW9WizTF8dR/In+2hWCPrILjHn8l9fcvBY/31f+PBaY0v1cN/2+L+11A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU+Tu05/qHr4538krBA/Kl4wclo2Q1y0o2qsoqpFs78=;
 b=OuP1uHjVueGLr8BIOgwvCPf5/+7RqHR4MadCJ43NvuhcVUb2guf5vJdioLP0B4XwOeXp3UvdRij5g8UoHTAUtwTiIOsKUdK2edoPTiUh+7YYI0yWtbEFI48B3k3drkWoUZeNA5hO/ryoOIPM18gZQKVkkqYMZj2w5KzlDVoKdDs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6345.namprd10.prod.outlook.com (2603:10b6:303:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 13:12:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 13:12:02 +0000
Date: Mon, 8 Sep 2025 14:12:00 +0100
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
        kasan-dev@googlegroups.com
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
Message-ID: <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908125101.GX616306@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908125101.GX616306@nvidia.com>
X-ClientProxiedBy: LO4P123CA0434.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e72f36-0b5f-4875-7832-08ddeed94d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7dhe8hPlnAlCFZ30RY41AzG1QJuu0FZelXFaI3lTEl1GOmwHUXcBbT4DkkEq?=
 =?us-ascii?Q?uN6m7KLJ5z0B4v/Vix+wzdnm5hxhx1sV8uqszE1bzei4gmqJQbYWzlpzD7EV?=
 =?us-ascii?Q?8H5ppPXfNy8KBwYInQEHW5oQqgNIlhcfiFilG0Q9yBTqisxak16rwJn42+oK?=
 =?us-ascii?Q?cPZFw3KDSVovmPkY0JYOQL/ivmiAt+FloIN3tR2x50N2Z95g0ce+Fq8l/17A?=
 =?us-ascii?Q?pjlS9Hzn9Dg1ffESw5aOHbgJbF+0t1CRiw9VJ2yCH1mupcSCUuK8pjU4FbWC?=
 =?us-ascii?Q?IEYtjfMhDsJWNrOsM+tI1vf5Di4drFzF+J5k0GWx0y3Jqma++G/gcQPtr999?=
 =?us-ascii?Q?9NEprZjuy++R+JTUAcvfXtl1G9Yd1yDYa6hU5451mChPUf+EqHCdnB5H8ebA?=
 =?us-ascii?Q?w+8K03By9mZUuBUx/Tix5rAnXp2TMgsA2lst0deR+KWVqEP7RHjYZdEx2+Kh?=
 =?us-ascii?Q?zM5Xo5zi8aa0/6mAbvxoj++EUJEIbLH0bdCgsiXsOHWXi8llWEs8BQRj1Psu?=
 =?us-ascii?Q?m4sCrQscVj27juRqdff+ww1hPyfgsADDAlcuofSIVDYAWdY92ThiKucnGB7y?=
 =?us-ascii?Q?3yFNKT3kyi6oov1JCr6Fh9E/dt9ekIlN1EgVPM+OdwDCMOa702sb/Oq9+psm?=
 =?us-ascii?Q?pyw9hVBTNKvQIhxwF4INf5QBOrcmtClbBwcPaZIZyJdxsDiQ3B7p+pXNjM6z?=
 =?us-ascii?Q?5x/11DeBrBtGxmvVH1+K3gDSUzcTnE46cxrXul5vP7AL6JzHapj5IHQ8k+N7?=
 =?us-ascii?Q?/HBMhs9LyAR07dvA5kWXk4tuYuhUbGnojokE9VbpvmesZ0WwVBMvs2v0sqe9?=
 =?us-ascii?Q?S4Jtm4hBmCu49GnWX9B5H3A5b6E1ESDcS2FQ//XMroGNRW1NoIj3Pif5oDfb?=
 =?us-ascii?Q?F4If39vlwO1Flyjp0e9NNnlASDhyMyEop3fCzIL4UXjpLda0y6VXeGGkJN45?=
 =?us-ascii?Q?ZLmWpRAJJE9YJZTW12apzzK+ezGBzWvNAjPeXW7EDW3kUZon1SBXq3L5umct?=
 =?us-ascii?Q?50PuUONy4ydPLBh0iE/hBTZOHYI3x/LEVwLJpVP5WWKyknJkBDdPmFVesH7F?=
 =?us-ascii?Q?Ct0JQIUVlG5N+hG+bGlkghzvJX//tQhzv4KdeovL83U4eAWMq80jTewKcLZb?=
 =?us-ascii?Q?n8YCIr/2bktX73/QeHxDPjCbgqwt3kyBVBycVoBFOm7ulKLLFAEbcCSzj1/m?=
 =?us-ascii?Q?806MmV7WVHywTtQ8e1eyjvqImukGic8qXeZzn+V2iWvHcLHgwktcGZsj642p?=
 =?us-ascii?Q?97e/kgzag1avxKgveOGZUDASrDHHTt+gplyfUkgM6bTEN/G/LqhBYL8JZTok?=
 =?us-ascii?Q?JN10UuD0asO+XxzU4ZFuPpV21/JgXzVbhXI14oHD7Hn+yVtSmulohgCuMfrN?=
 =?us-ascii?Q?61ZzbXMor7PdpxVr9AFqNceUEvxiI7rXsUFeVEQ3G4sQ2r+Yf2lN2bXhJGVs?=
 =?us-ascii?Q?adM/krvWTzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XsqS0KiTGrnpPlEcU+MO4h+qO17FcJvQViuXWHRz5o1xDzFTmi2ZJVI+KYE+?=
 =?us-ascii?Q?xKoRlglJj7cxCwB2Yw2k3Lb+kRNrb0UIIcl4RdkGz3BhK/rnQZDVTLqNgblE?=
 =?us-ascii?Q?3tYWCPMCm73Lc+QYbkndhtLtm9O3gaKS2tkqvsgtXo6Csak9NVagcijDocGk?=
 =?us-ascii?Q?EkiYB/kHS+TC1bwYOBnbsY+qlKahZIIjsfXoUW94tyHMR3yxSkPh6v9MSnAx?=
 =?us-ascii?Q?A49KCGqC1tPvCKgOFzqqEPHhUohdv8c1kLoxcQbuxD2cXcC5DAvjkgxcK/kM?=
 =?us-ascii?Q?xNJH8o2kIVFfQjxh3HXnWLFy+RZv4ojOy38WRhYJH2aoOQSMC+SnjbX5S4fV?=
 =?us-ascii?Q?TdqpiAreub78NcEXE9OuAr8sYwux7riCiag8QYWTVuSubGcKnEOXhtoUkhwF?=
 =?us-ascii?Q?+O92sNyG49JR06e68cymr0MorXjvguIA2zGWuxCcc3bpxi2WUyVHsaSJlDWQ?=
 =?us-ascii?Q?3UcdaAWaZGeSK1xhMBRb/Ago5bX5rclnOmi8VsARSGC/Cbftf6BY8IxAtY6A?=
 =?us-ascii?Q?+Dkccnm27F0bhEokbO3xu5wTbWyonZSZgS0iNrh7CIP50o7xXY/wvh8fUVyR?=
 =?us-ascii?Q?RzQ+MEVPp4F7ttKZk4yaVtGE6SDFPpskCzTBjNFhv3x2PaJazCM8xQfAHEcI?=
 =?us-ascii?Q?Koz8pGu+fRFMP04tQirQEAUeBN6TXCSfnmSiu/4cxDv0igR4AhafPaVpht1X?=
 =?us-ascii?Q?rOs/tPPLRZZuBN83eh9UXUMJinesYV+X+GmqRzT8K5aCN2lvfd5+eHcn6TIs?=
 =?us-ascii?Q?+qjZubGbAKKjy56XZqVowFiDLz2zCNrODbhv6Jn0IPyoTQ+AGcz0CTRmTx54?=
 =?us-ascii?Q?gwq484HveU0mEaReBL14kvx4mewOR6W2gVmtuAKb2iDqm5mb6rb29FevSmov?=
 =?us-ascii?Q?d5qxXfDVVi7ctZn6ZzWJ984kreRKckT+kcL8jVzIjIwqkDyhqk8BnKxjf0gf?=
 =?us-ascii?Q?g2G15j9+r0l06KmfWujXDaHQEs804pTOqrcIv3fLQgpmWTUcy4AwbniiiOSw?=
 =?us-ascii?Q?r4ugdE+L/FPlFA13UM+YYFyvg5NF25OgHE6FM8J2DE/kUNICvPACvsN6pZvW?=
 =?us-ascii?Q?7JacHMu6u4VURvkZxWprAQ+/SmjSnOe90cSTvKusHpiieJmUCWt8yCEs5HY7?=
 =?us-ascii?Q?JG6ux3X/oHcSi0ADltg2E2AS+5RCmWNAYKpj4Wfyy5IR1N7QHQiFDtJsfhEv?=
 =?us-ascii?Q?WfKzzck+LT3VsVLIGu4XQrbXWO1m4/mH4wobiHcV4QR72gm0XJbrrtrfyuZz?=
 =?us-ascii?Q?+sj41nxqRxQ+K13PEGyQbSJBk8H16IaQ8LJo5pnnpBsP5z02xm9WNw37e3pe?=
 =?us-ascii?Q?+oetV0280ayhMk9scmVMTX44c8mDcjX1kOPuS/WX1878aTMw9f5RYBd5+7jR?=
 =?us-ascii?Q?hNKfd2aedPiherwDqzdmYJla+hBfs9rtdsA6ZDV6hKolcB0Gnrwo2bGr1VaX?=
 =?us-ascii?Q?wFwWm+0DJyULQpZzx2R15b9SNhjJEGkNxopZbRIcURnBk7mRpuroVKovUyq5?=
 =?us-ascii?Q?6UGVToOK5P1Z0SO7T83drtqlwY+r4WTd/pG56wCm9aSKzh/N5sjbUR1V+gid?=
 =?us-ascii?Q?LFe1hz3Z2dmR2hZ0dNlgFJbSuIEzqwoqx+L5HDgGHh+zWvcbLcpValTBYR+r?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sbcWw8Z7Hw0KbIA52/SnhYqTcSDNKhMSRxB4qoPmtUCY4tayoi3sCrvyQgXeJDcXj9/I8xXuq0li49IAXPfKt7T37ttA/BgN0yhJjQgkvbX026RqJwtFAddOdRP0dTVBT4y2BPjJIKivmw+aeFrbNVimbymc9VR89Me9NL5zZbOj4dkVVWLJ7x8nU5Rc8kkNJPqD0dS/DAzZ47kysHS8WNQD7/Pyf7DbU4u4G64BIKsjJDtwzXEgjMNuJBM3OQ91QJs53iHIkOliCwxgiT000b+dU52AmxCi4wFrjpZbAGwsVPQ5KhopNSbcnrfYrQJlcFdLNvB6Z3WunLajiaWk5r2u2S4ETLK2slZXYQUrqjmaMeDGFmHH5UwjAnVgZfZPnlyhc8aHOBeR/SJ21S32WBci71hjukXEuT4Kt9rMnfacghXkiI3ONTfa1EPGwxrphUx6gnAXobXh3B5ngVNmhpllz85a4VUteRGwgT1k6WiiWurJLyNvHIDywMFtsWiaho95V0L2XRJNLNDsHwh/OkPtwWFrYDiIQiJpcIZ6+t2F13QRPFqjcSwMVBbLi263mw4u6gBvVgdKF/TQ7cCls6Nd5HOVVkBOX2bk/A/bn2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e72f36-0b5f-4875-7832-08ddeed94d0e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:12:02.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGu7aHV/cenYNEB7Qh+vB2KtXSCY+u542pSiZvDErI6/fuYNZdkozXku3zWZAJBmbt2MGddqQGW57OWrHcBuEtdhGx+Hnh+YSfiyQffMHSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080132
X-Proofpoint-ORIG-GUID: 5El5QHdQmyb48Mh7Z7e-cCEYzNbV8N4d
X-Authority-Analysis: v=2.4 cv=ILACChvG c=1 sm=1 tr=0 ts=68bed627 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Kq8dobMbidePVuT2iQAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDEyNCBTYWx0ZWRfX/PKDMfaTk/Q3
 7mn+qHktYoNNdH4nDm7BJlWp97jZX54KWzWCCx/EYg41uFO2+k6WXgKvGfRWe/Qht2RxN0iqn6Y
 KTWeMP+8I28axWf2JxlwDu576vFqmsv0Y/bnhsPK/dRTNe4Z2BibqV5jkbEzHThK5SQ8Qa9JyBL
 67YV3BSkUDkqb3Xs2ftRez+nJELFoDxfv6eT7E4nFPMBx+yb6ggEMS3Dwuocxv0/flI/hKCSsLM
 kvqVMVyy3kdWx0yrWE8Fl/f8Frzo47fWMiPUlijS2CuibA9M9Qn3SAdL3X6amUrgC/iA8Pv0b9C
 G5e1a9MhF8ytQmL4ijngUdGFalnkQ8ygvPqlJwqnWHRNBzZt1RUpWxW+NzYiYmNclw7KCQf7Ead
 nT7qXIsC
X-Proofpoint-GUID: 5El5QHdQmyb48Mh7Z7e-cCEYzNbV8N4d
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8C88180007
X-Stat-Signature: 3pmrxk1x7xo7hwsjcchos9w5sdp965e9
X-Rspam-User: 
X-HE-Tag: 1757337146-544584
X-HE-Meta: U2FsdGVkX1/SSaMptHd+KEp1lgb5hRk+VBZUVINXz4VE+akhGQIwfQjAPns8x+4qITwhGZhfxs5xWv2FczvoxQ5FVFu2S959hzOvYEg9Hi+Y0JhDbiVvICcR+2M+wOZ7o00ON7ksjqPOV+lyIgKbDoC0wk+NXaxLZjU3ntA/Nf060fbRQafWtu7R6fB/6/Cqe09YRIXF00UelAwWL0e5pBdxCQaGIHZgu8ZAisz3bcNDES8v6olyoEGszYUyTAW/IiEf1rSu/HJffH3naUQGYIEsr1oC3fFBSzyHmmPqLFDNn0xyGal24bJCUb6nwRjB3udqh4xqpmYvBUSDu98du1cEGzr21dRhMMsSmI8JT72RgiBYoYqZBiuKwbZj/CMvdfceD9opdYBUEpcHW2VQY2ce0hk1id4QDqEF8RZA1cdiPjOFG9eClY/E+8k6SXCxHWYQQmhQP96msUqOKIvmprrrLDbb5XrM/K220jWWEUbPfJsCGpq0/E7+QdLHAoia96h4TTPRZgg4b/m8khtPkn8Lgk0IXH9rNZTQvkYjntbgu84uxN3UsoZE8EhOOg/wE4MMeWpQtKPF3ZR6kWzVnz65P6IOnLWZhC/R5lTmSYJthsIGh+qBBR2mp/ogZdd1ZACh2yFixkHV5ZK1s0I2JeTspz4fAkIr2UWPZgrLwP3ZlBkUKfhthkL2hChTdEHreDp42xM7kADHC3mxYJ61iG5uPIyeKu/AEg8f5JlFBzXQECHUDHQ+W73afPFKSXp3wvLPPFh5+yf+lOdYDesGcdDa1FyhRtqU7sLmSTR/wjghIbFJDBdv3wwlErvL5jpEr/k4VpMtW1npr1xQ592arl7w0BBvdVrH8QTEk86M5NGPqrSUM9vs6uD1W1XSFwipOtqKFROZG8OoH7tPcINEkJh8OXzXbqY8j0VbskMHyAJ2axKC0wZN3jvRCcMAhIvzonEWYsRWzwkSVcdQc97
 lrD3cPmi
 XlgoPAs7yPE62SoNmbLXZ0d8Ydjhyc0JR7uZ2PT+6ETcEbtkXHvJEd8ukTHus8PAfWLBPbUN3CD9s+/glZFNmGIrxA6gBaP2Hh+sMJKgJrG51CPZZUVnWVgyUR97LKstBEh+FBfOdiTQl42WgjEuByjLxwXdsNU4inUuiD2ueZjlYYScDRU5YVdiOtA/75nbhMSrVCPgc7gR/EEX6A6ESie6hyfedcr/ygli0kptGEVeHzH59j9xP6Wtji0tPPSoJ3Nm/9bHWownykS0xawZ76NrhQmxAfcNUJboUQ6K77QHx1sPqNFdy+8P+pjXbmiTqHyFneIq2MV1kPcOD2MLsXcVqmLt6cDYN5BdMUV3qXixA3FjHOv5tR0296fZq+tsntoDYgcYMWiMxcNvLxw0eF7x15iDWIT7+eZrrEWww0fG4LWN8NL+ULZF7aamHHWbDu4OzaUmLLLZVtJrVzY+JK/f3BfP7lpA/uLm+Sc4hNle/NicMOWFkpdY5eUPLqu9StD5glZAjP5OQXztLEhbCL4b0kSA6SILTNrcTu1XKqgFgIbnBkaOR5V9clHgHoRFEeHb/IHCFH/7WmdvBpZe9RbFou3TbUX2kd6H8lTEV5flhbhg/DF3RDgTjy3/iGXh7l+b+bzfkO26wgBGQLSe05TKrnKUItT/ooKo5zEX6cP5Bo/eFa0vCiTdJg16DPPagBzc1xtnwOa5Zl06znS3RcXs8KbjYS8622M++iF3SemwBattSIOeat+8/5w8U4+rXRd1HEhAa+jgpZTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 09:51:01AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 12:10:34PM +0100, Lorenzo Stoakes wrote:
> >  static int secretmem_mmap_prepare(struct vm_area_desc *desc)
> >  {
> > -	const unsigned long len = desc->end - desc->start;
> > +	const unsigned long len = vma_desc_size(desc);
> >
> >  	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
> >  		return -EINVAL;
>
> I wonder if we should have some helper for this shared check too, it
> is a bit tricky with the two flags. Forced-shared checks are pretty
> common.

Sure can add.

>
> vma_desc_must_be_shared(desc) ?

Maybe _could_be_shared()?

>
> Also 'must not be exec' is common too.

Right, will have a look! :)

>
> Jason

