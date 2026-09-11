Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFECC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD366B009B; Fri, 11 Sep 2026 11:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5676B009D; Fri, 11 Sep 2026 11:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9A06B009E; Fri, 11 Sep 2026 11:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E88536B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:56:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 768D840274
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:56:19 +0000 (UTC)
X-FDA: 85201933278.28.37C95C8
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9247220009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:56:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cGHJVV1Y;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789142176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWvKwYBVM6LxFiCDCSgfrRT+a7pcSPc3rLFWve8eoP4=;
	b=ht+CMEn8fXn1t7q7A03NK44quhvoNL9Uz85llonNJ2yVtQwigcvyaePjnGejhsu3aoTbrv
	6heptcIqszwC0sggsOWh7pnjNY8/HEPkzciFqvOHY6bcDzHBj5Ib7mqWxlDVTOEICoqQ5Q
	EKgqrd0gCQqTCv0Hr4oO1sEc+tlowmM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cGHJVV1Y;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789142176;
	b=OaQh5kVTOLIp1qBMe2eP2BdCl08rBw5ZlKFingS7csOD7YwN+HRhjYWzoTKmTpb/d5dZIP
	lzJaMnFG5u3FfoMjQnmIlwiQ98U89dXNDZgTUGLlGauW4N4Ne7+z6Q6fIGs5W9rt9fkoPr
	KsxPe/fPNNxGwr8de51wYPd76WSGfxg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZH2IyHudylbDv0/ejB/4FMOb1hao7a7S7qS+oHqexF77WkNWY71P1FbGWxPrnL3i/aTvShT6esyuJ44HRlssEUoc4kIwMgTIkj4ZLrlhi0tEXCz+dDLQ+5Jiuiv+lPE5g6rvaIROcoBsaRbjIpgv9zZgwut5OqRi2nWnTAGt1DcgI7haVyBQ+HTvkO05NGvHhoXLsE9eBqb75Etyns5YVBhvS11Fh1Uk8eT6OsY+frKpFquNW3TQ51gbS1ctqIB8J/O6pfDYtRoSwznB95gSoE6a7hBF+eWlMB4IP67Da1vD6alPbN5BrOMauTAzd+X7yy8+Q1WBf3KQ+y0aCxp/0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWvKwYBVM6LxFiCDCSgfrRT+a7pcSPc3rLFWve8eoP4=;
 b=MBJxHe7Pqkii210rNqnlnRRJeQ9vuWdRO4wRgQ1zCHF0I4wzfFHUhd00HJz/pggUqylVfnfAQ3zZRt/ZnF0TYBadeM6LT0umHFpsEgttpOk6vNkqqETTu87xuRqcxmAVaHtuFHjYEhpQf22zEOOCEfDRhbus7KIS9ZcMAeGJVfIfzRr+Jsz4w5+yo15dyavEE5qsgUWmJjLMYBQlsVHo3VHDaySD/5KEWNtC7dTdsOtaR+smAisLXHYvhzwyaCuutMsjPQou9UWvyZccSgzoesCUc/Lzs+EW6Uehp8OLxMNmEsJZdUuAl1hZMk2v7QupXcdVXnh3FGnLNJFMqLIYvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWvKwYBVM6LxFiCDCSgfrRT+a7pcSPc3rLFWve8eoP4=;
 b=cGHJVV1Yv7d9O4trPOQf2VU+2c5mmJXMl3ZwAQBNIPUoIUV3B5gQXiaP+tksHNHK9s2pJ4M8RSBcZHnfKavw6MIziK9xNczSR7+qMgjDzjDb7lrC7TQeJPypTU/eeEIuCdSNa2Yx5kV/3LHgbD8lhxIqNLMMn124PDb4t16HwH3663L9jNqxED3KdEyG+OpzIOR/YDDS7SdO7Wpf3rbGoDLqvrjjIo76VIWE1QN+04bXlC+8Xu8fFUx9EDH0SKO5vkgQA0j3X5emx7v9g4DsHoogICBv/0+/TG1PQhGxdL6mkWdGBDHEtCgbyXypct7e9W4WakgLmEWrKJMaw/hNTg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4177.namprd12.prod.outlook.com (2603:10b6:a03:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 15:56:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:56:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 11:56:09 -0400
Message-Id: <DLCLYU21ZLDV.2SO9YNPMOHYV0@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 10/12] mm/collapse: work out the orders a VMA allows
 once per VMA
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
X-Mailer: aerc 0.22.0
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-11-kirill@shutemov.name>
In-Reply-To: <20260910120238.2529819-11-kirill@shutemov.name>
X-ClientProxiedBy: YQBPR0101CA0330.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4177:EE_
X-MS-Office365-Filtering-Correlation-Id: 815b9c30-916d-49e7-97fd-08df101d3392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|7416014|1800799024|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	o6C8xZPHb5FB8jsbwnTjGBQOZuGYGsqcNfBhat7qD/wLYvnFwBjzhJMjcAUJZ1bFtfFHApZo7pmuRy8Hnr+1hq0lCA/51A8ZkEB8JAqY6ctLNbZeAo7Hfm02AEsQZrcw11FIGFXESOVDj/JqW1wNS+1O8+V+HZpDBt+VMdVuYOPnb+GJKKN9LNUV0W9B/8tI96qcajQ+V8ch72qKSukL07QgnaGaP1o+6saLrXL9jLiMmfhWHDe8BYEPfGrlFzfUWT4krn/AT2oNP1yl+D3T5kwxYite5Km2fW8XuihNJ2PH2ejqwuUQXFf2k05bIuDC0X0euBTpdRTJ41/tn+S/8r5MC3nX6pY0plgyH4nTBjSErj3t+z4/wbUDKn/eXl/K3VKs/Hvykf64qeCIz5tCs7Ys0ITezLCndrDB210XJ3JqS3CnIYGLDXp+YZOJPsyljeCVLTzfZDPv87FsfAwmjMm24+WucxJPN5Lk9nG0k4XJUoa3YYUmGor5QCx6cg6XMHXUD6Rm5BAAZImYo0jFlDuoS2dbtNEN27xzPOv25jtlGbAsYl1zRaiToy5PzYgmivCBSgc8/Lla+cVLLAoWAzSUJ35i8rbZMOz+mmq8abX+dc8P1VbR6U6uefnadsyZu8rlUMWrpyS0l+xfQlAHsH8BxzyzCjg7TrNTRupjCEE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(7416014)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXVjNWZFMjI2UnM1NWUwTWdBNlBXcHJvWVI5Y2xBMytCQ2ovRmZocjZ2SVQ0?=
 =?utf-8?B?Wmh3Q2dOczRoMWJ4TkxzMXc3a2x0Y2RCWDVONW1Sc3lEZ3NBZmdqVUEwUzVo?=
 =?utf-8?B?alBzVWc1MTNvcko2Zy9Ld3BCdVJWMkNyYWV6K1JsNW1kd2lHanBvS1dFdDRF?=
 =?utf-8?B?bFB4d1ZvWVZnaTc1TzlGOGhoVk13Y2lreDJOWElTS2JFUnBDL0xZb3R6WFox?=
 =?utf-8?B?cEtLY2h1SUpLN0lCTkxMWkJXeENYYnJHTW5PSGk0NzFlSkJmQTNKM215VlZC?=
 =?utf-8?B?c0hBajhCVTdsR2h0RDIxMXBMamZCMEZhSjNrYzVqMHRkTXpoeGM0R2ZaYThz?=
 =?utf-8?B?Umx5cHFzV1lPTVg4dldYZmxCcmcrajRQUGFYV0s1cmdqeEVxc1FzbE9TMVdX?=
 =?utf-8?B?UXVIcXM2aE9ONDRYZlFsZG9sdnMvdDIwbXB0REVHcGQySkRIYllGaGtteEY1?=
 =?utf-8?B?VzQrWVZSQ2tsSC93RXl5KzNZb1FjQmFSMUhPQThPdjY1UHFuRDNINDJMQmJR?=
 =?utf-8?B?dmNENVdrbFZBOUpLVHBQcktCNEphQU5hem1iRWcwSkJNSVhxZjl4VU1RMXRk?=
 =?utf-8?B?bC9jRHFYd3ppVWExVEVSWFZKT0RERVdDYm5DaE5uSVhvdkRsZ0RyYnVyUVVh?=
 =?utf-8?B?K1FHdHI0N01xanpta2srYkt2dlVzME5OUzU2TDZBM0ZvV0JFQ2k2Qjlya2dM?=
 =?utf-8?B?VS9ZY3pCdGE2YzNXUUlKUUtqdmYvTVJvM0JDbWZFb25SRkFvV2JibTNyMmd6?=
 =?utf-8?B?ZGZ6WG9ldUtEc3RrMkRSZGFyMCtVYkRRRUxoUElhc1VTTEFSYkJxRW1aS0lS?=
 =?utf-8?B?aTVyb2dySG9LaklmNDloelpmajJxVVZDMHdEU1Jjc0pVMkFDektvM3RxRzBV?=
 =?utf-8?B?R0dCMnpNdVk4bWh2bksrc2xSRGtWSWY3OEtJR2pwT1NhcDRVMU9DaGZ0YjRl?=
 =?utf-8?B?WGkzVzBMdXRwTTlpMXhudzJxVlhYVEVlM3E5YnJjWkczWlNxbmEvazlVbytx?=
 =?utf-8?B?YU5RdS9kaU5iOXZlRDhOa1dwMS9tcTduT1psQ2J3OVBOTGFpUFdvTWRyaTFs?=
 =?utf-8?B?WEU5NGVYdVFVaUltWGxBaXZpMW5ucjA4N2pLVmtnaTNlTW5YN0hHRXJPMFlm?=
 =?utf-8?B?dHdCN2FvVzNGclE4WXpaT2JYd215MHhkdmtxM2VOYnBLclBNWFl3UEIrZk5a?=
 =?utf-8?B?SlN0TWdFVlQ2M1NVOXgrQWlBcVlRdFN5c0hJUE9HR3l6ZnB1NFIzUUlmZWFr?=
 =?utf-8?B?L00wOFZoc1pKZ3VybGUxRVhCYzIyUmNiL05vdEtBSGw2YUFwT2R3cUdzVzRl?=
 =?utf-8?B?Rk5QZWtIc0pWRjhEeHVFM2lYRks2VFd5bkhudlptRk5DRlQyR3NZa25FNjgy?=
 =?utf-8?B?TnRqcGpmenA3KzdzSlBMdnQ5cHRCRzMwNHp1UzIrcVJzTkVJZlc5L3FTTy9G?=
 =?utf-8?B?SEtPQkZKU1B0b0lPdVZHOUExM3ZqNjNrN2xRTEYrY09BcVE2VktNY0JVekt6?=
 =?utf-8?B?TkR4b0p6SUkySEsyblhUanlkWnBQTEhiNG9KVGV6elpDQzNwTExTampHemhp?=
 =?utf-8?B?SFQvWWVpU2ZSVmlpSm9vY2YvdStJWS9MV0xZTGtVL1hxZHp1MU9mbmM3emJJ?=
 =?utf-8?B?SDI5V1JqeUdIejZ0bmM4YlpHYk9WNTNEUVpCbmZFWkhlelZsK0dPRVFaY3Rh?=
 =?utf-8?B?TCs1U0hjR0grbXhXbnZILzBlVmFDUWNrS3F5M1U0MWo5Nk1udUdwK08yUERq?=
 =?utf-8?B?dCtZaGVxeCtUSEJ5SHZPeFNUNi9veVhkeUZrT3hRK1RXTHpmUXdjMkNsMGlK?=
 =?utf-8?B?NlJNOExJcnp2d3psckZzcy9CcUtSOVg3WTd4T0h0RlJKVnJGdHVaVmxLZVFs?=
 =?utf-8?B?VFZtNklJR0ZYUXZmUld5MFh1SkFaLzJIeU1SUTRxZitZaWMyZC9rekJUNmRN?=
 =?utf-8?B?aTVtREI4c0EvVVVsR1k4QVc0SW1qVVdRcjBJRUJnMTFHTDhWM0luZ25lRllz?=
 =?utf-8?B?ejg5Z3hqYjlzRGNpOFBpbU5JT0ZSYUhHWlJPT1p6eU9uWHF2NHY1Z0tUQzNR?=
 =?utf-8?B?UDNsZkE4U2FYYTI2NUdCM01SZVVjR091SjR6VXhPMm81UTZheUJMVTNLUHhY?=
 =?utf-8?B?Q2JaYVhHakNJODUzUG12ODJyZzRlT3AzV1ZiTnJEMG04d0RXZ2w1QVNYb0Ji?=
 =?utf-8?B?UGFRTUZya2kwRGwwT1hENU1uOWpza0pXVWIySi9XaWFaYXlhWlkzKzBNa1VE?=
 =?utf-8?B?aVhJVjRuakdWd0xRZzZmSUpJWXVzMTNPeGpUcGFtN2Z0eGUyTEY0ekVGc0xP?=
 =?utf-8?Q?KPRjh6ZECxD7IPXKZL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 815b9c30-916d-49e7-97fd-08df101d3392
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:56:11.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7HvVI26m6o4oKdtwYtqLJpu0vz9GZpTzbJg/fEMJBvqdI44vibCKOT0LPed2XrO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4177
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9247220009
X-Stat-Signature: ibk1uhd3yhxyhtiqng8nonwc4top4on6
X-Rspam-User: 
X-HE-Tag: 1789142176-991918
X-HE-Meta: U2FsdGVkX1/KyP2xJsAVP3skD1bLIrhCqY9hS+kb+lh0gruF1iMM5yrAvrrDk/FHonyXTokOAc201S+qDkaeCHhXLpZ7wPHMPhsthg0dSn9+v7nbe4FN5HfX5iYxx6fNAB70LhT7rpT8L0PdOTe9Xc+RQ+Dwmpm6jELGFtQIw9+ouMyITAw+ejRWILoysXVskWi65On5hEf23Tqop1B9djvWczVviaKtQdxXq58YR/sEN/+GfA/rozp1V0IYNGB0mPxzGdM5ho26kHbmCKxVsolx/GPMnmrncuNbSF/vsudDTB45xSdpnd9oJixdz2vwbrLmRnSI4Pg6S6HDXXaqZo07ie15vbCo7LsELmgFhBZAb8VqLP8asySG0DKxWZPL9ZH0evXxahjMSHj17tvjVjVS0KgHI+E+sU73Om15oI5ymr0q0nTDNexshU9pQm7ON2g++NFPLV8AwARf6WXrq+DO/fQTw1QEuAmK/4zIwsbi3P9pKfdc1MNkHvHzSrBgSpEkBZRny4nl9Ei616+FMSAnba5BWulBtS0fWY6+PuY4cUhKvco27ukQnRkJO4LRIj09SEBLMFu2kiDLb3vrmKonmJyY2DTaWgRaQ3+ZRr918ON3GZtuIRXDz9ppdfJulTEE93kU3vqx8v6wvTHuSReFQSctwezPgESaGRd49P7cVfl2pd6d6fMqYydUlwxyvRJqZZQCx1OUGfQlyb2sO810c/9BwNIM/8X87gkxYJzTZlydiOj041H6oBOoUKg1skomhRdjpAMqOdEWSFPQezxU51TZodjRD2trGXqF94wmZ86hZsJR7h4UtWM9hdCFlU/CvBwrpMUiLKtZaSjMtPwjRLcQ9zGkUrpounZguMhL7zWtEO9Fy5nHVJ1JPcx49Sz1NnbVFcTfhnUlA6AY70JnJRKmtDbwD9y/k6yXV//lpcWjqm3optakpD5AncOn6rzAQTzf1CgScsUEDEw
 +g3N/eWv
 3wghvqSLSeRh9Pw9zEz/BNgZXXvqQnLbtpQ9LLGSEGJt94qtRIHyjqpLL3do8E9QfYVuaIxtzvO0DkpegJS1OFMaX1xs1gvjUnrdEXDQ9JsXpdQuugT90usKBUQXFk6w/lV+vwXE42/GkCvRjdlCrHfz5avxo8xrtSnz1GCNjcU3EFX+jAoYefXpE7iayN4qq1bYGwBDlShpigFwfFplpAXgr7J9STddPtsTBnBy8rLdwcRCSLNEILKmkPuQdM7XEjewAg8JeAUu06He/5dQri5OHnnA6j6Ew2vjiT9f2hdMWWH+YnYDb+i5VVqi9LhgyVgU7LbzSD+Pe7TXzcNhn9huZhFPNbeq83954A/qXnjJ81gcRfKKvQa9NIcGG+jDUm4qcaw0XVUJ1xEgXsUGgsldP4jwkdTMPMYOuSaDJSJb4uMahVVcv8uW4mIEvY6A/YkqvMIdaI3r/IHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> The scan asked collapse_possible_orders() for every PTE table, for an
> answer that is a property of the VMA.  Both callers walk a VMA a table at
> a time, so let them work it out once and pass the mask in.  It is only
> good while the lock that produced it is held, so madvise_collapse() takes
> it again after every collapse.
>
> The mask is then sampled once per VMA rather than once per table.  A thp
> enabled knob written during a walk takes effect one VMA later, and cannot
> widen a collapse: hugepage_vma_revalidate() tests the order again under
> the lock the collapse retakes.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


