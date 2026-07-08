Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1F1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648CA6B008A; Tue,  7 Jul 2026 21:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620C66B008C; Tue,  7 Jul 2026 21:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510D76B0092; Tue,  7 Jul 2026 21:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 021BB6B008A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:51:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66F27A0576
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:51:32 +0000 (UTC)
X-FDA: 84963932424.13.45FF421
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 912C6140002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:51:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ciz0hXLO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783475489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hvnEKOYGxY+c99I8Nk0XDXF7VYEITjwt2+wNRetklo0=;
	b=dgFxagIizub6Eml/IPxTMUtR2eFG7iojtjxb+/kCjYSKhFTz2qN8i5IT5JKa5ThxrAaf14
	uwxabLakP7FVTUKKLVDkdZl+y+o+Whwq1Dkz36hmo2OguiUJZpxdYy1tL+/sO6m3Oe0/An
	HT9Z8wZZGn4008kWZ0/yyF0crUPpJQE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ciz0hXLO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783475489;
	b=DKeDYqkj1BkGJs3LU+yngSRE2vlkr2vczqoJInKloHE+/uxRYTbfjP9fsnp2EUyzKov1le
	EYBcWSI7LGjHyTuf1lgW0ThH3+Z2VlFkfJyhDLNfVxNiWjcl17sIp201qY1Tjkr8t5NPrO
	tNJr2Erqw6bgeT/Vg+lqBz0scVs5RJ0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMnwmufGfBCmwffvb4Y2uJgw2wfMnLQEvXxGJA6sT4ACPyKMGKHmv7rk6yCJlHIOnX4JImjE8u8bsoeh7NCmF+X93k6gG6+J9WTOb+kxTdFKlJrJP9DmaiW7ERbjdRUc/A/coqltzG2Ru23ZiUjRoD1Y/ZFVIDHWShTAaO4xVUb1NF6Rn+vFifVQ8aLd914sR0IYiHyxuj/UsG1bmqA9l243IfVTCp6Koi4lCGRjpahlYVymOsDVhRHRk34VvyeUh1+LWlpeg5+kFa3JGvD8lRa3yyjgmsiQz4YiZb7MDFZ7ULMjaw+neCwnoGT0rYW0CkcH0f/HmL5mvfY4hs8erg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvnEKOYGxY+c99I8Nk0XDXF7VYEITjwt2+wNRetklo0=;
 b=Kys9mEWzvJzo8jzvl5ohcceRNBu7sRgweKo4Crday3uCJiby0lkY/IWhdXEcm+OhbjCceQxNbFqhNjOHzOCvumRWTSxJrFnXpCGUU97RKZDZLVDSY/wlWkAVz+wKQouDAxfqZt7rkduluBftKlC4nx56LZIcbUluEW2yWXpkvkhTbbw61MjALKpLyIgAgzVlYXvKc6O1xbLTtwkg+S3FOLr/lIcNzokDLYr4fO23VYghHDEm8MkQoS0ULDx9hL4BrxcWhYZWvwv1cX1vEQU9ISZGJmGHjnr4KVkOWdyfTejfkzSCSk6AbHX5ow2j25EBgYI9udtlROz4aJ/l/i9VJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvnEKOYGxY+c99I8Nk0XDXF7VYEITjwt2+wNRetklo0=;
 b=Ciz0hXLOXIseSlw9Vo9CYMvZiklmeBrUxa5XRW5zsaccGAlwJaoDGnVamvbGXqwY4lfM5DXKXHPllT4z9CS8JEiCyBJv/SVSjDfSZU0uq9D2zDZb0H4CUJt5BRDiTBjAjzFxIBooT33Zcl5GvmW5suvOUrZ6D7v1+6TmySROjoPLsp40KqBIEXLHq2O3ZsOyOjX+Kk+fby3YgBmEl5PyvH9+xs7pDGwlO+TcepLEWo4ncm5Cea6SAy/L3U/gnrhwd0rb5LSjoQ04EJLgzM14QyhotLz2wg3SkKgW9tFh/WehGgGxqfUzNWLM5vC2dq95j1sICHriTLXa7pu2DSnejg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ1PR12MB6290.namprd12.prod.outlook.com (2603:10b6:a03:457::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 01:51:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 01:51:23 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Tue, 07 Jul 2026 21:50:20 -0400
Subject: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
X-B4-Tracking: v=1; b=H4sIANusTWoC/x3NTQrCMBBA4auUWTuQRm3Rq0gJMZnWgfyUSYlK6
 d0NLt/mezsUEqYC924HocqFc2rRnzpwL5sWQvatQSs9qFGNOPMHrYj9Yq4kc8hv5ISRF7EbmRq
 tcTkEcptZo0d3VZfnTQ/92RM0cxVqwP/3mI7jB/SYc/J/AAAA
X-Change-ID: 20260707-fix-array-overflow-in-migrate_vma_collect_pmd-c504b92613de
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Sashiko <sashiko-bot@kernel.org>, Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS7P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25c::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ1PR12MB6290:EE_
X-MS-Office365-Filtering-Correlation-Id: a47d7d43-99ec-429b-43cd-08dedc936a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|23010399003|376014|7416014|18002099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	gUsWUx6sDk42D7S5U26e83C/sH3GzGQdziwip+jpm0zexMaD4mh/tLLBCY7AOMhEZWZwf00RkxqWY9oFtQvF7S84/HRjI7LS+vB/qnsPNs/26fkSI6SMAkjnCE22sGkqlsGR0czQ280ILUsy3PabEsVOy1RphVbngvVEG5gSD2G9d650l/E520bdHhGrPhCVoIjWiwwZKwtHRgFQOh6f2n9GC2ahLbyjv3QCehV3zygs2bNA8p4/Tuk8IOHSyU7tCGXA/U5ugNTsZVv7LQgQm8Ag+yIWUt7qXlPMDTd5Zz+V/XyaaL3kwDsJ4+qJFLLtLTwr0OHhfdolHLEaEmJm4dsvPwzFtJPdwPEvza9tai7sgQ92lA2eRzmiHB48+pLbu9sS7mBZGV7fq8PuCaagsH9z6V4QCcilBBmJ7eGgF1UKno7HD0cYPXAQyJBuPzj7Mt1qcnLUaPjT4M4T4wTOC5FXZ1Gsl1Et+xgrqmOVHNzFRk2+UsEfZTCBurUvJhnlTyaGs/ayWtYpw15SBWstE4MhN4hMS7eS+PVjqF7ra4MCmxomkl6gd/1cKedsTHsflDWuZLC/eVyqjikO8j3+sh2rxApuDvXpw2cqORNlPaiNL70JzLVzeqr2tneNoqgP/rnPMMCtYkYVc4cwwZ5tExu6aC6J6Xs+MqMqKz/3fIijrnR05pwlSm90AM8TdmgFF4v/8cpP6fDy6IL3tNaw2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHQ5S2tvL25YSGFEemxuNmZXS016bmJMaEVEbUswdUlIUk81b1VEVkEweGRz?=
 =?utf-8?B?NncyTmx3dEEvQk5aR28rTW1Cc0lzSlh6djVNa2FsVEJUVnpQTkF6d0FGMFp6?=
 =?utf-8?B?cGlicFlkR0x4eEd2Wk9MN1Z6dXhZMTgxTG5Ra0RoZlIrM2FtSDlwRThETVp2?=
 =?utf-8?B?L0RTMzlZOXJaN1ZuNzVGc3M4bDZJOE5RalAwb0Q2L3hBQVltSVlDbmJ0UmpL?=
 =?utf-8?B?am5UMTUzOUNNYmNacHg3aStSMjZxaWxoR3pSRldxT2g1RVozR1IrVDR1MzBF?=
 =?utf-8?B?ZDNVTXBVbVB2YzNFUGxDc3FFei9YSWs5OCtFU3FPWUpiWUh5ZDI0Q2JIWDVF?=
 =?utf-8?B?QzhlaVA4aFFBWEpNckZGUW8wdVNiUHlsQzI3RGZXTDJ0U0RUUGRWV0hoS0RZ?=
 =?utf-8?B?bzRiV0trUFYxT2lXTS9ON2JtRDhBYnBTamkvRTN4Qk1sZ1pBbjN2eVo3TUVI?=
 =?utf-8?B?MHpIUnVGRVVvOVl1cHdXQUViYjc0emVWWU1abFJTYXJySU1MbkRPZXJwc1J1?=
 =?utf-8?B?d2RMMjFSRkRmYlRWaDBoKzhVaGJYNVFhY0ZwMGlrVlFwODIyMjE5Y0hWUDRm?=
 =?utf-8?B?bVZEcVZ0ZHg1WHNkTmltckQ2SEc2REpHb1Racmw3YmZtaSt6M3hySzN6SEow?=
 =?utf-8?B?dlFWNEJpVDU2anRoYXliZnlBWXNWOVgwSUxwQmlFRDhWdS9WRVBIaFNSYXBC?=
 =?utf-8?B?UW5qTUNnQzNkTCtTQm9YSU9kMGNKaXFRRmlHQ2krSjJncFhIMnczWkgxZFc0?=
 =?utf-8?B?UEtzSm5rWWl2T0hYcVJLNmlRRUFaK1BYeXY0SlVPWVVNZlQ5YXhLZnJJdXJy?=
 =?utf-8?B?aTQ5dFNoV0ZVdUN3ZlZDL1Z2V3plbjNxMHlFWUMxRzQ4aTFXcytmc2h2MmpQ?=
 =?utf-8?B?Mk5tYjd6WFhObXoxamx4c1M5TGRTczd5S3FhU3lmc1NRVkFrQzB4OFRGdmZC?=
 =?utf-8?B?VlRicW1SNEJHdXRFNzRLWFFYWXFwVFVHRGZCWWw1RUFHTEJaT0VOSnRaN1VE?=
 =?utf-8?B?d292Nm5EZXJmdE9LanF4aEYzNXcxSnlCbTRyRk91WjE2Ny9waGx4TGdlYkJJ?=
 =?utf-8?B?aUhUVkpoT1NrTkZzUkprRTc4NGtwL1dwdUR4ZkhhV203VldUVHZ2c3JVN1FK?=
 =?utf-8?B?Umk0RmxwK01mdTBGbVR4TGtFam1jV2d5TWdwQmgvS1h3V1VFNkh4N2gwR0lj?=
 =?utf-8?B?OWI5c01SZmh6OFF6Q21INVc5a3VHUGJLRTV5REdxcGI1UWRrWit6TzFkTDBr?=
 =?utf-8?B?cEtVUDY2bUlFd1ptR0hMTzkveDJ0eVoyV3BNS0RMNFlCdE5FTDB5UlpaTGVJ?=
 =?utf-8?B?RHppNXI5U1VUWTFYUGhKeGpVY2N0SDNyWVo3bnc5aGJSWXV3MHdzTmlOWkZY?=
 =?utf-8?B?WlZEMHUvaUhmTHExdWFFcWFFKytwT2x3MFNXUzJPQTduNHM0OFkrWXlLL0Z6?=
 =?utf-8?B?VkhvSEI5aWlBWVJmQkQwUGVzZkVoZU5vTVJxUXhHbXpad0phUXhJLzRkaG5j?=
 =?utf-8?B?VXdQZjdVK3dieG1KRG8xdjc1Sm9ucVppRmtoVmZTSWNHeCtzSmhOanJFUXhn?=
 =?utf-8?B?NXhNQVhmenNIQy9LV0RydE8zbEp4NmNCbFdjRDEyMUFuMzV6MURrU3lWRnpV?=
 =?utf-8?B?dVM4amxIL3d5V3NCZmhoY1QwTzFPQUg2WC8ySmUxbGF6dk85dStoL2lMWWRL?=
 =?utf-8?B?N0FUZk9XK1pmclR6VEhVU0dac0ZocFkzWHNiU1ovNDhBTEVabzliUytoYmNr?=
 =?utf-8?B?Y2pleDlkOFpmWk5QY3V5VE5WSUZHV1NLZXZkQW00VkUwRHRSTyt2NUN1T2JO?=
 =?utf-8?B?NG94M1VsaVpSRzJ4c0QrVzk0SG56ZFVqd0pjTmJmcHJncTZoQU16ajZKSHJs?=
 =?utf-8?B?aVhXbjUrMWxRWXRRNnU2dHdsUjFFZFdhSlJqYXN1R1ZvYVdiS1ZTL1ZQTVNR?=
 =?utf-8?B?aXJwWVZGUWlDOFFmcFIzK1k0UmdKUDNaYUozRDZBWWdINFE0Tmw5L1lER094?=
 =?utf-8?B?eUVTTzNSMHJsRUZKdzUzOFBtcnh5UW05cjM1RWg1TFVlamg4L3RwaElIQndZ?=
 =?utf-8?B?WnBRamhnc2RCNWp5bktZdkFKZnhEeFhUbHhYdDlmZ2xYNDUycG52SFh2dXNN?=
 =?utf-8?B?eEp3VWtqSXNISGZqSWNWd21pYTNMallRbTNNOVE2SEs4ak9xcGNTeDFrL1FB?=
 =?utf-8?B?d2N1RldjTEhteHl1eXRGQVYxRXRLNWx4YkhwQjVJZ2NnSDlSS0R6aW1STWZN?=
 =?utf-8?B?VWlEWjdiTTRTMkNsbkFzLzVxZDdDQWZ4Zlp4akdQSEpDelMyRVJ5VVBHVHI1?=
 =?utf-8?B?S1NROXgwSi8ra2NaNUFtVTZ5UXJ6TkpzK3NLclVwZnRURnpDNmZTdnh3QmFT?=
 =?utf-8?Q?Vo9g3fYecGgVtalIee8BZFyM/T9WGfddJwnxF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47d7d43-99ec-429b-43cd-08dedc936a07
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 01:51:23.2503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWuKCkvVZXfdxwgrO8FYGn0RchhU3aXnJIM2FxUAghGRrP8Q9XlAIouQJAZM9geh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6290
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 912C6140002
X-Stat-Signature: oi6w6fsx5wkq8zmjds5yb3wjnxg5jhrh
X-Rspam-User: 
X-HE-Tag: 1783475489-509212
X-HE-Meta: U2FsdGVkX18yJdYRtXmtT/iLcBotD5zE0aa7I3yfIJM6DCkV/iEVtJWnoLAPPxHi3/QELjmcV+uJJuDKoQCt4grkda7YWS7+1pWxD7xPvaH1hxQH7t9oL9orjkW2z1L6+cvgvUXlAgBVx4+GXjAtu6Ke2kpu6nIeiQtsckdrG/PlzNUE7Cs0LtMQEX9TxvZ91WElyBNbtm/mSm1h8y+sbHMEAVJ57lqgyXj1uX0/gHnyIzPtoFSQF9OtFm5uon6JaD2hi03oMT4edlbUySb5BmS2DqXtSkbMVyFoVdC+mQDL9bpfjUxZyRcmkbcyNUz7LJLCVdqS6P7Ivg2Pev7rCmlkWsMILlmlqN22G+1Bk9P4aHMn7izBpZsEoJmQTugngvM20UzfwiMv5xjRusASdsyYd3TtvGYphnFDtHphsIkLOQ0CTFNQiUafSfemwCoQAJqCvAhd+oVpOo2tnCPJAJLQwadyjhLKym3myIb1HKyUFzIz7E557kaa2XSJWHkKOqoCYRiqIE3kWEiDCQM+10P/Sh8L05f/TpzD2zif7wmGFdneVyvsleEhL18c5NMm3jowBpiK1ancx8CuUDQgWUsAj00y0ES3tthGgxeFr0N38FNb3M2P+BLew9+AKsXJmberoO7jJf2A0RH5iqCU1a81kdnDgMMqje5eE4W0pp3K15WDHnEurcRtULyvb3DfI+4dPT01JrlKvn4zunHXZ/S51pGTx5+h7UjSVzhXWTgeQp8WMxTSXepp+ZJLpBLCu57Jyk/g90NDdyhZEdG449NxlRyTbF1jWw6EJ+5/gyeEJQBS9QB60hbT8LvenpXTBRzdUyP4hNDXyX51dhFWmtJSx8Bgvtt/kLaWM7LBT978/XxBwwN/4nfwV4hqjik0imaJCxhaSIrdSNeJ3LBSxotM1OTm1Rm7dx22+wVGXbbVaDNf146Haa3uDFSbXd0lqGHNqvBNCTGb/xTWSWY
 b/3qRTH0
 3K05betQyiBeHRsfrhIwL6Tc+5uZw9yP7nhGESmMwXnllD1fbwTU5DEt6/sjRvoJ3dSjxFdoRAALJcspUfuLKuL0wwMm6fiRbiIzWub5XwMhhrq4lfnT2KOHvVmoyVY7KCgSZ5MO95QRIRPua8Ih+0XGokXmbDvhj7jGxNO8qZMIYm0JRRFxC13WZ73hAtQUUO84MHYBy2W9Uuqwr5GVv2nQyl8pS0vQ6EPG22D0flTvacT9vxO5lpoAJSdGiddAECoOl14xhfX8NXlTAqgppmq7JayDuuSXr4e15VKYNBsfz+cl39CuC1fDrxwKvnpWwFVtl6NbosdrJnVDdBWbU9izvVc+amIECfmum6N+jT4hs3dbSABNurELgsD6i/dIgbMBoZdygz2NMnyB671WHXb/An02f+V4bKEgocOGSvfkv/va3d0/0tJV/yCWdDpP7FuXvbbz6tga6tFE0lNTSh/rEBd3iRNwArxrPAOIHAlv0IFccv5uzczsqGbQPoGS3pR9/buku1DpOEyb07dIKSKZ6UqcQKdj0Ki+UGfIGpZP9cuFmLseF2SbiwlYZZ3YpG1EC+1vQjrNabPVlLEZ9ZbvkDZ4YItBImsMRdH8o8CAPWyHkSuGAKG8Hew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_collect_pmd() can drop pte lock to split a large folio and
restart. But the code does not handle restart properly when pmd becomes
huge or cleared. It can overflow migrate->dst and migrate->src arrays
during the hole or skip collection. Fix it by:
1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
2. skipping the rest of the range if pmd no longer points to a pte page
   table.

Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@huawei.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
The issue is spot by Sashiko during a patch[1] review as a pre-existing one.
This patch has the minimal change. An alternative is to reset
migrate->cpages and migrate->npages and restart the whole range from the
beginning, but that also requires a restoration of no-longer-present PTEs.

Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.wang@huawei.com/ [1]
---
 mm/migrate_device.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 2fffeb1f99694..6ceb47ec1da24 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -257,7 +257,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	pte_t *ptep;
 
 again:
-	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
+	/*
+	 * Only check pmd when addr is at start, namely no pte is collected.
+	 * It avoids collecting the same address range [start, addr) twice
+	 * and overflowing the collection arrays.
+	 */
+	if (addr == start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp))) {
 		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
 
 		if (ret == -EAGAIN)
@@ -267,8 +272,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
-	if (!ptep)
+	if (!ptep) {
+		/*
+		 * Skip the rest if pmd becomes huge or cleared. Flush if any
+		 * pte is modified
+		 */
+		if (addr != start) {
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, end);
+			return migrate_vma_collect_skip(addr, end, walk);
+		}
 		goto again;
+	}
 	lazy_mmu_mode_enable();
 	ptep += (addr - start) / PAGE_SIZE;
 

---
base-commit: 302dfbff3e73be2ba5723237c6303244ec27cebb
change-id: 20260707-fix-array-overflow-in-migrate_vma_collect_pmd-c504b92613de

Best regards,
-- 
Yan, Zi


