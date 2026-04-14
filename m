Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE176F9D0C4
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636536B0092; Tue, 14 Apr 2026 07:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3EC6B0093; Tue, 14 Apr 2026 07:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485816B0095; Tue, 14 Apr 2026 07:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35ED16B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:54:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3308C1E22
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:54:09 +0000 (UTC)
X-FDA: 84657003018.14.1A729F4
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECCA3140002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:54:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vux2Bi7t;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776167647; a=rsa-sha256;
	cv=pass;
	b=8Rlvj9XRfLOft3LyYKqqP5AWabkrYg3CGp7f579ZIJyVJKj8v6vkFFEl83q1Y757ZxOsoQ
	SQ3eBogGVHKvTlu2gwQTB/htN8A8VBLKsjZ+U8RRGXxB7N6SJd5Guevc7u3a4KvxKoy/xp
	EiuEhi1ZX+nFnfESLwC8iU2hXpglXgo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776167647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rznk6WAlR5MKHfMFl6MbhjoBG5/g8AAcLT+wr4YdvIQ=;
	b=prJJzwL38ovTiYIC+bRktl9FFrj5QxgKAhvXlep6HYiJ6zDxepApRIL/MLOvEvCvHQus+R
	bvLfhULSs5LAWrkcZIAaTr7WRbw3TvvJnzLEfq9IPS5fILAsGcaUJDg9Ukrzfni823Qlpn
	vb04z/Xs/QYIG65vz6BHJCP2o4/72m4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vux2Bi7t;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJ/LCOWb/ZGLLSc+RdFaP8lA6pkxj3P5xOp005CAwF3ZMGcyg2TsrkZkwGkuMXaFEXv9RYGMjofnQyyUL9YotjkldOZLfRas+C9fpOn61NOQ+2OTiy+MEMgUlEjTOvTdSTeJzQ5V+10AVR4K6GRDix47I3wZYXeGGdTyAm/D7sd9OS4M8zY1vLyHa2TqNuFyqJzz93eFR4sk+iwCQ3o6dfPAIezgMq9U7/ekkZl6czEqkYGUTWxNigvUJo/g2/Ufa3e7k0ZLR20c5aPTDmAXFj+mSQZBdg4rqLvYHxrtbm/tjYCwFTqOrMZEtuyYKZOJ4XCDaPKe5H/D+6fLGNXSAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rznk6WAlR5MKHfMFl6MbhjoBG5/g8AAcLT+wr4YdvIQ=;
 b=aFQQlqKOuRX+ksXHjvtTYMoKLKyX4Ap4n9l1omDemq+RygbnBPjmaF+BcO21U8MYr4le4GI4hp9tUQPtoFuYNlWan4nlIaSr2EloAfQ/3+ZNgcHuW9eFErAaJBmSNAZF1YCba9w8rHqIMrhBKE2D+nfuganMtElxf69jN2s5mLMzBfrH0qwTtFR7Sz9NOv/+9lMOgL27RGtcGsC2i0A+eShFryRi+nK66DuqFMaU0I75fWEXO01vSEd/xyYkXzs5s7scT0c1lqOJwj5oynDffzPdtPG3sCci2M/H0XrWOzFMR6xxdv7RHlZw+G61ojmUMAq8LRucMvNqCXArqGZ5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rznk6WAlR5MKHfMFl6MbhjoBG5/g8AAcLT+wr4YdvIQ=;
 b=Vux2Bi7tqcJjsoCjJHkUFAERRa/zera9TqLrmW38b6z75UIy8dq2CjqbI4oI2NPxMnPiX/sU+wjh20LrfztuZ/MYMvzsU9xOkzvLu/K2oL6yyq36jIESiK5rj7J7FTn4dmAP+VI/XB/jOx1AaTZ4kxFC66R5Xp4lX1FYkmEfzgrNp1FSWscMmkLAVKKo55RQIShZVPexw3z5jr/Lzn+9FC+aO+4CDvHFr9w9+8NwcL5EUvxqPvru/HVuFt9fDsJrTf0YlMxGJyNqBdCWbAknBkXGPh0tUYLjqEXsn7tBMQ70rZmeSAVD6FcJ5/BInkQKJQ5476EvqHDiSq5V5ygQVw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB7454.namprd12.prod.outlook.com (2603:10b6:510:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 11:54:03 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 11:54:02 +0000
Message-ID: <fbe13ade-d503-454e-973c-68785d8f7baa@nvidia.com>
Date: Tue, 14 Apr 2026 21:53:56 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix double unlock
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260413211559.20969-1-nueralspacetech@gmail.com>
 <2c0c00aa-7fb2-4d7b-90b3-0309c13468ce@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <2c0c00aa-7fb2-4d7b-90b3-0309c13468ce@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a03:505::29) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 061048a4-ede2-4957-9f5f-08de9a1c85bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3VQCNAAnaS/dl+z2bbzZTFCHVOgu6YRbdesJc3Mavim7wrGLpUtcsKEYk+CBDCUh8kF2BQCdYzF6mzXNY3MQFetbroe0Hs94T3+EXdExW7h/J3fjkx19acMMh+BxIo2RYes62IRwup8/33J7kY4EoLMZc5XlP6YJwsYAmsURicrCmvA0ADtCB06JL74uXjFRgW9YLsqELik4v8EGqQzUhhyh1C2SCbhlwNYpbaGWsk8bLXis2ue/hNXqyfh6teNIT1dX7ufjpn6Fe7ORH//SvOxFtezzlimRLWPu9ghTgjZW/JCrQshAlO+W1g+sRZSeyog/9S5TfD1BLSZF69x6LHNtCwm6j2UDAOYs+dpHxmnbF0w96U1C4M3409u27otA3VfLCkswapPl39gY2RGOiSfbk4xchbn+HrGnC2k480fiZiZnzQinwNLvhFy+Ew84pD0sXs7egfnzqC0e89yJ1UlOSzCi4BfAhI/5sjZ2gcugbM7baTLQMJTTTngaOzuuj+UkD+zKTjOcbsca8ey+q7ZfLlL5MD6nDXrOU39GYqASBc367LNE7LOJ7cyfCjqOkC4/2thgacJNOJdXtPSwI8xrk8eYna2MQIJeaWgx2nX7Yao7NdKUIp86BjlqGRzmchubo2MlOCH4MGFykdD3ksJ44CHrJbHQboKLCY/nhjT5HxPdYoaZDzlxMI/cLClJmQ0PdQKVoK5cmAclYmFEgGvAcPba4xhgpHc5rQy7hrA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXZCL2FjOXJPQnlLTlM3SERMTHBNaW5RUkZobzJYZXBFS1I5ZGlZalBhNUJM?=
 =?utf-8?B?Kzl6K2F0MG9UblFPdVYvYkRlWFZKbDF3Zlh2SVJueEg0RnRNclR4WUh5aXNT?=
 =?utf-8?B?RnFpSCsyYTBkRWtwSGZQbEEyMWN0YWRvMlhUd2pnZEdqV1kyOVdGQzVyOU42?=
 =?utf-8?B?ZlQwV3lWQkliU09UVkxVS2JGYjN5Vk4xKzVnMXIwbTJUbTNPK1k1aGdscmpC?=
 =?utf-8?B?WTJ1NUtJQzZabE9ZaDhHYzFjQms0R2lOV3VDNGVUSFdQaDdSeUJTL01CZFFa?=
 =?utf-8?B?WFBOR3hENUFjcjN0aUN3RytScy95QytSN04rd0pKRGFzRjhZcjQ1Sm95bFVy?=
 =?utf-8?B?eVZBeDJCQVdnN3lseUZXZ1k4NDZhR1JoYUQzWGtoaXR2bUQ3L2lFb2Q0blU0?=
 =?utf-8?B?NlFUZXJUeXlFRnhhWHAzVURwT3hKWTJpYWgyYkZiSU1NTEpzN0dycnRtQnM0?=
 =?utf-8?B?REtaazlwanJNTFZFVzdqQkxvS1J3dDVHVVFtZFhuUXVJSHZxbzNFaFZONkpU?=
 =?utf-8?B?ZWJUdFYvMjI1emJzN3dBT3M1a043d1hZU3pUWm1WcGNxVXJxaDJTcFo0NXZI?=
 =?utf-8?B?aTVFVnBOa1cvWFJoZ0l4UWNoeWFhU1MxUW1SRzJCRU81Y0pVbzRDRjFVTHFr?=
 =?utf-8?B?QnhIM0lXaXdMS2lzdVE1amN4NktnQTRoUjYycXRISDhhZGc2NytuNTVvbmlV?=
 =?utf-8?B?cmU1ejlZZzlLNWhXd2JGOXE0aHBVMFNhVGxYYWRXeGJyLzFkQWJYZ3ZzTEFa?=
 =?utf-8?B?b1ZHRFFwODlrbHB1emNJSDlTOTJWMHRHa3dLTGVrVzF6M0I4YzRpT29Mdmda?=
 =?utf-8?B?ZnJKN1NGOWFaOWREUHF5LzRDbVovQzloMFllZ2g2ODl5ZW1wSjZlVmxueVdG?=
 =?utf-8?B?MVhrd3ZWbkVoNGg0Q1JWWVl2VHY0QXcwV2hnT0JuSmp6aEcyek5MVE16ZHVx?=
 =?utf-8?B?aC9PZngwaloxUEhjUFpGQkIydTZWcjV1WEoydGFFSzc3TDl5blNaYThKMHRB?=
 =?utf-8?B?czZrNmVYOU1IRExMdHZsSkVjbmZJMWU0U2RHR093ZkhUNGNEQ09rUzlJVk43?=
 =?utf-8?B?UjRjUm9obUhCSXkxUzVsZk9ZcTEwR0JQNTkyczczc3pyVDg2QU5aMGZab3Rn?=
 =?utf-8?B?V0xmajA0UTVmeit5UEVMQ0tLaXZ0UWR1OHZPcDVrb3hkTWVtK1ZsakNFNXpC?=
 =?utf-8?B?VUNOWE1vaThMV0UxblVMN0k5RUREdU1kWjNWem9leFdQc2ZZT0xQWHRYL3gr?=
 =?utf-8?B?OWhoU0RvWW4rTEM2VDlrT2E5SUN3Qk4xYjNZenhjUnQySGhQNFV4dWxJZ0JD?=
 =?utf-8?B?RkJ6K3MxV29pYW93V0U2QkFvUW5iUFc1Z216TUlKYjhaTHlGMlVibmpNZTJ2?=
 =?utf-8?B?ZlZyTm1xbWV6SzFhTzUwYWlJOGFJNnlicHlKRjFrdXpuMzdXR09HMHFsR0xS?=
 =?utf-8?B?ZnNWVWNXbGhPcnY5Rkg2d2FNTlphWjFEajhuS0lDbmpMSmFOdHpUSFdkT0xJ?=
 =?utf-8?B?Z1VvVG84Tm8xUkdxUjVhbG52SmJyR1A2Q1pvUERNYjM2emNVTjJlWENSaTR5?=
 =?utf-8?B?bDlYdFBNcjZHOWRQZFQ5STdpbXBWNmRJdUM5eWtwZ0d6SGVkUElyeXYwOEdl?=
 =?utf-8?B?dThWMnRVN01UNG9LRXZ3QkE0MWNRT1ljVTBzblVIaUNZaW1DaGd4eW9WWmxE?=
 =?utf-8?B?UGZlemlGSWU4RE01ZXpuUU1pWGFHdjlGdDFjN2YwRjlERWVYbE83TTRaYlpw?=
 =?utf-8?B?YmVJQkkvOFc4NlB4U0V2SEE5RE14VUVsK2xsckhSZ3B3b3MwY1d3SFdrMUxi?=
 =?utf-8?B?eHpSRHRkV1B1VUpidWh1dnZscVdiTm1SdzBmZit4b3o3ODZXTHF0dlp4M2Fi?=
 =?utf-8?B?NFNHZkhpU3ppTEp4NDBMLzdPeUUwSUxwSk1hY2QzZGlNVnZLQ3pQUnFmNytv?=
 =?utf-8?B?UWNINHV5eUFQVnA5RXN6UUhvempVc0oxTFBvbUg4QVplall6MVFwUFF5OWtF?=
 =?utf-8?B?TWZzOGZKWGg5VWRTSXhhdCttVFUzaXRHUUVyOWRvcGVFQ2JwbVpybm02M2R3?=
 =?utf-8?B?M0FMVkpUdFpoMVZWOGdyc2dLZlJESmtDbndWQ1Y4cFVmV2VsM1hPOTZwWDVM?=
 =?utf-8?B?alRLektVbTBYQkxOUCtqSkMrN0JhNGE3NlRVVk9rWHhYeXFzcEJKSllPUlRC?=
 =?utf-8?B?UW1WQWJyRWMyc2V6RjViREFkZHNkZllKcjFBYzFkMUlRY25VNVRZZmY0TlNY?=
 =?utf-8?B?V1Z0K2lBaGdYRHRsSWJTQ3hjb1lhdi9neWVZNmFlVzlBd2VjNXFJejhTaHNi?=
 =?utf-8?B?VzVhTGV3ZEhjOWs4d2lXZDN1b1ZDL1BRTFVVWWNsZkwyNnkzb1MzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061048a4-ede2-4957-9f5f-08de9a1c85bb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 11:54:02.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: la+F/HwTU39X5LXzHYR9/iLGlZzCNJ1TU+gDckSRWDIZ+chYtjv49JU8Wdm/O58KKQmfciAlFJof0yC+DY4YcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7454
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECCA3140002
X-Stat-Signature: 68bnkew943nx41uz71awaiuto3n4xek4
X-HE-Tag: 1776167646-679179
X-HE-Meta: U2FsdGVkX1/n2OPtcMLvnycfx2ky13Etj6tVWmb1SyREgIJu1dlMpeTsPydE5WIozAGlG75b1ZkqEKva/ACMNFcSRgNQ2cqLo2KLi9kdGDkCve8axW9k3dHqmPZM32kI+E1i3XbzVd6eWXMzeAt+BgaoPDRcRmK5lHsShGqSXY+7sbqKM1AtSsYK1XTltrqXE3DACSi82dMxbpgYBAQp6nfPs6nHBsEQBCMuATYyoU0F6nYJ2nIcsYAPdg/iQnqv0sOvEDHmgITJfPydtjnhH+BDFL8xxhs21b+HtTHA9YJUH3nyZ3eBqZXeqGwz7HgHwiomhrtBCe4rPqS9q991kAkcSYz4f+6Nv/G2pKP18L2SBpO8MHDENQchqkzlKkFnip1PhHsl/yXJAK0viyuTLoxTM9Pxd95fGj5NNdDA4mjt6uDKuUiReHiFv7RJAjfdgSySCWyg2Cq0fK5EYQrtypwwRZGIo+UX7EEeyqds9iiRh4rtdZfxXW+fXVQNs+oV3ot6QoeG3dDLmCWAnafY89rYd8n4n7Dm/gkuEzyKmTayvswHJZrkoG/ScBQadfucJd1OmwNATAt71zOjH+XbteCUzmn4BSaIDnaQld/+7+/SYAjqktsdtyvolEh3IZPx53Flv6aQGmQt1211wbmemcz8XNoBB9/uTrmwlDmc94Je3k6/OUPlvK3f4JJzgBD+h3X8L9f24gah+XTqD9vgHap2JCnuvPIOXwXS6iJrXqxMAeSJjyxEaKQCj4hr8sQ83WjEVze3xd18mjV8u6OXbsylTo69eDQ0SXD22lCDAq5QsvwH8tqJKBtfmExJqCnJuMit2FNRJCHCnC2OooUXzydjI4cTIyGv7NjEqzd+/YjV0YAjaxPnb+9utA4L/PCZcoLAFufi0o/Z6HZokhY2UqXh5h4zc0mNmL8+8/X9vr4jxDMGk+yoMesKllQIe2VJxl6KHl2J5HYn9bxFOS6
 TFL3mI3h
 KeCVO5i2WwF0yUpFXp4eeXbChkGXjVBtNc3ewt197KGpi55uY/ubWcO7Q7o8UJ/qMF3a9zcWAAWeqZ6UBpasK4m9Xte+wnclENFtw8jHVhDsUuR8anXHaUewrsOXvmwgsBGljm45rlkAM8GfUUu20XFtbDKMk9t9iRpzL6qSiJ2ofKD0STNE2rEI48n4aZoUEDRV8VtpsF1Wc0vhMP6LxSizPX57qlJ0QBa398Qt66aSgsiIKJkht371OHyJ6IeRdrWwHA3KAK0vUhAz247PqURtOkKBq4fsRd+5StxcKIM/hUTe4yGAWuPORhZWlL2Z+BO5w3uzBSxNtpa/tqWzstc0vCs6wBeGIPqxM7RR0QB908cKRT8f1ev4TD2rQsQn09F4ipmVP51Znfh33dABzPtr/Sjf4Xr6HkDs4xCvJJe8kH+rcpK8ZTQzEmZm2feuu/bC3TSlg0tntn5elTdlwdOzGP4aal6ueXd7jzNjoauVlFU2TAbd5oImpY/r60zeP6sLNzfK1QSXHzOe77Hr+CRcwHmrunvhBV8zCQ6em0Q0lZ6i/eB7h7SKEGmjsyHlwQzm50wtaeSck6bTkRGc/goW3Mtg5oqEBqZTj97iTiHnTE961+uDOlj1xj9ZzWJEU1b50
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 20:03, David Hildenbrand (Arm) wrote:
> On 4/13/26 23:15, Sunny Patel wrote:
>> migrate_vma_collect_huge_pmd() calls spin_unlock(ptl) after
>> softleaf_entry_wait_on_locked(), which already releases the ptl.
>>
>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>>
>> Cc: stable@vger.kernel.org
>>
>> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
>> ---
>>  mm/migrate_device.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 8079676c8f1f..7eb2f87ea39d 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>  
>>  		if (softleaf_is_migration(entry)) {
>>  			softleaf_entry_wait_on_locked(entry, ptl);
>> -			spin_unlock(ptl);
>>  			return -EAGAIN;
>>  		}
>>  
> 
> As raised by Matthew, the entire code block is dead code:
> 
> https://lore.kernel.org/linux-mm/20260212014611.416695-1-dave@stgolabs.net/
> 
> And I even Ack'ed it /facepalm
> 
> So we should take that (cleanup) patch instead. Thanks!
> 

+1

Balbir

