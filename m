Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A261CFA478
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56D46B0031; Fri, 21 Nov 2025 02:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07A56B0088; Fri, 21 Nov 2025 02:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A92C6B0096; Fri, 21 Nov 2025 02:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76A616B0031
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:52:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCCB412F901
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:52:48 +0000 (UTC)
X-FDA: 84133847616.05.92962A0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6860B180008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:52:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YSX19Wec;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K9CcAWn3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763711565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6kBqP/x0tU3wKMVz6l3MuVsrZRHP2qmSi4lDvVL8QY=;
	b=qzX3dDTycJg+q225ipIiFP6NzdHVfJhHc6tDBqjAZa6SdZ9zLNd9P/nQlsrbav1qAoK8S/
	3GaAd8QPtjMt7BzfTHA5uXkM0d3oY5oRk5hk0aS0B8QSJtNxQWVByLkCYHMN90Y3Bo6i+D
	czxuSmucWJygQ1jTajaZRDwJp/5GAMg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763711565; a=rsa-sha256;
	cv=pass;
	b=iCVNSHGL4ucGRVnXByGq1OUmDdSzJ01XIYbYTmluU0N5NAb54V+vIP7fMi4nkAxA0zHCJl
	tubw+cBFXBBF+Pn7kJvbSvV/rXbjMrKyqZ8wDyyk/dJ2da+0SA7dpCOr5GiPTUKL39ne2C
	93r0sxPOhMvd8mB1lJx/HFXjbP7iMBA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YSX19Wec;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K9CcAWn3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL1uLtL030160;
	Fri, 21 Nov 2025 07:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=B6kBqP/x0tU3wKMVz6
	l3MuVsrZRHP2qmSi4lDvVL8QY=; b=YSX19Wec0XqyZdqM10c46wr029hNFVp/KY
	n83AO1oBd7cl7CRD7HqjYX3t2zIm9A5WHzoCI+B44p6WLaVuQC4b8UOokGpobWWB
	mi33qHqfNPjwbFj3qL+YZN53K3hUHGoFlTGjOccwIMpwjpHQqJL/PWI+jpq4tF6u
	vKnr0gQXYSIZzjgEXfGLW9ISPVYW8Ac/0QBjV3rYsVvUQOUt7R+LNcxb4J7Nhu7F
	0OjfBK0LbnVhJ5IHcKrr8tT60ghbrYXU6mMD3vNHA6GVgR8PjUfTrnoXj8ymS4u+
	J2CQNb4dm80QdgqlYz5t1WP9AuLJCzzeZHlhbQrTuodckdTU4Y1g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbc2ffm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 07:52:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL67Jpn009745;
	Fri, 21 Nov 2025 07:52:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyhbgxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 07:52:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbkE21GOPGepClMFr0Wpf5mgsmH4OsDD2nQozeQuK5+aXc0QgcA05v1ZrKzUUwO/a3wscW4M+F9y2t9cDjrqAKo+JtzLUdzTGaqOc62iiKFQJlN6v2Jazm3ciSuCdn3OOJ0MQ+oPwDFgzPqIDUgblrB6HlB/bQY9VqPeEFFkqTKycsrTfPRZmWunG6p1h4qfLkE3+iMR7Itiy4GUSgypSER22jyWMZfiMfvemsAb+E5LCh4QLNEZZYgkuyAsmp1+KjCS+ZKASSPG0UgM9v+Ofw4J+RKf+bv1rntbEKseNHqX++L4rnA3AKtgUiQL6g30SHgayGBgQzdHQSybtLX/+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6kBqP/x0tU3wKMVz6l3MuVsrZRHP2qmSi4lDvVL8QY=;
 b=lFHIC84YoJqNcGgvnFKMz3Kpep3D3V1lNFkqV2MRTTu5MdnDYrGXFUW9lo+bB6uscI2Jd/0akkYB4TXnhDwoyHm3+FzPBRswjyIxEED4DK3yUSx6Oe7yMbV8MbF26GHldRXINw4+5MK9EZX8bivAnGI7GX1P/pVKa2QZke+jsfJAJxIrhMWyzTJUsRd+w5/L7Qqa/qeTAW9R+KMc2EOXdtcE5UA5kD1bKejj88E603tzRPz3iu/7BLmofGCyeXvuwGWJen1nrbUHjxAH6x/BNy2rmPKjde2sI7TH7TG3Obw9rgOpwo5BRenGDCfI692kWsIUIv2o782fb9qN5xaNOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6kBqP/x0tU3wKMVz6l3MuVsrZRHP2qmSi4lDvVL8QY=;
 b=K9CcAWn36+ydkf1RL14E9r6fuICdgx1b2SzsGRA4VwensbYfSyvHgsw0Zlp9pfClM/a+g/RDMkOp+8LVE50rB9ARD9Ss0M4S6/Sqp9KxdCJbFBn5KkImsSl1SYXw1wjQuyLeC/gO7cF4ZUm3upLRr5nd4wCbd8tdgOJ+svMdbvE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5160.namprd10.prod.outlook.com (2603:10b6:408:115::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 07:52:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 07:52:36 +0000
Date: Fri, 21 Nov 2025 07:52:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <070dcd0f-ef77-4924-baf1-6c380bca192d@lucifer.local>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <IA0PR11MB71851184AA5977BBAFBD55C7F8D5A@IA0PR11MB7185.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA0PR11MB71851184AA5977BBAFBD55C7F8D5A@IA0PR11MB7185.namprd11.prod.outlook.com>
X-ClientProxiedBy: LO4P123CA0196.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a991f8-bdf9-4b5d-dfa2-08de28d2ef65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o2J3r4LqBG+xBWGU3fFcUCo6cQBjt7sNGzZn8+yJaNyhQb+DMMPuSxD3Amr+?=
 =?us-ascii?Q?yFR/mMpyFcXhRBSpdJAb7fhK5c/SJug6ojuJuf0tL09zbZIPTPg3qFLvbqgH?=
 =?us-ascii?Q?3fcg+osToV69fowqwR10OinOpweI/QEon5F9532aWCjGh4SPnzyO31r4hRnT?=
 =?us-ascii?Q?5apea8pHBQtY7QpbxY7nM2mYcAy8JI2WiPLtho6F/+bR4UkQ8WuEaFs04VoA?=
 =?us-ascii?Q?V3BJNLyWrtrr8St+aNkkV5jUnZAsMugiTtDva9V9dfsubU4hODx67ziFBAKV?=
 =?us-ascii?Q?uKbwk2M0diBUVDFTZ8IGKsFAt1w9hFnBwnnoYl/9KWNwJBnnVdxyuvkZlU7r?=
 =?us-ascii?Q?gkE7DF1+6y4W4tK6SZmcCQT99Ev45T92ndNNIgTQQHhl6UuSMKYxxyQC5m+2?=
 =?us-ascii?Q?PMLrrLXfzeQO58E0ZmuzbeKUzDbD+GL2cibfR09uXza0YXAr0DwKNFLdphDV?=
 =?us-ascii?Q?UPIuwnVHBTfqMBJzjXrQmCxoV22jim+aRyRtfsqZ57L0Ru7LljVubA+ByM6F?=
 =?us-ascii?Q?ClsKDU749oTQZc6R9qhzTI7QJ8/4lSNN5VPLFn3QmNawiM1e7f4HArmmo/gJ?=
 =?us-ascii?Q?EkqRW5e5hT6aFbyzgOXxDGKwNYrpEbKpF+CQSor/58bDry1iPGEQVqen5iUN?=
 =?us-ascii?Q?pjWoPy8/ywsHCq0UwsZgyZIvOidzAL5oczmzDZ6i+jZdmN6W4dD5upWSdtkU?=
 =?us-ascii?Q?uR7P09QwtBYrl895Y1/A3sO7WUSCv/Sqo/Aj0czbQtseOP0XE7T0vWZuwaET?=
 =?us-ascii?Q?0sgxZ8LU32Tyv00n4tJue01saMT5PXj12wQm9IriBh4KgVzZJpD0aSUIgCC/?=
 =?us-ascii?Q?3tWh8HdGiXA5tvCwljLOl9Fu/KtPuV7k/izUfhQ6tmIxsqvY5BV3jW79CSCN?=
 =?us-ascii?Q?YSUnKu1DE5ZQsSsLH+jE4ft+1KF8sSKCCv/uErLZuxD4qEYUtjCHvSUb5eTO?=
 =?us-ascii?Q?Wj+8WtGIT0VQjJA4RucgSbsEId8Qswnp+gmHzVd33vIEhp3Ks6r06tG1LAO9?=
 =?us-ascii?Q?3FIxYy6SqqAayNGVdS6AP8ALfLw6lGvd2e/tE8Xkrth+clyXtDhiN8ZT35Rb?=
 =?us-ascii?Q?tapMDs5cL/1E1Rnbu8YVY34Kee3tI2ULuuaDCjIg8hVV1V4XBW6d5g3Dk+Ul?=
 =?us-ascii?Q?Rm/7NY9ae1dKQujz4/Rgr3+lqG26AZDETNsY+BUhYPh2xxSGTGdANkpcvVvw?=
 =?us-ascii?Q?XjMUVD/jPE+OomcxKZBDutkshsL78NLJ7JmNwTHnWRZIBhtNY91Vv9/eLlxq?=
 =?us-ascii?Q?4W/vGi2lqHgMxe8GgBsrwW6ml+gmO/CeyeUQ6s20NsWlez3BgZEmPyWrOdrH?=
 =?us-ascii?Q?9cyK90x7iqAb+Lwmlp+LAb3j000OwCmOaGBr1fLEqqCLibCUStPFpQJIi+1m?=
 =?us-ascii?Q?fKMSA/3UP8RzLuCyO0k+kDeHJKjKievjyxK3WW1cXNveihBYWnmxz7tgilj2?=
 =?us-ascii?Q?pJBizfwWvoLKqAnNaRbQzYlwCzjgQq/j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QsSKoj82W0hrGGWBbmWH1kmGckxZDIFKHUSNNOHACCVmB9SGrtVuaYMli39O?=
 =?us-ascii?Q?SKrMytlsvXGhrsuBJACCaOStB4NFy1ktE6NBjDNS0dK/SCqP/M/rkifzIV4S?=
 =?us-ascii?Q?dylzQfMrwZgk3mr5YkUu02HJzCX0ssXsBLT/U6mdUDT0LQ316ZrBYRXltQs/?=
 =?us-ascii?Q?Esn1EvMKcOOwqdvUKHSKPh3OIsbySMJ7TiDHwVuIsiIp/YtrU2ObvD7JIM3z?=
 =?us-ascii?Q?4gb+ZMFQ8AZT0tdsTgbO9XzZtcs03CNLKDz09d1qNFwTiPhPkEHPmolC86m8?=
 =?us-ascii?Q?q7Y0VQvAmQ10vNDyuBJzCSAsHeeAn0yaRKw0RX8WQyJttowowvgNrJm5ttuV?=
 =?us-ascii?Q?x/m9KYLECYMUW3u5OgxTNt6PmOKUV9maXgGP9BBom3eyBttZWgD+7kwKV58K?=
 =?us-ascii?Q?dy0EaTYPgHTZLYMO6rkOuOMcQfxg+6fYWxEs9+o37u2AaGEPvSBKzne+oWwi?=
 =?us-ascii?Q?4fAWnaRr8xd7AOch0Cz6m12Ak3HjWizd0YU5mnEKMl+nQLZMeA/+izcLVQiC?=
 =?us-ascii?Q?g0nyOihwuzPlyuhTCQnmOzvJDVBIop/XhuqyieRc7iEl8Non14QxyUXQQ/Dn?=
 =?us-ascii?Q?jZ12UPGh7EHl99VT5Sp/k6KQdZOmXQ5irEinIuhSVEnw8HmHVgou9ssfOFTK?=
 =?us-ascii?Q?9ZxhxNioP1e+gsTZBbv6zp4U0H9iAU8LDdhNnaQhK+Jc0A696d4nnG61Ife3?=
 =?us-ascii?Q?a5xXHDgoPE2wKz8nPlihSqxbzo6RQdCAX1kQ/uW8kf00lDYb0NaV0VqqCkU8?=
 =?us-ascii?Q?6gzf7mTwn9HET8ZXGzxpPErG+TqS3+sfhMB1nquFiRXdWeibeZmKVi9PEIBp?=
 =?us-ascii?Q?Evdrj5lyRDnGKDIA9z9jyEWcY2Tzq7I+xmUuGmOp9TSjsFaxiH/dtkUr0ayk?=
 =?us-ascii?Q?xyaXpCq1+T4T2kJBaHDA4LOHRPMceVEMMTi+70UCoeHtkgLAStx3XYh9HbFs?=
 =?us-ascii?Q?T+XcNd/fEJ00S+XVnoc5F0+lQZLt/luFbdDfcSYgOBSTtxX5nHpETmBg+qC/?=
 =?us-ascii?Q?rkmghhYHF+6S3fbpjHHmbWMpsZFZnUbCWbU/di1Ht4kF7+ugPJGY5qYJGA/1?=
 =?us-ascii?Q?TKZl0a4t3hSIeLUhcKKe4/pCnU4wwjeIuwnnygj22gauPnPFuz/uncO3eFUQ?=
 =?us-ascii?Q?vyDmyNSet5suXlzNffWfVNNkbzaVfwHzkXmxOB5fTljrQb13hAAlpTOsABRB?=
 =?us-ascii?Q?VNWoylgauaBg27JONLaGZm7q56phoi67aRvNMhZBMvAWliAE7dmq2uiEMJ4q?=
 =?us-ascii?Q?/xtSF7jpVOlbeeqLOxy0yXIIHLSPvWbNbcJs4DQR2kVliJcMshoplwgeQ1Sa?=
 =?us-ascii?Q?dUI9GG0XqSndLqCPu55Ow4gUS0NRQjmIZmtq2sPUuj0ZyPLnQc3bGCsDbjJK?=
 =?us-ascii?Q?D2CvqPL9yJUbYSMcREH3wQKRkZ8/TXvkI4/Em7nuT2Y1XYq/1Ns3cl7pJowY?=
 =?us-ascii?Q?8Oixj7q5YHYAaco54Hzo9lfrjxAUZzTAWIIrLA9cjsmJAdHXthVGSaPM02Ig?=
 =?us-ascii?Q?AnwMdETO/tePgQL6SETscOHlAFfftntpNA+EhRjMCPMLs2tFU8SvccaclWPq?=
 =?us-ascii?Q?ESLKkAwTRsAEPL4L2CJcXQfrmqD5skDlDxqPoHLDgOyQgJha4czR5Y/3tlks?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DoklxMOGhXHHts7PgXG93lYpKF/Ju6Gz1K+Ojg+26AX+piwUbtYpvAHDsXzqgOOY+1yDk5irQ0ysL6quQrj0tFWogCIaVJ8BV1gHyor8mJprG4TJxBUyOH4vNi2RcaWfqzqiRHS3b5Gk9sZgT3LPCKNwu29uuK8lfznDuk2TLd3wXcPDxcKbqsadLzTxAQP8DPSX7zpaYpfbE9Zs7CtSKeKED3u36dNCCSTSwJBhO0jqqKBrJd1AdfHDAm5wWr5d+UexNIjBj8oFBI3+lYXTOkZ6E7rsQ29u7ltPK0yj3cfk/lVh6iE4ICfBOte30JUpaX5Z9ZnA7slvsXJRg8cyV+QffRXDwxfwtTIz8ZsrKYwZppTyJeLxHk3YxgdVecBRDmiKSPOX/f8JOKhzahVMpB3tRHq3P1AMoDNhx2hdBSmo70CDayIswnleKlrI0feZ7t9EaJDwGY2zXWcvWBtucVClOHo50kQIPRuUxaEdrvllH228lzPJn9aJ4pkDf0yYhmaidiPJ98/IzHNUIqDjfFJe/BmRpivUjRzOhFoGdUSwfh3WOrpxZ+vKM6O353dMSmf0YzZ449xudFvlPJISgZh4wh0lTrV1Fcik8eYgENI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a991f8-bdf9-4b5d-dfa2-08de28d2ef65
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 07:52:35.9894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n96wVlorVMw7kBXgVrBm0KqYea5B6Xe+FP4gzlUPQYOl1SFpyBddun/RVZSYOpCnDbgb87M3TiTcN8E1LV2+bwZrOzFd8J6TXoB2msNSWKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_02,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210058
X-Proofpoint-GUID: gY-tI7xXz70dNJGjNutteJ6F55uk_sR-
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=69201a47 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=V2YOfA7uUe_6pN1COsMA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: gY-tI7xXz70dNJGjNutteJ6F55uk_sR-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX+yiwNdMUhC/z
 a/sldewiWwWNLbqbphvGFsYsGzOa6bzG02w/iTiJTaZOu+4XaOnyucE0PKlnMfhNJ2QnPO2NHz4
 JKRearSe0BVMs5inOoKE0LYQL/CmHiSSHFAZlY4OxhSCW+kc4LyrkKvNX68BZv5Pk/Gdls9FlEE
 b/nCy6MWOhV7G6SFlN9cB/QyACaQgF9s7LqZ0yRLN0TVQ+53KP7NNW4YgwkY/bJUzmelngZj/Js
 pCCbr4JuFE5amnkYMyfkfiYSBgaIdXKEHIHgt8QMEmwPt/V8dcGe0y02k9oKGoKE5++fLLEiyt0
 SuK6LhSLALGfEabeHHugbUW5vmmV50tzSM9s3kHXNRdIrpQvGZuesXspMHPAb0AyZlc4x8poqsx
 CG8EXiVGQhNvnoxYgRrnItzuaZFeGxTH0S93R4YMLJjhBl8DKgM=
X-Stat-Signature: ohijmygnxhofeofophx8jhc59m7gfke3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6860B180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1763711565-89894
X-HE-Meta: U2FsdGVkX19ViC6MuqSIfDYh0Sz7MWAA9kBv3i3nSM007Xo/mIgQV+wvhcTKMplp+qqRIx+3PraTG+BxB3ujoGEyMy4M9xM6uet2xzCGlrr+k1uScWOMXmOGiwmqUNRFcl+bNZb0xtfaeHSFEmGSFmKTlTsBwwVNU+XFLrNBvCJ71pW6+Hu2j6x47c4V833DDU3EKsP5DzbBhtoZC6Pnbe78Sj+x7nePuXlskSzeYu2dH/CP9l0SFd7SEjhxKo6me3gg4L/jcYK9GSmjR9fZiRidjP3XvEb3VX2AGJfYaBBpgBnSaIKBxifsbEL5Jk8TO2i5hEf8B+IDVmGOgZ1I+E+Txo9IsbU2hySv9Dsw/zMrU1Qh6LXqJNT2gMGNz3r04xNGuipY6F/5K34d0yN7ozb1VoSY6f0SrjSV3HucFeg9mBAYKSvlTLe2cpy0NpFRBrHNvgvbZUjNEfjVyQVEC+8b17zZjxDccdZA8wnvKutH0HBLMmE80iry9DJ/RNz7L6RZrOpr+Ipd0EnWmBmXLfprXm/LRVUN4l1QOOMM4wpP/lpXx5Q7K9Yanq9BgZpB89GE3WNT3Y3LHvjUeKiDa+oMc8oLWYe6fuQ1YFR8XiKqhZBhyD89OjgubNUAxKNS+p4aHvU9BOpVRT6sB504IJ3ByNLzEfQvP3ps2OSb+IhPnVSoms6Pb+/K1ru1w6g91+bHRYiw7uqdobIBDRwSVOsYZr4mSa5mPWsz7fY/uYoJEb+fFytj8kHnD6eapLnCQhTOYHB/q2nwCCmzd5oC+987/deZFMnxcYWtZhU3NAE0ktBBpbNPKWFqYZAveVHotgDOVFwzreZSr1C/v4SOsN9DGg4t3bfto9E2Ojxof3/VJ8nx/y+O2FbZse2imICZJe1sj39w8YP2McZBaWP/lUo7tUSQvFh068tUbeu9j/gcjHxkzoqV1zt3NWWYTZL1i89I8LbZ8W4OKgalpA/
 HBwfm08H
 MzyBXkgrEbdzIX69XCHN5m6/IhCzCvh835JTxHDgSJzNdYsxds0YAKuWl6hjC8pLXFhHYQ5ezXFPWEG8sK9C4yq9cdiO1HpIqNMYBOHdzln0SfAN2qFCfgqYiitupI4tvmPs1G208RrSckqG38mdJZBsrYknxX6YDoyhs2xf+Bc9HzIUOpIh7rSOvHwfbilmm2W8ndHlJzcYWlP903UhotUDF7bsj5DicXAUryKqc4tBA/rwZeocWsaaNwYzD4uaPeYgp4UF9eNkurEKSIO5YpiSxFXoguI++e7AjFeyjaro3Vnun3pl9FGjhE7bjnCNHQ4WGEanUf5BhYNY82JsGduziPDC0S8hoNEy5fprmKh8ESVPGVElereT6nSlCAeeQ6pXJDsPfVhdL9xzoQlZ1OE0aLY5HvvZcQ4x7UZn+f6H/SCrQb0rCjLLlsNCemW2S0xxgQcpUYXMTwWA3BbrIEJ2tl78EffQZ/L4A3rkh0ntGrE18UnIiR7ZF6YBs2d7Vtc+YgiUIFRKMySacBMUHN+DtvtlvtrBfH0Yub+gRt641KRb2gGE/u0b1eLJSUyfBjkGEnpy5aF4VQT66cj3vm+1kmEmmzJ8lylnnywQWfiCxzS8v74ByDcB4HhI1k7L1kAOh+HRFyGnyFlqDk3JF6g5yekQvizo1idmId1bQh+qeRP3IbhwTbBmIjPMI4XZZT8vhvkfwvuiaGbeUboRbvybkIUX5+Bp1ks2pmq/nlKBZ/IIgl9J9eGVCLkMbEoFYJ/3ZIuWFoU5u2LsWljMndmcxPkn5ehEUp5PI4inBBNhXt+xRdT/mxksF9kRbCiSMIQS6cy1tYwGEW9oiABONnRNq88iXPRcUN3of2i/F2B9L72c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 06:51:31AM +0000, Kasireddy, Vivek wrote:
> Hi Lorenzo,
>
> > Subject: Re: [PATCH] mm/mremap: allow VMAs with
> > VM_DONTEXPAND|VM_PFNMAP when creating new mapping
> >
> > Hi Vivek, thanks for the patch.
> >
> > In general though, let's please not make a fundamental change to mremap()
> > behaviour in late -rc6. Late in cycle/during merge window we're really only
> > interested in existing series, series that are less involved than this.
> I am sorry about the timing of this patch. My intended goal was to just start
> a discussion to address this issue we were seeing in Qemu.

No problem, just underlining here :) No reason you'd be aware of this. We are
trying slowly to manage workload. Slowly :)

>
> >
> > On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> > > When mremap is used to create a new mapping, we should not return
> > > -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set
> > because
> > > the old VMA would neither be expanded nor shrunk in this case. This
> >
> > I guess you're trying to be succinct here and 'clone' each input VMA using
> > the 0 source size input.
> Yes, cloning would be the right term to describe what we are doing here.

Right.

>
> >
> > However this can't work.
> >
> > This operation is not equivalent to an mmap(). It may seem to be for
> > ordinary mappings but in practice it isn't:
> >
> > (syscall)
> > -> do_mremap()
> > -> mremap_at()
> > -> expand_vma()
> > -> move_vma()
> > -> copy_vma_and_data()
> > -> copy_vma()
> >
> > Essentially copying the properties of the VMA to the new region.
> >
> > But this doesn't work for PFN map.
> >
> > At _no point_ are you invoking the original f_op->mmap or
> > f_op->mmap_prepare handler.
> If all the properties of the original VMA are going to be copied over to
> the new VMA, wouldn't that mean whatever state, page tables were
> setup via f_op->mmap or f_op->mmap_prepare handlers for the original
> VMA, would also be copied over to the new VMA right?

The problem is for these 'special' VMAs the VMA doesn't fully describe the
state, some of the state ends up in the page tables in a way that cannot be
reconstructed on fault.

This is really why we have flags like VM_DONTEXPAND.

>
> >
> > And these handles for PFN maps set up page tables, because PFN maps
> > literally do not exist as VMAs which have properties independent of their
> > page tables like this.
> >
> > Equally VM_DONTEXPAND implies the same kind of semantics.
> >
> > > is particularly useful when trying to create a new VMA using other
> > > existing VMAs that have these flags set, such as the ones associated
> > > with VFIO devices.
> > >
> > > Specifically, there are use-cases where a VMM such as Qemu would
> > > want to map a non-contiguous buffer associated with a VFIO device
> > > in the following way:
> > >
> > >     void *start, *cur;
> > >     int i;
> > >
> > >     start = mmap(NULL, size, PROT_NONE, MAP_SHARED, -1, 0);
> > >     if (start == MAP_FAILED) {
> > >         return start;
> > >     }
> >
> > Err, MAP_SHARED and -1 fd? Doesn't this always fail? It does locally with
> > -EBADFD?
> Sorry, I was trying different things and did not copy the version that had
> the MAP_ANONYMOUS flag to the commit message. In other words, I had this
> in my test code, which works:
>     start = mmap(NULL, size, PROT_NONE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>     if (start == MAP_FAILED) {
>         return start;
>     }

Right yeah :)

>
> >
> > >
> > >     cur = start;
> > >     for (i = 0; i < iov_cnt; i++) {
> > >          if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
> > >              MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
> >
> > Trying to cleverly clone a VMA I guess.
> >
> > >              goto err;
> > >          }
> > >          cur += iov[i].iov_len;
> > >     }
> > >     return start;
> > >
> > > The above code currently works when mapping buffers backed by
> > > shmem (memfd) but fails with -EFAULT when mapping VFIO backed
> >
> > Right, which is expected, as described above, you _are_ expanding here.
> If the original VMA would remain unaltered and all we are doing is
> cloning it to a new address, would that still be considered expansion
> of the original VMA?

Yes.

You're saying 'make this 0 size VMA size N'. N > 0, so it's an expansion. It's
the same thing as if you were expanding N to N + pgsize - you are trying to map
a range without having invoked .mmap[_prepare], but the .mmap[_prepare] callback
establishes page table state (and performs checks) that are not encdoed in the
VMA metadata and are critical to the mapping being valid.

>
> >
> > > buffers because the VMAs associated with iov[i].iov_base addresses
> > > have VM_DONTEXPAND and VM_PFNMAP flags set. Therefore, fix this
> > > issue by not returning -EFAULT when a new mapping is being created.
> >
> > We're not fixing an issue, we're (unfortunately, incorrectly) introducing
> > an entirely new behaviour of permitting the remapping of page tables
> > belonging to VMAs posssesing VM_DONTEXPAND and VM_PFNMAP flags.
> I mentioned fixing because with this patch applied mremap no longer fails
> with VFIO backed buffers and my use-case works without any further issues.
> However, I do understand that just because it works doesn't mean anything
> and that there may be other pitfalls that I did not run into, but I am wondering
> what those are?

It absolutely will break, see the .mmap callback for vfio, you can go past the
end of the physical range...

Your change makes expansion of non-expandable VMAs valid in all cases where you
aren't explicitly setting a fixed address. This will break in all cases except
where you get lucky.

This is obviously a non-viable solution.

>
> >
> > >
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Jann Horn <jannh@google.com>
> > > Cc: Pedro Falcato <pfalcato@suse.de>
> > > Cc: David Hildenbrand <david@kernel.org>
> > > Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> > > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > > ---
> > >  mm/mremap.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > index fdb0485ede74..d3868d941f72 100644
> > > --- a/mm/mremap.c
> > > +++ b/mm/mremap.c
> > > @@ -1736,7 +1736,8 @@ static int check_prep_vma(struct
> > vma_remap_struct *vrm)
> > >  	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
> > >  		return -EINVAL;
> > >
> > > -	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
> > > +	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP) &&
> > > +	    !vrm_implies_new_addr(vrm))
> > >  		return -EFAULT;
> >
> > This is just incorrect. I mean firstly, as explained above, we simply do
> > not support this kind of operation and cannot correctly.
> >
> > But also here you're allowing !(MREMAP_FIXED | MREMAP_DONTUNMAP)
> > VMAs to
> > expand VM_DONTEXPAND, VM_PFNMAP VMAs which is really really not
> > right.
> >
> > The missing context here is:
> >
> > 	if (new_len == old_len)
> > 		return 0;
> >
> > 	... all code below involves an expansion of a VMA ...
> >
> > 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
> > 		return -EFAULT;
> >
> > And making _all_ expands that aren't _definitely_ specifying a new address
> > work correclty. But you are in fact 100% specifying a new address because
> > you're setting input length of 0...
> >
> > So this allows _anybody_ to try to incorrectly expand VM_PFNMAP,
> > VM_DONTEXPAND VMAs. So is wildly incorrect.
> Is the problem here with VM_DONTEXPAND or VM_PFNMAP or both?
> In other words, assuming the original VMA did not have VM_DONTEXPAND,
> would this behavior (what I am trying to do with mremap) be acceptable?
>
> >
> > >
> > >  	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
> > > --
> > > 2.50.1
> > >
> > >
> >
> > In any case, I don't want to try to support this behaviour, I don't think
> > there's really a sensible way to be sure we can _copy_ page tables
> > correctly, and even though the source size = 0 is a cute trick you _ARE_
> > expanding, and VM_DONTEXPAND is very clear - do not do this.
> So, the thing that is still not clear to me is whether cloning a VMA would be
> considered a form of expansion (of the original VMA) forbidden by
> VM_DONTEXPAND?

I feel I've covered this above :)

>
> >
> > Additionally, please if trying to make such fundamental changes going
> > forward _always_ provide test code, it's absolutely a requirement.
> Ok, will do. Just to confirm, your suggestion is to add a new mm selftest
> to exercise the targeted codepath right?

No please don't, your patch isn't upstreamable.

I hate to say it, but I guess it's not come across clearly :P

NAK to your patch or anything like it sorry :(

>
> Thanks,
> Vivek
>
> >
> > Thanks, Lorenzo
>

Another way round here might be to try to use userland to figure out the file
that a mapping belongs to via e.g. /proc/$pid/map_files, determine the
attributes from /proc/$pid/maps and then generate a new mmap() call with the
same properties.

Cheers, Lorenzo

