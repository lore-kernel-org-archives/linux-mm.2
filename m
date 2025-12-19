Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5436DD78786
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B832E6B008A; Fri, 19 Dec 2025 10:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18E76B008C; Fri, 19 Dec 2025 10:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12CC6B0092; Fri, 19 Dec 2025 10:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CF686B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:14:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04D2C57ABB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:14:31 +0000 (UTC)
X-FDA: 84236567184.27.367AF55
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021111.outbound.protection.outlook.com [40.107.192.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B62820014
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:14:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=F2RRRP7t;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.111 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766157269; a=rsa-sha256;
	cv=pass;
	b=RsGAF+cwHQMqg44qU1cJRYZP8TNwjfnhDDV6eu8xolg19DK7fGcEmpVAivw7b7ecVqwjHX
	ArbuJgAyNzc82mZGV8AKAuHXe+6Eb7eW5IyWAjljZ/+8zJGUDzS9O2gqos/1oq8EEqCYCY
	RN70HFdPnH/LjlWnvmjWbUxKcHc7YZo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=F2RRRP7t;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.111 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuYOFkFkz62YKdN6gvFsNH+KOO/N9gbmi66kAWr/6hY=;
	b=zLOqWISqQ1tHX2JFI4zcPgh5B/hpPzNwetKugWK+6HVuV6/yOAAVt/K73Jn0SxqPX71t9U
	crkGFeb7/r50w6vEdfu4Pwo0KmQ7wmKCleTokYNZLttL0KQ1psoiSFad3c9VXRc8HWejru
	hRcs9OQjWYP4/agxe+AcOZh7RAmkwZc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jqyG+xcK7se14MERwOHs0Rw6sdWKDYJID54sZ/QQB8gSY2ylQIx17//iOOGN2kKK9SgwypJAA4I68PN3mDWePBnVxoJ0z7lb2aA6xrGdx9ln+IjBITP48XmnLrAl1v+HNFbJurA+Vu76rWsGpDVE1RGg4oKrPJnaB3Np46J2rSQ/4lwaiB7ZN9QzVe+YQo9X2vGCTbKEG7mtxjWwnndhY+JZJf3bLWr9+UwTzWawlJlbqgRdyAXbT/FE9ltrU4mhDxhFebeZkACrSQukINlqdNRr5bT4r131GVjES0QajvGF6cEBbSEI3fXhMYG7M6LWLZ7LW3w5eBgqfkeq7fKewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuYOFkFkz62YKdN6gvFsNH+KOO/N9gbmi66kAWr/6hY=;
 b=cZQKLy3x9Dvha5giSB+jSDflzc/D6xaZlD2Up+tiI9wBGx92hZnb3g750Z8wussopMTJuYQVqcErz7IdvYwovXLM7al8fAb39pZ7kWWgtCMKQ/kGYqOCZn9vbe8Es2DhuUIBI9RzTH0Zkt01cmzwvWCsR8ilkJ05MdrUyBLDwdITheBbkZO/ZsTFdnJoGF4Rdmf1TgOwyaEw2W+dbU6OzunRcgleMuoA4l3+//lh7DapGIHxMR9p0xNChUgRfDCXZ8WXcx8Khj07fElhqtxi3naVudYps7QAXrUDiqkfDh7lqgb4oU7hb0VeYeTyiMDykSSJtFbUJIi176on8mCvpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuYOFkFkz62YKdN6gvFsNH+KOO/N9gbmi66kAWr/6hY=;
 b=F2RRRP7tODKgwBElTR+73vZ3wNUekW1pks6VtDXW6k3ZilDjbG/E7b97bHnZ11sFcdEfJZTRZlYgmWUIrPhTGDojrvSFhXFCLkeN/Cs3d8hvHMjcbgp36rxUD5w9MEcZObv89gTtUNEdatVEzgXon3Ll5wdjAdY8m4IHH6HvDIp0kwfSOHte/vO39ymcvZ9kznkrzx8Sppb3OMCi+QHFps/napbcT3H23i1HwKC/lzzvQmFCZqH6LvEOJCNnWyY6qKLaaBCD33HtHgud9tkRFrx/eB6lt7z26ZCzBXhHY7ek02WAXmKerH2TUBwPMCjS5tO/HYxUqYt1iUCY/pNf+w==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB9119.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:14:23 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 15:14:21 +0000
Message-ID: <edbe45b3-0f85-48d2-8d4f-784781a8dee5@efficios.com>
Date: Fri, 19 Dec 2025 10:14:18 -0500
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
 <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
 <aUSbhiMgluudbVEG@tardis-2.local>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aUSbhiMgluudbVEG@tardis-2.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4P288CA0006.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::12) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB9119:EE_
X-MS-Office365-Filtering-Correlation-Id: f72a16dc-8549-4388-82a0-08de3f11497a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2laMW1yaHcrVVBqdEhvaEtCUkExOFIyWUl5OXR3S1Y5bWdNOW44Q3F3VlhG?=
 =?utf-8?B?Q2ZwMEFIRzg5YzhGUGRSNnBZcWYydm9GSjZHY1YyWndLdGtsWFozRHluVk9m?=
 =?utf-8?B?ZkQ5OU9FYy85Y0NYbDMyU2J0bDlDT0pYVlRCa0lPR2dhZVYxSU40NEkyaUgz?=
 =?utf-8?B?WkVqYXBxc2s1TnZ3UVdKRnJwekxWY1lPVG9nc3IvVjBpeXB5RlNyZ1VjaUFp?=
 =?utf-8?B?ZWloWktOYlZUNmt5cGx1S29CWGY4WVZCZVJYSnl2QUEramJpbXU1UHJYOFdC?=
 =?utf-8?B?RGxTUHpDbTFwazdNWENpZXJ3a2VCZlB6d2psQm9BUmU1OXRZSnFsK25zZUFX?=
 =?utf-8?B?S01jRDFmRm1kck1OR3JyQmtFYURkOU1SYis4end4ZDJncXFFcVJGZFp1NitV?=
 =?utf-8?B?K2tGeDVOWmRMUDVQNnA0czFacjN6TzJtd0U2dldVWHZ1MW04bXRuM0FSQSt3?=
 =?utf-8?B?Z21vQlJMSU5hL0tteVRFM3kwcHQyN1VhVVNhQUJNZEx4cXZkZFlhcmVFRXFu?=
 =?utf-8?B?Q3NCWWpuV2xMZ3RnVWRuYlVxa2hwd1QwSzZuWnM2WDM0eENWRGFTalg5UWNN?=
 =?utf-8?B?OTA3R3ZlVm1wcGM0RmZFOXRPREVCNVNxVDFsSUVPS2FmZmFwNWlVYThMdDRy?=
 =?utf-8?B?N1VrNWtvZ245alA5YTYrYkhkVlN3QnBsaUxUWXFEb2s2MFJVczNseEJ1Sm9C?=
 =?utf-8?B?U0J6ZXU3QXFQSWc5WVpkWnEwME9tczdEMkduYkVCNjRRR3ZKc2ZIbVBBaXhN?=
 =?utf-8?B?WncxcHNyOCtVaEw5RkdjVjlJV0MralVoTmg3YnI3cDJWKzlsTjBFYjFHZG9H?=
 =?utf-8?B?MHI4RThOVjNzWE5POUttVm5Lc1JiajFpQTdBU29RZFVzL2NPOFRBazgybDI4?=
 =?utf-8?B?QmZFc0JqQ1R1bmVNcmlMQlhlYllJRlRpek1QV1pxVE9paGtFaFVDTy9pMnZh?=
 =?utf-8?B?eVplT1JwUExHN0txc2VTREdBOWptMjZSU080MDcydXZvc0NITERDTU5BRGNG?=
 =?utf-8?B?Z0Nkcms3QWJHNk1MUWhKbEp4N2o3VjRIM1NjTmRwSDIvbERiQlpmbE5tUlZO?=
 =?utf-8?B?c3NPQVhXTHBjc0JxcGJ0ZjBiU3RSYW5oWVJPYTBWbXFlU0Q5bGZVQ1RmY050?=
 =?utf-8?B?MCtRVW9LQUxLTHFWdnJyUEM5MEs3cjhaT2FjMk0zenNxMlRYTE9mL281V2ww?=
 =?utf-8?B?WmZ6UFVUZ09aRHBaUTdhYm9GeXVudk5EV0dIS2p6cFBXZ2tCKy9aTjF6SDRK?=
 =?utf-8?B?OW96YmN3aUZrQVAwRVNXUnR5KzZpZnRlR3h5NklkRm1jRTFyZi9QaXV6OEt2?=
 =?utf-8?B?NWJwcUduTlhMSVBpTEQ3Y2V6V0o4Vk5RWm8wQ2M2Y1Z4cFlWb29FbFUrK0s2?=
 =?utf-8?B?NWtZOXNETEdaU0dzQTduN2ZWRllQdXgzZDJzZFZVa0pldFlsRTEwSGdEYnBU?=
 =?utf-8?B?OEFJSzdOVWw2WERDaWZJSWd0K0RZc2ZvRGJudm9Hc3BwTkpyZzNyc3JHZ1dO?=
 =?utf-8?B?K3F2N2p2WWJYU095Z0JaU1VCMGtQaThzd1dIOXBZQVFCdDFnT2tUZm5vamcv?=
 =?utf-8?B?UDlwakFoMmIwMHRvSm9tWnRkOExFZnYxSDZ4NllCUFM0T1UyVklYcUV1dXhi?=
 =?utf-8?B?SlZQNktvaytWb3JKRUN5bGpaSWJReWFGMkZwdUxLZ2xrdVVFd1VJV0NVZFpn?=
 =?utf-8?B?NVJqOGhZVDZTUWZiNGt5WFRyd3BoZXBDdGc0WklTNWNoSnozMnFmcTNhL3FS?=
 =?utf-8?B?UmdMTDNKL3UrRlVYNVJiNmJ2enZvOTl3Nko5L1RvdGZqT2w4RzkxSHFMVjZH?=
 =?utf-8?B?NUlaOTkxaGJhUGJQdVpVZ2JlQmV2ZGwzaHRVZzJJenBCbTFtWFFHekhLR2pJ?=
 =?utf-8?B?TlFacWN2UmZTVmdRV21vSXlORFJ4ZXJlVHpqTWU4c1NXUHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wk00WUczSFlzME5xdlY2Um9HOUV4U1hRNXcvK0lFWEsza3VCK0tXVWp4eWhE?=
 =?utf-8?B?Vm5JZjFNQ0FDbDZSSnpMdHdSbEFmamJwcm41MUY3ZGNsaEg1TC8yTW1DdWxO?=
 =?utf-8?B?dFJaTUMySWxTd0pWSno0eU4yL3Uvb25Ia0VEdXRoOFM3a0ZsYmhEazVKdFAv?=
 =?utf-8?B?UGRBV1RKZWV0VEdOVkZxZE14Zy8xb0hhVU9td1lJakhWTFcxU0I4a2J0SVhx?=
 =?utf-8?B?ci9CRkpqb2g3TXVGS3k5bWRPZDRWRE1aWFgvdlFSSitLNzN0K1VBaW11aTVP?=
 =?utf-8?B?WEVYME9HZ1dSQ0dZZjB2OHVsdEtDNU1NbnZBRDdCVGVZbE4wWDZaVDRVZFp3?=
 =?utf-8?B?d3pXSUtOTEdUbzN2c1F2M3JZTlhxUkNrODJpWkZLM1lLU1huODNwQWJHc3hz?=
 =?utf-8?B?N0l1UzArTVdJVVlNdVIvYTNHNmcwcXNIMHpwUjNQQUwwcUlwa1I1bEJKbk1j?=
 =?utf-8?B?M0d2WC8rdXJRWmpWOEorT3Frd0UzS1N2WVE1aEpEU2ZqWENuTnNPS1RKQTZY?=
 =?utf-8?B?Q3JJUDRXb2t6K1Btdy94S1pBVW5ab0NhOTdKUHR1dzJDL1VvUzd4b0dIMU5Y?=
 =?utf-8?B?K05GVlltMHZaejQvaDBGV1EzVVdQVkkyd3ZTUHVGeXJpK2RrSVZZVEs1N1pl?=
 =?utf-8?B?bGZIYmk2cDhrNnlQeHBOeXVBZWs3eTNtZWdOcXdnQmFYdVFQTFVmKzV4YktC?=
 =?utf-8?B?SzBTS3o5ODhyVHBCSStaTkRiQ3NwdmZ2NmpScFR5ZTZKa3JnRThLYldndGFY?=
 =?utf-8?B?NE9XYyt6L0VyeU54QytGLytBQUdXVVdWamxNVkphQU9MajBzQ1pKS2xWaHp1?=
 =?utf-8?B?WmpFRkFZdnVWRStuOUdCcVZkSDUxUWNOQlZoZHEvR2lyaDFjVE5oMVp5ZjVG?=
 =?utf-8?B?SlFaUzR3c1Q4c3Job0pZck9hekRIKzlIem8raEhDbUw5YVRYb1JoNXJRVklY?=
 =?utf-8?B?UGVTejM2QlJySlNMS3VoQW9wdGxNS3NOMWVRWnN4Ti9jNmVYajJXLzdVM0Zy?=
 =?utf-8?B?S201YnhFOUNYK2t1akdRM08xMGFIcDlXM2YvSWdkZGxJY2RNNlFFM3NIMmhH?=
 =?utf-8?B?NlFjNHl4RW96SnhrOVFldlRQTVc5d3l4YzZVTkdwdHpVdUdWdDVHZ1VPdms4?=
 =?utf-8?B?THVTREVvNmo0anAvejV3dVVLYW1IckxwZjdZVHpaTXJnNDQ5eDJsTkdxbDBT?=
 =?utf-8?B?ZHF1NUpvUjhIWE9oa3lzNXNmSllRaWdoSFA0RjdaclpnMmN4K1kvY2RQZzd4?=
 =?utf-8?B?eXdtMS9DUExBRFN4R3lvSFdQQmkyRnVLNmlWVlRDMVhNYTVRSlRxWTZveWJl?=
 =?utf-8?B?ZkREaFdZSDBnS3BFTDlONjJTNjZtdE1PMXVjdmlHclE5QnZBU2RpNDFhTGJB?=
 =?utf-8?B?dEVDTXZrYzgyWjZHWlUwWGlGUkFKN1VuNmxvMjJ3ejhrOElFbE9TU2VSY0NZ?=
 =?utf-8?B?emRBbzgycnVHNmVjSUlmbENyU0htc0RDZ0pKdTI3NTZ4NW90UW5FSnp2YUhX?=
 =?utf-8?B?ekUzOE9uOTB5OXpkTSthZFBFZUUwVkN3M0ZQb3AvdCtCVWJjdTNKVnozOTdR?=
 =?utf-8?B?c0ZXL0RDT3VMZFArRElpakZaajFneDhPNU5vcUExOStrbFFUWDZaMkVKNllq?=
 =?utf-8?B?bkd1YWdqVTl2eHY4dkI0WHBWWjhsOE1BWk9zbHJXb2tUSXgyd2V4V2ZXa0NP?=
 =?utf-8?B?SnNyemJoT0QrdWR4Ui9PSFlMZ05lWEFPZXBLL0ZrdWdlWURRejdkQ2d5UjJF?=
 =?utf-8?B?NDFybGRUYW9sK1JHcUtGcU9FN2hVS2xZTlNNNG1JVlZKVnZ5Y0NnWTdWWEdh?=
 =?utf-8?B?VC80ZnZWYWpuZ1A2UmN4b3hlK2pTN2lMMUpjbXNSVTlINEYyb3B6L012SGN3?=
 =?utf-8?B?RnBIWHpydVRMQmRTR3VndXdmQmdRYzhudndSOFRIa1g4dmxycnNjcVpvTnY5?=
 =?utf-8?B?TFdSZ0Z1T3dERTRJV2FTeU52TVlZemczbWhSUXlRL1NEMGxJd2w1T0lMdkh0?=
 =?utf-8?B?NGp5c2xIc1Y0QmVkUnVsRjhTRDl3cHI1M3dSYVhmR081ci9ZeEp0SlpLazBt?=
 =?utf-8?B?c0xNT2w0L1hHQWFhWFVVL21MbFczRTl6Q3ZuaG83OUlOd1VvM2tuekI5T3dQ?=
 =?utf-8?B?Zm5jNDFuTjRrTHEvMC9pWEZrdWg2bHh2R2g3WGQ5cXNOTUlkS01EdGI3S0VT?=
 =?utf-8?B?TGdmQlhMZkVHNWhvUitadGVVM3VSTHpYNTRIVnhlM0c2M1h6NzBtWkw2bU1P?=
 =?utf-8?B?TnRUSGdwSXZYcS9tWTJQTU5ZVDI2TFhVNnovSGVUZ3QzcitTZS9sVU9OM3Bu?=
 =?utf-8?B?VmsyY3lqK3JBTStVbVNzOTJyeXk1VDd6bUc0LzhJTERDbFVsRFRSVjA3elVV?=
 =?utf-8?Q?2L8xg3uquLIUPUlw=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72a16dc-8549-4388-82a0-08de3f11497a
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:14:21.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/AxFdB/R3Zx00giYIYpH9B+Oh0rx7pnlPHPd4bj57EXCVUSE65qt4GnicNYgKNRS4aPDl2pOEjes6Jwz5rKIAonuIvxNL1FKsNXnxEBxaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB9119
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B62820014
X-Rspamd-Server: rspam10
X-Stat-Signature: mtksuxg845iazbypyn1h1q3six87r6xf
X-HE-Tag: 1766157268-95015
X-HE-Meta: U2FsdGVkX1/OnEwcIp1p/vF8RmrjKFEwaxXzkpDsoopGAoo+jkVqtRWaKq3c+OUnR5ENtK9/h/JqacD9nQS1QPh7c49Dq9Vw9ANQ/Zgua/yF2FIBh2Eu4RSLUPVxe5PgYWC1NAXLCwDS45KWdqyg9eXo8Db6/EwaWu7kZfmQpsF67m6qGfTUUZ4hxCoHQZqr3YLXGWD0/XNitZreQDgGud11cVLDer45bL69P7fiJ5701XEiq41nxWMqsZYOCty/kn3wa6pKbcMCo2t3iW35BgGH3EWFUKzFqNfBhN/+sT9meXf+AKHbtjqbYWHATrVtN+HcilrmUE8x3HGMohZgYB9kbq/25AlErkSweIPGVFUw+pFD5n8TNjsvikNWugV7zSthSSCue0osxsau2UFl9/rF61me3Bv0/mRDSwCCNIBOdez/eyc3F9lNX3uc9pNwwsG31qFKbBXlRLQk1c01X3dcwSRt4G4If2Ia3u3OQAtga1wHxfpvUmGkMC300eqknIDeBvlRy0g+i+Cz75bZvvhrSDmJNCMWWcaADVPjwvJdIO7EQX4h45rO/ophJ+cbPKE85PFriowobJltywDTPaVAxjMFrN9qN/iLquOdn3n0bU+AIWV40l0gCju2LLcUkgQbS7l761a8/wOnyiUO+/ZMBHvsU+6nI5tyBUcP9V2tdt0NOb7D+jIrDrcSNGPH21Pf/JKTNMeiQy/ZUSHovzawuu8qsTjY7t+4ICSOEd4DXDhnev1D6rFbTUwA71TS2oEbrXVcaj60ohxr0m2A+N9pQ0GeRqr8WxM1QVE7pEHvtFFZetQPiJpCc25u8SAwYjyKalO0kKvHYfvapChrkrj+8y34ys0ds7OSbj6GbXS5Lj4DATWBz3x9FG9YkIGkDx7PrdSrhZQMFrsWm0CikhaTLvLOYOCxF061onKQfEpm8ZB9Se4Yd9Z83sumHiI5ys6+d4y5I4mv0v5Da8d
 gKnD16yw
 jTrBf32QyLwioDV0bS5YliZOGSEyhcgExwGbhtjUEGe/pU5oS5VKW3g+v6DwkPU3w9bpQnAEkfnnDyZcVPg9wMsqvIinZBiH8BlOYu1kg6sSrrbfEyK4EnBxFg9aLHL5QlZgrna/aSftN5CULQGjFd8cdz49deci7vIGrfHagPrKtuIm48zcneoDF33fNxIhnsgut90CnrG8F5MaOzGQwiAu1vY5sJLl1z/b6+tc6NxsQ5Df+vGGzTLrYgQDnF0iP+yH+MJ2RHQAr5hubxD6dR1ltj4wC7gMFIFa/TowBbz74NhoK9nk47sI8YlmMTQQvdEpeKQkkDOHqBbr23Oqjav6yfltC8AGXpUhlP5y1IZnmqm6WqwvxHHajsaNgKijF/OfCFSU/YSW7xjtKYWf4bgAdv5nbXLsrZRBB0DcEpASlh9saliZiEK3YBZaAvHLAdAgHxStVV3nuusgmzizGCr463LlH7CaiE6ovFXop+OVsRk9N46sf1wYl+igpQT1UdN9yV+PV/+NDX3sPrCpsTJJGRw53P0BnXBMMWQtM60p35JeQF+sEYVl+RKMH7CKQSMhEZJGik5FikB1Lf6tN1qWKCZl3PiOnhi8YrjvER6GNEGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-18 19:25, Boqun Feng wrote:
[...]
>> And if we pre-populate the 8 slots for each cpu, and thus force
>> fallback to overflow list:
>>
>> hazptr-smp-mb-8-fail    67.1 ns
>>
> 
> Thank you! So involving locking seems to hurt performance more than
> per-CPU/per-task operations. This may suggest that enabling
> PREEMPT_HAZPTR by default has an acceptable performance.

Indeed, I can fold it into the hazptr patch and remove the config
option then.

> 
>> So breaking up the iteration into pieces is not just to handle
>> busy-waiting, but also to make sure we don't increase the
>> system latency by holding a raw spinlock (taken with rq lock
>> held) for more than the little time needed to iterate to the next
>> node.
>>
> 
> I agree that it helps reduce the latency, but I feel like with a scan
> thread in the picture (and we don't need to busy-wait), we should use
> a forward-progress-guaranteed way in the updater side scan, which means
> we may need to explore other solutions for the latency (e.g.
> fine-grained locking hashlist for the overflow list) than the generation
> counter.

Guaranteeing forward progress of synchronize even with a steady stream
of unrelated hazard pointers addition/removal to/from the overflow list
is something we should aim for, with or without a scan thread.

As is, my current generation scheme does not guarantee this. But we can
use liburcu RCU grace period "parity" concept as inspiration [1] and
introduce a two-lists scheme, and have hazptr_synchronize flip the
current "list_add" head while it iterates on the other list. There would
be one generation counter for each of the two lists.

This would be protected by holding a global mutex across
hazptr_synchronize. hazptr_synchronize would need to iterate
on the two lists one after the other, carefully flipping the
current "addition list" head between the two iterations.

So the worse case that can happen in terms of retry caused by
generation counter increments is if list entries are deleted while
the list is being traversed by hazptr_synchronize. Because there
are no possible concurrent additions to that list, the worse case
is that the list becomes empty, which bounds the number of retry
to the number of list elements.

Thoughts ?

Thanks,

Mathieu

[1] https://github.com/urcu/userspace-rcu/blob/master/src/urcu.c#L409


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

