Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643E9C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDBE6B009E; Mon, 31 Aug 2026 15:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C696B00A0; Mon, 31 Aug 2026 15:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378B86B00A1; Mon, 31 Aug 2026 15:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFEB76B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 516881C02C6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:13 +0000 (UTC)
X-FDA: 85162545426.18.5211495
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F63B160006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j1ymtVBr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPJDDJcKa9lvexi7Wypu3m0WvDuY+EowhGLAL4uORvw=;
	b=iP/ri3LEDU5wizwDMzsbSi6NYH4x9cdU2B4pqjlDTX7toNbqjIsSbAYhtKkPq4Y1txZvpl
	Xg/K6XZHGz+cDP+/hAThAOJSNn5W2euOcb9jUTcJxBdTDagNR5hPzjHFtsQHltX7L6f5Pc
	zke25kACfcN70Sx153T1QcnWDFV1miQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j1ymtVBr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204370;
	b=7hdWdiNtIlY/cebYEDII61vPMo9/vizUs02gEfo8zEbc7O9NKh3MkyXWNEMpOYXSPUtYRp
	vHHdIN56nqFnB/m6d9QIfvyYnsTW4zlM92XKMdEHpLqMpmyUBiwoXCD9gdIZHKKWUXZjWq
	WeKOMP+7pPARbSKEW4PoaV8rHyzUjT4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ddbMxkwfQ4sBexT5Wtffmk2NaD8EcxHuURhMU8etJvSFf1tIvdeRQj7+d0Lf2x/OlgU0EIkOFc0u1lvI0DutAC8+kHgXWApf8p55WyRsK+5xuYYoX5SR6PITRg+PBbfcgEveht7ueduv/+d1kkVeHbq9s1n1KmsH8WWNK5kVYSzQSuLds+4LQ59cvFoYkOpb2+oa+oa6zlEE3TiwvwzvGEVqbOXHYBHGejSezjxKR5pkS3E1WHWbK5qlIMg2cTXDa9u/cJUVtpGhtCN+CKSTkiszAcyzw4VHQ5mcpXrwNHhMJbhmb79FSbbspGmrDb2crbdoZsNDhizpEQc0DTGAiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPJDDJcKa9lvexi7Wypu3m0WvDuY+EowhGLAL4uORvw=;
 b=AdXMfwAYaQIl6uTt/PkVsIeF1mRd+Dy3VBRxkXdRv0vR4hgMuekizA3zucp8tk6nHqCsI1I/WVH8bObrrSx6h07CTp2p3yef2eDt+j/tcX760f45a2jb0dnG7TEyQzC9i0CABT/zjclVCamI10gRpeEsGwj7vbp2bpUmDutzOJyzMbTJDWW3P6oLOU9ZeGXK66UvQWV2GZoiaRlSTuzPC33d3v11RAp9lOW0RO4Ud/2v87opz2KbXmUUA3oBV6VkB0agFNl92svE9KEGmwXepNrb1xKemhPH5ucj0pXOrfgEo5zqemzSUP5AzhQRJ131HTw+QSbNMyE9x5RIt9dCUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPJDDJcKa9lvexi7Wypu3m0WvDuY+EowhGLAL4uORvw=;
 b=j1ymtVBrZKTRb5u7ro5RNr0iGxETNsm2rTaR2VYFnzOuRuh2/ZX9LD7d7AMj+ZylYyK+KFxWKZAB0yh0ivcV75HmWjl55A7nzCHWozvc2hpYqZU275EKpcxhYvRMP0LT9z1O/aV8yxPyqkmEYeM5L85WPMYnRMHELGPPRW0tmeCpghzc+QhZ5RxvC4SNX77KyoycF/yMo8oti/F+U2Io1ixfnxMDeGpK4m1P1u8JFHZa+WJzwhNVMecjfvIKnl68IaTcLktbEQfwl6MQIF9iCrIx/Fg3vsPyNhjH9M7iIg6It1BLHpju5oWGNXeaPxNsAyVNVDSuYH3/RNhzOHQwrg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:50 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:29 -0400
Subject: [PATCH v2 06/14] f2fs: stop using PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-6-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR01CA0152.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e44d3d6-7e27-46da-673d-08df0795a8e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	yrYgEWOvIqv0iriZ5z8SvtfyHNzNWThtT8NrOO7iVBrtNSoh9xV/wuHllwTxcK7ShETe5GiC1YWUmPrOfmcaE/mfKN1SbLmg4HHHs9uuEWBftm2HBNrFv3wjQ6mrLnHRv5VnRyuYFS+DUTwl7IrRCbJJaN0kDRVOxqKGMkGShRujTFV+9yZY59OYslZ31RfdzbqouJjneDIcWbF8VUP4aIgyvggB4PkYBVyVqBNNxy9Cn9MyxGAIF77gcph+969EuKiSE+sPoKR2I7T+dORub9+Khr3FNFYRXwlYzkjEdpE6CCz+UHwoWZrZh4yx9oWpqjATW3tQrPhlapbqGczGBRfm5arjz2nDqTLILXFF2Q6UA0OJ5nC+ZQO6FyyxmWtZZp6MW2c+KDq4101y9atBpYBD3r0KqPO08DR7wb+GfpHkwv/hgmUeqfWkY77P7QS7mYtt+QQzNOfL5WKUsJvHndN3g2YLRg93nbRwqyjeDAWbARtLBaF7eDc5gjGmJKOO9MJQFwPac75rrfDrpwzU1U48WDse1H9MryaR9sEdL18qc/IUZwqVCw3xa67WVAlcPj/OcKDAZ3B4bivn1CSY1w63v4l8xllLfZyOHBOXcWtj24w02WJfsRzdOSXIjAvSZ0bo6ZrY7x4sCsShV9RWqjzAskVt1jjtLBSX/1RPefvv8sluJcjgTwAbGs5sWDE9jreN2rfQdKx7vdjdXMQ7fg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWFaUWRLdUlDZ25CamxJcCs1bFNWbGRRdm5OZVFoZUNhR29KeUo3ZmNxeWFE?=
 =?utf-8?B?bXVqQ2JLSk9jQk1pRW1UYXQyTllPcFlrbG13N1dneWgvSGtJbHBlM1ZGMTZj?=
 =?utf-8?B?cGhkVUY4K0ZITTVlTDNUWDFLV1ppTE1SNEFuYktyblUrUVFhRXdmejVwWlJr?=
 =?utf-8?B?dmh0clQxN3J6RXpVSWlNVjFGdkQrcTZiUldBZmxzZDZkTkdNeUlPdFhwd3lm?=
 =?utf-8?B?QzFhTGVsdzhUWDNrMEtaMVcybmFFMHM3YTFpa2JheHJoWTlIZ1hOQjU3NFZw?=
 =?utf-8?B?Mm9yeU9rbStwVnpTWEloTU9TditDM1FjM1E5dmgzVkFSeERIYWg4UWhtNklu?=
 =?utf-8?B?VGFEU3RsRU1lVlJhWjM1anB2YUY1ZE53RkZaNHhrM29KQlk5ay9GbUpNcDZ0?=
 =?utf-8?B?MDBwcGV3UGFyZnhXaXczK2xldmhRYVJNcXJBM0VRUzBZUVJmVGVtazE5QnpC?=
 =?utf-8?B?bGdRWmpiQ1pTbXBtSEI4RGNsSFlJdXM5UUc4VWJaeGs2TGxRd2Rmbm5rb2lx?=
 =?utf-8?B?TjhnblRON1Z4dHdkSlBGK2dnWDVrUEpzS0xZcGxWVGlsQzJhUUkxMlYwM1ll?=
 =?utf-8?B?My9oQzlKcG5kQzRHa1NyVjlWcHZVMTgzS0xWK2NWd2EwY0E1WFZhbVZsSlhx?=
 =?utf-8?B?SWY1aGN1YitFTlh2MERHUDBWUkVrTTY4MXlZdGE1SFg4MVp6SlFCYWt4dFN3?=
 =?utf-8?B?Q0pjYnpSS2FFQnNveVB2cjQ4TktINzlqZVV4L3pNY3FNNHJURWFTL3pDemt6?=
 =?utf-8?B?ZUFJYUNZd0pUMVd0TnJDck5UQzJHYVRQaVBROXFoTTdOUnJNNDZ4U1l3b09N?=
 =?utf-8?B?ZWh1d0t6YVdnZnVvWDM0YzJLMENaTFdBNGUzSjRTcXlYSEp1Vy9IejFvenZj?=
 =?utf-8?B?MDNxWWpnTWhENmNTWnJMRVFueFJRS2Z6OS80UmhoZ3VlRmcvREJXb2dVMHQr?=
 =?utf-8?B?M3JDNzMwM2hBemFYMjNMUGZXa2hQcnZZV2dNcDVna2JHcktNcnVHMXM0MExB?=
 =?utf-8?B?b3BBMm13OW0zSmN5cXhTOGdybzR1OWc0Zit5cTl0V3E0SE9lUXdFbG8wa0Z5?=
 =?utf-8?B?ZWJUcHRQWjNJY1FwQ1FVQTBlUnlaVzk1Zzc3TjFqYWxuM0tHQkVIVUlDUzV4?=
 =?utf-8?B?T0NhbktsdGcxRUxKdjRNS0NucXI1anhNRUE3L21pWEhSWHdlVzZIME5mdEE3?=
 =?utf-8?B?L0FLclZTcDNVRTJJVlF1eW5WWU5oRkFaYmtzR1QrV0xrTGJISzIxcU16cTRs?=
 =?utf-8?B?SHYxWlIraVhWQy90UGhnMWpXaUxra1R0a1c5Vml3NG84dkUyZnlwQkRFUzFT?=
 =?utf-8?B?NVZsNENUMXlmc0Nia0pjZi82WTBCMDcyQnRDbS9GNTdVejVCZUhlUGxUWkQw?=
 =?utf-8?B?N1Nwc3NaNXJPL3FJSWtjVmllcDZORURMQ3drb2NWWUxYS2VnVjNyTDhaUHp5?=
 =?utf-8?B?OFY0dVN4N25Tek5vVHNFT292Yng2bE11OEJNcUpHb01pby95b1dzckE0NlJi?=
 =?utf-8?B?K1lzOGl5QTJsZWNvdHBOOWhhajBRVEUvQk5sc045cGl0RUxaeGJyd041LzFI?=
 =?utf-8?B?dnNYbU1OTHdXenVISjdyL2VSUnplbTVZMEFBcUppNGlZMjhqaHd3T2k4WkRL?=
 =?utf-8?B?aC9SRHpIeTRlL3U3VHk3OFJSUWJSV3BBeFNHdTl5c1VNUFNSd3FQUzZTRnNJ?=
 =?utf-8?B?NG9wL0VZVm1Ndldjb2FrYVRiM3R3WmluVmRYN1VMK29QNEFiV3d4Z09zKzU1?=
 =?utf-8?B?T28zcFdIUGxYRktta1U1U2szZnY4bU9IcjZjL1VONzVvbnFIOHVZQWk5SHhX?=
 =?utf-8?B?dEM1aEhwTExzcFVvNVRPT3FpNTJKK2xBV2xzSzRTRnkvS3p4OGVuMzZ6VjVL?=
 =?utf-8?B?cUw3bnY4VkdvcVpiY1JLNWNDaEJrbzEzcWxXakZMb0RRMFdiWDNFeHlJTm1W?=
 =?utf-8?B?a2FseW5GTFY5SVIyc2VGT0lTMVErUlhGclo0MTVSdTZabnM1cHBzTEYxZERX?=
 =?utf-8?B?dGtUUlVSTTFyb3M2blJUQzdTMVpDMXlLU3kzN0c5M0VjNm9CeXRrcm9makxh?=
 =?utf-8?B?UU1GRTNtVm05SzB4Ni9lNHM5dUdVYWYwckRLNG50aHFPcmZNRE9XYW8yWDhw?=
 =?utf-8?B?TG5NeFpmeUtEYUtTYU9xTC9JVVM0cUh6OXk4cDNTWW1BdDdSbjRkTlRNNktQ?=
 =?utf-8?B?am51dUhTSWRHQ0ZuSlBKUWF2TGkvOVlxb1NtMmNkc1FOM3dHd05tUWR1S0Rs?=
 =?utf-8?B?dUZCM1RDU3RmOVpsekhkQ0p5VUVFbHV6TFJwTnp4SEZLMGRQVE15cFM1eDBL?=
 =?utf-8?Q?K2rt57nUk1369xtLxL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e44d3d6-7e27-46da-673d-08df0795a8e8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:47.6611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fK0nlask0fl3Llr8ZeIpXxLcy3oOfUwyXTcL55SHI6Moup45u3qsqZIz9d4/vQkm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F63B160006
X-Stat-Signature: exq56wa16io94qe95tn47x11k5tsw3g6
X-Rspam-User: 
X-HE-Tag: 1788204370-678594
X-HE-Meta: U2FsdGVkX1+VmYW6uH1QU/CY50nD7Tae0FTYK6v7WTRbutyLAswV6j41jsXAeWRgHX6y4k7YWVe2NWxrFriyKDpSbZMymyYqzr3wjBXuKpxKat7k3s6XQ7gP56TouUH44egh0irJ1TCi0I/tt8G/0Lfd6BJh1yNtdSnwbc0CrKA5tH6tkA9HVHQnQLZ6PET5m6hwxdjm3l0jdOS5W4klJocQPXKkAjg5K9jg3ItvAetLa45SOYwY3nc73si+YeMJtseREPEsUTWxHLiIF6Hw6vqDihusUOkZZEV4YWYruYoU2oRpbWUnIzCuaza9eJ0ImDPl4icCUdsfZI0aigCTQnKNuK0rhr/rAhPrTTCuA4u9B4OzxDx14ZUFN4S7HMaM4xt0fP2Y8McRPo+6I96lvDw5+mRT4FKwtblZFGLo3pmV1QKPtP/i+DEGV0xkXTX/iJYQ+F7htENSXqwSEMKqcur2zizz6My5r7hjuomVFYB+l1PhmyED+cS41KeagC8SehY208yWLXWgalllUiVfcB7967WdPAnDCkg5k8KkE8e9Y/wN+bpXyg15TvI4HBzF/J6E6KDnZvnqk4ZiA51/SW/QYKC/whtc5EfbNnAm81ilF9a6wsKMkmhLxc2DEJj/i+3yOjYhDn+ZcDfeaBcbN4vlBjekLRlZWWpdEkprAlfUp/whJegOtVivQPbTddwD9dpJ272dHkXiEFk2WtWOmfPawWNeSa6qG3yvm6kI5j5nO66rj5/uHvq7h8ZLK6niM8UaRBtkolf/kYD9c1QsHNJuPR5vdGQpZWqg6biFNK7knebyggjkvgZlynQ4tToDN7JnOaB2s21DzoOqlBISOe4R5y/PQqUGcLwCDaB3IVAPHRODTA3RrJ/7g+wiY4N9VlVaBvddChavfjJyrYIWcYqVHQ9mV+Yn9rxHCx2rovHII+nzj0+ZuPJl+jqgFeHDIuLrdcA9KnyffUNRn0g
 kDbo2bpi
 +hrk3axKtJiAMd9KrtzUSrYh+/18QI5BlpGtmtw7P1b8BZ9PCL2p67i7dkrYG3GPCU+1itZYFPsZ9HhNSPfEfqHrr5tKWHGsG0DvidtCLpWm/62NfKgK4GmShAjgR/bKHpz6voK56i1rNgPu5da99R/tAqGokF+3fCkozV+eUP31zmsaoo5q0WeU1gMX+2/HBNzmm6DHsySxgWRgsq7Zz3qqAECjdPIwJ1r2Ipss6GQjDHHw9EMf6kwY2KVHjrWXc7eBNKZjyioOLuPSMDnwnZ5YyDek7uFd2r1gVjksDeuELLjACR5ogKvIPVt8QMozspCQ0oYyM2a60Kpv79LxJ09qNw9B3Sin1Rd9ZgjDZTg0iFJTGu3NYIcfHyvxT+1AAl6PsUSvAaeLFHP1bRODvPzIv5jDy8g3pMOpM8WPLUFv6kxdXfRzMQarxWusxnQBHy7Lf+fxNEUIrax11/b39dG59gDzBRtRoE4gCkMcu7yuH0BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
page->private != NULL is equivalent to checking PG_private. Change
PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
but it can cause confusion when PG_private is removed and
page->private != NULL is used instead. Change it to initialize
page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
semantics.

It prepares for a future commit that removes PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chao Yu <chao@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/f2fs/f2fs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9940a6cecf1a2..2f7ab5888b078 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 }									\
 static inline bool page_private_##name(struct page *page) \
 { \
-	return PagePrivate(page) && \
+	return page_private(page) && \
 		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
 		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
@@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
 }									\
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	if (!page_private(page)) \
+		attach_page_private(page, \
+				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 

-- 
2.53.0


