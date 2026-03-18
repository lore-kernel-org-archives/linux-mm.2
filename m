Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F647103E183
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3AC6B0255; Wed, 18 Mar 2026 10:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853DD6B0256; Wed, 18 Mar 2026 10:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742C36B0257; Wed, 18 Mar 2026 10:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60DA36B0255
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:29:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 009B6C1F32
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:29:35 +0000 (UTC)
X-FDA: 84559417152.11.5C1560A
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id E79A320005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:29:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BSh7bxIM;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pQ8WV0OTiy/Tj6Y9TgrJEoPswM7uGxkcxVvmTW9DUk=;
	b=Cc9TiqQYUb31yE5o+QT6XHiI6uTb8Bs+BP17gfcrNXwRj2wgCTwN3AdMcCXhNhQQNtx5tt
	xvBIcnr8Bsl/yOrTEcuSz7EKHD4chHIT0gpsajY9nh7yoN63Wme4+8r6tRmsAYVu47sub/
	269Cnnw5bvKuHdxro6Px4eLoS6cdsCE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BSh7bxIM;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773844173; a=rsa-sha256;
	cv=pass;
	b=lD59lxDEM4UZ9uEE1mbi3FeiW0vlzyvIfeTZjCBv7yuuaIdGtl7DeV39UA+lGtWGi2x4oP
	CoRNv+u22AddEcyE3d8tKFTOMRP/mhSmkoEKl0tVP6qero03jwWVbGll8WszdBYiA2RG1i
	6wdR/AB+HGdV1ZqfUqiVsDpJo34YZP4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bc1TgSZCQz2Jh9+XVoWxOOa/dQRaOdid+02VQffVD8449bu10XtSeVspw2ct9Rf7ezCf0sSpJ6H2froF2O+3Zwg0yW/ZWYDvb7UxiB1YLKR4fYsWQCahp4D9Cxs1J/yT3BIU0rtnhnhXaa7hSfzqQkQvSyarFwwB/XF1sVrPhOxjn1RvHsXOSmNFESga1jD+ycgGj2YolLD/lu1SNTQjPKt1IzZOqJUd2aDqWyc4jb4TearS2pubFZszOdSrkhfUD9o/cmM9fnHS2wrvSavaCjIa3lx/Asw1U/hK/V8fR/I0MNPzizyD8zmJ1+y9gLPkJyfWGUmn7mmJrb12IoIhmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pQ8WV0OTiy/Tj6Y9TgrJEoPswM7uGxkcxVvmTW9DUk=;
 b=xslg3PRd/lWIUOyI6bb4LcWZfp5jZu+uEyKOkIlt3mb/T89RaT4pTa4VZQ72YPMsK20235G3WU1w9u2ovYL6etKDyZ3JTScA6HRw6TK4JVjCjwpoNf+6hgTv0wyoNFxxo6UEyfiGidHPDe7YQiBmlylLoek0EvkxInfwXZTABbLeD3yAX5zK6lc5eDDW/vJIUW9xgsR3ovnySxGfyR3f1PB4tjc+3AsWQM4KXvNC4gkormnc4oKqv/YvMzXfSIl0hQ6lWMA97OwN6FfcKJIjC0vGttQ05g8QDNi4esA4YrzHgfW+4wnMrF1Dq8x5GZ808oi+bYUf0zadWKO0AUiRMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pQ8WV0OTiy/Tj6Y9TgrJEoPswM7uGxkcxVvmTW9DUk=;
 b=BSh7bxIMfNaI5vwqT6BGibM53YmOWkXe3e1RLn24+74BFo5Q1enAQ9m7M0l0wVk6SQBksZlREov6MculDHi7GhrSig/LmVbjNZdGPI6H7xrQAKkAzrdtl3HckJu+p++vloi1EwpMyphiy2BCsC1iXjvf4HL6L5mEn+TmRrZSSoc=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 14:29:24 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 14:29:24 +0000
Message-ID: <a69f463c-0ee3-492c-8505-710d757a1f21@amd.com>
Date: Wed, 18 Mar 2026 19:59:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/6] Accelerate page migration with batch copying
 and hardware offload
To: akpm@linux-foundation.org, david@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260309120725.308854-3-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1P287CA0023.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::28) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: 76cb3e95-4ab6-432a-baeb-08de84fac070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	I42mTN7NXqSKI8umw+srM9GdN9rzKaFlqQH703xrVIAUFKl7nln9r8Z4qWrUCyJkvNTSlSjwfShCzplkoQbU6N1QCrHD/NhnN9Qtek9pncDgbDY4v3TYi7LKJTI33NDT/Kc3ISEdEDYItcpTRiH9ysFs/4cLMgpH/2ZpAqgj3fPUqK25251XO4SrfeA6f/LkJjHOcxKjzu9Q+2nAFyIaiToPUxCnlHg4xn6qm6XaLSugHr6UnXzlTf81+oe2aC+AVrK6qVT+A9p0SJuHwiB7DR62HADAuRQVXGySRHbOEibJLqFb9kMpp1E/koXl/5qbMNLegyoyyPc9YpXzy1/eWt9wrKOtKsJZddSVL70AGOM5m7OY5bbOMd3uMRQVLA6c4xVqOLrdVf5J7ILeWqcEQC7ClhOMesys7r+EUlpA2vmjLSOHM/k7x8refk9AY1W4SZRg4+2mTdKJ+zXqMnPS0JedS5lJYG+zg8++FGHfPnBdsa4f3Ej33dp5TK0tBgkkNkY3vYWjvjijrqnMwetE/pB1x4CpWo07Dy55cTwPrC94KwUI89Yf0/S3uedu8rCvdnJg0hZ26y3LWZrLrq9lkP0TAl4JDkrqDbvISmcTsD/WpR2ADjaqrod/HmU0arYetQkOxeQlX/mnaj9LKsIdHfu1x5n1yW1JBqXb7Dfpi5d3TMzfNaif0znftLxP66XVaOD5jx+GuJnauBvChJboTNnrBg2n0yLVeErcqt2BhPY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXhmUUxwQ3czR2tIbjFoSkRTbDVYQkYxZ0c2Zkp0UU1xV01yTk9TV2ZNdm9H?=
 =?utf-8?B?QzdVMVFqQ0MvemFqM00wNHN0UWE5cjJGeVZ3QVVITkhIaXpZdzg3bjFRa2Zp?=
 =?utf-8?B?Vm1lRHBlY1pvNytLa29IVGdHUXVZaHRQYmZ0NG1kdk0zSy9FQ1FrcjBtbUEy?=
 =?utf-8?B?QVZEODkyZitQa0xVb2RQcVNWdEVlK3g1WkRpTE1BZmJZTng5em9MV09CRlFs?=
 =?utf-8?B?aXJocERLNlljazdmVzFoSHZ3YitmbE1iWEhsQWg3THkvR0JCd3pqa2c1T1E1?=
 =?utf-8?B?Zm9vK25sVEg2QzdJRHRsQTk5Z3dIelB1Tk0wbjdYSGlVbDYzb1hrWnlNaEMz?=
 =?utf-8?B?MzN5TElGb0FQcUNnUHZMZlFiRlRLazFQUHJ4aTg4RG8vOFM1U3ZWS1RidmpV?=
 =?utf-8?B?cVRsRGxqbzRzTVNLcG9veWFVRjJySmRCZWZ1d2JOWkk1Y0plQmFvM01NVWY4?=
 =?utf-8?B?elI1dXRKQVNBcmkvd0tCSWVQWkpCWjF3QVNjRUd1KytIMlB0UzVQZXY5TUZX?=
 =?utf-8?B?eFg1ajM2ckdUbSs0QjNackRzNVlWZW9iY2pURnBRMlFuSSs4bkNSN1dJZUpk?=
 =?utf-8?B?bXUyV1YwcWFPMytsYWVMS3lobG9tV2JMOTZFc2lSMnFjeU9aYkk4cm9OeVNK?=
 =?utf-8?B?SjhtN3dIclJFMEVNMDlySU1UVWZZd0RxZ21OdXZVbkxTajg5VFI0UlJEVnh3?=
 =?utf-8?B?aXpRWXVSVkpIY2t0cUJEajlicnNYV2N2U1E4U2piTnFXYy96ZnZnbkZzSkpY?=
 =?utf-8?B?MHhiNmxaTzRxMVpZOXlHYVBRMm1Zei96a3FuNkRJdlNrN3poVVNYc2JOWmly?=
 =?utf-8?B?R1VUa0MyUzZ0WU5aUU1IZWVveUY2eGRDMWRWcDZlTndqUnR3S1Qwc1dyZXVk?=
 =?utf-8?B?emp5eDlFYXVzdzNvN01nS3gxOVNhYjI4YTN6bWRxbjR5cmluOHI1eVp1NGpG?=
 =?utf-8?B?ZlQyV0c2VGRtaE5CTDdyeXRidE1ROVJ3b1o0VXJ3VEExT0xTL3JobzBhYlRl?=
 =?utf-8?B?VXhyRllCWWhLd0ZvZG1ZWnRoZkh5b2VZMmxZRUFscUlORkdJL0tNY0VhYzk0?=
 =?utf-8?B?YzZwMFNvRytORTBpaWZFZGdyZTdiMGx2OVp2MXJTRmlUTkZIN1UzSkQ4STBS?=
 =?utf-8?B?TGJjZGE5N3BRZ3B6WVN2QXl0ZUFDa2JpMmZVRFJhSXJ1MHI3aDdZOE9ybzFG?=
 =?utf-8?B?dy9vbUhsVTRuYUVJeUxmMVhnaWF1V1dmTjhQdGQwQVZ0aUErU2hvR2FsMWRn?=
 =?utf-8?B?WW85ck5PQzM4bENqeHlvcm9YU2dFRjFxQVk5UXRoYTlFTW4zeW1VL01DdG80?=
 =?utf-8?B?L09hYmFaMlFOR1E0SGlpMkNka1JYMExkQXRpZTFEWE1SSUpXa2x1U09xc3ND?=
 =?utf-8?B?aHBhSitjbW1rRjBKeGV4Y00vbm9xeXJya09mQm4rcWkwTnh6NDI5cDE4Vjc2?=
 =?utf-8?B?OGNBUXJ5VEZqaXFDZG1HaXhmY3dMTi9DRW43bWtGVllMeStBbXMvcTA3elRH?=
 =?utf-8?B?bWZ4a0x4T09uRTB5Uk9vd1Q0cnRDMTRvMlBJNGFwQ1pqOSt3dDY1aDVPTWtZ?=
 =?utf-8?B?d2NwV205aEZuejROOHpaSk9zRjlQakNLeHdmK3lVWjNSVDJFakVDc1VNSTZI?=
 =?utf-8?B?TEZBbGw5TFBNcE9BOEF2VEVTbktvdVdIYUxFUDVoUmZkOC9jTlhQWU4yZ0VC?=
 =?utf-8?B?NW9OTTVZSzIrL09EY0tXa3JNd09mRy8rbVNyQk11RE9CMUh5WXZuT0t5NEpI?=
 =?utf-8?B?UWlvOUg1Q1ZiQmxudDhWVng1OURSZTNaanhBYkZjVkxjS0tmbUwra2phbHVi?=
 =?utf-8?B?NDVTVGxKNGYwbTAzMHlrQjlHSXpNb21pMEN4cVNYS2hLT0R3S2NIZzRoRHRq?=
 =?utf-8?B?bkdTZjE4WnM0MzVXdzd1ZGJ4SnVCR25CeTdjR0xsWXRReGppUzZGeE9OTjJl?=
 =?utf-8?B?b3ltbHFpZEwyNll1ZWJqcmVBc2czbWZkSlZmR1B2Nm1adnRWNFZlS0syUHI0?=
 =?utf-8?B?TjNzOW5LYXZNU0x2bnpTSDhCQmVYeEFQNXJuVlZOQm03R3VCY3VseTZJU1Zj?=
 =?utf-8?B?ejJkeThKNUQzMUNHK3VJOHZyY21JbnlhcFNhRnhTTGlRajZXdEFZcnVEaSs0?=
 =?utf-8?B?Z1dlZzFnRjQ5S1Bvc0VEMHhpcW0rU0p3RkZuZmVJVDBRRGZxRE9URWpENmtx?=
 =?utf-8?B?N2oyL1dBQ2NndWxzL1lWUFhaWHltS0pTTlFqZ3RWSG96dzdqUGUrYVlYQ3M0?=
 =?utf-8?B?aGxSSkthTFFabkFtbWNUK2hRbXEycGwrQVRVNFV5Zy9LME1RRWxxV2x0a0pu?=
 =?utf-8?B?UGY3ek9hTEc3SFBCVmtDWWVtSlZ3c3lONVZWSkhiQzMzMUFUMUh5dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76cb3e95-4ab6-432a-baeb-08de84fac070
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 14:29:24.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wKp5eB4AQAJ/jpREUxIJ3cSpu+BnEn6SRhO4nVR0pYbVx2P7zPd6ERI0H/Vqz49NLiV4RbiaMRZsFDcEKXiig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672
X-Rspamd-Queue-Id: E79A320005
X-Stat-Signature: sqy34nmjosegh7rt9ggdzo7sp54x3z74
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773844172-103274
X-HE-Meta: U2FsdGVkX1/OkoKq2fWMwyEzdeYxJZC6ehSSvrmauonV3ifi3Tc9QSxr8YltO/SyrY6NR2CQ3PJx278LeUPaZlpn6/zw41Na7Wv/8PKTSstqlsWQF7u165qVV0X/9AaMKJtujeOecf73VQfj3lnAJcdqEmmPlHe4tkBvEXelCcpebm7eNxqNY8muplZoc0q+DXrZUAK1qW46nF2oHlPa6ItTvoQT/kyDnJ0kQrjmFQvwWFjwnGCrf4LSMs4pmX6iXisF6AGtaae0nXg7OZgkPTg87ccNDmFv2GoKmzr38WTwS8dOVJQhrbKRJ4OLpOaHvX2TZUmHIeO4Or0MZn/mfBLbP0lTUO8sma2F4FYZw+Un67qPZq6C9B3OXugE6m+m3V7kj0OqItAcnGam38DFbIHCpFKFd8RPHNkV2NBjOm9uvrxvek4vT00WVbvcbE5awrjbFT9JObfieaRXSdVdm3R8t0I9G86Q1bhqs0usLBnlA7eV7TI/eC/xpSpsBtu1eFzy6dk5Hfz7K7aUzbIDkxDmA9p1ivdiv+07Hk/mLjBgsBLhtRLCgYsAZWAhCQSzHDlwgBwVSGRVgo4vD1MAPdb9ZuFUe215rp8BVGm25yctnwYH3Ecfcuetp4OgqAol4K+oK12EjQ1Wb6Rg4iTv/rhPLg4Dz0bcawnMao9fS1oJLtdKl6Dzj0EcYXkyXBpmXFJl+k4T+3JgmmoudSREk4OJSHb/LHmYdgTAnwOJNKYlMSDrmep6yFoA3vhFbRdLbSgL1+MX5Bg62O7rPTGDyE0v+p/uUEuig2ldHgLtHXVJOkCTRNBOQQqhlSU4lEAyBZKzLLiwxdItmLYjgB5Zv8SKhmXP6cyBQ/YNrjvL2FstbE1TgGy85MAeUTjbGA+vxLKKrll/KPcfZtWKnS9I9e5kkE/EP2oAoay6ub68f5GHBA5/IkFzIK7TqvNZAbfUKBUNsON0vUE7w8p5ZT/
 RFl8GptX
 7lTLWWzuxXsc59TbhjPISodMCjfXrgSjt4lCvx40APiZqRXQlwK44tpYG5lzM2EYH/n+HcltOnZhvgcUjy+IyZU2Q5XGZlzkgSXkB6ZixlXd4DdsrFmDUfRKcMSK0p9VHiM5SitXq62KWtuQLxh/F86oGArihophKAzQP3obzChj5lSAI9+i2nesyClJKmX627X39aOnpaYMitmT4j89a4dEJ+V8QO+S/co9RWGlnOHhi2Ydreblteo47pxKbGWzLQzgQw9wlTBGpwRfWMiB/BGOm2K7g0WGetUwTpSlJw/rB5oWm8yAKSiLX/s+wFELDygA9jZQ6zDGHn/dhmyHzkhbmnb8WMHkhNx2MktGX8whw49hTlTpoVOFdROM3zlp5zPwYj0Q54LzS91eZRZrgQzIvJ6kw0xDaEour0OtjziJy1ap1B7rZ9VP1+qiD8PwK9YteUj2e9zeRq1k5J79T5Y6V1CYVmM5fhfssnyMrX4sorSv0LMg4UQEuWJnBzwR7BFyp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/9/2026 5:37 PM, Shivank Garg wrote:
> This is the fourth RFC of the patchset to enhance page migration by
> batching folio-copy operations and enabling acceleration via DMA offload.
> 
> Single-threaded, folio-by-folio copying bottlenecks page migration in
> modern systems with deep memory hierarchies, especially for large folios
> where copy overhead dominates, leaving significant hardware potential
> untapped.
> 
> By batching the copy phase, we create an opportunity for hardware
> acceleration. This series builds the framework and provides a DMA
> offload driver (dcbm) as a reference implementation, targeting bulk
> migration workloads where offloading the copy improves throughput
> and latency while freeing the CPU cycles.
> 

[snip]

> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
> 1 NUMA node per socket, v7.0-rc2, DVFS set to Performance, PTDMA hardware.

> 
> a. Baseline (vanilla kernel: v7.0-rc2, single-threaded, serial folio_copy):
> 
> ============================================================================================
>        | 4K          | 16K         | 64K         | 256K        | 1M           | 2M         |
> ============================================================================================
>        |3.55±0.19    | 5.66±0.30   | 6.16±0.09   | 7.12±0.83   | 6.93±0.09   | 10.88±0.19  |
> 
> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
> 
> ============================================================================================
> Channel Cnt| 4K      | 16K         | 64K         | 256K        | 1M          | 2M          |
> ============================================================================================
> 1      | 2.63±0.26   | 2.92±0.09   |  3.16±0.13  |  4.75±0.70  |  7.38±0.18  | 12.64±0.07  |
> 2      | 3.20±0.12   | 4.68±0.17   |  5.16±0.36  |  7.42±1.00  |  8.05±0.05  | 14.40±0.10  |
> 4      | 3.78±0.16   | 6.45±0.06   |  7.36±0.18  |  9.70±0.11  | 11.68±2.37  | 27.16±0.20  |
> 8      | 4.32±0.24   | 8.20±0.45   |  9.45±0.26  | 12.99±2.87  | 13.18±0.08  | 46.17±0.67  |
> 12     | 4.35±0.16   | 8.80±0.09   | 11.65±2.71  | 15.46±4.95  | 14.69±4.10  | 60.89±0.68  |
> 16     | 4.40±0.19   | 9.25±0.13   | 11.02±0.26  | 13.56±0.15  | 18.04±7.11  | 66.86±0.81  |

I ran experiments to evaluate DMA offload for Memory Compaction page migration (on above system)

Each NUMA ~250GB per node. I bind everything to Node 1 (CPU 32) and keep background MM daemons disabled.

The experiment has two phases: Fragmentation and Compaction(/migration)

1. Memory Fragmentation

I allocate ~248GB of anonymous memory on Node 1 and touch every page to
ensure physical backing. Then, for each 2MB-aligned region (512
contiguous 4KB pages), I free 50% of pages at evenly-spaced offsets using
MADV_DONTNEED. The freed pages return to the buddy allocator, but the
remaining 256 occupied pages in each region prevent merging into higher
order blocks.

After this, Node 1 is 100% fragmented with 50% free memory means every
hugepage allocation requires compaction.

[ ] [X] [ ] [X] [ ] [X] [ ] [X] [ ] [X] [ ] [X] ...

The fragmenter process stays alive throughout the measurement, with
oom_score_adj=-1000 to prevent the OOM killer from targeting it.


2. Compaction Trigger

To benchmark compaction in a reproducible way, I use a kernel module that
calls alloc_pages_node() in a tight loop for the target node. Each
allocation enters the slow path:
__alloc_pages_slowpath() -> try_to_compact_pages() -> compact_zone() -> migrate_pages(),
performing page migration under MR_COMPACTION. The allocation is pinned
to CPU 32 on Node 1.

Target: Allocate **16384** order-9 pages (32GB), producing ~4.5 million
4KB page migrations per run.


3. CPU Contention (Busy System)

To emulate a real-world scenario for busy-system, I run a cpu hogging
process on the same CPU as compaction:

while (run) { counter++; __asm__ volatile("" : "+r"(counter)); }

Both compaction and the hog are pinned to CPU 32, so they compete for the
same core, emulating a real-world scenario where compaction shares CPU
time with application workloads.


I measure the following metrics:
1. Wall time: elapsed time for all hugepage allocations
2. Pages migrated: delta of /proc/vmstat counters (pgmigrate_success)
3. DMA copies: DCBM sysfs counter (folios_migrated)
4. /proc/stat for the pinned CPU — user%, sys%, idle% during the run
5. Hog iterations (busy modes): total loop count of the CPU-hog process


Experiment Results:

I run four configurations on fresh reboot to avoid buddy allocator
state degradation between runs:

Baseline (vanilla kernel) and DMA (migration offload enabled),
Each on an idle and a busy system.

  Mode            Wall time(ms)  Migrated   DMA_Copy  Hog_Iters    User%     Sys%    Idle%
  --------------------------------------------------------------------------------------------
1 baseline         16708         4563506          -      -          0.00%   99.40%    0.29%
2 dma              18887         4622952    4623181      -          0.00%   76.65%   22.55%
3 busy-baseline    33256         4599846          -   62300165085  49.90%   49.75%    0.06%
4 busy-dma         32475         4602750    4604672   66022189744  56.32%   42.97%    0.06%


Inference:

1. On an idle system, wall time increases with DMA (~13%) because the
current compaction batch size (COMPACT_CLUSTER_MAX = 32 pages) is
too small for DMA to amortize its setup cost. However, kernel sys%
drops from 99.4% to 76.7%, freeing 22.5% of CPU time.

2. On a busy system, wall time decreases slightly (~2.3%) and the hog
process accumulates 6% more iterations with DMA offload. The CPU
time freed during DMA transfers goes directly to the competing
userspace workload.
This shows that DMA offload for compaction benefits busy system with
high fragmentation.


Note:
Tuning the compaction algorithm for larger DMA batches and using DMA
hardware optimized for small-size transfers should improve the results
further.


Thanks,
Shivank

