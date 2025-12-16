Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A860D609AF
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F7F6B0005; Tue, 16 Dec 2025 10:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D126B0089; Tue, 16 Dec 2025 10:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1F26B008A; Tue, 16 Dec 2025 10:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6C36B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:27:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B216C8B33B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:27:30 +0000 (UTC)
X-FDA: 84225713460.08.FB7E575
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	by imf24.hostedemail.com (Postfix) with ESMTP id F37F6180019
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:27:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CA8gGYyJ;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765898848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjGErN/TLwM0jQ+eDoBPL+0eX1xVCGP7N5Ry+xA25lw=;
	b=PuxSF6NwyJQTWh6Uc6pT9J4rQgBC+T8hWowJ622U6f4onqLS8tU9wxbvnp1KNbhcNCkPUL
	jKchBgp36PPQapyTlmJhP+xNrYNg0+OtXbCdHyKL6sd9hQkRfDZ6wxsH+W4VZCEMl3qgbx
	XKjCGnG7Ey0ATaxSb6vdW4h8IBBn65E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CA8gGYyJ;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765898848; a=rsa-sha256;
	cv=pass;
	b=pJA6E1NRDRMeShLkQB0bnvxsE6DiGq96pC73grWCV6cCgP7YUn5fef4fLPFYWCFXWFkBU0
	o/aIPyocdus17FJ3yv+Ahzs3U3EJN/IzYbo0NhQTEudulfGllkuZBBlI8vJO5oa3tUSkCe
	YSUoZF21BXj9lZNRQ2dyeJVSzWtL7To=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7bzyMGFcTIK3DHRqFxpk6Guax8Vrfl/BYP9AaGfvwFbMVs3rZ5l2K46aqK9uJO4dDOAPh/kRHKbKS0zVa4nWK00tCpOG/rY/uMwXJri7j3c1AmCwsK1UVCbx2zRoyveWgffzUXIsh626OeN2ejW4yf/oyaGMjHXBdQkH6gfMcpvs0wQ+Aacn/6rkjXp7nx0pJ4LyOfO57VMkaRh1FCGOcMt9dDTSSxZ//En9VLq15M3EYA99BbmKHbSPsudHBppxlarnz4nzDrnznopDm66IdP6i35WkXM0gtxAp9M0z+lKNpE0C1JvfLu+9uMnXhGkyKfznFMnggKqlipkjKixmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjGErN/TLwM0jQ+eDoBPL+0eX1xVCGP7N5Ry+xA25lw=;
 b=vL8Uv8eGENVr0fcYDL1YyGqMYQ8vd3NcFFQ9Ta9K9A2i3vi+u/4b3LvLuYNz8678+FFAenKYExHoJKYnnVeqqQWzwVFHQjiPvGxOdRs7rPfyaxyPCd558tNpsmY9Q95nE04P42kEsHiInKIivkj4BKXHhRJ9gOp9jxNkfQaDcdKXgdTN6jVV9qWbpo8cpET1Xfy7ZreyY8/qHyWJt7RnWoX8isS/csUKvbR8T+pSWbYJhQ5Jg05GGRjO6o2xXh8BhkHkApY5amxzCzheTvqn/um+gv4ecxcNMBjr4UXPOgQSblCCW1MqGxHuYj1DbSc+yQJwJQ2p2FABwJ765/sL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjGErN/TLwM0jQ+eDoBPL+0eX1xVCGP7N5Ry+xA25lw=;
 b=CA8gGYyJWSj6RWXs6fFLkEWZvUalTPIwSaGvzTVuyl53CE8K+qD91CraYgZFXySXvcQYGlDc9dba9+m8yX/ZjHfnY6we5g/EinInYm6FFpFhNBYfUDpxG5IYTyyFgn7tk5CHOMnphd9xAHRd1/m4QGFfebOkfQJL79gYWaHKMfekoQMc317eRLxZa7m4sFaMbCCtXBeGoq4MiYGp3QAqpDnwJb0Uze16guaFB41cbgZjgpPfHHKYcGy1Eg/DtGn059WXzWaUtNUjzi7/iTp0V6hL2HW50ZR+YAnStA45HPa/jePPBQpMZdsOmMTZgR1ViZr1SgfwqsH2dLUCqhGIJA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8895.namprd12.prod.outlook.com (2603:10b6:208:491::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Tue, 16 Dec 2025 15:27:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 15:27:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Date: Tue, 16 Dec 2025 10:27:19 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <848E8F85-CD24-491C-8A3B-474E4FCBF995@nvidia.com>
In-Reply-To: <20251216111139.95438-4-shivankg@amd.com>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0043.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8895:EE_
X-MS-Office365-Filtering-Correlation-Id: 6605049d-a331-47b7-8ce8-08de3cb79b89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eMohGjz7jxFU+9wIMhUtgGKk7zqw57vVtO0IBwngj1BskOOEZtvXiCDEJ7lr?=
 =?us-ascii?Q?1x1s4pW9/Ti7xFg4dDse2JYVmfDaDUnhmUXfEG4QSYI3ngQBBE6xn+NjI0oB?=
 =?us-ascii?Q?P5zVffvBfQdv+ZeK6WOnlLokGOsezY4mepvh6mXSzc1uR4orrYOytW1PuEc7?=
 =?us-ascii?Q?ALwiak3rSaVAf5exeU5yUVv+m2gahdlSgbSGNvbakzeuShvzjdKumtlUAjS4?=
 =?us-ascii?Q?QLPAIgZFd2FWDZJZtQimIBw9BtBmDsYtBXBHqIzjBTDYZyFt8l9A0iQf18SG?=
 =?us-ascii?Q?Wdzibr7MOuMOb7XfY/mzRDbUJhdoVDe/IcUJMgsEpfZ4ja4aU6lYMThz9A0P?=
 =?us-ascii?Q?UFc8ATwlmdtARjyFWR5o9POe3Yup1AeZS3vqbjFY5J3EmtNYUw/9O1rsMHxZ?=
 =?us-ascii?Q?X2tGvCHr0z8sFkzTqvemOwbgvHiEEt5r2+OcdbOxXHbMksW1/ABYPHFrqfyp?=
 =?us-ascii?Q?H8LwHOafslGVNqR1dFKjccRbz9jIDVk+Ww0uVllP5Njk+F1XkLlYXm/V8jAW?=
 =?us-ascii?Q?UZoz6PHHNZPTzkXUdfjdWDd3/V3WRPIS5ON/1Y1nmlMdWJGEFfnU4k/mFo/K?=
 =?us-ascii?Q?/wz6yFtL/aPNfXfdqaP5UkqiutbNTLsCN8Dc5lcZhtOuuCB2NNSTwFfR/633?=
 =?us-ascii?Q?zzQTCmVTF0+fZj0rI5+BjPwmnpj/8H5uykm5NGhbHzNfIUVU5+ZG0cec7M00?=
 =?us-ascii?Q?Du77jYQNLoVGnTxS7+/Bnvx6WIEx0RYf+FB7U4hOUwK3/btQb3mUPIljTvKY?=
 =?us-ascii?Q?N8d0f/C+2Xspyhit/XSjdducM3jQsL1PnFKfx+lNDwphoPZ14aKQF+5HvONb?=
 =?us-ascii?Q?TfFvBoPoM7/2EDmPp1mLFAT17s2YxuIRcqtU2b6SdqgsU6tDJn3PwIPL6kfv?=
 =?us-ascii?Q?pRVoAlMQif0zR4zFdbUJtyKRRkaqcjhzh/RI3etvXl6xUVHADwMUBEyh826R?=
 =?us-ascii?Q?hpxcyiVPChELCjanIR9354w0PTpPtbVaK0zIDQt4Sr1RRGcpfK90Uf912/dx?=
 =?us-ascii?Q?xYQs+lRUx4eoLrDuvchlkTV5vTjXr8cQGXT71X5NiJHhMjO3nCYdSEi1mUZb?=
 =?us-ascii?Q?toz2qpG1Otn1C0cV/TRF1uQdUD0dp/lqDwUn+s2vv9vAaj9SJDO/KIJhnhkf?=
 =?us-ascii?Q?BpDgi9S73t+AKgZsni41SrkyiZPnAAsG3Ro3XKP/LQEYy1Gll33xSsguvBmC?=
 =?us-ascii?Q?TgMLRQ09ZZfA6qWwCWO8+Lw03htTCud2gFXOQo5g5uXTMWvsgsSJIF2Xf6QU?=
 =?us-ascii?Q?VHThY6nYwIAnSMHdYghmBIMdkgIa9w1qFEoGQaOx+d1IF/vv2bFMQLvdY1Sx?=
 =?us-ascii?Q?C2QMVf7PZQvBtS9nlB7zMs3OPn2sXZV08cc3ffTut8fSlVpb9x46C6iPkmVi?=
 =?us-ascii?Q?QzpM+TWFNfpxGFdPtFR0OCJMcHTkVX0jZIVDyMfwB00wF99qONCw3xcR95vc?=
 =?us-ascii?Q?6zwSh09LhKuGgaXPRZUfJIlQe1O+nmyN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VRl55yFuqDqI12gk67GWmLtdwD46JfT4PrzHCaIzscpCigj4ZcIIqicXKwKu?=
 =?us-ascii?Q?4DOV6389uSEdS4g5N7pJREWkuYraVdMkTi0TTLHqtfvtCQNqo4CDVN0dzb1k?=
 =?us-ascii?Q?un5lG48tz8rjJTT69bSsy78fkX5GQuFNdwMlkXJ3ZuGjeQRfDjq74y6UCejK?=
 =?us-ascii?Q?BP52+1KZUrTDXcAPFEYRPJfuDrnAB11pIJQSkCRYGB9aWydZXq/f7MAEuTNB?=
 =?us-ascii?Q?TcW1vN3+rvBDNrcrX24YjwB2o1suInYJmzzStZ2ECPsKljLvEpN2Fx3IhWw8?=
 =?us-ascii?Q?q//POs1VuI1aP9eJjXQZBjcse4voDo90o9N6GhTbCmReWRd+03RCfpyKPMwm?=
 =?us-ascii?Q?UmAE8Y+dYPA8rC4ox4/zFYPGPwQs0K99lyUhowH6swAsTug2ydjXNNwsrk/v?=
 =?us-ascii?Q?NR9BDbbM/f5WgvpehffYyzwcNaiUoOaPPiji6zgFy1eB51Xi8c2A2mmFweWE?=
 =?us-ascii?Q?FvBp70pLaid+MGU6isXUhpM0UFEiOtYXdBlF+mgXTNRezbTq3sEcD704x7YC?=
 =?us-ascii?Q?xDFEkctBiGH8T/KhOSEK8DG6NW2mSyN7XPGgr8kC+Y+6jMY05+Gh/jhKE+hR?=
 =?us-ascii?Q?CDf/IQABXB94drhPVMfGT3pvg5J7/UuDnmiiwRnj5gyS/wOLrOSlgQog/rLU?=
 =?us-ascii?Q?rMMeKRtSNWvm+HWpNXYeSTJt8CxMeDpaECQvIcz8yGj2f+MDQbpugf1sWxej?=
 =?us-ascii?Q?lKXxW7k8qPSe6o88ij2lanH9YQtQc5AGDVi/mY0Kh+jT4Yk49BUpyfwH6s/c?=
 =?us-ascii?Q?lF0Kfjllx5EnCJM3DWFdTsW43XqjiapbajbBXArEEuoEcekmdqZKqs9e83+X?=
 =?us-ascii?Q?a1izbjnvrR/yqgcZD4aQUwi1ftPGFCcgSBtL8cMcJRDhD0whEVsIQmtG0MDN?=
 =?us-ascii?Q?qSq2PNN6cfrDqS4An3k1pYBKRugz8AuM9Vy+khUG9XD130vQuD97kuNX5qhp?=
 =?us-ascii?Q?Alx2cU1VGw0cGuiplBDboHgppiUGjbQoAU+lzF3KMoaMlZrWTkKdOKFtwvfu?=
 =?us-ascii?Q?zTUojRHiLd/3GSO5EWgsjbmoR+7kUQINNFKTeaKLnKELDS6xGp4w6AwUnp7Y?=
 =?us-ascii?Q?1g6+LiN8pbOdpxykfuGwPPvaW8dV05aF7H+eljzQVDmVUrik/JHflnTOtl76?=
 =?us-ascii?Q?deCWTZSygRbN6LlZdS2BqZNj2BNfyfLVmQ7FxJmncuB76fzmYA827Osppb5W?=
 =?us-ascii?Q?hVjxUsgrUy/MU5v7b9Ug2AgtXxzFIwuG2aI8J0bGCy8O4oa30Pq+299IObIu?=
 =?us-ascii?Q?mjh5EkMvghCJiC1VryZ5Ix8kLPZeJbHQ4RVL2iBAVNugYWdh28kuWIgcEXk6?=
 =?us-ascii?Q?NnuQhHJ1cy4Mp8HoyY0SBQyF4e7/NLODYDeIu0eM8dYnOq0lwox0Lrhavg4L?=
 =?us-ascii?Q?/yT+j4H0oBDk5Z4pGK79QNKlH49sx9VMQr8rwMEGUtds/WZ//3nVHwFS2Nq/?=
 =?us-ascii?Q?D9Dpp6Dhm5q+7PfXo9RgEOa2MMm6h55qmGY7qJVNganHzdzt0UCGyJJUNmRp?=
 =?us-ascii?Q?BDtKNjBXrLekPB+BSgvsfw5L3YAH6wTCgOMsO9xZ1eMamRaKwk0dwh79BmyP?=
 =?us-ascii?Q?0NVH9OyU/ukIixgkx//1jiPguHBvurtiqhD7IEVj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6605049d-a331-47b7-8ce8-08de3cb79b89
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 15:27:22.0512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5wjLwjH1WuRsXb49fOnfHuBAGVe5ijg5Ol62R/97qYB7Sr6pu1Qg2xRCfMe2wdt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8895
X-Stat-Signature: y7iz5bpof6kpj5jfm64bmko35d6eswps
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F37F6180019
X-HE-Tag: 1765898847-478131
X-HE-Meta: U2FsdGVkX1/oPpPdOCIhjx2OM9uMRhTjvq7GVLsxuPQ7iz43dgy0CYGhe7xb/yKn6T+tPhsVYOj+KIWvP/fJPRN6TuriIoj1W5Q+J+8TJwtu86xquSZc8AID6JaLZQvenRHmW/5iY4g9aGp9tQQTz5J201B0sX8ZUdSda9vrt96TgtQ3o+Zm4Csnupigu6ckqL0G3kp/FvpEXkwDTo7Tzfr4TUCk7LoU2F8f/mrl7oMjlrF0DnYmU8rmGMZ8zk8tB2Pot6grT8/SJ/Skx2bXY8gqUgSvs8koEEIuBLOYvyziq+wPnv7YFoK4G/jveqS0Deqof9LsunqHHsucbPJrck5JDL2A2eU1aPPK1OEB83toZRKhBu0NjjcUZpznXSzjLZF+qk5fDvdDmspwjPm9YJU1dy0Hm2/XfEd1bwoqAqJlxiCKJGvjCQPR/WRVlcmMv5ue8Fr/wZ55h5+1I7RaLXvX4fUux1+BYfDvjmQwaCaJXOE1ghGgdIjOGsMAyQH1UNOlGINJO2ifm32CuhDwrQ95qi+6g/7oLkajRiOsZ+sROS7ayx3gtmbuc99zEtq7ibGirhz+FnMH8x1QTAPy5zi0QYOs9ZaC9jcjrDqKYyIvxUICjoZh0G9gPEySccUaQQy2rrmODfKqUba9Qi4FQzx3AdcU14vpHE+3LYTgT4IDrERm4L0mYnN5tMqa2MA4NlogzjvaivFMRFipOkaFqiN2BCxALOro8GuRQ8+bk5bCyzBzy6tNKzsmsm5N9SMhHe/2srL723rau4yh3HWj8KtN/ZucJQsCfbMvvc/d1wITcyo3i02/YsFKNUk/O0znbWwqciL+xdQahd2xikiWeZst3m6ASNud4x6iGRv14HSZe6/32D64wg7qlZpXF7aq/Xs5Z+8lKKFfmHdkQi76xVMoqoPtFq7gH39+mBhjHtcvqJNsmrXdNU4CyfaDf+xQZhm19zMCkU1NTZdKL+q
 SdHpQAxg
 3q8toqtwB/GMg2ZdOj9DWDSEU46GfnDR3FRUUevzteXTt/yZfAElfV1yEydwHSVlXljBRSUA1oJ1dmR+s/hlz2M7+16O0ONkTSPJZs+QX0LC+YUPojn5dQKojQQvqJG8DXAPefn0vgVKIgDW9iK+U91u85xutkSb//Vw2ZT86vkKr+t2tWWcYxzDaMjB0Av688T6Z0igT2tZHUzk3hq+0LP/ih+C1N0JXU9k4Wyg3pUb877q5HhMEeJZkNRMOYp+cuKluwA09EHRMpP8MFlIq8q1KBb1solkHWGL4O3hhVgQFFcn1+hrgetpKrO6Q+fKk6U42o2J1nnD8BXn96j6ZN8H9Gh4qFX12ByWx8S5d3oVs5eLrNQhBVhdy6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:11, Shivank Garg wrote:

> Replace 'goto skip' with actual logic for better code readability.
>
> No functional change.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/khugepaged.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

