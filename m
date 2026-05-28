Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6898CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483D96B0092; Thu, 28 May 2026 15:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434516B0093; Thu, 28 May 2026 15:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FBD66B0095; Thu, 28 May 2026 15:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2B56B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:40:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D99371C05A1
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:40:25 +0000 (UTC)
X-FDA: 84817845210.24.EC3E12C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010055.outbound.protection.outlook.com [52.101.193.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 228F01A000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:40:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R0w8tpRZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.55 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779997223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzKJ3A0knsCp43XZiY+7zOOoAcsdxX7BewlyBtfaan0=;
	b=Fczog3/bIIMH/fcguzHsmLcdO/2yoKZe5kGUU4Bzq2w9KY7Bw8Xp60S5kgPlQgB9KgPmOp
	TcYNIKPzYdMILOJK5s3NVRjSsK32ZUNOGkpnvr5TyNiijDRgGMPrRUBvnHY7ixJwFUFSEA
	kQI2YEvOTjq6bTuMnet5gUWGa+IacBQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R0w8tpRZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.55 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779997223; a=rsa-sha256;
	cv=pass;
	b=gMGF600CqaRcj1G2+gcvZBs9rKiZxuG1zoYOG3kxS4li84YoiZjm8+piotB6FkrTl0myFN
	iX2NLbqwlfr9NUqs0+BJOyZV1z9UPPLF+HvsGySKoyUhr24TiYK/gOB9lAkGA0q/l/BstR
	GZY1yDuZfCAbRTVUwYF8FUYWbC/nGYY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mSiVQF/3mT2ObragUqGPgtC27PlClB0a4sDS+A/qmayAd+RkJc53lqHpHRZiV8UIT0JeIyVuKAiOZQanV4E5HuX7coPXwlySIEIBqJtw6EEbnmLKdcGltJmDcQPiT87EIztPfSiV05vRp/8W2d1WDP8+YO/vgt0qAtQfX7GeGoEL+a3Q9iGUEg9/M9/tzGrapSL5pO2mXDLplRaJoz5NHSXAC8Jpo6nmLu4xcRO0MB0YQNpNrPoNgnrnz9YTboPVpcsUE3E4evC4YXmB3thVZQleE1Z0iYhJorML7h2+lT2QQWs3RHcUa36e5zp1aXbG362M6nOvCEPAk8c+oKwNXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzKJ3A0knsCp43XZiY+7zOOoAcsdxX7BewlyBtfaan0=;
 b=GH1JWRa+P+HqedzZSN+coawbTWjnwTcvljF59pR7J1xX2G3fFHu8/f4wOTzEP6Aw/PsUG2hYgjh0EvXq6gPoDFrRq4nJGls5qfmC61R3MLmL5jeKlWu27nuvepC87ziRJL/08l7+ENd6UNGAoKw5z29aWGf7KL/huFVEpH3C9/4icn3bj5jSjPYOmTYyNUoK/35uvCT3quE1hkAyPn+/F5Gpo4+xt74dzdHrfZRUPfUpMocbQ1N9tHOfdfzaMnQ0XoLBi6FSOIWZHILN1NgduEk+3yRHUhysCBmumFD3bhMCRrEOQ9IJJy4/7zro5GNAE3in33AL6Xee3qCIF03aQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzKJ3A0knsCp43XZiY+7zOOoAcsdxX7BewlyBtfaan0=;
 b=R0w8tpRZaB3BHpFdFSOfYdZYi4B9gizuiQx6MHgxe3hJbwjkVc2sUqU3NfIf2SlLNdQBl8339cZ7qFQmcRbzpIxIkWhZ0OaDsZmg32jZdjhSkJM25QvUrocnnThbE3XOojrsrp1McGn4FtQ/RUHRGCu6mqXi6KYrRPM9fnZsfWimsEon0pcRwG99OX6IYQ47BsSHLzxrPqdMfPuijXndX798sjMlKstPyprIzoiJcD01Ak/U93RuY54ojF4XaMsppZKSaRUeuHdvJclyl4A1lQaazHY+1OLn9b1qzDR7bOtvMrwoWKq4kxnOhVvzLYR1XeK4zplxfTLyGAkbKOHOoA==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ0PR12MB6942.namprd12.prod.outlook.com (2603:10b6:a03:449::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Thu, 28 May
 2026 19:40:13 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 19:40:13 +0000
Date: Thu, 28 May 2026 15:40:10 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <ahiaGvfMZ-7MIcZF@yury>
References: <20260528190337.878027-1-ynorov@nvidia.com>
 <305848e7-f987-494c-8244-bcf8eed6fb7d@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305848e7-f987-494c-8244-bcf8eed6fb7d@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ0PR12MB6942:EE_
X-MS-Office365-Filtering-Correlation-Id: ee5bdcc0-4070-4fbe-a0f6-08debcf0efbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|22082099003|18002099003|6133799003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	NWr2uF0skJB5jR3HnjE4nrntKjk9tPrdQRGHt/b0UU73pNXxbStDby0euNoO9BkYjt9wTV05xy8fOvLRyKvCBVFqx/BaM7hKrPOHgvx4fd3GH6/le76ZXJstUDerE/0y9N5Ogb8ARO1bJgrIxo3DrsFQHRJPEvfg05mYxPmnevT+iOip4XNfHFHgV4OxAO63WE/uZdZ9vw0Zx5qXHlXLAUgheToOfwuEOoRjFus/smXs0Uf6Nt8uhX/ea0WSKlOdHOKbeJW4WOODAbZO54+ZvLI7KeNMwkFFj9CgRM0RWopL5ZdmzJCU27EDXLvjezhNx0K+zxoc+YIpUVm6atVvn8CNjjaafxR/wjlRMBP5+WkKo6wmZJLjFNWOuLpAjqwxgOD/eARhyunFL9jIwHtMmigQCths8tyfbdmGQ/ts8RVTDr2eR6T7+0ae8+OqOlGSZxXq2g89W/eRYo8b0ZiNPvRnbW63DLD/B4IA1KPYkUQ9ui7ykMAlsvplrxBkGJyTSEGVoeibaKVKpAdsqNpxgQEFwJr9K82AdtC3/JFCkdcBP+lOXPvm/n+lF/OrLeyqJXPF9Inw5ofSXd4ckFxYBJt84puAwbJHUgBrzb1i0F55o0rx2qCESIlXrcyAu27Tp2I47xiYAnFSwl3SYstOXQd6N+o2ZIKesegD66I31qSTFX/jRhkjW6O94j6JH4XKWhdl086GKkWpF0FPXsK/gg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(22082099003)(18002099003)(6133799003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nmi5OS2T59jPCAIn3QB1iZCzxEUZBSX7w+d2PDEg0fd5aZHBv7yQm43v2Nza?=
 =?us-ascii?Q?kZjGz9/DS6O9Ewb733RcKCLPWz2zoa5ZKh3g30KeeexU4rKLicfUUJNtYTfP?=
 =?us-ascii?Q?VA0OaPVvhNkrMwO870YihT9+IRP5Bp1ka67OUA3u9i4MlVzmk+wTcGuetSYw?=
 =?us-ascii?Q?NMCMXZXwSeNsGouUpbPUqVqyFriQUqH6G1MhOYu6fBDGRUVRzt7lDIaQfDNa?=
 =?us-ascii?Q?O4G6mdj3K8+hGyp1v6Vr5N6RfMZ3hKCdnrbishQuH/obh4hWU4wseYwgBDex?=
 =?us-ascii?Q?MI9zvqoClBQraIGfRYnxiTXePNZSOfC6qQVIPFtm2G2xR3suvT3C43MT8cm5?=
 =?us-ascii?Q?UMFohRNPr6rD4sPN0RFMpZdA2KzM8db/RTpB1eUSR7bnjVpaVtj2Kifv/e3T?=
 =?us-ascii?Q?ZZmfki/Is9VrHQ6XgEclF2vXOn1P3C0PaLng84ZtFw51UGkwXbUeGZH2rNLp?=
 =?us-ascii?Q?gcRYsYPHEmGhKW7v0Z6BFU0YiFKg0qd69qwM/eUjGhUgNh53JQffsoKzJnfG?=
 =?us-ascii?Q?cVri2xCv0jy2FePBjxvB1cf95f7m28rhnLDpIZYBIFkgOZwN+acqUY9hELbw?=
 =?us-ascii?Q?6rC35Va52WMoE5CGn4JDitEeCCvNjGlzeBojZuaWzuXF3AR3Jmh2kNopb+RS?=
 =?us-ascii?Q?K+NsDKWeoqPbCHUWHq0OWv/ToMjg37bn2AbCyEmZYgawW00hcWvFxY5bU8Z+?=
 =?us-ascii?Q?d30OxVjieV+ddOQ3PSm0BvaaXueSwvTtNMzGigKbTKYC3GZMszYs06uMCqom?=
 =?us-ascii?Q?0/KlsKY2bUJ4i0nknmBtMhF/g5YpGZSmgfp6FNQzhUbdPCzoS8MvvZASbZyJ?=
 =?us-ascii?Q?IYKxwngiSkKL+iJH2GOzSk/Dx26MPzcG+dwEUIRdvWH380BObKjWwgp0ny0U?=
 =?us-ascii?Q?7DEwnJT3Xf6YeTmTXRQyyQGPFtnBChp6KJYBZOHfET4yCC46JpBw7sKXgFdG?=
 =?us-ascii?Q?gvYtcA0xSTCgdr/wqKQ04AwK4JxrLbWW/JFcf2MEntMk+y5ABM8TJbL67Ric?=
 =?us-ascii?Q?b07q5ZmNsvNJ24t9z22KSI+re3/VYLIUkajswgydKmpo7uu5LuRNB0rmHQb2?=
 =?us-ascii?Q?NHil6sagFmbmu+dZFIQGMJL5i2IIWSTU12a+BV3fETH8//tBjeGdQsdu27t8?=
 =?us-ascii?Q?zH2dIUXGHDSTey2THgIcz0wi0n3Sqo3LwJIegvIs6IwFdYYlKbZnsutdKj03?=
 =?us-ascii?Q?1KyG3YBKPLMAUresm3lcHDDbff4arZBQuY/uvUnH3q4wSV2M3XO/fZzYQlqn?=
 =?us-ascii?Q?zQWzzPqgMRJEMo3cM3ipOp3RXWe3J1jvMh3e3jUgt0zCvxpHAgS11cA0wjEf?=
 =?us-ascii?Q?fRs4vrE56FxQNxL+cocigpW5K9+UXhON6zeybaq9c7gm2cbcV5jG8YMj9Y6T?=
 =?us-ascii?Q?yj5xzF9Sp5LT9bMG3fyhYO/oKGJeE+A31vS+c+g3ehhzNSCpB/Cy+wS+MK0K?=
 =?us-ascii?Q?PmLJ3BQE2g28u8oEAErFw+IrZT3hjRf9S+IshHPXxV7N3s1HonDqlu1h2hQ0?=
 =?us-ascii?Q?F5Pi6ZdzIj9Ghr+3W34YcKZYLvTneW2FlzKEU+FEFufGUHOCoGwK3RmZ5dsS?=
 =?us-ascii?Q?ditVWpAKEmz1P/nd+r/Un/h44glKTUeAO8erzWnts1vhIDbE6+X/whCYUtrw?=
 =?us-ascii?Q?RCogJscyqMcQjdYF4uZFYy+qbr/ZBuNsZQHmihNxdEDHr2ePs7YaMWSB9dbT?=
 =?us-ascii?Q?qZcltNc0knke78TW4F9M7pwqe3SHhLLnyxlQQJaFFHJQihLtePE7T6WSGXjz?=
 =?us-ascii?Q?+6r6TGQNR84xm6sqBx5O08pXOAt9/3poa8/kOgPL82rq93TOIwQX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5bdcc0-4070-4fbe-a0f6-08debcf0efbb
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 19:40:13.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+qnAq3NvYgBRO1BV0OUD/sqTNLqiF/otkbBBiibeWSUdVJzUFkodcNXFFSVX1psDPi1rNTYgriSvfDR5toFdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6942
X-Stat-Signature: ectosk4a7wnnpkunqrxie8rijmf1x4hn
X-Rspamd-Queue-Id: 228F01A000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779997222-737669
X-HE-Meta: U2FsdGVkX1+3/lHNQNVAJ8aNn7ksTe1aMpd1hN0C+c8cJS4K+M1xSKovBbx1lGK0DAEl0iV6S08r6jvckyLy0eNKxOAFt0Ykx2eyN/gb/rw9K9JZnN9uZOCqGGKS5UqhzvQHCvul1ix7quiksSp4Q6wz8tcMzd4HIodfjNLQOPq/ZkL/mcXme8GwdkdsJWVQZC0zD5Lv7an+PbS5Itq8ggmPhhhLDJP8FplSTDsrUm4qnAadd54/ofNHazOFSu1r8G4OHRhpwtcXhRkBCFfXYFHQQ/dznYnOytpGfI1+LkPWSJCdLoUSXjG13CGCCTymjjEtUEhIVA8EV/C4ebUTFJyWdu7IbOV0azu1CafBW4qGuqW5P82ZHu5XovfC3iq4n95yqX/tUNSKbG7QGQJrug/mkkhhjibiDkJp6KUfMN89qZ7pmUYeVX+g7hZT0MUbPspAP9UHg4HDWo94WYn82AHyfWr+IPIHksPK0J2kRLo5QXnK6vGa0LDeaFWybOveHUEpOOht1V5/oc04Z19ZaB5jnRn4w0k5kYwF0L3Yl8/aQmeu2wyUAXb8ST0yzc8mcTkuQgnC2ZJBSTrNN8j6ANKcyEZg7nBmGuBF2cKlxYSYBies+1CrVvQaQ/G7ofLTZ25g7z4H1cfyEZnAHC/Cg9vkXxOTXc65SlH2agzI0BCaEBiuoS4F/qR/pEL/IhOEFs4KpkmjneWK+t7NHZPCGWO9cgQlipfXICYAGUd4tkvwLaj6u9Scjq+KelJQYz4P9doKV2HJ94paDLB2dxa9yC8G8HGrBT41wV9dYqDahn/V9Lh/27Ge+kHJCXa8vrm2fY1L9va7LiTVO36GCoj11Xq18gbp2oEytDSssRXg3PcVFbLvRFaRFNN04P6InaAS4nzP3od6BV6FOlYJ5Uu9v7xVl1ysLeAQjXBFLlkTTnFb47SiY8SLmQ6skZhyVC3bvCeHE1bddCdZKmCv7Td
 j69AeYSC
 L9lrhBhLnTg94m2rf8ktxOfTgoPog+fSLrD5YGZrVfv7ExCVofS0ilAwqsqZrkYKF3rjONc/CymHNMFWIj9cmXg5/G9Ho9PMYtLTFc6cddQ+91Xbq6UcdVoWAd+0JK2B3bxmZ7W2I6ktTSuQgJZytqQHoALgQUNvkpfdyX/rWS4wLf1QlC6wXTQIqIeKhttG+ruTvaCkX6SkGzKa+hDZu+fJpH11X/LyK9MN4ixBHSzqPCEjCtsBVZi9Y1REiuUppYF6nIAaw3VVOVs76R1+hm9znM5zlWSEEOTWt45Kyq/X9eNvlscKaqXBnYnHKnzf92fv99wCDmn5MLtOUYg/1XKxoTN8queJrgN+TR4n8EbalSCxCL3x3T9awUuNqte/ryi7QspU6TeLsBDFA05A/2PF7macmuEJOGLFzpSXg3YvXyntN0phf8oaj7pVB0JCo45Kz4YpDRi7w80p5yUv4/3zwu50H/4MdVNNsCnfdM/4v+VFh2mXqCvbwKNHYC3gRiBwOorSR4WfVy8jZ1j9ILb/hrpPeIyofZZF3bYQ1YhZmZ/2UmTuhSlcb59yUCRQPG5OCJBfF31WVWzS9clLu+MEx+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 03:37:04PM -0400, Waiman Long wrote:
> On 5/28/26 3:03 PM, Yury Norov wrote:
> > Reassigning nodes relative an empty user-provided nodemask is useless,
> > and triggers divide-by-zero in the function.
> > 
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
> > Signed-off-by: Yury Norov <ynorov@nvidia.com>
> > ---
> >   mm/mempolicy.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 4e4421b22b59..cd961fa1eb33 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
> >   static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
> >   				   const nodemask_t *rel)
> >   {
> > +	unsigned int w = nodes_weight(*rel);
> >   	nodemask_t tmp;
> > -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> > +
> > +	if (w == 0)
> > +		return -EINVAL;
> > +
> > +	nodes_fold(tmp, *orig, w);
> >   	nodes_onto(*ret, tmp, *rel);
> >   }
> 
> mpol_relative_nodemask() is a void function, so this code should fail
> compilation. Right?

Apologize, submitted the wrong file. Will resend shortly.

