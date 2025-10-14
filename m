Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1216CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58B798E0103; Tue, 14 Oct 2025 08:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BB58E000D; Tue, 14 Oct 2025 08:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5598E0103; Tue, 14 Oct 2025 08:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20FC88E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:17:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA8ED887E5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:17:15 +0000 (UTC)
X-FDA: 83996619630.19.6338E56
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 944DB4000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:17:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ig9DBYhR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZgldTl1w;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCDUQREtzSu+2tSkGuOWYlHdkidtlnHtby7KZjcKsug=;
	b=IaskZha5UR1tDRfxzqnAJOF1rHlESwi0MmquO+WIE/gYtcXKF3MJx7xBA+sfaF37KqA3NE
	fFGiiN+V8Ph+lLCDppmP/yfrCokWW3VOWQZu0jZj8M7I68x4D69DxXD+h9fM3LWmassPmb
	0oe9MGjgK7XgM1M/LXCrx64OzlPdPcY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ig9DBYhR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZgldTl1w;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760444232; a=rsa-sha256;
	cv=pass;
	b=EOVy7TkWURwNsBJl9kkt+JKYz3vw5BhI3cd5mZ7al+f0frhjIsvZMqu8B2LCXNqcqnUCtg
	Y1TMSm6GK2COHAHV7GSAXY7TOwUmRAW0sIRS9a36TbhK4/SzVkYke/eFwukh7RdSGhkb9H
	hqAPjvxWPXumJjg3Hpf/FboW+IG9Jqw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EB9fhT003604;
	Tue, 14 Oct 2025 12:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wCDUQREtzSu+2tSkGu
	OWYlHdkidtlnHtby7KZjcKsug=; b=ig9DBYhRFWhOIc1oZiTS6juTFEk3WYb2a4
	bbyPpc5AjNU6C1Mp6byVcQTLsT1kpqWY8JZQfnT6VwauSe6cMFLpYu18In3tw8+U
	yaWFLBdMuSn5t5scqydA98C0UHw0KVFgeBDGzo1KMmcAlhYbWgjRwoks+QbmapTV
	F6VtQ/xBVXIqUyYovteYhEp4zPVrnZygenebsdkmR6g2rQ+6y0M/BNIEriFG0iGI
	+CArRq4aNwdGoGlD9RG9jeMxOkcRV8De9hwU5eTP0re0ayn8oVDYL7SmiZ0zd8Vw
	umv6KVjFbN+CsEt9eGoKX5UK87qHEq4tZbkVHLmdO1zJHp05NP4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qeusv57f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:17:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EA1X6I026157;
	Tue, 14 Oct 2025 12:17:06 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp8kv9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 12:17:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJlAn0y8dvCG+PrODpBYJBv7MifKBrl4osOO1BCBOf6fm5LvVXY3j3mUQLXNUJ1KynuVCFBwvVSpUts8u3MrIqA3h4nucqWkVcFZy+4bzSpeWK324UbBVfHvNGURyx1peX0igmrGyFltmG8skfyvBDqnlhXPmmuJK9Pp95Xakw6ncRaWoPtopYQTGXnFKZcPiEDaAyiRb/kbuNZ3aptWVDS8Tkn92GQcpQUeTg5PnVtBx5cHarE6btK4whzr7fPZk3iHcoYuCVwOJ0w3pL1P+L9AwnFyScmoU3I/wAsznzsHFgQgH9D93rNXnihkpAt/ElrLWrPVNSqDbsj5tEvpNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCDUQREtzSu+2tSkGuOWYlHdkidtlnHtby7KZjcKsug=;
 b=aKjQGci8gTnb8mVwp9vsYiNNPi4RCautrU4ZEXgnSj2F5Aon2a5oho2kUyWcJ1RvNs+vYS0iGDhtuF5j77qxoeKq9HRWcoRAg1jiVRarLnzqIflXCFOoyFpM1AI00491QcuGxKAvPcnMRsvTQcDOqqw/sXgVJyHFZT3llsYHcvLX1R5eROrpzwuKNuM/aO7rqNXatrjc9ZqP/eZyXLmczC0rn2yK20eEMAmzzepVCcfElvAEgIaPsVTm8cC5dMtHXhWDoPLTmygXiLf7iZLUFXpNf1ASmhL9V1bOHaXLpciJF4tpmO7JTg/XKzrBtyoWh30FoV/SmWdpFu6H0GNWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCDUQREtzSu+2tSkGuOWYlHdkidtlnHtby7KZjcKsug=;
 b=ZgldTl1wGw6dwPN+QevIt3f696MgNPFNL0DvACBOhFtLhAEJO0Y82D/ssatek0GHiVv44JDXZ8KNV0hdkw+ShDufM+Cw8X5mQat/wRiqoE6v5XyqGwSSCpeL34XeCMfHBZixrDIc7FaP68tCbYBr9ryEpX/ujT0CVyyf9/07Zzo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7795.namprd10.prod.outlook.com (2603:10b6:408:1b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 12:17:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 12:17:03 +0000
Date: Tue, 14 Oct 2025 13:17:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, richard.weiyang@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 1/3] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
Message-ID: <3982686f-908f-4f92-b3ae-e6f141e617ef@lucifer.local>
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008043748.45554-2-lance.yang@linux.dev>
X-ClientProxiedBy: LO2P265CA0506.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: bde6aa3d-c0a2-4096-e0bc-08de0b1b9558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1RgPjlFiHuoz/e3xWuv+n8sTUC0SzuHsM7SbRigvV+3RZkQevcGV1uDpDN2g?=
 =?us-ascii?Q?YeKdyw4YwoNeO4FSzUYY7N4cm54c1LvglAYoS+Xzuz3iGtoOWRAl9wf2mSn/?=
 =?us-ascii?Q?jQbri1rX4/g30j2fl3Fp6LF0Jdx0A2jvc3s3ugUIF78jlei+Lm6nWYkLqYiW?=
 =?us-ascii?Q?uH8QAGFkDix7bN2ZbONmbnUJpBw+z1D58kGoYaHtb754F6AGxqnlQ8xBSm/E?=
 =?us-ascii?Q?JLNwTCPJsKOdbIimOSUU9o+We9ob9rR+XNWtAg/tRyURmKuR1ACspU9RyARI?=
 =?us-ascii?Q?Cnh5wGqnAvhdDmMDYorpne+l5SI8xVgDFpkiuPUDwO8QhJy9lGvBb45B5yo4?=
 =?us-ascii?Q?z6Uj11fT8+E9QBGEmo0P9inOGOfA5Ss3bgbtf44AJoENuZr+VFHGj0JK87fu?=
 =?us-ascii?Q?+7kTysHXpSH3Ee/YopdL6x9A2GVWCZ+2ZO+YfcMcETX9ryy0tx6/gbSrHGVE?=
 =?us-ascii?Q?VBFIx+wBLjIv/fwXoGXkG1FQ+YysEczGYgj8QOKUBbXRMxcjzNzGiRherFp2?=
 =?us-ascii?Q?RL+6DtT1xqwR98gXnKBEY5pEYdmaCdrgqMYMRJi0jUH3vQ4wigNseOwZmI9T?=
 =?us-ascii?Q?qkc8Ij5cSV1u2QK62/4j6vuTFogDeLh1huDQ+LP+gQS2r+BEbnFEpSnxzEbL?=
 =?us-ascii?Q?D9AKEE8ZmafVz/X9s6zqlKPaCbO7zTOH5EtUfPAGfhdXI8NaUPm008fVjb6z?=
 =?us-ascii?Q?BKNzGocI0pp2NYJk7D94z2HpqdQ5Ac/bPUCiDjLalnLDGB7nISBvIBXIMokX?=
 =?us-ascii?Q?hOOIBP2TOvKBsW+BABPXkgLJIboREr2CkCYvOSsxXRucEsgN74BcxipLgxre?=
 =?us-ascii?Q?Vl6ClPoOuoIqVXimhIcaQTnch81YEe7+PgKi6HZtF9L7qM7eq9bSqbx6NoVD?=
 =?us-ascii?Q?U3RdlLqLAcCs3Et8sDGHhZmJetNOnP7RWNZrsrqH2ZF9LTpq2Yx39oqkhhDs?=
 =?us-ascii?Q?uCkDc8KJNvFcKlWeHVn6KXxbjQtXbk00XiWkaKTkSRqYQ/bTMwJ3qpen2ul4?=
 =?us-ascii?Q?FCuaxy24LZtwl6qLLatCUlYg371rxf1Rhc4gCUxjt7zU+T9Em0McBmJyW7Xs?=
 =?us-ascii?Q?pr45w859HXKKW6jbs9asEhprmk0w9f7ADxxvTd9Lkm1oXVTJRPlWzHwh4khA?=
 =?us-ascii?Q?8VLb2iF6jUCHvE0h2KKEmwM1eo3/rPMASxwVlHYCwKNInVnJLvRfcfUGFtCE?=
 =?us-ascii?Q?MeffrgOuDh8s2g+PgT+xTxgd7CIOhlVNzhLHFspRaln0FM3G7/Mr+oTMsfeV?=
 =?us-ascii?Q?riwFiv1utHGb0lWmgvwgSqu22ogzLdZQvpcm+J3RH4eYzXNAqfYwj+o+9vNo?=
 =?us-ascii?Q?alEr9zuYCeR031/9hv98iNmnkjpW4ZjrwKUIS3RHqkKp5c1P0jlAd+Wx+yun?=
 =?us-ascii?Q?MwkPKu2ugb03AC8K4IPmep+ucAti5Y4nAT7aOQMe/fnns4GY0rPZx2/oXxft?=
 =?us-ascii?Q?TitMFypY0mx3dNWIuitUUyAzFGRv0JQ6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MsDAkrZvhY591tE4OkMRtA0dB19Sgk+gA4ATSFXiFqnEiIkp8oslNbzM7J/b?=
 =?us-ascii?Q?efxGZlmsm3RdmhGbJer+9yLQF0qhdySCVT3qXRSdkrDkl6BGljvb5dcScKB4?=
 =?us-ascii?Q?u1IWNe2J3Q5l7DPRN04Aol5ZNW4Ky1B1iGbFED5+OPsyn6ef3O2dMsH13lvH?=
 =?us-ascii?Q?DSs5mEdZnEpkvq2mAy4iRaXayrFRmv9Afcw9shNDSGhZ6EgKRVFbgnWSwaKP?=
 =?us-ascii?Q?nkDeGWZgTd97n/BRsrN2axzmbGIUDYyW3hj8ZcCXlgziCenU0dUxyVqQCis2?=
 =?us-ascii?Q?8bDV1/0Fk7Jort7csxs3rkJArI0NPB+xhp42PFUSrWJ1ydhUqa4uy68BiyiG?=
 =?us-ascii?Q?UuHXYS3kSnNclgvmadHndF7r3Iynx0+7sDPuttTpkECa2afdFUI2RpPPGvjM?=
 =?us-ascii?Q?Fc+wkUlyWA3VEUDkfPUY6/wF5AKTM8+5oQA03WtFI665rvjh/x+WC4MbagrA?=
 =?us-ascii?Q?AUTLMMfytYoUwTe2EcVZulKKaUUqNBUE7/Rnu/4mXkq63BvqDlythPXNWCqT?=
 =?us-ascii?Q?OILGnbo3kohNrhjmrGGAbfs4Cjre4Cg3BluDlh8HcWfckfi7nfq59K0janbp?=
 =?us-ascii?Q?z14wdVFA4oJidRE+WNaMehygdXKVIrGAetqCRGsCphfgooUko+xiPr6KEAC3?=
 =?us-ascii?Q?nQVwMsGdF2fdela6CkImQGFRWej80T4IwBnaw2qTuezylvt+4rHSz//zN9v6?=
 =?us-ascii?Q?xU6qGNzIV0EL6uPxo5/F0xBlH03j0wmjOUIGMyGz43C0qc6jSF3B5KvCEBOS?=
 =?us-ascii?Q?Joi7fHMtSwt3O4mzU5J/5zHubgAE4ZYyEgfNBHB9FYJ0Ef14tzD7wDW1SNEp?=
 =?us-ascii?Q?KU4vCJASUPPQ5+jzlFYLOZViLVaLnAWXUAnQv7mGLx7++P/ukGXnv1wVeHFs?=
 =?us-ascii?Q?oSK6GRqB95TKcFmwgf3OCBO+dvtGSF/5qp8WLOiQTrdkrzzMc83qdFc+l0SR?=
 =?us-ascii?Q?94nFR6w7aAM/OgRjDfyTJgEsngCJ1hI1uebko6XsmYru94gX2cegdRBaGrj2?=
 =?us-ascii?Q?P+cdZy7jlnr9I4IHkQWl4AKYPRTlHHSh+WU5veE7kqXElPnI8nDeXYltsv23?=
 =?us-ascii?Q?AElygdZPfZmUBwXKkcrifvQwdbkLoevGSDQbAdMGRqO3T26/l2R/0Yw31C/1?=
 =?us-ascii?Q?Zxiqlm/dmmWYSqkQ94aywSgSD2XZPc+p565ZTVGdFiMBfAVeEOLgjZtocSqJ?=
 =?us-ascii?Q?mlPW6dmrnnakWtoReipKKH9OKG5Q0QvL5T9HUuxVv0p+hXVjOWkLTHTOm4oq?=
 =?us-ascii?Q?sjTvyJhc3Ie23uxUYDYI8P7RqX58ALJBTrDfE9mgOv1hNIr29/ruxrp6a2su?=
 =?us-ascii?Q?Cj+PHAX8Q4ajcn49RI6cEMmbYA1zq0Mj6pKOGti/W/BYCRb7qm+8UkdnbBWt?=
 =?us-ascii?Q?LAcOopdZE++zuPbBSdChYBKzigp35S4u30t0Y+LYgCtlWsY6x9X1yIQxOdxM?=
 =?us-ascii?Q?m9KXKwdjHdKJ3ZXMQFnmjJQXOs7aCKZUeYDMyVKk1vYKjmQ+qLwmahu7fG7a?=
 =?us-ascii?Q?If3bm5Rrlf7IGBXzNQVVinNTR/wMOVRaL8G3LrHM1HpYsZdcbuxjHJBX9gLQ?=
 =?us-ascii?Q?QC6B7D3xH3hCstDqQxL78lJNTH5rzinKrRjrDKNqHtre+d+fekGzXNLNcXBk?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yd9HNt/++bNmOapgpmHBqGf4qbo/R+Ho/XvLemw3naUQWP03Gj+/inGYjWHw3Tn9FlQqIJPDGdctEKjMIe4/K5APM+MWqCPknKqwGroEMNSs8v7DdZIytuX9pbrureMkolzOkrDHBHxAm5GZ+HhxwNs3mXn/O8AgnyStQ9qfwn2PQzziuVyaWXhfyA4rqCCpEcCTvlI2CAbMqOrFz9RL78y6eotiuHmHEP7spk2j9uOQyW4qPat6i/9XQ0teq6uKDVgr2qRLtPv1f+yV0wFFcvPZ2SCqQcJ0QH/yl9QOTqmAkv758LgnVjhQL39oPp6zt9CUPtEQD518XNfSNmjPDny8IJ2pjKoMUXWj1RceBDtdqP/r5jBhNiczsijyc3SQfEJ89sEdWm2GPbTOpPzLKm/wVvAdJEha9FXCpF0pLb8bler1ljEfTzs2eT6bpkOA+YhEwkLJIDOAU41wZMP7xTTjaEKyS6DTKfkWBh9P2o0iOznZBMe0LHrmMC6G9QiczMGjFiWBcNSmALjkZzS0OwqoNIfmT0bDcRKLck2HGAY3HBUO6/Ut/3J2RK2hMBSAczhGfe/wp345kAFfejsdMBMfq8JqgifF08t5nnKmKdc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde6aa3d-c0a2-4096-e0bc-08de0b1b9558
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 12:17:03.2510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Veccuk+YaZfU5aSoFbhXbiotnwaOxvLOy4KyNyVU5IWfNHO8MzTv+Cuq8DkIVdSxYcuomcaETGwRQ8TzYtcgGzK9JwoYB1AMM7IauiLJ8G4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=609 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140095
X-Proofpoint-ORIG-GUID: Lc4PlaSPxkSRZVMpw8Y5LVPecl512FO-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXyxMPYR7TqNrh
 5+rl+H3TlH52dUg8TA0V0ItwaxZfdCqveByCb0Uozc8iBR8/Fp9oIi9hYz0KEdHAuBkl7OqtTfc
 rO9OuPrcf9mFbUmXUSBsUHfr0vUpHG31NMwH01XDTmdWJf6WaOpd4lXKekz9Fjv70ySKg845yKG
 Pdj4trw2nVb7BdoSEGUhJT7UqEwtNwaWXuEEjWLAMH9s8BeaJJXPc7+ZdxZL0W/ujvDeEWiw7PV
 oxecxwf+NzZq+IcAx1597FmR8x22Og0u1L9FXkLii4I1KwUG5vFXUbJGWRT4et89kf7qYY839a7
 dQOaPmIF4CdnQTiZMRp8/Q84ENqmk4estTdG5vd7QOhWvCtQJyC8quJYrYuDivcqOp9kRThcDTV
 L31jVvcUMkzMLf0Kn53VhvDhXS7nJL/I7tCIlqAUeIy//qu/3r4=
X-Authority-Analysis: v=2.4 cv=E7TAZKdl c=1 sm=1 tr=0 ts=68ee3f43 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=7CQSdrXTAAAA:8 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8
 a=5WXMs9Q07sKjwNZqsikA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf
 awl=host:13624
X-Proofpoint-GUID: Lc4PlaSPxkSRZVMpw8Y5LVPecl512FO-
X-Stat-Signature: gwjhmcbwhmzha8gumec176c6bd7n3iu4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 944DB4000B
X-HE-Tag: 1760444232-889121
X-HE-Meta: U2FsdGVkX19qFCjuMga6sAMuCH5SWY6wywFsbkjh5paWVkmxJtCoghPmwdx28yeVE8oCI28NuUWuMyFogqdAp4EMur3jiBcpr+VjD8V1TBqRz2aoYtKlRzHC5ZChcwfS68TVvY0DUQETbBhhaY1W82ShkK7P0SE2+KJmd8EwSMvgec2F9nb+yV7y6eEpsR2YgnPFQhR+8ad9pA0whN0MKs3kuLy2OPie0jD1PuLE4E9bz47knCxWaLFY6RBTvTjkz1NxOqGgmMQq7NqluYGfEK894p8+bUF/fAa24mPtv+xs2TcMzZLKFVB3wSdWttbXtg1Kapiucr7H3jWBO7pSWTiX5VE1Za3Z6hOh428vhaGo/EMaSoCwe/oFmvCfuAU+yH+NBX+tTmFIGh40KIru4BlyhBoH+ltohk1KCf+8PkMWbjusDkPlqIce8Iosa9T1CDqSmOKZpbeuWK4OWKIGX8GTHD8gZe7kq9JVa/had+2/33x/+7RcYnLY0mqtI/OiALBi+vVIp1+CODbXqUFZa1bn6KlM498nLAdAutU+c+WvHZVMQQVh4RAkGTfg4JoNKJ7cX/xU/yuLiBEEqpPZepcB62DZKSatz1hrJX/CgtrVP6Bteq3ZOiLyLM5WLrAkE3OV3wS4kIh6zWr0o6m2c3s2p9O+98xy3qGy4jhD9A1rz1mekjEDehf9LHQVKIz6dHS0z6hdFYSqWqARAqWh/AZfEJqcVDMOjA5/9u+xFP6Bhywq+16XLQ8pxPF7egU7D699GKXWCvtmKCKvPaNQWTwvsZwCz1EbQ9ITbJRqV+IEfrlimC1PeXSqPtrwbTznEGtipH4DN9z2heydXGwdv//64/8/L5s2WnqwSf9LWQItiQiiw97YoZZjlbv2ZN292qo45TIUY/oIJ6qToFOxxwiYDjNmR9fmh4sBubgE43FaPErBAsR6splSfVfXZ8aw0w7w43+DNKrc0eiwzmI
 JSFkVtQS
 L4+mxUcqV5sfh01ZDO3yDhg8Zxwl/plSEPJaIOBCXwX9es4hye/fgHndWwY1geLAMC3dAm4108ZxyeA14hKe0zl9irXY8XIZtARdidscbRvdz6tt9GE8rKwyo2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:37:46PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As pointed out by Dev, the PTE checks for disjoint conditions in the
> scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
> and pte_uffd_wp are mutually exclusive.

But you're not using is_swap_pte anywhere :) This comes back to my review
quesiotn on the series this is dependent upon.

>
> This patch refactors the loops in both __collapse_huge_page_isolate() and
> hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
> instead of separate if blocks. While at it, the redundant pte_present()
> check before is_zero_pfn() is also removed.

I mean see review below, I don't see why you're doing this and I am
unconvinced by how redundant that check is.

Also this just feels like it should be part of the series where you change
these? I'm not sure why this is separate?

>
> Also, this is a preparatory step to make it easier to merge the
> almost-duplicated scanning logic in these two functions, as suggested
> by David.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index bec3e268dc76..e3e27223137a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || (pte_present(pteval) &&
> -				is_zero_pfn(pte_pfn(pteval)))) {
> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {

You can have non-pte_none() non-present entries no? Isn't pte_present() a
prerequisite for pfe_pfn() to be valid? If it's a swap entry couldn't you
end up accidentally (unlikely but still) hitting this?

Seems like this is required isn't it? I may be missing something here...

>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> @@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>  				goto out;
>  			}
> -		}
> -		if (!pte_present(pteval)) {
> +		} else if (!pte_present(pteval)) {

This seems pointless, since either the above logic will continue or goto
out right?

>  			result = SCAN_PTE_NON_PRESENT;
>  			goto out;
> -		}
> -		if (pte_uffd_wp(pteval)) {
> +		} else if (pte_uffd_wp(pteval)) {

Again, what is the point of an else when the if() branch unconditionally
->out?

>  			result = SCAN_PTE_UFFD_WP;
>  			goto out;
>  		}
> @@ -1321,8 +1318,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>  				goto out_unmap;
>  			}
> -		}
> -		if (pte_uffd_wp(pteval)) {
> +		} else if (pte_uffd_wp(pteval)) {

Same comment as above, I'm really confused about the purpose of this logic?


>  			/*
>  			 * Don't collapse the page if any of the small
>  			 * PTEs are armed with uffd write protection.
> --
> 2.49.0
>

