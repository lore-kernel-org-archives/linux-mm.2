Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E22CFC522
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 17:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3126B000C; Sat, 22 Nov 2025 12:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73A86B000D; Sat, 22 Nov 2025 12:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14196B000E; Sat, 22 Nov 2025 12:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE646B000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 12:15:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B33212B86
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:15:14 +0000 (UTC)
X-FDA: 84138893748.11.64DA549
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020118.outbound.protection.outlook.com [52.101.189.118])
	by imf08.hostedemail.com (Postfix) with ESMTP id A092D160014
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:15:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=KVaB5FkM;
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.118 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763831711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWH3CcWBkeYbAxvYMywLu3eXiI3g/1qNhmOgwKQcVVQ=;
	b=geUHh4kmqFBoB4Y9EeoTdZSMWBIqgPGvlpyWZYPC7Od0vSx8PRTQAI/x21rBNPDA7B8npm
	K58JgdFa8bjqo1F/GiqLXTpYkzDYweiCABi4VfJ9Vb/AYFldl7H05H0kyf7LN7Q8zQpSk8
	Br3JzPSkmK7KMdvHlYBtgxBn7jBHhlo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763831711; a=rsa-sha256;
	cv=pass;
	b=j6h/DpRpSblbGFFwZDYnp5/80E3gdMAzgW8irFvUnIVftpo0fjMiQEk2pyLuda/DNb5iiU
	wGDoo6jyU3tgthq6G4oTbe9Hog3XptbqAIZLgSWn/sVURm69RGqsuQe9VYqcVAQE2Pp49f
	jLevPR6Gn2+7JUuUPv4Wpmhl4cNXyP8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=KVaB5FkM;
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.118 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XnRlHBZUPrbazirVzRrKpXB2dGOxj31zBXtZfWL2V3AJTaHJCE4X5nWUNT8pLP9WAv1Zl2ulxVsWIsQOKwJF/LYdytsks2/szLvcbFliFz9UyIF7SqjdcKC2VHpN1QKoRz5LHv8tZ3hPvfEzaKHPk3m5ozYmfAupJVOP3p/lxH7N/2OVRmjRC8tY8Avz32Fc3Ag5ajfne8lkpUev/38t+mHHy4PCqA6Uwsgte9sz5Zpd9ZZFYpwXEQHUNFWMBVfC0ZNZR/DLiHVHXxuVdoXXKDnSG65UAJmfBCsOHdWKBKeBeOm8UhFwFekqfGOUFnfq0SjKNZzAm745rsqHT3tycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWH3CcWBkeYbAxvYMywLu3eXiI3g/1qNhmOgwKQcVVQ=;
 b=JiKbnL0pdgXlbHFicdiy2r0viCvo/pLtR3BC3nn4SNN8UAmh75x+luS8idTonIXoW6NvKn5YrfjXlYfj5tEqyfaSMIU/E/rji8zWrB3OaM26p+rmisiyjON0m0WfdGCopRhXhC+1rKcf8rVC+3GNcsdQdmnc7JuVovjA5xt65KX7kx6a/URrt9eG7DABi7dttppAyuHBJXBcX2TO6kdQmmWz38jcR+EaLYGYWJm6IT+eNGkOdYdRdsqdiRQ4EGY1JwL1LagR2U86tLQfuSlcvSWa/qzWrkR90S14k1YEMr+Vyb8U+GyYK9jrTMdmRyCGY/NNIzMhQx4N21ARZ9uPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWH3CcWBkeYbAxvYMywLu3eXiI3g/1qNhmOgwKQcVVQ=;
 b=KVaB5FkMrKEpIPWU/kzxvHczmAxQrHZHnv6fV4oARziN2KrIUMZFHL2q5DiYghrrnbWDoGqVgqUeUI+l4HIhXM5r+HCzBdI8QoYXeszfYr4uxSsFQpIzEBVoegzpo5F3B2CiYlDuythd+uPpKfvw0OuiMTDl8H95F05KzmpRn/eobxSWbr5uowyY6bNOR1+ZJPb6DkGZp7I0M3PdFXG3dmcWX4UGsh5knFepeDHQx9taC4PTiqIFvAjXx2NdZcEmI+2NdMrv66zvAtSkyf0eGhQhC4SmWuA7vdesrb4tyd21xDntKZheKVC33S1rmSdQAXIPe/01tePI4yiKHpRE5A==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB5908.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:5e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.15; Sat, 22 Nov
 2025 17:15:08 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 17:15:08 +0000
Message-ID: <a3652f6b-cd3b-45ad-a3ad-e92369cf4068@efficios.com>
Date: Sat, 22 Nov 2025 12:15:02 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/2] lib: Introduce hierarchical per-cpu counters
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
 <20251120210354.1233994-2-mathieu.desnoyers@efficios.com>
 <20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::22) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB5908:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b40c22b-6a1d-4a79-9d84-08de29eaae6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnlvZ1dQVFlCWFZCczZyYXFXVkVNc1lyVXJ3bk53OWE4VXpFVU5ycU1Qbmd3?=
 =?utf-8?B?V09kZVltaVVsZlUwQXV1VmpubFdEdkRXV09hWmVwL1BTY3pjakpud0dqbFYv?=
 =?utf-8?B?RURGZm9vVXFRVXErdWZMMm1naVpxRE9qY0dsOFFuTE1MUXpEZnlzTGczdnpL?=
 =?utf-8?B?VHhGQktFcDBLMm5xWjQ0bHBUOUdnWHZWeCt2Rm1PWEFFYktVM2tuU3hNT1Fo?=
 =?utf-8?B?SFVsUFlHSUVKQStHTnRSMWQrMndoT25uNk9XNDdGdnFqU1RiRURZd1p0cmJs?=
 =?utf-8?B?M3dzNDRxZWdRRHhYeElUdyswQk5yTk12TVNyZHBJY3VjOEg4bjF1R2pMeG1o?=
 =?utf-8?B?emErazc3VmZnRG81eW5tc3QyNXpFdmUvT0J6dHJqeVlMU0czY1Uvdk9nVWRO?=
 =?utf-8?B?Q1ZBNDM2Nk9jZVBmNm9GNHdSWkRiclpZZVNPd0xtZW9JZGJYUmVJd1N1U0Vn?=
 =?utf-8?B?MXhITHFRdGUvenFRd2MwRElpTklON09sVjBZRXVOKzZ0SFpMWUVGbW92V3BH?=
 =?utf-8?B?Q1p3Q1laOS9YWnI5U21YVzFHdDFJUGV1MDFXNUJaTE1rc2RpeE9yc2tQRjd4?=
 =?utf-8?B?SzEzTkxMQjE2bUQ5c1BWU29vTVQ1VW96S1lpVmxkZHd3WFZmWWZRbkRIcGdr?=
 =?utf-8?B?M0RPUGM5UEVYQzRKOWFGU1lSYmY3NXZHWG1QTmYrY2NFZjdyanRFeFM4Sjlm?=
 =?utf-8?B?MTFKMTZUOENQdnRDdlVPZnhZVVEyaUMyNkQxVEt2TWJYdXpTRGkzNzlxK1M0?=
 =?utf-8?B?RitkUmZURE0wVERvbS95SVZRcE9EamxSNlhjRFdWYWNxZXExcjVoN1NOMkpl?=
 =?utf-8?B?VGZhckhoSnJJZmlsM25pckJjQVBreUIrVUhmM1FuNVlyKzZUbG1aSnp6WVYv?=
 =?utf-8?B?NW14elRsaVA1aWExSTRaNTNtK2FrQWtWckpFdEQ4N1JaU1NadDZ5Q0VUMFMw?=
 =?utf-8?B?bzdSeVRWU0FTcGNTUmtoV1k2Q0FQOVhIdDhDMGpyL2w2WCtvaHBKTC9QSDRv?=
 =?utf-8?B?VW1Ualg5SFZjUmpsVFFWZDRXc0dMU0xjdmZtZ1NXUitBYUdSZXZPeFJtOUtw?=
 =?utf-8?B?YTJEMythOHJOSnJ2Y25DdnFHQmllM29PRUdmWGZQUllPMnRpR2ZWTlFwR2Yv?=
 =?utf-8?B?ZnI2N0VsaGtQbEZWckRuY0g4Z1k1emVNTjN1K3A2RTRXNk03Rmx0VjZ4N0FG?=
 =?utf-8?B?Ukxja0VzVmRKQjBjeEdaNWt5VEpzcFFxQUtrT05ld2tlMzVQSHYwbUVVMm9T?=
 =?utf-8?B?dklLQ2t0UkFPZVJSVkZsUnl1RWFQTFV6aDlJRTc1a2ZRR2hTbmFOT3dlTldI?=
 =?utf-8?B?c2lsUm1hYzFpblVlbitOVDZjOXVSY2lLbVBSeFRJOGtpWUg0eXlkVzI0c0tF?=
 =?utf-8?B?UUc4UVRqeGNGT1d3WU1aMU1oT3dqd3huU0Ryby9nRkNIMStoUENqSUhyeTQ1?=
 =?utf-8?B?R3lzSmFONDlvRzlNOWkxQ0p6cU44Uk9DUlRxazhFMU5DeWxPTmJQY05PY3Jj?=
 =?utf-8?B?cDlDMnRGalQwZCsycnFOV283eWVqckNyVHV1M3BmdE9SVUJXdGNHenkzWlFh?=
 =?utf-8?B?Nm5YZ1ZhSCtFWGhtSU9qYVJBNUVxSERaMkRJOStDTGxnNWo5WjdCNUVFOUVn?=
 =?utf-8?B?bTJ2aHFkWjlMdnQ0T3k5ZkU0SG1KRVVtUVROOHlVczFiQ1gzMGFYOHlmVkNo?=
 =?utf-8?B?Ti9VRDA4cFB0bElRYVZNZTRPTGM4QWQ2UGhiSXZPUk5ZeERSV1hnTmo5OGcw?=
 =?utf-8?B?WkswMkZRdHl2NWZRZXFEVytGL2ZOaTZnZXY4bFZHTUJSazZyUEc1NnpPa1dn?=
 =?utf-8?B?N3BWTTI1aytvYlB4KzdzMEVPZkw2cG1tN28zL3Z6QmFqUHB6N0N1S3dMQTJv?=
 =?utf-8?B?Y1A5MVR2T25HZVlxWTFnMCs1NU9zYlBlQ2RhSkcrUWJndkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zll3ejRrYkxRL3ZXWTBJRmZDK2NURzVOTW9Lc1U0TzcxVUNzQjVTNTNucEg5?=
 =?utf-8?B?VTlReTVSMzVybisyK05lMjVqRUJrNWtxRVFMVGhlYU5QQ3F6QXYxK0EycHlz?=
 =?utf-8?B?TFV6M0laaFg3ZUFEVnlweUQzYURBZ0xKUkZ3VEhaNlE0QlZPK0RjS0JqVnBn?=
 =?utf-8?B?NUtta05SNjRObDBrMGsxMWJWbXRLb3RMYmpQUUpMVU1hUzcyK2dKTEtTZWRh?=
 =?utf-8?B?ZysrT2U4VmlyZzFjZFE2U2I1b0xqZEUyVXc3aCt0OXErQ3lmbHJnd0JHUUwy?=
 =?utf-8?B?K0lvaHZjVit3c1hYMElVWDN4VGNhdkNxdTdRaHdvNS9RMHFYVjRZM1M4T1lD?=
 =?utf-8?B?M1htRmdXcnpoZnlrbXkvSWxsZUp6ZVMrbUZnZWVSU0NnWlVmVmZlRGNlc0pr?=
 =?utf-8?B?UlNLMXBER0MvdzVnd3ZzenZqL1pFU2gzNDg4ZUcxSkYrRzlXZmpaUjNMVjRv?=
 =?utf-8?B?d256NFB6Ymozam1GVVAyOHUxVk1ETWdNWkZLOEVyVUxhaXNna2RPeFZQZHFj?=
 =?utf-8?B?QkhXMXlEcDdBVE1yS25KTndTTXorM2RUSlcvMGtNeFN1ZmlLd29RRlRvbklo?=
 =?utf-8?B?NUtyS3g2S1JPQVdhUFZhY2VyNXYzT2FNZ3FqczB4Z2NjRExDTmt1V1YyUTh6?=
 =?utf-8?B?eGxsOUN1YlhNdExSRGpWd2xaRkNZZ091Y3g5eUxVNVN3YTNwTFh3SHNacVJw?=
 =?utf-8?B?M0hjQk9lK1liNlltWkIyM1JKa1R0MENDa0cxbkFVYjBBYUJSdFJSZlo3eE5D?=
 =?utf-8?B?SlhmMktXN0RQV2ZsV2Ruc3l5NmFsWk9EQ1k2aFkwVEYvbmhRY0tkWENGUVlB?=
 =?utf-8?B?MC9DVDNhYng3eDE0b3RXZ0o3akM3OGdyVlFzS1ZMRk43MndxQW9jS2U3Qnp5?=
 =?utf-8?B?SkMzV2x4TC9sT3hQcmV1KzRJc0RjVXBpNGZYdDZMTEprVHBQaXBobjJONVhX?=
 =?utf-8?B?YmlNUGlGc1ZJVnRiaHh6ZE5FaVBwc081cFc2Y1dUaTh3Q1FuaWJZS2xnSzJy?=
 =?utf-8?B?RU5GOUdNTUhGYk5MOU00N1A4OE52czNoU01WN0MyYjBwU0ZwbGlRWXR1VFpY?=
 =?utf-8?B?YXBPOG1NREZLRkVFTGNhendGaGwrbG5NeXlPZVpSUGdtZlQwYzNMWkQwNEpm?=
 =?utf-8?B?SUN2TEpPRmM0RHZBNVlPL1E0OVV0WG5VOERVZmE3eDRlZlNtdkY0M3p5N3JH?=
 =?utf-8?B?SjNrZUM1MzdzRkVUMURHVUVnbW1PQTR1bkM4N2JRcFc1bGhEMVZBVGZHZ1cz?=
 =?utf-8?B?Z1VDaEFmODkyWjIrQWJid1lOT014MkZRd29Pd0V1V3cxM3R6TW9KYitLbkZP?=
 =?utf-8?B?ZEI1YnVtQ1RjSjU3clZIZWNveDlCT2poQUhpR0pzbjZvQTdLaG0ybXNSZ3g1?=
 =?utf-8?B?cnpFUWMzZHZQVDB3M1lPL09adDRuUXA3NlFZdExtS3c1ZFdCeUVzVkdlZ3Ro?=
 =?utf-8?B?MDVwZDNPZkh5NHhYQUd6K05qV0t5UXdicy80NFljTGphNjhPMkFVcitEM1ZY?=
 =?utf-8?B?RFFwRUdRclVIaFJnK1pVdmFBT1QyUHBqWnYwM3g3bHcvUFIyMHRwbzQyQ080?=
 =?utf-8?B?UzlhVEphR3N0MXF5YkdEb0d6bFhMc1dXTUZsaXdoZXRpLzBWeVJQRGtONVow?=
 =?utf-8?B?ZXN2MTZQVXNSOUd4Tzc1cUxWVFdBZmpPK0hWa1pjSVdNZXVZQUg2eERodlpN?=
 =?utf-8?B?OS9JWTlRTUFySERFNGR2OVI1MEJBSEtlZFlFYWUvNUVkZXU3TU1Qdng3a21Q?=
 =?utf-8?B?c0VCWWFBUDdWMFNvODQzc2pSYnhyWXVEaFBkemM5ZXhjTWxpKzE3NEIvek9s?=
 =?utf-8?B?SEpMaTgyOVlrRi9qL0lNRi9ucDRYS09VY1dvcU1DZjR6aS82L01NdFZ1RUZH?=
 =?utf-8?B?WDlvc0xlOFVSZHRKdXFYazlXVEdtbUhrTnhGaTF0QTZjb1hFTVpKTHZTZ01Y?=
 =?utf-8?B?aEVLWlJ1WVlmOXowQ2tXajVYNzYwcDk5MEdXanBSVHVkOXdIcExiRUx0TlpG?=
 =?utf-8?B?QWtOY1hUTy9EMnFIcjNjU1BuOUtWLzdMOTBpdEJuTWRrdldBbEpVN291YTFh?=
 =?utf-8?B?ZkFkbmExK3BTUlI0aTBzRWFBVlVuby9zdmN0cTVGOGNlSzlnV0xMaU10bWxo?=
 =?utf-8?B?RGFXVStRd016SFVOYklzZ3g1eGU1K005YkdTNWVIRUlmV2xTVGwwajB0cGR4?=
 =?utf-8?B?RDFDcE9RZ3dnallWM2pwUTBxT0ZNOVBlcmw2YU5sTzNQODZ6N1FJUGZxMWpV?=
 =?utf-8?Q?PcMNRWN0x+lyCfkhMfnboS136NQ/OEr8b6Jmq85YsE=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b40c22b-6a1d-4a79-9d84-08de29eaae6e
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 17:15:06.0363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmrMLkn1d/NQFXx23rDsjwgc6xz6dvyBiZQeIyhBSBgVHVCpK4JDacBmF1vnkUOyMz6HKbq2Q8rdRzMgCoKXIHEMENiUqOqSXb3BqfrtQqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5908
X-Stat-Signature: qytfxt9asfd9bxxb4nxqdegoau5e6wcb
X-Rspam-User: 
X-Rspamd-Queue-Id: A092D160014
X-Rspamd-Server: rspam01
X-HE-Tag: 1763831711-840012
X-HE-Meta: U2FsdGVkX1/TspIuOvsvr0F3rL+Qbe802h3izAc2CldWNgB9E/pmo08460XeAZ58bxLVa83YC2Bx4xMLhF9yA1HlrkW383znGoe9Tq+eqsyCP0MMvH0He8+l4W7v8Ev6l08gMcip3eP5s6Di8NWzDgnjhrdUn4cwPI8FUbE6VEfAqt3vIUPGFbeo5n5pLudelko268+v9twnsmBDKd/kf4xlAqEgU1rx8f6/JefV5/oXS3iHc4tVAUlbeJj9g+ACdLcWRTi+YMcezafVwMX4tso6h4jrk7Z9Xvr5/DdZyM5ZHiS70L+lMUFTVctdAINalZoiFutdsKpTRHTQZnnSXHNgjCOEc96H2hPdj8LBZxDGm5QtMOprzNyaRNhkCY2YuKpZ7/62F7NFWrwDOtH4dS5Epn6eogdUwdCHR3XlzMlkSIlIs8uV3Ws7vBluHo+2pSzpg6YYXWucaZIw5k9WkBGWSj5oCfKCsO+owxSeehre/Gx+CQ3rsMU0DoIxEufTdccg6C4JgSUyRbJ5ADVNshj0z0H4amD5715NzV3dgRya7ykmx+B78mQMnkYrZGaxeT6LpSdApW2OqdNdGJfNkdA/GNatXfLocSQkcOOeyXNpd5eWhWwtV8XcGBiFq9DeezDP3P7uJsTyInsCxxoJjYJdMFnnG0UkeeRkbnnLb1lk/lYaOQ0YzO4sssr+OKsJf287hhOQL7SEqhr+xXi+d/pEdrkTymm2tuHrtSEDdj8N2cX+4fjF6ck3xN6z0AveJ39OAz7xa4uRe53GN9KZ+PvEV6i0GogZQO++uUxRzMWsqeDHAIKp9sO8zPQKoBUoiilxfWJojqqQy45znKr+Al3NEHCoGuc1IzAfQIrdiQkPN7P2xHAni6RpZ5AnH4V6kp6aaXHeUv35bUYzYLRJRHOz6JSp06Fk+0CvzlIzsFZoON4/hseP2nzjrPTN8I81b0tDPyBev/7S2tYwxIj
 meu1l8dg
 nBIH4qf6NUqXyDT3zzKIX4neem3kARMYCWWxz5EwQ0Egmz4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-21 13:03, Andrew Morton wrote:
> On Thu, 20 Nov 2025 16:03:53 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> ...
>> It aims at fixing the per-mm RSS tracking which has become too
>> inaccurate for OOM killer purposes on large many-core systems [1].
> 
> Presentation nit: the info at [1] is rather well hidden until one reads
> the [2/2] changelog.  You might want to move that material into the
> [0/N] - after all, it's the entire point of the patchset.

Will do.

>> The hierarchical per-CPU counters propagate a sum approximation through
>> a N-way tree. When reaching the batch size, the carry is propagated
>> through a binary tree which consists of logN(nr_cpu_ids) levels. The
>> batch size for each level is twice the batch size of the prior level.
>> ...

> Looks very neat.

I'm glad you like the approach :) When looking at this problem, a
hierarchical tree approach seemed like a good candidate to solve the
general problem.

> 
> Have you identified other parts of the kernel which could use this?

I have not surveyed other possible users yet. At first glance, users
of the linux/percpu_counter.h percpu_counter_read_positive() may
be good candidates for the hierarchical tree. Here is a list:

lib/flex_proportions.c
157:		num = percpu_counter_read_positive(&pl->events);
158:		den = percpu_counter_read_positive(&p->events);

fs/file_table.c
88:	return percpu_counter_read_positive(&nr_files);

fs/ext4/balloc.c
627:	free_clusters  = percpu_counter_read_positive(fcc);
628:	dirty_clusters = percpu_counter_read_positive(dcc);

fs/ext4/ialloc.c
448:	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
450:	freec = percpu_counter_read_positive(&sbi->s_freeclusters_counter);
453:	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);

fs/ext4/extents_status.c
1682:	nr = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
1694:	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
1699:	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);

fs/ext4/inode.c
3091:		percpu_counter_read_positive(&sbi->s_freeclusters_counter);
3093:		percpu_counter_read_positive(&sbi->s_dirtyclusters_counter);

fs/btrfs/space-info.c
1028:	ordered = percpu_counter_read_positive(&fs_info->ordered_bytes) >> 1;
1029:	delalloc = percpu_counter_read_positive(&fs_info->delalloc_bytes);

fs/quota/dquot.c
808:	percpu_counter_read_positive(&dqstats.counter[DQST_FREE_DQUOTS]));

fs/ext2/balloc.c
1162:	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);

fs/ext2/ialloc.c
268:	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
270:	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
272:	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);

fs/jbd2/journal.c
1263:	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
1268:	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
1287:	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);

fs/xfs/xfs_ioctl.c
1149:		.allocino = percpu_counter_read_positive(&mp->m_icount),
1150:		.freeino  = percpu_counter_read_positive(&mp->m_ifree),

fs/xfs/xfs_mount.h
736:	return percpu_counter_read_positive(&mp->m_free[ctr].count);

fs/xfs/libxfs/xfs_ialloc.c
732:	    percpu_counter_read_positive(&args.mp->m_icount) + newlen >
1913:	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
1917:	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos

mm/util.c
965:	if (percpu_counter_read_positive(&vm_committed_as) < allowed)

drivers/md/dm-crypt.c
1734:			if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) +
2750:	 * Note, percpu_counter_read_positive() may over (and under) estimate
2754:	if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) >= dm_crypt_pages_per_client) &&

io_uring/io_uring.c
2502:	return percpu_counter_read_positive(&tctx->inflight);

include/linux/backing-dev.h
71:	return percpu_counter_read_positive(&wb->stat[item]);

include/net/sock.h
1435:	return percpu_counter_read_positive(sk->sk_prot->sockets_allocated);

include/net/dst_ops.h
48:	return percpu_counter_read_positive(&dst->pcpuc_entries);

There are probably other use-cases lurking out there. Anything
that requires sorting resources taken by objects used from many
CPUs concurrently in order to make decisions are good candidates.

The fact that the max inaccuracy is bounded means that we can perform
approximate comparisons in a fast path (which is enough if the values
to compare greatly vary), and only have to do the more expensive
"precise" comparison when values are close to each other and we
actually care about their relative order.

I'm thinking memory usage tracking, runtime usage (scheduler ?), cgroups
ressource accounting.

> 
>>   include/linux/percpu_counter_tree.h | 239 +++++++++++++++
>>   init/main.c                         |   2 +
>>   lib/Makefile                        |   1 +
>>   lib/percpu_counter_tree.c           | 443 ++++++++++++++++++++++++++++
>>   4 files changed, 685 insertions(+)
>>   create mode 100644 include/linux/percpu_counter_tree.h
>>   create mode 100644 lib/percpu_counter_tree.c
> 
> An in-kernel test suite would be great.  Like lib/*test*.c or
> tools/testing/.

I'll keep a note to port the tests from my userspace librseq
percpu counters feature branch to the kernel. I did not do it
initially because I wanted to see if the overall approach was
deemed interesting for the kernel.

>> +struct percpu_counter_tree {
>>...
>> +};
> 
> I find that understanding the data structure leads to understanding the
> code, so additional documentation for the various fields would be
> helpful.
Will do.

> 
>> +
>> +static inline
>> +int percpu_counter_tree_carry(int orig, int res, int inc, unsigned int bit_mask)
>> +{
>> ...
>> +}
>> +
>> +static inline
>> +void percpu_counter_tree_add(struct percpu_counter_tree *counter, int inc)
>> +{
>> ...
>> +}

(x86-64 asm below when expanding the inline functions into a real function)

00000000000006a0 <disasm_percpu_counter_tree_add>:
[...]
  6a4:   8b 4f 08                mov    0x8(%rdi),%ecx
  6a7:   48 8b 17                mov    (%rdi),%rdx
  6aa:   89 f0                   mov    %esi,%eax
  6ac:   65 0f c1 02             xadd   %eax,%gs:(%rdx)
  6b0:   41 89 c8                mov    %ecx,%r8d
  6b3:   8d 14 06                lea    (%rsi,%rax,1),%edx
  6b6:   41 f7 d8                neg    %r8d
  6b9:   85 f6                   test   %esi,%esi
  6bb:   78 18                   js     6d5 <disasm_percpu_counter_tree_add+0x35>
  6bd:   44 21 c6                and    %r8d,%esi
  6c0:   31 f0                   xor    %esi,%eax
  6c2:   31 d0                   xor    %edx,%eax
  6c4:   8d 14 31                lea    (%rcx,%rsi,1),%edx
  6c7:   85 c8                   test   %ecx,%eax
  6c9:   0f 45 f2                cmovne %edx,%esi
  6cc:   85 f6                   test   %esi,%esi
  6ce:   75 1d                   jne    6ed <disasm_percpu_counter_tree_add+0x4d>
  6d0:   e9 00 00 00 00          jmp    6d5 <disasm_percpu_counter_tree_add+0x35>
  6d5:   f7 de                   neg    %esi
  6d7:   44 21 c6                and    %r8d,%esi
  6da:   f7 de                   neg    %esi
  6dc:   31 f0                   xor    %esi,%eax
  6de:   31 d0                   xor    %edx,%eax
  6e0:   89 f2                   mov    %esi,%edx
  6e2:   29 ca                   sub    %ecx,%edx
  6e4:   85 c8                   test   %ecx,%eax
  6e6:   0f 45 f2                cmovne %edx,%esi
  6e9:   85 f6                   test   %esi,%esi
  6eb:   74 e3                   je     6d0 <disasm_percpu_counter_tree_add+0x30>
  6ed:   e9 ae fb ff ff          jmp    2a0 <percpu_counter_tree_add_slowpath>

>> +
>> +static inline
>> +int percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
>> +{
>> ...
>> +}

0000000000000710 <disasm_percpu_counter_tree_approximate_sum>:
[...]
  714:   48 8b 47 10             mov    0x10(%rdi),%rax
  718:   8b 10                   mov    (%rax),%edx
  71a:   8b 47 18                mov    0x18(%rdi),%eax
  71d:   01 d0                   add    %edx,%eax
  71f:   e9 00 00 00 00          jmp    724 <disasm_percpu_counter_tree_approximate_sum+0x14>

> 
> These are pretty large after all the nested inlining is expanded.  Are
> you sure that inlining them is the correct call?

percpu_counter_tree_add: 30 insn, 79 bytes
percpu_counter_tree_approximate_sum: 5 insn, 16 bytes

So I agree that inlining "add" may not be the right call there due
to the relatively large footprint of bitwise operations used to pick
the carry, and the fact that it contains a xadd which is ~9 cycles
on recent CPUs, so adding the overhead of a function call should not
be so significant.

Inlining "approximate_sum" seems to be the right call, because the
function is really small (16 bytes), and it only contains loads and
a "add", which are faster than a function call.

> 
> 
>> +#else	/* !CONFIG_SMP */
>> +
>>
>> ...
>>
>> +#include <linux/percpu_counter_tree.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/percpu.h>
>> +#include <linux/atomic.h>
>> +#include <linux/errno.h>
>> +#include <linux/slab.h>
>> +#include <linux/math.h>
>> +
>> +#define MAX_NR_LEVELS 5
>> +
>> +struct counter_config {
>> +	unsigned int nr_items;
>> +	unsigned char nr_levels;
>> +	unsigned char n_arity_order[MAX_NR_LEVELS];
>> +};
>> +
>> +/*
>> + * nr_items is the number of items in the tree for levels 1 to and
>> + * including the final level (approximate sum). It excludes the level 0
>> + * per-cpu counters.
>> + */
> 
> That's referring to counter_config.nr_items?  Comment appears to be
> misplaced.

Good point, I'll move it besides the "nr_items" field in counter_config.
I'll also document the other fields.

>>...
>> +	/* Batch size must be power of 2 */
>> +	if (!batch_size || (batch_size & (batch_size - 1)))
>> +		return -EINVAL;
> 
> It's a bug, yes?  Worth a WARN?

I'll add a WARN_ON().

>>...
> It would be nice to kerneldocify the exported API.

OK

> 
> Some fairly detailed words explaining the pros and cons of precise vs
> approximate would be helpful to people who are using this API.

Good point.

>> +int __init percpu_counter_tree_subsystem_init(void)
> 
> I'm not sure that the "subsystem_" adds any value.

The symbol "percpu_counter_tree_init()" is already taken
for initialization of individual counter trees, so I added
"subsystem" here do distinguish between the two symbols.
Looking at kernel bootup functions "subsystem_init" seems
to be used at least once:

1108:	acpi_subsystem_init();

> 
>> +{
>> +
>> +	nr_cpus_order = get_count_order(nr_cpu_ids);
> 
> Stray newline.

OK

Thanks for the review!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

