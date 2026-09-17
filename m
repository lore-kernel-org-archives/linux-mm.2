Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEEDCC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789846B008A; Thu, 17 Sep 2026 16:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A3F6B008C; Thu, 17 Sep 2026 16:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6EF6B0092; Thu, 17 Sep 2026 16:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 150D56B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:43:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75CFF404B4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:43:35 +0000 (UTC)
X-FDA: 85224429990.12.AD096A2
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012053.outbound.protection.outlook.com [52.101.48.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6C5F1A0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:43:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ciqVaf69;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4qMZvR9Gm9CpbplgbgXkqPpLCny1BaqTVcqVpCLx2E=;
	b=ZhCA+C5x9uH1ux+Wvf8n2X6hzlNE+4XFazJa+lAPNLHJ56H2P/nqxyfTCJyJ8pKqf/LFFq
	WKf1Pu8KoIkZNlYzEKgql5VAWSogfXtnYIfGhxJgQF7i1HR1eIhNsDnRvibMepQlGoxpUX
	iClcZOrXpDgTSA/FsmWJYDJUMRmu5sE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ciqVaf69;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789677812;
	b=sxBZX3oHdnDyc2AigeVhBkPo3Mg8pk3Ac965dobqKr+Bjgz/3FgD6QsGHbqIbKYjQL5c2U
	Q4xpT0L4spmou2c5MTwrLNyjffvb3FrqPRL3pKcbwhYhsedvLWpDMa9hX0+FSZIl4WqfYU
	BFZdzSn5es65x6J921bOT495975Frhs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mN6eawpxJCIv5qPrsYOx60Eynyvma74v3cPS9HJ9ZWLsflQKTvUfU3QHaNoiOuY4HkFRmroKPyfziQyc83iPzEqSbJYu37QgF3hcC8p+FkJweuIQzBDRD6WJ6R1hp9T6dV7KsKsiBcq6RFc2XF+XOh62Xy63lzKfzISPKYKvil/lep8dfN0z74ZmJ4GTFQtQhXlqNfsXHw3b9HALImAlZFIl7aCK9XoDwqw6oS+DtiDi+zs18qiLjTtSoi8UjcZsuWwwb2o2mzRUvjo5kc4q2R5XRs1/n+7xlw6rNoXfkbw/tyIukAKCxe4WxBNKmb9VOajZ3iIUf0Niavjb18mNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4qMZvR9Gm9CpbplgbgXkqPpLCny1BaqTVcqVpCLx2E=;
 b=sulkwBdGCHFNr55GRdJCAnLn6LC4W31dzeoSRgjtk0XiNC5HAzadFPXRdTGCkndEs0bu7idBX+sk8WifUkizCx76sau5KKKWcW2ifEHGPbLfsFM9nHG8mKtNAxq67U1R6DsDr18ls1qO2ExYNrDsvPytuIwR7VOkrQtGlPmuErVA0PMre3OBz/jextmWz5T6NkrORO8W3RBIO2aVWdbKyHekLwFkHTWQhCgaDBII4nhiR1BQ17ScTFB2+wxyuXyOrZYC5h8YyDDLPdwEOLblspsku95KfRDgqQuLjQest+uq4RYQMWKXuwUZScKLQDR8TWkNVwAKZkWwOoq3xnCdpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4qMZvR9Gm9CpbplgbgXkqPpLCny1BaqTVcqVpCLx2E=;
 b=ciqVaf69G0O7JFsMcnwh79Ofsyj3sPcf83rEY+1mT1FK+K7LnQENnbDIFl0oELjCfV1wK6ViWwrh4E42311QNClAkPM4svt2VJUv6DdSpB8kp4j91PwthRU5K0NaFMcTlx5QZbbgz9a64V5gDnImbfCJChiiExouywoI0TxcFZLtr9NNXWodt6MT+M/VQgsBjElaYMUct0ta8MMo2b0z64KaCVfv8t7RvpFIZJ+LNtjy+Fbs36npDv/TFE7kVQu1xMBJSNVmJgrwPn5sEd7kLTsz/NKIkKdovYvSD/WUYshklH9ipOIhITmH3yvxwO+e0yKonjqRbEsTzWLGhOLIbg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM3PR12MB9433.namprd12.prod.outlook.com (2603:10b6:0:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 20:43:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 20:43:21 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 17 Sep 2026 16:43:15 -0400
Message-Id: <DLHVTX80IKX4.GKQ7P0C8S5IK@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather
 than anon_vma
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Xu Xin"
 <xu.xin16@zte.com.cn>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Rik van
 Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Chris Li"
 <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng Shi"
 <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan He"
 <baoquan.he@linux.dev>, "Youngjun Park" <youngjun.park@lge.com>, "Peter Xu"
 <peterx@redhat.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
In-Reply-To: <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
X-ClientProxiedBy: CY5P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:ed::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM3PR12MB9433:EE_
X-MS-Office365-Filtering-Correlation-Id: 7011f993-aba8-4931-b061-08df14fc5003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	X9mKlrFh+z0w/51T+sfXik4fAUdLQuLVurg9q7UPl15TRHsW7Bwjk0v2/UEr08dF9hAU+z5tr5TbrpVtUIxAwxwB7GCwxN3XWImDGZeHkL9tqnxeWWxw2Ro/kmFxoYhBmkiuGe4TsFQV9+rc6sGRbG9inHyxRU2DjMgNzWD8r5z5drQ8Bx5yjHP9u0cbU/jR6o8dMjV5d2xHxNperofT8NrLRRYBMF50lZ7jSzDXJIjNy1ebAMgm/zGMhNBQEn43T8Chv47U0j+tmibrkmu3ChyY77vmjbfa0VKs5GbdFmQiR4CyPEH1ejRDRXch4vYgkH4m2jkhTQ4EwG6inCZzuj7hM0iIrhFIyoSkNaw0KesAR1/hKbgli6IKBAuz8ne6sCNNjirYybY5+yDErE1cjUHlMMoM5i4QEyI/MZNny63TwWELgTyz0xWsdkUMOUlgm5AVOMH3soktSogaI+Lw6ANkSBLR5Ewcdd7HMQDQFLUguHOYXQ9XjGJEM5evVwi1Lpa7W564iiRKMUeMg4k9ItyplRQXPq2S/gw/6U1XqzKYXDyy5dpwMnxhQlKtLreKxZDIkrxwEjwxI8/RhA5w71JRa5NTT689WVsjz1sYf2uNZ9A1OCmtyYlecJK19YEOsx7LsKvDr3pgcH+YKIKJGgNamPIXoSN5zOClW2n9rNIgmqG613Ls078A8nVU9bABIsut/KZIjqOpJbLPJG+NKA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzliNWtLVmVuZEdoK2g2dXU5Q3R4OUdtY1hMR0xDRjZIZnVaQUg0eUE4bFND?=
 =?utf-8?B?clllbExRVzhsajlkR09PbmxSNmV0dlVNQk9QMCtwU3h3OExJWnRJNEs1cDVN?=
 =?utf-8?B?WitseW4zcndPbTdDMHgrT0VNR05vRUN4a0lQaW44elBpeTkzSjFuOTZNeDVS?=
 =?utf-8?B?d1Rjd09iaVUveDV5L3NOY05NT2pxL0krN2tiTWQ3M2tRa1NwUWJqQmQrcWR4?=
 =?utf-8?B?MWxVS0J3N0laZ3p4MHdtcE8xc1cyaFd3ZklRa1FteTVUWGhRUmptQ1NtWmtB?=
 =?utf-8?B?SDNrMkMyM2t1RUs4blRGTS9zUVRtNW45NUFMRTZMdGpRTi9RV1hjTjZsODVt?=
 =?utf-8?B?UGNKVUhOL1RjT3luMEcwTEhNZ1NIZ2xBSnVDa2J1dXBxTDBkaytTV0FhbURO?=
 =?utf-8?B?b09jcXRZODc0U3JsUzhXbXBMS1ZLM2crWW03b2tvaUNnMWFFcG9QWENDeHlH?=
 =?utf-8?B?bXFFN0FtL085L3RLRzVsQmxPSWVod1d3WTlTT1JteWQ0bmEvbVlwb0VXVUFy?=
 =?utf-8?B?YVZtYllYdVJIUENuS2pQNnFVVUdLclk2UDBoUkRhSXdDeTJ0cGI0c1d1ZUs1?=
 =?utf-8?B?b3lrZU5zc1FqOEMxVWhyYmw2MXlMblFKUDV6dWpkMS9EeEVMc2RYbUFMODhi?=
 =?utf-8?B?RnozZVZpbktkdTcya0lWaFNFMEhsc093eW1Od0hkK0QxOXFMbWpvSzlqdGZh?=
 =?utf-8?B?YUdoaVdsZjY0eXFkUzFzN095L25XdE5YcFhscGVCN3JiZ3YxWHM4eHluU2xB?=
 =?utf-8?B?WVJiZk9PS1o4cm1QTi9oMU9Nd1FpRTNjajBIeXZ2bUJLNlNybnFhNUFuQTMz?=
 =?utf-8?B?dVRjemZzcFllZzFBbHExOGliQ0pmL0NyVW9CbnJacWVwSGk3STZOUi9KTDZu?=
 =?utf-8?B?SklBWFBFaWVCczJvWTNzZkNWQW9xd28wTE5PdEFkeGhzOTlHaTFkZFl1TmZ0?=
 =?utf-8?B?c1B0czFZM3gzZDJ6Z01YdlZMbEIxTkI0c3pVY3doT2M5TzZ3SkZEdTZ6QVpj?=
 =?utf-8?B?VlQ1RWNPdm1FenhxaFFQSkpIbHZ0WGxkSDJzU0RvOUZkTkJ6N3dUT3ZDeEJl?=
 =?utf-8?B?UWJGWXZYaWhpc3pqVVFmVW9EeW5SdnJCRjErekxLcm5PZzVLdllmY3pVRnBL?=
 =?utf-8?B?RDQ0K0lBcEhIYWdISS8rU01kR0g5NEZ1S2pGaklWSkZoTzdUUjhJZXBrRFE3?=
 =?utf-8?B?Z01IMW1hQ2x6ZUZlZUMzclBrdWNacEMzYmxuTmZ6VHYyRFdwbi9EanAzQWRL?=
 =?utf-8?B?UWZ1Q09aNGEwd1pLdTRVN0hkcTdBVWMzTFdoTUt2Rzg3bzBnNDZxM2VGN09H?=
 =?utf-8?B?Mnp0NDk4bjRwMVRZYXhGbHJHbWdSWFJpQ3lvajJHSEhvL0xrYzNvenJPNk1q?=
 =?utf-8?B?aXh4NWhYSncydndsWXdFQVdNYi8ySCtIQVdpTUt1bzBVYUQvWWExNXMyVnRI?=
 =?utf-8?B?UloyZ0JuVG5Nc3hJVmRpejAwMFFROWlqMGE3Nk4xdU9YWVMwY2xVSW95ZkY3?=
 =?utf-8?B?c3lqOXZDNWJQQzd0bDZvMXZiYTVHUDhZOG00NDJOSER0YjJqK0QwK1E5S1hp?=
 =?utf-8?B?dVRGSDJCbGNuQmp2OVZFNEdRSGhXOVpXcFUvUERxbGdpVUh1bHdVZGRoWTRM?=
 =?utf-8?B?WWxGbWU5VkNjTXFKNE9KcFUvK0ordU9LOE1NMXozckp4b0k3Q0ppS3RuRHZW?=
 =?utf-8?B?UkN4TDNmMUlTOXBVLzJaWUlEZ1FGcFVKNGdMRjdkdi9SeFpVNHpMaCtYbHBK?=
 =?utf-8?B?eHVaMTQ1NGR4U3hnZkR1cXI3TXJEY0twL2NoWlY5RE10UDlxSTUwVlk1Zk5h?=
 =?utf-8?B?cG90OUVRZmExeVR4QnFpcS9rRmlmZldJTlQxSTBFdU5SdkVaY3kzd045alIr?=
 =?utf-8?B?R0dqMmd6WTFCWHNwb0tKY1puSE1OV2wwV2dXa2h2bmhTSStVSXNvbWYxRGxY?=
 =?utf-8?B?c2crbUhuWUNWaVdINmtUSTY2K0xzMmFYNEd1RkVEYTF5ZVVYK042Vk5GdzAy?=
 =?utf-8?B?VWFDVHVKd0wvcmVVTk9tOXhYYWlmY1BoN3k4SUNJOWJkdVpWenpEU3N0b3JT?=
 =?utf-8?B?N3phQmtjS0lSTFVSZE1RazJxQ0hOMjhIc0lsL1l4Q2tsZ0dYLzNOV3l2ZlM0?=
 =?utf-8?B?RU9mMWhmdU1pQmcxOW1iZ1MxTjNaWDB5MExSWmFxUFIvUjVnQXREKzNqZVR1?=
 =?utf-8?B?aXYxQTVWb0RPOVovQjdkaXhoQ3UvbU92aWY5bldRaU9FOFo2aDlFTm84Lzgy?=
 =?utf-8?B?cE9qN2loS1JrQk1PTlNaWHVhTlU2Y25tZ3plcEk3RW8rRzN5ZTZsWTJpa1pJ?=
 =?utf-8?Q?V7cLvDAsWoulbff4y8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7011f993-aba8-4931-b061-08df14fc5003
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 20:43:21.8374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HpmV6+qT/Ggz3MdZxdb3FfglPFUu+f1ZOKF4HTpI5nzH4GeWarAWv2qOFsbbIss
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9433
X-Rspam-User: 
X-Stat-Signature: a566a8njmsfg1afgsyuzj8ceje5kzhd9
X-Rspamd-Queue-Id: A6C5F1A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789677812-447827
X-HE-Meta: U2FsdGVkX19781OQmGaEiqjZ38VGx788DmzW7WWpC8k17h2JBdketZtowc6ZYs3v2z9DhJkFvoLMJA2eEN0ZMLz9GyEPFVxAkzFyMk0SVK/gz9PF3fekDAjnXQruPqshtfiUUwvRJArIy4JHEvm9zM3RjuMuX7Qu+ByIBxig3tMUe4QLhq3nrqRffi5hrqq/oY4gaENdpWr/pB20kwN2nanFfS7bYyut7XdxMQMfwbaExpvp+BNyW9iFlOTDShhsRP2x7w05vv0qGAVnFiGwojRvZyEYa6BWerOoNmEX/kHTICVsN103RSSx2uE9PUxOm99TrOKUW9yRiTOHGhgolXgK74RCR3MsyeLz9HAk8W3kqGi7CQSFcgvQEsZOMimvgPNPNXQPJWqufEL4q+VuUX0EF6qjlSitoq5ThqkezrtDsFQmwG+Hc1+1YLYStmNTdL5zd5dn4O8JQvj1nUlhQC1BXTNNjMqz/H71mVzhzswCvQeEA6tKZiMyhMbDeuaYia4643Cl0fXRlSfop7f3LCdggxnl5pCjHZqiGAHTcLtV0s1Zp5y+9l5APEhJs+o7TTmhzb2qjgROsOAK/0TOh+D/WWzqJg11/nBX7cUdQC5oOlij4wRuLmTC0FNo3SAij47u/Q0++FHvJ2FbXtlG/1tnT6366SaOoUmtND+Qj1FMgYAetgDZpPoZYOtOitt4EJ4UjbyQwVXiVeo06WGEUOJQT6TVmtgdE3FbZrc77GLHSvHi5nAzUjfThDpjqDm/f8hbxwlVzN34xpvKJQ5hD+9Yxz4FAq8DACIATAjCijOyWpGyU6kdvs0XmWt2pDnjf0QdLeBPeExhhDnjfKze6GZHbGlnHDJVqozaGhhIIwAFEoUfM5kNbr2AX+K7rfiBxhgfj+VqpKT4LADo7OmQAqYZUBPaa+gCRMSI9xQqqtsb/sI4w/RuPBswtn5rkY3wXSfJ/97XCOHqs6Dyr22
 itXg7xVG
 ntbAz+xo3tKRL05q9XWnwiK3z9xR7aYA+zXAYNuoXCi9L7cf9NrEJozfdL7/SjuYj/cCT7vTmbGgHMyT90zSGDjpk7N6viEWO3wH7W2kLHm/3UHjq8hvfoP6T9HSV2OLEnKq26y4mpyRX2BO1il6Lik2dM75NYXCOJDpZ/Ep3cDNNzx56s4rjpI9szBnp07wNG9WFEhvs+QR14zF5dkZG0en0LkB+g7+o8M2fbmr+K2GloJKLclNjyS9g8/eUMwSgbPOaTFgh9QtDFggzfRTjSdQQP9HrZ9bL8hCrvlRdmmBcUy7W4/N3Q6tuGTxVsU1umE3cJt0a6Ols7rLXinD5x3TGFdE33hxZpKST0E/+uA8erfipQyvoq8pIgH5E536V/L4/qROgX6KMbF8iNuULuwYvLrHMrvIU6M0kRB1CgYUBZE0ZosqzlaomyI/Byo/febge5asFzBvu1d2JYtVVjKeo1zdCprkLAEdgB+E6MTyeZIZ5WEB6TEPHnv3pRYyZcGFe3hel6RPG6rUdGKhbpRAp+JMf5y03m3gKZpFaFqoSIws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 3:47 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
> reverse mapping, remove references to anon_vma and instead reference the
> anon rmap.
>
> The anon_vma is an implementation detail and should be treated as such.
>
> Do not update mm/rmap.c which implements the anon_vma mechanism as it is
> reasonable to directly reference it there.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c     | 17 +++++----
>  mm/hugetlb.c         |  2 +-
>  mm/khugepaged.c      | 12 +++----
>  mm/ksm.c             |  6 ++--
>  mm/madvise.c         |  6 ++--
>  mm/memory.c          | 12 +++----
>  mm/migrate.c         | 12 +++----
>  mm/mmap.c            |  6 ++--
>  mm/mprotect.c        |  4 +--
>  mm/mremap.c          |  6 ++--
>  mm/pgtable-generic.c |  2 +-
>  mm/userfaultfd.c     | 10 +++---
>  mm/vma.c             | 98 ++++++++++++++++++++++++++--------------------=
------
>  13 files changed, 96 insertions(+), 97 deletions(-)
>
> @@ -4176,11 +4176,10 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  	if (is_anon) {
>  		/*
>  		 * The caller does not necessarily hold an mmap_lock that would
> -		 * prevent the anon_vma disappearing so we first we take a
> -		 * reference to it and then lock the anon_vma for write. This
> -		 * is similar to folio_lock_anon_vma_read except the write lock
> -		 * is taken to serialise against parallel split or collapse
> -		 * operations.
> +		 * prevent the anon rmap disappearing so we first we take a

s/we first we/we first/

<snip>

> @@ -1619,7 +1619,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rm=
ap_item *rmap_item,
> =20
>  	/*
>  	 * We can consider the VMA only while still holding the mmap lock,
> -	 * so lock, so reference the anon_vma and calculate the linear
> +	 * so lock, so reference the anon rmap and calculate the linear

s/so lock,//

based on the code after this comment. Please double check it. And it is
a pre-existing typo in the comment. Hmm, it sounds very Sashiko. ;)

>  	 * page index early, before stable_tree_append(). If anything goes
>  	 * wrong that prevents the rmap_item from being added to the
>  	 * stable_tree, break_cow() will clean it up.


Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


