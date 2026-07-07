Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D47C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 22:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B25F6B009D; Tue,  7 Jul 2026 18:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AAD6B009F; Tue,  7 Jul 2026 18:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0626B00A0; Tue,  7 Jul 2026 18:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 093AE6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:58:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 609541C833D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:58:09 +0000 (UTC)
X-FDA: 84963495498.29.5F17758
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012063.outbound.protection.outlook.com [40.107.200.63])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8407E180006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:58:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NMMqPOgt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.63 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783465086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSwYgSCuGhydm7SW28wLKtBsLt0mY3QeTJHdzjtG+Yg=;
	b=Si3Yac9xo10tb4HZUX8zaO+P6/SoB7HVO9HcXUlOw4RCIEAoCIlYMNfD2yIuezYXsu+kuM
	jRd7ZGWycQgjqif7KYjSJCUUY7CV50Mkxi9+AF7IS+WItCPN2k6fnNhKBiA7mgUQ1Kj4/D
	65ChC+30nBV0n5kTHpqvXW5tZUAkDDg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NMMqPOgt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.63 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783465086;
	b=GatouUI0Fk/6o0uKhNptI1JLHkCXExoNx8z36FtGza0ZMK/ArQmabx49FWw/V1PvTey+BK
	bHdTYM413kyPSMJL/BopjsAd4uY2eMDlek/1mGtIsrCd+KKwYd4B19UiX/urX7moN7jO1N
	yhDL6xmJxOdlddYnUdtKqiuSxr2cW4g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5IbRRBu/pNMnztlx3dCr7wzEm1vHRt7//WQtX59fC4v+wulTzIAsEfDI7FFMjbLt1B2amZSpzXekBT3uTJuNc48W8iiwlV/T9I8C2zKPceA0Hx5OcW1PMtqA2d8vvJt2e+7jfNXIBCwcEc5jIS2oY6vYsyqp8kueeG7ZAEmLqEMEc5ILuspdYMOtwH3n4mgco1p0IjcjNjDTE2p70aDHU3i1Fel1x6M6WgZ3Yg3huJ6lr+WaCWJzefuo+2bxdmlmcazouWN7Fuwies52D3Ruzv5tKahkTNW71e/b+mWDK1cYQT1Zizz/gQw9I1ZkzgRg9NGj6qxteR4lXPwnV1pRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSwYgSCuGhydm7SW28wLKtBsLt0mY3QeTJHdzjtG+Yg=;
 b=GAUoWjahhGNiiDU5T4wlvGiVoZCKVb5dX8yTnEuTvYfuPu90SnX1Ff7Fa8E6lhVDVizbI02Fe35xO2379DKGf8rJT7fluX7z9bGN7yBaH32y4Zn1G4Rh+X8knDJdLa/8qGTJU5u2XKEmrdOGzylVMUeIEF1P17/ZhZ2V6soQKhq2FzNkAfhzNmdCMTWtQQ077i5GgedxOkEwlDD+pmCNKQxUggeBIqfPmBjGkcT3jDVT0o5FNKLhSxjy6DYHBT3i54dU4vIv7fZQlB5tPLbxFFlDfMCJQQCmNM7H0PwXv0A8rJtPbUj4R4Y+pi0zpdkpfRMD41RfjGaoHXd+DZRFYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSwYgSCuGhydm7SW28wLKtBsLt0mY3QeTJHdzjtG+Yg=;
 b=NMMqPOgtd+KzSI+xGii7jOxTTC3SWz7rufc6/AfOHduYKGA1/OWSiBmRq8wAZQeK9kdBn8rviPX6dEMZ3Lw6+NtctHhfKFn2aUVy21lEC3lcySyTsP67JdIhYIA674ej/C4PW3ZEyAgJ7z7F7NbWDRDNPVTz7V88793svnQl9LCaXKiyyjJ541A/imaiWU4vGmPKA4snUul3bHQOQIepZvj8y2G50877nm++E/5SKbpwE7xOpzwxYY5uxYIKlBgmPU+l3UEqYxo7PjgviSeK1qGh+Qt1m6TslS80r2yYs+XfLfP2ShXzzX83koKQBdYzDwUXv4ZLYd+zu/lQqyDFLg==
Received: from BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23)
 by PH7PR12MB7379.namprd12.prod.outlook.com (2603:10b6:510:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 7 Jul
 2026 22:58:01 +0000
Received: from BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2]) by BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2%4]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 22:58:01 +0000
Date: Wed, 8 Jul 2026 08:57:51 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, 
	vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Message-ID: <ak2DwhWUkk7lgeId@parvat>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <ak0FtLIlTyCo_8lB@lucifer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak0FtLIlTyCo_8lB@lucifer>
X-ClientProxiedBy: ME3P282CA0050.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:5::19) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB4995:EE_|PH7PR12MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c5e56ba-24ed-4f4a-c576-08dedc7b2fa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|4143699003|6133799003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	S9REe0ofz+bsugUIPRXChvhInO8s/NtkOSrZOiKDCGEeVVvN/ciaW8pWK1aaOiikDfZm9WbRFb6CUzcv5uPlR4FAVC7kTAdz7AflOUdQqLZrrB/ZH8uFZClueXq0Vi8ryl5aScmjf8lU9+51NLqkWlRtuOQ9aZvns+VYHxT1LN1XIr8hdYnDsrAijifSVWU/8WQZIbeTFdZo1jUiafzyEYW+SPM7r2Xxar+FzafkQ5ggPJa7VohQ+l+l88GEe0Z3Mfea5yhaCbCDLrWiOCxGosH6GOJ62bmt5oUdWNd4vDb+Me8eItUlpGHU5V8LAc9ZNuM+XkpqYrJSK1lTGYb4o4pu2/ikDIj/PTuqxxfw5NL+f/+oItqkIJUzK0fvE8/3Cj4ddkvB3qrW+JMDDaBBS4rT9uxs1BB3N7YdWzU517oRhYc1DqM7CP/ooWGWVodHc4GCbonoQOBKdUV92xKlCXrqfmkasbznLkGSFzSMi0NpE31ofJr/z8xD5UKNeN8T59qY9NPzNgTdJt9FnLY9sCmAlAxMrpeQMo8691xdWZw3nVS0ulmoHCOTjA2QTVNf6nMForCRpUgbK9yy1PiXR6vXERodtbplNSl4a+OKgXlLBeyMFUzqvf0CZQeHrU9A1v8xpUafITAT9SPy9sYwtMiRa7b24Kqy0DgVdj0XSlQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(4143699003)(6133799003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DjiPi9oracUWG4Nh59D5AJjwHfRZraQiZQbeuIAu0Xj3RIwW9CT+yJM/T8Ix?=
 =?us-ascii?Q?4Ugy1tvcH5QmBP7g04A4WX/TsV3NlZretsDBZQLIXzO/5pEZo5TXbYTwvCfp?=
 =?us-ascii?Q?T03yMFrBS/WGmG61PhwXaTWHhbQN39ovAu+QYsN0uiypeDSfgMQKAC2tAd84?=
 =?us-ascii?Q?D6uTg6iWMCAPN6mpegw7cjWGGTSG5jWjN9rXlhulrlCh8rvRt2W36sah8kcB?=
 =?us-ascii?Q?h+QoMd1GHqItwmKe10UXAQ75Xy2id7EvTrEckch8kocjmuaQS9s4A1qBktT6?=
 =?us-ascii?Q?KgKcNyOSWZYXYMjuVqC9n8kHETPD/uHtws2rGZXFcRwjy7EBuYk4ERWYgPJc?=
 =?us-ascii?Q?cnTM1hXdYOwA1BQVA4drzwie8JWGHlc4f6pxMjtpt4H9dkBrLdExLeCkP4tI?=
 =?us-ascii?Q?ZfstbnPmOzQwkwEDd4+mTox7LGujtBlQBbaV3rhhsUqrHXH7E2n2FgPWwrYN?=
 =?us-ascii?Q?pXwKUEOyUmDYcR6vX6BAb7AEP3q2WbYpV/Ut8BzLMEhHyxQf/FadxaYDtt44?=
 =?us-ascii?Q?VyMgI9JGEhp3ePHNZ7S9LHr0miBeU7zbs5nE2d3nKiqQyaeQBMyuNcW/vlLF?=
 =?us-ascii?Q?BmrSzPTPeYeTiINDLjF1nnEIVWR7bMtj/mJxNktKfutV4jMd9xevn67NpQky?=
 =?us-ascii?Q?PdmI4C5+TMOrYGiPRwFDC/rfiOFLo9jDgB5+CeigaswY2Loy+p0mkYE/Gjjp?=
 =?us-ascii?Q?s709zvkVnU3/M3z4h/efJcODdHUCoun6g10APk2IKGNSMme6ONQ9N2Vh1xSJ?=
 =?us-ascii?Q?KWfS+MXrNd2ngl9hocN1oyje+XhREnNelPq9ygRmSCtbUwMGQhhltSw8SsOY?=
 =?us-ascii?Q?5GnnzOdelCcdBvjACHTD8qfdFvvTJv31tYdrsiLoY4I5Ylwid7KHJFlYQJkI?=
 =?us-ascii?Q?D5VPlM4ZiqQ/yrqSd5ftWpyyEsdiGyMziayjuTHXRiRPjzL5AIYHwWgcCFzM?=
 =?us-ascii?Q?DRFtvyHcjehHGffQDLEoIRTgIQj7OKCbsP+Ed9ie6bMmUoJRE6jdtNiHZQvG?=
 =?us-ascii?Q?YbMNQYAoJjumz4SI9i8JWA1SIlWYYoqwUTuLX0cuk8rLUONFNWXYMPvhiUOb?=
 =?us-ascii?Q?8JEe4eorT6ENrlTb9kxXOmcy5RfSWTt1RPdtycBPPvsod4YLFt1iDlDJzXvZ?=
 =?us-ascii?Q?/0D8E/ftbBbigZKKwuHEfaDZHniHJRCoglkLOI/xHCVQwF0eoZ29efc6UcYz?=
 =?us-ascii?Q?3M9mv4L2L6KGJnkBklACHytJnntT7NzSVgCvs0CiAMF9q0odwHKK7k2+fmAj?=
 =?us-ascii?Q?ST92Gf4/6fXpCl8hn8oIDxW5q5l9KQamE6p32S81uBWlyBHt5cRUOnAjkZkI?=
 =?us-ascii?Q?5uQYIhTMTFZsLyp7YHdppReOhWQhifScvVvks6MjjyBmq6XowCvO7zu3yOi/?=
 =?us-ascii?Q?JbjcEp8JVbA1fhdMXPtdHlF30d50qDhDvEFpUMX71WMUIUSEp3Z8GojbIyyH?=
 =?us-ascii?Q?VVoMqrOPSu3hdV1TTi+SjzGXKfip1LsKwEJeUsfbC87aMgdKcYujABM6ksmD?=
 =?us-ascii?Q?7OA1OmvRxqh7iD7qB83oi37bsi6HIowxRXyr9XBiwF17nxItQnpRGq1G1Lbh?=
 =?us-ascii?Q?7XptwBpoo5BWMYuZ0UhRphz3vFjFpZs+fn+ZdIUVP6A0s9NB0QiU9AMM9l3k?=
 =?us-ascii?Q?1VNP1Gw7cfAOOZXY5TfhwlO1ZK4ya1tRy7Qvz6Gw1nVllouhNvySb6BsTp0W?=
 =?us-ascii?Q?/1hMHhhyRAUMhSTMGlr+tURcbjM9WzhtCYVq3ivmvpZgVM1NeRDBgid8xtF/?=
 =?us-ascii?Q?x2ZWSw00kw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5e56ba-24ed-4f4a-c576-08dedc7b2fa1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 22:58:01.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xghmvO6uNNUgLoYkLzoT/ZXaNUUi8EYEPh2qhxxYqSY5enjpHT98VmvDLjYiKwobxmyD6CxPZTSmEtDnrP/Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7379
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8407E180006
X-Stat-Signature: xrxh9d413ut98n7hjj3crb5ifbumwnne
X-HE-Tag: 1783465086-244792
X-HE-Meta: U2FsdGVkX180/IKoJcfp+jxfYGGRkCI1Fq3z3WIcrWlep6KBU5QC0IkOU3wBqmXnwc9G4ghUGKkQPUp+hBgvYMS0Rw7vcTh3xfpqSfwd5KSJnoUGUqXpUKdYQTeehgApeyVmxAy3xVkWdcbEQSfx8lVhwgLuJQr0VudMArppyOCW6KGfszIjBkOUKmfPm+o4mi1DpgwyplYVqze+YAzq7hoTc0cYj627Ccgokf61NBrnDCbM2kHkDqBc4DKt9zz5UQv2uxvuGqKxJMp92zH3vN3CZPykNUOCOUVhtAMQvXmUJ+nsAuNoU5YhZ5VeOhMSag8oJfqdCV0lJOK5DKl6L2cH8HU0F/dliMN2l1lm4lro3oXpGbeJqCRJvhMAJTwIK9Ht+IdzUmK/UNOzyQmmi88X2n7HEDiRQljdAuOaB/oNHgCLdHnNNmSe8kBFp5/yZyTIDN5NThQc+GzmAJJsTL63/fVhP3eMWj3wfQBoTQmMUb+HX+J/JwCTv5jlGAikETAKkg/bBngfMWn6FylOz5q3ZmfyTPb9Zw+1TxNLQMoTmoirfPhJI3xFGkttBXQtdO5l9OGhDhHc+SwnIO7PNT6yIxGgfCKTqDRlGISDmetV/D8K0f4vDxIlXvwtYzVhMEuEgx7iVjDcCoN1kcSyXwOhnJv05Rrwh3U6eoKlkCg8fT0JMvuRKxe7DG0/9o/RP/aw1rzPMBquHc8ng6MIawBon6xOjewBUFb0eRfx3Vo2v7CYfAaUxjEtkxQabybHgdYwk4lVtJljSNr+mw4q90oN82SkBnTQbbEhCJ1iedvyBoQ8y9bcxdNGvFxL63bouccHKhjnF8Kfhdnv0rKRRd/VyN+RzvmFOqJ3DcR87mDNXNrc6WPvkH579QiF311345v33mpVVLaFoneVSNaGCV+VZHqAcA3aKFj/oewQ1mq+3Am747aJZEj+8mNsNtmJSY9ECu25q7trYINSIW3
 2wQIAMWu
 Snyies3BOpzyEaoOqlCf2z0gBae5YSEekyAg9nS7ge28UtJehTbFXMbfJFHs+1t7sT9gHG569/nfeGWGYL+DXwRdFZwgaHpqtFflam+UZnU4gbNAdgaVnoUD1pwWgC157zOWcG3DQIOul15iDECpvNjbJD07dUAA6IMby1xLfbr1sKtTiJ4etIr5hUEwR9ZWz0gKAtson+QWxhMvL7ggkdX6wVhTM6b/FL/KzxYmBn759Xq1Ti7JtTmQ4r+KaYHs5cWcGj9slwAMrhNmsTLRdU4BDyCnmOHwM/2OsKkY9yKPfWq5e+hhQqGxQyuU17tph6KnnhKZEaPjtNkWNU6Ha9jz+xlrtVfG34f9w2pAszcaZdVdVpIMWUJqddMjWm8JejiIrIPYnF/IlD4SzG4La6W3yw9m86NNhCu9LG+gYnRqjrteW/YYLDMig5NiyuQ0KvErcbkdZ9BGPxgD1AKJiZZkQ8BzOK1lZneYkXNtYvN2LfO17PPbJ7bUaM621HSzZGxHLTlfGd2KXYpLsDp70yAtT8/0zTdCefsX4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 03:01:56PM +0100, Lorenzo Stoakes wrote:
> +cc Balbir
> 
> Thanks for the series!
> 
> I think Balbir should be cc'd no?
>

Thanks, my linux-mm monitoring has been largely skimming through the
list. Explict cc's are always appreciated.

> On Tue, Jul 07, 2026 at 06:45:06AM -0700, Usama Arif wrote:
> > Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
> > to PMD operations") a PMD may hold a device-private swap entry whenever
> > an HMM-based GPU driver migrates an anonymous THP folio to device memory
> > via migrate_vma_pages().
> >
> > pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
> > for any non-present, non-none huge PMD), so several MM walk callbacks
> > that used to assume present THP or migration entry are now reachable with
> > a device-private PMD. The results range from a VM_BUG_ON() firing on debug
> > kernels, to an oops on a bogus vmemmap dereference, to silently isolating
> > an unrelated live folio from LRU in the aliasing case.
> >
> > The first 2 fixes were reported as pre-existing issues by sashiko in my
> > PMD swap entry series [1]. Hopefully sashiko won't point these out
> > in the next PMD swap entry series :)
> 
> Yeah I don't love these 'existing problem' reports (distracting from other work,
> add workload, really it feels like that should be a passive reporting mode for
> sashiko not arbitrarily added to other series), but sending it as a separate
> series is indeed the right way :)
> 
> These of course should never block an unrelated series.
> 
> >
> > [1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> 
> Hmm we've had a whole host of issues with device-private PMDs recently.
> 
> Balbir - would it be possible to audit all of the code paths and proactively see
> if there's anything else that could hit problems here?
> 

Let me run through this and audit them. My usage of device private PMD
did not expose them, but I can see a bunch of reports in the link above



> >
> > Usama Arif (3):
> >   mm/mempolicy: skip device-private PMDs when queueing folios
> >   mm/madvise: skip device-private PMDs in cold and pageout walks
> >   mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
> >
> >  mm/huge_memory.c | 3 +++
> >  mm/madvise.c     | 3 +++
> >  mm/mempolicy.c   | 2 ++
> >  3 files changed, 8 insertions(+)
> >
> > --
> > 2.53.0-Meta
> >
>

Thanks Lorenzo!

Balbir

