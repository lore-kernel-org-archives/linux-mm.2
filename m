Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782A7CCF2D5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 20:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E266B0093; Mon,  5 Jan 2026 15:12:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13646B0095; Mon,  5 Jan 2026 15:12:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B047F6B0096; Mon,  5 Jan 2026 15:12:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96D796B0093
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:12:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43A26160276
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:24 +0000 (UTC)
X-FDA: 84299007408.26.AB2C627
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id A463B1C000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ia10IIwR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jN7I+EYJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767643940; a=rsa-sha256;
	cv=pass;
	b=HmWAF4aZOE6Kx+B6GrIQeNaKEmy/GPQvjYwxjK0yHGiQIfhCf7zZblCXpNamk4HIAV9ihq
	/JN6j4JDt4i+9ol0vTzQLvgnOBjFsfQkHX4KvOfkKcmJNP6MgeL/TaQw4ist2/+K2A6GhM
	U31rxpOFfuseReVPPYcKfCpHU2055mc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ia10IIwR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jN7I+EYJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767643940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxNjAp02nN0A7EXAOG4X+BjeL3/JDUB7pNilbHdihXc=;
	b=42gjSNGTXOISfOTusxgnW5Rb5Z1UcCEc3V0HodS/LixmL6d3RVmvXUQc6fLUcY1f7+dZqx
	dAlh/YNuXW3dc9YhPpoxj1BL/B+dRGsQYDvT7mtZYM+FZ1987NIWmXkCR0nenZzjH17Klp
	3m2UOTPsnjNOs3hOO4sbHmCwe5NCYV0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605JpoYK1920794;
	Mon, 5 Jan 2026 20:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YxNjAp02nN0A7EXAOG4X+BjeL3/JDUB7pNilbHdihXc=; b=
	ia10IIwRKZ/IFF0kJOrqeP5GDQFhQTIjjfFI65WI6fXoma4exBltnJGUkaxGqqAN
	KkdZU3K1KnG/aFbJNXXQp6uIwTkcOLO6t2fGp5eRU24zzYsw3eBNdOF0OkDc2hfb
	q84Uwqi5hUbXSn+LsxBTSm51f78LPML74zcKd3H0g8rADf2umVCFgghGj3afnKn6
	p7RjhAWrNo17GiTYRJWwirwcVvlSVWiqAZr0TqcFoo8RENnp5TFPnSh1hv2tE40/
	5edMBdZTwNZgTqIdQM+deYDdEz5o98DQZZeevtUtWYn9/KmzdlFAO1dJgriJ2ej3
	bh8ynOu7ZuuZISYWfcQU6Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgktm80ww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605IcXSa026313;
	Mon, 5 Jan 2026 20:12:10 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjj1t79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HcRtOyTAGcZIt9He9tnXBmTgCmvspnmJIg72wDAsgMm9AbuGSCg7MWzy+60u/soqA4bF5J2AZefIK1oF+YiW8XLDNB8AysudFPM0K/d1fhewh3q6tGGti1avZIu7SapcXtMK9ibXhzfaUwOkf1IkS4In4lZFvNUp7osP6x6gsvA9uuWAJLuuGxvuon0fF8thLNlTj7l4F3gnOtwcOFJ3+emYBjKfm5j12mTO3Ras78dYdKUl3x+NiPaegKbXtXgGGxmeamaArQ+udlsnS2DwJRhZZPLjwdZIZlTiiAyWcp4lDoikBWtYdhf1p8pX8vOX1KMEKKkgRegpzWjk1zdiSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxNjAp02nN0A7EXAOG4X+BjeL3/JDUB7pNilbHdihXc=;
 b=CVxan9OIyuATMBnIFVfw5wGFF9rQghL2qMZEVve68cEDPg3g1X1fyM2Go3ob75G1lJdi+S28hg0sXwtUW91dwHL34RSmaMiCZb+rv5UL7bbgWuk88ylb/+ruIdW4lAqjL82uzO0Uymfg96oqJTjJqf/J9l0W2vy8J7DmLBupZlZ13gQi6r9sWZYAeJDFLFqOGyy2pS/zAvUrbMWFOWEARaf+TRoyVLo8jdZcif2GJDASRsyLr/38h37TnVtOZpKM3N8jphyamcTkhAm95yvQM4bzqvrXCKZPWSzc5T9PmXmZBRDlyaaWg2K9irDvOuYbWsjWPVomVewJotN/kEWZ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxNjAp02nN0A7EXAOG4X+BjeL3/JDUB7pNilbHdihXc=;
 b=jN7I+EYJ0CTv9s/dcYHTPfoOT5KiPvpmNsFpUry1RU2rwF10yy5/SRTd1JFU83AwtfvipTzX52ullNaZr+lmfz9eIPq5ulkgTr95dGFsgtoyeeL94qNhuVEQVyeU6Cn6Sf/WoK7681/Kl+NvzrQ+JKG2C9i/agk3j8dMFKJzMBQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7077.namprd10.prod.outlook.com (2603:10b6:510:286::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:12:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:12:06 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH v2 1/4] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
Date: Mon,  5 Jan 2026 20:11:47 +0000
Message-ID: <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0330.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: 3316f6d6-b6c2-48d1-e828-08de4c96b293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lQkyYh4UQj776SPfh0YMyCe6W99Uwh2Sng+HdByiD73vmf7AFavIDRedR+lV?=
 =?us-ascii?Q?S3dPOB6WYLEJWF0yvsCvrAsF1JZf5sP4uIoGhtqAtIHw11m2DqqPKPnFZStC?=
 =?us-ascii?Q?LhcpEfxxHcCCM5ICl9uagyNZhGwoBmE6e25HD2FdOIsR2YbdSYoXOBYPe3e/?=
 =?us-ascii?Q?X0ibchCei2laMSUmFSYBXw2124a66uQluJhNHrPT+sHFV+/BjfUnNZcEIXhA?=
 =?us-ascii?Q?jpbkMobhhjLoKZjErWW8OlG8Qc6ABoQBHZOt5lHrIqd/bZYkgJKwAoPVj6eb?=
 =?us-ascii?Q?0Tzj2bM5Wd8ZxjRHmaqfBLqH6OvONeVxf0V7BGyr6aiIreM9kyS3RdcIWuQO?=
 =?us-ascii?Q?X1JyqKlyPJLoX1HupQNyUiAjt3IMByEWVkNsdAXDVtnSAMtH5sHHMgH5uHXD?=
 =?us-ascii?Q?BnHpGAiWzzAB1WxYJx/t9IrBButsrfQCx4XYwEdvRhbIcbLWipSyyTgseAYz?=
 =?us-ascii?Q?64MhQOGsQ7/06CFU4+8MvRMA0G5ofH3lLnGg9hFaRgSH/XjQfa7S7C1GHa0F?=
 =?us-ascii?Q?V4Jln1+G5jkZ309gvQJuKReIH30Y8UQLnTO15pQXQp6mhVTPC8ZXjYxgKNHj?=
 =?us-ascii?Q?6TstCwjIofu956Edhnwc/mT+60vkg+VFD/F8YFrobOewuZ9cS37EfVvrk0KF?=
 =?us-ascii?Q?wa8gTrLNKEhs1DAzEuaB9+qk+GxPybw8Nyrod903jHhT7FX7gC82Ys7GZLeD?=
 =?us-ascii?Q?aNirhS1R7AO3gbexYzBwN//Jc4omEHe+wLd/9uFkrCvogS6OVOuRyruU+/Mk?=
 =?us-ascii?Q?bDRiMy9Qz8LMw6EIvFgthoWHIvxh4BhzhEi2dQ2+1Pbz6EQR8o7tkf51s6jM?=
 =?us-ascii?Q?k87f3RCKoddcmLA5Z0LcPEm1V4SZ3lxhiKDhfPJ82Dnf25rvIqGSJB/ETjIR?=
 =?us-ascii?Q?0SRUEazSwzRWAa2xGELuFLYB0YB2Sq1ie2rOPNustMH+HW32XL/nRjXkMp2v?=
 =?us-ascii?Q?JxDchkOSuJS5gUVH1YpaIK1JpOibxm28VXNazuXV2xkRgo/yrZMo+5YZQOvs?=
 =?us-ascii?Q?/5CRE2C8pJ242Ke50vDG56v5bmzyyVzuVNzpLMEAgtYV0Fcui1AETLjklOVs?=
 =?us-ascii?Q?6RLyoy+TSIo4ZGIEg7+J3jpM2eUhZiylnC3s/+IBuRuQ/55BCz2KHuMp+td8?=
 =?us-ascii?Q?6aaUoliEz0DL16DK+G5+fidvHnaeSe5497c+pnOiccskHI+jDxz3wskhrcYE?=
 =?us-ascii?Q?LSNffFPvbOBELpRjDehiIGeCB5ZmSCybd0AlUTpbTDw5ajWuvaZ2ZJljplk+?=
 =?us-ascii?Q?lkDR0T/ckOgplAIQmyN8+UFWW7aJsBPVaLrWK7MvY5QcMEtLpxVJ2z8uUIYt?=
 =?us-ascii?Q?+AWkvE6BA2f8OsZGYfH5BvYb0VfqSG66lcRkK42ywQPHFXm6HDrpQkX0G1Be?=
 =?us-ascii?Q?nJvpR1Y+pv4FQrhl/cR8BHnFIA3Dv9YH1hkUXIuaBfRJUjjMP/LGUdH8A9K2?=
 =?us-ascii?Q?1CgODs2SoflGfg1H547y9+SYxp0Muc2iewPATeFvKOWc6I8XVOfiFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gv8R4+/eBWIZAI3VQ9YyOUyocHttmgInQaggvOESPlZKpdZyjVpPklFLn0se?=
 =?us-ascii?Q?WYpcJEMc81agH0z87fUtsDE/LioUwGbYOUzLgj7GGHqdTTumlTaB2xD7HD+D?=
 =?us-ascii?Q?xdaR04LpX58YzEP6P5aXZOoV9x72u6A9vVhXLCst5RTevWu98/hRJ+xM4TKe?=
 =?us-ascii?Q?UQOKPhGHhIt/R3sb/c7D9gLkR31DriRyWnf8yPCZVtsuHbnNcZON8PnmoaAz?=
 =?us-ascii?Q?HlunbxmKX2BP/1DUCshNVkZAqfN5sftGahBUZuB034sux1p0mYGkRz+mZY6l?=
 =?us-ascii?Q?zoZUEwoD0w9stNw/zXOdbtM8TLA0WqtoS83YTJo47rajq4A6xhKZ4mZUHHFs?=
 =?us-ascii?Q?zDnxRerGW4BMWMU6Aw8sJWIP8mnxhzK6ryjJ0Q8hFXmyIfARtKDYNQarudSB?=
 =?us-ascii?Q?zVcDEeJ1SurixwK2YHlmAxp57NzXll+8Xted6BuurBwgQpL7cmKHXqPfhhmD?=
 =?us-ascii?Q?b9L1f+MIsd5EFFd0yuNLNG7PIAeVOrDAm4/JnR01dGCsIs1yO1OJtGVap9Zn?=
 =?us-ascii?Q?9Ig75i3C//C2PbQpt8xmng3xY0NadTaJtGq1ZNzUCqo++GakO4XakH9juFle?=
 =?us-ascii?Q?/4xX9W2H8QywIUl9/IiIPYup7NtKqPj8wmrHoYdmUr4LEXI+AsNejh95eK5y?=
 =?us-ascii?Q?vnzWVD6xuX4YN3tO98ozrvfT7MLQv8J2NC/qdEPorXLYxMvMTl67jVSvR+hI?=
 =?us-ascii?Q?X+LT+f/fHXBmvUFlDOt0OpMAPWKCteXi/Yf3OfgnBjP6/zduZWGHkKYjFYuw?=
 =?us-ascii?Q?4DaZDQuYUHwuiJQi6ADmYSMx/EuZWREHKBPiuVEYmWYEWTGkmDA4i1wlduAy?=
 =?us-ascii?Q?QO4hu94o/pJzn57x/cd4hMYzS/GKPTzbdUrKkkeg7c8+56sGUnxrr0Udah1l?=
 =?us-ascii?Q?RzOBoRI+NcEIy+67X30VQfEd1BXyBfGyg8u/14dwHXXHaL4WDKvnmQHbGg8l?=
 =?us-ascii?Q?O93aICCVepjbFFf5sXIwH7IcyEourbd3Hx4031CVFYlHcfJl7+eyOna1wxyz?=
 =?us-ascii?Q?4Aq6X6Km9qkU/5zFaHEfKaLwQuK4wtDPFSN1XWhmYZeR+2CekcMDDOrmmI0W?=
 =?us-ascii?Q?HpTdTJ1moSJqinkTUoB6VJcbsEJllB56nuRP5hksRHdhvJN9LZkbHfd61G7E?=
 =?us-ascii?Q?UtRizCfs8IEnYyMXnBNdMYRcI1EsChgOU1KLkDP7uCwnuGzS4KUnKnHX4F+7?=
 =?us-ascii?Q?aspzK4cDPx6P+ZNgwW4CaPFeHtBOW8GflIKSCImsoi5VWkKuuTej0R468ul+?=
 =?us-ascii?Q?YVMMSOONUFb1sFT7YZjFZ4PKS0ceoA89/R8WoIl5yejLn3lyh7KbRoWKkGDn?=
 =?us-ascii?Q?4S/JM4rPAK/Bxxp3WkeWIPNAEPWcBVLY/JZvkEUkJSKxRcmh4ALngGQ0Ju9o?=
 =?us-ascii?Q?m7ZQ0wSNRYUKPkHFzXDYlLYMLkr8SlXVtlenfmqHJZ4JzuN/nZfsnyG4udeD?=
 =?us-ascii?Q?xRIMaxWvO3HBqRu3LukZBdnzIDgNDYQihm0nVsvToYO5x7ziTgoOWGW5N4Il?=
 =?us-ascii?Q?w05m59jyg+gkzWHbPzFd2Nw6WzLEVffXnjRBfGvg+hd+XyS8T2WszAF9UTsY?=
 =?us-ascii?Q?Riehi+eiFFvUZh8NQq0J5QvPBVRSF4kDKBWYu8S0lti/MOUHn0dhsCei6TqH?=
 =?us-ascii?Q?Lpe5/+5/0TI3YxH81dPhq/N4oJOBBPwxo9jE5kC09hHVIxyZbkCSIqGk3iXP?=
 =?us-ascii?Q?U0LvfuZoOUKVevkd98HTssNw9Goam3mifqHXrYTk1Ur/DGYpmyAP5cdSZHSG?=
 =?us-ascii?Q?wnbuhNRobDi5XegaQJjOfKNG5qH0n1A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o6TBx1fPRAfufWNvLDq80THLXEzKVlu2GSJMpcw432n6TIqXv34hXC+h+KatBVNYBdLN/GsJB3wJ8CaGXbxwnqx+dwGI6EVBiR6AGLCBCPq4rsCVlc2ifnpNYnkqa8hCKAanorUvpZCrikTa77TbK8zNxFX5/Phf4J2YaKA/speSIlUNu3sRVT3Lo5PkYnm/TaswjPb8IQ/bPlTYW7XVyFU5VJXrm2PXD2m2IDqWomWGsAUOtmSQwSg/5Dc+Gv6k6oqtJhn63oasKa3nv1ltdmsb2elhfjzvd0kH7PdAFXOr0hr48/4ybtKSk6DcFPHoTEF/O6jNeKYIMOKqPRUwtbQIhDUuEGGFx4hMMLBd1Alks8E/7SZE335rTIwdAEdsxdOuNXPJENccM2JZak68+treeIbSIASpUI/i2qZimwO0AcAxjf+WUYMANuZ1JbtXZ9nLHXNVot8WVLT2pQyuLPEJg4V0CnvK5ifmWbLPUvXolE2ECJv1yFud+Bhv2UPdVe11GN/dGQvpOjZUtvP6Ozj3Pcu6AmMPxDi3AS/pH330VSMFPWmfjoE/sMcAH1ulLs3Fbyvpi7l9Ll6d2mw0yy8GLbs6OffWLuOhv11Pr58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3316f6d6-b6c2-48d1-e828-08de4c96b293
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:12:06.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XsMlrdCj5CtMoJHnEAMFywaEQDGb/imbs7+4A61aqTocfzNJO58UvHMP0eO7KwkmEYKK3dpna/fSKpGInok2yCXYrIzuU9lxehBvINe+bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050175
X-Authority-Analysis: v=2.4 cv=RoPI7SmK c=1 sm=1 tr=0 ts=695c1b1b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=PW_XkhgRYGIbnebEDp8A:9
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NSBTYWx0ZWRfX9PDHViksvcpu
 qL/eUpCHCyZSSOLdSRJ0C5eJJBiv4CmdAc6NbV8sLHDbJFf9AI0cjVqq8ei6NVXJvIy50OelLW1
 tQ4v2CpUdKZNZOw1XUJgERUSVZhSmaunPvqB6njBeSYAvk3JTgwKqHFogMg7W9jFnsFue+/t/Ma
 eQnoSfyS2pSHiKITihy4A/lRs8sdMoZNrybRGwCkZv2bgYHTVBnE0jOXjk6gfafw3vfuvwElAsc
 tIFZougFXpEGhJT7I+ncgGtCg7Vcu6RzzSy7/R2aS3+oO24SQFIKOA3n6VktR6vmoBqYS/4nfBg
 Pxgi2gkB3jb2WcFnsUF75WC/JTco3okCSX7gPxcvt1/MkTgwEs2p8pW/S/31LdisPuTfR10OC+8
 SPoUJtTajBnsLSFavj3B2PLfP4gH6DXiyyao9PCkadW1mLVqNs0tMGv1GRe7pCOn2YApT2CPVv5
 eJee8dsMCPxlKFKE3R99tkhXA3uvOcZfmQICXGGA=
X-Proofpoint-ORIG-GUID: 9NNrnBjMleGsNSvxfgwXoiqlF9hb83Df
X-Proofpoint-GUID: 9NNrnBjMleGsNSvxfgwXoiqlF9hb83Df
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A463B1C000B
X-Stat-Signature: w11bx9tb7uurng7dcfzjiqgj6cppiy1a
X-Rspam-User: 
X-HE-Tag: 1767643940-398985
X-HE-Meta: U2FsdGVkX18mkqh2v4OwxHmZlK4hFGGWnaw+T4jHZXZmEtMm//Gw4574Q4RVqPOCkXkwlZGwxqUhqKUkZ9rIYk81Vd/Kazz49wO0MGQr7BT7QJ0SOSSpIsNSREhxm3aPh9y9bZOezIxWQTyviS+R2b3JR/O/F0tl+bKv1wsgCBHC31b519Y6yoIeCIAnzqFEUc4Yp4mcO4XMc+4xC1NelTBP2cQPe09Znh1npScqivG6TvEIAhf7zg/ngYYFiTk31XDlicYSD2Hx3vPRlN3loCfnoT0sONDEgzwjshcsnwx7nsUp5GHKXoHh7FVeUiMTfN/YCOZeNTlWtN1Sx2gt6odEdEd6Py6JF+gLGJ3H9W13RuFf0CI67+vkcCw6jUSL01Xpp5pDd4+muMyesvHaDq2hE0OrBUirGr+7huVT0/O5WqJ6mQJmGCp9QrHxxCw5s4P/i1GQ9BRCMOmKPAFKtFX4stM9enQ0611kIGmxdi5EYFI2JVFAmdN1+M/KpOi7gzb6qY6el2T+JVI93vzLCfoJLWLFiDNVyIcCSb4vcVl253wGZshqoeRIBE1TJzGHGi/mgj+G+FG7Scaieqlwetz8GhJ3jZoWGw55S2dT8ebOVMn8QZmnkdWoqB94hEPgMxZ8pRHy+OiOZmGUx23AJZH/e1w3ML4pTBssd8NIHIoCUsr+L3eiVM2e6TbPCJ2kstr5P3T16XwPgjInBU/nqO8Dml9ZJObDt4agrlAG1KEI7jfw/VN9hdUkD0QUT5GlaOZ6bBUr6XYwNEETaqXSyyEBv/trPgjNgHIU3TPY4CdN5xSOtbwnpHWWVg4vkq2VusNTswClTLrMdbydp/lEPyAssdgvmXQ5E45DprHhxs9z3GWdoNpak4LCKvxw82Nfmmcg27DW4YlgchXNHhIdUvw//J700PwTxSHAnazRT15jxf4Tn8yEXp3ZE0zNjswCtYEkf2Q8F4gnWaI1IJ8
 p2zY9hXg
 Wav+zcY7fsA2Tz443yIxypOjPlUEy1+NPOQiFuwaqgM4XPsp3xdh4XpcHan4mibkBTh99kDJUouIDv4zpLZpif5KvZc1E8oIJOn6IAVLqQFxFdPvzzOMrCMrS2/Puc5cHveS52FZ6zW5cAk2TmsjvMlQUKzbkUkfDjw8s7+nz/KrOiCmnMuUOYTiQKKRxeBReoEN+3UlvjCoiyePkHbn6+3KUC1MWSuREQOp15F2fqhK8lgEPVjGnIKHzerUe7SZud2KY/bcopymoeWnGvWlgtSHivbPbikHR8+8St0uCTsp1gQXCrwJB5mMdRCTN1dmB1RG/ZH+R4KtNFaCNHaNrDte2xZ/ElPf/YptjCDLFVVxUsTglyLJ5wnDSjBOWeXcpy2ZahnWiS1w4D7AYFA5nwiEbAImDhqmnpZeLxdnS+tWEf21B9tCs8VsmywsjYm7fOC/iUF6iiwN9xo7Zhsroc5Fo/x1syt8VhrhNeUXDT4kQ1hi+lJf6TstbrW2THn//ra59VXweg1k115N/uKnrUJCtqUOgK4N98Z31A43eNOpFHRSwsgfN7mtz+4ij1Oe+cfOxEbL38sGW1wO+tt24STXA7fPEeBh2GKb4i+rvBlSRUrBM+cZfZ4IMUMkVbucWbJBIeMbddeG+4lHQGaXr/Gqyvo7dNAztCztevkw4IwvXJeEjPWgpLD5qNlFCw89jKWxq2RLaXrc5SFJPOrJf8HqYW/IBs9dvoW0mSJIZnGF0rJ6ssyP+yB+K7UYXO8WRbhWO7dR7d7GMw/ynxpepLlz5wOkrrY09l5zB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
merges") introduced the ability to merge previously unavailable VMA merge
scenarios.

The key piece of logic introduced was the ability to merge a faulted VMA
immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
correctly handle anon_vma state.

In the case of the merge of an existing VMA (that is changing properties
of a VMA and then merging if those properties are shared by adjacent
VMAs), dup_anon_vma() is invoked correctly.

However in the case of the merge of a new VMA, a corner case peculiar to
mremap() was missed.

The issue is that vma_expand() only performs dup_anon_vma() if the target
(the VMA that will ultimately become the merged VMA): is not the next VMA,
i.e.  the one that appears after the range in which the new VMA is to be
established.

A key insight here is that in all other cases other than mremap(), a new
VMA merge either expands an existing VMA, meaning that the target VMA will
be that VMA, or would have anon_vma be NULL.

Specifically:

* __mmap_region() - no anon_vma in place, initial mapping.
* do_brk_flags() - expanding an existing VMA.
* vma_merge_extend() - expanding an existing VMA.
* relocate_vma_down() - no anon_vma in place, initial mapping.

In addition, we are in the unique situation of needing to duplicate
anon_vma state from a VMA that is neither the previous or next VMA being
merged with.

dup_anon_vma() deals exclusively with the target=unfaulted, src=faulted
case. This leaves four possibilities, in each case where the copied VMA is
faulted:

1. Previous VMA unfaulted:

              copied -----|
                          v
	|-----------|.............|
	| unfaulted |(faulted VMA)|
	|-----------|.............|
	     prev

target = prev, expand prev to cover.

2. Next VMA unfaulted:

              copied -----|
                          v
	            |.............|-----------|
	            |(faulted VMA)| unfaulted |
                    |.............|-----------|
		                      next

target = next, expand next to cover.

3. Both adjacent VMAs unfaulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)| unfaulted |
	|-----------|.............|-----------|
	     prev                      next

target = prev, expand prev to cover.

4. prev unfaulted, next faulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)|  faulted  |
	|-----------|.............|-----------|
	     prev                      next

target = prev, expand prev to cover. Essentially equivalent to 3, but with
additional requirement that next's anon_vma is the same as the copied
VMA's. This is covered by the existing logic.

To account for this very explicitly, we introduce vma_merge_copied_range(),
which sets a newly introduced vmg->copied_from field, then invokes
vma_merge_new_range() which handles the rest of the logic.

We then update the key vma_expand() function to clean up the logic and make
what's going on clearer, making the 'remove next' case less special, before
invoking dup_anon_vma() unconditionally should we be copying from a VMA.

Note that in case 3, the if (remove_next) ... branch will be a no-op, as
next=src in this instance and src is unfaulted.

In case 4, it won't be, but since in this instance next=src and it is
faulted, this will have required tgt=faulted, src=faulted to be compatible,
meaning that next->anon_vma == vmg->copied_from->anon_vma, and thus a
single dup_anon_vma() of next suffices to copy anon_vma state for the
copied-from VMA also.

If we are copying from a VMA in a successful merge we must _always_
propagate anon_vma state.

This issue can be observed most directly by invoked mremap() to move
around a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
specified.

This will result in unlink_anon_vmas() being called after failing to
duplicate anon_vma state to the target VMA, which results in the anon_vma
itself being freed with folios still possessing dangling pointers to the
anon_vma and thus a use-after-free bug.

This bug was discovered via a syzbot report, which this patch resolves.

We further make a change to update the mergeable anon_vma check to assert
the copied-from anon_vma did not have CoW parents, as otherwise
dup_anon_vma() might incorrectly propagate CoW ancestors from the next VMA
in case 4 despite the anon_vma's being identical for both VMAs.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
Cc: stable@kernel.org
---
 mm/vma.c | 84 +++++++++++++++++++++++++++++++++++++++-----------------
 mm/vma.h |  3 ++
 2 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 6377aa290a27..660f4732f8a5 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -829,6 +829,8 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	VM_WARN_ON_VMG(middle &&
 		       !(vma_iter_addr(vmg->vmi) >= middle->vm_start &&
 			 vma_iter_addr(vmg->vmi) < middle->vm_end), vmg);
+	/* An existing merge can never be used by the mremap() logic. */
+	VM_WARN_ON_VMG(vmg->copied_from, vmg);
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
@@ -1098,6 +1100,33 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	return NULL;
 }
 
+/*
+ * vma_merge_copied_range - Attempt to merge a VMA that is being copied by
+ * mremap()
+ *
+ * @vmg: Describes the VMA we are adding, in the copied-to range @vmg->start to
+ *       @vmg->end (exclusive), which we try to merge with any adjacent VMAs if
+ *       possible.
+ *
+ * vmg->prev, next, start, end, pgoff should all be relative to the COPIED TO
+ * range, i.e. the target range for the VMA.
+ *
+ * Returns: In instances where no merge was possible, NULL. Otherwise, a pointer
+ *          to the VMA we expanded.
+ *
+ * ASSUMPTIONS: Same as vma_merge_new_range(), except vmg->middle must contain
+ *              the copied-from VMA.
+ */
+static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vmg)
+{
+	/* We must have a copied-from VMA. */
+	VM_WARN_ON_VMG(!vmg->middle, vmg);
+
+	vmg->copied_from = vmg->middle;
+	vmg->middle = NULL;
+	return vma_merge_new_range(vmg);
+}
+
 /*
  * vma_expand - Expand an existing VMA
  *
@@ -1117,46 +1146,52 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 int vma_expand(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *anon_dup = NULL;
-	bool remove_next = false;
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
+	bool remove_next = false;
 	vm_flags_t sticky_flags;
-
-	sticky_flags = vmg->vm_flags & VM_STICKY;
-	sticky_flags |= target->vm_flags & VM_STICKY;
-
-	VM_WARN_ON_VMG(!target, vmg);
+	int ret = 0;
 
 	mmap_assert_write_locked(vmg->mm);
-
 	vma_start_write(target);
-	if (next && (target != next) && (vmg->end == next->vm_end)) {
-		int ret;
 
-		sticky_flags |= next->vm_flags & VM_STICKY;
+	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
-		/* This should already have been checked by this point. */
-		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
-		vma_start_write(next);
-		/*
-		 * In this case we don't report OOM, so vmg->give_up_on_mm is
-		 * safe.
-		 */
-		ret = dup_anon_vma(target, next, &anon_dup);
-		if (ret)
-			return ret;
-	}
 
+	/* We must have a target. */
+	VM_WARN_ON_VMG(!target, vmg);
+	/* This should have already been checked by this point. */
+	VM_WARN_ON_VMG(remove_next && !can_merge_remove_vma(next), vmg);
 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON_VMG(next && !remove_next &&
 		       next != target && vmg->end > next->vm_start, vmg);
-	/* Only handles expanding */
+	/* Only handles expanding. */
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		       target->vm_end > vmg->end, vmg);
 
+	sticky_flags = vmg->vm_flags & VM_STICKY;
+	sticky_flags |= target->vm_flags & VM_STICKY;
 	if (remove_next)
-		vmg->__remove_next = true;
+		sticky_flags |= next->vm_flags & VM_STICKY;
 
+	/*
+	 * If we are removing the next VMA or copying from a VMA
+	 * (e.g. mremap()'ing), we must propagate anon_vma state.
+	 *
+	 * Note that, by convention, callers ignore OOM for this case, so
+	 * we don't need to account for vmg->give_up_on_mm here.
+	 */
+	if (remove_next)
+		ret = dup_anon_vma(target, next, &anon_dup);
+	if (!ret && vmg->copied_from)
+		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
+	if (ret)
+		return ret;
+
+	if (remove_next) {
+		vma_start_write(next);
+		vmg->__remove_next = true;
+	}
 	if (commit_merge(vmg))
 		goto nomem;
 
@@ -1828,10 +1863,9 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
 
-	vmg.middle = NULL; /* New VMA range. */
 	vmg.pgoff = pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
-	new_vma = vma_merge_new_range(&vmg);
+	new_vma = vma_merge_copied_range(&vmg);
 
 	if (new_vma) {
 		/*
diff --git a/mm/vma.h b/mm/vma.h
index e4c7bd79de5f..d51efd9da113 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -106,6 +106,9 @@ struct vma_merge_struct {
 	struct anon_vma_name *anon_name;
 	enum vma_merge_state state;
 
+	/* If copied from (i.e. mremap()'d) the VMA from which we are copying. */
+	struct vm_area_struct *copied_from;
+
 	/* Flags which callers can use to modify merge behaviour: */
 
 	/*
-- 
2.52.0


