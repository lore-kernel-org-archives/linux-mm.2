Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82C8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18726B00BC; Wed, 15 Jul 2026 09:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFA86B00BE; Wed, 15 Jul 2026 09:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06E66B00BF; Wed, 15 Jul 2026 09:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9810D6B00BC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:30:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 259D31201AD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:30:35 +0000 (UTC)
X-FDA: 84991095630.15.5C8B8A9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id 19FD34000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:30:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LvH0OYLU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784122232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6r8X3xT+3cHz7MTODz99ieFTS/uxFO7jOk6VIrxzW7c=;
	b=zKVLBU97fNUTMQANGmVCuSLEZTIUpeirtScrkY+kA7Z3/Kni5iS3NPWdr0r7FgmctQtvWh
	WX0JUPVbE91lwWAYk08AgmImnoKfMBddEJ2CTpNbF2Gz2vV9HZY5bWHAmtIEua2InkgpLw
	+azOPbu5AWLsn7Kgo3vnnSsSLCD5gC4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LvH0OYLU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784122232;
	b=n8mhRIzt5yXIj+hMwAMLl4bzwrF3cEwknyPXa+6JMfhvWeQCFeU01yx1UkwyEoI4jBhg7j
	KYhw9sYLe8jljYlDtnl9v1svWs3nxFlf2Lntudn3qkmOWfnlAwzGQbN/eo0iT6SJbRmyUG
	/huiPhnLniCiEi70z9fTkfyUBpKBhvY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWjxc4k/2yDvL3SGybtcT4rb9l8H+kS9zH/af6S7l84wVVI3tc3Zsf7G9V572eHM5uJLNSFY8f8G5ZmdYjoPYT4czIBbENgUf6pmWaOXsDAlFbaDpLXInZNo4a/3GpGTbhnilOX4Agg/ZWMRBjYxCWlOeGkEwc+n12LARUtFwXsd/C7hAN1AxTXG5XcL+EZiVqNs/dkrAkD82kidQj/pOeehyYDrHLZd9WMfAKsRrGfYNpFG0brQbKuWL3nZGvbEX1cAL3Cx4Cisk2iCbLBskIdlEsYVttrT0Duu7IiJwlYFoeGVgZ83bkHvg0DMZ0/0lzEdzLc3RgFhGy3OkT4X6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r8X3xT+3cHz7MTODz99ieFTS/uxFO7jOk6VIrxzW7c=;
 b=JbpOsfWpQdUB+MdMy82jMJ6zcM77wBYug4S7x3vXvJ5gKczdeywwfNZR/EdeWF5tWalCspqQbuKooy7Sv1u9e6iYgoqq29eJ4tiieyeo5Cwa2vL9SAzElsYR/3nQ77a0/4CKLEKLSBWP3cx/oHBiC1xT7+B0jTQc6QvZxvsysCautvgVzJv500ZujLvXR8hV/wZYcpJRPC7sp+PrItAdCRiNevNtA/Y/m/IiSuzt6C0S6k1X5aNaVJY7buoAU8l8OV3OSBK6rBJId/u71NddsfV4v10daLQ82ExJ55Z4ffByIPQjD2aiW31KbNn/Ril5WxJZF+VuG7Nnfi9J9ysQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r8X3xT+3cHz7MTODz99ieFTS/uxFO7jOk6VIrxzW7c=;
 b=LvH0OYLU54BG/Lsjc6H0I/SDJIBxKOCGMXc6TzVDE1IIMgzXpR429VzPgkwXTxWgcY77DOu289qp18+vGutylcOpYRjpKt4a9L7tpz/u33K7pxyqDxi/BSm3kDz3/LObQ6PwYUYvYiPVT5VmC4H9dVfOR1oJekO5lvXJrL8YfUooG4SMDzxkzciQouZuNk99mguV2/vm8gjepCrsSN0ah7PIkLDTNbv3w/MNvDQ79+gVk6PlcszwAPmTEMohuUMSsLiZtBWi7E9Ow0M75z9cd45Lipri0wzuIYiEUWM9nspzjbg/mV/skOmg5E7bqX6mfXSUgStWssFMWSU24mKopA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8562.namprd12.prod.outlook.com (2603:10b6:8:164::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 13:30:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 13:30:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Date: Wed, 15 Jul 2026 09:30:25 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <C15D0F7F-0F29-4BEE-A4F7-53A3E6034D7D@nvidia.com>
In-Reply-To: <8f7f0a6f-d819-4a56-bb5c-d690664dd80e@kernel.org>
References: <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
 <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
 <alVjyqWiAggf1mTG@nvdebian.thelocal>
 <aaab69a7-d1f8-4fba-be13-6de109f37348@nvidia.com>
 <alXFS7BJWLwH6Wpt@nvdebian.thelocal> <DJYQKBV5C3WQ.2A702GAYGPW71@nvidia.com>
 <8f7f0a6f-d819-4a56-bb5c-d690664dd80e@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0291.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: efcbcb53-1e3c-42e6-6543-08dee2753b60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|22082099003|18002099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	yxtoOAug94427HgJ69fePJj2Dhv+HJ/b+suyVnSj89fmOxyeQvFdAhpM9HIA+AZuM8gsi9duBLhT3v3QNvv6NFI5SLVXqxDfgQyLQ9lipnKz6SY1Sww1Jsb3mUcjNRcQNm3/8woc9Ij3Ad8TN61OdmdVkAvKHDtXs+Hpc/laVA+auPzpCW8a1J6eLQyInfnpd0eMN+91VqIqIIk6QSNBYSWmwnfbvXnCvhkzvz01BXn9cuM+VNBm+WypUsaj+R8I6NewvPYs2HCwI2HCs6RqLWlJtOK+eRkYi04ttI6PAra/8aYnyIMpPoV16hdbVbyb4W3+99mavK8fhBRXW89edZyKbgCkozVoDdmpdrdnJ6SZvoYVpvFlaIQZw68Rc8J1Rc92NsPFBVZhEwJSeHaBheeFgWegWuhbGzuVT0ZS1ZqO+qcaxnfn6v8ylAVJ1ayERTTPAYFF570b5uWSV5EE7pGL+tzLVckb8mNsxIqyonTvnC/UlgE/wGcZnRU/znmaSMhVN3SxQ1SP0CI0TaVZlI11yTucGTprYtzJfomNnr9Xjffhrpl1yfAWP//SbMgDDWcBJxCKLGYCIYJZJeu2jf9pW9ezQdJhxn26rAqu/iIw6i94pdSAxlBip2pmF1tcZuXO6Ic/OVYOxtRHayDgOdXIoDUcs3JDAkYxbTbcPyc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9zXwe+s3C5JYmrI4FEYJLBE/aJM9JRx05TGSu0+2S2RDJPnT1GP1OsKzAjMq?=
 =?us-ascii?Q?CWWXE13K1eXOovJepKb538uGa4xa89cUa1jZ1nFtJvgW/CHz+bzaWyzjpE57?=
 =?us-ascii?Q?L0bYdKANyC8j3hug5M5tE8JAii45k4Fm5KJBShwoNdxTXfqaBBKqrlH5wQ+d?=
 =?us-ascii?Q?Tc6Oz6kA2ZUJK9WT3M62MKfRZ3anlWOyyftTQjv0r1lmfeeHYH43tLcB+hFj?=
 =?us-ascii?Q?aF9vJPXNuCga8KCo7nw6J60b3Bkr0Hay+fFFz0SH0qElxq5cOiLZ8Z4fMMhG?=
 =?us-ascii?Q?CtGw/6680gjBeMxJ86Vr2003RC+0QelLMrQ57IPqvYNGJSQ2T0DcBT5GDXgN?=
 =?us-ascii?Q?schlzDHQptt4yZnGyfmOOpJsh2cOeg7PH/So4tizpWXdxcQEon28sSHFXGAV?=
 =?us-ascii?Q?sZRjOh1zAHUQwEU/PxrrD1u1lw7NEhNUQRjZnSUlrtsTCpm3wVXjfRmz221j?=
 =?us-ascii?Q?57zDUUkD89JnauBMRx5X91p2QUvLSjqNiKFBW5gm2IdLVW63hfrk6XR8MVpJ?=
 =?us-ascii?Q?X8V8WXobvYkg8SpkOdrwEgFoquxHFnc2jUn9alhORtSyF+elv79H3ubY28cu?=
 =?us-ascii?Q?TM1RvJSUag80GI4FUjhtzsevQ7eL3VOCIsgAGvoUko1f6WbuA7lZuqSHGyaH?=
 =?us-ascii?Q?2N9n1+3C21ZEcnoLsZ4EGpANQTGMQ/jLgQDUJZLI0q6TH5UbcBZ7CyCMiQ9G?=
 =?us-ascii?Q?1QC9zBIIAGYBbGKOv9xV2d4FMXfxeiZAiK7ZpFSg54maOdH/eZzKuePbRT4I?=
 =?us-ascii?Q?zLgTgWpjd0DLSorRAJxf5xudeMPyqUwfLC+YEpQ/bZiGMmgHFu+WYQD0aSaF?=
 =?us-ascii?Q?+oPUcDne/s/dKw5sy40apmhDKBmVywFbarWnOeGP/A0q3B0MZKaJQ3JiKrml?=
 =?us-ascii?Q?Uso+/atkOa/AKegrruq1XCVtmFVOYmTX0gZT9TXg9RBlN7TYB9uG0jL1IPij?=
 =?us-ascii?Q?Jmsu4XM8KxQEm0K9XRYKeh1czwsFfHZSG2IywgqoGc5F9ovPVH3Ky8h2C4Ja?=
 =?us-ascii?Q?gCZmVJNg+jloQnpJltNTKfOCxIjywJJMLGXlp4kcLDrETlaJY+Q5qB9C9WXk?=
 =?us-ascii?Q?m5K6AAudNGxYlynin7H8jbJKq6HVHxSUOL1raOlaES5o2RJzI1flqmUcAq5o?=
 =?us-ascii?Q?I+QM84wj8k80J5sv3XPqt72OxwXxsZ7Fp7q676ZF8cSgGooShxYwp3lOVW13?=
 =?us-ascii?Q?DMloc/rv/tAUD86JnDugF6oNlnhkggnETakrjiKqM0vMvYFp2KnSuX8/fBVv?=
 =?us-ascii?Q?GTP4QTH9bctqlPICiG2wrktGSqbf6zLHNBwgmKI0cHDFh/GcTYsTtR81RQ8p?=
 =?us-ascii?Q?cE3xu/bQ8Yc9tA9Tmq5hnRYY6gVZhC392fFp+42Zh010bM6FQJZHEgKPPifb?=
 =?us-ascii?Q?PafiiYKhB21kI7PsjroWiObAu/L/A4A6Teg+vErIQJddLn0viYkqUNvTMnU3?=
 =?us-ascii?Q?2JC7fKnNLlx6xPsoRttKX2z5KNcqMOKDpb+lVGne9JXwzBv/MpWYXK1pd801?=
 =?us-ascii?Q?Ojc0K/tQ7gUL6LCfoXMcOWe+kmnGMQInDwq+eoR6sNfGwIQ9uwlNRt2L/FdI?=
 =?us-ascii?Q?3JaE/ANgIhf4CQ+reNfLyWYTDc0p4svGnkkJGzsMvRPqmwrpmdVxtFBmOIsO?=
 =?us-ascii?Q?SgT+T6NacRNlbKAg9l/8Oi07kRDmqlcyhvwUZG1mEfbzTLYNRo9NiI68wdgF?=
 =?us-ascii?Q?hqf3LR+i4HfLQJmQd7gA5M6rwGNCmbpiOHct4f8ywuSGlEMava3h5FE44ksB?=
 =?us-ascii?Q?R945NE425Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efcbcb53-1e3c-42e6-6543-08dee2753b60
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 13:30:26.9943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ajz59PDcbHX1M7n0ZcEYT2cc8Ev9Q9Dt3M3klfPli2Zt6j9ocI4kWXin2U2/Avj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8562
X-Stat-Signature: xib3ssit8ddp1wigmendkra51ma77mah
X-Rspamd-Queue-Id: 19FD34000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784122231-974969
X-HE-Meta: U2FsdGVkX1+fDiaFmwTkm0tjb2/2vNhuohPNLj26KrKIUSYSf8qdD4UZc1ApR93Z1ZEa4M7j1K9kptIHebJbNB1ipxh49GG9SzExeAL6c+uZNbCywy1hVDoMPX9D09NQFo6EriYN2Bi+Rchi9+07c3VLQnycpE9rjkIP/sQyfNMy/vv8RV4hI1jMFWljULIvnkes1rNg07tPQobp5tsUmWwnoWz2N8+V14cvaOy/17nXH5UEoflfNFwKYAl7skBUvo0UkUhl8cZleYRw8vXL1l/Wdj1xmEVwmgZbiug+vJOdTC7KYxHCwdq4vMOLO8kUz5YbcPtvG53oKFznmWzS10e0hwMP7LfLu6IU1jan/fKHNb4ZaZUDhjZV9bpZlWV+XJ7eySUBhD9TvZVRZJLiEVinoj3fCTwtyEUyLNTdbCZMVUo+WEdHVQ4yb8Q999f+xEDDNhCX5BXJvzq59RUSlzicwwsRww+XP5vmahTrzPXA7GBm/gREkFBwqWlEwVyHv0mjo/pO9w5C5nZ2bK4wgx4RhEWnSw7ekSk0ep/f81cVGLYHFSh9mXXDw3nBGsKvsY/+eIzpjBUfnhnkGANo6SQvV10tSsGooo3JCLqGQALnZaeNSAxahJHx+aLkDqV1nziZ34pQPOJhlWsQkuXPJeS1iBCn6L8eU9T1cLe3PdDSbiRGdGyayEIGBs1b6eF24tfoZGMc0iEyG2raG64LJTTZbORKQZpeU6tpMF0r06tWuUBjGLaayNVaPyBI2LbWWewh1PfiaBdMkgjHMcmMAzSqXFl1aqcD8/0MO6Q52gz6K2batCOPFdMiaNPeUTB7ktwygNSHwwcJsqBWSmsGX1E7WQhY73hVgcNF40QJZFQKR9nuMA5RdZLdbehmLcsx2luFWAi83wSSgl2EI3pQMpx+bW5fG+7ujnbhhIrO3zoRQasBEkCzsoeeGlOTVuTZ8nVf9tZ49GWgzYCNkfM
 UATiNaqV
 KLtW6WHLc+Z9MUqbzhCz7kfOu/ilkmrkqpj/ceza5hACtVq0Tk1pz4Z/NTMFxFTXnMLxdvjfVIHycHRglJD4B4W5GxTUZNz9x1q833wSBCiGGvsnsvNb3yUugZVCGiOkl9B+26wfiZgK5j7XrBzNOEvlIE/iNm7sxHbmP3YTWVubstwNAWtrmFfFP+pmfXnk6pgEXRggZZBMsn0Pmfulax11yD4NdusmLCiUk0wfIJGnjGEPE6cKm8vn0foo/VhWZwHcRaRbc4mg4o0nUhedYU3BpmS0dqlDuM+2PfrbZ2tQRD7e6FTsrUJqNo1Rz/XTr01KM/O3+NIkSujyxcAlVpj7u/EE+ZnhOGLmFQt96PYvmOS7EclbAp9/e6Gxui6HAc+LdH52OTuGm4mgC58mR8D43s37+l1Q6dne/7lOSwCKJoz1P56Y7Kl2PwsrYHBuu0BqV9ptI8QjN/ybxv7x9oywEwGct9+t1R6+y0dSUlbspmE22ttxzyjLDYikgUAMlCzpQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Jul 2026, at 8:40, David Hildenbrand (Arm) wrote:

> On 7/15/26 02:59, Zi Yan wrote:
>> On Tue Jul 14, 2026 at 1:30 AM EDT, Alistair Popple wrote:
>>> On 2026-07-14 at 10:10 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
>>>>
>>>> I had a patch to add tracepoints to the code and some of that instrumentation
>>>> included this data. A combination of the trace points + hmm_tests will help us
>>>> get some data to start with.
>>>
>>> But hmm-test already has a nice bandwidth benchmark :) We just need to force
>>> the slow path. That used to be easier before I simplified the trylock handling
>>> but with the below patch applied I get quite a lot better perf from the
>>> optimisation. Note the patch isn't entirely correct as it assumes any locked
>>> page was locked by migrate_vma_collect_pmd but it's good enough for the purposes
>>> here.
>>
>> Thanks for the numbers. If I read them correctly, the optimization
>> has about 3x throughput of unoptimzied version. The optimization has to
>> stay.
>>
>> I will try to come up with a fix that resets collected PFNs, reverts
>> established migration entry along with putting folio ref, and restarts
>> from the beginning.
>
> IIUC, with the page table gone there are no entries to revert. We only have to
> take care of folio lock+ref.

You are right.

>
> Which raises a question: how can the page table be gone when it contained
> migration entries? Probably MADV_DONTNEED could clear them, followed by
> reclaiming the page table, maybe.

Yes, that is the case pointed out by Codex.

Best Regards,
Yan, Zi

