Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2924ACA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDBC8E0020; Thu, 28 Aug 2025 10:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697E38E0006; Thu, 28 Aug 2025 10:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5376D8E0020; Thu, 28 Aug 2025 10:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4323B8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:23:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E16001DB8E2
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:23:19 +0000 (UTC)
X-FDA: 83826383718.18.88FE858
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87FF740015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:23:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FskuXtkL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XzGpwHCm;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756390996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCeok8XSF4cCWR8oOIhk3Cm0warKH9PV1M3EsB/QLXs=;
	b=PbxOa5ihkFQIEC4tKtBMeXHVfUbPgaAX/uQ8bZ5WpZ6oXkkJYwzeyCKH4mGiCHPskC+7Ns
	iVgceK8vJNUx391wpxGX/GxLH+k1HqDf6sI1wFoiIqwkcjfMdZgUVa7k28ngTugCDBbB4M
	XS8zHmR46FBTtj2R9/xbClJPkwOJ8sA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FskuXtkL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XzGpwHCm;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756390996; a=rsa-sha256;
	cv=pass;
	b=WkfncNVj/Qiv7v6peieFeCRMoyJcLvTG7BCZVtKb3/Q+Jjc34qPlRxiAACVqNDEnSMoLRu
	si/ZSGgUKxRZdIIYIEPApdE+Hu05avRODphsd70Gf179K/WByjHk/NQLJYpVKgw491G0rH
	OywO9P+LQ+7WdijTdQbYT3B0wzFJ1Rc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENCEP016319;
	Thu, 28 Aug 2025 14:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BCeok8XSF4cCWR8oOI
	hk3Cm0warKH9PV1M3EsB/QLXs=; b=FskuXtkL1iNjtRN7xvTJwp995Djf/A8X5m
	hot+Azlwd0aSL0lReCbxHt3IwvjWteHoz+XYNi4bI9QWClq9dPZuKBHLgS0Q/3zF
	7TKWJ2hr/sLhEJZ9ITftVwEwtGDl744JTh6tLWueAabDt0A06ccwLqsdBE6X1ydI
	KLI3uRckM34dhftS5tVopps3vKKIOwSp8oIviYsk0vq42SUv64TY9nolXYXqMP0M
	HghRvSqNT3fUEcT6iSI7g7d1fX4liB6yRTZa4JweCRp6+GqBJLp35mbQ4IrACIqo
	c7nB6axLgJ//NJMop+96bNft0XcYVvuJ/npLtcqYmwbOP/9+OZgw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8fw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:23:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEDUEQ018987;
	Thu, 28 Aug 2025 14:23:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c21wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:23:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFlY16IvKaXWFplkUUYlTZufl/bF9kkPLrX7iEHqjGl2IXsMxCPwjZicHEcXWFZldb5Fiill/+42IAtv1qlT3sXeqaovrG/EXy8im9F3Ezl910hiVO9oV8E4BNF4CVfol8VD16dXMkEStLTcJycv7D9AK2aIxcixMO0BMG8GJnBsNSnA8lT7DpLwN4Xh7FXqIiQnpHiJNtvq5G57WinM8XHLiXUg4p/Sb1wV+TDEDnScIvfTkTmFFjlc3OIG4dh8Brl83bweBtc4lyey0bFTk4W1UVbk+QZ79PQdh8ZHeRLukxbxFWMyD06n1Pv72xDAxnGFKZ9jshCDGCSbq1Wzkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCeok8XSF4cCWR8oOIhk3Cm0warKH9PV1M3EsB/QLXs=;
 b=sJtDCL+QUrrGQkMHrjUcjiTZOLmiswzxG7EUGo+Pk/x+7/ZJAu1aDFHdRqUYxNJ8GJyZfXARjmB3/GDrm+W2MGe8B1GY7SZLvY0WKz4Qfbar+AXwZ1PWH2R64zUYn5qL/zqsottRymFhjmfcb8gIVdRPKqRY7Oktlmhq4gHp5kTGXfvDVl3iSd+CbgpKvH5x2VpkI0P+X7oea5ADkbzxdr3hXAdQK+4jqEH+y87Exlh+IcodLD8LYvkBaUuimD6jfYKT6d2BfP9CJBbI9FTxdN0GVBO7n5ZldwSbuig1l7TM+ebnDQeekTL9b0YyIrSgRjiXdIOPs7Y0x6TtAqPYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCeok8XSF4cCWR8oOIhk3Cm0warKH9PV1M3EsB/QLXs=;
 b=XzGpwHCmQtvu8WVnhGmjpBXtvLfJv9bhoOCgLi4ZdglJEKuzg014N84bGUf90wY3h3ErGIie26uUnuVNDojsr3alxI7oYvhPTVTRVhz2ocFRmM92f/SC9PHGrQpcgJxBKVFH0unZE1T2Az2OBIraAopIqccKXpb6FTgvJgc5H2E=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7596.namprd10.prod.outlook.com (2603:10b6:806:389::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.18; Thu, 28 Aug
 2025 14:22:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:22:56 +0000
Date: Thu, 28 Aug 2025 15:22:54 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Carlos Llamas <cmllamas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        "open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Message-ID: <b58449cc-022b-497a-97f2-c91776d133dc@lucifer.local>
References: <20250828032653.521314-1-cmllamas@google.com>
 <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
 <53b938ed-dd78-42fa-8cde-f3a938b6f39f@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53b938ed-dd78-42fa-8cde-f3a938b6f39f@suse.cz>
X-ClientProxiedBy: LO4P123CA0202.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: dd113183-6be9-4f54-3cf9-08dde63e623a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q/fpDj6SAPMiZP5LZIXu8tIRPoflgGZKxivsUwnNivKuUdyFCHiePacbiVyV?=
 =?us-ascii?Q?OSHeARWkVDWVW8nBllkfcooyY5/pujGFq/QxY5kyIl3v4ylQUfmbmuPfTxqc?=
 =?us-ascii?Q?Zxznt7TiOQEzwr38lWbfc4uTAwXOr0BscdrpnQE01O1//Fnf2Iay25Epk1gq?=
 =?us-ascii?Q?9+zGkrYtIlB7Ri4SuZrTQqh1ElcCVHUUeEDJTL9hM7+e+PUp1W8tNCvU47Tt?=
 =?us-ascii?Q?8gRZ6/mU31VFvke5BZchQvLApeiOtqin7MrAd7GdjOkfCCQXN+gV4Ut+14mU?=
 =?us-ascii?Q?AMZICrLfnfRKfMO95OECNqNccSmC67rO4Lq98Ap/FPQxLdA9Wt2YnhgkUSoj?=
 =?us-ascii?Q?v0T5GPnxInR+ditFK0DhZ+wJ3CKa3aHubNO+IZvZm/CDNOsba4rYLghfcFAG?=
 =?us-ascii?Q?gOUThHsdP2sS9OOo/0MoXw/93+UsCUr/iyey5f/FWCk6AEY9NjfRxU4Jttol?=
 =?us-ascii?Q?b91T0ZU4fG9J6RUJ8V1JVEDUge2BUjdyOkQoo4oy7F81JP4cGc6oyaFOb6VF?=
 =?us-ascii?Q?tmou/SbRpaC8ls0+w4IiiUXvkHB5RGW1GGxyYU0l4miZ21WqSzm+hiPACyk1?=
 =?us-ascii?Q?zUQK7QIeQcaTwazZrfYog388dLDBJckRay1gEOYBeepK7KZbzPFQNH/JUrV3?=
 =?us-ascii?Q?QlXnn9m9zYhPSqu8U+g5RhMz25jzaMOIfCU18krPcOcXTLSegmjI0dWyEiCK?=
 =?us-ascii?Q?Z+scRFt6BgFM6y23jZhuhu2O4ADcqgwmhd/E0XTuC2hZlTSdO0zKqNxPyF01?=
 =?us-ascii?Q?YawL8XRwytZPAe6tJPp42QZhZ7ROb5Nf/JF/8HSNVJ1XJrgYMVuHhg6gm1SK?=
 =?us-ascii?Q?XJSjRwVgESAq4LvexCRiUQt0dVGdfk0InL7o22xLGFwOs0A7DD1ama6+VoOQ?=
 =?us-ascii?Q?gwK14wyBJy6lxIf/W33Io7n3YEFCsEqRSHZ0HCQSBSmOszJUzIAACNYCVmcl?=
 =?us-ascii?Q?YUzTc0b7KL8VcOSjBqBKZUNBNyyPbQY/ZtFRzVlxEmQylea5iXqox5ylFu3W?=
 =?us-ascii?Q?/d+daqouQKY+E9MQg7GXJpOw5kU/If9J8/UWL/0NN0s+Tb8UOSQ4/b3szhNX?=
 =?us-ascii?Q?IOWtGndmR6/WHGOzBybcHxLfFAq8q3AG756HMb11RlBAz/vjwyYPms0MH7wa?=
 =?us-ascii?Q?gBU8GFSqGCx7V2WlsyLrtdCC6JufQlT34VsfHOtkQWLfO9tBaRYDQjFaz8wJ?=
 =?us-ascii?Q?dhtknNULCXIqR3SBqbS3JI+m3qLLqaclmc4W1DXGwuARO5d4bhrRBuE2eAq3?=
 =?us-ascii?Q?+B4v/x61xmrHAYGyrov/HQYY6pYyIbt9bSScztYim9xVRvOYjwsxdPY0ee/M?=
 =?us-ascii?Q?U5SeDfk2cxgOxV6+WmrDKEHgjw6kkse0P82TYXFI1RpVMuGff2imN2cVhbaT?=
 =?us-ascii?Q?fS81Jy7m3onjSLQqDgaeUBvfBqkIu18JhO8guqrfbe3xxLgUF0JNUyMnRK5g?=
 =?us-ascii?Q?UoI5cNoaOf0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?caWau2f0OhkquUbaB/h45B88KrwvgHGzJjxiVt8sm87nCh5gMCS0Cmnbu7nE?=
 =?us-ascii?Q?WCZ05k2e3B+QPiokkAX2IQylSPJ/d/0OzowYP3D3h9vbOGi4QNYW3EyePRJm?=
 =?us-ascii?Q?Ys5+vurA2obFJDo7ORKgs6kwQRvGLNzbzUi2IuR1dqY1L61vv7ttAxTIo4a3?=
 =?us-ascii?Q?cVGm49v7LI5jEIT7/fzfkcNba+3peJKbrsyoH1sgtIE9f8unaCbkmHSRuxml?=
 =?us-ascii?Q?zuP7/FXZD3Cdpf3bBNr17gThDpc63jW4M5frvqc95JyLFb2vmtHwzmRqfRNg?=
 =?us-ascii?Q?PC0HbTS/T9LXkVBi5nAG8C0bW8wDxEUyMbMfjQoGL8SvbAWoVjx12JD2mubI?=
 =?us-ascii?Q?nlBlOF/t81coMQUNt+s0uel9e6ssGiNsPjL9KykJMXsJjs5PL7mgorer3Dxp?=
 =?us-ascii?Q?qwRLGtVSpwI32gFo9Wvgg7i28jqYVRcXbi8TSyezJr1NO4QuWKfU2/fK6sRr?=
 =?us-ascii?Q?UNUHgM8NWd4zcsu8bpnkObi341izk0M1lSRKiluPhjLlc6xMBlOHFJrCreow?=
 =?us-ascii?Q?qT2086P7t92rJU59ZAX+PCvVfeFLWFPMdNf7TVCGzuhHGJFNXm7PliQzBSB7?=
 =?us-ascii?Q?f3y98HfEwcO415YI33IzQl3qdn97jQCQBYOFZwE4CnwcEhBx+i6lDVO5LNrV?=
 =?us-ascii?Q?nNKBKd/wJVEhGGd3g0SsUMSSk9LbC5D/uJcmxQ5z2TiW7Og7WtSlWP8dJDDQ?=
 =?us-ascii?Q?kSCZ1yYTF7NortV2xiIzAy2cmjzYhfKeHbzR4RkcQA5arb2f2cSMd/0ya5xA?=
 =?us-ascii?Q?Ly5brRkqAnZr1Dk2aTQqEhdUcXcyW5Y2egPA+c5qNmDINyylFbTn6JiczOQr?=
 =?us-ascii?Q?5eokIN/ItCoP3BMOQtk/n7mklPI7BCGsjd4Euz5IYoxhKVLVvx5jAieUJ5wB?=
 =?us-ascii?Q?6pzOGLsaAfD2weuVhlo7wooRe7KAQX/+GMCHD2PE4Y/fXxp6oEe7U+8Z+YvV?=
 =?us-ascii?Q?OIuEbWaZ4wC02yWwX/+bGhf7u2EuQ+FwNyVX9F3t+Sx6LpqKCXLOKMGXyJvW?=
 =?us-ascii?Q?SUAc9otcRXRbGayizISSaez8qNc6fsX5bkkTCYrbI9tDEDDxxJ2GKrTYejx9?=
 =?us-ascii?Q?NjM63wIA12Qb0I9UykqKDpmVePNMIIDOalOmyQFnwTx6fy+ppbBzoljdLzap?=
 =?us-ascii?Q?1CD/jeXwofOJvml9tcaPbmn/4xVXMbQyRIxmbpXBu1N+Yhc8x2AJZs6oUTpg?=
 =?us-ascii?Q?ZUboogobQVkadP1Bcx50aA1bBRf3kYD35dLadL5laI28eq9rpjKXrvfGeH3p?=
 =?us-ascii?Q?rbXmLDytEjYZ0hnckQmHgYatEiz2F4i2fskb7LYib5lFyxnUo4xo4k8BWc9a?=
 =?us-ascii?Q?6/SGS9x4OIiqJyUYUxxlGGyfubEoEwZRmU4ZRHDyCJyE+6sV3MKAExSpQME0?=
 =?us-ascii?Q?vCJzSrDb3DmDD/Y6TcssTg3wwXfEPaiJdMPwuPrfsYPlie8oQDg0mVddvpyl?=
 =?us-ascii?Q?2a1+jI92j+UOLVsxLUVjiJSuxlAvg/qQUk0e0DHked09H1SMBztudGuE/nUU?=
 =?us-ascii?Q?vUgkquXAHLjtnaDtFekmzw01A6sS7Ll0e/gbrKSgDwHyL9jvoo1lQNObZkuv?=
 =?us-ascii?Q?LxAJnH89PAGia2CEHZLz1V2/Xk0688m1OiwEWTXUlI39sBgTgowt+/usmkWe?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gp0h3sQtwgFwe6cvvE3KtLppES+66y/3JIfx0niQ+DcQ/APaV5hTJdDDnMeZxMVnr8r9dfd/cg0lgAsaBbMOaltI9xVhJRzIk26VEQk2m/TzBlGm47F4etOVgy6oSOQ/sDpyEL8ts9hp8H+bbwpseRaSZLe5fuf8wurFAL63IaN3dvNx/8zZyOoMZDs2IXW/rCy7QKot4+EccXu8Hj/T94IG67VA5gKwRfh4KLfrbJnEcS32/sOkSK7wCSE6+besKiBzKHudfkXP961kC5HfTbK4g/BdWdvw4o9LTP0CsVbxvSGReZT+PVkz/upotgYvLg939p53032eJy+Nzn5uzatJIBGgUZVTJtDYSPWJdTOa57v0dP7YfYGAXzesM3orPD0cuarxCeieoAitrVyo/3Q3erhzQtaT40KnEZ0NVNndd2Y/wyh6s3NiTsEhIi/ny6gMiWTOuyIB5arzJH/fcz1nqW6ZYYKzUKx9GHB9VVqFFjRQVxbm15A/Ee3xX+7Fccw6Mu8+CoBhTdno7rrhhHsuSLpbkUOb/9ERIR6ZxczgVlueqgI78wORxHXOQVmsev0FALhZUO1Ye/t1SAzJQKqhsyReWDagkg7x/L0smD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd113183-6be9-4f54-3cf9-08dde63e623a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:22:56.7339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrr0QTE/85di05DJDFLUZb6clB2ET+OFJhocmFJyXwPFNLKawWZ6fZFDe9ojnbGqKqVneUUKH5rmn98+FN4RrV7FH6uO5CsliZGfbNTQJss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7596
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=703 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280120
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX0AL3pQy5VjiZ
 bWsvuUjFnRUMnXxaz2m6P6ljIjC1P8Dam8JIu0EX8a5HsA5EJKttpCkTi1ez916zYm7a/VqT8Dh
 tPLshFxtc1uvH42ovvO/b1VknVs9Z14lq24S4xBZW8SG0JlC7L15HCgAEMUWC2OI+ioOCkd/8Qp
 9XxMn1Pz2if8xOMSuUg6n4QoE1cExPXePdbF3TgcqZsNfSBk8TBdc8b800n8NESp4egMv1Lc6oC
 in8/l60XD0K1bcKASMZebBdMkxG6GNPm+UcxFt1qpkEbZaMlTHo9TCa+vOyxJ5l/U8FwjPd2EEh
 Ls/4NmUTV6gaqPRw/mAELKnGUQHBtV5PSIjE65hQyQTNt3FRGGE9ZyCiL1Y777kbiwUb76bZIfM
 T9A+kEW4
X-Proofpoint-ORIG-GUID: Tf3IbjlTKoAWNvGOuZe1rU7gTS9je8aE
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b06651 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=XW1DHv_aKtVuS41FjzMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Tf3IbjlTKoAWNvGOuZe1rU7gTS9je8aE
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87FF740015
X-Stat-Signature: ag7znykg5surkukiwahzxfycxj3r4b8f
X-Rspam-User: 
X-HE-Tag: 1756390996-166031
X-HE-Meta: U2FsdGVkX19e22VDdOcYZfO+s92cwlCkVpFXlpsZ6jDRXrdJqhSWDa8zEXXa0uGGSSs/CvcUzGOCE0/Tjzx+YZmjBo97wc8lNo26tY0iDOVZPBABYQ+RCbpbnPQ8pStJDr/Y2Z0lX97b2snbQnGh7773zKrv85cL06jgCmYY5UAfTqgBm6iMYuHwG0p0T6Y6qyxfbH49STgtKCuM/uYxZ+FzbCtPbxvpZBGOIvOiklVeN2I6X/s0fJ9ngLsCRNTsYTovLRFXI5PYQpw3w+tnSmCOwQn/+xFf2fI9bOMk8RUfr4RzRaDv7G2ljsEQGs0ACW2qR5JPMTXXDV8cIt9y9qanCjDgVDmeHWfivibsEzZeOCDS1FkNzv2eRlb4Un6N1auJgtXwMRJUw/ntdSMXV4ixRXqpQJIVbL/mI2AHQIgCt0/OPp4ZgQZQYvuG4CGPjJQA/Ctazkmn8itrC1pPBa867o8BOnVeA98IXoQh5VZKivaMoqz05FyrUYWEIMJOcnaBfC3Tl3ybPf7g6LBUYTWPxoMXpIDWYdo0YXOnrMkK/JuqxvxD6ap3xk2ooLUwptxIVsolg6tixyD34xujyDvE6hGv7VNdKH4Me4gRV5v7Qb1p+w6jEDbdYycY4cZrO2k5wnzR8kL4nKTOeTVOiHF/1P/iGSoPvyY1A+2JFvScR4DUnNqPPar92OS5pbdK2U/wavwlKGg4lrbzSuu47KH81Xvm2tQ2WmZANbFPkSuyGOUQsJknS5iFmvZBL+4OS/XPGcyQPvFA9D05ck/tQsovvk0L1KC4SmDpPPecysgCpYmhZ8C/mM1bvcp76gbYIrT8ADBB3Yb1JMmwo2HSlL3VfAFtLvqTAIAps+PYVXYRPcMsAMyUsBY4PR+pvJgW+HyjMKxmYHOIeWl1O5eLuQ70MWFz+RTVyDM0eVi+EymHWfq56omrpcrJOLm7cnKub9HfJx1vxlvH/4tj+i2
 YqVnDOev
 oSU/bTvIhv9v4WlV4xwO4uoT9+B3Yq+iOn9L4MFxP7SdgOBOrQxCjGj3ltJ7grlf/gBNs9pfGpjkxrv0h7CAyZWHa+MJvXZ7amuv2o2MTEB/aTxIhXT3zpZUBxXvaaBC2R/AqtVRyG+9expvk1MonRy4dap5NpjkjXDKYq9gANcESMQbBU9gTDrAYGK8B6b7vqcUmo2qguvDwTyBLggvKPirTOkF/zOnRICdBJMYbsjk8Q919O6OCIGRPW4JDnxvbrUmFOFQCy/Su6H5lwsf3FLOou/vl9p7fLADuetQuKhkCDVqCKY30WcchdBSrHjLyYCvdagUqkZoffiQsTsx2OtTq4XoY2XWmIE6bS3PRuX8a+mqO24C0DAqCPqO7DQbu8ddFmOMfJWdyZN6E65JQhkLIj7V+aeUh7ZO6bo6CylNOKHEMGO4P3GHAQv//UoKQ6oU7N2xhs4/Qab6LveS/bnAvnhfbyR2jccjFX9PltUA8dxx/0WMLHJ3hIpQvNSnADa4UfuI/FIBOztkmJoqMZXoJHpY0izyF+xZwWhEh5axaIetdTWCn2lfDw2cqw21s6PuLdZayB7YzpcgqQlRipVLQByUWMfTnU2fAO4mdoAqxOrFUwPfnkgBSBlmqO/f8zZx82fVkzr8+ZZV7ZRC29wcdurJOo7Tup0vMcf388LBUbdWVWj0yF1Zo7194bv2ls9lXGGixeidbjx1O8EDvdKdQqwsyvIhLYXx0SoPUOZbCTKSfs+7TDlvwdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 04:21:05PM +0200, Vlastimil Babka wrote:
> On 8/28/25 07:38, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 03:26:52AM +0000, Carlos Llamas wrote:
> >> Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
> >> checks") moved the sanity check for vrm->new_addr from mremap_to() to
> >> check_mremap_params().
> >>
> >> However, this caused a regression as vrm->new_addr is now checked even
> >> when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
> >> case, vrm->new_addr can be garbage and create unexpected failures.
> >
> > Yikes, sorry my mistake.
> >
> >>
> >> Fix this by moving the new_addr check after the vrm_implies_new_addr()
> >> guard. This ensures that the new_addr is only checked when the user has
> >> specified one explicitly.
> >>
> >> Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
> >> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> >
> > You need a Cc: Stable.
>
> No need as the commit being fixed is from 6.17-rc1?
> But it's better to use "[PATCH mm-hotfixes]" to make sure it goes to 6.17
> and not the next merge window.
>

Ah haha really? I'm losing track of my patches.

Yeah sure as per Vlasta then Carlos :)

