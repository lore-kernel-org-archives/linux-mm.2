Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B823EA795D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D4E6B0089; Wed,  4 Feb 2026 22:40:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DA86B0092; Wed,  4 Feb 2026 22:40:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4428A6B0096; Wed,  4 Feb 2026 22:40:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB406B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:40:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB18A1B231A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:40:33 +0000 (UTC)
X-FDA: 84409000746.15.C74407A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8407160005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:40:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="bJAkR/2A";
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770262831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xobpAsNfQBJPn36XL/ffhcsfVWJjob5rYkyPVTMN8ns=;
	b=6VN+chGeVVLIsWML466zLR4fY91jQctD0zkQOFAkhAwDAaJUkBJwJsZzfRTntLyFVaE6lH
	0n29wZSEzXD7zyVb7prQPpT4WiE1OzMgiLI7B/dUh9hyxCNHhE9TvFVU1xqBdxZArWFn65
	+O3HxuY4gjg4hMH+FCSY4JOQ4cod61U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="bJAkR/2A";
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770262831; a=rsa-sha256;
	cv=pass;
	b=17V5FM6lMTqtkJSHYI5cRrrAvJt4R1g0oI63tfS3sG3FoRmTNR6HBJ5V5IFgp2berqvI3S
	VgFjhLKO7FNy5LToWVAYLUT1zF4j5mllE7pNGxupuTJ4CQIN9fjAWkG/bdGjjsbXRHhFiJ
	9KZNPIcPQP28PUcANdIQLfZVYmFvil0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=paySVdVgi9cZfXIGHCWN/dFcxI68BdSCd4qgcsM8rCnZEBWcXUC7tNyR7bvw6tUvvepbkePN1Rd/mVmcCD/dPNZlch+JOuIarq7Cvb24I3SsnPif9ZqRgYis31huPDTk8HW8s5Bwri96HLta5n5DRSTI0O2I5E8pO1JQPkYDaugdPDt0JVzgepG85pbTap+hPcpAUtzpgkR1fVt800pctTIFzF+J/kl9xihJHiSqhSObrUv4YjGnXAZ0CB08uHUkWB09+Do962y3EOaQaiIQv8KNhh+Dx5J6xli99k+K4Nqa8icZGVWGYvZh22fVVIjGj8QLUOZ1b+vGq5j1KEBkKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xobpAsNfQBJPn36XL/ffhcsfVWJjob5rYkyPVTMN8ns=;
 b=cfUD3s29HHS+CU/J23MORGY5VvE05O9ElNjSzb5j9CTsJNBhuXgfQfKm1k+ENT589UJ/JjTNb8lo2QnysTki5QBb4LWkLbwJqFPNZm5mrduoi82hdWH3LVtqei/PbfNE7SHpTskflhJip5RtuLbWrRzqpBAwFB+/iHlIMG4Z/iwDwA5vmLcWqORBNGPM6b0rbhKuLYAO5D55UzDH9YAdrVjh7cYvebs8zlCKeIacQH49rQjIuGa3X3I5YIshkda4wR92qa5YorBwSpu5mg3rUUuvLPv4raqx2wX8/Y6knjmzOxDjExueiDExqRD8I229UrCBRyLbqbINyKIZKrR1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xobpAsNfQBJPn36XL/ffhcsfVWJjob5rYkyPVTMN8ns=;
 b=bJAkR/2AK0L2qoPjhhStCGZNQagqTmIa/t6Un8lqZDToy3ITzhXO/dTBh1lxIkGR3CO69/JHgJvKEqfbtTtTxXsN+UlkmPb6EyY5U5L9Ca7CGqqo9A1JO4j1cQIj/qe4U3dH16B4QLYxnryxhBdc4fD0xA9WSgu899t2uIVhdUsOxcELWamcozkOAxy26FT8uLUb3GqcwT+/bmozzZ/AfZ0/aJhIMK0MNRRlAl/b5R/hwC+Jbk6G5x4nIWWkFj6M2dh5V6xHBdBN37e66IhkxVu+CAxMdLhVWGEprBa4VtDe9h3FINjlZqzb2RsIiIMHCUoLA9H8S4YEH89zKLUckA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9079.namprd12.prod.outlook.com (2603:10b6:610:1a1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Thu, 5 Feb 2026 03:40:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 03:40:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Harry Yoo <harry.yoo@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>
Subject: Re: [PATCH] mm/memory_failure: reject unsupported non-folio compound
 page
Date: Wed, 04 Feb 2026 22:40:22 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7A895A79-C569-4EB3-9C4D-75C1635B9DC7@nvidia.com>
In-Reply-To: <95bd5396-256c-58c6-62ab-ae95e0cf371c@huawei.com>
References: <20260205005603.274383-1-ziy@nvidia.com>
 <95bd5396-256c-58c6-62ab-ae95e0cf371c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9079:EE_
X-MS-Office365-Filtering-Correlation-Id: f0192444-7c67-4c59-e06e-08de64684bf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WklFNHlZRjFHZ0JiMnE3OE9jLytlblJIMzRJaXBvRFh3SE91cmE4SFZRNFlx?=
 =?utf-8?B?a0FBYWQvK2ZzVXM5M1lobUJZdnNKcWkyMXpVdXR6UzNwRWRuaVJhK2NsM2Qr?=
 =?utf-8?B?VEgwYTBndWkwQU9UWkZ6SDBNQSthdVZKMHpNV2UyWXJlMjJXR2ZOdTVnblBp?=
 =?utf-8?B?QjJMMFF0ZVlmdDh0N2JKV2w5N2xKUTMvL1hJUVNiQldsVzBYOS9pRHA0YkdW?=
 =?utf-8?B?V01zaEZBUVRZZXNtS0N1bWZ1ak01SEd0R3kzYnRJT3ZVWmRRV0lmaWxXUjBp?=
 =?utf-8?B?cGRzL1FaL2UvakZ0eGtFNUpIY3NSVmVSa0dVU3RsL0dmWHZDcmU3MjkvcjJD?=
 =?utf-8?B?a0ZUNUtTRnhCQXZYYnpkTnd1M3Z1TWlPb3ZoOEdlSVZhYjVVNGJCdFFXMnVr?=
 =?utf-8?B?dHVnOGVKTEhvMkthTXNwcjgwRDJRK2NZOHlCZW5ZSUlGd04rMFNVMi9zMzZP?=
 =?utf-8?B?SXpHQ3kzdE4xN25FeGlmWnZ2S0ZCM292dWJwVFRzTXFLSUtmQmdEVjZROGEr?=
 =?utf-8?B?ZVNFRHJtcVhoUmhrUXEzekFDS29OZlgzcjFIem0ycWIyTGZ6bjZrS2xEUjY5?=
 =?utf-8?B?VGNXemxmSXlwM05kVlBjYVJ1ejRnMWJHV0NuMWlrVDNYZUlDV0dtYmI3UzBB?=
 =?utf-8?B?Y1pESUpLKzBuWnVaWlh3SkNnaDRDZGE5U1BMM2NVSFBUcjdkNzN2YVNOOWhI?=
 =?utf-8?B?d3M4cVpvVk1JdlhDSjVwSlZZQmN2QlQ0NHhlMy84NDBrVzNPY2taMUhEdkJE?=
 =?utf-8?B?SHhuOE45VWFUWW52UXNFVzVadHlwTDVraElqR3RJQTdsNFFzMmllTnZMQ2I5?=
 =?utf-8?B?SlpNQzVSQXdROCtiN2VOZngyOTVJK0M3VmxvRUsvbEludThRNkZWOGp4MGx5?=
 =?utf-8?B?dzB0VnpBYXBWMEZMUXQ0VCtXL21NMTdSenlrdU16b2RVbkNaUGc5Mm8xRVNB?=
 =?utf-8?B?eUFoY1dIbWg4SisvN3ViSnhDbi9mak9UZE01YllHaHdKRHBGNXpjM3ZJb3dk?=
 =?utf-8?B?aWdjVmd3U3RybnNKQzNNSEFMT2N3NHh6REJlNE5ETStMcGxGZmh5dmRLdzQ2?=
 =?utf-8?B?dzMvRk9QV2NOL1pnNTVXTnVQZEU3UFBrT0VpYS8zRm1OckFPMVhKV3FGSk1C?=
 =?utf-8?B?UW16Z3RZR3hya2ZWRmpCamRlM2hNU1ZZN051bEJTZUlXVmJMN0xpMW5yaEZE?=
 =?utf-8?B?bXJET2hBTm1Cancwcmp2cVhtaFE4RUpFWHlpd2lZRHpua3MzU2tHUGt1WWhC?=
 =?utf-8?B?QU5GSEg5WjZhaU05M2V1NGZRV0xBUkpXNEZpTWlybDhqbG9Sb09FaGxrQUlI?=
 =?utf-8?B?a3QrY0IwbC9mbWVFdjQ1Y29wcGtkM1pITk1Gc0NvUnd1TEJTOTZwbFVvdHdj?=
 =?utf-8?B?L05LdDVaQTA5WVJtRnBndEc4WEFxVUdtcHVLUXkrZFF3cVlkTlJuRnk4OUoy?=
 =?utf-8?B?YW1DeENZUFV2Wk5xRmZjUzh2RFh6c1Q1YlpnUXBVY3RwVWVkOW56MFdRRjlR?=
 =?utf-8?B?ZlY3MGlDTDVqcnZnY1dFUEk4VlExczZ1Syt6TTl3dDk4Qkd6eVNKZUhibFVI?=
 =?utf-8?B?UW9SR2tEYmVKdkdHMXMzaFV6TWNWY05iSWJKWVYrNDBxekdCeHh5TVgxNjY4?=
 =?utf-8?B?SStzYmd4dGlvb2ZzTEZmcUJzb0pVcE9Od0NMTWgzZ0lyczdGSVZqWVRZdFZh?=
 =?utf-8?B?blp0R25yNFpia2wxaUtObFAzeW1FRG10OTRQWW5idy81WUN0TFQxOE5Sckd1?=
 =?utf-8?B?MkZsckJyOXdQZUkxQmxkQkRaU2djS3ZCdndSZFgyOHNKMlExNVN6dVVyRkpp?=
 =?utf-8?B?WmszMVBwb2REaC82UnBoMlQ5NkI3YlEvVU5LV3NLMCt4bmJlR0RhQmk5cTBr?=
 =?utf-8?B?U0FKZWlDWTdNMWR2UWVDWDh3OEd5aVdLUFBTTVVrRStpd1pTQWpnVG5OcnpK?=
 =?utf-8?B?Nm5OOTdCc3N3emFHZEM3WHptZmRoQVNrc2o0eDdaVDczYXc2WVdaS0h0eUw1?=
 =?utf-8?B?em5CdjZhaXdaZnpoTlhMM0l3UjlhRm9lNTROaEJRaEVrUEI2UmdIZ0FqcDFy?=
 =?utf-8?B?N25kWjIwWmVqSUVwTXUrcktEWmdOM2dSOUQraTF4cU5MVzR3Z3BqS2dHQmRj?=
 =?utf-8?Q?ljDIf9oV09ZOLIgIAVQAf3BNB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0ovQTNjUFJnUGZHK1RCbTRhcWY1MVhuaWtCRWJ0VnhsZURBSTlRcVJzU0g0?=
 =?utf-8?B?UDA3clJOMUdHY0lXUTlha2VJbTZ4Z2x0MTFXTnQzU2NzYlByZHpsZTdFWlJK?=
 =?utf-8?B?eXR2R3VJSDlYWExneXE5aWNRaHI0bnRZYjB5VVV2TlM5Y2xLTkRqRGpqbHlY?=
 =?utf-8?B?VXhRVXpWUDYzbUVYOEsxZndPakRsN2xKUzRTS0FBMmhENXJVR2V5SUxBWTEr?=
 =?utf-8?B?U0FLcXhUemtWbEdQN0hmdzJONGRCL2k5WlY5b0ZOekhUN3hkWlMyazRCcmo4?=
 =?utf-8?B?R01MLy8wbHlpKzhISEpmS2ZRZGFWVmlyNEFzSEtBbFYvSGJPbHIxRGREUERB?=
 =?utf-8?B?UERGZjBHVjE2eldsRFIwcjJRUHRFcWxIdGd6OTZxblJ4OXFqYmlnelBxdmhB?=
 =?utf-8?B?OUZiVkRxbURMRm9Hd2xhRGdoelVRVVVvRHZkNzhocUI0L1BlNVVsN1l3WHFO?=
 =?utf-8?B?RE9Ob2NvSTJYdnFaUkl5bVZBVHdscFNWV0U1a21meFEydEUwUTQrRGE4VzJr?=
 =?utf-8?B?S2hkeVZLVVRza1M5WEpSNE9BanQwWExxYkdJT3RuVlpFRURSR1ZFQ25WdU1M?=
 =?utf-8?B?TENVMnozY0xqMkd2RkNTQVFiNkRwbTRqYUtNNGdyMWlZWkJCc0diclRwK3FB?=
 =?utf-8?B?V0R3UVBpVG9KZVNsUUFvM2cycE9zWWxKWDZGS0g1L3RsTElKSGJVb256ZWxt?=
 =?utf-8?B?dllKaXZ4UnNJMThnRWVVMlc3OC93dUJvb0ZqWG84UDNSZUtWV3FOUUVFSEFU?=
 =?utf-8?B?Q1B0RkZUNDdZMlRXellacTlhdzRuUG5lK2VhVU5lODF6LzgvMXVGbElpRnF4?=
 =?utf-8?B?WWNYNVZYVHlUT1FoQ3RaeTZXQ3I4MXl6dytqVC9ER3hrQ3M2QzV1SmlxU3ZD?=
 =?utf-8?B?MnArVU5lb2VtWE9BTlhWN0s5Sy84MlgzMGdUdkh2VXgxbXErMDNzV0JHaWlr?=
 =?utf-8?B?WkNxbXptS3RNZWdWVitMOW5jR0NxcGhXMjlEelBuK2M0Ri84VmNwb2FINkhY?=
 =?utf-8?B?OVZiNEl3T2FzdnBIQTg1Q1VXQ1NXS3dMeWlacnN2TXJGTG1ONkkwanBPM3dI?=
 =?utf-8?B?VFVwRXFHNXdhdlV2TEI4R1JiNnhKVmlBSTcrSGJsOTdLdW5uSUxILzhDdTVW?=
 =?utf-8?B?Nkw2YUpYSDV0QWVQSTB0Sm9SeW5XZ214QS9PeFQ5dU1XVjdsTVZWQ3pKK1ZW?=
 =?utf-8?B?Z0FsTmU3UUI2ZFRacnhZM052VnFUZFZuYjJWRmx1b2s2V3EyMlRKRHRYZjZm?=
 =?utf-8?B?Vm1NWnRYT2I2MlBxUUQyUjRJdjVCWm5RYmhJcldJc0pBUDNZQXQvZm50UVRE?=
 =?utf-8?B?Z3VMUmsvdE9UU3pEZTlEMXpxRUFmeVdYL3lPWW1KaDUrUmhQWXpkRDJQN25o?=
 =?utf-8?B?aEFGdTd5ZlZaUUtabTVkc1o1MmdkYVlidEc5VGE3Q20zU0pwZ1djb0RMYTQ0?=
 =?utf-8?B?N1ZQK0JJN3FrOEJ6STEvWDU4NWxrbU94d0NWMUhGekJ6bnJwb0J6b09FNXNU?=
 =?utf-8?B?R3F1RjdyeG1hNnc5SzkzcmVpUVRBZ1dBeWxFZ0xNbk1MUVNNdW5YbkQ0bERQ?=
 =?utf-8?B?MzFMRm1rcjVlMUNhSzl4enBNcXh0RGdQUXNRYlFqcU44aXBKcTRUTVlGcHVJ?=
 =?utf-8?B?RVB1dkNqS0VkeWNNVEgzaW5JcEtaREZYVGpiV29Ra3hBN3I0UEJaTHlJOGpp?=
 =?utf-8?B?aFk1cFdvMXZ5bjZjTU1ORyttNmtrMmwvY1FINXoyR0FualB2N2libTFrblRr?=
 =?utf-8?B?NFVLUG9oSkdRYTRnZk1xOFREZGd4L3k3QVZFckMvL08zQkR2c01NMTJLek56?=
 =?utf-8?B?MktZMnIwaS84T3IxSmlZYzdYVFR3ZmVwSU1DU0F2SmNCKzBIUGJWTkxLM0xv?=
 =?utf-8?B?NEJqckdwcnBCZDBLTG5HUmFLR0U3a1JTTUd1TjdzRlV6RzkyVS91UlhEVGl5?=
 =?utf-8?B?Nlo3dU91N3c1M25EMzNyTWJTUGttWEExekJleTJ6bUxtWStNcEp6UHNtU2JE?=
 =?utf-8?B?RWh0Nlh0L1IySkNVQjVaOHBZQldHWWN5YitHSWhLUU1STTcxNkpMdXBwNk42?=
 =?utf-8?B?MDIyUUVxQkFtdU8wN1dKcmlSbWZidWJnZXlHMXdaZWVWK2xZd2h2M2FNcFgv?=
 =?utf-8?B?dzU3U054TUVsai8xMHFDcnZyT0c0MGZzNmRYb1Flb1g1YVZsMVhYb3JXaVlQ?=
 =?utf-8?B?ayt1YU1oSkVJeVk2TGRWMGorY0VZMThMTTV2N3JMM1lSNVllV0FCeFZIWmJu?=
 =?utf-8?B?RzRldlhia29lNDJVMitIREJqaUY2bGUySk1mZk56ZUJkN05ONTFqTkswWkdT?=
 =?utf-8?Q?J1ZmoSakJTKEU8lxFQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0192444-7c67-4c59-e06e-08de64684bf5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 03:40:24.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16ALK6wf2+FLZcSQliVRigEWMO3d9UNtuXaVyaZfBLfixJ5LXfxZwcEoaymwttio
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9079
X-Rspamd-Server: rspam11
X-Stat-Signature: qunrskoqeq6g6m7py9gabpe54etsqchg
X-Rspam-User: 
X-Rspamd-Queue-Id: D8407160005
X-HE-Tag: 1770262830-524211
X-HE-Meta: U2FsdGVkX18056RbuiYo8KTKvwYxPRFE/yzXAggMNK2hMRKbOJno6dSoiEOFhoisyu+yw6AlvHDSwLNy2D2BcHlbW2chJl6gIyrjtb9hPyLhJMpJXSFZ81giQzI4b7M938JdWArgG6+K47pT9VDwrM+G0hLonrekuUvkk5hPDOcFIjNUftUnPhVzysz2M3lDywQRzQILF5r5XgL2DXybHasaxy/RY+hNFNbZurYGQksuhwMkjmoTQf3oPH8/owF0c1wn0Oxk1XMp53Ln7iAgVA+T+Bas+hPvggj+OuGs+KdpmqGObLDYHA58POv49Fym5upK07hFkvKsZl/WZLOT14ZnJiZkl8iVOdIkkDRp4HQOI8siANix69Tnrvzm9GFd30UvSlLppd15xakZS9FpwcpSSAfsEetOC8Xp3Wgmo0FxJyvI2wmPheYXqe+8DxyuNpfdeaQGF8k12mcnveh9R0WQY2KXdn7XA8UlOR7BRQlnQUhiOfT9bIuxqkxk2/W9AXy3CGEqYBpmOo4sHm3LEVcwSSoNR8nPyApHzBFthNwe25DLbpNnOrX1x7o3AdJ6iozPUuy4ABnxZjsHh7Q/dYMxgibq1EZ7PKxq3Xu1uQzal/gyblPauTBurEwugVUDLy8GkH5ODcnUSSOdl6a3kI04Q+4V0WR39UqPPm/M/aikJJkNBPD+Av5ee/PVuBGw4aNpP+0cZHRO67jJp/59rJt8cvQxaKAiME2/sRVap7kS5kA6xxOQBWfOA7xbSkjur+XFrEm2eSFX7JWHJmLps6+3oSZRm+o/ph7ZgP2RtdIFdMA0VrtCR4xQDyS/BCeQpxRxfyKi9TEbEVqi1ud61IACUvpBf71xLx7mPL354K4NyApLcqoTagtQQLSz3ubv7+mIdtOEBLvQzX0HiCrzD7zbh27NPord1wcZZ78AMP4Kc+cGOuIoCaAYkPen8w9ZwWu4Ro65hsGiYI4HEmX
 4K8+RiIi
 wMfmlLnymm3c/xNwbMPchjJX/E5ac+dwa31HfwXwH8H8tNHtu7SttV00XMp9IIKmQHVGFMJv3VvX8eTHVjanbplRD738w7NCVikxFvfSwYpbdtS8u2liXe8RlZo6gUtUMyNxDihJTOeKtkLDaigUfOmJ9f9yqUhds2lzzuAatjmkLdPS9Ii8KwsO2xzgvd1rT+rqwzIFZPYPq4Y1LeiXezBTlx0y7nmak4JdoZaNAj8IACMKYXYYb0l8AOo7F1BVkyJwwBYKRgO0stg2P/wJlx3SacZ3wD9WfYeERInW7VFIJ7gIn0CunMzZjz+RCNfPoGhs1FV6BBRY8LidIWqJUUf4+ppzMcf9PvuacS+tcvkf4hwBj5J5b1NRPF/oFYkLKW6wPRwD+badAiaNl4zng3S0gaXJe8lBDZSMB6kz+MkvOX/PcFGFUolE8AGg1jP0qfUH8zJxs5cP+V1d2qzXoFPV75a5N/SsoHOOkMRfgay4Y6q8mmc+fCuQLfIbucsklmJ+WuX6oVNk+dGUVn5ZofJKX59VuHyOer6BmRWq9jrbYv6rAZgZ4bDC8WLtY5u7dtF8kSsIfdtZz0lQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 22:25, Miaohe Lin wrote:

> On 2026/2/5 8:56, Zi Yan wrote:
>> When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear =
in
>> a userspace mapping via either vm_insert_*() functions or
>> vm_operatios_struct->fault(). They are not folios, thus should not be
>> considered for folio operations like split. Change memory_failure() and
>> soft_offline_page() to reject these non-folio compound pages as
>> EOPNOTSUPP.
>>
>> Add PageNonFolioCompound() helper function. This function is functionall=
y
>> equivalent to folio_test_large() && !folio_test_large_rmappable(), but i=
t
>> is supposed to be used on struct page. So open code it instead.
>>
>> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio =
handling")
>> Reported-by: =E6=98=AF=E5=8F=82=E5=B7=AE <shicenci@gmail.com>
>> Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADA=
B98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  include/linux/page-flags.h | 16 ++++++++++++++++
>>  mm/memory-failure.c        |  9 ++++++---
>>  2 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index f7a0e4af0c73..2fe8047f42a3 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -1102,6 +1102,22 @@ static inline bool folio_contain_hwpoisoned_page(=
struct folio *folio)
>>
>>  bool is_free_buddy_page(const struct page *page);
>>
>> +static inline bool PageNonFolioCompound(const struct page *page)
>> +{
>> +	if (PageCompound(page)) {
>> +		const struct page *head =3D compound_head(page);
>> +
>> +		/*
>> +		 * Without CONFIG_TRANSPARENT_HUGEPAGE, PG_large_rmappable
>> +		 * should not be set/used.
>> +		 */
>> +		return !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
>> +		       !test_bit(PG_large_rmappable, &head[1].flags.f);
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  #ifdef CONFIG_MIGRATION
>>  /*
>>   * This page is migratable through movable_ops (for selected typed page=
s
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index cf0d526e6d41..8b6b5950bb66 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)
>>
>>  	folio =3D page_folio(p);
>>
>> -	/* filter pages that are protected from hwpoison test by users */
>> +	/*
>> +	 * filter pages that are protected from hwpoison test by users or
>> +	 * unsupported non folio compound ones
>> +	 */
>>  	folio_lock(folio);
>> -	if (hwpoison_filter(p)) {
>> +	if (hwpoison_filter(p) || PageNonFolioCompound(p)) {
>>  		ClearPageHWPoison(p);
>>  		folio_unlock(folio);
>>  		folio_put(folio);
>> @@ -2945,7 +2948,7 @@ int soft_offline_page(unsigned long pfn, int flags=
)
>>  	ret =3D get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
>>  	put_online_mems();
>>
>> -	if (hwpoison_filter(page)) {
>> +	if (hwpoison_filter(page) || PageNonFolioCompound(page)) {
>
> There should be no problem in soft_offline_page(). HWPoisonHandlable() ch=
eck will be used
> by get_hwpoison_page() to reject PageNonFolioCompound folios. Or am I mis=
s something?

I did not know that. Why does memory_failure() not call HWPosonHandlable() =
to check the input
page? It looks to me that HWPosonHandlable() is more appropriate than PageN=
onFolioCompound()
here.

--
Best Regards,
Yan, Zi

