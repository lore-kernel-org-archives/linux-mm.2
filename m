Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103D6C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A3B6B00A2; Thu,  6 Aug 2026 12:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF18C6B00A3; Thu,  6 Aug 2026 12:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12886B00A4; Thu,  6 Aug 2026 12:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98F0B6B00A2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:23:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01F1CC0136
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:23:28 +0000 (UTC)
X-FDA: 85071364938.24.3BE6B6D
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D61414001B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:23:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k6QgkqFV;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpYaZ4LTz3I98Hk3iwqHGDImNHkyCGdV5kamcfXXa8U=;
	b=GptRfXzCKOX7k5yLkJqWfoGA9yJzrFjiVfTxSYWV/LkPF/CuphjnUM0xDFsPccoKAFbSwz
	jjCsOY7eJ0Zad45UgeDMKFiC9DS+mWighAKCqQePcU7ueknZsCC05Ndk386WysyQs+uiqW
	tTFWleJvJxKTWdkV+f6T981YXy3Mb3k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786033406;
	b=1lXlWqdEPSgU1hRIxpmMY/KpTo2T9sfp35v/lrH7D4K+Qpj8Y/o48ItkCSoAOUaY9wWToj
	NlihlhoqmyqS1SfQ9WlWFaai45N+Dl4zx5S3+pZPUG+J7tgYm7YQaGc2XbF5djWRSwg5DZ
	BV6q9RIfVNKiDzWe9Lz3YxCY4c1SXdA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k6QgkqFV;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qFTbu9WuENUFKj3v2EjHIwngSigpljgGF/6rj8aosUzwWYEyxIe435u2uErI+M+nUuuRDqZX5F2oMI5kPUlqrGOTj4r5pjSrg9oW0wiSJApo0whzvwakIJz6oF/BohQo9Ei/WG1UMvwSBa2/8JKzXyqxs7TZGCTVUDk376MrRyrfHUwhRgNunh/LcJuDYcINcLB3UceiTDW94RJI4fF/ld1HGNN5xnwH68WwhjOjt8uxIXAWXzzI1zg7sHX82jvW0PebwqxKGOxVnDu/PSz4q1ZFItVvUmw0pHlz3cBtC+BvWti9henqLOVc7LPWrVMcvldr95en4nmFQVOvZLMkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpYaZ4LTz3I98Hk3iwqHGDImNHkyCGdV5kamcfXXa8U=;
 b=NG/DZfrxTNWL99+ZUDAn3QEYPtnvbqkVfkIbUmgSEhdwB4JJRnqVwHWz/F5ilEjnoQRgyQXQA5UL54rYXFphM07NlorsqORGzT7HWn3oJnCOr546YOaJzjJ6KqNswe27xb4NKMXK1jAsXmKYrrAoLs3U9N+7D8tbbU4MJ4QUUYdtFz9SU+l9COwBZ8h4yrL/Tr4+Z0lA91J4Yby460cL7AzPXjIFk8b3U5b3n9xD3kQQm+qtwbaKg4kpPZvZyIb2lgKi7aTB2/aT4i8p3rJB/UTJOwJSrDFjdhE4y0OCmLL5Y1rw6LeoX/yRfY6fbk9kKtrno2NLhhnzJ7BPztua0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpYaZ4LTz3I98Hk3iwqHGDImNHkyCGdV5kamcfXXa8U=;
 b=k6QgkqFVKlfZ5/BOGKX24h3Q3IiEB1IOT2uxkR/7RrNsRCLfUjYYKoSOSgtqAEuu8Z/yqX6PKMxHoJWp4SbiTvRKNCQtZiLe5E95fjdCVCPNd+miOhPKeic6zaEEEczJ6g9nC9MzzThMsyk8YyeeHBJu6rnjfx40di+r4lAjNZjac0B5IhW6wyRZKvpvKWr9dVFZSQVIsS/s/oLwirM6P68A6qwvqmIiZJEDMlF3spMm6Hh0Qsy9O8U/UvEJ8r9k+3My3noRR9nFuLqHk7/g7Z32RukMvNSZBrkuybhtgdFSDmS8zAS6u2EyZsTKz9Ovqvd3WMmRJ7bodyeLQk0EHw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6799.namprd12.prod.outlook.com (2603:10b6:806:25b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 16:23:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 16:23:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] selftests: mm: add mTHP collapse test cases
Date: Thu, 06 Aug 2026 12:23:18 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <3D9E14AE-8A9A-4882-BA3D-1DA95E651C49@nvidia.com>
In-Reply-To:
 <f260058520214a9611922a96326bc54ba282fb73.1785985999.git.baolin.wang@linux.alibaba.com>
References: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
 <f260058520214a9611922a96326bc54ba282fb73.1785985999.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:208:23c::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6799:EE_
X-MS-Office365-Filtering-Correlation-Id: 118b6011-38fa-4c55-c211-08def3d7072d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|11063799006|4143699003|22082099003|18002099003|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	bD5WL+S0XU2kQ2WxK+jqlbqlt2Ykq1LuKuFeWW0y7Cm7QKgD83Gv2M9EI8iBl6pry/ivp8aOcvKxeljHrDJNstUFpSYcfgbTHwn8CCdfelATgkdC/ogMhPpOxFbIdVGE0lP3R3eaaoo8wcfdoIp1dR50xYTUyHevDpmktwGeFTWGkMDBvYIwflApXIUtURmMmem0mOAUZKrKIOg9PWMug0eDBrZd4ZtQDmt37XIP6uPRJlV//4NloMJh9iNS0sDRl0DAsIIl0CpPz2PZTUEPmxcHd5M2vW/Iur3v9CPKYa6pJMndyZ8ehsEAoIAzROhh1X2OaOOv2cRh/OB90w7+GI4H0B0WaA/wGRwVN9nfqAqfCrtXjlotI5MWpYUoj3cgvKi6nyPK6piVzTgTcdDa2GGGrqg9NXYKk10JBCmdu1a4kP1TlUzPFD8RG173VZhe4UMyx4pCZka9ijCHxmfr7jgC+fT+glW79+YWewThgF+0v2RlMVDEDQziAiII1T2h4PQDamyVD2wh+B5EcrbmZZgpq92/6K1EqYWAbNtn2DHHjC9TLESjI6w3b8beWHvM5/nr6mA7v3Y2A/P2K4g6Jv1y31VTQ/sFFAbdnCg9tPl8VsVIYMDZ7qgOyufiMLhE/KXbbwMubvIuo6SAcOPinwKpQ5SHdKAheLvXLKRqkJ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(11063799006)(4143699003)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oBicW4IOPhp4H1xylEZ/HlovHKshfasaAHcdi99/v/VICPjcNHpJ/O8wXfty?=
 =?us-ascii?Q?GjXLpatJnTFpVHP30NCiuUltz+1wmU/t3r/PyiSPYxF++URu0xXEwqUO9xLZ?=
 =?us-ascii?Q?jvNM0uc1QDX4enWK/3i54KptbXdSlxlwhqREpI02L6Mjmh5O/dOhDmI+FU0o?=
 =?us-ascii?Q?+ErFDzXAA1DZis7ITbA5vcnp5CvfasiakuricoSq3GG39Tqd3zSlH0rUDekF?=
 =?us-ascii?Q?qTnp1gP60vnJzSnJRqn4nJsu0lzenEXPaeWGCdLyYBdC+xLD9Qqb/eM0veUQ?=
 =?us-ascii?Q?bY5+JK/BXMRgYbs51Bw61+MlB5vfmRs09AVljyzqkb0fOE4zN/uwVnt/Rgt8?=
 =?us-ascii?Q?Btbd0JQ8Mo44F95MH/8UaqeuTdm12rik/su5utXfjEGJDYnq/E7iur4wDP8v?=
 =?us-ascii?Q?yWKNIvjig95wCoUiinmzCwlTuS7SPY1vzIkuASKlg8wzgF8P9dS2CVIv2niY?=
 =?us-ascii?Q?JY9aCaYZ6fmH9EoSKqeUTiYPDlCzRiEIuN6k6Lj7r7zojmVbY5ZyfWE6k/JH?=
 =?us-ascii?Q?MOu97b+JhpfwsneArQwMDF2qaJYNocxvdH72/mNcBpIc8etNLibByRNw4Ns4?=
 =?us-ascii?Q?R6SKzUgK97pXr/ui5h4Lm2YvYRUowdx2jP54Any4qE9VFLS05r80cEEHo9Mm?=
 =?us-ascii?Q?t0gKDCTGi8da9u4J2XoFY245HrBf6Bv0wbuujZXwYMlr2x8zLIrGPIcYe2Dp?=
 =?us-ascii?Q?jEW38FHunMiJVn2RZcCC8YJCQI7sXCIpztnkTnnLPsLIP/JRThosaQH4n8An?=
 =?us-ascii?Q?PySZ3wM9xKX+J2rvWsjcswKIm2j59D58inG/GrEeZ2jybMIwc7Oj7nblW5K7?=
 =?us-ascii?Q?72UU68zDW6MckX+CSolS/x6elpZxQiEEU/Br2wky4GC6eLVBmJcN/vVU0ZSA?=
 =?us-ascii?Q?KyByhtdl1hay/u4MLW9gpOWWX+gUfiP3IKlf1Uwd+xaXI6SCNT594CaLsWI+?=
 =?us-ascii?Q?W8ntJT9Z1HUXgNNnN5XZtY4PmRrR6+BhuiszbfSeiuQYYCWbT7B03quaW6l8?=
 =?us-ascii?Q?8T2BBnqr3oqZl733oMPg62MFDHxEpmigDHym4p9HpJKmQoXLGrcYgpRcEdHy?=
 =?us-ascii?Q?EaHhWAUxKwmw6gR5O6uEhFz8JZoToQvtYhD4frvCg8eqFUqviDXSqBKZN2wX?=
 =?us-ascii?Q?FqG1+UvgqO93qpChcQ9axwi7uOsjH7WbQqffRIOM+wxGlAQbeMCf0Nippury?=
 =?us-ascii?Q?gMdGVHztViS9aU+Q/EtiQkehrVUg6mBETT7Og93xcV35MXwD4i1NrhlZVhhQ?=
 =?us-ascii?Q?fLo2TdwYE5cLRpAva5FWWRRkbxx+Q2Qns4mnC33zDRubcucLGUeJTmUKo7Je?=
 =?us-ascii?Q?v/UH6SH4HTB4tbrG41wAB8fgUooq1Q+Fu1qTh7w8I+IyLX2AbbjAvrW+fBB1?=
 =?us-ascii?Q?MdSKNyZxLv+opcPZoccOGAJ1vKpHtYV49MpTIHXncmEmbJ4D2s1YAEauSlW0?=
 =?us-ascii?Q?qutCiyBxljONoMkmybpOnZaK9D/6a6PA9Id7EsmIlUUBhNRH9M7FJPo+FDGH?=
 =?us-ascii?Q?q5LrxqJ7ZthVr/y5b9uUGTbVNHc6QBivES8dfqUhQFw7N/4T34cYmjwW+bxw?=
 =?us-ascii?Q?icl/tvvgvvTFT14rtWobyjQPKnLEov3XgcfRKkReM/iln65N3z5KjQ3iUz3J?=
 =?us-ascii?Q?ImLHqWRbquXoSrK52WTf8bYP/eZmFLgT561XRHZEREnNNNuwJKpTUdXWNSs2?=
 =?us-ascii?Q?7worbUIh2FyBdLRNIdSE18hqJ/RZdjud5XWGT9dXYZJhqWfk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118b6011-38fa-4c55-c211-08def3d7072d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 16:23:19.8604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIX7gZJtLDJnNOrnZPbts+b8lqrx/SARpeqBzQdorNmjX50/CNrRiCqZwaDLIlVJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6799
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D61414001B
X-Rspam-User: 
X-Stat-Signature: h5t3mzqrq7wd4tsr4cmqrpx9ba74wke6
X-HE-Tag: 1786033405-180508
X-HE-Meta: U2FsdGVkX18yLYld9KVFmOTbn28aWUlxmG0O7uHvxkJmjvevhu5S5Ai26SKRbUHC6PBuxhCdGZqMO+TW3BTeJtZ0+ivieaBEJIGZkbGzKhMHeVdtPW/3v6uBnGBTmiWPac5gkWER2DCMHwRtBBow+hvmGlxBgfzXiMViGgUcogv+tTHkuh3d3JnHk64zNoeGNCsb/ROutn7bq3Gn5UCvCx4KQucT/vW/I08dr0FFxwuC9n0MhuA7mUJQRa3hOmccT9jJbwgM32qzCDyxHPV9V68joLXVVZQ6a7holSxuwqpHe5Dh/WbGr6C3mroZxV8d+B0OHsE8oTMhmQyBA/zNETqynYKiODcj7wshV3Lm8XUXRSI/THiKJLf+dW5aEB5T2tblStv7Znq23/Yb7yOi1EXO1LlEUGsssILcB4Al6aXE+lXtlxSo/Tldk99Bf/0mgJBV6eYSu5pKdsWvrpv2/A536/M2F3R2b+h/GTp8lVND94unfYrMhfXpO2ixbDTP0Q7QQN5X8WB2RBfifgEM170a7m0ObQDWCe8Wq/OEoJstkQYMQ2lBXP/P6sqs25I0cJ79bNNPAhdPvg3D5Q/Z8ZBO7DW8EC9wKuY6eVxLrBq2g3nPi4mOnQHeAHRRjoholK+fEPUgohwZfMw8Ei/bCNLmU2Jwv9l0VUnVIwcoAUDCo1Gn2zRqabfmp3Nk2EdKXZdhJE2fno86f3z9s0UR1s8B8mKIbKBCHQmwH+q+4hzE5HApngZJJcUbm5yhJlpX781aagq6ntnxOvVlqTzyUcaCwPr54p6PdICkABF0SFqeN8XZTkMHtBKkBMa/qb2wk8ot8dAjKmhMVpgBxx7AuDUnMZPa//DzvH5OLh4evFX1KXDcPLgF28ua20JgNpqn/aK1nUvSbbTVD1QjqxJBsQIONWVuvcNDDgCmz5OWL42q+AwmeuegOWbDqOb4AImYQqVKaR0P1N+NgLvPzmM
 fAPdZPsW
 7gnTXa4VIX+kr/jy9CAo2CXhSON0SZerDPhvpVqDmKgBgA8fV4fUPJ5G0P525anpfNilY5gT+uAqwQwT7Tnqy4qtUxTmccMU1tbDSvSsN3iTFOuZoBtsB/Bun/g2sQoZ8pM0odhILo1z1eXAQXb4B2nUTtLvaqFCmpI6d4rJzyZ8VTgmqFAKTIYn+shzrD7cqhEJSmij/zhOuO2FgC2/H36tK03DXhkysaVM35iikxYa820kQ7lzolgW0PVaeYj1/ksglfmv7yUgVhSL2POfebiMw1LtloWKQBSaYjooHYx4D9+yWIkPq8UO24qHWQxm4DNSahWooXwvGN/f6cfvhSSZD/VkAMGgomKbB7A82rjUnQdzcQHkuVI6Owjvezifrl3+ZsXV0cewsvqARZFS5sG3wsdbZ9aNM9vN5XqRW87QYE5p0u1fGPzx0/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2026, at 23:34, Baolin Wang wrote:

> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
> parameter to specify the collapse order. Additionally, added mTHP collapse
> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
> for anonymous folios. All khugepaged test cases passed.
>
> Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c   | 137 +++++++++++++++++++---
>  tools/testing/selftests/mm/run_vmtests.sh |   2 +
>  2 files changed, 120 insertions(+), 19 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

