Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84498C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784256B00DD; Fri,  3 Jul 2026 10:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A656B00DE; Fri,  3 Jul 2026 10:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6490A6B00DF; Fri,  3 Jul 2026 10:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 384856B00DD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:51:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C21AC167375
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:51:18 +0000 (UTC)
X-FDA: 84947753436.07.FF9D37C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2225180004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:51:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mwrdYg0n;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783090276;
	b=2f+rxqV0yhK4gzWMSckghAoP6AwhcTI/Fh5ViowtztHaZdp0WBmkEEroZDrcB+W0vFa/Xg
	uwwJESAc7YU+0Y9Hdu4G1x/FZGUPJR2yVwavHDIyCYm883AjJWzf736b7qllPJJhsuPleT
	6mLdHanEDwl2N7HQzeUT0oY9dGYXTwA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=536uoPkVfSNVMXY+Zcfqr/ev0JHCMwC07/KjanhsN3k=;
	b=p/jFHLi2V2GVx5efxk9iD+7+CBCw30prWqYP8YgkrNcBbECUGNY8sADMwNfKssx9YdITLO
	wRft8Q5IRutM3Q8+Jw1XmFHhiaGTH2XhRM3P1H7gM3Cz/ddSyFVxAS+6/GpLD5Ff/MDoRl
	smWoOnQhM1b6D5WYnNl70iKAGe6hV2E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mwrdYg0n;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEGZkLvtrHLqIzcLeGs1Csq08Yu0ujJUvXKZ3qI8jnkF///pjKrNJpb/S4eJZhugCR2umA4ZWi06FVSCePDbAMgMI+LV5+9FzAt01jFZLTFh6Cfdl9Y6Y/sLyyXLTLRgjCROQv43tR9JFMPiX4uRkGMqsb+Na44UBxtOTrlUTmJk73cT2QCX3DXOA/KKLT0WZy4OaxMLJNO86KuIjDtnAvi0bc+pKB7PGrAmeC4O2iL0rfcEfgesydbjx3h7dKD4m3J1visMU6+/4dSFG4I1TbGc7j4TbB3nNR4mM16c4DpDJaxHMssP2uZMwiyY6eFddbr+IzugSzg77RwpXX2AXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=536uoPkVfSNVMXY+Zcfqr/ev0JHCMwC07/KjanhsN3k=;
 b=wZF1HIZd82phHJeDTIVjpzSCkpmjRksH0PY83o6N8M4Nk9xm7GEBbaypHVvxQ0S+ZC/SwASYFUp1F0Nz8DBL6M1LmfFG24o21VxpX6ZkT06A9LNGflpzmsMjz7rYYfZ58PuyUrEyTANZWvMJ5zRO0FfTHNBJ1QmiA5WerFLjnWcVDfCkXMUUlbSPVuapSvMXm4kCqK92LRCOm4rMbbgCcQt+AwNnEJb45wApFc65FCkYLtnRBtn4UgHZjiMA7ueKWbyZXeNh3Wh6jaZOmZiy/6IJXzLf//HH1fy6Prwq7Bq04PPHj5SyJ3vPDa1uaR5CN6J/yDkjs1Ve9gRfhm4j2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=536uoPkVfSNVMXY+Zcfqr/ev0JHCMwC07/KjanhsN3k=;
 b=mwrdYg0ngnvp+ySQ0LlAEcy7PX2JmtnodevaGeKjvmzbVXKeWZ9zyy45b2EMYZI5iQxgF+SxglAETLmJ3c51JY8w5xj/9WAAM7dZda03PGgh4D5HaAp9M2rcItxb01C+I1PZvJV7+0CbR1i5vk9bLQyax1HriomQ0jtjwPdgnwrP70i/TuO41eM1EoH2XtRBCXsMkZOPz3oiOXYmWgh9lOpsGfDn90ERPN0zhFZ9OSHUZ+V18HVTkDl58PTaZUCZgYCMuyQt3AawOBtWLRlcT+tKXZ0UVPDHnr1Kx58pP3oezK8NlTIfSZYNNzXV7Cf37Jp+exAvbG+bPPSeBLDfPg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:51:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:51:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:51:07 -0400
Message-Id: <DJP0QWQWPSQD.2RQJ3SDQUQ35R@nvidia.com>
Subject: Re: [PATCH v5 11/18] sgi-xp: Use higher-level allocator API
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>, "Robin Holt"
 <robinmholt@gmail.com>, "Steve Wahl" <steve.wahl@hpe.com>, "Arnd Bergmann"
 <arnd@arndb.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
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
 <20260703-alloc-trylock-v5-11-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-11-c87b714e19d3@google.com>
X-ClientProxiedBy: CH0PR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:610:b2::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d1fe0d-3237-4e3f-b154-08ded9128577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|921020|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	dYA0FlLxIeNKn/Yt4VVelI/B2/czJyRmwD/rwBbCoB2IXElaXtCf5lgVBlhRiMy0mN4MG1/ZIcw/jAozwaioGCVnWms1ThmS7aY8utm/AyM96yyEdhWSlXFU9rL3biJiwlsAc3/uF3oJCxAJlR2UBIYn31GdmWXFCd2ZTR5q3QSMt+hGr4YQ03pur+92cvvI4UQRTpZBIg542bo9aw+fl18XtbB+3GBGb5eOME8n/77Oh4HRYi5FcBnr78nlqm69SW1MHAL1zzHnChW5MfvPApXUyfnofEN2slgV0A/WtmjiSW9/zppk95dQZ2FvpCi06AUGLrucH0+h1nUPcomofwsTcsFgJBlHICrfL9ruwhHjb4OiI/k0GM3JSoI6iEtRv/aheV+01rOd5i4riu9OZK8vWEahc/Z0mRZFhBwV+q2v8D4TaWbiDNy8hO1WoaemwZOZGRZox+vet6bDVNXWYkUp7vJUIY1KK6dAextCtLgywfSZmyHWYfGvXiSuNf78+d+/cCHJyn1rtgcDWa8hsMH2msl7s2YdiBv4KeLdpttMYIdCG/Jmfnf1HnJISzzfJdM2hxla/kjBh1xUOGL5QJUuHcnrjxJC/xGjE5iqM8/lagkOPkY/yRavVpwnVCWApsaWpRZkYnUlNB3+j7+GNXNy55+Nvn5pHd8cisUah6WLxv0CHirPLK2rObU+oeDusCIlrhVoGUGv82Y8tPCHLQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(921020)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWM4ZUt0ZWdnTEJpekp2akpUMnJZQ05zc2NwQitoY3FWeWdzS3oxelExWE1l?=
 =?utf-8?B?OHpGQ0VQUFVRK1Y4cStKa242SndZc2lzTjJQczBmaVRTbVk2Y0tjUVFiR0Q1?=
 =?utf-8?B?WWhKckJ0V2VqOFpJTnljWHlRWVJINzBlQnI4bUl3VE4zeHFGVkplRm5TQVdC?=
 =?utf-8?B?SDhVWWp1TmMrbnhRdW8zR1l3WE5mUXBjT1NjYkdJOUpEYjJJelgrTlQzM3da?=
 =?utf-8?B?U3BzWnBXYnl2Zkg0RTR6OFMxUXlNdmRFRjBZNHJRMnZ5YjZMWitMaHZ4RmNH?=
 =?utf-8?B?TDgvb1hmeitZbU56cXUrSjFtb3I4bEh4b1JxY0hPYjY1dGdCYkFPYUxDcGk3?=
 =?utf-8?B?d3I1YkxzcUtMeFZRWFAxLzlUWmFEeG9hSFVJcjJrNWI1WUJiclR5Y1QyM0t0?=
 =?utf-8?B?c1IwL2dQWnkrWTFyQnNZRHN0WWVlR2d1UDQ5KzV3c0lSUmpib0ZadmoyeWZC?=
 =?utf-8?B?cDJVc3hEa1BzMjcvVjBTK1ZaUW40UitNUHJKMUxoK2Q1U2VhLzUyVEdzYVNE?=
 =?utf-8?B?NGhpT0ZmQjkxcUk1NWZTeFhxS0VNNitya1FDY09pQjVDZk9mSG9qbWhEcWFF?=
 =?utf-8?B?QXRCU3RVWEIzOUwycnBuSloxaVdEbHNhb2V2NFUyUTUzZ3ovaEg1Q1IrYlVD?=
 =?utf-8?B?ODhCcFk5K29mTGdwMENsTTd4VnE5N05FYTFDYXBRRWpoUWwxRE5iMnkrVklU?=
 =?utf-8?B?VER5eWR6d0V3YTR4TFVYYVdUbldLS014ZWZHUjFOeW8wbXpuTlFIME1ucWNo?=
 =?utf-8?B?U2hkeU1JRkRZaXJ0MEh3QjkzVlNKRUFHakN2czh5SUVxaFdpMDREeEpGUTZk?=
 =?utf-8?B?YUhQK2tyRTR0U3NUMUdZaXkyM1ZnSFFhcHJBUnc5emJ0cTEvQjlGcjZTaGY2?=
 =?utf-8?B?UnQyemh0d2dJNUorK00zajdwZDU0Rkp5VGFNMCtQd3Y4UUkzdmVCQW9GYjMw?=
 =?utf-8?B?aldHbkYyZWhTOXhJVk4xamgzcmtZTnRMK3M3YWdDZ1dNK0g5b2ZUVUxDNlVq?=
 =?utf-8?B?TEFjQ212N2xoVXhSZTlIekZzakphTmdoK3BTRGZBUFY1dllVTjlpejZRSHVU?=
 =?utf-8?B?dEI2Q3N0TDRJTDBMZ0lKMzNRVGJ5cGlVcWlwK0U3UHBNSjEwYW5tY1gxODc2?=
 =?utf-8?B?QWY3Y2UzTUszU2FnZkcrS0xVK0JDQk1adkt1dTQ4d0VWc0x0ZGFnQVg3Yi90?=
 =?utf-8?B?TkVNRnYyaGlteVFDdHU4czJnMU5hUFJaaE9UUXFnQWVUUTlOcmdWUEpFVlpn?=
 =?utf-8?B?RERUaU1Qa1JvSEVzWFJjRDZhVHFsWDFVV2lkNCtoRklUOVZIUm4wRGxML3Jn?=
 =?utf-8?B?RThhL2xJS2s3K1Bzb0haZU1yMGdZR3ZmQmNROUpBOUdtdk1LZ2hqcG1CaHp3?=
 =?utf-8?B?OTB0TG93SStSVFZQR3p2R1ltVEkvZXhoMm05VU8xUnVqcHRubjEyTGJKdVRE?=
 =?utf-8?B?U09PY21iK2MvYmRNL0dIL0pEZHc3dExRZW0wdnVLa0IvaHVBOXJiNGF6NFM3?=
 =?utf-8?B?dFVwdzRQMTdvWUErYWFDQTJ0d2hZYmE4RXlHVEFHZzNrczVsOVNmY1kzK2lH?=
 =?utf-8?B?OFBlbzRJZnAxTU10NmZ4SWNBTUhZSmsvdUhCRUJMekZtTTVwMTBRWjN3bERy?=
 =?utf-8?B?N3M5ZkRzWEpNWFBZWDBCUGlWNnZrcWRNSktnZkdVYUpWV0h5elI0OGY5Z1kz?=
 =?utf-8?B?NFpWWlNZRjJCUjB2NzZxbHRpeHVYRThqVUExRHdzSzUvUXdiaDFINEhhOGdo?=
 =?utf-8?B?OGV3UXQ3bXZQVTZpWE9Wdk5JcWhzNUYzQ2lVanA4ZXJhSVBzdVlIT1I3TjNt?=
 =?utf-8?B?OCtvM0M3aVBiVXkyOTE3cHZ3ZmRUMmdRWVhMbjF0Ri90VURZQkRMUXR5OUZm?=
 =?utf-8?B?b1BwbFhZd1Y5TzVKVlYya1NHS3BoNThBaEViSjcySE5KaDdVTGNuMytZdE9o?=
 =?utf-8?B?dXZCQzlFVVZkVEVjS1d4ZXNFZVlPem9kUk9iSGV6bVM1STFITXJXUGV5SGVZ?=
 =?utf-8?B?enJSWHBWb2k1L2Q0aGhSNzIySzRTVTBoZEd6YVNwUFpoZk5SWE5TYThmS1Mv?=
 =?utf-8?B?eHNhclBzK3gyYUg4bjkwTlRudVdsdFR5aUxkMTF6MkExVnUvNGUrY01nN1JL?=
 =?utf-8?B?YkRreHJ0eGJhNGxOYld5K25ZemtFYUJsZEJjbGphL2JpV2VhUkhKV0lKaWxF?=
 =?utf-8?B?ODlRYUZzQXRlSHBFMTQrMVpWZ2dtVDVoK1dsYVkwRFlEMmZjNXBRT0hRRVNy?=
 =?utf-8?B?WlR5dy93TjRoTDlNZG9IVzFZcnNtQ2liSWUrd2ZHRDFJSDdESVVPUjN6eW9M?=
 =?utf-8?Q?BzkHrIt1pv48gmYa9z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d1fe0d-3237-4e3f-b154-08ded9128577
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:51:10.6392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFhRAFq++Q7/5yUoBggwjQfAZPCVfyWY2lMghJlbvowtX/O11o0RvjRM6m47o3uv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E2225180004
X-Stat-Signature: 8x9ixthdkyy53c1go8myqwrnon5uftij
X-Rspam-User: 
X-HE-Tag: 1783090275-8743
X-HE-Meta: U2FsdGVkX195MzLXtQXaijWL4X2AKuTrGdaxq5Uk/6eiMVRugLuxsEEdol05N6VhOfp0g6H9FYNb/caBRp292M5hD4EpMf11NcDKieEcb8OGO4Ws17dRxnBXaOoO1EuoVhS+Rm7rxB/wOIca94GctYkQHTZnJoRdZFoaKWjiapI2boJN+RAWTKzV3za7OTDS05uZcmxIBceGcqAHf/Z761pdRaIO0Sembb59jOtHIjyniqwaB5jGrW9SnfDNoq/PpU64RpnizV2kpVWT2zvLpBwFnAExQLNoJlqDjGTRkPhYvdB26zuRTs7Jn+EXVVaeQnOY6VZUTvqKN7jCqD3X7R7bWy5ZkHTteoC0dpVuqTLW/bF+Fq2bN3hvRsRvQYOLIRyTLgEju1AYsZcI0HzXzpW07TxcaGsmNq97CZcyNFVCjFl/WdBWxfi5N1+0l2UxXpIZ/e8ZP2ROs1cbSAxgIjSoj/i6URJ6/oDMikS02hkCIJxeSRfoSSVlWvzYiilNYPBYrjunXTZ599vaq8RiIbf1zR0JZGg5kZG5c/MPSnKl6kfVie38pbSdcO4NeuAV1PKJpZHWWgLJbHpElk9/Xfx4+krKw8mTnKPkvDU6dzQ3qiN+uNBEdup3atZFgInzRNMDD8EJMbkRYXsmDBaCyuZ56xvP3kEGzViXJRGQ6uTTGN90ckB0JPogUiJhoyAWS7D6bLB5f20bRzqEc9MmXuXJZ+gcMi29/s1vq1QkbPjitOCUzHhxS+XnK1hasOVBq0tzfEzKPnU7DriZkl2Nog7NKPkizrgUezSLQ1PgUozHttNzclSGQosMsEKbkr2UKQ0bCubbEgAqTFDu75Sclh0kQKGkQw2+36NVWbQrsDqqzDHUSmXVfU4gtA3yQERo6SciqWAqMw2dGi3shuc7USOPtutb9BEVRR01+Sb2VP8pIqPiwWRcI6qRX5mP2l0nVZtS1cEJFAAcMsPn6I0
 in9GOhdk
 Mi/FcB++ASMXmTn/9LWx6ofWK6sQ1SwopND5JrmmJvgkhnSA/5+7nxHJGVUoGd4RqDzk8mfFO4NKj0g5Ry6GTtPiMvvJsIHwIfYqihi5IrRJQyH3WcRjw2dhhu0XF3WWmTJlyXMGtRtxFRltcFS3r4C8pAUceAQUaXug6ssy+kQUnw1RI5Q6eO43lKL4vD3VVMy2VszdqxbmyQcMQl34JIVHnstUMer9WW0eZuieDWAsxFRXdoDSO5MW1GajNHF6sEzqhHCtoIzXLp4hBaVRoLn4pZ64LGiGaN63AZYU9+0TNr4Qbk3ctrUVCEs7Rcxv+jT7/ncq91EFAMt3/jVE0XfV0bOY8zXsSKksALdIplsY5jsFYYJVh98mkLPZD4bwikVwZCz0tNjuFYtQ3yAQoC26fNlz8pBrEx+tbZFg+K+a0qQQp3roZk7W4IrCqEhTWtMa738Me/sIC2xlFBA3zzBnrLCK/cnhF8CSmTuyVvCYigkPJf/ft/qPMIND90aIk0Ef+euwLtAktWLz7gShVL9SvDw5pohg1TcEer1apRNPqNZQUclY8gojSjDCuaN+4n+B2SQ+JHzr9sGd2KT9gVq/bSo9ZBzxikcCwl2g7+Y0KUgJP7q2gCI2XVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
>
> The former is going away and the latter works fine here so switch over.
>
> No functional change intended.
>
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Assisted-by: Gemini:unknown-model
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Steve Wahl <steve.wahl@hpe.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  drivers/misc/sgi-xp/xpc_uv.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


