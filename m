Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618E5CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13AC8E000F; Wed, 17 Sep 2025 07:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4668E0001; Wed, 17 Sep 2025 07:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D988E000F; Wed, 17 Sep 2025 07:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8848A8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:17:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DB0D16050D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:17:15 +0000 (UTC)
X-FDA: 83898490830.05.8C3CB70
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id D118080009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:17:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l/ufunWc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UEGsJ+0g;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758107831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWf68Mg8+CdUweMbvcn0m03EHHhgSPHFqjBTHsztv5E=;
	b=h+r+k2jVSNONqGhsVBNOY9lqFI3S1hE1a+KfE9dxuKDNbFNgJ2EMLND3Ui5dFdbUvG4PqI
	GBTH3c7OXm8rix2UjqI0OGieE5zH/8EUxahSEO68kAH75SMbOF58pUFDnpxcBGYAVhh8Ye
	1avqZohk7kK5IkMeYb8lceNhcakrhaw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l/ufunWc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UEGsJ+0g;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758107831; a=rsa-sha256;
	cv=pass;
	b=x/H5q73LFygkIXutw5bwcEtq3b0vD4KNFrX2122le+CoNcl8p1maKc4K5ga1+q+1kfKWcJ
	Y32MsxJSgXi250VTCz5VHnjJt4nZ8EbMS0NgW5JHDtSLoVqG9G3SKXl0v5+U3voCvN30YG
	NpuzyAFGGocve1TvtsV2cIrwmb60K/0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAQkLh010093;
	Wed, 17 Sep 2025 11:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EWf68Mg8+CdUweMbvc
	n0m03EHHhgSPHFqjBTHsztv5E=; b=l/ufunWcP7AwqgCZnP0ZHek2uOiILUpWPC
	mvU/Tx2OTAgX/HUGgt8AV2gQRJbXEHNgntmYfZnTKkHWQcDLoLgoj+oGUvc35GCh
	mw7Yfd5W9FaLmpPJRaZTl6sg3tKoE1AImu0y40EptXHKHVTfoSmm0iwu11GjjFjt
	lFGHDBNsWDvgY4yQH+1zKD0TS/tFCOyEqdRpUNVrGEOknzem6cfOQAdx1FCYVXF9
	vCbLeFcPTAS0UdT9/C1SoiLAe9SYq6Ua50+z4GBNUsfjHLA/TXl8bzToPyKQ2/rV
	8MKZhzLhUZPVtBCaCcGtMwK9YlFrPh4BOVJ3kjDZ2ze5u/AbKxfQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx8gy0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 11:16:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HB0ZSR036779;
	Wed, 17 Sep 2025 11:16:52 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011014.outbound.protection.outlook.com [52.101.57.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dn6b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 11:16:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X2nSugn+jmeR4x+2Slnt0dJLjwtpx6Y3XSPbftTHT3MpaEgNF7McMTCqaiPGoulChmSqBPFMCn3eLU7i/RRIZkPcutY21aboaPqv9Ux9mEDDXqe2MuC90TBr2sPrssvVa3E62RnA6IHlzLqh1cMglWC16gTwbm/WUJi1NIEyOb3p9d/aBvqBH7x9ZyaIJChVCoCgVea/k0ha0wBMFtljtn7Mzez/4yRKCKmKKIxk8zilf8+01GEqLxRiKAWiGXOMft9JypZ6TxL0GPG63C2+1ZmL/RZLInBbcKR9te31NS87iceAxvq38q7iiW0ze1KAUO2xnW5gQH2FxaJqH/w+IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWf68Mg8+CdUweMbvcn0m03EHHhgSPHFqjBTHsztv5E=;
 b=kZqmFQjrbZWVk/xZpcsKZ1WotvWJXZI6O/Gr5a1u3kVXF1JCAToG9UTjrf3Tue73Y6JkuMMZGEzc2OaB+iJDfmmd73t33PO8eDVdI/tNknIf03OPsOCdNo8BeWajEv8QyDCz9FPDjFEabvSiZyfy8yG/wnluo3tAIfOyGlruooj7GAQTskAQyrwRxZY7kXM1r3Ok2LD5F371qEE5dj20YZQoALJCGMPK+SI3GngyW/Lbf8dxR+I4x2XA9poRAeSHwmeFIxCkmrTB6KVa9pJ36Begyxh3MqPWH3SfLLpp8nnVlfhT6zVKdUf4Bi0riDRnCFbaUxFDquRILqMMRr7kSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWf68Mg8+CdUweMbvcn0m03EHHhgSPHFqjBTHsztv5E=;
 b=UEGsJ+0g/vjzg0pwHxZoP8jEny7y8ifO4b3sfl4A1SDWw1lFou9g1oAeuJNjrkGdc9gab249MCqHu+ySKkJ11K7ODvyOGVz5ZKI1KU8rpya8GJ5wZMIVyOjR+IjeDN47tdFyYUUm9HDAqPz3rUBQiMkipQ40HH8cVNETqDpbGdg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BN0PR10MB4936.namprd10.prod.outlook.com (2603:10b6:408:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 11:16:49 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 11:16:49 +0000
Date: Wed, 17 Sep 2025 12:16:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
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
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
        kexec@lists.infradead.org, kasan-dev@googlegroups.com,
        Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 06/13] mm: add remap_pfn_range_prepare(),
 remap_pfn_range_complete()
Message-ID: <8ff73b67-ebe4-4407-905e-3fbc27bb5c2b@lucifer.local>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <7c050219963aade148332365f8d2223f267dd89a.1758031792.git.lorenzo.stoakes@oracle.com>
 <fdkqhtegozzwx3p4fqzkar7dfbzffn7xiz7ht365c3pe4x6hk3@zbfwoktrhci3>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdkqhtegozzwx3p4fqzkar7dfbzffn7xiz7ht365c3pe4x6hk3@zbfwoktrhci3>
X-ClientProxiedBy: LO4P123CA0347.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BN0PR10MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 58e488d1-7ebc-4cef-def8-08ddf5dbb232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QDz8NaNsuZSii81bdShs6RnplNiebBqPbVSJHoxrNA75d8uo03QAHvXZO4mx?=
 =?us-ascii?Q?m9QAMyUNASETh8k+Ll60gPf1mHkio/fz5BdRUrW0eLyZkVCeT6mOctef3XHc?=
 =?us-ascii?Q?Ks5NYvYXcWILTwqCMWWe/u5Z/YtcB6bhYYlTMtNDbIeQGREJUEIl7+uxVOtZ?=
 =?us-ascii?Q?p9EJhfcFNCDw8OzVLXJ6IURc2X9N/l6bhNEwg9P5iZG6nfS0yWKcNM+YC9RL?=
 =?us-ascii?Q?kROXw5NGREUHUPbEMswoR0XRt+98yIjP4TxEhyM3YLyCyR4n2npMCxl0zUF9?=
 =?us-ascii?Q?/YmdXum7gun0XnKrLlUPdb2qQpyy7+LJ32unr+rucdZcD4pEV7cItZtPSuUt?=
 =?us-ascii?Q?ajPhOiBacSan4aB5kCzxNNY/4G46uiNGWbbsvscPHXujAg8/qjnbR91t4HTN?=
 =?us-ascii?Q?huW0kJBzRK5l0l3XQ7mapGPSZ0B08bKCMoomorEjD8DxdBWO3u5nVPS+Zy+g?=
 =?us-ascii?Q?c/5+Si+rH/xOVQ9DeGZi3RZGLlduYLJS/Xthq3waxsDIPfgw6KE2k1ed3Moh?=
 =?us-ascii?Q?Y2qtQmKBpQ8wmUaUmjJfr62JCBDfowrKYrMv25ScGfh6p4PxpZ9gjTDg+ZA0?=
 =?us-ascii?Q?QA6KJfRaP1qUGHezh6nSRcWPaj8gRwfWhCl8CXhpL0UCE2lawQRRnMTGJuSU?=
 =?us-ascii?Q?RY30HCRcSXYGQxoyWKXI12cihfg4caBPEy0tBxDEoWZumTx6lQcBoZB5Fkvm?=
 =?us-ascii?Q?QzerkTK3DcWenau2OdIPlMGfmFPLNZJZjnELDsbd2TQyb9eOsZe9oDy0TaKT?=
 =?us-ascii?Q?RUIa9VOj5eFM5y0O/WeLBQ2WzBwM1HKsERqWwKVU2GROaTq6bXIvdOCko3cX?=
 =?us-ascii?Q?veoC0WF6kl+mJ8WFeCBnUyibnxoTOwCWi2eenjnOyTBbjMQRbhWX7afJZmSS?=
 =?us-ascii?Q?NB1aog6EzkGr2pqFaUiJuDPnDRfwffhOB0BANmJ+6lTDpqv8xDNg++Yu8APo?=
 =?us-ascii?Q?Bf9zowdI2gRWGYGgUAp7vo8B3ImolmbTcTSsF98WXYOTgcC66pEPa7oBtkb3?=
 =?us-ascii?Q?jbE6Jvjc8v2ZoyZfGIdUTz4GJFhrfmg3SvU8MmS8/usPce/n67iLi6GfWDLf?=
 =?us-ascii?Q?+iT8Yz97bf1NABeZ8LTE6l+Z3kCLBufhIZ3H/kMPOMi3K6dfqQwhHtG09Ly7?=
 =?us-ascii?Q?pRMmY8rzgmJHQNJwEwJHs4D1y033+IhKNXTNJ6Gx7i6InEg9Xe2buup8Vv9h?=
 =?us-ascii?Q?NArwWTDtPpjLzFFnI54E1PcqccQ+baimmnDle5OnXH748f80W7VPKhraRlMt?=
 =?us-ascii?Q?SKT3Tb/lqnYHKBADTbNO9hq26Zaw12htP+bIYonudTKLNGLEii1KuW7d1WLJ?=
 =?us-ascii?Q?jvW5WGWM+6t0rf7q/7FtejCxNuiIXzavxEI+maRwKlr7NALKOLmt598qQfwl?=
 =?us-ascii?Q?Z+oededuyBYJznP+2Syaz6h0dmCrAvwzR2Ie2u5VmqVZL+AOgLQMBlslnd3G?=
 =?us-ascii?Q?PqT0+X3tOg8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ta104v7gL61zsVJ9wgoBuq1UniaMCeyZqn1lb76n0nSwzg/qKW460TEAbjgn?=
 =?us-ascii?Q?dmGq7I90HjUyZ7MVqMm83YFd24jN1dIbAL6mbVyWH2W71mcdSbYK6qPAER4p?=
 =?us-ascii?Q?GYPh1ilwmV6Zlk3zqWCneAQ/wwN6azIxoihcOmMEBh3OmAIPNTNkiw/mRqUS?=
 =?us-ascii?Q?D9/Ess/6+l6IzTNgzngr/Jop3WVaOL2gnapzYDpqqFRpQvwxgK8QuVdJf7RT?=
 =?us-ascii?Q?yH1bcASkg1Y1GQzkY381a25gHNH+uEaeXbIbdpvEOOmuvAQGpL3zrByyUCPK?=
 =?us-ascii?Q?iDS/UbLa86tKIA97VT4Mib6vy0T7LYUhP7B29lK9dSzBRGg0ZzHdeAEBbZYk?=
 =?us-ascii?Q?epgPYu6UHfRYBird5LwJWYR6iA1VLz20B336XQBji8Zbn24+vypTAhwTInzE?=
 =?us-ascii?Q?cvhCiIjhUn++ktizUUV7/4TIa0q1PlG7n56x6p0vwlzrht96mBPN5DsAXVDY?=
 =?us-ascii?Q?FD5sb58+JOVS9FrGPAaZO66POhu16DPAbn0deEytxAZvpCSEVouJb2ENapBo?=
 =?us-ascii?Q?a7ELoDKnWjErj5bvtNs/cwDqEx1ZS7pBzK64YY0A2xKU0xvR5GdlIaVWH+uU?=
 =?us-ascii?Q?6/ioAvBb0+wLa/zijUB1qzYvrc7H/8g0+c4bW5HbY0F/dwE2UZxKQH1Qbdts?=
 =?us-ascii?Q?AMnfXEx8Ce3a/wK2QV3BcitNORreFU4T2TVXo6pfM02wz9d/ePE/bL/vS4a5?=
 =?us-ascii?Q?lD68iSmN3zYbHJMMKUyDajlup0R1yEF7QlPUCxEu5RqmvRDbUmQNtMTWBqqy?=
 =?us-ascii?Q?BiR2+j2dll58+4jpn73zU3mG0n54wjQISiGouNjEy3QMrohVi27WS7WTPEb3?=
 =?us-ascii?Q?L3/kOrd5QhhXgvAQmYf9+fgyh2k8a/gBmtGoPTO1OtmhwWNng5hCWW+rpBCN?=
 =?us-ascii?Q?xXfuA93aazvtmpq11R/d1X9caPTjwN6X6g+Vy3q2Zz6MQuY+LV6U6sV4z4lt?=
 =?us-ascii?Q?rtUxtRqkLw4V79E4noAUP++m7t70TJLMBvrk5Fn+ErDAXsyrQWeFZl3a+73U?=
 =?us-ascii?Q?AG55XnedOFkaPS/T9aBG+vbG1dHalw3xuDlXS2+HEbRRhA8QjMuvC19nEbHf?=
 =?us-ascii?Q?QQ6HdW3bnxf1jmjLpuxC4SVC6H6i4jh5py2e6aVFkkAf17tx84HrBRgtBW9z?=
 =?us-ascii?Q?hCjtxQFsrgf/BdCGJZatJh4nUt9NXJxPDstLTqnpQz3KlQ/B2/vQBexilghS?=
 =?us-ascii?Q?//FOWX9eqS3/ET+oBAnniPXG+v+lED98PwrtiyIFsaHLSwPlLtqMu2ckhxOz?=
 =?us-ascii?Q?2GlIWOjptVYMfnPJIZxyV36fPBqOUz05+3075ODpOf1iaDEc1CnZHh+lZOZR?=
 =?us-ascii?Q?nSfQcO+I2Eta+EQ10LWXeCuaY6zd8O9Q4uV+aP7SR/9H0mAVGKwP3sBreKk3?=
 =?us-ascii?Q?oMeEsLUxnw1o/2JD1xiepTNdwSQcYx90cb+xU/DFMa0ypuMt95Ky22+5vsFu?=
 =?us-ascii?Q?B6XsScux2co/fP6dJik8noLP0K/D64owhxBvNx3cJOHsQqbLOhrEYPV5d3Vi?=
 =?us-ascii?Q?dSQDVtULvlUesGwwwKNFpSMlDiOjvEy++1zcsY6gHdarEeEJte5eRP3s482/?=
 =?us-ascii?Q?avyx0HKo6Qr5g8b21+M1nm4BMRYdxSdmV7JFIT84+lW7ENOaM5pdGJZEkulq?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hJdRzMjidaoK46g2IPGvxUffqyRBrGPgjo0vf4hxutHjyEcSJXoicno852vP32/InPHCdTvkR1NU1JplL5VAMrUKel16GeiH3u23XaN9i/si9I1cWUeEIyIfTfAPTvTUGLMZi7zRTpOL/q5fajEubjdIIPqUCrQxaXgnfxKYnDfrlBYeApnnG35R95cL9OO52oqVPL/Y4PIk3qkMEgTKUwWBeWzgiKdCD9FK3+3z43OGuAMWIYtPyDX0sOsyAjPUjOapeSFjkyk217URwhe+v8ndJwE6AnmF0SJJhaMmH+1Z4ezCANf0uvWt0Chh76swn8oBPR3rxSdK+XF8pHAwos8NjixPIr42HyKBWi5I/+EST8px/KOblrxOjhtBm9v7ltCrMy94pBbhmIKBkuW1dkG003gn2oYqalalDkAvxt2BU/YPUf+shtidOITAck7nT0ePoqjc/b5CsDJ5P2lSc7zACkc9+2EhnpFsFGcXgTwWgt0D3bVz56UmeFb16jyH9DrbokzdyYf5IXQUSO310y9sDhkrYUINmMdGw455wMrAv8Edw59rre2/x6e8g9IyxddDq3GIcx6NO7u82LWAOO+/4jzKuFbDHr31QwJzU24=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e488d1-7ebc-4cef-def8-08ddf5dbb232
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 11:16:49.3430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQPM2JcBavQp9WvQ42iWhBtj5ThBxycFS1WkCobLI3Xk1oWLlU3QVPwM1y/4ELw1QEHfViu2ZGTQsHSXdqphBiNbVKJCo5pvPBpFOKXhPbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170109
X-Authority-Analysis: v=2.4 cv=JNU7s9Kb c=1 sm=1 tr=0 ts=68ca98a5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=6jIfH552mySo-QesqxkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-ORIG-GUID: wuN9E5BZMklQO8AYxyUMUI4ZSTRulcVS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX3SByUJabOiyM
 dyRQh7pgm3MzVfsmZAshq2/n227mGej2jXMUGSu2218izwalYnSBfSW0gzx9oLwdXqwwT+X3BJH
 kVC06kUfPhhVLDmBRqRKokvILIS/LT0iK85Y+UjpjCeudFBcjTWYOCA+P7jkwe1iiA+RT884uje
 Zsef5QWFykJnAoKWWfAFw6tBLBHygq8ci9FJXW+/yp8TofjSj6Gxgl8kaclmVO0l0YiuhZkiuaV
 gFLsUzHBoh1zS+jczwVIsQOgQBdV7gHbONU0SuKAN4fUZGyy1s0t+cu+Tsm/NSNG4dqO7SV5pJz
 IoOij43sGB5dl/TukShVh5UAL/th94du7TfzQml0LFPDGWoB8o/EBISGR9ld5FZ7pJ3540qmFo+
 JS728LDtGBiCDS2WnE2HgS8bnFznTA==
X-Proofpoint-GUID: wuN9E5BZMklQO8AYxyUMUI4ZSTRulcVS
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D118080009
X-Stat-Signature: 557fkka1948j3b455miqdebw15ii1m1q
X-HE-Tag: 1758107831-496166
X-HE-Meta: U2FsdGVkX18CiHSTreWGktk+KG4H2P9Ko8HKY3m+9Nm454fqybntUnDvjtOYno+KEUbJs4JC8Xq/RGxysuP07QbtoYI4xTmLPaJ9mPesjdKiOommXC+jwODbsyobb1D6XOU45gPFRjducAnhv5lCKAML1LQLN5ccAsM/leFA63cIVlvXKog+n5HxGlOpXj2OOXghQ92hxLNX2zPaNEB2UyUVKjqo+rFOyXd9S2b4khbA36okNedxbkKj5II9Si9lJ3P9GYVjqm0Cff6UvH4fatCrVDT6gPZGetzFSxjERl9ht1EnKOc08EFmsirEuVjrVbjvoPT9pwim4Bj5C6i35TMdl4MCyg9HjOsuZqCdiiYm8TDBIiTf61LduOndew8DwZta6WZZLYvztxZ1xq1Sd+5XQyrZoaRxD1vxqcBhGBpSV4+xviqfDsS5D3F5wlJ3oQsMZ9MnvuZLfRbNb3tBHrv2g2KsTrzKHRxwmE9PnynhyXx2wjDhiUbpKYEbLgZ7AeUrsYorWNwYSkt1UhI+W8U65VVAQ6u1MGH4SpqrewGC8+ggZNKAU9rjqjEUyDmL8XZXcQ3dGkhMkWOuWamjC/Z0BwrLwv3fU7+Q3a9xwN6ox3Pkgf9JQHYcHFvChDZFeFBn2R7nkgo/q9lxkGqZk6Uj6fRiTzmWWgN6x1IS010aanL0S0XKYG6k8UnjMOUv5HEkTlJPVacnGa0hdLAsneztvufS2BXZlk4ZgRP+66S6P20lCIDrkAqrvfnjN69lvVHCxeoPkEo3WnDR4Q84gfDrNzFgmYF1+38XB/qgVQOeFFMG4iPRxtCTWCUhSc3ZYMuipqTT27a3nlY5FzUy6jnu3dZRFYsfese74a5nvNGfSamiLVtEO1IagArYYZb23QvJucyYFmh3WAYCKWJcwHynjANLaS0h5w5qfHtPOaablwdTEV/CuRUH3aOpoVAzSU3xJVUAhPntrqV8u+M
 Mu0UxsP6
 OinX/m41L8ajNriferTtcnvaMf2R4bc+LzeXhBlKvJYdOkcSl/pvIzii2kU2UDVAfQ5wwE86uVsCM+LZMN4TwdulfTk0y7I11ccOWuz/w6kFnm3+N+++tXOL6jidW+9pSGVlCxRoUAbKnyCgw127zJNBIVV7peir91R++Rfla2N23491mFnbApwd5tLnY5GkW2kdPOJAkFQHsYQPH0FtY6SUhIHiJSs/D9iqmC76Xwe9c+vWRmvkBdYloXEP5MoNBPcqyXDnn+2W0X72oYY7PYqUGWqtrDA46AKe5D1FtMP2ImAhOLN3bGFBRg+ZHOloGb3uRrvuvjUJaqv09xxC7pQdcFcPl74Twoc0dkbYzcBg1as/iHKeZJUuwroUrWRIsEz9GrsHNb9dn1JDauIsz+5f6OtWQlZnskixUfGs5VgV3wrjrARq6tp0SItFSnItY5vWtCDMG2UtzESsefJz10fpniVk47HRTiGNrPS3Y7JA2PRMt0kgjgPZaFfTwAx9nb//J+l1KDPrOzjdN0fVXrMCO7oRc5gGxeyBN03BzsXvbzWdhBy2D5hnhVWUxpfnMJgUQGhY93UxdJ49Y89xTGKhe/ZqB9axBqGMSPStNy09a3V15elM3kkS3Je+N+VQMggLPa+v1gM7L9tN5tSh8f/g/JeQnUSH9Esf3MJafE//k1bZCTJWZ0o/3ID42yz0JdpEKF1+vOqslY4jTYzAgWq9vn7kEFGWC3BgAJsXaqsCQGQUWyTuW6nCfGaypYC5z2D8jplCMy7/N46Mo7HyhtkSexdL4jC2uaaU5aBtXmIcMdBGxUrvm9a6X8aDpOoezizCV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:07:52PM +0100, Pedro Falcato wrote:
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
>                 remap_pfn_range
>
> >
> > remap_pfn_range_prepare() will set the cow vma->vm_pgoff if necessary, so
> > it must be supplied with a correct PFN to do so.  If the caller must hold
> > locks to be able to do this, those locks should be held across the
> > operation, and mmap_abort() should be provided to revoke the lock should
> > an error arise.
> >
> > While we're here, also clean up the duplicated #ifdef
> > __HAVE_PFNMAP_TRACKING check and put into a single #ifdef/#else block.
> >
> > We would prefer to define these functions in mm/internal.h, however we
> > will do the same for io_remap*() and these have arch defines that require
> > access to the remap functions.
> >
>
> I'm confused. What's stopping us from declaring these new functions in
> internal.h? It's supposed to be used by core mm only anyway?

See reply to io_remap_pfn_range_*() patch :)

>
>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> The changes themselves look OK to me, but I'm not super familiar with these
> bits anyway.
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Thanks! :)

>
> --
> Pedro

Cheers, Lorenzo

