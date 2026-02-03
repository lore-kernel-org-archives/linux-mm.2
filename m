Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89409E87820
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 12:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65FA6B009E; Tue,  3 Feb 2026 07:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9A46B00AC; Tue,  3 Feb 2026 07:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868EC6B00AE; Tue,  3 Feb 2026 07:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7013E6B009E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:09:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E7691404AB
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:09:07 +0000 (UTC)
X-FDA: 84403024734.12.B562C3B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id A819980007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:09:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="o/G785e5";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nB2c4dgL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770120543; a=rsa-sha256;
	cv=pass;
	b=V0nSH9Iomx0lamg1Tu5n99S8OdzwQs0d/GipCk3Z39LDZJDWjADBJ4vHFPoGMKVnF0O+94
	KczJOGVQdHFEFNl4OZ57NBW+O8CXr5m57Ni/xoQ2U2muMJfE1l/ucmPupSOLF1VZ+ugfSP
	283vDxee6avpVhWsu4i+pwunrGYAM3g=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="o/G785e5";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nB2c4dgL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770120543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJ5EB9yx/v8VmIR8WDl5rZBy3Zs8q0dlaf+8cPoExK8=;
	b=Hxrf2j14WJWckBfRYMAEnX3X7eJgKsSfBb1SXA0UPlgkzB4p/tHkPvXCbWCk+QuU+y9102
	a7poCE62SibY8qY3TNaF7p92eoMqnlLzIpXmloK2I3NY7uXsDpsMNDGskn9HXodZcD4Rir
	DBiOZsmuvXxwN5Cit5ZGjs/tPOrPVYI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6138vWB03766261;
	Tue, 3 Feb 2026 12:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VJ5EB9yx/v8VmIR8WD
	l5rZBy3Zs8q0dlaf+8cPoExK8=; b=o/G785e5z44znryEsz5wbroV+zUA+i1coX
	9PS9DMPTEJuuRqZl2DNBDUIQiCa6OC/EYG/90FolD3ikHaIFDjl+/84G0k9Z9fJZ
	fhlSWiJ3Yt0BhvBY8HWjTnwfV9j/xusY1bV5HSUHki5PSNOmsdh3s7Zvr2XjCH9Z
	aCOCYq8+wlWX19X85D0Wkx93xgn44Vc5OxjMRNUuENr+VG/w5DlVwgqNXY7dv+Lm
	MQXrLZWVpJUvP2W+fAEDBnXpe1PH3mFNRxI9BgeaQza32oGfHiTBuh/Tf4Y9bSpH
	TZzBrjQO/qzNAlorOXZZx4D4tf2cCz/T2c3ni0dJggc0i+q1OuMQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arhkwcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 12:08:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 613Boxie037317;
	Tue, 3 Feb 2026 12:08:29 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c1869qy0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Feb 2026 12:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMhI+LVlR4I9mDvGUEyYk5pUMDMV3rK+ZA4sylahg1jSiNvV9i7/I06t4tn8w4tXdmRhHlJhciYpA62pG5cvmugOLtWo7ftNWoKMe5QpaeGVPSUPQpQwRHgbd7j1OPzcyzB1nqfPJXRry61ArsVWbsHV+WdDm6qm+UU3axVM6BeDo8aEIIwg3k1NMIbMR5KW0tBM0lgjRMqG9aP1BqMZsqTz6qFBUBrhUyUBOILNwJOgtM/z7j9NAC7ZgokCdtWtMVu8SFM6ka34gOq0i2xEVCvWLGU1hyVuqMmeoWYaYhnQDZWIrjfRkfZq8o/A7xII4WnuLP84JJ2Jribmmf8ZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJ5EB9yx/v8VmIR8WDl5rZBy3Zs8q0dlaf+8cPoExK8=;
 b=OdXl03gec008o+lJO1Cxp4ks6m5jplwKCVEYjXEc/Q2lXsUXT6MFDUJkJfYeRtBqSHe5DOqRywLtQr9+2KSOFN4sHyfaJ0WXegA4WbZ8H9y0DS8TGvFmauKtQXzKGd2EtWX7E15Ftfy/VwzblK9RTcaINq+Yn8w/cQX/c9z2eSl9BeDeZpPsh5P0t2Gabc+zAVQryILALVyc+hGkw2IOPfUYu0iDx05kvvVszPd5xctjq2uP+LrtcnuE5mwHBEwbwTDBRAwhX6j+nMDjS4gWykaAPJVY0bKu/GVXJU5EY9/kKjOzhFx0Dx6J9tPUWSkdzpLgsovSt/YT8ND6QXzopA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJ5EB9yx/v8VmIR8WDl5rZBy3Zs8q0dlaf+8cPoExK8=;
 b=nB2c4dgLU2/GiBZW8Fy+f/ek0msGVEZZW3VCxMwGiSvvL0HirxbOuHgEp9zcVW3ND1iurrRv4wdUCRDuwflMIz6fMD0P5ajq/XiF/8dq663b4c3VHLEpT6RNWPxddZGCo4uJk0UEtDaaDpmzTkTnAJenWmSB6/sAVrTTq52TxCA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM6PR10MB4202.namprd10.prod.outlook.com (2603:10b6:5:222::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 12:08:25 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 3 Feb 2026
 12:08:24 +0000
Date: Tue, 3 Feb 2026 12:08:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
        hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-unstable v14 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <db10946c-9743-49e0-a845-7f53a60778a6@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-8-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122192841.128719-8-npache@redhat.com>
X-ClientProxiedBy: LO3P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM6PR10MB4202:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf78729-4a7b-4aab-03e1-08de631cee7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HRMm+aTZLdYqqGXXSgWFbhw/7hnxYUz9m21LiIErFrEgl1CytAQLZnX6nsq4?=
 =?us-ascii?Q?cAJxCLKBeJCPlEy7ppx7856aTOsJEYqYEMAdLPQovMkYQ5U/fWeysu+CLNuy?=
 =?us-ascii?Q?/Rri9ZIyK3aDn6ocCMFKSpfaQPwvErF3Jg256q80JMKb0L3YN/+nrA/TbhhQ?=
 =?us-ascii?Q?RLfTCiugT2mbheaNAQPm6vEUav0Oi0dfZJOVUWcH5gNC31vBEvLf4/ygRokF?=
 =?us-ascii?Q?8n+JbsEdGd8AZHFwIrBhD3ujI2BjjlwmQfryugr0hBYTTpGOjKpfJZb1SX1v?=
 =?us-ascii?Q?403YNQ9bSUujRx6p2vsJNpMGJrcCQ1hBlcxl80B3V5L+Ij49gpBx73Hwd3ZZ?=
 =?us-ascii?Q?561+gB9EPKsW/vmctDChC9e/2gkchJvSSC8idMDEla4q9Qu3yZZI1wk2eZmX?=
 =?us-ascii?Q?3SktQHFea6KULxYXyU9IXLKpxu9yUpzuSkst+7hHKc4KL985HeaJVXwWs+PW?=
 =?us-ascii?Q?uMboTZGaoK7LdTnvVie6gJneo8i40iTct+K7s9+uz8Ox1yFNww2kGORgkDeH?=
 =?us-ascii?Q?FEvqJLbp8Pf5oofxsw+DgzVgGtqxZwcqYF/Ws+zIVQVs8pZdKnCNlZP74d51?=
 =?us-ascii?Q?DW6PRb7SbKld2JAFstxG2SnJIIC4nVF45YlKuL8IYpR1wBD5keFfCN66xHpt?=
 =?us-ascii?Q?T8Lp736X+iIoPzoocW63usvk38bXTlaOIxGJL2PzemTmvoC8QVwFaD4/7d/f?=
 =?us-ascii?Q?bVcJUGfCMHSRvuqUKjI9pWlPwads/sc/CY+KLum32p1FaJZDoQXpWUczHL1d?=
 =?us-ascii?Q?Xy3U/KNzYOki0KDMkWOC4iPEHr328/JnNWoqcKEJ0qQc0ZtkFhFJN48vbGMr?=
 =?us-ascii?Q?gtrBdQXzrPspgwS+eLU4ferhUo7D9ZRByijlDAp0mRnkJG0fGx68hYfgwa1X?=
 =?us-ascii?Q?1+RTvtDUwrzp0v6ahWvIuxxdQJak2HMkE9dfPdgspzBl8hUIrVOvE5uo+mey?=
 =?us-ascii?Q?/NFqnTKPZ8i2inyybcLEWqRSnqUGL4cqFDMHarO06GE5e9m5cQqI1xCeab/3?=
 =?us-ascii?Q?Ajw4XTZLsyOwnLJraBKia3exogHwp+xODSdDAq0SWhUIvR0E0tJ8/O/SwBpx?=
 =?us-ascii?Q?iAkrqGYY5PSQWYwPqQAhnmV0qdIhE/9miLsJtdzlDdwfaUKCGZbPtkgN51JV?=
 =?us-ascii?Q?k7KLp+akePqGS+E2ACJWf3jbtDLt+lk3pWAgS/6855sI+n++6afRo1emIngi?=
 =?us-ascii?Q?g0KuzzNHDED7rOhk8atVRmwBPsJZovuKkzy5L4tX1ZJoH8sEUEyej5nKIOvJ?=
 =?us-ascii?Q?FV/ejsY6TNHJMSlvT1YqvnIZKFny5V4frxYWnej9P2nFd1y+c1+h4HD/GN2I?=
 =?us-ascii?Q?RLCrkAfIXn1FK5jlLfwR5z8SyHbx51S/G1pgqNbSxEtHk1xFJ5/fsuKHbmXY?=
 =?us-ascii?Q?5k0T5eScEu61epy6FgQRTor7hq3Bvb5J2lNXOIxUPwebBYdI4go/ypLAp5vE?=
 =?us-ascii?Q?feKba2SRQ539TTyCYL7Qs0ObzeA26wF8yXK0++j64Gf8roPqAx/v7IJ9WLIs?=
 =?us-ascii?Q?hQ1AY9azwnR0W5nKl+D4RjGHxXrPWNcUPeZWfr3Ajt7Ilvr9kpSGbqLABufG?=
 =?us-ascii?Q?u58SF+8RxN3NVq9Xq9A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cx5zk0eQW3FTXVajPN5adcHxp4TRje2urhMssJCgpUWW7mPzN+yWGIrDyleY?=
 =?us-ascii?Q?toH5sp9w6MNVWsEg9lJbU5MJPRLEz+gs8KSp9ocz0h2WjPYbuA7TO3wjpWtl?=
 =?us-ascii?Q?LvHbOHJC74PVsZTM7w5kk4ZnKTfTr068ggn+ZUyD/AyDdajbYd3Ot9yptzhn?=
 =?us-ascii?Q?Xmf4fo6lRqbB/PqnJg6u4iGx06g3Z/bOEDzy0cHzQsGcExYJdYHPPnjFggfv?=
 =?us-ascii?Q?RjQaeIysxo6hY5/Z1kDenyzQRUTlcG5WL5JsPSAGg1M91RfBHawfL/JavRmb?=
 =?us-ascii?Q?HVTiM8aHA7WYWOgpru2jKpva6PIE3+S2Aj0OB/gUtp6lF1TBP0MuyagpVQNB?=
 =?us-ascii?Q?2/As5P+tMFbNY0kOJz2aRcNmgA3PGTF3/ZX91aoBQqhqjDPmevOThzyziHra?=
 =?us-ascii?Q?aGmLCEfQNXUD1Gzov9iKWZsxC15UKBwLvt6gztPmOApd9ajLkRzV6qa6vLZn?=
 =?us-ascii?Q?IsHu2IJnnrZR27EUvPQGumE1LCwu6FYfSTPh9xN1WaVc9xB6GJJOAqTuRVnb?=
 =?us-ascii?Q?hVtaT1/9ZXd1hySo3UrFT24l7/zOkIVB5qvkn7N0eIdzltpP2TZYaRBH7WXc?=
 =?us-ascii?Q?wgSJ6QaHpwEvgmVpsYURZHNR01nW0nm0awJObNs68ZbmtDpPouDpg5ACot7h?=
 =?us-ascii?Q?g+ZnTrXNWV+w8m9MqMoI4D1R9ooIMkhxpVkpZrMIgUjlMN1rzBgkXyJw0Xd9?=
 =?us-ascii?Q?A70dItl/l4dU8D2yzzR3SYpX2NBS0TKHdupv30aI2EXnKKpSUAVhKqr3YIe/?=
 =?us-ascii?Q?iUwNxPmYDsH23gmkBonRmIRuCKyuyNEMGDFSoILMF6yvNzKEg9o0IVpf0znZ?=
 =?us-ascii?Q?qqjdxoukTn9A+CeWfojKWrB9GzIaZ641ykDpzT8TbDeSv5NFyAXijGP/UWrF?=
 =?us-ascii?Q?euBdkkBSBLDin4kqBQPzRf5Ej16eWg3XfuIwT7BXfaP0DERGbEharagBe/we?=
 =?us-ascii?Q?U0yC3ea+VggC0BvdlwXqBotmzGgyD75Y2YYASy2xfy/08CtoWw3DoowJrmPH?=
 =?us-ascii?Q?Qk01JVxYCIs0sq3/Ncdq1iejcr/GW7jibWqMTIfwYmT9KDgmzI+MApd6xzRl?=
 =?us-ascii?Q?5ePsPDLbB2vmi/aS9TBPL0z0e5v88oW9PqE+w+41qSMxFsSWXS/fQPaq2gnB?=
 =?us-ascii?Q?4vMfoKuCqErl9QK2QPZvEimBnFPtYVZ8cAVd7Mjh9m0IkfeBvsOTS+Z5sFNA?=
 =?us-ascii?Q?GoUcVCCWmbADeZxV4P6MPGzjvrkDIxF07E6RakPrw6UmdzEUDvHywIRnGDd5?=
 =?us-ascii?Q?HLaNH71N+UCKwP1ktLsod41MBBVBWW07J0YBfhYBYjgHlmI3ZtST38oVOnTR?=
 =?us-ascii?Q?iEegBw3yDmOxVyjPlRs3vHIfXw9yLS8iPboiW+XwmABUTzJ7BFesCg9+WZmx?=
 =?us-ascii?Q?/9sQS5o/3qeDmh0sGMMsYPADUgI9WA2pldiciBD8sf2LAaiC2CvPLGLvCCy1?=
 =?us-ascii?Q?oQQFi9JmjPj4/U+Dxzo6Hbjzg+XmN/hsMaiRkNkLshdtIZwEjLqRdwPBqMIq?=
 =?us-ascii?Q?17A0I9Ja8JVk4vZGC1+5k+j8J+mdEIzCVX0ywpT2QlhnUxENmcAROiSVoYGV?=
 =?us-ascii?Q?+StfC0jAVLoBLoWm9ko+yQqozRZXIFc+NTYlnqp2/RPETTWgUc3xgzkwLCOz?=
 =?us-ascii?Q?T47dIode7NLYl2+RgdYDgxDKIdyA+8DaAzzxzTtlWz6p6+82/ISDmofGJktp?=
 =?us-ascii?Q?WjHH8dCqhBY2vwwJcvjRPVfLDx6OOIkUHNosUPfxnYgP44geZvr0Jf95jYkY?=
 =?us-ascii?Q?qbYp7Rv/ifrpUxy1ShSTfJ/M75mVUJQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SmWCXN/3IHnUKKV086LV9p3NB0y/SRKCJXUJ+SY0CzV5RxX5k0bzmBeETc0gf0xK6xvU1sJAhMIId8z/19YYtXccTRmgWAizdt9c4r2lEw8kZysYVLjatsH0xSiNhsvrMNWDND9dRY65qz4E+2a54xI/9ksOh42p/QzNkzcpdcf+9P6MSlzPlM2XJos9ZA8V96/QGG4K3erQr9VVxXplbFLaF7hK2p4OiU7lzxLIz7uZG487m/B1ZvX6X72fv8hy289TMDV/JblDQY5jGieR21zzjLdbbV6QF6580IUzqkWpxja3jyebnFt6+erG1UNSet45btUvczqIEgk/vNdzOAq8eJ3hd2R0IszMnRcy0lPHLNN1HomFs+ESSdEMFNRVZGpbClIkp7N3/UpRaCnvZ3SE1nQ9l8OPGvrTcM2m8eq2jMBOimTurf15lz8XyGCNkLrFbHeJek3WXko1qM3+j54mTJZrQEsij83fcAPAuu5iXmOWF+fRZEgpZB/1AqLT3HYvV6Pj7fufzg1Clra0yk/ET6PyHNufQyTtk9+f8r2gxPYJ3TixTcc+1t7tJ5FmMsLZ8KJA1i/YmaoyXwc5t0fSbGmDSZBToU7qceC/soo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf78729-4a7b-4aab-03e1-08de631cee7c
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 12:08:24.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wg0jggvwwDvSWXsl3a/DxWzNIReRE6PiDPgLRbRVpZFh049b13ofcYBfUUzOkH4zSO4s5N0p8OVXjI25X4ONhHVXZqL/My4bfXy2WuV7eN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_03,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602030096
X-Proofpoint-ORIG-GUID: FqFo6J7ONwveNks7T7afDtbgGN_q-IMd
X-Proofpoint-GUID: FqFo6J7ONwveNks7T7afDtbgGN_q-IMd
X-Authority-Analysis: v=2.4 cv=fdmgCkQF c=1 sm=1 tr=0 ts=6981e53f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=HStmIDA-SljqF_l6CIgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDA5NiBTYWx0ZWRfX4KaT9nldxfI8
 UkFFmO884k4/8UBxBNJh23kabc02NG/dXD7m9EyjyzgW0heCuxB/wC1oAQAdqh1c0phct4TX5Fy
 J8t03Ia57f52NQe0q2x/nD8BByyAILWF9vha6FvhsHquf40SoilA2tw/TeDr4mSQd3YwnWnQN7t
 VCgwRxTmMhrWo40Na3Grz3jDaKb88gHHeYGi56CTFbJRxQL2lR7BjjTn6NEk9f8llgPQPNtJxnu
 yuRl3uhGPRbj/zCcojn4rLVrbVu9Y20SgcbAFKNQ3eDKuucYseJZgIgpSPudqma653SVAs/2IJj
 tzF1vQBK4oPMkKRqZyRzfkI70zZkS2lt/YwZeiUM2CmAah5xJd3MzLhToImui+wfOeOJ+iKgsJH
 W8Bd4z/W0rbthCwI+Qc0k+zZYKi8hi+ECOcViqTKMDo0SrdgJP5Ec8fiK2YME785YMjwKLw9rkk
 sj5CBOAicDhXZ0UVwxw==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A819980007
X-Stat-Signature: yqjka1o9fbjawwabeb8jrh7r3iuqxwat
X-HE-Tag: 1770120543-913062
X-HE-Meta: U2FsdGVkX1/13Xg8weRJm4d72u0G0GiaTv6fkc95H2pldG66mS5SWcmWW7Vdzi46HJyC6lp9Wec4vIIsAvCg13zRoq74CrLkSpTJqv9+P6s3BAERS0oODQ1+esq0cvtzoz10GrABkPkYYj+7COaOqIgFOGqrniLZe1ZjrSdxri49yj/CpkKmoxCRe9v6ny2jtnALags0p/I7FHHRuWyOKB7Vj6bNOFUECw0GNLyOs2A+WfkwrpkH51x/IcVEcnkZ4kfJ4PgvNnIqK1PjiuYurrX/H/XlhvbgJsIbCJkAqsZ0X7t2pLgL1JCsnkCi61pewOcw/NtTA6F6fZllyM0gS1VnUJKMbW3czHZFPOaDG9HZ5jfdTQLKougYEn4Ly4pueeui26oKp9DunCLMit2C1vRAcdhKvBLTyYVWBIbCPo33UGzblwqyzQk+LzGggzZnqNALhPcdyk7gJ/iKeWhhZ5L48zhLQxPiwHb6fIFHwtaKhrpHZXdjYjs8t/7T1fuIJYWRtQDJl0+0kTuCIVUYIHZ+e3fhQO9KU7Ktfr/A0L84QUPMRa8ZqzpP+P+bgnnAqryUca1m6m81Z0Uce9qAZU+8DdHWUMocQR3kGnzDcAWT9z97EMtSl/4RHukbcEo71Rxp10NlcQ6/ZeKI2nBEWz289cG/QMriG7F8rTH2OWbGuqQlJXCkQON8a19bh7ya42oXHZ0Cq8lEaR/kQy+JNezoIk4W+6l2n8lt3pE7Hi96MGkkh4Sz1OMuf36Hdnd4gY7wiQJo1NkS+dYx1BsoUmCxQmw7/1nqsx5qzvSxQz9LAdLKxlOfcRsOH+oTpuBycUg0CUMhrK4qRUt7gmdYZfFFPVBb7jYoy+cwuRJNb/jZ3kBLuhJmpLbwqi4OPlWkw/z8+1/7335ZYwy7On9aQYe22JxvO/r78ccEQ9GIYehzZBzxmt/Ev9jGJ4xFNnK55xowzCXgSYAn83ijTCG
 ux5Ik5b3
 NznjQBeT09oPjSBJljFUU7HkYiBVpE2rmAWTm0BLlJhsr9VnvyY5xnhzoLE2BXDfZuwKDl/HbALDMKl+Gd7nlja4ATT1EWsQaLXFSfleATivWYgwzYB3/ND3qIMBzeZpPA+SwN7Kw/5BleHygsAgPEdei9JDP7OyOuKUZO+wSaWtWwhvJcEc95Cs9QSTMhKekeauDOxuDuiggNyx05kocuCKrFobFaQyNx8mlOEJ1fM9wA2N6sPnSC/Hqa/RRDRVVQgDyggxzlAfEsMAJ4EDycPgr3sE+NQPuxtgigy5QfxuVGNV7z5mj9Z6pRfCaqJkf97tAxNp6R/al2NYNtRTl5KoFLEkdqPSk25yMr1aLNweeGz9DetpJYP/urAhoJcTE2lz6R3pItydT23pQ61hhl1ZtHR26Rt3JsilFBoyMFOn4lVYmmV9y4VCsdViaCoAPs5AJA63GPVDBwMybwXFa6n1G3N3HrHbZc4NpTwDjRVc5jaC9TGdP2sFZVFSw7lrVm+l5re9+hlSrEj2V5868B1t3Y1SLTTszKmO2EngKtXg45Map7pras/YwUynD49ZcqEDHYgpqpfvlcw0ZoRVl2iv9jHSwmk87UTkt/l/hghwWGAsmS0kA8ruWx4iOM36CFXmKEMl9/SjLeIuDOymHg56KK0N5TLItX0m0HB9yuQoEMKC53qfvMzke/Y+YW/xHtuqM72IJSicCYvO/8B2wnGEPEVQ0pYKtiuwWE9m6tL/6j7kb3+ib/XdzcPEbztXSco9GCp27CzjLDlOyTelLTVhAhp5KYpuguB7zra9ZBDnJ2Ty1VzC1Z0mBbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 12:28:32PM -0700, Nico Pache wrote:
> The current mechanism for determining mTHP collapse scales the
> khugepaged_max_ptes_none value based on the target order. This
> introduces an undesirable feedback loop, or "creep", when max_ptes_none
> is set to a value greater than HPAGE_PMD_NR / 2.
>
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
>
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes:
>
> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>   available mTHP order.
>
> This removes the possiblilty of "creep", while not modifying any uAPI
> expectations. A warning will be emitted if any non-supported
> max_ptes_none value is configured with mTHP enabled.
>
> The limits can be ignored by passing full_scan=true, this is useful for
> madvise_collapse (which ignores limits), or in the case of
> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> collapse is available.

Thanks, great commit msg!

>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

This LGTM in terms of logic, some nits below, with those addressed feel
free to add:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Cheers, Lorenzo

> ---
>  mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 0f68902edd9a..9b7e05827749 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -460,6 +460,44 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		wake_up_interruptible(&khugepaged_wait);
>  }
>
> +/**
> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> + * @order: The folio order being collapsed to
> + * @full_scan: Whether this is a full scan (ignore limits)
> + *
> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> + *
> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> + * khugepaged_max_ptes_none value.
> + *
> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
> + * collapse will be attempted
> + *
> + * Return: Maximum number of empty PTEs allowed for the collapse operation
> + */
> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> +{
> +	/* ignore max_ptes_none limits */
> +	if (full_scan)
> +		return HPAGE_PMD_NR - 1;

I wonder if, given we are effectively doing:

	const unsigned int nr_pages = collapse_max_ptes_none(order, /*full_scan=*/true);

	...

	foo(nr_pages);

In places where we ignore limits, whether we would be better off putting
HPAGE_PMD_NR - 1 into a define and just using that in these cases, like:

#define COLLAPSE_MAX_PTES_LIM (HPAGE_PMD_NR - 1)

Then instead doing:

	foo(COLLAPSE_MAX_PTES_LIM);

?

Seems somewhat silly to pass in a boolean that makes it return a set value in
cases where you know that should be the case at the outset.

> +
> +	if (is_pmd_order(order))
> +		return khugepaged_max_ptes_none;
> +
> +	/* Zero/non-present collapse disabled. */
> +	if (!khugepaged_max_ptes_none)
> +		return 0;
> +
> +	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)

Having a define for HPAGE_PMD_NR - 1 would also be handy here...

> +		return (1 << order) - 1;
> +
> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
> +		      HPAGE_PMD_NR - 1);

...and here.

Also a MICRO nit here - the function returns unsigned int and thus we
express PTEs in this unit, so maybe use %u rather than %d?

> +	return -EINVAL;
> +}

Logic of this function looks correct though!

> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
> @@ -548,7 +586,10 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	int none_or_zero = 0, shared = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
>  	const unsigned long nr_pages = 1UL << order;
> -	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +	int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);

Yeah, the !cc->is_khugepaged is a bit gross here, so as per the above, maybe do:

	int max_ptes_none;

	if (cc->is_khugepaged)
		max_ptes_none = collapse_max_ptes_none(order);
	else	/* MADV_COLLAPSE is not limited. */
		max_ptes_none = COLLAPSE_MAX_PTES_LIM;

> +
> +	if (max_ptes_none == -EINVAL)
> +		return result;
>
>  	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {
> --
> 2.52.0
>

