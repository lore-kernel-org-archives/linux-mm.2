Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F0BCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96A908E0008; Tue,  9 Sep 2025 05:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941C88E0001; Tue,  9 Sep 2025 05:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809EA8E0008; Tue,  9 Sep 2025 05:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6927E8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:51:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09E8013ABF3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:51:31 +0000 (UTC)
X-FDA: 83869244382.23.73EC423
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72486180009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:51:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k0f9OAJl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d7S4rcwf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24Z032ooGYOsi7eMvYwu24bUAIDde4RNvK0LajM3KCI=;
	b=nC4nAErhgvaiwSWJfxeqvW6f/U0d1dN7zMGD06ztNRQ4Sqp8cXVatMf0E0268EQYw+GFrt
	lxgM/Q1KjttcXQdOC9Grvzd5l4yn81NN+b4z4TF9V2cIpdj1/ngIKpxz9hLxKMEaeWcqpn
	k/x5c5t7v2pQMsjm2NzIxnPoyRUHpdk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757411487; a=rsa-sha256;
	cv=pass;
	b=UJRk0NmqUS1i3CKnBkR3KsgZLo/hhgB6+fDmTqXMtY/MUOHnnKazRKp34PLOJJgcHCq5u6
	EalXQ4UBBaNFfUO/0digJV1ZW4aC2WN56MRmwgWj7bDb/WAPLpHxdpuIqchsm58XTwWp93
	B05S1BDtd9RcWs/uY+l3Isx2mLaQqq8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k0f9OAJl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d7S4rcwf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897gT55022716;
	Tue, 9 Sep 2025 09:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=24Z032ooGYOsi7eMvY
	wu24bUAIDde4RNvK0LajM3KCI=; b=k0f9OAJlxwZEkGSmTskSI25PmVgFx2A0Br
	uuYJHFyEk/swIKRASSANKYrK3zCft+HBucvTiRflVy4MQs1YaXcqloMWGAReDO8H
	ClE26cA/H9npzHIGEZQQpfLvvS3W4Ozx6x7BU+p9OFT0xF054dccTxO360/N95P4
	VIn68xwcZyISzoYojhQTa7GoqAuz2PL3cgXbQxQ5HcwdPmxDYYpmBWlJDnng6krB
	HXRAxR++YKTsley/eoflv/8EtKRtvfX7cLM9KYiHwIdjWpcuvKBtWSf3g0WV+T1D
	qVmebZbqTjDESYf+9QWQ1tHtOgSAZQCyEqmNKj/kclsfJjUDv2Aw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922961h97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:51:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5898ZBhH026049;
	Tue, 9 Sep 2025 09:51:07 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012029.outbound.protection.outlook.com [52.101.48.29])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9cxen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:51:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DmCNSuD4M+fdRnDHosXTY+zmypLnXTnj50Sl0TgB5YF/CxTqFgjnChYlB7BJTlh/HP4hEBtbWqBK0MprCZzjsfZsn5ghrWlUO8nXCebJek7SOO6tzT5HrPFwz3iE1I2aaLKzYh8aQ7hBW7ALHuwemPm7G3EnlDlYklQFT5VpEihlwIX5EylCsikyXwIAsbXKDzUMHozZZBVAlfkvk9B2RSXQVYlHKxxhefgF9JfjDulv3Gtc3DdNHTwkIXoSyoZ3nNod5nd2kwt8tEJEA/gly+7RVU2dWziMYyUif6y46tW7nbyYJ7mz0mFdHfD36ERN6+/2FTOTE8PgzTp4BgrS4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24Z032ooGYOsi7eMvYwu24bUAIDde4RNvK0LajM3KCI=;
 b=oJ8Xp7MPylkbN2FOnnQ2ifprEo+LhxpDFBEheGBSx9L/vbZpFhi0U5spo4L8r6gB0oR7RIKWkUE4Aca/Y9I4FZyeTuCsRBBG+XzLKU9/5GYKRPjN0T6gERGlpqWB0yJqUk7dITS+UYiaUMoJz1IL4eaQlcpYF10Qg9khAsGy+IHsnqIen0NBRHk64UvEzG1WlGVma/UjX5YhHn5UqnorFXtXR7wV1MxthYQcr3guelHN7Q+7Yz3mC0mytnO7wiaki5384u1DOQhzk2elcgV1PA1baLhwDOnZAibGJ+K7CxaHttV34yS21WWu8fK2pdyPf3P2Xn5AgXrfMsZ1Dopf6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24Z032ooGYOsi7eMvYwu24bUAIDde4RNvK0LajM3KCI=;
 b=d7S4rcwf6zaIDrW2xuSCbF+yV/GPuRGjgCvh7NhP4sxkZ7Dbbl03Hj3cr/Q87zOBTc9WJeCs1YmyqQIAs9Usixr90E0Clg56PVMBr6sWOc7EaeomFASiNXFJ3XG+npHvZf6yDEPrYPHDDIrVgrF+Dq8kuO4imhEXir66pIBAISg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4122.namprd10.prod.outlook.com (2603:10b6:5:221::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 09:51:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 09:51:03 +0000
Date: Tue, 9 Sep 2025 10:51:00 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
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
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>
Subject: Re: [PATCH 13/16] mm: update cramfs to use mmap_prepare,
 mmap_complete
Message-ID: <23e74133-7be3-4f89-8877-d241c90417ff@lucifer.local>
References: <e2fb74b295b60bcb591aba5cc521cbe1b7901cd3.1757329751.git.lorenzo.stoakes@oracle.com>
 <202509091758.mKPE6Hs0-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509091758.mKPE6Hs0-lkp@intel.com>
X-ClientProxiedBy: AS4P189CA0025.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f283c8f-e852-4181-c738-08ddef866394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zdXJCK21Lgs/akk7zZSYa9/sE3Izeo0bLCPD0YLKKiIlypyTaSZL3eRwv2A0?=
 =?us-ascii?Q?ITOyNwhTV3qayfeVVM3D+djYPgn7cxkh4BwH9+T+mW/GgH9IrE8xr2OWVtKN?=
 =?us-ascii?Q?UPuULJv6Ne7oNAMC9cI1Tn0KAkPdZ+K325eAjT8asn3XDt1WMsqMcNoEjx02?=
 =?us-ascii?Q?zsdbH1Imfn1D9NYNJihKRCxUpKOBkv7mr9g/4j1Bgk4Bsoal5OpMrtTkLAnJ?=
 =?us-ascii?Q?teKnXjv9tnjeyXBK0cUlF1fpEcny3HXB5W1bIOnTED+zTsR3sSPtMLNtEdGb?=
 =?us-ascii?Q?OvnCElMVh3dEUEbPJz/VCEMBLXH5MMWGaT9cuoNUTFOnd6kt7c90YgrIJ15W?=
 =?us-ascii?Q?HrHqSiujm8OS+ttmgISwUei+3ao4n3JFJSolvMLAkOIr49TIncSMgjMO6OFi?=
 =?us-ascii?Q?aqopN0ktd1MAXh+B2I8Kqm0MtBXUhD/HnYuyI0dM8W2Udcb4PVKJQeLNlVwf?=
 =?us-ascii?Q?x8chT41elMvYLBIbKMUGcI7KhbsKw4PAsL9kdkjHdS7PZntwpf+tSoStzPAI?=
 =?us-ascii?Q?PruVkbsHjA5ijSvnzd+ojkHPreTQRgzrjqMB3XKD1ZNMlT+azXKa+oXtqpcb?=
 =?us-ascii?Q?XTGIsNfN3KxB2vsgpkgia0Fk63lealdho6fJ5sSysGOINcdPtzSoJizlyDo3?=
 =?us-ascii?Q?cxLVibnrXOFjsaeTj0KRfbp9tmp/lh20ZYutkt0J5vF05a9b1Eu+BqdoTBbG?=
 =?us-ascii?Q?egjDXmzI4BF8n5mh8i0OaKN12xDqnn8cmWmSFPDxw2FTlWzEoRlyfxFgjYVK?=
 =?us-ascii?Q?4TGQAcEBI2mtl8E23X8GyYSl97I2OdNkVSxoomIph6PukOBSwxJVUZR+kO3f?=
 =?us-ascii?Q?3kTpnwrRYMQuoPj8KmGVllR0XAi3Sl2t6G154ZI+h34rp0G53P4XzLVVBVDR?=
 =?us-ascii?Q?lNTmH79ymfHbQe4O6SbOniR2dtJLJTfvqq5+tkOl+RMrACEnwY8KS0vQCNU+?=
 =?us-ascii?Q?1DGfG0mqK+WAc3hZsQLbDqCKYIuSeDHdjvnuXW86T6vsQnOugongbS9xnBUH?=
 =?us-ascii?Q?CfZySFFTGTuH18/9pa8DIBct4hbTrezVE95aI+b/IS3VvI9EmtdMIPihy1lG?=
 =?us-ascii?Q?XK7lMlPNZim+WvSxPzFYHcm5PrHvOMP4mkraFzu0OKugZkR1nzkDBIOm2Ib4?=
 =?us-ascii?Q?2/fBapQVR837h8nxh+qmB4yTzyQMtu8AINGZRJDU0dm+zpI8QL6P4SPXxYXo?=
 =?us-ascii?Q?Qt56etRtuGmZ8BHvN+7RKP5HdKH2ybtjOQHDU8P9183iEkmaAH9C5Hd/3CQJ?=
 =?us-ascii?Q?4fNYFc+bzZBWRE0kT2FrpejkoDTEjWQTw7ApGGxxRC0ukWR1CeuvoNvSyS8q?=
 =?us-ascii?Q?soqLM4vacfdDDoQ9XDgP50iv6gLOnl0Ii1mGDEUgMSq1I+NBdLZb3mMBvH/n?=
 =?us-ascii?Q?iFXfmObhkqs1G7e7Hu+Lwo9raHK5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y+3ZmSO4uqkth1jOXyMKXtKwGzCqMA12JCuDYYrmIC74D6IzC0dyWdjzL+KL?=
 =?us-ascii?Q?h1BPkChktmbiOWyhqkIgSHjV9GJTbJ3XceaNwJTUekZk5wJyLmfZgjRsEtM/?=
 =?us-ascii?Q?Kh+sXbK6rqi/c1ws8fM0TYbaSW3UyZELvVzO/URmzibusGTmyONVWfJAKdy7?=
 =?us-ascii?Q?vIJvtAY5eI3Idp5D55Y3LUx6dzW1VtnIq1voDpopgIWJehyjyW0TSa4Cpdkd?=
 =?us-ascii?Q?ps4VXD8Sa1KteLR5FeYDad3GtYlv6uytiicx0SnyVwWATn0irCIPmzlUDdJg?=
 =?us-ascii?Q?drVPhdDmVga/5kehzisQ+d250m5lNFmV7PEecl7WayGe9tiM7TDXp27HgNk5?=
 =?us-ascii?Q?9t2Atv3TB87/t10mN5d6uBfIkDZ0ymFrl5+5mSwWjF2C1HgQZWpheXswXyQv?=
 =?us-ascii?Q?eSjyiqflvT0LKql6j+kcepZRLB/VZmz+YebGvn5eZc435JXGhrOMO/I6YJ1b?=
 =?us-ascii?Q?/Nw1QMy+mWGcy7uaPq3fgT9NusOcXusDpT+BREWF6RG1QCkrOfq14I9MZwUA?=
 =?us-ascii?Q?NwiVxUT24RL60pGMBDA8i3gIgdwtBa4b5NSelnPR368tX7jMgvdNFao9vKYV?=
 =?us-ascii?Q?hwAAgXJncoxfVbXhZT2bJG3SDyXdYHCFDAQ0ph/pgJwN/26KjlMrkgeccKJX?=
 =?us-ascii?Q?5y7ZNBRk1F1RjE0B8JQ+E78r9t9g3Pgx2efORfAotymIx/br8qMMi1FotLO2?=
 =?us-ascii?Q?SZEYj2gUfSnKBudNKEPMr0XtZTRCDB13xJv2mqUlNlRQ/SyMO4MjQRHXhHPi?=
 =?us-ascii?Q?f5eKKobemFQnhydfv/JYf2VbgmpzHXum39R8gIZfBbO87xswlTYbYAXvlmDc?=
 =?us-ascii?Q?s63Ga9t9S88JwMBgfhyRGPzCuSwb5mKrvivgWVt4mO0HvbjNlNFSgUe6iX7r?=
 =?us-ascii?Q?qNwJ6gVZrSW1d3Vg3vbKr7eW55OSGDDbPQaCn1D5VTFMW8wH3SXGWFkl8gZA?=
 =?us-ascii?Q?Te0i6w/L7LoCJ5cmEhDx/Zgnz2IVcDoG//89nl3heoc7utgAhuWhG3pPtz/u?=
 =?us-ascii?Q?Ksv4aus5rR+XZ3Qo7Zvcq/8BrcOfdkkYhJWAekz0ZGI0uvUBaR6cdyefjuOJ?=
 =?us-ascii?Q?icVVazpNT4T3BXxOZG5LTpXyvPo4DNBI+Ub+nhX9qLG2VNJSXmQLTRiFf4Tc?=
 =?us-ascii?Q?4y+lYgc+y9lgwe2zrbMlR/Bpn9B/2W+bkg4dkmFCTuc05uq1onbXacr7Uheg?=
 =?us-ascii?Q?HHurPlro7oVQJECBB1Fg0vbp/Bu65L3aOAW8Nq5XephrzB/aSmMRbbsRpBQw?=
 =?us-ascii?Q?gGtztZLbQNe8bnhZSfD+191hGq6uan7J23wEkf8jUB9Af0ss+gz+bh1wKb3R?=
 =?us-ascii?Q?rTRmJ1k1zyKvZQTkYaBkaP6WAqz4HHKIMRlGFn5qob5yvEuTSDjA97vAHjuP?=
 =?us-ascii?Q?zGcQjsywc6gUORc/U7J8q8QzLk4r1pOX43NSNv7NuhMQXS5QXpoiNtXWQV9L?=
 =?us-ascii?Q?2ReY36jYr02wihn8LBRBIWciD0/asNGnocpfVZ89UBlkwaXyZp7Wp1YOw6M2?=
 =?us-ascii?Q?Oy3/zdpnYbCCkFZs4v7zhqrEDRePPk3/rudMoQ1h7ivYUewm9zx2zysS2utS?=
 =?us-ascii?Q?kXhXbiRfrgNY5npj4JvvNqRfQvxnuxozFDH+p+lq3OUjv7OxKVjGr2eAlHAd?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZjMvJidlqGhLyRK8uZsGLiZartf4rMp+fRKY+EywxbWu/f8aVBgx8ouDvNNlCS+4pUqEXXJrslQGHB3C+nnGFNXawFP1FKXI3PHsZ27GW7PfkaHvKbCfqKbRXLL4OTXKIw9RABGDIasaWCFoobbDT/s66Cy9nJE0BI2kBWnFcjeMVQCufJrQnsa3J4bW/eBH7Nqt0Zc5Fl9im0EijXtkr/7Hkve6qU9lhBXHTUCzwFnsgKnfmfUP4T84gEmNAUS4SB4fn/eR8F7j12q85Yikg4zqFwyeeysBlaqf7JYlkwC9wgOgyJzSVHA4rkjx32+BjMbKqo4lIPzapFw1tCfpwPxJG2JGAhFayIF4RMMWKwlabgozguPLcxexKnVCwsQu3SCyxYzR8ZHpw3YJsCdHjoGnsXW0O4irl5IxpSJRq8SMFbqeChQc62smIf4TzJQ/koGff6v96DRzPS9F4VfBS4JZWEFpxF2/t1xXa5RQUtVW+ve86Ek0mlZ/LUA/ZevN6dJJ2pPjFWZzSTtpbdAC32BAJSYGvvB1NWHvihAWYWTd8iRFNE/KmCVOfA9E1Z2f8W4/r3LLV3cIhD/IaCizpe4nAtveBabubPbxurahm5E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f283c8f-e852-4181-c738-08ddef866394
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 09:51:03.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INX+RCJ/H0q9lmznpOHJEp9IR5cdFi756c/BqOfpo2A492uYkb4NBfQdGkWA3YR+BzCtgUiU6e9ayr7JJE61wSMc+nDNpZH9Mo+P5xjXqaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4122
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090096
X-Proofpoint-GUID: _wYsKODB-5Y6xGL_N-Ej2-lp8DenTO5V
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68bff88c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8
 a=CwSCrH6ST36NPg1m9FMA:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf
 awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfXxMzgado1UzNS
 wthQhZySh+VZRqv0t7hTn1lJygylpxMqIJJX+pRf6vbzsJm5GtIaH3p78QZOZwJPIipgXGbp6Iy
 1k1h4N/ik9JSuaTaTIc00+2NS80N6OKaK9jadIjlli2v2opw4myeffOjKB4PkseHhOCfqApiNAv
 ES4O8TsBstCdSw+41tlPaCokK4cr0Dha8YPStv3Vpv490HuUqCPdZCybYsHiPycFmGta0y+plDp
 3bApVz5OvgmHHJc8YzLL9ftMTBPwSmfUT94C5oJEg7FiatbKMTYKJ5fX0RfCZVltfQvZNtrui7y
 E4LL5dXmkMpYeYr05ZWe+P460ClcpU+lGS60uoSYzh1HsbFM3eifywrk2a29pvwl7R5pEMx8pe/
 ufR1zGhpx2ebP46TSbtoAYo7g2PFvg==
X-Proofpoint-ORIG-GUID: _wYsKODB-5Y6xGL_N-Ej2-lp8DenTO5V
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72486180009
X-Stat-Signature: uqxhxqfdxz8wo4fxg5asrdjrf3q8xyb4
X-Rspam-User: 
X-HE-Tag: 1757411487-770517
X-HE-Meta: U2FsdGVkX1+2M8emlH8M57LGCmCMKBFZ2OdhyZwfwLWSRxPLEKhIfz4a1WUzvTjlnvVTEWgb8oGrO0uu67i5cBDsP0gtEPtZC+fuBySPwlajDQJoNvFebUeKkXpDlpaIk+BFqwS+dk9UXAt90PzdiRuG0RtEu3+riqwOG+Z+p5oNpJqzcTMCha0oae1fdYhsUPuyqwjXS/99Nqh+V55Pvy28X2RTJ1fVi5A37wb+UrtC6fXbpFu5lB932y/5sqZV04y06nXkxXoEnXvqYE6mQkIdLCnnUIkYaFIQl/NwikpApMy/VF2qo+k2CbW8F9FwJ8LOTNtN3PZDjFdGEc0Ih+OZjRWrkJKwxKna/ipdNWL+dMEt2lnhJIMfWrH98kqFcxe0Lgy9/Q3aaxOOmz5J1r1s2xG3U6xajYAap9/ToOX2zWL/mqLUCdsDwmpmJ4+R8uS8BSFabvVXEFf8icjMXnSxd2DHQKSusbe9KQBdaLaM90t/zNBkeQdUBNuBfO0g1zvBiO2AHSk68DhufsJ+i4ejc7nNchs1vIDxSTuPlZQGXyUfSVjQhMVXEJyIyL+qUV7R1H/TYrBpyONmljauy2CWxlzmWkCl02kfYswdVu/ew4LwYD1a+0+dMpWEcr46j9ruFznhPRS9KIXa1aNR+WtlUm9TaUopjDMjVzfH89wpZtBOqDOAg/nXMVPxr8tmzlOpgAsx9XC4BDk04pY8eCMYaKzLU+3+u7tcb0+6l0pkGBla2WvQ8ddJFOVl8pyYAI3vM8bwDwGgy4M+r8ofuoQRXHTSDFKGBXPA4lNRtABCOCz62PJJQTXA3r21XnuWqXea1iWmQbocNLPEZWgO2bwZ+AeE6mhlL8oWGuDIjOBgE8Tj5RFkgK7/RtyzRTI58P5PnCCKRubn5cZ0aBTdb6Vm4GAApOcFyaFf082YMW+oPBD2nBaU6S59aCJmHL0amghfUTRs0V5T+156fiS
 lQgzCc0l
 O9Jj6St7MYwF1R6L4zgtdFA71tW7AZYdPCWHbjk6eB8JPtxMtOlzI3Dln/2n8xgTbUtsCGwY9S5lYZ8LzQVBUmvCFMYRmacywZ8o/6lPC65oBQsXk6ecHWnrlIvzRqrrK14h2KXSV17lzNb7Bbq7oXQ9nEjLrgLRA/POIwl0/gAgCX8fcZKbSTcMbJ4eGWg4QTfDRdtj8Ej3UdvdsAMq2waj2NQ6HZWuJvXIx9/KijfVp6c3+hamC/bs4/mT+bXv0M5Un4VfhxVHWNRFW1yJcFk1oF6WLrnhcAuvwTgsOR20ttyWuA5YBNEgDxS9ppdTA8A7syJacjvpyhmq+yENipBOfzuNYrXsCtFWjXpmlEEeqvnEC1L0vujBtbnwqQopg1wpnV+7huqg35MPWI67NmWn5S3CIcwHJWpOm5/EA0+ljE3ppB82s0bVBwdQibw/9KAUl6SLDXd1BVkfLNhjfIHe1KiCWfvuhShPejHpVSsf9IBQpsmI1Xkv/4ciX2WSTHsUlX11zYEhrdJGmxGs5XFX9PNkYIevOBrMzrY6SX3b091ZdZn29cTFhYU54zVGEGSMFyq/BGutvah1kxzjqZshWpbSM67doZ/iELZrPGWKJQJH8LGkpMFxAPHzKRiLSeW4+C6eI4S1agnUJ0GaIqhYFBCfTy1eWIO2MPcPPyK6T7H6WpjasFf1j7u9yrdSTk/0Yoej3HNzT5Jt1u79g82WDBwKw3MGILxhHV880mjAsJGUfjR3sbssF+bQ1U5JaDMcxU8vx7QMDZQJJIt1z1J0L0/AIMDwhCeQWPQrhsqy2i+YfIJHfLN1XJojd4+XBTji1eihqnwrHGvGAAVChUgr8ucfipCajnrmFp1kS70m8JodHMHEysQavPZIY0w1AjDBxVquZbCNPhe9WXNyROspoYq+Qrgv9DBX7EbGJGPIoEFgOE17mV6uTuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 05:41:44PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
> [cannot apply to brauner-vfs/vfs.all char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus s390/features lwn/docs-next linus/master v6.17-rc5 next-20250909]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-shmem-update-shmem-to-use-mmap_prepare/20250908-191516
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/e2fb74b295b60bcb591aba5cc521cbe1b7901cd3.1757329751.git.lorenzo.stoakes%40oracle.com
> patch subject: [PATCH 13/16] mm: update cramfs to use mmap_prepare, mmap_complete
> config: arm64-randconfig-001-20250909 (https://download.01.org/0day-ci/archive/20250909/202509091758.mKPE6Hs0-lkp@intel.com/config)
> compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509091758.mKPE6Hs0-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509091758.mKPE6Hs0-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from fs/cramfs/inode.c:19:
>    In file included from include/linux/pagemap.h:8:
>    In file included from include/linux/mm.h:1096:
>    include/linux/huge_mm.h:591:16: warning: unused variable 'folio' [-Wunused-variable]
>            struct folio *folio = page_folio(page);
>                          ^
>    include/linux/huge_mm.h:598:16: warning: unused variable 'folio' [-Wunused-variable]
>            struct folio *folio = page_folio(page);
>                          ^

(unrelated to series)

> >> fs/cramfs/inode.c:358:38: warning: cast to smaller integer type 'enum cramfs_mmap_state' from 'const void *' [-Wvoid-pointer-to-enum-cast]
>            enum cramfs_mmap_state mmap_state = (enum cramfs_mmap_state)context;
>                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ack yeah, I'm going to try to refactor this without passing this around. If not
then I will do the appropriate cast dance.

Thanks, Lorenzo

>    3 warnings generated.
>
>
> vim +358 fs/cramfs/inode.c
>
>    350
>    351	static int cramfs_physmem_mmap_complete(struct file *file, struct vm_area_struct *vma,
>    352						const void *context)
>    353	{
>    354		struct inode *inode = file_inode(file);
>    355		struct cramfs_sb_info *sbi = CRAMFS_SB(inode->i_sb);
>    356		unsigned long address, pgoff = vma->vm_pgoff;
>    357		unsigned int pages, offset;
>  > 358		enum cramfs_mmap_state mmap_state = (enum cramfs_mmap_state)context;
>    359		int ret = 0;
>    360
>    361		if (mmap_state == NO_PREPOPULATE)
>    362			return 0;
>    363
>    364		offset = cramfs_get_block_range(inode, pgoff, &pages);
>    365		address = sbi->linear_phys_addr + offset;
>    366
>    367		/*
>    368		 * Now try to pre-populate ptes for this vma with a direct
>    369		 * mapping avoiding memory allocation when possible.
>    370		 */
>    371
>    372		if (mmap_state == PREPOPULATE_PFNMAP) {
>    373			/*
>    374			 * The entire vma is mappable. remap_pfn_range() will
>    375			 * make it distinguishable from a non-direct mapping
>    376			 * in /proc/<pid>/maps by substituting the file offset
>    377			 * with the actual physical address.
>    378			 */
>    379			ret = remap_pfn_range_complete(vma, vma->vm_start, address >> PAGE_SHIFT,
>    380					pages * PAGE_SIZE, vma->vm_page_prot);
>    381		} else {
>    382			/*
>    383			 * Let's create a mixed map if we can't map it all.
>    384			 * The normal paging machinery will take care of the
>    385			 * unpopulated ptes via cramfs_read_folio().
>    386			 */
>    387			int i;
>    388
>    389			for (i = 0; i < pages && !ret; i++) {
>    390				vm_fault_t vmf;
>    391				unsigned long off = i * PAGE_SIZE;
>    392
>    393				vmf = vmf_insert_mixed(vma, vma->vm_start + off,
>    394						address + off);
>    395				if (vmf & VM_FAULT_ERROR)
>    396					ret = vm_fault_to_errno(vmf, 0);
>    397			}
>    398		}
>    399
>    400		if (!ret)
>    401			pr_debug("mapped %pD[%lu] at 0x%08lx (%u/%lu pages) "
>    402				 "to vma 0x%08lx, page_prot 0x%llx\n", file,
>    403				 pgoff, address, pages, vma_pages(vma), vma->vm_start,
>    404				 (unsigned long long)pgprot_val(vma->vm_page_prot));
>    405		return ret;
>    406	}
>    407
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

