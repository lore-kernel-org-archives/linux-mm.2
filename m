Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B98D78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2A56B00D9; Fri, 19 Dec 2025 10:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93A36B00DB; Fri, 19 Dec 2025 10:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B016B00DC; Fri, 19 Dec 2025 10:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD3796B00D9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:48:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73E0D89724
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:48:21 +0000 (UTC)
X-FDA: 84236652402.21.352A3BD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id C85C41C0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:48:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OF33LPlL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AWacHWvc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766159298; a=rsa-sha256;
	cv=pass;
	b=O/vGMTwwZEm75E4U5sO4L12QlgdyqVDJ9Q17LVn0Ae3US0bIusEuOvSGyjcccoyGH1W/J6
	VswQe5uuojUwOj+q4M9o2X9InaxeZ+p9Nvo7SsiWay/R7d8US4tOCVT7jCva+oURG8kqs0
	Qf8Sm14JDAcdmzlZdPQYu8ZMyEtS0F8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OF33LPlL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AWacHWvc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLNGpH5YRYaetCfHv4BweUe3aNFdnLnpIRoOcFSEvh4=;
	b=PXwg8boH5OgdDXZ0EcP3httJG3U2WYSLJF0yU/vFWZAXpxwy4/jo7ANGE0UVE643X/pR+c
	zHWg3PvoGPEoRhc/7GMNXHx8cyqsX+g+cXMdt53NXgseTDOJafZbMeKX95/ldQLwo90/6d
	D/BV01O/7MizFY8IQFsxjnZ6g9NYQH4=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ3E6S72931645;
	Fri, 19 Dec 2025 15:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZLNGpH5YRYaetCfHv4
	BweUe3aNFdnLnpIRoOcFSEvh4=; b=OF33LPlLGuaEhbJ+J+Pw3PJnY+vjzSbEnU
	ttKieUV0E9/g6urRCTynROT5018z7SW/gANyelJHntNGfoU7n2ahEKqjsMPQhOwC
	l9OfbpWlAXe53NGx827iYiLh42X3mMH0P8fkimSnbqGjF998w02VIWRIe+R6O4iI
	SpcXsNQKK8yMS8wMLV4/JigxYCnIvGVHwXyuqdeRjrqBbsmzRg6woBi78hi504xd
	Ht7tdAUROItL9IaZ8HdplRfMwQ4mh9e5VWRbPk7xx+18aZBUEc0C6YzpP467JnEC
	62thE4MZ/a9TfQcmhcdgiEPGM77WO/QWxjEMqoMfIp9d2RgtSi3Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2899gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 15:48:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJF2CpI036682;
	Fri, 19 Dec 2025 15:48:00 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtmkgat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 15:48:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ct6KGr3+wnFvZo2ea1/yFggWcNivlIwYIq5iBqyNVMnJTvxu+WwagaVBVZBF6NBzeAXJEsaEOswnw11LWYTJMt9NsVPoa60X57E86SAf3B8SUr0BuPzcbnK2CLI+BFiQYEd6QUinL1eTRj3851GiZpAiRYNztOd8Pd/Od6Gyot+fJ+gNtHGANABIIaZDxlCa9Ho6RS5rnqg0PozwzJoRpPTGU+/MfMWlpUjfGp9I+gES6pmdtSouReIAPhVhbuthtrM5g1GAdbGmzbMEdXuvgkytenNm3kpf3/UYXfoA9q5HibfXci8XcAts9hQBhqci92MOIQfl61/yYCau1d795g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLNGpH5YRYaetCfHv4BweUe3aNFdnLnpIRoOcFSEvh4=;
 b=zMAsJje6KNPCCRrvrQfjZJB+AuLZn+t0Xmk9khpOx+BCIV4C9iOj5PU2rZgH5a3v2GZvMWsYr/P88l6GeHXntZcKlOtNzH9JgwgiMI+yjwUvcGJyO7EwOH1nd6vrtDHrA2MwbXttYpYd5oEvBaYs8LKtBHzg2UW+ciYUGr5x8niLO+4hOE6MyqdF+3ht+Ap7vg07pJXi5srw2P8f11ZpfYzlG0qSl1seKyQjfFjvroz5gHmKJzRdaAK6NNHDjVvpeG1+s2VMMO4TJ2rUFjYk/x8yYjXa+7xpaVLV7vgOHsdvYLr1Itd4jzAtcjyjS1PskU/1PbOWBlQjBPCO7j5p5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLNGpH5YRYaetCfHv4BweUe3aNFdnLnpIRoOcFSEvh4=;
 b=AWacHWvcg5zPaYsuIEGkHC5mbVzMwEVaTjaSBNit1wsqpfE6Ilfq2Jpjqdiix8sWJL2oc/P4oO93Rv+D5rhZptvpwOoPof6/u9Al8WuVP+y1mu2lqb2ywu/QDU2qV3wBBi11i25kuHpLxpag6/yfIjprE3VQrCZQy7YAWNYylN8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN6PR10MB7997.namprd10.prod.outlook.com (2603:10b6:208:500::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:47:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 15:47:56 +0000
Date: Fri, 19 Dec 2025 10:47:52 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <x2s3l56rqwgcpkhpu77pjt65tfwgmchuy4fuyrj7h7uag5gja3@c3jbws4quxrd>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
 <24b9d33acad627997febe9b61d398fc53739a333.1766121341.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b9d33acad627997febe9b61d398fc53739a333.1766121341.git.baolin.wang@linux.alibaba.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0049.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN6PR10MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: d98c21ff-57d6-43d1-d805-08de3f15fa6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wxjh8HxFN9bybeNKJZ7nGzPsi1RLOyQRtptC9YLZ1blGwOH3mZQBe/gjTPxZ?=
 =?us-ascii?Q?YRCVFIHYyvzWzvpMckEQHGHr2EZz3mT+VIH7E1gzSETU565pXNh7SvErnxOd?=
 =?us-ascii?Q?kB/dBlw+8aE2uNkbkwk7drIX29oej6s1nQAEIcZJcL2nQImBUICT+CBA9nBO?=
 =?us-ascii?Q?cbVpVxxnvnhKe0soBfgny5xV4miuHDsZkmdzEQ/zBxKDfG1gTjum4pre5O1Q?=
 =?us-ascii?Q?M6ITcT1bHvSq9u84Cs+WdXERU1wvuM4xKQsxMRbuZTw1QqHqsf5eBGu0ZdK8?=
 =?us-ascii?Q?yz3cA/wVAr+GOP6uPydhlfJ5Fogg5YN1q3WmraQkPFHrVe/OD/yin5hDxnuQ?=
 =?us-ascii?Q?tMrNuXsU5Wki612Uzq6yZxx7PViKbhsVcbNnlxadSygOIm7k/EMsg/AZHMt6?=
 =?us-ascii?Q?8JKKbrWyPZFx0oKJJOPBuj3gFS++bPD0CKnziaWNhinY12/HZeLmDBAygYi6?=
 =?us-ascii?Q?eiUzkk1ILk2HHAlMoAtAuUpf/2Y9gCsG8Phylm9t+vLatNCudS0JELy4/Yzp?=
 =?us-ascii?Q?sPeM9I18i58pigtLkhS4qUnRHQLbprXbAEzwo4uPRjbei0RMwC/aViXOK2aY?=
 =?us-ascii?Q?yaCtyR19Y1HCClAFxNAi5uqntw7bCfUK0T7iUjilHppWegyjkjws4u45/VNK?=
 =?us-ascii?Q?BkMie+Jxz91IHO6uBRcC4USR/4Fr7IIGjta55840RSPpwQaZjrdMo+s7y98W?=
 =?us-ascii?Q?IhLGO5ZdQeRSK/F6WqkU6RnepfczmJ+lkta3ThoaIhu9JJq+Mv6sjcBu5sdn?=
 =?us-ascii?Q?nxswCvZW9NkrpRowN5VnjVn8tucO+u1p5BMLixwM3yuX2nE0Vi05e+jXCAq1?=
 =?us-ascii?Q?YG1Lme9yS6UUTmjtWD4uczu3fpcFhDgSmY8RPeqAaGXHBkeaMxPK8RAAOwht?=
 =?us-ascii?Q?gK7qfx+8YMfjc9JFTZrtQdTaIckRGtoS21nqN8KnlTgOJhczNKGtrCQeuzZk?=
 =?us-ascii?Q?RHKpwjQUXi2FcCgqCBVWbPM0cttdrXJR0qthFC9C7u9N748C68TdaIl5rsBa?=
 =?us-ascii?Q?05ii+pA1ybeKAOndwRb/5h4wTtjj9Z6eJrO1u+h2qpEzrJndDaDxd/bM5TL2?=
 =?us-ascii?Q?U40VQcQylS4VcXVz9sDH7VRjIdsdQvzEFtoYC6XZbiGLr4kre0vdxaevbXPn?=
 =?us-ascii?Q?nm+x6ST0FEXTCTScNNA1cU/X6T2T+Wibm4ikutBUqQCYOOej0PgIyb+OjCXo?=
 =?us-ascii?Q?K5ZvNklRDMTQTbVALArE8RYedxAWoDVTEGWHV3yQy5Zi9bmNcjHXDTGQ1xwg?=
 =?us-ascii?Q?P264yb1GNa5AZJkfSQv0d+RW+r6ATrsHFwyJwPlFk4Xg2yzjWthgfd8L2gk7?=
 =?us-ascii?Q?7Ghpse2HzpXxMsTkipL872Y4qaOevrybVqUM8sOM1mcEwmRiJcgVKAGtiokT?=
 =?us-ascii?Q?hTrgnXucmWwJve0UujFU1OsBXw7qrG3juP6FAkwa8zbXUp8yMhXSLZL3TBAH?=
 =?us-ascii?Q?Pg540nYaAS8JU2TP353GPczudwOIopQk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ocylk5nF48x2t5DIBktE6EqFqn5kkxmI1Iq8AztmZJccVl9iGUpSjS/N34MA?=
 =?us-ascii?Q?qlhjjchVSmHN34HilVZBEjZJy6TsS06PF6qgiR8xy5t8N88MUm/xRIZ+0VDh?=
 =?us-ascii?Q?n/AEYOPVpwms/v5id8FJAlu+9Bs1HfKg1lVttNe+vxucwDTDPAcTJQdSEqLa?=
 =?us-ascii?Q?9dWjcQ5nxPUt6hHO6VtEQAJaHjVLVMRnwzafY7j9hkOnBy48JoeYdGM/A/e2?=
 =?us-ascii?Q?NkxdVvYaac15IjTuL9O3dYukrmCTiaeDxWVhHfZ/J+pjSgHTQg5/5VnUNBGU?=
 =?us-ascii?Q?STc67jNN9a25HNgk3xsiaeD2KeVJnEMGPUBxgkKi+Ho7tnWnEiFxwUIX3EsB?=
 =?us-ascii?Q?Pz7VSVbslktXngI3xZqn+vNKJGkwgHGvsFZMYEi3DD3DAiPUswsTtbc0Khdz?=
 =?us-ascii?Q?xNW7uD2aP2JGhg/SOCIiQnNYZY3TeYMy0s//OAxGT6/ZWtH5XokKDZi1Ebm+?=
 =?us-ascii?Q?phPcRWL4P8VDAz3VM0rCeVdmop2SDAklsReiY+XgQI2BP7gjbkm0TxQJ1QFA?=
 =?us-ascii?Q?ZZQFwF4QulpPNBCLdJIZ/MhTtRtDfTR6cMfyvBD7MeTFziFCGSUm7MvxjI8s?=
 =?us-ascii?Q?3di7ryajaOFUgtlMoSv7YNA0EufELiCd655vDG9nLjWMnY+IBv976GyJyUx2?=
 =?us-ascii?Q?ytPKNfpsUHRqZLSCD1KB9zmYTvKje62Xy+6VVHyD0MffOQoEHiVN3kh0d3Jm?=
 =?us-ascii?Q?4SqnXcufZIYq9mxQgne+NCiQ6dVQbml7YLGWA7ush1Ai1GyHtUiQUy8pKYLa?=
 =?us-ascii?Q?emIfyCc055TPRQVbqbYPoo0liLDfYNwwWUNNH9q37m2H8/SrKcoqmn1+sqql?=
 =?us-ascii?Q?A8lryuRjb2zWL5xnoAJIRXCndyms8dppYuVPQ5zBkppnhFLJzMXMZDXQtvaL?=
 =?us-ascii?Q?z7hO5U+zjOYibGgUM9BNDv7pOPMg7w9QR5R+Lwq3TZhgdV0E/VLfKsPXPimU?=
 =?us-ascii?Q?97LyehPSYRs9u6H3IKzkJPPLX0YCdBQP/Z05+nfcbVaIkUbQUoIK85Itmrdp?=
 =?us-ascii?Q?kBL098DdpNNy33pGk04WEXBRub28pnBVG1u3Nyw7Q0bdNduJUKodpKo4l3Np?=
 =?us-ascii?Q?sm2VYrsWTV0UXBtE8kj5WtJu/D3IySF/DcuoqWkbuwOocpDz5OKOBzUum8Lm?=
 =?us-ascii?Q?B6sD1SRaA3AoklAXSX/1wznLFXI5wuWX7v8e6RmmxO1kMHmvAuXsbnIzZqVL?=
 =?us-ascii?Q?gReabGs2Z33ffLQGcChi5E/x5hezfGztVmbgDh30hDjTSFI2/jTXhN76ELMo?=
 =?us-ascii?Q?7ZJVh/kxVZm5jYOJbx1LHrxbpz2mE1/zuNbcsbBnGPXSZqClFpUQUkoR5Y9o?=
 =?us-ascii?Q?dQxNitIqwOlV5UVS2ogabEVNm6x7EhIr/hz82pP0h/tvJenwIFuYju8kGihW?=
 =?us-ascii?Q?7N+CUheTHQrk0cnkMOa8o+kt4r13McZhCHD+b737+T6DlWfuuJsLEeYB5S5b?=
 =?us-ascii?Q?v+T6/TEcPUDF6lzfZ09bu+xSuTO+Q2m02faxlTPUgyH5vCk3kRm5NSIJJPlB?=
 =?us-ascii?Q?V6xRhIBUmY3X3pZgCjKdT1T9Zp4aqzFw5KHuQ471EIb6zrwlux4o/ACLclB/?=
 =?us-ascii?Q?Pmjn6siMlTL8Sn1YOPpWiGVOxqsmVSG5Ic9Yw6+dmtrezh5mIrKEGFmBZ0sw?=
 =?us-ascii?Q?BBdd8a3WumGpgcW6kfvheM/4U80vednOnKTih7+Y41KCcSJMHcrRIs7eWnkF?=
 =?us-ascii?Q?aL8+QjeQ8c6HxOXl+JP+U5tr4xPOLyEf6CVXkkivXWXcH28fzq9PMyqIz5Sh?=
 =?us-ascii?Q?S3i+Btlvlw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	077kAkmVYkbkoAnN26FTaozK8TQlxopRE8KNTO+Tpk8zLhAVsN+bKo1ycW8d1XmVNcB8mftUugi8rZaeEXPr+Ftuz9XsLFImwDcfEXuE5YYUz0fe7bJXq8HvkO9yVjGVQ8992qCsRL+wXoIRA90Wkq/dvQlY9LX+c3wiTtL0B2+YDn97So9Ok+sroZXY3Y01u3FbaI2EgyeN9sBE1Gp9xro/H6p8GZ4b7gGzQq/pLH8i6lxoLbFf/UcPXL1jqDjvD01f1eJaDKOP0a9M6RW3svbEQJsKAGBUKIY4yXbskvAFosp3hIfkfRBRlzXL1eFxZ/8K4DG+DpcwidqyHuC2AGWBDUViAf2Z+2YxkO515iX6kDgKJPFGZnwWGbNrXTJGbbomsZQ20dg82DfNBviRy1w2BrwbSF/rcyW+B9CDmQ+3b6yr5piYhGHVZI9qLqUWlLYs2GyMhLP6ehXJ0f/u4lTL0kVlR1o2ARvL3znT3P0yKICRqlm4mUny2+hlXZwgaaWeG16jC/d5BjZ+pLkMYUQ/gMhP2vjc7ZWnMY04Y/e0+7ShF4IlApE2Mv5Tv7k0lJRuJLQM2xyAAQGDu6t1bEjdjhI2b9zPrDydpFJr+2s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98c21ff-57d6-43d1-d805-08de3f15fa6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:47:56.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKE+FI87sEqBfUfKnv42bQzcYX9kh87P0g6St2/2v+hLJikJaarYYEkZdEQJTnNsDyHMmcNq+lu/XwgAS9wBCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7997
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_05,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512190131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDEzMSBTYWx0ZWRfX5CZjVd9xn3M6
 D6sdKFYuvsdhWpEAvzEmnX0zrwYz5c5SfHhZP+ZYt40k8kXAt1dQWj6DsW3E/3MU8gEYfsMfANr
 K71XGPSRTI8XG0SZH2470AdQ+IfJoqXxcv4DR69R3Tc6+LZLtC2mib+5hElg+zooxdKKgG4KQl/
 6Rn/gXjdxc3h7yfMuNN+PgESVj/Iv301wBetlDIylL5S04iTzJBgBzBFIZHnBge3w+5cMFNE+Nc
 W6r+WKEBZXoTz88c8q4ydUKMq2oVaeF+15e/ezN+Ml0i53aJiNPnZ5GkHrYyrJOOKUFSg80XoLB
 Zah5pClXpOCvkBMk+NIeiFfdn/mYhxJ8tGHIhC/p9Zlj5nlEkUKRVT2r5H6nGGwNfz8lrlWASr3
 E9niRUwt9J8b9So6kj1i/17GrhSFGTKihd/Q0g+ut7XnJAGxhQ5LYCVxZjdAMgJ6UTjyUiiBR4D
 hyc0aJam4MvQO3yVDU3IEw3Hg0P+DX0rjy7RCGGA=
X-Proofpoint-GUID: 6F7JTEL8zr1xbVmtsiGwnrJ7EAE4VoX9
X-Authority-Analysis: v=2.4 cv=H/nWAuYi c=1 sm=1 tr=0 ts=694573b1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=wDLEXmE7x9BwxhIoP-YA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13654
X-Proofpoint-ORIG-GUID: 6F7JTEL8zr1xbVmtsiGwnrJ7EAE4VoX9
X-Rspam-User: 
X-Rspamd-Queue-Id: C85C41C0005
X-Rspamd-Server: rspam10
X-Stat-Signature: sctq5fyiybby5hrkxgostu5zw17ksdta
X-HE-Tag: 1766159297-310133
X-HE-Meta: U2FsdGVkX181zmD6jZlklOwrMpJT5ZplcFrEPdmxKK7UzIf+9DL4M2bK6UgJnPwvPODOCWRRbMmXqwoFRGlB02iUfn1V+WNl1zeBbFR0v8exmzpDiR7r7jJMcR83kJHK+daaJNSYKHRbB0VpVPVZEUxpgT8aJRaCrE2QofYrYyQ84szuaT0nHHzpOUH+m2ffSP47Aata/BV4meagI7MfPSMvtc/DdOyrdZyqHYWyHp+bBo1SKnvxAy1F9wWhOxGlrmxvP8fJduyQyGBJp9FnXxtdgHGbifbgkg3CPntLCg78aLar5gp7XCH0QDKl6DLxEU0TbwVrVv0PAOUed4+GYbM6rnDoB2FhRLm2NliylYu5VwzkoaCELEhm2jZRfoYP7GU7SMIarRYBUnq7STdtHgkQHB32zDscRDCEqWnBRH5INA9j0Nf/K8B/M2TVaP25n4RtK0rUfZuU73i0syMLDVqzx4wrg8u/bHLOr5UMwxOlv2UhaeGvxmtsEUiQ4WXQzwbZMU/8C/Icb4bLBr1zWKjRDBFrMdjGqmfplPtk8p2AmvOOcDRK2uXZ0OYCckaWj2VnHDf4HR+6t29sytKNi/In6QiaTp1bX2g/ogDapO2NtKIZWtfTi0iacGItz2IyL3l7+rdZgU1M+TtsDSERAIlKHNjGAJc7Rw8PVYEW3HvB4U6JfCw0si3Qjx/QPgxieZWJisIci6vIRfNFagEJyU2PM1/yU8nRs2C6p4AyukBBfzCbYRmEkiWdbLT3qz7LwojNBrfJCnslaUSG4x2c4IADssXdhx14U7IUkORll16icy7UAoc9pHDuYVG139zTlTYENmn1h9a1IH41C9FiLS7A+MXIxxCcyurAELR7K8jsN0ZbyIGrjGwqNR9TzhxvYeUXu55CgxXxvoC/zH5iLcPMa6BJpbo6Kb+tf/A1gldLPqWCwzwSYUl1qgav0NLaBCZVDp8vRMFVPYxV82S
 S8bVcM4K
 vkdkZCbSp54qDAszEV7eSCPu2DHNF17OXwuGibJPSkdRTyrwswFRfGaqf0tEqGjGBqXxiT11xpwcwjrW/BOcQ+S6VycDs2C0PM+VKlHwSYtYFROrtFkIDr2R3yts3DypduLNaIF1T3gJTqCtFjtwHWAf/ADLVkFIdPLm8/NFCwSarGzXG4JGwTiGxjDdZSUTl48p05Y1wuQRhAgep0MxsEAlw+t3SIqmqk0N8o665eJrYq/s5qi5nUYECyrHLKNsv3cDmb+9DrDax2/buqKgClrnmQGQFBryHpwylukKo+xEjDQVl6zzqTAhPrFVVORcLYAVPg1jrv5Rd4gJ9QMyL1LOhdW+50tF2dMGbZXFNI2xjqL/frsMRxN06GkVbERBMg86y30EzAU7TBWICdKpelkMbUkm2KoOE4uK7DvtDpPOY2/VMez8yavJLjZvZ4THqoCIXSWl+TaELtFDiMrns9lJbURSL3uf+o9hQLRo5jYQHZn0eSogMuhqJH59JZiXHhcQhFENEdRagnS2kxYEI0kYSYJxZqYS51qWy1Ku+vZWlscL99Jdtv7z2YyCEE55OHTyYtTB/lXV1E9gEf7J0q3gVNC1UglndaWMNZh1juEO42j9cSD7eeOCkKTfxd7upH74rbCAueIve8PBcs6WCrMvfv6xPVY1RQxy19GMLMrlTdC5L5cY1EZ1Qyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Baolin Wang <baolin.wang@linux.alibaba.com> [251219 01:03]:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation. And it will be overridden by the architecture
> that implements a more efficient batch operation in the following patches.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/mmu_notifier.h |  9 +++++----
>  include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
>  mm/rmap.c                    | 29 +++++++++++++++++++++++++++--
>  3 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..be594b274729 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>  	range->owner = owner;
>  }
>  
> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
>  ({									\
>  	int __young;							\
>  	struct vm_area_struct *___vma = __vma;				\
>  	unsigned long ___address = __address;				\
> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
> +	unsigned int ___nr = __nr;					\
> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>  	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>  						  ___address,		\
>  						  ___address +		\
> -							PAGE_SIZE);	\
> +						nr * PAGE_SIZE);	\

Did you mean nr * PAGE_SIZE here?  I think it should be __nr or ___nr?
I think this nr variable works because it exists where this macro is
expanded?

I am also not sure why you have ___nr  at all?

>  	__young;							\
>  })
>  
> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>  
>  #define mmu_notifier_range_update_to_read_only(r) false
>  
> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
> +#define ptep_clear_flush_young_notify clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>  #define ptep_clear_young_notify ptep_test_and_clear_young
>  #define pmdp_clear_young_notify pmdp_test_and_clear_young
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b13b6f42be3c..7e659f4171e2 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -947,6 +947,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  }
>  #endif
>  
> +#ifndef clear_flush_young_ptes
> +/**
> + * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
> + *			    that map consecutive pages of the same folio.
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries to clear access bit.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_clear_flush_young().
> + *
> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
> + * some PTEs might be write-protected.
> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecutive
> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
> + */
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
This is where nr is defined                         ^^^^^

> +{
> +	int young;
> +
> +	young = ptep_clear_flush_young(vma, addr, ptep);
> +	while (--nr) {
> +		ptep++;
> +		addr += PAGE_SIZE;
> +		young |= ptep_clear_flush_young(vma, addr, ptep);
> +	}
> +
> +	return young;
> +}
> +#endif
> +
>  /*
>   * On some architectures hardware does not set page access bit when accessing
>   * memory page, it is responsibility of software setting this bit. It brings
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d6799afe1114..a0fc05f5966f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
>  	struct folio_referenced_arg *pra = arg;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>  	int ptes = 0, referenced = 0;
> +	unsigned int nr;
and here            ^^^

>  
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		address = pvmw.address;
> +		nr = 1;
>  
>  		if (vma->vm_flags & VM_LOCKED) {
>  			ptes++;
> @@ -874,9 +876,24 @@ static bool folio_referenced_one(struct folio *folio,
>  			if (lru_gen_look_around(&pvmw))
>  				referenced++;
>  		} else if (pvmw.pte) {
> +			if (folio_test_large(folio)) {
> +				unsigned long end_addr =
> +					pmd_addr_end(address, vma->vm_end);
> +				unsigned int max_nr =
> +					(end_addr - address) >> PAGE_SHIFT;
> +				pte_t pteval = ptep_get(pvmw.pte);
> +
> +				nr = folio_pte_batch(folio, pvmw.pte,
> +						     pteval, max_nr);
> +			}
> +
> +			ptes += nr;
>  			if (ptep_clear_flush_young_notify(vma, address,
> -						pvmw.pte))
> +						pvmw.pte, nr))
>  				referenced++;
> +			/* Skip the batched PTEs */
> +			pvmw.pte += nr - 1;
> +			pvmw.address += (nr - 1) * PAGE_SIZE;
>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
>  						pvmw.pmd))
> @@ -886,7 +903,15 @@ static bool folio_referenced_one(struct folio *folio,
>  			WARN_ON_ONCE(1);
>  		}
>  
> -		pra->mapcount--;
> +		pra->mapcount -= nr;
> +		/*
> +		 * If we are sure that we batched the entire folio,
> +		 * we can just optimize and stop right here.
> +		 */
> +		if (ptes == pvmw.nr_pages) {
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
>  	}
>  
>  	if (referenced)
> -- 
> 2.47.3
> 
> 

