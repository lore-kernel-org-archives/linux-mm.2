Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F51EC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5DE98E0034; Wed, 23 Jul 2025 11:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A354B8E0002; Wed, 23 Jul 2025 11:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD9B8E0034; Wed, 23 Jul 2025 11:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3558E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:40:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2341710CE6F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:40:16 +0000 (UTC)
X-FDA: 83695940832.08.593060B
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5456840008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:40:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDksnwR1;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753285213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzH5SMM9WlcVbLiX1jjvjAjYLtSDNGgllJ0RmGuOLTg=;
	b=kfFGWdztEUtIEREC5yYavJVgjEHFza6fA7GMSjwksyQppiwj+nXh/Aq79r84GImrEqTMGg
	ceJ+i/Qtw15l++qlRB/kfSprBBwl6rVqlcZfzIlR6gyhjRLGOzlMDY2yRnTAyBrZYPWeWF
	Zj6A/qOLtptAhhtDTE6P3pDs7QjUHmk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753285213; a=rsa-sha256;
	cv=pass;
	b=q8Wc2M2ErM9bUQf7fzF1oI4CCKE1eGpiamcwudt6Xq1oB3S5kZsWfHkvDgHAG+zQy3Qr0U
	+a9ZUmfVWF4jH1y3+jqsXmtMkETHg6t31HnS/3DepfgARq6uAVfSXvi1ZACp73anpV7jet
	pqg+ZDcV+V+1gzYxOOQNZe4XybEkGGY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDksnwR1;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yK3/mC2TCZPwi8PjRjhdm+LmSajAvh/rAkmccw8t4gXsRGrB8CbGjXice57FLwynaZD6lzDPGJdzQsTYqxM2TvgUogY0vpe6obAKl7TvGb/0wZUzKqwZjCbQd2S3DQoyDpg4U1cz0tciBAUBURx1p7YOn9a49Ch3ZAbCycJIObgR2ZsQXP/rPkadFDLPe0d6joWyLbpWqGV5cOP7mSHQhk02gSJnuJ1OeARXwav8/+ddQl+0YgxEuWTCZo8pZTYPFycBMQs3Ha/cBy7cAMDLiHvo4A+D3aFrKmUrdQT/mfWe6mbGkNwYALDWGmxpShlSl2ktKm1Qv+ef1wM4FnmggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzH5SMM9WlcVbLiX1jjvjAjYLtSDNGgllJ0RmGuOLTg=;
 b=wKsgNkqNqcCMwFOmLhpvUz/T1L9gTnN2JcabPQJg4fG3obrMcKiyP4ha3iU7OrHL1/ybrtVXVGWyl6P9WS2g4NV11f8JJ0oEkjA/KwWJYgzOxk49LKrJ3O3yxPJMCytATxmQAjhFhcuwrhP4XKFUXD1rGTfLgW4ktayeoOblAYUXZXxN9JGb2mA3zGfPoCOWGVMKYMDeE2/VEM+WWeD+jXJ8NY/WC66CEVpDQYa6biGiclmw1JMUjNRgXGT8g2tobWYlv9juu82k54GmLtsxR7NNIrPjF9EzsnnKYLS6TaFGotJygouHOITJ/Qpp4GusFKxSc7Jj6Vmr9Cf7TZL/BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzH5SMM9WlcVbLiX1jjvjAjYLtSDNGgllJ0RmGuOLTg=;
 b=SDksnwR1JbMhN65X+FoIGwUewfw/nfb5v4vyVzLAyOPlL3lJLHH127q7cduPJ4QjrXQ6nohfb3TdEUQxGdk9uFyX2y3TvTZZfogX7GqPfEtRYctVMUy7I2KfWOfBfu9NIo+qASCWENId3fPDB3p31E6tXwgA4MC8C6ri18R8PJ8/WJfn707ahZjCck4th+98q4mv1cI1/d8e0NjzeqVu2GLsqBFgBdezaTPNcXTxjsHqKh3Gxd7XQ+BHfHXM0kdkGBaefTGrO0UZAKpDcLx1T9lIicC+5IcEfqHuq7vVSleOe0gKiaX4R/hZfCp4czJ6JeUHftGtAD1UPLEZzN9ncA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB7880.namprd12.prod.outlook.com (2603:10b6:806:305::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 15:40:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Wed, 23 Jul 2025
 15:40:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, david@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com
Subject: Re: [PATCH v5 5/7] mm: Split can_change_pte_writable() into private
 and shared parts
Date: Wed, 23 Jul 2025 11:40:04 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <724DD429-82CC-4C6D-9425-086258ECF63D@nvidia.com>
In-Reply-To: <20250718090244.21092-6-dev.jain@arm.com>
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-6-dev.jain@arm.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0133.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: a8016663-8552-4566-c57a-08ddc9ff343a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dK8CTEwj5SDlQ7y1cv67rtyB3JKwJqmmRaRGc51w1kA+mr6LFUQnpJFCZp/e?=
 =?us-ascii?Q?HN7vpLOk1LpLCkOV+LJA0YlYULk8oayeX6+/yCCvEUJf7DvVw3hu+GpQwMiS?=
 =?us-ascii?Q?2uRc98ALcoysn1740g/acRcg97i4Uk/qMS8ry1aoBmFj+QSycqKmiqAp5FHF?=
 =?us-ascii?Q?cYDcKbW7KYIlssb3dPtsMDaUKeAHjFrb1LDYbYNymu/EC4H2ZIbrDnKi7XfD?=
 =?us-ascii?Q?rKPB/koIaVNJMIi5jFtqS9yf5bSkzGnrA4iiu6kyzsEK3e/UVO8KKmM9BQYy?=
 =?us-ascii?Q?98gk0gfd9mcUSVxJ2ylpFfqLAVB86inJ25GSUI0yDhV3srzac/HI39UExPUM?=
 =?us-ascii?Q?tyZX2oAgpnnT24GN4aD6q9iyQcxsGKEfltP50cFlKche1qcIDw7Gdim8nhXk?=
 =?us-ascii?Q?4vN0wZWjNYGu0SSTQomgP56kph5nI32f4fImxyIXa/Q3WuSHPcYuNAqWqtID?=
 =?us-ascii?Q?NzmFXpM9Q2U5oFXReG05iDefMXWnDEDUw+ZyIm9JohyVb6GVVAJ5Jkllakgg?=
 =?us-ascii?Q?aWN7KSNacPZDAT4Jmz+YvS0dg8BauWT9c45IVeNlXvxf208Mi7+HFNJhT61Z?=
 =?us-ascii?Q?4SLVJfHgyixmhjARwb2aKEfHl2cSd2ir98f2bd7bmYQRaOz0T0iU2m16I/Q6?=
 =?us-ascii?Q?f9eGELdKOOxbT9DVegFJTnYw0cWRlYjIIyup982MkOBeQkuF8ZcW7r0NJSDR?=
 =?us-ascii?Q?QhFISyViJALxObvXnOepqmHgKhoPA+c9TLzwNbvsAE77OZcPflhLX8bOkW3f?=
 =?us-ascii?Q?t7Mdf/wPD8qyv4b2YALenmL9rksZxSYWQVu96A7F2LNpN5JJN3ZxdMTTFlYw?=
 =?us-ascii?Q?8Kd8/Ro/XrodW/g8gGdRawXLMVqN03ktqfzIYt1ow2ziwrSmIUfg4+Pb7hzN?=
 =?us-ascii?Q?8q5uvDvAt7bmBSIfQQIqRXXp5AIJBrxe3DwYOUX5cHX7hu07DWVElopQbC2i?=
 =?us-ascii?Q?hIN7zXjd7qX0GvFhZQHlH1AQ5NrzGblOD462bUQLMj7OwH/E89xoa0BC7TqL?=
 =?us-ascii?Q?JycEa0F28PfjFlAUIkX3h2ttuGqf2+pYExHPwd4DKRRFUTSkRvnM7Mfdtnz0?=
 =?us-ascii?Q?T/rSrBGmL6VC9sco0JNnT9GLEUedxrk5TLIkNFZNb8r5wl1/YhWiWp8+nWM+?=
 =?us-ascii?Q?ODOZj7ybSxxF/earflAIYvSfH1A476fUdovLJdjnZPaDIovhQGRF3K51BLjC?=
 =?us-ascii?Q?b1IF2wu23jSp8C0gXXUvXitv16XeC9cDLF9ar9isaJyX/qypjtTtyx5ZDah+?=
 =?us-ascii?Q?h9BlL5U3so6v4ETeAvlGGCmMX4wOWynFn1A2ODByarpNy23PUzIKOWexOi58?=
 =?us-ascii?Q?CAF/XKnt1GyQsRwH/nGUbB86uSJZEIxvMOwKHLRkmgT92iEbrYxNuzlr6LDK?=
 =?us-ascii?Q?XBQK7kxtwdrhFfeZ7gqHc5Qt9vSwRduv3cDvFYxNwfIrwxgfO0xORUuEexK4?=
 =?us-ascii?Q?3sbPJQWz3Ik=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tgd5WdZafGcU+ohh5v4/6j8JVKm+58oTjnMJSm3lR2AoYtoVpBKx8+aEzY+r?=
 =?us-ascii?Q?vnpEpMh4BOWkQIYSjbjXYveAY0I82RnjH2s7KPK/w6DvAUOzGbzUsp1S+jpm?=
 =?us-ascii?Q?45GSwLoO3sQbRv5sKYbzIRyEX/MBOd9WXny9XFbfvxfeoGheUyL6Kovfk+zQ?=
 =?us-ascii?Q?aqTuZIBzFcHUmCfqosKYjvy3o/BR5aFvSnUeOK+UA5LtcMmWNbEzhKzJ1omK?=
 =?us-ascii?Q?x/SPzugHb6Q1Cn3aR1tGA6Wr8nmtbU4QyQXvPGV2UbmMI8JmrvBTtOKIOMYY?=
 =?us-ascii?Q?Gbh5ky0IXiA6MaVhe0YVENsvGxWr1KMIcM2J8NX5fLkN4rnfC0ZmRn90E0qF?=
 =?us-ascii?Q?h0XXO6Esjt/vCQfOqeAH5SLmzZGmZgbs7Oz0NLVvgKzcqWG/3iyJaLiJMT1F?=
 =?us-ascii?Q?46Bi9QhoVs4GvJnY88OsZOWZeGCiK/WvCs9YgwimRoPHJE5eyEVr/kcAdsYy?=
 =?us-ascii?Q?iQlV6tEGL/adj1a5QnbdAnffqHvVMZbeyZi3O3hm3Fqq2E0jkGuX5Xsh12th?=
 =?us-ascii?Q?fSwkTOUGQ5MLAfjrVPvQUhLyfImS8PXXkSQkvlQa7A21pJMhFJjvkGlG4xa3?=
 =?us-ascii?Q?fHonFaMbJPsfuAC77sISKFtTA5YnoMVwHatf0uJA1T5ZT321hdftE+r2hsBk?=
 =?us-ascii?Q?MjXW6SkGujb41maqVNnL+pKoUouJp8yfVlnLvB4Wa/eURagPT7BPOTFo+O2x?=
 =?us-ascii?Q?olCRsH55U9kW/UkDEGcEiGaLUu81m7RKZspXzlQ9uC+mn6G6o9ex01WdPmax?=
 =?us-ascii?Q?UFPcYUzqopgVKOQ4lJGks8+gztVlZP55Xjh+qyOBHotczLQB9R5YxXyUwczL?=
 =?us-ascii?Q?lgSC1vEDpGUBo/k9KS92EVBY/lhIP4Twd8ivYNh4YOCL377u0TUg2YWIJG3o?=
 =?us-ascii?Q?0kUfspQX62nTh1XoYLV+SVErHUIDL2RlUgM4y52fj3aT1PCyKmCa2pSBj1IL?=
 =?us-ascii?Q?ArF1Rkt1naUDxqcCYJkMVdZ//jNhgDU8zarIX9tvz+VvVPUL0Ck3rGN0MYLG?=
 =?us-ascii?Q?nXxPR1c446QYWDJ8kbskcjygkRh71KREs+OBSQ5G6BetOt5ecHkHFtJ1AwKc?=
 =?us-ascii?Q?GkJuQ5la53iWc8sUqYooI6MoaCIyJGSkiKgAMA7q04+Ul7GlgGyFFnWxaiiq?=
 =?us-ascii?Q?Tp+FpQF05C/75AQrSgsK6nvlR4MVF2Axxv9g0k9CoBxbbXL1+8ZZnDOb4NoT?=
 =?us-ascii?Q?93emf+sCj8z61v8NWXxTRQmfVbADS6SSUvXB3CKbrarTtsOsWkEtnN9bzwtS?=
 =?us-ascii?Q?HJ1tcTAlafWSqD+6yyLog3kfj+I8KdrEdsd/SbQcIO47da9vjqwZWhGW5cNO?=
 =?us-ascii?Q?Y0aREziQ1WN+gd0eN0QbvZh9ztocF1s6FbYgDw+ewMIIaCwqLzP5s2HCeHDh?=
 =?us-ascii?Q?0ghFguZ51O11JgIbr+f5EOAja5RMmjbb+3JG73d7m1zVmtqcUEpwPSX/VA1d?=
 =?us-ascii?Q?fqobofYAR0P2iGjOcKjca/33w/jmICj5zr4wNz3TBF4H6ruh8tmA7JPovaTD?=
 =?us-ascii?Q?lcgglvVEU+6gzVwqu5lLD4/wjOJNWz5sL3DPrwPHMTbC3E7ABjC48g4m5F7v?=
 =?us-ascii?Q?bWx1VF67TxMwDBruShOWCFuKExCqoE5eo6gGLYJ2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8016663-8552-4566-c57a-08ddc9ff343a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:40:08.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IVwHjAnpeHp5c+bc0Yae3gR9gNrzxOnVzk+KlFgsCszQQ3Phf8LX7y7va7CQH5u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7880
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5456840008
X-Stat-Signature: w5fj9rkzy4mg7ku81xi314kjpkz64wh5
X-Rspam-User: 
X-HE-Tag: 1753285213-625119
X-HE-Meta: U2FsdGVkX18K+35hyGriZsHwHQ4GsFWqVQDg9GZSjPP+LqKGnvw2sa3mMH1Ee6Z5j9JgbptZQqEH804l8glwk5JgRIKNDpqd4azy2gvN8YVIXf6drzHL8Jn/WndVu7ZC1+0RkwgHBp1J4AA0puVWjc23xvA50GTdTffc3k6u0STQbxBcWJ7lKH1WEM/+LC+ioQROaSuDFxAt0tg1l0qSPHz5BfL4yVTi169MW5wLI7Rz2+dbRK3CMptCgV0TElB8AiEHnmzLuTrToNA22E3GO7Am+VWi7GznXKqc/T4qlc+vyFtF+fdlOPtMubpj5ojqq/Khru0cb0oLTOpqsSZv9/TaPTKh9Zaul5ayyT812F0hhtsYVAvPZ43a8Px98oZQ+cEAMFJYYivgY4y02ctCJvO6LB9ZYvFBRKjHbsB3S9EM4IYYMoyP2QKe0b4+KhL7ZhZCyXil6Na5pt/Q5UroC6parZc3txB4aAp1WZ4srEbDn1by3A6GHN56198HbvThC7QhQWdRxwIV8FZnXVM6JJxkv6klX2hNC99r57Adu4tt+0uRl7k0i1f9D8qW4qxazNd6tq7/kfS0ZlONhr1HWoQdHpMZnC+qt9ha1vcZjRMp8NhyH1TGULkTf/aJZtYR6BGROgWYs1xSl3AYA8MQ2S6NHPUjylVJbZcRC3jgdrDRl88WYI3wCEEfgwnjB7xYXZZXMTwLhwhN0LfiOjRIZdwCguZ2WfR4CV5u6yF31MuEMAb3wZMGW5EKWuSbWaqyRU2Z6VE0FuxOxokeF2+2d5ScVQIpXl9ONNo2EOhFb0+jONqqhOktbsYycmuGbSxOIpRQlqH0Z1eGlhag9FoQU7htaw/VZa2g7Soq8qDOEPx4swPTAuiBETwACVKsKUac4zHbDj6m5THBjgcAAaHWqG6Q6P5Tv3emr67MwArQh/1vUk01CJ1UkRZ5qqNUtXJeNISsCz2H/8c1PY/7kJZ
 /Vt9yMqk
 q1Veshk/qAKJYCBcQ7IQkv+Db33An+XBhSG6sMZ2FnaD0ChmA6uWScf2RIH90BhCmqpX9mOQPtPZAmwJ9WTscwlshLpWEXZiAULNwPkkq7BHiLeFKI8NGD7ryvKpyoDYhDrWmZgMZb4t88ioG37iE2oVELQxm98WWEjuZV/vs7ur6I6k1xnKPCUtRHtR1vrPkPNLQVCT1EZM9CvaXuoLlJN1tWKrP4Tlxmc5rAZJfdrLR7e+YxX+hGauOrnDanPs1acg41YlHK/RwxxnfT11BpSoM03r1UaFV5KEg5n36zTwH9MhiBm38Yfr6d1Pz8X6nUEN/eLDRZ6pMWaTDh0gAjCaszPkwN/l31UmTjMDDtKKez9hYZn5EHLNQV0EEUaWKZ7bt1NPUQAQECYpeKLrj6rdBvb4NLH1bQ8lbl6celMAMSr1aMfu9pteTRkuYuAcBvvuJZOJKgawt4OZEueYzbNJVCTOV+8JlJP/qSG21Ge+RtpyZZjZsFk65e1cWJUrrSZ3Kzo6K7O4Kru0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Jul 2025, at 5:02, Dev Jain wrote:

> In preparation for patch 6 and modularizing the code in general, split
> can_change_pte_writable() into private and shared VMA parts. No functional
> change intended.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/mprotect.c | 50 ++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 36 insertions(+), 14 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

