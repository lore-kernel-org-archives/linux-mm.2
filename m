Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49936CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B3D8E0076; Fri, 17 Oct 2025 05:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763598E0016; Fri, 17 Oct 2025 05:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A658E0076; Fri, 17 Oct 2025 05:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D67B8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:44:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF9801A05BB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:44:39 +0000 (UTC)
X-FDA: 84007121478.08.58243D7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7172420003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:44:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FyhpXu1a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zkUpYMU1;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760694276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OUyGRk4rNuea11ZO9izlrGFTy03rauHDBiT1qzHXTE=;
	b=2+h4PuK82NmXmMlOoqm9LyehSEzVAbtqjuiPeNNttLR/CzZzU/YDrhJ00YXN1QwafhkFcD
	FGBfxOVa2z6nEoOUivJ3YIZOmY39+roS56ZxKtK1hWufbkUem0AVj8Vb9TvchyJ2JBDVnp
	Rt/p35nNBQ/+FQ1dCVvXOP6KI7DdDQ0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FyhpXu1a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zkUpYMU1;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760694276; a=rsa-sha256;
	cv=pass;
	b=jlXai5414cl0zz0HaXWYvljOjhoh9622K/xxlj+5dd1PxoocwwWFnrCtYnYUTyVPJscj/M
	kpkQnRuO0JPGCjbFXvjcH/noqrqTH5JZFDRGIFOBsGRDGb97Yd4t1PBiLhckd0vpj0KlvC
	op4cyvsWS/0O9CifKA+ckytf2o4ShWc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uCXF017623;
	Fri, 17 Oct 2025 09:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8OUyGRk4rNuea11ZO9
	izlrGFTy03rauHDBiT1qzHXTE=; b=FyhpXu1a/zo8yKPfTx028NQXH1rV7LFP/M
	G20Q9R8eYSIctYXbx/Y6r17mOw0gTOXalLbsaAKiQ1VJBjMxTU/0XpgQdjRc2CI4
	Dxis9H/Uw6Touh0H9AIrFJYCsgnk1UJAqY/2y3YmsPr93PmUKaIZqEvwT0/cfnki
	N8iScB52bOisDMKOVBph5Nt1EDY/5fkpQ82zMnU7zlRxXNNETiDXHJzZbfCB3u1i
	23mSfv+B+zCYkr3y0NJx341QjUlJcxWxphDxxhkiH4Jn/TVTNNyMsqMaslfr6bAt
	iniWIMp590RznzoDSO/2CMCk6PRYrbkl1BD4KJlkz8Rin3u8kuFg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59jp11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:44:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H9ZD8l013633;
	Fri, 17 Oct 2025 09:44:27 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpckvph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:44:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+D2iPMaWpQlCfU4z79H5x+Quu8xl+IvQ2SQQLDqYPHlLTChe0NRGqbzn7Knhvt6gaCG49lKEwMShpeSe4hwbqrYbbRlNLgzc/nmW/v/hNlv6kACAwZylv7e6X85DH8Ydx6B+wD80z4OIoY4jsRC+bKR6FZbGG91P83wggWZ4RrRJ5d3GaJLeqzEHOrm5Hc8uREbgDOEpPfhqYxa17DbABkUnOEfjQsxmWl81X+2w3IiIZUjxFmrEVBxCFbzxlndSpbouts0aCoHj+kqOFHxLkt1Hbapmcqu6znEVxcnMXkc5V3JaiOZtXcSjIygNNID4wtQHVOJwDIz0hQc4KsjgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OUyGRk4rNuea11ZO9izlrGFTy03rauHDBiT1qzHXTE=;
 b=QPC0r2g8btmpi9cejeRudHBl2eAv5FxjkTUnh8eEdP6oGJWCnhBjkwp3X8J6X7L5raZwb5iLYIj5yzBrbS18DNX55f8tKPnisqE0SQ24Ry+Adkfodf7Ds2wZ+WgtYDuqmJq0iw9x5nB15kzBbM7cNEjqJa+AkLKPoBrXcTgJNuGpWJjH7JGGvSClNBswNRN6uxwl4lRd2QBOe7tPR/EC+VmNjYJWE0TLVSz/mql9k2rbEtnrBwvUPB7EhM7zFFq+g0iEOwb3Mc7zdMPJdC+h97XJI9wg848BEIwSnofIhhmi+KzjFSbdV4/8vllwVWZMsJmtlYdWXOcHNaP1ECOsBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OUyGRk4rNuea11ZO9izlrGFTy03rauHDBiT1qzHXTE=;
 b=zkUpYMU1oexIMs8ugHDLrSc/XkrxbxUNjQxe1TTnu5z0zQC7cO48uiNOJCutGcvBicphRAyoPN+b4UXiC/F7Gc+MSDVHfY7H3kf3NnMbey0y7s1G3MRjUi0d3aNKMwRNgvUmpmw2N+g6a7V58tUm4iXH2Ki9zAZ02yAWQKhMGVk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5677.namprd10.prod.outlook.com (2603:10b6:303:18e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 09:44:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:44:25 +0000
Date: Fri, 17 Oct 2025 10:44:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016004613.514-3-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO4P302CA0016.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: 75fe863c-5e28-427a-0e91-08de0d61c227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVemSRE/570id6pLT3kRn9NPEP/XcBUa0l6vUX9O5M2mDPMWsyruznoKPEJU?=
 =?us-ascii?Q?b+6SP24PYoTO7Z6IVYHal+6+WXW/CTgTsauTC3a8yfAopar6xiba7AVopbvv?=
 =?us-ascii?Q?o1CojNZwiIZrdIWBXj75Er85EYXfGDtjDIJc29kkRmgUnCb/VpLfAhFr6zDq?=
 =?us-ascii?Q?d03GwyCiCt1JwGD7Z5gUUn64sbzFmrWUTmh8tmHFROXklWgCkkDEIMbGJXVA?=
 =?us-ascii?Q?DF24kcQMCbBWudKeQynWXYY+x7+ROOeUbmbEoC+5ih4abJ/gBKxvMj9jUZfZ?=
 =?us-ascii?Q?cAit7VeEOtec7nYbw15C7Z2NXx/kiq0ZMpEDAOpLArbXokkqwAkbkXtoxyr/?=
 =?us-ascii?Q?yK0Q1gJu1VRu9tzktfsskC7WHzmsGRESX1OLbQ6xtRALtkw9tebTNmmbLzli?=
 =?us-ascii?Q?eg0HiZslCXCsG97VIov9YfB7WGUcZnLaJ2zN3YzpsffpsgA/RK/rggQMCAww?=
 =?us-ascii?Q?YLyj0k9EbdJFNaMf0vKn6f86vPLez+G1yUWxWXJXps3hK9nIK+C0GhHqPaVj?=
 =?us-ascii?Q?Olb4odrQMRnDD6a9FvLvJ6KXuCd8rhpJV0l74WzJm/zjIJDDqC7wwUlzCIJp?=
 =?us-ascii?Q?OUoFFalyvB8cb8xZaMV6xiJYIrqldv5c+TgbEcIHB3wFq7g/iCICdyp90dlf?=
 =?us-ascii?Q?t9J7iqcnR9MZ72Fjv27ZoLn8qKq4yMLHCZISQMYsekNMO4ocF71YlbU/Sytp?=
 =?us-ascii?Q?Wna9pqVayObVVs6URU89vdbihcqSd7VoAHdy9ACL8fxpI4w04B1xn1GPIra6?=
 =?us-ascii?Q?4i1f/SozgDqZkaZKLbx8BlrFPAicSTFVYmExQQwdzSAR4WrlM3qp2y2K6+oH?=
 =?us-ascii?Q?pmVcIRj38gvkMioiWIW8Fj2BnLwvxpwMnY3r5HVuzIDcCVde0eMlWl7COcP5?=
 =?us-ascii?Q?g2gG17I48Y5VJhrtCSQWfO+ekDfIRePZlrdV621z2liUagADNcrm32xPGTAE?=
 =?us-ascii?Q?W+Rukh4FzfzB7HHe5J/dg2Es/92beyMxNy1r1SDKgpVmG4Xn5kuFQwLgnuUK?=
 =?us-ascii?Q?aoGpJ0GYOGuAIsBW3m6MNUS5OlTPwo58oRp/YA+ZCog6kAUvVDbMOBfB7gtT?=
 =?us-ascii?Q?Hid/NniyXOE+D6zKxQE+3M+VdnnBdwLCgjajzDEJ9XCHYEGbLnqDNoWPSVpp?=
 =?us-ascii?Q?VV3NrNZUxrTZ7IKGGP6Cd+YFQ5qnjccUPYrVEqzsH0oIHWHMF/AMo8xs5vMW?=
 =?us-ascii?Q?DmPYxO5FBjEwITVX0Mqq+ea1x+pMSIGOg7T6vAYXzeLAM+4hkMIv2+4j+RaI?=
 =?us-ascii?Q?Z3TrOjQ1vqqNzLOT5+q2/2PykB790MnIe49s80CVUJ79HikLZl+ojNm3f9Yr?=
 =?us-ascii?Q?JyHC3KohgVkyWkY7Ay9dipuFHXf+3p3k4VHrleHT/TD01S3BtEZ5J/JqikCU?=
 =?us-ascii?Q?RmikqanbEYhoeQLQ5ZaZvd+r1C6+Rj9FdZB02lu2cJJiQ96Er66S3+XHOj3u?=
 =?us-ascii?Q?024PNGZU27VjCiJ1LgYqsX88Pc1nivik?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ktxRb/8++G+7DfjNtcQYMzXt0u0rOlOsr+w4ibrU58qzdK75Y0fMURI2Ot54?=
 =?us-ascii?Q?q0l1Lpf92co1hgE/DZmqHl3aJ+usqUk6p/AJH9oyEPMZSb1uIxNT+5w48mMd?=
 =?us-ascii?Q?xLJ7v0u4PktJYb2BdWlLl/1LEGMYwf39ryrSnrDBQujTYK/MiYYA4P4sSLJ7?=
 =?us-ascii?Q?KNi+oBRz3iGNsmo2ivcyI2YmLYKWZRn9rLwIHgySALQEs2d+IrIdHIC8VbD0?=
 =?us-ascii?Q?qR6tkUpHsQ0J0dY3shicdIAmqniv3HC5VubCHjc3Wng/E3FoItH7digb/Ad1?=
 =?us-ascii?Q?vHrbz3dq2tsOsO1h/dYBF6HHlsFYxJpjGooEmepva2wLq58KgOOUYbanBE5n?=
 =?us-ascii?Q?o8ZOx10wkMjTJ2gYPG82aAYXZLJNurb6AIXzNOmFWv/MgXhF6oEAWHZTmRmT?=
 =?us-ascii?Q?v7KLlLhUW7l6TMSSn/XmzUPYRzxSgCPxFH6T3wcX1WkpHkkbUiXNaQ/FQTC8?=
 =?us-ascii?Q?+tCb9367YlVk4bvqDsNr7FaJRwdXvd8MRwFYtdeSuvFkPEcwofP7h/z7TrNX?=
 =?us-ascii?Q?+W9YRVQPAhJGwpHgaGiXFj3dNhLjyYDsRX9gvdE7YCJb+xlheCfnJ0e4C/F+?=
 =?us-ascii?Q?Dn6tgnfvdGiCXjnlWZ2gcxg0YLKwbAzKmRRFwujYgtywegU2BUwkXJd+Usvv?=
 =?us-ascii?Q?YO2O3542uo8nwEfFwqjYOykHY1Vr/iM20GXnTSApSJra9laL0S5sBsPYqHKY?=
 =?us-ascii?Q?ieUbwsNUphrUtL3y4YAIwbgDNw/lG7bPWjiKljaYP78M4cdy1Vzp8GjEsH6v?=
 =?us-ascii?Q?d+I4bGRnttISA2w9L+zsYgA5gfdDkiWtlyZF03dt/azwNbJaqJQ992esWQc2?=
 =?us-ascii?Q?LMYh/fg/TRWBiPGkeCB63qYqwtvbS/0zvr/iw8hGb/+E66Hgc421j6ptQTBf?=
 =?us-ascii?Q?0XFLUcnutktpYnyuOffrF+A0Ytgk5S79b6d2XUgSQc9+mO0PJC/CTB9Visfr?=
 =?us-ascii?Q?RTn/GcS2k3XBa/9AFXP4Gp0LpufwBeVs5ALk1GSxx1pfxeFb2qXBkAXSsgDM?=
 =?us-ascii?Q?1pBSYKeMA3wCOjVcjuwzPYPSotOq+Uy6PF3I5ikuvOwGCagl4eKRoULz9SyL?=
 =?us-ascii?Q?edLPHFdKUDGel6Ix5Gx4H5NGIpvOtxPktzT7utkHJB6doTcSzQuJWypoKxcM?=
 =?us-ascii?Q?6gPAHED4A86NjXymJ6VFRSBB0vX0xLa3RcNltN3L5seRAUarLyDplA1nsQft?=
 =?us-ascii?Q?bprjRmV4QcKpE5wHwiHRfv47oQlzhBPp+3CRPjds2MLsS68SHejtpl4Xsn6Q?=
 =?us-ascii?Q?PGpI0KbRM9eO+ACeP2sw5Qi/QaxCv7zWme5XSjRXA7aLXLdgn+hBiDSUh6zr?=
 =?us-ascii?Q?p0pE8PLEd6ZW1//8zv5ub5czJcYpdVwpFlTpA2rOvlq4hCRWKIdKkMhk2I4e?=
 =?us-ascii?Q?DQ594PDyqhwNfYroF2+PTqftWt51ZhHvKjdO9tPy5ak6Ds6HwgpAk5TZgOYb?=
 =?us-ascii?Q?5CNGHph7YYW/T7Cn+r9ShRNr6nbN6BlGjoI4qp5+r3gb6+O5nBxfUnvpaJKh?=
 =?us-ascii?Q?MdSQSXhjZ3VZAtrCbFRvTBujQxMTkJz6NoALDVt0UNJKYnv/C+rPizbd6YnH?=
 =?us-ascii?Q?T1jT8a852AG1aJjlNpM/czuz4f16U/I+oyjrLlakOv6iXdQm5Ls3eq8NELyJ?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ssLADE65ae9ToFvmpARcpF6e5Gw08GUAmKB5HtNbBphUGsP4MYBazEGzDSYvXe7ogS5EDtb5dlKSNwSCcukRcYxYqGJKYLUXzr5I50P8kaVJswxXowB6BhwW71gKriFdsJq0aiPp6McE47BSlIWHIwoxzTZ+w1EDGMj8gjrmledeY/G/Jeik/9PXNRHKW6kjNcQ3nUIZnKyQ865lM7Yh8ut/fqbcv51uWGK0JKpFjGAwi/G/nUb0NRicHeRti/rbWWH9Ahu0+8QeTdhHd5xpMu4/WqLu8XF7Tktleq/qnq1xGTga1l/wwidk7Nl7x/uOKZzT8TryBI69yB/SEh5hj83Kw60rSPCjCDHle1UH9mS9+49Bda3ukn6Aj15y6yNizP8gw+nDyG8XRjYtMbkbdie+1l/Mwnmi5Lzhrk8JQeeS5iOIyBtQgByVgxoFAcioBjR7Ut2Hpfm1cKogISJT7pRa2vaC2IIovzAH+ChGtj3UqdQGnmVNe2Sbu/Ik4GT9OzpVNGWvE+B3tps4BXFu4kf4web29b5lJdyHplB5S8FnFotscWkCG6p5pLD05TmiPuDd4PHZMoCikCdLuR+U7KW4MrUS2Lxs0fuMGlWSzxQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fe863c-5e28-427a-0e91-08de0d61c227
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:44:25.4105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NtFsGIQGKjaYlB+zZNXhBzq8N7SzvCbFceuEs8fK1SGIO55X6xMMx0R0Y3n1QYX0XBc9qVxP4cbaHB4NGR7g5fRgrjff8IwjbTJHrQk/oY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5677
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=913 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX2VQgmfpXVZqS
 rz4AO2kyzw8dnNyGYrs/P3XQ9f/bZpC0RVL0pzG5h73UtCCdnc8UKocbTIvpuHYNEr8NF7+9T5L
 wkui8I4BHAuFxQaMNGTcoKbMl8SA18GpAapO2EEWGVjyGrnAm3PO7f45/OgnMZpKny7Rb9jh835
 3dIRQj/6vwTjbR2N/7uBb/jbTCHPq7on+boA1eNX/b0Su6QeJBMWk0rytl/oXwcHI74WJZ7Vvto
 eVw5EQSdUkVuswM8p/zTyNsg+cjA1WMP/Gh0fxVxf6gPwe+EH/U0xUaizh526jiPZNFxGnnMFXl
 kvtMBc7WCzk7tf19MGBcjtWCKCdfHNsrkuf3YxDEEy4s2PGryEMFhQSVDGSlC7JLzkz/GONiuNb
 BxeWT5CSiGDp6x5qE+UO67ioZ97djvZjutgx4INvM2VUCqvvxxk=
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68f20ffd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=ePqjB_eq0OGTjVj7lg4A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: U71WAslHVw_YwWQNOnH9CfT41k2k1qVa
X-Proofpoint-GUID: U71WAslHVw_YwWQNOnH9CfT41k2k1qVa
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7172420003
X-Stat-Signature: ccdtd35txwoubz7g5mckbt7q1kyc9um9
X-Rspam-User: 
X-HE-Tag: 1760694276-442209
X-HE-Meta: U2FsdGVkX1++2DYNwmw7es5Cyf9i1+1UHmqt3/JPCYsPlrZWKTg2/4Br6P2N27qcLjiMdctXZiutdEDdRQJlaJQEGAA3QhFYteXfE3raBJJr+N7JHkjeLOl3ZLZRaMSgAvpsR3lxdekbrpG3A8ZkZHD33wr4b7WrPiQ97E7rodzQuoOABrkOl9IPGkNj7Iz+A85vENGGAf4NhZs7IRWQ/sJE7wR0dlaBRMiKVm4g+C4uQ/AON1IrLGQioJfNyr7V39/pQk17KgnrQOFBf6+h+yOKV7HhPCuQjDqnixtmWopytSmPdWZ0nWDyInf9hWrniJwz/2+ZlmIdMb1g9Qot6VsmqqbNs1UruYI+5PklVrwf1zgBeZUzQnnSALgWwXZuZPJ8EXyhbz6FoWevhL/sIBu5DRrjNnMCr6h/giYJC8XfrJ1UF0ANi1H7IstwQynJZ1W6I/z6WqMhdKuZ1WlbTjDrgLV8Ce5zgftX4XKW9FPoh08y3mzhNhaz8p5JwJwew10dGJS2t0GfX5mYMEvVou5jc51euFSrNytQcRh88jr0FBRcYAWdpd8UmUqHtHBjf/7ASln2P4ZVtBrYb5EH3s0o7GmdZLYVrrvHTe0bVysyRXwfqa6Pvbj1GiW8hQ3lmhxlUYCNGbQf+K76pZjdmSeQ0Q+bfn8cTteagJO6QqLSX7EzicwU9VOnvukBjdzAXGi+CAbDkaO58I/x5XQ4kxv94aBkL3r2ioIKofN4E/TuII9jW7UrafZbH4eIOuFjusqgT5BeWTqelRcXpdyIA+G9oyp0d4XYMOr1lkVZBWPpv83aKc7PTOz7hya1Y8amQVkPFa/VblKUlzg70fcQImwHSyzLpwcfA/Auzk0xaAqVDgB4z6MxeukpEk/Gc7NMBdY2mf2UJEbuYU8n893ei0EMexFx5yo/rwPfzNo8Dm8SYX8Wvk4NSmbUQYUPhamWo8XDlDfTVDYUzGTHBLH
 20lsnBQu
 3jGfTF893DFSNyhaeU6hgLCLVCUJsr5Saau7cnLWxjMQHDp6v0g43y1/VfoEScCSJjo5zqX9L8QeNUiChlUI9A5FTzUGxFTQCnfSFSeT5d351cbT3PimOKl3+/d0wyrjrWFfzErJNetA42yAGZN6Wm4EqUlovMpaeA0h8ej2rO4gocUHERBcwuw69fxzJjIPXkLSt95mP2L7TZw1IX1r+HtTt9D05ORc5X0vBlNypPf7bTRA60BzhErwg/CycWdmwqPHaoHn12FL7RalZTLlZNOHIu0hzbpF34nZxwaT+99u8FNE85FNAquGaewKIWAKA6TlFSfzeo9Q1vzEtpEFKbQYuTIoE044UhEF01zE8UZnKoro7rBVO1MwCZbBDdGH0Ddzr63NavoRH6oH54g2oAt+ikAFdrEHSw+JwlIPjq0bzu9OGewHaEA6PIRU7Os3WtO3TKPUzVy0Ij0qs1LRQudMbgbgc0vi1MJZ1FEJBQoVsx72D5E01lSLeSCIlMnYxeo2yPwu38SNYrZmuCYnkCSdlI/MrWITwN8s5EwzIblR+PvYosLlyDemnRXFPhKvvi9cqtlTcIf4CqCCE2vm8tqPED/QXxI6GnF5bgRRikkr6bmVPwRulvcvatZIq50JAyNuVSjxZSwGs1J6AvKSyNCv71IW0rhI6osHmUb4E6ZmFjM3ClRu0i1XbbHziISo5dJ71zHhMkbZcRopYBbG3itHlXKuagd6Z5Uk7PPpmolhTY3a4ZHcwS1f0x0NnsAHoHTm4ioSYUwgennauZFSXy3GYsba0hrUcOT3A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
> Existing __split_unmapped_folio() code splits the given folio and update
> stats, but it is complicated to understand.
>
> After simplification, __split_unmapped_folio() directly calculate and
> update the folio statistics upon a successful split:
>
> * All resulting folios are @split_order.
>
> * The number of new folios are calculated directly from @old_order
>   and @split_order.
>
> * The folio for the next split is identified as the one containing
>   @split_at.
>
> * An xas_try_split() error is returned directly without worrying
>   about stats updates.

You seem to be doing two things at once, a big refactoring where you move stuff
about AND changing functionality.

Can we split this out please? It makes review so much harder.

>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> ---
> v2:
>   * merge patch 2-5
>   * retain start_order
>   * new_folios -> nr_new_folios
>   * add a comment at the end of the loop
> ---
>  mm/huge_memory.c | 66 ++++++++++++++----------------------------------
>  1 file changed, 19 insertions(+), 47 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4b2d5a7e5c8e..68e851f5fcb2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		struct address_space *mapping, bool uniform_split)
>  {
>  	bool is_anon = folio_test_anon(folio);
> -	int order = folio_order(folio);
> -	int start_order = uniform_split ? new_order : order - 1;
> -	bool stop_split = false;
> -	struct folio *next;
> +	int old_order = folio_order(folio);
> +	int start_order = uniform_split ? new_order : old_order - 1;
>  	int split_order;
> -	int ret = 0;
> -
> -	if (is_anon)
> -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>
>  	folio_clear_has_hwpoisoned(folio);
>
> @@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	 * folio is split to new_order directly.
>  	 */
>  	for (split_order = start_order;
> -	     split_order >= new_order && !stop_split;
> +	     split_order >= new_order;
>  	     split_order--) {
> -		struct folio *end_folio = folio_next(folio);
> -		int old_order = folio_order(folio);
> -		struct folio *new_folio;
> +		int nr_new_folios = 1UL << (old_order - split_order);
>
>  		/* order-1 anonymous folio is not supported */
>  		if (is_anon && split_order == 1)
>  			continue;
> -		if (uniform_split && split_order != new_order)
> -			continue;
>
>  		if (mapping) {
>  			/*
> @@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  			else {
>  				xas_set_order(xas, folio->index, split_order);
>  				xas_try_split(xas, folio, old_order);
> -				if (xas_error(xas)) {
> -					ret = xas_error(xas);
> -					stop_split = true;
> -				}
> +				if (xas_error(xas))
> +					return xas_error(xas);
>  			}
>  		}
>
> -		if (!stop_split) {
> -			folio_split_memcg_refs(folio, old_order, split_order);
> -			split_page_owner(&folio->page, old_order, split_order);
> -			pgalloc_tag_split(folio, old_order, split_order);
> +		folio_split_memcg_refs(folio, old_order, split_order);
> +		split_page_owner(&folio->page, old_order, split_order);
> +		pgalloc_tag_split(folio, old_order, split_order);
> +		__split_folio_to_order(folio, old_order, split_order);
>
> -			__split_folio_to_order(folio, old_order, split_order);
> +		if (is_anon) {
> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>  		}
>
>  		/*
> -		 * Iterate through after-split folios and update folio stats.
> -		 * But in buddy allocator like split, the folio
> -		 * containing the specified page is skipped until its order
> -		 * is new_order, since the folio will be worked on in next
> -		 * iteration.
> +		 * For uniform split, we have finished the job.

Finsihed what job? This is unclear.

> +		 * For non-uniform split, we assign folio to the one the one

'To the one the one' you're duplicating that, and I have no idea what 'the one'
means?

> +		 * containing @split_at and assign @old_order to @split_order.

Now you're just describing code, and why are you making it kdoc-like in a
non-kdoc comment?

I mean you're now unconditionally assigning folio to page_folio(split_at) and
reassigning split-order to old_order so you really need to be clearer about what
you mean here, given there is no e.g.:

if (is uniform split)
	break;

Something simpler would probably work better here.

>  		 */
> -		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
> -			next = folio_next(new_folio);
> -			/*
> -			 * for buddy allocator like split, new_folio containing
> -			 * @split_at page could be split again, thus do not
> -			 * change stats yet. Wait until new_folio's order is
> -			 * @new_order or stop_split is set to true by the above
> -			 * xas_split() failure.
> -			 */
> -			if (new_folio == page_folio(split_at)) {
> -				folio = new_folio;
> -				if (split_order != new_order && !stop_split)
> -					continue;
> -			}
> -			if (is_anon)
> -				mod_mthp_stat(folio_order(new_folio),
> -					      MTHP_STAT_NR_ANON, 1);
> -		}
> +		folio = page_folio(split_at);
> +		old_order = split_order;
>  	}
>
> -	return ret;
> +	return 0;
>  }
>
>  bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
> --
> 2.34.1
>
>

