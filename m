Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B1DC624D2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3043E6B0096; Mon, 31 Aug 2026 15:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D6B6B0098; Mon, 31 Aug 2026 15:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E086B0099; Mon, 31 Aug 2026 15:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D62006B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 489794022E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:08 +0000 (UTC)
X-FDA: 85162545216.19.A35D072
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7A60F14000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VUsQilxe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204365;
	b=2+TMNBBk4r2sQcXwe99sD1uAOT5F14sOfdOG+N3Xk8zX2fIFt4rTJ0dnTNSkr3i6MennIv
	c1w3OMRUD59GCbHiN4Xz0i0vmPJ0gb7YiRudF1rHOHwUOd5710QCxiKTxNlZi9GWamou40
	d8c6zf/khhEOQ3IHNWf/nyZRoC0T2n4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VUsQilxe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
	b=WgGG3fXhGmT98kGt8enPvczZPckdSzd6hz8Scn10IU2p/BPt79N85Nm7FGJM0TJqs9bFID
	MbB1ITPB7iJgqNmWqg2aZqEXg+HSQpvh7hnxal+CUgy97FRjxQzncXj67LCfKiWTGdS+oy
	F+RX6hVuE9Me+azxGTMotCXGBhC579g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4rsVKKlHfXh3l4lMZIUOgJlCbzBMk8CaSmABQHHUUg0oS03t4zSd986OjGRr/83HHbHzYdmfYAfCOk9wPgmSePf+59IckyOaWNIDDOy7sIZg89xfgm+SCO7mq3ZZtff1dJrzWz29NwwzCLTqDaLfnC9A9IEZzG4ItHBFNbAIPahWtEhySkA13780r6eFGQOs5F4y21kQ4FSNT0RWunzCtwoWZe0+WDP90HpseWdrswC5OnawDbw5Z/8zPtXDqVEb1DhtN2KmrNPo+y5TSLyWAmzuMBclII9nTFD51MyuV2x7qWuEJUnVoFZxu4+rusoWCDUnE1XeOLVdH+ttGwFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=c1pF6WlHeUOZjvTMZ2a9dKoW4IuFLkxUKxs17zLhHkhNV7OBdpoKZAvsh3aIWz6iD5h3rWOEI7Lv/agoHtayIUFdSRv7q0UiPsXCkXKlUauGc7qYkhPBn7CSHceG46w/jPWTxqB4fgUTnxl5KMdk8UQDuNO8ouGwy7XddGddJQB3HA/JJoW0mtkJsWJULkGh+ONPJHWaFsCNW8efkG3Hj1mefD60YL5UMT4s1yTJMfaOPkhJEQ+TNe4E0tj2YAySMGYwCzX+iiE8gXP95+fNUhPqkMrUy2bFc+wqp5bfLNAamFVYZXM6v/K4ZRVKZs1HArx6SN25MxQp+hVUYvWbUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=VUsQilxeQ3CeDti/jJ9ypcIEl9HoIaLBDvQyVi1yc6wnS5BujojGLUK89fkUjtkJTlWxYdZuZh1tpOQSrn2DVhyzzkFFqcUKy2sbap0WT0tMKpuGPHbWkYcFmlU5SUcqcU7wWV8xInvYvBbVBeGb1AeolcHInStGbcEG3AROrgeKJgQeIC+5Uy05XcK74NR1JPvsUYqq8RqNFF8BLu55Wr1YP8fjLUFpUYbrOlVGcXZpnd2X/JxeL2DzXwxQbemZacobPGLlWD+FnE7lSHOhsMUsEe8rPeEsvcyl6HdhA6EWNapTwtQtsa//zf4mKZgK6tIDCeb7X20azJIHPmjSZA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF0C60B25BF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 19:25:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:57 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:35 -0400
Subject: [PATCH v2 12/14] treewide: replace PagePrivate() with
 page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-12-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Ilya Dryomov <idryomov@gmail.com>, 
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 linux-raid@vger.kernel.org, ceph-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF0C60B25BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 2550fb1c-0298-4b3d-e2ff-08df0795ae4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	JH3lEVF9GXgssAzehBT3UTWIKt4T8maLh+X5fH/4Sa4+3ICUZG+JvlNdorOcUJy+OxL230VySQnWB/yy/9D2wET1VNaR2BZHWdqPq7PdAPb7mnH12U2GmSvEbbHhYGBxpMEr1jfHiopqblgeKofUEUnkP5h1Kjll4ZhfisJnKU0C4Bis4Gxt72kUEQgCHb1/XDGHWqvK/lgBU+nL6apX8y427SkeC2XKFzAWTj5MgkCWhsPLO0Tzk5lMm53cMvH4p07mszjCVb59Qgr/sHLZVWjsevf65Q55sOyZ7Bjp02FZv0jsQGyjW+dn7DCbeVgTlo/UJIcFWxNYI4pkafdR2xkVnEUXzENQ1a0mI1V8LqaiQhAYPUKUiXB5A84JwO3l4DWUT+7XZi618+E944lFoDuenFXyldjf20SIR8axRA8frW7Rp6Js3G8KNCsvVRvtwK2l/8vaGgmUBvanbmqRqpsRwq6dyJhgFuskpEUlmnQbHiyAn9qZzZOqR5050VKDMsknAJAnWr6muVEB0+d83tBlx2KBtXt1LGqaMQP/NTeX6GtQBsJF4Lq3exSuW20S8m9+mmc1PSaDXeMgZO8WWqMvOAwu+PtnoLywswaeZoNyJeO6jVDEfVihL16KWKaNzFTVE+TeGMGT2x9hxG3RKKqcXZd/hqhVwHVp9mdAjdKmsggHtp3ZCNbSFCvfcJHzjx18V2GxshChdGrp91efqQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2c3TkxIZ3N2alRhemJWK3EwYkpkelF3Z0xyb2NyUUh1Nm0wQ0czb2pHbTJ5?=
 =?utf-8?B?S2pzRWFWRk5pRXBsR254ZEh2d3ZKR09hUWJCZ0puUENNaFBzY2JuWjNWZklT?=
 =?utf-8?B?RjRiK1IyaEM3Rit3cGpwZDRjOTZUSVdCeTFHMGZHNVRXMThROEIyZEwvekRI?=
 =?utf-8?B?SG9Sd28wajBRQlpEVnNvb004Vms5VC94amhBcC9BSTlUM1gvMy9IdGlHb0U1?=
 =?utf-8?B?d2UzOEtSQzg3cFZ2WjEwNGhDQ1dic0VETkFISjZaK0JOSm1RNEdFZjlCK1pR?=
 =?utf-8?B?SUYvMW5TZkFDMStLaTNJalpSUVZhRUIxV2RFWkRJbkxRNHVObW0xcS9KcE1l?=
 =?utf-8?B?K3J0MVR5dzA4NnQwUlV5NG85QUUvc010V0JHdXlOTm1VV3FiOXlKSG01YmVo?=
 =?utf-8?B?SVJqNDRMSUhnQ1RGcXBMdHdnV0w5TzEyb2ZVTG9zZmZzT2V6a3d6REowdldX?=
 =?utf-8?B?UFM4d3NaM0IvdWZ6cC85ZWtJUDJNTmo4ZllWVkNseGVqZUFuRWNEMnVsSmdI?=
 =?utf-8?B?a3gxbm94d3VJZkV0RmMwajVaMjQ0RU9INElBaUlnRnFSc0N5YkdyR284YWt3?=
 =?utf-8?B?Y1NKVnFNcnFweGRYZjlreHVON1g2dDNydVdBQy83T2VEa1MrekdCWENlWXVC?=
 =?utf-8?B?dXhLMnNQWTJjaldWMy95RnBVL09CZk1ZUmVRSnRnQUhjVU93RUl6VXpZQi83?=
 =?utf-8?B?eUxyVjkwRTNQdHNpY21zMFgyaStyRjBhV0NkV3dNMndTOFRsa2pVYVVyRnhz?=
 =?utf-8?B?OTFSZXpNWk13NlhaQStTME5RUTB5ampuYnRLYWJra3hoa1UzQUR3QTJuTmV2?=
 =?utf-8?B?KzB0bnMweXVPcG03NUZPMFN4Q04vZldBUTV1TnU4MERYVUdsL3poQjh3RS8r?=
 =?utf-8?B?dUdyZkd6VitMWHQ0Vmo0N3FncFpvRzQ2S0U3SW5zbG9sRVJLRkI3blVWTFBn?=
 =?utf-8?B?SjZoVXVlTjdxa0FkMEJKeDhIZ1QxWXVjcEFJbzh4YXFsOUhRZGo2L1V1K1Vu?=
 =?utf-8?B?c2wrRTJ1cWF3SEVNR21TS205WFhrK1d6NGRIa09zY2FwLy9WK0xNVjhLaEFa?=
 =?utf-8?B?Q2prNlJSMSs0Mk83dlZ4NDdza3M2MUN5dmtReUVjR1ZQWHFLVitrY1U4Nkta?=
 =?utf-8?B?UHA1S1lOMEJzMjl2ZGZkMkhXVTA2QlBKUHlhMEpaUjJIb2tDcEJwNVQxbjc2?=
 =?utf-8?B?VkxNSHQzUGZwY2oxcTFOa0JhQ3RiVFdQVWNWemg5a0JRYnhPNHZZbWt2MTlm?=
 =?utf-8?B?RHphMXdNL0grRmJvTUN0UGNOUE9rNnlXNnpmTXcwSzFXS3dSanBmam8xWmlu?=
 =?utf-8?B?WUxiUHkvdGYwMS83VGYyaVpCcGxDaGxVNkNZS3Y4b294OGFXb2Z4bVpQQUJq?=
 =?utf-8?B?Y1VweXBNVlJXTXoxMFdOS2FodHdrSTEwdkZqeGtkSVhENTkvQ2RBaGtJM2d2?=
 =?utf-8?B?MnNzVkdtMUhnNkVGZmE1UmpDQlZrUkwrZElnOUR4d04rOXJjTnlVWXJGdzNv?=
 =?utf-8?B?eWhwaVQ5N29hNm1wUlM2bm5adlFZbmNYQm5OOGQwV3pIRDEzVTJlbjE3eXhR?=
 =?utf-8?B?LzFGRkUzcUlnVVRiVDJSeHdlM3ZkS2YxelpwQWxHNTUvR2tSQXFLTUY2NFJL?=
 =?utf-8?B?Rml1WEhmQUExd1dyTG5WK3VBUWw2VGFrcnZzbXpvbHhZeXRLS2Z6eWNuQ0xU?=
 =?utf-8?B?Q0tQUnE2YVdGVCtzTTVoNkxhYzAyYW5QVTh3eGl2eHUzQjhSZE0wUHdqM2ht?=
 =?utf-8?B?aUY2VVFhUVVFUGxtTTdxU1NFM1FxdnBWVE92TW5nSWlqYUF3SE4xMnMrVFEw?=
 =?utf-8?B?R2FjaHV2OXYzN250R0tzejhOb1pFbTZSMG01MEtwdCtFWllKUzNQVlRsTmdy?=
 =?utf-8?B?bTZZVlNXckxzTWhFUlRGT1V2QnNhMkFBcE1vVDNyM1hMMGRMVUpFeEd5R1FB?=
 =?utf-8?B?ejNkQndOMm52WFVKM3QwbzhDZ2xLTUgzMHUrQ2JQa0Q2N21aUmM0aGh1c2dJ?=
 =?utf-8?B?L1oxU3YxNnBPeEx0UzVock53SklyeWEvSWZYTkFobUNWYXo2R1JncTBtdTRV?=
 =?utf-8?B?bFpnUk43bnJQc0xra3VrUk5SY3BSSnpxV3hJNE1PcDJTT1pncTNEVGtzWjVq?=
 =?utf-8?B?dHpNMThJREdRNWxwYVlBa2dOY3FrQ01zTTB2S203VkVBNWEyTUR5NyttWGxj?=
 =?utf-8?B?endtS3Q1UlpFeDRZTllidnUxcEFJblpQcFIvVzVMbnp0U3FVMEx2QWxOaHpR?=
 =?utf-8?B?ZDNDb0RVU0U1clY1LytIOWkyVVBLaWEyVHBQU1dsMzBLTUhJRUhNaWp2bFly?=
 =?utf-8?Q?zEHfdWQyDvb/mUF+RC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2550fb1c-0298-4b3d-e2ff-08df0795ae4e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:56.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ByVAZ8Vxubqa6jljEwUkIGzOk1lV0y8b2Et+XbhSlyi9msTbhRc9DbcEiNblmprq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0C60B25BF
X-Rspam-User: 
X-Stat-Signature: 11sj1dnjujw933jr6un975dtf6wq1fsy
X-Rspamd-Queue-Id: 7A60F14000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788204365-337286
X-HE-Meta: U2FsdGVkX1/Wq+IC4wG+QMDbrqH9pWNsW6THaRun1WGMFUY8e0krvjpuIXJOdAIOSA9Yee6LoLAR3LbdaXDCQ6gOl6M+Rd/wpbOhg0JwIamnvXr7LCB02BdOECCn1fiRecH6tvGgMfuRLi98Fb9sHT2BLNEuGDGQ4kjlhW2H+PCIgL+++pnlgbcJLMixY2DhgvD1QeKchV363Bori3aJuRTNTrZOsmBfk6ZDLeLPuOclwuo5UZG1uEV8SbKLpV17jSGzA/y18qa/QFB6USLaP83yenfhsf0re1M1cRqfonyRZGctnyFsvfDfxYKCC1M8Yg7ls7cW+6WL8g3nAucoQZmGb94hWnjVwmw7zFm5qm1+ykrQPqpXoR9m2MKHl+WkHeEJ8oNImp+VCksx5VtUSN9p09rcQ5YWuzbcJwZBRu8x+lphafHUkRCNqvkwkNjG4ZQRVFPCxc9nggoGmvawsSrHHLIPzqtmytH4RChLxfnyOrY7NXD79rwxtd/GZR8CgTgRbCACVPT61WbsZFsPPL3Oi2R2YmkM2KYTuMMW8Qcj37k9mrO8Lcryu1GGNZ+9Tg3neHBlZS3CR7JDkvnvWcK5leTtcsQRfIt/8B8ZkhvZ8TdxOdujWRx5LfDS1EvGitaxF15/IxS9uZ62CUyWp6AFWBAZSyj92DHjH7l4TBhAsh+aD5MIgbBzyxwlf35qQsXy1CTPMsqdwBJwqttIlQRkcw7q+RoJHrf94ZQNyk2LV1TLs1DgUvZcM7mKgBITvYZZHjcJSqAt9SIsKLl27uGpqU4CnvmiTaxc5I+YgjZuzvVemS1YRWatE2bBx5nisyI06PPQgV5FyWSZU13xg00fN0I0Brasbz4g1T8Jwhbb1XAZ2Y5F49kTj7H/LnqQwJL3xrDWqv7CQ6Gp9asriFYy9svnUUhYez05wvmFWqDjJWUOrNhKAjjKX3GfotT6dYV7RBXjr4vlt2pR30C
 WzHnZjgW
 jEae6es/kNf251dsiDbADPRLPMd02mVwJEbcFsBVdNnm0aYxUdbtgekprI+/3qJqHWr72sES1j/lep64oL6af9Jh6vgLzZDJwn0Z98atE/WJJ1w0osKQR3rgX2bxVVOILRWWmVeJ3XXyyBKcxHJjUuJn0b/egFXNSk16qY/uUM3WbS3Z/Z/toTtKCIMRNfgYsqPK9W/Rc+p7YD2gulSarCD3jOviTvsaL445NIINe+0DAv5cXEgeuataDe9NmabUAUeseh69EY4kTIqrpzSx8XDnxsqazUHjdubJFSu2YOtNaqNSeoasReuoj4NEshfVHVl5oPPauxGexuFb3bWQMPR9NjHNUvFlE/VrbOMyXyweT8o5UCA9mvzDHkURqEQ+YjqMJndPGY8WrdF315Tnc2dbSrdstsgw1TO0qgY/s90jur5qRmWs1BdsMbiySx5+tGhSN25V3/BpoO3bnFpVBgPcWfltaAY+rEb6Z7/ECbthstBmJyFQsR2m91eFZnT8JqC3o5toML1VdjmQZFWRfqzcCQnbfzyO6Uu2WcAHBvw01wcCLmrk7nsNImgn+86WJ7hVymyLJC03BdZwlelhGrahe0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PG_private is going to be removed and its check is replaced by checking
page->private != NULL.

Replace page_buffers() with page_private() and delete page_buffers(),
since only two users left and both can be converted to use page_private().

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
To: Ilya Dryomov <idryomov@gmail.com>
To: Alex Markuze <amarkuze@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
---
 drivers/md/md-bitmap.c      | 6 +++---
 fs/ceph/addr.c              | 4 +---
 include/linux/buffer_head.h | 6 ------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a371..0cf14bc1cff32 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,7 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
@@ -535,10 +535,10 @@ static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
 
-	if (!PagePrivate(page))
+	if (!page_private(page))
 		return;
 
-	bh = page_buffers(page);
+	bh = (struct buffer_head *)page_private(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 657c2cb0f8811..fad17df1d5082 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -70,9 +70,7 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
+	return (void *)page->private;
 }
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c0542..e47fbd0387b69 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,6 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,

-- 
2.53.0


