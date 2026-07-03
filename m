Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08251C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CA96B00DE; Fri,  3 Jul 2026 10:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC7F6B00E0; Fri,  3 Jul 2026 10:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95886B00E4; Fri,  3 Jul 2026 10:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 912876B00DE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:02:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC8FC166814
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:02:10 +0000 (UTC)
X-FDA: 84947629620.10.F917F4B
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id C9DCC40014
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:02:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a45WYJKf;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783087327;
	b=maldpgggmQy5La7OzszgRyN9yhJTh2CrMoCBOqVsDhr/OAdvySK6jwmEcGuCA5Ka7fvLDc
	nyWwPuKR/JUxvW5W13dAAHhv7faTaA9j2bZK4tCAEemZnj7A94kz1g7yi6/buLmJVhP/22
	MlxBU16kP2e6V/q7vg+urOnP/+kZGXQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783087327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cgma/7XcKvjBGS0UhiT+59xLj75Sa7DGdVy7e5iIL8M=;
	b=JYfJFzQBvV00NIHyctnY+HGPIsTOyYusOdY4ABEI3Fmo9fgkaQq49zouLQiL26tclWoi8Y
	5Jw9qPcAXJBaQsDJ/XtbOl9fGRChAQpIOKxyl0/TtkPGWyOHGwtlIE2rC6v2Oqu0BrQFGc
	sI1AnGb7/G20aCgiGKfASUueSc++oQc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a45WYJKf;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPLBGR4bctTu+IYD6exsXdUbV2m/lB0/qDZmj4O0KJJZLvgIWkSsHat3i9QKV8ozTGHoJc7BcOdJKZjpww/lAds5i2w3CmyjYmbYDa5egX2uP3wuPE6hlybxli7PTxcFS1XMN4jNQAqRN49shYEkB/j9Vtx/u44raUDrggNe3RedF1eG0DgHlvXk1cv87PP3DeDCuahwJZT5LZhAI+8xgRi3VVc2nanlRLVhGcFHMU84J4sOA0lbPnpL0Vji7q7R7uOfmlcPVEJRpp6roo0K34mVe5uWbDD+yBw4UJC9Te0kUiCtyRqojCb9dzdNa2HHe7wK7c/cBow5ZYBTFcdCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cgma/7XcKvjBGS0UhiT+59xLj75Sa7DGdVy7e5iIL8M=;
 b=KbhHe6nlrGhPscByRIWv86pLwyPerSyeN40rTiPcOzao+5QNgon0CDiLg1f3gKMRqkbAizsr/fDVODPqyl7d7Rk9OSEBIWOTzF97LdrOohC9g/NvbN0qv/46R1Wuv1//ehUT6ukVmX5gICExsM/lVwOz23yEzgWrKRUZ4nvKEZeizyPCEvuhqd+Xf+1O0v5JfkRl7AgNPqDKXHOJiUPCELyz7/kgY6Gvd+SZGpco+smjSgAAkVd4GJi7W6EsNAV3MB5oEqsbzlUqBv7c9kM2kc2E0JFPvjV647UgYMFb/ve7nV52oRGUSzyP2+zn0mjzjFbcSR/eU8BPnV2EbUMELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cgma/7XcKvjBGS0UhiT+59xLj75Sa7DGdVy7e5iIL8M=;
 b=a45WYJKfsUBS7AdbYc2q80tEgTeFEBIMHVeVRrkiDvRWtfgExmqUbMqtAM1bKrwqPAxdO/K6cDcdvWlTTmGiuHmIDFnYJkgxO8tkP49w6SL+oqBCY/urhQxTZzgQzfTKYJJv9cmP4UF+Pf9baPp1SOXgf5gwv3m24nBmBD+3Y0NhYp5AWFq77ggETkkp3PD7y7OI8cHo8+p8XlGfzGbrFI0J7UlMz+tASERkbahQ1G/Sm0ZCEwcy0sRMpytEx8EJCR+cefggoRBBSbhGsDD4nIPGw6Om2Xa446adG938V523MLwXHOLxlcBIBg5RmbNHaRLVa0LMknD5q2LdNqSTwQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8931.namprd12.prod.outlook.com (2603:10b6:208:48a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:02:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:02:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:01:57 -0400
Message-Id: <DJOZP99PK3WY.27I2E9A25FPJ0@nvidia.com>
Subject: Re: [PATCH v5 02/18] mm/page_alloc: some renames to clarify
 alloc_flags scopes
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>, "JP Kobryn"
 <jp.kobryn@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-2-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-2-c87b714e19d3@google.com>
X-ClientProxiedBy: DS7P220CA0110.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:25d::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8931:EE_
X-MS-Office365-Filtering-Correlation-Id: 91393054-093a-401b-7d35-08ded90ba73c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|11063799006|4143699003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	CKaH89piW5qw+YmB6jcPMzMfp3ZALre6MuXRN7mhMoeId6SVAHcvyELnSDLoaEaGTsk1C/y2JnO/kl1so717L0jU6yQzji/ZkbLioQ7AwUCFTSKhGfYfRTojyMKeN7YOeRG0iC3vCb3UQ63mciwu0wvM4MGRRGybsatVedoP0flY5Ah+g5tkSVb0sn45yg04b1Fo93XFLpJMk8UN4/p4rn/iwphBw9gSY5kNuVsPqQJQDeuTvhv0Y2zrBkJuoXNXwhS9PbBmknb4Niv2zEzjztGk1px1xhE9XxkLxE3Hxf9ZXy0OIviGDyeMEUCwBXi1YkpAGemcLOpPnVgJz7dLqyaBuCUo9Wjzx4Hr3PYsSuWEzO4TwJFQh+A9wV8cdJ6ZlbvRmK+joXQoT0OyzXklYm7A8GVWC0uSP8WRb8HBamdTMC6U1luWWwOW0kY1ypRJ/f5T8Es6RGRGUSUfAehEg9aVSGm+PUjnVQOXVRF5xr4I5NZjFBIWZYTMq+PXtjDZ1bdl96DKZ3NvCF+wLanVJDd3rGcIgG2eCyLg6MCi82ooPQAMaO3xZCT8YfumLSF+t3RgXDPHma+2ehmNkp3qt1eozXWm0ho3VNjG4TNx+BA8HERkILBr9k0ojv2uPSN52NG2zlxcJp9WaCIeBNWsTi6VoolDs71KlHi5cJ+GkZAIm1Jq80FZZso4JgXXm4oHvptUG2CpmtRcYezQ3ZCf3A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUxlWHdYaWVUdkFVT0ZjVUZRVktPM1dhekRLN1A3L00yNklrZU5laHNSdEhm?=
 =?utf-8?B?d1NHVTZDYnhscGhnUFozSmx1NmxYSkRUcWxuTXVBb08zS2RQRXZiK0FOK2Vh?=
 =?utf-8?B?UmpJcmFLejZjZTZhUnRHcFR0MWhzcnNmckZCTWFycXUyQ3NlU0hTYzNIQmps?=
 =?utf-8?B?R092RGw5VUJCOUtXT0NZQW8yNmFYcTltSUg0ZU9tcFY3cjl6ano5S0x6UDJS?=
 =?utf-8?B?Z1c0U3JjUUd6c3pIRWZ2a3N5dXQwam1hSnZQbVpTNGl6Y3JPZmEwbnIxeU10?=
 =?utf-8?B?b3hjaUI1bVUrRWFOT3RuWk1paGZZWXVDU0NyMi9FMXl4QnhkN1pIWXRSQXdC?=
 =?utf-8?B?T2dJUnpwNzdtWVR3eUE5Mld0WlNxaXJTK0xkRVBsRlk1Wk5vLzNXaSs2NkMr?=
 =?utf-8?B?RVdubHBoZ2dFMFp5eEkxemplQXdKSXovZllkeTBvRUs3NjJCUjJVTWdOdUpN?=
 =?utf-8?B?amZNbFl4RXkwL29WejdMbGFwMzQ0cWRRc2pKL0NLWm5ORW9NdlZvTE1hRGwv?=
 =?utf-8?B?bmxteFVqODdmQmRZOUx5Rmg5Q3JCQTdJY21yNTlUaCtwd015TG9NUmJCYzI2?=
 =?utf-8?B?b2pEZnlGRzRSWUxueXpPaXdlY1dqWFFnb054YW5JWEV5bmVxSEppRXA1U1VL?=
 =?utf-8?B?dG5FQ2xaSnBoN1NJWTdRb1gwMGx0OU1jeWMzOXlYaGNYM2NZQVhkVDVlVWx0?=
 =?utf-8?B?K3k0c0MwakVvckI4TnRDMXlES3lWUGJsZ0FGNnRNZ3lYcktheW1VRkdQM3Nu?=
 =?utf-8?B?SG5DZUtOT3IxdFlIR2pkRGIyNlZPZ0lGUVJPb2Y1RzZEY01WSHBqbkkwNjJr?=
 =?utf-8?B?ZU9PS28zZVlBTWROQ01ROXVZNmxKRFJHUkVYVTRONVZCY3B0YzgyQmdYY0JH?=
 =?utf-8?B?RmRmYlN4Um9yd2l6c2U3S3lCYndIaGJwNk5DVzdGSm1Na3Z4TmdOWi9mbytC?=
 =?utf-8?B?ZFR4blZ3dXJBOWRvMS8zekJEeUFZeUJUS0JYdjd5Z2VjbW5Kd1k2alNzRXlB?=
 =?utf-8?B?d1daUTNubDJMRzNMRmpuaVVTQ080VCswQjBWa2kyQTFoaFpMN2ppK1daamZh?=
 =?utf-8?B?VXZlUDAyWG5aMG9mYytZWGQ4VTV2QTVFMTNTd0s0QnlDL1VPZXo0SXVMa0NX?=
 =?utf-8?B?NUIraXFnUC9obFVrTlAreFFoNXV3U0kwcnAwb01NQjVoSE1NcTFxaTNVeWgr?=
 =?utf-8?B?YVdBTExQWkhsd0o0YVRpVXhJbFVBZ1RiVFdHZUwxekVVa0UwalRMY2NWZ0l2?=
 =?utf-8?B?dTNyNGo3YjdlOTJZQkkxWU9XTUVpMTVnY2M3SGRESHNqeTJ2Q3drdzRHQmlC?=
 =?utf-8?B?ajg3QitUbEk1S1BqeDd0dzVWa2N1UXFKS2xhTXRzNHExV0Mvb2IrYlNyRnIv?=
 =?utf-8?B?cE9QNzkzQ1FUYlNaVUJlejdPZFU0WS8rZTBZbGdSMVlFOEg1RHF6MS9qMnM3?=
 =?utf-8?B?M3JxZXNwaExqRUoyUzQwZGQ0ZjVnK0lxRG10VHNaT2I3T2Vveno1elg0emk3?=
 =?utf-8?B?MGFpVFJGbkhkaGxQbnhiREIwNFNwRldtdEw2MzlqSlVJLzVXcVh0UVVRRTFw?=
 =?utf-8?B?YTRTWFBJQVFKanpCUnN4RksxNUZQWXJWMVpzU0RtVlU3dnF2cVdQVHg2QW9m?=
 =?utf-8?B?T0lzU3IwMUpDbXB1TWNXak83RDJnaG5RbUN0QUlCZTR3SXFJYUtGa1p2U3NR?=
 =?utf-8?B?YkZYS3NSZmNpVjhTRGdIcFQxblpUdUtlUU04MTlUUFRYTEJFTDZidmdsUXp0?=
 =?utf-8?B?bHhISnozak1ONzlhUXVZcTNaZDQ5VHFvZGNIYkJGSWxFV0VrR2owQkhadmRC?=
 =?utf-8?B?Mk1OYnRJTDdHNnVHNjVvUkphUy93bEV5ZzZtWWJ0ZUZHOE52eHBvL1NqaTkz?=
 =?utf-8?B?MEMyOVZZc1B1clpKWG5vV1Fjc1lMaFQ1YVI4aFdBN0cwKzBWQlR5NXN3SXRE?=
 =?utf-8?B?NmZjODN5QWc1NTZnRW83WkJJWGhYeGlDeEE0NkJxQ0RCazFoNTN2TGVYTTBa?=
 =?utf-8?B?VUc4VTh3QTMzeXAvRmZuUHRyeDZwaGtyMFd6b2NmWHZ2cnVTRUFkRU1kbS9s?=
 =?utf-8?B?RXdQdHVoREhBVm1BL1RXQXJvSXFZVlBzWG1hdVBDTzUvejZQRGNhN21CTXY0?=
 =?utf-8?B?WmhPVFVnZ3o5WVRyamlqWEhPeWJTTm9VenFCN2srNTZpb1VuNjJVTGZ5eTJs?=
 =?utf-8?B?S2xxZFk5NUxhWitVeVB6cGY5VmlBRE5zMkQxejlWdWdwR0IyMFMweno4MFNs?=
 =?utf-8?B?anFXSm11TUFsUWgrRkpQbTZIY0NwbXFFSXhVaUVhTDJrTzd4R1MzcllmTndB?=
 =?utf-8?Q?b9GI9fU30/NKQiatHZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91393054-093a-401b-7d35-08ded90ba73c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:02:00.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhjcXcZmGf73cXRAhJ1/QwjOI4bchpVJztQjMDbrL2rI/ExHaMXhlUbIDJw0kEt7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8931
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9DCC40014
X-Stat-Signature: gpm98tqeefowisbjwpi1d31oacd6pr4n
X-HE-Tag: 1783087327-444098
X-HE-Meta: U2FsdGVkX192ixZF6oUdN0//lnbC5hUBvwXcV+l64B3oAuFVuWKNYCYVLd5PPiADYT8G/M9i2P0NnsNNfX8dGB51cJMr4oia17QTLpQ1zYaZEDn4UrbZUxByyNoErzk2vWG7SVoF1XGDDEvUrq3t1U5MCwlx23+n9wJpMm7NkF2bUQEEPv5Tqb5AxIyu4bASaVxqw46DH8y1J5C7VptxEe2utsCYUaQEDVk3cgOYMxiBfZcVGoeTbm9mqb9bIFzj32jXIEF81AZnfLU1gSCEGluTrYpo5b12Ig6AbQFsQ2vliS64QLIwHwhQwupqi3K6BVn1ldfgrDxAtNWvXvmGQi9dXyRGUhO216Dyrd6fdKbwZXEGp9o4+NH+BevGTR3KaevvJMNcXoO82uuVs4Mn3ry4FQnA1ulRQGpPj7Ltd5HkZBbqqzvBiAxOxPgJdBZfQyFwTqVw7yqKC9nukj9xQfX96O1n6He7i0AR3Pu8wl76u6zNErj+P66bMbB7/BWVBhyZOT9JzrC7aL2HRVJ7OXaMGAgriDibyi6sburXEpCtXLoXF9US1tJV5o1B39AyR4wevc0W5xSi0e5evhGHasRiaYx1Sp2TK8O8oz74/paGEXc8Ns3dsZyRL4O0ESkqleFX7CQfZpuv+HBsjUGLfd5isQSd7uwDPQDmluSeABkuyUbZxhfcbwFEjPUSmesySUZlyy6+ByrI1HKwcU4aAW99dbK+DzFJmU2RV2nRFGMAH0ZLNKNKThNX1LHxG1wpz3QtOsvCGab46CbnHcvjpWLBbtcXR7RM/K9qtc6bJKeHAfsdzeKvE9t3eEKkISvHni9DaX0gMcixM5lGMqLf2XlcI7RiYBTIFU0Nh4usggPjucD606C6IWp/kSzOYXtHjwK4YLPD/WTk+h1O8zdKFBj778Ekb1j+i/kBuDi6q2PBRsjth6oGSM9X1bA/weOY1tBHxNVhXTiKK/SZ+al
 0rHJV86o
 yF7e03ZgLHa8YpdD/Q7lI6RoToFVheGoZk1OrLGrK0NrgrAOHdsyEGnGl5TLQgMYcY/QSA7yipu4h7ftwyCEdv37+d3xNYGpHtEEKaMd+fdK8EgFleQJwhbHlGips3eMVe0AQXHIc/p7rK6xYb7SJXZi5L4vL3TroddnjVcYO/YDJGKlPx5oyLtFDxNbyCdP4H0lZ4I3Vums/CT95qf114fgje0URQ9fD6GG7bczcjxxIR/f+sBiuALdNM6a7CWpBFr4amG0BdMNaKr72QVy7Nw5YoCvoNXRbzFLwIA1AAEcnZNYF+XNmR0Bpov344TFJenoLr57RZwcMpRrMi55Nssihw1hW2em2SjpxeHoCr0apRIbq80CqkGps0b4TdkAuqJJhJNBP46OvTZtHzved5UA0UfD7wgI69G3/khHv/NK4Wonu0+iGjhxYFBlPHUeznI1hmuc2oM1eKCTA2O8ROBRw91LcPJvj9Ci8oDGYAOHh6DGArjDYFfaQNEY8y0qNUnxa0zXF8hOJQmR98E+cMpJNXZaNsGNJu8GAjuyHVkfKzh9LG27Zn5SOOP2KmOjwB4DP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> It's pretty confusing that:
>
> - The slowpath and fastpath have a totally distinct set of alloc_flags.
>
> - gfp_to_alloc_flags() sounds generic but it only influences the
>   slowpath.
>
> Rename some variables to highlight which alloc_flags are
> fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
> slowpath-specific.
>
> gfp_to_alloc_flags_cma() and gfp_to_alloc_flags_nonblocking() currently
> have perfectly harmless names, but to keep the naming consistent also
> rename those to the alloc_flags_*() pattern (which already exists for
> alloc_flags_nofragment()).
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: JP Kobryn <jp.kobryn@linux.dev>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/skbuff.h |  2 +-
>  mm/page_alloc.c        | 28 ++++++++++++++--------------
>  2 files changed, 15 insertions(+), 15 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


