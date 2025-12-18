Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA10D6E2AD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 16:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB356B0093; Thu, 18 Dec 2025 11:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2B36B0095; Thu, 18 Dec 2025 11:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569B26B0096; Thu, 18 Dec 2025 11:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44AAC6B0093
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:20:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D53F2135B4C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:20:11 +0000 (UTC)
X-FDA: 84233103822.20.C5355A9
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022109.outbound.protection.outlook.com [40.107.193.109])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA96D10001F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:20:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=oRCK3mgI;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.109 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766074809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vC88EwW7YZ/++9uJJbSvNxlN+AtECnBih5CkZdc+QX8=;
	b=oO9VtXnV5+fxY2c0xn1ybOnx582UbefkCk+TYhpADyX/sP7qZGzGGn467L46z7t3ecZBo3
	5X8yNojpJ6EExCeMXApe8X4lPUtVBv6EJHl8eZshVgWztfamhLcMhoZrTMatsXr5fwbO3d
	cm+wBGY8qfakwx/VD9zNctPQ4MbrPpM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=oRCK3mgI;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.109 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766074809; a=rsa-sha256;
	cv=pass;
	b=65xg83lhhH1H7ei2/ydQRLmAMnL4JuhF1Ea7sZszhq+SXQ8dpOUKEEqXJC5uRXdaGh9LoV
	ZJRNlPUZcvO77rsEGQkaLh0+eNH2CxQG5AdQBA14aJlOkc/UxEtjIbw2H+tFjNXZYpl8vi
	+cBuIPjtuF3hSbbGn8Q6fLlbR3xHMr8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b2RL0iqef4sLreH2q5DBS4b5r3eeJmLnAjUerNixv8ZtpT5AG+d6YlzXPm1bu8npdRkrV9lXKOKBf7g4WtlfAM8+hzyDNCaYAbYAUPj20DNSY70FHwE1Nd4muL8masTEx1AGKlGZH3BvJW97dcbq4CagKKkTk9utT1DuHp8itKb/e9sVoAm5WBcSE7Ikjjq4FvFtpErqUaKN/KrvSDq0uWNIOR034msldJ+kGOLWRH1fGs18pyCacU1r3GrG3uG93IMBJweiiplb3WAlpiVJBzDxLmo0puy+bzJbW+2EC9TSx4zv+9kysVSQ3o5PxXn7eMYyYGUIbAhJQvW2uRxdmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vC88EwW7YZ/++9uJJbSvNxlN+AtECnBih5CkZdc+QX8=;
 b=JaMOHK7jCw3eq/fMFAW+zxZ/lceQdM3DXjCoLZCGDzW3nSf1qZEAMqlYAjoEioJB+zgUSs1h+Dul3HyZnNC6vJXaErlhdJeZKWKqeDvYWKZxDtM2wS2YGbiZxdjTomcMXeOUIjnKQIDwDl9n0NyC6XLNuHMhHw1aahRXs0caJFCSJUKviXi9CPuljWrAvoDPVA4SOh7xxrYd9vMkg+rPpNRBpy0pUKaDhhH2xNVfDFtiVHFaGd3z1dybLDv4GCKV7DnCSVhqJ0U3HyMJG3vhZC8hu5eLUcMsGa29TJk4SxANjSW2zRociwj9vVl9VWcKeyiYoITFMhPg5PK2uXCMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vC88EwW7YZ/++9uJJbSvNxlN+AtECnBih5CkZdc+QX8=;
 b=oRCK3mgIHwbo+WHtuULSAVcwjGlN+zEiEobD5cUstMtDAp5hoW7ud3x56Vw+W7SGIEVCQWuAmvcqFH8RX3hsJ6TeBlhcgOf7sr0uRklVV0xWuoxXzcFqtf/q9eOv0bwCtxsT/6HTfDak02F9JXMmpnKyzEYGto6XLznUDQrkGSuluXXR91tr9QdRnCDF1SD+z/iavrL2+P5VGgGZMA0ZHYC8UzGRUbR3/XY8dMs2fsV8wXxDH3lmzRihZVAVfBlxVxxML5qQS0kUdFQDTHBehXDobCWlEqK9KG/olvQIThhsJOp6h9ccZ0P0HkIYPMm0ZyP9D3Tx2u2PAN9LEy5w8g==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB8592.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:57::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 16:20:04 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 16:20:04 +0000
Message-ID: <37ce5ca2-ba64-4bb9-b752-3239c57ff7aa@efficios.com>
Date: Thu, 18 Dec 2025 11:20:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/4] hazptr: Migrate per-CPU slots to backup slot
 on context switch
To: Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes
 <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
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
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0153.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::14) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB8592:EE_
X-MS-Office365-Filtering-Correlation-Id: 4640cf89-4fd9-4011-6ac4-08de3e514d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SytvWTlDL1IzTjBndER2clVYNGtZem5iSWo4NXFXMUVrMCtFOG9ZWjVKUUM2?=
 =?utf-8?B?OTBJTUpVME0xVjVjQ0pLMFk0dHUxdkdGcWNkVUFmZVE3dkxMa0dHTW01S1FG?=
 =?utf-8?B?K1hGanVILzVid1VtOHdJd296bG1kSmo3K0lkZldKUFlOaW9FMHhaMWwxVWg2?=
 =?utf-8?B?MGlCeCtnUndqTnpKTFFLNERtQ1BxYTEwQ0dJbzlGNnI0R2lBaU04UHlMUUFW?=
 =?utf-8?B?a0d3Sk96U0Zua1J5bVRLbDI3ZUZFRnpZVm9ZWGZJNktkMVY2ZWRIRWIvTU82?=
 =?utf-8?B?a1JPQW05YVhEcFBMdnM1Z1U4cTVDenJ0Y0JINmZvTHk3cVhNSXVBU2h6a0dt?=
 =?utf-8?B?a2VBcjNzTWQ4TXdaMTUvQk0yZEthWUs0eTEwUnNwd3JFZHFXVUJCZnh3bmV6?=
 =?utf-8?B?L3FOV3NlZERjOFdwVWlFRlovekRESmtTRG9GbkNFaFZaQ2pRNU1aY2xpajBC?=
 =?utf-8?B?VlpwYWx0ZEtuUUxhdXFjY01SNjA0RmFocVJPdFlMNjNVdXJQcUVqM2JRK1N1?=
 =?utf-8?B?cWJnU0Z3bFk4SE1UWGNNVWxrcjl3SkF2T3lreDA2WTBORDBhblJQWlNmbzVq?=
 =?utf-8?B?WUYwTTJadlBFZ21DVG1NT0x6cWlCMVBrcFBBNWxoM2RJb3ZYY250T1pFV0lD?=
 =?utf-8?B?aXFlbXlOY3dwSENEVVZUWEt2NXY3TEpuZHJSTGlRVXZ1WFZKUzBWQndKVTV6?=
 =?utf-8?B?UVE5SWpQRE9WdERlbHM3K0RVNmNtMXN1QVRUU3Qyak1Cc21aNW4vL2E2WTJ6?=
 =?utf-8?B?SVZIa1dFZjhLZXRkejc3cUtrbEFBdkVmZEtGQmxnaEFzemxoTXIxenhqTjMy?=
 =?utf-8?B?Y1RiRm9TMStHdlFTRUdIQTNDQTlsM0JCR2xjOHBHNUR3ZW1jeUloNVBGOVZy?=
 =?utf-8?B?dzhLSnJjL04vNFVPVEFqNmVhc0wzTVVRcktnOEVKYjZNdm1kdTNrZkUxYk0w?=
 =?utf-8?B?cFdONnI2dm9mcVRhOUlmMHRjWE4vQnFmaTBVNXVqcURRRFJQckZKUVE0ZkRQ?=
 =?utf-8?B?ZWprN3FRWThKWU1iUFk2bUJnOGdibCs1U0Q3Vk5NME5iV2dna1FGRXpZc2NK?=
 =?utf-8?B?T0tsb2pRNWhCZ3lqTk0xN1E5QmljdG9vNXV5dVVlUEZlTEU3NXZlM25Qc1l0?=
 =?utf-8?B?dlp3dGFvT3d2OHVmeWFnYVhmbHhqUG9tRkV0Zld1OURRSzhZUm5uK1Q4cDNo?=
 =?utf-8?B?QklFTU80QkEzWWdLcTF2SjdTYk9BSVFPVTBDZFY1WlptdkcxaFdWOVhSd0ZD?=
 =?utf-8?B?SVpGcTRWdWxMMlR1aFYxZzBCb0hOL2JUenNEd3Urc2d4WWZIN0dwdHh0VlNs?=
 =?utf-8?B?M1Z4TytBcXQzTk5ET2dLd2xTQ2lCNFFKcXBtOGcyN0hNMFNIVElOZ3AyZEVa?=
 =?utf-8?B?aTAyVk82RXE1dDJvdUZPOUVyeVNxaVlmK1Zsc2REUXQxMVBmV1YyejB6Vmxp?=
 =?utf-8?B?aTV0Wkg4TUhRdWV1Tm1yYjg0N0x6R0Q4SEdocHVsNTE5SC9rVUkwRVkyNVdJ?=
 =?utf-8?B?L1lRNXAvakVBYWpZMGloZzBKUlYwdktOUXp1SDBoNVRHVUNNNGRIUWVrYkZn?=
 =?utf-8?B?MnAwWE9MWkt1clU2T2wvb1JhTzAxUnQzSmYxNnlRcE9kMU53emxHMUdzKzVZ?=
 =?utf-8?B?OXQzUU5PMERwYzZDMWhjSTRvSFhSa0RNQncvblM0eXljQkxrNnlpbjB2RStY?=
 =?utf-8?B?Nk1ObThBaHRQSXR4NFJLRkQ2QWtpQXFMeURQVGJNd1JKVGdOTFhMdUp5OVgx?=
 =?utf-8?B?REFiQlRRQ3lJREJra3lwTGg1VlFyVmVxM3lLWU02YXBPU01QZWNyTEQ3YStV?=
 =?utf-8?B?bjlJNVl6VUJvOUtrN0VubVpYWDJiSzRHY0ZodHpKakVPOXRFK3Rub0hmRi9T?=
 =?utf-8?Q?3wr5ZcQu3f0yR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTNJcEUya2lKSzFDRFNaSWlSRDNWYUZiSnZqak5lb09ZeURkVVRETVgzdzFt?=
 =?utf-8?B?S05FVDNBWUpRTmVkbmdYY21hRVBqVXJISE51a3JwZmtYNVhCSEF5ZnJvTVhk?=
 =?utf-8?B?azJMWmFmZjh2NkU2b1FGWit2Y3p0R3dlLy9EMTRBTFVpdEpDMTdtWEk4Q1NU?=
 =?utf-8?B?bmJlOTBQTC9BZ1NvSVFUZklER3dOSkorajFLeW5Ba0d1SDQvaC9JRVJvRkVP?=
 =?utf-8?B?WTJGck9HREVhQzFxSUtNRDJueUV4OXcvTUVFTjV6Q0I4cGNOeUhmcjBXMWtu?=
 =?utf-8?B?bG9QM2lKbDNiUHFjR2wwZDI0NSsyYzIwbEdMWU9ub1RlazBpMG55NUV1TEl3?=
 =?utf-8?B?Zks1bEZqMjdBSVB5RWNmWFg2MktMcDh2ejVJWXZFbUJ1Ylp3a3oyM0RreCtv?=
 =?utf-8?B?NE9admdtOTE3VVF6VnpLK1NZdmhmQ1V3Vk0ycTBKeElPeFJvNFd2UG1aUkVa?=
 =?utf-8?B?NzY3eVk2Z05oeFpLRXU0RGJmbmVDQzUxOW5qdEFrdkU4eksyemdnWHlSYzlN?=
 =?utf-8?B?MnBsZFE5VnA4YVVubXBqZ3M5dmhHUFNQWDI1Ym52OUptUmFtUGZYSGt3SkNH?=
 =?utf-8?B?VGduUFp6MWVEUWRrRlJaZTR0c0pEVkpWTVlXUHE1cytzWEpsSEZmcE0rUFdQ?=
 =?utf-8?B?TklDTmhIc1l0U24zLzFFNGsrSkR4R2pnbGVxWDhKNHNUR3dXcEo2MkRzYUNS?=
 =?utf-8?B?ZTZhUlY1K25oWUxFRmo2SjM2ZDBpMEM0MWJLM2xwUEwvOTFCYWlqVmRpaCth?=
 =?utf-8?B?YmNkR1RQME5BK1JFVXMxTDY1Rk9hTVdkSlBUWndJUjc1TnVSQWRiU1UrM1oz?=
 =?utf-8?B?N3lQcVNidGMySGlmdlpYV0RYL1V6QjlrUWtMWXRKTnEwdWZOWHNaRGJxNjcw?=
 =?utf-8?B?Nm91UXh2QmhkQmxxenJ6T3lyN3ZJWUY2VjNxUktoS1pNQkF2M202WVhEeEpK?=
 =?utf-8?B?Q0IyTGNSZjBYb01OTXl5Lyt2czFuaC9ibHhhU0tsOEhybHVIT0hSdHpveHZV?=
 =?utf-8?B?bDgvNkF1cDI2Qzl6cTZjN3ZnV3hoNi9DclVCYVo4SFUzZ0JvaUhMeHY4V1VB?=
 =?utf-8?B?d0kxUzM4a21vV1UxQmZIR2Q5ejBEMTRiNWh2ODNJVk01dU9mZmYxaitQdHV4?=
 =?utf-8?B?eEZTOFJ1Y1BKSk5zNHlwNS9pdktzbkk3VldOYTBtMExDOXlHREs3Zm9jSFVT?=
 =?utf-8?B?cTlPd3oyL1E3Q0pLemxFVjc1RTRjMWx1bTJGUkxXcmo2c092S1p0Z3Foazd2?=
 =?utf-8?B?RXlwNmQveUdKSGx1TWlGcXJkT1hsUmdZUWVLWGtLU1VMYXhIWmJCcWtZajgx?=
 =?utf-8?B?cmk2US9lQ0JZZzJsb0JONWlBRUNZQ1VhWW0yRVVZQkxPdjJZQXY5M2RoVVdl?=
 =?utf-8?B?VnJvMUwwc2M1eVVaVmQwS3hlZ1BPMVc3c25OVTk2SWQveFdUd3lVSzJ5b043?=
 =?utf-8?B?MHZMbS93c3pGUGZhaDZIYno3NUlZTTJxMGFLUWt4alZERXU5TGlBekVIWStX?=
 =?utf-8?B?dm1RcHFQUlhPdzRMTm43UDB6WWNYN2didXowNXZzVlFWYzErdUtSYjYrMDBa?=
 =?utf-8?B?RHpqWmFDZGcxU1Z6Z3UvSnpzWnVFS0pMY01aUkNSanVTSzJLZzB2ekZsaHRy?=
 =?utf-8?B?dWRDNWU0SHlBckZGb3J1N01KanN0N3FMbWVVRmxkMlUwSXoxRXdwcHo3eDM4?=
 =?utf-8?B?TE9KOXdWMGRDZzFoZVMvRzZlL1FPUGFCOFNoY1o2UGJTRTR6WmU0NVQ2aWJU?=
 =?utf-8?B?bDZkSGRVUWpVdGxZd3lmRHRCQ3BaNWJCS21NRHNjR01nNm5Zc2FaV2N5b1ZI?=
 =?utf-8?B?VE9SaXpIRVBmODNjK3g3bWE0Q1M2cFloTlNtYXh6TUk2YW1wRlVRYW9iMU9Q?=
 =?utf-8?B?ckF3WmdFbnhUbjNmdXJ2cXZHd1kzWUdTNzRDQmxTMmJKMEtRWXJsMjM4V244?=
 =?utf-8?B?QjlQTWtXb3BGVnFicVpkcWJCelR4NWxZanYrb2t2Nkk5ODlKdWNIUkNscm9B?=
 =?utf-8?B?ME11V20xemNEeTFGWTNxbjA4SDJ3SXRjRkxFeUtyWWdNTDVDVTB3RnZiaGxM?=
 =?utf-8?B?VHlQdG4vbGxQcDMvY2J2RENLWGUySnVqWGFUN2NZTTg0dVpCZzFtSTlYVTlG?=
 =?utf-8?B?QlBCeVdncVp4b21SYk5NMFE4b3JHMnpGK2d0SW9yMEErMk9XNmdPcWJ0SVZE?=
 =?utf-8?Q?vnqY7vvFVKBzOryIB6J2N7E=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4640cf89-4fd9-4011-6ac4-08de3e514d20
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 16:20:04.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xf6h9WpO1mbHu/QNJcZ27ig7hCWCE/AgMSM51+w4x7ehux+zq/4mmdnvonhFs6te55/1XRRci6EIkpQmXR7I4c2dR4pdRnfoZt0ZxtRU6zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB8592
X-Stat-Signature: q88ie5bbx96qic7sdoeby984b383dzmw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA96D10001F
X-HE-Tag: 1766074808-576018
X-HE-Meta: U2FsdGVkX19Oln3Bz7Qc297wAHiUd+sbAMPsnOQPkFFpcgsJIyi/8cYViK2aSJWO3XmueIUnPCTkfhdHLlIcMt3mw2SLlHO0WTVm3Qd7iqUhgFKlVD8XBZuBTxXy0iNNHZraZMwoIjey+ka3nvTvkD7O1iLc1/fyi0VbnFAkpJxHTHW9S5dQphHfSZ7CFMxaxbk0T7FYbZNzGpt7hmtN6RqpBfhkQPkwAWEQ98RDK5cpy6ARyNQMT828kTGInSlAJxdmoGLVgZ7RFd2Nj0FIbwG20XpFB8HHiJyQTVIwgjp8V4OHazoAgJvzk2hHfS/9KMOVDxTblcdH5Dv6I7m+86OOdL0jxKoep2JHweFaRMOVMiC/ch6TY1MU/aTvZHmh4hXlrbmN9iRVaLWwDW5VYuZ4/FFiwzlYudhEzVeVmFFxfqbddyT9OP/RZn1ZpFteyRc8Yi+A+iBHVVKVuF/rgwZ9zipNMCubUWmBZV6DT16Prz/Kn35PE774DYAzcG24HP8ejOh+AEVjraUaipjvcSXL9PUCeHPujyNWwCWoojhEX7y1B9MyNys8edelAXzvUsP761fU5bbqoH9vDn8ck09eNYB9vNzgLTQKOLyEyChj9vkGEeuVwxXbbEZU7CvSqP+Z7WxEvx4sm5957c+buUXp3lzfLB2IphkjJh0c9DPxJiwLdnL9Jx+FMjk3TbI2Yt1hcypyXscHYZGSFmJBjgwMhQt+CW7tPRuTGOKKAzEf0dNMENdw4x+HaHkpbdRrm69Fp8RDcyFdqrnF5yFMAonspdNB2I19/ztd/YQ2FYvB+ksO821XUHmYgbCPijPXSRDR50pS0+U08JwncLmlCw32G2OGcJOQCtpen3y75DXcU992GlyXUAm7YsJFhs2nludxMmjy/whZwIleXxOJKDtZlbChJAClNWviGsRuZW1/zBaQte8WS6bwpLJpfOku2r9fR5/eUX5+8npJrfc
 iMW/bXRw
 tm05Ou688KEymn55nbKNBw5fwTvRswqTGszZFR9pAyvYLcXIpGinadD50WnVn9xNM6dz2HhReKP5ThWU+Lm0dWnI/lcV/2fhELPZoU+MNn5H6IjN7U2HAeOrboi445gIUAorijSGkIvxB6Ke0enSy4UBIc4sBmz6DvZspGXLqyaNIbxkF6pkXIZt3buBJlsfPGnpoOGqMxGdoXytHs9UNlamw1417za54kOVbbYHyNGz0yJyB6GVMDWecbVPe48iYTVgPvEWe1LhtM6Pu+P+cTFHZdHGrtp2v6JYWuMRUDvFn/lV+J+o+1dFDlr88UIfCvECK2CFAlBibcCHlaMkdqwkfIBCwMNT54YyfvItmtSY7xYTFCaH+bryygDVSiar3EaAz4phLB8ksuLdw4GtO46zMOUzedJBJUh7JMlRouk9q8tCfe9msPZMrv4IC2jJCsWk6H5fF7oZE6dej6Q2DhlslXHaOTvUlBgXJYsz9u8mvoFBmB0gK2xz2Texwef7XF6KwuvkCi8TENlQw3aMSaBIwOV3X1K8UHuZ/5bzNCoQdMOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-17 20:45, Mathieu Desnoyers wrote:
[...]
> +static inline
> +void hazptr_note_context_switch(void)
> +{
> +	struct hazptr_ctx *ctx;
> +
> +	list_for_each_entry(ctx, &current->hazptr_ctx_list, preempt_node) {
> +		struct hazptr_slot *slot;
> +
> +		if (hazptr_slot_is_backup(ctx, ctx->slot))
> +			continue;
> +		slot = hazptr_chain_backup_slot(ctx);
> +		/*
> +		 * Move hazard pointer from per-CPU slot to backup slot.
> +		 * This requires hazard pointer synchronize to iterate
> +		 * on per-CPU slots with load-acquire before iterating
> +		 * on the overflow list.
> +		 */
> +		WRITE_ONCE(slot->addr, ctx->slot->addr);
> +		/*
> +		 * store-release orders store to backup slot addr before
> +		 * store to per-CPU slot addr.
> +		 */
> +		smp_store_release(&ctx->slot->addr, NULL);

I missed this:

+               /* Use the backup slot for context. */
+               ctx->slot = slot;

This triggered the hazptr_release WARN_ON_ONCE() within modified
refscale tests.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

