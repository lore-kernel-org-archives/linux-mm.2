Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED98C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870B36B0147; Mon, 13 Jul 2026 12:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847486B014F; Mon, 13 Jul 2026 12:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711E16B015C; Mon, 13 Jul 2026 12:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7606B0147
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:52:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD8C9140183
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:52:07 +0000 (UTC)
X-FDA: 84984345894.05.FDA37E4
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012064.outbound.protection.outlook.com [40.107.200.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1204A0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:52:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cfvx1sGI;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783961524;
	b=245EYE9cSvAdRd1QMnO/KtHTeQ26PrqviJ7jaBriu1Km4ms1TWp/FPHpnh/swfTvZyNs9r
	N9VHsoWnmDmDatECTiCwFDfuTf09xbwyihmSceYbXj85rQCjpooq/evWpGX1oUamjnevjC
	mFo4UCXkceqnSKXSRIbzdTJhqZh5kpk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cfvx1sGI;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783961524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G83fY2RVhM/mag5R2KyPD7t8vDqd+NR91yp7+SctYfQ=;
	b=mYsbSbv5puxOtXl+VgFe4rLah7OIUSGHeBINHRZ0ngQXVM4NKLVH4nVQkFIVcChG56tvkx
	c1u8ljXbl2svlJybEPzy6fWQAYQeNQA+K2c5je8K3pzXvHmSwLkSloFEeTCmzG7PLQXr+A
	Uqe2Dm4FMbLHGWLeHwAYulEPDozEzgw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBIE7cwvZFdjAfoO+WK44VxZWJ6lne6rMpUilrI0PsWhDN7ZK7g5JRWEvx84v6iskLXq2YHZxkypUf0gkMwz7/9eXzPdBgPeKm7mzcIBC9VtawiFvgfKgO1NVkelgBJH3Og363/O5YqZMQLp/NOpRFMm/8OXjLduwd/tbayecyb2JwZ3NQScvrlqLpkUtRvOK9kMMJ9eXcsK8P38O3s+NIdTD9tufwMsMFWX43d250EgfvdqydfCnGU5CxXWs2gMxCBdZ/mCznVYLzbX+3uy27nHm8IHjosjwxlzoNMBwcjQqeBfayfK4bENJOwM2TpEciHTWVAkv2Ao/7w3lRIftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G83fY2RVhM/mag5R2KyPD7t8vDqd+NR91yp7+SctYfQ=;
 b=OsFJJYdPh+MvW5pQWSE7znhYrySzbPOB7n8OpZQmb0k/+Q++hNtwbP4iVlrZbvp2SXlql0oP3ricz7NYFC+B7KwXJAsbOU6ahlTOSWysZge6f4CY6hPF9KCZOhebkU1wPNE5MdHrf/zz/j4fYHoC3mljeSoLSzJryGJWa5I8id68d76zfTxwAunTmetZUCz2iDBO0jSpq8ycuGC8SUkK7n62E+lJlQ+EwN2hs5OjoSaB6KTgVnutKceSIK8QHUOF9mLIU01GenA2JRPE9bI6FZ14VHhAkoBWQUXvZMu4Pv58lqCjKg8qbXHx0MyOoO5MZVpExoHVji5BHmCpvea0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G83fY2RVhM/mag5R2KyPD7t8vDqd+NR91yp7+SctYfQ=;
 b=Cfvx1sGI/y0Jrg7iDiPuFd5ufEhOVPSlh9NwyDoTMXErOgYF4G6KTMVmMPGhW+TxJdrQiMz6YXigfONbFlq70kF0h7hxNJbbFF4g1RO9jLL5ltwbWnZUrPaMTu3YHuQ7UqC8s3fPnklHD5aT8ulOrbe05Dx0NGP4crgP3SiGHuv/EPakfUGzJmkcPQpOlKCpc9EAAXiB98yTSrFylDPI8G6mFbguOGK+YNRVjNdIahItoKRUNe+t9XXltK9Prx3MO+DC46jZb3pt6cAiE8/1igbh1CSOUYOhCtLAk6aCSGA/NLVuTRNWyVwFPUgNsXTQpp2fu4ngZr0XHbL70dtFiQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB9062.namprd12.prod.outlook.com (2603:10b6:208:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Mon, 13 Jul
 2026 16:51:46 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 16:51:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>,
 Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v5 13/18] mm: Remove __alloc_pages_node()
Date: Mon, 13 Jul 2026 12:51:43 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com>
In-Reply-To: <0e7c2aff-a278-4118-a9a9-123c2735ed67@kernel.org>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-13-c87b714e19d3@google.com>
 <DJP0VKJLE8TE.6EDLC2BFI1SG@nvidia.com> <DJXJRNZFBPQ2.2S6CM4YAKHVQ5@linux.dev>
 <399958F1-544F-4826-90E5-B471E2231375@nvidia.com>
 <0e7c2aff-a278-4118-a9a9-123c2735ed67@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bacb44b-9266-4faf-c389-08dee0ff0644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|4143699003|11063799006|6133799003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	+1/gHOWdte8/EDdWMtoAjWW1+IpRy0GtuYUOp5Y7rUoi1OJEPt30pfrmCYi48EY7HgqsCOp6JCy6hfqyRGEkGsU7JKg869wienlIinnvR3Q/Ewpg/GKdVJyEoDsfD1G3aE2bScHTSbiMvtnu38iK+59zNtvYqQgXtVis5rIPIZPwwlTPoEGONYp6ZjwHGR92l/N7DMoWH4LcDdHznXQ1VAzCDAT/UgG4DNdqz8J5li/cFxEorT75AMc9tj99Krj/h5qZYoYquSThIH7P+f2AdV9S+RFCg+XbbE6Mp7u+QHcdBY+5vdxMeeKqTfWWb+wZwFHsRUfjIkLmxLEvnui8+Oz1wTBQ9fyckrJhxrDfyzsPjrxWr2SXzaocV1AwgJ1hBAdYurJ6jFVyfsycO1yyxemfwnVhPabQBs4S84/6BkVIAAx5ZzvMhnss7K3pRblq4nXmIB47SRIg/S4qMG7BIVrlsUgmlWleXt34vCaaTeow8s7X4LXHyQ/6LIy/sDDEAcUP6czbioqN0jHRkZ9dkpajQ1JXkJEFjyDOG1em9xtnPGlMLb/uqNyvsOzHjumKJrOsxvJ91jTTSfv6A3liAQBlfZBTn7TULzk6nzVk3SQMIzq0dgdCTRGPtfgGJaPG/xc83ue42rqjsGCqEdp76XLjiGWF3mf6ty4uJsGVHS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(4143699003)(11063799006)(6133799003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUZ0amRtTExLd3ZPTms5RkVZaVZXSk42S3Bqb1lzN2s3ZDI0SFdUdGdORjhN?=
 =?utf-8?B?bWx1M1IxdEpxamRZcUMxYW10S0N6eUNwaHdZTStSWmN1aDRqazd5cVF4SFdZ?=
 =?utf-8?B?V2FYWmJmbXV1NUZHVUxMZUJCZVRFaXg4TGkwdXJhOXNUMU5ZdFFNUHpGSGJR?=
 =?utf-8?B?WE5iaEJRMHhTTnBxWkRmWENxOWZYdnptc3paVVI0ZkNyQStpcVlpK0k1c2k2?=
 =?utf-8?B?RjYwMmV2dDh5V1JkZzFieHpncXBveWc3bHBOL3Y1L0c3a1k1OE54Z1dDL080?=
 =?utf-8?B?d3NzWG42MkhCWTVQSTZVQ3hqRHd5aEw3R284VTJsQWtwd0FrTENCTjdzZXdt?=
 =?utf-8?B?MXNGWTI2M2FpQ0h5MEpFWFNKREovSkhBRlRMUU9uaEtyN29sM29LbE1sODhF?=
 =?utf-8?B?ekZRdEVxU0FCcWVCZVA5S0JLM0xpK3c1bjVWVk9yQTJiVDViaUJhcXFXRVpz?=
 =?utf-8?B?RjExY1NKSE1WeGh1Q2pyQnJRTVJuOEtkZ3FtdGRFUWlyQ3lPajBIajZJSTgy?=
 =?utf-8?B?Q3YwVFhiODgxYWtvaysxUDIxRjM4YkIvVHZpcHhVK1dHVGFXaHVKWUZ5TSt5?=
 =?utf-8?B?d0luckNNMkZJdGc0ZW1nZXpWMzlnQmk3WlNMQWV0VjlyY1E1TmNWMlRNblBh?=
 =?utf-8?B?QUgzZDlFVmpHYWZsUFROZXJtNmJDTWZYK0lMZFNFN3UzQS9xeVkvUFpjdHhV?=
 =?utf-8?B?V2hqRmZ6ZXRKZklSSm9VNE5lM3duQ2R1L21LeVpoTlpwRkMxMWdTdlY1bkFB?=
 =?utf-8?B?aUM0Q1pxM0dLWHdiZDdpZUtxMlMrdjFuckcwVlRqanNIRUlMSTRKcTM4Q1Qv?=
 =?utf-8?B?bW1uZnExUEh6b1hnZWw5TmpaWkZJTkZMdjFkNHUwc1Y3R2J4Tm9uSE16WU1r?=
 =?utf-8?B?SU51SmltSjdqRW5zb3BmYStORnZROFhaQ3dlZmY2YnVmUVlLL0xVSk5pZVRV?=
 =?utf-8?B?Q2tscWs5Q2RiZjNaRzJGNmJPODd2Zkt5VVF0Ykp4L0hRTHRkczVYd2l1dW5H?=
 =?utf-8?B?RGVYRGtSNFpFbkFqRVhwUGFFdks4Q1A0MXFCRktRR1QvMVdTeVVuMEM0QVd0?=
 =?utf-8?B?VVVRYmdjb3N4d3IvU2dZMWVOQVBWaTh6NWlIQjZDL1FuVnZVeHkvblhDMlE2?=
 =?utf-8?B?WlhaU3NmU2tVVDNBanhvc2IwU05SSHorZXg3dEFoNTB4QUhueHNmTlMrQjlH?=
 =?utf-8?B?Skt2dW5ZM0pSVkhHRzZMaDdCSytqZmVFSUdDbHpYaUNEZFAyMGllbUtnTkpC?=
 =?utf-8?B?VVBZdzd4QnNVOGhQN1RSeGlwOS90VzBlUG4xSTZWc1lHUW0zcDVxZmtOU2kw?=
 =?utf-8?B?QnVIbnVIZXpIVWZLWDcvaU1FYmJyN09tT2xpV0VJOWt0dEN3L05oLzVDaFg0?=
 =?utf-8?B?Njc1L0F3dFVKcWJFWXhJV2ZnREQ0RDZNanNpWWlRbjlnMFhuMUMyd2FJMDFz?=
 =?utf-8?B?YWlCZUx6Q2JMaVVtZEZLL2dxS3lMZ2t2bEsyRHA0UW1xWlVwWG40ejAvYnNv?=
 =?utf-8?B?ZnVQbVNxQ2loR0MybklZNkZ2bDM2RXBFUzRma2NZSi91VDNtTGhJQnVaVXdJ?=
 =?utf-8?B?Sjd4MWdacVVFMU8zb2plZHViTnQ0MWJRVWlnNFc1dElWRnRRdk1GOG5QaytW?=
 =?utf-8?B?cFVJQWtLdWt6UHFFTFU4T1oxQk12aFI4WWo1eUNPZnFmU1k4NldkRGdudlRX?=
 =?utf-8?B?MW9LOGR3M3RDOXZRUHFDL25JZGpha2FBTVJsQmlPb3hKM29oV0JlM3MybFlQ?=
 =?utf-8?B?ZDF3bHU5d3Vod3kyaHpUaEY0UlNYR1YxL1VQRUpVcExIVklMUVNOWEN1aWI0?=
 =?utf-8?B?Y25Ma09VYUJLMDVPK1YwS1JBTEdCdURLbUFjYy9NMy9TYk9HVytUendYNVdZ?=
 =?utf-8?B?TU9TWFkvSjBhS1JRUGNwWkY5ZzhmMUZrNW1mWitSZ1RDOG5DQ2hCdGNkV3RS?=
 =?utf-8?B?ZkEwU3ZGaHpDYU5QSDRHMGNRYTJndzN3VE41NGRvWWF5OC9BemFpOHJESi9L?=
 =?utf-8?B?cVhTUWgvci9pNXA2eFdwYkFjSVdzY1BhczJNZFFabjVjcXNtY0svRlNucklP?=
 =?utf-8?B?MGIyTFREV2phclZxeGlMcTFKMk9LQ2Y2cERmM1NtdUMzUmF5UDVpdVBKVFpl?=
 =?utf-8?B?NFBrOWFOZCtnK2hWbHRVNkdscEcyMzVXYk8wdjJBbXM1dUhHUVBVYWVzMTFn?=
 =?utf-8?B?ak1iTElrY1RRcHdGd3Y3MW9laTlvTWVjb2xGMGlKdkNjNVRIRDhTRFJ1N2R0?=
 =?utf-8?B?TW96cHhubTJoNFFwRUlvRnBKUkl5NFY5MXh4WlVUbkVJcUNxSEVDT1NkOWxM?=
 =?utf-8?Q?2hNQ3DbAGkHqjZtGs8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bacb44b-9266-4faf-c389-08dee0ff0644
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 16:51:46.2703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAjoJEtZBz+5eExARFrIqbmba43/WIaiuNNiW/REeyzrgbkF6AKYmZHuqtPwqTEJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1204A0004
X-Stat-Signature: 9ugk57s5ehiwdoimspcw1ugdzwwc3ye4
X-HE-Tag: 1783961524-371206
X-HE-Meta: U2FsdGVkX19L/SZsNKA1nu+WljBcHWsRc/w/O1yWdNCQ7nFR7ZJHe356qTvRu9v88FhuirSVbqpWg7TcNLXusfQDFXHip80QsLRKijfKATlUlGGs6WOJbe9pRCMmT1HRH7wRY94IOJ8YtnyTAgSUnuPVkjFxoTKsozLPlDqsl3CNd5tZL9dNAqg6ETUGOezT+7Yhv/s2jsOzuq6k/HCGA8+AxIO/IsCU9lG70iAKBmLU1s/MSsNoeFZxFfncM6bWMYxDyGl5wahRY2TMht1jYzFncHwb9OSwSjkntPCn0mNCdHUrF5k9fsPaFZlRz8z6kAv/fSY3zROFcin+mcRSQ4eLW/32/r6zikrhxmsNdPwxPvssF9iX0kirfXJLgGbT/NUdkHi4X8HxNl7YK4gQPuoBGFGVAyQ3S728DNtp0my/KygPj6iOxdViGwobtqFdJNb3tHT/iWxh4uzMkA3h18tLo4RK7yML1vSjyAWPoWPyVje15edP4OWXJFi88Rs7aulHU0bYklPAlBFzd4+rDNTAauL/5128gHLmfcc27+/MyOjf3JDScnmiVtedVgYzJukAJeQl8hVn/dA5lZK855199hJsvZkvj5zw4A0PhoAcHNzxVujLrmhO8tdRUGx+//HPzYnHSbPJHA5znhQGZJXU5YaWRZ3XkzpDQoJOK5rOCLFHLBuC7ZxSjb36TrRHuthvrGY60UgFuMpua+Fd0ym5FdIEM1ZvrdlVbr+GG4yTPPmorHCc7DvRjLsrBjM/bgbwHV2meK/rb0SGXSxTuYFAcrTttMi2YgbFTEOlhaJSnVStgX1HxP4vuShhmwozmUyXiKn4OgJN53sShWrnUSN0tOmdZEm+rLOxtV3hTm8IPObvrESGz3Hqwj65oErq7QH0TjlQAK/zCfE+TIKcZCqeYQjKdfcmqJaYth60xYdauYhwp4nxaxl3zuxPVRVfgLSxCG+GWJDeUKVlBRe
 37hyoz+A
 Ko902xArnVjyeygrGkJS3AYeIewKQz3mOwZ5QfJdabImktZ9Mvnfb5m/FpWuMvjK2O6zsf4pmR4X4DY5cgUEK0FYhDUYlR5L4QyHSVVU6bAXtpgjhJUzscpeysbcEu/5Kul+VQddOw1WD7gnjfnjr2xqSCmXZ5phxwikWRH5vaq3oKdDl2YvsTgzJBIDvGN72gy0pTdC6Jf1QqzyMe3OgmUsddUzNYK199ISG0Br2vySkxWqVBl/FEwoPgo49Awb5lRr7MVorDfuNKzvyBrFkHZglsaiUBc7gShKLXhP1fz6Ru221pdy1vbm3/PDp13f9C/MrjfDCZr2FL+LxCi8OTSo/YrxOcVFkkGfhmimPMsx2HTuzr45v95A8XlzgXV9A1ah0mk8Px2SBP3WzHNpeo2rzRtxwD0qeDOnseAaCqhePNTaz5M5j34XOM/BNhCaYtYgsers9fKxujJCT7V93YhwEhoVUvq9hSoTw7jQfAhKWmCh4EEuzr26v3hG/xEF8id5eHCZZFJ93MhYi7EZ+pOsL8FHZgXYUirQxrkRw2GLKqrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jul 2026, at 12:37, Vlastimil Babka (SUSE) wrote:

> On 7/13/26 17:54, Zi Yan wrote:
>> On 13 Jul 2026, at 11:26, Brendan Jackman wrote:
>>
>>> On Fri Jul 3, 2026 at 2:57 PM UTC, Zi Yan wrote:
>>>> On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
>>>>> There were only a few users, which have been removed. The only advant=
age
>>>>> of this API over alloc_pages_node() is avoiding a single conditional
>>>>> branch. The disadvantages are:
>>>>>
>>>>> 1. More API surface, more sources of confusion, more maintenance.
>>>>>
>>>>> 2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node=
()
>>>>>    were using the result of cpu_to_node(); if the CPU gets hotplugged
>>>>>    out this will return NUMA_NO_NODE. If one of these paths fails to
>>>>>    protect against a concurrent hotplug then page_alloc.c will use
>>>>>    NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
>>>>>    memory corruption or other. With alloc_pages_node(), the code migh=
t
>>>>>    just work fine.
>>>>>
>>>>> Ulterior motive: this frees up the __* variants of the allocator APIs=
 to
>>>>> serve specifically for use as mm-internal API.
>>>>>
>>>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>>>> ---
>>>>>  include/linux/gfp.h | 20 ++++----------------
>>>>>  1 file changed, 4 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>>> index 01d6d2591f49e..3bf55a5f9143e 100644
>>>>> --- a/include/linux/gfp.h
>>>>> +++ b/include/linux/gfp.h
>>>>> @@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this=
_node, gfp_t gfp_mask)
>>>>>  	dump_stack();
>>>>>  }
>>>>>
>>>>> -/*
>>>>> - * Allocate pages, preferring the node given as nid. The node must b=
e valid and
>>>>> - * online. For more general interface, see alloc_pages_node().
>>>>> - */
>>>>> -static inline struct page *
>>>>> -__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int orde=
r)
>>>>> -{
>>>>> -	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
>>>>> -	warn_if_node_offline(nid, gfp_mask);
>>>>> -
>>>>> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
>>>>> -}
>>>>> -
>>>>> -#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_nop=
rof(__VA_ARGS__))
>>>>> -
>>>>>  static inline
>>>>>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int orde=
r, int nid)
>>>>>  {
>>>>> @@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_nopr=
of(int nid, gfp_t gfp_mask,
>>>>>  	if (nid =3D=3D NUMA_NO_NODE)
>>>>>  		nid =3D numa_mem_id();
>>>>>
>>>>> -	return __alloc_pages_node_noprof(nid, gfp_mask, order);
>>>>> +	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
>>>>
>>>> Could this become a VM_WARN_ON?
>>>
>>> Er, it will almost certainly crash later if this is violated. Personall=
y
>>
>> You mean in warn_if_node_offline() when accessing the nodemask?
>>
>>> if I'm enabling DEBUG_VM I'd rather it crashes with a helpful stacktrac=
e
>>> instead of chasing random poihnters, likely corrupting memory, and then
>>> crashing later in a completely undebuggable way instead.
>>
>> In this case, VM_WARN_ON + return NULL could work, right?
>
> See below.
>
>>>
>>> TBH I don't really understand the "don't BUG" culture we have in Linux.
>>> I usually just go along with it coz it doesn't seem important enough to
>>> argue about. But now I'm wondering: if we really don't like VM_BUG_ON()
>>> why not get rid of it completely? I wonder if there's some case-by-case
>>> difference that I'm not picking up on.
>>
>> My understanding is that issues like the above one should be caught
>> at development phase, so VM_WARN_ON() is sufficient.
>>
>> The source of =E2=80=9Cdon=E2=80=99t BUG=E2=80=9D: https://git.kernel.or=
g/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3D1cfd9d7e43d5a1cf=
739d1420b10b1e65feb02f88
>> You can read the commit message to know when BUG_ON() can be used.
>
> Quoted from there:
>
>     I'd prefer to keep all these warnings 'simple' - i.e. no attempted
>     recovery & control flow, unless we ever expect these to trigger.
>     [5]
>
> So I wouldn't attempt recovery here.

Ah, missed that part. Yes, for this case, we do not expect the conditions
in VM_BUG_ON().


Best Regards,
Yan, Zi

