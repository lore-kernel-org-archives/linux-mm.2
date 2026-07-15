Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76191C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 01:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8166B0093; Tue, 14 Jul 2026 21:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F206B0095; Tue, 14 Jul 2026 21:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7E76B0096; Tue, 14 Jul 2026 21:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F344B6B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:06:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 713D11A01F8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:06:03 +0000 (UTC)
X-FDA: 84989219406.07.015593A
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012050.outbound.protection.outlook.com [52.101.43.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id B975B100006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:06:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ue9JpYsf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784077560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/tR7yEMQAcBi3h0g+6bW8/9twO2Mh4hGwsSHkrLQSo=;
	b=g8wFXwk/R8LMg4SHGQv1/Fgw50WjudnsnTJEYfz1Cscr6YC/lRFnhmgep8er6zAJkjPfZS
	uJKNC5isoaYYPwnD4MZ5G06CIhExiaOOUboQuGv+VaRb8fZHYPv8GxZAT6bm3d3vI3ovoY
	71g4j6cV0VWGPiPpFlr1aUwZ8iRf+Dc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ue9JpYsf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784077560;
	b=IlGOjCjBb7AEjHLOF9Jo35NKAcav//NQH3/KV+2tRcSyLIHRAG0+5UaZoTpv4/l8TBtRi3
	PS/4JbVhEzGImK7d7KrHKzz1uEf1SFBcLEHejOiZM3+K07URlilcyZdUXb8Ir9Tl7uSKoH
	64OtPYY/cDILbjKnKhXYRq5cHyvdFjA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/EbTaWW0QSHfTFEYgjVhl4IjwTuY7WcQX3DGQGkWD70V0WtPg6NJUTlw38odN89UNbfq8TiS9MQ+5qFMjV97kwlmUAIgp4EUK5zwvJmwi1OHXHYM0DvTjnf9xY8agB4aLJbo99o49KcOnNhRj3l/qNBnrMG1n0OX2ie2gp1qw5d97wN/XqRnjJlDnTE4fV/w9G+UxDy6Jis4mTFg+z25ZW92OyQbfo1TZbzyEhGtqihxNWrkmVx8bZjlWdQUddJ0wYMOC1Sn1ljP/h3vnv/bfTdsXlYIfGRAgC0TRfZLiQJnZjiunpIUjVCM5Y5laWMF1heqJ0UmC3EU8ohOj91tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/tR7yEMQAcBi3h0g+6bW8/9twO2Mh4hGwsSHkrLQSo=;
 b=BAf55fgpVRbSffChGNnJxNFCisIjjeuLNAsYkfz4LDwWllgtjtWg/8/oU/cLOFabPrKHsKWIx87VCMDLaRNOr2l2ySYseWLompMXggLtKjj/JuukWweWxBaCzybEKyGEDXh6Okhy5SmuvKdvHJ4n8ooq1BTJznu9zZMKcfBs3xAZnUgEtn39TpacrnTLvukk3+qIjpiS/i+9tbM2xQgnkCb9/nsKZg/4hzcuBjLvknglR/Dg80Q0gcmY7CuocNRbqwX/YQw2GqlZ9VTXIeUCwNu6DWzPWdVYNMCSavbV3uapc8FH21i6krrSZK40kzIP7kP6pNIY6qWlGuUcUKLoXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/tR7yEMQAcBi3h0g+6bW8/9twO2Mh4hGwsSHkrLQSo=;
 b=Ue9JpYsfR5p1afnJRZKuy9T7pW3WS4JzSeI27Uo9Jjc6XEGgVB19xjDxZkVeV1+5ly+IWL/DAubBgPgwv1SO5iharAMsVbwrFO1gJ1iMzy732WB5J3HRH1in2sOeeg/n5SFNPg+kp7LB2GQTfCusK0rmmVk3f9kyvNvqTdc9GYwNVeYn3NuXrVZQ86ugvgt+kT3HaHalLHpoAOziJC9aRmPTEGSyhC8FNdtrmOOrzbYVPr+DZ8SdpJOgjBdmL9lgcpRa4JEhcmYISxnuemF8Mkvmgwp5LWlRObgCLIsDBEXX+S95kRVdh6svq4bvtAEziXsVZzlqL4toCiA5KNOymQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8689.namprd12.prod.outlook.com (2603:10b6:a03:53d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Wed, 15 Jul
 2026 01:05:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 01:05:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:05:52 -0400
Message-Id: <DJYQPL4G92KL.K1QTSHQ0JSU0@nvidia.com>
Subject: Re: [PATCH] mm: huge_memory: Fix kobject cleanup in thpsize_create
 error
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <zhongling0719@126.com>, <stable@vger.kernel.org>
To: "Hongling Zeng" <zenghongling@kylinos.cn>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <liam@infradead.org>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260711084624.207777-1-zenghongling@kylinos.cn>
 <DJYQMTVRAHNG.1DTTNWHH4006X@nvidia.com>
In-Reply-To: <DJYQMTVRAHNG.1DTTNWHH4006X@nvidia.com>
X-ClientProxiedBy: MN2PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:208:234::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8689:EE_
X-MS-Office365-Filtering-Correlation-Id: 43574d88-b9f9-43aa-a705-08dee20d3805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|921020|6133799003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	HCiHoWX1KeB4zCBTn8FadT4LPa+rLkg/1Z88Yi3yYX1nv8SxHu28DZLiyk46pmQRlG0s9V0Ew4mexrVwxTbbIEVY1ZJ9DGJD33gLA7+Z05eQ6CVb2P01FQsmxFSoMu9J2mqswrVtwKoTy5efh0WSJ5cjGDdmB8tviFJkd9Ii7LLKwwuGLJY95TfhNqFW5UFOGQihNH1Vax/plkHizoWtnazJ9KMp36GMknEYB+DNesLgeGDDPL4qtK4ttYuknU42wWygG4Evb50N0qr0/Sbg3XFdh6GhGtzLVdadGU1BbZasd2sB1tmDHkOSgyp1DwnJhHnDIiTAKd61bFNmgCtbLDdoo6VpUkV2dQwqMvJV34DK9+pMDkHlzGkSIY49yIQVipGzD1pB2odvIHfPY7R067nAR8cf/CXFoBUG9L4wHwrC4mb1HmQYhDLN3iznErvMqJsvjlSnXvU6pDcnE2ggHOSgictKwx2Q4l/gP75bPZk1ux0EBFSBL/BXWUg52gjODsp7bA0j9DTB0o7gD1sph49TlnDBRLTltKHjObEs45e/OFpp4kRV1Ra0gKB0dYV7LXme8iZ34+A0LKRPEgOgdMiywehaJ5IiZvehisVdAgny4YsCI47/2N8et+XGYZhkRHHFFNrqYXcj8BrwqzYVcrGXN36wbKK8O4JTEN1vzedHybR+bnv+4Z0Hw642r/VGllFoedBj7H4MBsJkKkrWAA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(921020)(6133799003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ty9zTjZnUVJUNWl6OVpXblZ5aGNXQnpIRDZTQVlKM0pIcUE0ZWhnT0xDaldO?=
 =?utf-8?B?UUorbEtZTEQwWFp6bWp4dURSN2ZiOVZwSlVVb1U4SG43SElKaU15L2NIdnNx?=
 =?utf-8?B?cVUzR2NWd1lFdW0zTFdleWtMbXJORmFLUWhlTC9sNExQMjBxTUVGczk3VkRC?=
 =?utf-8?B?T0tvRGtwNEV5SEphVVNsSnFRZi9zYmlPc0k0cjB2K2U5K3p4eHhreDdMem92?=
 =?utf-8?B?VzNad2xWQnVIY29VUW9vOUlaWmVXM0ZlQTlCeTN3S2dWNnRwR3hXUjhyZ2Vi?=
 =?utf-8?B?UVFTNng2YjV0SjN6SHVrWXp5cnV5RTcwY3VpcXJVaHZZR1lDSVRWZ2lpVnFy?=
 =?utf-8?B?U1dJVjRQcnRwNlp2czRHQTNycWNCSG44MjVSL1ljb1E5L0p6YzAxNFNtQVUv?=
 =?utf-8?B?VmNsNXpqNGVuRjAwMEVZVUMxQmovY0ZDKzBkblJaZ2hKVU00SHVvYlYreFpK?=
 =?utf-8?B?WStCUDlPWG41UHp5YWh1bEc1citkQ2lDd0V1WEZWVnBWM3RlRW1xNm1iNzc3?=
 =?utf-8?B?RTNzbFU3MlFZeGRSZDFFazZKV1pqbjJjZWdGYWJHc3ZIWTdXTk9ZQTFqTG9U?=
 =?utf-8?B?ZTlLaGFtbmFQdzdJdXR4b1NFd29kRElmQ1A5Sk1QcXFSU0k2YUc2RFRBcDAy?=
 =?utf-8?B?bUlLTys1U3VsNDAzNmxPeXpTMTFMdHRFZ0twZHpvVW50WFlveHJqM0ZTbmpx?=
 =?utf-8?B?TnFBMGRtaGtGQmJnUTR5T3lSVUdpUThLZkU0OFlzMnF4TVBjTkRjQnFYNlY1?=
 =?utf-8?B?TW5SdEFkYlA2WlZKaXdrU3JkUjducnFmT3dnTHQ4azJNMmQxWW0vbE83Z2pX?=
 =?utf-8?B?T254alFFQXg4ZUk5Sy8xMFZmVjZFQjNZUWVRQk9jSWZkUWNiWnhQOCtXT09q?=
 =?utf-8?B?eU1qcm1LVWMyejc4ZVl6SGo3VDcwcmE1TEFYalh3dElRb1M2TjhXMk1SMHRM?=
 =?utf-8?B?UnVBV01vcjkzVXp5K0NRM0hKZ2l1amFKUU9YbEFNWEFuMVZab3FWdkJBcU5Z?=
 =?utf-8?B?YmJCb1dRUFcvelZiUmNoa2EvQmoveFVWNGNkMHNvcnZGK3V3azYvZGxCSkJL?=
 =?utf-8?B?RlozZCtuWGcwT0wrYlVjY1RrcGxtUU9xWHNHc0dPc1AwWmxPTmsyaTRxWE9O?=
 =?utf-8?B?anlieW9DNjJwR3hCaVZVa0JRcTZBcG1lVnA4djdGU2d2ZGFGRDlqUHpma0xT?=
 =?utf-8?B?L2VENVdUOVZjMDQrRjhQYmN5Q1BueUNxQ3oxdmtEdVh6b0lQZDFnUmZZdVZX?=
 =?utf-8?B?RktDcUVXZGZXaENHWHhtcUdPNUpEWlFCMEd5YTlzNWpkNWdYdWQrS2tkL0dk?=
 =?utf-8?B?c3pyVkErK1F0VG14V2xtVjJsbGRsYkdnamVYZlhEU1QrN21hTExDYlNxT3pU?=
 =?utf-8?B?ZmNsa1h0amZ2aE1DQ3RIRnBQR3A0ZFpodDk0ZDJGbjBNK3JNT3k2bWp1WHds?=
 =?utf-8?B?elRsQVFDdWNsVjFQb3lwT0RYL0FJZFdCWlp1b2JERGxONHl0bFR4RU5BVFBv?=
 =?utf-8?B?S2ppbXZlcW13MTVHSG0yVmtzOTcwSEJVTGxUZzFDUUxYR0w4ZUVhWjU2aW5v?=
 =?utf-8?B?ZjRPNU9TSVF5eHFOa0xNU0JqUlVNM0JzL0kwUDd0QzBRTWZ6QzZTWDYwRFEr?=
 =?utf-8?B?Q1RpS2xFN0UxWVBLSXQxRzF4MFNNcDZqRm1YZW1KT3crTFZWWjJjYnR6SmFM?=
 =?utf-8?B?a0VUMTJkZ3M5d1lDektCWFgwck42YmVTRkpoRlFpSkVxbUh2cTkxZ25QV0xn?=
 =?utf-8?B?cTJLUG8rNHc4VTROMXYyaDlXUURmelBoWnNTWWRBVVlmNk9lK3NEMWlPYmp5?=
 =?utf-8?B?ZHNXWDkxMFlrUmdUbCtUUTRYbGRhTU9kT29Ea3o1L2thUXR0UFZjVk1CMjhH?=
 =?utf-8?B?czRnaktWUEJPNXM3YURQcHhTRU1UNGlOUk9Hbk8xckRBZlA5SVROejFDQThS?=
 =?utf-8?B?cFZpQWRkaC9NZ2p2aHYxVlVpdkkxOVhkM25PR0QwL3ZRMThyVlFuZTZ5azJu?=
 =?utf-8?B?a05adkc2NzdBRzRHZGZISWlPLzVLZ2xBQWZSajVxVGVuL0J0U2pSZ0dlaGlr?=
 =?utf-8?B?Mm1pdGVRZGVqWWFEcjY3aGpEYVhqaS9oRnRTd3BuUWRiMkF0d29YdlU1Q1cx?=
 =?utf-8?B?eGlQYjlQUmxwLy9MektOemZ6YTk4ZGdId3ZNdm01Yis3ZWN5VUlvOG83Nkc5?=
 =?utf-8?B?TmRaL0tBMjF0c3hGYlo0cGVhczA5d2NmakdPbmRiQXpIaUVkVTlrY0pDcTVT?=
 =?utf-8?B?ekpzTWNJempzcFQ1ZFB5cndobXBJR0xIT1U3UG5Gbjg0MW9ja25Iem1HYXJM?=
 =?utf-8?Q?Cmss1zxDxbVJk/wLz8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43574d88-b9f9-43aa-a705-08dee20d3805
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 01:05:53.6591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xq2FV9AGuxuH2flgWlM9KG72b3YlR+dm/aUBUAHfPblIbndKHPZaKQiBlyMOFHuh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8689
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B975B100006
X-Stat-Signature: 8469459ye3ysw5np8may9os8f8cg9ohu
X-HE-Tag: 1784077560-284615
X-HE-Meta: U2FsdGVkX18HSdJ+qM6DFDsFnEyvnUF8kg6aEbNH+mVbT7sgpVFUTqhGz3a6/AT5tDS4izRwHlUVOzYO2KYDuZeZLwNyr7VbAX5uEygVXPF7nBdUtXzY6hwaEis3XhcpSVC/yxOdYgXrVOBeHtiV/xSamL1EY/L13zBr7YSB5k/Yfjpf7+9qwi0X1+1L4dRrZkZ65NXiaPrDCWVOkzdKPKqY+u4oLpYiSh8CqchvbH9ZxwZ4SrotyRzDJ7enQdEsT6bL/eLacE5vLTAIxBiyOmW9/t/tn7BxUUKff+3mgEJMLEwO6ssmgJOgppogjZrWSNsnlYHDrN7Hv/ubGSdRvSIp9YSP4M2MMgQ3gpeBkYGFnD1uMzdu3VJ9ONB12LcytKqWy5jvjYAia91tdU7w2F0wmVZUqk8doNC83OrkckKkt/o7zjcC8rjJrv/FQTwvh5uNKbcKgHR8pHCZcabeTOL7iz10dXCT1KxWPXZvZ0poSPB9ggkIhqW671xxuC2ir388zsb3nJD5pCWGsQpR4+KqkvRHndJfVEMW1fEPXqBYz4zzs+eZUQ9YDv/WHcD1Ujc1ZcZAp9+aiYRn4Q3DsE4+M1Ig3UyolkA4ane2xbJS7i96v3a2CAI5pVfTsW12qzwJv9Mut5rpsL6jizOcsb+YKTw9sVCXGAxxGY2lwOwcHYZvllt3jRcKmiUgb0iewstGUxGsTqsLOVrBo93goHJRde5vfqO1bKd1B+7YlgihyFbxz0PKsGlELJAeRGN83ZkByZAcq/UIJqqiT4XL5a18M1/9uuiDmmr9d/DBVG7umVg7Ur5Ej48hp5+lyoVaVUj8gcxJFsMbcaB2fnFeE9oB67xJ2T62n6+3mtHZxkwJ4ZKQ5gwIfGyZUYPs7EYqvI4D50VSUJFgBnAI0xG3jpNr7+EwslOputX8e/69OjFlTrg9SX3FXUW8FHLwpPmdHvwJJmpQ0VNlPpyg+ZM
 Bqb+eBSk
 uaMSISg1VqGGAtWv7nPg89Lkylh7fnQvDMplFoOYKtJLvIFaz8rhXz5vWY5MqpLbtuXlxnfFdf2M++dI8h6TYOZTTLr09y7Uar6akP+/PnCz8G8QH861rO3GExwnchTxC8umxvrfwF/8vt/eaxMAcej/hPGwj/WmiIfCnpN4AvaC4bPinVHpr085nuUfkvJ6sjQBgEbm3sImNrFw35oa6nsWJANqhhd0iqiswZ3TboQ5rcI/2LXCRot2xJW/Po0SsImwyhfcdHn4DKWnsqsLJgKdx63Hp1ZEMMEDpayWUI+ZmHB177Wf2xSLODv9Lo6x+X5MIIxRtR1XSISrcsYYKWuZ+PZ7yHYn4BOY2ilJL72RngMtERIJkQODei/hMDH8uVOtXbTDhMH1QpgXkef9+ZdGFsMP9K8J8fEJAmf/9S05/f1juRZDbxR87NAd+dkLZsvzW8h0BLlhR44v2pvJfHiKvDlWZ2XWOSSEdVBNBYFx5ujWijz3DeAElyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 14, 2026 at 9:02 PM EDT, Zi Yan wrote:
> On Sat Jul 11, 2026 at 4:46 AM EDT, Hongling Zeng wrote:
>> When kobject_init_and_add() fails, the kobject API requires calling
>> kobject_put() to properly clean up the memory, not direct kfree().
>>
>> According to the kobject API documentation, kobject_init_and_add()
>> calls kobject_init() internally. If the subsequent kobject_add()
>> fails, the kobject has still been initialized and must be cleaned up
>> via the reference count mechanism (kobject_put), not direct kfree().
>>
>> Direct kfree() leaves the kobject's internal state (including the
>> reference count and kset membership) uncleaned, which can cause:
>>  - Memory leaks of kobject internal structures
>>  - Potential use-after-free if there are pending references
>>  - Inconsistent state with the rest of the error handling code
>>
>> This fix matches the pattern used elsewhere in the kernel and in the
>> same function (err_put label) which correctly uses kobject_put().
>>
>> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface"=
)
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>>  mm/huge_memory.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> LGTM.
>
> Acked-by: Zi Yan <ziy@nvidia.com>

Oops, forgot that V2 was sent and missed Baolin's comment. Sorry for the
noise.


--=20
Best Regards,
Yan, Zi


