Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07F6E9129D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5956F6B0093; Fri,  6 Feb 2026 04:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5240C6B0096; Fri,  6 Feb 2026 04:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128CD6B0098; Fri,  6 Feb 2026 04:35:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F7F6B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99310BB59A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:20 +0000 (UTC)
X-FDA: 84413523600.28.118BB77
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id EC9CC18000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="T/GqyoU/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MA9kMblk;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jFl8cPp9l7llPigBMaeTm7x9UM2cg+TpFsmr4X1jhY=;
	b=K49Ig3S84d+0+Hj/SuPVAKx3g1hGF7lrgFP/JFDPraw8sfAQVDfKuWX7J6KCqVXdhqLe0v
	JEJ2ipyaNP3F/CnyB9jpQW6hkAA/r+MbJrsXST7Q7G1qLp+ii9AP+ifuZ6jiFFPQ2OHk5r
	W7L8XJHfMc3i0sMFqlELfm820Jou/cs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="T/GqyoU/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MA9kMblk;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370517; a=rsa-sha256;
	cv=pass;
	b=Es+ggSiqevgod2UMZBbwhONmK/vtwwxnwCwTJuMLaw5FVzZqFscqcEixFtvjbYBGmOmFQO
	fgvkoPDoHq2UyTcDCuO6J2LGoBpl0aa08HJTS/dapCQshD22eAc6Tgm2NEcymdwUGw4ni8
	oB6LNblhQxeu9cx3QX1G2vbBT5CeSwg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615ILLJs1078331;
	Fri, 6 Feb 2026 09:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9jFl8cPp9l7llPigBMaeTm7x9UM2cg+TpFsmr4X1jhY=; b=
	T/GqyoU/JlZtEFpAbc6Ls0/d/My9G6iZvbVQCaGIsgZd/Rf4ZVmwC6a6IMgE+YDP
	CwVsXXZsVfcNmZAUa/9JS4xTt4+O9Goc8zpWoY67EKOM0ciqxNRRxjG0NZG9SvfS
	TPPlf4AFTAQm+pHrPMdxo5wzPxhn0LREURcRhoNS7Uu+xTT3XoIJR8zU4+EMb4kc
	H/S+yscFNIIwhElrA1g77NVIVXeyTMSp4mKwdJzkCiZY+7ijRS780FNiUa2vHPB0
	olZjDDijUhU9H1ECydv0Au729FckBVOiXyS1gpQ5PWCEE7CpNleedIUkYxbR6BYp
	ft3zbZVi99u+CXsHDraUPQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50ddgwtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6168JtPI018212;
	Fri, 6 Feb 2026 09:34:47 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186rx6bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fY79lRN1XBEWcOYJja55VCVQIoP0SkmvkBFlCvsEhB5cIw2ORKBfPidEgCVAXzToYcS0R7UKaQrBcSz/ZbrD2d4M5efrS5ZXB8hkUdmy7nDVR/I67Ch5Bh98HlhdwfmyeHar0plBTOiJZURCYt96Acu0MSFZlmbdFS6T6nrhZay8eq56zwng67EtTcoJ0LHXALIFJQ7kU3eUNpFwKWR7kHNLqfrMNKGvu7B82cMkDJLmdKnEwD8WKsn0FFTW1CvHCU/ufQMV2Z+by7CmzMy1UsQK2t23FNlhMy/dJbR0lOlw0Q2ReJYa3wdrZdD09Ev8bJ1aY5tdxgktQexXSn4U5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jFl8cPp9l7llPigBMaeTm7x9UM2cg+TpFsmr4X1jhY=;
 b=A8RW2p4IsveqUNj1MMIc2UPHLlhOk28zxuv1p5QooHOyhcUX2+qcCgJk7z+8zzV5jmQb0zioxyGkeWelIaPI7rHqwboVlpJwy5hyUro9fLrACDaL8WVzrQpaL0W/dKARMbCvAGZ3cTzlq8/6T2LFdPoFWoyjOhtH9jYSKfA/lIRFLkNqImpcAVs78jH23p9/iZ9CH6D56grdI0Sg5vamZ2u8wMyLjA+Q290Ibou++vHSwZplufjt5thZd/iYYuDUFu1RMMGIO8rC+9puN/KGuk94cSTtVb9G/+u3U0GmqofNxt2CVEqVu4NgYRRTn1JzmovDjR/ATkp0p1aSi21Q8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jFl8cPp9l7llPigBMaeTm7x9UM2cg+TpFsmr4X1jhY=;
 b=MA9kMblkem71+lg99i4CcmEPw+pVU7HrWKVxwK5wybeirWFmP06QK5CYHOL1a3sIkS6hDccspmB3eYUl1YSLx+kRZ5wnASJuGPUgPfdFlpB3IM/FZu81XjnNEJf2iby4sEteNjTr1rWrUhA72wi4p1lrluD/yi0hI/UF5uzDFdU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:34:43 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:34:43 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
Date: Fri,  6 Feb 2026 18:34:04 +0900
Message-ID: <20260206093410.160622-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2PR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:100:55::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c2c83d0-66d0-41b4-0add-08de6562f560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?piDGwZFHQNfHQqG61fBM9SGsrhvUsxRqRgK0qjc6T+lWoB0WJzd5k2VimJzZ?=
 =?us-ascii?Q?xh6ef48q1IpTlv7RTHTBV7O/BpIzbgPSAP/pYUBdpSGajumCG698Ja95hzvY?=
 =?us-ascii?Q?3YsEttQInD0XWH5D0oy1AInfI4dw9oiex3Yrm2Wjtuw3WStVWfjfN6vuSi3p?=
 =?us-ascii?Q?nJnDV1wLgu145YJL/m8VDp9fSdJl0uhqyvv1e46g2TYGIBS7oHvHd3D2qWqz?=
 =?us-ascii?Q?UGJS9rZfUaySVGzsx85kGd2Af9S06jlqDFIqpB+pKFFfESLyO0aHy9tWFzVB?=
 =?us-ascii?Q?gEtVwGlZfqPEuQq+HFdxvOqF2S8B76r59nNbGsETsj7yfSuBg/VQCnne0D0U?=
 =?us-ascii?Q?7/OWQLmYcBpQXjqLUtmvgQh5RmC5Z7GQu5tf8k9MVNWGnKqpznmr5taV7mte?=
 =?us-ascii?Q?R3LlbCjJrVUlCL/GFLuvmjJdFZrL4SH6M5Rco8hv49zUXJC53jh3sF/C3JNu?=
 =?us-ascii?Q?gdB/+jngQPMTZrg1OFfRa3KK7FQv+6nWFzbCuoVaD7rRR6k86C9VrCwC66I3?=
 =?us-ascii?Q?/W9LLQAxsn5dYSVRpL6SkQv1setM1Je7IlX07lA4Aw34q0qeyxZ1R6vNpmkb?=
 =?us-ascii?Q?9rkm/9hntjonrEtJcTihKtR+FuAWq5c5r4jrkvfdBqBCIObyzR782uDdE6CE?=
 =?us-ascii?Q?EQyW3tcLihUZQy3rSJTVytKdnf9XkIoU0RsxdCH4IH3MFMQeir1impvH42LN?=
 =?us-ascii?Q?xbAhutel6p9bEu8heGLe+dA876jnrQPpLDnzZxhYDawXAs789nxx8ofpPTDY?=
 =?us-ascii?Q?KfvuQS2c4THUbCnPQ+NQu2PFF8xtD50EUEoVTBQNdLneuE5MvfI+u49uW2gg?=
 =?us-ascii?Q?ycfasnmzBHeeQ025FsG8EnG+F5Tqs4o6XhiX+qIZJh+xLaTYVmjyulOb/hjO?=
 =?us-ascii?Q?6MGB45l+2kJbCm9bixh8DTyYLgjuYMlpv82DGCES7YKIdIhBHP+PH4DlerVJ?=
 =?us-ascii?Q?Rbct5nS3h6AovaxSWVnuPAwnJMnLzkQeO441gNdxzYkNmmvEADJUjySOhtGV?=
 =?us-ascii?Q?NbEl51SUujY0m+WJaAgv5F+nNJgJRi7cVlt04H/0VEB+8HFWD+Wo40aEZ8fV?=
 =?us-ascii?Q?AG/dOEEwpk7ehLop+3Nni2jb76hSIZdvFj/hNIjN50nR8NkMaDZ3BMt+gt3c?=
 =?us-ascii?Q?jtkMesloAlDIyKLYRVBaeg46Ol45oWYYwIOlktqr3GC8AHFY409lNTCusPYt?=
 =?us-ascii?Q?G4Wo5vD5NgG41Er3xQQgf3iZGYRhe003Pu5qSm/oIsufSKTJcES3+lxTa7Wk?=
 =?us-ascii?Q?qvGWCnhoGiKmQJT/6btbDCjbGJF4KMlUiQSVylRMPTairF7njnOq33IPWE7F?=
 =?us-ascii?Q?B7Mz3/EhyqRMjvqjOBIQSAYTMfjgakLwqF/JOYTGtPoyUqNUwYIpA1sc6rnf?=
 =?us-ascii?Q?zjsqc8xvo58mlfMxPS3PSG3jXhqOnAxBjzMpeQrwOrQIp2sQkDB1KzPNM2ff?=
 =?us-ascii?Q?E9QTMy0QdhCaR5g4Uvzz6WSYYoXu8Iyq1TgAwiCdokz8hu39CXOLfdmbAlXx?=
 =?us-ascii?Q?8GqgKUvPjBW3f86F1bO6oqykmSb9cbWC/dFvuXy/jM7mWRcz+2BRMioVVZOk?=
 =?us-ascii?Q?PJpkra8GZ60H1s5eeT8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vuyqGRoJsfpA/OWL0VTKr4eSbcvLASgaa3zWk6G33wn+x3sIznhDj9o9k7qa?=
 =?us-ascii?Q?UT8BflU8NTrKPDZtf0YkRhkuwLPMH29/bn+4nvGbpsa/mD+Znhsd0rwT7TM+?=
 =?us-ascii?Q?TzCdpIald6Qg4Lx7h3JeTwgS8c17UpdaMUNcILOIzNmgnwHU4LGIqlvTLueC?=
 =?us-ascii?Q?clCluu/06LR9NF3VA4MlkpYRXx04jX3/qSYVGPVd+r54ppYl0UJqmoQvolbc?=
 =?us-ascii?Q?bstivubI+05XQrNpPnjsZpmfbI121BBQJtnUwDMUt5C+9LzeWqy91+R+74Q4?=
 =?us-ascii?Q?mx1SX6jPyUGnErHAH+JS/CWJ0s9NDu+Mk+T8WKNmTsA3VGEIGoE+bJMo6F86?=
 =?us-ascii?Q?8s+ly+Mg49h0SASxXqEvwwivXsiAVgGMrwTit0yEmFyZ5nqAGAFsYr1JqrNY?=
 =?us-ascii?Q?ilK51VtSPGLmFX1O+QmbCm7AUaF2STxOyulxjItIHm6LIjKIWMTETtBEL+dR?=
 =?us-ascii?Q?yMgoF+VGPganerJcw0T+hHpjiVMAeyBPM2sR6/ub8rFS2NiTmwsO6m4bHwbc?=
 =?us-ascii?Q?f0jwV1JcZ8wKcbk4JTHDFN+y/FIq6u/QkmjyP2iA8fXyzQbUJ9mc42Jjx5YS?=
 =?us-ascii?Q?Flg4vV0ZrObKsGTzsHvVHffwOkya0hVbFKz/hXTuL/806aYQgErAhukqmRUy?=
 =?us-ascii?Q?jTp8f4CyRPN1BE+Fjnsf5xbOxVTID3jehYLnpg6Z78U81gwF5Geepb+uL9kW?=
 =?us-ascii?Q?rTxTj1Oe2YAS94ZTHeRcSZIZW6cocDoCPiYkKRqy+lBaSq6urwhPx2t9EdbZ?=
 =?us-ascii?Q?KuVpepliBjBusKRqny0lTdgM/FNnY3SUc4Y5Uqk6VkCTJbVJh6AnbSRn3PaX?=
 =?us-ascii?Q?kFqQuoSa3HL1fNmF0c3WMFZmMbDmHN8sHdaPcRQ5k6njueKTCva+wP/KCfHo?=
 =?us-ascii?Q?U3GqkSOcCB4T1+MwdFVVXYs0I5aafiY7vRL4jXJUAsZUsxVwJMhICjPSk2PZ?=
 =?us-ascii?Q?o0pAg922QxKrHUGl/3xlQCrg1K4kav7wOeLy81ZH44DgHmTa2MEv0jgZoOAV?=
 =?us-ascii?Q?RaYmxJ25Pt64u2ZskykOkDOEwhf3FPvNR+YuQvr7GR1vuGA8Wwjl1sVHapZ9?=
 =?us-ascii?Q?tjfWefGZvjuMnggTXNbGNOz4ikyuzMvRkHds7q0A/dNc/jwEzSMoUWDaU8Lb?=
 =?us-ascii?Q?ezlFfV5lmt9v3IfXpXbPOyQER2u6pUKoEkE+D/4Lg11HK7+i+erUdAPEWaS4?=
 =?us-ascii?Q?2/dKPaI8CVWIXDrkmw1AeQn33kLcBBcDxh0zU0OnBtH8hZXmofVeaevQ4Wwy?=
 =?us-ascii?Q?8Uy7ycJBLtUfZfcx6MbmNM/vjXLb/+9IZZtfYjFdk8qY6zQyd4fHVngxTK7+?=
 =?us-ascii?Q?uehje81A6JaSxIJXxLXmLvpmc73WkH8eqo2WCfJwcxE99NJno6fOK4VNxUD+?=
 =?us-ascii?Q?9pMDTSgIvJVy80tVOzBAyfR8rftiN/TXHZHa7Pu8FBMoxWrjd2cuLppl43Jh?=
 =?us-ascii?Q?KKPQfhMOZN6aIOFOgmH/DN47CXwvm6zmjMTspFw09bwQXtkNM7KRWdEJqixx?=
 =?us-ascii?Q?5foK3uzHPYNa+Wb1DkDA+2bEMvB10RH5bhFEjlR4X2RmlNfJ/aiylVz2r4zw?=
 =?us-ascii?Q?Ed3QWPppM5p8cvlH0pNLomFMyWvwlHQmakmzOoE3l6wrgT8jLmiqSL3xtO6U?=
 =?us-ascii?Q?07kPNgPtDTj5FkfK6G0CbENp38NHts3v1v8MDayF02jSw314C+kDHP4hXd6+?=
 =?us-ascii?Q?kPpU54xgRLJ3vZ7QDImrc3yKF6mxtwq/H6JI885kxkT8/0OlZHQOFb8tDbMe?=
 =?us-ascii?Q?GUGoGFTjgA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2MW7CnpDmnMvMh+FOkSLl3zswV0W5AHzpz7atnqu7oOyb6Mgl0DkFbq60/JP6OARHTPGwOL78OlGwUsEmujUrq3ZAxygC2xw6/0S8Tp93jVjBWexleRucP1O4b/ftI1lS/I3wehq3YPf8iY+uYI8ITHnff6kUy/HG319tLrHuMHs3D1nqFTEGlSRvZ9jdKiEKR4No1ylgvywKekTMPVpqz2AuzVEIGOqs4MjTH+vhU0Q9YnmVUBJc0xrw8T88b54D+F6oLZ0j39RG1ytc2iF8ODw+O3vUQlGdx0iSidYEKD7QMP0SM2eQoIKuGS/F5C/NGb/Fx2IjMqDt2pAxu9rVyPiyhjhr/a52X1oJZR4EiZxsky8ONu/ISD+IqXRFhah6C0NpPBHznfhyf3GR5XUyOGLIPXGPNmSv9NEYSALO5rTx3f23t3dAUcHdi7RXShwFwRdh3iuIZLFkS91Ai2Txs6w/SVSggeKeNb6fHkXAasrszkh9NsjqL/OJGGA1sV/JLODmGN0HYwFbiK4hl9Ecfby5LwFdPIiqA6+DysGQKp6jOAN0wQpA8jDoukjvpqMnoxigz5Ro3Jt7m7+dfkcBxoW/YtFR2XenfsyloTlgXU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2c83d0-66d0-41b4-0add-08de6562f560
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:34:43.2506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QaQOyYVvcC/mwQMr9L9o5nnxtCotgpBFS2WydQVX4y2mYt23olmxuIVtxT1yE+5bEdqzWT37coElBJoeB4y6Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060063
X-Authority-Analysis: v=2.4 cv=TvvrRTXh c=1 sm=1 tr=0 ts=6985b5b8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=CcXPt190chqvaedpIPwA:9 cc=ntf awl=host:12103
X-Proofpoint-GUID: z4D4nh1-NpC_sJR7sTR-f45IEelDPLaN
X-Proofpoint-ORIG-GUID: z4D4nh1-NpC_sJR7sTR-f45IEelDPLaN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfXxmk+oSGEjTcC
 ywRHwF9S1h9ZYDQgWhrsXbKve+ny+bYwRNqvoFPlh2hve/aYDB7X7ISitDKKyFJ/qqHG2no9tyw
 r2H6Ih+N3MIaHZpwbBM9bz6EMD5FlKbHquCNnY/NMD9qh7c4w26QTv/1NC7bHHol59q9FIRVC/D
 8fZzvk6PfttHeM2vSbbkscgGT149EkvDSjzptv7LMSiQ8SzlysyxLKvOrtPV7Som7RbGDunm1h2
 7n2EQbDh+Z/3/pbrKgUcuFzI3IrwDyu3k227Pw2lwaiHRYNM5Ssr7unste6+tbLZHCoFBXGGrrJ
 /8x7ThciLGSpcfRhYiGZNSOVDAMMqSPj8KXVp/eghJoF6d+Jt4/+TJnsIVzGyNrj0Woo7WEfACh
 ku/DkA9kt0J04H2UFwxRXueDHN2HA7ZLKF5xMscZFgkr10fE8qA6LIV0TuyUXuzLZSoV/1UBlP1
 QS9qgxSknMY2YITyeS1XICPhrR7pMpic9+B16SX4=
X-Rspam-User: 
X-Rspamd-Queue-Id: EC9CC18000E
X-Rspamd-Server: rspam07
X-Stat-Signature: jib54rw955jqcnh8hy6f5k3d976y7nc7
X-HE-Tag: 1770370516-611571
X-HE-Meta: U2FsdGVkX1+z8YoBby0CbIgfHIgK4pWME4Yz/n+vQJ9R/ApSIOvmT2iq4rJhlAQsnFfdQQzMIofOaGaWAChNgvYRvhzTgN7T8sgVQVB64JtW0edicz5QmNBZNyk/NWlMKnhcE5INsiZGnSSo7P2PTkrdTClRzoqmUsGgVSGl66YRFgO/FosoY1zywdad/Nf6Utxt7gA0+V1/Sz6pPTseAtDx7UGqRCFEwuGOlR4ZcnlfMcxLqryQ0H8PS8cleyuZzX67xM/kBmDMvL054ECDJdOHBkW71/PpfEijfYApdbN/hihVMwH4sslZB6xTAmIwAbS7TRm+ni/dUjdyOSlKxOVep35x6HSwKxROk25lG80d7H5K+yMPNRt0Ur3arVQkem8tlj/vMRuoRAEn+e+g7CN+CAQy37pWpxvSxOgSx3H0AnQmtpFSF9BK+oC61i6oRo3e0Z6XLu93qhWXxv7r5FVD+ysJpF0L6EBjJzBr5QPb4fXzP2u++xPaXSQXk69vuTwxbJwWSmW7RABchtKIV/VN8mL7fcGykEReIn+azqEj70mfsdCqhhzn1frBXGl7qtctiBmZfZlKitGccY2iCwxf02iUvp335WgAiaqEWmulQDi/7JoDJtGiFv10054/nUHaR8tngqKy5pddudGF8s2LEVOJjemeUo0usUjB10sTo2/6rZGG41V1sZg5qs+2b28XmXjECDAW+9TWVTsHvc83JwLprZVNGeBW3YDpGV9O4Iptuk4RLcLS1AhdHvliG/bTkftU8z1KX98NC+6tTjIYRt3ahmyd/Tflsz+Xv3yIV7zijfxvO96xTIrF10jxEGB0TIyvZ3WYrAreip9JjdJNL4PQ8jdPaOIbiv6HLRiyAq51RP9SXwDixMK7QEE/u4Tr3mytdDBca5fSeQSXvrU/HMVcwTUUSPUytg1jF+RiP9MAeu1fIsnBjvh+H5oUbK+ZXTaGZZjMAtof5rR
 G8JesgW9
 If4Utq+mX+kIx2W1BbZMqjUXmiZ1o3CDguYZ9Fz2FmyjVCvQD3qZxlCeWBMSHAu8Yb65om8UP86CSH0j2QW2yOZE2dhDumOOemaJSKsohNYA9D/y5viefqbWf8mUUj0i3g3twn23c2HSxn3LdNCYHV16/7oT6gUvWbKf4Elee0KsuiA9wNWaK3B+0Cc1cnG6dYSM8nH3w0v4Qna7P9DazGJww8P6D1vajN98GDIhuXXppP0Q++OJAAvFmFjiwCwlGVcXiYRnT91jBfGKR/Uf63AG3/mNiPOavSX1jONmWnEywHAYHvNh+zf6xlAIaDn8L2Ne8EQO3QVYY+iPDWJS3+VS22UQuLhFWZl//LCcCE979Tm829buHp/a89txNT0M/9sKh/z4v+q+BZcOZ7l+Zp5hIdqD68ROWwNm3+ywYTsVH3Y8/j5S0lna7jUHTcvT2oSHPIb/dLhCucWG/RD0B//5/Hv/5rmQmrYwCEhHVYkb+cBRzqkAmYEkbtiC76iqCK0AyBRbx8IaegwyPg9o5me69t0Jki5MsU2juEw+YbfneGtKvQjCIRJY1PLXp+nEFMkSmkEW9IIgyI7wV5jxINinWiys1UCrK0W1huSfo8OQVcAGbSo+VXvtYQUAotf9cOCnVx2x8CEQUT2zb+2xd2MaCqXHPDkReRmNKNMJEhzUx1olMILGFxXXpgUoWEvlXNhvpXdkJm1sbh3EgtdqCCr0TJ8Cy0PAQSDZviNuBuS5ddze4YGWfEjrgJTOIEi1uTZb5PPgsExRbkvdfodVbNw9Pdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

k[v]free_rcu() repurposes two fields of struct rcu_head: 'func' to store
the start address of the object, and 'next' to link objects.

However, using 'func' to store the start address is unnecessary:

  1. slab can get the start address from the address of struct rcu_head
     field via nearest_obj(), and

  2. vmalloc and large kmalloc can get the start address by aligning
     down the address of the struct rcu_head field to the page boundary.

Therefore, allow an 8-byte (on 64-bit) field (of a new type called
struct rcu_ptr) to be used with k[v]free_rcu() with two arguments.

Some users use both call_rcu() and k[v]free_rcu() to process callbacks
(e.g., maple tree), so it makes sense to have struct rcu_head field
to handle both cases. However, many users that simply free objects via
kvfree_rcu() can save one pointer by using struct rcu_ptr instead of
struct rcu_head.

Note that struct rcu_ptr is a single pointer only when
CONFIG_KVFREE_RCU_BATCHED=y. To keep kvfree_rcu() implementation minimal
when CONFIG_KVFREE_RCU_BATCHED is disabled, struct rcu_ptr is the size
as struct rcu_head, and the implementation of kvfree_rcu() remains
unchanged in that configuration.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/rcupdate.h | 61 +++++++++++++++++++++++++++-------------
 include/linux/types.h    |  9 ++++++
 mm/slab_common.c         | 40 +++++++++++++++-----------
 3 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c5b30054cd01..8924edf7e8c1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1059,22 +1059,30 @@ static inline void rcu_read_unlock_migrate(void)
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr: pointer to kfree for double-argument invocations.
- * @rhf: the name of the struct rcu_head within the type of @ptr.
+ * @rf: the name of the struct rcu_head or struct rcu_ptr within the type of @ptr.
  *
  * Many rcu callbacks functions just call kfree() on the base structure.
  * These functions are trivial, but their size adds up, and furthermore
  * when they are used in a kernel module, that module must invoke the
  * high-latency rcu_barrier() function at module-unload time.
+ * The kfree_rcu() function handles this issue by batching.
  *
- * The kfree_rcu() function handles this issue. In order to have a universal
- * callback function handling different offsets of rcu_head, the callback needs
- * to determine the starting address of the freed object, which can be a large
- * kmalloc or vmalloc allocation. To allow simply aligning the pointer down to
- * page boundary for those, only offsets up to 4095 bytes can be accommodated.
- * If the offset is larger than 4095 bytes, a compile-time error will
- * be generated in kvfree_rcu_arg_2(). If this error is triggered, you can
- * either fall back to use of call_rcu() or rearrange the structure to
- * position the rcu_head structure into the first 4096 bytes.
+ * Typically, struct rcu_head is used to process RCU callbacks, but it requires
+ * two pointers. However, since kfree_rcu() uses kfree() as the callback
+ * function, it can process callbacks with struct rcu_ptr, which is only
+ * one pointer in size (unless !CONFIG_KVFREE_RCU_BATCHED).
+ *
+ * The type of @rf can be either struct rcu_head or struct rcu_ptr, and when
+ * possible, it is recommended to use struct rcu_ptr due to its smaller size.
+ *
+ * In order to have a universal callback function handling different offsets
+ * of @rf, the callback needs to determine the starting address of the freed
+ * object, which can be a large kmalloc or vmalloc allocation. To allow simply
+ * aligning the pointer down to page boundary for those, only offsets up to
+ * 4095 bytes can be accommodated. If the offset is larger than 4095 bytes,
+ * a compile-time error will be generated in kvfree_rcu_arg_2().
+ * If this error is triggered, you can either fall back to use of call_rcu()
+ * or rearrange the structure to position @rf into the first 4096 bytes.
  *
  * The object to be freed can be allocated either by kmalloc() or
  * kmem_cache_alloc().
@@ -1084,8 +1092,8 @@ static inline void rcu_read_unlock_migrate(void)
  * The BUILD_BUG_ON check must not involve any function calls, hence the
  * checks are done in macros here.
  */
-#define kfree_rcu(ptr, rhf) kvfree_rcu_arg_2(ptr, rhf)
-#define kvfree_rcu(ptr, rhf) kvfree_rcu_arg_2(ptr, rhf)
+#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
+#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
 
 /**
  * kfree_rcu_mightsleep() - kfree an object after a grace period.
@@ -1107,22 +1115,37 @@ static inline void rcu_read_unlock_migrate(void)
 #define kfree_rcu_mightsleep(ptr) kvfree_rcu_arg_1(ptr)
 #define kvfree_rcu_mightsleep(ptr) kvfree_rcu_arg_1(ptr)
 
-/*
- * In mm/slab_common.c, no suitable header to include here.
- */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr);
+
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr);
+#define kvfree_call_rcu(head, ptr) \
+	_Generic((head), \
+		struct rcu_head *: kvfree_call_rcu_ptr,		\
+		struct rcu_ptr *: kvfree_call_rcu_ptr,		\
+		void *: kvfree_call_rcu_ptr			\
+	)((struct rcu_ptr *)(head), (ptr))
+#else
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr);
+static_assert(sizeof(struct rcu_head) == sizeof(struct rcu_ptr));
+#define kvfree_call_rcu(head, ptr) \
+	_Generic((head), \
+		struct rcu_head *: kvfree_call_rcu_head,	\
+		struct rcu_ptr *: kvfree_call_rcu_head,		\
+		void *: kvfree_call_rcu_head			\
+	)((struct rcu_head *)(head), (ptr))
+#endif
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
  * comment of kfree_rcu() for details.
  */
-#define kvfree_rcu_arg_2(ptr, rhf)					\
+#define kvfree_rcu_arg_2(ptr, rf)					\
 do {									\
 	typeof (ptr) ___p = (ptr);					\
 									\
 	if (___p) {							\
-		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);	\
-		kvfree_call_rcu(&((___p)->rhf), (void *) (___p));	\
+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rf) >= 4096);	\
+		kvfree_call_rcu(&((___p)->rf), (void *) (___p));	\
 	}								\
 } while (0)
 
diff --git a/include/linux/types.h b/include/linux/types.h
index d4437e9c452c..e5596ebab29c 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -245,6 +245,15 @@ struct callback_head {
 } __attribute__((aligned(sizeof(void *))));
 #define rcu_head callback_head
 
+
+struct rcu_ptr {
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+	struct rcu_ptr *next;
+#else
+	struct callback_head;
+#endif
+} __attribute__((aligned(sizeof(void *))));
+
 typedef void (*rcu_callback_t)(struct rcu_head *head);
 typedef void (*call_rcu_func_t)(struct rcu_head *head, rcu_callback_t func);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..3ec99a5463d3 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1265,7 +1265,7 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
 #ifndef CONFIG_KVFREE_RCU_BATCHED
 
-void kvfree_call_rcu(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
 {
 	if (head) {
 		kasan_record_aux_stack(ptr);
@@ -1278,7 +1278,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	synchronize_rcu();
 	kvfree(ptr);
 }
-EXPORT_SYMBOL_GPL(kvfree_call_rcu);
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_head);
 
 void __init kvfree_rcu_init(void)
 {
@@ -1346,7 +1346,7 @@ struct kvfree_rcu_bulk_data {
 
 struct kfree_rcu_cpu_work {
 	struct rcu_work rcu_work;
-	struct rcu_head *head_free;
+	struct rcu_ptr *head_free;
 	struct rcu_gp_oldstate head_free_gp_snap;
 	struct list_head bulk_head_free[FREE_N_CHANNELS];
 	struct kfree_rcu_cpu *krcp;
@@ -1381,8 +1381,7 @@ struct kfree_rcu_cpu_work {
  */
 struct kfree_rcu_cpu {
 	// Objects queued on a linked list
-	// through their rcu_head structures.
-	struct rcu_head *head;
+	struct rcu_ptr *head;
 	unsigned long head_gp_snap;
 	atomic_t head_count;
 
@@ -1523,18 +1522,28 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
 }
 
 static void
-kvfree_rcu_list(struct rcu_head *head)
+kvfree_rcu_list(struct rcu_ptr *head)
 {
-	struct rcu_head *next;
+	struct rcu_ptr *next;
 
 	for (; head; head = next) {
-		void *ptr = (void *) head->func;
-		unsigned long offset = (void *) head - ptr;
+		void *ptr;
+		unsigned long offset;
+		struct slab *slab;
+
+		slab = virt_to_slab(head);
+		if (is_vmalloc_addr(head) || !slab)
+			ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
+		else
+			ptr = nearest_obj(slab->slab_cache, slab, head);
+		offset = (void *)head - ptr;
 
 		next = head->next;
 		debug_rcu_head_unqueue((struct rcu_head *)ptr);
 		rcu_lock_acquire(&rcu_callback_map);
-		trace_rcu_invoke_kvfree_callback("slab", head, offset);
+		trace_rcu_invoke_kvfree_callback("slab",
+						(struct rcu_head *)head,
+						offset);
 
 		kvfree(ptr);
 
@@ -1552,7 +1561,7 @@ static void kfree_rcu_work(struct work_struct *work)
 	unsigned long flags;
 	struct kvfree_rcu_bulk_data *bnode, *n;
 	struct list_head bulk_head[FREE_N_CHANNELS];
-	struct rcu_head *head;
+	struct rcu_ptr *head;
 	struct kfree_rcu_cpu *krcp;
 	struct kfree_rcu_cpu_work *krwp;
 	struct rcu_gp_oldstate head_gp_snap;
@@ -1675,7 +1684,7 @@ kvfree_rcu_drain_ready(struct kfree_rcu_cpu *krcp)
 {
 	struct list_head bulk_ready[FREE_N_CHANNELS];
 	struct kvfree_rcu_bulk_data *bnode, *n;
-	struct rcu_head *head_ready = NULL;
+	struct rcu_ptr *head_ready = NULL;
 	unsigned long flags;
 	int i;
 
@@ -1938,7 +1947,7 @@ void __init kfree_rcu_scheduler_running(void)
  * be free'd in workqueue context. This allows us to: batch requests together to
  * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
  */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 {
 	unsigned long flags;
 	struct kfree_rcu_cpu *krcp;
@@ -1960,7 +1969,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
 		// Probable double kfree_rcu(), just leak.
-		WARN_ONCE(1, "%s(): Double-freed call. rcu_head %p\n",
+		WARN_ONCE(1, "%s(): Double-freed call. rcu_ptr %p\n",
 			  __func__, head);
 
 		// Mark as success and leave.
@@ -1976,7 +1985,6 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 			// Inline if kvfree_rcu(one_arg) call.
 			goto unlock_return;
 
-		head->func = ptr;
 		head->next = krcp->head;
 		WRITE_ONCE(krcp->head, head);
 		atomic_inc(&krcp->head_count);
@@ -2012,7 +2020,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 		kvfree(ptr);
 	}
 }
-EXPORT_SYMBOL_GPL(kvfree_call_rcu);
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
 
 static inline void __kvfree_rcu_barrier(void)
 {
-- 
2.43.0


