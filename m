Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7256AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542786B008A; Sun, 28 Jun 2026 22:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3A26B0092; Sun, 28 Jun 2026 22:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409816B0093; Sun, 28 Jun 2026 22:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8416B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:57:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F481A053E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:57:02 +0000 (UTC)
X-FDA: 84931438284.25.AFB6484
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id A6B0740003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:56:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g5VybDGi;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782701819;
	b=B7BvQlIISUIGu+xlHjVgplchRDcBMyDKO99jZAEY12mixlGRT6+K80iEI3RfJKhBplRmDD
	nJ+jbjDsrEHAYeN/6As6xp09Spn581+JbFgVpl1x7eCgJIHt3mm2jHWrLjFCqyrUfRWoCC
	5Spm4EIfjDsQ4TTLLJa/39/ejpjn7MA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEDdoAfGWbBe14kFzvqi+I5rw74PsoitTgBLDQMuA3k=;
	b=c8VsipP3qd28zs3vlt1ZkQHu9rbm4RIxJbsf5+dv8lBXEPFpEjAXFuGCaRowKaPtK7x0UF
	B/RymALEdxUZ4zzp4rKrNUHSZQyhNl0QUh290u+OpxA93G77tNmCc8G3bQjjTLaCovNLUB
	gAwyzeRFqKuvOGXgNL15rGrPu2LqLCw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g5VybDGi;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXkBAQC5xx2ANT50BzU7ShqamBb+pQ/2sibnGPBbdXcpvo6tm4i//skTzXVAK1KHbt66JFcV8f6lk0j7sLBRc+Ez0s+Q502UsnNnoNDVMnAdZfTQ856f28WLmu+bCgeKz/xLWdYEas6Nrcq+8ktxxbMWmQEJCHIUWyo9JdIJUSWFkBXybn+vkGIHd21S938yaBMOGF+YB4Y3S6HQkfIrS55V76bypRf1pUK+YzN3eY542d1HwUd97xNv+eAE7DEHBCE+KiUlAKZPNDuNWA2bm0AYgyEU2aLuh6xFqMNEsq4M9gKUpg404J0opte0Yuco4A88ThYkxEP8lrbCuKmTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEDdoAfGWbBe14kFzvqi+I5rw74PsoitTgBLDQMuA3k=;
 b=fuPIRRPXS21FQuYPdZV0pnboyZSlc6zF0aKp78FKoD4vjbITgOaX7JY+BcNTa/dIS5TaGqhiXh2kTOwaA0y8FvvzmN7H3UCbXJ5JtGhfa1P8zNmF+vwsuo3tt63sttdzHC+t8pE80qC0PrEWMI3/pWN2bgyTXnZbCg3DOwA54dwD0j2ze3kia5mf5CUWPiyPYra4+FlXsmXeonwzO+gaKXgdWovgpYW3Hl2RIoj3Au01FpWYFA3iFZae6tOj6zFe+Wymuh84OoNl+FgGrC0lC+3PwWyw723NNJXkqUoIPLpkg8SiGnkf7IhCEjKFN92HN6pqR/YlNUPv8nMwcUWNgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEDdoAfGWbBe14kFzvqi+I5rw74PsoitTgBLDQMuA3k=;
 b=g5VybDGivlovJ3hkMwHi2VppfJM+OWGXQr6img81u0jpHClKIISyMCqE9ElmcMGi5l7odA7kPiqAQ+ebb60cJ4Xw+EOXUzsyI8FdmGnTtictdo04gq8F/CcWxaKP1H57B55fziXIALt403vHxd6ZZV6VUlyolZ/Ym9UTNkifh9XaB+f1jkGgXmT3IaxeS1YbRp1vQnpZOSNbfACBjXxdLFz1IkkqmZLzft6PbMN3lAbzkgZrMdkmVb/ao6JthHlFFvfCrQ8Oonp6OWC0oekshcYlFSnHMlfJ32dhWMPDvSkwTK98JcNpCMrCgTqncG79Z2vdimKD+k/r9FzeGYMM5w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 02:56:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 02:56:49 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 28 Jun 2026 22:56:20 -0400
Subject: [PATCH 2/4] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-keep-subpage-private-zero-at-free-v1-2-f4ce3930d10f@nvidia.com>
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
X-ClientProxiedBy: CH0PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:610:76::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 601bf62e-520d-4721-d464-08ded58a106c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|921020|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	kMrzqvl3qnAaa0/HrNSYKTljqIBYUNXNCIuTbQsFtAyMQaaGmDmhQ8OboGY+BTpY7Yv27bWdHPjKny146pAQmaaaTPy9Qjoq04ZYVmojnyPxmzknTzLP40ekktWtBWUUe5Ld5NrZ0zXVKDUYXIjsE45uWd5IZkczoVsU7xGEBh3X5dZSnusUepYBMasJd6OL5a5joX4rFtcZL7czs6wxGVbAql6UlBEhpk1Hs0DxMEZaXTRfuAOoon5lhxq6dleZ64BBC8n+UWs2RCrqmMjx5zU8w0NtP7zwROO4BmUa5yAQYa3tG2041W4yuDRZp85Yix7usvFtOo1LITvqVAL+FAF5Nree517VZ4sxiL1nmHnDw1/zKL8BvqpSSi54wOsYzh5NMqsQsfRQ8H3mAsVUMF5ciDwA4oo7FjVxHX3W8CSCf+gpsibCXHvfEexpt7Cz8NVo7wS/waXgLKDdmx7b66h313aT26xlS3nWwrZUKMmt+5WUhZGsN6kgUX9lVPZggjq4DKYpdenyM88cOH1w7lnYlo5lM1UGiEzwPAWXfkVZOs4DR0xXpQWBQ3LVfttc8cRWCKKVkXYhokgyraL8/06kbJv37nKYyC+9+ylosTpRoXMuDmCb6y7Wgjsyv2ZNTzFb1bUECOHgavmPaZIxC351L7setsJdtLurpmHcWyGH+t5Y9aq9pj4bJO6na/q5nyFZNzcUoXwrNudF6bRbJA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(921020)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3JndUFEM1Y3S3Y1enVrSVBMSU1Rc3o3SnVXSHdVZFo5MUJJL0RZblZFSGxy?=
 =?utf-8?B?alBwRkZ5dmZ6N21IcEFJaHFReW16Q3NOVlBrQWtTYnVqQkF1bVNwUHhqaENt?=
 =?utf-8?B?NEhCR3JKejVRZ2J2U3VmV0N5RlFRbERhNTlOVWg2WUFGQklQZkpaTTBMTmUw?=
 =?utf-8?B?ZFo3cVZxcXBpbGwwL2JHMGw3NFp4bHNmR0hmK0dzWEdFZUxKZVlzZ0l4L1U3?=
 =?utf-8?B?bUFkc24xU0tsT2lrc25ac2N5dW04VjBKRHk5aC8yQkpQQ0VDYU4yU214UHZw?=
 =?utf-8?B?dktLSFZ0L1hza3puQ25YQ3pRWTdCYVNDNjZ1MksyYnRjVTlvcWdhTzIyS3Rp?=
 =?utf-8?B?Q2RkT0xEL3N2VWZXaEdrMnBNeGRXeDEzTExrMml2MEpUUnhMaDg4K2hMQVRh?=
 =?utf-8?B?N1Blc3NoeUdxaWZYaFpLNE5MQytlZTNtSHRGaGVRK2ZYcVBFT09uNHpGZUNJ?=
 =?utf-8?B?ZXdoMm0vUGJJZ1d2eTdVRlpITlFMZ3NjTG9PZGRaQU5jdHplRlViaVBQd3Mz?=
 =?utf-8?B?SDltcTQ0WllUSDFKVmJrRUZHcHpYU0paQThIV1FCMklodGNHWnJyU1pGS1NH?=
 =?utf-8?B?R3Y0SGQzSDlIQ2xESGVVQUgrR1ZlQld5N0VhWnlheFU2bHBGWWtMeTUvUEhr?=
 =?utf-8?B?eWZWKzc0d01iRnYxODkwdVBjb2s0RnhXZGxSMURxK0Vudm5WMGhkRHJ5Z2ti?=
 =?utf-8?B?Ymdnd0Y2MkMxRWpEWklVWDhQWmxHWU5rN0w3eXl5QXpHL3AvUjJ3N2x5NkxD?=
 =?utf-8?B?SHdxalVlQkgzbW9MbllyYTdCcWRISFVzR0lFVUkxWjZhTkdzMThkNUo4N09k?=
 =?utf-8?B?Sk1BcEhjc2l6Nzd3cDA5TE94MmpXcEwrTDA1bEV6b2VXZjJuZkZkVnkzYzRi?=
 =?utf-8?B?UEtscmVwR1JqNnpXUnpjRTRsRHNRVERHK0VoU1AxL0Uvd29xcnhjQ0NJRUJS?=
 =?utf-8?B?TmhDL2lsMXp6RVZuWHcvUmN3a3JtV2h1RWh5emxBeHJNaUh2d2EveU1vTHJZ?=
 =?utf-8?B?c2NtR2xGc3MwQ3JjR0lrOGh3RVBBWTJhVWdwb2lCMGZRMDZOZ2NZcTFBYngx?=
 =?utf-8?B?dTl5M0FtQW1qTHJKVTBReHBUWkhYM0VnZ2xXZXM5UHJPR2lySXFXYVlJenpm?=
 =?utf-8?B?ZE9QN1hzS1dMR2FCbU5Xc24vSHhNaWduSXR3aDllOWRtZDZsYWZrL3BLTGxM?=
 =?utf-8?B?TmUzQUV0QmUwaVNWUkdERGxpT1BrSldiWEQ1eXBoVFV0b2N1b1E4a0pWYkI4?=
 =?utf-8?B?VnNWU2JCajFUUHJHVDVEUVhxQ2RucGpPYldidmxDK1Q2MFhPcUljUUxsMHRj?=
 =?utf-8?B?UzhpMGlXMERYQzc0bUdkKzRQR01WNXRNMlVvdmdmMGVJbWdlSjFZUktpb1ZN?=
 =?utf-8?B?NzFaRlFSeVVsQ3BBZGZxQzFjK0FBa2M1RVBXRXFPL2pwQ2FCRGJ4OG9sdXB2?=
 =?utf-8?B?T3RPRUZ0VHNwaFpFSzIrdFlJMU55Qjc5QmlRSndTTTQ2c2tuY1lFbmx1ZjRD?=
 =?utf-8?B?eTVXcnN5ZUpLU1YvQTlVZ29QVU1WWFErSjZCbXExdXJGTUo5MUZuQzkxU2F6?=
 =?utf-8?B?Y3hvbDBvcndINGRCSXkxTmlPV2NnM05YVFhTUDBXUmhnM1NLaktETHBveE95?=
 =?utf-8?B?OFlTQXRwOVJCbDBHZ2NzRlNwSmhLK3JPUEMwTTVEVk9uM1J2Z0RRUi9Ed0Fw?=
 =?utf-8?B?SU9BVWovNitwdXhPWGxzd0JnblFwdTNxZFR3aFIyUTVSMjZBeHNyMVhuOEdw?=
 =?utf-8?B?STBWUlI5VUpZYW5Va2diQTJ2aHNrcFdxemdNNDBxVDU1ZU0rbWk1OU1uWmkw?=
 =?utf-8?B?RlNsNUVmaEkrQlgxWm1GZHpPZTNXNm1xV0dOOENobmJBZUlKT0psV2tFaVRi?=
 =?utf-8?B?TXdEdENMdFBrZGcxSWk5cDl1YnR6VzR1RU1uME05OERGbW9GdXB4ZWlOb0FG?=
 =?utf-8?B?WXMxY0h1enVBaGIxOGsyaUFhUlpseEpnS3VIMWdiQmRYRVJPNkRJTmhHbXh2?=
 =?utf-8?B?R1MrRkpxUUcremUyZWRyeWtmR2JDa2FERjBtVGE0TUQwQ1E0WFVITXZjRkpP?=
 =?utf-8?B?MHVNTUpUeUphUVNoUjdCWWMvR090YTI0Si9pcXQzdlR6YWU1eTZDRG52V2V2?=
 =?utf-8?B?a2lFK2xrYWF1d1NWSHE2ZHl5UU1nOHRuU1pJWTFHck5UZWRkQjhpRnhJWGEy?=
 =?utf-8?B?OERzOW9taTMwSU44RWJGT01IUDUvaXpLbmNQTXF0OWtxalBoS0xtLzhlWHo1?=
 =?utf-8?B?eFROZVBJOTdZcmFIenNFa2xNOVRyQitnczE0MXBwS09CS1JnRjRjZFQxcWtV?=
 =?utf-8?Q?cXpBgjnsU0BoIgy1Sn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601bf62e-520d-4721-d464-08ded58a106c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 02:56:49.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqNQrSz2g7O4lzqNMZa6HW1qYhzWAznHnRXZvDnzEYOSHl+2YMRuwrmR1ZOMTrNo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Stat-Signature: 3us7oeciz91e6smnbj81frteseonsgcm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6B0740003
X-HE-Tag: 1782701819-955472
X-HE-Meta: U2FsdGVkX1+eTB8O0OOfGWY5eQkOWvAOS8ejHNa9s6M1mS/RsDTsRPrI97sTvWpvzcgCtYZzPU+3OP9qipmXo0b3Y+ErQxAmTyELVfUlL0yBqIp/bHaGS5kQ+rZYSJtfEETNtWT5+dABDjenlF9UJYB4KXH3Cl23PYOhE7Mh4dsIGckhyvrZb//+OkChimgTLAAW0SwapllPYobewDTFJbOsRy+846H3Fbrf5YJTkqrXKcqldipjPUW+zWLctnw6fK1/FMc5vWWTIHZ6OzcJhVU29UJ4tnB7nixcR+bsPmTPeVEqyOmYFCLIRKrijY7rlrlWxNFq7oQ4ktQoCVoTtHvYJTZZqlY2N41cV24xKGyxYA74l9Tn/9v4luBflQixnruQoTbj9tcm4M7pSZlV9nhju8YnzbOUUsDMxvN87wLyj+BAH62yc9TfVdRqQb894u3dT5QpjXoV3pM9sHOyt/GRu2D4QVUxOo48ASxToScAwFz55MJ4SH5z9HsDiIVN/eP4UqKOFYQWOOVOBGfD0s/87sA2zBTqZ3g/ii8Vszqd574/UtCTu7b1YzvzMPVFeavFTjzwL4WlEQNlEepFn58ktXKuGbR48CyNBlaxQ/rVvscjvnVKfigYubZfqY302kr6hmDG08ZXbiCY5JHTFY0FHUrAMdAUQPt31Khf5r/KCkRJaeUySdAxRbjaUklXxMWp/SkeDgA5HmZXpi5Ha4RcyecpTBzw4CYFu+hII0Su7N43i9TroPYI5WZkrnslqP9tmAiO7b+I8n2tuC3Dt3OnplF773HsaeEAJlei19x0uxWjKVHaZym6SSlJ2fxy08UbQebT6xsrCSbX+KQiCNJtaGECLF8+z1b+3FLMwbJwc4EnrloLknFbSCBzLPooWyihMvegd7lMylakM91per6Gs9maJ5oEmr8tApM+eDHm7T9bksjbD8NHURo6GBYfCyrEbeGn749fGwBRxzx
 vHxG4JOD
 ie34F5Iw9iQ2fLVIL2xGWUkx0TRX8+1zfHT9qcaV68glycxcFgcouEFiEsgBa4kif3gPb1EOv25JAGladGu6jaGxOWZBom1elUoETaUykrSNyVKPpkODAidhSJ3D6Nlpd8SMXtTCFBDdilTiGIiaC+jKkZT6+saMl2ay8rIK3LhOTMps5NppvECecPyU0z0Dxw95S+CLe87Gg5OntHhqpSuuqm4UOuFvZ2oSZFBz637inu2bvkk+6Q94ExSwGr1uhpAjmW8KvOU8eC/fUU4LCoxu9U9KJEYQ9KhlF12rBahc2r9PwiDt5FItpRwVp5WAw3ME2cTRKjPUAtOkjdssY3u+M/xLJv0ZY7xVYeQCk5qVCjKuG2f/py6G5eACkKOTliuZHe4yCyOy/2Jknj88+NmSqaOIlg0bRGhEVUKDQd06QvRLP4+KnVajkaI2qLiCaNHjQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page->private should not be set in tail pages. Commit 4265d67e405a
("mm/migrate_device: add THP splitting during migration") removed it
without a proper reason. Add it back.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..037d67fbec6e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3594,6 +3594,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
+		/*
+		 * page->private should not be set in tail pages. Fix up and warn once
+		 * if private is unexpectedly set. Do it before swap.val assignment
+		 * since private overlaps with swap.val.
+		 */
+		if (unlikely(new_folio->private)) {
+			VM_WARN_ON_ONCE_PAGE(true, new_head);
+			new_folio->private = NULL;
+		}
+
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 

-- 
2.53.0


