Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E3BF513E6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 22:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797F76B0005; Thu,  5 Mar 2026 17:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745DB6B0089; Thu,  5 Mar 2026 17:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DA46B008A; Thu,  5 Mar 2026 17:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50BE56B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:49:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2C1D57EF8
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 22:49:51 +0000 (UTC)
X-FDA: 84513503382.13.B8DA38B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E0D6180009
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 22:49:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tzSXnNOQ;
	spf=pass (imf06.hostedemail.com: domain of pjaroszynski@nvidia.com designates 40.107.201.41 as permitted sender) smtp.mailfrom=pjaroszynski@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772750989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YrsfIxECZ9joRMUdHh8abizdvLMo1U+QdJOIGBWjiU=;
	b=gQRGT++g/qP8r3HqBteH7pjVTJgBL4g0gVwKIGmJAyEOc/odjeOgr6rat0+ITGO9SzhKsI
	dwFF7yL/aTU0SLwyrP09Yj9hBWqtoGXbO7jlGsrI8K5gC3e+1zpdQma1fouJxkm/wEcEkv
	QXB7dyELThxKvp3hqgNzzfh0HcfUnCQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772750989; a=rsa-sha256;
	cv=pass;
	b=K6D6D6oqFFhZlSQopzdwZcGmUKEBzL3HbSbx+W3miIoZQdxjhg/KYe/6O8V0DY5ieu5PkF
	kLdQN2yUwSEM2spysG5ICbzNXXsbSaheVJrMB+kRmWVu6p3jw2P5aFQ2uPg1aM8mMd0GEs
	gs2aUuXiN1NI6NWq3Wc0I5ZBWXt2XTs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tzSXnNOQ;
	spf=pass (imf06.hostedemail.com: domain of pjaroszynski@nvidia.com designates 40.107.201.41 as permitted sender) smtp.mailfrom=pjaroszynski@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPBBK3SV/aHgR7rZu6znN6a5n1a/lDxiVc4kVLpyXijkpi+dQMkN3/9p6UN7nvvnGCwKuuXr7KOppys7wfyKdGnrnxlB5NGnZvq5bJbqOhbDq+/cQylrERedFLBk/fMESA0gIzrLnOZTiPTd1Qdcsr+TmhtWhdKcFgBAI1TIi25bL9zH9oCJn9NZS6JaTCEslT/4ulcMuD4GUcPZuxx9ITYTua1EnjeNavQEQvWb2fN6FeCZsr5QWSXnOgGF7sKU/WXbYPjpB8qngt0FjbOM6CYVIQ/1uOZWhtz+R2Um/7kwcDEE3sc5cXl7UdbGcc+WLihjBGVTkKmnOV63PUMPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YrsfIxECZ9joRMUdHh8abizdvLMo1U+QdJOIGBWjiU=;
 b=Jkp00J3ZkzJKCP0G0y4Zez7nHPutYYeC02s0oZ6pi2V5gueaMe/T0lHJqvtGjzSElnJV5l1o6rZFfxpieJDHo4dl8yZuh/U61OqW7IW7bvpqXMKVZIj+KRGiCT3qqA9aqgb6a0QaGW7PF77XAbYdEuui+QbVKW0KqJWl0u6mli09F8CMIbC7gDuhYktZ7aYTmtg+0TTWavu1XmRFDkrgd8ZUUmwJEn8rmVWE3ojcxMXHZzg/m7z0sJUlYRsDoAkzFNn75QWeJEEREOsAfHysVXPhHmFy53Lzdrp25+pG/cM4SvbIiQf+CDL+1LmkuWVO3Ci7EffkTUbCQJlyPwTWhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YrsfIxECZ9joRMUdHh8abizdvLMo1U+QdJOIGBWjiU=;
 b=tzSXnNOQQWLLFpHNzlYzv9Gs3JsFQIU4He+uGhIG0x2gFeV+Y5+FHFtDKnUl0RLZOosWczsfDrspjEzvYW5Q7mq/BHq5TZA/KFg4K9ZtdZEZu9z2SsQ0nRIJEJdFqGnq7LvMgxZX0Ol8/mcpvQZaq1t4jj8+v0JlQy3gLrk7APwk/7hVXFThgXat8gRW/ftAuNVO1BoSd2obAuj/v2GIXhXD4xjjq9+SBqf27KFl1DbrA6eVn+KaaUEsYRQfnjoOSeog+W6JYDtzYxbLgLpQvBtCRevxRa+bzhVKFMcOQpznzcQ8JnBjKuKHnYYn6ONkLIBIIfcSwSBaoi9kAElzCA==
Received: from DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) by
 MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 22:49:44 +0000
Received: from DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46]) by DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46%4]) with mapi id 15.20.9654.022; Thu, 5 Mar 2026
 22:49:44 +0000
Date: Thu, 5 Mar 2026 14:49:43 -0800
From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>, 
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <aaoHSV-dL8ernMLR@box>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <aam-ZSHWrkYX8spV@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aam-ZSHWrkYX8spV@arm.com>
X-ClientProxiedBy: BY3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:254::10) To DS0PR12MB6559.namprd12.prod.outlook.com
 (2603:10b6:8:d1::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6559:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 563dedc2-7fa7-4805-7721-08de7b097ebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	eo/5+yZlYmGzOCthoz+/eKTBbMjt/XnVb0b75pUBThfTf7pfsbw7ECISVBUjDdkO4gJ6IEIy0GjyYrDsokS9goJ2T5tgzOFOChqPfjVFv06e/2s5DOhyAJTIRDTqCppUsnwBGDOpAQhOq3E+yT234+riwb8Pp0iPJDml6D9o6qm+OSOm+Y4nxoWiZOazbNZfePZ85yZ1AuIs0OrkwLicpemIaY1lKJsCoBkXXB4QQ9JS9J7zKco1o4C0fKvghOvR2YxukCfIz9pnw/IvjwB1AvFTpr0EMK4XGhqcGBYR14b1uFU3jcpUL+yBnaKDx2LK83Rtxo1ZjlQ87LxutYy5p3PAaPXsuzvdICW6v1+oKDvaEgY728IbcGCOrI4v/JVKClZfIF1m4kzSywkzCcFqSN8KQ8PdjMKLxiOVDvOsVcdlTuNdXHauxDnmNfd3mCtcEj21K4n9FCKSKnTzvHELCG7RHn6qG0DsjbnX/LEYW+gHJZNwG5EKrmT0feIVLw6Xt1VvXetFOwWuulAG5EykPFwSNA+IzYjS7a9bFGPbouCOtOz8aiNtTsr3B/AmoShPUuZmDdFSqPA2XiAZvUtEsxpeBN5J+EW7bsHDTIEN89prdph6qOSaDrYbZxB5aoaD/23XoIhOFb8mzUsdiktD49+oskaiMyDxhRM3kvoXvHzABNl46lgWMJ9r1nazyxbpD3ZrfDhG05+XiQ/py2XXipsoE9euRNaIaylOMSSM22Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6559.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eWuW+vokEFMnWNKXipGZmISMjhWmO8h4iTTOnJodkdA7OyywMp+HX07wQO75?=
 =?us-ascii?Q?smUzDaHy9qKWkrwOlwy/shYyA9jyN/m2VlJDFmFyruy8Sz5z+xd+Xoiuw4Us?=
 =?us-ascii?Q?oCxJFCCM74FlCL5rEccyJgQ+cw8oAn5z5v1c9hEBJUEQ4hOTtnYfX8LucBjP?=
 =?us-ascii?Q?fTy9tnEJhvN8puSoCxedOrOtjdt+Be14Q56+N4cgCmXHKv+4l8D+yRKqScZl?=
 =?us-ascii?Q?UtntwBbixlzhxA5WQIpHCrO07RULlxN99vVhQtHau1lflqVW5m1GrLAdvXS0?=
 =?us-ascii?Q?UAy3vuO0zmze+W73fDYQj42ZJjHWvFA74BZ8ssUfQMEdC9zJMetXlXYtDee2?=
 =?us-ascii?Q?vwDWikjFBl9lhAHJm8qt2P3Dm//EbPz9A3ZAHrw1t31KNQzXeLIo1RV54SZb?=
 =?us-ascii?Q?PMCu0uJ3tJToial/bF8GEMQYd5dcDAjJQoXPNlCHeoO8PDYIUH8IQHIb/3ps?=
 =?us-ascii?Q?P0j2t9QFNqNHsaAm1QfNYoJuoZ3PRtpr7/YtV8mi4icMyfpIkKElmAuk+lAp?=
 =?us-ascii?Q?nOieltGdvEXjHEQeUhSYhsjAQErFa7O2Iniu5CasC+63/8Dkr3k/m9hob5Ky?=
 =?us-ascii?Q?t/ezYA5khJV+IlVQ2wMaantFi+ZVaPDGuv50eP/STiiNTQJgFSAqmQZ0BSwG?=
 =?us-ascii?Q?aJKk5iHiU4pJ277uz9FCQG15a+oaAtdYt2Vs/DbfZozFIss4UXOK5u3g78JR?=
 =?us-ascii?Q?EmAJySNKXYDwgDHuTaEPUo87yXuTexfgPkn7CDLGw3BPtkfBR4BAUQ/MIzrh?=
 =?us-ascii?Q?78XfUUAW/+8bCrADBcGM4YhFtDailS4XETif74cgzmujYIsBuk8178ZhgSfg?=
 =?us-ascii?Q?NbnN/ipxmmuKYrBLbUGykCXMIw+tq3sjhjuTtApSDtCa6NPZNg02oiuv2o13?=
 =?us-ascii?Q?RKIlt3llQeh6KFQmW5De+5c8U4xrDGN20VBxmlFpLib4OCJMSpPrFo0X4H+P?=
 =?us-ascii?Q?C0GMRnIAhH0ONosK5idzVZQjHYNzdejmKi5uzJwzUUp1cfjbl0mTjSMJnJ51?=
 =?us-ascii?Q?Tm53vPQa81lG8xIZirkoHdbY7SaB4IassWGjTvOba4Iibe2dAqpfubcrOqm0?=
 =?us-ascii?Q?CAmFFUqEUWR1BYOISkxEvzZN9pOhFIj2VPza76Jnep0OYv6UE0kCne5jGdXh?=
 =?us-ascii?Q?yvMtQYfjOvm5RuHw5CekQX5y2pkkDAJkK8vhsTcXwjLbS7kPz8UjGW9kR3dr?=
 =?us-ascii?Q?QinAf5Vv8E7II3RE4eG98drTJDUgvoqjpBpN1/ZR7gxkigz5BS9YFmkQSDp2?=
 =?us-ascii?Q?DMgRC4drweZoRP/JTdQDfpz5+nbtO5WiJ9SAX8Cvl9q1v3HftgsSbXIRz952?=
 =?us-ascii?Q?Ie3nN+1eY24WF1U+lmauuS7ITYgLlg5iQOuDxKulu53/IOdH+Tiv/pcUOKjZ?=
 =?us-ascii?Q?HnFpa1xvp52AEClLinBFQLl+IaKnt8B3sRE6QqQNdhL32dO4UeB+anKej6VB?=
 =?us-ascii?Q?ItU4l9+DL4UNfmb8L0VygQhPQDAEU2oAJgDi8aYkz6MIzRJStbsqBqRLLFIM?=
 =?us-ascii?Q?KY5UpL/eVzoxcjJgm/y6LX/srvUzv+CSmiAwCx0CRfrdUQlePwjZG5eoSnBm?=
 =?us-ascii?Q?rSX1b7CECng5063/r/hBUdGzzyj/vgZeTESJU44g87BonAbi50nnJP3Y60ZL?=
 =?us-ascii?Q?osf0/g76frS3ZcTPt3EAnZOivjzjmeZRxK1jij3NhmF26rAUqhjbwooDXWeL?=
 =?us-ascii?Q?bcMgcufuKiUvorEx6wMBsZE0V1nagAhh69zz7uaWnI6eJq1CfUQ4YGbySiDo?=
 =?us-ascii?Q?RUMKyDdUiZH4Z01LHrES2+JsnTgYOjY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563dedc2-7fa7-4805-7721-08de7b097ebc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6559.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 22:49:44.5795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+1P4n4/6eenWCoe+W47rgnafoHKeAQJujoQihjKnVx8ltxzuvKfszapPb3K5BYG//BDgiKlGOnteoUqjCVsFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565
X-Stat-Signature: ybx4hcky67gz7s53a91yne5bq3qkq7zi
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E0D6180009
X-Rspamd-Server: rspam12
X-HE-Tag: 1772750988-3913
X-HE-Meta: U2FsdGVkX19VCs0JuUZaAggGW03yV/uSWxX4AkUqmH8EmsJKKHf0+V2XJgUlDr4iGIbKBe+NToSdv59ujKFJ5I7T8yoLR/aDlCQQtUocQOEqakQL4YfhZQY53BL2QFB/VbfF4NVrZPqcf8vJTqoyfI4mlApMXkMUzjf9Y6zIuqS3/skgbWmt55TiuTAsbwmecL5chDYcrEHsmMNUS6ysMpMeTnhqGHQKkdU/d/idSSK1R9HehJirzKC4oF+orqXjehgbf0yzZCSUve21K02QBDEaAtEyKyDV6qJxL6dBFkCvVj5bmIesWgzbDHY/MkAoO05aKExiNyCKgyoYXzVpPt8XEpJTkrjdna+45CpU/KIRxUDnLTuW/tEiN0O15930L6UsvmkoS+bazQXp/C4O5tc0YK1z0pEeQayNI80NnDTvfT1UJdoOT62RzYcaNL+26AfOX0Uzur2td6gO3fOHwC+tpToo+GIuevZCDbXp5ZeaHZaPLsaTjbz9DnBKf0aE20HYlI9NlvJtcyMZ705wJH8K/I/POkmYJrrwpy0Jw6jcGswlDVZLylDQuewH8x93BoZpcVWWBcDWApYeEW3IT78de65ivb3xIJ+dxZ32Nm0rmhwHH8ycgNlRRsWh6P3Q9gk8oM2i8ERUvSnnZUAAUZboZIDpeUNBgAoa8IMSw+5atauORZlCnFro3Iq6gom9PAM4dsw4Vl3p000Wc0dDw/AvnhXV/o0AwzV7sa2aUIgiL8MdheZgwLOQZ22PHPGjBu1gonDardvC69/hYYGeH6x1o+VDx6vXTJPHC9jmCH3JLRWIowf3YtyJj6HpvjOA1oqL6EMSjQ46nfceBRsVsuxjX2I05RA6E0SEug6WjFxa0K1Mc5j1JYsJn0dzjrmZqpqhuyg+HuPshd1i97rtGTkT14Dj3HZP+4il1BHNI/cycerXfXUClNFcPy2et5Ws0kvZvfh1fiD7CDjQ5l/
 yCFU6WZ7
 RRLDbtcfMEE5BfBAPU3gl3T0XK86INjalSZi14ayRDKv2R6WkNYC3avyxb18rEietDePmi532xICe+0jp4Z6YmXIv5/AtxtUCBati18EFgYHRASK+6pGt4l30la34+96bHtX1cmTEKAmtaDAxZ0cMxGpBAVqHGWs+IkHZE6fkgTNdXo2Gky6H3xwlc2QnMHtvLiM1bc3qubX1CN99DIYFlr2gK7D1j2R01B2gB6iCodsaT4w2Xc8R36tm7WkwrseMZi7nsvTFph20GY7o/FepAMHufVmZEw/BuNmfJmWyb3h7GqGooN7LIb7hsnqfDL2iPM2eLoKT5zJCoWwSd62dsD4OAYEpKmBA3vd2JWR4RBKbDEQg0dOl1ufJRml26utrUHgdYie80c924ixXOFo+gnXrAvFPid47MEo0Wd2ROHzwMUP2YdDPjqs44XB0vC3HVQ6P/mndLsc+WiIRAS0pMXbMUC13YZAoDfbp61gyWESSZZG3MYF4JfdIDX9/NBlHDx5zqiPJmv5GOWz57NjvzGiAJbzj6S7hh1VK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 05:33:25PM +0000, Catalin Marinas wrote:
> Looking at the patch again, some more comments.
> 
> On Mon, Mar 02, 2026 at 10:37:51PM -0800, Piotr Jaroszynski wrote:
> > diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> > index bcac4f55f9c1..9868bfe4607c 100644
> > --- a/arch/arm64/mm/contpte.c
> > +++ b/arch/arm64/mm/contpte.c
> > @@ -390,6 +390,23 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
> >  }
> >  EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
> >  
> > +static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
> 
> More of a nitpick: since this checks both the flags and write
> permission, I'd rename to something else. Maybe contpte_ptep_same() to
> somewhat resemble pte_same() used by __ptep_set_access_flags().

pte_same() also compares the PFN though. I picked the _access_flags
suffix to match the ptep_set_access_flags() naming. I do agree the
aliasing of AF and "access flags" is unfortunate, but it seems
preexisting. I am updating the comments to be clearer in v2, let me know
if that works.

> 
> > +{
> > +	pte_t *cont_ptep = contpte_align_down(ptep);
> > +	const pteval_t access_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
> 
> We can drop the PTE_DIRTY from the mask as it's not relevant to the
> hardware permission. It probably doesn't matter in practice.

I think it's good to be consistent and just update everything while we
are doing it such that the sub-PTEs are in sync.

> 
> > +	pteval_t entry_access = pte_val(entry) & access_mask;
> > +	int i;
> > +
> > +	for (i = 0; i < CONT_PTES; i++) {
> > +		pteval_t pte_access = pte_val(__ptep_get(cont_ptep + i)) & access_mask;
> > +
> > +		if (pte_access != entry_access)
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> >  int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> >  					unsigned long addr, pte_t *ptep,
> >  					pte_t entry, int dirty)
> > @@ -399,13 +416,35 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> >  	int i;
> >  
> >  	/*
> > -	 * Gather the access/dirty bits for the contiguous range. If nothing has
> > -	 * changed, its a noop.
> > +	 * Check whether all sub-PTEs in the CONT block already have the
> > +	 * requested access flags, using raw per-PTE values rather than the
> > +	 * gathered ptep_get() view.
> 
> It's not just about the access flag but AF, dirty and write permission,
> all can be changed by this function (and only to a more permissive
> setting).

Thanks, updating the wording in v2.

> 
> > +	 *
> > +	 * ptep_get() gathers AF/dirty state across the whole CONT block,
> > +	 * which is correct for CPU TLB semantics: with FEAT_HAFDBS the
> > +	 * hardware may set AF/dirty on any sub-PTE and the CPU TLB treats
> > +	 * the gathered result as authoritative for the entire range. But an
> > +	 * SMMU without HTTU (or with HA/HD disabled in CD.TCR) evaluates
> 
> Or CPU equally, we don't force all CPUs in a system to support DBM.

Thanks, updating the wording in v2.

> 
> > +	 * each descriptor individually and will keep faulting on the target
> > +	 * sub-PTE if its flags haven't actually been updated. Gathering can
> > +	 * therefore cause false no-ops when only a sibling has been updated:
> > +	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
> > +	 *  - read faults:  target still lacks PTE_AF
> > +	 *
> > +	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
> > +	 * become the effective cached translation, so all entries must have
> > +	 * consistent attributes. Check the full CONT block before returning
> > +	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
> > +	 * range.
> >  	 */
> > -	orig_pte = pte_mknoncont(ptep_get(ptep));
> > -	if (pte_val(orig_pte) == pte_val(entry))
> > +	if (contpte_all_subptes_match_access_flags(ptep, entry))
> >  		return 0;
> >  
> > +	/*
> > +	 * Use raw target pte (not gathered) for write-bit unfold decision.
> > +	 */
> > +	orig_pte = pte_mknoncont(__ptep_get(ptep));
> 
> This is fine since all should have the same PTE_WRITE bit.
> 
> Anyway, nothing major, so:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!

