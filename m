Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE66D1489E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 06:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03AE6B0092; Thu,  8 Jan 2026 01:04:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4826B0093; Thu,  8 Jan 2026 01:04:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9932A6B0095; Thu,  8 Jan 2026 01:04:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 878D86B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:04:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B6811AB386
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:04:50 +0000 (UTC)
X-FDA: 84307757940.23.8C8855B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9EF0120004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:04:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YowGi8+W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HIyWaCV9;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767852286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xr9IDgsyZpSEYQOtgQiYyKDc+6NQCWB7i3N4D57va8=;
	b=RTjllblNntnJog9qQ4oulxTESEAdbT2rZMfxlB8Q0aYsM6DiJCx+vWR65QGSTzrB79lgqP
	OZ4d7eJc4X3rc8B3SYmoYri9hdchYMMa/gLVPb+maSvRcwnG7p+F7ItjyvpNL117gRQ4CM
	W/NfqY9Rk2OyXfZkz4Sr0mnIjNWTRk0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YowGi8+W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HIyWaCV9;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767852286; a=rsa-sha256;
	cv=pass;
	b=ORFmw4WL2UkaoCZpeXfyAP67Y9SzSKo+nP1GtJqS5fjiodSih5ODftwL0cBYQ+lIEG9I0x
	Ivy4G1dM4B/PEt8XHLbzD1I8QwIBVoeAHcX8ZsJ1f2yC9kA53Y1JzPMAPiyzq1RvV8rAOl
	pw4cR3897L1VTpts8TYAPEIeQNZU2q0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6085Z7E13612888;
	Thu, 8 Jan 2026 06:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5xr9IDgsyZpSEYQOtgQiYyKDc+6NQCWB7i3N4D57va8=; b=
	YowGi8+WQFig6P6MgIo+gwYT/bJWeyKCkQbh6wDfYwAubAHENYxtni/GdDr9BoWH
	4V7txJaPqi7bycI8ychm0qY1xo4I3Uxik0BDTpbs+T9GdokaK9mn/0+QrWfKi/0w
	GWzzO6oTFVF8S3ImqvEtr3VnYWDFp6/gUeBTl4RwnckFbVX0UrincIoT8c0s8uii
	OSO4yzcaM50F3+vBFi1sWPPUowTtxf7w4FvzQ4a7/kVdkR87V/3MGylDOm7ssNDX
	ht8t24P+4fDr6qORJGmoeHjEbr1Pl+Z3P3LhaT9IuMbwHi4Hy917Aym5qgEHCA5R
	R/OuLnJaeD0BdM0YB/VurA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj6jj80rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 06:04:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6085IhB3027430;
	Thu, 8 Jan 2026 06:04:11 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010051.outbound.protection.outlook.com [52.101.85.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjaeqb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 06:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1y/N1meioWknWUKaH+vdANeYhs3Yg0XnULz+x88sw3zGc19flxrfG3w1PGEytSOrS4tOikgSIdyBrLDQmISsiGUWKe7AoTQfu+jmS8wjwtVWYS6wATrfMF8AbnjxQ8yWaEymPVEBeCCdG7fcolZHS+73sMvVGHAk3707Xbe4eqlpntB+OJbyxHwOkCmzZRiUdOhtdHVLW7KCiJLnhTqcSPHeistsoSjrVn4QYDKSNdtjAaN85KIq4/CCAHzXcdaevnZtCkHtFEaIyw3MuKjnYvwHx+DZHMYTEKP9ZHjHhj2/0fzRRc8uaAgst7WnWCur1nJ6lf8eGnjzUd3lcdsyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xr9IDgsyZpSEYQOtgQiYyKDc+6NQCWB7i3N4D57va8=;
 b=clsq7Pt0yfUrU+nAecV86b/pEQXAyxH3LnFYo711ZP+tVhiYx6LIGeuofP+34TiKTb8ClCUMBbUQ9k32oJKog+jpoy/XmQcCqoapO7uZn7Vr5iMTdehOwEq7LL5S1VV5uWJk8rnnQWxumDDlDp8w5+YNd+HExH4KdcxTWyexm+4x1Yk+3r6Kmff2qyZhEDSSuyocXPzD+xeoa5A8LQDTd7F7NzxR010Ww+K34lgMcU2G4TZgFgis2AXYWXAuiHI6gRY6H6QMUHPeiIOafYoKDzT304j0eQeaWF+taOJY66VD0bXzWzI1YRHnEfTLs4Okg/JYoEoRqeGSb9NbYwNmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xr9IDgsyZpSEYQOtgQiYyKDc+6NQCWB7i3N4D57va8=;
 b=HIyWaCV9wyyp/kPFCd07LOKobaXa6MhRzwuRKOW9WBSJ+xlYIFysI63V39rYh7QLFlr/Lsw+spPrvQs5WhcwGY7r/J9Bvrteq2bnR3Sitzq69giqJR7MM8Hmur0/DqAzyaqz2gyvF9/UWf7FIM07uYFJ3aVYsJEevJOxt8BtCeY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 06:04:08 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Thu, 8 Jan 2026
 06:04:08 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH] mm: folio_zero_user: (fixup) cache page ranges
Date: Wed,  7 Jan 2026 22:04:06 -0800
Message-Id: <20260108060406.1693853-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b002ef-62d8-4994-22fa-08de4e7bbc61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/QWTlyNDVZKja3EWjuO2tONnji6uvanBwNOJKzc9KE3whAu7XK5TeRHfEXCI?=
 =?us-ascii?Q?q0jdQVofrhXCyF4Xwb1GHbUQ51Z4rOl1H7M96Zmw3D4a/lqA5qiE6FwpjGJ1?=
 =?us-ascii?Q?j6OAHvSBFYXQfc716PisrOBTeKd3t99IWnr1yKnuOqZkZOivZ30kSkYqPgzs?=
 =?us-ascii?Q?f7Ngw9XmhtUnmIxFDuWYo+dwRBjksZY7BpxtJD8bsrEEy/TYm20lmD+2y/5H?=
 =?us-ascii?Q?qONs8LMAyXgLP4djQ8mMQLwNJq5eTR5whymkeuDEGNKckSmIKN8wG6TWAk4D?=
 =?us-ascii?Q?dKyo0MpXwGK8zFkLL/eaz2UyZE3k2Y3pLMTqWT/DeGP9AdDvL1HPgwly19U/?=
 =?us-ascii?Q?fTEH0fu+V/wM8SIKk/truQn4yyZZj8kvUw4Kkrthv/HXVzdYKC+IztFeD3eM?=
 =?us-ascii?Q?eobcesnCIcmGpozTiXq5M56Owk4pniYh5f3s1Da6IOBs/iYjXhES2Gm2ozGz?=
 =?us-ascii?Q?7F3fkoZZy05tKDS3X1sE7JG0SqKfmEb8l2cj7ypNsWW5YA1tVYIQ50gqmDet?=
 =?us-ascii?Q?L99g713TX7ozR7maxVM+8V3e6cTVLgFGxg3BNKSgcUzIhktA0KGaIA+rpp2c?=
 =?us-ascii?Q?9vi5Wuh1hsgTejpvlmmPeMarddEH1vFRpDvopCPrNyVVDJy5a0AYVTyf+wtS?=
 =?us-ascii?Q?t/94mDsWpaS2DLXH/Qd61u8I+qT94cHGZyq36FWLYLDADLyJbEBF1aaXvNjP?=
 =?us-ascii?Q?RDJ4UBupqym8NltU9t9UagMdOKyBpLNJ7zY5PiKDN0ZdM2OmUnFkJIXhKv+Z?=
 =?us-ascii?Q?VhfLqDaEjAivOTG4LItmZuYsgwcUNReBbfWLJAVsehffFonOLMk4s2jTRKjC?=
 =?us-ascii?Q?PnNbXBrt9k0x/MlMA54IB0QuxkmEY78GHuGVVqzSy4h2MMBuB50Jy4wDTYiv?=
 =?us-ascii?Q?j0kGvX1XV3mLnGMBAmVUXFabINIlW+dtJ1raUQtgU5av3fK9shIzWGjtnyVA?=
 =?us-ascii?Q?yaWFjsr2tWTkyu7tDX4e08r67F27rK/4fgWZ5KiuDGpxd5tPXXLuCUoxNkOi?=
 =?us-ascii?Q?uKCgI+qAIjXv2ouRT0pVql33gY8q753UnIi8pZltNaJjd4Hckzf8TAMTryNn?=
 =?us-ascii?Q?7xp2y+kAanyiM0flR+yveGs8J9UYq0qHZcnOk9pxXHuhH0edipaop1XqaJzH?=
 =?us-ascii?Q?igj4l1MTR9amReNc2hOkHtYlN89oOMG9BAy3cOPhlRRQ4+Kxk2k27dp8KIbM?=
 =?us-ascii?Q?l2TLtgkO3mWqBMOHUQfttlJsUvCVrftZisNslh59AEDzEyMBewYvYku1NN9V?=
 =?us-ascii?Q?nAZ55TYdj6cTCT/0lrdXDKwmO6q6xrD0e6qwPWYmbn23RLOo49fK+KLKi4Af?=
 =?us-ascii?Q?fS59W7yc+998k4yQryPjgxv6aRB/SvKs9iwavdJAo+yHeMllxJTiu5xfOkSh?=
 =?us-ascii?Q?CqnPV3W6OK0TEXx9WPYDeCSznLNwWnSEX+jvl2CCUG9zVwZQ+YRJb/iFYU1c?=
 =?us-ascii?Q?/c1/rIkBq45NNYH2M0ZtARj2ES6MSeZ1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mAH1MIpWjWFlIQfcysyi/iyadJjhgC6v+F27xbLI26llxQFJ8lPUOPgEa6Nd?=
 =?us-ascii?Q?vd8mj3xTuD7YsO91tFWh0DlODHh9B6P8JdWNePGV5avVSw5Qld69P2tpzF6Y?=
 =?us-ascii?Q?KKmUkZU1e9CKACnWT19UXR2fa9l0uMaVOvKxY8ipdeuqGS1qnShEIMwswE7h?=
 =?us-ascii?Q?0mXJFpqlEjRHO9ztfQCh10qoskA7qAa1OVTROMhfSNve02P2oXGDqEYU1eIj?=
 =?us-ascii?Q?kVfRbUDJgKCU9ia00F5t4kCef/mimW/kjK/8vMczIuPxxiU1FeZ8zU5Za6SU?=
 =?us-ascii?Q?ubxfSfARlIv2mN2Zpgx8RmkyX1MNdQSt+6tw4i08yzxrWKHJAFKJc5rOJa4Z?=
 =?us-ascii?Q?qB6n0eULBGdU+olr8faJQFl8MYmTSRLfuBTXjBNJ+uxqcYG2VxD+RqX8LtpE?=
 =?us-ascii?Q?W9MM3XT+X3oxvhL3S0Hl6XOcVM1ZKeAip1wUYGenYx/uYuCxK7QL/eh64Es+?=
 =?us-ascii?Q?iReiEp9fYsdf1NQHk7K0WoZVggdEpsViQSLsUm1qxqzfh1Ntz0oYS0StmIX/?=
 =?us-ascii?Q?2xM/Hj4/KvVyg+MKgVGfaCT9xXiZz6m1t44Ltqo3VHR2WmtV7wO+1EL5ZkUo?=
 =?us-ascii?Q?50wS6P+oWRSJAy+lFOMo9d7fEMxuTB8k9VgDfdj7NELw17QHYWCzIao6Y4cD?=
 =?us-ascii?Q?6UAEHpfyC+dDrzlr1+JdJ/KqowxZnbo0REhySlWlCNS1Tvks4Vdb20oeZB3T?=
 =?us-ascii?Q?NbxZbN2Z6DJzSAKeMzjZwiXv6N+uhoZG2TCUKtBD1Czj0yw+fnVBO7h06LmQ?=
 =?us-ascii?Q?JmOr6cOBK9RKJgyU2asbyIw4pR8jj+Xwtw2JebE7Whues7ugOhWLJOF4a41Q?=
 =?us-ascii?Q?b6T5FtvAzP4NnOU9O8YJYc/rkINyhKE8hczlux1dMZ2ln6gf5JEY8M6n6kAh?=
 =?us-ascii?Q?AoXKH+uJxurcfjVeTraS+AIkBBVxfbZ3+nZa40iXEHUkinBHUJ1SgDze17zS?=
 =?us-ascii?Q?+89UcMLLws66f37mjFGvspXRYWMOhQBqkpg9IWgfSRiG3jR9LF65d0o6uPyu?=
 =?us-ascii?Q?4SlCEDM4K5pupKD6cM3ivF4+qleq9gzwFyp+ac0u6RiXg/498oFn0y5zlnC7?=
 =?us-ascii?Q?FN8LwLy8YO2M7Gjy4YGgKmio+/Lr0u41do8ZdnPvGp0yH0WbvmsnKd7tNkgB?=
 =?us-ascii?Q?V4uchETLwqd6gsW1EkU5NI0NWdj1JCaq2UqUl7+GpI6qzwVOoU2dtaZx3bPj?=
 =?us-ascii?Q?NYnafydfbBNUwIDZlyZ38F+x4o+WJwP6QKC1SlpvZ2F2icKvayLKl8MITTQv?=
 =?us-ascii?Q?2oT8bL+tumh3TD4tDB/uW7P6EJyjUfsxq9T/3iIAnrE2v4CqYuI1ztzYhHUo?=
 =?us-ascii?Q?n977s/VRA4ksKmGhGq9b1udWDruY+nkwZBPkNJiK6UsEZVHzgBgsCtzqBUDM?=
 =?us-ascii?Q?9yMmaje4tCrRDihZT7UtnTVT+nM3l2k0eVAH+NM+GOcPsOuF9QqpRNGhHUfE?=
 =?us-ascii?Q?NE2wuptdn6viAUAb+D9ABWmUO8sZLuwm+gp4MZHTPmKe1daJAenJQAeD6+IV?=
 =?us-ascii?Q?BI4QMQVwv5JrwcaEeWxNmmOSgkJ4BQSa+CKI0hcSKGcgmul1O3KOQzDVDMIl?=
 =?us-ascii?Q?OhXvfD5dxkyQHJAqQeWiNXADcveOWn/H+rcCtdh8/Her4xbtCikHIPatHUku?=
 =?us-ascii?Q?4QKJ7KIx8ZFtUB9T5FYusN01246qYuz8KFiOWf3pR4UKtfyYSrI/poHY56z8?=
 =?us-ascii?Q?Uq4wP4DRhq9G6AMPxeiIAoV1fUS4qeSa2gyryvkLJxcElxPrlvYKgHii2qND?=
 =?us-ascii?Q?L+g4HI0Y3sXa2+NF5aGD7UqhoDAmYPU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0XaMgzdvkOuag9kEk3gCqiWSS6SUbq9uMYGCGGqvlNDm2+3AuyVdIWy/wTTkXP1WzQv3SjY0g6jaGXouDi3zSTnIpmF2LFe5D0ghWYKV1TK9yeKE/pPfsZXmzNayosPNEFP3a98L8a0AiE4ULDBv8zmnbEbw7+33kxEdYtZPMLcJK64e4vxZbGhkKGG2pYOwysuJOVhmYVqrPKQfnE8yHUSM6/0kgpzvvj1qjsOmG8i/Tkh6kCzSDbxIc4+I6R5lSKFriZWmMQskIQRfe8tsdz5O9faQ+YfwTrr6fR0o4hQE9S3KiQcS/khQza9LvJIq3dvOJWZaS5+NNjG6wgx8v/VxaKhrral7fc30cL79LRMjsE0he4eCW+4HtYu4F2DtsSNI4SJ1VHOhuSyhyHdHXD5aGygZE/UVPS6tj9jjAa76xb0gOech9kLImJjFE6KWG9G/3bFiIkyU8RqT5RipZkBWro0r/yphwwZsbhz8khwYJSzqE1oMGmu1hXFxq0lAJsnl+w9oA86OanNcoUGeOS1wPvQ4sS0Ik9m2qYdRsLsloebkj65zLUwnAJf/0ztmeDIP8XYSJQzi6qHrDRAQKfl3wLYM6aWJum8wCwesa+g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b002ef-62d8-4994-22fa-08de4e7bbc61
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 06:04:08.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNb2sAdRh0Fwbd0nJQYc1VuBx6RTPRUfe+MZOIcmIWwRFprs6Bwd4+kc8bMn7z742SIT5ZyXUIIoTfbyKh6PM7W4ibCNZMs0sdLbiGIWzvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_01,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080037
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAzNiBTYWx0ZWRfXz5UVOFkKiRKK
 DWcPKjDWmq3Z1evumhLE761ufxckkiXS2T2kCBrl9r6KwtAhi7R8r0yfGgJGKccwCud0jtt1BB6
 8W8O7NORJUi+MPcTFFI9zEFVDLDF5AYyyGGkPGOsMLuk4/YXqT5m9K+fdG1vAoAgWFBBT8XekBZ
 HbTJEnEI1XZVX3qJAIU+YZscILx5N+C9sehnnR9JiZXFy+W9D+KBAgVBibyqrX/p9AhRbLCS2+G
 kTACzOnLiQJN7c+ffMeemAjS+rwiQEF/nRIXMbYb6AgrlgIu7hye0GctxLt3pF24J2tH1xN9v9J
 JwSxlpvJ+6BZDP3Xh5QDidq/ULbCP4ILURZuH3kC+puJoTT+teK86HZtnS/1qYv+2z/KMqnvZ7Z
 6/smvDo/qNen4M3ymJGgl5BWWm58XGueWOlVogN1duRE9HEElvW2txFOMgTEPNuS3rqEnAiWYLi
 iuu9hrKxfiCLY/WTbGg==
X-Proofpoint-GUID: z_Z7H8dkod3Jt5HmiFOSjPv33bS1WYdA
X-Authority-Analysis: v=2.4 cv=WtMm8Nfv c=1 sm=1 tr=0 ts=695f48dc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=IcjVyHZ-vTDp4JK6qwoA:9
X-Proofpoint-ORIG-GUID: z_Z7H8dkod3Jt5HmiFOSjPv33bS1WYdA
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9EF0120004
X-Stat-Signature: 6jesjz5mpa8phff1xchzjre831qujwrh
X-HE-Tag: 1767852286-292041
X-HE-Meta: U2FsdGVkX1/SjmKbWF5h9brmDWiBbvFmAPzzibKqQ0vi8R1KXHMmDlHcIxzGTNyDredVNE9ZkBTe1NHIBDLd4GDqvpRlgWStIDoeUurJNTt+rzCN474epRI3DiXVPYclzuZUD5xFeUhSS0N1CFV7ouWPQ4OoWurmXNW194vnjJG9ITMYZ/RyEVlJPHMk9W7VK/MrybVI8JYAemNBpa/VvmpjSytQKemUFpHNnT/gn3vKpPVmecpJcHMAujekh5td+o6hfxq97O4Nk/j6qlCfUgUSEiY/MIOSaCoN2AwTuv4prBZ3jSAH+FiFE1tq1kqQ/qR0jMO4mKo8EcM4fTpxHnK6Xt1ked7VfuiN0DeGS3caOJ/vddtrJka8+sp5SF+/sHccJgVzdFOAUVkz2Lk/J+Q41P8E2ioF+/Mbb9AgvFzM5hHQAqp38O2CWER21N0J5vANmJpQ7pwNFHxpjp/6wz4CfyPmz9QOznUu8r4KiEYf5YU0CvzK5KPRAsNcmhxj1m95aCzlfjiTyhXNTQfLk1VJtE3ErFLEQRyUgt1+5uThNVlMZVzMvNMjXPKVN3ZaJqLV4PDDENK9bi5lyiOLaGYEbPc+bN8v7lITOjkaf2YmPZ/3jtKPf7h1Qepz+Zam33PrFWr172jAkJiEUTSw0D5yBAbiB1blImxl4M8N7M3dnmVgNhThxSdDjPEDokBSM10pTgcfYxO7213SOPnzecDJzZk7cwAE67e1ejZ6wasCBM/hNJPxGHKRAZQmPXTVtyl/Oehnc+iY56fukH5sEM+qrlHFlon9F7smumwqGwKb0RYCz5M8QLRFO3udGlNC27O5gsUFLWKNJ2sF0O9wd7SWZfusx7NIhjNrTVMWmumViYbQH2QoUxSe3C+iaf9cXtElCh5IsQVgD/SxNTLIsxpsXSwQj5j26yk2yHBs4nMvnJbn7Nsuku0I5OAUfXXOtQw4Kl5/HrMeFEGWUpO
 qFyhgUW6
 YHo20RQwOykW3355beAZaScv0K0goepQ8P7cfbpRhSOd0VLqYM0nE97KpLpGGvU93unhhFivf1FR/2Ee3ke9NvJpxrN88IfhPPUcmuDF6lzCwD6tspepWGb/4vGofqcjNjHars9h0xriYEvJ4oXjJc8IjN/9NdHvOoOjAvbRoD2yRmdTHAGkAegM4hGBgSsN7XiEkPD36C0oHgCD2bAiOZn1iifq1gW33lQaHHNPiE5iLzv5lIe6eGg9n6zvZHR6EZyJ5q3kCwKdGmYSk9Ovw3El9um0OStaBnfLRexSZU7y1kxrg6tbcP2aKvKT6yRtr6L2Ak3y76UtyIoN13NffAJLviGddnUz1+N1r6KQOn/76NRQkVvKpVxIOpQmV55ESePz7FPdPb8OXYmxpEs7hQDIlUuRi2JsnmhkH/kw0saMaAN7CaBid1rhXtGCJCLtthDpXzPlzocwAj0Z+i7ZIup+tXBHAKTHyNpoJ/MgHcqLBKwKX23rQcbQbwqKe1YHJn0UJt1Ys6uwH9Q+hU8ITUCsQ+ITSjTUyHyzm+E964IMlTnzErers8GeiCEfqmnBk24LZTVJizQ0WB1ITPM1TdqxB/j6I2GjkHVBQxG+YQa9U63Skpc4gz0QgUeKMyvlfTIdNms8+7VozHGqfHj4mfrQsUzjnoK5dC8T0+oJQuxU/BaYti3hnKy0P3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the unit computation and make it a const. Also, clean up the
comment a little bit.

Use SZ_32M to define PROCESS_PAGES_NON_PREEMPT_BATCH instead
of hand coding the computation.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Hi Andrew

Could you fixup patch-7 "mm: folio_zero_user: clear page ranges" with
this patch?

Thanks
Ankur

---
 include/linux/mm.h |  2 +-
 mm/memory.c        | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c1ff832c33b5..e8bb09816fbf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4238,7 +4238,7 @@ static inline void clear_pages(void *addr, unsigned int npages)
  * (See comment above clear_pages() for why preemption latency is a concern
  * here.)
  */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
 #else /* !clear_pages */
 /*
  * The architecture does not provide a clear_pages() implementation. Assume
diff --git a/mm/memory.c b/mm/memory.c
index 11ad1db61929..f80c67eba79f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7240,19 +7240,19 @@ static inline int process_huge_page(
 static void clear_contig_highpages(struct page *page, unsigned long addr,
 				   unsigned int nr_pages)
 {
-	unsigned int i, unit, count;
-
-	might_sleep();
+	unsigned int i, count;
 	/*
-	 * When clearing we want to operate on the largest extent possible since
-	 * that allows for extent based architecture specific optimizations.
+	 * When clearing we want to operate on the largest extent possible to
+	 * allow for architecture specific extent based optimizations.
 	 *
-	 * However, since the clearing interfaces (clear_user_highpages(),
-	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
-	 * limit the batch size when running under non-preemptible scheduling
-	 * models.
+	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
+	 * clear_pages()), do not call cond_resched(), limit the unit size when
+	 * running under non-preemptible scheduling models.
 	 */
-	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+	const unsigned int unit = preempt_model_preemptible() ?
+				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	might_sleep();
 
 	for (i = 0; i < nr_pages; i += count) {
 		cond_resched();
-- 
2.31.1


