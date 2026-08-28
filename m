Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3415FC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAA36B0098; Thu, 27 Aug 2026 21:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB9B6B0099; Thu, 27 Aug 2026 21:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A236B00A0; Thu, 27 Aug 2026 21:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBD906B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:57:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34B9A12024B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:57:32 +0000 (UTC)
X-FDA: 85149016344.26.29176E4
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by imf05.hostedemail.com (Postfix) with ESMTP id 602F7100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:57:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h81jkvJ0;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noUbmMJ11ufufRtkRrBG1FfDnNRRZJH+rUpAWaj9b3c=;
	b=yuJbgQjdQ9xyDtEhzTVDz26J+eDtbgCPD20Ncgn97tmoLFWmPF0mCnZrLXH0hAATeZE26c
	eR0XnnJRVmlMKHzSiTuws66lCBpSUJ7tuRZUO9fLOC5YWwvSyvQPXriRJTVxzKpNYZKZXE
	N9zQKOvRMCgNYhPz+IQtLZ38/dBO/Lc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787882249;
	b=SO68oO0lECCtVHLdh/0wC8mB4S1DKQwBq1LTXnzQkPx/khKSo7NuXYDRlCxb1vMEgT4YhE
	QUK/JZIXaHgtHN0sEdumMG6DqdprlTHIon+qHg8hwaMBfEDnJJF7bNZlxu9tpRZguAY4Tv
	MSjb95dcWDorqbB6qRlA3yDLDyJZ7GE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h81jkvJ0;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HenubNH7EakCj93fFa59DwfVBSODpDUwrztved6FA6bLK3CCP/0H73IZmCUT5HiCSpCn5VyFeqP/ymgMDIiBpBRO98LD3nbtvK7ZT2BjivyK34mXO8ddjE2Anml9BwqDaZ+ufmLVW/CXoqeRKpo3LtR0EgcQMWscw0rXPEACOX20yw0CLWiSENWZTOnlUkVu0hcsLlaEU/B6f14aaoAc9Nsef7nnmDlZU3APoyfK0t4d1hOS2JtB0h9+kS0g5H/J2UtP0vht0E0f/cvNF7tVEIwuRvlRq0c887XavaM3SNE8hrzR+0XE/z5xQK/T1xt1Logh6Dbcm78Y7oks3MpjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noUbmMJ11ufufRtkRrBG1FfDnNRRZJH+rUpAWaj9b3c=;
 b=gAL9lCHB6itELzcZyotpPLm8yTMYhTcLasYSXNmf4QPcGOOChHD6E1T+0zi0p6UuUQ9tR2WHH3ThfOJ2HhmehEMJNQP39VLmZtea5rpigm0yYpvLUGauG6qMVUkJVf3SFcjl0P/QZpWf8OnTr3ZqQnf2lo1DbBMbyfbriEMAW+0ezdWC+H1CLWWC03hxaIKSDvLIm5KbztecbV2tx1GjnOhtk0r750V0ZwNqJme6UtYh+dGc6KC+z5YWFmsHtFypcO447JjbDhaSs6boKsa9DBy8hRSOI8SFw0rl0EPsW4UKQrF1vHuirA1jzTrpbnqczp8h05luijD/mP9v+4HOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noUbmMJ11ufufRtkRrBG1FfDnNRRZJH+rUpAWaj9b3c=;
 b=h81jkvJ0eKczzosFSCerb21Td/xe5ETPVgVjHzQ11d0Gu3VYiZ3qJojO26SpHJKJQJBoaCSzJavfAnueYwE53VlFeVaOBsTT3fjR5OLVgqeEUAoChMOlaV90ZqTniZ5KTwyD7zsWxbVAvKIPyE0WZYWYIZ6YKkuKC49B/CkTHG/aj6b9js5RsEfN8SH/ZcVx7g3SqNjR0C+kBAAOv6EKUikR2usg4u6xqde/wSFAnzLxpQvNcf6MPJbh8obpkoeQSHI4BKWDBBhxdrPoOwN7ZB1v1/hh6SU9QDk9ZdGwLClTcjGnXwbq6dJltH0mP+ern34EaINemfPwoMUsYpHVeA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7977.namprd12.prod.outlook.com (2603:10b6:806:340::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 01:57:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 01:57:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Aug 2026 21:57:20 -0400
Message-Id: <DL07CYI5866P.2HCBRH4BWPMKN@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
 <hannes@cmpxchg.org>, <lance.yang@linux.dev>, <hughd@google.com>,
 <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <dev.jain@arm.com>, <ryan.roberts@arm.com>,
 <balbirs@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Usama Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau"
 <kirill@shutemov.name>
X-Mailer: aerc 0.22.0
References: <20260826162101.1314941-2-kirill@shutemov.name>
 <20260827163838.1813081-1-usama.arif@linux.dev>
In-Reply-To: <20260827163838.1813081-1-usama.arif@linux.dev>
X-ClientProxiedBy: CYXP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:ee::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b5d61b2-c48e-46e8-e518-08df04a7b424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10067099003|22082099003|18002099003|11063799006|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	CKTugI2lwEUaRekORQXWAS3uDgavLJ0rrN8dTTQLFXSPjS2RYp3jdUNRfEXe0xX1riRCih7btWB593VWUyS/njzBSeu1f/sBYecaMz6Hx12MYQPkd+/MFg/TxEKl1uMJ2m+RNEeAg/MN4OX7JS6D/GMvG2ugKnpfnBXV3I3MWp8FfFd5kKBA0gdoWpFbp2lLJSNP7wPZJV0czWSlatSNdszm2VJykuSxFdDMeAQz6/pZcEQBveAn7eU5ivWAVSwQA/uJT1rhLfSnOTIDbg5zqdykm/F2fd9g6wL7Lv4oxGNehDxAhrJAklQpKwvEMXGcg8TJhY1pkboy44tyqUyyYawsQxap/UmW3PDAAMPmIumC0INb0wd2LUpau8nCEuRewsUV3HJbgAnGLx2g+PtGl1bEIQE+QhjU47mcsNOR7z7Sriij/jLDIgDLcxXtoS3aVDEeENlQ2aq6tAD8U8HCliJEWlO07U0JsNu5Z0S82lj+rNKb27yKO5XHWMMzgWOOE5xuAKT/eNhGWbxmdq5lB7GdI4bhtCmow+rt4IB7VubEqR6m79sTXyYCaA8gkY1eSUr817EKdoBRq9BmdXfswyh5xaYx4cfOak3rSmCqOt5aB3p5Mellr7O8AsjuvK42HPWcDp+/xAG1hmtQrUQM07At+GPX/6SPc/AUh01J8Xw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmRPOWlpUFdaUERyTFZMc2kzUzhDTnBCSkI4S2dreEFvNysvUTRtcnd1d3Bo?=
 =?utf-8?B?WVpoNjJ0K1JQMUVMTnJoNnB4RXdUaDJ4TFdQbkxFWjFRZkVLeUFIem1CTDJm?=
 =?utf-8?B?Y25OdFVuQnF3eVdUMkhRWnRnWlUyYmFWeER6RWhjbGsxbUxNczBDVm1TVHJt?=
 =?utf-8?B?bktCYTFoMDV1YVMyYmR3V21YcWdZRGRtajNKcXF4TUk3b2d4TjVzakljdkhj?=
 =?utf-8?B?amxjeFNQaDEvOTd3MURPS0lEajdRbkozQ3lpakN2Y0pwaHlFdmFjaVUyc2NC?=
 =?utf-8?B?SjdmV0lNcG15eEJjWExkemg2UkU4dTNxTEtsZjJZcDhqUjUwVmNkU0R5andX?=
 =?utf-8?B?L1ZIaGNqLytsZTNmYnlvc3BlV1FyUUFvaFpSSWhpMlp1NUs3Y0ZTTEVwZE92?=
 =?utf-8?B?ZXV0ZDA5R3hLb2JhTmk3VUI1ejNpVHFCRVFJdktEM0tvdEtwRmI5RlZCdGlD?=
 =?utf-8?B?RlFVWExSOWdteGR1aFdhT0ZwUWxLclVheWhmcW5RYjBXenZteDBFZ3kxQkdW?=
 =?utf-8?B?UFZSUUViWmZaUGIvbkZ5ckhqOWpncHpZNHBIb3pFWjZxdXU0di9uaWNlWDdW?=
 =?utf-8?B?RXVTK2pGcWg4alZsYUp4aXNiaFBhVDZvNWVIS0o2bndnT21JT3NjVGVEUUho?=
 =?utf-8?B?WWdXWFUwQVdSWjh3Y3MwRlc4OGF2Uld6L2JFZFVVN01pTThNb0xMWTY1UWxS?=
 =?utf-8?B?N1FwNjlhYU9ZUmVGS3RvUDZBMzFBVi9tR2UyU203blhzUXdZaW9nZlRmSC9w?=
 =?utf-8?B?WnhCZVhJQThFVDVoOU94b09yWWRlMVh4bzhDQkFua0drb3N6eWhveVVJY2c2?=
 =?utf-8?B?UytRbDdUR2JNRW9Va3lNWTJXZ1BJQ1lDOFowV1ZGck82bVJZSk9jaEZqWXpU?=
 =?utf-8?B?L3FybGJnbGgrcmpxdkFjcnJYL1lSQnJEUzMvbEJPcjZTZUsyTUNvZ0o2RjM4?=
 =?utf-8?B?V20zVXk4WTNEY2VBd25wOUdRUXpEbU1rYmxST2dBNUR4Qk1LSW9DeDVPODEr?=
 =?utf-8?B?ZFJndW44dTdDVnEwQWhuUnY5N0pZV0NmUXRrRHlOcWdvNnJDSGN6V0twcGE1?=
 =?utf-8?B?Sk81M2tDTjF4djFmMVU2NkFCblVDWDVid1g2VjgxaXlaUVc3SWtqbDEwTEMy?=
 =?utf-8?B?Z1IrYTY0RDhzNnpHZCtTRTg3aXFqZmxUUDhwMVJhL0tCRzdPSVVObGhRZktz?=
 =?utf-8?B?Q042d0FVMHBKYUZQc2FnT2MzL2VBdUVhdWd6MTcxa0t6V2V6Y21EL1ZmQ3RV?=
 =?utf-8?B?VUppVWFjT1g3SkJCS3FST0VmcExQa3lUUnB5N2U5cFNDVzJWSXk3WHg3MUhp?=
 =?utf-8?B?ZkF2dEV2QzdhMkRGV3hXRW5MTVpNd1g3VnlzNVFEZ0Z2OWEvTXc2MjE3Rm93?=
 =?utf-8?B?ZFRPOUl6bWJsR1lJWVNLV0RBQ29NcHdQdzk4VHA1K250L3dqMjdkNURUcEor?=
 =?utf-8?B?QkdDbTBRWVYrNlpYdXI2dmlCdWRONnR0dmtQdHd1NEdVUE5McFIyci81SUNx?=
 =?utf-8?B?ejkvUFh2QVRhT2J4RGRuazVzOWV6ZUpZcEJrUloyVTlIdTFVRk1JblRMTmZ4?=
 =?utf-8?B?cEpFYm4reHBqR3hUR1BxUklEUTlvcDN6ZFp5b1JWT09YRThOUlhFOERCMlVJ?=
 =?utf-8?B?R01LS1hka2tPOWVZMG0xYWRwdEEveGNLODFwbjQzdlJnU3pNSHN6eUp3ZVVR?=
 =?utf-8?B?V1dKdCtKZjdhRjZOSjNzdG91NFUrU0NJQ2JmSjVZNDhlbGpaa2toQWkrOFpW?=
 =?utf-8?B?d1g5ZDRNdXVlYm9yZGFacDF3L3VpOG1aVis5VDZZeHJqcHp6ZlNyRlRLaFMy?=
 =?utf-8?B?ckdjcDVJcnNMbnZ4Ym5TNUd1MFVmbXlKUUwvbUhNbkNQV2p6cnhqelBKdWZ1?=
 =?utf-8?B?L1F5ckdUVjg0TU9QQkR4aTVad3RDdXgwWVI5UFhDcGtaU3p6VEh5T29NSXBa?=
 =?utf-8?B?Ly9WTHlDRVZZSGhuNXJrNFkrTmw5OURnZDdhbFN4MW9YOXRPTUJ4SktKSXZ3?=
 =?utf-8?B?NytSMHBIengvNW1CUCs0RmdyTlhLRUtBTDljUHpkeEhta3MyYWFESkNFTkhp?=
 =?utf-8?B?SnRpNlEvYWFxQVpxdGJkMTc2aU1SNlNETHpTS0l5Y21tbkZLRVlPWmVWRE9a?=
 =?utf-8?B?bmlUQStxbmpGdWNqUGsxWkdXRTE0TVhYUzBLODdBR0hzdHl5WE84bFI3T2pp?=
 =?utf-8?B?OUlkT1d0S2F1UXhGcWRPaWk1cTM3M2N0Y0FVSjhFdGtJbDJaQ0lyQnBFYnVv?=
 =?utf-8?B?QnkvbUFMNUtCcDVGZjBHdVJFTDZzN0ExUS9qWUIramxEM2xSZnIyQy80cXg1?=
 =?utf-8?Q?rXybTLmxTEafrBQZAb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5d61b2-c48e-46e8-e518-08df04a7b424
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 01:57:23.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YQ/HNbU4qNIhbTLt4Q8fFczrYqnHbQ6IqHXeX7RmlRbp8BNGucWxEOBmKvQstZx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7977
X-Stat-Signature: q35xed1rqb5jqse7sz19h5m15yywkp18
X-Rspamd-Queue-Id: 602F7100003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787882249-585535
X-HE-Meta: U2FsdGVkX1+dCn4w/xr64EpDQ/5HVNGAgrTsvJKEe4BTjTIkG2dQ9aDwke8aUsmEJZQq51uFApHV4Ev+iOJzHLSV/RDF6RuRE+IGdaqIj3k5WzVlQg0Pbi2rakxXJlfLpyLpi4qQ0DcvNSmZxWI3ZoHJdiO5vGCzreAJBUIy7/T5Dqdd9MQaUalt/iK3B+egdMP9s7Prn/K0BZyEI5ptmdxFUN8QuCMwjY0LthCvCTe0c0BiFEzr/xCRU+IHL569Z8kLrS37Aoe1+wlohpyB29Ty8WR54ky+JA+pf/Un+VzwNbtB3F5Oq+BrL3l+O44SJuzC9liVP4ex7cUU/DFKQK1V15xm588MZWs2Vgwp/yVqUZL8i1xbRj4fv4byEmAQX5kiaiN4rBf3wuc0RfNV606gwkW5ZEC1mR6P4RCmm2UfhE8rou4n7Or0CjPIfu2qMSaQ6udN7P+4kJ7ucfh07WnManJd/Ha0TmZvGBYLKj7oaiDqYn+r8OQpsNpehb6/1l7zZQLGpmEhbEFdlfZFV5/iJCfnEbiZEXiqyZIaS6Mq6hab9s1PlE9Mic7250+QQe6bx0DDjn8WQuuUgkj0Ufg+12MAqmz51sNqqO7J9Fw91CH80QZOlWMYQNDNSSXNwwvFPwKOWays2shA6sHrrZBLFZcdS55RIAriWh3Efvm88UklujP7GQdZvxbTTjSOMrdIGxlP2vuiridIMDnYHKssbxZ/bgGcQB/6V/1z+p7EeeEZRKewOEgnHW+zGlMyJfP9eJF0L4oXqTjvzv8/ypGwzQXmJKn9snAOqhhUKaik+uhrW63a+ZrklTdWpTaurlVKb+6dMWkom6A5Ts6Cb5lTi6LpcLAfXhyF6Oj6D+DKytLaL+++8Xa3AEr79rZw8yeOQFjzdQmU2sj2R4VcxtIhStycFZgRvYsm8HbYYEz5Y8HnIofYtuVRb+N+WJ4CHZQDwbcAWwWZVPYWqgr
 2r34Pa17
 hUhsCA3ztEdcaPCf+6yPDaZNxhDtP3kSisTIFDpt8BjH+6USu0XC/Ua9CtVNROlEdZhIUA4HGi0H31sVV9ReYBCx3WkWkPwAFaTS7u4Iaw+jrI3be0R5iY9G8Ktwd0D0/Gc11UUJo2TIg8U/ESWTC8OaCh4WkeFeU6yF50utFm5RBCJXT/g8HBOH7ZHv1SA/4MHT0gp5Zm3RJZ2rQM8ppOFTlifk81FG3PLJBO6Dt/QZutryA/bfFZn0YzDgJHwfm71VZ/kEz9o0JqhqQYuUzmZbIsV0xZDQI5aiWcb2bJMGg8Rtggjl3FfDoYOEqz724OqEJqYx/gJgxjooaLc8NdP5Gtac2GNsn+zOLtDpDMgEx2HbE/cfNZKyu+X+oydoqHXElii2LGWog64xk5trBZZ3ssPdayHlfwl55OjnwuO9tSLg386j8rM/FHJvEG7szaH5kk5M54Q8hQwaj5usig1fmlnJ3RfM5cFB5dKtQntFtX50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 27, 2026 at 12:38 PM EDT, Usama Arif wrote:
> On Wed, 26 Aug 2026 17:20:57 +0100 Kiryl Shutsemau <kirill@shutemov.name>=
 wrote:
>
>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>=20
>> deferred_split_isolate() probes each queued folio with folio_try_get().
>> folio_try_get() failure is treated as a lost race with folio_put(): clea=
r
>> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
>> the folio off the queue.
>>=20
>> The folio_put() race is the most common case for !folio_try_get(), but
>> it is not the only option. Another scenario is folio_ref_freeze().
>>=20
>> A zero refcount in such cases does not mean the folio is going away.  It
>> means "don't touch me" and current deferred_split_isolate() doesn't
>> respect it. It can lead to unqueueing folios from the deferred list for
>> no reason:
>>=20
>>     CPU 0                            CPU 1
>>     ---------------------------      ------------------------------
>>     freeze a mapped folio            deferred_split_scan()
>>       folio_ref_freeze()               folio_try_get() fails
>>                                        folio_clear_partially_mapped()
>>                                        NR_ANON_PARTIALLY_MAPPED--
>>                                        folio off the queue
>>     give up, put it back
>>       folio_ref_unfreeze()
>>=20
>> The folio is still partially mapped, but it is no longer a split candida=
te.
>> Nothing queues it again until part of it is unmapped once more.
>>=20
>> Skip the folio instead: whoever freezes the folio, owns it and owner is
>> responsible for its fate. It also covers the folio_put() case:
>> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
>>=20
>> Reported-by: Lance Yang <lance.yang@linux.dev>
>> Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linu=
x.dev/
>> Assisted-by: Claude-Code:claude-opus-5
>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> ---
>>  mm/huge_memory.c | 19 ++++---------------
>>  1 file changed, 4 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ced400f72d43..6281ed993243 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4590,22 +4590,11 @@ static enum lru_status deferred_split_isolate(st=
ruct list_head *item,
>>  	struct folio *folio =3D container_of(item, struct folio, _deferred_lis=
t);
>>  	struct list_head *freeable =3D cb_arg;
>> =20
>> -	if (folio_try_get(folio)) {
>> -		list_lru_isolate_move(lru, item, freeable);
>> -		return LRU_REMOVED;
>> -	}
>> +	/* Lost race to folio_put() or the folio is under folio_ref_freeze() *=
/
>> +	if (!folio_try_get(folio))
>> +		return LRU_SKIP;
>
> I think we might have a problem here for ZONE_DEVICE folios?

For coherent ZONE_DEVICE folios, yes. IIRC, private ZONE_DEVICE folios
are not added to deferred split queue.
>
> This assumes the final put always dequeues the folio, but ZONE_DEVICE fol=
ios
> bypass the generic folio_unqueue_deferred_split() path.
> With memcg disabled, this can leave a recycled folio linked on the
> deferred-split list?
>
> Should we dequeue folios in free_zone_device_folio()?

I think so, before mem_cgroup_uncharge().

But it is a pre-existing issue. We need a separate patch unqueuing
folios in free_zone_device_folio() to fix commit a30b48bf1b24
("mm/migrate_device: implement THP migration of zone device pages").

>> =20
>> -	/*
>> -	 * We lost race with folio_put(). Read folio state before the
>> -	 * isolate: folio_unqueue_deferred_split() checks list_empty()
>> -	 * locklessly, so once removed the folio can be freed any time.
>> -	 */
>> -	if (folio_test_partially_mapped(folio)) {
>> -		folio_clear_partially_mapped(folio);
>> -		mod_mthp_stat(folio_order(folio),
>> -			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> -	}
>> -	list_lru_isolate(lru, item);
>> +	list_lru_isolate_move(lru, item, freeable);
>>  	return LRU_REMOVED;
>>  }
>> =20
>> --=20
>> 2.54.0
>>=20
>>=20



--=20
Best Regards,
Yan, Zi


