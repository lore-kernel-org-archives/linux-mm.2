Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8414BCF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7366B0005; Mon, 12 Jan 2026 13:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E496B0088; Mon, 12 Jan 2026 13:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18B56B0089; Mon, 12 Jan 2026 13:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF5D06B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:36:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 732831A0A94
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:36:56 +0000 (UTC)
X-FDA: 84324168432.01.7007218
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021093.outbound.protection.outlook.com [40.107.192.93])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9DE9B180002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:36:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=bZb19RJ8;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.93 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768243013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKLsWdgVRwtoybHyM41cm4G/0zyebB5vJFk7qiOF3WA=;
	b=NpQIztgZXJNyKvmwIykzeAKt7lLsd9m7jN78Q0AzC/839Vep1GW1qrUC/HE3uzELX/102p
	5ImmFtucUFhUJKZK0N7yabRV4bcD5flOMiVYwHXCcUSAEAZLZ/VLzJScWBERKhE3PAMZny
	Ce1f0rAaDRfNTqx1baGtqkoyDiq4nLc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=bZb19RJ8;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.93 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768243013; a=rsa-sha256;
	cv=pass;
	b=pV796q7WDMoh3l7VvLDXxrTmsUqZuMjurN+TIBd/aGRCw/wQS3h7Fka7C0jkTAoS6s/FK8
	3laoMd1zX+NKDOKZOLTFs0qNCA9BoL+xcTym8VnD5jGoibaOXZzq/JvtaQg5A/RR0/Dlv/
	Vmg+RGqMopwi9xg77pW91gv6HR/6zx4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sYVrFC8bHFIM1nbCVfGJ/+n4hYfSzlPQ/6qCtoGVev4LcwEAxbzX3m1YZQxQXyBdSabWsr6vD4/iK2//DnhVM4ZtfYC8ya5rS7XkyupzOaYLfRjXmY6oiB+zy77W9a7qUpprM8oY/sa5eNdTETBEWcOWt4031mlwjSwAlFwRAojmF9OPHtF8+WI34l7FJhJnSE6APcIvPM0lT3N9ZLu/jd6GfxPbxZBm1RncKR9z4XxJVK1wfTNz0T6mz8GYDcpwSFNfQpJh5PYFevcHH2GsGIUzvKudZEm03YMnYeWHTMa6AvqsO+mrp0FfxmdvJ4YzA3T8wcBhLwNR4qV0giEe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKLsWdgVRwtoybHyM41cm4G/0zyebB5vJFk7qiOF3WA=;
 b=Q0LXN3Bf6dmY6aKtGwtI2zQLP4zzV73fPljvb7IXIgeu8U0BgoB1+8jy1uDMYsdgcu7MbEf+mr3qL2yl25ud9j4yy2lVdJMRBE/0YqPhwRuTiVOHO+Q/5O1ebv/jsM+pJqCx3N/TZYSF1yI5qFBWQfceoCEglw93BK0m7KeCAa9Dc1ktwY4VGMqJ1eaq8IBhXFLMnCkl8FZ4FlNlkaODzqqVwBpI+Scb7kTJKsnsUJHyriO1ldqVkZf5iiqO8+HHsA9ps4g0xrUL3grUPupA2bwpM5OSSGmuXlT4zDRufVE6Tmz2lCnl+zWCB/GrU2ZqsSFzb1RLJsCIG7ViDD4+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKLsWdgVRwtoybHyM41cm4G/0zyebB5vJFk7qiOF3WA=;
 b=bZb19RJ8sATHt1lFQhhMKg6ELKBiBhejnPd3tkoq3IDJ8jjiQKgay63eP5a8tVDyEGDI+2HwOKUXfUP30FpeQExwk7P9w4cKI/jw+Cobyb98PVXVwhA9WTOckPHcqsZ2VwZ0/WpQ7YyWAvgM/dVJjuW4gnRbds2O8EK69sPlYE0M4C2xHRRjg1MphSCtzQYSgoCm3fGuaw+MPyYYkuJftOo4gOpyEgAXdTZ8CqIcSGeRz2M2HVP6Y+NereesR3xt8NXGcM9GnDulmdmZaKkZ7HUgl02qG6sUSE0/loGIsq22FkLNoeKO5IuseiTuPT9OzMZ+Uy8t55qMlsRUMQqsmQ==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PR01MB8716.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 18:36:50 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 18:36:50 +0000
Message-ID: <171c5a7a-f12a-46a0-b791-18e25a3c7877@efficios.com>
Date: Mon, 12 Jan 2026 13:36:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
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
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
 <20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
 <6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com>
 <20260112100523.6ab884be@gandalf.local.home>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260112100523.6ab884be@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0179.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::8) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PR01MB8716:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b53c45b-84e3-4111-613a-08de52098caf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TklXeVduZXU0Ni9JZmRFaCtSVzc5UUkwYVdReDRKK2c1U1d6c3hpc25rOGx4?=
 =?utf-8?B?Z1RsMXE3YysyTkhod3V5MTlXTUNtZENjK0pLV2RleWtWTjB3WkpVTEx2dThz?=
 =?utf-8?B?eEQ2WjY5cy9CWmp4UnN1K0NMbkRFeGZDMWxpWjl5QkVUSlBQeTFmMlZGd1RL?=
 =?utf-8?B?Wm5HRzl3VnlqNzcyY1ArdEFsSy9RM0RnNCtYZFNxQWEvM0VsUWVVQUlMTGsz?=
 =?utf-8?B?TDJHbFdhdWVYQWNjYTRaRUlTUjdvU0RGa0ZuSFF4UUdZUU1BTnZQSldFTXgz?=
 =?utf-8?B?N2p2WW5VdmI2RFpkOTFJRHozMVROcG5TK1F1NVFWUlpVek9rVko0SXU5YzMy?=
 =?utf-8?B?OUkxN1ZvOTZabFEwbkt3L1BlTjhIbVhuWUdRVmU3U3hkS0JSbVA4RHl0YTV4?=
 =?utf-8?B?ZU1WSTF0a3ZhdjlOalB5VUl4MEc5UmNjNjBJZW1TMEdxVnl4Q3RtUThsZEU0?=
 =?utf-8?B?ZDMwYWlhdTZveXROZFJNVjNnZUh5Yy82ajBlUzdJMjduQ1ZLZ1RCVFB2YVRt?=
 =?utf-8?B?MElPaVRqSEsvMUZXMTR2SVNUamRnb3J3QkJxenVXNTRCWGtYQzFmZTRkcXFZ?=
 =?utf-8?B?UzNkMTJrcGZ4dlYvMzQ3K2RlWXRCK3kvWDFvekF3OEhzcmE4U05mQVVEMU1B?=
 =?utf-8?B?QUJrbEJ4cmRqMVM0SnkzSXYwYVhLUGhLWFRuNTdBWTFsRzJaRURSNEk1ZkRk?=
 =?utf-8?B?aHZ6N1RUWVA4R1BoL3JhSEZrZ3dyQkdUL2JxazVXRVBUbytiV2VDaHpIZWlZ?=
 =?utf-8?B?Wnh6bWxNc1RqalFCRXVUa0szYmNvQnNKanVIU1hnT1ZYQmpnZGlZeXlLSlpy?=
 =?utf-8?B?NE03RGZ3cUdaaFB4V2xLd2NKcTVKNnU5L1ZvMlY0WUhzQUtxZG1kQ2Zyei9C?=
 =?utf-8?B?dmFMME5QR0VMbTlVOTJOYUJFMXFUWW5PcmNXYXFWT0RvZUxtdlJwdmNvQ3ZJ?=
 =?utf-8?B?VnpPR05SUnBwbmNhdEFzNGZmc2s0T1NGM0J2S2cvaWlYUGxCelFXN2RBelR6?=
 =?utf-8?B?djFGMitHL0FXcVBKeVJaNXRaUDQrSHZydzNvR3kvaWs5OHhBZUVsN2R4bmhy?=
 =?utf-8?B?NmpWbjVmV0MyZXRpMStkQTFWQlJLbjdPWnlWTldZMFhibjJob2Y2TW9ENnEy?=
 =?utf-8?B?NTA5QlJLZnorZ3FHY3R2bEhzTE9lakpGSk8xaUlrYWN6UThJTmJsNE5WdVdY?=
 =?utf-8?B?UE8zMXBJUjFubHhxd01EbkJkdDNOdURhWmJkbk5pZ0U1aVRXVGZsYzFwMGhP?=
 =?utf-8?B?dysyYkZpU2FJZnRtWHBlaVVKMjBKdkliTlo2WFhFR1hja3A3djR2Y1diWXo0?=
 =?utf-8?B?UkROYmNKUkdBdEFueWFNQXlsWnlsWXNRaW05ZHNBV1pPMXJiK25lR3R2NlJU?=
 =?utf-8?B?WGNxdTNMM0QrZHhRK0xmeVNWbng4Y0hXQTNocSswSzFLWnhFbW5renRSL2xy?=
 =?utf-8?B?UU8waEM1NHFoOFB6Z3llQzB3bXM2RUlheHZzclZMSjNQYjl0RzZNek1vNlYy?=
 =?utf-8?B?THJLVWFrcjhWK2pOZ0djTndGK29MTHIxUXZPSkRYb010WVhDWXovSklYYjdL?=
 =?utf-8?B?RHBsM1FLam1LWm0xUlYxN05TOUFUSzNHckVHaWEvR0hGZjdqY3dIQlFWMEFW?=
 =?utf-8?B?YmNNK3lPTWFEUFlFU3NsTUxDdFRQalpGdVBhL2J6K1VTRkgwbk0yamorek1L?=
 =?utf-8?B?cjh5dWpHQjBqck1WWDQzcjlickd5WERwbzg1WGMzb05VZUZSZGZVY2ZmZDFR?=
 =?utf-8?B?RFJncGRKTW01cHJGTXprQWVhQzQ0ZVJHV01qZ3FtUHZjK2tNRFRKZUUva3py?=
 =?utf-8?B?Z24zRWZVMmVNY3hIU3BkZ2RPRXI5bFFYbEk5aVg4cExjcW9nUkxmQ2pwcFBD?=
 =?utf-8?B?R1pYa3p0RHlLWE5UeVZuakNTb1JUbFIwLzhWcHFTQUgzNmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUd6ODdERFM1a2JYNU0yNS9ER1l0YXZpVEg4N2QzNHovdXhvR2JjOS9CSDhj?=
 =?utf-8?B?MUdlL3FGN0lSL0tLNU5NdDdabXpDU3hRRnVwNVlveHNkS1BNVnRESUs3dzRR?=
 =?utf-8?B?MVhvYWsxb0NxL0RHZHJQZmdBYXdWSjBTQmVqL0JoUG1FTVQybE9lL3UrczBy?=
 =?utf-8?B?N3c2QzNkdU5HYWNMNnZLYUl2Q2RkZDFIYjFWMGpzd01hY1dVTHFRSTFFMmpR?=
 =?utf-8?B?VGtid3BwRTRyUGZ4cGZPSGhOOFh4UHYraE1Ic2NJckU2RzBqVWduenJZUkRX?=
 =?utf-8?B?WUh2ODBmbUxxeE44ZGpnZFR2Sm1tRUw5T01QZVNscS9rM2N1MnlwclZ5ai95?=
 =?utf-8?B?R1Nsa3pkcWt0QndTOW9CTzcwNW9WNm9tUXU3VzZ2R0xyUS9TeFNpcjZMblRX?=
 =?utf-8?B?UmtjRVFEblBYb2tZc3UyWUR5RkhYUHUvVW12UDVVUThNWkN6UHFqY3gvVTUy?=
 =?utf-8?B?ZDQrRU45QzFvTkN3eGJHbk5uL0lBY3RwMHhsSzJyS2JKMHpEc0N1Nnd3YlJV?=
 =?utf-8?B?RXA2RHVrVlkydUFMODkrMUxSVGxGSFFZUHExZFZISFNBRE5vMG82RGJ6ZFdL?=
 =?utf-8?B?V0kyekZSSkM5NUZTMGhnZUZGWnZZOUlvaEVjZUpZNnhaTENCTmtWRUVtTmdt?=
 =?utf-8?B?NjdlOUFnbkhVQ2NtUWg5VUd4YVlqYVpWbVlMQVdrUnVrUEtxaG5RczUrZUhB?=
 =?utf-8?B?Vzl5ZWpRQU51ZnRNRVV5eW5NZEdCU0srMDJnMTZyK045ZVdHRVgyOUMxYTRN?=
 =?utf-8?B?bmdkSlV2SXdkeUx5T3k5eXA0Tm4yUjRMK3c5ZnU3WllEUDZKMHFpL0w5MUpt?=
 =?utf-8?B?RmNBTnk3eDlpSThybHlZY0JNbHdvNFNGZnQ2SWEybi9KZHVCSnVLYnlSRElW?=
 =?utf-8?B?dzBLbUEyQ2hiK0hKeFZ6ejZqRVU1WFNEVmNKWGgvVGNsbEpmbUZtNjJGVFhw?=
 =?utf-8?B?ZGhOK2ExMkQxUENjU0xXWUhlaXdGN3NCTFJDei95QmcvUXpZUG5KY0c5eW9q?=
 =?utf-8?B?b1NpWDZab0QrR1BaWkxkTWVFSTA2QjV6eGNZdlMzU29LS3p5SXF2emJTVnUz?=
 =?utf-8?B?UWxwQWJxVUlqSGVKVThoTzVPblBrRGltQ0x0bkl0a0dCY09rYkw1Slg1TzFC?=
 =?utf-8?B?RnZDUHVldWhoWFdZaGJseEowM2N6SHZvbVo3RUNuZ1h3Mkd5amZOYklLMy9k?=
 =?utf-8?B?SFhSM29GSVVnSTBuWnk0bEJHZjRva1JiVkhVWVRkeE1vNWJUUi9sZ1psUDl2?=
 =?utf-8?B?V0NYczdUYkVqV09GNEQ0eDhWQ1o5UU52VXF1d2VjSmZOMWU4WjhGRGp2TWhv?=
 =?utf-8?B?bXhHbDBkVERIdVkrR3RCQW5abDJESFJuZUlnYk8rL0ZhRlJjaEpKN050WEZ4?=
 =?utf-8?B?VG11anFRbTZZZTVHOEVBOFZMcVdvZHJndmFydEp5Y1doQUlXRWNIclBIQk54?=
 =?utf-8?B?NGwrN25DZDg2NXk5NWdMSWtPVE9RRTllQXJmNzdBRXhPQ2doRW8xL05PYUQx?=
 =?utf-8?B?VEcvd1BNOWJtcFZabHZMSUF0by9DSGpoZGVBazBsZnFvazNLbmN2SlJUSENt?=
 =?utf-8?B?SVREbkR6aWp2RnFJVUZMZC9jZUJvMGlkdDZPWnZrTC9mWU1RSC82eUhyaXNK?=
 =?utf-8?B?T25EQkgxbmtWWlRjQ1h5SzhPNUVIczlneG9nNFM1dlNhYUZEYVZtMm5ySjJL?=
 =?utf-8?B?NVZGaGdrOFFlNWw2U0M4VlZYSTJvQzY0d1lMYmxoOE1nc0lKZGRQc08wUDNm?=
 =?utf-8?B?emFYRjlPZkVPZ1NUQXBQMEJOSTZUWGRybFo3Y3Y1ZWliT0lUa2RLeit0bEJy?=
 =?utf-8?B?bXUveXNBOE9lV2czSlgrL2IzS3BzRHVDczlCYk9XSXVUaXVaRXhlZ1RUZGRX?=
 =?utf-8?B?T0dRUUhWNWU2dGNQWjlSOWhOZkdZOWtlRnZYb1M4OXhOeFVXMTBGMUhqVDFU?=
 =?utf-8?B?bEZ1OUdMTUx2MUNIVU9LN1FzUTZZY0N2Uy9BczBWdnlWdVhPWWhqdmhrZGsv?=
 =?utf-8?B?cXVWbDNXNlVFdmR6U3ZOeUswbTZWUEdYTmlSeFN4WFNFaUJCc3lRNE8vRHdk?=
 =?utf-8?B?ZnM4aUhURFJURUxDWnlaMFJvN1RoT0xMdUNjc25rQnhhbE5IaTVTMlRsY1Nn?=
 =?utf-8?B?Tno4NytOZ0w0MUxXQ0lhRnd2OGlGeEVlaWlPeElsaExWTTFPVlVpbFpJRXRK?=
 =?utf-8?B?ZzRuWHZIRW1SUTA1QkJGRk9TRERWdlVBZnhGY0VSUllTdEVNOE9BNWJRVUVY?=
 =?utf-8?B?Tnk5bjhvMDJESERJQ2dzS3gzU3RlQmtYNjRjWkhGR3NMSlFHZWlBYnY4aUQ2?=
 =?utf-8?B?eGtCNmUvd0d4Q2daSkJCZ0ZUY21TYWlOR1lFK09keGRudWdJeTkvTTdMV0xq?=
 =?utf-8?Q?BX/Fvu8CcS9Azx8I=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b53c45b-84e3-4111-613a-08de52098caf
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 18:36:50.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOkGezWgHNfvKxYavjat/D9vNd1KYrcMX4U32owr3AAeSYH9rgKk7HQzEkPYO+rgGq3da4LaoMf1u85gc+H7gLIuCOpsKxNrpVar5UInDrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8716
X-Stat-Signature: rnmjycotfa9nmbtcrcayaf7hbfh8moec
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DE9B180002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768243013-994707
X-HE-Meta: U2FsdGVkX1+CiEVghD/R543ta2LVxebBBJJgXKvdVed+gAdguadOFISQjUYnt6ZpgFLUY44RK4VAXcStOyBQJ2nhi6ojZ0SWSzxZ3kjhVjVa8PuRspusIPgGka9OqumdpsUTEVsLsK7kQN/PVn8+G1xbl6dJWd4BrXFwCqO7to0B7Dl/HzlrR7z3Z8QT+lkNTjwvp9pthivDHYVmXrXHSOQxJjg5+A5SDPr2vjeIK6F8q/0mQrFl7YPeTs3LGz5nAIDbElCezo0gjF8fe+5y8DRary1j7Oms6SMONYZilJC83mU90jmvsScp8KtHjzvxogqphNH0Ckn7HgCNAU7iuJwTKwHkzyFhWlnS2VHLMgylegoGmSnHbMhg7mJBgQFQUsen46HWJKGCDSKonhvOqrO3KX96csfVOGkajbb0A10QOfjAAEN1Y+42jiVuBz/09CM7bJCyIl8aiWOSaf+ZQHFR2DvLt3NB/IFqa7suDf3b+/wIqdzHC5h6Ez0JssJGyVnBqy+H9tSOnc1aL0jdUWsPoqg9K+05DDZwZQxj9LuP8jl2SzjEW54pr8TKL0wvdmDiJrQkx9E5cl6T/apVBMwHhxFix50UYsrnOM3yxn6v3kCXhAp5c3v5wH4tWoLLyohe7q4v3Op7MaXw0BMvJ+Z/phPh0ATvZQlCtB71017stlEnI7ekY++FAx1f14UEyRQmrEyIUgPiUr2A3wAPDlJblnvqcwy1ilRckn4kmR4AleNZgqPeNjHn6we68gXf2dKKJpg5hWZuysgrrKPQtV32lFWpgJ8SNyKsYTeB79MLj2Uj2k/heW6z26cyYmaCvPo244O6he6+QDbMPHgY8DRT9ytPGlU5lm+Nfhj7AyxrR5tyrnEXMMoDpieuW35Qe2e/YnlR3nK9gF+34OD3kffWJeAbFrjpRz2wftBvLxYLanTMI1cO+J9LcMy2CQmK+fuIAsMWcg12MUJE5mg
 Mu+e6CnW
 VXSyqDDpkUyahrGYZ9EtC2bqUQdQ2CIb1iXL0PNFTmmPfpzCLEXUEBMd0Scax9L9yeRaw42F7X69Kg2ZDq9bBL3dN1zNxd0ILknFVAa6TIvk3jl8lC5KV4eIinjZgMLoEl4P/2UbyywCDgfuHkdFFRVp3wbGnH0JfsO+NXJQi+zHIIBLnKLWJKTxMzhaXSoD2L2UHVGPOQYnVtv/Rcck0nL4dY/YiQjA5/capZ86B09PE/ki+d1UpUu18cEKu6iYFi1oaa+Z4zOdFxjkXqZFtTODgLx8zYindpYdznKoblUM7XkGpZYLyFZ+BFEtiEeCy5Q/7pAegw/xESDXgueDMNgzoz07yuk5EL7wO99dyjciB0zFW9oWqOJNhUFen6rFS2E/DpCF7rOcKlkTsLX9u6FDp9eptjhXNLC/9o/OA0ZSDSc9meMpFaG7mwdhTbTKkZ9naoSlXOuNc27tsPZDRgWqPeXBF5Kq5tgq5B4RpbGv0KtGDREhnNSarWYW/wTCMa7EnSv6CV0JY4FnW60EGnyUUlf22GkhUsvs4E/66uslh5hE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-12 10:05, Steven Rostedt wrote:
> On Sun, 11 Jan 2026 13:04:59 -0500
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> As a patch author, I find this feedback really useful. Is there
>> an easy way to get this feedback privately before sending out my
>> patches ?
> 
> Hehe, we all want to look good don't we ;-)
> 
> For me. I let people see the good, the bad, and the ugly (probably more than I should!)

I really don't mind having healthy discussions publicly, but I try
to minimize the amount of disruption my work brings on others.

That being said, I think this AI review can lead to interesting
discussions where others can pitch in, so having it in the open
is worthwhile.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

