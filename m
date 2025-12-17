Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF35D65C5A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 14:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024A96B0088; Wed, 17 Dec 2025 09:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0063E6B0089; Wed, 17 Dec 2025 09:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C936B008A; Wed, 17 Dec 2025 09:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCDAC6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:51:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 690B8140B28
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:51:17 +0000 (UTC)
X-FDA: 84229250994.28.22F6662
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0289C8000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:51:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j+Y+PDNm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OOlBxU4c;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765983074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QN/ChwzehAu5MUgFRigWQ2v2CX6GkTv1TaWcUSwKmww=;
	b=QblL+5CKWSJsfoZIhZH8P+uTHczLFaukiqLNLcoMT9iPzh3ov8qKVJ2M7/biQskPPJrquh
	FU97OGMEJUrTcm1HVhIU0ik4TBGAWY1xLJanfE0c4cliVmyCzeIu6369if223cgwDXfhXh
	MQLkSmVtd1OXAJHEco/rnj1aZMoHw/c=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=j+Y+PDNm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OOlBxU4c;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765983074; a=rsa-sha256;
	cv=pass;
	b=ChJMEW6En7CVB/G1IoXryh+y4uC50gzOMZQamGPcjG5rttiUe5ULCd6oZXddCQFrwCvbLB
	50M95uITUVg86XkW8NxiMKy187mDTFkLTL1tSMHkFKXW7KomBWCFODfCfw8xDBUnNrG0Hw
	OEa0FI7rOnqlA5t0s/GvHG6cW57CjcY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6Nd9K2112435;
	Wed, 17 Dec 2025 14:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QN/ChwzehAu5MUgFRi
	gWQ2v2CX6GkTv1TaWcUSwKmww=; b=j+Y+PDNmy8GtDbn1jw3mSWkP+nIdUQS+Xy
	dKYhG3V70nsAD2vZXkKZmbQR6TAIrKOnctoyyl1+LkdwCWLhm/gRFcpZ3uhQX8t4
	Jd1ISvEl4YEZ46v4AClpeVDsAjYDaCzI99Qdjbez4jNDVnLPDwcK6HXyt+zFqfZ3
	ChM1c5ZJ+yro5Tb9+34HaocWA/m3AI3mxaoVarovOK/BOCyHq6/E5OZ0idCow4cJ
	vuDMJKu6JiCJxSKa4gxPYvYktGqM7imSonW0ja3ANmREaGprtjgC671cGfBMOsHJ
	gD3Xtrk+fH+0KF4D7nqi/I/PJGiJcTwofbvfxDYfj9Ypo2O1H52g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2dy7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 14:51:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHE4n1Q006177;
	Wed, 17 Dec 2025 14:50:59 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkemude-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 14:50:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBC5vNY5GlAO+EU0g87cB1y2vPNtXfvZ1qi8picdBBEeaovHU7Onj8yYcKFgGjjgI7C/VBBk6qofAytVJbGoj3vHE1InFX8SaDCPHVvM3SpD9g3gaw8wOhz+4eGcrgHrAyFxjwOsaOZE7Qt0TaNqmRBbYTTByzdV5ebqHMqJI5gh7+3n8W4RsaDUM/E1oHqDl95XgP9ONUulrmHlHNZgFRAViqZGZjvjxQ9Rvwr4QqhKAnOrUljRl3PJ20RENkW8UD1VxsBCT8K3tZyRIxq1wEt6u26RUCvH9J8YcPov9YBRX6kAiBmbBTWNoamDiVlD1u9rIuabzTVdERRWEJGZJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QN/ChwzehAu5MUgFRigWQ2v2CX6GkTv1TaWcUSwKmww=;
 b=WcdLZn7lUFMJL201Mt9WJiSjO/cerAlUhjJA4WGwCG4Sic4qV/7NXn+HdyOXIIvbwPXJ62mekCRN+NqO+J9IfSabizIfOHwaWiyST7Nwq/YHP51DFycoaJsjkfXDKIP/z0DrUadM0EGafmIWT+wG6VWbg+BrCloId99dLQYuwPBL0TxIywrJaCwygUqcVt7yLK5p9xxigcAYHX9aQ794LRuqN4mtJV1d/VO0Zd2c0+cm4pqac39MoqlpkcTFDzsir1qkfs+iycUddIaVprEP8P1MAOGfys2xSg6y8ap2nRjJX8S++/T344whgEb6mFWxn2XQGnfv1Muu9EFEp6QRgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QN/ChwzehAu5MUgFRigWQ2v2CX6GkTv1TaWcUSwKmww=;
 b=OOlBxU4caL3f2zlStMOQJc+twM4ubqrm7/U5H18KsdtCB8upDFiHl7UuR92VMbp2mQz7LQ4MFxFqaW170ggIlWqVSkrW4/RT3hes9dr5QrvBlWUVoUIPobPAgA17pBhGCY+Qhe7i/kXfWrIuPVfM6KB2NURru76I5E3tH0RA/gw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6280.namprd10.prod.outlook.com (2603:10b6:8:bb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Wed, 17 Dec 2025 14:50:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 14:50:50 +0000
Date: Wed, 17 Dec 2025 14:50:50 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
Message-ID: <16d6642b-6f22-4d7b-94d6-92692b63cbd9@lucifer.local>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
 <1a0001cd-c38d-403b-b3ef-d19e85acd772@linux.alibaba.com>
 <671ac450-4a59-4e26-b098-7cf65add1e75@lucifer.local>
 <37915af9-d307-4955-969e-c16ea26f7f4a@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37915af9-d307-4955-969e-c16ea26f7f4a@linux.alibaba.com>
X-ClientProxiedBy: LO4P265CA0271.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: b5751341-5f26-4ecd-6c47-08de3d7bab55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QkXjtJCn6kcGhAyQSAUboqkSRGJwqdOQIai6SQrU20UpeGC91xCEr2pLxdiS?=
 =?us-ascii?Q?N90lPMmnzETzU01EgvhpaucUbIAr5CfSyBCuRlmqNU4wcSaYDF5aSjJZPPEi?=
 =?us-ascii?Q?FMCExbbCvbx9CbyJNZlYGemdFJ7aHOjcYM5LMbk3IAtPHa+B8p0JzIdLoL0M?=
 =?us-ascii?Q?HcF0uoCTnZDnlXu05Oz4HqyPAwwrKXsX4wB1axe//uqEd45iwGQSlXHRH3QC?=
 =?us-ascii?Q?SrGBj1mnIBqMXn0iEzWDs8/ZNIHqMZqm2MZghKsTZgqyiAPpBWuMm5qlE9sC?=
 =?us-ascii?Q?/B9uBYV3/I5LCYLAJNhAUln77WyigOn4FYCl+VvSBTO2mjfb7lH3BI4xZKud?=
 =?us-ascii?Q?4bSeZq175s480h3RhgviaG9wemfRrLk+qANbVEIp+5lSl74LLAP8ihSBE/ln?=
 =?us-ascii?Q?7QMkMl/X7b7pbJxbOTvL7aHxCAn59xJ5WTj5rjnVeuUOkdq4TI51L56ywqJc?=
 =?us-ascii?Q?3q0qpU8guQvO4ODkBSquxSKduiFsgDAkwjDAmVpwLl+/inXDjxpXb5qXmTvQ?=
 =?us-ascii?Q?D/Q3/vw2KGjbBzzMVORC8mv03Zm9wm5eDM63tng22J5bJ46Mf0D6qPMI8U4n?=
 =?us-ascii?Q?y+x0hyRtutDlwyx+UB+jcS2UsNLkSXYpfpPAUQZCvOwm3r3kG//TfvAdRsGs?=
 =?us-ascii?Q?RYO2OdZ8ypl1G7AkYuhuKY8ykDHsl/OFQWSAd/s+bYDU1aBfkl8o/QSAREQ/?=
 =?us-ascii?Q?YB1O3y0Ee/01Cnpgtul4nG3jvzcFGFF4t/1BIqKYsJ77n8aZxJyG9QIFwhP9?=
 =?us-ascii?Q?LFYyzruIKCoQ/XeWQn9+ITFXxoUgAl5QTfl1FpY3c05JucXJiGpBzrbQXZ8n?=
 =?us-ascii?Q?TbtDwlufNUY5hjKYe4VFO0mtPb2jsycYvsVP6DmXEWAbf+LRoZBO8sKw/GZO?=
 =?us-ascii?Q?2AmXhOgS5+uadLNjXJcq9dPiR5OUtqAnKnR1OF+n57BZnTdYgLvtAChjctBL?=
 =?us-ascii?Q?99jm9UXYmSUciWMkHgnXau7df09fDrpEs4CeFHUAd/oNcoEKlca+YSbSP0qk?=
 =?us-ascii?Q?2JIFjOiT1YlJjofVGKMOV+Danb6noBNIi+wsEmdkFDQDPZ9rg4CsqCZx3Iw1?=
 =?us-ascii?Q?hTzdQwKfZXFKOIJqZd/kNDcztkhVwK7w91KmLkaN4VtDOV5dni7v6nazHpR8?=
 =?us-ascii?Q?x5n4krsvI+CPsS546GeQEOKkIbOKOVuC+kjCaWkITr1rBOYLK1fCAaXUTN4q?=
 =?us-ascii?Q?ZmjdkeMhOxetx3cSV1S2MJq4pW9xvQJz6/JZ2WRrzRO1DtCLkKs98QTbxEnQ?=
 =?us-ascii?Q?erJH5kcvmgyZjcL4K6kFaN9dwoA9FyBUiVgFoM8Ct7ArDPpTMLonOSp/voGk?=
 =?us-ascii?Q?bWZyff/V/MN+1Kr0O0kcUxFywiZyDzHZR++71LS766f7HGjqNsjCvfgBCvAc?=
 =?us-ascii?Q?NHdoFkRhiYdXxwH/bB5kiOQG0/D/bgGO+QS4g4c64cN93eK9jGDKHFUFq0Sd?=
 =?us-ascii?Q?8UXFS+yj1oaEcqXXCpJmKV9aNN9/U5zg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hk+t8YujUrvh3Lplgjuj3ve694IOwYjqEuuBnDKaDKUj/vE0mGv3X+tqfTpx?=
 =?us-ascii?Q?I8CBnuXTv9i8+PNhqjkmqdxM8c2MMXb939qTU659d2TnNAvpyJ7Rge5aNUbV?=
 =?us-ascii?Q?hPKzo/rVEAdKTCoAQkISYdnU4KLK5aEHzjwbXHJYhUuiTYNjIUm7H9B5wIJC?=
 =?us-ascii?Q?IHEvKffJRPTnYeV0KBAPQMbbOw5V5eODLZWuAr47eeGrDGv4pC6j90rqE/dt?=
 =?us-ascii?Q?U7qC0TYpaqUSKIiPc0A2/EUQmEmed1ST+Erjp/2wFool343qD5ZbKkxWUUIo?=
 =?us-ascii?Q?VuTEIAXgtV0a4geJEkXXivu2vvGcR9cqu6WoSewNXJAT42M/+JPgndQ7NfAW?=
 =?us-ascii?Q?/CmgkG6K8homZvF1Dq618sB/NprFYo4X4N1prh3ao+BJnYnteLk99aXD6Rrh?=
 =?us-ascii?Q?ENZwkjnaLBXoy3UAIHwZZWJm77QXYQcLau0QqU7MUNTy6Kt242ClXhFtvjzH?=
 =?us-ascii?Q?6C2nft/zndHzLqYLzN9dfczrbpEU4o3F/JWT1EIcE5yOyG6O79YtDOao5lK9?=
 =?us-ascii?Q?we9znYpvgSKgZH598UVb87QIyONsnClN/8zO8GM/o5FGRvEyL3j8mnhrwUGt?=
 =?us-ascii?Q?J/KdznUUL51jYQA0GaTckYqbxdU9tzSuW9+amLfWG89YIxk3fuur2gVlKY1B?=
 =?us-ascii?Q?F/QNrBsV466D8GT7BZJybl01LnvJ5kDaVV+t4TIFuHYfoXCKLUsxacFm3Q2C?=
 =?us-ascii?Q?+3Vfj0kAvAhZG6rkobg9NdRAOcTDWhIEAB5Jz/ikgrp1anCkiWQMvrGy1/IO?=
 =?us-ascii?Q?gEHXTjGrjF3idubjirX82yvHW0nK/0Q+xspLom5ifdFF0lsaGnOlVyDX8lGs?=
 =?us-ascii?Q?P5SjCHFqxdvgGUP85zv/6dEXK7Nr5MMW4ZwBGmV03mX42Sdp4zQvPTLtCc3L?=
 =?us-ascii?Q?nKot1q61DBnc6cqTmZ7+JQzj4hXrs4IMDOqxJeq/igzq9vzYKvxzGmjds/rG?=
 =?us-ascii?Q?ZzJ8SRWX9kZsRhpUnFw8Cyss0odkLZEAXcvo5WkMM1PBlgNxK3wxqhCK7J9Z?=
 =?us-ascii?Q?mXp+zaMgzno8C20wAp6IcXwlWSu/t07TvcCaCmT+FDIggdzaV9qTGdzgmCZC?=
 =?us-ascii?Q?IUAKKZgp+UXoCPJA82uriyNIbJJZyJylDnlCS1qFVYsMzoNiTsfeRhwFiatC?=
 =?us-ascii?Q?WDuLTuXMdJuv7MFPYSrT7lUfzUDbLaOWkSvGMOFoCQBgm8R9yGfYVsGuKJBb?=
 =?us-ascii?Q?ZupKx+OTTEFINX1cZsbYjDVaenN7xjHYPVlW9g2lwmKpLoihqOQCa+xznHbK?=
 =?us-ascii?Q?QUOKd01Xg5t0WnzGJ9wGT7OPPf9A0jimdVzbr2tK6dubVx8g9ROUnvTRXmfI?=
 =?us-ascii?Q?AgKzTxbvQuDeNi6jqyzTIqalcScw5LJ7ZD35wBPxBGgzo2bbLkU88oV9Ucie?=
 =?us-ascii?Q?pnLZXQszVtjhIiMlaZ6vFdlX3XEmrQfu7FTZt7J7oyti3vGtjlQiOPSHAvEv?=
 =?us-ascii?Q?2p3vPGBtjbFH5B4h9zfPdVP0ODfKa29ChpONTlGXd1ZlSsjdjPHCGRwTYGyR?=
 =?us-ascii?Q?tMRj0+AEiSDJm9bWaHeGWLdunaBlphFjC2LmmDar/IifVxRhWbijc0yDqjjM?=
 =?us-ascii?Q?Mw2yYzHdCWIiL776yEJiwct8MWEzCaR+C6DnzpOdwM6+FqS0ht/iIB0guKey?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zbr8+pmXuFS6HFS24zTATWo4dcQJf9e8QE1eUaoeRmRM3c21+QZk1tGljEPTqGiE8LENjfYeAi6dyMY8jbuliHps1AhQo1fpcNdMMIq+BsvzCOC6z49ENsLK/zs7CP9bF7aYC5p8DTLZyzqCQQaIOIclEcR4ZjFeov8mgK3QKe1M+Ueld2znCYSYLztf5h0OHtDzzJWMfr38jurjS45gZuXUl/koQLuBNG4iPxjW2oRoCShwx1OvrdQ+6yeDQPXG2GFw66eSz0vPlpX0OmAxc3Bx2Jy5HEFXAiG39de3YxDk1Cvixj0ZeSEpsZa1iJCi6ptQt0GhR7FurCWbhwfWedxe+6zD/YidKkkNpyj5+qoXB5RdscnmCyo2l85d7FC7VELv9Ml4dIYRvlCofSbw2tzCBwVH7U5Vx0rYolEJGgUVt1yuk02eC9fMjEPazbq2KLHN7uj/BlZT9JaeGUJxbpH4mbpLbngF6ywk0faRzfydIuEENIRjyw5yUsEjAdSQ7urT3p2EU+afkciF+AtDnFZuwkAfOwqJ42lUhEL8Sq1b3gjEuQW+HgyQQ16Gr7mWu7lnNZUTqh1wmAavoMhwJwfeW3xfgJ+AfUtuZ01c0Ic=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5751341-5f26-4ecd-6c47-08de3d7bab55
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 14:50:50.0987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQ/UlM8ukjyLp+T6BWxLaVBye4uNfvtOd5b2ToYhMtf/UN6ao39alZJbVW/kDfpO2VJRc/iP5X4tPLhar41y/JAPK8uZw88jM+Lsd8K1IbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6280
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_02,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170116
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=6942c354 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=DV7eJ0f4MyGicN00f5wA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Proofpoint-ORIG-GUID: fVfdlgD0kzj162r926bXKaW2V0L5ml3t
X-Proofpoint-GUID: fVfdlgD0kzj162r926bXKaW2V0L5ml3t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDExNiBTYWx0ZWRfXwAHSdxM2OHEZ
 4A6hWkiu/WkotjH/GWMyGNxY1zSwJiRsKAqAOPEw1kdEZoeUpd3PoIVJEomJ+2Lr15D1v8MaKOD
 QONbLsaGt9y+u3pg7/Mww7aqyAtERQb3QOqD4hq4ScxufVWL31ix7ibOQzjgBcB+Ev9AbVleXHW
 EBVTJ2m9E/6NQC4sHNNOszjwfUGSXZLfPkgd1WW82u/xyQDbXqQrvXd82FZNTYhb5pZb0YmX+6B
 cJ3ti/Rn/FAG/TJS7C5AqLazPplf8K70o7JXS5a8um3ZE+pH72WaKnEOXyI1G1BSU0gjNvQx5KX
 4NhZtfguKsTKalXASHeFnk3x5oa82RvM3SyagANCPVHh6NJ7oYa4gONw1lY28lA3DBM0Acmkx50
 3Y1D//Sek+S9QaEXavfB7lqR6QZ/e9pvi/8AVOZ9cS8wUfdFv/A=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0289C8000A
X-Stat-Signature: h97zumrtxafqnapqymd9dtuncyqo4b7j
X-Rspam-User: 
X-HE-Tag: 1765983073-30271
X-HE-Meta: U2FsdGVkX1/Z+7u2xqOcMH9n/mP8Wpub+xTwffDxiVssC83Xd7bWKGDY5T1OV7KYPtDDB/KaqEOEK92dFk20NWDEnZcDZ26GUpYbpsO7u4S7+syBnk3Acmyk7fkkk4KWIeSBxPb6ZS2U3TzVQ2BNjFn0I0s62meKuBV6Hazq4uuQTuy7Ygh68/r+MXv/RoW3mPXDz5eY9qrxroLTeWEuFwicb+npbaZDiLE9pfdQCkzsjhS4aMb7RM86QrnEm/vhWGS17PoM9je4QDRdjhlIbZlZ1D4I4zZZQy9shI1l9nr6p+2tpVWX+zcrKcvdLAi3CvW5C+0tM8cUVxXTGV8z9QLONabvCC9DQL/fkE4Sbak7JuE/fUE7Zt8RW1x757lbmk6j7oFeysAPebRS7yhTUxxwYbIJ4PZV44+65W/Mkub9ZUiE3uTc1ug/Jl5nF2RArerYVEtm4buXDFCnd8yIHx7WZPlyp7fvBd0J69sYRej+iiLy9NsSuBL3uyrBMQ+j3jSCuZ5/q5ypByu3NpeGH3UoQb61INxJFkPeaYSC5FZUpJR0vpD4VXzgyu7N2D7Y65D94nTs/WV+dQWzD1+q3yY7r0JyyYxJsuW53wyUYflvlgwVMtPcSeZo6e0Edi7ovgLcTTV922ueFPXndivua9ayONwLTxUXCZ+7QXwnmRCq+Wi94J1xEpqLlOlU7cA4Cs7v3x9nHMKNMEn7qvBb4wKsVLcXeH/U2X4t2JdiU+9FRKQe5EUuqlFBmYqQ7tTHTBfc/ptVjA29A7TGV9jrregW8wy1Od/RrAHiIBBXh5kpSqard8JIevDZjDt+OKaDIA9q4SuRsmyBy8erLDlfP+WT3vGO/6f1vknrJ+/KsM3NSD6bAAdFkMYt8gas7vU/R0SvR8cR+1z7jP1NUnduYYOBG2sxZQtkvpykVDqer50WkZO+pr4sLPML4iAJBdLpkXsxGXdbIoyi1GoNbM7
 rS4P7zt7
 GOsJxu9u8TsMWaD7CRsYTaggHYNAqw7WuF14GUusacwkElzeJedI9+g/ueTZ6yl/jCQTrkFHE8iioewvWgWgFVB0IAz1I+HT9OL5NG0VfOoXJ0gXi3BKX6poI0ix8YTZtD11Smgye6aep4No3IHrYSFPfQ11bB4+5gxbQPbm+9rg/0gvZVPLfKmy8FBK1llGSBttdy651ity+3uNyUdfzaYaJo5Spq0SSYajEd1kNYvTSJTlL0gUUi7wGhBClOiQOyqNt+308VXtJ7vHzjhrRwyCsM6dJpayM1Yd3U/MPvYco+NZdJ8VC5NS8jpjRxDVeOBx5W1ag1fFqtw5tSeye9kqkAqMyzQMFZ/ca89vUBECaYYogAhWchPb9vAlPwk3LFM3CbDaaLTWDn/x/MH5xuXcDT4F+128rfzOeMT8R6CQSPrr72WgnjXmh/x7BWtq5SD55dsH3lh0TtV88dj08+CkEXHSFo7OHi8TIX9cjJwB78I6Sis6MjNcOOQNvxjAEnfSeF+SNvCAd6pGXxHKwnPWB4Akl3yyoMwMXDzq+MiEIErgD+qm2EJNJE1T0Tb2t9zlRtLPyp+hCr4+cmZ726cCX3jQIHC7+frH5zugfRoGj+tXqa1xbk4zi9BGL5yxKq9/qlu96jzdC54U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 11:53:31AM +0800, Baolin Wang wrote:
>
>
> On 2025/12/16 19:11, Lorenzo Stoakes wrote:
> > On Tue, Dec 16, 2025 at 11:32:58AM +0800, Baolin Wang wrote:
> > >
> > >
> > > On 2025/12/15 19:36, Lorenzo Stoakes wrote:
> > > > On Thu, Dec 11, 2025 at 04:16:54PM +0800, Baolin Wang wrote:
> > > > > Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> > > > > only clear the young flag and flush TLBs for PTEs within the contiguous range.
> > > > > To support batch PTE operations for other sized large folios in the following
> > > > > patches, adding a new parameter to specify the number of PTEs.
> > > > >
> > > > > While we are at it, rename the functions to maintain consistency with other
> > > > > contpte_*() functions.
> > > > >
> > > > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > > > ---
> > > > >    arch/arm64/include/asm/pgtable.h | 12 ++++-----
> > > > >    arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
> > > > >    2 files changed, 37 insertions(+), 19 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > > > index 0944e296dd4a..e03034683156 100644
> > > > > --- a/arch/arm64/include/asm/pgtable.h
> > > > > +++ b/arch/arm64/include/asm/pgtable.h
> > > > > @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
> > > > >    extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
> > > > >    				unsigned long addr, pte_t *ptep,
> > > > >    				unsigned int nr, int full);
> > > > > -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > > > > -				unsigned long addr, pte_t *ptep);
> > > > > -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> > > > > -				unsigned long addr, pte_t *ptep);
> > > > > +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> > > > > +				unsigned long addr, pte_t *ptep, unsigned int nr);
> > > > > +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> > > > > +				unsigned long addr, pte_t *ptep, unsigned int nr);
> > > >
> > > > In core mm at least, as a convention, we strip 'extern' from header declarations
> > > > as we go as they're not necessary.
> > >
> > > Sure. I can remove the 'extern'.
> >
> > Thanks.
> >
> > >
> > > > I wonder about this naming convention also. The contpte_xxx_() prefix
> > > > obviously implies we are operating upon PTEs in the contiguous range, now
> > > > we are doing something... different and 'nr' is a bit vague.
> > > >
> > > > Is it the nr of contiguous ranges? Well in reality it's nr_pages right? But
> > >
> > > Yes, 'nr' here means nr_pages, which follows the convention of the
> > > parameters in contpte_xxx_() functions.
> >
> > Except you're violating the convention already by doing non-contpte stuff in
> > contpte functions?
>
> Nope. Sorry for my poor English, which might have caused some confusion. I
> followed the contpte's convention, and let me try to explain it again below.
>
> > The confusion is between nr of contpte ranges and nr of pages, so I think we
> > should be explicit.
> >
> > >
> > > > now we're not saying they're necessarily contiguous in the sense of contpte...
> > > >
> > > > I wonder whether we'd be better off introducing a new function that
> > > > explicitly has 'batch' or 'batched' in the name, and have the usual
> > > > contpte_***() stuff and callers that need batching using a new underlying helper?
> > >
> > > OK. I get your point. However, this is outside the scope of my patchset.
> >
> > Well, no, this is review feedback that needs to be addressed, I really don't
> > like this patch as-is.
> >
> > So for this to be upstreamable you really need to separate this out.
> >
> > >
> > > Perhaps we can clean up all the contpte_xxx_() functions if everyone agrees
> > > that this is confusing.
> >
> > I mean, unless Ryan explicitly makes a case for this being fine, I'm inclined to
> > reject the patch unless we do this.
> >
> > The contpte logic is already very confusing, and this is only adding to it.
> >
> > >
> > > > Obviously I defer to Ryan on all this, just my thoughts...
> > > >
> > > > >    extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
> > > > >    				pte_t *ptep, unsigned int nr);
> > > > >    extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> > > > > @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> > > > >    	if (likely(!pte_valid_cont(orig_pte)))
> > > > >    		return __ptep_test_and_clear_young(vma, addr, ptep);
> > > > >
> > > > > -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
> > > > > +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
> > > > >    }
> > > > >
> > > > >    #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> > > > > @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
> > > > >    	if (likely(!pte_valid_cont(orig_pte)))
> > > > >    		return __ptep_clear_flush_young(vma, addr, ptep);
> > > > >
> > > > > -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
> > > > > +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
> > > > >    }
> > > > >
> > > > >    #define wrprotect_ptes wrprotect_ptes
> > > > > diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> > > > > index c0557945939c..19b122441be3 100644
> > > > > --- a/arch/arm64/mm/contpte.c
> > > > > +++ b/arch/arm64/mm/contpte.c
> > > > > @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
> > > > >    }
> > > > >    EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
> > > > >
> > > > > -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > > > > -					unsigned long addr, pte_t *ptep)
> > > > > +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> > > > > +					unsigned long addr, pte_t *ptep,
> > > > > +					unsigned int nr)
> > > > >    {
> > > > >    	/*
> > > > >    	 * ptep_clear_flush_young() technically requires us to clear the access
> > > > > @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > > > >    	 * having to unfold.
> > > > >    	 */
> > > >
> > > > Hmm shouldn't you need to update this comment now 'nr' is a thing? E.g.:
> > > >
> > > > "And since we only create a contig range when the range is covered by a single
> > > > folio, we can get away with clearing young for the whole contig range here, so
> > > > we avoid having to unfold."
> > >
> > > I think the original comments are still clear:
> > > "
> > > /*
> > >   * ptep_clear_flush_young() technically requires us to clear the access
> > >   * flag for a _single_ pte. However, the core-mm code actually tracks
> > >   * access/dirty per folio, not per page. And since we only create a
> > >   * contig range when the range is covered by a single folio, we can get
> > >   * away with clearing young for the whole contig range here, so we avoid
> > >   * having to unfold.
> > >   */
> > > "
> >
> > Except nr means you can span more than a single contig pte range? So this
> > comment is no longer applicable as-is?
>
> The nr means consecutive (present) PTEs that map consecutive pages of the
> same large folio in a single VMA and a single page table.
>
> I think this is a prerequisite. If you think it's necessary to explain it, I
> can add it to the comments.
>
> > You've changed the function, the comment needs to change too.
> >
> > >
> > > > However now you're allowing for large folios that are not contpte?
> > > >
> > > > Overall feeling pretty iffy about implementing this this way.
> > >
> > > Please see the above comments, which explain why we should do that.
> >
> > You haven't explained anything? Maybe I missed it?
> >
> > Can you explain clearly what nr might actually be in relation to contpte's? I'm
> > confused even as to the utility here.
> >
> > Is it batched ranges of contptes? But then why are you trying to see if end is a
> > contpte + expand the range if so?
>
> See below.
>
> > > > > +	unsigned long start = addr;
> > > > > +	unsigned long end = start + nr * PAGE_SIZE;
> > > >
> > > > So now [addr, addr + nr * PAGE_SIZE) must for sure be within a single PTE
> > > > table?
> > >
> > > Caller has made sure that (see folio_referenced_one()).
> >
> > You should comment this somehow, I hate this nested assumptions stuff 'function
> > X which calls function Y which calls function Z makes sure that parameter A
> > fulfils requirements B but we don't mention it anywhere'.
>
> Sure.
>
> > > > >    	int young = 0;
> > > > >    	int i;
> > > > >
> > > > > -	ptep = contpte_align_down(ptep);
> > > > > -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> > > > > +	if (pte_cont(__ptep_get(ptep + nr - 1)))
> > > > > +		end = ALIGN(end, CONT_PTE_SIZE);
> > > >
> > > > OK so I guess for PTE_CONT to be set, it must be aligned to CONT_PTE_SIZE,
> > > > with other PTE entries present there not having PTE_CONT set (Ryan - do
> > > > correct me if I'm wrong!)
> > > >
> > > > I guess then no worry about running off the end of the PTE table here.
> > > >
> > > > I wonder about using pte_cont_addr_end() here, but I guess you are not
> > > > intending to limit to a range here but rather capture the entire contpte
> > > > range of the end.
> > >
> > > Right.
> > >
> > > > I don't love that now a function prefixed with contpte_... can have a
> > > > condition where part of the input range is _not_ a contpte entry, or is
> > > > specified partially...
> > >
> > > Like I said above, this is outside the scope of my patchset. If Ryan also
> > > thinks we need to do some cleanups for all the contpte_xxx() functions in
> > > the contpte.c file, we can send a follow-up patchset to rename all the
> > > contpte_xxx() functions to make it clear.
> >
> > It's really not outside of the scope of the patch set, this is review feedback
> > you have to address :) trying not to be a grumpy kernel dev here :>)
> >
> > In general in the kernel we don't accept confusing patches then defer making
> > them not-confusing until later.
> >
> > We review until the series is at the correct standard to be accepted before we
> > merge.
> >
> > As always I'm happy to be convinced that I'm mistaken or something's not
> > necesary, however!
>
> Yes, let me try to explain it again. See below.
>
> > > > > -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> > > > > -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
> > > > > +	if (pte_cont(__ptep_get(ptep))) {
> > > > > +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> > > > > +		ptep = contpte_align_down(ptep);
> > > > > +	}
> > > > > +
> > > > > +	nr = (end - start) / PAGE_SIZE;
> > > >
> > > > Hm don't love this reuse of input param.
> > >
> > > OK. Will use another local variable instead.
> >
> > Thanks.
> >
> > >
> > > >
> > > > > +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
> > > > > +		young |= __ptep_test_and_clear_young(vma, start, ptep);
> > > >
> > > > Again, overall find it a bit iffy that we are essentially overloading the
> > > > code with non-contpte behaviour.
> > >
> > > Let me clarify further: this is the handling logic of the contpte_xxx()
> > > functions in the contpte.c file. For example, the function
> > > contpte_set_ptes() has a parameter 'nr', which may be greater than
> > > CONT_PTES, meaning that it can handle multiple CONT_PTES range sizes of a
> > > large folio.
> > >
> > > It might be a bit confusing, and I understand this is why you want to change
> > > the 'contpte_' prefix to the 'batch_' prefix. Of course, we can hope Ryan
> > > can provide some input on this.
> > >
> > > Thanks for reviewing.
> >
> > OK so we have some reeeeal confusion here. And this speaks to the patch needing
> > work.
> >
> > This seems to answer what I asked above - basically - are we doing _batches_ of
> > _contpte_ entries, or are we just accepting arbitrary large folios here and
> > batching up operations on them, including non-contpte entries.
> >
> > Presumably from the above you're saying - this is dealing with batches of
> > contpte entries.
> >
> > In which case this has to be made _super_ clear. Not just adding an arbitrary
> > 'nr' parameter and letting people guess.
> >
> > The contpte code is _already_ confusing and somewhat surprising if you're not
> > aware of it, we need to be going in the other direction.
>
> Sure. Sorry for causing confusion. I try to explain it again to make it
> clear.
>
> First, it is necessary to explain how the contpte implementation in Arm64 is
> exposed, using set_ptes() as an example.
>
> Arm64 defines an arch-specific implementation of set_ptes():
> "
> static __always_inline void set_ptes(struct mm_struct *mm, unsigned long
> addr,
> 				pte_t *ptep, pte_t pte, unsigned int nr)
> {
> 	pte = pte_mknoncont(pte);
>
> 	if (likely(nr == 1)) {
> 		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
> 		__set_ptes(mm, addr, ptep, pte, 1);
> 		contpte_try_fold(mm, addr, ptep, pte);
> 	} else {
> 		contpte_set_ptes(mm, addr, ptep, pte, nr);
> 	}
> }
> "
>
> Here, 'nr' refers to consecutive (present) PTEs that map consecutive pages
> of the same large folio within a single VMA and a single page table. Based
> on 'nr', it determines whether the PTE_CONT attribute should be set or not.
>
> Second, the underlying implementation of contpte_set_ptes() also calculates
> 'end' based on 'nr' and checks whether the PTE_CONT attribute should be set.
> For example:
>
> For a large folio with order = 3 (nr = 8), the PTE_CONT attribute will not
> be set since the 'next' is not aligned with CONT_PTE_MASK.
>
> For a large folio with order = 4 (nr = 16), it aligns perfectly, allowing
> the PTE_CONT attribute to be set for the entire PTE entries of the large
> folio.
>
> For a large folio with order = 5 (nr = 32), this involves two ranges of
> CONT_PTE_SIZE (16 PTEs in each range), requiring the PTE_CONT attribute to
> be set separately for each range.
>
> "
> void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
> 					pte_t *ptep, pte_t pte, unsigned int nr)
> {
> 	.......
>
> 	end = addr + (nr << PAGE_SHIFT);
> 	pfn = pte_pfn(pte);
> 	prot = pte_pgprot(pte);
>
> 	do {
> 		next = pte_cont_addr_end(addr, end);
> 		nr = (next - addr) >> PAGE_SHIFT;
> 		pte = pfn_pte(pfn, prot);
>
> 		if (((addr | next | (pfn << PAGE_SHIFT)) & ~CONT_PTE_MASK) == 0)
> 			pte = pte_mkcont(pte);
> 		else
> 			pte = pte_mknoncont(pte);
>
> 		__set_ptes(mm, addr, ptep, pte, nr);
>
> 		addr = next;
> 		ptep += nr;
> 		pfn += nr;
>
> 	} while (addr != end);
> }
> "
>
> Third, regarding the implementation of my patch, I have followed the contpte
> logic here by adding the 'nr' parameter to
> contpte_ptep_test_and_clear_young() for batch processing consecutive
> (present) PTEs. Moreover, the semantics of 'nr' remain consistent with the
> original contpte functions, and I have not broken the existing contpte
> implementation logic.

OK that helps a lot thanks.

So the nr will be number of PTEs that are consecutive, belong to the same folio,
and have the same PTE bit set excluding accessed, writable, dirty, soft-dirty.

But since we are retrieving accessed bit state (young), isn't it a problem we're
ignoring this bit when considering what goes into the batch?

I mean now it's going to return true even if some do not have the accessed flag
set?

I am more convinced things are correct in style at least then this way as, as
you say, this is the approach taken in set_ptes().

Thanks, Lorenzo

