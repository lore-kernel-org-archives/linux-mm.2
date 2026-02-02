Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B73AE7DF0F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1BE6B00C4; Mon,  2 Feb 2026 12:12:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C316B00C5; Mon,  2 Feb 2026 12:12:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91236B00C6; Mon,  2 Feb 2026 12:12:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B48406B00C4
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:12:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CB7816023E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:12:01 +0000 (UTC)
X-FDA: 84400159242.17.980573A
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6BB52180002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:11:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C5SXQxLU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770052318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5Ny9VNgPU8uBkkhwgx8ketSMFR5KnL2pr2rUqDrL3I=;
	b=7RAN3Nxn4Gdgrx8ow47kblYhl6xGcNNWnsUg09NEVRKt7RgoC5ngzwNh2UQsDGUFmen/0d
	z2YzUO0qayqIy05v+LFH+syrMJ+ADGfz7bBYkezwdJSLXjK5EmBN/duv2suJq+zKNHkd0Z
	Sd4AyxIwfrlO8B+OWyDGMjWWcuMMAls=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770052318; a=rsa-sha256;
	cv=pass;
	b=HmeKorzpF1X7iaqhXfXYuc6OD4pm3Af3YXp2srvzSErttH49CkycLwtb+QfkJiXFH9Kbuo
	Db1y423kmitwQol1yTkVzRF2u8shAAJUnCBWqPhTP5bpH0eMCuxWFwiY0ShQV7xIh0q598
	307xd2sKPLglAUyj3adxIQ05Q1nsQsk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C5SXQxLU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hhcC57Quy/XHAESm1X1Qlw04Br4ua0ndDaS8jIlJLAzBXD2J6Q1GIwHlwq5sKPASrByo/4B0QHs1kLsyy5xLz2CiTylSynbOEuG2DPjA3IpqDRlPJq+S8HEUAjK9/gJ4NqyKclGhkAx2V5Cc6j/Oy1HIVXeatvfja9ZrQjy1QzH5HDVfytlOXp4byu9sQ57u4McTwIL3ZdaTUIL7aG/18TwZIjh4xcxwSKcau+O6h1+Kl6TQDgFZYp6V/KokFGvLwlSFbIrqT5A8yucSnTX5wneK/WGkVdMNBRvhTbR1NXIuCN6v2mAuWKbgFzWVmYdyquiuxdI3SqCFJqlTphcwEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5Ny9VNgPU8uBkkhwgx8ketSMFR5KnL2pr2rUqDrL3I=;
 b=hWNFfTVN4/itFgnhZ4dTRzL1YCLI7TSG61w0PDteoR0QQB0BnUyN67Ikup4eoALu17KSVDjIL4g04Sy1YdeCo5iurUcvXmDgombUoyBMEy77q3RMrgnEiTM5tUkS4oiEwoSrIwXZv6htLWoqCpmnokvU5gNCRnjUp2VHSzD/oSmKelm6ULoLSu3JxSPcQ73AToGyDQsToG36RD9g0Y7Tg8mEmwOv7rKiz5pOAh9zY9ijAitom2oHQoHOvmKwt8bKMq/nNUHIo7FE0Oy4w76b1tNKiR16wQnTawptTtFu/bz5wMKF7Dia+FRlnWB9egD+R3OW79hWrT5G+Zvibf00dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5Ny9VNgPU8uBkkhwgx8ketSMFR5KnL2pr2rUqDrL3I=;
 b=C5SXQxLUCjCLjDACpFL8p1D2OZr096Wg1AK9jR47eEDnb0C/fmRaVCdEwFUQB/JBVYgrPFAvUq0tYvlE4ZTTeEwmMhJHwAQrR95T7LfWRANQJnjx2iYcVY8dbixxefb2thTFXskD0wPp2IaBiQKTGv9yOSJ8VXCspmgegq0gJzTvCrjGptm6aUD8+VUacSDBhG3vJ1MLHkZG2mX1z2V6SVrbjimYj3GMjg3jKDv8Q6QpUx1pssr9qKfPJRL7rHt+wESh+8EjrVDy57PtEuaDa68o9y6OCdq4UvC5dPhXg2oIXyWbmz9nFbWNA8yYNWmkclthNMu7nTpV3iRLaysNPg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 17:11:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 17:11:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and
 avoid deferred_list handling
Date: Mon, 02 Feb 2026 12:11:45 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <21EACA83-C358-4FE7-BE2F-415A7EDC1485@nvidia.com>
In-Reply-To: <5aefd2ea-8eba-49ed-bc21-f84dbab8cf3b@linux.alibaba.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <20260130034818.472804-4-ziy@nvidia.com>
 <5aefd2ea-8eba-49ed-bc21-f84dbab8cf3b@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 7adea42a-2c4f-446a-f6aa-08de627e2884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JDRqB2ySdWFbf/48Pgmmy6CsvpJ6Y8amKPUV2GbX1GqEIzf84aeJdqAmBMn1?=
 =?us-ascii?Q?7KKKbqUgx1nP4RezoWIxme2k3yt6pXtPhEYVuVC2fEh4sHvM252h4R4QMRba?=
 =?us-ascii?Q?PkhyA1PMY/qwShIAZ08R7AQEib5YmdwhyJitfO6KH6ZmKSS/NHj9Nz5mbyok?=
 =?us-ascii?Q?89EObDz9Oz9U/PHpy+fphSQAapMvqW5G7STUOgF8PImJOJ7VZud0yWkzTqXO?=
 =?us-ascii?Q?Pzf1yey2W0CpVjDkQ72346tth9TRD3ahjcXtzRaDKKo1rwRDZU9Qhtop2Os2?=
 =?us-ascii?Q?AmWrGn6UTLycZJgtbJa3iYDTyB2/+W1kaVwXWre4y7aZ2Uvc/F9vkPWEOUL4?=
 =?us-ascii?Q?SDiy4VTUc8FnyTC41Mc8PrbcZzLDZSkFJseisCRIh95V3lFybLkjZE8RZ+MB?=
 =?us-ascii?Q?RI+zrh4K1MKWiOM60x79nIP30CP9ThZOUQI7dMhi7eP+XxC/aleINixqTV1k?=
 =?us-ascii?Q?ONjy3omNukKnYpsUMqFRLpPLDIwvCs1gwcbad0ktLWGFl1CPQOa3UhMufDki?=
 =?us-ascii?Q?QAMA3pgoXL0nBVF7a6GJofc7i8Bvw/LofjDxkRZlFCXFnXnxG4euQIH2R7Xp?=
 =?us-ascii?Q?d0VsaSxMF7BaIz7EG8nAWhIse+5FXeRKiuat36x+LmA7htY2HWub4iDl4cqo?=
 =?us-ascii?Q?/Ditfule1Qr9tHPlYO+4aTAptVIubE7hTpuBRTf+tvMhFk2I8ojujTsqwZgO?=
 =?us-ascii?Q?pK6oTaq1RmpYaJroeOp4nLDmfpbRMyqZEfno17LHLY9i5CSBq0AXNsS45CVE?=
 =?us-ascii?Q?QyOeOBoSPvBJDidPqfZaWL+fWTS6pl/uoTRakaqkSmpcyw+dlCCxsdXRBnHz?=
 =?us-ascii?Q?S9qeHQ+w5GDsJYlC3cUVq5mRHHbiy2gj1BL6sGQcxOuPM68aVpKUbHyOem6A?=
 =?us-ascii?Q?EIqES5Vgr7nuBAqmLufwKbgV9rSA0IzsgrUWZ1g52aYs1Bc34bqSeSadUyDZ?=
 =?us-ascii?Q?jDtR8ZC/VAjRn9mbNJzcsPbvxOjRewfsfX5e98Uwd6NRGc+pNcSTnnu4eFYJ?=
 =?us-ascii?Q?H7YoHgEB96LyvVDD6SVrNtON2kFsyFIM2gODp/rWzX6PPhAATRnxfEYWD76s?=
 =?us-ascii?Q?W3IAoC144kR3G5SifbuF24F0VHMuvFRewLi7hapvHmGwnpxtCJMsYwSnM1nn?=
 =?us-ascii?Q?gwcEdzNWhBWobAOPI/S5X7+dVhUR1/exMjPXAxdYb3uj4Es1splEid0vT8SG?=
 =?us-ascii?Q?xGOSuNBaLjYr0odww99HS2R2rTAYsZgQd8wllVAbAuJHWiNxNIa0gRbo5v5W?=
 =?us-ascii?Q?RhlX53MqmE9RyPvnna4D4ges+3O/YD/I8NSdVfborps5iAkzSrefOxJwVLnh?=
 =?us-ascii?Q?X2CurLnSoqYQkULvecunm9lfDkNPTLhrOaKOVMSgdJr+KL+eZVPu5uM1iTjF?=
 =?us-ascii?Q?GOhtRbQYJWeGCS0CGmK86Q8TFpCimrV+UOn6WQhTR4UjvdY0TML3fNfWQ4wU?=
 =?us-ascii?Q?P7byRa3ZJuMtcUD7t/4j4eUrNck9G9/aaqW7WAX3yU593UrrTqKcdthpEntE?=
 =?us-ascii?Q?tDK1+LIjJRFoqEq+SyMNbhdqSVB6hT+UGTpf7isYlUmpSh6zTXG7toG2hNFB?=
 =?us-ascii?Q?ghb1rK0eqwBupxGDxkI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pdgXSLAL37McizAz76Q0Zm+1hpuccN0Htsqg4rWw94NVM0eASP1UnP4TjDTx?=
 =?us-ascii?Q?8iw76aEX01mBIN8cxE1Ct2KUWbYJ4oi2HP3QdYD3trJskDkmDWJNhIYtcLbv?=
 =?us-ascii?Q?i6dP8SUstDBJKlrr3MUjT4MoLcds7tTVTiOGH3gQMgLT0mOBGjfO4Qmp3j2w?=
 =?us-ascii?Q?HKDrZ/DKbvuWi6ngVV39euR1ZbtztYTKVsfAZxTpmHlSeo/s4bIDf/9VdCoS?=
 =?us-ascii?Q?FRY0ewkE1MxU0hm9Qh6cx/A4qM5ofi//T8ES8rmgKQ5TFt6OWGBSzHlUuRhO?=
 =?us-ascii?Q?TSo6Py1bwNdvnhV6DFshBzVFQ2WZQjhJMgzlL8ZmXuprt+hggRkd9DhvJLXv?=
 =?us-ascii?Q?WrMV+4ACgzcsXa+P2rzVk7/nW6ztgzY57DghXLntNcQyb/if+0YbbvX/bark?=
 =?us-ascii?Q?0U8zz1AkhiBq9HITMWkUo/vaNN8eZvbeVdp/eGmDy4FIwBt10qtZca0+7GoP?=
 =?us-ascii?Q?xcZogYLxgcn0IwwqdtTolTB6X0r13UBVlkPMEoz1GC5lHUofKnjLh2bNdvov?=
 =?us-ascii?Q?xJoUlEZuzHU1948Rkiwck518vKv+XjdsHDWYJHfi+rexyntqP3JHJ2ZzM2OC?=
 =?us-ascii?Q?ZwuOmqO0pazWqgMfJRJdndYJynfmcNTJpydgrwOULCb/01Aa8K+ioKIsbs9k?=
 =?us-ascii?Q?phsvQddK17EXFvIqshDQ8LnnHJqsmSofQRlNyLu6Q7u+zoGV/dY9Yff80wn5?=
 =?us-ascii?Q?etPq2C8nEEme6uAQc5C+BcviaLj2vnvCtCg0bSgeT/+5h7B8gv+0RY0SEMX2?=
 =?us-ascii?Q?4BN+2v1Y9SKgwdOOhEbeEZq3fACW2QRa65T3z2lrohu/t6JwFzNFwbHV83ww?=
 =?us-ascii?Q?vBEs5uuZUat/LTkJASop/zhsU1FK7RVVsYLGAENQ936wRxR9XpEqZpr5z3kk?=
 =?us-ascii?Q?k9WTgfG2QxBGxxPTmiITP2708paCN1Tnuh4AEtUDllYc2jNDdJzpdwn5Oejp?=
 =?us-ascii?Q?mQtrfAZ2B1mnsk0nqQC3xfKRQUQlMWW/Ka7depzWP0ofHk+HIbOBc50PSms2?=
 =?us-ascii?Q?yPSoz7UI7vzyw3XqjN4WJayoaaPMs4dZ6edd4YMLHa+7YBDaFGfnKSbYmbwC?=
 =?us-ascii?Q?fWQF3WPv/Y5LXsQA3f3YsnbUeYxJU/vBcZ+b3AKlS/esrrSTDZhDFGFFfJ7P?=
 =?us-ascii?Q?PU6pXdd/09OPDHuwk+arSWa3h2kSHTdKdtAgw/0fTTsD2Z8/jbDjveQJlwZK?=
 =?us-ascii?Q?m8DiKAUAKyiOfU/FAdqS/LXdpWtD3V2RcD+gQAbhARfjdnxFMKIx6kM9MmiM?=
 =?us-ascii?Q?5gyROteBiliatzxEx8K6Am5OhcfrzenL+q13zpJy/8ikuUcKZRtoxPvpOpY0?=
 =?us-ascii?Q?jDrtShhNg17pU6uX7Xm1aD2RzkrA9AHnK5hz9tgmMZG14vqBxu6TIjcBCUsN?=
 =?us-ascii?Q?whtaYxTr2yCg5X9cDGvqMbOtciqBPOLncjOzto1HszYWJy4GYnpD6mzFnXJs?=
 =?us-ascii?Q?HWjLrw1IKo7omNywFK2opjMQYKZUjZuMrKRcU9VXvRquJJygdvw4yCGwkUtJ?=
 =?us-ascii?Q?skpfv1zYoE5U47nWkWfuLXPJQ1R8M4wz7KdjQY2P0Vl5tIb6hnz+eF5CyheH?=
 =?us-ascii?Q?E1vEFQl8+THgbWKm129cnyRYH5tKAAY0x3CWRGIwI18T93BFP/F/6IJ627i4?=
 =?us-ascii?Q?a8sUyL/FFk8MCVDp5ZZXcU0grVntkSU5nvrJnE82RNizslBEk2pBw/bL1c1z?=
 =?us-ascii?Q?Xn71e01/diRAxbSsvwbRiGpbTC+p1oYcmUvhlIxYjmO/Gmtr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adea42a-2c4f-446a-f6aa-08de627e2884
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 17:11:52.0353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8eGEDRfxsEF7INCM8KD+jNdEnn1sjurAw5YbYMC/9bXfpqYmOrbf9XaWYuUlEdo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025
X-Rspamd-Queue-Id: 6BB52180002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9pu6471ro84qp4dgjaz1go7u583o9swd
X-HE-Tag: 1770052318-513206
X-HE-Meta: U2FsdGVkX19a65/KOs3sXuY5MfzPi//614AoKEtwNQYWodgDlcdbjCNnPN07gzLRIQgXpNQPxSadUpVUJEV7QDk8O4nNeHwXL1ABzH6e9wmPhE+ySHWph7TCcK/QDTExQpSzJLZQfLWheodjKbkynDNPuvd2vRfZW4tCG9fwobjyCRfYXggfZDUIK6cADuNwiApdwepHSvQWgcQDkF9JR4CxtI6vJpZMg3p5Oa2aIDqMUx1cd9ysAfW/NqI8OitoHAZ9v60DmWPrGF1SB3887qdwKpICicYxn517WXn3zRd3FiBE/geucW2vT6xBvFOArboAIY7m/Y8zC4nf6OrNW2XcHIMo11s/sqbOSKucJCZmSlBWAK0lrUtVrkepfPCQFDABqs+nsRrcwkp8++3zrH63kLrHlI6eZWXmdpwvxxH9Vj5Ox9vCZxuV2YqnBrr1udcltcZys7weVMc+yWY4k9G+/KD831DakkyTdOKoVkZwS+L+wU23QDTq+IUVhA6kEbL2a2oaAJv+17ZRSAiPcx7IbH/VJ/1p/2a09f7TglkkSI4mcOcC5ISmSm7FKA8TVds/xqXTEYcScUlorq1EW3YdBNZO9kpcmKLd27DuAj89WfzC/5qzrN+F1Kw4JDRFlhEyc9tGUA2bmbEizKMov35RIT/mhkbXFGNJkIGi0+qd7Tfl0qxfGKRILfI5ladxowGLNnBY9kU3p20NY890MZKr+3nSY/7+i4BMAtVmRykfDrGdlIu5D5Zx0b7YL21bEeMaKugzdYN+jtiQ7AP9zGOMEZorZ1r0z24kdJqTR2Kjcm7xmrBJNhThKBoDhDezP9+/M39WgYX3ahxCqSOPqX3om1NYpitc8D1f5l/HbNrSjq3vBrJrzr9KPKhdg52whhCPfCaVzCEFzf4/95XB3RNz1jpkDKg2ZkGeEb4m29r913E86Jp2hFJfNu+vu83YIlzuS7RaGBTARkzOx/H
 Vau4bd4N
 f4md5z9ma+7Gqy3V7bdG/3n98+FiHt35PoyU3xdHWEx8zKgYcRGFOfX+Y2Egkogrn1lgYZliB9Osq/Nn0ZQyCD81RShKnY9Vr81IqSD2wscLFmKF56IMPSl/kr466nxsPQO3LXumgA79VrzdCXIbLAJa+qb1PL237wDU2UGT87kqw8/3HeTSDtqWchtIz7NaQ2yIhE7rrxN+B1H6PllthFsfJ/uuJjprSSjLoBYNc4TqRezqGx/orzmGDGKsBlFhIpsxKOTx9qizp0MurwmVTvNbMpoCL2o70zFydx/v+6Ps8UEQzPgIs35VyIlO5C9XBpszb5Ady0XuyzU0Fe2o74ZVsFkM+ChVGXlDsPcmCzqjuLE3AXhU7BAj15w8xqKIeLOUa0fDJpa2YpwpNUcVOqNt8nnwlkErtruIm80jL/1GZnGKZfwlAgi0kow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Feb 2026, at 22:59, Baolin Wang wrote:

> On 1/30/26 11:48 AM, Zi Yan wrote:
>> Commit f708f6970cc9 ("mm/hugetlb: fix kernel NULL pointer dereference =
when
>> migrating hugetlb folio") fixed a NULL pointer dereference when
>> folio_undo_large_rmappable(), now folio_unqueue_deferred_list(), is us=
ed on
>> hugetlb to clear deferred_list. It cleared large_rmappable flag on hug=
etlb.
>> hugetlb is rmappable, thus clearing large_rmappable flag looks mislead=
ing.
>> Instead, reject hugetlb in folio_unqueue_deferred_list() to avoid the
>> issue.
>>
>> This prepares for code separation of compound page and folio in a foll=
ow-up
>> commit.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/hugetlb.c     | 6 +++---
>>   mm/hugetlb_cma.c | 2 +-
>>   mm/internal.h    | 3 ++-
>>   3 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6e855a32de3d..7466c7bf41a1 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1422,8 +1422,8 @@ static struct folio *alloc_gigantic_frozen_folio=
(int order, gfp_t gfp_mask,
>>   	if (hugetlb_cma_exclusive_alloc())
>>   		return NULL;
>>  -	folio =3D (struct folio *)alloc_contig_frozen_pages(1 << order, gfp=
_mask,
>> -							  nid, nodemask);
>> +	folio =3D page_rmappable_folio(alloc_contig_frozen_pages(1 << order,=
 gfp_mask,
>> +							  nid, nodemask));
>>   	return folio;
>>   }
>>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
>> @@ -1859,7 +1859,7 @@ static struct folio *alloc_buddy_frozen_folio(in=
t order, gfp_t gfp_mask,
>>   	if (alloc_try_hard)
>>   		gfp_mask |=3D __GFP_RETRY_MAYFAIL;
>>  -	folio =3D (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid=
, nmask);
>> +	folio =3D page_rmappable_folio(__alloc_frozen_pages(gfp_mask, order,=
 nid, nmask));
>>    	/*
>>   	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index f83ae4998990..4245b5dda4dc 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -51,7 +51,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int ord=
er, gfp_t gfp_mask,
>>   	if (!page)
>>   		return NULL;
>>  -	folio =3D page_folio(page);
>> +	folio =3D page_rmappable_folio(page);
>>   	folio_set_hugetlb_cma(folio);
>>   	return folio;
>>   }
>
> IIUC, this will break the semantics of the is_transparent_hugepage() an=
d might trigger a split of a hugetlb folio, right?
>
> static inline bool is_transparent_hugepage(const struct folio *folio)
> {
> 	if (!folio_test_large(folio))
> 		return false;
>
> 	return is_huge_zero_folio(folio) ||
> 		folio_test_large_rmappable(folio);
> }

Oh, I missed this. I will check all folio_test_large_rmappable() callers
and filter out hugetlb if necessary.

Thank you for pointing this out.

Best Regards,
Yan, Zi

