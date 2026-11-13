Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1235D606A334
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=DIho0Mkm
Received: by kanga.kvack.org (Postfix)
	id 3052E6B05B0; Fri, 13 Nov 2026 09:21:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC246B05B2; Fri, 13 Nov 2026 09:21:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBBE6B05B4; Fri, 13 Nov 2026 09:21:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E338F6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:21:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44323120175
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:21:24 +0000 (UTC)
X-FDA: 85430308488.15.6DBFC63
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020122.outbound.protection.outlook.com [52.101.191.122])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5F998C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:21:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=DIho0Mkm;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.122 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4Lw3YdQYq+oj1p2tIKtYCZHPrF+4Xhxem8cGrlCsg0=;
	b=kGwxn/EBOmiT35guFfT8vuCXc+hW04QHPux53aCG+C3HFVLMibf5n1mJgdp3PvAstws3Vw
	XPsSktiku5ycut3vPDViHNuYviX4L+Io/lUIYgsdgL3MwsEJ+zqfJ4/dwmcdUCG32kLuZ2
	A83B3LCm7I+p3Qm1+Q8juPCKViM5uFM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794579681;
	b=1kcllgP86zO4TRS/BLhCY7Fiqn8nnk+PHNnS4luu91FSaaQR75ha+9yARknKh0z5RrSYzK
	+nBn2raCFysU1HUc55PSgXwBRH5BEbcX5RzEO6LSpi4yxHRWkA3uCLnFWlKz8hJKAoeYZd
	tgJKp6r0mh7wwOmVmsAiJbE5fL2NNTY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=DIho0Mkm;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.122 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5TlA1Ad5gu8wBEXqa1MliMKLe1rNGO2EwMrJCO4rJZstQ+vi9jHrXD9GbnYRZkvFvv3jHZGHJttxLPs/mpLWYjxBm/Y0NTobTirShnazubYFMV9g9JGOH3xcEpqRK1njQgWoBQxpqGgTZxFhk/+qNBd1z3eUQciKL6syLeGMvG14he3sT6jcrJIQZBmnXXzxu7j+gvDbXJMfrR1xOjMLZnn3RRwgUqy2BDR+BOgUMn8BQB68zNKSHyrWzjJR3Ons8XE2KuWE3/TkTfhKRtuvUu8qKATDdsFT8U0p6Pi/ENWB2HSqg3poECxPFbyL/9eyBW1BGNgEUwqwJrtpa8cYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4Lw3YdQYq+oj1p2tIKtYCZHPrF+4Xhxem8cGrlCsg0=;
 b=k7F5olEXY+bPJm6eOv11viWDxGrBfnIYDK4jybFkdc9obPmWRB3xjH1Apmc1J7QlK/F5ZVRicfMg4szK0GWH7KnNWrw/1Ua58g12O2t87WAsfOh+cJkRYuVeYGgf2ElGpjpfBm7h8/yVTY3P2Kii5fp/hK0Pp5oDRFpyZuIAASvb0AbqB8hk5S6p5bIethtq8Fn8bYui6sFDeqkcpTFnQcB5ImcB37by4ddJH8zdZxnfRYZpXt6587yI3WrtsvF9/zFnQSE8QWvJsGn6jweCNleiDaViDmDX11rZoapVNs+U6tZjFES5d8Guu5UkeDWP/xPu5oyXzbFJ1Os2RYFaSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4Lw3YdQYq+oj1p2tIKtYCZHPrF+4Xhxem8cGrlCsg0=;
 b=DIho0MkmNznOq3aeniB23IO1V11U5dVhE3jVdtK4MXJWAfr+5HkNu1djGThw6+ZKoZVZOvgJA3btMO6sOPb//SUMSoXkmTTLBN1C4CWNH34ZeMva7c5a+6vWbNde6clCRg04Cg0+x3K5H4frfZtAP16bOiN8ng3Z9BEaaRmXb2VktcTgEdUGs5gE5zZhIxlwjeVC6r54sJB0KnGWOO1BvKRZZ6JGUXrOl7nWeOMlV9QJhXva4GpkLjuFWloSNaccEmdjn8UtmKza06trMU1NNY244IHJW1ga9gHfMpSaEOIwMuuZOBwbScEYmCg5IY6xr2WKcl9gyVWBAIfufBvwQg==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB912907.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:21:19 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 14:21:19 +0000
Message-ID: <3a5521b9-37e5-47d2-8f72-00d205cb52da@efficios.com>
Date: Fri, 13 Nov 2026 09:21:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v25 06/14] lib: percpu_counter_tree: add lazy tree
 activation
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
 <20261111203626.95838-7-mathieu.desnoyers@efficios.com>
 <sashiko-outbox-211801@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <sashiko-outbox-211801@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0082.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::21) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT5PR01MB912907:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ce6c92-a160-4b8c-8087-08df419162c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|261026121527099003|56012099006|4143699003|10067099003|22082099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bmVOnKWC0WgWYBCGCRew+6UFYIdSGCLTzZjICL1NYz6A61ZRlN4dQYTQX0/NlsNqmAgHbcrLR0oec1rmmDEbzJo01F/ORLs7uEW0ggqrdayOsx/31Uhy20ij7upjI+UsKRcFlXBgb2URx43gLT4qYOvfP9TtfE8EiftuJTDQPuLe4futxZwxBrubh19M3t2AWGPVLA8PuYyEzs2N1NxWUYp1dZxlBU9bezLheeBc5g0g6nqXbZvuemffQNKgXwSzUE10xM6b4C3+IRTDN7nJ1Bv2QcFkLypnNxmPWx7ICD+9Bh4+JUXL6hk+6FbbGU36kY2SWv+twynfuQrlVyC03jG8URq0gIGNaComRjtQy8yMjDOxD5PSY1yRzI2l8C6xjD3sLw6XWDUtvrh8dM6z9iLmBYNBIRhbSCYdi4YbY8F6sjTlAhdDhTrtZvqfxUu9bI+hWLa1KeSI9ojvLt9rOaWF/48JbaTdYn5L254kyclgAawmP7XwwUGQBt7oEu1lUfv78GtobgrvfMZRxtWTL1qGkUhhnIcOsoOqYUI4zKPEKUym6Xnmd/erDLupibI/KJ5gUN9OSdky0vuxulojZvKVqR+LnVp7edrPZHOyAh0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(261026121527099003)(56012099006)(4143699003)(10067099003)(22082099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2ZlcUFJejRCajVmU0JodFJoU3pQNHdqYW1EK2hQL2pobmtrc3hpbkEzRXdH?=
 =?utf-8?B?cjJjMzNJRy82VVRhMmFBNDFqNFhWZ1JrdEtxUWxjYi9QaDZRUlNBUVV4Z3dY?=
 =?utf-8?B?TlNCcVAyQzdLNzlDWXF5U1FUY2YwV0lEVFJYeDJCU05qZUlKZVh2SWd5RTQr?=
 =?utf-8?B?eXJsRjl1cVhzNDBsVExBSGJ0ekVMU3JjYlNON1FpdSs5eHMwQUc4a1RqSDc0?=
 =?utf-8?B?bXhvNUVaMnowelJJdjJLMGdDSHFtVktsa05TTERTbmFSTmtwV0RBM3QrZFpG?=
 =?utf-8?B?YlZjWlFkYW1jMk81THB0aXcyUTE1RTlkaEMxdnd0ZkVoTkorUm8xdEdXenE1?=
 =?utf-8?B?SVZOaExvSC8wanVod2hEWU00MmtEaDZJNmVVTkk2Ym5EeHR5NlgzSVJaUERy?=
 =?utf-8?B?dEJ6WEZTSjRXM1FBS3ZuM3RJeU81M3A4cWNSdGdEN3RIc1dNZ2Rxb25nNWd6?=
 =?utf-8?B?RENPOW5uQVNJTE1TTzVNeHYvaEpST3puTEJqWTQxV3BGc3hPc3RwS203eUd2?=
 =?utf-8?B?V3M2VGl1SWlHWHluOWZsQVlzSnBwQVVLQUtnV1loVjB5RUlaME1DeTVsOE5D?=
 =?utf-8?B?cHpKVzR3Wm1FNGtWUU50cGRWMkh1ZG44VzFiTmZiSGhMUkREbDRMU0N5NzUx?=
 =?utf-8?B?ZHdSRFFESkd3LytrRElnSHVpTG9GcC9ZNzc5cjZFNXl1dkkxeXNGK3VWVk9C?=
 =?utf-8?B?TXl0a2dPcEs5bEw0RlR5QXk3MWNaYkErMEs3R1JPS3M1SjcwYm5CQzR1TGFm?=
 =?utf-8?B?emdSUFRNWlRPc3UyUy93RGJIaTMrMVVJTmhjeEJ4ckRwNTU0ZmZwNUZlK09r?=
 =?utf-8?B?WS8ya0JEMStFejBpR3B5QzFnaktKanFhbnF0WmtWa0hsMTQxNWt0MkRDNGRv?=
 =?utf-8?B?U2JJZ2pOM0c1VHV3T1U1TGdlYWh6Q0p6QWxHRDJKU3VpVmpWZ3ljVTRNRFIv?=
 =?utf-8?B?OVF4VUNrNHI1ZkpqMEpvN1VBSjhLU1hvaFpkZFU3bkxXbHh6cnF2RG1sM00y?=
 =?utf-8?B?T0FLMnR5S2YyQzRXZEF5T01jNDN4OVhvWjlldkZHdHVLWFpvSk8vV1pPQXBx?=
 =?utf-8?B?OVhDTFg5U3U4NmJTc0NiS2VCT2NEdE1IRGlzUDh3VEsvNU01UiswMDc0bDFG?=
 =?utf-8?B?L3pJQTlENEkrVVU0ekh6Mk90cGs1S2FSc1JhZkM3Vk5MclE3VFErUi9ZTzky?=
 =?utf-8?B?SjVGZms1bWVjKzZ0TFRJNE9aNVFncURhc25OdFEwcTliTHZiVHpTYTdnMDIv?=
 =?utf-8?B?UHN5MzdTbXV0MGJST3dwQzcxOWhsekxqWllSY05BeFBHQlJJcVlFT0hOOGVU?=
 =?utf-8?B?ZTVzQUU3VCtkNDA3RkFBNUdYUThISmowZ0dxQnMxZHVDbEhqL041a1hQQkND?=
 =?utf-8?B?WHRBdXo0QUhCd1k1QlRleUNVZjh1MmFVYkxkaEZFSWw1ZlhGbktEVEhpL290?=
 =?utf-8?B?cEJYL1FoSHExUSt0bnFpUkJPZVNvWnJjVlJFcTczZi9oNm82NUhWdjBEWFVp?=
 =?utf-8?B?cmNYc3VOU3lSWG82ejhUeXU2eUhwdzlENkpjanFuOENhVGtiMU83YktIUzRF?=
 =?utf-8?B?b3AvaVVsRlZ0WmczWFZaUDNRZ0FTdkxwaTZRWnpjbEo5QVlZSWdCNDZFaGlC?=
 =?utf-8?B?MWVxUzhEVkozVXY0TnBHUFZiTEpvTFVKdnJEUmc1cHVxOVk1Ri9WWjFDejRL?=
 =?utf-8?B?L0tNN3ErRjRMK3cvNW9qOTF2cm80dzduWUxoYXIrbFlsQmFBUmsrWWtLbmlP?=
 =?utf-8?B?cGdsOGxPcmtGb3NaSFZLeGgyWjFmRmw1UHE4dUd5Y24vRXRlSjgxZTZnT210?=
 =?utf-8?B?U0RJVHhnUnNOM3VLNUh2T1pLekFtUytvMzNURUs5Wk5FeTg5QTd2YkJwNkgv?=
 =?utf-8?B?UHpoYS85ZnZmcnpER2pmTUdPK0ZiemJPN2FZS0lYYnB2WUZOU3pEUTE5ai9P?=
 =?utf-8?B?SURRclJIMFEwdjg2cFdJcWp6RFZ1UWxmQXVZVkNyNE5ENUZEckRHZHZLUHkw?=
 =?utf-8?B?cGJoUmxHMHlqRWsxZnI2OEpROEhScDc2cXNYeG02RERBei9hcWJwQ09aV01q?=
 =?utf-8?B?R3VIbnovenFHYjA0N2gwTEZVK3FoTGVtRm1YdXNJWWlBTENKMHpzbEszK0RM?=
 =?utf-8?B?UnF3QkJFYUlRaityRU12TWNKc1hLaXdoS1VzK3hvaGZ3T3Zxd2pQVUtQU2Yy?=
 =?utf-8?B?eDA3eWV5VStneGFYcWNXalRkVlNqdzE5Z2pNYk1oUlNZWXQ4UjFJUmczckFM?=
 =?utf-8?B?UkFsZ0lvVlAwa1lBMVdKQWl0dk5XUU9IV3NOcHNsVVBZUXhRR0lwakxCQzBu?=
 =?utf-8?B?UTg5K0wvRVIwT0tyWkNzVFkxajk4bVN2VWxXVndOTDRSdnVUQkxzeUw1eldZ?=
 =?utf-8?Q?IWBBT30nIF23k0CE=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ce6c92-a160-4b8c-8087-08df419162c7
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:21:19.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7QpFPZb0Z56/TBFDNaQzE02J8GE+2CjYTG2ee8HUfZmNzzrnhAxM8827JxhaIj8Xz+zG+6oDDwIghT/iv1hMHXGXKWGZdKfrhlo9lseyW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB912907
X-Rspamd-Server: rspam06
X-Stat-Signature: ucyt41w9yo151yubdowjgjg851ahmg5p
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F998C0003
X-Rspam-User: 
X-HE-Tag: 1794579681-288061
X-HE-Meta: U2FsdGVkX182GJoFqrdB42k0yz0jqPAz+ruhQosez/MKi/8XAVko6UCBtF1bCUrAEa+WE6FOlyZjVTexnjrycrkdgAuEkL/dDvyaa/IS8Zgkb4wK2qb6SrQO21fbZrZ801vfisw6Y/paslzDkYmH6p31c4I5oJt9B9d+xbr96nJ/Ebq1kyfLvmzSoLl2zbbMUVzg4ky/mCBRAALhR21mn6W9bDQdvvn27jQ3bCQ+QjV/5LMCrytjPOgLZDrzWEfWnsQ2JBLpsHhPv4KBHtMy3+RjRQ4CVuT1YPjiLiqsV7P6VSWkvstQkWN4EsTrdhIiktiUvAAuHuowPXrzRk9dUC68Tb5kXSsODr296mnt+zbV5oxn+PeKmurPZKPvdvoI1BcByEnmZ6cpyz11LyVE8YTXN+wUE905PspByArzOmkyJNm76WSnWKlqzvJ4d3ScUvsQjLqcgSx1uCJsuNecgSN7dX4xFcVAEzhUN/Me4sf6+DX2oVkvXio/LbdC3Oajbm3khyjOmISYk/iA/S+814KgKJxWvQ+Zf5p2KjjMOQLKRz3lvfpwBEjgpnLNTsqGrs2/hh84+0T7ng++uxxQoNQ/LVcm4J8Oi4xszi58BHguL9qpLTE4uK2G1SP/MGETcGry/CQG+RTdJQeTXwhPLwSbCq4ZAiaJerPS5slGGu9E3+Rwe2NE0749FovGe+ZVBwsvBNjWGjtFlnGsDNlfQhQlI69CDkxqdao55hRskUtu4dJSj36MyNk5+YZ01Udi0uxLHuGSCqCnn9oWpL00iHrimZfMgRYaytWrZ3uIVbJV4WIzxh2M6Vzqn95erGYuCaZ9JknQYDKXFAJ35bDfRrAWCBPFiBGT24H04HzMzR6kCLwDe5WU4NrFN9lYoM04VgVEpN7/LS58D7hLZSkFCOChy9GdU3xzhBDWxZ7fwBYAefZg+kV3FvKM+HQ+p4lJq2EOQJdag5dx1fcudsG
 Q6wLKq6A
 cdjaQxX0rF22kH8gIoPgksKE3WyJzZngD++x/iJu9qk57SKatolJUGiNJ5x5lmlTTHS2jdWb7RbGR7/CQ6njjE8sbnvhzcKdtHSdT8rwT4UlG6TjYpuXDDbzmPOpiD1ADMhDXuJaUnEq/1ua/q/HiPyimbgWpounKCBw1e6EwQZJLlwpxu9hB60cf3bhp8XWuZZN2egoCkCwbSzKkk6zVXzPUI+D5rjvmaRtuQZu7CHZYWk1NDgVtsapzZAmJ0LR+5MXe/yMrqsXSERKTM4kNQYgxgpMPfagjL/aiDtPGYaxsZeH0J7lbxaMDC52MyCSpGuHTrRdn0zQ8wcR8Wt/dRwC/LmqdnJ6D5sLVYR3tD4U9SZjyEBLFBMMvj0ODRinH5t6KVmxzRDwuRE9RFkOFoeQgy419fwL6vKvtzA7SmiLzOC9hRQz5KJBAO4UzcC5DiLHxYljwUSvJR+funBEa7Lzv31d+97AopA15GShw7ZhsiiSLgldMox4FJaUg8qP5wNqf7TyblmmoUjJZHy6W3XFYc+6ClcLd2Gif7528O8saG7Z6KKD4s1rUfuJQ3+7vJVvGtsOgzsH8LX6UWp+m0IFKA1i8WaIz4iWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: Medium]
> Does acquiring sh->activate_lock in every non-owner worker right after
> sh->go becomes true prevent percpu_counter_tree_add() from ever racing
> with percpu_counter_tree_activate_many()?

[...]

> None of the non-owner workers can
> reach percpu_counter_tree_add() until activation is already complete, so
> only the owner worker's percpu_counter_tree_add_owner() calls actually
> race with tree publication.

Yes, this is a gap in the test. Each remote worker takes the mutex
before its next addition. The tree is published by the time it gets the
mutex. So the test only covers the owner's additions racing with the
publication, not the remote ones.

Planned fix for the next round: only every other remote worker activates
the tree. The others add right after the release, so their additions
race with the activation.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

