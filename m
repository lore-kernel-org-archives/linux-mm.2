Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0E9CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77756B0088; Tue, 29 Sep 2026 11:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28F36B008A; Tue, 29 Sep 2026 11:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0A26B008C; Tue, 29 Sep 2026 11:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 930D46B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:42:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19A10A6E54
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:42:53 +0000 (UTC)
X-FDA: 85267217826.15.FA60FC4
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020077.outbound.protection.outlook.com [52.101.189.77])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0219D18000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:42:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=BJAhbuYa;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790696570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC/U1LK3fB0NRovELjkcJdZ/E0d5pUUAOefJqICWYNk=;
	b=hZ/6zoP498a0eJD3GIBKgvQ3UKuwGEdjTh1j1QboUalM32xijsqzunMf6d5n29lwUo7Pyz
	xj9/9aCY5xogzsrxiojVqdjRuq226KIpfMrBRZHA7YDkNCAaFRA4NZFI/Ka/6syu57kLOd
	QkJVH256hO9bnkul2914g3CeFSr+daA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=BJAhbuYa;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790696570;
	b=djBMeivTyCEasgFAhBWbfLzwy4c5TRtGeezwHThzZOsh+FJgNAyvNGjHJIBMlAn31XrX7c
	wt+skwD+J8uxx5C7DFMs93mTv2J3gRMMCKehnH2sIGF8AP2LrZLHe2PQvlgKvQAInm35BN
	6OListMLiNOlSwUCqR9Fn6zF1pcSnUA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdvEEnHKAsp7eEYPTrI3rETlJwYdC/jifM08Z4rRIQwTwstaIiLIa/ty8ETfOxGSfF6btdK5wEy8IFmVDTWdcyeVXAZi7/hYT4Inw2kADWOVBvKnrxnBnJ78kJq+8imhHEZpZ+Aeeo8k29gdWTWf+rCZt2GZjj3ICLKCX6mkvLl9r3+2fqZdmLwba5+KzHjeUhaWNVn9EXR7BeRt+rF71s953chz3YrSCV4M7KRNgBT4fp8KlbPXtIcH2ysOlumbzR7+OyCr3odTVQm4IcMaStkgOSlN7I657lPG1V2z4Z0hmFxjon8zaxnyGHkSANqwj8NqB93gny7tezvRndYhwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wC/U1LK3fB0NRovELjkcJdZ/E0d5pUUAOefJqICWYNk=;
 b=q4V7KyFqxiCB6wLqeBkdnVCPzXowDNQ7YHoI3MvooG0jBZu8swr1Wqc+VCaS42FCbw1+dJhKbTtDKP5DEhtxU6BBM8DCNDm7n3r46gFOEASkkf6gbkH2AYskcYKm6RcxU5HOHw13ILn2xi7wQi64PrzPJQ4CP849LUU9q9O6oJelvCrguyTAqaDRjSi57BfK33MHZ4kPYDV35/Q/cta+u8LtEDby3LRBu5EEgY67NNMil4lguBx3VSBwuWe9ZKdElyjuF34jZhaMUoBzpGaO4921OTroZvz+b1ya14EVeVUF7oyqYItF9RCziSVn7MIa9B3PmnX3luFxKboYF4wSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wC/U1LK3fB0NRovELjkcJdZ/E0d5pUUAOefJqICWYNk=;
 b=BJAhbuYaRuBpyfbVWst6Kn1lB66H410s7sz2Q4CiGASSEYd27jBXumYxQQnwpMp7LM2sORWZgM6fjxFklQMI2u2EhT75Qea/tGTTLq2ydEmsUywAN5L6SSdA/H+7d/9C1wPZzx6IA4+OZzYZxCG/gpHdV50bk0pQ/4IgoXgy5sjlLFz/Ecs0iVHsRWlwt9+UZCfjxgvWLmRoiFFnB0ylyUV8N1cT7xYyLvkHyand5Hccx9cH5m0alifliflm54dfBanpg9SA4hhuU5OstuTEkwxdL0+sUU5xbTyThJ0PcuMWdHXcWminDf1wc/SH7ypm4HzfK5iG3MGgyVOcJ3PuEg==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQBPR01MB10534.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:71::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Tue, 29 Sep
 2026 15:42:43 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 15:42:42 +0000
Message-ID: <5a695b14-d25d-4c11-87f4-83c8d299d79f@efficios.com>
Date: Tue, 29 Sep 2026 11:42:41 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hazptr 2/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes <joel@joelfernandes.org>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 John Stultz <jstultz@google.com>, Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>, Gary Guo <gary@garyguo.net>,
 rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev,
 Nikita Popov <github@npopov.com>, llvm@lists.linux.dev
References: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
 <20260927155134.4740-3-mathieu.desnoyers@efficios.com>
 <CAHk-=wgQyCdrWH3ZuSajOxZqiups6jYbPtqY8JR8OeS7yi49Mg@mail.gmail.com>
 <133ca8de-cf30-4bf5-9539-d0b73e347b22@efficios.com>
 <CAHk-=wi7BkCuzMe_zWi6KHUs09UQWJpCVNvuFg5wh_CAu5dgow@mail.gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <CAHk-=wi7BkCuzMe_zWi6KHUs09UQWJpCVNvuFg5wh_CAu5dgow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::18) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQBPR01MB10534:EE_
X-MS-Office365-Filtering-Correlation-Id: e9648738-b104-437e-47b1-08df1e404cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|7416014|366016|4143699003|10067099003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Al4ACkzm0A+vCt6IhpyO48bwJc2EW/DPOkWyrV+sK6D5CLM73OHTJlIw3eQDGgEaoQlLc4egcnmvK0sB7eSmphZNZZLxsPbA+M8j9YBBQqp8wqILkbV58GT6tgOkG9Fz8DhP12BWlEMrR9Zp2I1tWFqtYeZ6WS39aPpz5FvfB5YLb8Oz87TzTYOoYuxXo6JXvuDwq0dHT9ujS6eetVlEl2aureJntJ0EdZNeuWKmQ8ZbD7IEdRCTxBBI7pa0fLwse06g6uiH+sTvcpR8st/yJuXCMoZpXHzRkUyC/Og+7IdsA27hAXkmwzfOUZ0fPPIhspZkIhOl2J+YZf2iLxv3YGd2hd9KVO1URqY8rTyqHo+UWgSgNFKhpruLDWTjJInILbN1lG09hnT+5Sn1jPZyk0S0RnpR3EyOC+vvhL/EF2rxLVmbLifDALKqr4zFestBWNnHgsMlxloKbzDftOTrFSAvsTBErlEiSz2BrCHIwMuJhkpmxP/NI+komwf6QfePKl2/XURtvGsDYwxOQwHwghB+GqoUzlVyR+wDifsa3+pDbFHXVYtLE/wUMaTw3M2GmOUtawpxglt8EmRJsBfQGz0U5y2Zn03pixHLpHfWBuE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(7416014)(366016)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eCsrUWduUjZ5WFIyNWVtbndndDV6WGRFS1VFNWpteW5Ec1pNNmNjdFZ4TjJ3?=
 =?utf-8?B?Vmk1ZSt1OE9IQnJSZ0RJdjF5NEc2RGhHbGxqQ00vdUJZUjhaS1poUnhFRUht?=
 =?utf-8?B?RHF0Qjc2NWRCcjNEdU1tUk42ZXdkbFg4cXQxd0xrZDB6dmVKNVgxRU1xZm9L?=
 =?utf-8?B?U1JMc29jMlV2ZjBkdlZwNWFkVFdGRFBzNWJzak5tZE55ZVdNY211RFozYkI3?=
 =?utf-8?B?T0RLdFlxRU51VExlcWJWS1N4QWoyTHRZdVluM2NTQ3pjU296L0tma0RoM3U3?=
 =?utf-8?B?WUVycjR0SEEzTFRRazZRbmtNaFJDMldPZEFoSVd0eTFielN5ZlNYeThxVGR6?=
 =?utf-8?B?ZmZ3UmcwWTNwTmRZT1FwSllnT0JTejNqNkxvTm5VZW1hejlMdEtPbUpiMzdv?=
 =?utf-8?B?SDJONDRHN3kxcWZ3a0p0d2xEMWcwNnFpbnZtSjZyUk9BSGNCQ0F1bUZzdnFy?=
 =?utf-8?B?bUVtK1lVRFFqNjk2cFhXNDRQc2twRDhidGh2Zm9OcFNsOXR3TlBPV01GNlRx?=
 =?utf-8?B?UVkvU3dLOW9yRENjOTRqVEFrdUNCT2oxWERCcjFDV2doQm9KTW5iZ085S3Ro?=
 =?utf-8?B?RVBiRU00VTVCK1Z2aVVrYVJZWHVBdi9RMzBnM3Z3K1FVTHA0czFuTks3dDhS?=
 =?utf-8?B?aG5ybVZRVjdHM3V6eWs0bXZxR1hSWDlHZXFZUjVyczVvblIyM3g0RDUyMTk5?=
 =?utf-8?B?Tmdxc1NMUjhvZW5ha1NTK2tidFIwYWZSVVJXQklaVEx3U2V4ZXQ0QjVZQUto?=
 =?utf-8?B?Y3I0dGt0a1g1ancrVVdjOFNQdm9SYzQrT3dXbXBhYUFYcG1vY2dKTkliK3Jt?=
 =?utf-8?B?RDcwY09nRFpYalNvOWVEMXh3LzlwSkFaTi91NXFNODEwZ1BHdHd0VGFiUU01?=
 =?utf-8?B?TUI2UHFDeGJxSDBnL3BIU2lNK05xR3BpRXoyczVRU05sajBLZE9KaWp5Y0cw?=
 =?utf-8?B?NUlFa3hRU2U2aThSWEVRQlFsVHdZa0o0V3hWaTg3MkFRWUkwaWc3NSsxS3ZE?=
 =?utf-8?B?Y2QwaHlKZDhtRU9OVkpjVmtQN2VVNEEzRXM3WmoyL1V0RFZHbGF6Rzdya1V0?=
 =?utf-8?B?ellHZVFEcDFWangwTFRLRktlQjlJN0hvWlRINEUzOURGbEY2M3JoY0tKb09S?=
 =?utf-8?B?U09FOGxVa2V3MDZBcmZYQ252S1NsdER4OXVhSTkyanZDb2ozWll4Q3czcFNC?=
 =?utf-8?B?QkdBTmZUNEZlczNyRHV1OHlKbzFPQnVTTXhBbU5kb3lpcm9sekhMTGtxWnkw?=
 =?utf-8?B?MkpkT3I5b2xCWDVtODR3eWY0ZjloQUNOTElqYXRJczA5d3FGMlg2dzhBNUNM?=
 =?utf-8?B?SjN2YXNrUmZQQ2psbnVNRUZLTlo5WE0zcTYwU3l4UmU5RHo1SmxYQjA1Mjk3?=
 =?utf-8?B?VzZBNm5JWXltSmhpUytvem5GSFpVQ1JZZ1pzVTdUT2NqTjVNbU14RnpNbXpW?=
 =?utf-8?B?eElxSnh1S003RHJuWGNrNkFUQjdjd0hpMFFwTFdqU2hLU0V5WHdyQWJuVE5C?=
 =?utf-8?B?c05rd1lwdXFReVk4RUNlbkJJMS9EeU1KWmlJKzNqWmlQNkFVOU9xSUwxVm50?=
 =?utf-8?B?ZFFwZUxuWHNMNHQ1UWlOTmVGdGNxWWVxeDYzU0FTejgwZ0FWR1pReGk0a1g4?=
 =?utf-8?B?S2hIZ2lkeTY0eExEeCtDSUNYaERxM2I5cXhIbVpJMDdSZTRiSVNsRlpjQW8v?=
 =?utf-8?B?TDZsSmhLMDMwa2tQMVJsS29BVjRuS2Fod3g4VVJKUzluSDk5K2UrcWZJbEYv?=
 =?utf-8?B?MTdyTVBTUW41L3FFUitQTWxkK01BdnJ4WFFZK0ZRb0lXQ1V2TVZ2OTRDU2Ra?=
 =?utf-8?B?WHNTbjJSOHJUd3phTmFPN2tOUHdSUy9yUXNld0NhZTdVYXBkK0trM1pMYmYw?=
 =?utf-8?B?Nll6MnhGaGtTSy9Qb0RzRkFPZFIvbTM3VzFMVUlEbGY5R3NTRHlpZU4xajdq?=
 =?utf-8?B?Yi9RNStoaW1MVU0rckxicmlYVFZrZEdrOXVwZnFVSnlKNUFzNy9VQlNRK1FF?=
 =?utf-8?B?WlE2V3RIa1kyMVc3azJjZ2wrSUtUZmRwM3A4MjVUQWdXNlY4eHlPUEtzOU1W?=
 =?utf-8?B?dE4zWkNTclh5OEFJc211TzUvNWNtRmYxZnpwRlVWanNQeGhNSytWK3VxVW5R?=
 =?utf-8?B?QzdHOTJ0QTRCNGNkZ1d4MFlWTExVKzBidlNQcnhxM0VHQUZPWjFxZmw0ZGNw?=
 =?utf-8?B?bGw0bWZEeTdxK1VPRG5aV250TEpzNExOTllCdk94bEprVWZjV2g0N3Q2Rndj?=
 =?utf-8?B?Vk9pZG9BZWVzNHZXNVVxQjBYcDRnSnFPcmNuV0pvUG5GSFFsSWJZcDB5S2dF?=
 =?utf-8?B?dTIxRUovb1BYelcvSC9HWXVrcTlCeGdoS0JKempUeFJJMFlLVXIybXNpUzhS?=
 =?utf-8?Q?kaddFx7LjBMmZXWc=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9648738-b104-437e-47b1-08df1e404cee
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 15:42:42.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJxgPl7F0SJRJHxX5Tlc9zUuG6JXk6EgfErhjsGYy+YWp4X2FbpQRREPjlHO1p68jWTnuIWEm2qg9/qE87/trEt7aSvyvfoAtHKY7JQJV0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR01MB10534
X-Stat-Signature: g7nqtq37cdd5do8jwr6ciswhmrzje5w4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0219D18000A
X-HE-Tag: 1790696569-105165
X-HE-Meta: U2FsdGVkX1/LmFEPMpTviTXePqJE6liqHxhrvNeSkJ7HwLacA7CYBnSZu2+P4w8t4GpbYFzaRbwDhdFDZJkojX3os0divdMrhK8UhQ/aK09mm1YpGSMVlP8HoXs5zkYg/egrLE2cnxkZrITf9GWUqvmpNog8KyFhu6Wu6x+cPSN8rVQfmKopv1W6civAKNNqHGsgHddZKotYS8NSn/aWPz+KHxDpmcDMJVzPH74mOcTPMKSTdOxLklO9IeRp75G+zuIpfZNPQeZNLHNjGywdVuT7QvFHOLE/VhNs8KMUavwOIPiV53raklEGA43ynkKYE2HGNO+iCeKROjs8ycmly7qlbenzC7CL03Twkr3Uu5YdtFGiz1rcQzst0Rj+S1It59CKES7g5SaE2Ok8CI1EdBVIRptVRVe6ffAqK+6V1IP+CvvjaqxROAOHf6Q9t31o+43PhlF+hFahtmoZZH4WPob0mgbj4s1kpoC+rDHOPq1b19tvyJxNJXuUJeKP3Oe7q8Kuj/1DlVvTIqq8xiDVGVbV/UCCnfG+PrqHqfKefzsurcVfAcvO3vs1PCc79Cuk3DdgvdEiwJvEJttuD+gkzPxreiJDMZuYx8zpzXlQ+TP3NfTUxthDAwDWFrEFYR2dUmEXwQKz6k6VKScySDgFn2wkqtxP08aLd69rNyI++HBQundFWZj5I+a70tCs/CxGnjP2V4kiSAdugrcoFjDV+ZzDGF1PEGyWGNTjHGW/iDXmyCFi7qLZRZmlAcTuD1kL3+T5DnN9bFjiozCs7uwD4BGNEubC0mOkLwDLUbiAXCkLwSZr/th+C/DCdBFo5EiP+3xCztwsEa4WSwmpJkhd1p2Ea08yWP98qAV9dHhx1akPhW5u89DjrC8qiYt+WxOC2jTdUgFeW+81IlrVGudPtB9L015QQo9RMqWLnThCuS29gbAdoxvYGFtEzoigMaMGxv2YgM/RZVJ6WZGnaw7
 C+G3PhKX
 JS8CBjTP6dqrNWXAQ7eAhycUh4rgAVtKdRoRz2vwxAeE8xiCo1iXlxbZz7gseSi5CHPxarcWz9g7Wsh0OVTWF22n8GFA2e0d6TLBYlyTx3rEEkpdsHYBjzc7iprNEeA/HoZjqCxohJ23VrASqlpvugEBRFSL+kzPR+SQXRal5UfBvizTn2LdRJAL5k2oXGfZ8t1t4v6WKVgrfkiS7xT9eplaPv9jj3+AGw2dmxs2YJWSHbJeUg4XyXJ+Q6vd2oAqPiJh9QbF+IJgcwX+nknKcgqxcaznC3UWbpcYmtY4HIIIN1SSHQFPN3bdYrjrOPdG+WUK/yBj1lOToXARIOPvt7u/PWjc14AFueLth8EV1XhStaKnGSS9CLuY7veRlmjwiAGvxc76/2SEhZ6MW8wcM4EpJyhXthRmaynIBUVbfcv0OQXEGvDDSJLff9OoMyNSMM0War9AarR4lfJHcs0hdb7T/vnIUPjJNRbUp4/q8n5BuZh96d30CisM4Wl40pOFTp87DBtK3XqV7Q6DSGSnL8CdpmQ/YT+YKknO1kBM9c0/KNkCPvkmb+n5hIebUvDwV7Bcw8MBsTyNZihf2EcQPWdhxTnqIItY1WbHo8Aaz/AJk7eEEw1eN7yoQWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-29 11:16, Linus Torvalds wrote:
> On Tue, 29 Sept 2026 at 08:04, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> I agree that doing it in asm would generate better code. Also, I've
>> been told that clang now preserves the address dependency in this
>> scenario, so perhaps we'd want to use preprocessor conditionals to
>> select how to implement ptr_eq based on:
>>
>> - architecture (allowing asm implementation overrides),
>> - compiler (e.g. if compiler is clang >= version X, just do a plain
>>     comparison). Likewise for gcc if it ever decides to fix this
>>     behavior.
>>
>> I think this "hide var" hack is a fallback which can be used as a
>> starting point, and then we can specialize based on architecture and
>> compiler.
>>
>> Or do you prefer this in a different order ?
> 
> Oh, if there's some sane way to tell that the compiler already honors
> address dependencies, then that should be done first and the whole
> thing should just become a simple
> 
>   (a) == (b)
> 
> for that situation - allowing the compiler then the freedom to do
> whatever (which can involve not using a register at all, but a compare
> to memory, or whatever - the compiler might have reasons to avoid the
> 'cmp' and use another sequence entirely)

For the records, here is the relevant compiler discussion:

https://github.com/llvm/llvm-project/issues/34577

and it seems like they still have unfixed scenarios,
which may or may not affect the hazptr use-case:

https://github.com/llvm/llvm-project/issues/220206

Considering this, I would not be inclined to jump to the conclusion
that using the compiler compare for hazptr acquire load/test/reload
is safe today without a careful analysis.

> 
> Then a "if we have an architecture fallback".
> 
> And then that OPTIMIZER_HIDE_VAR() thing as a last fallback.

OK,

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

