Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015DFD74EDB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655CD6B04E1; Fri, 23 Jan 2026 09:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D3B6B04E2; Fri, 23 Jan 2026 09:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA126B04E3; Fri, 23 Jan 2026 09:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 378FA6B04E1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:52:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D956913A967
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:52:30 +0000 (UTC)
X-FDA: 84363519660.25.AED8A25
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8822920016
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:52:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="j/H5d9dj";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jJZ9yVoP;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769179947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wWWv9H5KqD6bayDJW35VJc8yAjxz28ZnlTnTZNn7Ac=;
	b=g991lVsyMxVTWWHQv4qE0+1l9ujRsC4yV8ByxvLn+MZBqqGK6F6I7FhXSpaHn5QO9OpuxJ
	MPy5cTYEeZhlX/5PbCACBGrt41XlL7e9Z8cXEwcNnjFL3orr5ZM2LMhV0CTZNUG9C6Ytta
	gH8QL3zJtHp6cLCE/JDNjWHy5Ajm+K0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="j/H5d9dj";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jJZ9yVoP;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769179947; a=rsa-sha256;
	cv=pass;
	b=LZkhw4p4vJO7Bx1KXrkJRkklHRaYRwTZK6wB+2+Jfk1/+r/Ko68ID10CbLkpuWhmxA8m48
	koYpZXlwiQotRlwcvA2HS+CstjctL/N5n/pNomoC8tPsaRAg7MgZpn4Pw0HryryKZ8Fszn
	ZZ/teh4Hh8TgIP7XiNUlV8iAJX4pkBc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EBCD2172801;
	Fri, 23 Jan 2026 14:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/wWWv9H5KqD6bayDJW
	35VJc8yAjxz28ZnlTnTZNn7Ac=; b=j/H5d9djk2WN0j5U7ZqirJzHbYAjtRqAmP
	unVk6yeh/r01+6Qm1zGE7GHK5HpQD2vzFUmj68OkjTHRIn3CH3e3V7Pl2KqWryQJ
	+G0zWEg1/kghPw0mj1FFXjBUYPiCWOc2sHOBGcBUiBgvf+6pzRPZeWJH03+p4+lT
	HGXqfxkYj5GyXjg39l8yRoTjdT58+q30JbiK5bM4fEjhQHyxQjriG1iU3cXR5BIv
	1Cz3a+aaz/EuIo8YoS3ZPwbS23vnTMawkWkEUI7Os55zY8qfZJ48Htf7Gr/b6qEK
	RfpYjslHimIiTQER9iGrpdrpQRAq/qSKzFvONFsRmX3GsS9VUViA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd70y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 14:52:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NEZm9N035816;
	Fri, 23 Jan 2026 14:52:15 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4y9r27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 14:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCQBwycfOAqt7iH3rXSO4AdhjmX3n/15dnkhXbj8tLgr3YqNnLJQzFwOTZNqULTTFg/mJlfGl9+XGp73st0mTFfqDJAzSzBBq0t6+pITsL+gPGV7MX227uauuSItUGpGlMDacx+5bS2hU3zhYbLA/xDwEL4MgO8Yn8XKsin8zqOUcdSqVVakOalErtjlJj32zBbacxbOUshcR5HUfI3nYh/amuuvysXm0jl0TCXpFtGm+S8qg9aYX9lD7d4pvPjZbDe+N23BjVrx/TytiacaFB9w6vctOsbSY7TClI2s3u3fBL15QXRfsX39QvBt4GqZTPKwZpLOo8pR/+1tj/JUsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wWWv9H5KqD6bayDJW35VJc8yAjxz28ZnlTnTZNn7Ac=;
 b=YeSm1F4/55vCh6RmHqnb5kKnqbj6mzEBqgp1S0NrFl8x0xsi7ReaYctaT98bFK7X+iiFTrXk/LbPoPMKQsY28JSqb2xctV4wgLL7gDiqsizWvqO1ps/p3r2TPQS8xwubOIJkumUMetrmUnXhyyNqqpnNn7YWaO5DtRxMpD0lZ2IsQzOMbyCNL/niMUuStDWmX3qjWWshIxmYVu8L7Poq/HuANiFj4fE/Pa/3kgLaARzm0S+EYqFEG8hd+5bmTf5/ZvlGENLOQb6e5XP+F1RvPktFPU5YAYPFnwra7tjJZBXHhqHRgi+FXq+OQg13DnagB4SMu+D52M8hKNkPqPO3og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wWWv9H5KqD6bayDJW35VJc8yAjxz28ZnlTnTZNn7Ac=;
 b=jJZ9yVoPmlyLIwvtVeKSM6O7wbBX3H8NmkVmnocKE6ztrhEIs0Ton/1Nbce3caDqHfqkkgTzWCPt4+1jlZ6ny4o93cxisO8zgGcD+VvmgcjIo23DIBZ0cNHG7SdMcG+M5X4LPCHieDA2qyRt4dkPrbuz9ZuAvdJunPDjawNNzXE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB7540.namprd10.prod.outlook.com (2603:10b6:208:445::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 14:52:07 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 14:52:06 +0000
Date: Fri, 23 Jan 2026 14:52:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Message-ID: <825b311b-c4ea-4abc-be10-1301d4f5da88@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
 <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
 <168cbc6c-5f7b-4324-8d45-d9033613a67e@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168cbc6c-5f7b-4324-8d45-d9033613a67e@suse.cz>
X-ClientProxiedBy: LO4P123CA0258.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB7540:EE_
X-MS-Office365-Filtering-Correlation-Id: a281a669-cdfa-4654-2b03-08de5a8efa86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oZRNow5SwJvdK9qiblms40D2Nn14xUHT4QMedhEeMHir8BAK2ZrniaLcRmqb?=
 =?us-ascii?Q?LokHqqxX4mQEJnopCVEk3nm0FVBAYsqohFwu1Y14Xiue1yP86vn9/iMgZUkq?=
 =?us-ascii?Q?RVpJ2U/hMDXinem7TmJja32QyLk5dae9YmOmsLnkUGABmbKn4rxQPEBp62vq?=
 =?us-ascii?Q?hfJ4va17Zk425SAroPW6nTHpNRvZnSd/c3T9EglnYyqm7Np7461ujqah9BV+?=
 =?us-ascii?Q?9jb9zydM75RGx2Pn1rY6o5i4hRamcqxsclFseiBcCbqFocb8NUMU8fuR2DUu?=
 =?us-ascii?Q?fUyCnBrfnd6Gctm4vIsRpydjvet5JvGEN1DwZPgwrOCj4SPHWllQqA55D/Y7?=
 =?us-ascii?Q?xWQRuGM7/zmhpNkwk9ZVGLyTP9G2s4jBTZH5wvNbNf+y3WctqKTM1U/ZeCeZ?=
 =?us-ascii?Q?nnSnifAOu3SHIGeiwew+bsb0u4US5dyP/dBA6WnD/3VcC6H8nCJedhrhvBSV?=
 =?us-ascii?Q?4FlhJCfAKRFI/Zff9BZqD3RE+LKd0Qw+RBbt7xQ6jSvPFkmqz0hhhdGM25Ag?=
 =?us-ascii?Q?F8Y35iVwwPJ5rBxrTdIjIl4gRhLSy/rjYVhowMcVq3jha9zs2PR5tFG+3LC4?=
 =?us-ascii?Q?U2siOimq8LiwpmXoO7G/J213LT1jY4VtrHCQ2hoVJ0BdurOCbr/UV/w423D2?=
 =?us-ascii?Q?jTEdL9kSe5YxJh1X3TpZqeIPod5V4XpvoKrn7f91tPq+DAuesPVfXjSHCFTZ?=
 =?us-ascii?Q?zs2QH9fL4gM/JHkof45s9htmQMepnTceIQSJtQVqzMwdNBcf6uQ2aM00IQs/?=
 =?us-ascii?Q?AycGMiLuLQfCje59Y9eiQX1T9W8BU4A/yNRqCEoiLU4Zq7a03Q/ClDJFZRz4?=
 =?us-ascii?Q?RXPSDDCvS1jiLN4sb690LasaEF+D3KsyhQ4MIBfOBNm2wvYkdW2AYU0syoeP?=
 =?us-ascii?Q?u0x5RETwfeLBcVu1B6KtPER2XQzr9US3sSXHcMWhWyAcfpV59sh5slWLHl9A?=
 =?us-ascii?Q?lw6k8Z+CMmD41qN9H70HWS2Q0HjIOGSQVD7PX4/+BTooKpBU3qLVhP2tWOHf?=
 =?us-ascii?Q?1rGF1wgswKT5uegty4cim3mYxl6C73vAD3tULG7WHKAVbUKPal9gFYMZIeET?=
 =?us-ascii?Q?r3LRRE7HsTQGGHSAWAqImbuT5Cb2Y6d/7v1rPw2l3ndkxXO9W1IizBwRaGjh?=
 =?us-ascii?Q?AoDjH04B5XwBkrwGEoRBTwMLY5ar61n6muzMsog2+wS3sUZXYmbDE72rmw9S?=
 =?us-ascii?Q?BqWfFWcD6/PViOIKPDdBNiJxXeHkEeffRBkisPTZ+q8P11AcstbOUtAhpoEh?=
 =?us-ascii?Q?Js33YiJcv3PbrSf2N7H1nQyC3SMOoBRrlfvJIU/fOFcgXbc+AxnYByIoeikj?=
 =?us-ascii?Q?A7vOqcA1BSG6rI6EDMjOQ2+g+zP1oGjwqzsdldmwGN3c70JnfmidzIXB6scf?=
 =?us-ascii?Q?XeyvrJ3JOT6V8vwPxRZQTeukh2aFyaj/ekAHSdNMbwBRzGQo1luilL7VQy0G?=
 =?us-ascii?Q?vdBvbrwXxTlI77q/t4bxgcsMYTcRB7CXciVFc2nA8TN6z5IciwtZ0+W7cf1Y?=
 =?us-ascii?Q?LOJCDrrjNYjF6aZgR1unoUSoJi8o0qHen4BYxdYbOyi73U8YBKZuAObTiu7x?=
 =?us-ascii?Q?1QPrxZUOHz+fqUVLw7U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TGLV2/F0lkbr3haOqGkZPEnj5kmNoyS7qFzNv+efhJ2/gu/6m8LN3CFFb65s?=
 =?us-ascii?Q?3uE70m6+kj1UEdnmFCO/Fjqi1WiZvl4jWCwTWTnd7QtaKU1GfkxRNxl0ncGc?=
 =?us-ascii?Q?r+tVxx9wcTKbfJfHnX4Oh5mr1wy6qpBoJno+GsszS/KV+JPwjTgjpuX+ys89?=
 =?us-ascii?Q?orH2kFYzkkscM8o4fd9p8Fac7qqz2hYjYO5z9tFS15Z8PT0KX5cnr9AXsLKy?=
 =?us-ascii?Q?7NuHWhPZAfN0Fwgfac7tgs+tgtr8QqSB04BNSD3BZ53wT1osnsHMz17fn/E1?=
 =?us-ascii?Q?Q6Z2Qkx3MVTYxd47a9T2uYvLCKmXeQSSecs8yIDHkT93NfrHi6jOuiLSMKi5?=
 =?us-ascii?Q?zIt0e6ihafOr8rB5w5w0BbQqsuKf+8EHKOLwo/1aPO35E9j4i67XHeK5T1pj?=
 =?us-ascii?Q?buzsDrvUZn+JQYJLppR1zl287b7O2pLKUEz4FVaOvJT7JK9vJoAP64jIijD6?=
 =?us-ascii?Q?+q0DHL2zjpmtxoNJC8ov0RCbimxcZWV0zAQtFyi245FU/0GNaJ1lKnhTCJCo?=
 =?us-ascii?Q?nQlaagcDaxC4PJmBk21YLL5KmsaJwPsjf34ovUKPi4ZczXL2KgXW5vPpz/BX?=
 =?us-ascii?Q?/379/SzERTn0DsQAxixjWw1HLm7w/VHa4zAYQTFiZm/TVjlqTdYbVUyC1Xgm?=
 =?us-ascii?Q?LR1wKyGR6aUDzUNn7O75RjMxesnQ/bCIAxScfYUIB11XBQ5s8fwEagsN1tH2?=
 =?us-ascii?Q?6T5WUH6GKNjPkVJQLOIOJu7vrthZUMWGcl9tLHd24F9yCIm7Ao+dxk2mWr0M?=
 =?us-ascii?Q?licSle2u+WU2XieNumbPBY9gHQVkbyquWvpmqhvDCPluy7CtgboaoPEyRI5h?=
 =?us-ascii?Q?hJfG9BI6xgD/3ATqmxvO3fdXYAJogJilZmrjKIuCaQij8cujZ/ZcuTkL9wRn?=
 =?us-ascii?Q?gl7uC/7V92RYAGsZnmdBU0STWVzT3zueBQ2ecZzhcp4kGpUvLwpouBa32UCW?=
 =?us-ascii?Q?9l5PVfpx1WO98JVVJHDAsU7Y9ZdL4boz9JxV29F60rkdBMKFGHkdFlrcXIsB?=
 =?us-ascii?Q?GQCFd4PYB3Lxsy+gO24ow35pMd2Y9PMDAdaehm74xy7k25pkZAWfPVBbLgNu?=
 =?us-ascii?Q?g5KhbUwO0Ml+i8PEhaQk59nxdljYgt4PilB+jZ1mzgEx9DuXQtFXz+qqMivZ?=
 =?us-ascii?Q?qpeiibBarUmiKRlnusIUNqYergLDZ1J8i5kBlLqVEywtB+/bfLfYCz6l40c8?=
 =?us-ascii?Q?Qi+vLssau53pluJApk0RQGn4cgWVD5GBmQ4uqEljjeTA/6d3XdBVPO/FqogD?=
 =?us-ascii?Q?AugNe1cAYnC8yW0FInDvNM2tAyNt9+0dOerVw7fbWwzOE+pegmPzKuJBW3vU?=
 =?us-ascii?Q?SzSRMeZpizyuL4vvkLrVV0u3UjubOGxvXjX/D4NqDRF/PzmmsQaaYryurUcA?=
 =?us-ascii?Q?WcTU5uDPQxxs0g+7fzTSNV7fZ3Y9JPkBWjRaDbL7htl6mXAC00+pCXjZjjs4?=
 =?us-ascii?Q?hq/QJids1FtdCS4c3BPKEHqY7OvGlfr4NbX2c9sC3laVuMaKqTdGg2ZP+Qbj?=
 =?us-ascii?Q?3eOAGNRccvVnk5IlXStzMu7KCCeDXqC++xKBMNzyKvIXp/U6juZRvhgYzltJ?=
 =?us-ascii?Q?H8ndwiepfEQSWs1xBrYx7vA87Sltc/8VXEt1ugXfmhMzPJMkIlvEU9N1BOqc?=
 =?us-ascii?Q?Bbr7l/pSjJ+1GVr76STA+zoVV2IkTgf/zr95OKHiyxaONYkzBg5NTmdQXOgy?=
 =?us-ascii?Q?dDw7VYjDkmZyEqe4gChTIsNgjnCyrpdl8Oc+nv0fUL0zkx9OSaY9OuBnIu6k?=
 =?us-ascii?Q?x+4ol8roIzC6NlZoityCqLwgAxfHtQs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9nUPit+qUOyjKiZIRxqu1K+a27v9GymzAznJ7fyiRuUGSSESKn63+4HQG1S+TzgpvR5TjwOHzOZLY771NTsvw1y0x32mqJvVQOOAIJu3NhF7IisZE2i+/gUUOX9kbzyhp/OntcSeFSs2UMC0tIVkyTi2oDeu10aX5d6+1NdiM8v7FOR5kstuca7mAUTFfCB9engdvD9EFiWd/RBWimPyGJh9oXx9bjzZt8O4pqJElwsDaILkF5j8sLqSzaK5SZz7JbUYIzZ0Jwo+o0qxK+9qokIzbD70Z8eisikQOQQKSVWYOiL8PVBfr3WnlniGluTwQpPBruZTmlgnQwejYu0utCodlRe+RdQlupvuXCBDTy5AL+rOTEU60bn40ROj3d8GJNkngjFwrhMWh2igtD0pqdv/P3hFkDJT5CAWYbvQgP41pRgP54IfghOmlnKHF28rpfjHV1uPqpOjs8JBgVf4rzCyHI1abNgw6kZPAO4W3d+f53wqgtfAqHIwn5Nk02W2VOEbT37ofXAuiGkJhs+HQVedVCPYcdRdKqo9jo7d+oGezEXqw+Hu4AoGRzy9wZ+arEv30RN88CkJoNfJbhiZs3VBdjHZHrzRj/KnOT97MZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a281a669-cdfa-4654-2b03-08de5a8efa86
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 14:52:06.9052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2nJkqev4JB/8wX50OXgkpGGri02pOB7t/AilKKkwG89MHThQOs/F501enZVXSP86kPlvoVgovq3ke3SvaJE7sCOzpgULQ/QbWOLyyh+Srw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7540
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230117
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69738b20 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=MYcGAH3-2dKL1yzI35sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: LJg4BbHdjXuTDZbPupdCurtT_sq8bXyl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExNyBTYWx0ZWRfX91k+ya+MJROy
 M2IJeZip4Ys4HdfS8LJUSGv+F65JB2iWSZR1myAuA2eZgQSdRzGjtcL7F0RrSGbWnjz7SIkheKK
 7w82KDZzY4qmkSGWTk822FqhG4JgbbUooHH2rBMh201MiRBcm8MbWcF32I/u/XYNVFObGWSwYe4
 t+FbqLOjAbMM2xx0MCpsJhTp+d7afEqdQxjxCzF13nsdJNcs2hBnt8psFOEsCxHYbJyq3KKPdFh
 g85MdDbpnpug7TVvpAlx4qAErWdp2DTjv+3TR3twgebjBQezecitGYBQyk+13v2wyrGEPrpyTmB
 iv/JXL/BBVj7EWZl2ZQzdtDI/uynqYVFEcLZDsmr8aQuiVXt3xWcw8nbJBsPj1EbhNkFXzjyXT8
 GViOgS6NI7u7S2PT4gOGbmbOXhS0Vv2uAIVcr5lXmLFjVHKRxSqsyroGgeVGfKlgtD8erk97mT+
 vIZ3/8shjWZlCD2RLDQ==
X-Proofpoint-GUID: LJg4BbHdjXuTDZbPupdCurtT_sq8bXyl
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8822920016
X-Stat-Signature: a9jsjtcg1ytwwwtt4mm6b9ukfgbj17ir
X-Rspam-User: 
X-HE-Tag: 1769179947-574240
X-HE-Meta: U2FsdGVkX1+hn0Co23hEm3NLpUtLNN1UE2KGrPcS38NopMJgC0QZH+UEJBDQTCQt6olhNwKiFe8tEUutR6aOgDIUgXokqUd+cCIzGkjPu0t+DHpYteZYUTXG15w3HS2WkLY4Mjxg5+AmLo8VdfiCETYFxt9b9OzpOOvuhAEnFVwiSJNh1Q53saVFz+jzU+u1Yw7fPBdTSFm3BewgBRMIe9bp2oKmkxCYWWWNw+Y+Uqx0pSxG2kh6rLhe31l78m/M0fLnmybdjmnZm7GQ4hoT3cFngr+TjSXDNe331PIKeh8jEp9eghMCm7FZJvJIrONJvAjUAtsdZr2jodrRp0UHWwprc0BRW7y0MSO661gXPI+ae7VWys4nUK1CGa7whrGW1AcO4d+gWU+6SOgWPpbW2+58a72ZFenTxrxbTe0AlYmIvmKmM95fU7SuXp26Q1A96kYWYaOxbsPhJnph6BjOyRS8pTvY7Llls4dviaUkVba5SpgkhOhV2cdnGR3n5BpLIiQilqR+MkE6RTpYNWyN8PYVolZBgRyt5hCgsO8ognZQ3gcgC49mKQzkANoY0d2FkhlqKlAyXg60V38V35c7xy+VKJxlOWyJaiDgt9ugXw5SlGLYHHPMtXSiCLDSEdUkjc57HoVG2I7f6lMI6ZyVE6TaLPqjekffck8fJqAQ+8BQ8yL5EER7DbGC/IxpQuCc3o64f1VQX+WVZj29RcIxfTap187nIGzhAvFY7QUP71MYKPUzLQkSezEJepL59puOzNXLi0GIsX/E8SzAWIBqd4X7dWerPvf/ci9qGgLhhMX8qFMwTId0zBDA64L/Cl8ccnWkEveS+x0gtCJF+LEC4AJpd7z+iWWZgPxoJThPsmmOSUHUBfn+YYhkHhO+H6jmSlz/mnw8K42FbxOPAz4loyoqpbvON0Pora4xZgOEcAUHohYhFU0B7aSHNdLNRy3hhzV0wG6Rj8sIpxWHQzu
 s/N1mqr+
 FswFdiaxENaSFt2yDZyBxfYr+6TA8mdQ2/Rq8mPTBeG4mXXsyOn29T1iN8gNLvLyqoVG/z0noQdTN/bBZWXaRnRmJ9I+UfZdooF39BXcTTEAbs7A3iFtAbAyqrhujCB4d8zuW3qGLpxlr9ULxVcoZ+k2l3MmFURoClqJXB8Y3F2XR6oH6wCIqRtCAOZ/GT4dg0eSsfLJjXObxGezS+mDIRTDxsLy5jkHXbV/klTE0ivHV8dMZv248F5mIsrXVV//NG47R3ELRdQ9SR+ruKkaDV66LOriJu7ucRw+5UCzC1oX+KZPYs8Cy4vZw/IidlDJ/OTuzrDOmEZj+PcorYcgvGOZIDURZLbvpKXbTaQa44sWvRc04DUNH09WUHFRa6WYZl+2aBmwapG5lps8Sx4GzgMSM7vdfIBb7XAP/zj1Ot51ga/kuBEU/R5cwU9NH0XrXjajrKu9LqfnmUCYCm6DtP7eZx8dc89Zxswt4c1SQ4xAyYORD8+x+LZ3z89N2fpVOs9tDRQbDE0ECbZxp3Ejpt5JKXpEnbqYVbSLpLSRHFVTQA/X+sFkS9OBkB1xBh6BBo+NNwR3r4A941D9PsQ0eXpjwIWDLbVtbzmv92TbUntZ++DyefcxTOxCC/sD4bprikByfHyBAUWefbH/kvXwjDz57jIg+QZTKZJ9fEm2mpjkhf8YcrCFjLfoaBmWys3T9l60bK9vrEfk6D+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 09:24:54AM +0100, Vlastimil Babka wrote:
> On 1/22/26 20:31, Suren Baghdasaryan wrote:
> >> > +     int oldcnt;
> >> > +     bool detached;
> >> > +
> >> > +     detached = __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> >> > +     if (refcnt)
> >> > +             *refcnt = oldcnt - 1;
> >> > +     return detached;
> >
> > IIUC there is always a connection between detached and *refcnt
> > resulting value. If detached==true then the resulting *refcnt has to
> > be 0. If so, __vma_refcount_put() can simply return (oldcnt - 1) as
> > new count:
> >
> > static inline int __vma_refcount_put(struct vm_area_struct *vma)
> > {
> >        int oldcnt;
> >
> >        __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> >        return oldcnt - 1;
> > }
> >
> > And later:
> >
> > newcnt = __vma_refcount_put(&vma->vm_refcnt);
> > detached = newcnt == 0;
>
> If we go that way (both ways are fine with me) I'd suggest we rename the
> function to __vma_refcount_put_return to make this more obvious. (c.f.
> atomic_dec_return, lockref_put_return).
>

That's kind of horrible?

The lockref_put_return() seems to encode even more in it:

/**
 * lockref_put_return - Decrement reference count if possible
 * @lockref: pointer to lockref structure
 *
 * Decrement the reference count and return the new value.
 * If the lockref was dead or locked, return -1.
 */

But I guess it's still returning, it's just a weird convention, and not one
refcount uses, but perhaps because that uses output parameters.

I'll rename it I guess on the atomic basis but I just find the idea of
suffixing 'return' on a function that returns a value really... horrible.

Thanks, Lorenzo

