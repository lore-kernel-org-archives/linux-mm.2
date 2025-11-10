Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93626CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 07:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9148E0012; Mon, 10 Nov 2025 02:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0FC8E0002; Mon, 10 Nov 2025 02:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89028E0012; Mon, 10 Nov 2025 02:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3D128E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 02:21:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 648954C9E6
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:21:32 +0000 (UTC)
X-FDA: 84093852024.22.93D9E90
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2589020007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:21:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oezdskAh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="BvrYAx/5";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762759289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kebk/abQbERcJkel31dZ1l+eudgm1OMX3/rbfGM9mmY=;
	b=S0PBp8bobsdcfpmd/n4ag3cbmwcdq/pfANOgk9GVj5SVCJ0IiDWvMCT4LnbSjTuMBWFZon
	QJfQBLp3ob7CZV3bnule0mAl44YqV1bfLhy3R3b0B3dJfnYPiRUCC8Oz8NHKAmIGHaArPU
	1VSR/cgWgrsmnNug6NULTEcR/0nh4s0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762759289; a=rsa-sha256;
	cv=pass;
	b=ImLBH5WhQOFe6q+BbsqkQ6a3kmWDUNrBh23d/qubbQNUrqp6hUUN7ina7PJR0w+qwhnV1d
	KDboBr20A/sUK/11669OkStK7D53XqsgTi1tPXzGVVLIcqydxo2PsI0uNHIHCd7gwkwTXa
	+alEEZa3lxhwCqsXY5RQcnEMlSsxTNk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oezdskAh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="BvrYAx/5";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA75vW0031240;
	Mon, 10 Nov 2025 07:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kebk/abQbERcJkel31
	dZ1l+eudgm1OMX3/rbfGM9mmY=; b=oezdskAhzHCFCzWCTrH/1QLojCZvMmFeYz
	LWk+1rCw5Xah9iUF9l5+4wfv+KYa9Dti8HFv85werrXviOXGEhX+mm1CGcuQ6gTy
	VZx8vBPQqVfJTYJVI+Ic3RCdCYG/kBw+M3+cyETRVxI9HaAok8wtVvMbypNNseOC
	l1sm9pS7OCMiOJ3wyP8bFrhwaAZsW+bvQGXugFItHDxNVkmD1hORTRWF6luSSY7+
	j8GKplNFxJYniZMolx9JLfIhQ5RibLnBqD7HAtoR1s/3RuDF0sqnzFnURGXHj2x8
	16EAH/78uWcr5a8/aU5LM3sFjvZ0zkV2sBra5eFmTr/D45CKYT7A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abbbp00jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 07:20:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA51mGi040109;
	Mon, 10 Nov 2025 07:20:54 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012042.outbound.protection.outlook.com [40.107.200.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va7srv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 07:20:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZ+O83duep/g0mcw4CivSyrkVHvswrGzE0ABvxTNvRlWVaiZBxvmbpM80nFDoAeoerPsFUH19onX4RmMh101fAMXLyBWdNNDo4CJBz3+EWaRJlj03VCfjlCeQFWNRI0EhTvvpJwEb56fT91gsySf8HYU7BH2q2xsumkcdpEhz7yg7F583pBr4shH/3ATjxMRrV0ZyRrTAl8PESZp2JKhhGbB+NFQeugJk2HmcotqLHgouqpk8Z0pLV7iAfCcuzhNztMJG7YCSkFrLwE84Nkc72PkYOUcmaToXecoeQuc1tdRTct9Nl9x+2fCVAMXWtXR26WnaoE7O+a0TVtjg49PRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kebk/abQbERcJkel31dZ1l+eudgm1OMX3/rbfGM9mmY=;
 b=xJhqnwKZSl7M4Ip5piPBfzWjB4wp0rCX+FvryoVdayyLPfZ9ODlTMDVCaTSvEHKgSXBrQAIaWpBbE5ptoygA7QgjW19UGCJRaV+TwpZvhmLqUc2ZLsVoWkealblMig+KQtxir9qGp6+HyJrldz09TTkBrwsb/OOAiNnfZG2qFN3I/CzTEi/LzteYGGD/EUVsKY76tXfq5EVHAhZ126pqTZDGehn36nkAXjYxiHTafSKR9Mt8jBDW3XO3ZY+UaWzRMkHVYVYjmtP8iGkdVALW+oIa5CmOWyyn59/36yt68lkvbAiXduUR+4zTb/S3IW6Bnd13zf3IfDuMhhFx2wgxFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kebk/abQbERcJkel31dZ1l+eudgm1OMX3/rbfGM9mmY=;
 b=BvrYAx/5wvYsFJls0/VwW4XOYFhHuyM2uALm8HFAc10nBrMabEqKZkPws0xYTUm8RgsVgT1fx/pBMsT3zY4Ucuywsrtdrto0+kzRkgM6sIx0BqCKd/fFgOLzMJXmtp2L2lfAJ25bhlKRcauTMJmoYRqm21ffkNKGcZku1ZC/UUY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4430.namprd10.prod.outlook.com (2603:10b6:a03:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 07:20:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 07:20:51 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-4-ankur.a.arora@oracle.com>
 <bd11e906-8d01-4e39-b385-f158520b589b@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 3/7] mm/highmem: introduce clear_user_highpages()
In-reply-to: <bd11e906-8d01-4e39-b385-f158520b589b@kernel.org>
Date: Sun, 09 Nov 2025 23:20:50 -0800
Message-ID: <874ir2cq0d.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:303:16d::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4430:EE_
X-MS-Office365-Filtering-Correlation-Id: 6531f7c2-da4e-4e63-be95-08de2029ad83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yph+ih/gTL7u2O3EyLuvFegdY/XLy/9uR1FcoCY7VJHp2+DAI/TwGuxDPuaq?=
 =?us-ascii?Q?IlHKcpsneEESvKLVcmphqmh9sEHZohZuN2cT9KYlBkuIrdd0Etb2SmaxM78X?=
 =?us-ascii?Q?Ib+6uAGNqDG0c7R9AuVxNud10JVuA5/nVwhTsiAgHQMnFL8pkPeTMp83KL+U?=
 =?us-ascii?Q?4KKFaDe80bWRxgcteJOOGUejxO66edfs4mrvMrGucfktMN2isKZIRq3fk6kp?=
 =?us-ascii?Q?uUidzskhL3NCqPShvkpAziTmvw3Hk8C62SwkO8gVPuBLpCZ8AH9Jm9amfdlz?=
 =?us-ascii?Q?VXDctMawAroAJER0VyTf6hjIPtk3YSRGAgxWYpPgJuyUJusX5hsv5dTFC5pq?=
 =?us-ascii?Q?G7bK0wnBHvk0HSdemb+/VywAzY9wWDJf9J8310QMg7CaKiNhtAs0HSiPjf8n?=
 =?us-ascii?Q?3oZxPVo6VsbBdia7KW9cccrwMr94GWEKo9euGdkxbYSDF5Ezi+yAe7+rcZp+?=
 =?us-ascii?Q?U5UjO77kfasHAxfZ/w7IP3rgI4xyPTqpPdNNz8oZgZ5sO7UlL6lg+ropVsKQ?=
 =?us-ascii?Q?3S58mlzQvRFHqLvMvckDnvEEgb+0A2fkc6om1AiE08lIip1efGGYW4tvNbx2?=
 =?us-ascii?Q?4I8uobqk8ob5WS8WIGf28Zy9sk//xgq5Q+shr7XLpV4yteqWZlW40NsrGEeA?=
 =?us-ascii?Q?6P63ajzcUSW+F1Pb2a3YYWs9lywcVHw4S4UEe3UaP2McpqrmaPanpRmJLv1B?=
 =?us-ascii?Q?SYVFaDvdiu+xaTkUwtLEjq6IHEeqFReLnO0ddS4sg1m6cHJX9q/8yQEM+EtM?=
 =?us-ascii?Q?J8J2SrDIWYmg3JVJZdrgZLt7LpL8rtnnjCWKhSkSH+8qSfNEuxto/mtBbAm0?=
 =?us-ascii?Q?8FyYZIUqgDVUACUb33BAnpgorz89jo2TvsSkZTk6IYu1NoxXVJugicS4rXan?=
 =?us-ascii?Q?H/0E6pZC7UHUFXNn1rqeCttvkkSe+q1vt92cClrcxjmFh64O0TlQe6/ioZpg?=
 =?us-ascii?Q?DzgwdSsk22oHRWkO0JPTn28L1bdkE60tYjtC5hBeFPo8KUF/LX6sZIxQRAZM?=
 =?us-ascii?Q?ZG8bI2KKszWxCdR2eW9N2B1shqRx44Sz8nyT+/VrCdpBNEzC175n3SOS+V9q?=
 =?us-ascii?Q?kI7nS00dXA4adX0rD+fumY6+LDvVQvPOpl/nHB+o0Pl8R3Va3JX3/loTezCI?=
 =?us-ascii?Q?sSUq2TZwPusxFWBEM/AA6QnT/4Y3IAPZopVb7eqv75GHPbIRI0MZHtpiacik?=
 =?us-ascii?Q?zsQuBS3tWX7G/iCfbvTlxNPxKUsWMUnfSqn1fqKkvZc870x69vhj4MteyoqL?=
 =?us-ascii?Q?hQ6Cw4sPnOktut4pLJfBQJQ1OHTdXwaE/wJ2OC8Ll7kAwXd8r11OYujDZLB9?=
 =?us-ascii?Q?BsAFIV6AH5voDiYXJMPuqw8EUHordyhKbf8MwyOVJoCz+Qrpw2VT0Y2qQkFh?=
 =?us-ascii?Q?V3cw4NDUirTv9KHVnHQVCAigmpnTdHXxAMGVqDPeB2wHPGP2T7dvEXfiB+qN?=
 =?us-ascii?Q?giFeEBA5F/5hJrCN/0+yRAY5o09U1F8T?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aoDdhd3WYg4jRg47MUw5UAdOzvARr6AW25g21EXxEGeVGOVmHnXgWkt16sum?=
 =?us-ascii?Q?a8DO0XooV99z1RTRI39y077btZ+lSvns9LxSdT/GsbKB4sJ7zp//MXpJLHzL?=
 =?us-ascii?Q?1rv7y4v+SoHMSpG7Jr4d1QSI7N3Crb2RT/EuGP3vZaqoGK72tMhzLIUmyiSA?=
 =?us-ascii?Q?FA/FrJZuJdDFX3PkgnyfiBWYHmas7/utgQtEiN9BVEWdTLIM2iQtDQLtBUr+?=
 =?us-ascii?Q?sbPWx0u0oj3o0DPwvVeIW4BbNzDct7fuck4mSPmBnZhdppk0URBAZ6epsy/l?=
 =?us-ascii?Q?FJL2MijQxachg2JUmkn54pal3uTYIMoJatOrDXXegTsUjgGR+r4qMrwo954t?=
 =?us-ascii?Q?XoalOBXKvLsrejo5i/6lVJKrrj8mX8Tpjznoc3elOujzFEuoTzne4n7Ojz1I?=
 =?us-ascii?Q?YlWbjmUalqh8rFdS8PEMKxNNEyr3zVG9e70btHyG6VBs6GSxvCsLx4QQkhNy?=
 =?us-ascii?Q?7IZeIxqY1i84AvDwNK4w08y5AM/gMbLGTzh/9Ns4E1n1sJ6UeVCH+iTJNioC?=
 =?us-ascii?Q?L3MVm5bb4vutTrGugfKVxVLj6w7zKRKbSH0aMTMlsWt3IgMm78g/UZQ2V1T3?=
 =?us-ascii?Q?Jnlc0xlaOycMJ+r3w0G3sDa8+n2HX17jgS4GEWvndqxaE7EMWxHJuzuIXWAm?=
 =?us-ascii?Q?Obhj+yDMduV68w6aOOcsAlMG/2U5iavxjl702JfSO/ZlE2tZQKeJNPKQ1NYj?=
 =?us-ascii?Q?/RZg4NG0pUqWHENsbmrsc5fmG2P5rWj5f3dHRGAFttHyCloNXBoGKnfz67Cg?=
 =?us-ascii?Q?t58GS1VlT59WbkdzRqeWivaULOdgsieiQqphEFsUk0ooeT+wDXgS1bgfnhjh?=
 =?us-ascii?Q?u9JJDE739rDhejc6WDB0TBVXvsb7QqEQACADG8zz52DMln68fLwW82OG6UgB?=
 =?us-ascii?Q?TtN3SpkQK1RCxtc1E68CXjsrLBfHY84kRPfctTuODbHY+qrIbhQzDau3YpBR?=
 =?us-ascii?Q?BMIFT2VkyeiJUx8K9q18AY+CDrbyawRBnFKge4FNnnQxEUZbgbdJeXCutBcb?=
 =?us-ascii?Q?lvD6f52f+YFPJRgukN4xW36KfbomvQCJivPi+kFc2UcXEFG/aZfZkpX/BPOa?=
 =?us-ascii?Q?qa3rPp3Q3qzMgjlbrV47zqyGEdY3/hi7Vz/C+MD+qgg33IOCRQnkSsyPFMOA?=
 =?us-ascii?Q?U3/4TqGpHnLX/Y8cbq66JbRK+RYaEdA5WTxl2ZBk1eOw3dW/oIr3xPMa0Wh6?=
 =?us-ascii?Q?15t5sM8WB0aRj8mlMq8pRgW0VVNxoVOPJUJq4IYSnyNgI2Tkaprdp4ESZtnC?=
 =?us-ascii?Q?W7K2TmW3XDq7c0V7aOWAuWsCpMt3JVvEoWJNbtfXmnsHiUQwlXUNcPol2vH5?=
 =?us-ascii?Q?R2if5hPX2OT1kkZBrxcLygqwdUzsFeexpHNFA6sv9e3ywxIwVZPT+JzixAuv?=
 =?us-ascii?Q?omwaJWupbSgtoorqAvs9aLjekblPU6AoRdsQaK8KY2SAg6aIJZU6Z8FPK2mX?=
 =?us-ascii?Q?zUUhu0UVutO4kC0brFoT6bEM8Z/Ys5LeuBbNgieCz3qbDdh2F99ZY8MoMd0j?=
 =?us-ascii?Q?GtT5VaJDhxKW++5qdG2Cb7X6rB9a/LlCCrtPqo8/NlBMQifeIj9pG1iZi2ju?=
 =?us-ascii?Q?cQIdze4mbKJ+5Zzi4PRJvlUGnw0OTPipq4qGvrt3rRenw8ZrejbNovnT+YiE?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TYbEfI4v0DGJXXv/BzJGQQJfkuolQoAgjLt/s/wL/ZDHf+j/6fwouf2Rz8D9C6O0je9ALfYx6/ZPpd07UiUSouznOXJVGNmxyMVsG9g2b2vPRcyI2KuK2VqfKFuRV5HJxYxuvDKzUQbEhDqIVnsB6YxVdth27eMmPJF3Z3UyWgmfz9rRkSXHjT6ZN6wEnBrUXWjYDSExrz3H29AQtjcQ0dXbES4anh0obFY1nNeN+1geu2dqd3/4TY8m5LX+Ony5Zx7la6bT68E4KcoXPREorJMtFgt0WVUEUnBVbiGcqkjLD9bzBDgYIefrgnoscRy1u8Mf6AGaY++cjmIsoDNOoynmbzP18JinrtkCxC8N8zhgr/4tjUhjYwdZSaRvwfefo8AMALJxklgssLdo+vxdZkXTQ1wSNumcDDy8pFKzbkHPSfDYpA2AcY3ZW1Hs6XjYjHjeNPI5CtoVyAW3ongrA4i3QHw79CnQQBAXxvV8Umr+clWdpNfznVL5HZrIpM0LhEXEeNR6Um8FHmG2fkFNsEYl5cSvtlJb8IJMtWr5jIr1rh6VgfDDNYaABj8J3QxllXovmTMtN577T6p6rjOBSinZsItpe79XYiM18wnQDY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6531f7c2-da4e-4e63-be95-08de2029ad83
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 07:20:51.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/APmXJj9ewN9mn3PifAF56R4fB3FvHssGkR2Eo9WhSuCNbOF6T+JGW7Y0TEqjovsgNIzmXoXhIhLXVtzaXlf7jHgNC7533mxAXukTbC4L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4430
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100063
X-Proofpoint-GUID: PxcoEd5COPCKSKeEGEkZYTJ7Ji9IY2bY
X-Authority-Analysis: v=2.4 cv=FIgWBuos c=1 sm=1 tr=0 ts=69119256 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=_0lRPuehjkuax0JPf5cA:9
X-Proofpoint-ORIG-GUID: PxcoEd5COPCKSKeEGEkZYTJ7Ji9IY2bY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA1OSBTYWx0ZWRfX+lOkI0mOUE5z
 lJKkJMducAX3eCbjCCCW8QA3HHKh5cfElM6nqlb/If2RMXBVf6jfp2hCjMCktDnJPYFE9jh260z
 0v3b5ekGS0iYmSfmIcbx2ZOLMCexYQ2jBE8Nyj+weHigWjDRlMzCUxDZnsdIMhG7Z8akAXuqH6o
 gBwseH1IblRR0EM+I9dKeSsiTLtUPsaGbw88/s2tgF1d8TEZZSqiUyz09Jpy0LCBCrtpT5lnRZC
 uMdjeHSlHsa8tHLhQyI2g4/FUeFh20UDSUNJkVN//DFuNal0FhBWKQmiVMP4j23eFskJAFcWMvA
 CFoY/V24MWjJ/UsfJE+RSwkVHtQ5eYYbAveClMKsVQu3iJFmQjqq9nXJgL7takYzmc4KrkOZhGz
 J+42lUEKnRvpd/qtISdUCiotMGiccg==
X-Stat-Signature: g4bapaa3oz1fp7qu9ee7ni5of1cx9p65
X-Rspam-User: 
X-Rspamd-Queue-Id: 2589020007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762759288-932540
X-HE-Meta: U2FsdGVkX1/lLUGBpWUq/AKiCI6mq9dLBbXItq2GJ/nhtbObs+g9NgwIFoh/dGW6Um7l1pQXmPZZ+A1v2C0EUbforUrHHB4tgYhO30AXgwGQUKDYHE+EwPoCLPrOd0d3ikdUqeL11JCMkmX2yivPVoqGDJvc6Ztfj1ZWwQSiCzSnH14NTdAmblRivtQT7yIVv+mvUNMPx8MZ9yrJlLn7/ejTGtXZVb9XyEpxQJnArWn5GKOf0xl/OgErMxeq1+bcoAmXIAyv3r6sNBWZgIrXrWcYOtK0nAUeXgnt8Euo4z6lrDUq95cqiI9qjtI1gzrp3aHSgw53XMMizQOpc1ogPx9Tjm0CWnrXFgeXVGXbzEDKFwtrsowvIh4JPCg2muJtrgIdZwsD1RzKP7duDrOfrZEX+MpiyMoIV2kyzMX/V1mTmRk58pa6cktLf4EK3rks1C2F3PtLeVWBHYV2dRqslDPC028Suh7X5xTuB/CQi5V1TkRLcF95ToAiMl/bdLfcd/E8ZhEWJoAZdX93brXrIrNEFb9ONdse/Ikpl4R433RbyCr26czSl9Kga5tdBo3+fqPU/gRPNdfc+hjZM19C1BfwfflDhfU87xd/yXzh01p2j3DXolAz/toPdFxSj7n472Aya5dmkXdI0lwL5edu9+WpMSSAdSF3P9Vkca2tb1nX5BQEJUubkSFphKOnnufP58X/EUiQ4FCPsqnRZyyDLJAur+fN8PfLGtfYo1eGSmv3Tfd3dlTFPDRgDaXG9WKSNXQM2eC0yFQJsGl6ARtf4yfgeUz4U9wR45CvkM/+HK4Ys50ubRjURu7HZfMBTiHyTZI04/msk1s4qdI067Dz/xVY4qNqNGTVdGzt4+5Z6Ef/HeEp9jGaRZ0xyb4F27uzDi1aX4dKL6YygmoJmk0rZTlk+kws1k51RNxNyN5H9Vp8a1rpldsKOe6k7vbbmqlGR4Sskkrm9Jz1Xsw40OE
 bJR9qtgH
 vaHyYX5Pu0Y4SEW6eeiYbodeZeam4U9Wwop28SjSha7wb28nFY4w/amcB2VOLxArtePL6omyrZ6fl4eNyxhVYB/hTRqc01Y6qhkyCTzQPZJoa3YfS+v2bGsIPVlH6NlUKL9Ck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 27.10.25 21:21, Ankur Arora wrote:
>> Define clear_user_highpages() which clears pages sequentially using
>> the single page variant.
>> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
>> primitive clear_user_pages().
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> Note: fixed
>
> That should be dropped.
>
>> ---
>>   include/linux/highmem.h | 29 +++++++++++++++++++++++++++++
>>   1 file changed, 29 insertions(+)
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index 105cc4c00cc3..c5f8b1556fd7 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -199,6 +199,11 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
>>     /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
>>   #ifndef clear_user_highpage
>> +/**
>> + * clear_user_highpage() - clear a page to be mapped to user space
>> + * @page: start page
>> + * @vaddr: start address of the user mapping
>> + */
>>   static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>>   {
>>   	void *addr = kmap_local_page(page);
>> @@ -207,6 +212,30 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>>   }
>>   #endif
>>   +/**
>> + * clear_user_highpages() - clear a page range to be mapped to user space
>> + * @page: start page
>> + * @vaddr: start address of the user mapping
>> + * @npages: number of pages
>> + *
>> + * Assumes that all the pages in the region (@page, +@npages) are valid
>> + * so this does no exception handling.
>> + */
>> +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>> +					unsigned int npages)
>> +{
>> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>> +		clear_user_pages(page_address(page), vaddr, page, npages);
>> +		return;
>> +	}
>> +
>> +	do {
>> +		clear_user_highpage(page, vaddr);
>> +		vaddr += PAGE_SIZE;
>> +		page++;
>> +	} while (--npages);
>> +}
>> +
>>   #ifndef vma_alloc_zeroed_movable_folio
>>   /**
>>    * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks (for this and the others.)

--
ankur

