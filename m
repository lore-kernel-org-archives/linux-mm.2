Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E833FD10F4D
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 13:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6EC6B000E; Wed, 26 Nov 2025 08:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA73F6B0012; Wed, 26 Nov 2025 08:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47C76B0022; Wed, 26 Nov 2025 08:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE84B6B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:49:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C137BA3A4
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:49:08 +0000 (UTC)
X-FDA: 84152889576.30.204CA97
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB961C000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:49:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eNYXpmDv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q7ppvV/g";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764164945; a=rsa-sha256;
	cv=pass;
	b=tJ8x0RiZYhFCm5DLj6MB58mMvOXvavhYEo3AGODLOU7G1rrBS2/9ACbUY/Zr4thb8iFCy4
	Pkn09Ry7JzObtduSJTmrcxYYj8xhKYqGj1PLOKAngAAUlxaxV8XieaSvqR0mxWn3/BQYUa
	cPcuzB1t6GGmbO1AKr+a11s9b79z6Eg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eNYXpmDv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q7ppvV/g";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764164945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7h54uDAl2buA+QN8ZHQcckanykRyW7DeY9xJw0foQs=;
	b=n5RF9aZwlgHc9G6fl3+qgUm6rHQDfJndqW3CfSbj9h5jYqHVd3YjYn+2kW6Rrv2Kyyxz8z
	kz+xBMZmGbYHOOUuGPFDzIWFOd6KYW0E1pd9FJ9XTwcXuC2FLh8n38Yy0FIpkPd+nlcdo9
	fiSWkKM+bUbXeEm2z8SnDnGpn+mM+b0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQDYXxd2339709;
	Wed, 26 Nov 2025 13:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=y7h54uDAl2buA+QN8Z
	HQcckanykRyW7DeY9xJw0foQs=; b=eNYXpmDvkj1uiE01KbWdun3MtvOH50dM1i
	Kln+43cJ/4Vun488N/AIJyjHyjVOkgGsawiP3EHbu1cGcVr+1IppXDLLSwMOLFW9
	XX94sjZp6xVm9PJFIaOrS9IzLgubxLqoKDAfoRHEH2Kz069UQe89s5moG1NivNb4
	RiPFAvVWF8lh/c7nz0QiQtIgJFTO0yuqzhWu2Trwa77uqEklKCItfYPp+dfyfL2l
	Z25dWiMSEa3x5hzp9z3LatD6nXv0f8fdh8BNT+iqbz7v9ksE8+GxHqbjowqsJ2CL
	nBn7Uj8JZcfMsEUsUOV7ABgLmX9QBh4M6lMaDiIoM+6scOYcZMWQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7xdc0pb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 13:48:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQC2SsJ032660;
	Wed, 26 Nov 2025 13:48:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012055.outbound.protection.outlook.com [40.93.195.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mb0ynb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 13:48:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZ5LPfraIp9imq2qc5vAuXnIi4imTdDChiLaDB6QkismazFNxyeTSAIzhn/ZfbVIorcIhZLtEkoByGDAdpFLg6vm2T60WixPzI5xgKSbzHGCNtzD/4qUrhbFVtkSVVHWLe4y6Xsxz2vkE4NDMgPAkNSkkgqfR0krcjnh3Vb6Dgh43dgGXo1Df/OBQRKvWFO1qK68nUqmgpOD7nFCq49w1x3AAHwDo5WKZbh9K3pu//iBF6yDLQexjPX1TIkzhRMu74Ms+pHCxocuBJfoTaVVGqeuEL/SZekgZfY4CntWxJVREbrwBiM52Yy5ixAzXqmaGDDslgTg9Q0y2WcHDRAjtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7h54uDAl2buA+QN8ZHQcckanykRyW7DeY9xJw0foQs=;
 b=PF60BxcP499XRYeKf2jo6pWIFgXP6ufxZNdvERpFy0q6l7JJjnhaXki6TxPo2XntnFJQY8++yCLNOPac+l+5LhM8mLjIiRFEPKv9aBp98lXAvfYsHbrNKBxK7KD6qdB+UTfsFlhU9HWvBe3i4bxclCOE4WpyNAB1P0Z6DaAAtefhT9hE3sbAvPpforGmLb/wG1IiJWRo0FrIKQrDK2Ran0a0ReSL14DvzUOVhKR+z4HlhV6sKTu8mdlnfDqeya/k1+pEN58gZZYD3jYKMi4idEXwMYtmYSa1V4SXCvzvbZ3zh208Th1s4eHFqXcpoPVvByn9YSidjjZPbBQ1Of1Q7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7h54uDAl2buA+QN8ZHQcckanykRyW7DeY9xJw0foQs=;
 b=q7ppvV/gJ91e1A3EWNxt3A+3iRHYnrixFxiWE0Wj8jzDkguqzB9COyoePZgbIRruNoQKwTwVEV3ZM6zI9G6m85qdU2YEJWMDdsNaoRiH2WqeRo2O3KMMBQC6H2NTp6nIF3ykB8BJUafYpb+lJVtTSLq5EHaSaMIHS2+AZnW/7nY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPFCAF322559.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7cc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 13:48:48 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 13:48:47 +0000
Date: Wed, 26 Nov 2025 22:48:37 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
Message-ID: <aScFNZjGficdjnvD@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SEWP216CA0114.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPFCAF322559:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9ee091-fab0-49f3-3e62-08de2cf285c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nOhlIgE4eYB1kwNRqAWqToGNNchTdiohWPHHdFnZKybSBANEkm0SF6k/2kJS?=
 =?us-ascii?Q?N8+C1UeHFQgBG1dJAv/yUEW/2nGTw6atmDCXuEoXVs6j8uTzb/JR4GVTWtuc?=
 =?us-ascii?Q?AeBCMfa2QuoY55Ep7hCbIRGrXYkaUMQqCeoXtABKRshi8kk927fZYxE+Kb8H?=
 =?us-ascii?Q?LoLJ3JkUVsVVFXkuXMpTJS+LsEdUtkQjEuG7hHh4bu76DG1CzzFvvbKQXxop?=
 =?us-ascii?Q?ghGVPsmCFF8X3HqxjS/TTbjJIJEHgYvXb4Y0MnBc9mCpjx+KWJ4H6qfr5j1k?=
 =?us-ascii?Q?zX8nlo3BXyFGmdIwvC5WxStbGFObZ72O57XPjEvbyiQV7etPfj5yx5QMg2B1?=
 =?us-ascii?Q?rtJ/m7PnCL5GH+4qOlvvGuDwPhCXpmRHtIrLrfrjN4EO3V6Ywbsqh46yxhp9?=
 =?us-ascii?Q?RMyrzFvONoaFbFhm9iDE3yc5dKjzSbi32HTEqEV4MGDcitBTrBShnl9/7B00?=
 =?us-ascii?Q?ZwrM4rcfEaGt0swdDGi8sbVKc8yOIJOmXrXHWfI5uN3nMFSuQ2WofPj4tTQB?=
 =?us-ascii?Q?SZhxuYM/aLauLw+xDHaPUKfyiu5eSVfnxbmdcL3svHFWrQV0bSv+aOuTNRHF?=
 =?us-ascii?Q?eSdlEGiuxK993fTwT6yAHoxdy8GGC1RIvNCHePthDbkoAO57xDI6lNu29xsb?=
 =?us-ascii?Q?NEh0jfcAvvz4WsZcsimkxuXTxKAom4ENlIP+nrVMQwBACtHuCT+NFqTuf4DI?=
 =?us-ascii?Q?vnx/pgao94oDRRIGtzxEOeqHM1JzuCvSZI9QeS1cEoHqFP/kGzioHYY1n9St?=
 =?us-ascii?Q?ikhon7cPkvHzWUAYwuEeYSLbSeg8y+8FpALSdMAr783O8GX43G8poJTbu3vt?=
 =?us-ascii?Q?QX4DpfQTuVtN4v1TUmr3w7GS8JbVEyDiRfJT+fSyDZ1iLEvyfLDjGwIyyY5K?=
 =?us-ascii?Q?a+t9OPVmacmSonNB3O1eLOgbLyFCUiLCrSCciG7cGZs90pmLM0mMYmS3TYl7?=
 =?us-ascii?Q?3e/n8fWWIH99QV44/4HwS7Zy5TM81qFWITanBCzuzNa1Zj4/R7bj9AbgpfH0?=
 =?us-ascii?Q?mPOxucPKaQSlOZ9yJjRwecDaLW4/393J5tSmoBg8drWsYxdP4ZlbnWjQ8x/R?=
 =?us-ascii?Q?U+xf3c6nRfEnEv1QoZvvwI6e8WS3mLMrcg30vrh+VxuR3xkYzTUofjZyRwN4?=
 =?us-ascii?Q?yUNxpAuhdpRPGKYf4yLW3wqXZ/BKrZoDk7ufsWgIcodmWyiUBfHsE5HFNKXz?=
 =?us-ascii?Q?HLIhHK/S9yBtVF/blvhsXIpYC+EFnOEG4BWV6VfFpkR4hThJNnzpA51ZIzQA?=
 =?us-ascii?Q?3kDaBm9MMFjxJ4vGbyNwRmlpfHBIvs2XmLadkGoAC/3IVNz6mJfZGT1RL5CW?=
 =?us-ascii?Q?PBdpXTxI690Qvx+UnThRHCrKDO+RV1PvhHYYMt8bizrqZp33AEHM0nsXDPR6?=
 =?us-ascii?Q?lK0Dh9WIAavv3OUMZc1vRJkrvj01hJMKDsixud/FYl9lucPz+1oJQldCy+s3?=
 =?us-ascii?Q?ZZfnwPnhohro6xhKeexrIEkWzWB77Qco?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y1h7ghcaGKMx+1rmNJr/LDe0gHtdlAaZrl3thsTKUdsj+lmkuycJdV1QjdjV?=
 =?us-ascii?Q?zMiyf4Fw2dglGC4nz33hq9zIS0TjZ6ABJzX/sFZpBOli8zTztfXSPmF9e58r?=
 =?us-ascii?Q?YsYm2/BDgrbQhmQwh9xk8aaYp8Zaralhs6JeYG4cKY37CXdxTbI1NrdYBz3j?=
 =?us-ascii?Q?dTcdneoseAOwBNkbeRHeji2EnhROCGkR80AAVIcEPnq7UeN2Mpb3TYYDoaF2?=
 =?us-ascii?Q?uSNPohG3vZVYgY/f+Qn2qYHNs7zxbWE3B/5+RhWYOHxdeELnz1Kf4ImoEoaB?=
 =?us-ascii?Q?F6/X8QC8zCrlpHZYNDblJUn5biPf2U6uPEfxGm7I7sD2npSjd86Qmwy4p6GR?=
 =?us-ascii?Q?Y7pABSvdr1cqmL0kpfQv9zy+aScqhmcFleruizW8tP3D0qyycW00PNnp0ZDy?=
 =?us-ascii?Q?fRI/fCC/74KUDxsif7MW+wT523WCtGV3myRFY6ryxtA38Ay9VQpGWH6MfXt7?=
 =?us-ascii?Q?fUj79Z9eSczf+vHJ+9yjeb07DJNJbom8PvCkD/C9/hoBhmcL7RIslCJccVO3?=
 =?us-ascii?Q?4Jja9LAsrU3L0U2DaYxwjDlKRgE+HArAjbeqKYExkO3DOvOb91jCLyyXY64j?=
 =?us-ascii?Q?mHj9t0zZDdPxZ32VmNkowGa2QdRTgPosV1f1z+yb12X7f8DWprh8Jvd3BB64?=
 =?us-ascii?Q?otyIgBw2s9PsQFJgIsgbt51fy7RAlLZYicc+i4KZ9nf3+tbVleP2lqJ+znQ2?=
 =?us-ascii?Q?heQj+18uX+bnRK46l5G/SMYn53Z9QCTZSGO1fisRiC8QPny1DR2QX3wCr2lg?=
 =?us-ascii?Q?aVWvZplpZchyuOMvry4rok81cXJiNymKck25auazXJ7e0vpT3v/pPHJXuRCG?=
 =?us-ascii?Q?RCgzi8cVMfXrM0qfSvc5SJtRSPBX7rT2TUALWp+PKAvDJjsnzvrQMDjaCw4K?=
 =?us-ascii?Q?TZMQvJujX8VTSOmJatDQIP7mdm4g6CZk5C+AhvkyQila49OPqU6QRI8feptk?=
 =?us-ascii?Q?rnIf7zLwTUyWuxCqPkeQ8ynhYtnTtcJEsL3ItAePxHvWKFYIQD4lpldz1XYj?=
 =?us-ascii?Q?G6qKYnIVrFvo+aKEwq5ARBIcjF8IkQzUOM5KyaGGBs1E3mZVe8VPMco14HaM?=
 =?us-ascii?Q?tnQjQEenY4+03bgS4oMmj0fp0KB4B2VwPuChuTjYMjyi3BaEQU5WQmPEGqpO?=
 =?us-ascii?Q?rc/lWX/db/cH1TheNB6mJZZ1qt4Z7CeaZNuL+z7ihDc9UglCIQgKWsGvv526?=
 =?us-ascii?Q?oTFwB/lPnT78MNEcagc9v/da2Wk7iMyJESUOTsHWdpshfZQg2lsTZx4KB0xb?=
 =?us-ascii?Q?B4v9XaiuIT8fAbc0Shsqp9KxCB/F1oQT5El06YClzQmvGcrr6wZ3cS6iEGXj?=
 =?us-ascii?Q?Vh3KQR1ikG8QgLKjC8yb4+xCqj3YNHXhxwC52IumfVzHorP1oEO5Jzplv2EE?=
 =?us-ascii?Q?aZOrJCcwITf6B2JE2L9Z2wTrSJjdcRE3h4gCzN6adlzXCMBCJ2rDWRY6jtxT?=
 =?us-ascii?Q?ejztTvV+gMKazJRNZUvkpgtLP2fqxy+RinjWH0eB0NhD/c6tY49aP0A3R5X6?=
 =?us-ascii?Q?22hXR3TgdtVJjKdGdUrT58pI0CJXUjVnUh7dD6QjDmZiqx6NXWDHUq2Nl4zj?=
 =?us-ascii?Q?G2YmthIl8oMYW40/uj33+qxdXRtncliibjcnxYxd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PskJIJz0omzjBBBhZSwRZIrS5W+u2J+ZnK9f9ZWnFhoxooLFpfzhQSBQdowquzuOUeYhtlD2v8e6cyZkl10/hG8XKkBbKuTYZtdh3Z/JOfNjNsGXpmrvggkqvWZQWriedqRlxRdp+wn4x1Smkvi/fT1AI9gpJYPEdnh661zTRqKAo08HuIEGt/OD4TWOq1Fw8plNQ5FWCXVWwthjXOXNISA+GtqK7GVRdWscOKSml4LAu72EoL2BRG44KvrPTG0hbVZoy5POi+9ensYTmbjaKykYQmd8BzjjnMMgdo5hJ81x1h8pBFvJPSPTkeJqTVaIB5CW7707PXIg/5k+5TqQjCPWDmdXNRRqG+FRYy5fbHY03u6DFCr4ePygQxPhReC6+Yq/YwJILUwYbTEGeaPko4uI+y4vsTrVJMxwoxNj4yNwT3LLf4Fk1U7Qa3ULKRC+KYjTuL2i6TRT8mYGkJm9+F2maL3XKwQdwpD3tQiCysN3kiAjDb+0a9ihDKk4Z5alJd1kcFpvYsbZOEQxjnf38Xkyy9m3asMIhmBNv1U+cS//4f59AOnQnQ5SEHlJlqeuMa59gRwYY+4WJgIZ3HSNHP6yWJCxLmPDlePWBkWR3Vg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9ee091-fab0-49f3-3e62-08de2cf285c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 13:48:47.4778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a314W5ehCjSYAjc3LbwP0m6xNjAMFvGZtKIVO8tS2a6JJRB7LKRe4nUgzQbWHmmJYP4+SFrVKYIn9ESf0pDo4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCAF322559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511260113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDExMyBTYWx0ZWRfX9b/tOwiUYpJp
 oJ8b6eEqkGYFnKSEEQtCtwN91XrGZOfUkfxnZ7xra67rMl/91snCpHpg/lYx470H7B6ZqoHnEcB
 aqQxHreODXNQyrdVZDjYjYrEDyA4RsCTaGTbS8vdQo1X+5VE/OX2ZA9ewi+SY/StcrjUX4HMqRw
 qZSkibt3J57kyTdbAcgK13S6MW3RnYlC8+LsBTbKe4NBbPC8RQU9lJyjsMX54zTknWv2HC/fkgO
 dHp18pq8B1xgjkX+tgr25TLXIkNzivA/Q8og+dOX0bXFkH15eBEo3GRwruSwA5g9IHLtortpZF9
 zExJJiPAzWivm8SFIhQbX9L2G2mq0CgyZ6X6LDcP+dK+fQCA7Sps2H6KXA/7c6/X+hkG7fPpmGg
 ZfV5tvbOR+CzXVEMVYntw6rwkhnu0A==
X-Proofpoint-ORIG-GUID: yUHX2eVsbPUnJ7pDFUvc-kGBg7ENQUS-
X-Proofpoint-GUID: yUHX2eVsbPUnJ7pDFUvc-kGBg7ENQUS-
X-Authority-Analysis: v=2.4 cv=K88v3iWI c=1 sm=1 tr=0 ts=69270543 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=8fFOO_j6LZX5_KeSTfkA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB961C000C
X-Stat-Signature: quc1366fk4ycdmjkjmtt4umxbh3zs1ie
X-Rspam-User: 
X-HE-Tag: 1764164944-890729
X-HE-Meta: U2FsdGVkX1/BsR3EMhqQkxrpHzXagrMZ7JOUDh7t7Pg4ctW5eQ1c39O/od7hM36i7DVK5VPUrtdVqeQF930DC3VqrJZE+WzkIbx1bM3svkNEdEoBkG6xvYL8IEVuVa6nZ3c7GY41JcI6sVzquBjRdtWz9Ny0bqSEHWX/iaiTVvpcjV2qqD3AC9eJN95jo+Ez1P00u9AcOfrEaop1WHTBAgrMb+YfrznHEsjbvxBWgCCKZ3n50LXqkY+bmrZhpDCm0kLmzF0ClKOEhDXPXDIJVNxyWIGyQjG69rLdpQpBBMji9wQK4zKNC62Fk9CzpGyd3pZVq2vFKxd2BbMvjkX2S3fWFqM424+jlviMz+mgwYW5ePpm9PwR4c03c368VYzrvoqHTuLSJONMNNrXej7B6vrKHW+mKaXQj3KbdK+SjFOO+EqASWa2/PR66rsvSGZ+8QgLXXJDxS7eLE4oglLx4XR5qDCIGnD/n55VCJVqmGR/XvcxMnQbOFm4gZvigPojMplgEFWVF6aXpLk3GJEyxhpNJMjKgH27OZBkpbtWL+lEI2QCkGtp/PAV38RkFTWq6orO2NEUow8du+qXsrQAKJqXqWZALCFs9ea88oSxF83siwHYOe140A1MQqgrhn3TaYS8msiNU+orCaLx2k6OXyalYAqkSLiAK8401jB6V5yD801pbHuBg52spdQfm5FmvdtYO9rrWC0oM8sluMBuhe5kMlv/PD22ObeIqKY3cW4a2jaU/vL4TW/DnMUDAZ4p0XjeZtOicSFSOtgsZmjJyzI7f44TgZVATducE9REzPdvisKoqHrMwRDlptUFuBX5OCHD0sr8XhXK2Fpvcs/bBBLwE7+/ceM+8m13weq6HRlCSg0kcV9fq1GL2KtX82fcjQBogzMc6Wrc52J+L/QwBC6XNirhE0xs4f4k1d+FEI8mnvEwmNBt8j8zvaYahpB8+G4F32Q4fAzzVwVTc8u
 zHrOpNjr
 /m6Pz1FULnlIigZN83mF7IjtsdkViKcRZeEV3ikSL/XX0tCQNmAnpinzEapJlV3HLxOwjZkY1VQtoaQhM9peCdEREkvfuCXX9hf+xIXkzdemIju18myVnxOSWTOvUQDufQtmIqfASlHg+tOANmd5VCzlYhPpovcCB9NeaLfdsqK51H7cJhWHp/quVZYg9CIaayyuY+0HglYujLaHJ+4K93IFNIkKWcbTryRwCVsbQ/O1vezB0ykmm1PsDf6jZABZtLdUEDYFQxvFGZ5pa2/K8rFJbWEGRfi6N/kO0ildrW/fTBDGTZ2lbmqt5P4xgsrjZr3U1HUj46kq+RRdqzXpHk8NzTxY6JQrVGGkqGgg4sfb/UJm159DN3QWxmp3QXiimRSodtyMCGNISltQD/APi6q4c3BbHS1GidiBbb25zQL34bWmO8oRkSv83I2T6mSgoMfzuavQFacbhQXJclx0RQa88QI5e9pqI9nyrLGX+PnTnXH7ZH/kIyNq+ga9faOn+oiDcHImO12n6Obdw5Y2HCwEerVXifQ2qByQbREzZs4uMl8lMK6yM2V8vaZ0K1u2hm2lSHYbFnWPnXkwu6jH7ZDEM6uiCy8fZecHzNxjXv58opmS8qCyeTlOpdOkO13YfsPf/AnVt6tIx+w8ju1pdp1KaCn+UlmpilhQ6SXiUb0XNmnoJus2tQVIGWpV4M1E61jB66WU54t4Vtl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:36PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to traditional LRU folios, in order to solve the dying memcg
> problem, we also need to reparenting MGLRU folios to the parent memcg when
> memcg offline.
> 
> However, there are the following challenges:
> 
> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>    number of generations of the parent and child memcg may be different,
>    so we cannot simply transfer MGLRU folios in the child memcg to the
>    parent memcg as we did for traditional LRU folios.
> 2. The generation information is stored in folio->flags, but we cannot
>    traverse these folios while holding the lru lock, otherwise it may
>    cause softlockup.
> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>    may be updated, but the folio is not immediately moved to the
>    corresponding lru list. Therefore, there may be folios of different
>    generations on an LRU list.
> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>    found based on the generation information in folio->flags, and the
>    corresponding LRU size will be updated. Therefore, we need to update
>    the lru size correctly during reparenting, otherwise the lru size may
>    be updated incorrectly in lru_gen_del_folio().
> 
> Finally, this patch chose a compromise method, which is to splice the lru
> list in the child memcg to the lru list of the same generation in the
> parent memcg during reparenting. And in order to ensure that the parent
> memcg has the same generation, we need to increase the generations in the
> parent memcg to the MAX_NR_GENS before reparenting.
> 
> Of course, the same generation has different meanings in the parent and
> child memcg, this will cause confusion in the hot and cold information of
> folios. But other than that, this method is simple enough, the lru size
> is correct, and there is no need to consider some concurrency issues (such
> as lru_gen_del_folio()).
> 
> To prepare for the above work, this commit implements the specific
> functions, which will be used during reparenting.
> 
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/mmzone.h | 16 ++++++++
>  mm/vmscan.c            | 86 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 102 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7aa8e1472d10d..3ee7fb96b8aeb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4468,6 +4468,92 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
>  		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
>  }
>  
> +bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
> +		int type;
> +
> +		for (type = 0; type < ANON_AND_FILE; type++) {
> +			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
> +				return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * We need to ensure that the folios of child memcg can be reparented to the
> + * same gen of the parent memcg, so the gens of the parent memcg needed be
> + * incremented to the MAX_NR_GENS before reparenting.
> + */
> +void max_lru_gen_memcg(struct mem_cgroup *memcg)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
> +		int type;
> +

I was testing this series and observed two warnings...

> +		for (type = 0; type < ANON_AND_FILE; type++) {
> +			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
> +				DEFINE_MAX_SEQ(lruvec);
> +
> +				inc_max_seq(lruvec, max_seq, mem_cgroup_swappiness(memcg));
> +				cond_resched();

Warning 1) Here we increment max_seq but we skip updating mm_state->seq.
(try_to_inc_max_seq() iterates the mm list and update mm_state->seq after
an iteration, but since we directly call inc_max_seq(), we don't update it)

When mm_state->seq is more than one generation behind walk->seq, a warning is
triggered in iterate_mm_list():

        VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->max_seq);

Warning 2) In try_to_inc_max_seq(), the last walker of mm list
is supposed to succeed to increment max_seq by calling inc_max_seq():

        if (success) {                                                          
                 success = inc_max_seq(lruvec, seq, swappiness);                 
                 WARN_ON_ONCE(!success);                                         
         }   

But with this patch it may observe the max_seq is already advanced due to
reparenting and thus inc_max_seq() returns false, triggering the warning.

I'm learning MGLRU internals to see whether we can simply remove the warnings
or if we need to do something to advance max_seq without actually iterating
over the mm list.

-- 
Cheers,
Harry / Hyeonggon

