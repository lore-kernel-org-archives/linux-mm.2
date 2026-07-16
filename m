Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CE0C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9B06B00B1; Thu, 16 Jul 2026 17:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0646B00B2; Thu, 16 Jul 2026 17:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6F86B00B3; Thu, 16 Jul 2026 17:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41ABA6B00B1
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:13:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A95B91602EB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:13:42 +0000 (UTC)
X-FDA: 84995891484.03.BC6753C
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010007.outbound.protection.outlook.com [52.101.201.7])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7C4D20009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:13:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bxlOutC9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784236420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZ15O8asbbkyGDnwbWe27ifFCFdM3D7Sw3so2x9EDao=;
	b=nsc+XVR8czJabzBbdgUPsyUUML3UArdFbZ+4zm0tVFr613h4Y+TWVqMC9IfF382yAk0CKg
	DJ8UgGwFwOxWsyiste6PCJtdRDVpdwD5xT9AuIZe7umwsDg1D+WV+lVKBipko5bF15V/Xj
	SvhyGhVfaH979J6yP4X9SHGJCrg7UAo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bxlOutC9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784236420;
	b=usQGMhBfa9rnx1FCGP0xb/TtZ2YQlEz0xxXZUYUXgFN+SRaO0X4FuwprU9k50kADh5GXsI
	2GNG/qPCoKP299vl07lJMA/2a6rjGkMcKttAxPV3rNNaO16/U6OUQox/Oa1rCoO1UmC2dC
	DSe083fyw/m9nmm4ItXifD3rd0iqF8k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9t+j0Kj9gJhPaBY7I1TlXfMvW2KeVVfESyEuqBL7cPiyvw450yxLsdqmqZukUF331Kdpx4wdo0+nYj5UoTjS1yu4eCfPkDK464CG39lmyqKXMTT+r2k9Y19757C5lA7aaUZZuXU4nnNanfBqiakOOjOeLti9SInvAqkat/8UcfGt6W1rd9u4H3t2JAmGfnwTtEvphx6LiMd+yS//a4uAXXzeuXHj0KkU4BdKHALNuzSmScZztSGAyK73rvaAtzByFW8DpHvnOqc02Bl2gGcQkKKK8lckJFHRLqvj8qvCeMwtEPzygJaSX0Ed6bTnNMP7ak0A9wlRoNVJYkRdo01cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZ15O8asbbkyGDnwbWe27ifFCFdM3D7Sw3so2x9EDao=;
 b=KDWqqCF94W/dEvnutwAwiirnbHKDNx4sCzCDKUowYiqoYdl7u0buXy3vvFsdZxkG1KqyEkDD2mQNkjNgtczVxmMzALnHtMAQSzP9/fsc74gBPgmLlYXj4tADbUL5K8vyYsJI8DBbjiH8gTwpPCM67TacxU8Jsa1ciLGY/xfA79x8JX+t3XVGfpImuMyA6au0L1ydfCij1+PzqC0nzfwAHbqH2GGh9Iwd2F4PyfQ+yOtLqPbdc2XY6bxlT2tQ2Xq9P4h4KmqQV4X/6vLlMynCyQaj+xjYqax+ZUY4vPPNyWrY+59KWStp6ruvGWedR90ELm/giG2u48p/a/mysSBu/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZ15O8asbbkyGDnwbWe27ifFCFdM3D7Sw3so2x9EDao=;
 b=bxlOutC9/GSOhSQQEnigXBa0+nYASyLACIejg1rlrj0AjnYcP6+YuwMpQk0cEeHkZGuAFVrT7L1X3obv4pLQvZ9/AI4H4n//ZteVcfksZ9Px/yS9xNoW3N3K6imfCcdte8Gq4PuHYkkGk9n7L1juKkSdPCUtu8zUOlaMGRvoIby3iUboLnnk7X0+SZY48kYOIhWk/USID36R7cMcQnf7hXtHMe5HREmkC38aFVZifm8sJG0b27vzpyd3N7bIoOjwHzt6KQZ0bZeWVSRx0zqu7D23U/uo1YkoKa0U/3y1LBm9Us0OGg8cKd7GPowndUYHbU9qZ/OO1SZhvO2Hb1zscg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9424.namprd12.prod.outlook.com (2603:10b6:8:1b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:13:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 21:13:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 17:13:32 -0400
Message-Id: <DK0B0S62Y96H.3RZQ5ES88NMNX@nvidia.com>
Subject: Re: [PATCH v2 03/10] s390/mm: use free_reserved_pages() in
 vmem_free_pages()
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-s390@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Andy Lutomirski" <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Alexander Gordeev"
 <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger"
 <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
 <20260716-bootmem_info_part2-v2-3-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-3-4afc76c73d61@kernel.org>
X-ClientProxiedBy: MN2PR01CA0039.prod.exchangelabs.com (2603:10b6:208:23f::8)
 To IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fd4a979-4a10-46c2-13de-08dee37f17bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|921020|10067099003|11063799006|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	W9yAhoTIlu5KZuINKmdp7ra7U/1uJYG1Jfim4FHDgmgNdepE9xUwX9rZyoYvC2SaulrBB17Fxe04hKGE4l/1W0/r06s5mkh2WrcDBrmhnPHD98WbIr3OBqltnVmptyyyRQuF1GWEE90//vN+3liZli4jz0oSDYnr6ErLQsovA9zP+UqkeKGpBXyqpZxcYxhOaiko8Ry7HmsDj/t10v+ytnQl4/IiNd2xEGApzS7Ro+MBKwEbRjnkjqGcCc5rYz0R7DvWKBh/JbCkpiSDTpC5I61mAXxce0FUbT6D7fjZ38rFUhvmnYFQ6mdVpOViDBh6vBKcYnIjhyLsXwQlIV7Ak2yvftAqmu3BmMWxfVf0qyWpy8pPP1P9b4RzWjnYzeoX7YHUVSEuIjc68JawbUPzVaRHBVlNoahvDclS0UrUgsxariCzCSu3l2Qopi4Vs0OBqG1uGk9fwTMKShm7ugYGF6463NbGerFSEPE1gnAxRmeZAg0t5vB0Pnyirp2ALD/SHiZlbVey+a4J+z5GOyuncw8mjsyUgE6YKnUoCr4p0E0A3xyI41XQ1vRJva4igfCDXM/ZYhSFfx63tBpTrWZgeBCtTd99o/EMWV1RTK54SP0gXevjKUA6FUJlli17eOO39sp28iUfmmlxsmOEXtfZ4FfllqcSYdvJLZK3n5NRZxMug1nwCvdd8UBvPGjElr55mUrL/0eaCATMC93OCbwGkg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(921020)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rnc0MVRYTEViWmlVVjltdTVkVTlsODNkYVdYa3VjL0ozNVVtWUE3Z1hhRkZI?=
 =?utf-8?B?T0NCd2owWmZSR3ROVDFzTHN6cUV3NWNlZE9Ja25sVlNUVXNndUkzVGRWQVB6?=
 =?utf-8?B?VDhCejc2emhuNzJCRTJOUGRwZHUyQ0M3VXFMZ0xyQytZTHdGeWJBMzBjd09F?=
 =?utf-8?B?bmtFS3Q3MUdGekp3OGh6Wml5NnJzR1RNM2Y0VS9aU3RhcWpOYWtqYVFYUnBr?=
 =?utf-8?B?d2UwRWMxd0VYd053R1lTSEZWdlNxWGRQWE5KdkMzdjhDelVuS250bllqdHpS?=
 =?utf-8?B?WWNWb3JpM3dRaCtySkV4Y3pNNno3QTRESnpISWtuSGtGOTlNL055L29CVys0?=
 =?utf-8?B?Z1NOdnZOZ1Z1cncvYXhvSGtzT0poOWhjNWtIVkl4TXhjRUxWUy9TRkhPQVpn?=
 =?utf-8?B?OVdBQy9uekRqaEpaSXB2WGRsTmdxbUtneDd5a2NQTStWVkhvNUxlM3RnZDMy?=
 =?utf-8?B?ektoK0VqVkZZdkRrMjAvSGlXVHhnWWhwalZmTXIzRUpjUzdPQ1ljYW5ycDAw?=
 =?utf-8?B?MmFtdmdMZnl5MURpSTRGdHR6Y1pWcE5COEVkb1hGenZuTVRGYSszTzg4MjB3?=
 =?utf-8?B?dU8wM2VoNlFRNXlwWElJVjNJSTNVcGtFVUxZNThCbTZpZWEwcFpOV25JSkhG?=
 =?utf-8?B?ZUJadGJtVDZLWnp1aUVaQ0RxU0dEY3ZqMkpqbUNvcGRDSHhhTVdxV3QyQ29v?=
 =?utf-8?B?Wi9NVExwb2NTUWN0TjBxZlU1elhTbVFCWVZTL3d5R3ZSamdpcCtGelQ3dmtr?=
 =?utf-8?B?REtNL0plck1WZG9CZURHM29jWlljZ2pibW1TYkRRWStzTVR5L3lNTTQ1WXRM?=
 =?utf-8?B?MS9kK1VwYnZFZnV0YzFKTWJmZ1pmb2xLbHRKMk9vSTBlcUd6L1h5WW5HQ3Vs?=
 =?utf-8?B?NVV5bElTWWdlNW9JYkhkeHBubFhrdXZ2cEttSHhYcWVnVU8xSm1DRmM3UExy?=
 =?utf-8?B?T1o4bDY0WDFyclBxMUh2WEpGdWtHaHY3SDdZd2NrbzgyYklmK1lyUVA4UHBn?=
 =?utf-8?B?ZlpxY003c2RXNGlQTHkzWlV1UWVPWDhHS1ZjWUpzcjdjclMwTU1VTytFUkZK?=
 =?utf-8?B?cjFnVmdpVWlQNWY4ZklBVDB4Tmk0MXFZczVLbHJKZnZoRjF2Tm5TbzEvR2Q4?=
 =?utf-8?B?aXdUdGpCczErSjNSQkxmWS9KWHArQ3ZCSmtRZGQ1U1NMQ0JuSitxc01vMC9r?=
 =?utf-8?B?TEU1K3lOamlYakVzKzIxZXdLVDF6QWV5R3hXamh3dHh1Q2VQc2ZSNE9mWWwr?=
 =?utf-8?B?MzgrMWpPQS9tcGRqQ2NmTzR2dGFETUM3N1pacTlLTDVobjlSY01zUDJVNlFp?=
 =?utf-8?B?Q2JpL3d4bmIyTW51VlU4YldHQmp5U1pIbXB4RXhlRWlTTGx3VjhxN3RWbk1o?=
 =?utf-8?B?TU1wc2ViTlozbkV0Q1J6eThYTXF4bDd5aWFHUnplTXJWT1E4VDNEWHVNL3VT?=
 =?utf-8?B?SWNhQ294L3pPOTZpVlBqY0lSYzVWOEFzR2pHdnZhSVI5WkZaenBGR3dSRkMr?=
 =?utf-8?B?NzRRQjZEVExwMU1PSHREUERpSloySzkvOHkzeDErajRNeDNmaXRkWU01VktS?=
 =?utf-8?B?REZzeGN1ejJtRW1pc3NtakgxdWE1RCtOeitVQ0lMdkY4SkJ0ekxTRlFxTXdR?=
 =?utf-8?B?T25HbExlVHU5dEt0djlJRHFuM21KV2RRZkdxR2ZNQzIzMjJvbklBcTJaczFS?=
 =?utf-8?B?S1hqa2w3Yk9uZHVLbzBscjJDT0Vhb2ZNRlBHaUZWR2pTVytIMnU5VENSVE13?=
 =?utf-8?B?RXJJY1R1ejMxenhhakhLYlZYZVRIK3paenVJZW9Qdy9Oa0pIQW5xSmcvM3k2?=
 =?utf-8?B?aXBWeEwxbERocGNXVFlQVER2czRMZ1Y4d3JaQmFMa3ZKYU8rdGUrTVUxZ3B4?=
 =?utf-8?B?RlFBMVo3N1AzQ2d2dzQvYkNyQmsrK1dvcFcvNER5RDJUYS9VczZ2R0VReTk4?=
 =?utf-8?B?eS9LS2hpRW8ydGtwQ1dqaklxSERDTDcxNjdBWTQ5Ynk3Mm1QSlFOR0poWDl0?=
 =?utf-8?B?QjViSDYwMC9QZm92YzRkYk41RHlTVzUvazZsYTBJVDZ4dit2NE5NRWNQWlRw?=
 =?utf-8?B?YlkwSlhoZ0paQzc2L2VEUWRCcktwVVRndGdDbytYb3UyZEJwNkhoczJUTHpl?=
 =?utf-8?B?T0FRQmIrZXFLcnN4L3p6OUpRWll2M1BxMTBQQlkxZTRrVkxoUjN5d3lLa2Z3?=
 =?utf-8?B?M21VMmpFU0U1WVJyTStkRlRSMjJTWkhjWk5ua3ZLQUVVemQxWnJkN2JEZWwv?=
 =?utf-8?B?bCtEN0xhRktMb0NuOXg5bmV3Qi8zbGIvOTUxcUNZelpuL3ZNSGE0NExyYUg1?=
 =?utf-8?Q?ybcAHBU9hsmLcBehhu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd4a979-4a10-46c2-13de-08dee37f17bf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:13:33.2797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CZiHOZBq0A3Q6lYbqc/QcbDC7U72PM8RqU+t2Ca93fy38rp7qAWotHrRT5ftPMd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9424
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7C4D20009
X-Stat-Signature: fat93eq5abudofbz1n1483y7ho4nokhg
X-HE-Tag: 1784236419-965899
X-HE-Meta: U2FsdGVkX18cgQLv3/asj+wj3d33WZZ9LG/dIsCOFZbzHCm29ZrV5tEkxE+MyrosqPMlUElKL2IiHRQABiWEwvbZbCQmCAonBjsLfv+GnYpDDQZBlalE/k2oeTDeSc5JpwEdoM12Uf+9tZ8moH3i1X4yF9mjqH48W59NUing52wHZRzE52EeisMCAF+s7aUuopxlPe+iROYqcob+PtPW644z6Kjmoof1CG84wj0TtD7fVzF34c5NxVU06YZAx925o/qStow1ngyeKjZOK/TBY17oOdDtgVdXHyMBEea5uY0D/eWl6P/Cp+uuE8Mb5kEr11AJIfB+Q14cX9hnz1WL7x/OiVXMveSEICCFLkhOsHrVB5XRXo5P8JqT/8+3LiyBIQ/Od8BxBT0wmo0Zi1tHHXNEG1a28TWjQ/5dLw22Q6BP0mZ2K2m/nIMcA35LYCK/ds1BTrmvl52bvrD6lesAid76KQ3cMdJ1N+eRo4osw11UdEB67/qJFb2AA4Jz0IPX2KYmoCZlCMoo5XraeFRj9pb+wy5DGkB/YFpVhdnFw1WHV99MsCq0LCv/ZmO1pq5ZAYy5qE0ActAzXxXm9kWX1YHnJgRv3F5voI63xDl9dN61QjnuJHSSkyZTsfraJ1GOl1PWGF5RqYJdFDVGp2ZzK1extYSNkVfPV+BbprcEEGJzwTvE2UV8a89wvxv5KNVfJBYgKvakFN6scT+5VzEIbhTHHEHXgDcTbiWFhBunr0icL3GfLFFsQhL/JFrb591phjf/MzXiAbtPbhsNPD+jqw3QdFOK413Tj/r0nDXxpc8kgiPDPOmBmGK0L9e89Ho7181Mr0iDRZD/wWjd5zlsnF68rW6GAEtsFOtkUGpsPDBITFZSy8o/MjBaFLs6UTTOZ3dij8zwoiYA+2/InKacPO+toAE5xhdWqWARw5H82mRxJpNTo48pOTmwTRk9i/9QcPLsE3BVWasncUfVJlK
 pCmMaDIT
 kK0M1z5Yz1Y5MRJGxMiuRxMFHZtv8jFvxnFmWnjIw3C8xJoD2v8s9mX3q5FiQfsRfq4kc/B99lB4WUcXyyKTQCSYbaXczs3BQGeneNvC5N/fruEiUSU3U8XUArykMlPjZqR9CLGlRFQFbmyJzG25ov2m7BsTogd54/FuTo8WdITPsFhZXb1/wjVMwXMNo61z3ajtZSfp+vb9leanOgKc0psIIwVQSELDsGJhoDO8uyLIWA/6eqUmD1PamSkuRKY5J+odAMYJsFGj61Ytkquex1k/hQzLXtAyT2klRP5Px/1e8r2EQRkGnwmT9kqteCcOYgSy0/aT7lGPDcDDS6doFX4JvwT7dAhsDfNwDAqHODGg1ym1ZdolceMZc6QauRvi8Vl8YL5zKrZvsQKb+N52zjqhDfkl58dma3a+jzQinVCGRdjACqetL4mcxrvek+f6S79EnGPFubdFH40oKJy8aabJ5QjAYYAhJVu387kn2yrYCoPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 10:51 AM EDT, David Hildenbrand (Arm) wrote:
> Let's use our new generic helper.
>
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/s390/mm/vmem.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


