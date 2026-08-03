Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130DDC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F414A6B0099; Mon,  3 Aug 2026 11:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17F76B009B; Mon,  3 Aug 2026 11:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E079A6B009D; Mon,  3 Aug 2026 11:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4E7A6B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:34:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37ACFA1B94
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:34:48 +0000 (UTC)
X-FDA: 85060355856.14.290FAB9
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012039.outbound.protection.outlook.com [52.101.48.39])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FA131C000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:34:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ts8X9Y7S;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785771285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivloSloBsPfVSxHQcNFVB1STj59t6hZ3rSk67HO8O54=;
	b=5eB1wA++TzZzpp1Qve+QrwntavGopmTfyfv+GwoQYH+zTked936u1ukk3pQzNmkGUqdGQf
	fVqTrAVqCiwwR/4zQiw5Hv0NhRuK2wUUNTeNakyd03M90e+60ioZYE68LoQcaIndnQCAdz
	ZgrbR8i2/NkWH+uqE8Nx9sWLv9vbwfk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785771285;
	b=zAWA7glzyqWTs2SWepxhUOBHbEUzLwscfqHxRUA+eqpRsB1Ibj7l6KpKjp3PJbeT8Jxndg
	En7KxL1Mn5ixPNMRUFZ5B8LlpTDNaG/TH8ausc4oOA7V9Bc5EsjNhpN4NRArI83+fQ+s9K
	w/CFX2TjQXFCDP2SsxuD6mgX43TS0QQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ts8X9Y7S;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEI/Mxb8+DCg5cmS0hna1VjEdcL/sj3/x4izPJvjyO3JbtG4FaaoY+dyreezDr6QQlpYAipWNN7ReM3hmmi4t0la7egpfxkkDG9MNMdgIWkAXf59RNnKWhfhMkRbSB4b80Kqe1egGS7+wt2h3NjTsqvCJReaQixpVsbxt20gACc+w22UHvyZTlrQOH8xc5wBoRenN1S4evoiuF2aW5JYzeijGWZaA9cQx56aa6iYZXxIH4GLzcsOnQeFuFci2ktSo04GyOZHzCkHT2tB46ttmwaBmbcjf+uc22a317dC6WJSy3LsSAsSgYXgbOc6mpOzvRLQfM81wxaprXLjxwChGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivloSloBsPfVSxHQcNFVB1STj59t6hZ3rSk67HO8O54=;
 b=cgx9O7QgWaByDwKBC2V9S3jG5gohdCN3hzDkzaGaPk5GrfKNC9lOHq81MGPOC+LYjfxU5HAbvHnlACpXsyl4Ajzmz5+1gZCn85WAAozdpyr1ZLWRXPrOH94GrDkQHGC0FVdZq80kwZUKASJk5LQACttKE2hNQEWGIb9UTUvS8qGtZDE4xcddIMwi/MjqTQ5WYtQhOhn0zOIFmF5wUMCL9jVUzZKWIpegR6wpD1uZUVOwEsIloX1t80+dRQr2AWjjMKZ4C8OrMWFWhfV5l/lgVKRLvVgtFpyLDtWC0RHW+pSv4So6UshtSJoKRvqcJ1eM+9MplvHZSiI87mjmbwDVVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivloSloBsPfVSxHQcNFVB1STj59t6hZ3rSk67HO8O54=;
 b=Ts8X9Y7S++w0upZcdMrEussGHlQMCBsFGc4H4Kvy5kyZSo7MT77pd/u/wAnGhgt/mJaNmWWemZA/yEJSYyMlp0bStcMzkk3qiU5EynWjq62kDEh0q6+TcWWZHVr/JsQdkl/vMKkGimUGAC+G+g4rdwf5ACaw8SXD7T0gM2cM96jCgQMoxeMYZrOqd283/6QzyCejdXMjJrCAUoykn8XBJlqtOrMPsk13c9lN18QoZN6ntkTGjA2fm+EK9Dd7kp3vhn/aCk83M94bNofDfj60nrM8WEEYKZj7L6rYT9pcb0PrAIu+pAZ1cpZEJPwHKN3M3WHqUXlYm2NrAWh9QYI2Ug==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CHAPR12MB999224.namprd12.prod.outlook.com (2603:10b6:610:302::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 15:34:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 15:34:37 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 11:34:35 -0400
Message-Id: <DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
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
 <minchan@kernel.org>, "Sergey Senozhatsky" <senozhatsky@chromium.org>
To: "Johannes Weiner" <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <anCuGbQ_-pTajAed@cmpxchg.org>
In-Reply-To: <anCuGbQ_-pTajAed@cmpxchg.org>
X-ClientProxiedBy: MN2PR20CA0038.namprd20.prod.outlook.com
 (2603:10b6:208:235::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CHAPR12MB999224:EE_
X-MS-Office365-Filtering-Correlation-Id: 944a8050-9975-42b5-802e-08def174b9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|4143699003|11063799006|5023799004|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mkWuVfgZmIk4bf7Kyv02TdjWybujH9kag5c96OyaWQtiwSw+lskNadeysybtVqMf+0I4InoL/KvlFeBubL+9797RzGKsahbIjgPfHo7s1xcWsg4QA9Be4GOgDT50nCvoQ+7/HGhQOhBlDTvuYyIXDPQajCAjqprJONtisrTJ1lGpkwynM81v7NJ6RgSKuvsxLPBi3vv5f0m3BiQdJFGqfX5lHs76nKqhNFRI9M3snyBEYNY+VS4hcPdJWDInAcf1WHXAJcqtdlg/4+c///CK00IFIPmuFpwuHah6oiI6myVBfpiVUVoXe8z1wPKW7XCcohBGK/s95nBzHO1BLrKky1rs/15JakjcGhu+HqhUe+FKJsydYxOEU7XFn11RDFPizgeFLErT2d9+jrKg75biqxKuydggCYK0AW8v4fT/E52qrydyAr6xl7ZVN+9rH10pafJRhtqJCbDOoZOMmZG3AU1MwlQpmuj7OhiaawfZnMcIczevSNyu73GbF9bqdvX2xRB+oA7xKkZlAnXTNKYBbOgZSq85hqwBut7NqPZE1obu7iqDjynmaPnEMzG9oXjEaBtVanHlf6uGpbjIBlir5p9+3Nhn0xqd5E06ebqYQHdTPEec/kZQMdOL1TTR5mnAFQhK5D9X4Czxh6YBO3BxSBZc0TFQdsyaxe4UHJJbZhk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(4143699003)(11063799006)(5023799004)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDNQN2x2eGF5bzB0TWt3L1BVZCtrbXdaRjZ6cURyVXgyam9memF0ZmFVcGJM?=
 =?utf-8?B?clV5Q3h5ZS8yZ3Fwd3pIZUdNSmF4UkNNTk9RaHIrY3h0NlFBWHNJTlpyblJt?=
 =?utf-8?B?TzlndFBzNlpBSHNJb2RGM1poOXVYZDRGR2RxYzgvcVZkQ0F4azNXRDNFWllN?=
 =?utf-8?B?d2VSQkNqK1NrWWlEa3E0Qk5VOS9WTVZNcGVRZUFFVEg5OXJHYWc2ays1Y1Bq?=
 =?utf-8?B?S0xtWEszcVh0VkpoYlVhVzlyb0NMeFpVbERwVW0wZG9TMWt4QitqMUpQNzdy?=
 =?utf-8?B?YXZWV2dsY1BHOGFQWkViRTYwN09Oa0YwU2c5MzJwTFZkSFNKUzk1SG9XZEw0?=
 =?utf-8?B?emdEMlVWSktZaFFwQm9UNDZ5aXZzSVMrNEloby9vaCszUUtTTkNiQS9MVVo4?=
 =?utf-8?B?UVYvS0gzeTM0Vk93Y1puTGRzR09UTU9tM3BIZmtNRjMvYWR6cEQrQ21Wdjdi?=
 =?utf-8?B?eHVFQWIxZnZuUWswNjFPY0tvT0Yzc1FUVHdVV3hoM3ZxZHdmT1BrTFJ3WmtM?=
 =?utf-8?B?dmYzMFBPbmd6N252QklYNWdpYU1CczVrWTFnaWh5QWdoMmFPME5KNVJ0L0JZ?=
 =?utf-8?B?ZW5OeUdFVDZQN25vZC9xMjNrK0NZK3lNMkJyajdsL2dMNlpsUmJNK3FCc1BD?=
 =?utf-8?B?QnM4cnloVGpCeTc1SkQ3SkgzTEU5R3dYN1lSV3dmVzZ6RkR0UCtFcmVLdXdv?=
 =?utf-8?B?WEpucGRObFVNMjV5TnNMUWpoY3B3OTZrcmp3T3FUMXBkM0RYZFJFL0tFOStk?=
 =?utf-8?B?aTM1RjBtTFMrL0p5L0JZU1dGY2pOU21QcUtxQWxVVmFRU3pVNnVQb1hmSGRa?=
 =?utf-8?B?b2R3SThBa2JDVTVZKytpUHh3clFqMmRLUDZnbElpS25JRzFqUHFFUUZPNzRh?=
 =?utf-8?B?Rmttck1tSHhuc0ZBc0k1OGZJakJpemFzNkJORVZVTy9yYkJLZis2VlJPOWYx?=
 =?utf-8?B?d2FYZ05LVzBPT05Hb0dLLzZ0VnFHUVFMOTNYeUwwanhpS0UvNm1OcFZhL3dE?=
 =?utf-8?B?Y0VxVXM1a1hZTHU5dmUzVjBaRjJYMkJjMCtOQVNBbGh3SllQU0tQWWE1L0xw?=
 =?utf-8?B?eDlTVUEzQUx3RytGb3ZTY0dteHlTUUhQSWkveEdpYTFsTWFIVmF6MGxDc2hx?=
 =?utf-8?B?T09EUHhHS1VVMGFSRUFvbFNTL21PVlNBaEljYnVnUmwzMnhTbVpOTm5EUktn?=
 =?utf-8?B?clN3THlLQVlNM1c0aGErWGtJVlhPcnBERDZ2V1BGVWxPK1M5NGlzOXVoZ01U?=
 =?utf-8?B?ZFhmdnBzd2h4Q1pkYXMwNHJJSmJLaFRsTWQwV2tuUmhPSXphZW9TdHRaQVFM?=
 =?utf-8?B?a1dvM0c5TkFBeGhqdFVheFZtZjRYY0lBcWVvTmZ2cGY0c0FTUjNwWFkvSEVW?=
 =?utf-8?B?VkRyNGNqWG1aRTFFOTEwUldLdWlManlpVjFZSEpGUVd2dW14dlV1N1o0eFE0?=
 =?utf-8?B?OHlLcmk0b3puZTh5ekVNMlpkMVJ5Q2hDT09zOHpLQnYwMnF2bUtFMVBtYzds?=
 =?utf-8?B?dmh3Z0xVUTBoTEV2K3BIZzVQSzVsTzlkdmRNakhSRGhabzh5azh1ak9TcGlu?=
 =?utf-8?B?cmE1UTdUT2FoZzgwTS9mdUVwczkrUVdlTFlubjVzK0x5dGkyN3k5MFgxOCtG?=
 =?utf-8?B?UVpZUkpBamk0Y0lhNTFUWnRwT2t5M25NUW5Zb0dhQWFjK3VKcTAwQi96QkM0?=
 =?utf-8?B?YVdsb0plblBTT21KTDZibFhJSGNaQU1zYk5OYmdPbE04N1EyOXFOL2p4TnBz?=
 =?utf-8?B?dFhDVE5oTi93cE93TFdSVWJaVFZ0MnRnNUVTZWFIM0hPamdpUnB5M3hQSVBw?=
 =?utf-8?B?Wmh5NlVPQUtza25SWE1IZmVSRTUyM2VoTEN5WjNaRTNyeE5rbTN1bURUaEtx?=
 =?utf-8?B?Z040aExoN1dFNXJheFBYS3kvNDFEOHp3VVY2eExNZ0NHUjN0OWNQTS9BL1lL?=
 =?utf-8?B?MU1hZWNNY1pxNTBHV3NuMXJmVVhuMk9NMkZsVHFweCtlQkNvaUpuY1N0K1RJ?=
 =?utf-8?B?QUs0K1h4WFlUMk1xWUo0WXFQZHQ3MUNMUXQ4bURQMmlUckU2ck84WjFKY2xY?=
 =?utf-8?B?eEdyQ1dyeWZTOEJydEE2bGE5UVdEbnRnU1htb2RFU1JPa3hLQndiWXlGSzdo?=
 =?utf-8?B?WnhDVHIycmZET0dvZGlMN3dqeVhMY2V2ajBwK01KTnk5RzE5Uk13TElYRU9G?=
 =?utf-8?B?cDQ0SGJWYkZVYXJicHJBSzBTdTg2R3BidXhSZHVDNTBudWg2MmFvcURQcE03?=
 =?utf-8?B?SjZKbmZJRE5UazVnZk80SUphb3BLVFMxeHZwVGp6MytWK05kSHpyZjBQOUxS?=
 =?utf-8?Q?VIcSye4DmLMWvgz0p8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944a8050-9975-42b5-802e-08def174b9c5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 15:34:37.0468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPomLv+30xcv97Yrj50aHMlsNg/1iLo5BhJYGGxrMHx6+RNn3BUBAxq5LfMHa2G0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999224
X-Rspamd-Queue-Id: 3FA131C000C
X-Stat-Signature: fjoxhqho556swygxjsmogr7b1sdrcbet
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785771285-288648
X-HE-Meta: U2FsdGVkX1/FkTJttdoxQgZMEkjGk7KA1sCDxu/laNWHbvONDt1pkOmPd430XXq4Yn6ih1Nu6RJRZaTnNAJ7WOFsZgK2Zc4Xa/jNcYYPly38GSpEaj0K9vbVhO1m0cIw8DMBjVG8QI7OA/V/h2jWckZ1Un/cE2h/FzCvbSeNbESA6x2pQKklIpIcdoSQpSdc0fbcbe1W+sIZWvxznfr7x7AOsPhmmIegjrEMX0/nXLyoHoz2zTHwTvjjHBJ2wCoaMc1LcP2FqcwFNZ7rp+oEtb15jerpEcNYNkEzSpntAjBBSMinaTcYUqU96D6jH2n4wYb9r59VQChx5EmWQ71TOpy05NdQ9aDucmh6ZjYGGdw0RAd6vGKjxB1tlZDcW8AaysDIYstmuyiOHw87WCAcJHyWCn+5xBwkiT6UywdJdp+mOCYCqebuaQtdB9b7BKD3nuGxy4JQ/FjpZ2ja/JU00STkVwTolNi90/aDNgnc2wUVEJeKeINWgaFSYyn4k1CnJlJdwsgGnJHusquEtxtJm5bnR+7vFj6Z8CAUEQ3g4T4dkmsqjL1QIZtJdvGEdzjExdg+4FJArO8kOyGdZT8AJL+VJX4hU63T5Cs1idUvkwYe5m74nS7ilT1HvsJvfx2ac+j0bw6Emb/U4sFUWIc3X9BkWjZlwM45u/2+yHdGpPKqbU7p9YLVYcc3JninP8JPDHLecSOvuQpFwjM5omIqu3xJ2nubVXrUrMOzwd84EllBOosorJV4fUbqbl3HGvv+6IsFwbxd6071u/INSfK1Vg9eCbS4SbnwIIPfU/2kGjgC7/VAGtrtCl64CtC1lMJDEDzmptcjhKylK2X0l2C3YH63OdxBaf86NFMPMxB3p3z1RkdajrrmLvXihe6RQbTQ7NeYb/Youc0jcoybrbJIkp1Yk9HiF9QDWFuI/kEETLJ6wFObP//+CgwstO9Ya/NBme1T5+Ab0EyLji0SmdN
 /PGpRr7M
 1OXf3BfXoYZ9QaE+EG9tpOpcPcxUr4VvAHPbpcsrdhqHMRScIV/X/VDi3X75HN5BqNQlYGAttvAUBA9r02ai7r8TtVdgBaTqFJbNzQF0HJjrUwK4oRQ2RCJDsw/KDB/7siR5YwQF9r34aVcFYKUfxwFHZgXiSpNdyc3TbIXRBnNbYIGzqwgn/6maDcBrz5XkRF5E6liBOts7DggsHWnm4PDcvOocd4xWQml0rNbM+0pHSMm/tIwjKkzTtLyuQZKB6IPyECm0DgvNqChB3YBg44GrXcM4IgueqJbCPhDgQxI0ur1cVSQxB5GSs508+NIyN4tdeDmUXVF6JexJhB24eKeJnUgyvnOt3XpA96li57i4M1iagaZpIJWAuUHqanxGdXK8hcoaCPn7Y7rv4YGncMNcPoj1mChsjfwANf4736lW2PrY4K0xLpwCRpyOf9/SQUQSGduurx4lM2Z/j4iXLBhcbz8LQFVUJXAfc17UQZBOa8k4IIFqiwZU9bcgWhIf111McSPKZxfMgx0noykrjSXDUdf3lVFjPbB2J8UesEGAmcG3YdLVXERUQn+HXt0hPgY7TwV5XEiI25XMXgoDmYAfgCa/Kmja3NuWBQKE3qx2fXLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 11:04 AM EDT, Johannes Weiner wrote:
> On Fri, Jul 31, 2026 at 10:13:24PM -0400, Zi Yan wrote:
>> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
>> Replace it with zpdesc->zspage->first_zpdesc =3D=3D zpdesc. The check,
>> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
>> should be negligible.
>>=20
>> It prepares for a future commit that remove PG_private.
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Minchan Kim <minchan@kernel.org>
>> To: Sergey Senozhatsky <senozhatsky@chromium.org>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  mm/zpdesc.h   |  2 +-
>>  mm/zsmalloc.c | 15 +++------------
>>  2 files changed, 4 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
>> index b8258dc78548d..4fd81c2e80769 100644
>> --- a/mm/zpdesc.h
>> +++ b/mm/zpdesc.h
>> @@ -26,8 +26,8 @@
>>   * with memcg_data.
>>   *
>>   * Page flags used:
>> - * * PG_private identifies the first component page.
>>   * * PG_locked is used by page migration code.
>> + * The first component page has zpdesc->zspage->first_zpdesc =3D=3D zpd=
esc
>>   */
>>  struct zpdesc {
>>  	unsigned long flags;
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index 8204b76f78308..e8ef227624efa 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -290,11 +290,6 @@ struct zs_pool {
>>  	atomic_t compaction_in_progress;
>>  };
>> =20
>> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
>> -{
>> -	SetPagePrivate(zpdesc_page(zpdesc));
>> -}
>> -
>>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>>  {
>>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
>> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigne=
d long obj)
>> =20
>>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc=
)
>>  {
>> -	return PagePrivate(zpdesc_page(zpdesc));
>> +	return zpdesc->zspage->first_zpdesc =3D=3D zpdesc;
>>  }
>
> There are two checks: get_first_zpdesc() and obj_allocated().
>
> static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
> {
> 	struct zpdesc *first_zpdesc =3D zspage->first_zpdesc;
>
> 	VM_BUG_ON_PAGE(is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc))=
;
> 	return first_zpdesc;
> }
>
> If you expand the helper, this seems kind of pointless now:
>
> 	first_zpdesc =3D zspage->first_zpdesc;
> 	VM_BUG_ON_PAGE(first_zpdesc !=3D first_zpdesc->zspage->first_zpdesc, ...=
);
>
> Mayyybe it could make sense to assert first_zpdesc->zspage !=3D
> zspage. But that's a separate issue that the previous check didn't

Usama has the same comment about this.

> necessarily catch. And might not be worth checking, considering how
> trivial create_page_chain() is.
>
> In any case, it doesn't seem worth keeping the check as-is.
>
> And with one caller remaining, you could delete the helper and inline
> that expression into the check in obj_allocated(). What it does now is
> self-explanatory; it doesn't need another name like that PagePrivate()
> check before did.

How about the version below? Basically, I made is_first_zpdesc() more
straightforward for backpointer checking and first_zpdesc checking.

1. get_first_zpdesc() needs the backpointer check; the first_zpdesc check i=
s
meaningless, since the assignment is done above.

2. obj_allocated() needs the first_zpdesc check; the backpointer check
is meaningless, since the zspage is from get_zspage().

Both conditions are needed for is_first_zpdesc().



diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548d..4fd81c2e80769 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc =3D=3D zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 8204b76f78308..d89253dc6dd40 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
=20
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -476,9 +471,10 @@ static void record_obj(unsigned long handle, unsigned =
long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
=20
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
+static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc,
+						  struct zspage *zspage)
 {
-	return PagePrivate(zpdesc_page(zpdesc));
+	return zpdesc->zspage =3D=3D zspage && zspage->first_zpdesc =3D=3D zpdesc=
;
 }
=20
 /* Protected by class->lock */
@@ -496,7 +492,7 @@ static struct zpdesc *get_first_zpdesc(struct zspage *z=
spage)
 {
 	struct zpdesc *first_zpdesc =3D zspage->first_zpdesc;
=20
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc))=
;
+	VM_WARN_ON_ONCE_PAGE(!is_first_zpdesc(first_zpdesc, zspage), zpdesc_page(=
first_zpdesc));
 	return first_zpdesc;
 }
=20
@@ -833,7 +829,7 @@ static inline bool obj_allocated(struct zpdesc *zpdesc,=
 void *obj,
 	struct zspage *zspage =3D get_zspage(zpdesc);
=20
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		VM_WARN_ON_ONCE_PAGE(!is_first_zpdesc(zpdesc, zspage), zpdesc_page(zpdes=
c));
 		handle =3D zpdesc->handle;
 	} else
 		handle =3D *(unsigned long *)obj;
@@ -848,9 +844,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc,=
 void *obj,
=20
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page =3D zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage =3D NULL;
 	zpdesc->next =3D NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1001,8 +994,8 @@ static void create_page_chain(struct size_class *class=
, struct zspage *zspage,
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i =3D 0; i < nr_zpdescs; i++) {
 		zpdesc =3D zpdescs[i];
@@ -1010,7 +1003,6 @@ static void create_page_chain(struct size_class *clas=
s, struct zspage *zspage,
 		zpdesc->next =3D NULL;
 		if (i =3D=3D 0) {
 			zspage->first_zpdesc =3D zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage =3D=3D 1 &&
 					class->pages_per_zspage =3D=3D 1))
 				SetZsHugePage(zspage);


--=20
Best Regards,
Yan, Zi


