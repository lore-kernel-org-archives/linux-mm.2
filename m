Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 844A6CD4F3E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48BB6B0027; Wed, 19 Nov 2025 23:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9086B0029; Wed, 19 Nov 2025 23:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6706B0027; Wed, 19 Nov 2025 23:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA93B6B0027
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:00:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E7144EAC5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:00:23 +0000 (UTC)
X-FDA: 84129633126.06.3F3539B
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010009.outbound.protection.outlook.com [52.101.56.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA2E820007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:00:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=di5RUCR0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763611220; a=rsa-sha256;
	cv=pass;
	b=TARLQv2HE9fYlk5nMU6QYWXNA3qnOOk/Yc5ibgVSfrQ/LBBI72YpYU88REe0iu5JL0NLtG
	V7piZwPWiIckjSt+x9UGyJqYmtandDcDLPScx4Eaojha4UEAbEavRR2guhjmD0UmZyP9zR
	GaQMDmbN48D/QPHoOE3vwOpWh7URV4Q=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=di5RUCR0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763611220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hC/Eu4Jx2z0iUNE4zsURDkO2uo/SWStumed8rZ0IYUY=;
	b=sieAZz33pz7P6zVe343nwFgVy7xnMfY70SK97yTHri7vTAx75ycldA2BCofZqyHvlAEoYB
	MomAeStzhEnIoD2jSWODWcfgwpvj1XrGYUIUx5heHl5ptFg2ChmhBa6Sp7jKmzlzVNk6ut
	mXcXY+JeaubHiP9ZS0TyHWdsqdfaE5A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQzj6Tt1WgDnv6LGMHFSmAg6o5ItF6WCui0LLjG7XkzAB+XH83jPFhsVsuV83hRLVgt0ynFwOiR2myrF1MHB6NjgwjwTlCcv+GI959fQXInxyQvH+5ss5XZXEQu2sp61yo9FaG6sohCZr5Dvec2BXTh1VVomEpFBgvyjbh+0KeqfBbDawM4IgNzvygNNs7BGm+qR9yo26uJwB5GKj4zbmiy/D+/EiERU0d9w7NfrXgofAvhXNo5651gnTwqdAIzIiCkSDLjyf1UDfrrPY88ReYJ3ghQbyRyQD3LoDSbfhYp3uvVcW8/OM+DhTswpb8SmJXWbK7sShVI1IzgMqxHqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hC/Eu4Jx2z0iUNE4zsURDkO2uo/SWStumed8rZ0IYUY=;
 b=YgAlbZ6Et4ENsn3NCQPnkglaXk2geolVq4lw0Ggl5j6Qt1PI5n98D5umTb6A10t1ghoKcaq4eBr/SP6MMp1R4DyI3CDDcCplk/vFATp8miXjrDgKPbWU7xQ+Vk3+Djpe+pTYuQr0MVvrcVhspaB92EdQTrpSNMJZ8cG0hj8pRSljiXrdA1LwmZrYSTc00GoTiqbVwsLLbRby/z1RvBwJT4goa3FLpyM6KeP3kILjbIeUMmXnFJvQRiqbVzCtF/C2UwjwR+Wg/7F8Af/2npQ6rn2A14aSmqsjpiamrbNj2CLEXJBRT72PgzQdfWFt9D5F/ccgfFanImQh9yIFtSaYcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hC/Eu4Jx2z0iUNE4zsURDkO2uo/SWStumed8rZ0IYUY=;
 b=di5RUCR0n5MXHsPD9QcBQy6/P4Oyf2V7812onrl5asC82NbSuxp4s99vpHurJoWakiStVdPu5MlGtP2EwtSqbd7hySoine5HTMnsLlxG83HS38U+NuAMiIgJbqmDZc/66dmolqppByXBIftEFPraRHPxK/mtR/PfYj0488JBTDRwbTn3qRWICKzmuFkCQLn+bcHxY+gAQxqno3C9UH9bTWYPYvAtTtnyLkJaaNg8Dq7SGkner4QH0IahnnJWQ4ABIYTYKlpBFf5z70zihTQYwVey8l33HwYlkh9bHhxc/uZIkrj4MIi1QFsc6tU7LdoyzF/fxXqmUhEtWo0/5OpRhA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7914.namprd12.prod.outlook.com (2603:10b6:510:27d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 04:00:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:00:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] mm/huge_memory: add kernel-doc for folio_split_supported()
Date: Wed, 19 Nov 2025 22:59:52 -0500
Message-ID: <20251120035953.1115736-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120035953.1115736-1-ziy@nvidia.com>
References: <20251120035953.1115736-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0106.namprd02.prod.outlook.com
 (2603:10b6:208:51::47) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c17b399-4777-4e0e-58dc-08de27e9499e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZxZ9aT6HLb3WMjihSxHALK9inOC8+NduMmopiCOP6Xjjt1k7WbU2gIl4Nva+?=
 =?us-ascii?Q?17oMHwIm0Z2zMtrIuRe1hKqM37xD8WX6+qf1v8KRod6yqrgp8y9arg/sv01w?=
 =?us-ascii?Q?0orm63QfBgGNHqiG0LzWMghq9Ckz6KcXp6JJMEH/10fDflAnKWLoESh0SUPV?=
 =?us-ascii?Q?QlI2biS3UZ2obxc5AORAyKxF37pT+5LjDA9RYoOJa/Fnb5Sjj59d5yKvYV6h?=
 =?us-ascii?Q?+nBNvfWskX0j6GZRkpgeA5StAuflnMkihbt97hfLJWs9hqe7Km/Vd6MolKzu?=
 =?us-ascii?Q?1Vk5hCpyY3U8A+4oFqPiezWALZ4Ge4uIIHZt5ddOheYRHMiyb35QRVnVfQuC?=
 =?us-ascii?Q?WQX8fmvVr375ssx8ztGZOauKAaNHFBvnL6qWsV4t+hgB9WppM1DykYiCocEe?=
 =?us-ascii?Q?glikrd5FWwhgOi5zAOhFx3Ubqn0FW6EJhyIXKzoa1krPAIiBkOCD7Fi/o5wB?=
 =?us-ascii?Q?HdrHWGREOsS8qEfHCS0BMaOzLc9UmKFecBAyBwmus6g0u8G6nO0wNREn1K7W?=
 =?us-ascii?Q?sdSXvREt7p70r53uVNC1ecYDodKVrTZXBvf9fMA5Hgq5zsxlUGfAWSe/f85i?=
 =?us-ascii?Q?tWJS/ebR9Ik3yooS/z3lcLf/8m+8QCoEyLjlHjbWV4WC0hCzurYb13Jioc2k?=
 =?us-ascii?Q?xbavZUKRHIuyWshn4Mp2iqySLfu6A5qRnYe8uvZhQOxQYBn1Pj3d+61x0mUt?=
 =?us-ascii?Q?u5OxkqySzFAVzy8aW0pxXXjMNRclKpY2C2l3Y1cB1X9XLDCqfmh74ef0FprZ?=
 =?us-ascii?Q?nqNKbNrZ5UUdHKJ/Dg2B8l0M3ee+RMq4R146XMU4GvGsYgK86oNrqxgkTm+O?=
 =?us-ascii?Q?fYgIyijr/pqRjRoZRpD8wsdOFWH14OS19d5rbHCPvkN7+II1/e4k3WOzvc8A?=
 =?us-ascii?Q?Bv6iY+vyM6wNrw4tIlDzgYfxuk2lQetw25eSgBILflXXdFj46Bd/7GK5yPMp?=
 =?us-ascii?Q?jfuVIvRoAAioCQ/pM3x2IHmJC5NGhNoH13gH9vZb8jknQEjpcFd8i9fJqUBq?=
 =?us-ascii?Q?749yLNN5WV07ivAp0bYmnBBglF0BHvOgd0uUbYCv+ltAiVwionj6gLF7Yq5k?=
 =?us-ascii?Q?QReB9uBIx72J/18MXoXZP8gtq/snlTMH/WloIP+W/0gW2NFZEkIwKre67hsq?=
 =?us-ascii?Q?oTvoZqF1EiDoGREZWn0cjYA36NGsl/el0vGTv9f5YjO+WX6fqUfrkbqpgbFn?=
 =?us-ascii?Q?ThryjQdL8r/blE6R5KdRKR2lLbfnv4r5Yqx4muFQsn8kEwJf6Zhe0ZH7a+k7?=
 =?us-ascii?Q?LUFs3qC/9TnC1rlZQMCVRCMfma8YdYz2uZS13ZdYkQuAin0njvYcxTZjprKM?=
 =?us-ascii?Q?8grRpLbSeIi+y7a0zSc/3h3giVnW3Sna79uZya6fYUdjOrUpzp1PqIm42hkk?=
 =?us-ascii?Q?N6Rj9aKF5v7SzdQPSyjZJ+CQTzmJ7J8KRHSixHGA6b33zZr09EnIqMxEv6g4?=
 =?us-ascii?Q?1lAZii/k9ZLD314dbTfb21sfxh7Qj58D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fODwzjK7Sc7LKM5I0wodLdjeYpMUFQ2tV5RcbOX6RHGBQnCzHcN9UwLH3v5B?=
 =?us-ascii?Q?IGK2xuuYWd+3IzQNgqAe6Cy9DOeg3SK5g9l1c9RQVTY9UsRdhqHxGn2/1Au7?=
 =?us-ascii?Q?n5NEjZFhcWyJJVVkY3UtPGEcDoMm9Net4zpC4hYtxMxEpwvjZQIGT94hYq0g?=
 =?us-ascii?Q?pUOAva2tBBlCaBoaWiejThm+82kFZ7nuFd2UT01peCvn2aRUUTyTZO24Vfyt?=
 =?us-ascii?Q?RpzGKlYCtvSHzxF8IVb8PbvWCKqt9s3Rqujrf2Gc1QI7HtBkE1E+L4bPB1vX?=
 =?us-ascii?Q?+Uw0q+BthlaEIXe/q3p7niQOWqO+Ek5HeB/q4B61oK5oJhUTmj7JH3OPlw2h?=
 =?us-ascii?Q?NvOB+s1mN4MdPaZmIk2DeZXipMM9mjKfoG82+vfFgX21TcatisHaHYuUYEdX?=
 =?us-ascii?Q?62LiOBai6GnDH9gHhRT7bO1a8gvdbeG0BpoUQTqN8LW6d7yEqkTW9e4guXzC?=
 =?us-ascii?Q?J7DX1ZkYurCUMANpDLKGKiHmXRBGmMNj5Gx7C+XJYOdaQ8Cllx/1jq3ss7Vk?=
 =?us-ascii?Q?+557ODUMJxIbsZgdqsLPBQIoniAgbco5a4kZ3YLlqF7/l+Iw1TmbKrdt09Tk?=
 =?us-ascii?Q?DS654vxBRMB61BfQlMDhQSNi+nEckdqDpwY8y8EYLxfa4c3R7RWGbTVVqtRB?=
 =?us-ascii?Q?aLKaxyYzt2we8D4U53n0WyNivlRDnEmBvbhzGL+bqrmsAiRA1kIYY/y80rMc?=
 =?us-ascii?Q?OgMkajOFUcOAqs3O4iH4SyRLYQkdO8nAVPfigP7PhSPGStL0I742tXXeSrf2?=
 =?us-ascii?Q?n6DIRG5b+QLR81vIeKe14VFSr/MRw8U9K6Od0rFmuhhWXM4zzYZRyeyIV3T9?=
 =?us-ascii?Q?zQCRtvpjmDOeC94Eg1pzcwRfMyMrsYIPkFQpcQW4ygxoYLtnleObbzH1LcOq?=
 =?us-ascii?Q?ZMEuoS/kMAVUVaWSnxE5JDT/yTu71xWC/7mD4MNka5WdWW5Vlq2xPm7hm28n?=
 =?us-ascii?Q?JWgXBe8YmChLaWmD3zlAT/awMVnFNNUul3MZ+LqzGwX6p2J15oS1lANMj8Im?=
 =?us-ascii?Q?8mfFpqtL3eoKggxwHH928blUAGsrWkB9xfVidvUxD43scy4b2BYFowOVNX/0?=
 =?us-ascii?Q?Wd2cj0VtHUdg02BsWzltu+vrYE+pcViZDcGO2u2i0CtXp4E3BukvSo+dzEmu?=
 =?us-ascii?Q?vvpkClhp92KINO29awYv37EGQ7VTWIjcpvxx5SnpXW26vJs/Irvjn68V0v1W?=
 =?us-ascii?Q?mVc57j/2/chehxkfu0RKRg1MVu1UAaTmIZnnTTG1hMVK1Mg1zGIzPlnhm606?=
 =?us-ascii?Q?k8qr4OSf6wMNAhOlpTskd9qWoKWZ0geXjg5r1rZ/8IhQR/zbVKCPnujBnVM2?=
 =?us-ascii?Q?d3VH/BIlOgZykDtxjF/n2itwEaggXZ+qrJS0cOPm32gQKbny6BX7dsakbtsT?=
 =?us-ascii?Q?hNT5mtXOkLefCJ/13WWQ3CPI1rJmD+AtKQHe8VQMcyrdfDObNCG3OoY6VVsP?=
 =?us-ascii?Q?OM0wwtHkjPqW8NmNo6bOCsKulbdNFVwXva+0y5skYNtuHMsZjgNb684QCZCC?=
 =?us-ascii?Q?WuE6KFUzZrk7pRuqEB+VWhdyfbZEh0rP//6o+RF4yt+XdwIl7MTT5QWgbluE?=
 =?us-ascii?Q?qeb32W/Q176sgssKRuv5dsek2PCKUANbuuAONUan?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c17b399-4777-4e0e-58dc-08de27e9499e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:00:05.0344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZ1Lt6+4oiTMkk0KfbFOjLbSfYKL/9e4eOxK1jgHa6RksuUCsZ+UI2G9tOHFUF80
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7914
X-Rspamd-Queue-Id: AA2E820007
X-Rspamd-Server: rspam07
X-Stat-Signature: hq8zumctt5qasxstzkprfwquaejtramt
X-Rspam-User: 
X-HE-Tag: 1763611220-483026
X-HE-Meta: U2FsdGVkX18HGrSGagRCf5tuN8L9FK6glWn7ekz46sC/VFsktLQGl17qzgNKFEePohEnCFOulo928CC49mcyr/S5exeH+gkU5D1usINbCtqJebA3gMbCYK4UT9RdFCfVFUm2wNTTeuXEIaIGwN53iUshydEEpRJZinx8OYGXg1oY9RbRDl/alLBrw9KZMc5qfmKi2/ngZDLU2GbbkoYohsq2zPhj83GYTwluDENWSdTvnyLFfqiTBMq4wpSt9g4i/tjHS0o8zOYfX/OD1Lolat42AzkAsJTZ/aHNWMQ4yAC/9s/+NU0mmFJ52trFpHBxvc4CxFBVgjBTyLw2UlXOTl+PJwlzWA+hiXPX5H8Zgi3OJs3F4/hIS4b7zWzFtJAko76PJ19TWpbltgWCMdivH25QGgT5GuN4W8y7Wura+40g4lu8obJAJaQEeMtseHvqWWgvvhKXdTVh1z7GWRUWZUJHDd6JiZA9ASDrhYwEzNRzGTyvvkr51RkCFxq0vh/GZWwG9T2JCZThxhc5aYf7cz/On8qbn/UgNYNDk14GIfDPUFHUznLKronuOnbOGck9GoV/PYfugI8WtoNzHLefFWuYP+TTqtT0OCO30cBFVyequYJspvIKlEuitmO2YqKQZQHSKs8iLeWl4ZG4JgNwesnDk/UWPxcKuktQ95dSyKGGOKGOnmNr+IELUnr9wHKJPyjXGHnQmD/OZHgvm7VNDEPW6Sh+0KQLtG7Z2fRIX+w5nb2iLNe8sW6L5SbEQaPv7vK3ab6VvskKYim8Lz1dJn1q0cZPBilr7nOPKM9c7szXA1Lj4ULZnWPHMU9EleK/FidoOKfyvOmzF99BycwSBZPact6hXuSk/v7+HjRBpAONZ5J0qjqX1zMyRcbNewumZWicrbhXEpJHe//uF1m0iU3z6lq0fkjmF1REke2GhEVaSdxi3XxSwCuyNGKL4USUMyao3zDF4gsEmp+vrPQ
 17kRE6Z9
 4lAhK2dNGqGR2ZtS/UJ6n0ZD5d2zV/E+pixWSwswE/abfgIIZCH0A2wMlRNkSRgEH/HLSQTF2ZCmLs4mwnoCJje3/pqvJuozLnbS0q8pR7jJQXnY3SajRmNvQSxt7ZwFSWiuE6wwrbxs7xoHZ/oDIdePqI/L271dYKgW+GVW1ViqYHW5NeShhwLEAnewK6/DH3kb6tCnagC3fMQxgs51lFMPj/DcJRwpXK2Z3wu2IJquAmCwUNK5KEcFMW368lu33JS4gQCY/Bar2l3QAAmNwuk6Ojpa+GNSOg7I4C76ffm17jTWnaFdq1lEjyLyj/x3UbldmGcEr6LXINbl00vrSvfsAB/spEca1yhPfcJEqsAfAgCe61OxUvGaMh50Q91w+XYiZ2U/idYW166Yadb4bUZUCljIS8zy5puXQYG1rlMXaXQu2bXmVX2uB4OZdX755AxNmHMPylgj918DIS3qJrp0XOls0iygV0qTl/7ZJX2wU+I7/LH+qfrz7nnLDcXveDtn2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It clarifies that folio_split_supported() does not check folio->mapping and
can dereference it.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index efea42d68157..15e555f1b85d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3688,6 +3688,23 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
+/**
+ * folio_split_supported() - check if a folio can be split to a given order
+ * @folio: folio to be split
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @split_type: uniform or non-uniform split
+ * @warns: whether gives warnings or not for the checks in the function
+ *
+ * folio_split_supported() checks if @folio can be split to @new_order using
+ * @split_type method.
+ *
+ * Context: Caller must make sure folio->mapping is not NULL, since the
+ *          function does not check it and can dereference folio->mapping
+ * Return: true - @folio can be split to @new_order, false - @folio cannot be
+ * split
+ */
 bool folio_split_supported(struct folio *folio, unsigned int new_order,
 		enum split_type split_type, bool warns)
 {
-- 
2.51.0


