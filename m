Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1EECCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53C780092; Mon, 27 Oct 2025 15:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B046E8000A; Mon, 27 Oct 2025 15:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4B280092; Mon, 27 Oct 2025 15:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 808008000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:57:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F5BEB7014
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:57:39 +0000 (UTC)
X-FDA: 84044954238.13.E0BB91F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id B7A14100006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:57:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ae2OsfJK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jPVYzdOL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761595055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6k9/qbLoSkCLvbIT4cAVMWMIkC8X4crJ90DN2ii61IM=;
	b=2ZcSgCCXBFJeVHFv417Ea7ocFc2SctInkGQxSwCvZsrA0uEZYyn3oU9JrQsxUylP4w6H/B
	vcCN8LCgP3Fsxrna7dXu0hzqwvVpd2YNCX6LNqXKYsS/WVj48pUzBhoGMyx8OB6Qh5RyDE
	p3iimq1Kgp8NLUt1LZzRA6pNmuYda+c=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ae2OsfJK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jPVYzdOL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761595055; a=rsa-sha256;
	cv=pass;
	b=ABh8RY1dD63eduG2BYaUXqz/u/f0dGai2fHUR8TQsV6zcVi8cNLUFsLM4sKfxQ3k1ovxlt
	VbaTmeqUYTg8drI+w6/C6SPn1uYWIQYtKfMIfAJjnrZ2ZVQl/R+9pBS/d57GGATa/dmhf/
	hm45o982Fc3ko3I2K/rLCytt/A6GA6o=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RDYAQw022106;
	Mon, 27 Oct 2025 19:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6k9/qbLoSkCLvbIT4c
	AVMWMIkC8X4crJ90DN2ii61IM=; b=Ae2OsfJK15JowYRzM1IHXVODAGRyh6Jl/t
	WzzqwbfnvSZ8UpmyPOWQTCBPPctJrICZaUq8mJL7c6N/b9nhfxT6toC9tFP1ugd9
	EopECPDVPLjCJqIay6MsmeDM5BNHTfmHL6KF2Eb8eMj0hcOQHNiRqHTh6jbzv4KW
	/g31Mr3aRcViAskuxm+2BbA485+3ihKaqP3uH4n2A1SZ3b8Djyu2cBIHr5oVB5g2
	4bO5ihsuzIYLWxV43hyP1cgpENHsCXBC6vSJiEkt2h9OEhjqGZgdxWKQ+Fy5NWsL
	8DCtaM3cRPNfziK2yeKxOGidPVQpXjHYlwqMuYLx9ty55vhTZH/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22x6stk8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:57:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RITb9R037542;
	Mon, 27 Oct 2025 19:57:18 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n078t2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:57:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=senrE4p+taqFm5v1VBoxbLLkW8hf75UaJoxpocuTArCWMa4nb0WXItnhLsajN1KRugiWjw3ToJ/ryRQ5+mKRQ8pFQF7L1mEUPVfnWFLKsc55t0P+WLc+2G/RzHNvHyAxfpwlD/3nnXcFICHwag3Zv2OKZ0iImaMJKDFxfkRwLomN7Y5X1n/o2MjGMUvpXMwsGk23liVuksEZYcaVBM/esN+HumufUkpHeXU/exSUt83S85hhs9eCMflJ8ihcVjqjEJvgg2ij74b7FAk9YLvSh+NApiaU9xDfKBN5ef5u1ZRqfL5IpHLqhmiLvc+H8bSx+Syc6dQZ+tLt6wLGL60oCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6k9/qbLoSkCLvbIT4cAVMWMIkC8X4crJ90DN2ii61IM=;
 b=n484KztrCNo70Aaqd+e3yJQ/wUPvGd3W7U/E2SlTHq1gHSLmfCdAqbeSdv5BsU0BRpHXjBcfm+dXZr2Mi9Tnqq0lJsokAPDdZlF4NP6PIoF8uVCyIsLrLDNVONdkQ/JQLMEnCn0xIEmlAI9snqBz07qXj4RKntZUB3/kDCUUdbDiN1nTyGhba2xW7W0oheMJaFRcK7LE/HOEXsAwtp3nfdENtTrdeTyr55jYWcEnl7mIlIAjmnyIowN3laW6Fo4fxrS8Nb/a4gaDmVqNGDJbKU92byx/yXwTLi+NjYg3q1OaHn4Z9QuPyPl1J6WZ3qdJtBV0tw2NSf7RVQr4FhhIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6k9/qbLoSkCLvbIT4cAVMWMIkC8X4crJ90DN2ii61IM=;
 b=jPVYzdOLm28+ELhTO4okRaHHWziQrJZmUR/lK4nf22df9Kd4RqyA4Xva6tnm4m5VsvPN06anL72nVeQX7CYiSpgzZSOeGvYFWgvCrtG/hFaPC6y4zEgn1mMFbPcEsl2pV7Mku7KsEc2/yORDuIXdWw9cR6lqx3I2nOULeaWEWh4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:57:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 19:57:15 +0000
Date: Mon, 27 Oct 2025 19:57:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com
Subject: Re: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of
 folio_pte_batch() for pte batch
Message-ID: <177420bf-ba51-4841-8703-632622935afd@lucifer.local>
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
 <20251027140315.907864-4-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027140315.907864-4-zhangqilong3@huawei.com>
X-ClientProxiedBy: LO4P265CA0273.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 81bd8815-d91e-4704-ed75-08de159306e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bR9vea2NZr7Jq+8ym7RbktVdfK+A/f5FZX7Tec1ieOlFuBONqQftYBA7m+W8?=
 =?us-ascii?Q?oeXHgVaeUeHYjeM7Oo+Y7y31q28rUw+yI0FAvvpYreyGShCKJ95/8Uu+pVQs?=
 =?us-ascii?Q?cWtnYU+6UHR6pVVl6w/nGqF3UVZc+b1r9qbF+EFDDeonjeTkj2GCFPaesS2w?=
 =?us-ascii?Q?yMmEEp5CIng0+HVXbQQISMcCp2h/vR/TM//WFrX0e5lRnsHRn/hKuG9wKS1L?=
 =?us-ascii?Q?k1GTKglTHZTP8Mk5KNF0GdGL2PYhTFPgEc8eZ7AonALMiLvaWBjM1R2weKJu?=
 =?us-ascii?Q?VJZat5gNsbz/cnpYT2KYreSLA6LfG/B3/wRSUjUxGITbpZXFq8/hJmPpq+HQ?=
 =?us-ascii?Q?uOZ1ZIxND1rkwRYmI925hoMA5KnKWqK3j+ZhL8mY2lTXMEru9KQOTYYOr2BA?=
 =?us-ascii?Q?G1ONb1QKQUI9kxus/Tu/bn0HO6VzLUn//RYE0VsU3rp8tG71qNUz6ghBJOjB?=
 =?us-ascii?Q?UTTbZ97ANipucOJNDxAU6JL8mSUTgZx2sX6DCDgeNu35158VpDn3gUmIGPTN?=
 =?us-ascii?Q?zWx+tUbkKCaooM0QnOtHNTD3yRuaR9tWM+998STJeliFvcZScpIlQchBFtvO?=
 =?us-ascii?Q?+ad4HmP7Zri5AW5WidrBJfEdXtcro45wGn7OPLJmOGoGdD0BntN54MGOngFK?=
 =?us-ascii?Q?rqHMMAAoq66+RSKQnXfs9cRhvGwN9AcIfuMEZhqqDuNs6Xg26VZJh4s7uT7/?=
 =?us-ascii?Q?wDS4MS/WTkWHO8Pqzdz0iOjuKJrSx36JthywhvEVNohrT6OoPm62vizgm909?=
 =?us-ascii?Q?ranajRA0SrGkmQnGpu+mEDW/8TJUdxRAqvtaOzLAmKYoVpSCYyknmuuBf1go?=
 =?us-ascii?Q?drqqPmsnBTVukOLGxpPbFnCvTvKILHVTW/sgBxN3PiBWUdZN6bfkwAkIf/lg?=
 =?us-ascii?Q?6AJLsBpkknphHHibV6JNY5QKdIxfInfydPWEXlLX/osZNUizbnK63ghmbcT6?=
 =?us-ascii?Q?AavDuWEjbUNzjcpkRTrv2/jBuEnMw/Y93ejebou4EqfHFTjXPnNjPlibcUUJ?=
 =?us-ascii?Q?qyae2QgBioGFDwvx3bXGySJXoFdV/EZ4YZvMXmnpJhvwbVVXDgI4lNQxojnj?=
 =?us-ascii?Q?GV8wnQRcCK2cN1mNnf1q0SDyCWFR0k111jSLrJO/sQH8MgmSmXlB1RnVq4sb?=
 =?us-ascii?Q?W+I2OZWQKrtgMixwb5XqOxyyN6qHg0YJVLVayoQxraoG5Gou6S0kexkgcuKq?=
 =?us-ascii?Q?T90De4IvcPsFHe6OHQqzPGFY661IqnnHalfGE9NLPE8ASZN0ugbPV36caILe?=
 =?us-ascii?Q?W0lKmfRToNosivuZal2okRO8PlS8l57/X07FpR4rmkLoDjbhU5I9IfxXn1z5?=
 =?us-ascii?Q?+F7YuoMUg2XJQ2EMIiV2rLXgY3FOylYhFm7v5Zf+YSSyTzcgsMf6aIkEtwUg?=
 =?us-ascii?Q?KqBsEBQNsfYtVjhyUgjWg7uB4Y4758R1W2YXVY38x+AYbrwe9M542SWsMAf2?=
 =?us-ascii?Q?7dRAkygj0e2+nfaZ2gvYfdtLri6y213s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OtrXaOcJzyNagL20qPPkSd71ln/2NDe+YnL12bhiWcL+Lg7NmrkWP7KQUO3k?=
 =?us-ascii?Q?FL8/L5s4hWZwNrRaMMrvXvZnQJ2rDr5WaxIQ6Zi4K8JphJCbiDLtZtDFwrGq?=
 =?us-ascii?Q?EnZPqdgw6gpKGKMlrUgSOH13ng37NhcDkCuKgkQOWGGvb2TOqKf4rNdit4q8?=
 =?us-ascii?Q?hY1MPx/gpheex32A445B/BFzUIlizRMX/YXznCTJc0bObnDNDrD6UbrX/GGF?=
 =?us-ascii?Q?M36xap5cHlusfpcLyjoAM8KCcdF0lnkfj4FBxeZDHM/u6CjuE9YnU70gnfcc?=
 =?us-ascii?Q?UFiTj3IZi+D1VES22bdUvKoO/r9uhzRZOKlEeKt641IHsUrErWNUiVh6ozrZ?=
 =?us-ascii?Q?4gH3MmDxihk+McET6MKIcJFvyi7RQJASiGcLoMC2ME6eF3h/vUQ9g6mZh8of?=
 =?us-ascii?Q?lzNBfh/9pHUsyBLfJkfX5nfSwv/Cz70/siPiQE+8041BuJchgHNS1bdjxAoU?=
 =?us-ascii?Q?VdvenQ/xLVZMjIiRxIcdiFVBMz7JejWrKsuPvtOOdfMgOMDte2D/GRi1rSF1?=
 =?us-ascii?Q?4EDCeWBvmtWqXbMbTHL7RSzAZQ+b8gb+rjlqbezeD1vTNJ3GtOQlQHRN2++m?=
 =?us-ascii?Q?e4OwOQiHin1INTwoc0SZuIg8HgzMdSXv3rioKmdltlOmnmeT2g2B/4+EjKIt?=
 =?us-ascii?Q?7RvC38AJFPlwz7NBOxHLKGDfp1605ThNcBoyI0uOWi+zTWTab8vbu8P3Ms1p?=
 =?us-ascii?Q?5krfC4jqcNIshOk3oEuF1xGna3ebUNvAx4D0JyEKAGACUTcyKu7vVvsURC2k?=
 =?us-ascii?Q?ezdzkc1sVw2VTdR2kKk7EwUB9grNOrVNVmca8nqwii3ggKRQpzwrx6wYZPF3?=
 =?us-ascii?Q?jEGCPK0dxvEpbMRUy6MAus/qeGIKp9YrcdCoxnBvRbOzzd9/Yvml5W/bVsXw?=
 =?us-ascii?Q?ZsrUCAqQoP6Izk/1CMvHRb8y9F7L6rqHRUHpV+Xuf+9f8QULiDSYyS4AqdYr?=
 =?us-ascii?Q?QqqcetZwctN78pSwzfSmwLvcPfDxbmosuA+C556SdykuQyWXnegp5tnjd3Hb?=
 =?us-ascii?Q?uXQGOgNWoZVD3Zszw6AfxBDdf9xGgxZzYYuI4yU6lh4NACUhtOrZV604ViNI?=
 =?us-ascii?Q?goFOh/8kbd5YXZ1pDYxvPo4lbzhUzb2lAPBIrXRl4xSbGM1zxRk/30BAqDX1?=
 =?us-ascii?Q?mibxA2DmAq+afDHw5+BLrlQ7w4ySfiUVCNC++ImQBlxHDSWU1P28LbtaqHu/?=
 =?us-ascii?Q?gQnBOUZ413lhubR3VnXFWl10iiYJlr7geBipfWSIckwng1UQ0Pa24Oq4+YWT?=
 =?us-ascii?Q?5Ar+OXWnIwwgeQO3g3utCtQXHnDMDyYzzHPzOroA5i1Buwhjlq+uU8Xu8O26?=
 =?us-ascii?Q?jEJ3Yxx1AFJMA2ZhQr/BpEAGmk4tJcSEtHZpzcxiXU5XDWATDUaU1AtNmpsq?=
 =?us-ascii?Q?mbLDwNhA92RBpUT1mM6/PuvDpYZyEAL8Y8pVtNrkWWohAa932Uk1mtJvsWhx?=
 =?us-ascii?Q?eDWhCf6zPGLoRZHKI70xaHzs4obkzqDG0ARL53cnWODmWpQ+HBURO0HsdOZl?=
 =?us-ascii?Q?dlqC+ROiGbVSABUD8yd9fVq+TJ+1mDl25OIHe3oTP8rwwfaiglCfl2LV6FCJ?=
 =?us-ascii?Q?eX/nanl1WJR1PbK9/vuGB+kQG+9m0zdH04XcWB+4xG1lsdO+tqGpa4KCYlnv?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GnX3fMYsBuHDZT7y1iZyWeBlu6UCqR5zK5o81/ZDwY3RcnHm+hEKiGg+MSyO39nF5bGzzUSCw5S90g6NAKsNhri2AgADkLWK0ekTFCTY6SViVcPnyHlfv5p2t7/82SHVEVxQd5Un5OPnHPyLwuszg9FGhkj/yMKe6RvIIGoh2LI6dgT9DS7vIncNjnUOZE+kSfy1sIehxfuScStinRCMfMzPcXbg/9A5453CyZI8xG9JCLJyeU/McrqtP3ZjSNCiQvKwxtLQw2tn4zstvRSiYMo+cFRVhWg6PUZyu68ANKW6/kPnyIivUCaS7AvDz4+9x7lqXUp7B0g/2Thr/whZmCQuRf98ow+R+4EjaRqlDbDgN0ZKS38rv9ivQt+HqcPD2QmNt6euc8Y0WCYoeiwS1RoU+tUj7v2T3wK1xCwM7B/X6gyhnu6BYZkhY1FjMORqCWlnlhkicI1Yt4jjSYKz4H7hPM+HPBggogNpdLrwrUw2zpT/qZuo/rMgfBfI+HMrDGD2rXFndPUAb5uJWDWdl4/MXBxYnn3LZa3215UZWdfJPE5W0eKPWOFqy+MpaTFi/A5ZboEjBB01Pbk7SGt6dP5nWYmoxK78QWaPXBsb+jM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bd8815-d91e-4704-ed75-08de159306e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:57:15.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijkXX3pXghdgjNs1aD7gZ9GZGMmDJjPPRvQlsV932e7RazQLR1RwVDso9m5LVJ5txxVD3wywI7XtxA09K6tWBCezTUf6Hr/UshR8g6GuINM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=838 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270183
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfX0arl6BbjEAp1
 Q1FUtOsNpTDD+n2Z1Md0vXtkQHDCTMvyZg5BJvAEsbLkht/cL34tF5y4117MfPnR2etQB8RGXq1
 mRIi3w49mCgoezy5BS9RBut1F5mHdsfazc2Hl9JCHg8crHhempMBCIlnhfsNT5ST+h/FxMv2vb5
 hdVaxqZXEEEvKAb5BhpZWiudO8S9Sv76U98sQIcFe0kVBxY/mTbiOLYqVg9Uae2c8egGNMd9MI/
 Aam2eYde3Cih82e94TfnocFjscpAEFhEv2a4hwyRH/UgY4GgDDuFiFXRPq727vjC1E0XN4VIore
 9O/dS7z+dbjVhZIqqR6nD4gnUbzyacKNDY35rwlC4MU4aNcSTprxd6k1/C6hk03tXcOPugH8W0x
 vddhETgwtkQ7m7HU4JCjUEhXjpTtGg==
X-Proofpoint-GUID: B34CCqOnpwssTPvTxfv6dELsFkdRP0v4
X-Proofpoint-ORIG-GUID: B34CCqOnpwssTPvTxfv6dELsFkdRP0v4
X-Authority-Analysis: v=2.4 cv=dbiNHHXe c=1 sm=1 tr=0 ts=68ffce9f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=LBw61P5hhjHc5ZEUSYcA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7A14100006
X-Stat-Signature: mfaga3qyfbq1gzmosys14nuhffxcqsum
X-Rspam-User: 
X-HE-Tag: 1761595055-298238
X-HE-Meta: U2FsdGVkX1+88n1L8tJsGDipDwkth2eO52SMUXfHLQLuQ0LqLgMsjzpTP3MAd+PEmvWv8HsvGcfPEYlY76P+qFe9b5RQR1cl6EuOcZXZwdCoI28QK5fw2ELeN7v2IItOnMvSGkSCtDhFvDlx4g8f3/fLie/IC9ju5ARy+tFNPgyMNGN40PsMXnNcM+xB7/cOEJ5eK/FhKfe2sCERTgM2LeKqCy3oh4N1pEf6Xg4Zm1FIirsaS0zMQVrnwo8Itpnuk47PO4zczvq0CajMQmhYJPThAkr9rOTwjMWH6+yOwC0Zoj9Ol/ZO6pM0WpgfeY953/lLfg8qbT9jj59g/Ua0r6F+5VH53HUfAIvN0w9uPIYinndptgygZQBEFrNyXG4uz8ExwXVQgefvxQdDZSLK94x/yOmsJo6yJQXkJ8B+5akwjfxhC00HWMPmi1Edow+/i2L4wsFaF3gttPHOLsa7ilEmVbqQ9ChzL8it7OKz2MnzdybmrnGaGDjmULaWY6MxmyyQTbDnfbY1AEmdmEg1SwSRDUEAWCz5c8jVplKfsd8QE/a53W/7T+WsVE1LW+4VBIRTkJ/hPIlX6Xpn7V3ZeLtHV66ZGoSwE5+SQyXbYBv3qyQqlbw3Oeby4u/RjUkzCTotn15lkdd4s0W4biC6y5NOU37CD4wbH1J/sBhD2SZRKQq0MMZuaB/wJPzdf5YHoR0NdrA4wSy4ATosu4Q3je2UEaAF9+PZqMhhHf45e+NyyTTKtnCPwT82S/OTCsgtqDYTVOc7CV54rNIbJ5Z3vsNkkSBZdQ1teCpd7l3raUPz8/Gg/XqtcrBtmoCiZrVtwH6JN0wtqx9IqpYaSdWTRAUqmHawuhktqOsHMkXC24QxrFYCSlyTD4CMyehYjBUMBSl9e7BcPZeZR9GwCzWkbsJLd5GLYZuLzkotfo9YkLt8IAae2S9lV0dDZBgZjE/s6Du3y2ZGTnWJ+z9egu+
 r0Z23wm9
 mxhQKXuCjjAXSPaRpyfPWO9axcGnKCX8tmMAiDhjQvKJmYUssEV7saXk1CUOh9JBWk1u0lJdgvWKT+6MUVnAwgTqFUl7wu7C8LS/wacQxaSZB+gmuE/ALEoDO6a9mNlZ1g5x6UMrUkipe7ZOPhi2XxiWFwLBlAeXWu1DW8lGscGeNVL2JrWpYJ2JVMCdw3wtFO+VcbLg9iLklCjFojuuv9csGfk2Nch/OrCiJ+leTbBQWeRp1QEnwk+SPVdQPKjl4v5f5FVg9wsmR8c6h6bfRjZU7zLMshcUOFvwfjrS7YL6tk7bkJFoZHsxq02Y/KtQ1fmK5fAiyixivMbnipc9rlZi9XwE8hB1+ARlGrmVHrm1CWdgU+SPgKo37U7sPkY/omzFOaF0aH3A9Uk9PQzS+DoCg45rmCY16OBbqfEmjrrM+CvMzhvgCn9ZU3xAWgFArOOkzcS8odSq1Ql1aVTHXCiuQYGY+o+W0mhFWVic8Z/oDyK3AA+yBu6tLlzHSVKkEo8yJ/yvmkTRLpkoOboniA3LaSThB5h0pT6qEmBPXSAX4+CtXYEr96qLcYC3dw9N0tyKkkrVkAkpzNdi0H+4N307QFyDFKbWmwnOAHEiEPtfNp0WCic9miUqTay6YCFYHiLwP0pNJOoPSE+dtSUaUCb9gk+8AS3ByWFMn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 10:03:15PM +0800, Zhang Qilong wrote:
> In current mremap_folio_pte_batch(), 1) pte_batch_hint() always
> return one pte in non-ARM64 machine, it is not efficient. 2) Next,

Err... but there's basically no benefit for non-arm64 machines?

The key benefit is the mTHP side of things and making the underlying
arch-specific code more efficient right?

And again you need to get numbers to demonstrate you don't regress non-arm64.

> it need to acquire a folio to call the folio_pte_batch().
>
> Due to new added can_pte_batch_count(), we just call it instead of
> folio_pte_batch(). And then rename mremap_folio_pte_batch() to
> mremap_pte_batch().
>
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  mm/mremap.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index bd7314898ec5..d11f93f1622f 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -169,27 +169,17 @@ static pte_t move_soft_dirty_pte(pte_t pte)
>  		pte = pte_swp_mksoft_dirty(pte);
>  #endif
>  	return pte;
>  }
>
> -static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
> +static int mremap_pte_batch(struct vm_area_struct *vma, unsigned long addr,
>  		pte_t *ptep, pte_t pte, int max_nr)
>  {
> -	struct folio *folio;
> -
>  	if (max_nr == 1)
>  		return 1;
>
> -	/* Avoid expensive folio lookup if we stand no chance of benefit. */
> -	if (pte_batch_hint(ptep, pte) == 1)
> -		return 1;

Why are we eliminating an easy exit here and instead always invoking the
more involved function?

Again this has to be tested against non-arm architectures.

> -
> -	folio = vm_normal_folio(vma, addr, pte);
> -	if (!folio || !folio_test_large(folio))
> -		return 1;
> -
> -	return folio_pte_batch(folio, ptep, pte, max_nr);
> +	return can_pte_batch_count(vma, ptep, &pte, max_nr, 0);

This is very silly to have this function now ust return another function + a
trivial check that your function should be doing...

>  }
>
>  static int move_ptes(struct pagetable_move_control *pmc,
>  		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
>  {
> @@ -278,11 +268,11 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  		 * make sure the physical page stays valid until
>  		 * the TLB entry for the old mapping has been
>  		 * flushed.
>  		 */
>  		if (pte_present(old_pte)) {
> -			nr_ptes = mremap_folio_pte_batch(vma, old_addr, old_ptep,
> +			nr_ptes = mremap_pte_batch(vma, old_addr, old_ptep,
>  							 old_pte, max_nr_ptes);
>  			force_flush = true;
>  		}
>  		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
>  		pte = move_pte(pte, old_addr, new_addr);
> --
> 2.43.0
>

