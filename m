Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D6FD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE2D6B0005; Mon, 26 Jan 2026 11:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C4E6B0089; Mon, 26 Jan 2026 11:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4092E6B008A; Mon, 26 Jan 2026 11:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFDF6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:39:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D88201607E4
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:39:46 +0000 (UTC)
X-FDA: 84374676372.23.879B34D
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021100.outbound.protection.outlook.com [40.107.192.100])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11F7540005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:39:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=FcGAZtII;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.100 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769445584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pMjcrHQTeJoxFDGvwEEyayzU0VFj8pDeMXZBqtWMubU=;
	b=2NYppI6GYsDffVlHdNFhm3NobbNV5SwrA1SwCJu/fHWxKY5FtYG4kijtsb6VIwQFrtx1sy
	Vme5VIUKA7/7Ap5sVg3I6rWs7GQWJ6AaQtWQ8WSmdposYEmA32/f2JtaGBy/PRlwzw0aSe
	L5AZSGNoTSnyNKwdegvg59dvysmu0Gc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=FcGAZtII;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.100 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769445584; a=rsa-sha256;
	cv=pass;
	b=iRPL9HQYHINhcFYJV5ofPQos9GHVWQwhwU30+UKmNmBNSj4RaKGPe7ORBYUFMDGYuD16wn
	griirlLIHMd40VgMF7DKzJDiqUSMOBbx4n6VMQLqAKe6LpdGuYNcMpwEk+Ye/mGwvBSpkP
	VWQNKSOoZZR67Akt+rnetPQuduPMf90=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/gunAo4NIb3btR2b03NlMmYrN5GQMUeMU0dJXtTtwNH1t/Q4Y0Wuj90QZ700Y8NfeLW1pOu9NKCWTnZNKzNEuJ7KXXlf+it4g0nuaRuuIRDHtAnWFOgUAN4zWFGZBszJI+OwgnTzVPCd9QIxqRu23ac4KL4qLVUc+/AgQyAky8RfHboqcbxY/fBjQAL06U5wTHkbeKfBcfwEuHOG+bStd3ZISKq9wHTczTRbCYLKCUimKuUge1HUkDxH79Y+oHT+IOKtML/s3NKnaJtJogZZG3RV//vogXTvG+lhiqSljXnMrclpKWVmPBAl3ACiL7C5klsGtC/eidMr1i4kx4iOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMjcrHQTeJoxFDGvwEEyayzU0VFj8pDeMXZBqtWMubU=;
 b=krJWu7oKjjdctEdjYHDA9w2KvB5/a1IESyH84GQZniVIgv99yY+SvTCkbA+GL6lybkGF/6qoJpM0br97Oa1qOV8xU3K2KqKTmt0u8AfJK1FEh0qmUowxjHBA0Fgdu7rxN0rxVvcJ8oXkN0XpQacuUPUHTTEmWG6dtIhcSJehQ4RHsR3kekYpbFOZNOFjurtb3u8VHdWN/IsIZNptaE8SfWI4WpKJ6VbLKKXEzS1Q/zx6G+rr80ofKLtebYFA8YtNX3ZoCKdxgzAV4zCwaL0761FepFcEOEnjPm4ievUzqFReUaYfLSQhYBVHHTdI+rVXLEqL+hlirTr3gh5i36RSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMjcrHQTeJoxFDGvwEEyayzU0VFj8pDeMXZBqtWMubU=;
 b=FcGAZtIIFaUkJ+/unjMAPoodlT8GU/PLTWdGJNvOKByDcdOtmI/BKSmQ82E8ysEnXuJBbf4sIKtU4DQzb9fS11Y+w4jR1pxqmdbGR5xCQ7If7dksNwm9pNYNyoZfUttoDWqlQkFgaRhLHuj5GKvp3bLb9L3p0VK/C9KfKGCRQeA2gTodd/2CJoNg7sRDuXJDoRAIoC54Kdl7K0OtotZYCel17czZgGNTrqs5hIioMvv2U4Z/CTKRuC+6IwtLHejdJpCPnhvicTYZKqu1ChK1aiD5yK2P/gcrWiYRumJe7Jvva0YoVxV91W67XY5qjD41dq5iuGfHcJFXKzZRXo06UA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB8391.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 16:39:40 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 16:39:40 +0000
Message-ID: <0079bc61-5655-4677-a421-1a61f4c52d59@efficios.com>
Date: Mon, 26 Jan 2026 11:39:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 3/3] mm: Reduce latency of OOM killer task selection
 with 2-pass algorithm
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
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
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
 <aWfNMKCoEp2LuA2v@tiehlicka>
 <a46b298b-baa3-4998-8715-0568b5b186e6@efficios.com>
 <aWpfbSJe5vREzzyd@tiehlicka>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aWpfbSJe5vREzzyd@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0170.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::9) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB8391:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e68001b-da6e-407e-c401-08de5cf98070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NStTdTFHclFMTlJwZ0tHSFY0dkxBZDIwcGVmT1J3dmxJRHBMWUV0cE5BSW9h?=
 =?utf-8?B?bU9jQlY0emtJN0lLVzhhOEo3aTF0dnJVSnYwYUgrWUlIV0QraHp1T3E2KzZV?=
 =?utf-8?B?ZDdsQkVJQitpbWx1WEhiMERYakQ5S3VXaVg1ZzVhVjJjTTNQaUdDZmtoR2Rx?=
 =?utf-8?B?b3k3MklXK0dsQnJyOU40NEFpMTlNVUszdkxsUWpodm1Jc1ZGYmNIbGI4QWJu?=
 =?utf-8?B?bVNqczNHS0pYRG8zSG4ySFV5NU9vSjlxUThiV0JLOGNaR2JIYkdwNkZMMjZu?=
 =?utf-8?B?LzYxL2htMmlvbVE5bUNFK3hTNGcvaHlYek9MT1hGVi95Rk95ZnJxRENtZFc1?=
 =?utf-8?B?RW9USzJBcVQxa0hodk9LL0pMekFnVzJJM2tiNlBNdTRrVStXSG5vVFplcFU0?=
 =?utf-8?B?TklRRjE1RkxKbFhITkRMREhPVmFUd0RCZUczK0N3MzNjTHNGMCtrRmFRcnlj?=
 =?utf-8?B?YnJ4SkFTdHAvLzhjblRlY1dpRUpPaFQ3SmhZSnZaOC9PSGlQby9PM2hOTVFn?=
 =?utf-8?B?ZVo5OW5Bek9oOG0zQm5sQ2trc3B5L3FCdDJxYVZKZUxQNkpUWDArcnNScGhP?=
 =?utf-8?B?NmpIaENhY2plNFpQc0JvbkNlcjAreXFubDNJZ2lBYklFb2loWkMwbzBWRWd6?=
 =?utf-8?B?RmJYUS9RcUFCTjlZMHNvdnJtK2hTZjJkZm0xUzJpMmxROG1uTXlTbldOdG43?=
 =?utf-8?B?amd1Rm1IdnRaTGtKcjFLQWhlZjdtbDNsSzZlQWJNbnVPQjN5SjA5RG1wZit2?=
 =?utf-8?B?SzZoVUkwbVRpT3U2TitMdGJUQWIzV3NuUU51YUpKU1dzZS9lM25DWmQ5NGxE?=
 =?utf-8?B?a1UrbWlWVnhJMnYwcGp1V1JUSzF5bmMxYUxqZUVuZ2MyaUd5dHpHZHhhOXQ2?=
 =?utf-8?B?bnV0bjE5Q3pqMCtHRnorcThxMGRzTkN5Q0k3RTZQYkVtdFhRb1BROXp0bG04?=
 =?utf-8?B?RTM3blBLK2tVVE9NSXNQR3pFQzJaSWJiVDRjRjlGTGRBZHFGNXdHejBVc3Qv?=
 =?utf-8?B?UDBORE8xcEs0VzViOUFXeHpBY1NSMmcxT0NOSzN0ZEVzWXUzTmRlMVRjVjVm?=
 =?utf-8?B?SmpqRzdJL0doQ09mWHJ1WS9maVpEMldwQWpVT0xFa1R6L1FhMmdIRVJHdHpJ?=
 =?utf-8?B?RmJZcmNaclR1OFBMcS9VK1RBdno2RjduZm9YRUZGdnhvMGorRlVRUnR2dWFL?=
 =?utf-8?B?RHk5NlV3YzVUcXN5dWE2dC8waFljdnhPWlFuTVRCdm13WUdHUmVPUXpISnpH?=
 =?utf-8?B?SHZEVkFKelUyZnpmeUR4Uk1OQzViNEJEYlhRa0tFUkJGOEJIMXQvYktMRGR5?=
 =?utf-8?B?Q3E4TEFsTVlzeU5DY1l5aVU1NVQxVTZ3VkJocHNVZ1Z0b0Z0L0ZiczhkaC9G?=
 =?utf-8?B?Nzd5cUtRNEt1U2x6bEROZVBoOEZUbU9JTXNObS8zbkRpd0lmb2ZnWW16NnZn?=
 =?utf-8?B?NE5tdGZ6cGJiZDUxSThvbTI3VWpiMDdCSFFzZjAxWU5kQi9KeVVwTVltOGxx?=
 =?utf-8?B?Qlg4UHZIMUlSV0Z5c21INGJhT0VxcFQxS0ZlWDc2dk9qY3ZGM3ZZMDgyR3Nq?=
 =?utf-8?B?RC9GK3RoOXhLZkZpeGJnb0w1WGRJa1ZHbFpRb0lVdXRPcXhwdjdScWw2YWk2?=
 =?utf-8?B?bVRzK0FUSUc2QUNYOGlZTDRBVDdDOStYT2psWkxtSTBCRDF5UnR6NFhvQWZq?=
 =?utf-8?B?RXNQM1piTUpVc3d6Znd1UGdsZXgvNURkdG43ZCtFOEVwZHBhTU5PbG9xaC8v?=
 =?utf-8?B?OGd4K2piNHBneEpldHY5WkVtaGVobTRPdHJvejBPeUFGQ1hwUC95ZG5TU1Bl?=
 =?utf-8?B?eWJCVGhCcDRKcjZ2c09EVkJpQ1hqUkpTcHoweWdEZzRFWGJId0Q0TW5uWmYv?=
 =?utf-8?B?WnVUZEx4Wk1pbEdicG9MTlp2cEZsWVZSMExBeFNTcmZNWDJ1aTdFZ2I4Qjg2?=
 =?utf-8?B?TVdwa1lvWnVFL0FMUFVJdE5wSFd4aG5PRUIxdEJKYnFseC9GYmZ3NnAvdTJ5?=
 =?utf-8?B?eEFXcVJrZFByOWkrR2toR0hoWEtzaUhBUmJ2bFd2dGNRYVY5K0hhODczYk42?=
 =?utf-8?Q?GnnLWS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmVJa2dJa2FxY0ZCUzVISERBOFlTRnZLdEZySDUrUElTL2NlU0lSaE1MUGR4?=
 =?utf-8?B?U09CcGNaQWxuczVLNlg0Z3dhOXBEbk5tdEdqVVNWbkZoeGNyMmU1eVF4YXhC?=
 =?utf-8?B?U1RKeVY3KzhUdXFXb0RtMXRYRXQ1dEF6S1IybEdpWU1qSlhJbU9saVMxN2Q0?=
 =?utf-8?B?dW9HdEdUKzliaFJCeW02SHZleDZ5N0o4QTVSRU1XMnBsS1VIZ1VvUkxUc1hl?=
 =?utf-8?B?QUQ0MlJmYStzNzNreUhqNGs4ZkFJV0szZEpNRFJhUjI4VGxjbHpjNmxxTGNn?=
 =?utf-8?B?L3RONUFFSU1yQUlOUVlhUXNPdmdsU1h2d3NuSjR2MmUrU2E4S1l4S3FrWFdS?=
 =?utf-8?B?eVAveDNRbFpGMXNOeDJuRTkxM1l3TVhxc0pUMkhsc2hFci9vZElxcGVOYjlD?=
 =?utf-8?B?NWZ1eTk2djc1ekwyL1d6NVZPY251eU81Z0tjVGczUVVnWXdqYUp0bm9NcUJB?=
 =?utf-8?B?WFJ2MlRVWjdaVm9DZDBnbHp2WkFHTElWM0xneWJZSHRoODZqSk41d0ZKS3Yz?=
 =?utf-8?B?YkRkb2pHZUVWQTIxNUZzUmJZTm81dERBaXZPK2ZoNnZrWXN5QkNLOFRxWGpJ?=
 =?utf-8?B?cC9sWCtHS01ZaEY3UytvK2tRRmhSa3FMRVFZQ01iQmtpOTJjTWVSYzc4TkJC?=
 =?utf-8?B?SVpiSWd3NU9hZW1ycjQ0a3phRThNSmxOTFl6VzRFOGJWWStNR3lUcjJ2VER5?=
 =?utf-8?B?cjJpSE5VLzJ0NFA3cFkvVTd6NVdsMFNuckdkY01xWmdxK2pmODY5Tmh2WVAx?=
 =?utf-8?B?bDBjNmxtOTBWWlI2RTNMeE9xdENrMXhkMjNvQWt3WFRIVVpiVlJ6ZHE3VE9L?=
 =?utf-8?B?cDdjNTVQV1N6OFJzNFlFTVVzNG5qZHN6WWJlMkFTTUlkRTVOdlFEVWpYbUpi?=
 =?utf-8?B?eERPRGUwWWUrN0VBM0ZpN0lqU215aFJ4MDQ5aE1jdUNXL0xQTlFsR09IRDdU?=
 =?utf-8?B?WkY0eVZwek5MREpVNW4rQllVbHJMNXBBUjVlWlhuOEhLL1FoZlBFeDdRQ1Iy?=
 =?utf-8?B?SE8rczI4dDlxc3N4ZitqZjFwd1hXcTgzWUpLOHZ3Zkc1ZUNjWjZEK0o3ay9n?=
 =?utf-8?B?ZHg2MVJrNVhZZDZuRFhtY21KemErKzdvYVRhL1JOM3NXK3IvTytybnRPbU5B?=
 =?utf-8?B?RVdlWU5NaVhEOE11bzlCS2NoT3E3bm1ENm80VUV2WXV6c3dRdThsRlpXU3pT?=
 =?utf-8?B?M2o2NSthbEhuWUFEeWF3Q2loQzhWMHRyZWMyS21yY3orMTcwU3V0cE41QUhw?=
 =?utf-8?B?NElvMjNPUzdweVIzY2Fyd2Z4cjZUV3prMVdQYmJtTjdhcEtwenlzb1lZNWw3?=
 =?utf-8?B?VHVrQVRzM05LaEMxM1A0ZTBvaFhpRXEzZXRPZTVHREhFTnZNZk5aZE00Zld1?=
 =?utf-8?B?UnhCTENoOWdzdHdxVS9ubSt1RnRBSEhCOTdBeW4yRkVOYTY0SEhQdk9JNmEw?=
 =?utf-8?B?aTdvSGNxRk1qRDNJM3p0MTdEcUwzeml1TkZrRFlPd0JFcW9RanF5M1ZhZXI0?=
 =?utf-8?B?VWxnUFo2SUNXdS9FS09oSUVIVm9xWWFiRmExT1ovenZsNFZteXlVZS9Ba3Ex?=
 =?utf-8?B?VGg1UnMxVnBqYlVxZkoxNWk2OXEwbHJab3ZCVjE0ZkIwSlF1ZjdRVGVMOUlF?=
 =?utf-8?B?YXdndEkvZ3YyOXZ3ZWxSUUZoaDVkQVdINFVnV3B3VHozby9zUUprd2lsMy80?=
 =?utf-8?B?b1ViMVdHRXQ3cEhoRmx2MnMzT09xZkFWM2ZXVVZSMTVKSElDOFZGWENCRWJR?=
 =?utf-8?B?akV3MFJUYzhVaXU4Smh6N2ZKTlJoY3o5NzZOMkdVSTBPSVZ3dk9Rc2RyckdI?=
 =?utf-8?B?bVlLMDRYY1pFQ1NXWVNxOEdXZzR2UUhORVJaZ1JVRlcybFZYcGRSNUtQUTJR?=
 =?utf-8?B?SEFaam5iTjgvTFRxaVl4WWVYVXM5VEVXb1JnQ1NqYXJZUCtXandpWEpzaFJW?=
 =?utf-8?B?VmlFTXhWZ0xXQkd2Y3FZOWpoNVNsTXFkREJzUEZjb2l1R2RVYUFoTVY4RHMr?=
 =?utf-8?B?dzM1czVHOVR5ZW5LeWR6SHRrVzdLQkN1bWlCN25mUlhSN1Q0VnArUFplWjFv?=
 =?utf-8?B?TnFPOXhyUDY2RnI1ZVNXVGZCdnZUNCtseWp3eUdXV09RVWdMa0kxTi9md2Ni?=
 =?utf-8?B?dFlXNzVJTnc2dXgrYkxxR2xxcnp1M0E0WmNyYWVwN3BMVTF0T0l6R1NlNHR6?=
 =?utf-8?B?QmJ2cUdOTHJHbnpsNVQxdUszMkVEaFZ1SUd2TFNZM0Y0VmNQZ1UvUkx2Qngw?=
 =?utf-8?B?a2JiZzhGQmRjemphV0k2czkyUDVYQUFKYVlKSDU5N0dsNXlPMi9FaVlvZnV5?=
 =?utf-8?B?eXYyQ0k1d3VaV0ZmR2l0UnM2ZUhwM2MxcjFKb1JJTlhuSVJ0allRN0FNdWpL?=
 =?utf-8?Q?c7mer9mO33dlN8UQ6TARCQu8pUMRNrpYrJLw8FOC4jgbE?=
X-MS-Exchange-AntiSpam-MessageData-1: QXoL+NV84rlcEDpt7CPwQssqPrQT3ir6D6g=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e68001b-da6e-407e-c401-08de5cf98070
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 16:39:40.6422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvf3Sh1pKOl+ouaPbvvqPmD7B6DXvWylQFbHlhinjYo+UkYXhoPRf5BmA+HgWgBDv3Cll+288mUtrz6HyqtwOXMOqjg3pJgplAM3GfbzbIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8391
X-Rspamd-Server: rspam12
X-Stat-Signature: ma4fjoe77kitb3hrpmqfg9anorsjotke
X-Rspamd-Queue-Id: 11F7540005
X-Rspam-User: 
X-HE-Tag: 1769445583-690187
X-HE-Meta: U2FsdGVkX1+tVr6xz4ycU1ARimZP1dCA9naJ9qzcfHLYT+rBOpIWD+GT9PyH+FeEaVAmTUSHATaiQmLMDgpo5+2Mdebv8pdIkRcgkdSV91PqKPllutxy3+aoXG1BFBVqFyPmC2sP4NKT7vIvA/UhoifyXKSl2fTK+u9GPOF5Ev17TtvdWWXcAlM3IrGb0N1lgxpDfr7BaioyxXkMZiz0BGn0o29H0JGxMUyMn11XxmrfoE5Zzo3uPJjl0c9DlRTJ0sSeati8gwMvGqrVWsnnA0ltS2TVM3JjKAHLx80vL0bypxOgPm6IO9RK83rsFCTwxk4LDYU9arTsbwHvQz17dxZh8IR8Hq/mlYHg6pmn14oPXCWTPJKzxWgJPBTviwex2OgK/Z58Xj3hszADG0V+gkJrlDq/Lg+QkEi8g+VVA/6mPPJ3ru1hHN54qjRvVnPWXrO4UPm2zsfQsABPr3AGtIaFP0i6R22gV9rAXFMbeYg3N3Pk1cx69avjDdQ/ZCb9F5ZpUQrEzY/0hPqyEEYMtEsHB2QyVUHGsQ8QBwBgmxA2/D5ysq8R7gKABw+9HGf2nMGJ7d8N1xdfh1YwvfTdzzyHQnqwiidBUkHeVaFsa0UyMLf/h5XvCueL8l2zRKzBBwolCfQ/yt4TI2JPU73wHuiWeAaD/qtf7iq1VzXspV4bxS570bF8C1u2zGTFKKY01svbh2Sdx9+aSiwVbh9CXVOi0jvFAC/uHCDmVTjUb/KpKcDJJlKgUzB52+Tc8rvqFWcw4zrzjlly21EPkxzw9J4JkaEq+P6eFKi3rHsifleWX0biE4isjkIUccaCyMex3tEK7UwmdZHfPsS4KBD+2smBWDg8kzd7KnCO5BEEvmNeu/yBUVg4/H5hsvNfyuCx6Ugm601Ls2OITkuAcb4/rp4D2t6kXZ0JdYVoP140lpY4hIqfAdsOMgQwY/NJGNbjQuzSNYPQp0PibTo4UbB
 sPIOhmh9
 liZw6dIkoxYtnNq22O890rPBl5uhIhLm6v2JNBAJVeejgkf4vTZp/s0XMDLfvBIGeg1lbPBI9WQS4vD1QWj47WK4NLrwnhZVBaZP1zLhpbj1SZIpEDSML4+vOF+YVYqTJmUPdulVDzu/ABelef40Mtb87IpQNLSyO6LquJFvDQAvVyfIqsYN58K91lRHfj6r9B5wNu02pJzH57DRnfq8C38LrWeb162kn7QnzMlWw/xwRfeXGYae+Hzkgshzcfnd+ELl3ETiGNd2tsjHj4Lul8m6Y4VgDq1Rrq4h4Qt6ihDTlz2dszY+ba0VJsscrz20pOnLDsp+bwVNfZHwM9IdxGMeL0UmTjQC/ZB+Q6Y4pK3xxZL/gEeerKQRW3shkfXyn+fkzyExXFbZ0rak4boaSM7GpcA+BmnZ2gke5Sl+q8X/CEJ+HRbBcp+BtI3w5NlQrXP9DxTWvMW/GYrP+yFLekozhFYigkfMWsuD6lz8QKZhK/W91E1KouHueIpEv4s5UGADTmKGiTmMV9ibwi2bBSu+CJwuV7ZnqCrrvIFqWmmN4xYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-16 16:55, Michal Hocko wrote:
> On Wed 14-01-26 14:36:44, Mathieu Desnoyers wrote:
>> On 2026-01-14 12:06, Michal Hocko wrote:
>>> On Wed 14-01-26 09:59:15, Mathieu Desnoyers wrote:
> [...]
> Thanks to those clarifications
>   
>>> My overall impression is that the implementation is really involved and
>>> at this moment I do not really see a big benefit of all the complexity.
>>
>> Note that we can get the proc ABI RSS accuracy improvements with the
>> previous 2 patches without this 2-pass algo. Do you see more value in
>> the RSS accuracy improvements than in the oom killer latency reduction ?
> 
> Yes, TBH I do not see oom latency as a big problem. As already mention
> this is a slow path and we are not talking about a huge latency anyway.
> proc numbers are much more sensitive to latency as they are regularly
> read by user space tools and accuracy for those matters as well (being
> off by 100s MB or GBs is simply making those numbers completely bogus).

It makes sense.

>   
>>> It would help to explicitly mention what is the the overall imprecision
>>> of the oom victim selection with the new data structure (maybe this is
>>> good enough[*]). What if we go with exact precision with the new data
>>> structure comparing to the original pcp counters.
>>
>> Do you mean comparing using approximate sums with the new data
>> structure (which has a bounded accuracy of O(nr_cpus*log(nr_cpus)))
>> compared to the old data structure which had an inaccuracy of
>> O(nr_cpus^2) ? So if the inaccuracy provided by the new data structure
>> is good enough for OOM task selection, we could go from precise sum
>> back to an approximation and just use that with the new data
>> structure.
> 
> Exactly!
OK, so based on your feedback, I plan to remove this 2-pass algo
from the series, and simply keep using the precise sum for the OOM
killer. If people complain about its latency, then we can eventually
use the approximation provided by the hierarchical counters. But let's
wait until someone asks for it rather than add this complexity when
there is no need.

The hierarchical counters are still useful as they increase the
accuracy of approximations exported through /proc.

How does that sound ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

