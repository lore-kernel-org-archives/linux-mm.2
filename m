Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74250606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AInRY3XJ
Received: by kanga.kvack.org (Postfix)
	id 7F41D6B05BD; Mon,  2 Nov 2026 22:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA2A6B05BE; Mon,  2 Nov 2026 22:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9EF6B05BF; Mon,  2 Nov 2026 22:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF2D36B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:47:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B42D1402B0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:47:41 +0000 (UTC)
X-FDA: 85392423522.14.22AB387
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	by imf22.hostedemail.com (Postfix) with ESMTP id AEF61C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:47:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AInRY3XJ;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkeMze9tVazF+fZ74fjwMYGoG32HsUJdX/eR7yLdbRo=;
	b=dFUEeawsKGUsqkvMoZbjCMYV/ePKr7JzuJUoQ3A9DE7qKJsbKfzcIMZ8qSgFzP9UpJhBhy
	gntx20TX+Ooes1gvLK3il94VUs5geqjvRtOQSFJjvEN0gstT2aJf5pxanb17QWv8X+NAy7
	ptWM2EIm/S6S8PfzDT+ns6AQBkDkIDU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793677658;
	b=rs+XODfGyfkrUfDZn17gyMt3wDapfH9J5m7mf/rm3mxM4tMFS7PmxMLPsbhCdN4b+Q2GD7
	9OXos+5elysTQkJsAcem5L/rg7jtHAGQDYFarJ4JnhSsiPqV71cwc8zux6WU8xU74WGwlB
	tmLRUFE+7AhP8Oylk/bqOq6T7Y4EDiU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AInRY3XJ;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPiZn2q6rl2G3FfkGWgSCdXTx2optPKYL1ucD2qJ7kQViqdc604eo5YwOK3Vt52l1rV5TuA6F1kgMRkZhGEmbcqtW/Hx3lJh1BF7TucjwPxTZH9y2tRKcfvIUj4fODc2wbUq1hbzWARx8+8wfOlgjIUic6jVYBot7p3qkjg7OhkBbzK6MCtmFf0ixqgQAsBmSYSiNX1J2AfTB85l4LZA0x2+KLtnIdVApDgW/cN/NUmKs1bhvMoQUPXHGnBsBChyosqVFsF9EOYXKJWBGEGVDS4505w5IYlQf5EJ0k7KwImrXlzfB+zUjuqCv7vzNArSRACmI5R+9Z3eF964XWx16g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkeMze9tVazF+fZ74fjwMYGoG32HsUJdX/eR7yLdbRo=;
 b=vewMCYR0M5cQsJrEjpA/Yd1eE2CUyIPP5A6vwmToboLIJvNk513x4ZbVYBDwXE1JSVq3FW/mvGBguHFevLpcNQWFYO3ZRV4t1jZ1CmrdOqb1NgrWshuatjhYWqLuKJBwOwrf0UXewhbUefD3Gx3Rx/C1hQOOspNtFmHqoH9SxzzcedIzQ1b+Ct2dwx0Dg64FhsKvDft+QMkwSfzljab7AIXo3I3wIqUSwP9Id4pt/cfNp/NWkFMeMzUwI7o8CpsVMyORUO3wrjLnKdd1HLlI0vE7x52Vd3lODi/CRFXl0t/tBkktsU57EVLmQSsMu06dMalACUMxMO4U2F2CWQq82A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkeMze9tVazF+fZ74fjwMYGoG32HsUJdX/eR7yLdbRo=;
 b=AInRY3XJy5BucT9ZqEfQ7OKxuqBg/6RzsrhkF0IJv0LmiuO3uIHMTNUyIWq2XuwMgH3GtDZKOTfQfupLIpqXv6sA82Y+4ANJ8kjcX/40a7AEu5rsVXltI+NQOinrX36yn9lDqZ9v3WJ3g9kKPpGdc47uXzNIZtTnpdP81KaHtK2CtGPp6Mr8ZfRqCXNy71dzw9ysX54euNmjBhO/LqD/U5jpTlCzatt23rrLLqqSrunJJuRTrkIlTPfglOZPAgLRx4Z3dWDfGNiFZm7NDEo44w4qeiWneCPscwr9JRkbKb8vf9BCEN1X/msyQR1SSny/lfVCPZmubJbShtLQPYVqFA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:47:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:47:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:47:29 -0500
Message-Id: <DML9NSN9T0ZH.10CA6Z7O1215K@nvidia.com>
Subject: Re: [PATCH 8/8] mm: remove thp_size() and thp_order()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu>
X-ClientProxiedBy: YQBPR0101CA0292.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 4208be67-fc24-43ab-4735-08df395d3030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|22082099003|921020|10067099003|4143699003|11063799006|261022105027099003|261021123027099003|261022075727099003|261026140227099003|261028144727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Uf0LDKyYxlKwPuCbRA+hA5RMhamCrERZoCZHHNBuxrGrTY8E51tt8GGRQAD++yrF+sW2aBHlPoV4CqkxiBrpfuRWO6Q7P5iJtsBtt3t7adfLwSzKNzJB8ZHSqasAXKvC3cpFZvTSxfxusv9xhXETmSwoJRrHsj0Vmucn7kMYLKh4mFcqKU2JxxAKmE578MngoywEorJ9T1p5hDC43wA6ZV3XswNVF3ns7ScfVS/eXEU6ggadH/dwPMYI2jKqfKpq/fWsDTE1LgJnc7JO5lrAUkkwu/AAqLPgJ3WOSWruGEWeyc6tlXqFacsyaCGueqbutcCWt9hU1F0ExXxRWsLRChOh00eWlM/cJPL9xE7/rpybpXtN/qkd2xI1CyVYQFaJOGTv1jEq6mKJ9/K1rF3mjl6JH5dVweiOwyMXCrbYzH5XsU/Rg01O2o+FCRIagI46zjY+NU9nyYqO4IAQsEvAM0uv1CGeVC8auJnn8Y3P+nn46M1tbtFJCSZoJokqu6J6LFveVV0Cj18m8YxbCBM5tOrwpsDxphLceAMoUaAc0X234oR2ZOUc2xW6YqUwB4fK7P0yTYJOvSN+oge1C8aQRKkZCucr5WuXkMKXAihbDCzdQNUXyATJDqgFz+BpgfvjjuZOneywGelFt1oW6wk5j/ZZZrMn6/OB6uO/Yp9+XuV9Q1U+PUkc8YqKMketfpL65k7pIBJE6JQCSArFqG/pbg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(921020)(10067099003)(4143699003)(11063799006)(261022105027099003)(261021123027099003)(261022075727099003)(261026140227099003)(261028144727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnIwOE02MTdIZlV4OWl6L0JEaldRY0ErVStGMXUxSEI0VUpqSEoyMGYyT29s?=
 =?utf-8?B?WEtRR1RUWUtuRWR5TGRLVVI3UUg3aXQ4RUNGRldHNEwvdUxycGsxY1I5NUVa?=
 =?utf-8?B?T3hHR25Sbkh5c1JHckhiNGZOTlJXeHN2S2tqamkwaDdyN203Wk1kQ051UjZ0?=
 =?utf-8?B?Q09qc0lXcldPMGVXMUFFa2YxenQzNDVvS1dDMCtaVFlMQjFKL3lhb0JVTm5E?=
 =?utf-8?B?U1d2WnhUcjZScnR1VmVHQ3g3K1IxMkptb1F6U1c2L1M0emcvdEp5MEFyTWY4?=
 =?utf-8?B?QnpHb0I4Sy9sY1dkbnRmWHJWMmQ4TUlvMHpGaDVNV3NQcW9JZzJ2S0ZHQkNK?=
 =?utf-8?B?eDFaa2lvaHI0SVNXTkdNNkRLQkx3Y0hvV0txL3Y1azVUTUQrMUdDbitISDlL?=
 =?utf-8?B?TmdCbUR6OVAvYlJUSTA0UDJlMjlKTS9PTmErZC94bFNMTk0vV3Z1UDJWTWM3?=
 =?utf-8?B?eVljS3BTQ1d1eHVTSVBVaGt2VTRJV0pBRE9vQmVjUmJadjFwNXE4bDJEeTFm?=
 =?utf-8?B?NVE5cFo2TmJZcERoeVgwUkNVaGtNVkxJTS9hT1kzQmJLZy9CbkxTTGdITlJj?=
 =?utf-8?B?bnZtR2xJY01TOEI2Y1N5NVdCd3dPWGJ1YVFBWVBGeFRUVHBidTdaaXBzUWRu?=
 =?utf-8?B?UGtrdFdkVldQQnZ1VE9CR3M4bjVmOFk4V2dPVXBRVU1yYjl1UFU3a3NTTk5H?=
 =?utf-8?B?bjIrS2g1MmlSSHhadTBUajdTYTFrQUl1NXMzTE56NWswdXVndEZ5MUpBZHcx?=
 =?utf-8?B?Qm5iUGVsUVF6ZVNXR01hbXIyVHdxVFVBRTErd3ZpQTYrbE9rd2JjN1FIYjdN?=
 =?utf-8?B?U05mNEYvSmRHRU9HVGNUalhJeVozOFVhUUNwbVJmdmxMRWVmREZuM3d5ZFA0?=
 =?utf-8?B?YmlncWRuWDdSRTFDb3pDSUdmZyt6YXdmZHNxRWdBOTdqK3ZqMlB5U2ltbWsr?=
 =?utf-8?B?alcvZEtRSDF0c2tqV0xEV3VqSmtwdzVSTmZMaERhc1dNSzE4UmV5eFpyWlla?=
 =?utf-8?B?Y1E5VzJXVlpRL29hdGNqVFFqcDdXSDh2K0h1MWgxZFd0UWQ1NE5SdXhJVzFs?=
 =?utf-8?B?eHRtYWpJaGZxSjVBNERVbWhnZlA5SUk2MlRrMkZKZk5vVlhTQ1hrN2p3T0Fk?=
 =?utf-8?B?dWFTbnAyMUZ4NTczOTV2S0doNkVpQ2FYbitLRk5XU3g1VTFqQUtwQ2xEWGg4?=
 =?utf-8?B?M3JUdjVSZy9ZaktXcDNzSlBVNmNYN2JuWTFiOVNhZEM2TXFseDNjS0phMkQ4?=
 =?utf-8?B?dlhwSW1QTUcyNmpFU0M0bDNwb1ZTUnQ1NnFZa05WVkdSOHdIaCtwMVR6Q0Ex?=
 =?utf-8?B?OTh0cDBaMmk4T3RiakVBd25aaTMwTnFtbVlmeDBaZDBIcmx5Qm9TU2Rtb0Q4?=
 =?utf-8?B?a1AyZ2NzbTZaUk1sYjIyWUVXUE81aTZReGxHWHkwS0Y2UjdwQ1VtSmZXWVFx?=
 =?utf-8?B?UXlQVTR1Um10MEFBU1MyUEZJaFhUQWcvQlplVkh3bDFOeTVoQWl5VHNCbG9r?=
 =?utf-8?B?UEFVK1hnTGdsUyt5NmlqMmhlSTRNZEdDdEJyZnNVdzNJYXRLRW9pYm5hb1dK?=
 =?utf-8?B?VU9TUm51YWJFb2FzSTY1MUdTQmg0T0lVcEkzSmJKRnNzY1dQeDczLytzcmhI?=
 =?utf-8?B?QlliSmdCbE1KYis4WFRIUDBOYWJWR2kyYXYzOGwvd3ovWEJ1a2RKN29rZExC?=
 =?utf-8?B?RktCZGRqdjI2U3R0WC91bmhQRDhVVjk4ek1vMHF4a0tLQm9JMXlXVmp6Um9l?=
 =?utf-8?B?S0RKNnVGdG1OUkVoZVlkbGFBUFB5ektUUXhvZS9rOXE4c2JPbUlidk9td21u?=
 =?utf-8?B?c1lNMUpoUnRjMmk0RHkxc0JVQmtiRWZJcVRac1krV3I4QmNQSHU0d2d5UXJm?=
 =?utf-8?B?WHZMZzJxRkJEd290UEpvdjcrVGlHUFZoTGd6aldFZTJKUGwveUpiTUNVdzRK?=
 =?utf-8?B?aUxoT3V3cUNNOElVZHdsa3JWZkQrWVorYklzbUZDWjJsQVNhMThtbmtvd3VG?=
 =?utf-8?B?RThHemd2c2ozVUJZZUVFeVlVUnZPalVZOGtzczFSajFCQWE3eFZVOTlTOE1X?=
 =?utf-8?B?NVBwVTFLaC90NlVrQWJJZ25IRkI0RlEzd3A0dGNHZFhtamtZVzdwWkd0SzVk?=
 =?utf-8?B?SWlQekVYQ3dpaCtXZFQ2dzlUNFBWTHN3VHJ3d1F4T3RYTkRnUGVack5QL2dz?=
 =?utf-8?B?QS9tc0JNV1A1b0IxUFloOEJ6M3JtWHlWU0hWK3l1YmdRd0ZGNi9KK0ZVZFZw?=
 =?utf-8?B?OUloSXhWRSs3eTBPbDMrSlJWNHFNc1hBeS9DQXpHMm1VSk96aVNJbExpNHlZ?=
 =?utf-8?Q?Pn4pvwCV5krBSGAMb1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4208be67-fc24-43ab-4735-08df395d3030
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:47:31.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNH95FWqqKYpt4NBSJJS1+nSaqPqTbZSohBPlsVC7tI7uJs8fZSvCCHGClAb9No5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEF61C0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nbtph7bqs9mdgka97ndpffzx7c5ne5k4
X-Rspam-User: 
X-HE-Tag: 1793677658-999763
X-HE-Meta: U2FsdGVkX1//OxW9ixD1lLvene6y1UpqUZLa3XgkuDQrRaXqFeoxefO353VSXuI+614nXQarnET2M3IGYvN94H1uah93+kcWSafdn+CEXNeXmMm7tfH/hTXJO+pbibPvh8aCEQOsYDXQHtPcWeX6JG3H90M3G/K6tU4jX13XthVEECASHYYUWBDfis/ohpv+2HEAaZm3JprXPgxFyN+h8RohIddhG/CJMiCc1M5UgXSIFfvl26wGcH53BNogebz7L/C+3E4YY6wfoII2GHqm7UMjW0kwlAOLm8boGKxNh6VaWHMq4g9QXN+ccYqemoRvRZCVV3LQ1ZThGICPSKLHCxg6fWoCbL/PFiS7EfP6zTjtI1u9AzCtrM5+DIVgfhrKQtj6Za8N79UoYNERdNqI1Lr7X6q6utCrqvgdcSXgdlUQ/Rne+zpvd4s+UxnzgALcAjWlD7y2jTI3HEV1rViUX82nsY6cLAgywZh1yOpGIwmNSCuoWzEI1SF9cariv4L2kuOvVGixFFCC2jb2sdIoRd9KFvtgojGdpc0Vd5WQuDQnK3ZHCY3FSNnXbmSntXrxIMxMhlPnh1Yi8To8I646UXzC/s47O15GQRG11lK1zzfxWFkMDe3DiCLf6TLpsiMveNK8+veYXNQNX2ossm3XLu1reu1V4S7rJcCn5EJmUR2t/u8P4LEjna6y7SrIr4OyO9jAtPWwLRfV7nMboLylXwANNkY+kbuTGG7mFt/m+xN6k5sGeSvILaxebXH4ePIZ39DZ6nOKOkrP4hCj/aoc+e6yiOxgrPpSVQ+F+sQksFUi67IpzsWfRRAWRkHL+7IvzCohWB9oWmRoHgK1wIPR7n0PEh7jY3y7w3s8Yrz9DXjbHUC4GBjnJLd4pBlsWVO5ZUKsvgdk5QaWmvy4uk5jFQkRDMo5VciQiVinfZVZdZZXXRCCgHy9kqRyp5r78tTaPrqyMYgZUY9bpMg0p2a
 slQiLQzo
 CFE9CWQ/K2DGoECEcU/JSgqn+s3U7ucDwNIINf9CAIasomgYeh4ray+3UNSPKQ2dYRhmbHRr/sHUGPyvBtC9e3yTyTjETV6wxCKSVbhjtsefAw6lqI1mOcLVrkFfxGPNx3/SPRUAVBFopIQ92tG5rj+nt7nbIHjPu/KGYzl+whmoaDIwCmjQ2FY3AOmNs5lGHZYtrYArqV+ifQgu55wzEM4r+EADsAnV8ZnMeR21k3JS+S7Zz73zE3h+reSzPb8AcG+TDd0hlU8mtNsHhccmUzGAOxcJtWkq5I7xdNPp/i+wF7XOHFJD3tsyotS4JLU5xV9BeTbfro7WY9SkMkPPMSx1GCXYwLe3uHrnFrJDnwPjoixYOFass8AXGurejYlOT03ZnJHFUAuJ/eD30mW6maYs+0KlK230QHF1Y97CtQI3qVFZ+SEGGRzXw1Qcbq4uwnCrTmpTxodejyGsWq/duyMjJaS7UmNOKfi55eGJJjwrbDoCs87jzO8BaFYciAF7RCV7d/CcQP6ZaFOlhBh3zlWZD8DTHv2/nNUj/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:54 PM EST, Tal Zussman wrote:
> The last callers of thp_size() have been converted to folio_size(), and
> thp_order()'s only remaining user was thp_size() itself, so remove
> both.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/mm.h | 21 ---------------------
>  1 file changed, 21 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


