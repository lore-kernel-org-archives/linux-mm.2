Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52951C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464B56B009D; Mon, 31 Aug 2026 15:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC536B009E; Mon, 31 Aug 2026 15:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C566B00A0; Mon, 31 Aug 2026 15:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D59226B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BEDAA0259
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:13 +0000 (UTC)
X-FDA: 85162545426.23.533E431
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91C3814000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DqDalye/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204370;
	b=qxezqImdBq9Zxi3eBmpAfdsCrQJupGPZcpTt8KlsALb4SgG2KCCiH1kcEwxSiBU6E76uez
	3NZPhuwx9beJ+DCHAPFr4OOh2nVC7KWLOAYKVcjc3XBRxl4eskCFtW0B73NfM/qjVxSo19
	Ujo4YRgJNxp5a7vCirOHl0IQkbW1ijY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DqDalye/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmiS3zJ8+gLvEmPROyGfTdnP+5xIWzIJ8ixlUsSG0UM=;
	b=donLi5QM+4cbHbIDNcw93LDau4/6gAclPXMWJbpB4MtCk1/w8W7I9LYr0QQStH8c0Gj+Pc
	2XQv0i8+0zriqxhYpnsyyrTo2RzZsGoRamnIX1GVk+3DQ9aOrBF3NgeWsRItKMmGTkrMDg
	+LQh8iJKUOAD1YYJpElWDXPgH9BMenc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EmN/ODJ6Gr/3rzrPcdVrNkC+Ysd5YcWG4n8M1oe0JHRPlc3s7gIEueV0pEoMcTVoKlvtFZ+7Ys2oFNIdWb31ehWEfX9D4bEuKfq/QrOjkns0bKVuz7soIJzV5qtO5YVlBODsG6PqOrD3WZx7MGxQHgKAiFePCEVYko8wDgLmUB37YTebwfeTNG+4vFmOY1FdcFpt+H3yh0a4uGXpWBCzO4zy/shhcYXbp5q5pdMuBhHvFSrkx/w0PKpteMxSxmtag7JKv9YEB4xIH5Cna/7HilO7eGPvm5qXGNtx9pnh9qTy/w9nsJhSQmhYWRpc4kbpGneg4dJRDQxLqkUbUBeQeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmiS3zJ8+gLvEmPROyGfTdnP+5xIWzIJ8ixlUsSG0UM=;
 b=bK304ak/K2LzplCOYLPuiRDAuzfC9AOgI3nSicbkh/vVt/uUna8fMgR7zKHuIlhwgxNots7K1kiUMTIDZHFnAyDiejW2ibT1nAcG0xfWWyUNZQakJh/SMyM661EnFKCSn4kUYPRtrqp7S07CgdIrZ9fGVzx8OYZVNm7ZQ1Qa6KQaxXVLU3D0mGvl/1HWzpY+J61sPZ4XoMrD2nQ58545MBDtoWP1lM71yP54Yh9ijcRpPn16Ga6vDHlwK4u/E0wEgY+EKEu8ncpjyQ/p67v0A0Uixb94Yz0YHXwY6SPpUg2swd5UkyQv/q0XsPtO1YI3rf1QUIDhS8duHCKlGn3bCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmiS3zJ8+gLvEmPROyGfTdnP+5xIWzIJ8ixlUsSG0UM=;
 b=DqDalye//TN5IWfzMahUNHKVU4a77sPchgBTBFxsgfbmtrX2PnGGFwmouGjzpOEI6wLf3wgTK5SUgavvJVbe6isbIpojwISla8cxB3ht+POiQB8V+BEW/ByCgQefkNdPEriZxC7YQoQIqOMhNwtao/YA7eZG+cENAJczqQGCnCTRQM9vLP7yG/fMW6yqwJm6BbLoV/0qIRdbRntt2+NaiTAWogJNCmYEE3FzYQzSzhUkYMCb3EN/I25Y8OZt31a3Em6uF5ZKG5z22eVqxb/WpGTdVrIxYlCVT5zsxR9Ptrey0dSQhPqzGnXwTVhUarAXklTZCKG30i+6xK9+RtKhEg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:54 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:30 -0400
Subject: [PATCH v2 07/14] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-7-3668159cd9e8@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e162e5-4022-48ac-4630-08df0795a9e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	jNhDQFLuMGZ0W/PW+ti5tfP1ZOViw+BHkuYtLtFMYS9XUeSkYPJTX4sLMVVTj33r20AJMrmnTGSlhjLNrkL0yuhhLT0hVjLL5e5MY9ivjWKqpGTu1NghDXIc9Dol3F5FlxY/lgPFsvcbvmS5cOThDQ/Nb/hbLLhWYRkGodQqrzv7uVLU3PMXYNPDv90ktUgzVl/IwQeVyySOLC1pzOkLlr2KZUfenc06mXI+ftND+1LOuepZ6VfvX5941GRdODG8YyDCTFmPPq2cNlIsQMqlBKFz3E21DMMunYlQWXGhJ11tVkpu+vXEookTy/qSPvdJgnXfGozJ16x6xXto/JQiGkyGKYl1ZkvjWnVr7gf7kCUr77EpP7zt/Z/haovK954I7ld/cBeMOewZfhCHXPxeW8SwG8G/FsNeYBEapIeotDM9fB1C2PQEE5sPVGyJ2O60DSScqY84AwRNxC0bKGvguLL2ZTtMmCULNqVVfDhKQAm/h2vvBAo/W3aJjYO83/pvjjexGVE6OitIZlGGeLMGRA4CJnSG/d8G/4NqE/x+It/aSpyJMMlvlf5IVajkGtdKxxk0WbSWxwZ8OBOvxu1JSifnpDW+ghK4Jx8UUoA7mih79gVTmuu5iZVyu7cpAnCyg9I9BaMLOE9PH2Jqx/Ed/h0UHFGyKwvckFo6wJrYqAkN5SuNY0d4Q0sNmkhMrs/68u4UtoE9TKgGOo7rHei9+g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkhuNk9WWkQzc0laRG9HUUFoanRYNGRoMkNLd2I0MDNaZENwMWdEL0lDR2dD?=
 =?utf-8?B?RHdPOWZEQW8rVEFGN1RwU2NZcHNrS054WFhzVGN0cjRUZ3Bic2dTaGNyOTVi?=
 =?utf-8?B?QmM0dUcrZENSMDhYa0hVQWZYbEwvbUU0RkpsRVE2cWJvTElBL1BIUk40c0ZS?=
 =?utf-8?B?blUzYkFheUFKRTRnaHlPcytPbjAzZW56c0NxRFR4TWNjSUR4eStLUzh2RnBB?=
 =?utf-8?B?c0ZhVCtHWXk0dWk2NHdCOW5CdWQzVXBINnJiUERxazJoMmRoVG9jK1VJRTA1?=
 =?utf-8?B?VTQ1N3JZWjJWd0pnNGZhZXBiY2F2SmRmdVJvWjFDNFc1bE9BZlhXSmVSZHh1?=
 =?utf-8?B?S1hDSGtnWTJoSGZzOGlJQTJMeVlFcWtkalFOSGZFcWNwQUdvS215cjZFNTcr?=
 =?utf-8?B?dFc1RHlMRVRxYzZjUWRmV2xidGpzb3Q3ZzU1RzZERmN0cVRXYm5Hc1F3aGJW?=
 =?utf-8?B?SUVTclByWXFXZ2Q3VW1HdkwwbnVpZ0VIbUZxV1k0YTgzbGtBdEJWYUJvSW9Y?=
 =?utf-8?B?cDlmemlYaENQbW9UVm0zcE1aeW0zaTZETW5PdFVidEZQc1hPYUs3amNsU2Iw?=
 =?utf-8?B?bFgzeE5RMk9FNm1ya3hSV290UUZrRnlBV1lOMVhhQXprYmZMYmJKZm04eVJI?=
 =?utf-8?B?SE1xVlQ2ZE1ycjZwd2cvWG1iUmRTUkJPNjBhbSthNnJKbkpqS281RXlQSzRW?=
 =?utf-8?B?TFdjR0l0TzJzbE1OcjJCWC95N2MyS3h1aVdsYVNMcE4zMUkwYlhLcmw4U2hY?=
 =?utf-8?B?K0dzQ0tLZ3lNcE5XY29UQ0NidkdiSEN1SlMvTnZiTTQ5RmxIR01yTTFQNDQw?=
 =?utf-8?B?Nit0OUQvQzNoRHB4dFVvdllmVmNpUk9KaC9DUDVDblJJOHRUY0NLa2lsM0Uv?=
 =?utf-8?B?WVNzVFJUSDB6S0NhbCtQRnpidTUvRm9ZdHFwTEZnQWI3OWFVUVhkYy9veWpv?=
 =?utf-8?B?VXMzY3EvTUlqTGVpTjBCR0plVUgxdTVZcFJnK2tVbVZtYzM5cEFDc3dlZXdV?=
 =?utf-8?B?b2ZTT1ZtbU5GSTJSa0xvS2hJdkhJSSt5dmRvU0t6aHRTRm9WVjRDLzh0eEJS?=
 =?utf-8?B?cnJxMEdTSERkUThUaDM2NkFERG1EaVlycnBYMVpJUTFmR0RJN3J6NE5HWHFS?=
 =?utf-8?B?NmFvWEdVRzN6SDNuWGs1UlpJc0wwYU93bmtOQ0QzRUV5UktzbnBrTTFaNkM1?=
 =?utf-8?B?UU5jK3hQVXlKbzd2OXEzbURjNjd2aFJidUdUbTlyWUU4TERQTysrM0lmRmhZ?=
 =?utf-8?B?U0l5eG51S1h5bjNkZTczLzFrYkdZeGljUWhWT0w0SkY4VWY1a0w1VisxS1N0?=
 =?utf-8?B?NVA1QW1SRGV0NzF6R2tYbmRrSmg0Q2x0RDBnUEJoK2pYRkVrdHRxT0NsWFNQ?=
 =?utf-8?B?eUhJbzNJdWcxcVRjUzdId2FHRVlmcFZqeVlVR3BXNFVEZ3dDVXFRaWZnNldq?=
 =?utf-8?B?MW1wL0ZwUzR3ay9xQmFvTjlNcHVHNGVnaFpUNVNqVmhyNzhBT290T0RwTVYw?=
 =?utf-8?B?NjdMa2J4b2g5Yjc0QW1zdXpOaEUrc1BvQVVXbVU3YjRkNG1mU2pSS240emFh?=
 =?utf-8?B?R1orY3VDNDVDRzVHa1VCOVp2dDhqOURXbmh5OVgxb2lyLzFtR3pRc2daK0FY?=
 =?utf-8?B?Tk82NU5ZdUY5UisxdFFNeWo4V3UzTnpRRlpIR3J0djJZQnplMWN4N1YrNDBp?=
 =?utf-8?B?MUtaV2JTVUJKeUpBTi9WMW1EcVFHQnBURVZQOFhxNDM4cnNrKy8weEg2OW1P?=
 =?utf-8?B?WUk1WjhMSHZxL1dIQWRPQy9ja0NLTU45VDI0VUhxRjdpSEJTN0FkM1RhUVVw?=
 =?utf-8?B?SkJFbnU3ZUVHeGlEUTh3bkdQYzYwSTRkOEhJT0NWa0E2WFFOVVJ4WVhoVE04?=
 =?utf-8?B?cWVhK0N0eTBYUURYWVhjaXVWdHdlVzd5WTZLWWZlMjhFM2kyN2dwUG03WlhP?=
 =?utf-8?B?cTNiWnhpdVlzUUNDQjZyRlN5UGtDOXFSanVPMVZLejF6ejNzYjgrVnE1Z3Zs?=
 =?utf-8?B?QURZcUZmb05yVGJVRDFpdzRYUUxYVW9JT0F2YWRxV0NQMjZvQ04ycHpMREF5?=
 =?utf-8?B?S2VLdFlzUUhjSytMZHptcG1XM0xZNFhyMVZaeEZYa00rcm9lSHhsRHV5QndO?=
 =?utf-8?B?TTZ0T2VoR0tQc3FUbHlmdHhWV1VVa1VSVXdlMnZTbnR6NmxyL3BISWVjRGM4?=
 =?utf-8?B?YXZkbDI2Y0E5VHFGb1VRZVZUaFNBdGE4WHJxYk0zNTFCNFdDaE9lSFdUVXk1?=
 =?utf-8?B?bytKVGk1WWVRUzdNVkEvUjVCRm9GUk13Y3dvZHBSL25ZS0t6UWI0enhldEYw?=
 =?utf-8?Q?10zWh80V2EKn2UN60w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e162e5-4022-48ac-4630-08df0795a9e3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:49.4268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ITzvUpcuLqw4Z4h17eUYHhm72+ssdjwcJUyiMPazmzrjAHRZRCzilERskSKvkZW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 91C3814000F
X-Stat-Signature: ucdx3rqtu3ekwybsij5wbgwabjrek693
X-Rspam-User: 
X-HE-Tag: 1788204370-283511
X-HE-Meta: U2FsdGVkX191Nuc8kuq+vPq7+/YwYaJKSPC1B0uiTwflBlPTFQFuSQnRes+nMZCXL7MyHAcWrhIU1I6O1nSmlsfFg5Di2w2w9/SoLiguJORHJZWkUVjukCdrKsQnfw1liaB/3/AH/aupmkayHJTZFz4ft7lvSaBeBrgSUS42DY+T6jPnmazPv2yyV5Rt6wXa+DmOLX5z5EETziaJQYGTM0tIpoJZBMV7WbhucVx3BsKcPht5vTZnOvzc5OJsB0tNisR2xZ68F3B++7l/87TT2o23rEaD9Cc6MTqbjMU6i2LgSVvEsMvYgGtcn6JFQ2da9A0pcZD0gY7alfUlAb4rnXy/N4pjXjKHdo2kz3ltarjnHpq/vGuwszG9QMHCXWgAywrBFyxuQK5aN05zww8M9c66pte4dErVY8uCywX1cn3QaEUgg4dr5vIsNU9B1G3NKh9CRD6THrA+REvdJiZJ3VsM3feMN2TjqXgZJ3MJEE8NezAJOHKhUDKFFkzkHhWPGTRRdDbZFi66TRAhrxRuRUDkGgOpnYjA1Id+SfyUVhw82VwTd+4Moih6i5YUQgE7NjdUApPLosZnsx8rqf7IUTo3lkPez/IrsQHEKskFwzttgI3DqND/tz4moSNSmGYeMvSefWOHWboQ4nbfPtqR0iiUa+Ih2VdXEpXzrXv2aeoCMBaB5GEnBGe52pzjG0ACtTIkm28DmL2V0RhG+CVGrZMhq4QTv9ULnvjEYAJkh7sNJdP5UxyyClA6OlqHR4twkojCmhNwL89Wd1GMkDLwsAPVlonyASgVJgO/I5oCyr3euQZsWirM/QRdcNFeQrodgtfonTzFvk3+LC3rHgCSpFxRmswUbQcEdA70gIaNdCOjSvdxZs2HWQFskdxQJYh+4nZ9D5xasC7N4+5X/iQoIObN1roTiB3gcVnPfiM8WyO93+LSCPTPkn+Xwx22JdqBiV4amHg+DbV2z2waujH
 +meeWwfn
 F9YT4yob17SaYBVgkx5PCfb+Mk1SW045+r9d9j08EF7HjddyUV9BJ+E2MQntfmFlpJBH8fRYrJv+JjljU9bZ7QAKTKKwHg/q2nyLEYKF7CdQvpp7BSVqrHGtmfOsaGwAATYMtP4scHdGweGtdO7KzG4jgjCvY54gHjGCjzHRjNQMRH+O6BnlyvYCv8JYLDQn5ZCREEXF4NkoAD1AWJBT/nK92GfSetxkbhA5DiS0sgsG58ZJF3vThqNNLoO0TVhDsKani7xi9LkSUELX4nHnwMr1lDurzpCzPgRDuIYT37LOE1C9ri7Q9zLg+4yljzP6mzBOlbTfEXjf/XV0/mZca1zIb28eLV92+KLDOA2bj/yvGCmMMHkRrOxpGjPclmlcipkzVfoHUGCCQ8J0LHYLgnhlWiEgTV5a3ZcS+9PC4l+XHgpwzoDZNDexMMEp8HYGIaY+yqLiWbQL4o16kToT5x9HEjgCCEiDI4zoh3Frcap5jV+PcbwqHJ4BmthOKPSI/LboRwc0gymXn4oomDidBswaj+tHsiAzYE9phq58zoJMIOyOJKltkoxVzneAbg7hzHs8nd/3GrHWksByXh5tFjGNb4EmJBsGDEMeEvsUA/eppzljXwNrMKFwWaoe/zwR4s2hcAIT6CwcrvGFN0zE5nvN1bvVUgo7L+WzYNwkZb85uOH54oGV/Tc8FuIWMgR/HDqnFs49CDwT0XpnF0JihplIfT8CfKN9V3QkpLLAI/ifzoB97OSdt2Hso2ifhpkDr88CD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

erofs needs to traverse readahead folios in reverse order to achieve
maximum performance by
1. reading all folios from readahead_folio();
2. storing the prior folio pointer in folio->private;
3. traverse from the last folio to the first one.

Add readahead_folio_last() to achieve the same function without using
folio->private. __readahead_advance() helper shares readahead_control
adjustment code among __readahead_folio(), readahead_folio_last(), and
__readahead_batch() by checking new private member, _forward, of
readahead_control.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks. After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 fs/erofs/zdata.c        | 13 +++---------
 include/linux/pagemap.h | 56 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d1904..78fd7d980e957 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
-	struct folio *head = NULL, *folio;
+	struct folio *folio;
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio = readahead_folio(rac))) {
-		folio->private = head;
-		head = folio;
-	}
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
 
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653d..546e987d5cda7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1416,6 +1416,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool _forward;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1480,18 +1481,25 @@ void page_cache_async_readahead(struct address_space *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->_forward)
+		rac->_index += rac->_batch_count;
+
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_batch_count = 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ractl)
 {
 	struct folio *folio;
 
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -= ractl->_batch_count;
-	ractl->_index += ractl->_batch_count;
+	__readahead_advance(ractl);
+	ractl->_forward = true;
 
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count = 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
 
 	folio = xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1517,6 +1525,39 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
 	return folio;
 }
 
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	/* Drop the previously returned batch from the remaining range. */
+	__readahead_advance(ractl);
+	ractl->_forward = false;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count = folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
@@ -1525,9 +1566,8 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -= rac->_batch_count;
-	rac->_index += rac->_batch_count;
-	rac->_batch_count = 0;
+	__readahead_advance(rac);
+	rac->_forward = true;
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();

-- 
2.53.0


