Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF18C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1578E00A9; Thu, 24 Jul 2025 14:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB83D8E007C; Thu, 24 Jul 2025 14:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80378E00A9; Thu, 24 Jul 2025 14:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B462E8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:07:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6131C1131E2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:07:44 +0000 (UTC)
X-FDA: 83699941248.19.B2AA6F3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id E1DEA1C0007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:07:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XGt+ZOKY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GRzu/T+D";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753380461; a=rsa-sha256;
	cv=pass;
	b=B6YR+p7QFHFmtPujAU+D8JP8R4LQr0E8GeQB5yS5gAuqmSaUaLaFBBwxi6QIkva+1FGAKx
	UurYQUhIZYuscezRXW5SaeRtQNSkH+762c7SZO3ymtngjR4Ov/W6/n57187dBIQ6Dd2G9p
	8HDGwpt0guMTIZgumwSjPiglrtlcxNk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XGt+ZOKY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GRzu/T+D";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753380461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNq9nUkHE3B3txZ0m7hUMf6eioGvBr/oVizgVUL5tNQ=;
	b=Et82EbP8CrcxQ+Kkk4fpqTTOn3MvILH9Vl9uqCLwAg5XJwRPKrmS/7WD6Rpg4HDg8um8QS
	HRAclxfobUOlPLwEJCSTJG2QtgyG0GVTcYw0uH0Z6vMTFUJeI/aguXrkXfkr5eOPQU8u48
	0S7dsFLfabn8bA0kMxmazbzvB96aqYk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGiuhP003965;
	Thu, 24 Jul 2025 18:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TNq9nUkHE3B3txZ0m7
	hUMf6eioGvBr/oVizgVUL5tNQ=; b=XGt+ZOKYmRJD8C1LcCtvb96+1QVzTTSVOX
	wSXVAHC+tKh5+9qeeT+HobCJXGtChLoZ2Y535uqokdq1ASxx+s1PUNxHc1nRX2aH
	qRDInHkLgWbYqPx7bHXVKc1mf270anAsV9/NOqmNfx6UNNTuIno7U8eND5zxNhyp
	Cpxrcl+8xUQMrsiLgeUP0A1r6vSdhP9UNyphLYCMusTo+qDTsRazzzOkF/1LrBwF
	46nI8FybKyZWxED/oLpnRyYyNqNiOc7jE1An0Xs5abAPSVwfxmiXzXUsJbld18AI
	YhDmgJgOc9CE9uTAeE28AxzPr8hjtk+0k6g0XV4r9BXMp9AM5Mwg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056ej25m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:07:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OHfaMT005737;
	Thu, 24 Jul 2025 18:07:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tc5sen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:07:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iwz/6UfkKLty+AqNjdQAaJraclRQjaRMTuQUihKQXSeIGjiG8D85sQtEojH9AFEyGpRabeLTDzs0srDpwbZQ5CjGrARmmqlqRdbtwGvE9823WkDqUFXbLNQ3s8S5dxO5EXSN/0Pq/Wo+ZdfsztRxNQFytKhsIJ1SvEosgph6NHPGqtrYFerbvAZaf7mmOrpBWh47Vp0xFnoBLlNE7GIJGVa05F7Z5nt3B6lfH/0F4us5JRo6bzJRCjZXWReK+vquASRFsgj9d8+LS57To94ZnMyHRNUK5eEeHwXWvRwrzo7zOBnQRndyk/kdPSnvhk9zOAWZJn/Oy3P2XNB47kusRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNq9nUkHE3B3txZ0m7hUMf6eioGvBr/oVizgVUL5tNQ=;
 b=AuApVIYdNS006LtZ+l4tpLi+SiD+lsyBbLwZIjj+gKjZKx25ZYinxaEhoyf3D1CGVL/S6gdFOkdslVh2sMqAwsNPEtR4B07wEpr5WiGCv714R+2VMZMlsPbZ5duR/2i1N4JBboumVgUkX5tpnPi1LzlUfMj5+JBTFtslapZl1F6LKWpZNQQ7er0PUXxMUkjL2J2wAXEKfC/ApgciLxvU76pJC8R7iFlip7eFrBkXcyIQ6fus5PJ/SeQbEjaizmKhltwPxX6UH4oPgUzlUtnBUfFdkw0OWwYKK0H4V/Y3UR4ea0qWD9MVKcgZmiCv8GgCzEXoAOveYmlLHsb13Ef7gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNq9nUkHE3B3txZ0m7hUMf6eioGvBr/oVizgVUL5tNQ=;
 b=GRzu/T+DPEswkuUYmsGwhnPW8NI+gu3PoffIjXk3SUxSEfrJFVqjBSIlBOjHPOYWjXbm+pYl5w/f2d/5j92Pm8HTLITMKvjDmaU6KFhZh2loLch2IOaYobfDWvg0PGIEllZTq4ijHI12TMniA0V3SO7SB5Pp2+a2Z4ukuHjXjxE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5840.namprd10.prod.outlook.com (2603:10b6:303:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 24 Jul
 2025 18:07:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 18:07:31 +0000
Date: Thu, 24 Jul 2025 19:07:29 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] khugepaged: Optimize collapse_pte_mapped_thp() by
 PTE batching
Message-ID: <17639424-1014-4fad-996a-2490cfa908db@lucifer.local>
References: <20250724052301.23844-1-dev.jain@arm.com>
 <20250724052301.23844-4-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724052301.23844-4-dev.jain@arm.com>
X-ClientProxiedBy: LO2P265CA0298.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: 36d17b77-6b44-4d60-605e-08ddcadcf584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SQMLUIJSGgLWJjzfhfnD7DP3OzG8Qh2C8DIJMaRQ/Dn+WIUNYqXjJHV6PofK?=
 =?us-ascii?Q?lBQUS/anC6BUT3n13qdyVjnATHaSrlRiMkxIchU5zhFJHC47nVIK/p5yqZNB?=
 =?us-ascii?Q?THpPwiraD+Mpyf+EgVoCfPaelQB87tkBBJZy/2gfkKIXHD3nsAZQjIVdTzBL?=
 =?us-ascii?Q?0NmQrMzv8FgyOYfJfiVh5TRq1lRfxEMLm9abmy1Fuj2Fd8YuI1+dofKZ1exL?=
 =?us-ascii?Q?sacNWoY5p/9eY8lozKUA4hAIrFX59OUf19+789QEoffTpYzM8yC1euW+ijzR?=
 =?us-ascii?Q?7q2D0FoM1qwBd1b/d8dhnUNwM5SOfia+gQTw8IFsSWPYRSZfMOu7fjkAjuog?=
 =?us-ascii?Q?NlZLhl5K4aMruliotIGxfOhUHYsdkfV4IxOC3NTjh+waBqXsn1KJiFLvL3qg?=
 =?us-ascii?Q?phfvUZbs6koKbprgm6oWUWDs6RNyWpvpUvfiHEvR3llHbuxkaoEMRlqIwNp0?=
 =?us-ascii?Q?PtzR8zESGwXoAnhO2Taii1JF6hWVXCOC7E+T+smkxPzEOmxyFYSvCo/UC0Uy?=
 =?us-ascii?Q?tE42ZmsqROsL2lmYzHXqb6z1yOM/U0Ht+VjqMs6a+0lmqFBwJmfgZa6VzEjE?=
 =?us-ascii?Q?sN7ui2MaTdhMofUhdYCp6iCKBN6sPLHF0DePbwqYb4/mif05HdLU67LbcHCj?=
 =?us-ascii?Q?KqBz8gzUipuTjJWICHwhneOhH7weiu8MGdY7X2izYxBXRGgiUG+3/F/FjHHm?=
 =?us-ascii?Q?V82U5hwdFt6HtTDzbdYIcKTr7MOqf/ko+UHqElo3B0Gds77aAHXixK3XDw8v?=
 =?us-ascii?Q?AKEAu6DZ2vuFDwe9wxDc6itFJNc40bXVj5eaEdHaw8qzzWtsopL95NOvFWmh?=
 =?us-ascii?Q?9pDTnn9qgmPyr3AJZIeH1xqt7AomQrhEQHj33a7E9lz+bdStXyWmr+8Lya5K?=
 =?us-ascii?Q?Hr+opZn+o+n12fXtgRbNsKGj4nL2MjqgZ7X5c2St81PjGqCBhYImG8AffABN?=
 =?us-ascii?Q?k3GQwmQ4R3OJY9C+mVmmxeSYb52OZtzZ5zMg2Czrn15erLUJW2OoMor2gTws?=
 =?us-ascii?Q?9hL60+SrcOuHVnKnr4tO/u4zfykkv3epmeSR/3wFb51bCT7lCK45purrgmok?=
 =?us-ascii?Q?x9LHfmuRr8QDbv85CKDcBN6FxJQy2/1ILLaToAmkpemx05Wnp6xGpp9Ca51N?=
 =?us-ascii?Q?biJuKMFs9WGT5e72B2tbrRhHd7CYXqn/VrBoVUa8nxmb5aye2s+brHl+oTot?=
 =?us-ascii?Q?4747mgzbRPQFDLD5F4v9eeFepHbfZT9dE4/xc1XwLFZwdiieb7m9FtuqhbSp?=
 =?us-ascii?Q?pQJx4eRRqZAWYCMWK/zd6SQF5ebAX/KJV/G5+8WdO1jAZUJwl20TPFjHIdWB?=
 =?us-ascii?Q?FV1hAj0osAnSZaWi4T7E++a38k5fkBOmrMXgzx9DRFWSFDpvnDokrYXSnO+b?=
 =?us-ascii?Q?XhJVd/aOGr281sRiVOHqOA3lCnhfecXEedGR2UfIMTx8OYweNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jvh9cgiXqlNRmMMAeNj+VVG2pQlQ1EpFZj5op7Ln9yLbnThkSD527nFRc8QV?=
 =?us-ascii?Q?PRH9Qlkm87vGkL6IXDQX0FGgZzdNexkZV0aMLp0mGCL9pja8jcCf/ITTSPaY?=
 =?us-ascii?Q?KngrmhTQIOmCo1YYUrM+BqlHsJAUjvNt6a4Tewq9FDT4KUvMr7dQX6Zs6diZ?=
 =?us-ascii?Q?fVk5kFWrxBJvlQPYxpG4HzGPoYR1/RTpTZ/Uln5Umbr76umyBUOgApKjvAnP?=
 =?us-ascii?Q?knDzahfrUEvTYjtEI/0kE5VweP57fuangeQBarbHB6q/DRY7ZYQHRI2n68hw?=
 =?us-ascii?Q?kq6pch0zBV6UfmDA4Lh6h5n++YPo+0EWMyXlC6oowWb/ykYA1wSM+Eo6uqEe?=
 =?us-ascii?Q?JAFZbkkpC5UGDy4iOAre6YhGvR9aabrUAbB/P8wobJtYBTR/wSYrm6jNkS4T?=
 =?us-ascii?Q?T6epmbZt87aAR4wHZOjCjq3FfFMW7MK3J089v/QTo7tYjQDy9b4rO974wPWI?=
 =?us-ascii?Q?t8XFUWaFcGNSXM/h7z6kb5XzRNNCPGTw6diFkzoLOtHPfOTyv0zxN6tz6K+Q?=
 =?us-ascii?Q?dAoihhlcUDB96TsE2x6xqnQJKiE0TOMEB93BGLwsssLoSRjLS0bH6KgHEmO/?=
 =?us-ascii?Q?CtWDhBoFwso4kwNdjh+Sa+H+uv98DLskou86qWZ5CcIiODhQlima026ROBXW?=
 =?us-ascii?Q?U6yQGEVhgfuJvjOP8wBzhdXCStM26s1vGQ9cad+LNozhWkFWxOpubS9rPIoo?=
 =?us-ascii?Q?cxM3eAKlU22UZrozFK4sNoLGBxtWUnjOAc4Aq5pp7lSOLxeBZdlWnJc3uNQA?=
 =?us-ascii?Q?n0gO0SeRvg97nmMgGBSNoPcDCtWfvIp5rMNSKj6Jlua9d/ADisysLsBtetc+?=
 =?us-ascii?Q?LePT6fLwDnzg/0qOt1itpgo3zf/aRYqQUFiBqc0PYPRRyEgDeMmxR3ugA5AM?=
 =?us-ascii?Q?7JHWpNPn0HPnuZppIJRNcfSAFgRWzn7TLuJ6deJl7lYV1U4R+MjtLJr7p5rr?=
 =?us-ascii?Q?I8XVyv1CmAceyyfE5SXZwkM5cm3nfh8JFF+uZOhETtbwpZKZdMV5gLEBr6QL?=
 =?us-ascii?Q?pbZjYtnvnY7yVIx6OC+8M/LN/ilUj9DEK2wngj2VkTJduJBz5nZvewffVrq6?=
 =?us-ascii?Q?1d6lwJSndoVlSE9zasQVzVymEqVIhirnvR+8fOVt56Y2hWikaa5RWwH8ewFe?=
 =?us-ascii?Q?oxPRSCi7zEEDEfCObwfCm47cPyvHeo4WcNm9UbkYdlAUkA65AvLi3wx8gLKK?=
 =?us-ascii?Q?Sjmfzmd6zPD+T6Bxt7lNact9Fg9g4d8bH3aY03ptTcqx+KNf7g9luLHDJcFo?=
 =?us-ascii?Q?XlqABENlnapHTyBsjOaZDhAbXu8nwQ3mE0oQqJmh/e2yX33XXmOJ9qSELiEX?=
 =?us-ascii?Q?PYPGHx6VsQEu7RIpqT7moThIsTxUL1JkuIkEytLlHrVS0kFklUz2AS+rElDa?=
 =?us-ascii?Q?HjHJdTZ4iQP2CchmSgH66tPUPmEhXSb7IHOanS+5XnwiXKMUUUskUDwkkujR?=
 =?us-ascii?Q?D8pG1LaFY6SlLn3lA8qvwPJAnjCkOGhgBd6afI7L1Y0Or89E6ca9Fj4XSln+?=
 =?us-ascii?Q?85ljomBF2iKHp8U1VEvItALiIDs36WCnnJZH9fXcPOP0/oDk8/YH4F7BVS9q?=
 =?us-ascii?Q?C1oNXSfx2sTvjt8NEuxudXMaYcEK4Jq7ARW6vzbWo5kxuaWXBiNViP0EkcYr?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TsuFbx6xqvdg0j74CrEPWcEjq8jTrwX6rEwnsSyAnyFw4iPPxAMliB/KrsfWXrzVw1cPiM2zsGi8UMmav7moFSaCy47pVFug9KwBVzB74J+6+PKtoiJQ/Qo5CbtZYg/q0+2m/scdB1TiV8HTIdHU70G3voTXtPEKYUe6cjEfc1NbAD1NuW6aYf5yr6sPPMTqvIgaPIHKxu/DAL66kjtmacDgm+P44EvPUjiO78gfmi6XO3z3gAUDYK/y3SVfpqI9yxstrrn6K4z0BdVrQANjoQxHy9BICbZb0m1HWsalwM5v7cZmhpD8MhS4iKTrNo2JmhEsksPLjUcKmTskcEG+8BGUYpImOws53guURYL9VvAMo9hA/w8YB5Zm9ixM339bP8TM3c1yuWdkyar0zbc5CA/7LMyQ1dDQixfuVPAkZmQJbMDsPU5P3icNjJPB5KPbfRYxwM6P/11FzR/HRJaHLINy60CrnvaRs80EmuaJLgbI0DWv9RgBgy593iCkMlZViH1U8+ChnApbD7/eaV3oMR5BCbGV3cDaB6YXRnIhAiFN0vD548jwk5r0QakEuK9eM7WVy3yUf3MVGK4VhuF5PujJW7HXlCjWZQGRF/9wLiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d17b77-6b44-4d60-605e-08ddcadcf584
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 18:07:31.7878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWeFgZVplO5dB11vrglPsYUBEXkEz3wDGjVo7LX9hoDeKVw12MLv2jxkws5sAfRy+TlZyL+UcQ4dXgGWvpQeb3Mxe5Db3cVYhBTuhJBnSqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240139
X-Proofpoint-ORIG-GUID: T5_51XqaWxeTH5u08hHeNYRJC-DCbYkH
X-Proofpoint-GUID: T5_51XqaWxeTH5u08hHeNYRJC-DCbYkH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEzOSBTYWx0ZWRfXw0W8qaKXV90O
 aSxuURjUZL3sK0pLKTgZuiMpohWRqXVdkbbgAiYgxbb2BWbIMppkjIlDhX8zHMyG1qBxTrPA9c4
 PkajMNP670w1gVglmd44ABzZFrdP8b79WpbH/QJ6ANDG1zyNOd/fKvy0ZWgcTNJ+DBGbVVyaYgQ
 vjIIQRcI2pd5CIg0cqy4yAQxoE1FawcWrhD20sp729Rp/HuCkCi5ytqdsFIIRW+z+L1pTg2GG4x
 5AXCGIfGgCAvx7JeKTllmWoF/++9harEOU42R05ZsQUvXL8GJ6KnERtdg49j5rQLRodVMiMrMZk
 3WcZp+qKKWPQa2otSptgPBCT7nWgeZ4xHIEeOfcw7Uk4RWkjGO46eddWo8aNeogsNnHhti6J50L
 ep7e25RWm0jYLWzjem5cfg9Ch6sodU2WCM6D3Eue3v6ovEemVGOlrWNc/PZAp7vRwuOhO8Ao
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=68827667 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=He-yOudtoeGGN6VMLs4A:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Stat-Signature: 91snnthq859pj4qmz53g491tay1eywui
X-Rspam-User: 
X-Rspamd-Queue-Id: E1DEA1C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753380460-177771
X-HE-Meta: U2FsdGVkX1+FsyvsdWg2MxtFFyZ5MN+gkn+ZmTNh9dXYEgXWGwXyqXtGTbVVgZ1nqj5NHqi7RkaMODhpeFPfsLo73OcK39mwBuUVumO6zVrx/P0LEUFpwpfr4uSkB2es/MhqdKOMsOR6JHZK0cC0KS4v+/hIBVXCr2NAPvGLlQpbIMfCmbNJ78wutW2DXwTe2qSC745fmTrH8EQxFPhsTlYITBUNIbTICch2e8e4iX2uTMTaXKo5YLSYr4nKyRBx0DaKsR19H3QsD8dr9BU0bfw6hrhw8ZgdbV6SMVC5KvwTG/PoZpb9d2tB225DxjqPTe6IM1zXrkKz7i/WmlBoo+/bRDESxIB2ZQqozGqL06yFDiwiThAsEK8+KhgejCzCLuHP2BsjIRE7IUcI3dAp1YgU7efqDpwKVlCbQWh3MqteDb6MuXZ6sCp0g/xw8WfRFr4t7aUBa9IsJz9h+QkKFbhq7lBLA3NRmeljMphwJKkAte7dnvdOh5QeWD0YT0gVMSc5Xm+fQ4UnmMp72AGzFyIggYqTpSxOQ54ran6V/id6d27D3rGtsqlIR2MqmIYCNDXoRUvXPRVXFJDuhhQdHkaRPAHFoNy5hU3qf7ddh4XEEk7LG4ktZFlTh5hG2KW5K+rwmDIAbYLZatpQFtA8+Hr0Ez4/p7zezr6YxhZULJQam5j6i0U26w2pbpNOa09wByVdbh2hqFZX/QqUiEdsNlrD9HvMEQktZ4yrE6gDHOnqy3gik33fu6qA2EwyVKcoo36kRPIbuLbjKFDbVGzOq2hgy9KTYMmg5lUL9wBdOscXSxhyTGLSI+GL/K3O6TNTjDJBYK+1CirVDf8VyLdyZ4sbpVqjOZPuzWHLNUz5xGyOh5y2K6maKqX+ajK0i0JkzLhWRcxviPbthmkZWtB/QFGes19glxnr0mmADl12OQT4sFbb6+4CDVoFnAa44Qxsa4Iow/w0S4fQlWrTUTv
 d02RF7Bp
 0ay+Ecbt1ANUxcJq9IUY4Z2aYP37h9g2AtKl0gStWbO2r59BBn2T2KkUVhwSXQec0z17jSDJisYEeJ1w4Bc+seC5IJTY23nSBkQQYkdfMuSRHfZ9ZlIb6ddU91w/G1PQD8bVkoEfxqD838AndXtQNULHgcj3HIZdVnmB2v3xvN9QKm6lNtYcMx4z35cBWdjXCFJAxUQje5trPCyQPldIxUgy9EzHfGf2bXoQbS3ZsuEzXrpjeA9Iwi2alqfG2MiP8ed2XR4IGgae/nDbXJf4emiMKUiGQActua/B9jNMSh32WbtN5kAadXQUvfvTYYhntKEKECK2IM2bosB1cRLYPLErf3gPSEMPlWHLhU8nA9IZcKOW6Lw67V5Y5SRqiQxf4P4/efAIkHazJ1LlWtE+6s3A2nydQZT93nAv2QCXWvtiV/YKBILiRDOyNiMdDgqccnemUeTKwlMHEyGZfHbzLXkDjlxAd/KL5XKZcN83p3g9+/fOaQem5R2lTyjR9Wix+Dy7f+O015YT8fkeDdQ3y/fD4I//awpvCAHL+2+fjGFuvyapvYjaTTv1o26/ILgCmGeBpss993HZQkTBmnlvwbr0s1g6ZN3R6jfDh6ENSbZSu4o6AAJa51UQqT9OvLlOmt1hbMwU5/V/uoowbhi5REN/bNO8pk6xxbKlJm/nWTE4zq+uaeY3IEfCH4hS5C1RsARjJTK82x3a6+hZWYayMMADF9RbaDYr105JfA7fJ9Gk8GLS+dn8EukQ3S9rJGm5oqxXOW/V+k5dtOQQp8HZIVS/ZqXopO7wyKAJAlw31WimYOntARJPXoMktqSzVfqmbN1oFwK7YQHvAhQPgcEFJUpkAZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:53:01AM +0530, Dev Jain wrote:
> Use PTE batching to batch process PTEs mapping the same large folio. An
> improvement is expected due to batching mapcount manipulation on the
> folios, and for arm64 which supports contig mappings, the number of
> TLB flushes is also reduced.
>
> Note that we do not need to make a change to the check
> "if (folio_page(folio, i) != page)"; if i'th page of the folio is equal
> to the first page of our batch, then i + 1, .... i + nr_batch_ptes - 1
> pages of the folio will be equal to the corresponding pages of our
> batch mapping consecutive pages.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f23e943506bc..374a6a5193a7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1503,15 +1503,17 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
>  int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  			    bool install_pmd)
>  {
> +	int nr_mapped_ptes = 0, result = SCAN_FAIL;
> +	unsigned int nr_batch_ptes;
>  	struct mmu_notifier_range range;
>  	bool notified = false;
>  	unsigned long haddr = addr & HPAGE_PMD_MASK;
> +	unsigned long end = haddr + HPAGE_PMD_SIZE;
>  	struct vm_area_struct *vma = vma_lookup(mm, haddr);
>  	struct folio *folio;
>  	pte_t *start_pte, *pte;
>  	pmd_t *pmd, pgt_pmd;
>  	spinlock_t *pml = NULL, *ptl;
> -	int nr_ptes = 0, result = SCAN_FAIL;
>  	int i;
>
>  	mmap_assert_locked(mm);
> @@ -1625,11 +1627,15 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  		goto abort;
>
>  	/* step 2: clear page table and adjust rmap */
> -	for (i = 0, addr = haddr, pte = start_pte;
> -	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
> +	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
> +	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
> +	     pte += nr_batch_ptes) {
> +		unsigned int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;
>  		struct page *page;
>  		pte_t ptent = ptep_get(pte);
>
> +		nr_batch_ptes = 1;
> +
>  		if (pte_none(ptent))
>  			continue;
>  		/*
> @@ -1643,26 +1649,29 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  			goto abort;
>  		}
>  		page = vm_normal_page(vma, addr, ptent);
> +
>  		if (folio_page(folio, i) != page)
>  			goto abort;
>
> +		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);
> +
>  		/*
>  		 * Must clear entry, or a racing truncate may re-remove it.
>  		 * TLB flush can be left until pmdp_collapse_flush() does it.
>  		 * PTE dirty? Shmem page is already dirty; file is read-only.
>  		 */
> -		ptep_clear(mm, addr, pte);
> -		folio_remove_rmap_pte(folio, page, vma);
> -		nr_ptes++;
> +		clear_ptes(mm, addr, pte, nr_batch_ptes);
> +		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
> +		nr_mapped_ptes += nr_batch_ptes;
>  	}
>
>  	if (!pml)
>  		spin_unlock(ptl);
>
>  	/* step 3: set proper refcount and mm_counters. */
> -	if (nr_ptes) {
> -		folio_ref_sub(folio, nr_ptes);
> -		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
> +	if (nr_mapped_ptes) {
> +		folio_ref_sub(folio, nr_mapped_ptes);
> +		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
>  	}
>
>  	/* step 4: remove empty page table */
> @@ -1695,10 +1704,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  			: SCAN_SUCCEED;
>  	goto drop_folio;
>  abort:
> -	if (nr_ptes) {
> +	if (nr_mapped_ptes) {
>  		flush_tlb_mm(mm);
> -		folio_ref_sub(folio, nr_ptes);
> -		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
> +		folio_ref_sub(folio, nr_mapped_ptes);
> +		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
>  	}
>  unlock:
>  	if (start_pte)
> --
> 2.30.2
>

