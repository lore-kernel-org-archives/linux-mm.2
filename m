Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101ACC624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1696E6B0099; Thu,  3 Sep 2026 15:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119886B009B; Thu,  3 Sep 2026 15:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5706B009D; Thu,  3 Sep 2026 15:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7AA96B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:09:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31131A065C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:09:18 +0000 (UTC)
X-FDA: 85173389196.26.27767E8
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021084.outbound.protection.outlook.com [40.107.192.84])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13F4FC0012
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:09:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=jpv72Dgw;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.84 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788462555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GEaROtKaj6cYzMR5bJdk/qt3k9+Sf2aPtlj6c9+aNbs=;
	b=hhqRw7F3h07n4YGKTrOqBlOC9g5EZAgYJf9v1gA4V6inaBBYQ4UP92ey6535VN7iLa9146
	OYgw28rv57gWFTXvJL1APE8HRt4r09dx2Ux+h5gWFq2SCDRml1jhLs7IMkSET6Lgsa4pNF
	xQStcQ95TGkqausfCThVkiME0Rqh/+8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788462555;
	b=QYJhR6cd4C3S0nwFinZhUnSsKkXMyDa0HWq6VujrNVw2zZPCcX/OlgirXjB/mBvliHxi2F
	3HOHQ2NoCYy9Rfoo9je4vztduGotJVaOcnvMmzzBWfUW6G0w7y1bxOdJDxf3+U1vyjCaFs
	U5RE/CHHWXkhIctIhJHw3tjVcVG9G3s=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=jpv72Dgw;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.84 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykgRI6N2lexFvWdWcyP7hYs2KWS/34LwrDBqJVqqgMswdo12G9Xnl6qQI2SUK+yxVEb5L2Q4AxVFIspRe+O4zveREVGFYN55SgbkvhOTrym7MizkM/nur4EZJBwy9wIWwEeZ+0vYXHdsBpW683jJ1U2shxS7qmNIq/gEODb8bgS7BpI+hIrVM42zwGc8CQlvuu9fEcWfDkhoL1CA+jouFPx4SYa8BUXBn9IWee44vwAmfrlhvT8i81dgtz4X1PjECZfXkZ3c+h3/ldIYpd4MTIwwH83qALn168u0aDq5f4wqeOhLMNs2+2ctDuGR82wl38/ps92vjB6RcQprwhVU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEaROtKaj6cYzMR5bJdk/qt3k9+Sf2aPtlj6c9+aNbs=;
 b=PKisFfSYLiH5uG09zpkA9K5QLvBVSAo8NLQ3v/MS+XxAaimAe0+zRoMxula9CckpJ6cPAASA/mEA27+uBYRRZTTvy1GrmNAvg7RP8L3/PnVkbQ2NoMa+qNZb5atmgg2wxoF1XWtjf/1NtJ5zqy1zLmdgCMMxfOPHWjuWh1/qZ2ShaVFA3U1N/9LZOgTKxSpjOAF3NvW7teH1MRzIeLre7tqt4wiyG0Hcw8hW7DEpy+saZRD677q7QQGloMDgUXCwj+qsNcyqIoVxC1yZa8i/lOlo/ZqPtDdXeZHUN6erXuVtBXgQlrqLcXChhV2IttkFsGsvj/MBCbrfzKvoVXJKxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEaROtKaj6cYzMR5bJdk/qt3k9+Sf2aPtlj6c9+aNbs=;
 b=jpv72DgwgiPef/Y/5Qt3oArlBCfUNRFJkZn2Vfhmnt2pDW8rLGD7R0T9o9iV47b2NvRaiSqdBqGxR/bfZ11f1+xPcGmVMjMMAWIfBqr+yfmvnoxzAM1VaMj36TbYt4Cgn4HPo9wHXzVCT8tvjMJ4Pw+84ebNGnMnsfPZkt/NtcO3H9249uAuzxjnXbXV7RVJc3tWQUmO/UyxRiYUclxjSenKmept3uvMwVv02PhXOAzPIRrAoVSXYPbFWGRz0tIfjIV1nb8yjQDNaEMqIqvn3u9fVHGTzlEOiA9uD5IyJi8Gqisje9YtM63cYthwtXHYi1Il6Nh1wa3ka1XNMKogqw==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB237853.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1b8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 19:09:11 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 19:09:11 +0000
Message-ID: <e5c2f04c-64ac-4a5d-8e62-2e7ce0083fe9@efficios.com>
Date: Thu, 3 Sep 2026 15:09:09 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 0/6] Hierarchical Percpu Counters for RSS
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, Josh Law <objecting@objecting.org>,
 linux-mm@kvack.org
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
 <apmrfy5zsjmWMNj4@linux.dev>
Content-Language: en-US
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <apmrfy5zsjmWMNj4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0246.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::27) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT5PR01MB237853:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f80b2b4-1e75-4976-c8dc-08df09eed63e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|6133799003|22082099003|18002099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	MKMn0jK9r6TIJkGedtNEbE3KlqocwugEVGdY4bYNPyuwYOcIImtISQbWLciljfwQjVHv2xSw3ZEixt8GzASlcdk3YylHrrTSuQJTjXxx+4aI2D4a7uOXeGPy3I2xvKmREV5ZFKEwb61khLsJqt7J9GRJlVDrSJsf8r33Y8AGnZ3bdy0OXunGB4st33qH8zyoDFnacgc3IWY1I6LT9yzfpeZz6csmbBdEVOaRuBHY5qj9dFbU7ZPsxKRZ0DpXWgLE1OtkhZhWC77r/BzpA5fLhFDIbnyXxNwBti63MuF7BiDpdXLTwcszgsEnTXkvV1/C8bn+eeiTq2ioiUtTscva/o8FXLBi6o8F5CFiRbbo0PWOx9dQjmnWW53kdpczLZaWGhgC1ADzsOeWS0nIzKk6Jte6WU4n01uNli/kQy/N8AEDABsCeYnR8EHpP4/TAlr6txG6Fd/vFXe93Qs33+TI8evwk5r9Z7WmL6P1xnYfKgQjZom3CcBudTtTEOKh2j1KP7It38JqR34oj7uU+Gv85jfNxU5tTVoB6mVnUzhXzU435LQjgGz7DdJuGhy7JaZhnYJQjR4/SW0FeGvSU4RVf/0JXjlLGnkiKATqq3NNXoc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEFPUjJpOS9COTgzcHBOY1Z0eTF0b2NXL3pRNWM0WEJ5V2F4LzZ5ZnZ1M2ZX?=
 =?utf-8?B?UThScEpPQ2VndjQyWU41Q1ZObXppbDFLSmN1SnZJdkxkUXhnOUZHT2dUYmRp?=
 =?utf-8?B?ekVuL3NsNzNBQ05hWEpLaDlKTk45NS9vcVlpclBNSWlmU0pWdjNuMTYzVFR5?=
 =?utf-8?B?WmlBYTcxMStxSGZ1anR4eGxzYkNXRVdZMWxXU0xNb2EvbGgyZEVPSTVHblMy?=
 =?utf-8?B?SVE1NUJwMlRVV0pNdW56R0xVOVprL05Ld1BHK0JSZ0pnRWRSUTZCRC9IZEFU?=
 =?utf-8?B?WnQ1ajBDNmc3Ym1yRzBWWlI4Z3VNUld5UURrNWk0MWdIY3ZwWjFkSk56ZndG?=
 =?utf-8?B?azh4TnhwaXhLKzRBU1hCU0dyQ1h1Q0VBWXpNa2ZOSS9Ka3pYbWMzOGpUNURZ?=
 =?utf-8?B?MFVJOE5vUHdLS1FVV2ZqeEVjNFhTdlkwbVBhaEhnMnd2USswdjRnTmt0MXFk?=
 =?utf-8?B?NEZ6ZFNmQ200V2ZSdEE0UjVzU3pLL3BmZHpCUEJLT2d2Y2l5OFY3UEE1R0FX?=
 =?utf-8?B?QmNocU43VlIvOFZtZlBNT1ZScWdtN2V0a3pMM0pLYWRyK1B5NDJ0cnN5WkxF?=
 =?utf-8?B?clU1bU5KNDBZOWl3ZGF4anZLaEVvZ3VUTksrM01KQUU5R3hXRzdlVkNhanMx?=
 =?utf-8?B?cmdKWXNyUkVFTlhZbDYzUUlkVkQvZ1krVGFteU14OTc1a2s1NGlLNElRblFR?=
 =?utf-8?B?OWgyejYrNDFoSnNUWXp0UXVOeHRrY1M3UEszNUxsVU4wNU14ZXRlNUt5OUhk?=
 =?utf-8?B?VElRQ1FzREpsTVBpUEhlY2NXNXVYQmdVREl0WHh1S0lXQlVxQ0ZmTFUvZmFo?=
 =?utf-8?B?dzhWdG1KU2w0aFFXVlRJbHh5Vm0rNVJvV0hDSHFPeGpRcFd1VUpIT2J3eDR6?=
 =?utf-8?B?eEViTjBZSFBjNE4zbENjV3pqSmZyRHl2V1U4dTUwRFptYzhXdVZxbDVqVFNV?=
 =?utf-8?B?ZkhESEhURUZkSVVXSWlUSGNXL2JrUFYxMUpIcXJIZ2ptUFFTOG1DQ0dlRmZh?=
 =?utf-8?B?L09hR2hocUZaZWYrNkhBZ2x3c1MwYXBJVDhUcXllaVhIUTFjV3M5VW9kVXBt?=
 =?utf-8?B?dm5FRGk3NW03REYvWlBMMkpvS09kUThRNVBxcGZqU3pMdjNpSEI3bFBNc3My?=
 =?utf-8?B?TlI4KzFaRVZjTjRDWFZmUEl6TW9rZlFlVVZtSjZpVGs4eGFhZ0o5Q2s1WEs2?=
 =?utf-8?B?b01JRjlTOWc0azRKa0FCQzltb01sbjlCNUhPWjFRQVIvK24wRGpGNjl1M1Y2?=
 =?utf-8?B?Snd6NFpWRWJLKytGRWN3NjdxMVpOZFd2L20wVmVJSHZEc2hHeWxEK0p1NHB5?=
 =?utf-8?B?M3JKMWZMUkVLRGl2ajV4ems4RGJ3cWxWK0ZhU2ZmRHdMT1lwdldyUlZ1N0tt?=
 =?utf-8?B?YUw1TVhOejZ2MVkralNKcnYzZTRDeDVJT2sxdjJuREtGN0JGTENMUFpxTkd0?=
 =?utf-8?B?RHhqNnlaMlIwVnNoUHNlNmRkOXk4dFRDMjg4R3lmTkRFVHFBUGgxZDlpSzJ4?=
 =?utf-8?B?WHhuOXd1SXJjREdNY2tYbXhaMkNxbFVrUzE0Ly9vWGFGS0hXbEhodG4va3NL?=
 =?utf-8?B?N24zcEE3eEtqVVNEQ3NmdGx5WCtMOWRvVmVjTS9JSmFFR3FHOEdjVVBYbXlF?=
 =?utf-8?B?K1lJd1VWMkh1OUhNc1pEbGJvalA3RXdzVkY1NTdHU3V5clBIS3hXc1lQZUlm?=
 =?utf-8?B?NEdPdkUzRHdEeUsyMnk1TWRDMmFxMi8yV0hQZExrUGg5eVJtdzlHSnRFS1JY?=
 =?utf-8?B?bXgva0h6TjZuWWtEbi9waWJubzIreUlPYm9ndkZKWFVaNVNLZHRNcmQzYnJm?=
 =?utf-8?B?YXZOMHFYaGhUcW1EVWpqVnlKR2dVRkNKbWJ6WlNodVNUdDJENjNrYnEyV3Fn?=
 =?utf-8?B?eDNzZ3BJOFdkbzNhL0dodXluZ0JobEJBczJaMFNCUWpzREZOUXFZZVZOYVk4?=
 =?utf-8?B?MEovV0YzL0NsNGlFVGp3WXVHU0dBaXFKYXczZDNqQ29oUEdzdUJzTW1BRWVF?=
 =?utf-8?B?eEFXcHdiZTBpdTROdzA2RGRreUY2bDc5akIraG9mZWYrbjYxUEVEMGd2aWZ5?=
 =?utf-8?B?TWlFL25yMzE3V0toT29HMWdmcVIyTk4wSFVrUDNZS3pqb294ckd0N0xoNlJ6?=
 =?utf-8?B?VThmQUxGenk5blg1Z3o5RFNSZjFkRGpmRTZHRDd0Z2FyUytjZ09CVHZzTlBk?=
 =?utf-8?B?aTJlMDVJYU1CaVpaRWZ5VUZYbjAyYkM3YWJ5dUFnVEIrN2xjY21BVWVyVlJQ?=
 =?utf-8?B?MHNyNW1WL2l4Wk1HdVY2cURSMURHeEswK0UwWW5NNzJmanlKTnN6ck13ZEcz?=
 =?utf-8?B?QjNDdHJ4UFRMcDNkTjZWek9aMklMK04veXVnUzdPVDlHcmlrSDdZUkN2cy9Q?=
 =?utf-8?Q?q6lpK1hTro41Y+saIOjoUU58HlmZz6evkgw24?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f80b2b4-1e75-4976-c8dc-08df09eed63e
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 19:09:11.2390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89l3tGzi7aaiL5xMm+W2y7X8TgSChh3GzIzXqyq/61j4UxeKf28oE083qJgcgbrDvPLKPrX/IEypM9aavv7rPc7iHZ8f0XbZjc2eVwJjyRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB237853
X-Stat-Signature: ez83ompsrdgx7gkk8z343hmmeyi9trfj
X-Rspamd-Queue-Id: 13F4FC0012
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788462554-418185
X-HE-Meta: U2FsdGVkX19KgV5Zln2Ll1Xya3LHy4Tkl9blx0bZ3Nnjc+xoA3HVgJrP7cob9H0C9WvlpErwJBhnoYAge6/SaTU8jeBhcsRhm8GeeoLNAWfCfDdgldsPxcDJaWo0+w9UwvqsENMNg7pMJkAJGyIA+Db9CLeZ54AOzSrP1C4ieFVuK6Xae3RsVcNqfGsK5DqHxBy3z+wCSLPtzUXxzO06S0D2Uhxr6h33/MwYR0tI+HiAXGr1+kG26dgWl9ix/pi1I2Q2EXc8FjoEvfEqqY3WgioOOjbsPxTBClC26XfBBFASEF70tvv+qNmlzWjuw8Fxovsqujna0JZAJfUaqxVtojTIIq6iAQLc8yFurDp/wnS0KfVq8P16qDGuxq/vj7US/KYL7l8p1noupf0BUZ4GZr86UpLI/3tACWEa33EqR2yLnUMoo/L9n8a2zDMqKmt9bgDYlV6+3dpDT6gHsUB2QZDx8NxEIAOQC4f+KpO48myFb/MB1OeGUqDWFiuwOw8bzsrawUyo8LWdtdcAL2sM7orE5Zx14iauomV6NjY+xyGuL5IU2AE8DGWQOprUr8NtVO+Q/VPg7zc+ifvDoqYRd+dS4ZJzf9eAJodqtMbLKLpfW4tdIFXYJusRpmcpN7fBc2gd3hyCZCLxUI/5XI6d5x2ywhwfAyj9D5VKnzYrcGDkC2MHN8NyVo2OQcv9CCsgunNNonNVCb35SqNmf/FMVxN4Z9n1ZyuS2ZfCy+dY+HaaPKGkyyNgVdwxWVmUWI/gGeJ1P+/na15t/7TY8QLnwpVCb9YhESLsiYTVAi5Z7yU79k5yGyndvu8Ysq9zMQBLyN17HHRXawMWgJTg9XO5uEy4mNCN/nexcZ/SbVu/83x6ZO0Ll9mHCADljMUkTM+6TUIEwZXYFeZKXfgKlKHPi/Yu+vea03tl4/B5Q0slufGOVciT9wnxvbeV1lSUf/AaTEn/CHcrzOy/D/H8fzv
 cXcIIefz
 0gfV73EzyOgPz8ySNukeuc3xisd4vIjA70/secGQCczexA4hy0DfBIXuTrEuX0UCymJvTIXuXk3pmi5eLXMMIuP145Nkrh4svDjD2OHT47qD/bRsRKh8ODyySUqVLJTxiBptElPGjPEaBlfgjYjGYfzxL4H8Rjs7rPLjeWJomb99Ufa86pSorFKgHr8IZbOgb9Vge6yFHDUeY+Uw/Si4vxVWtVMIs4BgAw3/YWvn5H0wBvc0sXARgvvel675NczCFBKnSUMdUUU3nlxIWF29oJpJvRZFGqFDV0VjrOX7rclTF12EmTCnGrY0OvN5kmHFMTDR8dr6+MIZrZmIjhGQMq5yL5opRQpy3BSIOIWiSP6hpTySASaIBhXnezpzKa5Xhun6EmINg2NSEfTF207Uy6fee4rFogQJFeT2zwsNal8zg+D3lPlKguAIEgMEitxNBjmSaLMYOOfGZ3g1767+djyI4JjRWq2+PozSPAK3PD9YMO8RLwhy7ruBJF1cx42HzkUOinbcz7+dngmLW8HU1rpBuHOLFF5RlAYX244SUN9Itp9+1FkJyeNCo5MCw1/lVmrhGBxRzvzRk/YoOjeZqOAsIAE2lb736aQUDeeljhh37bJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-03 13:18, Shakeel Butt wrote:
> On Tue, Sep 01, 2026 at 02:28:45PM -0400, Mathieu Desnoyers wrote:
>> Hi Andrew,
>>
>> Here is the hierarchical percpu counters for RSS accounting series
>> rebased on top of v7.3-rc1. It includes small bootup fixes which were
>> needed to fix bootup sequence on specific architectures, and a rename of
>> the test config option to include "KUNIT_".
>>
>> This aims at replacing the prior version of the series you had
>> in mm.
>>
>> As a reminder, the goal here is to provide more precise RSS counters
>> through /proc. A future step would be to also use these counters to
>> speed up the OOM killer task selection when OOM is triggered by
>> memcg. In whole-machine OOM situations, latency introduced by the
>> OOM killer task selection may not be too much of an issue, but for
>> memcg, where cgroups may routinely depend on the OOM killer, the
>> acceptable latency tradeoff is quite different.
>>
> 
> Hi Mathieu, can you please comment on the Sashiko's findings [1]?
> Worth addressing or not?
> 
> [1] https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers%40efficios.com
> 

I've looked at the report. There are 4 classes of things happening
there. FWIW I've also used Claude to counter-check the report.

Summary: no code change appears to be needed for classes 1 and 2.
I should do test and module teardown fixes, as well as overflow cleanup
for a v22.

* Class 1: the supposed "over vs under" swapped accuracy bounds. In that
case it appears to be the LLM which is confused. This is because the range
of approximation as a function of the precise sum is expressed in the
opposite direction than the range of precise sum as a function of the
approximation:

+ * The range of the approximation as a function of the precise sum is expressed as:
+ *
+ *   approx_sum >= precise_sum - approx_accuracy_range.under
+ *   approx_sum <= precise_sum + approx_accuracy_range.over
+ *
+ * Therefore, the range of the precise sum as a function of the approximation is expressed as:
+ *
+ *   precise_sum <= approx_sum + approx_accuracy_range.under
+ *   precise_sum >= approx_sum - approx_accuracy_range.over

We could possibly extend this documentation elsewhere to make sure that a
LLM with limited context don't get confused, but the code is OK there.

Sashiko wrote that the positive margin "should be over_a + under_b" and then
claimed the code passes under_a + over_b. The code passes a->over + b->under.
Exactly what Sashiko itself derived. Its reasoning agreed with the code; it
misread which argument was which.

* Class 2:

> +void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
> +{
> +    unsigned long bit_mask = counter->level0_bit_mask, orig, res;
> +
> +    res = this_cpu_add_return(*counter->level0, inc);
> +    orig = res - inc;
> +    inc = percpu_counter_tree_carry(orig, res, inc, bit_mask);
> +    if (likely(!inc))
> +        return;
> +    percpu_counter_tree_add_slowpath(counter, inc);
> +}

Sashiko:
Does this code risk an unbounded approximation error if preemption occurs
after this_cpu_add_return() but before percpu_counter_tree_add_slowpath()?
The level 0 counter reflects the addition immediately, but if the task is
preempted before propagating the carry to the tree, that carry is held back
indefinitely. Multiple preempted tasks could cause the approximate sum to
deviate from the precise sum by an amount far exceeding the topological
accuracy bounds. Could we disable preemption across this entire sequence?

My take on this:

I think we need a clearer _documentation_ statement about what the approximation
upper bounds guarantee. It guarantees upper bounds on the approximation error
_when the counters are quiescent_, never when they are actively being concurrently
updated. So if a thread is preempted _while propagating the carry_, it's not
quiescent. I don't think we need any code change there. And disabling preemption
would not "fix" anything there, it would merely make the race smaller.


* Class 3:

Test cases boilerplate, module teardown and cpu hotplug issues: Good catches,
I'll fix them.

* Class 4: Overflows

In order to be strictly C compliant, I should do the difference in unsigned
(where overflow/underflow is OK), and cast the result as signed to compare
with 0 with a inequality. It won't change things in practice, but it's a good
call.

Thoughts ?

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

