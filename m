Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89777D39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0226B0005; Wed, 14 Jan 2026 13:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC76F6B0089; Wed, 14 Jan 2026 13:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA086B008A; Wed, 14 Jan 2026 13:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C58886B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:37:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 737481ADC84
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:37:12 +0000 (UTC)
X-FDA: 84331426704.06.0624BCA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id E13B2180002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:37:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H2NQfSVf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLu+LSAm;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768415829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSkNyFf3zbrtNHg7LNiybXuIz97t1dRm2+dmZBI8TKM=;
	b=kdfwHwjOOBN7+cdbk3SbZNai1XEuZdofAod6wuxIkEzxJbs/3HMC/GcuneQhPAEaT72a6N
	EqGmEidbTJVFRQmjydI2RqHtXxL/RdgI3A3TdFrQqqsZrrm4ZqyU9riBAchMSZvWt/sGXZ
	LMveamDZgirlQ84or2OgYwN5X+FtrVk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H2NQfSVf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLu+LSAm;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768415829; a=rsa-sha256;
	cv=pass;
	b=KbOrbbjIjrvXuzpIu0yR5Af9HKGi1blVX60idr6QvuN6KeSZQ/dyN0IEoIeK/lBPeCYFo8
	Ij8XtbjAmSCYcy0YkLOjsV2w0lP4ASAQXnWMDiYdnXdm3gfQPfuR1uK2Byzrato04IN0Zr
	uOYYXpMezmwGW19REEAvcSVm2YuuVNo=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EIA2241361981;
	Wed, 14 Jan 2026 18:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XSkNyFf3zbrtNHg7LN
	iybXuIz97t1dRm2+dmZBI8TKM=; b=H2NQfSVflqEOTHOubOuZArHddjl3SZGyQh
	xO8y/wb3tHEfjxCP1TATfXoGjcalJpH9onfMXAI6G8nf57qON+Ehr+XkY9pOCFrn
	KdeRZcElqrM+AXwUw0moMXGIriUplKUNyDTRECuBSAsrlypAyRvUz2u8SPgDICL3
	h/h7+NXMMi/NjdmZy40i1API9dZZHZI0MYlzzOGY3K6nbJds8NwoYVVTSW844LIb
	0sJiMVT0Q0NcMk9AVL37NVSCiX01Loo5k7R+IJ81bSLvbmrkpBmr91tD6OFtI6PR
	wuUIYPDtQuFd6WjkdnzZ84yaFz59r3VdJu5UWcqeprpjZDVGQiyA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp10mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:37:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EHPsdV000463;
	Wed, 14 Jan 2026 18:37:01 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7e5sqb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQmOAnam5gnB4Xf5iL/Z6NGyIOVtQUkf3qT1tlQWozZ2BWE1GoPL6iUAAA/rPC0L0QRsfJobp7hYEjzBN0s2BKSKYY1LRoZWQTb4cQ8MzFekcydVg208bv49Dyj6kLeWxUbjbi2KEytxKDC8UyHjlg59Bc5V18mHyybNFfeKK0aFO4tAD/4nR50hZvBW/kNrcElONtVvxXNEwyffd9DJIC70k8gJE17mUfqQd6kInqhPilQz9/AGiSEoOT6kgZL3WduWnCTeEvqsONyC4UD7fPgg2tFduouoXmz4mpoluWQiHD95ABz70UEv1pfzH3v2dLEpPoxDd1kg9IG9H1S5Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSkNyFf3zbrtNHg7LNiybXuIz97t1dRm2+dmZBI8TKM=;
 b=lwUWMqc8z07iGVOInXrzCocUYW49sPxgIN2wJJBmYJRXkqxjJW7THb6zHDR95xjWRtwQC4wQCtY2mXLtaxVE7IscyhjEMrMMNm+y1JhPDVBvcBdvohEE7kTHVBU8uJeRh6WbzJ7fT2GLKxb8qPLyzz3Tcr6mJipv0u0OqKO8q/e1n6XMnHTd+F67E9/EWpkvwd1IdBFuvfivimOsi5vHX8pCL+SE14fp/mR7Ew2vguIp1CcDcndAMU1y3qIDs4RRZjKhOBIdkIjTz/D6t7prIKCBvhoEwvrTQMRzNVHgwI4Oq26wINmkGlI/ke/AO0EyZ1atxiRNrve52zR+u9JDWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSkNyFf3zbrtNHg7LNiybXuIz97t1dRm2+dmZBI8TKM=;
 b=TLu+LSAma95N3lSJeG1YUOcFFMxxOU6Y7ELEAqL09qoTzmBwbHzQ9YZ45kDrwTogVlc0vxENPmR6znGCFWsjs6gRYKtnhLwQ4XsX1GUz42UT3tRAhWrXX05lx0gkZNZVgn3wK24Y3WuNLt1fkoEaI47Yr1oax/iCieGNJ1ylfnQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 18:36:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 18:36:58 +0000
Date: Wed, 14 Jan 2026 18:37:02 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chris Mason <clm@meta.com>
Subject: Re: [PATCH mm-hotfixes] mm: do not copy page tables unnecessarily
 for VM_UFFD_WP
Message-ID: <abeacb22-111f-471e-8748-5fc3ea372c78@lucifer.local>
References: <20260114110006.1047071-1-lorenzo.stoakes@oracle.com>
 <2cfknurph2lkbfht6nqajt74fujwompjgmkhr3muiiv3snylhr@ufijpjud2rac>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cfknurph2lkbfht6nqajt74fujwompjgmkhr3muiiv3snylhr@ufijpjud2rac>
X-ClientProxiedBy: LO4P123CA0107.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c8e7ef3-7067-47b7-7e4e-08de539be624
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?akfAaSqTB8yFaRi8f5cE6kc/mqTra3AZ6Ynj9S9xotTsA5mxnuikbpooJEyn?=
 =?us-ascii?Q?x6p0qOZVxGinjNm6uSYFn+TN9Smf5aKCZZXrG8JHR1teRt3VW6BWjljK0vyY?=
 =?us-ascii?Q?udBgHzzjQ0YyqemdUIhZHm2qAzZxclgDby3kYhbOrZPY/uUv8zrs58c4Xr/x?=
 =?us-ascii?Q?jt/ejm3ujQZcYtJIt50VGWRNyUVSSmpLjz1xv56vV1tVKYfmP20ItZtrS4d8?=
 =?us-ascii?Q?Uy+s2XSApT1eQ1RlL90TQm3RgNMrVH74uGqawlnuhvrsVFF4vl0eZqm0dsdX?=
 =?us-ascii?Q?PemkzzaIDqIyf0tzlDklUAxaUDZymwhhz8cTRUtecpQ6q8SPIc/NWi8+5GWF?=
 =?us-ascii?Q?JXztyRqhUqzFdsrfl1VOy2TGYAS3uSDeOvVT8ir+SKxJ6TQjJccuzo/NO/PO?=
 =?us-ascii?Q?tmtexEeCQgCrBJwlDPGg4JuQMDug77BxJboLpalSOsJ5wZ40+tgkNSivnbZD?=
 =?us-ascii?Q?9o6zyij+qqtN7xx4Z0NFd/vzqpIyhKpuqIgoOSlWBIb3voboVLuFXhf5v2Ck?=
 =?us-ascii?Q?1IyPBlPYZRyybwTSQCYAzPmg9WAYSUTT8O/tj++iYKlxSu5Rv5WmTZhN/xyY?=
 =?us-ascii?Q?nvHrFi1R6128Ii98ZAkNSogiq8TzK/Ac8iJasDo9jyQXL5QegvHM67Ytwunr?=
 =?us-ascii?Q?8fOwVvgyd2qZaCcvqFvScGoRwZZIX/35VeL6RdUxriEHi2zQxF8MPFXuS3uc?=
 =?us-ascii?Q?/DowSIehvowbkmJHAjdWpi+ub7h/92Jz6n2FsElHXlh9wLDyA+/CbYsDZxTy?=
 =?us-ascii?Q?udklD98Zn3/zJtw1lei6ur351aiUdqC5ThiYgjEuS1sYYKvo91vlAOs0i22u?=
 =?us-ascii?Q?qpABvNeLI+/k6TFObBxgwk8wGELM2euGw4RA522o96Oa7Bep0X8on6oIOon0?=
 =?us-ascii?Q?YfDYPvAkGa1KCffy9Q838PA2Q0YZPwI2FfOMmpkySnfUqZDZyOuH8agZE2de?=
 =?us-ascii?Q?XIdStvsWuMidn2ploWY4eN0+lZlGKIev+xqlLO7amxVE/1Yxgj5TGS+hqPLv?=
 =?us-ascii?Q?ZGf2yGvdqACTGHnCJVgIfN8pJJjCSa81dJVgxqar1fr7Ex6X9QSPRZbdqwrj?=
 =?us-ascii?Q?KE/0eCcz9LYrewwqy4Rs/q0+jjkckH3Xqx5KpKumKKOD0kA07F4a2+MlU2ws?=
 =?us-ascii?Q?ml7Q0BWLFK8PK2R2AZyvKWWmPvNzMjZRI42lxk512yFINg0xsBNbJzkkxY/K?=
 =?us-ascii?Q?Jcbk3Nz/E5rRu0LSW+bAanpR7RiqD3Apo/OGq5a5J6g9Eod0Of2DDONbO2Zr?=
 =?us-ascii?Q?jHxU7uBS6FLZwNwLH6rcyREnhOrBBGiz+jYcSM1LGObqTDuFCH4TKD9Zc4ca?=
 =?us-ascii?Q?YaDvcFqvZDkQV/FBiihU00pbDhd8YwXwcXMOObFpEEIR/ek12YAJ6XVpnPS3?=
 =?us-ascii?Q?owXla/tvCgMDtVHKzYyyDvMB+S+SAV5lL3TjF5B38a3pu30n02HlswMnbEmJ?=
 =?us-ascii?Q?kGlM9qnaEmEwMnMVRy255i8pFg3057ALLwM/kIZHj5LYnZa9Elkx+md9+tkQ?=
 =?us-ascii?Q?q9Aw5Tc8a66lh+/XVf/3bRfyl3Wr6IBWKzu/TaTcls2Qdd0crX9yZfmAXMW1?=
 =?us-ascii?Q?T2DMwfGVGfGK9aFA8Cs=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Qzd6rXIqsfONGW54dxJ47Ozd0L3AkT8extUt2mp+5dKq7ORv4lKp7iJzB6OT?=
 =?us-ascii?Q?YiJ/qKLJ5piQzlJUIyG1Wdjz+Jt4XotlFMXKo4GwKvhfm8tlJ/ukoz9iEnGQ?=
 =?us-ascii?Q?Vhv6zsQGJQbJiRliMQZbfaiywQ20wrJ6aFmxuE9+h+jf1E7tVGv1jb/PKGYS?=
 =?us-ascii?Q?igJdpTfZbv5zTOPybtupe4U+owxzhCVqd9qXGTaaePO7bM774R0xlTpLEoGT?=
 =?us-ascii?Q?ho7mEFnexXvNQIkrkruTO0tVFSUuwpJJLxZP8VC+nyKzJQPwnOKzbVK5s2DG?=
 =?us-ascii?Q?xsFUOWlrro3EdtXQ8xJLxDSSQCveBGOneTY9sDcyvBnfIVm120kLO0QDbhJA?=
 =?us-ascii?Q?haAvwRpBMqTVj2X3lVBSq7j41D+y0X3228Ctu2ib9hrloKiPUwSFae4cF0kj?=
 =?us-ascii?Q?pTmCawC8tDz+uCKhnzEgWpqxohKhPnzK87AerFdLCk5CC/GZbnXYYnW4lS0T?=
 =?us-ascii?Q?FrUmJO21uH7BZ3CAILonseuKWOiExFfHdkagBfxSwJ9hqWG7OS455qtLvIkA?=
 =?us-ascii?Q?0e+eDxMTzsHoC1DCPX0chOOFP98kYmzvZuTeQhSi2M1eehh560hZ/et+MDBO?=
 =?us-ascii?Q?Cad1hv2ITXfTkbfhhznyz2ro0emjT4FhjJ/rcWuE7ftli7prePoVEKTIehFM?=
 =?us-ascii?Q?zVhuyZ64++AdfNDLVXkML/p3HNTh5BIXtfyR9GeHAetTc1kqr5PJssKzMWBs?=
 =?us-ascii?Q?vhbmM0UGQceFkx1OEWhjibwneXuv7NFaYEAycOjNz3e5FcHmjNIyVDAnc7Tf?=
 =?us-ascii?Q?5eVvS1eJ/h3RTMjfqBE8LLMXT7MfpKrU+GENwHqMlISCD5eqIHs4l/z/zIy/?=
 =?us-ascii?Q?Y+rCSz2zOji+sYOFGoutP/wabt1B7SKW/H7H5Rb08R7+IhxwKwXvT+ZYH87Y?=
 =?us-ascii?Q?ad5R3O+gx0+7B2CcjUJ4afwGcLBL6EGrmRpx3SiHIQ62YhoJGgaMbKLXBIMy?=
 =?us-ascii?Q?j8MT1os9itGEacHpU1GgKXYiPIUuJBthaLTCzJJBaNFeT3LW65GHdaFZRiML?=
 =?us-ascii?Q?MmgYQzHI+nHkbgOB2srkRB4XQXDjj6CUI0ERf+e0E5/4vnXFZca1PJWPHBFu?=
 =?us-ascii?Q?bWA6HPBkcqVkcW74YdrO//bMKdbFyutWVyCQQGMxGE9v5Jg05G7+U6X3nYBL?=
 =?us-ascii?Q?EEFTKX19WkAlmRCZaYFOG22aKXVcT0HmPK5RZPIhJX8QXA3MvPQLT78EWTJo?=
 =?us-ascii?Q?gyJxRocSOlV7UmOE237aNFhfQIRJxcV0XxLaJ/yx5zYABZ4js4LDstNGynwV?=
 =?us-ascii?Q?hM2D4a48DtYtdHOIs205n6QK+FirVGEDupGs/p+sQUBfy/Ao+uXOgF0vK0ib?=
 =?us-ascii?Q?M4IlpWOpOj3GzNHd6KC0dPPYake0f3ap4JKwk+xQ5SrH2wh3Ly+lXFdWapfH?=
 =?us-ascii?Q?eqeq84gqrcmeaON3Fiz/aB9Mt4OpePrLdOjzsWmSlJRTy3QyLGlmI+ShJRP9?=
 =?us-ascii?Q?kVl80A+0D/pHF0Mj3uLrZPTblmbm8Wfz9YUf9yu8Mgv9ADWoBHqON6Qk2ab6?=
 =?us-ascii?Q?wHK3/yGV3lCeURMX3OvHDxxBM7Comt9zjpSCIDGr9D0mCDGdrrTPWCISwhj1?=
 =?us-ascii?Q?12png53jguI9B54XvbjzOYIrwBe/n+nIa3ZPylod3zDgowphA0SjecyNzhkG?=
 =?us-ascii?Q?HKbJuUZeTAUpXc8ATMKVqhRTPT2LB3tbYGrqoHythgYu8sg8rnWCcz+EPJdl?=
 =?us-ascii?Q?389JsF5RV0Tn6ns+rxN+Puhl+8EqaIscX/SbacqF1XK7C4QU/41q3UppWHS8?=
 =?us-ascii?Q?7cVDaa9AYb+LvpzzEK9XUwy3mVPPBAs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W0tzHg6bDurtX93ZuPqIQ4nWc3fUcJedIof8tJZjD9/AEVW7OCPWTJSjcVoijZ8CKJhWx0otQwljFGufVDu1TVq6ftzh+gI6fKMHWAobKjQUVfwn07MuOwQNB/iYqfk0MBzkQVbqmx6272eTT/Ib2aEzu74P+3atIwAs6oCXXpGdMIkpY8jlEZ2TrfZHlWi2bswnj1CABjBHtkOydiH7AOl18WG3JRHfvOJyCeEjMBhiZAXq3NStpdwi+ylwuYqqPksAX1N0zB03ozGl6K8h2P8qiD4HWUlzdF/3SIqnv1xkmQ6e1tiZv4mO2W5g+feYCm1R3+OKGqaRjtPzrZ53xhWPQVb7D6MTwJdtLjPKAs352uZIDImjAbPu4lBFQ0PqvO2y6x2L5FlzlwYDkpbF2TMl+/6r53ZBJd8UVe8kxUEXt06wuE+Le/HtAWQYOvn69/vsaNe487iM7GqTTG9AW57d5SnEwXxxWFZDtkBjsWBVnM+lpz5Ozqk5c0p6ZqBXcJOVFmdXhNX41bpGttoXOLMXaNvrwn+Vf5w0XqDLqxu0zlxGeJhb20CE5H5iOpktoNDiHWv2Icltpk5/+LnMIP+hlfUCeBjaJzMhcsNBuh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8e7ef3-7067-47b7-7e4e-08de539be624
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 18:36:58.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XR0r7E8Ws5VXHGJDpl076ErOboobOnFoHSaLPf10rugJbpGa/n9J1fZIcWhnZQJO9by4safZBlKJ0VaW9GjF8szvhq56tVNLdXmvI3iHr3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE1NCBTYWx0ZWRfX5eSVXg5MLku2
 pam6mYJ5aqOkaGkPkgemllKUiHHwSMpF/54asT27J3/sVRNxFVBYhEWA+ZKRRVQUKz6onolxjyx
 pKFZNygaYDYesShccHbMnfAKC8YrDP/nPycEYymcA3fmweb94Hs/rgExK/+W040ko3anKZq7iF2
 SF5tMEj6mKvz8fgN3pbHNnE/tjhHK/oLEwUMDMzsCKkeznZiGnCykR1WHtmZ0sqqzrblIRM/FNQ
 YrVgJJw78d67qKVAlomkp0jMCBp6nabU1u2KvC4OMM2MY19rmYHSPsat0FClDW7IYAwDfZIHhSc
 dfP16T0t6Tgc6bZmTzq7tf632TkjmNt5kTFiHcOfKcmD3OLEqCBK6gbXw243Ppk4TGtJOyt32tz
 7xKS+1XfSKIYJbh1n8lhhh2eZJfke6cKV2PQWn3akRJzR1NkFbCMaDZQVUOB/gB6ZMY0ysGTDD5
 ClMT9z6S65MUptoazQvyeMacK05sxvk/ZkN4UxlQ=
X-Proofpoint-GUID: Yim1hxy6ElA2fYtDAPmKyCdFWCHTLwYq
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=6967e24e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=yPCof4ZbAAAA:8 a=xPVmgk64bnOTVGhQuz8A:9
 a=CjuIK1q_8ugA:10 a=gKebqoRLp9LExxC7YDUY:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: Yim1hxy6ElA2fYtDAPmKyCdFWCHTLwYq
X-Rspamd-Queue-Id: E13B2180002
X-Stat-Signature: k91fjg7afhtzf659y4y3d48aqxdayd1k
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768415828-44948
X-HE-Meta: U2FsdGVkX1+1Xpto5ii96hDuu4AkR6Q1Vv/9LQbx2nEidJVifzxVbtDP2fO/Kk6EJPtYJZz9n2PyrSkdKe106gdVYQ2F5y0vM78BmmLUy28KRnMpzsNe95hmnswsIBjzy78RkogKAUs78D1/kR08QHO5dHzQuzID+fqiCFOiQGYXa2//orfTAxhh5SK0Z/Nkj96clbNWIyGUh72tEe4lz0gJz6iNjCmqxg5d/ONYjbopgP5KMEWbhiFGEFRgQMY3WybQz/iUELJVTqCw/20R2eFG0QfBJn/IkfdHXKX5TvtENn2o3EHdK3wCS6lWP7pH1rehz0b+fw0Tco57QhJGheX5MDZ95USaLpy00cI5Sm7EYMHMeBTreSz2dmWn1n9jNniN5Q9i7pzGfvtgafAnhYKlSGcd5fl0i5VqEgunb1MAjMzQtmTC/LauziCgbe2uB6WJRhy4vfWPK0k1dyc2VLJ6fkhth4oaLfOMNX+N+G2YWEQSZhL3iVjXNIOaNn5GX7jg1kojjArx0RwEJxNquB000CAu6PWDAb4z2mXv5y/MklfP6p0VTP7klKK5yu62+PMUh8iAQZQMH+9oXfNGDWj5wh8mi85S1JcBZj7SN1dBPCwwTLOFtlQksC4MhWHpSclPMhVhUTO5qIuNfsOSXU0RXWg1J469GWJoUMpSYXuNfE5zzYCDfiY+Ccdk6WzuRc5R2W2CI/NLOhIy4uW6pDfDsosvgc+e/D+eLLNmrKx5drJ+5GBKPpRAK6H7MM+c7yqmpRU8cAfLINaBpY9fKKfg3SodhUu8xVSESTNHGuocs0UZNkv3cq4r6FBBohw0ecCp7E4K/Dzo/9F37/vU/5SoiDwBMlbpLW8jdPOIeEzM/ZVZ2vbAv3HnMXPODWbNlQrVZe40YDfO4MEFQte4hkVmlNACj78bNfakszHruaj8pYMKM66oTDABi07G/XZ8AAwoeOLWwfbmlf+CeZM
 s5CRqRyO
 T3wO+FYdKW+h/v0hIEMrTRfQGY0h7U7ZxUGSJ25CmN5xcVWjunJ2Z78IjVE/2GufOq41VFQHcsVArgq6fS+DLLjW8HuLqsZVJVQlQssydY9Xh/Z42Tc/d/Qfafp2rDz6bQbMO/gsRTNs+cz3JpMbg6tCJb18MbOj7VuTAIcnn3Lw6nkJm0lmYAy11O1IUl+zWo9blFIx1I8PPF30XCVKnvoC/YFnE3AcKT1KzSCJdwwT51cDYvnZsQwPaBae1KrPWUzvWhT0ESvR9A+oU6CmFLGiQWdfQgGTCL72L4AC3SNVz+QdC6/C006I0PPj/+bZafyiGUdY3uCkRRqokkyAXxgt8S3ESm18V5h+iSHGgPPM3ihnzW0AVaDtNUDrsi4tPZieNT+kL9RSn0ARXo+j2TTt/IJI9G90J+mLM+p0KCdMJnIET1nI6YceDQpgUlUPiQnxuC2RLT0o90QLvvpH9OZpwgLpqXtd6E4w8fmWmhQQzJeZzmPQ7wlN4stqFPgdG35bRBasabyQUDfgQmK9Vu1F6H44TgmqzJUXwMMiGKIqu/qcH2py0CjtZzP1LvQB6C9xB/4kosr4N/vuEeoO8w8MOGzGIaq7wRJ2uOepiTYpeK9nCw9Y+GA43FGVdH67/lkzeI8P7i7vMuG3pfPkWFJw0dlyZZag5DdKlMva6ClABiiAlj9pbuU2xxcvMuJmBGNYf5zKvgdHFdBr+WuOFy43uwOZkPESGr/owHvyxS+eUt7+4Yijb+Gjd7UEKZ1Ym7q4UUD6Ull9NyC1CeIgSnhLEbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:35:08AM +0000, Pedro Falcato wrote:
> On Wed, Jan 14, 2026 at 11:00:06AM +0000, Lorenzo Stoakes wrote:
> > Commit ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make
> > VM_MAYBE_GUARD one") aggregates flags checks in vma_needs_copy(), including
> > VM_UFFD_WP.
> >
> > However in doing so, it incorrectly performed this check against
> > src_vma. This check was done on the assumption that all relevant flags are
> > copied upon fork.
> >
> > However the userfaultfd logic is very innovative in that it implements
> > custom logic on fork in dup_userfaultfd(), including a rather well hidden
> > case where lacking UFFD_FEATURE_EVENT_FORK causes VM_UFFD_WP to not be
> > propagated to the destination VMA.
> >
> > And indeed, vma_needs_copy(), prior to this patch, did check this property
> > on dst_vma, not src_vma.
> >
> > Since all the other relevant flags are copied on fork, we can simply fix
> > this by checking against dst_vma.
> >
> > While we're here, we fix a comment against VM_COPY_ON_FORK (noting that it
> > did indeed already reference dst_vma) to make it abundantly clear that we
> > must check against the destination VMA.
> >
> > Reported-by: Chris Mason <clm@meta.com>
> > Closes: https://lore.kernel.org/all/20260113231257.3002271-1-clm@meta.com/
> > Fixes: ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one")
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Thanks

>
> > ---
> >  include/linux/mm.h | 6 +++++-
> >  mm/memory.c        | 6 +++++-
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index cb3de0c73d03..44a2a9c0a92f 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -609,7 +609,11 @@ enum {
> >  /*
> >   * Flags which should result in page tables being copied on fork. These are
> >   * flags which indicate that the VMA maps page tables which cannot be
> > - * reconsistuted upon page fault, so necessitate page table copying upon
> > + * reconsistuted upon page fault, so necessitate page table copying upon fork.
> > + *
> > + * Note that these flags should be compared with the DESTINATION VMA not the
> > + * source, as VM_UFFD_WP may not be propagated to destination, while all other
> > + * flags will be.
> >   *
> >   * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
> >   *                           reasonably reconstructed on page fault.
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 4b0790c8fa48..2839000cd26f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1465,7 +1465,11 @@ copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
> >  static bool
> >  vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
> >  {
> > -	if (src_vma->vm_flags & VM_COPY_ON_FORK)
> > +	/*
> > +	 * We check against dst_vma as while sane VMA flags will have been
>
> s/sane/most/?
> I understand you're annoyed but perhaps we should leave this out of the code
> comments themselves :)

No, sane. It's highly surprising that this is a thing that could impact page
table copying in my view, the fact you (+ others) tagged the original patch
suggests to me others also find this surprising, especially given how deeply
hidden the code that does it is.

So 'sane' is the clearest way of saying it.

Also, comments about how I may or may not feel are not really appropriate here,
let's keep the review technical please.

>
> > +	 * copied, VM_UFFD_WP may be set only on dst_vma.
> > +	 */
> > +	if (dst_vma->vm_flags & VM_COPY_ON_FORK)
> >  		return true;
> >  	/*
> >  	 * The presence of an anon_vma indicates an anonymous VMA has page
> > --
> > 2.52.0
>
> --
> Pedro

Cheers, Lorenzo

