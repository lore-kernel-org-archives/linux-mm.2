Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A660EA3F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BE96B0088; Tue, 10 Feb 2026 03:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C135F6B0089; Tue, 10 Feb 2026 03:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A384B6B008A; Tue, 10 Feb 2026 03:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 931636B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:19:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30CD01403E8
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:19:29 +0000 (UTC)
X-FDA: 84427847658.04.F850D88
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id B729D180006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:19:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JX5+zggI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BOCvB8vx;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770711565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bmnQoE3xNWMprlc9FGaDbPrZ60tVFBSXoecZZl8x3I=;
	b=LFhhafk8C3Z7IJ+GztLyZGrV5bgHUQTl4Tiz8HGWFkadTbPv1++K5T7iAHVWbbPjXQaTJl
	h6tIL8n9kUlksRaTPr6fmuv346JslNj3zsOVSd7oYzQgUbO9Oxt0qcIiqnHkuwmhHD8F4n
	BTds5Sa8H8HfbUWrOk31kItIrV/UpBs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JX5+zggI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BOCvB8vx;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770711565; a=rsa-sha256;
	cv=pass;
	b=urzBSE5lbzJgEcyHSfSnWh2MaTRpVjlHHqwIFVy6bEeNs4swrX+D6n12UL5NuFoUbuMRMi
	XvYhW/W4su1wjiXkHh+79wKf3VdEeo1JtD3ZIhWVgtXyaUYWHvx2gvEf6CpfxcyGWRCNIu
	5GM8nFYHyqr2Sr1Bl3So2sI41kiBm9k=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619MljtH1628192;
	Tue, 10 Feb 2026 08:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+bmnQoE3xNWMprlc9FGaDbPrZ60tVFBSXoecZZl8x3I=; b=
	JX5+zggIpT4RcnbseAOAV7nJ5l8HlTYZ978/TPywdrWA3a07fGXGQi2WvjWFrmWA
	KT1YYIHn0yyJSEi4pGVYiOqL2rKBdCVJYtEqK+w2pFzQfKl9nAJ4iWNL+yEztBn9
	3u3I4UMBjyHI/Z45966nYaKYYb1oO3dERbKAZbgvMQHBdCh+93DLekRWi4lFfx0X
	Ap0Nak2/Ppll1Tdjt/ku56dUil1XgpgaonfALTQQfjtCbQcqkWu7BjnzbipspNkW
	1x5bvYc8ovAC1qZSFO/dzRCukIpokfmOpDUSrOgjmPsfYQfxiLJwcd3qNOofd9s8
	aK3kBspFvMVDWVpGy5j3mA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8uhc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 08:19:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61A7LcQg035343;
	Tue, 10 Feb 2026 08:19:17 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uuaawhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 08:19:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzwxFqPSzrvNiWHvMjDA6dyNhsqpdq5Cbj8fIN6pQl+fSYCYXPXcNpi/s35SkWcfUg1U3AC4WUVqo87KQBgFVrrcQIOJb61yhCqaUthtWDv+uaeKC9jbpR+m0j+21MIl8PYTlXbdWg5P9Mt7Bn+28jpUEHE074pwSGuzNUlva5yWkr6ggqwCHlc+9jYSMMQYTW1IX/yS/Jea9FVygCZKGWUYBN5Owl7oneemQC06AECJD8tkd9nkCwCFB6E1eMEt3N6zoZkMqTp8/jPyM95DdxcZmC/gVqtjfJG8BVHibIrAyyEsvZ1BLOYNuKn+KCqivlM55+vpueYMjK/QmAAX+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bmnQoE3xNWMprlc9FGaDbPrZ60tVFBSXoecZZl8x3I=;
 b=yOYv5g7eQdIRh7Yu2HMCg5Q5pQnKZLkfr/2KLWNQxJvIfLsox81o0THQj0mB5k06LY1ya+E5pcHxB6SrmTQ0uqPf12P3VfhaBwIqgAoxBr85Xwbb8VUFsEV7AfIkV/43YiZEk2cQ127WNIR5rOpIY+PMTNEJD+pqF6F0sCXsrvpJduzccipSNInMaWW9L/MToN/Obvedd0XwhPMNKyQa9JeteEgXSZeTH4Pt9tnzhYO+/GUMUl7ureq6hgXeKOHv+aEvIT2BPYSl3hz08jJqEprCd9oOvixAqdWsiORXGRNDI42xB5tN4Su5ctLkqYv79Kg2/RwC3vjfSocm0Kz56w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bmnQoE3xNWMprlc9FGaDbPrZ60tVFBSXoecZZl8x3I=;
 b=BOCvB8vxXbX/Jpaj5vFJ9HGrUQ+6v3qfklqq/NaHF8D5A5SVQ2veA+hqR38VdR9jf1eK2/ubpB/9z/xp+3psqS28nG8WCG6b2jw7bQRVPhONB0rl9M0Ebcxw9mMXpq5/sPuxKKyh7M2vNvmMVORoJLFbi32xDMpU+DtRhb7w1aE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB4961.namprd10.prod.outlook.com (2603:10b6:208:332::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 08:19:14 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 08:19:14 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>,
        Hao Li <hao.li@linux.dev>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH V2 1/2] mm/slab: do not access current->mems_allowed_seq if !allow_spin
Date: Tue, 10 Feb 2026 17:18:59 +0900
Message-ID: <20260210081900.329447-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260210081900.329447-1-harry.yoo@oracle.com>
References: <20260210081900.329447-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0145.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB4961:EE_
X-MS-Office365-Filtering-Correlation-Id: 777c4418-4411-4e94-f969-08de687d13cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TH1CSYR3nboiozx+po17QYWSmyAABAMKfZRmnccBuNeUl7/lPPKk41WNpI1j?=
 =?us-ascii?Q?VCBRo5rz7TuEVUcpQAEyahaVvyHfO/Nx5MS2SNkvJGH0UijDDwV5LvTbaoeV?=
 =?us-ascii?Q?0Sj3LPc3veh6psXJi47Wf3S/ql0jrxEAajvtmtlXK4eA44XabKwoYwLbkfFP?=
 =?us-ascii?Q?9q3AGcvkSiQKPadPyh3BHxm/P0JP/BQWOpIG0emBHMJ8D9MIHS0+7QGMW1bY?=
 =?us-ascii?Q?c3rT6fUvnIxrU7omjy3Kq8N57CPGnJclXJXG0Yw8xjNY1sCZNntFPBu4fVJS?=
 =?us-ascii?Q?+TMkFl82g0eDiNfbWRG1xuHYOhALX3ikJ4MeU0xbP52kq/3UJPeG8X85r/u3?=
 =?us-ascii?Q?EQ6s4hhOK9MwppM0RIPdjBbKeqisYOSh5Pu+HU3RQjTIzBO/vtko7ofJEoel?=
 =?us-ascii?Q?ior5+FpQexvscrguwmC5PNNwMKgmQBPTrA4eH3L4eJaUspeTITLpvxa6A7eM?=
 =?us-ascii?Q?j3QmxyrRpC9pN6cxHgUFLpPqV7jXIS73uB2D44c3S2UvKFCrk5OHpUE+WoL+?=
 =?us-ascii?Q?RkD9/5P8OwO9uo27VPxAr+ZkGBlhPe2cCWVyIi0IF6e8bDqtOYv2F5V97pcz?=
 =?us-ascii?Q?ZLzXer3WZnZGmFPsbJKj7ZW3u6zIfpnoW2kGI9n+wZAhMtq2tEipv2kChOxb?=
 =?us-ascii?Q?GQbQ/Lgnn2spWPl8xWp95sOtXUMGJgp3Z5Oa/mJ3Dto0mLr15b0XBM4ukriU?=
 =?us-ascii?Q?KjAezsn9knIW9jej5TxkJEJs193r+J+PZZ9ah/peb1pk9Ha7n1jtUqtJPKl0?=
 =?us-ascii?Q?BwU1yfXH/uqpVVYH7vqqvUO13bxKBcYPFUrXJxbxN5YTuHDAFiHg8WhzMHsi?=
 =?us-ascii?Q?+ZwKbgbDmxpYICrcfnTX51XKAz6gpdCa1eoZ547gS7GXqhzl78sxuXXkrC3e?=
 =?us-ascii?Q?ZslyToS8aqasN/xzI8va3VpzfLrUBDdLw2P8+1afJo2q1brrxLrKB/D6hyXV?=
 =?us-ascii?Q?/It9L/eX21Wrn5VVpkgGCLt0uH1LRjEDTB0Ve5CAef2sBU3goq+XXgTxwWh6?=
 =?us-ascii?Q?y8hduehrJuHIxCS3uMnGbS3+jkYCU7Fp007CmIGqR7C9F7cDJym627Jtj1t+?=
 =?us-ascii?Q?508ZG0kNSoqoR8hdhqjs79QRWg79saEj0D9TIKDyItT6NZVeq0RCZRaC4ST3?=
 =?us-ascii?Q?MBQTmSEeDy0EETTwUQZdHlLo5c7ms69mtEiKNYxPh1XNcNdSjLfyGsG85GZz?=
 =?us-ascii?Q?+/vJn1sP3CxV/2wtKhRS4nj2vZGzg09tQhhMgsRHwYryyy9+FDgFxMuQgoZI?=
 =?us-ascii?Q?9cgq/U4IER2/FxZky6xUnYHkiXwTnZlgzhKLpPtPvOAtGekUCbApsBaC9Sd6?=
 =?us-ascii?Q?a1qwmDXho4x4zvTe2hVofJLUTTXTBuWT/oifA/+KeJOGuXuELp1RkD0p/42a?=
 =?us-ascii?Q?s+bcryrX/CCsnVW2Wq6LaDUCpIOXu91/yhmdvd17a8wspMkeHwxO7y0h32r/?=
 =?us-ascii?Q?vODLI9NavbPRI6naR3xsZhOImkZGpJ/x6rdZZLSucPk8rcMy9qV+z3VG8Er4?=
 =?us-ascii?Q?gkfzrwLYaHc1MrL0jWptZD7N0wMNHNzshWrEuwKfzGJacVhYK8CiveqVycuA?=
 =?us-ascii?Q?wbYxk/kNz5fEWTnoWow=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VTS7ZFhEua1RsWCwxwtvxH8evk3OiylIfZcZZwdCUPMayJ/erfbEKAxPglc1?=
 =?us-ascii?Q?RK9IMRIJ95yqAFU0ZHKCJ9imvhAfS1lwRNjyZ5gPLWgLVGJfKfg9v/uSTXbr?=
 =?us-ascii?Q?DgF36iCb+wPE/GpuPAv1hZ+hhX8uajy2zI01BVYJwpmmaWmvK11dffHKDlue?=
 =?us-ascii?Q?R53wbcgZ3i0xt3/6t1aOx6yrZW2szzQhyDIsgh9sDZj108GQyABYkdXW5MTB?=
 =?us-ascii?Q?1erHYwZM1sBVv7gDaDpmEq4zHfjXU5h+Yfl+vkWKRXZ4dk+wt9ESNNJYrL0a?=
 =?us-ascii?Q?yUulGeMPtYRrLvFJBnzOx1tbsh9s6KH0OtH8mhZJlxXruPiaJVGZ7ny2Gujz?=
 =?us-ascii?Q?xodtKbp4IZMw++/TSJJoB1ujD/CTvght0pgeBdUVqJrt0uTk4aU/x+NVUw6f?=
 =?us-ascii?Q?t6eHzFF/ffhJ++qhsRpifENrk1jmXFB8BcJtXUCerCePlAQ45jUSb5bzhMED?=
 =?us-ascii?Q?uYcAvLL/TBOLIhc+IsHyC7qawJwOuFgvenuM2MELGqUNeLIR+AOvEr+4Rq9p?=
 =?us-ascii?Q?oRQEs2RNkFg2ReUROSFG/jHwaxwzCzZoeJGxB+8BD0+2dj/XmaTCLQLz4kLS?=
 =?us-ascii?Q?/INVe7cVlRZ0j4qscUkqeJ76kLIXDgmQLSeZV5C6Z4RIEQF8TWVdBQL3bjJN?=
 =?us-ascii?Q?ylVxrndyyHtMSx75bD7VpMSYKD2+Opc6/ushVgIUBUJiNZ2BGFBOPv2rXwfr?=
 =?us-ascii?Q?Fs3FAAayhEUxYGqIenTCy0tynYMZ92JDsS6F+bBF6cyC40Q2AL+/eXW5qYSO?=
 =?us-ascii?Q?Y9b3IT7iR5CNUYgF7Ec7BjT4CW1HolEwKEY/E1VXElJkueD0+7jX4VhbcOUo?=
 =?us-ascii?Q?DYe0CvfX+rhlsCT9KTngUnpnHZw0mY8eZSwssTCxGocygADm37rZ0DC958iF?=
 =?us-ascii?Q?eRPjowI54V1ENxbpHNsiat4/Lqc5DeY2MHNbAKzd3pHLppond3nQceonV6i6?=
 =?us-ascii?Q?zMxFpaX0ZMbpB3iidk5SqK+T6y1E7239WaiSHpmObbcduQ57fkUQHHWIw9w1?=
 =?us-ascii?Q?ycNCrXcsxGLJR4xmPkNBXHXG6ZlO3egLIu5JwhFlRJ5Qnx1BuZTArCoY0emx?=
 =?us-ascii?Q?DLMGde2QVO2Lqhfejj18zKbxnFOdKFee3kJShT3xuXS3gTIpkS5L6WfwBn+D?=
 =?us-ascii?Q?Fz6g2gbpbbbCsa6LbmUGI/srMMt+Q6YB1mCZpcn4GV9WnWRxlKCnh5jQYN38?=
 =?us-ascii?Q?oIOBuuIsUF0WxM9e/efHGs39/+tvFiepOCggTfmbDHismAl2A91jHsInUAwH?=
 =?us-ascii?Q?RGubv93z2QJXSS+bX1wUKtsyIC1q4QP2zZ/cC4FJUxB/SHwOHpe8pfn7YYyv?=
 =?us-ascii?Q?uKcqva1UslW3o23jJ5CYzPGooMgLJfyUsLzS4bIej0liPuMMgVwuDGDzIZqg?=
 =?us-ascii?Q?l27KVWKPQw7vqrZ+C8S/JsUB7z9uE+x4G++XgXk9uetooMzOMDyuNatLRpdw?=
 =?us-ascii?Q?nyHYyYHBwBTeExzT05iCMQG21jW3JED3keam1Uq9Bnd+2zRWXM3XgpQ1ljb6?=
 =?us-ascii?Q?+BvJwcmq8MUFZFVCRCn940wIQXxLw6usDGfyBdSJZCclsq+qTVffbWVknavm?=
 =?us-ascii?Q?CF0l+ZGt84qOHmttDiBO9KL48Mp5Ipf9GXY14lZgB4yB1gOGo+iYDumC0cH4?=
 =?us-ascii?Q?e0KifnHDDbSxMfMvZnARUUR/sP4jRQb+ufPRqEh6F/1uzKJaT3XTRWjkYPIW?=
 =?us-ascii?Q?3Km9E0U9MEJd9m/vdDTk6P5V4kddMpo3j4XmqaqYRrOI9y/Hb8jMRoryqdl0?=
 =?us-ascii?Q?d+eRLsCNNw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OICPSDvCqOCJcWBdn5yN+Pz10am9sc+u+CKrfWiKwAPFtmFEbFMm93ya8tuWVVWixRBi0T197ZA8HA3CkK2O7+5SdOTWeH4HN3YoBIs1J/rbnNRohSeOG+05npB6VuS93gG7GB9SEr1A7YXNeG+c7np8Ga4OHRo5jxcp+IqckblLPDw1QjEJnS2WNzGcCPSAE1zS26BTkxXTVhDgr5T3ru3oKllTro61maZe517HRtblt/qjPDKlfJt1DVve0JMM7tI9Ogt4wMAzRquRm1WpCJ3oOPFLhvdHqh9FjYF+L49HazFGKJuf832dAQONF793oLHKPyfJyMo4mUbcUek5vIpUkFyGCebtTrPK9xufRBoRJDJWf+xsAGFKXLT7hwjkUIxfFgm9ZCKgZaa3JvgcZiL5rYg//HcpUjw4xv0bzTOBOlXgWpvx1RIlA8nu4T+I9IdgS0Bp2eCZVHO8poThQhAmQ0k4NJ+I/RqeglXvljsXyIlFJobVuIqe51lDqXOpEtLKLjdfVsE5CgsBZoojq69jrtW8urudrgzlPAzsQJDQsNV7ZPfxcGPGIok42nt5awEwuA1wr5E7FidQruHN3DD+Uy5E71h4h4m+yzVTZdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 777c4418-4411-4e94-f969-08de687d13cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 08:19:14.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEFrHl62nozceFLblgfbRSMgM5b5VjqRQAZHqIL/GRN5nvb48ll9P5KoamV+YnBkkGlMC2VJ8VIDjlRzKOlxPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100069
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=698aea06 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=FBGu6gR4qtA45FvWA0AA:9
X-Proofpoint-ORIG-GUID: ucJlbO2Sk4uKZIFd1MgfpOH4FkixxxNE
X-Proofpoint-GUID: ucJlbO2Sk4uKZIFd1MgfpOH4FkixxxNE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA2OSBTYWx0ZWRfX/mJh2E8ckQLz
 v+S86HSjN2wCF18k9ENhDTU/n9ED4yBwIDxKJ7sank13bpRIzZBmG+59/OYA79zf09Nm1rGCk+i
 G3bx9lQWfyVuxOk9lKlhoIGET7+P16K250qeDbVtI8q8gQMcfIJeYcuqQW5yjUJJz3pwsdKOLvd
 Z0p14LG8HbMi4SDb14vtChoVRLK6Qq+gytiFeZsw25NVcz2VniyMQONNdEWysbHRkVGDAGexQGx
 pV6qw7P9HWJk8MA873z1x1NRWhQ544HiZLjvBkyJoReXGR6XvYV7ieJ6wSeSohtJ5/ZpP08ogPP
 PVDnnskEn7rqWLPWSaAbHjgf3UR8p5A1AHqgQlKPooMiYJiWOzA7Mw6u25stTO/4fxh7UE8Za3w
 6cIeXWpj6XYVFFXONYnjPmS6faNVLb12Un+KKDy7WeowE0+erhzV9nlGb0YVmajKVxzNAre8yRi
 xkdkbpEBf4Vfwq9V9Vw==
X-Stat-Signature: qz96nptra139epyyjbka3cubxmpm4xny
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B729D180006
X-HE-Tag: 1770711565-966539
X-HE-Meta: U2FsdGVkX1+QQbR7aSqGwmX3vtTtlhA3TlO3q58bSw8ME8d339yqZY7Q8ArHcejTXxJD0GeF45+6i+fltgXJR/JdwZ1M0JQzGXjl4g0T/XM5JyNJDDf/Sh3PAINmlcALEcvJ135aitUkF2ZpHDI56uSc7dkx2+kD6y2mcmSLjfMnV4ANvHpASLmShuR8+v2A2mVxzDlpFjOFFlyaYj9Dc6mynY0K32OM8gK7ckBfTLn8YfKSKX13mj3YHEP8s03QTYgh7mmHZZd8ysYqnToAMkSZLZ427AYGjYeajzgHFKMlJvxElSJ0eRbi30bXLzP63vpoHnNwmZcg7f4AbjeUxQfhGuT4nef0QWPxEmFpCVZJYwy+pbIUxLKr9Owt+lcPyiuoOoPHwtiMr/BLgSq5NGMDv5zFdL8DMU8WqR6aeRbAxlQhWpM1e6u6WZPBSS3HieUCC66zCtL2aVW6ppnDQ54mfIzD75d1WkFMpQfsgNuehlo+E5DCJ1LXs7F6OIHGOto3UDNyMz5/8quqpioVzfdaa8OKyUSj8/pPMOb6bA+BR2EPsgVESae63I4++L+b7Hdf+YTJc/4Z5HmBl+mu/n49B1mj8MnbwHrOBUkX3C2OZmxzfk5P05VK3wU1PyooLIBXgtTBCK/EUHrODqze9l7pp0gVkHWvPjvQDyC9mVUPEbNlrr88x9W6IdLdKRZJnHzAi/d732kioe+1iomUfrk2dn7Xxp3uJyqgE+xLMGrbjRlPnHAmm7/AS6yNQAUHODCpAi3cJgww/PYIAIUw4yjy0jY53Wi2tFniSkV8gWYQOvm+olDZhqS4DHl6wgDf1HndwCJSaStgdf6Yu5i7vbYCxliSDDn/BjljK/+6Z6lwlo73VTnbhkiVZei+J8/bBgfG/qGIttehDSGKmq4XZ5+K0++ypcqerQTERerEQ8ahXm4cSo/P7mxRDHELeXDhW5UUnyZpWFB6JuZwerX
 T3BT6lJm
 hxEtR1vgZ+9LxgBvWgXr3E5pzxmM+TEQagLJykEGTaFH2lC4KBAXE/73zUHntat4b5Z59p+SHWPvcFstDcM8a8792+x2sey3f5FY+US6lYBa4Y2AC/FlHdRS9XfyhTwu4ZQkSHjfKn9dS8esB6L3knSId+j2sGKaJ7icTgAicE3mL6BpO++bAQHLPg/zBRuno+0Gq9NuF0Sdx2SNVX4jZZ8VLz3hs9hGIHj/Av4Bngkj1JIDvPl27r8qbg4pJEiiO/hklW8F2cJ0dbcwRaTXwdp9Ha57qRq2ZFeep5L70U0az9adEIr07wzzZUzTnv6/ClWgx4BDtKUey/xSrTIO8AWzYNO73eMiPRQlRatQ6Y61NQXsfWX3CwchM+j1pfi+llVi4fGDzi8CVXtWaNJhCaNHK68us2JTXwtBiI7Od0zR48aEtWo6dq8AEJTUBXCo29y0wteoRfOox++PXDQ3ywA2jV9HlSygHcgNU3lZ8W3ML0o+Qn8+UgiTdedFZ9lk0Gf1E2oQNRHWMnYs/mhoMN8MHKn4UYeL3WDbx4zcz0q38v+QXsIezQH1qmcRf5gK3GADIlxCfxWsF3QzPbmh/7lxSsxKzPhOHq3HX/qktZr0FUytCE4LPSCGEucKmZJ6s1RNp5AoEdpB7Bymvnn0lSO7uvua76PhXMh80Fl9x4a2R+vmy5mtrxZ7uA4M0OxCuF6qExspJ0cCIVz9qMUwfNOOaEhXoeX7sHFJT32qCNGnypoGa+DxrCA7K3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lockdep complains when get_from_any_partial() is called in an NMI
context, because current->mems_allowed_seq is seqcount_spinlock_t and
not NMI-safe:

  ================================
  WARNING: inconsistent lock state
  6.19.0-rc5-kfree-rcu+ #315 Tainted: G                 N
  --------------------------------
  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  kunit_try_catch/9989 [HC1[1]:SC0[0]:HE0:SE1] takes:
  ffff889085799820 (&____s->seqcount#3){.-.-}-{0:0}, at: ___slab_alloc+0x58f/0xc00
  {INITIAL USE} state was registered at:
    lock_acquire+0x185/0x320
    kernel_init_freeable+0x391/0x1150
    kernel_init+0x1f/0x220
    ret_from_fork+0x736/0x8f0
    ret_from_fork_asm+0x1a/0x30
  irq event stamp: 56
  hardirqs last  enabled at (55): [<ffffffff850a68d7>] _raw_spin_unlock_irq+0x27/0x70
  hardirqs last disabled at (56): [<ffffffff850858ca>] __schedule+0x2a8a/0x6630
  softirqs last  enabled at (0): [<ffffffff81536711>] copy_process+0x1dc1/0x6a10
  softirqs last disabled at (0): [<0000000000000000>] 0x0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&____s->seqcount#3);
    <Interrupt>
      lock(&____s->seqcount#3);

   *** DEADLOCK ***

According to Documentation/locking/seqlock.rst, seqcount_t is not
NMI-safe and seqcount_latch_t should be used when read path can interrupt
the write-side critical section. In this case, do not access
current->mems_allowed_seq and avoid retry.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 11a99bd06ac7..90f0e6667130 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3791,6 +3791,7 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
 	unsigned int cpuset_mems_cookie;
+	bool allow_spin = gfpflags_allow_spinning(pc->flags);
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -3815,7 +3816,15 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 		return NULL;
 
 	do {
-		cpuset_mems_cookie = read_mems_allowed_begin();
+		/*
+		 * read_mems_allowed_begin() accesses current->mems_allowed_seq,
+		 * a seqcount_spinlock_t that is not NMI-safe. Do not access
+		 * current->mems_allowed_seq and avoid retry when GFP flags
+		 * indicate spinning is not allowed.
+		 */
+		if (allow_spin)
+			cpuset_mems_cookie = read_mems_allowed_begin();
+
 		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
 		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
 			struct kmem_cache_node *n;
@@ -3839,7 +3848,7 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 				}
 			}
 		}
-	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+	} while (allow_spin && read_mems_allowed_retry(cpuset_mems_cookie));
 #endif	/* CONFIG_NUMA */
 	return NULL;
 }
-- 
2.43.0


