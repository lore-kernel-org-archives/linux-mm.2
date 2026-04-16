Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B26F8D777
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 20:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FD96B0005; Thu, 16 Apr 2026 16:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0D86B0089; Thu, 16 Apr 2026 16:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6806B008A; Thu, 16 Apr 2026 16:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1976B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:30:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E797213BEB8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:30:24 +0000 (UTC)
X-FDA: 84665561568.01.8E996AA
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38AD41C0016
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:30:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LfZNdSU0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776371422; a=rsa-sha256;
	cv=pass;
	b=0+JIrCVJz7Maa6a0zpFahT0PnE1Ms2XLiqnqzJBfYaK4ksZxTsKU3NY1Hr47cYC0p4Dvel
	VV9Di1l9LbY9d5kHjFxs4lpAs82thcHWnhpFQshMogaRmuv+CfWtFJz9JzOgm4rKeP4Ox7
	30DnTIe9rVelmHngbaSiiCXz1fzJQXI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LfZNdSU0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776371422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsfDljdVp4FmAj0zexoOHXGaEexDd9av/t1cEUNF2I4=;
	b=1YmFvVDBZe2u5RWiD5xTi5SUsF5kyN0dg2otbI6IL3P/1n+Jf1MP93i0gH8HidTAgByGDE
	dXaBl2SysJwVRjgeAxb0DZ52UaSZ+Rip22vJRRuh28JB/ySO06Lcb7ogqHC/y2E8GDVMuh
	7fltsbJxqypaJW1KtMTVPz37xZUu+vM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYY+nkxBMxMfhMQzva2UjkPi06L81hvEPlUsHAovP0pOtdChZjCLVuRwNu3GJl0y0GwHlC5FsQnPVRS/iMMq4p4BQ/WsLHT/QJekAvFP3rtsTgRqzwVF5SvIrJ/hcuphCv0CIV3YFYlWv38ExbpK6vcd2waQfhQJi/dUHtP6490PO7GxwvSiza5TYzXGKOWlHcukzLRRJHxbtSn3GiCM1CHxNS1C3k9Lsobw2ySHyvN6tnWS2MYCVuQcdUTPaXCb8I23QEq1lgxKKwXKv5zbT/ms3J7JYA0HwrHFa4aw7AUPJN0ZVOufkWN+9alp8ybL3FsJ80FiPi2Q6jXlgyZnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsfDljdVp4FmAj0zexoOHXGaEexDd9av/t1cEUNF2I4=;
 b=xn9elGtaFj9nEiMBO3r+ZawwWZyO+ekns3/N6plWchPIMQlw5nhlHiyslgYM75nhp9Z1DeFvG17MxPulhr9oEjMio63iK+/NjA66eVOFTnFERIabyK5QV0VSrf95tVZax9uaAq2CzOURg0gZfzAPX9W7bMuUJG0BsfHnBf6SyG4gd48dpePPBkgZjPm696VWoMcrV4d6nqEWHr4GYE12XLJ4DseybdmZQCnr1kWzBrHke2QctT9T+JMWiZfzsCxbVErVJbRkWd3RVIqq74MR7feYKZMrLgDyDqBradlu45PipjcyCJko7qeTShs0LpANA7RJoPUBObu0s95rb06mdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsfDljdVp4FmAj0zexoOHXGaEexDd9av/t1cEUNF2I4=;
 b=LfZNdSU05R6WtCb1p/btOFtxLKJkNTqKMb16bKsytFflpGQKvKvINDi4w6BMbqz/f51FzcntA4wLa9trpweEVve313CdhKhB6rpLzlDyfwLNnwT2EnUm89iwVoZ/B3WnGCJbZFRNtk7NocLgPhEjEOgjpPE6qnqszE3TXVp1II/poXkkWkjho9WpjFnl01hUcjQd18l4/HxOY9yIi9BkAeMymGXZH5WqIrF3ibF6417rZF+SgyU4YAdIOD1SeC28uoPuXcozDFeb40QT3X7V34QIpktpj/WqLX2a9xwmjg6wZNB+Xopw9zqhxdqtf0v2hwxMN4pkRUxWNhFb2/Nlvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.17; Thu, 16 Apr 2026 20:30:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 20:30:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Thu, 16 Apr 2026 16:30:12 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F134AEF0-A71A-49AF-8C22-A06C9A3CC464@nvidia.com>
In-Reply-To: <20260414141344.29949-1-nueralspacetech@gmail.com>
References: <20260414141344.29949-1-nueralspacetech@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc64bd9-7dbb-481b-ba71-08de9bf6f797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AZJuPa8d1x2WCBuwcJiBHd0KI8VesSPS+boz26Tc+G/5umckyURlANO8HzxGfX/Fuuli+YD/AlOH2B2xx0Rtq5OfMQsf3rHYOYaMMlXfYBpVJHiG+NOKA5c9qLeqBSKP3XgCiX60bSUJRauEmkCih6Sd6efW06R+My/haPJqs+bSnBZMJlrytqmXIec2NkQLcujEt9OmQqgRJ0ZEcILHYvdUIekjpJxo2MPGOjDbkfeOY4zGc8e9UOo40dLKg1HtxUk49wMZZQjrZH7UhBheHxcldcEfEy1+sXgXZB5XClFurUAIJHmxe1Js8Lu5ZRd1cYb3UO3FYfwtbEyPqsnwNSWyfe7GPCrVKaNQfUTHVcKMjnNkZ9OALRmmPqcP/YFEmNam5kPrDnV+cfEnJPK/HcrNGTRmOtxyxshvPn5JKspY4UFfh5Hg2YY4AmkQFkK+EbGSRgle0QGgruIb339o/ENc/ug6BBaQgfJlkOfhWGR7zquvXNgmQclDBTnYjJYwM6Xn8NljicEk59A0JQJ94bj7ErBmMJN/79sJrzYLqmU/ofBn4Xvw6SP3Ubr9r3jyk0+5JyIpi/UCGspNmGbA3MtMwXEL0tnn4ks+845rg48Xsnls2bgPCIcNw4/5LwPUOwGTI0f+Xze+wFlU9dnKhqc+NBVVk8ukfBt8u3C8yGXke7vfEwScdGaKwNTabkiAdbVceXwdTvFRLZ8iR1up9t4yGG+3HCzqb4UpfkKyGl8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RkxK+I+igBPuqxLiB9deUseEbOmAZqTulkMCDVrsdKriRyyY4SCqsByyQKv1?=
 =?us-ascii?Q?m/VJJmbtF/cdkqOAi5fJtjeI315Yj6ufvNTzsRTTqetfmBybXkSWbUuW3ovQ?=
 =?us-ascii?Q?Vu031O8bYNjih4s0Zxt9d2wqeU6vBvvrNid2NPQZpGnsz5Xx/pUcUxkAyS/I?=
 =?us-ascii?Q?ijWPc5py3jTDdeSfHcmxYsxOUlUfNdQ34UQLQ/XmO5Ki1boEcyucXXDVw2rL?=
 =?us-ascii?Q?+QzkuWUsauKMsvFDug37vfTt2C3HXtVtatrNTiVc9Owf2PDcfQLTu0j59YSH?=
 =?us-ascii?Q?6JLjJOjWZVAtJg7ZWKqYYPd7fdkal0qMAFPYcsYnaCsHiB4cxkUQixY4SpR8?=
 =?us-ascii?Q?94P9lhlxOJ7BN/at+0joTIj5LMEiCrEIlG2DC2F4uHLKo0C+YLgcGoYA9rA4?=
 =?us-ascii?Q?tV9PhJrri+9D06zYfTBeZpJ1S/doH3k/OOIZASO70fgNZhZ2u9OReFFm0dUv?=
 =?us-ascii?Q?oEalPV93t8P6n3TMg6r2adGsiUnv5KbmOrtNE9ZkjtR5n1+mdaOfD3aV+/c1?=
 =?us-ascii?Q?ZIphOLFRd2jPYqwZd3QHztUHYTsMUr7suqSaPvTDDrLKbShZkK96v0lX2shW?=
 =?us-ascii?Q?lGZEpoLFAlmET9l3o+cuFWtHOmMxPDbczNvlchind4vQLnyeXNGDzU5qOsBZ?=
 =?us-ascii?Q?tEEsRq4OD7MEAlX9Z5vDu32HYzQhbnxsHJtgNLtTmZa0IZWIH83W1CLVBn8J?=
 =?us-ascii?Q?iHdYi8c0AHcxxkr4FS+nSgSA19dpKt5JFSewgBXXKfMF3i8T2gmX95MIHIVO?=
 =?us-ascii?Q?c48cKLmv6x0xUDqedIPT0wAbhCqZYllwakBw/eJZso4OprujenZOJxK8m/Zm?=
 =?us-ascii?Q?B6IeSgYNpwxAtCD47SP2FtP+w0enexlHT9HyJTgz7jSvSz4JpS3Sj7JQVG41?=
 =?us-ascii?Q?QA7OWqSbu5XErkfj1TnDrrPvuK9AXSTrWb4g4OxqgsiDErsivrp6aHCJA4ar?=
 =?us-ascii?Q?qZ6MYqywA8uuiXWFOo2dUheWVkjRxerYFWOe4MmzD7s2wk+IY2dB79m6BFKQ?=
 =?us-ascii?Q?rVcgOzMsJ6vV4vdLWcOlkSiYyMOZI6H0Q1XpGMuZMM/nSLtnFUIFYQ132/kW?=
 =?us-ascii?Q?p1swCSBqOF3VEchKIl1+vT7O7YmWXC6LHQaux2H/xG28YbwaTvYeYXFkdVB6?=
 =?us-ascii?Q?m1k6NZau3KqknkDiyDwE9n6y9uK4iRc94FB7KzeEhrlHV9Jb76Voc9pf7jpj?=
 =?us-ascii?Q?vcWXire+8OaHKqwdaMIZuzMEY4XtKQBP96x3JhqQKtoHWcl2XokTFFOG1CNx?=
 =?us-ascii?Q?k0M+xmE1bosSJSyOTEqpZLlNeEg1U+6j5IfIueGwSa7f50uR+LXmU/t7DoxN?=
 =?us-ascii?Q?Eru/1ySZd3TVmfUjSSGeR3mZ61YYYItcOPyMdUi0K01/NG9wJOe0Qk/NAazz?=
 =?us-ascii?Q?/CBoBrb9Q6NQsrVi2T4BNw9Cj9ORYAqW9Lj+Alm876vdOUMTaDTOrxidC9q8?=
 =?us-ascii?Q?AdnGnR2lA6bCcwF2FB5FNWoNMSYQN4CfuNO85K0qIf0gnEm0JhuOkq4ppVq9?=
 =?us-ascii?Q?yWwogo0yTZaXGt4Ba0kGw3qm5HTMCnjmZAVMR6Eh6ZD8lZxCkHuUqQ6QXiXK?=
 =?us-ascii?Q?hc8eoV72sXnfSnKshufp+SPCGetrWI1nrEQHvNJ4lij2zoOiQ6NMrTXYaumO?=
 =?us-ascii?Q?cfEhqGA6Vfu+nS+vc6I/BsH5XzCnm0i3Aa6dKvoxZ5NkPoR9JY22NPkTRPAW?=
 =?us-ascii?Q?vaffiYoyB7SKs/vpb0TwsNAUrzl6aTeG+BrJCDdyEV1XmIu+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc64bd9-7dbb-481b-ba71-08de9bf6f797
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 20:30:15.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGh8RxeL4OOzhmsQz9NuhD/X8l2ssbUcAMbgneTj88mzrNuYRJ6NCXw2jbLvHde5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
X-Rspamd-Queue-Id: 38AD41C0016
X-Rspamd-Server: rspam12
X-Stat-Signature: ahobs96d4aoux616u4as5okjfzm416mf
X-Rspam-User: 
X-HE-Tag: 1776371421-513419
X-HE-Meta: U2FsdGVkX18ZKfRO4AGkqdSW3DIJ+WQLEZfSeT5Lz7FGp1RgVf8+psnOCCZz3s/cWZ6VZUUF6Npo79z95xWtiMNcfIzq3toUkZdIGQpMRoOo2t51s7p2S0EhFZuim1Ra/DKPtM7gi7XUS5JaZn3OamCXSrNjKacBJEGjkicaVXDuGhZ38ZhCZxQsSYcy1RSZyP83tvOflBJQniKOSfDIH0Wpmf4T5EM9zusiehGa0U7uymSiEBnT8BaPFMpww3vXkOk6rxV0w50XxqOwPTQThAvZJnvcy45dG79TsaZZZ0FwufyJemOs13Dt0D+VCCvbjs8FYKMcHlREnO+pbpJYvPcqxoWPEXqpsJ7+jbj7EVlyM31s+2qiJ4bQHMfXpSZSEdSPNZgTVHyQNkgSgFZz/1HvItVqKWONzfj0IOcgBkHfCJKyGY81MOSIlcMazYq1FeA7C/4WCvNql6joxg86N1KUR0J9cLYUjO61mFJnka421LMFDNMW/NVWpjRS2kGsPCMCNLCj6ZExJqw5OSXnqi09DmxYquNnS5rqnWW+MjAUPfmHptMf6kSW2ngcY7o8uwlpWJmvRtamKjas68Ch5vZQAHn/TJu/jswJ6hHh9oM0DlXw8e07QsBiIGQu3XHTY8fjsbxqxQWswhTQkVIqSYS+22qzaOq0DiDObQQh1NzSAoyLEeub0VdnXtHdEbmhYks4p7gpUZHfvDa+5MS7h7Bwq0+8WYcP9Oei4CYtIxgYb7d8PcRgr3KxyJwCUVPdQGCLFxMQmx0gJSHbWZneI8SRIsDtoKH3lf7bne5VMLaCYJE6fUnyofPB+KI1l0RpMMnIXTmAmDmiS1SZ/4nxAoryja1vvRyjFG6mvQ34e44xAXRTytnehrSALmlGeGtwyHQx+yspPJkeW8PGoGa8we0v4k225Wg7pJsyndw56Vkb4Qt/jyarJhqIYQGBnYu3pZeA2W7tIfr4CDa5wNG
 R6aW3pOo
 vWut0eyP7T0YdMGNMmEnO5JyEouUHmAa1Ps9xpNE0Yo/JKCjD/XyTJedZqwbcW2z0Vbpu70ODlO9cjZroyrZOBp00NL115YvOLv3tgLeaYZTbteweHZxLy3EB84QnuWpJmEOXtJvXQnydTdRXPNyyCJgLt+0sDrBsc+oo9MNArNUdvmt9OsepMD+22LzBT9TeswP8Xr3keQuPacN7SaTZ5LPzHP9zmu6fegWimLxC3m9WQcIR0lPgiEZcb7ESkFrRwE6vyZHDbRsLNPEJEwHZaryKa6n1ea1nlafhgyOngGICImkjVdv5iCEgC0aFamhI8Wgj6Ml083HktTJLtjsqywaRJ8oa7toxmSi0yL485QsWU5LJe4SNiDuUmGXZl2pLdbR0jr6snr2ZQumC4eqi5+J71bIpDjqtKAv3N2xBa4uqJS7uy3jWH+O5l/IG6QfH0bkgdZqzXO7Vaqe3N1LF8SI9gnUJk3WHwxVtjf7hJt2D+JU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Apr 2026, at 10:13, Sunny Patel wrote:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
>
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
>
> Refactor the PMD checks to use pmd_present(), making the control flow
> clearer and avoiding duplicate condition checks.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

