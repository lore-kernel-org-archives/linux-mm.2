Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176A1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D64B6B0005; Sun, 28 Jun 2026 22:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987966B0088; Sun, 28 Jun 2026 22:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879206B008A; Sun, 28 Jun 2026 22:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5368B6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:56:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A41971A054C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:56:56 +0000 (UTC)
X-FDA: 84931438032.06.CE37871
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC4EC40002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:56:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sofk2X3Z;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782701814;
	b=6e027/pLv9xqEsn6G3vakCVm4BKz+9W5Zs33WhDbuf21hTKFL+KlmU/hRYU8YPAzWMo94P
	yHPmO80F+X2pbPaIyPAxNJyPv0O88R91qJLnyUxXytXzeFm5zvVN1ip+zww3SCo1e7EhJn
	dmMroPRjoLJinEux/m4vr4E/XkgAfIw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BvHlhZj1v62weYPLU7DsHH+iU9pmHdRZGoSyaTIcQA=;
	b=AOT/g47swIcr0NPmPIfw4BObBZWb4t1jS42GdXXrNuP2QOQpVaj2VtjDCrWCdaBd5kqHVG
	L+KOjaq21JDTRTw/sseJ6cBEowXQ95ranOcqq4nbwJt+w8cxr1s9zhPfr1vsZyyxsiVmVe
	X7r9L21PAFQItH7bYQqg6wqOkxVGfRE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sofk2X3Z;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xgbDQfDl9RydIU61gYAVdNE6DdK1M51bu+tQChvRB+aNGDwUCQS6tWFNoFBfeEZuHI/fBB5dYJwmXu1az197dtuEqcYIygaw4qOQbFBMcEcH4mX6I8X2lHmERnZ5h/aSJ54BT2CaxlnOGbvMJf7o0Fgg825tQqrBhjXlMGpZlq5iQ7RrkJDq5L0+5C8shYtqK3JC4ZlQGS6EkZAB+24pYVcEPQvY/ISv6RmiT38F+Y+oYh5sFdv8LhM+lOxYbIsJTkwi9ClHW6vFzOgwOgjNBtsGlBc0M2WrIheYtNueRnnFZdisVUbXcTv+koePK9xUfRjkMshHJ6AkRY2iuOlRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5BvHlhZj1v62weYPLU7DsHH+iU9pmHdRZGoSyaTIcQA=;
 b=n6+7oxwOiFSAFZlOwN70tsmQNuKWANLmu52sGIslx10XhHHuu/sCIrBIQ81UuzFoW0B1O5wqu8CNk6eB5TjPUtINQN5l/A77q3/ikQjOFZxrJ2S0lXoXGfsFoHpmSkxLdEauiUOIZVnr9oL9/sDSZo6uv46E7efMko1IYCGi3GBFMcqsSYHVS40CiUODACOwjtx24qLVqUH5Ia6hB3lzNNVGB8Jm6LCXvocXP5l4t4nb3NyUPNzfxiKLP6QZ9ytRtn79vHohl59ajK6/YoBhK9Qj26q+Dh5iSc711XB3ttL21MywuAIucQqzgOyzoPpsWldFIFCTgNE4oe36VoxhPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BvHlhZj1v62weYPLU7DsHH+iU9pmHdRZGoSyaTIcQA=;
 b=sofk2X3ZUk+cB7+2+3731yOC3htsilkbRlbuXtOy48D4pDHsg/CxZ4IU0ytogyXadYCLV2Zy8qGRITaAWIiNGZOx4UeEUcJR5VFlCBkSryw3b/5EXn445Rs51RPVlwsQ2F5XJ6IFBvFieV5YvP6FvkCE+nEXrfF6RSmRtwm2JkuGCfO8GgDJGcwZoZuuKe0Hq1g2SIaUo9vRuXmt/FwQ8VjKrT1NQ499bUUvMaifouJMCmpx3FOx3H/7J7ouO7K9DsyEoR7b99EpbDpNB6uXARFch4/XHI/zV66CBhi8Door3Lrn+4D6qbV6fOgTT9fAS4uvMcJiMBMaY1NVINLRuw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 02:56:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 02:56:48 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 28 Jun 2026 22:56:19 -0400
Subject: [PATCH 1/4] mm/compaction: stop recording free page order in
 page->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b341c9-895d-4265-0615-08ded58a0fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|6133799003|921020|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	L0kt4gxV58RZfBlPyl2kchmN5xvZneIUt5o8SdIFcwgHBnhoIs4hc7L0nBsGQsJmJ26d/lfwJQSzbNVA/jpyfhEWLKKgCTY7TcVVRJNi+WHbBmYBFv9bBE9u9dRTi7+BeFjb33aKxaGYVnZR9NMNA3OFyPFCETudM0EMKfhuFeJWYSXcw5rb4ArXMzmdO2Cs2669tSAIWRZkP4elJVcQfR2Wuw0xKeYZ9EEulPyQrMeljT7YmP1QWXHZxKS0hvoDlBiw7ucEq63m8mb1/rGlwUHDwRbI6b+7QwQs493KowpRl5xM8iUY2omGpjS+FJjeag1kX0di+U27kBKyXO26WN6JSoJwfL98abmMBM+e1dJ3ULSZoy76M0zDn59Ny+aYkHGHmblTogPtbXfRlEc1lbXNqwd1ZUYfmHs0XTM5gxBlQRSAEIIHsGwJer6ImiCLCcrcs/LqvQyYqcriODXqp+aGlERLbx/IIapk/I7kv+2Oatk+6oTw0HnFfpLT8WX3b06gEPhRRqxRW9BcVKQ6mGuP8oj0PMHgkmpOdFpYGZDwfvGvIEDbR6iRcHH6P1e4D8jqjwJx1He2z/lucRsxnpor8Wop4DwwSP2yQxFhxMGdYa/w2aUDJpKaPvAyDor59VuwQbkjSi29UZti1YcP+59T2kDaStNDmZNDldOb5SGW8XOefiyYlYS4UN396kE70ausGxwI0NnMZwPs/0/+aw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(6133799003)(921020)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d29zQmNvZG8xb252QjBVWkJBdDNvaXNhdUhrS2N2dzBoTG5HblVrRExDRTE4?=
 =?utf-8?B?M0hlZTh1bk5BRy9PejZla0RZb1ZpQzVEaWFwb3h3Vjd6eGVQUVNUeW5mRE1Z?=
 =?utf-8?B?dy9IcWR4TklmKzF1Ry8xUElCbE9YblNkTDkvY1VqeFJvQ05HOVN2R1RhSHA2?=
 =?utf-8?B?a2NKcEQxbzlOUkxLQkkwUFpGbnRxQktXdktaZnBnWXVjWDZzd2huM3hvM2NI?=
 =?utf-8?B?R3hKWlJGNUFHd2JuSEo1ZzFNK0RFb2c5VHlmYjMrQlhmaDZTTHVrZU9NZUNo?=
 =?utf-8?B?UGdoZzBrcjlKK0FraVJlMmdGZWh5WXpYS1lzRVhnQ2h2M3RYTFVLUUwyaTdn?=
 =?utf-8?B?WlpQemtjRFpGN0dnMmpsN3diN05zbndEdjlCNGtyZnh1VWh3S1Y3aVU2UUcx?=
 =?utf-8?B?Y3pJNXNNQXM5TXBRdTFoc3RJN2xoL09DVTJ3OXFDWm9RNU9JZnBUZDlqZXBv?=
 =?utf-8?B?L0MvRkkyeDd0Njl1SlB6U1pHbEJlVlRUZFlMdGtjQlI2UVB0MkU1dTRPNS9K?=
 =?utf-8?B?S2dzeHFjVU1yMFhiOENCRDZUMGpjZS9aSHBkaVk5WFpDRXF4RTBtZGRXZWdn?=
 =?utf-8?B?b0M4UVlPbytVMjl6Y25ONVVDMFo4QXRDaGNFZWk1aVV3cVE5MnhXYTQ5TDVT?=
 =?utf-8?B?Y0kxSWNjUnNsdHZYMVZMazZTV2NpdnZQR1RKcFZOaU5FN3M0a0JPb3IxQUNE?=
 =?utf-8?B?U1l5WFBtbDgwS0h1K3VLZVBHUm1JbkNkbHZ3N1VqTEVaMDN1aTZpZUtyYWlF?=
 =?utf-8?B?dFhpQ2xwL3RpaktDOUpSOTlTY242R1ZLcEsxUWxvL0dxYktTYzJzblpnOHIy?=
 =?utf-8?B?bjdPTmNmYVJWZngwc2dwNXdDYURJQVdkN2RyS0FYK1pqY0ZkL1lhazhmTjJs?=
 =?utf-8?B?Qm9YZlgxNEp3S21GZDRiVFA4OHhSRDVlU3oyRy9xUTQveklHRURGaUhVTGtL?=
 =?utf-8?B?UzNpbEQyM05LYytjV3dPYkZiaWNXbWdIeE9ZUjVNdnVoZkxVeCt3L3NoUjlV?=
 =?utf-8?B?WEI5UUR4Q2w5ZnFFN3B1bmhDVExFUWJRaThZUG8zMHEyNDcyOFV1YkZhY1RK?=
 =?utf-8?B?L0RyL0Z4ZjhZY2xFZkdBT0VGOG80MXJTVEJ6SEdpd21zdDVaOVFraVB3OHlE?=
 =?utf-8?B?YXNsTllGaU9Yb0lKZEVYQ2wvRk5xSXlkdDRXanFuTmVOR0RnRFFWTklsMUkv?=
 =?utf-8?B?VEFZV25OK2s2NS9aK25NemNFb3kvYzNncHBnN0RzVVVYaUFWNWcwajc2UVAz?=
 =?utf-8?B?a2xLVC9lU1NLMnQvcEMxSTZ5K2czVjNIamlSQ3BVR2hIK3lVRTJkYnNMS1Jt?=
 =?utf-8?B?b0VKUUl0QmdCdXhXeHVYUXVPNUlkYlc5K2VkM2UrQTZad3pBY2xwSWN0ZitW?=
 =?utf-8?B?aUhBekZCRDhNdzRkMmNtRk9ocEg3YjFTMzVhanh2aXRRejZvb1dJUHFRZ3Vt?=
 =?utf-8?B?MFlwRWZwMGVVenRhalFaZ0VlUlZ2aGhaRFRXTVd3UUdZczR4QWRhVzAxZWNC?=
 =?utf-8?B?RmJ3N0xtendqb1crU1h1T2FQRHdYaXlLdDFscUpMNXlJRU82R3NkcXBKM21D?=
 =?utf-8?B?c2xCb0pmQVJoT0V6dGNxamNReUd6WFRtYTdDaS9GTzgzVWl2Rkk1d1BFRHQz?=
 =?utf-8?B?cFE0eFNVY2xpNkFMT2dlT0tlRGx4WS9CVjRoUFFyVWt3OS9WWmhYMEdsVHJj?=
 =?utf-8?B?NVRabERNVGNuaGRubE5LR3FYNlJOWHFmdlEvRmprTXBhUFQ1QXd1SDBLWit1?=
 =?utf-8?B?UU5XQ3c2U0dzVHRlMVBIaENNaVQ2ZkVUM1F3eWs5Nm5na1NnZFpvblBDcFVk?=
 =?utf-8?B?ZVdKUWhadzFPZXdGdXZMdHpyQ2hleHhqdHd4VW9ZVzZDSW9wSkVYeFlsWGNU?=
 =?utf-8?B?Z2xhWlZhdDgvY08zVkV2eER4aVNrOE9qVHdkRjR3UW1YRG5QUXJ4QXNpUTJy?=
 =?utf-8?B?eFMvMDNITTdZRXIzQ1MwUXlUODl4ZVJRL0NuTUIxdlMvNGtGSjV2akdiMnlR?=
 =?utf-8?B?YVBnTS95T0JSTmF6UW9VM1VPeEFGUEJRS3o2VVNqSW1zbmVGbmUwY3hVU3pn?=
 =?utf-8?B?eithV0gvQng2T1NYNkFzTDVYSjB6OGlWYjJHbG5pbStSTUptcHN1RENzb1FL?=
 =?utf-8?B?RzNGdlZYdUY1OEZHbUxSR0pLZzNHQ0xROUJEQmIveTZZK2V4VXBVSkxWSXVY?=
 =?utf-8?B?NXN5VUkrRW1SMDZlMHhLckJSV2phejlyZmFaMGVaNTBqblJOdnZnY1RkcWND?=
 =?utf-8?B?bndjOVJWeUNRMGZpODc3d2JqcUdLWDVjWWJXRitXa3JqbjkvcmtKM2Jab3dB?=
 =?utf-8?Q?iLVOgJtJlkMnWwjkpr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b341c9-895d-4265-0615-08ded58a0fc9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 02:56:48.0845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NCnH6K790+hG2ZBU0yhKCYu+GxTn28xrb+CBs1SrYqxxKQd3ZQC6CPsBU+oJcBoC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Stat-Signature: 85bdkeudrh4x95apiygp3jwsuzdfgkwm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC4EC40002
X-HE-Tag: 1782701813-290995
X-HE-Meta: U2FsdGVkX18Hsq3U1NCRE91oPNiYRsL85v+J/DsWRsbXBVOw4QLwUyzeB7DgUm/Giy2+sosz2nB3Si7LGUTwseeoGt+nkbmyR1J1Z5KpLd8M/qcAw1u0XAf4v41fX1XsuvG2YRfYCEaPMk4ujRUo0ej8EKVE0RnHU1gkR9t8eD4WeMHfEsXaafCGReYUee8SHMJ7iBtvEOJZaUp2CXdZKIqbxedBR5raEHo3uN3YaMenDygy0HEEnOpZLt6vofc+oLHfmqLIZQzGZgemb1ge/B2JZ6R/WWvHN+wz6JRij2djgqImyiLRcYdl4itPuu2gu70Dv3PwGArrPQxT522J8e5gAlgmyQ302w7zRTJ05W5CeWVG+Yu/Ogx7AYlRkv/HgY6cyKYKVo1qLmKnwVDAqmgevJW2HXdLksy5LhwHhCgy9yEkKyyse1YrAS4EhR6q/pZr4qiHXBD4grnvTy6zaIFl1ozMSIhDf/xPCsImi+rFzJntVmCr5O/i0LAouWyTzmWY2OIHOpijyvBMumjcncfEY8pklzOpmBqBn2Lz8Xu7OattwYl9D470G/T/ZP4LymVB+WSUugXZ3TZqXTIDVNA1D0dQ4gMGBN5t9seutobsoiceTdFkjOtyEQ3to16ycgDxK/FR19wGJZgTR6ayWm5IRRZ/B5/FvK22Rd2VerxOjE5xtWcxmkEyOAk/OeeeETzTUJOmDiW8mJZyYxfilZ9C3hsmkQcgdR6nqgkkKuhYoBnTcefac9VbyTs2nisBK11diFNsrgcdcyHUQgu3kPj5SKxEmRdGkpKttSeac7Xe+W6MWb63d0KzNpNpwuRBwMkLhBEfYbFpPLBAa6SI5GS7jYRWObAa68z09Wrqqz0LwDyimzMS31s0/3EhDJOPYg+yLaoJzglsj961JAxRlq/+LLkmtYk62v86Wu+RB1DTKGVNzER+PPdPfYGgwqQll4GpDZSpmo/FW90IdYt
 MkFf9lqy
 TD5jKOxbmyev9dU6dMpF/96aQCETUKwsI868NMKXvKf4lYJdu7bXQ0TpEjVBYGnx3ZN46jJ/iv1T94zU2NbSER5GJo3E1ceKvu0iFkAsdI19g7x1Hh/Lvarpd8GL3b2lJ0oqjMa5FEtpFAnbtlspcCZR7T5pdrRFMESREMgcSbQXsOj2RQHCOsOiTyA5hS8tDxMEwB3HVTQxLF/SQAQGx48FErqZ1h5Lg3ovNdpbfhlrG9nnly+J9cDt439FzKpkDJb8LTIUGIAs7FALZmUtuMO/lY0C1PufxP+MkWuk7rEaT9cLiwiPNRAzBDvM7TaWI7js1+FnweADMgJe1XWBuGVM7IojMzkZVKYAAXuiLEVJqglHpK5wC3bSaR7s7fy0yF256nZo3WqOSLzf/BvngfNUymw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by free
page orders, it is no longer needed to store the order in each page's
->private field. And there is no code using the stored order. Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail(). In alloc_contig_frozen_range_noprof(),
isolate_freepages_range() is used to grab free pages from buddy allocator
and it leaves the aforementioned page->private set until
either split_free_frozen_pages() or prep_new_page() is called. That
triggers the upcoming subpage->private nonzero check along once
set_page_private(0) is removed from prep_compound_tail(), which is called
via prep_new_page().

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/compaction.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b776f35ad020..349838cc6c19 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -644,7 +644,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
-		set_page_private(page, order);
 
 		nr_scanned += isolated - 1;
 		total_isolated += isolated;
@@ -1617,7 +1616,6 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		/* Isolate the page if available */
 		if (page) {
 			if (__isolate_free_page(page, order)) {
-				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
 				total_isolated += nr_isolated;
@@ -1846,7 +1844,6 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		size >>= 1;
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
-		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
 

-- 
2.53.0


