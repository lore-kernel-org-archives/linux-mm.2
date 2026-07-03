Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C15A6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 15:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B3B6B00D6; Fri,  3 Jul 2026 11:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822BB6B00D7; Fri,  3 Jul 2026 11:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711EC6B00D8; Fri,  3 Jul 2026 11:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 410A06B00D6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:10:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBA524016B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:10:53 +0000 (UTC)
X-FDA: 84947802786.28.85FE5D1
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	by imf17.hostedemail.com (Postfix) with ESMTP id E7BDB40003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:10:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a4yDSrY0;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783091451;
	b=0bfEZBKuarcFf9GdKHEjZJ2bitEOFWZKehr/Qs/UvkuslcGqjYtby3UvcgsvxvTqmdzY49
	8XtWszwBbRQTV9PT9AnNjk4aCtzBqRtkhj9lzrmPragpZpbSOEe6ERe46PiPK/ipt2VNEO
	QmDg2fYS50IdiJF2r3qzQ+TVOV59t30=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783091451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imbjWLDjLRDOdHpadbzmi2zb6YUKaZu4fe0MJ0xoukI=;
	b=UWVXzDg7tN7h4r7U5NKPoqJwmNfjzLN3bgiaQfSyg0LNwFgsXaPCIoNxFWkey6SnPWoUGB
	VpzyEd2/dnt3Tl64qOdCzX2Pqq0+dcFOP7sJNkHGw7rgKJqPteQvuAI+ck2UysVzflV6rg
	ksp0d1pwg+LIvnce0ksS3cxUOMxgzdc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a4yDSrY0;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWcOj+3Zut/vUjByMPpA3TpH/nifhrxUP48BvKamh9Kgg2D0ScvhXIw5X0Qf641nyMFie+ntPfzR4Yuo9S8nc0sJVkixcg+mVEfaPp9tadwXXne3s+Hr9230x+v4b5/fxMVanAFlNfTcxgDZTHrD4DHOLt/UCWQ74FWdJc+GRLzoaibepFWfyMgCthdAHJyk1EyHTrOxEJ9YC/dv+6gZvizLz5StG33lB0WNwFpsArexplnL7MFJmJmnYsKA13quJGSOfX0+nZmrXy7nSrvKHG1xcahFRPPuaZGoYwcCvankt90on8Ad0hkD1lVMeM03oUVPkhKTyFzJmczrh0N0QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imbjWLDjLRDOdHpadbzmi2zb6YUKaZu4fe0MJ0xoukI=;
 b=ViCA+cSrO0LfXDceeut9KMJk/S9p++5NWwYwlXNq1KAi0BlQLQ8kJH7p+BHAdl9dcs3gPdwUEXgsUSOFU871jkJtAz2T5qHZu9Isw2DXA8Kp8oPkE3acgAdtCumO1MT9ozbHxWGB3q2UsfrtKYkFhwpv62t5SjanT88n0w5c+/kWma/BYy9A/jxYh9N6WhJoLhAncVv9v7oSDYqnK26NqzF137qLHsf/KQ1G9/7xRxm+JfAppiD+i8kjNrz2Tw+6ZWE0uHMhWpleMHZI8tQ9AA6ucC09indOLqfFKUtYmhypmLrur2UYd/iHKGqCCIy8J5hKmlrAAtseZEBeEA0nxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imbjWLDjLRDOdHpadbzmi2zb6YUKaZu4fe0MJ0xoukI=;
 b=a4yDSrY0ffx0wySdnFeodS43KlecFRdA14xSW5JyBXi9Ga5yuAaCflVqrbO8suWYgqnMGxZ6smwp8VgJpwsXuYLnC6glW5eAdwE3r39m86ILOD13xSGsT/QyVdS6kq9rGNMkPsuxCJgBqtLfsynk2e1bdkcDafwIM25Kt9sHlYiV1K2FaJRIUNNvXEELWfSSmp1awj48W0Jo0p99wEUxOQybWqiVt9LuVvw/1Rha3TEL1d3BTAtXrSpR1ZZ8cTpow6ootbtHVQPwowpNwf3zwtM3HHhTpNsfQDVXIq/+zXnKET25fZNssLtQT1Lhcs6XZDMIZ11tUeIn4ruDRGZFcQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7347.namprd12.prod.outlook.com (2603:10b6:806:29a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 15:10:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:10:44 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 11:10:42 -0400
Message-Id: <DJP15WG34H2E.1A3IMSIGM8CYQ@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>
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
Subject: Re: [PATCH v5 17/18] mm/page_alloc: drop alloc_flags arg from
 alloc_flags_cma()
X-Mailer: aerc 0.21.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-17-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-17-c87b714e19d3@google.com>
X-ClientProxiedBy: BL1PR13CA0334.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 29910269-6be9-4efd-c649-08ded91540fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|11063799006|4143699003|18002099003|56012099006|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	OdgX1eBLMVuuhrnd/mpJFyQl4/Ru17zUfqmdCHtsvIsj0lfWbM6Jq9Dq0xCSMStF+ONhxWTqERSzWpdmkqgr4zdTW1M90oGnbTHQSqXaTm7qYuZLjtv1IlWpPHbXOooHBLKlqiBI0NrsPL2WV/vpcOWQC3EYeU6DpBP4MOwlP+CmrhjvmxAyun0zw0ThAZuAxE2Dn5WQVcOC8jyxF5g5uCTvSMQDPEg7iGcjXhbt0rABPY6/gNXCMdEpO9LQhd2ffk6bE5gd5KKT9f0fHaC7Nt0sjC7bX0fKb/+QrarpyhxLQP8deV0s8lO7YTynjG0CjWWI8eXG3bU7Nia4LYRDxoKBL1NJUc2FAr8DxQwHaT36rhCWlgQVYz2rvzdtF0U1zOWpOslqdr3xLQAV17cIOcuCEId4QTeqhERAGKfOCSi8CPq4QDtOMSbtt/9gGKHlAuSIWuV+5pbivc+pkgiBhO/z1D2E/+LX/gIyStFYl9ODnT9qwAK/8M9hu38fPTtHf9NFudg0r3G/7TeQvUouVK71UmHgbzQ6tjwhh8D6aNIXBLW/TGEKmvQHKAvk50qy+M6hAs5ncAkwKd3lWZFu8f/NjgdvxbzCvoUVocHEiFJ91PhSzuR2K0ihV2iOepPD3gEMdDSpBua54ss2BUlsHZ1ocdA1a+3VSdMmhEeef8dMkrP1ynpdsskRh3ly0nRCRX0Wz8JfDWxXVFluEvDi4w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(11063799006)(4143699003)(18002099003)(56012099006)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SllObUY3L3FiK1RkUVlyWmVxVUU4cUZ0VThseFYreUNpelVobVp5eGpZS2xp?=
 =?utf-8?B?a21DNENVb05JVmQzTFhTTkg5bTVzRnVWTXdvd3p4MXJSb0tqRzR5L2hOUDMz?=
 =?utf-8?B?ZkNONTBEMkdNNEZHUmpVQWs4dktwdFYxWWF4ZUpPVXY0cVNoYnFXblcwY0Fw?=
 =?utf-8?B?NExyWFBYOW5xMXRBemtra1J2b2FZUm02aG82d3lqa0EvbjZZQnIyZHRUMHBI?=
 =?utf-8?B?bEVJTWp2VmhjSmxmQkdsUm93SjZHdU44ZlJKS3huaXN2aElGMlFsL3hORS9O?=
 =?utf-8?B?WlcrRzR2Y2ZjMTRheHU1bGRZWnprSmpmQkd1V0R5WXVvMFQydmMzR3c4ZDBF?=
 =?utf-8?B?Ymh1SmZhbmhxaHh6c0l0Q1dQWmxScmhudUVrc29zWlJEY3dWNGV0TDQ5T0FN?=
 =?utf-8?B?TUZEbGJnMXd6VUdzK1d6aTlXbFdBTTd4aDluYmIyNjRBTmc4QXRDVytjNGhJ?=
 =?utf-8?B?enVHd29FUDhwejA3VmI1ZVgwZWpXTGJPVkUvY0xKbENCbUxVVTZaN1h0OXU4?=
 =?utf-8?B?Z2ZiVkE1NkRiNFZFOFV6Sm1SaUpPOUExdittNS82L29KcXRETW5oQXNOa2hy?=
 =?utf-8?B?TFI2azhTYWc4SHZmZ3dobWZ4bjg5QTdmbHgxWXdoNzRCTzdubTRjNWxxdnl0?=
 =?utf-8?B?SFVtNzIxNWxBTjVvVHhOanU3VDBKOUFtV3MybHU2U1NETzZVNE1aZTg3LzF6?=
 =?utf-8?B?T0htamF5OEtGRHA1OWNhNmFEMFlhUEZ1K3FGSGFZbDFTTit6MnQvdTFrZklr?=
 =?utf-8?B?aDR3SVZ6U3h4cUVXd0toNW5PSEZKMHlWN0FFV0FKdEU2bXkyT1FyUWVPYmhH?=
 =?utf-8?B?eFplK0J5RDF4U2pZTjkxQVBNbytkOTg1aHRBSTJtVVdIaEZhYkpCb3ZWVDl4?=
 =?utf-8?B?L2ZISzRLeFZEZGpBL1V0bDBtekFkTEppV3QyQWx1bnFzK3Z4RW9HQk1NUWEy?=
 =?utf-8?B?ZkRta0Q2R20yNVBobnBuaC95MlR5WGMrck41M0tRWUQ1M0lIaGR6WXhsdUg0?=
 =?utf-8?B?RXFSY2JqemI5aWIxenc2cnkveTZWR2c3T09hdEFycDV2dllTZ2xGRTd3Umt6?=
 =?utf-8?B?eW9IY1ZnYjFkWFJSNDIzNUF4dks2bUJHeklYL1pXaXBTNjgrYWt3dG1BV2p2?=
 =?utf-8?B?UktoSEhQRTVaTGdJckpldzREMmh2SVRvd3ZFSlBBL3BsdzhZbldZT1hUcUZw?=
 =?utf-8?B?b2ZPc2FubFEzdEFDMzNWdE1HMDAxL2JGZThIZTM1cVRvNmhvSUlsUTVMc3lU?=
 =?utf-8?B?akpBRFJqR1pmekIvSEpZci9lNU9ZZTFvMHBoNUJOeVo3aVlxOUZ4N1pkNnQ3?=
 =?utf-8?B?a0xVMXZ2VEJIb3dJTmd5YVhBV0ZEdTkwd1JvTDl0ZjV1czFIZG5FRFE1alpn?=
 =?utf-8?B?dGRoQWx4N0JDZmxaakRvc3VWd2pja283YkZvc3JTOUpUeXg2UlhtVlZEdnJ1?=
 =?utf-8?B?ZHdBSVJkZXh2NjYyTGNnbUtQclBIUHpsOTZVNThCdkpBa1pyZzNjRDIvcnNO?=
 =?utf-8?B?eTRhdXg1cCs0UVRXQXVPTUdORDUwcjk5OFRpa3J4aG1sTDl1bnFUL1FPdE1p?=
 =?utf-8?B?YmhRK2I3Q3FmSEgreW9IWDdUWUhUNlhKSi90L2JVUFgwRHlIdDQxeXA0OEpv?=
 =?utf-8?B?aENHV3oway90UmFYWXJKWHc0Mk1WOExiZDdrMStXeHc1dUdwaG5qWEx5bkFH?=
 =?utf-8?B?QzJza2QwQm9mVXBOa0xMNUwvbXV3czBNZjdVTmtyUzhielNTKy9wNEhtOTc3?=
 =?utf-8?B?RlZUVU9VSVdMbTVkS0RxWE9RanBQWmR4OHl4NzVCYnUyUGQyZmZXSkxTZnZu?=
 =?utf-8?B?V2EyRy9ueGVyUThHakVJRi9WV0U3NmxpNnJlN25VMUpoTWlvRERzSSs4Vjg4?=
 =?utf-8?B?YURvSjZlNzJ4a0RxWGNFQ2M4cC9CUlRzbmR2WjB5dUJiV01SSHdqY04wa0ZB?=
 =?utf-8?B?V25UeER4RmZYNjlXWURRaWF5R1Fad3p0TGsvQXJ5Vk93eUlnTlp2UXF5Rm9L?=
 =?utf-8?B?ak9lS3N1ZEJ6MThJZm5paHhLODJWRk9UWkJ6SGkwNnBRbCt2R29uZU1vVjlq?=
 =?utf-8?B?czcyc3hXTlBuQ3lMNGVzMVNqdi8rR3ZRTGMvZ1J3NTB2cUlIUkQweFdkSVVu?=
 =?utf-8?B?bjJTNWFvOEFNWEg0YWxxYnVmanUwblpsbk03QTFSVGxpaVhZUitCWFNPK0lM?=
 =?utf-8?B?UDBBVjdseEpBbW4zWElwOVgyUXhZdC9pVFc5c2hLOVFDRlJNNXpVUGZpNHdy?=
 =?utf-8?B?Zkx6TVZHaXJheWZYWnQvUmY2RGlWRm9oNWF2eWlzREsvQlpwWlZZVThGRVN5?=
 =?utf-8?Q?4I1NECjjtN/U18dVis?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29910269-6be9-4efd-c649-08ded91540fc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:10:44.2201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7OTmVfpoUHMCJJcOaE9o9p/8c8dLDSQwuTTCH5V9VUMP3aW+Qn/OgcI5oodMLcq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7347
X-Stat-Signature: a1t1k576hw1c6pupnbx4g6sf7sbzzo8p
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7BDB40003
X-HE-Tag: 1783091450-386390
X-HE-Meta: U2FsdGVkX1+wGA3g7OajtqgrBQPVakQwZIKxFdkmAl+u4EPJelAyNHXfoIijlbXaW4QLefBPhv3fqOuQL/d/O2pF22A6rL2LDCHa7PiUlqG4zNGkQ6J+hLIKuFhW1t9XyXrBTrRv2oRPhRbQYglvZgBvsL64nej+nm6XVtF6p8HqU3c7nepROJtuRg0EhwD54Fu+Ec8Y9mI5uM3Wb9AeWbUXusOaezOM1AnK7ySiLmm56G2b4dRwjLkobuHEQ7TKiwCdJ5zHsvfOs9ra568Hw5gb77N+1ifz5WiNjascmxhxPIwkRPkcJWhx3Nl2d0bKKoKUoVaDAHNU3s+YC473QBClQ5J0oRx3lK8NfQBtzINXwftip3oIAX3TSQ6SGTaD9Py5yBbGAgQRzZX3gL9j4FoVyLQ4vUtBQ/13ClL/pLrvYPtmcJwa3eql/nVrqVff3tbVoqpfoOS/QA07QVgLA+2bwv73mud7tpnB1i3VnP+42FgRo7+NnftLcHP+dq7rjnjpkyz1jEOhlsikEMq/M5xWRHtClbVrI8fZ6H56G9nmLqzaudjT+TU0CohvoEicH5eUhZ5xt5kH3et2DxivQdCCblfArzcPJU0awSQbdOyrS6fOunqlzREbfCZMMuTSejDW9EmC6svMf48k76TgCXhGDf7ApwqcMwNc6Jvkm+i+F5864J8arDrHBuvRw0DUKh0jboyMZtwfY2L/69rdtRuuT3m4e/60BY90XEm6e5+f8XhNMZiLAUeBfBfhpis0DFp63gvfCxuki+TLUpBHoOpr/Igsrv31Ek9SmE7kIzNXwgPrlQCuOtqaaaAN2HZ3fmQIlfdtwGE0cWm8wgIot9I9g139Wo2omAjAkRfUPTOzxA9GB56/uOq3AJw8+LvYqHTAB7fcdWjZacwfol1tYZjwQVn97ca6hh5HjUCPIUo4HHCAdFMkGpmziIXG6IdZHMkkOckYHU1I3EAsLId
 7Zi1mQQp
 IAL11MCezV4bBDVHaJ230t9idV8CXYH+8HV29mDY+AP4nm3QDOcpc5EIhfMNm2UnMbIKQqa4cIBHnhsGRSUZhouiu6aUC+v1MkUBnJZBBlhIQIjt6+mObqvaWVCUg0ggW+PIi0kAoCEhBrydZENYp11K+uUdB+uTLGLDCNGMj2thl/3fg01TLVU44XdF/bc3ZpBdasviGzyPzJqnLyi+3BT7dpH/HWDYu7kR37kPE/6lwGK4vAUQBZ06F5PfGqvT5xNdf9QuK0d4075jUmkbUX2o8bJVIoXdLWaBMysjyxpoUT3DXKARpHUaU5mzZzejbTYE9RCr8+ltuMtElQVftYqpgAa6ziqgBnuUfdOnVyzD5E3QyxqE00g8uDP16v3OpuirQecszi6oiw/rtUIOdzhn+fJls/6K1pZx/lMq502XbcPPa93+jk/iGWSIS7DujNjFClhn/XEXkVzv5I+SD4BLXglEJ99WbnBRcbom8gKsZxTHoG+slPz3bW9+i0mB+AH9IKWEGa5es8ahZFVEzHvhb70DWWeK1FKmxj4YkPaL3iscikhVfDvvpFooErkbJfwRr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> To align the style with other alloc_flags_*() functions, drop this
> additive argument and just have the callers do that themselves.
>
> Note you can't always freely or alloc_flags like these callers do
> (because of the WMARK bits that encode an enum) but this is fine for
> ALLOC_CMA, just like it's fine for e.g. ALLOC_NON_BLOCK returned by
> alloc_flags_nonblocking() and or'd by its caller.
>
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@ke=
rnel.org/
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
Nice cleanup.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


