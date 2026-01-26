Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D8FD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE74F6B0089; Mon, 26 Jan 2026 11:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91EB6B008A; Mon, 26 Jan 2026 11:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56316B008C; Mon, 26 Jan 2026 11:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C384F6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:34:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66E2713B9E9
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:34:28 +0000 (UTC)
X-FDA: 84374663016.18.E84B430
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022075.outbound.protection.outlook.com [40.107.193.75])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49AE6C000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:34:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=XjZkvUdU;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.75 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769445265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKpJfrOjv8G2+ci4luxEuBN9ERD33ifLcjY7HlgzToI=;
	b=NwPjrEjXOMRLey7yggyyNEz6aaoi80SvU+qw8dZxEXEPBgwAVXDEMHNC+bwd87Uqw4DuuC
	iQP6rL8dvj85B9uBjdKejHVpcxvkbgEPzqSA9nTg7PVWA5YTgWVuDvraZVD/znFGBfh57J
	YL6QnQJaJlo1hkhQpfXlKPu0uWbFUZw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=XjZkvUdU;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.75 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769445265; a=rsa-sha256;
	cv=pass;
	b=iMjqlK2K+UJwzsW/rPMjZk3826KGn/+rLa3n8obWYLe98U/dYaJEsvx3IwuMVmDZbEE/Ip
	D24aYDNQUl+QNXC5G+TagjummtYO+CCXSs78TfR/W3JXKoa1SQqGY8Am9uF8eGnvkYk5ZJ
	2Co9DlXUNjOiUQqwCtjYwgPjv6KujX8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tR8YfN2H5g8ys4KBjGT2443etqCuWUVfFHN26PI1BUz0B83zJdEqgK8MshC2WNnVD1EQckBpYgUY+8ifJ7YZ83ew4rCiJR/gECiFhNO6YlU3gn4brMj3OCMnRTYSrX0SIdYiQ7SiVgySKvYnu+L+hhmn/ou7njtOBVHNmIcJUY1izvt4UtD9+JJz8ifFkuxomAOr3N02JB2t3lUg87WFriGCy8WTlHlpySklkKJK541ut7Uh9uMH6cdTX3uIUO7KDLDLmuc4zoz2SbJPQ5WaZi5KranffCG4esJZLpvd26cYwFfJ1fH4J7x6i1xN0bfVJ6vHpaHkycSfCZYal68U9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKpJfrOjv8G2+ci4luxEuBN9ERD33ifLcjY7HlgzToI=;
 b=EWcY11gOyLVGEAUPv7k3dz9fXTkUkxyZQdlm9+oNljMdOBmZHuc/n0xNrDzHhZaWAJ/k4DdfNh7PNUtJikFtXbiz4B8dtlnXn6699SKgcKzHZ8fvIDDLEhT9ECuTaBDDt5hyTe2fBxOR8yf2k8u3i3r/Sy2ckRb8wtrNldfX8WW9ltHlwL1OOQj519C4kpScfSD6AzNmumXerImwOLEJdQioiN42W/ltQ5W+NeEmVDyCi0ZO7qxlpa8m6pv8I1MEXYGUv8hUo7N39AmBB1Z/476LHEr0ytRshdydpXKIlgF+ksrGHwdrUFxWGUy09CWJSoR+dwJGVTB8tR7Ab3OJqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKpJfrOjv8G2+ci4luxEuBN9ERD33ifLcjY7HlgzToI=;
 b=XjZkvUdUYVLt0a0OEEdcK9IfJXM8kYGWkx++CUGk6RaKysJTznnzKjR7tD5BY0hB6TH3WaXShUHdejSp858Ukb02XdsZM9M4h6l0y4iUf9vA7sFmKq3Ax0IM7NxX4P/Rmn+Djde2j7CmSXOTkvVyjL1BCx/V/uo3BEsWrlryn/DG6wNR/TEYAC/E7znOmeQmcsu7hM7TxyQlvPtjbFaWa6OoTxVh5qVlv5iHRS17yZqj2to/nrZSmkuBHNbgFJWwRGB1F/tvg3lB+0cYM/qIdlG1JzQO3JrrzSUccMIAHY5DBwJYd1u+tZmCWxYIfQe3qKK46VjDePlKXxlbJxk1nQ==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB9040.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:5f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 16:34:21 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 16:34:20 +0000
Message-ID: <7fc3d243-18a5-49b2-81cf-8584b1493439@efficios.com>
Date: Mon, 26 Jan 2026 11:34:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 1/3] lib: Introduce hierarchical per-cpu counters
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
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
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-2-mathieu.desnoyers@efficios.com>
 <aWfHTLDA8-Fja_gD@tiehlicka>
 <67bdfd38-1acf-4b90-9e34-ce752632ddb1@efficios.com>
 <aWped4MIi5i0Y7-R@tiehlicka>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aWped4MIi5i0Y7-R@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0055.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::27) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB9040:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d4133a-5892-4b17-8c3a-08de5cf8c1d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3B5ZHl5aFN0czRuTmRuaDBQWFM0S1RpYTYydFFqNk9QbTdXb1Q5cWh4akM0?=
 =?utf-8?B?STFqZXc0WWZwblprSk9mVS9RQ3NoRmVoWFFFek1DOGZKazUvNS9LS2NKaDFB?=
 =?utf-8?B?ZjJQQXBFNWs5VEcrdXRCc3VJb0ZnUFlLRjJUUXloV2JwMWNDZVZmRVZNTm5t?=
 =?utf-8?B?dWZHWWRyS2I2anhaalVnZzZzTHRYY2tGdEthd0FFeGpTOHU1RWdEMGNCOVpB?=
 =?utf-8?B?UlJIYlJNRUhaYTFmbllzeVl2QkR6cUNid2wxSkdnOTNKclYvSUVPS0laMjFi?=
 =?utf-8?B?MmtkV2JVWlU4T2V1eEVFWUl1eU1hNmd0eDRSSmNKQXhmeE1ROGFBOVcvcFM0?=
 =?utf-8?B?K3ZIN1h4SHQyTjF4Ym5OMXhabm03cFBreXI0aEtQV2h3ME9FN2RHYkRSM09y?=
 =?utf-8?B?WCtzemJ1UVV4Y0l6K3RNTlU2TmJZOVBRTXhIb2NEUlNTeE5sUGVweHdpOHg5?=
 =?utf-8?B?Y3dwWU13L241bFk5MEZlbU5kMWQxbU5zWithNjJjSVdEellGTjBOWmNXcmZi?=
 =?utf-8?B?K3IvbkhrczZyU2FxTlpWOEV5eVdCQld0T3lZdk5ZbU9KNVdDR2haTmJ3OFJ4?=
 =?utf-8?B?WFc0U1djUkUxV0xFbEtRWHYvZ3M0R2ozUkwwUjYvU2Vtdnh2ZVhpb2JQbUJ0?=
 =?utf-8?B?aWJFRXQrT3llU1RVbWVKWGt0OThUUnBOVC9ZK3FYNElGQWZJaGZGQjNWYmJD?=
 =?utf-8?B?eVJ1RFlRTlI3akY5dkYrclpOdWdGNHZ3UEI2OTBSVklvTU1uSDBpOVlzRG1l?=
 =?utf-8?B?ZXlSVmJzdDBsdThvelU3YVRRYU5mbDkvUEJENVp0UnBUSUNCN0h3S0NYQTdv?=
 =?utf-8?B?ajNXUVc0WGE3VFJ5c1JKQ0ZuYjV1Z0ViaVZTV2pxcXFYTXE1WmRXZG9YWEtB?=
 =?utf-8?B?Q0N6czR4eHFmam0vem5IZ3dVeDc2dWJ1dHBObzZNN0wxNzdVeW9NSmlDMEhC?=
 =?utf-8?B?cEFjNlpDYU5VRjA1RHZjNSt5MmR0NWw4cTJiSy80SFlxRndlSEFIM21TdmEz?=
 =?utf-8?B?L3lhQ3JXdlR2Qk01aTRFWlIxSmpxcEJMbjVjOWRMa2N3Y3JlT2loQlhRM0RC?=
 =?utf-8?B?VXcreGVRejVRZ2szdkhUZ0N2TFhkSDN1WDBuQWV3cUhwWkVDd0VndWQ2YTZV?=
 =?utf-8?B?Nk41QzNZRDJ2d25lK3lhZWJqb1NmcWhJV3FLWm1GQ1g4bTcxcktMN3VuK0F3?=
 =?utf-8?B?WVNXQXduNHpLMXh3VDBGS3pqb09lRDZhS3JsRHhydjZTSnFWSXBCR0FWN1BQ?=
 =?utf-8?B?Z0N0VjdrMnowV3dnSmZhTE5hYW5ORTVlMG1TOHNJV0t5K0JKc2g3bVFnVHFV?=
 =?utf-8?B?MllnaHNqeUtMMXBqd3VRTmZobGVaZWhhUkZBVEhRMGVSS0JNTC9jZU50VEsr?=
 =?utf-8?B?YkgzQjd2K20zOXM1Qzg3Z09JUkE2WWlWWkhZN1JtWUI5andMT0kyb1ZyWDBS?=
 =?utf-8?B?am41K3dCMlZmUTF5OEJ4NW8vMzZOd0tPSEZHcEFqOVAyeG9oNmFtV1Z6eXZn?=
 =?utf-8?B?Q1VwaktkNFJpYm5MUzBnUUJVVndmZVplQ0xqQzF5Z2ZOMzBuQmJyMFh3aGg2?=
 =?utf-8?B?NWVpQTB3eEJMQmd6aXd5dDJpMHdwNkhqOXJ4V0NsRXhhSzhPbS81aThEOUI0?=
 =?utf-8?B?d1FzRm5UQ3NXVXFFMU9VVWkwWEpkTkRCU21ZOFZOazlSRzJlVXFZNC8vUTdK?=
 =?utf-8?B?T00zT1NUY0xxL0JMMmNJMTdqU1RIaXFkaldQaHhrbGt1TzdXdXBwUkFqYUd5?=
 =?utf-8?B?cGNnbnArOE8zbmxIb2h2MDZTOGJUVTdtVHhPVkNqN1lWQ0o1R1Q4OTI0UTBY?=
 =?utf-8?B?aWt4YWNBY1JQTUpydURQb3NMKzFYYlA4cEprUDZlTkllbUNNZ1lDUE9ieGNs?=
 =?utf-8?B?Sm5SZUZXM0VJNnFuWUdmVlZJMm8xOU9LSnhaVGVEZDN3eVVnUHJWRE5Dd0Jj?=
 =?utf-8?B?NFhPSFFRQ3NqTkp5RFF3eXI5NXVOY2NuSHdGSXp2VE1mZkhQSUlDd1FIa1Qy?=
 =?utf-8?B?bTZhc1FqM0xrYTh0cWlpTmhDcjJBbzMwRWVRKzlreHNvNCtNc2xrRERId25o?=
 =?utf-8?Q?hymwif?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUVraXZZdENMZzdqYzc4TmJVYnNITkVzUmRiTDdaY3E5TEtQb2N0S0lRdVFB?=
 =?utf-8?B?VDZXdWl4dW5GdndrditvWitHRFNiQTFoQmtRS0w1S01XcW9hSXdZOTdpK0xB?=
 =?utf-8?B?blk3eFlFejNLTE43Uy9RTkNuM1BhMmZ0Y3F6bTgyemIwWmtXZGFWNVd3Nms5?=
 =?utf-8?B?QUNwbEhOMUF5eWZaYkxybmFjZDRtRjNxYTFsMVoxVlkzWGduOERmWFRkMkhn?=
 =?utf-8?B?T054bDFGRWxjcGIzV1hTRll2RkhWait1TUhyYWJkYUllMkE0OU5IWGR4eHBk?=
 =?utf-8?B?TnVxUVlDTzJOcTBNOG5qcUg3a0VabkozZW9CSGFSUi94ODNORms4MGoxQlNm?=
 =?utf-8?B?MWpxeStUVGlHQUVId2ppWmxFeUpBMFROc25oOFI4M1BiNzlkK2RHTHdXYnE5?=
 =?utf-8?B?enNhUkFtOCs5UFVLY2M5NlpFV2FibkZHMmdvOEswRjF6TzJ4akJ4SE1CMVpK?=
 =?utf-8?B?aUtETXAyUzByMGpHNkxPWVFTcG9ab21WOFRvc05OeHFEeURFMHNCL293NzBs?=
 =?utf-8?B?MlZmalc2S1Fyc1E0WngyQnAyKzlsNGhkcnkvU0RueHl3aGl5VjNPRW9WekdQ?=
 =?utf-8?B?ZjFsaFhlaUNGdnJjcGx3K2VKR01jSkJqQWp1VER5Sk5ZdTBBZFVsaTBVNlFZ?=
 =?utf-8?B?bkR4Q1B4ME9oMFArRnVSZkU2SEtBN3RMcHZaeDVaQ2JDajJJVUV6M3YwZkhx?=
 =?utf-8?B?Z3ZtNnU5VkV5RUw5Z3RweUI4c1U0Vk5FSGE1Y1pwNlFHbExVQWdOL0M5YnpU?=
 =?utf-8?B?U3Uyb1NRUDNyQXI0RDhjcVRKMmIxcHowUHk3eGlFTU5vUTlCcFVqdHZCK3VS?=
 =?utf-8?B?a0U4dEdjYVdTcE9rbUJwb0VndVZYSHFVVTByOTlZYU01eWpCdW1QbEpqK1Z3?=
 =?utf-8?B?VEtOUG9IM0JCYjRZUVF4eEFnRU1ia1lUWkdYSTVXRyswRjBYOXNtNjFVR0c5?=
 =?utf-8?B?T29oeTJqZ3Z2VUtwc0QyVXlLNTV1dUZwYTdMN3R0LzhCNVhPS3lmbjc2MHBa?=
 =?utf-8?B?bWlIYm5CV0xDL09DTWZRODVzSkw2Q1A2bjFMdGM1cjRPbHVkRTFZTVBpbWdF?=
 =?utf-8?B?cUh4VGdwNkNKVEVuOXQ2YkFLeDFyOGRZWDgrMFlZVlhQRlFIY2lGMzh2bmJC?=
 =?utf-8?B?SlFZMnBIMkc1S1MyMS9NWC9mdEpvTlBMNE41bi9wOGVwczNiT0sxcGhXWUpE?=
 =?utf-8?B?OUxTNzJFUFJQUGtoYXhKQ1JjVU1BSUJtQkFZQ3ZLcGtEangzTlh6UUplM1JT?=
 =?utf-8?B?N3cvQ0tWNmFmbXR1WDBMNHlVOU9wUDZsbFlwZ2QvQ0VremYzT0hyR2g1MFo1?=
 =?utf-8?B?Rng4bHhFOThyV0xKMWl0Q2llclVSVXpsR3MxMmlMVDlWMG44aEMrbi83TU85?=
 =?utf-8?B?ZU1LSVlUZFBzK2NiclNsVkNOdyt6WXlwa25iRzRLZTR4bHM0V3NzK0NpdXlx?=
 =?utf-8?B?QmRRbjUzZGJES00rT0prd1FueFRNNVRiVjlPUllDVlpKN0dHV25EVUxzQm1H?=
 =?utf-8?B?dkduQkh4ZzFYT1VZcW9Ob2d5b21OeXRDRGVvNGVGdDlOTzhvZHhmRXJpR1JK?=
 =?utf-8?B?TkhwUDcxUVhUS0ZSZ2MrL2YrMnRIa0x1eDg3NGRmWlZlTDhwbW9Ub1RIeXVN?=
 =?utf-8?B?WHg1RUMwU1ZpdVdvYmlVdW5taFlPTVkzNG5ld1pDRU0zNkNyc3RTUC91cHFY?=
 =?utf-8?B?UGh2d2Y4Y1lwMU9Wa0U2L1VvaUdRa3hoOFNlend4ZDlsYnFRK2hNUjQxMllh?=
 =?utf-8?B?VXMxc3ZXLzJ3WG56OXZteVpxOEMxblJrNEk2TEFQcWJVN3pkaEZZcTE3Rjk1?=
 =?utf-8?B?UmU1L0d3WFhxMEs3WHNXTEttY3RRbGhFVCtuMGhGcWJ0Nkg2QzZnZ2o4dFE0?=
 =?utf-8?B?dkRzQVoyTjBOYlRHN2NrZ0xEZFUrVFpBRzlhTCs4TmduV0hFSGpGNU5oa3Ix?=
 =?utf-8?B?WU4ya2I1Z0ZDWXpEVU5LeGVBQjlUa3JOTFpSNDNPZDdLTkRURnlvdU1FQWxX?=
 =?utf-8?B?RHhnRTZmZjF5Z0FPeE44V2NadmVYSHlvbXJkcGt5ZklsNEdjRG9zWWxZM3VX?=
 =?utf-8?B?SU5vWHFqZGp1Y2FFdlgvM1NKWlo1MWI3UDFHZkRNcnFDeU1wSzQ3cjhvVzF6?=
 =?utf-8?B?dnRNKzFpdkNRQXo2T2NWSlA2RlRsZGtvQmR1RkRPc2pmVW4xYXFDdjZaUGRR?=
 =?utf-8?B?R0Vhbk14UzJEbjZBRW4rNVF4TUFza3U4KzA3cDE0OElKVXpkZ0dJWXNTRVNl?=
 =?utf-8?B?ZXovMDBmYmN3MVdraVVoQU5hWmNtUjhzQ1NuRlA3NUFGT0xLRmUyb1NWaGdH?=
 =?utf-8?B?eGIrdnBZcTJWaVhEYnJ4MVdMcEpDNnlpWnZiQmFzWXAybHVkVkhOdTVEQTVq?=
 =?utf-8?Q?QG+hE80loN+MlV1WyLsO1QG0q2lSdSRlGyCxS1jcyPQm6?=
X-MS-Exchange-AntiSpam-MessageData-1: PEZ4CMd3ruVog3Dvt7s0fHTC0Ev4aWl2k4U=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d4133a-5892-4b17-8c3a-08de5cf8c1d8
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 16:34:20.8590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sl9A/pCnCgsDJurOkJ0Apb2ms5iVwiMieTZh4PwszgO6GMd+zXVFhGRUHYOL/+xqOHZVEDO1BiqPXj8YiAFcRacp4BJ6SKOhT2I/Vp5QhE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB9040
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49AE6C000B
X-Stat-Signature: 7q97fkoeyxnceyhpq1adz7f5wpc1uqpd
X-Rspam-User: 
X-HE-Tag: 1769445265-105525
X-HE-Meta: U2FsdGVkX1+e/N9Ynf1vqfhydfTc1c+dBLsVEyqtXFjNl9kdMRxg9kVvJYJXlb6Gr3zvJXfm5HI0Hy/gZFa4RHwwK3G1i1IsavTPGbaykMnmhlT34NBO3LQ/OsRabqQFYrZ+WIV3Bl2bHcWmc9LZ/b3jh20Lg7C3TDTKle7NHmah4cQGQvw8suAwgXgIkyUf6jRqo/o+6DWY5bDdv2HKZDqHyyQ6H9OwZQbQe22olhE0efFDj/qh2t6jPBbqunO26bfVZvjf2VZWgaVMUxJ01l+GxOHJIB3xXKKetabvpA+zAob8m5WteDWv08c75Zu82aFG0EPDZGa2QI7z0wtd3+WggO1drXCfLEQ0rT3XP3hrAeTaNuvYR+p9rqFDwkd7FfVyOd8h/eotqqmlAWo7fEO3ciSb1EKT5sIF2TTQh/tgwR5NvryWLHyJtPQAxzSpVR8rdl4jidy4ZMLsczwYmu5PbiTKTUjrjpigfK/j5KppyhzAXh7ArSanc0BG0SBUMskvlMfot/4/hRt6xsLyuZ1tImnous9I9sd8fb/oSDrq+mxAIdB2Gd8Z+LVqZn/rf5geGuBZYGPR6wT5y+KTfMEwT0PLA5kKkp4zq3oRSRw5ZVojCGpfZt+W7O5m+XlTTZdv6Ny4Gzo34x1p+nf2FRBvlCl8zBp3GAsfopgweCE1e8+faixpgy7nwlGVKP5va0m63dtu8lH0nXbXmgCFsIBK65T5NZGqaVu2BFczlRQSX7j/0/B6qWhGTzMLfwxso4isN7qnKLNbsCS2MpGGm1TehB9k0IHKfMDu1c+qlyc6PPD3Xaq5VORLgjOKSMSv82HVRmI533FOC0d8KofbNM6lHGIk9xT901fSTw9MQRBhjQrUc8WMxjPGBAe4Rze+BBHmMTn0gws7z30Qoq5G9FglPt0v2G5L64nZbh/AUui9rvqDVzrYL3AVO398HbZsCrZd/aNX1jk//u3Mcsp
 Zaq3Nj0/
 A4Nw2dxnn4q2bNXFwlirER+cvy4H5GihucyeNwqoZ3IRHs0IIhLuT1aPhDBJN3rmxhU7zKurSqVdzlgw8+Gpcj741yXQsQ+sx2EluYr16+SWm/6MYS6KTzpVXgAlDqwGX8uboW/DmLtN4V2tt5FNB1gLnplk0pNqpJZKzBkQQsKYmK45uUvw7S7971EAFMMbHYiV+83Fe2F+tJ8gqwdurLq7edEYN6zkwjRrXvGAoxlviHTe0ZekCIqYEag9LGGySRNa7Cnl3T9VqeUo/s1igVsW+H7agahRmxdAP934/NsCp6CcNaV8783/2gxfCgr6WTkTPV0dINwWM2Ocwew8pZAl83P5T3E5PXDO1LYZfkeFN1jIkqjGSl1NxXYKvnr8SvGoIbG3ZWmI5pi+mmzPIsy+7j+YRVaYtnWoHgyLpCkCODSXUZEvcKbE/8upVkzCFJAI/GzE/QtAUbAhDPSsy4f1ANw4Cv8GCI2d12w49+FuC4LSdb4V6PvC1veMmj+M05nmKTuIFwJqzFNB/ORj9ghQm2w4APHpyylFcPMuOOBYRtJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-16 16:51, Michal Hocko wrote:
> On Wed 14-01-26 14:19:38, Mathieu Desnoyers wrote:
>> On 2026-01-14 11:41, Michal Hocko wrote:
>>>
>>> One thing you should probably mention here is the memory consumption of
>>> the structure.
>> Good point.
>>
>> The most important parts are the per-cpu counters and the tree items
>> which propagate the carry.
>>
>> In the proposed implementation, the per-cpu counters are allocated
>> within per-cpu data structures, so they end up using:
>>
>>    nr_possible_cpus * sizeof(unsigned long)
>>
>> In addition, the tree items are appended at the end of the mm_struct.
>> The size of those items is defined by the per_nr_cpu_order_config
>> table "nr_items" field.
>>
>> Each item is aligned on cacheline size (typically 64 bytes) to minimize
>> false sharing.
>>
>> Here is the footprint for a few nr_cpus on a 64-bit arch:
>>
>> nr_cpus     percpu counters (bytes)     nr_items       items size (bytes)     total (bytes)
>>    2                 16                     1                 64                    80
>>    4                 32                     3                192                   224
>>    8                 64                     7                448                   512
>>   64                 512                   21               1344                  1856
>> 128                1024                   21               1344                  2368
>> 256                2048                   37               2368                  4416
>> 512                4096                   73               4672                  8768
> 
> I assume this is nr_possible_cpus not NR_CPUS, right?

More precisely, this is nr_cpu_ids, at least for the nr_items.

percpu counters are effectively allocated for nr_possible_cpus, but we
need to allocate the internal items for nr_cpu_ids (based on the max
limits a cpumask would need). For the sake of keeping the table
easy to understand, I will use nr_cpu_ids for the first column.

I'll update the commit message.

> 
>> There are of course various trade offs we can make here. We can:
>>
>> * Increase the n-arity of the intermediate items to shrink the nr_items
>>    required for a given nr_cpus. This will increase contention of carry
>>    propagation across more cores.
>>
>> * Remove cacheline alignment of intermediate tree items. This will
>>    shrink the memory needed for tree items, but will increase false
>>    sharing.
>>
>> * Represent intermediate tree items on a byte rather than long.
>>    This further reduces the memory required for intermediate tree
>>    items, but further increases false sharing.
>>
>> * Represent per-cpu counters on bytes rather than long. This makes
>>    the "sum" operation trickier, because it needs to iterate on the
>>    intermediate carry propagation nodes as well and synchronize with
>>    ongoing "tree add" operations. It further reduces memory use.
>>
>> * Implement a custom strided allocator for intermediate items carry
>>    propagation bytes. This shares cachelines across different tree
>>    instances, keeping good locality. This ensures that all accesses
>>    from a given location in the machine topology touch the same
>>    cacheline for the various tree instances. This adds complexity,
>>    but provides compactness as well as minimal false-sharing.
>>
>> Compared to this, the upstream percpu counters use a 32-bit integer per-cpu
>> (4 bytes), and accumulate within a 64-bit global value.
>>
>> So yes, there is an extra memory footprint added by the current hpcc
>> implementation, but if it's an issue we have various options to consider
>> to reduce its footprint.
>>
>> Is it OK if I add this discussion to the commit message, or should it
>> be also added into the high level design doc within
>> Documentation/core-api/percpu-counter-tree.rst ?
> 
> I would mention them in both changelog and the documentation.
> 

OK, will do for v17.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

