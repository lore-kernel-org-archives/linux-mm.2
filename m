Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D4CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDE46B00CF; Fri,  3 Jul 2026 10:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B52E6B00D1; Fri,  3 Jul 2026 10:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A48F6B00E4; Fri,  3 Jul 2026 10:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7D96B00CF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:57:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8E5014016D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:57:24 +0000 (UTC)
X-FDA: 84947768808.10.78CE127
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	by imf07.hostedemail.com (Postfix) with ESMTP id D882D40009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:57:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=inczzgyu;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783090642;
	b=l5fo11LYgnIUrL/DbUFuBBCmsBjv5ScI5CYi8WJS4cAFkkc/Gjzwo+BREVex9omgDReRK5
	pFnHtagm1R5MuTMq8YIT0FVgG7coYz+TH0WzV2LxLy8spviXuqP8Zi4ahSkzQT/wZRR6tF
	04RAuv/JU9VJqPY/u9rEMXDDaEISeWk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvxpgldXjLt5+64jZBBRjftzhiUJJ1YwlqnAgS6rEfY=;
	b=fO9nnlqDqrYpWqSzeEhZpmo2NbwaioTDdWXmkmhctq2fN/EyknIFfz2/3YSDep+9O5qRIf
	Yezn9mtK9+q7Gl6MLwLxD6vbPrEdFVCRezUaqfRlOwDOfXkn1/tOzI1gmorHmj5CYv8DPz
	FjC4fNTpDYJApUWq8Y9696QIi5DuLRk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=inczzgyu;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFDbEFsczvaI34FbOMoeWisdC1qb3xP7UKner0p3QSQWX11NqakpoidUkG3/191qhWmn+4q9b6bndmkcl7cfWOKLnQC7bl03vz/SXrIVZueNxZRakkJrZxRLE1F04QRhoJSpAoIVmQ7nr2t4o3byo446CbosBtk9DaJVGNW8dAd2lyX1hIjOS2cj9Y2oXCjjID9mQJxcNUvogxRQw8wh9iyvj1GNAu1AQdVK2EB9Dq+E2ljq5e/scCGXVLfbCZbDw/ndeFGECpwkVKjAyXtvbg5t79oOwNkGC947TWqrDpgWHZF62cnsNmV9YNosxx+LfpXsPGn+QxC1z34Q1o8M+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvxpgldXjLt5+64jZBBRjftzhiUJJ1YwlqnAgS6rEfY=;
 b=OYL3UX/wvSn2HFGl/9hSAgXd+YvN0/Uk8R3+uH07EXunhCCPlsiUIdxaYAyn0J8AKJJCE1sWo3KEFD293MrNFVy2S00DlUHVldpivu4FAf+pHMcfAjWbEIj3ojkPU3bqIGuR/foR1pIXCfaWS7IzxAMDL9MkMzfjgIYiO9oI74QPsBaAirDxIbekt1iYOUcVTmdJMlVeN0ExtlJ7HMRaXqHiVyDhyvPwPvdtHRPHM02J3zixUuUnKnhHE2GDyjjI8uUoyq0KHwO+Dm3YU7SjURzMkt7HKzqamWrilmI6HHvsiDro/eHNgnMkdfElmjxn5jM/cN4jCqtDwZFlBYdPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvxpgldXjLt5+64jZBBRjftzhiUJJ1YwlqnAgS6rEfY=;
 b=inczzgyuVNZuwLD7Cn0FZtkrCUQDYPii5ekVQ7kqjHc6OjadzEmaWH+KNL4wdT65hGcBLkqAKp89Ih6371QBE0ZOAubKWhfHta+WL9smpjDKM6DpZ0iIltAA5Z+oIuNkVcmwKlpBdAnUL4+CdCIbUf1+O4z9oTEFi0mLfrvGXpXo81EquxmF/8KpJ/qG8n+jRmXhQ29lK6Ud59ncOh5+qrNSmhAadl0gZzjRJOCWYTkSOU065Sp8bZi7NiRO+2kdLgBbHj/xeDGvFakzodGQHI1gRbI8zJvuGuDGU7JURsL74WU6eTf9XgrvnSb1VPLP2aybtJ+O6lDSvqV8xz7QpA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:57:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:57:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:57:13 -0400
Message-Id: <DJP0VKJLE8TE.6EDLC2BFI1SG@nvidia.com>
Subject: Re: [PATCH v5 13/18] mm: Remove __alloc_pages_node()
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
 <20260703-alloc-trylock-v5-13-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-13-c87b714e19d3@google.com>
X-ClientProxiedBy: BLAPR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:208:32e::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: b10b2ae2-1b6a-4daf-e1e1-08ded9135e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|4143699003|11063799006|6133799003|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	ycOAO7HjdWjcDDOElM5H+lyIMylGcYZRx7ZnOMjRlx0xysZn4/16m/xb6IZMqyfuyxJM+YRWGQQZCJe+JQRf4hcbcZ01y0oZcYaUsSuak11kkQWEnB7jGbs+76ttLIA5WCTAS08jnnN/K6u/zGmHYBjpfi17DHSWzoB5HALBz6cbTl9Hw37bq17XjC1YoT1dtJ/S38Hh83kQ4y4TsSBW9hkOfGMmbywdNVkBrumSFKu0RUNXw0UyYYy/QCwaNSMwnaVxaZb4ZlShOmuiGvO4rSF7OJzsUXEQU2b3ihyuJ+aZbtzHfrMAs1sK8UoNsdtNIwwDZvONRxR1WmdJf1dyJVLnVmbYdjsg8Q/nM+Bm7Ui+Vqh7n5mZTiRrrEaQw0zaQfNQm0EjFQ5VcQfZN5eNN8KvoQWl+EckIfdj5J1SwldcbxR6RIAKgo9928ApQGs8hdiWXfPjl2nritnqPeYnN6AYWpbXYAfuL9/5qHxqFpyNE6IppsBXsAxWtS5l7EUXFXGSkbDQHEZ890u9qUJsMAZlavYDpLu3qC8huSyRC/31qKgmhJkgveZo4DkFowKbJNmm/JP5LVDXmAfiL0N/gFwQBaMdf4HbjQEPdP8HJEFq+Sn6IqSunizOs6naeT5GGM9RVl/2k3Ogha7fgz09C0rivtC1qt8Jv3nueSNyTLQTrbunfmJuXCccYdh08DwQ5D5XGKZQWYFKYLNw48EWmg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(6133799003)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE9PNmdjcng0c3ZEVmF3dDFkOXNmQitDWmNweS9wWkF0OVovSHBMK1h5ZjdR?=
 =?utf-8?B?LzhxYUM5WEVsQU1Rd2pEY1BPTnU2U2tqbDJmSW9pR3lVZzRVRDltWkJxRjBW?=
 =?utf-8?B?Q0hibFBncnNGVDRTeVJjS1pIeHVyV2JuejFjTmFESXowRk9URU1WSVZENnp5?=
 =?utf-8?B?Y01MaGNNMW8xMFprbnFKa0lpeTN0c1htWkpDMVJoUTFPTE1MUlo4dWo1RHdE?=
 =?utf-8?B?L3k5OXF5cDdhVUdEK3RYM0FSV1htUnRhKy9lck9kcmIxdDhPKzBRSDJrVlFk?=
 =?utf-8?B?Mkw2VFErOVBOS1YvaFc5aWVCQksxZVRBaDN6NGZLL1dhODVqSk0wcnVxN3Ja?=
 =?utf-8?B?VlZTd2JCRzZ6d2RuMktXNFFJZHFBUTVMOWtXQng3VzFTK3pOajExSUxraTF2?=
 =?utf-8?B?ZVJTVml1NkpiNVlFRnl2UUxDcjBSSC85cVNTME9lN2kvWnlvUVFuV1Aydkpw?=
 =?utf-8?B?YU9kSHR5Vi9wS0YvL291VmsvYllLSmR2QTNaL2RMajRabXRoZjcyNUJQeHVQ?=
 =?utf-8?B?ZzVsUjJLSXkvTjF5VVd2TmloMFhQVVkvVm9VbFZORkJoOWs4SHJOUTROQlgx?=
 =?utf-8?B?eC9KNXZWUXIzN21vMHdXb21xQ0ljUVlpMEJkOEdPSFZEWnZkS3k2ZXZXT2h2?=
 =?utf-8?B?R01sWURoS1ErR3NHd3VUYXB1U1l1VWNKQVlNSHh3SEJwS2VMaytpMEUxYnJ6?=
 =?utf-8?B?ME8vZEhwdnVadnUvckVEaVRlSTBxc2dKRVpwRUZqMjVaSERPd3Y3OXNNakFw?=
 =?utf-8?B?OXNFV3JaaGVnSENGelhudGpaN2tMQTlwckFTUXNNbkFNMzA1ci8xTlhwWTg0?=
 =?utf-8?B?VzVTcVpCNkFuc0oyTklaVFV0ZEJpa0tZTk1ZaTRvK1NpeTNUYmtNYStYZ1VU?=
 =?utf-8?B?cjdyUko1Ty91MXlNYkM1bHNJRHNEdmp2MWVkRlZnZnhKRjdlSUdYSzBic3g3?=
 =?utf-8?B?bktsRjhTVmhPUnE5NjNYdHVNNTcrcXdtdG16SEI0QU91MDhoUFluU3RCWUd2?=
 =?utf-8?B?SXlkcFdQdUZ2NURscFJNbGIyZStOR2xYTXk4bWJXT0RQTW5kc3R3UmVsSjlU?=
 =?utf-8?B?ZWRrNVl5RmJiQUV6TmlZSnh6aWYwdlA0cWJwRm80UkdWdG9jTXJVczM5Qnhm?=
 =?utf-8?B?N1VGa3ZlV0xjalU3YUFWQ2lMcFBCaWZuWmw3aXZnZVdhbE16TmFBdi9CN2Nv?=
 =?utf-8?B?MS8xdzY0YUl4dm1JN3FZd2hTTHl3aHdGUnkzWDg2SWN6T3c3NlU0cksyeXFx?=
 =?utf-8?B?ZEI0VytpV01icC9KYnJveVdjdWR1cGZVNzA5VXVVMHFHeW1BR2FJdGJmS2Z6?=
 =?utf-8?B?bERjMERua05peW1vYWtZb0VmS0dJaW9XZGpzdXVGbXRCbFpwZjhYaDJ5dGNB?=
 =?utf-8?B?TjBRS0VVdVhpbkd3eEgyYUdhUDlCTlo4UDgvMG1jSTNyVkxoSCt3MWwwUUxD?=
 =?utf-8?B?RXQzSG1WT3hMTS83elRkbk95QVBpdlBsdlZZeWU2MmpUcE0zQ0FtazdwRGF2?=
 =?utf-8?B?eWpWaFp2d2RIY1k1VUJBWUp6bkt6NTBGSXFhSDZ6bmQvcEsvRThNOGN1K3lM?=
 =?utf-8?B?UHJYb3VObno2eUY3QnM4TS9yaEw5UGZzbGhNeldWU2tCbzQ1SlV2c0o3bHRR?=
 =?utf-8?B?ZkxtQUNTTDdqSVZCU2gzUlBSYi9ZNUxXSFFOSHIyQVJHZy9xNnhIREVYb0FO?=
 =?utf-8?B?aktTb1p5RkFPcUNvOWR4ODVwbXF3ZHViYThKNERpYjc4cUl0SjdqL2FYbzdF?=
 =?utf-8?B?bGhtYlpKSkVqMzBjd2tyWnpEeDRsNm1yL1h6MTJ2RmxXV05ROGNaV0ZVTlVz?=
 =?utf-8?B?TDdIWjlYUVdlQTlObGVHRjBNb0c1b3NHU2ZSUGJmV0M3emtWUHY2NTl2TFQ4?=
 =?utf-8?B?OEtqazhMMjVXU2lnV045TG5ZZUpOOFdNUVJRMlBZa1NqOHpkRGtjVXNyZlJY?=
 =?utf-8?B?eWliTkFla3NMZVF2RVJPUFVpaEdpSlZqWSt0OEpsRjNsMzFTKzJQMHhaczRz?=
 =?utf-8?B?S091aW85U0k1WWxHR0UxYUN6NDJENG5CTHVsRkkveDBYTjRLayswRGdzY3I1?=
 =?utf-8?B?aFVoOWRxdUt4aXk0SUZ4Tk1yRG02ZlNKTFFZM1F3RHpOdGs3ZEJ0S3hoOFJv?=
 =?utf-8?B?L0VWOHNSNGFLR2hxdk9NclFMZmRHOVc3VHNpZDNQSERlVzNrbVgyZXlyTHE4?=
 =?utf-8?B?aVhBbzR5TkNlSWpTUUEySllobkx4bm5vKzd3U0psRllnb0lsREVTZHF3N3I3?=
 =?utf-8?B?NzJwaENYNW5ZUVNYZmpWclBqSm1ITERHTlo0SS9NR2RGQll1c3JENlV0NTNo?=
 =?utf-8?Q?i00Iu9BIOZKsAivfo8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10b2ae2-1b6a-4daf-e1e1-08ded9135e68
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:57:14.5951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DUT+eDuZRyiPLIazIu08EN0AIBP5zkIXPh74QDUu8zEOocw0t6b7drxouanWOYhy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D882D40009
X-Rspam-User: 
X-Stat-Signature: 7h8sgngprhks7hbduam1ab9f5rg3w5rp
X-HE-Tag: 1783090641-453659
X-HE-Meta: U2FsdGVkX19O5nrEjBjjqmaVW4+tvtGSJ4AA0fCt2CY1m4NQbKbSIkMA6hQZE1Jt+oxdi8fTfx1I6anSs08TONkStvyEsVX9O2HwVBoAm6qr+QDAGcjdeJln8q8CqTtKE8FV/RqWZDHhHh5EYsAqfFyUsrmH386tAE+29Hi7lakv9kw0YjR3++6xJKW2w5UJXAwaqas4YR4LGderZ0Ssd5z32K4hMCE/OMZBFJ8NDNvXZRJS74jQWajox/e2Fz3pWQsei0Q0Z+ctBUPJDKTHGIxpQlnXF3AoQr5a4RXayDvkPDEGVaUX84sYxueEWL3dw90A7tx24C3yHqqliYa+gu+1On6e4elmTbLftA5FI3XtCZZo5NCgG9teRhRkb53K2LI1yBxTaRysemITLX4EDKoxf/ht0yFEhb4uBPoq6SqMgNKfbFObD9FItjlGUEwYSU/hzinfT9daKpGCimvKPQJ/DuDi8R2hNqzI7MqEWQ5TE1kLzVFoJfdi18NTK4c8kq57+QFlGQdMDdabw1L+BW/2CBS3TqYkuQTb1TpPGAg1dnUKDqEebiUsRifxQ1bUDmpAt69QAwzGtHywT6tvJ4ZAfZuA8/93Tk1VVkbySuV+fCwBNRnSrvAv4EiTDRUxNnbC8dmQLfR9tlkuet09QEpyTzFidKlRw3EE3HBHPNukwB83aXmbwxYxb3i+cOy5EbWH89RxCaXUH+6kaZOyPS4YqS7JCcVuiIbJR7w4wl7ryfMWjFSa3fCokAnYSyXZ5mc+Et/NJcWq0qHAq2VruMaOSQgl+AC+dDRw1iaT2g6OJxgSXtn8lieAwaTf3tA/Bo//Gi8ZMfNCCBS0I4y7hlH3MvslLttL6DkkuafoYJSc4PxSc7y+uiB89FPA+dDTAgh6kTlk1aNkQxUCWzKSqQTtFYjCHZ3R0ZdfFXSVmOWzg+SExYc6qZju1FpXRV4TTmmPi3oGmUxRl7Mh4hR
 8f/V3jry
 4scverNKZZSgKwV0bsKgzCtjM1r8jEwb5BonuwhzfEssm81zYchBgzaGtJPaUYkPs5j8FsjsUMEi0YpCFoU2Zc67wLp2bqvpKtjlr/9vxABjYBY8sBlXboZkaOW1J4D/v+TnmSMXc+1qTfEnFD3hesgfdE7HL2Z4OEOJpIUvTIGCHzf/A3cA20akq1Sn8SVZPjD49qt6HXR9E2W/yiEQrEPpd6NZIQCCSKgO4ROfxlKCqykcj3P9rKpE0WYO8JraaC8d95KMlsHPWij3FLvh/czwT+rIKmM2HQvVLY3GzrHyxgcoEAzI1QmhXE/ABJ0OLIaupoLZsVWiTTs6f6FrVkBVnCz2H+QPQp4E8iaykas5w0SMuGZN4OrvoX82iPn/+u18NXisM0uKwy9MDbS//NH4r0bk1gYraz/gw7epINpEHhGpqu8b5MoJgT7j5vA/myBRe4JI6oEyQV7N+ZlfTrmOgKXrhI5keFzKWpDWKQ3iOG4XUI+iwhclDqdJqTzw61tC2RrxvY4/cqFCbsJ9420G530/w42ZmxZsSaiEytRiXVBwm1EuBqCpyi7PB425YIqLN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> There were only a few users, which have been removed. The only advantage
> of this API over alloc_pages_node() is avoiding a single conditional
> branch. The disadvantages are:
>
> 1. More API surface, more sources of confusion, more maintenance.
>
> 2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
>    were using the result of cpu_to_node(); if the CPU gets hotplugged
>    out this will return NUMA_NO_NODE. If one of these paths fails to
>    protect against a concurrent hotplug then page_alloc.c will use
>    NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
>    memory corruption or other. With alloc_pages_node(), the code might
>    just work fine.
>
> Ulterior motive: this frees up the __* variants of the allocator APIs to
> serve specifically for use as mm-internal API.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/gfp.h | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 01d6d2591f49e..3bf55a5f9143e 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this_nod=
e, gfp_t gfp_mask)
>  	dump_stack();
>  }
> =20
> -/*
> - * Allocate pages, preferring the node given as nid. The node must be va=
lid and
> - * online. For more general interface, see alloc_pages_node().
> - */
> -static inline struct page *
> -__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
> -{
> -	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
> -	warn_if_node_offline(nid, gfp_mask);
> -
> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> -}
> -
> -#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(=
__VA_ARGS__))
> -
>  static inline
>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, i=
nt nid)
>  {
> @@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_noprof(i=
nt nid, gfp_t gfp_mask,
>  	if (nid =3D=3D NUMA_NO_NODE)
>  		nid =3D numa_mem_id();
> =20
> -	return __alloc_pages_node_noprof(nid, gfp_mask, order);
> +	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);

Could this become a VM_WARN_ON?

Anyway,
Reviewed-by: Zi Yan <ziy@nvidia.com>

> +	warn_if_node_offline(nid, gfp_mask);
> +
> +	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
>  }
> =20
>  #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__V=
A_ARGS__))




--=20
Best Regards,
Yan, Zi


