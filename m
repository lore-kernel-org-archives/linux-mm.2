Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29426CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 01:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CBB8E0006; Thu, 25 Sep 2025 21:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7038B8E0001; Thu, 25 Sep 2025 21:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F22B8E0006; Thu, 25 Sep 2025 21:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC898E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:53:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CEF413B068
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 01:53:41 +0000 (UTC)
X-FDA: 83929729842.09.1652ABB
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id 248BE4000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 01:53:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=RH7jKwlP;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.21 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758851618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2j9UC+epAySYGoDbcEQDyafmSjP3q8LIWxCcFPQYoyE=;
	b=f8UpCkTk2rlnngkUV1uXDUJ2JIKFL6cLIgCWBvfcKEfr8a6rhtUWWpN6VTZzhCi7DqCFoc
	RFvzDTTgRrH3mkmUbPLziOMZBoXvX2tAzJWr61uB1xR/gZSCDaRy391y3bLFw/qpwz7jBP
	GIoA3bsLTtPlfze0Wr4rHiTKCuWPkxQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758851618; a=rsa-sha256;
	cv=fail;
	b=v+m+D5gJU35GJh7MT33mM8+qXj6WM6EtBCWFrHQZ1ZZWWqMaDRiG5voe+fWFvoLmfm1dba
	oAtt8VI5doA/1mn3pQhDtZX3gZDC/T5u9W7H227W3QzePFZc+yYzhyONnSm/8QA6zv7OVr
	g5/pTHZ3TrYZrXyqC5dRUHo/YEScTkI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=RH7jKwlP;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.21 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFlr9PU3utRvMncoGBOBYZPdKb4q0Gxlp4BVULq6gG9yaPKUDvrwY41WOsR5+lG50uWWEaFf6D3puXrCjHYIutVDkmxiQAlb5CX1tEPjFUzAPaWBHO1geji6SN1c3tlQRKujVgFYl2bIXQLswATRMPR5weA3ZufOhBO37t+S6BVyVKHyK4mWX+shKTSMNHzh7IJ1W+mCtSuDpHYaLqD7tuHbnzRrYrfn/ijwNHvcvBqEjE11RhwCPc46qaGq2YGJztQBoP5utmKAlVs0pqw8IyQ0IuBkMgvhmRxHoE3HnXZ4eNVeKDwtDbEjxwv/UEJ4gWuzjyiNfYScIDvR/vbyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZBI9rZleJnzOVk+zLOU31NIYOJmrtQ/resMy/Zl9yM=;
 b=BCcqu54Fl/zdU1HY+IHa/U40JsPR3+XrYOkhc10Q14RPLgw7Bkiie4snFMhqR/kJSBNztcwmGjxsO6kNzC3AXj21f/bZ/kuXhYMatS/j7H1LPgJprH77PH2jLz7TTWGTE8Q3FUD2neTIm1OPQ5Inejl2i1tqGSqwfXNFSHurwJbn1x8TcRw6t/DJwWQe/y5+tGAyklZqkrJDmX1KYWvFV0Kgfu6aRor8qXidM0/KliWo5HeNSyNTTq39z4Ud63zkvYIYbncgmmmr7GA8hsyefgCIoSJNr7ZarBytUZa/9mIht2Z8Yd0/Q0d1uDCF0hQD5wUhI6a1C6eeeHZZ5YeNBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZBI9rZleJnzOVk+zLOU31NIYOJmrtQ/resMy/Zl9yM=;
 b=RH7jKwlP8JoNGjm0orhiTcp+OfOeZUfVPsQ0myKfC/OLVi7lKrxxTF/k5FJKcicyngb9LOiZLNpjX2Bw6unEC1tFiJDv6bdPeQwDkPZAJ2k9WRh2w/vOcqdMwDIQJN1S8DgTi1S+XFgKwugAiL2c+Wabe5CJ+T16RzyUbcgXW6qW3dXhYwj5EuYLkOfohBN8qzgC5dzEYcjgpgO5Fg/xM1Ik9cO5tSNaiav3g+Zyd4YvN7u/NAoYN9u0CBfAK88fiqgq10H74WcMLc+fJFaVzKaWtCjLW5op7KugVEn7TZWOCKkmDmwNgEsWBMNnGjNFZHqNGotjjmdDUrLxUicv1A==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH1PPFDA9B3771F.namprd12.prod.outlook.com (2603:10b6:61f:fc00::626) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Fri, 26 Sep
 2025 01:53:34 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 01:53:34 +0000
Date: Fri, 26 Sep 2025 11:53:29 +1000
From: Alistair Popple <apopple@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, 
	Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v6 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
Message-ID: <3uxfirnfvki4kztyf3vac5vph6kzhnf623li46gmaqux5ivf5e@3uvtpfeymgug>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-3-balbirs@nvidia.com>
 <azcaqmqwdslvoei7ma4obtpxcdv7jdqfdc3ny4sylgwelwhfvo@okwd6y2oq5q4>
 <df1e62e6-57ac-4a5f-bf62-71fea47481af@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df1e62e6-57ac-4a5f-bf62-71fea47481af@redhat.com>
X-ClientProxiedBy: SY5PR01CA0051.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::11) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH1PPFDA9B3771F:EE_
X-MS-Office365-Filtering-Correlation-Id: 458c1150-e028-47d3-6fa7-08ddfc9f803a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?I5kOgucwaxQK+ly+VWIg7LrKOMpBkgRHR8GBa2bpFjznOXlBkMssMSqtmr?=
 =?iso-8859-1?Q?HCuIOFSa60qQIEYYdnoHmDZEVnQbxp8sxmeFY57umCKkVttdHhSvjv0jko?=
 =?iso-8859-1?Q?RrEfW86tx433Pe63HdtZSbPTRPKk3c+1X8rBfsqsvy73GzmfrCaXbEg3Tn?=
 =?iso-8859-1?Q?GY649lZ7qjEazjbs/c8CSxQb+HxnyyccR2YokEizsm3loH2tcKdGq1ULgF?=
 =?iso-8859-1?Q?v7lAShxR/mJQxFlbhmD62qdLmoENzcv2yR42z4SC3Rzl3Ttrciu0E2pK+w?=
 =?iso-8859-1?Q?Rb+IX8baSBt9FiCpEWZD2o2j+q0NyEclS3I2w96ORzULMBxYt2XP1vRLue?=
 =?iso-8859-1?Q?hFE8Ch+uhAmPec1uWjD1al+fXQzn1AVfAoGpkS0iAZgXT5laZs0Fq2fuRH?=
 =?iso-8859-1?Q?0+KTQt5QnbLlM3GgnfUINJK5nxTkpU3+KmW9ABAqALoyKdyGcq5KhdIdBU?=
 =?iso-8859-1?Q?oL0NoZnIf5oL/GvHQX7koUgGEVOsusG2L7DJIPyZ5WXCIeOrKR+TqCspLR?=
 =?iso-8859-1?Q?QnwcN6NH1ce88W8SVn6fRpFiFtTgQ9+gX3WPiJxrYBEsUXtviY9i24qFbV?=
 =?iso-8859-1?Q?DaiQGhLt5mqmcnGAa6+rxq0rThR+V3DTK6ogZyeBIsy+W/B0tgLCh46s/q?=
 =?iso-8859-1?Q?3G5QO2IG4DqnWhPMjeUsqwL8iq5etMWVcyruzHSZxpiEKaFGqSLlkW+etj?=
 =?iso-8859-1?Q?7IWXa3wUa0TBB7pw+Kn69Bk7DgWpTzFxNXKdyRWKJ50JI87zGEbfF/6J0m?=
 =?iso-8859-1?Q?BACvjZLodgTLlFv6VjxeEvuF6qNeekj40Bf1uzkTWzLeF8seJgU+QMTDOz?=
 =?iso-8859-1?Q?tNmzSmpHG0UJqbG8AlXk5k+qh4n7xD+qgOCmAeedSSPzuHtLYsSo07sNmH?=
 =?iso-8859-1?Q?xFNWno/IYPz54EP/xgDMa/ypEz/dgiAicCVRqHD4m0hboeDhhaJUQvCWJL?=
 =?iso-8859-1?Q?6ELZ3uRECAjD6nt0lyxrl7AKPv07sVDFTzd0xgqO1ctEkgdrmffebYKt8x?=
 =?iso-8859-1?Q?X8W6YqtGCphd6uVFE0QBcngstXhvknWfA+a/xDu2HQVq80oNd7mWmFtWom?=
 =?iso-8859-1?Q?bUXrikdw15kKeNO1/8NRP2NCgSvF7Ag2kamplRo8AFgrN5pWy7+mP6drfr?=
 =?iso-8859-1?Q?brP/HwbTCDmd9n0nmjMPNxZgF/hrKvhuKXqvlj2ttRajMpaiXTxoZUXpIP?=
 =?iso-8859-1?Q?3oem9akr1hKgeO0IfSCFy5W9JeToJCf2qMN1P2m+fMhBe+X7F3orIWWWn0?=
 =?iso-8859-1?Q?IBvUo9UAeVd+ht+Xrw+pTl37y4K7RDLYSZ/zlM/oh7BYR6vBh8x7KXaAxb?=
 =?iso-8859-1?Q?fmuGzYhz5GkOHt2sGsEixGJsOjRpjeGZRQrXF/bJav+t6qFsNPm4EMkKRv?=
 =?iso-8859-1?Q?WXhDj5umOIjERQr0dlhvOiJtViTW1o3uprDqQvv7t3WVMNkU0zSJMeVone?=
 =?iso-8859-1?Q?lslN/SVu+Cl0m8Ivc8PdKhF/YnbsyzquOLYLfTsy5aC7MfgAiKIT+AWFJM?=
 =?iso-8859-1?Q?wJz8f/WAgAPUkM63GIbbxy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?uDlflAWu0uuH3c8H5QWujlIJH3BuhdYQRrNDAelHLGK/psv6p9zkRV3L1G?=
 =?iso-8859-1?Q?asF28mwoPaLdNetyowj/rumR2jr2AjFeOs2QZ/8LJd+5nZTacVR8ILxvq8?=
 =?iso-8859-1?Q?zNagkOnoT6LyJAY1ud2AsJufkElZCkMv379JwTEkgMwxSlkkET0OLeKlia?=
 =?iso-8859-1?Q?maE2z6C02R5nEsayUHyazeQXDeJMF5MDkFnd1CkT24rao/h4Rv17/NbKuu?=
 =?iso-8859-1?Q?UR10bbuIZbGD+T2UZVQN3ceRF75wkxFGwPPrNSpfpYxp2OSEAYE64Fnf6Y?=
 =?iso-8859-1?Q?LdkL7XcQQJlzmGjWOtMY0Dq2jFy4WpumMzmMOmQM4t3L8jbZvq+ye0435t?=
 =?iso-8859-1?Q?uilb9M2b6ffTRS5Plg0KV+9L5BvGUad3bvYceaRTdlgU+WNrw9Vo4DXys8?=
 =?iso-8859-1?Q?Swa8HKTMGhiDBvlVw5yBVBKOZ4k5l2YPN+QlaexSk8nJ9PgIO+thp0A3QL?=
 =?iso-8859-1?Q?oUlghQEkXszIW7yGKqpJpBJj4YqF7DAK2S+ltN3vFxu6JfU9NagArpXnpa?=
 =?iso-8859-1?Q?CHe4PpIgx3L63Huq3A3sIQq2eeKTE7IaoM3rK+T3mcOcXgzK+vzMtJrPM9?=
 =?iso-8859-1?Q?g/racwmBeuAyL5KwcIugoHRlqYCJh8pLEURQcBk53kN/grNGd5RtoknncU?=
 =?iso-8859-1?Q?pni4zZy0zHPW/sxpLZtytHYAynJLk9ZJdPhQ3m1TW+/zZCTb3t6ZovRUeN?=
 =?iso-8859-1?Q?bkOss0J6+3wpafqD8lktla77fQlcSiXl5P42gMH9CU6UUgzIZxGYoDBkOr?=
 =?iso-8859-1?Q?jTgcGuaX4kIHYc0/cM8ipHtXuwpcwf394BZuoEzFDC2yIkmmwzimzxTvBj?=
 =?iso-8859-1?Q?RWHcmCTxKGi48io50YjFhZ3VJElRvv5XBEoBNv9xS8hMl2+RMkO9B/Cbsn?=
 =?iso-8859-1?Q?bTBIFO1GV/klvVAjc4mzH0fUG/9/jSpT/DIc43HMQcsSiUgYiUXqtTbBa6?=
 =?iso-8859-1?Q?95WCbHr4QG65jxHHV74SlbnZMlPjwKWpMTKdRZopTZ2iimszgUoIcT/QhY?=
 =?iso-8859-1?Q?zO5GQZiYdB21DK++Ky76RJ6ijBWYllqQDKSwntllmzHACjuh9gfNN4uxA7?=
 =?iso-8859-1?Q?LU4rVTkY9qCV1xeLd6PGDGJAqVnOsgReccD4ZBBthG1CKwj5JyWsN6LyvZ?=
 =?iso-8859-1?Q?Pa1SYyrQPj5r3RuaiPMCKg8+pb4PYpZKkVyy5X/M1yz4M0Z7kejvYi//G/?=
 =?iso-8859-1?Q?wEEVV2T35SU947WkTuNqssvM8uqYlgyrF97QnPUOGgrgxMfygEIT79011M?=
 =?iso-8859-1?Q?pINt4+eGcR6dzYWrYteCPdh2qyTOuetYjx3jFus1Op1/E3mY1wn2WCWRHl?=
 =?iso-8859-1?Q?5bLtQyPzmmUyQXJJGMzL+Dq+jZIMbIhA/s3UPHorPJewO3Ad+1RpzEtWhR?=
 =?iso-8859-1?Q?UNTS9H7xuTJZ2OwgaLJkyMywYrrbBNRLUiY4WNbSGvX8MVTuoZmTj2ftjU?=
 =?iso-8859-1?Q?eY6Pcyxk4aNrCV2lVgWvGZ+FatGdJtxQ984zrTq+zLTEZ+yzGbsb5aBGdW?=
 =?iso-8859-1?Q?q8s7p6gCfGQILQVEeAhUZAKsQGWcVVoT8tB5IwtqNHSSTEeUjXYq00mlbD?=
 =?iso-8859-1?Q?KruzbF1wUaNQXqmOvxjNuQS4m7hOcT2PrHnlrw8z7ufO8tQ4HgQhUolYyx?=
 =?iso-8859-1?Q?8Rzbsy9WOmgZYde/zl2TJBeDL6UiHOXEwz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458c1150-e028-47d3-6fa7-08ddfc9f803a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 01:53:34.1298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ohyy0UMyeshq1/+LjIQf3wAAu242bmGXha1Y9ukBo1Y4i/gNzORI7bHtmCGINsGEtUGeYoxIXILsvXv1QjBlZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFDA9B3771F
X-Stat-Signature: kjstqtq6pddwdjggxpdj3w1s1p65x348
X-Rspamd-Queue-Id: 248BE4000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758851617-87537
X-HE-Meta: U2FsdGVkX1/6rIWtJrHkzibFnZHdi7YdbLD4slTwTyl+ojrckUVhvJOjq316vhGyLyQAB8rlANU1FG6zrkZxNcrbbEOriX5X+NnuaaaJ6nxOY10iEPgKSBv3ZlCSDcvvpWj4AcO81+90DtoFOHdjzwN37W/4J3z8cGHmOetz1ia/Ni1GYcgVD4qXoXJ2rEAB//Cbx6e74uj66sFGZsk8DMvTIXiY8WMsI3zYvCxw/9E3ugRRZpBqmyVIpMJj/sMIicFaXEX2uMPeMK6V+dAz7MpHZ+NFXSN+JYq5Z9MdzUaTajPamcjxoLKXf2hi5Sl8p1P9pI/Pjz762MOat+yFOuj69zRX3XqdSZznGUpeXazoE6Fzo5TmzDKpWmmUOkdrLRin95k9SD8aDqW0t6XCSnDmHF9dR0z/FXzOguFsazcU9xwELCxALwfC12ktoecE+qH+NHx6hrWWhqvKY5DNPOi4P1NPBM47Vd5VZIwfYX6TGq3CO4jfr2rx2PN8UW2RtjYOlwXX2yDjUuAmBTwNCt6tPG217sK0vbiTl/InMNjAdjxRz7xLe+LeNL4sBGI6cL5aCvqeGiAnzXGRygJm4JHv+FMdOCfawEldM5xFfOrrmkD1kO9HQChIoY8d11M01T9ceXKKuqtT4sk87dvgYlb899BuaU9HExmzGyJ4d/6Nh2wLN1HR2tUiUju7MxnprudyMP5Khhkt3fbVayXUbOjbjjbhRfGnfoWGWYUj9mXoRZPryMKzBQyBbje/SoyWgPp7zb04+G8XopsR91uuPY9OQlfE3+RLrcl7wQlFzMTgiN6wRTmCBk7hzbu6Up+Jpq9yFWdUFdRD2zkerI3cMtdZ5tGnPFJiHY9mh+ZieIo4+/Aaj/NpyfWjX7JTf6qqtiZ0pOl7MczXAMUnCoLqs+08YfphbjiqUinf9izqvLSqAgVSUKpUV8hJv5Qg7GDU/084g6tDXmSOwDcVwvw
 0MkdWMg+
 3DyO347ps8HK2McNE3dP/qse7Xf+j6EQIn2iv75qZDMYERLdowRbLjFwhKVuGAiwbj3m8Lydp0Ousr07DmwE3vv2R/Cu9kdFDpDwRUhUMM62EPuWFrFOtBjwRbA0d1DPx04RXGNdzLv4tfsTC+QLlNdSdh9E9RUOtd/Qs/snro0nDwbGAJ+2C+AajeiRuVs1v5rVzOdM0UhpmfnLkJEMswbEAZYWk386Der29VEJzGcuaUDinfLngrOpQPds4fVELJzWLNfgF/UhCcCIZdKM7vJcY4046Z7H/99OypTjZswha9guDKdPjqsazYffWVKKRS9zJBUWJAy2j9+1dfllunFKnzYe5jegyQNHiVxc7dwZ2pF5TYkBSxCng6PzyD9ComaqE6de5R4DgaVwB3kbzG6CppJkX7AHtIeLSBK4cNfaqbfw15qalN/lyXFRrABtHZFPHZwM6XnwAywzqQWG0xJhzuKyzY4EydqagJlV80kJBgK4V7ITGm9sXGUY+JBR4hzFV+w/Zp4fgtuQsNh28XSshQ65It9BMdQ30W3d25x1nuN735v5qe/ZCkKNOTrbthGqiRTULGR4/jKRwi3tC6I30w05ikw1hcSskWIAPz0oxar7O9urviICm8Y2P6ZOrdRbUMB/xgCOatcwyJ3O9p/V0qHiFdn0trSoFXUk9GXiHSxu8rBb9673XSiTwE3KSc8KqJms4PbsfUuh4Aj2m77HQwF7fWcDYV/MOxr6Is/PafQ+V2XVvcNCXKETo5IzNHo2rLwph04M9hmOKjrGTQv8HS915fTp4JZX+PvE5OZg1RzIserOJgkCGHCluESvueXHTEoj6Z5FoQEXikGCjsFeZRnp9VMu7lkvW0lHIxF49+NLogojlBb2npN4BOXM2Fv/CSxK7NOXFSIx5MQ2c4xCnnfBKBENET9oEijv66RegP3HHBn2t8atT64JwJgnnmPxaZa9szEAI8OFf3h1piYoXwVUJ
 DOQnlrvC
 ks4dWJxrjDNMChfXZ6Mz3KRgxzWoPEOTb0Z9e1qNdRnakaGRJXBTgvJp0xwCy002qqvgyF+oc5ksYY5Qmt/Q/4WA3Q0k25cE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-25 at 19:53 +1000, David Hildenbrand <david@redhat.com> wrote...
> On 25.09.25 02:25, Alistair Popple wrote:
> > On 2025-09-16 at 22:21 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
> > > Extend core huge page management functions to handle device-private THP
> > > entries.  This enables proper handling of large device-private folios in
> > > fundamental MM operations.
> > > 
> > > The following functions have been updated:
> > > 
> > > - copy_huge_pmd(): Handle device-private entries during fork/clone
> > > - zap_huge_pmd(): Properly free device-private THP during munmap
> > > - change_huge_pmd(): Support protection changes on device-private THP
> > > - __pte_offset_map(): Add device-private entry awareness
> > > 
> > > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > > Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Zi Yan <ziy@nvidia.com>
> > > Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > Cc: Rakie Kim <rakie.kim@sk.com>
> > > Cc: Byungchul Park <byungchul@sk.com>
> > > Cc: Gregory Price <gourry@gourry.net>
> > > Cc: Ying Huang <ying.huang@linux.alibaba.com>
> > > Cc: Alistair Popple <apopple@nvidia.com>
> > > Cc: Oscar Salvador <osalvador@suse.de>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > Cc: Nico Pache <npache@redhat.com>
> > > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > > Cc: Dev Jain <dev.jain@arm.com>
> > > Cc: Barry Song <baohua@kernel.org>
> > > Cc: Lyude Paul <lyude@redhat.com>
> > > Cc: Danilo Krummrich <dakr@kernel.org>
> > > Cc: David Airlie <airlied@gmail.com>
> > > Cc: Simona Vetter <simona@ffwll.ch>
> > > Cc: Ralph Campbell <rcampbell@nvidia.com>
> > > Cc: Mika Penttilä <mpenttil@redhat.com>
> > > Cc: Matthew Brost <matthew.brost@intel.com>
> > > Cc: Francois Dugast <francois.dugast@intel.com>
> > > ---
> > >   include/linux/swapops.h | 32 +++++++++++++++++++++++
> > >   mm/huge_memory.c        | 56 ++++++++++++++++++++++++++++++++++-------
> > >   mm/pgtable-generic.c    |  2 +-
> > >   3 files changed, 80 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> > > index 64ea151a7ae3..2687928a8146 100644
> > > --- a/include/linux/swapops.h
> > > +++ b/include/linux/swapops.h
> > > @@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
> > >   }
> > >   #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> > > +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> > > +
> > > +/**
> > > + * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
> > > + * @pmd: The PMD to check
> > > + *
> > > + * Returns true if the PMD contains a swap entry that represents a device private
> > > + * page mapping. This is used for zone device private pages that have been
> > > + * swapped out but still need special handling during various memory management
> > > + * operations.
> > > + *
> > > + * Return: 1 if PMD contains device private entry, 0 otherwise
> > > + */
> > > +static inline int is_pmd_device_private_entry(pmd_t pmd)
> > > +{
> > > +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
> > > +}
> > > +
> > > +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> > > +
> > > +static inline int is_pmd_device_private_entry(pmd_t pmd)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> > > +
> > >   static inline int non_swap_entry(swp_entry_t entry)
> > >   {
> > >   	return swp_type(entry) >= MAX_SWAPFILES;
> > >   }
> > > +static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
> > 
> > I can't think of a better name either although I am curious why open-coding it
> > was so nasty given we don't have the equivalent for pte entries. Will go read
> > the previous discussion.
> 
> I think for PTEs we just handle all cases (markers, hwpoison etc) properly,
> manye not being supported yet on the PMD level. See copy_nonpresent_pte() as
> an example.
> 
> We don't even have helpers like is_pte_migration_entry().
> 
> > > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > > index 567e2d084071..0c847cdf4fd3 100644
> > > --- a/mm/pgtable-generic.c
> > > +++ b/mm/pgtable-generic.c
> > > @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
> > >   	if (pmdvalp)
> > >   		*pmdvalp = pmdval;
> > > -	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
> > > +	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
> > 
> > Why isn't is_pmd_non_present_folio_entry() used here?
> 
> 
> I thought I argued that
> 
> 	if (!pmd_present(pmdval)))
> 
> Should be sufficient here in my last review?

My bad, I'm a bit behind catching up on the last review comments. But agree it's
sufficient, was just curious why it wasn't used so will go read your previous
comments! Thanks.

> We want to detect page tables we can map after all.
> -- 
> Cheers
> 
> David / dhildenb
> 

