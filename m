Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0EB6CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0059D8E0002; Thu,  4 Sep 2025 13:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6A78E0001; Thu,  4 Sep 2025 13:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70CA8E0002; Thu,  4 Sep 2025 13:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEFF88E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:23:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CA0C1DDA27
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:23:09 +0000 (UTC)
X-FDA: 83852238498.29.6712000
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C67E1A000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:23:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZTSwZd08;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zEOgvxpM;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757006586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+mUepPk0EGT5HWZ5Ibj5A8G4XBggdNtVtILRKUwjFc=;
	b=oHWl0SyGThNzeNPFGutKArcZEoaRkY81GoxSs/jiTIGemSHYTEnqZm/mXubqHzonG/7qcb
	CPuGX2zdjaUT4tmhnVnaH4c2Dga6rSdXMW/McpuWyiZlW5PtoZCveQc0FVnahe2OLN3VW/
	AbMupUYbkJBGE9156VLnFeXDnGzQdIU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZTSwZd08;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zEOgvxpM;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757006586; a=rsa-sha256;
	cv=pass;
	b=HzasB9kJoYCQ3ZtahuwMkt7iNl7JMrWzWF6qRATwzGUNvuLQJq+z0dCjVA4epfGV8549pf
	wpcPTuiG+BRwvEjF+1lBUKRdF+KRA8XadBVo0Iy6sU2UJTtqClAKo9aMuUirlmw7RoJphe
	wMODW72zgkN2PeCAk+EywE7GKb2inCA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584GMexo020748;
	Thu, 4 Sep 2025 17:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=V+mUepPk0EGT5HWZ5I
	bj5A8G4XBggdNtVtILRKUwjFc=; b=ZTSwZd08ToE4EBf0+KIlsHfrKQRa4gmXGb
	77DtF4jmqKL8JJJo6xeUWCkYwMnJdszRIEnPfRZTZ6+8vPgS/QL53qECAxWj9XIq
	Kri7IY/JIByisekNw0tz/8iYe1j2wRHKBTLYWaYwqoSLljRBm9ExxUaaX2w+4PdR
	eudWvgrpxv2IdRDC4KkT4t3bZK6h1nAlES+NJrHBViCcK6YLTDnzOBs1P1AcGWGg
	CC1A852MK+gCivmA0uYRPhn+Vi2gqRjbeieGptK5sniLnaFWrcKnzfRHlExeuncs
	48xzLxBLu+VFRrHUrAy/izJp7C+6+NTi2VZu5bmmjFy+J6go85Vw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt06w8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 17:23:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584GS06b015766;
	Thu, 4 Sep 2025 17:22:58 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01r3daw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 17:22:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWvOyLra+SinPbxKIF5jdILgV0Q/1jjFWtl8p+hOpgEaS4V7C+vU4hwAG5G0WbVVDFqqqsvlg+if2JCMkR0Ue1KM6qPugVVT+pJLzIFQybQQyuskEPgTi4Z91Zz+A6CnHXuaDqSUESmEjduxQnp21g73tEL35iLbskKyQSf/QayKXOjPehms+VwTQpV2Fs8JGSbGOnFxe5vkvH9c5ph0hpfkVBsgmr31+RdacsijPZJYzUtuuV57WMXZiSFRtFInOzVpIjZp73IFssEp2N91sfZVDhhnQ6rzLwDtw0/DvtW8/AZCjCmEPZ/1je38jKjDXrxIwrRtwHijCXhiAa0prg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+mUepPk0EGT5HWZ5Ibj5A8G4XBggdNtVtILRKUwjFc=;
 b=n+LwAkFN50UQVgosrWb4H7KV//U1+UQndfS1yw+XGQXYT2vj1ku8rbka4vP46eVOxBPIDjOP8JQaSOpphae4jdI/0JeR/5Gr1vbQZw53Q8rAOAHAq29maTA7QmI5rKe+r0CSamZFNMWe/3NnxaZNZwTr6LAf/s5ISwyOIWo+aM06slD0ULvuCSHcMsVSI/7GU59gKgIjDYLHFurkjA6LSjKDPCRPjzuHxFNPB0gZbjl8JBaHvZxpMGK21X2sgDP0ZKtpR7z+C4HudVN86Xu30FQo5UbDJ3Otng99shKhus8/+hqR5M6wWcBA4UNFHw77Q++sABdHzDK0vvCwQuaFGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+mUepPk0EGT5HWZ5Ibj5A8G4XBggdNtVtILRKUwjFc=;
 b=zEOgvxpMvJ+B6GJDaLdaaI26byHXkzOqeIPfWHlGiBnjUjdiLVciW2xCPIqaoyItu/AuXii0KcVH0MJuaMafXaBvpTPHePF7HCWZdjpxVat9hMquQEYaf5EQXNGgGbOlYeNz2XECPiWpWpEOvsegMzQZC6sC472jWRWodI0rwDU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH3PPFB6E8A1B1E.namprd10.prod.outlook.com (2603:10b6:518:1::7c2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Thu, 4 Sep
 2025 17:22:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 17:22:55 +0000
Date: Thu, 4 Sep 2025 13:22:51 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
        minchan@kernel.org, kernel-team@android.com, android-mm@google.com,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org, 
	minchan@kernel.org, kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0301.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH3PPFB6E8A1B1E:EE_
X-MS-Office365-Filtering-Correlation-Id: 518ca01e-d72e-45d4-b2aa-08ddebd7af70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PKDZBZjaTbj4DrcJvnR7Ch26NVMJCX9nw4WTLYF5a9eMtvP1PBOOUY9/yiH9?=
 =?us-ascii?Q?jZJkt1FGuDDl/EpcLz2KigVMkHUCw1KD6RNJ9WcWifB7+mI0CzHm3VSsoo2o?=
 =?us-ascii?Q?QvrekmCrn4AmkrcnNBkMfXTuWP0BV/W9SWjKaritsivVG2yvce/X7G6iVAZF?=
 =?us-ascii?Q?VsBYpdof9f/gLVU9xKm1Uv8a6rpdzputQ6PQArdLkRSpoReG19OnfTSbVraS?=
 =?us-ascii?Q?OujMq2mqRHdVxBacyYy2umYG1bsuCsv2W8hTXrxm8lJPknIySmVstInQCK/w?=
 =?us-ascii?Q?6D/ztrWc/KkGU1TAd97lJZh0oiyNGFrzxlKBgyVrnSliCgHb1EYnmgw1/Rh3?=
 =?us-ascii?Q?zjZPjRyLZ4iS5f4FebxEQ8GKWby0Wa94ImC568reCgF907qFh92bqkqQvfNK?=
 =?us-ascii?Q?kxp1tGFOOjnWFADyk0IxAg97vLqXY2uwQHnXnGhqxxjyxG7UuPz86HyhwjhY?=
 =?us-ascii?Q?tKrMhDJtS6KJINpg54rCC3qhUNIMy6iC8miqe0GAuf/A14ejgObhlWfKKsnj?=
 =?us-ascii?Q?iURehuFxAkZLcqgZ0AfFwRKpltGcKS+pfiCR+bemL1PBcbq50J8PlNz4EV82?=
 =?us-ascii?Q?i7zeSNhOyozcOYvu5jtcWeUwcfapYMbxIocjMxpWggGFusWwCL0XwV9c0Py8?=
 =?us-ascii?Q?uRUSQZxafr9qw4cHeaSw6DqqG5wbowTWJfbpw9NbeLGqrVYOgtUYTe3i3ixT?=
 =?us-ascii?Q?YvAr8Ti7LKU0F4fDB+XCykC5laCbt8S3cmN0s3S/sKm/+jZipT0/9Tb0mhI9?=
 =?us-ascii?Q?c3zYWV1kJfItLrfLEA63j6qeQF5HE9o2+jFsKarY3D1PacZhU+BAoDSWqLeZ?=
 =?us-ascii?Q?5CcXHq1T+xxSxmS6gPtd2RdGKJmkGdkGWbYbVRLdn02mX0D4WhyWylimZxYw?=
 =?us-ascii?Q?9JH7uDM2pw7ZXaq/vkLABCKf9YiP7uO5+lyhgllE6HWN+qOdB4CbqMUsq1KG?=
 =?us-ascii?Q?ySRYEj3/QJENm8JLGcgBcd4gGM47FIdKIns9n7qMv3YNB9IfkoHv0LITwsOm?=
 =?us-ascii?Q?JiHMW3LBTEUH7O3zyQSAGq+q2/exK0x8BQmRBx5SvebpGWYrkphxiYK7qTCP?=
 =?us-ascii?Q?Sn6liL3TXQUy2pCF03/70Jv75F/4qKpsgwAaYIM7zeDxYmyI0QuLYvAVpRMp?=
 =?us-ascii?Q?eVdUP+9RN1uC1+R5I6PGg111K7xicHEw6Q3mbAhAoIEnUrNGZgUIh+ntJM7R?=
 =?us-ascii?Q?/KBzgXccCy+sDfqFroc7qjl19XUZQwzq+ehZoJkWnuHgStKhah/FZvXhpin9?=
 =?us-ascii?Q?Z13GA2HEdjZrC0Wp1IQTu7m31W5+SlsvrHcwseK1s0V/uajtWYA8AIR2Pyzp?=
 =?us-ascii?Q?EjmJg3/xZ2VO+0racUPCAW0mVuGFkc6ZeCqgG/8q3V3wt40p5he7KG6xy10O?=
 =?us-ascii?Q?BHgCEzo5sj7+8HpJHZB3saMIsuqVN9cFk1bonEJ93bzUxbuyqLGp2A4dVlKr?=
 =?us-ascii?Q?c3sh5RTlysE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/elKLgR4ZVznA3OO3JiPH5IVnVe5noD3ULxGyy83dBI9n4M3dwJbKZ3Oo2ww?=
 =?us-ascii?Q?oi/UeKbpAD2QDQdmzMwx7//RHiGagBW+yiFXFybH1zMs0o2WK5/CqAjbjDDO?=
 =?us-ascii?Q?pvBBMWW6db8zXqEntzUMNJ9NjGtUxJ2JjyefiOzA79v3VyS2ovY43vfdf7ch?=
 =?us-ascii?Q?S6IANQuB6nstG5spNuurFDYW5gjzUQfCk+5NZPs/I4QESgXs6Y2WQ0+TvN7g?=
 =?us-ascii?Q?prLv9Ru9robjcn3AsHX9LKC8Fg5D3O1od1ELNVtWLqvXaSaEF6bi36bfEJ3Q?=
 =?us-ascii?Q?AYK4T1lubMPt5zmfS6An1AjrChWz0NLjP3Fpv9I+zjFJfRncd5kIUIjOyKnJ?=
 =?us-ascii?Q?MPjb4RT+kj1E4Xr5VitN2JrocQf0M84NGbEPmryDj6fl3OW1rD5Kx0NfcrVC?=
 =?us-ascii?Q?OOXAcJh1UdCpWdBbXkwJU6JxzMEAZO8hjaql78bHmIqkekxAZIfWf3Wub1Yc?=
 =?us-ascii?Q?culkI0Z7WbCsJ98vy8VOjOewUSBE31XVXt3xePuD09zRy69bDm98r5/C9PhW?=
 =?us-ascii?Q?0mStfhwV+NqdG0vp19OqhcIFuew0NPmEfH8bU3fUfF8kPftmiMg22TbSewYS?=
 =?us-ascii?Q?+2Bbw/i8P3oGuRICAGqlaRM9pW539hbavZMNqpCsErPfYiZDZyNEYTScyvyN?=
 =?us-ascii?Q?4WT7tbgIchGeQs6PEnRW35tQv+JV77y4JhRypY0/IpbW57c0JotRKVHyL9iU?=
 =?us-ascii?Q?8iYB2s3PfSglf8Redln/yaOnXISBJtXFJrnpvlo2+t6wgUeTKmEeqT0ccgqa?=
 =?us-ascii?Q?yNLK+aJiL1p5esXT8z55Klsw9kCuJivcVFb6cx5fsBFG14RFikvHrIjw2gqs?=
 =?us-ascii?Q?ldsqGRDprsIg1lpMJpr3Vz96UqO40eK7iEo8jdlLXvdaADurhxMSPsXtIu4X?=
 =?us-ascii?Q?srz/IzbypN0Z2BjgowyuBdRrr85ZHUr45vA9JDcyBMcyBHtl71p97XT6JlP5?=
 =?us-ascii?Q?RmtfJVc2s8tw8MzDRuQexp8oU6PqYhGShIiuVuK3Qt4VaNmyqtQnaZMT4Qoe?=
 =?us-ascii?Q?bhHfo/5uj6Om/5LzHrIq6Y715IevThwCUD8JKSplCKvRRv6P5pm2o7bp66DS?=
 =?us-ascii?Q?gxenA/MEbZqHkOMapvLMKCw+oJu+W20UcMeDmpU9ZLEgHyF5qWtzqmD/5TOC?=
 =?us-ascii?Q?DWhj+NUXtyvIIztIq3w4Yc5T0n9NKyfeMGy491LGYpaOC+xEaMDm8l7krxdC?=
 =?us-ascii?Q?t9REhIQwWuWC73wW6/xPaZfNHtxFZNrH69mc8qRW1RTQAWeP1v6f6tqvVpkS?=
 =?us-ascii?Q?0zvfzTKrCQ8qnRfxSohQCp6c+lwIXtMXVMtqhwcYKBTi0kR+Kg22ImMn63Sn?=
 =?us-ascii?Q?/CMIyJL2yPcwICEhm2OkO3laTesQJObGpzOdVn6z9LoAXHapO7bhsCb4Ae4A?=
 =?us-ascii?Q?ccKRxsDdMPO2dCYynj7tSyZmhEAjOVnsJgLDU0SuqrO7A26kVw7fH+iyzw++?=
 =?us-ascii?Q?mn2ulU0MJR3U2Cskp59O2I+vlOedWHKmNd/x6nBXpmbvGbamTCyOI5VaOQdf?=
 =?us-ascii?Q?41y9A5pQC5BaLv+1AWxczzD6+tjc2TIYp6lqcg150r4+dnPW9mJ4PxLopeVN?=
 =?us-ascii?Q?ca/PmWSiTI/UMtRD2zpdYZqHpHJFcYLuiYhXxyRU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GS3zmwDnrthIIw86zAjxUS6gSfgwqYb6olcpf4SOBfzxBYj4IDFaJTpFnJhcNXPoxfSvCl57ZOsFNexQxKVdoSniOM2eg7iF9MOz7s/lAmqVqnCigQunpIAJA5hy+CzE/eK5VHMSU1nKr7TGkfD56bXeR9kMsPl/TK41XJr7LlR7nkUHArSU4WgIhvRBJhlcRmsQFuGT1plpbJUxXvAcEng1QU7ijDAya0msTdvWEJWdsF0qogbXImI0wlMeDcNHRc/XwwS5hZ6BYSeJvrtAFxpjentm6cKbU3TrUZLvV4LBl5sex3xhMpxMgGUKCjLvupY86AGyj+ajwnHcrALY1xt4piFZoyk9YZTwmXCZtcA0UIS+su4whRScNP8YtHQiWXhEy4w6KUmcEpAWzq0yHemaiVnZ8E/DQkhv3Nx6x02EJkQfbJ2Vz1+QPdSJxFvCiEbqGi3IflFWcwgS9L/DXiZnTUlYCBouColgNpKpaeUkXUNNsagWaX3HjqCAHy/ZMrXRiVh28uEKAl1UsMmTg9BJQJtUoE1OgLQTO7ijZGuaSjIh58hBaV3VCwYEeVHacBtSqjuaW18xCzoJlj7Xk3NNN5pO2f+HtcptGf0eU34=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518ca01e-d72e-45d4-b2aa-08ddebd7af70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 17:22:55.2726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PzkT2CK86gctYSe7ZqOgFVe/qpcEmBRaZnUiYGDOVfddJ3O4VHZ3Z+UAr9m4kkqBKIby1dFSxj/gp2BRaHndg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFB6E8A1B1E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040171
X-Proofpoint-ORIG-GUID: 3df2vTOXpWSRsRNo3vaA5vtsS1h3pdsd
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9caf4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=NSDreuSvHAGQj-7__XwA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX82FMdYj6V3lN
 54TW/RuwzV843maXRv1wcnu6tozEpSc6tii34a/BzJDqy5oIzA4fdJJN6unRGcSMsk+zLHmk/FO
 o816kr1moj//0hIHyB4m1rZUSEJ1BS7B87DH4YpK4SJ8RqLul62CdUAX78gwQqhGuKFMqHVNmja
 eoo7shyN7IFM2TqMKyqgMezv9XPYFyPeBHxes4OrIkyqwoxw+42Ii6j8Q42lHB6K2TZmF4kMtJ6
 AzdebshGfdhQ1j/NAOFndXmX/zsC1Sr1RoOBKFNu9XhX8/hoZOUAnuknb4qdhm5yb9Ng8Y/wLRb
 pfAb6q6YeRdXs+vtaNzX8Itx8DsRTx1KLSj7IQszJWo2ramuewY8R/Sd2XINn/DDwbqk2Y2sUUy
 9aVU1pLA
X-Proofpoint-GUID: 3df2vTOXpWSRsRNo3vaA5vtsS1h3pdsd
X-Stat-Signature: ro16d1zy76f9nhig18aqk73e3oayirtm
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C67E1A000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1757006585-268474
X-HE-Meta: U2FsdGVkX18jWWAgy03TcF+O1QvYvdErLiDMkwT/7DGJP7fGcJhZzhH6PS34uAuegoRqUSHVEol/82oF4e5p2hFWnLSYypE+OQOV7Ttm5/u9Ce3cmXHyys9xeG4UOhlpJlNto0LyhUovua3vN3ojLrQvgGVmm5c5v2zeHXTbab8cHcwnEdNQQ87OCHTwZ9WoSCAw6En5cmGiWnZXUs084vGMHauG07Ol91Y+yH/Lb6zMdPBRnCC2E0ZtTANx9xOvFk7pFzXGyO7z0eOsiJsYb+G65H5vQH1Plnti5420NNnEcaP4/jpRGbbQyG3TcBv25tyynxasXNsZ7ukrHHbFhMt9cj1xNYsd/Y2nIlWzQg8TYiMJj5lrdFf0p+Vh/Xwc8x+6C4qZ+Y1krQT4HLri6EsIXMaaa5I4/umGBQa7AZDBeGJ2F0ujaw0qfqTdc75DAQatUS4Vqtt8f6B5ygaRTY0qutjSavfqYvo5+XRoglkHSBoss3QrVGAzu6JIm5OLQCEOiY86MC0EkvNG3ZmfJtGKMDC/3B1dEUik0h5DB+jQ4lplU27ELYtDdG/TMbuVnyyhJqeDI8yQXHXofgmguzZIt/7po//x2X64lpgk0w9O+Vv/nl6J6+cOUX63yRY8KGAsNMKtGb4EtxdWGgzEcIgecAbL932k46RURt1/f5elnGCFNP/AFw5pianG7m+f+onK1kxN1aP1QqnJkOG43kSpDdgJxnzS/dfSZLgrT3P/aIYAYKd8uoT3AyyRPRwq/NrxoEAZIIRVCiVDaHn0WJkxgDG7k6hNewSYzuS+jwi4zWhK5WsdeaLa8l91gmTlCOeYCe6QY7lj26QoXTXyvcXd2301QOVXA2t8sh1rBqaD51KE2LRNUSqaxTDh0QZF1/9W/tMt6925/O29H15FKgYI4+6bp16WoCDJWMtHl8kOPvJvQunpZhY9g4JcoHiWLnOrHpmS/SBc47wm8pR
 7lX4vjdI
 gXQHcsoLvJdBHgUr2bQAqolyvddHmQoFGB0j9UjXFDw7E0kS1pjGVFC67kCQUkKmO6yr9kyZ2Vk7ibouV4Y5zNSLxezogT/1XlpUb5mnHlRI2Unk2ORnmFwzHNmnmFyqEvGKOIFyRa+eS/4fUlnQ/mth3mni0VRtqE/a7mLO8z7Vi0HighUJZGBWBxVYdtIkgpsjeE9Md6h9b2F/73Mw/i1dWh8sA5JNppdvfb4eXgQjw8vgZCLt22dflv52HB3ZveADUsoCeWLqlGCxQll9nja+pzU5MWjirD8+Leuk29eel9k8Lw0FoyaHmOAk5uIrEbEQYhBjtXwz6zdZ0bLYY9S4OCmzaNoT/2OmO5t6BU/eU/w1iTglWKZTBXIiN7ZPUqkSgNR1dFFexnv/MTyZa3uWanoQYM2lXhffB1bKtUzkUgDhzlyA1F+y2oECc+PromRD/QRV69NtHEZwIpbsVvsStS0W+RQOnwUYGPxsyTkPm4IlJUNnLLYICZMeQP6RoXtoZR0ATJjL5p158TsFNpWMly4s3BOjK0dy503rxsqvKUrM6mx/MR8zQtVrWvCXIBljMOLYBd1UHxaNP833fTcUiv9W/J1wvLdU70qvNqqNj5bXToco8InlV/BfkBQZ3nOmCTOh6Az93Fyti8UI3aYRClfCkz1QDd8uYlG+HkBHbA3iRE6VDhl7NWnUiwWxCJyfa/XgbP2abV70qWvMsYEqxGwmBTxJQrUj8OVwK5r47gKWjJWi5ey8HSjeDPxt6XoI1TZ0RBNA+9bzFSeKK9Vw1PwH/7jSROTcQ/IN1DPa7mmh6qYm6aUVXLzRMfGvdiA4QAQ9IjkUSyQDz15ro6kjsNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250904 12:02]:
> On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> > The check against the max map count (sysctl_max_map_count) was
> > open-coded in several places. This led to inconsistent enforcement
> > and subtle bugs where the limit could be exceeded.
> >
> > For example, some paths would check map_count > sysctl_max_map_count
> > before allocating a new VMA and incrementing the count, allowing the
> > process to reach sysctl_max_map_count + 1:
> >
> >     int do_brk_flags(...)
> >     {
> >         if (mm->map_count > sysctl_max_map_count)
> >             return -ENOMEM;
> >
> >         /* We can get here with mm->map_count == sysctl_max_map_count */
> >
> >         vma = vm_area_alloc(mm);
> >         ...
> >         mm->map_count++   /* We've now exceeded the threshold. */
> >     }
> >
> > To fix this and unify the logic, introduce a new function,
> > exceeds_max_map_count(), to consolidate the check. All open-coded
> > checks are replaced with calls to this new function, ensuring the
> > limit is applied uniformly and correctly.
> >
> > To improve encapsulation, sysctl_max_map_count is now static to
> > mm/mmap.c. The new helper also adds a rate-limited warning to make
> > debugging applications that exhaust their VMA limit easier.
> >
> 
> Yeah this is nice thanks!
> 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  include/linux/mm.h | 11 ++++++++++-
> >  mm/mmap.c          | 15 ++++++++++++++-
> >  mm/mremap.c        |  7 ++++---
> >  mm/nommu.c         |  2 +-
> >  mm/util.c          |  1 -
> >  mm/vma.c           |  6 +++---
> >  6 files changed, 32 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..d4e64e6a9814 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
> >  #define MAPCOUNT_ELF_CORE_MARGIN	(5)
> >  #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
> >
> > -extern int sysctl_max_map_count;
> > +/**
> > + * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
> > + * @mm: The memory descriptor for the process.
> > + * @new_vmas: The number of new VMAs the operation will create.
> > + *
> > + * Returns true if the operation would cause the number of VMAs to exceed
> > + * the sysctl_max_map_count limit, false otherwise. A rate-limited warning
> > + * is logged if the limit is exceeded.
> > + */
> > +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas);
> 
> No new externs please (as Pedro also pointed out! :)
> 
> >
> >  extern unsigned long sysctl_user_reserve_kbytes;
> >  extern unsigned long sysctl_admin_reserve_kbytes;
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7306253cc3b5..693a0105e6a5 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
> >  		return -EOVERFLOW;
> >
> >  	/* Too many mappings? */
> > -	if (mm->map_count > sysctl_max_map_count)
> > +	if (exceeds_max_map_count(mm, 0))
> 
> Yeah this last 'mystery meat' parameter isn't amazing though to be honest, it's
> kinda hard to read/understand.
> 
> E.g.:
> 
> int map_count_capacity(const struct *mm)
> {
> 	const int map_count = mm->map_count;
> 	const int max_count = sysctl_max_map_count;
> 
> 	return max_count > map_count ? max_count - map_count : 0;
> }
> 
> Then this would become;
> 
> 	if (!map_count_capacity(mm)) {
> 		// blah.
> 	}
> 
> 
> >  		return -ENOMEM;
> >
> >  	/*
> > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
> >  int sysctl_legacy_va_layout;
> >  #endif
> >
> > +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> > +
> > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas)
> > +{
> > +	if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> > +		pr_warn_ratelimited("%s (%d): Map count limit %u exceeded\n",
> > +				    current->comm, current->pid,
> > +				    sysctl_max_map_count);
> 
> Yeah not a fan of this, we aren't warning elsewhere, it's actually perfectly
> normal for somebody to exceed this, this isn't at the level of a warning.
> 
> > +		return true;
> > +	}
> > +	return false;
> > +}
> > +
> >  static const struct ctl_table mmap_table[] = {
> >  		{
> >  				.procname       = "max_map_count",
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e618a706aff5..793fad58302c 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
> >  	 * We'd prefer to avoid failure later on in do_munmap:
> >  	 * which may split one vma into three before unmapping.
> >  	 */
> > -	if (current->mm->map_count >= sysctl_max_map_count - 3)
> > +	if (exceeds_max_map_count(current->mm, 4))
> >  		return -ENOMEM;
> 
> In my version this would be:
> 
> 	if (map_count_capacity(current->mm) < 4)
> 		return -ENOMEM;
> 

Someone could write map_count_capacity(current->mm) <= 4 and reintroduce
what this is trying to solve.  And with the way it is written in this
patch, someone could pass in the wrong number.

I'm not sure this is worth doing.  There are places we allow the count
to go higher.

Certainly fix the brk < to be <= and any other calculations, but the
rest seem okay as-is to me.  The only real way to be sure we don't cause
a bug in the future is to have better testing.

Thanks,
Liam

