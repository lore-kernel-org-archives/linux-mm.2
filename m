Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7049EC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09056B00A0; Mon, 31 Aug 2026 15:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B92A6B00A1; Mon, 31 Aug 2026 15:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8343C6B00A2; Mon, 31 Aug 2026 15:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFFA6B00A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F83E1A0211
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:16 +0000 (UTC)
X-FDA: 85162545552.29.86D5CDB
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6EA1414000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P1GqHT8+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204373;
	b=As+zTQNeR8sjRVcnyY+tYsn69ZvlsVuJZT1WQRqodQ4SRyQ5ywnir/O56TB6VMIkU0BOZJ
	mDz+fbfujMoj+vV+/mq7uh2Y0i89OYDot9vzA13/72CAPx0ez8tQGuVXK4JxRkPH8ZWVcB
	Q+hN+wuhhtCrA1QIL6ZsYliAKE9I9O0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P1GqHT8+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lih/fizY29lg92KpW0HpyAlHrKLcCx8Ux2zDreUbk98=;
	b=dOWNu4DnXiGlyay5m+0ipH2EQPd8COTLqFJc2jlqhrwwPj1SPKe8l/NVnnK225M2doWRlD
	3+3wp8P9XNWHtn6szxQxp21ZIRnQGocToBjBAWGnXmFHNBP4Hisg0MccAW4M0LhuWd6yOc
	wJ0qk+foyOt+NLb4CAT+z1Z7K5vsooY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZfqXnHCWKmHVY3K6+QHr5Nvkrdq91IK13mjIO80ckH/5FxFx0nL/LOsakZojnBj+oyIdhQukDmbgSMPljF/DnxXnUyuKxvO34D3LfUtqwCWLGrxJKR+Jbxfo+NFSOvjUt+yjKBfHsR5Iv57NO6XQmfsoOFIqsN3eSppJ4+GSBGvc+TlojoCF4/cZ+Ie82hmu05feF2j3y6uIsBETuC8U536Qokgi2uSdcuHqB+tRbNiYlU4jEvwh1JcYRjF1P+lUrc/dDDSC6ibL3Ar69xjez5VtcK1r7o/LPq60jx2H4VF9KggbQnzlDGg9n5P+M2H6YERxQXnTetY0v6HREBIgbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lih/fizY29lg92KpW0HpyAlHrKLcCx8Ux2zDreUbk98=;
 b=eKMYxoDkD7/tyOKQDUe10dzGkTddhadiwbx/LQ4Tz03GXytTE8SktaCBDgduJN+PR2xlgLTqdpcLeWwYV779Nz7Pmm50xcO9pk0qPBu1XtKIhNKhcb+0ylCqImH2q93aK6HJQuCcERUKqmlZ6aT5hkuzf1q7vaqNodwlty1QTtGUwOORNswHW/8DzQXcGWHYimBf2iuLFJbNxMYZ+fZT+OBai1owR15NOlr7EB+XCWf6d98JtAnp7v2hsNYBPLYdiPBTuUZ42Zd0oMrqn+egH/8ctw0VPePoLe6JwVXb8+rDtca8JZ6kuhyckosbfz77QmWVPf7vAEjP98eC6wpoEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lih/fizY29lg92KpW0HpyAlHrKLcCx8Ux2zDreUbk98=;
 b=P1GqHT8+ovYclNSRLhR1AQ4I+iZP/M0g/oZf7f0hho3vp1v3GGntzDxU34wEh8V3uKhsPWbWORPCnUZTlxt0jQdBl3SzsGix07ppY3BTSXisnEk/0V72phebQlSxCCiD5GSmCYTpCwpLvbNX8R+pLlH13MKhLjVdnVpOY7v74ft7iBCVGk7YbBGPf1VWxiNnFre6H2zMnrxUPQJp6qeyPv/LsSDpDIibxH3FukaZIAky2m7d6yngmAti6Uy5ipUUEaifm1+2FTUEzTI85TpxjqRrnaPef70Dl3e6G52v6JQA9VNDe8tfbWhWif9SLuOoYEPXtQVUyuGbHLT9qveX5Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:56 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:34 -0400
Subject: [PATCH v2 11/14] treewide: remove folio_set/clear_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-11-3668159cd9e8@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Trond Myklebust <trondmy@kernel.org>, 
 Anna Schumaker <anna@kernel.org>, Jan Kara <jack@suse.cz>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, linux-nfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: BL1PR13CA0343.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: fd805606-a531-462d-2780-08df0795ad40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	cDaBEllFgJq3CtJDDXL80r5x9w20y8YQAXveq0BL1V/ibh3Qc/Flf8EZ2kbpOmv2GDJ6HzmCzFCJu7cghbVP74RqgvYLnA7bptLKGgQAgqsPWp+Dt8T1ZHuA97cPCmOg+hbc40FYjlU9BryqJ3OsjIw/p3Wk8bxkIWSMYEdT0YRQV61qQOODJ53DeOGpiEr6ORSX5jTntitLs9BQsBiRiXHNKZIGQk13UPmJLJgUq9hrT5diBCvpiyNDya5n3x75TTv5z3olBhoGPKqKsBfhyV+2VdRHYRmbYYT8NRgvairiDSMZMmmz+F3QAnRyEKcBXvskhoDNV/jNnHa7XdrzQkwInK4U+cUHYEMx+pLIFj2cQ761E6C3GXAdXQSWahlVG4aKD9Qx3cxg5np60yuuWuXk6rcWkEn5FN0vI5enOJ2vACK+71oyoDE64bBKl5QYBbn1RBb1xZKRGzW6CTFe8XQ/snj5WG0p5D/eHdVb0MMuUatDhU4sevZLNiOPuCj9Q/7VKKWpStvv+lh8iXxrUV9n2MIaZ7E8spgxkRfwbMO+onytdDINX/Sl8eJ69hlMQ71lDMV1B9EYAAYrR3O3G1lB54pdiNEGKtWk7+b6m8bI41SnxkW/q+4+qaXdVvrpq+VQOyvHcTQrEXwb1b+qhK26FymqqYCUjpmXXyCeuvNMexDOFKvSPHn1UaDHshncW2NuiLAUN8eOKNrKmb9Hww==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEZYRmV5dWtRMTVsc0tIYnNpNWNneWpTdmErdDFqQXFteXp6REIvbEx1N0t2?=
 =?utf-8?B?aW9BQXNBa0xHNUdyV0R6VU1yZnplSUVraVpES2ZLeVUyamRxb1NaOWFja3lI?=
 =?utf-8?B?aWNNYkFZR3RoK2IvUitrTnNHd0Z4cWd4eTY1VVJvNFprNTlMTWNDRHhoZ2Y3?=
 =?utf-8?B?WnhxMDRtWE1ZQUhOVXo4S3NndGRncWpQWE9BdHBWRExTRHRCTFlGQjk0dG5V?=
 =?utf-8?B?SmE2VDRMQmwwMXJGK1pZMHlHa0RtSkZrd3orVEJDRWM3SzhrUmtmbmF3aVlM?=
 =?utf-8?B?enlCM1RTck5mbmpPa29OdDE4cTlGSWZCWDVnVFlGcG80WktHQlUwb1JBMHJI?=
 =?utf-8?B?ZVFqWjVIV3JEbzA2NkViRHUzaGVIb1JDcElseWlucHIvUEJYK2tlTnRMOVl2?=
 =?utf-8?B?SWI1TisvYTBUZnlBN1YvR1ZmV0VnRytBRXA2YjBnYjZJOFNleDlKRmwrSDJt?=
 =?utf-8?B?eG9wTnhiaGFFdHR5WkZYS3BSUURTVjRCeGxJallBMFFrMEtyV0VkODJYa1VX?=
 =?utf-8?B?dWM0SXRFTmNIZnJ6TWM5Zk1jNzVUcUh5VFBTcHRVYllYeDUvcGUxMkVleWtT?=
 =?utf-8?B?WjJaU1FiRG4vT0dwR3ErSlFXdkdNY2cwS1gyMzFJRk9KcFlCdWRrUjR1YXlS?=
 =?utf-8?B?c0k4TFlSMm5TVlR2NVpXYW5sbjRDV2xPVnFQeWZPYU9UL3oyOGE5K3Ewd2N4?=
 =?utf-8?B?ZDBTQS8rUHF3T2NlRVg2R3pWazJGVmt2eHZyaWJXZGVVOHU1UGZwYnNLMTcx?=
 =?utf-8?B?di9ENFo1M2hpOFFCOS9tcTZqdXpmVFdlL3pHaXEydFFsTVR1bkI2VktRYUNX?=
 =?utf-8?B?c2dsZktNRm9oS1dHY2FUcFdUaGhNRVJlZ3UwTzRyZFVMcmUzWTY0U2R5MjNl?=
 =?utf-8?B?a21UOXdOdThuQ3ovbmpzWkpMQ1AzamZyN29MY0txTmV5OUlPRDd5N1FIR01Y?=
 =?utf-8?B?bmpRaFZlbFpaVW1qL2ZFOWw0QkN5MmcwN3p4ODhiUWxvemVGQkYzU1FWc0tE?=
 =?utf-8?B?R21HcXVsVE1DRWpIcm54aHZ4cVorMWtTOVNoZ1UraFVXV04wYWpockZZcW5y?=
 =?utf-8?B?NytGVDNIQUtOSWo2YzlKc3V3WkZHL3N0akljT3R0UjFycDZhVWtRQWxSdzlw?=
 =?utf-8?B?aXVkVHpNT3dsVy91L1JOVlNndi85Z3FPUGQ5dDdjZ1JZR1pqUkpFZXVUWjkr?=
 =?utf-8?B?U3gzS2tTSzZ1NTJJeXBacXlsVWZ4YnY2WFVvY2QrNld3YzY5Wm5BWVhTbFll?=
 =?utf-8?B?cXFJTVViRml6TkVyZjNZQ1hRRGZwbXNvbVBLOEEwaVBSQ0wxU29yWVBOcG1G?=
 =?utf-8?B?TkFOYkVxUy9yNk5jekhPZFJPanVHcTV6c0VGY1oxcEtoeG02TWNCZVZDQkJz?=
 =?utf-8?B?NEhhY3pBbXVCV0IzQXlnMlIzSG56Tm5xUVlSK2c5bEQ3TDdNYlZnU2ZReEI5?=
 =?utf-8?B?djh0QTZCOExZZVFKcjJubFJ3VFZSMjhjcHgwNWo0UFpRR2phSkszSjdlc0RO?=
 =?utf-8?B?M0NOb3hIdG43T2pPMDhwdEdreTJGTG5YYi9UMnF4aUYzSDVMQTg3OXhvclc0?=
 =?utf-8?B?Rml1czdCTFJscUdDS0ZORkh2VHQva1c5MTIraUF6R256N0dZZUdpczhseUIw?=
 =?utf-8?B?eHhYZnBaZCtxN1FDcGdaNDhRM1RNcmxuWnplbVVBa3pySTRNN09oNUxsL3N6?=
 =?utf-8?B?VlVOaC9kZ09JUkRBWStqaUV4cGtYNCtFYTVpUmUyb1NWMC9WSjh4VnQ5MVo4?=
 =?utf-8?B?OTNFRVM1Smp2OG82a2ZFbjRhUmlEL2l2Vkl2aWZCQ1gzbGhYaXAvaUdGMHFh?=
 =?utf-8?B?VTlIUnFyL1Z2dWNPVVpKblpqNlFFYjNtWWNCRzJMNlZpRUNkN3g1bnJDWGZL?=
 =?utf-8?B?SjJXMWJvVVRmWU9MTFFaaUVPTmlteC9tTzZYeHpTdkd6Y3BSOEUvQjhON0RJ?=
 =?utf-8?B?UzZlTWZZMU5XNkxmNHp2NnUxTmMrZitBRVduK2t2dEdITFByUG95N0VzZEY4?=
 =?utf-8?B?eHBoa1cwZFE2ZTNVS1JtMjdzYXBTT3ZUY21rWENseS9abERrWFlqWEozaXEv?=
 =?utf-8?B?eUZCTlhQRE9WaVpqaGVjSmZoTEhma3ZlRnN3WEt6NHV4V3U0TGVxT2pITlBQ?=
 =?utf-8?B?VkszNjZQVHY2QWRSNXFuSUt1c2tnUWNhNDFyYmhsR2U4S2MxYW5iYTVQc0ly?=
 =?utf-8?B?bkZlMTVOQnVITzhtUGJndnoybVdHc0ZlcFR2ZFY4SHJqNmpYSlJwV0VPTEly?=
 =?utf-8?B?NUFlVVQzYjl5alJyZm1YbGNHemlyRjM3WTN4Tm5yMzRScDFCQm9tNWlsdnJ4?=
 =?utf-8?Q?VQPdk4lTA4J3YCoIcz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd805606-a531-462d-2780-08df0795ad40
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:55.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dK4lbrei4QfZuS+CY2q9IzvnaFO/nAnboeNBmCq7WFWkKmG+4C4IO07a7bw89HDN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EA1414000F
X-Stat-Signature: gxd7ydwzwf6yi8yn9jy98x5nuiisgest
X-Rspam-User: 
X-HE-Tag: 1788204373-52860
X-HE-Meta: U2FsdGVkX19DHs6eIvNPdefXaUMcxdJmGTWsYk5ahSUdFIGMLy+owox7agu/J3Q212etX+gYwKAPNAaO1DRDm5jT28ahRCe9oxPogIcP9HsKwA1dEDjm73k65cY/p4OMvRq9eExw/p+7YgapnuWjFmBTir62wRrcTTSzu5g9gwg4MKdikbTOisJmci9+Sd6qoyS0tbdQfg++O63zoVLEhBKJjHhdStmSZZTdaFVbJ9f0OLNlLFWypwJxQtq9R2eIThWLB+85DCdsd1yUKSHfCxH0yC1nO44Y/YLdi8ItrD+Kuzd7zlS9snei/BZhhxRdLSCbRaTqEFdJEwJrP0EN/oCWHvjv+G27XK0qMoFEly/d7UQDQfr9fAuMOG3mYR/ErX2Y1k/yel/MdTI1GXCRsBqUFePUonp61ua0dUBvMtcWSeQ1I3IYxIRC3CgPiqeGu5Z7o3vGPcfWy5hqlkVPYH/UFH+K/4TmvoWikjbOrsP4XP52jlE3yroV5w5erRjviMw/voyL3A+IeSBteDOrMBa5RvFUo5p4k8pP7CZg8pl2GC/hmtM4bqpQzOCXcR6QXWMT+TjWhuZm2bOGWB6CW4t6iASJLTvnER4ICGjzfR7yzE4fsc389eE8yLPVV/KRNqwXBsvqS8X/kVUNFwE6SBj12YDKhjo0ByBHkp/qvrhCWMjtyS8S7Re39i2aDdTLkTpPACUQd4T5IgheIwIiFm9wX5Iovnz9+uVMzz/FP8JHT/NJ3D01qCujZ3oQK/3Ra2ZbI2DS1HvYYHgDcoKwgzjpWB2QIBtCfqSkB0v8g6G2EfEeUDm1z3Wc3eVwGDgFh2o9jfweNrpLCdlXaH0EtHJveSjWc0GX44ab0VrY3j8qe71/18MEpqvFaCCXeI1FokN/+Fnbw8L/msTW/W5OWZaQe2Zxrb6uksnY+csn8fMpG26q1ET06hpfhnVMbAauXRkVymUudNLKsxAw0m9
 ZC7hPQHS
 8QISTFLVKeGZNX8o1VJpzwNnjzRI6tH1M4XPgdiamhzuYvhcprzV4/z85C4CkFyB0dgN33dbdGJFMhgfSXA5yaj3YDNc33LPBwv7LAF7YVviSHxtZZ0a7ux1nN+DRWpvwjTo0Wj869wAw4HM9Qj7tP7J6vKBVgzj8vFMBoNIR5x76MZtmitxC0PGe7Rz2nRYGMGmmRYykzpGM3yBd4j9Nj+Rv3wJQdzs5ws8o+rle1xdjprOlho4qTk40Z1Qwuz2l6d717MMEzPDfoJXdbrZWY5Ap5gXFWe8H1Mdq57rb3DIAOdNY/MZ1zwXc+PtTg1J65jYwmNHDSNpU7yzv9mVNmW/NjDYEHTiuTootekLLwebm7CtYB+T/Ani0B44k4dAv9NxgA++0NqRPmj0MKpHqQq0jVMXA7J8Y+sOHb/m3xfojjDDISweLpVMOmyDQJppz+x27BWgmRqVYOgH7u9cxBTsadwH4QBDx2DBrhAuDJMi9SIIhHQhIxq8Enu/fgiSMKvoKQU+4Sleg7JUgUP/KwzPOoeJTYO0f24oNdcm6vcpELvn7YUY7XNcw3l9UgSoArgPj59dpqypdfSxVY7PAM7c0Z2k1RUC9TRrk7BwUxghZv/oKBkWU1KNOECa83H+zL/DS4WTVKGgW0ln5XSMwvVPCTW7Sdwl1cB9AnulkrUHspTo4fFRAJDb+Xnmmnrr/4MJuL/v48MbqmofMVIx9O8qEMk2DdxzoyGr476eC6xMHsG03bo3UpcTplxOq/4ZDr8TFqfIWBDYfP/VgNj5x3cQ+cWIwzg3pGkCxxY9eDKUHqkItbiA5NNGRyR/sDK/MQe/ADyima8M31VeO2qHolS16b2bv7ys57SOHA4pypqOjEoAy5MjR4ccqoAEsIV5+t5mxA2+MKBdcrVRL+RXRy0PziA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are no-ops now. Remove them.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Trond Myklebust <trondmy@kernel.org>
To: Anna Schumaker <anna@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 fs/nfs/write.c          | 2 --
 include/linux/pagemap.h | 4 +---
 mm/migrate.c            | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 623e7ef1f73d5..b6967b5286691 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -717,7 +717,6 @@ static void nfs_inode_add_request(struct nfs_page *req)
 	nfs_lock_request(req);
 	spin_lock(&mapping->i_private_lock);
 	set_bit(PG_MAPPED, &req->wb_flags);
-	folio_set_private(folio);
 	folio->private = req;
 	spin_unlock(&mapping->i_private_lock);
 	atomic_long_inc(&nfsi->nrequests);
@@ -745,7 +744,6 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 
 			spin_lock(&mapping->i_private_lock);
 			folio->private = NULL;
-			folio_clear_private(folio);
 			clear_bit(PG_MAPPED, &req->wb_head->wb_flags);
 			spin_unlock(&mapping->i_private_lock);
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 546e987d5cda7..88b4c92b43575 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -594,7 +594,6 @@ static inline void folio_attach_private(struct folio *folio, void *data)
 {
 	folio_get(folio);
 	folio->private = data;
-	folio_set_private(folio);
 }
 
 /**
@@ -629,9 +628,8 @@ static inline void *folio_detach_private(struct folio *folio)
 {
 	void *data = folio_get_private(folio);
 
-	if (!folio_test_private(folio))
+	if (!data)
 		return NULL;
-	folio_clear_private(folio);
 	folio->private = NULL;
 	folio_put(folio);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 666a7365e16e8..5ca1548ca6d61 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -835,7 +835,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 */
 	if (folio_test_swapcache(folio))
 		folio_clear_swapcache(folio);
-	folio_clear_private(folio);
 
 	/* page->private contains hugetlb specific flags */
 	if (!folio_test_hugetlb(folio))

-- 
2.53.0


