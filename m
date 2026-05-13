Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48505CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BEE76B0005; Wed, 13 May 2026 06:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996E66B008A; Wed, 13 May 2026 06:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACC06B008C; Wed, 13 May 2026 06:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF3E6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:28:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3092AA07F8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:28:20 +0000 (UTC)
X-FDA: 84762021960.08.B390EDF
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28AF61C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:28:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cc04b7NR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.56 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778668097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Is9z6gXvURz4hFwlDVeE9C0Sv7Wyr+vuD7shqv5JnYY=;
	b=AT9ao7Jb2QMGtSkBkQuUUNIf6O/HypmIknXkohzEGVoVIjUkas8/Nmyju4fVnJ5UoPGnp+
	9zOJhlmMGmmWJXJZ46mGmk0d3xcj3YBK5Yf79CBlMB49/HUK0ei9x18ZFLhALGx3Pg0rBi
	ucQHOGSmyIZj1TFn2bpE/YppfWFVAig=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778668097; a=rsa-sha256;
	cv=pass;
	b=fWBeveAfAcugZolsGQrhJIjJOOBzM6NBYxXkhL/4bnuU/EnqXujidOby0IA0l1IT1mkMGi
	YtKXK2rI+TwbB0SSQFXBDtJnzL1PS6/nj6CS37/dKrYovewD0vXR2TG81hgaZkgnDMEMH0
	Kf1PZ7DUbX3HbIxFwQvFYzPMzQc48lg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cc04b7NR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.56 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+Ll2EqqRJefWvcM3KmjDWfC03z9iAQP1SGNHG4bsWei13/pAmfoAA25ljjd67cWN5D8AJ5ljMvwbBUzBqqLZ+fhSNYf3YUCBcBjPDAUju/zl+dQaWOSycQXebPdQXv3/lSnxftdDrsy2VFjrxJQMhaFobYGvARewK1do85Jox/HlD3CG2DxRPfjph3/VPpWVHWH59r7s5fMUjwZA8w2M6LbIDIf+aAvqwqSkmLSfcGvnq8ZddgW8eD2l0W+0G8wfCb0XCkINz2Fjuo23pD8k+7nciwYlbkRzcZ/K08UOoRJOkfPoVBx2Tis96+z0BMv2W6swVtJIK+XxlHiyok2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Is9z6gXvURz4hFwlDVeE9C0Sv7Wyr+vuD7shqv5JnYY=;
 b=mdWdSI0TsyeBcElMehU8S1qA73BMcQRDO7OgRZFNxUYgQ62LS5NBZp/a0N/5l3IZcN8cAfP+AXUyRcqTKTRJbkJ1KJgVgaqrmMYP51RThQtJ/z8hHuSjEkhb1AHX47T0DMCjFN2xVEWCEy+Xe/uV0sxKQqD/ueSlzB0Olj/H0/9UFtUg4ITNU/mjUH5AnHiiLOik3bQ+g1jTt22DPM/LyKtbf72WdgsoiGAHQEICJUySZrN4chUmr31zqckdoidAhoeCFuA6xyMlBb4GvoRw7vmTO6c8Cc7d/ktRHwfpuzJOOIyPwbNkQ6Z/vl5lCnRzwECZuBxQkBapqmGRilporw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is9z6gXvURz4hFwlDVeE9C0Sv7Wyr+vuD7shqv5JnYY=;
 b=cc04b7NRRp5JF4BsFQmBAObHvXyjf69eyq5altD0u070ZwEWtsojGt7G6Ia+eLAhnqMLNuhORuwKbdy0NixGdtuXJ3FOqx298e+ZIWPlUsX4A/CiS4BZlJzh9aaTw9CzcwERYILfkzpwufFyifKpbRC2EMp1p/jqZuWiIKEz078+c9b/jNG6UG9S93FWI3x9ftlQcJn0/Mo/fs4i/BhYS9Axm9C+n82oXxx0/EmkeEpTFskm/zbR2Y/OqixIRscc1jtN2xS74vCCdFXFl4jzSWsRVtTN4XOYoM+B3+NCGZbo9ODkRrt4K1hawakXoLQ7mBDx1fSkzjGbKOg4BnPEGw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH0PR12MB5606.namprd12.prod.outlook.com (2603:10b6:510:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 10:28:12 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 10:28:12 +0000
Message-ID: <a03c93a4-9847-48fc-b82a-2fec72a292d2@nvidia.com>
Date: Wed, 13 May 2026 20:28:06 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/test_hmm: use kvfree() to free kvcalloc() allocations
To: Hao Ge <hao.ge@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260513082525.154036-1-hao.ge@linux.dev>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260513082525.154036-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0008.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::7) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH0PR12MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: ea5e8cd5-678f-4009-2156-08deb0da5597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	I+3bN5Dah9bFMfxkrAf4l6SpObcyXv69NUjo8ANSk0c5gVQD2rrfHVTWV+GTNtREvuJXtci2aKbKNpero58xg0NMjA3cit4YKIxL2WZItahUyY7OrHBN2xoM061bEnxHehAt4eiQYJNiUWNhtNp2SoA3D9uCRB7NuqHjCfOWJHQ19elB8/y9fAtrxh2inHzwJPS05LVi1cwOYMGDf4lrV3AYbc5dA7N+wLQzXzTL4nFp8kWAEkOHc6zXj870uCGycLzHu3ejg9CX7C7JAEqBAWpYFy2z4VGemQWwiCXqM7LaCpr21izbvG1Ai5Jh3WQxRjPXEavAhEyypwE8Q9n8qoLM3geVBwWqqYq7wfyZ8aZN6eE28d3QTpiZ0E2mrDZiJughXUnw0p612XwgtlmU1n5bZHg1h6rqZ5yaHKscjAPGQ/4J/JIwuBijusNSYuiFGbEU95lQw2cj72+MHehk9Bc6Q5dg4yj2rKm/pNmDE3NFTDxEtPuHzZstCeOWjcQG2CvfrdVRzovaZo+FVDjcjfAJGJEJ89FoMDAm+WQz0TuKoJKRzGsAapScvcDgTDzv4ld49dUV+T7i6VPkjFcqPgjkWe9jTVORnH1MhSV01fy1pcg3ck+uBybeCrV6fA8/Fr6NTdgAO7Xgg1eKdkGgrvh/xk25oN1R2tXKk9Q5AHiKMjFBNzEQo7sObLivvsqS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWdDdWlKYVRJM2hUVlIxTE83SDVvakUvSlRYUGpBR3FuN2NlUWZWWDQ3bSto?=
 =?utf-8?B?VlVaNmlZMUJ3azFtYzZkQXR0Yld5Ylk3NFNYczNYdjMrWUZDL1lSTkU0L2Z1?=
 =?utf-8?B?RnE3TTM3VjB1c2Vac1VJREE2RkdCNzFqZGhoaE9sMWdHTDRFay9neDRYMEJt?=
 =?utf-8?B?UjlaV2RNK0R5NFpTbUZOelRXYUpxeDNaNUNpU29PWVBpZ1YwTVlMK0FSaERm?=
 =?utf-8?B?d1ZmTTBEOEgxTFJmcWpLZkQ5ZFViaEFIeTIyWjhmVFJtUGhReTh4Uyt5MEp0?=
 =?utf-8?B?amFmNEdzTmRucjdqdzRROTR0V0toVVFFV1g2QWtlYU9CLytvQzE4c1M2amJJ?=
 =?utf-8?B?NmdXajlLZ2F0MXVSLzF2ajF4QlgrVEIyd2NMYjFuVmRLMVZsZW5GL0RNZVRG?=
 =?utf-8?B?RVl0UTZrMm9ienRPUnBtSkRNN3pXSGtWbkpBNVRKdmVrekRvb0dKT29ndzR2?=
 =?utf-8?B?eFJqTTY0b1lCQzhOdUVITW9OSkNrSmFZcmoxUjBEZ3NXM0taYVl2QTc3QlBx?=
 =?utf-8?B?cnVsaHpDNzd4ZUNpUmJDbFRlSnQvbERMS3JpSi9pR2pSVmZ2cmlydVRXVEdV?=
 =?utf-8?B?YWlxc1pTVUNGMmI1QzZpOWhYemhCNFdwUHN4MzdGQk9iRW91Y0hMM2xSZUxh?=
 =?utf-8?B?UVBzeDdiM2lhUy9xajFOcGx6aHZPRHdycER2R29BM09lQXVSNUpORFRORnZ4?=
 =?utf-8?B?U2xDMjRYbXFicElVWVNnRXN1RElQRzFlSmRxQzRmaVNqcmVsUWI5eVd6dlZF?=
 =?utf-8?B?TmFxdFl3TGxxeGUvc0ZTRUs4c2ZQR0x0VmtCbjc5MHNZMEZ2WDBvb0tDbE45?=
 =?utf-8?B?dHJ1QVZUMWkvRGZ5eDlyU1ZXR1hKczhCYjNqclpBZ0VzdUYrT1BpM2pMbUtI?=
 =?utf-8?B?ZDBMUzdXWTluSTBJYllTK0hWOU4yT3YzR2crelVmQUZaaDBHd2FWNG1ZL1Ux?=
 =?utf-8?B?R2x4Tkx4SXY4SzF6SFk4ZUwzWFJMZjdnaGwwQnRlMTArb1E1MkxsdUE5LzVy?=
 =?utf-8?B?aVNFTGZDd3dOT0h1bncwUjBPRDNoYlpUMXJzdklyaU1UUUluNWZhdTdETWYy?=
 =?utf-8?B?NkNDL2ljVzdrQzRVZmlUWG5KTXpoNFBDK1NlM2ZGRzRUTVFBdGswZWJWb2M1?=
 =?utf-8?B?YnJBdGh2c2x5N2h5amhIZmRBMW5YaStDYzdreFB0UWlIKysyZDZoMkxzM1Z6?=
 =?utf-8?B?NiswTmFDL1N0LzNlS204OGhZcWkzRnUva3BnZHJhSm9MbWpIaDlwT25Ha3lE?=
 =?utf-8?B?NjMxY2FtVWl5eWswVTZ4ejV5b0E5Y1djTXBFQTFFUkxUL2tqMnl5cnhhN3J5?=
 =?utf-8?B?T3NaalNXdU95aUh5UDRVQzlwVkxMVW9Ga013eFN6N3lDdStjOCtNazBhZzM4?=
 =?utf-8?B?NS9mVEpVTGwzbGl4bFZiM3pRbXRjVytheTJVWHl6aXlIamRDS0dQQ0dRVFgv?=
 =?utf-8?B?YXBPODd1Q2NFcktpVEt4VlcxL014L05GQk1KSXRHMjh5bFExTDBkTzdvZE42?=
 =?utf-8?B?TnZtcGJza09jc2o4VWFYRjdFelhMM2RKaTFUT1BvRnM5dzZxb01mSzU4N1Nh?=
 =?utf-8?B?SElVeXgybnJuNmtXeDBSeUgxWE9ISlhCMHpqRXhnWnM5YitBNFBrdkV1OVFO?=
 =?utf-8?B?NGVEcEx4Q2ZjMjFKT1dycEdQUjRyMUIxd0JBeWdEazQ1VXdHVzdUWjVmVmVi?=
 =?utf-8?B?NytvSlkzODU0a2ZSMnNqamh5c21kZ0lEdktQdXFFMVlzbG9JWkdjZDU0R2Vu?=
 =?utf-8?B?cVYwR2lmVml5T2dzY0dvb2xxTHJDVU9VVXA3dmlqZ05lb0d3WUlXZDNOaVo4?=
 =?utf-8?B?NEZtbURkQVZWYWN4NmVJMDZlUm9aVUcrRXJMbkQwUDVURGV4RzZYYVE5UlVx?=
 =?utf-8?B?QW45amVJekdybUM0R2Q3VDJ2Z2NYVWkrL3BTRkpWMkNoeDhmRGRkZmRyNnla?=
 =?utf-8?B?RnVCR3RLTU5WTTNsT1I2eHJVeHE0QTVCZjQ4eExJUXJCRytxRk9zUmY4VUF3?=
 =?utf-8?B?WFBkOXJ6WWVLNS9xNkZxU2EwTkxOa2JsTWxVSVo2Y0dTWmNyMmc4RkpVTUM3?=
 =?utf-8?B?UXVPVTQ0QkgwVlVRUC9oZU9nTVdYM1d6VjFwQzRYdGRoQ1grYmE3QU12L1Nn?=
 =?utf-8?B?WHlWTkEwb3FQUmtDcWtLdHU4cVpoUWZGb3hYRXMrOWRHYzNJRVZleVVpa3hR?=
 =?utf-8?B?MUVRclhUd3dJMTFtOHVGM0l6dGg3ZzJXMFJWR0pyT2V5bnRCdWhmaXpkTHgx?=
 =?utf-8?B?OHQ5OWJ4TGJVVXhjemhyYjJnZ0lkeVR2SFQ4T3F4R0RIWUhlNDRvMmd1eFp5?=
 =?utf-8?B?dm04RkhNZnZ6NHhHVUtSQ0c0UVFhK25JZXFMUDloSmZHMndCRjFkZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5e8cd5-678f-4009-2156-08deb0da5597
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 10:28:12.0086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z9ojvdHSqfLzLh7FqB+Bg9rKIEiXvNJWeL8ZsMzlzAF1eMwMrXHC2En05GytEva3TlDiMh8zdxNIUGOF9FmWXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5606
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 28AF61C0005
X-Stat-Signature: zk5twur1b75q1r4cc9h3ibwfjo5hou6h
X-Rspam-User: 
X-HE-Tag: 1778668096-333253
X-HE-Meta: U2FsdGVkX1+svQuDhXahQQIm/S2L9BG/yOaDlG+VtmWXcQsCtYMe8PWTIMJOGeA8FZ1YVP5mXwjbWoT/Bhp9oD5R7jrJGKBMQh7JCyQlxAlQ+wyHSfnf2xSID6ZeK37DSLpTTyYgDnEkiDUP0TgBrkqHEOZYwH8DKPHvWSfqMmTnUDyWPN+3+fBa8UYkJqtVo2GXOdR8gxnAu/rVB5EIqm2PN83dzytl75YGTzViAuKPLozKNoKq20Qc19MyPwevNb4x7LW1KeZsD1I7ERPllAeLnkhOmf83BTXIi/UOzG+dyoCl0U1hcSafkJ2lnf1cFCT911bfOb83ct2piqn5nWUpEU4UtQhomIlNVkK0KgJZk3u78CvTNAXk9Kst5d155HGchIfCi8Kc1OzAx8GqPCu3KhlCcHfa/i2B2dIruVrGYu5E+1quTe6+WiXBAWNrczLOuuH5dDwiDoOiumX8Wwo9WJsy8wU3uVEMHz4lsvrTHx7VKNBYfZIDTzLiQH+h2ytfuviatLferWzGGpw6ERHDxW0fJw9/aB/NLbirRLZIjlApI/d6+y5L9NjH8MUxR5LoOdIXtGkumqWf6hy+RDEWZgvSsyW6oBxM5X42mxq4YjH4QcKC8B9ZYILryoYUcgROKWxkNV0rYoQZB5FSTSY4lKB/Sks/LIMi79GgteXaQ+qElxrvl1hMR+CaRuGTIjZNLSSdZJlxyekpD59yg7LrctZvRqRQiZ4UlVzMm+W7OZHXzDQ17OLOmgxK6YI5Ln92BtyUBRABqnAuabGvCSx2rkA67t5vY1Ji297OgHd1rSYGINqJBAr2H1xJioinCegj1S6ZdOeNT/6PFHCvXCUKqk0cypQFygHqqA/BvX9eUxkhQQ3xLuctppvxuYzAppKewg3Z/LkED0eANRxASwnIvZuZAxmIAg2hGsx7gBsEqaIe0w1Ba9jRqhJcpoxC8/1H6SbFNxS84O1aS41
 sPArB956
 PXc7N+eTAo0X0BGHr3r/JAllUQTPkHknZSePd+IugWZnohen3SHX8YSEcxBq41RCTaOrwT+7C0xyQsHiCNKT8CH757LQGNCxi7opA0OjQlsdOWKmuQsq2CGPTTh1nrHjq774X9RWVnUVCLSdGlqYIFD7wwFk5aE6iOEio71HeEcU8/doWQa4yRleUb1vPWJ6WvsZrDRnUpa+5xETSsnl/beZeYwG2wlS9OXUEmKlm80B0eSq48i42viLtS70xCwGFGRkSH2mcvMCHa6s7RpHaPdR/7IzJuFBzCbanbC0IsnjaIAxv8unpgVNW5uKw94N21xdiPhUvfvtsC5fpv97QjEjBcv+S05HRvM4J7mP/Ru5uHsEaAs1puy7jquiBgIzZs8k82HOKoxW3IWlGG8U7JMcG1llw9V0IcT0sktXgOGqMjATmAeUiNDX8akkZutuKJUO3wzGrJEeM3L3HbJA5G7CUY/5CSRhTl2tu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 18:25, Hao Ge wrote:
> Coccinelle scripts/coccinelle/api/kfree_mismatch.cocci reports
> the following warnings:
> 
>   lib/test_hmm.c:1256:15-16: WARNING kvmalloc is used to allocate this memory at line 1191
>   lib/test_hmm.c:1257:15-16: WARNING kvmalloc is used to allocate this memory at line 1196
> 
> Fix this by replacing kfree() with kvfree() to correctly handle the
> vmalloc() fallback path of kvcalloc().
> 
> Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  lib/test_hmm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..38996c4baa40 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1253,8 +1253,8 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
>  	mmap_read_unlock(mm);
>  	mmput(mm);
>  free_mem:
> -	kfree(src_pfns);
> -	kfree(dst_pfns);
> +	kvfree(src_pfns);
> +	kvfree(dst_pfns);
>  	return ret;
>  }
>  


Yep. makes sense!

Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks!
Balbir

