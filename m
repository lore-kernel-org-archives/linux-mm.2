Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2123C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C804A6B00F1; Sat,  8 Aug 2026 22:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C310A6B00F3; Sat,  8 Aug 2026 22:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2646B00F4; Sat,  8 Aug 2026 22:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6787A6B00F1
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:13:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1B27404A4
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:13:51 +0000 (UTC)
X-FDA: 85080110262.10.06A25CE
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id E7767100009
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:13:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FE5OXCVP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786241629;
	b=sdHTXcq56pc0De355h4afWGErdzkJ0Fjz5tJkd0dtvBzIcfEBiGmnbPGdAQAYiyeZ1uwrj
	tgBtO/UjEWfaF+bibKWpYHj/RVa3AELVz5pNdK/x9ad1FJ5NOOTlgiDBMQd/hee30aH4Wp
	JbXYw7BVE91Ykcc73E+wtMdUBjefnVc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FE5OXCVP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786241629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYv1owtN6WG8u1HH/zEzuFsr2aA7zZFGq8cnkYjHaFk=;
	b=KR52KwK9WiYYG1iaWo9Hpy1zHUjdZtUYasIzpXO6oeNAvVrNB9FUCP0nvBtMKmWZShZdhl
	NVBT9XapM3SazoVj4SkuL6xOPOvZOZRBsEQLvfnWjd18b+Ksv91/Mj7ghvYxO59VLJILLK
	+j9jtX2xmPMofg006mwVn4ygF4H0VM8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQUKEyKUrLkaPIRoW+Rw5+xnBwwbCgu7F8kzGoTCSm4U22wvNc72E0LW5qFo+4lAdFZ4lBbh8A5avyU/JOgY1Mg4UQ+QEjqGIKxcfaTiKjrD+fDSB4j3v0GdS39MhCYcJmwafxt+UzzwCnq7Nhj8O/A1hgqCTweydVx9Kvi6u1kmzjyJNIOMTqAXXDdgU4l8cSac9sRJY/zSIj5MDzWEjWily6o5OpWieSvusNWtLFMQRlmnIpgT2Xq3vT565JIzEC0+9MlalWGpvdVq+Hi2LeZC4jrNJPUDpvf/aM/WEmU4nD7O8YdSwaQvF8+oNDJiGl8eLeW84kmPwhfhAETlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYv1owtN6WG8u1HH/zEzuFsr2aA7zZFGq8cnkYjHaFk=;
 b=yTtieERlsaFfsaBallQnRdVbL/coxMS/6YV9rCW5gm4cpAJTln3wh9/eRoHfH8tDm4YAxGy17jzZ/A8zIRF4PMt0MQFJU9A82h/+Ew1l2FEDjbWrefp0bBnSTfglTbfoCjfcXUqtpefWE/1EP/JXDBtaNsndWYSDfI5bd8lGP/fbsDytrawxq2HmVpjBxw0hzOvMG6vjewgoLuoWAax+FM68YRrYYfoyiTc7opqQiTpC3j0IigK44g8/E/IAmMHqyzhGVvKQnUeSQYbeTJLMa6Sesx4fZZj4oDmx361Od3cFDlcNMRwGmEkwNiUYRFZtVYG45L6tf22Z/Kun86Lvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYv1owtN6WG8u1HH/zEzuFsr2aA7zZFGq8cnkYjHaFk=;
 b=FE5OXCVP5MtrqTQRcmBb5TvlCNiqNr2gnAGL7kYZxyOtaS7U7vtiO7l8f/8++LbnoL+amQN5Q89QfrXPMJVHeZRetNuIqRju4FMhFxUHgWj9itMzAVoKg2pt/nkmKK7EE6nYkzlHPlAk+PHlEJX5KSr/thQyOEZGSh1GZ4uNg0ku+FdWeqcDh9WbJnGjtanSeOh1da+kowcX0KMTKEfSb21BdGB3E1OC95Qaj4SxqpaigywL5j3IaHr06zhMZtcbEaLCCJpO/Kk1VAPPJLMHvdQ73rXfFKe1+lyNV/2eZoFn4MdRSbxD2oLP5Ev4sbIKDmwwOIq9CRe2oLFPp7LPGA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sun, 9 Aug
 2026 02:13:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:13:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:13:40 -0400
Message-Id: <DKK1T42OYTLU.2V7NFY0A1KC8T@nvidia.com>
Subject: Re: [PATCH RFC 07/13] mm/huge_memory: move unmap and remap into the
 split helpers
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
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-7-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-7-689939a7ccc3@tencent.com>
X-ClientProxiedBy: MN2PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:208:239::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 69f08edd-5428-410c-10d6-08def5bbd504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|22082099003|18002099003|56012099006|10067099003|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	A2UyQ5LaLY7o2OLWFg3vViK2qKOPAddXev4La0k6mKg9i2pxpJUrKNxC96axze3Ig3dL6OJjCtypeUcClaNXQWWDNO+LcYzxpuwbgV1KUTH8qEjqThaybm0soyC4P+yyy9LMldKzd2G6i1SmlWNMEasgL6r6Uaj9Xf2E7dgyfG/rKeAvTCm5KRdQkaFg/TP0/BErmARLHsOxJwhRS7GvMwP54Z2FD1TiW2ixvj7Teq80sr6z5jth09wA/m31XMY7qQEZECKfdTrUlLI5urHyredgCgRjVLTMK1SviD3ENbJA98otE83uTg0w4qBIwUBB2CCvm0LQclzEIb4OENFAlQLtGU105TEzvmCdzpr6i+GKDfNQ9Rq0OQ30yF0xLwq4ND/0R5Fn6s0ElgSWacj1RU4oXC1RpRTSrNhsV6DMZockWi6d1DOqGPm9rxlXyym1PUxod2ofUzAi02mgaWnkSBbtbTdxAHcGUTOGBRMu68xrI+mFSy1bOKc/g4c68zZ0PczS8vAAGCuTPKedRIJhtf6Zi+RVfcBpUAL75fx4xWa0z89EtdLrbiOoK+jAGbQ9Titwv1Lnojk4pF7cwTNUobDt+cEg0K8HOve5J3YwQLxXKN1I0YO86r9t+pDZjXLMCwZceBejnMIFvyTu3pjXX2iJ+PNKWwEdt/Om+iWzj7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(10067099003)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1lYejVjWmxmVUdxK0c2eEhoempqTjhSL1Z3ZGlZUFBPTm1NREg1UFBBbWli?=
 =?utf-8?B?SDlRRzlDTmJzRXp2M3VrbVNZZnRlZk5LU3hqODVaT2Q4M1VmZldxYzB4WWQ0?=
 =?utf-8?B?L0JYRGRicGNOVFAvTWtPa1pSUURpOGt0RHFOR015dklna0gzUDFHb1IvVnhu?=
 =?utf-8?B?Qnp0Ny84RWd3WHRyc0RPUXBQT1RjQ3hPSHJyYlZPZm9zeDBwVFFJc0hnSHhV?=
 =?utf-8?B?cmFtR0lqQmttVmk4T1hFeEhSL2tRZmMrZmUya3ZGekpWQXprTXNid01EWHc0?=
 =?utf-8?B?c0Vadys2Sk8vU2Y0Yy9vc2FSSEZ4ZFJidHBQNk41eFRWZDF6ZjJxcVdvN2dj?=
 =?utf-8?B?VFU5dzFoNVA1cndHVGFZcTlsQlRkZXp6dlFpTklWeVRac2xoa0lKaVVLdFNG?=
 =?utf-8?B?M1lJSjN3QUFIRHR2OXNIdjVrSWdoWWhZaGhYM1pUa2ZaSTQ1bjB1VFlPMzlw?=
 =?utf-8?B?aDlnZ21HY1ZYUzFJWC9xRlhMQmMwZkdnNjQySGpaTHZJWlZoS0xEY21WTGRS?=
 =?utf-8?B?cUZhaDloR2E1SGRrWlVXQUQ0VlR1RTVzYzgwTGxBRlJFQTdEUnJYaHgzYmR5?=
 =?utf-8?B?TzdUV1A0VitET3FsbjhoVUZhOVBZVU1mN0xJbW4rYVU4TnI1K1dKejVjTTlM?=
 =?utf-8?B?U1oxNUVDR2RleFhCSHYyWVhMUURoR2RLQktXbUFzZDNUNlk1SXBLMXc5ZUNT?=
 =?utf-8?B?bTBISmc5WUNaMXFOYlFsK2hrRllNMTY3MVV2UytUK1oyZTVPVEVkUzFlVGM0?=
 =?utf-8?B?VzFjOXROblRvMU9VV0dSanRycDBKS1dIaVEvWUpMSTJWRlkxbm9MM2VrOHBW?=
 =?utf-8?B?MldQZUtETmcxak1RUGJYMmU5MlNUaFU5djRhU3l5eEpDaS9NVVhFRk5lM1ZD?=
 =?utf-8?B?Q1I0NURzNjVqWnZ4d3d4OFhSbzVwWGFWVkFsZFdvdUNrVUpVS0F2UWtJSU4r?=
 =?utf-8?B?eDhkL1ovWmVCVXNUemRqRzNPQ2NqQXR5UllyTWt2N3hoMU84bVk0UEpSSngv?=
 =?utf-8?B?V2FsaGhiWUoyTDQzanI1bGtPUk9RT1VneU9Sb0tpcGdPVURBMCtGd2JtKzUr?=
 =?utf-8?B?R2hzSFVybFY2K3hxNFZsSEhHbTlxcHpKNm1rTjR0Y216TGxJL2c2WlRyT2FP?=
 =?utf-8?B?WVU1WEdwTGxsUW85bHpuOERIY24rdE9HNC9TMjlaeHd1TWs1QzNuZTRNSFZq?=
 =?utf-8?B?NU9oZlBNSVdGdm9BNG10R05vZEVlZFRsWjk4OXVHQnRnR3ZNMTF3eFVoMmlL?=
 =?utf-8?B?c0x6VWZDRkhzTm9qSms0NjUxWFlWUDBtd3dJc2Qyb2U1Umk2Vy85MlhHdEdj?=
 =?utf-8?B?NmU0TW9MOTNYbFliWExMN3J2cHUyMmZoU0ZYVW5CdmlJaWw4REhYS1NleXdG?=
 =?utf-8?B?Y3R4TkZxRHFFbkJDblg3NmFyditJbTJPZTlkNVVQWEpTYmMvMkdzQjliN1RI?=
 =?utf-8?B?T3pMaEFHNm1XZFl1a0s0WE9WYXVVS0FtUlVYNFgvMDlydTN4U3VNTWU3bVE3?=
 =?utf-8?B?dGNXNGdXZzhsazFwYzRQUERJTlNlanErVUV5TDlxWE9vTzhUdGIzWE5pejlI?=
 =?utf-8?B?ZjkxUTFIcUhNWjFwYThRdk41NzVINDZIVCtQaGtkTGwwQXdSRmNCQk9hWnJB?=
 =?utf-8?B?TURrOEQ5b256WVllV3Y1dC82V1R5L2NDVUN6MjA0TFZGZjREWC9YL3BnemFp?=
 =?utf-8?B?VFh3WHEzWGVlTVdkRXFMMFRyVGxzY3lSVHd5SDE5bkljTjhxb3JBSm1ZaENx?=
 =?utf-8?B?Snl5V1JKaUFOczVTUUpYemdTVVNVZVVRYlFOckgvV3kyK2s5RXdtSkJrSjZ4?=
 =?utf-8?B?RUI5cnNMV2hpRlRBaDJSVloxN3hHNG1vMmJVakxHTVhQaDM0YzlDVko1cEZj?=
 =?utf-8?B?T2FpU3RlVGg3ZzA2VUs5UFBmSDhIdFFXYkxaMDJMZDJwT2w5bUhGKzE3dWlm?=
 =?utf-8?B?dHBnL3M4aDN4c01TWmNnL3NSYUtFc3d4L2FvWDVvTEJrS3dtRGNINk1tbjMr?=
 =?utf-8?B?T3dsVC9Gclc4eHRQRzFub2lGSXVCVUl6WE02QzJROC9NWUphZUR2aVRleklO?=
 =?utf-8?B?NXBSSUZlME1JWDdDOE9NRHpMOTc4V0xTSnc5SUZGQ1FZOWZnSnNQdnFUb1Mr?=
 =?utf-8?B?ZURpWi9lOUN1T3ZuSHArN3p1bWE5dFp1Ry9tTTg5RXdZZWQ1dmZHcGNEeDRX?=
 =?utf-8?B?cTFRNXN6ak5YYUdURXFQZmpnaklXc0hWWWlGOWRGNlVsM3FWbi84VkUrZHNz?=
 =?utf-8?B?N2FGUzFwUlJVRkU1eHNhZlJrTUpyM3h5a01Udzg4U2pZT3ZoYTRiWXBxNjVl?=
 =?utf-8?Q?xSjWN0tR0N7D5hiOc8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f08edd-5428-410c-10d6-08def5bbd504
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:13:41.5439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7jUrfLUYyE0FlgjhJmp2wv2oToUc47rwrOv4uBjZjODbc4bPCL/N9vljz/TheYI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4338
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7767100009
X-Stat-Signature: pw9qddwqyhr169gdjqhi11sajt4kwpnf
X-Rspam-User: 
X-HE-Tag: 1786241628-893525
X-HE-Meta: U2FsdGVkX1/LFT+KXuNQjTYg0MEvqtaPPQayNNZvCZFqqj52MJzVytp2LM4vUM1h/8sYrVTs2F8kYDFqFddS7pPXwRWEvUCHJ3Jbz/ePL8PF+8Jv6KGxoF+wdKdTIlovnp3hfpihSYSEvHl05yK5feF6jA2QkJu1Y2B3yONMTkeaP7n7PjEiX8KVqMvFVGF6TUjC5rr/pH/o74D/fVHIMIh1wRaSx+XK3kIF86ilhawrduQFLXSEQrNBOLsidE197J7GWSJe/a0o2uEcY0rNsaa/CtahEVaKJvdrfnU4sJ2ZYGRlEbR56EJssGbaZzIzx9f7FL8igz/gBKU49rk3enklaP0KHp81u/WeqDJK+c8FSGB5whPYKreioePRr4K8PpAXzrFmvyx/i7AT/KCj3Eo9Trs+vF8RCBDjd002DLiOhgirs12k6GpvG0dKVoS+Z+jCRYDohi4ODRBUbnKDRp66K46YwR+/kQLkkxYYqAqpiuRdSKWVJterAZhiwMJDBQPzHMjPCrxcZKebJgCznSUdwluWnvHSQy8b/BSJ0+TLMXim7+fUhPVw6uEBRen1WqcCsuS5y6o1TqFKGJ5EJIy3hnZTzX/fEpgX72nG6O4mYjRYPQLbgJkDIs9eI5AzmHi3tyeRW+IK9xFSMAvXCGziYFngnUYqXANmklSCsw+Sw9Jhj0+6QVD6M28jYMOmM/KX5S6d6aTy3ywvhkb+eFEE2MUWGpuVa/619Y8II86erNEejHAW8+S/Ji201lydM8rYp/WG1x3z1emB5cVFxiIB+ORyPLLbvDnWSVaf8Xkzz+4BSmCdKe750tZABi2ONiu6GrHJxPDkikJSWWBZMxYofeWefzBJt4AEPl22bM6Mwb5AMt3YJmzMeRbvo7dEr0XydlzMYiQy0cK06hdyxxni3F5vH+dassHDzbiqxKsQbwG7LeMh1wellVDU162X7iPYd7688T6wQLa/a09
 ighCNdqV
 +9Af8KkbbzSHyBD0HVIuExkqJVzsib7Rd0HysoO3n/BFS1ID6Rc2sCe2FYZl0XVG8DbAC6++D/Oqe1HCaZnGCenOeZg8n1g5lWQym2e/RjaadC+QV9x3sBaSA5vrpNV8FC+iysjPST4f4MfRmoZdntW7XGw6N4u5UXxpMO6spOJ5dVwSIKfOc99JZHSmbX726Eg36q1XPsZWkJfy71XGnEvl85TO/+fcn9eTwg5DYxPHnkgrFTgBy3ZlfRWG92VbTY0iu6qSVXPrL/4ECXo3nBz+ucWa6ROVF0qL1ONIbqN8Q5rLdakx6ch1ljwouX2i+jqLQ4sUvfv40fxusiIi4543Sduta7OJQjipRa0iC0K21wIssPBtxVI3Og5M6VMSemqFDYW4PsN1hLzM2XYi3EdSYTEd1NdIaPcXOxadD7tZNJJi4jJ4ZZOfx72GhUSrTclN/KRBI0uGeoqXvcTbZPUr2lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> To prepare for further cleanup, move the unmap/remap handling from
> __folio_split() into the split helpers.  Only anon folios need to
> be remapped, so remap_page() is now only called for anon splits and
> the anon check in remap_page() is redundant and can be removed.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 51 ++++++++++++++++++++++++++------------------------=
-
>  1 file changed, 26 insertions(+), 25 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 72f5d0d24127..c0115841d1a0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3589,9 +3589,6 @@ static void remap_page(struct folio *folio, unsigne=
d long nr, int flags)
>  {
>  	int i =3D 0;
> =20
> -	/* If unmap_folio() uses try_to_migrate() on file, remove this check */

This comment is lost. Like it says, if file folios are unmappped using
migration entries, __folio_freeze_split_unmapped_file() will need to
call remap_page(). Can you move this comment to the end of
__folio_freeze_split_unmap_file(), where remap_page() could be called.

> -	if (!folio_test_anon(folio))
> -		return;
>  	for (;;) {
>  		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
>  		i +=3D folio_nr_pages(folio);
> @@ -3934,19 +3931,23 @@ static unsigned int folio_cache_ref_count(const s=
truct folio *folio)
>  	return folio_nr_pages(folio);
>  }
> =20
> -static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsig=
ned int new_order,
> -					      struct page *split_at, bool do_lru,
> -					      struct list_head *list, enum split_type split_type)
> +static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned=
 int new_order,

__folio_split_unmap_and_freeze_anon() might be better?

> +					   struct page *split_at, bool do_lru, bool unmap,
> +					   struct list_head *list, enum split_type split_type)
>  {
>  	struct folio *end_folio =3D folio_next(folio);
>  	struct swap_cluster_info *ci =3D NULL;
>  	struct folio *new_folio;
>  	int old_order =3D folio_order(folio);
> +	enum ttu_flags ttu_flags =3D 0;
>  	struct list_lru_one *lru;
>  	struct lruvec *lruvec;
>  	bool dequeue_deferred;
>  	int ret =3D 0;
> =20
> +	if (unmap)
> +		unmap_folio(folio);

This unmap parameter is to accommodate folio_split_unmapped() and
counter-intuitive for __folio_freeze_split_unmap_anon() this function
name. __folio_split_may_unmap_and_freeze_anon() might match the code
better, but sounds ugly. :(

With the moved comment, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

The function name is secondary.


--=20
Best Regards,
Yan, Zi


