Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA7ACF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 00:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFB46B0005; Mon, 12 Jan 2026 19:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D576B0088; Mon, 12 Jan 2026 19:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224B46B008A; Mon, 12 Jan 2026 19:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD006B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:48:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A414813C869
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:48:07 +0000 (UTC)
X-FDA: 84325103814.25.5EDF6E3
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020141.outbound.protection.outlook.com [52.101.191.141])
	by imf09.hostedemail.com (Postfix) with ESMTP id B236F140006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:48:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=SA5uPuv7;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.141 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768265284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0ieFFsNB7uzF7Xm/plNrnw+g9/JvHG2MmMoTVwkPV0=;
	b=FVxmdhX7iq9aCmFMf9/H6ASlT9Zps3e08BHgxF/+r6850JJRIQ3/GtfQD7mAJDADJMpNKR
	ZByUU7XwkqwzAR8jP+B9Z2bc+wVwtd7iYAe6Jb9x+KsLqgv8UJhIwq8dp60R+fqMNzuXFv
	zLj/yUVjfKoG1ouGLV4P6e+bA+pXpZ4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=SA5uPuv7;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.141 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768265284; a=rsa-sha256;
	cv=pass;
	b=pIAAJ4kISQJAHfU7qChIZ3CtpkCaKugJE+nNgkU5aQ8SsLU6MjurLwsnrk79CsQVH2/djA
	P95JEq/htKC75DPcoyR99sXhe/LFjtGYcpdesiKBG0v76djj9UHEWsNhPp3VsU1T/R5hKd
	YgDL1gYH0WEPoIaMidPNUf2Mj88PcQg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYChZ98ttX8ktMEK2M3JAte17xwfAd5F7oM3ToHYDTAlbnhrQn4fxgYXGpF5Ul5s9Az3ezCMKbDgfVfBqVsSf5pq8jI7qPnSaJGWxO9+6wPcsBufiquXzxO5GRyYwVNiB3D5GexS2hHBfhflVcctOZK8qmNHUQmTh/AB/rKA1F+ynSdjImVPQ38Mw+o8GCUeec2Q3H9ZnNPvzWeEv1pEVsE0LCS0aP+8oZWDMAETwP/VHvkIFaylQi7SJYSVahyUAwGnp7exuRncAKQIKg7+da6Ga9cf6ipKEgudpyMB+YDVhqw6QVit8Vb7HdlNVlvqEr16qT7PCZrZJnIxlwWjjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0ieFFsNB7uzF7Xm/plNrnw+g9/JvHG2MmMoTVwkPV0=;
 b=guhwtdkssyDiHOkOYLxUETnh9okeU0LJ47YR4xuz1lltHIE1OsqEwtJRQAbZyqHgzLNyQYU/kdqmJ/7EnSqQZ7coNXS+SSh9OrJx1BG4dzJZBb4v/XQKw7gKeDaI/gsJt4Je+ooLw6YHsXp6YhcbNoXD0k6Cj9IRB+pkijWoq71DLI86SzzFbbX0W0X98SqppzRxIfsUFD6lLhvM+vfVgkjoB0lvtlJDwSpL0sXkblETfI66RdaQ/JeFp5XalKTgjTDUuHbskwpeEKK8cTKd1SYP8hTfYVIk3ttKKZLfR5qT6vKNz8Sh8tHpCdR3948+MZeVI7FaF5uQBCZT2JcxkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0ieFFsNB7uzF7Xm/plNrnw+g9/JvHG2MmMoTVwkPV0=;
 b=SA5uPuv7XiuOdBtF4AZwdJr3ycFI3o7v650aJLB/DfJN58wKZkQGVn9vyrM//UHVhqKT2ZuupFSKTkzk+0km0fTqGXxDTjnuOIItpAEGxbMb6fexm5Rm/G9L7xBp7sB6Z/tC1SkUo8hZ8Iajkx9fj32yTexZgOJduDR/PDkDzkpE5ZPmGeXv+m+MVdR2C8HeYA+cP1sd38sCOhoHWXlLFpPAWwYObr3LCTfaLZ19NhH67tocP5kix1YhsSHTm/NQUGWKbPkTHVr4tpghxmE8dMeIvBFe5wmAGeXKyduLWjc7tQC7+Cq1U8bRxr/+fHG81I7WozlytyHGFCDF37iywA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by TO1PPF59B1BD8AD.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b08::648) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 00:48:01 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.008; Tue, 13 Jan 2026
 00:48:01 +0000
Message-ID: <b779c646-64c7-49f8-8847-8819227e3f1f@efficios.com>
Date: Mon, 12 Jan 2026 19:47:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 2/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
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
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
 <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
 <aWSz5OHBwtfYrruu@tiehlicka>
 <f2c04264-17ca-418f-bc43-e8aa6fa6cd0d@efficios.com>
 <aWVP9sPqG8VC8Oq_@tiehlicka>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aWVP9sPqG8VC8Oq_@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0011.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::24) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|TO1PPF59B1BD8AD:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cd7730b-bf28-4cd0-cc1f-08de523d66f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVNCZWxacWZISHdRekNJbWsrRzJaeXhua0h3UFRKcllGaDhmMmkySTJiTGxN?=
 =?utf-8?B?L1hCOGRxcVhwL21GL2VlcUtGOWhBRXlKUlFCVzBPc1ZGVC9BNUFCMTZtQTlv?=
 =?utf-8?B?eWxhMkhpSFh0TTFUaDlWRWJFRHhMQ0hEMkkrNVdPUUxRL1FGeVZkamM5dnY2?=
 =?utf-8?B?blJDUjlYSlNaSnlMbXQ0R1drdXdTeHpzS0pzMVAxRG5MZ1dmSk1XRHRNRkV4?=
 =?utf-8?B?WmJUUHAvcVdWcUtLN2hkNlRZSGJTTDZVL3JpUi9nMGpseGtTWXhxN0tHWFd1?=
 =?utf-8?B?b29JYzhuMzZUckw2QnNxV2M2ZzFtd0FsVVFvSzB0emdqWnZ1MzcyMVNUMlVn?=
 =?utf-8?B?UTk1UTQ4YWk4YVk1WTVpcHJZb0ZPWG1USnNYOEM1YTg3U012eGdxN1FtNHd2?=
 =?utf-8?B?TmtoOEdmMnE3WVdYS3Z1OThuaTZ0T1NuVCtSNXhFVEZrcDBBbE5jandXV21w?=
 =?utf-8?B?YmN4Z2dyZEQvQno3amdQV1RzVFZlOUN3VXVOczNCL1IvQ0FxQWpubExJN21X?=
 =?utf-8?B?V1o5alkxSzBJNHpKOFZFUkVzTy9KTVd6M0o4dC9sSngwQTZ6YXh6a2lxYVR3?=
 =?utf-8?B?enNzRHgxUkJRREI5ZHVVUlVvb3NBVXViZ0FQN04yVTBJZGdUdkwwZXNVSlp4?=
 =?utf-8?B?UkQ1RWpRWG1pT1J2dGFKZ09lNlY1STVkK1VZL2JqYk4xdTdxZlVGLzcvVU1m?=
 =?utf-8?B?MElsUGRrQWdEc2psUFhVeGNTdG5KTmVTYnEwSVRLQUwwTGJIQXkyaTNud3lM?=
 =?utf-8?B?NXJIankybTY2OTB1bzI2WFdJcFZmcUREa0I3aGMrcVFsK2YwUnVaNXdic2ts?=
 =?utf-8?B?T2VHQ2g5bm0wb2VHOUpnZmQwS1dEb2ZVR1laMWwxQkV3alF5MnIwdFBMTksz?=
 =?utf-8?B?RVZ0bDhtV2xPQVVPVlJDeC9ic1RjT0NhRHZNZnhiUWZHdGM2cGVrOTRhSzhX?=
 =?utf-8?B?MS9IQTZHRTJTVWFZWFZBVWlSRDBaUUNoUWtSREx5eE9ML0txakxJTXcyd3lN?=
 =?utf-8?B?ZmZPOGM3MTlJQ3RZZGxJRzUvM0NVc1Q4ZWdNd0FxWmsvTkQrakMrUDFUWVBn?=
 =?utf-8?B?TCtwK0pQWTliZXFuWU9Yb1Rtdnh4MnRmTlpHRStQOS9ZeXlBRW1ZdlF5WERh?=
 =?utf-8?B?cmlnODlkdzR2aFVsbmRiMXlQOEdyeEVBNndkMDNacjMzK2ptYVdtQUtKWElj?=
 =?utf-8?B?ZDZabVZ2dWRkc0oyZVJZZmd4czBaQVVJTC9Md0tSaWk0WHhyYjIycm5WeDdD?=
 =?utf-8?B?dkNyT3NLa3FjYnR6ekkzV0hKRkQvYWxFRXRyM0M0RjFJUjdteUtBWnhMUTBC?=
 =?utf-8?B?eDZmN0Z2L2FPUGN2dXAzQWR5L0lhSGJNZ0lDQ1ZycnBQRlRzWThZbVovRng2?=
 =?utf-8?B?OURtcDNLM1k0KytOc0pZN1hGZ2Z5TUN4NHNWSVY2UzI5d0hXS1pYdURFYVBL?=
 =?utf-8?B?ZWh5UkZYQXRrVnN6R2FOdFpYSmdSaWhnaTBVc2JmTUJOa0JIOWpsOU10dDdH?=
 =?utf-8?B?Y0RSWjVQTFltaU5pSHU3bXliZDhsZ1E1YVV0UXRnVDkxMG1YdjRwY1dHaEta?=
 =?utf-8?B?cEFoZGNLQnJsN2s0OUtNYTdUTkJYbkk3ejJMakNGeGJqcEI0NXNoNWgwaUsx?=
 =?utf-8?B?TjdpamYzSTVlVjR2ek83VW82S25BemltcTFpMW0xdGloWTFaQUV5MzhpQkdR?=
 =?utf-8?B?MEFZZ0cvVVlMVWNtQmdCUklxYVBrZFY5T0xtRGdjeGJYV25xQkIrNGVKNGFw?=
 =?utf-8?B?dFU4d3RENEpieUFleUtVWGFpWisrVThyYUdTREIxTFNtYWlETG5xRmcrdndJ?=
 =?utf-8?B?bTlDUzZUdXRCeGJVRWJVd1hJRHd3a3RCelB3VE9GbFhGdzVFS0pxbCtjSmZ2?=
 =?utf-8?B?UERwL2toYkZyVmJZZnJDVEZleUk4NmxJaFY2L1dKOGU2Smc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0pRZ2I4QWZwYVg4NVo2QkZLaVl3TGs5RVkvOERUQ2R3V3IrUlFJZGF3UHdq?=
 =?utf-8?B?OEZaK2l4NXppWG54QXY2QnAvVHBDSHRURjlobWZIUUwxVTlWZHBGb21BWFlo?=
 =?utf-8?B?U0Q3YXo3YjgzVWo4ZXRJd2hXWXpwWUZOOXBqZTd3aUZuVFU4Qk85RTJsd1pa?=
 =?utf-8?B?elBMQk1Lc0V5aE1Kc0JLd0FVWXYxaDhzdUF1ZW9OQk1JbWpPWUV4TUZFdHll?=
 =?utf-8?B?V2JVM2l3TEUrZFVyWlZCY0J4YlhXbExZNzM4cWFOeWF2SHJRTWdqYlU5RkVB?=
 =?utf-8?B?ekRUbUxJMzJ0OEpidlBheGd2R3ZvYmh2a201eXR2Yk10bmFPeEU1ekt4clh5?=
 =?utf-8?B?ajRyVTMySmdIYVZDc3cvaGN5dkxVQ3czRCtsTndPd21TaVFRRWd2WFZweU5l?=
 =?utf-8?B?d1p2NHVMc05vZjJkQzNmbHRBZDB1S0swam1SUjRBQURvaTA0WG5JQTBKYXo0?=
 =?utf-8?B?RmdTWmlmT2VSWTF6VkxJSEM3eFBRdVM3SFRlb29HSm00alI5LzVNMm14RW05?=
 =?utf-8?B?V3locDRqNkV1TnJPZmtZeDhNYUJwbTVRT3VjQStjT2tNZzJKdkVlMGU4bDc3?=
 =?utf-8?B?Q1ZyL0loSlRwTzY0OUZCWnVkem1ZSEZsWXI0STcxcHZDMW9yVnBhdkpJOXgr?=
 =?utf-8?B?QjlDUXJtM1RCL015TG5kL1hleGZxc1pLbHpzOC9LcDNjd1dpREVoRTRZZnEy?=
 =?utf-8?B?TnJuTnpIUGoyZmpqV1VhbHJyVnJXVUdSbjN1ODZpOHFib0VVcTF5QnFFSTVQ?=
 =?utf-8?B?SG1vdjVWais0UVZZYzJJelJRa3lzc2FrMy92dUVKaVNpalFuR0luamF3RXBx?=
 =?utf-8?B?VEVPWmx5YVYxMVRSUi9GL2RVMHZHMFhTSXNDUVByMUlndDA1ck9USDB1YnNW?=
 =?utf-8?B?YzZMb2ZuTVkwRm1ycEM1K2FoWlY4ZUpPejdjaUViQUx2Tm5JR1hHcjdlcWx3?=
 =?utf-8?B?SjN5ZjFrODNnSkpDaFBQcHplWFNvR1IwL3QxdWdWb0RhNlozWUNxcHZtNk1J?=
 =?utf-8?B?dTdBbi9qTU54MDB4eGRDa2VmaVBrRUpBWUJkSHlSMThyMjJIYmtiK0RQeFVP?=
 =?utf-8?B?KzNXSlRobEVETHZuNVdiSG4xK0N4WkticG53QVRJMEkrUlVvalkzR1MyUVBv?=
 =?utf-8?B?UE5iMFJOWUMrSzRFWE5yZXFQUWRwdDVrRG9RVlpUMWozK2ZVVlRZZWttSXVK?=
 =?utf-8?B?VXAveHpvbXFDcnhwN0pKdlZaZmRJM3BIMU9RVUEzK0xHakxlazI0K21maHFq?=
 =?utf-8?B?cjVHbzZQeGhYYjJTS2pqYmp5MjFFZE1tUUNZb3F6NWVlYm9tdU5zazdzQ2JI?=
 =?utf-8?B?MkE4SGdIWmYzS1ROdjkyNHY0QWRlcnVVdDRTV0F3RmVRaUtCOTljZzVtWkM5?=
 =?utf-8?B?NExYbDYvWWYzYVNIQ3JZZjhMMzZJdklxTTdaRElaSGhMWjNjdStYSFpzQ1Rt?=
 =?utf-8?B?djBybTNuU0QvZEovelZuekVXNTNnMHlURHJmWDNGS25scTNIVlczVHRFMXo0?=
 =?utf-8?B?TllXRnFTQzdYdzBRekQ5VS9NQmJyRnp3TWxTeDFFdFJwZGV0NjFVcG5SdS9K?=
 =?utf-8?B?b1NWWERBcXZqOStwZGEzK1Y0ZnA1clA1eXp0VjloMVBoVnhqVnQ0bzFrNUJj?=
 =?utf-8?B?OEJ1SGcrckpKK05aVlAvQjFycE1OK2J5NW5EZDVnQmc0SjhLTHhtanE4RjE2?=
 =?utf-8?B?Q2NxclhGRWd4c2JwTDhSZWVMeVhzSkJjUkRBZ0JuN0FpWkJhSzhQQUlsSXpU?=
 =?utf-8?B?OFAzM3dNUU5UaDZodTFXUyt2SEEyb2ptdklZTGRVOFZUSHJ1UEhZZU1LOUc2?=
 =?utf-8?B?WUJVS1BPTUxiRS80WkVIdWN2akVYbGVkRExEOC9mall3U01mUHByQjdjNUlq?=
 =?utf-8?B?THZGVVNCZVEyM3l1MndxdkdtNGliQTdGWGp4SVBURzNSZjhONUw5S0pxOEdC?=
 =?utf-8?B?V1BkU28wUURzbXI3MFRSYXNFeXFTYXU5V1ZvU0VtSDVKa0hhZ0tJb1FlZTBa?=
 =?utf-8?B?WklscVp0R2ZSeWhwWnZKOXZWN3A5UGUraFFyZ21qYS9ydHhTMVBlOWhqcS9F?=
 =?utf-8?B?djZmOTJSRG03ZzF2M3Y0R0FuODRTb1FXdTNzWEN1MXhtTnZoWG81QjNib1dQ?=
 =?utf-8?B?aUp4RDZnekFaQVAvTnpoTy9zMzZIZ3ZiV2MwZ0t5UE82Q2tYRGgweFlEN0Yy?=
 =?utf-8?B?bVBpOTZxK1RUaHZ5YmRaaUVXcmF4ajh0bTZNS1IrazV3U3dsWWhTOHFuaUNY?=
 =?utf-8?B?d1Y0d2ZiQ2dmK3gwd3F4cGZyeW1HUERKZnVhUmhrRWFUUFlTK1hja0FkQXRH?=
 =?utf-8?B?Und6NUkzb3Z0aE5WZDAwTTd1Zjl0dmhNcWlZWHNhNnhjZml0a3k1RExKNkxv?=
 =?utf-8?Q?FyLhkBuyA0J1wE0bL3HVvX5I+GAEUSj5pQLJve9nX/Y4y?=
X-MS-Exchange-AntiSpam-MessageData-1: LiJT3Tzhnpn/lzj5W4jKc79lyr1wCCNIcUU=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd7730b-bf28-4cd0-cc1f-08de523d66f0
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 00:48:00.9109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rsz8fpHCPkqDuOg6cNSSKS+UsCqSBK5wGddPgpPiLeK9yeWOgqmWaqoUSfXHhVjIaSycvbVOc3v5Hwe1VPitz1yw18uFUz7D+XfYmA/c5Hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TO1PPF59B1BD8AD
X-Rspamd-Queue-Id: B236F140006
X-Stat-Signature: paasn8wdwoerp8cz517w8nwqwwa9i79d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768265284-316946
X-HE-Meta: U2FsdGVkX1/lyV34X/bu7JJD8j2vrcJOWKXkbgwqLx/Vbic5tcT2r6qtRVnLAJZEbt4l+RfQyT+2SV/qtIJ0iEdkfDuXhAgS05C5NPRa6vM2V9rwXlpT/MpnVtIKUQsK6nIZY22Wy3Lr8RDgszk4FUU2GPvYWoI9Z0o3gMoewHHviAD8olvdGKzi+tOstsYsVnKCnIla9Gsna+ha8iYAbfXtc0EN0icBic6RG6pi4pNdJerF9EiBXfZYNcErJ6ReJ4NG15cYLRtm+8qIfZRPeoYfUftzUc+MNMMv7yUwMD3cfGo0J9V2V3N4ViL9ilNlC7VHTcG4Gc0zCxQ5vCCvY2BdA1AqYQhaJuxvR6OUCQnzNut852/RAjhP4Vxzg8hIJqGrpL8AkIdCgWt17NsNxjHsAStcbGOIhWRqcv2BDqSBp7oChD56/b41dggi4E7zfRWeO9VUfxS8oRFUqvPQlHNLVF9qHFlwExeWqkV5vrdLaURyQMYDtIS9aCeRRqdZ2iH/rqs8efevnAtXaQuu+02cheHsn2bR49AyBUQgPP/A5eoFhkiY4sOjnxEOI+g53+qiG8VGGJWFH8LlvRsvSlmjm/WNcxF/guBOMcfzk8TTOHeep4hDL3XcWakz7S1zg3MuAdf7+j+0vnoSLPzTGRs1gD03szwd18kYTUjrC32dpgZasTubBnmv/cX8ptC04Wh4vzotxAPgNT1PBGWYt6QLL8yjsm3lzufKb1X/+4eelJnsg4UDuIjQ1nQIom/qUKI929ZWqQaScun/pAJk0/Oxf/K7ff6MAAk3pI13DgbwN6XvhfOfNnz3jNEaeI+oAp2oUj4KEnxit2lSQgKjWCshlOsMtk2OmRXLTeyKUriygEUwc9RWCXUxQo6YO5VP3ypBqTzGLw7piof3N9X5q67b+478EAJwU/4Z3GWbidyoIKheMRlYpNa1vv9W4+SW5jzNec478Y1rejqVUIF
 +aJ6gtpP
 OR6fN4vM8hwDGsGf0I65Iia8xKT8C4m+5nna9qslmbfg/bLxnRlxt6zmMZM5OeAedGuoyANqxwlkI8UwawJzff9PILMUU5SzAjGtYB9Yu2pYwLPINW6Pi/Tz3G7tNftpZl8O8Lx8HvdtgML6saOFhC5aRemN6ubcpRivREki64NR7RpsmV1cg5u7q7ZNrGzbig8gp13WJPruMOoK33sgQls6JaIqCql/+hTCzkKjegNYsb47L2R3bg3V9JrlUKkXwKI4tsJZxb4tq/UjOwdAHU5qgQF8R7hDESCH2D1NZcevqdgNsBsztn92K9XTG5W7JPa3tdaxTdgLFZ92Z1WgK5iHi2EqT4QY4qmclX3iCNMwKfjH6m/XyhWhE9spuzusyw6TLsypZcsheniwQyTN+e/xKcJ5vJOidSjbwORr3cuit0jZns/Ue2SHsnxcMHz4SJta6B0SBozVu3tLiCyFI3L8rHHhLnHWRABbA98T4sMfAxiMeWR1b+g9NSVQpxRuWvBO/JprYRmr5io9gswroTOaowg5jd+x4mHQRP68Qtvd7IxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-12 14:48, Michal Hocko wrote:
> On Mon 12-01-26 14:37:49, Mathieu Desnoyers wrote:
>> On 2026-01-12 03:42, Michal Hocko wrote:
>>> Hi,
>>> sorry to jump in this late but the timing of previous versions didn't
>>> really work well for me.
>>>
>>> On Sun 11-01-26 14:49:57, Mathieu Desnoyers wrote:
>>> [...]
>>>> Here is a (possibly incomplete) list of the prior approaches that were
>>>> used or proposed, along with their downside:
>>>>
>>>> 1) Per-thread rss tracking: large error on many-thread processes.
>>>>
>>>> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>>>>      increased system time in make test workloads [1]. Moreover, the
>>>>      inaccuracy increases with O(n^2) with the number of CPUs.
>>>>
>>>> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>>>>      error is high with systems that have lots of NUMA nodes (32 times
>>>>      the number of NUMA nodes).
>>>>
>>>> The approach proposed here is to replace this by the hierarchical
>>>> per-cpu counters, which bounds the inaccuracy based on the system
>>>> topology with O(N*logN).
>>>
>>> The concept of hierarchical pcp counter is interesting and I am
>>> definitely not opposed if there are more users that would benefit.
>>>
>>>   From the OOM POV, IIUC the primary problem is that get_mm_counter
>>> (percpu_counter_read_positive) is too imprecise on systems when the task
>>> is moving around a large number of cpus. In the list of alternative
>>> solutions I do not see percpu_counter_sum_positive to be mentioned.
>>> oom_badness() is a really slow path and taking the slow path to
>>> calculate a much more precise value seems acceptable. Have you
>>> considered that option?
>> I must admit I assumed that since there was already a mechanism in place
>> to ensure it's not necessary to sum per-cpu counters when the oom killer
>> is trying to select tasks, it must be because this
>>
>>    O(nr_possible_cpus * nr_processes)
>>
>> operation must be too slow for the oom killer requirements.
>>
>> AFAIU, the oom killer is executed when the memory allocator fails to
>> allocate memory, which can be within code paths which need to progress
>> eventually. So even though it's a slow path compared to the allocator
>> fast path, there must be at least _some_ expectations about it
>> completing within a decent amount of time. What would that ballpark be ?
> 
> I do not think we have ever promissed more than the oom killer will try
> to unlock the system blocked on memory shortage.
> 
>> To give an order of magnitude, I've tried modifying the upstream
>> oom killer to use percpu_counter_sum_positive and compared it to
>> the hierarchical approach:
>>
>> AMD EPYC 9654 96-Core (2 sockets)
>> Within a KVM, configured with 256 logical cpus.
>>
>>                     nr_processes=40    nr_processes=10000
>> Counter sum:            0.4 ms             81.0 ms
>> HPCC with 2-pass:       0.3 ms              9.3 ms
> 
> These are peanuts for the global oom situations. We have had situations
> when soft lockup detector triggered because of the process tree
> traversal so adding 100ms is not really critical.
> 
>> So as we scale up the number of processes on large SMP systems,
>> the latency caused by the oom killer task selection greatly
>> increases with the counter sums compared with the hierarchical
>> approach.
> 
> Yes, I am not really questioning the hierarchical approach will perform
> much better but I am thinking of a good enough solution and calculating
> the number might be just that stop gap solution (that would be also
> suitable for stable tree backports). I am not ruling out improving on
> top of that by a more clever solution like your hierarchical counters
> approach. Especially if there are more benefits from that elsewhere.
> 

Would you be OK with introducing changes in the following order ?

1) Fix the OOM killer inaccuracy by using counter sum (iteration on all
    cpu counters) in task selection. This may slow down the oom killer,
    but would at least fix its current inaccuracy issues. This could be
    backported to stable kernels.

2) Introduce the hierarchical percpu counters on top, as a oom killer
    task selection performance optimization (reduce latency of oom kill).

This way, (2) becomes purely a performance optimization, so it's easy
to bissect and revert if it causes issues.

I agree that bringing a fix along with a performance optimization within
a single commit makes it hard to backport to stable, and tricky to
revert if it causes problems.

As for finding other users of the hpcc, I have ideas, but not so much
time available to try them out, as I'm pretty much doing this in my
spare time.

One possibility I see would be to track memory access patterns by
sampling with page fault handlers for NUMA locality tracking.
Using hierarchical counters could help make quick migration decisions
(either task migration or moving memory pages across NUMA nodes)
based on hpcc approximations, including using intermediate counters
within the tree levels.

Another category of use-cases would be tracking resource limits
(e.g. cgroups, network traffic control) through HPCC, and then
using approximated counter values to validate whether the current
usage goes beyond the limit threshold.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

