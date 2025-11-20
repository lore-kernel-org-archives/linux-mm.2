Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE892CF8863
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409DA6B002F; Thu, 20 Nov 2025 09:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1D06B0030; Thu, 20 Nov 2025 09:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D12D6B0031; Thu, 20 Nov 2025 09:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 187656B002F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:42:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A440A140186
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:03 +0000 (UTC)
X-FDA: 84131250126.11.4D2A12E
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010004.outbound.protection.outlook.com [52.101.85.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB5BFC000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QFgxV6KM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763649720; a=rsa-sha256;
	cv=pass;
	b=5M/2subrSBFNJ+3hTbUDfPjXIpQs8a/ubGcxkdCGnKLQ4lmT7KqWQGrY+Y6BwnJLajcUWJ
	G7q33i3XvLn3INDRyvP3aEMcjUWzyarQ1KnWUYBVjhTf5NRgUZ/ajJ8p0ag8KecbhaTl3M
	rgI+TBDNUT6w+gdY9ZWHqb+BqOI4MOc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QFgxV6KM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763649720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjT+pG2My6tGu6B76CRjITiAVYw5mj7k8WGF/HGEonk=;
	b=Js0UzicDRrwnpmHgYgQwCwlwNHZ91WTEmrYC/AQCWB6/ZvusOVNm+34LyabvcfN5yILYff
	Vp0KkKjf+sI/EDhUfEqAG+WCyfpocWVDEgEONqaEo4vIY7pT7jSf2hZG4637q6vyKi2dkm
	ATGZC8fVXI2EBJ7pks/T0Fji3xoJ/Hg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KL2z1zDk6nDENfxFum1RW94d0gzyGCKgvxzrteq7ZaCuIY8Cn1t1DOXcyTtf6WzYJ2Q+VGMnkwI3KEwOh1I9R3Tmq5lmm5ysoTCUJsNt4y8fKeVwDB/jmM2R0tmc9V6dTf5b/nG3KqK+UkVT3y7183Z1YU/fDGOkN+t2r+uW8DhR/aeui8d93S3n0BK/uEFB+qiVQd1fiJKX/vhi6/CtGjxm/sAP1xRk2hCu1/n1N0k5/ZZ8MXPm0m7UNq6khU3tcmeOv2WpjhIrQXjAbPGp9nSGQfYiBEaVCyMnNAgzBTQbK1uHeBQftlNHZAv2UrRtNUc7SmXcWnVtFViG9XW6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjT+pG2My6tGu6B76CRjITiAVYw5mj7k8WGF/HGEonk=;
 b=o9L6s4k6TA3Mqut4cXG4Ohyu2X0gl3ex8LkAt62bM2VzDmpZcpPHdUp39wCfoQd4W+n+lJWiRM2wSo70vwv/a+uf7jYioXfmnfnSKG0eZIgwAJNogGhDCFz+Ggy9iAKEf/4Bfc3ifAF4eNMwFQduM9D75LEkra5ycHdu/iGv7aUMdWU4CcLVJC76D/Kp940UvCOynwZF49zqBooOFlLq8+dt+VaMHy5XNxGGqBj8vqIT6eRfZOy4ZnROG7ccXPadSBCZ9DIF6wfqyYiPBaIv/BJZNowuyNAQO3u7QpvRIZxKLmADF8nusOMng1mtuEkpKSmS25zf5SiXEr8MSt7BzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjT+pG2My6tGu6B76CRjITiAVYw5mj7k8WGF/HGEonk=;
 b=QFgxV6KMhiHVk8bvlyvup0PfQ9htf/9yGoNVYRxbTvuipWcEkJky+lw8xeMOI5nHB9F9mteTUXQUtjifGf7w3HdMyGMVXl0+S6e9lvmIPVG5SUf8n2GB4+0UJNWPSy3q1icqgOkFDtQVQoD2iSyWl7Sw0aNWqKXYTCmZi2h0LU+obrExGeI1yJptzUwfX7IRganO99SEWRWDppd+M8VkDf++xBbfwCH84DQisHM0pBvgKliuo21d6X6jcjOgZdIHVVJBNPbxQufeAzQQuri+I+8WHjPUp26KfsLTZcyoHpqQi4veYgGakeZSF0iRGYOT+xjrMhwHn++oONJnC0ZL1Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 14:41:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 14:41:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
Date: Thu, 20 Nov 2025 09:41:53 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FCFED9E9-56A9-4260-8B42-D0BCFC83C506@nvidia.com>
In-Reply-To: <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
 <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:208:52d::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee8bb68-0b7c-4358-724c-08de2842f3fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QU5RQ3h3WjJOWWVCWFZGS0o1NmdYbWVycmRaeVZ3eS85ekh3blRlYm52RVpG?=
 =?utf-8?B?SkREL2JoNlZERVR6eVdWb2NBZWpYclExTFc2TDl2eTZLdmxvRkNYcTRTRldi?=
 =?utf-8?B?Y0ZOeDRqRzdEcWIrY1lzbzRxMmJwZ3NYeTFFWjBxemlWQTg3dlpJbTdzaFpz?=
 =?utf-8?B?eEZHcE9tck1NdE9KY2FWd1dQbXV6djBITTM4QVdhUWNKcnc3Z1VyL3UvMjFD?=
 =?utf-8?B?L2VyWGZFSFgrNUQvNnE1bXRNb1h1OG5LUEhXWGhoYkJwcVlBWTdocmlaZEVp?=
 =?utf-8?B?MWc1WHRlYUxpWE0vSm8vb0g0cFQ4TjJmdnJ4RWpNREtaWGlGSkxjdnptU3Bn?=
 =?utf-8?B?Wk5kWE5hVFhtelFkQzBjRzY0c2htQWREYW1oSjZoNGFCUmkrOEQvcUU4N1Ru?=
 =?utf-8?B?eWJIMmJHRXlMZHFsakc3by9oOXZVL0ZJYjcvTmlwa3BVQWRJQnlLV3RJakZX?=
 =?utf-8?B?b3ZHd2huNmR4MG9kek9KNzBWWDNuaitwZ0kzblNJdnJmUG8zNlBKeDlsdnFM?=
 =?utf-8?B?ZzBTdnBRTUNMbmhsN2hHWUQxWUwvU05jcVQzbzY3aEhTenhhUi9FeXU1a29I?=
 =?utf-8?B?ZVhkN3BlQjMzckJPclBrcDlNdlFWTkdMRk4rYTBqcGxEZEY2bzRxQk9lSXRm?=
 =?utf-8?B?V01xUGY1RzVoMjg1TndFcmNCa3JJVTJXWWhkWm5NaWVSZUNDdWd6M0lpOElU?=
 =?utf-8?B?dGc3dEV0MWQzRnJSSC9PR25JVyt5R1VZWmVNQnVBVDQyMUZHZE43dnREZzVa?=
 =?utf-8?B?R3laNVhDUlJMRmpiVjNlTlFrK2RKWWtTdDdJQWlNSXdjY096MXVhU05iSGUz?=
 =?utf-8?B?T1F0VUpTaVNQQ1RiVG8rZ20wYnlGM0V3eDVSRDRyYkxtM3I0VTMxTzdnS2d0?=
 =?utf-8?B?UWVxNnR6QUxiQTVNK0FhNWlwS1AwUS9VOERnMUVYdmZuWmVadTNwUkc1MDA5?=
 =?utf-8?B?dDh5UjUyMzNxTDl5QzA5a0xQV1hPTlY2M0l3c2hSWHVIVkVhNGo2RThjcFVt?=
 =?utf-8?B?WGpqdzRYQkpTdlJPUUZ3TkZNb0JOdTZXOTZKSTRBMkhvbXNGcmpEdkJOOHNz?=
 =?utf-8?B?QTNaOEhpVjNQU1cwOGZrZHNyd2dkMWJJZnVBTktWSE40VEJOVGtkbTJ3alNo?=
 =?utf-8?B?YTVYT0QvaVBPOWdpL0FLM0FtcDFPTXNFK2NxRi9ya3RNazk5b2VlTEdsdkZI?=
 =?utf-8?B?NVNLaUF6TDIrcVpjSVQyTHRJaW9KditYVlMwV2ZuakQ4OXBQQ2JxbHFsdmhu?=
 =?utf-8?B?b2U0TzVxN0VBSXYvaU9hZjJnYUppcDZIR2g4cmFvVDBZYUJmbkIxcmh2MHA1?=
 =?utf-8?B?NHQzNmR5eXZrYXp2akovaTc5RzRka1Njck9GZTQvNXRGdVBUMDI2WlovbWlT?=
 =?utf-8?B?RzJlOXVjaktQdHdwVXpxZDB6TnhaZ1VZaTNCV3VncFNMaUZ5clFZZHE4WHc2?=
 =?utf-8?B?Ny9VNk92QzRIaUJRQlc1Y2NXUmlxWEVOaVFJcWtjTVVpSmFBb1RVSU5wbjEr?=
 =?utf-8?B?ZkkwQU9LRFlkclNVd3lBT1JrTy9jVHliS2pVU0J0S1ZLRjdTK2VTMEVuc2hU?=
 =?utf-8?B?Ylo3b3J2WGtlYVhML0RXSFRNRXczUURYWUZlY2FJWWpvQ1o3WTA4NWJZaVlv?=
 =?utf-8?B?Z2J3bGVOODVCdWs3eXdFem40eWFxak02VHJ6dVNseWRRNVJVOWtKNlIxUXpi?=
 =?utf-8?B?T3lCdGNqcUUwQ1ZSUktBenBNa2c0ZzE2QlcyNlp5RkN6MU1LY1VRZE83TGk4?=
 =?utf-8?B?WmhSZnVmUVhJQW4xWXFCMTE5NTBxWi9LWWxYNm1lcFVNNEFjT0YrdXdoY3ZR?=
 =?utf-8?B?MHRpdFovanZTamdrQ2RyU0k0NHVzZ21aYVhDT1lsQWxWUkl0eE0yMmg5Z2hT?=
 =?utf-8?B?ajMzazZEMm9YRTN6d3FyT1VKSnVKaXZ3NEpMc0NCK3VYSVZ0SFgxd2ZjcWVO?=
 =?utf-8?Q?JADykejM3BqUS68lUlGXm7o+Fxj12qZo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEF2UU94RTVQTEl1SFhBSmdtdFpNLzcvSW8xL2RmVFFCb05nVzBrZ2VrbVJO?=
 =?utf-8?B?ZzZjZUxrQ3RvblJsUkdtTlpxYXM4Q0VQZEVlRGxhWjhYKytIanIranJHSHdi?=
 =?utf-8?B?NTd0NmxoUW0zZ0wwaEkxSTRENjNacW4zdkdRK1ZGcjI5ODlUcWNCVlp2MENK?=
 =?utf-8?B?QjNLa29laTh5dlRyazJUZ0pmcTRySnNKK3JnVUFBdG9PbWVJME4xdWNpWVZq?=
 =?utf-8?B?V3plOFdIZy9SZ1BmYks5dE1WaDNBNWtSb2x0Qjh5L3BZUkV1ZFpUNlpzRWtB?=
 =?utf-8?B?MEVPUHUyQVNJdkprMnpPT2ZwU2NNQ2lhV1lPWjBheGNJSTE0cFJiVWx6T0Vn?=
 =?utf-8?B?WjAvYmV4dXdodmFPVTNEQ3hmQTJmV3FkakpNeDdpVWpDY2dJV3ZlQk50ZDFi?=
 =?utf-8?B?SzdRMlB6ejN1ZVR4UW80NHViTGMzckdkNVAxTjZBL2VqQ1JHcE5aMGRxQyti?=
 =?utf-8?B?WmtldHU1MHliMExyeFhkS0JFLzJNbnkycWM4WUlmMG5tYWJuL09KS3FLYWoz?=
 =?utf-8?B?cFZkWWdwWVdxbUJsOGhEN01EMU1QdEIvTHdXOHliTTFFR0hpZmVUZ2gvajQ0?=
 =?utf-8?B?ZjEwSUJIYWF2ajJZelJEZnp0ckg1NXNDTFhYWVBzYjRwWkp0TzJ2bW44UXNM?=
 =?utf-8?B?aGx6Q29WMFlqb1VFZWkyaGdncm9rYUxKVlIwcndKNVRqNVp3Ulp1UnorVktF?=
 =?utf-8?B?SjZVa25IMHlXVzFqSlNtSllYUGNyRTBnSDd3VGZ6N1RCUkJVOGxsL0E5a2xw?=
 =?utf-8?B?Tnh5eVlnZ0dvdU1KdlFvTjl3V2xNQkZvZmdnaDcwQXBTRGtORjRXbThMUm1W?=
 =?utf-8?B?aVpkUUhCN2lqU0tkbTJWN1hmbU80b0lBT3Z0dnA4WHVTQTZUS3plNTBYNzBn?=
 =?utf-8?B?SmNmMXRVeDBPdWQrU2RjTWJmM0lUY3ZxSHFZaGRpUDlKRUg3Q0ZJL1FjU2hu?=
 =?utf-8?B?WDFPU1pGcEtmczNTaGlsUTRUWW5wVStpNUx5OHZ6WllWN3QxK0c4UzFwUlVp?=
 =?utf-8?B?aTZuZVJ1Q0dTRFNVSk9PbTg4ZkNSa3d0ZHdVVU9melRnNzJYY2ViREVXOUQ0?=
 =?utf-8?B?ZUNUQy9FVGRFTHE3d3JGQ3Y5ZUVYZXF2NDZTaXVWNWdDeDZTOG5OYUpqODlC?=
 =?utf-8?B?dTgzTFVwOU9rU2NVdWxKRDFKditFTm9UYnBidkZqN2dWdGNMSmdiQ3VYa1Ix?=
 =?utf-8?B?WVI4KzZpNWc4alVUdDdKZTNvZm1TWlF3eEhOQS9zdWw5QVRQNWxMNkhZdzIy?=
 =?utf-8?B?Rzh3UXordnhicFhBNXU3LzRGV2c2YXpCWUtEM3NOVEZHOURDa2tZaFBkem9i?=
 =?utf-8?B?elpwV3d5MGYvNWRQNnJHUDVtdUc4RGlTbE9TS2hadnRNR0E3ZW5DbHFLNThs?=
 =?utf-8?B?cmpmRXZLazAzNjdTcy9wQ0lTaGdTOVp6RFAzSmZqSnJlYklHY2JQSjBUNjI3?=
 =?utf-8?B?WGJhYnVqRmUrMy9jZ1J2eTF4RUJvei9raUFjRWdDenAwSktLSEV2MDBqR2NZ?=
 =?utf-8?B?YzVjcTZIdzd0b2lONmQwL29hM2JNdUtwSkY3Vk81cjE5bURrb1NFTDBzb3Iv?=
 =?utf-8?B?Q2xqVGMzb2VDZm0rWjFjdHJ2VnlxNGQ4RXNWRFJZZzdkQS9JSlJRbTUyOHFY?=
 =?utf-8?B?ZmwrK1c2ZS9pWWsxbVFEbkQzYlRBdmQ0QzhzaE92RGVPR2o0NWkvRU1EcWxM?=
 =?utf-8?B?WHVmMGZveFJHcGdwanF6WU1XdzA0UFpzOHp2YThvL2FpNm5pL0JTOTI4Nmdz?=
 =?utf-8?B?U2xxbzdiYUFwcGNpRE95ZmdHakZNVTFtRTJFM3g0KytDYUJ6eTVBbW9pelJL?=
 =?utf-8?B?U3ZHcHFBY1k5STA3VXprTnVEcisyYS9CckRoODg2ZkF4cVB1Y0d0eFNKMlFu?=
 =?utf-8?B?TjFjWGJoeW5mQ3BtbC9OT0p0WjFaR2xQRnNlSFlWbVpkdlMrSzZidkJzOTJ5?=
 =?utf-8?B?MFlvczhCN0djdm1OZDV2ZzloRW5EVmhDOWJ6NUdLUmswWElXUjZkQmh5eDQ3?=
 =?utf-8?B?bkJNbENxK0hvMHhrRFpCNHE1TzFyS0pSSitmcGNILzM5NkwydERtQWRCb2dz?=
 =?utf-8?B?ZkVnbHhQaGRFejdDVHpCaVNHWjlOOVVJb1NxYUVsOVpGbjd1WlZQd2hpTG8y?=
 =?utf-8?Q?Br9s3z4oXhap5cXvG1YC50B6G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee8bb68-0b7c-4358-724c-08de2842f3fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 14:41:56.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9E6sbdi1NnfoMrwp1g/y6GLo4qMEfCgnvPAnbxHfaesioR75sjoFzrQiHxWrRhw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB5BFC000E
X-Stat-Signature: ypgt3oadznmq4rnrzepcf7n3hnehz9bw
X-HE-Tag: 1763649720-106868
X-HE-Meta: U2FsdGVkX18Rr7ZGsZYB/jPhQq1E+gO7W/5HbivEfRNU3BtpmqjW4KOmwptxiHvR1mRYpPNXU3ablKnjbkm68Bth9hMwvDAfdWva8XzSto/4rzuJruqHeO2GISpZfH4wsCyv1S91TdRJRiXLVuO02kLcrqFOQ4zLrOk9gQz43o86c8z2J2QnVxyJIzT51TsWrLZguJ22RL150AtDiWHsci+erFVMk/lQpEVKNdcZZhUzWRKPHSmlKmeerQs+iS0enrLLXXDvzbXMp3NFyzNoKtM+t6F67FTYtXLmel0AT3FQmOn4yeAJ4jlbk3oSfF5HX0cimLokV5G59HJ5oOPeSEKfjzWiJ/brB4N9Dnhdu/+U6r1P/1XboiD9RrMUnp/1o4y+jm4iwrBZUAnNDmjgZn5eCwx3rwKiaBLhEoksfKF3AzotSZkUjw9LiK3sBE/IRG+V7vPRCg4mX7A2Izs+OycUwdyTY6pQ+1i3HBuvHTPmG0fgiC9mTsHhmsO+BOXkfiRaCgGBdm1/pbNVyJa3veK/VfrjsCoHxQiaL9yIrsWmy3dgZnO9zIG+O+q+C6lF1YDvLchhLKOYG8HkZhVfHyzcp8Vm9k52Ek56mI318vPN9hbB0+o/rZMwC6ZAKRVf46NKaRpR4vQKAojORVekfRbEqkggrx8DiazJPyvzTZNJLDd3ByHMuzDVDGqksUxwOjwhX23XZGbRrnq4qOgCf3mu+6+XT00fg1FItqariXpm85x9OYsL+Xasb/rrngj22kEpahrD9hpoxMZ3trn73uYGx0UTqQkbXvypv4qqvydu5HGBqyJsAcjwTuu3ccksfB4gMeO5wq80ffN029AXr/oiMHkDjlNU5+SlFOna6RP2WQASUU0rW4NpEDHObqUjW1idMc+MTiaU946XDIbHPJ+7WJMu/hNJi5g7y4VdOUm/PanLV4DOW6URsz7e7+fz1VX2ASUJ5XJoxswEDLK
 fwf434WW
 HiFXPrOnyHkj67tDPxqUPoFT2YbhqFNLyIBTT/3ra0MhyN8EB3QT7mtB7FH91z1Nc0OdeyX/fn58TsUTse/sekKfDkd7EIe3O29h5BMwrJxqpR28iSvK1I6CMlKJmWpHA2/NF8sXxM0a16/9z6lk5EnVGn98EQHJK0TyRnx123sa/Fkak21YYfGpOS3uO9nPXTYfe4p7QO+VKJNp8hDSr8wXIo+m/bVIc/ipgDx5FkfibQoH/sk8S/YtDWen9OolmScXkmTOM/ki6wHZMn2z9QNBPvF07uC66SLrOjTBYfld61yey94HFYThhF7bvRFOTvDhvYi9SiZHwryRi4DkZgwFMgGZx8rU6rlLIsovQc1iOQBS+j+ggOh397fi+K7N/BxLSQKXzNA6TOfCY8j/DKp/lREIbdGpzPQXb1DswTU4k/VVI7i0XSmLpUQYN0hzO0zatuYZ4MsRU3YJqFqwGL3vA+Ky7i6FERX5yjjLGzva5/s9OV13+YiZlWzLNAvYtUTK77h2c8Dv4jM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Nov 2025, at 4:25, David Hildenbrand (Red Hat) wrote:

> On 11/20/25 04:59, Zi Yan wrote:
>> folio_split_supported() used in try_folio_split_to_order() requires
>> folio->mapping to be non NULL, but current try_folio_split_to_order() do=
es
>> not check it. Add the check to prevent NULL pointer dereference.
>>
>> There is no issue in the current code, since try_folio_split_to_order() =
is
>> only used in truncate_inode_partial_folio(), where folio->mapping is not
>> NULL.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/huge_mm.h | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1d439de1ca2c..0d55354e3a34 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct p=
age *page, unsigned int new_o
>>   static inline int try_folio_split_to_order(struct folio *folio,
>>   		struct page *page, unsigned int new_order)
>>   {
>> +	/*
>> +	 * Folios that just got truncated cannot get split. Signal to the
>> +	 * caller that there was a race.
>> +	 */
>> +	if (!folio_test_anon(folio) && !folio->mapping)
>> +		return -EBUSY;
>> +
>>   	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, =
/* warns=3D */ false))
>>   		return split_huge_page_to_order(&folio->page, new_order);
>>   	return folio_split(folio, new_order, page, NULL);
>
> I guess we'll take the one from Wei
>
> https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.co=
m
>
> right?

This is different. Wei=E2=80=99s fix is to __folio_split(), but mine is to
try_folio_split_to_order(). Both call folio_split_supported(), thus
both need the folio->mapping check.

That is also my question in the cover letter on whether we should
move folio->mapping check to folio_split_supported() and return
error code instead of bool. Otherwise, any folio_split_supported()
caller needs to check folio->mapping.

Best Regards,
Yan, Zi

