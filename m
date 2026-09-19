Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFB2C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 17:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADADC6B0092; Sat, 19 Sep 2026 13:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2D76B0093; Sat, 19 Sep 2026 13:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97AF76B0095; Sat, 19 Sep 2026 13:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 701166B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:19:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 103681202D9
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:19:20 +0000 (UTC)
X-FDA: 85231172880.26.083277B
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020084.outbound.protection.outlook.com [52.101.191.84])
	by imf09.hostedemail.com (Postfix) with ESMTP id 002E314000B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:19:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ae25sw5B;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.84 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789838357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjrvmsN0wobH3LEq7mso18M4GS8VQBp4HE9d3/CC3pg=;
	b=UjjbYy1kS0GOzad98+rpYS+Qolzqb1tVeJwhlLXe4BeWjaASN0vS7kovAGlnRtXup601/P
	/kx4XV+nBLRGJMM9o9W3bNDxiONxeDpqHnedJAWuFTjLNnuptOUfx9+044qHDdallue3hd
	FfY5CeaeduR2tOf0c+NjnVfRIq6wd/g=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789838357;
	b=mAjhuwsbGpJLceqPQs06VKiWqWcxYj6sXbwOXEaWItfz/tTr8A9ZPFx9h4J/9uKbFPKbJN
	ejCpIbFosm8K/Yd1nK7/6bpbHeUdwJREjaIPlPV0UrZksqehM6q3KNxy59IC36Yb/qex9h
	R5kDczA3sdggmp8LwOiZI4M/m6cdwKY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ae25sw5B;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.84 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmQm4XMbozrGjNOocZ8O79lSpWlfj1npiuAmqFiqO8VxZAUVCZp7UF/GkTP9zfOBJHXUpHW4BS+1zbWo2ScLzFRG5Ke2Lpme096U9OFNpDTV4d5qFueTQSi5pOsAIv6GYvPC5BSTmxzXdaRD6uGgFZDubXEnoA+Xz8jtzOASiRUAjpkZj4n9osYOj970vrpQwdHvM9w7YW+7XwS7VmlYG37ukKyBOIWr8gNlZxzqC8cG2ja2udv5P2CB4lwP03tf8hbZuR3DuTYDfRsvLij8xEZgQ/9PhrDTrEYxI+KQgLI4qNJzpgyqgvLsN/ZCYoEVWsPVgq/7YvBjKwtksDjjzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjrvmsN0wobH3LEq7mso18M4GS8VQBp4HE9d3/CC3pg=;
 b=aNITGLu5dcyupqv35coCPZX+yNP+La4+HQU6fnEnePVT95nyl+Jaku5WtE8lZ/7e5JHTJOStf0UD2c1lRODwaciGWb6ATSIBNMYiE6w9q1Im19tEb+EVc4NUCHtqIYvnI/ULFUFpNKUNt9dT8zBcgyTr2eYLVOEp2QB2vTJBqJ145du+FYfaM3p0Uk8Slr45vTN/puaNGcVqSa7ELRjk/E2oYfdn09YimVQpwBtQuL8KS1A6y+M1N0kS0DckLRgwYzMzS1yTvg+MLfPHKQkgaDAzq1bWgivGFhlwIPxEgsxTIHy7+r+DtkPAI9J7MqS8s7/roDsd/mo20pWANWG2vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjrvmsN0wobH3LEq7mso18M4GS8VQBp4HE9d3/CC3pg=;
 b=ae25sw5BIW1GMlZ0Uo4lyfVhpksJQU3egGpuGMgNsvs4X0thsIb4hkGaphvJd7ICOGXcGhV2rmzGDKbYsACjB0I4ZkQSV+ums1HtjL5oBbnZVkCl63QGJbCKfBPj4/4T1aWkLgMHHUD9ar1Bds73accByjWORsdGZVxeMz4tTqh1bHI6uSJiCYMULYL5C9Gg+lDEkUaMz9Hv3yT5syoKi0mqmrA2jZAYo9UDWv8DDTl1n+3DDBTw7e+VPtFamC50eJW2jvC1cznHwlW61UEeUzDn+goSewuNTqJB2XXLjk2LR3/oDXXucuCzs/Pkx0jw4FtE7enulAOqdGge/N0OiA==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQYPR01MB11620.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:a7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.14; Sat, 19 Sep
 2026 17:19:13 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0428.014; Sat, 19 Sep 2026
 17:19:12 +0000
Message-ID: <c0de0530-e919-4cb8-89de-56a20a8a09fc@efficios.com>
Date: Sat, 19 Sep 2026 13:19:09 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/28] hazptr: Implement Hazard Pointers
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Bradley Morgan <brads@mainlining.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Boqun Feng <boqun@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 lkmm@lists.linux.dev, Zqiang <qiang.zhang@linux.dev>,
 Wang Lian <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, linux-mm@kvack.org
References: <e9669b34-12c2-4cf2-a887-315f581f0789@paulmck-laptop>
 <20260919000056.3132131-1-paulmck@kernel.org>
 <CAHk-=wj9knmxXD01=top1DQ9_aqrN2a3kpWRS5DQv6QLwLOztg@mail.gmail.com>
 <6B1FC39D-6EB0-433A-8E49-E5EFC9379AD7@mainlining.org>
 <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <CAHk-=wjyniJy-CX1muCrsZp-i-sLGRYeRYEPN7sw9orRZUCwag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0285.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::21) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQYPR01MB11620:EE_
X-MS-Office365-Filtering-Correlation-Id: d3aabb90-3e5a-4480-cd33-08df16721fed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|1800799024|7416014|376014|366016|10067099003|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Ar7qwZ7dAY3u7Ssg/Cn/Ui6flCiKR9EDk0i+cX/lie+5dNejIFMU48sk9eniAX7xHlsqJ4uD45txguHAb8L7l+IVNqP1tDsJt1ZyD6BeLwTIJhvsGXzc9XcJylSnBHHov4tigI78blZK9FckQ+S6xT66XGTj6KSEo+NPwgAB/lPVca3VWr0hHlWKmXF5MI3tReNYcHLTl4o8UPXEFsmspZZ1IitnJR5+MpIyd7WXZYp66thbuqsGGYMiDbCqGj8ZGC4+FmCu46sERFctx+JuC/gXBjj0u7kfrI7K+IKHkRoCSJJf7iqcJvK3aM+s9Xll8rLkrOIV9t5rgqiUPfwA7rHBDyLdIajVyru1S/yk/+i9NzK7xV/3TYJniEo7kDakWMtDybXr3JoUQBaAs7CILvTw+gZojuWvv9t0XxRNF8PJYhaeX0DkApb80c45zkEHsTSujuQimzSDAdUZmhVykYqGQOz5Mc3WSKZ4om2f5Wq67bQJw2MGtkkO4pLQRPg1Bd3oinPHxsQMVWy4XhvZaAu5ToHrjPMN60MiKYzeQ16MdcM//3ucxsalhStrprOe/haxbzYqdakwpx/f8gZdu+znP3WKTsqB+6PcsMKoLFg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(1800799024)(7416014)(376014)(366016)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnlxNUdDSVkySTdLRkozbHpHZjNFZy9zUHozVFFFRnVUTHN1Um1uZDZXZ0Nr?=
 =?utf-8?B?Yk8rOFlpZUVCVjJNMlZqQkIvVk02VDZ5WEtLTlgzU1ZCOEtiZ2hXSXVrQUJs?=
 =?utf-8?B?RlZOOHhlMFRsR1NJdU5DbkQwQjE4c2Z4eWZsUmlwVUZNcmpnK3k1RHBOR0I5?=
 =?utf-8?B?SDQxRjNUeGExdm9HNVJMTlVRNlN2Y1M0MitNdmhHM3Z4ejlRYjRuQUZSQkFU?=
 =?utf-8?B?QUdkMHlPSHg5amJLN2UrZTFFcy9OV29SNWNhUUdya3l0dnNxQjdSQkVIcjJS?=
 =?utf-8?B?Y1F5T0t3QjkxWWFwRjh0WlRpT1VxTHBRQzliWWpSVGZlMXNPc0RJbnpVWllS?=
 =?utf-8?B?d2ZadFJDU1BIV0VmWksrVSs4WEhrOW9mVVRrVjk3V3duZll6WkM4SXE5citl?=
 =?utf-8?B?QytlV3d5bDdGTXYxVG1yN0VxZXl1ckJPTjNZQ3djNUJ6SG5sNzEramZQWU5G?=
 =?utf-8?B?YU83Znh2NHl6ZkFHUUFFNWgxYjlvTVJEOHpUeEhwVzJldzg1Z0pXWHI2MFY5?=
 =?utf-8?B?V2RJWEpoVTdpbnVGS3M4V1VOUzZCR2tacS9GRU9nWXFkcExxYmN3dEhSUjdG?=
 =?utf-8?B?MmprbWRUQ3J4bDU3OFYrZ2ZoSDFCdG56dHUzUzJQT0U5Wm5tUWlGczJ3cmxN?=
 =?utf-8?B?UGZGb0daNjBmMDQzTU5kRTZDVURxMVFoRG80TW0vUlRvbEoyb1dTUXZLVW9M?=
 =?utf-8?B?aXNkd2M5Njg4TTF2TkRjM1Q2ZnoyNVNueU45RnFJQzlldklTRjB1YVErRDYv?=
 =?utf-8?B?cDQrV1pic21JRFNZYmdieU42ZmZVSmFtNkdKSEcvenVOeXRPWjluRkEvRFRI?=
 =?utf-8?B?QTdpR2VBRnpOaGRCSDJuZ0Rxd3Z2NTVnbmplckozcE5hcE5Xc3RuR2RhSW1T?=
 =?utf-8?B?YVlrZHo2dHNOd05FYUZvNVdBWlIrQjQrZkFrMWZuYjlQTGQ0WUNxZmc4REE0?=
 =?utf-8?B?dHAzai9FT3FBM1J6NzFNYnlkQ0xBWWs5VVgvSGlBQ0ZvdXhoalJmVzlHSW9a?=
 =?utf-8?B?U09VTE4za1hQNlREbmFDRGFLb3BVUFU2UHZaQXZySmpqSzh2TnRRTTBoaGtn?=
 =?utf-8?B?SXFvK2dVbmx4NWhiZFlWVGkyZzN3amc3eHpwaWd4WHMwU1BlMndxc2s5Q0Ri?=
 =?utf-8?B?dzRucXpzQldSUHFYTTdsaXBldEhTNmJVeE5Cd2VjN1Roak15N2hIZnY2aWJN?=
 =?utf-8?B?dllGcGZCK3BTRmJIei9KVDlrYkpnZ05lSExzNHIrd0ZIbHV1SVFidzFWcFFI?=
 =?utf-8?B?VXlPY1pjdGRmcHY3YlRaNnVWb0xycTV5MWNKU3JuVm9CaVA3YjBtaHoxNGlS?=
 =?utf-8?B?YVVHclJnTHVjc0hrY2pwRXlLYmVBbzg5ZFVBQ3JEWnpyYkxudjdqaGpWYVdw?=
 =?utf-8?B?L3lMTXc3ZEk3THJVaXM4TWdiZE1leDlGY0VEL29iRVFjMExkWVJwSVo5RTlZ?=
 =?utf-8?B?S3dXaVB3QWR0UllnMU85UGZBRDY2cm15M0VVc0kvQ0pCV2hlNTYyOCsyWGhy?=
 =?utf-8?B?WkdEZVJDOHRRYnp1dlVJRGVxV2dGRDNPNVdrOEw3YUNHb2hVS1ZXaklNdnhx?=
 =?utf-8?B?TmM1WTNQQlNRZE4wTGVxdnBnT3ZRbURpa2pDZFd2RzRWYnFFVFhRczJUWWVw?=
 =?utf-8?B?cXM3MjdJN2d1QzJtZTVYR1ZDUE1NRFBlTWVGNmtsa1FJa2RsSlRIOW9jTm9r?=
 =?utf-8?B?WEZFYkRXM0R4bVhZVzJKbnhvaFlPSE1DZkthc09STC9HcG53QmdoVWsyUjk5?=
 =?utf-8?B?MnNja011bUl5OGd1NDdDc1VTSWtzdDB2Q2NnbUFkR1RNM3RQajlid0RQWFBW?=
 =?utf-8?B?a3hRbzhHN0pwUUwydVUrbndXb2EyVm4wNHFlR2t3Y1FWYjF1RE5GeHRIN0VU?=
 =?utf-8?B?V0NuQmpRNTJ5ZUxYdkJRWWFFTmRmYzZHS1hWUTRwVkxqV1Z4M2NKN21lMlpV?=
 =?utf-8?B?RXl4U2lmM0xNYjFQMHFkT0NUaFVSemxtVVVmWW1ncWFWSFdlVDhsKzJNOWpQ?=
 =?utf-8?B?V3dBWHhiTngyNXZOTFh1SDZiUFF0dTdHUWh5d0NaY0lRTkJqQlA2NElmU3o3?=
 =?utf-8?B?Vm1nbVBPUjFBRUVOakdTTmZ2c1hwbjVVb1hhb3U0QzFHVjhvYkM0Qlp1VEx6?=
 =?utf-8?B?OHpyMldqd0EveERsdlVBK1UwZ0NuUEp6b1lmWXNPTjd4MGlpZFpVQVUwcGNw?=
 =?utf-8?B?dDRPNWdjOG0xZXdMODYyYTZodlZxTDRaZ3M0aUwrTVk2dE5EditrRmkyNEhn?=
 =?utf-8?B?MEZIRDRrK3llbVd2cTdnWDJPUStaRHhJdkkwZEk0VWpvMlBpQVJGSmpjRVJ6?=
 =?utf-8?B?U0xCYUxLZnJWT1BqRWF0VGlmMXNJK1RZMUZ5SzZWQTAxVDc0UG9oRzVQcllp?=
 =?utf-8?Q?AKORDrqgFaGV1/ZnXHrY9hLTYoVTxLdgu76JCm+tlqGkR?=
X-MS-Exchange-AntiSpam-MessageData-1: gzxVEZj0f4WNZlfQxS2fj8l7nlSIQti7f/w=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3aabb90-3e5a-4480-cd33-08df16721fed
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 17:19:12.8590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjR8/+Xfrm5zgGR2WswMAiLOGALHmBduyyBU7FAEdOg9LLe5zK2GWPI3LQozrju2YiQFzrPHduFRa8YBjER+ZWjIoeAGIAsgLQ7qOmN8J1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQYPR01MB11620
X-Stat-Signature: 7k7n9nno94ea5rho17ag9koypaskdsb3
X-Rspam-User: 
X-Rspamd-Queue-Id: 002E314000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789838356-230588
X-HE-Meta: U2FsdGVkX197BFKKCWBTs3DwybRkHNQPPnJ8UCp/MkJpajEW12OK2B62LC4kIQdCLGeYgnYyKn7O3xJZHAmDVJuwTK7kRyZXAE0mqpkKLKoghW4RHuQCtUg1I42cIqqe0K/WmyWe0wVAKxdzoNOa5cIJwm+P6hNZYDmLXfrVqUJPtWgYoga8GRGDE/FrwLx3TI8uy7XMPpGRY4ZBFHXvD3H3J6ZzS+wvNmqbDtZAAp5nx455q0BusAsX4cc+NRXuOhwEOmqIgv3q4MHp+1DRZ43wPCvnyJVfkhRAjHQRyAnGysnN+gPvHNfHNqAH9UZlPHOUzOkN5/LVztSCSbgsZoXjYU4+pnY2c1W1brvvi1GtL+79kpLvz/isZQsg2vv9R+HVTgrpzYnAT4jZlPCzz/sK8zQUqnCdusRNDCj+r3ZhoEZJ8kwSioVgCkVO6/VhuORcZhhR3/vtRkL571Y12RZmL+yjhaXdxv3ARZZWTlQ9+wXmtdhL1KcHUmRwtA/EBhIMdAb4pkisrH5UC80a5q9+ZthgW13o0k/fyjfsxr5MbMokN+AD9sY5DrrWPcIQglmd1m+xkPp+YM/Spt+f4yt8s/ci1oYkAohVCH7P/ODej6ReYppoAi1fJGC+hnzOHwyXK48n1tsF13TeULqEFFlheiEwbODJGVTA1z4TimaVcfHngkdUl7Z/KrXhSjLofu2vRgyJucutfY6oFnHEdcWGJB4wjgnZtbigPQsB/BF41D1z/gzI3uLQ1uiCOHULELn7Je51NrMjrKemTJpqEBY55f1bmUr/6Gbo9SgzY3PiEbynPVQLCnsLY15PSfJHGtbmyhBTMkuneIa9XweBVJY7V2kiFoofzmFdTyt5hWnkRGO8R7ZjBMxr6sRUOVUXY39HLQ4nFRvqQZLeJZF3+PakQB3/j2vFOQUPvjsWbBs/A7JSBPqRT26yQGOEEeWeGVSQ9UcCOzY9KVCh/CJ
 CHv+jJ4G
 QsU+e0RFLOfhaQSYaBn+45I3umsrD2mkxxc1IuaziS9R/tsPX0ej5sWl6+LQ8+chXwd4tPiJ91qNKDXmhzPFbBxReJeRTE8KfJT65x5AxeMUFn5m8k6j9mlPnLN5vtCubgYbkcXesNCbve1o7VxKDUELcvRucG/C1YQWhALwTMinMVLoVOGbjGY0Td8nKI/3XugHfReCR6pX7UhduQuUn4aXswkSA5CpAxKRifgMo2Yy9NbpprSPhmIwHdUBTd1IbFsIg9J92Q0eEKUSG91MlmiFo8ZktNnmObW769awJr6aP7bkb/0Qj/148ozsowfl+3hkFMRSn/spUhBESLFp201bgCoL3T2dav8ZrFNqJS8KhUle7BuQ6aN9iS4PbY+FKuO+SXDJ+gHNly/k0qYdTpqoJUMADV/YAL7E4r5DxBTZ2BTuBU5QzuTRRKZcsoi0vkez+p+rH9uuLrdpRU/TEgnLkYMHoJznuvKwxvH5juOpLA7apJgEAP/oLc86JV5k0JNNmyOwXJDMzysI3jjBOhjiRnl1TBgx1eRnn2HVDYjkxRk8mtHkSF4X/Wsx+p7I5qTO5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-19 13:00, Linus Torvalds wrote:
[...]
> Now, obviously, the thing that would impress me is something like the
> dcache. If *that* can be converted, and it shows real improvements on
> some real benchmark, then I'm sold.

[ Side-discussion, not related to hazard pointers. ]

Talking about dcache improvements:

I've been working on scalability of rename, directory move, and
directory listing, basically killing dcache global locks, seqlocks
and rwlocks which significantly limit dcache update and read-side
scalability.

Those improvements are based on RCU, not hazard pointers, and on a new
"RCU pseudo-transaction" concept I've invented earlier this year.
I'm preparing a paper and I plan to present it at LPC in Prague.
My benchmark results are on a userspace port of the Linux kernel dentry
cache at this point, so it's not ready for anything close to upstream at
this stage.

Cheers,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

