Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C875CCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1993C280001; Tue, 14 Oct 2025 08:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171C48E000D; Tue, 14 Oct 2025 08:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013D0280001; Tue, 14 Oct 2025 08:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E02218E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:37:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9045B1A08C3
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:37:05 +0000 (UTC)
X-FDA: 83996669610.16.A35BCD6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0EE4A18000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:37:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="EcFC5a/k";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f6DPeDZR;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760445422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHYG40Ckah0+cYq7f44uC8Rr0W/5WWDLF47V5VmL5b8=;
	b=QZGvysKsiQ7UJwyxpPiQXUlowI7g4lf/1Lft8rfaFGUie2koa7HfUq7yxMn8OH7Fyhzftj
	edqeUq/GrGgAChkoV9hxf2+Hai2wuIeBTOObrEoCleo/dK0Rkg+5lcHzWD70fMlxYq3qqo
	1xUM09adoqbdLagDaGeYqLyVQz/jzlI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="EcFC5a/k";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f6DPeDZR;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760445422; a=rsa-sha256;
	cv=pass;
	b=IQxVInkP8SiJzTwRqM+k4I/4FL9zuk4YZAvStjgigyfD9WHX9Zu6H/0L/4/IeA8QI3cvjs
	UcD0GVpHSlKA9CZTMOJxNQwu83/Lpf7blAbhnjK7VvsCQdjNFu7HzSrB0xNUTGnt7NU4oc
	VXWGJ897e7yjFbbZxh13t5ZH+z+JJBY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EB9sCH019624;
	Tue, 14 Oct 2025 12:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IHYG40Ckah0+cYq7f4
	4uC8Rr0W/5WWDLF47V5VmL5b8=; b=EcFC5a/kUzKzB5dBxdg6P+MeareiXPMkUk
	1pwFe1lxa4hB6EcposGxLGp2/ClqI71zkQS1BPjG7fHgVDm5Q8YGqqXVgcrXf6pU
	dHVuZwlY8pZ4mM7rldcndS9vLZs6WjYub40EzF7+CTIP3uTvMKXOQPgINJ20A1qY
	Gek15o0M+uLxCAJDjTy6oEATzFD+hIcwhN+agcjOPAap/FaDU0CMEt9TYxvkczAj
	cAtj1Y+JFRjNhS0bFWTKY1By2cWfKmwWND7B9P2d7mhvRw1D6Q2inNTh9mOKOZ91
	CVvnJhyOcw3TMUCNCiRYDY9mxSnq9NPrto7MHFeSzYRkA08VkpFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfsrv68r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:36:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EC08fN037213;
	Tue, 14 Oct 2025 12:36:54 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp8w0qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:36:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0FgOXFgpm4xeH96Bk++NkgR48vkXVMFY+jpj/i3R8EkMYimi7wRIawU5paupuex7UCEzenkWzssFmSBXFV8+xjIKJehegmiVDMiUKuM1er8jWhVGzqD7UEeuyycw4+HOs3k+qTUQQz1O+nXh5PaD6tYbdquwiDPYsAT0PE5E/wkLulbQauOsdOBXn1YgTy7vbbeHEgWzZGGOFQh1uMGuNKgduaD4BKRvpuZEZGHiqFMXgYCDsrAAraSC4ouwRd8zsUojjltlprHESAEdV/dmwWgp+N5DVBUaYo0mNw83+PUMY3QrCBlg0js1+L4P+vPTwPGHPzSmznYQZdQxZS8Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHYG40Ckah0+cYq7f44uC8Rr0W/5WWDLF47V5VmL5b8=;
 b=RayZyLnVjJ1bcN0uJCvpYU0ypCTBczFKiWjOfJB4srrYZAVzVN2lPtRCawF300wzwVbtcty8O1Wfqdy0xRstAz3o5h2CKDJeeNVzDM9RwypbVene4QLkfXPLYOY8eA57qvgve0lBVMRaR9QbOj1P+UP61UzmILaHAniqShtAWiFoilWKPQx7SMf+6ZF43y1gfCd+1yxWTTS/EqQl5l8vAd+Z0n2ITtC9TpMDSyg6ZOovLjKW/fkuKlXVWLnGQkLG/RZtqQk6lEVXdDHO1JJKQcr6Tnt8+rvafV82Cp13vaDy3zDccYaqY6S8AvcQjYpizDL81c/0hcIxJpGL2wrMkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHYG40Ckah0+cYq7f44uC8Rr0W/5WWDLF47V5VmL5b8=;
 b=f6DPeDZRr3T29J+osI9xDoi802REtxLE57Zkc3v7xADRhJ4w6ix/7aG8SjXZJaH0n7gucxfN0qqv9KaEMnjy6pj8hdhD+sxBS+NmhYSUHrg71SL6FokqLJ2Gp9eLLQ3Wzz6gp7IwBkyUtnh1WBlsBKtGxXU5KFGIeYMX6+RJM5w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB5632.namprd10.prod.outlook.com (2603:10b6:a03:3df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 12:36:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 12:36:49 +0000
Date: Tue, 14 Oct 2025 13:36:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, richard.weiyang@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Message-ID: <80341f56-6f8f-4e41-8f80-f1863256c662@lucifer.local>
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008043748.45554-4-lance.yang@linux.dev>
X-ClientProxiedBy: LO6P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: 7037cdea-ff5d-4e8d-1633-08de0b1e587a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E/owhrNOQFBu8hJgXKsOBP4nwb1LPcPvV2B1oYXcsu1vMvm1pnmVIUp9lTQT?=
 =?us-ascii?Q?dPDzu2R3lsxylwzUcdlWMw0+D2sT2kZ4/RyzZOog8zat8qFlhZ/m2OfdRv+A?=
 =?us-ascii?Q?8oHZR9ETK8Cq9Ide6IFTVbqFeoalyZviefLfKh7gwMH2m8r7koh7KBIZLnOA?=
 =?us-ascii?Q?0rlIFJDrvgQG79RiMHQbwZRQAYxqYneJhYJ7gKghDpMUsP26iEFNGlZpZ9Ir?=
 =?us-ascii?Q?KbVPDXCUaaKoX3zPq+3Rncmy/43ZuhfMBeuhrCvFxiOh8w0w1ueJumnOgFR6?=
 =?us-ascii?Q?CbxtcGh8oLdMXyge3AQhgCoqjPiKpLWSzh7RdGzzLqujJC5twbqkGt1w/gKy?=
 =?us-ascii?Q?0fxFmOGd4bVeYW6gvRhTjUEoxPMk/1YZPs8neuDF9lpsLYE0mB3WzI17KqVp?=
 =?us-ascii?Q?tD2xqhmMmfc5Em2XPG6ifr78Wtdnzf2TxNlFoD3xIhLyU4aewbi7/oUzpm6Z?=
 =?us-ascii?Q?1Xik9CtnmMYje5fVWBgYy3GPTP5AmbpvY82HppW4uQyBqr2ljQxYKV5xltna?=
 =?us-ascii?Q?lMTskYDyeevRQoCV3WPE7SPtdttQBjCIIOVmrNH4soPeKfk0U7MwA+BgKsVm?=
 =?us-ascii?Q?NbwCWmbFgywIwtc26jND/caoZ3ZMWW4hRraSJaMpqgHg71BGRS4I4xaHGrWc?=
 =?us-ascii?Q?POeJA/ckUNreaPFJD9+kV2aKNc+KjmM8OuacW5OYDPRFBKUJMDXFYoYT2KRZ?=
 =?us-ascii?Q?ew5sPNEWkQ/YZkilXhYsc047kKUj5OtaRsWHsKjGp5B58Y+gLW0KiaDGj1bB?=
 =?us-ascii?Q?ts5rNyfMnCLsHHzEMm22roUt5pGrM/zXswwEYGvgTQrUpOXW0VP7H+fmsfwt?=
 =?us-ascii?Q?WVGrywc4Cmc0UtbNqbaa9IMj7Hqk52GIThuK2GwzHXM8J7xQrU8gaFxI3zpY?=
 =?us-ascii?Q?erC/4L7Zjn/AWawg2gtdnsm2SqjMWlNMRwOk+AQgCuKwIuUjvcAYHcA6i3GZ?=
 =?us-ascii?Q?A3eSi4nXL1kQ//TQdhFTep7osuG/zmJRXsK9Uj8NQCn3w5xY8NB4len992VH?=
 =?us-ascii?Q?+LZ6ZMkmxzLhEw9ST7QPzvxUZfYOw7iMb0rNobqod9IpoNaHqQSWHjb2svxH?=
 =?us-ascii?Q?sBWQxKQKkp2YdlNTGmkJvAutI0cpIgvrAP3iAsVFt7jIW83v5vDTNnqGqsDr?=
 =?us-ascii?Q?uJhqbCKNxenIP/OmKF3vLhwWv5eoKHTSUYEf+wrThzrhEgpYzooP4m/E4K3p?=
 =?us-ascii?Q?NAiAMa0yAEJvrO1hzgrGkNggQNV0aLqClX6sFEWbJrhb69vOL4SaMBxzLtqH?=
 =?us-ascii?Q?t+AEGemPUlQPVfrSHkCnarEWYl0vslPUCExNyEKGW86XiUtElOtarH87IRRw?=
 =?us-ascii?Q?nDkFZwfaBGSasEaxdMpQR7gCfrl2/Gn0GFQyed74Yw3Qsk/oruGeL5FGlVOO?=
 =?us-ascii?Q?k7w2qMrNZP/4cee/x2hkc1ifZtf2w0867WGHEVF7se1dKupprg849fJF18jZ?=
 =?us-ascii?Q?W4SWqEXYx5oWB8xvBfD+wqvZ25WwDKlb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fd+5UzGWXD21A8wArt9pfRUfudjiUiyJKuCtKjsk7yqsSM2YinD4WMoQS6GJ?=
 =?us-ascii?Q?KpD3StRH4248MahkJmzL+N+A7DA0MkbBXt/lQHyy6iF9YTB8a1qLmjX01oV5?=
 =?us-ascii?Q?MpYtitVMjZHKIsP942JjiW7XB2NQ9KU42QWPh4PdhnbMA+ERz3RNt13FLOo+?=
 =?us-ascii?Q?t/BA+V0zQEUqMGIpm0kxhOtyGlP6a6O372cZ8Pjm27LiHJxQjS6FbPc5yA9b?=
 =?us-ascii?Q?yrSM+yzC5/1YhPIF0zJRKazw6B70qBrLDhSaknVK58J6d2qcVnBzsPMwZGet?=
 =?us-ascii?Q?mnlLAHBfA+XkrPXA1+sJK6hA36fktxuZniBsJwC5eFEWUFIXmn9gclLAN8Xf?=
 =?us-ascii?Q?wF39eKXzQwSdJbDGoniBZcNMfK1vTyMHA/6y60f8BJ7u4kBDYoYLGYcR/Gd5?=
 =?us-ascii?Q?lkW7hskI2cSTJrHamKki+Lrj987w+urejmQUCS/tJsWnZXoesDMvmzRT4fVC?=
 =?us-ascii?Q?DzFM63ak3kAguJNbT5nO4SmwtBqu/n092tuiVHylGlKEy+KoxhjVqvFxRB06?=
 =?us-ascii?Q?u6/l4kxHFqk0mAeRFDoITfazVG1pxBzYYXoEdME+uzNYzL5gxqrG0w5RBHa5?=
 =?us-ascii?Q?PKO0yJMJBpRemom+xlO3MGdulMpZSmGKz/lT1zrq3ixQueggH9m6fWqqPb4V?=
 =?us-ascii?Q?4iO9JwyOZGCbk8vzo3QvQ17VdNOZ8ssylqp/dxTOle1b1zk50iZJHx5dddv3?=
 =?us-ascii?Q?o8L/xNpUiTkxDrgHljD6HrgASSPAudyuJQabjlY18Y8vjYwT+CNgfOFhRmiC?=
 =?us-ascii?Q?gEmX0HL81WQUl1xqOHaWso4EM5yQPWb1h3gBiI+KgOiNU70rvAvGfToQAwFh?=
 =?us-ascii?Q?ykI00zo3F+LRgmdwlT1SdYKEtxkOUUAZpBdbqXcMux+kg6exGkRb3uCF1r6c?=
 =?us-ascii?Q?WXuleM0/dUWtKzOxVly4RtTr0AbXLCCxjctznAkfUqVoWVYPiFI1iRrL67eC?=
 =?us-ascii?Q?YEIFxf2e7Teq3Ur/L07e5TY4mERKsk2qYobGx80hNWvB4R1kjb6QsLFB6I1f?=
 =?us-ascii?Q?bHYka8kl0Rpm5m09AtdzfHybQrpCKipIV9WvTS9IhSCRwbvXYrhwEPY3t68q?=
 =?us-ascii?Q?FzeYBu/tF8S+syZnf070chU1bBMzNnq44hJBq4RIVeLVTAx7JUdNG8x3hDgh?=
 =?us-ascii?Q?SxMvAcI0FmR69Uf18jBl+hHgAz93G5uO6l8Vvwy56h2AENghzOA8zDeIbP/s?=
 =?us-ascii?Q?TBtLobLwnoQoYidVNDGn+eTdZm/ONqQqTWFpPrzriIl3CpSTYan8qqLYw8j7?=
 =?us-ascii?Q?CHygn9GMpof+XrruUs+jC78ZH9lIC6Ew1s0b6qge9q9n5R9ypv9Yx5cwuNz0?=
 =?us-ascii?Q?BlsUtVfNZzPtoallDPI7c0eOvrFtbOgEOAnzpv1Ylxj5PQdMKJ/h63Or3hmK?=
 =?us-ascii?Q?gu4h2vCl5v6+xC2fMqDnbWvOOyTQd5e6wNA9m56RPJqAVET5FF6g+vh71rlF?=
 =?us-ascii?Q?rbdjETu/QsNsy3ftht9jNTdwETuG6tmdhgvypEA/fKmeTTEMc1xc+pS548Gx?=
 =?us-ascii?Q?vXg66jXbI3L7bkULG9MSd/t269B8x+vxLMbc/dQakXSiNuofbkIa28Un1qxD?=
 =?us-ascii?Q?jjx4yZF5Bnj7lrOLb1ea9HwnJ7y7lYTLJpE9RgmTXkSzmVAcwnKLcduTuCK9?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4BdMi/NZuqB0PYDQwv/u9pAhLIVADRFl1bwtrmodqpAmtnvVbeGQy259I6Pj1Dax2MqXE3IIPHwhj3YQFN/F4YqGWi9raGJrQkWmltYjmjtHrJ5B6KpTnYhjLhoMWlszV35sKJ6Cn328hcGBCQH5vxDcf1S7/coa5y0kuqV5lC5AxO0iGuYwKwOpiAz9WaP98Hu8zlWLE1CisLYeong5xKH2+jrNh4WE0kiruo1xEdVr3S7kneWVWDcJ7+1C6SFoiXXMKB1a/igK9Qqfy8NH40zVX1IQmA2cukl1cbkKzueSKdQmSO4wvHs/Sc5hdxtRSyrZLFHeRl3/zp3X5+DELEpMRX7XROxLSEbKeaQI7AUG+GRTaUeb34806zadv65pDxr+N7ec9WVRtLfIBw/4pFo9v488e0WHmJm5DAXwtDmOWACJ9F/BN4OpHLlyUc8Oiqd1ni4D0824NWrRy0ElUlJInJ8BQbDDOZAzBwyxmjQl736rfWvm8pwLT6pCHArBZnn2GvhgHAn240yRHPui4RWmoHlIPPK457/YgIAPA0qUEfPTgv+I5WOJFNLiPtZrqHp6EWJXAKV1jOzeOBOaFQCBu8OCuvG/4POrsBbLwUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7037cdea-ff5d-4e8d-1633-08de0b1e587a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 12:36:49.6199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2lY9XyGGiwjXRa9SPtcnMNX4ksOwfEsGLcMkZKihJCuSABkC7RZD4+/QCztS7PNXY4r8SPsGLWqyagP0PVnvWq7HzCWCA/vxagrJ5v8sOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5632
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140098
X-Proofpoint-GUID: 8Rjm-ve5QghEH4mEPuWDACwCisfv7BUj
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68ee43e6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=vFDKSenX45RvfEaX7TwA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfXw5WIusSTTuKM
 yo7m54pz5ldrSlMMa0NI0pdW7ODZjoGvlAqvliQQ8gNsoutsox14Ex8zyuvFL4atC4sqcVEiLZ4
 MWFszaeOmnzVglBufMtFdaiEXlPyXQyEPa1f9kkPzkOqzCE9SmSTOWL6Vw5HkGjggyAgHw/LmAf
 iDNWk2KbcsmMPo6NAI4xSERTRONHyZcxeTPafj/Wu1dUF1Lf78E42F476OksHwKOF8wGf1CVViW
 n2oBMTYOrSXm66hIlGdTYjgUgBS9hDBCrvRTqBUViostrLKMJBbDOl+o72LyTxziWcPtxZn5RRj
 WEpsx5VcD9Dlnlxtzp+TLvnUeqfzd9K9/odsCSC1eC8VOJeOm6fYxteW1bbJWiL+L4ygLnh9F3F
 XAvr7YHzsSviWJ5H3HydhB5592fnpw==
X-Proofpoint-ORIG-GUID: 8Rjm-ve5QghEH4mEPuWDACwCisfv7BUj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0EE4A18000E
X-Stat-Signature: 3yk79o74zqfr1mqrb6ctjrpm95gxpso7
X-Rspam-User: 
X-HE-Tag: 1760445421-389665
X-HE-Meta: U2FsdGVkX18I5MHHkN8gwVUdv7iZ0zslTp19/9U43okjYK2i2vxkPYzEXIew7s5pqX/3gp4Oy13MKDavM6VlvYOfleT8Q8KDlzYX3IZOakt4kjgkK/yPWwBNEeaqT98m8zlL1/S4CQYLBePpbLN4xGHX8jjcjQWYFh8k02gWitOBVTApwidLOdC6nJdyEGFIkddJFKbEsSpz8jHSUoN5Zw8GtUzwHLnnk+Iy157AgQOMuVbegAaTrsrG71wCDRaAP5G/Zs3L+s0iEH75hqAvBwDEb3PuKF+X/IX3r5AbXlGCQ1uyPCWM0zbJkiqLS7v2N6u5aG44NRga+SrFWHD4tKK10W9sTRWX4QAZcAnbmSO8swS+2xKj6Fg0Sr1wSVBbdrdpXI1/OzGwY0wt4pJi1h5A+Y5Jd9IwTavgvzqqy5egsyU81J0K7YmW1As48jtvOg4B369LstngsTM62VuvtOjoUUBMkVDUkkX68J4TDHGHlpzmPwF+6MBp5kILK8ybEsbOQabcbb55gxh9jMEvi4anPq45CovPJMoBl7mYAe2h1wK9/OoT8eWu1Ynd3fJfS3umcx33Z3n/HbtyRKOvswZe7SgiiqSEkx+w/isC9jNTCYz/QCNeEKor+QMWi1uFFpVmzMV7MCdd2aPXOkmqgHqtD67gIsbnYuQ+XFTbquPRDstTdOdFGc/6iYe+P+Mf6ntnSeCPh8rNUJhKiJphJyV7AkUGYs3zzpZn+CTy/jHRL7VAOUSF5G6XlbfLX17Vi+Btp0l9Ox5s0v3OOjfML8Fc3TvVrj37yDsRLXIT3O+hvdsvu5Yef5M0nEAO6DhBwEwmyqYrQ+0BhU7ISyisXOucqUsrzWvfx+xB5Nu2J1LZhLwSmJ8z45vVPa+zeBxbWN+ygZmTUuqhf3+9dsajWuf5MIn5afNrg5xGPm1tRFw8hnoAvzewsqYgyophxXStcLUeBJ8bjG5am2mUNEn
 /V+Lnuuj
 cUsb7hOG7VN3O+G9P2p4LhpjivYVIsLmY2QBP4U5f0mZPbXNhbVAEe2nTVJ1PPnFkNLWK8+P3GVK05ETxCm5N6ZbKohWeLnNNk8BCVR53XVbIlskvQFsldzstkEWk4PZtpDy+zsxqNg88pnO1mRuPQf4dGnsEatSpwE8hhAoK46utuBfCEvXKJd4CijY6jTQSKZFfN8TCuuqb/aBtxSZDtCOUtv14IiDiHJmNQardri96JDLQ+iMGwrifIgbkf5EQTBdLPElj7Kl67UVshqwHcSL/XapNQ6EPy0oSLLfy+ocm2G/e7pDBFI+zXD6lArhbe869xyPGu8ZTrSz8RkRSzCcFNCb6eCkSR71tDB2vXth9lQTCHaMRMRV7DAj1FGdLzRgjWIArkkO+ZFb/DgHG1Z1/Q3Raole3s40XvaWqdjQnTP1zDoeT5uynbsLAp0d+yfcdOUqcVCV7db3h35qhm/I/qHb6B5SQxpzjzL+CSC8SMrkqbDX0yTFSFn1xOhvXgVWKQifb06M+vn7E3GeENHTUIUy9DrT842SXMv331vo6MldoV4MSVBwN4a4R5Y0tUltA+7sH7XxRCdW3TdDp+7xVHIeY5vgI/IZuOD3vGxvfUv/p0xubTeOqT87PEtdxzuWFTEfRfOqnWjzUbagG24T6EJSak5qQloij46uoaQo7cwIdFS5gzd/lzkPk1GfViVPUGcJjMyucOsjW0MomQ5A0IS/GjxberGprLq9dbzUGPJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
> and __collapse_huge_page_isolate() was almost duplicated.
>
> This patch cleans things up by moving all the common PTE checking logic
> into a new shared helper, thp_collapse_check_pte(). While at it, we use
> vm_normal_folio() instead of vm_normal_page().
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

In general I like the idea, the implementation needs work though.

Will check in more detail on respin

> ---
>  mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
>  1 file changed, 130 insertions(+), 113 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b5c0295c3414..7116caae1fa4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -61,6 +61,12 @@ enum scan_result {
>  	SCAN_PAGE_FILLED,
>  };
>
> +enum pte_check_result {
> +	PTE_CHECK_SUCCEED,
> +	PTE_CHECK_CONTINUE,

Don't love this logic - this feels like we're essentially abstracting
control flow, I mean what does 'continue' mean here? Other than you're in a
loop and please continue, which is relying a little too much on what the
caller does.

if we retain this logic something like PTE_CHECK_SKIP would make more sense.


> +	PTE_CHECK_FAIL,
> +};
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>
> @@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>
> +/*
> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
> + * @pte:           The PTE to check
> + * @vma:           The VMA the PTE belongs to
> + * @addr:          The virtual address corresponding to this PTE
> + * @foliop:        On success, used to return a pointer to the folio
> + *                 Must be non-NULL
> + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
> + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
> + * @shared:        Counter for shared pages. Must be non-NULL
> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
> + *                 PTE_CHECK_FAIL return. Must be non-NULL
> + * @cc:            Collapse control settings

Do we really need this many parameters? THis is hard to follow.

Of course it being me, I'd immediately prefer a helper struct :)

> + *
> + * Returns:
> + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
> + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
> + *   PTE_CHECK_FAIL     - Abort collapse scan
> + */
> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,

There's no need for inline in an internal static function in a file.

> +		unsigned long addr, struct folio **foliop, int *none_or_zero,
> +		int *unmapped, int *shared, int *scan_result,
> +		struct collapse_control *cc)
> +{
> +	struct folio *folio = NULL;
> +
> +	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
> +		(*none_or_zero)++;
> +		if (!userfaultfd_armed(vma) &&
> +		    (!cc->is_khugepaged ||
> +		     *none_or_zero <= khugepaged_max_ptes_none)) {
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_NONE_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	} else if (!pte_present(pte)) {

You're now making the if-else issues with previous patches worse by
returning which gets even checkpatch to warn you.

	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {

(of course note that I am not convinced you can drop the pte_present()
check here)

		(*none_or_zero)++;
		if (!userfaultfd_armed(vma) &&
		    (!cc->is_khugepaged ||
		     *none_or_zero <= khugepaged_max_ptes_none))
			return PTE_CHECK_CONTINUE;

		*scan_result = SCAN_EXCEED_NONE_PTE;
		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
		return PTE_CHECK_FAIL;
	}

	if (!pte_present(pte)) {
		...
	}

But even that really needs seriously more refactoring - that condition
above is horrible for instance so, e.g.:

	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
		(*none_or_zero)++;

		/* Cases where this is acceptable. */
		if (!userfaultfd_armed(vma))
			return PTE_CHECK_SKIP;
		if (!cc->is_khugepaged)
			return PTE_CHECK_SKIP;
		if (*none_or_zero <= khugepaged_max_ptes_none)
			return PTE_CHECK_SKIP;

		/* Otherwise, we must abort the scan. */
		*scan_result = SCAN_EXCEED_NONE_PTE;
		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
		return PTE_CHECK_FAIL;
	}

	if (!pte_present(pte)) {
		...
	}

Improves things a lot.

I do however _hate_ this (*blah)++; thing. A helper struct would help :)



> +		if (!unmapped) {
> +			*scan_result = SCAN_PTE_NON_PRESENT;
> +			return PTE_CHECK_FAIL;

Can't we have a helper that sets the result, e.g.:

	return pte_check_fail(scan_result, SCAN_PTE_NON_PRESENT);

static enum pte_check_result pte_check_fail(int *scan_result,
		enum pte_check_result result)
{
	*scan_result = result;
	return PTE_CHECK_FAIL;
}

And same for success/skip

Then all of these horrible if (blah) { *foo = bar; return baz; } can be
made into

	if (blah)
		return pte_check_xxx(..., SCAN_PTE_...);

> +		}
> +
> +		if (non_swap_entry(pte_to_swp_entry(pte))) {
> +			*scan_result = SCAN_PTE_NON_PRESENT;
> +			return PTE_CHECK_FAIL;
> +		}
> +
> +		(*unmapped)++;
> +		if (!cc->is_khugepaged ||
> +		    *unmapped <= khugepaged_max_ptes_swap) {
> +			/*
> +			 * Always be strict with uffd-wp enabled swap
> +			 * entries. Please see comment below for
> +			 * pte_uffd_wp().
> +			 */
> +			if (pte_swp_uffd_wp(pte)) {
> +				*scan_result = SCAN_PTE_UFFD_WP;
> +				return PTE_CHECK_FAIL;
> +			}
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> +			*scan_result = SCAN_EXCEED_SWAP_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	} else if (pte_uffd_wp(pte)) {
> +		/*
> +		 * Don't collapse the page if any of the small PTEs are
> +		 * armed with uffd write protection. Here we can also mark
> +		 * the new huge pmd as write protected if any of the small
> +		 * ones is marked but that could bring unknown userfault
> +		 * messages that falls outside of the registered range.
> +		 * So, just be simple.
> +		 */
> +		*scan_result = SCAN_PTE_UFFD_WP;
> +		return PTE_CHECK_FAIL;
> +	}
> +

Again as all of the comments for previous series still apply here so
obviously I don't like this as-is :)

And as Andrew has pointed out, now checkpatch is finding the 'pointless
else' issue (as mentioned above also).

> +	folio = vm_normal_folio(vma, addr, pte);
> +	if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
> +		*scan_result = SCAN_PAGE_NULL;
> +		return PTE_CHECK_FAIL;
> +	}
> +
> +	if (!folio_test_anon(folio)) {
> +		VM_WARN_ON_FOLIO(true, folio);
> +		*scan_result = SCAN_PAGE_ANON;
> +		return PTE_CHECK_FAIL;
> +	}
> +
> +	/*
> +	 * We treat a single page as shared if any part of the THP
> +	 * is shared.
> +	 */
> +	if (folio_maybe_mapped_shared(folio)) {
> +		(*shared)++;
> +		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
> +			*scan_result = SCAN_EXCEED_SHARED_PTE;
> +			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +			return PTE_CHECK_FAIL;
> +		}
> +	}
> +
> +	*foliop = folio;
> +
> +	return PTE_CHECK_SUCCEED;
> +}
> +
>  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  					unsigned long start_addr,
>  					pte_t *pte,
>  					struct collapse_control *cc,
>  					struct list_head *compound_pagelist)
>  {
> -	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> +	int pte_check_res;
>
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -			++none_or_zero;
> -			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				goto out;
> -			}
> -		} else if (!pte_present(pteval)) {
> -			result = SCAN_PTE_NON_PRESENT;
> -			goto out;
> -		} else if (pte_uffd_wp(pteval)) {
> -			result = SCAN_PTE_UFFD_WP;
> -			goto out;
> -		}
> -		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -			result = SCAN_PAGE_NULL;
> -			goto out;
> -		}
>
> -		folio = page_folio(page);
> -		if (!folio_test_anon(folio)) {
> -			VM_WARN_ON_FOLIO(true, folio);
> -			result = SCAN_PAGE_ANON;
> -			goto out;
> -		}
> +		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
> +					&folio, &none_or_zero, NULL, &shared,
> +					&result, cc);
>
> -		/* See hpage_collapse_scan_pmd(). */
> -		if (folio_maybe_mapped_shared(folio)) {
> -			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> -				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> -				goto out;
> -			}
> -		}
> +		if (pte_check_res == PTE_CHECK_CONTINUE)
> +			continue;
> +		else if (pte_check_res == PTE_CHECK_FAIL)
> +			goto out;
>
>  		if (folio_test_large(folio)) {
>  			struct folio *f;
> @@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	pte_t *pte, *_pte;
>  	int result = SCAN_FAIL, referenced = 0;
>  	int none_or_zero = 0, shared = 0;
> -	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
> +	int pte_check_res;
>
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
> @@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -			++none_or_zero;
> -			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				goto out_unmap;
> -			}
> -		} else if (!pte_present(pteval)) {
> -			if (non_swap_entry(pte_to_swp_entry(pteval))) {
> -				result = SCAN_PTE_NON_PRESENT;
> -				goto out_unmap;
> -			}
>
> -			++unmapped;
> -			if (!cc->is_khugepaged ||
> -			    unmapped <= khugepaged_max_ptes_swap) {
> -				/*
> -				 * Always be strict with uffd-wp
> -				 * enabled swap entries.  Please see
> -				 * comment below for pte_uffd_wp().
> -				 */
> -				if (pte_swp_uffd_wp(pteval)) {
> -					result = SCAN_PTE_UFFD_WP;
> -					goto out_unmap;
> -				}
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_SWAP_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> -				goto out_unmap;
> -			}
> -		} else if (pte_uffd_wp(pteval)) {
> -			/*
> -			 * Don't collapse the page if any of the small
> -			 * PTEs are armed with uffd write protection.
> -			 * Here we can also mark the new huge pmd as
> -			 * write protected if any of the small ones is
> -			 * marked but that could bring unknown
> -			 * userfault messages that falls outside of
> -			 * the registered range.  So, just be simple.
> -			 */
> -			result = SCAN_PTE_UFFD_WP;
> -			goto out_unmap;
> -		}
> +		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
> +					&folio, &none_or_zero, &unmapped,
> +					&shared, &result, cc);
>
> -		page = vm_normal_page(vma, addr, pteval);
> -		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> -			result = SCAN_PAGE_NULL;
> -			goto out_unmap;
> -		}
> -		folio = page_folio(page);
> -
> -		if (!folio_test_anon(folio)) {
> -			VM_WARN_ON_FOLIO(true, folio);
> -			result = SCAN_PAGE_ANON;
> +		if (pte_check_res == PTE_CHECK_CONTINUE)
> +			continue;
> +		else if (pte_check_res == PTE_CHECK_FAIL)
>  			goto out_unmap;
> -		}
> -
> -		/*
> -		 * We treat a single page as shared if any part of the THP
> -		 * is shared.
> -		 */
> -		if (folio_maybe_mapped_shared(folio)) {
> -			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> -				result = SCAN_EXCEED_SHARED_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> -				goto out_unmap;
> -			}
> -		}
>
>  		/*
>  		 * Record which node the original page is from and save this
> --
> 2.49.0
>

