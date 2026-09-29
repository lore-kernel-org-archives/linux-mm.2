Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E81CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936CA6B0088; Tue, 29 Sep 2026 11:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8566B008A; Tue, 29 Sep 2026 11:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789476B008C; Tue, 29 Sep 2026 11:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46E9B6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:04:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3380E1A0532
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:04:17 +0000 (UTC)
X-FDA: 85267120554.05.5E6B3A7
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020075.outbound.protection.outlook.com [52.101.189.75])
	by imf30.hostedemail.com (Postfix) with ESMTP id 00FE280004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:04:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=PqtbbY37;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.75 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790694254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S85K70cy2lM3PzPMsCC3unyEbX7a+ze2kkU2NHUSgq4=;
	b=PvrK5BoESVpNj8zPEfuNLg+Dhu7GH/CokHnESpT+yNQ3+7rkFC8gyrbQSbZjkZ/QIx1CCo
	7+gAB/JOgiUn3t7vfnX7laQUtkFkDLjCkP+ZsNYc78fLFRaBJkjkLaZjpX78E7/JUkOceH
	8XpYXVwCnKz/vB2HtGLiWy+MmQCkprM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=PqtbbY37;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.75 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790694254;
	b=eIkHNR7ELOnwDNF5WRTIcaGzhWVfPtcKhw/n4M2iExuA6S21to2Fs760BqecYLFsbAAD4t
	+aOjNhkhh0A7nA0qZVwa6t4vd+1BaTL+A3E8+NVVJ7/azS+FHXSt6XXEqGGgduwKMKTDBl
	JDkGw7/qJkZTtEig1OxAofEyK4EMZg8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6vpcU6IkmTrWt6QWp4qVb2js9lRbfXWk+70qnWdpNkWcEOvBr3FH5/4EqkzZ9uzmfaBs/vlD9aJDpolrFmpXGKLENdDFFEfsWUpdH+UgJEOhFmFvBJ+mdjrtQg7CIIbOg22QDgwO09MW+LBrRRR2kI9oZV/eEhUPkw29SuhmtQ2+3SpzZFZVlDkAdDKytipk3lD3/PIAMHJI1nI9a0bfuAVKvyZjNwEvrCEmFlWBGDVp/M2OA0Kh+wyS7Ooh9ppLd1zaM1IZoFzupd3HTo8EnzjV77U6tYqDpalF8yhtVjY3qON06biEZViwYOFZXlv1yy7srBttXMSeJjUhfQuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S85K70cy2lM3PzPMsCC3unyEbX7a+ze2kkU2NHUSgq4=;
 b=N+NtQS3ln5cf1zCo26nx/2WqAUSlW10RIsO1CVquhcv58KO0n87kKrC1MxviXJDt9sObjMKACowMTK3hsokVJb2wBXRRSVD9PmxvH4fPujdTF5Wl5EeHJYKn2pBp0Mgb5jCdkpA5TGrQDLoHPQqmkQCfrjdbkpV9loJEyYXt5zpBT0+eNjidMeUWRz0v/CL4zEWJ87FDOXZBB1EffXpNo+SeUuWPwDYG1sClBXQWe1Yv5Nbd/osUMbyTkBGHnsTQnHqxsm3u3Tv3h9avyaAFm7rhAUKEK/BFDn9sGWIZpsmyN1EyKBUN/zYtNIcUVmKXxXQ5vFTAfGrrVldCU58KJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S85K70cy2lM3PzPMsCC3unyEbX7a+ze2kkU2NHUSgq4=;
 b=PqtbbY37SKigorixk/G5fnbVXd1IxRUTYERgP0jYQPOyz2O73X8kFs5tlSStsxnsMz/1vMx/Q+AnWqT9S41Z/cK7Pk9o3jrMDDPgBhGFmGAYOHoRWCe6Io3dLe4G7U1uPX8r7G/QPaiA1OkMlBRLnUCO9L8WfA561G0i2tzSLRgZZkFOPqko+TtXtfdwpwhoj9F167rzmM1uZwlIdSkXeqZQpPiVh08TgOjNJf8f8fIdIEhY3ylNVFOsiunC9vDJCAEikfmpxGhs7owYyTi/Bh4VgYM6KrqRQphwhOhvn6d1rZIHlQCN9EJa+IoUUa4aROXQsHWfD5rcGXXF7tQ/gw==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT6PR01MB309022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1c2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Tue, 29 Sep
 2026 15:04:08 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 15:04:08 +0000
Message-ID: <133ca8de-cf30-4bf5-9539-d0b73e347b22@efficios.com>
Date: Tue, 29 Sep 2026 11:04:07 -0400
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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <CAHk-=wgQyCdrWH3ZuSajOxZqiups6jYbPtqY8JR8OeS7yi49Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0138.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::17) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT6PR01MB309022:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bee8a9-14c0-4d20-5854-08df1e3ae963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|56012099006|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PWqZEan2pySRm4WxkEPjh3j90f+p96WlpItLNsOaWZVIFBl4ZT7Zfi0tu9ghCyZkH2BoKc1gCU4RrJb3DCgtC6rGfrtGaRTYtvvwDe0Ou9uW55iafU3rmbppTNBSB/WczVqmJim70eOq5mx1m2CiaLnPiGRTyDljGcI2eHcDfVpHAsIgzvR80HEz73mPXEIv3IyaGoNx8EvNbb2/AE1fCNhcYk2Y5hGyijYLIYrt7orNtWvWesiLbp/hh4nwoOm41Wci5SFuhyEu2tnPfDul/3w8B61NBR5DP2M7/YHzoo1hEukk4UJtmswf13lDcDOUy5rxZaNV1LgNmIf0NK7t7lliWvTME1BZeJsJGky3kfirnIzbw+DqUnh3t1mgyAVCIgb5Swc038PNIRz0mAr0VYPDPzWlZ+nsw+GXWHm/+61SU1txpHfn2/lP6hJEgyds99AtJkj93OFErhfGNAJbr5TuEEW3Q8PJyzh7nZElVwOYt0YwQUBcB9LGIzPpRWzPsmhO6nVFQ2ZBmvbbi8JB7rJ+8dwp/MK1Bp4x847nMHCAws2tFhJ/shRG5AtSwRhYb1EdsDerMZrVpz0vhjduwyOODchwWPSwyWJAeUaPUEQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(56012099006)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEpIQTkxTm5kVGV0UHB2MHlNOVJPTGJjSzlEK3lUYzZlWlZXbVNITHF6aGl0?=
 =?utf-8?B?UkcxYm5SMmx4ZlUzbTNjMVdIRDhESjdMR05ZYnhBdGFPWmdCaEYwR2N3UGpQ?=
 =?utf-8?B?aDFkOG1SOUhoQk5aT09tcE0wT2VOOHB0aUliMjA2b2hKbHhrdStveHUyLzdE?=
 =?utf-8?B?OHFEYXNhRjh0NzJYSkhNZFBsdDBWQUkzYU02UDd4bTBzSVROc3NuY3dIRjN3?=
 =?utf-8?B?aVlUQVhVREU0OGpSY0N4MVJwUUd2MVI2YVYybFlTeFJXS1JjQWsyRG84bnlq?=
 =?utf-8?B?aWhGQW1KZ2JER0xlV1V1S0c1MENJMEg0akFTSTQwQTI1Rk1HTjFIUUhCQ281?=
 =?utf-8?B?TE1LUDV6di9pWGVKNWI5Zmh0VjdBVEdiRklxZG0veW94Qm1rOXpCNkhlWGRi?=
 =?utf-8?B?R3hoK09xeTFuMDd1NVcrQU9lK1k4Q01GZlNEMG9FZzhXWlVLc3JYeU13cWJZ?=
 =?utf-8?B?NGhFcUl3alhuR3Z1QjJOOXVXcVhYV3piSXoyeGJmZTd5WjNjbG1nS3FNVGt2?=
 =?utf-8?B?NEYxS0JSdEw0Y1VKWVJKcmlxeEphT1dXVlRpWTZOTGM4dzJMeE1UTldBWnVw?=
 =?utf-8?B?MnZwQm9DNisrMURGWit6OFlrNllZb2pIdGtvcUNISGVZVVdEQ2VlaEU2WjlY?=
 =?utf-8?B?K0RURjB5NkVNNmRBelZxek9va2FycXRNMHJuNmFJRERBdHQ4aXhwWFdXTngz?=
 =?utf-8?B?NXd2OVkrMTNNU3ZVOS8xTURPcDNpVTY5ZWJzYUcrYk9HaTJSbUI1VUxvUytT?=
 =?utf-8?B?Wnd3cTRpRGNzbFI0SFdDVGx0enV5K2NKWWJXWFRSYVBEZnlsZHNpUHEvbUdC?=
 =?utf-8?B?dHVwWHo3eENVUGJheVIySFZIYXNILzRGMkNYQU1VUFZoajM2eTh4U1dKQk1q?=
 =?utf-8?B?dFNlS2p1ZGhNVlRVQ3dXemc1TjNSRDBtMlJodmVLQjdPcjVQQkwyOXFLcDhh?=
 =?utf-8?B?TlYzQWFxYk5uMW9iQnVCbEdjZ3hCV0JuVGxXY3ZZRVQ0NzM2VzRFb3hlR1BQ?=
 =?utf-8?B?YTdlN1FyRms5SHV2b3BTR29FQng1R1Y4NGN0dTZiZno0dThGczlXeHpSd240?=
 =?utf-8?B?SzJOMTJvR2pBekFyaGt3YlcvL0plTFBLUXNSZHdxTnFaSGJrVkV5YmhxRUNm?=
 =?utf-8?B?Y3VBL3FoYzd1VDNkYmE4Q2xrL1BYOUlENjFnMExFRDV2T1hnR291dG9QcnZz?=
 =?utf-8?B?VVFXaEFia0tPT2YzZlgrM3FFb09tbFc2L0l1dThMZytGSmRidDJXWnluTk9I?=
 =?utf-8?B?d0N3OWhsL2FkTTV3K2FiOW9xU1IvcEJBTisyTWoxYXhZOHYzR2srdlRqcHdu?=
 =?utf-8?B?cUtvaXBxTTVUTEJzUC9wL3JzY2xSZWlKTnVUMVlPK2J3ZEllbU9tM3VVM20x?=
 =?utf-8?B?YzBNekhiQWFWcTF3MWlqbHNGeXBiSXZCZnpBRDM3QmgzVGIzMkRLZDZVQmUz?=
 =?utf-8?B?cHFxdkZJc1JVa2RRbHUzQndhY3hOZFlsMFJJSTlKRTF2OHFxUlo2aVVRSzZY?=
 =?utf-8?B?bi90TEJBSm9qUm9TUXZabXhCajFMTHFOdGR0dzVMZUdnK2VSQ1hCc3lwMHlx?=
 =?utf-8?B?MmZVYm9zY2RqbmVHTzgyaEdURVNVVlZXelJrK2JrK3lOOE9xZlhmekYrQktv?=
 =?utf-8?B?WTZ5L0tNZURkYm1xYXZ1cDAwb0VHbVRYK1Y0aVJTOXpSTlJONHc2MHpDMXdR?=
 =?utf-8?B?TnJJNFpKbE9YNFVVYWVKN1VqMUhVVnQvZ0gyN1Z3MTdwcWt2M3UzQUlEZzIr?=
 =?utf-8?B?NVMwVjNBWGJObEhRc3FRa01IZ1I4cjRidVJvTXJjT0ZsUWthbVljZlNESVh3?=
 =?utf-8?B?akRHb3VzMXlkN1labzBSRVNSRlpvSHR1UDFUaUhzc0YxZUorRDR4YXpYdTJX?=
 =?utf-8?B?UWhhYkRpYmpkdlF2Z1hjSDVIZzJDdGk2cE1Hd0c3S2hURzJDOEhYNDl3a3R0?=
 =?utf-8?B?R2FXbG5FandKRCs1T3RuVE82RGV2VTVLd1dwOGxCTDduNVcxVm8yMnRHb0hp?=
 =?utf-8?B?RTNTNDE1a1FCY1ZHcFc1UWY1bzU5R2JuTm1UOFpJMXU3OEcwdTNpRGp6NTRU?=
 =?utf-8?B?eWNKYy80MFZkRi9jbFNOU1M2ODhHWVNkZmlEQWJtclkwbkorWXI5Q1pXWVNq?=
 =?utf-8?B?cVp5QVR1dmdEbWQrNXA5QTZhY2lsanVJL2ZUSHZzdHZwV09pYitiSkZEOTFy?=
 =?utf-8?B?UHpHT1RjMUNzajVmZXVoc3BIczF2NmZrTVo3cnlVOXl2L0NqVkNKNDhweVNa?=
 =?utf-8?B?SlRqc3RHU1poT1U4VVkyZERPN1Bza3Vidmd2ODR6dDFOaUEzL2tOSjRNVHNF?=
 =?utf-8?B?LzZYeDFGWUdrUFVTTGtoTXljZUJES3JlMUFIV0NtVDJ3QkloSDlZcUhzdlh5?=
 =?utf-8?Q?i2/tqz3p5ECq4rXs=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bee8a9-14c0-4d20-5854-08df1e3ae963
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 15:04:08.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21uhG9b/R4ra6C8ANFKT5BLfL4KkH8HpQPxddDaNoc/BKWwyyUpDoLxsOu8wnXA18+7KYvn59eNldwyTUfirJ5mNYq8wnk2mNYhudnVu7/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT6PR01MB309022
X-Rspam-User: 
X-Stat-Signature: tyuxdxm6n3xnwz995wru9wwihbtbzqqq
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00FE280004
X-HE-Tag: 1790694253-317622
X-HE-Meta: U2FsdGVkX1811p54w0M7LvA4wGfrb0Tpovx/wY+AuVM4E5dlSA1sytCi9Q+e+KpZIU/w/c2c2elI650RAJf2kmFiSAJ1CyxB6ORFNAx8wzi8hNciVP3ueCg2VT8vtk4TfaYq0gt2M/iQXKQISH9ECiYo8logX+OkLO04UZmIdV8reXvzSyI3nE7qXUxgg0g//PnPM5K5+RmbH7tHZTFmp3T9BNlh7Bb/0xelsdm6+4Zal0o7SjgPNZBIeWgCUUd/JObQslYbnpWqXvZ3j4r5hyBua07IQPiHJ5bzbKV8hGuMBvOabKxTaXDy89kStqG3p6t48AmTZaD39ixk0IgXRxMjWAER54IhlTvUEdOi1pzL7uC9gKRVzKTKpfZ4p4sy8pd0HxrVqdHOM7oX9qxUjf+uTGxgHTzVR6g3KLLjm4DygshCy1H5e40SyfcKDVZSFu1Upu/NwGSmujQI+QzB1KfkbywiAw8boNiLKap+DosI8T3ZVGUS5u+rdBwcxlBcyPR2e3+T7vfUhQot+TIPkzKbvOey0IlMD+SpeGyZR73wbXsz0JQJDSgZohG9dnYZf9nhvrzfxuFLwfwD3rQZvfnL8ygqJons0G8HP+BpZkt7DVRNxmDIfTu2b3qHD7VoePBZCyZvFqEJTFFKagQRlqHIczQy82ub39IRpy8qfPMmeTPL/wbRR1pvRDG0KqNjaUynJeYM/Fyb4/bXZ4seMFI+GnJ8G182U/mYjuSIdLcTg41B5dsfETQpIHmGL8Uwvf3xbB+hcQEDNUnPxP1bPy4gYdrXhdgIih8LaC+YGoA9dMA85C45zzJSO3gzzyAYx8vTIHeXWpFpPEmG6R/MIiszZ0scx9VzyNSBG2dskPlRrjZbtfYfmyRoF3ynI5Su7f6Br/8Qs+wu/q/R7LbVIDeta4Az/3YlVwBCrFwWXz1IjK1U1TdIQ2ICdlspgGa1mW06g2JqGU324C9yLhE
 7WIz8LDf
 0UbAXicHmkh7tzuB5YVdT2SjwU2rX7lG8LW/x30+v2dM/A2tzWi8tvZZ6nkUTOpkg6G9YXBM2ylcVt8nVcuynrBK/VhCWm2zYuNNqXjw+jk1mQmPAa5ijAbcYhaic5a8Hl1uWAceTOKZ8Max9PYAdAOUw+JuormNYfae8vtD6GQWuJasN5FQOB9tmMvtwd/TISdOrB+3AtOynRNcSoM/jSnjlnPbcm2bpOnLAT2rrN67j+5BmgSvSB7fSEXyemSv/WFLxaYHa4ULiL87GWVPQaiE/nzG0ZpBPsxXnFVabSui3PDbGtjqebmSUOLyAXbMjYlnDtxUBWSueLm5UzkfxZIVCzGSm2Uohckd4bSvYYrDzYjYfIMQRKTaaW2oDWSEI9nUXb5606ARqecuaPSoETb2zmxxLr3qtR3xYpdErRyKC+PpHLmOvGu126as2FdpHkIZok5goZHUiZ5oO6EJCXLO8oKRbGLQvNAMRQS7q08RTWlkhNHSvO2+rryZl7Cng26M02ugmHn0ff+A3C04VIKRNFFIeFru4F8rlslDttDVQxlBuyA5ei7aU05lZGCI+hc51L5oyvmNHgTmATVLXlZhaXiaWJPQ34iXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-29 10:47, Linus Torvalds wrote:
> On Sun, 27 Sept 2026 at 08:51, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> +static __always_inline
>> +int ptr_eq(const volatile void *a, const volatile void *b)
>> +{
>> +       OPTIMIZER_HIDE_VAR(a);
>> +       OPTIMIZER_HIDE_VAR(b);
>> +       return a == b;
>> +}
> 
> I had to think about why I hate this so much.
> 
> It's probably entirely senseless, but this just rubs me the wrong way.
> Those OPTIMIZER_HIDE_VAR() statements are hiding the wrong thing. They
> are telling the compiler to treat valid information (the pointers) as
> if they had changed, so then the compiler will have to just reload
> those pointers when they are used later (and "used later" is part of
> the whole *point* of this, after all).
> 
> But it was never the pointer values that needed hiding from the
> compiler. It's always just the comparison. And while the "optimal"
> thing would be to just do something like
> 
>    static __always_inline bool ptr_eq(const volatile void *a, const
> volatile void *b)
>    {
>          bool ret;
>          asm("cmpq %0,%1":"=@ccz" (ret):"r" (a),"r"(b))
>          return ret;
>    }
> 
> that is an architecture-specific thing - and then have that
> OPTIMIZER_HIDE_VAR() available as a fallback.
> 
> I don't know if it's really worth it, but I really do despise that
> "hide the wrong values" thing that generates two new values just to
> compare them and throw them away, and adds register pressure for no
> good reason.

I agree that doing it in asm would generate better code. Also, I've
been told that clang now preserves the address dependency in this
scenario, so perhaps we'd want to use preprocessor conditionals to
select how to implement ptr_eq based on:

- architecture (allowing asm implementation overrides),
- compiler (e.g. if compiler is clang >= version X, just do a plain
   comparison). Likewise for gcc if it ever decides to fix this
   behavior.

I think this "hide var" hack is a fallback which can be used as a
starting point, and then we can specialize based on architecture and
compiler.

Or do you prefer this in a different order ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

