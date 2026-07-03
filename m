Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4244EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3563A6B00C9; Fri,  3 Jul 2026 10:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306DA6B00CF; Fri,  3 Jul 2026 10:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1C26B00D0; Fri,  3 Jul 2026 10:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E31FF6B00C9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:44:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6140C8B5E8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:44:45 +0000 (UTC)
X-FDA: 84947736930.20.8A60A81
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9D88E20007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:44:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NxqnYI53;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783089882;
	b=zmiBc0WkXCwVyLvpNB0B0B+twhF77VwBUaUvplitYEEJrAsY7F7EeMVDfBKrWxpi0QLA+8
	PWRQGUmTtwmk12HD94oya3XlSYbH+gRvQvCIkj54UcFSuWwUHUf8XYxivzXzKxig3B1rem
	UYoba+mgyyvEJqGnJraxkavzXxlhdbI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783089882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3x+0ACx3VFEUjN1Alr6i2LoBunDNI9Mo4G3bQHFws/U=;
	b=aWYc5l/dSFSsO3dDMLlYkanus8Xpzk5m6vbzi7AC1KhSbn7LBfqHQWKngfrPfSQ04DsGeX
	sYepaO8BiicoVB8QQWVATtfK7DSsieWiLnRB8+V86gyIjaU5gv87H4cKcvWdofJ4gsHDZC
	064XIeeUvQkYWHeYaSF0a0vZTZU6MTc=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NxqnYI53;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=klO6/VIzoub5N6edSkPrfTvTpr1QoIDUBzqJjNw102+LkHopgK/rKF0J92+AQVKZXx2QGl8264vJWOF8SIuaVajR3tezJg+5YSOY4UtwdqZ/mi9BS/serBnywfjGKAprRd7Ryq96MHXGHkIVZgRZFY8mUNJHXkBIHmho2ir3+cTJ4MxXjk2be0X0WGdns9bGWj7GSlm+fozetcdMz7MjBpvwBFHSQrpRx/ByS6PtSILoOq1eR3sUFaWZX0pqB/r8S9de9ef4CzecBYbcCpYRtYAdI3TA15Kf8tHDbK8vo9g3bpKzwqxWyAuLAzm69P2LWjpb3Bu4L90GQv3Rt/ca5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3x+0ACx3VFEUjN1Alr6i2LoBunDNI9Mo4G3bQHFws/U=;
 b=r3uGH9w+GRRMbm23Gpv/dsYiwsJadRRTLrmehez0mQi85rTgEPOwXNanvBkoDoS1BknvvW7hdWKjeMeI6SJpSgLHYzDPTyHDvpwxoxamyGIg5t4KsDWS0VoXNDzZ51/Qjh0H2N0P5emvuiCw99F7tAnRMCDLpOvCp5yCmsWBFSxBnAmyGHnZETdyA2qga2oKqzTeZTlV757U5XSCH4748PCEtqPdFrGuJhS+t+cxtPr7Scq89RbMivObiwxqGUMU1CnsWbc8c48IfJr+MHV0b4/qav9z76ZQHNLVOxCLVoHwrhozoJEyimPa1imX3qrHpR362yof/WhZcm/9AeOAvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3x+0ACx3VFEUjN1Alr6i2LoBunDNI9Mo4G3bQHFws/U=;
 b=NxqnYI53Orf45w6HSUbsxPwy5gLRRKM1CqsrEywJUZ/WscykueO54XKlFx+BnRIH0Q6zbthWZbQt3gAqvomQA5Kwi0rsRG+8vYjhzOXHliiC5AqwaHgHX0nuuOqFBWZG9yweWdoC/R/VO/u5tjZqI5Foxhp9TilKdRaYVyVMHnh4ehAzIkX0Wxarb4x/ItM3ugEfNwAEBkJ0F0GvtxCv+UPJ02EYNelgWg9+xUJoQ37quFY5fPGAynLHmmwpc2S29MUZUdDv+GuzZJWAJOwIpbZ2XAFc0q/PizwLqQk7L3p6mQoI+OKThBnLGTtExcWGc7rFmGgg5pcc9qmLxoSSMw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:44:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:44:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:44:31 -0400
Message-Id: <DJP0LUQSIWFL.35JYD5IFT1NU4@nvidia.com>
Subject: Re: [PATCH v5 06/18] mm/page_alloc: relax GFP WARN in nolock allocs
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
X-Mailer: aerc 0.21.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-6-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-6-c87b714e19d3@google.com>
X-ClientProxiedBy: DS7PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: fa22a07a-2753-4c0c-7f28-08ded91199e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|921020|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	3Jikbz2eIAdybvKGEIh7Zh4hpqcGozVba+ZVuYsBbPkAKDix2iWA+12ITpBMTG9hpbdhR8n9nM7FaJWyB6oPHNm7jRXZNqMxHJnSgbCFH/ZF6KZvHOpz0HVE4HFCecX8veMX9LZG49V6xFz07gTTicWhJS/N/9JA7hUgB09INZ0ftvoPiDYzDMZ/LtLS5mtFjgYLv+MFON47TfjZPi0MzD/RrP3CnRqHRIGWnxe3Nw2gZcGcYzqXaKglKKn9A5KpGpcdpyugiz+5o7F3LBDdhgZ9pJ9b443Q2O0WzMO52pbActUjBYBzM1Ps6h2bzoG/HPoIOJyAMil/5+aGaEa+IM1BJVn35qRV2MU7/ZmQkV/nSX8hIZT8B3LH63m54AbuIu0twrQvDvREsZdivUyK3xPTrT/kQQ9EpDHCPrZbeRQKOK5k8mg73vrkzjDp9F8SNtmRwjSN7366tF4MWDrBq5zOyP+qfrMuKurzEvb/X7zP8I/r8dOkiLndIVbW55msRKAT+Vp+cOEFwN+vZxoNa8GCK4bpDqRu2/jxMBQM4eqT2Ls6MBegzKZycPea3qTgD7dIqD9mm/y7HJv9oYcG2YGnQix6qjAqaYbTBh2GRLjEQFZnWY0fDbTOnZvivbZE+n3kqzpjVzr7KXxw+M9x4Fbckg47ZtzAvm1GfPEyLVnVrk8jx4qk0GFuuGQvVWOSQncxCO2k9QjJoXebnCIn2A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(921020)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHkyb0cyMC9NeTN0VlErRzFKTjh6VVRTMzNuUTVySGZtV2VaTFFpOGdIQ3dr?=
 =?utf-8?B?L3hjbDQyWUczaG4yU2N5bkNzV0lkSTRwUzRxRHJrbmRwa1JRY0wxeWluZk1w?=
 =?utf-8?B?d3lWRmdZbms4VFNIYmkzcnVXTzZzNkVPUWJvQmRpcXd3ZFVuNVhDZzJsQmVP?=
 =?utf-8?B?cnNsTlNBd2plMTRQZm1NR084UnV6VENZRGdJNm5GTG5ZdzI2NytLMXMybHRQ?=
 =?utf-8?B?Tnd6eXk3R3dYQ1FHL3I0T1NlNW54U3RRRTVKNVlPSW90QllObUJ6NCt0UUlx?=
 =?utf-8?B?dzNic2dRWVg3UmZaV3lpVFFrK094cy9sNUZhdUtGakdQOHYyTDVHbVlMOUMv?=
 =?utf-8?B?Z1Y1Q0k5MXZBcURQRXM5WElIWDh5NFc5dWZDd3JManFNdU03bmI1ck4zbWVx?=
 =?utf-8?B?bXFuT0IycnEvL0JNeE9va2hxMW9pelVBZzNFdW1XN2p5TmQ5cmNRUExlNjl3?=
 =?utf-8?B?elV0cHVLUVZ6QXNlSGdMMllXMXJYMTZyM2J1NkptY1d2cUxRL0xKbDRtSHQr?=
 =?utf-8?B?a3VPT2ZKK2I4bFUreWo5QXVHYmpMcVhnaUhPRDdUT1pzTkxSUWZEZERNQmNR?=
 =?utf-8?B?V3huanQxQ2pxRmIwUnE4eFVISmlhMkVaSlNtaXhSR2JJU0VYYUViYzZjZVFr?=
 =?utf-8?B?QXV1dTlleEV4bjM1ZmwvSFhBbUFNWVJRNC92SFFnR3J1NmJTVWlkRS9TZHpJ?=
 =?utf-8?B?cmpWYkM2MzVGWXhnT2lJTzlUQVN1L3p1M2JmVElzSk91OEVNU1VPQXBkYWJX?=
 =?utf-8?B?ZnVjOTR2N0d0WTYvNTEvSkszOGY0T3ZWa1RLaWNoVUUvaWpMemsrUXJqelkv?=
 =?utf-8?B?L0NTQ0ZDdmF2YkFwZUZBb045QlQzbmEzaEFMdDJMV0N0R2w1NWtSZVFJVy9V?=
 =?utf-8?B?YjI4dlUwb29TVFdyeFlBaEpkY3hodWtWT1ZUZ0Q1aEdlUXdZQlpERHBqWVRB?=
 =?utf-8?B?aFovL0hIU1ViTkdvUU5UOHplOW0vZFBNYUQ3cHRYcXVpT3d0TStNNSs4bXUr?=
 =?utf-8?B?S1M4VUp5ZnJxYS9QUGJRUHpML3NPeEZzUXRhelFtRVl5NSt6VDJZWTBWYnBU?=
 =?utf-8?B?RUVQZVZxaGZiTmI2b0Q3N210VmFLUmduS0s2cXdUbWRnVDZQQ2M2dnJleFZ5?=
 =?utf-8?B?anlwQ2lNR1Bwc01nRWNhRzFPSUtVWmNLQlYyZER4S28xSWxxNFFOMUNTSXdX?=
 =?utf-8?B?MFRwVGJWQjc4Ymk4WDBob1VYRlhSaks0cFVCdVRselM5MkhXRW9NK0xjeDAz?=
 =?utf-8?B?OW11QTZlZGg2QVF6NUdpSCtMdEpCUnhKMlZ0UVZOUzJyTE9rU01xcFBpbmp0?=
 =?utf-8?B?R09IZnNuR1V4TnF1R1A1OXFrOWdIVjA3SVZsS2FoTmhIdXhZZzFJM2U1YVdi?=
 =?utf-8?B?VytnOHczQ25BU1A2R2V4MUZPWkh1VUlxNGRFeGRMSkVYWXgza1p4dmZ2TC9C?=
 =?utf-8?B?T2VhNy91ckUwMVp0RHdGbE5SS2pNMkZIZzYzSm55QUdCRE1BRnY0Z0cvUVQy?=
 =?utf-8?B?ZDJ0ZXlpQXFEZTN0d0xyRFpGRkJnRExpV0tWb3AyRi82YUw1OUpob1IrN3Jh?=
 =?utf-8?B?SEZWWjlFRi9SMHB0Sm0yTVFrdEFiZGpxMkNad3hsUFV5bVBENUJPcEl1OEhR?=
 =?utf-8?B?dW8xU20yQ2RVUmM3Y2taeXU3dWF2RXp3S0F4eXkrdzlpQyt2REhwLzltWitk?=
 =?utf-8?B?VE1lZ3BPbE4yUlgzaWNleTVMZjRpY1B3eGdMSXdPMkJaYVdqNVlzWlQ1cWdv?=
 =?utf-8?B?dnJDSEcvTXp6Mjl5bW9xSlBaQk1NQzdHRmtRbEJUdXI5WjhCQVhTR3hGaVZB?=
 =?utf-8?B?YTRvQ2NzUERKTUpnc3B3emNINXlRS25IdFVObkpBaGprbzBHWnRxQkI0T0kz?=
 =?utf-8?B?VWtlZGNBdnpZZEdDbUM5dmVKcWVRMjhHRjh5OXluLy8raHl3NGJoYVlTbVdE?=
 =?utf-8?B?VEV6MGhWejZhTmJnUHIrekFUYjFLU0lYQ2ZyR0JTOVYyNWdwZlI3S25jNno1?=
 =?utf-8?B?SFJGcFlMZzhnVGNUaXZDMFlpSVA1STBzcmg4RTJ1cyt1dFBFNC9qdmtFMmsx?=
 =?utf-8?B?b2YvZzV6Mk13Yjg4djV3UGQ3YXJCUHpDN2V2ODJiWGF3ajN0bWdjMzZISHFK?=
 =?utf-8?B?Sm56WldGS3hTalE1WldzZC9SYk9zak9BbU94RkhjL1NhTEdzSW9VY1hiUHBN?=
 =?utf-8?B?eGg3VExRMElaSUJzQlE0OHRuQWpMdWxubjYxRlh5TTAyZGJTUXN1ZkJWM1hI?=
 =?utf-8?B?bWdxTk5XM3lJb21lUFFhd2d1UnZHQldkSkNIV1FIeGZUTEt0bnBWbVBlM1A3?=
 =?utf-8?Q?Od4Eg71huSD39qkMtY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa22a07a-2753-4c0c-7f28-08ded91199e7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:44:35.5756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7DFrB2osEyqcvlZx2Zg1eX3dhX8hlWMHxiIId8T9t4lDLUeJAn8Ln+og9oDPa/I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D88E20007
X-Stat-Signature: 65brfdtskwqkqhbjeif9x6kbw98gdr4m
X-Rspam-User: 
X-HE-Tag: 1783089882-84480
X-HE-Meta: U2FsdGVkX1/jQvvOlU/ARI/f5ZeOWqL+rocCGgFilqNksV7NQIgahuIJ6K3Z3TFZL5o+e6J0BpdceMCMFjMslPcLvn3Mmdt8DK4yfGZfFZeeOImjp5JuN9YFMzyQuVKOGjboc2clRF7mxRZJDzI6ziveAGT0Iwfuc9LtfFRFyKywDrFzkGK2zPcfgIe/h7oexs0swrXBduBN4/NOhp+H7MteRAKVwP3w1IE4rIYtOzjLaL8McQ9cTQQD+ww23BdP0B4VWKjitdiRRmrJ9r6XTCzCDm5t1NkfoRCTuBwtayzMmoTyAkBuTNLvRhOnTBFw/vJK+T+HL01TxQnDHqVMCZCjD9OnZF0sTkyDc/RNKrneXPqff5F/g6p27WmUvYNKKdVg3Wrbef4APsEBwt3Et1LimS7M+/ouDY6UVfCdK6tXGlBYbdjBKUAzuy1LY/0/BdnWr9VN/WhWtgqXk37hqbGr/ooIOEFztbff9AeX1S0opLae0dzi8h84k2WwCHZCaQjw8GoVdA2ShqmJdhYv3yXrikkH4esWFwNrNyENA/aqAOGys45LhMfw5tgfwhYQlrFzzeeJvRcJeqD4TIfvGBewqwLpj1kez2hPxS01bQTE8xYVPYJ0F9PwIJz5o7SWmieqYYDrFoQ0NjpRPgz6+BP18RudbNP3OH7LDVRv4zxmYBQmmgHyLywEAzKkCkjO3Ql1F19TqGLIVL/s+m7A2ZICTurKqUN0+5RnLA1pG4wvUm4vgWp1UgDkN7oW2krXDhgJtpS4Yy9ESX2p9GPYqCVG/dxG/rbLX15NnlfPQz5lQ17KKXOiYYqm7WRFSND0lmDg+QwJaSdEHUD2pcwtg4O168RlOAx8uozfso/64Zt1GUlJKW2GeMZoglCVFbHJV2vOrf4TejDLku4vA7P8ttTREFSS6oQTxBjDSkFJPaiTY8WdglA4L3N0mJ+Uw35wNL+PolRIUfGpCnKikr5
 0zL2DnSM
 FmEhPgrUC7zkJjOTS63IKmjE6GUitYbOacVp/evbxXElEZVxrGHCZa8rytFHtbwd8GplojeoykZrHS5Z2g9b2iWQDhUQ9KQfBvtFAwgkseon7FQ8P4xfPdnwSs/rYEJ1iRYYQtmKpsy4RPeW284YakJ21jXl/DDzzv9AqSWmTTj7JnbTdBRyEVUXDgXz3udGBFtshVlVBG+F07IjacjeU8t0/CYSy4rVskIhhEoipj3Uabsw5r6NBBF1mKShum3jEv8Q7AgJw8XH/hXlcWlB8pmnvIZz6QE5EioG74u9cm4paw910fo3LNBdxIPzP2u0Q5XxA9obIzeoqLbu3bmIVjokc4VjumLXZEn2JqOIftNjPwqglv6Oarudx/QRUZpY8GiOybM3mWa1OwmHZgBXXzexmcvjRvymEfbht6BKOYjR88HK9GPWJ8EG6YMwOc/JvTZao7jdWN2LmqI8iypgRgfLMXvfdWlfqXCS05pI/8eSI8L5tauFEo68IAUX9w+tzRWAP8f8snwMw6eTV73Dl497kCcFHILHre6yPB6qs4GL28/WR4gn2h/rN2HI/d4kP+J9VESbrWXJLdzi83gg57SDbHZhhBx+k7hsR8nl9Xw1Uf3lVDGszfACqXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> This WARN forbids setting other flags than __GFP_ACCOUNT but we
> unconditionally set the ones in gfp_nolock so they are certainly fine
> for the caller to set.
>
> There are other GFP flags that are almost certainly fine to set here;
> Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL. But,
> nolock allocation is rather special, so be conservative to try and
> ensure we have a chance to think carefully before nontrivial new
> usecases arise.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradead.=
org/
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


