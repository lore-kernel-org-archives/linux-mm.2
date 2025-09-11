Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132AFCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 15:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46AA78E0006; Thu, 11 Sep 2025 11:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4426C8E0001; Thu, 11 Sep 2025 11:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309C88E0006; Thu, 11 Sep 2025 11:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 180418E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:59:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A509516048A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:59:14 +0000 (UTC)
X-FDA: 83877428628.16.585B62F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id B4DC740007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:59:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sDktUzao;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Tpi/ki1D";
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757606351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojbVzqSM/4BkW9aObjqxfXU29GzpzE6lXPwZ8p+HUcw=;
	b=eGbmguX51LNiK/cM6zFoDFsQdTs9C38msjlkWp1FWWkPSKWjK+/7OQ97aY9fW5qb3+Sxhe
	+tHk3n/w9WAqdOg96YlFEkbC9+w2otmgk8M7liIrm3rugUZK+FUd33hlSu9gjj+7U5ZjDW
	HxM/tHedh0SuUXT9ck20VDN/23pzxAg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sDktUzao;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Tpi/ki1D";
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757606351; a=rsa-sha256;
	cv=pass;
	b=O8eiu40kE3meqG2COz5/d4md0JCH4jIqq9XsFfVwxidzvH/t2oDDDc4AATzxw2IMTy5pMD
	4hHikCpFbGlnw4CEiJnDeu/Dtua268DMaj7IG2nEjcLmtI5K/PJFF8KI/ndD97H6UH4SDJ
	y68dENkT0kkq8aGus8V0BvxvITeEgTg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BFtqAQ029583;
	Thu, 11 Sep 2025 15:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ojbVzqSM/4BkW9aObj
	qxfXU29GzpzE6lXPwZ8p+HUcw=; b=sDktUzaoDww7YUUPtvY5uD7EBfutrWIGz9
	l8BckopsF97aTTSHK+0d9I7bRx4WWG/Qo0U9jR0nre+uw8r8ifBHkM3pWFIbMUF7
	Pi8DjXij4HulBZ7JYItgTJXSmoTkl9g/f1K8pQz/CrACe6ZkawvXMMICF9olOiBE
	RUtIuoeW8wF5m6MoZA6pofJClfj1kn88S2fD1UJ7L8RFCZwrdKz8fwoCJNS5470H
	Gc9te53B6yFW1JyDkYQoYtUgqFTA22zu44lV3r1rXB9c71Y2M11XwP1pTwAKhuLx
	qcQf9QTbYXVTKg8sDoYp8o0jQsUxHkkmnuna2DmY9ZWt7LGMx7Vw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1pq2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 15:58:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BFTcUB013398;
	Thu, 11 Sep 2025 15:58:40 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdctseg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 15:58:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3M8AFVLYPtTUzrIWcplp7tIzIWY8LoOcSQUXtsW7x1/mV78LKiBTVq97Ke0vnEelclkQfdDHfpU2WVJCg9wMdzNs8GfG6k8e+3qjIHliO3WivRxrIA7OdSS0bcl12QVeE8ZSsx1B4DSjCeHQdadzec9OE9u5PhVz/B2ZmIWcJE/Jb2w/932D3JnLOzAx+/SR72GbeSvGea7frUJy87rXP43oGrjzNIBYdc1LFskd5lfVg11N72cLDm48k3/M13raxs7Emi6PWIio2R6T8bTAYkr/gZmpIgXLhX+HrbWNZdlZTjnKibaDRLcdOgEAC8HR8HqaXDazcw4R9bUuo8QEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojbVzqSM/4BkW9aObjqxfXU29GzpzE6lXPwZ8p+HUcw=;
 b=CUeVLOuBVBitfvJ+HTQKmrK1+lD6G8DMNOCp9j9iDBoHolnvQhFatED4IhnpFwz6OEVJ01HsyPu3KQ6VfBHAnt1sG+LRov1kOLuZarkRdfS0hbGJQdvRkBgr5n+BY7A3mdYuKd6aB5RKX1gsrUaYUQdN1cOf83T9mal8q38t24nik1YLRXTKD004svfyQce0VbEzbxL95riGn52zOolbSMXimaeZFAzj7NVxxIb63BKbwKyvsKo/zGLB765QQZQMulYKDD0NrXFty/OYgHbFRIkd6ZusxeEP2DGHsDkvYKmAsHKudPYFJK4u2EnAk8yV5gqG74HTMK0kdA+YnQv61A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojbVzqSM/4BkW9aObjqxfXU29GzpzE6lXPwZ8p+HUcw=;
 b=Tpi/ki1DBfMCt6ZoSYIMMgi27g7fIFxZvQXyjmG/NnJv4UDezgNG1CSTbINlbr94oQLaNi1r73rQqK3rgzdw5/8QHEr7sv7hoCESS5hYi+3AsKG5ONYAD5zF9GVWiVScwJtlZ5ri10ZT2+hbVWPvWfLZT3c4Eg6g1d1u2PSh73U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7654.namprd10.prod.outlook.com (2603:10b6:a03:53b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 15:58:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 15:58:37 +0000
Date: Thu, 11 Sep 2025 16:58:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, willy@infradead.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
        21cnbao@gmail.com, shakeel.butt@linux.dev, bpf@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 mm-new 04/10] mm: thp: enable THP allocation
 exclusively through khugepaged
Message-ID: <a2c122f5-ab6a-4242-9db8-e5175d5b27b3@lucifer.local>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-5-laoar.shao@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910024447.64788-5-laoar.shao@gmail.com>
X-ClientProxiedBy: LO4P123CA0629.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: 481e3028-09b0-4370-5ba5-08ddf14c11c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z3fiVa1c04LgULOECAPzEkBogZww19fsicobMG2BgXduG9nNZK2sJa5SE+v+?=
 =?us-ascii?Q?5pfjiizZLdTxCRdEVJQQw6HUun9AtB/E8Nyb/4XQp9PLWnPtv3zix/zMnWp+?=
 =?us-ascii?Q?H8U7RJbCyzNSHc1JRJBvdX8OlZehnsb+EbnmA2TQcG/fbMRw9syyXehr9cKX?=
 =?us-ascii?Q?5OnNCh4y/UHOYJqWt6V5/XW6ScY/GEwSo1By0ybmnZYTByW9QvOmnYSiVQRm?=
 =?us-ascii?Q?CH3UR5X2cy3Bde+EQ16lvzQQlbmET7pVqYendSoNb7POJPLcr60Z2LfrXu2w?=
 =?us-ascii?Q?vV1OWL6jqAe1M3Vbsp2a5JXf/fX8jAujt6GiFR3PKkKcXArvUUZOQjZAt7eb?=
 =?us-ascii?Q?4hWycxt4+UcisV/mVfCrN9/jTal3hqOEj/U+wD6MekxGypfRYbmFTKRWSQnM?=
 =?us-ascii?Q?o0aBhwj2DIEyGdawBBmMhHvA2VXVhOFkJ/6Kku24lOpFS/ekoz6sClpfc9rn?=
 =?us-ascii?Q?JxnVUfpAlohO5sRRSthEyHZn42mQ29pQeAdNG5JeK3wn3T7Jz0f4N3hBZJp7?=
 =?us-ascii?Q?EIJX9VieV45l9etX2vkCHjY4sdjxUFt9oln13D8g/h0ioFT9smAR4RxPBQag?=
 =?us-ascii?Q?zjuhCY11+QWPdDht5v4baLt4AkspSRSquUz8NEbSkG30dNKVewsGgmYlECnN?=
 =?us-ascii?Q?IO0nD8xYm26qJtYM3RX1Jn6s8bhVQ/OAUV+OrAAesxplFpPEK6z/kgWmneSM?=
 =?us-ascii?Q?SBs5E9seUw8CYgBcqg6vvR3R74Lth+VutsT4Dx5hQAiJUO+DCsN6DG25lyaT?=
 =?us-ascii?Q?1hPj0hk57VrCaVsqOm+OpbCI//NsUOHEel22Jzo5YoDKWKsR+H4KbyDTF+94?=
 =?us-ascii?Q?8Fz7k6tFbl3Fi0PAITaZ4UE/FkNpNxMQhdhXBEo1bU2tmAKDWv08mBlNRXCw?=
 =?us-ascii?Q?3KvxCLIWIqnCKrkopX+ql8fkpARE7VD6poGw7mxb0dK1J6gSXD6u+Ey40ucZ?=
 =?us-ascii?Q?uzuQGgUNIgPyZfFVWu9HofyOUCM8One3Paat4cm/21Gxldg4hWPRt/+WccaY?=
 =?us-ascii?Q?xndJVsRe1DgJhc2Lxj3OvKxddol+3VRT0eZf5EqhJUhFSZGc9NpV3XfqMmdl?=
 =?us-ascii?Q?KwIoPL9PW4pp1XC8gE7zd9WN1fa3T6ERPVdZREOkse1fdaXXE3lOem2kBH6W?=
 =?us-ascii?Q?GFXvNQjoSbRc/GyyVyFUcs0r7I8E2mMYf3bU3FL0NGWRAvC4VOMR28AXdV/+?=
 =?us-ascii?Q?aIy9z9VmVXXILLLnyeawSFGFzTbl1l9fErxNzdOln8tAisNi/jau5FFdZYpT?=
 =?us-ascii?Q?RudJ4MMtnyQADTPEoGByQfwi617MXsKKJ2THwd2CpO76FT9TOrW0fja4ZUGe?=
 =?us-ascii?Q?6r03BjciowMtukW0yCX+YWJFVB5BbrprczkFq20RE1HAvcH7G4itmt+GsLaP?=
 =?us-ascii?Q?iuBucwA98tm4L/aRLAu7thOI4s5cJ4gs2VdUXDma3TVK3mJFw5ZeYiQDI6qh?=
 =?us-ascii?Q?Y6JTHfXoO5k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RzSHHrStzkTvepR2aLFeZdfRaByVCivCeQly48K2572d++phmYoANX9HV3OC?=
 =?us-ascii?Q?rJ+UMPblNxf/kG91DBVa1JyJefJBYfFCvMcOTm9B1vaT4K3cK+ztxPKrb3ai?=
 =?us-ascii?Q?Isu51BjSPrChm3UcGKvYFDkHufYhTUlPRXphf0u/4FFQhcn3RyecJafLj7wH?=
 =?us-ascii?Q?fj8QAIsWWq90KyL2C4flRSOU1bEwcyfzM6kJZ13BF/UC01QIMy+Xn7BshoqC?=
 =?us-ascii?Q?T0jmvdwvs+gp5zRlYQKb/E614kEWNEKBxxbs+d5d9qlh9P7gYgrGqMOGcRyn?=
 =?us-ascii?Q?Xe6itaVmr2VSABPA8QO6nR0+nVpcREtkPmBiWqeuUpZ/+dO3RENevQrpJBsj?=
 =?us-ascii?Q?by4tNp/jp7GlmMMCEwo1BjzOuG11GKSSR5t7YiMF0yNMiVhUMD1cFt5xV2gv?=
 =?us-ascii?Q?8Zm/rH/4UU9QbQmjBiJ76cWkAVpqtWoC9V3V0AtNHWHMCL2ITywqjR5D8OLb?=
 =?us-ascii?Q?ixlPwIS6YcMFNyjI/bCz1Ya3zpBGDyKAeL00SdjvtmOm6RaL0DDJoJxgwfQj?=
 =?us-ascii?Q?F/1g8nc1maaT/5MZvF5q0MYkyLgv+8vlgHY0556P/ZFJq7pzvH5O2HTZl5/3?=
 =?us-ascii?Q?ZfSO16UOkisqfTkadM2ozIJ4zoRdvJeP4E2VVmhdudIaLFm23YKAOrCifFLt?=
 =?us-ascii?Q?F+WFh466LEe3UHBH6iSasoj/dY00XYm2Y3RYWW3L2H2mcdEbbIJCKpO7cdvM?=
 =?us-ascii?Q?HG/V1yPlWf68VIQ2YGqOrhPK0U1b3dC7qlJIWVcWCGr0uVFlzHRKT+SvCU9/?=
 =?us-ascii?Q?rrtkkuj+d8GYrzgarXMpu/Ey5tDwW8eJywQcxfCfxih26goaw9ZV8enbMJ0t?=
 =?us-ascii?Q?Os+Hhy5HCxzIrYMWYXZ6pOv0kAJH+sF5jWFg15uUkBpGNDiMxcw/mgP+MI8j?=
 =?us-ascii?Q?Mh4e5C7ZASzc3fyaHvrGKvUgsP/zo0DyRJenHYqKJH9J3FLlXFC29lqiXEOp?=
 =?us-ascii?Q?9S6+39XaXtDeJR1AwGIuq9vhTr4SCCikyZwpmbgfFJGvMROLsjNytk8XtjJp?=
 =?us-ascii?Q?hVCx1eLfFrMw8COCXVdOjpV61+yo3wMJxsLhw4xPHurjfJZR5mt6NMp+I8D7?=
 =?us-ascii?Q?kg7IRAT0ffyIQLjeWJlNc0Bvac93xmbGLsEOCuxJEEFEISHkNSq3fBYmZqX3?=
 =?us-ascii?Q?Bn8iSwlWClEk1q/rDo1NKSpsFf6BGbHG7v1n/DgXjeJosU1GF7eOkpi2bQdP?=
 =?us-ascii?Q?iNkfSgWgZ0b75CoRugR7yFu04LNmfK2fhW4Cmv8NwNEXezS4neTjCF4CE/2u?=
 =?us-ascii?Q?MnbkxpCLjIrcs0O00wswIqj3BEaiMvk6n+OMuSplwd5S5o35QwmMUiRWqQDM?=
 =?us-ascii?Q?5+avNmDKHMLyF+uBiu8ke5d9ICMxpqcFrqKLxZxWyfkVplPd0xq0uSM5M61A?=
 =?us-ascii?Q?hRgUQ2sDgCfkXRkftRmhWMbmwMs8mdBDslIvPapCTgrXIJs2ceuyMH1fqSlk?=
 =?us-ascii?Q?b0UPnZ1aRW4nHhoMtFOs1tddivJfWqZabUNxAv+doWGtzHSredYU3s8hAbrD?=
 =?us-ascii?Q?6QSwkhqFS+48bbJsSPMSlOpJBbwv27jJ4EWIW4GlWCq+jcXx2PVRjwjdkaxb?=
 =?us-ascii?Q?gi0LqrxqoKXVlZTY0W43of0/7fs5nZwS0RVcbbhjct9y48lnmqiR3kfHmNgr?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xbj8LWv7V16smJE/H+RsDgUty6yvlAUV/XcfC23klCVdwwiYRjvbuUwl3tIhUjQu1jBmz76BkBUFpDXixG1kL5KS7KnA87uiB4C0FIeGwuTiXLoWqRtOvWKwhWc/PDiBiAdYmQol30cXpW2xr3ZtpFrjDZ+VfXvnXoDww2IZaOV/5d/ygGa4YHPGKWLHZ5dtVRWb7JrcxbacfHdCFLDzQZ2qyu4DK8g+w2hf7DPHf7vNmhs1l8hCZwIwrLuCzQllI1k7gJzPCJF6ORDV0aTPx94lcqy9QBWN83xEOV9OkzqSD+aHgMqdrP2jUtKSvi6OLKUNDFvCqXadAs1Jx7nJ9wYo/z0Q08zRYPSUWVE73huwh9zghQHznMHp/+TnzbuAv5W/phrHljnoJJuDa6G6/fk1bZ01G2d41dJbLGWkTiI1S5J2bJZebwqV1pH+7tyxAmlhZlgcQw30gQHxY2YFHirms+Uv0c/Q441mMIUS+BH4rH2o7vpk9J7/Bl6sxVjQuj71OOW+vj26Pxo+GWuER8dWFCodqRu27QIJ8T82DK7QmnQ3afrc+ttoBiEqTFbvKLKnvAhJyIWCC+QWF18ZMM/VDtoLaSkjs72g4KchEiQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481e3028-09b0-4370-5ba5-08ddf14c11c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 15:58:37.6231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xLO0dms2S59e1zG826lkRzjbHlQ9b9oE+cvKJsL6l5Usl32wSnnXCsKtgoW8rAJv6Egs3x8ujf1cKsg5wdmbywPisxDp/UE3aT6V2lyFTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_02,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110142
X-Proofpoint-ORIG-GUID: hVCLeJQ060YrRt1Gxc-fzuZC3jzZaBCb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfXwWi11SaKqj8U
 PPKwqRtq6ZP349qxs97lh3Y4XC1wpjLwDkAs+5KgsNP+gjy2svnjvzb7TcrkT2b0LhAk+p9zLv8
 78htBBSkULciTo5uo2j7x/j2R5ILa7kbI6we1R0I/Btm2sc00wqiORorKhYY2ybZFSRzK7Lmfsm
 imqAHZ7DzosBkNfkrG3wxQnQavNZDZ2J5lPycrAb5+z1qlsc65TKDaKXO3OhPauQsWMpYX4GNbZ
 Ubry4V+9AGm5b9jVhC7Zy0MDyzt7e742/fjDsqNUVGf1pjRu9pUaDbhIVrQS8b5jAC5RXQhYazC
 pk/biAIRP2BmBAJAKPF/Dz4F9T9tqkNQc+0/QvnDQqPxZYtaAmckaogH7rrlXAJ8lxYzjyHbU8E
 LiiKjPQO
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c2f1b0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=FT7PAADoqO9mgDEFD_kA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: hVCLeJQ060YrRt1Gxc-fzuZC3jzZaBCb
X-Rspamd-Queue-Id: B4DC740007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: e795co9jxmpmrgm5h93cogntog76e56t
X-HE-Tag: 1757606350-658637
X-HE-Meta: U2FsdGVkX1966AMOKTe1rGq2RkiBqD73p7memzJUO9k9ewJhZNVJ33P/KY1vroBtMfTeXJzVd+qmP0KX74VkkG7svXO0kh7VSG13Rvbt4sZDPG6hF//+0AG5mDiujmJmZ2Fo1SnPjkW1GDwm0/+0+Um27SO//ok7nEYo/LPHG5viYTJ/VKGY0NZpCnUERTIjui/h8ExElLqJ011pv/7N8I30QOeIaAmHkCmysvAqEY8O0tsnCR+Xr2cQAYXSJJBfV1kduCJvP2NhqDK0Ge4bRKgjEqNj7BBbh3e5GwhUn8M2NZRvWtrDIEDXbp6BbF+p57Ve6y27/zBb+kYe7eeH5hW74eLfBHdQmXsVWdDDX6xqWcfgk9qrsAU6GmSOcC/F04CvgKGbNwbAnTHz7s3NBcxaeXqoKaK1aHGmzSJHLNiZIuOB81LEjiEtxSDr9mNWw+6vXkvwZYfxOjX2/8UK/I8ainFLAQ6BSoCQJuM86Gt7xowWjJNNhPyyywxsnFBVouuN2AS0Vnc60gCyELPkULqqy/oim3d7p2wkcdjQzaUPKz8RjcOp9uPtmEnvQlAqZ1kuQjV4fZ9nagQQtxAGrxSDOhKiVzJGcK2W6q+ZObSqHTe3YDqDii+mtCn8fzOgpdc5b5ydsMx8Cy2tDg2bryy+2T7ZgnwxTPJHaVd6KAsZKgkhkmFgBjk5Yr7W+dAgt5p2sJ4R+VKFIf06hz3kKIJIpkYUFc0mJvIR6De6OU6uN7ikuqvADcf9ze33JdlhXKjz4cjZVbNdEIYW8+uAjYGQ5pAyXv6Cyn0IdULhQ01eZV6dk9Yu769y+Y8XsaI/c1eqzvKTRGpuZ6VCZ1d47EqnqBEIfC9z3Qa4fIkAtSqhcTWu9V/85N640BstNgBWmr1fb2Gh8LLqAQ01AsQvD7nT3xNmmagCJRyM5LS4WPnfeLepgOBfcfVYra0bK35mIxXtb3MC93lakFNy5B4
 clRLyf25
 771ZYrGHJEV176AWDR6fivi/nv6fYbC7FoLIhAVrFuhccivu1HA3yJaPh/c783J8HeguFklhxvm5EnbzY+BHw+azS217Ug9sDsX097OOnSKLN0WJ+x8MLPsdpK2gAcF4jBuiGJ3HRmlmSdSLUqz4LezcpX+uOdy5o95KxY1p6UWMiPsBX+ZYQk83Plkof11r8Fqwqb+bzM7Diulneh8bG9zXxXgS3/JB4jvQTzavmPGO3Och0vc9vbb8rkQ8PKdXcMcvy/1GeG6egsRY75Xr5/ng4ljdic2xYhP4uT2+A4FpneD3EbZ4DZyaef3kK/7VM91DDNeMlve5DlRl/yjo0wDqGX5jXU0lXTfUyM8CRRwACOE+EdC2g53OW1h+fN46TdHQG2WywrTIcOdSvmStFy9ATobcYb+M8n/kSdr6cwSo6/0qBLpuDhWkCLvn0ZAO4v6dYq4FzXI6xUCJxYpATANXlyTNBWx9ORwNWlYcc2XZiRy4J1V1i/b7V2KOVtt3EqztGwmTqbRCksy3M2NHJ60jMx9wERylaYHJOXdxrGXIOHOCDPZxZe+G6myihstGapSyZfXwdEQSWp8oRl5jWwCO9Dpbx6SndwGmuBUqmd1SFdYYguyZ+Lm0r4ztTe42HUc+SzJt/3ue727f+9Nc2pDuH/0vsMPtvl0/GZE779eqX4S+uyOfOK/jyXmDgGBzPmtupjLudATYIg1WZhoGHLhYOzJpgSYE3trEgdwnDtbGHfmljgb21HM1yX8PMS4Nr2SRDN75cWCbZC9oJFzCQC7tQX1zWzZh3/hAf8oXZKsnv5oAOJhSLNWLHYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:44:41AM +0800, Yafang Shao wrote:
> Currently, THP allocation cannot be restricted to khugepaged alone while
> being disabled in the page fault path. This limitation exists because
> disabling THP allocation during page faults also prevents the execution of
> khugepaged_enter_vma() in that path.

This is quite confusing, I see what you mean - you want to be able to disable
page fault THP but not khugepaged THP _at the point of possibly faulting in a
THP aligned VMA_.

It seems this patch makes khugepaged_enter_vma() unconditional for an anonymous
VMA, rather than depending on the return value specified by
thp_vma_allowable_order().

So I think a clearer explanation is:

	khugepaged_enter_vma() ultimately invokes any attached BPF function with
	the TVA_KHUGEPAGED flag set when determining whether or not to enable
	khugepaged THP for a freshly faulted in VMA.

	Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
	invoked by create_huge_pmd() and only when we have already checked to
	see if an allowable TVA_PAGEFAULT order is specified.

	Since we might want to disallow THP on fault-in but allow it via
	khugepaged, we move things around so we always attempt to enter
	khugepaged upon fault.

Having said all this, I'm very confused.

Why are we doing this?

We only enable khugepaged _early_ when we know we're faulting in a huge PMD
here.

I guess we do this because, if we are allowed to do the pagefault, maybe
something changed that might have previously disallowed khugepaged to run for
the mm.

But now we're just checking unconditionally for... no reason?

if BPF disables page fault but not khugepaged, then surely the mm would already
be under be khugepaged if it could be?

It's sort of immaterial if we get a pmd_none() that is not-faultable for
whatever reason but BPF might say is khugepaged'able, because it'd have already
set this.

This is because if we just map a new VMA, we already let khugepaged have it via
khugepaged_enter_vma() in __mmap_new_vma() and in the merge paths.

I mean maybe I'm missing something here :)

>
> With the introduction of BPF, we can now implement THP policies based on
> different TVA types. This patch adjusts the logic to support this new
> capability.
>
> While we could also extend prtcl() to utilize this new policy, such a

Typo: prtcl -> prctl

> change would require a uAPI modification.

Hm, in what respect? PR_SET_THP_DISABLE?

>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  mm/huge_memory.c |  1 -
>  mm/memory.c      | 13 ++++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 523153d21a41..1e9e7b32e2cf 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  	ret = vmf_anon_prepare(vmf);
>  	if (ret)
>  		return ret;
> -	khugepaged_enter_vma(vma, vma->vm_flags);
>
>  	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>  			!mm_forbids_zeropage(vma->vm_mm) &&
> diff --git a/mm/memory.c b/mm/memory.c
> index d8819cac7930..d0609dc1e371 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6289,11 +6289,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  	if (pud_trans_unstable(vmf.pud))
>  		goto retry_pud;
>
> -	if (pmd_none(*vmf.pmd) &&
> -	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
> -		ret = create_huge_pmd(&vmf);
> -		if (!(ret & VM_FAULT_FALLBACK))
> -			return ret;
> +	if (pmd_none(*vmf.pmd)) {
> +		if (vma_is_anonymous(vma))
> +			khugepaged_enter_vma(vma, vm_flags);
> +		if (thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
> +			ret = create_huge_pmd(&vmf);
> +			if (!(ret & VM_FAULT_FALLBACK))
> +				return ret;
> +		}
>  	} else {
>  		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
>
> --
> 2.47.3
>

