Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB96CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 21:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1842C8E0007; Tue, 11 Nov 2025 16:56:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135028E0002; Tue, 11 Nov 2025 16:56:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E728E0007; Tue, 11 Nov 2025 16:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4ADC8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:56:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B79C12CB2C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:56:19 +0000 (UTC)
X-FDA: 84099685278.10.B2C0360
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FD284000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:56:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BjIjut9W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Snj1clPY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762898176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qXAImXyPD8qxteDIVkDy7xc5U8ewsLkqaWU5gOOBYKs=;
	b=jGFfkUp03iO/ODyaCAyV2XH23eHaKXjhfGXAGHIkYSNrYJuXmaM6U9sDBVnbAQzCJCsjup
	ufEuIxeF3Tn3Nrab0HvIn3jzOpWzjzY6WBX+bHhVpTJ+j8g+O9fHLPxpg8kj/ElvaPRQCE
	DFnkuyYSXudQ38QYK8FkOEdO8TUQTLM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BjIjut9W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Snj1clPY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762898176; a=rsa-sha256;
	cv=pass;
	b=ycYwyTEYs/augwM6OMZBcEXfxosYvhvmgKtrYy/4uJuAx3nQ7tohXTiXrThhGuKjkt/URo
	IaKe1t2K4TCU5l4S7ieglZ7+DNCKydzFQNPJ3zyuX8HiqqNMqdkFuAqBcS4GDvPbiqAYDB
	9D8wkQYX2bcVJ1yxca/ZOw3rKSmTCu4=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABLMDJk029362;
	Tue, 11 Nov 2025 21:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=qXAImXyPD8qxteDI
	VkDy7xc5U8ewsLkqaWU5gOOBYKs=; b=BjIjut9WCh6Khv0Co8QPhMC2sTlAN72R
	Yp3f3l6Tv/52JWNrONq4UFCceo30QU38bDo1+VMqMIzkHdwY8Vtc3bN/2xhWXLDm
	KxoGvVfPfl8g+vBreTR9Ig8yuxMuWschza+tBOkurLBgCWHVRqk06G4+TxRsYIws
	TumVY+HrySuICpWZLnWd3kvIreR1ESmXNAWhbb11taqVfRmR/QEgnnHBsYssAsEa
	mQY3ZYj4amzrQqYMipN0JKnu8g/rC+k4eVqAa+tSKxqeV89OKFsd/k6ZtLHeHuDe
	jupguS9inXpI7OmJBQgNHSwiN0Y996cFbscgmCFzJB8PJcukvykh5g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4accts81w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 21:56:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABJFmWt039926;
	Tue, 11 Nov 2025 21:56:12 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9yd9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 21:56:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VVMiG+bnYpf2heqE1uBwGfFTxHjh3z1EyVlYIOvmpmi3NH9PkXhz83uVvsKv16l78JQsDa3Bv7IN3j9E1unYGJOgOnZPARtPAR3t602lfZ895yzXVewRM1q6O0KB8fyBKweu34T/TYcxIia1YQsCuXvL/jm669mUK0BaeB1WpVAZkEoowSioKkxdPh8WOpSnHi0a3yQfQinPnrx+6FTS6IkOCTOdhmWtu2qBIxt2+FYvu1U+V08gK7QNHfaqzJCWfB5khxggYW8ngI7vUmomR1An/rwGxEgm289umkyg5uB2Kd0T6TsJ0SRlSyRNzIs0vJ1REnlvX69uk3eLMRfjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXAImXyPD8qxteDIVkDy7xc5U8ewsLkqaWU5gOOBYKs=;
 b=NnodywyNWqTxTZVMTxG6vODwuk7qf+XY/1NkoUeN6yNz6ROSSMr6X3XHDUT4GZXCgW2kHoYunczJPGJa+i2XHgnNRxaT0RyUT8UwaFC0VIheWvKvvq1IlI6vVBb8g7GgCqvB+/1R79VK42nxgdnGXuUZr1GRkCs4qNpG+4VOeLXAbm+NegKn8YGEyH0lACvMQnpUQHpTWRUrlOzdsxi7vFk+lGBIW2GaWurHxGnYSVQryaQWn4O6mTzNTA+Km8IbyoAkb3VtHbv+x2hNRPeyKkwPumS/oJyKwZetIiATk/zi0jJZRX3K+kf2JF2eFaOjR+dxX+SfcIKFWSNZaumVyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXAImXyPD8qxteDIVkDy7xc5U8ewsLkqaWU5gOOBYKs=;
 b=Snj1clPYiSVxPIt3f5emjrohefUMQWmJ2VhER0r1dGRE6lIY870HchlpoNbmeurUSb498LQEZCZil00arxO/7yusb9UZbsUQTUlY2yftgCfrQDwsi+WSpK6Rj1x/DOc5wjW2DsDTW0PCD8UnjCmzWtkfq8lSdaS4gE27srR/W/M=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 21:56:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 21:56:10 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>, stable@vger.kernel.org,
        syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Subject: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu() retry
Date: Tue, 11 Nov 2025 16:56:05 -0500
Message-ID: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0444.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: cb91ee68-fab7-472a-0aa4-08de216d1f82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UXJDQaw+JR5mvBUdeyp0ajYsSVyj9OnqhOsYt2EZKr27TprhM+K3o/vGG6ty?=
 =?us-ascii?Q?Mz5g80tfC5VCdIH0/4QawsukjFu5OdILU5hufdhmJD6+gWKxeJlexl7/8mps?=
 =?us-ascii?Q?PHELzX/5Y25xNOy2Xyc7M7A2QiVpH7NgCDAYXSfJwf1m9QRA8MVibbzE3iQ4?=
 =?us-ascii?Q?tRSSMyeTdw+Lw6s2Iozrtx6CVmPJ299fRLOIath+96bKWGQe3bMzOsFtW4nW?=
 =?us-ascii?Q?zFs9XSB2zOiPcy+3Z1YBx/HFEaugy2ZVhsWMCjY6WhdmpF8t1b0tMwOicJmy?=
 =?us-ascii?Q?v1MqQcjcndQlsCCWqrI77U0DULglSTIYAn/211dtG6V3HcmZDG/wGsaNRRZ5?=
 =?us-ascii?Q?FYNpNQbNnSxSuGznnjNcg/OvkA8tifurK8ko6Yl7RLZd9XqR3ElPHu5wvSJi?=
 =?us-ascii?Q?2dsg/NwlE2LzUVUk9ibHQ9x4dPquvjOcVxknxz8aS8kEnurEHUL93qy+gfnw?=
 =?us-ascii?Q?eVXMXDcUWFpiRlQ5hL9px/q14ZWo+8uzm60h7XNGMfGhWQQL2XC2KjQghoMp?=
 =?us-ascii?Q?WqrSZpLfVy/Xkx50ZiWrO2nzjbJ/kG1BTOjmxuQVabvE1zmnohM8Jsm8tnKz?=
 =?us-ascii?Q?ZGVBXrvkUGzG9bbPWMXPJ/oBfHU0BDgNp57vuyliJ9Wy+p4KyZuAe2Ymk72V?=
 =?us-ascii?Q?2ya3yzyjgtrZM0Z6opFIGe4cyQnb8d1+rdTgEtuNnJOs4pEemVhWWC4Wqh23?=
 =?us-ascii?Q?r5BiKnF3kWKFAKE48Vl05mPLF1ugxMMpkIfch859sYyjgFUWCkZG5eomn/qg?=
 =?us-ascii?Q?x/q9vdRwIQL5/AOrK1G2+w3UDVJZUtPpNZg+HQ3NZzSuCZv5cs3i85sp5ckt?=
 =?us-ascii?Q?HdIzUNSxl/rv90wfpOgGcmNTimfXC7XykFjfSCS2BbqElcg2ZSDGdeDxUz9C?=
 =?us-ascii?Q?pglAxAPoSClOwz0C9oeNk3QAZS7dG/4TA8PVlPFfvwbR+7IE3mijDHH3qO0+?=
 =?us-ascii?Q?1Pf6cggXOlzCeQ7lE4xu2+zdOeoxthUPnZ5W5VfFFS/2lCAKgwwvROe+BBIk?=
 =?us-ascii?Q?/JawKd75hL1+OMPJQccRaJwDfchlZi3i/FrFJt4OzzEJ2VBthGam6VZ/lZQj?=
 =?us-ascii?Q?1Gsa39jTkRFbBfCdEnXQQHQK5BE5PXpdjMqJSvABrUA9HrptjH0p9wS2rNqU?=
 =?us-ascii?Q?wzzIW5kkZwvRmbrRxS30uMQExOT+LIy3vNhYp+Wuc6X5EY1p5C0MKsDWJP29?=
 =?us-ascii?Q?IqYymTbjPg9DjSaGdCh6szwGko7GGUoDAFLE/s+kpV0TtY8E/pTPKWfDvOM7?=
 =?us-ascii?Q?kq6u5Kt7Ykr3Xv4ECZTcOuChGuznLW+USo/cI3HFlfb+BWYP128/9iD1mxgP?=
 =?us-ascii?Q?hbJZXbbH9h/ISc5hLeVYPOadST3X+M011KZRWZyCqJVHWDxOxEIS9kEVM4og?=
 =?us-ascii?Q?QeTDmsxWnj5aCn8OIj2DLTi1No6tPBg1GjNuNmgnz0UoZG9+9A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sv6N44kum/MnUvjKA+fWN6j3Y0o1g/+CejwAeN+38uGuYG6NWfJgg4OHJUsP?=
 =?us-ascii?Q?ut4HT4LPE7QqB4+AVVWUy/KqHbyvWyTscOT9nY6MW9CzDCOnoMx12YIRWDAc?=
 =?us-ascii?Q?7D0OYVdgMh939uOD2p3wQxJBe0WzN2Sw4S73mNDK+SzqhoQJ/pOOTZENcMjQ?=
 =?us-ascii?Q?wP4WAxkXVOz04KpPSeyTOGJ8Dl90O77L8/hKijfZEiTvkGn7Md2tWWMoItwj?=
 =?us-ascii?Q?fxRwnlD4PbicTqZ0fNiedoLTVk/lSmU1Zv3Uu+H5SNiFFpf0QBs7pPR9inyR?=
 =?us-ascii?Q?sDnDjIgTEN4IsWyntNKGw6vWqyTfUWYjlYOolX5OcibzVgmLlwA07r/URSic?=
 =?us-ascii?Q?kclFN2YQCrMuQBA/NBI6Qc0bbCnmlJV/6BDvIrRTx/pDkdGPyEK+Mj4BFiyr?=
 =?us-ascii?Q?9NgZ1K6xMXa96XqnO787XtI4xrVZkCSl/tFT8NhTfIC+MxzzxlWX1URSA4no?=
 =?us-ascii?Q?orfBn4fsln58Z3dMozk+Z9uvZO6c+HlQgn2HUPGHgrP9Ngt3T3Q5OmMi7++q?=
 =?us-ascii?Q?CGx34oJkkGv+NdPN8oyglqNLvNlxqIh3RSW/8WrrZ1UhF/9IRwZDdhvBMzNi?=
 =?us-ascii?Q?v8Kve8B4FSI0ZXCmGrqKyJbB2KLyOtcasQ/pkuGtWBzrfKrzIS939MFXx40g?=
 =?us-ascii?Q?kY2nlw81mszTYEZRKr1dsxWnVjKb8O/hqDSIfoNNuCaTG6GqbtzIVYeeiZDz?=
 =?us-ascii?Q?D5myHhq8/HYod70FhoeOfIaJSKjybsnncvPms4rgs2WObpkOPq0WyvB7HGLa?=
 =?us-ascii?Q?ob/V4oay+D4Z6moZyrkE3SnNo8RsbHkmsB7rjG/KlzRcEbl0s0TK0211WdVO?=
 =?us-ascii?Q?Bd/N3nP8r5q4ym7K/z8pjSEtXjnwxrO+c/W+IuetZ6st3i0k6uqndjBxLMpT?=
 =?us-ascii?Q?BK+C+bg3416IzItXtB8EGFQYL9+9I2uzskVCwOtTb/CEWNucA7NzsyHkE0vN?=
 =?us-ascii?Q?umVjLzhNdkgZwAmVjx2apLxASzF6p98w+OHT2wtXDIjaceBoab6d6hG+Lfef?=
 =?us-ascii?Q?Bs39TmVQrVWRUETGLGZKxnDRoogJRKDvLoXeLLsj+9z9C6Q+lAkfUKFN5hAP?=
 =?us-ascii?Q?uMPpERfYWCbI6NyiOxnikBY0M+xzYyIUs5pw/28E7dMAR7KDBOSS0/39dwZx?=
 =?us-ascii?Q?Ipd4j3mJw23TseXPJyNHnC9mEFvr3b7xiuxmOjxTRYcfclYA9TYt7urvSZqg?=
 =?us-ascii?Q?SUV7crwCiCkzG+I7+eRYIIu0SOvAmXQle3RmWeUZFfv+kPI1FF2YJsiCJ/7C?=
 =?us-ascii?Q?b90+WfhQp+xlWm6bjrThavfhU/3ZLnKiA1vmgRnQ+/GMRDkYpGrfkbBLtgs9?=
 =?us-ascii?Q?oH+ouAM6IGpex2140yRWkvI4zWV77RlLpkKEW2eyBblB8gufh/X5V17WjuLU?=
 =?us-ascii?Q?et6+X6RlPOhGhc/+QLZKVk5X0b1oDC58470rtgc9tX8mfNNpv9IFbPECCPJb?=
 =?us-ascii?Q?Dps7Vq+P0uzcg48WBAYGokdi2GEgJbkl3Bstl8W4VK9V9GJdJx/H3K29NdP/?=
 =?us-ascii?Q?zk7TAtybzwkkLugXnZjY6h6Q+Q12fUjes1PHgK0Xwbr5pBhBbufIuxqb23QW?=
 =?us-ascii?Q?9nqP9tMlqU6VNn5T0a1PWp7bkGIzR+WuULKSszrl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TI8y++p7nEby3hYZc6pfxDB4jLwhHCT9PekXx/Qq2VapnPYj6R0s1mlIKlWjHHaII8cTvps/l55TD5oOqU9VkTzBAqgjNeiBJ4HM2LTH333IKRLfY1e3G4Xx+DlYAmye9Ok7PUcX5CrqMLH5u0gguaYxt5hKT8sn7G3EjOoDCYREmsUREeeoMbef+SE+0lQoOsj/2p77WUXbObdnGN9tgY/sLYflJs6cocnWZurjqCGJ10tCui/cfA2ebi2OPDYyzxD62s2sXWVnmKQFmprn0YdUeX7lr0AahGvbpdLrlYIxbh5lRg1boSqtkkstTLMjDrX3+4A6jNRv+vOmIq31ApbofYWiHjVsyUNu29ncG16AY94SzWC5eF1/QaMfxaJ0SBXAUc5atjXyhfow30kwvSj5rGd5QJy4LvE45ygCLeTCRHgrVZI/4n5vG9+Fr1lOPYgI7m8ZUmEHZ9Vmzm5qou/9ugbStJI2GhPoKFyQxiSj51WTsTEawtCSXiuhUfj17M2cdq90zMSgG+4J9zTL74rLOY3JJhWltKcU/V2jsz1nCe/hSny12o9lH1qLdVz/sV+SM1buJL6Bkts+yHBfVAliJRWLaAkSHHeSsxP9qrw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb91ee68-fab7-472a-0aa4-08de216d1f82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 21:56:09.8454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBKRAGKmHjskCqsM8Fq1oPfUSVQWy+XWu9ZroWtnr5Cr70K385f4OSSJfYdorVV2HIxphoWpclHswN6tVa2+KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_04,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511110178
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDE3MiBTYWx0ZWRfX42sRdUu3S3RK
 AW88i4Pu/9maJr5S9GYs8JZZ+p8A0Z+cWUrQyDTc/dp5XF0gO06OtqfBINwZrxweUU1WBgLdtq5
 0+eI93QPqt2UWjSIQLqlp7L0lPS07AKyR+NFE7ti74Yh3FQr2i6Ia+nrMx0MI8hJ1ejFp/ZDkGN
 jN/hRci1019IQRQPi/f00vwW4Uc+mK8JiTiCwfDfjJF3PR9L4XTY/8JfdhQcI44ue8DlumMt9SR
 6XzcHBcUJcw/SxGKepwL4CV1y/19iDU0+Mw6XGHqBafWdBEy4wDYeIM8IfBjoDC/XfRDcVLITT6
 ZtTiKEmqrKwDEaKxdx0Y6EwuklCvpDdYcQKJo/dCnspc8EeCrB0sBDd/yC97Ve7vMrgzq4KeU5e
 Ot9KbUGUykvv33uZ+UrF2S5GG79UoA==
X-Proofpoint-GUID: SECi2Wx26eEBHjA9TZ-oFeMpUurxYGCx
X-Proofpoint-ORIG-GUID: SECi2Wx26eEBHjA9TZ-oFeMpUurxYGCx
X-Authority-Analysis: v=2.4 cv=BtiQAIX5 c=1 sm=1 tr=0 ts=6913b0fd b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=edf1wS77AAAA:8 a=1XWaLZrsAAAA:8
 a=VwQbUJbxAAAA:8 a=hSkVLCK3AAAA:8 a=yPCof4ZbAAAA:8 a=rDUhUsTXIQp9qXccpckA:9
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FD284000A
X-Stat-Signature: opep9kooc43kxtbrtxcsfs6jzitb15fm
X-Rspam-User: 
X-HE-Tag: 1762898176-698351
X-HE-Meta: U2FsdGVkX1/Fj2CH/sfoikj8TFwucerZkwTqdrmIt1bG6JhPb1uNg9BbvvwAsTTl2TthFI7EBvr5yKGzPltpMWq1CyL7fuutpYWj1DNxqgeGHWUBdy5YZ38CBJI7i66b0iLTc7LWhx9iLML1WWJ/VyrCtocsIPAYl21OVfd3IBikQ4bD1tFmtptBASSTvWkuf9MkI56miN1IjKdQpkw6yjhQj9w/+upcE+5/oJk5moutRNemB/jMdvU8x3vxYGheD+ULMVuzyj0R9UNesCHkkpm4j23O/NCBNJKHxRAp63liyFnKM+YRXK0+dlxkoh1RDrPXjukfal2zPWWxcFGq4pGZCX2HyM0cwXoRUpLHlwigIS/OMzbveeIXqARWlnKcv+Of/1G7teCoGtpsjqYI9EOf/ovTiR64ZPviKxR91eUeMcGcVcwWj0lsKOlifO1MpK6N+eCACnOy3JdAHCp6hOBg/xSw9OxhsV5ktLprWIEWc8jWQCjElqhjE67gD4kguY0rJuLILFeO7M5HuooRduLUTPrDQpQoQGS0A6WXbbrvzGwXWT6U/FuubHY/d2bcAdYqGbxN73Tihjqm/5Z+hw3xMUmmP5yZPT1e8Z5bvR0gJDa6OrhQhUSp+hiHumSlDQ6zIpJiPdDEtR2CjlZXKArD1bVv/RdIQaHRSyAgeJgyYjGsPWDunBY6sZD902gzLbNvPFoRzUdRsmDlG9mm5VRXN7VX3m/0FfruyhsHuxkSGpfbCnuCTGeIerHp+3GKyX8O29wNWAGSpeNK/TzsqZHRO/UPqYk+XfAvT1JP7WAavkucALv4xojXXOTJmt0ac4cGc6BNMYT/oRni/ZSjYTOV+ykEKAZiaNuQwDit+n1u1kfUEj2wJsFGIYX2ykIk1kBauHU8JUwAPkG/MVqgFA5dNQMJd++8Ki5j1SVPlak7HZGkR0eZVjolnzpiOx4KH59OC8ZFxWMvNSIgsJJ
 8rIJZ5Ys
 +BTIVcZD/p20xNUyK2FtN5N/esVTivUQ3QsmSv9HYsextTbR91zDWE7TiDltDX+/U8PtUYiWEswtrJ19aAxPjf/cWFjEjf5k58BDH27rm1H+Kb8pXjY7gZo2dj1/kM5GVKvD/wmVBDoFt0hxCooYk9HQZDSaCbMO1Y5W08O4b88ru9Q+4/EVNAxlKryWN1GOlMwM+THWu6NySy3HcxCkmPBm7aB6MrVygFk8McTB3uhPFIWqQK3GPVt3xZjedJefuOtFVU+mCVWfYHsjQCetfF4C//xnR40K5DXE17Kih6hyViEvmlKiWT4/Wx24M4Cj34Kph2/MHpPS9XDpdGwWGA02iWVLuA4aKQYxltDzGv4v2oBcNZ6vItSLO0LGiXr9SmpQRL7YVlAvLBmSZtGuN0Q3uHoYgh6L+/L6VYJua1X5fEMB/gamIeaZLHvMvrm2SUt6B2fhnSwgjzDXBEYVuWNZ9onOPYXOG/gEWTNnreC75z0x/QbHTr0chRpVFFf37UkthSaYF/DpKGreWKQOy45EuHYH7As+i8qmUiAGsa/eAy3Hn4vP6rzlCZxN9cOtqqn5UY7HSl1IM35/KNn2cCEuI7OWwROdjRGUr8xUzic54KstoPwCRh30QiNrEQ0X/hjV4n4gudA2MuDrG4UzbUYB8peHXjqg+ne6K/St9NacUyU+1MhPuVGsobK0QQbU9d+zYInHb14RpJWdjAGlvpJwcVP8RI6w5WAmcUbxD4Zmejh13r6rQgIEHtMaYTmY9iNtxOSWZSgiOR2+QKOBaTYh/iocWaaj0SMPt5R7+xZ+BfLaWp9sBW6SZu+kliTNYD/9HDEc7UtDpIZpRV//WCPBJxbu+qabwrcqpnWAgeak+pHPQilxN3HkV025eE75fD/Pb9UfzLrFhXweLCxxSgmIq4eGHXDczIFqCvClUmu6ckHTu6exJib8tdYU2HXJ9P0DLKAE6L4IKPqGVhAMU8RFIwFng
 hQc9tfsl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The retry in lock_vma_under_rcu() drops the rcu read lock before
reacquiring the lock and trying again.  This may cause a use-after-free
if the maple node the maple state was using was freed.

The maple state is protected by the rcu read lock.  When the lock is
dropped, the state cannot be reused as it tracks pointers to objects
that may be freed during the time where the lock was not held.

Any time the rcu read lock is dropped, the maple state must be
invalidated.  Resetting the address and state to MA_START is the safest
course of action, which will result in the next operation starting from
the top of the tree.

Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
lock on failure"), the rcu read lock was dropped and NULL was returned,
so the retry would not have happened.  However, now that the read lock
is dropped regardless of the return, we may use a freed maple tree node
cached in the maple state on retry.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on failure")
Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=131f9eb2b5807573275c
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap_lock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 39f341caf32c0..f2532af6208c0 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 		if (PTR_ERR(vma) == -EAGAIN) {
 			count_vm_vma_lock_event(VMA_LOCK_MISS);
 			/* The area was replaced with another one */
+			mas_set(&mas, address);
 			goto retry;
 		}
 
-- 
2.47.2


