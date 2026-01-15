Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AE2D4661D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC236B00E9; Thu, 15 Jan 2026 14:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F806B00EB; Thu, 15 Jan 2026 14:38:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92ED76B00EC; Thu, 15 Jan 2026 14:38:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 680636B00E9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3837E58CF0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:02 +0000 (UTC)
X-FDA: 84335208804.19.2EEBEC4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id D27E240007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JHgXQD13;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y1WecIKr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505878; a=rsa-sha256;
	cv=pass;
	b=CT3NoRH3OwL0hdmyR8FM8XdmRjNJ0xSh0dhw4JDSPxmzzywRe7gRCg6A5sRqvX+6dUE3k5
	2mIDgtCP/JrhrtF5G2AoDLoLt7k39a8IbZ5+zw+exuHprrTCk4HnHzaw7zu0Pg3rmMz9Ub
	t7D4RLLSKI0uHwUIJ2qqYN2Gmo17Yx4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JHgXQD13;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y1WecIKr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IilarVVpauxeno8EofxbrkiLGp+BwROD3y8GtUgzkrE=;
	b=poVdtMZ+UvABFKbIRjr48efoa5h0/ceS9ZYWLIf5cQNaHeW07UIMMzvPsGma8kem8Cd7oq
	XqDUhFq07Wee9U0rfItLmrenWESS1JYGlnLiQ1VvogEi+IgVkYYDdBmPm6xKDrcFffCI5Q
	Sq6zKrUvuAUtAMUBWL1ELgoc3KOyzmc=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEfZUP1940184;
	Thu, 15 Jan 2026 19:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IilarVVpauxeno8EofxbrkiLGp+BwROD3y8GtUgzkrE=; b=
	JHgXQD13aXBTKL+dBHLbmG7D3/yfQ/qE86qQsPt4YcCIXtb1fbNc98Ple+ztRXIE
	bnzeiegOoG5zDRHKo7XrK203QGj9YUUp8EqUVCF0vMRVBSvOxzAVbgMlLs7K81wm
	Y58wBYbYoEhm2k4xHaPnLer5ycz+hLSf+YmtWrvxShRJrDLV1mklV6K1HSpJsapt
	xeJCSsNUzXesSb99ea7EKXDwXppXUASS/hOVkHydoelkAEC0tm1ZctirVH9WoPL0
	XNlkPMh7JVLbYI0+ggxMQbiENmPZWlmjTfWhlkTY7P9ipb+S15fSV9CA7W8mwbpR
	VdBpIrrp0vhqN7Ic3ELKsA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3bwcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHp2Jn033952;
	Thu, 15 Jan 2026 19:37:51 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bqnsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N26wCmNkwD7QVlT5sthZtka5KU4S/8T6AhECcEzbs2T2ayWjjiSRE6N9SUCneYJCNLK/UIlx97SfmOsMN4nC/YTS0Sev0l4cTSLJiRy9qdM1vS45UVAgkSQ9mriPh8KSoGo4rNt1ipVQlLdbc1w+Pgya5uFhD4x2OUXB/22O1IDn46snNUSgCQLbhb3b9PPg8rqUvj6QdDbUWdeUU37OEOA6Jf0B3cxXpPduX8P6diuZeJ6uYczg+QgDN4P72fNE7DzT2THkO1fpbyOyfmTwELYULPGjOwL2U+vX60kXYdz2+G5e2CX9lT1BLX/CMDAPkv6Ay68orIyXwbuFk7vroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IilarVVpauxeno8EofxbrkiLGp+BwROD3y8GtUgzkrE=;
 b=uu2VThrLDm1M+Q7ENr6TNijCxHUeahWvw6LbQYOAt13C5t8E9mzMBgTttLZ4HN+1mqX6VUAQJ/FHHjAINs0SMx0WEfl/WNS2W74NXhqQd4k2XINOkHI4OmkZpN8LDAHIz2DQ/AGoNdSPIdpWnF4F6Zuo5vmP+D+TIechOQaXqVl+iqajnBKNio7SIofxBEILEShbX3IflTVilzk96M4uxUaZ/oXY+LHmM3c3Hc1pZvNGU9jGDAhiuRgPuuYPki9YMWOcTOfb4q8Hl6UyVXhZWVk3MtXl61AU9xhOrxStJ55syh/oHlpfrF0c/Ptz4SQYmzY4WEIc2sdxYQboAiZueg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IilarVVpauxeno8EofxbrkiLGp+BwROD3y8GtUgzkrE=;
 b=y1WecIKrlM0sleo+1Hjgr6i++vxGR2L+MOBYPPpJXCw6qSDbWhoznBgYgY8TUYNcGVKWDN1FVvqqQpITQxNRUWdGG5H1vm+f1MUaPN0/E9sIvTa2+QVXIViDRsLSJM1ipWUHMFL+mZ5Lts+WJfv8DMDCuSDesczqMmJeyS+IMdo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:37:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:48 +0000
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
Subject: [PATCH 22/28] maple_tree: Add copy_tree_location() helper
Date: Thu, 15 Jan 2026 14:36:41 -0500
Message-ID: <20260115193647.1695937-23-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0111.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd2fe3c-6d81-4c86-94a4-08de546d901b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eEWkUq9hvrfasKlfeq2dK3+NM2Qlb/151MpyocFUO50YN6mNEtcVGXfYpIiz?=
 =?us-ascii?Q?SJAsMD5nV7j48eMGaMFKlEs/A55BENkEu4jSw2nWRLgEsOXjTrXlSfW02CE8?=
 =?us-ascii?Q?MONiH+F6+EayGOuv1L6OKp3gXKSlGzjoIxDfxs6q+vg2glKZwayKWwM+IEo5?=
 =?us-ascii?Q?u0Gm7KpnoMiKSNNchxIg1Ju9zZdHJEieIInEJWBzpPb09KUfk/MNjOZNKgvE?=
 =?us-ascii?Q?4tBF9y3y5eAZ+YYuHhmZ6Kuzjrc/vCXzQMMApncShpXbmiBIGslNQ6JAmRgJ?=
 =?us-ascii?Q?FusoWZ8RlRjZ2y2BPzXmQshsQ6nn5xcl+l3yINO2hzHloJfAyRnjZysPZgAS?=
 =?us-ascii?Q?o/onK5CK/LM9D4qcfP+UB2vwYiurZF4LFpQF75MrSbXlhmIbRAHT+ubctUn/?=
 =?us-ascii?Q?k6nsaKSNtnhw7oGyFzSf1gsakxYPY8k+mGtDvyHHarcJBivaPhrMxX9ESDIv?=
 =?us-ascii?Q?OMr06oD4fa9Gyyph9fdpZzDfY/WOcC2X9cAUnhKVoob6HWX2CAy8zzt/ukq/?=
 =?us-ascii?Q?bu7qNesTKVhw8Xxi/lkKlduNW6lk5lM8xNkUs5MDT5boQMJmgRtZw8TEbaYs?=
 =?us-ascii?Q?AikcMxHk2UOepC6rDRvN8RRq5A4A663iR1O6LsuH98yoUr0p2KUNa4k89Nl6?=
 =?us-ascii?Q?AVSzIY43DiCE0nH9IoMjSXfhsoK5Z4cZ1K/6Niiq+fvWnnGascOnrjD7Iso9?=
 =?us-ascii?Q?n5uY3tSrtcItd3vU/tKF76VX5U8ebhhlyVv2gUxdR07DfgU2z3htp4V0d5XI?=
 =?us-ascii?Q?ztWNBDsMq8AsEspgAfp+ZDm58xcYu/l75277qHQ272QYAffgEdOHdL+wLKa4?=
 =?us-ascii?Q?hFEYnxpr8IroZ58zRKLoCT9TcS49ZrMkJrj6Ks1tGlHeG2Oc1MMd3aH4wtQ7?=
 =?us-ascii?Q?bb3Zf5CBHrpaPOkJigQst6rPD1el7EQMJcy5HS/4t2+7+0u5if2VxKHt2XXg?=
 =?us-ascii?Q?Eio386J7p0lknlk0ookW7d2sj9V+UVkJ/GXCc1D1r9jIUIcTPzcqLn64ptst?=
 =?us-ascii?Q?Mx2l2Z9QLnkcEH0HFmbQsX2kfBHsWoNWKAfsQmxscFQcWWgnFBBSICsNCRyQ?=
 =?us-ascii?Q?jl/CKk6GRyanuiQyZot3PNAzqazHR4US2Vdmjb+y5/WYYF1LChuUovwGr5oD?=
 =?us-ascii?Q?o1goh+7EkKvvXMoDxTtxu/BpvrJFxaC4WDqXx/tlKUAiVzOuNptnahllvSOK?=
 =?us-ascii?Q?BTbFCOt7sn6wU/IPa7tm/EhQAgaKmwfYFDTdb8rM5ZaHoKM9ScVdUYZPvUz9?=
 =?us-ascii?Q?LCOpsWmHrSreygvy7/khCRkcS5FTCIsc/liHcACG+OuUNWAu7mEINa88ff6k?=
 =?us-ascii?Q?Vqe/rM+NpDLXu9A0Wfsmckz30/T5z/eAufWDYWQWduK++OOXJhXCklxKdTFb?=
 =?us-ascii?Q?S7GRpES9gOhG3U4h+0pThWPtpb8IanreQWGbko2oGOET0GozkEVPWP/bWG3l?=
 =?us-ascii?Q?tVVOjYvrsuJfJ2wi3JXiq9CYrfiov6ue6CHoEMc/NqzYaEUjzJM7pey1d9bs?=
 =?us-ascii?Q?wSThUb8XDL/9gWHB1PfnL7OoShxjzSopUATMsFlC2SELSo/i6qDJmY5qCJ6l?=
 =?us-ascii?Q?sEHFykmRobja/GIkovQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DWx+dmjCAFjZpZxgO6hF0L1Q+5rNskuFnlIK3J6mAm1L0gAxlJvg1sZO55vv?=
 =?us-ascii?Q?G8CoKY4V/uktu1NUTOpFPbgk7qcH4ijzoXmiWM/KDVquvzZtdoTuiO2VOYdP?=
 =?us-ascii?Q?+lWyXDfrvDt+ukG+4pPolXDfUfGm7T+zqq+T4j68owy7VZlZvsBq0nFLTZCQ?=
 =?us-ascii?Q?zzGTcugE1rYACzQirYf1AkD9Y7l6ICusSFqpkOp4D/pJjGj+GuiUt4rmvmzo?=
 =?us-ascii?Q?T2C5Dm3IFIMPxur9r6edY3FHog03XNIyt72L7hXbzyOA4nNoaFg6nI5zK0SI?=
 =?us-ascii?Q?2dflbzJAlLO0J4pwFCR3xTN9e/hON3pFWZAxd1nUObcbcGNi5d1pRm9YKacU?=
 =?us-ascii?Q?1WY+95GiETnSgb3LrzfhmibmL7zhwlLGb2NKPfM3LtUVV/njABjWaAj2kDmK?=
 =?us-ascii?Q?rkc3aDGwRh3EP8s5Pet1NocE/+BTsQ+z13VBz5zJZJKvXupEUHitYk13Xjpv?=
 =?us-ascii?Q?3zeARPZ+X+wRSxP1DXqLwy88HyqhFWh0MYDiIHhSbhTLnXvOr54ATmAeviIn?=
 =?us-ascii?Q?uXhkh8nXdogvrRNuATdt1UQAl7IEZC2B2sKlZ0hWI+Eh2YmA8ffScaCzdzdZ?=
 =?us-ascii?Q?AEXO4HoDcgL377FZPkA8cao3t7QlBqIQpzmFxr8vgnlLHbekX8CZwU2jWlUj?=
 =?us-ascii?Q?rJm4u1Y2MEKE7QIamcyR/E3HSf+Pw3wLg2zq4ru02oeIeBGljssZvsWTlytC?=
 =?us-ascii?Q?c8e3cWmEHkzMkjK81CAJspP0t6FQVdMR/XospGc07UfAb2OMsc7WXPHRhZGh?=
 =?us-ascii?Q?Wd2vXlqstb+j+XZwsDsaCtINFce5p/+VRs9MuT7x9/PAyRLH9GGxp9eiFcZV?=
 =?us-ascii?Q?7uR3tRbO5C56w0IvwjLbcrGimtZjKK6NjbSE5nP2subqiB4nTXlZhp87Yc3t?=
 =?us-ascii?Q?Kr2UOf2C+CyJm8Uir3+wvyrrluCyLramOPAqv9l8rmWpTO0ha8U7h8mmdTWc?=
 =?us-ascii?Q?KjBBGAVD4VVJepnSrYGXwydmfZtMkPQGWJiYuHQSjobtUsCnZUTpaepwThKJ?=
 =?us-ascii?Q?nweoyxYJpCXlcODhMv5bXFDR+x+Dc2YQM/eHQqXFBA5OJ3oTGJVHQqjm3F4k?=
 =?us-ascii?Q?osGHqJr4Upexw+TMA9PdSkWOhmi0e7yWWcDa5kRANSNK3Z/yZo4Fdi8zPfLm?=
 =?us-ascii?Q?fDyvYwbxwvylzrupTipP86AfKPYgEqv3uGk0nVYL3eawHFgrPvY20d08Yr4k?=
 =?us-ascii?Q?VBuHrw2tEe8Bv3LNjshWv1d/g/sk9U7tLjjKNfczeNYBxlkGME6RIsu4RVyE?=
 =?us-ascii?Q?btZX+NzEDIH+lXOaMcrPBVlRg4whMnFz/D2f91u/oWA8pLSL3jpPJHQm5e0V?=
 =?us-ascii?Q?PGPrtATK1J6FXIr0MA1EyybRsgVMA/NcWrV2+ZAaOIT2Vrkya8NPZJHzGeno?=
 =?us-ascii?Q?u1O3eZOnKjUnJBh0R8XbNOLpdK5U6fg3OkpPFvYs6aDMS4jsKZhxJAPlu6QG?=
 =?us-ascii?Q?vngtbK9VV5J6NsQQdMaBvyZszehuyfZd51Kovu6vJSiTWZ35HI+jDQp2BCy6?=
 =?us-ascii?Q?r561fMJKvBPYSoj5Y7tH3fP8DZpTSsFSIpOiGu+KWpr6OvmCBq0GRrhAtMGe?=
 =?us-ascii?Q?Q3HXGTo6an3Dv4scf5j5cQoLh7RJtF9pggfX1EnrKjovXZnYmAVTEe31HREL?=
 =?us-ascii?Q?bw2BVfOJEI7O6vHtlBnb9iIphJZXklKtEBZvUesYCmtQa7mlf+JbybTtDkHe?=
 =?us-ascii?Q?c/3RQ4Qdn4d3xMgKNqaeIjm4qg8cmK5yJQ2LFgMF4PmQuqTsOMfOVbF8Lu8f?=
 =?us-ascii?Q?pmpC8rzOaQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	llmA0TOHPwNKg+F/2fglZqzaj0lUWtTAYG32J7fIy6HOhMJEQz4uN/llzc3sXgkaZbBOOYZiCTD3HdTiRtW3b+a2EnpWWt9P+abVclXLFaUnwBPcSSsEmBx6Jm8PvoLEJavwQ1GUAksRuB2IVSFPhqhu2L0hET6hJBw0DZ5llUPHg/Z6O9LHGXkc8mBseNKnMzIkMooZQvqj3K0PBTG7AVamFO0a6qLlskU1UCf/ZFYno/oPekoHKSx4sWbqAiWs0UUtXBJYmP8EISmKTB/FAFfKnJ34YCUQRjSl4ddvhPimAcY4gGOThSl1C6/3E0rcserWd5Zli3/TvzLom7CZIaqzwXFMcfA4MT/RHDUeoNAfwZfvsAj/c7C7AjMfTIWqRTdJZjx8WCyRKTClKBJNr9WJHLoPfDRq/Cp5iRwdOUyQyRqdLIsak8AH9ptsFTTCrlA9oPH6d74pTE4HjLv9O8J+Wag10dC8/GIZ8JgfXnG8wGJWks5MskVlvejaibFJAr1It34BVjWyAWg8fI6jisq88rJNeOsKSGdGkOupnq0Aw5Xz/0oIFfnBTVYQ8qySQSRCMF9ludzo+J/WsCQlT2xDWLLtUEGn8XoFTOwVWK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd2fe3c-6d81-4c86-94a4-08de546d901b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:48.0172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: me2AZ4bJ5jWtFFwh4WaIOx9FJjlbCNp3fVNbpLpZUZgv1Aq8pbVUY7sGFGSbXlXiRpBtz17pW5kXouz5DJSJbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69694210 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_w8VSrfIF1JFY7EYZQwA:9
X-Proofpoint-ORIG-GUID: XBxGufsKiOHt12OHh59a82DMj7-Pr0lQ
X-Proofpoint-GUID: XBxGufsKiOHt12OHh59a82DMj7-Pr0lQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX54ZJdW5RKQNT
 vKjXRtB5LDYZ1C1RImJmjHNrReM3qsQnVgd7IwNnh2SZn2UDDKIA3VV3D2mrh7SoJ2Nml68cv0z
 l/zVAF1F6S6UXGsidmJziDiK4L0+Y3W1c1ShsxSDyTzNeq/oGTTmBp/wF7J3r4y8VZ+KQ0VNOq/
 q6JraIOMSdvdEYnYDgXivsmqi9EMSwFuFgUtigqsaZSWesPZhjJ+mm28fTTRsMTjSAzPDkwPAgY
 Om1YWFgGL5andO0ysOczxOw8YNMyKw36adDmQK+jxTWMzrUvW7Xx1c9v6Ifb0E5BSwbUGA/zvBz
 T5OaexkuPE7VV/Lo9ReG/0xb4YFSAn+qNmmvSGiao3zeCCge44rFDJtidTGLz5LGVeCiFcTPjlA
 dw/gu6VWx2vdNgoFg4TpMJv0DxDV/AcvGV+C7eX15ev/j5uwUwGSX+HeXCNvPevC4G9N/fEgRLl
 RI9o4xXXJF6c4Lo7iZg==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D27E240007
X-Stat-Signature: yzn95dzgopy64fx86fjm5yaih6y94e4m
X-Rspam-User: 
X-HE-Tag: 1768505878-386243
X-HE-Meta: U2FsdGVkX1966oqfC7UGF3khFhZwxdSjua0zw/jhYN+hF3k7eWDGlVNbiGVNL82Gca5h7YzxbyQB1M+ary9oGv9W0svAJfC5DHhvUKvL+Uc04Y4WlqgBwDH28PM0KRIPj1j3alBAHLlasIfMJ5dG/p2oNmk1+zTr0PjIIMop19lIFzMT5yjHFa08flAMDdQU4zNac4i4maQ3bKnuJMGtnrADVKZ940vRZLMhuWoOUqV1rOsGC7AVuTygkBTXZabeVAzEEhRHHeEqb3DchN9GMcVr6hMIGqz0HibZHasX9mbcrbhy4VOi1JfFnQZrokw1TT9vRlMsPjEuj44WkkHdEwFOENqLZ5Ieq4GQzYxVu5j6MOknxD8wN3wXHHXTVQAojGdvMstNT35PQvz4ye8wD8BAAGKSNLavP9vFl6/kxLevguVUNJQ0J8rKGGXtNHfRGy5naE4ebfcLeoM6z8m9rB3skfjJDk2vZoT/29C24XSS7jlhifwVg5p0Ohk3UrfCnQVt6IeLcXrKQuuKXxVKfc4eAgV7IhlshPGTZIYOx1Jb+CTzCxA6lMJ5IlTyTe+o54fqXLTiAMLosexJbE4g8+n2HY3xy2HJtPsOyDrIJkGZJLqkU/8djCR9haECrodUvJqYKLCOjHdCc0we70EQb6/daHRg+vBz4M0YtOqTnhbWt97EwKs/xEmx/aODYoW/5/bXILQlf+r1szmpom1pheWAPNX+uLlwTzwKUVGTb+b0cDT0mFPxGmZbMKYSyfeinU5Guf2jlx2Jy5rNXOMjJrg6Ot+Hvx7N16vObOgmRgGdgZF4a170A5QCR6S772IfRiS6rK75JwsxCcSovJM3cRKEZXkYe0D1UfaSTDXgycXgCxwLWFSxCnXDIFA83+WOTX51+VOHJJWbN+tjale7lR+xqkFTZDNxPj1cX9iFjLfsBo1tcgyyaJvsm2NfpLzdpEfdqd6M9Rk7QMUsFMb
 2fM0QLvJ
 5la+c+dfUE1oGnHIIsUIH2X7F348UCSjoRLoW8kYuhXqh0IjnWNmpFQNNST8JY0rRz+gHv5TYFm1fHgzG9eXNWD7uFWi0RUAAiHajHC3SV4RKZ9bfBg8JIBczSSM1SRu0D1LC2BflUtN5PrlVjfCj8WMSz+ppHZQC9cM2Ey0da1iIyjHCzHt47stcFpydrG6DrSCqBsxtXuHMVPDfNE1p5prSEk5U2ZqH/lXyUAbBuIass4BxHtF49cvWYnsmtekZK3nqa/cm8NcmOl3ub/ZUGFDZQ44TM29dxcsibY3UEC3TF/O+L2n3YnBuAOW+wm0SQk9EYRxjuOn6JGuh6tYsERbdqOyEkcsYv5VifG1PkDZ6thtad2vfV1s9YwGmoARd/iRLecaJWQqPHCecWp3bnIM3ijR0+CVzBkzl4ngvJbN/cjfyV/VopssNWvbJIKWlXNvGqPrGLCkBOlLpW46rO/9WyXHDfyPD/7tJrlqzB28JspaoWd6CSn3t1pdOGta54ScKYhNRD9ZAqJMt+GfsFFEdFAMMnXNnSZOU14ZgMWObPIZryLCeFS3pZx8wixBlj+Gc6cKA93JtgIb24QxzxFiSMD0GTnKi8akF2/WboNu5UEmFsgnlUzUYiLyEZQ3ZubpnwYh4C/Wi3GQ9f6UOCJdEJ60neJo0w/xsaWhYgV49csj/vhR7jA7FdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the copying of the tree location from one maple state to another
into its own function.  This is used more later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 50e1d9f585502..a6f4a1c8549b5 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3500,6 +3500,17 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
+static inline
+void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
+{
+	dst->node = src->node;
+	dst->offset = src->offset;
+	dst->min = src->min;
+	dst->max = src->max;
+	dst->end = src->end;
+	dst->depth = src->depth;
+}
+
 /*
  * rebalance_ascend() - Ascend the tree and set up for the next loop - if
  * necessary
@@ -3539,12 +3550,7 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	}
 
 	cp->height++;
-	mas->node = parent->node;
-	mas->offset = parent->offset;
-	mas->min = parent->min;
-	mas->max = parent->max;
-	mas->end = parent->end;
-	mas->depth = parent->depth;
+	copy_tree_location(parent, mas);
 	wr_mas_setup(wr_mas, mas);
 	return true;
 }
-- 
2.47.3


