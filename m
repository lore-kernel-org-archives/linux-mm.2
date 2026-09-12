Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5175CC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 13:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387BE6B0088; Sat, 12 Sep 2026 09:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338A06B008C; Sat, 12 Sep 2026 09:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC216B0092; Sat, 12 Sep 2026 09:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE9B36B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 09:50:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4ACFC04A2
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:50:39 +0000 (UTC)
X-FDA: 85205245398.03.10B06D6
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF559A0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:50:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ML4vNmWL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789221037;
	b=Sgpr9NNGc49klQMnawPUEiyqTdwMi1zBqlRf5h6ImP+6aHKSLi8A6cSt0jfoOs/kYwickJ
	qfifxsdWSt8FJceN/jCtPnsCNS3ZeZay4XSmkAkYLJM0HtBVsSe/ZH04r6xd+oxIqagf0y
	Uvw1FKffVTR8udQ1pkEw7EuLrd62AMM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ML4vNmWL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789221037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7psj59Ddh0wXvMbbp2x9Uu0gzyw1fPASUFWtAHU3zJs=;
	b=BfKuJRUT0T/2tjx8rdmH4QrgZkGG4bmOAZpKUKHMRnIv8Ef6KZBniPZyZA8RCBgAx0KHGz
	NDhjhEkCNDlJam1kEPAfDmc5v6X5CiVtZVAVk8kPoI1s63941KU1pZnI+CEbZC7YG46KzO
	GZShGQviIf9xmLTpnV/Fu794r87zggk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ceFdth1nnCRgeqdLMOi7MjvA53NzbbxXDsPDMt1eEQ0kQOHa0xY1OkHNtPTctcWaNXIiY8v3uZiN5CU8WTzp38IPKq2D7j+rxJqJUNfUlj+h6hSnAZi9H+YZuNsYkJJh80O4SzPnbE89gdrshl9TyCpyi2Ag2AKyHUI6WozqFts3C4PW7GYh/KsU1rsGDUxJeeXc/fvlsDI3qT1FB3GYy4oD2MV9PsXKhQRCDuYEL9x0Vu54ca2Tq1tgzEFiZy1X84vkVf6VVBqskkZNaq+D5UCI/Kx3VL+WlWRW7E1bXRXn3HouiYOPb2Yoptyxf2EjCdMPvZP+2wD5nyWDOM/k0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7psj59Ddh0wXvMbbp2x9Uu0gzyw1fPASUFWtAHU3zJs=;
 b=nVE2LFT7THL8cMV4rXAqOOAhkPcCvtTnA4PnyEF+bXOfbGYS4DZaQ4VH+CIVUB5AO+C5IyZ6uaQR3y5vsYBwAc1uxD6/HmTwfN1brHz4U0Eqr5hiIPcvfzTYDT8uZ3aQyT3xiByZt5QXTyTldOnJ80AnhiEIOqiFq+z+56YgaSwyXjd3T6ekgai/mhP7TmFewzaSbRgDxlktwmbWcWTUmHt6Hzz/XuXLfe1UyyzeV9U8H5LFF7/KBMZailK5+KF+1egkTuv7bLSOZox8998RT8wEySCSmQjUc99jZh3BNHK5mpQVdf+fiL15zas6WoMGnJuluCCKfvEMIf/qqr0KlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7psj59Ddh0wXvMbbp2x9Uu0gzyw1fPASUFWtAHU3zJs=;
 b=ML4vNmWLGF650tnQ9Uhnanw/F3xOHHwPOrMydavNcNVq3Z2F1ZrLo6Ew5b4o6e5NiNosOD6iwnkMGKGH0M5N7iO3TwDYTowFlnUvI+qTC4rpVH3U+tzbH+plS4tMbxCZQUoXRr/T30KH7xWdUoLeCvcYlKe97C3ugN9gd1tAPM6haew6OELoKgpGk5QsVeNQXR1i9yuAZv6pBXeGEIS5m3UwB9cNzE9OiSMZBcPdTPnLDqmngQUFVIl80lqp0OIYAIMrKhxUFzCJ8GspaJJ9SsmG+c7mKS43dTezCjn47JwuS+5+3VtFVYe3jOp79OfEVnKK9g5WEmgCMtxVfm7J4Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Sat, 12 Sep
 2026 13:50:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 13:50:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 12 Sep 2026 09:50:30 -0400
Message-Id: <DLDDX69VL9OU.28J2AG7DBDTKR@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/mempolicy: use vm_normal_folio_pmd() in
 queue_folios_pmd()
Cc: <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
 <akpm@linux-foundation.org>, <liam@infradead.org>, <ljs@kernel.org>,
 <david@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
 <peterx@redhat.com>, <jgg@ziepe.ca>, "sashiko-bot"
 <sashiko-bot@kernel.org>, <stable@vger.kernel.org>
To: "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20260912034833.2952750-1-gourry@gourry.net>
 <20260912034833.2952750-2-gourry@gourry.net>
In-Reply-To: <20260912034833.2952750-2-gourry@gourry.net>
X-ClientProxiedBy: BL1PR13CA0241.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: d2dbdff5-0719-4903-f666-08df10d4cfae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	yb983GzjPo3zi1P+MmdebiAlEOUOOZFN3NuT7wDAFD7haU2MRbzhk2yPOAlc7UaC01RukWIAZFTm7OqBB2hAhEcG6ExYu74X87vSvChMilAWlVxoqfZjXUzARWACRNuRGOEMhqTM0+jEYUgXdIE+z88z1LP+XxH3ILRTtNrjDI9FutWsx6sAKHAtLsRdJuWklvi3X3oepw0Sgpziupiv3fwoNUYA9dD9H5LCmeoaYz7/+T6NLreuKpAA5g0z8OrEU86X1lyhMHqSPUBptduQ6vh6jerpitzfPjU+yvX2JiV8RRyFV7hztGrsIsVJvTsAK6V4rDLgwtKcQPqjVvpy+3+8CTDWn3xn1MPghKezV3vnAlX2IG24Qxy38PuyygmwGUXMmBB3YJhuWw99VEvidoQO/KcBOP7Q9ofNaIMbm+aQF05oC/4xFBGPwh9ipezbTS8enu+IOpXRR70vlSL3vzu5hMeI913zBieSBCjWw/sf8dXvMJSY3HQUd9WsKLZMrn04+II6ZrS3n0WDzWqZKgnpPQF6rY6qX2yxfpmueyhgeyoiPS+fjoswYjpbgeAy9jK/Bf0wTiByJcBcM6QDE/SrICw/xDrtbpue6hPuSANH26KQMM8Q/Hzs2DMitmOi2AyjoIPlbLWtsghj6X1S5f8jvWzqu26/Kz1qr/yFpEI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V01jTnJCVGovbXpMc3RuZmNSYzJCRm1GOUVCWURsbEc2NHJCZHdZQ0xsVjJ0?=
 =?utf-8?B?WTV6eU1jcTlrSDZEeTRmVUZNUnVNZ3hTM1hBdXM5YmhzU3BRQlBjZ3BvcjBs?=
 =?utf-8?B?U1hQbXpMQmJLbjE2dEl4b1QwTTRRbEFvT3NlMlNFaUpmN0E3S1VTVVJrUnRK?=
 =?utf-8?B?UnNjNy82YkhZcGUrSnpyajVSQ3dFaXNWSjU5U3hDSzcwM25SRzdQcFFvNlUv?=
 =?utf-8?B?aVRxKzNxV1h3YXRkRjQ2amNjWVJ3WnlwY09ZSDc1Sk1OemkrTzlXUERlUXN4?=
 =?utf-8?B?WFFzUWN1c0JxdGRBTCthNDRSbzEyNHp2UTRrMVJ4RGs1cFdvVmlHVlBOS0pI?=
 =?utf-8?B?TlVFOUtMYUp2VUI1S0xieUVXSk1ZVGJSV09CR1dud3JrOXU2WDM4TWNRTVVY?=
 =?utf-8?B?T0x1NVhIU3JOQTBYSXRGUXFEQVhBTTkrdnpjbFVFai9PbTZzRGpYRHQwS2xn?=
 =?utf-8?B?TXNxdzhwZDZxeGxHbXpMZXh4WE1zVnlzdktjT1JQa0ViQjQzM3d4bWxCbStV?=
 =?utf-8?B?NGt6WitiM20zK2xXSFd0TFQ4aEJyN05pS1I1SkpncXpKNlFLYnBmNDBpcmZQ?=
 =?utf-8?B?VkpKVi9UbjhzeUxNcHNBMzJ0SUtsdTFNYzRPOHM1cVpoSmlJZnpaQ25mTVlX?=
 =?utf-8?B?OGhLbWswZUk3MFJtaDBmeVpZdUZzcGYvSFMwcnZObzdsQWpLajhneUhFVk9h?=
 =?utf-8?B?amNhUmdoaUlEQVp2UHZpTEV1WjJUNExZT2tINUVVNnpPdHRtamxDOHBRRFI0?=
 =?utf-8?B?a2tDS01uZVluZmM3M1c0Wjl3ZEswQjc0cWMyeGQ0VG1Udkx5TFUwYmhpRlJv?=
 =?utf-8?B?TXJMcGlZdXMrRE9qRjhYN2taeC96dkhZRkZjTzNJc2hDNU9TTUtDMy9XRFVn?=
 =?utf-8?B?b1ZMS205bUFldXFRT0dRMFRzbDQ3UzhwYitZNVVwUzh5VWwzSGF3WVRxaVh2?=
 =?utf-8?B?a0xoVSsrVXZVelIwYmZOWUJhN1hnN1VMOTMxalpMdkt2SDh3WU93MVU4TDlY?=
 =?utf-8?B?N2R2WFAxcDRWbXZObE9WTDAvZ0paUHlycFJjZWErUFJlV3lXQVRpZGV1b3hh?=
 =?utf-8?B?UVdiVGNKV3BVLzZqUVVLdXE3em5XY3FxNEhvaStFQmE0RGMzYndoLzF6RlJa?=
 =?utf-8?B?eCswZnVYb09ManRyM2dpd2lHN0RKd05ZekZTNHMxL3BDUGNoak5rbXBMQmk3?=
 =?utf-8?B?V05LZXJnc0x2UEEvZTloUlUvN2cwNkMrZmFFZHJQemRHUFpvQU93b21EaWFQ?=
 =?utf-8?B?Tm15ZlloTDNMb1J5aEM2MEhsaW5MdjdobUJ2T01semhwSlpkUmt4MUg1TlBJ?=
 =?utf-8?B?VXNhRFB6blJPcmpjY2NQZlgyb3FYTzQ0dWxEczJyYys2RDhWcUJ4Q3lrOHJq?=
 =?utf-8?B?dXczd0FUZGtINGUrSlY0NUNOdTJ2M01aK1hiV1d5VXR2ZjN6TFI4WDV2TGtK?=
 =?utf-8?B?bjB2UnFZUDEydVdDZDNuZitnejVaNUpQRlE3MllVMGIvemdKV2RnMDh0b25Q?=
 =?utf-8?B?OGJHcnRFR1FHaktlWEovOEZsS24xaWkwbkIwOXE2Z1pncE5paWxKNGFINmZZ?=
 =?utf-8?B?dDFPV1g3eUQ5QWdtNjlra2MxWTg5NjE0SEZFb1BSSXRDMWczc1hqVStRdkox?=
 =?utf-8?B?QnZDTEpJUmNXMGQwLzlmaDBoSC9sTXJWZHpWdWY4RzlhZHBzRnlOcVFzTFhs?=
 =?utf-8?B?bTB0VFl1aFMwL3pxR3h0QnNjNnd0dGI0NWsxYjhEc1ppVnYvVlQ3U01ESFNM?=
 =?utf-8?B?cjhRdXhKYVRYTFJONFZ5RDBMSDFHRDliZUQvQy9jem84dE1aNnlSUmo0TW1j?=
 =?utf-8?B?VzJKbDBhUEo1VGJJZzREa3FLZ1duRmhLRWJ2TXB6cDN2UUJYelRkRlFzNmhU?=
 =?utf-8?B?eFdOVXo0TUsxT0lwYldGQXpMSEJGYmJCeFgrYUZzbzlVT1J6Tko0dXhlbXNj?=
 =?utf-8?B?cGxKcklvRjF6Z29Ya05vZzFZbGZnTVRMeUhlTzZwYUN6QU1QcHBMYThXczFS?=
 =?utf-8?B?RTdjZVV5OGZBMm1NcHlDQzIrdGFhb1BSTHZnaCszRkVyVHhqOTQrWU1LVmRW?=
 =?utf-8?B?NmVmYmx1NGFYY0dzWE9sVGFJYndMRHlveUs1bTR6MGJIT3VZV0IxZHpCSGN1?=
 =?utf-8?B?RTBiRGNaeG50L3FPYVpCWkFTZ2d0Y2JMTXVvZWpONmRHNzN0VXpvM25KVUFK?=
 =?utf-8?B?NGZTcGFvSjdtN0hWa1A4RjVCbllwMkRuTzRRT2U4NXZ4ZEtmTFVCY1FneHJj?=
 =?utf-8?B?SDU5RlJHZFh1akVabnRnWEpxMTAvbmczZHhYQ0tBdlJ3dEtNMjdVVzBSakdD?=
 =?utf-8?Q?0nChp8fWJtVKjQui2h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2dbdff5-0719-4903-f666-08df10d4cfae
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 13:50:31.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TOSG6Mq+VIM031yRcApr5Kl3BqpkpWLAc4MsSeH+rLi8SE8biJ/hNL8sK1lFC3vQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EF559A0004
X-Stat-Signature: y94813etp3cgao7mkr5ioqep1a1xm5uw
X-HE-Tag: 1789221036-255039
X-HE-Meta: U2FsdGVkX19k6XsrOlePN8TBms6k9yTkrc7r2GuF7HM1hNQovrxB4ybYhw1ciEcDUvOcQTbr+8BBLdl4WhKTWD8QaV91TixbhcSd3rR5gTXHj/jySsQipEzIAjGe7dJdnNRzovCVQOaK3yfJhC45OKHQvc5puC6sTPsmYBLRGbdcaAbRP6gvOOjf0ZZkrXV/i6ywFCVpofuyJFuTJfxGhtdpHWPlDthx4vzf4Cx9a9kKKz0Z2yWcpkToe103Ojabw6hL2zETHBC5id/rIe0qWkibG7QEssWLYx9D+8j9g1SEiQYCbgHvT5PkVhzhRDV6/2QdCR4V5LmqIw6Tq2fkAovIpsG18qHNO7hOkH95qIOEVt4HMX26KwYgIra6QNMTmmsyV7TMEKdlCAOw/Wul96cl++e8v+9o0w7+ejHuyEejbywY8SrqXnE2lL1K5Bq7eRoXdcoULtg87kyr4vxPoqwlucBZqGdzWO8dwXPMDdGbG6r01AR9G7z9pANhzLesi0Q1/FYc4iEYJeSReYz9qvcp8qF3tzLEel3lmNIoXk/wlO5uy+jdO4LXFngzamq//TeuqgBRPZGKffmzh4EaclAhrER5OBnw2SpF4wlIIR+hpWa1AFmUcnzvtxuQqrxifJAXsMEUO9E3MdTrquSNE6PV9HqDjB0deEILnJEjAefBBAVnN7PSNpTbB7E+x1Lkl23DV+4rU3OGSDYE1upB8VogOQgS75IwaMzhVftwc4/kz4dKBPzN1iUF5WUk6NLnPbtcvIwF2ZT+QGzbRfwnYhpEHGKsSZBYfN4dV1CsR0chLJZ5cyWw70Ja1d2MVF/UGbnKAHJV7gREvyt2JR1tq7B3ffupm1/FK3WyP2duKYE9NslFEA0Tt1AHDMzruT5EuVuGP/QunIqcs3OTma21U6AF1GqMdBiGkfOdJ/KzhsQ6WRFuDq1ikmlAWNmUd6fzFPcxq8C0wEfh0R8Gqwe
 qL6cusXB
 5NdrGZcfSupFtv+YNNwbUOutuVn0d/clSq+UWofkW3cY0MLOyoKb/1buQbX3bWtSmkWrgHMYumQf3z0yP52+oTFd9hCUfnTml5EzuIUvNpQCA47HhBI3z+XP9159WcfVq21dNgYdhpEOLS8DlL+KO8QH2HQ40BZ1dPo76Njr+s1tzcCC6i0Ch/S8bYDZ4wDkCEJbgs9ZEtBiH+Ztr+H5ppIwJB0GGPRQkFjblTrq/AafZ26yDw8LxNheYfrisOpBEE1AeDiId2YQy94ctvVaxCPNF64oMgAoWHl4ZfsAHxkDjNi3ykSuQHfX/e3Tg+epjAWVv9JbH5X9S8qeefXyBrqMX0MyHtqtZzeavbi+GOCpIrETfba6YAZzNGZLGFBaFZ7Hg3V0U25mU3joOlVXGreD7vHjdMU3RTaHQhjIn5P7Gmtt3d8JlDe8nUMo6KHxUG8yzS/KNWZQF8k0uYqcqby1+BtoOD59KcUNaSwZtCVhbZl1DxK5fo6+RuEt/KajORwchYZM4cD6B1Sr1tDaWAw9W6OvwjqNQ+Ek3RQjWIxoTeJSOGb+8NjeNtQkRHa0wOlmXP5lNYg63+hRZcb1QxshGn7QNO6nPhlj1P5jseQ/QBBOeMMp37c2crtDqL5JDyPBn3NX1EkRsLk7VLYDfgByLdesPm4oYclLP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 11, 2026 at 11:48 PM EDT, Gregory Price wrote:
> mmap a VM_PFNMAP region whose ->huge_fault installs a PMD through
> vmf_insert_pfn_pmd() - a vfio-pci MMIO BAR does this - then
>
> 	mbind(p, len, MPOL_BIND, &mask, maxnode, MPOL_MF_STRICT);
>
> With a stand-in module for the driver:
>
>   BUG: unable to handle page fault for address: fffff96dc0000008
>   RIP: 0010:queue_folios_pte_range+0xaf/0x440
>    walk_pgd_range+0x52b/0xaf0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_mm_unsafe+0x193/0x230
>    queue_pages_range+0x64/0xa0
>    do_mbind+0x25e/0x640
>
> queue_folios_pmd(), inlined above, calls pmd_folio() on that PMD.  The pf=
n
> is raw MMIO with no memmap entry, so the folio lands in unpopulated
> vmemmap.  Neither guard stops the walk:
>
>   walk_page_test()         skips VM_PFNMAP, but queue_pages_walk_ops
>                            supplies ->test_walk, so it never runs
>   queue_pages_test_walk()  honours vma_migratable(), but only while
>                            MPOL_MF_STRICT is clear
>
> A VM_MIXEDMAP vma needs neither flag, being vma_migratable(), so plain
> mbind(MPOL_MF_MOVE) reaches this too - and there the bad folio carries on
> into migrate_folio_add() and folio_isolate_lru().  mshv_vtl_low is such a
> mapping.
>
> Use vm_normal_folio_pmd() and skip on NULL, as the PTE loop in
> queue_folios_pte_range() already does with vm_normal_folio().  On the NUL=
L
> path, retain ACTION_CONTINUE handling for the huge zero PMD.
>
> mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
> rather than -EIO.  The PTE loop already returned 0 there.
>
> Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when in=
ject")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40=
gourry.net
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/mempolicy.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


