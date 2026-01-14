Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAADD30CF6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C756B6B0088; Tue, 13 Jan 2026 20:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DA96B0089; Tue, 13 Jan 2026 20:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5FA6B008A; Tue, 13 Jan 2026 20:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0C66B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:22:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 295C01ACA2D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:22:25 +0000 (UTC)
X-FDA: 84328819050.05.23F1A35
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020141.outbound.protection.outlook.com [52.101.189.141])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B4D940003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:22:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=QNTdMk+3;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.141 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768353742; a=rsa-sha256;
	cv=pass;
	b=bkGRd3Tgn8leB0T8AsiflfPkWwAdkuwyh3/vfQ4TIHtebUKpq/vNDoJOKIx8qcnwNXd6L2
	M8vE3N7mnS3zVP/+ujE4r6/BR9KhY7MmKE339fRFLwIvd8c+KVahMf2hyl7s7LHapX/d+M
	Kbc0O6/YSVMXbLELLYOexb3Pd6XR/PM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=QNTdMk+3;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.141 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768353742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDUzEzvfpg/U9Jlhdg7Dq9u8gt4LzLODtj2D4cHboLU=;
	b=PAyg/FuOk0JjuGm5s2JJ/uFGtVG321dK7LSUdJfhvATrL4a+ZO/4hDn9KLRGsF+PpwPqEe
	9ymcb1mzEX26G3hDv2Tl3e3IGFfZmYf3C4GQIoSzUCdEMDSanNmCdVZU21r6bCt9MXeN1a
	nbGt/yl/HMpLoSow33VbuIvFzAZu2Xk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRzpv/ALRlg/QUsD2Bb8s7OyH0MHQ8FQ5Y7j1eYVNb3JsLd/nPUTvajwM9QCExGwzObONoVx8YJ8TR3fbEaMcrLJ+xwXGQkEVgCE0hUZ9d84PJoGaCcbK+iJwIeLHqBxIIHReihLmviLWP0A3esltoJunt/aj/qWAgRljC5PQzEnSCo5bf6FJm/ZTm4c8jXRITlKJs5W4VEeGnlUWLyZkR6KOmMeemncLEOPzFBwOmoGPyF4oU39Wa5SwWZywK3PZybQ9GYt+qixCUMqg+xcz1KwhEAEclp33rInt6AY2aTm5hY/teVqJbh8IPUUis9gJpxgsAWL8Farz07NnjbqTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDUzEzvfpg/U9Jlhdg7Dq9u8gt4LzLODtj2D4cHboLU=;
 b=qyPNcURn5SkIWO3Ew51ombeJmeaL35NFVXpLbMP3ppbzkzYU9T4QUjl3W3V6CjihOhlPpAbzXmLwxJXKTPKQQ/MBjr7S1YmrZxHaI4tudCGhwSlkfqkrst4HM7vM1Pgc8OKqI4cHwFOHgFZW7AcTSo0m/hcHw63MKu2SuLBFEhWcyyL0iNizNeeeYR1FiRCONd5g1qyXzfBy5/c/3E9RfGQDLhr1FOb6KyCEIY4k4LS8akLlsDqt5XK4m5uVAv9pibxXWK3XO3EidIVsJ+6O3odztjCEJCtRtp1HFMC4vk4QloCUP06iKXeY1cLz4I95XmojJi3PocpXmAfSxkztRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDUzEzvfpg/U9Jlhdg7Dq9u8gt4LzLODtj2D4cHboLU=;
 b=QNTdMk+3Hikwih+IVaBawhLW4jHbpLnLI5mOTXMBYz7fzXMxZTRn2tWbHD+x1f2gcGJ7xvADpZAo4zpG9aPUTWOAEarz08ii7Y79DroR5qjLY+w7XVT9hJBLFLOIuxPLduJmO0btwmDxhc1EJh+VZieiGdCflB2coGESJtwd2owYF11ArGznGBUv2qC22G4eXiD9XwkTVrYpvryhLYtIYVzekb9LChQ4b/8llkUNojZL22ZIbwTOZayORHzkuMzymWgcCQej2WSCOJ0D+hrZLUKVmDchj1OtMPRaSaKaPeXy8mpH2QIgNevUwzoqtuQBJkHA9fF1jbxvgGn3HzV+Zw==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB5229.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:61::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.8; Wed, 14 Jan
 2026 01:22:18 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.008; Wed, 14 Jan 2026
 01:22:18 +0000
Message-ID: <162c241c-8dd9-4700-a538-0a308de2de8d@efficios.com>
Date: Tue, 13 Jan 2026 20:22:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on
 large many-core systems
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
 <20260113194734.28983-2-mathieu.desnoyers@efficios.com>
 <20260113134644.9030ba1504b8ea41ec91a3be@linux-foundation.org>
 <c5d48b86-6b8e-4695-bbfa-a308d59eba52@efficios.com>
 <20260113155541.1da4b93e2acbb2b4f2cda758@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260113155541.1da4b93e2acbb2b4f2cda758@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0287.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB5229:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ab02ab-e910-4fa8-d725-08de530b5bdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVRXcUNiRy9JaStkVEJvZ1M3aFJERnVWSTdBVHV5cTBLS1pOUGUwM255V2JB?=
 =?utf-8?B?UW1QYnpxcWRBNmsxdGFxOExHdFNheVgzc1A5RVd2Ny93b3hrU3pwV2NGeVBE?=
 =?utf-8?B?RFJ1YUl2cFEwYjJOMHEvdUNhSXJNdm1FY05sWkFabk9Wb2lzeEdnMml2V2tr?=
 =?utf-8?B?T2I2VFpJK3p6RlRPWStxaFBWVHRMSlM1cEhqRVJjMzNWWEhRejFVM0dFYzly?=
 =?utf-8?B?MHEyT2lET2RuN2FZNHVYVzlVZVJnMTJ1bFRyWlNYbElDSW9wTy8zQXpOcGx5?=
 =?utf-8?B?Vms0UFlNSkkzWEpVazllSHZkMFZ2dXVidkFYdTZhemFrbXJwTFk2eGZCS0Fm?=
 =?utf-8?B?d0lvWDl1NURwVTRwWjRYaXBoNXdxYTNVS0ZNMzNQeDRTRlR6Tkg1SEZSZ2g1?=
 =?utf-8?B?ODlJSEw1Z3I1SzhRUUFJalhXRTl5b2c4ckJ3N2M1N3RJSXJlY2krcVVYbUt2?=
 =?utf-8?B?aW8yZE5YYVZldFhUYnkyYlpmazFPOUhCV3AvRmpyZ2tSVmtCK0ljcXlsZjMx?=
 =?utf-8?B?Yy93NzBnM0gwd1RqcFA0OG13MlRSNWplZ0pBTExCZktxVkZZV3NNK0dBZ25N?=
 =?utf-8?B?OUlaM2htUCszRmxmOHpyZWgrM0E0dlpNTnJ0VjBiMEM1Yml0MFp5VW80alhy?=
 =?utf-8?B?YjREeEJuWXpIbitlMEd1WkFBdFR4OVpUVC9wOGxkK3VpSEdQcjVhQjNFV0Nj?=
 =?utf-8?B?dEo3MU1LZGdseDd1U2ZQUXYvNHZRNUYzMm9qb3hyS1JDcmNRNFRKVTBsclAx?=
 =?utf-8?B?V3FZZkt2T2VqL1dDNDNXQmFCWWRMcktnQ0o0MHVCdHhxd056NkpMQzZHOTVt?=
 =?utf-8?B?TzBYSlc5am9nUzFXWnlMbWRIMmlYcjlrenFKREtRQzBsc1NwRVdKalUrMFBw?=
 =?utf-8?B?MS9SdTVSWGdxeE1TNFYzOW40YkZqYVNuUjRTRjZqdUVOODhScmVyak5ISmxH?=
 =?utf-8?B?T2VqazdWak9xVVY1UDZGQ2hxWEJHeUZWTTY1NkZ5S3E4TXdmOVltWWpMeDlo?=
 =?utf-8?B?N21lc1JId20vSDBTRU5tZTdxQTJwcytmUnFkZG5JMFRrUm9QVzF6WEZXcnE1?=
 =?utf-8?B?YUIyTWovWFBMRU56dlhOSk53VnRQU2h6RXcvRVBabjhGRHkra3BnZ04wM2xE?=
 =?utf-8?B?aWhXNUE0V0hOV1AxQWR1WnhhOG5FL0J3NmVDbXFPTVgxdkwzNTdnNHhHRjJm?=
 =?utf-8?B?Y2U2UEZlVHlyRDJwY0F0VWNRNW0yYXMxSDgyTkF3eVlCRnNLY2p4TEoxa0Rv?=
 =?utf-8?B?ancrVlVlQUhQcjcwdkRZUXh1dlE2bkRiVkdrWjdBblZ2MFVOZHU2d1N5MlJ6?=
 =?utf-8?B?OFVzdDZVdHp4aDM1bk5FNEo3M1ExbE9VNlBUMVNUcnZVZ3IzS3ZydGJyVlVr?=
 =?utf-8?B?M0YvcG1MSVFKUjVrOGpQN1pXZGJlS3RMYnl2Y2ZkTCtIMlFuSm83cmN3T0k2?=
 =?utf-8?B?YWw4STZRWVdHUnNKUEtadXZ0RGJIVEJOY01EcklCb1NPSHdxdDBJVzIrK1hm?=
 =?utf-8?B?K2pUa3p0RXprRDkwd0NUY0syb01DWGRSdHVwUFdFSnpYa0k3SUNFaGQ4UE9H?=
 =?utf-8?B?TS83Sm5sQXB3T3JseS9JdGxtaTRUaGNYOSs5cCs0Vnl6K2hFTExuTEVrZ1NF?=
 =?utf-8?B?QkJzVlNwZ3RuRjg2SXE4RmxrS3BPZkF1TWVwU2w3M2hpTmtSTTg0SC9HRWZz?=
 =?utf-8?B?S2pGMUdXTkhrcVdwckVEWHU0K0F6T29sUHIwdUt2dEdGbHRKSEErL3FJZ2Iv?=
 =?utf-8?B?enpqcEJKZFNQNkFWNDVTeFZGZ2MzV1Y5MFJjRVNNMGNwQ0x6Y2JSOUF6SXZO?=
 =?utf-8?B?dkUvbHc0Z29oOElJS3UxMVQ5RFhKcnVZYXJIT2VQTTU1bDI0VUM3djMzNmox?=
 =?utf-8?B?aEFQRGRRRk8wR0tjb2JndFhRSUhYWGs3d1ZYYnlkRW4rNGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3U5M1hXQU1GbW1ZZUxPcUFqT0p6Vzd1N0UxemJiQnZaRmU3YzdBaTE1cmpM?=
 =?utf-8?B?R0M2TnovYlo1Q1M1bGZEdGdXQit6ZHlqOCtBaXdiS1c0NVNXekpLdHVsRmxN?=
 =?utf-8?B?Vlc3K1cyT0VQaEVrcTN6dmxZcUhxSHJ4UDdoTlQ4RW5TSSswWVFOeHMvQldE?=
 =?utf-8?B?Q1BGZFBKd3hNNU9VcEVKVURFeXhVaklRbnplM1BuTFhYcE9nK0VGMFJQWm9Y?=
 =?utf-8?B?dm93bjBDdGdoSW5uUzlyazRJWkkxcmxIRmdBTGNHSWlGQk4xOWc2bXZXeUFI?=
 =?utf-8?B?VFlxUksxSnBzdVkxZjM5dENYZi94QlN0RFlURUx6a0hhZlo3ZTEzVi9wQ1lY?=
 =?utf-8?B?a25qcWpRRWYzVzcrNnlBMGkyUVNTS2R3T1pwVnYva09rTDhMOW9mVkVmY3U4?=
 =?utf-8?B?dGNvVkF3dXJYWktFZ0x6WWs1bWRpMHp5eDY1SlBXckhRM1lTcGt1RVRqcmNn?=
 =?utf-8?B?T1dSeXJoenJCd2FBb2o4WmVqWDZ3OE5IWUxkUkZjY0Q4RW5IL1I1aVdWOGVS?=
 =?utf-8?B?M3pqRzZCTW1xZXh4ODRWOWdkTW13SjVnWUNOcHZDc05hNHFMeXFSeUJzSHRO?=
 =?utf-8?B?ZEhHcUtpMS9jM0didFAyWGVnMnNYWG0rZGZRbkNxRTNwMEc2OHN2aWwvV2Rj?=
 =?utf-8?B?eHIzVzd4QmRNWXorYjczOE5LN3A4ZXBKUDJnL1RxYjIzVUFyeENjSzA3cUtR?=
 =?utf-8?B?aXdqTWQrRjdTT01McWROTnduZEJDRWVzUXFxM1FtdkJ4YXk0SnJ1UHFaNDFm?=
 =?utf-8?B?ckkwcTNCWVFZYndGU1F1Y3hnZGFuK2NwNDhtdHdNMXZVNWJablUwalliNlJG?=
 =?utf-8?B?RzZrRlJlNmltb0Vja1gvNjFDU3NDZm5xSEd3SHlJUFBabnFaSmxYeGREZHh2?=
 =?utf-8?B?cTVubUIwSEFhdkx5TDZTTmpCbFZYcXNucW1Oc0ZlU1U1WnJERy9rdUNoYkVS?=
 =?utf-8?B?cDBTRnhhUjdVSUlRcFRCMHJFQUlkWWpmMEp5TFM2QmNxTS9QWmlyUG5LQmh0?=
 =?utf-8?B?V0MrY3Q5cWgxNWpkcXV5dGdOZjZRbnhsNTI4RlFNOXJ6QXA3YTIxQ3BpT0Fp?=
 =?utf-8?B?bTJ5S1ZxSkxmT0ZoZWgyWlRBQUJSWkRFcHB2Z0FyWnNQUURsVk1WSFFUWHBt?=
 =?utf-8?B?RTZiVHBmdkx5dSt3SGtOem1MVGc0K1FacFRJbUR0UGI0bGthaHlxejJvd0U5?=
 =?utf-8?B?UHdUYUlaWnV1WHhDcWVLTFhKcGJVR3luU2pPT0xBa1lLdTRQM1NCS2dBVWR2?=
 =?utf-8?B?dVh1b3FVT1FMUWtiMC91ejJsUHZVNUR1R1orM1BpR2ZrOUJ0bGZHSU42a05F?=
 =?utf-8?B?K1FubkptS1ZmdkFlUWhKaFVpTWVNdng2aTRVakhtQ0lDMUJSTEduMWZyN01U?=
 =?utf-8?B?dDZHMlZTS29jVWZxUnhZT2F3eS90NEI0VkUyeDQ1K2hHUmtlRnowOExnd2tK?=
 =?utf-8?B?QUNrc1BGWEZldXpVWFlBZ0ZEWHZiaU5ydHhjYTJZSXYySERkVy85c3l2anRK?=
 =?utf-8?B?aFZDblFoVjkvWHczSHhOOU0vUlVPalFYUW9OMExjVTZTbXpyK0UzN0p4K0k2?=
 =?utf-8?B?U0RKT2ZqZEVWQVpyQldCZFdpeFcrcjFWUFVra0c1OGN3Mk5rc1A3VjFNTURn?=
 =?utf-8?B?SWlMY3l4Slh5d2hTUFh6aGNpK09pdW5mb0d6TG8vSFpxY05YWkxLTlhmMVh6?=
 =?utf-8?B?S1NUMmdnRE13eXBnblhRY3g4ZEtRTksvWGg5TndUT2Z6aWVRM0FHYm9VTHNx?=
 =?utf-8?B?YlFsTXZkaUVOTzlFY0ZRbmt5Qlk3U3NKSkNMS3lDWlJMazJ4dFF5UFRrZU1Z?=
 =?utf-8?B?YUp1OThCclB1WG1nSFM4TjFUMFg5QUZLRno1S2dSWDhjdU5iNmx6K1doY0xW?=
 =?utf-8?B?V2FMWldHdGI5d0pHS3FDWG4wUStiY2E2czU5L2RTWG1UNDg5NzdMYmlTVW0w?=
 =?utf-8?B?cmlhWlp0aUhORm02TXhqZ0dIa1VwdjllQVRhYWdhY3ptbTlxTklpVGdVbENS?=
 =?utf-8?B?WmVIMzV4REpuelR5b1puQXpkUFd4TUZRdXFVR2Mya2NQUWp1K1orMno5b1ZZ?=
 =?utf-8?B?ZWs2UENIMVpqUVNoV3Z2UU5LWmtRSTJPYXN6bjNxdDA2eDh2TnVhNFdWR0Jv?=
 =?utf-8?B?b3kwWkhqQkF3bm1JN25MRFVwLy9oeXFPLzJCUzZTeHQ2c2o0TjBrTndGdjE0?=
 =?utf-8?B?M1cwbkg0UTNkb0lWQms2L3ZDdTBscG1mUXFsMkhRT00weTlkZ1BodExNSGN1?=
 =?utf-8?B?TGc3TE81QVNjaC9pempKWE9qUHI3bDU5T0IvZ2szeGhyZWxQTW1vVzkwaFhv?=
 =?utf-8?B?dVFDMEJwanNNN0dxb2JacVk3NDd1ZUJrOU0rZXV2MXpXWXZaWVpvRkZjaU1j?=
 =?utf-8?Q?kP/5gYHOJLx2mGEJR9+PaC7X1Pjl6VR2B/0rWPIjfgxFR?=
X-MS-Exchange-AntiSpam-MessageData-1: 4vCUSex1Djxug2tb2nRX57kkm0XTA9cGRTQ=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ab02ab-e910-4fa8-d725-08de530b5bdc
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 01:22:18.5281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qcbuy5bngaYvyj+hGb1p0XC63m4GbgveZyc6y5VWR7rx2JaJGom7cPPQ+x7If3nZQE1RGZQNJlLTnJGh4uNGpaQQERY6ln7SheAia2Yp1pM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5229
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B4D940003
X-Stat-Signature: b1i6m5rcs5igayc3zc89x89zoaa8ecni
X-Rspam-User: 
X-HE-Tag: 1768353742-106979
X-HE-Meta: U2FsdGVkX18uZqMz3AScxRxInZDWMJmfVwvO3WehjGtPCIjc4DL75liXJ3/mpS6FP+tukDdY3iScd8nQqPPmiQa30ET+hE4CtSnQXtN3x3xXvFdvJjGeyaf+8ThVnEm2tgnP9mVcrbd5cYUWKaXD2fPjgpcMfG2rZB6c6FfkMM1aSlfOQ8Xo2RUntwjneiV81Kbnr3itjWmUqyxAi/35cBjtPZz8TLO5tEIzsp8r5Nqf+RohQJWUIl6JhC43oxCvyMHNqhFM6pXyJ0mCnb1WCtR0q+Hn8kKdgNqn+8WE+ayUFF67JYZOp9JL+ci5MVJDzIY3zPxTcHhF1lgr7uEBkrGdDdiEqMtxUX/v/cxihVjEr4VFas/h1gTAz0SOps0N0NGshVCUxDXMbE12YljQs4uNftsudpuvvSrVR+fhNWJ0z3MWhKQsXFT+zvn+BIkr+pq/WTYbyc2grp+TkZS5MFi6R63VINEyv5/JFcUygmPwP4Tenl3Bkks++myPVqlVU5WFvE9jjtuXTBoSYP3EXl7/TOPAQW4p9tlZeikTYvJxEtvymHjmzV9cequBWoKd9/Y+YE5PaJnNEX/wBXVn6p+vh709ggTEiKpdUTzoCjv4pYwgf/gPj97bBcAzL6rR0XyHvVBeCHUT9lH/XTONpm4CuKAtHG+kBIDEFipw/uYNbE9sbe0OoyiP89GLx6d4YTDgzosXP4WXjkYDziEN5QUkuq/UjAkBDhYDexotFaWLAVfAH0InTXCrgJtvA8GUhbYj2ZKhC5pqPEBMGXv3P57pisPGmGtdMg/w29T4ai2bOLO1O5CVfSpkEsavI2IJH9Auyh950K5TCVQowXBy2aB8t1KNuBH4c2HjJepZ0ZiLAZovQnZ9zI86BVrOvusqrFJYUs/xNi8Fq1GlI5K1OfgfE7dcSxt9cZ9Rsh0Rxq8/adDFFqCruv4VRdMyMOpC0/XNJZk5/rXff4IhCgK
 1RQfxBxI
 8pjebBVQXgkxmnkGVfta9ajLGHcQtG8REOv5p4GkNJE8Nzza3fTkO4oxlkAt7eWludBPZq1hrEGEejuPZYpTOGdfPP3QMbw+AwEvEdyUl/je9GqfAZhm84TlN1kQUu0AHPVNhteNIDuW422QR1Kufj9VRN+iP4cLepSsTGBOShdbePUoAePGOZYEjeR7SOvZEqBGGSW9yEsKboKZ1HHPVkt48khVYfJJRXeenuXWIHr+ORSbtn310sWqLLg1nOONdfPQhQvoB0dI2HQACZJOU4aCFwoMEdSozuhikNF+dfDMzBQy4n2JHZIBaeR3/FtIlqtMYnPZAManNPILJLMuvM95YjzWD9vc2VMigNQgSuUGBff1TA5m69ocSndHsF9b4mDkDy7MQi80E8PKWhqb5r0mDnESq/4bc8C2uUY1UBRSNdC4DrbgXo+E5cmGSdP7uCzeKU8DD+wNDf95kJWDCvEQ/PzMedh0OIA+c8AIPo91dbk9SO21CnBcThZOMkQrpd3f36TNSY+Di0haw0iCb2K7H4jCE4wAZREmCjfP11Tqtclg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 18:55, Andrew Morton wrote:
> On Tue, 13 Jan 2026 17:16:16 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> The hpcc series introduces an approximation which provides accuracy
>> limits on the approximation that make the result is still somewhat
>> meaninful on large many core systems.
> 
> Can we leave the non-oom related parts of procfs as-is for now, then
> migrate them over to hpcc when that is available?  Safer that way.

Of course.

So AFAIU the plan is:

1) update the oom accuracy fix to only use the precise sum for
    the oom killer, no changes to procfs ABIs. This targets mm-new.

2) update the hpcc series to base them on top of the new fix from (1).
    Update their commit messages to indicate that they bring accuracy
    improvements to the procfs ABI on large many-core systems, as well as
    latency improvements to the oom killer. This will target upstreaming
    after the next merge window, but I will still post it soon to gather
    feedback.

Does that plan look OK ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

