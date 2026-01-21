Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A27F4C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90ADC6B00B1; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8866B00B2; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762F46B00B3; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D056B00B1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D80F5B267
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:18 +0000 (UTC)
X-FDA: 84356561436.12.1988EAA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD49BA0012
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OHMT2OWX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HtWNEIgZ;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=;
	b=6XIb5GP0NpcAHgvzPz0QkOl8yA3iKjyR4scPn6aOL/7SBzYTZrNqDumlSTtWCv5PE8hxkw
	xu5Fa/EhwEOKMm1JsFlB+nIQ5won0tJc9d3s61So798OyGLuUwUgJP6ag5FJtkQ8+STJ2M
	0u8bCVXLuv8jXrOyYJQxUuW/mfyU1/k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OHMT2OWX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HtWNEIgZ;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014274; a=rsa-sha256;
	cv=pass;
	b=5A+fkK025YtGK+hnj7ka6/DdJ+BkD3fEVZ+a15/0VgC/KsB1IxVfDNMAFUt3d/2ich8Z42
	I8toMiA4S5ga2oD7XoAvKjS1oDuRec2of+0W2/cQZB9oMtZamSjiWaEOtpYl4N6admsbJ/
	WQP88wXX/Qj5i1KNL4GmjwpgAy7GeNI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60L7ElmN421477;
	Wed, 21 Jan 2026 16:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=; b=
	OHMT2OWXcJjBTOvKazMklUxYBEm2IP0YIlkIA5m5K4qRYHmuuU2Ec6U0MiNLM5UE
	3MM/W9KfG2dOj4eUloK14tLjIl3F98XIimcfianHHqvNd2Igz8vShhqiP7QR5iuz
	9fh0ZtHhnx0nsW/FAs/K2Mv6HQhjAb4Ikb5wPDFsM9Tb7DvXsJf/8X3WXD5bBRRn
	ozsEbmVSlq3Uj/LyjfENR5ur88EjwAwRIcHdfErPRuAJlhgEtICpiokciuHxZpwm
	EN21odQcKVu7Ir2aXcpjp1bT9DkuW3EPxyXACDRmbXXAtdjisDFM3iYTxBmoy39G
	geagRyAvGZOAhglk2YaU8Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagctt01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFwZbA018907;
	Wed, 21 Jan 2026 16:51:03 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010001.outbound.protection.outlook.com [52.101.46.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbndr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J+I3XPbOP+DIU7u/eveDfm4F7+gMTQ8j6L8g20qxvEfwfhAymf96toKX1ZPtJrfE+UNGFWEUzr6nQQY08tdb3o1+HBBLsakQO0teR3wagxYfOg7QQQf6IRwE1sPyUz8K92aUfZ2ySHt624cQcKLdsIBnT2Xg5pwQ8dKD8vf+uLmirJq850x0CLg4aQmfWJtGtZvJOP395z7MAUzzPxzaQGDvKUQIvdjLZf/CLiD1cuhBwhAMEBtST7hlPEhwQcO2+A0cfRk5U1tBTNCXJ/BBHztz9uypUzLcD6TW5qm9VRJJKctppih2iTq1rQyaJKNuLiXj5m/h2Wp41pKokrh9Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=;
 b=wtdFwb2cKSHgEhhxJSN2HgWnble9Hezfrqc6rERKVKd1FqOc3ea/NbRgHQmXGdoC7F5UUEZNiSmhHl/JZN4wLtDp45lNR3Wuk1Y32qlnJs8EnOxs5JEfnP1/DKhJ0Q3pgMa2YANw3qbgeVIx6eW9wu4heFV55+1lzjMjd4Nac0IYVTF35fg9sdWsm7Pn4Su8gGItuAwis5QHjokxI/TCIESvMCDbyAJzg2NaJhSICB2wzICcURZlXIVR98ScjIZMHvNKFs5Jhe480xWShDvgz/NI2LNEX6U1/Xu/2W8+iYP0m1ChbR4HDiWps/ESCja9eoGtoDRKi1jpn04on4N1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=;
 b=HtWNEIgZkS1luIZmNzALvFxMsesY9+u43G/4Gb4BonOxpGcvUQq7gjksaw5eND0M1dJfMQ7mbLL/TovNxioJbzj9vLdbpaJqk50QSDkBbY+uKegua5xHr5DuwlYOrWGH9lcY9OguUpbrDUa/YJj7mrKedwL0lV+u2DuNEpb8+Qg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:51:00 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:59 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 07/11] mm: Change dup_mmap() recovery
Date: Wed, 21 Jan 2026 11:49:42 -0500
Message-ID: <20260121164946.2093480-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e42b6f-caee-490c-de98-08de590d4119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A9GiwrwMMoLDvpV9LC45F9tp6OWltZTL/f906aH9I719BXfSQ+iO7srTpH8i?=
 =?us-ascii?Q?FH1HkDiz8ruq2uhfq6NaAI4I+mnK587oHaAwr6dB4gs5/D6ojOtcR+9zGFqZ?=
 =?us-ascii?Q?Ir6Ziwlg345LoTSIDPW1j+ufsJAvWK4kvP73OVhcjacahJYCNjzD1oLGtDWe?=
 =?us-ascii?Q?Yd/Mq/IG9Oq+va21V5SqglemjqvMBM9i47xcp4fQxc5NCrLJodudfmS2uuaU?=
 =?us-ascii?Q?wAN2mglDIGUyOta1cekVFyS+FeNobGj4EVcqvo7Zn4leXIIRx0mPORhhq4Ax?=
 =?us-ascii?Q?lgIAhGVs+walE/Bb5XnKnWucv5BLYsPbQeRQn31xwfUzm/G4NY0FBdoCuZyn?=
 =?us-ascii?Q?4gpwZCYO9lEkTWIx5iB1yblZlW0djL5Fz6DQ2aVvxmXyipfIRi9XUqWDE6c3?=
 =?us-ascii?Q?bcpaYwHIq/uOw9fdtFAdhGotUBpR/ZIxLfRxH9b7R5Drd47LjFewEuHMskdI?=
 =?us-ascii?Q?+HBPdg7h0yiO/k7dFtmyirykVnLCbfPow+KmYkW4Xd9c3LBYjuNq5863dlGW?=
 =?us-ascii?Q?iE7pjlc7ReogcXTeLW18iu2hpMTxEqHHxJFRT6Z0SdptU4S+Gn+RdbUR4Aty?=
 =?us-ascii?Q?zun04St9CfiDDEKbnl3YjBSYkYb5vgXIClfikjG6l8daqGio/PiDL+NxXft2?=
 =?us-ascii?Q?cs6ukqrkwQHp99Nf+6CSJfvN5QFt2Gda/d1g6u1Og6zCXOYcZB2Ku28Rzgp+?=
 =?us-ascii?Q?H41jkVyRic4/dkEbHVjJ7IujsXpce9u5aHY/N44dXhyhw4eUGV1lJFnkcHmH?=
 =?us-ascii?Q?xsAq3FOa7h7rIv9J1u5vPUkjelGSW6hUmDXmD0IzKmPA0leUD0iWu2S1aBn+?=
 =?us-ascii?Q?QQnUT/U7uFPEF/C7HXd0uJj6nDYRNmqm8oZJhko81ZpB17TidoIOzs4Z7wcL?=
 =?us-ascii?Q?UAefvO7U9a9+Q3OhE/Vq59rLw6n7m/z/ES8absU7HbusdOiWeR1wJUsurmOE?=
 =?us-ascii?Q?Fpn60wNZ779R7zWbsWPohizqDdaLzCG0veHtPSYBMDj7yscEtJqCZ/SsDEg1?=
 =?us-ascii?Q?DSY69Y85y3QBS+7ldEZEkFdjy5ANzHnyGU4EVr8rK7zSZ8fHkmAdEOsjnrlm?=
 =?us-ascii?Q?s/8kvPynXCgPZ/Pk3yh8FBzOUuL3T6dbEUCYAAv2z1EXNo/UDwIl8kBuYiw9?=
 =?us-ascii?Q?NzoS8vvzCbtEkUY4I54d3esNWhr5MswZ48WN2QR+p/NMI+FU88l0O3EA2O1O?=
 =?us-ascii?Q?5+MmaZJwW/KT1aU6i+Hg9TosKNUpZtZtfsgLLXlWpbVtpJ3uvr3HH0ZiIRCp?=
 =?us-ascii?Q?cVZ6Q7Rv4sKbLt1eB5QbxkuyToTp5RkgG52zjPQxfEgjgxnbJBaAxeAiM5kC?=
 =?us-ascii?Q?lPJBmk2RaMp9kZAEumROENs8G46r2YFdWhZ3M/tdc8XSxC8C7wQcs9uAUy7Q?=
 =?us-ascii?Q?NfSioH4Ntho78R6G38qrDz2RMkEFlG5T0jrN5rR5zpwuEtwVW+lYa2b3hunz?=
 =?us-ascii?Q?dI1AoCyzA3qT15ykQYmKjm9tgI5R4oelT7tfV67jv+OefcaZ7iKimEXpNsVW?=
 =?us-ascii?Q?DJ4aMaieXWB3oa+UVjB4phtrDA3S8aWUxkiW9IUsNq97JOiJmFf9CeVVymzZ?=
 =?us-ascii?Q?PnAeeWl1Qe1zNnRRxZI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l4/Fpy6UUlpOLh0BeV5KpPD3haBJOsrXanz8E3DbOQsYdqT4hfwhJYRQsKKq?=
 =?us-ascii?Q?szWTziecucK7zgJH9XPYE05RVTMOwX9FoA0P+Eiza+YZkFCgOx6fCEex8EUr?=
 =?us-ascii?Q?kNjU5otBumPYBnEN0B/2910FXW2vR8aFI/WPT7Clx/Bo3BkgkpFJWwIGK2lM?=
 =?us-ascii?Q?wSn9eqdoJgQrrFtfBA33wG1PSMxJdk4qxA94g5nZ7ZU53t2O2akKptiTImfB?=
 =?us-ascii?Q?pqpPWwV6nJ4pYKIX8YE32jaGAUWDCQLH/g+f9EIB7jHbJhcRmccjn3thhO0X?=
 =?us-ascii?Q?piXnG0teNiXfD4OfThgEZK0d7K7f1k7TH0BTpyePWHy3u2i5rzXb5gTxwTDE?=
 =?us-ascii?Q?B+1Sc9QeJa7liMH5NtRswRdwmH3xYl+AMPHCBFFlPXL4Cx+8sblczifPqw6l?=
 =?us-ascii?Q?zQWb4xXMW277UbTWNtxGLH+E1E2M6xqaqBs4giCv4hdemKj9Kk56DhR3qMej?=
 =?us-ascii?Q?PERgo/tdoNmncCtwh12KAVONhTmjm2/ltoQVuuZAhjNzcZV0XCfwGwP2k7cQ?=
 =?us-ascii?Q?bKqm0kgl+FxDOxByxHzU37CqKzQkmUp3lDMnFAp2dwxdthNOVY6crRaX8tlX?=
 =?us-ascii?Q?wPDmNuK0zO+S6PbydnHveuFdVLTXePWP20/3wKfp+KGvETiULt0mlLmqia08?=
 =?us-ascii?Q?ub9jdHJFOr2AbclrdwubH/m3cTfTlMmGOCKr5oGtk87rSB4OyxbLqOgFJXYr?=
 =?us-ascii?Q?yR2SvLnnxtQ/2DhN2XAxnkLktOGghlw1dF/+rA8uzmLZET6hVwgKsKUo10ax?=
 =?us-ascii?Q?gZyMFrQK7N0jkaaAPUag540TIeIyuDPK7IJ+NnGfl1vzEodfkSwcgQ6hMLrY?=
 =?us-ascii?Q?AOA62psT7idQWpAxLLxyoPIEPhqDPuBg68+bc9Y51uCQAsiTlVRo/kP3qrhh?=
 =?us-ascii?Q?/TV0h4tVvwlVp2UXGKmBuXx4yD6e0GHELVgSDX5kQThpvdRe+mYQQeRSJ33+?=
 =?us-ascii?Q?T4hxh0NG/1aBv4Zp10rpI7HompBIOyGz/OsD/wQu8UAS8oR9r4m56jLBfR9Y?=
 =?us-ascii?Q?1YeADD63j9Iihq9Z8zaUD3SK1sojJ/mMOqfdJfihkC0u7VJjh8lK78m8/WO3?=
 =?us-ascii?Q?Env+FdJJXizCmtHiRhM+A5TAYyCQ/nO0G3LHJJOTDx1RkK9OcekNJutiH98u?=
 =?us-ascii?Q?D00ODkQnziMZsmQKinkluK2RFBbIzkr3/5/VPYJAos0psBEPCoarc7874Jej?=
 =?us-ascii?Q?vDruDjeMwXayMDdDISGSwGWYMloCedFOS3gndIrYsMkw/9oZsVuEHSa1PJUA?=
 =?us-ascii?Q?R3cZyF1JDtdy9LpCY1ClrtKcOkUG6iwSCco8NZP6xNxfl7Yb8bJRq9GKzFt3?=
 =?us-ascii?Q?APTH6mTL/VEcT3S0hBymj2Wq7rVIoUJTTTPbpHUzfv2YIwnsfb1koI94PrbB?=
 =?us-ascii?Q?nKYsndWl5DF5DIDHHpE1QsSFInksKhllmLPfro3PzkiaSqdyOhaJG2lcsw+N?=
 =?us-ascii?Q?UyudUzSMNb66wCCDsnMvufdqfM6oKPR2el0DSIrpeXfrFfMGswRZfo+qidcg?=
 =?us-ascii?Q?A9WhBvXlgzfyMsvlf8Vgw2ltOWA3SorudCjsI9Wzwc2oAjF8B0kNmhM457OJ?=
 =?us-ascii?Q?DG3+i9U4RCXCY3ua80fbPKAXRg9ryD+fsglB6Z9SKWbjk0M6/RG03D4Dmqc6?=
 =?us-ascii?Q?TQ/0ORQ9rxf4F5w2YY1UycqTVQHJoWdwZoxos8vhqb5F0E2woRkSr9DFpdAK?=
 =?us-ascii?Q?sMaixrReU3/FMSDEVW4GZSNdEe79mhNbT+zEeivE5DyAOqVd7eP9fXHL+ZTa?=
 =?us-ascii?Q?9XI567q2lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hJdp39EB3DjABx9g3QzCxKQ6N9725CpVZH2fI2mo3Tu9Z8lZycpJD+Q7XHEdHRbvJalCFipgaCFhz9/k7RWD2wfV1VHQT5IqDLFfNUuVXg/MZ+FFLiikdPh1YeKM96J2xaEaDTURGTl/YudBegbwWtNqc1J7aJxxJB+yf13MOoMhpy3ObagHwSM/e78utyIWScihsSpHuehidTb6DRPlQ+F1zg9k3Yl2r8sjppr/4lTvNB56byuRba20M8f3aS3/ANhejt+gy7Ox1jt5vRC2qcciDfr7SQ73MjVcc9vwBvyM/0xa99enyU6/6NWsqOtZExnKsn5JMacnQSbts5SFPan/APEi6N4wLFDngDrV9+gJJZOtxs2Wg4T+8Hp405l0Ut6MEz/PG0m4P5zk89D+2lirBD9Xc3Rvk0dxSFoPHQTzu93xsuC1UZXm8TbxfV9U1tMdd6OJQ+sqsM0kQ34AhxGMnmQh5K0Y51olG/SDTIpFe3RXUfhNuzwpS5DJJIjsaoz3pQNq1Hx6R4saL4tTsXoN8qHzyjXGyudAdfzhj7MuHXSDkGLpVWYzKY4L8adDUQAsRqMeQC8/FX1Fg+4FXAA/tkEm5OriX5X1C1hl14c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e42b6f-caee-490c-de98-08de590d4119
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:59.5888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Eylg1mRvTaIiDRuYLvOMnzA31VCFwomFP05PXtkkIjOAP7saC9zhLABQMx52HTklSqFyFH5QjgeNRWh3owXdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Proofpoint-ORIG-GUID: mtj_2YH2lHZ9FgLj6eu-vXfcAQaU6Blk
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=697103f8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=-ybE2mxfzGY9hGNCwgsA:9 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX9O/CUy1mzCJU
 /85KiuksQLR7PSUsEbuY+7VK5tbFaB2k3dtNCN8v40A2TpNLGpE7LT315KqqfzRtN35lduAnztL
 0zxvL8ElmQuTQydFi4owTTDefN5aTjSBbKiKZ5e7jJ03xUtmos1xiutcKUY5TKMD8zB2KB37ESh
 tkV9T8R92TZ/MueJnMx9y7R0il+rALpE2MiQ9EJxHBW8gLdefU6+1H7EsWC6qs2M6AEOzzCsqTE
 B8gxZitVu5cluZ2cxIY7eLZhnmiYymFouu4na7HUEt3dp6l5w0INtVoutNcT1ltwRcVzqZQuriT
 vCUsnxHtLclI290xoUGHUjIWOxdU8mk/p85KY+23pr0rWDV0rExGqU3wNBk8ZBirqRaDueE4oiy
 ROSOEWbE0rroBph7UpD6uGbxb0y+zYMob+Cv3da8jhayzPCLbBo6l2+Tj1Y7dVlr3vnVOP857C/
 8EzKyP3t7mE3aZk5zZioVrSi39ByiEHRHrI46aVA=
X-Proofpoint-GUID: mtj_2YH2lHZ9FgLj6eu-vXfcAQaU6Blk
X-Stat-Signature: 61wqna3cwhes7djc8peodhh97a4q5zka
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD49BA0012
X-HE-Tag: 1769014274-97958
X-HE-Meta: U2FsdGVkX187qGK/mTx0yHl7Dn2K+YuBoW/HkvAMrMZbNkDpTXl3L4wH602lk7gEAHGBUAKcT9ssADRlPadFWkxmnso3dzHDoFt3SPste+GgHlp2/J+vvNW1KKUsZluihqvhNZ55210sBhhT4ZmMZhqeZBC3n/6RgoTsbj/DEmrIDaoJ9tlaT4S4DOv0fwEHBh3lLQ6tT5IBNoolnRwigo2K8fyzwGArygUJoVeopshdshxEtGGdwfysRdPB3sO//emgGqldKPOl2w4u7Kb47ac2Diy7gmNRs6Kv3w6SmuhKCQnTgk+U+Q73v95GuJyDc0+6y46oAlGRdKHBo5TXgEpEFzQqiqJLkERqwFyOZPEwHDPAZYBOc7PVVwbKRYguUOPgtFtTKGOZxxvXNx61A2I1dJVrIR32xLB3vmeI+mYaTgkoCaur+fYQKT7cLCv8txmlduCtyc5GMQQ/klWTYIdtt6Ch24pcKJiB+kPxoZZ26P0swK88MLRhr9+kb6pvH7XOo5jVtt3zLyqAueaE5z/20c2Q+EhmXCSfrMxhXYYMucW/imPWE7VOpORk5P+uQZRIY7FJHO8Q1HfElJ1Ig6iIgmPr4o/3NY6gvxCD8AxuXSDGrnAR8RmUYFUfUy1V3SHhmUwLWIh/iwZ1dBslwuH48hOvesT2cphG3MHPdd36xVHagsnOXcab2W/b+Jq/0BD3pJx8l+JU+kbnTtN6EepNY4ff57YgcQRDpqxEdChwNJ2sXWRz/VZ70xHKe3gGe4eAfIU25kZD5CTcH8YXO5Vmoyi4T8Xup//LJZ6JNeI+3BMxwLbMm/J3405SeSKJU/jBfXjDSESGYm4OYS2hgjeIczTu00mKpvZQ96vR2iDuI5KCMu1qlECaYAh3eq8qxjmgCsSJnGPl/XK3zjZ4TelJWJ1ThfHsBIes92svJn8W5pn6EHL017TMr3Y5fFY977vuri7jyVlZzgnYbwL
 +DQ/pJVc
 DlxrZ6oWoMVd9dnejmod74AdKnSj6CVPZ7f+EIAx3oO+oGg7cWTmB+ji4NcvR5P3dQQaJKtSX1FhrzBnnjE2VrLcs6lleVmJ1HyA1PesWGrLeUPibw6im5aSb7MSZbIs34EN3vbTpndotbpq+AGl2Jqt1Z9g5VSr3fHgDkby7/qtODuNrabjd9Sn2WBXim5dsvJsS90FD0mqxh1sfbYWX+CRtkP+r1PMitNcM+1Fr3SYcRwEtRvRFwL9sLlItv9USyR0fkWexBBrS7cdHDaPLrgfw6YOF9uwRTCJ5/SlcNlUg7aA3n0D/buBV1TX5IpFWnaJzNkHWF9ZOq/APtCJHFov5bp44E9coCOAjh8eyGSFEUMnm0wfVokc2pZw3Wc1njoWNnP1xORu0qZOV0iAYdXr36JbgFbRJwZuTa/uyzg/vOTFN8lQHN/v2z/l6R6vX9pUwy30/rJHvXFoDjKphE20dJkrwmxElgtu+qlZWIT1VzBm90+Btrc3NEMDpOC1maRIQfP7NPLlM8nufV1KqnX9c1Kkj0Qau9iFs3FEpnuvoBwS0DYfqhR6BycDdRYRokHGoKJarxnFSvcjyp4YIGXW8N3RL6PXx9y8cQqRz+iETIXVttqq/uyshlrAfhe+B0CjamxeVRqWQfq5YpWsqbG7G70/XGKlocgAzOR/fb+Ecow4w7ka0a7J6iJl2531geHnVUytW2sCfodncvjZiGL5T1yQWfgjnyJ8lPLhUhHA2D8ZEVvBOsKbix4PU4mh6vymYzKNY1/R1Xa4VLclwRhZRwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the dup_mmap() fails during the vma duplication or setup, don't
write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
free the new resources, leaving an empty vma tree.

Using XA_ZERO introduced races where the vma could be found between
dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
race can occur because the mm can be reached through the other trees
via successfully copied vmas and other methods such as the swapoff code.

XA_ZERO was marking the location to stop vma removal and pagetable
freeing.  The newly created arguments to the unmap_vmas() and
free_pgtables() serve this function.

Replacing the XA_ZERO entry use with the new argument list also means
the checks for xa_is_zero() are no longer necessary so these are also
removed.

Note that dup_mmap() now cleans up when ALL vmas are successfully
copied, but the dup_mmap() fails to completely set up some other aspect
of the duplication.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/memory.c |  6 +-----
 mm/mmap.c   | 42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9043cfda65b94..4331a6abe3e4c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -411,8 +411,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *next;
 
 		next = mas_find(mas, vma_end - 1);
-		if (unlikely(xa_is_zero(next)))
-			next = NULL;
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -431,8 +429,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
 			next = mas_find(mas, vma_end - 1);
-			if (unlikely(xa_is_zero(next)))
-				next = NULL;
 			if (mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
@@ -2125,7 +2121,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
-	} while (vma && likely(!xa_is_zero(vma)));
+	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 827a64cdcc681..48dae3d48e46f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1285,7 +1285,7 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 
 	vma = vma_next(&vmi);
-	if (!vma || unlikely(xa_is_zero(vma))) {
+	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
 		mmap_write_lock(mm);
@@ -1851,20 +1851,40 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
+		unsigned long end;
 
 		/*
-		 * The entire maple tree has already been duplicated. If the
-		 * mmap duplication fails, mark the failure point with
-		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
-		 * stop releasing VMAs that have not been duplicated after this
-		 * point.
+		 * The entire maple tree has already been duplicated, but
+		 * replacing the vmas failed at mpnt (which could be NULL if
+		 * all were allocated but the last vma was not fully set up).
+		 * Use the start address of the failure point to clean up the
+		 * partially initialized tree.
 		 */
-		if (mpnt) {
-			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-			mas_store(&vmi.mas, XA_ZERO_ENTRY);
-			/* Avoid OOM iterating a broken tree */
-			mm_flags_set(MMF_OOM_SKIP, mm);
+		if (!mm->map_count) {
+			/* zero vmas were written to the new tree. */
+			end = 0;
+		} else if (mpnt) {
+			/* partial tree failure */
+			end = mpnt->vm_start;
+		} else {
+			/* All vmas were written to the new tree */
+			end = ULONG_MAX;
 		}
+
+		/* Hide mm from oom killer because the memory is being freed */
+		mm_flags_set(MMF_OOM_SKIP, mm);
+		if (end) {
+			vma_iter_set(&vmi, 0);
+			tmp = vma_next(&vmi);
+			flush_cache_mm(mm);
+			unmap_region(&vmi.mas, /* vma = */ tmp,
+				     /* vma_start = */ 0, /* vma_end = */ end,
+				     /* pg_end = */ end, /* prev = */ NULL,
+				     /* next = */ NULL);
+			charge = tear_down_vmas(mm, &vmi, tmp, end);
+			vm_unacct_memory(charge);
+		}
+		__mt_destroy(&mm->mm_mt);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
-- 
2.47.3


