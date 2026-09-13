Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6BFC88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 16:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38286B0088; Sun, 13 Sep 2026 12:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2116B008C; Sun, 13 Sep 2026 12:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963A56B0092; Sun, 13 Sep 2026 12:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7AE6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 12:31:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 704D2A086D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:31:43 +0000 (UTC)
X-FDA: 85209280086.12.BEC8285
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012065.outbound.protection.outlook.com [52.101.48.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B57140005
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:31:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cLUmRO9e;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789317100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcUk7lnoBp3qYGPcoRMqwtzz0Mg2qBrQv8WS+cw4l1c=;
	b=AAbAAFioCuUvNPHIBrIr8FC0uBcSByZj2M08S/UbYfKehGS7MQmL5soFu2SZbZoJY/UN2P
	QB1gEuDQC/I+kboBRjHyDF86HZTsBHWDKJe2Tsi0uk0G3G0OcnVmyqN1xMDr1KSBsjZJt7
	UnIztqZ2GWKysA8/UVRqjj1814cLVTs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cLUmRO9e;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789317100;
	b=WD/2sMPQVs393P8RPITPV77OrnmSl5g6YFPfrd8Fbk1YHgQWgurZo5iU4gGf/4cHK/0gU1
	B1RU4/Olii25F29tS3FDdhZQ/do6RU6tIQZLERoThrxgfuvUI7e2b/fIT3Fooyjqcg27h9
	q4ogvTt2yOwypDpGmw00Zz/kHH6LLRU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKjXoy52MnI5ZuRfT+Jd5UCLeFMrkxI5fyVNSuHUeeiVFdx/oMHDA0QSH2n5iUOjHBwY+e10CdL0IpKBwQS6Lqguoi976B+qOGXe9mMycVBx1I0+eAIUau/Lj1Z//wSjkxmumbpCTgQWpTuqm9kK2d/lG6BnQYIM4BxZCrYZAX5J0z6TNFR1d4dDmRZxo6wrUDaJutVcgZ/LorxmQ/7X23x42PQEyZX2O48N8g0dtqflnDL/207HPRzIT+V/cCr+DMBz+ydgR/gjCAvig8fvUAYaRTc/JWsV2D06vDpPWWZ2OTN2Ofo2fG33IL7ksJjnKPLTYmqWlu0SH4mbZRK3qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcUk7lnoBp3qYGPcoRMqwtzz0Mg2qBrQv8WS+cw4l1c=;
 b=oJ0FrDl4/rBEX4CoZMEkAYrfkzkUd4xMIp5d4JbDvTbq6n612s9DVq3KKYrwhW+DtqEuXdmryeqVJZfkQcrXMIjlhuKi5Ifi7zehme6ydgsyIVaLdTipEMDaeT3io4wdvdGZtza/cuhK+nV6lxIE6JFT0aeB/k7zBfgkvI8WtN1BS9isxVq7rJDp3r0LIvTv8ykoIoqhVecRwU42572CAhO8MpXdYjDY9x+z0Y1UwiWJoBu4Ytb3jtjOldQ0MqA1HCKOjDLV5DOouti66+rguychYITn5R+vtpJlSkx2aqYGwh8vv6I0ThyGnb85Mn0nloEAWT4/P0412vIm49ifFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcUk7lnoBp3qYGPcoRMqwtzz0Mg2qBrQv8WS+cw4l1c=;
 b=cLUmRO9eGcrTocQmNah8cZ9MmH655vS/8oghCRwEa9aYnSQeAgqojJp+N/IugeVv5OtvVIr7U/s7urrfPREMRJSFgD5qsmqL+DRtdHWkjvNVtL2Ocln+Sfo1W865qzGGisPStl2d1H/vOhj7mPuAQ6eYx2podZyJ1FlP0Qu5ZwnlFEYdnjTheqAUR71e3tSqgzxbVVM7/n0iNgLLxdtTRVi0Ak9rFENMIXSTqAjNax9c3eGuKC4KvbbN148YaJCUqOdnGr3MYfdgahK9N8dxwIrnTAZiYo4tXjiNO6vJn73xDJYl9ChclakVhMpUG968pf/fzl3T2Yzy3wNx6RUNDg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ1PR12MB6146.namprd12.prod.outlook.com (2603:10b6:a03:45b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Sun, 13 Sep
 2026 16:31:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Sun, 13 Sep 2026
 16:31:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 13 Sep 2026 12:31:32 -0400
Message-Id: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] khugepaged: hold invalidate_lock across collapse_file()
 readahead
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Nguyen Ngoc Thang" <ngocthang2710.1999@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Pedro Falcato" <pfalcato@suse.de>
X-Mailer: aerc 0.22.0
References: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
In-Reply-To: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
X-ClientProxiedBy: BL1PR13CA0387.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ1PR12MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fb2ccff-6314-4fca-91ad-08df11b47938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	rffBiPJr7Q8JSFIuMrew8RoTWfc6TQMzmjCqEVljYsFbuDZLAw7z0LFuV5u21O9OENQS0wFBb9AZy347D+k9YhOTuJiSBBwv/Syi/kM0qE0EHQ1K8IDsB9Np9Q/mvtfePXtToKBLVOSw02RIAupwUJmbloTmDbgsVVxFbuY2bLB7KFB1f0H4x82st9Q0dHjz4hiFAkX66HfUxKaLP31/N4/wAJqPA5RUHK9GB+8n05Iwmj71KRwysaLszD99fLhya4UmojpG3kdFy+Dh0HI1acjGWaM0FV2c8zZQSr+ap1wq/+SSJA6XhNvn3WoX/RbNfHOyGj7F+shfsl/7YlJi/y+zzNOoylfPxXlf8XZuJmCZqhPtl54cibgnjDptJITWaT7i9f9rr/wwYtJ75ExZVzISB/4hdVJrxvhjN/3R9XvdaeBrKK0nRxGVTpD6Ch2XGrt1E/xkLi/k4Awo2dpE5zp2TFFm+FzCtSxCJNbhRSFjulD1d3nJorOvsnJy5956odT/g3eJJq1ObPL8AwZgMJDQ0L2TlXjmMngajzWXEGOym/lm9NmWYWOjTFUPd8pm94UdD4JGHbzuND3hvapX0kGQ45mRYEAbssvT6EiugFf2/9ZbOjK4vXp1OuEER1aBPpBDkKJFGoCS2XTTQvxHUnL97vngUridaU7qCFTiA7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkgxV0JrbGxwcUlPQm9ibnFmK0ZqVDM2dElSaGY3REg4YU5WNDdsV1RNWUZx?=
 =?utf-8?B?Z2ZSUmhmVGlZNnlSTG10QjQrTkg2OXRmZENiUDNjUFBxcFV1Z0RuYkFaOUw3?=
 =?utf-8?B?Z0xCcDkrKzA0czhZZWFHTzlCMDBOM0J2M2wzTDhYQnNMT2NTK1BEY0VvcEFS?=
 =?utf-8?B?Z2djQ2V1OWpCS1d3cktjVkdOb2xmYWU5bzFabG1mSTJ1OFBJWk5tUDVDd2hu?=
 =?utf-8?B?UWZqeUFGZjRuY3M4b2xCWGJmTTAzZDZDelZEcEF1VjRjWFlPR3oraFMvbnQr?=
 =?utf-8?B?TFBxaXNsQVlsN1dBRFFOSUkrYUZKLzIzeHNtTjFPSlBFSENnUEV0MFYxeEdF?=
 =?utf-8?B?VVBmN1dtWWluN2p3WWpZWmpuUXdSdzg3M20rTTI0SXM2YWQwQUpwUEhTTlk4?=
 =?utf-8?B?Qk1Vc2U4UlpMbFdTNjZwSWhQcFdLclBZT3V4b0R3OW1BekRMdFJsR1JVdGZi?=
 =?utf-8?B?K0UxaGxwQkxsdDZINVRkNGtHTkhqM1VKQ2ZJVW1JZnpmVGJYdTYyUm1DY3pK?=
 =?utf-8?B?QkV5TjcrMHBjOHFzZHNZUFFtbEZ5Qy9zQ3lCRUVsUndaejc4MGxTaURxcFN3?=
 =?utf-8?B?b2hIYzhFeDB5Q2lQZG53NVdUU0x1NkhUbzUzbm9TVDJFb0N4cElxRmR2QkNI?=
 =?utf-8?B?Z2c4SHNXbmVrUERBclhtQ25aLzJNRTBBb3dIQlA0NjlDc1dWSXR5TUkxZWVZ?=
 =?utf-8?B?dFRHSFl6bE1pcUJVVmVTWHdFemsvY1VpYVFWeGh5b0hIWHk5YkMwQlJpL1NI?=
 =?utf-8?B?WXlkTnY0Tk5DT2JaMTJwcVZTY1pyK1RzUmlXL2YrQkdKcGRqeEZ6OEwzVnlQ?=
 =?utf-8?B?NktMd2JlRWNERzg0OE54MWxoalE3a0tIMGo5QXRxWFdCM25QTHBGSXU1aTRE?=
 =?utf-8?B?Smk4dkt4R25NbmEwMDQ1MGNyVUZZVnhUOHpjM053eXBIY0R4bGVsc1hzalJZ?=
 =?utf-8?B?NFgyL2UzaVpxM3JINEM0MG51ZEgzREppUE52MjUycVBtcWh1ZEQvcG1jd2ZQ?=
 =?utf-8?B?eGZwQXMvaXltZUJ0UVNjSTd6ZWtmbDk2ZTNRdE54RDkzWVBaTjB5bEFSTG9u?=
 =?utf-8?B?U0FVa0t6OXlySDNqeGRtdVNtcDhNRERsQ2VGTmJDTnh6Q2l6UnhDZWhEcWVy?=
 =?utf-8?B?Z29HQ2xValp0UUhya3U0YVRpOFgwV0MwNHZqUUwyY3g1bkRxV3R6cnc3OHBT?=
 =?utf-8?B?WVRzbHVDbXJEUjVTdFlIa09NVnNkOG5Ud1RsTzdzRFQ4eHFJQ2hJbnNRMDZz?=
 =?utf-8?B?RVFweTNYalI0MkZVeHNkeERjNHJvd2x2TmZ2S3MzTEpjTXY0dEFlaUJWcE5t?=
 =?utf-8?B?RW5LWUtRVGZJUkEwMUFmaEJrLzdKUUdQcDhIU1RkV3FRNE9acm1nWjBCN2ZG?=
 =?utf-8?B?R2t1RHdIeDEwYzJreGgyVURaRzBtbVZMT2IybGNkMVpEOFhBK0ZNVXBGeVVF?=
 =?utf-8?B?VktCTllOZkRIbWhiUXMrMVYvaVhRcnNoRkM4TWx2Rlk1NzVzNTVIZFR0TW16?=
 =?utf-8?B?RzZ6cE1Mak0wc1ZUclBEd1htbStGMnFVdWMvSVN1RWlyVmRwMXNDaEgrSXc1?=
 =?utf-8?B?YUJIbjdkUUVKMmFBWUtmK0w2SEJkb3c3Nkw2SXB5Z2p0RVJqbzRsUmVzS1NM?=
 =?utf-8?B?MHRJM3pZc1ZMb200dnVsRWlSTkxvSzN4S1hYQkp0R1VIZTlYZERtRytCOUFF?=
 =?utf-8?B?K3lQQ1hZd3RtVVFyNUJYZUFGNFFoZjZ3NVZuZFdRaEZMMU9TM2JUczNLMnMy?=
 =?utf-8?B?UXFaNEpubnNyeVlYa0hsYWFzd1BDREhCUjQyYnJtTHB4dUhSdm04T0N0Z1NC?=
 =?utf-8?B?NysrK1VyWFl2bVh2K05aUjlHOSs3bmg3QkQ2Q0tabnhFR2FmeUFGaXRwc2cr?=
 =?utf-8?B?MjE2ZTU5R1pSUUdrVk1TRi8xeFV0WEtZaWVSK1RLNTRSZnN5aUxDN2hXNGtS?=
 =?utf-8?B?aFJDSlkzaUlQVllGenpSRGRsVjZNaUtHK1lYc2VaZzU3OHVkRnZvOXJiM0tD?=
 =?utf-8?B?QzgrU1hhM2tNMytzUXJvd0NPRkVlT0YzblVreWtra2ZkN1FiUUdxVlNremwx?=
 =?utf-8?B?OUQ2SklXdVAySUdFK2dzVnJsK0ZIeURWK2htNGNKSnJ6NHNnWkdvbWtYNzc4?=
 =?utf-8?B?MWxIZ29KamdsY00xQ2wwZzBCTXVsOUUzT0ZncXVQRDNpbVM5NldrY2txTVZX?=
 =?utf-8?B?TERERjh4Z0lPeHYxYXhmTUNXbURQQTJ6c2lWb29xOHZzS0FlWGlBeHloWnU3?=
 =?utf-8?B?UUxPMjNLWTE5VVV0aG4yUW1OdXE5T1EzVTVQRHpBSjNYNE1tRjhQbmFYOHcw?=
 =?utf-8?Q?IQvGQk97zMvdNa9+4O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb2ccff-6314-4fca-91ad-08df11b47938
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2026 16:31:33.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmGMV+ltMcSKF+wvv8L69spWx4AcAcr+ore6mcDpJOL6zEx5/OVv6rTZpMIUnfuv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6146
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B57140005
X-Stat-Signature: zser4a8y3yf9madt5hrjqjk7r94fc5gk
X-Rspam-User: 
X-HE-Tag: 1789317100-809102
X-HE-Meta: U2FsdGVkX18sb9cLYkxsNZM7mG7SxJkMTd2sg0DSrOc+yiBP5H/peIp14st00pck8XhbHUBgIbXie6iiW7vCCTsMUg3WXYrnDJ+4n8WG4Pi2MSE0YOT5LsdHa4uDli+6Jkyegg5wRYoXUvAqslT73ZoGfaJ4fxPlZM6voxnvMgcTWZ6fOVNmvGEqMhhsuHgpC0z4LEZgkueagrOOtUJx2kQUUD+7JvPJTfJB/SENL+pNA3L/DoSfpN+F9Lsl+4392OSm7VEX6JpeacatU4sb6lp0Zu/RheytPtOPxfueB8YnVkJk7n0U9UpObsccJ5zR3+DZhpr9M30GhvTZupTKMz7UKmCCYh0yfZNc8PFirJP9+LpV8TMmeD3oL5+e/+7fcMlb/4XUQu4gvA7tHYgaPKwSyMIUvp74pV1mTdOxdgJNXLPgFMJrvCweRMiJmJ5G2eRd77hXSXP9qPARmyOjtTCWWIgCziRC3lHyk+AHYsvxEK7z0ctpCDtPm2KGLUk1dQYsma4E6mHzj8qGltB3YQis2rDzmkkMp4sACH0e8nSEXpBV9qnRaamIzBgayBaWbbwOIxs4eSVDcxpqM3fA2TAt2+qLKC9E5UTwy+v/E2t4aL+/W+Y++f88iX5DJNBM6/2GxBXEvd/91JRzGVxdau5WyBfMTpXmyuiCBCkfM0iusj5e1OpOjlEiNVfarZFoHC6ZHubt94GXpVlef7DqQn06O9UgaP8JZnm03zuubFho0eFLSX8oTjceq0duSP+nEXMhvsdDUliuPzcBOY1OET6U+cSa3N237QqIryPFPPhITFFXYK3GbAOxocwD77Nknq49geENdaK6rdtU3jpiY8cOlapjKxS2WV8ISyVTYR99CJGHFI+sK/QMCXM17cGNAuocZuk9IIO6Cvba8FgUG0200yi0fuAjTkxKrhCAb9B/XK1/iIh8I1IvFmzKCxCbrVSLxkHuPao8tjzQuNl
 O8sLYzpy
 fufBlxjVMdqoFPxCJ1B0baxZTlVyjPfOdBFtlugIfLcY+Fm239egvf7evL/jWcRvdqZLRC7gnZQ46RwFZ+Hx5amdGjhzfBNFpW7XvHunuN41TYWW33fdvQq6i/R+7ljpS+jBMnn01Y86Y5KdzBRcniKUhd69hhq3TLm+zuVYXPTF///SDnNLhmGHmTcvRAdu4k7YGkR3m5yYyeiP8b1/wumGLDSpMVtNmAwufhUxv4yTH6ndEvQWVgeUUadxEMXREhybB9mHB31kjcTgi6MKk60wcMiHbmTacSBrKS7mV8eUG+gIA9aHgeJX9pG/M+N6ZNPj+Alskr4kj/67khSnOdX+aUzlEWmLQoDaDcH7RrJesBSicAKVMgcldMzjZu3fkXdxqH/bAonQpPs1KKTWg+qR4OS/q0nUW8iOGsmSt6g+m3jCt0aJaY+t0rmZr0bafIUuQC/VOAv2Zkq+WRK3IrqmSrhfH6TPjpupwJ8A8ueL1flHPUeY7Ijt3WmzCyVa4gxw2aJQFbT5TNzEjsK+DlW2df8xdRa7xnZ2f4uTz0CpfkFAOBGFQk8wi3UKuKk6aebYyCfJjw5cIk/sG2JbIJMLnIRH2pfFdEUk1YmjUzFiGDYGswMUfmt32rUSfdYwISBory8zdHdVkVfuXgeaup4FNz10fC76yKkuEJi8Dyw/Bg5YfWp8x4mTqBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+willy and heat

On Sun Sep 13, 2026 at 6:11 AM EDT, Nguyen Ngoc Thang wrote:
> collapse_file() calls page_cache_sync_readahead() to fault in missing
> pages before collapsing them into a THP. That helper takes
> mapping->invalidate_lock itself for the duration of the call, then
> drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
> takes invalidate_lock and then waits on each page's folio lock while
> holding it. If collapse_file() has already locked one of those folios
> by the time truncate reaches it, and then tries to acquire
> invalidate_lock again (e.g. on the next iteration, or via a nested
> readahead call), the two paths can deadlock/hang on each other's lock:
> truncate blocked on the folio lock collapse holds, and collapse
> blocked waiting for invalidate_lock that truncate holds.
>
> Reproducing this over ~150,000 collapse iterations with truncate
> racing concurrently reliably hits hung_task: blocked tasks within
> about 20 seconds on an unpatched kernel.
>
> Fix it by taking invalidate_lock_shared once for the whole scan, before
> locking any folio, and using page_cache_ra_unbounded() directly in the
> readahead call site instead of page_cache_sync_readahead(), since the
> latter would try to retake the lock we already hold.
> page_cache_ra_unbounded() does not clamp to EOF like the helper it
> replaces, so clamp the requested range explicitly.
>
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D16bf7cd0ebeb1de93aa5
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> ---
>  mm/khugepaged.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 11ff98d55c76..690ccbcdf593 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2267,6 +2267,13 @@ static enum scan_result collapse_file(struct mm_st=
ruct *mm, unsigned long addr,
>  	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
>  	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
> =20
> +	/*
> +	 * Take invalidate_lock before any folio lock: the readahead below
> +	 * needs it, and truncate holds it while waiting on folio locks.
> +	 */
> +	if (!is_shmem)
> +		filemap_invalidate_lock_shared(mapping);
> +
>  	result =3D alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result !=3D SCAN_SUCCEED)
>  		goto out;
> @@ -2337,10 +2344,20 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
>  			}
>  		} else {	/* !is_shmem */
>  			if (!folio || xa_is_value(folio)) {
> +				DEFINE_READAHEAD(ractl, file, &file->f_ra,
> +						  mapping, index);
> +				pgoff_t eof =3D DIV_ROUND_UP(i_size_read(mapping->host),
> +							    PAGE_SIZE);
> +
>  				xas_unlock_irq(&xas);
> -				page_cache_sync_readahead(mapping, &file->f_ra,
> -							  file, index,
> -							  end - index);
> +				/*
> +				 * invalidate_lock held above; don't retake it.
> +				 * page_cache_ra_unbounded(), unlike the readahead
> +				 * helper this replaces, does not clamp to EOF.
> +				 */
> +				if (index < eof)
> +					page_cache_ra_unbounded(&ractl,
> +						min(end, eof) - index, 0);
>  				/* drain lru cache to help folio_isolate_lru() */
>  				lru_add_drain();
>  				folio =3D filemap_lock_folio(mapping, index);
> @@ -2672,6 +2689,8 @@ static enum scan_result collapse_file(struct mm_str=
uct *mm, unsigned long addr,
>  	folio_unlock(new_folio);
>  	folio_put(new_folio);
>  out:
> +	if (!is_shmem)
> +		filemap_invalidate_unlock_shared(mapping);
>  	VM_BUG_ON(!list_empty(&pagelist));
>  	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem,=
 file, HPAGE_PMD_NR, result);
>  	return result;




--=20
Best Regards,
Yan, Zi


