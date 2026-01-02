Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21688FA3758
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 20:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A88A6B0088; Fri,  2 Jan 2026 15:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C536B0089; Fri,  2 Jan 2026 15:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3B46B008A; Fri,  2 Jan 2026 15:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16BB36B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:55:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B227F5D2B5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 20:55:37 +0000 (UTC)
X-FDA: 84288229914.08.F7B7402
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4D82B160002
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 20:55:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="LzFFq/2e";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjbZYq8W;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767387334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9x57R5oSQ/ZySRhUgCwdPtlsOC20S2NS5Z+SbQIZGvY=;
	b=H1oLqVXjwyVU9P6SNyyOD3FZ8673hV6C5DKwHSgoRWMWqSLros8oYONZFLaaFhmyNbzU8v
	q1tpNAQQAYxNvzf9pz485mX0VHAsBoX26bC7ZMiK3TPgdXqD9fEy73kqvmTGO2xCxPWZXd
	UqQvlE0YtnGRe4nHlZCNFyK7UiJKw1U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="LzFFq/2e";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HjbZYq8W;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767387334; a=rsa-sha256;
	cv=pass;
	b=zfrIAhJ0CPwl4laL2lYtAhvTSJhgQHK63GZnMXviBCtuP6nBKQkGZbgDL7qUbiF4B1qtaO
	kPvCDMxeeKvPl/205SYG5OW9iZ+XhQ2j537zRGJMk5b/eN/VmyXd0Z+Bl4NmVA9wXcMWzU
	qGvaOPacUKKibFYcDdLhM9g1kxUzDlw=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602KUiCe3562843;
	Fri, 2 Jan 2026 20:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=9x57R5oSQ/ZySRhU
	gCwdPtlsOC20S2NS5Z+SbQIZGvY=; b=LzFFq/2e82EdeX8ZBfyePdBkZpCJTIE/
	gCKxjkclmnwPdpDBIOlE9rk1xhlMsWKCtvLt+isXKI3Z4RNeyQMT30w/Er3xzU6t
	a5LllApq2hSRUABzV9/6NwSxkiThhOpAw07IaxvEutipZ13BjMXA8wAOtlu36gm3
	Ccok4Y2vO3hvceCWHP5x64s4o+tztAM0oWp/L6kEBBcLg8QZ4oxMEA0SxMDO8puO
	E/uEvw/d/ZZgqPX1ZRNdlaTQ9RgirQ8ch33JOjGOHXMaxvMj4ZbOnH/TT5/nzix2
	+nZHESmI1Or0GLPPdpSd4fMroXxiuNyOLVlQ6iIuDvsZAkc8AkN+HQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba61wdg5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 20:55:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602Js1dt014251;
	Fri, 2 Jan 2026 20:55:24 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011070.outbound.protection.outlook.com [40.93.194.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5we5err-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 20:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G+mHnkwGCz75iWs5Qe8va2d/7aY4eOOgaYuNk4RTC+Etb8uTcoNfg67FJqE4FbhMl2xrY/9VfDqhpz2q+WrQGhRJNkAvjsQJbhFpmAkgCzEH1djL8Z3ABjwHsBvvMqjCh8+4LUWGlMbMVW2uf9OE4x4q0mapGUs8IO2TIZ7Q9BGO4C4+vQWF5tjy95FjOmKwdt/B9cKFF1vZKU5UueCZJ1ceENRgte7xYTouNVBVLxh7YW+0jtpwn5hGx1FrVfE1ldTZh7QlMDQ+bOit3DoN0lzqNwt8FgQ/mlFOAUUYcuZ5aZz0bSQWFvnvFwYiOwYlXhBZjK2fNM9JXOdb3AV5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9x57R5oSQ/ZySRhUgCwdPtlsOC20S2NS5Z+SbQIZGvY=;
 b=YR37lWiZaBNmSGW8JUkP1Pa9yuC7/TkqNDAhEO3Md+wtsZLJb+T8jHC0r1FWM96anvI1f4Z0/rAIHuB3C45MoePMIAGGt5UDn9cxHjOFci8SOMO/8/+LBE8RNykJjg/pjOJ1CWB1+PPvxanwqVpDoWOdth5Yu+G8ehWkusCqNcAGZPjUPVrr2cxHmvWm1XpFpeU4/zy3QMv4GwichHtc84yfluWNlduHfuuUNOz4MOTY0sw3Df6ULAHYLzFqdmrVe8U4R+5GuAzthrpeIp7lq0yVovS8sNf7OUdS6ya/GtNLTKCF+4j4dlHCGFzTqtxhfdmBb1JX5hmUqCTNiUpSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9x57R5oSQ/ZySRhUgCwdPtlsOC20S2NS5Z+SbQIZGvY=;
 b=HjbZYq8WW7N0Uu7zX2JMY+tHWvC8Xeh4rGAS+IGjtz583w6jxplyR6mUuec/moTivD+lUVXm+qPZysdhEJBVGUg4j/L28LzdgjZ8nlade4lwuswjknbbIT+f/i/PuzpylLwNqlE/OY88ymS1n+xONr19gfAOvrQSBI3o84/jzn0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPFCBE2A5DAD.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7cd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 20:55:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 20:55:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
Date: Fri,  2 Jan 2026 20:55:20 +0000
Message-ID: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO0P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPFCBE2A5DAD:EE_
X-MS-Office365-Filtering-Correlation-Id: 387ca06d-6b4d-4d01-e750-08de4a413d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V04S9g34MobV/CFYN6EqpoKrN3IRoFSbb7gUxKDqfRuziAIjam71AsJI4Leb?=
 =?us-ascii?Q?3azJCM7dVRAtZv7x34e7AI3ZBws4Z3tcb8QuW2V0UMG3SZnAij3FA4ciY1g7?=
 =?us-ascii?Q?JF7phaRGcWUklPnsWnAJoSrs4WctnYqpHYYDKAu8aq7RzTjvwsOCVBPRlwo4?=
 =?us-ascii?Q?iL3Vb6dla1WzbVJ9PCTWHERKJJcAovptDi4KxNm5KZtmsxld4c7tbAI1BQce?=
 =?us-ascii?Q?iz95RLxZxSB8fYxBKS7bNkH45n0hGbdjfSErCtQCYEZTXhlC8g19bMGnlgE0?=
 =?us-ascii?Q?WHaQn9KZWXtoNvOWNiX6b6TRe6/anEr+R/dRzBL0fCbHn/s6TclpjptpFv4C?=
 =?us-ascii?Q?/KCRv5vj3Tye+vvtfJ1Uh650nsDhlkt8C6Spcq5XT4QjUjmo5jt8N+Ny6h9s?=
 =?us-ascii?Q?0i1MdhYuka9fTRiCYP5JqaWZjlmJKYVZNgcJG2KsZIjEu4gVXO5gRSrab61a?=
 =?us-ascii?Q?rAZ+PIMpZXyRcevNScSgNiuIKZlBaSxCy4HRsLof6M7TOWjlFZuLQFhqiUVw?=
 =?us-ascii?Q?ovo2oKHsCxtpWoyYy3mh4nrGpgU0+F31+XTgnGvnjI4Gfx+9l4a3kQWln+mi?=
 =?us-ascii?Q?nBntPxNAI65C1r0KYnhu/2nZZT5btyGoFc8TevAfeq4szlFKJXoZPZ8DzXeO?=
 =?us-ascii?Q?2YZxiNe2qJ0v4aIoKLUakEmbdQhc9BKo1uaxXTmw2B8Wygk2gSo6cmoIJ/ny?=
 =?us-ascii?Q?MoSkGa900hdMwJhMq0wdrZQMB7jF4LtOhcCVdNEdgXf/JhoFodDCsMyboldf?=
 =?us-ascii?Q?Nw1/CwticSJGb7Kik2FOhiNsuXPd/SZTbAhf7zGoyvAL/sNGgKKjgMKNIHWP?=
 =?us-ascii?Q?bInDXjhqnWJvidwoRDSj3fScrrGlpBjucnmhneAnDkW2HpCMj/RqNsQZJ7dz?=
 =?us-ascii?Q?SCGxDPpJhVGqQoEctiLj6b2KF+H0JP64bAir8fl9rEWr1qQ7FiAtRj0aAPAk?=
 =?us-ascii?Q?XjlrEMXN3xCHEXQqzVTwzfzywbyr5jOaUTsNQaRgdO6DpAclLSoEVl6lfX0I?=
 =?us-ascii?Q?dKwSw9O52gYglFTnzCRBDNZKpDNzoD2HJ7i2FfF9T9HH/kLx9ZVZqofGoSH4?=
 =?us-ascii?Q?hbeWwZ3cJiAuVasxFxYLvEqLcmh+8uZ4wk5jh5LnrLc0O28GZR8JJGBQUwPP?=
 =?us-ascii?Q?/l4yQQAAzfkxeh+VG3TzewsgyowOH/ShZ0Y7vSeD8qjRVW2iCNxDJGFa4UUE?=
 =?us-ascii?Q?KDGFkQVEM99u1VIIiDEH+WV7QahCMSlptS4mUL6gNyCEfyjuVqMZdTUvEVhp?=
 =?us-ascii?Q?M1E3z3MqqU2lasYTHiYDYHM46CVJdDot77aj6/XWC4FmtLN9xLP+3K/KBIxo?=
 =?us-ascii?Q?y7uSuwzh1ac0RCYBNtZA7RSHPOBa1yMddbUCqgFQtB4vPN1vDFEhdwX4Z1Gt?=
 =?us-ascii?Q?CPxhaaHhkY51lyeTu6GLVmJTNi80flQ11cUiSQekabnNu83EEDmJVgwuYYT0?=
 =?us-ascii?Q?zqYD2q0w3IaqaFHONfxPBkUmLXhX/VSgnZbr0q2LRuugVzfAeq0Y6A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qpG1lSDmZlxfO+4sYxk7/vN6NgUaoaDRodXAAqBafgrV7kCmafdSmfG5QNaJ?=
 =?us-ascii?Q?/c5fzUyshhb6qwzddZVWluxsPXc+NrQtd7DLwF0n3eqjVp8km7x7KK1iTHZd?=
 =?us-ascii?Q?UAKb8Qc2QqJNoMGYg7PvqXjEc9dPVemHDWzVvaBsPnbXTosh0pDM2e1GrJNP?=
 =?us-ascii?Q?yauZpxobdkBH//Sc3rZiLYnxK/5JkUflm8wU8+8XUFzoUr7dUBHA+zZG2k36?=
 =?us-ascii?Q?CM8uc7YEx6u6uqSu7tb1XsvLgxqy8hzVSmetKSa6CZKS09l/87CBY8Kui0/7?=
 =?us-ascii?Q?ndA/kpviFfBn4wlbk/F3K8od2sg+GSb7alN+7rKerIU/xS1CTmEhahulMMqx?=
 =?us-ascii?Q?eEeXSbsBhqe+yX71U/84LPbdUougbs8SIuNMoxX/CPlEw3Tfm2ICOXUH6Yeu?=
 =?us-ascii?Q?Es76OnZ822NmSjYreZFpCMBQpjw5IacpYBYf2V0Pyks43NgKpeVgu2HP6aPM?=
 =?us-ascii?Q?FTJ36dI1dBh7tFhpRIncZl3Z7axz9UX9cl3s0ZsGOR1tOIS3uhLCsnTOewF/?=
 =?us-ascii?Q?kPMu7BKAReniYkrjRYeEOXCiUU0x0PejaXkl05TwLSPWI8XlxkaknIYdqVuL?=
 =?us-ascii?Q?RP/i69c2s9dKim+nt5OWzO2RAovbUlmytHxCnNZGFvIH/NsfDPW1tLvzuL3T?=
 =?us-ascii?Q?n+Ont2nUDrsO32CWFVrX1WOj7YvGp8wnqYcK7g5kMNGr22hbBXb9JMwGns3+?=
 =?us-ascii?Q?fdemWBCIP6k2jP0otjdXoK/ZcJZitGXmfMcB0DaHpVONVTI/dQCNy6hjhLh1?=
 =?us-ascii?Q?9yGtssENQ4WJ2aBdlAGfOV1jD+8PolXaH887etzb2CxtDL30kjJo3pJ/cCc1?=
 =?us-ascii?Q?rbqrO1duY39838dJsMFG6GvqBF6BqRr9sKTi8rlAU0KjRNaLDWNTdaEFmbeO?=
 =?us-ascii?Q?xq9v2f0DwK+qYX1A4X3yC7ff+f1kXQw4ZFHlyzgyLs5mQB3ZCmnSMHh2YkAB?=
 =?us-ascii?Q?KHYwccayGq+ue3rpgzubobdAen+nCfMqlVXhWohVSzIwV/gjhthGe8GirU3W?=
 =?us-ascii?Q?KTRrao2/QT3Im7x33V1S84ZrkOWhVpjGucQfAy/ZHFAIFuyq5938TUFb2zWx?=
 =?us-ascii?Q?7Ar2nR7aT4sk0B1HhADG/PrDgdzASld6qbuTQmA1ZCkHxn1R52ZcejMtx/JL?=
 =?us-ascii?Q?qua/o3veIVk5yiBaA49v3h9MYYu/oKwWZf7aQsAp4j1ijp9z/3BM6AVhViw/?=
 =?us-ascii?Q?eJwSTKc8AwaT0GsWdkVetu233UqtcCrHWoY4ExlEmWCKCYmrReOm9N//wlHw?=
 =?us-ascii?Q?fAEK9gA4+OByFr1FNMWtqoioNL0lFi20oyroS8ktLuWlTxIJC3MZPI/3cRCh?=
 =?us-ascii?Q?+LxPKId1MtnWpUQxmrFaIYqj3UueO4JXYHvWJoPdkGU+EFwdHQDKBhW+NshG?=
 =?us-ascii?Q?U7C2341Fucioshsr2uMtbkNv3HvCT5z2Jv78YsrcT+XL3f/xicba4A9GFHwc?=
 =?us-ascii?Q?L4qew2f09HgOzfUnRCF2ophgeBGBP8K2XOjRDzHRPF0Q1LR6GHPXO22NMxSD?=
 =?us-ascii?Q?1VyDUAZtJHijP0bdxMT2ooAbG1ClJVzS683Krb0yTaJu/M6rVw6jv2xASe1o?=
 =?us-ascii?Q?YCGKjTmBt9MJL8X3ou0U3YDlIwqw+w9u4xDorT1xnu55faHWiRPtBhPrRNNK?=
 =?us-ascii?Q?8CV9qLkMnBXGoWds2pbiSh9W3GT0Y391u6cwiY2SCT8K3IfWZpfqGrWagjfq?=
 =?us-ascii?Q?i9dpJ+nLcIqSRHs/ESo9+9ADkbspSi09PVI47aa1IGhRu3WLsHNkbLpMs56B?=
 =?us-ascii?Q?w0kn32iUpn0hEzd3iJSfwdF9EiKv8D0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0dqjD13szPdm+U6+2XhbkHu+7G7WCAE8ASUtO2VMj/S8/7YNm6L3pWJTPsWrvjJYhqEbCHHBI4y0epqmGfStFmtTf5tCpxgXXcN/2coI608HycOdigl3jYvfrYCbHCzSRYt1gSlAKvYZxe+pq76y2cK9AjZCTQN96lrN4ujHN30UcqM9K6AOSuAFs0LRuk7o+um8zD/rJSBXWyxnsNGfbyXr6VCAVhOQ8vAz6byn4eH6B87JukBWbkml9+qDieyu/gg2lJufntkKOcylwZJvE2SjAi912GKenD7T7xdDYx4KPPYldQ3NLTIYiSZa2HipS9MagFNvJxbHFoJKNAXEi/VF9gGDR7u2H+U/Qx8HWjXCLdJ+uscFcyEy1VEGGSZkxc1oJQTkKqGAvtjTJnwnvOP0HiJx6Mj1xygYZVIu8ACEJPZ4xOyFDbWuGvSgbmR3b1KkTpn2tvTdry3NcSrK2rM8CWCEaHtQGkiR9hTiGUYHto2fL3ecIfZQMgOZI2r3df8iUZDuoapq1Ty8Z401+mqhpE/dMI91tG+iuoNzp1X88kALkpsVITGzd5FSfOy/jk2z7VqEDaHGFKrdYOv4jkERJYABnJuMEeiNoPWvjG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387ca06d-6b4d-4d01-e750-08de4a413d17
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 20:55:19.3350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LautT2Yvfdr/rgBPJQ/BaLGpx7x4ky5OWR8Lx6Jaxo1yBpjxSJjiomdqDEgMZ8t0B8+W7N/fC4K1f6MEkyx8UTTqTQlNeKSC/+Gbw5bVU80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCBE2A5DAD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=942 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020187
X-Authority-Analysis: v=2.4 cv=LL1rgZW9 c=1 sm=1 tr=0 ts=695830bd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=e_WHt9a-5von8bMIeEoA:9
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: 29AYibuYoR7VKPEshBMwgEanOeSiJ7mv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE4NyBTYWx0ZWRfX4C//8ZJQKnxY
 SeiP2G5u9F9VPIF0PJVnP0gRX2M4ibzTuIAcm5U9dmpzE30ABbZeXrxOQZeCtCK/TgpbNsaMHir
 qiBpEo44O0yFTU/MhPRXwzmzp/tD+3gaBjYuV0sU8W+q0smnd8a4nhtmEXjcKtXHK45BdpJLAy/
 DTzxHOzu+GrRCy/kXlPTW7Dlnn6RCKlSgAKZP3E1kLMLRT/+W9BYtEykKDa4N89v0VHNYEkC02U
 s9C9KvrtcK1DsyoKKL3Eb3xgzUZ7NFBS8N7mpEiiQgT1bXOdHDXFQIKkfkTKK44mzCs+NHZUWbX
 cBBqsyuv7gTDMPbNwdeeoHt1cowovCgT2kID0qDim/eUgHOhprzs0EStSSe6kHaqt/whzE3s49u
 Lbx0DPZxhTpjyfoNVhk9JP0h6CRfE/d8oGYBw7zikRjoUEVkh1JT5JSaE5tlZs4g0jDu9M8d8oz
 N57oNGC3BG6Hx0DADBivpkLjqKq2dZx3tFpkZGZY=
X-Proofpoint-GUID: 29AYibuYoR7VKPEshBMwgEanOeSiJ7mv
X-Rspamd-Server: rspam02
X-Stat-Signature: izjpdemrqtrfy9kkxr8hyj737c6sgmpa
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D82B160002
X-HE-Tag: 1767387334-847252
X-HE-Meta: U2FsdGVkX1+CjppNKd6EvTdk/TjQv9yobnyYT7bbdPJZKezzJtp0/nXmw3mssURzcZ9iuXy0vC25MVQZgOGEqyQTPzOW9SHqB6z6lz1Pkji46VoPr09JAI4geftlcRSrTVVE/dzszBMygauDp6e84rpInO+/hsgMvIwr33BkpPOQuJeZX6vWqRlDxqDT1Sd77wtrq8LBQqlWMPmHEn/+r8sskpLp50aaW9wkY317taz0XCa+58N7mLYkGtzNa+zOB9EPMZrs+UTqMs1yV1JpkXjgMIoRzl9NIf+oDPpM7X22bsNOflJkhlkWPOfOlR+SPogpud7k+jJljdiSYCnbOwOVppZbDCC7Zb3uH+vgcVQ4d0JqEr+U9ED+kdbodB0PcrnXGPHzABCIPhXRQzYt1UkDTGH2dIitJA/4fAiQvu65+HDpELjX6J1/3vlX09R4u7+AWJ1LetxUUmnJviZX3Nd+bXfAaCNpF2YHBjgamSloim7O9oNP9SssiFlvbQJBy01UllS8n2esvDsaCCz41FbCF+s16ZkHqPEXdnnZXMoPOBjfJyqXLFrP7IMlNh28v3pwYFLqhMtZif1aoHCnx+nHqkkMtvXfV5YXcJIItzDY3+4DehJuP8JAUqKEGCrEjEfuw4uc0rGrXPigoqngxfyt+SbHXRMpA3b1NuAvnoQBxOjgIyvwR83Mnt+CWXGFKh1GgzZzYVnA+o2VYcZgrkPM3ZLcIlxLvUTiAPKBKGJkHGH1Q0Cn/blthScZ5ZKLdAL7+AoypZiI9tOi58xNqoXEXQ5q2xVfQrpsVjL6JsOxWIUjDUVAJNbB02Jm2wpSX5HvWkcbcnlmBrPI3uK4fSduRMOz6Va5atpW493FuqccrxhoqLvXHGtnSaKRR0r0EY2QnJ+eNNkYlCQcCImEnov7CQVQ9lPlC1CFps6YN47iOTABlnFQ0MSAs5/Y2WzXHqs2xDK7e8uMgIq3ja7
 TIngxKBJ
 0kFtxohi+5JnMTXldrpmySHSt/0he1A7ybAbA29RZjAcfeQ7YrMTckP/TyItsE93glG1PFGw7bJ5DzWIhDyw2CecvdoZYetFn+knJQ02NYUfPsm8xSW1zjlqpc40W+riajqFQh4dMEy70Nhl2WUiDUMVSawSLUPPU6nKQhw3RV5jGMU43CtrXQ+iCkgTMLAw144o9RPFuLJF5oco5e1+/i7P+Yh1gSiY7RzZL7bTo95HX4cw0+33wO95hgLKku+7n6Inkpmzq1uFhgissPhMnX/w6YWJuSxAoP/H58Rrbb05LDGYJLIfeJBDLI3HQJoWgj36uY+Gj/37rZjmZehxaszzv4GMFHvK4BGG7xAhAat79K5Yh7Z7wdYcK+p8zRU/9d8iyp2DR1egtq38OIiVU2+37JNLOIQZV33OFwWNN8KM5R2J4yw9zES/HsUW6jFEWqnkd5Tgn607/vWtNYjNmKtoyqRsquC3/cUz7fUDR+2TClTKg9EwmbMdEbYPGAgq5OC+Sv6d9E+YW4Fbrn42P+C1Mcr9RxAfncieFwlg9T/7cOo1BEa3FRq3RXKgao0gmpu48yOCyIKhG4LbPdJ+Bxe1cgfXo3makDZdoqGSf/JaH+5aB0T98jwxfRiUvCptgU81FMsoE1oX1gY1z1dQhB9iAKsvZieoxvs2NSu8ljDdFc13yTeU/imoWPVR+clW1MHTB8Eg+4XBQfIVrKBZAgX6/V1pEaMK02UuVHi70T+bIu4oWfLjUv2stS0mM4TirREH1xiQOejxNPScgt4pImKw1uG9wEv7nesQF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
merges") introduced the ability to merge previously unavailable VMA merge
scenarios.

The key piece of logic introduced was the ability to merge a faulted VMA
immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
correctly handle anon_vma state.

In the case of the merge of an existing VMA (that is changing properties of
a VMA and then merging if those properties are shared by adjacent VMAs),
dup_anon_vma() is invoked correctly.

However in the case of the merge of a new VMA, a corner case peculiar to
mremap() was missed.

The issue is that vma_expand() only performs dup_anon_vma() if the target
(the VMA that will ultimately become the merged VMA): is not the next VMA,
i.e. the one that appears after the range in which the new VMA is to be
established.

A key insight here is that in all other cases other than mremap(), a new
VMA merge either expands an existing VMA, meaning that the target VMA will
be that VMA, or would have anon_vma be NULL.

Specifically:

* __mmap_region() - no anon_vma in place, initial mapping.
* do_brk_flags() - expanding an existing VMA.
* vma_merge_extend() - expanding an existing VMA.
* relocate_vma_down() - no anon_vma in place, initial mapping.

In addition, we are in the unique situation of needing to duplicate
anon_vma state from a VMA that is neither the previous or next VMA being
merged with.

To account for this, introduce a new field in struct vma_merge_struct
specifically for the mremap() case, and update vma_expand() to explicitly
check for this case and invoke dup_anon_vma() to ensure anon_vma state is
correctly propagated.

This issue can be observed most directly by invoked mremap() to move around
a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
specified.

This will result in unlink_anon_vmas() being called after failing to
duplicate anon_vma state to the target VMA, which results in the anon_vma
itself being freed with folios still possessing dangling pointers to the
anon_vma and thus a use-after-free bug.

This bug was discovered via a syzbot report, which this patch resolves.

The following program reproduces the issue (and is fixed by this patch):

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#define RESERVED_PGS	(100)
#define VMA_A_PGS	(10)
#define VMA_B_PGS	(10)
#define NUM_ITERS	(1000)

static void trigger_bug(void)
{
	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
	char *reserved, *ptr_a, *ptr_b;

	/*
	 * The goal here is to achieve:
	 *
	 * mremap() with MREMAP_DONTUNMAP such that A and B merge:
	 *
	 *      |-------------------------|
	 *      |                         |
	 *      |    |-----------|   |---------|
	 *      v    | unfaulted |   | faulted |
	 *           |-----------|   |---------|
	 *                 B              A
	 *
	 * Then unmap VMA A to trigger the bug.
	 */

	/* Reserve a region of memory to operate in. */
	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
			MAP_PRIVATE | MAP_ANON, -1, 0);
	if (reserved == MAP_FAILED) {
		perror("mmap reserved");
		exit(EXIT_FAILURE);
	}

	/* Map VMA A into place. */
	ptr_a = mmap(&reserved[page_size], VMA_A_PGS * page_size,
		     PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_a == MAP_FAILED) {
		perror("mmap VMA A");
		exit(EXIT_FAILURE);
	}
	/* Fault it in. */
	ptr_a[0] = 'x';

	/*
	 * Now move it out of the way so we can place VMA B in position,
	 * unfaulted.
	 */
	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
	if (ptr_a == MAP_FAILED) {
		perror("mremap VMA A out of the way");
		exit(EXIT_FAILURE);
	}

	/* Map VMA B into place. */
	ptr_b = mmap(&reserved[page_size + VMA_A_PGS * page_size],
		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_b == MAP_FAILED) {
		perror("mmap VMA B");
		exit(EXIT_FAILURE);
	}

	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
		       &reserved[page_size]);
	if (ptr_a == MAP_FAILED) {
		perror("mremap VMA A with MREMAP_DONTUNMAP");
		exit(EXIT_FAILURE);
	}

	/* Finally, unmap VMA A which should trigger the bug. */
	munmap(ptr_a, VMA_A_PGS * page_size);

	/* Cleanup in case bug didn't trigger sufficiently visibly... */
	munmap(reserved, RESERVED_PGS * page_size);
}

int main(void)
{
	int i;

	for (i = 0; i < NUM_ITERS; i++)
		trigger_bug();

	return EXIT_SUCCESS;
}

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
Cc: stable@kernel.org
---
 mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
 mm/vma.h |  3 +++
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 6377aa290a27..2268f518a89b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
 	mmap_assert_write_locked(vmg->mm);

 	vma_start_write(target);
-	if (next && (target != next) && (vmg->end == next->vm_end)) {
+	if (next && vmg->end == next->vm_end) {
+		struct vm_area_struct *copied_from = vmg->copied_from;
 		int ret;

-		sticky_flags |= next->vm_flags & VM_STICKY;
-		remove_next = true;
-		/* This should already have been checked by this point. */
-		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
-		vma_start_write(next);
-		/*
-		 * In this case we don't report OOM, so vmg->give_up_on_mm is
-		 * safe.
-		 */
-		ret = dup_anon_vma(target, next, &anon_dup);
-		if (ret)
-			return ret;
+		if (target != next) {
+			sticky_flags |= next->vm_flags & VM_STICKY;
+			remove_next = true;
+			/* This should already have been checked by this point. */
+			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
+			vma_start_write(next);
+			/*
+			 * In this case we don't report OOM, so vmg->give_up_on_mm is
+			 * safe.
+			 */
+			ret = dup_anon_vma(target, next, &anon_dup);
+			if (ret)
+				return ret;
+		} else if (copied_from) {
+			vma_start_write(next);
+
+			/*
+			 * We are copying from a VMA (i.e. mremap()'ing) to
+			 * next, and thus must ensure that either anon_vma's are
+			 * already compatible (in which case this call is a nop)
+			 * or all anon_vma state is propagated to next
+			 */
+			ret = dup_anon_vma(next, copied_from, &anon_dup);
+			if (ret)
+				return ret;
+		} else {
+			/* In no other case may the anon_vma differ. */
+			VM_WARN_ON_VMG(target->anon_vma != next->anon_vma, vmg);
+		}
 	}

 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON_VMG(next && !remove_next &&
 		       next != target && vmg->end > next->vm_start, vmg);
+	/*
+	 * We should only see a copy with next as the target on a new merge
+	 * which sets the end to the next of next.
+	 */
+	VM_WARN_ON_VMG(target == next && vmg->copied_from &&
+		       vmg->end != next->vm_end, vmg);
 	/* Only handles expanding */
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		       target->vm_end > vmg->end, vmg);
@@ -1807,6 +1831,13 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	VMA_ITERATOR(vmi, mm, addr);
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);

+	/*
+	 * VMG_VMA_STATE() installs vma in middle, but this is a new VMA, inform
+	 * merging logic correctly.
+	 */
+	vmg.copied_from = vma;
+	vmg.middle = NULL;
+
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
@@ -1828,7 +1859,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */

-	vmg.middle = NULL; /* New VMA range. */
 	vmg.pgoff = pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
 	new_vma = vma_merge_new_range(&vmg);
diff --git a/mm/vma.h b/mm/vma.h
index e4c7bd79de5f..50f0bdb0eb79 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -106,6 +106,9 @@ struct vma_merge_struct {
 	struct anon_vma_name *anon_name;
 	enum vma_merge_state state;

+	/* If we are copying a VMA, which VMA are we copying from? */
+	struct vm_area_struct *copied_from;
+
 	/* Flags which callers can use to modify merge behaviour: */

 	/*
--
2.52.0

