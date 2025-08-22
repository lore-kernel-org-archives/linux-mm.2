Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B24CA0FE1
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94ED8E00A2; Fri, 22 Aug 2025 06:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65B28E009D; Fri, 22 Aug 2025 06:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C062D8E00A2; Fri, 22 Aug 2025 06:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB4E98E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:42:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75F7283C4C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:42:15 +0000 (UTC)
X-FDA: 83804053830.17.13C0E2D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C25340007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:42:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fioQYRYu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Evs4ieop;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755859332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSp1tBshYU/qiG6ZTgfD8aS0wKcEcW5Vs6/IIRTu0Cs=;
	b=J1kd97oVWqZUXufVQJS84dvFBiAPukghv828a9PY2Y6i8VRuh0fenyeiHOfx2ZIyNFUTzP
	buciMhoJh0rbbPDAEgNtFBZEnTMhv5He9aVI5BrQw9qp0cZLDq0yIjw5NznOaU5WU7wibO
	lpw5DbC1U4z3uou9C6pfyYC3PYQhoZc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fioQYRYu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Evs4ieop;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755859332; a=rsa-sha256;
	cv=pass;
	b=sPIUPWHxuXK2IXp9fcIK7s6BUNJ8n/tk/5VlPDdO6d7w8fZsdUUgiUnK8E9qM/LdLB6YkQ
	IRT+aK1qmnpy1ZeRzLG79mD3sUbBi3SZ5sra5DIRp/IHX94EYg4Fc/QZSz06vC9gAcSfrO
	Acf4f9f4KmDQMFlPpcxwbnSAKFl73wo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MAfQjW020321;
	Fri, 22 Aug 2025 10:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XSp1tBshYU/qiG6ZTg
	fD8aS0wKcEcW5Vs6/IIRTu0Cs=; b=fioQYRYuuHQkNqyCQj7Ez3sEiZJSvCo3w6
	gsG8iaTw5y0eIvFecn7eASsruH7Rq4Npt09sZnjTWEPy2yOTluunrkCtpElH4dB9
	I58Rn1fTvFMQ1L33NSQtkxpT9UyyHIOQ9M/+8/nyawjJlCu5qD4gikLp6mxhrf5f
	S8V0tXEWD+U5vzgL3j2L1eHMMhdHiBYVHEy9QI22j9akErFDFnKVPnEORo9r4SdG
	uKkSJcibGfpQ3InCoPl1djXKEkDX7XcEaNoxl3+4f/J0tLp0Rd470dBDjNqchgRH
	jcZP9fQYm3/rL2/1ZMu69eRs98PEnY352JGdmPYYZhkgdCDIcH5w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr57kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:41:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MA4pfQ027228;
	Fri, 22 Aug 2025 10:41:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3syp5a7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:41:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VpANwMBoNLONsK0qgwozCS6KpOijfTucw0mXUklRDvhUsjXAjTr3ENZXcDd1URsLqqcEYtCmoOrP+R0Jc0ByHh2o3v8D+2dquiMOnxZ1xGHda28JT5GmUPKrsKq9sT3Ud83IV91upzmAXLu8iqVq3fQVSyc5BOfAEKDHeQtMQwYdiw1eokB9BHSU364s5DoF+RKhbHhS3bQHBEPGw3RIcbDflvoqsoqxl8pC0YpcJjhBLwcJGEIRIbSUD4mSgQ8EkcdAqZILfk/vk7nXzdpRWkKAd9ZpmYR0UObNTZDuiVa3eMVKHFB2LWiv9r0oZBuIng6KyRl6bDAimAtZ1k8u0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSp1tBshYU/qiG6ZTgfD8aS0wKcEcW5Vs6/IIRTu0Cs=;
 b=tcJM6TBgDlCjokOGovegVsn0wvlAPgnBR4QAbf3258NTLv88Mv0awcwudb7JBQBNSxgL2yS9g7s06VlzvdKDmzWO0Ct8PDx5CB1lsFYeS1f+Di4NSvK2jxNcIHDfyboagx6I2g21Sa+56BKuqn6ndaFA2PM7Yzp7ef2cRCBNvYMTm+IZCyL+yfCPshfNDb7TJHqyFCJyyiQmHXbaYyYEbY9hHifzX1VDqRr0rtGtPGF3wXF/4qf13qWyFCqgYcvgvzVVDDHIi8AXqpF/nZRp9ajtTM3t5wxm3a/063N8b9EtLPO1mMol55Q1zPE/CAA/Ep84bq7n5gzeyky5bkXDnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSp1tBshYU/qiG6ZTgfD8aS0wKcEcW5Vs6/IIRTu0Cs=;
 b=Evs4ieop/dbp9TStgPy9lppG0rgILQ1yu8e0ATM+mhDKPr74jFFmSlAae/h6fnsbpyiqXC2KFpBQhj+ufkFG/z3+PykapluwYt9r4hi6cABoZnUZlKwuQmwjNRdDMdsb6P7EamdGoLAqY3AjbvWaHFkSeDZj77LBF6beEIRrUs8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.18; Fri, 22 Aug
 2025 10:41:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 10:41:47 +0000
Date: Fri, 22 Aug 2025 11:41:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
        mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
        peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-ID: <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
X-ClientProxiedBy: MM0P280CA0044.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ac59122-98c3-49dd-978d-08dde1687eb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3PZ9sQZXVFjDh5NF9wwVtmuy1MFdZPry3Ul2oZYdlAFFzHcyP9jB/6HX+blw?=
 =?us-ascii?Q?kGSedXvdz7pHXRZdSf1PVM4fSBfOhHn4hBTzb3/+lVXO9e0m/bLQJ5hNuCGx?=
 =?us-ascii?Q?5Q2JlKnnfOoPKJ/qN4Ty5BFBjogEwY4bMfq9Tj7tgcGjRjeUR2sUS4myBaaL?=
 =?us-ascii?Q?FwyV+Wqswi/FEXOH0Vk4KQiEFG3bLfmVPU8eoFOcVkgZ/jqnzOtQMOAuZHg4?=
 =?us-ascii?Q?ppeGOkRBmneNl8hXAD0roc4m1NJ2qI4HtCt6sKwl/8tlqVZ78/fGM9KB1gV8?=
 =?us-ascii?Q?rzFT5EQl/GyQ9p4Tx0WsgX3UJVde371EmW/hK5UcAiMXcx4d5fxC0C91mjxx?=
 =?us-ascii?Q?fpngEtdUlqWQozVcgqYjqCq4Gypf4zraR20sVrityXjPaWyzD5VSp8rQ6uLP?=
 =?us-ascii?Q?1RPM8NG6lRVhI6ek+HpHSSz2bD/y2i1IPevykCdNmwOfYT3f60jqDWC/twW4?=
 =?us-ascii?Q?0NsbrFbzav4eRiTHYrEK79dEmhzQNIMTsEC0JJmooi+LPFC28uY92Bx42qO3?=
 =?us-ascii?Q?yCzCJi4Anw7CgERbJQR+DhQ1ThA73NXqsnCJRjh8fO1P6wGq0jTl0q8XvLUB?=
 =?us-ascii?Q?8dXxCD2JRE50Dt4WYNGRk/u0vduISJfyinbW2FrKJNDvhZOr3o6x/o/B/zy6?=
 =?us-ascii?Q?HgXFdsG380Vb+sPhPAcpzgXs2O52eZWLg6hCkCt9cSrLx44f0pGwGXzPvPzw?=
 =?us-ascii?Q?onesSILn2n2NNB8FHnrbGYzPEhIe9T+aN9khvpjxipF2eMm8aTiR+BXKO8qZ?=
 =?us-ascii?Q?bEhw/2G2yVKwSI4yMLJ+ZCIFiSsQ8+9Uj2wVNiBVjne7ex2I2ozevdOUbeOz?=
 =?us-ascii?Q?CfGUaYY5fLyCOcYeLT2CdLqGwayV4MpwJlUOXANG94G+KFl0BV1ID5ev+Oyt?=
 =?us-ascii?Q?sUiMpbcNkf7YUqHmH04u4aVjIAXPLVG0pU+nz4Yr0BIi2/jG4eh80Ug+K9X1?=
 =?us-ascii?Q?GkEcLD8iT4G6u9Srg26nkXYJDZhuBTqWXKCDwB0upGP8GF9WrEHmrPSQnEDf?=
 =?us-ascii?Q?wMuTNCzOdnnArDxSQj+BMpEsZRrQRvT1QUeH6KfJ6pY/GTVRBSlrGJyi2Vbx?=
 =?us-ascii?Q?5VBopcFYeiM4DLZ7ONN6GFPV36+G/FZhdEp8YzcIybXTlNaba4cWNsyjyaKy?=
 =?us-ascii?Q?wIKSMKr+qlJ+t8JemcXIgjAv7sDR+DIIT94EpO16Pf5b+Qll891+bqRPqTEU?=
 =?us-ascii?Q?KNZ4NTV1GL4sEPUimfutej3tzbzDvdmDaZLPmuJH0YkOLem6WJTCxfF8iniI?=
 =?us-ascii?Q?yXOaX5CGRp4HB5RIfSHrz4tG4aFlMcjcWmwh7kQlpky1IQ3GF5ag+LXWqFYs?=
 =?us-ascii?Q?mhZekDj0NZxsV82/wfFGGLEq8uoGqTZJUFLMuy8EG3JbYDqLa0GRRD8wDbIY?=
 =?us-ascii?Q?0jVRgVOsCp/+wer7URsS/wFBxFnwMXdwt1xm5Xd3WNdwP4x2rsuIzK0oTWkG?=
 =?us-ascii?Q?xYUKSMmb/78=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TnziHasQDIgebOewJSqp0O56W637Ig70tzvQYDZvbMOiqWH6kTIAT78KcGcI?=
 =?us-ascii?Q?pr1DAKB4fCCga68hfGe6b54UQTKLieBfSy4l6bwjf26SJOTnhRNPSrqNfzJO?=
 =?us-ascii?Q?KOuV2CnK6lx+lZFa5h39cw6bDhMrexVwziiWzcJuosVEpnWNWK7IoHra1hfC?=
 =?us-ascii?Q?ji/Qktc+Dv0HzkIxYXoHoF5KtVZFL5FaorNsPOkKJMk9qo3bvbrQzil0ZdQ4?=
 =?us-ascii?Q?XHyKdDxxlLByIuUpRGKuSJcOcEViMba7V6FpXC+rhOzazrstueYN7lelcNNK?=
 =?us-ascii?Q?f4JOloHiGSgKgyILd1F1JB1bhy6ImGNpc50Phil/JHOkvh07ucOR8hkfvVrJ?=
 =?us-ascii?Q?IYWsPHFlreDsjeXU157QTnpY9EXFjxsqM2X7s7Su1QJ3n1jag2t285KWihVm?=
 =?us-ascii?Q?fkYjiTDDoEPKwCqIJBS9vSVTj1DxL9N3vpPID6FDTVXD8kTgNrpbuwiohTOL?=
 =?us-ascii?Q?AvGIty4m8BSzxRGQidNgx7DeqaA2r1W1JCNr1fSnXueKJpJyPeJdQ2x60dGa?=
 =?us-ascii?Q?1UBcJJ4jdAmJO4Y3LdB93CH5gHtUDCo+CxapOJiBRGJYcRcOgIPZAQssUTQn?=
 =?us-ascii?Q?Rn4a48eaQeXJysZQ9wGjYnBaUupZ3ZAc6aE3hBQsOHS5kfsF24b7hmPyQPAV?=
 =?us-ascii?Q?VgiwKNOhOVI4DC/3RyzcjsTXpRbkruVO34eetYfC7soKfc1PCsmF89AbjqBM?=
 =?us-ascii?Q?szmZqrR3i6OvuDtePTtG4kNNC9VqfVm3M38ehUHjnMWb9WTh1TO7n9SKbzWs?=
 =?us-ascii?Q?K2lbIkemABfmDB1mvyeNAkIfyNJTJUyZZKHWP4eaLCU1+twI1m4Cl7uu7Tk6?=
 =?us-ascii?Q?EjMD43hKiE7fiWJwIS5zjI24GGFsKi6EvmJte4uuXBRgz/d6zVa3yFdzNMP7?=
 =?us-ascii?Q?fDRq2uK8y0qEZp4ujdHGaNcSHHU1RHSSg5cuaoxPMtHHiaz01vJbbr4oTW17?=
 =?us-ascii?Q?euHby6/7GNwUW/zqEMsaEBLXpHTMp74Szgz65cLXOnHctgBNvQeeBg4/fqkI?=
 =?us-ascii?Q?bIlwJjvZ4zpIwy3ZQKaHxQ/qsitUdxFDa5yQEiHAN6LCdY96HHogrZwusHgj?=
 =?us-ascii?Q?yulOM+44dx8pqqs8y2jL5mlssPotAeorAS089C6Q35kpwqxcJdNR6+8cp33e?=
 =?us-ascii?Q?uoZd/+ccbFTvqB1Skh5bVurZsfBUq6e66w3tPkM5ahwljGmLkqtETccU8Usb?=
 =?us-ascii?Q?ngD3Ze/Ve+t2xqyCjS+OAXYYAp5Q4TBJjbD8Z9L/AyhXlaog5N5Efss0qYgR?=
 =?us-ascii?Q?vObdR4I55cxCBsKkuWiEfhSJfIl//fSrMjfGg0p5bambRbDSLSq7goU/0eT/?=
 =?us-ascii?Q?ff0nGfcyJVZrfeGYmheNNmyF9Tiap1+MgRKATNI2+KR7fQ1Rk7VJb2sOe2bS?=
 =?us-ascii?Q?8iEHB64z5zVEdN/ruSolBAEguf514dpq4HUpRpBRY+PC9ofJlyfJ6R2JyuBQ?=
 =?us-ascii?Q?xKANtLXllWMjXBtlyf0EdLZ8S1eHcMPxDeIPPsqlJ5eJph43WtytEuP2MVBc?=
 =?us-ascii?Q?+v7oCLGjE3FgqAQareN84YscgjGykkaf9CYJuJbngLMoORMjrxCgMQSEum2b?=
 =?us-ascii?Q?sqEZ9xtA5I3rBsO3cOYNdiThWQv38H7LBmZZoBLfX5ACI69Nds21IcaQj19s?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z0y29sbw0BFarOrFhT7fHimYpPhMA8/623QNCnTcQ8Wvoa++4YkCUOWbuqGkTepfgeCump72rGwTJ+3CmIjEAB+SuLHVfteU06znz0EKQr6E2pPEHIK+EvJRL3E/2u9tcxDKpw01kgiWbJXcz970KNOXdQgiSPPm9hcl7575p70fDIWRyg+HtSo0RXn1d5cyjoZHkKmWzGtUdN1Kuf1+p0MuqluiI61OZiGOkPwHJLyZDzVMXxHNsSYXjyB7kudmaQsi1nyMDC0eOW37nc9L56+x64YBSdu/XSxiwxUtavh4SkvVRDhk9cJQVrwNn6qAP6BJXSxlnFjfjWzKz8zUSGl8zoK3KLDjxz0McyAQJ9dmcJtaYpJZKQvzHtsYsjAd0gEhyHyUTZ+nzcqoav5rwKjdv3OsHwYXUTSaiJtfZ91FhXPP5nYcnbbv74UlKGDUiwSigU+AoOjLHIVaRGJyR28gqYeiE5yEZY1VyF64mM2z5XcU6wi3fXPyTV5TTXXeitTRYRus0Y108nfitnutx+DakM+37hHTLOWzE6MZ1pkS7wBFnz2aBakZYORbVL7Z8W21kGU9utg7STOEmL7QY4kdgWRteCUJWw3c7A10z/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac59122-98c3-49dd-978d-08dde1687eb0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 10:41:47.6576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LCroaBYLMlwXzTa9e6KnBfr57eaK8yp6lWpF2ncyDaVHygEoU2wDcr8j/YSWPBn7HHk8CSHGPVCAxP7+S3OISU1Ne9tUXnDUr7cfYdHT2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220100
X-Proofpoint-GUID: 6w-28eY8oGnbeyzUfgPeGovlCCrtyoGw
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a8496f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=C5NLWshkwHPQOkuYpVAA:9
 a=CjuIK1q_8ugA:10 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: 6w-28eY8oGnbeyzUfgPeGovlCCrtyoGw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX6UMURLkTGfzQ
 vVUE7Ty1PgqVP4Z1S6rORw8a1YFUzgy/Vgb+Q13af04jBRrSAUc0xbimliWfATpK9fMDZSKo593
 s/biHqXxn5IQpqyUiRyCKkm8YyTqDSc6yz47D3lt/nfSYEPtiWroHISBzVCKkT7Pc9SSYsdzRjf
 th5ZgDql1x4Btr9JA/W88nIVbQp20B+VcN+4rOamOZPyx1t9SEHpNN/MS8j034AOo8kjELm+liy
 4zCSdKpFyROL0TJilZI0Vh8P7mwbBf3fAnZOgvxwvdr3Zcjw2yyoEzbV5Syj15X9ME17H8zYvTV
 e0SY7CvVy603hKeJcBWo0O/k2/PGJug3/0ePC/YRayzB7/Xq5tYaABjImsqvcyvBXASiZA/+GE2
 yuoTJKmWw10WV28OAFR3v065RWLMRQ==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C25340007
X-Stat-Signature: rbpeg478i1m6k7dfps4goenecd5fmmbr
X-Rspam-User: 
X-HE-Tag: 1755859331-60282
X-HE-Meta: U2FsdGVkX19JFNXhDv/ptwEGX5vsmytqaL+e4Ngd0OtZs2juNYQ8q1TJ77GPqJaiieh5fc158lWWJ5BNfReri4gHTWpeiKFJfTqyqBnpgE2oxTgXgZYcxyi8FMr72hVlaSeq2Y6tnmDehvVsWZL+oh5iySD8WCuJVHdaW2WTwiukwjzdqSpDrpfX4E2P+byETobDcBxy1v24AnqurzCeHLvxvuykSX8ho011pW5TkiqNXQAmZ1uWVXY7badL6xfgp6oyx1b7lPaLXKez94IfKN/Eqh4oyuZZKi8nvWPcuYjm5bNVuU2VsHqG5VOpKY11Rh5jYiPP4qq2VdA0WpTCnwTWfw2SAKrcmJQNX0WWbAV03FUgPiZCJJt38N9kNXIJE7/Vy9NVSR7bqLyIX1aJq9d5j7LXh0LcildRmw/H9dzgPODDStPNxpXa/gOWbgW5c14uyO6GfjF5rGdbluwDzKsxpOvfs0gF0hxO2IVG7wCYRA8KvUwfwNBrFr7t18pua4utuvbxKaAn9bWLRMLW7oUxY65s16Bqh7C/fAKSmXF3NUW9AakDeBmAEGeuLN7xF7zjOse9UL9oIqKi046qcyBVx3Yn0RL7EWivELHRYxIl1H5WcNTcJRG53yhJcr75k0D15qIavLKTxaBGBlDhWNm3Q+ZjaraFXblwvZCSn67ME/qnTW6sbxYoUGJwMI94sphewLf0Hw+++ACHHD9s9G8k+p83cvN44WWs608aYib+BvPVynE2AmtK1SHv+mbr8RM/kmcrEd/djQxMgUVQEX4MUiLKdvWvOgWOk/vqE+KwegWybzckjVwizUGxrWKNvpVfF67UJKZiTowdaXf19wPpTmldlQRaRLJYZ7qasSbzNHx+WENgss90qDg9r2RmBaUq5Wy/TD2WmQOeCbLyJmqKySobgz22asy78Wsnq5Ha2fkl5gWI6tWS8RwmCtEzYql0rpBJlDznPC5eNbb
 DsqTMGII
 XsQS0GoTcuu5LUUphRFaoXNoITsv8znzpa0yNu4i1fS2hrY2VVBqawj/VJ1lWnptRX93MtwCIMXDL2YqxgJIHpDCyLLgO9ntFuFIvQo+kqliq79qdkaQEDeULa4bjjN3xWqrrareKyABH3nGCAtHZ+codbA72OKWpZ4OfzBjsoSJTyNsXPtFwOB8YRBDpdUiCBhbu6ZX91c7TEQ3kjtE02SkyvU3X3M0C+2/L0HBiEtZgDQsEcQ0z3CHL+ik/XtVx7zAYmSinvUAlz0FATa70mho5RR5eiLGYJex5kIGrJamC1bad8GQKOTvv/BY/unVuVlAXN9jp7NP/9WCbu3LCONaxFDZWOR5drEB7DHz58FN69Fvht+4iMoc1Oc1QD8nGAWD7oTnEYTR3qXQ1s8KBNb+/u55mJKDxFnaPyQ6CjzzmS3B+Kn2mtApRRfoyF4gmX2xtYlPJcAUByXE/qAozhuTfwO7+t2AyW1NHgE0Ye0ecehZQHLtCRKslIVnjL6G8ueHO9CrC5Zci90Claad2LurvCyWPjMc89S/cbUTu5cwWDyoF5n12PuwQVqD75Zr8wZihtovmsir0Mcp0HcVJ/3hr+2ZP0iuCQH5rPxLOAcR71I8I6RSTyDlnm98PZ8Il4rB6WnnDIFHfLYiPPH17EKV9fRlWoSIohJitlxpWXjCnHJXSEntpSMMC0S5xme8k+sqFsSe/NRIY5B72rqw/hd7FuQu16y7qpHMag2oiuzoUSsD5zop/sKIfcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:43:35PM +0200, David Hildenbrand wrote:
> >
> > The one thing we absolutely cannot have is a default that causes this
> > 'creeping' behaviour. This feels like shipping something that is broken and
> > alluding to it in the documentation.
> >
> > I spoke to David off-list and he gave some insight into this and perhaps
> > some reasonable means of avoiding an additional tunable.
> >
> > I don't want to rehash what he said as I think it's more productive for him
> > to reply when he has time but broadly I think how we handle this needs
> > careful consideration.
> >
> > To me it's clear that some sense of ratio is just immediately very very
> > confusing, but then again this interface is already confusing, as with much
> > of THP.
> >
> > Anyway I'll let David respond here so we don't loop around before he has a
> > chance to add his input.
> >
> > Cheers, Lorenzo
> >
>
> [Resending because Thunderbird decided to use the wrong smtp server]
>
> I've been summoned.

Welcome :)

>
> As raised in the past, I would initially only support specific values here like
>
> 0 				  : Never collapse with any pte_none/zeropage
> 511 (HPAGE_PMD_NR - 1) / default  : Always collapse, ignoring pte_none/zeropage
>

OK so if had effectively an off/on (I guess we have to keep this as it is for
legay purposes) and is forced to one or other of these values then fine (as long
as we don't have uAPI worries).

> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), but not sure
> if we have to add that for now.

Yeah not so sure about this, this is a 'just have to know' too, and yes you
might add it to the docs, but people are going to be mightily confused, esp if
it's a calculated value.

I don't see any other way around having a separate tunable if we don't just have
something VERY simple like on/off.

Also the mentioned issue sounds like something that needs to be fixed elsewhere
honestly in the algorithm used to figure out mTHP ranges (I may be wrong - and
happy to stand corrected if this is somehow inherent, but reallly feels that
way).

>
> Because, as raised in the past, I'm afraid nobody on this earth has a clue how
> to set this parameter to values different to 0 (don't waste memory with khugepaged)
> and 511 (page fault behavior).

Yup

>
>
> If any other value is set, essentially
> 	pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");
>
> for now and just disable it.

Hmm but under what circumstances? I would just say unsupported value not mention
mTHP or people who don't use mTHP might find that confusing.

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

