Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E42C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3380D6B008A; Wed,  5 Aug 2026 15:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1816B0092; Wed,  5 Aug 2026 15:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B676B0093; Wed,  5 Aug 2026 15:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2D2E6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:03:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7428C16057D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:03:50 +0000 (UTC)
X-FDA: 85068140220.09.694A42C
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021108.outbound.protection.outlook.com [40.107.192.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 830FF1A0004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:03:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=cGrbum3n;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.108 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785956627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KKXiXzqWxP0bgihgsN4VBYNo361XldgRdl1yH2tdfo=;
	b=zi0/+FT9KIMvVO2N7KqHgqjOmKrgAWPoF3EzC1hb8H5H1jsI/qYQvHBpXe1UnjguZizDvN
	6zwpLsHxCYgnv06TPmj+XIlWczwrGqlobbnm+ApXiBrRXsnLaZkgPQqP7eTXOR0p63IsCs
	WgWfkuB19l3DGnQg9YhixALNDKe42z8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=cGrbum3n;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.108 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785956627;
	b=xTPfD8jMKGvtpb+6cfFOpjl0pqrlfYpNEeKqdj72a48HdLMpy0qHHlySAReuv2f5moYRmW
	RGG4PYw3HwSliVWepVlxtuI34adFk+leKs5RVZ6PKz2Iy3mmvdcKUwfHEBWXF22/qAUcb/
	to5st7HLUP9nM5V+FOKowZSkc0tmico=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haMLEgPE5FRSTqpiFisx17xRIzvf0Ubl7/OQAhb+nPaJpyW4CIFlxoRezoLBGyJG0LgRMtZb4s7Uwe1l2QqnRc5EuSv5tcLbrvvO0H0Z97rfRD6auakA5VT1Rn7xvMOQOBjrlFIDhKdin678gdG9gCLDs3baGJf44mrPR+QfrZEkwiBuvQ67EV6yGxIQZUv0MTrJBaSJ8OSLBprPMr0d/xhBp6AO8ftxto+faqorF/kB7OhjwHyCMXNE6lK3ipo3CfE6JC1pirmP27lTom5wixPo6HxqE4nJpJaEZzBH/WFXAONrvsu5N3RBImyr4JYmfu13itlQSkR6g6IjE7xxsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KKXiXzqWxP0bgihgsN4VBYNo361XldgRdl1yH2tdfo=;
 b=kdQDlaJT3er2I+nCmH2aZsL2lXIpXyLwOUfiYhBh0cat1bvKa9HIejiUR3smC7yebANp9BZRIHnULB5CPfW2YjP6S+n9wxIBXBUOQwFkJ+4HMShHNezay624lOOpPRdM1boAeWp7vQrt6GE3VEQbz7wvWjWypRI+N0AjJQzv2lZ5Hm5qrxPZdSAID2MhPKrltNBA5Jj2GavHxgS5KpihqNMS5PbP5iZZOCr04tCvXGu0muu6ntKxUw7ubICIpS8MON/1Ds1RBiN4C2CVCk7ZW5sTeGT7pUaABz65f7e0H71pqqQp3oq86pZH9VccDHyxipAx7uDzXI/lVDAjDVD98w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KKXiXzqWxP0bgihgsN4VBYNo361XldgRdl1yH2tdfo=;
 b=cGrbum3np0lWjy7pONIPhleUz5L2s9qxaMvLyBQqUtvvoSw0dgzZfy27BoCvoLq3OntL2+Evac/sw/qgEVk1PLcpOTu9alIUzOAc3mDEZmyy9C5sH8NdNVSyqiHMFqfMH98r+aRiBXj7N0UQ8ymorj+erRlKIpeWFinLpkoanfh5O5EcbALwvLQjLtrps26v7z6n7YewA4Hxa28q8HwEZjqtMhigz4XLym57jyeHG+B302+mXotVnkLmAO3fW557M3MDHwFNxeTqKEuMm4CFI4N0Rn7+DXr9KL4HPLEq8ZJPCapNA4xECNbwiC+ywhjVcjc/cEe3oxSKSkdCe9YWJA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB9297.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 19:03:43 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%4]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 19:03:41 +0000
Message-ID: <0393072a-3950-461b-929e-154001ea4595@efficios.com>
Date: Wed, 5 Aug 2026 15:03:39 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 0/6] Hierarchical Percpu Counters for RSS
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
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, Josh Law <objecting@objecting.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm <linux-mm@kvack.org>
References: <20260707131544.75906-1-mathieu.desnoyers@efficios.com>
 <0d454717-be7c-47c3-bd5e-2ad304c3423e@efficios.com>
 <10ca9ff9-428f-49c0-92af-698fd5bea3a3@efficios.com>
 <20260805115738.5d74e7f41c6f02cc5fd4791e@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260805115738.5d74e7f41c6f02cc5fd4791e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0334.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::16) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e014065-4f30-4f98-bc01-08def32443cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014|23010399003|18002099003|22082099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	0E6u3+TYBCIs52tAlOjoWvC+ilEpNSKthSXuD/sECXwJviyrEcQLgpawf1wFPN3WKGygsxxUDtWlc6/Ln1Gb6mB0AVtEoAlvzchO8koRYf2FUBo8sfbpnUNUpIrKhuzhZ6AkxQl1NSrhyYhpgNVmO7UeI0hKHEswsr3FzgS4bEFC1zAfNXo8qhlO9VoA50pwLIomSriFydRYc/iajKuOsWxhZBSdvcNY9aSwSrCnnlLDemkhNEU/blUIHqA6+8Ya3FCH50TefH/tnU19NqtkYl2fo9i1/36ZORQCmmWfRHSaVxnxuNhnhM9Yj2z1KLDEKFWpwZSsSBQD3Pg4Z+oiMgVQ/pDXjPbWNWJEcDsHCIS/V7nNkD/r1LPP4U6HwHXapUPLDFS1MBuZDWkXDlUxK1TyDoJBQyGSgHllrcwwFG4MgPGr19enZu2rAIY23FBPv5mXiaQkAU6TbPZyrotTv548ZULC/zgk6/iQItbxrKjf5+CrwngrPovYvYdICfKtkAtmPc08kT3zwkdBpldo6uB/6/ROlplu3JljJZIiFSi17ZmG9Tej4XymV6cYcreuiqKBfNjIStOA2/xwKCHchPgzn12XGDWAqOaw/y+GbJg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGczZml3bXhwdW1COURQUTZyNVIrSTUrMlNOcG5CRTNYTUEvOWIwQ1hxNERC?=
 =?utf-8?B?TjhLdUdRNFVUbWVXL0JRczlYWlRBZ3lJVFJSdGptbkxmUkJhcjBOYi9vdi9H?=
 =?utf-8?B?OFloTGRPdjNXUTBUOVA2OVJGRC9ndUhvZ2o2SmhVQ05KWmprR0kxTEpVRUNa?=
 =?utf-8?B?eFpUYzdyREdaZXo2RkJFQlU3WEhQUWhSa3VVWWVTcnVXY2F3SXZUK1p5QVFo?=
 =?utf-8?B?QVJOQVAvOTNTeUd4ZkIwM01KdVA3VXVHQmxGZ2F6NXh1K2kwcXhFemhKci9Y?=
 =?utf-8?B?K1lKZ0JwS3BUaGpsNXRBUGVSM0V3NUhKSTR4TnA2TXBwVzZTUjRhT2cvbXR1?=
 =?utf-8?B?RkRLVG1BRVRNbnl3SUoya1piVG41NUxFZTE4cjhLeklHZk9EZE1USkYralhE?=
 =?utf-8?B?QXNlbmpIc1JmcFk1SmxHeldneDJkbWU1amlaYmxlREh5UHRhT3NJcDFWQ3M5?=
 =?utf-8?B?UmNTazZxTENFcEZKK0hta0dOTGZIUitRZXNLWXlGbzY1U0RYRjJOaUhvb2V3?=
 =?utf-8?B?akQxcmZlbmY2bTEyWXprQ1EwZElFOWNFKzhSeVlrOENWTWdBUlR5RWIvbXdF?=
 =?utf-8?B?TU12d0lSWUlqdjh5Y0tvT3lmY0hpUU9tQ05FdXpXQVNPSllJUVptUzg4cVRH?=
 =?utf-8?B?UjU3dGdNbk8rL0MxenRSaGZySW9lbEtwaW5MSzBqbHoyRit3Z0l4SGV4b3NT?=
 =?utf-8?B?cmtHczRISlNYSlVyRzhSTENIR2d3T1A4ekw5SlNYWXJhRlg0S1ZHRitGOFFM?=
 =?utf-8?B?WGl4eUErT25aK1V1U0Z5YXNhbURzVWg3dWEzKzFBUkRJc3AvUVBRR3RmeklP?=
 =?utf-8?B?dzhnTVhwMlJOSlB1djVRQXg1YjZGY3o1ZzNkQWQxOXpLQVBub3hNUDdsSmgx?=
 =?utf-8?B?RFhKVHYySmxaQ2ZMNEsvK0hqTW9zeVI3d1BEWGx5UkxEQkhudnlQZnFqSG43?=
 =?utf-8?B?MGZ0Vm95MjZuWkVvZkt5L2huUnRBRVpVM2IzSEk2RGJtakFpVVMvZTd1UUVR?=
 =?utf-8?B?cWtzRGhPR3BxY3NncWtNQWt4UFpLWG5Wc254ZmkzTHVqTlNxWWJvOGtSaWNq?=
 =?utf-8?B?cDZJZkpMUVBhTHhNWTd6cXN4dVIwcUpGTXBHRHEveENGbWhKTWkzVlRITlox?=
 =?utf-8?B?RSt0b0VjRGx4UWFZWDFJVlZFY2ZzN2RvdzZRbEx4dTBXdkEvd2EvREplNHJH?=
 =?utf-8?B?dmo5bGR6NVkzSHYwT29oS0FmVzhRclNaR2pJMFQ3dm5XMVNPay92OUFzWTBC?=
 =?utf-8?B?dkVrY0owcVB1eHV0cnFrb0VNM2JVSXhPZFljQ29LOWdXUVphcnJVZ1BmSVox?=
 =?utf-8?B?dHV5VjZOZDZvNjZHWDBpcVhKY1BrQmgwUVJCOGU2OHN5clhhUnVJOW5UMlIx?=
 =?utf-8?B?VE1ZSGhQUFpOVEY1M1YzTm1wODlzaUM4OEM2aDJNVmRxdXdHT294bHdLYXNh?=
 =?utf-8?B?QWlQbnRlYzRRU3Y5TnVtT1kzbENNZjJNcFdYelVkRUxlMTlXMnZORlBmc24r?=
 =?utf-8?B?YmVIL3ZDYzZsYWFwd3grcWhNdjBwb0xjbk92SWtKRkNjdWEwQmFpNjVpTW5R?=
 =?utf-8?B?dVNJbXBuL2hRQjlyMFhidjhHalVVKzlXdm85NVJEQzE0TlRzR2YwdHdycGx6?=
 =?utf-8?B?NXU2T0hTQ000ODZJeUErL0tkQ2FKNDBOK3FvNWxJWmIvWHNock5HaWtDU29E?=
 =?utf-8?B?Wk1aVWtITWlXenVlQytxeEh0Vzl4eDlYTFRCNjI3aFF0dFQxWHBSVUFPeU9R?=
 =?utf-8?B?NWhDVEZQbjhlQU5neHBodTBma2g2Y1BCZ2ZEYThOVGdVYzh6bHlJZmxNdXRv?=
 =?utf-8?B?alJhMmxMdXNneGxGSEozS25nWFpHdHh4NGVRZGdlLzNVZXYwQUFiZFlxaGRT?=
 =?utf-8?B?SU9haDgvQW55Z1dXV1dOUWdFQkJIWll3U21pa2JMVDlVYXZyZjhRbXVYVUht?=
 =?utf-8?B?bVM3TCthNkV1SjZEUnJZRXA5ZXBoZ2gxa0tIQWRSd2tzTTRrd1QzV1AyNE0w?=
 =?utf-8?B?Tk9WaXlBTnNxbHdKZzhZMEZUZlkyaUNNVkVzUDNPOXlkK0dWYUVhc1JYNXRh?=
 =?utf-8?B?UUtvQUgrZGhzbDdXRFVjZ1F1UGZybEpmMVFyZ1h3WFh0MUxrVWJKMVRaT0hU?=
 =?utf-8?B?QWdVaEVJSG5EdlIzL2RkaG5RL0hvRk5zL2xTbzBLcG5FQ01ZR2FBSjNNWWFy?=
 =?utf-8?B?QUtLZy9iS0IxcWh2OTI4REd5cUJHMWJycjVzUDYxMUw3WjVCU2xtWGpOV0hU?=
 =?utf-8?B?MmI4OEkzVGNBWUI0NDArcS9WYjZ4ZnpRRUljQklOZlFycXNSU0xuUU9NVS9G?=
 =?utf-8?B?YXlEOTFuZWNPelZURnlWMHY0L0xiQlRwVDUwa1BCNURXYzN5Y2FuUVJLQkwx?=
 =?utf-8?Q?GuT1M/g8NUD2J6WAwzEwPD2ukvkNXDVxL9jyBJmqUA5XD?=
X-MS-Exchange-AntiSpam-MessageData-1: 4fiFai80u0m2dFlc3SDYo22/CFGt4aj8BEg=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e014065-4f30-4f98-bc01-08def32443cd
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:03:41.6418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ium+nANdiimcOOY2BdfQcj8e07Z0gHJr2BuvpwGG1GnHVNqV9l7jRSmG0IwRMZiIHBs3C/IWUyT/GVoEkRfsnDTulWZ0NtjInyaljxoh3oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9297
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 830FF1A0004
X-Stat-Signature: dqtufcdihsemgnejfw5psxkgd7wu1rmp
X-Rspam-User: 
X-HE-Tag: 1785956627-660247
X-HE-Meta: U2FsdGVkX1+DxixYlLhAFidyR4/OSrUSNxA+AkFYgqUy/czW4qww7CVsrWinf0wVfGGXjTGpJ7Or5cKw3xkd0M+ikOsmS/zADTQt9rWJzBCLKdg14e+9zA8/hvV4i/ZSaYUnmMgKIoR5y95WpvKmso0y0/PeEyDji5FTu8Nqm1qdUrAK7J1Zi0bS21cXfEry8vZAo0KuxmcKezhEXCEI6VTJYCxRZAvB/xHDRSfaV+LSMRHriYyfYsED8snA+ZGd6jE5K90jEKjL8On9lKE050LoJ9M4gAni8I9I9dpR9zW9vdjiRT4f0S8twdQ+S7a3HGTcSffu3jVNvi7Ng20ckG1g3aAXc9yEXcFgE3sOd06bmN+rMYjm0HFz1F14tLGQEbbPwNHENdvserV8Y3/ZuSbT+0XnwuhtkTciT54jdjLZcNds8EY2B3PiKr/FzJeE3a1HMD44SyyLLwS1iCKLayeS4mVhGs091vr/Bi0FwAeMo0rzc0awTdjUrpgtTequIZMB0Pl5TVvCQCRCMXXn21sJhK5/s15YbklHQDpHyKryhVPoM+h7CWitsjls+c/fzk4uteqxYSI4K3RKFSNKXCi+khIGBbiLo1ytzQEfRNusPXfIGrYIipTYxK4mRGaQ2rr99jIUgdrJP44yVwej3CugutxxzI+31DXWm3MKsn1TSZG1NvxLZkIRT/tjURrYtGcjPvUQndHGcAouxZiUcv8DhCnTQOS3ZF51E9A/a4oYeURfp48kAVI8sILv/37m5uOXVpk0pyKo6ew6JkmgyMMASFSqbpr9T9g6yScn9k5kN2ybHZMEdAhewoFchx97iNdHxggXdfw+zc0BSOE8nS1IHi+LmBEyk/LoXhqYdJNToXE9a+zwn4FXJqxKNoyUlW/ySFnUe5AhAx2E7deKGwsCQji1RiL2sHcRVR2+O3IVGUv9Q6ppl88/8NYCqC+cb5+2Pe78mC55yI76FVt
 ofd3mdUN
 +kZN2z6dLCKPo0v/dDiFtoxhHGeOdA9sbsjQojquTZpCZNv0vMBd7NhBFIIC3zamRR9Z6bBUrdENpBW62uvP2bxtJVuWaCSShq+bNJtoA+hpzFdDhheGwsWnrI9d1jBE8eDpBH4+mbD+FtnRG0YlJvbgf5WqsMMDLPTrwVgxmYHmkg2Y6TbINz3GUzfOfTSe3eF4lHSWZceQMrr/Jdu0iudoAvpVlFEKnYY/qoWVJiuExlS0l0sNKHOwUwx5/5cfBdKfaduL98qWl8PyLw+mztgB97N07Nwehh8FVjL2OX9bXW07C1MxSPL8dxoJXXfrkgkG/NNnFO7Vh0i+15osQe3Zx2n6ugq7aSeympN1Pg3VFEeG3yTlrrA69Iw37mcCvyEpyZz5/lZ/FrQasxFzSYCwJ4+JKGOcv5MMApKSOqGCQF7j49IyKYml3zq2UDOTWGRiBa0+G2d3nJQ6b3DP5LBrPrT6WZZrcaXwaloZd9Ch+Iv3Dwo50MrGL5lEoUYs1yKXnHSGikYro/beP8iHFbY2zC9hJrVcLtn61y9M16y+EJlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-05 14:57, Andrew Morton wrote:
> On Wed, 5 Aug 2026 14:37:08 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> On 2026-07-23 13:53, Mathieu Desnoyers wrote:
>>> On 2026-07-07 09:15, Mathieu Desnoyers wrote:
>>>> Hi Andrew,
>>>>
>>>> Here is the hierarchical percpu counters series rebased on top of
>>>> v7.2-rc2. It includes small bootup fixes which were needed to fix
>>>> bootup sequence on specific architectures, and a rename of the
>>>> test config option to include "KUNIT_".
>>>>
>>>> This aims at replacing the prior version of the series you had
>>>> in mm.
>>>>
>>>> As a reminder, the goal here is to provide more precise RSS counters
>>>> through /proc.
>>>
>>> Hello,
>>>
>>> Just a gentle ping for feedback whenever it's convenient.
>>
>> Hi Andrew,
>>
>> Can you pick this up after the upcoming merge window ?
> 
> Resending after -rc1 would be appropriate.

Will do, thanks!

> 
>> That's of course assuming this is solving an issue which is
>> still relevant.
>>
>> If there is no interest in solving this issue anymore, kindly
>> let me know and I'll drop this series.
> 
> This was 1000-2000 patches ago so I've forgotten what the issue was!
> Please ensure that changelogging describes the issue in glorious
> detail and I'm sure it'll all come back.

Certainly. For the immediate records, the issue addressed by this series
is RSS stats inaccuracy when reading /proc files on large SMP boxes. It
gets increasingly worse for long-lifetime processes which jump around
various cores while allocating/freeing memory over their lifetime.

And once we get this in, it would be relevant to use this infrastructure
to address the tail latency of memcg oom killer, which AFAIU is now a
scan in the order of num_possible_cpus * nb processes. Although not so
bad when the OOM killer fires due to a machine memory use ballooning out
of proportions, it's rather inconvenient to cause large latencies when
it's used to apply the mem cgroup limits, which is a rather more common
routine scenario nowadays.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

