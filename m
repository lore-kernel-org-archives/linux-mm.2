Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41672CD5BB4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553136B008A; Thu, 21 May 2026 09:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503AB6B008C; Thu, 21 May 2026 09:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7FC6B0092; Thu, 21 May 2026 09:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5666B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:21:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4688140650
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:21:06 +0000 (UTC)
X-FDA: 84791487732.05.F0EFE44
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id D72171C0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:21:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NwnQMdVP;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.2 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779369664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRvO0rcoIw9/4zni+tMSWTRTFG8bGDx32HFePu2deD4=;
	b=n2P4eLeS9Sl/4kFeETUg02JWXQV0hgSnlMGBBK0lVi3gewkyEntL8192m9Vl1WGAlMb2VZ
	JxPNvL5JymJvZxrkQ0M18HC5JRHPVBQSETJnC4g8H8+sfsc2YBttuqY3aS4x4FgAfwUE/9
	Fnixoc8OaENG/DdNIHBmtiFhDk5XR2k=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NwnQMdVP;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.2 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779369664; a=rsa-sha256;
	cv=fail;
	b=yDickr0IFf1f3LqP2B9ed1Yjr/dCnNrOhUMlPCz7kydj0Xpk4H41bcsgeY//UwDe1XWj0r
	fXX3jLNqjt8XN1mRz3ik05X592nbDFHwrX78UExgJoWo+w9cdQ5aCqMOFWacs95Du8/BbC
	WEMDklkU/IpYCrI6wNFA/gb7WA7/9kU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRlxPZT5Ak07XVOmW+EKKtoIFyk3qzFtZRLTO7up5LnmPL6pDLHuV3jP3oJGGurj7fmZNBtaRyH2GWL0ScAyKxM/oEd7g+9ov8qjGTe5qVHsenco9gI/dxmVa418nGO/yxu+VgEg9icbxo+OTFTqPf+djBE9PHVGtDBguxS1gEeonj+N+rcM1OZr3PIqSAIn067zHMvH15x4oAK7uWrkjyjnPqJYKDQHOHnKS09wd1aAvnlItRIkZoqZRZ2BWP/XwPJrGaoEzLP700Sp/43+n35T4cCcgWTVfbtS+LwVxP5RpN9TJufg9tLRdVTWDBe2EawFS6ius1CIBwkzIMsHng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRvO0rcoIw9/4zni+tMSWTRTFG8bGDx32HFePu2deD4=;
 b=gckpkp9kAbm+Uu5U4BLE0DK1gul8rt9q9Bcj686csx5Hpdd8I0Gkj/QVytFtsby/ZDts0qB+1NRh3nQqJJVFyx88DPJd7Fs51PRa1eRIGaKff7bMOzUven9z7qOvJRmc2uIV8bRVr+3rQs6GrBSaFR6cd+542kBfALGm3QWBQcf35SeK69CM4EZ7TZmBtCfmS3vHQnCLXKC5tu2lVfOBqbH0X+GZaMeJT7qOPsmfYHKQwh8UE3CDNzXpGJWUwVaOEHSC8MT08m20O8y8uueYX86zEe7QBQk0GQ8XAh97u6/ju0j1/YhYIMaW4v9PUynws8+3bOO4l01rtfjFizEl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRvO0rcoIw9/4zni+tMSWTRTFG8bGDx32HFePu2deD4=;
 b=NwnQMdVP3qjemiDTkMEHvBjjg7OmEh9xuhwphkfi8TRJvqc+MoDmt5lf5tEEPUnVwU2zFTeWiqBmMaBn0NVxDkdh1VBhbapWvE7+dMGLydZaC+laetvKqQ5nK+7eLph7BhL3QErX1tewK4ULfOaS8clQ6Uy6bUZ1XHI542VnUss=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by IA1PR12MB6210.namprd12.prod.outlook.com (2603:10b6:208:3e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.16; Thu, 21 May
 2026 13:20:54 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 13:20:54 +0000
Message-ID: <88e14abf-d4c3-465f-9719-0999097a2342@amd.com>
Date: Thu, 21 May 2026 18:50:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
To: akpm@linux-foundation.org, david@kernel.org
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
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-10-shivankg@amd.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260428155043.39251-10-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::6) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|IA1PR12MB6210:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c88265-b5bb-4174-a4a2-08deb73bc927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799006|4143699003|56012099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	/thi84uaL6j+H6Q07SlQ/ZxfBgTPPlIGg2Sb5aVv0QuECQNiy1MEhFVCaz5k30YE+Ca1YE+YytT2oc18Of9IGv5I4NkwwWVCJ6pam5QfJRE9zZV7ZJNkLL52+nU2QrISG6Dv89dakg+f9f58ig67IM7qDslFY3UJXaeffsiDzOexEiqFfROssEUYg14IHvk148gr7GrwfyjEOUFhJw1L78DMfHr+SWnL6jvFSxgY2AdflCX2SsIlcHWfCYfMoBB8atZqwiJywfSbk78Og19JAvdLwONnP9C7MVRo8RAnDdd52jCb6NCgQ0IPp1n8HQLDrtIwB1e5AvuDZfinEq9PL3gl4cnZG0UebxsIVeGXOTzlwykzS25yXVszGHr//PT7okLwDUtstyco5JK3+JnckyU7f6iQ4P2RUX9pbKIsZLX4ZItbB/t+9YA9jbcL+uqebEm6HzATNvaKF5YSte1j95sSei0r1b9RCVERnCsGI+HDKktYFNCd17bbZRSzyU1CttpvfjAFA33LwBAxT3hG1Nx3CZ3yuyr+lda2j4iLkFqMjUtjbtUQn2eLAYaufb5n84fIhEw+c75pfbg30C/vZmmtR5XUjOdLB1+TH4chRd3d649UVNN2pGem2h3zrLdwaaFNi2Hmczz2xSxfYNsSLw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799006)(4143699003)(56012099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEJDWkYraVJucnJSNklYdXlGV29zVEMzRE1KNWI0UnpSVVpWM05kbHdPRktu?=
 =?utf-8?B?MG9mTGxvbFN5clRxWk45SXMwbmlLU1RpYlJ0dHllSmpEOFoyVVZQeHNtNzJs?=
 =?utf-8?B?ZmhJSlM2VkI5LzFDZXU0T3dlNEsvNVdUNlhIc293RWhFVnl4MC82VXZ6KzRt?=
 =?utf-8?B?cmxkUURJakdRZnhBVWg5RENUUEtzdWJSdnZoNHppOUZjSUxQMUpEYnVCTnh6?=
 =?utf-8?B?TzdNYjJDZFVDTzRxVTh2cmI1R0Jua0hLZWRXdWVoeVNKVkFXaVFvSU92YkZP?=
 =?utf-8?B?VXBkSDh3MXJuVTM4LzJsazFkMU9YNkpJOFRsbFFld005V2l2MXM5TDVhdU1I?=
 =?utf-8?B?Y3dXdW1NejV4SXZWanhDSnI0LzBBa2tza3E1UlZiSFI3eUFxU3ZkZ1QxemZD?=
 =?utf-8?B?QmRxR1dwcHhWMWczTnArUnhpQkVZaUxmbG5ReE1ScHdQYU1OaDI3Z2hMaWUv?=
 =?utf-8?B?UjVKU0wwVXEwcGN0SUdPeE9CTEkzZTNyNGxqUXkzUC9OdFNxNEhVMXpBNG5u?=
 =?utf-8?B?c0ZKeGppWmNudnYyaThobEJXOUdXcjF1eVIvQmhiQWF6K096U2d0ZHFDQVhD?=
 =?utf-8?B?MTBkS0d5ZW5KT0ZJS0RUb0o3RDYyYnVqajl2c25tVU5pYk1aZ3lDaW1TaEJn?=
 =?utf-8?B?Mm9WamxGSmk1Z2xoZEhXOHpLM2l6U0luaC83cExzc0RvQm5VZGRWbjFKQVlS?=
 =?utf-8?B?Q01WK01oTHRERktoMjQ2dVQ4VHBnaHhrS2hJcnhBNGdLSkRuZk5GSXdNaUlo?=
 =?utf-8?B?aDZ4RjgwKzVOdlZKNExBV0VsWmJaKzQ4YXZLcGVtQkdtQyttZjBZTzY5THQ0?=
 =?utf-8?B?d2RRS29Nc0xLaEtKcmkzS3VDZ0lkeEVKODQvRFdwT2JKb2V4cS9FcFI0WjQ4?=
 =?utf-8?B?cmgzbHVteWkyV3h3dVFEeVRwSUwzTEtyZnhSV3hFUDQxcWh5WDQ0anBmSEUw?=
 =?utf-8?B?M0V3M1AxNGN6eWtIbll0NDlsbmoxUnJrR1RhUU5kMi9lc0J6S1NYZnlDbVNH?=
 =?utf-8?B?cVM3WXYrVjI0VlJ5TFdaMHIyYzYySTJ6S2Z6bFhjcnVFZmljWmdSU2dPOXBS?=
 =?utf-8?B?clNpakk5aGRGSnIvdGgrc0djcVIwN3J3U0dOT2dEU3lZZk5FYjg5aG9wSjND?=
 =?utf-8?B?clh1aHFFVW03cDYxY21PNnFWZUdkeGszanM1Z3pHRU9tNms0dUYxM0dhREdE?=
 =?utf-8?B?ZTJzWjFXdFc3Tm1pbWFYdkNvOVNidHZGcnh0YTZlUWN5YlNhZTZWdjRGTDZs?=
 =?utf-8?B?dmZRakNZWUtuVnF3Q24xdFhIbEFCWjBQdFlRclhta0VxZEdwU2JteWJ0ckxp?=
 =?utf-8?B?Si9KZW54WDhwRFlMNXVUT0FEdHBkUUlxUVVzSUhWSGxodnp1akVRbm9jalR4?=
 =?utf-8?B?R2xmTDJzREx6d01QbDAwWG9CREVhK211QXYvYTZwTkJKMmxHemRyOEdWejYx?=
 =?utf-8?B?dThXSXZoM1N1SDcyWERCQW11OWZhVDFhKzd6L3p3bVFNSlpBbW5Va3hvWHh6?=
 =?utf-8?B?UmhlSW1mZGtFamNLWFdoQnBXUmIzRVZ4Q0FGUjJOYTF2M1FhaFVJZG5KVUZN?=
 =?utf-8?B?aHBvWSttcFJ3dTNaMHBRU0I2T1I5OUpxNnVQQ2Q4RS9ITktKUThYaDRFZUJD?=
 =?utf-8?B?UVdWeGZtWFlrTmp0OEZmSFVNcVFIRWxHYWdKS1B2aDF5a1RCMmlTUHZaeTEw?=
 =?utf-8?B?TGR0SC84bk5yU3o2b25sVWgzRjcyTWVqbXBMSml6MExCZG83bzBKNDJZaVgr?=
 =?utf-8?B?OU9UWmdlbzNSREVDTHQrczdEbVdJbDVSV2EzRWhuazR4aDdxWHJNek93Rmd0?=
 =?utf-8?B?NW0rTVNROUVBaFNUNkJ2WEFZVitKNGxxTkRsYkJMSEpvVGd6RnlpTXNTOTl3?=
 =?utf-8?B?MUZuSTYzZlczK0ZyR3NzamZacGhuTHBVYVVuUVdXRGx6Sm94L0dzaGhTcndv?=
 =?utf-8?B?M1JOUEZMZkdLeTJSaldQSUlXV3VRVVVsdCs2VksvN0FiMnpKV2JQZmM4Z3Rt?=
 =?utf-8?B?b1lYT2FUbXpiSk51SVM4NnVCU1oyUGhWdjVHRUU5RFhnSFRVWVJTVGhjT1NX?=
 =?utf-8?B?N3RUTC9RVXdHUXhsOThOT1JFbEx6V3JlRlFXc255QW01RjZ5ZnhjTC9xaUZx?=
 =?utf-8?B?di9LQTh2ZUp0Z21RVXlPZEovOXlIbEt4SDJSSEtuNHRlbC9aTjdBRFYzSng2?=
 =?utf-8?B?NGJ0ME5aQzY1WWpRV0x2YngrSEFVT2xxbmh6VVpFNjFVbEZPUUpWMjZ4WGpJ?=
 =?utf-8?B?WHdNMHZ6TkIzTmhJTi9OZU1KUDFjZ056UGo4eTJlQ25LWjgzSEVmMFU5Nm1k?=
 =?utf-8?B?N2lHOC9icUVkUHBoQVpkaU5oWUFoaytuRElaTWp3STZNL3ZObnJ4dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c88265-b5bb-4174-a4a2-08deb73bc927
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 13:20:54.0306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vENypGtUeqOhRmHdSfZ3ZU1NNHxmZLSVcXLHFq6aqPsMMPK9ns/4yZbpBux0PBOFn//oDJVkmMkvt9deFvLi9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6210
X-Rspamd-Queue-Id: D72171C0009
X-Stat-Signature: fx9nzuu63rmadcnscadtby7ubi67ddmr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779369663-858927
X-HE-Meta: U2FsdGVkX19EsofwYEMeoksnwwtDkHHHvNam29Rkc7alyiyCUnf0jDIV1HANjXcQf8Zf3QBkBAFbGFVbW0lNOpy8UsXycJmuQSnbAs4hHHt4PkDBLKqDWyFBwCzcev8I4yw/cIDCLrJohAfY675rYrJ3xczdpwN8FdXi/pMz4JeH75bRE5HCLohAUQ6tFUhlLEzlSRXwMkBfhp5TTjVBOD3PPzEZoMIQ8ndmGZV5BJbtonN7zb/Q+YOqhMW3n7ibmADizXzkMmzLlBPQs6u9Uba9Gr70Brsyd++SspaPsdN9A+7ZzYTFkymv4Gu8gHLtPW5KG7uWd4dk0kQuj48GcPyUgmYNuj3uKoSRUQQlcJF+ImupPj1B93AiFZC5dAiuJiCH9nv8Gu8TC9XEnblREbs6o0M/dSB3tGUCSw3JKyQMcwJGlAHjnD5XNsdLmsCgXmkjubEQc02eD44aJmT9inbb7nswHCXOFtiMa38kSnaV0cUyXQAr8CxM/M0XhmTTs1eBx4sGYGZK2ZCBzAP6s660tUGea4Dviap0io2vFAPxTfhVJnVRb0fyriBPze8deaVsatG1J/URq6+keqwgqyhA7Ndyr5pThcMEddheQO7Aj7W4YjbGqQMq1qZDEpvqtdyEOObnyT+kyJg9VQHEEwgTnWQJaJ8aZ/8sVfQUUFVKGbLtHdpLHYRDI/h2F60VD6mTz7bxenRz2SxUBWjoGccmIaAjpQnel45FB7FCGV7tB6+hhA1dhYuSS0eC+JAJvCd5VFSbNkEAj9mtZzXP9GbVel/FrIgTf5dlziogmHRcQWFyXra4seE41Hi+WB+9CEkdTAibJti50J6620OwDXqQFzjrLeZmF/cjALApo1xY9aLUnYbKejd3in54GagCLJIcLFc7jIzrahAJfLa8z+wDtp3G30JR+lzi72V/c5OIiwj6i96/4MUAK7ATqB4pV3hHeJD1Llgwygd3NKt
 azgTIICI
 i7ZCZ231lN9a5tyrOgUBnaobmCbhjNE8fNo1PAWvtT3LN3XmSvgDHbWFDEIEeGGvQOFMfjtgU4Qpng14XQ2jdLJo2CNo4Gf9KjYz+NxOMJMRYJ6uE1uHpn/jlwjrNqqF0iSHw4OFFqQX5/bBRs6DTZyVoxnAiqVx0/KJNZtWg4wG+JGnVCzeO9KGZT4np3vsLioFEIt+nhgT7dd69z++TKDogNk72KBA7drntUGxNFPnAwD7tHm0irT7mlt7MX8GAP7XcNajm2mOJXZR6TlDHi1jITxiDzhypLyBO6ONyT5Ub6FYfxo+l0qSW4tAanBWZW/NKuVqebJniQ4rlgjxGh/7tf/OzGRchtkxkxv+kWGwEMHLv3i1c0uIcJRKPYUnrw5EJvrCpI4F22vYUpgWHFfs/5I/Fu2H3XZ3IExyMXifTNyS6WBBlLO19qUP15Z/dXj5ul9P8vT/4Tdf5rKza+v3oEqOSLTOLXUs7o0aWPjspVeBKDeNWq8LcFV374zQUB/jPX7CedZE+wnIjOfr+vf8FaySKONtAdxf1PsiwBAJj1Poq7uwjXkeG0riXRSjXiNWtGfgD9V8JfHdnik6TUusRcrBc+yGZBPbPboQMPPe5veVZVumVtuPgN28Wl2XafBoglwG1rmOjE3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/2026 9:20 PM, Shivank Garg wrote:

Sashiko review comment:
https://sashiko.dev/#/patchset/20260428155043.39251-2-shivankg%40amd.com

[...]

> +		rc = folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
> +		batch_copied = (rc == 0);
> +	}
> +
>  	retry = 1;
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>  		retry = 0;
>  		thp_retry = 0;
>  		nr_retry_pages = 0;
>  
> -		/* Move the unmapped folios */
> -		migrate_folios_move(&unmap_folios, &dst_folios,
> -				put_new_folio, private, mode, reason,
> -				ret_folios, stats, &retry, &thp_retry,
> -				&nr_failed, &nr_retry_pages, false);
> +		if (!list_empty(&unmap_batch))
> +			migrate_folios_move(&unmap_batch, &dst_batch, put_new_folio,
> +					private, mode, reason, ret_folios, stats,
> +					&retry, &thp_retry, &nr_failed,
> +					&nr_retry_pages, batch_copied);
> +		if (!list_empty(&unmap_single))
> +			migrate_folios_move(&unmap_single, &dst_single,	put_new_folio,
> +					private, mode, reason, ret_folios, stats,
> +					&retry, &thp_retry, &nr_failed,
> +					&nr_retry_pages, false);
>  	}


Sashiko:
Could reusing the batch_copied flag on retry cause data loss?
The early batch copy captures the data before the exclusivity check
(folio_ref_count() == expected_count) in the move phase. If a folio is
pinned by DMA, the early copy might capture stale or partial data while the
move phase correctly detects the elevated refcount and returns -EAGAIN.
During the retry loop, migrate_folios_move() is called again with the
original batch_copied value (true). Once the DMA pin is dropped, the move
phase succeeds but skips the data copy, leaving the destination folio with
the stale data from the first pass.
--

IIUC, This is real race and original code avoids this by placing the copy
after the refcount check, so by the time we copy, no extra ref are held by
writer.

To fix this, I plan to avoid DMA pinned folios from batch path, by adding
refcount check when creating the unmap_batch list.

if (... page_supports_batch_copy(folio) &&
    folio_ref_count(folio) == folio_expected_ref_count(folio) + 1) {
    /* add to dst_batch/src_batch list */
} else {
    /* dst_single/unmap_single list */
}

[...]

> +/**
> + * folios_mc_copy - Copy the contents of list of folios.
> + * @dst_list: destination folio list.
> + * @src_list: source folio list.
> + * @folios_cnt: unused here, present for callback signature compatibility.
> + *
> + * Walks list of src and dst folios in lockstep and copies folio
> + * content via folio_mc_copy(). The caller must ensure both lists have
> + * the same number of entries. This may sleep.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
> +		unsigned int __always_unused folios_cnt)
> +{
> +	struct folio *src, *dst;
> +	int ret;
> +
> +	dst = list_first_entry(dst_list, struct folio, lru);
> +	list_for_each_entry(src, src_list, lru) {
> +		ret = folio_mc_copy(dst, src);
> +		if (ret)
> +			return ret;
> +		dst = list_next_entry(dst, lru);
> +	}
> +
> +	return 0;
> +}

Sashiko:
Should this loop include a cond_resched()?
The original folio migration loop in migrate_folios_move() explicitly calls
cond_resched() on every iteration. While folio_mc_copy() calls
cond_resched() internally, it only does so between subpages of a large
folio:
mm/util.c:folio_mc_copy() {
    ...
    if (++i == nr)
        break;
    cond_resched();
}
For order-0 folios (nr == 1), the loop breaks before reaching the reschedule
point. Processing a large batch of order-0 folios here will hold the CPU in
an uninterrupted tight loop without yielding.
--

This concern for large batch of order-0 folios looks valid. But I think the
current direction is to remove cond_resched() eventually for lazy preemption.
So should I take Sashiko's suggestion to add cond_resched()?


Thanks,
Shivank


