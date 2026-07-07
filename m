Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFDAC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEBE6B009F; Tue,  7 Jul 2026 12:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F2A6B00A0; Tue,  7 Jul 2026 12:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E606B00A1; Tue,  7 Jul 2026 12:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B94B6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:02:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B986168E3E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:02:43 +0000 (UTC)
X-FDA: 84962448606.14.7A3D5A2
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011068.outbound.protection.outlook.com [52.101.52.68])
	by imf11.hostedemail.com (Postfix) with ESMTP id 451D24000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:02:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J0xq6xmB;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783440160;
	b=SUQdZLG89M9a56PQZsBOzdeeZ8izKgJrWP32uniobhRr7EivHgxywpvQMQVOHPDqq/3zAy
	fsXutzzr7ZXXTyDc4ZHmdDA4KhrYdsdwkI8oi+swYZh+DKHJ0nupF06Kr6oW39Hlh5V00N
	/htfKwgL0EKLLHkmrOefmr3XY0kK6Fw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J0xq6xmB;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7SvUOWE0X1q3Nn2NaZQzXLwCZQsOZL7XiTak9KyNpg=;
	b=FXJbTm5z3e+9RGKNoTU6x6zAXipQ+boPynvD9TWrohSVAq4mZ5Ki+jm/s7v/1PMdykW8bP
	z/Tph+mJvtt4bdIlULKR/PAe4ox/uIWvxkpvr8bHQEujSBspe7k5J7vIKBqq33UjXKcIS7
	CigVcMhBm++9NsPjyQV5LXqZ+Gobmf0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JxqthDI+yLQYgZFKldZyxGgjTPydQTNamWLokVxnsgA28gC2PivMZZsQfdFTOxk0ggClD5vt6wwmiGYP2vQ2glYplxZSdcf2BmdPHrcS82rQQ4eImGXV735Xug9bdkZQB7bRh3DeBrgWNfi+R8gEPUHlIKiCfAMLqxYr6CMqzrWkCBeOTVzYG7XWMAg/X+lP8A9NgLNd6BVQBvqpN+u2uystVbkesSVxx3Ggc5wJcHFscgiTqB4s1DeyWhSwR0oL6r6FKnTylzcL8cVEi8oqocIbKJ7B8ZlyzZLeM/Hv52m2pfsUsr+NfQyFpzNFX5jvESwXpz05XarfYpXb6utHSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7SvUOWE0X1q3Nn2NaZQzXLwCZQsOZL7XiTak9KyNpg=;
 b=Ynh3LQ8/MeycEn4tAPpI+qCSMAVQQiED15HauEGxcxsWP2gHi7G3RCQFLkggS2QUnR/Wfn/lUKe+Zz0ecCSvp67j9GzJz3UJKgr5yF+44Mv94mi7RQzZyfopVb4FwAanMHBAPHBCVzpbnb20aIlU93YJFQHAcjYEAlQnGY46rHWyrRU5yRzGHpwccVIHJxz9kFx5GLwkjq1rI7oUaGKDGpneNxRUZzMFOiuoU0tW5V4iLFRVju/7YRJKAT6b2IcYYyU8usgHjVHCskmT6ytIdo7OkiWtuT2cxok5oRFe5mwMvF4t0Gwp/ICk04ZtlJEZbry5X98RVVpFzAzq6R8PYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7SvUOWE0X1q3Nn2NaZQzXLwCZQsOZL7XiTak9KyNpg=;
 b=J0xq6xmBhp2V/E7YW1B8dkwAxdjlNh/2/fguYDbrrMgWJcBn9N/AYyOjkBNTWhewBsRUob/8XDAOQRgvnPQJRoKuTEaVbs3+LQUTkfSrndBa9ZUxejHoikcIb248yqSjPJiR6lTDFgNp4V3l+uOcL/CUJnPN4mk3CcsxdS9gYXbsZbEbVUowyyOY7Clsi2OM5QUxuNVQMf03h7NsSc8iQDRgYXuGgFhmLB62QPVwF73F205hBGty6co5DaesdlVY1JS7dp+z1tozpcrhE8C8M7whJHEe6qsojYC9JRS04lvRrZDnpeU0TnsbpcQ4BaoILSRNMO44Ku8H9znP5mWVZg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7278.namprd12.prod.outlook.com (2603:10b6:510:222::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 16:02:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 16:02:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>, <akpm@linux-foundation.org>,
 <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/4] mm/page_owner: add print_mode filter
Date: Tue, 07 Jul 2026 12:02:32 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6C99BC03-CF3F-4629-BA70-E5FCFF359B8E@nvidia.com>
In-Reply-To: <117481D7-EF95-4123-BAD9-F9D24D1C94F2@nvidia.com>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-2-zhen.ni@easystack.cn>
 <670931b2-7d9d-4e37-a410-a2e7d85cfdd4@kernel.org>
 <117481D7-EF95-4123-BAD9-F9D24D1C94F2@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:208:23b::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c28e5bf-43eb-4750-5e38-08dedc4127ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|3023799007|6133799003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	C0mrAV9vDKdsFm0LP1Y5mxcg2fewUkjbdULsiDo0EUg7C0W945SMN5I+TqEw0lr2ulJlBnxoJRQXyGcNfdITF3xd71i4x8Ua5NM/g5qV9cpmpFShEuHKKhv/bTtBRA1ZScAXmEuHhat6L96zg6V6PR4WVktN4ADVAYlgsTvrxfBCrDxhZPk4mzFy3Nt/d4rrxcXdUnDguadVY3pfGqo9DRdkZ7lITQQC6UwTr0CoIVedDNU/2kmG2vLlgapAC5dXeLS9KTxZ6Dos8roovJqrd3/9ztgaWk76FAwWZfd4fYdA/w3UwDlVJKmBsAGPk1l3SSz/n8dKjU1YBZYfDzOpJOFCtgOdyPCSnEy29zML3tH+WcoM7YrfqWd5bMhLyy+tRlDDjqHLQGRs423o5TlfcD4YX3g5hOHQmXPTrx00WOauuYZBXUpIjVvNMizbXibxHG1rSa7NubI/8aXUHzrKyEReT6WpSNpE+R03UZgKxXcwEkp1Ma+NQb8HDhWUlDMErQqw30gsbtMHjh1VUmj0g6sL5YDfWSZ3BfL2f0SdpL+n0oNkg09P2Q9N5S3a+kIuftBhnEWxhVofQQRuAcoIKXTTSrBM0Dw3+6WEuq0rf04hAb96VLsinzOIKCA4CM/1F3vw6lh1CStvglHRzfRAXh3lcHtL8sVfmuFS2Znczfo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(3023799007)(6133799003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S5Aan12jSlCuJM8SftbDNV9DxKcn/VUAjWQrdtfnpHH1KqWQ7VMjClD/W5U3?=
 =?us-ascii?Q?ITNSPLxaXUnU+GktLe/SUTjCSclWtRwSyHG0gGao2D/e45GN+h5JnS5lBvfT?=
 =?us-ascii?Q?PgunmJ6EI3QO8SYpt0RCVeVH9Wd73Kk9AvndxRJ+pKT5OoTKk1jeCrAgftDl?=
 =?us-ascii?Q?/kAa3H5At55D9ij7TlzMt3J6zrCVsq7Z/d+kHyT9Q4J4sf6zs/dUaY8yEICw?=
 =?us-ascii?Q?q78/9JW9L775sZLs5IO6SVRals9yF7PfDeY38JQqW6vkV+TRyfwTtniTCPyV?=
 =?us-ascii?Q?A6ljXdHKkUfjBqvGVt0LQcaN2wl7QIKr9RPrdr//DLPqAM7+A4l0eSLFVyyQ?=
 =?us-ascii?Q?Vu+wuH1FsfS6uUQdeH162OxPYdoCebyijMPhHBuGomPE6MNxJNC5Pz6c+L4B?=
 =?us-ascii?Q?gWT1Tv+SJ4BSsebvasG/iYtaXcpHwa23VamOfX5gkj2Dkefn3g9o+f+zCErk?=
 =?us-ascii?Q?8mj15LKH4ToogdomVmVS125iwuQVh+xjKFMYC/cOZvPCp6mL+S2WbITz3lO4?=
 =?us-ascii?Q?rfrEr3YM47kqNVaRlwLM8NMKo8S8oO5E/OeCsKT5E5uQTWM/PVWZzqXDGUbm?=
 =?us-ascii?Q?DrtxNkkZmr4wdKm40lm25wFSPvAJ6RP0ISYVZIjfu220WsbsOEbP3SnH1JSc?=
 =?us-ascii?Q?8yXpvz5EeN9AKA1zANVQxY9hMf5Ae2xiBlmtg8GFRMRgo/XqD4Qg+W8mbXhl?=
 =?us-ascii?Q?WGDJh8xAmw9HhifZ69bVKsdsKpUP1a5xdFUiDPEcmUeSE3X2Lb6SKcDK3+dG?=
 =?us-ascii?Q?qXj43AZtDmGWvTcT2cSOfi89xcEzKPiPoZwduS0ViZgTlwJWlB9+h/Gk83E2?=
 =?us-ascii?Q?Tpm1/p3IIPfiqAjHNhw5fjskPNh14XZuDkYgmQoxLUWjv62HHDW1zn6aR/MO?=
 =?us-ascii?Q?815zVxSgFtC/Uyu5UhxI/qLcV8aIqTIMrxWwytPoYLrzt3hGPao7C9A6IMWQ?=
 =?us-ascii?Q?EKp0VSumwefjD/owpgOZdifhAdjBkCLPasOQ8YMmEDGgFbeXNGelfXSTo3pT?=
 =?us-ascii?Q?gydlXseRyHcP+A5qWWbkhXrt88cLQaxqjuRKtAWy/F5D9FpewXXWNQMbfFv+?=
 =?us-ascii?Q?+iVcHvcpauiaRVDRfls04BVVQKVIlJi+Ov7qpHE2FyEHcQKwIne2nvwUnIXy?=
 =?us-ascii?Q?dqDK1UvbjH14FTBQWF/jMS2nSVp1q8bEYRuvWuOLVVcQFU31KdhESHX+KRoG?=
 =?us-ascii?Q?vAeASv261znvXhusR//RbBOg1kHPSV+ik1fysIQd+bzBsXR7Ob4+bMHlXyst?=
 =?us-ascii?Q?RBKmjbmJJyH/nRAyICCDcDLTOIy1++ieHyR4F/7uvdQ0QH7XU87tDcq8qLh4?=
 =?us-ascii?Q?UaMpLuy0C0xNfb1WELG7UuZnXLP4b/lO3qHJwoITwIy3M17/PBnnftzYN0Zc?=
 =?us-ascii?Q?ADv3r9vG4dZzcViJEVv1fcnQYAvz2Q+iOQXyAck4LdBEVEvj2QbbFO7v215D?=
 =?us-ascii?Q?uz+66PTgK9GA1RfoCd6paG7LuF+YPonKtfbIZ0gGX1wLZBQX6EocflWsr3Ki?=
 =?us-ascii?Q?TZaN9sPpEMLdqJVcKaDeeFZVTmwVjK0w8YLoLd1h7if5Odiz7X/8bPKQamcj?=
 =?us-ascii?Q?QQYK4mZDaOl9ePEdlxzRxheUtLmYiEGp+eWXKdc6JF6WvR6+i7IUbfEqnR9i?=
 =?us-ascii?Q?n/Xv4FBHLlR15VEAw74nn0aLaW5Q3NmHAsQDhjWSl1SCXQYqkQ988UJ+I2P5?=
 =?us-ascii?Q?5sXJEhvUghcQ0ssqoMonTPC6WPRfBQDvtGQlgnk0b6rn+u2Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c28e5bf-43eb-4750-5e38-08dedc4127ae
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 16:02:33.1628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fB7xTnuv0pTN/vqjKSHrmiLzjHh5ebuO6zbMMwS2h7L+yz7FJCs5RBLr5jRdhlM0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7278
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 451D24000C
X-Stat-Signature: zzmfg1mqo8fuot5fqbar8wpatgpj68eq
X-HE-Tag: 1783440160-395001
X-HE-Meta: U2FsdGVkX19+L0QoCEjz1cSDf9sQvdGgnYARdRW0f5YX9bIqqLBd3CFXwYOYnSKkxUUq9Eg1jL/10S8fQpso5/fjTSYoPkdSEbxNFYUDDmoNItIzqh9JJ3ZKhjRKTUkvx93N40eWlk++Oo7JKfW3vmebAPX96iuu1sKTk7JOQFgnXJbJTq8XI0+xlUJgEBae5udId6FMHoUnQrbwN1W+40oiyVIgnvbLd8/gNPlTdJyyXr1yFb4bT9rChxrNyVCXJYVphlhtQGEgPvG/4GsQCOhsr+svkdV7fmIgOXyj1pN8Ty+R0aVpG3jET50VyNqJTlUx/cx457EVKutJScqA0RMOniwYbgZLm3NiNwAShzYtCxDS2LRgts7+0NZo6x5BgEGaAhen6ln1KgZv7avcCkSbAufYTrgRSW5ByJoWD5/u0dTUaR449W7zvEVXpQkwLlPlAcy6ZGtwBejjz7QQ9tONZ7rIi+XrgHA63beb7dgvYzi3m4NDOsK898GdXvPcSADZIZcWTmL1rakWvQurSQgG3dMfK/gibGEOV96cTMpVkQLPXdzCHeh6gqhSfCaD13gYtMNc4D44goygjVgFbaiQbljHJQPHqfk9g+u+j1+SClJ5WDTQOwrZrO8D5aHIUo8fm+2IL9CBddmgmCEUPaSMec0XcKktY5Ibxz0LunfXn1nYSXpBIERXTwVJxhEKe7NzleKVJMDRyGN/i7UVGTHFk+KohZdBzKu1WXynS7y07mo2OLipGKN9pBx1IWiF9tyHkvQT8zcl4ZSSk7QKgLQrX5xPB5oYt0RTCtTtA7BoZqttGN6ltPRuQyXN/1mPaaJnTRQd6jssWhA8ws8B2IOOa2Sltk+PD6qtnzqY9F1gVew5qBz3TE8n8C7GdX0jAMNm53CN6Wlc33IBvw/j+qdbknOSTWPPyCAijXLnWCr3jKiCta4PeXfTBH8v6tQIHOd+S9lkLtvUTDMbubc
 CGY3F/X/
 DI28aeSJDMf9dgR/bdi78IYLe1sViGCq1U3DW+jYawoIHF2uUvl6tAAmOeYH3FcAEcByJYItXctC2zBHd6N6Qa0in8Vu3dTPUz1YNkaHmMKV36K/iZdQ8QVG2Y1N3JuyJPNuV/3oUGrECbIqzU7JN6UIg5QpoQHfmZvr1Mn0GRnaz0eBONdmfWzMzJ1tJapT+AVv/f2r3KnbSz6VZMAxHNqH5Jn2skVQmdWiQVn1TjxqE6zMNb/69o60UkMqvBgXgkRrpzMMaacI3wn9Dd7nONeuwfvD++dp8UewY34t5xsFDW9b81twVburlkayeISgmP2JTtnbaUwNFfOI3s28QPSkjxFtA8SkI6ZWwEK/vYwUACP5PTBlCktvAbNVRaBNh4Rmyukya2YbfU2wS2f4Fo3m8wigsjQqWVsmOfABDAfc1CgIJMDuLaXQyFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jul 2026, at 11:31, Zi Yan wrote:

> On 7 Jul 2026, at 11:27, Vlastimil Babka (SUSE) wrote:
>
>> On 7/7/26 13:54, Zhen Ni wrote:
>>> Add a print_mode filter to page_owner that allows users to choose between
>>> printing stack traces, stack handles, or both, providing flexibility for
>>> different debugging and analysis scenarios.
>>>
>>> The filter provides three modes via page_owner:
>>> - Writing "mode=stack" prints stack traces for each page (default)
>>> - Writing "mode=handle" prints only the handle number
>>> - Writing "mode=stack_handle" prints both stack traces and handles
>>>
>>> The default stack mode maintains backward compatibility with existing
>>> usage, displaying complete stack traces for each page allocation.
>>>
>>> The handle mode dramatically reduces log size and improves performance by
>>> showing only the handle number instead of the full stack trace. Testing
>>> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
>>> improves read performance by ~4.4x compared to full stack output. The
>>> mapping from handles to actual stack traces can be obtained via the
>>> show_stacks_handles interface.
>>>
>>> The stack_handle mode prints both stack traces and handles, making it
>>> easier to identify pages with the same allocation pattern by comparing
>>> handle numbers instead of comparing large stack traces.
>>>
>>> Example usage:
>>>   # Using the page_owner_filter tool (recommended)
>>>   ./page_owner_filter -m stack          # Print only stack traces (default)
>>>   ./page_owner_filter -m handle         # Print only handles
>>>   ./page_owner_filter -m stack_handle   # Print both stack and handles
>>>
>>> Sample output (handle mode):
>>>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>>>   pid 1, tgid 1 (systemd), ts 123456789 ns
>>>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>>>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>>>   handle: 17432583
>>>   ...
>>>
>>> This implementation uses per-file-descriptor filter state stored in
>>> file->private_data, allowing each opener to have independent filter
>>> configuration.
>>>
>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>> Tested-by: Zi Yan <ziy@nvidia.com>
>>
>> I think in general Tested-by" can't carry from previous version due to
>> (functional) changes. Andrew can remove it locally, or Zi can re-test :)
>
> Let me do a quick retest. :)
>

Everything works as expected as I just tested the code using the supplied
userspace tool. I also discovered a small typo in Patch 2. ;)

1. I used the tool manual with NUMA filter + handle|stack|stack_handle.
2. I also used the script from the cover letter and checked the output.

Tested-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

