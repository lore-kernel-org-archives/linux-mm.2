Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9002CE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078B76B0005; Tue,  6 Jan 2026 09:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022BB6B0095; Tue,  6 Jan 2026 09:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D8B6B0096; Tue,  6 Jan 2026 09:57:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D481D6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:57:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F15A1ACA7
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:57:33 +0000 (UTC)
X-FDA: 84301842786.19.646B1FF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00DDE140010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:57:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VEQi1WV5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q6HG7Eqy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767711450; a=rsa-sha256;
	cv=pass;
	b=I2K/4x9NpomuRiXlU/cH/EBW8FPupjZJrulKmxjKUr8j1huKZQEetsrryiHrzuh7X+x1vF
	Rwp8z+tEDcvtA8mgA3tsPqBbkBLvgkkQBaxKXz/58UI1vjIlDQBBGoDZ+JkMApAsvgm9ID
	jBEC7P00sOApdafIx/PshVQKOauTsD8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VEQi1WV5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q6HG7Eqy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EK1fTXOzjvrAkq0oAjACM8dpQMZNdIFw107zq0+D4Q=;
	b=xbSmllxEQnYs9EudNncEUWNye5We0nfjftJqy3uXSdGOBliF3JQgfa3yC2klk67qg50/Ym
	eIwOcNTUdl+SLaWtA+xDJW828SER6rAQedLasOaQW+6cFC88erA9M34kdEOP5/ZWTr3vv1
	oOugG4yDlTbpZqclPw9Mxi8veZA0GRM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606DIwU93611905;
	Tue, 6 Jan 2026 14:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3EK1fTXOzjvrAkq0oA
	jACM8dpQMZNdIFw107zq0+D4Q=; b=VEQi1WV5AvouYpL7KiRb4/OvRtblOXVkKP
	Dq6PiOV39SRDWGTB9MJbAP6FYtzLJhY+zpDqgJ2p8t3ZyvsWraO8cR9ucRWFz43x
	2yIoJVvUT9wHpHYrghVFbw36OZMbCAdMAqovMkGtuqgHDoNBK6j6LQEPVDpSP5cR
	yDx6dThwNbQrVVXPcL2Jk9Ab86S30ZzI4w2hOvyDcnn+Vq4RAVJKLZVA7hfgikp5
	7FY0XBRuQ1moyYHkRaZIclXhzaB4OkigLV/HO79vbeMh/RTm4ZyfFBruM4S327PG
	amsuZ1FDIzRqdjk48fi8KR92YBn/m32/dh/tOHccgEeG/+sZMI9A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh35xg4h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:57:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606Eu0HN020375;
	Tue, 6 Jan 2026 14:57:21 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011025.outbound.protection.outlook.com [40.93.194.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjpmcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 14:57:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MbDuTtwXKskFHYw79NS3gCEInvC1cwJPFV1S8NgslYtF8P7+kGUE8sDXZlICiCFJqAt8d92dROMACKqkXP2fJ5yJJkOE9s2EmPEX9aL+giaxm7VnZqelBucp5Uf/ouN8xoPkqdqBTXKutqnBxhgqlg6l1V3LJmQX5dVdtNRkiujTdybJFaBCk4EpKM7wb863WGVILnpZa8GJllgwpA0bu2sAwjZs2SxODKqv8i0M803R5fog9Z1A7GmpamYC3edYQ4Ev7KiAbzCzJo4bmTvmRInAOR2ZmmdeJH31nqvK4P27yVK+KTcv8N4UZxCUyUuVHUNUqO/bdw2lrXINKouEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EK1fTXOzjvrAkq0oAjACM8dpQMZNdIFw107zq0+D4Q=;
 b=F0heb6thvoHELxymXFJlRvYRqwTdaanz39kWmNiKua0ySmyTBDLNey1KkK6CV63iHIMWlx9wfI3RVOelhZXX1l6b+VxwpKhanY946kZsdUomwkyjBPaUt+BHEcag8a+Sr9sq1FTNFGCfprA+MyJkL17D2yUmkpsAf3QuiIrHsPPYYn2mpvSJIknGJGkRs6Y/Yyn2yZEECiWpXNTSiK9xvMPvkpEoryK+cZoCrE+JeNOEVSdK1qVYdLlQJcdVMxs2Z+GfOCCLoNs03RAIASemglaG56b4hDofw5Gn84hnzncYnUFyQFVH1CZXneWlCqyRMf56gmkzUBH3LHLPS/J+zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EK1fTXOzjvrAkq0oAjACM8dpQMZNdIFw107zq0+D4Q=;
 b=Q6HG7Eqyf/9/vLY/6OgGkOWhcxU6S2PdZWsWRHWvSPKqgTu3QV1jzkG+QDH0o5gXrSYgOBYEoH5iKehJDVa3ivybAv8OtxyZPFiBhF87jpnGF6ggjYHA53MTD09aoW/fYgxmMWlq8XB8BAwbkPHKi6CKOVo86KGEhA4Na5sdMoo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH5PR10MB997759.namprd10.prod.outlook.com (2603:10b6:510:39e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 14:57:16 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 14:57:16 +0000
Date: Tue, 6 Jan 2026 23:57:09 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: stable@vger.kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
        hughd@google.com, jane.chu@oracle.com, jannh@google.com,
        kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
        ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
Subject: Re: [PATCH V2 5.15.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
Message-ID: <aV0ixeDusgafhonV@hyeyoo>
References: <20260106115036.86042-1-harry.yoo@oracle.com>
 <3c1000ae-6c4b-4b03-a458-e74edf64db8f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1000ae-6c4b-4b03-a458-e74edf64db8f@kernel.org>
X-ClientProxiedBy: SE2P216CA0016.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH5PR10MB997759:EE_
X-MS-Office365-Filtering-Correlation-Id: e18b7578-784f-4704-5d18-08de4d33e1f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z0w/bfr9XlZpX2bCZDdF/EYSdeGAo9pTW7JLDPS1bUtYKj3GuZ5LSPZr5TVZ?=
 =?us-ascii?Q?IH+s/J9ZHOx1CErE/JC8EUPBld/IoxleDhQMUFDnnmb8x0nH2QFXhg0NBsRd?=
 =?us-ascii?Q?efe8IFUFnQIh28ebGP86bAymDAtHuELRLKzTPLaFfDwCWcQi8TCscFkGtqyD?=
 =?us-ascii?Q?kdp8b2aPCTnfaxCns6sNfGD+2IJ+dSFc9rMPQQ1rrSpIGjxqxl05vZK3tdX0?=
 =?us-ascii?Q?fACL1HCNzF8EAIk2s1NNvh72DcegkQ7QIUE7YgbmDBZmOwv+Q/rzsRY0MDJm?=
 =?us-ascii?Q?YSw1UQel2+32mMUR2lA+FCio2z5zK+YjaLd7V2luMOPPPoQPFQIdaMBdakp+?=
 =?us-ascii?Q?kiJjhamGZwRd6KRaSPy1t/gXp58pZAWxXt71H5E0svzmXzUlU1Qvm6zDp4tw?=
 =?us-ascii?Q?YKBP0vs9cRSeWjZBrfRTgM+wGOds6IR5B4hKvfVJ2n4uksNRMe/FariRCfrM?=
 =?us-ascii?Q?euwyh/VMP9ek/yssdphD0CUSV//8dfxC3mA0QWzWZ5tb8WtUwr1WfDx74zGx?=
 =?us-ascii?Q?BFlL1sKAYtvD+wNi3TONVPN70YR4Tp2/7qzORolcpEeeu1fQ/DxGwpscjF9F?=
 =?us-ascii?Q?2J9SwdXMPVyoppdHcX5KsG6qWzADc/PiJ2ot2tlGI/NWYRa3Kpf8mY+p4WQL?=
 =?us-ascii?Q?+agUQVQGC3CzGRy5jbjAN9BA0Bsq4CyJjOQfSC/H/izxfQYLXkirRbGuKtG6?=
 =?us-ascii?Q?jiXryh+WCiGp+ipKvKTkT/2FxAMcJkUf1UrLiBDit8uvyHCXSQyrHb3jMfq+?=
 =?us-ascii?Q?ZKkRsroEk+TSz9Bhf8OK3PWW+n+riLyJauEP4cpt3Tm/0NFRGOAO35rYd8gi?=
 =?us-ascii?Q?12SSNWtl56YaWw0Hd9GKLTbM5O5qHf5MEi44sRQF7bBpoDcM3GoGpHDFRIng?=
 =?us-ascii?Q?HakZXC/nk9kCvS07+qrmqPpI/04jJGdBo0xfVV204H04ZJz8VDwzGDVsKFtR?=
 =?us-ascii?Q?dFv+qT+68qwMTzr+rmdpxkA2Hvba+YWduIJyzrKQwX2kAWvPLpB6OfS1X6x/?=
 =?us-ascii?Q?arN6kh8XsBz8meWTiR6y6FNbK/oYPPqSPTWq8a/2wyzBNNvAVHWtI+sXujnI?=
 =?us-ascii?Q?aNgzh/WKjmbCK/Aaf5si8poCOgLQcX69yMsfptisoCzhGkklDNpEsTQkpULK?=
 =?us-ascii?Q?ziHcYZWbPl/AbBZIsKHBWSzOKMTRl2KwrQ0IRdCcNx76DbQ2813zshSClbrL?=
 =?us-ascii?Q?w0FblK+m+50D07WaOvFoQJc5F2pWIdnuzBsmaIATLGRWe6ekgrvEzD0BnEKC?=
 =?us-ascii?Q?jhmKsB1SK7LSLltrFcgJItmjeH2lfseLarqZJ9Acu8+u1i5R/EpZTJEgxqYr?=
 =?us-ascii?Q?fVmFOVgfySqJkAdc7A9yAy0MKw7cRT4pD0C6I9q/2S7MkGEQIH8F0QcZesZw?=
 =?us-ascii?Q?RpyPPHoX6mTVVhLRWyGEZp+9xQDzXsR/olptr2FZQhuCUoxaFd9jyLpMi4nT?=
 =?us-ascii?Q?ikJrILJ2RqG2KOdLdfc5XP5baFVJzbQKgYROOVbVexJ320NRgXfdAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vFcUV+HnMNmM/K3ReAOdMjEWJjCnRY0I9zaOF8DWPGpxx1Jk2hsUZIwSjt2X?=
 =?us-ascii?Q?IYh69DdsXbSz+8gKub+zdXt8mNienLRWBjI5Tn0uw70wyiAIjsQViU3XOo6u?=
 =?us-ascii?Q?moADUBsAIgT4hIlPmwjpCMS/EmeeVhylQC1ewjDdTX9ECV0FZSUuqg6xpH32?=
 =?us-ascii?Q?8CLJDU6Gq+Qs5xCwHYZSwKOvHB71W0PVHclWDP2SM6+/NpEtBo54Yxqhnm6K?=
 =?us-ascii?Q?82+2Y56efVJy151+THG9A3DVSFZI0a7i/kSkRgxPss5DXaJcK+tKZsg3D1CR?=
 =?us-ascii?Q?lkNXVuq5oisItyb7ZSv33qXCuTnV/1ELR4qMQarcd02tAW0EVYN15yqsksEn?=
 =?us-ascii?Q?VRXuChQ9zNKfGfV58xbgajwALDQ2hutDKm6dbEMWR00eMr+NyhNrBOQuhmWK?=
 =?us-ascii?Q?wURTu1DyePi+DRod5N8/qjDJhwdqUr9HfSX2Vsc1xErO/uH1csBBAoKYndPs?=
 =?us-ascii?Q?lfG+fakpadEZsXTRCSz33KcLikl8I87+s9ThJKIJjPT/M+MDms2pFEf8Xabk?=
 =?us-ascii?Q?mAqxRZYmf1pPyCK2QMZZfeUnLw492fmEIiXfh9yFeaPIEm26uJ3fTULEOxei?=
 =?us-ascii?Q?hEYe1TsSrI4GmiTjOXiUNM1TQBWnQUAZR7WZlC8zFUgHMdfwgXKOLmem/jc3?=
 =?us-ascii?Q?V3gNXtntFdTWQGi58IZG+acCJU1BGVUOIG2wL3iSPcfaChAPnyBQUU6gfZ6y?=
 =?us-ascii?Q?uy/smMYRiNKk96vT4RmYMcD/S5qERiOBIDNuS7VWiY7ered5EGty1f+0g2m9?=
 =?us-ascii?Q?VE4m0MMkHTsJ2/+hq/Yj2tJZif8/Gil08xsK+gXsxI7ca5w4Wl1/7Bv0a3kW?=
 =?us-ascii?Q?frNclZ4Zm17/QXfis9+eWSNCibO/gTb3knVNqGxi50aExFNpTSdo2ue0eQNx?=
 =?us-ascii?Q?VnTolvMBxCfLfy+1VM1kb2uC+mAoARapMYT+iJh3NdS8hU6TUzYZqPKlp3Gk?=
 =?us-ascii?Q?fT5yFfT517Q3wdaP33kD2lqM1YVNEAcDQUFQj/XWLbdBgohxC32IVziFF2qL?=
 =?us-ascii?Q?smyix6eZBgXoJOA7ySpwdDoHgeLjBs5UsEJhHA+JEZhSNi44PCCGTmA/0mRw?=
 =?us-ascii?Q?2Jvw27rfPHUXZEDCt0r0MxjFIZg+EPnmYiUG1XcaVbzQlhrwO9M/q5EViWKD?=
 =?us-ascii?Q?SOSQYZfudFcpDQ6BMuHpf4RXO3mkLAeYb65qT+Ek2KqND6uQ2dOBcgY8/bEa?=
 =?us-ascii?Q?tmPGkKreGgp8qKZVIQ19pfBTRoyIJ0KiYDgWBHXU1IWEywuMmtbv9cj+5EHY?=
 =?us-ascii?Q?9dRjFZ2zwO5mhtfoz43Ah/Mk+lxVKYpcEcR7XZY5sWAT1MGYYV/sQeoq0HAD?=
 =?us-ascii?Q?bAt+PZnbAdyO8VdT/2+5Of53gxn7cR5QJEdmENgsuRU9+CCvjX8xwTZza/Jl?=
 =?us-ascii?Q?wLBMu8yrFw4EHpyp6Rp+U2pXHfVeBaxZKKtWlV2OiPIamnEtK6vtQDWhNGl6?=
 =?us-ascii?Q?LZtC/d4SXocyj/UhpS2mufCgY/PAyCOunKoTUw9apxuuvbHr0GkSMbhF4Z1A?=
 =?us-ascii?Q?1Cif5dTkdMrx9mNKhR10ybJkIb+bBcJEHY5bevDrA1qbt+9aJ7K8bCF8vt+Y?=
 =?us-ascii?Q?nsjlvHW1gTjf35Jucq3QIEIxayd2O//mZKtuDn6BYTfVddxY5vcVvIi/EGg1?=
 =?us-ascii?Q?zH0FgC5c/YdG079u/ZUzKqCiXQXfuSKB791HsyKrMmILSW0oYpgmQPgUzuV3?=
 =?us-ascii?Q?fFw/lDDwkjcyohcCJl8B9XD06Hvtd53YyzMfMN3fAEc2OEQqbx9rVt0YBLts?=
 =?us-ascii?Q?9tDv34kIUw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ku5GWcKZEFDmmGO5rwrCfttlgQF/FtTF8IyN8fjN+FTDnZlod3Yb7vX95HbFUHU45+UqiCrz0Bb/cUHEUMnersZ/giXzbEC1AhcEQTxYr5Ele/UfHmwPz7qddAaNqvyepTlt/wTUV3DdoBlqfb864wKAoyhX9+gbMzFXiRPS6B97pko3u2NjFxHTWecLO1sYREmL/XldZReK1a+z9H9z5JUmXP8MDq/jY7vsXzI46/VHdtm1isn+B2vwszW8AUGsoIJZ7y/vqUW+DOl2iSIKD9p5g5vyh2xwSz0UTJ9lL+ywtqVMwJgeIjfIuBzgHT3fhJv8IlF2NbmpnzUYOIBi7F0rXeCK4JeSm/ku8PmUYpt65wDWvqd2jn1HtCcJvoI8fdUAwR6/PAqHfKBHjQ8/zSO+RQiFyq5thD4TGmPnNlVCa4YkVBK2hz5//d+QuEYkCOq5U9MBv7XHmN27yOVn6zFua2qOW8XLeLBz1UbWBl2wwm46WsACh0zcGnCkGiqzNR21FFev3z1nuDcSg/Xu5J3gXiZ6wKP4jmX9fuOUzmM39aAqNnSW2Gw9pKpjehYDD2O6HRpJ32g3j79kpNxf2rBG5iRKDqOxT+PHix990Mw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18b7578-784f-4704-5d18-08de4d33e1f9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 14:57:16.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvlKUs3ZtRoGPwu25cIsnGGLi9k1yatNQ3mfR34BzXwnn3FzoJqgPD8qm+Lc0j2sl8VMW3/g2awTGbTadbei4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=905 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060129
X-Proofpoint-ORIG-GUID: APbNtzYRngC1ED9BfMuFyjnF_8vwP14A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMCBTYWx0ZWRfXz4F8z4pAxNPS
 AYBMZ9hyXl1b+thvF1MmFB6t+2aIymjvuYQIZBLuYM/LIK/9BLUF6asbTvIjgWHN4/n07ZKmHJD
 TggvPdemFEmGECrjuJ/sfiZTsv/hd1+a2OtpvsRwRjHlrSUesB7LJwSwgrFpzt/m9yvCfUnKhbR
 dE9NDl+VTHTuGQfjacqJawBW8SYa1kQCQeKtiXD62yhVXqX7BgxWcbIM85Gn4oomeNqbDjMRkJT
 FpCSZIejz8eXb06c9HBp8WZwAuyHMieCMnxZ2OM+f67eAovaETb2Eby+E0MnkuSGJMxxe/N4b7K
 a8QU1z+ZzVzbwoYI/VXKna+LjP8RaB5+dEPVL9NbKNODAlShQa5nJC79525GzYs7TZOu2R3SuTU
 /s1Zj6+qM2E+jU6QLico4kdp/Y9E7z43WdudrbafYTRQtHaWxBYT4lJrUsWrOTcSzUPP6R8uPcd
 I6zFd4nd/d8g97KoaC5nL1vdMlGK3e6PjeZ7MoJU=
X-Authority-Analysis: v=2.4 cv=A+Vh/qWG c=1 sm=1 tr=0 ts=695d22d2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=mrkbMhXnIUMd7q6wHDkA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Proofpoint-GUID: APbNtzYRngC1ED9BfMuFyjnF_8vwP14A
X-Rspamd-Queue-Id: 00DDE140010
X-Rspamd-Server: rspam03
X-Stat-Signature: nu7toaut44i9mqe5f4myoq9pmz6bong7
X-Rspam-User: 
X-HE-Tag: 1767711449-298631
X-HE-Meta: U2FsdGVkX1+AW7r6kj8ygEM2SXCjP0x1foh3oGQAJBC43kcSH4WNmyB2Q2hP7BTuwbCp5j5Jgeyd0YKaxO1i+PwB9ZQyeBCI9WyOXYVwfb+7IkNwQQ76ot1bkFKmroBwORftgBPP3gRmCOVZs8doIBGIuHst2Nq6L9n48H1vvr+hWuu6rJ91kgTsYalizVo2zECGGiRlyoWTZ9WiwYsX8PRY949UIYtKcfk+8zyv7Ptz+TjR+wZY37NiN+SXjkdDu4h9fjV221Ruzfo/X9a+Q9iyU92uHHy883F00ylIz4CCkLRE/xehQEQs1w+MTul0rR4l5wvhxTNteg/t1BZzPQ1dGFrVN09/yrtWwa2snaUMM9nY6sNPJCjAFyGi6Tko9r3Hu9oFfy4vhvfHYYIY/es7j2GgJuU5E5YQOUhshJeiezwjMwpEjdXHewtn9rc/Tu/gbBmk3kG+TUQC2m5sNNMCXjYdU9tuB8GZFPQNylnhjJQK+BaF4iBMKbf6eYEbwaL7HI5OTS6ar8H91ike/ltsscsi00AKEjtHO8euLwRpdKbmv1XpOZ53b4S670WZ6RHBliTQl+29ehpco9yHZGnVaBpwohW1tRNKbhQmpqHSlUCpZbkojsC3nSUiYvFBZXsNS6QhNm6omwPWlS1h11xE3WLQVD05dyQ3GzbmCKJcwLNRyddGCE21XLUJdbVr7EUEBc1bbfi5IV3TAm62uE2dDBo4bnahsS8LwoL2LBd+OlT+HJ/v2k6nlXxTVjw+Z6o0TOvOzbZUPKrdbGYuCnW6oEJGOjjtaMaRvrm5WxFYKXir3REDEyT5HwhJCjaNLfwRgqEbc4W5SaFN1LfhjccT2p04NAJg4LfI/CGSFr2CMAhtTXIP9hBFtpoWn+ocGHgiHmzz12Xr2aygSPDz4lEcdFMRxV2xMHkLJCUpnuupAdeTZW1LlLgvPuuvLwsBzwV7bTM7x2hghFSYtN+
 SnhZU0C+
 yh28JGdMq+iOrxRJsAoGeqmS1qYOfn1D26pocH6nAArUfQpDlXlh5FAz8nldyflyrsTDboFOi8vT3OwxElVnxPnhgaWkbSy9wM+pxIYzK///ykZ0RMJk/5b3Aeg7YvMw9mG0RqsVWaj7So08MfBP0toky3ixSbcg9SZXJ2Iw3Z4wSV6wcd/hCRhYyd+BVsoapvXQFPHoUwqpAthChIFn6NugjdjjUacwWdoS5hr1eZx04jx4F7asFrBht+AKRMTUVyRph4Id+Njhi1oIj+O++lR/3rGDPyf7hfEndmzgNrEQM0Dr6JwVmjg3bI4CcBtGMHhGhLBpGnJPW3WqDkeW3t9HkhbFUWlq7ioM+f31nwuZAbRjGXigtq4PoxYb1DoPJsDEVRFgeNChYaLXG8qzFTkQ8H6WFQkOczOatr7lL0dU9+BM/3Lmsf0ZRn7tubqTbiSc8MqpJJIz1LydOj1CzpHam6EjUvJ8V0dPmAhS4xJyu6reRiPQfn9Y7+5aNxqKrBuktBWF/9hxX8im7oHFW3KuGXIhnFddc6hBO3EuERpiJQlmou7E/toCnxgKW2iqXysxKsvBuRXA4VCVcAzyay/drAWMr+k4/ZW+MLw+fiEG6KmGqW/UNjhoJaUKtVMkDBhqBpew2w/Qpmgu+SFEiNzsvX63htQu7UuJ/I8KDO3gpZSG6Y4s8TsAiEVcQyA3p8nL+8gyTbhoPeK3fCMmvuo4QWIkv10mPt5/P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 03:35:32PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 12:50, Harry Yoo wrote:
> > V1 -> V2:
> >    - Because `pmd_val` variable broke ppc builds due to its name,
> >      renamed it to `_pmd`. see [1].
> >      [1] https://lore.kernel.org/stable/aS7lPZPYuChOTdXU@hyeyoo
> > 
> 
> Ouch.

Haha, it was really unexpected :)

> >    - Added David Hildenbrand's Acked-by [2], thanks a lot!
> >      [2] https://lore.kernel.org/linux-mm/ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org/
> 
> LGTM

Thanks!

Perhaps I should have clarified if your Acked-by:
applies only to 6.1.y or ealier versions as well (5.15.y, 5.10.y, 5.4.y).

What do you think?
(planning to send 5.10.y and 5.4.y versions tomorrow)

-- 
Cheers,
Harry / Hyeonggon

