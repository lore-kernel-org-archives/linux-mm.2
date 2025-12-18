Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBABD6D22B
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BA56B0088; Thu, 18 Dec 2025 08:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42A36B0089; Thu, 18 Dec 2025 08:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECEE6B008A; Thu, 18 Dec 2025 08:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 783DE6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:51:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D1351A0187
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:51:12 +0000 (UTC)
X-FDA: 84232728384.11.D457A40
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022085.outbound.protection.outlook.com [40.107.193.85])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28243140015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:51:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ZBHnIH6j;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.85 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766065869; a=rsa-sha256;
	cv=pass;
	b=VuOF1AKD2pGOrpww6W3ndr9T+yxUOaqVMAwqQC9JChqH+Lo0nf2CFsnfFkv5Y+zwU50z9B
	gqdzUgyqegHlcU2Jo5xagd35HMwlhRHv3oRpu4k0yf4NJkpH2mve7y86eGknZaaUSItjjE
	GwyS82Asqz6vLaux4KjNK/kUFmoGtQo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=ZBHnIH6j;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.85 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766065869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yc825N6T9+7oztOGoWf1LHSmu8zl/K38htVxxLd6kQ0=;
	b=lXjffc1RnW3Y5RMo5RRjpKDUGZGgt2AQGj3agGbDK8QYMCtDOqs5bkJ7c/Dw+elyxwzipu
	pphR88CmAoHWOEf7LwBwGPIIN6ifsygRsqVz0faUMqrf7bC+zPI5PdM1YzKxkAu++5Dz3E
	wfdideYIYQHbJ2ZX4KmTGcvQADVedck=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NuTyqqL64ddx6/PQ9CGibnEwC+gvvxwmnKOlVyq8ojCz5eKm3V1cP3grWqT6vX9grHjw5BSg/2vhGAABvGqpsxWa7PDLpsL+PYBjEfn0jfzW2FV21bv0qf3ij93i/TC7IkgvxJZTItHrx3g0QgHCU3eAipes4V05j3ZphsFhUFSw4fkpjyWUmmrj58LGfZzfCIm3Y5zRhHYryiuXjgo7AKagxuZiEMUO9vorkrwpSujVdHgBNHcM9/Uz1yFYIUOztKO9OnIyr+2cxq3ho1+dwZ0QwceFfAmt/ROL76zpJ0LnJbaSauEz4aEVjNpGbXpkC6GGC+Zwze/ADas/hWnIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yc825N6T9+7oztOGoWf1LHSmu8zl/K38htVxxLd6kQ0=;
 b=wCTnjJU6xzojhxI2gf+1RpHzEfjISWkqjcusMgwFCssgKNLQC/KdkGD+ZIhXPwSrKYEgt56a7jU9KjokxkHknt986569ID/F9O6EdvBuwUbfiiVJy1JWpbgxrYXufDUhoLO1lx1kLDzYq/zX6sPRI9Xp+ywYhaRV8l426QlszcpcSB4foiCibMFEgrWnGP2tdk3/lnh8hP31CLQHIEOshK8S75pmYRjOk38K5X+2e4FfZqb+E+YBP+rPpg+5qnqZWhR0QWJiVU+N9LKpwer08SbsVNBKnunims441UDCbTotB6pp6gfGafq+1AmuyKnFgOGwabR0G7neNRs1jm7xjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yc825N6T9+7oztOGoWf1LHSmu8zl/K38htVxxLd6kQ0=;
 b=ZBHnIH6jxtHQh/oNA1cjFx7XKSs9xewa4tebUPES3y26oG0DSNlMG3tAQ2tt2zhw6V2cd6Xyf/32wyg/1UwDVsHWzyz/+7g6BntUtM75mqjHMoBHJFciYk0NAgm3rcN81tUajTgJS01VE7GUjZk3GZSoO63AQrwZEgxIRBbyhpnF3Yv6eTvmrOyJdaZViSrhALDb/FqnS2p5hT/JMUiH0gukWi5tnrPSLtUfIzELfeFPPJY94OBaUOwdUW1Ay0Xt+5hiJFAOFP+MyqUwiz+l6+iCoz1GrnOXG7AhT8fTa8KurtGicfUvWEcCzo4sEy+SXNIeCy1zDiAt0WQ42y1XWA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT4PR01MB9799.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 13:51:05 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 13:51:05 +0000
Message-ID: <cb55e583-395f-4b83-925f-c341c95903c1@efficios.com>
Date: Thu, 18 Dec 2025 08:51:02 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 1/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
To: David Laight <david.laight.linux@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes
 <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
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
 linux-mm@kvack.org, lkmm@lists.linux.dev, Gary Guo <gary@garyguo.net>,
 Nikita Popov <github@npopov.com>, llvm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
 <20251218090313.33923750@pumpkin>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20251218090313.33923750@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0077.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT4PR01MB9799:EE_
X-MS-Office365-Filtering-Correlation-Id: c1bddf70-e45d-458d-762d-08de3e3c7d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnBoTmNOL2ZQdnp3dmdvaEhjRHEyUDJHVkw0a0ZYb2ZnYjNDMExOTjFCR3cr?=
 =?utf-8?B?UHg4alZGZzB4akZCUkpHOFNuNVo0M1lGaXBOOGprK3ZxL0t5TjFFRUhTdi9a?=
 =?utf-8?B?cFVxYWwyTDAxdWFJS3R1WXFlck1Jc0hidmFNV3RIejJjZjcrQ01nWlAxd1Rk?=
 =?utf-8?B?cElmWkpXYVBMbDVLZ0pmY0RuQU55REptbEk0RVFzZkdMM0wyRXZRZ1dibUMv?=
 =?utf-8?B?bkFzRnZTTituVlNxWXFnQVprbUp4VUJlVmdZMy9MbzVFSWFhZkNROHZ4UWs4?=
 =?utf-8?B?NzJoYjliTkRieEI2Zi9VcXB2WUNBaFBqbFhhaHEyaFdWUFc2aUlSTlRUWkpG?=
 =?utf-8?B?YnZ1YkZuUEk1N3hOTWJaRG5BaVo5NHNucE92YXhyd0xHWkFhQ0hzTWluRElF?=
 =?utf-8?B?dmg4YkJlYjZxcnhDWmtwdVpranlFWDJEZm5ZTExyM2gvemlZMEdWMEZTTHhr?=
 =?utf-8?B?YlBOaXlzc2U1YlRaVW95cy9PejdPOGNMcFJsSTB1TmlUMnNCaFJ1UlBCc1pM?=
 =?utf-8?B?dXRDQ0E1VTZDWjFEY084cTFqMUEyV3UrdmtrazZCWjVTbVU4d05qeTA0VVgx?=
 =?utf-8?B?T1ZJYTlBeGs5c3VtbVlnMjFuclNFK1RqMDM3ZnhJVXVqVnlCTFZCVHo4Nlgv?=
 =?utf-8?B?K2FnN0xDSWh3SUZiUkY0T1o4MmFaVmxvTXhtTTM3cG1VSTFyS0c0RC9rYXps?=
 =?utf-8?B?QnpmWmYzUWg3dlhTL2dsYWMrNHhPVytObVlCT3dodER3ZUM2YXF2M2luYjMr?=
 =?utf-8?B?b3A4Vzk3TW43dnRHZE5yOHNaa0IzbjJjcWZ2OGQwcjdPdnBrSmtvN0o1dE0x?=
 =?utf-8?B?ZGdLYnVwY2tUcG85d1BqT213VklDc3drK0IxcmZHYUtNUEFkcnlTUHBlWmhQ?=
 =?utf-8?B?c0o2dTJ0MTYzdGNIVlloL2NHZm9mUlVQeDhnMGdTemdQVTE0UnAraHN3UTVG?=
 =?utf-8?B?Zm5oRG9WdzlqTmVSaHpmd29kdVZYQ05UaG5zV24ydmtzRURWQk5aUGNBSzJs?=
 =?utf-8?B?ajZvV2VsUllrbk9UVHhaZFJnMzNON3dRb05DSDE5MkxZOW01U3FpZEtVUi90?=
 =?utf-8?B?bUlJbG03L0pCZWozb2Q4eHBudDZMK0VtT01WdDZQd3poSk9hYWR6SnE5dXJ4?=
 =?utf-8?B?c2p4SUFCbzdNZ2p3TVRiWHpVMTI2R3FtNXpLN2tqWWZQbmtjRlU3dXQ0RDJE?=
 =?utf-8?B?UStZcURJY2lhWnRrb2xDUWVobUgzNTMrblJKejdXc1gzVGV0SlR2bUl5WDNM?=
 =?utf-8?B?RmFmdFNUNlZOSmZTZEY1VDAxNS9OTWM1ZGxIUTlTby9BVTlJWlBmYkJiVmNV?=
 =?utf-8?B?aHQ3VVlIZ0JxVytaaHdDdit0WGRRMDArZFV6ejRlaHhMUEtBK1dmNUx0T2di?=
 =?utf-8?B?d1AvdHZHZXJRWDh2ZEFEcnRoUm5YMUxRUnNNZlBBNjZvdWtZckhYMFdWNTBF?=
 =?utf-8?B?RnBtaTBKbmdxdGE5YXFTSFozRGpDdlR3Q1VoVEthNUF2djZIVTgrb01NVWVw?=
 =?utf-8?B?U25CUEtpcW5BYWxvT2pEckZINWZ5NW90eEJOS1kySGp0Q2hjK3pOdFdRRlp3?=
 =?utf-8?B?OFV6NjJrK1RQYWt5RndXUjduSTVGbXBUUmJtaTJlVTJoSVFtbDB5Q1pEWTFx?=
 =?utf-8?B?cUk3Vm9qeEJ4L281QXRJMUtVN3lDMTVudXRRV2luR0FnbDhuZmo1cW1VSmlq?=
 =?utf-8?B?Qld0cUs5SzJRYm8rUEIzdEpJM2k3SnFUZDZaUytwQkFJZW91RlNsOUVpZDgy?=
 =?utf-8?B?LzRxazBHR3lYWFBtRUZRZEZkSm1adWVja290WFhrbVpiVGg0Vi9scHZ0R1hx?=
 =?utf-8?B?QVBUZDJvMDVHbjQ0SU9teEt0SGxOOEMybkpnNVhQZnJ0VHMvcDlXRHRjWEhk?=
 =?utf-8?B?b1JTUm5YQmtuTDNJOFlxRWlDdU9TcXkwSkZIVmVuZlFzMWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MktoK1ljWVhjcVVoWFhaTW9ZMFRoNSttOGc1MjlLR1hXUE9zcldPK3F0Nnh1?=
 =?utf-8?B?VzlCSXJSZXl0STRoZVluUVlIMkorcWxMWGRvNmxtQTZKTEpicUk0Mk5RbUt1?=
 =?utf-8?B?YW5qUGtKS2RPQWFaYU9KbnQwTUZxVEdUcFFDb2VOQzNySWtacm8rVnI3eXEw?=
 =?utf-8?B?bjg0dExQZ1hGRGtzNlFFRThFbm9oUTNiV0lLWkJYb1lPemhwcS9BenN5Skh3?=
 =?utf-8?B?M2xIZ251dHJTdzhycWxnK1hPb0hmVnMrL3B2cXZvbHljZjVoWkJ2a2NaWUs4?=
 =?utf-8?B?WFBjd2o0Q21PZXJiZXpmSDZzZXRSZXJwRWx1RzZncnVZVEhhWG15d0FKZWRN?=
 =?utf-8?B?Q1pwM1hldkp0dGlpeE92QUovbmdFZlZTa284ajlwc1pkUUV4WEtybTlLYU9F?=
 =?utf-8?B?c1VtaWI4RDlzNDJxV2lMUFZCUDRBQXRTM2U5bTRuM3hlaW1wZVpMblJiZEpm?=
 =?utf-8?B?TGtQNzl5MHMvV0MxV0NLaVRaOXJWRlVrdGRJbjJjZkdlSjN5L0cxdUpqUGU5?=
 =?utf-8?B?MVA5cGNybXIzdTNDekhGb2JRR0FIcnUwbTIzMVpDMis1c1dnTUd0aWgxMkNp?=
 =?utf-8?B?Q0RiNzBFUWJ0L3FwZ3BvanZKV0gyaGxmaHN1QXhvZU5EVWJzbEpPV2xsU2ph?=
 =?utf-8?B?emI1TTRvNk5CUDM3bUlIQkxjdmNnZGMrbDJlQUcrRU9vOEs5Sm5ZdFVkandz?=
 =?utf-8?B?N0Jpa2d0a0pDaS9nbVhzdGpBL3hJZFpHcTdRUWxqUzF0a1QzK1QwSXZ5emZR?=
 =?utf-8?B?Q0lZdXJFRzVnNEFqSnFzRVZDSnFPb0k1bEFaLzlUZCtHZmpHb0w4RU5VUWVw?=
 =?utf-8?B?R2ZyTnl2L1dEd21qV2xOMmJiU2hDemJXK043Mkg0a1pmYUpWV3o2dFllMWRM?=
 =?utf-8?B?YWhEQVpuVnd4LzRmY3hJNENBWS9FQ25vR1NGVDVKZjlWeGh3VFg1MVJYUk9y?=
 =?utf-8?B?QTJmYTZxdkJCZGorWHh2cDJUTGlRUzlnYW14dHBZbmhGbFNSNGx6N08zUlRo?=
 =?utf-8?B?V3VrbXkwVzVoUzAxT3hxTXJ3eHRpOFRvd2ZDeFZzU0JJVDYrVGt3R1J4K0Vk?=
 =?utf-8?B?SjR1VEtOZUx6RTZXZlVRaTVQYTBFaDRUMUREaGd3blo4T1hDSVhaYTZGUndo?=
 =?utf-8?B?WUVpcEtBZURIOWFRNHFGSmVqV1FGd3locXdhTzVqeTJ2S1FvWHpPOTVnazg1?=
 =?utf-8?B?S0M3MXp3c0grekxFNHNKMmdLYWZYQTFPc20zWGNlb1lnczJZMW43c3h0QmNu?=
 =?utf-8?B?MUNTZDNkNmVQcCtqektJTTVEWWxnQkIvVVU5NnNPZ200bmV6VnRMRkpvN2NG?=
 =?utf-8?B?UUNlUlZWMEpGTlExSWRLYUhqN1Q4ZWNuaDd4dEVyT0NrbGFnQ1V5eFhrL1Ar?=
 =?utf-8?B?QzY3T2NoQW4zb09WWERmR1B0VGQwam95aFMwSWhPenpIZjRPNlpUU09CN1ZG?=
 =?utf-8?B?OGhJT0YrNlBVQ09zQ01XZnhsUjd3QVFSQUZvQWJkMW5KclB0ejRZRTZscURy?=
 =?utf-8?B?WkpXZG8wSXJ1b0JZMWtFVEtSNDJwMmNuZDZNZTNuUjN3akdIQmNmT1BkSG9Y?=
 =?utf-8?B?Qnl1b1ozUEo4OThYZ0ZsWUs2TWlWOW1EbzJXc211NDM2d1VUb1U2a3VUUlVC?=
 =?utf-8?B?SHNqL2lrOVhGWGdWMFgyZ1VPV01aTGU1Nzkyc2Y1YTgwbTlTeTFUUGRBcllk?=
 =?utf-8?B?M3VIZHNZc1hDODBDOU9wYVRCOGdvWER4cVVXSnVIbCtqQVFHTm82YUNBZTZQ?=
 =?utf-8?B?SFEyNFFMMEpTRkJJSnNUMGRCUG91T3RhQ0tUSzJEOThmREMzOWFWNlBKZ1FY?=
 =?utf-8?B?VzVGQWhkb0FBNnlUNDN0NjVFQzBRdjZFWXJvMnBlbWk0R0llZmsrbHVicVg1?=
 =?utf-8?B?aEVUejVFNVpyN3dzL084NFRwMUdZNDJaSVJBengzdUoxQVd3MU9ZaExZT0JT?=
 =?utf-8?B?eTVrOTRDN3Nvd0FENXFVNzBaZzhJazFvK3owd2NxZjJKOWVUcXp2YnFGQVp2?=
 =?utf-8?B?dzFWSVNEQkRUZCtQS0xwYmlXQkNSeFpOM2Mzbk9kV2FMR254M3lQelFiRTB5?=
 =?utf-8?B?bDJBWE0xMW0rTjl4Ly80TGN4aGdMQ3d6ZDFWSDNXeUJNT1ZMK0x0eHNFbS9R?=
 =?utf-8?B?YTB5QzRiRWs5M3VMMFhabjF6SDB6ZU9iR1kvUlMrR2xEK3B5NXZBNm1yMlhF?=
 =?utf-8?Q?YeAjx/3qlHgEtfcPtsFu/SU=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bddf70-e45d-458d-762d-08de3e3c7d37
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 13:51:05.4503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fAZNrxiYG0o9ashr+n+86zqwUKshECk0hkrNQaqltom+qJmQvml5y6zCq01hIiQC1yKJhKib+AhdGkdPhiKuabm0OiYw208rEZieJGQtbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT4PR01MB9799
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28243140015
X-Stat-Signature: b7cefwxjwwkqi8uytswmohcnc5hx3os5
X-HE-Tag: 1766065868-105034
X-HE-Meta: U2FsdGVkX18DuQA3/8L7RFG5c1u/Sylsy5aX3K9DzlMYP5VUOSNFs6oykrjluTJ+L8El9jSHpra8hws7/ycmE/dvHzadKDlx8jzVZDdgKGdZ84epqx3WqQ4tuAjQwHilPRMIKbJ+MzZAVUZckB+r8ClLX0kF9nGwrXtP1fm/mWdQBzYUezivt2b0V6H6Ooa5aVjw1LQmDlVtGaOIWbgc4tpwe3zYT6vwDCgWN36HOIpnVcMNYBCbsgywUtRmhek1ho2qaoRhW7V76MZQtAg0Ztm3lA45KtlbAEoN3DYyUb4o1vU9T/7Esg45vdcu8+IJLbb2zjNhuGim+A0F6K1RZww2JKLgz3AoB89DwNVlynDezGo5KbgeuYKQMsZGlJxLutazay5KUcTMZIBqMLLFDPPVnblQZ4rZIjXHYHk8kevkM6ZiAkUFzc5O7c+yBZZnI25A6D38vFDPWVrVvcOgKjzjSLXIH4wZ7jjykNZGfeG32dRIiVk4OKB1Fb6ATixq3LDYzca8WKaKa8drnSKD/U8HlCWPc23e/5H7iuAYA039UCyW3NTZh+lFaEAv56c1eRwJQ04qW7e/BUhDo//7AXP9fP/15QeKd9rcXW0NULk3oxPmjJeML12qWPpUQRpxvSxk2zXbt3Tjh6MvV6zmTlSN+MkUtFiwL6TWdznGKgA1HNh3B34zXq1+HNjEZ00PmarsHKvjT4XewljVHrL/bTo1UAP2z9+yixERAuQzJ7+57Eqde4mgKU+xvbag4+VIOnEoVcyTLmSrY+jc85Gf1PpG0rc/jht3QuqiaFSt/gL34CTRoZWJbAMCd9exNpYSjNZZ34Msi15CGFwa5kSxJ10cY4KfrDQAYy3FeOpKIGANKCsAw/ZSiqF1cO4RGgL6I56YqsGFkjr72hMeeda22a28tuaCC40KSTzi2dTkF2p1sEy0uZo2HHUjH4LOlL7kKcIvUNDtLM5UInVbW6T
 g0e+uZSK
 DQbWUGsY64AbY3udrz9F1KtsD+Y0nO5nyVwMgyQocpvV6aNQVDTAAWgZrTp6+HGIBbWW+0btIJviWQQN5nDuLAsyh1/nZQZm+kALAsRCnhjS/96wEcPJRch0PTkMx8hsYKlgTOD+dnzI5SceZKi6uIVyZsBxSKIs8fSgh9OqnYLTj/YXN04cqaEBTJmDX20zpRuFj38CYy/TPICxwKuDTszb0PuqEmOHhRq8WTKRCIuAA/+Y2b88EReIoogc7TBy8nrevBN+fYrNMbb8fpJd92tighHdNPgCW4moOU9mDPPIowl3BaDnXnOsgycL2xUr/CV5RwF8+VrcbyPNju0sXwqn12P8fOmeBZsz/nGtRCvAFVioI8aBksB7O7dBg9SMxR+1egDMstyM/07yYrzYG6rtGyNKKMwIdqGAvob2y05PE6mCycc3vaaUsIJxgRb1FCnp8ML7BW+Vok2FtsbmBW8euCC9bOseWkDqr+lCD6GfZar5Ojra5SmqYW3LrW6ila4/9GvYKFPaiWfUaKKRldwotg+/p4qAE9T4tTb7NRGKNbW8LgWqdOMTHdOerZ16A4P73ocq+b7Ao0e1TUjdl09bCaSBGJUoWXFNdLkaWWat3wpAmjjP/nbPYUB84a5RnvN05Toq+bvjMv5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-18 04:03, David Laight wrote:
[...]
>> + *
>> + * The compiler barrier() is ineffective at fixing this issue. It does
>> + * not prevent the compiler CSE from losing the address dependency:
>> + *
>> + * int fct_2_volatile_barriers(void)
>> + * {
>> + *     int *a, *b;
>> + *
>> + *     do {
>> + *         a = READ_ONCE(p);
>> + *         asm volatile ("" : : : "memory");
>> + *         b = READ_ONCE(p);
>> + *     } while (a != b);
>> + *     asm volatile ("" : : : "memory");  <-- barrier()
>> + *     return *b;
>> + * }
>> + *
>> + * With gcc 14.2 (arm64):
>> + *
>> + * fct_2_volatile_barriers:
>> + *         adrp    x0, .LANCHOR0
>> + *         add     x0, x0, :lo12:.LANCHOR0
>> + * .L2:
>> + *         ldr     x1, [x0]  <-- x1 populated by first load.
>> + *         ldr     x2, [x0]
>> + *         cmp     x1, x2
>> + *         bne     .L2
>> + *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
>> + *         ret
>> + *
>> + * On weakly-ordered architectures, this lets CPU speculation use the
>> + * result from the first load to speculate "ldr w0, [x1]" before
>> + * "ldr x2, [x0]".
>> + * Based on the RCU documentation, the control dependency does not
>> + * prevent the CPU from speculating loads.
> 
> I'm not sure that example (of something that doesn't work) is really necessary.
> The simple example of, given:
> 	return a == b ? *a : 0;
> the generated code might speculatively dereference 'b' (not a) before returning
> zero when the pointers are different.

In the past discussion that led to this new API, AFAIU, Linus made it
clear that this counter example needs to be in a comment:

https://lore.kernel.org/lkml/CAHk-=wgBgh5U+dyNaN=+XCdcm2OmgSRbcH4Vbtk8i5ZDGwStSA@mail.gmail.com/

This counter-example is what convinced him that this addresses a real
issue.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

