Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B835DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5901A8E0006; Thu,  7 Aug 2025 13:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5403F8E0001; Thu,  7 Aug 2025 13:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BAEE8E0006; Thu,  7 Aug 2025 13:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26E638E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:54:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4F32160885
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:54:01 +0000 (UTC)
X-FDA: 83750709882.13.7556181
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4719F120004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:53:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O3PWsMXS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HgN4RjJu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754589238; a=rsa-sha256;
	cv=pass;
	b=RznmCNsyU/wSrEhiWQKSV/FvlrGlWQ5CjSGTlNrFLnzes/RI1shPy3OlsFqKDhTiTkZglQ
	Jhp+TDMLPMjePIfGPm8sx4pE2IeB0QGQm1P09udTvB3GKqmyt3BKYTCFBFHGq5ID6N3Sia
	cmjyRn3wXnvn8PuOt7P4X5rqIU3cRug=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O3PWsMXS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HgN4RjJu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754589238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDljsRghYoY0jtF3v2LPU8hIFfOjGyMQHTuN6AiHZms=;
	b=JdflDtBiuE9oLiZ3/5924/t/d6sH+6OjIcv8nUXov+YHQcpqjF6O2z0UhgBub935mknWaN
	4Xlh8lZBufEXmVnhEhtVdF8iSCuhR1F7gb1x1qTaVS/7JtEBjl4IdKfxRZ66sbMbq79x5d
	yvSUPmtJBRQ8Z8BmOctc9vCqeE4y6MM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577HCFIn009765;
	Thu, 7 Aug 2025 17:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vDljsRghYoY0jtF3v2LPU8hIFfOjGyMQHTuN6AiHZms=; b=
	O3PWsMXSymFH4VS6xSZ5hq2QC1bP4HZJ/PwHrQUUp214n+a4na8u7AxeaiNlwFR6
	Mz6nijpTUCpakEvRn6BufES15CW8LeoH+E6ffbTeOU581XlQv/dRFeaC0apc9LU/
	lsBERcJrpEKVVE0wVo8/0qY6/TuMlW+p/Hgf56KZ9wFxkUg5+m+6KRtmjXsGmUye
	UQT7c4E95rDws9yoPF2pO+5nxrsTfgfUHkWqPM/pmlJvwGMQWo1X8omc3HhiIE76
	05ZvHHEFBqQWme/YyVD/E4lH9hMUNMcPKhhBX9YZwidbuiADsM7Rk3WcPRHZlBXO
	NuCqgshTXlq5qNYAhGRK2A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvjvkxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 17:53:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577GWFEa005647;
	Thu, 7 Aug 2025 17:53:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwys2h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 17:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwW3g8yeN0VKqmrtM4R2EAo6YGYRbnqPkHJdapvQWTC16CNRcnk0R05G/lp6ba/YDbgxnoNgKEnI5DE9uRk5xX5uh9myl0FyW+9Z7vjLPTdxpfvh9ft3bYlwC9H6sDzjfnLU+u0o0jhA44KqG+MmYqNF/YZ8NsRANbJRsMchJi75Rbp5dwCzdClAPMg/9MmBvFuzy/mtskTjEt2P3friCNrXHu/J+U1QAqKPIvStbTfRVQR1HID0ZvboOYrfaTSF/J80kZZtlwYgl2QLhGPw9ygWF5muFDx5gZAIufmwmyb37qihwqtR8HF11BQ4skV0DoI7/uojOVwNpIVPJ3Araw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDljsRghYoY0jtF3v2LPU8hIFfOjGyMQHTuN6AiHZms=;
 b=t7J7yqhxa+ugbBFu7BHCjZUCRN1An5GrZvyh5VHVnVJNOXkuOYYe8Mi8UfDKLNEt8st/ISO8EmDJBGq6dW3U8JwdIA40Thm53xmNHHEbPNjqCmfCuj8kZvQM1ZHyrBGGBDSbNPFRXcn9GSoI1HlKUU/SO1FurJcaULJUXvkpLejS7CZ5cWIr9WuiIVPDkYwyOPicXRR4qJnRu8WtzN72KOGbsV5v9uNpT/nfUHd4VaiJKY4paXlk81KTxRjADo9SpJ+pBZQd3A3fCM/1Hp34VQ8UVfWgNAiyeyMYGGRUKZ2ABVTShZD6o9fdBwSWD+6bt1SS3ilGwplVd3kPo3RvCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDljsRghYoY0jtF3v2LPU8hIFfOjGyMQHTuN6AiHZms=;
 b=HgN4RjJuydynS7bt5jP5xuF8QW0F1fvIM9driQemTa5QOwdwgm8Bt+zP6xJRSgbW00+7p02tS04Hu8IcXic5DJmVsT1SCYNCSPmU4wXHFT0ZWi8nPcfv0yvn+Lkol+t/e9UXuFYV7UNenzlj5A0wHeGdqIPw5pXwG8gJKuLBJMs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB7465.namprd10.prod.outlook.com (2603:10b6:208:47a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 17:53:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:53:27 +0000
Date: Thu, 7 Aug 2025 18:53:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>, kernel test robot <oliver.sang@intel.com>,
        oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <0f0a3e8d-e83e-43b9-8a26-7368a0655f45@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <cc727530-8535-4d98-9fc4-f6a36941ca75@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc727530-8535-4d98-9fc4-f6a36941ca75@arm.com>
X-ClientProxiedBy: LO2P265CA0367.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: f81fd2b1-513f-47bf-07b4-08ddd5db502a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlVvckNoeEkrNVJNZW1PVHl3cCtvRzFYY3ZHS2xRZk50S0FCM2tVQ0psVUdP?=
 =?utf-8?B?OTVnOG5hS2hIdmYwV0k2Qi9yVithNXFZTG1ndUlhemMzSmZINUJ0V1p3Uzlp?=
 =?utf-8?B?a0FzOHNqYmdzNTZsRUNBOFJrOEMybjVuVUNuOCtjUzFCcm5CVWxHclRma1NP?=
 =?utf-8?B?SmFaRDN2Ym5teUxBWmVhQ2d6bW9zMWowVFVuSHFJUGxzci8rMVpKbUR5Sit5?=
 =?utf-8?B?WXJhNmFKT0F2TWxISm1YcFpPSVJtbEo3bjRxWllCNzdLTjRxbWxtZWovdnYv?=
 =?utf-8?B?S1hlOHZ4bGVMODgydWh1d2FabC8rSXg4Zmc4OWZsQXhjSGpoeHQzSFRYbExV?=
 =?utf-8?B?VURSWTAxaFBCTDljc3dCZHE0aFliVmFXTnUwcldQSFpTVVE0aW5mSGNSSHdQ?=
 =?utf-8?B?aHFLWmFYdzd0WEhoVVIvZk9xQmlwMHFNR2RwNFA5MGtROXFrem9rSTArWlhH?=
 =?utf-8?B?OW83czVpUlBhc3MwejdxTHozamt2WmJzMis1a3NSZldyWUVvbkRoR1AxZmNV?=
 =?utf-8?B?bjZlUU5acWRTTThVRGZVcC9zMlVERkdleHBkQ1lyNDdCV3pzR1VycHhxaHRH?=
 =?utf-8?B?ZE1LU3ZwM2crVFhibWNPMFZPdTdZbllrZ1E5REFFRHlLVjI5OXpoaFprQnMr?=
 =?utf-8?B?NXFGZnhQRXJEc00yQTBRZnBMQ0RGaEljanRUY1JLVnBJeDVTcURtempJNkIw?=
 =?utf-8?B?NHRwVS9YaitEWWtHbUlUWVlhWTNYMU9OWm9lZ0N3VThhTDdhbGhmbHA1ZUdN?=
 =?utf-8?B?T3dIamk2N3dvdzF3b1NMT0xZd2U3N08rMjZHUVRPZGEvbGVqYTltc0xkVGp5?=
 =?utf-8?B?RjRMQ0xFTE9sSVJHTmZ5UmFWUnNoUzhaLzArZ3pxMWh2Rm94bXpmWnRPdU9P?=
 =?utf-8?B?UDBHY1JuU1FJN1VuYXV0NnY5ZCt1TWxmbjVWTWt1UThweFdVOUhJeHdlT3Ix?=
 =?utf-8?B?NE4rVDlNSEU2MTRKTGE3ZnpIS2Znc0lKUVh6TFpwRTFJc0dYZ3hBci96MFk0?=
 =?utf-8?B?U3lRNmRlTjdjREhDbStuWm4wQzRydjdCdUpXUjA0QUFiMzhOeWRMVWFwc2or?=
 =?utf-8?B?UU8vaEZnbGN6NjlTQzBzTUFVYnYvRnBrNlV4RkVPNllYYzNKN3FwR1d2OHpK?=
 =?utf-8?B?QlVRem8xekQ5OU51aHhmU2lIR1piU1ZoSTI2bzNycXZ6c25KNVZFVWZINFdJ?=
 =?utf-8?B?NFJkZk9KYndUTEJ3d0gvMUUzQ3c0L2s2eEF1NGprc2swaVZsd2hNL3hicHhp?=
 =?utf-8?B?SFZrTUN2NXRLelVsYXcrWkRiT2o0alhsY0RvK2FDQkE3UXlLVUdBTXpvSXlu?=
 =?utf-8?B?RHB4bnBlMmc0SlFGb3ltcjVDQmhFdmNIK1BQc2pla2NQQloxMHNLeEFMeFFT?=
 =?utf-8?B?TVVpTjNmY1hjSFNlS1BLK21HdFl1TnE5YjExQUpkNWwyeHRtYWJML3pYazBB?=
 =?utf-8?B?MkR4a1F2Q3YwTzRONllOS1d2RkpYMzNnUjNSTXZQVWdpRmlCNWk5TXpVYU1x?=
 =?utf-8?B?UDg4MXpleDYzYXo0L0FyTmtvb1hvTDYxNU4rZWV0RW85UWpPeTJqcGV3ZnZh?=
 =?utf-8?B?UVE4bkhVRGhMcEM2SUlNa1N6UVZUL1J6YnB6N3NtbkY1NkphTkpxeXRZQ2dS?=
 =?utf-8?B?eXVRamMzMzJFMlpTRnhMSThLMmJqR0RRZWVBcGs1WWMxSEVQQnh5alBiOE5o?=
 =?utf-8?B?S3c1QmlBVGM4RE1qVWJsc0MzRUgwVmpDTkZWci9iSU53RUVoWnlkdlVQQmtk?=
 =?utf-8?B?OUFRcmtkTTUvNDd6MXJESUJ3aUFWT3orUzNxTWI2WWlDTmVDdFlQY1BqR2tr?=
 =?utf-8?B?OEhZbUVpRStxTmZEM0ZkejU5SVJhQzRsajllbWx3ZnNwRzhnQ1VFallEcE83?=
 =?utf-8?B?MkxFeVRtUGx6eGlCMFo3cmwwOXhKK281UG0zanhnS3ViRlVkeHRZS2tXdFY5?=
 =?utf-8?Q?YUkBfAuxMXw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MW1qNDZrSWlXOFp6VlNLcUMyZmZCekJ1NzRsRmN0cTFKRGdyUTNidXFPYVR6?=
 =?utf-8?B?TWkzbVpoOThhOUp1MDhKYWE0T09MQlNOQk1ZRzZKUStqcURLcmtVTGFJUWN2?=
 =?utf-8?B?S1g0bjlzVE80RlE4N0ZuZldhZGR4dm1TY3A4NXFrN0hlY0MyWDJ5bXpXS0ky?=
 =?utf-8?B?OEZMNUt6TTBwTnZqT0IwMzcrSENCcVpNYmlwY3ZHNm1IRy9xTGVVcTlqZVEy?=
 =?utf-8?B?YTBnTjc2YlFRNmdMMmwwbW1GVmozVnQxem13SVh1aHhVWTdTM2ZYbUNiUUYr?=
 =?utf-8?B?MlJ0cStEN2hYNWdPeU9qZW1yQ0hDQUM2VHAwN1R3emVWZUdGRGJycFAwa1h4?=
 =?utf-8?B?dnZGV05ITzRITllYR2UxME9ISUJUMzM3QnFRZlBsbjJyTjFWMmZkdGFVN2hW?=
 =?utf-8?B?WVoyd3RUbXp5aDFwZFNrOFk5MlQrK29WTHVIWWtBaGRmM3gxbk94MGVnc0Vs?=
 =?utf-8?B?WHlJdVY4YVMyQVU0MG9tN0ROcENKcE1oblgwZlBPWlYvdVl0Z0RwM3UwWXhQ?=
 =?utf-8?B?UFMxNlRUY3JRZG5nbzNqUmRZTVpDV3NVRHB2RDBuM2liRXJGOTFFMzA5MnlG?=
 =?utf-8?B?a1lseEZBSEk5M1cwWVQzd0ZMOENoQ2Izc1A4b0N4dmNsZVkwTmliM3BQK3BY?=
 =?utf-8?B?UFgzejVBc0wzT1lHUXRQd3dFbmhkdmpZWnFqeVFkMlJzVXdJTU5xRm9jR1Fa?=
 =?utf-8?B?VEhJRUdWS2NxYUFsQk5reTZEZ0IxZzY1OUtoTStxejhwTnNQVnhuVzJLa0gw?=
 =?utf-8?B?Q3d3d0VDN3NWSHp3dVNBTis2MTdUSW1OekZUWFJvVDYraHpqNFlrWE5xNlhu?=
 =?utf-8?B?eSs0TDF2bUpLdWhSMlJwY2V5cGFVbnVGRWJMTzRPakVlL21HYzA3UzljSTBB?=
 =?utf-8?B?WGlMU0UyMVhPdmlVNFBYS28yNWlEZFVnK3BCTEpBUC93dmhDL3N3ZlZPUEVC?=
 =?utf-8?B?eW1Wc3NTRVp4NXhCczhnOVN6UzJFbEZwbUdpVWxvd2gyYnEydzEwWVcvVkc5?=
 =?utf-8?B?TzlGMlJQN2tCRFZPQWRzU2V4cWxobmR6VFQ0WjBVeWFPWks5Ky9GVEtDRE56?=
 =?utf-8?B?WnZ6TkcrUDFmZEZtcWRHYjcvdk1WL0xJcFVDYm12b0IwQWlPTXhsZDF5ak5j?=
 =?utf-8?B?QUM3WjZ4NklmcStPQkNrMU5vemFnZlBIUmhwR3djeTMzdldhdm10R1ZONlNJ?=
 =?utf-8?B?WmZ3RnR0SU1NVnVjczl5YVowMGFrQmcxNkpBeUxTaS9GMHRsTUZuejViUzFm?=
 =?utf-8?B?MzkvcnFCTXM0c1BWQWZSeEpvNVFlaVYveGdvT2NVaVl2L1VzUkMvUE5oMFpv?=
 =?utf-8?B?MWJkTGgwUUs4a2tvRGJjcGs0aGJzMUZXL3dYZmh4bUZmeEZrK1g4NFBFOWVI?=
 =?utf-8?B?UkhhT1VES3hUOVo2Vkh3aGNtUWZ0Y3pXcUtCUGFVczJMS1BIR05tTUFKV01F?=
 =?utf-8?B?VDVTOTZKc3FVVklMdGNjMDU1dHdiNGdEM3htZkIvOVd0TnRSanBTenpKTm5H?=
 =?utf-8?B?M2dkeGtKZHhrdHRlZi9vVCtFN3VOWE9MbGpua2ZOcEZES0t2S3FGSkFjbGtt?=
 =?utf-8?B?d2Yya25KSXhEWmRIb0JQRzNwNEZvVUYya0k4R1doRWZXOTRIeGl6ay9zWFNU?=
 =?utf-8?B?bnFLWE94ekVUbnR6eDBBd2lMZFFXZDNmTGRzMHZxK2tpaEcybFM5VURxaFhW?=
 =?utf-8?B?Wm1udkJTOWNjMkk3TGJWZFQzZUZpc1BvWGJtTm9jRU1xV2hRamMwUW14aTFO?=
 =?utf-8?B?UXgxaEN4V0tvMU1JL0RaWWdqclFDTkg5UWlqRHErMlpoRWVxdTk5V1VuaXRY?=
 =?utf-8?B?L3grb1owV2JWNUhwT1RHallkeWRYbGNNNWk4WUlId3lDclpObmJqWGx5S1I2?=
 =?utf-8?B?ZjRIaWRkTmhnR09SRXI1em1aTWFJMzlHdnBjTnRub2h2RUEvY0JGTUFFR1FC?=
 =?utf-8?B?ZHZxZTFnRHV5UUZKOEVTdndWZW9zcWt0enVvMFRvWXI5ODh0amJ2eXRha3BB?=
 =?utf-8?B?alpUQUZLV2tBMmE3b2xEL3FQR0hGM2ZITWRwREZiT1pUNUtGR3F6dkpPSlUv?=
 =?utf-8?B?M2lCSzU0R1JMQmtJVUtLT2UzQlgvOVk4aGFzZEsrb0k3TGxFcHEvNklnVHRl?=
 =?utf-8?B?TFhOZjJvOENXc3M5Y3NPbzB0WjNEdmR1WEt3V2VkWEVFZlQ1Qkcrb2psTEEz?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6K29YESNFeDMgItpOE2KenLehccnqBHjQ24NNfSfp4i6f0Q0797Ob4KY4eOSWvKbU0zFBdva+PvAyh4EBbXnDtiKfyvcM4rO1YyAQQInKmpq69sVNjerGbP+dc7+qK5ijEtXTjY5cDv5d5MK2QFR34h0WBbmhauLjAHqlcQkbesz+eRU4wpFhsibhhpGU+hepTUFb5BVixXTlmvghNCGiIsCGAhDDPl/5EZhqQrk/yYHNl+vIFS8dOrpHC/8TNtHB513Hb6bAEmsDOekQ685X8L328a8dJnYl61mkED1hBPhaHXLWWIIsFCvmREHeu4sHEC4oeYgQpllV9WBtDkaXR0EKCVOZp10zs3WLnvl6E+4TOzv4TTDUK86JZQTytiOg53TgddE2FFLzpc1yzRU3rNcZjLH06AF/tCj0S7AHpp6A3kPpyqoHnzh4MOgRfrpdkEa/f9jnHsnvcQ4UWAn96BjCw34wCYXhTvuhj+H1sBoFH7Pl+F/nAJy1COdWqw107bFSOGjspsbvk8pQ+DdTs7LSd8hE2TsWSLkkiAKf7zjprq7SfGHDmjKNmbDThyRIK1M8BNUB3rKoUuui+LfU/LSV/gF9NHpUthoR87Hc0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81fd2b1-513f-47bf-07b4-08ddd5db502a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:53:27.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmVQO1Y8Dv4aKS7EHVhE3qBkUem7fAO8TgUY1leaHq3eTfsyyswWo1kTRxzZhTtvvRJaRlVqb09erUweVR8DvotuIjThwWm/digEow9+o74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7465
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070146
X-Proofpoint-ORIG-GUID: A6VxWcWVlhh8C-NRmDioS_0xbXUVCebm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE0NiBTYWx0ZWRfX43wEeveRoWnD
 t0LE8xiVGfmHDhESyxUOKxWyuxOVSN4J2VO72PGqM6GJqlWhs3zcOSJD6iSSXSi5IWKI5Utz3lp
 2z1h8autuHO1UwYNOO3JFZuJ1h6bVQd57Ka2TpLbRYchI/cvZm8X60DADLlKy2qk4ebNhvyBC9j
 778sbn17EiQ2WtqaY6ZMrZsV5l2F/ZptfDC+X5Jcj1iV9rC4+VWeZIqlSudqWkpc9o1/P6djgjt
 COVFe/Awpg1oMtoyaSDd4lF70brEkq3koaScgEXcIrGBPtz70WTfbGAd5UrgLGqgD4tvI3plf/y
 xgN3bREfTECYvQY79UAVWk7UnELLvG3wA01GdxKxfsa5MR3vkS4P47tygSMlEE1gYtPEEPkDswj
 WURxsNVOarfNxLzqfpu+poTiiuET+JqPFjQ1g0llNmMe9yIBwYJ67WOJW9hcVAFHKvC2Tdcw
X-Authority-Analysis: v=2.4 cv=dobbC0g4 c=1 sm=1 tr=0 ts=6894e81d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=HVRxv4gHS3gMWBJZr5AA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12069
X-Proofpoint-GUID: A6VxWcWVlhh8C-NRmDioS_0xbXUVCebm
X-Rspamd-Queue-Id: 4719F120004
X-Stat-Signature: ghhmdxgzpruahmjwspyoq1ux7ym4auwu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754589238-544479
X-HE-Meta: U2FsdGVkX19whv4X6yW31S6E8Poms4LRTCbjmxGg0y2uWeVOUFvnkcia1dBiRLIZmIa4c/IIpRwh31vf2ab2IxzcQfsN/QS0dkai1yNZYhIOqKvCEtKqub0rkWVNj5RvnZlV3JGy1m/LL1Bldp+bftIaiPxxjM6sjBOTzX+tiXPjV0YUp0VF4+Do8DAWZ3ebec8gvWoACa72VZfSv+HBc7udvNPbigeC0fo8EkKlO+CokWs0Eq195TwzTuETfsFVZ/nQce4sKuMQk8IDCeuhhB4gFQLubrjTr36KMiJEZbjtqq81qSoDKJd25LnSzjcY+fwdomc7zySme5ofVbWhR+5X4wJ3v1VX0LHQr7QgqC+33IfTMbSc14swFkDA6YVBcGbEiiAf8DCs9ch4HjX0y10wna5+o/e4v8KqaxvAAyfvjbm5t7x3NLO2gJWrYAtDHfRWX3Hfk2gjlhlhJuxb8o4qaecBqcSShWrueFsPy07CVnfMtWoAefwSiKomYgeMK11tp4uUUUcFW+kTLz9yAkT0rh3ATBM86QvDcQ6PHofa373SpJYZtzoicms9n1q9SgLAKeJQLeSQTpPCMu+angMIxdNOfoTUbt+YkC+Mcp80E1yu+M/waYUMy/SA8YHpAaZx3/RutCK5jOGonHieAf5og752prAhrcw01RHI7J7GpX89JdUlsxMmtMtUKMKiKR1Wmpoat/IvIrg5Pbw1K4R1KFnO51Wm1Z6p+8tOCWIuCwn1MNjCV8M5iF7zENzuufIiWItbRNBWetlwBZtGD7gfmRldbM8NoYRy1025PhCo6ETsDjyQTY2nyIgaVl9fyjuLTBhECTTknxvrf4gkAJtw7RWIAstJkYhBLcAJdMQjIhWH45PUAYSTnnZ0o7XNlXubRZVFwu27Bk2UTTr89ASqerobpOjrclyf9KDletkg6kuUqsYRQTHK14oVmkIC3cRCGu5zqDIJ3IVfsQR
 NepFtG+Z
 Dm/rOCXzwBvBrsphgHoMzLdS9j8CdH7TGsL8EvrMfGArDYdf28qlnVzIAlx1q3qtM651JPFbNcyf67ODk4E5r/6HH0pWM8aND6wxmtOsgi2JP7OyruyXI25L7BwS5V/NQJgsc1EsbfsNd78sJ48qjvTsX+v8mDUdS2dTRKWXVY+hfdipe4wcf5Fw4xI8BOtuykZEOCJrd5V1OJXuA+v1ks/JzUBqbmTYgCe5b5L2QjCcc+Vw4pr96int1gZr14O45c/If2eAvJ0ViSWlSZlry9Ta3MAalMcmbdamQpy7isAbV89B2I+z7JWzblVzAN1EUfArVUs/prpM7kiWiTQn2TQQrMhxigftn1yUX08W2g5jN4o1lXMTZ6bRbLuflMKiTMXtIMtpINrDUZeHf84M6Ki8Rnmd4L8Z6ARRw3mn2az673DreLrUoSKDX1ZHysbIWYbTDNr5hJa67rZ9agfUHPJX/9E2sS8erXXzd3AnC9lLFTvXQtOQuHGLdC9x8NDGTW7aq5iM531VaSlnu/PbvIgAH8uZJ8R1MKROK7XrnbOA/9pMuX8iFRtVgUmR6e9d8l9M0htNuCzkH+heYayqU3XFYRpmZkijUyzDPpmlgtFn4PBkGLT2f1ZiA7WxXK0Y5bsLIfuNg6m96ff1q2knO8Cq4lmkxp6mpR8I9j7t+B/uUjbnbKKv++LlEcFehzFPywTHMcLXlhGynK4Z0qoMwX1TegC67SUneu+AoIbOpNNpQcxyoYD+YwUO1nd6hXHHLSRFOrMI8Mr2L21d/z1zYDz5fjItybgwnde6sfoflSiuL1vyWlvPdfjKUDoH/mzj6I+kHDwtexacZ9Ea9ghcifoiPoLflH+Z3o0wsGeJvG+HFdDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 11:20:13PM +0530, Dev Jain wrote:
>
> On 07/08/25 11:16 pm, Jann Horn wrote:
> > On Thu, Aug 7, 2025 at 7:41 PM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
> > > > On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > > On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
> > > > > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > > > > ---------------- ---------------------------
> > > > > >           %stddev     %change         %stddev
> > > > > >               \          |                \
> > > > > >       13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
> > > > > >      367205            +2.3%     375703        vmstat.system.in
> > > > > >       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
> > > > > >       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
> > > > > >      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
> > > > > >       11468            +1.2%      11603        stress-ng.time.system_time
> > > > > >      296.25            +4.5%     309.70        stress-ng.time.user_time
> > > > > >        0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > >        9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > >        0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > >        9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > > > > >        5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
> > > > > >      388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
> > > > > >        1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
> > > > > >      135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
> > > > > >        1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
> > > > > Yeah this also looks pretty consistent too...
> > > > FWIW, HITM hat different meanings depending on exactly which
> > > > microarchitecture that test happened on; the message says it is from
> > > > Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
> > > > meaningful than if it came from a pre-IceLake system (see
> > > > https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
> > > >
> > > > To me those numbers mainly look like you're accessing a lot more
> > > > cache-cold data. (On pre-IceLake they would indicate cacheline
> > > > bouncing, but I guess here they probably don't.) And that makes sense,
> > > > since before the patch, this path was just moving PTEs around without
> > > > looking at the associated pages/folios; basically more or less like a
> > > > memcpy() on x86-64. But after the patch, for every 8 bytes that you
> > > > copy, you have to load a cacheline from the vmemmap to get the page.
> > > Yup this is representative of what my investigation is showing.
> > >
> > > I've narrowed it down but want to wait to report until I'm sure...
> > >
> > > But yeah we're doing a _lot_ more work.
> > >
> > > I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
> > > especially sensitive to this (I found issues with this with my abortive mremap
> > > anon merging stuff too, but really expected it there...)
> > Another approach would be to always read and write PTEs in
> > contpte-sized chunks here, without caring whether they're actually
> > contiguous or whatever, or something along those lines.
>
> The initial approach was to wrap all of this around pte_batch_hint(),
> effectively making the optimization only on arm64. I guess that sounds
> reasonable now.
>

I wish people would just wait for me to finish checking this on my box...

Anyway, as with Jann's point, I have empirical evidence to support that yes
it's the folio lookup that's the issue.

I also was thinking exactly to try this hint thing and to see.

Let me try...

