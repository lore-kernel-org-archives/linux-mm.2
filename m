Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F7ACA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BC08E01CD; Thu, 14 Aug 2025 22:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980918E0002; Thu, 14 Aug 2025 22:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A948E01CD; Thu, 14 Aug 2025 22:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70C418E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:37:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44FC6138AA8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:37:14 +0000 (UTC)
X-FDA: 83777429988.01.05419A5
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
	by imf03.hostedemail.com (Postfix) with ESMTP id 666CA20007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:37:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b8Z+TWD3;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.79 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGyVDG7fCSJjYp9nJgoq5YT9eDtYs13e0Ky6mQxm350=;
	b=0zJPC//jqEYINrMKgHoVF7C7etPuT8NlF1uz59F5c2Ar6HQ3NoUIdIPyq5mr0eAxolseFY
	FaDUkeXvwPuuxxJF+uVittevHmVZv9m4I6+DNaADnRPbi+c8MuZkLmQQnK1F//TviKfSqT
	T9mWMcLQS31YNEv5va4otlSnqu/JBTg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755225431; a=rsa-sha256;
	cv=pass;
	b=KGsxB9G4IydYrzDUNv4ny+UcoTDOmld/8pJ/PSQRsuKa5sskdxhjpXqNVtoounkfLOxCpf
	4GNxHUFYPUVQrWV/7sn6c2Zhm1nn9FeJIt1bIDjXPTPcPYf11lR32UhfECDATvizsjiZ08
	O3QmfL9+yVBnyOI7Y+y7YFGglFswlFQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b8Z+TWD3;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.79 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VrbY/R7NSujf+nc8eGvY2djCiuLD2j2QJgDltFfsK1p0rzvPBZkLHZbtvcUoK/c6R74uN5vMMikHXcqnuC0+bbNN+pXLX9LNxWVFe1BPFwQwRF1bte+n4md8OHhQCiGskRDh3N858y7buBGGoQgoTmR4yhy3EuVlad2C+JQ/oPO2nCDgGEo5v46l9m9/knJzshTMTg9uPicQlClPSk4N7Y2shEzvlGnYEf2+EOzBzWqQmPOqdwDdD+V3VbSlHYG86BSbSNrH2XeBqZLx10JdxplCkP9Zv50s5ZSQx+YJP+TcbPQM96nhQdHH6w6axYLqev8+N0DtFbAoTCXlF4CE4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGyVDG7fCSJjYp9nJgoq5YT9eDtYs13e0Ky6mQxm350=;
 b=Bqwvs4eD6vr8T0LmqKJrT77cd2U7jVZai/ZgUWudTl1keii4wOBUDFbU+hVciFdxJAhX5AZ4aRE4sS6iQMJgCeiFBZ7+u+noHrXySZiZgbo7dFmfAzrHDpBdc7fVaaClKJMo9aWUZCxeT8lv+hSTcxf7eEOcaaDidi2cFFN2NUcs6348JBRVvB8n41qIZqdVESNLGY5jzGDfY+pSmfm3sKdsntyDYxrlnObvnWGo1e6QSr8bm9/jIBeLTtBKUKrnRLYvMWfgLRusjple0AiieSp64Zm59atd+QwVotOnT7t/QZVGDP45pU8othA240tsGiXAWy2eM8vzwMBK2KQRpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGyVDG7fCSJjYp9nJgoq5YT9eDtYs13e0Ky6mQxm350=;
 b=b8Z+TWD3P66NaqLZDkhOnx8hdznZ/IlFSonBCu03o6Z7jgkrVvFiiGtmCgMMW63PqMC/tCnYHjFZK0DLd8jPnmvlixmogzP0uuszukNe7/kFIJl0Bk42c9CQLYlbiuTr9/S7BJAO8F5JkkM95qMa9SPYAhgp0UTeEPwbK+gQJeY+NOBEUQguBOQ5FN3HfV2kdud3igSVRwA/KIBl48BWcEsHZHzmANtHvbP/JLTE1ioQPaQg4RrHCP3gPRCon3mwKlEqKe/c98z/wkD+jnu1G/zocLLP261qI9OZD/BBZ30YBVTuymr18yHA8x1XlW0RaGPYb/tPy5WChdIfEoUwJg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 02:37:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 02:37:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: simplify lowmem_reserve max calculation
Date: Thu, 14 Aug 2025 22:36:59 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E5434A0E-3125-48C7-BD25-185CDA4D9FAC@nvidia.com>
In-Reply-To: <20250815023500.36893-1-ye.liu@linux.dev>
References: <20250815023500.36893-1-ye.liu@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA4P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac6b8f2-c9b9-466d-2afa-08dddba49d4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Krlw9pApdyIu4EiTx6yjbhgk5pyWAepLanGNgayXxjfKTzvu8ms0S23b10vl?=
 =?us-ascii?Q?QZK7OuRYGEkzZfTziguhZPNrxLvr/Yw5AN7Rv3axxCUUYYM1V1K8z0mNwimw?=
 =?us-ascii?Q?ovO5XB/d8E7jMLW0L6y57Vyrnrby2KXFB7p5sQ/zXq9DFK9GSyL7twOBJPnP?=
 =?us-ascii?Q?tPSCV2uFJ9V+Au7YjdUKkQi6GIBIoiVhykesHHwbn0IXJXsAo0WSpVsqay9i?=
 =?us-ascii?Q?xWj5J7jg5RDKqhsfyXD8LOIrcp5xA95vUjC6mVGf9tTOZfjNksDIsTIK82dc?=
 =?us-ascii?Q?c4PNFYijrtgZDzdSqmBfsXzaFkauRDDkaqJKoPCtmEgHkT8yAQDSoWgGh5BD?=
 =?us-ascii?Q?uuTZTWaU/AsN9gTSXGtwPaUJ2UxYx1WVY213zWMqhBRJUqQna9XD8DTaak5Y?=
 =?us-ascii?Q?KQM2n2TrblHpp+6r+T6yyfv5fsq2p6qgiQBgUi2oql/XRYoq/aNmMlQ5mlNf?=
 =?us-ascii?Q?yRLjfo+fl5YCdYFq3N1r0LZQhs5FtWTV4pSU+eduxUfuL1PO6LeluIGzDUwE?=
 =?us-ascii?Q?OgilD5u4CSXL3Srqu2fV3Da/23gYol8jn26KM8CCDbRNC9H91eaG/nOxv9zO?=
 =?us-ascii?Q?z6RKbduPXXs+MDU9W5VlXirrl91vB3A1OmX7PpGN3URTo4JGtYHsBBCmUX44?=
 =?us-ascii?Q?6oRcQt8hphH94p7+Avk4I21sJD+B82QhQSxT+onVAW6b/Heu7pW/OBCV8gZw?=
 =?us-ascii?Q?tC8YJ5f1HdIO3QS8TlRaQBT/z6p09xyERM4zircZAShgcIwQNiBghWJET+5G?=
 =?us-ascii?Q?JwD0lLZxpmqsqzT0EBeyyEh+a+5EKHVqTBLUsma2XXBwXoFC02iXhJxY+VPO?=
 =?us-ascii?Q?S6gvPWLpuph154jO4ycHoZ1MjiCW5AueIE93GuJzZz1Us/qWgdmkVbjkq+EM?=
 =?us-ascii?Q?KlxKbHxD9RQOjPVOYhG979HJGtApD/18xFcv8fCdZ4nr60lu/whlGw2huM4K?=
 =?us-ascii?Q?/RthofwchkJFp/arSvQ4d3/gVcZQCkiBFtWqO9T/HsVuieai01M91j9EsWKB?=
 =?us-ascii?Q?X8e99jYaqmJC6fqtdUVSEdmwQ0uGsodeFFkU9u6oRfhQ5zif22ob/oWs8AJn?=
 =?us-ascii?Q?SFYL0+qDhy8iARet2briYu8HClLxLU1e9Tefgtt+ANHwWDgfqgS+5K9oQmi2?=
 =?us-ascii?Q?Wpuxcb+Q+0Pw7ySMwdUL2MahLD07hfpX0WRhUjn/iKpktc1LECK5FmnpZTeS?=
 =?us-ascii?Q?5WLVn8SBpUNL+ZTaFvL8FdhIhmX/tFy/IjmBfBDXmGbE65SB9MsOQQ+8XLBY?=
 =?us-ascii?Q?hp2AcThGkzNa9wTJacE25xlQhc4moPVic/miwLwwQ0LNBBxoc5CIPdy+b1U1?=
 =?us-ascii?Q?flA60GPnj8uDWkShRvajBbodWo2nm3gj/z8Do0aoV7dSmehqdFVgm5pWhFgS?=
 =?us-ascii?Q?D/TFL5r/531pfiHbBQ3nwkCvdgEJsvt1VMCx+9FlZeEnu1uALzK+21PnqARN?=
 =?us-ascii?Q?3L44PVuSOqY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GtZXDOxH7vy3bLyOKs7dUtq2JDvXQb9+dv0I8WUxkzjzNxD6cjNaoyNdz5bO?=
 =?us-ascii?Q?6vT7Ih9XdTBKzRcWcBU6DXplRZ3LnY6pFVzITGKQEVyn3iLhX8EOeIdhCgWF?=
 =?us-ascii?Q?ZYkkNvVGPhQecjHWzwZe3U9eT7TSP9pskNRnUzp8BpRnEPOP5xkOdJONM5HN?=
 =?us-ascii?Q?7csnZfvkmH6kOgSDVWml9m2ztwfwBzoeWsgo9tVxRDUxhGQ5Rftpa94SOd/k?=
 =?us-ascii?Q?sOG/0/41HzFXPXsSCO+LnGRqwZwoZvFJyS98w89wwqXDhOj1WrPV0V8aegHn?=
 =?us-ascii?Q?QQERsJ91zLjpmohA5mucvIvKoCthShBTuid2J79rKg5XUC9HUllhe7U+lnPn?=
 =?us-ascii?Q?nGbdztBNcYE1SWhkHh5GbGPwB5pEuWlce2BplRPC3r1jrJiicw8Clg80SWT7?=
 =?us-ascii?Q?gL5TQVteIGAvAqGYvucj3jKYeXr8SjHfUguKmHDXmZbePlyEVlfTgQZs2I9f?=
 =?us-ascii?Q?a+iE4CpOLgHfIkfhvTpWR8dwZmpuv/fyfFoJjrcrCDLnoYadXC6hFkzSIGfC?=
 =?us-ascii?Q?T9QhXBrrYsOogaVU/KN0ODvV6hWpgb32nd7XxTYkX3GZVMUgEcGHEA6CE9zz?=
 =?us-ascii?Q?ERMugFPAfxf2cb9EhHTxtg2oitQa2d7z2q7FZq5IhWW2mzw2XIFzM1gzlsih?=
 =?us-ascii?Q?Qy7wv+YeknHHs3s6yPZSJyp/EPzm0TfaY2ape9xdrts9prbE+9F+6SW3ESmg?=
 =?us-ascii?Q?3k5ZFasDPFCuL1Nl0VxZAYz951ZEBGi+ILGckku6nlZ8/M8w5AlUPkb3sNHK?=
 =?us-ascii?Q?qKuq0cQIvY3Jk6ALVIk8belUf8F0KV0OPLoJ4KwchRKObhJCPsiP9yqFKh4m?=
 =?us-ascii?Q?qimt+XrgzYFRvFHef3IhGNRJBUKg+Q7lhq3iddG0pP3E3hinalqQiTUuEPy0?=
 =?us-ascii?Q?qDCls9oqRZrXRzo7askhF5DDWDpW1V9GAv3Wj03TpOzQK90M8lK/PBsu3R87?=
 =?us-ascii?Q?0bxyhyz5ZLy1KZiQoDM10rVvNSfc7pyT/iX0xd52t/Dzqs8JRnfsqxjFeLhw?=
 =?us-ascii?Q?ZqJdleZMbENVMGvGloZDJFOeLg9xLEuVZ2AIjmsx0dMA5QjC6x0hX3swu+se?=
 =?us-ascii?Q?q+2hyfFMyYRLfFnvjVRe/xIJJ7wdxenQuywIM1q3IyXhBFQ6KJ5+7s8m1biM?=
 =?us-ascii?Q?BaH2VgJOzEmMpsZmHegA+/gJqLBGJslVgf0fwG9OcQMUzNWSBN1qVMLEG5GT?=
 =?us-ascii?Q?EhkEb/YnENOSCi6/bka05Ru8B6iFfXexxtMuJXKpFigRBMBtbyWmCnsWO2N+?=
 =?us-ascii?Q?uJC7DN+DqbK7jt+iwBlIhdvHecPpGJKsQCdjmchLHsLMJEEzYocYrlSAmjUo?=
 =?us-ascii?Q?vKy1fJVRhyVuN9ETum8/4TjHm+RqWy2N/3UcYYUjl1XmoHRM8fahZGJrXS4D?=
 =?us-ascii?Q?5cXTX5xgch0LVdgsQ68R1BdGD0Ig7SjHuHzb463gbcaaLK15Rk+ONk4eFX26?=
 =?us-ascii?Q?+fUsnEPKXibWXoqCTtCzZcJr2yPTihL7bKKNBDkEGZAGKTDUslM6vS7QcIkd?=
 =?us-ascii?Q?97LAglZSRyxVpX/pII3kO8427laQ8VF13+qS5pKD7RL3IiAzJcEaT3UVccHl?=
 =?us-ascii?Q?/uMkcpWC+a2qSbvyl46jyeIgG1sJnVVaGQNeDY9i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac6b8f2-c9b9-466d-2afa-08dddba49d4b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 02:37:01.8048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McuFsJqLv5BanNZQZTC1T0ITXCg6IYCM9qKZVomL7SxmYOsZyaLAtuudExxNXhw5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 666CA20007
X-Stat-Signature: xp1f8uf7qmnsqoy6gymnho6ceuaa66j4
X-HE-Tag: 1755225431-338895
X-HE-Meta: U2FsdGVkX1/dmgOKFmz/kkKvTddRP0kYk/0eOZfz9AzYNbWnWXTPxfELV9uypyPi5ufacY6wBTW11XidK4vZ2nTAn3W6XrN3L9BOAYwsuqyVqmb7JtKN+2lhRvcifneEzTisV09pWJsTmAl/9Zr1bKrQP29/v//lKnYjXje4BNBYlyjlB+J+9XKX0Xbx6lDiwZ1tzx4jmlJeyZmnjYVotSdnQoCBudkFt2KVKKJ+XQVarSUWnOqhL2lozB+OMzB2nb53xC8DB0+un49inoTMVBTyXwzoyDUbe7CY4CAXdODefQTWBXS00oL4gmmy29+930GsgVcSUo1KOVVoSbvxJ4kcefq/L2aps5DcP8K8d6xw+H/7KMm+Qz1x89zjzf1QNAsUaFIIpKk0bdxCCRFm2MtgOX238W2LM8XX9c37qX1/h0lglK4k5Q+5WhlrVTk3lP1Pxq6cWdcmYNr7wrIlejokiE38+39jvpLrRE4/tuLqCJn2YVQ7TmM94MPsbf5tyhLB6XMbSwxeO1iXc231xHRjDcE8ybQUilMBmfCqtyrbuWnAZzvq4MCDOEPHPnceQTD0faEOpANUDlSQBG2BDpf1VNLzqrzxYk66WSQKOA3puGFFjkjMs29E2laO+gfOmV3GbJrC6tEhPAy20WrvJt6fXB5KmtW674YkQeKFPvHxdBuZgjq+Rx7x9WcNebjSdDYO7Fgi3rI0qY9mtpDjE8PVCEVPtiDT8TCQft/ThgGJ/rbImRkUnY0IpkM0eHIkimUFj5efbL9/XzcwG4RqyQOQ7flrsEVoNolmWoshv5uAxuq5ewRm2cRWf420GAtVM9vqyyw6/7C7Up6b2+lgYKugqU9DVMuVsBafLQKD7OQ8tXB+lqL0nbBDgK2BqH0wsM8PmhbuADAYFx3/PLPQ7eQumr075ampSmmFZzlER5UnUDfcyZTg9fLMKxxuG/gG+Cb3UcFABUjFz+ixdnZ
 C0Tbkdda
 old1hFyVMx2w+PVD0ajulKhV12wMK+5do7ZI9O/q+BNzA7Y4A4uZhvuuNA0xYfxfs8uAV/x5Q3DZnl2VvgYQaYeZv2B/QaShc16vPNYIgF9NdNWpbX60zzprdcXtCF+QaUGt0DZTHhtLLHlyzpHBFpwi6dZ1l/PdA5Zf0MTgt63QPnE0Kh7xWx4/pFQTjHh9ceudt4xS9uPGKoiZLY+U6WxbUilaf4dtQs6NpIyScmgvoP29scjrYPlVr5M9XpqflWwzoWr4/Uztqv4FAUeSgXbiZB5TCzjLhLEVF2BJXZhfMS6/dj4oJkQ+0s7eV7MVodUIIylOeBOV4Mlxg5IwU8VPsxVQm2eJ1UafuWDu1S8kx3ukcoR4+Yt5fS1FCF8EJvpwit5hKpsJMX97WoA/JStpyrj9JkXBxjkd/kgqu/acVHrehMQ8p9px3/zQeQpwLOlWKKdLK+myiqnqqHMrO6/LAcHosGPBmQhYCsQTbxqOLmptXlMCkKcW1WeUFEHYsBhUs3BADaNdbTTMpNr57WqB/Usco7dy2GCyP9gOcB0fcvnc1M2i+cxThnp20bCLKfBLytvK9XOeleFKfhZtbc4ud34dfakt+7+NkkKiVlIPwrz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Aug 2025, at 22:34, Ye Liu wrote:

> From: Ye Liu <liuye@kylinos.cn>
>
> Use max() to find the maximum lowmem_reserve value and min_t() to
> cap it to managed_pages in calculate_totalreserve_pages(), instead
> of open-coding the comparisons. No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
>
> Changes in v2:
> - Drop unnecessary braces
> - Replace "if (max > managed_pages)" with min_t()
> - Link to v1:https://lore.kernel.org/all/20250814090053.22241-1-ye.liu@=
linux.dev/
> ---
>  mm/page_alloc.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 64872214bc7d..2617fd2f4b73 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6235,16 +6235,13 @@ static void calculate_totalreserve_pages(void)
>  			unsigned long managed_pages =3D zone_managed_pages(zone);
>
>  			/* Find valid and maximum lowmem_reserve in the zone */
> -			for (j =3D i; j < MAX_NR_ZONES; j++) {
> -				if (zone->lowmem_reserve[j] > max)
> -					max =3D zone->lowmem_reserve[j];
> -			}
> +			for (j =3D i; j < MAX_NR_ZONES; j++)
> +				max =3D max(max, zone->lowmem_reserve[j]);
>
>  			/* we treat the high watermark as reserved pages. */
>  			max +=3D high_wmark_pages(zone);
>
> -			if (max > managed_pages)
> -				max =3D managed_pages;
> +			min_t(unsigned long, max, managed_pages);

Should be

max =3D min_t(unsigned long, max, managed_pages);

;)

>
>  			pgdat->totalreserve_pages +=3D max;
>
> -- =

> 2.43.0


Best Regards,
Yan, Zi

