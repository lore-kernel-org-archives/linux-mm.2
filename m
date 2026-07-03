Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC67C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8326A6B00E5; Fri,  3 Jul 2026 09:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3166B00E8; Fri,  3 Jul 2026 09:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA756B00E9; Fri,  3 Jul 2026 09:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 380766B00E5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:48:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A70A012015F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:07 +0000 (UTC)
X-FDA: 84947594214.24.3B48501
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6B3910000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:48:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eklyQHG4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783086484;
	b=VDsiY/fXjbgguoaM27oWlwgzi+qO0cNBSUlcCFJT9WCT6DhTfQ/Wiadr5+yuba19aX0Lns
	680N56bNt92kiTc4drECz0L1k0Wn7ioGoCZ/qIUQ3XP9kQwLHOXUGTOE7pjm6QWT2irbHf
	JTI8LZ9pegHW39FhhmuQmEmqA10qfT4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fa3DcBB3/5RcietCD79QSRND8W19FCh6Mva01B6vKz0=;
	b=Cx2Y8/+rfPatiE73O7yTIZ/aKc3TUzIpoPQwUsQ1S7cTntLleNw//cv5E23l/ZBteO9FZd
	ZQvsbVkyjCdb8J2fLXePd+wy4eK+5WHji4glUFh+hqbfBq7LMiwCyuTAgBZ5tYgJT9Xf5f
	eOwstNwhPrR5FlRZ+lAF50OUlh/sBkg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eklyQHG4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmGbgjAOFKj8U9JWZHOL4dCbqB8D3aS4P2nh+NBMt6B9fBAF1T+edn9FvWnVvDGMLKxZWWUlYTdWHR584K5E5d+77lukt8D2pTSweT/sBd5vDmImtfQDlYfFSuh2epdfILWd5I6QSuKFdpi005sLEa0LK1y/gHaiRyvh6hmuT3KRpkEwPkvBhBRDM2kDEg+KJdCA2JCg9ku2MvJiXJKpQRzAfNqhN0oy/nQi29XU3cADjIT39/M0RQ4ZKZY7T3pg5n54UZzJR6rtCg8PTdETl/ZT7HxpKMnKgjaMUJzVbiK0HWZTu/gFwAn9mM4g1eXpDuQcpAnSbNL0y8+3HtAnXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fa3DcBB3/5RcietCD79QSRND8W19FCh6Mva01B6vKz0=;
 b=ozbZIwn+GbwA/U4fnha2To75x5s9afWLR7pX90c5qQIFoDurobdq+CbjYJhRacF3v5RpQJvSuN9jOAQD2S9dMreYxK+y9kl6UENANcJUx85M7tyV4FzoTTuwVknEp/kWmgKCkYoRgl6/Zkd5TSaupkNKmoOZdGFwDlVSbh6HwwXJE9Icr4SBWEAbWvLCLmPvHjuUPpFOpx16gGHoOKO1KJbApo0Kur0jikj/QfFfF68mURDpa6y9lPRHTafU8M6aLQluwTyhAZHmr6443z5GgaCTgabcmih41g6w+v2cFNc3/nr0nvFG4yg0TRZeMpbBHiJHEGgKg49JUyDCfWzXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fa3DcBB3/5RcietCD79QSRND8W19FCh6Mva01B6vKz0=;
 b=eklyQHG4RGtmWjY/eiYdRiBfFy7E5w+eyj5lhBHz7ZhjF2ipyNAOrYGyn5ZXibBpaZ5nGnPqqDvCOPxmBOTUlFM6tBZrQvcbxAz5b6I0H6ShMu+M2mV0PXuXugtySy0jGtJGvcTLQPHs2KUYOY0xVqst/KQUKaH9QyAMdiAl6Ai6qJ3H5XYGvxy5Je6+vt4x1u1Qk0ELYS+YhMZbGBiuT4i1YeyRSXNeg36esm2IJ5zXEWPCiMXe17offCpnbaGiovDQWbTNjZH5EQlxmB0ieCiszFerfQppER32Zx6Vxiw24dLNiEV13n3CUAxE0YYqt9pcqAPfc3iz6F005uqu8g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 13:47:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 13:47:54 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 03 Jul 2026 09:47:49 -0400
Subject: [PATCH v2 4/5] mm/page_alloc: make sure tail_page->private is zero
 at page free time
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260703-keep-subpage-private-zero-at-free-v2-4-2970fe777dd6@nvidia.com>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS7PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:8:55::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 87db4492-45e9-4156-340c-08ded909aead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	nLODzp2GQkJ3K+vC1ozqNoyDFRg1jjm1OaOAV1rOQWef9Gb/3jA6GgI48R2uTINcAdCQW2wmd8iJmqHp3xweb8arjfShP3D77xCo1rYvZkiC9HfEfRNS927mXaSYyVf1SmYwKUjD1wCYXJ8b/bM7Zn26hJqv5ujUMsyruuZjnNCl8tlpkL1A/FkEN2w2GgaqeIicwZHwwQNEqG/1VX7oh0twPljU2ADTkcpZcA0XKvvPt3SmK6JPVrVspmeZeDPnoEpowWUYDpmpFTIDQie7XNAB7q0AhdJPKN8N1oo7bQKbiykd7tsV2PEucoNtcI8aP45B9tEPBgjHHqF/6FHNzTN53anwqCKzl0msjdGx/XF0QXmM1ZrSj3QaG+5mtj4MbryavfCg5BLJnsAbHbAb+SuELYHEpGRtkMoKqeQT44JrH81dO9UtGVA89mtfqrF+4TBZ2gQZZjI1vcf4Jp1pkrlXz+he0JaipzhcJ9i/wOcqBnn11/e5r2KTdPpK2ImrrRgtef+tJfSyAlb9bK9gJt4d9L3EQhXjK8PVmmoAGYzAS5CA7yBDgtkMyTvXg9T4UvxxFNFWNoaU3qtXfVpSdSZj9zJ9koi8XMo7s82ZqFJNQpzivm+GeQ7x1z6Lzpx4RJhtrKC3m8Y+CLTu+7hOgL+NfyEHiD70OzpM6BSdYulPclE5AbxWCZ3QiHYz6EVpzEH1TGpIFr0KKx+MWVRkcg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0lZdjRZNzJCaHRoL3BOKzBpVWRLRkVmc3k5VlorMUtFZGw0a0VmRGVHUm9G?=
 =?utf-8?B?Mk1Fa2ZQNkczZ2NIZ2FCbzVOU3VQZVhqS0JiZFFjUXZVbWhLRzRUdi9rWVNW?=
 =?utf-8?B?WG9pNEpORTN2aUR2b29oZlpncXFWL29EajltVktzNEJQYUNWK1FLSDRXMm9j?=
 =?utf-8?B?SzZlWkMwNmxJVmhoZHhpRE1XZDd0dmlyWGY2dnZyU2RNcFhMVHRqTEtOZ3pY?=
 =?utf-8?B?V0pMOGhFRVRoUjl1N0NXbFpDbWg3b2xsak9sVGVnRVpxODNoUGxON2lLU2lW?=
 =?utf-8?B?SnVwL1ROeGhqejRmUWFNQ3M5RXRzeG8wUzJNTWRIWnV4SG13WU5zQmlsR2xu?=
 =?utf-8?B?cHdxVWVpVTJYL0sxZ3FIMlV1V3JySzgrRkVjTHpJMHZHbXJRWERuZkZxVFVh?=
 =?utf-8?B?alA5WkpabUU1NDlOS0M3YkhCVXd3VVlEeE1DMFQvUlkxYVpackxCOHFCRVhD?=
 =?utf-8?B?czA2ZncwOUtOaWRrSHNHSjBsUnNXRkFsVUVJRFVWK2ZiN0cvbEE5b1dYY250?=
 =?utf-8?B?eTc4MnFrVXY4NTVZOE5YRFRsOWNJbGtXUGM2SUlWWExoZ0FGeitKbVQxZzFp?=
 =?utf-8?B?NFlWc2ZaY3ZGV0haZXhBaVZhcFIvV0M4MnY2dVRDc0xqcFpYd2NGUnFST1JO?=
 =?utf-8?B?ZHRxKzEzUUovYVFSaWJHM3ZVbHFHQUFrR3oycnhQMlFNZ0lCQU9kbS9SR0hI?=
 =?utf-8?B?Z2VEcE5IM0FkZTFxdGNEd3hRa25rampZN2EwQWlEK0JBNGhJdG05MnNncEwy?=
 =?utf-8?B?QVBOWlJ3d2pOb1hNR0JZcGpBc01hRUpjQ0JoakV4L0daNGZ4Q0pITGc2aG5m?=
 =?utf-8?B?aWV4YXloc3R5ekMzZ2ZQWWFMRTJEVDhYMzNKa2ttZndnUUsvYll4VFFMRGxL?=
 =?utf-8?B?M3JVUHBjdHRuT2pzVlIzOUowaXdQNWVMemFTcEI1MTR3S3JUWFRJOHl0c1cv?=
 =?utf-8?B?c0U0M0R0OHpIWHg1bUFFemZoL3R0K29YcStLdlRCVnlIVnRpdm5ENXVqbUkz?=
 =?utf-8?B?NWpIQlBDZ0x2VE0rUUdQOHA3aUprSkl5WVUrS1NSUWlpV2FLb2puOCs1dHN6?=
 =?utf-8?B?RHIxSFZoTXFDM0xkUThBNDBVbXp5RDdSUVJFR1B4VktUbjFpWEczRG9EZ2pK?=
 =?utf-8?B?SjJvdU5sWnozeVl0V1EwdlNiOXEvelIzeXNDd0YrK1d2eVVvcHRDVndHclBF?=
 =?utf-8?B?MU5KcWdJVHNhNVhsd1BlQmhnUmorTCs2ckpyOUtUNHFwbGlFUSsyMlc5ZmlG?=
 =?utf-8?B?bDFUV1c4Y0hkUXJ5eEE0NGkzNG9Ud2hENzRMU25TNzAwU0R3Y3lFMU1JcXVz?=
 =?utf-8?B?M2R4b1NNc1hNK3owYThzWmhiMHRtZEVlelpkZ1hvNmxoU2lXMXg2WlZyVW5G?=
 =?utf-8?B?dmx4d1FITDVHRXVHT09LSVRoUWU3WWV1RTJsSDhKZjVkWUhEaWdnNTNPeURl?=
 =?utf-8?B?K251NVN1NnlrcnhGWktidTM1dlBmYWZkYjliMjdXWnovN2I0TXhRb0Jpb0NW?=
 =?utf-8?B?NCswdCtuYTc4dlVrQlRuZDI2YzVBYUNSc1pIQ1Z0bkJTdndDQkYvdTAxdzhF?=
 =?utf-8?B?TlozMithUjdhMlYwZ0w1TDI2SlJ3Ym5IN01YMFdTVGUvL1BJOGlBeVVBaGU0?=
 =?utf-8?B?eTVUbGU0Q3o4ZUY2R2JaZjVIQk56L0x6K0dodVdtcjJEWGFhVFNwL0JQUjY0?=
 =?utf-8?B?ZGZWN3dXYkNDQURoNEdodnQ4L29SaHNnclhrbVlCbU9JOWdqbElTL3dJWXIz?=
 =?utf-8?B?anE0NTZnS3hFcmpES2trWGpCQ3hLdk9HMzZrQmFpK3RrYTYvdE4yQjNxYTV5?=
 =?utf-8?B?bzlFTW1GNHNwakNHL3VXY0F0SEtBR1cvK3ZjZFJEaFVFNytnbTFRdGJWenZG?=
 =?utf-8?B?NStONG8vK2hENDlpNDA3bE5tbXhmcHpXT3JXWVVNZ2Zqa1VyUW9lLzhPaW1V?=
 =?utf-8?B?aHdRZUd6cmNuZE1JZzA3Um5lTnlZU1dyTFRrdE5PNGlGMWdIYUg5cnl5anVK?=
 =?utf-8?B?ZjIwanlOUU9NSzVOS1dRMThNVmdvNGJjVy9DMTBZaHBORjh4TTVsdk5ob2xC?=
 =?utf-8?B?bWRtRTdOdXVBeUl6d2k5N2dOYVFheWY0b1licS9XLyswSi9FUDJpWXJaUjVp?=
 =?utf-8?B?NGJ1TmxObWRyYmIwbVRiN3ZaOFNLQ3JEVGRHVnQ2Q2JBTnRYRFY2VU4yMTZV?=
 =?utf-8?B?dnNnMG1PZzBrUFJ0WVY3QXlDK2R5RU9jczFCdnEzNW5Ec0ZBRW1IdE91MmFO?=
 =?utf-8?B?d09JL0lTempYc1NMaUFpVG1ENGExWERwTHQwMlYxbWtaWVBFSUJTeHE1OXRO?=
 =?utf-8?Q?iS9YKDBQKdr587ubek?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87db4492-45e9-4156-340c-08ded909aead
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:47:54.2677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r447yeCONB+kAUrlFVPNYv631uJ1qyQY1OpcOnFFZxwyRUryeSn5CjtOMq0MqFCQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rccx6ikogedyzut4zkagbmk3sq61rice
X-Rspamd-Queue-Id: C6B3910000B
X-HE-Tag: 1783086484-904540
X-HE-Meta: U2FsdGVkX1/FJevHj1HTNjf1DKzvJsiC39gdmQNdEMIljdtSc15WTxMgu/v3Tgb9rQl8DrAmyq6xxbc3kYUpkcEHZkmxSiJmPIUEvF/96GSVDrsWEpNjjgG5p/+uJ0Xht6z+mHWfOWSFp9Av4WKUe/Fctn8cs5rEH12jSaBOqB+znVorV2UcvQsAjTm0HSyhmVkCAqSqQ1zs+0kZudOO26AHMm9/LiI7BH1CLADJbXdJyJuRf6D8gQOhrACLD4krO4IfAQT+nH8StWeb8mt5Q0/BeM0/0lMJAm8oTPWQqS/mysjwchXrI43EZqgzsAwr4N6YbrzS6mcEnU8LKAiL2JcslE6ZyFZKicbvOHRTY6weHqfBnUbnk4tfPhUtyWAjgYYsZzDHDTpqBsCfrESfU4xxTgvs7jrdBJdPN5W/O95gV/5zwnvEO9osMg+Y79DXMgCPnAsR8f8xHZQJhLBR223hZkPV5jhsziSG1E/CGTMzBbO/fvHHAwf9I+48McEAfEVZL0Qt8DiIpelx3x51KhzEAJh4IWAUXmTBWpdUE/zq7K74832QLXbP5eqBAV/g640xXpZqe3CaQxj2b2SmAZPq06ckKlWRU9wYhvmP45JadxJl2vGIRN20BWmvu3xA9YFEw5/067gT3esWVwFH0L2T/fJgDx03TklMCaaB5kFooKK1nWTQIzmvyKcoTJRvb1g74dFDn+qQFWc1kHChPxAPrEj+8vvrZa3ErDQLcxLkl6peG3jS/8rBLN8VZZ08/fCNutSKA3Zna0vmItdQv9chomsvZCRL7+/fBrf/gE8rFSQ0TYYFY9A3AKWnpToqYxxiw5kIbGgRYFutqUENB3pWBz3yVLcWkEwUTfAZSQQZsXH4l9G47nBFWCDPfN8Sq6pBhV+ctIvFLGHfQf/fOpuSD2nYsFngZ7XS1KCEmZj4EHRI/o3TEjOjhQWom4CvQIHn/KDMxSbmiGe8ISm
 un7Eb9qX
 yYSId2sKnVoFwEoOJ/eWAjglJEX64RWGYZc2inW9uZy5O72XO4b9/+oV9Oc+9SvIcxmOi5iMrNDxSxEskJM4CtBjEHjNBF781Op7ajNIUTqIOhm2n7iGi7tiISYGmjxNeKCWFhfeZCyVkp5hS73RcZ6VWodjdoSVWtLB+KH2+2I2QZN1mfey4l+A2YfDt9U5Rbb+VfAcldpFHzwBzY2z14WhRajnnBqsffZYjrX81/0E5R4HC1+ju0vReEF7jIGmJqoZ5GI6gyLFafxvtudWOpOh6FYkjbI4Rm6dlsDc5cpTRpiSiDsgRqRFJk5kPbWKEagFmx1q4lCR/WCRiwwG39/Jcl9PiQsLvgA4Vvk5svTxyhpDiaFL7HTc2UtTbMxQRAAIwOZDfm8j8uu8n2uVmoOUZPWjrp74XSG33xvTMVaH2zCGbV6RDGCX+vjI3s8/u/HFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any code using tail_page->private of a folio, a compound page or a
high-order page is supposed to reset it after use, otherwise ->private data
can leak to new page user and cause unexpected issues. Add a bad_page()
check at page free path for it.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/page_alloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 762d9b6bc792f..723a52dfc80f6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1376,15 +1376,22 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
+			struct page *tail_page = page + i;
+
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, tail_page);
 			if (is_check_pages_enabled()) {
-				if (free_page_is_bad(page + i)) {
+				if (free_page_is_bad(tail_page)) {
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			if (is_check_pages_enabled() && tail_page->private) {
+				bad_page(tail_page, "nonzero private");
+				bad++;
+				continue;
+			}
 		}
 	}
 	if (folio_test_anon(folio)) {

-- 
2.53.0


