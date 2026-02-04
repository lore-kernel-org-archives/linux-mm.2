Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A724EA7948
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826576B0005; Wed,  4 Feb 2026 16:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807DA6B0092; Wed,  4 Feb 2026 16:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD3B6B0093; Wed,  4 Feb 2026 16:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD516B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:41:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 240181A01D9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:41:13 +0000 (UTC)
X-FDA: 84408095226.03.46763B2
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011023.outbound.protection.outlook.com [40.107.208.23])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4079F40005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:41:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RVdDIEkI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770241270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jN6AeiKAVA4QloCA4TuDH6b0Fc7d0IErE8ReP6J0D8=;
	b=b/YMT10ZrDHOZdxwIkvX7vzGEFwDGty8eR8rGMKsyD6SXOyGUrCYul3rjMX90obx1kb1ZA
	ANopXghrsYb4ZcaNIqGCDOAadDy+lDQvBF6DYVGf8u3+CnDvnClsyjPvmu1Loq0x/09NqE
	n18e3iXPzrjH2yUNiFFGnJUawrxzVjg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770241270; a=rsa-sha256;
	cv=pass;
	b=lXuZ+pz9yw54QZLhwBTd/89J4n50+y6iGe04S3fYZ2aNMdoz2ZN8ol8XuVNskmHGe3hZyU
	7bo8W7RJyLBpGl20my8zWongp0hgVErdgIxFks8VEa1zioff5FoQyBrY47eoV7If5cseq6
	EVIiNr3VV6I3iA06n1bZlOE00ylMEJs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RVdDIEkI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EcF+FWdnZS80mijbDBW0exWaCeZsyGfcm6VwpM19wGfLhn0QdLbkeiaO9VQ8z0KTzjEd81NDOF5ueXKitmcn8OZ80V4YMo8DjSC+KM2dwibYhWho04sXxWER1y75tSLBVmZ1p4oYmEgzLTS641xk/579UBQgeo6mda85uCKxKlT7RjPPNZqKbPUiNFn0KKsfYc/7pjKc9Y/7v+fmwEEJIA58cXTYg8MDaa4nqDhWim6yqQzJcw024DtTnBBu6928R9UudD8GuRuQV3+Yhwwe+IIqv4T9ZvWHDKdepWoJ8kZG6g5qEpgAxhagdK33OyGVUclxFEr3VQUM2x6879gCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jN6AeiKAVA4QloCA4TuDH6b0Fc7d0IErE8ReP6J0D8=;
 b=zPRkoCc2lpvGsweI+P4Kc1OD5A0sspSrwvcWtywtjsPcSQD7uyI2EdoMI3VX56+UjRj+m7EkOwMJVhopseJsAPmk8Sh0oMbdY6zhnT4qwfvIac1StYQfGwT/g7F538+vGOcIG4sx6kcSjcDh1diEL28YgV+ReYeMpONdpLNAf0MQRryR8w2j54QuGISfBN8ALzudqOpek8GtTs/VW94OwpxhRpzq6x/LMPMEvZwTsxxYyI+UiAh3x5Jk73JG+VqR4Bo0K1YZXnzeKGYR5bJ7sqPvHJbAwV9KIhKz0fsRaeTW8CcaZkUi9Oe63AWe/EeUc7enj24VA/iSkpO320aYOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jN6AeiKAVA4QloCA4TuDH6b0Fc7d0IErE8ReP6J0D8=;
 b=RVdDIEkINJB5i0Nhqafi6IHP6dr04v/mpt/oJ22PSkC2kf00CSjMANGQXhfDMFMWTzLWiiNf7uu+rZfiVqGz43qJaWywn49ZgpAnFipNP18OZ0y8BFB4T+HACh5ivCccYL0NwRNMqzqNtrfYEEy/i2jL0C9MGy2DDKDqEmzWurruTngf/1k/3ur5f4Qh8IJ2d3VyLDiFHjl1EJqD5y+dGdIM+1uBZAOjQgxtNiPe3ZiAmjwW7MVXBdn8CEJ3XKh6B9d6/J01dpV9ZfRobm9aJGw7TTbhIWXnT9fZr6KdtaGodE0YnotyIu0A2xziq4A423o3EnHBOT7tzEivPTXFKw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY1PR12MB9698.namprd12.prod.outlook.com (2603:10b6:930:107::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 21:41:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 21:41:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>,
 =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>
Cc: linux-mm@kvack.org, linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 16:41:03 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <94DAA11B-597F-4F8F-AFFF-9D7626A7C091@nvidia.com>
In-Reply-To: <1bfc9e64-2961-4d2c-a6c3-fb123f66e6cc@kernel.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
 <1bfc9e64-2961-4d2c-a6c3-fb123f66e6cc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR11CA0083.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY1PR12MB9698:EE_
X-MS-Office365-Filtering-Correlation-Id: eccee2cc-83cc-40f9-26f6-08de64361a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWJtaG83bm1SQXFDaW1TNm5HcFpBeXdQcHhtalhwWDlxdkN6UEtXL09RK3FL?=
 =?utf-8?B?S0xYS2xVbUl3RHlXTEVKZkhUWG5oM0dsRWpEWk5mOWkycHVhck5nQy9lWEpn?=
 =?utf-8?B?WlZieEtRUkxVbEVqbmtCU3R6RHR5SDZGRW1FTEJnUHRQUTN1dlptT0N4b2lr?=
 =?utf-8?B?djRSaC9BUDVENHprazNQRm1zMXV3bUk5Q2l5dUowaXBvU0QvMzljalBiT2pv?=
 =?utf-8?B?dVJicDV2OWdSTWZ6ZHJTdEF2RTh4bkd1YWxvbDV1YnVpY21uSHRlSG5DR1F5?=
 =?utf-8?B?R2FZemNEaVFEMzB4cmM1OUxyK1RablZza3JnblJjOGptRTdIVFRQRkpCVzRS?=
 =?utf-8?B?UmpHcW1SamRPTWduQmlINVg3ZktTT2M1ME1BN0dxTWNneGx6NDFhakFNVFpH?=
 =?utf-8?B?UlI4M081eFdsRGZXbjRJUHc2bFgvVUJpRWxwZ0lwQWozNVlUOTJRNEp0NmNP?=
 =?utf-8?B?dnowejhTNm5SUDI1RWd3YkxqM1BpR3J4emsvWXhuU1pITjRldGQ1eWxyUjdQ?=
 =?utf-8?B?Z1JpWXNYMnRFdmdITUpkNzcrNHpvYVZBS0d1RUoyWHhYeWYyc3pMelExMldV?=
 =?utf-8?B?MUluWEdPZWEzK0ZVOE9YWk54TVRMcGFVdlF4YTVDZFBNc0orTHdYc2xJNmdi?=
 =?utf-8?B?SlBnRHRxK3lsRlRybVZPMys2VzRWSktSbk12dHBWTGFtRmRjbWFPMDh6Q2I4?=
 =?utf-8?B?NWZZTU9sSDI1UTRmRXArMzZialhKSkVJVCtDanlYV1ZpZ0RieHkybnNYQ1Nq?=
 =?utf-8?B?M2MvUmlPN01ocnVKTUxxSERKVXErVTVET0V3NEtIMG9aSWNPYm1aOWtFaVBK?=
 =?utf-8?B?c2RtU0M5RnUrMDVWMkNCcncrTHZRMGJUeXlObUxaY2ptOVR3dEZseHdBRy9y?=
 =?utf-8?B?YWRvZFI0SDUzOGhSL2YyREgrWVE5ZnljaUFOQ0wvR3dMaHFrY3Z3SE9USXFh?=
 =?utf-8?B?dU9NWDJwZlZoS05UZzVhS1hRTm5IelpFa3d2OUUxTWZhTzBXc1BDM0ZrNkJL?=
 =?utf-8?B?Wnl1UkNUdVlHWFZJSHBUb3hxcS9qUkVvd1NidElCV2UzaWdxWjFKaUZCaXN3?=
 =?utf-8?B?Z0RZVVNyS0wxMXhYMVNCOStOdENPU0lSSkx1c3NhWHRmMnU5Lys4UzRLRzJx?=
 =?utf-8?B?NUUvRHkyUE9TTHhicXNTekI3VldtdUR2Wk5hTlVTOTZnYSswOEsxcTZ5bVFi?=
 =?utf-8?B?QXdjeXRsSUYremQyQTB6cCtWZENycVo2bm5hQzZFRHV2dVQ1amNGWWhsSzdN?=
 =?utf-8?B?Q0N0ejRwUjFIUzdYcy9mdHBFejY5Q2cwRmg2aG1FT0hHQ00xNitVcUphYkl5?=
 =?utf-8?B?VzZiSUdzSlFoYy9PbXh5dzFteTR3T2UyVUlXaTdKdjgzVDJMbFE2L3JYTnNM?=
 =?utf-8?B?SXdFa0RJdjNrQkh3SlN3SDBuaUE1dm5pdVdmUWtYTFo2MDI0YzQzb3pwL3pj?=
 =?utf-8?B?cmhxN0MwU3Y5cFNmS2NXbjJlNnJTamxmWDNhdmZISVRMODhLY1E3d0Rzbjc4?=
 =?utf-8?B?MVljaGRDSldnN2hlTWsveGVMQXdNMyt5SUIydTU0ZG5ONWFHNzFUS0VwRE5Y?=
 =?utf-8?B?M2tPbHV2ZnpibkVjYmc0SWEwSXRzekN6MjA4eGNHQmI0WlBJc2dQbytMZkxj?=
 =?utf-8?B?aU1yOU1PcndzdW1hNTl3V3pNM1hyaGhtc3E3Titzblp1ZGk4aG05cTRzbHEy?=
 =?utf-8?B?U2hJL1piWjBQY1UxQzdUZURLaDdrN1AzYUdoRmJ5cVMvQ1dHUkNIMWQxcjI0?=
 =?utf-8?B?dmYzcGM2ZDhDQVQyTTRncGZ6ZFJualkyUW5NanhETWw0N1g2NHhuSm5kb1lO?=
 =?utf-8?B?NlpGVm1nR2N6ejZTSGV4cit2T1JSUVdNZmlJUDdMMTJaWW5jZTZmNDlVS2xs?=
 =?utf-8?B?QVl2T1lCRkxaZ20xcThVSUw1a09XUnpDRHMxU3FqWVYyeEs5bnd1MjQvSVJI?=
 =?utf-8?B?dko3Uk9VVktLR1dkZnFra3hxU29JVDNxblNkY0lwQ0wyeE9SNnRCcW9kRnAw?=
 =?utf-8?B?Nkc1MzQzckZXeGZscUl5dE92TGdGS09wVXRqNUVURk9ieEg2dnRNN2VXV1hn?=
 =?utf-8?B?Q21NcXpLMFQyQXNxRlgrcmtma2VnN2MzN1dJOVpMRElpREFqV2hkQUw4WS9k?=
 =?utf-8?Q?OB5g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDcvVi8vdUtHSXJNTlRKcFdsRG1JUW1hcEtrTW44ekZKSTJ1aUhsV0g0ZGlK?=
 =?utf-8?B?cjZRY2ZHL2l4NWowdHJ1NFhFRU9vamlBMnZaTUlOamV1bTQxMlJJbk4ycTFN?=
 =?utf-8?B?MTd1VWpXOTFiK3BpdzBCY1R5MU9adWFWUVJZVm9OSVIvSEkvNWhMa0J5SlFt?=
 =?utf-8?B?SnQwSDcyUzk0MTRBbW5VeFRUdVFwY3NIYmZSVEpSTzh4STM5OER4RVlWbU9r?=
 =?utf-8?B?Sis0bHZkSFlrYW41cjF2ckVDS1lZMy9TTEEvdVdYMW9SQXV5YW9KYzVMeWpq?=
 =?utf-8?B?VzVQdmNpUmYvS2tOV1c4ZTFIcld4QUE2cHE0dy90Qjd5WTlLTkRLZmFvK3hs?=
 =?utf-8?B?VFluSjhQOEZONnJOSjJVd3RYRmJYaENUai94ZjJ0WHRReFhuTXNRZ3lhS3Fl?=
 =?utf-8?B?U3hFcWloV1ZIb0JUVGh6SXY5K1pXeUp5ZEpvdlZQckd6RTh3N3BuUjlIbjJQ?=
 =?utf-8?B?OTlZVGQxb2ZZaDkvYWdNeFNxS2EwaG1yRExvT05uQ1diRjROOWVjQjNoSER0?=
 =?utf-8?B?bURIZ2lmT0tLVTIzUWZESjZHZkk5R2dNY1NDVmdhalVZQ0hoVnQvQ0JOd045?=
 =?utf-8?B?WkowZTNESzBRdXJUSGI0R1M2QlhnOTMxRHV5Wmg2Y0JGU29FVkowTnBXb0Nz?=
 =?utf-8?B?Wks3YjFmZy9tbGxlMXUwY2RhVHNLbkN2aU9MY2RhT1ZzTEZpMEFYOGVEZHV4?=
 =?utf-8?B?WTBGZXVFZFI2eC9zV2FlL1VvQkdjbitrdDZFUHJCdUZpalNGMTYrc0x1M29o?=
 =?utf-8?B?ZWpGM1NLdU1qUjZSeTgvdEN0NnJmU01SNjdURXJWUVlwZytzb2xZcWJhWjJq?=
 =?utf-8?B?bWNRV2g1cHVsK1MvbGF0c21rb0dBMlVCZEdMNVUxbXVHVkJ5bXluZkIyQ1dM?=
 =?utf-8?B?TitOYVBVcUd1V1R4eFpzRUlWNnVJTE85bFJsd2J2TGR2OVplc0xyYXExWWpo?=
 =?utf-8?B?RVpoU1p3dXN3RnV3VDRYK2dIZVVzTFVXMWZMU2NhdHc0R2pqNVJQV0NFZjRQ?=
 =?utf-8?B?Qy83dmpUZ25JbjdHRndzbTJTUEVRM1U1YUdkNGVuZ1UyekhYdi9uZGVocUth?=
 =?utf-8?B?SVJYdVRwZ2FGMWZueElLNkJKUEVyQ1lqdnRLbUg0N3ZwTVJkL0xwaHBhOVFB?=
 =?utf-8?B?SFRTVTk1Kzk1aEdLd1FkRW1YU2dLVzV6Zi91blJ3QXZMM25YdWZCdFJhZm95?=
 =?utf-8?B?MkM5SVBhRDI1Q1FIbmNTM2FsREF2bVJuMnpvMUZpNSsrRE9XZlVpRHhyVGdO?=
 =?utf-8?B?cU05bGcraEk5UlRlNWlsbkN2UU1mcDE0U1cvVGRSYUtYVXgxSUNDbW1vOWl4?=
 =?utf-8?B?d2FXSmFOckROTFA2aFBsWWlUNTVIY2lDcSt6UldQZ2x0enMvYytyejM0WHc3?=
 =?utf-8?B?Ti9GeGtCVnBtbUhKZ01LODR5eUFFNHJtRnVRNmxHbHJ3OTFuWVZZRk1YUkxW?=
 =?utf-8?B?UzhOZktpSlhyZTNFc0tTdUdxcUpKK2dYRFRtTHg1YzQzRnh4UXVtSktXaC9G?=
 =?utf-8?B?UStOZGYwSjAvaFM1NzFFcHdwdFRWWi9rZkNseTdZYzIwQlJDNlB2MGlIeUpL?=
 =?utf-8?B?emFibU9wUXNhTkFValpXL213UTY4WmdnVkFPZWxZSkVYNStLajVYaWF2VmNN?=
 =?utf-8?B?OHdNZ2pBRjQwV01aMVZiaitQaHRGQTNkTnFmRnVuM3hlN3VVSWh3SVM1a0tq?=
 =?utf-8?B?dis1eW9ZSkNVWmlZTEhVaFlPbnNrRndQVC82eXBHZWVSYmRGVG9wUzZ1SFU1?=
 =?utf-8?B?NDcwUjJka0dRQzA1VU9CUmF3eFdMckFrZFlOTUdJa00yQ3JENXhkdE4rd1Nh?=
 =?utf-8?B?b1IyM3FCa2VyT0dCQWsyZVhFNGE3VjlzWVY1NlhoY3VPNDgwT0s2c1dQa2RG?=
 =?utf-8?B?emlLQ0MzR3Znblh1UVhMN2I1UnZjVXJRWGxibndJbG9lQUpYMURUMDZyNGVI?=
 =?utf-8?B?U0hQOEMySTNndE9YWTU5bGk5WDBaRE5nckY0c3U4ekpUekgvRWErL014ZlF0?=
 =?utf-8?B?THREYU52SUFVK016SjRVSWJQWjlucWxycW54akQ3SGtPLzhkMlhydjlIaFlo?=
 =?utf-8?B?RUdjR2dmSFF0UWNGQm9DbE9nQWRWZEQ1UzB2L045U096aTExV0QrTGxVWVMv?=
 =?utf-8?B?OHZrd1hFcXAyTXo0OUVYMGF2WDdtVGFBTTlxcTVqTFd2aUJzckh1ZkNFU0sr?=
 =?utf-8?B?YnBzdmp1ZGdaL0dwbnZ0bFdZRUpJSnBCZHNFdTZjeHRMMml6VFBocnovWmZJ?=
 =?utf-8?B?UWg0Zkg1NW1wS3lwTnlxS1BPc2tOeFhGTTRIZG5jUTdSc1lpOE9HVDN1OFMz?=
 =?utf-8?B?Rm1QQkorell0M3dBMUVvcFFrT3RvTXM2ZXkrQWd0eEZ6QVZmUFh2QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eccee2cc-83cc-40f9-26f6-08de64361a88
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 21:41:07.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zOlzKhCpRLewKyuNXaXdAP0myob7tP9if1ZyGb4+jJJb5tkpSSWYCKETgHsmwKI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9698
X-Rspamd-Queue-Id: 4079F40005
X-Stat-Signature: nw7zg6xj87nqzno4noigibgetpyr78px
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770241270-549031
X-HE-Meta: U2FsdGVkX1/xer4Vi+OY9ryAS5E9j41mVFcn/blpFAITBJbfnn2NbLuRBrrOJUyNfZnD1CvlLGss1woD3N21nTdmtVxiHVn+WEYtXTmoMce2HyyvkyO49o4EhOuw/E+klgv24AZzbGiCPDrnNGxYCg895gDPaNXhATeTng7DrGy5G+YbRV7wztIV0/8t1o7zLKFLVr4d15vbwkocbvLLbLPfQjZqv026DyP43VOtJOTUkydwIg3Thu/AZ0x56Pun0ga+iWF4jRjr2i2AYH7HAJhn0U8I788rAvndLXr7Qbu87u6F2AAH/jhTzaO7x+Yp0fF62t4cMz3gSMXs8P871NczHz3X+21832PSewhwqptL+ZMlxQTISaeD0DtppwaFh8FADuPvRT28U6O8NG19c4Hj2LvHibUS+qHgnBDsy20P9/Xn2ZZJcbJzUlM8g8J3/6VRSpKkateu+vCifWMA7dMNBb6769Q3ZhCiIkeWDacUdzfk3onw9CDqhMQfkAc4cAn73V8fMSclhiY+qZj9tJ9IA4ZKOG2SkLfagbYPuAMc8W1+kfLOcyX6ifGNXc6LC/V0+t/X7PM5Wvl4xgby+ybQXlLECboEZrYd+AspNBRnZTXtRdynjAppnQ5jgCKWpjQviRMXQ/vfNJUBvseoYJ8CqAE20xBNogl+FMQgt6wJLs/xobPiCOVP6YCNLaT/u7PVdl6BsC9+UYNCajz+qPrilrNSZXHMgTgv/vEBcYePPWfOX11ytSkyD8BTEkWPKrjw6wR9SCHWwrogdZw/Xmdlfvg7UOcCiV9dzm5FXmbmasuhqJfY16aOClegG72HDJtGjqUBDC9qkzQDo0QrD+oGhhTb+FqCqYEpZO3h4YZ3BHPZJilKJTTjAtbO/xPre+C+2ZDd0CEhGOeuVKERAaeMEc/keWY2RNZurqqeEahI1XS9wngtgQM/5p2tGNfCs2+17AHedJ5kW+JLJsm
 XJ37CHLb
 LUH8nqfCY4dmz3p/K5KqD560bKAP7Syo89bkIo39nBrVOc0ALwp/cDzRMUNqXEJMW2Q0mxsGtydK56U01HGXhTZycWQFhmZKwOLY4Zd0CP3cWGhsakmwtng6DuFXi+1cSLklCe3WHiGGh2S8vXN5eKXgvxYraS+e8ib6NxcQpwCAPs4/2OtURqvfLZQzBQO8p515RVbT3UB76zbgnv5osz4smn8LLMfY1yN/XvaqFWbi1oCKZMm6Z4K4wg8JPjUTIg04dpI194m9Az2wFN3Rssk/4BzCwnjs7PynvXU+Mdzix4kF49GhqGXkNYb/Kv1RDRzeeK5bTFyCl5UsPN6snH7QFs1bk8J8t3whEauItP/EKzs51CQLIDe4OApS0DtdOrh3R54ry/aTQXLqok9UqNZCS4tN04Nc06GVDubYT0t/JA6Ar6+DI525jlnd4wLB22f7B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 16:37, David Hildenbrand (arm) wrote:

> On 2/4/26 22:08, Zi Yan wrote:
>> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
>>
>>> On 2/4/26 18:41, Zi Yan wrote:
>>>>
>>>>
>>>> More details:
>>>> later at sg_vma_fault(), the driver just handles a page fault by suppl=
ying
>>>> a subpage from a pre-allocated compound page[3]. We then get a large f=
olio
>>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>>
>>> We can identify such non-folio (but compound) things by looking at PG_l=
arge_rmappable IIRC.
>>
>> OK, back to the issue. The patch below should fix the issue?
>>
>> Hi =E6=98=AF=E5=8F=82=E5=B7=AE,
>>
>> Can you test it?
>>

<snip>
> I think you have to test for folio_test_large() before testing folio_test=
_large_rmappable().

Oh, forgot that. Thanks.


From 8dda4bba9964890462eca3ef3cce57bb4fab8313 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 4 Feb 2026 16:04:19 -0500
Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound p=
age

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/memory-failure.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 825c706ac576..137c67fda57e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2440,9 +2440,13 @@ int memory_failure(unsigned long pfn, int flags)

 	folio =3D page_folio(p);

-	/* filter pages that are protected from hwpoison test by users */
+	/*
+	 * filter pages that are protected from hwpoison test by users
+	 * or unsupported non folio compound pages
+	 */
 	folio_lock(folio);
-	if (hwpoison_filter(p)) {
+	if (hwpoison_filter(p) ||
+	    (folio_test_large(folio) && !folio_test_large_rmappable(folio))) {
 		ClearPageHWPoison(p);
 		folio_unlock(folio);
 		folio_put(folio);
--=20
2.51.0



Best Regards,
Yan, Zi

