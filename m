Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94695D3F071
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29AC6B00A0; Wed, 28 Jan 2026 09:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00706B00A1; Wed, 28 Jan 2026 09:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5056B00A5; Wed, 28 Jan 2026 09:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C86296B00A0
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:37:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A0EC8C296
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:37:19 +0000 (UTC)
X-FDA: 84381625398.03.62004DB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EC0CA000F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:37:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lCJ+WvTT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ST0O4pkb;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769611036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMQePxUtfWMl1T9B8DRhdmvCp2wqH/uTqJ0fn9Dmn6A=;
	b=VMfMeRujAZlUv3ksX/YeaJ8QRvvODhG1MzLfEZG2O0gx3UyxcEVZ4v6PJnSmxfU2m3VZP8
	m+LpDIwVTt5UwMkyMc0FwJH3qJTbn/4i+FSeFbAEna4pwgVEC6rkNxzmbHWEHaXmpnoyQj
	8cnnFR4c0xQ2v+JW1vA2iEvL43HlB58=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lCJ+WvTT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ST0O4pkb;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769611036; a=rsa-sha256;
	cv=pass;
	b=XEK8mbhwVD4vtpxHlgvacUdY3UL8gjUL5zxEDTlqrkzZfInk4NPD81G3/702BWAytyDyuc
	xWml3dBoN/7t0+RI6L7MEK9Ld5ubinNnl/jSDyJUWP+5mw5vezbTRc7GpQT9Hv/yiwSnTy
	kNSU/cAEyZwLUT8LDD1Q02ig1TnFMsI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S4C9S91337667;
	Wed, 28 Jan 2026 14:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QMQePxUtfWMl1T9B8D
	RhdmvCp2wqH/uTqJ0fn9Dmn6A=; b=lCJ+WvTTMu8xrCG9OkVIx5TrQEZyx/puNr
	yISEO1XiF08T9xu9cHWhpyp2KWj9wcw3KIT4WPYDZkQRc8RXibY7a5ja1dUrZuT3
	vxPWc4SAmSF5MJhZD7pHvbsY1no6h4jQaXxB3Krih23YhpNx1V24rzz1AZ0zEti2
	F8MTnEAAsyn/ztdHRYZ5RhsOWmjJX0cHvDa2PAy3k92iJDPFDs+HrrXIWqmzhnC8
	OmIAnD0I2ZpBC6fZvTSgCX5v69j7ZHa13fB5UocHVqrdHrZb/LsJ3D1ifWxqYme/
	LR+kqOBFHCYf9ZtXL3byEe2JZ4T2K6fHYoWWSMWPyvpMdiIxleNw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09j3q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 14:36:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60SDMB8s001836;
	Wed, 28 Jan 2026 14:36:57 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhfh644-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 14:36:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XhbyrdUl5zovMWG5psiqkVcf7tPIXTcub7nlufcYO4WhhDQ9vUwywV5renT5J7t85MZFwGoNFiAwzpeF5FC2BFA8DvymTdVjicHIZSUjMMZdKRWcpRJTWoG7MNu0KCaDOj3hmtqjaLtBdTvECJx7wVpoCRc6/nEeLDscn59c/HHNYlnvW8+mDJZeBBbja37jDL6A+DJ6n/BG6AztfRCPyXsDLTevnSDRI5rApyTTvonWiTeXHwtuMLRRoANdUWFVjFkg6b7zTKaJmGxHNJxavKiBpv8jJ6ZdeCsf6WEZRnDvUHyDQzRnCDR09/5V5nPwynrHsHZ165k7nBopZcf7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMQePxUtfWMl1T9B8DRhdmvCp2wqH/uTqJ0fn9Dmn6A=;
 b=IngbE0iGA10A4OaE8Nz00dHV0HpNnuI6zb95V5+FvSGPt3/6ydExTQc8FzXQNxYsLJaQ5mUmD8pnWj3dQi3ISS9ypzDoFfiZk/7ZadXapBFgypcd1qx3p7xg2KfdBbwoSLK2POWQIW5nBqVH8N2ey0cHyuU2G7HY+oNftJ+LpCgF8AmgzOJVoQZwjGtxEY0v0s3vr5nc76Tcv0LLOCwO1mXWVQpvkC9tfl4sQ8Fc5FetKJRi2p/AhR5fZsVBAHZRdWZ32MjM/XWbY8kebGvmxThg31tc7DnnnZgMxRLHF5ud4+cR2kqpkcASGeXw4UQCsYqKVMzJ4jv3XC39mMgrZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMQePxUtfWMl1T9B8DRhdmvCp2wqH/uTqJ0fn9Dmn6A=;
 b=ST0O4pkb7wXMewHGidNOSTQcQQ+u07amHEx9F9h96GyzzIYREFwYRIrgwGPB9CzLqAS3/sxcpZjly/j+ZDGPXIDtGDvDPL2CJK9YrR0n4+I0WkLG68415d8+dCkvFTbaSzuXjICmVjfDA6S/jYX/a0ZdJHWfKxjp7VmUhwkInoY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB6219.namprd10.prod.outlook.com (2603:10b6:208:3a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 14:36:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 14:36:55 +0000
Date: Wed, 28 Jan 2026 09:36:51 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 22/29] maple_tree: Use maple copy node for
 mas_wr_rebalance() operation
Message-ID: <znatn4y5bl57cb7fffvcgy6lznnyv5qfmzlnin2q55lxhhagcn@cl5pu256rsna>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mark Brown <broonie@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>, Aishwarya.TCV@arm.com
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
 <20260121164526.2093265-23-Liam.Howlett@oracle.com>
 <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
 <ce123a4f-c35b-465e-bef1-30a86274316c@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce123a4f-c35b-465e-bef1-30a86274316c@sirena.org.uk>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0468.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eb187d5-a3f6-4b7f-f4bb-08de5e7aaf13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zDcehRnBsnWplAPce+HShQfBBlCN/ZMl2Rkzo6kzSdG9N2k4K9j2DhA3Zpu6?=
 =?us-ascii?Q?5DIJk83OHFQC11/o95vWRsi64dZYDNvY6jADEfdrMmI6UAMqoS4e/qZfhilV?=
 =?us-ascii?Q?Fvx+JMWiQO9Iqi9A1IYn8/fPXTOUxzhEKKJ+u4fS6LWKjNRjwm5cqbim3S8N?=
 =?us-ascii?Q?Mu/H/eGcHSMXIL/WwUQAM/uNqsLJJjdQQdJ6gIqSdIeiB9QG3+2pB6Srt7Eg?=
 =?us-ascii?Q?Le+atOBlQ10Cs5FV84j2hTkdEmaWgejZ9kqL0ySvzyTrDQmKDFW79L6Je3iC?=
 =?us-ascii?Q?MS6ZX/WRpaswgCA6XJ7NyTrSAC9j0tejUc9a6J1tEWiTqapdikvg9WnC4z/M?=
 =?us-ascii?Q?F78qaH0azcDHZRLHOKrSGLKdLGUtQjAlwtVffAU/qdTTDnjTE7Rh8ypMIwRw?=
 =?us-ascii?Q?En8Zvd2+5sr7O1c1fZFYs4oafSWfle0Ibj+jbYnuEVtnACnnc52pLyqeUYMy?=
 =?us-ascii?Q?RpMTWnZxgfelvCGls36Hjy87EL3DCwWVVXmuGrQbtVfdC1E6uRCJ01YherHD?=
 =?us-ascii?Q?ol2omEJy6wc+FiFoyAd+l6IOnxQk2E+LsC9IeVH3Vq7AXzwXic3sV9tQ664L?=
 =?us-ascii?Q?5oGqtIcJkGCKYoECLX42pVqGnQSu4pKmRpkncJ6QDVz/FOK+K/CnRwq/nup8?=
 =?us-ascii?Q?iPhsa7+BWtmBZYVQvgQCSn4RDkRGEBYpLJGCh8wQ7lPCadDK0ydwaeUy/Kfd?=
 =?us-ascii?Q?OQQXKQicCaJ5RyAgyko6bgCUvBuTmBAipYvpTe1pGCVdNvOpmpFAIZUoafi2?=
 =?us-ascii?Q?0m0d5YwY8vteYJ+mCvEM+KIDOoO66kGOjeOJwUp8yNDYOzdl+xJW3oaj+43e?=
 =?us-ascii?Q?1FgWiLlvN3FjBxguK8fayJviipvfSt3R23ua64rZUDMawEDzm5iMO620bn82?=
 =?us-ascii?Q?dMsTl/UOy52o4cPc/EEN6RMof5fGXB7i2d22VuVmocarlnd+CdXzq6KZNSxZ?=
 =?us-ascii?Q?V/K/nM+Yv3eb1m+fzzYe8GipnEgaF6cLx3iNTiDOv8Oe6ChNRSxQxBMQuLCc?=
 =?us-ascii?Q?pD0PkZ0ZT3ngvaYagoFO3dmkiiYWpl7IPTMyFT4jGanr1O4g20tUTV6UaExL?=
 =?us-ascii?Q?CRgjTEl49cBY7d0bAyvuPBth4EOxKbo6+4GMDf+99ytBxeJYYvLRl0u2sMCS?=
 =?us-ascii?Q?drMxYaJ/MagDnx9yqJTwv5yz/w7sejvvTGiwziGwQxCOFbDVPLINMJs/4ska?=
 =?us-ascii?Q?aRNfXccfed5we6GrG9V9Dx1HYblJTbPE8BQqsuqDTi553abc1yGDM9PhLlB0?=
 =?us-ascii?Q?jepLKUaqiHYBXVVEyUWYWeaeU/2faSDHl6DtZrvF1+vwPGWdWD/odvgyEuus?=
 =?us-ascii?Q?camRehPDHK6tWWuMO205J1mryB5AjN4bkXfiVTdCGoNNtHKC1rv26v7GMfx0?=
 =?us-ascii?Q?sSZBY9gr8jvAJMc8u2FgM9EfYSlZMjzR5vF4eICOcvHHgZ2tkPfmlNQNm81F?=
 =?us-ascii?Q?2O8IM4L3hmQjcy18E90Qp4NoQ8jppDZRIs7II0RzF65J8grpAAX0cTon2+th?=
 =?us-ascii?Q?oKERE6UQu0M4UFzNva1ohObZM/hqnYV09Qsj9e+LqzuUW22BjEMHFmoWsFNM?=
 =?us-ascii?Q?1KDJoyusqtwcoEPz1Bw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FjU1GM0YgM22LJwoI1QSCk6xiZ4LIQoM2EvnGwCfXMgfRulFKPuS7cBq1xtm?=
 =?us-ascii?Q?yQCNBZOKtLAB7SDkFLmWRKLXFlCzflhqbM87P9/TAGg5dA0UleUt0qZHq6l1?=
 =?us-ascii?Q?Gfe27dpDoMnZWcUPWXgxh2IVwVwYEwOTt8EaPnMrGlv4QTHkqxBhX3eCFqjV?=
 =?us-ascii?Q?aL9XJvlFr6WQa9vDYpG7UbdPk8zBFSovofwJkWfLKzKQWfP9WSPa87L62dgy?=
 =?us-ascii?Q?hAqNfy4p2MtV0hXPh48ay7rr2uSaekY9btMimah6weKRsdjZ5MHaFP0U/Zm1?=
 =?us-ascii?Q?qVEm5eMYTTPphpKbzoxmS9Z8X7Yr4ujH2i38mNVfGqG5XT1sz3n4WSQaaqeS?=
 =?us-ascii?Q?7SW2/qImwtFcycqo9j+Ib48loEAUUoslJGmFYn2yV7fpgWt+eGLpK3D9Tote?=
 =?us-ascii?Q?o3UGrCMxoRBPSMnFjTc/S+kBZEyEkjKn+CdLUGHkc4cjVJwB3ZDJf92shmKp?=
 =?us-ascii?Q?/L6YUhsQnolwekemnb9MnqabuLijzK9L8vqISgNumsf4xlO5R3EKd5IbnZZj?=
 =?us-ascii?Q?iEgS0eqO4Ib6C/iO2Zk6Ze5Nnt44fBxdaF/UaaVEs6r7EimWSzydanmhINup?=
 =?us-ascii?Q?o+KihoFTkVNNRNkd+POjVeOjHIcji8XLONDp506Khkv2t4IoZloTonis1fTj?=
 =?us-ascii?Q?1TsngTl2fyMB76h6dsIEO2gN0FSixMFcB2RZ/Df9kzknDRBUXVDs1ToI8IVR?=
 =?us-ascii?Q?WbHUUkLqnZ2BBAvOkyv1fvalF4Vfcr5HOSTIuFWdjhIlkZ1WFYoTE49jO2cF?=
 =?us-ascii?Q?T5YkrXCFDgl0YlEeT2brWced5ycCpT2M5yqI5Mgp6V5rbD2VUQgMvvZhNxSp?=
 =?us-ascii?Q?3aF8gtzOQsaHHChEOMdZo36A9rkVk/YsoLT8Ts5eWKuHPu9TdmEiGehaUIsd?=
 =?us-ascii?Q?y+dwXnhCNBItIDw/ekbvdDbklU42ZxlFubhP0iw/qG+sxRKqK0ktmIxfRXTr?=
 =?us-ascii?Q?9bRBlju/BOVVNx52PYyrPQdAMiFCceoanZ09YRauL44T//mkD3dtKGz+wXdt?=
 =?us-ascii?Q?8Sj352DZBGdtch7y8yd9Xsf69bqFlF/BmlCbi/OAflz4C91dZLas/2u9521x?=
 =?us-ascii?Q?4rvK+g5sCYw6mKZs/yfAQV7ptALBqPuA1AEjqWpnKzR903SMz6d/LXawz+pp?=
 =?us-ascii?Q?9aI8n2E+mCcNaDf5HHFsV0Q3GPUJzRnWvK+2zarpvlhd6fFj4zGFQWppzio2?=
 =?us-ascii?Q?DsanKDrd4t0+Qli8y8N8tVKkxaIMWCToxcgr5WjqyJKIkGFODjjBkivKOvWA?=
 =?us-ascii?Q?96bktoHnlfKXiNzgyWAtuO/n4hKHOp+Iy+/Uab+h3+Ol6aG8Q2dvAm3o7vrx?=
 =?us-ascii?Q?PLZL0AgC6G1QAJ0PniNTJ4l4gc75O2YFO61YXFM195uX+vGC/CU079tP2WsA?=
 =?us-ascii?Q?amlyc2I/KbJ6cwTahPdU3H61V6WPts18prqRAcG+4td3n+0eOXQR6IBy/Mke?=
 =?us-ascii?Q?+cUF0kW4H8wRCo0Sn46Hk4n3Yk9v3QFfkHg+i01Ks5poECSSn8TAH4jIJCjF?=
 =?us-ascii?Q?rVDlSpdGnTa2ayJrUvjY2z/kA95Mm+/oPT4WGt7zMBNJZyP0MigLu4GceDcd?=
 =?us-ascii?Q?w+uEaUOISlLZwWu7OzeO7A1vgfY9WUIBG1gqyG5PNeJLV9+r/Iy4tr2MH23F?=
 =?us-ascii?Q?eG1fKsRGMOXCrKRW+qVPuQzRTS/GfjpeyRHbkFx4r7WhhrCgDJG1gIprwrQk?=
 =?us-ascii?Q?ZaadvbV3dpbF6sFcDDznBW6mDiO+VN5I9xQQ/I+WhEJUlAuFq47+cihWNU49?=
 =?us-ascii?Q?gYZWcp8gdQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wS326/NQtXWczpKLr4cTYKPxOr/RY5ibEdQuX3KEpdmD2eXn2QnMdXvMBNs82RI32Fq3PJA/6dc68DwKb0RiMNe7TVUbHt+kXxth3HK17OJvzOhIESNciuJcZ8BMSChWLJfL4YuxWCiLyUzEErDTffFqZ4TETzrGV2W9cy9B15YBrYXy0ysG21q7BYIbMkYFS0HBwYU/SGQd8d9FrjXeYLz6LkyTGkhHSHlHVcR3yak8grBZI5NbW/gbA57xv8p2tnZJP4r3p+dbE05zTI/FaZdYUxxiHGnnBTiZFNYNdiV2yMqLpoYVuIejlojn4M2bbFOIJ92XDTh3XXqX5yiJRxqxNz+c8fr3kLUrEe2OSvVnphdR7f0Xx1+IhFKLBZcE5bsgwXiMpABTwrqf813gz2DM8uT4gT7xgQtMtZQxmDORz6s24UJVNawkSwd58M1Rq6vxjbwMTYbENlLnqMD/1TUlgE+90ZhF0gBNrhVEbqS7R2HBUaDfGs1PSExswbIy4EhY2eYlAtcG3W7SgHLqWbU579XLVGNzc47NxUmn52FU8nYbvRrCOKIS7SipXoa9s4OKQ464jFCgdcg2VQ7ouJZn9olSmedGo8w2hFozMIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb187d5-a3f6-4b7f-f4bb-08de5e7aaf13
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 14:36:55.1152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8seZ7ab8I4Pk34ANlj2IH8AEcGArkp9oXDdwYzqRVCkeYQRMIjoFV5p+Vk2KNPDQwtZph4dvFMjMipxVkPB7vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_02,2026-01-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601280120
X-Proofpoint-ORIG-GUID: keKHNTM3r_mQJKsSDYrgWJOMGjY9KLg5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDEyMCBTYWx0ZWRfX3CzA2Q7F0Wfl
 3XzXrEwpMUV0r7LIX4vr/gR/E1fm41y+WT39ZV14CL7Lx3mnUGmgLWHhGqnT0yN4QuUXzioAAqA
 8TECNmEZmAutPTgb7rkZgIbzad5kuifXsGAfEnyYWVND2OVYkB5od9wDywvps1VOmBnhcfDciZ/
 X5tGlSskr5ekNoNPB8ZND4ogeKm50N6dKkE/+aobLAZu7dl6RHKCY5INAJ6cInNHxo5NBbdUXzF
 R5a8wOvYCzC3KgxEFSlIimYodWODdEDN8tM7ou85fJq1meANkU4R3KRXthLm5I/sO7fjVAX36pp
 l2O8YqiFI1f+Rw5ca88gqJHz2jaY56wvHMN1JgVM1cBgINrnDKt1TRdi/5EGIuY5ZebGP3tMYEx
 ePan9LhS+HuW0TgAq+lXgs4Wz3OIHLsz3EQYl7ZuYoHItDtBG2AlymsRFaeC5TKcsL9CGa44nco
 TEiVVQF9XeXMr5+Uf4S+211UXKTOqCmwZyok6sjA=
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697a1f0a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Ec51SCiPbZtzNtErd-QA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13644
X-Proofpoint-GUID: keKHNTM3r_mQJKsSDYrgWJOMGjY9KLg5
X-Stat-Signature: j6rw1ejgpk7wdqhio4oj13w95r3dmbu8
X-Rspamd-Queue-Id: 0EC0CA000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769611035-719981
X-HE-Meta: U2FsdGVkX1/Chg76MbuqeEut77vnsVEMYbErDQtUmaST3v1os24I8MeWc1cwJ714GLsVv+3kWa8AhBrV3Kt9cYD5yqNgrDgYjtB/HDpl7TLSjBbDoJDo8CZUPYijf3cErS58qKt/pTpteFJ4bTRyPA3Lp1MkTGCUiS2Nhtj1e6Q0kpBbOQUsXuKA3EwHCZb11h746Y7aYEtHQ8PlQTFmWOkq++qaAimMXlEg1jhZjeIsBI9Y2gBJbTVkTwuRYnkqO3BaEPwMzf2aruHhLtuUMz5AMlBb071SLLdVypvoUoTmmZNIDHtIlamA3aYRPXFSsrzwWGNJGCkUYoD6NLval6wznj6cqOAvB5WNwQEf2Tc/Kh8+HC3Na0a7U0j/k1L3OOwdqNZAH4tXTsYVPx6tea9beexJxaVPvlxcJtimY02wjKqVx3+Sg8AgIAc9tCZc0XIDyHnUJDNyB+b8qWXeEXFg7edGVsIsFGW7PWNwlvDkBLsrSnGQXYK2fkHy/k+cpIdwfh+vMCmPxGkZ3+qwmfDPWcUoPvdbRoXzL9P5Ddc52eY2HOGWjjSprOwZmweF0DvVTZoDD5OEw4z9pdPNl+s3MDQpLj3G4O/vzFkvf7RbZVW6XVgiCCn/mGcgGQi+RJ9EOtdNFMkaY+jmFgrEz/kwArK35CTwH5W8UTEMSoxuolyQm7pOkh6a50TEfMpdyR2ujnxpdWY2OdOFfZ8Sh7PaXaVg+9zk/W50KhupGVZhhL8DBFaELN6Yb5plhMb0uf4QppAi92UrhQL7Vv91dQjwYRVQ8P3PcPODQEt/yEqEHwVCL3KBQqdISui/DIhj4cvfWGyI8mvwPAWipqZEF5PuoGkVyvuswVLHdW0cV4DskkUdr4EIgbZFTN1oqTArtRy6FW7bcUQpSlKUn3yIxVwVcxOneJJ5TulqrTBuyQuyjM2DRDESeuMfTmovAqAQI7g1U5fPHg6hgLjLK3v
 C5hvLObi
 eGEyuf9f1QYH4LtghxdMEFtrs/5cIjErsJgkIQ3xWirTX1ukuwG0MXtYE+TSUw2x/nuO6kg8V8l+I+uPv25bDvwDochdBC8NRQqAqyFPe8F67A9hZdqbVUXJEKCbT8Zf2+Cun6ZaQcFd7trtjkZYSzG7W0ZP+CnwkuU7Dib5nLcesNMf3qJguVoEgsUy/wBFu5sAf+IWi0YuijiPSGNasvH/lA6bDQccbvAmWUQP5choDpkfIkNGPe17ezqWk6vGlVSF6DuuFt9/cAeUi8wDRO04Wl6nUkIOSGoP1lY4t82E/JYEoj9IBAMqs007A4PikoKSBYG8sVGwLp54XqMy7BkN9cSMXkliWXDfJPZlzXGy0VF5Og7G98KjgnmfRzmAfOScj/8tD2z7qSloNTN52cYsEnQMtMAcsv4UZQ+IL2J4EJUQCRUwHNMnokl2B0r8id0Ke3vmZJ75NL1L3MFR1j8AYGI9RNhB8Ig0ehCDWp0t5rxV8QX5sjhLCCxz62eQ7zkFtizLkkmhMtDYB8L6C8gqRQKKOCts7qIWty6ImHDU24EIEZ1mCIOh5mf8bHxbQ65/WG7XY8Z0UJc4lbRQd65/LGEC50HNNCTLVmTllIzTwztrkIBASL+U8PXgu9huxZRdImNxMKt73W2ctKNdFHKZXdwwOH0gFqMJSDt4MxikZwd/KTwv2RrFjydz+4PJjIp6/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mark Brown <broonie@kernel.org> [260128 05:53]:
> On Tue, Jan 27, 2026 at 11:05:54PM +0000, Mark Brown wrote:
> > On Wed, Jan 21, 2026 at 11:45:19AM -0500, Liam R. Howlett wrote:
> 
> > > Stop using the maple big node for rebalance operations by changing to
> > > more align with spanning store.  The rebalance operation needs its own
> > > data calculation in rebalance_data().
> 
> > > In the event of too much data, the rebalance tries to push the data
> > > using push_data_sib().  If there is insufficient data, the rebalance
> > > operation will rebalance against a sibling (found with rebalance_sib()).
> 
> > These appear to bisect to this commit, there were some issues with the
> > setup of the bisect which fortunately don't seem to have confused things
> > and some timeouts stopped the last couple of jobs completing but we've
> > got adjacent commits showing passes and fails and of the two candidates
> > the other is a refactoring that doesn't look at all plausible.  I'm
> > rerunning a clean bisect but expect it to confirm this result.
> 
> Confirmed:
> 
> # first bad commit: [6ad069085c621d39fad4d1835af7e563975dcf7e] maple_tree: use maple copy node for mas_wr_rebalance() operation


Thanks for bisecting and the test name (linkat02 on arm64) from ltp, I
really appreciate the details on this.

I'm working on a fix.  Please let me know if any other platforms or
tests showed errors and I'll try them here before it's re-added to
-next.

Cheers,
Liam


