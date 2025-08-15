Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EDDCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 14:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140C490024A; Fri, 15 Aug 2025 10:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11958900249; Fri, 15 Aug 2025 10:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F235990024A; Fri, 15 Aug 2025 10:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF020900249
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:42:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E21E1601AC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:42:35 +0000 (UTC)
X-FDA: 83779257870.10.866612E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE871C0015
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:42:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JIHbdBDY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="typC/I3t";
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755268952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOu1uiock3Ir6CExdagg14S8A3I6ECWNv5Kft8WXdl8=;
	b=uwnxHH3YtdAyei8WHIvobyShSzW1Hzxt8QZtFcwSWM+U66E4bXJTckwGGjqitgoYSc+RlZ
	Jjk0A6ywMiBgfatksZ3qLXXhRAufDNi853vi9UMu6vqFLZXsESOX6q+eXFLThhS3ZtWhO3
	E7CeZERqiodbbyzPrIWOEsVGwXW13Xg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JIHbdBDY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="typC/I3t";
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755268952; a=rsa-sha256;
	cv=pass;
	b=g7Dc5hC4045TPBgtXy1WZj2302W7dOi8yTa14PimNTaWjP2546UqQXwRc6atx7yr76vXhz
	e1sETSJchS+bpb1TX+BV9c2MpERBGSOVFwhT6urSttsanMjNE7fMCSb9uPjmC90/eFzt7Z
	gk3d+tBTE/Vhpe3jbfg/6dps9MR15TE=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FDN6JN029029;
	Fri, 15 Aug 2025 14:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zOu1uiock3Ir6CExda
	gg14S8A3I6ECWNv5Kft8WXdl8=; b=JIHbdBDYfxHlOyQggjGNQSxhW7RiVk2jmz
	pDqiQq9bCEprd6+oEVCxfKt4c+buSUv6OwP23Sy57Xfg/5/+9BVsHEJgQvCvJbZp
	O8wrh4DP4I5IdgQz3v0kW/jD7rBuWyb+zW5LtC21Sfk5JWSoO9vKeOKmdhiVnIn2
	PuXGhwjK8urgfKQ/ZaBETuA3c9O0wMbG8HtNlyC+ePc7ot1GUR+mH5RkBC4gI9ts
	ot7AeFQowJ284QvENEsNQREXFkahLxyGxdc/3Tm62GvVT1y9OzLLWXU9Nhn6uQgJ
	wAC7YJGA8k6nsJeW/DFqWOzqKdZbelClrIvcHn7yJvAhm9lphnRA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvx3y2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 14:42:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FELP65038826;
	Fri, 15 Aug 2025 14:42:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsmm0pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 14:42:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XM7fJQFVsyBQfJNCn7hQKkExWbaHdfpSHMCukKyMVafHcMLuWb834jT8Rbshdw+pTP30mNvuwu/P0sj9jOH3Ve4BKSWBM52VTPFSavqCT9R6HMxW/IW68i2ZvKOOFSCVDwsl14vac6bnXkvx2Br7AWlu/YkK4gTFGbjjPJ5ewvzwH9GnwNaZy1vBJ3fJFIYMi26GKkCM44ateBPbYFYw7qNzVc6+PCspJmNSu9m7ktha9eLzWPVhcxkz229TlaE8M8KT+5/m6deq6Xso7ENNZ2jDdr8BQUCQJYHl0/hzq+ZdSESj34vd/MRLKnWCySJnqbAeiWA3+0g8hAFZ7uXbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOu1uiock3Ir6CExdagg14S8A3I6ECWNv5Kft8WXdl8=;
 b=NkcXyF0abrp0XNC0L2EY7yr8sJLkTGm254AHZFW061ZrwiAxzfvmwYaP4n9udT3A/A9E7ssIqejG23D9dZJ3dUD2jjcQSew8FEkljtcv4gac0tGb8/eHMW51CV8uwycKINTtcCbgeiWy0B0yLZ8A8y16M3muxbCvBM71JN+mPMS60SqoHHhmxMxH4+gZYvjPHOeI8uIgoUU3H5K9uU3FecMFCZnzA1uKLn8vOJ7OqYZdCZ2n9WPtzDmthzwc79udP2SQL+uInSDTIJMLKEIl6VZ9Errul+pLW+AazddLkyeVnA6Omil4WBkObSkNMBmTB6NMvXJKGZzvCOag5vP4xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOu1uiock3Ir6CExdagg14S8A3I6ECWNv5Kft8WXdl8=;
 b=typC/I3tPgVr0oWGVcKCl5NpbBrvc/sUvx3Rxs+wKWQ8FZhPuEO46HKVv3JHNZuRwoKOR4wa1MzbEE4UDBTxEUGuAp4chSIlW6ka+fmX2f7MaVB9osmXlN9rlwLDXD3pOOItXj57RRX2/63LmhnTSHQCQs+pnJjC53RG9vCGcmw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6254.namprd10.prod.outlook.com (2603:10b6:8:8f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.14; Fri, 15 Aug 2025 14:41:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 14:41:53 +0000
Date: Fri, 15 Aug 2025 15:41:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji@honor.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
        rientjes@google.com, shakeel.butt@linux.dev, npache@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        peterz@infradead.org, dvhart@infradead.org, dave@stgolabs.net,
        andrealmeid@igalia.com, liam.howlett@oracle.com, liulu.liu@honor.com,
        feng.han@honor.com
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-ID: <d5013a33-c08a-44c5-a67f-9dc8fd73c969@lucifer.local>
References: <20250814135555.17493-1-zhongjinji@honor.com>
 <20250814135555.17493-3-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814135555.17493-3-zhongjinji@honor.com>
X-ClientProxiedBy: MM0P280CA0100.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6254:EE_
X-MS-Office365-Filtering-Correlation-Id: 47079c26-74a7-4c8a-06f1-08dddc09e050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x3tAyW7+XGyu3LmgPmVMWOsmVGKOuWqSBxaGZeqJmvGOqT/U2PTA9rwAfFsK?=
 =?us-ascii?Q?AJBSlBsa0k0Iv29yc1fZ/OSRAitWnJBsrAWvwwYoVeRBdnDWcoUeP2Vk83Xb?=
 =?us-ascii?Q?dcs/h3slFPfYY2slPN5AF+GrnQdYmN8clvzrgstPnU/MDOglZvzrAw5LBQNM?=
 =?us-ascii?Q?99tO7TFDjl6h81SXVEzzroUbt6ISEpU4z4vkXRWJHzbYZWoa5B5vsvCzeCW5?=
 =?us-ascii?Q?Q/oXZHvAUWVjpbLGDsqW7XB8xSyscz2THNOgLnCbKr3jjmVZBnEGMDYPnA/t?=
 =?us-ascii?Q?K/FJKNsOvmkTg29D/IUYxfYyvAfKTZBhWscjTQt9+ebi07y/dax35RaEupem?=
 =?us-ascii?Q?GZbYIFfphcbN0VfHdZufPHDQiYfybrWdVUZzliZJRTiKaGNLqT22CtJ4uwIe?=
 =?us-ascii?Q?APT5zdkNzWi4aBy0MxXqvBzmyzNO29ntaLku24MWGvOyKPrCJpxoSfGKqrga?=
 =?us-ascii?Q?T0BBmh2Ja3zsfMY3s+AR9iAR1EMfzTmHboJoONGnuS5LHMRQt/SlIstxBUph?=
 =?us-ascii?Q?2hU13NOvNyPfKrP7AFfiXaj+xtrzKY4eZarj0c8Js9HDA5Qv5CLETtUbwqi1?=
 =?us-ascii?Q?sbIc+cZqliRNMRVMMjVpLGmobXeWid/ukBWfneEG3xhHYVAkeJpXH35pvMR4?=
 =?us-ascii?Q?8xck8XshjA/0OlL3P/C3emaus5nIhoycmlMTToQOfhM2ZyCp7e1BSb/IToos?=
 =?us-ascii?Q?YcesDnhg5+RmM5N4zcfrt+inFP+8vNWXU5KxjVfeI4EzbZSqhZ2T8nQwif8G?=
 =?us-ascii?Q?2cRgqoKu0wGocDwV3Jwl98oUTdPNWMpnu8TLf2HNYPMcpoJNVnEu8AgYcpax?=
 =?us-ascii?Q?A32m9XlEg/zA4v0RmfPTFRmCzVsd1tpc2iHRk/OdMllcIQ8/hJLzQcM+IAce?=
 =?us-ascii?Q?I+dl/NtvV+wuDyJwFlxbiwUVGfa7TWmGigs7ppzndviPlbGZ6Kspm0ywWnWs?=
 =?us-ascii?Q?JSLJfMEv8Cp1cY9VU6g4RmY9dcRbGj433SzEjM7cccIvC+QLGhUxprkXHCib?=
 =?us-ascii?Q?M08JwJi2MZD5g4XvY/mrc61/550Y4Lvhlc7qQAcYuFVd4Hg+BwystK7S3+FJ?=
 =?us-ascii?Q?3HjL+GCbCjWyON4W9gZhQHjrugWRBX7YXZSEfRjF9QwUOdANaDakFRZAbGFL?=
 =?us-ascii?Q?29UQv++VJBp9Wkk8TsY5St5NGSozm3aR+ItMslR8oxKnaN0KPMJi9Q35Nbup?=
 =?us-ascii?Q?WYgAd4n15f1nZ/VG5UEEjskWeIgCOAZN2ekr5X9n/B2+aEXo7FsW61FBycvv?=
 =?us-ascii?Q?09PFfDT5HYiRtOA5sPit4sryfYfTFAFbkplLz6PkPaHKZ6qiibzUoW+ukXkq?=
 =?us-ascii?Q?ZEo0T8zI+Et86p2w17G6q5iVNMKs8wkI/j7d0J3ufjP2HZrBeLuU+OVeGkHO?=
 =?us-ascii?Q?1uMY/uh93PkpCnX8vdn07LecencnSooFdgqfpBo/RFxmfYDL1Ax17wSK2WrT?=
 =?us-ascii?Q?q/MFhcRJBrI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MNAuIEd/ZRPQ4u8Ayd7o8oGmncGXdbdvK/YdeMpY8evYlvRZCwUNPuqiVBt9?=
 =?us-ascii?Q?UAZ+yLfDq9ttFwtpKfOBiEcnEAGrl/jNg07fyuJuFLVzMD9vnWMqfYWUuWmN?=
 =?us-ascii?Q?qAgLX7O1YwfJm5hVEXN/NoL5BGVdvhMqtlpK9wGcxvD9rdgiHRVxNVxvMT0j?=
 =?us-ascii?Q?MaH7mVQMiYQRs0Uy6+WwVLQnf30d4ZayTFaaqdCk9C91HRaLJ591pKQDIwR9?=
 =?us-ascii?Q?Nz51wMEyYuYGENyDLrga+qzacPnZiTu5TKcAlQCRCBIhJY69Fx2JKJzS/nl8?=
 =?us-ascii?Q?ByJ2pnu4MqUQbYnElHv0Df0jR8Lr4TNSPbGxOMewnKZCLKpgl9PxVJpLO1rR?=
 =?us-ascii?Q?Q6S/T+lzUuJmzkvcf5R8XeGsV+7vyT95+/cuv2hFoZE/TXi2cWVw5992EALq?=
 =?us-ascii?Q?/TfywMZYhATvgO12uSPbBdloj2l3f65iV35UshiX3qkYUP0EQlLifPtaWRhV?=
 =?us-ascii?Q?Xel1DDpcHJOvgIh1THp5nmm7vtRfp7+JhD9l0kimYSD1tJXLany//Hw8hUqZ?=
 =?us-ascii?Q?tFdfi7+alq5Ek0gSw3QeUOWYLgR4oePY4MSHV3dep7bCo86DQudsHweHvXYi?=
 =?us-ascii?Q?SbLjW4LbQGCOlfROqQvoKvaJY0suXXenIpk0638z3TJ4JOQHv50a4w5c91v4?=
 =?us-ascii?Q?5P7Z/jXGuBURTuhICJMwHm2Kpn6y5A5mZkU3zxGrgW4j5xoMzKwhSmnoOaLm?=
 =?us-ascii?Q?YnCJhj35ARFF86ajL13vDtbzE/ou+0QRnjqLOCX6X4QnpQb8dkl6t13W+f0L?=
 =?us-ascii?Q?PXEo+y8ptCNdONtK+xBo5896vUPloEQR6j8uerU1ckRrt9vvHYdKw/H3KIcw?=
 =?us-ascii?Q?KDMnpHwKfelm6jbbvkYWuVCpr/MCFvHxuF0RSv++tRNwk2F4qMVmQKwACC8G?=
 =?us-ascii?Q?CmBuRl+gVNEkXvN5YDTDAkoAQCT4eSxYiJbI2qfONmxNXng22iTQypxwSSyy?=
 =?us-ascii?Q?NM7/agizjITR/QbZ0kUM6BjhuhmW0aqxQCv3YdiupFBNRqqDWWT+1jK1AYbr?=
 =?us-ascii?Q?W9wT3oWiV/C82Gm3OEgzXVz1ZDKcCvQQSqXCgNcr8mE7w8dKepRXvjopBAk0?=
 =?us-ascii?Q?hNwsuC2mwE6aqgWxyi11YduzbAVvzu3OlXLDGkj8VveMccCLR1mapLo2CeWQ?=
 =?us-ascii?Q?DFOLgvqptqoGJ7JcEaJogjtAYbl6S9qHwd2dvaPmT5Gpi2WOqsNSAGiLpl1n?=
 =?us-ascii?Q?JTzKumO7WGGhL3owq2YdMXTRpWybUo46S40a/saAC9nRbs14anW/BU8BPk5M?=
 =?us-ascii?Q?h0wYeG4EDCqSjbxFqvjpw+5ntDOQqTeUIpT94qq+XLNi247+qazc/SOXwEaB?=
 =?us-ascii?Q?+yXaj4kXzbydVPNLMBvnfPPKdRJJKpVEt4cY6EARDoOBtrMTJ5OYZbpNsFKP?=
 =?us-ascii?Q?yYUOPChzVfmlT93fgU4pBf+M05O4EFey0ESDubW0f92D4saXMrzJt9d+rr17?=
 =?us-ascii?Q?QkrYpm2ch6NDTA+lVklGAI/sC6s7a5Mh40lgYszdLSyuh1jvVL3+VmNiNZo0?=
 =?us-ascii?Q?jGiE58iHCTakV12OQLIda6Z6oAoENmJTzhU0lSbJT8yTAtaLj/LhecHRMQkg?=
 =?us-ascii?Q?dWowkm/ATI2Q/Zsnaz2C7ApyUXxwH1pDhUxZTziKFHh3vGpbATymo/vv07pZ?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	//Kr8VJQVKWmMgBTv3yPSXqgyOgymv2ZIQfd0P8txSOG2xl0lXc8jeHJ/lSUDTZCzsHuhHQu28eYuRgqs4ci0/yEG5an1aqErpZ+abS0O/O03FeieZMkWEM0MySsUySeAku9F2vlI3Yjim9CqI5hEhdG0RnOy5hDDS+xJomI87LMk/tnSnc9jQv5ULEmVzp8xDPFhsk+v/Iv4/5kYlk3FFpHrzYXXsT7iYwWpIOCHkIY/H8tPi55JSryZM1UOW7zwAyJTRZMClIQrdmk68s+DZwAjx255+V2Uhy/yUPZXYTdKKa/4rnnSYXZ4gEHn7I1ZQV19N7ZMoRsJNcKd8XkGELUNuMQtjFo62pKjnl7h+IcRevwwOYeKyEpOchkn1T88zEp4CMmiEGIiO+4NBsHO3Ja1WZOw6eegh64RciCW8OzEoWOtJ9YkCxaVwE0GEk/UtNkv0xdGUdADmhnmfT1e3QrsLVdWVB5X6Wf6ULPNspHdx/nkY6qAgutY/UKzW/mAVpPEgD6t3qYA88DczOmggwimQSQzdq/is0vf0lZ3iPiZtLWd/tir2W1cy+xrcrGUF/18lSRa/hGUzdyJn3XA/xK/CiM1mUT7bBkKGBBW80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47079c26-74a7-4c8a-06f1-08dddc09e050
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 14:41:53.4354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a0UfyUE5jvFxpX3qvqNtNwcjqqUb/N5vvwErqF20WgtWZA5qddS1E5NKCe54Y6cxufCY5PdQStjdyzrVZmHk477nFCyivDaGgBQSX593cU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6254
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150121
X-Proofpoint-GUID: aBsULtsmQlrEjACU2_xMCpDwwipz55WE
X-Proofpoint-ORIG-GUID: aBsULtsmQlrEjACU2_xMCpDwwipz55WE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDEyMiBTYWx0ZWRfXzDBe6KXP7+mh
 rTE0o1JaxmD1rMGgXd5Q2nWq4Vao8Cv7BdDMYaHgBdAAUeZdtS0WbPs0Ke3gVwio333nOwT552K
 +yF1MLJ0zWxnVppFGQVABjNk/1dyuPlc457kZWr6jKdWMdzn5tMlAYCJKVCjcVUERpmwk9yFUK7
 iDdc1xYeC8t+TY5CcMP5Gg+j6CfBVIh830N4Zle+Wt9tEODjWWuGg6Bo7RJsGq/x5EsOqvsUySf
 0cm+jH2YKfj4QiTF5EbNH3OkcfXuytBybbwdDsRPieZXcgVAb8cqNeIrb/e862Ffas3+w6Onlb5
 zl5yNqNaV7VcjbuLHyP9BgH2lote0df35dQUZrfK7gSNKi6MX4QK3LBRRKJCKXtK3hHWQxO6P7c
 eFd5TdsIz/DUaJxQCy4BhDzOxwimrBoFbs3kmWGU3bOVahM5MtQUOnQTOMpa9I/x+3dNjkNp
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=689f4740 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=CvlTB2HrAAAA:8 a=mnqe6SsrCgYQQeGaO7gA:9 a=CjuIK1q_8ugA:10
 a=67QrwF-mucXG56UA-v15:22 cc=ntf awl=host:12070
X-Stat-Signature: p4hncrhufc4xeak57wnkipgtnx8mo97f
X-Rspam-User: 
X-Rspamd-Queue-Id: DE871C0015
X-Rspamd-Server: rspam05
X-HE-Tag: 1755268951-18862
X-HE-Meta: U2FsdGVkX1+vRaa8cnJrIMI4i7JsrX1Yi8tlQr+Y7qP44QxjsDVwfKhX0Rebx96wzWvNNZFdN4DO55BLtjg+yCIt5roUfZDNe9ZynbtTdI/akDXPPgWuBe9oM6vSox6iBYTeJaWI4TeHBX2SgSVFPlZsI40GorN+JWRAyaoQ3pRAsFEAI6tA646SjntUY0mf73CsXJpso7A5v9ke6X1z7yI4AjJpTFQOyvHvD0in97cvJIcyfUHcy30uFJ4qJClzWAj19ftf7YTHb1++etusXzb5vD1SGmh7uAo/9TCPWlsRfSnmg1wFy6seISvzMEWTG4npVt6YAPoQ85XXeHLMVFlE6b5v+fCIMVj6hMjTdxrgWvwYxofn9ZZnhgUenP5YvZCghvNL1Gcdd2d73t5/SSbQhFhAhBLTte8iz8vJVDr8x5rnwSoOEGcLWmemXyFDoTx55Uw3D8eAab3mqiUpsrU40w2euYXd4NR0Oo9rFNb+o/EMgXfQKsVi6pEpD4hSl6Mp77mXcjEahTXjAIFbTX2ecUjeyMYZuEnYh0B0HXqrGOYgkpocS9A0RWBjQtBV4KV4ypXSOuxgFgAc9z66N4eILGTKzdimCr2NbC0fzd1tIDEoK8EkHXeRozAoeRnydes3Ma6lJ/Yw252dwaBucd9+UvgmXp4s21GoW/GEyTcnyJgQ22hV8zJVj51Vlss8SYli3EU1H1Z9PL9hNGJ2hYQqovFcjr1GfnV+zE7xxwAQAPH36TRNSUYr6wrzSFPcNjhsl8WI0XFG33Af4sfOvW0ZrSYPowyjZljptGQsTC4VBJZyJOTtbK8UjdFnbKuv+JtmVlb9D06mVZmTrqrnWCaKtG1Pq6o9J3fwNOZ3XGGWe6feGyFOMDcS13EZJMkyW/38YCums6+X6DiB7t0a5p8Ofoq5Hn7nzGYoq67K6MArftGyExveRYCZPZ/ohvuTw8tn5VazKi5T6g1Orch
 qcXZfOfI
 kdhHSEq2xG6JKM9kbdvWStMwieCSnDV0yW4bVtnm393awUPHnd65ZpDZD49kl0UMOpsxeMQU8ZQ8kkW+V9eAnAdFyHk7R/bY0f2VqnjGkHWjcCfYuE/iM/wGlMegQYOO0nktQqrPsNdg55PHle4fxKswqmjScSPKEjz+9RpYbSNPirQDSKCaj9hnXUW5b+RCR2QKKDnIf4zzRWLsI8VqgmwOi7ka+Xl7CKcPAG/B32b+7WF9OI/XnaKDAyk3wlLPVB3OUPl2MCvdEiD1TajZDBTRd6qD0VZgHqbr5Mh15Il+s03vbR+022Euc+Ob3HB77zVQ88ygggcs0+yZWzhmLnX+V1ltLcl2D/hAeeOk8TrQK3vtprfcd6+HV6nV37C21ku1WHZo5xrGZJMqHq8wCuQcP5Oef5G/1kEdlZ5+CYAd6CixhUVonz9r5T3EPaqo7KvtfuM0habUNHRTx+5kTI9XrRVCzPBo7Jb3ITdxMhX6F4IQg3XxDD83S2WIao2aIg4+2bk8A5lClN0faGToY8uoFwYMi6oIY3JRW+2PODES5yLkuo++JV2tGUcII2jCmQxY2CNmt/0iPPjKMZNmEO8fcwuAWVKNAi+C9+/hFBXPjnCRCtZiNeATvj6mcUFM4ak+WJvXg/suXkuwTcMNNzPFwlHYdkIRLevKfcMfN4xrimkUILpIKcf4wR0yi/DIJTscQeJ/8wXc8MVQnZk1F67DNGT96P5JVTL5OBwJ1chUQRSmh0M5SeJ3JGvADbhfZGobQOZkB5K/mdYVnnc60lOTXAQBCrYStEz16/5nvOJCvWa3R3zx6dfsIfEuUNGU/MQUs9B8bpbv5VJ9TBFEQxgyc4sR4wMIo4QQq2zpanBffw8BqqRKTL+ev1YVbz8xGNEE4W7NIdK32Au8zg/xnQ/t10g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 09:55:54PM +0800, zhongjinji@honor.com wrote:
> From: zhongjinji <zhongjinji@honor.com>
>
> The OOM reaper can quickly reap a process's memory when the system encounters
> OOM, helping the system recover. Without the OOM reaper, if a process frozen
> by cgroup v1 is OOM killed, the victims' memory cannot be freed, and the
> system stays in a poor state. Even if the process is not frozen by cgroup v1,
> reaping victims' memory is still meaningful, because having one more process
> working speeds up memory release.
>
> When processes holding robust futexes are OOM killed but waiters on those
> futexes remain alive, the robust futexes might be reaped before
> futex_cleanup() runs. It would cause the waiters to block indefinitely.
> To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1].
> The OOM reaper now rarely runs since many killed processes exit within 2
> seconds.

God, I really don't love that that got merged. So arbitrary. Are futexes really
this broken?

>
> Because robust futex users are few, it is unreasonable to delay OOM reap for
> all victims. For processes that do not hold robust futexes, the OOM reaper
> should not be delayed and for processes holding robust futexes, the OOM
> reaper must still be delayed to prevent the waiters to block indefinitely [1].

I really hate that we do this :/

>
> Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]
>
> Signed-off-by: zhongjinji <zhongjinji@honor.com>



> ---
>  mm/oom_kill.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 13 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..7ae4001e47c1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -39,6 +39,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/freezer.h>
>  #include <linux/ftrace.h>
> +#include <linux/futex.h>
>  #include <linux/ratelimit.h>
>  #include <linux/kthread.h>
>  #include <linux/init.h>
> @@ -692,7 +693,7 @@ static void wake_oom_reaper(struct timer_list *timer)
>   * before the exit path is able to wake the futex waiters.
>   */
>  #define OOM_REAPER_DELAY (2*HZ)
> -static void queue_oom_reaper(struct task_struct *tsk)
> +static void queue_oom_reaper(struct task_struct *tsk, bool delay)
>  {
>  	/* mm is already queued? */
>  	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
> @@ -700,7 +701,7 @@ static void queue_oom_reaper(struct task_struct *tsk)
>
>  	get_task_struct(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);

Since this is predicated on the task_struct you have here, can we avoid all this
horrible threading of 'delay' and just check here?

>  	add_timer(&tsk->oom_reaper_timer);
>  }
>
> @@ -742,7 +743,7 @@ static int __init oom_init(void)
>  }
>  subsys_initcall(oom_init)
>  #else
> -static inline void queue_oom_reaper(struct task_struct *tsk)
> +static inline void queue_oom_reaper(struct task_struct *tsk, bool delay)
>  {
>  }
>  #endif /* CONFIG_MMU */
> @@ -843,6 +844,16 @@ bool oom_killer_disable(signed long timeout)
>  	return true;
>  }
>
> +/*
> + * If the owner thread of robust futexes is killed by OOM, the robust futexes might be freed
> + * by the OOM reaper before futex_cleanup() runs, which could cause the waiters to
> + * block indefinitely. So when the task hold robust futexes, delay oom reaper.
> + */
> +static inline bool should_delay_oom_reap(struct task_struct *task)
> +{
> +	return process_has_robust_futex(task);
> +}
> +
>  static inline bool __task_will_free_mem(struct task_struct *task)
>  {
>  	struct signal_struct *sig = task->signal;
> @@ -865,17 +876,19 @@ static inline bool __task_will_free_mem(struct task_struct *task)
>  }
>
>  /*
> - * Checks whether the given task is dying or exiting and likely to
> - * release its address space. This means that all threads and processes
> + * Determine whether the given task should be reaped based on
> + * whether it is dying or exiting and likely to release its
> + * address space. This means that all threads and processes
>   * sharing the same mm have to be killed or exiting.
>   * Caller has to make sure that task->mm is stable (hold task_lock or
>   * it operates on the current).
>   */
> -static bool task_will_free_mem(struct task_struct *task)
> +static bool should_reap_task(struct task_struct *task, bool *delay_reap)
>  {
>  	struct mm_struct *mm = task->mm;
>  	struct task_struct *p;
>  	bool ret = true;
> +	bool delay;
>
>  	/*
>  	 * Skip tasks without mm because it might have passed its exit_mm and
> @@ -888,6 +901,8 @@ static bool task_will_free_mem(struct task_struct *task)
>  	if (!__task_will_free_mem(task))
>  		return false;
>
> +	delay = should_delay_oom_reap(task);
> +
>  	/*
>  	 * This task has already been drained by the oom reaper so there are
>  	 * only small chances it will free some more
> @@ -912,8 +927,11 @@ static bool task_will_free_mem(struct task_struct *task)
>  		ret = __task_will_free_mem(p);
>  		if (!ret)
>  			break;
> +		if (!delay)
> +			delay = should_delay_oom_reap(p);
>  	}
>  	rcu_read_unlock();
> +	*delay_reap = delay;
>
>  	return ret;
>  }
> @@ -923,6 +941,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	struct task_struct *p;
>  	struct mm_struct *mm;
>  	bool can_oom_reap = true;
> +	bool delay_reap;
>
>  	p = find_lock_task_mm(victim);
>  	if (!p) {
> @@ -959,6 +978,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  		from_kuid(&init_user_ns, task_uid(victim)),
>  		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
>  	task_unlock(victim);
> +	delay_reap = should_delay_oom_reap(victim);
>

Yeah I really think we can just simplify by testing this at the point where we
decide whether or not to do the horrible 2s thing.

Let's not try to 'generalise' this just yet.

>  	/*
>  	 * Kill all user processes sharing victim->mm in other thread groups, if
> @@ -990,11 +1010,13 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  		if (unlikely(p->flags & PF_KTHREAD))
>  			continue;
>  		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
> +		if (!delay_reap)
> +			delay_reap = should_delay_oom_reap(p);
>  	}
>  	rcu_read_unlock();
>
>  	if (can_oom_reap)
> -		queue_oom_reaper(victim);
> +		queue_oom_reaper(victim, delay_reap);
>
>  	mmdrop(mm);
>  	put_task_struct(victim);
> @@ -1020,6 +1042,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
>  	struct mem_cgroup *oom_group;
>  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
>  					      DEFAULT_RATELIMIT_BURST);
> +	bool delay_reap = false;
>
>  	/*
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
> @@ -1027,9 +1050,9 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
>  	 * so it can die quickly
>  	 */
>  	task_lock(victim);
> -	if (task_will_free_mem(victim)) {
> +	if (should_reap_task(victim, &delay_reap)) {
>  		mark_oom_victim(victim);
> -		queue_oom_reaper(victim);
> +		queue_oom_reaper(victim, delay_reap);
>  		task_unlock(victim);
>  		put_task_struct(victim);
>  		return;
> @@ -1112,6 +1135,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
>  bool out_of_memory(struct oom_control *oc)
>  {
>  	unsigned long freed = 0;
> +	bool delay_reap = false;
>
>  	if (oom_killer_disabled)
>  		return false;
> @@ -1128,9 +1152,9 @@ bool out_of_memory(struct oom_control *oc)
>  	 * select it.  The goal is to allow it to allocate so that it may
>  	 * quickly exit and free its memory.
>  	 */
> -	if (task_will_free_mem(current)) {
> +	if (should_reap_task(current, &delay_reap)) {
>  		mark_oom_victim(current);
> -		queue_oom_reaper(current);
> +		queue_oom_reaper(current, delay_reap);
>  		return true;
>  	}
>
> @@ -1209,6 +1233,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	struct task_struct *p;
>  	unsigned int f_flags;
>  	bool reap = false;
> +	bool delay_reap = false;
>  	long ret = 0;
>
>  	if (flags)
> @@ -1231,7 +1256,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	mm = p->mm;
>  	mmgrab(mm);
>
> -	if (task_will_free_mem(p))
> +	if (should_reap_task(p, &delay_reap))

You can figure out whether you dealyed or not from the task again right? No need
to thread this.

I don't think it's a big deal to check twice, we are in the OOM code path which
is not (or should not be... :) a hot path so we're good.

>  		reap = true;
>  	else {
>  		/* Error only if the work has not been done already */
> @@ -1240,7 +1265,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	}
>  	task_unlock(p);
>
> -	if (!reap)
> +	if (!reap || delay_reap)
>  		goto drop_mm;
>
>  	if (mmap_read_lock_killable(mm)) {
> --
> 2.17.1
>
>

