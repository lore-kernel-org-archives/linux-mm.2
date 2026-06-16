Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3CDCD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230CA6B00E5; Tue, 16 Jun 2026 17:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2076B6B00E6; Tue, 16 Jun 2026 17:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D266B00E9; Tue, 16 Jun 2026 17:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D41006B00E5
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:29:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B42B614017B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:30:57 +0000 (UTC)
X-FDA: 84886163754.11.B7F7DA2
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	by imf29.hostedemail.com (Postfix) with ESMTP id B034712000E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:30:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E+7dMLQU;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781623854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCXSbThCx+f+EBro6YnVn31/Pa99oDYYp71eNlE48m4=;
	b=o26YYPdHZ+CxdHHnJS2wxg5B75UYxuA4a9dLG4jTMKWK7ilSbot3pZ6GVFK0I2OtSBdUlu
	sa8ouINLRCA8iAPl99QmNZjLA/5foeReamBnWgHLkODiSM5iz66pCaDOoTX/pz/J6PNPhN
	590+r+TqTc/4BBMryjaZsLpRBNGlYJE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781623854;
	b=aN+Y+N7oshEViCHjtMRE9yqFy4VcXzIB7jbVaX6NajSNM+Evxrg+tEIZ4GuslEN3HC13tw
	tUcuPUwXyAFpeFIRq2t5cDmK//dckjBIUoQIKMF+oUAudMRhpyfkhJNvsEdwMYhQmzrnGX
	zGgBknnsI/ct6degHm+FV5XU2G8W14Q=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E+7dMLQU;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDizR7A84q+mjqWgYctTxVKLBk/Eg8kq9gUyxcRibmJAeieSjOUVZ1Q2HIgoNEzUcYIkWDyV6Tf/9ie9sEQcjh5G7Oy4GPwIOSu7y1muPaNoNp4XBhkocl/qZvENp0VcPKJ41tLfmMj/wEQEYU8cGnEV8OuUqVXZr3My0ttYwMdoTDwMl8OTHYorNioBvthxl2RKmnQb1mXU12N2mif4lVeBqwCEUgxk+WKjoI5GjhxBRYpvkft33WjrZ0IEeUDBRpe06Z9aPhdNKD96ippk3x4i4Dj81rorWGv3wcgmUlHWHFyVvVvqLqEL0jMGyh00M9HW6+tMUbXG+ABuIzEgjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCXSbThCx+f+EBro6YnVn31/Pa99oDYYp71eNlE48m4=;
 b=IujEUnSSyCgVpT2OSlcRkpg0OrPKiweU8zbVQkHU+ziP0rdeGMJbYD9RYC0sOTZpupSQV51H0zklDPaY0LY0h7GPhcn+UJQhCIfCuLNxYxKxBlKqTSAeZ2miXX+bm4zjE1VoGID8EakgRFV/ucPiByfcGvmkfga1FY+weSlDqAaOLSjEISrv9gtgkizjCz01O0n3JMKNhRUzy6SYbOSDHFOz2Pl8hKeYnxTZgh159edLD5j/aWomSP8YmeqlEb4DByuRiiMgt81mXmw7OsVbs0rgbotufjW63KI6+RuW96nAOnaEIQJYHWKUw2ivDLwbKYaNA3Y2gMqI1+enCaEQFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCXSbThCx+f+EBro6YnVn31/Pa99oDYYp71eNlE48m4=;
 b=E+7dMLQUZ/xktJxCPJ2aslywzKRbI8v5MVZoZQtU7e/b8PpoGZRZHiJU4jFX0XrEYopzhF4UQ9Z+r3OSakEr/FBMVleL5p6x3Ug9ZiEpi0hjWYdWb8SsxEcm0EsS5+uvSHVQiKCSCCZoH4TE+zR7fNy+HIIcrvi5sj0IJ2D6vYD9JYNWbCWCuz5Yu++YLX0AkXpD+dHpPLyyfJT0twteWtwCZITa6aHbYSTZ1WclyId6jmmOycgVmWvgq5NjjTWjnSPpaEYme2poO+Nx5QX1h2n0raTdNArOnaPNzuIvWMnQC3fuXru5xl+bMtkhTZ9Ia9G6qsTScuA43g1u/Pd9eA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH1PR12MB9719.namprd12.prod.outlook.com (2603:10b6:610:2b2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.18; Tue, 16 Jun 2026 15:09:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 15:09:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Rik van Riel <riel@surriel.com>, Jinjiang Tu <tujinjiang@huawei.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed
 collapse_file()
Date: Tue, 16 Jun 2026 11:09:21 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <80270584-A7A0-4E0B-8D64-4EFDE046F0BA@nvidia.com>
In-Reply-To: <20260616145413.1491961-1-riel@surriel.com>
References: <20260616145413.1491961-1-riel@surriel.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH0PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:610:33::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH1PR12MB9719:EE_
X-MS-Office365-Filtering-Correlation-Id: b70eab76-ffb1-4129-fb55-08decbb93fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	53I8lwVfj5TlaJF9jNEksPgdW3IfMsEiGtRggbBaJkmF7+NyQrJ97+fjyhR6ogBPfXQvmGtsVvYSarhBugTnVP8sI4x/9Jh/o6c2idggU/0sWctm5d48Y5RhCDySC2CPf+x5WVV6DYYiJAFby/w3QIHaVL/0t6S4IEcfm6nmoNYACrlQD72ikFFbmSTWe+b+4XobEV9nECsp84TIMf2u2r/zLsmLaTkxrvBS8MeUCcDfKDZkBdfTWM/KVd4DVS60CWKDHmUyfdsjOlXb9jKqSrF7XuTkOqOMrdMSRlC+Bc7T2tVvXZGF3wPq08oE+ot7CSVVnaaLOO+p4gthItlAdpcHQx92O/6VCJfpDOxYjxbsu5bb18eMnE8k+u6aeOUEid3fnX4UyKd+5Pt+338gtbHA8hPrjJF7oWry+bdbqlaAOnLERU9C9vo5o3BZjRDDZiyqzjLUbKcYq+j0VVRGvF9a1QeH9rZTBPWcrUaB1dK7hTKHUBRJ8TYvm0vI4gP7fN7lQywRdIYKjaMTSO4nWY+LlzKXHAMRXP03SB+YsGfTGI5e9Baz6Ba/BNqZW4PX7NQcJbp0j8+RdUNnzgCSjYUrpfvXLPAqSh2rWDIzk9U98ZlGnY1zWnR89jzG1Q/Bv8AqAbRyPuXIGTE5DiKE3bUnb3trXkIw/1Ze1aUyqJTiGcnnggXTydc+XlTR8aLzsE1j0Gb1MKhfrp7ZqvFn6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xJzTg3bxnEtZjVZ+RxuNVIjvS72YJb9DbSCDbHgSoEHoxOfHFv55xHOvuM8V?=
 =?us-ascii?Q?fFD8MURHbOtsuvZi3P5wG0TJ2RXUhXIQazF7dpNk2EZIrsu/8BC9Jmc1Vavv?=
 =?us-ascii?Q?YvrvUz4dyO+H3OLbGG4TzvbP4oJiFngZOU2/g0hqzaOt7AIWv6AdZlBP+eR/?=
 =?us-ascii?Q?XlQ26vF3k3cBNBekCWsxizwp/Q8hlhxY63eOeBHpvM7GMTMdzallJKnvQNHO?=
 =?us-ascii?Q?ONpqdKQ8mobrNZUZzBk1R07ZZpEhZtgCMAleEbXvkTthAYD2FzClAN0XAuIZ?=
 =?us-ascii?Q?AKB9X1TLpgFGoe+kDzL27WZu6f2hBRolIznXmwlFL+anQVzrp9+H08ruzm17?=
 =?us-ascii?Q?vfJbQ+S2H+aTurQIKIU4FE4yLdyW2e/lRFrV+axUS1u/EA22mA2UUq1kELFi?=
 =?us-ascii?Q?xEVCe4o/uumtqhbnVIigNwnaA1sknFFxBy4xrFejq+BySumNpDUR5cUA3bmV?=
 =?us-ascii?Q?M4/TIzbOCJJMU+x9drKPukLXp/cMRu5TCJgGXhK12Bh/0dAMf7av+P/VEOJK?=
 =?us-ascii?Q?9OHkdnpAR5XErQ7byvcs0pycV+UBlBZGDmuW2Idpu6kfOS4u9DnJUVtPmj4a?=
 =?us-ascii?Q?yrs623vfx7t/cTQQq/B0D+AXjECq227iuWDDWhYI/mBya9wzx/Ze9tzAZ9UQ?=
 =?us-ascii?Q?j9pT0L2zDn2c8+XHVpfGXv73uHChtS+RBqkAnDneSjkjJCzJ1iOODdptcI/e?=
 =?us-ascii?Q?kQ4jHntJtJ0iw4F671HOgLreK0jM0etNd41SmQK3Ci+QT8tvHqYlPnv7i+dv?=
 =?us-ascii?Q?KMHxk8AejiffdRkWYFebCQtOPYDDOHR227NEz9HTdNiA8QRy9V5c4R510cI7?=
 =?us-ascii?Q?m9RFrGXQnWRgXoL/AWscz6HFSXXHgHnGacTW84Wj5V+wPGVaQICHBk9rGtln?=
 =?us-ascii?Q?q7HlcO2ISAesVkIoXee/0F5bsYBOlqMt7SfS0sWLnf0stii/8on9Nkuvhhfp?=
 =?us-ascii?Q?WLaUE3zOIilmAUSJQyGcgvI8EQkEknQLGI7WW7pDlGkvhkDgxF4yI/7gRMGJ?=
 =?us-ascii?Q?hZU9QFtQTzUaelD9MySXKXp621xhFK1W8Sclb46S1kWIrSJPMb6tCRPRMtf1?=
 =?us-ascii?Q?ysjJb7UryCdXvyZssQMJuhNU4Hz6Q9rylPaKpltKJ3sjbS2BrjqW3g2dIer8?=
 =?us-ascii?Q?WGR5x0J0jIuQ6KQs7sjtQQA1ltJzNi08q2fgLQIBoAlTAY000oo1y8Q9UBS2?=
 =?us-ascii?Q?bzzBEPUnsZbN+5aec5Xn2Z3pwba+7gLPvRfarejuCJKuguaKdffwCYjmSxi7?=
 =?us-ascii?Q?C5Kaf94X3nMSJwkfZrQfxm+SI13wouWHuo6ePng3tiGxTj1V7xkSjcTNMy4H?=
 =?us-ascii?Q?vQGl3rAvXEbgwCRj9w2xGxIXobVL1i8Nb26hNKXahn7jFDrnBNmg7MflYsLz?=
 =?us-ascii?Q?/W82d/c3mtDd9yhjtwfHURzvDL7fj0UeP0fYqqH82K1eAzcle+eBL1Hd+qM4?=
 =?us-ascii?Q?hUO/GuGm6g0KVpzHryTCWliUkiQ72dTLn1rG9yUKvY4bCuwxNcwIjEPlqSb9?=
 =?us-ascii?Q?JRhtMswQZxFMJBo3lYSWKDKpPDHgCSaibz7vuu88kTst5Okl0L3qobHdWjfG?=
 =?us-ascii?Q?U0oveV9w2zRkV3Ti/jyQjLEzcJDntN8bgyEpYwMDDGVkL1WSNr2MEXOUDwRb?=
 =?us-ascii?Q?PKf/EmcDQJ+xC6gmT9rtLqzTW+yOp7/OhRw0yOSHARy+VpN3JhqkZFQ9G/uS?=
 =?us-ascii?Q?omfeYFYII2Fo7JjzMF4rBssH9q5HqCiIpoWP24CtGkPDKFIU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70eab76-ffb1-4129-fb55-08decbb93fe3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 15:09:23.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SIafaUBSwZeG4NFO7wRmG/qbIljInuk0YCMk3YTwnFQOmaTAADkdmtWwQ0oV/S3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9719
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B034712000E
X-Stat-Signature: 7dbs1atdmqwxcx4mf1ec9weoejqgycro
X-HE-Tag: 1781623854-85450
X-HE-Meta: U2FsdGVkX193f2Neoym/qoXdRRnjkUFRxgjAYORSNMS1vG0xjgqfXD025CS5RYK+K8JueakDt0y8gXOwBwUnl+XOggREAA9vnhKYaNppwEgKPROT9j2rBRhGG31HtfyZVoJWN8HE5VNJtOgsjXU7+zkc0CLj3mK1ngg02KQJE9AadCL8FdLw3uHK0y6Ofl5yh2gd0ivXBzUtpDFjwpApc8GGDYaDdhewIypJVOnjvCiVyiHM9XDZ1YTHfD34eIgjH8WtKHjiAORB9NxywkYpvs1TM/tMTi3DPYZjjfwk8U/Z/1E0fCagJdwE15ia6quvkvMnWjv6Fooavfwh+hrOWZxMH4jSci3C3zunvRAyVZsXioTCGfIawbGxaosGag4NrCpSKO/6FKF5bw7eS6+LIciF+5Qx4y7DbiWdNiRcwP2Is3i6xdz1yl8tf3Yct6uWybK41BeKaPe9hYjgRuEEtl3+bBW9k8kdFcWSVjMQh/NOdO0uiVJN53w+4KUOzd2ZJOMhgoLmSpDOeXnqlRw8If+b1HZ7jbbp6a3CyJhUP6WOtd9s/HwRqkDF5lNCatvYiPBJMwDYfHiaJMUEyVIyg5/5WIVe9C6DCB+6LvHFg9yJAaY3CGHAVy5EHt/GTJtEnbADYIGBY8OzKmXneR5AeHm164AFMKJakTRSW2KDO3Sqa2oYXdKxMhR7e3heTpt4Tns4L3nEl6iUVD7Wpg8eVik8U08ShTedYXIM4GjJxxwEmRdDGUYtDxfvs3zA/NnwWPunNhSSVBO9mQCRXemXvrK9ABZd3HYkCah3fDqvd1GzR7feP4n2APybp4N22vQdZkDNGfWDpi5yTRTcQkjZynyb7DgLMvZZ9k4/KgXsgZn0/dXBlQ63oh9FOMwPhRw+vctiVBAV40OTv5ZA/EcbW7d4lg4dbxgsRXJt2CR2d+vMH9+mB6syih93nl+WT9S+1YX5TIs4e4JZBsmMK++
 kedBNoao
 MoJzgQV8Ub+aOYWYaQQ4c4lTJDUy0sw4OXyJtGffouy7vBiqDURIeVOWICdOPmDzzxXaReWDh/J40gg3fG6DX4jQFOxfjjdUqCEezL644i++VTZKGEh1JOFADSI9UEggzqZ2T22phxWdYGBkMyirVh/CAmSyzVi7fyN0pviNMJV9PN6G9kRNPIWHFzz7auaVDwnSrx7k8n9vZirJ/7Oi/GenePeJLpFSmLXMwRdSDg/cqxoW9m+kzPvwMpiBLKYXjJgFTbthtQP6t9GX8ozV6aMdgGUuAGx2Rcb8n3c6IUglYqmJ2x6nV4IszmHnz6hWZm/yNFVv4J3dWsl4T/UZJBj0PhfevmpYk4HKOq7WgKAUB9uWDksH8mT7ek0J+cunrVtuhIrTQX6MwmAKzxGklARm7h51WdVCHk9DUyZX82IzZvpsXaQI4hYRiwGcYe+vlLKCfGXYHO4NRmy7MulUTrYdzmFfMiHRvU5pblwAviw66wNyES221d4MR+D+n7aEe7Qsr/At2BAUlC9AHS6QVwR01pqUSctAhh+izV3SXH2hWyLpQ/ejH4LFcR7jki+LzSNU+/G3hyWJxpjQTfeNgOLZpcPRK3ji4s89QEEtQF0w6HtFL5fWc51YhH3Df2Bq1Q5yERSS5bPbLotgOpoJQ4iyHkljd/pCHJe9bPmE2QGuE4wodA6vyq/D3TmTpHmc2+iQIqC7gdzw5GBSkhmaQ08Wa73Jhy1U60xTYtyPKJEx55mK+l8ltvNVfXy3NBb4GeIBmFHw4L6lbV08MHwo1GrgZXQc0efDPDFooR2srrVTDXj9ItJ6dO6NMSia2CNeZGMLW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Jun 2026, at 10:54, Rik van Riel wrote:

> collapse_file() calls xas_create_range() up front to populate the
> xarray with nodes spanning the entire collapse range, including empty
> slots for the holes (the nr_none entries).
>
> On the success path those nodes are either consumed by the multi-index
> store of new_folio or freed by the nr_none retry-entry dance.  But ever=
y
> error path that branches straight to the rollback label -- e.g.
> SCAN_TRUNCATED / SCAN_PAGE_LOCK / SCAN_FAIL detected in the main scan
> loop (which then sets nr_none =3D 0 and jumps to rollback), or SCAN_COP=
Y_MC
> during the copy -- does neither.  The empty nodes are left dangling in
> mapping->i_pages and are leaked once the inode is finally evicted.  Thi=
s
> is exactly the "THP collapse_file() failed" case that clear_inode()
> documents and deliberately tolerates without warning.
>
> syzkaller reproduces it trivially with MADV_COLLAPSE on a sparse shmem
> mapping (collapse aborts with SCAN_TRUNCATED because the range is empty=
),
> and also via slab fault injection, which forces xas_create_range() down=

> the xas_nomem() path before the same abort.  kmemleak then reports the
> 576-byte struct xa_node objects allocated in xas_alloc()/xas_nomem().
>
> The leaked objects are struct xa_node (576 bytes each), left dangling i=
n
> mapping->i_pages and reclaimed only when the inode is finally evicted.
> Nodes leak when a collapse takes one of the rollback paths (SCAN_TRUNCA=
TED
> / SCAN_PAGE_LOCK / SCAN_FAIL / SCAN_COPY_MC), and only for the empty ho=
le
> slots (the nr_none entries); they are not leaked on the success path (t=
he
> nodes are consumed by the multi-index store and the nr_none dance), and=

> slots still holding folios are never touched.
>
> Prune the now-empty nodes on the rollback path.  A node is only freed
> once its slot count reaches zero, and storing NULL into an
> already-empty slot is a no-op, so briefly store an XA_RETRY_ENTRY into
> each empty slot and immediately clear it: the clear drops the count
> back to zero and lets xas_store() -> xas_delete_node() free the node
> and its now-empty ancestors.  Slots still holding the original folios
> are left untouched.

IIRC, there was a report[1] from Jinjiang (cc'd) about this leak.

[1] https://lore.kernel.org/all/86834731-02ba-43ea-9def-8b8ca156ec4a@huaw=
ei.com/
>
> Fixes: 77da9389b9d5 ("mm: Convert collapse_shmem to XArray")
> Assisted-by: Claude:claude-opus-4-8 syzkaller
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/khugepaged.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..d11a4c9610e1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2273,6 +2273,39 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>
>  rollback:
>  	/* Something went wrong: roll back page cache changes */
> +
> +	/*
> +	 * xas_create_range() above populated the xarray with nodes spanning
> +	 * the whole collapse range, including empty slots for the holes
> +	 * (nr_none entries).  On the success path these nodes are consumed b=
y
> +	 * the multi-index store of new_folio, and the nr_none handling furth=
er
> +	 * up frees the ones covering the holes; but the error paths that bra=
nch
> +	 * straight here do neither.  Prune the now-empty nodes explicitly,
> +	 * otherwise they are leaked until the mapping is torn down -- one of=

> +	 * the two cases called out in the comment in clear_inode().
> +	 *
> +	 * A node can only be deleted once its slot count drops to zero, so
> +	 * briefly store an XA_RETRY_ENTRY into each empty slot and then clea=
r
> +	 * it again: clearing the retry entry drops the count back to zero an=
d
> +	 * lets xas_store() -> xas_delete_node() free the node.  Slots that
> +	 * still hold the original folios are left untouched.
> +	 */
> +	xas_lock_irq(&xas);
> +	xas_set_order(&xas, start, 0);
> +	for (index =3D start; index < end; index++) {
> +		if (!xas_next(&xas)) {
> +			xas_store(&xas, XA_RETRY_ENTRY);
> +			if (xas_error(&xas))
> +				break;
> +		}
> +	}
> +	xas_set_order(&xas, start, 0);
> +	for (index =3D start; index < end; index++) {
> +		if (xas_next(&xas) =3D=3D XA_RETRY_ENTRY)
> +			xas_store(&xas, NULL);
> +	}
> +	xas_unlock_irq(&xas);
> +
>  	if (nr_none) {
>  		xas_lock_irq(&xas);
>  		mapping->nrpages -=3D nr_none;
> -- =

> 2.53.0-Meta


--
Best Regards,
Yan, Zi

