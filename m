Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E052ECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD406B0008; Mon,  8 Sep 2025 07:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384B26B000E; Mon,  8 Sep 2025 07:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7B76B000C; Mon,  8 Sep 2025 07:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3FE58E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:11:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C03C711945A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:11:41 +0000 (UTC)
X-FDA: 83865817602.15.597BA82
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5DB3A10000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:11:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gf8lKJ9a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vzrz2EmK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757329898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7YPdWDqyMfkok0uo2o07M2LPJvl3/okVukz+dZHq+E=;
	b=GBhiDGj/BTMdtzo++5tvaFqE0/0xiOPZ0jAXRAsybFCwTXZkfpa4VV8vKWUaVK2oC0XeNP
	VLTlWPYu54OMkD+laBx/x9Gp3mMhrKgvXaCBbr2G4nN68dMyE4psKvhEqhHSSRog4PiBCo
	UyED90nHgUInJfIryosJcXXU0GI3fjk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gf8lKJ9a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vzrz2EmK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757329898; a=rsa-sha256;
	cv=pass;
	b=rYvfaiUhr2WpPSouVKWElCkRFNNTlfh5BBr5DkSDmSoyKizLDdDs+hDZZsnOdE5pPZg+/o
	M4hqEu22yqYCCLmBEnR3FIl50o+RvykR2a6udizBXl+sdsMnn1RwiCU1HXHGsgKumveFyQ
	OBeo07/dnJ6oB/2E8W2T0v7UU3qoo+o=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5889ikUk000876;
	Mon, 8 Sep 2025 11:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d7YPdWDqyMfkok0uo2o07M2LPJvl3/okVukz+dZHq+E=; b=
	Gf8lKJ9aoNSsmHbhDHn/vmDH65agTishM5+EzdA4ldWsDlug1CU0XkIaphumOrum
	FXircP9pQ4N499ly6JEsG/dUWXXlTBaKYJiBaGOlHhMbYcNTj1PMEzacqOkhFX7U
	Dtq9hOAx5MKa0UUrAWIp4DvZ1CRC1PGZsFfWKb/Xh0bniuYbl8E53EMqbkf1rIom
	a6aTDkfOZhXUZxGbv1QzRXlDXUiXuWDoJ05S+FiCQMVksjX1QMT/YeyaUf0WDZjh
	dyYAkL9dZMwV8iLJprm5j0S7/TpaWuyl9PWX1IMZaDlLNHiyo/8djUMvBC6Ntr7S
	sGMxzdoQqQ8+SBVYUGQo5w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491vsc04s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:11:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5889R7vw030624;
	Mon, 8 Sep 2025 11:11:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd819s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:11:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RTJ04iY5FW0LWFtQNXZIc8h4OvnNY34uBxFA6MC/2cilKT8rbrMELVI5P5qyw3NuV6l2VZuIkBFG2lXm+a7lIEY4FJLsF0MhMXhVHxVv9QfaLLc2feTNb+KY1FHpTAhx8xVUBkf1D6CDOrFQ0o6LK2iJCpxV2ivVjQKQyeTVPzBzE3UxsZ/MbBW+aR/CcN7BkA84VVR0mwLlnqzL1SxXp1d8koWnPM0pXVZXg5Fw8ZMc1/dkwZmi3d1Qx9warMR9hBfh5VH0Bg5PSsNeouf7M1+p6D3r70pODI0EBYDfQZJ19iOhoP5lBkw89zRA2Ip9jQ7LxE8PsMRY3WzIeBFpew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7YPdWDqyMfkok0uo2o07M2LPJvl3/okVukz+dZHq+E=;
 b=p4uY3DNbXBmFWbN8SrcOBkgP2DZZvjNfUg+8Dn7NkIh3n621cCBJix51TyyAteFjTV+IHkl2hDuDI9A3b8q9vlqWPmZ2oj9MTOHbtr0UVUyOSQ8ueQDLMifiYw4zuSMZfpl2BnLLX2dj+3YszVU8njKwzY4a61wE8OWXT82Vk0oVXBirDBIu9GZMyHuint15oNDdNeeu4CphAAY3isUXydH+31rEOBz5JlAx6hxBNvv3hK9OgxXRZNyRURdRKwnqbeAnopRj3YV8Pfcdfg75G+6GTxtf/eN2i8RHNzPhZXMPmogf9A+rvgiwWIATuCzacZHESpwB3HlYz0vETS7Apw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7YPdWDqyMfkok0uo2o07M2LPJvl3/okVukz+dZHq+E=;
 b=vzrz2EmKnI9okEfxuc7JT7/ilxMfIyr44XBff5PanPzjzPK9PRE5iHZqGDqY5ygIAW0I2eWbTddRuh8CDcQ50cYjAvui9kM0LwwYBmCrqo/FAHWYiAMEFgAEcmQyk3/h0nd8Nr/gVujXByTGkX4D4ypz/5nMIbZXbkYQl3oXy24=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7155.namprd10.prod.outlook.com (2603:10b6:8:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 11:11:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 11:11:14 +0000
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
Subject: [PATCH 04/16] relay: update relay to use mmap_prepare
Date: Mon,  8 Sep 2025 12:10:35 +0100
Message-ID: <9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVZP280CA0070.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:270::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: c78eb9e8-a209-46a2-5a6b-08ddeec86ccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LLSiYGdlDciKDcXSdWjWBlSBbNuJbEb2CBA9AAdRBwQFkdBc+DQkqwx0XFVy?=
 =?us-ascii?Q?S6sQONFFfXMvkK6gigmg21HMK9hGOkaXkN303UOVFku33QYXFK5Hd7nBJAPL?=
 =?us-ascii?Q?82K1GRD853mLJa5QjWWycBdAESpJAtYypccS1zN60ERh+H5a7p21pBSIFVCd?=
 =?us-ascii?Q?eQC31HZwBtd51s5/mMeBubesFKrx1Bu1bc3lK52z/dDCbjtI6xsYfoS2ewJA?=
 =?us-ascii?Q?/jd6M5e5cClHqjmIP5GVgSi9R9650g+6as8kW/FfxE2OUVznfTKOT+L3Qm4t?=
 =?us-ascii?Q?Eh+JRXXA+ylOPRDxjlhei073vEV0HOWp1zD3puSVJ1giUOfPip3BUtCY0JHc?=
 =?us-ascii?Q?3udK04jA15iux06CnQz4m0eOtLZesP+zHxRMOK6m0rfcRMy1uYmhg3TYp3cI?=
 =?us-ascii?Q?YQbHgNVAeyNflFgP0e2IrjV+FWOwd6zgBjAaOnlOO3iLy2VKplCF5jNUHZ69?=
 =?us-ascii?Q?nAYz9kohyjme1W3RBBQH1b4x4t8SttiF2Y7Uoawc/J46rzbLkqV3VFzQmzCR?=
 =?us-ascii?Q?m30sJ5JwGCZBZ4oWytv4yGjjlitJk2ECqWw0Vhyvm689WaOFiSyTqIEvWcGy?=
 =?us-ascii?Q?+ZH+jNKP1Dgg+I5JHTWwpqHQY7ChPDgN5NEa0ocXER6HHibVZOrYd/UgjyQn?=
 =?us-ascii?Q?8XImwCabGVT/T6Dv9BNte8Osu4/Ig/dGisLapIufkDZMza3peK49CJQKdZVx?=
 =?us-ascii?Q?MnnKRsu3bqWE7bvvl8FYMc4wQhfQyYuoVwOtCPeXkmM+eWkLL1ZY+oBYLz8b?=
 =?us-ascii?Q?CG56jjxfJybDGkoZs4fH/YY+IxYuWok/mOygg4d8Y84DMhBgux9l36BuAaFZ?=
 =?us-ascii?Q?moI/X6lFPmYbNzPfVc1ptHQClblpYdAYy8/aHg7WHDWew9qLz9MGcvIczvSe?=
 =?us-ascii?Q?UgyVpD5VA7ABCL2bd8GhlpcWvRibd+y7juw2TVeM+gaf0Fwqrlm9Qsgekfh4?=
 =?us-ascii?Q?U1eyqPTkzRu6fhYofupymz08nuLfJbSUVw7FGKuA3Vh2bhPzzrOp84o9E4wW?=
 =?us-ascii?Q?eoFrUKAnvzynn3c7C3e6dRaGitiAu3rqsdRFmbwciCHOweehHyHBwU8dgHjN?=
 =?us-ascii?Q?DnESsZWFhS+Zh6c4NQbvomNmp2ADs+iXDTpZKcz41jSDiVSRzVypMNc9MwyK?=
 =?us-ascii?Q?WPHfTYpsJA6SizN+9y4emw4rnEvVK0RoLGL6w2oQ6y0eROb/ypFHrd9hfaAW?=
 =?us-ascii?Q?B5QApeLho1g1z+iren6bBOhc6u4Wd0Bc60BvnntquGNZb429N8jup4um1Wjo?=
 =?us-ascii?Q?TFCoVa8X66L73xPQwkGCEh57JhR2rSl9WHgFo7g66/Uiavy3buxVJ88fYcYK?=
 =?us-ascii?Q?81oeQK3RItjh6kTSjQMGfkFfH5JsK7dpi7prFeHXragM17j/mPXiqhongOhM?=
 =?us-ascii?Q?1wH60GuV/6cM935Z2448pvIxQ2p3EVclhwOPHaCktdnCVWKnvPVe0v7K0Nk3?=
 =?us-ascii?Q?MfJ8wnBRgR8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p8EFCYtmQrp2GuagZRYbfoY4/lvYqGCg4ZqKwrr7u4ZvifwrEBwjZUwFt0kT?=
 =?us-ascii?Q?PzhuxOMA0QMBV4tlyoj5teEJJQBbSDgorUl71EZH3ucKM7jCRMxVQAh/MIef?=
 =?us-ascii?Q?UMxZMEULZEwNbnmMV92M8SgZN1BmeDNKLdJIqQYoIWndlZSPcW9DEnMkTIv4?=
 =?us-ascii?Q?n3Xy0u5Ks4SQfS/QgoV1USx0sCB8SPUuxpMYGPPZipQ6GGUr3+HUYz188eTS?=
 =?us-ascii?Q?IX+3fjvZZCc16/RtwpKhPoIfT3SGWSjw+W1iGqXwGmKppLcPmpNnb9y+ohQi?=
 =?us-ascii?Q?mn0Rfb8JrCPXRIbyhQByo/aODJSGz260HyDPqp6g/M+JZpgOk4pzG89iRM/G?=
 =?us-ascii?Q?Cmqbaj3nZ3gy0APU7kEvH+4gzcBjzZXtzq7PBbjuSkk8DoPlltN/OJSUMSNx?=
 =?us-ascii?Q?CsxfzLm43SCqeSAf1JA8z8Fnaw00qreIdSCYmhlIoVa1JWwwY6MTbknxcn/U?=
 =?us-ascii?Q?jpslbg9VY5H3Vs0CFObwoDLVQX1fPrdZZLZ7ceXUbse30nWuWtri7shPXYxk?=
 =?us-ascii?Q?AHY5QCpq48NUT0/zdOqIyfeFSrqgxgWMfmu5ZfnbTCv2g3tED3xE90t4rCYQ?=
 =?us-ascii?Q?xh0Wfxm7lAQIylXHGVVuOqNjQnQKIUTy5AA1Z2noxlH4W5phi/xmWF7uLlXY?=
 =?us-ascii?Q?ZTP8VGlWuQVkHGj8eKcdMFcGEx04Dcsm4TsI7Fj1kGCKveix8acSzyG8fxml?=
 =?us-ascii?Q?dDVPMa4byHaCfcy6zId7ugFYby69I9IdfWvAe5rnylwgPBktBA/Lf2rBIjLJ?=
 =?us-ascii?Q?Je5CgJxgLCOjgXUvNQb34UlWL5RDrb5/+Xv+uENNfU17snIGpxlfAGXbLWQu?=
 =?us-ascii?Q?GRMCML+q964TpqzThJRA2V0Cm4Zu8iBchWcGL730uu2dUiyaFK2r+4k5AwBD?=
 =?us-ascii?Q?kHVMTXMSu1zvrSyLklYMkWhpeHfhCjxQ4Psi2eKrH29vzHkmQxjzv42YnX+u?=
 =?us-ascii?Q?I6oDhKqvXZ4FkpM8bowiDnhMsC2lLOhgKLzKW7W7PoRiQEklWIuciocNiodR?=
 =?us-ascii?Q?QR1V+Y24KVrJVwZovAWMZ7Ro9V67qii6iYE5I7XSkUMXY9+bsAOhMi0e4g9k?=
 =?us-ascii?Q?j4P8ibgL1mGLhYuYinuSHejI36wrkFtRiSSZERGTDyNGXHh9voqfRmBgC/kj?=
 =?us-ascii?Q?mn36dPCkIX5ncpRqVk1isKqGSteLxWqPcyzn9FhjVKSVSNeOMLbpwkzihViB?=
 =?us-ascii?Q?zq00IRHmWNVAykUxucdIgxJ2V8ISHgzVld4l8BliDDbONQKGKZXuuM8uGpg/?=
 =?us-ascii?Q?0S6lCTxCiLrkVTFqTVgP70RA5AjOCXr9aYb0px8ixToYxL8fPGbgC7tU6jpq?=
 =?us-ascii?Q?EtLCi5dZhKkPsHVOBhURIq3M2ZFlVfPifs36gEC9HN5EoVLvY4slPnsc7uYV?=
 =?us-ascii?Q?py2tjopYrGud7CXfa8S4uuZyIKUJi3nDaafxMk61P0QpPOrOuaCTBsT0RvXj?=
 =?us-ascii?Q?jDSB1FU5noM+zvFh7L2Rx5IQNzViV64eWDo9nQ4TcMbAzZppibNlY0d0XrpM?=
 =?us-ascii?Q?9OpVGHl+zQrtzhX7vAwjimVDLrzn1r1xtVnWPWnjEratw5EPSuk2r/n8Ng3n?=
 =?us-ascii?Q?6H/sWBKXAFwEleg2yssHYvd6Wwd8M4wPGLFgvfmpWHEbr7ce+OHUNbUWpeY2?=
 =?us-ascii?Q?GA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wl+8JTRLpnJ/VkOmvknghVHg4NG4og5Mj1taW0gJ8LL90zFKwQNwNZubRcQud42wJx/aSuMaw9wRmBs86iYQAz13ZJkJTiKNx3AFFTkkzscfFqLLupaTHrXHdhogtM0vrJgULsADEBv7ebizM5zPalafKlQrk4gWA2IohNj4VRj14OPgHsDSDkSXK3urFzA2hl16MbiQHnWM8uqSEXphw/Q9tpq4aLEJaN9RGDrAg+300xenYcT87YEhYRKAKWPkHlMUwNx8Iqur9TPAGUfc+Grc/aIF5/g2d0dgNz+CPg5/GJudYb0sQisWASf7t86fFcV4G0EZlInCuLV83cfYU/FVx/C3QEZoZ1vEEkzbHHhXJFnpo+wgXWa4fFYN3IYKRnNFuzr1gyBQgsDsdnKi8iNfTAA4HDMi0iW/JmwV6HisW8NL9dP1F/xTOwXj3wkAq1LUVJTJloplzTOQgTyyipdNIIGTGmQhz9sVAuspOmXZKyEGAqHQ09X+RyMyrwEC4jEkRS5mgr1awU360lTub7/zAtVgfIt+jVfUJc6B28rNd0OLkw5gcSxKJUiHTrXHNB6qD3DvJJucnY3+GInoqtJGN73LxXwJCr7JH4D1khU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c78eb9e8-a209-46a2-5a6b-08ddeec86ccd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 11:11:14.4643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIhlpU62yE2fXf7mWg9OHadxGIz8Y9P4bByL0RJzWFxqkWEQVC8m7QR6Bcnxyni07MVpyVgaZEP3LI9L3QOjAFK29lacVWlwwLZcrobpbPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080113
X-Proofpoint-GUID: Ml0xJwSz5R7HKhiewwZSV5W9c8iTKcW6
X-Proofpoint-ORIG-GUID: Ml0xJwSz5R7HKhiewwZSV5W9c8iTKcW6
X-Authority-Analysis: v=2.4 cv=JvDxrN4C c=1 sm=1 tr=0 ts=68beb9d7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=kVp6y68UWkg0hX7IE8kA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDA5OSBTYWx0ZWRfX0GffhyinZSpE
 donWMprIn0Pt0RTRSLdIC8StMXbQ1ISjdeKJgwfQiRfaNCqB5ksnIc3qpSZOB7z7odniElZgyjE
 Fmki5TqDB8GblvyHUGIfhK1CWLFTR+j5VmVPAFNYa+CfuJ4+najg3KDZDf4SZ/24k8dcKYl0lew
 4dLeBYLVTey90/nLLJyFT6I+Az1xX5Q0bQBxNC0RU5CQWpRF7YduFUvZkJJA026pp+laKR8HhfC
 BHsebVfpXF+EOMd8Yu2nec34jeH6lmvIolAWlBYsdsqIumSRu8lgfMOZF8YDaY4EDh+lzikXrFS
 0NPyLGjWx3WeMEqhLf3gQQs1FU/En805crn3Zd9Y3vG33YD1R/V8hvuXA1PEa0075G6wWbhcWah
 HM9yy4dF
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DB3A10000D
X-Stat-Signature: m58zwxuu6zftzy6psez3m3akik1tizax
X-Rspam-User: 
X-HE-Tag: 1757329898-548276
X-HE-Meta: U2FsdGVkX186Y/u3QrgBQ2V4GyY6y1Uwxg0eYAmjGoorpe5P/1pip2L2K7eth0urs1HNZX5laMW70pcquuYvW+EeIhNTLQRAN1W0MiBfEbMguZ3b7dPzmbXnuDhGd5N1x2fjvEVscxZIaB49Ny4RQ3OTHVXhzSJTSjfil9NUeFQGCBEMqNWGSZKzdvgHS/NuxlnCuWrIoliddVMxakl1LTHdbV/v0WFpUkq+N0EGBGZDs0jXlLn+1cvXyZU9OkJbZWTxXSoyLCiyxWdysk/lDdf5eOQx/aph+8hnkWk1ya0zZMCexwdEcv52E0zqEyXT5l8wXXfWvDBLXvnkc++BhV+n5SOSdeJ/V8U0bmB2uT8IDmHFOtNnecp/ctR4MmRRrhk5E9zSP0l0Vrp3Vp1WBUCBRENV7O3MqdRR2a5XDsiEZYUfigxvi9hHC1sXEv2RwpCbQVYyFQNRV1Ps0xwumbTZlLsuBOgSMEEMSTHoKj+yFjYfxtxkz4rv1atRBnQp26/gHYVT1NSBE/vXLIRHTNxtJJP1EvNLSZYdeCKo39HFfqOdguxYkJwx7yYIzJptD3xbwS3MS7ezOxZLUUXayUSG2u4ZRkz+qJx8UczT+30FYfMl0kawFQ+fvKZJrOj8P7QjWbUXr1ir9VBhe3BklJLeI+2+G5Rmk6mAa4Ks+qpFl59FYsHx6S+OtGMm+dBzW0S3w6aXF2TTh/RThDz3X/3281ins9S66OURFsa6ZEt+H4cHIuOK+0cLm1FnjQBA0BTotw589E91hVHZ3y5LQsgVOyWHHsdAAZ4MGkSJWqArfswd9+x71mnFFiXt4SO2pc+yQxf2DvIK0WTHJQ1P5x6MCBR2WcOZ3pdrGODilYjlh9rLByIWg952MSiOvgMjFt5mIwF7kl03FdgCVo9Qo5ZxNUXQgg0pvapdqSoqGxMqQPs98nTJLvQ5AefKuNOe6TKcGXQ2eihTPQjTpez
 hSJBulGY
 lcE4kZBNcPbFaFS14gfjXzFaljAtk8ytKUEQfKFdVOq+BtDN8lkvffT6SvtzftT9deY4v/5IL6vkn6eX2XA2/4ln3R8WctQPe6d8/I9vCYB3MnzKp1v2p3sOI2XCbo5huhc2ZOXDjpPmChX+SkBxdO8ogcdgBubtLL6CO83ajsy4VN3BkHmA8Ve7f6lXjwHR6B6eGr+ZXgzHHsi6ZwEy6h9M5YeO8Le7rsL2XIuDi2ht5/G2SQrjiNQt1oumMQ5su+6rTV6I1D4bacBLep8GFBVCtp82poN51Nlp+aOxAwYdthhjY7yfPg0ELwDXz9Gb7CrTwiiIH8NFdz9NC/yO4rC3RRYCGoJgWWDCx30j1evIWFtBme9nwqNt5JdykvJ5y4m0EkfUGEKQ0tRj1ISqtx8LnXUXBO5sCDsHCWY0RP88X1fGAYLqKnlpBr9c7VhxQJi346Odz74yPXXRix507AnF5dzHk7Vg5Zy7JS5CPwNpS8VlKarSSeW6ZmJdGNmeG1lpdpvIfl9PnN3UZbOBpnwq/XkuRY3Z9rtS+N6AmoV0zvKc/3Tjh9MXftTk9QcGY6feskorcMLO1U87ft+1Dt6do0WqKO2OtJK7rn0aP2DAlWFTZAZt1cy7knEGqCRW5OY2bpUVJFK45TBiV2KgRNUAU4MU/xTzCKfXr6/Yu70Ldd+R+Tl0PCXZNtrqzeMPTLBsmkEDcGsUp/rM3wghlKVBizt2SPjh6B9bqVT9Bsk7/9Y1zxa96jSePBjbOprjyjQvf7A9NdFOx9KxWNQvL2BFdXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is relatively trivial to update this code to use the f_op->mmap_prepare
hook in favour of the deprecated f_op->mmap hook, so do so.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 kernel/relay.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 8d915fe98198..8866054104fe 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -72,17 +72,17 @@ static void relay_free_page_array(struct page **array)
 }
 
 /**
- *	relay_mmap_buf: - mmap channel buffer to process address space
- *	@buf: relay channel buffer
- *	@vma: vm_area_struct describing memory to be mapped
+ *	relay_mmap_prepare_buf: - mmap channel buffer to process address space
+ *	@desc: describing what to map
  *
  *	Returns 0 if ok, negative on error
  *
  *	Caller should already have grabbed mmap_lock.
  */
-static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
+static int relay_mmap_prepare_buf(struct rchan_buf *buf,
+				  struct vm_area_desc *desc)
 {
-	unsigned long length = vma->vm_end - vma->vm_start;
+	unsigned long length = vma_desc_size(desc);
 
 	if (!buf)
 		return -EBADF;
@@ -90,9 +90,9 @@ static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 	if (length != (unsigned long)buf->chan->alloc_size)
 		return -EINVAL;
 
-	vma->vm_ops = &relay_file_mmap_ops;
-	vm_flags_set(vma, VM_DONTEXPAND);
-	vma->vm_private_data = buf;
+	desc->vm_ops = &relay_file_mmap_ops;
+	desc->vm_flags |= VM_DONTEXPAND;
+	desc->private_data = buf;
 
 	return 0;
 }
@@ -749,16 +749,16 @@ static int relay_file_open(struct inode *inode, struct file *filp)
 }
 
 /**
- *	relay_file_mmap - mmap file op for relay files
- *	@filp: the file
- *	@vma: the vma describing what to map
+ *	relay_file_mmap_prepare - mmap file op for relay files
+ *	@desc: describing what to map
  *
- *	Calls upon relay_mmap_buf() to map the file into user space.
+ *	Calls upon relay_mmap_prepare_buf() to map the file into user space.
  */
-static int relay_file_mmap(struct file *filp, struct vm_area_struct *vma)
+static int relay_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct rchan_buf *buf = filp->private_data;
-	return relay_mmap_buf(buf, vma);
+	struct rchan_buf *buf = desc->file->private_data;
+
+	return relay_mmap_prepare_buf(buf, desc);
 }
 
 /**
@@ -1006,7 +1006,7 @@ static ssize_t relay_file_read(struct file *filp,
 const struct file_operations relay_file_operations = {
 	.open		= relay_file_open,
 	.poll		= relay_file_poll,
-	.mmap		= relay_file_mmap,
+	.mmap_prepare	= relay_file_mmap_prepare,
 	.read		= relay_file_read,
 	.release	= relay_file_release,
 };
-- 
2.51.0


