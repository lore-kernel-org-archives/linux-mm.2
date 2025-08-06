Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FE6C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6818E0003; Wed,  6 Aug 2025 15:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0974B8E0002; Wed,  6 Aug 2025 15:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC83D8E0003; Wed,  6 Aug 2025 15:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD1878E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:27:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2B751A02E3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:27:14 +0000 (UTC)
X-FDA: 83747315988.22.779CDD9
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1285740017
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:27:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FTVWNurG;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754508432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uReLxqyHhY9onKeLm4gNIvYp4v9VPaHPfrlMLF1x+ag=;
	b=st5anvBAdqDSluxP8wnT6soxC5NLHUMkpaNl4OKL/bZAU2KjFndaE6wCC0RbjMAroMgTZ8
	NOlUQ/0V7vgHNybRBVugTH44kXb8oeCgtmc3BQoS7YeWzty3yyx5YtvBOhHqUn9c5HGqhF
	Khmlw0LrLf/Vv3JnFEywZO5TY8wrgts=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754508432; a=rsa-sha256;
	cv=pass;
	b=zLEoSmsWTO0MIA2BBcwS69qSJo+qSDjvWxgYbY7+2E9mS0cM/AQUF6ZXuvi9POsrDJZPv3
	32uSnkLi3RGu/bXZeO8RRkIIQ+lbD0zYZRnOs8iTwIflSsXRvRnnWurtnRHy2vaEnTty5I
	j4mio7uPW5Tf8uD1P9oao81wGvvuxoE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FTVWNurG;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZECqIFr446FT2LPNOv7wWfqbQ0B9vq1xSET2dJ7R0TwQs+Cr4WN+9mPbkjiz7N6vtwXsWKFlrtb1WqU6uiLCG2H6Ds67ZK6HfG4a98z0aD5LpkfMD+pbEUWTQegZHQsOUfCimZdbsv/Wf8MzkuJAdfxkNQGzrM//8khsIRcx6rhi+J0ufDpnXH8XvYMZO4pdCjJmP2gtqLgMRJ43UufI+lxldYSIPypufAbyBSPl4dALkA5hXvkImh39HEtBIquBA/UdCt16gv59kiYAQm7Kao2Ruc7AVHlEkl5Rf9vvJat8vDyZd55sqetxvnlhGj/DynXTzEdTDuEEIS8TOt87uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uReLxqyHhY9onKeLm4gNIvYp4v9VPaHPfrlMLF1x+ag=;
 b=ESWiG8IyvWJ5XwjZdQ+ZkKU8ofNiajbHz9I3Rqzjuuixmq9K3iLJMGZ91+98roIUaFqItsBs6S0gMiNo3zZojb7HomURvFhuegyXmfQMBdFZx007muEPoUFoq1oVGuEMThVILl44bMrKCIhMQufosQ/GsVWgEffSVjVdwPdf+QrE8uRVEuahfUdRYB4iPeX4bFkU5Rq7laoqwmHTWXUYZTAooAZDOKZ548Rx5T3D3jckIBSNwhtQgyigvWoSUA2BXY0WVEkAy3/vU1G+PnbTVP4Y/41tLvqZQcRLYvF5jRnYOGnKyQd4Uyc+qOYx68R6hMAMrGl22uVopG9qVUjxHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uReLxqyHhY9onKeLm4gNIvYp4v9VPaHPfrlMLF1x+ag=;
 b=FTVWNurG8uTpWNL92rclMJWpsxgrjwRukK3r7Euf1bYzXUB4Bge3lDAYo5y50el6SvlUal2fj1SzdECPqtYzygmdIE7inY4SFPxweMbtxuxWCShtxcUut4f/BOddJAbIN3DM6h97IEDleXYhOWoVblW7BZjc7trCPci8JA4ek2p0DEeGkrkBNC93ezF00QVsS418n0cCgXFUUurRafAiRpwuPDVjUnYGWSgDNID3lol4HNYnA3bO/Kz0UKqTuujitOzFK4xmv2dbHf2aE8TZ7wG1A6P9u5u6K8QSU1DJNf8UgIdt/9nrh/KNP5QYFYRaYiFal44JaP1c10caftG0dw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7356.namprd12.prod.outlook.com (2603:10b6:510:20f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Wed, 6 Aug
 2025 19:27:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:27:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 09/11] mm: Reimplement folio_is_device_coherent()
Date: Wed, 06 Aug 2025 15:27:04 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <360389D8-EA1D-4366-BD81-243FAAA5D68E@nvidia.com>
In-Reply-To: <20250805172307.1302730-10-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-10-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:408:70::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: f22b3124-548d-4529-4525-08ddd51f3b17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v1U1l19ZCP8LlRtAAecnOFj7X7w5FIat/FGJDyFnIuIIvKsA6VajYRrbtdx3?=
 =?us-ascii?Q?E9qMnfjDOfsdaj2nGoW4qdBMUmOrbGjkV7FA9DxEkkXiLQu8ZoQSz9dqDOqu?=
 =?us-ascii?Q?RlWgKU4cG3RlBuNm6Upo6OyhCX5YKK8m91pwIhfB8YvEDlGYnnYf6vWSFcQT?=
 =?us-ascii?Q?SCVNl1IYRMmxY+sgqil/PjS02IkQOIPSnG9p42groNHTCdhGzyKOE9fOK349?=
 =?us-ascii?Q?gF9rp98exwaditp1y3lIBb+bz6LG8YoXAKvF0Lo+E4UkAp/cIMyodiUTuLEE?=
 =?us-ascii?Q?l75VtQ02g1CMXpZilV2HLOpwJECUCE6G9m8MQHjPmvvy+X9U/e9gws6E5xJf?=
 =?us-ascii?Q?lNGqDLFSFYX+81+HCEKGxq6GEXgUAyo0Zww4mQrf5bL9yapaNAUsJERtDumO?=
 =?us-ascii?Q?AuJm8HnG4gcDXBayHo3ugNUplS0rvPZsrp8V8bcLjYkS+xgjSEBYsx6m+fxS?=
 =?us-ascii?Q?Koay4A1B/Ew8zTsiG1C7mW2GLV1Fvk0fI4ryhPCwPLM+8a5ngFnJOFBwneby?=
 =?us-ascii?Q?jf7LYVS16FA9YzldyXFhnZFtLulO0ZUqqPwpDpBw6NYSW/Tu00lvKNRHdK7X?=
 =?us-ascii?Q?0mjAtJ8y7nZkKyae2EzSouuFeQn7yyYA8NULgBNgMY2aL1QdqS0VMuCv+WyX?=
 =?us-ascii?Q?ycVqXtiLcXPAR4wCFYAXuCuaLGeGrijJd8TBeDX570Z0d9WZ4uI8AyxCfq3V?=
 =?us-ascii?Q?DTadNI9OT25nAEUMhIO/vIPIrUcItojE0JBfxWvdxCMEYoc81PQeHAK8+B6W?=
 =?us-ascii?Q?nV0ysGiuSIsUbSIAvqerah6VKwhAYtw/FQGM0t5x8+Qrig7XUSWo1KnfRxbk?=
 =?us-ascii?Q?2cEHbTdcdNE4bIIwCkjerDeMsmhJoq9mXcXpFxnByek4ZpBtF7zdDMQLifn6?=
 =?us-ascii?Q?QDCt2wJjuZpp/aHb6QDefW/iwNLrOQN2NJfoBCqGf/OlFeQQt2Vjw5tz6k24?=
 =?us-ascii?Q?EXm6KbIjkdboFRnnr1o0IEdHGF+eH4GHbZsNGM7WK5hEW1s1vUHrkMosua0h?=
 =?us-ascii?Q?azHEhEb9Z6yn89RTBoZKFPwPY5CfOujZ+woTwG/kP0nt1r/6PnAKe13j+4GG?=
 =?us-ascii?Q?TURUrJoa0ggH6JECOy0SYesHDO7UJBNpDGqBNs52cgXJe/0FfPwHRjh3J0z3?=
 =?us-ascii?Q?xuMfQVCqHjd1VEn0T+Y4+q7ruSUBJ2FTNfDaJ+OrUyjyy5Cj02tt6YRGAvn+?=
 =?us-ascii?Q?CGvVATIzN8D1I1xrY/y8rxfXZsY5cd6WQiUhdkFLzjhV/ArrKFO6djM+uyQh?=
 =?us-ascii?Q?HPOjML1KAamWEXKLAS5LZr20HEaw25IJxPwNulFU5ZyjJjeLKOMzKxbh2i/W?=
 =?us-ascii?Q?N10a2DXCQpe5/YSi2bpo0EGl8/35FTgJrKbNiqZr9TvY5UDm3pbP/xfssXAA?=
 =?us-ascii?Q?7SeRRqBfw6lIWhGEK4lEQd/CNot7Ou+xWCyX5U2NyFTUs+DE4rS+cKLQ/WY+?=
 =?us-ascii?Q?UyD3a0d7Sss=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rtD9+wfWjHKOcP7sDziYLXndkhbYgShW+7lyamGjc5/ORw0a0zBgjteA/2X3?=
 =?us-ascii?Q?WdVWjLwf8R/C4hgVowk+XOu2BGsEj5ELe/zylqFvxr5OCyhtgwAsl6ij8J2j?=
 =?us-ascii?Q?WlkBLiBCAxxCPD9ImxtGTYSCEru3zlR9T8BOGAYxXsom2Raja7ovbCARxYzH?=
 =?us-ascii?Q?8Qnk4pUbRquTz1jB57hlrC20Si/e/J/TbnS9zguVPmTDQbVDDEoitQ3IELUs?=
 =?us-ascii?Q?kDLV8MHW/B92fzZDWvRirTYQQh1PIpnJ4k/8ZWSVYftikZPVmplrA79ObLWp?=
 =?us-ascii?Q?cq5HtXcL/Ps1fLHSGNzGs7gmX/tMCfhS/T5qgK5NeLHbvJYrgBPIZnH2idke?=
 =?us-ascii?Q?227SBtNYgQeXjNYbxk8XcQkPteUn/zWng3W951K7POr3ddmPLlpdAmXKwSGx?=
 =?us-ascii?Q?5biyyiQAJ4BYVmEBGg9RvtGqN1V0eeClNpMIiT4iYJF75VUId8m00axibQ4R?=
 =?us-ascii?Q?bOJdGI4PrJxU4xxke04V8BGEydLR6CSxkhUsr7M3gbgi2VIHSjt1wcuKm3vL?=
 =?us-ascii?Q?5F9s/nc9lSNmxODd1QV/4/t4Rdu/+PtLhXg7WvheizSk64yIsxMlsUPBqKzd?=
 =?us-ascii?Q?+N00up4+lAvgSJP4NnyY1AK6r5teNKpCfVMqEvjzKvXt0OwM+ValCHvYhAht?=
 =?us-ascii?Q?Dli3i5dUhPERm2mEk6e7ldzljAVAFKtzuUlQKnNgwKnrUDyk6KqIN/qg6IMX?=
 =?us-ascii?Q?3yXSeesPy3nEKTeDIH9Bu+So5TuxO4NHGOQ9rO0VzDz0jPYQJkIOTjU0uIX1?=
 =?us-ascii?Q?zez9Fssa9Sh0w911HsKtA/XNHZxlUu8sOL8sg/WEGNTfHqzrmskGy0x9AbG1?=
 =?us-ascii?Q?9R+yEjQ0epdwr6AgaVcxR/hlShW1LbZ3cxwIcjEfrGS01QeuKSYd2GRgrcO5?=
 =?us-ascii?Q?d85PNdvH/mBS/LIJ1GSaXvc83m25+NwQjVvrDRvM5zfOA/lyjphEWHUY2c8Z?=
 =?us-ascii?Q?8EEEuYOoHHIVnYytCylQ6rD9Gy2tDNhkQnMIxRh0YFJA8MnB7MTypihRM609?=
 =?us-ascii?Q?bObLAcxKwfX/VVZTTTJ8Vdl8Tu/S2Zx1VY7BrOg8LVejSNDNpXbY+kBuXQfl?=
 =?us-ascii?Q?fcBzDEB5qSEb+fG+euFXIj+zZZcVrHDeNn3B8mgbYDunZutSz9Ar/Zz7XihS?=
 =?us-ascii?Q?8pAoYjeak1vjYVaim6AIWrfhvg6EaM5sSi+Qov0Mbeg5jHtYbKgbwkoHusym?=
 =?us-ascii?Q?OCw+TrpF2yzwnQQxA2oD3Hju5OCtb9/IkWmKo2nQFzHX2WDwI0vmmUe86JIO?=
 =?us-ascii?Q?g5eF/8Q8cn0EZaJJKlZP6XaeH3s6m8XfkG2DTrTDsgVxE0/HoomGjMU1vXNz?=
 =?us-ascii?Q?AZ6CbiPgFKUscJejEusCBgn3osk5LGZX7WNYU8m4DqPM3yyPl1mD0UfOqC6F?=
 =?us-ascii?Q?RNRPsg32iZ7IAZNPpP5DV+2oDc9FUP3jZlcnKm2dTHdNz4Q3tMy0QZyb7wRQ?=
 =?us-ascii?Q?rrdU6co55ijZkG9tJCt7SOa67Vd0vGsYd1PIFbWba1vSgC2mrDrRMQ6GvNyA?=
 =?us-ascii?Q?4S8fGf3DoMR/RzHnz0WVWsQznTPIIA9zT4v+kMKdtdwtnYdmospOpLN2onG2?=
 =?us-ascii?Q?HxMYdpRGXtrkLZKwm5Mboss6hidghCutqMXckbTR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22b3124-548d-4529-4525-08ddd51f3b17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:27:06.9897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: laNL4s1+gmAZX25KpJeMms4vb21aakQtsXaA0r31J7LXmdpQiJx2sTUWBxHJ7rtG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7356
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1285740017
X-Stat-Signature: nedbtrk9xt945uzhzju5esky31o1znym
X-Rspam-User: 
X-HE-Tag: 1754508431-123321
X-HE-Meta: U2FsdGVkX19un+I3HjwuFA8rnrA1ZJGZi1djZ152YzdxQU3G5vB2Eohgb7OyCAARJC1kyqlE/pWdUrZ/01WfkWMlDZCyVCI57SScOS+wCqx1do2JKvzVQuRqeqnXAO7QuSOuwY7HLNq8n2kpfw9vO8i6ca0J9bmLAiif9P4sdd4XYLUJYnJmC1KXdNhMIERO5NIHXMJc/pS8ML7g7EmTUc2T9/pjXI1BZUhBwQHPLyo2JUtl7Dih42UY1/dveE6AKM5sQEVytTRSh9Z12MIwhbQ2UAJ7Ja7mKWqSs21b+winodWhAaeyYfSIeuqqH3THvMf899SYUb/tjVTYpM6cpZQarz8Pdx4PWOb4Bq2+OhUH9p6cgzJuRDWMGyy0LNB4JJDUe4arCUBQ/paqZV7aydBSoXlHiOMFEsyrYJfSUJT7FbpJtKM2ox3dhcDokXCUm8/dsIO+tcmQ3hudKpQ/Pk3NHcEf4bl7IPk1xNeWkN5IQkxXI+SsUT1D698f3xGglJ0MVsA91/4CDOnsjDWSe0l6Z+8xY6GHejRk5pZ0TJxx9g76pOUr4Oj4gJBtTLVg+22EyuKh0j7QRt2X4SRmwZ49zJaaPeNeI5kJs1/sGvFybi73t7B1N3hhfj22eeQ88PZ5wJ1xw90585Zw/a8cpc5WTWEAEevedN6uklZxF8VtBBGeHafN2ytbljVn0a0KvTy4QBd/L+u7wWi+DTUwpIj/9Q2S+yOu3Iyty1Anm9v+qKMmRa4DxK5P7g0vH4wZasseR5/soqk5cdrJEtMuLDaUQsO7sN/K65tU/8Sl2Ye4vNhL+hWAOEXbKTOoGHudIaArt9pS/4eN/zCy4YJcN4HQ5/fdJvtFMz4icos6xfVECCgZQzFagHxdRK1W++fhq8vGICp+Ce1xAxm5AXoXxbar6X9XOfoYHraS5RI6AxYfMVgSuZeERBal80bSaZgP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> For callers of folio_is_device_coherent(), we save a folio->page->folio
> conversion.  Callers of is_device_coherent_page() simply move the
> conversion of page->folio from the implementation of page_pgmap()
> to is_device_coherent_page().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/memremap.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Similar change as folio_is_device_private() change.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

