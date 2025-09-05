Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF940CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0FC8E0017; Fri,  5 Sep 2025 07:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278178E0006; Fri,  5 Sep 2025 07:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118FD8E0017; Fri,  5 Sep 2025 07:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1BD38E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:03:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90D6216079C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:03:23 +0000 (UTC)
X-FDA: 83854910286.19.AD0F7DE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5D55A003C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:02:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k90uniRj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QvP0KXHP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757070168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fnop1JKMw8+UwQrwQhAEfFhxpacZBkT3Ig591z9Z3pw=;
	b=Uuy3nFjeqsBnH0WyrejlVkWhll5U3A2G+KJFJfQrNIXO8C+L1ihZrHyZ2cldSOi4ImhcaD
	UarEtDA7yko72X0EgXfmKub3skQXO4cBzPUvZQ6FuGc/+l4Cq1X+bN64e8ZkYIAfI68xP1
	NkgvBEvcpNWdxN1WK6rGXvsdDLD26bc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757070168; a=rsa-sha256;
	cv=pass;
	b=K7gurdVGxuyUybx3Bveopa01+3YoHQAgQNILgLMh1Z9BAHYew6zCzc1LX4+7g0Q1nAW27Y
	TxHXJu/MjU1Czwcmv3FtaQT9xvc76ew7N9LgpJNDuJchwD5Dw9U9JVAI1XLkMWnLYbHAd7
	J3tYRtYGStkCcFbpEpYyEZxf+sbnqxw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k90uniRj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QvP0KXHP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585Ati7m006116;
	Fri, 5 Sep 2025 11:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Fnop1JKMw8+UwQrwQh
	AEfFhxpacZBkT3Ig591z9Z3pw=; b=k90uniRjuHBMVS+/RDUEn99qG72h54oLkw
	leoyhqoAH08D+63+ClFF8X+VduHa+vyQlnq3Ahlh9BaTcKnUDv1MD0xAea9TfHG5
	sm2sx7E2XOg9T2GgaMQjIvCznOIYJPwVtuvVpxCwy6LA7AY8L4UH/78HxPmbar7m
	FaAN5PuVlK+15/W84Xw1nggY1Z4m6rk//NRQOjsg6tUybFyqIF71EnGKQZ4AmTwV
	e1P6TfCdUI5H6Rvg9M+u/p1BZpBhMeRrBOU1ArlzhWloehqbui+TGb46Juk8Iila
	0kLhZWRGPD4XX/NUMewuIXXQZnR8+v+aOlfZyxS8tHgQEiDfqoRg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yxa580vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 11:02:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5859JaXR039519;
	Fri, 5 Sep 2025 11:02:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrjucyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 11:02:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNf3+qAtxRhFjQGuUrIOXseonEB/Cj6XAlRzOZIUw+ATR5AWXajZlFyCZIDfbtgdNvQiJX2pGvAgC7tWHMTcgOO18bt7/glO9MsrQE8VBK1Zl2AoIfGlUl9DRN7hSV7H5Uy3G4c7xLQhXvUrupPuYfW9jmPIYZJCLuskt0ZSGDhsryjE4SJAu4LIO9TcQOaPteNgtOpQATPY6wD2i4G91MWHO6Dwg4CI9+azuc1d02iqhlsTSQV1N5LzZvVUSiYw5EN5yol5r217rih+NqyOFEbDcaBehwPkhjoABwllhch3OaSdn/WIHby3lNzdiLNmj+4XldLab0luwVW5nafuqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fnop1JKMw8+UwQrwQhAEfFhxpacZBkT3Ig591z9Z3pw=;
 b=R3uo/oKc0fKFY0EX1WjFRZcRrM9hyrN/jIx0L3dZ5syB2mtJJ4DYTVkSn+w/n/hLLtzRCXkPbH8BF0QFf+DjvVrd5AIk3ZxjDY4MxIQhmUXHADzE2JZyItoowG33NOR7B2z3cNn7ok/x0QRjub+0Y9hTRopdePJddh8VtmvHzH5d+Z3nDowXaXIAY+1yyMhgr1jHuoqw41R95o48mIPSQ/b1wT0j5DNQAB/ubd2VoZmdBgJhr5W9HMEEPMRUwznc4+j+VPCF/oQQ6+r1W06ukheZ2W6BRnKS0EOVyPtAVb5AMrMWLBPdB62ztAr3l6ye7sQG6wust07BAOGTyTi72g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fnop1JKMw8+UwQrwQhAEfFhxpacZBkT3Ig591z9Z3pw=;
 b=QvP0KXHPA3LCRwpBC+3m230pXumRuX0iLjseX8qZdCbCl5l1tX3S+HXitHOoC7qNqSQ9BDM0j7C/PRlhcyjp4VAH8wQ320AXc90LQOdib5bQUHDpEdGx30Wq7fWzZFjwAPla0peGMXCR+itZlOfmnd92z+YnhO+AMR6tZxYbfn0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5195.namprd10.prod.outlook.com (2603:10b6:610:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 11:02:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 11:02:40 +0000
Date: Fri, 5 Sep 2025 12:02:37 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Michal Hocko <mhocko@suse.com>
Cc: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Usama Arif <usamaarif642@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <2634aa8d-40f6-4f8a-8a0a-fd8d6917b2f9@lucifer.local>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLqqlkTpEM1SkvaE@tiehlicka>
 <0b22e23d-f00b-47da-8e62-c8b0ced05e4e@lucifer.local>
 <aLrB2D-DjK8pFLHa@tiehlicka>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLrB2D-DjK8pFLHa@tiehlicka>
X-ClientProxiedBy: LO2P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5195:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d1d7a0d-911e-45e6-ea37-08ddec6bbb6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fAUYY/W3V6ZdN63tYVci1ZPXRRkWtxdY3NnS8+cY6hl/ohe1Ub3NUg1c0BcO?=
 =?us-ascii?Q?ETl2IFUBAutM9ctkJFRPtDTLtmz4V5yH7k7O7s0pXNIh5i1MBIjIK9A+i+84?=
 =?us-ascii?Q?2pixuTYDaxbbWjwK9dO84QwP+jqcuufWyJebneJBeZxmaYGvG7J5xJp+qJBU?=
 =?us-ascii?Q?ASUYppEz2tWXt1+nEWMR3E1xA9UJl1spFs8xNWYevMvWpOfgXpXOmbVFpoq2?=
 =?us-ascii?Q?4ggf/Z0LQKFyjZD3BmZ55xuipTqfLOzYJ19h4COuBB4MYApcUiz1YZL3b8/u?=
 =?us-ascii?Q?RdL1jLXQfmxxzuJNTe1efcrmiJZ8h5OJ8jUDsUzxM1T2hagXm7CPBM5Xw75e?=
 =?us-ascii?Q?LF/5Fj1TjBVXFDwh+8OIV571VkD001mG89gUC1mP9mw7o6hgi+KwAn0egBkX?=
 =?us-ascii?Q?iYkGVfvvdftaupPX0I8/Wm6U3M+7XXkUogbQIAwXO37agl+1n7ev1xLUuDRc?=
 =?us-ascii?Q?TBrOu37BXTAfhTH7PCOVsiIgS42nKcxTxJw0V1T2BLmrfAmA4WAwUTkuxsj8?=
 =?us-ascii?Q?Uuq5YezwexvbNFJpnAIK1RcrAb3YJ7bLrkBS0cuAk4r96/vB8kfLIQQuJwf+?=
 =?us-ascii?Q?XtMKDzeUVbIaHCEAjyCLnZgsc0AGW0L+uPoEgSHMVLvZf3E7JZYnSrBACeIX?=
 =?us-ascii?Q?Vj/yDbgWE2If2dv9eGyhZCQXRykOXI69kScdjtXTnDVqD8sVFjVRkBW4SXm7?=
 =?us-ascii?Q?9fhqY99DhDrAn0UjOwb7N2oS/BAVI+KLcr4eEUUaky0jyi55MiAm3j5ZrZCs?=
 =?us-ascii?Q?mMTq01ckzaeGEKLLE37PqWtURu0xAiPOi5mPYUQmFRuPhLG9lQIeiQsUmYcJ?=
 =?us-ascii?Q?ixqkwf0MQ8bLKe3RG+yFLtjUo+pA58O+xmJzSIhH/jEEDuR2y4b5OVfeEowd?=
 =?us-ascii?Q?FPm1hKyRZfrvD7Jltu+ZyuhPqtEpQYY4iHn3Spbq+DQJB+1sTQNeWy4A75zD?=
 =?us-ascii?Q?hnY6dXk8C8dm+vkiNSF6onBDuIoWbqofoAP4VjZsGYl9ekqPNEF936vn/z5Z?=
 =?us-ascii?Q?QfE/bK3/AUt9AcRsHObWTkXAwBMvkADtiF17MKzGlSV9Mmqmajqitkk/FBYc?=
 =?us-ascii?Q?f8ZvBCmSeP/jIhu4coaHY9H2Qu4MZJZMXm+HMYf36ZhBB4arSkF784UNWeKA?=
 =?us-ascii?Q?MO9vJGNJOj3EQdL80UH36i7gStEuX2sX9yGw/CJuQhAJVTEa/LxcCI+L37O0?=
 =?us-ascii?Q?cpQpgq8nPSkMFPsMYVhUAclrcHlkDfQ/P11ptuBNXCXFfNTY2XXOTgKET+fX?=
 =?us-ascii?Q?VbAgm2MsJrglCrfi3/u5fZvXNRPhQ+9gNWjj0AGfvAzMs1Lqec8+B0OxonW7?=
 =?us-ascii?Q?y/EXezvNKKZc2Rvip7VC9qQ0TObmP/ki4FOzpa+Kxt8h1jjkqOH2z+q4HfHF?=
 =?us-ascii?Q?CEoRq0zoIeDnCnPESfqYkPVYPp1jEJnVr1TnwXcTVtIGAwQxirH9smEm5m+o?=
 =?us-ascii?Q?rakB6Pl54uM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LeoRDUEPOkyxueAH4YnfEG1VJIwf8JQzQlNEawdrgfeCCIl8zvS49YguS7Jy?=
 =?us-ascii?Q?aBB9Lf8RGsA8bc/yJe9ixaYNVV8uGLxEY2q2KVvXwV2X+pnETzLPUaNbKULB?=
 =?us-ascii?Q?bYNcguh4mB7oh7rEV/uQnP13sLofaQXmsSLClmQJ+7j3o9xGIG+eEcQ7iPNR?=
 =?us-ascii?Q?R+9Xd7Ha1VLmuD0C5zimU+GzgG3CNAUJuQcN1yMIuc6MEZNdVbqiauu4A01k?=
 =?us-ascii?Q?R6mcuDKiKOYDptUcBJ3GEaAzjJKn4v/6ujcZvNJ0uDph67l4LI2AnSEM9kIl?=
 =?us-ascii?Q?yOSE/dC2r/26apD+6WPDfku9ADiSzLJ5KiNn2rkqk6ejOLiua/B8GIlou6L0?=
 =?us-ascii?Q?HG3voI++Oi/es2FJKjLou8WuKoSSYIlpNHBY43km0m4VskCpOoAPnMos6zfv?=
 =?us-ascii?Q?5luNgjoSdbmbfE6CLl7mPtNYdMzwbqFEOCduBm0PkGmSAQtEpjwYDf2gcPIq?=
 =?us-ascii?Q?yzcO3yGT9O8lmThYXvnFOMDFMP3yf8wcpyg4Unelxyw4B5d1tUVaIaFr3FFt?=
 =?us-ascii?Q?hwoVdbqFZMA5liFd1PqswDf0/NGTd0yjYNgWdanhw/bPiqfZF3hs7HBQxi0s?=
 =?us-ascii?Q?/MuURpvI89g7ZfrwsQxYUCC0iCh8KBv+74a1HysUMhhucwMgSfe5ddlDxGFC?=
 =?us-ascii?Q?FOyFDwmnCNFOUqqz80f10i2WPBB7zy0VE885Czjyyrm286u3YrjzC/pEgqCs?=
 =?us-ascii?Q?IIxBu5b5XTAdbURBiEEBNjMnK3mIWjQ+zvRxhXRf3fipqVed2VnWtsr3UNEf?=
 =?us-ascii?Q?q24o3wdPRCpw7qr7gKKAZWZrTaWbrp2d+MjXVEsyh37kprUow31m6AemJbVN?=
 =?us-ascii?Q?LRyZuRZCQvVuZYk714mVcmMGH4Qb7DPvEl8jK37XN9GqRuh8ZJ0/S8M/aeR1?=
 =?us-ascii?Q?GTxIgMg19JD6zorFRCHHgSmXb6NH/iJOUFoa+CGODvrrkIX/iWcr0gZMOIF5?=
 =?us-ascii?Q?pJQkqNRyZAJbXat97BZasVyxktlLjzbkMjw85OLnXhbNuy8YbRouAac/Kipg?=
 =?us-ascii?Q?3mvtsBZDENQuqsLpibFsJyvawQ8arVuyqIZbAcRNlLAny/mQ5d1j/IacaUf4?=
 =?us-ascii?Q?i6DqxQCZwuZXGIvPtnKxcVO2rsc9TFS2fU70A08HGUYivgAcoy7FxMmUxFCn?=
 =?us-ascii?Q?LYSWIO5uORXLkIdGLVpc/0vr8LZRlGQqLzH8IKa36GcTBjt+HZdVwZHAcixK?=
 =?us-ascii?Q?biOTi8x4R33RtC35kZYuWFH9ASeOoPZHwNuH6P8rm6VkvH5VH8RZo0iPHYpK?=
 =?us-ascii?Q?YVJpXvHmOwf5A3rZ2P4Gue/QER13X9Zroqkzm3gV0yzU6DbBO87d0sQGZ+M6?=
 =?us-ascii?Q?9lFhLKjcFl/LalVo+/2ZFKrdM9flaakNbgFyDLOfuokxWC2Vd0dJyPOD/sU1?=
 =?us-ascii?Q?YXti8YPsfed8zzu85UMqKzfAgj3qYzBXV15Ozc7FZROzhe2LlgOCl307Nk2q?=
 =?us-ascii?Q?S4pQCU8WrlIArwgA48j6ggoOQH56Orj+kOObXoRuduPGSyHSFXGWqhFOj4WI?=
 =?us-ascii?Q?EoCUa1dy/ObOgjEHmRtA1L85REXv4pXorEZYpPxUWK2TSjz/EBmuA2KFCjnG?=
 =?us-ascii?Q?Q0skCGXKbV8ckUxW3aBSb/KaFijDAxhOb2bI/En/yn1r6RJAQG7mkW5TC9oT?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pbnk3ONEKnea48PMZkvuoW1ifZpceTaxto6taCm+9PdX7P/c7sya0JTgcdonKqwrBHsDu7oup3PoecpW17yVoQUjU+8ZeRWXvNYa3kXOvpjUZv1tqD4w0NKlTiQY2hlQT227voudpo6r08AU/4MsAo0pdSTIoDDURHgOqce5aYN5NqEgCnwAGd33pvqv4F+kSzYL8+6Rpw4iFfSriz8qjPJhfrub9Q+YcJkPn4RW3pIjCERvzvuH9xb/ZUjtYquDURUXPA4Bhs/XJ6isF1ind8SLMZ3rk7//lwA5A4xlZVCkK+BVP+8yLrMlZppS7ON4YvDQXYXlHB9BM/8Q2JTDcUAmAIRXRcyG4FGa5ViDJ5x16+NJDV/Hu1Lf+pTgyP/pfd1gmJs6i7TxBlTNCHAxPaZYHN0y3UDN/j4DPWgpBSg3kljRqDo/WcjIH0Hs5icoL2EjOqDA4JU0FzGWl0xbCD9yTX0FChxoBVVuMNSOiyZzB2BrLQ4YQkIO8d50PmDElvB1HCJGYHlvWhQqNSaUIXF5zwO3ImsOh2b3AkF3RIS5a5GXRlrbyZlHBr034Y9mjfBNWdFMZC9pcP3wZdOcU8InEg8hB29IMDtWWaXWOCg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1d7a0d-911e-45e6-ea37-08ddec6bbb6e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 11:02:40.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFqt7Jhw0fdnn9Pv3HRdXPGW2cpjrusbUmKq0chopNpTxOXYyaUjK7MNHK9FkGyBZwAitJZ+F2fqv711u0Awk1XQDrXg0CriaITM9Er+dmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_03,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=924 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509050107
X-Authority-Analysis: v=2.4 cv=eJgTjGp1 c=1 sm=1 tr=0 ts=68bac353 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=IbGIWmkbTIvR9GEkuE4A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDEwNCBTYWx0ZWRfXx6THwjlDjgqb
 Nag/Ee5QVNaReFv95ZjIjohDyFbfzR249KVCJasAxHzWX20nHfOovpJWgqAQoZ7KxiRSx924f7f
 s4hoO7PqTGv7hT7RDbs7mNFfnXVJ+TyTtfKMFvuQo59A8d6iJUUTlbQP021pPTKF5TyroZDe1tk
 8gEkumNu6lOm5KsdgTWkSPj5qrHWvdZyPOF0qSp47m8clWI/hW7QvZQV8UNEy+dhuSQjYXWlQy7
 VIbyyc2qKIwW85/EEFU7b33l4Qzn4O1H5xBm5emnlnk5ySLrvaue+uNd/5omw7pIog9GbwjoiIp
 jFI2cqAtFuamMezyc9Yf3AplsdAje0GamUuyBto0O0fRDFMzzOFFAZrCIs5jick1AiMl0hBS3HE
 XQ1kinfNY2sSnv2V//lKgl9s28b7ZQ==
X-Proofpoint-ORIG-GUID: 1UFbElWwBsXSEGeuTLUNK3sENbd6IM4q
X-Proofpoint-GUID: 1UFbElWwBsXSEGeuTLUNK3sENbd6IM4q
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E5D55A003C
X-Stat-Signature: awmfkm8oku6pdikysawmgkkqmgt9e5eo
X-Rspam-User: 
X-HE-Tag: 1757070167-933160
X-HE-Meta: U2FsdGVkX18nkCdJqRYRQXmNnCwwur4xn12FY2XA0ob6fnye6AWprHrBvUktXnG8xe1+yIfM1fUn2p5w44D1KvJP5SCz31Mympm8IpdwpmKasrsXy/vXiGCBntqf9Ny8v5fpnGY+wheL+Pm2A7obOlR+z4LVRf3i5mOoAKR1Gqo/h8H+GQpGjSJ6kB9Kx8Z4QzqjjnwmSQ0NPQaBEPRt532+rDSaD0sRv4XY9uwlkq5xEjOLguSclkSc0XrCofOSzCjsCN2np+ZsUDv4eDG4Cc+Vv04g4aYKSP8xp6GrxE+Zk5aHUndtUV2R18HhyUEm1JK2S4aNyQw+OzXuYXH9PZpEwHhhkeGeqkMgf7NKFmjgOZnLmJB7yOJvY76Prw+yLic6v9llBk13JTeazdYNwvhQbCZnQZw6Lg8pISGluN5ydZlqdbOWDnb0GGCxNHrAp3cK/MH6LU1PE2a4OQ2SL3yFVN0ZW3ZcHw6+/OzUxnIfahiXLghFLmfUBDMbErIv5cJFC5IvB9sEYawmOFWIlYUFcaT8Ya9++ALFTuWHQo8R/zhbyxN0yw5y1UnKeyieE+Ahb+phHapZMnGba+oPooBHIDCozxi2/3b0TFdFAvYYq3PY8Mjxfu4XJ/o1uZLxPv0XbHBlwBKUAK3WHlcLCiUJFseV8631GEYaYUR7XMIzfccrSyCryvAMu+WXdJ8lPTE1mh9A79+l/NKdFTLzovkw1PrBIy5V9pcKGaD6sxGwD8EN4gFxuWL+q/s+oHxP7NhuSYm2wRpVthq9c1or3cFt2R+k+br4mf7Dw4y5qfsU9r3dU1Eqizg4YkKUYAatbmxQCWGZ7THzl8hg6PqKuZslXscNxEWN49GjWfv1c6Jsi4QD8ooIG+QaW2HiNvm2PaLIYUFRXpeonu0qtbHgefdGrIzjnIdn/N7bYQ5+5QPtBtEjHvjqdWY1j8Nql43H5/ByATp1DXrfl9vAsqO
 gHcdvYEi
 P/xvCMAJB1WZSWME+YBOLQ4Qqhrb8WcU6pGKoYjgnloPA09f0DeJaWvujruN+yXXpOX7YBXu42zWOEdDRrWJVlf6eAOKuO6JhpciBGzGNw1DvFkvVqk3E4m0MdEMYdx/+sO4/L5kT9kBXB4Yf/Sh6pWI1uJUgJf68HaeXRl3zgDSoOAfi4prJPRReinElt4OTP18A1y9gmY/46SD/y5F+62NcPV+SyxRtlmKU2w5s1rKIXV4glL58an5n/jHyWvW8qVU80bWUSCL5ct9EeQx7V4mWBA6AmqioiKnxK9g7hLPUBkJHu3uhc5JftCvzkRjkLj0534qPG0eiXPFpP2YGLMxs/bq7ibutLgat8nVcfyyD92VM07yFXWVh7zf2WN+9rneOLcfMEJhngZahPD5IjyEXlh8eU7/uuhHM3tiEKCuSepMR+9DoakKG7OuGQypjwqYOMOP6RsqvpvAZIn1G2XknKAPfcDJ7+WSEX7fbaw0K+91LUYn2U+shZpRVfvZiLSVd+F2PUvhNXXLop2Qgb6CSDXofYa9nxPpT+XsKe0Y1GGQHH2BSXWE6VDDmshV1E2zNNUnenx9kg2ws/2JFRzopqLrNP5jpNUplweMl87KR0VSbq+dtYyh0oV7w4mbciTZWf44cDZRHxylo7yIDwaFAo9YF3T4yACKP1BqQnOzOjLUoMLrHpNOBwGHu0Kp/KJ05OsO3Np+aQ+x7wh1hrCdlqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 12:56:24PM +0200, Michal Hocko wrote:
> I am not questioning usefulness of the tool itself.
>
> > I think it's useful to keep in sync with kernel as if we add more remote process
> > madvise functionality this can be updated with it.
>
> I just do not see any value in having it in the tree. It doesn't use (or
> rely on) any kernel infrastructure and it can happily live outside of
> the tree. New madvise functionality requires a runtime support rather
> than a support in the current source tree.

True, and actually given the fact it's using standard headers it's actually
reliant on the host system knowing about new MADV_xxx anyway.

So actually on reflection no lockstep is required at all here.

>
> We are certainly not pulling in other potentially useful tools
> into the kernel tree in for some it was even really hard/impossible to
> be merged yet they would benefit from a close lockstep with kernel
> sources.

Yeah indeed.

Cheers, Lorenzo

