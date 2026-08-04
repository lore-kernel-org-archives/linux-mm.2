Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F41DC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FFB66B0106; Tue,  4 Aug 2026 11:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1296B010A; Tue,  4 Aug 2026 11:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779266B010B; Tue,  4 Aug 2026 11:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41BF76B0106
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:29:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7337A13BE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:29:17 +0000 (UTC)
X-FDA: 85063970754.04.B8E87D6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012057.outbound.protection.outlook.com [52.101.43.57])
	by imf23.hostedemail.com (Postfix) with ESMTP id D56DB14000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:29:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YGMJhQ11;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9l5ipUUyt5U7sxkO9wZUTtHw5SNzX9o1IgrnmeRsJ8=;
	b=Id/V0cH37/9QjEmkY+4VtVrLDUfKgqzy1ulOsDNezZHI4Ma/OMY8zHEWMSIPGfzQnasJds
	5vh0HPpXddSTgSyoAhsKebFNfoWk8WODfUXWn4xFcd1YBhwPDSii3wzPhSF30dA39TiniW
	U/tkmOqv+G6i4GzvXNrha9iMfC826Ck=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YGMJhQ11;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785857355;
	b=YqBCcV2ni7nT/5O3m6s2iXHpKPM6oF3fUk7YTZkx0vswthuxIHTkJUrr6fsA/8TpdR8ILA
	qJd6jhhyt0+2/YdQKpTLXvcxnwv1dn/UHGgupiTsZu8a9xWh3JlWxmQCoqm95S5ZttRgZg
	A+O1JYBTqGh0b6Am9HwvlGG5cK3L2U4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3HQ6YXmb3OA0+6Xl55s8ypeqsDKr2Z4Ccx1tRr7WI3mv0TwLkzVBzCLYQAqHY/NZVEmTe91+3Gi6NJlh0dKsLwDLLwfVUDo6B0VSN31LC8Vi0pOk31axUfYsGlkPR9uRa8GM27Cjmtfhnokm1KJb4z60DtEwDBSo/DDgezYAKcT52MkRHI5OyltYfUvvUce5hDwK2f7EdBPjHWeKfE0wOG04WrDVcSK77JDd+JTSXA8ANxGmsSsXy6mxjoPlGxeUxXsblUGOFmKqBv5ofRk/DGC1A6BXZQXnxVoXwbSc8DvN8soYzJFA8gho8LbabxvQJhSuiiiA5V4Qyk7AhO7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9l5ipUUyt5U7sxkO9wZUTtHw5SNzX9o1IgrnmeRsJ8=;
 b=FSNXg1uvcwjI9UixU4aC65qLmwycQfsBM1qm/MbK99fBwl8PDOOOku/dUVoweG84M2gHuGN8wU1exHd+GVu+h2BxSQ5elLnsjvOZiXdNw1vQHQUmk1AfY8f+4Dfg7HhtANBx8D9SFJIqFt645vobHvQhSzfHZL7A4JgMmJKzuG9HJI7K/l7hjOJD9XxGQSp0Y6Jz731Rk+zkMPc1uPQHvYcEy7UfpuvbG2f3UuRHKXTJQeuUFMQlhm7kjG4QNjffCo94KLnr3yRdlsNJIYlVOu/sREWoDYJbUfNYZDX42Wkpk/q2x89cfAu13RvS4uBXjiwdi6jZK+28/XpI/mxQfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9l5ipUUyt5U7sxkO9wZUTtHw5SNzX9o1IgrnmeRsJ8=;
 b=YGMJhQ11zu3dPuKhUChqsDGadovcTQ2wJVkvTjIfiZkF8qynvt9bK1HsSK+UP3yDE0IQnci/cjFNsKJuhs1amHvuEO6zH2nF+n9Ox9xCWzsgPpNWNEGfE90nkZBRCD4EnqpeBIJJdP3IHtvGzh1NjmXE9TRuA9HH6z/Q0QX496/LsYahTykoFg6OT3jYliTyfAoLPRaYkMAgCRqOBzH/4u7TsqhQSiTnJrkku2/KPLIx1tX+oJhcvsTrM6R9geiSxb6ZYDRPEpGmgxRf3NVwO8dN966kwUgkHqA4gQ9TcWDm/yt5ZDnVVYmSu6ChXWj48S9vmaoNxls/1yfjM9/Itg==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Tue, 4 Aug
 2026 15:28:50 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 15:28:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 11:28:47 -0400
Message-Id: <DKG9L6FAJ73H.710UJ6RFRSZS@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Minchan Kim"
 <minchan@kernel.org>
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <anCuGbQ_-pTajAed@cmpxchg.org> <DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com>
 <anDHoYNn0lPc34cK@cmpxchg.org> <DKFM47T0EL9B.2LJLE3UFJ0E2X@nvidia.com>
 <anGISIAXkyKAY5me@google.com>
In-Reply-To: <anGISIAXkyKAY5me@google.com>
X-ClientProxiedBy: BLAPR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:335::8) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|BL3PR12MB9049:EE_
X-MS-Office365-Filtering-Correlation-Id: d4913e8a-4bec-406b-0f52-08def23d156f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	cHLElK/zhF3WIzBdos/80Ykmu0XpEAExvfmGcMTMASREs5miDqtDWynz/UEAQ0jxUVL66uwGaIZR2r3h34SFl5QhXOEtQbrveTZhV/J7Wn981TaLo9jY3C5LwSrfWtA9y/k2BlcZx9Jxd9GJi4lcUdZdr0I41l8GlxrrgfKabkgAuNGkeUenWG5Pd26jwYWIrp6eXTYgC1gnw312CxQACehXqxLGDnS+wQVaiRKUWId47j8gkkdgW+BhJWYuAWtav+ltsIOgBQ3nsiF0w+V+8gx+bn7V/8gr1dbyxnmP/JV8vWAzokRXlD79rMoBrgXKpG2owULHRO1H3DC6sEempvtq8ufEUesI72Rrq5amkBdjp5riUgoi+mT9GWzbuuzausI2odmllhbYx2WKcHK0UQ/cGbO8XX1oni2KNnb5fGF3LSBYj8UVigeLPN91a+gVvBmOjlEdvW5X5J/SCN2pxvsqoakbUrDdDGwT4a+TnouH9uZkZLJCAt1P21TBsw4B8VQJQ2SrKEe7Y1NnEdNxjDZPnG/TRYC8N4/vWtIPtHYEoOIAQ84XEgwZSBWUR0E2pZOCcu5niEz9mYpvU7Oa6Mu9wfoRJWn03/XEiMy/Bet/VqCQrxNlQmbs6Y8vHutuQHJveebAmHUtHdcKPUXmw+vf++lLBgx9EEK7ctmOpbY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amQ4Z3A5Z05sa0xFalA4OXFDTzlvSDVzenQrK2JYaW1LcGt0MTNBQ1ZOT2NN?=
 =?utf-8?B?ekhSQzFjcysvWWlwMmJDK3pzUkNtRHNrK1I4VVI4MGVaZ0JuWDhwOWxHWVc4?=
 =?utf-8?B?dS9Vd0UxaWpXRHQ0MjZLSEk3VDZrU2hIQmQ4QkFvQlhzMWxHV2xPZmVoQTVU?=
 =?utf-8?B?RHJ1UWFjZkxHdytDSGovNXdDam9VdDgyOFdtVkxYazNXNnFDczY5NEo4enIx?=
 =?utf-8?B?ak1LM2hxNVhqU3pLVzBXL1pGMmxMQzBUK1NyOXNGRWhHMWVWUnNKMUR6OFB0?=
 =?utf-8?B?VDF4UGxmNi9ySlFsWjdqdVdrcDlHSEljZzBKL1Y2bkk3cFlEUE5mSnkwR2ZW?=
 =?utf-8?B?MUQzMCsyMGtCUlFOMWVuM3I2VFRpc3llMnpicFFSQzFHdjh1MG1hc0ZmNm9w?=
 =?utf-8?B?YXpDVjh1bUpuVTMrY3RuRjJHRnpyNVJWMXJMV1VweXpYZHcvbmZVbmNLRXFH?=
 =?utf-8?B?QnlYei9qRlhzSnpKNTBPeVlVdmJYQlNNQjJUSXMzZjJyYzBUZGNWNkZ2TWRq?=
 =?utf-8?B?R2VVZzNwUzVnQ3pRczBFRXlwYktsQzllSEpzdDFjeE5BbVdZMFBnam9YczVN?=
 =?utf-8?B?a1VtVGQxQ2krQ2xVZ0c2NlV0WWxGRDIrampUenZYanhOTUVRd3M3MnRzdWtw?=
 =?utf-8?B?bFkyZGVwMTNYR1I4MWZTNi9aUDJnUlJIaFlQcWUvZTZ5ODBXek9jcCtrQlh6?=
 =?utf-8?B?YkVMdGxTeU11aHpqMGZzSjBlaWVRRzJqMWdZRjlTbHE4ZzNHWXE0dWU5aVJw?=
 =?utf-8?B?VWR0eGZjQnJEY1BBcFNXWFFEdlBBTmlxcjRPMGg0VWFFUVdLU2Nzd2kxN3hu?=
 =?utf-8?B?WXV0aXQrc2xIV0FnMUNGNUthVlVlWFd3OHVBVE5OVXI3bjBIMjRiOVRjN0hx?=
 =?utf-8?B?UzlQclBVRWI0d0ptTXVNSktNVWYrR0FBc1cvSWZENTR5WE9ncTNVVEhqTVE5?=
 =?utf-8?B?eGxlQVJvNXFoZHZ3VllYUVNuQytjQjE1RXZpRFlmL3diYjdjMzdZUjNnUXBE?=
 =?utf-8?B?VlRZMDQxT0FxSWl1MFRMdkhXdks0WEt3Qmw5MkRHMUt5VHZLQlRsN09naDRy?=
 =?utf-8?B?Z3RKbWFoQ0VOVmNvbnlPbml0V3hXQWNyNExUSjB6QUtSbnJxekt1TVZzVnlr?=
 =?utf-8?B?ZVc5bFkyZyt3Q2xncUxOTEJxdzdBRTBlclFMbnhlSXhBR2ttRVdqdXJJS0RY?=
 =?utf-8?B?TCtGMFlIdFVZY3ZLUnZqaEs3SC9helRMbjJvMXEyang0ZVd2ZUNxa0RncGZz?=
 =?utf-8?B?RS9kby93TkJieEFtQVIzY0cvRjVsZENwcmVNSzF2WDJ4TVhEdDEvY3I4c2R5?=
 =?utf-8?B?QWk2Q25pRFBIZXlKTTMxOG9Fci8yRUVzc0J0YkFhaE5vNkVZK21ocG5VZXdO?=
 =?utf-8?B?NDhIS1V3L0txTFo1cUFOb0VGUkU4SGhSbGRWOWR2WldQUVB1N2gvMU1KbFFi?=
 =?utf-8?B?eDZacklHaUkxMmUzU1pZYnBrcHdSZmpvV00yQVQ2cVJqS0ZHa2JkRGN2SmIx?=
 =?utf-8?B?eVY3VnoycldSSjY1VDFCL0hQanVPeUpUTGhudVo4VWJRLzhBdVNUUzZUZ0dL?=
 =?utf-8?B?Z0dzaWplSkZiUVhvVjhiRUNBendpVnhoakZiZ1gxS3ppZEc2YndJQTQyWnUr?=
 =?utf-8?B?UGdIRCs0UGdkcnFqdFIvdFBCUElJZUNVMWE4aS8vZE1nbXQrcGI0NEJibW1n?=
 =?utf-8?B?bXhLem9ScE14Q1YxbndxWTBBMnR0ZDIzdFFiSFIrbGp0YnprYk1xMWFSMkxU?=
 =?utf-8?B?dW5yWmt3T0NhU3VyU3NteUt4dzdDMm5oSDhMWEszNDdSaVg5WkhCaFZ2aWh3?=
 =?utf-8?B?ZGpJdlJ4SGpNTGlsbEphWWp3MXRLak9rR3pvS0tmQlBrNG5nMkRycTdjVlpz?=
 =?utf-8?B?NE4wbUw4VStpWDlhdHBxT0VPaU9BejFhc0J3NEJLTnBwTlBJYnFONzlWZnZ1?=
 =?utf-8?B?UDNpeFpMZ0o2ckU0K1VNVjB3bTB4akVkZVJXaERYM3ZQMkhoeXVkbmxOOGo3?=
 =?utf-8?B?WFoyZ0lHVTJjM2MrOHJmeGpQMitZWUhuQ1VsWEdhYnRUc3AxRmEwOCtBUjlz?=
 =?utf-8?B?d0F4MCsrdm9wUElzNkVUYmQrRE80NlczallZbGo4ejZ2OXB6U3pYRVdDZUJF?=
 =?utf-8?B?cjNjM1NsODZZRWh3SVFOWVFTajFFVU5nM3M0SHhUeDBhRmViWW5uM1dhK1p6?=
 =?utf-8?B?NHFXZWc5UUxKTU4ydERXUW1kTi93Tk9YTGpDcjBOc2JYa01xL1RlbE9velhw?=
 =?utf-8?B?UmJwdzRlL2treXMvTlNCOC83R0V2ODM5eWZ2UnozWW5meXA1TlNReVZhZ3Q5?=
 =?utf-8?Q?Ua5LGVPDjJ+NEWXInA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4913e8a-4bec-406b-0f52-08def23d156f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 15:28:50.1823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTUeSnJzS4qw4jDicfhjwij5YBb4AKfqCkdCyIKNlcNXg59Ch1QQftMEFHa8eUmh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9049
X-Stat-Signature: 4t9nuujee671sc9549kacogoedrkn7u6
X-Rspamd-Queue-Id: D56DB14000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785857354-141425
X-HE-Meta: U2FsdGVkX1/14dCHZEHv/EuKZXFjfQQ6MWE/iukCfI59TLn2I4yhUOEOxrKJNOeR/yNjq+QiKWWaZ2K2i+ssG+lsVq6OqpMASZyn/NqFnyeDRYp/9epOnPGC5B3qvFCiPLTtT5koN44T3eMn6KudA2hmhtC40TFOk1z4s90EE9/XVZ0XOD4CJ9GQsAflzjs2DZw9eKkQxZu+lwZgfgz88+du+fCsj3hYym8Mf6J9MXk7D2EDQ3N5ISJvouHEFYC798fpPUho7Z7enL3znkOXzinN9RQem2bkZKiiHlT+MnjmlArzUsbOrqiR1HMLGD1IlClnO0j/S6rMxwtwRrzPvN48ElFY+HAHF26ILu7TgGnpZtG0i1QuBpWfRrQsyatZ/j34clQDdYs3zcscQ96INwV48Zm3uVW4ehl1bqACUq/JcbgxQ9llQ6jNNqrplvCRVZEyrErSL49PIZbo1A0PZRW8vuaxtk9k6IGwC50s2/5r++MNKlpgrObhR8aGeZV/sxuuHKb9F+xfq/Wk7PRMozpIo5Ud9dH44eTuZO4O9AiPNSkLBmUnYdNZteSnmzu76RjqUmXieHoUIFG0pM2vRnVNjJOeZBZ1Ja3USvtkkMPe/GSrFajExvaPRVbrkdhYzD4wpPNvcNxuXQ3F1pJ0zJLSWfmNgatLKKcpLwCRD2fcFY0ledaQBzXfC2ihus85pGsgwQNcsCpIXNZz4EsCQXsNhEsc5y9dyk67ANQ/Fr7x1IfrYkKyMEQnAUb9mUp0BB1U2GFbqXGHeuIyx84hmjV7nrH0n+iK29XXWaLnjjQ2xB3UBU5aoy+XpZ6bodYrgncTv2mephC3hj7rgrFV7OzTrHrTIS+62nHTfrDIwVBS6wBFgZovtXzw4wURYJTSiq3I17s+2kxwC34VUy8UYyv8SVz+INsUP6dHc6BUO8rK4IOv0KZOFB8eLApvH7dAkXmAJgSO25VqOkdsysm
 kjvQ+bXy
 wiK+6gtwTHRjtqDAZ21D/tURx37QtqgOGtfqtX7BTBxU7pRjochdKgl+dZdVH2inosjBirmDrFGTYutG+LhS/gAIITqEpD9P6S23yXd7HEUnLMH1xxfQ5JqOLrchU3Znxhl3Qt3lK184i9Wg2mJ+kC0X+vEhR4+81U7zxfLMqukApUxs7szhyQVTrtSjiWIOgHqinJCR74QxsCV6FMgvk1z6m5NPfqkdjOaH80zXJpoYZar1SvpnrYeVL1jb1elKMIxYU04qaghoUsw+hfavXACZsSx7/n4IQU9eM3Yi/edQ4m8Cdm2UBjqxpK6T+VkLWhofS9muTb63sG/w1KMXoHbgvzqAv4Lu3sJLuiUdHUjOM5pZW1BvB5cxoTsoQmC7ZGMKCwP9RfNigdp694l890LvU9kfEFvtr4bE0ykXo/fJUhYV27I3qS0NX7lXPI7lIYh3z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 2:37 AM EDT, Sergey Senozhatsky wrote:
> On (26/08/03 17:05), Zi Yan wrote:
>> ...
>> should be negligible. While at it, change VM_BUG_ON() to
>> VM_WARN_ON_ONCE_PAGE().
>
> Is it really safe to do that?

This is based on our coding style[1], do not crash the kernel and use
WARN() rather than BUG(). For these two checks, they are making sure
zspage chains are formed correctly and related errors should be caught
at development phase. IMHO, VM_WARN_ON_ONCE_PAGE() is sufficient.

In MM, we convert BUG() to WARN() when we are touching the code.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/coding-style.rst?h=3Dv7.2-rc6#n1225

--=20
Best Regards,
Yan, Zi


