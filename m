Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C7F606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=H8EYQ6Xx
Received: by kanga.kvack.org (Postfix)
	id 727796B05B3; Fri, 13 Nov 2026 09:23:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE906B05B5; Fri, 13 Nov 2026 09:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0D86B05B8; Fri, 13 Nov 2026 09:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 360116B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:23:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDC6E1C2DE0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:23:11 +0000 (UTC)
X-FDA: 85430312982.28.A390E2D
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021108.outbound.protection.outlook.com [40.107.192.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB72610000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:23:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=H8EYQ6Xx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.108 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794579788;
	b=YOo3O90iiAkZ5U+4CDT2nFnErr4qtnEOb5lIiURBpkA1qNveIbzzfKwZpSBsrJic90yNwV
	v13jn1b/jWfhWksUric6J8U/IaFT/vpw9DP2ch1zx6BGo2ZK9r3Zqrkvq0AaT4USzXv/8y
	mxsDT+0O7KNYK/tlv57c1Ep3EBxnj1k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=H8EYQ6Xx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.108 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeLDOcLmqwn4Mgr0bkG+XwfS6qej2SH5JaqSEo1Vq1I=;
	b=niq0ce00+qc81GJIi6i2jrPoRwQpejsCu5/udChjxzF8JbU2MjhsyFDTz9pqVuUz7+QMcf
	EhIWCfiookxw0APxVec6GSqSxZAOx97c0FmbT6q4fRTj8UCVPcbqVqa2zKBn61TxRrZhVz
	7IdILgM/anYwxPLtpWkNl1s+nUH2TJo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KzPW+KqP+157Eh8fL6YRU0shtP+eESFY+WWcF47Yiy1m4O2+D8M6KORF7dW+pziVdYvzci+zzvGnq2dfODbToPdY/V0KqA7lSTJUl+KFsucs2MwEVXlL/KSZsqJQOhSghpVqQ+8etbt8JS895gcm2jhJyLEfVJvVYRFqPRFy8N8AIlAgtmiMQtqvEzkfZaf060JC3Gc2WBO3mar9tUblrNvRCMyGg8Yv5trNuQ94wDdalDDnenc+ktO2BUAU4nsgA4b2eSTESorbrsN80NTiVzZUlZhBwGuUxwftwRLoQOHnr7Ekdm5xXCMTr2SxNm5fePb/K2/MoeQl70AIaCJpFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XeLDOcLmqwn4Mgr0bkG+XwfS6qej2SH5JaqSEo1Vq1I=;
 b=T5HlRHyF7PgywQLLQ0d27cdvMmuDJr3j5VWscJ6RHqfBnlePJNLclhnaVW+OP12nuk9y9nP7LpJuf2w2t7160kN3UsbHoR4v/9sBuAWTU4c7Fk5KVrEKf4mdxeLCOqqlMAbCYzBc4gE6LfgwkaUQNkG5RpZOSlqB+cHd0arhisbApSVf05yvrnoMRcjd+mqwm2jA38QG2AHpZFpwEJMbnTg4uSmoRp+eNOi8IOV2hXQ/1GH+IqYj3t1kdzbUD+JX5khuvdjMmWc7gQw+MQUFG1qIyxyZt1C8sxm5vSkxi5ihDn99FoqNdXYKPipo/2f7TBqsFRVskoih+g7flGwWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeLDOcLmqwn4Mgr0bkG+XwfS6qej2SH5JaqSEo1Vq1I=;
 b=H8EYQ6Xx0AJbIEqTH856+lJ659x7P6ZAhGij4yiQYrdOXGJTt6HfEIRtt6JNR7MboA8u5YpY1x+fX2T7inum3DShkFsfY9+t3ChLpIXxDLwKyEDn7Sqm5pw6V2tr4JSrLxZ3K0+IsH8Xn13freLbXbWX5wwZUgwFC3Z4CQS1HPNPHqzyCqP8U38Y+EfQdZQypWw4QLg29YxbO2tzeJM7vz+K3efW7Z+giaEGSrubrT/IsbY18RLBVaTgx5zyTJT6OhuMsVNJRsJb4PnqJK2NPLNnzbeS6bzUbic/IJ/MHgGs14JBZtNTbi+2lhEs/eu3k1fY4z6wxUFQJVpfosjq8Q==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by TO1PPF61C4FF72B.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b08::64e) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 14:23:03 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 14:23:03 +0000
Message-ID: <b33a9a59-f0e4-45a7-a112-3f80cdd0380f@efficios.com>
Date: Fri, 13 Nov 2026 09:23:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v25 09/14] lib: percpu_counter_tree: test the limit
 counters
To: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 linux-trace-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
 Andrea Parri <parri.andrea@gmail.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Hugh Dickins <hughd@google.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
 <20261111203626.95838-10-mathieu.desnoyers@efficios.com>
 <sashiko-outbox-211804@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <sashiko-outbox-211804@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0090.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::29) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|TO1PPF61C4FF72B:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f00af0-5d11-415e-87a2-08df4191a0ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|261009223027099003|56012099006|4143699003|261102123227099003|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	p/hiD+m7d7zUgA6GQXrY8ynQPcmPhl3wDtIpqi2AYteFCq9zi3yIUHqrkszSS4/thkicVUq9vqUt5UR5gbl376JrQlskg9k6klKyYZ663DC3Vfv5/KMtBDqth49PBVb91aNqAMIXOolPIhFRwKvrY4oKMo/XUc/m4CZndOePIT5fMWrp5K+pKA0Io+UTFMOOACNmukSoAcIMpMnZctci12l3USW0rLsSi9ZQzp4SrQIX4qQCPbNN/arP9I2GmwKe8Gcv+wFfOnaO8urQy3n3QeTWjAlOVbbdwVXG5x5o8rajZ1VhpOtYp7Hp4PGCeJb0sbzKKKvquoCILvGtK2rw4dAe56KMZxPoSq9Vm1p4BsSebhDWc46uDA6Cg0oCS5BE+CdO6tgd9Ps8SWpyMapMphsAJBfwm+jjD0VPmtzQSvsaJKxv+EOPEkPD3YnLKGhqGJjfMbj4lXWBd2Y9S28KaAg3rCwm1yWRqFoVNjqOUkZIVjGwS5WSmSl+lLePBK+GJe73EUxNW9rGzMyDBFJuBT6MMls7KWFWjA9kdvQlvEIOvNIpM4X2WaiCoaljkDvGO4WtJIF1zr4hZl03hPMPUmPIvakg5zAhyIIdty6Vl4E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(261009223027099003)(56012099006)(4143699003)(261102123227099003)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUx3TXBTZk10dG9sZjA1SGFVeDFPWW9WbVdmUTJlOEdkMmIxWG1TSll6VUU5?=
 =?utf-8?B?ZFVoQWw1QllqY3hOaFZCWEp0UjQ2Q21reFlzT0p1ME1YMUdpcGZtYzZ2R3lO?=
 =?utf-8?B?NXJrUWl2Z0dUdkpWWFRvT2h4MGM2VktNZXd4bjdIL0dYNGVFcnFhcFlQRkJv?=
 =?utf-8?B?YjRSVFcxSDMyd093NytZb3dkVTZGYmpCY215VExCd0xydithUCtqNHNBajRn?=
 =?utf-8?B?YlhCUlNnWFJxVkMyZmxnTjA2bkpjUUR5bktrMlR4UUhlSGFxQThLbGY2dEZo?=
 =?utf-8?B?YjRBT20zaWt5c1RoUXhBQ01nTlNkS1NoRTh0b01sbnhtMkpldWt5VVcyNFdX?=
 =?utf-8?B?TWh6ZUhOd3VtS0RYbE5uaTBnWGtsR1A3V0hmM0dKT1JxZ2VZZ0tobDJkM2xj?=
 =?utf-8?B?U3V1UExobTVobFRLN1kxamg4SW5oZ1VIeG9aK2ZCb1FIditvZzVGdm0rT3lD?=
 =?utf-8?B?Vlc4dnkvRzZRRUR5S3ROcnorbktxZHFRbFJiL3pBc1QvQmlrUEU4YVFZTjZI?=
 =?utf-8?B?b05wb3VVdGw0U1MzMVFZZU9Ud2JJRGZsTm0zWjRLSkpjU0pXOStCbm1TUXpY?=
 =?utf-8?B?OFEyclhzREIyYU9iY0krSHZ1a2dmMmJEOGZTeDVpRm9JeFZkdExxNGgwRGNO?=
 =?utf-8?B?OWlhTFQzZGJQc3Q3b00zdXViL2lIV0pXdjlsVW13OWlRSE1jOGVHR0VYQmRz?=
 =?utf-8?B?TWp5SzBnNGwvMVU5QVhmYjQ0T0gxY1ZxWFFvaElEN3p4WTVKME5hdzZZaFNj?=
 =?utf-8?B?N2hDRzZmcmlSc3VlK0w4VzZ6SGJCdEp4QjFZcHJMRndGN0c0T0RqeTNDc2xL?=
 =?utf-8?B?SStPRU9CWHdCZXRsRHJGdTFEenFESkVpRk9DVUNSYnFvU0VEQmxJT2tZTEtR?=
 =?utf-8?B?ZCtwU3RhQVFZdlhBcFo1OEVpdlBKaXZzRW5DeVUrZ2R3YW9vRUhoczJsUXVw?=
 =?utf-8?B?VldWcTd4c3lQSjJ3QjV1RXNMTk50eEZjZVp6aTVqdDB0Y0pJMW9icXQvRzBP?=
 =?utf-8?B?c21FdEJsYmlUVklxMkhKRjRYTTBSYWlyZ01BaEdSdTY4Uk01RWg2OTFjcWpp?=
 =?utf-8?B?T1ViNHJHazZWaFNJZ3FoamJkVkhtSzlFV1BlM1lwUVVnNlZuV1VndU5IREFI?=
 =?utf-8?B?SDJ4OXJKcjh2TnZOMEdCWmwwYXRvVk5uRytFSmRmdEVCQ2lNbHFLMHVzU0N6?=
 =?utf-8?B?NTQxTnozWVQrUXEyM3VaeWtrcjAxb1lRdUNGZkx3WnZaS0ZTa09qNE84MSt2?=
 =?utf-8?B?eEx3MnNyRXZ5WnhUeTlFaDkya0J6aURXRHlRcDFlQjFlUmZ1QitQOGZlWnlz?=
 =?utf-8?B?VUlVODB6RnVHRUhPNmNDMWllclFrNnUvUFByQ0cyWjJqY2p5QmpYeGRkSTVa?=
 =?utf-8?B?R2tXeGMyRW0zSVBEU3JYSE1HOGsxdlJuMmJVUkdsZGZ2bHRTLzdZUUkrL1VT?=
 =?utf-8?B?Zll6ZStTUHZQWVc5bGl5STlBc3p4dkVINkl6S0x4SlJCK1A2elFVZnUrWmNV?=
 =?utf-8?B?MEZsQStWcG02b20vd3NLTXhwbXRNdG04VXJNSGFFVzdScCtVM3pLdUJncjBI?=
 =?utf-8?B?R1UvZjJOSEdKTVZhN3J1WWxkWEEyU0lGUVhNL3dEL3EwYXdLOWRsVkNZYUEx?=
 =?utf-8?B?NlJLZEoyeWs1cldVdFNlU0xPNzErNER2U0NjUi94c0xiVnVISko2VTJpSlF4?=
 =?utf-8?B?TmtvaHFDSW1BKzhQejZtTXZSN2xMczRuYnFGTWtYT3VZMmZBcXIvM0U1N1Bh?=
 =?utf-8?B?L0lRT3dPRE1VamFsY3J4eGRwREtpK3g3UmJXTnVWL2RITEJhMllITldTK1B2?=
 =?utf-8?B?OUF5bnFKZDJhRjJEc1F5cEFmcitUR0pTb2E5cEJLM1pTVjYzcjVqY1I2azFh?=
 =?utf-8?B?WWs5ZldsQTBUaTh1aTl4bzNraVJBVFptTW9PZ0c1M2xOOUc0YTcwS1BtcjdM?=
 =?utf-8?B?czAyNlVFaVk2MjJsS05YN2tFYXR3dzk3ckx0RVhWWlEyNkRYNWpudldzdkJo?=
 =?utf-8?B?RUVMbG52N2tTaE85cHFKc1NKNUdScmF0eFNZR3ZsdTZLelNOaTA5UGUvRkYy?=
 =?utf-8?B?c1NObVZaT3phT1FrZlVLUzVSMGNWbjRhM2ZMWGhEODQzakpUOXUyWHd1VXVH?=
 =?utf-8?B?M0pnRXZYSnA5ZmEyc1hOYXNCYnpHaUM2eER4M2ozclc3MWZsNmtVbmx3UkxC?=
 =?utf-8?B?Q3FMVnVuOFFKWVNOSlNPWDY2Y1Nsc2g5aTgyME1qakRHVEp0MWMvWFpXMUJp?=
 =?utf-8?B?NTlZUUI4VjlHSlI4UlErcG1aL3dvbGF3b3djRDE3NTVsS2JNc2VKa1RwVFRs?=
 =?utf-8?B?TENxalJXT2IvTnpWVlh1b2srbFFVeUkvREswOEtCaE1OWE9lcHRjb1ozM0hl?=
 =?utf-8?Q?KmIUHLRkR/V199Ms=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f00af0-5d11-415e-87a2-08df4191a0ec
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:23:03.6790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5L8PpMRjr4HJwhV32jh6gdCAUdDnrmp3Mvks8SX5ESG9ygjh7s/u5IWwcgMuqJPwtQo+jyy+s8Xh5B5oXvxnBNYBuDo9X0Ksietrs3QQv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TO1PPF61C4FF72B
X-Stat-Signature: hn9wxd5qt38ydftxbez3zytnqizkebqj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB72610000B
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794579788-500338
X-HE-Meta: U2FsdGVkX19BF5AhiIx90nwy2Camc0E+bHBDlbArTTTPVBOVAvVagGMAZCYJ+2JSJ9pIMQoUFIeSFRfp/21/TN53L/oI9ACtOsqqAFRMXduODs4WVtmk23jEOn+WAQKYQebmT81pHSU2K1gdw/Dq5mPLkJMasMe7A5ccDrg3LnDdghwuImo5fjO7MKjiXHvNKcRCB5RB8eqgB+GC3tKFxXF+SK6PNP2aWj3FYnpCI8BZDpUnuozIkMM8iOjLwxoGfPVgeyz9XZ8S5vo+1A4BhvqM0h+5ksbB2wY68iUli3qDPpkuePaF5JBA/h3ptO4jzSfUYWSyAKGkao3arpYSujDJrw1AhkTjC2NH/xnlUp3BYiQFHxBwWPX2x5UolZuQdEBWf8Bk9rJBrdcw17hHCnNGghqH1+88G1BOrPJRmqOwgLE/XHY0FPseAM0O7ouCVQ4BzZQyje+sgbTX5TiELj/1aBuXD1ZyzGqwSsTDTw2bIDBirlkLoAzsZec4lxZud0/uGb4kScB1Kl7hSoQbhLjc4I+ZreoPDsLkTdt7vzrFus8qlg5xTy5t67cGNCJM+P3a7YlTRkJEl0tUqCCzpyd73lyTQjAxM0wM4d88CBM6oMGsSk5JEwvLk3w8sig57U5t777ygThJdycu1PokogIyGephEcUYBD4oAEH0N0dSBk5+758rtEy0uPKZqtgxgqGedK183JJxvXOdpXvGDZtPcc5c7JWl2LlcG+kOcp0tliNl9+LaRueGrggWxtp3jS9Wpn8nNOeEhq/fRGy+EBHW2JDjN8YFftlnETLwVNo7p3XqD8avxVWEuXQ0JWMd1BOVTqpRIW9KLNd+vlJOhOxihI+lEr2QTu78+P0Ch8kUhvuIVuAyLN8kFYhYmt3W4sCBXFjgn1lEd3ITuD0MmBiqnzqsDQXXEfm/h1TKrA5YtAT3xDt5ksKUhmx/KDoC4esxAcbcZKd2p8d32nP
 SoRxT+x1
 R0BoO1RiDR8S1e78TRs4Z/OwfjtYXDd56ebiAfmnGlmQoCs2/Si/HRSBnAJIU6no6xKWuxDnZWRQFlbrWEXPguZdOMTO8NxCnwCHObpzwZ86y8LmN1LlFFTz9WhSAmXZk8yHqpqy8oX5jHrMfncpUuTWpIYCZg3YjjSqHGhWwsgdAO/SnitqBaA70RJV8+cFF1QJcrxpAO2Wb+NBoXniykMq6HmFzDQqxcThr/IfmlDgOoZPNKuIC+zDhP5N1kgUCZZsbWYzGl+Hd/l2puPMeTrCfCQuMoifFcQR73ilsFzGzxhR2RjXU075m8DPRYZ85pBDis7CTA6c5Rs//22RbfVvLoVPjk27p/NfUdoqhnD/CgBTo8frpVxBzQKmX89bD3rLj+6VkL/WYpVANFxKZ84o5Pd2EYK573iFtsNOQFyyrPZ2UyZWYCARLmF+xBJzWxc0TiI4bdrBhC0RzV0+1CmVWThwcmtuMCEc705mPsRhb6/Z+GxdGrXiCa2a7QN+fSqcCqXpxOAF31obti6m5mt0rkhjSFtMv8/WJLIETiPWqA72uVBE0czi/XE8JjSipBlh/e04p819MmZj1ZEDyAxJ1ULiOazj7r8VK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: Low]
> Can the relaxed atomic_long_sub() on sh->charged be reordered after
> percpu_counter_tree_limit_sub() on weakly ordered architectures?

[...]

> This can cause a false-positive KUnit failure on sh->nr_over.  Using
> atomic_long_sub_return() or smp_mb__after_atomic() before
> percpu_counter_tree_limit_sub() in both the loop and the final cleanup
> would enforce the intended ordering.

Yes, this is a bug in the test. atomic_long_sub() gives no ordering, and
the subtraction from the limit counter is a per-CPU update without a
barrier when it does not carry. Another worker can then add into the
freed room before it sees charged decrease, and count a false overrun.
x86 does not reorder these stores, so our test runs could not hit it.

Planned fix for the next round: the free uses atomic_long_sub_return()
at both sites.

> [Severity: Medium]
> Does setting sh->target to 2 * sh->max / cpumask_weight(cpus) + 512 prevent
> limit_worker_fn() from reaching its in-loop subtraction branch?

[...]

Yes. The workers together never hold more than max, and a worker only
frees once it holds its target. The targets add up to more than twice
max. So the branch is dead whenever the target is above max. Elsewhere
the limit fills up while most workers are below their target. On 384
vCPUs, more than 97% of the operations were failed additions.

Planned fix for the next round: the target goes away. A worker frees
part of what it holds when its addition fails, so the value keeps moving
near the limit. The test also checks that such frees happened.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

