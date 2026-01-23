Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FECD6CFA7
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7F76B04BE; Fri, 23 Jan 2026 07:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B076B04C0; Fri, 23 Jan 2026 07:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858836B04C1; Fri, 23 Jan 2026 07:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 439ED6B04BE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:36:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9E2316019C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:36:46 +0000 (UTC)
X-FDA: 84363177612.26.35D6039
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F545180009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:36:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AXX84X0b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L7B593u5;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769171803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KW6jXNBkZvLUvAisely0rbp1de4BcdMp2dCtjPs+/Ms=;
	b=qEkfyZ9JZGjDrWxtwtdtbnHqkpii1z2dXjl/h1YdSoKFJFY64nvNXA4ySKI9A3smO/rRDQ
	p4wxe5Zn7KWRg1Kx7spgCpaN0erHRJKE3klxzL0KLvfshqNefdEqQNgYXYjJDezufjDGUP
	jOz8G3AEhpBHiQHMYXFk/kdp5IF0EQM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AXX84X0b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L7B593u5;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769171803; a=rsa-sha256;
	cv=pass;
	b=5jMfEyVcpf7RsUfCa21XjEgph62arL39DX2IWxDCqGLGR4Qhswc3ovVzgwkKP5EGVEQt6F
	KsueQD4ISu3vjmeRQIJn2Wag1dAnSTAL4OgBO/tTXaHv3l1CYIM+6070DliikBJxsVEZPA
	ke676DptuB1BqEtpzzFurcquWvbwjD0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EDom2973115;
	Fri, 23 Jan 2026 12:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KW6jXNBkZvLUvAisel
	y0rbp1de4BcdMp2dCtjPs+/Ms=; b=AXX84X0blI8mMCU4FbUJJXQtpD6AMfeylx
	fJ6CioDIIgOw4FMx5aQTpBDpGB4zvfYrng9s9m11VDFD7jJSHC6K1a2rnl1/3RvK
	YMywcgsO+w1GsPUZZeW4H9cXB+pqnshqlODHOGzqWkd1a79UBhMdSZPbQB1l2NYE
	ZYycmmC1K/nlBUpoy4iy0xovWhXWG+tzf1hFl4rEq/ooS6r0PNYdkAcJdwpMHp68
	DPQIfdaH4W4jAM+BGAESOTKJijvn1oJq6D4H/VE7Z3yRLEU/dGpY2CW7b3eVuP2u
	zg/VsjGWKEKXZYRRoE6TLbhNrrP7KZEygLTRzfLlPyMJM+KQW9ug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcxwd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:36:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NA2Lgm022548;
	Fri, 23 Jan 2026 12:36:38 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vj2t8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:36:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpETu29AePOxReS59e17KgJX5KqEp4XUtVIsXY1zaRiwQGaPO8BZu0Dp7hwrw6vAqNDu3wNaNZz8dF0oNPBG0sPCDzMNgHMMeupirS0W+VLGZkuNMELADQpx9NZeiTNsKzuvoD1T9ngZguhfW/3NpyvloszA9cDVqprGTff4wOFhx3ZEEU+uO8E9C6CH1FB5AJuUpVFsgk3SwwbNXahGcKV0Qx9p/r9w2L1U5p5EwxieS8xNp9idiJsb6uXHyR+GD59g942itG7pu9slBHjVdn7fcLpJOpEfyolGjiLKDIjyr1p17Yu7y6tn6eqdp4EAyaBwfpLyQD9QozGVCWfVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KW6jXNBkZvLUvAisely0rbp1de4BcdMp2dCtjPs+/Ms=;
 b=yYFO31noyMNgkXe01HMdjHM+GJo35HScMOVOIfR4KxujXvdTq6JcDZdBf7o+LdgR3bxl6k8sVtmgc3yBMGS5NCZTcXCYdLtBuPzbsSsB+OC4WqmZ/0dz8brc86gKbxN9VtSDgIGniJhUXwUSyo5AiDNE7H+C2stb+gksFEseuE/+K4XiPo7N9b0ae3OwWVK//qYbRpDOZSy2YUvM9FhlohwblbfjzVYGSDgZF1SUtps4uTUT7U59TExAP7gBzlW6wCr0Z+4VwZDnmsD1oLV+BzWyxuJ3/wVUd9PVHicDZRnOV2rlfm0ctECzmynaWQWJkApjhurugTL9e9Nog3cVlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KW6jXNBkZvLUvAisely0rbp1de4BcdMp2dCtjPs+/Ms=;
 b=L7B593u58DlvGCfwK4Mh6BMkyklsA7/y00OESUJ1CvqCP3MKz2n0iqIhpqPAhx1WN6aRopaURwnCKshSJEbODzLRwI9E4x9z6+eDyKS5VAOQbUkHUJCtyZmBrYiG+EV/7F9nZpsiRJQN/BnALSeIQpI1YfY3qixCsEXXOo1sBX4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB4766.namprd10.prod.outlook.com (2603:10b6:a03:2ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Fri, 23 Jan
 2026 12:36:35 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 12:36:35 +0000
Date: Fri, 23 Jan 2026 12:36:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philip Li <philip.li@intel.com>, kernel test robot <lkp@intel.com>,
        oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 420/429] fs/romfs/mmap-nommu.c:66:42: sparse:
 sparse: dereference of noderef expression
Message-ID: <73c208af-2843-413c-8801-bb8f35dcfb34@lucifer.local>
References: <202601221505.RxftadLx-lkp@intel.com>
 <20260122132335.5f3160dd20dfdb68c57ede35@linux-foundation.org>
 <aXL27/BZ/xIwNfT3@rli9-mobl>
 <20260122214830.50c0bfbf2142a61d370be2e1@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122214830.50c0bfbf2142a61d370be2e1@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB4766:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d35a1e-d126-431a-e65a-08de5a7c0bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QcQlOyhhHSwNq79lFPP5j9/V4KqFE/jSKUXreYVlCI0kTGTEUY0bVAcLFFBC?=
 =?us-ascii?Q?QjOGerMKaqlG1DPz8zg9MKvUlnk/Zh9cyL9+01NCug6JNyD/1DpR+Z5x0jXd?=
 =?us-ascii?Q?bQZKyHT2YVDg3ZtnAr5anzk7JHlc0SMs70tghdGUYSYpG14kmY7yDz8bZ+eN?=
 =?us-ascii?Q?BEzFOTP2ZYnT98WHPVI/iXlQE/jkrs8n9SutxrnuHq2iaFhl9t5nUSG6MlHb?=
 =?us-ascii?Q?fUo3lVV1l4in/uBvwDiZ18PadfpMRHtf8Bkhgx+ksprIZ4rMCP5P2D4uZ26M?=
 =?us-ascii?Q?FU72kXRokqHu0XK1odW/Q3WRupHjyc7zG6ZsVVtKOut+ipHUwOWZ8eNehqYT?=
 =?us-ascii?Q?yw3x/4ObqzcR+o8q/CkeumaCFiMBozZKx7NY11RdenERmE+LK8v8gCehx2/U?=
 =?us-ascii?Q?Qj/gyWwz7fRdjNyQXs3Rbv3pDkzqw/r96Pa2wMMdtJjI670QsBR2cWYZ7chN?=
 =?us-ascii?Q?w3Jx6VRPj1crY/SrdXWsU3oV8ZC6J9PF/IwW4Cgd5H3+Cu9TAxi4js8Zl4kk?=
 =?us-ascii?Q?65n4qlsIpkb/5mUmlb6jbqLnrDI1khoiAwU0XLvlsCp8apXNQZoDOW7aaPq7?=
 =?us-ascii?Q?iD9O7SAiBSoN9A2LmXZAmxnqIAIErLP9FQbhc2QBkNhs3vXLlnmLKsW+kHp8?=
 =?us-ascii?Q?RS3Gph7OR1X0+vkesMFozuG9qubvH3p1Ter8J1kAO8u4LbCyUmyrGkisVJ5a?=
 =?us-ascii?Q?oTXTEyxe0cCtBzzuwHGYkXksn4CxfjiTxVG2Q7lsGyu7F25rDk4Pc5y1Uwqj?=
 =?us-ascii?Q?HJFeHCPkmbsWq87z40k3FT2Jb70Z7mIniHvFK9b92yDd9oOHm99qHgZVR0SP?=
 =?us-ascii?Q?DqHrzpOmJiE1Vkq2OFPr89g7FpR9ZAkmIMndGfP2qcKvYSA03jUrT/l7le0o?=
 =?us-ascii?Q?PPWam6wco2kWqnXq/i4KRmSLDY1GMyot5Qha2Tim+kI6lBiM+EYVHrj284Iv?=
 =?us-ascii?Q?aL2KBVs6Rn7mtnQDp+Zw+2ZN1c3Hq8+/I4UQImzigDRRhX8jzdGa4UnRYaQq?=
 =?us-ascii?Q?ybQtu34eEOMI50JJ7+aWU3MKwKfLAWakOU/bPg6KQgFkgPIngV929eC3MbP6?=
 =?us-ascii?Q?x7m6Eie1LUoJ0S8H9AyCoFUh0B44zSrn1z7PV1hdO8alqDdKTq7gCbRo0Kng?=
 =?us-ascii?Q?NUpAg3KOKqWfVA/8sYB3KrnwLAColXgQQO18fA+Nl0lE/Nn1PN2IYrSChvvj?=
 =?us-ascii?Q?Rm3QvRnp/HFBLtJKKKmTeKMr8En0V5StBYkcfo58Wa/FSCFfnTI8RKa16RN4?=
 =?us-ascii?Q?XYncO+xTCxjABVWQnHNvgIJwtO0F97qmt2reOGmdCYpO4f0BFLqE1p23RC4i?=
 =?us-ascii?Q?Vl9zlJT5BYa4z5GXktAKBtScsiVUkxdN4s3bsHBADmCNC32bIZ08R9cm/LAN?=
 =?us-ascii?Q?zpATRK0/JXG/zALJFA8kG0wdUGro1/mNXhVLbtGI+ugA3pZB+zdpDdj1IhfZ?=
 =?us-ascii?Q?GaUnHBfzzTYtBn1PXbPcb3S/9Li5GeISOW2Xn4DjfcQjCSpsbvDksWjqYv9s?=
 =?us-ascii?Q?rKhkOauyXGzIabiqXmabNlwGp+EGV61oV0/7vXtVaumg5JF2wMnladpO8p5u?=
 =?us-ascii?Q?3yyaziuLpCIf5wWbtqW9YsVEF2hHWI0fVEuElAvs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2yQii5Uy8+3g2W9miK2ERY9ERskQHdxL/nMZHocMOwGkZdQZ0ZVRiFShHGjL?=
 =?us-ascii?Q?UcfnLDub0N5hPfd8QSIebt9qiWDtF+wVSbmAocI5HP0hnzQBQAZqk0cs7DkK?=
 =?us-ascii?Q?V8vWc2Egj9t4keocKRzm74l6tNNiYXJfPhWpTe1YdWrDoXYEHEc6An3sxQ76?=
 =?us-ascii?Q?VxPgD/oIk/+5k06hbGSXRaM2KTjGJhgRADFXOVSoCca+FeEc47OO2+XoiOmD?=
 =?us-ascii?Q?J0wmm0eb1gsYDu31TZVzbg4gv2G3FIeA+s70a9NMwZyroWZ/ZVrMk7BIhgSx?=
 =?us-ascii?Q?OV7dlw5rHNoDgZFjEjMX/TKh56bTe14yl25BzWVHZhOgdhXdRKt0BKbTelaH?=
 =?us-ascii?Q?ce7nB6lAwVGQjR8T2N7jp5JNxUDnNLsVWigPjbryj6GKEa1bgL5SESX19QwI?=
 =?us-ascii?Q?a/AiSPZIMSKvyEclh08jEqqlm+SZ2vHdj3v4fP9QV4m2H4u2ZRFx/pEA6L7X?=
 =?us-ascii?Q?kAyazX2r3/AWqxgVuAkEEd5Ga/BEa+Vwpf/2g72/Safhg6mJv3waAAy/GTsX?=
 =?us-ascii?Q?A3QVCYLLfqSfZJuageND1s3ucpBgp8zJC6iRGT5tHv1wGOJScosXeU7oea+n?=
 =?us-ascii?Q?m4cOIiMHcVz/oJXMhd6nVVY5lXrq4kje4Fd93b+HekJ4Hb/LGOydewdUaysq?=
 =?us-ascii?Q?O380KvEiA4F36v6uszG4tymP0jnAGPydac+3vgJolWb/9yVCaYFUpQuzAEK8?=
 =?us-ascii?Q?M/vHBJ5DfhbLfkmFSZrmmOfr4muVMtHAGmAPk64EaJXbVc8wYipIchFOmkJ7?=
 =?us-ascii?Q?h6xl1erUMlRahw5wemBu87NiMl+3uXKqiccLt5RI6FpW9VqLlSOCH+naF0To?=
 =?us-ascii?Q?i38opameSnEWt41wcccZdcMgEjKHgObwLC9Mg4zmUnk43yXNbyBFCzKkiNyX?=
 =?us-ascii?Q?GBcUN9GH49auczt9FBIZUXgnIl60nkE6zqyQwJwXtJGZWGDeupamvzZooyzx?=
 =?us-ascii?Q?aXfuUqa5+4Qm9/rFXhKdx68W7EZJ2cYKb4hInUXbUnIcdhL21XRHHENula/s?=
 =?us-ascii?Q?zmCV3hr/MCR7th9cFcpi8edzcU5S9ySosEdUnwfl3Lh+lAE2AyeRn2qaxvSJ?=
 =?us-ascii?Q?PdJZSTpOfZpZRDcobmxardEAkoWXd+7pHFlqYZvYJiOIJlRJv4pGXrdQs+As?=
 =?us-ascii?Q?YJj3/VxMPFh8feq/olUzWuHNcshhLAKZO9+G08ZlOfe7vMxmXoDlEJ+U6vwU?=
 =?us-ascii?Q?5td9zTGUDASGXNrtwFk2pTXut/hO67xXbrWTOK2/RUDO0flYltJyOiD+hU6U?=
 =?us-ascii?Q?GC83MHCwIzA21BxhzFzQ2KoIh9cXGcT7KFXqYl1Y1Tl3EEgg0MNpojcF8aMu?=
 =?us-ascii?Q?URxhNGnyFwlJWqUDsihb3znjcmP60auL3DznO2Bre5pPHSb9VdydYYEHrFS8?=
 =?us-ascii?Q?6sxdk+kjtsaJrCmC4XkY3F9bcavEkrPNPBLUm/mHA+suen+aVLBPOwpJw9mz?=
 =?us-ascii?Q?hjbISwwUjYus98p6mbjD3EcuG155vBzYTTfaRFt67zAqmwdbB4/pTxXNdb+R?=
 =?us-ascii?Q?ojJeJGHrCOFuPegBFbWn8yR6i1YITkwxslT5goSu1qgbjv+L/1gNR09fDvtF?=
 =?us-ascii?Q?8ITfOH9dU8BgASBVKwvN2+/e+o6/QXTUwASgIPk8ok2ihuFTlyFUllNO5+vb?=
 =?us-ascii?Q?qXZFqnVfYwtBmiGqwnOSBQ2fRguCugiQ4joQi407WRt0L4diIzgDclqfeHqm?=
 =?us-ascii?Q?WJ9c1R9i2gkM0SJkc672Dou7AaP3QhCohA+tLmEkh6vhXi+zSLOExo9qrc0c?=
 =?us-ascii?Q?P1br1HiZ+6HwwXSVVXF9BKzjHMdscC4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n5C6593MMDn+hUNZczAxRFbbzjVQTUCmNaxCvw/VoWe5FcVKk1tSUYw+dPc1pm6vm5ly4kWo0lZ+9Veit0q9fUN/veDHfTLM642zTc2VHVNydp3QdZPi11d0ggOVYFKLiqsqoQew5nySZzqByYaTY2vo3PCwuau0osla5C4lbtS7D4jHo4gPXQKbktLfE2D7UZG84RJhO6yJk5yF33PFq5XWTSCYcmy4FucNEKC/qU0/DYyW1fv1KwPLHeXB1kUKY5Z9ZhyqOrFLPu69U3puJQf01861/CVi0U40oV8vP7eJwPJpW38e+/q7YNNEtTO/RSKrLKzjd/PNGqtzq8TD8uQvnsl5jf9V+GGZ/0mMuMDsWqwjDNMti4uInZAIb3I6cGeRqmyUcuqsxEoQ7AFF7fw/l1S29LnBgGb+buPxiFeIXkONB7sdB/JrXjQ2drLGAHZcwvws7L0zFTcqDI5v2lZuOtrWh6jxu1E/jXPY6bxdt5PELcv3PyFmE4n7MTGYisULKLJOcpB+Hw0QaYm/Ea62brNlVc0Icp05vtmO2SlG3Dv5kgSAf/35tXIUTkenzWiMZhh4ROskPc7T+lzm6SuIPOj7/wq8KgkPJfZ0moY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d35a1e-d126-431a-e65a-08de5a7c0bc9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 12:36:35.4468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXTuq8bkxEYgEooLfWfUixfXjmCrxHF43XlBelwe7puLUaX8sXnO3QIbzWQ0XznYIeFaZ3fYoiUoQzHeJaTHpEjoG23nbR4vtFg74Lu0BUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4766
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230103
X-Proofpoint-ORIG-GUID: O5CuxzGuT5sALCSo3PIvYgleUJjnNpPC
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69736b56 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=JI-sKcTr1yi_tn1bgV8A:9
 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEwMyBTYWx0ZWRfXyP3yN+gS2ol4
 92glp81Zp5JHYqpn5Bqk0VgNBslKgLI7l4DMgiMSqgakRiNjQLVIShjYRcwBLZESxTQ2w6ZiGh4
 FiTS4bFfHzDgiLUJbgXgO1Cda+dWwU8fR9sjZDNvgPTf1DSOZeBwbCcKQDncJfvWV2QHU2B8TKj
 LpFEknqDrQ1KSPd3HoETBlKiP3+HjaYQDKbB4wM8fRZMMymal8EcrOMzWpEkwlVzPMZEN0z+YPM
 313iUIrbFdWVKQWv4pEZiiFdXHDpiTHtdHel5LRlHmPQWydS1eOpxcaQ2/ni2C1aSaBlWzDv6Nv
 09zpotf54hz/P9VfpmqphZLiOCVQXGWtqdacyEU6+0vGR/rLt7eEYul9VaKyZTgIWAxCpmEHBfr
 XgQRYTCn76Pc6k/KOOJBlZKcDC+scZlBdEbyGMU6v6rTg0sqly3FsAO0Q+yGebkV+dRGRGmKs3t
 DQS4jueBSl1ZuF6GWIGDsWowbRLyjbk+BtmRX9n8=
X-Proofpoint-GUID: O5CuxzGuT5sALCSo3PIvYgleUJjnNpPC
X-Stat-Signature: wkr1mm8t7kms7hox8xhagdnptnb1f8ra
X-Rspamd-Queue-Id: 7F545180009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769171803-113415
X-HE-Meta: U2FsdGVkX1/XhVghoLhNSSQFlsi40S6G6gNhSmKx4t/n2DVZjgKtVkJHwnAEF18OAIl2bmNsnO5Y4Nc1GMvNmGWU9XtJgcO0NFFcoMhs7Y4kgVUs5qNLhl7iM11XAMuubm2DQ93Pk6SzWH4efGSH5n4i8wv+VzWmA9qlCqRZ/n/C1lJNf2E6raYK+BA1k4dXrvF0MI/Z45htf1Xwf9wTpVfdXEENFEWGmwE7grWgMUck0C+VEdYaj8o3fBnO2T5JJkozALw72JojL4oO6OrVJuHElPKKQ2Wtfx7eDepU+pj2eXKZ0iMMnoAe0vBK4pxaqMDElgHYvO+Aik0j2yqirhT4ONP+jB75RcFml2ARPuc6zUwbXTviMVjHA2DVd+pUAKnCOJLxHlxsFRSXb5EqcKUSTw0JWWtRodZiRN6foBY9hSeW/UoMM5Ti25ZEUX0q8LoKx3z9Nwg7qsvpdoMLiahHNHqxWaBcxYaTMqGK03rcwcAO9DnuqG8YGGtbZeMbp80mmjC9rPqh3jtn7D6HB4NXU8Mmnpi15emmR1E1mGkf9tY3WWeRUL5jnGPGl/lWiu4jad22HNRKyDPypEFF5L0yfov6XikYC2H1IzvvdirOLK3UWzuAegDblA0lyabqBeBdWe4gyUBXGLrFEwk4MYW7qumARLttPrGRziWXASsxDD/BacjFd+nAkFEf4T8PIhjOPJTesh8gKdGPURnU8Cvme/7OKN90CbtGPyfu81UBnjZn0tYdDFadchnmF/VJ73gAnTOVRNvC9jwJ6IY0mKmfexNJMr+w7ge5RXHB9xOsR+oCTp66Milrc/Ey5UXzviCQZOFfW0iap7mraZ7qpP6Basr6PhNsYx+6n6xoI42q/lZp9yLMzYtK0ZcccQ105jzEHfunICWOFYW73o/1rMswMihHJAkxczqt/KoHEMkiHBdBAi9PNqMzCBzsULgDQUhfoopCZhD/3T65uIp
 NNrqKiuJ
 szfWSylwp7a02nj6KF5NL50nZ51MHjDPIlMYUG0XHj0P2aUY+V5iN0d9c0WkrL1dmjvUc8/1RXJZ0ktVL4D5gUNbkEZJCJMWH9T046Id827D2XDY9aV2XDIZqGAaBRxobGRnQYCqUbaCNxOFI1rncK10BXqKCcceKMA3CmpP5Tt2A8awlgPBgQTQV2fC34o5WdF60DiGaYCdff5Mbk219GIogviYHtSuB/NWPcoN/lLBIWZBpzFN+NAMWUf5Dn3n2Rs/icWzKq6WrDkainHthzuvZjaSaPg4dN32wnCL6COz3cSqPNiDYfdHeat4ewh9tgXBQaLBLHzWGlfCpu67/GP/63gVkyCCObpdI/DSWkeemb6huvnFZuv4joZn1pS8+7Ss76Tg10wxi6ZuxzIJ6lQcyWCSbJD5hlmKWIDWpW3OF2oiECOPKMVRwCXtsOwMY3YXxiPXl5+03M5NzdPO3wYmPV4Mp9bME1JOk/EcEb+ehhDf6hC3k6UrgBm7nyNU5+jDIW5HGWTqXOXMgJ+rkIiECQMOWk3kUvU6pZC0+iIDznXAvvYLVMtn1mB/YkB2ST++FSMU4BoScX4NayPjpIxuaIx5gUUBz2EGiuROkqrlHppwV+ZlYPw1jJTR5xDexjJ1TWhnTsnZxJDOBFMFfzBZ/rWCYu96fyvNnuRnxH6uEqJMUT+Oj1qF0t/riLOHBI/Gctsbl/+QFZ5qjRHsUmHU1bc6k87kOX6mv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:48:30PM -0800, Andrew Morton wrote:
> On Fri, 23 Jan 2026 12:19:59 +0800 Philip Li <philip.li@intel.com> wrote:
>
> > On Thu, Jan 22, 2026 at 01:23:35PM -0800, Andrew Morton wrote:
> > > On Thu, 22 Jan 2026 16:04:37 +0800 kernel test robot <lkp@intel.com> wrote:
> > >
> > > > Hi Lorenzo,
> > > >
> > > > FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> > > >
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > > > head:   dc4fe40a11269aead253fa0beb098b00417b8694
> > > > commit: 57a654376d4bb67119d436edc8c3c4c0ecb3c369 [420/429] mm: update all remaining mmap_prepare users to use vma_flags_t
> > > > config: sh-randconfig-r122-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/config)
> > >
> > > Has CONFIG_NOMMU=y
> > >
> > > > compiler: sh4-linux-gcc (GCC) 13.4.0
> > > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/reproduce)
> > > >
> > > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > > the same patch/commit), kindly add following tags
> > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202601221505.RxftadLx-lkp@intel.com/
> > > >
> > > > sparse warnings: (new ones prefixed by >>)
> > > > >> fs/romfs/mmap-nommu.c:66:42: sparse: sparse: dereference of noderef expression
> > >
> > > fs/romfs/Makefile has
> > >
> > > ifneq ($(CONFIG_MMU),y)
> > > romfs-$(CONFIG_ROMFS_ON_MTD) += mmap-nommu.o
> > > endif
> > >
> > > so why is mmap-nommu.o being compiled in this testing??
> >
> > Hi Andrew, the related configs are set as below, and this is guarded
> > with CONFIG_MMU, thus the build is triggered for mmap-nommu.o.
> >
> > # CONFIG_MMU is not set
> > CONFIG_NOMMU=y
>
> Oh, OK, thanks, sorry, my brain ran out of multiple negation capacity.
>
> The code which this report quoted had
>
>  > 66		return is_nommu_shared_vma_flags(desc->vma_flags) ? 0 : -ENOSYS;
>
> whereas Lorenzo's v2 patchset has
>
>         return is_nommu_shared_vma_flags(&desc->vma_flags) ? 0 : -ENOSYS;
>
> so I expect that the new `&' fixed this issue.

Well more so with the sparse stuff my removing the __private sparse decoration :)

It actually ended up being counterproductive in practice, and the obvious
'wrong' thing of vma->flags.__vma_flags |= ... or whatever already signals to
any reviewers that the kernel developer doing something like that is being
'naughty' so no need to enforce ACCESS_PRIVATE() etc., which in any case cannot
work with the semantics we need for vma_flags_t.

Cheers, Lorenzo

