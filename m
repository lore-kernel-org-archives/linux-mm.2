Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27320C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F5A6B00E5; Wed, 21 Jan 2026 11:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798636B00E7; Wed, 21 Jan 2026 11:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610376B00E8; Wed, 21 Jan 2026 11:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490BF6B00E5
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15F63C2B49
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:52 +0000 (UTC)
X-FDA: 84356577984.15.747E3C3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9214C4000E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AabthXje;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s9GQnJeG;
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WCDxHSnVjY1D7rDROP4F9efGJ5bHZcczysaereUs0I=;
	b=D38hB4n5W/MVRlQyNB0blZ/RTSDZzOS66nEiKyZWmkLmeYajZlVV4hFSQudit49BQPx+Ut
	yYAx1U57HUzx74GFBEGuut+72Gf9C7HG4VWS6Q+rPqVeGjDaNbpR7w2TopOP5DF78iE/nZ
	WOdlxvAyx4xdfcqKm8m+CttmGsvS8QM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AabthXje;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s9GQnJeG;
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014668; a=rsa-sha256;
	cv=pass;
	b=GFg4u3W+Lh0K0j/jvV9Afnme8G9CzDtqbflrIxoirtr3445NoVyuFhZgm1AMtDjdbHTpBC
	pEkPGpX3EgaPzhKFuHlu9UPoPuZgZ5ynuOyLFmhRrKEJsrwM7jB2+mb1V7xSDX53gYaEVq
	HRuEFzgzbZEIAyU61gkEP9hJyYWeILU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LEIFjE3429885;
	Wed, 21 Jan 2026 16:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/WCDxHSnVjY1D7rDROP4F9efGJ5bHZcczysaereUs0I=; b=
	AabthXjeermcDe1dPbYyBFZoEFrKKWSIk8Gmr6wM+RiOx+Z1PGEBk9g2/YCMwPq1
	HP21OACraExwTixrM1eq+JIb2QhP9vEmmnzs3kvUndJ6z+VWw0MxGLUT8Bc9eb7m
	P1mAmKECrp8Y12OKHe/tokn0iD1gfi68n28OhNlHLzK0VRuzurOMHu+7vyRWstce
	yq560zg/BOgiUrcZRJSwVwo9/cRmnXkoyzMQ93XQgV+LXXCIpYZUI1WA+OFeMlmH
	lJeCvnnuEZXCy8WdIZw6FSYoTgc4PqELJwf32Yrq2TIwwvrDKxs3QpzfLe89fvt5
	rcWoPQvrfREk/AD3z0I5gw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5p62p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFnnrh022456;
	Wed, 21 Jan 2026 16:57:38 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfa0u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WKPN8jzgesl/lrNqVl7lQqilCw1GN58YoIC/H7HyQUrkxUx0Pk+jag6SnIkF9AvKiZw2H0EKgCqeoIakBFVsGOigfVKdp8iNYcYyfpp4xH9sXpXnyA12dR8NgYUXg5zfhYS95AvMk2E0Z17aG91vnEMtRFlMhNUkhO7OvVK+3clWc1FlJBlWusKR3oPes8bEXWzwcUIm/rrMUq/E3D/U6O+2hbW4r4eiwVOst0Woe9n8W6dWHXjaVkaMqW2n0Hba5OzyNrKT+8Eb1DUSRcDEBX/kfruLDGnIOH3M9hMi1kHLMBP23gphmPGyT3+Lw2mSgs2gO6DI48maMcxAVEyyiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WCDxHSnVjY1D7rDROP4F9efGJ5bHZcczysaereUs0I=;
 b=Evw/QoybfgdghfNaJPm3jXBHLMdyzjWxPLlPI9DWRWogZ/TYXpfDd7AG6v2n6NMPwRP9eO2cBRBiVpsYO4sdf8/gPQqwgsPZ5JtkHCT0Rrv1V0NHZVLeMrEdBlMahNevjm9fYO8dZ7fcxJrYHwlvIrdQG+m/LPw8H/vxFYCv5DEPh2qzrvK+BbuDPN92A73QQbVIDdfRmReBh8C/DPqedBc/+E8ngkzTq5P4fepREUNU5zBp1Nzwz5N5NFe5Yv828TffSDKqGAcAZX0QfmEmdZYPRoE1rkJqPa8IqvgvLeYWCSwjkfHWJ8UJyuo7uKrjjJAGDCkqrcaJHZgtJiOT3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WCDxHSnVjY1D7rDROP4F9efGJ5bHZcczysaereUs0I=;
 b=s9GQnJeG9Rb6TGX8kK3K8yNNnGm/wfGO6VIEOCkOEEvP2AvMBgx9BCYRNv2Uyc4bUYeoETn74junZ45OLi1F20tPd7Ye7f3dq/B13TTesH0tDOBp1cz2pHM2QEHKhujxwaHdLENJ8kG3LeMNFoxKByVXkW15eIp/CVe1G97s+ws=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:32 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:32 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 22/29] maple_tree: Use maple copy node for mas_wr_rebalance() operation
Date: Wed, 21 Jan 2026 11:45:19 -0500
Message-ID: <20260121164526.2093265-23-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0057.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b2afeaf-d418-4565-4e2b-08de590e2b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uMqHiebO2ShWggyEpUCmzuD2fy9nHw7hVy+lbOOqLKtOfgif1ZE45gLzJ8pM?=
 =?us-ascii?Q?W6xxHUqPzrRE2xhZ6c7W8yLgGLsleB3FnVFLX8E1QJZ5UTFhVedNMQLUhlPo?=
 =?us-ascii?Q?Nhyq5K7+xU+32/uaJLpyp7wEAYXU3ziRyuERMVDrAU2Tm/NMGFzDyv/Dh/pK?=
 =?us-ascii?Q?Io+56DTds/nf2m3RyV0DCzKX7grRTklOzDKqXfs75KwPc3UuOlouL9/YQR/R?=
 =?us-ascii?Q?fHSQStQ99z3G0fX3EObFW4Pw3hbRv8KpZEMNqhgRGLHA8AqTgXqI2KLUFUBB?=
 =?us-ascii?Q?uHkSf2Cby/rKzyVFxLqyeNPLbNcGFETMwJ7DWpx9OFAvlGU/BRr8tWORhXzn?=
 =?us-ascii?Q?WediNeUnAVOHs0urkFDAyjHxwIa4qpFmIxypQr3g1nLa7J2YMLQDmFn1z6B7?=
 =?us-ascii?Q?9hO6fq47uYrhZHPwiguC/HZOSJwEfcU1hu7N9Dy8T7yVvJ88PXDnVrWgpmSw?=
 =?us-ascii?Q?d5DIPYSJQFPM5dZkeLwhZxnWhROFftL0umtGxmU/GI6M40OiDL4QIo+56HVg?=
 =?us-ascii?Q?eGU1Kvp0po9tPRJL8LOShRimO2gsKs8vSjmZpqCSBQveIpAwQ6kHapzn/Mbj?=
 =?us-ascii?Q?jWpVHdqVy+pk37WdlglU2L91HzHlH+XrqNOaCOZ+K7DPU3w4zEeKxZBc2Min?=
 =?us-ascii?Q?96CJP6UqO38iY14qqD5ZkFuyeCIFJ9mbJxJ6sDqUAwcwIDDO03hAhhj+YDUt?=
 =?us-ascii?Q?P9CWR4NvdFYePe689kjLaRXYVgykXwbXfARlLNOBc6A0XxUPdO/ekrPcbVjn?=
 =?us-ascii?Q?JNJmxWZXvsjkEwdhYyZv52sBTRNMz8Vo6cUOrsHQ6a8ww3inWzNmOogxm98I?=
 =?us-ascii?Q?liMfwfL2Vj/gEmIZYMW2Y/+/PqfseZSloPYoPEYni6ebbvcL3oaaFFeXuCGn?=
 =?us-ascii?Q?BOJxMUq+wKn9cWIKVAHkh8Tf8u4NcXhUSGspmJ093C9rPCbFH/HD3BDdgYN6?=
 =?us-ascii?Q?XhmQcgC8Z5ppuB+EOuRhW/877vlOarECXDXAQFYMmeQmdDmie+klgJNgDk5t?=
 =?us-ascii?Q?6e51beIDGy5BaA930f8FulXKA0B+VYNSQJRfljnG34WPsaOX+dY/3Bis7RJO?=
 =?us-ascii?Q?bkkQsOsiY/FgydwH/m6gb6TIukmnRroR1//UeDkXSQMM+/0z44yBkag54CqK?=
 =?us-ascii?Q?OkQGryDXIfCzzbmg76vynTM+7gXRzsORdxY7GHUmv+J4NsLG5IHOkAOygBAL?=
 =?us-ascii?Q?4OuHArrkTKchu7KeFMj6tb7l1OtzK/ipgvKU206cdIPBkeBA4EMtiaZHqPax?=
 =?us-ascii?Q?vPW8cpW7rIiflN1QDluN+KnwOXJbW5cALaGJBrs+/aMoSp3CPR/EYsZVH0y9?=
 =?us-ascii?Q?o0Y53db72vExpMhDZAQ8ENiJRUploV4XAQyL+bxmY0xQ4cdZVTGKS+rKEsFL?=
 =?us-ascii?Q?Rpm2OXQlANuJyMF0c2LIo3drDHZTV/IX6tugubXbHE0JyqigB4+MRErc9oTd?=
 =?us-ascii?Q?knXTZ+Uc4s/KHC+gukRO/LBVWgyKMnU7hk1Ns70WjrNBcOKAviDEHeOOw3Rl?=
 =?us-ascii?Q?WdiS+5on4SQDR7TPjePP6j8TfNaW+OSVm85ZiSy+k1akexcoUIL4TPMWj3jL?=
 =?us-ascii?Q?uSI2JhFHa2Z7K32UegA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K//kvOMWOd+lEjJvIlFm+OBNKbzSpfeOXMDIEMiWhlSfL84BgQSAPu9n3knB?=
 =?us-ascii?Q?DYZ9o8uvFIlqI8uDdU2zrfFTZ0QfB43d7b/gVmNtBBv2A2JwgzWRKeCQe4ui?=
 =?us-ascii?Q?rtX73nCOcaZvP++4iAaRIiC3lf5h8s2WRAfEW6jPneDH3Avs/5bkMSxHOIh/?=
 =?us-ascii?Q?W10LrpvYdgp7lXcBz30K5eN7MpZV4zDdLhylHXVQ4DIdvk5XgCXR/j9oWvzq?=
 =?us-ascii?Q?YWjlxdkVtpR3iQTqpBZYvTum58MvY3UNp7lCBmQbtbeb6PHuCEMHyhqf9aP+?=
 =?us-ascii?Q?H9yWeRQHLg7ihGzJmqg4/ctFXuISOzyU6Wdg286vWFDV4nFQxloIf+xU1hSx?=
 =?us-ascii?Q?TpwGc3QrjsvCfqxIo930Nubn0HkC7+GVkiCuhJiJO+EQGypgiUdiahPxWEo7?=
 =?us-ascii?Q?sKNB+2e37cCnX/0fu3q5wBfc6sxgDKKJaIX/7kB8QUDrjKQCenVXD4+OEIjy?=
 =?us-ascii?Q?qSp+HbjdRq//55cSmgjrKcVcRF9TL2wJ0nmYprDaR5/Oh31KuOmA/iJlztAF?=
 =?us-ascii?Q?ttamH3yzNg+kPqukSHD0BsdiFuyl4oVHC8Yd3y8GN7qLJ1EkVGNdcl40rnUZ?=
 =?us-ascii?Q?iIdajTjSBPJIJKOMvtafYwpdsci3/BGvCF0LXhfdrtLK68yPSup8jxlkWtLp?=
 =?us-ascii?Q?l/gsYwHoKHfeQuyoBMIeZqihtE4wKJ1X6EHckSxRALO9qCLXyAdR42jw60tQ?=
 =?us-ascii?Q?93ZB/SIkYA/EbarYieniMyFyXXftxeVB/ALHyqaQaH+5Et2pxpxkGo/aov2s?=
 =?us-ascii?Q?Orz108GEkI3EGEPMdBGEsRrPwxRtyQtJdmBXTxNdUoa6hp3anDBsCOLWFjMr?=
 =?us-ascii?Q?ihsFX023x1oETzrBjID7d2o6AhziBuZVsP9zfyQlSKx1xoNSzbPmBEp+6X5Y?=
 =?us-ascii?Q?8wFlyDKWHYXdAqFe9yyDyjaGTA3k9c47mkCze/3iMWb96h++1rCooTbNJ84l?=
 =?us-ascii?Q?OzRmSNeWnxlZb/dUfOjVbT57aM1G38BregxcwIeFdcsg5kKRLRBmFfk03ImV?=
 =?us-ascii?Q?P94lKJW0x8OGfdaI5iQ7Uzv3qDbvsE2MIRaQ/Vl0eTYqYNZAwddjQpJCzu+Y?=
 =?us-ascii?Q?uFwq6H4KA/NVICaTRx2dqZXxDPFKpqTiomckjLMXWhHa1zFY0Mq2SyI/NgZj?=
 =?us-ascii?Q?U1uSxLXhtSJ1fCi+BDxW4tTf1LfD2ebEetHKjU8RuKPbzaep2oC5NHbHQ5VS?=
 =?us-ascii?Q?KjOJGWy/d5Z5oFjpRVmLKGAN/dMG8jEfHHbk2z8MSj5R4lELE5sOqR4V8R1J?=
 =?us-ascii?Q?Zfx59JpPujAypuauG8MHbcLexUaZu83cLzaROkSgcK/FUFVagUg2qm1iNcGP?=
 =?us-ascii?Q?lufSi4Ck3LaVe+XEUPDexDLjIQdu4tGt0mxWHEZCU8JnJ9SBab9qixr0LGI/?=
 =?us-ascii?Q?Nj/IBl/mDADFq/UhJcdl5CH9wrRUbpuHyIFqWyXDBXGaG37KPgHcoatlU+wb?=
 =?us-ascii?Q?dyH6i5bn7k8kwA0eEpX99sG7Rg5w8YAtwISGNujQ9bpy2qWaE9BJgZQqG+0+?=
 =?us-ascii?Q?D1XhLU/jlAoHm1XEmavglWSN1U3i92/33vRS8KMPRW5SAZx7W64v1aWnbUAZ?=
 =?us-ascii?Q?6dIN0p8vmeVgAj9o4moafmBXvm829ksD/OuHTwNiK0v9Np1PUENAgDWmKIrO?=
 =?us-ascii?Q?oNL7PLZKS/oMV/JZllqGGJA3Jmb2+7RtDRhwIOq3yc0PmgGf4Qa/UUUnPQzD?=
 =?us-ascii?Q?LL27zSV7qFqVtRdLiQdC/M6Zcn1lt+GsaEALNgv3k8VPC6HJDfOCYhz7+NSM?=
 =?us-ascii?Q?uKxkPEdZ0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fAgxgc7gS6ZLgCQd5ZoBSFaHmOjfa363JyKOeZabRvSt4mto1gPa3qnICH8ump4OAk3qIKKa7C5AApWfdTdR8w7KJQMGpWA/UoAJn2WoyAstrMcDrKfAyjGZda37ILsy8yR7PR3B/9gHYIFnskCivFZcSJzL6Tx/Wni0hvhVypdC87L9hwaVuYgkQvm/bUBoBw/+rnITHWaHsNOwy/oUe9sF5FdFzvxcnTRvoh9wKOqhdz97Mg1tUbq39NBXY+jB+YRfDeMHzXYd/iZtakreVxHWgIDgx+7a2p3PMfTtB+b+A3coh3ultLiWAmfDONaj6YoZhT+z0sGXgRqDx7iINCQ+/STSLNLc40vy2OPL6jkzjYV+u90Cow9568Bnp0ORLilU3MH4+ZLC9ne+30/RzwC6aSEwAATPa58NV46WWq4NkyimzxVTbRezlPkLkBBt+6XHAUpHMYELDkguD774CHinKbPUr8lYDRIxnyKLeu/C0E3Vpfi0qtVbM22MuGwZWNe9MbZ0UmfTrlTHQ0O2TBe3OGc5MvZekIufIdAEd5HD+VxFkMh58zUPZZk4HuFh1mc/1yfUJVzTeuIbuAafZoFrujYtbcuIPqso8dIXV9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2afeaf-d418-4565-4e2b-08de590e2b1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:32.2179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8TE9LaUGXJgK2NLH/6mDdbw5spQSpwjQDYGg9g+LgwbUsXdOqkC6SeZmrFtHaAOMXMIbZJp5axg//JoVJoXYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX4aX4zbQ6a8gy
 Tmrm6rVQuLrLVOoada1SJxHEccXvV+tMPDH1OdzaSsoUbEwyqu3UyTJ6RFFwUWL5YrpoX7Fv+49
 +mYgioyCGHrmWVnNDNo4KYs12RUMOWMHsUMrZmT92PVHcZkK6sJWNF69BlHdeDBHFHIRhFkOxkr
 j50YXnABbFj2lRdja+PmoSitLlQbgEtpcALXaZffjSL0q9Tlmmy/mZYgv/IVDNFSrFmjP62op7J
 BUcsanyDZROOZYXoYxs0mSFY/zcc68lc6oQybLX2tKmJsBNVAvvSiHMcdWsbej6AIfHqSs1WqAL
 ptO8JWBpB8IDRDb64n8MTL4UGRVeKKMa1cnzqRAnVqOUudoZM0qcSEmVVSvk70MxDjmUC1XWjN4
 T9X7a7dqZ8+nsF03G5Rd5/o9eM5SOKZQdCtoPCpEE0W310BGyNHEmBPcELBgsTVaiI2FTmlwH65
 i10oXafortfe7Budw43snkWSFMJvE5Jsdqx3peQs=
X-Proofpoint-GUID: ZVG6XauaZnPldXMRSSc0kFJoFRF996GN
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69710583 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Zz53rQgBdMDpxz0lw5UA:9 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: ZVG6XauaZnPldXMRSSc0kFJoFRF996GN
X-Stat-Signature: zfmqgcprnq7ppfxu74aj7dbfqr4gu6dg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9214C4000E
X-HE-Tag: 1769014668-293019
X-HE-Meta: U2FsdGVkX19CDgrOSHNCgREGkoQVijFJDDO/N0rBONYvLOpbqmTS+FgJdApJKBWYbjqGqje7BYjSFCQowAOpXZA3PYtFAhNCnR8DuvQKlsewu/Z0+0+OF61x5axqaZlSdVqBrFPoV6fJatfW3VmVLd2BjJgLMFpf+oJKNhGiyNfcixSLAllrdTk0Z6XkK0GigLvuYdz8ESdmEyNgMt3UB2T4KG58gmfXg/bpTMbHjaGLIskk8YJFfopXZb3RehgpUL885GpsfOIWSoPf+NKlsyb5tRPSTvPtdAgrkljVmGigYIDpQA4i3zmYAaXSr7oCaHnC4+ZI5CCOvBj2h70NSGnC6k87dpcNnygmNWa39da4TBGqDJnvXEfpImuiHvh+7paD8EWJENqFIRNT+7G0DMCuv7wrT/d0hhK1cbKuqdbgcVdxYPgYnExOFfTxDpdtMyYmLEtKmFV9VFMb9d92bzWWjGJVFgFDSQjTWNcOKj7631fEi03y1AGAjl7Z4Lm3YgLVxWNsGNG/+bwZ0egqqBmFNVyCn6X6fgEqkAQEIjjwKx25qQZeUoe/Ds5o8mREkjI1jakmUZ1doMfhEbTBH4vjwPoZo1BLmN3OgpzGUynZ/wU8kKLLQcQmlr/B37so3uAFM8aRC93Tuck44ln8ryWChGea3YahuhvJxij2GeeTYZv+wtHBwNrHQKHLCY3kmtk8GQTtKQo4qxKw5EKzWTeVkK1LuEodnQuKFoenKUue3wb1QGrfPwa14uv1OlAPtN953o27EroOzFD9zCOl38nhanJXvzozl6jKxTiERJFI1yFIY4/Ni/9NHLEtAwRX/1FQnxfOuQQTS9prtEFQ8VN2ILpDJ794ZXB/FwG02tLsL/i6E6mdFBGmWoxiijtgZCCHIJFS5NhHs+T/7x5kJVlWRelu6JJhJtXxC8wt0W+LAtXOni6sRHIagOcbCmKhK2YJfTyUo6XzXQ2RHK6
 4lXoF1RS
 0W3or4nQU4QcLPP2C8MTSp59BnmQXfIsEZa1rIromOhYZZogPfF+TlrZ3vSWM7bPKidtu3PhW/xmWzke5JUAOe1MFC2/1H11PXsrMmjqC7pe1z6GoFXIBE+d7iECkk+sqYJgOlwPY5KrRMO8AG49XZ23Eu8zLo6cpnpU+0HiAlemcN9RHvLdXJq3b24w3TwTdrpyYPE5ulbQrnvM0e9zHjBeUdQawesVWUlvmNwDzFbR4IYrXM8hAwZ8/sKqqhTXkbMrlDKDtVG0gvTlpkXcZU5vE9iNFoQdx3cLpFV8PPtmf7OlpW/VTwRlB/SKNbhRXxVmFERFm8a8jcH972bUerMUpg2q7lWdPdnmbZ0MMo05T+APmknPWgUwi/yyiegSbRVan5SL1698US7ygbumpohJMt+wXwzWGJbcj0OPzFHPBSm2CTjog+Yo58MOc5nRgIT+W8ERCA2hDTa8UoY6ulwB1NT9WABwu/l6ZCMVGgvPCnJeirqETsOIsyqP3nWhqYE/CnnwG79tC12F2xAudJ0T/aQH5SeoNl1nKGHIz8YlZfbfaOvPfHlQEluen6d320vKI/Sc1FCGfhcOSdno7gWVZ3jdS45QG5vDZ6+toXxk5aO627XBhgJy8/1LHyKOPM7GYxBrKE3fsap+4UIXB8iZyM7LQ52mI462H8WLFdIGQ308aMtEbtqfHrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the maple big node for rebalance operations by changing to
more align with spanning store.  The rebalance operation needs its own
data calculation in rebalance_data().

In the event of too much data, the rebalance tries to push the data
using push_data_sib().  If there is insufficient data, the rebalance
operation will rebalance against a sibling (found with rebalance_sib()).

The rebalance starts at the leaf and works its way upward in the tree
using rebalance_ascend().  Most of the code is shared with spanning
store such as the copy node having a new root, but is fundamentally
different in that the data must come from a sibling.

A parent maple state is used to track the parent location to avoid
multiple mas_ascend() calls.  The maple state tree location is copied
from the parent to the mas (child) in the ascend step.  Ascending itself
is done in the main loop.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 212 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 205 insertions(+), 7 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 326d6026afee3..9b1686fbd2d8e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2298,6 +2298,19 @@ static inline void mte_mid_split_check(struct maple_enode **l,
 	*split = mid_split;
 }
 
+static inline void rebalance_sib(struct ma_state *parent, struct ma_state *sib)
+{
+	*sib = *parent;
+	/* Prioritize move right to pull data left */
+	if (sib->offset < sib->end)
+		sib->offset++;
+	else
+		sib->offset--;
+
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
+}
+
 static inline
 void spanning_sib(struct ma_wr_state *l_wr_mas,
 		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
@@ -2848,6 +2861,111 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
+static bool data_fits(struct ma_state *sib, struct ma_state *mas,
+		struct maple_copy *cp)
+{
+	unsigned char new_data;
+	enum maple_type type;
+	unsigned char space;
+	unsigned char end;
+
+	type = mte_node_type(mas->node);
+	space = 2 * mt_slots[type];
+	end = sib->end;
+
+	new_data = end + 1 + cp->data;
+	if (new_data > space)
+		return false;
+
+	/*
+	 * This is off by one by design.  The extra space is left to reduce
+	 * jitter in operations that add then remove two entries.
+	 *
+	 * end is an index while new space and data are both sizes.  Adding one
+	 * to end to convert the index to a size means that the below
+	 * calculation should be <=, but we want to keep an extra space in nodes
+	 * to reduce jitter.
+	 *
+	 * Note that it is still possible to get a full node on the left by the
+	 * NULL landing exactly on the split.  The NULL ending of a node happens
+	 * in the dst_setup() function, where we will either increase the split
+	 * by one or decrease it by one, if possible.  In the case of split
+	 * (this case), it is always possible to shift the spilt by one - again
+	 * because there is at least one slot free by the below checking.
+	 */
+	if (new_data < space)
+		return true;
+
+	return false;
+}
+
+static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
+		struct ma_state *sib, struct ma_state *parent)
+{
+
+	if (mte_is_root(mas->node))
+		goto no_push;
+
+
+	*sib = *parent;
+	if (sib->offset) {
+		sib->offset--;
+		mas_descend(sib);
+		sib->end = mas_data_end(sib);
+		if (data_fits(sib, mas, cp))	/* Push left */
+			return;
+
+		*sib = *parent;
+	}
+
+	if (sib->offset >= sib->end)
+		goto no_push;
+
+	sib->offset++;
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
+	if (data_fits(sib, mas, cp))		/* Push right*/
+		return;
+
+no_push:
+	sib->end = 0;
+}
+
+/*
+ * rebalance_data() - Calculate the @cp data, populate @sib if insufficient or
+ * if the data can be pushed into a sibling.
+ * @cp: The maple copy node
+ * @wr_mas: The left write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ *
+ */
+static inline void rebalance_data(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	cp_data_calc(cp, wr_mas, wr_mas);
+	sib->end = 0;
+	if (cp->data >= mt_slots[wr_mas->type]) {
+		push_data_sib(cp, wr_mas->mas, sib, parent);
+		if (sib->end)
+			goto use_sib;
+	} else if (cp->data <= mt_min_slots[wr_mas->type]) {
+		if ((wr_mas->mas->min != 0) ||
+		    (wr_mas->mas->max != ULONG_MAX)) {
+			rebalance_sib(parent, sib);
+			goto use_sib;
+		}
+	}
+
+	return;
+
+use_sib:
+		cp->data += sib->end + 1;
+}
+
 /*
  * spanning_data() - Calculate the @cp data and populate @sib if insufficient
  * @cp: The maple copy node
@@ -3405,6 +3523,55 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
+/*
+ * rebalance_ascend() - Ascend the tree and set up for the next loop - if
+ * necessary
+ *
+ * Return: True if there another rebalancing operation on the next level is
+ * needed, false otherwise.
+ */
+static inline bool rebalance_ascend(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state *mas;
+	unsigned long min, max;
+
+	mas = wr_mas->mas;
+	if (!sib->end) {
+		min = mas->min;
+		max = mas->max;
+	} else if (sib->min > mas->max) { /* Move right succeeded */
+		min = mas->min;
+		max = sib->max;
+		wr_mas->offset_end = parent->offset + 1;
+	} else {
+		min = sib->min;
+		max = mas->max;
+		wr_mas->offset_end = parent->offset;
+		parent->offset--;
+	}
+
+	cp_dst_to_slots(cp, min, max, mas);
+	if (cp_is_new_root(cp, mas))
+		return false;
+
+	if (cp->d_count == 1 && !sib->end) {
+		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+		return false;
+	}
+
+	cp->height++;
+	mas->node = parent->node;
+	mas->offset = parent->offset;
+	mas->min = parent->min;
+	mas->max = parent->max;
+	mas->end = parent->end;
+	mas->depth = parent->depth;
+	wr_mas_setup(wr_mas, mas);
+	return true;
+}
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4372,16 +4539,47 @@ static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
  * mas_wr_rebalance() - Insufficient data in one node needs to either get data
  * from a sibling or absorb a sibling all together.
  * @wr_mas: The write maple state
+ *
+ * Rebalance is different than a spanning store in that the write state is
+ * already at the leaf node that's being altered.
  */
-static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_big_node b_node;
+	struct maple_enode *old_enode;
+	struct ma_state parent;
+	struct ma_state *mas;
+	struct maple_copy cp;
+	struct ma_state sib;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
-	return mas_rebalance(wr_mas->mas, &b_node);
+	/*
+	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
+	 * against the node to the right if it exists, otherwise the node to the
+	 * left of this node is rebalanced against this node.  If rebalancing
+	 * causes just one node to be produced instead of two, then the parent
+	 * is also examined and rebalanced if it is insufficient.  Every level
+	 * tries to combine the data in the same way.  If one node contains the
+	 * entire range of the tree, then that node is used as a new root node.
+	 */
+
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	parent = *mas;
+	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
+	do {
+		if (!mte_is_root(parent.node)) {
+			mas_ascend(&parent);
+			parent.end = mas_data_end(&parent);
+		}
+		rebalance_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
-- 
2.47.3


