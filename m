Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DF2C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F516B009E; Mon, 14 Sep 2026 11:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151546B00A1; Mon, 14 Sep 2026 11:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3AFD6B00BC; Mon, 14 Sep 2026 11:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD6476B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:21:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E08911201B0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:21:08 +0000 (UTC)
X-FDA: 85212731016.14.BE57E0E
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by imf21.hostedemail.com (Postfix) with ESMTP id 047F81C0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:21:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nPHzEuSY;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IaJuj6XEigTkdDGlM71geYocw9XJR+7oG7gnsBo87s=;
	b=1bg0j/NP0RgZZGDSdmfwYRhkXu/96VZUFeyp3HWnyWDQP5D42ogFUdCxtMQca6sXg6vmDs
	meUVIPWm5Ie3VyaoRiH3g4z7dNx9YUZp6kAfqu4hzdqwYgYOGPEo80y9YwjBEuzkWB0E0c
	xY2YMDGUSoIWUFF5JClXFGY38aZYiME=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nPHzEuSY;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789399266;
	b=7cX/YNFQ1LtIuVkGgCQV+Z//Y7yVwWfEWVkQJ8HahDyJRO+krV6KSnUi6mw5y3jE0KeAAT
	gSpu9eMvDjkcBzBcN1DRCzDB2pC3t6Q/Y3rsuWtO+1VU6CTNjiSi9/4ov6bTUIJNkuhMFL
	MsMlHCWlAXp9VoJcPs+WGyh/mXCdsUs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0Ykw4jZ+pO6jISVDe3Jd6dU+a8+qKUh2V7Y702lat9qXQ7JRPqqpGP7W26a84AtV3MfaNK1wI26JV2ImHxeHfZP9wY0ykrY2qt1VIRzSRJMByBCgUSbwmVUyFF3HLF1oZTSrYBfyq8FrFBDjdJfjIE+6f1+k/RXozhwVhHtg83ZUqVn0L6SnYZVzF6v8qESWrdRO+8SIjeZ+xdQB9fcJBPdIIvi0ZrsKuEswy3XkqYGLeQgENq/JYhw80xLpaHvqxUfaalCY2AO16Kn4ODVkv02TV4pwr2efOc/bg0L2jLzOov3U+9sl7xgOYN14la0X0z+bX6hHE9NET27azMfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IaJuj6XEigTkdDGlM71geYocw9XJR+7oG7gnsBo87s=;
 b=DZbCeDMb5a7ONlAKHyuBLBxNZtDSEubK2j9+pOryX9xq+tZ8ab74Bcm0m8OudL5SWJ8FMkeUBRGfQ2/Bd6nokAf3/2458bOcpcw+fVUSgGEgazF1CvkbW1F77JeSoOyaV9lw4ODbyyVL2SyyQ/sJ7bLDbk+VYhOMSxixW5IaCMXfbcnzq+bGtDjCcOMfmPyEWhbx4k3SbAYR1i9ljVYimKzaPvteVDGkZdV5xUtCdnhJ3lWYbLpKxyB+Ejp/mD2ErrxzmTUWWcspXQIvDVPRuOBGFjUvVfYV/UkxgwMr/zPN2GaKyp7/faCHzd5GUwK6DRewHRGZKKYeonRftnauGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IaJuj6XEigTkdDGlM71geYocw9XJR+7oG7gnsBo87s=;
 b=nPHzEuSYMwykHgFb0yhACeSPZEGl/dAJeotj39Gv/YVci3WnGgrtRtqoGd8mxKSaytf3bJ7/mDMwd0X+YCicNEiBlmHNHAEjZqXk+2dnQhBuS+zGbKlfxsVQzALg2JIQNfFZ/GU5bzRExWzMvRVcD5dzR/W85cMvIJXA/Iqp2sa0DvFyim6i93uQim4s3N4x335R9g0EYTSvLE6CEXuM2UZX3XfzWkJ0fX5OXFExSAUlIT1iRfHI72pqMZnJxOFKlbY7C7EuOjaf2SpmJ1Vp36EY8HVgP3BpbNBam8uF8+CdcGM9mGYLd86l5vZtQSmvArCv/0LDPerDXUXoYDF/9w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV0PR12MB999092.namprd12.prod.outlook.com (2603:10b6:408:32e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 15:20:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 15:20:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/16] mm/page-flags: check page/folio->private instead
 of PG_private
Date: Mon, 14 Sep 2026 11:21:00 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <2EFE2C9E-F2C2-4E4C-84AD-1E3525DDA9D6@nvidia.com>
In-Reply-To: <85c24a9b-5116-4c3f-9bfa-ea8356890c9b@kernel.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-10-848550f7574e@nvidia.com>
 <37f9a01c-4f6f-429d-b221-73ceffd55369@kernel.org>
 <2CC856D0-3B58-4C84-AA3F-58D457344A73@nvidia.com>
 <85c24a9b-5116-4c3f-9bfa-ea8356890c9b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: IA1P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV0PR12MB999092:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a251a93-c37c-4a4d-cb8f-08df1273c7d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|6133799003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	+0+7FHt4+ZMoah740Suf7OAHUq1avk4oL6ozqiFFaWotkPNRFuxygWT32kH/hFmOMG/ebXh+pKciWAIoFU7uqjz18aVMxw+4ytPkzMRPjIyPWjimQiNkhDUlwLXtYjcxLbqORY7mzEt9Sv7nCmq8VWfAF4E8uah7hQh9HiF8xdKTMlTLyJFgOngmfhdswlcNdnoF4NFXDjbu+AjcjTAOsS3V/fUuj5LE71OT1AjeU7F1DNeBB7HNnf3AuMymRdYELMTuLWOSw7UkjPukOXR1YXuLCA1uM5M+9u41I9QkjXOE+1pFzr6PfLWh1by+K5VH3DlXqDUNG5/sTqj4azQYm+M80N8KjnPu35wkQG0QaePZ+PaakfKV/bf7/QvTt8+NpVzaYrp2eduZHPFPUqyXSZCe4n7Kua+INfc7COr6wtNFoeysF7chRoSfbBwiBsxIw7j2a9U+ZY1EHzscaYQz4MLQ/ZdCWtEyjZC6WGyCJ8hO+YwZ55OshPhZWQT2bwZBeo5vltUkKI2+pgOKEb0WBw1XrgODKAi/LQEka9yQuW24ATPOrHBBlKAL7jMNmlyrGPTDL7CFC1MnJJllR8AHu6q2Uzq8oRy5PBClURwq4+hl2B7+iHYtb2rckICIlLpBp9ADQuySwrZ5kMcHwmbuujckiAPM0egZ8du88kqd9Ak=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXdSRGE2cnE3Rm9HOFNESUhjNDZVVXFhNFFhQ1RmQUlhSENxRzBDMWxKdlU0?=
 =?utf-8?B?UmFMYUh3RVgwY0J3OEdiazQ3Sm1TNTFWRjdrR3FxbmtveGlkL2NGMStMU2FH?=
 =?utf-8?B?b1JZREZCTUlGbExhdWV5bUhES2N3MGhYZkVhcHlvbkt1b3IvbHY3NVpjOHJt?=
 =?utf-8?B?VWJkM2ZvRHMzOTBuTkl2UWdpQldHd3NKeHBDckZSdmhMbTlnNUx1bHBmTTZ5?=
 =?utf-8?B?NWdwTHJ0cVFtY3JQdVVVakVwd3NXVkRnM1VWbE41YUtoTGlaaUxHVnNzczVU?=
 =?utf-8?B?VldNVnp4cjhzdjZnTjlKRWxWZUlUY2dvYXNEZkhhSjFWeitWc1ZvZjFVLzdz?=
 =?utf-8?B?dkZBTGI3d1hCUTJkQ1R0L1hBN0JFQUI1VFRKNFZOYytpeU5Lem9RVDFZV1Vm?=
 =?utf-8?B?QmppQmRwVzJmWVd2TzJmRHVWMnFRdGZ1SWtqTERkRGZyRXBtVU5oZCtsT0Zl?=
 =?utf-8?B?dU96NjNwMzJOaEw5bi9FVEdoMk9NRTZPRVVYeTRMcWJKdUE1bzhCNndrWnRH?=
 =?utf-8?B?czZzWTlCQXp6SjJTbmR4VzJTTndXWFdPSGFNdUZOWGZSUWVueEhCN0w2MzRm?=
 =?utf-8?B?N3hMVkYveDhudktFelFSSFdVRXAxUUdkeGhRUWRQeWZ2OFNjSUdWaUV1WUcx?=
 =?utf-8?B?aURxU3V5c3hmVUptQWpRYlJMcVlZRS84RHZueG5ETEFUdTl2Wm5xcHFNc0sy?=
 =?utf-8?B?eDFwOWdDbU9RQ0FrYjhFT2hDZDBrOEIzV2s2S3BXKzhId3h4Sjc3RGtuTnUw?=
 =?utf-8?B?ZU13MjM3SHEvbTZyR1NvZDZjT2hRMWN5bnJMRzhyeW81NzJsTUpsRDVKR0dq?=
 =?utf-8?B?Tjd2LzZNbXlkNWZUTWVhTDFLNGhZUk14SHpMcUtMMkluMFBYK0x4NEpQMkRx?=
 =?utf-8?B?Lzl2cmNBV3lWSGpHTmtKSjNTT3cwSnM4a0hERUFmRDRjWUpoWHlOR21KUklD?=
 =?utf-8?B?eWJhWklwRGE2SUFHMFMzSUdDU2VNMG5jeUl0UGpqSnBXczJMOG5ING1WYTJo?=
 =?utf-8?B?MnhXeTB2Um80eTJzRDRBc0lyTXJDM01VQWdNMnlyRW01T2tKNVdmUnlySHBH?=
 =?utf-8?B?a2VNOHZ1YVI5ZGdiMEFmcEl2VXVCQ1lxekkrcVVHTDVDYm41ekpQZllIQ09y?=
 =?utf-8?B?QXZNNGlsQmFLNzVZNGdHQXpVclhFSnp1STFOWGZyOEJIYVZYVng0clZhUjND?=
 =?utf-8?B?VTYxcFR2VkFJL3VFSjNYMmJadzFLMWtZZk1vWllvTGVYV05IbDZmcHc4aVZ2?=
 =?utf-8?B?K245RlpXZ09rYTU2K1R1ZzdlQThtcnU5YzJhRGdOVkZHSjJVdWRsZVAzRjFv?=
 =?utf-8?B?OWVqV3Y5LzhIYkRWb3VORlpPVjhScVNKZGpleHJOcnByL1hNS2MyWjRuRHdD?=
 =?utf-8?B?bWVzMTlKZGpmbXJZcmhZeFF1ODhabjNZR3lHektuSFo0UnVHQmphQmFzVGZR?=
 =?utf-8?B?eGJQU1ZCV1dlVithTTNPZys1ckNtTTBUdjEyM3hscE4vb2oxUG51dEFmbVo0?=
 =?utf-8?B?dnVmN085Uk4vUWNRMnpxNXNEYURzVmFjTnVTSWJOODhpc0todE43Q1VubGFs?=
 =?utf-8?B?OFJMcFZKemg1ZFN0U0xSbWY1MEVBRnBZN24xUTR1QWhLd0dZS2xlMTYvTjNC?=
 =?utf-8?B?eDNzYi93bkVCTUhZbUx0OFhmK3dKVkdldHJPYmlxVWJNeW9tMDdDTTFUWE5K?=
 =?utf-8?B?SXZDaFpGYWdlN2tLMDd5OXF1dkdweUtaTzAzR3NFVUpXMmJ3Q3ZPRFREYzcv?=
 =?utf-8?B?WGlyUVZHNlBBc3EzWWNUKzgyS2FwaTcxc0E3S2lwdmxVbnAzdFVhT21xVEJO?=
 =?utf-8?B?WTZwb1lZNHRoaVpxQUhvWnVlVjVrVkZVQmJNeFB5d09kZUdNbTVLVERMRFpq?=
 =?utf-8?B?M1d2WlN3OWtWTzNMWnpsaGJHNi9WVmNNZFN4RXpTeTIyU0V4Q1VlMmVqMGhx?=
 =?utf-8?B?VlYrZ0Z4d2V4RzhZbW15eXN1TnNHSVFPL0dOSmxGNzVVbG5jbUNvNWVxa244?=
 =?utf-8?B?OHRMdkZIdjZWT3QrVzNaSzhqemZCMUZQSkpvVHhhem9IVndzU2R0YVdQSFQ5?=
 =?utf-8?B?QXF5bTdzOFo2TWVKS1VMRE1sR2doMjIzM2FkSHdESzcvQWR5KzVCYzBZLzNi?=
 =?utf-8?B?SDZ1bEtML1VVNXloR1I0QklHbmRkSTBtS0JiUG4rM3RPRy95Nk5CMVp5MTFr?=
 =?utf-8?B?dlRteVgxRVprczhRSFRvMEVUaVFzaGtUZUVWRWdpR1hrREw3eGc5TVZaR2to?=
 =?utf-8?B?U25oMnFYcE1XV21YaklwVzlLSEpGa0R3T3FtcjM0VHhSOHJ3Z09hYzlDeFdL?=
 =?utf-8?B?Q2tqYm45OC9jUVBmRFpycWlqYWNhZXVuWTJCYnJFRHdOSTdvVGk1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a251a93-c37c-4a4d-cb8f-08df1273c7d9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 15:20:59.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6qdZ33+dJk4lxDusU1j4Aso7JfwvFh4ABtejBkJ+shHYfY6tuFSae/xiEscu6rI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB999092
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 047F81C0009
X-Stat-Signature: zz8f9xo9peu9w7mka8amwe87x8g7pbyt
X-Rspam-User: 
X-HE-Tag: 1789399265-889836
X-HE-Meta: U2FsdGVkX18C8zaK90c+BzZwuSWvVBt5y0vF6WhVaNxbEUpKU6TI83JTomllyCYExwP4634t96sQRhCc1qLa3Y35zMNYfrczuE9KkFOzl0/07voO49v/EPa2B5IpFVm/uy0ZKXDNjo3gRTzCvcP5jnh6pfOgV+G4SnamhwA6BIZIm6l0NPyzQhlctF+payobM9cexnF4TTUlfPUycIoL1WWMpdr+OPleTgdpWor7JDFCkWUr7C75PhF6y3lnWkzJ52h9o3xpISf+c3ON8z9Y/5q1FF6AHMdJqu5l52oTJY+/HG1KoOshPA6SATKnjPKfmdT3c6KOtDI0LQGHpkjYjk/nA7sCuHH9hQhVUbp8NKz9mlLFEV5T/QzjAM0ptyACOPF289C/ul20hCieV4YxZbPXPx7Bk/3CRkGBo7Smm05lALhkb+dwYAxagp8BSWfwjrpRE5lEdOfeJRpXS1NkjTr9AIzOZ8Yrdu0xUHtcjVIhncKo+iYl3x2e1qKEXY+Gdw4RH5ESKJCl7v2yV6tas0Lcm+wPn6Zxt6L3GNMJoYQ3kxk+sMwO2Tg1t4faXQ1zuw64ivGMvMz+0Q7Kwb5jqN8bZDmEpGm9PvOeERXjsU6ARmmljxhSVaqdQNv9y+oCDebHDKs4TXCk3VCNBrK3G+XoyQs3BMhsZdWCt5FHWUfVlYm0tjU6fsx5Dg3dyC859EmrBWJRVvXGJu4oA1PqXSI2H6Yu0obhn8vjYNlfWQXEDHKxhnFNl+JYC51jTFi0SKb6qEdTuppnO51vrCNpu83HwuKi/sJb2mSQxQ42Zz47pHOyiJ3UoXia1/QEkRumeTkJV8eKX/oGKeU4jiLxxkRWtYcOhyppc2aXnGDdRf8LG/JzEmh4hiPexE3l5+6txL6mb7T0+K2VZd3FrBjd8eQr2vvEFhoq3yPIzHf2zVXS8nrtiQ0V54i8DVsy/W8AJOa44RV/2l5D0mB/rnj
 iu2+sKJc
 knxpkIbeFM+HcotbZ1LX35AvTBpkWUk4FcvwB3MFJ3jfx0rmodolYguA8uV3lFnW1wZjNHLUM5xygvB7BVp/EhrCob42tPGRjv/eNxNie9QxM859AiyaIeqK6DCFgmOGsK5Jh7xaBOFfMFDGqw3kqy9acqcnj+gvOCnU190SerjaWTDoZZJZkjsnxivR28rGbzzyxarNz0WGTcMnTAOeyfylR+b9HsuzV4ZOJwRkYCjEM3z31t5W1XNoD16RMSDjZHOiK4hZOpFT1PFJFdhaufEo93avCaciP3ArRKfVudtXgC9WyLTWfJ5J5xXN07ybKKAWp9r7e76KDdoSSTfwhNIUBdPDFl8gac5hFKvaxg4+Vjuusp11ZI5kRKEUlVrVnjeajV0Q7zybPwst5KKnC33Rx02YnNMtqjih9paTynOvItVLSaXvwz8Fusy6xW2P3VXk+LR3r/UbZ47X+DCAl9w0rF+ZUz1PfPPsGOa5slfO10SVtR51XydTgxH6yabfmqFjh1aI+b/MuxAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Sep 2026, at 11:11, David Hildenbrand (Arm) wrote:

> On 9/14/26 16:44, Zi Yan wrote:
>> On 14 Sep 2026, at 9:26, David Hildenbrand (Arm) wrote:
>>
>>> On 9/14/26 04:24, Zi Yan wrote:
>>>> After the changes of the prior commits, page/folio->private != NULL is now
>>>> equivalent to checking PG_private.
>>>>
>>>> Stop checking PG_private on pages and folios and use page/folio->private
>>>> instead, except swapcache and hugetlb folios, because the former uses a
>>>> field (swp_entry_t swap) overlapping with ->private and the latter sets its
>>>> flags in ->private. Exclude swapcache and hugetlb when the code is meant to
>>>> check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
>>>> as a whole, so excluding swapcache with folio_test_swapcache() is not
>>>> reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
>>>> stable when a folio is added to/removed from swapcache. Add a helper,
>>>> folio_has_attached_private(), for this check.
>>>>
>>>> folio_expected_ref_count() can be called without folio lock, so annotate
>>>> folio_test_private() with data_race() to avoid triggering race condition
>>>> checks. While at it, annotate folio->mapping too. Add data_race()
>>>> annotation for other lockless callers too.
>>>
>>> Shouldn't we just move the data_race() into folio_has_attached_private() and
>>> document there, that it can be called without the folio lock as well? Having the
>>> data_race in multiple callers looks odd.
>>
>> Not all callers call it without holding a lock. Before the patch series,
>> it is fine for lockless reads because PagePrivate() is an atomic operation.
>> But after the patch series, lockless reads can cause data tearing of
>> folio->private. I think I need to add this to avoid the confusion.
> Okay, but we should just keep that complexity internally.
>
> E.g., just teach folio_test_private/PagePrivate about the data_race, because
> that's exactly what worked before even with data races.

Makes sense. Will update folio_test_private() and PagePrivate() and get rid
of callers’ data_race().

Best Regards,
Yan, Zi

