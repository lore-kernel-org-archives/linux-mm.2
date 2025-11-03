Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257ECCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65AAB8E0059; Mon,  3 Nov 2025 12:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60FF18E0057; Mon,  3 Nov 2025 12:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB858E0059; Mon,  3 Nov 2025 12:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3479A8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:52:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D35E149DAC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:52:47 +0000 (UTC)
X-FDA: 84070041174.28.898E49E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 28CDA16000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:52:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vr9pRLhf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oSDIww6e;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762192364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4+3bzWctIzY0pTZGLlJq//7qmgm1O8VbpgthydEK+Q=;
	b=VKFbLkZJRa8GhI34gzbUZfZqRHLKDeRZGha3qNvy4C9runbYiYputglDloqQqYREg/xGGj
	angeeGM/hqY0/djBwhKVoxaG46CK+TbwAiDv4tPKsvN7+yUn/DGzG46sdUA9r9ddFHM9Cd
	S0HKCMUY7CEsuz15VPGBaVSvPXANM7Q=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vr9pRLhf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oSDIww6e;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762192364; a=rsa-sha256;
	cv=pass;
	b=VK1z8tnza2a/dS5O06XpQx3HwRBzZMsb4a87lrs+HK4oKbzF4tTmLORZKahkQXOv9C2ayo
	DS1RhegT+HXNyzuKW/XMZwe21YVkSLiMRSBY/ZF9SOwCnfYoqTX+/WR8sPdCfkCGL4es5h
	s/OOiUDVuVAobG3kKc9VOIzP/f3TpiQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3HOv5S000619;
	Mon, 3 Nov 2025 17:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j4+3bzWctIzY0pTZGL
	lJq//7qmgm1O8VbpgthydEK+Q=; b=Vr9pRLhfucqOTWxYffw4kIVcyCRrjmT12P
	qkkrgemBTu3b2CWSboVJD++DlUc6T5fzPNX6HO/KLEToHfPvKQM2CaXDSE9Fv+2k
	gFqZ5ckZDvVtpfnjdOQ9s+0pqqmrbBP6BP1F/aj9Gv8xVkhYiTVEXFqY4+fGkZiE
	msuIHk6GFehw2nHswNbpBcA+H3xwYEl9It/zUm4042nExH5XJmJD9ScLcXWqtx1C
	rmJjhDFeatE4V2g6rsLT+3NmBOSNiRrj5BPRmr/U5omuOiJ0KA1RWRwXYtjHOPtK
	TGJyfB8hEklsDO4ydfI3GL7P9RbJD76DOndQVv9UZxh46VKyHFIQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a70s0026s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 17:52:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3HRFdi014982;
	Mon, 3 Nov 2025 17:52:38 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012032.outbound.protection.outlook.com [52.101.53.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n87vf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 17:52:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GoqufSZ/752KU1dLJ6FT5nQiW/U11JfB7qEGs7boIe0rdU3gDxPD6bU8cmkTu4dRzvkVh/HXEss60ombvohehspAGNcd4mDMUhkP/4ndQ7veHs8Ij+TEo9J5UaOR71B9X2lV4MMBY7RkhnafVZwicA+E+DfqEmIom6iE+3ZMcUr5lTxvKvAdlhBQMBtP0YG7XZ8Sjm2piDyeeHurZwAc9QiGr1+pr+W1ERsUzW27nmbd5nrqJQrOvFKAAbMY/ul0gBaVQD0SPDb0x2gDyJ3OPGBNdVq9VxNsLCWsx6OPjp7F97bzlFntA+MuJZjhyaKZRrx2jbBYfFnsTndu9goCGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4+3bzWctIzY0pTZGLlJq//7qmgm1O8VbpgthydEK+Q=;
 b=Yff5JCPDhN87EtTSYr4NIl9Ek2iY9y8HpEsUmFwG5qCjoFM/asDVNyM6Sw/1Bsy9DjtftIoQS1ovvDMpZ8ve5wf28p+FLWXrLTmTyJ/6D4Y1AHppTeXsmQn8b01OoxN9sUtUfm/lo1KYr2ALo180qGcNSWZzW/D/AwCs7957ZOaBn3L8isUbmnYAkKU1l0XP1gXbuG9g9QRd5bnG1vQXRepBLBsMe4Ii2zvxmqN4zheuCmc/RP96Df02L7OxlcfSqLimkA+CQZ7JgVE2fRLn2wtoQtM5L8aXXK/BBNnZfuryLp6SV5eFZ5FYLlj/F10bKIWk0F6ZwnwAYOei6ifMfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4+3bzWctIzY0pTZGLlJq//7qmgm1O8VbpgthydEK+Q=;
 b=oSDIww6eP9b7gKo1/xUNXuhJZsSnqZLD0O6XFYisK9FDkz8aebn4Vgh1BAGq07xJeWjyTA6/fuLSSnckwG5SdhwsTkr8qPnyWS4JE4SJtbApdlYNnkiJ14FQ4IjdpZLM0xnAHZPjhld+QycGa1uUxldv0ZY6DMo+JHV0m+/BwdA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7840.namprd10.prod.outlook.com (2603:10b6:510:2fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 17:52:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 17:52:34 +0000
Date: Mon, 3 Nov 2025 17:52:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 2/2] mm/userfaultfd: don't lock anon_vma when
 performing UFFDIO_MOVE
Message-ID: <4acead1b-6b35-4104-b1a4-c96089c1caa2@lucifer.local>
References: <20250923071019.775806-1-lokeshgidra@google.com>
 <20250923071019.775806-3-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923071019.775806-3-lokeshgidra@google.com>
X-ClientProxiedBy: LO4P265CA0166.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 39bf4ae0-1546-4279-85e3-08de1b01c4fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P2BzOH905bdRNTkQpiyVBH6yILqNrwTt5rJCqykv7eyTNfy0xefnZG+4tBUF?=
 =?us-ascii?Q?MDD3oS2r1gvsCKU103wKjP70BX8Top3ycGnXLSylaw2FYL5fW9SDnEI+kzyr?=
 =?us-ascii?Q?NY2qtZFMutTPYCINmb0mIYR9j2Fs+CfRkVWFACcW4GhCdlglAikxta0Sjuqz?=
 =?us-ascii?Q?C3R7n6+7AOZJlTW3ebhh4DkR/czrGpDJaJRK2piLcvBC7ULfXiNfXV70LL2M?=
 =?us-ascii?Q?wkBbQAy3wOR9/QULr/MDSmJjlOoWo8jKTF+wTBlaM7XXGUjU+1XHtiHO3STw?=
 =?us-ascii?Q?0OneZmjOHQ6DyBgvAW0k2noFpJJhPfCykeXVyV2I5queqB9/YHNDGuX7EKFi?=
 =?us-ascii?Q?PduFOxAgiXkBZN4VHDCIrOU3yCosLndPz+DU5HrGD570kqMMRmYF3yZl1Eb0?=
 =?us-ascii?Q?r6hEhllaRYpcRuG2jjTVDK4kErUNyQ5gH1DCoqF3BiK/m50as+p1ci4/eFCE?=
 =?us-ascii?Q?SmHmLaBDZ4Bs8QPvdRqBy0qVS5EBHGMT+ko+neKRQuYNNUxp0v7dXYjXhKdE?=
 =?us-ascii?Q?ZXg9sKZ2yW/MO8K9oprIcJ3Z4kADqg+LEOUBVMR1Ey8WDvkc5+eOOeL1i76F?=
 =?us-ascii?Q?Wc5IfsNqFp84vj/3HWotQiU2X7gnswuL8FEXZFwM/Am4PncFX17/MfNLldmT?=
 =?us-ascii?Q?DCUFHXVmD5UzmRFvBsxN/S16HC9RV/5w09qSB/T2qRS3UogjjSltNo0bZxjn?=
 =?us-ascii?Q?YS9RcPaS/TfFFuUfJ1+NfmprpF0MiKG1SwzMzhX6yUk30Z201lqzeQM9TL3W?=
 =?us-ascii?Q?kRmP9GpbEI/mfn6EDNl0Ni41oEwQeAQFM+nPYdw9NGUrQemXm25BQZH2Ozjm?=
 =?us-ascii?Q?un2E7Seb9f8/BVCyV5EEA01+F69spg7rd14618M0OpEU9CmWxVCyREL++Nbe?=
 =?us-ascii?Q?qi3JJz1He7IHYVHDvIcnAGinr9p3lHPYAvCwXqOf1U1O5R5et7Yf9UnkFr3/?=
 =?us-ascii?Q?Sp2jEXZikKi7tEmm+MyaB8mAjPk7FdAtXFpN6oNZuQsepLUCnwtsAvogMvXb?=
 =?us-ascii?Q?tZO9Q/JX6K+fhciseUuYfR2ynOwTyLZiIqrmanmYDopx0hCZfLV3+101ct5X?=
 =?us-ascii?Q?VzwlvWUTlL6ASVZNQh1U7w7EVD/lyJ+mRV09yOKgiSJcGLBfMzcHMi4xbF6B?=
 =?us-ascii?Q?9pjIvB9CMDAER4MHAjIEoFhVceIVhLpyDHnksiLkxVStf2Qc/U8Xw0f/yiI9?=
 =?us-ascii?Q?94/xiqSDZ+YP7UnHEMvq0LRx5n2wb5r94tEWScjtLOimPBSEctyJxCxCmA41?=
 =?us-ascii?Q?ALdQwk4Z9A2iSS6ICwrzn/5GbK9Ju9XYsdXl6zfW8mLKz+SusGjDDoPrXPya?=
 =?us-ascii?Q?WsEfbjHDW7+MQP9fE0OOcD8vQFyHQ1lCfYLvtHrd0Q9/7M0AvUfzgegEjqHe?=
 =?us-ascii?Q?ylREdLnYPYRbneIU5JeqKBqheY0M2C5tM5/UONJIWHXCLioKSP/2erTz3d7T?=
 =?us-ascii?Q?bGE5vl7S0RJlo8N/kflzAo3y9UiOCe0H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?utPOdYfX1DTSzNw1njuD5j54MLZ0aYLCw0nhIn7UZqA7y3r0CbatS9Qi3MAL?=
 =?us-ascii?Q?+4qB8zGD7NLkyR/QQmySeKefbznIV7IPD3GkGzmQEP4/AMKTwPp2qycCC1vD?=
 =?us-ascii?Q?SH4qTts3UclUr7o5C5GCtmrVhizsIagjcaY/DGrh1AgqBevU70uvZHl2/Gjh?=
 =?us-ascii?Q?j/sLSEgZqxXX57q811nzVNjIC8wSysC1wQ8hVc+qgpgXGJ76Bb36C6910eEU?=
 =?us-ascii?Q?bTC3+lfszoHW1PXi/lBQuFsTcigosAWuDiuPRKrMqxoy8oPUBe9YzdT3ND7H?=
 =?us-ascii?Q?i2secyWotXhKtuuRyiLsLDxUt1lAicvCe/GXrl7Ne39mErDOOO7r9y4D6PmA?=
 =?us-ascii?Q?l4IgjDQE/pP1V+4I9WqD+XUK0diySEWwtuYYieIkS/P1IO1dsylfFiTmqNIP?=
 =?us-ascii?Q?fpMSm1Mh+SctWAHtotiq8n4wy8dyVFVMj96PVh5xkqJkaCWPG5BnwLEEZ6J+?=
 =?us-ascii?Q?9ktgA6gCX1OFovzYKS8lHYs7UaNPat+I1e+UiRaG+ZG6Qq4t89SDsWKBFl/D?=
 =?us-ascii?Q?QraDElc8mr39EfEfdN+1CZWF9+jMEbmlp/nlfaLl71hF49wbG6bSTcbjuRr7?=
 =?us-ascii?Q?uSZKAAt4cWe3i4JJUDjBzVUyapYWrc3dY0ABJGzj+US0nTNvFqD0d8p4aPLx?=
 =?us-ascii?Q?VH3Tu6B5QyWQZRn3wk6zIMQXpTuHxCdfZCOiLG/y5mEzQmVz8LaUyJEX2XOt?=
 =?us-ascii?Q?cs0BFgovNuUhUkqGADAwaoxFYMQIwxElBAprsYJyoY3qL2n1WUEyxmxbgR0Z?=
 =?us-ascii?Q?dPrOBmKQuhEd19P2QO05BnL1ANHg+NEgirYD82WCDQ+cd9tvxpYk/M8r8Enm?=
 =?us-ascii?Q?KanFvpzhc15b/asdIKVhGDJwDd0t56wIhd9W7ytwxG8zS3vhOAV5fOshBiXS?=
 =?us-ascii?Q?XP16zcV88ciBez7r7UiP9+F6jejjjF6zgy/joXydSOcopQpXjzLqbMRWiCzo?=
 =?us-ascii?Q?gUZW1IVAGA8XGsETw4KK9GpqsRRMAN/Y3nxhsmSoSUXeG+JCUkjyMUbZni8b?=
 =?us-ascii?Q?tMKJfI7EhWsGYate7y4nFgWZe/S21ZNU7935fo5FJchHMWOlLzfH56HUo10Q?=
 =?us-ascii?Q?kdaoORv4BKDK2iHeuSNv+04EBMn6qKvb3NryMaycLzu6NBOitLXGyXi9KCub?=
 =?us-ascii?Q?2PFnCeb5lvt+1mCr76ndJtiCfEvNvhM1z0ONDnCcV7Nd8BH9BWh8QzjnAVJU?=
 =?us-ascii?Q?EhDUaoS5udsmHEi0WXc0hVYOO8fGb73CBpzVn5T+5et4jJYSbzViTA1niwUQ?=
 =?us-ascii?Q?E9Zn6pycx211D4FqGpLZc1X/MVtJKmBqQbLYXfirRvaj6ABDNCcFOhT+9EsU?=
 =?us-ascii?Q?zpSpSfEvWZl4OyTxeT1SYz2GcRYzyyEYX4x7zKW9e5kgtc702z7R6eT9dP3V?=
 =?us-ascii?Q?qn5yqhPiKFaUULkVMNsrsLrEryux0kga7XvrJtY2XfxHsHd4B8CBy4Y3ERmo?=
 =?us-ascii?Q?Eud7R15ez3/bzuOCbtq3+yQR6kT39Ciy+wSYhzASDdbpVVjMMr/tbq2sT7b2?=
 =?us-ascii?Q?mfj4L4xJ+p8+4LIdQ7+aLpBOR3M49NskNT7ezlc3ZcDTgYbbhHJoV+yucjjy?=
 =?us-ascii?Q?T73odPxgtA6ohD9t0zw4sP33COXJ2vjUgmJGj0auoPf9DZ4rqNs2aNKo1Izh?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lrScbN8um4KwAWjrN9xalW1QNAR5Su7CyEFLmGWKHvgOee9wGh3PX/m3E4AhwHYpTk9k8HWcveUjQi8Vu6Ny9v0JXkJpavLYlvJYrshH/94qKhpm5irMsiqxzASdkvN1IvabpMo3ZGGZCJwnAP/Zpu6myHd6MWdiurEHo8rGyAgRqvov5fPKsCuYCGr/iVrzuoWvWCPup4YMoacpR6ZEyHLNzx/BzhzFjydanieEys9Jrj8jDwBGoFg9JGvd/0EYmc5seVzIHG5TrZVF+S4DxxOS8Za1jV4y1rCE/U/E/u8S5rZIebjxxdTzLG5S19I0EbcxiYhQYVAKcyIqDDYf24dtUcYbI6ys9US/v4OE1oRkIlsXSun3VN/hdzZAFUfCMlrKrNrOISiT5Oktq6fdGFENtrpJuyNjoP57V/JxWOl8TF81K6M4pMHdkHmQgHcRpbM7S0ua5IDtW6pu9IwYL6n80xuJgYoIn58nhmVGqBc4DQpJXfGjtUcwHSLFbQVoHu2K9PQcWGHLspcHLAtM8xs602i59uuHfrqG3z2w908nW0hjnijx/vOH6daC3WgTFKZmI5FycM7FARkGhKNZ8ai1fQdvxoFYlucAgqfZyc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bf4ae0-1546-4279-85e3-08de1b01c4fc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 17:52:34.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NCl64HumZom0kvAyv2i3uwzT3KoaPyNXBq3P8kxjXu3nbIwdd0jl4vr0JMH5ny2PVyOV/4sTbSb38G3xu4bxyq6vnz+VdrXkraljN0HK3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_03,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030160
X-Authority-Analysis: v=2.4 cv=bJAb4f+Z c=1 sm=1 tr=0 ts=6908ebe6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=bFBPpuQ32CfVR1azVb0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE1NiBTYWx0ZWRfXyzgKhaGVOFgr
 YeafDdwoM6/4LM5Gknl09F0DbUEEShcQxpqL1dLndJ3zm9sObDZW/ANZ+LfVzBSFSYtsi7bI+gg
 EhRT6mLHemyvs/lrfjvbWyjqreu2lasAC6t6cRquQIkiL/upq0KXyCjnyM+9o1SLaVR7xuQ+4Fs
 lXWwa6H+kf2ScxckUAdqzgyKG5cbDf06WT8HvgqEPJ8ckzKDE+ad6Z2kVMO9J6EVY5PcVlzmDuN
 oNUPLCTtxVXpqyC2LOMjn0S4emR1oBEyrN+VPWtnlFer2lKPXjfRsv+GoDiQ6X3HbzfdYLxUpEo
 Xco4MYOPhAQsLn/GhWV7wrNUnJyguYjSQkWeO6nm4BQkk40MU5oylONXyWLibZg4sZgHhOPl/hi
 Nzg4PX2rTyQMUGrSC9UICaXlfkZYOg==
X-Proofpoint-GUID: a6xxiAMNc9dd5yhPeqxT-4NdjKFX6Um8
X-Proofpoint-ORIG-GUID: a6xxiAMNc9dd5yhPeqxT-4NdjKFX6Um8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 28CDA16000A
X-Stat-Signature: gyxayfof7gdbzk6qaqkbh6g3yp5niih4
X-Rspam-User: 
X-HE-Tag: 1762192363-718321
X-HE-Meta: U2FsdGVkX1/SWohOaMNFPGFVxEZFZ76DC6J2yKes4dOMcGFE0YPZy1z0Ze49zRZZmctqvV2pk2T9Ap4o7y6R0w9PmNnQIkvvCWT1d+dS1eTu5Z54jTi63N/v2cj4BieEZo/1hO7sV9FUjywWFIJG40w0tH/o1860jLv69RFGliFqE8jlAJbTMNUz0aPAWQ6qeYAUwXArKL0JIOsLO0vKdZiilN+lVORnn/vqZBkujVkPbwDdXwUDG96TeOZYbfjxf5zvmMu46Cx7etOt1OZzTitsEiE/8PwFoNF+RksV6ZYj4qnWUyFSAwAqY90KTpRXgqAEfehl98FYw+hGa3nLhHnBI+QXe0xUPVhLddpk/Ha+g6puLKHvgAdHQUdPeTV04H1HFNQ1MD2eRACcrxIJtsaGlUFVibbaDdmtGglLrLXHca2UK+Q/YsTY06znftm+ZCx5zUNRIv6BZlpkJNJAQ/1WowVWN9sr8Rqf795R4jMrTDMugQL7WqXDIHaCSFa04+o2WNpdqdybYNDTdxe5oKWro0kjgW2GOX0hwpCQxoqcWRf3/Sprkx7E7MivvflKNjSkQQ3ZKGb0OQ0hLTigRZbBYi0XTZpcgEx3ue82sXRu68VXbwLPp+qrnb95W4MAFyUOeab/fC1QSmKHD/AXXJhvClhwPNKxURl3ACU+9V1F+6WU5bX3GM8SyKbzJjG8BLOwQ9qXr66dGIWg4xmfBUNb49YPO8YU5M0bPdpcXaeWie+OBTCqFt1vSQ/moR4h8oW0zrf55xdRC6zFODa0BzePXYLm9qgL6fnh88LhpZXad7MjBIePvl9RPQX5DL059PjkBu7AXqibJFmrq6tWDwFYcKxAAmG5D9zufHPKpda4tSu4tEz3J++AQi3qURTRjulWzacS/pqMxmknvdJbH9zumLBOptoCiKFlSJkY8zgmlbuKOuuvvFTJq8fs8xWwu3uA6+BgDz0yOxoanRG
 JZXPhPkx
 RVUIgkjXcre6iI1Q+pbd9cMjncbHHtbSP9rgwFo6dGB/zT7f+thr1lw52L9zt0Pj9dyA1pcL0Ariwo7W2QPMk/aHt/ZTWX8m7SC3fvJ/0S5pDZQNQSpSUTgXHX6VOQd7iaYIKbIB3+qp23E7LAOqCg7f63q4gdV7ODHoyxTOBUA+eS7nccUrrSf/t2nuMQ4vg35nG4o5o9Rj1FhktEfjjnakYrv4KjNKvveFqWgbeStbYhZaX0KkWusO9ZGAvSfWwuQYz61Wkb41wLufBbNsUECy3l381lb0FFrFz/yIdwy92Al3Z6X6EjtyzIzwyUo+Ac2CB4KuZYv0z/bGOnLt8PfPDfPrP4Lim0W6j57mpoUuej20RIU8KbaQJqujHUQdnWcV30Sa00HAVX0qhrkJILd9eiL4w87JrJPvWR39IenRqaoS4fTfFiFrhGlltY/kvRWDT2SKl0EEFPWudBWljhwdnRt1caHfIyG6C0EQ6zwhman+9dt6NLtUNA5L7jHlfpDu53pAc2nC6QNLlzUA5tKAr3Ag6Kp4f0zvORkg43ap1+INuPAHDMFVtOQtEEDfYuKTuy6kK6W3lm600RVIhSyirZTycEx+50Dat458KN/NYvCVASyp7WOegDKKk5WA5kRdlB/dGtEGP5d96RV2HtAWvACVlc/Cu4icduzzspKFRHVdOd/CmScsueNDl2JCMBe4uBNX6pzw5NKcSQGqTV6fQebnQQoYGTELjVZn/FTEqk/BP+Zp8CtuTApGN246OW+zz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 12:10:19AM -0700, Lokesh Gidra wrote:
> Now that rmap_walk() is guaranteed to be called with the folio lock
> held, we can stop serializing on the src VMA anon_vma lock when moving
> an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.
>
> When moving a folio, we modify folio->mapping through
> folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
> while we could have concurrent RMAP walks would be dangerous. Therefore,
> to avoid that, we had to acquire anon_vma of src VMA in write-mode. That
> meant that when multiple threads called UFFDIO_MOVE concurrently on
> distinct pages of the same src VMA, they would serialize on it, hurting
> scalability.
>
> In addition to avoiding the scalability bottleneck, this patch also
> simplifies the complicated lock dance that UFFDIO_MOVE has to go through
> between RCU, folio-lock, ptl, and anon_vma.
>
> folio_move_anon_rmap() already enforces that the folio is locked. So
> when we have the folio locked we can no longer race with concurrent
> rmap_walk() as used by folio_referenced() and others who call it on
> unlocked non-KSM anon folios, and therefore the anon_vma lock is no
> longer required.
>
> Note that this handling is now the same as for other
> folio_move_anon_rmap() users that also do not hold the anon_vma lock --
> namely COW reuse handling (do_wp_page()->wp_can_reuse_anon_folio(),
> do_huge_pmd_wp_page(), and hugetlb_wp()). These users never required the
> anon_vma lock as they are only moving the anon VMA closer to the anon_vma
> leaf of the VMA, for example, from an anon_vma root to a leaf of that root.
> rmap walks were always able to tolerate that scenario.
>
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 22 +----------------
>  mm/userfaultfd.c | 62 +++++++++---------------------------------------
>  2 files changed, 12 insertions(+), 72 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..a16e3778b544 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	pmd_t _dst_pmd, src_pmdval;
>  	struct page *src_page;
>  	struct folio *src_folio;
> -	struct anon_vma *src_anon_vma;
>  	spinlock_t *src_ptl, *dst_ptl;
>  	pgtable_t src_pgtable;
>  	struct mmu_notifier_range range;
> @@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  				src_addr + HPAGE_PMD_SIZE);
>  	mmu_notifier_invalidate_range_start(&range);
>
> -	if (src_folio) {
> +	if (src_folio)
>  		folio_lock(src_folio);
>
> -		/*
> -		 * split_huge_page walks the anon_vma chain without the page
> -		 * lock. Serialize against it with the anon_vma lock, the page
> -		 * lock is not enough.
> -		 */
> -		src_anon_vma = folio_get_anon_vma(src_folio);
> -		if (!src_anon_vma) {
> -			err = -EAGAIN;
> -			goto unlock_folio;
> -		}
> -		anon_vma_lock_write(src_anon_vma);
> -	} else
> -		src_anon_vma = NULL;
> -
>  	dst_ptl = pmd_lockptr(mm, dst_pmd);
>  	double_pt_lock(src_ptl, dst_ptl);
>  	if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
> @@ -2643,11 +2628,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>  unlock_ptls:
>  	double_pt_unlock(src_ptl, dst_ptl);
> -	if (src_anon_vma) {
> -		anon_vma_unlock_write(src_anon_vma);
> -		put_anon_vma(src_anon_vma);
> -	}
> -unlock_folio:
>  	/* unblock rmap walks */
>  	if (src_folio)
>  		folio_unlock(src_folio);
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index af61b95c89e4..6be65089085e 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1035,8 +1035,7 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
>   */
>  static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  						 unsigned long src_addr,
> -						 pte_t *src_pte, pte_t *dst_pte,
> -						 struct anon_vma *src_anon_vma)
> +						 pte_t *src_pte, pte_t *dst_pte)
>  {
>  	pte_t orig_dst_pte, orig_src_pte;
>  	struct folio *folio;
> @@ -1052,8 +1051,7 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
>  	if (!folio || !folio_trylock(folio))
>  		return NULL;
> -	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
> -	    folio_anon_vma(folio) != src_anon_vma) {
> +	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
>  		folio_unlock(folio);
>  		return NULL;
>  	}
> @@ -1061,9 +1059,8 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  }
>
>  /*
> - * Moves src folios to dst in a batch as long as they share the same
> - * anon_vma as the first folio, are not large, and can successfully
> - * take the lock via folio_trylock().
> + * Moves src folios to dst in a batch as long as they are not large, and can
> + * successfully take the lock via folio_trylock().
>   */
>  static long move_present_ptes(struct mm_struct *mm,
>  			      struct vm_area_struct *dst_vma,
> @@ -1073,8 +1070,7 @@ static long move_present_ptes(struct mm_struct *mm,
>  			      pte_t orig_dst_pte, pte_t orig_src_pte,
>  			      pmd_t *dst_pmd, pmd_t dst_pmdval,
>  			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
> -			      struct folio **first_src_folio, unsigned long len,
> -			      struct anon_vma *src_anon_vma)
> +			      struct folio **first_src_folio, unsigned long len)
>  {
>  	int err = 0;
>  	struct folio *src_folio = *first_src_folio;
> @@ -1132,8 +1128,8 @@ static long move_present_ptes(struct mm_struct *mm,
>  		src_pte++;
>
>  		folio_unlock(src_folio);
> -		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
> -							dst_pte, src_anon_vma);
> +		src_folio = check_ptes_for_batched_move(src_vma, src_addr,
> +							src_pte, dst_pte);
>  		if (!src_folio)
>  			break;
>  	}
> @@ -1263,7 +1259,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	pmd_t dummy_pmdval;
>  	pmd_t dst_pmdval;
>  	struct folio *src_folio = NULL;
> -	struct anon_vma *src_anon_vma = NULL;
>  	struct mmu_notifier_range range;
>  	long ret = 0;
>
> @@ -1347,9 +1342,9 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  		}
>
>  		/*
> -		 * Pin and lock both source folio and anon_vma. Since we are in
> -		 * RCU read section, we can't block, so on contention have to
> -		 * unmap the ptes, obtain the lock and retry.
> +		 * Pin and lock source folio. Since we are in RCU read section,
> +		 * we can't block, so on contention have to unmap the ptes,
> +		 * obtain the lock and retry.
>  		 */
>  		if (!src_folio) {
>  			struct folio *folio;
> @@ -1423,33 +1418,11 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  			goto retry;
>  		}
>
> -		if (!src_anon_vma) {
> -			/*
> -			 * folio_referenced walks the anon_vma chain
> -			 * without the folio lock. Serialize against it with
> -			 * the anon_vma lock, the folio lock is not enough.
> -			 */
> -			src_anon_vma = folio_get_anon_vma(src_folio);
> -			if (!src_anon_vma) {
> -				/* page was unmapped from under us */
> -				ret = -EAGAIN;
> -				goto out;
> -			}
> -			if (!anon_vma_trylock_write(src_anon_vma)) {
> -				pte_unmap(src_pte);
> -				pte_unmap(dst_pte);
> -				src_pte = dst_pte = NULL;
> -				/* now we can block and wait */
> -				anon_vma_lock_write(src_anon_vma);
> -				goto retry;
> -			}
> -		}
> -
>  		ret = move_present_ptes(mm, dst_vma, src_vma,
>  					dst_addr, src_addr, dst_pte, src_pte,
>  					orig_dst_pte, orig_src_pte, dst_pmd,
>  					dst_pmdval, dst_ptl, src_ptl, &src_folio,
> -					len, src_anon_vma);
> +					len);
>  	} else {
>  		struct folio *folio = NULL;
>
> @@ -1515,10 +1488,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	}
>
>  out:
> -	if (src_anon_vma) {
> -		anon_vma_unlock_write(src_anon_vma);
> -		put_anon_vma(src_anon_vma);
> -	}
>  	if (src_folio) {
>  		folio_unlock(src_folio);
>  		folio_put(src_folio);
> @@ -1792,15 +1761,6 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
>   * virtual regions without knowing if there are transparent hugepage
>   * in the regions or not, but preventing the risk of having to split
>   * the hugepmd during the remap.
> - *
> - * If there's any rmap walk that is taking the anon_vma locks without
> - * first obtaining the folio lock (the only current instance is
> - * folio_referenced), they will have to verify if the folio->mapping
> - * has changed after taking the anon_vma lock. If it changed they
> - * should release the lock and retry obtaining a new anon_vma, because
> - * it means the anon_vma was changed by move_pages() before the lock
> - * could be obtained. This is the only additional complexity added to
> - * the rmap code to provide this anonymous page remapping functionality.
>   */
>  ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  		   unsigned long src_start, unsigned long len, __u64 mode)
> --
> 2.51.0.534.gc79095c0ca-goog
>
>

