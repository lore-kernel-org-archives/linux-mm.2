Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89D7D39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344166B008A; Wed, 14 Jan 2026 14:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EC16B008C; Wed, 14 Jan 2026 14:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6BD6B0092; Wed, 14 Jan 2026 14:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA5C6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:02:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61AE38C0F5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:02:32 +0000 (UTC)
X-FDA: 84331490544.15.71FF9FE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 01028C0014
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:02:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VnJXD7oh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fDgKWGBQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768417349; a=rsa-sha256;
	cv=pass;
	b=CPfviF09e8Rt8e6ZkWSbRhSQHXy+1d3Rl4M6uMOKTN0nx8SCwaQzJjZ5pnXG6UaSIpNhoS
	JHXns7ygTAyprYFIwxiVRUQm/w36MjTc6Mnoom5YX3m3p9DhjkPDdflHZrni6NSQZqBS0N
	Yz3fY3B4lJs+RgTXu+6CpzC/0V9+Apc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VnJXD7oh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fDgKWGBQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768417349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xab8WT48lZ6CS2Z4CmBxsYh22Ma6wNnoWyiTy2rPGg0=;
	b=Z4AETHw6tgDUxf9O4bKXlLHFnOSpIbOySlHfO26aD4OAjN6xjWHic0A66KXJrD9Z6Yn2hh
	N/H7k0M0fkWZ58MHgcHT/VWoqmmjYl/YbUbVuK6HRDaUlqyWniZQ/qSFGuAcr1hWDujKA9
	zhFs5KRerZLPoyN67aSSe1rpOZgcpHw=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EHxRqY1362469;
	Wed, 14 Jan 2026 19:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xab8WT48lZ6CS2Z4Cm
	BxsYh22Ma6wNnoWyiTy2rPGg0=; b=VnJXD7ohnmNVFjFuAgXxzpBzEhfX1Gi3jf
	rsEDf8OXGurf3z0Tb/lJ7ZU8qROWm1pS/qRkoSZbF+WZWBCHijht8d6pNLp2RyC5
	jF7UuLBLwrqPVUsiJXNhiIOFvpN1atLxYZFglMzyqzTD1P7o3VZAUF8njm8ryh7V
	/lMxLvuG/Jk/HLmky7sGBovfjX0RMoZ0vqBQ6ilUzoVDtHVmsFc1K3dQaWN1qBU8
	j7x9riErn1yn1KumjlhWHPIOZc5Kz+JXgqhZ/1aixRT7PSAnr4k7fg16v24bx0+o
	iQ1kgrpOw/BgzFNqGRwC6sKQ4NcFVCzwF/V9o5cfAbktA41Obqzw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp11uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 19:02:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EIbLWQ005708;
	Wed, 14 Jan 2026 19:02:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012067.outbound.protection.outlook.com [40.107.200.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7a60fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 19:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HBHLjr3TDIo0ZM2uBdlz6fD8PUmWm5xF/kX4M2E9k+d+PhrxRTZ6trD+bxHN49F38qhSHVUEiqkFJ64mjutXPfNR6Z93/l5u4e0LBzIc2xSaF9Jz8/LA7fizz+aTn6hnZdjRqIu78ZhPCRyJtyWe8am/Usp5ud4qgflxzLYFThCNgn6PLct2mxKjvQdVv4xdVByu5D+TkUCOcgxN7Qc2P+/5pViHrCvappssF5P9VrcE4SdZZZSFLTjr4g1hhlylsqBGrOQxOr9V/Y8pBb0qKIqRgNzq8lF/Y+RuW8GRI/ZJLG2h6g6kukWsK08nKypyPU8BsnzySOS5l3G9Lqewdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xab8WT48lZ6CS2Z4CmBxsYh22Ma6wNnoWyiTy2rPGg0=;
 b=uZuDjQ6NpB/IBpyFdKJcFm8OBQpDW3jR11nrqfUSmNYOvRWeYg1nDouydMJ7USgTFCMaT0vvLxH+93sFJl116xW1gYG4MtEuiffJ9RDTn1QuHuXa3zypLuPP0vMD9p9CRXL/2wtlcPyL5fUy4VeBb8WJkNpjYwiMn1gb2rYPaM2HBHiCDwinlRPax51UMIjAgUvRiZEwcDkTsp2kXgWqHtWVe5CJM1Ud85i026srAYNDGf09oS3XaWNsutcFF55tSgsheCKwZds7SIRmXih8mgAB5UusDO3YOCz78b0dRuFul7pYnemiKbWKWRbwFgkfGSt9ds5QDF2HwtMigAHDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xab8WT48lZ6CS2Z4CmBxsYh22Ma6wNnoWyiTy2rPGg0=;
 b=fDgKWGBQ6pGwNt1RjeaySKROMetwth9Sa0KH8Djwt9RaADVKDjl44uvLm87wl+EXGsxi2KiE6eS7uAkOQWE6IgLz0LWuhgYnm1B8LV6QT2+zKmjnf2PI4tbMCQMgs3tS5u82G2o7QxoEdKhtbh/UbmkuLM0hgDuMf57FITlJhPU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF558EA2A2C.namprd10.prod.outlook.com (2603:10b6:518:1::7a2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 19:02:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 19:02:16 +0000
Date: Wed, 14 Jan 2026 19:02:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <6fb9d6b4-ad39-41de-8db0-aa41a6406378@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF558EA2A2C:EE_
X-MS-Office365-Filtering-Correlation-Id: 93304478-a0f9-4468-747c-08de539f6f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ga1Un0jlpy581oBDbNT480y9b8Oa/+b8p2FxkjX7tTGfdspmanvWAxeoRXDc?=
 =?us-ascii?Q?N/ffqhLSb7RPvsNl9dZkJ6igm8PHYj1+Xt8gWkLtcy5NRe3lCC5ipEL+EKUy?=
 =?us-ascii?Q?PkLSinRUYMNXTmW+/M4yua5WoUV57KB0lF01Yfw0HXtCZlCZzt9HUwLXrI1u?=
 =?us-ascii?Q?9eauR1Q1l30Ob3fYWqaSYQm3YgDx6E9oD89n1XWmSBfcFBKA1jseloxba0q2?=
 =?us-ascii?Q?lHFUZyzxB+Eb7LL1HM8dB16jqlrD5cVwFtz6puTBWEKNJYrcHFFvap9aanKz?=
 =?us-ascii?Q?mMkSQ/UsfXNFIc49kCs5e0ayGN5A+PJ0kFGhj3JaQeq/yydXn5MkITmMbSyf?=
 =?us-ascii?Q?3pNfPZa8f3ga3+w13zVCdXUv51kd2IHL6daFLAhoUi9gbfHPMhbHJmsy0fv1?=
 =?us-ascii?Q?l/Sn8JGGxkny3SzePSO6PCPo7ii3YwqyIP0co0S5nLQegJxDmiFoZepyhfb/?=
 =?us-ascii?Q?Nv53O6HqqLDZ4rrEFLqyKMjw2SFdRUkP0XkSU6/zh6WMmUer4FyS6YUS2dvW?=
 =?us-ascii?Q?Npw/SLD55yzLvIDpBc0RcltzEEa8XFwqs1Kcn5WpEOIA4BuTrAirl9lER7XW?=
 =?us-ascii?Q?oUgaFNhi9EGd5u72zL91fYiyAEgyLlWWL3pGq3vuc0xrE+yRDr8ICoJIku2u?=
 =?us-ascii?Q?w9LRP2jFYyc7SEshwCi+tKYYOEyh/dCaZvz1CGXNwosqL6AMl+0anYWsQDZG?=
 =?us-ascii?Q?8U0jCSdlXX2uwNTAZo+UE0qn1ifEcb8EPiLCWnjGfDbDu1U3xrU/0gViNRGU?=
 =?us-ascii?Q?bNX+Rqf2GV7f/2L1oj8IIAsTkVRQFaoW8oSu3B8fEao5rsnfBTr/eIgoVOSv?=
 =?us-ascii?Q?hE6BONCfTfohaXtgGTeqPpgoLqf4eOlcuSojHJN2z0GNWdOnh11c3t17gJ8f?=
 =?us-ascii?Q?wQuaf1Walnh9JFfW2vGnsLXRn29CdSu9/BojMsEtTQWhK6m7Q8AUTf0opxvw?=
 =?us-ascii?Q?KnL8j9lLSA3CMX3GRrCUHEUf9xEwEkF0aJqDU4jXRKGtT2iGGozbgJeeOL01?=
 =?us-ascii?Q?s4zwXC52ZEkyDrSledzkSFpiogTEUzctctvEs8MiTeMWTvxXvDjIAp9KmmMV?=
 =?us-ascii?Q?+2BZ6vgPgvQaQIu4iAcJZKPHtlkVM7T2CM7HH7GpNgSRKreQo3QGlASe8Hmt?=
 =?us-ascii?Q?mTo6FR/77ewOxgNsx4WDQD7j86EQfTAggVpB2AyjIDnDR0FPvauYtVvrXZxS?=
 =?us-ascii?Q?0z341Ho2PJg3fsWzMZiv9mYT7yGoGR3ps4PkR5Q5dr/TbjowDWdhvCExYjCI?=
 =?us-ascii?Q?wIbK5am1dgVDIwml3zGzbQaAPrwTRXFaBKkf1Y5hploTTXJolBOSGkMFmrp+?=
 =?us-ascii?Q?NVKMdfP+kOZZ4K7sxG9KECPJjXTvK7YLRux08gQ6MybREDWlXXxyJySuEs4R?=
 =?us-ascii?Q?nNs6nfgIRmQuC+g4nuk5wn+SnSQk5YWWOYxClqf2wOM3J0I6IdnC6Sx+hmWS?=
 =?us-ascii?Q?as+C5yffMk2jFHOyY2D2OwF4VHKf4QVcZn5B5vNh8SX912EbbHB3YBHtt/Dj?=
 =?us-ascii?Q?djIwH4sR5i/87UUrbT74H6VS7HjcA6rlaeDbF4igTvGQdbv8Sy6Irg10jki4?=
 =?us-ascii?Q?LXbUo7YIeRMBONSHKsQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aBqL/hopmOCJM/cdFbmTk87l55r3qWX3addk+GS+YvhtBNGEBg+mrEiu5rJa?=
 =?us-ascii?Q?SLTw28iMsJmmVluoXYxHFJbvCDS6D1FOXQytOlMJ5hdryVelt1uw0e65pBaq?=
 =?us-ascii?Q?ypqL8aYPoPDk4+YmMw3+V7m1HHORqVjhYvN0IXCEo4l1uzCCnmkWSxdj+1b4?=
 =?us-ascii?Q?oMap8Oj+CcQhbMJCpGOxMV6Dnd1KuHrGFaE0aPIFhsGhNR+F4coA0Eo1YehA?=
 =?us-ascii?Q?YENGbFJchnp4qAoLGxV/1v+eYveYu0Hnszu0Lcv3SxVTM8l5zpwcXhpGR09Q?=
 =?us-ascii?Q?b6Uv2dDIiKtohd1m0zQFrUl9JGX1wGcz4RqhHmGf68z04mK3ClEFTm4anMSe?=
 =?us-ascii?Q?yzrtGpFirvTNycZYid9VM+Lbo4O9KZs3K5cEwUeo/kLKL8Zsx0wC8YX6oYvD?=
 =?us-ascii?Q?YZysgujTQi75BCLj//o3G3nNhUxtt5+BJ4EvgkMzMrWpnAvuzq40XwbzwMiz?=
 =?us-ascii?Q?TEx0lk7N8rzKCJ77xMVprcuvHKHjliuKvcT4mAjodunr5HTQPzpDwpSD8GUW?=
 =?us-ascii?Q?JtaVfo9HvHawBK0INoBE5xfw91AWqi5G/xtDo2kHeUZJFb4q0T9aWpHnsbNc?=
 =?us-ascii?Q?NTK4Xbhsy4WVq403U3PdPQGxGv6muhGI4z0ou+4OAGGWMkpzK6fUB+GF/+ab?=
 =?us-ascii?Q?Xfibnm3Kwqh2C8mUhO51biggohX4+Ibrn7SdDyZfIer+qJbfYRREvGoz/W8G?=
 =?us-ascii?Q?uHS4RQ/LsThahM/Iv0D+j+m6xKxaS/wD9BM/+jh+eG0aQyhVRMR+MoHiWN28?=
 =?us-ascii?Q?BWrlmKULHVSq0sPxlA6MCMlj5EFtP1CehTBt+gg6n0buoOU2wqQ+8Z+EjYpv?=
 =?us-ascii?Q?191q/aCBkSbQ6+2gmN2EVBWPKBrH/KXB0y7Xsm8y5rhZbrVgzJ2SG+Xh0jS1?=
 =?us-ascii?Q?vFbAxxTnmdV5PHxpOM7lnMS+vnDsOg3umfmwRtH72sw8kZ5NKQ6ggsecxkL3?=
 =?us-ascii?Q?gm5SxSEPnIyIhRDf6wfzCDaHfVOtZrdzFpDP7vcu0f/rPw6aqh3kn5GDXIQD?=
 =?us-ascii?Q?S1kSns5PuCd1dmKTcp5e4jUFpF58M0SvvmINbgR57yJsPW/Nr2cU4k+AoYrs?=
 =?us-ascii?Q?bZAgS3T9s48f7B63L2yS66UA02nup1CCLCLTYzalytjfcvd9ph5lO1762LW3?=
 =?us-ascii?Q?mUzKsxCrGMdHgUAiRNHi5Laei0mdP5BZkXb315aTldzfWC8QXu93BpKag7rA?=
 =?us-ascii?Q?P5pgMVRmkQ5V3Y5hNsENYUr5VzhzWWx+ebssaPB8hXkshXrP9zPD82aOhD2Z?=
 =?us-ascii?Q?ySJkFbl64U4rwMA1qfoVUjbcedlxxaMfSGbk0yVNmEc36BVxlZ7YqNPn13v/?=
 =?us-ascii?Q?xIychESkaeYvpPN6vKSqklZYLRB+Z4xlYZA/UPNxHAZ/+ijXwAG5RRT43W69?=
 =?us-ascii?Q?NVSCLlkqnShNTDXft594pSokpZ5bbfpflrptxKr3Dqb8eENxM4JQvm+O9Klw?=
 =?us-ascii?Q?/c26T9wikJRP5Kii9BXqehCMxv2mbE8NyrD33+zpqLUu6108gDYE0VK7oUcg?=
 =?us-ascii?Q?eJpNBZ5dZGtihX7a7RR08d05FB9tI0gnWV8nsqIGqL7bjM4IQQj38nUR9lt4?=
 =?us-ascii?Q?RJO1IckbtACtf2sYXmehs8QcL5hHCyWucVK7jkkwUoDn2aKUiru9+PIuT0jV?=
 =?us-ascii?Q?JNkGBpx5v0Ia9d76PiyRZ2GPrBytuHqKAzcbbo3QSohy3QsQjivS3UjHC3B2?=
 =?us-ascii?Q?prKTJpQjvXYfHmhrqGkyW63iU/dfT7YZA9jKKc46gDRrE97l/pUiorKSE1ZF?=
 =?us-ascii?Q?O7Tqx5ISEXvmMfd0MTE6FFTkB65Hqao=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AkjvDjMDXWhk6Eoxi+lAmQpwWWLGp+MwV+dgCYR78NoDthY3axl3D8nAyBa86VCfnPHMCPdc/Ri0RDkMTOkhQ2xDYlbv6ZVsMB7XxNjCD6rOunFC70FEZoPJyFzheiW/4VGz2qbizZJAK0+o6OvU/aQJkoaYH5KUtfFwaL8XT3pdpmnGjoZmABObO2AytPBuvX4mv/P91P0a1Qe2MhHLg+pp7IpNNG7j4mOleJ2qBxXiWNnZ0xjduVzlsfwzucgNmqrC0jeME3nbQy9wI8WFz+bjdtDzBMPMlfjBDdNUsqbYlRB3g+j1S1VLHubvRiwL+zArBGnoYPSImg4qwOgGhURlsbk3o6N5zvvWpVTZitEBIZUIG+zxDMAU+WgLizu0CAk+GEcNMAVdc6qxrR9V6Xyy8AyrhJA7TW/sO3A9kSWHPfIuCdb39iRGipQUUGVqjVgGs9+c9UWREqhtWLZNUN9a7trrO2zuGoR4CRsgcxilKW1QUuyD4ONGbwXxVRc6ZCxzLEE1Wy7YPO9tDM0SRHyyIn3KxR3fYzcKadh+qYp7VsPafIGHxWThoaqYb1hSrsAaqP5I/8GDwvQtYZ+pHXwmWr1tBqpxronLioMuUTc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93304478-a0f9-4468-747c-08de539f6f0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 19:02:16.2503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otv0GgOseZgdUFpQMztx7BXCdrfEThiVZyKPVv4EWWJz+EbapzOedrpGAJhswbUqiPcaPuBaPCXA+Gd3QUoyJ9beYMEqOQhDT167jjjFiiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF558EA2A2C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_06,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140158
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE1OCBTYWx0ZWRfX0KA48856NU4C
 aNUMRNx50Tv06EgkDDYsmYfNJxK+HBUkQ8s883vrdbtH7dfBs6ksoZbnX5LcwipFO96t1rJo8iH
 EQ4K4hqTyskz5RSnRaOn8mzo62iB7FRwygsQD+46zoZfrM1qCP4Bo79gcQb4JThZy/F4GWU9zJQ
 dJErSkeD4ZQoVhrOW8A1JqB4DApu9vN+VW4vWeBsDfTxXYFOVZP032luip2j0LZ5RIa4Bih08QX
 qxnOb+YjwdG1OOI1t7UzGYYlXSYuigCIeYAdL4r8HnAjNDGHLYDiB9LYpip3XHr5ic1pE5Cliw5
 cEjZk96o7X690XYGujK7wFyNfvmT4kZXPsXRzXUKudboWs+IiswAdooY8+9iTa4dmUscubBxTcI
 6j5XdowqIHU17g1WTPET16ViZEVWZZ9MWiSpbxBHkedteF7LNMVE8xjooqd6NKHlCkeZxm0Mh7V
 3nqREJpnQgRp9qZO2jw==
X-Proofpoint-GUID: VsQGxqVrRCM2r-dWcDq5CPFckBrwbx-l
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=6967e83f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=XtEq_HLmtinM-6GzNzAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: VsQGxqVrRCM2r-dWcDq5CPFckBrwbx-l
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01028C0014
X-Stat-Signature: bg6kztrpu9sjenr6ogibwo1itmeaky7q
X-Rspam-User: 
X-HE-Tag: 1768417348-632132
X-HE-Meta: U2FsdGVkX1/mSM+I6RnfQe8wJIdemJ7V5a8eFCJwMYS4Z+bOpyMXvZIILqa7TVUB1UyAzAdJmiAxb4fsS27UKmYioHQgaE4fxon58UZr1ArjViXEPyJuoSU9DK6nvaBF/3XxP8USRkqnLHaK8BeNLRM3c241oVr5ikzklufTbSSoyp2UHwDCWbK/aBXCTWZGuD6/9q0b+ev5uPpXrb975BhrQW1F/YegbxuphxpksINAKgvoDHGpp3PQFM5lDRNv0+vRTwxwCNQQtPaxRD6l8XlnyKuzLmSOtjak6G44T4ohaTsfsKtR5NqUZs+SRMuE68m92HQcOdElUQY6Q1e3FxAwM4DzYizHGDO8eO1e15Wk9nsgro4zpmlikF7ZPp+tqrDuHbrPpPntXsXWDrobUALOsFGnPaGoYHG0ZHh7dUFDKBHQ9kuo39LKpjp6/3nH4YUkD5thFNnWiHt/TN74VvtjcVpn8ThBWUyNXfOeVZl4g2qP81PqGdAO0oKHpz5YGdlbK+GXTEouCumVLwgctWCc5eXKcyy6Ju/uSWXAd41N1T1/c8MnrMhz4ylVdcW0ZuSWCJlEkH/pkBCeEQGT1HdoKnAJaltjeALFPikuF/mForsHO5CoQhKBqMJX9G6KfNfqPlUmK4dNTZb+AfOohnzc7GUEvvsp2z4m+4Bd3crEtktrhDZDTKOXX1EBRMchFUCDDYo9KUf/ULGuTxlKkCHIsXPxCEAXk3hysKs9rF+SBv1xJxYAo6D55oFwryucmfx4V8CgtSil9nBiZVWAyFmeY60Gc4OL0HxNE+lvqhNEa/K8PoDHK7KB5jsivHfWyRmun7re3zYFZ1jNmXAK61YRJIDptAcrJ9jwOkVol/ccxPLCkImeKDavaxDCnIb2oKOhubUQwHN9RvKHPJEuG9VCyjCRCBbsUPsfhmhBXXdpPOjDHWRx4B4UPkkBetqDztYzQXEHgeRnTl7/nOm
 ZFFyr26o
 suW+qIjfXQjNdjwiuAJ/cAWZddGHLO9oXzrT7/d8M+/udaGJHr4b3NbVs24uY9p5D1d1YJwZcOgz1t7a+VQUFE1N6CvtGjn5t+sLfO4LFNu8xcskMQBtLNY2zWTwiTEgQrDHYeZE0OlobC0BjuAjIuN5BY/qBTuNW9mCvSO5Z74HMiJXsk4P338TKk6qHlsF6KTsoSnu6CFUOmxiVgXxnVimr9jCelz9mAM6jBz3/RIJRWBbCwLqyvORGl8IL2KmMBoX9mzWLICwnf/YMv7pcoAYZmBMMiDs31xrMVPA5WiZ/PRWi0hMRJEGlxiraQq2GkdwOBMzzjSy5O86S0/EA+ZO9UtTNZ1z7Zw238NiHohZyn33/P/gMGHEFz8fn/Tqmve6OiSb4rKLrkgdTxZENTB0LvETOuDEQOlttZtN8uys5sbmijYWjCfkkftuAU8R+ule1JpdePRFzfSxRViYw6sqvFhnyBgrJn7fPHlT1zVNwNRm2lFUsgEr4kxb5obi635oiw9jf3wdnzSx4XzZKyrJE1Bmi8M5NBkGSOuPNexvNhnWS4ZhNHmo7EPJEviSTwwNyw2KTxgdxsGVx+J0h4Oejpwp85fOVJnXQBWsHoU44GTMWR4KHqd5qMhPLhh4gIhzKnu7ijCnxslQ4kAZWnB6K1KD0vmP7LKfm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Can you apply the below fix-patch to this to fix up a rather silly
failure-to-unlock mistake that Suren picked up on?

Luckily this partial unmap function is unlikely to ever be triggerable in real
life, AND more to the point - a later patch completely eliminates the locking -
but to avoid bisection hazard let's fix this.

Note that there is a conflict at 'mm/rmap: allocate anon_vma_chain objects
unlocked when possible', please resolve it by just taking that patch and
dropping _everything_ from this one _including_ the trailing 'if (root) ...'
code.

The change here is purely to avoid bisection hazard.

Thanks, Lorenzo

----8<----
From ef7c7118792b21a4d87b0bf2cee456f3bab92b24 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Wed, 14 Jan 2026 18:52:37 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 54ccf884d90a..0fcc831ce33d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -432,7 +432,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	bool locked = false;
+	struct anon_vma *root = NULL;

 	/*
 	* We exclude everybody else from being able to modify anon_vma's
@@ -444,15 +444,18 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 		struct anon_vma *anon_vma = avc->anon_vma;

 		/* All anon_vma's share the same root. */
-		if (!locked) {
-			anon_vma_lock_write(anon_vma);
-			locked = true;
+		if (!root) {
+			root = anon_vma->root;
+			anon_vma_lock_write(root);
 		}

 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
+
+	if (root)
+		anon_vma_unlock_write(root);
 }

 /**
--
2.52.0

