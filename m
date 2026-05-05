Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6030ECD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 22:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3F56B0005; Tue,  5 May 2026 18:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354586B0088; Tue,  5 May 2026 18:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C736B008A; Tue,  5 May 2026 18:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09DDA6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:18:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 915151605C4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:18:04 +0000 (UTC)
X-FDA: 84734780088.11.AABA6F0
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010023.outbound.protection.outlook.com [52.101.46.23])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9801E14000A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:18:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sbdvXjkj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.23 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778019481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9qidEbwcbxNUjG8hAqqT74iHNrRyPHrxDICICDW3Q8=;
	b=wvC0eEK8rj+4XgbGPENYpG74Mv8VEGRjszxbxsqeKmhQG1JlAiwWLuk4oWiUdSOGTSPxtm
	7i/9xdWj+4QTKiX0ibJqwkD3U+XzFslscqW0xGcy15p6gSlPP3eqTmCLPwFHxRVj1QBQXb
	0Br36iBefVMVReRldzQtguRQUt4XVlU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778019481; a=rsa-sha256;
	cv=pass;
	b=bpCoO6a6klF39Ue0Cwbhy1meJ7XlgtLyzjC0SMTUH2mw3oyjjbCUb0r82Upl97U9a0W8DQ
	WPtPvtqYj8eAm/tW0U2kUFVw/TVUt4z0RWT/mQB1DqIkuPqDC0TspMjL9AV13Dl0Nd8tr8
	O5EixOMbNOmdINHKdzGDwMS/YjgBUR8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sbdvXjkj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.23 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tXsO1MczazzuuJdOhgEV2JYSYmCZCaeub+XsJJ2DoRNUosBpMOW9+7FR/brG4yR9UcPSA7zYHmmsboPisEOZNyfYsR5VI1FU7afuPfMid5WC2MMEcVFj87598AhCyL3fF31OyI7GbfY22P3LF0khD0fdpXsrllgq2VD3Gq9/8IWqd/2un6OJNkYlAeGgbaPCOGwey0ns71Ygcpjv0udL68LBjAjzjcGcCiNqV2vOGWdPyDbbVJEPjufjtE5uBwbZMwnjZ3mrLWGC+oM8GiIXirYFEhhNZ+dcOYwUsBMX5a++1TIWCW7sqtsgnZpYzojfX/QQd97vboG63a30J1Qdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9qidEbwcbxNUjG8hAqqT74iHNrRyPHrxDICICDW3Q8=;
 b=Z670YcCJH1OXLwydZmM13va/5sU3Mx481wuIpt1cDf5YIokyqF+IywxZUCN6LDinVPZE41gYygYdwAK3vxuECRnQSqaClRMuxFdQpemd93H8NYuWoLh/Kuv6oJQxiRamwFskhhp57q32AhtNZsagKg0H4TZc8h/i2pzvIpNYbfD28HXP4itFgDzrntgIIwfrZ+TYygvxi6SVgfUoQB1kk0JHUracZb9JIv+Off8ERg2h/O4gyW+8N97AjMHF9H67tCzHot3wzmrg8hlajxZiOkTB1Ymrgpt1vkz5Cm82Dq1m8xCJvQ9sJrN8StRcanxl7PFZLRNcg+MkmfhbkHeckw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9qidEbwcbxNUjG8hAqqT74iHNrRyPHrxDICICDW3Q8=;
 b=sbdvXjkjYAhbZagf9CmKaT3DWGRbyHeY8yR64Vc/2wXu5klRSgew7kbgp8AceXSw67OdsmNGkQ1SPmr8Q5Tgno5m6Gkgz9b1ebu6kwh4P8HC7qlqhXSlq1/jR5uZv/wg9U3a3dpEWSMJccNKlJB0pL3TbKflFxbiZaquZjZTSbUGDxdzpC76S9RLoE+bQo1fXiaFxyoZYq9ikTtguZiaI9fSqBSSsIP4psM8o/lECCfrvxuyKF5pVkO/XIFNYcwEVbx1GgLta+RHDPd1zQfbV6I1idDEtouiVPylDLGSKn6L3S5mXaWL4IyBvUCBMQWINEMgbsFiMTKHWPWad7X4jg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB8070.namprd12.prod.outlook.com (2603:10b6:8:dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 22:17:52 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 22:17:52 +0000
Message-ID: <e5246723-b910-418c-bed8-5222d63d90da@nvidia.com>
Date: Wed, 6 May 2026 08:17:42 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: Matthew Wilcox <willy@infradead.org>, Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
 mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
 raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
 sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, akpm@linux-foundation.org,
 david@kernel.org, byungchul@sk.com, kinseyho@google.com,
 joshua.hahnjy@gmail.com, yuanchu@google.com, alok.rathore@samsung.com,
 shivankg@amd.com, donettom@linux.ibm.com
References: <20260504060924.344313-1-bharata@amd.com>
 <afkDNR9yVRjire4T@casper.infradead.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <afkDNR9yVRjire4T@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWP282CA0194.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1d6::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: 432d997d-6abf-44db-5486-08deaaf4262d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	0q0Hv582SED0rjR2Mf8smQJcr0fhk768AaWuclZuYlCeitb4/FEiyPRYdordf98fR0wbm2HkhPYlAmLmlCjKd7wbs4di0hnkixQDyKR6HMkv54rl85nphYkg+cKki6Np6H6ViA0sMcxQlS6F9lYnX2LiE83F3acH6lj7yGu+L741yMaMuTpo8Y3pO9moOuGezVx88rIn3oZxFKOM1oOCQj52yrf93vsmf2nJ8A3adtX5vg93jQ8OAchqpH+XtV3oWcNsHmbgeqlatHFDBhaNAt5IXYknroVELFN8IVStuBx7k8Ud5eAzOdL0jWT3o+XHQIs1GWtvVn/Bx6j/Thpuxemi0Uk7CDajdPZLrf+a3gGW9wlMkrt0HnJjydcQp23WI2q2MQgcgH7q1UjW1Jvt6uuFV+z6KFKJAxrq+rlVp7h76OfC/OZ/OlDX6295swauM/6pKrFNEG4jBdfPYmI08QyEcOXPVMiLn7f7IHDEEGKFTe/3IrriepaJTW24I2khUtCylRCF1Lc+Rk/lTn/6V/TjGmiGp8pos7KCOFbJASQcdDKTLLPPX8g1uQ7RanhGoiqc/8Jl+92tA305eBBaBsdyriDEmAQsk858hKcYE0ffCYvGEibE1r9z2MiLelndWNQwVP5RBnosJzG6jBNHSqyflOo7dpiV06T8zCSrKb14Jy5+hKQ0hsBM/NxTxnBx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YngzZHY2YWxXWktrb1BQNUFCWHBWSGZNK3FUZHkwRmRYeUFIcWtQVkxzbnBl?=
 =?utf-8?B?Y0ZLNndCMVQyQk5aQkpFSVJ3ZDFlVHowcVliM20yMEZzbW5lbjNLVC9KYnFv?=
 =?utf-8?B?SUY3VkRvRzBZdGdoUDB4NXhtWkJ6dEhwR3RMaDQwM0lRNE1xVkp2SGxjWG1G?=
 =?utf-8?B?VG0zSUdMM3NGaEpIL0JrT3FNMi8rQ0J6ZjFER0VFZEVoN29LTW9zdm5hOWI0?=
 =?utf-8?B?MVRsK0tmTjVVKzY4V1ZOYmxocW9WTFhTY3pJVjZpcHdOU1dRVlo0SDB2ZmRV?=
 =?utf-8?B?NWVxbSt4WjhuaElMdlMzbm5mUTBNaXlWTGg0VTNQeUVhZGljY3dLaFdNYWZ2?=
 =?utf-8?B?YUIyaE5CNGZWekdYU0Q4Q1QyaTUvcWFkekRUTWhTcTJ3NXFiYnhqVEhpcThz?=
 =?utf-8?B?N3NHc29PY3J5ZnVQQWg3WU91RTdKMkxaMEVUTDVVQnZBeHJCRmpZUnpuazJv?=
 =?utf-8?B?NHdrRlZSOVRLdml5Q3BmaElMeU90TEJGUkNPWFNkTDNwUFNnNC8rWFdRYlh3?=
 =?utf-8?B?UXVuNU5aSVNid09GeE5uVFNORWdjS1phWWl6ZjI3RkszSzl3QWVENnhCV21t?=
 =?utf-8?B?YkRqNG9XcFVtaUdSVXJKcEhqV3NKd1pQMmloR041M3RKeWhqVzIwa2dPRTRq?=
 =?utf-8?B?c012WFN0cHZ5SWRUbythU044SStlWkFqeXNVVEJOb09VRXFWZndjcW5NNUxz?=
 =?utf-8?B?MTAwZDE5WEtDSUkvQ0xDdFhiV0VQU2JHVUZUVDBoWm5BU0h5dUxmbmlhZDRI?=
 =?utf-8?B?SWFLa2ExczhNRzdialRaYVBHcElLOWdUVlN6dmxjQjVLazQrcUJZeU9zbnFL?=
 =?utf-8?B?d0loL2x3aUxzYmV4TlphL2svdkJQcW9MaVVmY3djanRQcGJEbHF2aTc4R0lP?=
 =?utf-8?B?YmJ0VytrTEJXYUxzQzYzWll1TWRhVEZkS2FFK2xTaEJZQlppWWkxU01aOUhR?=
 =?utf-8?B?c21RWHdWcXE1WTA5Ujd6N1BjaEYwTzB2SUN5bDNPUEZFU0JoR0d4Wk9oMm1V?=
 =?utf-8?B?NUFFRjltMUtuVkZIQjFOM3BDSnk3NGlQeVl5emJjT3NpTlNoVmE0bVhRdmtz?=
 =?utf-8?B?c1RzTFlWbnprSE9USHdzeldCTmpjQWFxK0MwVm9TdGZLYWFXZ1Y2ZEgveXdt?=
 =?utf-8?B?TEdUeElyMjJEeDVnUHVBMmhVeEJBMUQrZzJhRVRLQWI1MzZoWloybWxGcGJU?=
 =?utf-8?B?bW85Z0l6akwyc0dVaExvTHdyT1NQMFNGZkJwSnpCeFY3dEV4bzROZjE2dUJw?=
 =?utf-8?B?b3JYd3E5bXJscVE0L2JSWDVjMWFycWx2N1dvMElqL1pPbWpmdzRQSUR2YVdk?=
 =?utf-8?B?UEdPcW4wY0NxZ1RBbURHZkQ3WFVKR2U3d0NhTy8xa3ZFVVlvcVRiRnlUdmgw?=
 =?utf-8?B?UnBTdmhDNDIzV1hxMkZPUmJZdng1bktsWHp6Tm93Ykx3dkFlNmpSNUwrU3JT?=
 =?utf-8?B?MlBMOFIydVJvenZZTG10aVJRT2RYUCtibFFoRE5DcXBEZXBJZHNmeS9RYjA2?=
 =?utf-8?B?aDBrTjVPdUF1cXBxdTVnQ0dTeTJhMzBaelJHbVVXVk96UUZXbGtRTldmNktP?=
 =?utf-8?B?ZXVrcmlZeitxOVJteXRQY040NVlUd2MrdnNkSko0U0hkSDdFWmQyallyaFFj?=
 =?utf-8?B?L3NObkdUUTgzSzRsZGVGbXBiNmxvdXQ2OTBjUlQydmt2aUtScDgrNHZrTXR4?=
 =?utf-8?B?SVpBb3B0ZGVOaXFwVlpob1pWNzNFaUd4N1h2Vk1VdSt0UWlqdkttRzJGeVRW?=
 =?utf-8?B?cHJOaDZjdXNZMDA5R3NjZE5ySVRlVDNvaGR6dktEbVhUSmJuUWppeDFGdGJN?=
 =?utf-8?B?U1RmNEtiakdjM0V4OUNKcEJGa1k1UXVVSU5ZTG54VVV3dmlaQUhnRForTWJM?=
 =?utf-8?B?eTB6VlJ3MEpoMFBadnpvYTJIcjQyMWppSm5WQjVEWnRwTC9oR0tyT1JVbWsx?=
 =?utf-8?B?MEd5L0Uvc2hRa3Vma2t2UGVqbkVmd0dSK21KcFVHNHZQcU1BM0ZvMHEwWFlr?=
 =?utf-8?B?WmhSQnpIL0lienNNY1IwaDVrQWtyTGR6SktYeUVtV0ZTSm41d241eUZCVXRO?=
 =?utf-8?B?QWhYR0JGUW5WY2RBWW9RMnNyUTRxRW1Fd3pRbzVXQUhOSXFMNDVxeXBMRkR6?=
 =?utf-8?B?RmRreVo2c1VLcUNJU3dia21NcnhWRE1jbnc0d3lPeTdWa0xmYXp3TWF3ZmE4?=
 =?utf-8?B?bHJpd1YzcnUyZ0puTWJGQ0IySkFZQmc1MEFJSlc4aG5ONWRXcUtObEplWnAx?=
 =?utf-8?B?ZEZFMUpZT084eklLck1wU0xJbkQvWFZRZ3pocklENEZaNjlCTjVBaUJzSEFK?=
 =?utf-8?B?WTZpWC81KzJYQ2NkTFFNbmFLYTB2QUF2bVBOODN1NzNNVkhtUEhxSG03RDd0?=
 =?utf-8?Q?RCC0SfnYFoqE28FL2RcEC6/2eLDrWCWlHNF1RoGFNc2PN?=
X-MS-Exchange-AntiSpam-MessageData-1: lgcvKnFtSbcAOQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432d997d-6abf-44db-5486-08deaaf4262d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 22:17:52.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2zTDZhVMfx/S54VR7REC/5BqvrkmHvKRwsW8wj4qTVtQ6GA4KNjnCkMGxMtaSDAqdIND9ozgWDkrgYEukXWKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8070
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9801E14000A
X-Stat-Signature: ua65b67um9o41yuyd7jhbzesqtqsfa9g
X-Rspam-User: 
X-HE-Tag: 1778019481-392089
X-HE-Meta: U2FsdGVkX19dXycBG56vQhDDB50l5/CKXGtBzDFRmaXsUsZosP+uyu1VxpCOZ+PDN9JsTDmWzLh3S81XxikqFMFvqQ6btDbzMtcqWYvfGrYbryJAtSrMtoQ47Q60R+w4iHAEpOw3UnCkLwL8g+ceb5+yiFCj9X/mlOPKGmpxH8COq9gzI5jx7sZ2e9CNx6Er1wJmbuh3P5Gr+ijaEF5NxTYLx76cFrHbE58jMzKom6ne1CcYTq5hFR7RrZrhDgHdoXeXVgdKsoLSxBbdjEuqO/NxcUAi7TicIPLAMBGgzS09azo0p7mMCTDel8zssuiFycTTz877o/ooUqZLkF+ZU9Ldb2SuL0aMisdlWELTJzku6fAsqX+oC4OUsUMEi/C3QVRE2mmRcfRcR5f2wXy+NHkJisxN6XiLz1HojF89NaTfM70tbaOImpFz+T60tLzYLP3+1LULDx6Qjs+eLEeFBswHPVWX3B3baS27KmQ4xoHO/8C4RJR2wH8kHRYis4+/xfC+WoOJSrVxvvvN7y4Cyptq0Cflj3cFA0EulNnb8fSpzjXLU+YIfnN4IVj7X7NoehALTw/gBbzt5m1CSdXjkRp0mTwyydjvFqL6RCbuKVaKNE9Kxs6fVN+HgZvQYeuEhlk/ta73E4h3WWZSY2+cwipbPUtWSdOybmIXj0S8lmfnoK1Oxrp0mCgt/Jc6mEt3AtgStJiG2gsWr00QirHHs6ah7Huae3dIStYwxrYXbec7KcviT/4p2iXF9zK53OnJKJELCQQqePx+kHhDN6vNV793UyqYpM7ruQdMUkoReedHhhVpX+i8p9Udcd8MyZLx3qvSUHBVjUAn4+sOIBBeW8mVWU1EJu5fo2k0YbBdW6EIcWWV1zVNzj48b4mRutCngL4BA/xMVYNYBQOMIQqkiuVifw0nKRB9P2vyioe2SJ3LFA/QXbOeQekJOQaxsQzu4/sDpl5bTujhi9RIlkU
 YJFkNarw
 3RtF0MukxioCPbVGWS0SN4ygzIFVkP40BL0BnJBnTXISVb7mz7PvXVWYEZfByv6AnEfflgS+oPEPuHgt4ggEPSXLG8c8kJRbO7ZunRbIPWtlKKnCL+tNil3j3+/7kd8JY0OMn40ah8PMoMq8/6uNpxBVy+Kasue6miEP+bE/hq/6gaCu0m0CU5p68SOvF8JkCeMPsCps1Jymf7pgE8qOJnLbV1WopTzVLhYzmI7G1AyBV5LDib2UEDB9yvZUnICnPOgUdyN0qv6kJo4UcN3oIq0IPONplF3PXxmQ/OqeYCxXi0QYdgwkpldPK9kXThqf3zTpg0wfhe+bZv1Y3W5UtbVT+g5yq4+D1Qxvd3R5PB6mO6zMkcpZxK420BhnuYQPdAN278yPXvoAPghz9nVfhq2VFN/CJt5WWslIzjgkfPOT6EwiM60aXPUAiqod/V34XjDSSCbTcGoBvPG2GJNsw+H00wQOK0ko9tPZB3vR9n+X36QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/26 06:36, Matthew Wilcox wrote:
> On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
>> This is v7 of pghot, a hot-page tracking and promotion subsystem. The
> 
> I continue to think we should not do this.
> 

I am unclear about the benefits of the patchset, I have not tested
it or reviewed the latest revision. My big concern was that top-tier
might not always be suitable.

I see that there are some numbers posted, but I find this weird
"After the graph creation, the processes are stopped and data is migrated
to CXL node 2 before continuing so that BFS phase starts accessing lower
tier memory." Why not allocate everything on CXL node 2?

Balbir



