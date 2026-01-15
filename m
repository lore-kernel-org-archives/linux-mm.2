Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DB0D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52F76B00E2; Thu, 15 Jan 2026 14:37:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6226B00E4; Thu, 15 Jan 2026 14:37:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C699F6B00E6; Thu, 15 Jan 2026 14:37:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A68BF6B00E2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74B241AD257
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:55 +0000 (UTC)
X-FDA: 84335208510.12.C89D183
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB32618000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Sx8HV+dv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F8VosyOI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505872; a=rsa-sha256;
	cv=pass;
	b=6q7Ah66a0Ls55+tAa1P/QqGTfG3U3+MKes5cppoGzPYjbwWr3oiVHcDMtSHoZ5WxY5zy0s
	3yCyokFo+a0GcSGAV2QDnon6gneinsB6gSDDTimMPLRTPvo80kblZMKXQmXCvI+31OsgB+
	vPPyGLkC1Y9W30pTc/roH3bhZ34sQJE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Sx8HV+dv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F8VosyOI;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7NbiVhXh0UkCgaaBGPyiUDV0ynoQF280FNk1MHGjOY=;
	b=fvZxUxhgQZ0HN1F1TDBJ7tS+yKJYQG0hZtM431QGxfxpvN+rSAw/2vEEg7jnOU71d4iCkt
	OrYvSJ+7X7cDIAz1I2uiFJDB118iC3FNRl0vaPAa8iaVorb1mqtNTZUBYICwH6t+K0imb4
	+hiHocAx0OVYQrM12h2jaxzQd5IemnM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEM3AS1296007;
	Thu, 15 Jan 2026 19:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T7NbiVhXh0UkCgaaBGPyiUDV0ynoQF280FNk1MHGjOY=; b=
	Sx8HV+dvGejkFLldle+YwoAMT3zCr4+mmQv9MWIWAjqlB2+C9CDT79MPA2iIlDqE
	xm4H93WiQgPPDrr4u/cxrUXjsSo73gyWTUwnBwdAcwWm6C3EgO1A2pKmsIELmvYR
	aXkAKpVy2C1BXCcsvDixaMQF859JmynHJIcRufCTwd29Eci/vrisSIgSIOcyptYQ
	+lBLELkuL8R0xuKjA63rt4v5gmucBq57jzNpzbVK24Sktj1cRoisgXWlxSehuKDy
	2hhhA1Bje2P3jWVbmbiQm6+Ww3w6MXK80oh3DL4oGz4ImsttK5RcwFhuy6RGzq9u
	gjSO2IbAkP6uQvrGqPCHeg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3tts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHv3P1008289;
	Thu, 15 Jan 2026 19:37:42 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010068.outbound.protection.outlook.com [52.101.46.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bffdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCesAHyptW65Ufnqyrci8KtrTVOMPpkgFFuSvpTbnYsV+vnYtjs44ntYtVcGy4GgRNdMROCrJWgkrM19tVmw3WisuSoy67vHhbkS6zzLqsu8pq0wWz3YXMCyRgCri86Sm1pSWdNuj70zJfV/JpYIoMn0Ev2+kdjYyg/JWSa815Jb6IfuFekS7EiDnv/j2fMzHtV4SLSfZn1d+sX5T2MWTU9vunu/oGvSE55tdrDGu3MuvEwArKgeJv5tmX9LE9/uIQGE2PpBgCXlrPxC+cMn6sc6Lax12L8imbV6RQ36+lgfwKliRSU+YWXF0QCCvcNuBSEnVKWCvXCdaKeURJTX5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7NbiVhXh0UkCgaaBGPyiUDV0ynoQF280FNk1MHGjOY=;
 b=YAr6St9xK8lisw3+7xolmCqTl+bk6reTwanJ2THYr5J9rBB/jgPXe/6qNy8yC46cj+XoPeBGnXaaUFxZ6N2JTI2VkPO4ce1NxxWKADkxCc5QUGIAyZganvJwrDQPBdP9Phf5eiVuaMnVTURte7t+xG5jXqzldsRf2UDeNDGxF74j52V/cZn3KT8kTJSYruQ7OvLHnRq805o3Atc1jCQ6LRkxDUTrYBZoyrwFr5PBU57vjpTpTwqSViRKifnwlI1NUT9hWkVE7MzqDjnsecFrTkbyFJO2wMq7qBvPsUi9q9r5Uv4QKlYgWfZmT4XqXPv7ZvVBlhw8AnJ0btB+R1XTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7NbiVhXh0UkCgaaBGPyiUDV0ynoQF280FNk1MHGjOY=;
 b=F8VosyOI76XvkU/v9/7iqMQmp/64YuVreCVmOZHZe6124TUW9T7OZc2I6vxUzFIAuv9Kzkoeu/dFIDWm3fIvFD8c78TeI6tuimFyrfvX4uJF1yIRdgh1ubbHd/d+XOQGqrVy6buOq76vM9cyHn4AWTa8nJ/L95Ao4PtM9m+qzbM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:38 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:38 +0000
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
Subject: [PATCH 18/28] maple_tree: Remove unnecessary return statements
Date: Thu, 15 Jan 2026 14:36:37 -0500
Message-ID: <20260115193647.1695937-19-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 870340c2-4f3e-4007-90e5-08de546d8a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g03iyupJ0z1t6Oek3KqxC8cuENHEvtW1EDzpcp7QsuFWyffrCrsKDyi5F1ON?=
 =?us-ascii?Q?s3FqdOgAMFroo09YBjG4eQq5w0K5zeQ/10QQND3+kFSZZ2UWX5K6BwBgxWUH?=
 =?us-ascii?Q?GURGgkl0fGUF+tAc9yX8L6rGoAEwLahLFqZHus9P9TrJm6bYapNCHuhFFWe+?=
 =?us-ascii?Q?GrOpy6sORLc3rI4BGJurbOqfjxjVUXjZQHp77fl3iROa35NuorO1AFQBO1+E?=
 =?us-ascii?Q?u9a24LWVJ3z4Fkc9vcMQjDtexcszhuYegj++oSqvrd1Wb5bK5MMQs+y6o2zQ?=
 =?us-ascii?Q?6FuikiBW8mwr8asRwO9nB1lCj41DGfrBwZ5XtjUMLXb4AApp9tSFcPhsoHek?=
 =?us-ascii?Q?NoUl4kVvfsuAp6WRzok8sichmzyuhGAorp6F37tgM4M6lH911I4gvYNWmTGi?=
 =?us-ascii?Q?8V0Mu7G3gNuRaCn4zGgxLotwT1IH/yE4UIEIYlAyVX4eR+d6v5HuXnlcJl7r?=
 =?us-ascii?Q?WePqG5krv1zSeALtVTbb9y8ux1swquvTa80Cz8Xk9veEh3oEtmu/LxaLSpsx?=
 =?us-ascii?Q?knnvzL+npUkmZ8l8X+Hy0JP65SIvKwiWBnPCy6MGXC1c7obrO6zYypCv6LKp?=
 =?us-ascii?Q?7px/mUSmyOnhPBoHU0tu1OmatuwVSzEOBXYHFuTBlhGG9/J1sKW2YItpgsH8?=
 =?us-ascii?Q?CdLHHESkN4TSY7kPm9IWxI4btgrOvs0oBvUXZY+gr0V5gdOFInqHaB9AgJaX?=
 =?us-ascii?Q?q3qoZQMQD1DDdc1F6yDPTjJ6+nn9nG4FHjSSjiE5sS+tdVkvrnn349BLPA2W?=
 =?us-ascii?Q?NjiwTdEAyKBAVboLv+PKAbDrqxmZCPrWegW+MNnHzFByCEfKPlijwhd5SuAf?=
 =?us-ascii?Q?XGgaAVHieFUDTQoGxczQclctL5Gw12zTJU/jh5DhAxsPoa8kiHFq1dgEPe02?=
 =?us-ascii?Q?x/KcJcH5x1kwURNGArXNZIfmJm+5cJRFR0UvDueDyGfchfdasmT5gz7Y6D64?=
 =?us-ascii?Q?JxIG+IdqAx7mDRD24dU1u/iC2b19Eeg+G7mUAFDob0yrMX+05enxOEGKLEuz?=
 =?us-ascii?Q?bn16jqWGiewaA5Ucqo850t+OGsd47U1+wBYhwWCHIcu9cAEsgxXUrcJKCats?=
 =?us-ascii?Q?polClS4TPMX14glhVn+uFx2EhcF6DekKwWuw+fKsUUCTDa4RqOxQZE5fsF42?=
 =?us-ascii?Q?A8nSTZOleaLcXq70iAQntPEqqrR+nChRXnyqxjtCv0i6wUhUApl8Zb1DmwT3?=
 =?us-ascii?Q?3wXpmi6BBE2q7WZ9QVVoMnODkd8NbDwn4TcAfDLkhOIGg8ElJ2TB5nCN0r/v?=
 =?us-ascii?Q?W72j0ISzoX6RwKxOZrIzEwbX5/NMVS89ONLSLJS0Hvbi96J5QJVhbF3uE8rf?=
 =?us-ascii?Q?24/sRbe6vNe9uBM6dRz1MMut4cg/ljVHw1M+CrHpJBS5Bkyv5fc9myyNqoCZ?=
 =?us-ascii?Q?tT1MdIpfxuqe9Hm2FA4oPpJu1TjwV9Xq73Klkak1gk+wefd0oqOXSmeeKBQY?=
 =?us-ascii?Q?YL67Zbk84zdO1oEV0mmdSwYub5UTiv8Fzy3PrsY+COQpD0krY+/CP1RzxAeS?=
 =?us-ascii?Q?IM4Blmi/1GA5hr3X8OhE+3eCH3qlRPtxa1XYwO0JcyB8vNHTdAEIrL9ID494?=
 =?us-ascii?Q?GXv6d8ovixa8bm5Z3Ck=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y5S4RKeuXo6f+NHn6lAE50msIb/SrKj6zBBKIrjMGj80E6VaZk06a4gop9bl?=
 =?us-ascii?Q?LAI7FsFUeG0R+mmw7heilEyWBY10B0x7R/l7EAA0bP3EjpkD/BIAYlPGf51g?=
 =?us-ascii?Q?dlq9WuJVmQgq2jGo5kBbJJlePimDh6KIDYjNaPwBPpIzXU4MeUgY2NYdWGiu?=
 =?us-ascii?Q?+AF4pHKtpzn2bxdtKehpTAQkKvA5a6+WpSx7b2846ex59CWPof6SkHxMQiEm?=
 =?us-ascii?Q?punhExOQdzS1kqYfbgbgMcX4nwG1mpRUZ1kfDzyPU6enLlUw1M/PJWHt6h7r?=
 =?us-ascii?Q?v3CPXlj3vf2lrWDGr0SWx2cJGM2qAjDkZoeS+FH3gqpo+A8gxNqm3N5mf/YQ?=
 =?us-ascii?Q?kAiIyuuDCwnKgH+EqE+BAqrwYus614FHndvEKMAXSsjNe+SjZXp5l+dAQ+w/?=
 =?us-ascii?Q?YFj2CZpry4CKyp3fcWHl090QQ9tNQpSLWpKwosYBV62d7Yr5EJOXoE6X2KMo?=
 =?us-ascii?Q?WnIgnZogZEIYKp4rYFD1dHwaKbbV66Pj0R8TU9Rj+89bIyIdWQJ2sIhs+qb1?=
 =?us-ascii?Q?r0N6pn2vBQHdK5tINUriVUSH8wtT6w189Rp84LV6NnaCzt1LCYWJGw+LkETj?=
 =?us-ascii?Q?rHTduQaMWSK3SSj0ZV2y2ZBQhPM7CDohrcTG33ifIE0RPNg0RZaRYLga/bgH?=
 =?us-ascii?Q?ADyij3FWqYPN5/TUovKGqyij3rjgSphkX8qqLU1l+1duX1SEBcrnDlAbr/Dj?=
 =?us-ascii?Q?d5O18CZmCHfOjdq8wYikRU/bjyokRbOWkZ26BQXMPLFVn7EsbAq12OWSRfKa?=
 =?us-ascii?Q?KjZ9iT80u4pXuCrckdvyrU1pVy7ZkfjkHGZDCT6mk7YXKNYJlkqO2Ynf6laJ?=
 =?us-ascii?Q?8SP6ZSktehoaRqZ2KQrmP2o5d38zS3+bGVRnZ+O7neU/akOzmCrA/lYbJwfG?=
 =?us-ascii?Q?VDObZXrgut5DrvT6Laf7BW4QiQYEdMA5BZGX/Mlo7pfR/e3waOrdR9AtQ6Qp?=
 =?us-ascii?Q?cI37kX2I2I6NyOTg75zp8Z80qIIhT64K2gnbfnTN+9pxUfIUYrt+9zcBvY2c?=
 =?us-ascii?Q?FrUfkp6SPrYTBBqsYKqwfREMR/PYnJEbwBobagmF9UDAYzD/h3pAvE8eLdX4?=
 =?us-ascii?Q?2Zt5IkieuZApd8ow7qs/sfSZ4tRlOEvWQT0zly8Os6guKmyaL2PLL9oEmPSb?=
 =?us-ascii?Q?eWwEtOu231Dhz8paVDWSDUJj8DXi/82223mtJkh2JrYzUHcfhH9QdUyLtv6N?=
 =?us-ascii?Q?v7gPhIPK2V/5i3Ofqk5Xnk5ubSGGVm5yoCZO2joX/Z1/NuFWmVYAFi3jMkrH?=
 =?us-ascii?Q?+bmZgepeq97Bd3iMd26lGMUNz1wYxOaF17Zq82+Xs4p2iWyKc1hqkQpBCMn/?=
 =?us-ascii?Q?qXoaX0amjB2Ls3fxiK0pThYzHwl/o/NIPU5E4lv6JmgJvHkqCA23GK0aWwC4?=
 =?us-ascii?Q?el9yci0iSgpipDlHeyLsi4qURoJFm7Vu+HM5dNuN2F/fWljAo55NtUiyLWx8?=
 =?us-ascii?Q?Q/rroOtJ+BIsy1ABGRwb/5f3zns/pzxOuRIsBsBWtO1UW++1e9OG5gcr7Kd8?=
 =?us-ascii?Q?5S177rkzsNqrsfYyyIGxBkNiTQpba18YCd9+nMssZYzhhmS0+cJ/vz5MPpfw?=
 =?us-ascii?Q?ta2UsKAX9FlSeLMwcVrlzgmxNgpyDrLRQ/NAoF4lI3ZeZGmkl89PGC/xiQtC?=
 =?us-ascii?Q?nhOH+8kQIk2r+J6UnwVdRbAtjSnOmgVl70BuD5sSSu987BZ3oqZ7P5BiggN1?=
 =?us-ascii?Q?lOkBVprMgswaZaVVoldv8ExkgZbcMZsmjF8RXBQWj0KL7JwgJPuhVSD1V9wp?=
 =?us-ascii?Q?Ot/JNU0S7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8yBKx6Qd3BGowwAxolTiViz6Wvlrynpn7hVEkzOb54PkaEzR149uVYtrwqStyzaCIzA3XWtpuR0Q/vOoDa0L26bjj2oGn0FygipujBagmbxbdwVa2t/DmQ4U9/xcCwzqgofWiWren/UyR/l4GO3pRbIFpt2qE6KVFs+xOcIdlV2mi6k7cG0rRxw93/UMRswC/eVKS2pV84AKYMSOZQyD10/gUf7YMSXPT3FTFkx5d49o4xa8OqJanl6NDwFL+hdA44O3KnSmdB7MA5O0JH+NyYIYsMN943axX9T42IVHJxrFh5VjEG91fhAunykdnGPU8HVHbXJY/SorCUYORt6ZqE7GbxjNczA9t9/M+JnShPluZp7Ksoqy7Jqk7BliBJxdaJKDsbFsbOakCgOrxiDDiLK06Tcx/KcAcLBWhAD6GJBk3magZ1DTIAKlFjcDyEnSCmd4ZmPOq6DhkYgM1js+D7TJ6MncSmb56AzV3XZ04mAIbiqNfReLvMycWwU7TgF8Hc2IhuMrLsdEhtrz54AkZheUElzObl4A5fMYcHmis0RRDArb41S7TPhpKRgFGjPX3e0Fie/3dXphKqI3ic3CzwNweyxB6DExyA9czW4SNy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870340c2-4f3e-4007-90e5-08de546d8a81
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:38.6281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kr5r6pwNzYHDb3mp4MWHlPwL/0QFpWODheXYZ39rQ66hy2gppClEFJifluBgflZ2LmMa4xOJEK21XYDm2qKRgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=69694206 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=k0M0yfqvNG3lIp37doYA:9
X-Proofpoint-GUID: NkmxLmj6HdHU4AmNOmXCQJTqmmmcyqxK
X-Proofpoint-ORIG-GUID: NkmxLmj6HdHU4AmNOmXCQJTqmmmcyqxK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX4M58+8v798ug
 Bjc8iDiasaZIH+uWfR78Xna1GB2rHX/cqvlta4bHaKEtYJCX6RGio+m1A70FGfQe35hRmg++G2P
 Tyy4rxb3k42OUStUmrSytNEQq/A2YINMEgZgYhaML+vBFZbfWdlarR1FgeLlBfJ8PJyGacvpvYm
 jDCftlGC004eyXzMrTwiTUA0qLblmjzNLyx8V+EjlR5sl5dxtIm2TCp1nAnH+RiA9AJGqjBJCfT
 qEN2DRAX7+Ruqr8DNmpRRoF9Ooz0QOPWny9Nk2hE+W8OAGr6QxS58AIp9uiMYnnRT3mEPSsD0mX
 3FloOJvbgfpADvg7yyF9UK5mQ8ai4DTBElWrluhbLL8KSAXl/JulnH0ctIYyoPppJ/QsHdkGOjk
 4IHBaiOdZpM+wOX1NSVESWsPGuu9QFCmqXfO9lgRZjqAPrJy6Gcie/s2XH8AjPp47hUJ/4CkGvB
 5x5TT4h9B5El26UbbUg==
X-Stat-Signature: w6a6ni534eycbisxam6y8wyrmhibo97a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB32618000D
X-Rspam-User: 
X-HE-Tag: 1768505871-398406
X-HE-Meta: U2FsdGVkX1+rBjbl+Si2ZultBB/GdijsLvAflKrOou2+xVbPP0OQIU/GpP54nZsokEtTJ+EDJEHNpOQORsdeXGEmFhumz1aVysqBZNjr67yiJZJHfGBVHNQCGAeNj93lQPQi45/mI5vc5YRoQ4tN5IY/0gRN4Dq+4ahJJCZW0147lYjjUcL/6L0yiifN8x5NTqnUgx2lL9jR613pznoqg60X3TmU3AUhyA7lFbK70hXD43NDD67I2yiGLmTmlgUHrzTLI1yMnq7og6xI4vUNsMeO+QUfDLN6eR0/Wwkg1WNxOOMYgvfZ5zsz7SOaQ9uhDza3Yo51WXNMsKHB/22KOFDzyrJbc1zYxM4NAnAZe5+hZrHKaGydpfmPuuC1Mlzi+zQHamswW/9tEmXI0qLbEj8KCvmia7bcZGnnslOZdTB46T+vqMQNTvn5cBw5up/+WwjlYqUHBnUZ28wIFB5xFb813iZogj8ezdSL1CcsrYReK1W4Tlpvil1AmiUOikr/qE9iqXEOPbBQpV2u+9x80sniyMRvBylwtVEzv5meiKvJpnhazXBmOFgQYpFRv05kZfO5/Lu6NgBAa7o5VCCiDwm7CtoQtX6SfHJcqdLU5FHFEesshHQjQ6jt3oi9oi/UFKJ/dzNilMrHDR9Fw2wv0T34IB5fhltoEngtPxnSMr5TTrgHw8rZn8B0WmOsqX5Yv+p/utNZSG0gaB9pTXlhukyB7SgKwpMOrfJT1mgXI96QfTq/cSfpp2e9PmCZhC6o/T3jA8iHC3MJUDD8IYUJ1LiJKjvisyzJzjiivXBGNMXKU4sN4REm7Mi9vF6kCWn3oZbrIU4kvkxAkzymA7wsi8hbBzXcV2LlcXE3FDm87rV4RtzwTrbLV9dQ5N71cp+OrcZEudythPN5ePHFDwENZTeDzUdkyYttD4zztJXmiJlnscAoa8LkD2/tKntDErrkcJV9R8SIl5gsY/9Qblv
 eKls+2RZ
 OPn81M1ny7W4OHYDg32ISJLEFC9zBWHfU6sRTUbzoDSHL407dPL2TpXmEkNVW/cgpEp1gX+1LeWacbyGjZUaG06mAohWXE60Nl7Lb7GyT6J17+awiadCYRpoX9yGuXMpcoxxwoFtu3fe3O7a05slNvnKuOO5TWFO2JRn2u9TmRcwZfl5JWt4zEvsEbCw+5zCkP2NxlIYtxaCdlP8OHqVkDuyYFzZ7Fd4x9BA1Au3xHJePNtG2WwMlXNVt9soo6Ye10SlM8B/SQ6esWPBX+M/zhj4JEh7xur8eI25nQPCkL+2HVIp8gGeQOzdQhxNRquYguIsqmKw290Mzer3uds0q1+g/695dYuVqWSpZYZ76El+hxV/4xrQrEq8bwYodDUfUxHIqK2KLqlwC+SFsQzwv7szT6Eo9N1VgImpy4s4chFdCwejhO+DOgknsWEKHsnE2TJTKkh76u9+3SI5Hv2J1PN2DBUOutFGzExrUtL/yH7crQXB1kQnAfHBDegp5aI6j5RVoOVWb0laeFGVRJf3PODzfZITSCu8s7FNperw2EE4C9/x6V1aGNZ6e2Xg9XpveS3wk65lSrQUM+QWn2jX01dD9gWNh6289CN39EoucBdZwJHVKKt+DzWZ3kE3aDpQ7QaRca/RGRdqNkQFCigvTtFBf2/+mg4II7plz2NqlUsBgYOlB+iwWaTQCpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Functions do not need to state return at the end, unless skipping
unwind.  These can safely be dropped.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 18d1312523896..70225f7856258 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3271,7 +3271,6 @@ static void mas_spanning_rebalance_loop(struct ma_state *mas,
 	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3688,7 +3687,6 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	mas->node = l_mas.node;
 	mas_wmb_replace(mas, old, height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3749,7 +3747,6 @@ static inline void mas_root_expand(struct ma_state *mas, void *entry)
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	return;
 }
 
 /*
@@ -4021,8 +4018,6 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
 done:
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mas->tree);
-
-	return;
 }
 /*
  * mas_wr_spanning_store() - Create a subtree with the store operation completed
@@ -4185,7 +4180,6 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
-	return;
 }
 
 /*
@@ -4233,8 +4227,6 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 	 */
 	if (!wr_mas->entry || gap)
 		mas_update_gap(mas);
-
-	return;
 }
 
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
@@ -4348,7 +4340,6 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 
 	mas->end = new_end;
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
-	return;
 }
 
 /*
@@ -4407,8 +4398,6 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 	case wr_invalid:
 		MT_BUG_ON(mas->tree, 1);
 	}
-
-	return;
 }
 
 static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
-- 
2.47.3


