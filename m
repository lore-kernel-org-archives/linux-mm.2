Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E71BCCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB81E8E0106; Tue, 14 Oct 2025 08:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FA78E000D; Tue, 14 Oct 2025 08:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30748E0106; Tue, 14 Oct 2025 08:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B94F8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:25:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D8FE887AC
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:25:20 +0000 (UTC)
X-FDA: 83996640000.17.81E4FA3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCC2EC0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:25:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jK9qdhER;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AtesZve6;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os0m+KtuIw9y7jZV5bM+RM9YTsZkIr+DvNjUG5HH7R8=;
	b=7L3eVrm/XbsXWdzyr6NFAMPlj56VrnOLTIDTEcAm8h0GVBJllF7rPiN1UIV2N6+Km+9hB3
	C1+DiGL4aXJhpoax7iw1+mun3Aw+l8xS/1Owel5/eImmL1mDRJVwDTgtl805BrEpOGNAUz
	i7G9SZOfDlo2LuowdfgBjUhvGyrM348=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jK9qdhER;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AtesZve6;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760444716; a=rsa-sha256;
	cv=pass;
	b=ov+0U8Z2jC/qD/dcz/c9ZdYg7501RnGjsQtuxViogVqgjyq3TIvTKR+cbxkDmWzC5cOnB4
	pBwn0bfhww+zHHPShVHFxfGR3lVSkPAzNUBY4Qv8qzxxgicz1GpVybuTuRMFkVkwBFrylt
	m+3YeCzxIeVnBQ3KMd/H6vmHBNaNw9c=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EB9esq022063;
	Tue, 14 Oct 2025 12:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Os0m+KtuIw9y7jZV5b
	M+RM9YTsZkIr+DvNjUG5HH7R8=; b=jK9qdhERcah2YmZuwobq1E3NIMXS0E5d/u
	tb9IxSiTKk9n7VaNceCDDtJRBRbXldKMJ4WBprQbxk/fskpVyQVqArgWDxVBx/EK
	kRVkGb/dWj0H8+AygIYGMrMk+uQpx/PdsDQHhAEztgl2RnDwLfI/yuqj1CuIwjTv
	nn26Sw4I8W0wPyIT2xNTQgAf2Il3pWSRyEdkRUdoWBJ+EzJ+8eBJK3rVuCHNHJPa
	Okid/HasccNPoo1kOj8RdsqutkGBOcoeqdwAeUnNbPANEed+v/2yU52UVF9dmHNm
	gP7zA9252sGHA94d2kkFrSzCdlA3pQBGVQb+fukd9ZoKDdtJ9HOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdnc478j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:25:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ECIpXH037884;
	Tue, 14 Oct 2025 12:25:10 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpevwuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:25:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rp3HPAut+yDquNfDiw4HyzIo5JjaJq2+myhBAb5GL0WsUYcenbgyPDs5q4u6nyAD8v2wk7j6S8zguG12C/1n9MgeQH0Qg5YSGc3LGpUP5x7Sz0P7xwK80yNDU2JJNoOhL+ULHe/NuK2tRjia3rJ8C5vjVsXv1sJMYv/BGH2vvn/P2MLwV32fMd6f/gVw4qwaG23dWktGoeV+KuKbXdmN4P9BgxHEt3DsSuWyB0TGjaJBTRkwUTGi2jbhb9WIqdcUR7BRoXNpydrcdFHWY2TQnkTFbbq+xauYMyWj1i4g/ZS+SF4RkAeoLxzEDqvrmkiB5JNYsUeCBkDt1SltTjj8pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Os0m+KtuIw9y7jZV5bM+RM9YTsZkIr+DvNjUG5HH7R8=;
 b=KeFQPjzedGe390j6C6niGpuhfQeuSMS3wmcyA2fPcdB3xFgqclF+bvPkjCe3CohZyrvTHpE4eRartQPP4smmjfwLVJmdzUR3W9bOTbk/yhvvT6Q1nXM0Ih8N7EcLsk94sRcJEXW6/2iCYa5gT/fdbT6V8dk2AaS1fqYeAMSvwqb99xorNUlW0GkSRuKB/qCXDJGMqpkjch6Ymx3s4qgSC1bxOmPpPhYIitGWPTfqwbTzhDGEBfBU+LclSwdsljLkncS+fx2yrUZVOdbxn5Ja82G4W8TyLT1eD6OCd9dLwgmwJyg4G/dWvt+Qst9q77Qp6FTyUJ+QjUzqFYFSFtT/5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Os0m+KtuIw9y7jZV5bM+RM9YTsZkIr+DvNjUG5HH7R8=;
 b=AtesZve6Pf15x4iFIqVuskNazFQ9gAgoR3VOPHGpZ2qwXt33xm3zQJovtd1eq9vMIr+4UBYLXpGLP3nMJ6PYhSfSau8gpVOEmchYwQmgytyDCj87wrn7ij+9UbVw2WTApSIUxW83aI2ZBc1WVo+W5tmAG0Oh5ytCCm0YMy6Hcjc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7795.namprd10.prod.outlook.com (2603:10b6:408:1b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 12:25:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 12:25:05 +0000
Date: Tue, 14 Oct 2025 13:25:03 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, richard.weiyang@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 2/3] mm/khugepaged: use VM_WARN_ON_FOLIO
 instead of VM_BUG_ON_FOLIO for non-anon folios
Message-ID: <7156dc1a-9de8-41b7-84c6-3795e56be664@lucifer.local>
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008043748.45554-3-lance.yang@linux.dev>
X-ClientProxiedBy: LO4P123CA0669.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 596f4111-8a7c-4ec0-dd4a-08de0b1cb4e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bznmCux0i4CnNwJVYg5UWHNF74gEKTd4xwZLGJsvflmezdi4SZWBMeuP6cYP?=
 =?us-ascii?Q?ZgoXL4F54r/F8dU/esjjYxjsLTcm+FvVJX5IUMuNzvs5X0GUQAo60FDE8IZo?=
 =?us-ascii?Q?YyU2jBfCzLZb0jTAJoaUtdLaC6iAxqfZyVeE1K4wQu5cl3HAIu8nS/GJtHJn?=
 =?us-ascii?Q?MHA8epoo4ovBGcbfb9BIlyt/Slk2o8UNzHblwQR/j+JOXPhMxHfDm2agKI57?=
 =?us-ascii?Q?r1pPzHGPNLIGUFNaD637drSFp6RwiN+IHhaEMc3bYRT6wrb9u5JrNpaDMIxq?=
 =?us-ascii?Q?QH5zSi1x+MVDR6MAsyAqAeGkj6ErzhvtHkRvzd3tLHHXzt/bLFwdxChNsFqd?=
 =?us-ascii?Q?fO2PmPfBfrfJYh8RlIxnZco7iEqhVtHrHY4xdd2/YcMQk+mKv8xT9hMDpwwl?=
 =?us-ascii?Q?3iThzt6nsNHgOwT2IAh3w6qd/vSF4DSn5LCRx6av+svc851BVhC0wC5AddBL?=
 =?us-ascii?Q?NTJAeFXTBt8E9vW3HbtHkaRZMFzTUmS+qSz2kh44T1e8tKZaRayntjl9P7C2?=
 =?us-ascii?Q?4aXnsyIidlkd+NL3rYVW8JoDVM/956f0jL8Zt9lsewCMOFMZiJvqI75ky5cZ?=
 =?us-ascii?Q?eTAbv+tjKtYgVDD5lCW1Fb06kJOBnHaB9CPrQ0n7mbuCIJgVQbGkvGLgkKtV?=
 =?us-ascii?Q?id4Ew1k830q6rqm5U8TpEH2l03DqzbBk8tfJi7WbRmnudWPEFmGv6wWkdRRd?=
 =?us-ascii?Q?iCMp1z4rNCwvyX2vRWZbBmYzdpAZI+0b1ugpQw00YEsRJ0GRJAcPAzkGjiVS?=
 =?us-ascii?Q?NfSr1BHyTYfi2hx4tTdHK5UskSkStMK+r5BIrDLbQywcPms7hWb5gZESpC8Z?=
 =?us-ascii?Q?0DfMa8pTsadBkqF5pibZsrHWiFrIkoPIHG6sUfzVJKzPOyEAMfzj+jSvIDwi?=
 =?us-ascii?Q?ZZHhyIhPbrY3lbZtiHD528ZOQztP6F7c4+ZffA1ynCDUszZ+BDTBv4M1qMdX?=
 =?us-ascii?Q?M4fVLOmt4D2NMxO37IXZyYG37Q0RHtFaCjHwSoa4NxQ1r/JtSuW0zTbOsedR?=
 =?us-ascii?Q?95cMwlMhbnhPxhhr9Dxctzk/oEAxN194PZ8E5E6eNTJpu1aYr1EFsc/rLjOk?=
 =?us-ascii?Q?OdNl1Ui9Jk/cpfivBDrCmGSvZdElsr3jn4LWFU2yj5IKdkTZ1eZiUZnbSWGw?=
 =?us-ascii?Q?hlNg7MVDV/5iqNAKlM18DTyrwBXHKOu840eJhqWi4k//IhjnKcnH02SLWGfx?=
 =?us-ascii?Q?9pRP8AyeJP086ixEOY8m4SK3WZi/vHcRo1tqG5V/XjRp0mNLfYRkjpPprKKr?=
 =?us-ascii?Q?PseaiW8PXxisWBS92mpJTfmxW+y81SZRGRY0V+oT8AoAHs3PyILEHur5thaL?=
 =?us-ascii?Q?wXO1kLj+RUHVd50aiykYPlnZyByJVRrWbfME2gknz7NADfsdC9+IwcG71mq9?=
 =?us-ascii?Q?mng+KNf1kJ6SfgdSs5qEg5NRSqC0fw5NThN22p8LFa8XcWLh6wtlY6CFaB68?=
 =?us-ascii?Q?SwLIyzZ2ePpRvub5enGq14f4FUuUgyV6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JjquWBcFrYTjav4r/2R7ZuJGY4XhPPdly1mko9GbGrxiiIhSLONGtPkTc67z?=
 =?us-ascii?Q?xSxa1lYeQC2dFwgEzkDuptLK0N+eIRpwuzt+TBk6448jAHP9NvGn9M93BJn1?=
 =?us-ascii?Q?3D4zA5cIQyASYe5ll9q2a/vJVIwqVsTDbTMN22FcOZXdp3InQIEAsL0lvW4g?=
 =?us-ascii?Q?NVmjq/ZEyBsFW/rCEQuGWWP42V8SFUTlDHFYMNTN2V1QZVuuQyfGLGnkIHsy?=
 =?us-ascii?Q?WIBLG9mfxxvaM02KHHjggzArVAWaelP+iKHn6KHEcwRhFXxW3ARwquPiitLs?=
 =?us-ascii?Q?fYakmXm1sIMYlVy438q9/Ke9Yc5PYb87Y7q4O1qlt4XcHQPPuFBf5hf9WhYD?=
 =?us-ascii?Q?j7gIDqJBBx9UX0ciBQ44t5gnLCuLK/FuQ7datZPhGwGOMqhRa7lMvumkE0Mj?=
 =?us-ascii?Q?uMW+bvAQzCaPCZRnQ+l7FfBfjcnxaidHAfp5bepQ4TLv3pan2p1h7qComF+8?=
 =?us-ascii?Q?EhqOSRtzsvdotteiOu+FGrkOvKhp/wX+tcN1EBgZLiYFzYmyThiWQl63c2U/?=
 =?us-ascii?Q?8Q7PfQS2YLhrGp2BgcLGwHMaJkp8hvcc3OBNqmLRy7IJ4ayeyOiO6eXUzerd?=
 =?us-ascii?Q?vD4hsniXymuO+1qrEDAmSh+2U3dvmEDBbBEbF65BzMHoRR1oXxuQ/BfaW2Z/?=
 =?us-ascii?Q?WtwmRqCLwXHSJlF6SXojPuq3SWvgb2RWyg4vFJn9PfBWupBRX9WB1reVqSgj?=
 =?us-ascii?Q?TejccFLAyeFmKDvJrOwxaKhKuLfwVnPtEgQUqkDSIkiNg3aa6i8Vzxqn4e8e?=
 =?us-ascii?Q?pHN2zGAqD0WljcoAHOuQyZJIEBD2gceJ+hFQo34H4up//3XJG4AFk1nQ1Y/c?=
 =?us-ascii?Q?DTrer98f0ak/9Nw9+wL8gTrHWZFgrB09uIKud+e3kyifG3g0yn0Kn9bEj4m/?=
 =?us-ascii?Q?LEGDKnOnLytWVg4BToWov5iflGFMmdojEMhA5zibRdF48YhwMpFC+WpzOD7C?=
 =?us-ascii?Q?gXHftT4VoQGk2hj0moO2jzyiuyfq2FO/UZkrs2ZxqR1jDQRuTZkSuugE0gT4?=
 =?us-ascii?Q?Z4xF6xD9bZ5Dfq1jktq9o+j3lLwF3OCKi+MZo7jPHoNe/7DQo8w6gCyOyhuh?=
 =?us-ascii?Q?mUhe33Wox/5mjYhsFVNwIsLefj+Pa8/yBR9QJ1wEHL2BEsPT0SwGx1l+4huL?=
 =?us-ascii?Q?aqgK6VUx4eYT52sweQJ2bSn4Lu9D0Z+TXm3Op8B4/teEcFZ0XY4OTCWQDTE+?=
 =?us-ascii?Q?4MaXtLSuzc+98K1X4dFyMREm+3DAx7Rw6uFcDCI2bVTwOsKVYmHmp3Yj0D+5?=
 =?us-ascii?Q?595Mzy9v2IYpZONdK3lZX1uAo7SlTXVkSnEeQRmR3O7DcYquIk8pWm5a21l9?=
 =?us-ascii?Q?Hllr3PcRUjVw3XslWOCv3G+186GNtKnqkc7KW2V8LCBgPaiLXgSp2MXfaBrH?=
 =?us-ascii?Q?HX6jmN9xyI3ExZpczyOnFTskAK9NDdziwW33N1eE13MYx1uu8UKs5/qwin8O?=
 =?us-ascii?Q?Zv13lBwGEwUMh1CngH7hsmEI+7So1IwHIOBw4/FzbJQdqS3+X0rSebW6T+yR?=
 =?us-ascii?Q?vCV+T+SXOMN/wXQHMaNVmTs3/kCeOoGBPMXxSfALT9h3Fj+EKAnrm70IR2XJ?=
 =?us-ascii?Q?HupMv9GxbLLoZeS7Hw9pxfwyQB9VVODQFe+BA2Yi8yqah2y7YMKcDo8KKyNO?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IAURxTXMKR2g+87sFrRho9tmaIYSdYRIFWBZwAdsyuWzmRIkNB8892DxkHxut/h2GglJ4bgjKqUWaBJ2v6GXdnq64ENfnGLw0ikjtqWPZgcBVxAsYIaf/oYJV4LiZ/KcK/Cm2g+yi8nw9puumfUkOD4U5WdvzO+UT1s3lBf28D1kwXv4gpjrWqHiBK2MrKuUGDTgJAM9RXtKaO4IdElDoCW6WL33A3QxoGxhDEYRg2VKVr6UAoBAcCkiHE/KAplsQGme832xi42k0tRVHfTH9av38ovmfziVFnqVIctSra8yqdO8DgCDuCllBIvpXLmyQuS9W5Fdbhg0FmQ49cyvra6xJk2Nby5vobfn3bJqtyZ1ogkXGOUvrak/Evwj/OvvtSzH9dUWy8YA2V7omWiVuvBWttJlUNfNUsomIiJO89XrIPdIjNl3QCZyxDzhw+FB1KL9uFO66Q+F1WtzI/jny9JZDnC//Q9GJitOP5bN3beNMI8JnNXo2PFzAJ+PS8/BNe5HM5utw70fn9akJQAjHARHsq70NO7iBTnuzwTYayneBMIy0C1C8umPjz3Qrf/wsAmj2v+Y7AfuiO+1MFWdBHnanu+VlID4kyRUPRz+M4w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 596f4111-8a7c-4ec0-dd4a-08de0b1cb4e5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 12:25:05.5778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XpuC3FuHHr6JGKhpCAofslBgz2H/OeCXBLQnowGrStoxt38Pock+7yA+O8covtAHXKm7vwsROZw1YrL70zuj1jJIBjALXIShvIIU42n8w7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX5Hh+7Di+3C2I
 kJa2QcMe8hxwhat0zvI/YrgJlwQdAGXp6tUaCVbygtAYqD6vQiwn/LppVQO4IKvOcyP/T9yXt2q
 fHfu+/yggqasxQd/e9jnPdnzkmMV8Wn/M4OB5pD+Wm3SsI6gD7m/B2iwJE5YbBLRnMbO39ttbmn
 6sJ0RX0a2howCiGN2eJnW6DmbUA6bfS3/k9v1iVOVlx00bHRwQRD/TvujVM7DTqLgMRRxeFsEJ1
 SahpxgjxdqBqfdyOw5xukbz8tLnTDvMEAQdFoIbzaxrxVOrCTdDe5/OhqIH5jLwGsHmS5/ARU4B
 zUPYdKFCLSuNo4wIugdsEF/9abkqOZZxPZ0/CJG9yZtfwVRkjZKWyHBlIGf4arP0qq1XhkuK/aV
 So9uV+CYjq8YhcgYh4c+kpcfRbFqFQ+Mile1mGQWozt2N69XRdY=
X-Proofpoint-GUID: tXVEy7WZMrlADOdLI_vUZRq_m92EVquH
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68ee4127 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7CQSdrXTAAAA:8 a=Ikd4Dj_1AAAA:8 a=pGLkceISAAAA:8 a=M9hiLbmYYt_0MYyZbaQA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: tXVEy7WZMrlADOdLI_vUZRq_m92EVquH
X-Rspam-User: 
X-Rspamd-Queue-Id: BCC2EC0002
X-Rspamd-Server: rspam03
X-Stat-Signature: 4tg9pqjoz4quwtheb9b1et63d8665txk
X-HE-Tag: 1760444716-402180
X-HE-Meta: U2FsdGVkX1/3qlcqfbij0uzkLpELAr8yjUdC0wl+/nz3K65J/GikdVFZafcIOlZGd2oKtUWcCQtZ99DSPRW8ucr574d2/Hf69peXzVpPfvRS8V/G5FusIYWsvwUjmlSio9QeHdtq0nYQRPXfQdWmGdFgpa+7u6fYTTBzkLAYJnIozsZCU+avMbAZqGNprIZOonQboqXDXUJv0yFmx5abTAhktWJhUjwfQJRICgt6SK+kVW8CaxHUYoKp6UFC95jjdkmPoofuj+PBnvcyQXMlMPey63A8hrHj3eYIgFx6WRopN99RZii8TumwOBiWaCOErfQ9R8jp/OR2YzSuMbz8mfU51KWHU+KXNOXidoRun6yon15HEyVyD1HPu6k97cTCCbOopK+WmgU8V+Pcrs/DcLQdd2O2UxTCAdA2YympQwz92PUlsd6Ua6s/5Wo6B7+11W7L1dSeotnyXbLklGlwfh/WZhmPTaZn8zmP3a36yi/zZIdVFMjZQ1TU0NEYHSizcEjeWFk8UdY4tUvFNPUMeGRXbdBGl4jRBgInaTAWrvGFS14by56x0mH+N8DcLK1eodkJe4K4NqNheej075lC7O5QPKj6VnB+EJFzTPOwa/deEZZvsn9EEWPMb2tp11Kz5zs+P256vOW7hQZmFSsEAr1T+U22tPQxlnEiMOcL0FNmZEftIKrCG5ti2nkyCENr3Sqo95Nx4OMhnt8K9Y6LjxEd5Y1TbQWMeRkpTvhXDwZMdwwnWFhxrJ7uPm14sTjIYbkUUGPE7ek+p+4T3czF9dqin1TBgpj4U5r0dLYI5e7YUOZPbL/lyldx24kmpwXlfdJlc5T0Obo+ExrF79D9UHZv0sdFM2G011svJ1xDe9KOsJhPPmxIWdZx6lEcWlrdYqt2v5fl+wsw6EqbqcwzSOMcjjWzKpt1xYnIZWoz1/PCF1gotnEX8DxO+YGHWqmtahm6eNviB3BcfacQbu1
 GyZwTvyP
 yRM4X2z0SuNCek672kK9Q290Y61wpjiz10q9+alT0X2W2MFUOrT9uz0nmucQ2U1I4hvHgIWeJmv7lEWYW7RdFyV5vnAelgBqqAcDmkRagZMs4c+5KvnPv5y16UsX2Kyz6bA1WXCtUkT035sQAL3czINUJdeL15YnoHoo+XRBCzVivPuysuozMJHMk7I6aVq5qnSMSdgGU5sHOj+tAFnsMjplNiQxTC2d7wsxe9AkE/i99NGTzMKrpxdDJV0XAuaH2j3dNpubnlOLV1xzMq1TYg7FOU+YRWtycjnl3d2NjcPHPNxjgw7YBewqZ79bB2YSH7E7TGuKdFpJl0lG5mo2Hv121qA23Z4nafDMv+0SGNcVlJcbzRoWOcAVdPzHCGOlngiKy0chzwxq9XJn6kObPlHQbDYD/98yAC9gLTlMecF6dIr1fVQ9v1ZXzOMXUR9KbT5766XMWEUPU2KSxwlTO9LcBztI2id0z0VVIlzMRaFMk8VMuPAjmmI83rlplCWZ9Mk/wQ296NM+EbQADprKv2O0xeVOe1Qc41XSmrx432Tp5bV56XfS1xT7nNyaQeSbwdiCE9xzKgM2X8tVW+zeSjrOfBmjE4DpKHROmrFcKsgcSMFUOld54JDD8KmAtNd0GVThYiksBqPXCy78rXWCwuxLQw9j+H4NUW1fVOq4ZtPMYU2Qiyg0GbOMF2qOL/ewlwTzFSOgXfyLPDWqkbYAKOU/JPpc/ftUGh2zb5Lj5EQKBj9gWqliobRCjP/1YFkQ+3LIqo6Cq87Rgo2GfuZmHHFXmT3OqrD0HMUy2xt0DU2julZAGrogFtLs3911ml5uBQIvv4j7dSmROz3EAfvl7WM91Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:37:47PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As Zi pointed out, we should avoid crashing the kernel for conditions
> that can be handled gracefully. Encountering a non-anonymous folio in an
> anonymous VMA is a bug, but a warning is sufficient.
>
> This patch changes the VM_BUG_ON_FOLIO(!folio_test_anon(folio)) to a
> VM_WARN_ON_FOLIO() in both __collapse_huge_page_isolate() and
> hpage_collapse_scan_pmd(), and then aborts the scan with SCAN_PAGE_ANON.

Well no, in hpage_collapse_scan_pmd() there is no warning at all.

>
> Making more of the scanning logic common between hpage_collapse_scan_pmd()
> and __collapse_huge_page_isolate(), as suggested by Dev.

I mean I guess it's fine but I'm not sure it's really necessary to give a
blow-by-blow of who suggested what in the actual commit message :) This
isn't really useful information for somebody looking at this code in the
future.

>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e3e27223137a..b5c0295c3414 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -573,7 +573,11 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		}
>
>  		folio = page_folio(page);
> -		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> +		if (!folio_test_anon(folio)) {
> +			VM_WARN_ON_FOLIO(true, folio);
> +			result = SCAN_PAGE_ANON;
> +			goto out;

Hmm this is iffy I'm not sure I agree with Zi here - the purpose of
VM_WARN_ON() etc. is for things that programmatically _should not
happen_.

Now every single time we run this code we're doing this check.

AND it implies that it is an actual possiblity, at run time, for this to be
the case.

I really don't like this.

Also if it's a runtime check this should be a WARN_ON_ONCE() not a
VM_WARN_ON_ONCE(). Of course you lose the folio output then. So this code
is very confused.

In general I don't think we should be doing this at all, rather we should
just convert the VM_BUG_ON_FOLIO() to a VM_WARN_ON_FOLIO().


> +		}
>
>  		/* See hpage_collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
> @@ -1340,6 +1344,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		folio = page_folio(page);
>
>  		if (!folio_test_anon(folio)) {
> +			VM_WARN_ON_FOLIO(true, folio);

Err, what? This is a condition that should never, ever happen to the point
that we warn on it?

This surely is a condition that we expect to happen sometimes otherwise we
wouldn't do this no?

Either way the comments above still apply. Also VM_WARN_ON_FOLIO(true, ...)
is kinda gross... if this is an actual pattern that exists, VM_WARN_FOLIO()
would be preferable.

>  			result = SCAN_PAGE_ANON;
>  			goto out_unmap;
>  		}
> --
> 2.49.0
>

