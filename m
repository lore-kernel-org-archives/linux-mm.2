Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA72CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4DD8E001A; Tue, 21 Oct 2025 12:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C758E0002; Tue, 21 Oct 2025 12:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B488E001A; Tue, 21 Oct 2025 12:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23E108E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:36:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF85011A947
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:36:21 +0000 (UTC)
X-FDA: 84022674162.20.CFD9B00
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 27E1B2000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:36:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dSjPhze5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JV7K8ymV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761064578; a=rsa-sha256;
	cv=pass;
	b=yFzYrZ3GrIYWelRfyFywCdUQQ+VjYCTK7DP2g02Mzmn6dva1YvMCA7c6UJTIid+v1D0wOF
	et8L56GIe+BIiNVQgS0xlfytrPc+w4YLGjfD67VWD8nfsBAQnfLDb94vHZbwFhyCuU35Fj
	aEK81a/XBQVDCa+Wa523Wl6FxhNhAvk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dSjPhze5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JV7K8ymV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761064578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/IHYKZ+xXkYZGlmx/O+I+ZSmGFkF2J8g+iRd20kQi0=;
	b=EpGMqePhcmVtKhF6z2UeO6t+xt4VzlGnL/LoxJlFq8EsrZQ9ymUbKANovmCxlEpGxL9JVl
	HnEZzNSCwZqyOtC1Djj72p0hXdTSSKmlA7QCNMhT/0P7xE8q8N69GwdDvN2jNHhrgs1+VD
	JdTBcGFLsVQFIsdK0C1XGRkl85T97xs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEIcSd001986;
	Tue, 21 Oct 2025 16:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=i/IHYKZ+xXkYZGlmx/
	O+I+ZSmGFkF2J8g+iRd20kQi0=; b=dSjPhze5DJ4E8qVfLRoPbbKbUyb+8qkI84
	R308DpiUOHbm0zT3bQyFTa3luxkbiwxfXPxpYKmdPSpdsWL3auiB4Vu6mIlcJHKu
	Srr1TJihPXkGsRJa/5NG2pNxrAIEq6AvAA8QncmqR9wiNtEctVsAdLVV1rOYg0DB
	ycIT9bO2lRC3vHxjgcqBdeZkJen1inF3HIYZP25BqI70SqzAiuw1dc/mx01oMRCa
	41L25iDuZA0udaCf+xOCxuNEbRRUkOd2wuBFU3P/BOnsUnbgS0aoGCyAJH/xG5WD
	kAshAB+/w+78D4iY3aQL73fQL2bNjuLoMRbxbZXO91+iK8n3aAhQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d60q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 16:36:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LFkccZ007196;
	Tue, 21 Oct 2025 16:36:06 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcae0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 16:36:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCzk/opszGcFE/D4YgsIpAQPjsjX9oahmMibCtCI45yVm33rOXGU3qOouslUGoRldljzTPDV41lRc8Ebu2s7GHFJ7zBMCE8usxdkgJS/3H4Yr8TgrkAw/YpQLPdy5vNZ9GKUKVrsEQlkAmize0AmV7hUWFbJznkj6gN8LmUmXhcaiisgZEdeWn2rjFEs3KxemcglBzHP9vtHqBObykeBDP4UPn05JuhZIzNVqhMuFvczWxQd9H0GEUDLZrD5Hd3nVxFgDVeg1rU04U7WkNb+aNM0dCXRddgBaSwS2CVICWFMalOUHdy+GNV5hLE3xhSVbhvBJnttND02hza3+41oUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/IHYKZ+xXkYZGlmx/O+I+ZSmGFkF2J8g+iRd20kQi0=;
 b=RZ+qQWSzL7rrgfC6FjiX7DFD8M0U//0k46U55w+YVNw9ITA0OW22oUdPOo36yg0m0HqonX7BQIGFIo1FUVzxJRMvZzT5/MEmyXRcf6tXOmrLyl9F8TLlHgHuYeqN6789wk9uTjMQu5KDXCRswO6V1aJlGita2Emr3M1UaucOvlt/EshoqpWFxQPWHpMZRIZ1ppzMgKkxZEWRGAowM//Ms9SlGuxaW3TRACBOVOKQpUnBSgaCBlJfSshrAynZQG0wS2LmoRMP1dImUoMwPbT/7DxalaUoEzKef11rDUVz77e3xRHom2MXJJLRENd7X+RXSHFqCrtd8H/nYXLmCFaJLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/IHYKZ+xXkYZGlmx/O+I+ZSmGFkF2J8g+iRd20kQi0=;
 b=JV7K8ymVAYgQ2r+hY+5QRkhEnc6/EdRvvadX609h8+QWZZaMcwrr9ZfW1Z59LYAs1vRsBCLNrceyUtZfoOK2D89d7Px7IksnflQrNxE0eQY0pwIJOq5tDQOXhWv7NHRwdS/0BXDwXMSwdp0PFcpcjtPb6Ck+Fu1VbjaPBFWHJB8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5823.namprd10.prod.outlook.com (2603:10b6:806:235::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 16:36:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 16:36:03 +0000
Date: Tue, 21 Oct 2025 17:36:00 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <36e1f03d-1acf-4a2f-aa29-0bc0c14ee1fd@lucifer.local>
References: <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
 <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
 <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
 <3554c866-5087-4beb-8d63-6a3cea02d431@huawei.com>
 <16ca4c3d-7c18-4cb9-bc04-d2eccb5d9b67@lucifer.local>
 <5703e7e6-f037-4b4d-be74-8c256e7a3e10@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5703e7e6-f037-4b4d-be74-8c256e7a3e10@redhat.com>
X-ClientProxiedBy: LO6P123CA0050.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: 65978a85-9344-4266-4c7f-08de10bfecb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iuOKQw9DP6Mh8bS5QWWz6Y1RUcuDKEUADAFPYufo1WIagqn3tB6TyarqMOdh?=
 =?us-ascii?Q?rB/U/lzJiuPVOOjjFInN/dWXmGEyPFWF8LNwqO6yixkrRPS2oxWcfkDnTaQL?=
 =?us-ascii?Q?mDvLgY5HXOeYM0Rz1xSkOBWO+AE5DaiVSwoBN7d1VOMuwuDwEKwR+o0xwt4j?=
 =?us-ascii?Q?/POF+ewFD0aWqs6gSGNprjve562KHdmiD9iYa/Or1+tUPHo97JzqkSDR0GjL?=
 =?us-ascii?Q?XLRkk6woyzuJeGHqTIQrzktQMAhMghhXzpl9H4vZZ1RerHMUsPFUbEToJCLC?=
 =?us-ascii?Q?4RsiTtCzLXCqghMs4omKnDrT9rNdHgPs5CYzEsl7EYXwsni1PVAiS2deagQu?=
 =?us-ascii?Q?BqbFvvO9Yz19OYL/d2YVw7AKm5BkxBGDqG6eEay9qKBYF0zf96XJCJZX9mRi?=
 =?us-ascii?Q?aeddheNq+/dlZI8+zNxS5MxMALNjUy5w18pTEx7aJxlFhNe43qkEoYFMqO+3?=
 =?us-ascii?Q?CDXIOvd2SYghPjYVp4CnzXfqOoN49Q5TozgStPzRO8Ya2deAtGpKRF4gkwcq?=
 =?us-ascii?Q?gL+e52EK9PEW8QXGw5vqyZBKlCkRfL/p8GMCm+5kCREyYY0yNB0SG1ulFGix?=
 =?us-ascii?Q?TTiXSbXkZkJhAGyHeac/PA6CjQKOPgdhZcVeybgWFP1T9HpGugflMAvKBIAM?=
 =?us-ascii?Q?Rz/8HvhN6IEQWdUeqko3kYJ48hr6KAly6nIra5OS8MCM16Lbhkkl4BNRB/hu?=
 =?us-ascii?Q?vqEGO3cWFM779QP+iSwMikZfWrmnGvkaS5BDqlvK9SDCn2U22V/Qviw44ODE?=
 =?us-ascii?Q?RWF502ds71HMsUBKpHQFF88ufz/N1toEdwgJx1TbNeF3b5RoHz+a7Rj2yxvu?=
 =?us-ascii?Q?EozurttVVBNKs2/ev5xip0Bn0Q5VQK8rjbmE+ZE59LXT5n06K9oVHkux7KOY?=
 =?us-ascii?Q?CNLeFFHk+XepWs+AVz3yoHKaMxmhppICb5eQRskUpobbIU8ZZUbQ264ht/39?=
 =?us-ascii?Q?i/naecXMbEgx+xmSCAI3ufhRitAh/TEN5z7hZo6Tnwcw261znq+B1ZQ5zlBk?=
 =?us-ascii?Q?LiB4xrB3Q0LBvRYz4gv7leHlce4dHCOmT7whhz6FpH7zxevBsaiEh9+QuZj2?=
 =?us-ascii?Q?4Yhp9dAMDnnmcKIZ5aPGWILRSOBAO3OgucfRhEnZRacuG5nMOTNh8Hs/Lj/j?=
 =?us-ascii?Q?s9nYRjIEPVK5vgOB+LC1TXd2SDXSYaKjGrOWWiC8kOGgMIcDgHsfim9MSm2H?=
 =?us-ascii?Q?nf3Q3kAFduETNT9CtssLWGTpf8YkMl5SpHLAFjriimKi3AkCW3pX0V5DbbyR?=
 =?us-ascii?Q?NH59ou4zfoBfxuF/uVXWpI+Xa66VLPBrF6NnMR7OYF8gNiyXxi0crtwJuiyC?=
 =?us-ascii?Q?EeKhQjkFmdJa3xooXMCBw5HBf3JowYkMM4S3BbxGJ212Pr6p3WTNzoHAPCf7?=
 =?us-ascii?Q?11PeQ9AiZmwdaYWoFiTTymvpMK8sWNpEX17oW0jlYAnREWMlsApc7nin30MP?=
 =?us-ascii?Q?6rpthvrQllP2uwlCpxmgW14qPftikoXo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5MgjIAR0tmWKIWEEVW8fvQl/ovZTci/tzh4x/WKLjy3O7E7ufxuMwwzMKP1o?=
 =?us-ascii?Q?YEZR3McC/gpykCT9lNTPbfnYZ7LLfRWcbNyb3YZQWlNtGO2XmgehJnx3O4uL?=
 =?us-ascii?Q?yxKFCq8SjQAhRyTQu/h+kfXFJOPnfaY3tLFbHinZ4qu8dg16sDlKy+z8sU4g?=
 =?us-ascii?Q?B17xlsc6w32697O9f5qOXwQAzKXZ4rAZpTBJDHKB+93xk34zoicztoJq4VPx?=
 =?us-ascii?Q?Ygu8wqHkUErYmslypwy47N530qBlnKNOi7ym97YBII0IYFZvffRAkgBa9WDa?=
 =?us-ascii?Q?sLmu1I67gfLPpsCvNASaQK3vV21OicRb1DIujTbYIfQ/S1MidPRnHkW0KoHU?=
 =?us-ascii?Q?7r8GElZnODbZiPzzj5m9gVDsKBk/d1PF6NO4iEjDlHLJ52OHa62Vyb9OiS7v?=
 =?us-ascii?Q?MqEOke99cfacaUXqyEVE8Mmiiae7LPNG5AOLk7WEMwLiTlH0atlDjekY1JdV?=
 =?us-ascii?Q?nyNZ01l5BmQThOrXOa02yUzoP4yZ+OvnFievM7W01ONVg/D5GGA2uoe1fSs3?=
 =?us-ascii?Q?SuqW12GY1RdoCxkf9v/+tiC4Q9f+wCZH7Efos0/Nd6amUIr1WG450nAw09oe?=
 =?us-ascii?Q?Aee9LGLeV7iUuGXa6/KdffYjC32dbhih+vJR+niO3aT0xZRPQ9MpNx8MOURu?=
 =?us-ascii?Q?6QTlkr1+Jl3fOMc5ZT88e94wqDtI6fHrr9i3pycNfbCgG6eP6z48ute8HS8b?=
 =?us-ascii?Q?tD4zfUWRYaYkVmtBNZ/MgdMaro6H5VEvYiKLi6RdCnSM3FGrqiGGHFnVC6CC?=
 =?us-ascii?Q?h5RwchTqpqbsGT8cDnm3XRxMoJVM1pUDocxUcaMNXQ48lejs3fa9qqiZVX/m?=
 =?us-ascii?Q?Vd/exkpoi3ZPQTshp5dBiRA795kgPiy4HOPTDCmbCVlpj6UqyeHyyuy5Rxh3?=
 =?us-ascii?Q?DkC9y9nku71Kp47UNS8z7laLMjl4U4s/l1Tcp9nBCtI8gxAENn8I89xaDT67?=
 =?us-ascii?Q?jXgO4yH7B7mSBWUriAdQ6zWFCVWBlXX72czz5i+1PiQcP6mAUxJkNdQpqmxp?=
 =?us-ascii?Q?qic0JGefopNI+PhbmHtTmdm6870YwO1OpGGlQIcfqP2y+OAL+Id4Wcj9p/mS?=
 =?us-ascii?Q?5BC5NwSwbhH5aqbO5+MtM3ZBzi6Sn5s6BFzdx8tfQkl+1WkHbE28wkulfrLP?=
 =?us-ascii?Q?4s2lyZpSV0Q+OmCD5by4FRoizDJHV52OjpPHFVG470qBSBIZ64cGlOiyYhCT?=
 =?us-ascii?Q?krT6/yLgIZp6duf4SF0n0w2egAyaqzeEonNGG2je+mMnewljLUCM+nEKTp/H?=
 =?us-ascii?Q?9HJSrPm7ifaHPvtcasyCE/dng4JlvK9O6765/C9CMZOcxwlB4eZ2A368QcH2?=
 =?us-ascii?Q?oDL1FFzDlN+vLH/3209OCPUBwNW6/bKDgSqXcZYKtd4mgumDOjwbszruxLlj?=
 =?us-ascii?Q?66kY1xJH20qKjWup/NbU4R+10fnqnw/55TAVwSUBU9uxt4l+hUeC8UQQEczQ?=
 =?us-ascii?Q?iiHwmIQV0rRpz6BgfbPPjZeTtz67PeddLNIEqXU7PDaF2RfofsARyqSzCmwO?=
 =?us-ascii?Q?WD6DvnqzboWoyoyey01jF4ULmNlOGmkWtL/SXN+BzrFQjzhaXykavz5Wfo7S?=
 =?us-ascii?Q?SeBQFyA9V85n5YhBNO6Da4NQLBMXTcgmxPWhybI9PXPGVlCH67wJ0aUWJugo?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	poSHukODJrlKea6vyEFDYJYMqfISu45htPh7koSXAZjBuLvZURzK6NHOlxYAchF1CuaiF8+zw/2BsUfoNfVC/xT+0MY/ALazabdaZIIHf6uTCNSwAgkhEJEjs4DLIKPOj7XLNqyqrVOc4l3z7s0DO3uh1nRKe5gLpFtnyPX7VXFloUQCljmZ0NtjtcHGDGbZP9Tf3GkRZpP6HnFMaH0kbb1N1OXnxMM3jMaj/doo6iBLykk+yU0Z/9EX78Zqw7E4RQ9L+EKUELafSvNScLpWA1FDt22Y9ekthMt2h6XxrTMjqR9Z85+NrmB3+Y+cenkp9+k1K14zsrLGE+2G+PX3l78nFjlUp27r39Sl1ZhsUcpSzZZeVOnGxDNO31cLAmWeB+oizct8nye5zGoCzzdEyOdo7m8GvN8FJAOYkT5Bx9uJCVjRAIK4NZRXC2eniD3gDQ9tWL8d7qAOUnBBbk2GQM1X5uGw+pCYUFjhMAHl//6wDfpec0+359iBo23GcxrvkbpHtRiE0zohCEZfGDyAAyb2aLT6jJOxeyIWAX5XyfyU/4AVGfhcaQp38VHOt5hEF92n2TEzvc2BQgDhwXe41VXKM2viDlLjt1qnZCC8oiM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65978a85-9344-4266-4c7f-08de10bfecb2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 16:36:02.9817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0z+7QMCsZ7+X+L/Z+BxV1O6qPv8aJgzakkawnzLapMJ59CIhJX8LoBfBJAYW+gcta2mA+84bUaEf9VZZOnPIJkQHYJs80FpzgRFF4llmvhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX6e+wQxtU1wLC
 SPa1zZhWdvVnPsWpxOkhM4wlntG3DYUXukaewA+OmlZRGE1fZyi51MiHO5L8VTmutit/mXN9nIk
 tMmR1d6QzSegCZq1NpWOQH6AcWmKsNYqs/YitB1d9cR/DDulsoOF4n4T2TJG+cymhXdhOhonSeS
 jiJTI+pstgT1jizG3UKJiQpfIyyV5lrUPTOB7BAW77IHQ8gSFKami4ewDTlL57KSc2JXTYODWjh
 Uy0FYwShOCZnXpc9G2R47Sy7igy0+drZD2q2Q8Rdv74dRDp/So+Ea1EfU0l1C5doQe8W2bLE51x
 I/U2ek2n3x830J43o9UlK9sNIXd6xp8GmZ0piYrK22CFm3AhjxhrviK5NGOlv1AY6UcxHDz5PoC
 IfoLEIWCh+dvoXqzT0RwKkPSJvTwTg==
X-Proofpoint-GUID: 97Yt6-bAHTZE560uFkHTMhsIF8MVTcbv
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f7b676 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SIQiLQehMSBD3qccAyUA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 97Yt6-bAHTZE560uFkHTMhsIF8MVTcbv
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27E1B2000D
X-Stat-Signature: fo8kf5os9errifgqnrymj9x9f7ups5jx
X-HE-Tag: 1761064577-971732
X-HE-Meta: U2FsdGVkX19cz+xlDQyEUJ+UFdxF2BDyPj9OR5ftfd6egbYTNEJpNGKhFXvAbH7WeIU3W20CvDqab/By5uDjLmvIGnYRU5McHzkB2kPasjniOpSmbBy3qbWNINkbqn/rq9Tfzf2kq5x9yco8YHmuN3DvT2zlS9D4PvYeoIwmWKpTbbflPDtfvZnU9M3wX9rTM/Uf4xJYU0DFCqe0R7fo3QrumZmE0Yz0B/tvsR8MaFr3VtdwHyp7f1eRSxNI6cmqqnvYji1tD7HumPt/leaR0Q6065gsj0FE4RY6yg3n3qwybNGDA82v1+AP2BU7YhuodAmZaUOydnS9xRdJr0icm9q7009hKcQyptwNsz40M37rDvcevLpNU9YiJuPgSzoqj1Fa+AzymTSOUhOFINySRs/5D7u/crKgQjtL2jREhELrNV5oWO899Cp8teu5SFyT8QBhSLQ1nXPhh3TSErHDIcUGXxGPATsiH4yLid/lwPYP3NCTQoaLsIjNrGAwLejReCQROeXGvP0ZZb0/Y13EQ3jb0PLxmT6a3BrgLCM07Y/HrGscdI1Mg6iP5FvzAxdXsu9yi+RK5SDUx42F7fHHXN7tY/N0aFde0faf/KWwV0PNXaTbP6ozor30l9jWHVMX8n/CcesyG0z0d7yNm+qRsupwSKYHnLFuUHqHKEdF2XRXZ6w7AX5WPzwt11GWh8zI+YfM0a+HPavTIOKfkmtHBw9hy6NeaYHMA7U/ik74F7sqkLTboQRu5oHyQJdeg6JZAFP0prmgXiA4L9gkjEmHHwu0UhJE9Wda/y8FX/a6aa1eDoP5T1iHAfITb1aTUBv3S/A5RgWCDAh4JRDd8cbB0E9mqhi9YJTsAUBZyc41WXxorXhUG1EH1utzdQsNOTw69kcWQPPOH9gbgrQEGUfCEPjv2+nW0utQyym0NbT0giw7nYW6nXQgQJ/qA0zj3gNGDI+UNCM8N1JxoKz4sPX
 FF2B0ZVd
 ny04CYcLVTC6Jv3iu/6v3BEf0UM5hs9S3RV1S5I1kyKfqnaGXgJgDgNlFh2GqZYFC6/m5VCjvXDgPv32VuH4XNnz2zLjYTl7JGD7YZ69wl/TEz/ScZUw5clWsVx7XuzVj5P5pkwBgjji6egCOE5eXL8wCeiq6UzUzc71ihiYQppDAPzTLKrSMnUQBSUfyoQ8R4a1fR5sa3aGvqEXoDzgyBg85zyJgWU4cizCUsAL2mLSpDSuKS9RL14Y7uezFNtTAiDoz5P5zpVg94FchgOFdku7limGlQSOICJ7SE3Ypus6POLT7CfXNkFTLK+Tnwv8MmKApNfi8A8wIohc00sK7uwMfM2Zbw87s1393Hn2DjBAoyTdHAjXE5T1qVjKfocRR27I2RfaHOhG3hAFfF1BvEd8YPYYQ8JQg5tEKPVinreg6jkesWCzd7RzO43VukVetRlH6sAlKBKyvWoBBzFmRYftWqRV0mtexsYYcpOyWdlBIcgEbD1mgXYT6+sxGurWbZZflQcDtwGYARVTXHgSmfdsv4Rim8SsrvszTcrU7eed6LFIM/6E0H2ZFaqXjYxlX56FKtbXH9AmsCAyaagxZowoCB3Mn9Z+pqMuv/pBEi/Qz429+wTCWjrfib4ewfRWPsQnE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 05:01:30PM +0200, David Hildenbrand wrote:
> On 21.10.25 16:56, Lorenzo Stoakes wrote:
> > On Tue, Oct 21, 2025 at 08:54:08PM +0800, Kefeng Wang wrote:
> > >
> > >
> > > On 2025/10/21 17:45, Lorenzo Stoakes wrote:
> > > > On Tue, Oct 21, 2025 at 10:25:08AM +0100, Lorenzo Stoakes wrote:
> > > > > On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
> > > > > > On 21.10.25 10:41, Kefeng Wang wrote:
> > > > > > > Maybe folio_needs_protnone_mapping()?
> > > > > >
> > > > > > I think prot_numa should be in the name one way or the other, because we
> > > > > > also have ordinary PROT_NONE unrealted to NUMA faults.
> > > > >
> > > > > folio_can_map_prot_numa() semes to me to be the best choice.
> > > > >
> > > >
> > > > I don't want to hold up the series so if you guys feel strongly, leave it
> > > > as-is. But this reads better to me.
> > >
> > > Let's keep things as-is for now.
> >
> > It'd be nice to have an argument as to why (I did say if you guys had
> > strong opinions...), but never mind.
> >
>
> folio_can_map_prot_numa() works for me, so we can just use that and call it
> a day :)

Thanks!

Kefeng - Since we need a respin anyway, and if you don't have any specific,
strong, objection to this, can we just change the function name to this please?

Cheers, Lorenzo

