Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC5DCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556E08E00C2; Fri, 24 Oct 2025 11:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5074F8E0042; Fri, 24 Oct 2025 11:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9508E00C2; Fri, 24 Oct 2025 11:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24C808E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:50:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0E3D49812
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:50:07 +0000 (UTC)
X-FDA: 84033444054.03.0047285
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7843F40007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:50:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VQve++Ih;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qLVNjD4V;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761321004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svZXTUraohKIqS2jPE8P9Sm7eIiIxfsKrFuMoeX1KwI=;
	b=UNbWtP8wSCqiEd4OKmZt4pVKIpJ1baT84mo65LTvu3RIIKs0JB7ARk//yn0AXxs5Nc3Zvd
	t+l/gVvpnRKbgRXEkEYrDVfgUfoqeQjiO6wZZLfWvCm8cS/M6rXR78dbWx3blym2iuPYkJ
	5LUMl7Ml+t1gS0jjGhRL7Cpop6nzW3g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761321004; a=rsa-sha256;
	cv=pass;
	b=mU811/dgM22CIu1A8B9D7gsqOpNTyndmNNkVXwmkCClCElR/F9a5MnYZV8viPNpvAxV4Fq
	EGGB1XSM2g4rfvFLV2tevvpdeuL2XmOSFPK9I8RWSGK6DDdwyB4mYBYVbv0B+AG8os4ShJ
	kjB+aNdTaj9urSkOSW7wgcffH2ns9nY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VQve++Ih;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qLVNjD4V;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OEgQ34013277;
	Fri, 24 Oct 2025 15:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=svZXTUraohKIqS2jPE
	8P9Sm7eIiIxfsKrFuMoeX1KwI=; b=VQve++IhUvJ8lqE9qX5CoEFkvF7bDfoRxQ
	L61Y7eXKsCr687sA7W4W+HBOq7ftg5yawFrbLV1h8bp1SbsHL3AlbTo7rcGDCLDT
	qWgbk+o5WaXRENfVB0QxZ6S/E0wREuTHtpTg3hp8hGPxy/JfE4qXvsCO15zrUC/m
	FKoln4qjfxG/7KGkhL9a+cm7KzkoqRKAs20qLYkCWotU2GGsxG/bbnheQz9gM6vZ
	y96/G7yhyyg+oTPO+nf+FtoX4o0/ciHnDO80iZU3Ck6k5HeNlEleIB0hsRh1Ww9E
	8R/fd3Z6qkkXwbT1H9iJX7FTEAUwjcz7ldIsugSVFobxSHZgXcFg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3kw0yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 15:44:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OELl3o004475;
	Fri, 24 Oct 2025 15:44:48 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bg264q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 15:44:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQKUDhJln/LNnTwdKmX4WgxpUeOrCZsOL2p7vYPdyFeaLWltLHOs0FUFOEZ793eV90zGPdNCy68hdqX0vx3cy8GEG9Ipo4e/k9r98a9BhfZS+hAMXhOAoInT5+x/ZyUfGgpJE8chx84u2Bg55GNMowHf+UaeiRVUci1GQysW4MSnaXewsAt1xa1GfhTPz8k8FG245vKbDa2/3B3jmx9Q9G+93IEXSVhD4t5ku5c+oxe6mrIJjTbKoWD2JP3WK5Kp/hTmsMM+wNMvo47hkfJ7QpqHzQWmO4oI/UEuBb1rTFp3NY0oRNzkhikvEmrIJxW4BTAV9QfxiEN3SwDKHqI8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svZXTUraohKIqS2jPE8P9Sm7eIiIxfsKrFuMoeX1KwI=;
 b=SODtmQgqOU4ysjV46mYLvg0DM3hBlDafLW4O0CKgI8zhaS4iLhC8R4J6hOos9Mn6Yvfw+As6BdFlnFQsMVy00//+5C6PwD+gUdusmfD/AIl63zYYJ2QaqMdkp/diXloMLNf/ATSGtdbf/TENVQBRB0SRpdoTO0KDonapmmp/2Ic9V94tMGJdoTBQUNrtk31V3MWug+LJkP4RY2OeUenjnzxtAXazJUh227cTojhMu9AAjs8ICV8kf14+6lbJA/4I6xP1cS7EhF/7oFuVTPr9/XiQUjw6g1CE69CPthJju4LjHx37NXBo69fWmpyTsMWag6woKM6bCL2FFFEheLSRUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svZXTUraohKIqS2jPE8P9Sm7eIiIxfsKrFuMoeX1KwI=;
 b=qLVNjD4VM19nj2ySWPEWdGxxniO70ZtA34+QtK3jHwDDVZ9S0WvwG5HfQ+ugMqiAzxDlKfOC80ZZbm3R3S3pPz1JcX8OvFzR3nZbIgbNIjARUTr9EZXa3fx70v66Cfx4jZkQngI5iL1VGuoE44aCKNdMQKPmHgGcbK2uPETfeWE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5922.namprd10.prod.outlook.com (2603:10b6:208:3d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 15:44:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:44:45 +0000
Date: Fri, 24 Oct 2025 16:44:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
        kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
        nao.horiguchi@gmail.com, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
Message-ID: <298f1a0c-a265-4b0c-a5a0-7f916878dcc7@lucifer.local>
References: <20251023030521.473097-1-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
X-ClientProxiedBy: LO4P123CA0543.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d06d5c3-b313-4490-059e-08de1314416b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dl2wA+33E9h1PhfbLeaMZYkJTsMCh+f37O058FHW/tPBazuGmWs4cgr9j7oh?=
 =?us-ascii?Q?4Eb1QMrujmcKHKkFiZ/lwqTEjBK0ChrqaqIgd9mY9+s/YfKJEG2fz4nqNmuX?=
 =?us-ascii?Q?cNu6NCjKc46MpqjgH9jh5QnH1t9seIdMLImQambIB5RvKkXsybks5SslVH8d?=
 =?us-ascii?Q?UnJTRF48vcUGTuE8qAL5D7m49uCVFlsOclgsS1KBca48mhX8bMp7XjSJCVj9?=
 =?us-ascii?Q?eQZZPmjH+yriAyzocvl6KKZC97LmXyDutmy8OYEA8M5KnOGxFKO7QpKe56+c?=
 =?us-ascii?Q?pTxMFsHMGWaCJMiyu3dy+DTlh+PT5hOFaumulANXCHkcnGAgBlgCEPggfe1Z?=
 =?us-ascii?Q?auvQ3DwpE/VQRkQxKPSjotSogLqhLIUum7T/kGibDF15TycLvb0VMxqSI5fO?=
 =?us-ascii?Q?ilinHncrhgE1EXR8vGOOiKdWOT1nzVSTfLt66DjLDJphg8CAYmX+4aaW1WMj?=
 =?us-ascii?Q?mpYSjcQYqpmrwmuB09PU7e6T4DUzVFr8huj3OiQhQseI0uVy9t/GoyfmIDQT?=
 =?us-ascii?Q?1tlprK1/2EbUgEkjCtI2xwN/+d/QIKwYYC6J/NerUyUkVllbQEX2SoZCdWR8?=
 =?us-ascii?Q?8G9pPhe7iTVv49OLlyFyfZAWYJUficWAoP2M5ArZ6U//pmVNej+2P2UDXZLA?=
 =?us-ascii?Q?MauBcmYOierxfWX21YQZdCySSQ4LWRrfo2Po1S1XLHK3VtPifiw8dHNDNie5?=
 =?us-ascii?Q?mJHKs35Z1UjfgGAOLThRIEK78TY3KCArBBYUEPRP4bllXler4kR+UHSV/kze?=
 =?us-ascii?Q?/kNqeeyRWLgR3UlOA0r2c5c4Vq54zn2kGfZidheM+wKx754hnO8gSP/QbIgt?=
 =?us-ascii?Q?nRMmkIB+fDllK3ilNvBJTZGsl13LQ0uJ0osmoUCx9p68+mjIPi8xVPa1QAqL?=
 =?us-ascii?Q?F8gjPbmvxNlFqoodbZrplyr/ZI7ghv4FAvsnBPQOD5QES3avPM3lJYdUC1UE?=
 =?us-ascii?Q?qTYZparYndlz75K8WOJJBa4+reURhjULrP3G/a0O/TJysn2SoyuqU8E4BvpD?=
 =?us-ascii?Q?RZ9MqDx+EkpYSreZQMdX433LOXC71ZpcV7FZpB+k8kEJXy3eSJINGxWqpsoZ?=
 =?us-ascii?Q?mtzNU0mRkyZmZhoZdSEWlFL3tDhHYA9K90GDK9n+DpkOXoZzBqSL297EVT4K?=
 =?us-ascii?Q?CxJo1fe24svrVA3CBPB6sE9yvPgX/cwGRl2xmWVvF4DssQD+e8Lpt7NUlpuw?=
 =?us-ascii?Q?NNV3ZvY0xAZXlbEKbccBDHEiYnu6NEfHd5P2JLbBh9lywFSvhHje9IFHWjyq?=
 =?us-ascii?Q?CiamOpsGzXuL03+xKUpAL7ykyYSB09yksmKjyNdEbafBOZIanAh0lvdfxmTM?=
 =?us-ascii?Q?57QCK516mcDz5okgpkxRlZ8uMKmylLQuIBz/iBtHUqfMQhBG78LeD7TXg/Gh?=
 =?us-ascii?Q?3lvvlK52yzFQj6H1Ic13CpisrtWkHmKPKVt/Z0vUs8ZLIhqQMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a0z+QKsRlqAPGhHLtDNucU4ex3wxc6XUeBDXvuxwabQ6FIbWO3oim6bfdq7y?=
 =?us-ascii?Q?dEJW/buHVEctA/v5no64/CjfBBgxP3N4CebUevwi5lLKhq0PeTxwz5hcuevL?=
 =?us-ascii?Q?VN2WASk7oVXP5/xA81FLCfziy/LX85kNauB4cp9H0EQCCaR4MDkpGbyd5vax?=
 =?us-ascii?Q?dlKWXhSF7mfFUTjb39o1UiJNZrCDJPpVwzBdTtllp8UrmDxQXKyhuVS5NOg1?=
 =?us-ascii?Q?ChR7m/mOeCzLWdbrp4vJ42jzCHrjJzP8/3Zw24IhjW44XEvfyotVVvDBnISw?=
 =?us-ascii?Q?NfY5Qf4JHYUAEAoVBqVx9417AnBlYa1MIQ7bcpuiD4WNTqcAlXgNxbuPF+f4?=
 =?us-ascii?Q?UF/EdzR7ZXSj0sc+VXv7YAjcYAxsKk9YX5mgkAhLW474V+3aZqHsTQVyiC6J?=
 =?us-ascii?Q?XzCXRA4PjoN2Clbo9uUlXW7f10ngv6nRhbHrGQ0y4vBwYQxhgemM0JX1D1hw?=
 =?us-ascii?Q?Piqnm+HwsWiYOLxx7ld46y3DKNPRQo1inBQX67zUAiZntLiZhvlIQ8rxLzF+?=
 =?us-ascii?Q?ls50J2DYkTSJOfjhCiMEK3+t5qSJRn0IcfDnv4tYLiQ+R5qvBtHDZZEsGvHf?=
 =?us-ascii?Q?cUtYLXCZ56jEGhWk0069EtvjPA3jj8SCMpphruZuJ8+RABxwbs7fKz7IRXOL?=
 =?us-ascii?Q?yNX+1UxPU9NUZ7NYiD50VPdG+g6PL46mNrGg7AybOV2u6FKjm414yidzXZME?=
 =?us-ascii?Q?mF3xdXd6y89DS819WyPzoG8ZvYQrqivA2647TTg8He61tVSpd6uAQEfFITrK?=
 =?us-ascii?Q?Rd7JLPqycjAr7dX6YaKSJKHNshCuVXaDK4OapGHWplMCH4bpdY+RjJ5R00BK?=
 =?us-ascii?Q?1FXVpy9dz3Adv7/pgrwHjiW8Pbkt3hsFum9vZjR5t2QjksCsQWEbfdWhm4le?=
 =?us-ascii?Q?pVVILxaex7bswLgDur7djuSrVpcKxit18y39e418//ZN1kpQOEqbJopSHMOY?=
 =?us-ascii?Q?JFVDTXjQ3GkNsYIC699+kDHLDAaWuFnvKGThHidT/kTSJ4Q46pOh0Nn/wwHv?=
 =?us-ascii?Q?3o0cf/jRUyxt6NnP8QsVIpwfk2p1Upf8HeFlcoLrjT9HWzaIuv8zcYKeGfMF?=
 =?us-ascii?Q?WA2vrPXwMOAW44jenpIrdwdKmy3CpDsWX6wqApraUFVMk1ool/eg4B52K0dJ?=
 =?us-ascii?Q?fXaRvy9tq63XPLLqUe2FqpEvnFHTxCBGqXAgSXTlQLw5q28/OUgg7I8PXfHO?=
 =?us-ascii?Q?TG1A9APm9Svn23hAIkF0kNPX3dxUmt09GugB5psQoFxbthzMZjxAnw6UELJg?=
 =?us-ascii?Q?mTg7mCCq2E2MZqygkzsSnj9YFZCg97SPW5/eGwdxe4y2IpJ6HuMBZR2x+hdX?=
 =?us-ascii?Q?6J4weX5VBFNLQTBfL33iWVNVDlHC9pm6AT3eC9aAdlthhUYM4cS8BcUNnNlw?=
 =?us-ascii?Q?wBRiCbL/5D5i7jZwKAVkmIzQcRZr5Hxi0bLOUHsh4QzdOjH1f9h2QilHI1JA?=
 =?us-ascii?Q?nVzzFwxLPHaA2Lxc8AGVlDaEuBfMGVr2rq6jMRuqN/KHW5OeTWQwHLNE2XiP?=
 =?us-ascii?Q?Ma2bTfevRdqZHjpPNrM8HYu2Bo8GKWE1f8ew1tSNLrBKDKCeQpzJ2fVT/zd2?=
 =?us-ascii?Q?J4yPWHfDJGN6weTr62CZL0vvusRgnCTkRlYfaz0sQ30apw57TOtGmnVxWa19?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o9Ex8gu/l1ZGDe54+pzS+UeQT+T5Vakouawa7FV6OL9hgyT1Bbsl6/32W6wf5rkYVrdEl+7z/jauAk+kYvWCwVYD+Qcx+ZA/Hq7tjaVMgfWrGDv+v/VAzFdK6VIXDXWfgK/XDe6Xl6+m6eO2hdRuKFcW1qZWtqAOIqcsywC+VoQ87hkP8fpNFBmvSUhiyxz8NeuUyUe9sDmHYo7qkV3Bp0LmmnAUCqnI/fE4hyGPQ/eTZamli2gw/LgVrSpSHxwCRuusjwysmAEQ4NJy/iz8cQ6EuuZkz6D6ozVyZ7Yo6U66X/fHDXfkuVXk+IZX/e/7KIwLIPvpYQJo+l+rBtYvL/bdzUpMHsd54qEqwdbPMr+2LQ4/cqnaYINsr3rCPsDr4friV5mkfqjmuEqmQ0DlmsLiSGrzmLAD4U4Ixy9MSrnU8CpCY8wwpp18r0yyvh3GqhM3ObXI20NRFkmlGEcTiZLbkF6mk9w7Dtb2LH6gyLcrE8HugMMqtFgoTtPiKzIJUwHb13kk+/7g4M7RhVmqzogbkIWpQb1DGj+HO3ksLzFKxHaqHLctZhHF7Vde7V4djIzqHnw6dtajXDx6yahnA9aLhHN28TovjTv5w0jP8gs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d06d5c3-b313-4490-059e-08de1314416b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 15:44:45.2670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJXNzEmgQdYvPAfsitkcpNsw8+kmiT9AFCKTlXjlEBPY3AknMLueAhB9VnaY701bmD3fkDFhj9G5vu3GKqniNL5O+zOsZHz1gar04xZtZY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5922
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240141
X-Authority-Analysis: v=2.4 cv=acVsXBot c=1 sm=1 tr=0 ts=68fb9ef1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8
 a=7oBX0SA7I5ApB963Ps4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: rAf70swvDu_QNNVadm0D_37eO-5OT4Z6
X-Proofpoint-GUID: rAf70swvDu_QNNVadm0D_37eO-5OT4Z6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX1uAG7oHVs+mE
 4AnpGSlu72v5F+b3iCM3tz2q/5vIVeeLrpIpeBmuBbjobzHFRsjtd9bkUrz9H+hpePUNB4pxwgK
 wCUJfHLsPpDdVs0QqGA9RmyomZm8tOY8TlYL/e7n7rPkt/yBvY5olqgYSmh76AXtJO/cjvIqNTX
 BGzl5VmlX6DndGX8SW8HQuJK782nWS8y7Ybl/+dLGJmRAlJYCO5sfARZKDpCH8pDUyB/FL72kqs
 lsRHitXJtRl1ZloN+taqXivh/w5jFCk/XHqec+T3m3Yy5WrgkJv76VNvx4Q84+g4fpONoC+hrWY
 Hwuv3bbMBjJlNBNE02gKeXTM9B1cbifhQisAbVwizJ3LeiG+x8a4PLMf9GqhR9jhrsaJuaToody
 gU1uodT88y0OBxQttFv1UfRbwGy51g==
X-Rspamd-Server: rspam01
X-Stat-Signature: 198ow5e3mxwkz46xxriap13y315e7hpq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7843F40007
X-HE-Tag: 1761321004-662066
X-HE-Meta: U2FsdGVkX1+jubQT4i29NDxiCbVgRG1kTP+4auxVPUIpqtys9IllRfvvQQPQ+S1jc3CZWT2mYU0FfiE/M976zKp7nJSUokr1Vc3G+ddx8a+PzqxTO56T4GTIQn2ZkPGnYTd4OcG+NmH27CEayiD+K7E88s9vLolsZ6jMSNoBTUhU/TkOvR1hl7H5opfNtuBk9E5zMypEwhYGem0LeCfmk/IfTbsFrWcVjRkB2TZCXoLbnHBGiCTqBcz+QF1sqkk7TDwkltscmLaXsPVjEuCVCNN7bvCommuetRK2tcdLP0grjxoTY0CYsuIScH/ZgwJ2Kcz9dwvLyKt7VTfxuF8Y7Y6PGYU42iZzYSDAbboShJCTv9q7JJTJVUzMJ7PE0ZWlzFq/rUYdYn3L/QTEFJTFk2ZSelwCbBN+n4rZHERD1KT3tmFmhsTpEfnq/CkOP2F3wRtVnz9YLV8JOOlcgjtPwc6Hb/cR417CMkkjavtg9PMK6BN2ziCTxcqJ/OshtgRAQ38R/66cIZn7lk4Evb+nGtgl12vE2C/HfsY6HIU8diyMB69Zz9tU3jCM1tNB/IZzunrFoEHedD6nL8oaLe5VS2B6rhbQmI48RqJlR8/ANTlPZNk8f7fusgZkvAUY5f/SK2hPNEJGtMQrjmKUD3fNlNyxS5bne2+oCBATFAy8na/0sDdu0wr5nIs9TF6h3+3EO60uUACPGyQACxPAY50c628+kdgz5F8KClQSFWt9lw2rKqYVuD2K+Cu21/6E9LIBwBSwBqiGTuLehVLG+tCOfK2SwmQsxLwzg6vUiV0jZYMSj1IfR2/uBa4Cn366CFBJv5LR4ZImT0/+1+CsTIT5hWKOoxJs1XXNVXbyfo2t10r+Dh91qNmD9Dru6VApPeCmA8KsXY1eRQc5ol7Lq8O9z9kRko7oHHvk4aSpALvSHsS7hLAkbb5NysQmkY942MzeeGBAbulRPBg0dGZEbV9
 v2AMbS95
 ha4x/ft1xGM6TUYx6L+yGBuSk550SWf7IxF67xrXjk7BlpkRYji4DJOdb+ygMO5Iut+Gio0SqtN4CFiDp+bRIxC/W5JmkM7hwy9SBZ2esg9LU2U1LQ5IKuIMZ0XhDkVdx8NNlf8eBe1giEOCgdkTHkl3FUC1OZ6W0lNDlOSzV8QZCS5j8QX6D5q7K87/6dxP1FOEd4gc+mWlRU5YPgihLcarGNV9+pSnMcXhQ3LHsy09qvJn8YPyzvENpFiVg1ocOkSn7m3iE+1mUOdsoTw0Sue6Xbat/lkyapJIoZzM57HI/6VLG/2v8n6WWK+pB8uNT7ER0uabKPFp7Dfxiofk/tFuts89AnYYqdrqJkci3Fmw53Cp2oJpIgaVRR8N8yGiwsewswMj9kmhCxEpcQrzkK3FVQ04+n3mLelwhXyzNZLIuBrtGwDgmPGZm1f45J0GIRFq96KS5rzqcsa+RNTkYasoF2YuqveQMxnRk8AmURqyAdXAcelqxFOT0aYjpmh9LpINOt63gQ3Ea0tZixw+izH5pnbD/h3CmctQP+qdn9OdULLe4ekcHCtMHpkDwPJ8j554v147TEi3R7fjvvPWop296oNxc2F5hEz2lsLNctsA1uqLQ+m0psaT1YjTmM+GPtTeDimXZrKX5wQ7D3RMIAL27C94HtTw4rCCt2ZdcPBjy9S7GsNGUq8l/5IOpRyTPdj4J35yIdER3MQmmSEZ2g35L8s/FtrTW9LPfSv9QKPtac/qxuiLuxthn+FBsHiCqMvVBGfNoMNXY+StqsNCdO/4MHQ6sKjDoKSYGF/p7JtEzNItYgWiYCsBfofdNiOS1zGx9Y57biXw6uy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 11:05:21PM -0400, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
>
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
>
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>    truncate_inode_partial_folio().
>
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag. This will lead to MCE errors.
>
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>

This seems reasonable to me and is a good spot (thanks!), so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> From V3[1]:
>
> 1. Separated from the original series;
> 2. Added Fixes tag and cc'd stable;
> 3. Simplified page_range_has_hwpoisoned();
> 4. Renamed check_poisoned_pages to handle_hwpoison, made it const, and
>    shorten the statement;
> 5. Removed poisoned_new_folio variable and checked the condition
>    directly.
>
> [1] https://lore.kernel.org/all/20251022033531.389351-2-ziy@nvidia.com/
>
>  mm/huge_memory.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fc65ec3393d2..5215bb6aecfc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3455,6 +3455,14 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>  					caller_pins;
>  }
>
> +static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
> +{
> +	for (; nr_pages; page++, nr_pages--)
> +		if (PageHWPoison(page))
> +			return true;
> +	return false;
> +}
> +
>  /*
>   * It splits @folio into @new_order folios and copies the @folio metadata to
>   * all the resulting folios.
> @@ -3462,17 +3470,24 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
>  static void __split_folio_to_order(struct folio *folio, int old_order,
>  		int new_order)
>  {
> +	/* Scan poisoned pages when split a poisoned folio to large folios */
> +	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;

OK was going to mention has_hwpoisoned is FOLIO_SECOND_PAGE but looks like you
already deal with that :)

>  	long new_nr_pages = 1 << new_order;
>  	long nr_pages = 1 << old_order;
>  	long i;
>
> +	folio_clear_has_hwpoisoned(folio);

OK so we start by clearing the HW poisoned flag for the folio as a whole, which
amounts to &folio->page[1] (which must be a tail page of course as new_order
tested above).

No other pages in the range should have this flag set as is a folio thing only.

But this, in practice, sets the has_hwpoisoned flag for the first split folio...

> +
> +	/* Check first new_nr_pages since the loop below skips them */
> +	if (handle_hwpoison &&
> +	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
> +		folio_set_has_hwpoisoned(folio);
>  	/*
>  	 * Skip the first new_nr_pages, since the new folio from them have all
>  	 * the flags from the original folio.
>  	 */
>  	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
>  		struct page *new_head = &folio->page + i;
> -

NIT: Why are we removing this newline?

>  		/*
>  		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
>  		 * Don't pass it around before clear_compound_head().
> @@ -3514,6 +3529,10 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  				 (1L << PG_dirty) |
>  				 LRU_GEN_MASK | LRU_REFS_MASK));
>
> +		if (handle_hwpoison &&
> +		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> +			folio_set_has_hwpoisoned(new_folio);
> +

...We then, for each folio which will be split, we check again and propagate to
each based on pages in range.

>  		new_folio->mapping = folio->mapping;
>  		new_folio->index = folio->index + i;
>
> @@ -3600,8 +3619,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	int start_order = uniform_split ? new_order : old_order - 1;
>  	int split_order;
>
> -	folio_clear_has_hwpoisoned(folio);
> -
>  	/*
>  	 * split to new_order one order at a time. For uniform split,
>  	 * folio is split to new_order directly.
> --
> 2.51.0
>

