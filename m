Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A5DCAC583
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 05:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F21D8E0002; Thu, 11 Sep 2025 01:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C618E0001; Thu, 11 Sep 2025 01:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE768E0002; Thu, 11 Sep 2025 01:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 452648E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:20:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFB42140254
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:20:00 +0000 (UTC)
X-FDA: 83875817760.22.194A175
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4FA05100005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:19:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SBf1/pkH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dTIseU68;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757567997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A69CJvin89ss56BnO21FlNR7rbDjsZWpO436mBwbtgs=;
	b=Eex4QFigFSEXRsZv3wB3mGJHHZxmKLkcliOlnNSHE62HXTAHDMGJ5+lgmDDJt5mdT41I5j
	b456xaUA7W3NYaBIUfIjOjf44u2UYMFtk5BxUV8QTXr11jcfZEtrhXiNo1YvSVdpwV9kDj
	1ZPisVG7IWd9VM0Bh4uyU5KobCSvK8w=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SBf1/pkH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dTIseU68;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757567997; a=rsa-sha256;
	cv=pass;
	b=4W8ALQclW8yedbuPS57ke9BfPGYLlwWZilr0bhhej7fro4UcrVw98Yejy3CR6VbZHlz9wJ
	6wG03qcLebQikUnYwKFh6m6pVGXj+4aqhF9ohe0KCqogUYBRkFZdK4AdaLoZNswHYb9Gsj
	2AD01LSa5L4pZ7MukPE6JSHjyAYSqk0=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ALfmcS012727;
	Thu, 11 Sep 2025 05:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=A69CJvin89ss56BnO2
	1FlNR7rbDjsZWpO436mBwbtgs=; b=SBf1/pkHYcYkIQn96KmqrLYi9zbzoiTq8v
	+v8QCwQUvryNa/Z5x2x45rJwSALBsn4DfGUrCE7JlYFLMQJYZCbNz4j+4wvf/jkc
	uqDj/JBXnMbCGGlx5BdrXaX6wL4a47b5cPRlo7qS0pwHqM1nu5zT8kmlqtXf/A5Y
	EuOz5Iiwyv13W5bUZj9flDX/GWel+qto8mmw82/8hEnko7UxOsf7BC/AD8Jnk9QC
	9nuucEjtxkhGgjuJ6hUEoslTKExEBuwd19fVkF93faXGPW5EnEzjWUsA9kBu7UEV
	7NvChz15dHri7KODaLPWACOdNcBnLNClh+qj/lh4smFyZiCj6StA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pedjdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 05:19:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B4oAbj013598;
	Thu, 11 Sep 2025 05:19:35 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdc51h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 05:19:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bu4GlzcsznNMICugZr/hkVpg5Fqn8oqQ5CntUC9YYNMDtkOM+A+qmV8KT9agKWptQolRaSleJaPxe2gdWbGa7ankQFc+J8cQxNU2S9v5o/9BBqT7Qy0o6JPSg4HBz3jTR+P9wpvC2mwNcRvHkS4hHXV0x1yeIJ8WIo4PbnQOhWoTiULT4mZQYvP9zKf1XqIEqKtteINqxZ5MvxHxEa5zFzM555b2tWh5qfTqB5onzAtM6bcmYfSXY17e6EhTxWMwVlnY5IN6s8hVVs+b8AhlvhSpSxbraAlZrZkIKodEvRdWtduuGi7DS9QGlFxjtU1JNt3AgGCmjCH7CDiPhprEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A69CJvin89ss56BnO21FlNR7rbDjsZWpO436mBwbtgs=;
 b=tEtJC6uZZ+xy3jA/2Ox/gZBJo3SC42TvcQzxRYXrfS5oE6vxUokApYcYavspjhVe1IjKo1qIoFPMT7B0DofbJlFLf2Q3ZiSYyvhUB1UYfogKcgylsV1fiiIO4LaG7I7GdZx0aLW+iCjSYQppOzxL2JD1dA5soJFNH/k1VkQm5pQx7wai0IYsxjquGnvGP58Fery9yICF6ryt04uGOfw8f38OtOZ3QRTYOJ0fjSQnqBwGRPpNR9w7MHIttxBO6ASSInqHPF9y+mNQmA6fZBrCwy24ZORWkWIJuw+lhA+fgNYFdSOd81kTHUU2KloWtfmn2Nj4/i4nHyQm4vmoa+0CBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A69CJvin89ss56BnO21FlNR7rbDjsZWpO436mBwbtgs=;
 b=dTIseU68otZMX44Q/jsxM5pBiT3nRvKwS0KN9lhb7XZVqp6bhFW0nAhO5QyWvSQ+tRYnVpbbXh/Opq7Sr5+dvlXc0Oi4vfZlZishjO4nhXnPksXLNBhgA9982TKNTnn9W3lyOq7MLwY/h2Iv1h89Rku6jFMlPu0sEpnA/0hD5wQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6887.namprd10.prod.outlook.com (2603:10b6:8:101::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 05:19:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 05:19:30 +0000
Date: Thu, 11 Sep 2025 06:19:25 +0100
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
Subject: Re: [PATCH v2 00/16] expand mmap_prepare functionality, port more
 users
Message-ID: <24895019-1473-4b1f-9d5a-8beea30e95b1@lucifer.local>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <20250910143845.7ecfed713e436ed532c93491@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910143845.7ecfed713e436ed532c93491@linux-foundation.org>
X-ClientProxiedBy: MM0P280CA0063.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::27) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c183b87-cc00-4949-62b9-08ddf0f2c8d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fc1QsD/0zrDph1YqLsTL1vA2KUsw/kMBf6PBDlkI3oqLuMsXZziKbx0GgKG0?=
 =?us-ascii?Q?6banCT69aFIpYKAg4QU+LLqkCCX2rsdE50kr79LfIyw8iF3qlQuToPP6tAi7?=
 =?us-ascii?Q?7oxXRwTC8+lg5xucApxvqVvijyijAIepY3rniK63gQTI6FP7Zo0dPUqBqVHa?=
 =?us-ascii?Q?B8KKMf/cBLOa/099wzfi6os666oH2cQAX7MDRHiscM/4492XTrsI8Gpzpl6V?=
 =?us-ascii?Q?n2uJdnsPDTmPnByGUirYNRfuTcnOaWkt/tIxRmfCgPbn3W6A07aHeRV/OrH/?=
 =?us-ascii?Q?vaZOv1bFx/0UQyovPG3FRLB8ObQPINs2IM7Og6vt6aVVoP1oSaUQ3bo/+DBT?=
 =?us-ascii?Q?A5e0QvUk3zpLuOubZgzideSzGVUEnTTR1V9f0LTB0T9OpfpwVBdEFNCBun/A?=
 =?us-ascii?Q?QsY424ND36XJ+/8GGOAYGAlQ4Pbv0p2Sj27hZJA+VdB6rnxsi7rrmruVl0uf?=
 =?us-ascii?Q?mEzuYeNBJtJOK02cZmfFB2MePvvRqg036HGBOgBNWOqjgiveohi0Sg3RZbw/?=
 =?us-ascii?Q?nd3pymqQgyUHGhwm3Ve+08gMKlafgg7+N+m54IudG13rroyTSrOeTYsCG9iJ?=
 =?us-ascii?Q?mHvYzqs0gcuOgaDqVnqDG1NFP8OMysYAyt60G88TjOYmFRG7BMocquhNrVK2?=
 =?us-ascii?Q?E0hSVIdrwWQpjrxe0taZdYW+tQIhA6QNLUNq+nQnjopxR+v3opRjb701IFrN?=
 =?us-ascii?Q?LriqxwRMKak8NZT0rpVIFhj/cUyyIq0HGwsqCYWDFCfxvrIktIEIACH9faEs?=
 =?us-ascii?Q?mX35oRWwHXHkXVbusCZvVZf8uOuhYsksYRlw5KCKXmA68svEi8qnXFqus+f4?=
 =?us-ascii?Q?M7HMZHo6ZVY6EnbB1iiZ9yl1mLlb9pJKF4Oq3RHykzk/g/ae9IL5Ln9na+oQ?=
 =?us-ascii?Q?bcmWgbQJE/FjcUqLzhU9JcU22ivTzwNfpM2GF81xXxqFdqvmzS+C2ZI9oE4l?=
 =?us-ascii?Q?9umHIVJ6lE0SgrJbWf2B1WogXkS8Ug38yYmrI84KAYT3xYAkhwKSIxaTFXDl?=
 =?us-ascii?Q?BjDq/5+a7zL94FSRi7phUXa62xcUi6S4IIe0TyrYE6KErgECB6AgxY5GTeBs?=
 =?us-ascii?Q?QTkpBtE19rz//t+PyVn3Z9QT8vjaIGc7nNmwYy5XgJT4r2G/1dTvJJ6Uw0c4?=
 =?us-ascii?Q?KFh8YWN3Uoh9+YVYcm3OWlOSx9K1oiE3KTPTPdp0OMOrbDbjGlo6VBtpPSXM?=
 =?us-ascii?Q?or8tsCroHIqbPGaPYOV54Mld4Uo6sVQdVkNmIAOwAYrcJMQW5NFpgLPtljyV?=
 =?us-ascii?Q?ZuPldvQ7GQpn6Nj335UfHnhm7hEgA3onBwptjCkfxzxOPzzaPZtGo5UExyaM?=
 =?us-ascii?Q?U9tv0wtnng0i8JAj2NOGfPJytrw7AToC/a/PoEixAlb3LqFiPbBbvYVyUnvv?=
 =?us-ascii?Q?+hJINh1h7h4mfjeJ9SygYrbTbgl6lPe3Io2ioc5xPxyW/65LgOwelbMGGvgd?=
 =?us-ascii?Q?FySQHTWA1tU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yo75NIICyILrChwQX4rPGs9b9kw/nCLkWDM4lOnHbQg1ZdoalTCNOOArdJWu?=
 =?us-ascii?Q?pm6S/PnfFVeFbHTNHjTOPLqDbUCAwyEsLvMJkOMeW4/6Mg+Sqm7QtjYD8vk4?=
 =?us-ascii?Q?RP65k8+CY1T96T9NBSEqr9PWG7zd8UYIe40mr5mxN2t4pQtOHeLaJmesvt42?=
 =?us-ascii?Q?TcRVsJd/tcufeoKf80j2ESZ2GtExF58U0E6LpLAkcjB99E3JWRKd45/WySho?=
 =?us-ascii?Q?LOrdkfp56PbbcqbQnutUW3zw0mVOx2uC+OcllOtyosIJy/2dq9iDzLbsRbUu?=
 =?us-ascii?Q?FUjyDZ1chWj1SEAKOWAM3zIRsOenlqTlhapUJqASjaudWaHVxxxxlwaQPgk+?=
 =?us-ascii?Q?tkiE876EPC+4TJ4J+iMDn0huADvVkSxsci5Sx22a7Vz00uB0kHyaF1PRj/q0?=
 =?us-ascii?Q?aniKT/A6Zn64MC9JGRQyMQX4UP/Vl5VTtgCsPXJ3sBPd97sqRwSNee20EBXb?=
 =?us-ascii?Q?MhOcFVA7CI2nqNRwkFjPL+X69+FVtTocQnO/AeIvTSdHDCCRI/gi1FbDiTSR?=
 =?us-ascii?Q?8XG11Ua7qvYzQagvvS5u/gCmmw+Qua8SZtGOjZYLZjG8dqoHvMnIEvqv1Sxc?=
 =?us-ascii?Q?YdNjVKf7YX8THUrsGiG92Y8F20lMRMkykFUXYOGsppKEqRtQcA+QCWv12Rwh?=
 =?us-ascii?Q?QkC9NUPiysMNLiD1UQkyYPMDgB11GQxmZ/BloGavRMrYjgI1ncRmENHRhHTx?=
 =?us-ascii?Q?L01XaPTPGmrq8UxhQ3qeRfqRkrB/xwUpNd0aCvG4Zwqu0GKEcoSmXF6IyNCi?=
 =?us-ascii?Q?MroPKy+8HBB62xacLSFMikByfouQn8PbRmpDs6mH+BaO5/VAs/KYBqa3RKB0?=
 =?us-ascii?Q?b4PcYxWj1L2RP5Wt6KV3LRtE2Jf04sYW6PuL1KaN+5lbsD4E+LtYerdPkw4G?=
 =?us-ascii?Q?yLvUsMaKA41V2Yd8rBwYPfmicZzi4NRXiLgixSAnU2Yc/mPKcntX/vJk0r3n?=
 =?us-ascii?Q?U0s5j9fP1zhTlWLfp2K+3mBAVwXJKv05usoWo67xwzXoyxMVLP9Ww8rkwz+v?=
 =?us-ascii?Q?WiHjxJAWDiSemB2AdJZHmB7QDvG/hYizaDuRqoamebCHEXozjwLNrfHBJyG/?=
 =?us-ascii?Q?wlH6DBfmsgovCHzL56oWvTAeGLAM9ZoKCTgcEB5xUOOZWqJRHsLtULmA7QOp?=
 =?us-ascii?Q?NKm6EhRDHvKaUw7fDClOuvMR6jtWh7jxTvvJycBv4Z8tsqTx53rr1KWTq04b?=
 =?us-ascii?Q?Br/ljSHuB3wdvDlsuymrTna/nh1/AdHq1fYKd4Vbl+qN8s70gLyZw6bmWf7T?=
 =?us-ascii?Q?CKH6DHP3fU71WD9Bgw2HR4iWyt/qNG0O6B+99rXnsjeqHB7j2tmhA4Uqxgms?=
 =?us-ascii?Q?agFn07phhNCW2qLL+xAky3Ww6p+UmwZ8ieivjgwTtCMb+SwxTvjvrcEDsbZp?=
 =?us-ascii?Q?Rkq6amPirbg+CeBjb7mKYfWunlV07qmgqtXH/zvhbz0AlhvcxYRzCg8sz/SJ?=
 =?us-ascii?Q?5QWXxaUXaR4W79w8tgkzHEt8Woowdl0BPlwvVJ/DgF02KTGHPXsfoWLuPaUG?=
 =?us-ascii?Q?CCA1KVwFwQ6+/tsW5xQGD8FXVCl/klTPBX8pLhUUdR501Wa1KKf0CyRFtuIM?=
 =?us-ascii?Q?MO/NuBe7eaLLV1LZAGyrMUmbSV0QSVPdwQcSfNYjFhhQRllLeprICtzpeAEq?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D9kOkDIo1oE9u6YmHE+fAoSa5aRi473jv2CfBofcth045WgCgBHfBIS7Q32PX1XuCM53I2bmE64i4xuSUUTkjoMAAYZBbumjyGRgn4XUzeJO9e73iiRBb2BUzm6q+hDT+VKP1Qs+acX5jm0CijkboifVNua5gMZJB0rp85s2HC2MeCZsN3ZxQ+ckcpZlN6JYwWqyKjGgg8+kB2A1aivNP0tNvUIHFw2/JoHeWdX4Ryyqi8CL0p4h4iJB0ekQebfWw2qxQOwCpsVw9U0BwV4ZobaqBh3EFiZEPp0X7uXzuJoe6BiDibCtZVLm1zSntXbU61+bnPj6Ud7C/jHTX2CQJeZMR4t9jZV4HMy9bam29nJh83xzXYzgiol2JibuNpLCjtceegCGy3uZ2EAdnbwJKIL+vDMdVDmmvaA2FtOWuAn2ss8YypXqvb11SNUHDeo05rY25bljRj+JIOvoHsI/FVGckDtiGfRri+lPG7D4sp+DbjLZRrOA0MC/wHfrmXPhRWlVZZN7ryFWmPGWusI/f+eHZ2Y/bc9t5Rsc4i2vcaPuEEC1/UvaQ0lbEpPiAKJn1BxmIg8bHHFAgi5Yba8wSiIHd47cEByET5GrCcH/CSs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c183b87-cc00-4949-62b9-08ddf0f2c8d4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 05:19:29.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVvhidX+uyD7Hg/IKDJgeYkE43ZJ5F6DbG7GhE9NF85ONHmuJ+ooKiebTFh9NpEcmRAUHtQ7RwV7ZHIpDPMVHsLJ54VrcojfGELuioIQ1iI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110044
X-Proofpoint-GUID: m6YDAT3BmsaEaJpX_6PXdDXsx2T_2Tub
X-Proofpoint-ORIG-GUID: m6YDAT3BmsaEaJpX_6PXdDXsx2T_2Tub
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX63LuJPUYbDLs
 7my/hVAxzmqy7ov23GEIFp+rf6jTTmEzKTi93pO8yf8KrMP49qKNRyUneKJqj6BSDD2eB6xqaE5
 lIvA4nGJjcNNFJS2oZ8HJW5XV7838dhjeOJDOhupIda5iOoIfMym+zTr9vkOqstBgqBVyqOBpDy
 UsKwnEAV0lBs3umV2fiS7OV3yGm4rXOMhrRr06h8byGD1PGA6/1QBNnHu4SdMz5m8CQVXJY+D8c
 Dpn6uTbqnSbFz+OeWiA5mobfgpPmFRSJ/622R9Y2cTJMcN4Gh1+pl+JiY5ihP5nxgCVLSPbc+17
 /lgH/Py8eFejxv/hK6IWoztHD46o7Hz9fiSzeccaHvVONJU6YiQxXkwUug69mO8A4JHawFvGc7o
 clvfHGtt
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c25be8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=SkEDMBO3KR2y4re9wX8A:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 4FA05100005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gejetwbaio6aimpbxocuoqstf95ez7fu
X-HE-Tag: 1757567997-955834
X-HE-Meta: U2FsdGVkX19UmJFyQISD4ZV+S8npnL5Xts4j8VhCreWzsrp/SCq8NP8kJn/ULKm4qrbzzpDHF0x9pkO4VfGJNXgVC56OxzRvR1yJChJDyjUA5yuJTR1DQhtBQcPRLbQuvHQJVAaEUcNSORu8cmfUdBz9k2W0cKGD+xIBaOw+GswHRnfFgAQDNJXZ3p6wIqrV5ZStVIUgdIrfqfGphtXVsG7FhzIu7G0XiysojWc/4P71XrmQrv6Z+g17pYNqY18TRuFnnhyoN0S6YlR4A/xkcZWrBND1yb/wG5Mfj3+dlkUYu6dvQa83Bf2FeeOL+XaR2YaslJWkAvNGZHcPwt7MJ4DS1/I+4hqtV6Bahbgch+bk+xq/iTFYZsRDsnoDus/WlGFfsij2fADcONxVzSOz3IUBK7qtF0ND4b4A1VqgeqJgeiPo6uZXIpR1A2QiKpsL70HPoOFhFj/Qkcu3LwDiHFhJXXNfaoiFAW+/4CH31tc8FFdzv+yC8Z6B59TxXFsVKgUBvgkTR++tATOhKq+46DBo/bRtPbEWNgLXZWu9G+FkzS/ElVYFHDhAYWp5rkgeTCjTC8p7oxwyUe/lGt2JA5FA5gpH4Bb1/4I06baFzm1+m4d6y0epdLkL/23Da4acX9o4Rz0O7Zi9+u84U1VRg0fdLANoU04rfzRpkAHX1ddLmCSYp5l4o3OlMdyhvAZZ6XZq49zVsxg30LojeEAlqh8Lbvz4U8lDhsQ3mdNPR0YbByJkuBAGWWXaUhOBvCr3GRZYsWL/q8RqZJI3qnhY7rZpzLa4dVnJ94lk98dWn+kQ5L9I2toHbCyZCzdZ/lbLhuJRw54xkdVf90byDNa2bsx5jIi6uiRdhNhXI4Dq5lsG6yFyMhmqqrUW2av38t2ZeOANQ8Ib69lJz044qmvMtIBv3w9O0kNQ+iibOOBf8KDMNVx+MZwtl+JxZLrKr1Wx2JVagL71XwJt+Bb5ojt
 jN0Oh0Mk
 Tl2OhOHvJXG2y2zqHJcBQ5JXEC8wDlODk2d/ftwrDeM54TPKmsuKFEuTDjAVeBGK/7iDMaqnmdoZ2pCqFPw51AVpZihWJ/u3rzA5xlKn4mYOWAxedXzhurLcn7v3pFUnLI9GdqHlYwJuzKW5q7y2eHOFXeCg+JsEr+k1iExDCt8aemF483ylHIfkOoolPMBSGiCrCBMIUllwhjZ04rP20H7S2xRb39D0Xns8+KBE5AaPZaO7kNxxS5f5/v8zlzxwvxloukGOZTh0YMOYVi0dw08DVJp2+TmwR4n/B/uNQTPJ3v6SGg6yfKP+cp7mgkMucEOwFUwLjberxFnzcTgKexzfK/uFUwxuYDXT4mElsxtoojMTDL7jT5zJCz+Sv/46alTcYO2mIj3BnIpcNlCBbKKNDBoy9etTQGp32L/LNUS9AgoqIqwWNd5fvC+NnAQViavWrg09GcaUfZCNkBDbnS525pUwcj+NesnS8LEyh2eY54BoUcDYGAXhtOAJO+Vv3V/LLcVLRk1E7WTWBjxkUTt4Z1Y+oFM8aFvujYdi+dxub2m5h2BccNJHImo52670h7EGzbV1RyYVywsD0X1KDprNCumqaInfl5GWsNIyoW9Vl9MY4xottg9xxKAMBh3peL6O2AVdQtf3RcATNLbU58A8P6J3PX55sF+mItwQW80MSyc0QjYtBpl9gR4gAQFTCplgtzRC5D0ztZj+E/v1GkXAnRpc4r1RnJv7IYLXiGe2OFLfrkUtOQdkLMty5VCgG2tupo3ydXMY7QX5+YobOgoVd9sbJoGHif25z6WfIOlvRkyhjyUJ3CQzNaMbIW9mqB5zG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 02:38:45PM -0700, Andrew Morton wrote:
> On Wed, 10 Sep 2025 21:21:55 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
> > callback"), The f_op->mmap hook has been deprecated in favour of
> > f_op->mmap_prepare.
> >
> > This was introduced in order to make it possible for us to eventually
> > eliminate the f_op->mmap hook which is highly problematic as it allows
> > drivers and filesystems raw access to a VMA which is not yet correctly
> > initialised.
> >
> > This hook also introduced complexity for the memory mapping operation, as
> > we must correctly unwind what we do should an error arises.
> >
> > Overall this interface being so open has caused significant problems for
> > us, including security issues, it is important for us to simply eliminate
> > this as a source of problems.
> >
> > Therefore this series continues what was established by extending the
> > functionality further to permit more drivers and filesystems to use
> > mmap_prepare.
>
> Cool, I'll add this to mm-new but I'll suppress the usual emails.

Thanks!

