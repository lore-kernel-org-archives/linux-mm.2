Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6EBDC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468526B00AD; Tue, 11 Aug 2026 16:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FCB6B00AF; Tue, 11 Aug 2026 16:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3568B6B00B0; Tue, 11 Aug 2026 16:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F058A6B00AD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:46:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DF3B1C0111
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:46:00 +0000 (UTC)
X-FDA: 85090170480.18.2DD9D39
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011026.outbound.protection.outlook.com [52.101.57.26])
	by imf19.hostedemail.com (Postfix) with ESMTP id A88041A0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:45:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A71FuA9B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786481157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giysvNhZHoxlllzqNuJHk30XuQRNoG/MkEH9mNxr9pU=;
	b=kSGJWR1ECGIEWc21FvA1A3qnB3ah2ZNjv+jpapQDZDynDrXVp6wPXoZ4kKKDI115Zodj7Y
	3AzkEofJD1KRKNy0gIM4kDcf+dDV5IrIv2CLzP54w4SySnCqa57xIwcApTTNjk/cK/Esjn
	dh+4pscwNi3d/eroODqbJfK+MHCBywM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A71FuA9B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786481157;
	b=280mU4nsvKpbZOv18C0nc3hr3oJOoDwITPIE9nx7+GAttTW7X3zEmucOCp7WW/6NQSyaSp
	kcNDuFs83s4AuvhtgokoM7xQZwdiHHqc70V6bDJtzOM2YvksipWb4HprTFasq6ZdEfCLDn
	2OP/SIixF378rwPu5TsBd20hX3YSax8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DAlIT54Lp7LaGkHwZsF9yjUmgQzo9PBgY14zfkwxT8WVy4tgJ1TsyutZxGMLNVKBzMBTAVbGP8brfhfdSr5Np3FkzWAsQVPalG6gYlcwTUwx2zhytrHoMNMW4ZV6/JasU3lVD3eKwnssHoTene+syH5tJp1TUHVb2UQFXH7IyCVrOmk0Iysy5dR1YdIt3EhwLMHrAamJajrtNA34kd8UewoKHC3CpOwh3ylajJPg08oHqnNSFooFE922uHhte6YWgMI3WPjjNl3xKzGlxlzUuVzCPXIWlG7W/tRf1Fqy8w5JQLOwjJxF4oJUEp5d6Y2z3S7/yZ05iPNJzdj8WeDyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giysvNhZHoxlllzqNuJHk30XuQRNoG/MkEH9mNxr9pU=;
 b=JBvEMoAPbcow1oFIBfZAlkvO1zyKndeBf86TU6+lj5ec42OgSG1cnq3phgOnN/2Ez02BzKpD/rGJSQVrQYWYRgAyShuZ+nGr9nwMmvkzfokQ0iC0RmF8ZwnLTpx9lJYh5KWNVGwBT4GXh+KK9ZycjqUbzi9ljuEs2/uW96yf0r6LiuG/XIQeiIJj8vu9n3GAy2xAeR2uEec3CzvwlzWyF34/4+UT72tkabTHujlvVgBB1JsFYbT6s2Hp6jZ9kjqyiHO6NkuYuDbSvVFwgLen/zwPIakaivUIZAAXk+9pzalAo2Jt7wRJZkTM8JhuFSsT4cY5adwTBsA1OC0GCIXqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giysvNhZHoxlllzqNuJHk30XuQRNoG/MkEH9mNxr9pU=;
 b=A71FuA9BPRa724fwaweb5W/ulzHsSYvBlgEB5k9I5u7rC2XQYSWSId6UEaOjK0GQf/Www55nxn2a9A9g43Qb19Gu2QH/FZOFCri0VZkEZVovlrWXFRcHJkjnIP4aHK3pekuWuaPIpTkADwqC3W3e7Qqc4wZajN2w4ZQFv0BuJCl7HLMRoOisaPrayL4i6FV2Mq/hJ/VVLtwfDPVDDn5s1QXJDNp3wqVFuD7IYcREOftSCwpfBn5fd1Jj6p4Z5LJUy2hWON0UG5aF0eF49FOXKXm06U+A0fLKLzIY0rNL+lKXdcQbCXtw8ImX62fc0hDPyFxKAFj9L+PSTH2uxs2wsg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9612.namprd12.prod.outlook.com (2603:10b6:8:278::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 20:45:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:45:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 16:45:50 -0400
Message-Id: <DKMEPQQA08NA.35T0JF0DEFRAJ@nvidia.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 3/7] mm/khugepaged: introduce a
 count_collapse_event() helper
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev>
X-ClientProxiedBy: MN2PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:208:23a::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9612:EE_
X-MS-Office365-Filtering-Correlation-Id: 9daae384-7348-4438-837b-08def7e987f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WKBvOVMo71kCuuJPFVwH3EBFIU+CBMGVC7cMKiCvpNMKHZ5JDuveI7epDDNUNdIoGEXcFCRcQ+3iCFBeqMRMG0iy9WVNfWhiDVkE0TQMNUvzK4HQ+dV3Qq43sWn5McdZhu7zTC3Wdsb2E5nr//lVj1ANoMOeY3EA7sBzd9GJtMQ6Ikc076gA5rsy1nRJ6zmWawVyyELdpmytWjtXo2Ye2X3SKpvUYT1azFO8Qb3NIPrDfoRGz0UnmfC/7Xn9UnXF8kax1LRMCTCmDPaHmBmJVRXyA0VBv8YCCxmsi6gLRrAl2iBzcjX6j+fW4uSHVyUy3FChVSDtTO+0IeUt86fwpkoaLAvBRXi5IA1NKwkWb0fwudw703CDndge6GSAprXaYIQ54x85TTdBjpgUI00w0LLim0leL3OAK3ONyo7i/HsKWOqGnqHcbmjqOZcixRL3xUNxXXZj9sO62MPO1GuKPbiTBuQ2VwWusdqrUNEFXCeel0eJzwGvFORrP0lC5IRUYntmQ4BOfOVh6TQ6NeGdTVfdgm6MMzZkj6Deh5+M9xkcfpTqBjSVDhJZ18FXwA7k8oZnLb3WYA/JksXnJYlkrhxF2tbQwFHty7F+rqNt69jdbPsjevz2KKdf2nGiSPTl2kE4h7TT9VSItSzZlFF1TzRBlup0m5oolp0OQFF9HP0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2ZwSEZpc3dOZUVXOGQ1bkVQOGhHV3hWUWFOV1BMUUloSjNHcEp0QWViS0hr?=
 =?utf-8?B?ck9XRDBvWEhzdDNzT1oxbzFGWVBiTi9idXlad25KWXlSVktHaVpGbDNzQWpo?=
 =?utf-8?B?dXFkUENmQ0lncnhKWkk5SzhkSWtUTzdrLzlab0trd3VicytoQ1VTU21lcnps?=
 =?utf-8?B?YXZOR1dTeitCVHBiK3NSaUcvcmlqY2FGOExFcjAxdURLZkU0VGhaazl3SndR?=
 =?utf-8?B?bTRyVmhDNW9iM3NlUWNoRXZvd1pSb0lzTndSaE9ha3NEU3QzOW83YkVSaEE4?=
 =?utf-8?B?cVRCcUZXbWpJcjVIaEFNUmdsNmVlZE5vUzM3UHh5TzczY1NQSjZoTm1HMlpY?=
 =?utf-8?B?d2lidzJ2bkhtQjBha21LaDUxenlJVUhXVC95cEtOcnZHMS9SQ1hXRjJITGZo?=
 =?utf-8?B?ZkpJcDNmV1hmWDBtbGVSSnlDVEEwMVhDbFB3Q2ZLVC9qQTBpZk9LRVJ6RkhO?=
 =?utf-8?B?Qzd6TjlwQWhxVDJRN09QekU5V29IWElxZXZlQ0E2OUZkdEhYNUtQOTBaV002?=
 =?utf-8?B?RVhJdy9uanNaOXBIUWlYM1NOa1dQNTM0WDRkY2NleDdvSnI3YWg3cWtNNWI2?=
 =?utf-8?B?YUIrOTQybktqWXh4cGV0K2NteUNuOFJSMU1GanVJYUEwV3pzNHVQa29WRmpO?=
 =?utf-8?B?dVE1Uk5SU3VyMG5jcElvR3RnQ3pkdEVISHZ4TGQ5ZkxpdzFIZUk3U0xaWFFi?=
 =?utf-8?B?ajFEVzBzcHR3bG5TbHVDNTByZER6NXFBdnc4eDlaQnE4L1Z4Zk1mNXA0ZW9Q?=
 =?utf-8?B?ZDkwbkxqKzBKMUhMY01oZTB6N3dlc0tLWUZBdDVvSFhqbW5yd1VnTjh2S3Rq?=
 =?utf-8?B?ZERqNjlWZFdaakNyTFZMVytHZHBac0xmOCtWRmhGdDVHOGV5QWtGMkx6bjVT?=
 =?utf-8?B?MEQxb3FPRnVpMW9VSlU4MWVDRzJlc2VBVWdyREpQRWJ3OU5tVjNUclFyNzE2?=
 =?utf-8?B?UVJ1elhOM2pUbEpHUnQ2Qkd1QlI0cWphSWp5cEZHYVJUWFpZVVBkbm55VDBv?=
 =?utf-8?B?TDZTSXdvUVdzRDF5ZzNZTEFsdEtKRlJHYmgvMEJXeFgwSFUwcll3R1J4TkRZ?=
 =?utf-8?B?ZjljSTNYMnl2RU91bW5YL0N6U2o0aEVBSzVKVSs5LzFqWnNocFRWRjR0dDhs?=
 =?utf-8?B?QllMTVVYM1FKdnVsVkJyRFd6Rk9KVXJ4TkNkRzJ6dkpDRmJMVW9veVJJMHk0?=
 =?utf-8?B?THl2cnA3NXBJYjA0NTN4WkVydXdxWWRISUpUYU9GYitYcDBYSFU1MlMyQmJu?=
 =?utf-8?B?U0J3dHdXbFlUM1c0L2srbWg1ZGVyWGVhVE1nOGZaMjNUVndydUJ1QXJwZlFk?=
 =?utf-8?B?NldLdXZDUjJxRkliT2JwWndkYU5iKzZBdno0dktqWndIQ2ZHbmZqT3FXNlZR?=
 =?utf-8?B?TXpOd3Z0Y3VOREd5TE1XT0o3N0oxaUZQeUs5dU9YWlpmMkhTUDREY0ppSVNZ?=
 =?utf-8?B?TFBWSlYxR2Y1MTJYWGxIZUZ0YnpCZ3V5ZnZKZnBvNnE2NXYrbVJZc21FZDRS?=
 =?utf-8?B?cEhLSWVEMURCcDFzd2ErWmFETHNSS3pZSW50akxuU3VOalJzcVdWczNrZ09w?=
 =?utf-8?B?MzNGa2Z3U1dEYW16NkdFU1NRL1BlQVRaRHJzNjBxbnFKcnJ5WWZJTE1qMndC?=
 =?utf-8?B?TW1vdEdrNHkrMWpRYXZRc0VCYjRPTVFrbWk4bTNJbGRVUjY0V09xWVZaZWNm?=
 =?utf-8?B?T3V2SjZkTzBCNzJwZ1JwdUtMUkpiM0lUR2RGWWNYTEdMQ1ZGRzdDR1k2WWg5?=
 =?utf-8?B?L05SZHJxdGJPdjBFWWhycnFXcDhPM3hwWjNOTE03TTN1QmhKL1NLWGZjUUFx?=
 =?utf-8?B?THVjL1RIRDBPaE04L1kvOEJ2UDdRa0w3Qlc2ZzM3TUtKd3lHenh1amJZRjZI?=
 =?utf-8?B?dXgrVHBsWUNUdXpSUGpBRXdhOC9tV2pnM0hsZ2pvOHMveGR4UHJWc1ZmSlpo?=
 =?utf-8?B?R1BYOC9HSU5NNkpZM0thNWI2a1pjUUsydzhDekUvZjF5a1A1OHNCbEpzMWZl?=
 =?utf-8?B?bkdPY0czTG9tR2lSTUhDUFd4UXhQTWNXRjB2dkdCdmdnb2NndXBxQ3ZaZE1T?=
 =?utf-8?B?dkZmdDdmYTl0RzlnbnB1V2hpRW51MjVkK2Yvb0hhV2p1MzVBOFRWMU0wUUZH?=
 =?utf-8?B?YXAvcmxUT1Rja1NIRE5wL3F6aDN0VGVCWVpYZkUrbnJEYlBKZ2lPbkQvVEdL?=
 =?utf-8?B?M0RqMHVhL1lTckFwRVE4SmxCRjZHNVZqdFU1MC9XcjF5TDcrVW40Z2V3UjNN?=
 =?utf-8?B?UzVYL1BSdjVCMThJSjdiczNwUm1PZmFGZGVHTWFhNTFwNUhsdnpNa1ptZ1A4?=
 =?utf-8?Q?A94hlhJjVOmA49TmYX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9daae384-7348-4438-837b-08def7e987f7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:45:51.4982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+EwUk7/I7G+xgzBk4WlrCOAc3ivUyuA/vXIBXY5rCb3HVfFUSS/mD53r9O+ykYI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9612
X-Rspam-User: 
X-Rspamd-Queue-Id: A88041A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 1aw9pabjn1ati5gtx99kxaimxkf3gk39
X-HE-Tag: 1786481157-328303
X-HE-Meta: U2FsdGVkX19+i3YSoxaZIqqkQWeKfmq2j2FQlH6OeNgBtMfAz6T2zm9kDKxAPEb8cEHVcsBn/SSXTYwyHd/aFW9i1rwIOw7zGB+rL1rUkTwBSAX6B2jUjg5rhXvSamFpsFxdrn7otTZY7dHr6Ckq6s1Ps9BWiT5ZR0i4zY42wzzBPMR8+vw8w1NCS3pxgCIA6D3TkFajx8dXvgn3ESNLfXk2Mx6q8N6avXe9c0HY/erpqTxFyPzKITO8a9kB/XAOAitfJX11TPJUss9ABXEMMUV5wYj/MT0fSTHcsWeeTS+v6v6SrffPXxTBpuf7aBnaBw5IjAhQ0Lw1fGvbLErZ90lDbFWXy1KAZgVN+90vgb8od8iclvbt4sEeDMIwWSz5Xb693PDfUjDxgK0ww1CTNOAR/waNXUUgoFYDMvsb7Jv8lLhWJOevC9C7VLpczcZKZ4s3i86vyrKk7BC+GX6qcKIKU3Pn4f9TKmsdYTZAC1S8qU4yDbFrswQ6Ax0AgbQEBLBw1OtbkPRvYBiY370HabSJviwUak+xsXFFKl2cxVHdZnvUbm/WJIl0eP5Z6U8Rpjw/S4Atr/eQewvns0PZSNpCVv1IQrR9ix6i19oDHIXfuSqJdLq4xZrd2WALHrwC9juBT7uVz8qKeNvNTbiiamflAd1srZdzsGEu6Pb4LFKZtI0QCZipOTj1UpJ8J+av8sT/VeDkK0+JLlFwO8c++/Lv++aEe27O6j+43lroPGzvpg6gW5AFgpGNQx+9Id24StozCOkLKKklwoVQNLxNya9SEXi4k19SawLXfZ40hy+17RTXWrPnsJPe8NTa0M8NgmBPvfZyXTYYzkckFX41t6bXrv8WIMuSNCLtENMrPIuA/CQ4Z20dlsHcyfgjxPFgvzWAr+h6glgnybh2lCRxaOw9ESwpNpzaIABzyUonoNWrhO6w5r8BIPIOUuEvhvHEoAJUan1tfo6GMRjBzED
 sBB0ZgyS
 tbTVG17jbSgBIPr3sYB0lqd+sEfpDCDPt9Q7p8zWy+7geUiL4mrZ6f80wXyN106TCWDiTA7TTiXP/bZT3C/+3CN5BAc9D8tdBgmJqpzlOCaBS+SrS7LzhhgfT55euLVZ8mb710gchfTdsfCMP0W8YGALkKefYQH+xMWEhDO+Ayb3NTP2cgo2O6XHLgQk4uC6DmUl099dPHXw2WuFdmBr6NJhF7zgsKiXgHX73LC08bM5gtGySolzSmjR00mkKDjk/zq7b6tUzBBBaHI0IboDAj6IHffZu1WUYJpovklKbMJ4g5tJrTuK74e//asLNon42mg8NAm4YWAZRJ5/Ix9I6vhlIva2ERfRn8Wq1mQaksDHWJW4CAi/lfEfBxxrKgcI9poEzLRgj15Ia47r6mh7GNBzXDwoiYNPgGMBriu1GXPh+qCrbnHyxWikvhFLOurQiEUS80aul6R4jAkKLVcJ4Y6T5NbixHQQ64ED3Z6Euf9SYr3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 8:48 AM EDT, Nico Pache (Red Hat) wrote:
> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
>
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


