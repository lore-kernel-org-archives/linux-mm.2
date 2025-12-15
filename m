Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8CCFD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BD56B0006; Mon, 15 Dec 2025 05:38:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D976B0007; Mon, 15 Dec 2025 05:38:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16C86B0008; Mon, 15 Dec 2025 05:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE6DE6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:37:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82EE3BE6AE
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:37:59 +0000 (UTC)
X-FDA: 84221355078.13.74646BE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 43B3240002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:37:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZTWuuntY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YYSLLDyQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765795076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjGXAGNZXPFQ+DCoZTaCxJwI2GSDEaZymHgUddSIix8=;
	b=11LwhprEHcF1cgh1DMEtSj+ZvchhCDdLQxFCKYkvLd0MvIjWHt8vEz5GatW61oVJqRU8jk
	FsPZKfJT8exdjgmu+DiZPLzTn96SuWi/SygVvM5UaNZnwzxH8Tk7ULighQPy3N6jfKosjm
	bUIsJP8ckpQKIxi7c+FGgd0vlnsWRLU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZTWuuntY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YYSLLDyQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765795076; a=rsa-sha256;
	cv=pass;
	b=67cEzBqvqwZlQ+JUik8buOI512KIT6xma25SKLmgNrZqFatuTvtef4vXmdlo2aWzkwx4kq
	C4bjxT6hK/VFOP3racQMM++7zmTbIGAO8VQhtpT9jPjVfpUYTIuNJx7ayNJkXw9f5qfyuq
	uEeAy/AkNdcZ5aqxVbTrHmedajrbAMo=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BF9uspf1859685;
	Mon, 15 Dec 2025 10:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mjGXAGNZXPFQ+DCoZT
	aCxJwI2GSDEaZymHgUddSIix8=; b=ZTWuuntYJ/Df1ggwa+tS9yz5lnc+EKIgC0
	Q9ARDoXL4IAJfEtx5hiQbhVRot7ytnND4nKQ3KxgU8/l/wojJVDDKAVM1zVdGWP+
	rH55xM/k4dyz9bKAu3N41X2VI+95jhIRfffOIScRlOKj+OTwXySM+mg55Piw/H9L
	P60Nftc8SVZepDSWG4c2uAzBKyeKruFIWOJTrxY4CoYoThq3lf9dy+IH5/19rOXE
	ZkL61t1HhSJTFjIHcpu8n/N7wc/RAby9uqA05djjV/dl6y2DBzBdydw8m+al+Fwl
	xZL+vWJNF4R8HuCR0q+94+9CcItCS1BWExxadBGIBpK1VRhtBxoQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja1sgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 10:37:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BF93KnE024791;
	Mon, 15 Dec 2025 10:37:48 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk8s52s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 10:37:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XczUzaoRADYxEjhidikvkZCTgsoegOLwKZwEfbeJENF6x5RMYTa3irkLZ30INjUrUbEtI/c7G8FieFTQUhF0STZYkg+yLJWjClASyiNiE57WOv1Uu1xAuCoyaqDpf63pb9g9oDQIYpkk+W49BFQW42cHT4tsk8rdbwkBbNrDRLuQ/vaQHPcKrMLZBzNHskqdbjPM3OuXK+DsfABDb4/AwQSyGcuxtpo0MKqxb/PcpUOGAprHfbaF0tWafUe/BkrkQXbITMjDrIkdSifB0fkhdeDqTlbn09ZXbyYBQghR/3PX9O9ZblqUcn8ToOvS9KLPngeIrL5ndcFIrpz+pkTtsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjGXAGNZXPFQ+DCoZTaCxJwI2GSDEaZymHgUddSIix8=;
 b=x8wefpqxO0Yv9cCI4qiU02PtdF3lqs3vKIEHhLxz5OFG28kcRFKL0/XKHheO5N8X8zHMJO7FDsYVYdcWSkojFup2Hbe8ekK3ku/xXV3vOawteuOUZkZ68EV8qzAWiD/K3eItllfFxBFBUubX6LAX5pH2wzJeHm7Tbio0w302F9LyP917fdVGD4xr+v+QDf6MlyaZ1v0wlOhFRA0LcYeWFxcSKcPKyCw/PL6G4XwQfoWG+F+DMssTNHltnkjnSa2UEHeYthKaoVEKkY0hq1kiHI10IAhp5BVtbH3ukbxUiI594QufF1ERVIOJ3NCQKp08zIjKNaMdBs+0qRmq15io9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjGXAGNZXPFQ+DCoZTaCxJwI2GSDEaZymHgUddSIix8=;
 b=YYSLLDyQqfRYIIFnMxZmV54DDGFNY1JpiOeywHtKJr3BYLDSJ7+kPSdzbUKIk60UWJb2SM4nyHNx6q90mQO7yILcWE0esfyia+gVxrm+Btn6c1elp+1niM85Bku47q33Kx1/lQyzmokjEN8peP9cjXTzdgIg6GtIB4oiO0ewE1c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6097.namprd10.prod.outlook.com (2603:10b6:208:3ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 10:37:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 10:37:45 +0000
Date: Mon, 15 Dec 2025 10:37:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anshuman Khandual <anshuman.khandual@arm.com>,
        Gavin Shan <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
Message-ID: <5daa9569-a3a3-40ad-86d4-ad47080fa5aa@lucifer.local>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
 <20251211081117.1126521-3-samuel.holland@sifive.com>
 <1b7e682e-86a4-4573-b423-65f9755f71ea@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b7e682e-86a4-4573-b423-65f9755f71ea@arm.com>
X-ClientProxiedBy: MM0P280CA0102.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: fd20c4b2-4b3f-43f0-a3ab-08de3bc5fbf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RwXBFlimX5EHYy6h26nw2hnlFqFh+0qzQLH4xJl71SB1Ezc7MbMhXOsrooV4?=
 =?us-ascii?Q?2Twcm22RP9VMBCcBomHK8vJpI1ipBzsBQiUJIMWxTCWlwl8SvxRDUfHQTZY1?=
 =?us-ascii?Q?46RpFuvSOSgKzYl2aPwey75sVDa3icg8m1OBJe4ufTX2DeWqZBOXMCRrCsE6?=
 =?us-ascii?Q?QYlpHlinorllR8jtvLrlw1ZPgPpanJKasAzPzdo6QNHHzPdua91QnuSTbuUH?=
 =?us-ascii?Q?o7Bts9p1pSx3md6jdBekfRn4Y4W/YwLAVT5ZoyZe3dnTDwxKM0U/zfi7MgQc?=
 =?us-ascii?Q?rtsOuqf0eMO63011Gu94T6+2lDHrbFmlpp+Ez56eMEhuKeZKr78TVh4ebSgW?=
 =?us-ascii?Q?Q1P5ExUhhi1P9eDkkgbWx3tdY2AogxzTxmSzB2x25Lj1lxPF2E/Cd4GweQuv?=
 =?us-ascii?Q?NaIFGhfu62IOy1GYTg+5o8j36Vl4Ch0aHVN985gcY7XUlUX5ocfhfECxB0Sf?=
 =?us-ascii?Q?ov4MVSEv38exJvMBsuM1aLc5MFE3nBdNaLKwLOS4Nxz4kl/n6os0HNKWaugl?=
 =?us-ascii?Q?MwJ27cHjdlkYxI9ep3GWCVTlOmeOWWDEVcWor27Aoq6jEW365weu9hbfUhUl?=
 =?us-ascii?Q?UJs/bxaHny14zyRJJGhZBj8d8qbIfdQ2Eos35BK/H/fAN4qUHDW3NYZi6ASC?=
 =?us-ascii?Q?ZHhLimo4qhpMuNew35svLbQ8tIy8sY3RrXvrc8i9OlyITlSPxxZmFsbJwwR6?=
 =?us-ascii?Q?WgpR7GxJEgA44ozmubZtWiEwVoLzjSqqFY7FBrLo/di4K9JRDVtF4mvh9ZlG?=
 =?us-ascii?Q?R0iJDWfRYMig7EIYsyqtgWrI9Whdo8Druom+UpEAaChqlgNQH11THUUFuTZC?=
 =?us-ascii?Q?9A6/X0j/rUIKbhfGv4CLYbdYwjYHEuLlKsMV8u/g6JSxqoU1ZAqNsipJ73sL?=
 =?us-ascii?Q?pljTemjVrwbxyGH6USZCqT0TiCpmnTaxydfUghpGue/8E1KZJFOiMXia+8HU?=
 =?us-ascii?Q?7Xwht9ofmlho+QtZcjNhjmL3E77eRaN2A23yJ9X5u0IJnayygVwnjIJwZuPV?=
 =?us-ascii?Q?4OTvoOamxpM8bj5NPhEgUVb8m9jGXkFfPJ9aMKZlhC4kASKXxp8qQ2smadRg?=
 =?us-ascii?Q?g8oE1FrRAdopGhnAoAzktAQmG2YsAODwQWlY+Ao+rX5a3H+qm0CMM1dntQbx?=
 =?us-ascii?Q?hLJwX51pwSs8IWfTiwiNCr9dwT9itjiOLZIVs+Qg5zgniMEQNK2ANLAugRBy?=
 =?us-ascii?Q?oSNkfTXzVCmFmukNHLkNReIa13bzdkY4/Yzfkr8SGNy22FQfuHEMHE+TbIuA?=
 =?us-ascii?Q?LpxDmZBL0MbJTNft9up2sWwVfJzmNCmCEbcptb8QFGoKwjLJ100wI1IXxa3w?=
 =?us-ascii?Q?RTsIDmYFrdJFJcG831qkuW9fVy3ehVWNYspxOVyCPyIgNJLIvan1/S4nKYZS?=
 =?us-ascii?Q?qXOHbKfa5jZWS4NLzcp9LvdC1pBxuztrwfZodjGdMnDr47BGgYH5uVrO748F?=
 =?us-ascii?Q?ftE4uX99jRWpsFfdgUndbVG6SHmMelKimT7AgNe88wW3kbT3jtJ21Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nua5+PI+s3zdyIX33EcEnBBVc4ep0n3rzggbKX47GvHa7QdM1Ia/hKBJSB1c?=
 =?us-ascii?Q?2w544XzOrrFuYi9/WTdjhfCMuaFgb6qjMO/MlCYr9R2+C31xhO26ErH9VrUP?=
 =?us-ascii?Q?vZtn1jHpJg0VfFYTuMKmFd6pD13SAU8EyPCuG4t9hnj8NtIJiH5Q/wOZjjh8?=
 =?us-ascii?Q?r8Bh7VQY2u+MVP/oUolXVV1+JxaiB1oMYTBG5tb3xjw5snWt/070c06C7vlY?=
 =?us-ascii?Q?pFtF1NVFkA26t/wC8bILmOYSbJe/wZT8rw+jIBPGJFNuK+a75eDrGB+PswPQ?=
 =?us-ascii?Q?3esnv6vbuiOiOSAQrNrjP1Ybd4rVakGtOixL3yO+fHDYRJf7mzJ+6wuulxHY?=
 =?us-ascii?Q?7gzkbA3lcdpZ+yx/nztd8NA4W3/B+YLU/xs0nqwe5jBFcb2ayioawOqdlMUF?=
 =?us-ascii?Q?fvoINA/sKP71mh/+Pq+USUqaHZvaV+x+Wpkufo5ALvmiqkQi6zJAnCd6/Q7C?=
 =?us-ascii?Q?KRbQhLigjH6MOxRBn1RpVVJtiIl5GDWkodCO5K0ks4u/yXhkoVXvfcOKwxR8?=
 =?us-ascii?Q?mta1PMHnF2OaiR559Bm7Vc0kedv9IGeArfYZcXxtju0J7Xm9r/7O+hugmgxH?=
 =?us-ascii?Q?dRPaQp4U3+s5TYD0NjAAdPy6PiK2gAVx1O0pB+e+rO6AOupZwv0qCqVVnJnZ?=
 =?us-ascii?Q?xTAxGDeueJ4MF2g4u31OXtO/gdWT8VdYVfkt9BO2ph9lncLGbnDl2InPE+wH?=
 =?us-ascii?Q?uq+R1JntPNikaSmi0/x1sIuXRAJbh438mnNNvrF2XzNQKM2vSojnYZCi+/9N?=
 =?us-ascii?Q?YKxHcCFKS9CdEikCRIN3qI4gBLwqjaDnFEpbFqB11V0ExFvB8QL+bf/7e1dN?=
 =?us-ascii?Q?/Ywhy3b0TpWswHHbQ/plZPuW0mW6YP9/0xJ3CLSVXPtnpB0qRJl1WLnMxCmA?=
 =?us-ascii?Q?L/ZkQRIiajmQ9OHQZoM9nA2YJYlSF8RD/2J7CvnTpgXOJOZjDTUzMsIXVypJ?=
 =?us-ascii?Q?uC+ekoFbZGY2/Y9btjA0RC4Qif62s8ODYrnSeYJNxAiDqzcJy/42Sk3fwaCZ?=
 =?us-ascii?Q?gu0+YRshPD+J5H7jH+xmJRI/KVhOnD3XJaFqoPmthvdTAxo9mOfT8wx8UsFR?=
 =?us-ascii?Q?Y+dS4QadSrL9UzQfIdJT5mMsXAuko2mEtL30pDwxZ5FlcRZTozMKL6ojaOsj?=
 =?us-ascii?Q?biqLPKKAuQFQYRVmdvk4opRZreB7TOxxdtnmjmVKG1lUuM0DhCXx1B9b6H8C?=
 =?us-ascii?Q?pFEj34ZVtxjfktA66A2k1KXfKWdsgSII10qV4tXQD+uKhHrlBc6ggikSxnoq?=
 =?us-ascii?Q?efL8wK1RY/ut/1Tr4q4MU1GTKkC9Ge9d2PiASzRDBtg8Q6Ki9jNLmUgNyUBY?=
 =?us-ascii?Q?dRudkvsd02of8scBbY2/vn7NedAaQYhA9QMeoC3NHk+WfSq7vOw0pVkz0dE+?=
 =?us-ascii?Q?cnE4+2FSYB6a2r9HQmN35WhkkF7kp0gAuFUP3mFlsf4Gs85ntjal3FCwjHZJ?=
 =?us-ascii?Q?yYNIyvzq2OWI1G1d2XINhik1XVsUVbbku7eVaDpb++SG+4/5x4xCzXK3c2tt?=
 =?us-ascii?Q?7PL+TeaaQo0l0Dz+1W1fTrEZ8IykKZS37T23XmC3vQkrKNl7WcngSsawR9R4?=
 =?us-ascii?Q?o0L3H3te4M27mN0WQKWfuYo8SVKkIIToSjeoS4YIMbivlN2gXnGLAXNRQZRC?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zJJWvErnccnhzXfscXmgjOY6Pvx+p7qkdPHAZ57OvVm3B2Y7eikRxM2lIbnEsUjo1VI0Rzy8gTvJ7fu6rOncHKd+0LJsTOwGJriV+zh0frpgk3Op5DcTjhKkkKsZhy4jXTx+wiL3Hy8OJQlhqk86wqltZ+Rik83+Zzxo4R6PjIbK4N6Wpr1ZoYEZ8lDWg26govJEB0kVW9vEE0XLZ2u/yCsdBP++EJ9SsYFUD2PI1MJbY9VDmDpveQl67VOe0a37+bsEMwKG6GziNGzBv5FzlkSuXSkU2DyAuUI+pHfbUVnEWcJKsoI8DmovP+gSih8LV3GE8YtpSCqgqQ8fimXqZ1OqrYOr+0w6QlU80PNAFlqxLDWBB66YfkDxRx3mmpZD3Ksu+1J+XGsDT5Zq+8SH5/NrnZOyAie3T+fPpxNQNJHH3ZtPbFTaqu5J2HpQz1KGGBmRFaVuzInm4tlsa9XDXctPMjbpPApM6eUovAMv735ulhP9TUtY5DJoou36Tft177MtgOwi5z3obYFFEn0VYk8fLwZKGA8ojnb6qxvVg4yBLYY69fkJy5Azzgg29IGM4PO5tkkhBnv0PVnryM+rxfq6kJGKnH0pYYjKItfeayk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd20c4b2-4b3f-43f0-a3ab-08de3bc5fbf9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 10:37:45.6711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8Bj+rjLLEmQgHskRelmk8bWprXcGLI22oAeQtO/3n1fXehUjkFDbjHYa8Afy/Ve3YhvflQonVOeyMWas52vlSXuye7IyYCXsyriZxjJHfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_02,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150090
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=693fe4fd b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P-IC7800AAAA:8 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=pFyQfRViAAAA:8
 a=XUpavxanAsYv4pLAIywA:9 a=CjuIK1q_8ugA:10 a=d3PnA9EDa4IxuAV0gXij:22
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=oJz5jJLG1JtSoe7EL652:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDA5MCBTYWx0ZWRfX0IrSiQAmAxjI
 cPUsrCX29EEsx6Acqr4JVMDX1+UuZXTXoBjQympFWIwxJzHWFeLyTKHkXvEizL+ZD7zLgh4MT3o
 8oU+sH0kmE248YutfHuiTEi6Yl6SIJ6NwddBUFB7OPwYJ9k+dbByo4oIma5pE4W4o+6VsrjBZkz
 1jScBotqjOG5SZBKGOwQMEvtm2Z4IlJBxbAwBJeMP/1iN3qqP79E7K6t8XbMb7qit6ChXmaZWDG
 /4EhvM2l0B59JA2lWHCYkKU45Z/coSMwyWeKIAo3nnG199v1LMn+CB//r79oOuqAJn31SgxyyVn
 xeMch8B0lBUuLM+kSq7IBpCA5ETyP1dglrIZ5ZhTu6/QxkHCbWcgmfRUW3Ayn073cI/iMgiwHfi
 QHiylWnfcNt8w14gYBPCqaQDQYsVVw==
X-Proofpoint-ORIG-GUID: nL5Q1x1dQ4fkQjQSbLVCvlsS3ziTRYF5
X-Proofpoint-GUID: nL5Q1x1dQ4fkQjQSbLVCvlsS3ziTRYF5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43B3240002
X-Stat-Signature: uiwec8465nhf5wmmw5e3g3ejoto9gwt5
X-Rspam-User: 
X-HE-Tag: 1765795076-27437
X-HE-Meta: U2FsdGVkX19SA8rda3ULsfe517YjQCSqxYjbWXq0hP7SVZ12wNTWGLXZJ38mQYfSfvRdQ9kNihqwJXzF5SMFIIU7xhr1O0xP+QHF/2JXoeS3nNeaYJuFpaafS/YujTIgrYYqU0/Pp3QacMDqTJcZMfdA6udHJl2C7PiuekDqsrwfNMb59gjTpPdyEIiTm2LnJlBIxHyBM3AweaTxPOSGb7BBvvg1K2RgekKGrR4+arQz2Ck+QUdT1gIiISUjsFdvPjQN0jVNhw32VfrsSkCq3wKa21kEJeBMEMz/CgCHL/gjMqQrIa/Ob/FP2JsPsPZrgFg3M4jA0SyAaP6eO6aQPoXxZTEtnnkHaN2ryII9/ENvDof0l0cJdBbYKIeN/Ymg0HJxzs2uZxpT22M9dEa6Te7RGHVWj+PVwf2LH8+AcA0854HtLgef0Hc/33VZKd6tLmB3oBUITDEw2IYWL5BBFof2R86n50toafAoDK5/fZNs35AuuBq4eO4c4ithiIsEPEcZQtedjy46nmCsX1/J3kECfx8iUx7hPmobF70XxWz+5tqpg8NFkFNm4wpWBiI1eW8udMEdG7kdl0W4WMf7d8w0AfnAGNgpAQ1mIMW0sXoFqBFIcp6jf9E0DZUCbyvOr6RaLx6TI/2OBjertX+ubOnlNRDsCzUJi87b9Srg53OMlXlmlhUenIe/NKa6o1DW9Q28X6+ZC9ax0SzrY38+eOU17mAGhyv6N3aw5UlMgEqzgO5ZDj5MnVDC0MlyU417aBY07IYGOj8jGuOVtSnopnkflHu576Tz7txzjgmuOhXMF9eqkMLj8hZKxvw9zUdp1EU1J6HXN6z3RusRQwb2dK6piaMhhMcqcxUfwHXT3++aSK2NSbtlkNgc94fSvH+36SNeIiMgUhxhaYM+S8IzNgcuiDRpJDll67NM6IslXkWH99gVpbccaxgXuQcU8qeunaYPWqtZlotPt2HnPAj
 gCrNZFaH
 reZlQl440KAT0Mp9FljV6UbydupqWwfPY2xveTDna9PMpSnoh3WukV0T6IbGTxTsAjU4Cf+yBJ5t+6z2mss4yZ26RakzVndm9f0U4qt57tvs5xeV5OWtTjNh9A1VbTBfSAkHRu8ryHAYGthWs+sQIoqKWTmDknwEP+tmMEp+GtF9AEfm5MnPQvreOzGjeP0sg3fE411z5wT3oEneZNvLXfGD9E9AfZy7e9Z9UpL7DFUWn8sPCEYSx5kJ///hSh8oxsKCF1Cxyd70mFIZ4a4T0IuUbCFy8VCoIz9QdXuJ1XXmD+iKQZsHRqarddPlCrJpKkpI8zH84PfPbCVJUxuEQMQ2BXPkSbju6q2oFLiglR9xXIan6n2OsszAk+budOY1cuSn6Pd38RikLYoS4yeY8GaCpHOTjhCgoH/+gCnotZ4XjWLLF06GqJmBwRQW+dZdQqHQXbUd7LyrrvwdaQi8z5/Jeoq3VytISPg/uUrQQIeEYJeNJt35ToR2OtOxGyj2oIbEIDFUDF1Ith9M0JhX66O37EPFT8cOavO40sF3/Hw5YT8S7B3isIeYmSZGDuKQysV9LnhmyEiaFp+P40QZuenrnbtQuj1vo6jqBWWmbLmWCYeEORu9OGg0hDFSEIBD/ELt1BW3Di329V2jEiqvqm57PPSS4iQXqgKzc9cg0SJ/QQFqPzj4rGTci1kU1iN7BujrCTFUeH1KNzrrgaZmDpt70B1u+sUEtGWls+umED2Z8wjNHS0wGCj7mIhvfcj1ThFCWDZDEoNeVEbx7UAx+kqxwatQQEnYmSS2L+hgmNjvyJrs8J2enG7kR/weabHme/C44LukB0Zh4uK9lOaVVk50SEYvZ98UYa1GQrtlhEZlzIirwnIJpTNElyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 09:43:58AM +0000, Ryan Roberts wrote:
> On 11/12/2025 08:11, Samuel Holland wrote:
> > Generic code must always use the architecture-provided helper function
> > to write page tables.
> >
> > Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
> > Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> > ---
> >
> >  mm/madvise.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index b617b1be0f535..4da9c32f8738a 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -1114,7 +1114,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
> >  	unsigned long *nr_pages = (unsigned long *)walk->private;
> >
> >  	/* Simply install a PTE marker, this causes segfault on access. */
> > -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> > +	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
>
> No! As I explained in my response on the other thread (which you linked in the
> cover letter), it is correct as is and should not be changed to set_pte().

Yup agreed, esp. given this is my code :)

Also some arches don't define set_pte()... it seems set_xxx() functions not
really intended to be used outside of arch code - see
e.g. https://elixir.bootlin.com/linux/v6.18.1/A/ident/set_pte

>
> Copy/pasting my explanation:
>
> | I tried "fixing" this before. But it's correct as is. ptep is pointing to a
> | value on the stack. See [2].
> |
> | https://lore.kernel.org/linux-mm/2308a4d0-273e-4cf8-9c9f-3008c42b6d18@arm.com/
>
> If you go look at where this function is called from, you'll see that it's a
> pointer to a stack variable:
>
>
> ---8<---
> static int walk_pte_range_inner(pte_t *pte, unsigned long addr,
> 				unsigned long end, struct mm_walk *walk)
> {
> 	const struct mm_walk_ops *ops = walk->ops;
> 	int err = 0;
>
> 	for (;;) {
> 		if (ops->install_pte && pte_none(ptep_get(pte))) {
> 			pte_t new_pte;
>
> 			err = ops->install_pte(addr, addr + PAGE_SIZE, &new_pte,
> 					       walk);
> ---8<---
>
> I agree that it's extremely confusing. Perhaps, at a minimum, we should come up
> with some kind of naming convention for this and update this and the other
> couple of places that pass pointers to stack-based pXX_t around?
>
> e.g. instead of calling it "ptep", call it "ptevalp" or something like that?

Not sure that'd clarify, we already have a bit of an inconsistent mess with all
this :(

Given it's a stack variable I'm not sure using a helper is in any way helpful
other than I suppose to account for people grepping around for incorrect page
table manipulation code?

>
> Thanks,
> Ryan
>
>
> >  	(*nr_pages)++;
> >
> >  	return 0;
>

Cheers, Lorenzo

