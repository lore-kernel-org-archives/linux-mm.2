Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7B1C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20CB6B0092; Sun, 18 Jan 2026 09:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AF26B008C; Sun, 18 Jan 2026 09:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AFA6B0092; Sun, 18 Jan 2026 09:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58C976B008A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:51:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E690140524
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:51:59 +0000 (UTC)
X-FDA: 84345374358.20.E42709F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id D464140007
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:51:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r+wq9RVh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvyCdxRS;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLx7U/7+Ekt60OjYWvRVEtMZL9hd+IruWUax2x43Fuo=;
	b=xkXMfdEwbqNDHnK73gxB5rbOolWYK9YSbSeNXDnSECFwBVKLUWUfbtoqBHhaSiIEG3aqdt
	wq9U6Fq2/982FLNePwumZYjoKoAHo8xzsy+UEJmnrJySCjrgzRWd0buhjQOQ3T+urlHMmG
	/a3FDCcnI9AuOf7XDKDeK5gS6g4EAH8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r+wq9RVh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvyCdxRS;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747915; a=rsa-sha256;
	cv=pass;
	b=nhitcqIY4/CJL2hv8HlEnl27/o+DXQzpJxoBOFbbfz8Nnm0Im4q/4mAUbNV4ilJL6Q0Bhy
	7j3zqSJe3QmwsqdHeJ4fd0mIT3v7UeJZeh7VwzDgv5qORHmb/I8DoMIPxopjkSX3g11KRb
	MVnTGmJHVusMyMhPok9TMz6m3rLenDc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IDZjFH3576243;
	Sun, 18 Jan 2026 14:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JLx7U/7+Ekt60OjYWvRVEtMZL9hd+IruWUax2x43Fuo=; b=
	r+wq9RVh/GNBAIyTgN+00FgSoafN05nRW/8PQKBfzgGL8NHoDdRDrueLa0g4cwC6
	prNilxwCvm80EwgK0jGKCyDmqv6I2uNVEIM4RWuPc+TgL+1yw8kL1hBA5Zqz7KOM
	IwbbnFFJGBgycvlUDwr3oWfPJkgUCMkN+SeNZhGahCtiWcIAGA40uQhaNOqAuYG1
	bdalLAMeUqCJTiGrjG/Wsp5PCO212IHeiiZRkQWo5H7bwg4HzUonEeJ9mEaWVbTJ
	vEP28CtJiAHHJVLi4nDq7B6ZMP9CgEiQReuWWB2OEhEnYDBZdeluV+odx+V/MY2o
	Xz8Sw/2NgJ2fFISQ+cSuig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9hcdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IBV3tf022453;
	Sun, 18 Jan 2026 14:51:50 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010030.outbound.protection.outlook.com [52.101.61.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb7b01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qj5cZTgT/82M6ir09HS76qk+6EubwAgqtLNxPcBTs/69EryzHyvO5chOe46NnYVPDlif3IWSTvizPdiBD18Uqk4TZ1Q9waUxzagfvUyQL3RFT8YLRtdzsOC0m+WDW9znJFO0xrFbcGUyW4VIAPy+AO8NWWnm8XCk4EAvocwCmZbeZk++L35hitM3yERjjMIO3oXPJQOJi4R5I6UYiD+VWvMs6S74M2MpZRslShSjFLZTIiJ/sO4Gp/ajbVdofZsneiSUyUFMbI8picRrHefhlNc2/Sy6MFjfox5FmB6Y8gihvMrdCAv8Pimf+1m9wiHyzxSU9yV4sfSBGWzS5+gO4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLx7U/7+Ekt60OjYWvRVEtMZL9hd+IruWUax2x43Fuo=;
 b=WwDQlWdjHlshkpL3+gRHgW7Atp5yZ02tnM35zUG+VtXb9/BPNGMxhZ76dsKb0OTDcYefp+vTKEHyl9Z6VJinMTcL34jZtzKHSvI/fXS1Nl3y0IMD1v2f4w+2TbaERDQ5XtcelBft8Yt16jpmI91rf0tN5CII0WrwqtPfQSstrfRTg1aK1tZjhNAztAe/d2EqAtc6N9cbFD7DxiAg99Mn7WcrhZH/xLzuIm6zdxT+Xb0v3z4FaBuggDzee2JP24X+Vn/YzBzvsQYxkCgrOlrI8/5R7vJH0fRZw2YhGFHW9Q2JAMPnCePMQF2ue7QeY8tRUF31VzBAveMZ+2qQwD2fGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLx7U/7+Ekt60OjYWvRVEtMZL9hd+IruWUax2x43Fuo=;
 b=wvyCdxRS3TxA1mNW/A8sOIAgBjo2CHLqoLP0rFvUf2cglD3y8tEGbQR33sHjrI+xROFh4wCxXVFUL7AE99GU9i9dT7AbPnn2wEWX0G8PalE2nl1zZ29olKwTA7DlY8H8WlP0wtOzK1wvkSMAtZCcZ6ox3klLJOuSGcZMv5NejhQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:48 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:48 +0000
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
Subject: [PATCH v3 2/9] mm/rmap: eliminate partial anon_vma tear-down in anon_vma_fork()
Date: Sun, 18 Jan 2026 14:50:38 +0000
Message-ID: <9923da5f8b095dd1e8d677692dcaf95859de0ef5.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0479.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::35) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 398f34cb-5ebb-4faf-cd19-08de56a11b2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Uh3YNedItUdMpoGe7mXikznNegExAAELZ7Cxn8uaRFGDWDS36IO1ppMdiEg2?=
 =?us-ascii?Q?xzzvsSvy5j6tJZpTADoiF0n3C0jDziZb4xy4MlAFORQO93djY8Y1dRp23q7J?=
 =?us-ascii?Q?Qe/YF8PqZa+b4E95KPJHSuW12MF0hg3PBs3EVqtrlQljgiGfKff/RrY3X7fg?=
 =?us-ascii?Q?ZA+Z6MlAu5ULC4r9TXZ1coiJJ62hrmsICA2YvDIt25Dn3Y6eTr8r6vTCELPy?=
 =?us-ascii?Q?ggOaANu1Euh+ykqbIcI1Xpp1J2gEeuwAUcnDTcr1EyIzTBOmGLJ1TLFm3Vnk?=
 =?us-ascii?Q?XdtbJUx7fS5TcB+vCx06yg9TP8KXxtCvw4yoD9wGiivYgQZ1TmRE7UeXIUc4?=
 =?us-ascii?Q?xbl37diWWUU01AcxjJ4jBCrhxQETSPSUtiAdLlYQHvfdIe23uiDEsWZdRvtM?=
 =?us-ascii?Q?kwNk29KxSs49WQMwvmqlKDd5L2vcs4N2hsQEySjSFhNNnQZ0MIEKwh1Hvn0t?=
 =?us-ascii?Q?/ferIk9jd4odbEKM2i6rW1CwJdWR10X7ilzSuNBJUgmvraoM4MrpbW+M0d3m?=
 =?us-ascii?Q?Vd0+ReBzBvV5oNqKF2QQt7eu4CNHgURCIzAAgphblfsS76FQFD6KFOXdGbjR?=
 =?us-ascii?Q?zr7scG++K+IIK5iwD8apSUeiaS4lD+rM8BVtt+1Y0RoDQ0hhFVDsanQeLWCy?=
 =?us-ascii?Q?Pa0XekbkJbgMFL100kxn2a1lNXYa7VSxZ/wQ1Zy893FCJxFsqG8tidbjYkXC?=
 =?us-ascii?Q?AIFzitevQStw2w0secN7QsP1F3xVa1n75GqK7Q+dzSss/Ulxf5LTLEpwQodc?=
 =?us-ascii?Q?9oiSKJNbZ9lPXfVVQZN+J5cPEsZuBebSulM7HhEOPZfG4V3pomlJKrviffdv?=
 =?us-ascii?Q?8f4xWy9/Ika850XaPV6WrxU2YGzd36gkVjlZ2qwUi5XbBS8G9UIjsJTs1DIw?=
 =?us-ascii?Q?68tfsU0DbO7GAli/xBrLLCCKhdMei/Y1t2TQE5iRN+Gxx+ILJBCrYtzzEoa+?=
 =?us-ascii?Q?IhUr3WOeCeOqpAdaHRG9T7ij6ztQ5yruo71Sj/q31e38GH6k2tyFTqP7b3aH?=
 =?us-ascii?Q?rJgv1DPiFcsy1UkPqSLY0XLr2u/20KbBD09tvUwJkPjcVVHkfFidt7En7F2o?=
 =?us-ascii?Q?fJHgdSN0TXSMicXcJmm0PZAWmJDgZA+l4kwXj8YiKs+w8/7nHdoo7DrKKY7g?=
 =?us-ascii?Q?GMPVVzu7F21kgw+IwAxf6PVRur4PTb5MYwPQo1O7PV75FPOGb5BEvmINBnRA?=
 =?us-ascii?Q?1bX8bqndG3DLNBAvLIN/rCxh5mtikVciWBkLA4I7EX91bLB6aIXByS2pKfjt?=
 =?us-ascii?Q?RcSP+MvAqhSmh8C+a3cTfLHp5YbloTkhm75QAWRNyCEMZJs4EKIbUfqX02bb?=
 =?us-ascii?Q?spMfg68C9e0L/2AZMvDjeemm4GQ5uaq9tFwq1qcbYRVn2m5M5MaRxpBsbQeg?=
 =?us-ascii?Q?f2h04paHR1ZXnMPafJ44ymNfGiCV7N5JCEy6wc82EFfi9qLxQUnvEzdgTakl?=
 =?us-ascii?Q?Kn2oxo5JlY301jGQwWXvQ3PCANK78qQ8L/WjC/WPg2YqH7hgWIMv7ZKb5y9t?=
 =?us-ascii?Q?3rP3btVf/XpfKGop1iWEQ9l39Di6xvihPzIN/3iY3L9jcvhRC7RCIx1e5beM?=
 =?us-ascii?Q?GvQnGXU3LIQ2leSi8aM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/168IRZ40cHioI6B4S5NQn6kBKh2fh+8hbJlEoXj357fLVnbAzwMtZx8tKTU?=
 =?us-ascii?Q?L7u7n/olc8xDFimty5LLUNoKh+FKNFNIblsGNMbdOakqZ5XlZ1LHdfpBkxCh?=
 =?us-ascii?Q?SErse9dIiWFqIyy5ddOB9llim/G5nD7v8MyyXLE34enD6aFVB2/f1hyjQ2oT?=
 =?us-ascii?Q?2K51SMrC46tT21qfeP57qxLitmyRk0Wl2O7TLbJB/DQrXYRnAMvzMHHd4kdw?=
 =?us-ascii?Q?uP/xxIBSSDiASqNH31rx4lM7K5F1r845vzCCom8eYguHWUuvtP3XXsIuiioM?=
 =?us-ascii?Q?5sO8b0251LcCuIP8slis9Fx1Lc1WTO6PY+ckMRMC1LAJGkLG1+srIdsf6J9V?=
 =?us-ascii?Q?mr2Cn69uBd+kmM6wn/f6mOD8xXGl7vMDbhLzYkStosPVi/6xK5tSviuYP4jj?=
 =?us-ascii?Q?nRVpFq3anCIssEXVQ64cMJNgwg5okMMJlLpgvVdxnqWw1Y8klC9TkYykrHUw?=
 =?us-ascii?Q?z/UR1URjBrA9s7Oefz4XnYxgpUkHdY6IE1s7aObhanNWi/GvyCB+FmOXFews?=
 =?us-ascii?Q?DcSmQ67LMtyKXx9HhHIrhWHA9n5coBdCf6gJR7AaOfrUgZZPB++ovULHppUg?=
 =?us-ascii?Q?kpcQci4UUU5rairMA+mXUrWCoJNF7BcA++2w+aBhMnnW07XwhwjEbRoefHHq?=
 =?us-ascii?Q?LdBMk5qj+lhduCUypO4yAFQDhuwwTLs64UlB6FPDBNpX1BOVUPW4KfFKKmCQ?=
 =?us-ascii?Q?dFAe10m44+gm9Yd41KiTsoCXB0xwSL3B0rrFbei2pJT8uY5MNWeMxKA2ZKAl?=
 =?us-ascii?Q?Ypxov9XzJypr8acZ4x6dlkkVaGyH/a0kmkuD/ESz1jPp4HLNOaBvBVQV0lBh?=
 =?us-ascii?Q?hD8HgCFIBHfhkU92alHfzZsCbeZHh8exz43hDDMzAPaPZ4Oc9Th4FaCGvKQP?=
 =?us-ascii?Q?X7KdhOekRY9yYP2Zq/IktJiZRbik3Ha+4uriMhBGMHpgK6CL4qW8ILhutupJ?=
 =?us-ascii?Q?ntwFVIn1IgKdW4IaSAc0ruqzRfDQ+p4Vq7JdtB+a3+DvcL3VvXKqMv84QUsl?=
 =?us-ascii?Q?5A3c/DF3nMuueEOEQcURDjai+3tht+bqe70mkQn8GNBqUEThxCrGOXKtrfOU?=
 =?us-ascii?Q?YMJHHRbij+pYe5fr5C7NqF2yG7Lmt6dm0c8K00beR10R+39WDI1hT7y3JG08?=
 =?us-ascii?Q?Yx8uhV7vtV8bGSYQQCAyVLI6CzbwCi2YEL/RufoIeYh/o6brj5IPqxRgJ1B9?=
 =?us-ascii?Q?p5w9oGprukpmgk+mXwOarsCuBVZ4iQ7LImG3zqwaYmPKqwY8Esb60I+vOZUp?=
 =?us-ascii?Q?8ylTQuQyamiyxJ3nXd0/30NXQ4JQk2K2mlKDZytHDK5Kas6RymxMuXh6f8Wy?=
 =?us-ascii?Q?i3WEP9WuGgzb9xmViNDtWnlw2/satloPN4A16Yv34qU0yuDlmP/TkjGrK57J?=
 =?us-ascii?Q?2mTMuL1GgvNhJw31x/MMIgypqLdgEudkoG/8d1ZMo+uCK523gxOFScLW9Jmo?=
 =?us-ascii?Q?8wx8vOgd5sTFLn5NHR/Ughvoz5M80XnzLlarmI/Q8UrGFaJU/FtXU7Te/N8Q?=
 =?us-ascii?Q?vLAMVMEyND6LqnqX/bTE0KYLEmY9iooAp2QvHiTK1xlkLNUcC9uu3XHmrVm2?=
 =?us-ascii?Q?7qfIULgcPbU9tOHADzZe/l3RjzHtFzNVjzbrn5MfuKm+hz6Ww5heJasZpphh?=
 =?us-ascii?Q?unPvj2bCsCu6Q/rkbj/QZJDwGr3wN+xHmX4vunb5qpnz8NO4qxVQc9JvLSso?=
 =?us-ascii?Q?na0UrY4sj9VzHTw0/Lu4qkOjTmHk7pmgB/xq2CymeRygADaCCVvweRA17y7P?=
 =?us-ascii?Q?XXt9iZFxzabt3azQqRWWPJ37BP+z7HQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XOsSkG6xdMJpWsKSaUBNbWNcGGP/14f4F7Z3rz1BUFKq3qhPjI4n+n9xS6Jf5+7HCzPn8PrjMQoODlDa2dNK4kl8XDKDS/Wvg5E3BQbAkfjTPssyNMWTPZGYwCSIP1OpK21X69kByNVKAg9vqAP3+Tb6UEBi0B8ZRLIKjjCHPPCbFrHAkDQ76yj5hRws1eeBvNlF7IqiPNXkK4BujVQZPYv4L9B37ohs0GlhnMfc+KHveyVFCmI9eVSusJsJj8kAi4oTvQ6vLbAI8SA11qt8xIzhIe9MadVW+q96qV0fC7S7Di/XJ30WuiJGcyLA6LKJaFHT/td2PFY/dm45HuICcFIx67e7c4+8TmZQcHlN6CmIrzxH86M+YpfsicbFrIjs3dK5T7XSf8HDW/UeNOkzrJ3eM+WL9uUybsarFXhGsoapOh+970Yjwu95ypqob2KvNwgBUjej2nOKTjEbmSkjpVSn2al1n8Fd1VxHRJhKnbWZFtmKpPL79qcLwNadGLH08Pe9YMS8Dt2uwlsc8avGd31zCcFpmXWi95O39XufIMzqPRTtCXelJ7mQGs5IzUhlf8WgIv6PveL5SBn+fh4VdKKPOHu6jX1sJSswOPxlKww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398f34cb-5ebb-4faf-cd19-08de56a11b2a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:48.0221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ymFm+2Px/DhxDS1PP6gCj205+RNDjk06hQ4+gtF/PL7u4ruUJIXO7wVSc71aKKoNds7oCJb8u1VIYIpfGDd6ILReMrEaF1+wmiJaYfvCmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=965 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=696cf387 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=buoZ9BBRBGxsH-PATAkA:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: 1iuVt8OKWAoLjfK18QtiZeEbOQ-IP_Ic
X-Proofpoint-ORIG-GUID: 1iuVt8OKWAoLjfK18QtiZeEbOQ-IP_Ic
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX7fam8ZBq6kAf
 nn/mAAiXuiLyYfC8qHNy2hiYUpFw0TeIkYgLx3NoIPksP2Id1dVmJbPHsa4A+gYic3mLBX4QMHi
 PGXgVH0Zy0ZZN1rPbnY0QyI0Pa1tt00zOd98sNFr+xpeAcoADgwIQF7rle0++aSL/EwpT1NKMYF
 o8lLHMHHsOy6MdmH9LL1xcHbIcgzueeZWaPdvzhqCzveGm1VED1psoddp4Fcl7x1LkHI3wTTTTB
 cUnm/dy+5uee9ou3CFRkEhjnQ0B9YEJEDNr+u2KQdF6NJTdkj89G0qy+DQsClKedvjt9iEjO6FT
 WrlJQAgEE+CjaJLWfGCir28/qXnEwFpTuDWDCRrqp56n1oxBFH6Vh91GqNbJt7P7M9hec0kFkbq
 GY/zxFnYF09THZNAPpDfM4+8VR933K1rBtnY24ii9B9iam5VxenT8mE8EGoWN9HPZS+QyOQAVhP
 OrfS9SbBuGDbFG7NZW79Rc4RbSen2eUk302KP+wE=
X-Stat-Signature: y7we5pjujscytxjbxwrf6note7sxc7w9
X-Rspam-User: 
X-Rspamd-Queue-Id: D464140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768747915-157545
X-HE-Meta: U2FsdGVkX19CrrnjGWr9/ZhcwqN3qa4+sucSii3PT40x+CXtZiHdG+yjAaAbxUS4oPuTmsVgyi1lDPJ+5LxkJxK+FW9VtDu35EXu4aWZU3jfri/EMreRgjvCRv21AP5zIrfdydLIwCpqkrRuHB0a4irKdJ0wEErXO1Umz9oe/zhC7n0ZVEMbkNjs/Suv3xkQ+o/cPaGdrduBeeTl4ABkjGvsZYQUSBBBsf4ePfYULG//tX+Xa/KXXzguauxiVvsO+LOOfyQQXh2LvUFm35k0sCPtQQXnSZ8bs3803hyMVj6ruRaJHaBrSuMyQKZmfFbWgO64jBPzSScD36nCzQ/BGfXB2BfxPYlm8zRrX7HvHyU7vEbQ/YCG48Jya5O22B3mvPDVd1/gWoztx2WO4SXo/iMh5qXCKtS5ZNF9ADwqsJKkJnirpz9PjWc+j9cIvjHjYSUz5hzxV6Z5wNJHCcLVjHJU5PR1hivuC/tzrdOxVongS2OH3B2ojsuK+W3VcBVou7bzSI/8s+WFVLxqe9xz7wqLooNomhEHUxyd1RTmMB6vZHOvLNxc1FGpNqdbdyr6Dq+s8ywo7i0Af4LjhP2/V1vsqXItNZwrAQlosAoLpwoyqw+9sS3SgirDQvKnmIeO1gd3ru+qn54xhYvm29loLTx2QIhtL5hPhnDqRaQGN/PkEeKluAO9JurisXt1Ydm6o2H5uHpmkEfMtVW3lHEeyPNsUDS1fqIMwoJq6CsMpCkFuKvz262P2t2AIP9KX/iM0ibbudFYx5My4OcRalaX2/bhrbiZ/Gy29HHGZoJ6hTTH5rKHmIiZCCBnt+1/MYPvUTilRpPeyfmImydmrEvUr/xPbhSbChl7wrQRrko+PTkCHWDIS9/OO/9VdcNCPT8xnK0WRpw1/TLxlBwg4hdELD1btbguJn9VUpke52zJ8ry0Urz2yYYPNutvpv4ahTZpBieDHVdBgedb6OjTLF0
 WQNSkmMF
 YkLyF6CdbFaGwuvSLExcKt4VX9yeHcSnu8fkzLlENzUPADUHU4JriKo5laQTFGuHq641SYZ0BPIVnAVi9jli066xvdo+sCMw6eOzzYNGbTwWVptga+phfJqWkiaY0aclalodS6XtX2zvBUKncQfB7VnU/+kbf5rz9ORs6S3ET31y2JgV+OxLIcz6x5U0mY9FoWvI/2ioRNovCNHsBJEAn7P9hvZekuinDEeIpxtd9EdY/AdlbX5JAGM6lqtAiTs5vljC+DyetKwEhH+2kehmc85bCIieg7jbal9xeHMlCPM1uM6nRgRbpL4WD6porHvBofiBX2B/LVa3iygkK2llcBzYykl201XPguyQ/T4rWGWW5HdcC6Xkj1JkB0k+nd8cmc95RYiO2AW+A3wELi93a3JqfrrIgxU24A6gfMw8lpxzSYrlHfoboX7kyp1esXGtsbu3o08uLTScO8/LgnjAvDJokWGCAZY7TIi0HwFLW40TT2eXmooNkctC2e3ZGo3BHv9Kt1wpLi+6TtIRqCh5sxRhisWopR3za7uftBAvsBwIm/SlSNCgt1rUOrNnwTk/mLxd7lydvkLcYiM+L7rPSFkL8r0EoIERoL0YiXPaEwqKEHVc3lFU6kGTy7PINoDj7rRsZ6aa9xzUBU13nktEe+p7gL/6VOd0f0OCf7R50JeVLlpfJrdulM9KSFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have spun a web of unnecessary headaches for ourselves in
anon_vma_fork() with the introduction of the anon_vma reuse logic, as
introduced by commit 7a3ef208e662 ("mm: prevent endless growth of anon_vma
hierarchy").

When we clone anon_vma's linked to a VMA via vma->anon_vma_chain, we check
each anon_vma for specific conditions, and if met we set vma->anon_vma to
this anon_vma to indicate we will reuse it rather than allocating a new
one.

It triggers upon the first ancestor anon_vma found that possesses at most 1
child, and no active VMAs.

This was implemented such that if you continually fork and free VMAs, you
would achieve anon_vma reuse rather than continually allocating unnecessary
new anon_vma's.

This however brings an unfortunate situation should a memory allocation
fail during this process. anon_vma_fork():

1. Clones the anon_vma.
2. If no reuse (i.e. !vma->anon_vma), tries to allocate anon_vma, AVC.
3. If 2 fails, we are forced to unwind step 1 by invoking
   unlink_anon_vmas(vma).

This means that we send a partially set up (i.e. invalid) VMA to
unlink_anon_vmas().

Doing this is dangerous and confusing - it is reasonable for kernel
developers to assume unlink_anon_vmas() is called on a correctly
established vma, and thus confusion arises if logic is implemented there to
account for invalid VMAs, and further development might introduce subtle
bugs.

It is especially problematic in the anon rmap implementation which is
essentially a broken abstraction.

The patch solves the issue by simply trying to allocate the anon_vma and
AVC ahead of time - i.e. optimising for the usual case - and freeing them
should reuse occur or an error arise in anon_vma_clone().

This is not egregious performance-wise, as this function is called on the
fork path which already performs a great number of allocations, and thus it
is already a slow-path in this respect.

It is additionally not egregious in terms of memory usage - the allocations
are too-small-to-fail anyway unless, for instance, a fatal signal may have
arisen, and any OOM for such tiny allocations that may arise would indicate
the system is under so much memory pressure that the associated process is
not long for this world anyway.

We also update anon_vma->num_active_vmas to 1 directly rather than
incrementing the newly allocated anon_vma's active VMA count - this makes
it clear that this detached anon_vma can have only 1 num_active_vma at this
point.

Finally we eliminate the out_error and out_error_free_anon_vma labels which
makes the logic much easier to follow. We also correct a small comment
typo.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index cdb7618c10b1..a45b011e9846 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -360,7 +360,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
-	int error;
+	int rc;
 
 	/* Don't bother if the parent process has no anon_vma here. */
 	if (!pvma->anon_vma)
@@ -369,27 +369,35 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
 	vma->anon_vma = NULL;
 
+	anon_vma = anon_vma_alloc();
+	if (!anon_vma)
+		return -ENOMEM;
+	avc = anon_vma_chain_alloc(GFP_KERNEL);
+	if (!avc) {
+		put_anon_vma(anon_vma);
+		return -ENOMEM;
+	}
+
 	/*
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	error = anon_vma_clone(vma, pvma);
-	if (error)
-		return error;
-
-	/* An existing anon_vma has been reused, all done then. */
-	if (vma->anon_vma)
-		return 0;
+	rc = anon_vma_clone(vma, pvma);
+	/* An error arose or an existing anon_vma was reused, all done then. */
+	if (rc || vma->anon_vma) {
+		put_anon_vma(anon_vma);
+		anon_vma_chain_free(avc);
+		return rc;
+	}
 
-	/* Then add our own anon_vma. */
-	anon_vma = anon_vma_alloc();
-	if (!anon_vma)
-		goto out_error;
-	anon_vma->num_active_vmas++;
-	avc = anon_vma_chain_alloc(GFP_KERNEL);
-	if (!avc)
-		goto out_error_free_anon_vma;
+	/*
+	 * OK no reuse, so add our own anon_vma.
+	 *
+	 * Since it is not linked anywhere we can safely manipulate anon_vma
+	 * fields without a lock.
+	 */
 
+	anon_vma->num_active_vmas = 1;
 	/*
 	 * The root anon_vma's rwsem is the lock actually used when we
 	 * lock any of the anon_vmas in this anon_vma tree.
@@ -410,12 +418,6 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
-
- out_error_free_anon_vma:
-	put_anon_vma(anon_vma);
- out_error:
-	unlink_anon_vmas(vma);
-	return -ENOMEM;
 }
 
 /*
-- 
2.52.0


