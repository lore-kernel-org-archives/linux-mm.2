Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3EFCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4A88E009B; Fri, 24 Oct 2025 10:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4D88E0042; Fri, 24 Oct 2025 10:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845218E009B; Fri, 24 Oct 2025 10:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD4D8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:09:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AD71BE163
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:09:19 +0000 (UTC)
X-FDA: 84033190038.07.0023D5E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B14D11C0003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:09:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qajm96q0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cGEQWYQv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761314956; a=rsa-sha256;
	cv=pass;
	b=aQS40a5DUfnPeocXJ1Kh0YEGCCVmldCjaCKa2IndmPisvMvWYUlxdNAdfiBHglv4m5Is+n
	mB7diJK4dUjewFVkKQ6pv0ADXHAiGntfp5vHB+uSsYh/P6e2tS0+J6A01uXAo4ZqA2/dUk
	jqy4rDyERBJkto5cvv8Z7wpz5mmU96s=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qajm96q0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cGEQWYQv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761314956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSNKubGPMIx4d0oyw+DzEs/BWZbN0tylmnDhp3feL4k=;
	b=jrjRtuwV/3J6iINvGHvD4le1Y36amw8AlBEaQv+coHoud3Q9GMHtop7nVdA2ZBpi/yUQR4
	AcGGcul/qms6HC0flvNGy1aizbXIX+CvnPRJPBnC8VX8F4WYEqsZ0MKbxeEyHdD8qZ9Jxd
	Iq2AW+5V1eZ/gfMCDfV8RwP2Ood8VsU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OE66Pg015157;
	Fri, 24 Oct 2025 14:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hSNKubGPMIx4d0oyw+
	DzEs/BWZbN0tylmnDhp3feL4k=; b=Qajm96q0qIVsMtH7Cm6OxRfM9nj4RtKole
	0tJCmVDVKsgSttfsasSvjL5b3JD9G8VBRWkdU0wMfrGqQVwHCt2DhEqSzELmCl1z
	6ip1sZinBqzyHORtWa0sKhcg0z3KrKCJAY90+IZmx9sDRH1Q9EbRwymyFozbe+El
	C8ChV57wfFqKa4WX8xnQ//vPYNaak8zB7gL1AhxpExb8M1Wt93mBl2VNmqSSPrjZ
	HhijiOGtaDsyAr/8MBYSTjjCc8txwUqoTKKzdBZE6oucbHyXGnXt7rSATbzRiuLR
	Qthn8z0HS2GXokQS1BER7AeneUAbQOJEQk/0z0L6g7pMNDZrfOoA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ykah2jj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:09:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OC4gxm030454;
	Fri, 24 Oct 2025 14:09:04 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010023.outbound.protection.outlook.com [40.93.198.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bh0bh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:09:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KR0HjzJiJKYjrzCUFjXlizoJUe4ct6+HGCuls8JP/oGumPFbgIfebLe5ykqLQFFB8f4QjQ67DqFY1wsgEPOs/f10sUeOQN+NYbtbfKA1az3Ge23ir2fzc+uArvg5cUuQszR/0wcv45Z1TONSTO9JqfaS9HDA4bHWrEaxEd/F2sIKNl01PCtZ+PN1tV9nmlCgCYGBjK9CM3obF9200Zw9eym+ChXjGFt7LbRKGzGGa7QItanzPBtUU5t4z3XOxay5B8c9+IQw/hR5YDNcLZ7xg5uK5iK0VRHU5xFO6HB2VFNPQZqCquAmqmFhqlGfrtBI4MMLgIptu7UWfhuRqyqgcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSNKubGPMIx4d0oyw+DzEs/BWZbN0tylmnDhp3feL4k=;
 b=orZLAxJJBqBCphs8pGPZVZhPgwGbDK1MF2fr22UdjAKbUy2gx68syvRdrdraa0Rm5aZGXws8PzHtHhGXukaRFf3EFjXSSYfBOGlpTdJ1jrabJGnWU9Vyhoeq4PSCfjSaTJsSusEaEEucwzMFgvGatN9EJJuIH60RTYrXzhAcZ4y0uWJoVOv981u4r05s6rcWP43VJ5lURVvK6TGkkoFts0BkFjBA6BxdbcaJc/Ua4h5IDYs7h/WM7fhTiDX55bXJo30TwPsSYnAKxXpH8hfS9zLL6TqO0z5TtSIx7s2ge+/q5KrqR0/YNwoy5lBqjWSfXi+miHHQJcPkQe8xoVFxEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSNKubGPMIx4d0oyw+DzEs/BWZbN0tylmnDhp3feL4k=;
 b=cGEQWYQvcJXvlUL9AC2Q/EhzjNu2v2zDVW/SucZ4yAsfx0ScXBGZO/N8z3m11PDmTqMWyL1fuDx0TBCrNoaZbToffesSyQQrunwyhxFRpqSEzjMSeDtnogadndBbWJ3SdkoMTmEeA4JWZAM33flzlz+/HYh2+ejigH9VXTea2HY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7216.namprd10.prod.outlook.com (2603:10b6:208:3f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 14:08:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 14:08:53 +0000
Date: Fri, 24 Oct 2025 15:08:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 1/4] mm/huge_memory: avoid reinvoking folio_test_anon()
Message-ID: <6ebbad0a-ccae-4234-a6ed-f7c6efba36d5@lucifer.local>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021212142.25766-2-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO4P123CA0622.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca1af26-c383-4360-44b3-08de1306dd50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SZ1q1wzO8du+CrgtjC6dSpCe8r5LTcSlaAozHoGoHxBV2lWAWQVnkKEUzl5j?=
 =?us-ascii?Q?ZpDoywjixUqa8+MEIJ5p+KOcINWCGonmYpJtqcGOh5duZqDiAJMeEmRioNNq?=
 =?us-ascii?Q?nWlgmOK/7MSGY7RbLWDCKUKK/TY3XlAYf8vSz7ezr7oE2CMy28xajmw07R6x?=
 =?us-ascii?Q?+7eU7Ecyu708r7+bNSt61AW3RMTqnyBE/B03/XD8xqU6x4010zKWyZMcvDNt?=
 =?us-ascii?Q?Q0aBPvBcKCbbzWSfyiiw+U6IOiuqkRdJYFhIiZ4o2xC6nfByCf1lLuIajgVv?=
 =?us-ascii?Q?ETVd2hKJIsQCr56pVQa0gDPx+VMbzC5TJiB4dOx5cybxU/h0c583D5YxGr/W?=
 =?us-ascii?Q?Qo/+AqG3zLlPbm7q7Mghfe4U5ngfMFOrowHDo5i/GETetKvBF92fzqEzR2TR?=
 =?us-ascii?Q?XZdxAKcf/eUk7w7+oWOPWMgnR9Hpbxj2QcqdVSLculNjE3GDZXQvtVpSBPyG?=
 =?us-ascii?Q?8XE06Co+mCkfpVUe+/sOYnh5KVC3tLeWhHZRR/Ab+i1IgrDXl6mRQ9Fl5bZt?=
 =?us-ascii?Q?2b9c5xd7rjgimwHV9/Rww0a3w5Y9Jq5Afv0qPMtHdThXKkTWDnlUdXqKozw/?=
 =?us-ascii?Q?r8w+W/otfMuC1i2Yc+9uRsy0jBKTLnAo5xPbuBKrs5uBELh5F//7n6yjQSdy?=
 =?us-ascii?Q?+rp+kGlXSNyPvk6bGtO9b16asJRkadzB9ToxmC/7lDooGqN+ZJcEu6zqkbf5?=
 =?us-ascii?Q?S4hXaS0trrqU5neYgWm1wHUSLGak9Y+UHn134Zsf018CP/y+BwHcLyHjL0RD?=
 =?us-ascii?Q?SyOdDWkaSnUP0Fz4yzgeTuIvETTLgEoBVZZXJr+nTRcSnWO9uaLHHS7V3h8C?=
 =?us-ascii?Q?DwxFllYdx3ZbyuJUqaafrq00Or6VP+bifg/Z9sWLNoxTCqMi+JKmY0BuGJVI?=
 =?us-ascii?Q?17162RTZ4+itL6v4NiXBl/t7nbpyi/8FNgf4IcTwqsNFm0RHLMPA0ILA8YYW?=
 =?us-ascii?Q?Bh5QI53newac94JxAFZsi3vTa16OQN+rUjR8YKZLP7xEPvHJaezQ/dzobVln?=
 =?us-ascii?Q?sbm92TTzWHkZTiRZSnWvesFwle71Fzbn6C0e5osWu2JDBtL/8oQVQYuOrYrH?=
 =?us-ascii?Q?TmmEv2/5LvCnhBwwCHkexU56bmm1P77JKAnbDfWgo6ioi9LR6FgTdZeoU50y?=
 =?us-ascii?Q?602wh58tKyXWOoGq7DyrfTcpta4PLda2tY7POsQ3L9qZBCAIuXmxYnR3OeiB?=
 =?us-ascii?Q?k+tRvRQirlhXAI0Zc6j9QFgmt8Be65gU3lgGqIP3mSnEXLBpRCt2MdaQDwBH?=
 =?us-ascii?Q?UIyDMRzLnyAL6KuQZVHlYQx0OaYZi2doniQPSJkSG8o7OO5w76E3h3bCUFlz?=
 =?us-ascii?Q?iJJPn2rLJC0TrfwPgu/LyJfBHcRqbMH9N6uMcfQPbKGpdtuaSA6mArx55d1U?=
 =?us-ascii?Q?Zyoer1rIX6Hr/82dUyXPyplTlDX8T6oyHaQGzEZzN8u3aAvt9pyXxrkwr4er?=
 =?us-ascii?Q?sU3Cw1oybLAvECVI4VYFubUL33pDTahOJ//XXP0YhpjDvnfkqX6+eA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dQaqyC0gwh3Qx2TG6y7x9hVM5zsyPsjQNhVBh2/wpuLHZ+9bF3+fsPhdd2Hf?=
 =?us-ascii?Q?84pFHBBXSJK2D/2l4encNjqcFVEY206BRhNlSZzWn/6KACNGifOiyFopZQr3?=
 =?us-ascii?Q?HZf87WZLFABQZBb/SH269hOnyBniTN5219cFkDB2BzNMT0jHL3Y1EX5KuRIt?=
 =?us-ascii?Q?FsWMy7lclpSFTdUWLQ64vHhLrAAWZTq3DNsxmJqnkLVnzBw9Y3WFV4h/slth?=
 =?us-ascii?Q?kILbQClDnK/gp36uxMoFfeElJonhvT6+mbc4ljCsBcrTnq5HyOltyUOmaxKe?=
 =?us-ascii?Q?L7RqaK+UdTtAzlrksJHWd4I2OrR1Vf9o7A3bDw29h8hnDgXrpUb+SGqhJbGs?=
 =?us-ascii?Q?T5wdWO5EVwMOFMvm5MC3IDYUbwp6iSsciaprQe3O2GV750g2H7RdL1XbEZEq?=
 =?us-ascii?Q?qlh419W85l03dmQ0dq7czkqPU3Q0dtC6t06Y2YGVk3Yw8mcQaULDFlS9oOA8?=
 =?us-ascii?Q?lD5LvQaFqdcHLuiOozT45ZXaBuQ5kCIyNO/iJ+xS9yXVnrIuKarUHSB6K5/M?=
 =?us-ascii?Q?eiXK8IO7cMir76XzqBM7XJa7N9c8OWLURR5HZovuPaFCrQjWB4h/Adseauw9?=
 =?us-ascii?Q?3g9joJwIOniLZJtlyXh/VjOkWddiyWWz6kfXgj14DsOamZQKMb7dXMXRWoPv?=
 =?us-ascii?Q?+IspD4sZQi18zX8h2Zc7c2Q3OMCUhJ5DiLkvM55AKiI8zFiBTrA6c47DjMT/?=
 =?us-ascii?Q?g1qnzjuv1xW0PsGD5wEzeYv0AynNmrFPMycsrEHyWcCPOL7XXw2N5j3LLy/9?=
 =?us-ascii?Q?n54FnuVHxbk4Goi5budtC9utk0dDip9ZlZ1kBZMd/VaQiodD0GqPyulCcQvF?=
 =?us-ascii?Q?+LFc1v2biEkAh2kUgn2EHUGpI7mowNSkzubElnx0Q1Le73Q6UuzZK4BUeCry?=
 =?us-ascii?Q?fSle+bsoqbHeqtkOmMR+GWRjmp7YvyPhqBMDxOiwF0z/hXYvqISduUKA00d2?=
 =?us-ascii?Q?05G/n+GeWpPhXkDxvrfsiWskJL6elpiFuEOZGxmyj20ovNy8V6m3OzysYa0c?=
 =?us-ascii?Q?KIt+hrZ6tEgorcRDg8MOAVIFynUi94qmQZVxFGGm8KD5kuuYqJYmMjcG45wI?=
 =?us-ascii?Q?okr5STK1va77lt87PK4gpezX1cU7ISeOVfwrM4+EwkKtL5zCiVbqgnGWaJg7?=
 =?us-ascii?Q?+wSSMc688cCx4bBrZZJrdbbu02tATzvj/39Q+LImlrfukG6tKjy+HOQER1xA?=
 =?us-ascii?Q?YZkQi0aKYsSbs5XtSTaC/lUIZXuhc7eZ0qxxbkZO0X3HYm54FVSbGQT45LpA?=
 =?us-ascii?Q?JNkiy0kaqsVszt4jY+N8b3CEYJE5XEFUAv5S6nUkD3x4cEpWBfN2msOrhCg0?=
 =?us-ascii?Q?iTKN+cFDvPS5YHlGQ88Pl43e/MPEAGgOu5XKnr5hWe9dDwHr1NrKmaBvy1KA?=
 =?us-ascii?Q?EbPJhnMcRMrUSvBKAmKizUKqaiY3HfJP7VINMhlYAxfSGuz4lTnFiEJFCgWf?=
 =?us-ascii?Q?oPP8kGPfmrPsTq/D1oOoEmRBRmKFbdz3vwc9ojZt5S0gLtpNpPXAai4ZMHtT?=
 =?us-ascii?Q?LRHSeEBQuFhwMBiNbEkqitPQEC7qlq+ctHQpktXqEKdUkSj0B41qWNOWdcuQ?=
 =?us-ascii?Q?05TpI+PKMhB1twAtW3Hx0lPEa1noh2m4auf95Ma72Tc7sn8YyocXWT89sjfh?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dMsvIDkzW+PyNrte3TXRVX6gUinU6SCdg4hb/ya0l/31PEu/zNFTQzdSnfG+fqkzIyE7pEs84g9tORqeOx0H+xK119tXZ9cZkcqsw6zT6fO8KeFL8AKWt7iichW40JLRdXWIl/6W0wq/ampTuRtNL1ZsNNkoavJgh/yNb73VCqjmTA83Wa0BthD4X1u4tR7gZXXsob5xkAK6a0d/CBa5DSLmj2AGkUayuFok+QemAISG9mwbnsr7J7iQailfaz7bkeZmMnhgQqg8kmFtzz32BcQkeMrXZx+e7vnMOldXpmXHn+K8ZF2JqqLC8J26vTLzWFJl55HX4u2csAqtkG1NwYYwHA9DcjlX8Uu2v7joxuqJMrE/ZX5feWwRpCdvfT72b0XNn1k4K/DTLsYpo8uR9Ta7KtpItG/3QpCfubyqX2pEc6S287+lJJqDbeMHqLlSoAB2zTpn2Bxi80HJQQDIbz/kjyj1dM+5YeCT++OHkPxorhnfAIMddnb2E/zKfLc1jiXygJNKV1AozNb+RJCB8d1QUAk4i6+Ofcd5mOOL/j7mnwvWiorCTe7jJISZFGw17ZqvqtaGjpPBnz1Xo8ffXIXXvRdU3nKRayN0oj7OrGQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca1af26-c383-4360-44b3-08de1306dd50
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 14:08:53.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dRF2NTLIxMSIBMmWuKCBRnfnUdMkLqH2OwsBotnuY3SU3ylFFXD8naXyyjMPA7D3aMvnkYOkZn//pbU8xyOq9h0S2VOb611V2EPzcFV+KAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240126
X-Proofpoint-ORIG-GUID: YKH_OmlgkZSFBFUGV2etHDlQjyKyf97Y
X-Authority-Analysis: v=2.4 cv=XJc9iAhE c=1 sm=1 tr=0 ts=68fb8881 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8
 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8 a=CWGZo2PNSThGWLUuH88A:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIzMDEwMiBTYWx0ZWRfX6IFkDjjR/Gbq
 MRVNyAPCi7vrOAtPU2h8V3NDEx9GKfsYpbo9OXhB+eHmhf3qPLNQ1yFzB2NSD+nX6XcA9F9b8QZ
 oQd7Nc69P+pOOsSyktMHEwj9OKpHgThmDyATYqQbSM0FrpDxX5u2wJNo8v3wqxDLB0LmR8tj48i
 qBWtdSpQFAWIE6VD98K6D0HqR40SqH/efsT5US/emGv6ENT0W/W+SQZ2CeN6P3Nf83NiAiwGJb6
 VSGWQH+Q6GHFkHs0tDWz2OHEVAHdT6MS8phxY2RO4gMuhrGWy/L9rymexO+AnzfNWgomU2XaOzl
 uXW2LmGs2oNRWSyMFUaJxQCuO06DJQOr82pCxetU8MyCYSr6LGKKif/fqSvSFaT6hjllAO0BTZo
 KWMoOfHbWUbrtZcpUrZDo0diKXApdGogu2YLI9fFRzW7/enyJ+E=
X-Proofpoint-GUID: YKH_OmlgkZSFBFUGV2etHDlQjyKyf97Y
X-Rspam-User: 
X-Stat-Signature: r5h4t58zckxokn7pfb4kyps3tr9cfcfq
X-Rspamd-Queue-Id: B14D11C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761314955-915264
X-HE-Meta: U2FsdGVkX1+OZwi1B9Rq/Z2VLSJgyMTz5EYDTQgr9XtbSd+ILjAWKBlwZSqgsntJcYvE421PAGgiepnvRBY6ZL9o0YEc7wJ3cAQizAmZBr7PfBiTUNq4OWZqKrh4icwi8mRjrmLCeSg+K+1Q4gBTKI0guKaF35ME6Lay6GmlI/p07MIhHVOIL4zalCJ2T8MMYAWjITfag7ta2Vz5wW1KcdNuB10f80I4YgHPIvuzAv/2txGX2uxaYnJe0xoEEdx59hAttosjz/GSZjMYJU7az0BbvF2ufuFdxCCutw15SrAy3MUpNavst5WLZ1zPxfZ/0pobkdli3tuqwJufM67L1CCQ9wS/iTVu2QwCZwDnavn4NOsuMBhTaNUcjqU4e+/OYcQ+rnCvdlCFJ9HlL57UHcQKlv0OzYxkKLs+B4AA9Zs29emyU/CGkWXp/LZyo9a2fzHiF1spQN4nU7AgbKdxBDCB/Wa14cl/urfBn6IF03TUIhGG9Iqy2l72/ul7dosKgrrUj8Me3agi1akuhTRbj3MZd9EDe364B7obUL4ZlTVINqecWT4zLoBAgIL/zdEnFCxwsVH53ogXcAWqx6u730c5GYcz2+cnOv3LYruoo9uG0nTpFGWl6udXCFkvcKau4uSi8CwVjz+8qV8rhq/huro0m6m59g3hJsXQ+D5VlNM0qDihslha58T22pUzjvqlos5WeiXD3bhSJxGPSKt+S03UsfJB8ZdKtU+piOSxlmbnA6VbYgZMPKqv/GyWsZ3z3oRbPj1VhUN/lBqKeSZNsxGyzgSnqZBTs17+n23bJHyij3ndARl8fAjA85uT8B7n7hkkCwiBezF5woYsA4Hxw1RUE6c9xscmMWprnMFEZlsOAtbNmFwMdRFbYVUwg3lcHBEpYBOB0uumHwZBZ9NQ8a3UHaw/VOESk25LqGMBIDjIELEaXjDtmVbHo1EdFlgvqy0lJPHrY+Dcqe5ythI
 GJC8PNLm
 UGnbsoDej/ZLujRQ590SSXcUGohjovQzrfz/fLZ72GFB8dT1syjq8v5lmMy2p/JYpYy5CPMpxcMfzx9r10uoyY9Q9bSaojCBpRshGnIrI7x0lVo1UEtDr0ahRPXZYCYTxJgw45RX8tZ7UYxNbkra6rV6IYFusiBaB1HLW2L6gs+H4dki7OpdenLxrlKPfNeDYxy2kkeVv+hZ2Z6TNfiaSSP2To70j2Wz+ht8hdrUwi5Kg1AClcTTPD04ITGKiMmdcOq5TeIJct9mw+uiyPJc9qaIC2Sp0apwqw+xMWqu01SyJzMcEaiAAykZp8WWJENKnsKfFAwlJk1m9iZEICyx3PmAlZP/ViBX3XM8LoiRoPQIwGMkheFGWAMxvwsWtXcXkHT3xxpCfnXgw6qobVmA1kB5dqol+gOOQc192moV+MnCdHFtzYA0goI/W9OFXN1LIiLkDpJZbqyN5d+qMfBheDT4SdgasJ4oLYfmkapFAXUCXWFB2+YLaqbA8X6snkuFHIkXcw0I9g3uI8HBrTF1B29MllkmVLS8pZX9aih1/Tqxjfrw4OnrMaBBzI5RMtdxtxuUzquhiZ7vOJQeefMxUPTQwtS7oXiKV1H620feGltQTmQMMoKgR4YKcaBOeiWueBzHQqPo4TtFLAqdOb7EfflTKaznUMH8hdOAJ7oZPLOMcy5nkt8bac0bwIjNGUH3FSRHLYbRWh8FlfdZpJBucpA8rrYR7eJqcj2lQuFPvs9iTaybT1nP7McExQArxT19TgiXVeJFH2ztiZk+SmmMQyV1qX9X2n+UPzbTf8Sa0gaqR78jsonNvilSkqno9dqjoH4QPZfCNh2ZDX1Jo5GOZcCrXydQ2pF+2dWcJk0zGVXkxqPc86K9XAz3+hZqpxYC5+H86FGC9pI2Pn2BN3YwfuxGDSM4GvBOX9PrtHR+amnV7hnY6wJ33c2Zerg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:21:39PM +0000, Wei Yang wrote:
> During the execution of __split_unmapped_folio(), the folio's anon/!anon
> attribute is invariant (not expected to change).
>
> Therefore, it is safe and more efficient to retrieve this attribute once
> at the start and reuse it throughout the function.

Thanks!

>
> Link: https://lkml.kernel.org/r/20251016004613.514-1-richard.weiyang@gmail.com
> Link: https://lkml.kernel.org/r/20251016004613.514-2-richard.weiyang@gmail.com
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: wang lian <lianux.mm@gmail.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mariano Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
>
> ---
> v3:
>   * adjust subject
>   * add const to variable is_anon
> ---
>  mm/huge_memory.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 370ecfd6a182..6d82df4a88dc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3595,6 +3595,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		struct page *split_at, struct xa_state *xas,
>  		struct address_space *mapping, bool uniform_split)
>  {
> +	const bool is_anon = folio_test_anon(folio);

Thanks for making const!

>  	int order = folio_order(folio);
>  	int start_order = uniform_split ? new_order : order - 1;
>  	bool stop_split = false;
> @@ -3602,7 +3603,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	int split_order;
>  	int ret = 0;
>
> -	if (folio_test_anon(folio))
> +	if (is_anon)
>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>
>  	folio_clear_has_hwpoisoned(folio);
> @@ -3619,7 +3620,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		struct folio *new_folio;
>
>  		/* order-1 anonymous folio is not supported */
> -		if (folio_test_anon(folio) && split_order == 1)
> +		if (is_anon && split_order == 1)
>  			continue;
>  		if (uniform_split && split_order != new_order)
>  			continue;
> @@ -3671,7 +3672,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  				if (split_order != new_order && !stop_split)
>  					continue;
>  			}
> -			if (folio_test_anon(new_folio))
> +			if (is_anon)
>  				mod_mthp_stat(folio_order(new_folio),
>  					      MTHP_STAT_NR_ANON, 1);
>  		}
> --
> 2.34.1
>
>

