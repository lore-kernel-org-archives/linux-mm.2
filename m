Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECD3C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43496B00AC; Wed, 21 Jan 2026 14:15:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7486B00AD; Wed, 21 Jan 2026 14:15:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49AC6B00AE; Wed, 21 Jan 2026 14:15:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0DB96B00AC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:15:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 560CABD4F8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:15:28 +0000 (UTC)
X-FDA: 84356924736.29.3712FE1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id CF1F41C0017
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:15:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FaRN+WSr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lXNL78SZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769022925; a=rsa-sha256;
	cv=pass;
	b=hhI+oOP440nAsdGBFdnbaqgEHZI5tzEr24+fgUzwrzU5zn8ezIrDO8La+tiCi1P0y8FooA
	1vcBs2lizi6iq3ufktX6NYcLNyHxv9M94NaUKtpN1bUzVCD7e4zHhYDt2iEWdqysNrjlXH
	ysyhfczp/X+KKkNTn0poSldVUmyr6Ck=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FaRN+WSr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lXNL78SZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769022925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxjehauT+wEH2ggsK71zICvWbtqe9sdWhYgGBySbVzM=;
	b=8NUPz/uA9wz/ZJ94pRYPfuRlcsTVhXZePOY50UXUf1mdhCXHWp0clSJHVOjYGu7xQwYsF+
	3ZUYwWfu4tnBg0RLjlGjU5dAb/Zy8ZOe4TQXZnubmlWbmS/xAqjnK/sv6iS7y4fyLUneEa
	jUHsvsGYzg3LIF3mQZrF5OdmpbYUn5k=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDugvM3029196;
	Wed, 21 Jan 2026 16:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CxjehauT+wEH2ggsK71zICvWbtqe9sdWhYgGBySbVzM=; b=
	FaRN+WSrlm/L6fCgCgWgWWauDGRpIGHa+nG5ZepBfTFyor5pWmYAzDrPuJdZs170
	vGn5QVw4YW7hy0dpVAoy5sQgf3Rp+2SZ3qgU8SGJcOzvOXvywg3xsuB1BDe0JUXJ
	8RcqKXGdEBgMZNA/FCyknYg7yaQbVULAnVO/yHEGNr8ZX0qE1rMkU59X2+R/uXpr
	K26ednf36ncslYK4w4+6WO+Smq555CMMae0Eav/wZdYDakl6FikDauG5JjRHH5ev
	znQRdcmUHYbyzeXG7rgmjYNPWsyHsKR/dQC2zkVpCNLRQsOmkfVwUlyZdO5kzPp8
	TDoEMObIiBTQIr8XOOnQNg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx8p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGqusM032182;
	Wed, 21 Jan 2026 16:57:40 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfan5d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyKfHfTruMix00wLAgFAwuz6kH6qR5X2jAuGk93uicu+Ac9ebDGyxkmLXDMUf1+DctRLbHzMmPqGf/wzb9/mTfVj28hQG6fOCNyVUpi/dwShzDn8qrxVVj7L6rcpR8+lBjzlsQf1sPAiqIwfKm6EK6enzu4Dy8tvZUcTvPaTS68n6s24ptGnIk87Z1z8HKUxfrl+8ekoGWcmXdOaRPXZbE2NIJDRs9R4+vzYJc7n27VirnsZrS97eXeJmAt07tE0KlVAUXzvvqMPFqbv788z33FWrmFuOuilq1BuAGguoFvX/sGbjrDO8y2e0FtJUu0fpw3skI2IKHZaLmn1CEWmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxjehauT+wEH2ggsK71zICvWbtqe9sdWhYgGBySbVzM=;
 b=FhaXzkgLj+B7yHrq/I95nSdOuEvuxbcjfnHuGyil1rAaqirNzV52h3AhuZspx8pM/c5ajQ++tMMLT939gpHjok0Gwg5A+jZ51t8F6dJRTuLRdQ+HNPNIl2z9I9hwbc9yRtNJNJWD93UbUc6LNA4WrE2R3AU4t2IR8K0aDiXJUOcnP30d0uTaIeEII0bimSi8ZB7QboB3CyRCKcT2BX1xHO+4PVybM8MF6WhhjSxo453g4WCAQVBjJHmOqKwYWn9kYmNTZjSDTZ8naQPa/j6sOFbRpis3HIlPuOugstdY7XU2amZwKpXasLTVsBOg/pUfFZmJAEhhe1/8ofyIA503jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxjehauT+wEH2ggsK71zICvWbtqe9sdWhYgGBySbVzM=;
 b=lXNL78SZvsYDLJSdXjNT5OsSyuaAS0zJu/0kynnF+iZii3pqYAttGVLfjcoimDK5h0jGRr3goMnh5IzRzuCxrnsUmnR6307CDiIxBpKITzNklNV1qr1WVxf/ifto3OyqJU7iMbRX76CVnKhFkaicD//GvfFkgssRvPXQ6BQzLyY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:36 +0000
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
Subject: [PATCH v2 24/29] maple_tree: Add cp_converged() helper
Date: Wed, 21 Jan 2026 11:45:21 -0500
Message-ID: <20260121164526.2093265-25-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: c804cfee-e9ad-4dce-1097-08de590e2dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?Yd5FXhcqYpwpH07NbWVnRQd4S9U/8xfIU030ofbE9TaMp7wUmcfkVu935xST?=
 =?us-ascii?Q?6oz94jLeoJIEm1+vf9TKrebHDxWj/wGQEvq1vJtEZGdtZqbWL/bUOabVUwLK?=
 =?us-ascii?Q?L+UBDylvpx9KVUG0OrSiMU525YIMGDE2p10lzUsVt+jkOloa1kTl5LeZwb1s?=
 =?us-ascii?Q?vZrZGqRUw5P0jP/P0D2383Y+6FOGekdAJoIpD7zUnUt4gwWvZKy/vlIBm/0G?=
 =?us-ascii?Q?MyCt00pzTDO1wPrkIOuUm2luf0HT5LHKfMoZHf+nBONQZ2LcT7zdrfsl/rCg?=
 =?us-ascii?Q?v6JhkKsrOVLyEaNErcRNfqszLxu1/+uo2FNOTnigeZPEHLvZFgj3/9QgAqHe?=
 =?us-ascii?Q?s7Zitzdxx5vxRQuEXRnES8p5BusJ9uDYhFAkh/A5vRE7uM7B06ez9otroMYV?=
 =?us-ascii?Q?7s580rc33SHc3Ymrf+A9bKtEgYweJ9Ec5vW9ghgQpNAQLMFEU6QuIWc2W/gD?=
 =?us-ascii?Q?B4JYwe1GLfx1OWc0DoM7ZbKrDbenqwQHvffXWnQbRmECOwR8V18PNVYkay6m?=
 =?us-ascii?Q?7F4j6uDxDp8SfbsPHbyt+Zy12CrNoP9Jd9Bo9UthpwbuwC2ek421usa2v8q7?=
 =?us-ascii?Q?V4r8JX8yGOBnY1CNKxQqg8UTVH9pJ29cqRMB71cpmuBWvqG9TCJjhT/XQowf?=
 =?us-ascii?Q?2d+ExYxCjAICGFpQDpHNalQlmjdVrInfyHJg/hqtJbgfhf9vtne3SJCrHwcc?=
 =?us-ascii?Q?Ngou6OQBeKTX/LYrDICEJCholglU66upOV7wnpZ0lcQKzNwsac70/oRDhr8B?=
 =?us-ascii?Q?3p8EaaRKyjCelFEthzsfEbC2JDull8+EZG7JC7GWRnbr+0uKkbumLE+Igixb?=
 =?us-ascii?Q?JvsHTkZImBJIWYvG4yoZoFR9AVhDFa/LFgb3XDQqykXOzujoAAZiWsxjhRlx?=
 =?us-ascii?Q?Pmk2F9efBmT0jTzIeENfAm1toL805wN9seYd3S7CNRyncUlMn55hCt/rCQLE?=
 =?us-ascii?Q?V25luU4Lx10TYMHxvLcxcy68ETfq6oAZLlUL8IoGcPAepOFxlIlyiC7zD0Oy?=
 =?us-ascii?Q?XSWDVTeBZB2JpVjAXdnTlZJu2VtuY74XcGJI3sOKpyMZk2plYZ7VNg8g8nf2?=
 =?us-ascii?Q?f4FeLrvDV5QI3l0dkn8nSHh9agQOqdl7u044wSgTaUbJbiBhpCvImsbV/bFT?=
 =?us-ascii?Q?CEOTjt9wul+A0+sBvGcI+b7HUb8TzUpwsrfkyOTiTNQzNJ6+KUBSpRmsdNo0?=
 =?us-ascii?Q?j+9s/+FaFkzK3R0juSIJ3qLE7qBnrbqXjnpYQOVBA0nb0C810F2c/lKlYJph?=
 =?us-ascii?Q?Pntn0KATBT6PrZAFoxLgbBDaaOB1eZLYD2MuFQ13pZvkJ5io2FH1UYlO8nEw?=
 =?us-ascii?Q?gS6LYb3AurzYSxb2X2n38nz3HnPpZRPNVKJYzdUHG0kltGnEJl8uJ8coWR+i?=
 =?us-ascii?Q?h7N1iwFMfULYacAp2oKHWfiDomqtkvajOl9VVYipQMEreijeNF+16Zy/jqkj?=
 =?us-ascii?Q?QE2flK3RCLqs7qFrE6wo2iYIwAx8aT06moN3MoVRmJy8/fL4pVV+kmBoztRk?=
 =?us-ascii?Q?lGMDatRfLv4HflOE/LVqk5aB+784ndPIWc9IkNZOgUARtOM8E8doftAXDIrn?=
 =?us-ascii?Q?S4158KP0P2KUjQVeXqo=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bUJikHf4HRUt3DmeI8/kxOb7z+wZMuSmdu/rv9waBJqgpUDjiQRDDWm7zyHj?=
 =?us-ascii?Q?GmhnwVSWBzxzD/38oxPRzliQqbczxnsYZGb2rKvEzlhyV/v4t83N3wVJysvq?=
 =?us-ascii?Q?jv34t3jaTb4nTyyfW0LuBrjnfyN5MsyHZhZKrOwJqQ6dUvnL/GsmNsiz4pKB?=
 =?us-ascii?Q?NGorNrOBwfJ2eyGhoNyvi2HJkm7Cq7JLVM8Tm4cIIU9rQ2elvvG9FzDTQlLC?=
 =?us-ascii?Q?1W+u7/LfGg2wHX15zqqzXBiXGrFfitndtMtCKU413AzCl3iMSePvFvkVEc8I?=
 =?us-ascii?Q?nS3jAxNg9wgAMyg2nINSTE4sUY2kKiEH8pKv+6zksWpDkpVLKpLAnEXjRD4Y?=
 =?us-ascii?Q?H7+Ba7TGawEpr8Z93ofGhQ6j/qCfgsT8XYPHwvVxEUYp4dbX0vvNg6tNuS55?=
 =?us-ascii?Q?Dz3doYPzsUsAKMxd3F7bBLz2Q+jxEfkFCd1RNUTiJVyNC/v9qPkk2fO+maZw?=
 =?us-ascii?Q?jQgBaOaMGHQ1GucbVhy1YmNNk2364gygOkBLMXAXZvtNbwymSbM8UixUYxRX?=
 =?us-ascii?Q?UNCLlTfqPmnIB5N5gE6oHcD0fMjWhlCDk1ZAHu7qlBny58EaZjTWTOcc/6WN?=
 =?us-ascii?Q?2u8GDj9Mswjmh9GCbVQG2JXBTaZgZxulfpvl63UQzNIa+PZ84EHo14zdsSPl?=
 =?us-ascii?Q?Sa4jXS6cFTad+TJrgCFZaM98kZo5BNX4iV/LHzR4loqYxsyD3orvncwQPo1E?=
 =?us-ascii?Q?huR0DvW/K8mN8FqZ8N1qcb6Vp3ZuFKSrTIR3CmsWdHiMo77W8qlrrhVyIJ/z?=
 =?us-ascii?Q?Lx56/2GLtLRejP+OMBKubnU+/VsOsznodFxC976zKJBYF9tfJsItVuPzpXBi?=
 =?us-ascii?Q?lgBII1V6MXJjAWuQNs2qgMry7ecLggRhvbmJzijDBQ/XBgkltOJSASbCr6DR?=
 =?us-ascii?Q?ARmlBRgn1wNpx9aIUGJq23haBI0KEcqYxEF5jnGpZwMdiqgbysbENpf5xE6z?=
 =?us-ascii?Q?tDXT8MdHAKkzw9W0GdFGFmpFoGZU12X8BQkCaD7WTkp0gIzr36AOQOOm8YwP?=
 =?us-ascii?Q?fdYSjbgrtyQJVk+AHTTTx0dJFKgsO1Soz28ZbzaoL6g8djiLTUU8vO7OJYoa?=
 =?us-ascii?Q?V/bZ5DOeNowZswn8rlXZQSX/BVhInT43BYV0kg62BR3b+yHW0Ok4S7CGA1Xr?=
 =?us-ascii?Q?DcJoauGAY3WhGwYAi/efsU9Mn5xA5hACjoerbiIkUryIj6dvhfu/pHCa/Q+k?=
 =?us-ascii?Q?IaDs17xVavF0dslyhX8ftt2jtyXTG31Cu7ZrcW+igdUAO9DHyzZRqg+FqC3l?=
 =?us-ascii?Q?fn847/GU5tplrka/AX1UdW3SkhT74643ZubJO8Zf40GRFBrW6qACG5cx/3G+?=
 =?us-ascii?Q?r11TURPzkL61EwNG4OgZ6PP13dfrX5QY2lUzWiyKehtS5TjRoVCaUNQAFADW?=
 =?us-ascii?Q?c5c8AosB4X0yU0R6R+Mf4prYrnUIzh1AJKSS4PubdD5S/mrr1jeWuG8FhtOC?=
 =?us-ascii?Q?vtq1GTSfTzgRUUfWxmK20+B3bG0HTh9Zv6BgvoEx2wTMK/RwIqhZd6yCc+aI?=
 =?us-ascii?Q?IN5MzQSSu7jm/VFK4gdA3qtIRys4Ru5eRjMeRfzz5VhoJLagY9DuOtbO0Yvv?=
 =?us-ascii?Q?ZQWTlLuxBTD9shs/96qEcl7ujMvfBlYS5q00Xnjl81q4iyJ9blA3hHHak47Y?=
 =?us-ascii?Q?uNkfDcNTVrtRV3UPGcIrMDvXNrOy9MRod5aRBCnommHKmQi+qJ8QWIl0RTnP?=
 =?us-ascii?Q?ZfqDyv14SPgczLzDj6gFhMhyMGL1uURJGMpcs88FTDl8vSh9UgVHEx3AeYWB?=
 =?us-ascii?Q?G88dQ070UQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 rUOzncXSePImgGliIbxO0humKsDeYtUYaYdeLb/xissUthtyii6BekCSgdI9hDlCRtb5hQxlwXpEgz4eHtSS3RlES0vv4ZMoGqYlyXPfrVWe7v1rlvVv3nXhTLMgwSrasdzyZOFEdxFrqmMJ4fHSMNdFhzmrk/FuASEcNRSTtxZOWd9BWL+cb14ENJzUJc2W3WJWVa+nTRYOLHu1p6bUXboZh/D7q/O4WDIunQLNxEXQ9MfGHc9K5UrfxWGekt+G9vfR10bzSAfWoC81jPb9Lxm51z+hrVotCx3RteA9ZRAdvgjv+qhtQTKvgSwpJa5Di0jq0WxZebLx1jxJ3aQE1catuteWa1U1AbO+aFWZhF4U5VzBgFwQLyOSE0k3xJCzgJzwIXFFH5OGY8sqo2W0a9Z9CTQYeNt03Qffw0MB2PXj6ZFb9BWkyvIY1ma7BuMt0DrbPpLhOMs7JhAvaVxjwKISo/pRoDug/nw5fPwxqNUed9mp6CavnribZOa+MoFb6ZNK2eljuIMRtfZP6oT81Ec7rrkQsl7jcUmLWY2emrAiqePaP6hYkxBHm83SIurlCvXUYTrrLv5rWXZjfOVPE0O3ZXiD+tyJhmQ9vZE83Vs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c804cfee-e9ad-4dce-1097-08de590e2dd9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:36.7640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17gqcwMgXTrG2JGr1adOZyil0cMjmKUDUNIDPE8IVoQqlmPGVoVLWDr7py0rZayiWq37IAfmjxyT3/dB9J9Ydw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69710585 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=MoTMpwtd16bSVnSR3GwA:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: k_uyOiKq1_KFZ1ZRBvXlrhNuotqj3P5g
X-Proofpoint-ORIG-GUID: k_uyOiKq1_KFZ1ZRBvXlrhNuotqj3P5g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX3TZFIfxVRxix
 aqjpKwIroLV5UxnBgWzxdLEjzYS+68l5wNpckNeeyhSuEtaXOdly/E6/LROMuUgXf9EY4CFDkLc
 2JJ0Q2UZjEjM74wy8AWNKN0jbblFNz97Lnjkhd9pLcgO5CfEsj0xRmQpJIeAnN7F5WKKk135EEX
 JPWgOBwnE4h3KGzLbQDPELxd43ZyhA/jhQcxzEKOTeQQfVDviX6+Z07k0X4uFSJmd2cmpPD/wuH
 DjWNjlpCzvGJI1YA7s1+SAjbSyb5YSjNT6gn1K9QQZiHhAOfi4YlKDI5hYz7b4IjZstvOijODYF
 jHfLR8qV8oymnGz41Bplws1JGvSxe4eblgvDJvzGbjV3Wvyt4iT58NJqG06ozq+lAzvivwzMY63
 5n2j5gtH/UVkstCpCnEblTpIsYSS5qpXcSfDzMq41iWawLkw9Nzf0nq6TEDvRYO25onB4a93WPy
 KStLZo5Mo3z3IuWaUo0KYeLzT/1/n4ASEvfT8bD4=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CF1F41C0017
X-Stat-Signature: kjdoa4rsawyg4fo4id5wzet8wigf4fu1
X-HE-Tag: 1769022924-534131
X-HE-Meta: U2FsdGVkX19hnHw67rx5+fv/37pVNqewVwXyZN8dVyWyQa93RfpCGhhiXKMcCO3ulgpZ0VjiQj32dkh8/5bAQ3F97IoaPPPgLULalqPeBnKDhIS7ZPFiZ5LOIv2XxIO8XcG84ZK5fvHobvucpBIjJjxQtMJuv7j3i8YACbOqgV4R70y6xid3BE6LultjnLs4rAYgHrGJ2ddurgVvnJx4QYxGTzvveU4FcBsF8+5z+9KbjgxXfFQpQ/CPDOo677Tirmac1WURlhVuabGfB0AELeGnoHrNQ1V6lMp+aBiY3QvPJB+hyXqEzMMf0RDPbol2YxFKuuBASDEfmkarNXwF7JzfXpFFTlezI77odpWMd7EvZWzl/tOnw3+oa+cQRBG7OEdg9Ky99HZ13WusvzRFgyn1lrgHMXIYJ4YjndvUf8nOaZvZCXwkebYR3sG2WjgbWlqhTmwmyvDZ8cOmrdnQqQ901kK3GnZFa1HA+crFmqVnVUKbKdOe5nHc7TX34i8JW2Fdw+sOmqdqIueVmVSykCT3KY3tSqSO8OnUAwyNFX3FOFIAYnvw0LVNHH6Q/9hsUpXh+nyXiBFbOavYkt1h0VNya0Maa58vbhnN6zXUU2AkFq/4M4yViEeyid4hfQ24SvgrpycEt75fUpGfQCctOV1q/d8bFkPghCA+Mj7QZWTrv+l15oy/CQEupOtvhlC/UFFfPvD3T1hwcUrSyjN8ivjcy6G/D747N7S2VRT+aOkGRhReFxTjHzARPp17TSZlPkcdS4L4+va1+SLb44u1uOWCj5ftsJNU6Um0r3M3HNVXoczeY95kNFDb+vMbElPd3oYwntfuRIbBxzhnphy8KEtmHYsff9ko/ml+uieBq1Y1fN/tIwBGgQY6gCYijxdfvb/NSTQVtNh6WVWBUjJSTMdij+lDSZFR7LqWx7qYTZpSIz5z+ViSLieFkMkY+oDw8zP9gaQFzwpP0En330W
 8dT21twB
 n76c3I/l8KWycbt+gJiVDVCjd/W2Kia6THeNttBBKknI9ulUSLlu3iAA0LSzMvTCj2o20bYLFScuN7nUJZi2hiNsa+UeesCFxbG7PATSaoZcYkSq5fJvkDCQpWZqBNKXr/og4j9Lj8dBOwiJZuof6I5H4uU8R5iBfN8qdDGLdZatGJPF7IdnB+UT5nfLP6lL4b3d9nvoIUk0VJxzfY1Gk/2LZb5Cvzreg4PdsRkC88j3JJBuNDJhG2UzucbX+yNgOF71Vx90H/EQmAtiEFTfl8zAz3Rg/NSOOfYoFMUgPWW8Q+F8x5uVZNb8lgd677M9vP8G9PXrlJRqwBPZq00X+js+kt23al8W7UXUrzramang3KORvqJPLS5tE59aDDYHKpoe9gwBHrFLb2u4NnVLVeG0adotUTLTs7vYmSOlc6LKfye5V/m7wr7mrAAMN9id4WDVDHQbbg35LZyYHZOFX5iF7T0fo7hKl3i2Z0hjhTGqn/no1L+6hKCxqnkyyq8MobbyIsmK6Cm0uaRYk7pXtH2Ytl832C7zgfpchyn+4suzVb2rKCqIX3ie4n618rXw6e02SosFlconbIFT3R2Ag58FZANL1/0LqhbRgUancaXpLI+wOfRN3gBzZmeka8OyWbV2UrDaMbzpHaCNYaszmciaRuaoBkmu5JMzUm/tjdJxdjxA1Id3xFwCJbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the maple copy node converges into a single entry, then certain
operations can stop ascending the tree.

This is used more later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 22f52a9b26a9e..191b855575650 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3485,6 +3485,16 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 	return true;
 }
 
+static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
+				struct ma_state *sib)
+{
+	if (cp->d_count != 1 || sib->end)
+		return false;
+
+	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3567,10 +3577,8 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp->d_count == 1 && !sib->end) {
-		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	if (cp_converged(cp, mas, sib))
 		return false;
-	}
 
 	cp->height++;
 	copy_tree_location(parent, mas);
-- 
2.47.3


