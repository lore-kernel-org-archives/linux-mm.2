Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B2C8CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B676B0088; Thu,  1 Oct 2026 04:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03C86B008A; Thu,  1 Oct 2026 04:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1936B0092; Thu,  1 Oct 2026 04:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8366B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:26:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D038E120359
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:26:26 +0000 (UTC)
X-FDA: 85273375572.15.15B3CA7
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010059.outbound.protection.outlook.com [40.93.198.59])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8DC4160007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:26:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OjW4EoFV;
	spf=pass (imf08.hostedemail.com: domain of noren@nvidia.com designates 40.93.198.59 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790843184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akkaRvJ2jW/plqQDTQAJCrLfiAyvXfLPi+dBpXmWEBg=;
	b=ErSWVFjoNgDaRo8RzImXeDBTauar+ektB4xo/B4KlD2wbdzVBpTyF+8kJ/3O/JD8A0s+dF
	wCmPYEgXL4A9uikTNkNC4RUBZnzTzIi4ZW6ygA2xiCsiOpTqVFMOZffPXRMH+7POHoNUg8
	zGVhYSop+g0Q7wmoWYuzZ9QSW5CSIwc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OjW4EoFV;
	spf=pass (imf08.hostedemail.com: domain of noren@nvidia.com designates 40.93.198.59 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790843184;
	b=yiFhiIXq0A3QieIoLKYfyxwKPh51lBgoHfG5N2kNxo5E7bXiqW4/9wTYCecfm9wgFZZamD
	TbGhoqQXPw4dRHm7TZTOZKeO/pJolU30LP/VZW4sZFjx7nRPfOjSWayaf+wxdbDw+oOgCN
	X/dE5Lgn9kYFQCqR7jUhJOz6ALJCINc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKbqAcrdLUh/HyvA3LUJPubxFztI87Oup6p8fan28fB3ch4QC2TzBzPUNCWjU8hDOYqjZcA2iodtG8/Ab1uw1W9C7qLleJN10hCuGXAlbbx0hGXrLoJtp9abM1XHyCMqzD/SQlGHr3EGAAmcmA5mRUYR5auUT/n8Pm8BWLETbEJF9aqEEXCOe7fs9DJISdhEuqaaZtr8O1eTKaUeNaMnOEwlUBPDC/DFOh1hqvHry3m/gm6a/MghJo8nLlKffSvjedphQO4gKDq2KAqHjXbTnfDakRWsguesm8VHe/0mZY51+wRupiXXJaOKoRuFIpMBb+zTZBO0riY/hn959/M9GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akkaRvJ2jW/plqQDTQAJCrLfiAyvXfLPi+dBpXmWEBg=;
 b=P4svgCXDLeVO3sVRru0Ge+Aj7hik0IYo1lUGjGXFQCWikcffIc2LEbiTVNhfIeAhuzWC8DWqLVJiN8WoG7kJm1UpWsrunZA/MgZCT6R4hERabXAK9IWMIJAi6IwDy2md3PsypZ1TsJ83N+HUDVYrS6T7zY0WxAgpn9gVfEmMSP9y7XBKs/rMIrYteltn1F++v7oGS0Qw4wbQpdGYr2VssvcN6X3I2R2LWUfvMZunOULMJXf2lLKjQxuxMG1gL2hQ7KHlrt8QUTTrVh1vouwz1bo55vrznKqoED4IHL6DXwq32lPQUzuq8R4J3Yu5iu1fSOwrZppkFvFTEbf292bc5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akkaRvJ2jW/plqQDTQAJCrLfiAyvXfLPi+dBpXmWEBg=;
 b=OjW4EoFVOVa94O4A85SfCA8tsD/PBbDxEV/9MrbyX2ZLBWU+vPGQ4IIDNT2Gei8GxNv0ly82yS8mOqfl6uv+qJlftlDtwiZNp7do40HAkhxcWf2w1ZN8UPA9QYf0bnA/atwt5ssrLO/EH9ZvZ9+VHvOhbdriMF2UceTeG4q9EaNe3RipeKL4/xR8Wurw7hOpcdlWj2fnQZw/pQR28lo29n9SMuZf+EajYobaSBfQKC3b6UbLRMqXNe4umlegIWe4Di7aDkB0kM0/LZVRRcgu7VoIT+nk56AH3/zDewQL3HLD7BOCKZ7ibiEEa0j8UYtV3taUIX3fb5i1Kcs6cc0D4w==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by MW4PR12MB7310.namprd12.prod.outlook.com (2603:10b6:303:22c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Thu, 1 Oct
 2026 08:26:18 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%4]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 08:26:17 +0000
Message-ID: <bc7a6aed-2bbc-428a-91df-a98683fdc4b5@nvidia.com>
Date: Thu, 1 Oct 2026 11:26:02 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
From: Nimrod Oren <noren@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins
 <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org> <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
 <a1f19a59-7dd5-4fb1-b5db-3efee8d249e7@nvidia.com>
 <20260917134949.GB1344@cmpxchg.org>
 <1e29995c-4877-4d83-98fe-88da780b6d40@nvidia.com>
Content-Language: en-US
In-Reply-To: <1e29995c-4877-4d83-98fe-88da780b6d40@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0079.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::6) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|MW4PR12MB7310:EE_
X-MS-Office365-Filtering-Correlation-Id: abfedd93-1616-4b86-8112-08df1f95aa31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|56012099006|11063799006|4143699003|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Re3OZ+4bGRyuP41b44QUwNUGroxAVf5uCSZAPQZ6viiGKy3AIFEeowDtDa8ZtRs8MEokHYy4T6PPEBzQx+Bnf3SZD6PAX4n56Qm4gGqOdaEJX2hZVSGvZt0pkxcBmJG9XAJm74La5GE04eIhy0CZQUWaAd99yGKBrx0asYGT6WkujCyWjwRPcF4qhmTEDy29HN/BvO6QhuKObKqJs53ngZod9nAc1a91elYfEolTnQabML38sbn1w9Q3O8U8ra9TukuU0QAOJC5D9DKRsvXjbi3hTf8ZSQD/Zvbn2B+UPOPyXWeAmYJSgkCvXzHGsMjBBx+ENG3GiGRVvmzCB3rgDcNNMZGXzly7aiLoQG+XTPYqQgWe1QjSAfWh6CpbLJP2oIyVN7/EdYmks8WhyOXNNqZ9mM+lR6rxOZO+UE+rF9DW04dNlpDhpWM2ovu+AKVPYd4mtXmASWSugJd+qrEnO/Es0wWWy47LpkMPVzEVdo6oMFtyVHxane2vj+6w1rwbQBWTs1g2sQYc6qtQf2TdvvVo9UwWf3gUASZq0EXj5Hn0OkLXmNJi1qVYlGJSLBKrrKiH1QJPwbHFqSJVqhVzRzOo5o14slL8b117tzcAgDJsPzWAbw8lXFnaYQ2NR3/9gS0AB3+ZWa76G06tfEN5H/8U9EIMtjpuaC4yUGwKmlg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnQ5Tzc0Z3k0QzF3RjlabEdqVU1KWXE2cFpHazRpaWU4YlZEYjJucG1wVlhm?=
 =?utf-8?B?dVNxQ1dVYjJES29rQjF3THZ1bFMvOFgyQm9sVUlnMG9mZGpPUmVjYWhGemZ2?=
 =?utf-8?B?SGlpSm9uWHkrdksxQjZzQlI3VDR4VjlneFROTFZYRFZxSHhMVXVZNDRPS3l1?=
 =?utf-8?B?U2NXMEk5czBPczZZVEkrUzlMZ25NOXhPTWZyY0dRUXZlcTBJWm1GcXl0YmRE?=
 =?utf-8?B?aEV2SWFidUxWMlBHMThzZExGS2lZMURVZStvbkZHUDJtZVN1MmxVZGxGeGdN?=
 =?utf-8?B?UkM0ODlKbWdMNkNhVHdYR2I2djNaTDVYSmF0d3NUZ1RWN0hHRlFrd002eHlI?=
 =?utf-8?B?Q2ZHSTBlY1hxMG5pN0M2eGFTdDlRd3VTekdnRTE1YXRYak4xL2dnWXRNRUNI?=
 =?utf-8?B?dEt4UXJsM2RCUE1lQTRick9BSXZsM2RiakhEaGlCUUxmWjZuWUNQNFZaVHo5?=
 =?utf-8?B?OHptNHNYOUtRdUJ3MWp2WkJYMmp6eFdsSmJHbnM3MFJCamQ2SHRmRkNSWGov?=
 =?utf-8?B?OGZ2R0wvREJCNWtrd2tCR0FKbjVGcS93SG9SR2FZM2d1ZitFNkdxQnBTVWZU?=
 =?utf-8?B?VjBNcHlaaCswTytwcGo4S3B1L2Q2LzluWCt0U3ZvSFF3ZXpuSFlJdFE1YXdm?=
 =?utf-8?B?b05jck9zYk1LbndkVndob2orT1ZUR3Nrc29sVTlkTm9BcnkxRUlZQ1BFTFd1?=
 =?utf-8?B?NkFJV1plOHhKcTVpNDRLbDRtM0RhRUhuUVAwclJVbnRKSjM1K29oakZWWk1S?=
 =?utf-8?B?ZlY2VklLelJOV0pZMW9UaFV5UWgwMHBIL2QzVk9jUms4bUxwT0l4NzN4Z3h5?=
 =?utf-8?B?dldXTi9aS0pBVGNtcEdrRWF1cy9GakZZRVlBUlJFTHBXSXZXZ0ZzQVFoTkFt?=
 =?utf-8?B?Mm5MSUFOUkZzeXZKcXU3MTNPdUdVYVd6YXdGRFczQU1qZWRtMGp1Z0FxSVBT?=
 =?utf-8?B?ZTl2L2drU3VINkRQUUtCZ3FPN2xZM3gzOUdqTlJiRTA0RTVmZ0U3T1J1eC8y?=
 =?utf-8?B?UXpjdGJaeVhOZHpyS0JBRllYWDluTk9GVHJHSW9iZDA0bHNhYktjQnhoTE5U?=
 =?utf-8?B?K2xCcFVEaE9jcGE4a0JsSS81VHpOQWZHcmRlMUE1Y3VObFQ0dGExSlcxRHZB?=
 =?utf-8?B?YmllbHFjcVpUbGViVXMwZzNhbm9KVk5XM01oRnBiK2VrZUNRRVRTMnBjQkhk?=
 =?utf-8?B?TWdkbDZvaUVZRVN2T2xNcXNzSGpVbnd5TEdzajF2V0dWVkV1ZXU1NG0vM3BF?=
 =?utf-8?B?djNOVk9zeDkrV3pQUjh6Smc2RHVEekNIajhHckM1SW9iKzFDVU1XbXdZUTJF?=
 =?utf-8?B?YUcyU3QvK2Vha1o2QW1Ycm42MmJtcjhqMTNYeDR2V0N1M0ZER3hYRnJWTndJ?=
 =?utf-8?B?WUI2RG9TM0ZIREJESE5LTDAvb2FhVnRRekppRE5tVUZKbzc4bHMvS0tUeGFZ?=
 =?utf-8?B?enNtSjEvOVdKV0w0djg3MldBM0syMHpBZG5SdlNveXlON2Q1cHRDS3lmU2lz?=
 =?utf-8?B?bmIya3JUUjA0Zk40ZkNYOE94WHRJcFZUQnNtZzU3TjN6MG90aXYvQkp1cUM3?=
 =?utf-8?B?MHJFZXhzTXZHckVQbTFhNmxrd2dpNFQ2MFBVVHh4SW5iZVBYTG5SQytMSFV1?=
 =?utf-8?B?TkIxYkliMmRxNnV2QlRYb0ZIdmlkQ3I0cVRRWFhXQUxwdDZZZXFNdE5zWkJN?=
 =?utf-8?B?UFZIRnhmRS9TL3NiSnh3QnUwVlBYM05obUpmR01IODNPNG40WTBvblE3N2g1?=
 =?utf-8?B?Y0VqVHZKcTBXOW96VjR5V0gwMkhwaENtbUNDTFZNNUh2MTNadkpvV0VXMG5J?=
 =?utf-8?B?bDZDY0VlT3NXQjJPSFp2NjhOQ2dSS1YxS3dEVThiL0F5NUIrOGFOUnlHV2Jj?=
 =?utf-8?B?UGNVZUkwQ0k4Tm5INk5sdjF6dXJidlpjYnNmSVVIRmxHaVkzc09mREJVS2Iy?=
 =?utf-8?B?MEx2WTUxTU43Q0JhSUdWR0ZvS21DcTRoVnZTWXh2cXVCc1RINnFOdE9tZElC?=
 =?utf-8?B?Q2V4eU8wTWkwZTZNRUxVS2ZQc0ROZCtlRXcxZ1NNbWk3clhWRGU4NGV2LzhP?=
 =?utf-8?B?T0pvQ0JxSm1CQisvdGtBVUpDUm1IdFNveVZIckQ4SlFKc1JOajlkd2RLNGg2?=
 =?utf-8?B?Y09IUUd2bTE1enFOL1cwVG16Nzh5NzQ3OW5uNXNRSmtBTzVBNkd0Qll4YmU4?=
 =?utf-8?B?ZHVJc0JpQWt4Y051bjJtOGMydVJQU2w2WDMxeHhoRlRSTmZHeTRoQVBFWlFE?=
 =?utf-8?B?cXo3ZzRMR2FuNHJiUDllc0pvamE5UVhWS21KcHErcGVQclNrZ01GRWI1YlU1?=
 =?utf-8?Q?vYzMIj+rQaUi5s6veE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abfedd93-1616-4b86-8112-08df1f95aa31
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:26:17.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxXhPx5ws/YlDzJLru93gWOY2E/WDKBrfsdhlrdwjjs3NoYWYeqeLPSWZEHKiJpgCGP8djZZWIDiRLiV1ed0fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7310
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8DC4160007
X-Rspam-User: 
X-Stat-Signature: 86zox617665xqwastntyjewatmop6c4n
X-HE-Tag: 1790843183-102587
X-HE-Meta: U2FsdGVkX1/sQWY+LgtTM/u5fgnQnMiohB23eQFL1/WSNTngrp0xh095y2I2wJHbWN3EmQy72Hs/eWnw6Pmk4102Of5W8QgtFcFXlJsZ9QxyA32GV7IAT2CqQmz4kNLMokl3g0DALEP8JeeweegeC9vCeBdLbwm0nTbPvkr79XNIfRhCc1U2udmB3ywxjNP1XkpKxgKcULKQeFI1NkPx/nF66wez8NiXT9qAVUVMuCl6srXZDmDZLh+Eha9VBaENkY4ZzdiVnjyeAZAAoxBiFGMbCPozQN2bIo+YrKk9so4NESF1GFLMKs1HUfg+HDzfWuCAuPtNYA6UU82DETlS8QdfnVDMb6dIxq4ppzgXwrx5yzSwSJJMSdNTxsjOSfc0QFdbKpKDxOqleXDhR9aL+KJmbV+WloLTu5iWYBHXrMaYT/88z13sa6Z8rNs+6hbK61a615JEMhkWNhh+p2gk8P5J8/RAF4HQDk4rfURug8A2SBEa+358VQ5yqKKf03fjXA5FEJt0SOxxsOdlShsMlCp9FXX0P7fzMYuL8KyGbj8f60E9lfYVe53e3uMv+tI/RsCd6qdOrTl87wy7u9mKJkd/hfbXeGD/t3WU2DcSVOe7ZdxWGUCB9Y4VrAi4Oo04Hd8QLbjQR87MquUS0A1pHzUCZNNQWsNu+MuegWI0EVPmbSI9QndjcSrbJcrD8cXl2gvVtbZV7zESpwv9MY5Lc7IDC6vMTkhKsD58ovn7FF5ZW4jtWvPVKPo8qMvHn+7WY2YovD/hSlAERkAQow5M007ArM+4LWspMguKF+ysjB0XvpedbcdXwhxWtXcnnX95fBxPcblIevh84PM3aK90QYJc4vzfm7N3Mfg8wX4sHSThbbB+Pa/hsC9g0JWRdihj48uN3asidLk2lZPx2eUBsIsrl3WhubHBSxNmRf442ugrCMz6XKi9AWuj227lPEk+X9eWLBSXJVIb/0Kj6m1
 AZz5zlL2
 Zrjpz2AAO3NPkDiBpNr71eMfEQ3EJXG4/oS9s6KZTJKSQpNo0QqHT+OZd9xb0OAPPDsWDkC8v8Cbi5cxbop1HaLowT/x61IYYUU19idP2YzLMKIqMUcsPd8zGq/XbSM1MOOerso2ugGxvCL7ADkZ06fQCNOL9gHuPcVlaLkQa03jdpNYBatTP0YZIlXwvsfuxJnx5+zUlI5dyy6MmQddF7JejSBOZH07NC+mgNZN+/XUOpLCMTK1jCeLzG9jdTy5cSl8ER3ntZiMZHdn6Azy4xxUSmuu9P1rKU0lUBtSjEcFm6eI37cdN/e7MXINDpUuyNO7qyQ8IQ7MS0CqGHUXPqGT04HtIcMheCBIYtTMLfcCRHa4/74drBG8N73jFWJm3H5v9LAiA8qCKlagFryIUfAl2zWJpMJt0JxuYw1tcIn1zwB4RrIUlhXKnMaXgFX68ewqLL4XyD6oAbqAZEMf40N4HqQW9jeYWT+O2mNVVBU1ey0EmSpCZIQanhqxg/vvJA9rdUpLmxJv3n6va32amzV1o6mdzf6v0PXQBHUCHnIZR6VDJuVDRDEIH8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/09/2026 16:17, Nimrod Oren wrote:
> On 17/09/2026 16:49, Johannes Weiner wrote:
>> On Thu, Sep 17, 2026 at 01:19:12PM +0300, Nimrod Oren wrote:
>>> On 02/09/2026 21:37, Johannes Weiner wrote:
>>>> On Wed, Sep 02, 2026 at 06:00:55PM +0100, Lorenzo Stoakes (ARM) wrote:
>>>>> On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
>>>>>> I'm not against carefully evaluating and testing out today's need for
>>>>>> set_recommended_min_free_kbytes() in real world examples. But this is
>>>>>> not that.
>>>>>>
>>>>>> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>>
>>>>> Isn't every possible change to address this kind of issue subject to
>>>>> exactly the same kind of constraint?
>>>>>
>>>>> I'd like to know what not rolling that dice looks like :) or what
>>>>> constitutes 'careful evaluation'.
>>>>
>>>> Usama gave some great examples in his other email. I'm not really
>>>> arguing to keep things out of tradition. But I think it's fair to say
>>>> let's at least test the common 4k/2M THP setups under memory pressure
>>>> before and after the change.
>>>
>>> Hi,
>>>
>>> I tested this on an x86-64 (4K/2M) virtual machine with one NUMA node
>>> and 16 GiB online memory, using mmtests config-workload-thpchallenge-fio
>>> with THPCHALLENGE_MADV_HUGEPAGE=yes.
>>> min_free_kbytes was 16 MiB patched and 66 MiB unpatched.
>>>
>>> I ran each kernel 30 times, rebooting before each run. The results did
>>> not show a regression in THP fault success rate or latency:
>>>
>>> Average THP fault success (Percentage Faults Huge) increased from
>>> 13.07% unpatched to 13.34% patched, and average fault latency
>>> (Fault Latencies) decreased by 6.5%.
>>>
>>> In contrast, compaction metrics were higher on average with the patch:
>>>
>>>   Compaction stalls:          1,635 -> 1,713        (+4.7%)
>>>   Compaction failures:        1,350 -> 1,416        (+4.9%)
>>>   Compaction migrate scanned: 4,812,254 -> 5,587,587 (+16.1%)
>>
>> A 2% increase in THP success bought with a 16.1% increase in
>> compaction work looks like a sizable efficiency regression.
>>
>> A scan efficiency drop is in line with expectations of what happens
>> when non-frag placement reserves are taken from the allocator. A
>> comparison of trace_mm_page_alloc_extfrag rates could be instructive.
>>
>> Why the 2% success boost isn't quite clear to me. Allocation latency
>> improving suggests the extra work is primarily picked up by background
>> compaction. Reduced reserves could be making proactive compaction more
>> aggressive. But the improvement is unlikely to hold once you run out
>> of idle CPUs and the additional compaction work actually eats into the
>> workload. It could be useful to look closer at who is doing the extra
>> work and based on what triggers.
> 
> Thanks.
> 
> I ran another 30 pairs with the same setup and workload, this time
> adding identical CPU load to both conditions. CPU utilization during
> the measured workload averaged approximately 99.7% in both the baseline
> and the patched runs. The aggregate mpstat %sys value averaged 2.25% in
> the baseline runs and 2.22% in the patched runs.
> 
> THP results:
> 
>                               baseline avg  patched avg   change
>   Percentage Faults Huge          9.92%        9.12%      -0.80 pp
>   Fault Latencies               4923 us      4856 us      -1.36%
> 
> The average difference in Percentage Faults Huge changed from +0.26
> percentage points in the earlier runs to -0.80 points under CPU load.
> It's worth clarifying, though, that both differences were small relative
> to the observed run-to-run variability: the baseline/patched standard
> deviations were 4.52/4.59 percentage points earlier and 2.64/2.95
> points under CPU load.
> 
> The same applies to Fault Latencies, whose baseline/patched SDs were
> 432/368 us earlier and 181/132 us under CPU load.
> 
> Compaction and reclaim results:
> 
>                               baseline avg  patched avg   change
>   Compaction migrate scanned    3,983,598    4,563,788    +14.6%
>   Kcompactd migrate scanned     1,242,728    1,944,022    +56.4%
>   Compaction free scanned      17,689,565   20,461,694    +15.7%
>   Kcompactd free scanned        2,608,710    4,426,810    +69.7%
>   Compaction stalls                 1,476        1,514     +2.6%
>   Compaction failures               1,265        1,319     +4.3%
>   Direct pages scanned          1,339,044    1,344,907     +0.4%
>   Kswapd pages scanned          2,011,323    2,141,355     +6.5%
> 
> End-to-end workload results:
> 
>                               baseline avg  patched avg   change
>   Duration Elapsed                98.82 s      98.33 s      -0.50%
>   Aggregate fio read bandwidth  0.2142 GiB/s  0.2152 GiB/s  +0.48%
> 
> Aggregate fio read bandwidth is the sum of the per-job read bandwidth
> values in the fio output.

Following up with tracing data.

I ran another eight baseline/patched pairs with the same
thpchallenge-fio workload, without additional CPU load.

For mm_page_alloc_extfrag, the mean was 3,334 events/second baseline
and 3,586 patched. The patched rate was higher in six pairs and lower
in two. The pairwise changes ranged from -1,281 to +1,943 events/second.

I extended mm_compaction_end identically in both kernels to record
total_migrate_scanned and the direct_compaction and
proactive_compaction flags.

Summing total_migrate_scanned per run gave these averages:

                              baseline avg  patched avg
  proactive kcompactd           2,826,839     3,145,912
  non-proactive kcompactd         235,081       275,834
  direct compaction             2,518,875     2,295,135

Proactive and non-proactive kcompactd scanning were higher with the
patched kernel in five of eight pairs each, while direct scanning was
lower in six of eight.


