Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F37CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 18:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7878E00F7; Tue, 26 Aug 2025 14:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8E38E00EC; Tue, 26 Aug 2025 14:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B701D8E00F7; Tue, 26 Aug 2025 14:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A43948E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:01:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5159E1A026F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:01:30 +0000 (UTC)
X-FDA: 83819675940.21.8B1C13D
Received: from CAN01-YT3-obe.outbound.protection.outlook.com (mail-yt3can01on2136.outbound.protection.outlook.com [40.107.115.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3911EC001A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:01:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=SSWi586e;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.115.136 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756231287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvsPQ6h6AjFAfgGui8xqt5DP1fsmJdqpxYNRKlmQgTE=;
	b=PW0N8c70ugFxLnek9XldWNm0DrFHTkGlaBl7FRbDOFzcu8L30x+STqSXoxxxnJawcUQxxW
	GL4Yr555CmABDMFZ3/71nEkg+vPccOTwi6q/5x3zXc0kGP+A5NQ0FEyZXgeBiM3nuhxVm0
	WmcJoD8uFxpaHD8wuZI5nNMjYqG0fR4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=SSWi586e;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.115.136 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756231287; a=rsa-sha256;
	cv=pass;
	b=tf0hpfDA3oYWnP4iOa7rhxPWEoYYXWltjAQPy9H0AJySjfBOIapej09kKkMUFgxv3zeIJI
	5PFCk5WUdFGNlLcg3jS7RYVSUvTGTm5fpeD1eBQD5UURWLvnfq151Cp+u+vJWo9tbqJP0n
	AvucCOtyKTCaDGZF9NN90ABq5DzhMvc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2lwdDz/+0LyJruw2FNAJV95LlSZIgYspKU6qrwfoMCPVeV6OZCVRTtaNvFmMrr7VPKtDe3pcUS6bFw8LpNVHxx+tkMwxW4IyoW4EzsY1ketYsZAsKTfoiIT7PyBnBzX2nm7y3L2lpEIm3kIWvdzXlli4FoEmCVneTHUeYeUMr77+8KIjCXOp238cQUrao68Uun3QQBQ9Rlzl/zCfAC5qKtNRLqCnif52/8Xu1SJQbVSCk5EJxQ+n6t0LY7b/fDJfCs+e1hlob9HbNxr+hGIY1uIVigvoD7m1qrV2S/fMwzpzpFbXTX/Wd4PTFI1+KDdE5vo0XhFO74c/96JZJbYtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvsPQ6h6AjFAfgGui8xqt5DP1fsmJdqpxYNRKlmQgTE=;
 b=Fn7oIlicMyKY9Mjac9Vlv6fABQzDfIl4Ik9Lqr8wlKyi5WuHtI+Nh3tT0FDcw6JcpPhOxH68cEUGpSPRYJf4Ho35EVUPVkuwRCRQmqwfVWkYkIpvNK26YYYrszC/9xNBU506Hse7mYnQI8yAJCgUvXqEiU8tJyksEGbrFNoV+gFXwjfA1T6VuJfC7rFz62vcr53hkBm+UkZeTNHdmE92WGaci1iUXb890a67tePGp2dWovMv6Qems0x60qWCvGnqbvcoBur2cVAgCtwY1sZNY8tWjBFdeGVvds0qe9NaCVOIvOBXvNHCb0HJtq8wt1F4neym8ahr8k/kLxWW6cr3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvsPQ6h6AjFAfgGui8xqt5DP1fsmJdqpxYNRKlmQgTE=;
 b=SSWi586eu5+K8ENIEJOihVn8yKK3D/9k+R5k+zyt3jGcdrJocytxt4rVtedxZAMw/lNcp2S6LvjOLQBfVUE7TfWkFDJvFFLXrygeQ8MPnxHaKdyWtMC7v5D3OyKV1JWJrRhj/bmTo8Lu7sokZpYwE5u82FH5oYkf/gKUD3rXMG2iw65kUV3B3hBY8DnHpDUUXCCZMu687rXdNAkaN89jQiKNcoWH4z4B8P9lhka1Rwo8oQ5MS9G4LLJtNNqkITrciwEII3ZreSOOJ+cGoXF6WS4ftnE2cADVyf/Q1Dfmysi87dNa8lfWQxwOtJdeNdBHrls9PoPwUXwTYZk+x/pMGA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by TO1PPFFCB747AAC.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b08::6ac) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 18:01:15 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%3]) with mapi id 15.20.9052.021; Tue, 26 Aug 2025
 18:01:14 +0000
Message-ID: <d5183516-92ea-4a76-9506-2f7e4da0b0ad@efficios.com>
Date: Tue, 26 Aug 2025 14:01:12 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] rseq: Run the mm_cid_compaction from
 rseq_handle_notify_resume()
To: Gabriele Monaco <gmonaco@redhat.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney"
 <paulmck@kernel.org>, linux-mm@kvack.org,
 Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.org>
References: <20250716160603.138385-6-gmonaco@redhat.com>
 <20250716160603.138385-8-gmonaco@redhat.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20250716160603.138385-8-gmonaco@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBP288CA0009.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::7) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|TO1PPFFCB747AAC:EE_
X-MS-Office365-Filtering-Correlation-Id: 2215fc70-1ed6-410c-df45-08dde4ca8beb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDNkTG9RUVZsWDB0UTRyTlRxN1loYTl2MmdETUdPcG5MUmh4dzcwL2hxVEFx?=
 =?utf-8?B?d1Y4eTIrNHRLVTBNUEtZejNCOWlrUitvZ0VSaXNWZ3ZoaDZ5dksyK0c1Wjl1?=
 =?utf-8?B?MG5ZR1FkaHlmN2NsL1crWGVDMWRvNE42OWQvd3ZCbFkwQkpkK3VNSGtHZFRT?=
 =?utf-8?B?U1c5L0dKUnZTcFdkeFdqdnhCR1hRWEdOTXZBQkI5aTRyeHhqL0x3b3BGd2FR?=
 =?utf-8?B?NjN1TVNMY04zRGZucDBJMUVMNFgxbXMrZHZvUTVPVjBBYjljUERPRnV1VGhi?=
 =?utf-8?B?Qm1lWTU5dUhRc0pvVDVyZWo4SU9OTi8vS1BQL3hvNUY1azYzOU1HWVM3YUNY?=
 =?utf-8?B?UUVkbXkwQ1BUVlhqM2cxWTd2VEtjTnVCc1AyZ3Z5Y0pUUXlVQzh0WWRGeXkz?=
 =?utf-8?B?Vk1ReHNZQWlqWkVrcUhzeEdLajI5cloxU2F5THpsNXJXVldrSDlsL3JCWFJz?=
 =?utf-8?B?d0dHT0ppOTJqemIrcHdNMCtQMDRaR2g0YmR6QlUwMVUzT0FFZXYvbVljU3dC?=
 =?utf-8?B?UG5Ka0ZkQWozQ09mZ1hXUzdiQldoeUZRZUlQNUlucm1TZ3F1TnRLSUxxNDJS?=
 =?utf-8?B?NERrMFNyZ1g5VzlJTjJGT0M3ZXRQNVIxaVNsRkNqU0owVEtxcjlqL2VGNElK?=
 =?utf-8?B?cjhEZm5DQlB3UlFveVpaYkRsZm9wRldmV05wVTUvdGdsWnlPRVZsVFRyUUY4?=
 =?utf-8?B?TTZ4WDRPSVk3M0JjLzVtaFVIMlRKSXpIcFBOTnE2QnVvZ0x4TzU1WU1jQ3J0?=
 =?utf-8?B?MXBPUUpPc3RsSklaSTRPUzY5RFd5bTFuc2FiZlprS2prUXNUKzhJYS9nOGQx?=
 =?utf-8?B?UHQ0dTZPVEF4UWhTK3luZm1XYnRhT1RmemRMejIydTZmK2UrVytRbkFuNGN6?=
 =?utf-8?B?L2s5SjBnWWkvRzNQVE5xb1pVdlJWVTVVSm9HenVnMk5qbExzRWp1RFlRbzNX?=
 =?utf-8?B?eEtGWFFIclpYNUhsOE1nYW9odkM0czB6VWNucmVvbjBFcW9McW5sUm9zejBn?=
 =?utf-8?B?YnZWSUZSbVFWQXV3K0V6RW1EcTlaZXM2ZjF4M0lqM000cHdCQWxXT2k5NGJC?=
 =?utf-8?B?VGVYRVYzZWtVYis1cEQyQ0hEbXQxaHgvbXZlUzRLcTNEbmRIOTF2OGRaZERC?=
 =?utf-8?B?b3RrNTB3b1diS01xZThuR2RaQVdNNDBaYmFnWGUwRktXYW8rcFJWeW1CM3FX?=
 =?utf-8?B?VG5IekdGN09mMDJUL0F0NWZtenQ4QlhTM2RLTTErbFVQREZtbnVjM1Q4RTZW?=
 =?utf-8?B?c0JHYUlyQTlVZ2Vxb2NlT0dqa3ZWU2x5WDNDTTJJcExTN3p1WmJ1Rzc2QVBK?=
 =?utf-8?B?SjJtbmcyTmIvbzQzcUtHNGVnbzRoOURxcldBZFp6ZGpYZGR3ZCtHaWthMTRm?=
 =?utf-8?B?UXJHKzd2SzZoUVp6L09yUjB6MDRoWmI0MzhjQ21nL1V2Y1RaTTJRWUdzRndG?=
 =?utf-8?B?dGxpTWpOSHVxcmVWYlhtMlJHa1hIZzVPaDlIOE5nTWJ3UVBlRS8zeTk2T2dM?=
 =?utf-8?B?dnB5UHRyck12ajBlNDlFYkRTYUpzZXA3NFY2QnlPRkp1Zk1xNnBKZnZncS9L?=
 =?utf-8?B?VWN5bm5pZm5pU0RSVzNDeXA4R3J4WCtlMU5Ecmx2Ujd2bG9COU45dUFVbFlR?=
 =?utf-8?B?blVtWFY3Y01oNy9oVExZaUlsZkxoTGVJS3d5YTdGL1BGbUVXZGFiUWU1Z1Vp?=
 =?utf-8?B?bkcxRG1WWXVlQmNPOXpLVHRaRHBVRDhYMndqTXB0NXgxV01zN2ptS3hndk82?=
 =?utf-8?B?M3VZYTRVcWtkQ1NnWGxmSk91MDFyaXlNaStpYkorSkhDd3hhV0JPSmxyb0pq?=
 =?utf-8?Q?Q3iVaXbg8nKZOZUzJyRfJQhyHlg1vaND8J1TE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkhwTWM2Zkw0bG5ramd6ZXdqd2t3d1o4Uk0zL1hiNU9mZ0FDNGVWdXM4RHhn?=
 =?utf-8?B?Yld2UDdXSmdTRjBhK2dxLzI1WDcwZWpjVFVZWHptL0xSc0Z2VHBNR05MelJO?=
 =?utf-8?B?MnR4Z3hkcTBGWlBWdldSYkxNNkxXVG9oUjVya0xzQVFNUHZtN1lRSnpiM0Yy?=
 =?utf-8?B?M2czcEFiQ3ZnUDU0TEZUTFZ6a1ZLVjVmQ0t6OUlkNW9zbS96L0t6RFlHREh0?=
 =?utf-8?B?Z3ZQR1E0aDNOQThhOHc1RlJseFExNXkyM3VtN3Y1cUJSKzF2aDV4SUZUd2Vu?=
 =?utf-8?B?ZVk0cDcwdFZxZDhSc1V4azAxRjRyVURiN213ZjArc1hqejdqTHFxV2V4cHFP?=
 =?utf-8?B?U1lPajRTMEJra0VyTEM2cHhINXczL3ZDNTQ4RUU1R2FJUGsyY1ByQVk3SVoz?=
 =?utf-8?B?NEF3WFZDbHJlNkVyUVZuelpGeTM4VlpBYVN4RUNZek1pNFlBQWNEQzV0cDFV?=
 =?utf-8?B?RjZQRGYycExiUXVUODlvVnE1eDZMYWpmTXlJTllnM1Vqd0JNbFM1a0NnZkxn?=
 =?utf-8?B?SGpOOUI5ZGFwUDRUOFpyTmFlTzR0c3A3RnlWZmxkaE9zazE3VjRwRWFIallm?=
 =?utf-8?B?dHA3WW5HMXhSQmZDZG1PRm9ieENzUTFqSjh5R1paSGFrNW5kYVlEZ1Q5RUFs?=
 =?utf-8?B?eGRUK0FoNDR2R0xpdnNzWnhCMXhnUDhvMjNkZXF6K1F2Unp3QkFrbGFVbEl0?=
 =?utf-8?B?Q3prZkV6ZDlsT0FrOWFDcmVjMkIrUkt5aWozeWowWll1blBWVXlGOUFGa1Fx?=
 =?utf-8?B?NXpzZVhiQ3Nka2h2K0d6ZDZWVGVKWE50WHF5TlhLZFlFNExvRlVJT2VTQmxr?=
 =?utf-8?B?NnZJWXo3a2NuZVdHOG5zUXZ3OElqcUc0WnRnelNKNHFQVGV6Y3BVcFlnM1gz?=
 =?utf-8?B?TkFtQ3dtbCtZdlVkajhsalgwVS92dkZsZ3Qxd1J5OGpMeGJucmxkYXhqTzd4?=
 =?utf-8?B?YWtheUk2Q2dJMlFtWmFmWFdDS1Q4dHp1d3psMlB4b2ZtVSt6YjNyeHQ0ZEVq?=
 =?utf-8?B?NDJuMGs3WDFzRlZLVVZsRE5LNzlRc2V4cVN0c0Fka3JWRDN0MzFaeVRYRjJL?=
 =?utf-8?B?bDhzRzVkbVV4bUJZMkg0dlVCOGliQ0xBNDM3YkFDSjNzWGMxaU9pYjlwZlZr?=
 =?utf-8?B?YXpReGkyWUlGZTQzelVzb2VxT0YrWnhMczR0ZEtkV0x2Z3NiV0tPQUVBRG5t?=
 =?utf-8?B?WitmOHN3TS9ZUUdxTEsvQjc3NnhhRHpwZUd0cWFXbzVKL1FoTndpZDZDMWsy?=
 =?utf-8?B?ODFZTVBHejJaVWZuRFB3Q0sxdDYxTE03QTMwRit5VlNoZHArbXNnRlNvZkJC?=
 =?utf-8?B?b1pHcXMvMk5Kbi9CQ0tseEpzeEZ1SWVZYUpIQWZIZmJuVDNpVkFQMTNDbENj?=
 =?utf-8?B?bENvMDg1dDVwRnE1cUc3T1U2S0dURDRUZVJxYmd5SFFIZDFvRHl0Y095QlJG?=
 =?utf-8?B?K2ZsamVyQzl1Yitla0FWZzFQc3JpNEVwbERhM3I1bHBXbXR6cm85N1ZCM2Fi?=
 =?utf-8?B?eG9IRCtwYzFVOHdhMUR5andCekxuYVd1WXlVeDE4UkhkY21yWHNOMllXdnpP?=
 =?utf-8?B?cHBIT1RKU1JHMFpWNXpLYXZpcWhmNmZqeGs1bXNFRVJqYXUremtHcllCaXY3?=
 =?utf-8?B?WkRId0N4ZGZ4ZFpsZXhCd0pXdm84elY3TnczaG56TDIrcEs1RlEwVjdmNy94?=
 =?utf-8?B?b2xOUEw1MVRqKzErNnU1enA5S1NBeWhPcXVkY0JtZzY2anVtQWR1THU0Q1B5?=
 =?utf-8?B?bFdEOEk4UWxRYXB3Zks0L1hybWYyTkJJajQzcWZ6aWtCK2VVTkdRdDhGQXZY?=
 =?utf-8?B?RDhNaThlWHo5ZlVNVEVDSE5kbHNkTW9reDlxSGpMQUFlTHlQQjNITEZIVnNx?=
 =?utf-8?B?S2pLVk8xK01jQ2JkaXB5WFRvc1l6clNueVQ2dVBCdXpYQy80MDVnNWRzaGNy?=
 =?utf-8?B?YnpTMndmdDhUTWUzajFsazc0dFBSNEM1VnovSWNNYTMxSHdJVm0xMHVsYWVq?=
 =?utf-8?B?UEd0Q2ZsK3B2bzlSRWV6ajkyVjU3L1BCWGpUcnVZYWgxTWNNa1cyRmdYYmNS?=
 =?utf-8?B?bnhQMWVYTzVrS25RNUhaQmFJRVI4YWQ2K00vZWhvVWJuaVk0bVJJWGN4UXhk?=
 =?utf-8?B?MUlHV21MNkRrWU1sRXppbFpVN3psQzBwYUMxbXkrait3dHZhMWpWbjROck4v?=
 =?utf-8?Q?UVcyFQwNtRPiHa97CgjPenM=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2215fc70-1ed6-410c-df45-08dde4ca8beb
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 18:01:14.0323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFY6sXXz9MBtxOhJVayEakUo1h4pkK1qVUPJidDkNbih52MuUQ/zGVm+9h6WKuQ3nPgKikkVruZRJw7cjbPQgA08Lw51VzsqBr2imiKV2i4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TO1PPFFCB747AAC
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3911EC001A
X-Stat-Signature: kjuwufy1ipi71c1omsg1g9zfhc46kixb
X-Rspam-User: 
X-HE-Tag: 1756231286-288374
X-HE-Meta: U2FsdGVkX19JT9Gmk+UDLgJv04Vum+JJKIgj3r7M5KIeh1r9CYBR7hZosCIRGaGgkPEZz/0N2HlUkN8ALcpQ7085pAsPrXNnGdpZQ7s9wWi5vhEgWEhbm3wVc6pBCSz7MT5uUBW6YjAXOb6PuGXpmN/yMP+Ges2dMtaEVpSp5ZTKAPg2yHxObVOlaBE9pk7CD2K3byXUBWUw3/6WGB/P37OXnyB0VJM3CvzmMnlL2KmwP18qPuRhkQkgdECJfjX28HfLeKQrQCia0xBrdegSxqJ2MdK01ET4vvAKbvUURzGUQyFOtjQ5RY2MVvI9UniUxfgg2v4jyItmqf/WQ1Pgu0N5WpnsZFsp9IQVyKnN0iHOKhKAkVw4hJjSmlT4oQTuq1KOsXHFjlwJKvWfxGnWoR3+NZCMdAqoIdOxD6xSu44+peIBh1jLz0XFZQ6pc5HEvgFQWAaE/6U+ZwWbE4//IZLHqkxoKxPaP4Bi7Qqi/rCv+tpFNgvLN7qNBH20YBv5+hI0EIewUQtX8bdGxrAjWQHw/PnmTo8pXW28WomNfAm3VDZbVIJ7aiBAzH4tFc179qF2omoKM9Mx8CkSktUIlNUL3lV7JHj7xwZJYb/cd//8L2JIc1g2E3y6y0MpszJU+qNDHt/6pQ2CuzE2xCzeVAN2VRllJiZZbjyXee9iRyptXuyornLRzCR5IIy9BaNp972id/meQscSLusx55KcxYRaybIKy/b82HVSzqs8aeb6xiWm3Uxe07gD9l6MgbBjPmcpIHUKuy5wSTeQ7rmrbAaYx7s6vmAZO3JpnBu6ODc1Zt7WCZesaipw9+3LrIfVczjbT4AtHbQcN2XKR+OYPxcAkxTURN4pK+gDp2XoTld63sdYAIF7HHYUFq7JA9M4lh04q0liVcn0Gw+0aOsdnDjpOLznESDtl58ZNR1bzUAeRfnHRdURmK9lSrGeMTHFTduAV4Wl5X3xPIhxmvp
 naO3gW4g
 3zseCg2MuGHb6fGDVERdceNUuEne67DBnp9sYg+wD2SLegvn+qG9+BXlQybFT68aX3i4T6iSO5gdhHKfbwUE5zZ8W3acZ/Vvp3yR4ieJ8KBNbJeooQWmaAZgVN1k3LZX1NacRMTw1Uy9B3k5y+JMVr410BAb6AHeZTuBheITIIM3BIUZY60qXWXC+wxuFyDGhdq9UH1lpLESiImFXDDUCshK5du4DRFqX6Kiux8hxV1jP95tD7lNiU53W5uQYgK5bY5OZTuSl1ohvmQTc50Pl9BcawKSnPSxZy4Lg/sULrgU7eHwq7kdnfsHF+kGkRJMH9brqnItgrVmRru6hasvMD++ScqL65yO5e7ckZhFK/r61wUo5/4vhaj/uUSGFtXF/D1rmzJpALZoFbdG21GrGAnivl9HIhR3axHjaQPHLXORjBUPkUXNWmohjf0VbcfO7c0W1D7lrGMwoJLkJZG8yIrI4Rc3eWYgPZy9Yz0tZJtwZTjCEINh5Lewsb2hXz3SniauxHGpRSOagERfWD53g4H4jdSAIhr5LrJqT42EIe8ro/p6tIjyySBSeNjyMkOprfM2FEK8TduoyJee3UCAjHsoBdR8Hi5edcv+aX1YxIuXuc4lAgNf+yVVeFdDZlIgir+AWNIn7tGqoZGvelr2Bx6T5nW7A+CwrxxGLFESsJX9Aqe3OdnQYApycqapKwIs1tGVx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-07-16 12:06, Gabriele Monaco wrote:
> Currently the mm_cid_compaction is triggered by the scheduler tick and
> runs in a task_work, behaviour is more unpredictable with periodic tasks
> with short runtime, which may rarely run during a tick.
> 
> Run the mm_cid_compaction from the rseq_handle_notify_resume() call,
> which runs from resume_user_mode_work. Since the context is the same
> where the task_work would run, skip this step and call the compaction
> function directly.
> The compaction function still exits prematurely in case the scan is not
> required, that is when the pseudo-period of 100ms did not elapse.
> 
> Keep a tick handler used for long running tasks that are never preempted
> (i.e. that never call rseq_handle_notify_resume), which triggers a
> compaction and mm_cid update only in that case.

Your approach looks good, but please note that this will probably
need to be rebased on top of the rseq rework from Thomas Gleixner.

Latest version can be found here:

https://lore.kernel.org/lkml/20250823161326.635281786@linutronix.de/

Thanks,

Mathieu

> 
> Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
> ---
>   include/linux/mm.h       |  2 ++
>   include/linux/mm_types.h | 11 ++++++++
>   include/linux/sched.h    |  2 +-
>   kernel/rseq.c            |  2 ++
>   kernel/sched/core.c      | 55 +++++++++++++++++++++++++---------------
>   kernel/sched/sched.h     |  2 ++
>   6 files changed, 53 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fa538feaa8d95..cc8c1c9ae26c1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2294,6 +2294,7 @@ void sched_mm_cid_before_execve(struct task_struct *t);
>   void sched_mm_cid_after_execve(struct task_struct *t);
>   void sched_mm_cid_fork(struct task_struct *t);
>   void sched_mm_cid_exit_signals(struct task_struct *t);
> +void task_mm_cid_work(struct task_struct *t);
>   static inline int task_mm_cid(struct task_struct *t)
>   {
>   	return t->mm_cid;
> @@ -2303,6 +2304,7 @@ static inline void sched_mm_cid_before_execve(struct task_struct *t) { }
>   static inline void sched_mm_cid_after_execve(struct task_struct *t) { }
>   static inline void sched_mm_cid_fork(struct task_struct *t) { }
>   static inline void sched_mm_cid_exit_signals(struct task_struct *t) { }
> +static inline void task_mm_cid_work(struct task_struct *t) { }
>   static inline int task_mm_cid(struct task_struct *t)
>   {
>   	/*
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index d6b91e8a66d6d..e6d6e468e64b4 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1420,6 +1420,13 @@ static inline void mm_set_cpus_allowed(struct mm_struct *mm, const struct cpumas
>   	WRITE_ONCE(mm->nr_cpus_allowed, cpumask_weight(mm_allowed));
>   	raw_spin_unlock(&mm->cpus_allowed_lock);
>   }
> +
> +static inline bool mm_cid_needs_scan(struct mm_struct *mm)
> +{
> +	if (!mm)
> +		return false;
> +	return time_after(jiffies, READ_ONCE(mm->mm_cid_next_scan));
> +}
>   #else /* CONFIG_SCHED_MM_CID */
>   static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p) { }
>   static inline int mm_alloc_cid(struct mm_struct *mm, struct task_struct *p) { return 0; }
> @@ -1430,6 +1437,10 @@ static inline unsigned int mm_cid_size(void)
>   	return 0;
>   }
>   static inline void mm_set_cpus_allowed(struct mm_struct *mm, const struct cpumask *cpumask) { }
> +static inline bool mm_cid_needs_scan(struct mm_struct *mm)
> +{
> +	return false;
> +}
>   #endif /* CONFIG_SCHED_MM_CID */
>   
>   struct mmu_gather;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index aa9c5be7a6325..a75f61cea2271 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1428,7 +1428,7 @@ struct task_struct {
>   	int				last_mm_cid;	/* Most recent cid in mm */
>   	int				migrate_from_cpu;
>   	int				mm_cid_active;	/* Whether cid bitmap is active */
> -	struct callback_head		cid_work;
> +	unsigned long			last_cid_reset;	/* Time of last reset in jiffies */
>   #endif
>   
>   	struct tlbflush_unmap_batch	tlb_ubc;
> diff --git a/kernel/rseq.c b/kernel/rseq.c
> index b7a1ec327e811..100f81e330dc6 100644
> --- a/kernel/rseq.c
> +++ b/kernel/rseq.c
> @@ -441,6 +441,8 @@ void __rseq_handle_notify_resume(struct ksignal *ksig, struct pt_regs *regs)
>   	}
>   	if (unlikely(rseq_update_cpu_node_id(t)))
>   		goto error;
> +	/* The mm_cid compaction returns prematurely if scan is not needed. */
> +	task_mm_cid_work(t);
>   	return;
>   
>   error:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 81c6df746df17..27b856a1cb0a9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -10589,22 +10589,13 @@ static void sched_mm_cid_remote_clear_weight(struct mm_struct *mm, int cpu,
>   	sched_mm_cid_remote_clear(mm, pcpu_cid, cpu);
>   }
>   
> -static void task_mm_cid_work(struct callback_head *work)
> +void task_mm_cid_work(struct task_struct *t)
>   {
>   	unsigned long now = jiffies, old_scan, next_scan;
> -	struct task_struct *t = current;
>   	struct cpumask *cidmask;
> -	struct mm_struct *mm;
>   	int weight, cpu;
> +	struct mm_struct *mm = t->mm;
>   
> -	WARN_ON_ONCE(t != container_of(work, struct task_struct, cid_work));
> -
> -	work->next = work;	/* Prevent double-add */
> -	if (t->flags & PF_EXITING)
> -		return;
> -	mm = t->mm;
> -	if (!mm)
> -		return;
>   	old_scan = READ_ONCE(mm->mm_cid_next_scan);
>   	next_scan = now + msecs_to_jiffies(MM_CID_SCAN_DELAY);
>   	if (!old_scan) {
> @@ -10643,23 +10634,47 @@ void init_sched_mm_cid(struct task_struct *t)
>   		if (mm_users == 1)
>   			mm->mm_cid_next_scan = jiffies + msecs_to_jiffies(MM_CID_SCAN_DELAY);
>   	}
> -	t->cid_work.next = &t->cid_work;	/* Protect against double add */
> -	init_task_work(&t->cid_work, task_mm_cid_work);
>   }
>   
>   void task_tick_mm_cid(struct rq *rq, struct task_struct *curr)
>   {
> -	struct callback_head *work = &curr->cid_work;
> -	unsigned long now = jiffies;
> +	u64 rtime = curr->se.sum_exec_runtime - curr->se.prev_sum_exec_runtime;
>   
> +	/*
> +	 * If a task is running unpreempted for a long time, it won't get its
> +	 * mm_cid compacted and won't update its mm_cid value after a
> +	 * compaction occurs.
> +	 * For such a task, this function does two things:
> +	 * A) trigger the mm_cid recompaction,
> +	 * B) trigger an update of the task's rseq->mm_cid field at some point
> +	 * after recompaction, so it can get a mm_cid value closer to 0.
> +	 * A change in the mm_cid triggers an rseq_preempt.
> +	 *
> +	 * B occurs once after the compaction work completes, neither A nor B
> +	 * run as long as the compaction work is pending, the task is exiting
> +	 * or is not a userspace task.
> +	 */
>   	if (!curr->mm || (curr->flags & (PF_EXITING | PF_KTHREAD)) ||
> -	    work->next != work)
> +	    test_tsk_thread_flag(curr, TIF_NOTIFY_RESUME))
>   		return;
> -	if (time_before(now, READ_ONCE(curr->mm->mm_cid_next_scan)))
> +	if (rtime < RSEQ_UNPREEMPTED_THRESHOLD)
>   		return;
> -
> -	/* No page allocation under rq lock */
> -	task_work_add(curr, work, TWA_RESUME);
> +	if (mm_cid_needs_scan(curr->mm)) {
> +		/* Trigger mm_cid recompaction */
> +		rseq_set_notify_resume(curr);
> +	} else if (time_after(jiffies, curr->last_cid_reset +
> +			      msecs_to_jiffies(MM_CID_SCAN_DELAY))) {
> +		/* Update mm_cid field */
> +		int old_cid = curr->mm_cid;
> +
> +		if (!curr->mm_cid_active)
> +			return;
> +		mm_cid_snapshot_time(rq, curr->mm);
> +		mm_cid_put_lazy(curr);
> +		curr->last_mm_cid = curr->mm_cid = mm_cid_get(rq, curr, curr->mm);
> +		if (old_cid != curr->mm_cid)
> +			rseq_preempt(curr);
> +	}
>   }
>   
>   void sched_mm_cid_exit_signals(struct task_struct *t)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 475bb5998295e..90a5b58188232 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -3606,6 +3606,7 @@ extern const char *preempt_modes[];
>   
>   #define SCHED_MM_CID_PERIOD_NS	(100ULL * 1000000)	/* 100ms */
>   #define MM_CID_SCAN_DELAY	100			/* 100ms */
> +#define RSEQ_UNPREEMPTED_THRESHOLD	SCHED_MM_CID_PERIOD_NS
>   
>   extern raw_spinlock_t cid_lock;
>   extern int use_cid_lock;
> @@ -3809,6 +3810,7 @@ static inline int mm_cid_get(struct rq *rq, struct task_struct *t,
>   	int cid;
>   
>   	lockdep_assert_rq_held(rq);
> +	t->last_cid_reset = jiffies;
>   	cpumask = mm_cidmask(mm);
>   	cid = __this_cpu_read(pcpu_cid->cid);
>   	if (mm_cid_is_valid(cid)) {


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

