Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B424C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39DFE8E00A8; Thu, 24 Jul 2025 14:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E738E007C; Thu, 24 Jul 2025 14:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216848E00A8; Thu, 24 Jul 2025 14:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEC28E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:02:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7A0D1DA9FE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:02:30 +0000 (UTC)
X-FDA: 83699928060.03.B4DAD0C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 244BF40009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:02:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QNER02h5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZEBeAO8C;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753380147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xErGQaafaw/teGcEuMGtJrGUWIpxeCQxZO8haI7YI0=;
	b=CdeWi69yXr2aDJQXL6nmXKDsw1d926ccpuTBqTy5Bg0MMrkGdOHAbLFUZILXUMBIGImCBk
	RrlnXYGMQNq16rCc6CBIUe/rkPyTBKMQOcHsuqG4YlY+C4AWhR/k69CJeIquIU5hmqQBtN
	WbZ1a6gMGE5wTsXJ/dtOENM3WktzjHE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753380147; a=rsa-sha256;
	cv=pass;
	b=Udc9GGC4K8BrQddDBc/h/snbQiWBTT9MMJuZIHVLsGog7W1gw1IWcjwtN9yYEfUhC4yhet
	HQ+ahHDAXIQLecF9KXkuDyVUpDazofhUDaeLSqsVEx/Fohh3XzQjbtBeJzDMd/rf9loOob
	pCJ112lwvlFxxWdD3IcTx27xs1svFZk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QNER02h5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZEBeAO8C;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGiqe1011242;
	Thu, 24 Jul 2025 18:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8xErGQaafaw/teGcEu
	MGtJrGUWIpxeCQxZO8haI7YI0=; b=QNER02h5TlP5aja9azmDJ6DWEY9nc6a3F0
	+STlcOwNhQs/gyIu42eg0Kgah1RLr7Gm7x5DRP0RziRr8aQQ2bJ1oEVzaTVhrv9A
	5DfV7q5nYqiSSdvpefDLDi/nutn8ACH88bPrA3AVohzk8mlCfqYIdBlKcJaLj3W7
	/QXH9GDbeUc7ZovS/aHcchVRkkrUIDSpxYdEd+jdp1R95beREN3n1cWvGtJXmCMU
	5usb4Ven/943wZXAbUbi55BzC8xePwenMJrjFAfTHpceYvZ3CDEGx9BOznewVKw1
	wOLtfNl48X1f/ScMwInffQUnyCBM6Ck7VcpGOBM39rU1+qQgyXXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gpt6sa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:02:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGt10x011708;
	Thu, 24 Jul 2025 18:02:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tc4hy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:02:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImwM5Lem4IDkNrxbnceAjczxwS/B0CkUjjaLeNeu9Aow8oCVtnPAyCEM4PJb+4NB6+bN7mMBMX9M2g3ayUNmQ3R+75KeeJgDzZguTsianpLdw+n7OgmdF5DJNXU43gZBFrlXetDO60pGxrYLINL+SGw+/WLjJIeDHl3afV1DiN1MiyL7yNAYmi3fQm0NqnyhQ1QIsyItzFQcpW9T9w4ImYXEwvkVz5dZZxBv9KI9keI+cufTZ4BFRlIk1SrK4mftkOiCgIzh1Jt32tckOg5cW1pg4/VdDhd8vHZx4ibvBkNgYLCslUZSryd29tMobjqzFLz2bheZcFZodYHISINwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xErGQaafaw/teGcEuMGtJrGUWIpxeCQxZO8haI7YI0=;
 b=tJxFlG7e16Nq7kJD0LHOmJM8rvUkOElSJjfTT/kk28buCX+9CsvZCyNAesYDdSj/QFu6FU203YPLOgpTqLLRBg+5Sc59lG9CJuBQAgtVQMqM78+UtZ/kaHqaW8ctcs9dOJelWTR0sLRu8hmXd79TPJ05I9HNePlccGatlZZ5qVhnMc/B55eJNWxvZHIEMca9r9xO7mUD0dYxAOdAMDh7y/6QYHvICS81kwm2AgGPlZEiMIuqU+vyAFeO1tsPdwj1cGp8HDsz+k+HV5BNhply1dXYu37eV+TgaDCp4zFDrTzTn6e51c2SF6KwC5uhqdJA5FHbGvYP5gaAKLJ3UfblYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xErGQaafaw/teGcEuMGtJrGUWIpxeCQxZO8haI7YI0=;
 b=ZEBeAO8CRlfN5ZUsU+oHHuoUVSiKmSq56/MATzWcwZjc0cphkSxHAqDkMvqknJZG5wDr+WLTc3DXw1Fj9cYKndTLqIgdnvhCCFE2Qpczrmh6/tCtlU6yNrMKCNjjYOqJP0AD4KcEK2Z+NqBsdwGU/QhpwAS2r/ui9shp0ri6+KU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPF5ADB4ADFC.namprd10.prod.outlook.com (2603:10b6:f:fc00::d1f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 18:02:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 18:02:12 +0000
Date: Thu, 24 Jul 2025 19:02:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
Message-ID: <9dd069e2-e7b5-4163-a7a9-fc59ad8caeb0@lucifer.local>
References: <20250724052301.23844-1-dev.jain@arm.com>
 <20250724052301.23844-3-dev.jain@arm.com>
 <83c00fa9-37a3-4024-b3d1-20e7749b06c9@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83c00fa9-37a3-4024-b3d1-20e7749b06c9@lucifer.local>
X-ClientProxiedBy: LO4P123CA0697.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPF5ADB4ADFC:EE_
X-MS-Office365-Filtering-Correlation-Id: 108c0bb8-3314-4cf0-c6a2-08ddcadc3704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6zcHpqh6jP2OwEKQc18JqphQ9QAXMbxeiXgg4kg7MultOBZnPgeEbUm9UBue?=
 =?us-ascii?Q?l5ShRWkVfQWyDFher+GZQq08Ck3FFZ3zCWdrA0SmhyPwXLLjdQNN5qUZgsbi?=
 =?us-ascii?Q?xHGgghacfNtXETmn09dhFw2fCMkwCA370QC6QFNDWv4C8pm15jSW9VhnLyxJ?=
 =?us-ascii?Q?8akJLfmkOIUF63ocGrrlx3WgwMS8ANO2dCY6I7IRx9+n7E6g57rbqAb3Wmtw?=
 =?us-ascii?Q?UzRbnbO0CIQHL15IuC+n/HFmshaEGHuwi0Me2LlOHvja2JDJPuPNg9/eH/G+?=
 =?us-ascii?Q?ybBCHN/2FyW0hDEcuSBsljmS0YyjjAAjSTzWvjVSmjptwvLWzakGuYVQO5pR?=
 =?us-ascii?Q?Z2PO/XymhJnhJk53Lfq0CXQn2Vxkg5Q2M0xj6B2Mje2LzWsTzT2ILFhmT7+c?=
 =?us-ascii?Q?HhCs55QzErtN0USlw8wtDKsH/hB8Lj3jzZzktC9HaE/4d0kTCQz3/wx46TYa?=
 =?us-ascii?Q?3gDB9wzzU9ICexrT8xCaLqXRNp+vn82Qtnui7+/9UOpJGxNnXIv3HPxFbffN?=
 =?us-ascii?Q?AZLUyPjFBtM+s8vsR2PRczStTXBi1vK0f6xOge+isIF/ZxB/RrCW82RD/OIN?=
 =?us-ascii?Q?jpo8w87t8GChMlAmpxxjKl1SeSQt9CRUD4Nw9tBaIEhEG1iBPe5qR2bRCPUj?=
 =?us-ascii?Q?gDGG8UcM3UCCvYYxV11RIRzgFVStgpFrVtxXXNF2rEL1zBb3D+vbdoVlg3oT?=
 =?us-ascii?Q?fUvjlHYZ/a96d8Im7Sprh0MM+c7+1OF/qpA2dhI3eOmjtURn0opNv84F5/3h?=
 =?us-ascii?Q?E2lrdgnKUpyNw7knECvyWJuKF2LcIK6LNa7dKYTRKmnrDEa19CNYKbh/xsLz?=
 =?us-ascii?Q?A1Pvm1P+bLx8XuTf5Acx70z916cecOIH2eXCFqX/PUp7yQtTX2CYq9i0YiIP?=
 =?us-ascii?Q?4EEV0XKA9Fbm/phQvvAJKOCMn7S5Mk3UiiUtSl9wY50fGgB5f4bhvEBqcnOI?=
 =?us-ascii?Q?LOIG2Isjjp9bfpgH3lmO9Pik25AjdJ+/noy5jjKJfkhqfBPjzeTjd98lp3ot?=
 =?us-ascii?Q?9H5meZuWbXsoUbMmLHwACMC9c8hzF1xYnR/jx/Pr1w/cLpiaebIRfmKNdqXr?=
 =?us-ascii?Q?xOnf4Z/7Sxjg4+NM+//TXohbviB7QKw1km/wcYePq0xjBMrR69H7XjOOxtJI?=
 =?us-ascii?Q?dVDhe9txtLH8jXMFXG4n4NyruWNX3wZbprdYgWfFDHpL2T6XybxZ9PYWXccQ?=
 =?us-ascii?Q?UTwCnkF1MAOAwiuzlA5hfXTE44GRY01OLT+o1Q0aT6aobY8NWHvXexUm+H1w?=
 =?us-ascii?Q?E9typ0/sOxSl3q+wbG49sdhNgA5lbVri2zhjKxjlvF2vPqiedXWTed2kdMxQ?=
 =?us-ascii?Q?PSSvZ6kBQudYLEzH1OZFIxfRnQetcw/tr4gPGNwy6DyoMlej1TJ39surVbiH?=
 =?us-ascii?Q?U7JBPKxPuua7DEgnkBZy3QpFMO/bZQ8ivDsEpn2ildsToxC3fA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IVvtybBsKKAlIw4/VZCYfg3WVOB7KwBHCYHFDtCNDiV5rrmQLYMxSuvzUXkg?=
 =?us-ascii?Q?XwADQM+QYyxwGqDI3wZoIt9hiUyALOQYCEu8346Mz5/0gpjhDMSoj01Pj/0G?=
 =?us-ascii?Q?KUVYUmgDzOT9ig75FG5nunr6W8GyibYEu1oxhFoUOOyiKybWYpwJtEXW/B3A?=
 =?us-ascii?Q?uQzqD82QX2uoqtKaACOKZBdZmrr9ioACMBTwh3nUPrPIgJpZj96bzUyGGSnn?=
 =?us-ascii?Q?PFkx6S/Lmxt+Cr4rc9/lbSr2uOXfXcKONORUV/Q5DAxc2SjB1yRbER7Ea2o0?=
 =?us-ascii?Q?O5R5iYlXkSWdXfPNt2vfTyjfO5PDIuikfoCsVcypWDPoXZUEXTSdqbLYSjT0?=
 =?us-ascii?Q?O0MY5RBXX31uP8+8Ac6MXCYg1vl+SVUcv35pYFmH4Xe70iPkytWQJ8feiZia?=
 =?us-ascii?Q?pehPWY8i3QPKKX4pkVGyygBXXnn2GPI9lr4M65qT3d+vRF9j+Hx3bNlg6LUV?=
 =?us-ascii?Q?FMWLTXK7toF95oHOko3BMNLeGPRrURecJgZPYI+DFn8rCNCpxJ12M2BrmFY0?=
 =?us-ascii?Q?ZejAkWM3T7HF7P6rO3plSgKAQwCsi/9D+Hu4HpjyTsYWdUIQFSIlayy01qo4?=
 =?us-ascii?Q?IpDYzGUgW7yfA/5qZ46jfDtb2kFU5QvT0AfvKNnVj4KFb2YhRZ827uJWl7YV?=
 =?us-ascii?Q?AIvjkiv5i+jDBvQ1MOG9Hp6OEXTsfNk90A0PDAPhnwGuH3/60mncdVG3AHew?=
 =?us-ascii?Q?aiRKg4X55/X5cQd8Z8q8RicAK13u2GVJbZdGDMkTIM09pIJ2uePiEeMKC0zQ?=
 =?us-ascii?Q?cLWsOvaw/KTB55Gi0d5WYw0wDPrn5JhwRUkquMvCZMRwz0LI3bBtFCE/bxHL?=
 =?us-ascii?Q?dE0T4t7IZAAn8wpncBeidOMOaFTjBed09GW92SBDdejedngd8uZqrSuuxmmr?=
 =?us-ascii?Q?r/L+tVdBJbGeZzZR398lnICodWtWo1rZVJtRSg+/u91w8QApT46LaYbLHRef?=
 =?us-ascii?Q?jRgziLSL8Bcg62g4k44jpEFk88lK698wz5tMD+8JmUJ2Mgs/FTAAnSHPDx5d?=
 =?us-ascii?Q?MkQHlrYKGLpTCMLVtUR96JPdpR7bwZSz1qMMN2hh5DesEZd1P+M/VMkOU0K3?=
 =?us-ascii?Q?DOUM3GmQu4g0dbVSVxid9a5S33AZbqUoozkr7CsFZz/1TtrxX0RdMF/CsnQU?=
 =?us-ascii?Q?od+Kysjj+r1ECoFwAtrOtvrYRZnoaP87HHsu/AHBW0VZ44ufkJSo8LYy+RQe?=
 =?us-ascii?Q?5KY3QN1UpTan6ZIQCJxHtzT1FMJN17fzNWe6R+bxtAxQWFFKQrBOBb+w3yVV?=
 =?us-ascii?Q?ytrHw8zAm1RITdOzs6Y0FDxxy4aF/b8nzAPJwvlLetMDvS+FG1MGzcEPvgtm?=
 =?us-ascii?Q?PZ/wUDcGEtJmhKolqYVAad1amXis+YRYUpxQaW92SHzCztNDiufnT34DVIvB?=
 =?us-ascii?Q?y27iQhETs4EwkKSSoFznrA+t4mSBEzxUlqctwm8VoMOXQQ1BZPFnMos4afLq?=
 =?us-ascii?Q?cqVHfGOZB/Xp4VeB++aB1dTIxN5nKSkIZHolCzHHe2XTt2XB8TpBoRH+tSvv?=
 =?us-ascii?Q?MxPHgJemvDodrbOWiH9gbaXVTQWto/oNuVmwXUY2cXYNi1mNmoxxkbDhAzPA?=
 =?us-ascii?Q?87sXjTEFeQ4Q32FLWC0SvdjlmvfYX97jCGLbzpPX+myB7nA1gMxPsrqmrmii?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pP8L0m2mj8CVKBZbhH+mMeMgkBBZXK7VEG178Xho46RSlpDdEVIpMENYaEyC8BGaVQx0t85kuH5ffevdIuJhT6v33X0OVbzWxKghW/d9jt1KUVXikwc9O10GzsTyCYFuB9XWWC4s/FPMxy0p09CNUgnAYi7ADbECXtyZ9WDYC9hpRV9DVqEOnm7pZJv6Dh0HPPYoHhn8AGPWI16s6Pc+63CsnL0zqOUUCJE6ZI+d2b+i4Pu7q0QI9wun0tkovgG3uG9B8TvWAk7XWVzY5wUx+2d3AzjgqH8WYphoclQL7uZULC3Txr8xDm5qGAriuyXzlSq5NcPK0pCosqPDiPOIoQcmFmBTiRXowVXEPiUC8GHpCXpM58ZErbQ0URKBXNdk+JSoAOMcj/7LYwYxQV4CMgEJ5ud20J78baq+UsIWdiVNgQ3UjwboedGoE5twaC/Uzjg4rywxyn7DAb1pLKZKuwFRFx0Gfj+ksEbs6SE0c+iHODYo0vhKySn4AqQ+BuYg/eJeAG1jGO9pY2IEYconRmTcHgFU/IB6aNUKO77sYzoC0iKQk4/PBdMNb8IJ5tM1SKNla2DdmgQa4PYSnM4d2YKX2tMOfhretnOMBn7lEAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108c0bb8-3314-4cf0-c6a2-08ddcadc3704
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 18:02:12.1749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oGXi3UEpSI31hRWtqkB8tYQnZsRtKqummYjiyY81UDpuppwsJMhB+QezgDNZRDyZIgCTbOXJ2EocqkwEqGuvW7PgVFWZMa0glP8M2Q5dH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF5ADB4ADFC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240138
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=6882752c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=k12mo42dw0cNrvHPgu0A:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: Svfiao4_v0DNBvLNVGjdFHXNDE_3uq4E
X-Proofpoint-ORIG-GUID: Svfiao4_v0DNBvLNVGjdFHXNDE_3uq4E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEzOCBTYWx0ZWRfXx1WWj+rvhvjq
 89mnbXcnjbg886TjAZlswodat7hnMIw906moU4zQKCaYhzeDukJj+c1wiF3xjhLF7ed5JFBLpGR
 D7BFEG/Pju1l+LN6MxJkqkMOt35ME//9zIFOGe+henzaKF9zmhDKZVzZ/UPjY+stJLBoS3nFCL6
 UQ+onsJupFXwORLvv/VFgW6f96C3ElmeKsIxQ4j588LCmdmc1YtS+ALiZgoWDg7orLBtwqzAkhz
 XGETHnSXXl9CgLyFOkc7VRqF9de2LWHANCsm4DtXpefELbstGMw9Qh1sQOXC4OiBAK/HLZKnZ4v
 c7kTStocWxFN2jONDy/918C/FJwNX7rMaMVMi3721ZU0d+3/jyvHLljAchA6EmaA9oIeW2wjsb4
 P3i1q/3vEWYnjkYMEeKN+SO4AFRLAWuMLTgyTkL8RIb1xfD39cxR2+B5fkwAFsT/P6HhhwOo
X-Stat-Signature: gqpu543hbex493pffdy59dws7tosuwy3
X-Rspamd-Queue-Id: 244BF40009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753380146-740700
X-HE-Meta: U2FsdGVkX18HO9jfdPHPe6n2j0faAWhbVz2/Uk4KYVWvrbr/KxLcd5kSIJDY+j46anw3EZC0mnCFw2xaM9fphb6T39RMzUQBbpjwE97LqDA+2+uGd8p4PO921p5U/hwA5fj2aykZxA+1/XLgKIWj+3bYNP3FLt6fspG7AGNElUcXTtpCdwX8ISQv4XrWid35FoxT8fBMj+RWtsgGTyCfyYMaz8zoMPoWclDSiUo0TrqbBjveHPYgSBeCFfvoxJbfdiL+RMAgvaByRMqXM8JlYHZpsrjW/7Wef35SoZf5WFUJd6NGv6p2R3BKZW4zLn1BA4vUH6wIGytPGPF6S0DGovhrFhz8EfxuDDrHxl9IRO8+IbXxSxHnazlXDYzuLV9BHfVraVfe4n8u2bg7+LQtiLLzrNKmhyZD6DGqUt89hEfGVkVs/MCisTTwxBQbBdrmoKQaS0jsyX+3eNGOaXSwKIGTTBmK0LdiSJgWYYwbIFYJDUWvnyEDxK79LXjUP6S4YCXpzGRzj2d8UcDXq7Lzkdosrb5l1BBfEQ6OZ1lDLjwrYqm4uKRUHpEY2+T2GYOlv4JVsgA6LwDq3TN7VWrht0FzO1F/V0/0Ct7Byy2j/jNwgkxNLAjpWTkNTMZkdknVU9N36H8a84nJtVpuGhJpPY5FR6DvEgYlU1hkpQ7614acP4WTiSlWh3jkhzBfqeDzgBra4pEN2Ck1Ew9jh95+lrH3C12nq1TstFtATsG8K8eEV9oxGJDF3/HJtZOMJ92NC18TR6FlmQ2sCrbYVWIwNEitxXUHAmskMkimGJKrtAo2F9e+6tlFb46uQtt2KWgQ7Cl90vNZSZ34dt32LmZ2CU708anPXra0mhhHSXWrJFYft7AyJOOW8pEH8Sf/sNy4g44N9dFGziTKIUwAsHQ7eOW7yxrqfJv2cuecm9OGunvstk/7aUQEQ5F9iXIxxATioqDTIZqFSIzdxG9FgwR
 nYAIwfyt
 BL+yyIhuNaQ6ap1+qDxg/DY5AtV+DyHo/xMB3Pm4xRElHXIU5KSdu7NDX6y3ARM5NnSuW/RcaQ+VQ4SHbA7WtR4SeZfqIVIjnO6Q6ZiK2pDVv7LZsPexIoO/3G5Kfu6GNZeJnkY79N5qzwz7RVo6YuNgTC/y38rZvhk9G+Xoc+v8UugyH8imshd7AftRbCwwjQ+vdCda9LserreQZczwxbkOttENzpo3zkaW1BM3WnAoC31kHmTJju7vwcGJ3zDRS+xshHzS8vnicxyn66Hk8DgMpilcFYHp9a2BrGm/paZ3byLwj/Ia6icYKdyAIMolI08dCJLZYqSAkyD7SyThpt/8+w5Vv5bCi+pXUl2wa2IuRhBzijJCIsOGYqOKJRk4hn2L3AM5NMYNc/oM6g0UZea0l51h/FKi+C3VJC38GiJl7uldKE/TDXnTxV5pEQ0WmQo60QuHDw58mNG+lM0tpPSkarIeU/57QeO7OW7VoStD9X9kQK+hTVIMOP5uxHEjy6vDOMt9w9WbYdQIHQtmbDHKGvzftK/3lJGBwVLeaUIxGo6BtUrwjt3l6zLI5gGv3wJrMsQWp0RPfwNwXNAdMWh83Zb0DOxMcGuQZrI+sN98NdCzyzvwTO0irdOUnVVSCSk8CeR1YE8AZ3p574EU+7BEbvQf0ANtASx8xRgIopyol0QvlE3ZvzzaI17pjFQKl9DbMW907nTxPE9hbwETHjcv7BqZGOqxxXK4lr3uGz+LQEcPhidUShf//i7MTYmjTouIeIpdQnqkIsmlyIFYl049eJGZRrLpi1W/fopf4wy7pURnIRi/Fm+eSxInTy5jAwctNF9FuoPFVu3NMRHn1oX2WA5vyFBHpixbj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 06:55:56PM +0100, Lorenzo Stoakes wrote:
> Trying this again as my mail client apparently messed this up:
>
>
> NIT: Please don't capitalise 'Optimize' here.
>
> I think Andrew fixed this for you actually in the repo though :P
>
> On Thu, Jul 24, 2025 at 10:53:00AM +0530, Dev Jain wrote:
> > Use PTE batching to batch process PTEs mapping the same large folio. An
> > improvement is expected due to batching refcount-mapcount manipulation on
> > the folios, and for arm64 which supports contig mappings, the number of
> > TLB flushes is also reduced.
> >
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>

With the concern I raised addressed by David, this LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> > ---
> >  mm/khugepaged.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index a55fb1dcd224..f23e943506bc 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> >  						spinlock_t *ptl,
> >  						struct list_head *compound_pagelist)
> >  {
> > +	unsigned long end = address + HPAGE_PMD_SIZE;
> >  	struct folio *src, *tmp;
> > -	pte_t *_pte;
> >  	pte_t pteval;
> > +	pte_t *_pte;
> > +	unsigned int nr_ptes;
> >
> > -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> > -	     _pte++, address += PAGE_SIZE) {
> > +	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> > +	     address += nr_ptes * PAGE_SIZE) {
> > +		nr_ptes = 1;
> >  		pteval = ptep_get(_pte);
> >  		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> >  			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> > @@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> >  			struct page *src_page = pte_page(pteval);
> >
> >  			src = page_folio(src_page);
> > -			if (!folio_test_large(src))
> > +
> > +			if (folio_test_large(src)) {
> > +				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
> > +
> > +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
> > +			} else {
> >  				release_pte_folio(src);
> > +			}
> > +
> >  			/*
> >  			 * ptl mostly unnecessary, but preempt has to
> >  			 * be disabled to update the per-cpu stats
> >  			 * inside folio_remove_rmap_pte().
> >  			 */
> >  			spin_lock(ptl);
> > -			ptep_clear(vma->vm_mm, address, _pte);
> > -			folio_remove_rmap_pte(src, src_page, vma);
> > +			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
> > +			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
> >  			spin_unlock(ptl);
> > -			free_folio_and_swap_cache(src);
> > +			free_swap_cache(src);
> > +			folio_put_refs(src, nr_ptes);
>
> Hm one thing here though is the free_folio_and_swap_cache() does:
>
>         free_swap_cache(folio);
>         if (!is_huge_zero_folio(folio))
>                 folio_put(folio);
>
> Whereas here you unconditionally reduce the reference count. Might this
> cause issues with the shrinker version of the huge zero folio?
>
> Should this be:
>
>                         if (!is_huge_zero_folio(src))
>                                 folio_put_refs(src, nr_ptes);
>
> Or do we otherwise avoid issues with this?
>
>
> >  		}
> >  	}
> >
> > --
> > 2.30.2
> >
>

