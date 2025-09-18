Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EFECAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BFC8E00E3; Thu, 18 Sep 2025 05:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B439A8E0093; Thu, 18 Sep 2025 05:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AE28E00E3; Thu, 18 Sep 2025 05:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED738E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:11:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F270160846
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:11:51 +0000 (UTC)
X-FDA: 83901803622.13.9C43C36
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id C084318000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:11:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FFjepoht;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=epMPGkoV;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758186708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKThfl2gC+53Tuq0Ogy6vch39D32nM24wAfYWTCszDY=;
	b=PpTzsiazjtojiTwTYoUu/h2+nFQCmlsU23IiCZRXPk+y5T7jZ+M/yhQfTq/4b7TiuQlYMx
	tRqap3S+x4L2YaaAtUNH1vnOU0muGuT4swbewPC80sVRBMjijsA5iikccUZ1DDfSnwp7rI
	eMTiCKessEtbXtplYQi/dgT8nabpRoA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758186708; a=rsa-sha256;
	cv=pass;
	b=z/2Va7is0MUdyGqnaKCwfl7JUytBnKXTS1PVwBEbIokEevVKtdRKupdgEbnYMSJgwFPKIo
	EdKrYvRpm09PC3asP+8zJIfvwtj00Jx16ScGYwqynymkce75riU08nBdriYiPY1kQQgOBD
	NBTC4vRMRLk0B8rhZo/O8JOrbzJk0HA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FFjepoht;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=epMPGkoV;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fuHO021221;
	Thu, 18 Sep 2025 09:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dKThfl2gC+53Tuq0Og
	y6vch39D32nM24wAfYWTCszDY=; b=FFjepohtfTD9qaam9mrcMyQRFupUsEa0xm
	VelFN33H5TmppqBM7keXkEcExs3rIb970NdKgTnajFRfugqxM+m6c3raQiw3pv9+
	mdmvh3cNlKIL3ILvXl2DEE9WFah8ycCS4bpKBinWPuyI2QtM5SP/Pl/QQrH4BL+y
	AjZzBLxEkgQZmfvFND84mgqQqpv+TBojKAK+6SVpW5WbV35E+lsaJLlUjY994Eiz
	h/a37WcuyAt0Hy0YNxq6GQM0COXk+zdLSn/okB1JdGixYKQDxKCs/c4vYBR9J2S2
	LZhoiaQJpm3IU90T/Kzo0Se9fKssZ33Qv3dk+O1FGEsVmYssutpw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9u3hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 09:11:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7Y9J2028755;
	Thu, 18 Sep 2025 09:11:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2eugmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 09:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyYF2TuomaxkzzMubLk44d7+w6LrTSi9ILiXh59VPltCTbp6oHzb+EY3LUpHo9JvnknUsyDnduBoKuzWcIoC2T0IDqrcBTU6tIBTySkFt7fhuu+7vKaeXlKDyOp0kBhQ98maFvtnFMuScDVB4VIvgXBB1tVSk1+/RxMNFNQAdkkicuxD7ABaoh3nsXkbp1YCSA+LLwwSECaJKI+NzKE3/W6lx+8q/OEoCLISdYg5FwVmh1Ut4tUIIKhqw4i8T/mG2/4Qq9LBd2EKsJIpp2C4pEURQqSGdgEWlv9An9ycLyNfWWhF5Rei9e+N1gMDLXQWl8Fz4UVeYFSgJ4voukPpwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKThfl2gC+53Tuq0Ogy6vch39D32nM24wAfYWTCszDY=;
 b=jUUktKouznQBK7U74899tG7E0cQ86AfO8piy11NAB4uOgx5kBj+my0yG9mfmsetAbQWRKRtbfgaZrQne/oA4Tslccdyg/dQHRFvP7UNwRUAHv0yue/gcl42rbm3+BAflKO94VqgyxGLB89o4EFQZpdmOsKam+7AP0Gf7n+GD84LiXb6BPcEqb7Z3KRAXsFSSipZqdinn2J84ccL3uOWz0IZYaxwzs3aEOUWhFa/vICJv9Dkjt4p6EFooZ4n6OPyi5lGhS2nDS13nzJbPae+KaOhHf0l2VpyRNZe1GD4f0NMox4PDlrO4i79MEYhnHHJ669XBJfpf9Shn+d/iZ+wLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKThfl2gC+53Tuq0Ogy6vch39D32nM24wAfYWTCszDY=;
 b=epMPGkoVUhI0bwmYpw64hn5MhuGl9sU8zJqM7Ar1sW5faUYf8Y+yCJRYtF1oSSuFRgNvLop2tX92f+m8vmR01fjxzncrTBMEldN046Js86mTZwEEB1frBx6iJb88vX6WIk6ba5VaHU76F2ARIGN4Xh5b0mMt9AbApLVU0mSoW+U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 09:11:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 09:11:14 +0000
Date: Thu, 18 Sep 2025 10:11:12 +0100
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
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 07/14] mm: abstract io_remap_pfn_range() based on PFN
Message-ID: <96e4a163-a791-4b08-a006-bdd7ebbecaf9@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <4f01f4d82300444dee4af4f8d1333e52db402a45.1758135681.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f01f4d82300444dee4af4f8d1333e52db402a45.1758135681.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0122.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5991:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c54b5c3-4c76-4aae-051f-08ddf6935190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MbqbgAf9n2oOb5W/NzemYhbQp9MVNOh7J8qTV6ZqyeTgAtrTKwqASvD9VRXy?=
 =?us-ascii?Q?kgKVjTtgXvaw/ObwXWfi2y4CqnkobuLCdZdXdfb+lS3VdyNaJOpObzyKLTNS?=
 =?us-ascii?Q?C8naXxfnVqx0owPp75gX++UGvoZ1BttGZOwPYmszi9L/M8hYQDoJxzkb3bqu?=
 =?us-ascii?Q?HCZZhexr2PcZwNIiNwHhDhv9nEbfnw8W5LDuyni8j1qINv+Lpf+xWkRkF+PE?=
 =?us-ascii?Q?o5nNeW+USGNJP2Ucia1V+dyUf3+jkd9wSYXVvALuUo+YqZ93C8/BuwaFXjml?=
 =?us-ascii?Q?o66bRqMiZcFj/WhsJMrkOtmdDOVBBEXGBKSv7QVDKx9F1J+N7Morg5gQTpfC?=
 =?us-ascii?Q?lRPqSrfeWZ28zs6NojCCpPtKRPsYZqv2ZHq0AKXbQJiJQtMWNTCtuUDdQ2QY?=
 =?us-ascii?Q?Cfv/SDIbQX7vtfgRpRJpCwFjve7zlP/CNF52NJJz2enq8BPjZGX2nQHfyLBZ?=
 =?us-ascii?Q?ktwhgZm+jZz0i/KsSRvxdZpGcZPs4r/k5llOINBjCiCMqGp5a1kw/lENVagG?=
 =?us-ascii?Q?EWkGYwnCDugjGK65P80tHcwx4CQE0iiHp6Qj/ii83ykJvsGen12ZwEm02nxO?=
 =?us-ascii?Q?7FbJ4ry2P4YzR4hOfkiRwVBznoMDXbxu8/tJcoZS1ktgDhEPx18Q5U59y0Hf?=
 =?us-ascii?Q?kK8Rq/28/UHEx73b0tOCztMJmnD9iY+hVgIyvxA9nY47qX8eXdkBdwRnyVh4?=
 =?us-ascii?Q?d5IEgyT1MqkZSF3rdSmN5QXrD/aduDAsKBDJjgS+oH/DYzwmRiqa58LXIRDC?=
 =?us-ascii?Q?czSv7OpCtXlVNUVIVEbWU/HcuGrGd0RZ89Cuz6FEMSvfyjBkPWwrSuXu30WQ?=
 =?us-ascii?Q?++lVHZLUVREsmbXF3Qem1EvC1tTtboT3/1aWpxsGz4ZbcQ9VjDvynrSS+/pP?=
 =?us-ascii?Q?gDWZm0azgHuebjSAzdjRwjILWiz9fTRSiJS33R1C6eF1bIP6DVNb58f2Q8S7?=
 =?us-ascii?Q?vtcNYDSS7CNIUW+OxhnCLtaip3cyLdE/Z1mxf9HuWQmIjGGZrm5mvnVVmKGq?=
 =?us-ascii?Q?pzh3kPBjwAbPrsf2M+beSADVXLHU5v4u4o30aqbaWsVNgTHeWLY6FTNV3JCv?=
 =?us-ascii?Q?Xjh+Zl5g0w/q9Hn5qm6+uPiYc6Cw/iOCSSqh2SLTqpt9l+wZ3XFF0gRqpwiR?=
 =?us-ascii?Q?lzyKSrdJL7VTUnXa4tgpB6wXAiDGyCsboeIAkTCTbr/r0CXj6OcKEa/8MqZ9?=
 =?us-ascii?Q?z8MVXx3E16Chm+oHUwKiVUnDmEUl4+I71hz583X49aSY8EDKwIyhg2nSgaox?=
 =?us-ascii?Q?/SScm2IQFX3r8HSd/HOKMlQa66hwFeoF71sziqLVuNx4ckVxXicSm5UTqeH7?=
 =?us-ascii?Q?Gm0bg70NrvjYfiOfGgrfbe5rKr0UgNtywY/ypwYnfVURy8IEP8k2eMkLEWny?=
 =?us-ascii?Q?QRpDNrvz4SPvFWqHU/B3sfwfQ+4sQMOERNoPPvZwxgblonZyq/AraJ0jh2kb?=
 =?us-ascii?Q?i0r6TJdkHMc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tZCoePQpNjFfqBigTY5a7RP8Z8BHR+riCGcrMrO9Ve0kM4fV+tmZ60QU3e5E?=
 =?us-ascii?Q?zKbo9clMa2+XVXUYpEDPAof+bZmVxqZj8IHJ+iM7j/c3GxFvuJpH1wDpTMUZ?=
 =?us-ascii?Q?BmjNpUITzYPhfy2Mttbq1szgIv1e1n1fKJHDMyKeji/vzeYSaVeMyzNv4XX1?=
 =?us-ascii?Q?H2adEKJ8h85v0mrl6F2iIDbOMQf+td/wr4yUVCfcFLH5Nz9/rZwE8dNbSwX1?=
 =?us-ascii?Q?F+Eh+0Po1QMqp77xQCnTxLPx9USciRMWncubla+YhLNNQ+a2PWuoVc2qmKza?=
 =?us-ascii?Q?zrtb08l6FhWWhFjd3ax4IygF41QHl6gy8WabV1Sj4Z+YdUenGE89lhQuvRJa?=
 =?us-ascii?Q?0+YL6UBGZuNYMlX621ILLdXXJ8LAK278xRH9BYavoYbOWA38F8gA/7XA1buK?=
 =?us-ascii?Q?WJrzba3bSglrHrRp4Coj+ennhhq04xYyt9qzbA5QEjV96CYJ9VOw4mLyMsEQ?=
 =?us-ascii?Q?fEI2gae6+u3JPKKZyghTvp0uQIdKWgLwKhwMxzyjQTbhqcQF57h06Be4V10f?=
 =?us-ascii?Q?syaGoqysKXP7iMaYUDhWZKR2ODhTYz9w2bIX/d/SBdZ23mglQtf1IrAp4OKe?=
 =?us-ascii?Q?ae838qV1t9mHPRfMBuDGQd/r//BOPwBkDIYXA+krFgCcfduwv/O//8NB+Xeh?=
 =?us-ascii?Q?o3nFZqO6//aIM8ZgyYc+xA6jZlSNiq1d9qaKfNjeKF6pESk9uEYZ632PSCiC?=
 =?us-ascii?Q?AW/C0We0etozViyi28sm9gLVO9NIMilwCPLira12ooHrPwpobj37o2MyrFrW?=
 =?us-ascii?Q?YznGSzw0Bi+QgL+pWSJxLgSst4L9jzWBl/VNme8KLobkGUDfGtPcoEbtwZQg?=
 =?us-ascii?Q?LeSxV7ATeZ+tMdkmk37pJjCBMmWPUDY4TSML65s/5ChUoiUSmonEAQgK2p0t?=
 =?us-ascii?Q?OGH58ReDet5ITfgdAlB4fJpXI7iNnrNJAYzGRlFaMRJs1ZYyifw0WU8aUvWC?=
 =?us-ascii?Q?dHqDC9pBugmo7xGvLRyMr1pGmT25cjQ+HbaxJ4KRASSCNFN7XuJQGjJBxDsA?=
 =?us-ascii?Q?rWy4YIPvKx+WWxExeQbwcrf/zLbUGP6Mz8h8LItHMZ4AoxHjt0Dh9a2m2SAo?=
 =?us-ascii?Q?L+aYzaxXl6Tg9gS3AG5nN8oiQ5I7utQ918FjxOQZysgGaIPM4h4G4FGs2N3o?=
 =?us-ascii?Q?HI43/rLGJ4zp50yGJ35S8abwEZdOpUeSFOMCDM5Fuxtim3pKQuzX/1jDKC+9?=
 =?us-ascii?Q?IcTusY+2DX/SAC4Ohm3EGng8Um+d8uOawrF71J8v4/QnHLWaZZiRwV/TrRD3?=
 =?us-ascii?Q?HjuoNHX+uNOX3ebEzfDUhuY4C2epL3R6MIHoIIRpxZaTDzj6Dv5y2mU0DsEO?=
 =?us-ascii?Q?/GNLl08ZoFd1s2y9nfehOjQcFPDX+mwYUl6lwfKALnPssh1MM1Dr0dJZTWl8?=
 =?us-ascii?Q?nheSv+zzXYsvUGn6mKrUcxLC97Nncb9214sH7nSSNTZIKBxi7NBdycHZa6Vk?=
 =?us-ascii?Q?UA1IZistCKZVLXdUHuNUhnDnfMrwOPM7gVmA8m3lIzkklRz/P7jC72zkuJ92?=
 =?us-ascii?Q?qxsWbZ4iG9CeEbjZprlIkPk08LgIpVZFXt1lY0cWs8mUHSmtFbCmADUiHpvj?=
 =?us-ascii?Q?yUhKeYYLFSuW05K6GVRwuTWulS5bOLECOJ1Je2YbgRrP8xO1w8twgGf/aHEA?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PInHGD3yEJo8Eh6IF+iNjFuBehdyCyFyE3jCrViryOeeiM5WeiqPfjMEMTGL5OQ0kgUO7bCMmYPE8sjJVj6NJfPQRwG6e18RPj+a5ZxxBJKxwI9v5K0qqDScPXxizGyhz5N+P04U9ujJoKvY6+SWMUpocJq3iYoYDThnBj3J44MQ9qLkKs0rN7gnjGII7Zvbm+ha8W7ZFTerAsBpRCGfhC8CIKCfaCT9BYkhRQdmLlMdA9jFwoISij+wvBGg13kDRzPEbSzGAC/5Jc1926TcyVM9mq8nP68djOwGHJpevEdLFO/wKtdioJ1rgQbgdbi9H7H0ZwdBgKoqAmcYzl1TkYijZaA4FHC/Emx2xA7UKyW5rzqOaSne3YeUdRmoMmtModQjP7MBakXhigLeIud0T6dlblDJKyvaaBAZvIvbYBcGfR2YyQo87yXx8imBY+cW/BCnLCTmx+xiB4kJU1bvWf3RjBUbELMK1svErykD7HkRyk60xcV9ymz1JsxRpXRDNLsmPtpjIhgAOUeG2EkkAvGOg+jjCN/GwzFFuyOcEd86Lm+phno6aDIKSwOc2ejHNUFcF5yh/GnI3qqM/EHFJ9eBc1apfIgyTk2ZNyz4X8s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c54b5c3-4c76-4aae-051f-08ddf6935190
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 09:11:14.7198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XndcjCiyQUEfHHACKH5NNrZ4pnwQ5nHmSIuxGI5a+hp6iBrSvJAujQG0ySYx8p3QjyT+ncEzm1bw4e9ccyPPmUud+8VzLl9cQbWaj4IT18M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180084
X-Proofpoint-ORIG-GUID: s6DuGrahn5g7J2SPkufbrdTVoeY07u3x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX5QNGX8zfrhYJ
 jo/FV0+ezAnDE3SP+2bJnQBrMCw5gOsDdfxELeCGT72qTC7cDHf5XmyE86IZ+nf2H8PxyY31ft2
 JOGurbxRn0QlkLFBkgiZyvdd63Mf1U/Ib2kJLjiwafxWfQAiTcm+wgb1mqbyRfNmuhgWvie9mbQ
 Yrb64KZSDPqpR5YgaQtCdFGSwxc4KzQ7GUW/wkzkExutuTjHpSZVi8Keld3wucM/BkMSOdAIFZ4
 Ccfinmxk9H6h8wiSZ3yQ8okLeZyErNFCMR1vwlHfjLzkjY4IQRATqweLKqLnsgfWaw7Fy4NA3yR
 4GMgCIjJ3PvwLpIIe8yrE2pnw2ps6vWWl2YJ0iHRdKUASKP5YIRk/2OSDjTBoj/Pp0gqbU+i25Y
 XBn4qiOx
X-Proofpoint-GUID: s6DuGrahn5g7J2SPkufbrdTVoeY07u3x
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68cbccb7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=fqlvQJdzR9ZGhYB2XEwA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: C084318000C
X-Stat-Signature: oix8mroiabg4uszafk6pi8ibau8qq9gd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758186707-705314
X-HE-Meta: U2FsdGVkX196azJRrAYjbhDplHnOBI4z+SC2KlpQRKrbIXlh6GFuAGhnEi53CeVv/8Hk/0frMeDbmWHenxs1JX0ghMEP/+YDtD1X76sZkq0iJZWURN463XggjoQX1FK5FQ8kMdw6FQqUHjV+lgLTqjXx/ZG8Fn+yrkGUFN+eggZ5Qyj8JFvF9D6yzOltmd15RaOmQIKy1NztEtkbzVeNIDa9FF8UDUS/aN1EznB8dwD5aRgPQaIhub+d+tNCjWmkonVyN0d+KcOjbVNUYBrI/MghaXNqw6/gerseQFdSE8ByvWR1HDqyLtBBIPwehvyjBB2bd8J3B8rNOYEPi4jGUsZKrVpeY72O3YAH0w3vKudIm58F5aJfC9Bb023UaywtsyaNrfcpSsY2gzNYx9w2OxD/8uvo9gfhgRm75/Wu4iAWZz/RDJg9q5ZGdXnUMXvGWl+bauhhaHpA38/JZ+gxtlE4IMHWTxAhry6gwUUSKb4Fx81w93xPZH1bmXUMxh5EYI3ITyl/4+R/aRY/3QROR6f+zScK3IBcnK+sxE634Vl5IlwLkXnJxKAQ8zdUtnS95fjNfcuKGUxFmRdSzRTmYtJFXK780oUBt7Jf8uSeNn+glHvNkpIUsYCrZMtdCZnxfErZ5149xSBfYgsFTPA/CCapbOnFICfKS15T3cgOt4Y9G83Y69UqSBFlPZE88bITfUfN9pAEGUWhF1UZzF6oUPeWzXhUqnESt49L3b2tCxp8OUVIvTAVsKYxHjoJeiSdD8H1sFuM48O+JfGLDh1rtDJW1kZ/TIPM9hEy+dwz+lH4lbwPt8PsbIar5gntuj0MVROar0Bj49gunupYmwhYl9LDijKDVvnQytxdglFPjLSOW9qqyT4mOcAV1OwbsoEY/2HVfq1kJ5SS+3TU/u7ixEBgxLZsSn68eieHlCGPD7EOAzezgJWyOMiv3m/EO7G1YN+1ALyzXjU9IdWqQDT
 qQ9zKgmk
 7SZ6ahVImAJ8uumO7lpM7NuqVRfsX5BOdB0S6IkkC3Kyl+HKwuQ7IEcWjvVG5myCZtpn/I/NoegZEtVfh00kIgTpJ8E9fF60M9RtBR879ZtXLREvee0jYCiUOoH+nFwuUcPIYAPb7luXOzO+uzwBkNeqTRsXGsUw0UFvLgpJlaYh/G3Sc7J8k9/nvhOokcs6XHaW1uU8h/s3g7E2UWA+NpKpfIyRoO6gQiileF3T60Zbph8vbF3p8BtmpIi8BjR6ITj4VhXABYapd+RujKzuIHKG3ie7YwNm4wLFgBBclLUjZzRYV576gLyJD4q30AnQZK3ZeBjX4i/iXWH+sSlINiDn/RcWvKQBiecoT7KEvG5Bvmi6d7gEvXoiTs00ax/lwLCcB8Gp06CnRrxPbg9R3AMpm774b5IvpTJ81k/mmco7tgtMK5DXJD8ElzftxPZJdirHlDTufKYSvyPyBgz/otYLkcxQTIzwr368shjUFZVDTEJfqT2gTVRTpBEkVHqreGvT0+jWZOKNdUMjyRU+izLFbHt2bzf2B69Lfmi0lmi/PI8sR4pZ8Pok4vKZ2kvePxI43AAR2nDPrx9HGkEGhcxrvqF2FCRLImnkcn+YFycIRtBZthFRJszWXh9O2iwbsVAUVeCtuGAIZZK87HTOUOBwkhzm6XpobbtqyKSPOT4gODANJXb/lG7TMoj1X4Sg2jaVOC2QM1UpyKnra0ilKy3yvgesAY0EmvtwTAYvo0ZIWwmqfeFVpCD8PWJVd0r7pBRB43jv2n8n6Z3suJqRfTqOJafaaoGLnKN5S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Could you apply the below fix-patch please?

Jason pointed out correctly that pgprot_decrypted() is a noop for the arches in
question so there's no need to do anything special with them.

Cheers, Lorenzo

----8<----
From 9bd1cafa84108a06db8e2135f5e5b0d3e0bf3859 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 18 Sep 2025 07:41:37 +0100
Subject: [PATCH] io_remap_pfn_range_pfn fixup

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 arch/csky/include/asm/pgtable.h |  2 --
 include/linux/mm.h              | 15 ++-------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/csky/include/asm/pgtable.h b/arch/csky/include/asm/pgtable.h
index 967c86b38f11..d606afbabce1 100644
--- a/arch/csky/include/asm/pgtable.h
+++ b/arch/csky/include/asm/pgtable.h
@@ -263,6 +263,4 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)

-#define io_remap_pfn_range_pfn(pfn, size) (pfn)
-
 #endif /* __ASM_CSKY_PGTABLE_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9b65c33bb31a..08261f2f6244 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3672,23 +3672,12 @@ static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
 	return VM_FAULT_NOPAGE;
 }

-#ifdef io_remap_pfn_range_pfn
-static inline unsigned long io_remap_pfn_range_prot(pgprot_t prot)
-{
-	/* We do not decrypt if arch customises PFN. */
-	return prot;
-}
-#else
+#ifndef io_remap_pfn_range_pfn
 static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
 		unsigned long size)
 {
 	return pfn;
 }
-
-static inline pgprot_t io_remap_pfn_range_prot(pgprot_t prot)
-{
-	return pgprot_decrypted(prot);
-}
 #endif

 static inline int io_remap_pfn_range(struct vm_area_struct *vma,
@@ -3696,7 +3685,7 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 				    unsigned long size, pgprot_t orig_prot)
 {
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
+	const pgprot_t prot = pgprot_decrypted(orig_prot);

 	return remap_pfn_range(vma, addr, pfn, size, prot);
 }
--
2.51.0

