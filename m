Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B299D78794
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE7C6B00CC; Fri, 19 Dec 2025 11:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED64E6B00D0; Fri, 19 Dec 2025 11:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1496B00D1; Fri, 19 Dec 2025 11:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8BAD6B00CC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:01:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 885FA13154
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:01:23 +0000 (UTC)
X-FDA: 84236685246.15.FCD23AF
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021132.outbound.protection.outlook.com [40.107.192.132])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57A7C2001F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:01:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=SoEjjNIa;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.132 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766160080; a=rsa-sha256;
	cv=pass;
	b=RhL2erGHFGjCuF40FnNXPZy2m+7W3wH7Rw29tQDiR3pLO8cnnHC0RyP/IOS3uCUHxLKJ5Q
	5FMKWolMXHobELp2Qv9E+qptoWmVFSIxZ3qkNWsEF2v+DuNF0xgZAKXHVFPuekzGjPwNyh
	j+FZGF4U6Psj2lBRwfog3bDfqZM+bdM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=SoEjjNIa;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.132 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766160080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8W80Yoet3gfGdJZ3GhSr3gXbtXMDGOGzbi8dcyryx0=;
	b=B76MFHVC4+dpC1Z7YAaJFSfwrhFFsAC5PdgCBVjVq+15fcbvTHLnHzZCxNj6Q0BZcQhKt/
	kzZSweMFPRFJbKAS07Zey8IVogc62HRoDlyep2pFM3xjrQhx+HFYwsA/gZ7o+HGFIkTRNi
	nUEgLb11YCfHDNIknrRP9Q2lHJjLkaQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrccJLFScMEA3VR3cnlwYWIlLuC70BnggOS1lIYiy8YLVloKPAI8+RqVnItx4NCflFSFKJzEpghP/UCWTDBpMfE/R+5/VWIyxp7cIqm7MS5/O0IoKJwsoBVr3dqo7xb2Kp1MBYjuLHx1j3Z4E9mFQw1/az5+4LCNmTSXtuekh1Rx9jHIuRAgDk7DcBlbdw8pHVpPGQngKNsr/ogG3hzwj7vNROc0hUn0psm4RJ561qaoQasyK+tHWGjG1N6AHKnNbHVKGJFd5dMJyBkJ5a7z6IiIfQM7NWolaoV0qX/822NxBXDhh1VxGXnafvfZXX5DWdXCPWS0x9nvwVFWMt2MmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8W80Yoet3gfGdJZ3GhSr3gXbtXMDGOGzbi8dcyryx0=;
 b=o/uv8nGYe8XrUH5Zvw14ejBCECScQB9Pk14Ponf2SkAUQT8tkn0hfzYsMtsXh6O42b4bNAxgZMP+yOoPHBnL9sPab6mxDEPpkkPQY+u7+Qh/Q4aoIQLDvL5DZL/FOVp6WEqA0ac/9YJTTMo0w0bvYJ+fXLGmZk5HvsjkiWf4LfblPmeSh6gszBgKEv2uNeyZNM3+1J26u4Nf7eOBjH3R3Qr3oC5Yeti2pZfcaYWS+X7TqJVvbUzQeTvuCsgmfvV+5TY8nGqldg/pH+MD2QM0yPLbNeserylZR0I9cgA3aSodZ7xIbE9fUCOh3+Wb2g2kL4gYgch3tAycZFcpvhiFaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8W80Yoet3gfGdJZ3GhSr3gXbtXMDGOGzbi8dcyryx0=;
 b=SoEjjNIaoY3mGFkS9H/2QYAAUJDl3fD/AHyRdv6HJrrCN0MfIVoNnDwfK2lNcAjdi0hw0YXekRRGduR9HHLwr1iH5uClKg9KZdeiLdgl3yx7/us9HlXlo+RgQo21CwZqHgNqg52JDLlpGIGZNIk7GWU6azPIzY7oimHMrxWSSoaOuHJO1PfobUbkeA+vh755ai/Qi0MV+nq8TvUJMdGAmOjmrnP8HLdDDS7Xpzxz0re0+/Kfagj9L3rresYjfUc4JjrgZ4Nd0g24Y3+TG8BJgx3c5Z+m3+VHgFFMKhEuuOd/vHPwyExGQZcMsuD5T8X6GXGqzDgyEol7lmj0jRSwNg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR01MB10916.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:97::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:01:14 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 16:01:14 +0000
Message-ID: <2fb78e41-5e56-425f-925f-a29524355d2c@efficios.com>
Date: Fri, 19 Dec 2025 11:01:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
To: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
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
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20251213185608.3418096-1-mathieu.desnoyers@efficios.com>
 <20251213185608.3418096-3-mathieu.desnoyers@efficios.com>
 <c8acf650-ef96-4449-ba85-557dedba0ffc@sirena.org.uk>
 <72ad1fed-574e-4850-beac-91626e5aaa0e@efficios.com>
 <2a772584-2269-4008-809a-6123e226ebe3@sirena.org.uk>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <2a772584-2269-4008-809a-6123e226ebe3@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0276.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR01MB10916:EE_
X-MS-Office365-Filtering-Correlation-Id: 49d14bcf-f76d-4d52-31ce-08de3f17d59d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0FvVnczY0ZkTmo5OG45MjRqdkNFTFo1VCtHZlVnK3FpRkdjVmZBZU94ZWpK?=
 =?utf-8?B?VUlRaGhQOTE1eU0yWnhIN1pvWGZCOVJOWndLRHMxckJvYStRcGFTcDUrN2pn?=
 =?utf-8?B?Q28vYWpOSTBwa2x1VE42cTRjUXk2MGlnSFF4Ni83WlhyVlJRNW5DQzJ5NmZ5?=
 =?utf-8?B?aklTSkk5bWx4V01DT3FBUWlLZ0RZcEFuZzF2VlI2RVJObGFzcVRHRUNsODVT?=
 =?utf-8?B?SXdaaFBLOEQ5NTUvTGRVTmVVK1lwSkpLNmZyQlhueVI0MnNpMjYzTjlyTHZ0?=
 =?utf-8?B?QzBJbDBUSzNhMkZuV213MnMvZmJ5WWFjRUNOMzFjZWo3cVpwNXVDenBGdmJ5?=
 =?utf-8?B?akR5amZCeGcyVm5ZUFA1NzhYRHZBd3FRK0hSM3VlVk03cjA0MzNQb0ZkdmMw?=
 =?utf-8?B?VVNYSllXQzF4cHl4V2V1OXhVeG9vaklyNVBoTzZIdFNsZEVlK282QmdwVThL?=
 =?utf-8?B?dmRBbGdpc0pDR3ZDdjkydEt5QXZlclR1dnRTNE50M202bTl0bk5xaCsyYStm?=
 =?utf-8?B?TVYva3l0Q2w5TzM4YUI1WThaUzdOdjFMMzF3UFNSeHlyVU9zbi9aNkxsNGFR?=
 =?utf-8?B?OWFoZDhWSkNjc3dHeCtWLzljR1orUmY2TXZvbHIwRm1hOWhJaTVNcFI3SCs4?=
 =?utf-8?B?YUF3TDdsME1WbkJjZFlMSjVycVlvTk54QlErMjZRY2ZobFNBTXA4c2tkQjlU?=
 =?utf-8?B?U0ZsdVBwYXo5VkY4N1M0L0FHNUxENnIwZmtZbmRsN25KL3MzNEE5T3dqYnhN?=
 =?utf-8?B?cy9LdmJjeTIzU2t5RnRsZlBqVFdXVFhJTUV1RkF1UkNhK01BcGoxU0w0Uk16?=
 =?utf-8?B?dlR0V1p0Z3dEdExjYXhEUnBkUnh0K3h3U0I2VmpienJnelI3bXZ1aWs1MkQ3?=
 =?utf-8?B?eFhSKzFVeWNCeFFlU1JaL1dXajNXT09kZS9yUXo4R1Vzb1Z3bzdjWlUxY1l6?=
 =?utf-8?B?ZmRjVzRkV0xwdmd6eXhnSTBmWjZBRWZqUGdmaWk0K0ZNQlFaclh0YVNlVGY5?=
 =?utf-8?B?dVJWZXZ0SGNwTFRVV0lGejlybTArWnVrdyt5NHVEaU1GYzYxS3dYT0RMRkZx?=
 =?utf-8?B?SVBoUXFYSURNWVRTRFFUUU9GZXBaUVZzK29hUWlPcHVNWlRSRjcvN3c5T1dL?=
 =?utf-8?B?T2lveG1SdkRZL3craFJQUUx0eE9CWHI3NE9HRFllQXY3dW5xT2dON2Q0L0Uw?=
 =?utf-8?B?Q0F6elJINUZhcDB3d1dqZFJTb1Jabi85TWxwamN3L0Fmcy9VRHJETUFuTXo1?=
 =?utf-8?B?L1RNN0F6Y3N1YW1QbDBXM2QzS1V4SW1JVk92RGU5RTA4R3JpMUVLYmNJNVUw?=
 =?utf-8?B?dHd0cFVscEhqVUlNYVpPbDl2azV3NldQOUdMcXpEZkFmNkNSeWdpSEg1MmhU?=
 =?utf-8?B?MHBqNWNYV2loOVJ0cGltL0Q2TTUwTFNlUy9LK3M2YUM5RjRoTTR0aUdkOGxj?=
 =?utf-8?B?Wng1ZVI3OUY1TFVsb0pwaFVrN2sxSEZmbVpoaVYwOFQza3lSZ0Z4cCtacy9Q?=
 =?utf-8?B?K1pJY2dLbjhXbTNtOEpTOXk1eWI0Tkl5eWloekxtNWMrOHhKTitJUUhIUk5y?=
 =?utf-8?B?RU14TDZIbHFIOU5YTStWZUFUaENtWUpCUSs5T29laC8zT0ZPU0YwT2VCd0Nn?=
 =?utf-8?B?U09aWHRadVZYN0VqbFBxNURpWVpESlpBSzRUVEsyemNoZE1URHBkOFk5N1NL?=
 =?utf-8?B?YmNYYWk2Znh3cUp3dUd6YU12TTVjMmVQcHpKT0Vsazh4NCtNRWFWOEJNUVBU?=
 =?utf-8?B?RzZEUEM3K3RJZXhsTE51ZzMrdFVibTlrZ3RyRzYwUGZ5dlFOSFZ1N2w2U3pD?=
 =?utf-8?B?ekNWRmtZa1B4UFpUcVowQnQ5YnRHTFcrKzFOTFYybmI2cFpXWjFRUkdLWlpo?=
 =?utf-8?B?RDFuRzh2U3lJbkhodVpoSXU1RjUxZ1EwT2ZMbkcxYkFLTVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2duTjgrcjY5cWkyMnZQQkR1bEl6NmRoMEpEbHlMcGFITnU2RWhBZ2VIQ013?=
 =?utf-8?B?UldOY25pRGFLMlJDOU5GcURGYkFkMTZiNUJXbWNza05LVHI4OFVGZm9yVjN6?=
 =?utf-8?B?Ukw0T3pmVkM5TFFhU0hjQnZmMERUd21veEt4ZG9FS2JpbEMyWXBoU2RFMGRv?=
 =?utf-8?B?T1pkNDRKSUhPbTRIdVBnWDNKa0d1dHRabzFBcThiMjR5VkR5UmV2VlFkNGdF?=
 =?utf-8?B?eHZ6dG5XaXFublkrTTVaTzBEaFZjamdPMzlNTkUwLzFvUEJwWEJ0VEhBZVUy?=
 =?utf-8?B?UHN4cWlENW9kemhuUFNyVzVsSGlnMlJyQkEreXZZMStJc0I1QWl6SWMvTHNT?=
 =?utf-8?B?dVZ3eE9wUVRRaWJKdC9qb2xvR2lyVFV2aVJ1OXJqbEZndVF3YS9uUHlUZi91?=
 =?utf-8?B?M2llZThhTDRNWmY0bjNLTExwaU5KcERkd0NXRzZUNzFReUN1SE5Wdm9Qd0Ev?=
 =?utf-8?B?dkxFeDZRaEkzcTNTTy80T1pidXN3Z0Jwc1JJdG5kVGNrakZ1dDE1bzM0dEg3?=
 =?utf-8?B?ajMvUlU2aG80ajIwbDR3Y2hrL3NicHRjRTY1VmxCTkg0UnI0NjgvY3llZWhI?=
 =?utf-8?B?Nk9GZEVGR3dreGhzMEtvSGw1Q256UjhuM3ZXcTZKRmlQMHFFTThEN01Zd1gy?=
 =?utf-8?B?alhNb3p5TUlVNE9NVmpqRDdkWUZzU01nL1hVa0tvcnNSSE85Q2NnckxvaS9P?=
 =?utf-8?B?NkdzRWZlZVdySHRydkNyMi81Wmw1MHZ4ZFVZVFgydGhVdTFkQzQ1Qm9lNWw1?=
 =?utf-8?B?YWxKNVA1b2ZRTHRvYytoTlZBa0ZlUVpLTXNRWmRMMllTaVlqU2NLeXlRL2Jo?=
 =?utf-8?B?OS9FUnNVVXJqaThmb29FSUFrODRSRENZUGRaTjVnN0trRlVGT2JrbzFHRVhx?=
 =?utf-8?B?Qy90aHdManY4empwYVhtM0NXbVJvOEtwdENXdFJ3WDNoTzNPRzZyLzFQN3kx?=
 =?utf-8?B?d0QvUVd4aW8yT3ZqbVlhOXZmakdLcjArZ3N4RGdoTzhma3JqNThxSnBWNVkv?=
 =?utf-8?B?QmE3RWtPdys1b3lnVDdqSjNFUlkzdEJ0UWNBWWZuaWMyN0QxbmxKaTdjWFY4?=
 =?utf-8?B?QmIzRTJtS3lKSVNhbGhyQTAvalJ4eXVQTmdKNmU3OUhVeDJ1SStSTkwvOU1G?=
 =?utf-8?B?bVppWVVHUHBFd1NPYXI2aHRkbDN1dllvL3BCUUo1ays2Q3VZTzNvemk5Q0dN?=
 =?utf-8?B?RXJGLzdHdHpuSytJSytEVVNPOTZab3FsMkZETzcwVzM4SzVMMzBHM2wrNmVS?=
 =?utf-8?B?R1ZoQ1ZqeDhHVzM5UWhvcDFkdmRmYU5BK0VxMFZqNUdXc0lJYjduNnhUZThG?=
 =?utf-8?B?NjA2bTJBVndEazB3VGYxSVpKZEtjTmlqNUJMUWJHUUJReEcyd1lXR09sR3dq?=
 =?utf-8?B?U1RNUVFKV2RhWjJ4ano5K0RTVnlEYWpwYXEyTFU1U1JBTGdzVUlNS0NHV3Nh?=
 =?utf-8?B?RmFtbkFlQ29aa1IwZ0xnZjI4R3pHQjZHNmNSYzJJVDdlQnNTU2Y2anVyZEIz?=
 =?utf-8?B?NW5jZ2RPZ0tPb0l4V1pMNVltMGcybzR0UW5nb1lQRmEwOXZSdlNNckFCcXFi?=
 =?utf-8?B?VVhSbElsWmRBd2FSZGNUQ3V1RUhMNUVuY1VzVGFRMmg1L2tiL2ZrWHVnWGE5?=
 =?utf-8?B?WHhNUEZrUTBiSW9ZMWdlQysvOW1mbHJDT2d1RWlneXZCaURielhnelRXam9I?=
 =?utf-8?B?anY4aC9BdjRQMnlqOWR4TkFIRGRjbGVzODUxUk9xTldSUXNORjNqeUp4eWpi?=
 =?utf-8?B?VU1wZG02M2hQV2tKT1NzUlpuMCtuMVpwQkplNFpWeUdQcXlTSFVCYndHb2Y1?=
 =?utf-8?B?VkhrOXBBUnlSS29UeitCK24zZ01lZ2JNWFJGd3haZ0xtdkZDMnBjYzNzazhm?=
 =?utf-8?B?WldYU2tRWTB1a3pkV21SV3A3OVVzcU4wS1Q0VTUrc0FaVzZrV1dBZ0FqTXN1?=
 =?utf-8?B?SFBBM1gzVHZTZ0tOQkM1ZHJzd0pRSVdBOUk0ZTZqVXR4NXE2OEV0S2RuVjJ1?=
 =?utf-8?B?WHJPcC9xUGdvcEZYTmkwNnhtWlc5UkR2dHp5TTV4TVE1c0FMZU5zNzB0OFRx?=
 =?utf-8?B?VjhibExWWXdqUkhWT0x2UGRQbGZBM0RkdU1GejBPbGhJVXlQRFR2aDNObjEw?=
 =?utf-8?B?K0JmdDRSRG9CWFVIeU9KSUZla1BMb0NBY0JnRDNDWWFPK0Z3aGFNK1gweVY2?=
 =?utf-8?B?emF3RVdzeFdHZHFQTytyTVpUM2RXbzF2QTIzK3BETHR5aHc1RFkzY1QvSmVs?=
 =?utf-8?B?MFVaMnRXNjBQc1hjNzlTR1dJalVFRlp6cjdrMFJLRUdxWU1BSEZVakprU21L?=
 =?utf-8?B?aWNkQWh3WXdjL1VBRTFPMmNGOUdONTdDVlVKQWhqN0tqOEFlOXlFa2VLZVlX?=
 =?utf-8?Q?oNsyw5fW1zHOM/9Y=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d14bcf-f76d-4d52-31ce-08de3f17d59d
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:01:14.3053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7mvW5HGJx/t3oY0g4UvTuUr7F1RMWDXVfADN3EyP0FvGKRTuSCrVlAXm3rhchgSTCu8NFi40PLu0k6YOmUaHCAC7k2CoonQ19vi4CKs1MA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR01MB10916
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 57A7C2001F
X-Stat-Signature: i5cciktgrbtfq6whrinyx7ttcrtnzju3
X-Rspam-User: 
X-HE-Tag: 1766160080-248411
X-HE-Meta: U2FsdGVkX1+4Anu+k6sRnNjaTflPnuv2izpAeWsXu3jrHHyEExjtut/WzMwomjnRqeNUKiIzI+eisMVgAq8NvhSfUpABRG3wbAj++D7vDLRu89UFKEvkB6Luayu0qoS4aa6ddg6DavXd8L7SdmLdxI4Qvkw92HRELEQ5ct3f/VCS48tJeS0EPzAs8GJfmBtCfJjgAqw5Zx+/Q8ssXWJ0geEMUl/CFgdsmBXY91+akZGvXRXUKG7nfXGFvenlt1F1PzzlV7tYv9rGtGSR8BFBa8pnxDAU67U4++CZ4iAzH4bTJSb/yQyxOXtAjmcVMP5OFGRci77RfNkGz73zkn0ywOgxKm0EcpwLOfe0eu+c8CT2ow6uvxOlUfa+byTAXAosHqyz2oo0hc08Chr0UcrRanHx1aNBvsBQKP6vLiYRSbplHiIqhLRVYME/MSlb+QP411un3srW3pVhJsIi4VZDkXg+q5Ujw/LUJL5g1OQWDQ4FE6HiJjj5lJSf1KhuQ3uREfxw22da6/9K7h6kccMZmgkvyxr0aZinbiTRHrmVt9yk/y3Gwk9p05Ud9LH4itozI+1g7rl/F4JeUHv1S+njA80E2UljMXFKONq5Ez0mbHp9W7Lru/ZpF9lwVKrjH/qRKBWfTQBdhEpUf9aADsx6VSaPjrSYqAgSmDwWOi1Du/nyu7C0mU7hjMaueoZZoo9BAc5lbHmbpXnXwyQBvQXFZcrz2ZBLrNva3AZNOgvLGPxI9w4LrCdTWS3kNjdklR1iWuSn7gqb2rdlNMkDbphT3xLiAIbCXyXF7lF5D3i8CXhWWCL41HUwqCpLh4YLqkDlZLa5dWadIytD5CNC0lGsv8roVBAlmK5Wbf1RXFJHcAmwQUli93ut4PAUpX3C30+DbcqsaUm/v4/BrHS74ZwZGmiyx3dCk5gxHBJK1QGxdpXLHIMVefRn3cFo4CElchINpJWTxnXvnXc9dFxNj/o
 ryL1nlf3
 zHUij+AkJJHCWDgv9S0P1RhOYWfW9BRuG6mWnbcMu6AVNVQdoaJKE7aQOWL3a+npsYJNuc4JF5KxtC/pEyZvckfq+20J3lEzMgnJNuLVjyBjcFcKGp4vGtwHeY9shPoRDP5jAHzA40VDHiCk0ZEQXV1XRfgCpzDJRSu2SiNAJsixwUcnUBJnaeLti2J9bPUy0M+t6rrd4QVawE7wgEfIu8jRw7Eor5U1MEhp8cwLo5znqVog3bHxQMyeeKfUJQG48dRPGENloTPvraI9kvT0xxUwE3rH+tPqTi0YJmBZf7ipRWIXsBQ5KNYohugjhAOVnmyPaHJ1hzCXLDtHLltKK/AZg9d0GYbuEKymTnZ6MEftS0TGAjKOC9V1mgvXTjHi+q/LigNM77IBZ/HNZsaJ8k/QRsQOxreaJb+Txrl/jakr8Sxi1sjUgB/amF9znLBaP4eYc9BfriR30srvMDr09uIRWXkdDJMK2BReyKpIxGUWEy7nc2EC2ZymPObZLA27Q9efp+8MEAXs21M77p0gIP09fGITMmRI6nIId0JmQ8vvLDJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-19 04:31, Mark Brown wrote:
> On Thu, Dec 18, 2025 at 05:18:04PM -0500, Mathieu Desnoyers wrote:
>> On 2025-12-18 13:00, Mark Brown wrote:
> 
>> An ugly work-around that may work (and then we can improve on this),
>> at the end of mm/init-mm.c:init_mm (completely untested):
> 
>>         .cpu_bitmap     = { [0 ... ((3*BITS_TO_LONGS(NR_CPUS))-1 + ((69905 * NR_MM_COUNTERS * 64) / BYTES_PER_LONG))] = 0UL },
> 
> That doesn't seem to fix the FVP unfortunately (BYTES_PER_LONG doesn't
> exist, but even just deleting the division entirely fails in the same
> way).

I just noticed that there is another static instance of mm_struct:

drivers/firmware/efi/efi.c struct mm_struct efi_mm

we need to apply the same fix to it as well. It seems to fit
with the currently running task when the oops happens:

[    2.482454] CPU: 2 UID: 0 PID: 12 Comm: kworker/u32:0 Not tainted 6.19.0-rc1-next-20251218 #1 PREEMPT
[    2.482609] Workqueue: efi_rts_wq efi_call_rts

[...]
[    2.485094]  acct_account_cputime+0x40/0xa4 (P)
[...]
[    2.487172]  el1h_64_irq+0x6c/0x70
[...]
[    2.487853]  __efi_rt_asm_wrapper+0x50/0x74

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

