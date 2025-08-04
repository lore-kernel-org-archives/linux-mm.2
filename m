Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C01FC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8988E0003; Mon,  4 Aug 2025 09:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0608E0001; Mon,  4 Aug 2025 09:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEC78E0003; Mon,  4 Aug 2025 09:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0158E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:20:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7752B924A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:20:21 +0000 (UTC)
X-FDA: 83739133842.26.8B42D45
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 885944000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:20:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=StlmAQv6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t1B8do0K;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754313618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHqcwS+fp9NaFdfyJNCeRHSmvAyKBhaekSYHNR6iWeQ=;
	b=OrYZAn3KlyiU7ny7bIQGLCj9LJoPLiAdMUjWpzbMnGqUDeCVfhGwoJHygYG9hCfbz5tsdd
	EwuTAG9DQyGd+68e4C8Mt/957ibBLdb9n/ceDj2ayEbOliNZCAJmbivdawFIcsK5az1HgY
	fmL/jnvcww1xT2rKmeh27inHr1BC58I=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=StlmAQv6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t1B8do0K;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754313618; a=rsa-sha256;
	cv=pass;
	b=8rGRTmxFjskkd8WYn5XQ0OgrIGy9zM3G6xNgIbHHaCcwrAhSCqQub36ZGvTKmCM2iHPBgr
	FeIRzRZeT/uT87ZuSQ6qS0e+7ABKTEe7TnPWn1PY4j+UgFHlvyVFZee9WbIRZt2x6X6GRa
	Y+TdLvdHZQbsXxfX420ce5UfcSimFBM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6V00018163;
	Mon, 4 Aug 2025 13:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZHqcwS+fp9NaFdfyJN
	CeRHSmvAyKBhaekSYHNR6iWeQ=; b=StlmAQv6TWbpKpAZRVAdoCQlXz3iwVRWVT
	bOxXHEqJCVB8SvCLKv38r1qDkD/twF8amD3DOPvt0PW7RpxhuFScTE/pAYTXzfX+
	miR6l1OtnjsrZq+sN0r1SEhwzbKPQ2BPQutB1o8Zx+3MCMm4Ov/dGEaM2BmsxreF
	dOHNTgmmEumYnNeYrukm4E9qRAVYf9xwdrnF9n0GKYMvrjPgaecKjVTw2+dAPr6p
	A4cSlmOJCiPXBN51byLSYEPNmml+m0Az7OGgmkKMsweEoJWE3m9/C+NcYkkCqNlx
	H4NQfC972FzIOcCUs5zDh7bMApCvblZBmq/0vv46atJnil+hhvIA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489aqfjjjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 13:20:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574CpMUw029040;
	Mon, 4 Aug 2025 13:20:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qcktjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 13:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EckqmPmsFhpHyY8b0S1byiBoNEi3DvEIQ6iXcjpxHMkhMhU0gBwJ9NY5/E++1X0FqAgX4vLJPI8E4pZ59CH8gkhj10PLpk2vbmTB9qGgKJ7r2PPCrBr/gewFXzEWRhxe4mNoj7ZPMId2KQMQV8/p15S/4u+9ihSjcn8uoR0KeQzRuLg1/k42Nnf4RQTLKw9Mjy1rNAtLgJ1PPnyuw1nhCFQ8kdSyn5e1KwLUpZTlvRMsKTUYtihOvHbNnXHBIfVmA3pZgmBrSzDX5Wfmu/26uEo72zVxq9O7aac8rnTDIbO2AQfYb+TgpBoLs7vQEOEnY5oV1MiK3m0TAeiGklHbfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHqcwS+fp9NaFdfyJNCeRHSmvAyKBhaekSYHNR6iWeQ=;
 b=U6MJFi8F6Cmes/5488zCRmVlnM8f0QOQVsyT9KuAOegfaLbzFtyY7vv/nwsbBfsExUzsN3a8bIc4HULxBoESdLHms7I88ahpyr8Xt5yOrnRyjmhXrfEL2eyOH1TJkdAmeUGY1Bpefbqn2gHaIpKjBCXxc/h+z6d7+zDG7AcxnrAsf8jHwh5Ad55Tczhjfkz0nFxvQcIokGgC7vSUUNv14I/PPPpu4/lOzRjgh+0xNlF0WBQ34HmAI4sSJXv+pjZhxQGYbpgoeXWM/tKd7QeqsN0+LSlK97mJac7rPlzMspXZZGmDuuYY1ZKEa/1lTvoRNJqlvf5yWICC5BTL8nffIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHqcwS+fp9NaFdfyJNCeRHSmvAyKBhaekSYHNR6iWeQ=;
 b=t1B8do0K4oD0MVv9U3i66cdQkI52pUvYOj7B8oIbfsRrWaQ5vR/EMJdLcDI9Y6lhtGI6nSiW3YPN3b4S/A8SSVIm9KcGvsG+7MLuhuLMsl3xhKYnLZOmNyaSqbnsXWQtWVgkA3Ndc94RQvfFXrMW4FH5o8iiO7WGliUDdkQKGzw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8173.namprd10.prod.outlook.com (2603:10b6:8:1f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Mon, 4 Aug
 2025 13:20:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 13:20:13 +0000
Date: Mon, 4 Aug 2025 14:20:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH] mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
Message-ID: <c9dc9322-c439-4f3f-9f7d-26529e94c882@lucifer.local>
References: <20250804064106.21269-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804064106.21269-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0001.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c6fa49-6948-4d64-3d6a-08ddd359a4f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m6g1GxaEmo2OhAygVUtoHsuy3sbTWmCIWJ6g+YDiU+V7CHvZYqgspwAAeL9V?=
 =?us-ascii?Q?wc1+WLlzk0o86ThohXS8mHzIZmYs05lyd5qrHyRfYTe4sdhET2WP8Fwsifi4?=
 =?us-ascii?Q?lt0Vu6RrgFdGK6MbEVVQtzN7HtYe8K72y1p1TMcJ1BDRUUKExh5YMqrsXoxD?=
 =?us-ascii?Q?VlaDe3IAD5+enfSpF+rP+UKYnsapSpCZ41ID6MBr3+ZnSDigw6YKCUDdHfrt?=
 =?us-ascii?Q?AtA7Na0uwbwiC18qaOupkDAWeQ0yUgGR1vyMb1FHJ/Cahu0V9whhQ1JY6S4m?=
 =?us-ascii?Q?nDy3015bY4mPnHjPohA4MQwgVFmGTEKQA3MO94H9OX4PtA8JG7ND/oFXd4y/?=
 =?us-ascii?Q?128D0DVO8oPoROhRs2H51r9mnugBMt28qW3AKfe6do2dBntV30mhRHPxA8/h?=
 =?us-ascii?Q?Q3soXNXKt4HDy2NLC++1fwjQGXDCFX/0aD+TmO2X8Sj/7SV6ze3CCOW4KD0b?=
 =?us-ascii?Q?pdaT8G7bmxppzIgSIBAd4BAmQY7h8bRPe6w7ZjPC6mA1NNP9VhwFbuhXq6OE?=
 =?us-ascii?Q?JbtWU21sYHF1jGcznfRQb7uYL7NSFr+Nzuq8pyyuwRI8sTxV8aFJSpz35/jG?=
 =?us-ascii?Q?TYANy0iXgi7w2oV3H9w6UAJHqlf2ItVJQv8fX0W304+SVtEBCOMbCfrXOgkY?=
 =?us-ascii?Q?cVxH9mFNfFvYGhGl7d5ba208cUX3Cpls4wDmI8ung+NNj7tavFylg0lGgOn/?=
 =?us-ascii?Q?wizx9FJpVbaXY9zuWLEkwhdMjT+FFcG8//iEu7JODw8AiOjCIqida3tYA8EP?=
 =?us-ascii?Q?bt5JpCXIAr+D5i2Qb1C92eD+wuQRj6RTFtpIW9kJ2980ENg1wisKXGP9+pNH?=
 =?us-ascii?Q?iht8Ze5HAGHCLHLGK5tc6VjKoEzb3YDXSpgpByW0tT5JD/L1XuKhnBsTnh01?=
 =?us-ascii?Q?5IX9djr5aDrF17fRy8GB/n+njQeDSAL1IG/u6dHRu0o9q1v+3xR/Np12vS9C?=
 =?us-ascii?Q?x7eLDWjH/X6hjrOBdMHBemus2851nC+eY2qtHXXVmtkWFL0GuQUrBTDoWHEi?=
 =?us-ascii?Q?fvcHoQ6z67OsrU+P5vAjrvtYjIV5T7LBHWzKTo2EMGVJMI9PySZIn0jUGnpb?=
 =?us-ascii?Q?JY9dRFnBQQNliSYw82ePPlp9FnaPuha1cta+wMaY4tbslfwrQhgK7fXajG3K?=
 =?us-ascii?Q?uVPIKULGVu7w/Q4ri1FR6bUwc6NSRAm3lSxC1f30hH+s2qnKjMQ+jSqLoCTd?=
 =?us-ascii?Q?x46p8lNh+/r8QJjKX16A6q9EA2LTwJG73OMP44kDMIST1TsaZultSvops2rr?=
 =?us-ascii?Q?fLe4eiOTyvssbariIYytL05mu8CJnOJ/bXAAJwGloFO0OD0XMDcShDs4SU1c?=
 =?us-ascii?Q?XlKeAMu2GgsKjOpgDC6q2IS5Zzjn07nTw+XWd91hT2HxC2ShlTpY5llQgpi5?=
 =?us-ascii?Q?KWFnFw3EvLsSKs7UBmpGisMiaDVZDYghsPWj8dW3FcClbwxuUlRTm1jfBKxy?=
 =?us-ascii?Q?QrEC88E8Myg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sY9L/J4XOmlEjvkIAyQuoAbZxsbUjomCd3Z0bBsxWXAnYKCUIUiWxP2da7PD?=
 =?us-ascii?Q?mQftgItD7S4ihPFyK3O9Gk7mUhFnZo6ALUOG/BQzDEGdgqRZ5CHiKggHflBY?=
 =?us-ascii?Q?cNmbpKhqs3kag7KolgQSHN5QytJxtWDaQkZghheYu6nQNQlRmJ53Dt8bA7+g?=
 =?us-ascii?Q?pcr1ELhCzKUARllxJg6jeFYQFJF6TWjCe/05kkmpHCM1NyvBMWx5NgXX1sOH?=
 =?us-ascii?Q?3EoV4y78QFQvbfvpB3+owBiPF/uOeFz8DG+yjmX9Y9CGjg6HZN0OsOHvsfWn?=
 =?us-ascii?Q?tAL+0sEKaeTl63I/Vy+OumHmd5mOyk0Hi1z3aQ54fvI/jonPOxxQs6W6ZpOj?=
 =?us-ascii?Q?LjgtCh/IW55G4F84Wh5lGO+rpHf0Ldc9QmHLvUfZTzsZYEceTvE/QGgY/qG1?=
 =?us-ascii?Q?iP0TNoF+kzhJJE9rrJ6a7izB8sP8kpeBounCJX+4Mh/8hm8qn2KybbJQuo5I?=
 =?us-ascii?Q?wK8XPIGF01CFwoJdDrCS37glc69AqDGTlpo3ZtREGYaSuPnyp5vANxQA8eSn?=
 =?us-ascii?Q?yGHDspynNz9slPC4u7p++G7dpzbo9Daxv/khQFyBne23utqsF6JS8Npm1gDi?=
 =?us-ascii?Q?Dr4VrmJG7jcLCbIGYXfBvBvcrCxspff6v7VOzQBp663+uhW2QTTxbZqkZ4vP?=
 =?us-ascii?Q?3j5B1tb2X/qLPxFSI8SvcIKCx0lIX176wBUnFfvE+PC06nfGY4xaVGVswkNC?=
 =?us-ascii?Q?h3HbfuMLNGfI0/TEvbKPIOUlTPfWy5J5x7SFSTQ6aZ85t+s+atQah8OTfofO?=
 =?us-ascii?Q?iyHHcOvtsTN4x48zRN+CDSz3WrlPfa+a9Ajp9Ayo0GVZOnKGtEEXNFSv1fG/?=
 =?us-ascii?Q?/TJvtZYUaKnPTIbwZnYzxYoQHJgNaiMgywf27Ag41IBratoLcpxzEJjqrWCw?=
 =?us-ascii?Q?LOxSyN86acx3CKUy6V7RA7FvAVBkEGV1RtkzrPR+8AV4tZ+4r27o59+bitBB?=
 =?us-ascii?Q?5ao91pmBOTrVnv9qsE+TkpncCIM01T3XET5MB1PT6KoBBDWg8hpIBt5BUlcX?=
 =?us-ascii?Q?FlP7A6BbYI/aManlEaY0uYJzzv2l9KEEHCq8U6m6MB+2LseEw254xNWPnlR5?=
 =?us-ascii?Q?teKSfa+EK+UIxrOb/7RBaaG1e4jLiAEcRjYui0W8/IgdOdTuuQpWaUzlz+00?=
 =?us-ascii?Q?emd2ImJLJs5YUKYjds9DBOkyuwmA3xGqHuJBIZfuTXg5KE+IjU37FFfmxSCk?=
 =?us-ascii?Q?+cGvkCFWbR2DD/vboQwLY6F+nz/utrYKDwb8BuBnzZWUTDVmVUr6zdv1ZSkp?=
 =?us-ascii?Q?uRn00zhRORxpSsGPijY6YjG/ErPTozbmnaHkhaMxCy9tALswsTM/GYn1jAhL?=
 =?us-ascii?Q?O7+B17m299BM9Fojkm+UX/z4bkdp+1rX3EZ/qoOfvFpU0GHn2XjbkKQExsyh?=
 =?us-ascii?Q?DoAGuPvul9FUYQCetDQopi0sA9ylxVGnoXKmfGHoiQawwx5VDiVHy0xjbpI4?=
 =?us-ascii?Q?ZKz0UsXARlE+tVeS/ZdJVCIaxGzRlIStbpBj5Lbw67FL7zK4bAKl2md8kYfP?=
 =?us-ascii?Q?31AhjRDezZ7izS3YDx5vkyfKg76mhBYv7DrCYDmJrgjmCitpV+AdZXesntEH?=
 =?us-ascii?Q?+zHa2J05o2/dysvHmowtk7Jg3VIPU6vDqESDs2rON4ygSB0S93X4gM8EG57C?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3tCFIrs30xwzueyOhSOIbPZ8nsSju4k7bXbapm6X3YmpsMYWIGHHXuRlbIzhsX/Gk5dQT8hR6r3dVFrDNEhGGtGzIBYLJElRyVKAxyrF8p9Ov9CY4TwFqMNiYD/qWgaeRSauKc2ET6f6A00+qcktJbd3d1YL3eHUNuswhU1XTWCtzwgdDbL/A4sOhecDf1hv2196NFPZuok5PH4UOSdlT3MewvykMlln2Z5FVtZbkK63LIoMlg1tx4KP4VmQLRq6BOkKAuB8zF7WAxrVmo0yN9PfBIt2OPf2pEjeP7o4rurWtWzz9xcD2ALRzpuNNkKDxTnNKDwTQvbIWVSWJjnM4nGgad/CEx9yS/B+DKfOiHlKOodf5BUV37TFCmlDyNsRzcnUGFKp5KRwaH7gGlrMK30wm32y5EHE76jIm/ZAd9OZ7AqiaLMkG8J3J68R1JdPQJCD0ivr9N6an2EeVIJx9wuIeYxLjIY0XvEeozhga9dRvIRK7mzgbeYjNprVVyBNUm8R8nuttDKJHWRgad9uUAjlM9JxsuCnYJgVxKq3AIKwFK8oGV6f+wZvb0f4RuZkWz1sbAJaD1mY+EpFEFj5GjQG2qidpWj8yco47QDKdpA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c6fa49-6948-4d64-3d6a-08ddd359a4f0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 13:20:12.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nimwRw0NQTgRORbwZ1WoWtBe6kCLKk0DpKL9colzbGfBRrrvlH7KeyazNE3y6xRmyXKqxHuBxnEDa3FSNJLk5SlDJfWaxDi5Vobn91s0MA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040073
X-Authority-Analysis: v=2.4 cv=TrvmhCXh c=1 sm=1 tr=0 ts=6890b390 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=fwyzoN0nAAAA:8 a=snJBH8SX05qNKFSHV88A:9 a=CjuIK1q_8ugA:10
 a=Sc3RvPAMVtkGz6dGeUiH:22
X-Proofpoint-GUID: zH3u523467UdIkoEA_02Dj28Tex1CVtm
X-Proofpoint-ORIG-GUID: zH3u523467UdIkoEA_02Dj28Tex1CVtm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA3MyBTYWx0ZWRfX6yabUzCp7498
 wGIRV4S49L8YqSKdGNAJvQX7TK3BGzbHDwb/mYkZJizoCZwLM402PQnYT1zprNL+wMopJpYoFFP
 2maBGyrdxsjPqp9lKlBwmqX1ORFSwDf1ztPksDoYeKgNgQ14fteYEphsnZ2gfrW6d6xZfk+sPWO
 knavlRtXYJAvCfTdE6hBx7FUsrdKggpAcFiv8ZFMGd1xG3JwTLSepybMP89yjVXosScYnogOW3U
 MPhrsxgMmVO0stLxKMtpLE9Tz0XRSKRXOQDtA8iM2I+2wxcTl0i7a5ZD/aYnK8zabm/sEWz9de9
 hNY5n/jCC86P7jBzyXGJUAfPcsGt53BebrpGNG1Dott9OlRXA4YSIF4goOC9RulTAMD0/FdZE5M
 1J25XubBYFaO7BaYMNFJJW4wUZviz3UWoBkUrSWOBCqdXLMOC/cfzqvRVg8PwsXyOKSfwvd7
X-Rspam-User: 
X-Rspamd-Queue-Id: 885944000D
X-Rspamd-Server: rspam06
X-Stat-Signature: thxuwfsu8ntd6rn8zjxj5z5dmqxyfuzb
X-HE-Tag: 1754313618-31520
X-HE-Meta: U2FsdGVkX1/KZwT9piXC1rMvPIXa5vBv5AzroR2mVvmbFVgbgewkWQUSMd46fKac2hDjzsoa2SNVWFdPwZJZCNfudy9mf9pEEleFa7n9446HSi8KJCTP/DXoLPbjf4mrherY8mGQqXZkYCbuVO3K3gBBRgM2O8HVvtnbV21rw8Ejp9hj1GgA56e5KgpHWkN/WLUoIa473zX1EffFjNVw/CLJEjtB0uzZ2+CSWHVgcKoXHr6A0d09PDYamt9YbE0q0eY9YaIugpNaRHDEtZDM510p5zbrB1FCy3RtMUmKSHX1nGvZ/qtlzKotsE0gKqmhe43G4x5LpUlszkaq8GzGUQPOV221IM3eljq5tz4HjifGPnC16CABD4FCLNO236yRVm1hVwhfpz6ELyCcvcOwILKmOXaFWEVkE/cI20EooSj96SkaWM+GbkmtjyB7hDoH8jWhTyQ+YNymmvkFgO/9T0hVeRqeWsiGhbgjXerHRVXhErz3E4fstZRrq8Dma4jyCTg0z9ecmnLKSrzduCCwR1kAy1JKaKT/NdCvARRRfGwceEoJabgsLfJtzB3bfoGUb12h+RTNwuD6adlNyY3gP7A14qMeDNuBbv+Zss6AoaVSdDtB83tY3MCaSVxyvnDtipDu5uwztHlebXO7EVAq6/UtI8mS+QCguMorIPxhaXF0O4/mzWyGV+b4dSi23me/GleIM6I90xcmQCt+pa5FxWEwscu7HTCwPnI1iWI/LtTUmF0dRhVOKhuk60bW45hEwmLTS5kju8+vvFP6wbvYahQmwOHFbuy9Uf/qMhpSmld0ah+GYP7Ljw4CmcypAKPlvDtZvSAYbx0WOY5/yaGWAI9VzVQaxyQ3he0YLniEFfONC0SyJ5lKUc1YVHHghjsz/W19HIdPbfEZKxgiMWDS36KtW7j4AhVZPMlpfKQeq5EyAXZWHEEJP1IANvMnHNtRXoz6LB2dbHPrCTI9hpm
 z80CZFx2
 0zT52isCNzatWFYMPblSIld5iwRVdKVpnH9KUWKGgjF6RFkd0SWwIpNcsBXT1vUxUldXHEkF6E3cNDCwV8q8GW999n2I8Lt0KFdbnncgpc1z1DNxzCZO0BugTagG3xcJv+vkpe6ykYaxogqul5vWQr8LNPouYukXWFf4T8E36/nIc0Qn4YiGM7RsGTn57wasBcPnD6abkUvhGtAG5ec9/jzwlNWeVWcZf8CTZ1VxB3PXabayjcSvwh7ieLLFEpywRPF1mETVjcN+uRA3nMUgAOeIvw3iQ/30R+ktjoyfJ9ZmduqnNRshQjRmQpm3oEVbiTPXMlV3npREd9UI+ux+6U5oEekJQ6EGysj9wU6dg7Hxu0lT8MOT7daUxxU35y8gqyXjodEHebBc2djp7ZQJz+bJZUe8mScZ/tW67UUW89OHnQCFswq2StCle0elhgmVma2J+U8w7vgXvAm+kLCrbTIC9SknolS9ZQ3iR0B+wrDzrTNwo+YtKM3ThMbfrqpe8garuil0njAnXcYjiX7dhzkg+2TFwcUGUAQPs7OTJvgi4lWf2jf639ZBqexPDaqBI3cS3yP6KGrn8p5UR6c0UTePqy95PaajADHqZeX2t/hdcZtfOrauVClydOLFL0oDEzB04hHa6NQvF1uLZygISfgDDZiOXEIrhVDHcSRaYJrCWj1wzWWQ9vDDJ9Yra/T+wqa0Z23iZSmaR6oP+cZ13qtivHH8zdQVdnNaOjLz1yFgB2fZpiJcyrZzQoY1ZA58nu/O0IO0ksRgwDC6cbFa9KwupDRSNrrRnam99UX3lRhxoOmzJXPZvPbRW5t+UnpSvtMGgxDoUXlMIGrw+hNV5lgtYuZ9m+LDd1yO5Q74UCfDLCBKermpYJqht5OW49LRftHFGSMDGOZK6zrO6sRgxovRIsO/wGFUxtS8TPNRGlWen4NY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 06:41:06AM +0000, Wei Yang wrote:
> It is required to modify folio statistic after rmap changes, so it looks
> reasonable to do it in __folio_add_rmap(), which is the current behavior
> of __folio_remove_rmap() and folio_add_new_anon_rmap().
>
> Call __folio_mod_stat() in __folio_add_rmap(), so that rmap adjustment
> family shares the same pattern.

>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

This is fine.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/rmap.c | 67 +++++++++++++++++++++++++------------------------------
>  1 file changed, 31 insertions(+), 36 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..84a8d8b02ef7 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1241,13 +1241,35 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
>  	return page_vma_mkclean_one(&pvmw);
>  }
>
> -static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
> +static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
> +{
> +	int idx;
> +
> +	if (nr) {
> +		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
> +		__lruvec_stat_mod_folio(folio, idx, nr);
> +	}
> +	if (nr_pmdmapped) {
> +		if (folio_test_anon(folio)) {
> +			idx = NR_ANON_THPS;
> +			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
> +		} else {
> +			/* NR_*_PMDMAPPED are not maintained per-memcg */
> +			idx = folio_test_swapbacked(folio) ?
> +				NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED;
> +			__mod_node_page_state(folio_pgdat(folio), idx,
> +					      nr_pmdmapped);
> +		}
> +	}
> +}
> +
> +static __always_inline void __folio_add_rmap(struct folio *folio,
>  		struct page *page, int nr_pages, struct vm_area_struct *vma,
> -		enum rmap_level level, int *nr_pmdmapped)
> +		enum rmap_level level)
>  {
>  	atomic_t *mapped = &folio->_nr_pages_mapped;
>  	const int orig_nr_pages = nr_pages;
> -	int first = 0, nr = 0;
> +	int first = 0, nr = 0, nr_pmdmapped = 0;
>
>  	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
>
> @@ -1283,7 +1305,7 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
>  		first = atomic_inc_and_test(&folio->_entire_mapcount);
>  		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
>  			if (level == RMAP_LEVEL_PMD && first)
> -				*nr_pmdmapped = folio_large_nr_pages(folio);
> +				nr_pmdmapped = folio_large_nr_pages(folio);
>  			nr = folio_inc_return_large_mapcount(folio, vma);
>  			if (nr == 1)
>  				/* Was completely unmapped. */
> @@ -1302,7 +1324,7 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
>  				 * folios separately.
>  				 */
>  				if (level == RMAP_LEVEL_PMD)
> -					*nr_pmdmapped = nr_pages;
> +					nr_pmdmapped = nr_pages;
>  				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
>  				/* Raced ahead of a remove and another add? */
>  				if (unlikely(nr < 0))
> @@ -1315,7 +1337,7 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
>  		folio_inc_large_mapcount(folio, vma);
>  		break;
>  	}
> -	return nr;
> +	__folio_mod_stat(folio, nr, nr_pmdmapped);
>  }
>
>  /**
> @@ -1403,43 +1425,19 @@ static void __page_check_anon_rmap(const struct folio *folio,
>  		       page);
>  }
>
> -static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
> -{
> -	int idx;
> -
> -	if (nr) {
> -		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
> -		__lruvec_stat_mod_folio(folio, idx, nr);
> -	}
> -	if (nr_pmdmapped) {
> -		if (folio_test_anon(folio)) {
> -			idx = NR_ANON_THPS;
> -			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
> -		} else {
> -			/* NR_*_PMDMAPPED are not maintained per-memcg */
> -			idx = folio_test_swapbacked(folio) ?
> -				NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED;
> -			__mod_node_page_state(folio_pgdat(folio), idx,
> -					      nr_pmdmapped);
> -		}
> -	}
> -}
> -
>  static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>  		struct page *page, int nr_pages, struct vm_area_struct *vma,
>  		unsigned long address, rmap_t flags, enum rmap_level level)
>  {
> -	int i, nr, nr_pmdmapped = 0;
> +	int i;
>
>  	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
>
> -	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
> +	__folio_add_rmap(folio, page, nr_pages, vma, level);
>
>  	if (likely(!folio_test_ksm(folio)))
>  		__page_check_anon_rmap(folio, page, vma, address);
>
> -	__folio_mod_stat(folio, nr, nr_pmdmapped);
> -
>  	if (flags & RMAP_EXCLUSIVE) {
>  		switch (level) {
>  		case RMAP_LEVEL_PTE:
> @@ -1613,12 +1611,9 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
>  		struct page *page, int nr_pages, struct vm_area_struct *vma,
>  		enum rmap_level level)
>  {
> -	int nr, nr_pmdmapped = 0;
> -
>  	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
>
> -	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
> -	__folio_mod_stat(folio, nr, nr_pmdmapped);
> +	__folio_add_rmap(folio, page, nr_pages, vma, level);
>
>  	/* See comments in folio_add_anon_rmap_*() */
>  	if (!folio_test_large(folio))
> --
> 2.34.1
>
>

