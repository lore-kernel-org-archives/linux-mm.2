Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A68CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED766B008C; Fri, 12 Jun 2026 10:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E796B0092; Fri, 12 Jun 2026 10:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5667E6B0093; Fri, 12 Jun 2026 10:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 412546B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:12:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F28954011D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:12:24 +0000 (UTC)
X-FDA: 84871450608.08.EB368B6
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id CFA881C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:12:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vgzk2egl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781273542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvfzITKz7JtmukBgR86pb3iisPyGBBDFz23aXJCQnik=;
	b=hELNRH970zr9ms7iwklrV3zvOYrw35iZaa921aXKG5Vt33L5LSJv8Ktj5/ObCdq9aR2SwK
	wTRwYu/hHk+gn/xIgbNJoPExLTuYsWYoV2cHaMULhL8VoiQIJE/VQxTEqtbfuPx8Axf8vE
	AZK9FfQWbQxwisKqeP996ywZoGtYLhU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vgzk2egl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781273542;
	b=wt9jnAf6fog3d/11EexbQl8qWGnieEEyWmxi3QXh+3kwdTARvN/QBHK0KNuEXNG63mn79q
	B8eJsbn64mSdJ5gXdMfb/Z57Fh+twh/k2O6hdOYjQMNyTdN0cEoBciAbX4rFrhQ+7f3n/D
	Cyf3A6ydJYqctIPGgZzu45xe4K99Rtc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xvl7x+BCH17aHAjlxeBiCEkapQ39UKMHqH/N1tEyiAo0/p70C5Dci5tG4kaoM3xOdvWqtXuTOxcoCs2CMRLsvc/nwm0gJlyAEMuODS+p5FjPsn+otwh9HP6Ic8EK9iHggwF05C+kYBsx5QXoYgV8Zii42HkH6oWejYNzW/nlCRpA+lcDStrP6AMPyWywjliSq5QRCWGImaqbbOouz8S+UeHtWP/TlNU2sjS4EPF+3z+GbmRrbGbPOyevQBsxkaolbWvz1JG7FfLWQs7tDqQC9zmOnQ7fDCm/mg9XxTf0b67yvDLDpaWHYKvmAsxR3VA/e5Uy6U4c/a/BXmXH1h7g9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvfzITKz7JtmukBgR86pb3iisPyGBBDFz23aXJCQnik=;
 b=V8nlMyGaYnZW3o1X/kxZslWhtLqWY1tr1JiYCtrs54AQHJEXAyu47nrecxhYhKoWNl4Im1KIjrBiW0rDt5BRPzb8TlATnK4W2z95a4aZhfNpNIXCN4EOwnluVihEnyUDoBqTaBvle/6IQTL1jpPDbADUTTXK1p4b584ySIyOUMsogsJEmAzwenLgpmaklAd2ofqLGWilhguLT2lZEqsUVqrx5zaOD26Ss8v6fW0aXb0tReKL3VAc8zb2WDHMR6LyH137zwOh4hQaGaGIXHoneDRZgXKsV1d1c4+xChpHc78e0cnKKaAvWpx6m2e9hpnisdBZ6mH/0SM8X2EPiqvn4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvfzITKz7JtmukBgR86pb3iisPyGBBDFz23aXJCQnik=;
 b=Vgzk2eglEybhqiIPDZtWLtRJmPDego4Jrao2tysiDZUiFAPfkFt6QKfmwvs27pjizNJwWrjWImhDHPSc5pL9aY5qc0hR++xe0KNJFh3NFTGS84ZbMfGD5cV01i6Naz0CWxh5mZGnxzxjURea7HvEIeB3oiGeCtKZxya30NSBSEgMNe0z6pUtBIvI2MJADh6fXNkk/L+9FpK/R5Iy0rwSDJPQS2dOmRyE5M5mQyNUUuW8+PC7YnyPirI7yiIA2ER3wr/y7Ein5zzKBy1J32x0kdYvWWn0mFVg0cBuP9qo4vqElXHuAgKnjzTtGWJRLtIJgstkgSz36KLac61omLQW3A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9617.namprd12.prod.outlook.com (2603:10b6:408:2a0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.13; Fri, 12 Jun 2026 14:12:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 14:12:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com,
 xiuhong.wang@unisoc.com
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to
 LRU
Date: Fri, 12 Jun 2026 10:12:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5718685A-8469-48F2-8FFC-10C4BE054F10@nvidia.com>
In-Reply-To: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0288.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9617:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dab1187-d735-4722-7d02-08dec88c9964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|5023799004|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	0PBsd7TqDNyxy5gR2WCOa4Kug2LLBqwaYekPWk/k12QYvOl7zwEt0RtSXnjzVgv34lnQ1BmnROeA9L1XyZzW9GuI6as54sv6t5uVvb7o1sGIVpl8wuWMsEobR0d5aVoTBvmjWnATVa3CbefDjqIXUKrpfNI2QBBFbPob5CJFQXtn8eP9NuRnIGe3NhIG4KpaE5ZTKs29VKtuTul9t7+GqwGY3UIx1oKyXDdb6xngSL5Y4FlgNBkjEryeCGQfmohxz9nIMObffBMx9YedGxes7Aunce6opoqXGArDDETvkt1bILSXl1LhkRQKZR12nZNTnPZ6FreGQx9gbssQVuU0wDjLTEN/Xi5mCUEBVHOlk1UvaHubDXpLyuSRcJCdyYb/FZHhlGlLidV89pwMeGN45/GssGZdnEIvXoXKJnSpe4CXC1o8zTjDOo6KxC+DQlEHnjiGl8YoeqWQdw2Vs52L8fP/O17k12EJ3u3ZeEaisgSTczX4pNp7MUkiITjiPslyvzUO6Cv+EoQmKyBJEvKWxHWGY7p/cY5il28TaOHQ4J3Z7R42PkqOBK9jywPueruobLa/lIuZpcdBklNu4YsjAfexBlM/Ed/U5Gzd96PepJtdzTTt2ti4jKZqphAxS/gC80wIas5GiJVwZeZCaZwryvwp8wTrxRl622kqv/KlRHe5ZIi83SLgwI7FUG2GkwWb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(5023799004)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xySYNy0YOx8Y+EuFEgZiqGeuvNynvw8ADiKfB16TZV7HQqJbi7zjk/dmPlPA?=
 =?us-ascii?Q?8foug1a4HrZKoQ80ADhPqEDeVZQx9FAgubzPPp+inMW/CAu3blPAG6Jyg97e?=
 =?us-ascii?Q?gQlGzxfGVXNflFMrpNkw4ND6ZfHMtRtSyYm3bPcm+BZqhEGekrBuSm03pi6Z?=
 =?us-ascii?Q?nRavzxUp5eXuTBwzAX8CIOYgi7b1EfEBhijh3JCboS3Xfc4w4R6Exln/dsDo?=
 =?us-ascii?Q?M6Yh7aNi7UMUZYjG0jMpD3SBE8rcmG7sKhuiRkNFipDgReE6Oao054oHBsuP?=
 =?us-ascii?Q?7fMg4drk8ZfYeGJv1KxOquSddg/VV/IVojJ/87RwYg/0tgrGO9jEJLM9hGj9?=
 =?us-ascii?Q?JmyV2PF6VSlrM9Bkn3W5kMM94pLmVkfvIHQ6ZTfw+GxfgwWiIgqdjxiYFIv2?=
 =?us-ascii?Q?j/Abeaep8A+HqnU/oefzPFMZxiPtA6bMkq8Y03FYEGIg+PzibvhzaXwaylbW?=
 =?us-ascii?Q?opHD6vb3rslKcFAV4r+gG/pvHoSh4kbUP+iPjpr/Oq8Xa2H5qp2QeIU6wa8y?=
 =?us-ascii?Q?dE0MUnZXHvZQimM0GN6VZ1w5/SNJhLah8syX25W4NlNWKSb+Ot0aKpkenaQq?=
 =?us-ascii?Q?plATLeNEUfUIdfMmxE9dNHeQq86k5MSdiNIsKdPYzi73dspoiEEXGyHtYvsi?=
 =?us-ascii?Q?RAOwLQUR2eZPM1GFrRP+qU0wbyam83soxzkvXlKZ/c62mCoCLQsMvc3ETEDn?=
 =?us-ascii?Q?PE9LYLdPer+Sesu1knjgFZSvtXM2cd8sDlQsFR7j8h9pW7+BJNOqlE59IZ20?=
 =?us-ascii?Q?qxOVjbN8yKtL/+pcA7lNidpHA6dB5d0zdAHYJNrDmJ+Naf7eCS1DTEO7ps9B?=
 =?us-ascii?Q?cti2EyoxQGMEOU5Lz4Wzq92zVt8ayFI9vKXeLhOBEkel4CZqYnRx8sPeVb7h?=
 =?us-ascii?Q?pi2CmIF4MhFEXdsY5afPI6ivMe3w8BxgnTiF8Kir5tzMXM7AXb6VjSa1ZN5a?=
 =?us-ascii?Q?BKNX5ZZjA+Y/0LgCwn5OZ8RATpiptm/wx/WbN5af3Dq4hIyCRlZXiOPZ6crI?=
 =?us-ascii?Q?gZGfmRsiVTvg+bBCNmPGo58tBnrPy9ZL31rn9Xve+hsWAmXcVLQj8/aPlPWN?=
 =?us-ascii?Q?xiP6LriCl3dzWuPsdxYMwO5jOqYfDgFNXHzt0jL/LXxukz9akxfoDeGOtXD0?=
 =?us-ascii?Q?MGCaJ4BhVbjJtiW19VWRc8wR2CHB13aL/zNKamedJbDuSk3bc0CK6AZQUmAy?=
 =?us-ascii?Q?gfJYLTAsQh6EnlFd/dbnk37FL7OIHXhpbHK9bx2Le302LOi19dfw5pHlv4bj?=
 =?us-ascii?Q?DC26BNPl3UJb+Q1iImLGab7suCMNwYUh1YTYOriMl2GsItNAiRgLxd30iOM6?=
 =?us-ascii?Q?2cncYP9anYmK8M+wfOb4I8T7r3U21+TCHWAfzK5IFc6BimJUexIZfDEgj9EB?=
 =?us-ascii?Q?U4jk78iYJ5HQ98rvUh4pdAy9K91sagBn3+wR0uozt8hgGO1+Z6wMOt+D4Cdh?=
 =?us-ascii?Q?46K/BzhfJG0TxJ9xwn7tPTSH7luYWImMsX9uHXnvhl2vwvEPo2bcQv/Wqnsk?=
 =?us-ascii?Q?KXWMEM1EMElV/C/p/ETmvkDlz1Sq3MWPDxNozQNvhpvBTycRTKXYVPOSLDAA?=
 =?us-ascii?Q?fBPABxyixWV5HG/9bWWrsRrRSDk9iBS9Bb4IvIuEtu0jXkttZYzUEl+Ke8ov?=
 =?us-ascii?Q?nz5fJATzmdfcehxIIfwOmQgFE8MzPHQ8t+UVNBU1kJxbWiaSbYzKo92y5/i1?=
 =?us-ascii?Q?9R59doJeC7i88RLn3c1LSjMrPdGbky+c/iF5nvl1TN2Ioij5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dab1187-d735-4722-7d02-08dec88c9964
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 14:12:12.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmwvuQzHbGBdllBFNpZ0lnvZbRd1Q0JpSmiqVF3jItj6TPPUKhfU7Ks2Fs+lDIBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9617
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFA881C000B
X-Stat-Signature: ip6jwqyzqaj6xj4rgd6jpk4kq77bn9e9
X-Rspam-User: 
X-HE-Tag: 1781273541-547313
X-HE-Meta: U2FsdGVkX19CyMdr5Un0BUbpDWQ/7s1hncMa/sdp/JuQ9prI+7UUVsf9R0nL59AkbGSwh2nyYjKUtMQvV8E74QCkQyliBUEQ2id9xrM6NJU6s/0DFue36LNUidUzVMAKmsFy5OtNSLmXdzAjqo+PAIlSz5FAm+sJ8R70quIYyebeRc7Rbc4WPWJsphZuTD7quCZFE6Si3Ey63/FO1LZ3viUIOn+agmRtcC5cExs2aJmaWvcC/rC2GaPz6pOqADp0HHOpUtxrRLwGK12NwNNVLJuGJ9EG9gnoHzFvA5ZT93yWkJUv3Ak0DcSMXgBPLOHE+UstudZq2dcmsBxiCDDx+oVZ5EmNhbNRtr6Ar/w5765VVBE7zWr10alYWrc+RtsgwrhkKQQUYIDUhpzboHOq4dgszwvzCS9FBU2PfrH/lROxTU4Pgn2pbm1+yM12RtGl26BvBpedDU8yMNSuJr/2NyLWmKNFnZsf4tpD9LK0iiw0QdFnENECCnHjKWVbUGg/IlTkQl1Ym35MC8zBsHpjiFsh0Vf0KLBg7g9sJeqmcrv6XaORHxUb8jDuuCpsHA8+3YcPo1MEaMVtYaFaJSyNX8N+qAuvgMlYnuwS5phleanPgGnEoI+G415RigrlVyK6kY7mTS2tdf/FlIiwmHfhAYK/lnhjSMI7tL1LR/e3uxLGqieW1nS2GH6BUCvLq03XTPWXLCD9PaZ5sMC8sQTl9qUSGv89f4CFnlU/jGpXSOeltP4AAR7kIygOVHuebUJpVPmAl0quWhqEQRbhOLHuNVqCJJbHRsJLR13N9lW0SFM36d3S6h1WYVPi6G4j5vVTIYVCWnHXL6gxax8cr6Cl+6s5qO2V5fPiyp5G/7F5WgBAA3X7RE6zKnQsLJ5F+AKWEiTzKK5/F0GvRsItfkxNmzid3l0Rqatfcx12hCxPbGMd6dQ/T4VY5bSTTOBb/pf9Wpk2CeJUq0dlHskmgdO
 sgUgNk24
 G4sg0W35LA3+riJfVVNYMm12yDWZVyOaHO3MgeY5uextGweBhWqjlV80DigqAlC2hqc3z2+GKwSyq+8POoAtww8vwDM97RfJ4Kh3wkYJPbd8xSVYi9Vv1yKjvUuMT6BpHVtl5dtNYH13qVxwf3o3yadSGSYukDKIaD97M+hlRaanMGT8mXnutisRPUGG5g6gfiWQpOZdyhvDZwniGAXUj6msrGxrVAvVB2j8Q9BFIyuJWLoV+mL19JWk+WZtEMs+sh1y1aLi4totPGAiPgT+FkZEzD1bQmnb/21b/KoogT095BklI4AipQHzOgsSBTHAy6lBXotnL/+/HhxVXXrX/YLtPe4vbB+NilM50uF+UYubd9wNtwuVW4Ik4//dsFOwIYGOpKhUdlWUg9vwQ7zBKje+wdRM8o6OklRG++ZSlXAt2jcKodVigBqfprTtNWo757zKHKBM1Z530i0z75SFddzxYhrhprWKQHCxwmssELnGWKj4V+IhVx1z3Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:

> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> The kernel panics are keeping to be reported especially when the f2fs
> partition get almost full. By investigation, we find that the reason is=

> one f2fs page got freed to buddy without being deleted from LRU and the=

> root cause is the race happened in [2] which is enrolled by this commit=
=2E
> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: rem=
ove
> non-uptodate folio from the page cache in move_data_block").
>
> There are 3 race processes in this scenario, please find below for thei=
r
> main activities. However, by further investigation over the code, I
> think there is a common race window for the truncated folios between
> split_folio_to_order and folio_isolate_lru, where the folios lost the
> refcount on page cache and remains the transient one of the split
> caller, under which the folio could enter free path and compete with th=
e
> isolation process. This commit would like to suggest to have the folios=

> beyond EOF stay out of LRU.
>
> Split:
> split_folio_to_order() can split the big folio into individual pages an=
d
> put the resulting subpages back on the LRU.  For tail pages beyond EOF,=

> split removes them from the page cache and drops their page-cache
> references.  A tail page can then remain on the LRU with PG_lru set whi=
le
> holding only the split caller's temporary reference.  When
> free_folio_and_swap_cache() drops that final reference, the page enters=

> the final folio_put() release path.
>
> Truncate:
> The changed code in move_data_block() lets the GC path evict the tail-e=
nd
> folio from the page cache through folio_end_dropbehind().  Once
> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> page-cache references for all pages in the folio are dropped.  The foli=
o
> is then kept alive only by temporary external references, which allows =
a
> later split to operate on a folio whose subpages are no longer protecte=
d
> by page-cache references.
>
> Isolate:
> In parallel, folio_isolate_lru() can observe the same tail page with a
> non-zero refcount and PG_lru set.  It clears PG_lru before taking its o=
wn
> reference.  If this races with the final folio_put() from the split pat=
h,
> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().=

> The page is then freed back to the allocator while its lru links are
> still present in the LRU list.  A later LRU operation on a neighboring
> page detects the stale link and reports list corruption.
>
> [1]
> [   22.486082] list_del corruption. next->prev should be fffffffec10e0a=
c8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> [   22.486130] ------------[ cut here ]------------
> [   22.486134] kernel BUG at lib/list_debug.c:67!
> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488539] sp : ffffffc08006b830
> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000=
000000000
> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffff=
ec10e0ac0
> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000=
000000122
> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc=
080061060
> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000=
000000058
> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000=
000000003
> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8572=
1f0e25f00
> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645=
f7473696c
> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000=
000000010
> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000=
00000006d
> [   22.488647] Call trace:
> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> [   22.488661]  __folio_put+0x2bc/0x434
> [   22.488670]  folio_put+0x28/0x58
> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> [   22.488689]  f2fs_gc+0x230/0x9b4
> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> [   22.488725]  invoke_syscall+0x58/0xe4
> [   22.488732]  do_el0_svc+0x48/0xdc
> [   22.488739]  el0_svc+0x3c/0x98
> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>
> [2]
> *F: big folio before split
> *T: tail folio after split
> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (=
folio_isolate_lru)
> *F: pagecache refs =3D n
> *F: extra refs =3D split
> *F: PG_lru set, mapping !=3D NULL
>                             split_folio_to_order(F)
>                               folio_ref_freeze(F, 1)
>                               ...
>                               lru_add_split_folio(T)
>                                 list_add_tail(&T->lru, &F->lru)
>                                 folio_set_lru(T)
>                                 folio_unlock(T)
>                               /* T PageLRU set */
>
> *T: pagecache refs =3D 1
> *T: extra refs =3D GC + split
> *T: PG_lru set, mapping !=3D NULL
>
> move_data_block()
> folio =3D f2fs_grab_cache_folio(T)

Getting T from f2fs_grab_cache_folio() via __filemap_get_folio() should
be impossible, since the xarray should either have the original folio F
or folios are not EOF. But it reminds me a bug I fixed recently.

Does your v6.18 kernel have this commit[1], which fixes an xarray issue
in folio_split()? If not, can you give it a try and see if the issue
goes away?


[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/comm=
it/?h=3Dv6.18.35&id=3D08b2b65c63bb26dbb2a4e2adc2ce96e2929b8b60

> ...
> __folio_set_dropbehind(T)
> folio_unlock(T)
> folio_end_dropbehind(T)
>   folio_unmap_invalidate(T)
>     __filemap_remove_folio(T)
>     folio_put_refs(T, 1)
> folio_put(T)
>
> *T: pagecache refs =3D 0
> *T: extra refs =3D split
> *T: PG_lru set, mapping =3D=3D NULL
>                             free_folio_and_swap_cache(T)
>                               folio_put_testzero(T)
>                                 /* refcount: 1 -> 0 */
>
> *T: pagecache refs =3D 0
> *T: extra refs =3D isolate
> *T: PG_lru set, mapping =3D=3D NULL
>                                                                   folio=
_isolate_lru(T)
>                                                                     fol=
io_test_clear_lru(T)
>                                 __folio_put(T)
>                                   __page_cache_release(T)
>                                     folio_test_lru(T) =3D=3D false
>                                     /* skip lruvec_del_folio(T) */
>                                   free_frozen_pages(T)
>                                                                   folio=
_get(T)
>                                                                   lruve=
c_del_folio(T)
> later:
>   list_del(adjacent->lru)
>     next =3D=3D &T->lru
>     next->prev =3D=3D LIST_POISON / PCP freelist
>     BUG
>
> Assisted-by: Cursor:claude-opus-4-8
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> patchv2: update codes to eliminate bad page status
> ---
> ---
>  mm/huge_memory.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..c24c12f71157 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(const =
struct folio *folio)
>  	return folio_nr_pages(folio);
>  }
>
> +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
> +{
> +	/*
> +	 * __split_folio_to_order() clones these LRU state bits from the
> +	 * original folio.  A folio that is dropped instead of being added to=

> +	 * the LRU will not pass through lruvec_del_folio() and
> +	 * __folio_clear_lru_flags(), so clear the cloned state before it is
> +	 * freed back to the page allocator.
> +	 */
> +	set_mask_bits(&folio->flags.f,
> +		      (1UL << PG_referenced) | (1UL << PG_active) |
> +			      (1UL << PG_workingset) |
> +			      (1UL << PG_unevictable) | __PG_MLOCKED |
> +			      LRU_GEN_MASK | LRU_REFS_MASK,
> +		      0);
> +}
> +
>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsi=
gned int new_order,
>  					     struct page *split_at, struct xa_state *xas,
>  					     struct address_space *mapping, bool do_lru,
> @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>  		for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
>  		     new_folio =3D next) {
>  			unsigned long nr_pages =3D folio_nr_pages(new_folio);
> +			bool drop =3D mapping && new_folio->index >=3D end;
>
>  			next =3D folio_next(new_folio);
>
> @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>  			folio_ref_unfreeze(new_folio,
>  					   folio_cache_ref_count(new_folio) + 1);
>
> -			if (do_lru)
> +			if (drop)
> +				clear_dropped_split_folio_lru_flags(new_folio);
> +			else if (do_lru)
>  				lru_add_split_folio(folio, new_folio, lruvec, list);
>
>  			/*
> -- =

> 2.25.1


Best Regards,
Yan, Zi

