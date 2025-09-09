Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E983CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0005C280001; Tue,  9 Sep 2025 05:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF313940007; Tue,  9 Sep 2025 05:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F8B280001; Tue,  9 Sep 2025 05:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEF77940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:08:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BEBF11A03D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:08:52 +0000 (UTC)
X-FDA: 83869136904.08.49D47FC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22C7514000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:08:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fFqPmFWs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y1h4W5BL;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvDkkzStq0ctcRSFPlmMvQc4HEHrQ+8DT1FhHiGdYi0=;
	b=3jlvTV1+tztCfCRXM79eq2C3BwUk05RQeQ63127kzUNC0JHDfJzeFPobQ2fztU3Lvwgaf1
	Wz3YNN5YxtA1sF1zZK4UMjW65YdunNUqd9LAxNg2ou4MCVi8B1W842Fnl2czXuJvUDFTO+
	XgqgUPFNOvhjQGIpthEKE3HKnkB0yE8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fFqPmFWs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y1h4W5BL;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757408929; a=rsa-sha256;
	cv=pass;
	b=vJvYWK9G0P8paBQPf/KmrNzRw/YpCBxR/uOwHLZJDRxpuoflJvpN5JFqmzGfDnjukPQCGa
	3y/Eczum2Wn+iZpWKq6j4LeABhc1MoaVfgD2k5RfPf4Y7r5YpUgrAKvdwmODk2psz2VcVF
	LtkcjZ34LZoaqbEj3tK/n+TydPwal/A=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897gIeB007710;
	Tue, 9 Sep 2025 09:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dvDkkzStq0ctcRSFPl
	mMvQc4HEHrQ+8DT1FhHiGdYi0=; b=fFqPmFWsKTENOOdoIykrwHmvp3F0xJAn0d
	NgLYqAaTKzbmFTeIUbKqpy1vD2j5X2bhzMk0BvW2M/QsyTCjhXsqYtemGB0Wo6Oj
	+nkRf9M0uHA0rDno4MXxmWYYo6D9ykm9TC4Gv8pmoHr2TEzxnNd8305QtbzgGid4
	HpcSfdA22qAo8SzoTFbbrwvZ2i62e+0lUqby+5yGXcn0dqPLSBAkHjjZKAHbUGPd
	/hIWw7XLi3TX1QgzetaCHkPEdzTtopuZ914fVcESu3njVx+2VPv3jY1KeMmOx09O
	0mpfuZnkwzFJdHy0PGj773F2NVOmOOLA3YLz9CF61wzDQvqC3pEQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922x91bbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:08:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5898fLbX026058;
	Tue, 9 Sep 2025 09:08:28 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9bh08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:08:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+aXh/zznaaTd9kzyemDT/+RDXDtdXt4W10nhW/bPGaEQCnjKCnjsC9t79mF7JIw+3kebWMiMe/fElswXxATG1egCFTW8g2BtGuN2I88fas8/1Dpzw7VWrbXJXu/DwDFVK3D7+u7KveJJDtEibEPyElHQ2xCGptnYiAd/s/3LPmMA8MQgwaCYmv4oRNUTTV2OBh9N0r4/Q7dVLe6ZDiOcxuQosnbV5Hr0CswlBNLcVUV6Yfx4fmfuovYMJN+4UwqbNIWF+G77q34dhYEsmoJ32tzSOHlnfRN6RMzE7hfjy/5RIns1YZUTzFVb3gf1YXWdKbz6rmfHPL+Vbr/J/220w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvDkkzStq0ctcRSFPlmMvQc4HEHrQ+8DT1FhHiGdYi0=;
 b=nAKuZg3zc/1TjB7T6O44WnJ7jEq21OhF++XEwMtNDfnwh8SiZI+NGSg3IlPdeVNQU2O1C8KFCePOzMf/ddTdBTwrWjYa4/aiM4jVJmG80H2hjiB0o1MPKivy/7pr3WaiclsR8zuYnE6yL5ZliVX3sNuXhSB9TOiUGjRVelzGnFbP8rdZecjtjigxL7jttRaQmwIm1EQj1odxzsgDMiWVuDoEbzTZHOLfb18q9m0n2+AQdeQ+6B68t2r1IGX5YkllZprsI2OdQyAxp/zu2gGifItd1BdrdLeDGmgqZAQKkSe+vf7j05nhdHBblo3mmdS/7V0qViMheKiKkzGCz6Myvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvDkkzStq0ctcRSFPlmMvQc4HEHrQ+8DT1FhHiGdYi0=;
 b=Y1h4W5BLXLylsJVU/gyeuFYsRPwXJVaVEn6LaaYwQ5ptxrUtNnBRbD/ymbJ/y9gkrHukTeR3SefzDUwDUaOdHsfzDxTXv6mvvLNvZCLo/dZn12HcoN3JxFZaE5xhqzMR95UXQQUdpVw38N/4mKHUjoX17rBBjoNpesiDWN6d7Zo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPFD7011BF84.namprd10.prod.outlook.com (2603:10b6:518:1::7c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 09:08:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 09:08:25 +0000
Date: Tue, 9 Sep 2025 10:08:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
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
        Hugh Dickins <hughd@google.com>, Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 01/16] mm/shmem: update shmem to use mmap_prepare
Message-ID: <ff2d31de-be6b-401c-ae33-db2f01c87a45@lucifer.local>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <2f84230f9087db1c62860c1a03a90416b8d7742e.1757329751.git.lorenzo.stoakes@oracle.com>
 <2a08292a-fdad-49f1-8ad9-550bf3129b2f@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a08292a-fdad-49f1-8ad9-550bf3129b2f@linux.alibaba.com>
X-ClientProxiedBy: FR4P281CA0206.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPFD7011BF84:EE_
X-MS-Office365-Filtering-Correlation-Id: adffec46-52d5-4253-4bf6-08ddef806f1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?68MegLdoEfEqLXFJKh2/9FC2k6cnYVIQWkL0GPb8SlzmgXMMs7rdozKlc9sM?=
 =?us-ascii?Q?FH4tjQ3u+AoaZqLg4/Hw9buuodpJgKRL5f6Tjp9IlA9nOJpgSrUhhyl3YLc4?=
 =?us-ascii?Q?UmOEQt4r2iPuKWSIP/uFu6JaKTuWLtKFv9raawSTEkpmwQennHOO2Xddlt0r?=
 =?us-ascii?Q?hhPn2/k7g/YVoWXlKVUbd++CgWFpT8W06kgl4bEC2DWd0gZtPj2fq/+7HFcd?=
 =?us-ascii?Q?5fxLIlQIfaYSNqf/RaZEoIgt0EAgGhzvmwsRghC5NqzlJElH9bCgsnOXwHu9?=
 =?us-ascii?Q?kcOW/f/yJ/0wDwNcJK7Egidj6FbbwQ7IvcFW+xYfV6VG2QGIP1tn2CyqQOmu?=
 =?us-ascii?Q?kNMPQBEl4S/oeITiDwTO8MPRG7T6c32hnJMUtUgSxFedtnXLFcrgd63S1p0+?=
 =?us-ascii?Q?zruIBumeMFjUbt17C5WdcG1bq/El/FhYj3lqo9bxt4iWdErUfvwNkqZ/mrG/?=
 =?us-ascii?Q?8wZretWRpUOO5QUU6xTqUSMbNf5IGxN9dDLvadCRfnERAPQlQl45PQLm7lvS?=
 =?us-ascii?Q?Ct3R1Tq5S2tgcqfedRCiOiVmxu7AUYiuSCYAz9yBx0/2BJZAIVLUEWaCL4BQ?=
 =?us-ascii?Q?rpL0EE/GrIR6AapCZTG/7CFJc7Q176h4T3DJzVxtsfV4VwZenwFB+2cxAWHK?=
 =?us-ascii?Q?KBMmaVpEMZ9dTiF4nnEkKtkqbDo5UB9nrrBsajG8FN/3q82z3UwE3g6mCEfw?=
 =?us-ascii?Q?78qVK5Atl6pMFGIh9Kpl8y3cYxi5jwqpWtP0sgfXooqwWRdespLwWxnijGD4?=
 =?us-ascii?Q?Fl0iFmcdfjxOW0+VAPfDtSErnS8ljLXy23R6pIXEotWq+UgMCX/XbWPFwN28?=
 =?us-ascii?Q?qxmJ3Xe3WaB13SSV+PBItp2bW/5DIxe3L3V+ZNki9O8PqWmjQZCtQahrY8kq?=
 =?us-ascii?Q?Oq+j9odklUB4zourq1xhMt6BX9mr8QFF7ehD/ZW+GQ4uOOC/ZuzVhUTc7IJZ?=
 =?us-ascii?Q?bxd7hrGHPjxHpxOCJCqAtrP76qtyzV1vYJ7NIELSxY6Q/RL54IUbeXdsRJsh?=
 =?us-ascii?Q?8RLDxQcNQEt3BFqX56jCFwm/Du1UzKS2nB7Q63uccApAPVJi+slq2BJylGCC?=
 =?us-ascii?Q?nBP4gUJbfZiUVTaIig3iY5t69bo65QOuP+qZhqOFMTWZNe9sMrzK9Mr+W+4i?=
 =?us-ascii?Q?pNvzmlErzumf2s1mwaCIvmuiN6lvRkERCDKnz3L4uplD8W37M/bHHkfgWFkU?=
 =?us-ascii?Q?MqGXO5MDTN0Dui0guaPXLGMfMLXoRVu9/3ypsEfgmV+7otB6B+cOttGTYNCV?=
 =?us-ascii?Q?ITy2+4FRkx/PwVEvhx8mf4q/hZzvxUmbWgtlJxISFkda5l3/fBi86zSZOIkI?=
 =?us-ascii?Q?mBSBXLK5m94fynJbxlH7aI8Dq/Oj2zO5rW+wHn1glTWehlcNfJqpMGiKnHs1?=
 =?us-ascii?Q?e1dPTqGPzGYT5yeY4u1Zmmw+8ZRYA60cF0O4izK2DVQyYuZ2u1VGOwykHzNQ?=
 =?us-ascii?Q?zE3aQ5KDaF8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g+kwI8g51sSv/ZqGr02fIACX8N5CPo/fGyeKZifNSKDmg8HlxtoVmOLjDAls?=
 =?us-ascii?Q?rdAzwr8cP2Af2CM1MUfBJn34D3tlfbfEmvgB7WyjelcZA3q8Qz6zrhYqPJyf?=
 =?us-ascii?Q?M55qABmQcvUZ+2tmpnJgqy10mdBBNiA1364MixaaLYZjkQpEcq6v3n5KyjdS?=
 =?us-ascii?Q?jQORjdGF1ZdPT8ehPtuXccvulE8nJUTJOtimTvlpiwglDS1d+b0DX59dH/V1?=
 =?us-ascii?Q?ZZdHPfIeAoiO/I4bFpSqkFVQrDIOMW7Xc/Gi9s9jcobehaoY7Y4vBVgJGgw5?=
 =?us-ascii?Q?A0mnSoARHhmWlpt8uoziKP5IQ822FEv2pSRVkI9r4CPNqO5n985+pF/ogaJJ?=
 =?us-ascii?Q?n0tS4hpIILntVWZdXFSiiMY7o8MN/IJxHrcwOxpiYeiSg6c1P103UU4efUPl?=
 =?us-ascii?Q?+yNx0WCUDSoZ+wFuSWPIcTAXXaoAql78W+W1UBR/9Ej0jdumr0dq5RE8wnyX?=
 =?us-ascii?Q?cisX+SJH/3iDp/1lKsnr5MmPNeMGdFGVR6ljUpEgSsLWlZnhFPTPVZ02MyKp?=
 =?us-ascii?Q?0EYDmtV+7xLiVb9pgnIkmpxCRb1suualbYZsq0rQYiYwnxj5eJ5rFZRIk7lY?=
 =?us-ascii?Q?A8SOKKItcge0Iy3L7e4O6Yopks6tAuH7uMcHMCO5BlPbaW6jfztSPRVPRumc?=
 =?us-ascii?Q?DDaR/gd0LLukEnKgusAjKm0iYm2ynOpcJy57UVpBdx1zBRkrWcjdlUiHIKm9?=
 =?us-ascii?Q?iR+PfucsjvMIisPyx6Dh1J3coVFSIfVSK+eMxmnaNO9GXm1jBfoI98inhZfe?=
 =?us-ascii?Q?nWNKlXXF/QvuYFPqZrjGQS8ki4Bn9NXG8q4XN85JP1/rmREO1wZIvsgjjUAD?=
 =?us-ascii?Q?VKRVH18k5Jb+4H5IE9Akm+YSPCC0+4nEs3pZ3p4uR6HmUpCpVYjxqgeXVJ5k?=
 =?us-ascii?Q?0fvrYRGSsh3Slj2K9g+yeix8igyxP1p3y3apF82D//a9CDoFldyvr4expL1q?=
 =?us-ascii?Q?/SuPWMr/16WXHQb/E2N/5C0YoPF7C0qDHvxMAa82PAXKxjrBT6GfxuXQXp0w?=
 =?us-ascii?Q?+VaU+R4z95eXEBTAuld7md2OVr+YkzYcqpQhuMk6ULw5Ree4m4QmX2oIkelU?=
 =?us-ascii?Q?Kqk4rYPQMyIF0EB5s7xyiPLDoVLNmV7b4fdrnMrWKxSVzcNXelHQ7Z3BmlpR?=
 =?us-ascii?Q?xmhBAQA55hUxbaKv4Tkx+A3AYHRp49MN29TQTqzhHTGpVlz/fjdzZle2yTZg?=
 =?us-ascii?Q?KfaqKz769Dn5TeRAWFci+q9wx3koNSu0c3r4DI22E/tQmPIUu21Mu8ONQPZ8?=
 =?us-ascii?Q?8vv5TuhBLF0Z4nt6Di2Ye4fwJM/DybrTNiQTrY6HhmLd8Iap5qC3fL+GtZ2w?=
 =?us-ascii?Q?Lm9okN0aH3gqvTp5S/UE3b6uQiXNSUZy1BK/Z+HDlTRlimtEiQ0QbuLbA6If?=
 =?us-ascii?Q?j+3f/aYkvjtmJT/9wd8Yg27/jMBmLDgS/AO0mSmqEbc8YV2PWERYRsD1o4MH?=
 =?us-ascii?Q?2cVBGbEmcwXicWLe97NLK5DJQVp1cs+VtXlea+DtUxGTJU1zhtH/9TvgcYAN?=
 =?us-ascii?Q?zmjOi4s9H1hSd95qXRAZv75fhKDmHd/ldlWqgLySOy/ec4hcZqHS+Xo8aCwc?=
 =?us-ascii?Q?x9+GtDmROFSyjmedACycWyJXmcGZuBMD2qRcnDXGxNp/xjq+4IBK7G8eK/kU?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iyBUF/WOAo+YF58AfRJiSEB8PR+3rzi2Re/efmeOOeOXrXb5JCBTCtbjaNYiFUT5UG3272hhJFwKOlSGvFhb4hmlsUEthBFaJC5d3qt7JNAKu8/h/f2piC4YZEIG89VGDbV6oQhiCdcKBjLe9mttyypuzX4llxRHpW46nGthZ8y6rV1uV089XPN3UlduWAlAB7jUaXR/sPS/RJ+NDZdh3C4vDrYtAmafpo1Y8aYK4srHn0Fo0EoqggGH3hEK+6sehM8BYpjUhCU8ygLllHAnXX2ANYppv9VNTQg5GjnHZWYHdhwa6k4Sn+WvbDmnd7fyyu4c54vNhUPY1JkZREaUvZf8QL651lIee0BfU6xzeQVWwcXyi1bwxqSeE612KBrsdFxkjGWfOV6GXdnbWz5EhRJI8pJ/qnGx2OG58uxEVNYpwuMzTHps3n1bbIt1vtp1pxqzZKGmBZRKFg9y1TDH9ORwKpAl99rf3ApNY/NOcJtFlWD3fbvdsbKqLZ/S2Q9wI30aIFEHVpUBwrS0dW+kRzt8cgOTDkZwuiZKH1UJLvK66c1Bvc1rAZPJKS2pg5z/+Cbx3l6PhsfRjUDesWnr0MGFsVrMoV/BLVvvz75eFPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adffec46-52d5-4253-4bf6-08ddef806f1a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 09:08:25.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sw1xzqBEjVnumaCPawD3R52dJyNZOaunZd53xbzdW01jlxifkXZ1ZWBO0Wzc35ScC/uE5KNrKqgcjL0fGuicNXP12QDyi9sL/byiBfXlxek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD7011BF84
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NiBTYWx0ZWRfX+OV5MzDeO51Z
 pzsjj/FiUAILMKyV29AIoRhhjTVdAr/tUxs1Dpcv+O9NW9xWIvux6hL4GmuU4iPRcRMVmXXIOFY
 OoOQXQrs0nuryZOOcX8ZUrGAiSkzB/pEcr29Er8IAGQ79DfqpCU3c0Yzi7Kbra7qx3hDtbJqZ46
 euQ5mk/kUhuMYTr+6ryiRfY6aqjSzE/zvSSupNkxye1UK8lGR0F0nrqMqfhC4zcqUUEeiapb+TV
 V4RZQBd1TU3QvQjTOU1zZ2hgCXhOLmBrPtNYj05B1n02hLK1zNgfODiroD5+YUrXIlYlmAV2Ez7
 tJIbksyC1OOkMkdfUFV9kWhxgmCpaOO42QH3sZd+B4hkfIZwIS5G1jhzEIxmj7vpnpHJy7fuiaZ
 1YniYYe4J1wWoFzTBNKFp19rm2buEQ==
X-Proofpoint-GUID: igeNx_UfwlDsZmY_0T0_GYR0PIhqIMh6
X-Proofpoint-ORIG-GUID: igeNx_UfwlDsZmY_0T0_GYR0PIhqIMh6
X-Authority-Analysis: v=2.4 cv=LYY86ifi c=1 sm=1 tr=0 ts=68bfee8e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=SRrdq9N9AAAA:8
 a=UQyiNi7Jvx-vLDuNDE4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Rspamd-Queue-Id: 22C7514000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3wbntkaxaywg47kwtxkkanajyrrgghxe
X-HE-Tag: 1757408928-561326
X-HE-Meta: U2FsdGVkX1/sDRSAG3FKDyH00MZokXmmhqQ1wzNwcSiGV0iztzqkQBUxpvY1hQkUMuOhSpb6mwXz4ZMbhmPVkwzc6+hi8v12amrSNDyT4O7YfCXkjJ7L52q2Eav4iZ2fi9DBOy/meARRgy9erTfhbuqe4G3N2VtcXgB9mWDdNBmowJBdGHIo9sl9F7ubbh2zyKsIN88UCRPVbWSseO3t7dezob7YCXn5vhJiclbH37NkZ48A/fJoFRT2Ao1Qc8KG/0hrpYtHMLI4UJRbSjQaYUl8lKeVc1flHW89hbAXwrS/uXgY21hOCi3JD6O6osGaij61O5Hj6IEDT/VLn0+AEiMQWbPTJZJAUZKWHEEAB7DbcYHCG9njP7TUTlWB4kAT0CVZnN+AHgSxCOaXKZ6zBGS1AwaTzf9ydIxPx4eOYRG+093oqzNdMfSzyTpxuvYuhJGMUzkDJRKImtqqd99LyF81xZjnG1aIQaoVYaLJ6N3AE0gv3PBa6+6TKszTNA8+/BGDzEd23ml0ueTH1En9vIMuc06u2mdHzXjQGu0JoJsOMfMbZFK2MNoE9flkmRgoYkst9lhdQFAZJxms/VRbFPjh5GjML5JlIk405PJGpmrnK2d4mqunKIl+B6+na0NlEV65cpQqoVjea4v3+e0Ss93l96fWqVNrDL92jHQbYAHRabAhBBJyMAcXLg1w4nUCGYAqG3IdqgdLezN6epUbJahliWBmgDTBccJYqp8kt9/udgIbiIoDRi/Zt4g8A16B1SRpkpDFmTW49yKIQOrVkrlvurGnG243+gvBCWQ3tphmM9lWvZAYe5li1IukyIjTFkL7Vo0K5bLtMNVzz8qhIPDj6r+VSPgmto62iwqoHK06m5EbgxZIP0OmmkurTI2kB3wkEzLcko3VNe9r3BBWux8xEvD0huMZWB9w6aNQOddCGWM+3kyRwG44XJ+5rGirasveWQ/RwupkzBb4KQ2
 L5whLOiN
 zpkGWhyk27U8tX/zJpTNDJp5m11aWTzjoIWcFXMrQOleHi7YAUOM1mrPdqdFCFguFAwS6QJ1ZOwtSZ7V/VwMjidqEqjz5Xh81hWygLg+bLfq2noz2siSSq4QhxSG6vtH7M5xNusLN4FS+6LNZzNlVTXHLxR7TmBRy4EOoyPhAUZJsZ4/MdlsR1cTse2+O3RLJ3J+Dp/JHBN+GzXdJLFtCEOm+bTObg2WGD+3EknAb1P0HlAC0nxlnbXMlPJFuwcZW5SIvVkzKNsNvsNCey+T2O3s7z+ZqX/N0CwnDeJV2gV2SRohsK1oSoqIsxYcYuhdbDRxg/CsHJ6jvwOg6B8K5B/sROalIvTBMGkWxGMAZ/DEW7RMcy8N9exe9LWS0f5XuEq/yqtL58GPy0qwU5AsIU3Gjp2HPh2TqexdaN30f4z7JFHVT3QHJ/U25kwX+SbB8L03BBfmfZL9HGwvecVkaQt1ntjlSqaAy4yyNio02W9GifGu+OCgb09Z53/OPsaADjZQqOHbbQISbkVmxsOJQ6+wolQhA9PL62ZF5VeeXy3AWzlIJm/n0IGnUcOLaNm6DSr+sRh5B6ZciSQPu37PPeGle+jipnJbTDt0LV/1mtlMa37eMGte0XHuMdyPBPqiX3R4YsKsiEn6IZlfMEmdf4zL3A+3ETsZS4UIM4riJsyl3KPu/AojK21gRAfF3GewFp3mk0Y3Em+TBCK3CuQoqypdYrukBNWsmAvPMbplVeBPxg7s6LqL0aK6W35cHYQ8JRR/OEFSorzBQ0zXXwhERHCV0i4GiGOs/gCmVGRN8ZfBOZ+X+8xabZbUMWW4TQZxD/SP5XspmqWojdrCXDc+TiZ6FuM+vOC99a3w1exaJNSp7dM7oJdZAom4bJzgti+PKdppN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 11:19:16AM +0800, Baolin Wang wrote:
>
>
> On 2025/9/8 19:10, Lorenzo Stoakes wrote:
> > This simply assigns the vm_ops so is easily updated - do so.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
>
> LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks!

