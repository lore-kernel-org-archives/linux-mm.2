Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0C8C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625AF6B0088; Tue, 25 Aug 2026 22:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6EA6B008A; Tue, 25 Aug 2026 22:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478676B008C; Tue, 25 Aug 2026 22:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7AF6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:06:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03346120256
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:06:18 +0000 (UTC)
X-FDA: 85141780878.19.FCFB1CB
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012068.outbound.protection.outlook.com [40.107.200.68])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3ABC940004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:06:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d03r3w74;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787709976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgjnsL7PgdMiPGhNy1OlIWpVyBq1zRsvAh9TmRdFiM0=;
	b=Iftu9/T6bk41d9JuNhGaKjAZHLvjEEavJv+OQdP7M3UkmWd8wivFrL6cBr+WpUeXxO6XUb
	QfiE2G1JfHIbvnJ5MvGLhbIk9SjC4BhSE+I1ZOM9c8iyhScGDrpUizVdy4cb7dn/GYus6a
	gnr/1WxXIOByKKIPsvpFFxOUODrBIeo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d03r3w74;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787709976;
	b=c5Er3N916W6UNf1CIDoX0CmW34qHBauxMVZWZNOyfxZuht2ZWD4sUiSo5qxzS9EZOGFXU7
	Erv8ZTkRmjCmGREmmL/Z7rUJCcSo1cAdZHJ93uNsow+1lLSEbUi58+AkuwSuV0OsihacL9
	lZD2ZVmcv+6NZpIybj721NeGMHmfaAU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWowkdclYTSb3rrRhBEbS0fQ9YuUt35z6qZg7YpRvBkBgU716f4nPTrhIo3IEbM1R5leVewS0XBrt1RaNNn/yDJed3TibKFW1SnY6RZx27qmBRe6WxJ0n9tVOak6L9Z4AdXseCwP4Ivhy4BujWOJt7SLo9uIBRaL/BU7V5++7o5cGWgolT+CYB/tQJfzBaf60Yn9sf9P8MnX+psAfiHiEb7fWEnj3309MT9mTrxIDqqnmF3uMGlL6jAiBja+a/e332D9yRzmVJMuWoi3xjDYetLfisF/6EE8oFJ1ZXMFTnKch4nqP0hqQTXfItVXhqNlsfCG/LjOYRlIp0ICmGKYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgjnsL7PgdMiPGhNy1OlIWpVyBq1zRsvAh9TmRdFiM0=;
 b=XGfRD+b3C6jsDbi48zojiphP8JddDR8NlW8c24JkZ7Dt3oftJ4xzEuygVHbpjGe0FQpBKbLYzzPIXD3xacZ5U6ownxdGUILnXXS2FKfKWYhCaObm2ypmv/xX3PvA9G+gfSCZ5MnL4/AKhI5aSLc7nMcCd5u9cvKqp3Gp4nkmjZ1wjBaKg3cpY3YOmzME7WVtXK33UA64zb8TXPTkigeyqKopc1k5Jb3WQdyO7tC7WaAc+HNSAGI3duU/X6+qJSqU3LpyqnWkkKM+RdACP8SMGYkl5P+G3aO4iSJLdv/vwwtJUuNT8lijKWAo+MbVTatL5ELO6aZm6owJ4a/qDjTa/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgjnsL7PgdMiPGhNy1OlIWpVyBq1zRsvAh9TmRdFiM0=;
 b=d03r3w74x973qnrePdwmJbe04RXxAN5nXZuaMI5DGVUzabCBCZTs4SvlQaoV1/R9n2DcHuSEztvgL4dT/DnQ+Ok08FCacnGar7iT/bYvpu+tX6kywycJhnFKlEaRu9ptNsylTGDx8KG4qM8CzKzKfwgoWWpY4gNUQEUOxWE10YqXb1RZHBNYdA/wz5cBr0UFoytewzBvBZjRWXH8JfHNwlffbx3gDRWcCWHRyYFUxjgBJuusdJmGRwcQy3WhCOmWzdMgefeeGKdk/Lttxacxy68qHdW8mvWB4ArIluMckx3ye6V7jyU6BAQXu+W3CiyMoekQvhYILrRco9oIKOKJWg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 02:06:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 02:06:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 22:06:08 -0400
Message-Id: <DKYIALOP7MFA.7FH4BRZYYC52@nvidia.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 18/18] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>,
 "Kairui Song" <ryncsn@gmail.com>
X-Mailer: aerc 0.22.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-18-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-18-9b43f5163238@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: 990ae761-222b-48f2-0710-08df031698f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|11063799006|56012099006|6133799003|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	gKQ8V4LXDCA2g7N3jkjA9Sr9kag3AI7cBlMw+cxJIqneV6RnN/oFzdbB/cegxzI+c3r6tJhZsGuX0T1sVR03E9ZwQ9S+WIgxQpY3hc2zSyh0cQo7IOloWP4ODQqWGqEQ5ctNQ+VOBo5xsgxewnhbGb8Gq4WMxoaL/AKS+oAHX87/eTF+JUq3r0w0O1YfmZF22i8RYODfdXSTY+H6EJGUCVX0A0EnurWEFmZQ061h/TUHMgsaX7mOWdQ+Bq+QjJA7wP2UV0S4w5x8V2MvikYDUkFk26Tdj5AlFN9WJH1otIWIReCOiiVB8Vjpiu3KXIJZFSbAMYRTEEdEPjhogFDgFN+gM7dtTXUimqagawfOL6Tm7qhaSbqJoVRRLhfN9qNfbAyQykgLC6XEO/AY6h1nRx/WyMUdAMM2K3Vum57c3UNc3bQxActa/YECOVDOjXfInEEgVxWa1oI8bVVYD7La+n9+j472tvM+ANn4VtI3QY88XG8VPEeS9XT7uuVX290ESJGR5lQEBzNE6KW9KNHDFeJYd32zfo78BlHkbjmcccATfWm1EWWMxJoS6AdTyb5Vtw71xqjAESCNIUAUaIG5Hon7cOzSVunwD6DepU+/bPfy70T4RPy/VIsawfrb9W9wM6LE6njB3PHh/RnoaBqj0EB1psQqJZkTiGtL3Oixp+A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWF2eGx1SmRzMVQ4ZXJsQnJ4V1FHbUJ1cVRwRTJMdlQvRHdHbHRmMHpZbmhs?=
 =?utf-8?B?d2NGb1lKVmFmVktucjJ6MjMzaVBRTDN6TU1ROHNMTUxwWG9EYjFJbXlNUDV4?=
 =?utf-8?B?TVd4SlJUa0toSmNtZk9SZ1paZHBPbXJqQkxFalRna0lOdGtzMEdwNUpPMndL?=
 =?utf-8?B?cXhUcWpsbXc0Q0RyWWhvZzlQazd6TGRBMHBaNjBsMGR6SjRVZWpaSG5vc2JS?=
 =?utf-8?B?Sm1nOVlzKzJBY3oxWWo0QkFRczB1cUY1aDViY0xVbGY1RlRDazBVanFpemJp?=
 =?utf-8?B?cFZaWUdJZElwQmJzTWdqL2UzUjJhb0pOWUpla0ZlckhuVmkrWWR0OU9ZajFz?=
 =?utf-8?B?T2hUdlNYdXVQckwwTDl2VkNNRTFHSnpUaUVsUWVsZU9qaE1vbGZ0cVBWb2Jj?=
 =?utf-8?B?NUtxdVYrWjNxUVdCbmlETW9iUlBENjc5b1k2cEIzZWY0Y1E0djlDQlJqdTZD?=
 =?utf-8?B?cW9rOU9EQk9UejVYbE93WjFHZUxHMW51MkRUSjNLK0NGVUFaRzQ5MngycWpO?=
 =?utf-8?B?SWpsUnN1Q2wzSlJDOTYzd3B2ZzFnVFpzVSt5VTk0ZnhaQ0g3TGs2WGNTdGJN?=
 =?utf-8?B?TVZ5d284cFB4b25ZMXQ0K1liYVovUmFoK0lBZ1cxYURKVWpwVXVwSUE2WUZK?=
 =?utf-8?B?bGN2YmxPMGtDakFzMERZejVmU01MTkRBNUZPZGJ6ZDI0Z1o1TnIzSS8vTmZ2?=
 =?utf-8?B?ZkFsRTMyZUtaSmpLS3FQMXVhaUdsbEszVWtzRDFuSE5BWWdiREJpQUtNTnpz?=
 =?utf-8?B?c2NZcWxpWFFEeXhFbWtFempDeHBHUHp1RGtFRlBIenBndEg1M3Iza0ZWNWVi?=
 =?utf-8?B?eVo4enBKRUlJQ0xDbHBnSTB5TVYyYmdYWFA4djBSN1BvOHZYejRJS3FjTmZi?=
 =?utf-8?B?cThlc1pYMGZDaVh1VlUrQmNTTmpMUnRkTjVGOHNKUUJqRjV1RVA3M3NkaDBC?=
 =?utf-8?B?Nlp5eFpJelozVGZRNnk2S3V6MkM5TEdVZXFRbzQyNjUxRzhhYnVtZHhOd1VT?=
 =?utf-8?B?VXFtSkkxeEdXajQyY1A5WExjWlMyaXRpMElvUXRVVE5hNVJqUWprWWJlZ241?=
 =?utf-8?B?QkpRUUkwWExVd3dNSTJiaFU1RU12ZXFjTG1DNERqeVcrRW1SLzFTLzJDRHJX?=
 =?utf-8?B?dGp1aFRoR1BSQUFrQVZhNVZPdUpKWVl0MFV5UkVLMGNQSHQzSlgwV2ZrNUgx?=
 =?utf-8?B?T2E4SSttanJTMTNRRDF1Nzd3QVFGVTJyZytwaHJrd2hoOHFJWU5ndlhTVWNz?=
 =?utf-8?B?K0dSa3AxazA0SlFsYkRyczNtS1RuZWdodXo3VnBRaFQ5anMrczlEOHhQWEg4?=
 =?utf-8?B?anFScGxPcHpQcGJiQTJadDNyOXRibk5PTDZvWS9UYWNQV0IraFc2Z0lzRmll?=
 =?utf-8?B?Nys1MmROUnphQVdQazgrMTRWV0p6dTRSS1p5cU42UDRtVWZPSzlNSnk1dGlE?=
 =?utf-8?B?SGVXcTcxWm1VT2JQNFJCMktJSi9LVTFvYlQwVUY0eHlTZ3VkVlNsK1dreVpV?=
 =?utf-8?B?UWZCTEladnJuRjRkYWZCenhZWU40RTdyM1FWRDI0UUo1S1ZjSks1czU1SjFm?=
 =?utf-8?B?bXlWWVhISnhZRzNnSWRmYzFOS0d5VU1saDVGSFR2NXZvWnV1bWlmMlMrVFRo?=
 =?utf-8?B?ck52ZDFWVm05R3RvUGRIVUJRK1d6QTFKeGwyWmdodm54dG1OL2YrUnk2WTI1?=
 =?utf-8?B?SWZkcURHanFXKy9zNko5NEVKczF4b2hGcGJrRkJJWnU3K2ZNKzhPNXREYU5j?=
 =?utf-8?B?OG4zcmpmRnVVREZPN2Z3dHA4bFhKVFp3R3JOUU81RkZIZVNmMDFMVURMbDhT?=
 =?utf-8?B?dDVQcjRkR3d5aCsvN043NjhqaEtnaXdHc0x1Z2NGWElabFRraVJhMzFLS1pm?=
 =?utf-8?B?Tm5Qa0R1cFlRWWRUQ0daN3hhNENEY2tYLzM0R2R5TGQ4RGFnZlJNRXNaaWh6?=
 =?utf-8?B?WmQxd0NMVGg2cDdjaWFBT0M0V0gyckd4Kzc1TEYwMS9vek81SnR6Ti9JWVNn?=
 =?utf-8?B?WWY3MHBleDBuR2UycVdNY2dTa3ZFRStGaWw5aFF3NStsVklINHV5MXUyelRo?=
 =?utf-8?B?SmV1WGVrM29MWXNrb2N1OTNvN3BVWGNzQUhJdHViNUE0b0lQSG1WUmttZDFs?=
 =?utf-8?B?L1MyTWVUUllKRllTRy9sa3BqanRzbW5nZzhEZG1DdHRMVlRjNEhSNmpOYWNr?=
 =?utf-8?B?S3lxK0VpWmp2T2tOc0VBZTlhZkg1NGFYc3h2aHNSdXNmd2NxeTlqWURQR1pU?=
 =?utf-8?B?ZXcvR1JYUC9VNDY4MnZlMXFRMUJucXVOQzNBTjJtRlBvVURxR1ppdmFmVXFM?=
 =?utf-8?Q?GDrPV48MSdWbf+xKUF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 990ae761-222b-48f2-0710-08df031698f8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 02:06:10.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7W51YeTQZ1YVBCzSlbauRoUwV4HoeplYP2LQ4n2tqvbu2jsxGzC8aN8IHfAU3gJx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064
X-Stat-Signature: 3yie7anx6tbmq7fesaorh4xarpyzm78p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3ABC940004
X-Rspam-User: 
X-HE-Tag: 1787709976-795118
X-HE-Meta: U2FsdGVkX1+kj3BqYYPQ3AaJpAQJCve7Hw36we0iKLOMsgucNVPFm2VeKU7E3oWidLEzEY+uCjklzNfMbDWsl3MB0njcBNZRfqokYnJ4JDSM92XN9OCVkdpvYcEPPAU9FN6+FvoM/8FEOKIPJ3SvT+BjMPt8pFHAZUdgXZO9Y0WdzvrpFZtzxOCKuwcOi5g/Ph0UJNRs+OHsvghLzTA4NGP9peFK++XEHSi9Aq1BW39EtkjiIVEXApyQar71n/6qUlSuGGMJ/Hxo8Kebo1QYK7yGiWtpL2InmmcOtV9qu2LYPxBoeJEuviwZ13xAXJ2lgE2KHUwDlaKoOABGATNnSmMaIbfZp+//KTGhAKLEuxyQXySZIP9mTgvuMgtFtQTpAylKtu8NcEBvXPdOvG/Fn99o8lOMYhaytilYhxhUsmekNMi3eJk09A60grxfl/wyKcHoUjGY8tKc700jYbq5zkvvHuuRL66C0MzsKNZrpDWsRZDZ7dvjR6lD167ksB2qxDKHLNso8fzSBo1/nBgwC0/AM+iaaj2JKL372f6VsQ7mVDk4hBi9afgacQfp9WOhFkkvD7kRkrgwXqavQInfAsrOoNfNIFX5Y76rmHM4Ut7KXcUMZEvPQwJdP8JEsWHojn0IZktE0Nrj26rNH/IV6LQmok50G2LA1MKjiVeHCKP7c27ITNqys051EDuMfst2TPHKQsLuY56z8+tVrQvf5QXr8axRGncriGLib0vRy1MV817phUClNA/hSQUElFLsbvKn8Ql2vXD2ciZ1HGqrthfHf1MApMSGGVgkjKXP0z28+IMidHuk3iCbnNUaT9O96UCQzccml4/MQ/7/Gbk1YV9FWcAs8WapuIXjMH3b8sp5/ij2GQBhKHNvXzh2Q8WoYg4iAXB4wl7/OFhWQITVAn5KPNSuLEjQ7YAFLLbfZONgBcJqoNLLcsS+wpuhyaMniGLxsDyG7fARiMwyd/t
 FCHXqhhV
 3NCtXXU2kjGufwmwqz/xhtfpXojUnFpDTbN0oypSsP+5XQvv7GG4BNtxF5+zcv0OZoGtYZL3b7DOKlO9J7eHBdaun/LbwABqzkDfHPCY+zv95DNW/6w2zr9QTFPMiZXBktKKA0RQBXZzJcxek4aUgeu9ME02Ix2McDJdUEdLSy7/09w7wEViIzjlgboEySSwrVS2zmHw73pGFNyK2dVM5vufTQUctUJmkyiVjkqcYLnovNj7727/uPMfXWPP+2LCbTXBKO5V3mFxMQ8TZV1kxllWEyEooXIGFrHgQrSrtg1DLrGUUXXCLr8fmqSwhWTY71fKmQ+mkZGEP0crmrKN+50HaolS78WqUZtCRCK6glH8q6+rU2zN2zwRr6l4vhQ8342kbHOI0JVyY8V24ouHmt5FcigkpTn7QsC7Pl7W/i1XbYN2YDRMx8zWCVRJ5+Klw3VkLmFLdc2P/RwOpckp9rnezJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The mapping parameter only served as a non-NULL check to detect
> whether page cache entries need updating.  The xa_state pointer
> conveys exactly the same information: the anon split helper passes
> NULL and the file split helper passes &xas, which is non-NULL iff
> the folio is in the page cache.
>
> Use the xas pointer instead and drop the parameter, along with its
> kerneldoc entry.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>

Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


