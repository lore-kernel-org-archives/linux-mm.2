Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6148ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 09:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1D48E0107; Tue, 12 Aug 2025 05:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A728D8E00E5; Tue, 12 Aug 2025 05:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBCC8E0107; Tue, 12 Aug 2025 05:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 743BA8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:00:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2373D1DB6F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:00:08 +0000 (UTC)
X-FDA: 83767508496.04.5557710
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7757BA0011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:00:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E8H0XbxO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ELTQLzsm;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754989204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+q1U7N0ibU0wwCjXC8GymapYTMrl+zBr54xk1yy5bk=;
	b=XQmVlnmJLybTi/uJF+8Zwy7jGMvY3udKzOie31jOMfeT6MumxSQ2tbd2BL1GLcHRExIsqf
	e5ZJ39xOL+dta11vvxyjvi2aksMnd9SOFBWVJJEgtAVsQEIZwoe1WL0MflNCmusPql0OnS
	AX0a6c0LZniWSNTv9n6uE6wVILY+Q8Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754989204; a=rsa-sha256;
	cv=pass;
	b=AI02+OeCRRq3GZIOrk4gmsMJnshKJ+tIpoPXlCXnVDMoOMHF4VpdOMQzqNNj5Kq1r7T2/f
	FkFvnASO/e/2S6lwWiknSQpjm3OhQaNx0FthAoPG0tOiNRBIwVHoQUtxIPlQEYnci4Bhlx
	EW8CQSW/tZ8635xE3N+GdjPCsFYDM2M=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E8H0XbxO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ELTQLzsm;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57C7bfxI007077;
	Tue, 12 Aug 2025 08:59:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8+q1U7N0ibU0wwCjXC
	8GymapYTMrl+zBr54xk1yy5bk=; b=E8H0XbxOe4lmC5cm7WZM7sv1VvzHj4Ypjf
	Dwxp21WUWvC5p3BuEwKbkCswApTyRIMbR9ciiSW7kkrUJq0hky1Gnk0oGXHVtBDt
	OBVDxWXhFBZNa7gp/wwwEYTeB7J0fcoKSht4Qen+5tW/i+XTjaIjHHFp15lgb633
	rI1kUGCjI+OSzN48oKO0xQn2JPUf2JP/pTP9N3mkupdZwxhfhb0KihAdmEpyeFFi
	oV9bKr8mFjuLn3I8SZA7h3HXA4yv3NQEvw8q90r8uU5WfuZFnlsALizDTYp0V2L/
	487skwU2va6LbAeivlHhwOGW5y6HW0j8b4gUowLe8iSzYG+apiew==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4c8mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 08:59:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57C7swpm038582;
	Tue, 12 Aug 2025 08:59:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsg8av9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 08:59:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pu2xkSORJzWYv9V2HKu9+4+PZmBaldhuSWLsNu2SUAgelIre6muxL1UbaXr7bBTJbBiVic0Ca2WvQrCmE2XInIOyfTOjMyaNvu4vNNbORkUwGdNarlBlUhClIbEz+0Ts8AFtTWq4CyoleauBNd/R/JwNdMZEyoPog2G70pv7spHe3GWmF3QTbavDPYtB3HmuPk9Ga3NqjEjLMfE/W6EyZ5AfVavz3x+xcvFXXS9wau3ScanPBE40prVOpofDmYm2arGNSWzRmCcW84S733BF7NalwxIpRxgdJP6VbzuApjYCpIqGDZSTn3UrxfiMvs5DgsUeRlOyJRvAwSXl5CJspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+q1U7N0ibU0wwCjXC8GymapYTMrl+zBr54xk1yy5bk=;
 b=DfrQn3CbD0MDQU67PonMePfxiowNKtOSZafeZnnv0gFT7cQzn2sPMCsjR11F9mnNE+FYloHCuxxXCtn0tygna4Hi6NOoo1Zo4fWJCa/GnIXhDfyc2tZ6zPRCOY9O1cjTb9J8bZr83KAaYlyfcM2DrS7ZO++SKYd6GizHm9ZPOpoSL1F3fA/USEanN+Aqm7uTM7IDUnvgq8ZCUjIV5qozUZg3v0buwPcTCVUmeQbhtX30riA5/mNNSdq2pjohO9R0AvSq+Vd+v/5z+yq0BzQWiIl5eQV2XHHRlLeF0FJY7JZnJ457j3T60ircAwXHKsBg+eSUB8G3rQ5BLrjHYvJ/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+q1U7N0ibU0wwCjXC8GymapYTMrl+zBr54xk1yy5bk=;
 b=ELTQLzsmkNQq2RPLnjy97kpu1aoiLN9GEfbMunKm/kS9I+DNLORESP/RtRZPZnWsdtUEXwvrCaSdc9dWC6kD63xkrxaqbTEJZOHD+tUEZEgCxqzNv0eNjsNEUmqABterpADBMxAEZWB8gPHNfCxsCH1JRQvkzBBZxHBIP1H7pYg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7865.namprd10.prod.outlook.com (2603:10b6:408:1b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 08:59:24 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.021; Tue, 12 Aug 2025
 08:59:17 +0000
Date: Tue, 12 Aug 2025 17:59:02 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Hildenbrand <david@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Thomas Huth <thuth@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kas@kernel.org>,
        Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, Alistair Popple <apopple@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>, linux-arch@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 3/3] x86/mm/64: define
 ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
Message-ID: <aJsCVtgfIVxT6Z93@hyeyoo>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-4-harry.yoo@oracle.com>
 <9b57f325-2dc7-48a4-b2f0-d7daa2192925@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b57f325-2dc7-48a4-b2f0-d7daa2192925@lucifer.local>
X-ClientProxiedBy: SEWP216CA0068.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: 243561d8-5cd3-408e-0033-08ddd97e84a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BAR8chNenu3UefQ+USSEWlOQm2QGOhcKPoyjoRidIc+rETjW3F+8c8McpCMO?=
 =?us-ascii?Q?L+9cRaSXwusfOEfcgHaBqeOOSuARv+5mFAg5/FAPgvhUoXvQzCMlZ5w1xK9d?=
 =?us-ascii?Q?8jEAGyG1kXZxmnkVNF001jzbdALYmrAgrN1Qc7nbxcn1DOUGmR9cX4r90Vtp?=
 =?us-ascii?Q?2JA1QoczTSV/yX89zduPoc0b/OPPsOOzNAktrgMZnyOVirlge55XScCtSGl6?=
 =?us-ascii?Q?kq+7l+22atTSW/cdsHFSWz8y31k+xYVR4c8+8C9v7yrPdlUJWBcdF/bOLuq7?=
 =?us-ascii?Q?2mdvPNurtd4V2Q861AyXqoaPcwC78j0ssHbmF3kbqROrfBNC0smI1LK+62WL?=
 =?us-ascii?Q?ZfrCapTq8WUeIBD6OtgYcPnQ4+9KoCMELxfOrLjR9WsfJby0QZLOaRA6yKk1?=
 =?us-ascii?Q?KFWPhHbUNfScCkLO7nV9JJV2IanO5JKhXhWHdBEgyJN8le4cOvLYU8mEbT85?=
 =?us-ascii?Q?HFY+KrW2TknAT95qt+4DmsGnUAHS4CdfwS5gVmyUjpYSXKvshw0AWpABdip4?=
 =?us-ascii?Q?vNh6vxreDU/5BHeAmMvfeUfrrI5CCHXaiiRMJLHa2+yqnbCWA2OiBIah4qgv?=
 =?us-ascii?Q?ssTjbxIqVPkzKuwDRt5Mp434vbqkWyIU9cjNcnqgtYsYwXB4PhD2IoxiHtj3?=
 =?us-ascii?Q?4IqJBp+RdHs+OKGdfhT0HOvqUdMH11axcWIMzNNBJ73Q0DkFqbQxioEz92or?=
 =?us-ascii?Q?z7reOoIIctMYgcVn9ckKSsk7oqzU59RLPkxUZxZw/PKNDn+NF9kZbSRfm3Ah?=
 =?us-ascii?Q?dF2pXcXm2cpsZQ3lAIyZJfk+C+/797xA9idK7u81nT47z6Zsg9v1vOwxXb3Q?=
 =?us-ascii?Q?voap4PbZhyJDNEgBg18PqeEK3MuuTNkiygu+6qXY8csArfPu9JoVJg3wARmX?=
 =?us-ascii?Q?YMzXvYD4A0dpRK0cQeNfWO5B30OBZvAq4DbvX/G3Yufs2y6apu+RVet5fXi6?=
 =?us-ascii?Q?XxhYHxsmmaRQICP3mWDTxtRPl+NKOYq3w3MOyMLlMjOMJqQ2zExv/UoIx1S5?=
 =?us-ascii?Q?fk67EJ7FGfEdn2l03HJPP92wgTcGWLYQufbercdm3l37+vobNdosULM1FsLI?=
 =?us-ascii?Q?ek/nF1q2iWrsfkZ+mgIJq1Oe9t/f0MhDrq9VeMAcqzPcMPalufHtRjKonprj?=
 =?us-ascii?Q?rZjJx2tVTS7fVyVHI7Wk7UjNKv+WWKmqoskOp3R4e4lYoTBlH72Zqu8E6ZuA?=
 =?us-ascii?Q?2ovo89G/yZkJZWAmnrUxWdmmAcnxAsEUoDQNt3iXeW7yw3OARsHjfFsd63QT?=
 =?us-ascii?Q?y3xTuKlBBI7NPtLl6ZQrQ1Vsvebla3PAR3MFoKZ7i+A/UDm9GT2c6BiZVpQG?=
 =?us-ascii?Q?CANP83T+MBdx4qSOQRzOl364956XpHwTe4t93/A443Y3hTg+qcnCCAExPYGr?=
 =?us-ascii?Q?rmIzTBWZIIcbpHzBa7Spqt8vKC4Y7j9cFsn0aVQVJK6R7c/LXgm4Uc1Yx0Z1?=
 =?us-ascii?Q?7UY+JraI83g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Meik3Jv856oadPQO10CUbtmboRExjOA9UXwAgCQJpkys5b5a0N96KIN/tV64?=
 =?us-ascii?Q?Gy8pdUKZg3HqVOOXpijWT1sV2p+/Q5OYQf2QXS5J5M7vIo3/sTE70wttRuL7?=
 =?us-ascii?Q?UsivJDAo7EJBtlvdq+KML3QT2XyXkB7DRgKy7NurmDak/GF+NORYoGSbownq?=
 =?us-ascii?Q?NCNynSszg4Uq2tXhjo1kzj/1Fq4mxXMnDxfIKdeFj0CTpCQsS7uS/po1zXg7?=
 =?us-ascii?Q?5hrJELXZLLmZnZfmn0xlWywbp8DZXE0KzBkjelci4Nx/nT47gk4x28JKeert?=
 =?us-ascii?Q?qNrQzJFtutAemxU1T7vsdg5Gn5rx68FIg07tGY0LcOySEsdquXdG7CORf9uk?=
 =?us-ascii?Q?3rkitsCr8Rad+gmcM2vjTXcdDJEGBQm6Wx6d7ogwbgwGmPYdWA67PyNzN7xf?=
 =?us-ascii?Q?bg05g53kMg0UVD9Hxm+0ASvk6QVRKRwmuFhnGiXd19HIFq58QW8T6ps31isr?=
 =?us-ascii?Q?QCiuW/2Nl/2VrSLE3e9BVUuB5ZDmzgwu+T9he41esvwGqPZnnF8Pj21HL3KT?=
 =?us-ascii?Q?GHoMW7iJCWbnBahk5SfiJvzfSEMvJnUcARIpiFldEy0MFBiUjoQ6+EjhBZF0?=
 =?us-ascii?Q?aW1WzsYH3DCG08Zrc2T+1Lcu9QTvToibnWy/bHF/zyI2OmehE7IkVC8G6/LC?=
 =?us-ascii?Q?C+UOk2TOngZZFwfh1kibj8sB07IumiGzqgNHmdt6DQyEKoLBjhS1RhOkpMfd?=
 =?us-ascii?Q?ImjdhtZbZrlFHSmq2hZoG3RtSj0DzTwWUxiRTQ7azFpQTf3OrzmhFkncqw7P?=
 =?us-ascii?Q?w33chfBPzVECSXqu1MOLUAHYkGc7ZFbktLfeZ0UD3D+hjDqnMEQl+gKZ9NKb?=
 =?us-ascii?Q?9n/Wrkt24fxf2KDRkVn2W/63yIBiVbzYuaKEOTi8q4hVMN0hNZURJUNAPKhB?=
 =?us-ascii?Q?+lr3Wytejvz+daKlxhwVotPBrC2fr1J7rTQY6cS195ejhR6n4+Ki4kgdnhNn?=
 =?us-ascii?Q?LCK06DQsltdckjkjBUs8yJh3A3G/4ombT9o/Z/oo4tw1b2gB15RA4uCXnRWg?=
 =?us-ascii?Q?SI1nPKZmHHJQXiXV87LBhNOoercpOomiNDgXY6cA4/KhJMxuk3g/J5iAoGJW?=
 =?us-ascii?Q?9xD1aU5QmBRu7dArcye/enR3szdPwTki4hxZRLSvr+e1qNmgKsuoziCVDxXw?=
 =?us-ascii?Q?1lPBx7Q/DGlqZo0BVclAjhFpj59RCVc1HDrwAG52g1OYLJQGkH4LFJ4yKlAa?=
 =?us-ascii?Q?dd26KIf9vpx2ZHW0dXbH5g7KZpvDxNb31TBwa8eIF+dYzkaVqdLOXySy803H?=
 =?us-ascii?Q?lnhz/fa1GfUrdJKQb8GZCXML2+yFsM5haSY7KwwT7C6RHMSs2iUX5g7rzz7j?=
 =?us-ascii?Q?T99CZcgxLDLPrKZWLRrPu8wE0zU/i37aD7uie6JT5gd/GHqCrhEFmkyWplc5?=
 =?us-ascii?Q?tsQ+tEuBtIeIIOuMyNoZTDN9ZURIWkzt+wzNaOKBeIYidsEtsT/W8/Fp3Oc+?=
 =?us-ascii?Q?ZHa24yGOlpJ6T28Kwcx6rPfIG1kGsTluwbu7xMvVMe2Fa5YBV77HNwm+RG42?=
 =?us-ascii?Q?AR7Cv+bdD2fPeuP1eCXXtuPEJssld9opnD4HRyi2j3y1purO1qHE/QDuRlEn?=
 =?us-ascii?Q?R7abaVcgHPiZjuBcT0+WKF1RZQs2kEIgGBAZ6k9G?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nw5YDPLhK4+123JrTSY6t53bGAZZvr+5KhUFBOBg+GkYpVizOxcij+pb/lRzg22PbeBjcPmZqHXsDQNBCxlEXCWPQMP965tD1dqj0eONgHSnomq3jAvcgKhFgNYcvEK5llggtscRhqt66nJAta+57byQAShZdOhyK95NCrEcY8yQdF3jUtMZ2RQEVX7Lzr5SkAkLBNjnuPhDnKr0jP0UrEvZBT0Xk0fw/7BIgoAl3bI8a8QgDXqU3LrCbzKHLl215uC/PkuuI7r1r2ZL0ybRV1AT+U0C7HQdPWyuver/RN+h522EFAzgybq0fsL7eCmcBlbD101smUPqwz+/FYycTLKuK7rAhzyUizjfcNQjloSUIthO6IUtIT3BdSWG8I8KpGNMSxRWUP8vkc55vtM33OegqYFB2cpfenhBSq39HsDihdVcF9fEaNEeA+JmBdZa+O0oo/GSr4Fxn/Z9ksnV9bWK9k8CGEl+T7LCS5QsfNNHPOg8FOhBpx7DkKXKRHxz/i5mrlxr+SO1iEyhXORJyUPLt/VCWuASbF+Cm3di/JKh84EKGGkaUhHQSdbKct+HJnWiEgPWwk84avqf9WHzZEja9TV5uWDjShBJ6yQZ/Fs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243561d8-5cd3-408e-0033-08ddd97e84a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 08:59:17.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM0h7/ZljNRINChvDa4uIqC67/spWbiGQXowmZUEavE4MRNnOKCOf/BxvkXtK7h+SSTWnHeoJ5rmZPKU21A/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7865
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_04,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508120085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDA4MyBTYWx0ZWRfX0UphPbm5fFVO
 UD04mLiWbO+ExMXZV3/b3zcczyQufwDqBEtFweznBir70/F1PZHN0wbTCp2IinYWH7Gnz5xpBQs
 E6UyQy9kK1Ip7K1iUfLN4f6KMv6aVsyArC+xT/+jijL+vWn1urk5CPZJrFQwkMkk5gwZXbRv4ob
 1VcOGhAnfGnQf6ssh51Wixw6xaF8drORNWSJGMOA+98/+iQIgPpD0mT+NRU4piVj9JhSczO3xAg
 M9Y6JK5GxlrUMIDzK9ouA76HnQ5NV9//f0hxx29jhzNQ3BwoMK606Nxz+KQrdLu9x+jMTbzt8Zt
 NneAS0wMlKYlKZP0USvWGeAl8ML2y6pUGjDPUhckVSrvY+MkiN4NMm70CdU65XIPfQnEJ9r/Acv
 ApOhkYxN08ptzoTSp0smwSIWtHXVhwdbwRXc48ffGe/2wNx0DQdsSjz1jflnIl+HnfopzmHy
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689b0271 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=Em3zR9OIEgInuRs0RJ8A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12070
X-Proofpoint-GUID: rYTTiGDbbxOlp_vk2wgYCFQAf6Y49Ckh
X-Proofpoint-ORIG-GUID: rYTTiGDbbxOlp_vk2wgYCFQAf6Y49Ckh
X-Rspamd-Queue-Id: 7757BA0011
X-Stat-Signature: 61rqw68mb3ow47dy4s8rdk9qgjgek137
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754989204-167161
X-HE-Meta: U2FsdGVkX18rJj/GBHeF+rE7DfgLBGsKrD1kbtPCnW+vHtzRNjX7lxfPs6mvnJnsDSlLuuNpgmEIaR66NEGfsLex3OoEnSi30IAi2EL1xMCLo6zpaFb8MzHbpJFEdxgh6YQ/KsTI0IqpXvZ0/6EOACMxEnvQ8Q79US9pQnS6UJRciccRuvoXqoa9A8tbV6v9usCNvPVmF2lakem20oNFjVanx3sDlWq54TGc0Hvp15ojkDrzas0DJpThVATSF6Wx+5M/OK+XUz4XPXZlgyfV8qCWZOxwH0MoKOy13+/yI5P5cjDxm1V7+MgjoLIXwCRpWWrwyUt7oe47UJAn+v+Co1xYvP/EbUcY4VAjU9lwCLz0pY93T3uQgVLnV3M/LNvrobluxnPQk9C5c3Ckw+L1dXZRLSk/bMH5uMUrh++BKOKlA/4+W2mpBBadihqsIOwo61+Ix+ueki6X8GwRyM3hqKyjpttOJ7WRzILxmrOp2MHnE0uuh7rXTa7nInfL5b1d/6M9INiVGjWwU/IEm9oacIephKxouyc2eKKPAIjLhOUOg6CII0h0Q2sRXhageclNLg5j+dSBcbd+fXDLpAxHw7UYTwfp/krwxu1sQRnWOLwko6oJXWuo7mQeY8Zxi9OQMUcd6DlGX48dMiMELy9VzFmmYT0D+ZV7Rk403zPUZm46BwRR7EtNfq4KMjvQRnUnZEFeucQtFb7QY7ISsj5WrVGfGLHfpAAzyVg6UbumirxiSaOA7sBTkjjfBui7cluFpI9ue4u0ZNj3XyKbmrv06DRIwluJyM6CadOLye2TtGBdvBN/tDtZfvRCanOhfioDEsKOXZ6Y4I18EjHaiZims6sIllAPFlf5Ooo3y6K8wklZ26j5FtasfXEXjwbaNwR17UFOoXInHteVnrngm2y+GIIckcqV/4TjKf2pv5viuV+QRujFmb7liIH8K6/lWYC5GBs3Q1qk4FJvsVYlNZI
 Z8k2TJk3
 8FNKUzm8UAv2Ip6Zk6UdW+6/JOoWAiOcyhVFqMp8+UUyCmGgDqZtEnpgaKevat0yTRsvo2GJ73G7FlmWOru73tp3EoZCHDnDJW2XVk3T/1UePpxj8U3d5S78NsTVCsGwvTjVc4oriKDx4k3gS3C1XQXBus0GSNm7zv+Vqycqipm7imUdTfMsCXFL+xjf2rX6etMfy72BshY8BzJRSzMVYeeCegxMx/RxBD5UtxK4N4yK2CN8VHx7vtBk+Jd5Ptd8OJhhWmBVQU2ppWSZ3haA/V3vkrwrIqIPOWNKnE6HEqe0i0xd2qVbOduDhLCDYaPQza5PiR8sfeUbkAzwviK0JgNYQQU1Q58fODI/KQnKfcJLfHQ4HqJ6BPdrWyIc7h1U2jTs1Tp3QyRcJSnMlaZYtQfOljfDmOEqYjZEmoPbA+ZaWbDg8+Uu3x+tjFBwp/Cs3YSY9/O6YhLmgRYYfmVP7HLz15yFeGMxG3Ad6ozykh2D+qUAPwdoyxDDrHxkF0rve6vVO/7+YLHi07QtUcmU/w16PFauSSIwXB2uUUH2GI2XLzQd17tMCCoF2cnvomwYkkdemrRNgO89+tblCgXKa0Gg+0hlaXXXjoHpnrfgd7IJRp2tw506Ao5094ioktnDlEgQd2mOjyS6gK2Esc1OaGOyk2V9nBQ4P3EGpYzuyCU1mB4uwqehbW9UhoEHKW4aT/N1pSz64r+N67EE6Y0UhJi+4OgtI5Qn6HQtseRUEvTjAkOp9ESP7wVJr8xOLH71NlBEaZtPZL2mcCEggWLFry1yxtl7TJkAOgLlvr8a4+r2vBwkRjfnyKaWu8tFjGtwOu5bv/ZzrIPSqFpXQJeF9jw2RCZzlvq6hPQeXwd2XVUSiCeObw+bkMQiLv5N/XrQYIIaX3dXP2sUW0x/jqSz3lBv7sXVF5dHWNkNhW1Uprqfm+YkZFIdbOWOdwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:46:32PM +0100, Lorenzo Stoakes wrote:
> On Mon, Aug 11, 2025 at 02:34:20PM +0900, Harry Yoo wrote:
> > Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
> > page tables are properly synchronized when calling p*d_populate_kernel().
> > It is inteneded to synchronize page tables via pgd_pouplate_kernel() when
> > 5-level paging is in use and via p4d_pouplate_kernel() when 4-level paging
> > is used.
> >
> 
> I think it's worth mentioning here that pgd_populate() is a no-op in 4-level
> systems, so the sychronisation must occur at the P4D level, just to make this
> clear.

Yeah, that's indeed confusing and agree that it's worth mentioning.
Will do. The new one:

Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
ensure page tables are properly synchronized when calling
p*d_populate_kernel().

For 5-level paging, synchronization is performed via pgd_populate_kernel().
In 4-level paging, pgd_populate() is a no-op, so synchronization is instead
performed at the P4D level via p4d_populate_kernel().

> > This fixes intermittent boot failures on systems using 4-level paging
> > and a large amount of persistent memory:
> >
> >   BUG: unable to handle page fault for address: ffffe70000000034
> >   #PF: supervisor write access in kernel mode
> >   #PF: error_code(0x0002) - not-present page
> >   PGD 0 P4D 0
> >   Oops: 0002 [#1] SMP NOPTI
> >   RIP: 0010:__init_single_page+0x9/0x6d
> >   Call Trace:
> >    <TASK>
> >    __init_zone_device_page+0x17/0x5d
> >    memmap_init_zone_device+0x154/0x1bb
> >    pagemap_range+0x2e0/0x40f
> >    memremap_pages+0x10b/0x2f0
> >    devm_memremap_pages+0x1e/0x60
> >    dev_dax_probe+0xce/0x2ec [device_dax]
> >    dax_bus_probe+0x6d/0xc9
> >    [... snip ...]
> >    </TASK>
> >
> > It also fixes a crash in vmemmap_set_pmd() caused by accessing vmemmap
> > before sync_global_pgds() [1]:
> >
> >   BUG: unable to handle page fault for address: ffffeb3ff1200000
> >   #PF: supervisor write access in kernel mode
> >   #PF: error_code(0x0002) - not-present page
> >   PGD 0 P4D 0
> >   Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
> >   Tainted: [W]=WARN
> >   RIP: 0010:vmemmap_set_pmd+0xff/0x230
> >    <TASK>
> >    vmemmap_populate_hugepages+0x176/0x180
> >    vmemmap_populate+0x34/0x80
> >    __populate_section_memmap+0x41/0x90
> >    sparse_add_section+0x121/0x3e0
> >    __add_pages+0xba/0x150
> >    add_pages+0x1d/0x70
> >    memremap_pages+0x3dc/0x810
> >    devm_memremap_pages+0x1c/0x60
> >    xe_devm_add+0x8b/0x100 [xe]
> >    xe_tile_init_noalloc+0x6a/0x70 [xe]
> >    xe_device_probe+0x48c/0x740 [xe]
> >    [... snip ...]
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> > Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
> > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Other than nitty comments, this looks good to me, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

> > ---
> >  arch/x86/include/asm/pgtable_64_types.h | 3 +++
> >  arch/x86/mm/init_64.c                   | 5 +++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> > index 4604f924d8b8..7eb61ef6a185 100644
> > --- a/arch/x86/include/asm/pgtable_64_types.h
> > +++ b/arch/x86/include/asm/pgtable_64_types.h
> > @@ -36,6 +36,9 @@ static inline bool pgtable_l5_enabled(void)
> >  #define pgtable_l5_enabled() cpu_feature_enabled(X86_FEATURE_LA57)
> >  #endif /* USE_EARLY_PGTABLE_L5 */
> >
> > +#define ARCH_PAGE_TABLE_SYNC_MASK \
> > +	(pgtable_l5_enabled() ? PGTBL_PGD_MODIFIED : PGTBL_P4D_MODIFIED)
> > +
> >  extern unsigned int pgdir_shift;
> >  extern unsigned int ptrs_per_p4d;
> >
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index 76e33bd7c556..a78b498c0dc3 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -223,6 +223,11 @@ static void sync_global_pgds(unsigned long start, unsigned long end)
> >  		sync_global_pgds_l4(start, end);
> >  }
> >
> 
> Worth a comment to say 'if 4-level, then we synchronise at P4D level by
> convention, however the same sync_global_pgds() applies'?

Maybe:

/*
 * Make kernel mappings visible in all page tables in the system.
 * This is necessary except when the init task populates kernel mappings
 * during the boot process. In that case, all processes originating from
 * the init task copies the kernel mappings, so there is no issue.
 * Otherwise, missing synchronization could lead to kernel crashes due
 * to missing page table entries for certain kernel mappings.
 *
 * Synchronization is performed at the top level, which is the PGD in
 * 5-level paging systems. But in 4-level paging systems, however,
 * pgd_populate() is a no-op, so synchronization is done at P4D level instead.
 * sync_global_pgds() handles this difference between paging levels.
 */

-- 
Cheers,
Harry / Hyeonggon

> > +void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
> > +{
> > +	sync_global_pgds(start, end);
> > +}
> > +
> >  /*
> >   * NOTE: This function is marked __ref because it calls __init function
> >   * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
> > --
> > 2.43.0
> >


