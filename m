Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF56ED711C8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9446B0088; Thu, 18 Dec 2025 18:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597056B0089; Thu, 18 Dec 2025 18:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444356B008A; Thu, 18 Dec 2025 18:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32E736B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:36:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA32AB891E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:36:09 +0000 (UTC)
X-FDA: 84234202458.23.BEF22B2
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022116.outbound.protection.outlook.com [40.107.193.116])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5EE2A000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:36:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=HFW+Brpg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.116 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766100967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PCdDFmJmzK+B5YoAbidctFCthdh1hm21JhB660LEUk=;
	b=4hkK69tF/IkpHxECu2Pz/DX9m+ojhBgrI32RrsyKnxJBtduWAAOfzGTOUg+ajoMNW2gjVN
	YqzZO9oO9fTjZ/+c5zQ0jSf5+b0erZOLmZ73PdqeUQYpcGV/TrSljI6Fn1hNeVXv4pjdWa
	W7ns5oE0JcGfK9i7oAy9AoOVXXXFsSc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=HFW+Brpg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.116 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766100967; a=rsa-sha256;
	cv=pass;
	b=j+SVlqAjGz7nJILZrPULKJ0+TMB+lpw7T+4SWC75vvLNx66zTK/ThD3skvRMfrC3xc5CS4
	oztuQS2QVJAjsiRK+vX/+KWCZ3es7dMCxTf8IwyrgB6Y42ttH+bdr+Svc6uXIaIOCgcXJ+
	lymxo7XLdOlPesmZJ5MfuNXNZdhY7jE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFscxMoK4R9JE9wlj0TPjah38dPt045wTm5lqmHK6m0uBbjA0raZARQoz/1LfrcqChnZlDzLx46/r0Z0BQr0FeaB4hmEE+mjNoOc0RFdtsCmuBG8qvgpfWAIZdSVUGKqZXJ3IiQOFOee+f4NNxCEJDH6kFtenPnOwoY/wkgM1V8/Ifju+O0o+hEgDjUDHMSnxd9j+VtYPBuQay+yuHX0LSWuED701+w4ujb3RavNpU/gCSevTYaP5d2ftO2xXb+3Q8wxS/AjLBS9IL5ULb8A3c3C7h7DUvT7ZPSqS2oOW9ZnpwnYMazNePUQBG+S6ylsn2ro6dBc1oSiv5NxV7jJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PCdDFmJmzK+B5YoAbidctFCthdh1hm21JhB660LEUk=;
 b=OST25t8FrskX5zT4RaO67ikgeLQ2yvchQvQPO7JK2aXBffDhBwo8MvsdLWRSmwoUJGkrCH9b3ajVTPN99EQDaHWHyQlvwIwAIrN736GcJU82yvFKSH35gIsmwnEg5OK2T5UWRZWlM0e4FsTI5xr0bTdGim5D47AtkB9F0A7HNS8diaw5DkEHjsDEIhluc9LXKTTccxxU9pB9pWoJU3C6e40LAKJCW9A8LNqHUG80A70pi5jC5TdZFpBFOsc2A+98hYVDMR8U2ZxNRBWtEJgfXJZIutyALbLSe/yvMlYBt3um+iUqmUwj861CBvT8VZgk7owBlt1IxE11VFiyI/MUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PCdDFmJmzK+B5YoAbidctFCthdh1hm21JhB660LEUk=;
 b=HFW+BrpgyyVzqb0+FW4TSYFca6uK8sCBdrDlx60Nnn12wFUq3vm+0LiZaaFHxjan4flpsAOpSIvtHLO/ymWETvTlFXjSAYUMvclZW5a0NUqoUYRNTLT6btnb0FIY/ydBXy3nzu3w3xZTT51fs6FrFgBZ6gbPMougo8t8tn28oCJlLqQsxfGK7E8BVXvL9Y1eqwDrWqAdV4vhJcK49rMc7OKMWvcVKQdVX2pNmoLS79W9wBxD4NFqVYC9i+MtGp/N7xWuaZ8LztIkSj7DLojqOMqd/xJoPyH4vWiZE+uTcJPyJtD2l83bcX5oE+6ElUnMiR1cGCmbdjzYg+QlQ7I7LA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PR01MB8411.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 23:36:03 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 23:36:03 +0000
Message-ID: <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
Date: Thu, 18 Dec 2025 18:36:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aURihbmjsKi8m7MO@tardis-2.local>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aURihbmjsKi8m7MO@tardis-2.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0159.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::17) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PR01MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fcb0d7d-40c4-4a5d-8653-08de3e8e34f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWFKTnZMVldZZWVIMjZZTzJzdTRvRTFHNGdEY2JkVHBKTEJZWkMyVWo4Mzg5?=
 =?utf-8?B?ZXlVT3o0OXhGRnUvb2NPYis1Nnp4djFtK1RCMmJNR3VObkdTR1Y5NzhReUlm?=
 =?utf-8?B?K2RXZ1EyQUpLQml5TlJpMnNWVUdRNDlsRDBUSGZNcCsyRGd1NC90RjFqRnFt?=
 =?utf-8?B?SWZNRE9hZCtYclpVOWdVRVVtNVlGZnpxcThGSmN5SXJtT240Z04vMzA5YlpX?=
 =?utf-8?B?QXc3UFcvNEo1MGdhVVFxeFU3ZDBOMmhZKyswb05haVd6TFlCUS9YYkNBNm8z?=
 =?utf-8?B?ZnF5U0NFa3pPaUhtMVQ0ajdqcEZKQ2dVZ3dyZXczaytub25OdUc2THNMdHd2?=
 =?utf-8?B?aWxGakw3OEpBTTBrc0tDc1p1Vk5oYU1vcWI2NDZGc1BjWE5Wcjl2bDgzTU5k?=
 =?utf-8?B?TjJlQjRIVXVUU3JDQ0xiMFV6WGlmM2FCbUFVZStpUUtST2RPNmE5eDFMSkRp?=
 =?utf-8?B?ak1iQ3k3SkZRS3ZOdUxUWXlVV05PU2xCcC9pZEt4QldGRHNwU0xuVk1SSEYy?=
 =?utf-8?B?ZzNxUmRkQjJIUCtFTVd1Vlo5THN4NXJSdmlnR2taMDlLR3ltbnNESGR3aXNw?=
 =?utf-8?B?ejlpNzBBRTFxNTgzcXJWSUJDb0d4RTN3YlhqZ0lRN3dQWGl6YndEa2dSS2NL?=
 =?utf-8?B?WWpiSFFRdjFqaTBWRk9memh1UUxMczVlN0lidFA0Q2svZFZ0NHZFSXYzeE1h?=
 =?utf-8?B?azMxMkJZUVlJcXFvb1JqTmtjblB0NGxRUlFDVitSSjR3VmlmVGZ4RWxCTDJJ?=
 =?utf-8?B?a3Q2bGtjOHMyalVpalFKb3FkNURVdjFYajNITEsyV3JreWQ5SkMwRjF6N2hV?=
 =?utf-8?B?SEs5bm9mQStRWXcxQ1M0QTFVSm51YWxHbXJ6ek8rKzRiMzhqMHh5aHV5MXU5?=
 =?utf-8?B?Wkc5SlVVWUV3T2doNVpvd1kvc01SMXJ4azZQYUpuYjA3TERDOHZxbStvdm5s?=
 =?utf-8?B?aDFDZVo0aElaL2R2S01PdnFYdDBMN2QwT25oMmUxWThwa3pVK2h0bGd2RHo2?=
 =?utf-8?B?NWRLclNwRis5VDE2TTBxV1dYNUF2YjdrNXJlK0N4aU5YMmczTWRPaDBKQzUr?=
 =?utf-8?B?QWVEMHByTEZ2QXV1QlJHYWlVZ2w4TXJ1dHRscVNwc2JrUDZqYVhmR1BHL2pi?=
 =?utf-8?B?dTNkdk8wYWUremNWdHhJWG1abUhOOXhxVEhOdTE2N3NLM3doSkpyWlRQbUZR?=
 =?utf-8?B?ZzNHS1dDRktSSHZ1bzlGZlpLZGZwZmYwdjlkYklWNFhHdit1UG81cW1xMnRW?=
 =?utf-8?B?eXpoM2JBUEs4VHBTNzIxK01qZkJZeXhPMHhBQ3BsdEhiMHNzaXp4SmFaOEU5?=
 =?utf-8?B?NXJVcEQxcjRaYkJBZ1A3dS9HS2M0b3ozenRaeHpoWWV2MCt6MUIrelAzVmtD?=
 =?utf-8?B?ak00OWNJQytQNW1ZOWY2bkQ5aWFzeUtPUyt1c1VpMFpiVVIxNzZzK25kUito?=
 =?utf-8?B?Tk5WaEJCS3VESjFkZ1VrMDl2OGdsUzJUMFR3ZkcvWjhldm9lZzNSdmxMYlhz?=
 =?utf-8?B?UG1IOXVybDd0eThBU3ZKV0IxdjlpcTdBdlo2aFJrL3BueVowYnQ0UkdSSVZI?=
 =?utf-8?B?dE9CaFdiTDZ3aWJUTFZLalM2ejI4aE9JMFpUamlOTlhrT3pZWUJzcUZhMEN1?=
 =?utf-8?B?WloxSEFCOGxBT3ZPL3RXNEtkUkZaZ3BnZjJ6WXZBeDNIR3hPYzhyK2h6TFl3?=
 =?utf-8?B?QnRpRVdSVklMZER4azFWVTg2MnRKT1d4TEdqbE9sT0R3V3c1Z2Jtc3BoYnRy?=
 =?utf-8?B?VUhVQnNyeERHOE9kWXFFUlFueEMxY1lCTzhXVURrdXZHWEdpckRUZVoxdVly?=
 =?utf-8?B?YnZ6SW13ckdmMVk5ZDg5bHRmU2FBWTIwY3N2amFreDZhNzh4VTYxVndWcEkz?=
 =?utf-8?Q?pEjFLjarwwlty?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmdvRVZMZ1JCK2hjV1lDRUhvb1AxdWVIWW0xSmxUb093YVZkcWYxSGUxT0I2?=
 =?utf-8?B?eitsd2Jyb0lrYnVqa3A4d1FUU2JGZjJkYUduZ3Z1NE1YNm5qRDVJZG1UaGsv?=
 =?utf-8?B?M3Q5OVd2dndVZUcyMGwySE9hYTNBU1YrRlpCOU1PbFI5ZVQvQ0hvcTV6QnMw?=
 =?utf-8?B?Zld5NU9IVnhyWnZvN0E4NDBRVi9FOHQxd28zeE9JSkZYNGE1ZHVLQjBHQWhy?=
 =?utf-8?B?d1BwN2l1KzBCTkxJV0xSbURMNldOYjdMYWIrVzdUWXhwUHpST3JOM1lCd0Z4?=
 =?utf-8?B?L2tIR3lhN2NUd1Nwb1lmN25PV0dYMG5FaDhtTjVYLzd5ajMzZXBaUnR0cGds?=
 =?utf-8?B?bEV2eDRaSWVJZ0VmeWlUSWlkMkJJcnRxbG9PdWpSR01pRmY3ckFTdWpja1RP?=
 =?utf-8?B?V1V4Uk45Nk0xaE9xSG8rUE1ySXdiWjdidjZLNnUxSnFpQkVES2dwOUY4Y0l5?=
 =?utf-8?B?TVF4RGJBQUFaRWxsY1RWYTV2UmRmUk1PQ2lNbVM0eS9PYXFhUzdrMkFGSFpE?=
 =?utf-8?B?RTRmRXJRcUUvMU9EL09LQjdoL3NkMjhJNWVORlVsNEdQNHFGT3k0cFdMTWhu?=
 =?utf-8?B?NW1BQWh2Z1JnOXE2Y2FycTZuMnRKV0hDLyszYXlid2lZV2p2YXV0Y3kzRUc0?=
 =?utf-8?B?US9tSmlaN1g0VDI5eWhhMWFyM0VHNmdOb3N3eEZlbURtZE41bCtyMGl4NG1M?=
 =?utf-8?B?RVFBNkUyd2E5MXMyVTliMm5RaCttYjdRZTlIRDhQUi9iY2JaYzFyeFM0L3li?=
 =?utf-8?B?VnhkWE5DQkNNcHpKU3I1b2hpQW5BSDRFRzVRaWhBYXRQZzFaaWVoa2tSUlE5?=
 =?utf-8?B?dmx6bGQ5czdLb2huNkVJR1BkYVJVSHp0ci9jS0pJTG1JRnpIZm42Snp0bkNo?=
 =?utf-8?B?WGJMNG1RVHF2Vjc2ZFk3bjJ0Qy9DTzZmT3RIMWx1c3dSc1VwNTd1TE01RnZF?=
 =?utf-8?B?Zkg2M1htZFE2UHJRNjB2NTFwZjF2N1RZbC9RdXp2Y3RjRkw5bDZmVWQ3ODNU?=
 =?utf-8?B?NUtvdVdCOFBDbThydjVjMFlkN3dvNXA3WWI4V2ZrQWhsY0k3M3FONmpjSVUz?=
 =?utf-8?B?R1NVTGhQVEpxenhkeFBGODJBUldRUGFwUG01SUdXN3hiTGJ1MGNSSjNKQUc3?=
 =?utf-8?B?L21EbDkvL2EyZG5HSWltSHYzbUVwR3hxalR1OGNZelRORlhrM3ptZmJaZ2pt?=
 =?utf-8?B?VXNCZUZBWm9odW1oZVVpRU9NNmJOZFlWTktwQ1cyd0JoaVFUWC9sUEdyUHFS?=
 =?utf-8?B?OVI2MXJnNnUrQ04zbEdIYmp0REVnSzdjL0M1ODZQOXU1TE1vYkNEWGNRM3Zh?=
 =?utf-8?B?bDJCQ1pUUC85QU05NlZ0dCt2b1pzZWNvNEo0elhQYXU5YkkrYUt0a3ZsMTUw?=
 =?utf-8?B?aklMdnEySllTZ1RYN2RhNU5LR1BqL1lES3dXdGN0NzVkSmFxdmdSVkU5cWMy?=
 =?utf-8?B?eVZNSUlMenNWYTN4SVlmNGRUZDVNTWdlVFVxSGJoY3RNOE15QlgxNnpYOE5l?=
 =?utf-8?B?YTFHMnBYcnVkZTZ3VW5VdFF3aHlGaVVPdkYxemRMSXNRbkhBVVE1QnI5VFdo?=
 =?utf-8?B?MCtHaENOOGx2QjBsejlpVWdPUFBaeVVvdE1PU214TnRydGFUNVRlODNuYjZu?=
 =?utf-8?B?c09GRlJYcU1sWEovZGw3UCszcUVCVS84NnhHK0ZzM2g4VHFoRXRJV2hzVklX?=
 =?utf-8?B?Y3M4WDlkcURDaVZOdnRVUm9QaTdMQWJFbXV0cTN3dGZGenliUk9RM21OZHpa?=
 =?utf-8?B?U1hqeTM1NDVqa0Jhb1h6eGlpa3QzVGNMWHI2dnlNVzR2dVNpV1pMU2FncTk4?=
 =?utf-8?B?M01jU1lNT3hNODVrenRCeHI5K3A5SjBVL293VVNYR2MrUk9zNUl5bG5tdUM0?=
 =?utf-8?B?ODNuNHh3S2ZGZGZaU1FvM3g4blplUEljbEZrZndIdHRmcys3ZTlnbVFuQW5V?=
 =?utf-8?B?T3E4dlFoR1dsbW5aREdHWFIwZjc4UTh5Wk5JYVYybFdIaFB5cHVmdUpjOHI0?=
 =?utf-8?B?VkNMRU5nTi9hb0o1c1JNQ1dvUmJSL3NkeUdnQlpBNkNhSmNzMzFuYVNkNjMy?=
 =?utf-8?B?NTdsN0lrbDlFSHFuMWhuOGlQam95ZEdvR3RWNmh6OExNdWo5N1lsYlI0ZnBr?=
 =?utf-8?B?SE5KcmQvYXBEZFJRcHdVd29yK2hXWTVlVGJLU2MzaEMyUTd2RDVDd3hiMGZX?=
 =?utf-8?Q?12GsI+MTztjLWNbUWLILKd8=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcb0d7d-40c4-4a5d-8653-08de3e8e34f1
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 23:36:02.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yuKScs9WPfwLwMmnUABhZVJNm48aKpegkuOG5VkobzAaUW53cuWoJgDw3uGmXmq7W0VdhVKHR84P/F9m8DvEBpJsf322mO7et+P5fYLepU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8411
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5EE2A000E
X-Stat-Signature: ehnjd66ebcbdtjgnokn3hzi75f6nk4zk
X-Rspam-User: 
X-HE-Tag: 1766100966-333070
X-HE-Meta: U2FsdGVkX18+Lyk3yv13pXFqU4tIG0G+dSOthzJrMDpsvoM788v175z8kN8eLbhjyJIw0ijU5nlc4kv14H2rtoiWVSHbWMxSM9M3fuHtwpTH1O4Flb66qML56+c/uresYsS0LM6lazxhxel9qdS560VuaJ8PRyvHmyEg6w3rMlpi7tSuC+6e0z5Djswaxsa78za4cXGlT0i8hqocDoR0NETZ3ZdXfyDmOLvlhq3D/5Doc6Jl/1l1rAXI9pyqxxvAnTNjF9XC9RrFZE/qxc7HX0DQcMHD5Y9yEU8LsEaNxmLZWf276BIncu8YoStXyrEEkrBozoKTh+cKLbZng+8vDSH7ThHKL3wQYkAJrezrHMdo8deeoJVRc51udCD+xJlzhMdUAJKlU6vYiRTXexUfM0l0/l8mcGG54P2KUBZVqlRaitwTpkZIyi3V/OdDT17KAgByzs/CyrEYiS2tk0vO28nD9rUerCrshcsta8TS3HVZOYNLw/0mNcm/lHdDKvX1zer7IYYkAASn+h0u+pdn/wyTfsp4MKaH52Smo7STtPCDmTfRVLorLOBn/mhb7KnVC+GVVRFW5I/6Hgy2El4+AAq0tQ+SFNnL56f/qj3MkiLunGHBFbb7rp1/yEDU3mEgYnDCLAUJDgwGlCN4fXWzAhKFdtJWNVjkkIM1dc2hW4MrgykA1gGt+GMHf8GvxSuX8YTa5XTC+AxqfAkBzOY4zXlKpxQjs1dWRq0ySrqq/NfpQ4LpHbqi/45Vh78wxPFMYHemrmvNC57F3xqiFHcZc6rWWhjMKVaG5LM5ZbXNotAuedWLYqoD+kuLZbOaGmSifr9VRvVG3nCzrsZEXMLS8r1k2cSN8I6AXij+IHCCfGPDh0pjqyiL8Se/BXSIgdfYwbjCPmnXDAP02YoWHE1PNh5DKVsCaYVSkak5xRL79/NL5QHb2io4jOlEe1BMReQvBHa/OrL891IkvKOGWTE
 EGF+rrFQ
 g1ORnJvRYIx0CpFN2ylELUy0yh2hUIbMTcrzKICzolpPsEfjS6Plq8YIiwuueT9bRZYhDFSAMQPN9YRfub3bzoL7eT3SVC0YkTJvQCJYqQaEa3zXMbvBgZqFN8ye8A+4MqcW3XepQNbjD0MNOpJFkuY0Fw34PtuVxq6W/rWTR4bnMY8hy7kdP47Hgmr/7/aiiaOcUP/hhTq5P0PLgo2skX7x+kfnZlWVS8lwR4IqPDTHpjO7v+wYor1VxEYUN50zLQTL1EdAI7v5sCJax/cfwuCAPOJQQFfXfcOcVNugtabx5dfV96pSaj00Lp7Vz5hNc6jkbDIAjMTJVDxQbWXa1UNJk2Do7n1AJua48pTLMgT0oc35s8JpQsxeaKKpkMmcnZojwos/58J0lPQCMniLWhXPQL77ugSx+hTPQqksBc/PRXBeiiTie5FdMvVSJMHPv9NTwo9GULZcz0U0i1ioNngGZbvMf3WIuO9mUcEjssbURHfAoiemk3BCJAwXbbjK+6kTEt62c2dyhd4495LVFH0nFb3PWUPPMjAa71sgsTvrksWyEuYJ0VHGqQbw3drWatKT1rlE6pAwtEf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-18 15:22, Boqun Feng wrote:
[...]
>>> Could you utilize this[1] to see a
>>> comparison of the reader-side performance against RCU/SRCU?
>>
>> Good point ! Let's see.
>>
>> On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
>> hyperthreading disabled,
>> CONFIG_PREEMPT=y,
>> CONFIG_PREEMPT_RCU=y,
>> CONFIG_PREEMPT_HAZPTR=y.
>>
>> scale_type                 ns
>> -----------------------
>> hazptr-smp-mb             13.1   <- this implementation
>> hazptr-barrier            11.5   <- replace smp_mb() on acquire with barrier(), requires IPIs on synchronize.
>> hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per-cpu overflow lists by hlist.
>> rcu                       17.0
>> srcu                      20.0
>> srcu-fast                  1.5
>> rcu-tasks                  0.0
>> rcu-trace                  1.7
>> refcnt                  1148.0
>> rwlock                  1190.0
>> rwsem                   4199.3
>> lock                   41070.6
>> lock-irq               46176.3
>> acqrel                     1.1
>>
>> So only srcu-fast, rcu-tasks, rcu-trace and a plain acqrel
>> appear to beat hazptr read-side performance.
>>
> 
> Could you also see the reader-side performance impact when the percpu
> hazard pointer slots are used up? I.e. the worst case.

I've modified the code to populate "(void *)1UL" in the 7 first slots
at bootup, here is the result:

hazptr-smp-mb-7-fail    16.3 ns

So we go from 13.1 ns to 16.3 ns when all but one slots are used.

And if we pre-populate the 8 slots for each cpu, and thus force
fallback to overflow list:

hazptr-smp-mb-8-fail    67.1 ns

> 
>> [...]
>>
>>>> +/*
>>>> + * Perform piecewise iteration on overflow list waiting until "addr" is
>>>> + * not present. Raw spinlock is released and taken between each list
>>>> + * item and busy loop iteration. The overflow list generation is checked
>>>> + * each time the lock is taken to validate that the list has not changed
>>>> + * before resuming iteration or busy wait. If the generation has
>>>> + * changed, retry the entire list traversal.
>>>> + */
>>>> +static
>>>> +void hazptr_synchronize_overflow_list(struct overflow_list *overflow_list, void *addr)
>>>> +{
>>>> +	struct hazptr_backup_slot *backup_slot;
>>>> +	uint64_t snapshot_gen;
>>>> +
>>>> +	raw_spin_lock(&overflow_list->lock);
>>>> +retry:
>>>> +	snapshot_gen = overflow_list->gen;
>>>> +	list_for_each_entry(backup_slot, &overflow_list->head, node) {
>>>> +		/* Busy-wait if node is found. */
>>>> +		while (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
>>>> +			raw_spin_unlock(&overflow_list->lock);
>>>> +			cpu_relax();
>>>
>>> I think we should prioritize the scan thread solution [2] instead of
>>> busy waiting hazrd pointer updaters, because when we have multiple
>>> hazard pointer usages we would want to consolidate the scans from
>>> updater side.
>>
>> I agree that batching scans with a worker thread is a logical next step.
>>
>>> If so, the whole ->gen can be avoided.
>>
>> How would it allow removing the generation trick without causing long
>> raw spinlock latencies ?
>>
> 
> Because we won't need to busy-wait for the readers to go away, we can
> check whether they are still there in the next scan.
> 
> so:
> 
> 	list_for_each_entry(backup_slot, &overflow_list->head, node) {
> 		/* Busy-wait if node is found. */
> 		if (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
> 			<mark addr as unable to free and move on>

But then you still iterate on a possibly large list of overflow nodes,
with a raw spinlock held. That raw spinlock is taken by the scheduler
on context switch. This can cause very long scheduler latency.

So breaking up the iteration into pieces is not just to handle
busy-waiting, but also to make sure we don't increase the
system latency by holding a raw spinlock (taken with rq lock
held) for more than the little time needed to iterate to the next
node.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

