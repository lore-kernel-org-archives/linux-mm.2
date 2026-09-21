Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13E6C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5E26B00B9; Mon, 21 Sep 2026 12:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C726B00C1; Mon, 21 Sep 2026 12:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7553A6B00C2; Mon, 21 Sep 2026 12:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46E196B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:18:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B366314021A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:18:32 +0000 (UTC)
X-FDA: 85238277264.06.E6697E9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DE40C000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:18:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Hf8TL5qk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790007509;
	b=B7EbndnkSR5Lzt6EBA9V3KkIJh6mWUioAVQeJysoYZ5r+6Zkap2NtUpFfXmhmC+KNZnt2U
	GU/WQXTY0oonYA4/JKToN8FNNkMF2fitcdz6dbZWJyqxdXUyh+Fee/r/sQ4kajpHLXgzEa
	kNgifDWgyHGQzeapFmbWpGAQ9D3TvIY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Hf8TL5qk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790007509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6j3Gx+2s8BaYFzoXW0hHjDmoZn5hVdxcxjlzqJX7uk=;
	b=uPLOkUFRBCepNhIIsSTNPYF4W+Tbm1FigWkPWO+agDJOrA8q53MdWAuMfZwFLoWnj6YctD
	8WeeIIIBuA5gqvpZUGaqSDSVs1bSOvq4Jw8hPkG/S9C72YiZ54Q1FLxYlhMMmxEu4xkYjK
	dtYKHQEJAc2as4nK2lIYH05cw5ImreU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ka7QPKPqwaKmPp7EpWeB52chPwalikFUpXRQYdHD94YO44lIkrGgIyJROUeFbRiv4ORwjUFo7x4W9YwV3gUWC27TRo08CHV7r71OkdSh+KHXwh5zqPIbzfxq+aTmZfZMHYiMAlc8IGuz7V6wQ15k7dIor+9DCJB69854cKY2+Qb4pgnN1TbblKRze49GuQ0r/trIqVBXdLrAGSvOVHRJTOye+nLC8uCLzhDBcGObt7mtweSKVL6K2cZHlbalWGaX5d9F12PM5wgxLSrHFzwanEhxHqmvRkBnqFTitZOMYRzYFccR0VQXu9kvRFjv2Oh+qYr/3G5ahSMKCUjZ8zE+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6j3Gx+2s8BaYFzoXW0hHjDmoZn5hVdxcxjlzqJX7uk=;
 b=lLF+rZdF1VTSv38TIowazCB51kOJzp3gpB50N6JMgpC4kG4sTRkykjDt3iC/5/tOl1pVFjl5r5KR7eHp7SR78BQ5jqS1YdbcT/G3MsoOA4YGlStiWhDlhmySgh35+JXDTEHdOLuJvcE+BPnDvWfKvosdQwLaGXSlcBB19LZjksaf87VZJBcjP759p38Qy87WqxGXijj6ExSMk3ZmU9Xz9iTL0QcILK5l6LJH/fVWJtyBPknhEcn8iglv0ezVPd4fBHRiCD6GIWt20WkjWsFWLJtfipKfg2ENQ6phmo4WeirxQLDr4u7Ip/ZjZSlAh+PHWho6FNzsi6c2gnrrTS1DlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6j3Gx+2s8BaYFzoXW0hHjDmoZn5hVdxcxjlzqJX7uk=;
 b=Hf8TL5qk0ATp25JraRJ2RstlpfOSEEXcYxSUVursECaq7i6U0QguYUfNxX3U7Z1epMyAr14Mll9LkLtMhl5gs4o9OFR0/gflFHjvej5fvPPuTQVqVFs6HL+z0Qd3HcrSFv9hxNlJe0+utEZs7USLkj8+M+YpdcR5jwdAw0ODTZMTDOENYP2KbfX21sFlOlIw/UXU8NmfIEcB1vLXV/jt6M9B/GLV2q7/ZHsXigG6mEDXQxAUpYbMGmIs/8KRi5LzVVrmpnxO2i3qrsQRErtL/bNz/43mRTlALdUwJquyh7Du2vVzcjlVFAvHDiMW7W1QpDFPMKpiDi9t4lXhqCCDeg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 16:18:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 16:18:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Date: Mon, 21 Sep 2026 12:18:12 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
In-Reply-To: <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:408:e4::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: 671e75d8-e61d-4461-cc40-08df17fbf037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|5023799004|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	35M4bVUxS6xHm0HVdle32yQ/42rEmGMQHKJiG7pJzxwZaD5pq1pivrnvaWFanUVyL+UCm+IsPl12f1PGGycrKUindHeitVlMWsg0RGVpZkxO/gImCpC2T3K/BZQ4S0vt+Z9n5V2TEIRp/kuU65Vm4EL7faYalHD+dmSCcZByIWEdD4xy+f9PaiE7S2MFmE0oMxUVH811yljO2SKoxiDhVRLhFGzAj5dPMQhTEzek1Vis5hpECBU6QsrFv9AX51/HEnr0fKJScTqPM6hucJv5wCbn7zkdGC3DgVJcbseupaIHzDbLOolK4Fu+1hwOjYXUU/v8oebzz/jMQifjM2/+lmpeUIu+lbmM9Vl2dYo1Njfzw4gq5OTqlqkfqDDZLEtZ3Vad+G9y/VfddLE4uh65Vux4+hzVD2Jngahivg6GrAResrpqEtgMs+A8kdKWoZ93/pREn769vLoDkUiIGNRcG1o0ATy5ZMlbXSLUw9Oj5x7TZm4RpELoGqhMFz7S0mlcgQjfeYsuAG408Tjlk/SFo2snMLaIcOImaPUY+c5URtux6hw39dDhI52Ctegb8ATGYtqGgZNfo/GzwJNfjbxJ/p38dUakkj+jnxv6IiN6200cNy+alvybVdGvmfHvld6qWKK/sRWvWR4ZWzTMwTB45je33cGJ0h485oqGgiqT4/A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(5023799004)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZitoVHhBQ0JZMzZlbldLRFdQU09FSmMwV282bGQ0ZUgvb0RjMDBTbnM3WHQ4?=
 =?utf-8?B?ZTJkTHdSQWZZakhIR2grY2xiWExPR0UrSlQvV1NoczNhQWdiVmFIVjNoL2pQ?=
 =?utf-8?B?UkR6TTEydUdWcUZaOGcrb3IxeHkveGZBMktwR0wvcWRzMlI4VTkwSG1XNUZD?=
 =?utf-8?B?a01kYXJEYWkzTHJhQkExWkx0a09jamsrLzNtTUltQlpuWlFST3I3NG1IYmNy?=
 =?utf-8?B?SXdJanhnVjJsL2ZwMDRRWGNMS0NhRitDS1NCVUd2NUJIVGFBenZkMGN0dW1k?=
 =?utf-8?B?YnRIL0k2T2ZnWlF5cm9QeUdPYSt0R2htMG83WmFzenF5aTA5cXB3dzJaa0I4?=
 =?utf-8?B?Wlg2MVRRWDVXb0o0dHU2UnJScHFQSmFNY25RMWs2dzNlSmdPbVVDZG05OFU4?=
 =?utf-8?B?YTRxMVdHT2FqK2QwcVdMcXNhZVBSMUh0Q3QwNmN3VFVrL0dNWEUzdXQrZnNR?=
 =?utf-8?B?TWdMdDlrOVlSbHFLQk50OERiVE13UDZ0S0s0UXdNZk5oVW1Gdnk0VlZWMXox?=
 =?utf-8?B?TEVPY29NdEVRcm5LS25DZFFwMmRpckdOaVJnbldPa1F5QjcrVWdrZmdTb0c3?=
 =?utf-8?B?SUlLL3JDajFFVnljaHlEWnNXWG5nYkh0Nk9rVDlCNFArVDdheGFnaVpyVE9F?=
 =?utf-8?B?emZnY3U5ZzZHYUhzbndSUG92c1ZMT1dQcFZSQXZvRGlnaTFXUm1aYjF4dnQ5?=
 =?utf-8?B?L1RoNjZTdWZGSlVqTUpRNjhzSWM2ZFNNVjIrUnAxdzV4bWZ5cnlUVENQa1A1?=
 =?utf-8?B?SEtiUEo2SWsxQUVvbEZqVExGWTJoSTZKM2tQS1pNd1pSWnBLakY5RXZLWUQz?=
 =?utf-8?B?NCtManp4UzdKa3lZcFd2V0xQMmZRUnYybGd1eUd5QXlVUHgwTnhiYzgzQ3Fp?=
 =?utf-8?B?Nnp1Z05UYmlCMDFaWndvQ0QzSElwNTFZcnlNVTZ2OUpreTJXY1Rmc2N4U1NG?=
 =?utf-8?B?NEJsMXlBOE51UXlJRWJJRVFGejQxOFgyUEtvOFZpeEdIYlI5RzZYem5oRHhQ?=
 =?utf-8?B?Ly9ucWZ4bmlHNVo4NFZVcVZxNzZ3MW85RTFQaUNjYW11Qk0yUlJOQStlNTlR?=
 =?utf-8?B?ZDRnVEVxUEgwOFA1bnF2dmhtQ2MyenVhSFJVQm40N1JRUGs0NkV1Wk1vVktJ?=
 =?utf-8?B?akJjMFZ4Z2t5QjVFOERjOWQwblJ5eEJnTHFCSFZmeDJjdWwvQW9OWEZzSTFw?=
 =?utf-8?B?MHNVNnU1V25Tdit0cnZnVXhlMkwybWlRUE9MK0paSVpGUHFoY3RQSkkrc1gr?=
 =?utf-8?B?bCtHZDloNThlMW5ZanRZcmxsaXVpL3JxYTMvN2dRQWIrdnNiTjNDUDFibExJ?=
 =?utf-8?B?QnZLRTJTZTFMbzNiUTZOYmxMd3g4YnZMRk85Nk5rR1VaM0JwZ29SOW5JaWxo?=
 =?utf-8?B?aC90bkJkNUZXdWtjZEFhUmlZR3RhTTZaeHYrUkNBUHR6ajMrTUNjMkV4YU5l?=
 =?utf-8?B?ZnhkL2YvYkoySWFiRnFRbTg0YlE3RUUyN1haUFVsRnFQNGFGaDJteXUrQzA5?=
 =?utf-8?B?QWVWZHZEZEVCMm9BWjNtYm1ObGdlSHRaRUJDMjlyMS9JK1pFMnIreERWNUFW?=
 =?utf-8?B?ZkVWaS9FYkh3QzlEZWI3QkJVbmdJZkJDUmZOSmNzWGpnMC9UN3dldDE4M0NX?=
 =?utf-8?B?aWhDWXk3TlJrWWJqMGE3MWExdW1ydUZRMkszY2hHdnVzaklFZlpHWXRrODFM?=
 =?utf-8?B?cGI4QVpYS1IwbzhuWnNZM1hQcVdRRjR4K0k3cU5iWDFpUnh4R09ySGRvNk5N?=
 =?utf-8?B?SnA3WEVmR0pyMjM2NGlCTDBhVEQxcjFSZHR4c1RRaFRKeXZCTmRYVExRR2l0?=
 =?utf-8?B?RkhadlltaFM0TEZ1dGxtUGVZRng1SUZhZERQV1M0emFXd2YySHBsN2xJWlly?=
 =?utf-8?B?ZExaL0RETlhhRmdTWk5ZS1JKMThkTHpvbEJDRFFic1BBSEtEZHl4Y1pVNlZG?=
 =?utf-8?B?L3h1d1NpcU5FQXNyeitsRGtPRVYrRzd2Y1ljMy9Cd0RDdDNzaUc1QzF1MHdx?=
 =?utf-8?B?bGx4R0htU1Zrak1pRnB1VnVZU1VZdUpwT0FIb2o1blNZMndkaUJxazZxWHNV?=
 =?utf-8?B?SkhhNm4rbi83b0JKUEloSDZlQkU1L0R5eWpCd09sbkV3NHNMLzVlRTdjUERD?=
 =?utf-8?B?NmpwWDdsWjlKbjhFYVQwMkZ4dXcxV0orR0p4TmhYMDkvSy83cks5ZzhNeG00?=
 =?utf-8?B?aHNCUjNsMVhSUWFKQUQ3a1NFTXlKNkVuWkx6TkM4MkdkTzNmdFkrcW11R1Z5?=
 =?utf-8?B?eFdlV3BxL2lvY0pucUZqYXhqWFBwV0lCdDVxUytTK2RCcjRhZzUxYVJUVzdH?=
 =?utf-8?B?VUR6M3R5NytkS2lNZU94WWtkTDNPUklrWWRiV1ljYVdUNWJzZnZ6Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 671e75d8-e61d-4461-cc40-08df17fbf037
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 16:18:14.5743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KC5Liim3WJORtd90J+1+zfm/OjrdUcoJES8JPeEIrdlhm1fFZPc3yiJ4ugQ3dz8f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DE40C000E
X-Stat-Signature: hiwsra3udpyrne9totmia3uhgssy6jzq
X-HE-Tag: 1790007509-509855
X-HE-Meta: U2FsdGVkX18zIf8FpIlkMl5oTg4suC9u12gnZDS31lJ7ql7WJzjJFJHVXz4I50zwsD4zKTzsxjYM4RFUdGQeUheTnX1al5dATW0aJ2g8HIjm26h9Q4WK4n82MzrNrz5CzS5PHBx7jvQLKwrAuFwKdsriKfXD0/S7vBV8N1s/RLdrcVohw34n5G7XyPo9glnY6aUzpntNYrOg+B5va3c4IMrhuP6XYdcXvA7hEIiJ9o6Ux/nfVVql0B/BCxyqR4mxlxe5qlAzeq7XoxzDmPp61A823zhz+LPFH/MZ1jRI/4UveoMIQtxVjxPEK4omjU+Fqqdzdyh9y1iNQCMImOJDvg6GM46aXx7Y1aE6Gw77RRKXFMDoYJJhw86kQ/mj5oNahxry0v3Q9ExztGajQlw8K2rTwonoexm/xcncjcTmc9kTZvLl25W2veysYdjcR/8eQaG64FmaZAYMfp4vMoRJjChQej2uQyMWe5d475JLjdGUY48M1Nk5wy5sHXof5WZczNwyAIY2Z1ICmd2F5GstcmlgxVhxJcep+02to1E52hj9aoWr5oen5kIAdncy7H7BViACVLqPgNtzXVwyWhbMxAqAI/dMJsi/8/bxUn2PVOF3QLsEOnVCXZ5eNXmc6NOa3y/ZZYmNBoKEQ/Igouv1diK1WY6tKNB0k5a/2TcOzEPB9u30snLdk3QZgTlKVd430lBASPItu+Wag+nju3Y5+LA0cmAzIDIDjSjWkwhc5UKQmbpQ9sw3TPRB36lIuA9ZGQhuSz3nXTka3PEgd0KCqsRHflB0Uk5umg/y7jmVZfJGhU9R3fFFOVLLfEFIS0DxkUDztVSVE8J4xgXf1l88jPfl3uYAtIL/LDO/atCmI27yafs0PmdhzjgWxCo5UGOLo3Aj03zyeL91s6201reW0QeXYbI47EitPI6FUyJ/XYTYvmlF1EikH+xD4F88EHIVaxMgwXXLOSpr2pQaXcB
 Ge31OQF2
 zraLuUYknebuvdarwzgzZZ08UJmRhAJJ6jsS0MLwKePPOvBZvFpI5WDhjZtpvPUqMxXvCxr/W+ztjn23nkpXYsQ0vMRzaBOkx4tBQysugfUMr1eeY+d1MkZAEnP9qPGdb+RiXVQMYjNKGwLq/CrEPViHg/quMM7RgWSJVM+PFeSKF7kXni5LbG14Ot8X4zbUk9fnxeYA/2L2fml57tn3EUnY/W0a+hcK00/HV0FEkZgW3kQQu7z4VxUiUv+RN3woorwUEMzACWspOtM/IQ1y4dRQydf4Bavi3IoVHpzqX16YUiEC68bTRBcT3kTQmMNSPDzxWBT53c3TqTMHN5dp+yV3Facv4bUQDVPFvyl9nQEvbLlOl+otksNFzqrnNJw6aQVE+3lHz3J9rauC9TOUQZud493PzVX4tgd9sQmXJhY9jICt/l6Q9afy0KSFmuJhc91w4mmwhasyk1d/W6IGN83Yk9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Sep 2026, at 23:29, Gregory Price wrote:

> On Sun, Sep 20, 2026 at 10:49:05PM -0400, Zi Yan wrote:
>> On Fri Sep 11, 2026 at 11:04 PM EDT, Gregory Price wrote:
>>> +static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
>>> +				int zlidx)
>>>  {
>>> -	static int node_order[MAX_NUMNODES];
>>> -	int node, nr_nodes = 0;
>>> +	struct zoneref *zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
>>
>> Why does build_node_zonelist() need to have a new zlidx instead of using
>> ZONELIST_FALLBACK like build_zonelists_in_node_order() did?
>>
>
> The intent is to build new zonelist over a set of candidate nodes, and
> it's also just clearer: build ZONELIST_FALLBACK from N_MEMORY.
>
> With this we get:
>
> build_node_zonelists(pgdat, &node_states[N_MEMORY_COMMON], ZONELIST_FALLBACK);
> build_node_zonelists(pgdat, &node_states[N_MEMORY], ZONELIST_PRIVATE);
> #ifdef PAGEALLOC_KTEST
> nodemask_andnot(&private_only, &node_states[N_MEMORY],
> 		&node_states[N_MEMORY_COMMON]
> build_node_zonelists(pgdat, &private_only, ZONELIST_KTEST);
> #endif
>

OK, ZONELIST_PRIVATE and ZONELIST_KTEST are not upstream yet, right?
In theory, the new zlidx can be added when you add new ZONELIST_ types.

I am OK with adding it now, but you could mention this change in
the commit message to avoid confusion. Something like,
for bulid_node_zonelist(), use ZONELIST_FALLBACK explicitly.


>
>>> +static void build_zonelists(pg_data_t *pgdat)
>>> +{
>>> +	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
>>> +	build_thisnode_zonelists(pgdat);
>>
>> If build_thisnode_zonelists() means ZONELIST_NOFALLBACK, why
>> cannot build_node_zonelist() imply ZONELIST_FALLBACK?
>>
>
> thisnode actually means ZONELIST_X+1 as opposed to ZONELIST_NOFALLBACK.
>
> Since folks are adamant about not allowing another GFP flag for zonelist
> selection (beyond GFP_THISNODE), the result of this is that all future
> zonelist additions must carry a FALLBACK + NOFALLBACK variant.
>
> The question you actually want to ask is why build_thisnode_zonelists()
> even exists - it should be part of build_node_zonelist()
>
> I can probably follow up this series by just folding eveything into
>
> /* build zlidx and zlidx+1 (nofallback) */
> build_node_zonelists(pgdat, candidates, zlidx);
>
> And add a BUILD_ON_BUG/ASSERT that forces any CONFIG_NUMA to have
> balanced zonelist additions.

Got it. Thank you for the explanation. Are all combinations of
{ZONELIST_FALLBACK, ZONELIST_PRIVATE, ZONELIST_KTEST} x
{N_MEMORY_GENERAL, N_MEMORY, /* private only */} allowed?
Any enforcement if not? This is more related your “private node” series,
instead of this patchset.

>
> But I don't think it's strictly necessary for any of this, and we're
> just shuffling code from one place to another.  Probably I can just add
> that improvement when we add the next zonelist.  In the meantime - this
> makes it easier to add new zonelists as-is (and just makes the code more
> readable).

Sure, no rush.

Feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

after you add some text on the added zlidx in the commit message.


Best Regards,
Yan, Zi

