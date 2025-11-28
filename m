Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D193D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 20:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C593C6B0062; Fri, 28 Nov 2025 15:12:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31376B0095; Fri, 28 Nov 2025 15:12:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F226B00A6; Fri, 28 Nov 2025 15:12:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5CE6B0062
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:12:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FF47131E4B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:12:35 +0000 (UTC)
X-FDA: 84161113470.07.A0B7765
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020142.outbound.protection.outlook.com [52.101.191.142])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C94D1C0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:12:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=KKfMu5nC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.142 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764360752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJs9M2s4Yy2XxXzRrdpByBfjQmTNqNnFBOYQDqB+hyc=;
	b=t7Y8hRu0vN9eeZbapuDj56MxdsM6mEj3pNN49CxX3RJiPdCKxVYbcEJ3LaG/OuWxvgd5W9
	jx/9/+EKA6zXo8iTWwps2L03S74CruI4hbm8VkILXs4PFheE11fPmFaHE+hEUvuTRpp+ts
	4/Uhonv6sFn9dWVm5KzNIcuURQdGH8E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764360752; a=rsa-sha256;
	cv=pass;
	b=V2el9fFrrrKqkHgLE0tZt9qVw8r+YStkxvOgT5QDyzpYgl/k50NOxUP0zoyMM3YzhPYIRo
	eo2XWdNrF1QiVi2QmPZxN0K665ULkvlDdyzY2HQns4RM5Q1adtldix73SHg5RVOBciTlHH
	5MobvugPAbFTejSil57WnVmdopHjZwo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=KKfMu5nC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.142 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JgMEd90gnL+F/9+NB1ue2mOvhADYvby/KRoitAi9DpVpMbkZfLJ1cWnCPKI/JWMA70V9e1+/dRJ8Ia2vhpcwR8pK4W2sxElhadFdvXPMQEc7ctwET7W957jBB8czsUhWyAQahJA0/s6DM+vaLhF+2fZZpIO0AnR1na4+xJubijM5Q+onfjD7tWoH6DUSSM0znAjMJ5Dj+EfGAH/N4djnb2e0UJEUM77kGdroYwQtc9vZsN02KcmrtJlI2VmQ6Q84ISSVWm7NDkbHauQvah8P4rj7NS+aEW1+QYMeTMe8YHeJl4GTHNB49LH9vOD+/GBm071A9eQrNKqx5wUd2ZS6cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJs9M2s4Yy2XxXzRrdpByBfjQmTNqNnFBOYQDqB+hyc=;
 b=qoNV3i2mAxIWxgM6+gNPFbAkT/pC6qU/SOUgoKm6J8tzHQlLegMk4dpx9sP8eDuhcDD+PqpIf0C7mGxU5ci8KEQxkHN1XeLkx/iz8gmHMbIBRRn1YfQ+nORexFI4SR7tEKY3H51smHelej6vO3fFLuaJ1M8QPMkgVmWMQzRr2esvzctOFPGJN610k46ZqxLUW/Ho6KE9UY7dX+RSUMO2lH3U5Yec6JC7IK7O9G3autB3IOiCQCas2BiPmN8o1kAucqbGzdcafjbtD7IvXjkmFJ1OGXaYHSndrOeAsXroDBFK5kotqBM1hETRYeJxESidBEaDQOXW8kJH10D8N6I0rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJs9M2s4Yy2XxXzRrdpByBfjQmTNqNnFBOYQDqB+hyc=;
 b=KKfMu5nCo48AZjP2+o4X7vEaM0HZb9sHa/M2aQD9gF6T7b5vwpSDAKNlQsJCFDE37K7fKgvm80gtibzoIOuAgpbMrF/sdnR+Epe0vJaJr9656pbyXz0pCo0weqTpGXXVngwnJMvp+ZNjPvdDvO3g/QXRRM4sKEIrI6QVJgJJrEHUtgbBW/akq5agAwFHJr+F8yr1FVU4qH5+V0/gQ3bBXCj8xOEVyW6cjGBlATp5jc5mSYERtqMe2pnRhgNivzX7+cnl9Q5Lfent9XQbMbRT71unU3iuYGmAXJu3EJriGyVttUTpBQaCu5S9rSJKulPetwbBNBUjjvRktRQyeRlJoA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB6227.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:65::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.16; Fri, 28 Nov
 2025 20:12:28 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 20:12:28 +0000
Message-ID: <bcc7140f-5efb-481c-b1e9-564a2d88ed81@efficios.com>
Date: Fri, 28 Nov 2025 15:12:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
To: Jan Kara <jack@suse.cz>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0082.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::18) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c7863f-d57e-4108-24c7-08de2eba7443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWhGSmFwQS9ZeldQWVNQNHFGOVh6d3luVFNsNVdGc2tkckwxSkZKMGljVXhs?=
 =?utf-8?B?UmhKVDVGdUp4cDFuT3h3TXErM1lHUExCcXlTQ3pwcHozSkJXakptWmVHU1kv?=
 =?utf-8?B?a1RrTDk2Sis2N2VQT05YMzNJYWhNV3BTQTFhMG1MV0VtbTNnVWpSeHZ3S2lx?=
 =?utf-8?B?NEY5TURuRUJnVGpTNHdjOE05K1czU3UvWmxIdnFXL0piVWhoWkZ5MGpTc1JO?=
 =?utf-8?B?RC9tZWlxakhKOHZPdGx2WVp3dDlGTXhQaHVveFhUbjJubDRGSCttT2lWSTkv?=
 =?utf-8?B?YktzYXBsMkkzUVdCQ2ljaTU1YjBuVWNicWRGMnRKdWhBVUtaWXE5WGpuRHhs?=
 =?utf-8?B?TVRRbnF5Y3dqWVlMMEYrWVlSTC9acXoyQ1orQVBwU2xQMTFNZ1I1UXVkL1Qw?=
 =?utf-8?B?ek9QdGpQdzErdGZ5WGNxdU01MERGSTFHL2FHSnlITkFoUjh0Yi9EUXRsSFVq?=
 =?utf-8?B?bzh5YklxOExhNkZDWmlZZmlIMXVHRm5keFBvbXhYWm9Bd3p6b3BWM0VlNVk1?=
 =?utf-8?B?YUM2c094aUczYnh0dEl2MHpQRDFxRnZnTEFGVkJzTmJlYUNXYlBjcVMvMW9s?=
 =?utf-8?B?ZE1VaFIvMnZCTHFMZnU1UCt4ZlVzK2ZZTWgwMVBkMzEyakdmRHlFRm5yRW81?=
 =?utf-8?B?a1ZZN0NTdXF3eWVxQjhNczBzYlNuOWQ2MXFiRk9xSTJEdWd4amFLYnR4UDV6?=
 =?utf-8?B?cXFqaExPOERSeloyUXNZU0M5aUxBUGV3WDBOOHh0Sms2U01HUW1jTVB6cTFa?=
 =?utf-8?B?VCt3clRNWU4vTHRsNTdnbEJ5YUpQSnBwZTJwcVZWc0lGekVnT2MyVCtYM1hi?=
 =?utf-8?B?MmwrTWp4OUxEa2NhdnorYU9VanF4Z3dOaTllN1ZSelR5RTJyVTJvZVFaSFZP?=
 =?utf-8?B?QVRYMStuY3A0a2JPbHpPR2RoQlhNaG4rZ3VTR25JckozV1dFVndqYXA3ZlhF?=
 =?utf-8?B?Q29QcTZldkQxNmtkNFhmaE1Qc05CS3gwckMxckZtUmlVbVdEdXY0a1NCYXN6?=
 =?utf-8?B?VVkvQVZESFdCN2ErRTFHaHYzZGkyNVNVK0c5UG83RStMNlJRSDNYOWpma1Fi?=
 =?utf-8?B?ZzJJSDdTS1RGNnZSYW04VVFjWGZoZTZlbFl6UEZxSVkzWlAzdXhUaFBuYlE1?=
 =?utf-8?B?S214MkZ3cTNlbGdKcG5OQTRXc0VTelhOb2N6QkR4Z25oK2xhcXZOeUxVTUlG?=
 =?utf-8?B?V0V4ZmZEbHdZR0hLYWJVVEhnamtraGIyQ2lGTUNoZEhWTW1JWkJsZ1lUS0FQ?=
 =?utf-8?B?b0ttWllXdEhsampyc3FDNkR2Ty9WcXVqbjdkdmxoZ0xKTDlTZUlzQmdFSDJR?=
 =?utf-8?B?UjcvN2t2bGZFM091WHVhUGg2NnpOb0dUMVY2OXFYRXIwdnQwNUpSaGFUNDhX?=
 =?utf-8?B?QXVOemZUMmNKOUVtSGpmMjR1UzN3L3JwNFRYenN4Q2NKdXptdVZuYUJQWEY1?=
 =?utf-8?B?UUl2cHljbFJKZms1UkxUZU1XVzUxRjQ1REcrTitDd1F3UUEyNldmbWlzQlZN?=
 =?utf-8?B?Uk9hNGhPc2dtNkNWSjhTbE5uelZoNlg2MVBhbnc4WVRwZ0RjdHZIZGFOTWx6?=
 =?utf-8?B?TmFpTElpLzJTOS9WdlF1L3pxZGpFVitXYTdNWmFScDNKazRhRXU4QTVac2ZL?=
 =?utf-8?B?NVA5TG1Qc1Jvc20vSUJmamtoVkJSQXMwczljMHVXeTR2UDZ0SU9xdjAvbEF4?=
 =?utf-8?B?SlhVM01TcCtjd090eHlYeWRVR1h2RFkwbVZ3Y1BON1hFaDhVV0pFcDBDK21T?=
 =?utf-8?B?SGtWS1d5YTJDMnBIZkt6YVI3U0NLcXVrdCtNT1ZlZVpwTE51STl3bnJHWjRz?=
 =?utf-8?B?NUFJS1YwUDlDYlBtTWl2QmhiSHRVbS9KL2FRa1ZSakRGQ25GKzN2emZ1dGFQ?=
 =?utf-8?B?eWxtRHQ0L2xqOHZ3a3FEc1ZIZlBad2lNRVdMbkxGRmhYdlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmY0YXYrUytBWG1oRGNMajJTS1BDaEo3OTB5RjNBMWNiamZ6RE53WnNMajBE?=
 =?utf-8?B?Z3B5bVYvcVNYWWNMODV6cE15dTR3eEp5VzBIM09LTyt4LzBpeElQQy9JQlhZ?=
 =?utf-8?B?MmRYdlVmdUN1QlpwU1BHRk50SFk0VjlmdGpZbUFRbnlGNllHdWw0aFVRUFc0?=
 =?utf-8?B?T0RqVld2K0hGOE5Qd0dobW9kZ3dRYVNKaGViZktPTEhaY1NXdUZOZUwvbGRC?=
 =?utf-8?B?azlyVTI2dFk4aXpBcGlPWkV0M0h4QmlmU29mTHhzemdZY0JKZWZCeC81NFh3?=
 =?utf-8?B?N3g2UnpXVitXNFZ0Ym1YdzU2Qkt3MHhqaVNITjBtZWRVNjJSQ1dWdkIwRDIx?=
 =?utf-8?B?N3ZsUDlpekU2TFdQSEZtc1grZzNIUmVxNnpMUERxdTJNL29kRkVTR2J6aWIr?=
 =?utf-8?B?Q0dxSXgrSGtSK1RpQitab1FwVlJXTGFtWlJ4ZkhGNldCNjJvNUtUUFJpWEN1?=
 =?utf-8?B?QWwyWVJWcUE0WGFZUGRSWGoza0Q2cHpLVFR2cVJDeERYNmZVNjJtL2NmOVlO?=
 =?utf-8?B?TFlCVEdtVzFOWUN6NUk1a0hta0oveTdEbVpscktmYWhYeGtCeGF4NVZJOHZN?=
 =?utf-8?B?UlVvb2FzK0U0ZFcrbkRZcXgzdk5WT290WllKWFl2NUFzNG1RK3YrVWFTNWY4?=
 =?utf-8?B?UkRiV2tIcGJXNjRaNlFVa1R3eFdPMDRQV2dQcy9vLzBsRWF4a1hZTXhFRVFB?=
 =?utf-8?B?UVRoY0c2YjEwOUJVWEN4ZWxaTWpCZWRBeGpJdTg4ZU9QTmMwSDFJdHE2bS9s?=
 =?utf-8?B?NXRHanE5RStaZFd0K0dPWFdZZzVBU21MbUxuVUx6UjI3R2lhTVhyRmlFdXho?=
 =?utf-8?B?Ym5DNTRvWFI3WnQ1YUJqbzc5VGRVWXo5ZjdacnNCV3JacjVXZVlDN1pjRVZ0?=
 =?utf-8?B?azk5N1dFOVQwNzRrS3ZsUUM0eEx0UEpMVFpxay9kdVZmMGxOL1FVWkhML3ZZ?=
 =?utf-8?B?RW9laVlDRDNSS2ZlcXo0YldTSFBEcHd2eVcwSEVRcVJJVkhQcEY1NWxNVE5i?=
 =?utf-8?B?UHkrZkpVUDQxUlhtbk5BbzhNcDQvaDdhZEgzWncvYVpKWEFGV2tRUXJSZWIx?=
 =?utf-8?B?Rlczbm4ySCtjVmV4QmduMWFBckgxWE1ianR0Qm52a1h0VE9udCtIdHBiSjQ0?=
 =?utf-8?B?eUxIZlBHV2VCTHhyaVJyc1hMeW1WSnl3Q0Rmc2YrTEg3YkRpcTlWOFNqQUxF?=
 =?utf-8?B?S3NwN2o2UU5PMGF3cmEyMTk2T084M1ZDN0lFdk1wejdEN1k1ZnJlTTNlYTB4?=
 =?utf-8?B?elMwK1EzT0NLY3preC9SRUNmK2ZMMmdHZHJ0cmlCV0F3WEt4MlJ3cEJQYkpV?=
 =?utf-8?B?Q2dLT2dnd084U04xWGprOUhBQkRYRDdMN2dYT1krTU5MK1BsVVhFSWhXSVFr?=
 =?utf-8?B?Ym5sMlU0UHRNWlNINzV1MDFXYllqU09nTVNSVndGR3psTitvbG9GSy84TGJm?=
 =?utf-8?B?bm0vblVpQmNmTmE5aVdLbTVYYnEvaEZ5WHlFZzBYZkpHajc5NFV2aWd6cnd3?=
 =?utf-8?B?UFV1aTQxbC83N1FSbmNMeTEvbmhYa0dxRnNHNVcrRUpYeEx5NE42VXl2c3I0?=
 =?utf-8?B?YmFRRTJKWEpIWm9NamFNRFpzSG00cEtPQ2YzVGl5VHA2Lzl4ZHNvUWkwdVpK?=
 =?utf-8?B?WGZMMHM5Wm80VHhSNlpXNjRYaHlOcUVxQXA2U2c5L0UwVCtiUGwxN3FjTURJ?=
 =?utf-8?B?U0FUdEFYRWN5RVNGV0hBbm5ic3VtR2t5L3Bza1FNQzVJRytuV0pBQkdQUytl?=
 =?utf-8?B?YjA1N2NQUDFQdWx4dmdiU21MSTRqRUpkR25RcDVYbU14Q2ZHODNhbkJJQmE3?=
 =?utf-8?B?ZW8zWjllM0hsckdGK1JiZW0xcERnbDNGV2E2dzk4Ylh5UUJTOHRkbmw1MEhK?=
 =?utf-8?B?cXprMEt4b052bWVCVTJmMVRSZndtNi9vTCtKMzFsYVZzVWJJRGc1WmQ4ZkFJ?=
 =?utf-8?B?NjZBYXl6TTBBaitSRDRWYysxa3BTdWxvV09sc0lOSzhkWVNyZm9iTkZnd2Fa?=
 =?utf-8?B?TGVCNTRlL29pK1p6UDFCcVFNNmJFZEdXZkdtZGlvZHNxQk1VRVZia3hCRjM1?=
 =?utf-8?B?bzNqUVFtTnBEUWFtMXRlRzJyOStwZG9BTDI0YUFRdjF3ZDZxNEc4bjJHdTVM?=
 =?utf-8?B?YzdCVEVIUnR1TVBqMnlJUERxR0s5azcyZG1KdnlJQXorbWcycnNHNE1lUkM4?=
 =?utf-8?Q?awZKke9YvStp2bT+RKaD05M=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c7863f-d57e-4108-24c7-08de2eba7443
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 20:12:28.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNnUKcdVABC4Fq6q4cTNj5+XTmrKkNhNFgWnC2p1MnqQFD4dII/XcAPuHY89bPJBAAtYweo1XLvKejFgoAkjbePToFAhV2j4XMNTwtcxSrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6227
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C94D1C0010
X-Stat-Signature: 5ngjj487bwund1wyfodiq7wru88n4rey
X-Rspam-User: 
X-HE-Tag: 1764360752-406671
X-HE-Meta: U2FsdGVkX187wRgLFcaKIy/KIYH6eFCjj/o4dSN0n94XTL/11JSbWSXYZubozOpOvNmUzf6lKIYAZfVjhofGf+0TvKoz510+/pGyu3ceZzoDNEbTOoKoixUMuKrlPSDGpjWk2NMpjqgUiVJtPobLMbPb0RBkFjSxTVNZjb+usWsq8LxKI4sSVo06LDpX/AIB39pIBT1o0+9k/6Sf1GU0Tku8pXoOz9dN7VAD9yUToTwNphZBVKg+rlAt8d3wR3Oz1ML3jyMmEgsFu2eoN+I+HjUAf60bFwY8ZC5McuLc0/k8nLf2MER3I/uDcPj6a1ywrq/K5dsctb4KcXQAirGOyR0ehUoDl5fjRxAgmVfBItDNO+z7Nxm/mlUqiRitxq210T43YRMC0R5Yah24EOSGELdHBg6ORBdsogGp+zYUCZF7djSbdUPuv0Wz487HpFE4uMCOtftIqeaZIqz9rHPApfxzujm2VfXtGyhBUY4y3o0tFzHNA1mlPpzTQkN8aVmh8OpqzoPpXahodvCCbKPEMc020j7Uypm2Mf1/ZOpjcnkPNPVXGzXkXObwaApAiKxW6h0MNiALnk+7n5Nw0MtvMTcF4exqjI0m6S29HItdOrfNNG7pa3c7pTfQlfLaOEkQLwh6cfQPsNj9S2xK10TJF16Ajmtur05eUielg+xvtVUqW3jCutz2IOrl98hY6nyTYUB+cZa+4kRJ2btfda62Np0ClT8+g5IrWxfXvax7t9Pxj4ErvVBgGkimc/umhMM3n05z+FVUZQlz1sxfAY4P1hHnTxzSRD3iyC3e+1LGBUCe4rLskW4deNYaxLFaXdz5aKaaqYxAjLjmz5IcbVbFy8maDZl3CwXdrZ8+ef6hN2YEaBSwjfCs4ICOkBaq5MbTSMKDU0v50DRM76WvRh+RUPt875dn01lcv7KT6qlQxcKRA1bNLLrLsqYmihzv0h0Yw/KzndIO2lOi4iyDw4J
 0b5xF6y/
 EYjkJG0cmvLc3TQB/8LkpEuGhHCQmf+ab4fzNDrBaXDabm3Dgq/MUEN9SpLi69/88pExGnQnadSfx2YZjUXPrK/fjmUpXW0wqV8sB5vDuL9v4DiogHGfvusVYy/WOR8rypAqnw31VvcaZmrrH49f0a/KFmG4DQOtcw2W5MZxfdX6FKskhvSpSSxY44Ct+jBmlmBsVG0RQatLiFJYlY3r6h9+vCn+DpiPGe9xAxf/aGTVta6iDY1qjZ3DB367GoiwpqAftZCccCo0C4PCSUSkxWkfuoW+J6V56Z+3Idczf8nSTd1zXBHvaEZmL83pv/QpRailB9LElEyc8Es5UmKMjkiTfx8m8Gh6+zyZyxs035r2Y4CeK7o6cyTZQGpIBWZN5ZEdt+8/2J3L2a2yoy9ovKVQENcGRtpQe1Q1NQesQ7XnEWIhmfxrnPaKOOnE5koBhAoOMi7sIhjfHWYQ5cLS25v0A5G8r3lbxB2mzPgVBrMuZ9kd1vcvIziDvg7kUhHgToXQwz+mh8TcRepOTVdmujQTM1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 15:10, Jan Kara wrote:
> On Fri 28-11-25 08:30:08, Mathieu Desnoyers wrote:
[...]
>> I suspect that by doing just that we'd get most of the
>> performance benefits provided by the single-threaded special-case
>> proposed here.
> 
> I don't think so. Because in the profiles I have been doing for these
> loads the biggest cost wasn't actually the per-cpu allocation itself but
> the cost of zeroing the allocated counter for many CPUs (and then the
> counter summarization on exit) and you're not going to get rid of that with
> just reshuffling per-cpu fields and adding slab allocator in front.

That's a good point ! So skipping the zeroing of per-cpu fields would
indeed justify special-casing the single-threaded case.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

