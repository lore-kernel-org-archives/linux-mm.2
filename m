Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D6CD262BF
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8B06B018E; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3036B0191; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748766B018F; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58AD76B018E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:51:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C9CC160290
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:03 +0000 (UTC)
X-FDA: 84359584806.20.0BEC75A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id BBCE340004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kPhu3XAb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KZPPm9Hz;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZPx9Cgo+BtdSemhmhSnZT+VNAK0JN8lcdGWba89ZXU=;
	b=BQ0cpD1E0gpL0r3RMmDRD2aDjayZV6nPQHhqPiR4UtZPCXl5Mwvy/oFTTfGgZjN1nJvf9l
	K2QsZVZoK99rEq39+s0qrc1fxCa7llFskD1cIMT/U2eZF4IwHwdYyPjdf7KMxpLuT2H9Eb
	/WM7nWZJLO6SsYz8pEX/7wvv6DUWlE8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kPhu3XAb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KZPPm9Hz;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086259; a=rsa-sha256;
	cv=pass;
	b=WdyzK14znrpdrw/YHLcK5z8hqWB2yDAgfxoAA77g7DaX0F+bPLZjPdMr5VpncWqFbFl/zU
	lM+w/7+AQxIMXjhvbXjUvIUvlg92QadRHrlxI0OImyXBP7fsrXCRY9U5C+11s2ggFliDL/
	MRoocbIzN9SNcUcBTTI6YJSSi4u1XDE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LLrHHM421006;
	Thu, 22 Jan 2026 12:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vZPx9Cgo+BtdSemhmhSnZT+VNAK0JN8lcdGWba89ZXU=; b=
	kPhu3XAbehgG0YmiMGgaQdTVrZRX32YvfGnh6bEn3lsDXETYFo8s+PVxAP0ZofHC
	57tCMJjeV0hE6HWTlLdBqgGa8Q97pd+uCfi+nWg4MD4rg6rsZcLI3UrgYEKiJHEZ
	/aAsYD7Qqf7dGwCRyrd1ZPKFt6sj0sb4O3P86rqRunTxoz2WQqnhiB/+z31QpkkA
	b7xFM4hboECrsA0PV00G+E5MeOw17IOK8fdRI+2CZZ9I3kOu0nssEn7pRRSGRZKg
	8+4nb2ja7IleiyGK1ZmsxqSyrjGxBnaHEVwT08tV8BHaQwcKVSaoGQ/+KekhnRMe
	rac1PRu4/31URBESbbTJ1Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcv7nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MBt33T032828;
	Thu, 22 Jan 2026 12:50:50 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010065.outbound.protection.outlook.com [52.101.46.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgk1n2-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ay5QTFHSsq0n29AY3V8AIHfVNYibJOga+DqC82RMPkDT7AbEpyI37RkOGS2MdCqbE19h5YykroxWK1GaKKoIthCMqY/kkIgBiDfZrgy1/eZl/QmcCyoHZd+flwjmkFPIp6BIyBRlB17Y/ODveY3VhTY/31F3KjbYZi6lDpBnvyepHP76vgKRy1ER13t6sXUkrvVIdHFu+i4k58naZ8602FG/pFveN4QZRADXEeNFMJuourXPnfPuW6hCUo1ZIOAJBANDXaRZ32QXiXX+LqLMHX7ofHxsKmqxJRANdeqUc4EAJtf3VWfclILEHnjwVX8KacHc8cqHZEf9ruMqXhyTZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZPx9Cgo+BtdSemhmhSnZT+VNAK0JN8lcdGWba89ZXU=;
 b=mbNWcyhQpAeVk3VFolOUDzXHTm5s2YwjZb8CnQGfZQzcPfWY4ILnBnKhdS+RtPuxNVZ22KP/txfy/hVS0J/Qrltd+z2ygJ1eHOScbNX/9GTq45M8OEs82YHpqmqjWqYswqsXDpGyKxjtqH5hutmlTqP6p9ORA26O0YFWR/+Mtif7NfDIJ5wjDIzQx7jK8jyOgOATFGFzcAxY2WDKWks2YLy+fvIAehfkTY2m8dq/YIlP/XcWxugvOoTfaOLoM6iHHqqCPpGUFC4SXWf4esTEc/oGtICUwDxVTZn8XmZL/UY7aE/eAFTmEiG93IBs5iGX5nkRg+w3Kt1XLZrF2G1mMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZPx9Cgo+BtdSemhmhSnZT+VNAK0JN8lcdGWba89ZXU=;
 b=KZPPm9HzDnAbowAsj/4fSCfAjbvVVfi1wW9lyHjgaLNl7bYdnPZdnNTI1ZSQxOe6MnyfjfafDzjoU2craSnRUKlbVG58vHVUBt4XcF/BO8w2PYuldZqWCyMsyHG4XY1hOY7LomcvfC7YljofNjuCZsmW2b2EeIovNeJx5WxhK6A=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:50:46 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 8/8] mm/vma: improve and document __is_vma_write_locked()
Date: Thu, 22 Jan 2026 12:50:28 +0000
Message-ID: <70dcf80f79ecd00a750ea17101061b0949119429.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0094.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::9) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: f5aebb5d-0fab-4820-eda1-08de59b4dcc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Psluv5NVeX+k4PzPntbWd2NWGAbqrG6bhFsvwyYb/5ZmbURXWEoVWpO5/gfL?=
 =?us-ascii?Q?lKzyj45X2PQFia1+vsQCoq8Ubic7rHdvV3UfQwpSH9bpYouZioKgTGtw8ASE?=
 =?us-ascii?Q?FpknnGMvYxhMWSu6YNZBNagDPo1yyQYVJPg+mtiIgeNa46k0KQLpgsoV7pOu?=
 =?us-ascii?Q?jO5p0K+QcM2aU7/HQfW8xKW891bIL9fDQOWK2uJAmbmwhcxPjWu/SeSgJxzm?=
 =?us-ascii?Q?y497/S3kRF9kg2KHBPUgO2D1qPsa/TB35zbGLuSKTyL7hKEaZMNnt/ebqL7P?=
 =?us-ascii?Q?gYxrkHXmf+6iJF2glppyiGRrS139Ai7TyNXc8or26+E5Cj+xgKGkpJSb9LLe?=
 =?us-ascii?Q?Nqt83ZJhlDiMgYYkGs+2dhLLN7ZDiTkmw6sRVMpbz9UEY0ytHlpMncYdNIFh?=
 =?us-ascii?Q?YYUTJgJDEuFsfbvC3l/6a0Hh4FqqR1C+F3t/ogZhLJFCApOYk8yrBQZL1SwO?=
 =?us-ascii?Q?GC3c1rsl+Ow8QicGKBrRSzsps4vPa/nsd8O1GHan4whkhu0L6RU5UJN+X5Rp?=
 =?us-ascii?Q?Ete3kizvGbar6RtHZ9Ox9RARS1F7a0FEYgh3MAZ9qxX+3dDt9aOOg1SZoTY+?=
 =?us-ascii?Q?Pf3Ba8ofQcD1XN/LDV88u+Dj/UslCqa1T6RL7eMr0XakFgxVhrSf41IC4qmz?=
 =?us-ascii?Q?/eptWh71Sdb4cSx54gzFEEbrPe/o3x0HX9oMhWxINwouwCHGH8CwOLLg7H+1?=
 =?us-ascii?Q?/dLaKuPXo4uQnlGj6QTRvY+pxq/dtJGh1FNmTUuEuQh+t88Nk7kkqWzQvFFh?=
 =?us-ascii?Q?63gOs+rEhP7ge5NyDiP4+DqNkjcd8ROPct2l8yENQyaNrlL9b4bJzpTbDzhC?=
 =?us-ascii?Q?FdGVvVjizBDNBuWUp878yr3x9kINYJgU64FCn7z6BdoJnuTemfqK+LraIxxz?=
 =?us-ascii?Q?ZM7+y4asxqkA8euriN0m4GZQt49go/fIKE6ULKrN+6vbipRhhWrf1kVy6kJT?=
 =?us-ascii?Q?VWllpItaz9FSTzl8rNAYXUZQSB55VOyJmzPGU3te7kGJcA2tAKPcWK5n0Cfb?=
 =?us-ascii?Q?rNTgZ/N+6arli8iWKqI3BKxuedKIR2uvsnBBlbPB3CMCB0hax+RqvBOuMnMW?=
 =?us-ascii?Q?u1sX7OtZuTJWr1FhRiUN8Y7aXG71XxmLg4lUudM0QmEitwxXKkbO8Q5zSIUL?=
 =?us-ascii?Q?K0PXvbl8Ci8bHziLJB45o0FPcKgtQ9qLpTafm/1n0noYYMDYTwmJJVwmZpnJ?=
 =?us-ascii?Q?CjJqJ2meprmP34HVRw3mmJa8DsMGL44/eaRN0pDCPM0QNsxX34Etu+sACbL8?=
 =?us-ascii?Q?vM6mOXvBUn8zfBM7jqCRkMJGLWWV+Dn58VzAE3LAn6e/B4cBokN5KadBvVjc?=
 =?us-ascii?Q?PA5FP7xn99Tj5G6tJYrpVWXhAgOqvDkWch8s0k2Uf9y9jk+y3iIHlUBisUjY?=
 =?us-ascii?Q?dP6Ti8ZamWQPk+N/9bU/HesJanAXOnRBMNuHjI2Pi8ne+mh/Zge+QbBCq3TK?=
 =?us-ascii?Q?SYSrKLwzEGhc5JdKdDuF6MKn/4Yytr0ao4XufyECEZRrdiB6w70ufbYExBwk?=
 =?us-ascii?Q?mEnlzcE5SeDqFOmgbewn6axnhovA2rIQlTo9z6LfogTryhrjtTfBsxOaYa/C?=
 =?us-ascii?Q?BoP+SWRUngCCniwYXvM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hlRGedhRhO4EqhC77sCoFUoOwJm3XdIRpgwDhmG3EQ2+eklzfQsLWfjVQadf?=
 =?us-ascii?Q?72PJ305f528kGDR+/2/+qGjoqB4dEhnwBf0d8wg3OEjAxcEAS7JWr+i7Dm3H?=
 =?us-ascii?Q?nSWJcF/fefzTWiYcvrIFqsx4KgWtjoB0OIxluAxaXPq+xDTSPhJKwerhEUKV?=
 =?us-ascii?Q?8+SmxLMLuIF5/o3EmlVL8HZchCVPKXBpI+1w851PtP73rCaK45NeK0pG9Bvy?=
 =?us-ascii?Q?OqaG19lJuU+3LZvC7fnPk4DRvhYZj9Za1hDdvCAzm6SKsr4pM8M1frJgX4Qy?=
 =?us-ascii?Q?vMbHqBMJzFXEiJnOeC710PY2uLQeIDyNXwyMnhLWiGG0SInJBLDvbLsX1EUB?=
 =?us-ascii?Q?fBqRmycXg9U30uKHRxQsI3kAgKRDa/Tgt6UdburqrSOTLLoVbMNTOzPD2ojH?=
 =?us-ascii?Q?9xHdx+xz6M7Ijzx//KaZ3fp/dkg87MJsYy2u9TIOts2cPdw4OLBlPZQQIL5J?=
 =?us-ascii?Q?CMutOfBaXJrau5frNNn/a15HD2fAwuNZ+pj+aDqu8YpS9lHU/NKxJXKCVre7?=
 =?us-ascii?Q?t801w9zbPMBNTx0LPq0P+dTuIVs+ajoUM3buBjChWLf4+yCB31SjJnjgWMZD?=
 =?us-ascii?Q?S7UQbuDwr9Ty/I+ZI7LO2clW/BLieGXONSwDiYLE3qwe34clCFOtfRb3UAv+?=
 =?us-ascii?Q?Sh0y8Po0QakxjQq4Exg0vH46pZA8mPKZNSDYUa5Emd0dXWWW5crhiKHiNcrH?=
 =?us-ascii?Q?euvSValcOyjNqgChwrCFY1Q9RJ+f2CnzlWk3ii8oimASdh7E6e2OBltK1Mtp?=
 =?us-ascii?Q?khPWAeIGXC2/0Vg1akpbV4msgRKr8GQD0MekN7B0oSRo9eLTD+OMJaDlHHII?=
 =?us-ascii?Q?4VlhKwin9poyLo0S8+KNt/zUvLSo/9tcIV/sliFs4/zY9JnXfyjA2tn/uPvG?=
 =?us-ascii?Q?ulJPN3ZY5Q+wZZ7UggAlW6wg9u+EnaOOw1bHG5E3FFTRZodH+Bnmr3w0R14C?=
 =?us-ascii?Q?HW2NRaQlB10rZ72UgpJXeRGkLIbIpc/TVBSnlz54xxrBqGvkderYJaKi+Q62?=
 =?us-ascii?Q?ZgTLFGfC6+M5xdBJFwLD45z4XnDBu0FdtYWZBroInw8IfEx9tjl8mA00LPfg?=
 =?us-ascii?Q?3SO/jyt+y7/AOD454AI8ffExPW0xnAESz+XB9o3rnIrpWJvNCN3QFPpQJlma?=
 =?us-ascii?Q?lUgDsDCvUJkmdpyCH3yPOyVdrZ75LSWPDbiSJQQpK1MVsudjIj5wjjHm+FHO?=
 =?us-ascii?Q?NyKLGBKs74vyrjV0EHlN1dLx428onLSTj5b/z4cW55eSoJClUINY4WlwmjT2?=
 =?us-ascii?Q?hDcIE8Uthzzbo42iKfYfYjjnRHpPwlTT7qRWbTkUNJXa9f91VKyd+g6sB5fc?=
 =?us-ascii?Q?VBqud1nbYBNcEmysBT8i3Y5BRYkAnZWzx8UedYDo/PzkQLzSduZEm35JwUjT?=
 =?us-ascii?Q?SzhaUyySAatH+frqG4ffLm+NebjNPowonCj34vVp+YX6mAvRKtLKwJANuzff?=
 =?us-ascii?Q?KgaaOqKRDB+QTP9H3YbZBtyFed2akwnw30DXVfHrD8uzFp36Nu8xxsSfwkCz?=
 =?us-ascii?Q?kxHJ9BfU/LMuyE2zPHkfE9EpOhIODV8ymtSsYtj2NaUxuBkqRBKEExS8Tycx?=
 =?us-ascii?Q?CvZVbSv9UoVfv+M3egfT4iNlelIxeyVVEvLK4hEQcLgoejazd3X0BzbvWhdg?=
 =?us-ascii?Q?GFVR2dRfQb140xDosfIcbrDgoL38bOWYrrs22zd/4PJ+8O/oceARKJnLisYv?=
 =?us-ascii?Q?dAKFI4MuuLbkN3oQZChKkbUhDU8UbF+ms33h9gqkYmS3rnF8yKWmdbvbjD5K?=
 =?us-ascii?Q?V2MhbHap3NiLCONo6QjyKEykKlI7QyY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U+xFEjee3dprAh2vQ18Jw9XU6QvJd3IRrzO1p27SWZuJIuZX6VyEMKqFaZNv+qiHwrJlfo8I1ITUKwH/mlvEp+gVzLDsDNIj9egbfbyjx3yi8dD2r/y/41zl6U0m0zlKdTDQKhDpoGMvcEajLdb+4kLgaB0fpCuSZ8D889xIJyBxj85L2JvcykBNqwT0RfET5ENmjPep3KEHJsQ1W8TngyekOlBtZ517MF4MnsKSJ3SBklYobt9UQefmfNz0kzv99txv0PfmiqaBXsClPhZXl7o3FQogzzD5jXWkaNGXoBVMdqZnVNAj2iQ/cJvLJtAEH5RwQ0ntfv344LLn4vq5s9T5kvAs3tGhQgnN1ABTUkhEYmKM+xwb+D4VuROtNTzxlliv5l8WZDHek5MwnplHc1Tavd2a/bBhJLl5TWyYQVUDivi93AgIa6OgyVfqD40TsfGdCe/Ynyez08qUIY0JH594nxPcYqFbBKfpyGHi0utfsbDGf8Vn8ijmUGiMHbxRXhf+yCloWwxJT0gOoAaa8zzEi8Hth4oTS0Wi/R0dZp7wejRCasZSev5jOf6A5ufRthFRztEhoN46YSw1rs6AUDC4coekd18cW2eOE3YczFM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5aebb5d-0fab-4820-eda1-08de59b4dcc3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:46.6870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yc876/U8VbuciOIHmUmkAtPwecxJv1sDOGLtrB8/XTGTBwcsc9HnLIIac/XP7XXszuzcgfd1NxBRfhxg/wYxyQPjNtDuSk5dvj1gTzDKstA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Proofpoint-ORIG-GUID: 44f527y73RPpF0ZpUbyHE0Fiz233j9uT
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69721d2a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=yBRV7UiJsV_3HBrqTEMA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfXwlIKGF29Aj98
 IUxz8sI0+Us+pHsFeMV6/0r0LIoPL8LVxYz+6C2RCg/I0dFHC1el5QxrkXZoH8o9Qz4yKCVuNIr
 MOrYQGq5gV7ORWd/nkNxXYICi/kTjLvUCq4CJ52W9hX1Oym6tzksoH2+6wDWHZzUkF7VSuClrUz
 Ab2O2ruqZQCYCEQw0ReOxhJgucQN0EF8OhPTsfo2ni0u937eQ7KbFW40p10ryCFEGJTaEurxTMX
 r3GETY8whdx1wLk65AzG+EHJcKFEMaoKLF37RoNIpZF5ERnky43t96JCqndFKzHMhFlIwDvhX0E
 Ku44zPHdlaLW12tAn18XIFd+iTHBNJhHTSwJsSc/PAh/24XPD3fczg351bg8uK7ylVX1sVpXwNf
 JXbmVzPApGr468D0YOfYf2Xy4EIpDNByHdgons0QTfvDvwBcmt5WjTimnJoqeVcKrZZRv4wzFLP
 PjOL+8HIScgFQa1aR6E0F/jW6Z3jtQfqDq+lfOwI=
X-Proofpoint-GUID: 44f527y73RPpF0ZpUbyHE0Fiz233j9uT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BBCE340004
X-Stat-Signature: 1tyj1e4mcud5kyurpxmzcar796493637
X-Rspam-User: 
X-HE-Tag: 1769086259-392431
X-HE-Meta: U2FsdGVkX1+evVzNElcObcQkvZMC1hseJt0lSa1OEI9wSNwi90hXrQ0/sMXrTku1N88B+A7yLkhMvUyug0r6HwNn7s7/pm88edxXzx2jdBuyZL2z/2JVXYTXnSpzStvARwNnIcIl2JWC+57Ev2KhcEctWRahwWiL+1yb/xMMAtgZ0FXTY3k0wK9GbRUqLMvc3m87yUwFsu6RVniTLn5h4QNASAjK4DuK83u7TDODyEOykOPrClUqCKzTFrzfMk0+TXx01BrnaNm2/A2lsWR0aLJrQHcoAeozi+GmCvhUKN8n0y8meYTFDzyF7cx7C0vlonqY1TB1HEquqYMW2zC0iQ7wX4s2jYwkgbu17sxJu11MrU+QWKVO4mCD8fumb1wAWKTMS6v7htBoadbe7e5yMAhCpYBbGZtm8cU78QNOltI1hm2IeFJ4XOdqJT07pKqCezgx9PIQU5LNKQU+e6n7uBw+doCUI6P5cd6rsY+GQ7syZ1qBJaxLB44HOeFrhxINI85AnxLxWGayqRQI3/Yjvbi5RsOj70MKOgHuHpcORjYpTizfX0oWvbq4avi3c8O4yrzPZlYpdbun4fBlBiIHKUGFlzL5BNdRgkQ0CYKFLalzLTWKECT4l+8XxakONous1cKyUsqEoop5AxWOem34r2I0pa/EEFV5pMYcdSNPINpVa1H+gLsyJaCm8K8M4ksG3ZPkD7RbFLd3WI2bFPI+T0ct/WLxxl2YCnJl4ZJz5EANC3LWU1wae+F00L/hEnQWeYJPpVmLIXhyssHxZdOfzGOEgVAAqnjIoZ3Q065plaxuhGoCGJxziAu34OdOaF37lgIyzMEY07ob6dyvTnnLilKOP6tEJTi7g53oLY2B/Zw8DcGS8CQH9TLqFHBtSqJ+04lUVYzjsdZCjoDOFXYlHldXhoAbAfEgnngGU2F1NWEiOoWmNDFkHSSfGlb1Kwj+uSPo6TPuWw/A/1Sd3IJ
 nGPY2fV6
 0h39Qyx62/9J7Mj7fV2IFn8s77vSEAahIsVGvjRcPIALB1PeYNC6mgwVgqyH7bVJ7bhpahvHHdYolAmcojPkRMb+3EzHEalR1jZAd8YggmXMCxNDRiAgNv2R86LNXF27cuf71QLfvNgTNz4zlfaMRkCOXx+5h1zsHdI8UdG8CZcLaemUP/CZOYW3E3TfMCZB/GpkU4Ht+6mU8aJozLvF0xWTr+SBZLurzM3cUuJDq0keLRVe1GAJMVSxwwP3XPJekuEjfUqX66aOmf7UgCBhX8sDtxuJo1GtEcO32TQATmJyfeMX+qPnjQwsSRlNzWEi0gAEs4OBf8KmTMfrRFuc/klQl+zM6uS39Ila+P3jvVCB0hypS6DL4yaKsjEOBz4XGViFctSET7i03EV190kFL71l96989nDWJVslyg6+ps5WtwgOG8letbHUeQ4DVMFFh2cIHyrJ4Hrbt5MZUTcXMey/j6ZW0uRemsukGYciyzydIsdyWuZJxbmbrqf/YrgDnieLI3WNDD4wUwI7XXaWYpD4up3tN+w8s5SvozLmejCpwpgZmaotMHO5gbFG8aaYf+Vm7CUNamBbF41f+RcV1E+POG7YyMvKf/WOCYXf0KqfiBLFym4x7zY2isOIeJ2pFD2I0BoCCHWAZfYIGKPgEATro0Fg7E+9Yv/7o/+d9IfXJIO4uOcoD2xGurNm9cOwS2h+BJ4Gq4JgD6+5i/oY4os0sPN5Glvov61rb3whes4LsJITfRpj/FELy4Nqx445Uv7sdgAPmh/dNXKZd3SPXxRxlxxZhjU8C8u77
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is a little confusing, clean it up a little then add a
descriptive comment.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 873bc5f3c97c..b00d34b5ad10 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -252,17 +252,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 	vma_refcount_put(vma);
 }
 
-/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+/*
+ * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
+ * write lock is held.
+ *
+ * Returns true if write-locked, otherwise false.
+ *
+ * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.
+ */
+static inline bool __is_vma_write_locked(struct vm_area_struct *vma,
+					 unsigned int *mm_lock_seq)
 {
-	mmap_assert_write_locked(vma->vm_mm);
+	struct mm_struct *mm = vma->vm_mm;
+	const unsigned int seq = mm->mm_lock_seq.sequence;
+
+	mmap_assert_write_locked(mm);
 
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
-	return (vma->vm_lock_seq == *mm_lock_seq);
+	if (vma->vm_lock_seq == seq)
+		return true;
+	*mm_lock_seq = seq;
+	return false;
 }
 
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
-- 
2.52.0


