Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E524DD4A5E8
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567B56B0088; Fri, 16 Jan 2026 03:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB606B0089; Fri, 16 Jan 2026 03:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3783F6B008A; Fri, 16 Jan 2026 03:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8A06B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:39:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B82238C0CD
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:39:23 +0000 (UTC)
X-FDA: 84337177806.09.A081289
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 421E5140006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:39:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SKeJtdT4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RmB86pil;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768552760; a=rsa-sha256;
	cv=pass;
	b=sNVcjho/3csPPQOYxJBhfRXtfonMLQcPdi9JkHk147l8IMA89J/mv4P5gj+Sa1O+67vsJq
	1cQKwy0GWR8lsA4WXyH3Uv0EZPBgNEciypcPwXE/eEtzF5IukSG/L2CbU4Waum8r1LxKO9
	CGOVHidjHTfTbsOwlLGfdBm2RxnvOBA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SKeJtdT4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RmB86pil;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768552760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UY5zhubnKtAxaUeMPdF6SvqOUVabPwoAKfCL8SwDl1w=;
	b=C+CnKNEj/eOtX0gUn7Ao+OQ2iDGQ+kM7n7tuci3zRii85PKZaRiKrDkq6gy5xUnvCVYxNW
	LYBk/y+9fXqFc/maRBl+WTLOahHShw5F9H5BPSNGJmd3mBt2vyFtdkc3yG0wYycuxxuD4P
	c4ulJk1olo7oRJ/9yuXpUl4LGUk1VmE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNQNo1655716;
	Fri, 16 Jan 2026 08:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UY5zhubnKtAxaUeMPd
	F6SvqOUVabPwoAKfCL8SwDl1w=; b=SKeJtdT4Jy6Pln7qMvvXL4TBoueWyBXsWO
	fqiSjAg/dgihIysZNwac47Y5kOW6gVa85NRPMlhRLMYGkU62nodLyhFCigjjqK/a
	5iMl91PskxApyshvbUKMBh9oSBt2xkkY2Eg+iAhXJbavJaYcjMBM/U/msuVMsRVH
	k3dpWEiWyxYw0XwPeTyx6vb7py4QAVb6j9cuP2udsCx/n9MFUkmM0z9xwe4FeKoC
	09feQ7IegY25rwmi16/MWNR/vRsFo38OCFNEUXFeQesmXcQf4qOdBXuND9sNZNuv
	wxtIK6pSJypFtDhDVj4jU4bKYLT9FAAO55+vuBZwnKNcFfapxoWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc4xj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:39:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G7ftHW026047;
	Fri, 16 Jan 2026 08:39:05 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cd2qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:39:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wSGKg028aefra7Ppdb4fQMVb7Qs+/02e17JZcN8tbfsWId36kjp9IAta3i9sR5Rqh34ywdesvSw3UuW2oA52KZQ2PFhQyi+Drk/RLk9natjhCSbhrov9vg0boATdOQXTGHTfHPUKUqCwGGLdafAGmSFI2HSzaB+Oyxu06+Rn7mTzN/lRlcG26Qq60Fs4/9DkdqKzufSWL275t+3/ciq4/jTMH9TiZyGJWG3nOo1RxBikP6J+p59oAcm0lB6fwRg8dsjFrw2Jbk+YzP9f6H4S7HuVPmdkOxgqDSYBPmXi75RZ855OHn0GLmxYQn2KGNSfQGmRRWBYd/Alc2caA3LMtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UY5zhubnKtAxaUeMPdF6SvqOUVabPwoAKfCL8SwDl1w=;
 b=jpCL6G7MizOXIKl6jxVY1QCNYoMgcVnUOH8trgNN1vstRok9vC0naoXcg5vLQTyhL4dIGJVfQpjuGd2Jk3ULcYZEVgMJs4kN4gnJIVi5NXM7FNq1jag1ZlKRD+Pm5XdYq//kFGMmkBeQPrKPZPjOdIX6WOT/ea61mKiyAZK4FWa/5tqpF/qCvtEbDFH8f87tOFaRyYAdzxezy/mkWsAlr7Ffnx+OAQ8UYtHFxLH8VWbug6EdQ2l+q9ECzRlF9a1lTEB8SJLiCOzgtCXkc3IayzFdYklweee7n+J03Xgt8qOvb7CPOp+mEibPJgBe6QnRdDHNDiIibHqP0QIsrFPupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UY5zhubnKtAxaUeMPdF6SvqOUVabPwoAKfCL8SwDl1w=;
 b=RmB86pilQyInpXbR9MjxfPUqDWT1YosDQNhgL0VnDsulQn7I6zZ5JKnDAn11oeP88VC45mbW0HFTZmeVH3LYwVVNbng3sVbzo+8jPCgZRb4wTptr+uClwZYWdCNsTcXhZAQp0wass8vTlcSTVFfbwJOZ5Rkk1uRXGKoDfLFUqS0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CH3PR10MB7932.namprd10.prod.outlook.com (2603:10b6:610:1ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 08:39:01 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 08:39:01 +0000
Date: Fri, 16 Jan 2026 08:39:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
        weixugc@google.com, david@kernel.org, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        ryan.roberts@arm.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
Message-ID: <343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
References: <20260116082721.275178-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116082721.275178-1-dev.jain@arm.com>
X-ClientProxiedBy: LNXP265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::24) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CH3PR10MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1a334d-7050-4da1-2ae0-08de54dab2c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DKNDtSIsHCkpwwrgFRTTRjnO4Yh9ErGRx3Msccftb8Sg8CCeqtAgJuoSKeFv?=
 =?us-ascii?Q?5K0dTb7tKgIeLhTwQPxOk5A9VZoaNAoiuxyvBV8O6RLghYaZosQoLJptv+gR?=
 =?us-ascii?Q?79ypnMiY8woUKTVvglTlx0uxtHuDPEz7VfF22IJ9yruoF5CKsxrWhKrSBR8T?=
 =?us-ascii?Q?JgQFYq1XhA94T0IIU2aQHzw1HYS9T/QerpEjaOLDntEgxSUBzwFZPgHeiahl?=
 =?us-ascii?Q?VfisnfFXirZYT3QqJHftgtR1XczCbTuLBJIRa/6Q4AfVGJ6EFsRt24UpAF8D?=
 =?us-ascii?Q?QJeVE2mL3cznBpsHYqpD+DXWG82aiMl0f8jVGUYP5PcheO8hks6xW30sFQ77?=
 =?us-ascii?Q?RlvdnL3Y0qGCpEwZQqcSd7rr0dPNNZaeNiLuDx21JYu0Mq5QmMC2OTZ2T376?=
 =?us-ascii?Q?p8ki7GS4oKHV14+/MPFI79DHGVyafsEy7OAXoqIbXvQc6n48gwibitQzUZWv?=
 =?us-ascii?Q?jWEzel1Q5T5iVKlBNqvIO+KiCw7TQ2fj+pEvf6IEathcQhWC/3sI+SgxNw+T?=
 =?us-ascii?Q?bX4/rTuqXDXRl31dS3daeJ68sOgg9rZNtTPVm0OXqSwV4r41+T577sDk2gCi?=
 =?us-ascii?Q?CgckiOVO+C1evbHQGVSzhiRcZ6yP1h9n3Os0rGOaJZLcJAYq+qLbIwRnwyIE?=
 =?us-ascii?Q?bN3mKDu4zt6lK/89yrMSJE5a6lGBxfyMEIiJtkfwX/uDqXqO1ZVeBygBpZl7?=
 =?us-ascii?Q?UgwV6pPIXSu1AQHpxRGaEWd+x7A1tZvCdsJ5fDX9XP7aETuwAejLqLiof0T9?=
 =?us-ascii?Q?No1riylFWfQYf6zgoNbHezdKKWBOuM5zGJQNU/DjyvT8R9mIZ1KIqcsE8kHF?=
 =?us-ascii?Q?Drps3flxf8bFLFR2rDaZWsL7eEtr/25H1oaOkbR64OV5WlfnfiDGbVVinstN?=
 =?us-ascii?Q?N9D/g2qitDdaqRlbRz3WzAS/3GqYChSUMlR29IkI53TAkLHCBy+UzMYFKfrk?=
 =?us-ascii?Q?Fwi/35vECX43d4uTV2G+vHKt2HauEc1yPOnHXHYMwGQaom6viZxcYA8A3a24?=
 =?us-ascii?Q?ZxiEZffBmWYU01ihv7G062g2jL+A9akOSo2DEGM3dwbnPCLY9LUgkscwhAWU?=
 =?us-ascii?Q?BlST+lKE/UuN9YlEUKGiizO4lJjRaM5xute8m9hzaunxtOJnses/VCO4b1Ny?=
 =?us-ascii?Q?SjmJBpDWAMHHNaGdmyAimjLwFsz740M9D07cRCqNpN2jPsUKMsPzCppiIAw4?=
 =?us-ascii?Q?9B25XMJfzXX3o2dOCdCWfKd96Bf86XuBJCldrUZlaJ3GYNqIe08FL7yDYbo5?=
 =?us-ascii?Q?uipu7XQ+zHN3ohxlAMZ8Z1SPqgquOYgH+noc9gEGE8reP2fkzvIze1ymhSTe?=
 =?us-ascii?Q?8ryCtc8YuX2dYBuF45l/XMzBjSBzFKt0gzvS6n2Z7paBNSdyS6m8SCKWibpp?=
 =?us-ascii?Q?9pCELECOfcSiXaMqG2i2hFlSev+GEkm0wZgDKEG5gAHHly6tkZBNN48nJ6SV?=
 =?us-ascii?Q?pVZST8/UJcSHOeFPGTOXmY0V7P2E2pJkUezrfLsoVsGVqMxzmQG0TARLZ0kz?=
 =?us-ascii?Q?llUejVj2nsyYXqYmKKiCWPAUGx83VRs7s9FbwM3/NsPbSEc0yyjEZBGxOEAQ?=
 =?us-ascii?Q?uQ7w6ZqaFJpJBQAnorU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fobwl234aweERKyiIGu2FXbPCjS1mOzlnNH/2CyZ6mqBSLKYuq+q55fVETuL?=
 =?us-ascii?Q?RWOcS6xWwvY/Gy9/qt/dHRyZSQHYyxGtYA8+sK9y5ak8iRLwAPNYIGwxa0mr?=
 =?us-ascii?Q?4av1pjkxFW/w4ZHZqjAfcG5kiLGb3m8XmoqeohPfqCoVRJP2DGAS6xL376VW?=
 =?us-ascii?Q?d3LOP68qMHfuYBG+EIsM0gLoepKsFxtbwv/T/o9EsVqgahcn4Fi7pOxm3e1n?=
 =?us-ascii?Q?G7nNems0ofEwYgCqZBHXPi+d39C2OQqHNJvMUEO7+bflk2klpyyba6/FewBS?=
 =?us-ascii?Q?Gxv/WqP+n+WsX0oBeEvuVHmd2U4gfL0up0+4hs2ye4Yuh0a3/Rdf2x5EjgDZ?=
 =?us-ascii?Q?fe6TTvrZH62q+nzqoDsy0kNaEFNSfNOI7ratn15/cInEPe32VT7z5NoR+Mfv?=
 =?us-ascii?Q?ipU/okAFnXD6a7Fl3+gydBtRkdMLLmTJEQYJ839s3OMzGKt+1Nr8m9nNIW0c?=
 =?us-ascii?Q?uZ3xA7OOKTglO+LTRUJDkml3c4OLDM3Izp4/DKzGbtfSmI6aNsOYFZB2F72k?=
 =?us-ascii?Q?2QPzcWIeh6yHqGUII37qzizLs51L/wRQvovvJ4O9EcxN5MsAWcRSRoeO1hTT?=
 =?us-ascii?Q?2e/j0amokhDl5tcFoRBCMl9eilrfEpPd4+Ghd3dD6re65MiepSJ/5KZIsMJb?=
 =?us-ascii?Q?5TezJRalRsTxbdsOG6BnE4JE9UWSSQ6B5AeyY/gJT/b7ZZoS44xKs4ZQkhKx?=
 =?us-ascii?Q?wO9ED5c2ghjPUblvPo1afAHkQ69uYoDFAZr/eO/LuYWXbkJ6VtCDaM3ln0Vd?=
 =?us-ascii?Q?tCORWxvy1gIITZ92uhZLA/XQRD2pHuObRYiMB2k+uVDj3aD5YWs6aOngk4/D?=
 =?us-ascii?Q?9S5coFoR1DRAL/oeIk/aqhknZ9Aysegea+vG6w+mHn42vxDpm7WMaaIzTZhO?=
 =?us-ascii?Q?gfCuWtEqmwz2hqK53u8FKClGdQ9H3zdcSxJGYThMuFsmf9HWAO1cRqt5W0RR?=
 =?us-ascii?Q?mnAxECJA041W4o4n65nvROneejTBBRErCT50+5WTaOIVxJX4wXxaWA7+hEHA?=
 =?us-ascii?Q?hLsdktCtE6LHa8WK8XbAxfeaemJzsfr4cAkE8I8fdlcr0V2RDn+9uFVZpG2w?=
 =?us-ascii?Q?QLJnanQjBVbVpPpJ2DDMbT6WKlbE9qwnNXcECQbJ1sof1gWzvPB9y5jwtUBg?=
 =?us-ascii?Q?R8EeTi6kEHIvr/xTLvOrTtM88EHXlk6J1VQFzgIZAyQmmlaEUctke2V/Qeo9?=
 =?us-ascii?Q?Ydg5elTXkRkgJvK+PLxFP1M27h+iVqx3ESS/xBqsgK/k3EDJpiZSJImMGD2I?=
 =?us-ascii?Q?UN2xhIJjaXv0CKKPkYTBTkNu3aHvFIGbxydUbX40qiDfN9LPu6JzHXJQ2v3C?=
 =?us-ascii?Q?UMd9GHkhUqdCrj6L0c3FeiOu01/JuIlC57KPcWeWWCBRQA3xGVaot5TXO7kZ?=
 =?us-ascii?Q?hZtH5qtldlyD6oahcaJKjyW/i0gugvR/WWCAzfjwgP4dwPRtwZEkQWNQZ1Va?=
 =?us-ascii?Q?zM66e5MLNvbJuUdUKtDOmmu8VO0PdvajzjRCTLpgE9rzrm1YRRio0e8JF+wn?=
 =?us-ascii?Q?psi7Ukyk/MAXbnEgkfFS0192EiyGa7Ty1f5LvqH3T99irc4DBgEBVaZaP7wg?=
 =?us-ascii?Q?AfAYfOXsrxRpI42FQ3xmg3bnoYmQ0OF88YFTnGWuZvIIGAd65tOkI8kDq3qg?=
 =?us-ascii?Q?KSFYVoet2J/is19D2TGvfDgaDnTh+Q+IlU1jg8gBD9mF3ie14Ju0hpST0ja8?=
 =?us-ascii?Q?HS/6b4gtAiXQJWE2Yw3jFnOaBAxCZTrfqiyF4QJ1tglysbfbVcgSdFtaWi78?=
 =?us-ascii?Q?hORwzL6U6rIKKyfzuWIY1X007EiWp78=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f9jykFTE23SOvxE16n9A8wMcxZtQ6CNKPRMCEj8SD4gCuzrdGvkIPieZPSnI8f0yrNDbO/IyzuveyeXDiWYHLIjQoNTtvddXhCQRWZ1D0R2CavfAYuDLIiCeIDYQKidhpijL2IZLxfg2xo0UbCdHftbLIA+WJ3CzVvmmYsKSiFSwEfbigTNiesfn4BmkkrViI1Ifk7piGMAPk4woSn0SzmqzVdYIjERbu2ZbAp/5+vz49rrC48D8Qipl9PRD57KP2sHzSjHjX6AsIJPXHjVRktbgXib1pVVFCR6H1x42tt1ucE1+gLdj6vy9uWbmPEsfj4IOsjA0zqWMdEwuysBjxvjqX1AJYGH+lUDofvvta5yW9RJJcws41BgYIy8aOsRuKn56OBCnoF84rxc8zxL6LVL6NBAK9IfjBjVn1yILbpH3nJkf3BPJDLgTPg0Y/JKW4U3IBAE0FLv+C0oB53+DEwBRARDUgYeh1MGMo8Bk/mumGGVBZs1XxSTz1alZIl3v04ip+wnWWlFThHROSRyIizskSCb3VzVPWPyJ9CVjbcIOrt/jXw6pittpG+n2UTskdU1A1eTnZavoAXSRBqZ44P8Ldq3HTRbTfXVkxm++fjQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1a334d-7050-4da1-2ae0-08de54dab2c9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:39:01.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2F8dgfDv+HetaeKnAK8bk/JKT4ZPxB5wGFaC2C5xtLkFyGNdj1zpwkmUM5WFvb72O6dgqXwGuqJyeCQczfKNILJ/fWHWkJvgo4y1m7Quvuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_02,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=990 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160062
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6969f92a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8 a=fcEnD9nNbkfarDs18DYA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: Mp4hbfMTTv1zsMtnOi-WZ0q8VyfdD7eH
X-Proofpoint-ORIG-GUID: Mp4hbfMTTv1zsMtnOi-WZ0q8VyfdD7eH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA2MiBTYWx0ZWRfX2f7Qm/lNK6I1
 BSSGTmZh2PDIMWq1teW0U+5DBHnVCtFVHKj2UMwONXqu3p7j7y9UGDUyr54TV1jYvi+KTwY44ab
 gZcNKRwFKRLMH1B8q+8hxnPFsInlRHiKNQPGcQi9uJOjNfMPjM4YjezNl13xOU7FKc/x2zpzztH
 /5cPIYg+z+H+vCipXwpILG5VjO4Xmc2WhMnhN015Ehe07Z3HXT0g0ITGtFs06tR1PcQrqAY3EyL
 PScPF1sU/N1OwmAklen+pC9OOZyEMk3NYfXYeI/ZucdbutT8Ew6IE5Px8QWpfKw6DjvCxI4L6Yz
 vmjZa4PcjF2oF3D0Wpb6qI2WggApBoIKmvn4yt1kAzLvZEkvDPARzPLlcgUa0lD2kBMwpZusJAK
 Ndw+Gjo6dUpg9/1ubP40SJw0L0lUoLRc9cJkOmxv5sh7RyB7Xn7nz/zUsMJk2/DUFAm1xRJ4baV
 TUe7fkAUPDX0rcEIcmQ==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 421E5140006
X-Stat-Signature: zfymuw6zmctgh953zdd4pd6ju8ubmdiz
X-Rspam-User: 
X-HE-Tag: 1768552760-52851
X-HE-Meta: U2FsdGVkX1+xHhvVIhNAwsbDWt1/P+KLXVBAbRRxRutpo02MyionT3WeNTH1yeQB/zs7heESnnAuteDjH+0YnMoZO9d34iWyd/tYyWZPbs6gS7MrdIsLj88xPJq/wez6mb/ehOGeS/qvIesCwVbVtnWduxDe6jmwVGva77d89O5eGnaIS3mnSnKWBCqsSDsiFh8s0hFHKvbYOkrughjoGI3Rw3koYyE1X+rxPjpiH0NM9knN68E+OKdO0pRnERZ3ppihKU6CEF1zwGDsYdP8YQx+RVSKt15m2rh4UQPxRtZQUD3CA4IPns8SvyAjuCv0L88nMFvJUIKB0Vaey1pSjFj6stAEVYZFFboDfcSr7zHU7FXb/LnVwfW7xjUZhte1AOhH++DR91IsdLoV1L+6HFIdgcfT/YvZT4Y1TWo1P04CPoc8h/d0rSXySkstE03kc/5c3p5eilOBWd5ShpcdcnNYPf3qczYqhaI8YKqtY5by9iehZNh9RcGUkYOkmd1LTAxiFtpPlB0U2OxzA4IonOdzL5XwSJ+6ZjbIHfMebjYhieHx5HAI0cuZFnESnRYyeEr/DTvgvnuRj5K4tgyJbs1DxWet4g+g0dgf4gg9KjzHCVw8q1d5NY+WYSQlR/bZcXo5ZnL4lawaR1jq8rVBIZ9dj4OnIGCtZuyXRMCZD0sRFdqBTGGbHOUAemjftTgBf51xQdTkuRiuZHQ1Tjtfqbg1ZJJKIN0a87IgmzoDr6nGszYP/4QiksqA5YLMBhkduKezvcXt7cn4B9K0d9VzZ/M+2hKXnX35EcwiOJaxlGOaE9BOjt7T2EJLAugFOBEZ4/UXfmI5thDNrMDfmh9PvZtAMlj1Ct9UjKDNxFBr/v7KTWKJgQsmLhZr6kgnvW75xQ+m/QuCQG+G21G5W2yQTDEkDv/LdImdQq5amDq6ovNBlpSUv8K7fGoTKQWIcObHDv6z01pGZODKM3v4bws
 /DOMgWab
 BJkeG1dllkeIV4dOIkDmyLAM96rKFV2o2YKosTllg9AMienx0GDkggRoILWz72UIkDpeDLlCLANnxvg0NrMRg1J0aihkECymZQicT5RMU/QWySKut8OjrObeFdJ/X88OIXl3UHdDyHsOBchBExQuWpPURYDCXyhdva4LMgn6o0XWWODUH9VK7RaFqK0daZ6LREXRcmrlg2ubnumktSBW/Gb75UDbOSNuP9U4A6rph61GhRH6fGlGF1f1Z/Qzfz1TsAcckZkAX83edArP4ReJyOxcjOoNeoCfZJREJHeKH6FT+Lwl+dkuCN2knfUXCl89zmnIj7gPzEhFamjS6LAaH4+d4QecLkw2JlEeCqyVNI68+JyhPKU2t3pfFyz9bmO3MBMppIDU9cKNbwEc8QDDH18qw90nBGvNrMUBMg9brVMVGzqXMPSIFclQqsHXtBBt1+F5khzjSowAjco152UE/TmejKrKn/pEjr/ztAVmcMYmkz3SKfwy+mUvuys8UTtCzh8ZsOotDzIkGUYK7ugdy7sN6e5jMZZmH3wPdKYQAvvMBTP9+KLQugr+ABQByO6kFB+vo7dfyircuzMYxnsvIqXzY2SCS0m8mwzJEYXBeTtP9Itax2JBACT6ZacgfYmUAcDHQSShthskSZhLUruw7wJaC2oL4S5iE3dETG8sP+VS+n7Som/5S84IW8vrGZXg4nfQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 01:57:21PM +0530, Dev Jain wrote:
> The recently added file folio unmap batching support forgets to update
> pte_install_uffd_wp_if_needed(), which still updates a single pte.
> We end up jumping to the end of the folio in page_vma_mapped_walk(), thus
> setting the uffd-wp marker only on a single pte in the batch. Fix this by
> passing nr_pages into the function, and set the uffd-wp marker on all ptes.
>
> Note that, since the nr_pages passed to this function is always derived by
> some sort of batching, it is guaranteed that the set of old ptevals of the
> batch have uffd-wp bit on all ptes or no ptes, therefore it is safe to derive
> the value of the local variable "arm_uffd_pte" from only the particular
> pteval passed to this function, but apply the result on all ptes of the batch.
>
> Use set_pte_at() in a loop to set the markers - we cannot use set_ptes()
> as that will increment the PFN, but we don't have any PFN to update here.
>
> The userspace visible effect of the bug is inaccuracy observed by workloads
> relying on uffd-wp regions to install their own pages.
>
> Fixes: 8798e255b5ec ("mm: rmap: support batched unmapping for file large folios")

Hmm this patch isn't upstream yet, so wouldn't this patch be better as a comment
replying to the series so it can be respun?

You only do a fixes tag for either upstream things that obviously have to stay
in place or perhaps things in mm-stable immediately prior to merge window that
can't be adjusted.

> Signed-off-by: Dev Jain <dev.jain@arm.com>

Let's replace this with a comment on the series at [0] please.

[0]: https://lore.kernel.org/linux-mm/cover.1766631066.git.baolin.wang@linux.alibaba.com/

Also the original series really shouldn't go in without signoff from me/David.

Thanks, Lorenzo

> ---
> Patch applies on mm-unstable, commit f8ed52ac0cfb.
>
> I observed this bug during code inspection, but it turns out that the uffd-wp-mremap
> selftest will skip some tests with a bogus complain that "MADV_PAGEOUT didn't work,
> is swap enabled?" even when swap is enabled. It first sets the region uffd-wp,
> then swaps it out, then checks through pagemap whether it got swapped out. For
> file folios, this check makes no sense since the ptes are simply cleared, but in
> this particular case, because of uffd-wp preservation, we need to store PTE_MARKER_UFFD_WP,
> which is stored as a swap entry, that is why the test works out on a non-buggy kernel.
>
>  include/linux/mm_inline.h |  7 ++++---
>  mm/memory.c               | 14 +-------------
>  mm/rmap.c                 |  2 +-
>  3 files changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index fa2d6ba811b5..adec1dcb8793 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -568,7 +568,7 @@ static inline pte_marker copy_pte_marker(
>   */
>  static inline bool
>  pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
> -			      pte_t *pte, pte_t pteval)
> +			      pte_t *pte, pte_t pteval, unsigned int nr_pages)
>  {
>  	bool arm_uffd_pte = false;
>
> @@ -599,8 +599,9 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>  		arm_uffd_pte = true;
>
>  	if (unlikely(arm_uffd_pte)) {
> -		set_pte_at(vma->vm_mm, addr, pte,
> -			   make_pte_marker(PTE_MARKER_UFFD_WP));
> +		for (int i = 0; i < nr_pages; ++i, ++pte, addr += PAGE_SIZE)
> +			set_pte_at(vma->vm_mm, addr, pte,
> +				make_pte_marker(PTE_MARKER_UFFD_WP));
>  		return true;
>  	}
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 6b22dd72ebc8..35ac86d29e77 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1588,8 +1588,6 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>  			      unsigned long addr, pte_t *pte, int nr,
>  			      struct zap_details *details, pte_t pteval)
>  {
> -	bool was_installed = false;
> -
>  	if (!uffd_supports_wp_marker())
>  		return false;
>
> @@ -1600,17 +1598,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>  	if (zap_drop_markers(details))
>  		return false;
>
> -	for (;;) {
> -		/* the PFN in the PTE is irrelevant. */
> -		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
> -			was_installed = true;
> -		if (--nr == 0)
> -			break;
> -		pte++;
> -		addr += PAGE_SIZE;
> -	}
> -
> -	return was_installed;
> +	return pte_install_uffd_wp_if_needed(vma, addr, pte, pteval, nr);
>  }
>
>  static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f13480cb9f2e..d6ca002bf79c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2171,7 +2171,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * we may want to replace a none pte with a marker pte if
>  		 * it's file-backed, so we don't lose the tracking info.
>  		 */
> -		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
> +		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
>
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);
> --
> 2.34.1
>

