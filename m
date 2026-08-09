Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A01C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6386B00FA; Sat,  8 Aug 2026 22:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3670B6B00FB; Sat,  8 Aug 2026 22:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256236B00FC; Sat,  8 Aug 2026 22:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D13956B00FA
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:41:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E4B1404A4
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:41:41 +0000 (UTC)
X-FDA: 85080180402.25.396EE60
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 574F8C0007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:41:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xc3pyCHz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786243298;
	b=zF8Vx1WQ/Z0Ru0/M4ZH+ahcR1VCz2okDvOFFkcpE8G+QKOE8iAoVS/DJIlmVn2MMmnc8sI
	J3OkqJo6D27FPc+e2rX5wSVAhY7vz71jAywXU3fra+Xg0ZXASIhkAgRgUeaPo8aG7806WI
	uqKksmmoBiuByBLwXavUCuf7NgN1K+4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Xc3pyCHz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786243298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syRqH7beQ1uqBDuRrLz2gK1IdgSiaoLSwG1J/trzBEY=;
	b=gVqOPeV0M3nyZHCkOnxCs+Ype7sow33DkwmGrqdQCL6gbeR8L7AAALtKoxMaCYTNhLlf5h
	tHYDZQYR04fvPm9dr/425Cp9tFxBUoWUwLEOoXTwgkN+sBy2ay90+oYS7TGOq3L37TuN03
	e1tkF6Y5Qi4SHwx2NN9YiJcVYmBulw8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m74hdS3M/ZWcLv5LhINQMx7dsurnuD0fos0Kltuaeja203xpCdXkY+8tDbX/HTMo2YzswR4EWHjvGrepA430aJ/pk+ELbPbkIDcHjBtkUGvZC2D2EKkdALUg+hLIF9gnzUwxB78y2x6oZhQDJSVvwLE/hvzY20QpT8+VQt8TfAEhnj4n/0r0PvxPM6FZDO0BEsXEpf3dWHk8qA5ni1hpYpPaPCCQB+5eHZQL4f2y5Sp9oBtlOzqYGnQZmTob9CPGf9YKyzmOdlko2t3PZVscBWQYKjA25IQRUZKlwx4Z4OrhX2Eu7h09Z8P57w8rsWFz5q02aWYMomaEIs4NGtszLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syRqH7beQ1uqBDuRrLz2gK1IdgSiaoLSwG1J/trzBEY=;
 b=NwIm4JYrCb789/ue3ZUEC3evBCrKx+HtTibV1pxwUzTAo5MFj1DrBaPeRkUAaGIc8ZjPl7mUc+iXSgrthoXI90v30B6Cs4s9cBME5kmJjfKtK30BfOYnDSUQlcFgVTkPOABOPzU5aJyI98xNo81kDraacHMqeF/oss3R5CPt0QWB/SRefv8us+wjzRKHwO42FrQ/y2HGsjSKzFMLb14pQY0j17pZtSBtnA2ml8LT3wHDOyye6f5gpOWKv04NJ/4TzuyQqJKVEkebHJc/k50onAg+uQNdJhlxNRG9dIr45Pn0YA+u5a9uR1gcGsYREY7ggfrZPIsrFoloJLEBg1h0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syRqH7beQ1uqBDuRrLz2gK1IdgSiaoLSwG1J/trzBEY=;
 b=Xc3pyCHzz7SEK2/WRUp5psEOvFl1LcKMcpBJwjGnBiYh8AZ2PdkjLewKmJ5nKLmUZvx05cetWVgQRiBn2S6ZCWNl5aT810K+0+JqUU55Rzf1C4lebdgLVJQ/UCduOqL34eDB7eXe3YmyF+eYW+FtjbDpxEDMS9TdoDIBaz6cf45A90Uqa1LZ5gTLhL+bpWP+UQtLohpnIWkmqHmHCDpT4xKRa2OQQkP6U/ogUrTVRUPb5H+tQqCqIGut8VXJBS9azj9PePzlTdBAQtbs49hTpB0y7+YnVzuye0NdWD7qpqf/VRZznyB62BRaw9qmKGFr7L/Ui04rNkuYIgxptn56+g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6648.namprd12.prod.outlook.com (2603:10b6:930:3e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sun, 9 Aug
 2026 02:41:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:41:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:41:31 -0400
Message-Id: <DKK2EFSYRHHT.39SVL8IAQ4HQ1@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 11/13] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-11-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-11-689939a7ccc3@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0222.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d7436ca-0396-4752-3f83-08def5bfb99d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YQpcVDeT9ZppicBVnWBYzdvUOGFpR9ROgqfskgfXK80p3uXN7LVc1Qj8OSn3fYZ981NcAiFybMRdYENAJwuRv6/HIHlwJE4D7KnDicxi6rzJRQ7O58pKo3cCBCVNwGyMcdYPGQWcI/fyt3MCaoPn6vBr5UhAKojPZnNBkUeTfKwrotDhthP87IRAWsx1FKeOKohOFIDrGNM5LLaFzmcFP/NSDyq4SXNULEccnvahK3mxWjuq4Cb3V7XGKM51GSLLO2erEtxv+nkaJTD1yOGivHWke688pYocdP7g1vud4CljHZMlc7MXiZBMQXAXFtp/Ar5qiAWncCB20viR5lvbESzNGXe3WnBW5rxDf9weYKfuH0HHjcIP+BgdltzqyjIKwlyOCRlaKCKJuEo264Q159A4O6szE6THRWb/TGmuzdy/9y/4sRpZ+85Ti/+kM3ZcQ0nfYh8YU6rCSuzIxYkqm/6WIlaI5BftH8AjmTejA8yLIjNz0esVUpmt8bsx9W4QYKJ4nG+WHsmQ15Bi15SNtSaNA+aPgd5cJjHEH0TsbD6+ksuO6TKI5hA/uKA5X+Cntj9SMsvwl/WyMyDpSE32Nc1qhrqz+GXt1/hSkuVEvbugrTxPoSccMwQt8i+yrE/SIYXtZpKKEngwgnbKPLDfYXpeamCQ0lp+69WengfvOqU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFAxT2NwVDBGTllVV0RBRkJBaEIxZ1JIdEpmKzlFSlFwdFNsMUtNQS9OeDRP?=
 =?utf-8?B?eEx5NldBY0p2U3pERkJHT3dBVFU3Rk1HQ3RuY1d0SEl2dERtVzFXaUhNYUtF?=
 =?utf-8?B?eXdIWE5Jc2xnUTZwWGVHV3JVR0xCMUZKSklEZWU5cm16VXVTanp5cnNZTytO?=
 =?utf-8?B?d01XSmxUck1pN2JWbTBBQ2IyanhzZGV6cWFBQjZXaVpJZExXdCtjZkZVZ3pD?=
 =?utf-8?B?eFRrbjh3QmVBaTNsdnNkeUVpNFcyU3lTaldPbG5Icktyb2p1ME9BWXlVLzRS?=
 =?utf-8?B?dDBuS2pyWjM0M21jYk5BRnRsWVZuTWxGMFZqRkd6cTVKd0NubFE2VTBPMGhX?=
 =?utf-8?B?T2UwSHNRYzZxUXF3Rm9SbmFIU1ZrUm1URlNKdEwybWY4aFFaYjBtNEsrTSta?=
 =?utf-8?B?SjlPRFo3WEszcXVneUJFbHl3MjA2aDNYUVRRcCs3NmZISTg3c1p1dVV6QkF6?=
 =?utf-8?B?cC9Pay9nYUdtQ0JyVlY0OXN1M2ZSSzRzOG1hQVF6RWJ6eGZqNms4TUhtYUxV?=
 =?utf-8?B?Yk94d1B4ZlF2U1l0RmhXR3QyelVpUU1JVXA2VkVRZ1lJdDRYMG1YNUN2UHRO?=
 =?utf-8?B?bkdHb0oraWpXdC9NQUhzRzE0OStjZ2Y0Nnlyd0tpZTd3WHRWZ2pMZ1pDN0hn?=
 =?utf-8?B?elo5NGVNOU5IckQwM0VXMy8rbHpPM0NMK0FRMFNiYVJ3b05PZkQ3RjN5ZDBa?=
 =?utf-8?B?Y211RHJVZStsOTU5MmRpUG1QTFhla2dYMy9lUHM3cnJLOG5yMWxKMkxpK1BL?=
 =?utf-8?B?OVNCT0Y1bGxYdVZYU2NJcThIb25IeUN6ZkQvMXZUdkN4WWhmQW9UdkVxaHBa?=
 =?utf-8?B?K0p1bTM0NVlIcW9hdTJjejIyRUZ6VzMxUzY2emNnMUdCSXY0NEtOZGQySlJZ?=
 =?utf-8?B?UmxVKzRHUUlrZUY5clpmS2dtdmVzcVFOTGh2TmFlK3lwc0NYc0I5TkNaTkZR?=
 =?utf-8?B?NmExd3lPOEoya2d6bzZ3STBxaDU2WDRrQ3BMRGxVZzUzczV6L1ZYMWx6L2Np?=
 =?utf-8?B?aDFVYmVlS0tUR1FEeXo0OXBsaVMyaHFVWmZZNUEvc0RoaVovRGNabStxelha?=
 =?utf-8?B?ZWtQVk5oN3I5dHhNV3VoN3M1Y2NpQXNDNkkvSnl5c25wSUQzOTgvTjZuMmZx?=
 =?utf-8?B?Uk9TSG4xTGtmRUlKYTRaM2hjaUtzZUk2MkZ4U1RHMm5FazQ4Z3FxZWU5c25w?=
 =?utf-8?B?T1V1T2JWNHdCSnBEWUsvTXFkMlVmZTFXMjY4U05LQW9iODJISlE1OGdtUkJK?=
 =?utf-8?B?WXJXOWNHK1AxQTJMZWFzK0dOM0ZlNEZINHd6RTF6eXdNeStLU2JwNVVic0dW?=
 =?utf-8?B?K09jL1o2RmtTb3YyalpKMVIraExhSHhSYml5S3dzdjRBa3VibXVObjJQUS9q?=
 =?utf-8?B?cHBYVU90TGhHcTJGK2N6RWd4Ly9xd0QwUjhOZHd2a0toREZDT2h2eWhhbmM5?=
 =?utf-8?B?d1ZlWk8wa3dlVjE2Nk9ObmNFSjh0dE5oQUZXMDhlNEdzaUx5UWpkc0NxT0Rm?=
 =?utf-8?B?QkRMQWhUdjF0K2FOcVFra2pOYmJ6OGNCUkUvZFZOdllrOEo2RmxDVExQemFH?=
 =?utf-8?B?MkV5V0ZHcDFDcExWVklhT3BYcVlCR2pQdnBSQ2RKOE9BOEdYMDZPRnB6a2Fn?=
 =?utf-8?B?ay8rdkdlVXA3bXZvaE9qVkRhdUFnc0RobFdBNnVHQVR3dnl5dk5lVW5FS05u?=
 =?utf-8?B?N2VIU3o0a0JOVEVPQ2g2R1MyaDNQQXN2N0VkOHEzSnh2UEJkSGZzenJtblZa?=
 =?utf-8?B?dXFQTnhtZmh1NFdJd1ZuUng2SWxYbytubWVKeEI3VnRMV29ZWWFVQVpDSTkz?=
 =?utf-8?B?V3dpdXh6cW9YYlRMb2FGKzRwNCs5c1JwVWNGeVREUjFVUUloWGFhY2F3eXFJ?=
 =?utf-8?B?T0U5VndxeGhzZnhhZWNqOVNLWm12bDBPTTV1ZjVMUit2WS9CYkVOdklaK243?=
 =?utf-8?B?M0tBOWIzQVRtcE1iQm05ai9LaXljczVrb3Ztelk2UHozYjIwSWc1TU80cEoz?=
 =?utf-8?B?bUFYd2FHZEthNHlSMFdLWGNraUQrbElyUDhNWWhSVC9VMmM3b1lDYVpIMHIy?=
 =?utf-8?B?UDI5ZFFwMGdCUUtrNnY3WjRJK1V5U3FZdDNpV09RVGpFZ3JGTXdCaUhJTE1Q?=
 =?utf-8?B?WDcrMHpXd2pUdFVnR0pEakFVanNEbUk0dFFoZTRUZnh2czEzM2wyUGUwd2hZ?=
 =?utf-8?B?MnRCZmRiaythSnpRcDJHUXVMRUpHN09FYmhMNHVmUm9nRjZpN2NOWm84M3cz?=
 =?utf-8?B?UFFXN0h6SWh1bENSbUJJejRaNm1RUnMvOXdQV0ZzVjZsZXhTMTllZ2VYRGZo?=
 =?utf-8?Q?vann2rxRnV7ZT1XaAy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7436ca-0396-4752-3f83-08def5bfb99d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:41:33.5759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nm/EIXfL3dk9NW9kiOy1LF1qkgQFq+UqEJtu4Q/j6fSGG/VvF14cqHVzzprJf4Vb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6648
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 574F8C0007
X-Stat-Signature: 95jde6wpna9qp66i7t4h99xbaa3wot4c
X-Rspam-User: 
X-HE-Tag: 1786243298-788853
X-HE-Meta: U2FsdGVkX1+N2tHeeOfpursvgmkwhAp/F/qSzaqbYYC4fs2tGUGHrO+XqDECCcCGd57Dq+Cn5KABs0g36THBUVEjSrmMUVtvbTbiQUP4BCdgse6/Ex1nwDr20G3LG8ZxlNu2yN0252YQN6vb2i7JeMS7UC6cJXAZEOsR3leu+nOpaL07VzEZxD18NtGevM0mZngRbNSF/e0ivnd3YqYoSr4x8cK74KXPcwxKoXkTB7H0ltPXTtjQjaU8bHQla1GJNSGFdWuhst3IsrVHFfTdiueYoy+e71KsRiyDVYEsTo377ggBnWmpBIUMeXFhL1EbOFWkaaw0sR6IzBmfRlIMuRMjAtFN6GOkYpFtyb8L13CMPQZwWzjIqa00kIRC9rQC9hetcFoPOLxaGbR4fXo/+9hBbRHgBSmhMvV0y4gQ8Puw35afMj3r7fGsU346t8Sz12mHBOMUbwRuWYhE7F+5CG3ke+Ctqv4YCKQwUOvjI14xakDoVcraI+8sOyiuZqqxU0cL0GJnacJCpvnTnxiBP6I70P9Lz740R1UvhxpwKt0GQ0J2wE0RnnxS8J4J879owhS+40KY8kObc0xMhgLGTwuEhNNtpBDUEdyNaybyHDoP1idIeojvjFel5SCjm9GwESMKSXSQGldB/L+IWS86AKV41/v0JrYW0EXW2yW3j75Y6dEYevCtrMgacT1hWQqcFmE13TZ3K2w7bU8OdVJogzHusT6iURzCSjabOGw8UUikVgDaP5NRqZLSpBA6K1IrAy/2jV2Q/0V5Pum1481Q8s+il+AHf9Na6TJr+lsfwJAkA1bBasBYcwr4aboFaMckTmHR+CuKjq0yEpo4eJlAqH/Ra9XZeYm61RwldHKb7gD2oAbQPXow9axK/PwGt+aRvYyE9IBBX7EH/+rpfIZR6J2On64GJ9hfiv6KQC6RcDDL97DlDgH/gpFopxJtYKofOOqEZTR37ji2NmBs3tx
 2BQNa+UQ
 y8znyYmiJKfzR2dwer/YBAdD3HtdcHhrx+h25D0ViFt9vWSF+FFxsJZSA7bnxhwChirDM/Uu0tZXOR9GHuDashp6Ca5lZ3iVuIiRXqP1PMZx2IKi0lB1P3YDLbTpQ3kl5b2gA3F5OKBra6Rz8kXYN/qwmLvJyWM161kEE5zJ0aEOkrZcaRTQcYm4v0KOoIAfV0EdH9x6KRGGb37a4X9g8fnkYC7l0NjEOOEkNmt+Fjbu5xgBy7aBIq63VazdGsUxjQXfjAmtFh+5+HiqriQmjarBDMpdvgYW1uUWJ6VjSKj8kxuQNlQVZMjwOYCmOhOlTM440jUKzczBnPt9J0NrdtGiu/8JzmGD7+2c0j1trPjoyYjfgEqNrwfX3/G4cBO5hbpxH7+yoFmLREc79WrjOoGbDTtdSeHbKn3kLoldy399Jd25J7+sIniSCvI4BqT8XAdPtZRu7RXbLNNe5nU3tVPwqzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
> and folio_put() in the after-split loop.  free_folio_and_swap_cache()
> unlocks the folio, then free_swap_cache() must trylock it again and
> re-check folio_mapped() before freeing the swap cache entries; if the
> trylock loses a race, the entries are left behind even though the folio
> reference is dropped.  The sub folios are still locked and unmapped
> here, so just directly call folio_free_swap() directly under the lock,
> unlock and drop the reference.  This makes the swap cache freeing
> deterministic and the reference drop explicit.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b80d0db63225..39c91c8e5bc8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4304,14 +4304,16 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  		if (new_folio =3D=3D page_folio(lock_at))
>  			continue;
> =20
> -		folio_unlock(new_folio);
>  		/*
>  		 * Subpages whose mapping has been zapped may be freed
>  		 * earlier, but freeing them requires taking the
>  		 * lru_lock, so we defer put_page() on tail pages until
>  		 * after the split completes.

this comment needs some love.

>  		 */
> -		free_folio_and_swap_cache(new_folio);
> +		if (is_swapcache)
> +			folio_free_swap(new_folio);
> +		folio_unlock(new_folio);
> +		folio_put(new_folio);
>  	}
> =20
>  out:

folio_split_unmaped()'s comment still refers to
free_folio_and_swap_cache().

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


