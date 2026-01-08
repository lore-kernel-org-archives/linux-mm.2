Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF253D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC7E6B00B1; Thu,  8 Jan 2026 12:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA376B00B2; Thu,  8 Jan 2026 12:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302E36B00B4; Thu,  8 Jan 2026 12:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7256B00B1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:58:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B747A160259
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:58:36 +0000 (UTC)
X-FDA: 84309556632.12.3904C3D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B4C3C000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:58:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BffLGT6K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DiO1HqOo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767895113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUQpJUFSkHTcswjfSnoO7OdhHZDBMcxS16+YHzB/AJs=;
	b=rR17soLZC9WKipj65aWkdOO+1GLD8GuYecK41iqgXdzQiA6C8GBa4Zm4CHlGSI4WwOYgFQ
	3SO0gmkGVJKm3LEDuGSJVizEAdzMz4bPQc5OG13/jYofn0sjTSi//4OPLYNWBMmeU9xmbW
	HjjZ5HKWACocsmuwYsQc+KaPpzLAzhg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BffLGT6K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DiO1HqOo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767895113; a=rsa-sha256;
	cv=pass;
	b=DAkPBAVgHjQpFKoZCSfc32SoNsyjmXN5YMmJ0b5alMlp5SVv2jrsgYgpHmcbbxOICr+nz7
	IaaeGtJIvd7sLJjbvzC20ON+X3hV98R2kenkrmSh4JxFKbR2E00Ni2482vD9UjSjWXax5E
	6EnN4SBDLGefdcuHFiPJoUNx/26P5QM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608HaILO804821;
	Thu, 8 Jan 2026 17:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fUQpJUFSkHTcswjfSn
	oO7OdhHZDBMcxS16+YHzB/AJs=; b=BffLGT6KDCqo/+Ixvtxe7TEI1gXh6EWjju
	APYBqG1X/RnneHmxOlDJCwibXvq0E4GiZO+AGlueDIYDxucQKym9P96ouPDk0nE8
	8n32nmUiYO3X1JAIK4JA0/tOgWXeauzB9bOKr832PeGIsMAuThQEqEstBuMlfdh/
	IlwZunCghKZrYBypG6FYhT1kvlvHcyMuDMizCyXLfLysTEiFArj+FWfzebox150y
	YkIWxXFJvkeFIV2TFy+YN/WPxaLWrFtz6+C2rIn30/MPDAiL9opv7YY9mUFn2t4+
	oRlmdhBr0VUJrMDk4nAoKUfaTkSXAjoKIbYMEzXXiKJyo+ho4yqQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjh4hr10p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:58:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608Gdgrf001128;
	Thu, 8 Jan 2026 17:58:26 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjbca0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQd0e+4PC2LzFQ+YCzYVY1+3Agw8/6w8rj647HPFaDyjef+THa+bWlBLtLJJxGG152nvBpOgpsrFd/cbUzPvTYx7/AM4i7s8ZpQUYGei3rDuTwZ9G2bzuiwmyzXmnHCZElgFlhe16dQQoK4Fp0F68QyBqUl+tqJmCv7GcWGw1C5uiue6AN6PMx2RFGPv++b2q0rjl0pFxbbAUnXn6keA8zFmk1HuInaHYIDUNfIIPO8Z8DgblAEl+gp+UxyOC0lPPzYsqnYQ0SoyHwlAeLQaYJctJU8pILBYN+7dDkcOoh9HUEJOF+8sNdKYGm+SRU9l78emLO18JErY4+dT/Bro2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUQpJUFSkHTcswjfSnoO7OdhHZDBMcxS16+YHzB/AJs=;
 b=HKMmlj/tT6ghwUyG7OglowgbUSa6bLsENiit1iEPt+aSoiVzVi354z5X442Lvxlpq8gS1LV/BB8HZpr8pIKmNiz7CjZKjF/fL9DBl8yjn9OA+nuRkiObXUrkYai9V9n5mp742o0bQi8oHxyBAnDnrkSojkGWM57gprW2lNYfG98/9gL8rV++X4fo9R84U/8BfrUHeAPwm54y7gs5uYRAKOAsG5ma3KuDIZBMliX6WVytm6vSsd2ZmkbHH++QHz8bBB5yW7BIi/pNSp/QCVABLemmX42AvOb6Uvn/lOL/hkUUgp7uuyu1nGrFU3ezD7Y9EY/GGEs6J76DGmvoPJnXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUQpJUFSkHTcswjfSnoO7OdhHZDBMcxS16+YHzB/AJs=;
 b=DiO1HqOoSj1xt6+fwI2oglOsQf71Q48IxEKYI4cavKA25C1WvJIVOZBk3K9sO1Lr7ReqHamQrOJfYRVkpIc5gOYD7eUL7wFP6Lo3IAk8rC4dmSqQYUcLowYs1K9YAoH1e8S3+dBg8+UetIlZSd/2Is87yuwpmnmKmM35VW/UftA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB997767.namprd10.prod.outlook.com (2603:10b6:510:39f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 17:58:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:58:03 +0000
Date: Thu, 8 Jan 2026 17:58:05 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] mm/rmap: separate out fork-only logic on
 anon_vma_clone()
Message-ID: <cfa3a126-4109-4e83-bd06-c602954f6d91@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
 <oecut2v62gxlisp24gxgzwzxm3y3kiqcbkrheuxwkwyrb45apl@qtyhfsv34wi7>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oecut2v62gxlisp24gxgzwzxm3y3kiqcbkrheuxwkwyrb45apl@qtyhfsv34wi7>
X-ClientProxiedBy: LO2P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB997767:EE_
X-MS-Office365-Filtering-Correlation-Id: 621891b8-8aac-46ab-e091-08de4edf77e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F+w3b9gjp6nhJ4TGwEC8lxUImi41PWMisH+yA+NbI3cMY1wF5EMFAGWgqcil?=
 =?us-ascii?Q?VZtJl1ZzQx3fFQkQ77itWjt42xIhoiqqRRQtN7/Z0f0IkJXJd9kdFntA/el0?=
 =?us-ascii?Q?dbVmnQNwbwOafhOOKTLyyCJfzAepPnVL48iip00pbFo+ixy4ltZD4mmoDzo8?=
 =?us-ascii?Q?4vG0PCzQZCYJDXSDpcsbdJmpfqCe/JKY5koPUplhAZLMJSniMNZxnyhMD1PL?=
 =?us-ascii?Q?PfdYIiOODYsyLtmE11BB5NVQ0On7YoQG9M147/StaJkY3nygNrf92n7jqjq0?=
 =?us-ascii?Q?PwAoT57JM8uiF86CBycDFUiX/U7Xz9p4F4Wp7wKQw1FYTyjSg2qU1xPYe1wF?=
 =?us-ascii?Q?IBtQobw0QEMEiqFa8/FLj1L+3huW+/XTVuR41RXcfW5bJFaa427/1IIVfbBh?=
 =?us-ascii?Q?vqTxV2PXHjL02e0uyQ2p0Lq3lD6Xi2XprIf8Zfa97YrGhEf+RZrDr2fPNizL?=
 =?us-ascii?Q?rfpLoRohfTLURBeeLIKdxvlDXvjk2PW4nib5dRaLzaW72YUk2LI75qyV7T+k?=
 =?us-ascii?Q?NuoMHlR6QdTGPIggbDSJybTaj35mUIn0Lscubj2ZcJIKVk0mN2oRqtHlGh7X?=
 =?us-ascii?Q?OAVQFDSuv7tkQp5teEDmE6LYL0acVRnlnzrr70e6m/DjZiq1gkwyhXy9HonJ?=
 =?us-ascii?Q?CBwalNXUmihVIWPWDVLQPiGcegF4Bzs7ckP2CVQLjYVBrhfYp/X6VcDpOKT1?=
 =?us-ascii?Q?mYfpyUdwYwwUgJZapCpcUu6NTNoUa/iOXTb9iZf4yOcPLsmspgjp3bwPAeap?=
 =?us-ascii?Q?RLSb2d0f49RQGMmPiY6gfcIZDAVcBTrWvaxxmTtnljYT2RxtaRAAA01dQdFm?=
 =?us-ascii?Q?GpQZwtUW4c39aXFxgIVDhjs621/W0IrRqjDymVG+os2+Xa4KvQNkoRusy6gr?=
 =?us-ascii?Q?mhQ7TCsdAS+YUAo+A/5XuqZAh/J3NAY6DU0MA4QhN6FiZcMtiu0ZWyk5eDhV?=
 =?us-ascii?Q?DnaMX59y3OIcMHhVVNGVnuwVT2toOtuaHSy0BljQ9HM8f1RrCNOsY7LSie/p?=
 =?us-ascii?Q?wp5r/eUjxyu+CmyHOYQcwxNBBivg9Fp7GeZk6qQCZJepbgTLOna9vBtdfZIR?=
 =?us-ascii?Q?oKUV5DZA4Kf7+qHtz0Q9dWBnbX+OTz2T1AglKKAIO0uJ+IZIpQRJIF7DQPRO?=
 =?us-ascii?Q?znxPBWtACEP7H4xP+ELKE9jPp5ByoyEsd5Xzd9LxBsKCRVN5znIcfnuy9tgh?=
 =?us-ascii?Q?xoX6ZAvTm+cOg7iTEWdLyCP/huDfQsxTndh2fZ7mk6Z5sdn6RTeDQXg1GKU0?=
 =?us-ascii?Q?AeObsf7gieN9cTosBtoVdYEXzlYpn2ktfTB08I/8kmhuJZjdabJqOsnDVJi4?=
 =?us-ascii?Q?8rMiy8W5C/bi5nQbLvP5Rb4ZCeRkp6QhMmQXHoOZNemSlzTWpUWq3SQ4TLHe?=
 =?us-ascii?Q?MU0j+TVTewgebREqbneO3nvXTOyA5PCNoovOtysLJ75cAcw0UCfvcCpB8ckN?=
 =?us-ascii?Q?e/UY8hUGH93t0uUKmen4GO1lhGO+Q8tVsoFHYdcUTeBbF6ZhljHDndTLRh86?=
 =?us-ascii?Q?bG/ie96ylXAk8+M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KkoAFxLnLHXGiXsS8kpJKwNvl26+HVkQw+wiK9hW8+JB1ofGfG1oqImmD60c?=
 =?us-ascii?Q?gOf0dxLx4WObIUrRTFeibHBtLoCSqsN2AOX3WWwKAFBqQgqzwqOmjQ/uJLQT?=
 =?us-ascii?Q?bRdXIC2/OY7doWk6+4Iazz2ipP0kAmv29FuunAwBtI6C0LsTXKlRA2829NS4?=
 =?us-ascii?Q?bRfCHT0Td8cHFSfH2yi+yoKIBcQ2C3KZ4esE+FGZ3t8vsZf+BMfk9mSCW4LN?=
 =?us-ascii?Q?PLTqVIL64QgparzbGaToY0rjsgWWEvXV5pX17DfYRxj0ajFHsmZyG3IjWZVt?=
 =?us-ascii?Q?CV5FM7G/UYaQKFXG5sz6QcE9C3c26rfd0nqYceTyUkRbj1Voiwjs5UigxY09?=
 =?us-ascii?Q?AUaqehq1KNXBiTtANs9wFZBEx0hDkURjaXyTi9cWtEq+JcJ/+Wu0pDcP80WC?=
 =?us-ascii?Q?LCg62JTjZEUU2eWmZ6/WVFYA/BZZuKBfe6+NvW2t/5E1SNMRYMZgsZgL7v/z?=
 =?us-ascii?Q?ZOyZ2TB3h6IgowSTYe4VujGdyBfBix3a6q+fj+nBhbxvB0UKALVVeU9Yy5s4?=
 =?us-ascii?Q?izvC12wgoHtqW5gKbWa/5G4Qn4OqoEiSXbMUodZklufvUIbMxf0E65QkFTf+?=
 =?us-ascii?Q?QkZKdA3kYmgyed6UpsFN0JwkiaffygIjVaXgeKiAaVTgdZ0X8ScHgqoTCTF5?=
 =?us-ascii?Q?XtH3R76tnYbZXUFuXUBpbDGlj8gMEUM/+dfcpQiSmvdJ143j93EixdgvGNUb?=
 =?us-ascii?Q?yp3Z+Dra9H8itmkORvKWVUM7EbDwtQnughrmhJyxhfVSeWGAd38WFrkNsjRj?=
 =?us-ascii?Q?OksY9KYnl51whMxN+BF0xtE7JOknS3mhYCAckYoO7HP1WCl5IviXPeZ3g6vs?=
 =?us-ascii?Q?+/lRculjuzUeKQYMwPOcyLhHYp/Fhsg7JdWTAB78DcHZTLSY0PX/pFcZZcU+?=
 =?us-ascii?Q?Fo2lc0vOSKYk8oWJHhpRHwjafRCG1Yic+GD8/LHMFcW5SgAZvER7UNsvgzt6?=
 =?us-ascii?Q?wWczmGkMmKW6NP/WJHyl+MmDTpcmIHCHWI84474Z8lCN3TCtuAQWrCvzDAEX?=
 =?us-ascii?Q?nUyoTywPJcoZ9NuYlqbd6Ta0Ibm6ydy9KoxS1eeO4u4+OZ81hreoTMngfjVQ?=
 =?us-ascii?Q?PPMkNhChmSQeSXjKaKu0g47Hecmv4rgNIbuUHjLy2h+ib9yCJTK4tUiuQhd8?=
 =?us-ascii?Q?HT0BIUSp7fpoEfzleW7e5392AaTN7Biyui1AQjwelityVTytIaKveGXIZ+NA?=
 =?us-ascii?Q?sxsqNA0PPmAET5eQFGukB0Q6zDmzLG+06lnc5vuONXNIK/vHG0RB+BNuWItw?=
 =?us-ascii?Q?WdF5z/PdTonljh12dMw44ESzbo+rugCNX/lXXaEbaIAkBzqz9DGKQb8otmJw?=
 =?us-ascii?Q?6jbezpIqNQ+MQHJq4Ah4cBt1RxnHh5LtAl7PUCjMubVnMW0RYwZJDAwcswLF?=
 =?us-ascii?Q?FUeGNWNnT5LPVvtPO88cA6/Ig+P/z5uRGkdf51U3WA6b1Ts5gUWHxRi74f37?=
 =?us-ascii?Q?zRidE5DATLM89m7gy7Fet4pPz+wOvDWYqUoZExUAI2DGAMhRGngiuTR0aWmD?=
 =?us-ascii?Q?tMQ90cB8kbbBh+Oe5hW/qNW5q4Epv8CJeyV2kqRLl47uzAk31ABihkgyQkq3?=
 =?us-ascii?Q?4iSXk4d5AW1xMKgtH3cCB1Mthcrnv5WQFa291DA+6j8K9alv7oKxlq4/sa+d?=
 =?us-ascii?Q?H87UtJQb317Dx2f4XxSWJ+vTeioFQiuh+2TGY/z4owWU9EbNx72nU2CSWgyE?=
 =?us-ascii?Q?/zRz2zcbV7qNuNPfKqicmgPgXfadEv12q5/2ZfOEtVU7Fot7xV7yBgGHFoMW?=
 =?us-ascii?Q?AHf25Duuypn0UOS6UtTh81/iP89ssiA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EEIdPdi63XEZu/cRP+crBHPCFRN5sVC/ifTSK/H+qVEXQ/YFsZ6JLZGkI4+r65nUXCYEwmU18xTYMidRkevFLtjUTMOdi5lqRRCrZiceWxG+qtf/17Ba51nX6tfTuMgM7HP53Z8oK1nQA5EqqR+azUtfLfl3tSEyrs1BFmu4GWcgUoOjSDXKctGWBBtxWSUG11wO6YC+c0BCwNHFEtm4UdMb490GiBzNZqfC/72qAVXWf5VtOwmoQLtMERHG+h9Z8NcesrKzwlGjPkSN6T7CI0tYQ6Add17zJth+x0iQNRqo+BpMQ8E0Y3Zan/GR/vp4e0/benRR++Bm+jb0j+i8ZdIglwtUJgoNUGEuEBvr3pQ+An1F3WmnuafzKHGQUJf4zpuPgyu1cUFrum4YadyMr/FtLw/c/u0za2yZx/92A/tA+AXb0ItQw1mypCnzTxnPJNyYuW8Mnrj+ah8hH+byqdt+TK2wtK4/mkmWFz/lnqHHo+hy90Nlwqy+CnaCKxGpXnuwHA6yivYlomdttkcLTc36ZP6LEEkQrwbO10iYN0p7ZNxd85lWSOCewOIQhQZxioyEtCZ5cKd+25Im8Oq1nk7VkUTSf1zSXV9fWq5C48U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621891b8-8aac-46ab-e091-08de4edf77e5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:58:03.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/Wq6MPEewbvjHarFZhXRikK3gDN0jYdcTkmE+thNs3GAIuxVrHiTppyTTZEn5DQFQMG0xlF1/NkA5H+VNnPVI0B2wDDm4bj0HJjWWAYG4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEzMyBTYWx0ZWRfX4Lq87lwcvgOG
 /lYWIuN5hgXZe5hGOkcC316aUnpWe+pyMmsU+uPRXh1jD7bb+nN0KJaIvFo3cBQm6mbNJO7ZVya
 6j9KrJgyIUsBN7t2OeeXM6a3pqcZrJJ924jZW/cy88hV8q+op7jRHENnIZlO3WSRlnlfRa5i/cb
 l38jKORHm7z0EUpXaheqHDDbl3O53JYPZR355PtFb16li3g8P0gVrGIPg66Vyq0UkD4mEYelQZJ
 F+V/pJu7qCEvYB1iJKkEM4EsAxYNmAyrsyPeKoxlC7l51sXFqDDzznYUKhAu3bRnK9IYOBEKE7L
 EJKkE0ICosHxg/3suea5CPhjmVjwj8deLE0xnhHkPxCYTkP4qgH42/5u8wAXj+2Tx6ljb5p4SHA
 m966jVRtoGfcpt3XjYV2VptdtYAVdJj6pqVABrfT7hjdgUXUFDgbbv8pJpouoZq3XvEeI65gVFL
 24Y56dx7vkqpLtk/cxg==
X-Proofpoint-ORIG-GUID: Ug_KWXib2kkpFejPrzYnNv3Nr_2nOIPp
X-Proofpoint-GUID: Ug_KWXib2kkpFejPrzYnNv3Nr_2nOIPp
X-Authority-Analysis: v=2.4 cv=T+CBjvKQ c=1 sm=1 tr=0 ts=695ff043 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=a9xkONWRoZmaOVjwFzUA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Stat-Signature: q7gxnms1bd38w6eujee7o7xggyod7yyb
X-Rspamd-Queue-Id: 5B4C3C000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1767895113-959763
X-HE-Meta: U2FsdGVkX19Q750RQR6sJxkuCMh8ZlBJddkQ+ADo8qs0jyeWUf7PWpgompseM/ZriSL0wXUVXXWcKXkbANo+N0AX2r2vTgsXDN6tOI+Ab75Mbx9OIh9l6kA7Id7tDW+baqOwWflSmtu46PsMcUoVwY/bdkNNJ3bPfbskNNby8sU1H7HTTpAxYkfYY9CKGkRCmyN4xmmCSKkZB5PJiXADewsBjAsOGpfIWwl9nSrfz29AYb1988HreV0CPDDLta1KWpBfWwcrIXl47XNtHapvVTG1Zc0drMjNtmyAAhA4Hsz4GgpcVLSKfaRLe94hkrI5IvFElcMN8kHdq58FaNr8cXVvDneVjGFJoflMpVGPPSZjqG2T6V/kqpZaYif0HDg49ho7n4F974MPyNxzvfktkKuUQW4jIz+HR4+mXKh5EBH0jPtAFBS+IEU7mZGsEj3175nMgAF7gdTtRLwlgSkncwunW1Xla8oH/AEP0G5RZmmPlAqdLvHk530kCam+fbqylNXTofkO068hde1VMl629Jgh2s71PBJ2RuXldnRqtXoIj00HxpHatnqIiivkqvBBjYAqCZbIp+UduGSDTICZkJY1VY5dpXdFH/70ljpkKe8WOpPA8KfTiH3pu97d7e0AETKXVqUlZLqXvDenfcsbf5KJcF9UtT8Bb8n2hWOPnqS2ML8bxcRR3ST//cu1SdVCU6or5WKd9xc9APYtMhfPNTgOQSgz9Wa2T41BgUaX81sOHSUo7fKAK4DMB5gwUf6VDqdeI58i56xfcGrM5zJ8MEvEq9l9V5sd7On7p7wzpl+nxOdJ1DihqJr9qXIKPPWwCXCMzoUuL12zf1euHlAjs+jYzzINwbxYj85dpJ0SSUzWVjS/TL47+DaYqmBAkhrbH0ho4VOL6o3jVdRU2ZBkCGWKgOJRFQYI/uaNBf+H379NfaHsYuhkSyOeV024ri1gcwZOv2lk96nBwYRUJoQ
 1tag1JfE
 kv1IkckUnGJkRywL2S/MBZX2rj0NWLDQIAgKUNQN/WWBtsvgBv1FlXJN4QsFQIAu9v637qIqMHE3LeAM1tlAaXV4FFcPebv/SvMa1DrrTMP5EdMQIerV8dIHCLVi/oHLuMqvyzYfFQQPhILrkrVT/crv9Nu8se837GBC2HJWFznkV99IkJGbYaapQfyutv2Ls3NMS85o5EIL962iUcXLnQ0YzNRbQZcHeOni25jyY25LHepktd2F9gkDLVBDP4SDc2E+cdlEpYHEun/J5eUcHO5XgGpQ9wl/7RQkxqEr18LHHESZUbsGu0w/WACuF3H+pbip9GSkXd8tbqeBuMmpFI01owT5+QEnuMfZbrdSbDo83qoqdupHCgs07wupmiVuoz5j1Tm4Rb13X264BQbP9SWXiJMkkGuBp0Ik6qH7xunQXntpVB39J2p6ARvzUbfYraqSnlDd2pRM4VluaNkzRNc3d4N4XYyBEXdl2M2daIy4FvBOssgyLhd3auzK2SNCAV2cu0p/TD4TqNOj0sBHc01+a+SO1oSAmQq+XIVk1XVAzsZ7SftltBAq3GcyUV3VDJnwP6zdRS+CD61IadiZvsnPb9u57BKFz8+XpSwXHu4BIfKZh4NDFQiy8H1jJf8oNMo9+pgkQ4xq70IjM2ybUK1BHBnH1h+KfUynfAPmrfnl+RlHFGdoxHjCgydR5hRGRRini
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 02:27:37PM -0500, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:05]:
> > Specify which operation is being performed to anon_vma_clone(), which
> > allows us to do checks specific to each operation type, as well as to
> > separate out and make clear that the anon_vma reuse logic is absolutely
> > specific to fork only.
> >
> > This opens the door to further refactorings and refinements later as we
> > have more information to work with.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> A few minor things, but this looks correct.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> > ---
> >  mm/internal.h                    | 11 ++++-
> >  mm/rmap.c                        | 74 ++++++++++++++++++++++----------
> >  mm/vma.c                         |  6 +--
> >  tools/testing/vma/vma_internal.h | 11 ++++-
> >  4 files changed, 74 insertions(+), 28 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 4ba784023a9f..8baa7bd2b8f7 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
> >
> >  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
> >
> > -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
> > +/* Operations which modify VMAs. */
> > +enum vma_operation {
> > +	VMA_OP_SPLIT,
> > +	VMA_OP_MERGE_UNFAULTED,
> > +	VMA_OP_REMAP,
> > +	VMA_OP_FORK,
> > +};
> > +
> > +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> > +	enum vma_operation operation);
> >  int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
> >  int  __anon_vma_prepare(struct vm_area_struct *vma);
> >  void unlink_anon_vmas(struct vm_area_struct *vma);
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 8f4393546bce..336b27e00238 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -233,12 +233,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> >  }
> >
> >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> > -				 struct vm_area_struct *src)
> > +				 struct vm_area_struct *src,
> > +				 enum vma_operation operation)
>
> You could save a line here by putting src and operation on the same line
> and tabbing only twice, but sure.  This is true in earlier patches as
> well.
>
> >  {
> >  	/* The write lock must be held. */
> >  	mmap_assert_write_locked(src->vm_mm);
> > -	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
> > -	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
> > +	/* If not a fork then must be on same mm. */
> > +	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
> >
> >  	/* If we have anything to do src->anon_vma must be provided. */
> >  	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
> > @@ -250,6 +251,40 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
> >  	 * must be the same across dst and src.
> >  	 */
> >  	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
> > +	/*
> > +	 * Essentially equivalent to above - if not a no-op, we should expect
> > +	 * dst->anon_vma to be set for everything except a fork.
> > +	 */
> > +	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && src->anon_vma &&
> > +			!dst->anon_vma);
> > +	/* For the anon_vma to be compatible, it can only be singular. */
> > +	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
> > +			!list_is_singular(&src->anon_vma_chain));
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +	/* Only merging an unfaulted VMA leaves the destination attached. */
> > +	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
> > +			vma_is_attached(dst));
> > +#endif
> > +}
> > +
>
> try seems to imply we can return something saying it didn't work out,
> but this is void.  Naming is hard.  reuse_anon_vma_if_necessary seems
> insane, so I don't really have anything better.

As discussed on irc, this is probably better as maybe_reuse_anon_vma().

Will send a fix-patch.

>
> > +static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
> > +				  struct anon_vma *anon_vma)
> > +{
> > +	/* If already populated, nothing to do.*/
> > +	if (dst->anon_vma)
> > +		return;
>
> This is only used on VMA_OP_FORK, how is it populated?

Below,

See:

+	dst->anon_vma = anon_vma;

So this just means we use the first anon_vma we encounter in the hierarchy and
don't waste time trying to find another.

>
> I assume this is a later refinement?
>
> > +
> > +	/*
> > +	 * We reuse an anon_vma if any linking VMAs were unmapped and it has
> > +	 * only a single child at most.
> > +	 */
> > +	if (anon_vma->num_active_vmas > 0)
> > +		return;
> > +	if (anon_vma->num_children > 1)
> > +		return;
> > +
> > +	dst->anon_vma = anon_vma;
> > +	anon_vma->num_active_vmas++;
> >  }
> >
> >  static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> > @@ -259,6 +294,7 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> >   * all of the anon_vma objects contained within @src anon_vma_chain's.
> >   * @dst: The destination VMA with an empty anon_vma_chain.
> >   * @src: The source VMA we wish to duplicate.
> > + * @operation: The type of operation which resulted in the clone.
> >   *
> >   * This is the heart of the VMA side of the anon_vma implementation - we invoke
> >   * this function whenever we need to set up a new VMA's anon_vma state.
> > @@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> >   *
> >   * Returns: 0 on success, -ENOMEM on failure.
> >   */
> > -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> > +		   enum vma_operation operation)
> >  {
> >  	struct anon_vma_chain *avc, *pavc;
> > +	struct anon_vma *active_anon_vma = src->anon_vma;
> >
> > -	check_anon_vma_clone(dst, src);
> > +	check_anon_vma_clone(dst, src, operation);
> >
> > -	if (!src->anon_vma)
> > +	if (!active_anon_vma)
> >  		return 0;
> >
> > -	check_anon_vma_clone(dst, src);
> > -
> >  	/*
> >  	 * Allocate AVCs. We don't need an anon_vma lock for this as we
> >  	 * are not updating the anon_vma rbtree nor are we changing
> > @@ -317,22 +353,14 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  		struct anon_vma *anon_vma = avc->anon_vma;
> >
> >  		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > -
> > -		/*
> > -		 * Reuse existing anon_vma if it has no vma and only one
> > -		 * anon_vma child.
> > -		 *
> > -		 * Root anon_vma is never reused:
> > -		 * it has self-parent reference and at least one child.
> > -		 */
> > -		if (!dst->anon_vma && src->anon_vma &&
> > -		    anon_vma->num_children < 2 &&
> > -		    anon_vma->num_active_vmas == 0)
> > -			dst->anon_vma = anon_vma;
> > +		if (operation == VMA_OP_FORK)
> > +			try_to_reuse_anon_vma(dst, anon_vma);
> >  	}
> > -	if (dst->anon_vma)
> > +
> > +	if (operation != VMA_OP_FORK)
> >  		dst->anon_vma->num_active_vmas++;
> > -	anon_vma_unlock_write(src->anon_vma);
> > +
> > +	anon_vma_unlock_write(active_anon_vma);
> >  	return 0;
> >
> >   enomem_failure:
> > @@ -362,7 +390,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> >  	 * First, attach the new VMA to the parent VMA's anon_vmas,
> >  	 * so rmap can find non-COWed pages in child processes.
> >  	 */
> > -	error = anon_vma_clone(vma, pvma);
> > +	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
> >  	if (error)
> >  		return error;
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 4294ecdc23a5..2a063d6568d9 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -528,7 +528,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	if (err)
> >  		goto out_free_vmi;
> >
> > -	err = anon_vma_clone(new, vma);
> > +	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
> >  	if (err)
> >  		goto out_free_mpol;
> >
> > @@ -626,7 +626,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
> >
> >  		vma_assert_write_locked(dst);
> >  		dst->anon_vma = src->anon_vma;
> > -		ret = anon_vma_clone(dst, src);
> > +		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
> >  		if (ret)
> >  			return ret;
> >
> > @@ -1899,7 +1899,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
> >  		vma_set_range(new_vma, addr, addr + len, pgoff);
> >  		if (vma_dup_policy(vma, new_vma))
> >  			goto out_free_vma;
> > -		if (anon_vma_clone(new_vma, vma))
> > +		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
> >  			goto out_free_mempol;
> >  		if (new_vma->vm_file)
> >  			get_file(new_vma->vm_file);
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> > index 93e5792306d9..7fa56dcc53a6 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -600,6 +600,14 @@ struct mmap_action {
> >  	bool hide_from_rmap_until_complete :1;
> >  };
> >
> > +/* Operations which modify VMAs. */
> > +enum vma_operation {
> > +	VMA_OP_SPLIT,
> > +	VMA_OP_MERGE_UNFAULTED,
> > +	VMA_OP_REMAP,
> > +	VMA_OP_FORK,
> > +};
> > +
> >  /*
> >   * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
> >   * manipulate mutable fields which will cause those fields to be updated in the
> > @@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
> >  	return 0;
> >  }
> >
> > -static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > +static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
> > +				 enum vma_operation operation)
> >  {
> >  	/* For testing purposes. We indicate that an anon_vma has been cloned. */
> >  	if (src->anon_vma != NULL) {
> > --
> > 2.52.0
> >

