Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D797AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 15:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9771E6B00D8; Fri,  3 Jul 2026 11:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928076B00D9; Fri,  3 Jul 2026 11:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1BD6B00DA; Fri,  3 Jul 2026 11:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46B136B00D8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:05:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF069C03FF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:05:34 +0000 (UTC)
X-FDA: 84947789388.13.AA3A9A9
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010021.outbound.protection.outlook.com [52.101.85.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id F378E4000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:05:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XY9PSYsu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783091132;
	b=qnaop16KUQt4r+HoWzwKSgHJ6DAa4bBB0NVZbxxnVgnEziqs5yH+ur9y2SEZOi7/b2qg3T
	dLCot+0qt5bwKC7VxFUnFlpJA0OJEseHiLbxwTYdDM1HNH8sDZ6NFKo7Phhc2lKrnQVA9y
	5xdVRdfVlt3RGIYj2IfDOzCR7vkVENE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783091132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Evp1IlU7CUlEd5xdjDCLwKH28NYtN6LRStlO5frH+Y=;
	b=nscbQNYPfaWD+MjD0q0y1x44MBaq9FziSOQoEJaxlaoeelx4AjxN7zV3m1FIhs05Xkr0xp
	YuJ7n+crivg3CNIkqUwK2qCpm6h9uQaMgEfh2lCPX0Ofya4Vlltum2wPaQ3Fwalv0K5NrM
	YR7uQp5PoZ3k6ckzahVjsKZzdmWqYVc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XY9PSYsu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQXhqSdJU1UyUz5BlTM70BOrslMXm0fYPKEnjljvzZ4X1V9qom/Raad/E9IxhFsBVw5kD1AsAFTyEB468JXZyEytJY3pNBnQZAfMi3IBgsBW2cbppZmliAqgFE64jqRKgJF7aAarzdgKEl2gq1G5FpGhUmvd4UeNXMF+WclaQYSc8HBWibSGdeqa0L6C0S1NHDP+3f+QkjXq6EMr26rOcvNq6AqPBG6IKw5c/UAsjbcL89GWax37IdKNytrFmvPAYkSqO3eCKwX+lBUbMDhjwY0/pOUzgBJKMe/27w+qWfVTJYNLmdv53D+wZ2j9FWB/8yMtsqG4885Fg8Pk1Cl9Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Evp1IlU7CUlEd5xdjDCLwKH28NYtN6LRStlO5frH+Y=;
 b=ZZQhXJyAG37BBwA+sK5cBPPL1+Vpgu6tk7s0JjOdUbrKDRMM/CRKRyOAi9NlFVzGFlMr6nCGVVt4vEvVvuXcs/IdvhNw3AeX9qiPPwd5kEkG9Rm009qxfo8a/p8ozFrt2D7amz2fCOe6f6Fa0MLv18ZrPca3ekuq2gOBfPPW1Rg4MiAMA3D9sH7FDuv7GFqk4dD0X7H6BIJTKxEIJJWyIq8UDf3hTL9q1x+k5lwGjisgp4W1wtOIS5E0gWpFvALWgBUWpNP583vNkhwR7q6cxO8sifUvNKyaqtFXbNZHnvZf2KsVk/tLukjvDxIOH/iQCQ0Z7LBo9VbdqYLYU9fOuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Evp1IlU7CUlEd5xdjDCLwKH28NYtN6LRStlO5frH+Y=;
 b=XY9PSYsu5w4HZw4ghNuQsfoDD4M2cFiSaNssZsLekzr+4iGCWiHZqE6RfoJuduFYH8jZ8OaSSiWwaxllVR7DzG8iOc+VC6hyu6VaZg+y0S1pXQ07AtOyv4JIXAkf+mI3vaK4aaotUh4fpsWRYAQVSXl3g8qgF3BBWdZln2zyUhqUpMw9N84Dn6LDZvENMTH1qA7G90M5BbVr24AR4ew8VwEG4vQITSDdJn6dI1ROMzV78V1moxC4p8zL/3HtIDUOHb49E3O+bgoy+y+14teCTAG/7GMUZD3Fc9AgcYdjpCC5PG2k9HC1dgTz00dNJlznpVb5j2xpXbLkgVRxHv98nA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB9254.namprd12.prod.outlook.com (2603:10b6:510:308::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 15:05:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:05:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 11:05:22 -0400
Message-Id: <DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v5 14/18] mm: Move __alloc_pages() to mm/page_alloc.h
X-Mailer: aerc 0.21.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-14-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-14-c87b714e19d3@google.com>
X-ClientProxiedBy: DS7PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB9254:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf04a94-c2ff-43f1-f4c4-08ded914838b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|921020|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	QmCRaYXwNpsxArTRAyqbIN+0Lk0KT3H64UBFqpb8Jnh5zUTebA5lD03u1hPVnikau8Rs0RFX7E69I6anoS+w5DyXlrdxu0EhOJhaKUU2qTnph5ZcQFgYWHRTQFCEPkh514aWH+staWHLTHv2kRE9tu5nv4qGRuW5lqL4SdFW8cZALDGsp3kYyrcQa1ZjXy1AQLMX/m5x1TeWXLOn+gVVkkGkZLtGnmyIjTepW8hv/VSI8WntWD2aDrqAkVKmoqk3pdEiLu1kf8SfY+JlL8mcw9idmXyPT4TsVpKLSkZuwHe2GnJw+1X1x/Jxd/8Tu79hGXzvtkkYO9JuSD653Yv5JYhh2FdCU+g242Y1Q/42GysSmYF83avtUifm0cgFL+WgtcRssVRqyEc78SGtI9M+6uxb0l9wHgO+QqrCIK9C8441GIf/e8vqYH7MaC9+h7d3FJO+hbc8TCxzcafMSJhA6+i7QRoL65Dw26nljbpTM4XAnZ4wIqgHMbmnN2PXba/4zCijFVOTprFrGdJug7zJVqorXpNzPOJR6lHTsEPLkP/NhS0OsDdmmHv/oUBmcGkFqMfPJPqamUKZVQtk5JQwKOr/8w1cRsrTpNCYe58XOKj6fv1sVaMI5le329Z1f0+v+hFPpU9MYWhExulWHHmCd/B6k0QTsrIrbnySrdqSa3+AUAMopnRrwllJn9rs6if8eRk35bp3RFv5d6JlPQZm8w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(921020)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlN2Zkpoa3lCNW1qbjMxd1d2UFpQdnkyS3VVUDNacmZpVmNya0pJb1liYlNM?=
 =?utf-8?B?TmlUaW1GZGYyUVl0UjAvUEJyc0lySFNrekRrd21Ec3kxT0pKNGhCU1d2ck5I?=
 =?utf-8?B?NHJ4K0JrK0pEWEloRTZERXJnRTJnc3c0SGxlTkxiRUJPaEt1UFhwM0ZSaStr?=
 =?utf-8?B?RXlRL2dzVlE4MFQ1UmF4YW5qQWVJaTFSanFzWWx4dkJSR1FBM1JNZHlGbGFa?=
 =?utf-8?B?U2hqZEcvU1JtRWVrOXp4ZUtTd0VWV2YrdG9PYjY1Vy9uU213QzkweGhFMDVG?=
 =?utf-8?B?alVvbjQxSlRjV3g3U2xWY01NVGlBUE9SR1IwR00vNEs4T3NIVlh0T3oraUla?=
 =?utf-8?B?MlE4dHJzcXhNOFBqb3EyaVJPRWVaQ1VhNDF0aElyZmZUdmNqWjJ6SkZFLzEv?=
 =?utf-8?B?bTd4K0tlNU5NRmhndC81bDVRKzFYWCtySmxLNXVwWmpqNTVDV1cwMXZBamhP?=
 =?utf-8?B?bDZzMHZmSVlGVDN1MnBqM2dnSStVbzUzTkE3aE8vZWRkNGszK1FzdTFLUWdi?=
 =?utf-8?B?eFdVWUtEVE5JWjNoWEhNUkVySk5OV0Y1OWw2SWZxUE82a1phdm1va216c1F5?=
 =?utf-8?B?QXdEVnMvL1JscnBiSVVhMStRZFdLa1BlVFVBb0ExK1BZS29ucis4d2VVZVlF?=
 =?utf-8?B?a2VHdUxkdkxXNEZqeTBGV1BWK0w0b1BTQ0RlSzkwYzRYMWdNY091bWxPdldl?=
 =?utf-8?B?UzVCb2h2R1dXTmx5QjU5MDgwYkU1KzJud1BFSGNocTdtTk9BNmhzb0o0disx?=
 =?utf-8?B?QVZDcnc4UnhMN0JlMTdYWTBVWmV4VSs2YTNlbVpCeHQzamkycndlMVFZQUh4?=
 =?utf-8?B?QVc0ODJtNjFxUmNNZE8xOTA5ZEt1dVZSQW5SZW9BYVMwSCthUFFudzQ5TzNP?=
 =?utf-8?B?YU1FUVlCV0ZxYnF4eExmL0pIYy8rbG1DZTY0VzNicXI1aGxpTVdObTBzbjV2?=
 =?utf-8?B?ZmZ6dDhDY05UdkNWLzlMSVM0U0JiQ2pjKzBSZEZneEdsSnJoZ2I3OU1jTE1E?=
 =?utf-8?B?ZVRxZXBTVUkvSWlIZStPcEg0Q21KYzF1Szl5WGJjTkNTSC9kZnRkcnRObFBN?=
 =?utf-8?B?ZG96MzVhQVhPM2kwaTRoTWZSanFoVEFNWFZhSy9FNGEzWUNKOURyYUJlVHEz?=
 =?utf-8?B?OGxKUmFOdytqczJIQ2RIYit5R2lTRCt3NzN6aFFZSFdOcTlwQ3dHdE1BYTNS?=
 =?utf-8?B?ZTFjZlh4M1Jmc2RzU1ZvTUZLYmdKeEMzY3pGU2p5NEpQdzFlMWxia2V6cElB?=
 =?utf-8?B?cTVwSzZtSVk5RDFWN3pMRXdGWW10L0g2S3l3RXEwSy8xa0hrVHQ1T1BqMENm?=
 =?utf-8?B?MVB0cENFVi90TFFTdEZPcStuWkxlajNBaW9WcFJCTFN2NHV1NjFWYjFtYmNp?=
 =?utf-8?B?VjU0dzJxZ29jUm1GT2FmdEFlT0czWkFNS0dwbXZvU1ZIei9DT2lWOUJsbE5u?=
 =?utf-8?B?QXFncHRoSkU4Y0VRdUNLNlJZc1hjdVI3cnJIT3BKNnROVEtHckpkOGM2a2J2?=
 =?utf-8?B?T0lkanBPeTN5M2ZxcThzWldOQVN6aXZUbUlCVzI1RjFKRGViK1pVZnpqN29G?=
 =?utf-8?B?dnpqT2lqZW5xalJRSm1qY01QSkNOcjNJeGJhdER1eTdtSkY5WFFVVHBxeDFm?=
 =?utf-8?B?ajhVL2VIT25yMDJSSVNjdDA0K3hDN29wVkZtSVJrb1g4c0JOVU9QR3pwSnUr?=
 =?utf-8?B?UkdkekVwQWNhTDRvbXVWTk56eXB0MlN2VFc1MjM2SGtxZkRCR1ZLMmZrek5I?=
 =?utf-8?B?OXNoczdWNHJ5cjU3cFlodHMvRmN4dHNKak1mYzFWSnhON0FvTlJXVFUvSnd3?=
 =?utf-8?B?ZUkvaWhsZ3l4TnUxSkFQOWFoM2NEZ05OREgveWl5cWNJSForZUwrYW5QUThI?=
 =?utf-8?B?TmpjTjYxKzhmMkt0Zk8vYlFFVmZMVWNMZVlMTzAybGowcC95cnRVVGRuUzNo?=
 =?utf-8?B?aTllRU9ib0tROUlORGN2Y1ByMjVYLzh1UVdBMmZaQUJYUkpNVE9Jbitybzh5?=
 =?utf-8?B?SFY2TnFCbUk2WkZRMzZSRnJzbTd4bnhieUsra3YzQWR2N0c3REtPQ3V3VkVR?=
 =?utf-8?B?KzVhMEdYNzRzYmNnTDNQTEtYcm1wNGx4N3BMTzc4d2NQNzFpaUdRTVMrUHZo?=
 =?utf-8?B?TVJyVk42Q3AxRndONElETHdIMFBPdngyZ3h6L1JNaThDZDRrQ0xGSFdmcXlC?=
 =?utf-8?B?K2lyRGFzcVFnUGN1ZHRlOWpSSlEwZnVhUlAvejluSzNFVnYyRnRKWEVTWnRZ?=
 =?utf-8?B?QWxQUFAzVGhiaWlMQjVobzV3OVFhWkpncnBNR3pTb3VTQWZ5cTZqZzBiVEpt?=
 =?utf-8?Q?6RChOdLn/gU8D2woPM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf04a94-c2ff-43f1-f4c4-08ded914838b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:05:26.4184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loXD3eY3wybe3nYbmFqmRBHgVFVMvqTKjZbD+3pdy8KVr+q/5KEsmxV8ILu+RAUK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9254
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 96t14bs6cqk393nrrwq3ssyyz4fh6rjg
X-Rspamd-Queue-Id: F378E4000A
X-HE-Tag: 1783091131-335470
X-HE-Meta: U2FsdGVkX1+DLSbwu96XBF2ztPs2R3QPCMwcoWdT/z2bsO6oHud8Ix7F6CTq7KMt55rOkwxaI57znXmJ/1VVMIA/NUHjiKmu9iwEDixCa+Tk/lrFZCdwZTcqiBlXgUil8Fuy6n21/2cuVlNzV2iCqt6Tppzr/ig+tm+vr4gY/i86sjS5R7oBo5xPyt4ol+PDHnBqSCV0Mh5HDl1qhGpO2MiY2duUDvBGbDNuvMZa7hTqBAccftvIwXjf9OxWSJDiCdulcCNt3bnhV6Nw1DJHiM1LW2ZA3myoNd894fbVhlZSyPc9zpdy+++HBSHIHHtLfHtQXu2L4iqztFBjCXhFOmmDPsbtie90qw5wFuW/fkcaWCzpRZ1VskJ6+iq5SGbxd9RXLVajH15XIP81t6V8Se5+iTYd2HTsyy54r+Pcm68U1IxfRmS6wlFk2SgUH2mWyiG+2fFu07XUOTVpqtqaNfuABsFyayqx+dujdR43Ei2zH66GZNFqO+JwHC94aCpQEz07Ukh/WskqYOPBXaxWrSKxCi1sYztF3QKkxse6yK2r7D33fOmZEgHId61s3eNH3SV4Ndr4KCV1kYjzOWLyMmxRYL0XeX85JCNUz2CNyLEpPrKxLD8RbrAH9vbWOn7wRYcaH/faCD8k20j/IeqLgIPp34QK3WMuU8wqxEW6ebcePW7bXhfOg0R9uRLi7ywZ5IRzckXReFR8IF0pix4jsV/K3tpqRdw2Q7+5JmsGAfFJjR3eOidmxWf3E9K2QdqQ5GYMQs/vNMeURWZSRaExkn8X0TBA80tgGk+FQ4wP/J3RLDkobQSKJUOM8aTzJgXPxPqVQMWDhWcSd94avvnsBVsVDlZTJMnPm+V+LV0MBoDWmfKd54Not/giN4LCeNP+e2UzodwM6qtAEnWnFdQAPXu327GyzZd53+L5bHgMj978i5y8IzVd7SGY/J7kQNrWPzPvHZtgbqy1+hNCiR3
 C68dVs+x
 mBqnIoXPMh90ws4zriomTy2ubb+MmPCCNO7D6a3yXhuHDJ1tWdioBCfE3yUV4oz0e+deNTliZSGnbB3buvIN7h8mp9to1yOXJr23BcW+tgIY4W++xBxCCd2cW2Z9GRauuSM4ZeNHNyeRZtmw1kaRPogZgkAMPnTGygakzHVhrnMJK/B78nnSlC+bkJUU26DkdspwMExgJdaG+JnZDsuWR7RaWzehc54/rj2fAYmU6eh7HXEKc18PBNgvJLDlEGi3GDyonb1fRvhhU6M4HwIpZt5a/5L4lldiFLUlwVB1bxhnpxq5gaaqZMAklXZrRa/43LagjclhPzwTeRm/J8NZk1cr6abRHM/wI4L01L/dr36Df8QotMvkxVdi/srTnfhHW9VAcqmrpFEqyCL43oh7g6tkide9zsuSAcEatNS+6EHPlFWqMCXZIELn3koBlr3sMa6duufbnwBlFTDbJDd85Cg52As7rb38fQkLkosDXnJJgfz0/YRUih1B+K1CqY5XSLjfyL3QBLiggIbfGzlD1QinSRddhvSdsbUt2SaKrP5V7mBRjNHtf0/gazxdewJmCejkb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> It's no longer used outside of mm/.
>
> Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
> this also means moving the definition of alloc_pages_node_noprof into
> the .c file.
>
> Also remove references to this API from the documentation tree -
> referring to the specific function name was already questionable but
> now the function is not even public it definitely seems wrong.
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
>  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
>  include/linux/gfp.h                             | 16 +---------------
>  mm/page_alloc.c                                 | 13 ++++++++++++-
>  mm/page_alloc.h                                 |  4 ++++
>  5 files changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentat=
ion/admin-guide/cgroup-v1/cpusets.rst
> index c7909e5ac1361..52a213aff04e5 100644
> --- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
> +++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> @@ -284,7 +284,7 @@ take action.
>  =3D=3D>
>      Unless this feature is enabled by writing "1" to the special file
>      /dev/cpuset/memory_pressure_enabled, the hook in the rebalance
> -    code of __alloc_pages() for this metric reduces to simply noticing
> +    code of the page allocator for this metric reduces to simply noticin=
g
>      that the cpuset_memory_pressure_enabled flag is zero.  So only
>      systems that enable this feature will compute the metric.
> =20

kernel/cgroup/cpuset.c still has 3 references to __alloc_pages(). They
can be converted as well. Otherwise,

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


