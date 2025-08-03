Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736E8C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 11:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CD46B008A; Sun,  3 Aug 2025 07:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E426B008C; Sun,  3 Aug 2025 07:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08986B0092; Sun,  3 Aug 2025 07:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB3DB6B008A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 07:11:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AF2CC0685
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 11:11:56 +0000 (UTC)
X-FDA: 83735181432.20.088E1D2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0973640002
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 11:11:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DzDCAspM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cZepSxAI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754219513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eC/JR8W9KhvDOPgncU5CFWyKBWoJVRAxMd1X+VAm8bA=;
	b=caLbLzVBSpdAiDW8gRU6NXYh3VwigmJPswmR3CZ8EfQ2gG4TM14WXo/VJVdsykN21x78Vj
	ea6Wfja0cbDBO4rWQlYMDibTKpcKERvWFzjXqCHqrdLrmcbYoDLJsGsETzI6cHJoxx2yqq
	h4i29X1tZ2ksaa9vO2Nd4DhFQ+RobiA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754219513; a=rsa-sha256;
	cv=pass;
	b=uu5ioGl5RIOQpVkZNdnhQO69evSDAqVLP45/G10ta9XHQgzkfcYiYu8qUjbu4S0sSxkE/k
	VZd7P3vlpKEiTqEGg1NsfSqG40KfqtZOunlRAVK3wM2mK1aQSXlY+H6Tx5QhLoRwTyF/Eb
	AZ8qeLHKqB9EPjP1DhGHCzvYculaVzw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DzDCAspM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cZepSxAI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5739fw2r028035;
	Sun, 3 Aug 2025 11:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eC/JR8W9KhvDOPgncU5CFWyKBWoJVRAxMd1X+VAm8bA=; b=
	DzDCAspMkVf3jGE39xmnst+KKTYBeYCS+RyORd7+6aDqYzv+9yiq9Cm+h/0RON0E
	isNJRp7gtiBFwsz6gxwxGlVcK2y2oLGi8zc5vMt3rtxXp7g348eQm+4RItXffwj5
	M2nuDQObRBG/oFfHBF2bSalt9yw5uWwS+ghCJutDBEp7DDtR9DdmpJIM6vqy7gHU
	H1If64rwPWMfn+upoEJmlNHWAWtv5w89UWW5J/FBuJ0yaCFY+FnjBKPMJyS/B32E
	WX7la4sMrP6uS0T+ELLSRZFo8yibvUmGnWmjnH3nLK0GtEYhN6IG1eNXXNHxAAqh
	OBhBnJUrIPttCpKeJ99jhQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899kf9amf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Aug 2025 11:11:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5738HOwP020513;
	Sun, 3 Aug 2025 11:11:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 489947418u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Aug 2025 11:11:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=amKxdTUWNp+4/IYNuLDlVN5aeRydrvbAP3nqO7fOPwfhFPndz1XmMah7xzCCK1rE9R6Ugsxt1lKfTKT3Q1Tu041eOpljTUXzDArKXtWW3DXKd3WPOl8F+scbGUvSeTgApisb8pYiZOC/I5oL4QL7AmoiVzLfXo0rGM4qAYrix8N+5cWu9rF+UUq/XLjkvsDwFgxlUJXtIvaXQEaOQZJGtGKKtjZA2g7/gLuEyHtvhDq2Q+Pp7SogfEGBj5ZCl9aKm2FUA0rAUOwbgdEoPqgj36DaOZGewUVp6ZCdR7CgD2lvgFdCfxaI77ah0ORnf7qURnS80g1F2zH8pvwJ2x4IiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eC/JR8W9KhvDOPgncU5CFWyKBWoJVRAxMd1X+VAm8bA=;
 b=y4TNvvf7osHabHq9ren1BKPeqoPuTsRaAGGJ4/23FhyBxf1wZy0nx/sLC0myS00b9RLMbuRiIU11VEOWLOBTX3edQh94AyNwYt4CpoMl3kj8oARoKPTXkfKdEslk6F5d9E0h3IiKG8Jh8MBQFJBYmUr6qGQZoxVbyqOdFpZxq2dZDKwyYsFrcF1uy8tyrn9R61jdiEWeq+GvWIDCB//uP13YBr5gdeALWBg4fTqMXbOAsZ00jh4nzeFeXEBPwTBCUQK6hICI4ojqYX6hVwOxVLGAAN+Rejkji6QhqlX/EksrcICjvC6im6oD+bET6M9V2JychbasMxMvC5BIA89y6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC/JR8W9KhvDOPgncU5CFWyKBWoJVRAxMd1X+VAm8bA=;
 b=cZepSxAIvMhqTvWz8vVAkXw2eri2kzy7TmTqHs/sGZyyjA5byJ/rG1Ayjw1/+UUzDyl2UG8hi8uMKa07QlDCrwjUspzyUmAozmjFNZ+yPZkr5Rv6wNEoi5TXStxVoo/R4JU0/Ef9BF7ibh06s4xRSz0rT3i+zPgQXjUjjv8XWgo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8732.namprd10.prod.outlook.com (2603:10b6:208:565::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Sun, 3 Aug
 2025 11:11:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.017; Sun, 3 Aug 2025
 11:11:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6.17 1/3] mm/mremap: allow multi-VMA move when filesystem uses thp_get_unmapped_area
Date: Sun,  3 Aug 2025 12:11:21 +0100
Message-ID: <4f2542340c29c84d3d470b0c605e916b192f6c81.1754218667.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 72075f66-d41a-43a9-7131-08ddd27e8469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r9FEUrJ2EDbh7s0SKy1xhAoBkMRUK5xJs9k1MhEWYt+n/YpVQekCGlvKzWRH?=
 =?us-ascii?Q?4hexeaLf10OxeRhmfeWTm+CxvlGsruL4LVXp1/khspdVNl/BN44iJQXbZc82?=
 =?us-ascii?Q?T3pWNbTFH1V+B9nDm15VCdHuUYm+Uy2ukXq0FFWDgBq2GBgvPw0UCYFwJRKM?=
 =?us-ascii?Q?rEMMoBmXoVUaXZvqdkEv0fyQDHn8HLR03+VKHFRdGajTadUYcumjvS5RAiKH?=
 =?us-ascii?Q?veg+JNkTEHLXAedo7rwNadXlkKw+dONNUiRZiK0JcG+L5uM5BG61nTUl5sOL?=
 =?us-ascii?Q?3najI0D0TjW3H7HTOCe8370M+M8oh6adtQmZJSSBH7p0VqcePvTLjDStRKGU?=
 =?us-ascii?Q?hnlLz6B4CsyxM2ghwoBcV5urk+CKJJUe65BvUhQ+6wR4SCtVOS9PPLweaxcT?=
 =?us-ascii?Q?hEdjHQfPqak4PzueogLC20y6P7p+QMlLOmEUXR76RSXOAwRiXCDKbgcvJVeQ?=
 =?us-ascii?Q?Zf8xXMlfDBTU+SB4FNMfY8H9rDcBOTrjMY7Ef35g0PdhOlWslV3pr2NF6uBh?=
 =?us-ascii?Q?/T7NN2nRE0L03Uz13cjICPbIwfXWnTlCg3xs3NRlMie8dQojWphYs0EOya6c?=
 =?us-ascii?Q?4uO3YW6xhN9UkdiFHZzqfyVCUtU59FqeQBDPzwUei/niqdf8jIlQV06e5Kox?=
 =?us-ascii?Q?bcW9smE4vu+KvMl4y/nNufdrZd/jU8L39abus4XBABGaVcKFh1XjcLqhfd8g?=
 =?us-ascii?Q?zp+Ze98Squ0r8BPgzH9g3YpgDFWpF0sdIPcqQXoGxsM4Emw9vVHGMVtZmgfN?=
 =?us-ascii?Q?qyZhYTEXPIGvbEnKXN3j3tYDmfE1Aejot7Et+vBIs9Df0pH4xayqW6KuF0KN?=
 =?us-ascii?Q?N65l8IiPMnOlXsTh10oImzEi4p2SEbLcr7Dzu1aZDncms1ik+GYTgdKUFavp?=
 =?us-ascii?Q?m/KZ5pBzD1eypQLWtU7Eq24V5qXOLKkOCzB374iSx4tjQEB1wEiruYVZjATJ?=
 =?us-ascii?Q?dLZF9AJYt6Bu8l+vDYW2DkSjqcwPceF65LDhp0VcN6iuR/xEIJ5XNVJAzaSM?=
 =?us-ascii?Q?EktgXD8heodTBb3cgXmfIOPFG0DbWS0l1lFBIRlQnk5uf25AN7v2tetOeV2V?=
 =?us-ascii?Q?QrIS6EaFYZiLlbRpTtgyanINEJDNZ9FampyNve699FwbKsN9YzwlpedKzXZZ?=
 =?us-ascii?Q?JnSSWTKK2gyn5N5eMXsX13malL1OJcFew2Aps/aKn1tgN8yxQ2qxxO6waYxB?=
 =?us-ascii?Q?YXo/sYBoXxRZgVTNyJ6UdR7TxNAK28UePbOwLnjaEPgHSOocgjF0PwZ0A6/G?=
 =?us-ascii?Q?ypu9myuONoJJAxB7zKhkH2nz/n9vnHTxdG30PfngGhtTgjRuzouHlw9hHJVR?=
 =?us-ascii?Q?1umawLcFKp63twFxzmyb8VVTqP+StV48cM9ZdFP7JpJ0Bs/90ZnFIx6oiolt?=
 =?us-ascii?Q?vo9PKG8dK3C4JG4jNmLCFSps1fnUs3K4qSxWkB5q8BHVW1G11hMeXieRVB74?=
 =?us-ascii?Q?nE0KBfbdi/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9YOH2MbHILmObihEciamStkQbpPAvPtIlGEMuc4hHMHyLCrMv4YNasGTFSFW?=
 =?us-ascii?Q?V7dgTLPUf2XsUG2y1I0nR6QhboS0u/L9T+ESZHq+HhlEp3KCH7ChS77N1Hm0?=
 =?us-ascii?Q?nJfLhiJTuSgpFVT1N+QiSkAgqMqAUebU2+A3Sv2UnyMHpK76WpeW7lQtZwvA?=
 =?us-ascii?Q?od6hUrOrRx6ApwrCOLYc8WXvWjtoWNZZhNN50GbeQWOLjspuEaMT8CPH/mbp?=
 =?us-ascii?Q?kJxZeiejKCPs5QXzZ5sgIDhjw2dCgxxF3x48uIE5I/Kb1UN8/swUUfOypKzF?=
 =?us-ascii?Q?EGUgTMdTwBVmW8GgGysxBEZg7sPQOe+ljxAu7hDyYrCfLCz0s8cwhdrOVqCB?=
 =?us-ascii?Q?VD4IlAlX6y+LK9sVhFEKnPvYy+8a/6lSEoMyOGwikcWudIPv4ttpL01GiQTx?=
 =?us-ascii?Q?5Yg66F8+mPLI5ydcvvPfB0SOn5G7zRH58J/mLfQeg1Nf0O41AV0Fd2QEsyjC?=
 =?us-ascii?Q?38SmE4/FCyYBwPC08hoel0IgK+zNgnOfD/rx640KVWfOSX3jWfhmNmIQ2BSa?=
 =?us-ascii?Q?Y4o/k4EKzot2lX9N45l0cF2TDFHkvQZEjiLh0y99+MfUXat5BrhnrazJWd+N?=
 =?us-ascii?Q?oEHAaAlUMoX57W5xqCQptN60rfpVtUTSW/1X0p6h+RwdsBpKav449eqT7STo?=
 =?us-ascii?Q?O//r29ttaxAJqSPGoZLSijjVOlRzdirXSp1Oy1aWB7B8JSPiiv/Yqi9mG0S5?=
 =?us-ascii?Q?koWtSsK4FD8ckP3Mkx2H4u+Lw4rVLEVr58KekwPqNaJNhviCwf6mVFj9BqIF?=
 =?us-ascii?Q?n7go2VgDgy4goIzinC67hIAwVJuB+erhitK0a+70pgwh4dkoCsSn8krLYS4F?=
 =?us-ascii?Q?SMPzjoQKc+KrMfHRxM6EKnXyk6ZGD5W0wjkUYYetYQVpKejDg08hXnF1ngGn?=
 =?us-ascii?Q?scMWglC4FaVY+PPkX/eNhfxNI8jLLXlOapbWu8Tzf4ezZKXChBcx3D0hS/54?=
 =?us-ascii?Q?MuLs9OxwYRjQefY7Cvf0As3SZW2l0PrJIP2bL9E20NEQhx1eTFVPNxS/04cV?=
 =?us-ascii?Q?7wvh2youI8uVlZ5lP/loV0Ayfmpzi97ft7H33cXOcWCrmDqebEBgLZyWaIuS?=
 =?us-ascii?Q?sm/DpLfLa76acWm9rpQrNU3IUnBfGAo/1jLVU5Qi4FeEZFKokbia3/cTCT6O?=
 =?us-ascii?Q?pPRBONR2WDHvazZeVGOIiujNMUMlWmTAQLmHYv/UUgjpKg4HHxcrWmQYwEz2?=
 =?us-ascii?Q?O65X9f3jZyanJ2+OVAP2hzo2fmq2+3KePDhfzFdyU8nHfaB64aee2AvRITD8?=
 =?us-ascii?Q?6/q9WpGfoVardBuo3Zyhjbr15j2ZY2h+S/R79t2/ORM9bBr/7x1y/z1RNXdw?=
 =?us-ascii?Q?uc1H50yjIyC+k1RvAde018+sdoyNGRC1XXYlcrBCz6+5IneLgTGtzyY3KaXZ?=
 =?us-ascii?Q?CMIuct+e/NOvY68Jc13AyXYGxxK39wD+XPrZftUZpu5nGtIk2xeGLKHZpBV0?=
 =?us-ascii?Q?0+5z8/Y9oWGUBssPJT64NbvUF+rVyWrJjfcpUaQBOFqKkju/cfV4XPBsPduO?=
 =?us-ascii?Q?ReDb5wWshxc8UBVuHAAMqgZzE9dbbMwAUK1hdYAC0655yDcgFIx0rkN1mG5D?=
 =?us-ascii?Q?y4roWkFqdF8P5g9oL7Deegiy9gCQdLfiOyYZ8Ddq/G356kVfsPiUtJl0mYWF?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sp4AvNjupfrkiBOlQkKglKRDyrVSqbeZvBJO+cOPJKle72CFNglfEPjNPQ/VBawm9IRh+qtpctUBdzk4QgZMPqoR6KVpdT49ZxvLCxrigjoS56GGfnZ3z204rIH9pz9aaFN25BSFQB6aGtXwE6ijGTwBSp8tPuEx2UKwMOde6VzmLR16za0eslrqtcVmTvf0sYCYCSqf/CV+m1U3YMeZyPDDBokAYLVeNFuDknin0LrmDdp8LAeIh9sBhC5Veq9+I5jisI96MciQ3NBMmX/peLKA8I+t+YWnVVoQMAPC0+dSotceHg8oAseQU8b2r2IzvCUDWB06B7SX0m+Cjk9DLZChBwtDQ5YynE45Gfxlh0LsHsBZxPgpr5yZsA4kIYauKjB/q2A98mmqUgREj6F2QwPNYMCMU+kH/vNCXkgQEAdlFZ/QCH6YhHBx6m+R8kzU+S0gf+H2mQywql/PrYc6mqJeMnZTz5na5MIVuej0genrlyqsvZRN1PQWsO1y3OQfJTG+4ENo/5VJVE/U18l5kXHxFmENgG3xn85iIUkGE/qSxSJw1WNCstHErbpVFh3feNip57B4tUMm3gf33Ma4t16BjIIMGoUOrTnPHgC7vOM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72075f66-d41a-43a9-7131-08ddd27e8469
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 11:11:38.6439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yQmCJRZzxWcLcCm14wQP/70cF7M+z763dcMPdB+LmfUU2Kx9tcZUp/lzW3EjO5Kt+6mccwSfcmmTzdRhzPHYaDfrND0tvCmIB2I52qH3Jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-03_03,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508030076
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAzMDA3NiBTYWx0ZWRfX2rrCGnaeK9av
 mDgTwxPRX/U79K5CR7fhLDN/Dpv2nqvLVWD5dQJc1WgDbNqW7XGiOpPeGTNpRcOWlhk5PASkuue
 hp+znyaGc2sZlVXR1PR4XFKzfZdbufxQV076THaN3kcwmAZYPbrnU7nDWK3++YKWGnEWEA35Uki
 VKivuPKJERVbEDrPsAaRM/FRWxuX7TB38Vw92F3DX+Jzw9wyXLvOQ6nm+1A3C3jGbvxwR/pwu/V
 2h/1OsgNFUKjx7cBEErBlG21XWCfjp7wQH6hEdEYTX6evkQQIbgDRM0zL9uRLCG2vnve0gHw026
 P23MjTlj2imDWyYHy/ANswQnZxJUkhwG7K0rf+hOEMT38UVJ/y+3SJeZF7h4nuUK65kLa+pZGh7
 3zwYteaS8fzEJDoxDLSjMjhPbqrCi5z0Kxar1l3W8Bj0t71WwrIOHMr7T0cQ+1O6DDkhK6SY
X-Proofpoint-GUID: oE1ad6k-wArXxoeJ5HiCUna9xeTo854Y
X-Proofpoint-ORIG-GUID: oE1ad6k-wArXxoeJ5HiCUna9xeTo854Y
X-Authority-Analysis: v=2.4 cv=VMvdn8PX c=1 sm=1 tr=0 ts=688f43ee cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=_Xx3-41EP-Rd5jrsEGwA:9
X-Stat-Signature: 4xset8rw9icwyoqmu4fejy6y6946q31w
X-Rspamd-Queue-Id: 0973640002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754219512-312611
X-HE-Meta: U2FsdGVkX19seHoXPFyjNYgC3fOJfcrCRDIJQmvzOlkXYhRSkCrhJ8wIMCGbT3OM5ZsuY7cYk3F1ov4mECael08Iu0zC0PhpRO1w9FzZsqzl8oKvtB88NMq3Pk4pd0BKuOJw8zUw/KIASgyjvmLZoiuOfCVX8HqvrnmlIj8OelTy7gRrMhW2470rrKJDH8bh6JRW7gnNh9OvIjAHiILrAKLp2RyxvdBZtxA/pBqPFEsFgcXu4B5G1VkIsnJz3hzZ4MRfLhEsbh/DTeMGeHLCFPZqxFSKI/Y1F8sXouUQ3aEjNc7coBpEugsD7npG3hxmo9DUVFOvbS3IBLhqDQ27IeE1WSeqEv7D2b/Rme2oL33bukNMKpjttEonpXIQFBvZZ+yVnJaL46D1QBa1Cz+HMHb7w6/DnXVUQ0t8Dg5CaCOvydYKhIGsfoJ/LVzY83spgNs1blfL/Bi5+rgHHiDCn1uGr1k7UPXQ5euWd2YqCVnJ8IRiyLijGAVGwJSI0rMmOLmysvl4rZHfwpUnBl0rJDaS6mJRFo1sPAjyu43gcMsJcPSd6t3GiN9Z6BObZ/eaNX18qWFAHtxOaaL/bAhpa1MKBkcCB9qaegbgjwPkuZJkyTXpIVugeN9Oxlh5yG4QbBwfFKwBOFVv5cOwoM8zHduIK9QJ4qHic5MxVeo+VEdGuPqLUX3Yos3KjHJy4bqEWQ50gaqdKqKHgqPybv7+HzeihBJai+VzkaBCergItPTdIlDladXsJpYTx46z0TwEy/uytZvzS3xJ3AOnPCPLocNXzV5U41grdEqtDaD7cIRj4Ur++ZCpzbHGCK7cVWzUvQg8ubB41x8zSszwpHv5uy8hTw01rAeUeJRgKJlW7Gych65UIgmuaoSqq25TZ3nfwH3nvOjBg0j4bk88cHU47O5jroV6R/sChZA2v4AYgl77PWOtjzRT0ZZDFZI5wmEi/Bep53OJAzOSh24ObUP
 5IETCQWb
 WoakIHVfh7vCgFvYvQT22RZIIsdZolBW0ISl2WqQNCE/C4NrsIjzzx60vzDRpE3rrdfMkSl8aUatRIDS27iBTN11Zxk0Re4rQMX0gj2G0UBX7iOak/ehbkXLiiiLvCqeLSjiVzswcYxEBXqvFA2zCuY4iVwObS66y/CgTPC/csTfUGN0vFp+f3RELgvN/VS5e9qque+YKzUzLdUwHL/aN90V4ElqDRSfmuB27hOvRywW8qL2SLsu54ujMVBGlTQOcyq+eDcyd21JwccQB2w4ip/sP1nnNUaNv6OsQP0dU+d/Gm1z1Rq+nZZeU9TX84gGvhHCoXANa9LzWAl3Y4LakjDqlLsAhz+r4oM/g3IXwqxvX4oHlGs2gCK8M6HWthl7Et7Pi9l3osSqMDp/KKdfYd0+LodnpEFXAjEVYVtx1BAY1+JQTOSPOSt7QLpCyEJtp6IzHei8DEU/mBnenaNbzt2HrPHWPRUfy9fR4EeW8n3Xw5vrOWxWK1SKd41j/mg/gdIMepiphzszbzqJLpclY4xILFNSTa3O2nmWl69QOxuN+bDoWz1oAtOaIukjfThtKQee98to8/Q2U9qB5NtS9U8mPRhAm51kDUdAQU19B2m7//eyI2hTloZirITC2rwXOpLxvywD9g9b3hU2MzULlJ6lmHYj05mvSHYIMx2hmYy9diJB6vXRk1kaKEQOjrt1YbVYt6X/fi4kGx5MW79ytFNFGfujBMplHvijiwz3AVXffYgVfgXK1bEnaeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently restrict multi-VMA move to avoid filesystems or drivers which
provide a custom f_op->get_unmapped_area handler unless it is known to
correctly handle MREMAP_FIXED.

We do this so we do not get unexpected result when moving from one area to
another (for instance, if the handler would align things resulting in the
moved VMAs having different gaps than the original mapping).

More and more filesystems are moving to using large folios, and typically
do so (in part) by setting f_op->get_unmapped_area to
thp_get_unmapped_area.

When mremap() invokes the file system's get_unmapped MREMAP_FIXED, it does
so via get_unmapped_area(), called in vrm_set_new_addr(). In order to do
so, it converts the MREMAP_FIXED flag to a MAP_FIXED flag and passes this
to the unmapped area handler.

The __get_unmapped_area() function (called by get_unmapped_area()) in turn
invokes the filesystem or driver's f_op->get_unmapped_area() handler.

Therefore this is a point at which thp_get_unmapped_area() may be called
(also, this is the case for anonymous mappings where the size is huge page
aligned).

thp_get_unmapped_area() calls thp_get_unmapped_area_vmflags() and
__thp_get_unmapped_area() in turn (falling back to
mm_get_unmapped_area_vm_flags() which is known to handle MAP_FIXED
correctly).

The __thp_get_unmapped_area() function in turn does nothing to change the
address hint, nor the MAP_FIXED flag, only adjusting alignment
parameters. It hten calls mm_get_unmapped_area_vmflags(), and in turn
arch-specific unmapped area functions, all of which honour MAP_FIXED
correctly.

Therefore, we can safely add thp_get_unmapped_area to the known-good
handlers.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mremap.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 677a4d744df9..46f9f3160dff 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1616,7 +1616,7 @@ static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
 
 static bool vma_multi_allowed(struct vm_area_struct *vma)
 {
-	struct file *file;
+	struct file *file = vma->vm_file;
 
 	/*
 	 * We can't support moving multiple uffd VMAs as notify requires
@@ -1629,15 +1629,17 @@ static bool vma_multi_allowed(struct vm_area_struct *vma)
 	 * Custom get unmapped area might result in MREMAP_FIXED not
 	 * being obeyed.
 	 */
-	file = vma->vm_file;
-	if (file && !vma_is_shmem(vma) && !is_vm_hugetlb_page(vma)) {
-		const struct file_operations *fop = file->f_op;
-
-		if (fop->get_unmapped_area)
-			return false;
-	}
+	if (!file || !file->f_op->get_unmapped_area)
+		return true;
+	/* Known good. */
+	if (vma_is_shmem(vma))
+		return true;
+	if (is_vm_hugetlb_page(vma))
+		return true;
+	if (file->f_op->get_unmapped_area == thp_get_unmapped_area)
+		return true;
 
-	return true;
+	return false;
 }
 
 static int check_prep_vma(struct vma_remap_struct *vrm)
-- 
2.50.1


