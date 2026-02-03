Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA5DE8306B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43A56B0005; Tue,  3 Feb 2026 04:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1516B0088; Tue,  3 Feb 2026 04:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EC26B008C; Tue,  3 Feb 2026 04:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8351A6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:45:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25BD8B9351
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:45:08 +0000 (UTC)
X-FDA: 84402661896.09.A4C7B9C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE3BDC000D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:45:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R2zQj5hs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pzIOZ+l3;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770111905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCoNy7szKpIWrDSBXwvXPNh8CyNuuPm01NytjiGsHx4=;
	b=rg/YiBWlmqN5BQP/wBLBN+zeyDVPX9pHTSq7M3xfFwUKvlCjpp9Bf/BBnU1dRWvtl0UMrZ
	0Qh/JpUQxy8Is+tQBjFpdFe8NtJphIOZSYNE54ElEQ3c2W6KAtQI7CDd7F2zZOu29U9M94
	ZeUMaxD/iH3arbmLgEzokZE74NUvGqo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R2zQj5hs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pzIOZ+l3;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770111905; a=rsa-sha256;
	cv=pass;
	b=ctZEKfBL3rXmrhC3ROH1kRDaHprtw6EF1k/EEkMa4Mk5Lalp1OkNG3wTnHg7K9iMsvdFHw
	cRgwu/PwV//ETHJNuNVfNHBlAFWd1L1lavk8SeS5oQP7U/pFnEiEmWH897cINSVcFITwhK
	fiZiTELmp0We9E87Lmsgy+c+1+fp8c4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6138vJs03079251;
	Tue, 3 Feb 2026 09:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LCoNy7szKpIWrDSBXw
	vXPNh8CyNuuPm01NytjiGsHx4=; b=R2zQj5hsIek73Evn04bd0mOhuEUxJUzt8C
	nje7I5O1zNt5H4NL2FEcVJ2YMus9kN7kshJSECyh7rLHEB2doLzCrUGv7Q8Ffgj5
	kt8Y1pPKDHogZaWpD2wHWc364WoqAvdGRK8vW8+5fMtH5R1gCWtGcQcqmnENvJXe
	sTyrkMM07pOxl9EMYbGSx+u9ih1YvEtoLyh2gg1wDBnoQMO8g/h8IAPGD3LUjCyP
	Q3mCoh4MN+aAUnUepzBOBrIX892zm97GgkxLVqyPiFcIBijFiEpRfMY9/pAZZGHW
	0Ursd71z+sLnW21mhSpTVN4Ue8ZHuKGkT2fsQpDX08gxZZFh1LqQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1axe3rpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 09:45:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6139b6XT002115;
	Tue, 3 Feb 2026 09:44:59 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186m4kvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 09:44:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Htl0hWHjA9GVmpsXd9EO1Oz9oHWkqcJqaRlFjZ0X+zPJirJWSQi2dwNEUOtW43A4063fD7dWBdG0rjJknkoo23t9RdHzg/SakJ8TJfBKuhzqr99trdckmowVkVnB8zYJjXO8nOxHvIR61OnXKN2zAdDUDuC3HYzlm+KD4b1TupyAnOGKfCVQhpeXAy7atAnw6OFU7JTGoqK04L1rt9XRGG4JwBKKKKGddN7ljBGbG42Qq4Xkh/fI0H/WmhBvHd+6XPg2DlnNLqRIQjlDOq9X8YxcsJuR2n2Af9VUZ4tZld3asDIBLvO2PbgltNvAkTIYyvMDf+tdSwULDZvKMPHBNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCoNy7szKpIWrDSBXwvXPNh8CyNuuPm01NytjiGsHx4=;
 b=rkphHHHQ3Yf7tbXoKlmMuIGLBK7PqBr/28fWA2xrlPt902P3aCV2Nob9R8YtEYBqsRJGcpwDE3c+CLN0M584qB26uW3p+r3/TmTRxZflQCYCpPkWYvg3xRQZrtnTbxGY/Ys3bqTXufLXEqafI3klYNnobEPhegywjI8SGea9tREtWlZvUjPwjzDCXv0xCA8S4hJGtazWgwLjHkRiRBsHWuwyxv49UbeSyIuuaN8/E59pxJEu0M0/6OeGvBrTJAYaD26huaZsXKEPx6RVOcgvp8pcTL8Sqz3PvvncP52yrd+CCKpe2Oyl6WSnt8CQEpA0X7qhJ+VsuHTrRSqHKZSZkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCoNy7szKpIWrDSBXwvXPNh8CyNuuPm01NytjiGsHx4=;
 b=pzIOZ+l3e4j58kArRyz3kSFMULgrCEjwy4piMV5zrbSsfQ9BnZlKsAyewUP4X04IK9yF6KubBC0VkC5fdNDkV9fEikcugVgowqTe8SJYHDvCnzRiDLV9nbzghgi+Hd87SrdVfImsPRgvxTZ/3wY1zB4cb5QeneuamEt18QkcN7Y=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7746.namprd10.prod.outlook.com (2603:10b6:408:1bb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 09:44:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 09:44:55 +0000
Date: Tue, 3 Feb 2026 18:44:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] codetag: Avoid codetag race between same slab object
 alloc and free
Message-ID: <aYHDMvMUfKj4_eDe@hyeyoo>
References: <20260203073006.151710-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203073006.151710-1-hao.ge@linux.dev>
X-ClientProxiedBy: SL2P216CA0149.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7d2deb-9be1-4dff-1e17-08de6308e2d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CZAfoXlueDEeTp8kaGyXNLyg0Ff33mKcG7I3jHsnywSJCzps3gNWR0rafGs4?=
 =?us-ascii?Q?51fqFnCP2Yi6On9v1HT2PlxDjfPYdN1lemOrB007ABNLKHnbMXO8CjRydSQh?=
 =?us-ascii?Q?wnKwYGFd3kH/uz+xtaqEPzbRWSrNtMEafltCgXnjIlfvNnRG3azKB1tz6+Nx?=
 =?us-ascii?Q?Jybv4OAbmiGq/IAIph3z/fuSvsyj1hydlMQgNRUJBKrE0tQStheuprWNpHho?=
 =?us-ascii?Q?GiVCY43ITDOa+TpZKXVKOInusQsW50Ec0Zz+JdjCNUO0b36inocrzMEj5e3j?=
 =?us-ascii?Q?jr+MXW5iUp7rmVKi37uAH4EKkgn7JRY6xAro3FWj53JZD5DXcxIxMQyO4tDK?=
 =?us-ascii?Q?WV9u6Sqb3Q9t5hfA8/Km5dhbjKwFMiAkCOmmBkfsfkPcylvQwaUeHh9yXlR6?=
 =?us-ascii?Q?tBlRuL/fiZnvC7D4aEEvsKfQAfM+uAA2JVT9nQvwCWp/E9VI4aBa2Yk4pFlp?=
 =?us-ascii?Q?L12u/fsY60SWVzbcREwfiT+g0M1SAX7pyxx6DIF035cpwNOcQQn/Gl4iSwm5?=
 =?us-ascii?Q?aJ4SxwEzdWwD5dEPGf4XS3PGGcYfPLiacCZ6tIy+eKTYc+31J+8bS0fL060U?=
 =?us-ascii?Q?v6M5GI9LaGevOD4dCuekBT6FuDyP1hcvn4Xo+uQjUYnz8AyGUXrtYvGH5Z0q?=
 =?us-ascii?Q?hwyhPh6okIRAR1i13XO3K8zvEyjTQGH8OO4FynJF/4jO1Qm9RWMo5CgiOlqa?=
 =?us-ascii?Q?4JxgtzLCEzDOrM+3YVHi4v/2kmdKwIOQszM9VrFJei3fiSWn66GrtImq0FTg?=
 =?us-ascii?Q?s+58RD2WcGpV2EgtAeO2csrEZsIZ1G1o+5wzIRbzxMtKm0QZaswHcSfnzOBH?=
 =?us-ascii?Q?hjOucRfg49s900r5H//h6caeIoBTWj7DyYUWGOXdiZDbRr3DMSfgYJcaVXqQ?=
 =?us-ascii?Q?5jk6ENwSIEOZ3iIHY+QU/lpYnDda6VzG0rKJ1eC0Byd8FnCIpcZZJc/PvDdv?=
 =?us-ascii?Q?JNQtH3q6Nq5oRmj1TAIWI2CXeVuGiB1PzPqSZCdHIdEJhSudtOCoAfXJqXJt?=
 =?us-ascii?Q?PsXh+Er+TA3Jhir0PJImjT+a7HKOwCGWabYjwiWenss79cnN70VwNodmk3ve?=
 =?us-ascii?Q?rfAe/LKq4HSUzAG/u5qjKouDdXKEy8fEJysaVMNrjnZYm3bUzz+1irPFMfuL?=
 =?us-ascii?Q?J3Dg3BftXs/BoZryKyiN8mJkiYl6U+yLWkuC4kRHszbM/gbTikmgFIwYbiAJ?=
 =?us-ascii?Q?GvSOc5OLVffT+veVnUEVHCLpG+6PjDfgOGawvFXxjK+N6Te1Sih0+m2/C2tR?=
 =?us-ascii?Q?rup9/liRUwKq7Y1HIzpfvq6xZHRENKmB6wu7QEGXt5UOSFny6QMfYwGMW1Aw?=
 =?us-ascii?Q?062CE5xBdItc4IqqSweZY+JUsQ3X6ylub6iBuus32OeAAbxeseMsQuEbW2Xk?=
 =?us-ascii?Q?Yvuk14KiUIUBaltYL+wEpV1EgODKpQ1isJjZNL8KunJAO23A/KY8U3lXce4g?=
 =?us-ascii?Q?p0ZdozgRlpYS3ain3RGo82hs01cAquwh203aAGs/h+prRxWmFRyHCvfnM6Ie?=
 =?us-ascii?Q?y/CjSmkD42h0Vhgq6k60oUnZJYPg4iUl2flU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?usSNSyUAkILbPHfg5T3NYw4vjFvuEo7vhyghZvKgCHOIMd78gyNoPSJeltr4?=
 =?us-ascii?Q?t20WpSiPf4C7b+Qj6IV0kVa51E1sxIpapacsgJ3knW251Yl4cdFw3DzBQ0wr?=
 =?us-ascii?Q?sKoBzLtLY/A06KZDQkCcS+KntB4fB7jc0u78EfU9uTq+gfYXODlTidSmkITe?=
 =?us-ascii?Q?fWzhTpUcc3xdUY7jAL55R3RXtKK2vdmySbd/ve355QDSvBkgCThd63qJ/Y8z?=
 =?us-ascii?Q?7HetTBF2ckYEmWOKWa6Gzai3JBsKOL3YKaKatrpqlYXBGzppk3olpRKmzEj7?=
 =?us-ascii?Q?swXxujZt+xQKWybknvREA8TMDxDlFrp86jisNs8DJvtySKp7k1b1dCtutn2K?=
 =?us-ascii?Q?BcrJbz1ncDvtw6gfKqf3A0CuvYm5pgiONF/JT+imjQS1eZWAwuaTQma6hByz?=
 =?us-ascii?Q?vaVNqZ+xGKvSLw6yeXMKYMNbGU4pNy+9lqE0LXEvNCZEAoTKHDBMYhM14oOG?=
 =?us-ascii?Q?z9xtXdxltSDCyqRfF6fcvUbjcnIn+rTLXtv/JEObQqVhBAHLsPfyM1XkkZFY?=
 =?us-ascii?Q?8/SuB88OCTIECZ3jZbZ0q+/U42isy3MT4Wkxtbsd3e5EHfaWNWuWzVxXT7oK?=
 =?us-ascii?Q?TphJTgvz1Q1xcz0zDf8DerhehSEd/8Rtb0peXb9bmCc5RZGmehdQcNL6vBJ9?=
 =?us-ascii?Q?6wSEUBNJZ3KqjHVHQTwb9rQNlVDayDVBaazPkKba3T4Ep2WuU37dUTt/zzIq?=
 =?us-ascii?Q?XBiYEpv3grMqJeFrnp6RbONGQ4SXNypxsc8aYxd0Txci4JVn0PztOYnL1X5/?=
 =?us-ascii?Q?+zK0DP112r0sSTfBjFl5E1DCe7xZ5pviRqhHsv+sxSSbxHULaNIY/oeUx52A?=
 =?us-ascii?Q?YS9kzjRhvgaBCYQCfQ3ha9yag5vLIrCpIR06kVCrWUsmwhxnZcXYQeAPGFl1?=
 =?us-ascii?Q?h5305dq8iQPLWWFuzMGRQqJGpCRTjG2UM1k8mqygIe+smBzQEqy6B/xODjE3?=
 =?us-ascii?Q?yp36U2m6ountekyTzJAR/QcIOSv1YPr2UwMdUjqNP3iCWA7Pqe2q79fb7h8T?=
 =?us-ascii?Q?sM6zbLFywbJdQxPjsoPsH2WdCcml7XvoiO6fxbgrhWeUAsidS3jvAThK3pHE?=
 =?us-ascii?Q?fZdDzp6reVJfgvIJ/vS2sHzMC4SJRr4aGzLHhX7kal4NkfHFXLYmZCXl2oZS?=
 =?us-ascii?Q?IUfn24fIdTzt+HV/0tCOWyKsk2EIjEb+HU3bN3TNQxsjAOgW5CZd29eiTsHM?=
 =?us-ascii?Q?VBs7kOR6qWwJsa6Vd//e/BrV3DHqFrwKShLfirOeUWPUDOYSxDAvB+Iv5nSU?=
 =?us-ascii?Q?mcdMfIOs4ENv6n5GqeHgWQYqOMCjDI09YFRORojAc0AQ26+4CVxbrtmQeyEX?=
 =?us-ascii?Q?+03oSIrbV7GK1H6itmZkCbjA6cgGib/nmnmpUpXEX+p1Ja5zkQN03MvfmcFh?=
 =?us-ascii?Q?w16sXEkgIvFbyAROYQpuYoh34wBf+KZ337BPTSZo/Z/SERMezk78oP4P90Bn?=
 =?us-ascii?Q?WqzNy0P1iPaaiJb4NAyBD3BGqxe8X9OoRW0PWjueBV9s0ucR/i2wuS2gp31Z?=
 =?us-ascii?Q?lSwTiE8MQEBzM4BeB611m+GfZUZE4yk0ghIvT+jGkgIuQ0Qmj9eGO3EK4FSK?=
 =?us-ascii?Q?lmf2tP5Rr2SLQVbZYwQH3XAGYfqbl4z4+g/AtgpT1sOMtpZ+ZcB59Z+rC2kg?=
 =?us-ascii?Q?mmKAhENCybt6YHHEx/3l3eiDyq4EZ8BZRc866f4o2T4Tv7kixRDk817QdwCU?=
 =?us-ascii?Q?RCFaCFrhGRKNadQJCfak25nDAqGITf9JRCJubisXUZ7jsA/S6Kc6t403+iAG?=
 =?us-ascii?Q?kTld3pW7pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Aovktrpll27FzzUCT/ZdU8dFjkhrVNf4QT8VxL2vuYs6ePJRaTWiv33UYzaf/rJPM9dN8YY7tLzM+eDkRG7cPYwGSOfxga+5yNxl0KsjsUz+sY70tf9zzy0/ePyrF+XqQVqhfQnQYLVOmS/DHcamrqAnjvkogKs5jRDfhDt/+SNRY2sIkvnckNMsBHqsPMeXDVas1No0R3FWvJSGTZ6QwWauqMdQXjqjR3xo7wuH/oiSfgtCUCAwCQputKoMEec2wT+f0fY6K3gkIUhMPogarnDG8Y16IY+gEBYHJqZmMybJw+LxLbZxQ9l8svr79GFh/XyJp/9vaV3dpXNIsU6TtMxDUsfP3lrcPQtcuV3WENLbxzvjzkTyPG9pu1o+2zvwh4P+LAzwmaKBP/9zB8CqRv6VcD3mcAVH2NU8NfyZ66yP1ZUi9lJZu4v1sfhmIv1cL4WKhMYTNIGp/5pdkIdYw7/iapvMQeXFF6ujDrLeCf2G+RA2GPwbzr5qX0w2rTHlLbVYyFjvn0K55XjuHk0PSUJ/tiHkxjMREIWa5ugH9Z7f0hgmqQ3JeZ/hbPXW5kg8IlNqwK//OeqUCBWFehR0NhkMnjeGu9DaXLJIZwjNAdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7d2deb-9be1-4dff-1e17-08de6308e2d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 09:44:55.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HAqb5whw4cM7Vjb+ICo8EWFlQ4qUts1dWRfCepJXkbtqSK1PPaUKNuwBsbypE/+4AUTL4OTcbEm+MyDOdsAD2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_03,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602030077
X-Proofpoint-ORIG-GUID: pqW1RaSxGbCNq3qpNYsjk0YUtZFRdu66
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDA3NyBTYWx0ZWRfXzijg+UwW+YGm
 g776P/TZu6RVjKaWtp2qe3+qY/NK7otOm2eoriDZID4z8tenM8U2Z6Gt0WOsSjkTZFcuIbFcB7f
 GYvP+44Gw6dayVZcbuQoztyUd9HT2DAQJQcotVdmmlkcwGrBhEv3eGOOhKbrChlETeKVhVmST+m
 godB004FhhBSaeK1XUGrRVqpyxUD0z7Bif1T9x7Z2c01pLFaPATyIXq+M0Lc9Psq0tRD4GPv9or
 +TGSlXaB/hxb0MVj8MhsWbd1JJI4xHErFJqRU5HPN00gks9dfQlttRWMR8QXu7hFnYyCKSFIcK1
 IGvpAqPdVrb0p4maSFumXd/wnrjBUceTiAPv3LrvRzRxWL2ULcpkH1lLypZ5JVTZxnQ3T/UACzx
 MI9Vsob9VT95jmRQl/JwSh5VW4egDhcn3tRzc5XAKSS3rRzgvynIrpIVECt4RWxndORHT9+1ZZJ
 7YESss5YqzhrxgYxN7yqPPa3cDKwDzwg4in0fcT0=
X-Authority-Analysis: v=2.4 cv=F5hat6hN c=1 sm=1 tr=0 ts=6981c39c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zeZQ5061tcTy48i-DUAA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12104
X-Proofpoint-GUID: pqW1RaSxGbCNq3qpNYsjk0YUtZFRdu66
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE3BDC000D
X-Stat-Signature: uwm14mrh5oec3npi16drn1tuabd3ybo4
X-Rspam-User: 
X-HE-Tag: 1770111904-365811
X-HE-Meta: U2FsdGVkX19eXhaFx7jYQOgj1Ov1XXqJRSo+EatjSrybzLdSfdM9eWUnTE8OENix653GR8Vaofezyqid0+a5zVZ0NIOIz04J4ZfSN/9s8Ly0aHh9B5JbsEC9QqrKpoEbTUmRxAatRh1nCAXA43WSZXTqc+50Kd/CegOTG5u3lMSLKVkZxo+/k7G8L4T14aM7B5TaZRN/w5uqxVZiSHuxH9kVVNfiPjCRaXTaAjWz66ivveyYkf2xj69qwffDjXoVp4W0n5cXD/uu7/fjPBnXs9aVnEvlpQvKwyMJMqg1TbFhAxt/RQXGA5FWaAGlhls1UWVNgeFwDzyXrqnLgsJdhOA97MybDJfl5bl9CujuQOrUCg+u8JFibElih1DcRTj3jkwQbiIQbOkdyPWiGXWtTseDhK5j89vNKASKzaU3ebqHfopY3b8ecT3chRnPDd+ebfZ+HzXStMcyDAd5lAGXfY0EewSRFiZiXaxij7ciXolwbnfNf+dwIkjod6x9a7hyhSZfk6H4vAVSfkwrVxr78zB2vCmuloqTOiC3SxXjpFxP1VjnHkpeb4EaOI7vuuMfDb7SdpDAlM+VBBUM2oPrv5yjawysQtEXqn/aK8V05b54J3BTHoiHTZTUNeuzoDAr8UvHgz7mObHQDLTdMpIjbbyGw/Qk8yv5sSSHMh4guhtcBxws5Xo42pzOCP1jbvZwp6Rfdo7Llx7hatn3i4pY+etGis+y4NGqMHbC2UdNGLMHwvn4BI2+YC0IMYTqjWgXCqUWs2M+w5bvL0SaRXpxUInQ9lNDEbV4bOWiqsgStBbEWTOfhi6hYreH6ET2m/KyCnKpaYqq0q11iee/Z5MPd/0ZFA2MZ8oJzfFAaoMPeUZ1XOR9EB9oFppjF8NH9YAN8U4JbemNPD6vqWCIGyER4QjSm+DMjHNeZcsKk7m4VW7GUHbZoXNmGSoMJuZt6ZkUnHkDVfMecjEMBPiU0Ag
 ztDsKm7f
 jkuoXlptbRJsd2d4JwTHEAeTTBjG9XIfXq/K3OjtqHLoh+6fzJKSY3yvkeTUUNQDpwy36NaIFqe2yxay5CB6u0R+H3pr3HyQHuTp86tT0SetSoD5n8pUlKfvhIMjoSHQuxg2KsK8YykDXTbhjgNBZ9+8tb95OpADf44lx56maFQ1tlIdVl1aqzaq4sdjcn5dyfiberoCIbgTuEiGXOAP2OKBBW4xICv2RPjUlcUlcVaeuBMcj6eET+5w0OMqbgcxctUcB5EdaG6jDE9y8qxobq6aFc8rd25K2J7xizmxU7/rRRXBU5DoFbEkgt2wmWwqWe8SbW3p5f6BDF7zjf7JNhBEj20D4P5YEqOtpIFWsN5yjm3kyoVB5u+thjRKw9K92I9qVznCQHEMaJzz5N+BCeV4pbtcm0EWbmIaV4Rqk6zbnaoVc1ly+9OMVgddO+PCHUXzHPE+dsb2h3GOel1c5Zgno5hlttdtAVO2og/EUGvlmnnr9JXaJHVbHxEX40XwBI4EEHgmS0MHsNsw9tC0Dy/ituGb7lH1WjzOkNOUE7cSzPRViL89nvS6+mcq+bgLCO0jd2m15s0FufCLl10rfKF5NBjvPsqhBBIDjVjI8h15wCUNdZsM+0rjsvmq+6ncYhVpFB6yfVO+knKn1X7DpQvj60sD6dexA77cT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 03:30:06PM +0800, Hao Ge wrote:
> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
> may be noticed:
> 
> [ 3959.023862] ------------[ cut here ]------------
> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
> [ 3959.024182] Tainted: [W]=WARN
> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
> [ 3959.024214] sp : ffff80008b696d60
> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
> [ 3959.024340] Call trace:
> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
> [ 3959.024369]  xas_alloc+0x304/0x4f0
> [ 3959.024381]  xas_create+0x1e0/0x4a0
> [ 3959.024388]  xas_store+0x68/0xda8
> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
> [ 3959.024424]  iomap_get_folio+0xfc/0x180
> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
> [ 3959.024441]  iomap_write_begin+0x198/0xc18
> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
> [ 3959.024470]  vfs_write+0x4d4/0x928
> [ 3959.024482]  ksys_write+0xfc/0x1f8
> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
> [ 3959.024496]  invoke_syscall+0xd4/0x258
> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
> [ 3959.024514]  do_el0_svc+0x48/0x68
> [ 3959.024520]  el0_svc+0x40/0xf8
> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
> [ 3959.024540] ---[ end trace 0000000000000000 ]---

Hi Hao, on which commit did you observe this warning?

> This is due to a race condition that occurs when two threads concurrently
> perform allocation and freeing operations on the same slab object.
> 
> When a process is preparing to allocate a slab object, another process
> successfully preempts the CPU, and then proceeds to free a slab object.
> However, before the freeing process can invoke `alloc_tag_sub()`, it is
> preempted again by the original allocating process. At this point, the
> allocating process acquires the same slab object, and subsequently triggers
> a warning when it invokes `alloc_tag_add()`.

The explanation doesn't make sense to me, because alloc_tag_sub()
should have been called before it's added back to freelist or sheaf
before other threads can allocate it, or am I missing something?

> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/slub.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f77b7407c51b..0d84fc917a89 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2261,8 +2261,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>  	 * If other users appear then mem_alloc_profiling_enabled()
>  	 * check should be added before alloc_tag_add().
>  	 */
> -	if (likely(obj_exts))
> +	if (likely(obj_exts)) {
> +
> +		while (!READ_ONCE(obj_exts->ref.ct))
> +			cpu_relax();

I don't think this is acceptable - it shouldn't wait forever even when
there is a real bug that doesn't clear the tag.

> +
>  		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
> +	}
>  	else
>  		alloc_tag_set_inaccurate(current->alloc_tag);
>  }
> -- 
> 2.25.1
> 

-- 
Cheers,
Harry / Hyeonggon

