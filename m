Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD3DC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76CF6B00A5; Tue, 22 Jul 2025 01:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27016B00A7; Tue, 22 Jul 2025 01:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC83D6B00A8; Tue, 22 Jul 2025 01:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A70286B00A5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:25:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22425C0241
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:25:48 +0000 (UTC)
X-FDA: 83690763576.19.29A3F3D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9F7BA140005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:25:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LKyORVul;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fHGhtbSV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753161944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAvVAJcmx/FmF0mF8c0kUa3hpSXddWcgLWuRTSXoDrs=;
	b=rZttgx2j9Q2ocykPqGGv0lqgf+7NFkx1etx22PVCnY/l/YdaRWKN2totAgCgUrWB0XkEW5
	bzP/eqWoiqQ7vhmO3j/hkGJ4bJ/Khte9mT/TNKsyEBx3okaczAJiCzUmEUU+bUZmwxtE1I
	h31dZvDo3EGElsoM2PwMd21B2FPPhU8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753161944; a=rsa-sha256;
	cv=pass;
	b=FV7vIzku8+0xL+tWwm8xD0iYu/NJ6Dl9DgNQXNRfE3K6wHhQVvZKdi6auglribnxnarfuI
	smWEYF4vbedTYvNk9GU4zkyk42RKtEcpfQTCMIsuUmkWBVlzFU5AGjmrV4zLRowD5Z1ZA6
	NI0g8i9umRui3tyj62UpDJg6LNJg+uI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LKyORVul;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fHGhtbSV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1CZsm009653;
	Tue, 22 Jul 2025 05:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MAvVAJcmx/FmF0mF8c
	0kUa3hpSXddWcgLWuRTSXoDrs=; b=LKyORVulmrmHWV2Vc4Duvsoxa5M2WqbcSi
	TnINojy+nvkCXgIGBnUqmUqT55o+6HI0Fm8VihY4GG0cfKvp6wX8Vi+Jj0cbcNVF
	imPqHmcWQE2BOv4Nj4MC1l8sFuhE8yw212+GWyRukX19C9gIBJGvoHM0VBu8LMQj
	uYE283pAXoVBdLI1Gf68XK7u1ubV6dRGEP4eUXR0gkd46z2wI2dd3ck/ZzYtwhXj
	jm8jzvvwrmLdbdzRzR51JxcC6IiNlDl7Q+tJ3lOOlEHonZBIEQwZW6G3u5op3BkQ
	pZiQ7doCxH7DkAMVJLPPyPrBWjm036qOX8eqz5jFlpvT4zZSNIhg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057qvdje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 05:25:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M4eLfb010434;
	Tue, 22 Jul 2025 05:25:37 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013071.outbound.protection.outlook.com [40.93.201.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8vmrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 05:25:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cE+E0Ag4SjVVOqDZNhP0UNMp2geQx0bs5+Y/L2Z4uIH7vuBF5/j9ah44SDcrCxbH5dCl4YtnaWmwGngB4eJ1TFcv4Ob4+14o6w9GcYPPe6uRGQIQ0zLLYTvxPInRKvsc4GW8EL4qOp7bJlP8qEH/6nNlYtszQIK7mZB8L2ODnAOUdRV8OM7iZCe7oUPe/1zzvOfRl1qiolltHYRsRmtQkZNYGEzxNgC2D5QZvaIsYgqAfddSfw6wYPaX4AMDeeeH90HLke3Z8PNqpX6PS2gJ0yYR2wwYSer4KHW0rOPU28d6wVN4RS2uYTN8gjN67akAaOAHGgp/mQtROBaf+DLfFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAvVAJcmx/FmF0mF8c0kUa3hpSXddWcgLWuRTSXoDrs=;
 b=ZCoNOe2pzX8X1zcrfNE8D9vOSB8W3slS3/iPRePgFvJHCpZc6zXBWoFouvxl31dCz8Gee52SnZ9WW1T+Wx0eQp3j6yViznY+u856a0teMNYRh7qi+RqHzSq5bYZDoyDYRy74FMTR1v3SBgXKV9bnZDfxcHstc90cM5rDX2y9tGnkiHp+sX4ak2wyz13Jq1DUC4aqHCKPx4fCrvHCRbJ9ul0F+1lVsgtUyKwsvGb6Wh4TjVPl5ckfzMl5eWQ+SmEJZ4eqg2ihIkXL9yFH9wPXy5K4rTHSD/8vYXIWpVSubuQHd9MP4kBUNGy3ERjJsaqU8DabGrxZay/P8sL8/qfDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAvVAJcmx/FmF0mF8c0kUa3hpSXddWcgLWuRTSXoDrs=;
 b=fHGhtbSVMbtsNqel4aninlS1Vdqpi6zk6Je5iNvMS3sPyQd143JvrW4F+sahSkSuI+mi/vr3Y8nly9dldTKc9oh1I59evqiZSw7+9c75Qw3kKra2N3mxYnZ3yFqisDaoEFg2aYXhT8up4B0IneVYoy5J0lEuQqOH2AZTCeGr1Lw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 05:25:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 05:25:35 +0000
Date: Tue, 22 Jul 2025 06:25:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never"
 setting
Message-ID: <16f7d3d5-ba14-43fa-948c-6562024c0dae@lucifer.local>
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
 <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
X-ClientProxiedBy: LO4P123CA0671.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4765:EE_
X-MS-Office365-Filtering-Correlation-Id: 4caff414-4b17-4839-438e-08ddc8e02f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DmEV8Lpq/jLI0TAS9RLhcV5YxKIfzNof2Mwc+xYbuhXMttHHrvrNyRlTzjsF?=
 =?us-ascii?Q?JyWMuUpnsnuYGo0wXp7/RA+jFw2i0m5Jim0VF/B0qyKTDxCCjLw8n1wfJuYA?=
 =?us-ascii?Q?mSLqnBzia3ECerunXDZ3T85jRrJ3XTIjZ7ekxIJOk3GPJaBYzOmQfN0EN8th?=
 =?us-ascii?Q?Ry6/fkLVtan2A+g70WCia/HqBp92V3XMq4qhnWgd1xHi9oNTRJDsRKWQo49Q?=
 =?us-ascii?Q?M703mcFIvsjGpdV477B2TUrL7sO8xa8wmcqxBkUg9PeWCiJc5tmHzwr5xZ/3?=
 =?us-ascii?Q?mAj7z/ZGla3pRTlrERFiO82fXZEIn35oVPU0C9mEtk8jjvfZKKMzNBHIPZHj?=
 =?us-ascii?Q?QE8zXPyHF/1svCdjR3MW4xU6R3s71iuabnGjVnzXhlFZJPQSe0rlYtSBg/SK?=
 =?us-ascii?Q?6soc3vVz4+kiC21Ak/Rs01xS5KDY/mDNDp8d4RyhGvo+49EbHY5gpnftRP/a?=
 =?us-ascii?Q?NzzaLtZAtk1sBnbCabjUEpltFCCPF8d4two5IUgjsZDCngGZrjgsRZZ60+LR?=
 =?us-ascii?Q?X9aAgA/7HktUnWLPzvAeYHGyODXVOANgf9rg4p38tyECsBep+C2VgAfF97Fu?=
 =?us-ascii?Q?kA8SjNUECFbILrJ4YhHk2Qztw67/ZxdMjYa2EM6lhCKnf9uc45Ce1I6GroGr?=
 =?us-ascii?Q?8n9zQWyUcF+Ugk+345dG2CZDFwCUPoSgA3oa6pjUKNTpfD4CA4cH+Q5VSA6D?=
 =?us-ascii?Q?0oTirwqr+L7JR/9toqk4CGdasyw8BlymZzO+b8eOgCuufW46FG6qBYjIghZC?=
 =?us-ascii?Q?IPgLrUBWAFZxbSqnHad3ZptMqak8thCvfgDautuFwFnZCD+8xXss+zM/nhb+?=
 =?us-ascii?Q?GvY1jDk/R564zpTVt34kuXlnEAc+/8pbnvwJyJcZF5Cb4vxXXmoif7yEve4S?=
 =?us-ascii?Q?4clLkzmddQgYDrAHsJCdAZt0+mXRYZO2keiPCr7I4+GppChzUmCZmYcETdda?=
 =?us-ascii?Q?pt2Xata2FFZRz/qzAtpEsH2q2wAI8WCYtD9EoSI82YZyXhD5QFoTuNUbt7K+?=
 =?us-ascii?Q?vKmoy8yeLgmel5Fg+pTJfKxXgfWNn9Xa9Cn1MO5GXXFaBbXCaKvgr6Us1rna?=
 =?us-ascii?Q?VEk4h8F9bAABMT7YB3j0JeFPjgK+IAXGkKBpGRaI16xF98S1kMjFbMAzFkeY?=
 =?us-ascii?Q?ZOM6vUQvgEx52uplumUK3dLMCG3xGC+Xv4m/IAf0xpv7uFxVTcofCocauLqu?=
 =?us-ascii?Q?ne9mhI6fU4yrR2xcua+cRguKM9AdRQlIOiqfZZSh3iE0G146nwhf2ldzCg/P?=
 =?us-ascii?Q?bbYgWO8GScwwuoTFbREQ4gefeysiL7SKyMR04dunXiZnqkngLcqdrVaPbO0k?=
 =?us-ascii?Q?3PDpJE/UijKorI0ZOfQqTMH28e6HPMUEDHT9cWiuyhvX2iU808OxkMohI4cc?=
 =?us-ascii?Q?8o5j6RsfFZ9vtCMg4e6eRZLh4lH8pjV99nKgNdEFwtqIlEBbdwiHMwMMiG2i?=
 =?us-ascii?Q?4UuxNlBycvM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yz0w/CPa4RwY6ZC095xEsQZAVNgxYZKZEy2RbxeBW7YELAN1TqbM9VJ4D4A2?=
 =?us-ascii?Q?DHgy4G43otipqIrLPd3iqsLDfj4IG8H71PtzxpUbSM2gJ4M4hD9geYtLzoEd?=
 =?us-ascii?Q?7a9N2sIEI7JFEXaeGoa+dKLbNyZG8jv68o/fpT+GQzvLLsOqsozCuFKqaIsw?=
 =?us-ascii?Q?J5w1HApnQusuADEYpVnjr+HE3wlq5u4fRZFTJZDg1zpTTkUfawjwwLe8ugYP?=
 =?us-ascii?Q?ubTfl4QU9OSZgHGM2sooA886+OMn+pgo1hpJkam5qZ36La/ICThQ4qFg7BLo?=
 =?us-ascii?Q?5qtMhMQYL3lOvSV61mNNfB0QpBjk4LNyD3VZHA3LQKwyXIagaFVbct29uijv?=
 =?us-ascii?Q?3sBYoTtWMGlI102cXegAX2F4lyjV2oi/EuMCsmY7ehrajopgbgeigEDWcVWP?=
 =?us-ascii?Q?FQVW9gC62FH5ypOFDPEvT3axcn4MkEnJJJIOHGHBwkoay51BhJjwPGLimXcs?=
 =?us-ascii?Q?wvWYhUbdSEzAAEcsCwe5ZG8J1P2fP2TE8uDZ7GG+xgzr06scDIRZk1fdeliJ?=
 =?us-ascii?Q?ldMe+S4/aOtZIOCbKsEgjc87+c/gYXoHOxWk4bJIFZhJEhVAVkInexypwCtD?=
 =?us-ascii?Q?tX744WNsDg4D4TNDU+nKj9NfySgxEsoHm2A5qwWDCaHETLsO9mTDFBsuuRw9?=
 =?us-ascii?Q?kjo8seVGDavBnwb6I62C4qdlQGXTUG9HDfGo+9mHbgtzcNMCjbfroiqxKpiz?=
 =?us-ascii?Q?3NucuZ27CbdS1I3nJa5p9cfbpMxrZbLB5yYNi/eOMBPtCYBC2eFmtzbVHwEG?=
 =?us-ascii?Q?mt+RGdUSXOl+AlqlpsJRRI1xsGftjwHzP3p6vCqdYzVV52quZ0WcIEaKnGlk?=
 =?us-ascii?Q?6Qa4WodlYaaRzYHcBz3UZHdirdc3VZlXMfZ3ShIr1B8UgjA+txyuzChorKH/?=
 =?us-ascii?Q?YvidUah/B00G1h7+F6UyuiWbSFzra7gUFKvqEai86Q4MHpQ1UPrIGWaV8XIv?=
 =?us-ascii?Q?Kl9ii08/MvMV3ZqLgg9BC24ytZbd/MZKBJBvwVuIpTcS4pWRIdXLdgB/0PnS?=
 =?us-ascii?Q?WNz6EytVnRMUwvYb2LWfkVKP0+mYrvBsF83Maq0s9IofeqckNxFY72G8T1AG?=
 =?us-ascii?Q?hN+iq8JwmtBVH6iqL0IS91R75/StoK2Qf1Gtax3aJC6R7wLA417Y15R+Y+1n?=
 =?us-ascii?Q?1Lbq1NCsdJEKyrhQ3nn8U0mgPUiTV2i+D6t8wqjqIU3ZY4lBSW5Adi8yHjr9?=
 =?us-ascii?Q?cIP41TP2B+x5UsP4YhvB1kHYRNy7veu+AJzm2mCqROClryQw6Q1KO2Q/FIcm?=
 =?us-ascii?Q?LLzAn8t4iMuFuKdOXL2gBnicC0gymYEj5BP1IfBIPenJu2YtWrZ0qj3gzK8v?=
 =?us-ascii?Q?QrA2lk2680GeaSbpi6oLGKhVzyAfkUn+Y1MLV6VMBRHnw91E3+nrrOIxpRj2?=
 =?us-ascii?Q?hTLEww4M6O5ZNmr3GOIQo64wW6Z18loGpdb0vVDunFjezIzC3g0eE2e9CP5f?=
 =?us-ascii?Q?IIbnHSezi1SW1xa3FA5HmVfLPa32HDrjcuL51E0+mjklBkxx1m6KLVc5cjxb?=
 =?us-ascii?Q?L7PPMtRg5hGJN60qOhJttsruStcVzw+I4/BVx7hXQ/QHP4gN41oEuiOXQ3Qi?=
 =?us-ascii?Q?X1VrYaYygGlcAnunSheBuGF4bIpDfbaK0ZQUvOKbDlunLFmobFSB6jQxf5nC?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YJpfpuw81N3bp4+IqEK1xMbuuR5l2Oklce3Fq7yrwBkjWrCdX9wvkMuuw/r4GqMN7EBVeuL+VxtmgBxd9I28Zv2/XHNipTN54CbXzcdHWQ3ZTj0KXylgGnDCXC/LiMJfg35/r/NIdR/K+AYU2eEVI6pJTPeH5GclIjt7tRW3c9PHMSMLp5J9MUgnCxTUugoLCfaYoR/3Ivk0+mHrhC+GA/Ufv4Glr1U3asmlcIgD/H3WU0RmWtfGU5d8Q9UVM2eNtUIlfSmrMS7t4U0LPMXAOi5N5JmIZyhqT5A9+M8QRsb89cjypCx00E3Cd8LhEbj7t9mpLIwWUvYOv4QgrvEKim/4kH1T1s0K++VjbU7EVrF0xMfiSoG2p9CgsN+91U6yRLF2OrFnZ7BxxeE0mXCaGnUyrNlwACL8LTtnf2T5ehLTa8mvZLKm3Xe8LxYEUp/+Z4DjQOPJEp4zF4VzAan+WaAeZ1N6+jmk9L1qHFgFl3vXgnw60Sj3TxJYtQaPB4KLGILzB5bOkeaLAglbGjPgnFGZji3hUThVC766nyJDN0NCLrEg2zHbZfCjMGgF0W8/l+/Gzr42icR0wcU1JX3+fjZ4jzPmENBrWnqkrpmlL6w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4caff414-4b17-4839-438e-08ddc8e02f74
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:25:35.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5Wy3am2wBuWOWTouXzyVGpjg7xN1rxdXXEMiwvF+K3nQieIKacYh+xtphzzjqqVBbLMNWT7Z52GDU3/5T5hOCwAGO0tds76QE6PLLrOOmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_01,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220042
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=687f20d2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=GWQDCHlmirbvX-Bz-xUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: th-r9O2-QEwTa1AgPDkAvZpB_NWRpCMD
X-Proofpoint-GUID: th-r9O2-QEwTa1AgPDkAvZpB_NWRpCMD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA0MiBTYWx0ZWRfX3Xh2+aCKDOSb
 txKI/8bGcNC5vjsdMeMg4StVFV2foxkO+J6Z2umbYTuEKhjC39EDfTs1VEHXtQ3VRdsJmc4Fbm2
 LFrQx0Mdc9sVfG7mgICYouLcudyDQd7rWHvu0sAw9X4ffqJ3yGWj/05VTqvXUKU9Ncs9oYnfev7
 tdgCZNJwQNKixbdtA9CejM/Pxhhxb5uHCU1IkH3uaeFMUej59tG0t6F3n9pyGZbqa8c31r3Aepq
 AkO0eF/w7Fyx+zjvTT648DUCji3NGj556xUqZOWzxpSN4kUyNw5FtWCN80EgdgYi7ifmBPko0lv
 LfaRiORyEwd6ipLLTspEw0zGzV9GuL0CFo6Vlb2T7XOIxgPdmewI4rTjjdmyCAVOKSKV6QePATz
 jnpj1w9SKiSrCJPqzPcamE7bFQhw3c95PQo1abjmac77Lt3VJGqdjUyzh8bd0trZ+WZl5DqA
X-Rspamd-Queue-Id: 9F7BA140005
X-Stat-Signature: 9gzzq45c13fjagk4pzobxhecrstcnkw7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753161944-791
X-HE-Meta: U2FsdGVkX19FoMFMvyU6sC/wr/+rRls5HCXTEiewi8ZcyzVZSHXbk48suEOP5khjEpcktF8c36Zmb5s2+uMSt+C7BQ5We9hPvO1xZPp6lExKWxPDTOZdgqaBXnMioykJWrWMWmTSbXREaYoMdFC1FK0/QfQT72GpbFPaCIEGuCUx+kVvfJPoZZoULSe/FyFBOcPjaUS9FKNCL5y8+C9s6QJzkhUtiaBt88M6kyYmoTRTKM7q3GNzruwbefuPoEp335YP0WPm5In4s/0EkQqIWkWlOH18vvIpTZVC8i9Pmu5KKc76iYJj+GlmKoxq9Xlbk+9AYAqL6PmegkpwXGsCyCuv5/luT0V+zea/guS4jXseJNYFAz/C6K1ngZEXakYcsJEodD9QlRF9FRr1oq56yomRaeZsw55fzS3mG2V7wXF2QwaVWsqx9jkvYijBZYx3Gnh1RkBXNn1PCtbaTVvTGNQQEFtDRZJg/z0EXnxL15WFxgTNRoOW43zG1tXJjk+pDSSvHVld7FVsmOp8ldm6el1UEHAFJjWhptxn3hvLWwTxBmKaA+U6jOcqPVYJuoF9cAUFnmO4QiQIFKdW0jIC9kEIVlW9hsR6VWUAXZb7yIm6U9wVKxphXxfAo3/cNDpRss5cdzhePFC0pZmAO3UlOx5xJje3r0T8uYkG2u0ZYL+GUeSlmEuzQ6zHrt/LzX9TCflbcHccZgP76RycJRbTxzV4mcPJ4EExc4JA02FeZmOoY1iZIWCqpaYO5N7n4qx4PzPKU49JSh1c4ebiqiakLxo3fDlMj5PuXJdFsqEKDNPwO189hx1qxkLV7vAN78wyYa71DSYKtS3+iTt8alYPb21JQJZRd3p0jAC1c2TKnXRGFdAMXbfjGzAHMCxMiFP0vXFzNe1iJL/+W2TYcTOfpRuNt0hG5DiKSty3Ub5REBa0ou3zs8EsYRliZsEr5niTIWpUv8QXUwygWlYfnsu
 RvUrb33E
 QaV1O/pOxwkhf4SdR/t8WsCHP94ZHqCae2P/4gAT9Zq4z+8KLg0b2BjKCsIMNGmHmzQpBY8i41N86vrcNESfac3UFy44udjaNM5YgT8R6OCRinBWhbs0jvgAt15PueYCCZNDFkCvngBio3ImxOJaQwe7lqydmrkbUk9rEyHVT3xJoYHYAcWBYP3YVoUrr3obFBTk+Kbv6TZHaDh8K952SOLeyeupgQ2D//kgIhekklYf/IC8BM1+FBYi27wgSVMqVyaaUc57+X5BEcT8YTYkR9fIIgAeCsNPVcokcJIfLtpZf+8trghwsQKizfwlmEhmFEqLeODX07IncaWxZnJYuxU1cLR+JJeaYkOTYi3rqMKwI0FD2tevY8n5Yr3Y54Mm4WrDvs89MbH1FxMSXmGyRbLHQEm8zVrZZ6r116ldGiRdTbhRi4+05E7olGOTQUL3oY0YypBlAtZpg5UtrmGjXsyVfi0CquobhlVg8k/kMa7bARl2RMzv4et2GL6OUi3EGAWRuKpvYUnI7NVM+r+1mHdKsijc++ImBjh2BPnUeKJk6+7Fulx5JKkPTznOL/Pmu9jGDV/M5bl000PV2RSqalSAnFnPKyTxAZfR0xk8z2ebFryAoGg5Cy1NYEYZy8+uW/UChxwzpB3kaxC+BV2Vo/Jlptg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 09:30:18AM +0800, Baolin Wang wrote:
>
>
> On 2025/7/21 23:55, Lorenzo Stoakes wrote:
> > Rather confusingly, setting all Transparent Huge Page sysfs settings to
> > "never" does not in fact result in THP being globally disabled.
> >
> > Rather, it results in khugepaged being disabled, but one can still obtain
> > THP pages using madvise(..., MADV_COLLAPSE).
> >
> > This is something that has remained poorly documented for some time, and it
> > is likely the received wisdom of most users of THP that never does, in
> > fact, mean never.
> >
> > It is therefore important to highlight, very clearly, that this is not the
> > ase.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >   Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
> >   1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> > index dff8d5985f0f..182519197ef7 100644
> > --- a/Documentation/admin-guide/mm/transhuge.rst
> > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > @@ -107,7 +107,7 @@ sysfs
> >   Global THP controls
> >   -------------------
> > -Transparent Hugepage Support for anonymous memory can be entirely disabled
> > +Transparent Hugepage Support for anonymous memory can be disabled
> >   (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
> >   regions (to avoid the risk of consuming more memory resources) or enabled
> >   system wide. This can be achieved per-supported-THP-size with one of::
> > @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-THP-size with one of::
> >   where <size> is the hugepage size being addressed, the available sizes
> >   for which vary by system.
> > +.. note:: Setting "never" in all sysfs THP controls does **not** disable
> > +          Transparent Huge Pages globally. This is because ``madvise(...,
> > +          MADV_COLLAPSE)`` ignores these settings and collapses ranges to
> > +          PMD-sized huge pages unconditionally.
> > +
> >   For example::
> >   	echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
> > @@ -187,7 +192,9 @@ madvise
> >   	behaviour.
> >   never
> > -	should be self-explanatory.
> > +	should be self-explanatory. Note that ``madvise(...,
> > +	MADV_COLLAPSE)`` can still cause transparent huge pages to be
> > +	obtained even if this mode is specified everywhere.
>
> I hope this part of the explanation is also copy-pasted into the 'Hugepages
> in tmpfs/shmem' section. Otherwise look good to me. Thanks.

Thanks, will send a fix-patch to add it there too!

