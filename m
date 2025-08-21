Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C1ECA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296F06B000D; Thu, 21 Aug 2025 12:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DE26B0010; Thu, 21 Aug 2025 12:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E6C6B0026; Thu, 21 Aug 2025 12:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 020136B000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:14:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70C681388ED
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:14:04 +0000 (UTC)
X-FDA: 83801261208.27.18B3C86
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	by imf27.hostedemail.com (Postfix) with ESMTP id B40F940016
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:14:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZtJhYhsT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.89 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755792841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYwiRm+ku2hBtN+TzX7d+mbQFu2Sc9eRWzODWrTTz20=;
	b=tCdg10MuiY9Ak2Fa3vgTpuXZFexIOqBgeqNsyU2OgN/RIURw5AnzJhPlN34GMGwu2wvPzt
	WxXEd3LPT6SmWuICFB8WEsBJj9Sd/+mGgyvIi2oTXn+V7LPXCOZg1wM8uYfX89+S3yBo51
	/7S45y6H8idWKSKVIDB6EFWf/SpLxR4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZtJhYhsT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.89 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755792841; a=rsa-sha256;
	cv=pass;
	b=C0lsNxAqez7e5aeF0a9cJZv+kWMw/wQcBbJqDUtB9pwP3qf+dgvA9g9jlFhk/QoL4DUlQW
	ZmcEg3WG5qwA7UPnPdEm3V1t9FeOxLQfVBGfmeDXeES7VemdN+wO5DgBz29QItFHSJJIJ/
	4S7Frb0yxN4ACcAeOvjDhFDJFLBiGIk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVdqDF5rfXXdJFTQ8Z+HcUZOXuDsgC8dM6PabpEyqw8DbpY24zIFu0Uks1/t2MBTa+UAyS5cUMa722ZhLchRuSb0k/Gff6JXDEppQjeTgGgUefr3N5TFu9R5vqAIg6DvtTDgptz7DV9eao3xPgvmTnvhjrjti/FaurMQJMwFu2zX5zo1RLJ452NZdmp2Os7oW1kBZWQODrMx0TOYOeB4Mm38R2ib65xPoPyvWEZ4N3Ff/2ffB2fa6n6wMV2iPXhnpFd/mHaGvKuCyy0S8AWA7tYDlaoUtUld6loFyYoIaTiu0apYPyi82HwD/3wT1Ot2wo57HmbnChGfDzDa/W9NMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYwiRm+ku2hBtN+TzX7d+mbQFu2Sc9eRWzODWrTTz20=;
 b=JO7DMoodqW5CqKJNrLtT/n5QKcdJo37cgpNTpabtq9ZncQCYVpqLRs5EhQ6sHKkvk2in323KmDSoWSgyd2WDgghPr3Nl0Zk/rdv1H3odeaVFPRI9vWKHVYxHqUfEvLBmq/dfVMftWRZnUsaPg0DFDLsXReb+Jkgfl7dvS/RTPK1ap/CffrHly6lFuNhYwKmWsXX1FcnYrs6EYGPW70EmMF8+R2GqyyGxUNb7dj7vA4y+jmXfRP70xPZDX5zrlNyyu3O7VW8IQzZBVU5TZIMUupl779mQTWCAbN5lW+ht5ugJ1E7H2yqVhQs/btt3J7NF2srPzgxDtHJcoNO9lukwVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYwiRm+ku2hBtN+TzX7d+mbQFu2Sc9eRWzODWrTTz20=;
 b=ZtJhYhsT0akZk9KR/r87b/hz7WCkTXA3utenAF6AFM4Zm3W512sthOYLARjDmNCB0Zlrv6Fl4klpMrYeWglxvfGROP/4SYj6nNqMwsTAiq5upyUsj5T8zeMeAkZQc50ARdy9eOWGNPvr8F9Jd+kfcDDwayMWT8JR50KZzxufKGiCvUn8UoDV7OsreUhwksc288vBSGZ8JsllJnC4HAoFaM6PFQk2UjqGihMmH9XyP5euUrfFxjF/RpMMlNQC85tQ/SXQKRXTkN95yQPEFrz5aamssuEi4wLkWYyfNCPqLn2OnB2G+GOWm0cmaurDkytghXXwXAdOTgCQojIyJeawjw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8126.namprd12.prod.outlook.com (2603:10b6:510:299::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 21 Aug
 2025 16:13:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 16:13:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lokesh Gidra <lokeshgidra@google.com>, Barry Song <21cnbao@gmail.com>
Cc: "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 android-mm <android-mm@google.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [RFC] Unconditionally lock folios when calling rmap_walk()
Date: Thu, 21 Aug 2025 12:13:52 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3133F0B4-4684-4EC7-81FC-BC12A430E4C2@nvidia.com>
In-Reply-To: <CAGsJ_4xccre0rz5zgRTA=NbFzF4FLS-ZUohgLFnfTGY9Jdequg@mail.gmail.com>
References: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
 <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
 <CAGsJ_4xccre0rz5zgRTA=NbFzF4FLS-ZUohgLFnfTGY9Jdequg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 987bd20d-2c27-4add-9d2b-08dde0cdb9b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTRmcy81Wlg2TTdxaXVLZXZoaWJya0owYVUvdVBtYWZUUzdhTGVYWjUwMU90?=
 =?utf-8?B?L1BqTHNUcGl0QlVMU2h0SDk1RjV1MXFxLyt5VjU3dFVhd3dmbC9QUTZoRXY5?=
 =?utf-8?B?cFlqTmpGdkdNM3BaWTN2TS9BMVh3TUpJbzd2TWFxc1NRbXJTdU1xQWw1VjJZ?=
 =?utf-8?B?RmMyWE82TndkNy9PL2ZJRGRyWDZDYk1XR0xncm56dTd6V0lQUlprOUV3TGVn?=
 =?utf-8?B?T1J0M3RCajkrcDN6bWNseFFNUUlURWVwb2w0ZEtyUldwZ1lPSTFmcXhYR0lF?=
 =?utf-8?B?MWJUdm9kc3pkMktrWEcwVVNBUm85emkwSXVSWU51UWZ4bmdiUWJUVmFDRWl4?=
 =?utf-8?B?RnZ6MW8wMDhsSi9SZmZJdzMxcitLTXY5UlBkSjl4NnkzTm1rMVBxa2xqUmls?=
 =?utf-8?B?Nk5oM2ErN1VyMGxBMWNwVmMrMVkrTGdnT2pSMDFobGx1a1Z1ZloyQ0JYbEl1?=
 =?utf-8?B?YWpzT1UrU3hTTTc3TDVJUlJua3B5UmpZVXV6RGxyZUJGTlo0bjZTcnQvdGVt?=
 =?utf-8?B?eHF5bzcreGRFaWQwdWNMa2FjUEJtNGtsdDFKT3JrdEVYZkpoTWhIY0llcUtT?=
 =?utf-8?B?SW5uRGJja0QxdEYrNExRQ3NZMFNVUVZ3OGxpWVFXS2MzckFKV0MzME5yZEhk?=
 =?utf-8?B?U3lUWG9CVkpMMklvYURjOHRIL3h6Vng0dHgxdjdQMUtZU2VVWG9xWjlFMlNU?=
 =?utf-8?B?YVBVZTRSM3dWaHNoQThiM2hoYlJzV3pGUFpXdzFDTGdEcUdrVm4rZTdkRnNa?=
 =?utf-8?B?amFsVzcvcWdJUmJTSG13enp6K3Z2UHhaV294NnlzczF2UVJ4bnF5Z3FORXB4?=
 =?utf-8?B?YWlCdkgwZFIwTVBBY2x0K1FWWGZQUnhUMFBPVkFNd1ZFL01SWVFmU0d1d2ky?=
 =?utf-8?B?d1dNbVZ2YzR2VGtoUTlwaURNdUZBRndVVHJyRWpRSC9wQkFOb2VjSUZERklE?=
 =?utf-8?B?Z2l0YmhBTkg0Rlk1M3huS2JBKzA0U2RCcTdCU0ZZVDI5RlJMNTUwcnRBY0hj?=
 =?utf-8?B?dUEzOTAya215SXVxeG5ubmF1L1NKd002QWRJaU9pcEx5ZFMrUVRwa0JVdlRT?=
 =?utf-8?B?clJsQmp5WC93aVN6SnMrMkN4QUdmVVNFYkNkenpRNFd6L05NZFpxUXIyTkZp?=
 =?utf-8?B?OVp4Q0RDQjVjbEdsZnorVk9aa1BhMlByMUFCQVlkalpRZXJIQWZDWFVVQnd1?=
 =?utf-8?B?QTQwTGE2ZGxBMTNQMGs4TkZIV2hZcDB3eVllN2lyUGVMN3FONkFyREdlZnMw?=
 =?utf-8?B?MlpaYXZxWjI1VUVROWF6M3lNZlo0VnBBT0RwVlBrcmpOdHU1UUJJRko3Nlda?=
 =?utf-8?B?a1lqZ3piQm1EYktGdEZRbUZFZVY4WHZ6ZnRXbDhDNy9KL01ObnJSd0pzV1lp?=
 =?utf-8?B?bzI4SDJMdzBLUU5YTDdnRWlZMkxqdWVia3l5OG9kSkFDeUMyVkpMTG9yaE9Z?=
 =?utf-8?B?Nkdqd0xKR3Nta243VUxOSnFBL0RodENLM0NDbWo2MmtMOUlXNFJFWGRkVWNW?=
 =?utf-8?B?MG9lV0tCTjNCOEhIUUwwVUxOMzFlUE50ZGlaTHA2aHZ6a2NqRlRaU0RWYXVn?=
 =?utf-8?B?VVo1bG55QkNXQXAvcWlzRkhpS2xUVkV3VXNtdmZuVE1ic1p4L0twaHl0Mm5r?=
 =?utf-8?B?M1JJZ01lUEtYSUFEd1FHM0w3ZGtseDluU2g3WG9ZZnF5cm5QZnYwWU85dDFJ?=
 =?utf-8?B?Yk5zYUNxZkdpZUo2VE1ka3gyS2d5aCtqUk1kRVlROHY4a1JjNFhvaW02VGU1?=
 =?utf-8?B?dWpaNFBidlJzQjhzZVpZeWdtY2NBZzYzWFlRL0p6U0RnMVdEa3VHOGk5UytS?=
 =?utf-8?B?QXNPdDN1VHRKRGxRNXB3QXVaN1BWWFNkNlVvdjUzMUJOTEw2UmRxbW44dk11?=
 =?utf-8?B?aXJTeWU4U09LSDdCejhKNGtLc2h6c1RVaUVjN3E4SXBWVWVaYWQzdEpzQlpD?=
 =?utf-8?Q?SZl8L7CvHNc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekNVS0YvK1h3OExVL0phS21nRVVlQTU3U1ZSSjlTODFhc1VKWjhobVhOMzZz?=
 =?utf-8?B?dzlvSnZkNzhIWStrdUkrRVJTcmhkT3JlQlBLNXJIMGJLOGI0Z3NzY2JIdUhD?=
 =?utf-8?B?VlAyWWJWZnZBS2kzdml1WC82Qk1EVmN1ZUF6MStMNFQ3T0t4N0VuREtwa3Jx?=
 =?utf-8?B?RVNGdERhSEVNekdyNndUMVpEMDNIaVlCQm5CTjdERnFDb3k5YTFCUXRtT3BD?=
 =?utf-8?B?T3NVVC9Ib3VMQVFPdk96OVZhMk5pZ2tSeEZjTnVDemc2Um5vWXR1WFNabjBL?=
 =?utf-8?B?SnBnNGtnMlc5ODVNR05Cekh5UjBYSnFxUHBXdWdmM29IeHJWRW9FcCtxVi9D?=
 =?utf-8?B?Z1lRVWxNbWFPRytBT2IvdlUxT1VtL1RlbkhjYmdFT1FkTVdjVzJyeHBBMml3?=
 =?utf-8?B?QzZMTUZta0ZOZHBqUG5uSUdhM2gzS1AybkI1aW1mREMxalpzSkhpQk56QXRW?=
 =?utf-8?B?Mmo4dHdEWCtqQm1EUnQ0ejFFNklsVWlsc2U4UlM2S3EvbEVaYXBDekRiaWdq?=
 =?utf-8?B?WTVCQWJKYlNKVzRCQXdCeFJFUEVEaDlucVFKV1h0QkVWZWtuZnZSM0RyQkV0?=
 =?utf-8?B?TmJmSUNqbmoxL0hvUVB1RXEvOUs2eU1OVWRsbFlBV0pIK3BCekt2MTFXRW1t?=
 =?utf-8?B?dzYyMDNaaS9McVJVSUdIK3ZQT0JoUit0QndoUTRHZnRpaDVTd21jS29OOTBn?=
 =?utf-8?B?cEk0RXNJeTc2SE1PSGZ6MHpyUml2Y3NUWkhIKzcvU0tJYjc2RnR5RlIvU0Zl?=
 =?utf-8?B?Y1F0cDVPTWFtVk1Xck1NM3BQVVdwWUJvSmZ1ckVVVnhuMmxXaFYyZ3JYd1pV?=
 =?utf-8?B?aDg0L1Z0UXltdWdDWGZFTUxDa1dDeld6cEpvZ0NQSEVFL3M4SFlWRTRJWlYx?=
 =?utf-8?B?K2trM01NYmJlVGNPQUYvSEpMV2FrQzIvb2pQZVFmK210NzhRSUNORzIyalBP?=
 =?utf-8?B?M1RwR2RRS1czQWdyWlErYk53WFp5UDB2QTdFSGhlZDJiays5TjJJMWcwdEVD?=
 =?utf-8?B?WkVDVEVCaXluSmdMM0FDbG5FN1MrQnpDMWNuUGNhb3l3YStKS3FMNXZoZjA1?=
 =?utf-8?B?dk9xdjEyTTJibXlJd05YUFlFa2ozYWRQTEp0TEFtVnF5Ti9aSlBXUTVlRGg4?=
 =?utf-8?B?aC9sY0FNeFpJYmliWHRQQzdoNVUyRmM2L2RaeHh1VVJoaVNJUkRvckV4cGZo?=
 =?utf-8?B?RTU4QitXTzFjUGJ6WmFuOEE2VWMzUU1ZUW9VOEVZQnlkR1ZOUDg2ajVsbkc4?=
 =?utf-8?B?ajV1ejlMU3ZzeGxTM20zMDZRemFCUStLUFI4QnRZaDB0MFhuYWtlV1lEemJh?=
 =?utf-8?B?U3RRV3RJVmJqZDhQTCtKYlR5RDlYcWdXdkNOUHljdDMxeDFScWQwRThwZkt2?=
 =?utf-8?B?NlE1R28wdWNaVHZoTUxONmNVQnRhT3U4b2FWVVYzSXlZbWlyakpWdFgvNEpR?=
 =?utf-8?B?NGJIL3FUVHFlYUU5NmZuTnc3Q1hOcEFTcDhBL29palozVzY5MmxUaGVHenpD?=
 =?utf-8?B?a1ZQbFhXMGVJVEpEM1hqZEpDYk5qb0RoYXl3Q1R6eTRISlhMVlhVcXlqNDJU?=
 =?utf-8?B?L2txMDVtbm5acWswdlRPb3BFNzR6V2p2VGdCNXNLdDZZWmR2Q01KTlk1T2hx?=
 =?utf-8?B?eVpCYXJEZk9ZLzhPV0duZzhnRXIza0tsbXphUWQ5UFFUak9nZmlVdHJMNkJ5?=
 =?utf-8?B?L1RYNXQ1aWUydDVva3o4YXZUNjRaNTI1RDduUTFlNjZVTlIrMjhiRWZDTDgv?=
 =?utf-8?B?VlBCRHRFUzRST214YmoySzdrL0dnOFl4NjRLbzZ1dHRVSVc1QWxHc2VvcTZO?=
 =?utf-8?B?dE5SbnFkanpmS0VxVUlnbEF0UTdYOW96Y0RjN25JTmlOUU5wYnByZGtaT0JR?=
 =?utf-8?B?L3BaUXpKTzhLWDVGRHlXcUxEbytacVk3ajFxMTlyaCtDNnM5bzRWdVVkQ1ND?=
 =?utf-8?B?WlRLaGM5QTRXRTBubkY5Qmh3bTQ3VVRaOWlrZVVHMmM2aGllWkI2QjBoY0tr?=
 =?utf-8?B?R0JWaFZNZzZ0QVpuLzkxSG1YaytZWkJYN3VyS0FCK2RBZlIwTEhSbzJOOUVm?=
 =?utf-8?B?MWtmNFY5Z1ZnTXMyczRkZGNHRitjVmMreUxLanNNQ2VSektCQzhoUzF0RTZu?=
 =?utf-8?Q?X0SqB4xxawwApljjqboRQCNd9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987bd20d-2c27-4add-9d2b-08dde0cdb9b8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 16:13:54.6519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ix03p1YjqnC3sVv4upn9Rm0nP1E4cKl7xbVdjlvPGNhLicRhj37AgCiLIaOgK89U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8126
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B40F940016
X-Stat-Signature: rkbs7qf6sadb51ffpemf1my3r9xys5gw
X-Rspam-User: 
X-HE-Tag: 1755792841-174383
X-HE-Meta: U2FsdGVkX1+2LJdNGzWc3Ja6gNpZXfzRfY06dQPfUAfFY7y+WHFlNm76W6sagUecokCN106ys0H1kQPeCPhUipvvkVASE5Zx5u/xKpNYZhL/gUBgz2SWQARK5BKFCOQ4mTXPu9N8HG2dK4jXfuWzOHctn1Wgb800rrjdGdtyQGvtg+08rfYQhrKAJLYmcy/gEw1JpBPUcC/M1u2bWBa8y0Mxb9GbEUfwtvITHeX5LtaXMm8eaB3k/moejoj+6VbeU/AMZCO2xx3XgSj8ALbPzj1CMUakuGkQt5YT2ttTFEqgql7SWs5dddl7mP3uwxSzhQVv/CF0Gj0fHHHDEMWz7Bwmci0KPy+juWUilA0G/MyHiVz0SlonX/C6zzO8sqfk1Dg92zrCWr/qTSHuUb64XCnPXnLGSwzvxQnpUfw8A5s8x5UBECdfxfzUBHLjAM9VFYh5wsg+KldCHnqToxqc2pq6pb+9aYQ7nnbYF2fXMbUEGCzuFi08ImSzqaWFsLviPnf4kTVO3FeLww4aeI4PF3rjtK5nOodP/3AwyTl51EaANRtAr0A23zGQlKlWBjH+RyqhCdxuC3wwvMraNnhmsqqVmHYz9DYGpzju21mMhHfg+X+mGk7/CEM1fwp9H2MADaFR7TSleTeitzGp9uHF9dZpzl+BnbzmaY+q0Trhui9ixaOAe7/G6SeGKpF/76x/ikdsb6u+LenfJK06grgreGpSTYIDSLCQxdx8ekNxYJ07OrMU0CW5a9QEXguFuM1EJaxomqrIMDL5FRMHMbviRMeZfz27uc6vH/vLTkvJmSmi6v/RexQ0GIy7OY2oQnR3qiMsbLHBeUAzaTp2GGqDHECqIZf/rS9FaRT1ZX5lbC9V59U4wO5vRIJbWmVrbsstI/BGXSQBqbESHpX0JnyK8gMWbLn2PZBdHbSpfLbs6p7MMC2p96lTkILvORV4Zu70TahoDoAHRCcmr6m4rcn
 2W5BPahd
 Aehbs5l6bSqT9nuLMIc0VOI58GF1A3balKW0WyeWNH9zPY4St9yxCzAffW6IyyB7SgXylHVOzIOSndg2Bn8ZuRBWEwmsprZ37pgEbSaRSPpdNAfQVfzeCkrZempTilLwHDlzRNHh8bIVu3JUFgFQpm44rXY/D9gw1dv6YNiTbLG6hcgfaQ98N2sDzu+bXdNO3G+ZY3zVEE58GYPSoBUlb84ZU02oyKMW4mKr1hU58CeKHulwiazcCgH8sQKQXYw1RKoSOBM/SZA0/TpBlETGuqUPFl974sOImYe0Z6bcwpHZh0rW2QEq0lAG2tlXkYzqxGFKdkdUVKQLU7qlQFNs4W0Qu2oPJvpgY+9MmReZH62eqoa8SkRpnYh/UPkdhPQsqpumoDn48jb6JhHJKo9vy+LkCPt1geMS0tJCdDPfWz3GyrXQAQ0m3I3IURCXjctfdyPD+nTHrMyL5cyWUWE4D5y7slXtsWvsoKU+vsf3kQx+X8UGvbyAHSsvChcOzKOWS1fS+XKBXXx+AmRu7CjRa9AgbpSWeOsqlVaq4HHP8flVWbmPuRHoGV1sbXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Aug 2025, at 8:01, Barry Song wrote:

> On Thu, Aug 21, 2025 at 12:29 PM Lokesh Gidra <lokeshgidra@google.com> wrote:
>>
>> Adding linux-mm mailing list. Mistakenly used the wrong email address.
>>
>> On Wed, Aug 20, 2025 at 9:23 PM Lokesh Gidra <lokeshgidra@google.com> wrote:
>>>
>>> Hi all,
>>>
>>> Currently, some callers of rmap_walk() conditionally avoid try-locking
>>> non-ksm anon folios. This necessitates serialization through anon_vma
>>> write-lock when folio->mapping and/or folio->index (fields involved in
>>> rmap_walk()) are to be updated. This hurts scalability due to coarse
>>> granularity of the lock. For instance, when multiple threads invoke
>>> userfaultfd’s MOVE ioctl simultaneously to move distinct pages from
>>> the same src VMA, they all contend for the corresponding anon_vma’s
>>> lock. Field traces for arm64 android devices reveal over 30ms of
>>> uninterruptible sleep in the main UI thread, leading to janky user
>>> interactions.
>>>
>>> Among all rmap_walk() callers that don’t lock anon folios,
>>> folio_referenced() is the most critical (others are
>>> page_idle_clear_pte_refs(), damon_folio_young(), and
>>> damon_folio_mkold()). The relevant code in folio_referenced() is:
>>>
>>> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
>>>         we_locked = folio_trylock(folio);
>>>         if (!we_locked)
>>>                 return 1;
>>> }

This seems to be legacy code from commit 5ad6468801d2 ("ksm: let shared pages be
swappable"). From the commit log, the lock is used to protect KSM stable
tree from concurrent modification.

>>>
>>> It’s unclear why locking anon_vma (when updating folio->mapping) is
>>> beneficial over locking the folio here. It’s in the reclaim path, so
>>> should not be a critical path that necessitates some special
>>> treatment, unless I’m missing something.

The decision was made before the first git commit 1da177e4c3f4 based on
git history. Maybe it is time to revisit it and improve it.


>>>
>>> Therefore, I propose simplifying the locking mechanism by
>>> unconditionally try-locking the folio in such cases. This helps avoid
>>> locking anon_vma when updating folio->mapping, which, for instance,
>>> will help eliminate the uninterruptible sleep observed in the field
>>> traces mentioned earlier. Furthermore, it enables us to simplify the
>>> code in folio_lock_anon_vma_read() by removing the re-check to ensure
>>> that the field hasn’t changed under us.
>
> Thanks, I’m personally quite interested in this topic and will take a
> closer look as well. Beyond this one userfaultfd move, we’ve observed
> severe anon_vma lock contention between fork, unmap (process exit), and
> memory reclamation. This has caused noticeable UI stutters, especially
> when many VMAs share the same anon_vma root.
>
> Thanks
> Barry


--
Best Regards,
Yan, Zi

