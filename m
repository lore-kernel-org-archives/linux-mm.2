Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CECBC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 18:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0AE16B007B; Wed,  5 Aug 2026 14:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC146B0088; Wed,  5 Aug 2026 14:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D852E6B008A; Wed,  5 Aug 2026 14:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A91906B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:37:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3621680580
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:37:19 +0000 (UTC)
X-FDA: 85068073398.22.792B584
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021121.outbound.protection.outlook.com [40.107.192.121])
	by imf05.hostedemail.com (Postfix) with ESMTP id 376B3100009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:37:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=QHQWxnip;
	spf=pass (imf05.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.121 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785955036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ze65JV3IeWwp9L8f3ElzfRyCd9fP0rbEWMnwWBJ1xkM=;
	b=7nlBTYjN2urLqB5vCaX7jWhFhST5NcwENgrnooNqXNqQ1R9EMDu2juXExV1GeiplRwHR+X
	6nlcNHpLH/QvflBX448UjVeMcT9LyQUpZ/EwUeVUnIK41m7+9neWlrreqMPg9cSqj7OZAp
	+gayPLwWaxoSk1r0/ZNd5pwWSpmIt24=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785955036;
	b=BMGHf/o6c+rCi4Au7aJqRjrnLIJsdJzAL/Uvl/ep9acqFWCk8H/YVLiWjfjYBlbZ0nGylt
	1aCykr7Uw42DRhPj0kVcIzTSe7Ntc7kN7JLdd/vCOyJHwrhKnss4grdZjciWc9tOHUN2cE
	utruG4ztu3ZjCoEqoRnhd3Q2KVwaltg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=QHQWxnip;
	spf=pass (imf05.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.121 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BaX7ix8bEnFFUMJU3vM6XAGwHzE+KTdazovQm3q67TC0eId/xywH3+fP9xkqM/QweRIWKtvB0p94LHz5gTLqOSF0COyGxYZ/6S7n4N5R6BRbUXMf01sORxs+XEEIAb2Myb9GWsK5uSZFhdrW9NadVmb3glfKncFk0/PToR9egyToOI6min5DSMHWFxpOZvbsTKi9pheNMq9U9Ie0g/+vZp6TLZ0aVZv+nzqvgz6zIpNYupwNgZfBTdcv1GzpWAOMWV4kHDodQ1bhbFfuw5pXys2eKZIL5noGy+Y03GsquKPr5EkZ8nu+v/MoqDk7mu+/FyVUeWPjM9Zy8j6aEHA+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ze65JV3IeWwp9L8f3ElzfRyCd9fP0rbEWMnwWBJ1xkM=;
 b=oTafproNWpmt6LqybU8MjFWjymsbyfnURly7A5L3m+yw17Fq12M09k4rk/IAThJF7dnQZ1yLVGRrreM//IxqLRid4RdzdPdTM3tcMcSkQwdgb0rsjUlLnvnMn+SVncnOI+85tjyi305bE4832q+zFzQSXVVxVzF+gmOBszhOPSXhk8QVXtEsbVm0KOV3eti54O2KdN9p+qlcOJeqgVSpBFVrD6bhEsj93im82D4qpaTuBT39iGXnSPZpO44S4i+W3QHkf7xTwhMIp6W4qVPuPhp05fDiKl/LBs77j2EIeYlR3OQqzRJZSTbnpzqU7r23/sffGtz7bllz8mOVaO2dxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ze65JV3IeWwp9L8f3ElzfRyCd9fP0rbEWMnwWBJ1xkM=;
 b=QHQWxnipJ1hQVSTrAOVT5+vOQ/KwBjLdmlca+xirMKVKtTOVaIwa37C4x6+6eOiyIGoiwCq84Nxro6vy0CxYaJOXSeqTxVUXzHeDfI9X6qhGmk4vJCN73B2yMnEvHEs2roZ3/ZyBrw1YBz1QzUg8CJ6iCYaygz8/BIOjm0yTGVkvBUD714eI0MPrktA84FxjzwASN3ccqND3u7lB4TISSYnLgF0fRfFE/0byUKc5N0g+ewab//GpfbeUASgrr4LnnyvkxfWQc9RihdsGUCx2bF3RX79mm77MJdSQgDLOWy9s2if0fnSMw5ELfAgHg9/FnauSnfInht95Y3z2DD66RA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB5221.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 18:37:11 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%4]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 18:37:11 +0000
Message-ID: <10ca9ff9-428f-49c0-92af-698fd5bea3a3@efficios.com>
Date: Wed, 5 Aug 2026 14:37:08 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 0/6] Hierarchical Percpu Counters for RSS
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Content-Language: en-US
In-Reply-To: <0d454717-be7c-47c3-bd5e-2ad304c3423e@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0264.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::25) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB5221:EE_
X-MS-Office365-Filtering-Correlation-Id: 677a15bc-b747-48ca-3968-08def3208f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014|23010399003|10067099003|4143699003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YkhHcliz/pm9k/uJ5ZjX7VN09e34uV0M+CsaEtE/eUikc5ZdvQl99rmvfYPaLXbq+osoq0FquE5FlE1MMI2PWZQhaVI507LvKbb74Nv6aFk3MxhJm34qNAQFnOCC1s2+tVswO1dHxBpjcWOiM9lqAm9pRNeNgyDxRt0Te3oXyoApH4yEdQvDxm2j23UVPzwF/lGC28cHG65UAmOMR1de0yXBfXAWGf3BkwJy6E7FHd3YS0bEbtsCZedkEt27uwtuph4pGqcZL6u1GaPc9G0jHEGNdklOAYQwqS1xOYlUe2w6zWfCeG7ssexj2uI0jJDktKH3rbT06V++jFNZb5YDAVFecXGpd+X+rtq3WnQvdnDnlfhFamyqPrZBdrJWx9Kqwc3VriivYdr0GfCF/soVQF+vh3brisT6pzWJ3SwHpcx3IK1wi3541p/TfjyceeeUjLMvd6Ljk2K4wzE5FCbY/7iW7oCffk5Rsa1QdnbgQl5gZ51eHDW9I9U3DZmGlsGNm6bYELZfEyEAX3V6+3Rd8MUdbC/Ld/53rHpomytvS5u3ZLwnOMSU0je69t8rDj7ekb8D4FDjWyEwSrrVXtU7LhBK1qb+1+t6eoAfNdLbjFQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014)(23010399003)(10067099003)(4143699003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1BWTFdHdHV6a1AwaGgwZkREVk5oT0pQamNHVE5BbzB0dUdqNkdUSGhBem1O?=
 =?utf-8?B?a0RQZHdFZjFKc3B3dFlaT2E5SWVMZzV2VDU4RUQrbUhmUFB5OWlicEpSUGhp?=
 =?utf-8?B?L2lwRUdvVkMrSEsyTy9DZEgrNThSNnJYRHhvNjJ3K3hURVpWd2dkQjVEQnFT?=
 =?utf-8?B?VXFWNHk4UVl2L3NGd3RzajlPNlZITnBCdmx3ZjFQbFo2bXo1QzJYMzE1bHNi?=
 =?utf-8?B?Y3RTYmxnTXhPTnVOWkx4OTR4bG1jQjdyZUxLaDJJV3lkOGwreit0Rkt5d3Bo?=
 =?utf-8?B?dUlkdzFNbWRRL1pDUEdodEVQK2tzVlZScExrOFkva0RKRWpyU09mMHZHaERC?=
 =?utf-8?B?ZFlucnNkMkcxNkh2RGlhR0Z1bGRDSjAxQUdWdTNSUmF0MlZtZWZZdjIyaFdI?=
 =?utf-8?B?eFZZV2NrS2w2eUl0RWNCWmp4RTZmRWl4cHFtNFZDdmo5eTk3emVlbjA2Lytt?=
 =?utf-8?B?K1dpbDZIc245aVdWbmFHZE55UWJqOU1DUlJSc1NUUUNyZHJrNlN0VFpPNnlw?=
 =?utf-8?B?ZVBZNVVROVVybjV3Y1ZiWWlYa240SkNneXYzUFJhZHFpRkw0bzRJWXhrQWVH?=
 =?utf-8?B?Q1NhQjc2NGFlakQwb3R6eDZUUVd6dGhIbzVkQitxSkF4SzdUY2p4WUpoR2xo?=
 =?utf-8?B?NXBsVVlYS256QlQ2NWVISUN0QVEwaHlLM21uSXB3RW1MOFk1VVJZVzIyU1NF?=
 =?utf-8?B?bHRnUURMd0R3K2lnblE0Q1kySkJBaHpySXBnWlg4MW5ReFBPaHVQK2NNeEFj?=
 =?utf-8?B?UkdSNm1FdzVFaXFSeW11b2FsNnBVT1hmRlJ3UWJpTS8vNUpZamN0V1M5dDdk?=
 =?utf-8?B?bENtdllHM2hxQnpOVmVKRFpwOHJUTDl4VTVESFFsRURKM0FTSHJqZFJxejI5?=
 =?utf-8?B?bWNtengvcG40Sk1sZTBVSHdQNnlOZG9ITncrK0RkQ3h0Mm91ajNKOW4zMXpm?=
 =?utf-8?B?YUNjOW5jTjJYbm84TXlpQmxkdm05OGU5dmUrYi9uY281bkZ6cFM5SnI2WlVp?=
 =?utf-8?B?QjZCbnBDV0tHUUptQ21rSjlGL1ZNb2g3WlZkTi9raU5TVzJleitPOEFMd2E2?=
 =?utf-8?B?aEh4SkN6NS83d2h4K0I4bURCdGRmdXZ3NFkwYWJhTFQ4dGt6R0hGUE8wcWxP?=
 =?utf-8?B?Z2FpQWtCcTcrMXRRUWZKZWZCWDZ2azFmQjhKOWpwR1hITlY3UG5SSlRXSy82?=
 =?utf-8?B?RU5CVmd3ZEpIWGV1S3d2ZStQbkdMd3ViU0pxbERwN0I3VDdyTUtpa1B4ckI2?=
 =?utf-8?B?NzhyZXFmRFo2NVZ3NFFPZmVieGJKeEFMK21JYktXY3h2K1Z6NDArVVZseDJv?=
 =?utf-8?B?QXAxaktBWGMvZW9Zekd3czJJRFQ3Y0VXN01tTVFXbzB4VE91NDAxZk9qL0ZK?=
 =?utf-8?B?VU1hNFNrckJGbHZHdk4yTTdvdlBVclE0Y0RjT21nMjdCMlQ4MmVMWFRXK1dq?=
 =?utf-8?B?MkVKSmFIb21MNTZNUXA3RVhST3lkVXMyMEFTTXRNZVhKbS9yWE1vRGphVVB0?=
 =?utf-8?B?bmZJcUJIOEdIdk8rbktQN0xCOVVEWWFjL0JKY29LUEFtOWk2SzB6ajVCR0V0?=
 =?utf-8?B?SWZLZnhvNnUyazUwbUxhc2p1NnZMeXpVV0xSdmtvVTZXanhzTTVQL0FVOVBN?=
 =?utf-8?B?L0tvazk5M2dUeDFGQ1gyQnZMWUNZTG14ZEhGRzB0bWNkSWJ3SVFKNFhYT3FL?=
 =?utf-8?B?S1JFTHplNG5jWUlraC9sazVoLzErc3BYUGxQUEVOLy9SV3FtSU9mSGlWTUZy?=
 =?utf-8?B?bzg1VkMwSE9hZDMwSm5PTXNSWEliN1BwNHF0NmhJN1hzZnBUdE5yZUV5ZlNY?=
 =?utf-8?B?OTJlTFQ3L01JdFRHUldVcUxVWXE5bVFSNlRzc0JaaUNDS1RZcFhmaWNJc1k3?=
 =?utf-8?B?emVnWGczcXRRblNOZVBCeDZRYlMyOW8yZklQSDkvSnh4TmxSQzRyMEJxT1Rx?=
 =?utf-8?B?TTJqeEd0emZVRVRzNDRYeWZOQ2kxZUNCTDJtVzU2NFNOSWcwT2JaUG8xZ1RZ?=
 =?utf-8?B?bzlIQWpoN1NIbnFTRkFoOEJXUHlWVEJ0TFl6WS9KYVhyeFVTbXM1TXdSU2tS?=
 =?utf-8?B?cHozNk85cWN2WXhJN0lmVVQvazZGTUdydkx1aG9qTU90clZLYU1vNnhONnF2?=
 =?utf-8?B?SGM5Um81V2tXVDhyU1VnYWkrUmNNMGVqN1BoVXE0VjMrMlhMbHRqWC9SZjli?=
 =?utf-8?B?aHVNdTZucFlPb25qZVZXR3hhaTN0clA5MmpqbGtJb0NENjB5djNmdWVKS2s0?=
 =?utf-8?B?clBvNUlFYXdLVzZ6Y29zVk1kSWdqYjArbkhwYmVsRXNIOXBJYjFLL1FHK01w?=
 =?utf-8?B?b09kNUxtU3pqWnFmendtVmlDVitmRFU0dkppQi8vT2cyZFhGaGQ3OU5qZE5I?=
 =?utf-8?Q?BsLTclpdW5EcEeutTZcnF5T2hd2mSd1kgWB7So7Ei25FP?=
X-MS-Exchange-AntiSpam-MessageData-1: QvvCKNW0/eTWJ8O2BWXCYDbPmtxE2XHLWTI=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677a15bc-b747-48ca-3968-08def3208f5d
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 18:37:10.8333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VS6oi41TY/CfvA5+Joh4suQraKgW5ryypFaPi6Umo79K8mQ6JoQLaCWvwuLF0KVcvA5aLELicttAKzclpUbY9ZFEdfPH2STQ460EV8Gvxjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5221
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 376B3100009
X-Stat-Signature: bkb54eh8y7sb43uy4fhibkwswgm75kq4
X-HE-Tag: 1785955036-480579
X-HE-Meta: U2FsdGVkX184/RV3Xuc1bKr27Dxpvgsqo1tFtWY2f65DkGOrZ7RpjbOj/q4kkkHgi4K/J4EbmjllK1YuPWzAYVS7VTJJ8DEYQK2kmifkNun+vl0FegNBYHDE0/KZ4XQKLJ1KFzdI7xx3c/dQu8K4aYEfUspWjSnxB3Wt3/SBYVZjs3RCHtPxuAz/2iuUYghpGYg1L+FG3PGjB9OkqWK/RglfqTORjfhYKU15F7cOT/yLDLTcls+6x2dvZa+8NcLxzLm90qliUxm/SOweWNCCsptcd7KmgyX+PhYnPLn1iMeMLaXoHh9qyq4AAkJivTf2fJbchOLZK0g/8CXOJ5pAx6m5uQROsPRpcW9WIs4B3gQl1ePDvC5nlMlGh5sSCsX0P7p20ZUGjRqpz8K4gBzMcnSR5Yb5Um7QgBxREKMb178DTDtuN9IN700qSulnmIruB8HBAhxmKNUIMmnbJnXOOJZshR9+b5lIz4wKFCJH8L+BvCmn9+jNz9nG/dQcv95KpK8Xx3dZ3E4dz+VgLzjd/x1OLlXF+GoETMZ4hrXEJyBxFVODWdjSCWZwUs0GX3sKR2GMSYXCB7tUs9S+YKLM2s9xoUh/bGjzzI0PkUYJCE9yfGrLuRt7L+dhMFZJMLDXk9TPRuOLVIzv3Cgb7UowkNmiJfYFmsVTJ6e1jB4McrRsypj2Ps9fr1u3kz6qeTWo7HQ5zcyAAQYCXMVl19jYd3i9FM4kcoWof7mIWK26hEcOz56J1x7HOF7rt1GlAFYgtqqo+ebunmScCvRypKJRZ32t3l9Fp976a9rAyMnc7JyoMvgWbmyR/9rdFtyRU15HG0N1nbMxhHSwApWwOOptdapHe7j3SrnlFVBv7o5m1IeQ+4rTU5S4sr35+72680FFOniMeyJQQUX5li/yQsQsjj8g/cQqp/VrIlFuM6ft0T3EXPnC+FH3yhD/ykJmatbAsZirlCPM4cwgpnclsf8
 1vc6ROAY
 Z0d44waSoSKqkQOiyeL5DAWO35+hYUyCGO30p2DepqsGvaqLYV/FRgRRjOrEQhIuptw0iSPWpoSIKoEF2CWOnGQnKtSJZ5nnWA2npAHJWtni4fBcXn/5Q2lL30LiBxGb8onrlhcUEzodKZr6tW2IZKP+mtU96W/kE1UdD6XdiWesPcSfdEyvYYYS18kUGy++anhLTqsbYlG8FZccEeqoRiXLAc5wM3qwxntSYsTYdkfcIM0xgzZ8f6+bazUMUstKLxkDIgKbskcoFNoBQMYfMuXHqKV3vBIJ9CIG4NtBNEnBEkd/MX/DfKLOTe7mnnMP2RXbr1mZ4TIOFzTa8f2SdaASmO1asEjqQPFfsFMpT6jBnEdbcplNFR+il++HYujBVwPnjjnp9FBtUaoJaBLCNImANbvYzymAkSkJDShGNyD1JRkN0ZZKXhUP4myEUVurofZvCYYn6dedCZ4JVUogpTnI5GExXB+hW+zbD/a+2qchTz1XBncKZW4H2MqeQaxtS04VyoUGNBS5rWtnJ2Q5o4pOagNvm5nPHmUAEzOMCUvdJ6h1CYd5iqQvLEGCztKb71dWHVFXE0A6w2oz9pMILV2GRxddZ3JQcv6BJuXba0nksjGSLQJ6T8XSp4H6cpNqw0kNl737IhF2EHNqe/hfKKk2vyMiFPDD1v2QshvwMr5wUx7OK0MhbZ1Ee6p+XK/zlDvrjm6Rng2dyDJZdAqMcYV7VR3kbIlS6LwssZwI8PY5MzE9GuC7sLrfh2opxUPkopCry3XJaU5nmcTLBYttRbR7ODIScb6rTMDd0MEbaU5U7pOf4yca3WYhQHjJDaPtTtTOZU4UlQPUjZ/T360kP42sRC2op7okteQe8YPD4sK8vCt6UCiP/Na1qQlNRSP+5aidR7qP7kguw/+BrHCCZpUtJ/RCHwctiY6yMya0vS0kTn8fVBKN7n8pCrJd8JmMBd6CR8Lq4jeLtc5EZULapMV0ma55N
 9BNGIC61
 pLQi/DxfQ9hKvdvGKJ0isZbjQi0FTVhFrjLuF0Qr9GraAO77OjFg7V5FmEFV3flVQ9tQ153tvD9zsAQUPlDhlmmdR1WbXJngJwJxGlpuaTsBS8/QlMoYs+IEUILuVjLVIbGfdV/3QTndImPmapu/UbKGWGLKGIzGrTKACr/R4UEHL7ydAZsDOpdTdRtHIaSVDFg1QS3Y4/zUqiWRGZwyJofsRTrCrmgMGAH87ejHV5KWQW0rx5WioBO3pEWJEKZ/nLcDf54P0XfJR/K9ql6c5sj1ICddKWKa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-23 13:53, Mathieu Desnoyers wrote:
> On 2026-07-07 09:15, Mathieu Desnoyers wrote:
>> Hi Andrew,
>>
>> Here is the hierarchical percpu counters series rebased on top of
>> v7.2-rc2. It includes small bootup fixes which were needed to fix
>> bootup sequence on specific architectures, and a rename of the
>> test config option to include "KUNIT_".
>>
>> This aims at replacing the prior version of the series you had
>> in mm.
>>
>> As a reminder, the goal here is to provide more precise RSS counters
>> through /proc.
> 
> Hello,
> 
> Just a gentle ping for feedback whenever it's convenient.

Hi Andrew,

Can you pick this up after the upcoming merge window ?

That's of course assuming this is solving an issue which is
still relevant.

If there is no interest in solving this issue anymore, kindly
let me know and I'll drop this series.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
>>
>> Thanks,
>>
>> Mathieu
>>
>> Mathieu Desnoyers (6):
>>    lib: introduce hierarchical per-cpu counters
>>    lib: test hierarchical per-cpu counters
>>    mm: improve RSS counter approximation accuracy for proc interfaces
>>    mm: reorder mm_struct flexible array to place mm_cpumask first
>>    init: move percpu_counter_tree_subsystem_init() earlier in boot
>>    lib: inline percpu_counter_tree_items_size with boot-safety sentinel
>>
>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Dennis Zhou <dennis@kernel.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Martin Liu <liumartin@google.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: christian.koenig@amd.com
>> Cc: Shakeel Butt <shakeel.butt@linux.dev>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Miaohe Lin <linmiaohe@huawei.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Yu Zhao <yuzhao@google.com>
>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: Mateusz Guzik <mjguzik@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Cc: David Carlier <devnexen@gmail.com>
>> Cc: Josh Law <objecting@objecting.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>
>>   .../core-api/percpu-counter-tree.rst          |  75 ++
>>   include/linux/mm.h                            |  20 +-
>>   include/linux/mm_types.h                      |  65 +-
>>   include/linux/percpu_counter_tree.h           | 387 ++++++++++
>>   include/trace/events/kmem.h                   |   2 +-
>>   init/main.c                                   |   2 +
>>   kernel/fork.c                                 |  24 +-
>>   lib/Kconfig                                   |  12 +
>>   lib/Makefile                                  |   1 +
>>   lib/percpu_counter_tree.c                     | 694 ++++++++++++++++++
>>   lib/tests/Makefile                            |   2 +
>>   lib/tests/percpu_counter_tree_kunit.c         | 399 ++++++++++
>>   12 files changed, 1651 insertions(+), 32 deletions(-)
>>   create mode 100644 Documentation/core-api/percpu-counter-tree.rst
>>   create mode 100644 include/linux/percpu_counter_tree.h
>>   create mode 100644 lib/percpu_counter_tree.c
>>   create mode 100644 lib/tests/percpu_counter_tree_kunit.c
>>
> 
> 


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

