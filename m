Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE8B3CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2309B6B00D8; Wed, 20 May 2026 11:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208746B00F5; Wed, 20 May 2026 11:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D996B00F6; Wed, 20 May 2026 11:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E856B00D8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:25:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC0A61C0236
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:25:08 +0000 (UTC)
X-FDA: 84788171496.05.A9031E3
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id B02DC120006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:25:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uzXvfLEa;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.53 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bgy2cHLXVFxZftwXD3gHxSvhPns4+D/fnlyRpxuPEc=;
	b=PXFcZcqmBB0u4dE6JjIMKJaJVSK2T+rtatm2m+RWb4VdTVJjtAOzb3z8NEqmditaGKdkGg
	lR313Jk5qltxLfJKDL1UXeXvMo1zeCbtq922xRRoxULmQooqcG142Cb6L2JWJlXnMM+uPZ
	g9dAzDz9uC94mkNWcwbSxw/YIuCQ69M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779290705; a=rsa-sha256;
	cv=fail;
	b=tTDYN8LuEIhLDe2/NjWpCBFWZCYsq1AzSyNGh98CliqdXy2tjeTRTSM00Gu1ip/ugC1ckB
	QUprK9oO29LaZ9/X5touQCz64WMq50VVr5BDz6lBf2+Nk9zWqRVIyQGn8q2QuP7F5lAS36
	T8ymU9ypCZKOhGQENJqk0sE2Szitkrg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uzXvfLEa;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.53 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDOhM+XJbskZ0SI2Xy8iG2JWk1BinRenMXokUdyoMw3gKmgbFr4TwJTXaLsNGqYns7SMI2h0PdQNTqbGrGszuKXCg1eX4qrmvV2UN1Q+arFyWbxX0F9TKUpeptIbk6/aW6PVx9hQm3eWC6fLNEPXRAOtCJapdKB8Gvgo4ggE1RVApu44cI/R8hdVPCRKiwDmxGnbJ0FwcIvWdB6GeMeWj7iMz+UUpJ0rixlpfDhGDYKeUrjfEPBMTLqp8b23NM5JRcBIN3W2FN6srRFYBNTxkUSWjM7PbHf6ou0s22q2xUku91ioAUAfQuJ+A6hVN4Ep0rW62ySjNMyw1KHOfYgX2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bgy2cHLXVFxZftwXD3gHxSvhPns4+D/fnlyRpxuPEc=;
 b=a6O0AtKVX/zKHb4V+yWme7SPwm5HrpGxCwaKeokbA5gphEXdm2Gz1MhM+8Lz6aKqZFjU2woQyLqhoD0iS6ivv+nl5IMKc9JBEEFdHWEYBZQhKjTjYU2rKatiEyo4TuU+1jZrwFa5UDjRZCy0NgDPEdhuAzmfd3wcoY7wXmrRUMKwDO3WrseSl1AHKjvh+CaOv3JIYFutVfqjwCCidBRetEFKF7AIgrkHxZgIVP1cyP3Z0pdsua8pOMggCyc7ePXga2ON8d7ezqWr5bxRVuX3OAytTCskiNmHZrnrnMiZoyUmWUEmymU4RjGHiPJpJb/UeTLaoRAourg2hXakTq1umg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bgy2cHLXVFxZftwXD3gHxSvhPns4+D/fnlyRpxuPEc=;
 b=uzXvfLEaUFTLZmMg3AumFxNDp0dHqEk9yIePgZONDWMBfzY9xHWWMZ7VWgmbZrDfm/SrMkOjB3dtCE/+nZjWSpfMtdgjML9cQz2wIz9BH8tyuH+avf8xb/dmERTh9ib9pKD/gNH+ZPa6z0f+B9AZW4UUK3gXuCSYkfDl3X/qlRg=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB9445.namprd12.prod.outlook.com (2603:10b6:8:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 15:25:00 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Wed, 20 May 2026
 15:25:00 +0000
Message-ID: <18dd8ab0-2a3d-4b3b-9a93-5b44ceb559c5@amd.com>
Date: Wed, 20 May 2026 20:54:45 +0530
User-Agent: Mozilla Thunderbird
From: "Garg, Shivank" <shivankg@amd.com>
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Day <michael.day@amd.com>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-12-shivankg@amd.com>
 <5a0ee441-3c0d-43b0-84f3-7e727ae042bd@kernel.org>
Content-Language: en-US
In-Reply-To: <5a0ee441-3c0d-43b0-84f3-7e727ae042bd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0113.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b3::13) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DS0PR12MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ccf112d-7f11-4124-9843-08deb683f4d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799006|18002099003|22082099003|56012099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	ej1zoqKTYAMuuFbFubk4E6jSBtcE9pF0TK2UbJ9cHuisv2eUr6QAqWay9qDj2WA7OiExRBFARotgLIwpxfTvGmiStT8CBvKqrvHg0vyvLNKBM4WoyqU2Q2bqjiBVm1St6NbIVmoOqoKE/GZZTSIOYX3yMQtRULEyQmOpv8FNTj1tNIHvf+sbVGNr+8Q3DCl6BI+DXWL7D5+aMaQZ8ZWww6eboOAeLzy5KFb57Q8y0Me/DNXAd5Od02NdaaSKlt4Rj1tWk4mdUAwLRztovQjyS0rAdzFmf7ekFRXnxh9zajE8EtBj2Ldr6CcW1AxuUN8o035j5UMho9kjvjHaR4/Vx9GLq/rt+g1l264X1QsMTaxWht3A3WEezEXkY8qsKb9WTNZHFUe1GYWMr7M9mWf4EqQoacy7BHPrglfTS3oJ+KTO8MKy/TCtimATOkOYecaXjQckHdeg/bIfLKgUwDl7QikaH82lzsfJE7UnGNI6T6oxzeXzuZ1uPufd2jfCDTIQKZWki6OY5CnOYL55LmxSKmWYkhuWnva2vefQzqSQusLYh6CJWqadXFqHNo4yL6FMVc7pU+7SITLvsVsoe2Lcnvp9+NPoJcJFVDfEciLxqhDuig9dypE+3zUmb27RInhC67qMw8AQmdvqESF6Zc6JKuNRAHXv6M6piZR+ssxjwMkbG9mCeJllb9flhtTkvQ24
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799006)(18002099003)(22082099003)(56012099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mk1CaWxiOVZFcGNWREE1VW15L3VyM0hBMURKUVY2eGRjcStqREJhV1NSdHlz?=
 =?utf-8?B?U1JZL1RnNWcvWVJ2d3BwMW9IMkJwdHJUUVl5dDFTQ2pnMEU0R0FFTTIxWUYr?=
 =?utf-8?B?dzkwUS9iMTdBSElOSjVzcUlscXBCTkNxOVBBV1pIRkJUdllSZDJOQ0xObzl5?=
 =?utf-8?B?eHBxanYzZ1NXUDB0dVV5NGtNTEFyM3VyNUo5OVNVcGhSbXBuS0sxVUNlSmRm?=
 =?utf-8?B?VWwxMlk3N1g4YTZoNk82eElNM24yOWUyNHdWdDRRWkttMGRqa2JwZkFtTTNn?=
 =?utf-8?B?MWJ0WU1HUHQ2V3JuOUkxVmJMQXFvMEpyVGtsczR5L0JDRjlTU3E5NEpyb08r?=
 =?utf-8?B?K3loYU5lNllWeHMxSDhlVWFZa2NyNEp0bis1dFltMGVhL2FMenNFYVJzdUpF?=
 =?utf-8?B?b1Bkb2RIN1R4Ky82UFF5Sm0xSTZWRTVqeTBNQlgyYzI4RnJoL1VtMWVWUzF5?=
 =?utf-8?B?TDVOMWVMVnFqQmt0Smhjc0Q1VWVCbWphblRVMU4vS1E0aVpvdFBIS3cydkNi?=
 =?utf-8?B?WGY1SzI2aVhBTHRUdVROaVh0R2FycFZIVUhvcDhOZVBqckZKRFZWRk5YdUFD?=
 =?utf-8?B?N2s1eDYyZjBBdzNETzhQMFNndWY5SlgwUkZnOWVYKzBnY3BxbW9xTUgxcFMv?=
 =?utf-8?B?RllpMDhWTlU1b1Blck9sbVpjQU9lWlF4UnhKZStaNnJxbWRMR1VsbkhQYlFq?=
 =?utf-8?B?SndFM3Nrdm9tVm9TSnllYlRBc0h2cTdHUVZUcmhxNGpDZlZIZVZucTc1bHdi?=
 =?utf-8?B?c3ZBTXlwdDRxN2FSL2dCVFp3dURZa3I2aVNmSFBoK0k2eVpxMGRjTnhFT3FO?=
 =?utf-8?B?VzdCR2NqUkhuRWZUWFBoV0x0eVM4YmVZMG83L1B3bE5ncjZnRE1kWXdhTTZF?=
 =?utf-8?B?TFJaUGJodXJqS09CWjN6UUM3Ty9OODNad3o2RGRLbkw4cDJhQXRGY3hxWTRL?=
 =?utf-8?B?MHlOQXE4a1dydXZaWDZMOHZMZVlDY0xreEtmSHZBYkovRm1tN001ZnNxTU5X?=
 =?utf-8?B?WHNBWDBKa1ZaT2hkSXJ6cjdONTMzcElOMVlaUG0zOGpONVN2czJnVWJzN045?=
 =?utf-8?B?bkQ0cHcwVk1MdFZFVFFGaFFnUExuNGNNQVUzQnE1MWhsZDZNYU5ueXlNU1dP?=
 =?utf-8?B?U3dhZHpBODNQZjRmelZxVkp0YnhPcndTWkFxaFZPOVBrelFaOTFOaDZTeERi?=
 =?utf-8?B?a2lISEpjVm5PbTFqQW85Q3RkY2dta1ZnOWRmRlpZY2N3UkJMcUhDTDUwc0xK?=
 =?utf-8?B?Q1ZYSEw0T0RaSjJ6VHBPelNVbHRKVUdNOU1uTjdyeS9uN0xvTlJmME5Ud1dX?=
 =?utf-8?B?TGF0S1AxdHpUZFZUY3VuMXJRUzA3MEhFeEpUVTlFRm9pZjFuZGdENjVzOGYx?=
 =?utf-8?B?a2pnUjRmU3czM3ZuWEU0TmpHNnJVT1Q2Vm9VN2tNOVJpTUFwam5RNW85RnFm?=
 =?utf-8?B?aThIUkFVQkhBSGpuMzdCdjRQNTlQM1BHdTBNNUtPWjdzeW1lVnRtL25Md2hE?=
 =?utf-8?B?eWpSUFJlVTB1M3RNeDR3MDBQd1VROWYzRUVGT3pVaHNYaGpGWkNWOERLVVRT?=
 =?utf-8?B?TVJhUXZmaktwRGVoYUNFekx5SlNPQVVERDBQU01sYVFlU2dNeldFM2o1clJp?=
 =?utf-8?B?S21RYkd4dHpVK3Z4Qi9MNk0xVGlMb2pWTGQ3Z3JTVjRhRUExYzhydzhIdTZG?=
 =?utf-8?B?ajYwanJXWTZlekNLN08rSHFpQXdGTFpqMWtha1lkNWZsdzA3aEsvS0dMd2Yr?=
 =?utf-8?B?U0tHRzJoQUpUaVZSczVRRHZ3OU9iTTdmSTdnODJTTGJaR0JKQkl0amtlMWtw?=
 =?utf-8?B?aEQ5SXgrWTZCdWZtOE56dzRDZ0phQkNmUjQ2M0hrbzFnMWRqakdUREsydUF0?=
 =?utf-8?B?dXZZU0g3bkhNWTBRMDF6dmdEWDhVUVZvd3JKWjl1aG12bGsranRkNXZCZkV1?=
 =?utf-8?B?VXg5eTFyY0hVeXljTUJVcVRFT1c5MUcvWlJlbFY0N25DcG9iUmZFa3Z6aGVB?=
 =?utf-8?B?RmR4bkZHUUVsWWZnKzBjN3ZaeVZiUFRMWEtQdTkxK3hERWsrdWp6amJQTlJN?=
 =?utf-8?B?WUFHZ0VTSStjOXpjdnpRSFQ0eGw1ODVvSkNRTjh4K1oyTmlpY1FCcml0SGZ2?=
 =?utf-8?B?SGlGV0VsZTU4eE1iVHVZV3NkMFJ5bXU2clAvNEpoY2VvTGVMVFZ4d3BzcmVi?=
 =?utf-8?B?R1JyNUNrNzZybDRoSGFFMGFzeW9Lb3p4TEMzeGU5Tm1DZy9qU1g2ZmVFS2hQ?=
 =?utf-8?B?T3lsOXpyU1N3MTMydjJzSS85SFhpQ1EwMGhPNXk1cW5CQVhCSERHL2o3L0Nw?=
 =?utf-8?B?c2NQdzdoTzM2eExDYkdqalhFVENrbnpHck8reUF6ODljMjdsQ1lndz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ccf112d-7f11-4124-9843-08deb683f4d5
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 15:24:59.9306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crRVSPK0tJdvrYhC0FDs9zDZQPAJQZliX8ccu9gslA+iEvfMfgMlpVDxj/jIOEjc9m7ZejLtiE5LGnL7gWUPAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9445
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B02DC120006
X-Stat-Signature: ojod4eowapw8fs18iehrjdfu54iw7two
X-Rspam-User: 
X-HE-Tag: 1779290705-982157
X-HE-Meta: U2FsdGVkX1/sG8uT5MnCngGhKCsAU3EUFOPOTI0/5mgk3Ar5io2BA/HhzlqqlzmQnYt5n+reQ83gMaBNvtSjtxjiRAxPG9KHiS/LjnoiVwtnZMolBoH6800nrjZ7VTCQkYQ6HUHcOq1zK2KaJco8TmeUI/48/KBQm2IyFNURM/cCd6lFuip+PNBtqnuVLr5al4rP9rqU66rj93ZvYtva1cjYxweNUnGOJwaeQ8BHAl1jMC3b0YrNYmJGHUofVrvkHY8RGOC+s+mDsJCmsXOmE2XIeq3PRhoMxGaBgZO6EJBDP5xW3xbBsYihtDP0wkbaUBHVXjbYKG774iMI/JfNmqcz3KvJfyVfnBs9x1VdmHUv7UKfSO362kKORv86FEYgAtkCKliUKw0jY5aQAHTjSHe3i4oD8gL57/KdzBFjpRgSpxf/8UipBARtyQeN6xNWM3E0sgjUVK5Oz8k9X0+ttvKS6AFPSZP5VnRisYL5HgCPp1NWtiZZoASiQ0RuOoANulBex5EkgBd1b1syEtnIqla2GB4PST3lYXWJgNOBe2FhZESGGH9rcd7VYLwyfClDI3LSkkegarOhiy/cbMERjlM0t4Kpm7xQ7UZ7ckxuLi6rOb5b/QPKsU7H/gGJuCH6g1kMmWeAERl3rWAiIqhFDmPqyJJdddOIp57+F0GFz6yxliD8CrFVYOL0Xhld0m/dzFV5uKc6mtY7Cbe4aoHHVlygVRCKZDuGEEl/1ybekBn47evs7+gJCuD2rfsHwfsRs1CPNXVkmN8kRu64z7U0sGCGIZhnUitX2AGAoApnUsFDitX/Og8HqzRfSX7Gaq9iPgR3HXkKKcvlJA5he6FJ9lEtF/F3wZjAi5ODBQqakb34suF4ZPzGGDXQ7Qq3OA3qXuaBAbr6DRO5VTVxkgobX5M/yYy7yvIkzuD7vXF2E/GbillSUYVgoqvClBRgJs9prhLT4xpS/Qo27ZjVWtL
 9FUPtMRo
 zv0h6J79lrggc87RaZiNruXkk6m19Uxs+ovvRPVd2gWmb5S80dM/gPOKzpCt1DpGsoLX9KJHy+SwMXDtv4IH18nX13WWGXUuv7Ab+rKInFNysU/VhGyfS01nPzGdCSVMcpzKYv80klmaShPTXuKF1y0ml5VPDESRd2+R30yPiOMESp14s8XvqdpALdSPUy2tuHOxZjTyvUkhLP1dvvUcwjsluqEf06k5ya9iA8YkGyFODpI6qQ8L1+aWjyxjMfGIMmo4VgYeC1XoOI32eqpvbIsaOTApTM6W3i1uW/C74SzMAScZ1Ig9vYLnXLZO0Asc2WrkTQeTiGT7plO/a274lBFVrDyABfWIGhTvD/sdD7NGarw5WOHpRf4tlnzAsv8hBYfZvQmVni6c3sHTQIg1KVbc13etlyVlO5x5Jms2li/7w5i6lFjJDKg9HAABZJeey63hJHFmNamq8XDGNXqFUgeyPcGDtfH9We1U2wwqWCkOSt6/CPmpc5uR+vjn63sYqw943rzAv7q6fCViJxxC0u4dZEkF6lbOB9Kqkx+s41b/lJj7hPHKP98GXZCZ2CzVaOliH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 9:16 PM, David Hildenbrand (Arm) wrote:
> On 4/28/26 17:50, Shivank Garg wrote:
>> Add a registration interface that lets a single offload provider
>> (DMA, multi-threaded CPU copy, etc) take over the batch folio copy
>> performed by migrate_pages_batch().
>>
>> The provider fills in a struct migrator with an offload_copy()
>> callback and calls migrate_offload_register(). Registration patches
>> the migrate_offload_copy() static_call and flips the
>> migrate_offload_enabled static branch. The migrate_offload_unregister()
>> reverts both.
>>
>> Whether a migration reason is batch-copy eligible is decided by the
>> core in migrate_offload_do_batch(). A migrator may decline a particular
>> batch (e.g. when nr_batch is too small to amortize setup) by returning
>> -EOPNOTSUPP, and the move phase falls back to per-folio CPU copy.
>>
>> Only one migrator can be active at a time. A second registration
>> returns -EBUSY, and only the active migrator can unregister itself.
>> The static_call dispatch is protected by SRCU so that the
>> synchronize_srcu() in unregister waits for all in-flight copy before
>> the module reference is dropped.
>>
>> Co-developed-by: Mike Day <michael.day@amd.com>
>> Signed-off-by: Mike Day <michael.day@amd.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
> 
> MAINTAINERS file deserves some love (likely put the new files under the
> migration section)

Sure, will add this in the next posting.

[...]

>> +++ b/mm/migrate.c
>> @@ -44,6 +44,8 @@
>>  #include <linux/memory-tiers.h>
>>  #include <linux/pagewalk.h>
>>  #include <linux/jump_label.h>
>> +#include <linux/static_call.h>
>> +#include <linux/migrate_copy_offload.h>
>>  
>>  #include <asm/tlbflush.h>
>>  
>> @@ -54,6 +56,51 @@
>>  
>>  DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>>  
>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>> +DEFINE_SRCU(migrate_offload_srcu);
>> +DEFINE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
>> +
>> +static bool migrate_offload_do_batch(int reason)
>> +{
>> +	if (!static_branch_unlikely(&migrate_offload_enabled))
>> +		return false;
>> +
>> +	switch (reason) {
>> +	case MR_COMPACTION:
>> +	case MR_SYSCALL:
>> +	case MR_DEMOTION:
>> +	case MR_NUMA_MISPLACED:
>> +		return true;
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>> +static int migrate_offload_batch_copy(struct list_head *dst_batch,
>> +				      struct list_head *src_batch,
>> +				      unsigned int nr_batch)
>> +{
>> +	int idx, rc;
>> +
>> +	idx = srcu_read_lock(&migrate_offload_srcu);
>> +	rc = static_call(migrate_offload_copy)(dst_batch, src_batch, nr_batch);
>> +	srcu_read_unlock(&migrate_offload_srcu, idx);
>> +	return rc;
>> +}
>> +#else
>> +static bool migrate_offload_do_batch(int reason)
>> +{
>> +	return false;
>> +}
>> +
>> +static int migrate_offload_batch_copy(struct list_head *dst_batch,
>> +				      struct list_head *src_batch,
>> +				      unsigned int nr_batch)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +#endif
> 
> Can't all that go to migrate_copy_offload.(hc) Looks like a clean interface form
> migrate.c, no?
> 

Yes, Will do.

>> +
>>  static const struct movable_operations *offline_movable_ops;
>>  static const struct movable_operations *zsmalloc_movable_ops;
>>  
>> @@ -1833,7 +1880,7 @@ static int migrate_pages_batch(struct list_head *from,
>>  	struct folio *folio, *folio2, *dst = NULL;
>>  	int rc, rc_saved = 0, nr_pages;
>>  	unsigned int nr_batch = 0;
>> -	bool batch_copied = false;
>> +	bool do_batch = false, batch_copied = false;
>>  	LIST_HEAD(unmap_batch);
>>  	LIST_HEAD(dst_batch);
>>  	LIST_HEAD(unmap_single);
>> @@ -1843,6 +1890,8 @@ static int migrate_pages_batch(struct list_head *from,
>>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
>>  			!list_empty(from) && !list_is_singular(from));
>>  
>> +	do_batch = migrate_offload_do_batch(reason);
>> +
>>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>>  		retry = 0;
>>  		thp_retry = 0;
>> @@ -1984,8 +2033,7 @@ static int migrate_pages_batch(struct list_head *from,
>>  				nr_retry_pages += nr_pages;
>>  				break;
>>  			case 0:
>> -				if (static_branch_unlikely(&migrate_offload_enabled) &&
>> -				    folio_supports_batch_copy(folio)) {
>> +				if (do_batch && folio_supports_batch_copy(folio)) {
> 
> I was about to say, the migrate_offload_enabled usage in the previous patch
> looks off.
> 
> Can you move that to this patch here, and use in the previous patch simply a
> default migrate_offload_do_batch() that simply returns "false" ?
> 

Yes, will do.
This is more clean.

Thanks,
Shivank


