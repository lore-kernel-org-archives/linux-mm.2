Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B321CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DB06B00A3; Fri, 15 May 2026 03:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF156B00A4; Fri, 15 May 2026 03:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6AA6B00A5; Fri, 15 May 2026 03:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A94E86B00A3
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:34:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4748A14053A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:34:06 +0000 (UTC)
X-FDA: 84768840492.29.7932466
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013011.outbound.protection.outlook.com [40.93.196.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5AF1CA0009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:34:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sER8GJpw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.11 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778830443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqigN8oZtdoEo+0dl8rZFcItunqBzYV4+jKJkaNIreQ=;
	b=JIF3FfAydB2/NuNSh9tsfpqYUZt+bre9d8WOkU1DYoLgkSvwPmnxcbKI/1sUBwN8lahNOb
	YWYJjpJuXu5ajDLwfcNQ+LAljL1wELP5QuEqU6W7XfTqd8CmtMEfXy65Xphu3tbIt1MAT/
	g11JyF7ItZoQCQ0AdJMVHWfglyVQPaE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778830443; a=rsa-sha256;
	cv=fail;
	b=Syb7+Ss2eLyrQDMbDxQG09iWzMD82cqrsPzQ42URUIJGIX75oL+CHIS20wZMtxwEXg+NeD
	L3WHqf2GyM8gEPOxXAP7xEkYRjQ7REdaqY4O3CUg6+FjMIzOLgLQpLIg0oS4Eosn6VSD9S
	UE4pm1HxebkpBe+wyqyxqjCrN/D7dac=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sER8GJpw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.11 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oZyojdNxuHRCdzFQinZInzDU6uUXKRnOPtWMjA4Rq7z3ID9+hsrcJTqmKZoCuGCNBt8k0GsqX3YvkR8T0f/jIisuV/FaNtpX378K5maGiYxX3M9Fwh8f2mSKIUZP9u2DFk7ybXsyKFGB4zcwqu5B+gmciLh6AgjyjMUu7ZmbnbWhcZiswmVWBat6IEtkm309lugJzXdZ5svika+mrzeoKFzU/ovgxVgMyvSmFg4EKM3bDt6AdUXCbVjYs691mN6c+ZeBLStQD2UvH5s6rBO3RNFcvfaNz6lnz//VwMH+bpbW0Ngn2+HUUzckUW+5o2UU9XEyg00LMBmrS+hyMKWUhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqigN8oZtdoEo+0dl8rZFcItunqBzYV4+jKJkaNIreQ=;
 b=HDRq5ivlX5OuFiUQiIOmwBCMy5dPcGMLkIChUSkL7247Q+XLeKG6ECjw2K5NU1GnZqkcVn8KbXo+TAIcVGidn15q4n81ImR+NKMOAcVPY94fCEee3z7uPItHlMM9AX/adX5x6Vk8HH6BC8sLgj6nXUl0NY3Ke6sSYHoTMXhyEmZ943r3z1NTHLLVHNfji4MFOrtcPyvBRAG32NH9tl/Zh+vKfoKNH+S3MDkkei4Q7fyhfzyT/H4zKA8dCqxXK+L3pJTmn4k1yuJvwMbEnAFGdrahIRRRta609rT7XpT/GzCZa0QcS+T+RDOXlgD+EH0VrGoo//pXlW28L8JN6bgsEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqigN8oZtdoEo+0dl8rZFcItunqBzYV4+jKJkaNIreQ=;
 b=sER8GJpwNFGq412GbgDG+nemkSM2SNG6tCmzbKfnoRs4VNnc1dCahx252vGpFRxCj/DeYOl0HCPDg5ZxRHWQnqMcvq35f8G1LmEcffzECOVhWWdT0t17ro6NFGhk0VtR6UxBrkjuzf+mft2OZd1C2+WX3T9sBwPWgQrxwBdOs1SZy9pkDaetKur0wTpGbHeTDvtGxnGA22bTT7WWteh/Q9iiabU02nLPTiEqRek7wA+BwwKl4wEuukRshilXo2DO6db4qkmlrlBaKymh3Ks7mlY6lpO+qWY5MH5r0JonAIQGg68h7wmALv20nu6LbE9SIzDj1FBBn34ir+E44uB2NQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB9174.namprd12.prod.outlook.com (2603:10b6:510:2ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 07:33:59 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0025.016; Fri, 15 May 2026
 07:33:59 +0000
Message-ID: <d355e30e-a7d1-4da1-83d7-29131ddc845c@nvidia.com>
Date: Fri, 15 May 2026 17:33:52 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/5] Migrate on fault for device pages
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
 <agaN29W7hAklrCxz@parvat> <2fe8d022-a414-4b23-af4f-9cecf1aac3d1@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <2fe8d022-a414-4b23-af4f-9cecf1aac3d1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:332::8) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB9174:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ab661a7-e783-4de7-8ae5-08deb25453a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	N67YFEJXJvkDBs2uK2eS7bdWJwLM6rmpqbbQrGDLsUoUe6lYRuyaD/NXByEY/TtDCeUPQyF1zI5bbVzehnCx0YkTwo6yeLaWNSSwG42/3gRgnlJfvQPrGeE7kz7HeSU+M4gYRlC5MKNrrr+vDHTkLpGFq76v13G1NBVeHrAV2NOUXObwai9HlItMxvBx6WDMuEFETJbnWJdaVn4gy1ZrmzrwH05bBOWG0NoUEtbP+7cx6cYKS2wrq8ilqnFfAFBdYFVkuiQbZEQVm8loMYS/8uVP15giy5JO+1B6QovLByA8jPKHTdqCaGp76BIpwBMGiWhjLVkrtaTfDAe2L0hewnJT4SJ9OH6iwTgFe7+MYeXELjWpG4+378p+8W9VpP8FLqsvh5tbL+apsoZHqjM8J4lrf7c6h3HTCKwxWd8A4oAXmWodlvjnCwioLetcO6LgXsGhjF1pd+cYiycRdtBxLbClw3RNgU6e7lJg2Uimh/4ojUutpYLDNrBhJL0YKllNkRjerBGyI/OBsNWf7ggJRNywZ0FVpK44EicB0hShfKItAUH7UXNwdnmnFtY1VnQjXYMDZqFak9tt6FBlajuFo7ZcuXEUDsxVXu6o8UAWwwILwWpirEsmPWfPMJGVRCWGG0eV60G8oCHnmamgSadJXyQfgPnWz5WyF2KocMHo8d2BGmk8UmAY/rwUiKwWQ6aP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mk9RTVdXcmNPeWpVUEV0UDJqZ0hHNXg0TGVzOWZiVVdsbFZYSG5YNFVhRW52?=
 =?utf-8?B?NkVvcFhibkdvZ2F1Vm9FTG9jVjdFaVJFWnFiRnpmSGRlMyt4bUtmMndBL2tY?=
 =?utf-8?B?cTU2aTdNSXBDSE02M3hvL2VrYjRyY2c3QWpzb3dvZXBsOGZFL3RSNlZLWlVR?=
 =?utf-8?B?TWR3UnJ4akxWUHJqbVJvRFVlQkY0Z0JBTndCR3FGWjN4QmwxUzh1MzlvbitW?=
 =?utf-8?B?bVRHZjN0eXhVTlhyQ1BNMGVxU0laMmdqN3M1cEk2cmdtNUM1ZjRNU1hGWndZ?=
 =?utf-8?B?RUpGNGhRU0JycWpnUXkzbkVBZmVPRDkzYTBNS2E2MU5CS0ZqaEpocHZpS2NT?=
 =?utf-8?B?ZEdoZUFTY1hkT1NFbTFxS0R3RW9NR0FaQnFrb1hpNjNmelc2M0l2TUFNKzFC?=
 =?utf-8?B?aDJZSlNwdGxsQXhWNmZBSFFhUUtqUCtsUGkwVDFpRFRUYktCSklxRW0rYjc2?=
 =?utf-8?B?QnFuVjBUcHVKUFpheFA4REt3VXg2Mm5FZDJlYWRHNnR4SG1CNjkrNHNpOWVi?=
 =?utf-8?B?amZ3YWx1VC9hZ1NLK1VDazdPUDdMVGJITVYxbnUybTY1SnB5bko3bGU3R3Fs?=
 =?utf-8?B?bWF5amJ5U2IwWHhrSVJ3NzlDeUx3bEdBVkU2Rk5iWDVZN1NzN0IxenZhekpt?=
 =?utf-8?B?V25idm5idnZhYlZXak54Q0t5anU1WGg2amxrRzJzTGJWcnVJOC9iMXVCRVlR?=
 =?utf-8?B?QVJRZVI1YmUwd0FvWUxCNFBpUGFEYVZxVC9Tc2hweXhIQU1jZ1VXbVFONlQ4?=
 =?utf-8?B?aXVTMENvVTZ3cWdzVnorWjB1ZkhnWXI3OTZlbE9EZHpzcWJnTDI5ajh1NGh5?=
 =?utf-8?B?c3FwY2ozK3B6VThVeE1YdGJQdElKaVZpYVFiSVFEYVF1R21lVGVsMDZSQ29L?=
 =?utf-8?B?M0lHaTloUlhsMWFBakJMZm05TjBQcTJnSlFLOTA2bkFOU3BuKzFXcHc3RHRZ?=
 =?utf-8?B?VTcrbnhWazVIV1lzUmkzUGFIRUZZa3NhZEhCemZldC9zQ01MblY0bzNmRWll?=
 =?utf-8?B?OUNvTjF2VzhUVlRieFVERU14ZUhCdk40QWwzOVZEMFZLazlqTGxGZFJjMzJy?=
 =?utf-8?B?Y3ZhUHBIY2lBcTkrUWpYVXBabXk2RnVlYXpsZzZYV0x3R3JaQTF1dmJ4RjZv?=
 =?utf-8?B?dE5pQlFzd2FxZjVUR0RtMDdXcS95YVgrQ1ZKR1B0RmlLZ0FLcFhUaUEvWVF2?=
 =?utf-8?B?MjVJYzZ5NUpqTXV3dm11eUpSM01xZlhHTE1DaUdzdjNTWTMzN3FEU1A3dmVN?=
 =?utf-8?B?R1ZhTzdDYjhGNDJ6SVZIb1NEUURyY0ozek9DSHl6YlE3MmhmQTZYSWJSWmM1?=
 =?utf-8?B?VmNVY0JCTXU1ZlJveUhkaUFHVEhnMHE4d05UK1dUTVR2K21waEZYUyt5T0ZH?=
 =?utf-8?B?WCtERm9qZkY4REVaUDEvV0ltdTlQR3B4RmVxd3BFeHpHL1pJT3NWTHkzUjRl?=
 =?utf-8?B?SjVZSTFjdlJmb3dLWWFuVmp2QzJLOFFyUS9HQlErUi94YkE5eVRCazhXbFpm?=
 =?utf-8?B?d0ZKWHFremxZbGdzdnNUSFBmVVNMRUtQaUVJNHJRNStXN2FKdE5kM21PUml4?=
 =?utf-8?B?RDh0ZW94My93V2dGbUhScDNZNnI2ZlJ3Vlp6WXk4TjllZ0ZPTVA0UzdLRkVL?=
 =?utf-8?B?TUxSTkhLaHZMYmdoUHM4dVBIcXV0SERxUXM1OHpaL1ZrYzZSc1pYcC9udENz?=
 =?utf-8?B?WnUzTGRQRWNsNXl0RVpWUXArSko4TWFpVytPNEJuaVJWdkNzMW9nWVNlcTFl?=
 =?utf-8?B?bzZzWG1Db2xBSjA1YTlpaW1XNG83WGgxWjRUZXBNNkFqN0EyUkk1Z1A5UXEv?=
 =?utf-8?B?eFRvZjlyVWJ4dG9yQ0V3cDBLZk16TDdDZURsVlpXejlBdk5mUEdybDNUaDFz?=
 =?utf-8?B?Q2ZYU1RGU3p3UmlMSTZYYTExRFo2OFBWNFp3Y0tUZzJrcVlkRDVlSlNxd0hE?=
 =?utf-8?B?Y2lYVUw1SzNXUFc1SUozTUZxWTI2MTZCaS9pbHNJQ2pLRkRydDM0ZjNmcUNJ?=
 =?utf-8?B?bFRkSVg1TGlNZzVXUGxhMHNVdGNHKzJFL2dpcWt1UjVzMXRSbU5PWUdmK3dY?=
 =?utf-8?B?djBRYTl5cjBxVktQV0hORGhZSXRLQnVwVDY0U25qblhNR0lXd0c0Wi9LNVVk?=
 =?utf-8?B?TVN4MGdRYkhrNXRZcFZLQUFkMU1sMGcwTVhvSU9lSEhOaUpzWTVTekJRMzR5?=
 =?utf-8?B?WnJhaWRpaWxFd21UUnl6MHBvOTZVS3FXN1ZPRTdYekMwV2RFSFJpR2JGbXEx?=
 =?utf-8?B?UnNKSEl3QnhmVzAwK2ZwOUxYeDY0MWpCVXZGTnd1a1BWSVZBV0FmTTQvakcz?=
 =?utf-8?B?ZERmRFNnYTR2OGthUXV2MXpPbEtIaGxZR3ErVmtuTDF1dzUrZHpmdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab661a7-e783-4de7-8ae5-08deb25453a4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 07:33:58.7340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAwxtpZorpB4s2BxqM0tokvaWJTds1kkqUkKharQ/SJ4VKVsRQTTwcRD+fsHnLy0gUicot/gAihqDa8f8L5cJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9174
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AF1CA0009
X-Stat-Signature: 58pc3xibkh716kgwuib7k9kruo13m1tu
X-Rspam-User: 
X-HE-Tag: 1778830443-105505
X-HE-Meta: U2FsdGVkX18H+RL7Tda5Mu8RGhn4Aqx7MZ7FEazaYRGuxqixvii7DEWUP2w2Rf5TmW7Bb1ZS/iGz6jRzpMjlA9wHHgMKPj4Wog7LeTofcCXroX9Bq8INVqAnRRvWB0/wSpFUeCnMDtyQ+493SUaOErQJbyMZ6dQCCE+M7D1YM4CtPpytE77oW1G5FRiTh9xlaoUjbkAypTKg12s+tU0KVjzvlNROhL5MMXKEb68d3H6Pp+VJlgyJAzjke0kvryZKLkqyeB4tfLB4XsE2aK1A6JlaX5yhcw7q5EQ5Gwho5mSGGyHZ6FlWFNjcoOoVQMv0tZEVBiZqFN/Lpk7rAsh4/pPcOMPI1j31xAgAbne/PMwSGcTriniyMWoKnWYKUDluw5WsLeeCCNyb22RJal07b62oL8+xSsBG7xSRNGD1Dwo9kLE05oLBiQ2NgngF/aA4qpiwKkPPHlvJUG/ER1uPI0CKnsYT+XZHqU3Ey6tGPWl0mf9l/qjOL+FhI+38KwlDmPT0kH+hNAFbpYb39f/SrIlZpqbC3fycw0/yJkKsASlHtfHxjqO5WSVNd066GgdANXhajdZqHNcUIoUVUYen9vCshNA8C+/5gXcX9hwfZRdPNg8QJtoEN04vEGan3CHK9Yeql79R6mDhrMRiqYxk0sTGruCpXo0fYh7Ay6OvAz40I67SeJXKTl9ZvFNrIJolS7s2MgMhM7g7DI4a9ivuPSJiKzYTlVGk/elRXY76Fu+ED8jODJeqqkD0Z5RXCyldEd3LKhe/bkvoFZmCj6MSyHUGTIl0NgyH8sy+7OiohnUUWl3SkKzj0eyX62Lfb5Eke139i3/DnC/DOT5/vt2Jwi+pzQjmLWEPD0K/BqM3QDUuQALB4M/4ngh4iOLX1Vkqup8aAnFavMbMUbQ4fvvK0CsI6Fh2KPYZxpo0853XWjMWIP4wEyQAi+gDxU5yFXhYpGc2fKJVRhkaKgtUmj8
 lASaWwVe
 OJ3OsaiyGBMAjAhXzuQM5mIkhG9Bi2ByegLPeoBOgiXppVl2y4oy9Ltr/rC7T7nJlR8GVS13i6kyN2JSDVxpqfMKKUSqnk7TxYYH6j4jIJ0LOO+SlSm+slk5T1CJyODuUkMYd/EZvkiU0iKN/tcED3nsLJq/8Mqhiampa+DuHNwgd5nysYtknpRYVR9OUkfELZt+WHXm34qFxGZ2X+njdSGuCvUHD3w/FHgsVX735yEZ4wQ0ZFa+G4+iuEgbLJp5Eh+CnfIvoiMhXS2FVCG96p3+vnVlqkp5gQHav3oMvvM/+QUg8ipMc/k//QZP8A/cM14NZkFuWZITtjndbP1KpbgVvU+7Rk1ZsLcrbWKRVt4tI3EtO5xFTR1LpqSRYuadJxEwbnYjiTSO/P2Sd6y50LYdvLyXggXdZMRy6pA749KVoAFObuJTRWcYv/HoDqHJgwb7dYRE9lymJijcA7HrWx6EQiTLinoXUDJWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 14:05, Mika Penttilä wrote:
> Hi,
> 
>> FYI: While testing with hmm_tests I ran into
>>
>> [  107.866004] ============================================
>> [  107.866284] WARNING: possible recursive locking detected
>> [  107.866577] 7.1.0-rc3-00311-g4277273ca0e1 #12 Not tainted
>> [  107.866877] --------------------------------------------
>> [  107.867217] hmm-tests/1098 is trying to acquire lock:
>> [  107.867491] ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_range_fault+0x147/0x610 [test_hmm] <- line 368 of lib/test_hmm.c
>> [  107.868076] 
>> [  107.868076] but task is already holding lock:
>> [  107.868383] ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_fault_and_migrate_to_device.constprop.0+0x3aa/0x6a0 [test_hmm] <- line 1267 of lib/test_hmm.c
>> [  107.869076] 
>> [  107.869076] other info that might help us debug this:
>> [  107.869415]  Possible unsafe locking scenario:
>> [  107.869415] 
>> [  107.869729]        CPU0
>> [  107.869866]        ----
>> [  107.870054]   lock(&mm->mmap_lock);
>> [  107.870247]   lock(&mm->mmap_lock);
>> [  107.870436] 
>> [  107.870436]  *** DEADLOCK ***
>> [  107.870436] 
>> [  107.870743]  May be due to missing lock nesting notation
>> [  107.870743] 
>> [  107.871158] 1 lock held by hmm-tests/1098:
>> [  107.871377]  #0: ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_fault_and_migrate_to_device.constprop.0+0x3aa/0x6a0 [test_hmm]
>> [  107.872081] 
>> [  107.872081] stack backtrace:
>> [  107.872348] CPU: 1 UID: 0 PID: 1098 Comm: hmm-tests Not tainted 7.1.0-rc3-00311-g4277273ca0e1 #12 PREEMPT(full) 
>> [  107.872350] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20260213-6.fc44 02/13/2026
>> [  107.872354] Call Trace:
>> [  107.872357]  <TASK>
>> [  107.872358]  dump_stack_lvl+0x5d/0x80
>> [  107.872385]  print_deadlock_bug.cold+0xc0/0xe2
>> [  107.872393]  __lock_acquire+0x10cf/0x1b90
>> [  107.872400]  lock_acquire+0x189/0x2f0
>> [  107.872401]  ? dmirror_range_fault+0x147/0x610 [test_hmm]
>> [  107.872404]  down_read+0x9b/0x4b0
>> [  107.872420]  ? dmirror_range_fault+0x147/0x610 [test_hmm]
>> [  107.872421]  ? lock_acquire+0x189/0x2f0
>> [  107.872422]  ? __pfx_down_read+0x10/0x10
>> [  107.872424]  ? __lock_acquire+0x3c2/0x1b90
>> [  107.872425]  dmirror_range_fault+0x147/0x610 [test_hmm]
>> [  107.872427]  ? __pfx_down_read+0x10/0x10
>> [  107.872429]  ? __pfx_dmirror_range_fault+0x10/0x10 [test_hmm]
>> [  107.872430]  ? __lock_acquire+0x3c2/0x1b90
>> [  107.872434]  dmirror_fault_and_migrate_to_device.constprop.0+0x3bf/0x6a0 [test_hmm]
>> [  107.872436]  ? __pfx_dmirror_fault_and_migrate_to_device.constprop.0+0x10/0x10 [test_hmm]
>> [  107.872439]  ? find_held_lock+0x2b/0x80
>> [  107.872444]  ? dmirror_device_remove_chunks+0x5b8/0xa00 [test_hmm]
>> [  107.872445]  ? __is_insn_slot_addr+0xee/0x1f0
>> [  107.872458]  ? lock_acquire+0x189/0x2f0
>> [  107.872460]  ? avc_has_extended_perms+0x234/0x1350
>> [  107.872476]  ? __might_fault+0x89/0x150
>> [  107.872484]  ? lock_release+0xe1/0x320
>> [  107.872486]  dmirror_fops_unlocked_ioctl+0x9ba/0xdb0 [test_hmm]
>> [  107.872488]  ? ioctl_has_perm.constprop.0.isra.0+0x2fe/0x6c0
>> [  107.872494]  ? __pfx_dmirror_fops_unlocked_ioctl+0x10/0x10 [test_hmm]
>> [  107.872498]  ? count_memcg_events_mm.constprop.0+0x22/0x1a0
>> [  107.872499]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
>> [  107.872501]  ? count_memcg_events_mm.constprop.0+0xaa/0x1a0
>> [  107.872503]  ? lock_release+0xe1/0x320
>> [  107.872504]  ? find_held_lock+0x2b/0x80
>> [  107.872506]  ? exc_page_fault+0x7e/0xf0
>> [  107.872510]  __x64_sys_ioctl+0x13c/0x1d0
>> [  107.872521]  ? lockdep_hardirqs_on_prepare+0xd9/0x190
>> [  107.872523]  do_syscall_64+0xf3/0x6a0
>> [  107.872526]  ? exc_page_fault+0xde/0xf0
>> [  107.872528]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> [  107.872529] RIP: 0033:0x7f7381c543ad
>> [  107.872531] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
>> [  107.872532] RSP: 002b:00007ffc3160a9b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> [  107.872539] RAX: ffffffffffffffda RBX: 00007f7381b44000 RCX: 00007f7381c543ad
>> [  107.872540] RDX: 00007ffc3160aa30 RSI: 00000000c0284803 RDI: 0000000000000022
>> [  107.872541] RBP: 00007ffc3160aa00 R08: 00000000ffffffff R09: 0000000000000000
>> [  107.872541] R10: 0000000000000022 R11: 0000000000000246 R12: 00007ffc3160aa24
>> [  107.872542] R13: 000000000041f380 R14: 0000000000000200 R15: 00007f7381200000
>> [  107.872544]  </TASK>
>>
>>
>> Thanks,
>> Balbir
>>
> Thanks, I could reproduce. Had lockdep dropped off so went unnoticed. It is nesting mmap_read_lock in the test suite, I will change that in next version.
> 
> --Mika
> 
> 

I'll wait for the next version

Balbir

