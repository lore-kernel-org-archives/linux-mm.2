Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD3BCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175008E0012; Mon, 29 Sep 2025 11:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124118E0002; Mon, 29 Sep 2025 11:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2EC38E0012; Mon, 29 Sep 2025 11:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD0D38E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:14:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7799119A59
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:14:10 +0000 (UTC)
X-FDA: 83942633460.11.92537C1
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011066.outbound.protection.outlook.com [52.101.52.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC0DD80019
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:14:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lhymfD8x;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759158847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbrCJKjMoVRBtpsMm7gL7m1WSfFIzRfK6PB6gU7YOUE=;
	b=d4RSfzPlG6NszZXEgcKp+Dbhc+Lq6zl71pC6YI4BtjMbUfs7mytAt2PFs1zlmWN0VSxyeM
	3rmeHVrsqEgDPuNZJUA0FS3begR61n6EA5twBWvJT6WtAzgXxNaXqlnTTW8QgN1+n5MJzz
	lt2DbpBmpxrmyOwksxV2P1NZuU0uwRI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lhymfD8x;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759158847; a=rsa-sha256;
	cv=pass;
	b=Q5n2e70ovQ/gKrI8k5erKl6or6OQMjE+DDgPD0VGecZMLTdChHeKPCyuESDCv5pMfZpW7K
	ELe2N4s5zdQ2JwjndkXqAVqv2Nej7D2u9QugVdk4O5DsDOkbaJRVzEdaIwSr9jfpY9l94e
	t4mlBuCPah8kmH2TD9lDembF1dVz4m8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/atyy/67F7OytfofMVA4VxBEfZdGjrFGNSb6WEYVkbkos3EPekN2DbbxY+QAdryYNQ93WwXurSwh11rkMABHmtihKcoHjrw8NG7Uw6rrniipP6mq9CqSNF8USXvWs9sHeTVEhJySyQNxd7zYaJHjX2x6/OIQiK+jrdc+4u1Z+87e1tnYlj2PgLG4O9K1DAh6mjRmmToGLEExePZg86345HpvJuaNQsvKZPHhP0ncTAAlAgivcxcrK3O6NINte90r9OiArcoUcPUmJ43HzNh17K0MStzKhJlGqR9H06Knfa4LhZ0U7r+RdahFBzPMg3zg4o7QTwwUW41Knu0wbXKtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbrCJKjMoVRBtpsMm7gL7m1WSfFIzRfK6PB6gU7YOUE=;
 b=b+OZK3dmeexi9zeEiEZl9wxVYppMEcmi/E26lXF2jVtCSpVn1oM1BFnYkJe5/YqbBqnezbkZlmBK/7CSLeNxByDRcJYqwlcoFKLz0oxQbsGA4VlbtS6gDgknk9VfAAL49gUcWXS0dZvQLW4oVY/UJPzS/dVP9p8kON6/q+sfIn5nx1TWLQgpHlgEKY5+HOZmuLDwPlmv1ZafBQzeDDkP/4f2VBdin0rT4Xi9d3zBVfCeGtXlxar7LmxQePCLpiNAVwa8HSSnuXiL46YIRAc1t+T10+Fd+nsiwVQCnexLNkEfwMtD3Kad1Pqj4IChMIPAdksoQwR2ud9xZCCY2yqrpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbrCJKjMoVRBtpsMm7gL7m1WSfFIzRfK6PB6gU7YOUE=;
 b=lhymfD8xV4w6vVLoP1iVPUkt/T4j5APWNC/mMHZ6XcZkwtI9J5uV+JrqAtcGxipiy4VXlw3img2vjw0q0EC6j3dUAk6oiRdtDt0JeBh3g2pGo0qwstj09ZXz05UCZfheQamSjAURW+kFbdWeEKfNfYQJjM01ulBzxj8VwKVWadgEz5hQFaa7Tgzg1yxvhBGBvv4qJnT1Dpox/X1vf8E7bZL0JXMV+SQs9ZhXu2HI33oZI6aioqfHsH3GVJv6uA4Vwtoyv/DYtcPbF4+NYy0VL6Nbh4u/K329Fz3a7MrrXhS6Y8lu6eIEx7/B8c5VKqRpDH8eunzUsXI0CM23FN3ytg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Mon, 29 Sep
 2025 15:14:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 15:14:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [Patch v4 1/2] mm/ksm: don't call mm_slot_entry() when the slot
 is NULL
Date: Mon, 29 Sep 2025 11:14:01 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <419AF8BC-3BDF-444E-97D6-C10DF8343759@nvidia.com>
In-Reply-To: <20250927004539.19308-2-richard.weiyang@gmail.com>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-2-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: e7be0de5-fd87-4020-6cd5-08ddff6ad369
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9jLbPeoqIiQJAwQLQKrZ1TS2P7xSVuYVc4HYwF7Pw36EfDV8VbMYdJvjl8CW?=
 =?us-ascii?Q?p+2q7KCWp9v1AQMbkAmmSJhQ6qJ0x7SFXKSVQCR0Elx8Tq98twFfwq+l8SM/?=
 =?us-ascii?Q?QZImN59FljxxvR0VqddnnNt0dgco+OYB1Bq9IaY14j9bjkKMZwItktcCgdBQ?=
 =?us-ascii?Q?Hh7rwnPmFallBkwwvfbXodikdua2Iezvd+0mWRIJ3o1xktZ7cwJsQD7oo+m0?=
 =?us-ascii?Q?DDdiiLFc4CzRF4GnvCmvAZs6mA2EM/ytxpTyjoN0Gq6KFk9AXSsk5hA8xL5m?=
 =?us-ascii?Q?guzrv3vRv7YAUzFQkORK9EnZYAKPP92rNl7/taohf2gIhx1ssrkQoFo9BRRl?=
 =?us-ascii?Q?Gfk8pg/XUXHRRGAF0TlnoVC05k1RGFBVyVaiiRL+dDpItAWUpZxim0aDIVA9?=
 =?us-ascii?Q?BB+qNxzhaQtwyu5wnX7jQbCULeOrs/wzif3IgN/ppaL73R61ZOUdak9xg+2i?=
 =?us-ascii?Q?UtBwD4K+Pt31bfLnMXzF1F8AxKhTfzn9aRV0cxX+q/HfGbcDeAD6vcJBywpU?=
 =?us-ascii?Q?Xo8DNI0bZnsLSeOJLZQogoWL+i9VaBwB1GktA9UKjOztX2id11V7NcdIyEcG?=
 =?us-ascii?Q?WKhXq708AFdvXU/ENSN0FGrlAE4RP1sO5MR3HiWxVib+7eKZQfZuipUDTBbN?=
 =?us-ascii?Q?eKYo3RsiC0SiiY3YxIokrzgIsETPm5LB8b8+KiQyHmzwesVQ8+dGvrZFKEI1?=
 =?us-ascii?Q?mECz2kVpiVXwXUBJ1zymWxlGRpjXrgqXmNzP57w9FNKIffEqHxXxBmnkOgTP?=
 =?us-ascii?Q?q3xpUK+EdH37AFkD0bzBZHXa0qV/2SKlNz6oIDCKgfuTrca80qtqPtKUUcYo?=
 =?us-ascii?Q?LgBXAenYEYqJBLozLSq4Y2v5/oBJi9hjs3dTp2OBNf0/PK7w5rIgt1fAGm94?=
 =?us-ascii?Q?1UEw/YSYR48JzI2RlkD53dnFebHGTh87Vp3XvYHWiHyex837fqu7z1L3zRH8?=
 =?us-ascii?Q?iy2Rrz5n5GYMHudC3DERynYNfx8L9rxqMLmvCB0XUuSlFUllFbryJ33VxHft?=
 =?us-ascii?Q?zQe3CNd1hPUHfxiNW+aqRWwnEcJkbb8DN/sQB83pCH+KihJajk2W11muqvm1?=
 =?us-ascii?Q?ARdS47UZIC7h15yrP+IsK6eHKPmqMEIx01sAVJ7WeLV3aynxa6n5EvZWBtY9?=
 =?us-ascii?Q?JLMcRs9rH7MRQv10ivmjpfttLBN+0CK48pG/HCSVlgcgCcbEHqzSC/4uuorx?=
 =?us-ascii?Q?bJxnKBucOvH3zLhxyM2j+I6a8pDK2WT6znIrGETLJVja/cN90WQdYx30M9xU?=
 =?us-ascii?Q?cMhJ/v9Do20GybpMWP+fdNT7mifcK+AHevayOwiXvAz7TYRQi7PGTvB44Q0S?=
 =?us-ascii?Q?pmlJoPFsGx/P6FxZBLCmx3IPcT8qKkCMja39bTRwBvUEO+Y3U6pRMahLlKo7?=
 =?us-ascii?Q?w8A6vzFRG6sZKw2Wp+APo9wUqIZqIvTZaI2beeWwcGOw34E6eEGtCo5Hi9fJ?=
 =?us-ascii?Q?Wz5SqmbU3LGOaGfoz1tTYYU1GTTBaHQS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yZFpaIGsmfi/DYoZsbfyihLd9c2NLRvSdJBNK6nzDsVrSnwU8wnH/2DogZI8?=
 =?us-ascii?Q?QBjti1vGOVXKWs4/5GaTFnq0B/OC2qIIT75S74pbaZzGBBTX9aG62kclXo//?=
 =?us-ascii?Q?kXNgyIvOP9NWKnPWW93d9cY+r40DUzd/V6QHp41HAi+laCFpQdGymV/D5HHg?=
 =?us-ascii?Q?9xEBRAMzBh89PdN+Ubppg+q4+eBRPkjAVsHyIM7dY5lr3DAjTowXprAmwl8s?=
 =?us-ascii?Q?wS4awUOC6+BXochHcFRpY4gtNOcCM/itvpow7CuWVlzVbQnvisbVl6prlkd0?=
 =?us-ascii?Q?Dy31s+7b7PbkADoFOaYQBS9npP6I9DQRtfZgylZqPP8OSmpUnIPZN8+1Ge/o?=
 =?us-ascii?Q?66QxZ6P/ey6uBdBKm+a3ECkDwcfr48XfnlOJBoitT3BSZEj1l0bwPaeNbLcJ?=
 =?us-ascii?Q?QoLw0Pm/dPbUE32c+0JK5LaVFNwY3Z7lGQNkoQhkBFjdDB9mFUkNeyxovNGY?=
 =?us-ascii?Q?FsUt7XFnHvNsLddaMmftLX/uY0XZMr6YtfhzLp17MMrSkHgiJOz16azoMxwb?=
 =?us-ascii?Q?XBfgPv/zmXv32H0no9g52y8yMQ1yioNELhO4Ymv6PnTk7EAaAtxyPsWJ+dDr?=
 =?us-ascii?Q?BaZIgm9rLqN9nXTU08O4qfbLmz1N2K/KVJYqkR15UW0+MveL9tq9W48EmKwb?=
 =?us-ascii?Q?VPMMjTr3hRMrTNtls1d4REm/e6j9hF0AftcYXzXoRhc2Rgzontb1/93EclwF?=
 =?us-ascii?Q?4l3TDQGuA1ZlPgCKskwQz4yROMqqzqeX2fa4B6TStGTafgS4Vmjxxak/Ca81?=
 =?us-ascii?Q?9RNP5qfkX1ZfqcfmgguvbTj9kSMmAPL4TiQSbb6ZxUof75WOgM3+IlXxrfun?=
 =?us-ascii?Q?SAeI2JJ4FKL9ODuN747i8SDfpEuENAb8O2N/cqrZE8gfD9CK66n8BqlR/mxb?=
 =?us-ascii?Q?OF79yzQSx87DWhL1npzloB0g006JxufB9sMBos3hIkFFc3x+8KYYb/djqbaQ?=
 =?us-ascii?Q?ItTr8pCL0023TLScd6OwFbSC7/OiZWk2o4jKKwPey4JaCCbEP9V9w07wCht/?=
 =?us-ascii?Q?W8RlxikqMptE9VlDwdi8YynK/Xf+6tFHnn6FBened9NA4ApVvV92UPRI783J?=
 =?us-ascii?Q?UPHLaaNkydxN+Uew9IvAFu8Zr5Q5FHp4UzIIkFFkZE8/Mq7T2u1/vIzfoyO3?=
 =?us-ascii?Q?zXrZXgDPNdxYOD8h8SRQCrJWQPpiUGQMPKoYVQatLZ5qERY73LK+LsYP40ho?=
 =?us-ascii?Q?e4yAvp8Hvy9ZwAHL3zRfAxztJ2A/AW+pe1V86ZKU5TYjhGwjjOhL6xM4FXWj?=
 =?us-ascii?Q?ZG9elrdRhyh9g5aJo+XB1/z3UjLEqiCeOhTcwkWywQH1ku9zJnCxrMR2/A7f?=
 =?us-ascii?Q?oNaqIWMzdd5BtO2gDwsmkrM0fgLRvBxx/sG/W4eqs3SNQkDzmSf4v6+7FxL6?=
 =?us-ascii?Q?3HNcw++CWe5cu7LJ/jV9ICC+WzeqwLXI7YPfv8CG2+V6q6SIlsO5mPkbkkzW?=
 =?us-ascii?Q?8Bfn4apDE1ua+OC2jirjJjcjhRWVI98FZQZBEqyVXJUDRzHK3WHUeGjGtl5z?=
 =?us-ascii?Q?TC2oB+bkaYLcm6RkWZlRBfgCu4Lzw07ttfEqVnRFaDKVoGsoWSLo16Q2DKs1?=
 =?us-ascii?Q?oXieqB6hVgOmog07hJ7fTa8xjFOx5PU5bDyMhaKa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7be0de5-fd87-4020-6cd5-08ddff6ad369
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 15:14:03.6380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/BYoGmzjo9+629qJPzgm77PIWdXdZDAziiRuI9s1iG1tLk6X8tSV6beSsO+JyO/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867
X-Rspamd-Queue-Id: BC0DD80019
X-Stat-Signature: 3ri7wrdxdo69q5uu795k9tyggy91hcni
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759158847-411665
X-HE-Meta: U2FsdGVkX18AWoTt3fTHoT0SLb91BkLOwcw9NCynnFNretaSghXrN4/eFwGffCRCWKHzFJsgiHNRqL0wXXzpQW2PNiTInrdV+soUbRASUC1M7HwGJc3vb64s+2VEqS3tPgy7cCiPYvl45k2eCmi6rgJyS6wYLiqFlM02W8CziW3siWyDg5TEubof6yLZD25Lae7ezzk4i8muVEhKBW/g3r5asg2a6cWWTe9gAHst2j7km2KOXoBckrx0kqDIFXmvqfIi5FHctEm1OlLqK7VUJcM/V/nAJq570EaXIjXE94QgQFsQ3+Bk1ASqDowg65oNFYqVlWh6gCiLP1dsUqLOwBjDOfjTTwddGMoSTwmqjKz9CC7MAyYHO5d65HTPNYzQ54lzIGifRStFLKBCKl2igumj3MyNxa7/PVGB7EuXqXWU/AfyA02hIOQbLCoBJfkBmKUxrSUpGerBrF2MUCqRbyAzdw8hkuwRiVSqzdSaAYmNsHoeGLkwtiiZCzuHbTyZkuMKn+Gehbv9B9tNnLhZMAH1jYMRRR5VOOkIohdVtxVQcCJficOwq9uWswWu5LCLajZymLYtzV4W/sMU9gaS36rME+UBx7hNuObQ+Sl0+uGYB17z9QsX/Dp0sJFUsH4OG3lWOQlN3rWmWcM8HECalLtsM+2eqbvJYP1kMc0r/EasgvGQKIJXfov/58mEWERWvw0djM0eVtKwfvg4DtFMDQ0xtw/pZGfWBvOAleQzjFSGKcgVU4QP2pzyfdw2gy29mLpEMoP6RqTx9VEJhGa+Wd3zyGB7IlA9M4EUJpO8fqf8yLGFNt8e/J4UBJAWY3xAx1gKljoxsW740qNXUz6VuJvg4YuVuFtk9KELno3DnfOz04neiR2cdBbZN6g/NK1WPtV47hKeYup/+Mho9B7cbPF6t9qxxisFCUlaJvEU4srcg7uw4vB5HnuiDj9D8dVeah80/tP82Ph9qZcNKjn
 UZCkPvK3
 UHK6/4IIZIevHfSZivmQ5Ny+J0aODhU3Smgj/3Q6anxFppqkq5lipRqxBq4aNl2Hdxoya+T+aL4rSo+iWIiGku1E1jSnN/7JAdglyogbJS9HpED6vNBHZGS/yhLUpkqNGlX0g2d2iN6TDXuA7QEIo03Rw4CA0dmr10ZsfGAo4mJVt02/5tDzDaJub1LsIlpsPLBsvetBIJihxDODOMzZhApNormceRd4MY7Nktx8IWAZdBtTza2nFzlPaf9IpfHj7B/SlqWkfZI0DPOdjxR99NOJNM/R3Ts0N0+rn2T4YB0CKt7QobajTQkA9hfMjbE3z6atDDbiYiv25bKqhuxPSw1rjSVtneSw62royPap6WOPXSWAi4uHnPIGcF47k5PGWLGmLS7YXkirgGAJso0a5njMhBorcv6dKonwwOdTQXm2xC475J2624JYKx7dLVs3OO7hlWehbt0QhBQwdeHHgwopulBm1z6dNMAq3YN3c60MD/RAHVIoF/BqS8CrlzgHwcgSVmMf9i3wjydDH/WmH2xaXrpmCXP3yxEuXUZbaSC2SsR1x0DSCMoGosH3P+YgQkqEnGi5mubP9kFA/jef/ZBMo6I0as86B5r/4ZnOJVd7QyRlqIuCWa0/H/KLud9KTdgz3PJWkO/i3/8SS04CR12t8B6JHEXewItGl5MYgYJ8wGg0qFUde/CJ6qq+8uVZxzTSPdrne0OI99g8wNOlAlquyZGcBbKrGhAitlLEVI1J159NGJQy2M3fuH1OoI6pEJdYrL8aJN341U8T30Bt0EotmPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Sep 2025, at 20:45, Wei Yang wrote:

> When using mm_slot in ksm, there is code like:
>
>      slot = mm_slot_lookup(mm_slots_hash, mm);
>      mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>      if (mm_slot && ..) {
>      }
>
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
>
> To reduce the ambiguity and make it robust, only call mm_slot_entry()
> when we have a valid slot.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
>
> ---
> v3:
>   * adjust subject and changelog based on David's comment
>   * use invert style for coding suggested by Kiryl
>   * drop RB and Ack-by
> v2:
>   * fix uninitialized mm_slot
> ---
>  mm/ksm.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

