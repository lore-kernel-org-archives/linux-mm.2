Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF04DC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C816B0093; Thu, 16 Jul 2026 17:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713EF6B00A0; Thu, 16 Jul 2026 17:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF616B00A3; Thu, 16 Jul 2026 17:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 328256B0093
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:11:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF939C0303
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:11:15 +0000 (UTC)
X-FDA: 84995885310.19.6C4DDD3
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	by imf05.hostedemail.com (Postfix) with ESMTP id AAD2A100004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:11:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YGeayh7A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784236272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TURODzLWfdqxRaUKipXe/jJvez4m0lmehNX4k8OxZdw=;
	b=vGwKa/qsTaCVvtgkOoi88GrOgISEObEu4yi1e0mDid7u+yzKnefKsPyHBBp8ThbgdrfvO6
	6E3wkIpCNVToqNcdnpNUT+jYQjxgq8FZORWqQZ0G8zAsUSd4wlby5JzqNk1qs0H1f0X07W
	DqJKxPMb3A6BseJ97rMUJLeiAepN3d4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YGeayh7A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784236272;
	b=MswihQE8nfrFP+71ByP52x/mlY0V5eT4sI/GYXRXWhzyjaHXhTzRuPcFlZqAp+8EUsG0Ye
	EN3ucJJp2+vjRG7hYZ4cUYyXMtVJzbYhl+1tRDrQ3SLNDUKuvS5w4YCU6BTy9FbaPN97qQ
	Eb/kBXJSFoankxurDbOP6CJanJ036HM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIhWNJy0CxheW7ghnzIwCFOob4XIOUQnirYwFuvlvPrNQRMD6FlBhTgemchn3ZQYi3qTfzUCDYxJXcQ+8/FlLDnya42gQI4DmzxqgjoF/e8OcTgJZ+lHKKZrc3w1gTFhw6uiHFZrIzUERx1RkuUk+PS5pR9jtFMIFc/s5YZ0OTpN0vYdv9tXzE7Pexo03EF4INUAxJRdLZdw3Od0OkIQDCb73GYu35V3qMvF+rxmYuc6bR0jF/ji3UFTQXusWFLQYZfdcQr6q+Su/wKsEIksNvDidysloRjaZzhHSBGtbbsdeYyn0TwYYbBNpw28HRbPeDVYSU3s7o934kjJ26F9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TURODzLWfdqxRaUKipXe/jJvez4m0lmehNX4k8OxZdw=;
 b=kNh9WeLU4CrmK+/WmPWC8KrbmSymjTUC7wiK+ET9nL6V2yZcIzwsoDNg6viacKzA9wI3e6uwzrWS+k5ads+zb6Ln0VE1Brs460RGAxzIladVMPvMl78onsU2DP4p4/oRQkz515m3Ok04psbkLZVLn45pUbYtQ8gABuiO8oyQS962iDEtO1QiT+vtL23OGmJZ0wTG3IRqifCuxvAqT1ZcfjPZ9kqERlEocJRI1Ya5uRRmNn4nwo7WCOA9/qBhwegjPTLA0ZKwQ282DmcRlIxrO5ur016vQs2LcZpuquBVROSWfPwQPJ5cyMvEQrA/faUfrVlDBEyOPOPnwhoYcvblZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TURODzLWfdqxRaUKipXe/jJvez4m0lmehNX4k8OxZdw=;
 b=YGeayh7A0UPiYR8K5VVwth+duuoDRCyUfmqOyMuP52AjuWD0hRv0siKzzHnn/ib5zjw4KQBFTB7w5NFWCsxwOYL6n8MAw3ggo4O4DFRXUKumPpQrIKqNP7cevyT+iIkbNySThkF0kVBL+BDcz6/bVubgAfcIKugpbd35Yow+2Gm1EURMQe2wwtp25iY2RZBUICFzxMmq1//XbWMjke5fYwhzPkXBKRnFtcFMJpGYGeq2gKfMowlX/o0l3sq2NB4WgPDoyY0WSCMfhLNVk/f+E8T11K4WMCg68nUo2YsFx0OfW4jxEk6Q3PLNXuJH3BdM4NaFz6SVBL/2XcCpIXPNWw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BN3PR12MB9595.namprd12.prod.outlook.com (2603:10b6:408:2cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:11:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 21:11:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 17:11:06 -0400
Message-Id: <DK0AYXAPZJOE.1G174PZD8NHLA@nvidia.com>
Subject: Re: [PATCH v2 01/10] x86/mm: drop order parameter from
 free_pagetable()
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
 <20260716-bootmem_info_part2-v2-1-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-1-4afc76c73d61@kernel.org>
X-ClientProxiedBy: YQZPR01CA0095.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BN3PR12MB9595:EE_
X-MS-Office365-Filtering-Correlation-Id: 4687d4da-d3f6-40ad-f91c-08dee37ec189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|11063799006|4143699003|56012099006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QFyQbkbGMMaW394GnvCsUlSxn2YD4j3lC3I0gG0InWo5Xo/MUemp7SKXDv/0lEcycDRcu3gywxtO9mJK89nDjdDPKmxiRvv64WWr9uQJdN2IkHZz0bpRqYlPQhl70MSrXz95EL63QCVHGWvemTnq8rRvCm0ckWYzjpieS4Pe5Vq9MseXsxO18XwhvwOnKhwm4NsQAGnIX3TMzBMbXzNXcn4I7FWqvPdjD3rrHlg8fgBaXp6OjW1E/hDfaSJ/Tg89LVvvMULUoGRlZOQ6NcWDIOEpfZav+oOlSS/K5c4xaHc7+ZCRZgFpZldN9rBc0gvEs9IL0rxeWOKCF70Cov33dAq5PrbMqOGnebPnLBiPVh2Sez970SiMIAXGc0ESF9TIVtny1Xn/izvQ1chYLp6tmTAUfE4z86XriHd7HMGsg4UhnAdqVUUFPPu25WrhdDmN7QVW+lhoHDNXOwijEadZcZzX00QiX0Om/JIKiLSSVy0hijOoZc4c24vh5uWnFZVGvRxWKRaC0IH/9MjW/v9+76al5+lA73Bb+O4CBbkprDTxqzj7j05+ogWbCavIIO5mxwxBRhGkfu5Q6GHi/G2YLdjdoDsBOgrYTA09bJe/p0yJ7xQzou2K4gZyrHCaQYMcB5+jqY1BhSTcHP8oiU4qKdpMqUXVGL6WUg6v9hv3C2A6J2VC1qyvIntTKutU9RO5U6fxItjjDshmCEMvKmcFKw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(11063799006)(4143699003)(56012099006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTloenJmTXl2VDFmOGdQTXczMmRGTU9ZaHRxNGZWOHk1ZlFKeGV2MGQ1Um4z?=
 =?utf-8?B?bGdpYldyMWNRdGdJQmQrb3Z2OU1ZOVZ0N0dsWDRUQTIvRUs1K3Z0dHRlYVl1?=
 =?utf-8?B?VXdnSDRrMFVMYnJ2YUx3WlNFaFVyY2c3MmczeCszY3dFVzdUMkNpT2I5Mlhw?=
 =?utf-8?B?VWxzek42c2dLWCsxREh1S3U2bk1iLzZVYTJLTzN1eHRYcE85NEZzcnhQeGZa?=
 =?utf-8?B?bHZMcVBjUGJmdXNuVFI2NFBFK3FhajZLYy80YXRSMk0wZ01sQTA0b2w2b2tZ?=
 =?utf-8?B?OWZBbGNGWThEZU9BZFlOdytqMzlHM2ZUNTMrRklqdmNmSHM5Z2xpWnRGTkcx?=
 =?utf-8?B?aWFiUE5QTG5lYlgwbFlPRU9BS2xFRnV3MFpsTWcyaC9RbVRhMEltaWlodXNp?=
 =?utf-8?B?TFltRUNwRkhreVJqRzJaQ0JtNFNmdWtPNlovWjMvWmdYTFAxdEwxdExpYU0y?=
 =?utf-8?B?Rng5UlpqbzV0ZHBqeXFWbjlFbkorRWJHcllTcFRjZlFzdEcrZ1NZallRREw2?=
 =?utf-8?B?bGI5S1V3UUhKRmlNbnFPWWZ0Tkcyc0xWWkY1REpkSy9FT2xsem5GbVhwQmtU?=
 =?utf-8?B?SzFHdXA1b0Z5K3Z5OFltWE95VGZvVlBBQ0pjcVZkcmRxL1BXTzE2S1E1cUtC?=
 =?utf-8?B?UGIxYmxoS2JocGtMMExnaWhDNXZVWENTZ21OaW5oRi9mcWVNQlcrWUpQZWhz?=
 =?utf-8?B?WDU4bHJsRnNWbDk1RWFQVzJPVDArc0RCbVhZV2RVOHlXeUtrR0NHWDdOMURz?=
 =?utf-8?B?WnJuQUZQQU1hQ3BYODYxRG94dk1sd0U2UG05Ri83QmVJL3lCbFV1VXp6SFRn?=
 =?utf-8?B?QXFVOCtkcGVTVWJwZkRrVkg3d2dNUEYreVIwZXAwUUdaQW14RndsVWJTY21U?=
 =?utf-8?B?VVdVSE9uMDJoaFFrcWdHQmR3eCtoN2xVczNBUjVnbTJxb3VtcGtoTHZ1TGJz?=
 =?utf-8?B?Y3g0YVRra0xkdW1PQlpXL000R2FuajkycmVoUkI4bCtXZG8vcXJ0MkpSc1Zv?=
 =?utf-8?B?T1REcDNEZjVNbmdrTTY5WFpQYUczWFNueUVQTCsxblZzMFV4a0NpcEwwSzZh?=
 =?utf-8?B?aWVpV2lzVFRLaVdQTERsNi9BUjlFOVRKdXVra09pM21QUFlac2hUZGt5QVd5?=
 =?utf-8?B?Q295WjZzcXlPL3pVbHJFVGpYNFRWeHo2VlVjUzRmWG9KKzZzVHkwYmJpN3Bh?=
 =?utf-8?B?cDNKaWkySDByMTF3ZUlpL00zajhFYW9EaGxNYWtIT2pQckREY3RZNStGMUtz?=
 =?utf-8?B?aEFpb0hnY1p2WE1MOFFwYXljVndxVXFvdU81eDVnRytCQ2E3Wkl1ekJVUS9M?=
 =?utf-8?B?NGVzZW04QTJqa0laNHMvQWFWRTNFUnVyQXZSMndFaHA0S1lyYmx1ZXJFeTdB?=
 =?utf-8?B?T09EK2xmU2c0VmVUMEJGUzllMzVkZE9GRGR3enU1V21zQUN2TGRDdnFtL3ps?=
 =?utf-8?B?eU85b2FkRDRyRXFSbXdUMy9RSk5NckNtMmxjUERROENXOXVQVDhRblJnQmpn?=
 =?utf-8?B?eUJwRU9GdHN2UFUxcjNWQldESTJFTjRZa3ZRRHZNYzhjb25laGpOdTVSaUo2?=
 =?utf-8?B?ZkFGeUhnSFczVTBrTHVIak52UWpCeUJEQXI5Ylc5NFJJVXA4QS9vdGRjVUk1?=
 =?utf-8?B?OXU4MzRxMkpBQ2s4N0lZR0xlaUNuRGVCeGtGSDl2S0pRZzl1dlpudVh5UG82?=
 =?utf-8?B?MkRTYTFkWWZOR3cxTDVGaHBDekpMWVBzcVFuNnlwU2UrSEZ1NW5raDJmWWlz?=
 =?utf-8?B?TUVxT1hQZHNMNVpTc2ZMbVBLZkpqNEFYaDJKbGpkMkRDOTVYSTE0ZkZORDJo?=
 =?utf-8?B?cFRKcHFrZkVnZ1hNQWhEbGUvVGpDNTdlM01DZjd0MzFrMUNnc21iK0xkYjJt?=
 =?utf-8?B?NEtkMlNWNHY3b3JYK1BtdFRxVUxYZVNidGRMRzRVSG82V2Q3L01JQ00zVUp0?=
 =?utf-8?B?WFVWWWFKTjlrZ2QyREVKYXpEd0trZFo2OWRocmNOVU0wNDQxc1pLME8wVEUz?=
 =?utf-8?B?VmpGS0txZHlPWEtqTm5PY09SS1FNTGZmVWx3aE8wR1Z5aEVkdEEwVVpOblFk?=
 =?utf-8?B?NjFwUWw1TjFYeTVrT1ZEQmVWblRUTjY5bUd4Q0JmeGxZVDR3RVp2YjkzNHZE?=
 =?utf-8?B?eHlKdzYydTZoeVBGMFNEWDJseGxnWm1FUlY4cVVhdW9iSHdjSm1ML0tGeTM3?=
 =?utf-8?B?WUt0NnFybzM4dzVnc0lHUmk4RTV6c3lrd2RrMGEwYk1CMXR6cnNDVDcybDEy?=
 =?utf-8?B?cjJYZWxBZ1AyWW96eVNkWjJvVjEwT3BReHFIUGhnc1dPajNoNEQ0dFZpZ05V?=
 =?utf-8?Q?eZc1ca9BekAc5T+QgT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4687d4da-d3f6-40ad-f91c-08dee37ec189
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:11:08.6931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzJLGq9jdGEOnUuHwmHZuLFS/lhESLT+VNGIScCZmF8S83Fsg5zoUrkwEbbXp1dA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9595
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAD2A100004
X-Stat-Signature: k5s7xpku9ucfsw4ri77aqjn1c8s1opsu
X-HE-Tag: 1784236272-507000
X-HE-Meta: U2FsdGVkX198wRRIl2tcwusPA505QXug3LEJdHxDuj7Mfs3vaQJCAGtGSQiB1ULiCiZ5e2kTXl4S6wHOmsQQ1M0UD2VPKweGlDuaAnrvf3PlUG3zTrVHvc/7dMyVIREUuKtI/s30/LYJdewfgqlihObVQn43uCCctc8fxrzF9dMGwPHxfSAuTmWrUbtZyN0WsxakgYuOvHZL0vRSlXsejPUTZdEcmXbbFwSr5XV0STBTHb/IxPlUaRz07Xd1x46zBI8NSJOft/NtSOMqQiWSsUesTPkADm+Zy6jjQbwIvnDH5Cj3oa9h26OVeqeCDGyXg6WMxLTXdDJ2j1L2ZnzUFa2/nt7MKJ3AXr3CREf0OWQIP0HuKwSqRpb61KZ+MmEroXMH4UpKT+eJECgXILbYpmb+r9Bv8Vjn+QKzRKmlr0QSQpmz2QDke5teNpOlDLlIu+40UbP+WHuozXhfw3ETUHliZitG0zUOldxRVf6c4J14IipcdfELV6JKFrG2MY88Cim1zJtKSCslWg+VJI1cj/16oCkZoAUbxJgJ2SEFs70rje6ssQ0rsz5aUBPcewOCI0ZOMN7AGIjIak8EK6QL+fKnREoHWVaJPffkOryfY2tyIGzhk+MDUT67qj9sIlnS/SxLdjjX08W5F/BUZ5vb+vpOdINUUCcvbnZJ0s3kb6MquE3aWmTRS4jUiCRBP6+zcXQ4bDTAJbi/C+iOFBk/LKkdbqAbEbJH9uwHjwFLOLbdHteL+2ePfqMt6ccb1A/hsaPpVLKX/jmnYA7emqENzbJA/7FpwG+kT/inE+TMrv6mOW2jySoG2qfU8veQ1PP31hp+Ljc+4MlNMw27OuIxsy7njSJc/1+b6CpCg05ofMs+//oZJV+4az01cyDsf14Y2X2hGvoZsNtuBNJpR5cQxUGEoi1uNPt3Q+ovrlmUeie7/1trqnC6s7BBJSHrdphlP0RfVq1LoAf1i8sCDpB
 jNDKeP3d
 37OqRoQVVE2+uakhMojMbUhZoTg3JzYENnB7CQ2r/MtNYQTEbTzaUaXpWFYLiRWbuWtLta29B69h2fbSvy83d5nAej1NrI+xBz514HF8Pd3MXYoh0K6eU1U266cwzdSlGOWiRGVgIce1rlSmERGlnGtJloh5rnx5L+LN9SC+xGJhsHIkFlT7IgHD4i5VyZZp87q4pKOYYsraBTUVpjKp8PCh4mlTpZr/oY2kIkRrC9P9eW2ybIIbd4a3/J3d2LnkkW1ytf06tVUCZbEjuWbObca5u0eJqv8JWaL68uXUlYv7cTfYGv4Tok9VCj8GDltYyCk1+NGuUoDCywA1yIzpNmHnkbVXCxX6h/fPf2zn6ps6qN/mmmWzJW7FXDdTc7qMfC2MzFEIeCTg+KiP+HDGqtlE/dOiDKFlxVwRu1H7lilfwY2/rod6xtTChpUSV50aojQDNnTiu9Aif6I8UuG40gr2xlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 10:51 AM EDT, David Hildenbrand (Arm) wrote:
> All callers pass 0, so let's drop the parameter.
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/x86/mm/init_64.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


