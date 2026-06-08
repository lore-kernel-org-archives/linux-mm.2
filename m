Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB953CD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFF06B008C; Mon,  8 Jun 2026 16:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4960F6B0092; Mon,  8 Jun 2026 16:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385606B0093; Mon,  8 Jun 2026 16:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 259146B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:40:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6EE3163924
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:40:46 +0000 (UTC)
X-FDA: 84857914092.09.895E9CA
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFCF040007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:40:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dIKGpIVN;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780951244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsV9gm3txVLjt0lv/Gb8zkhRBqZiTuSWK53QAI+Z1Bc=;
	b=UVSoIMdJGJUaX7sOg1L4/ixJsbVpqiaSNLJKUUmvlN2m2Fr8Q53K5wVNSY7LPEnq8JiYyt
	95Jj0MBihjYaAfkHyco/h8ir1IrnNsNafdbXuOImW76jRAfTfjeyvNxYqswwn49RP1AqYt
	8Yq8q0eqANsz0JHFQ2k305L72nMAbp4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780951244;
	b=x288MiQskdTrG/kd5EI8GRAIbJ4qAl24Qc3TooZIGl7o7PyHf6DOknBKlmKEN+60Upu0CU
	pufdLFXXUItcIFuptuPdulYaafVKtE0NYZqRRqqvViUr2u8zvm3rM6JHMJY+ONgjBv99n1
	y/dULfTrLMv5bX37SBQ/u7SMBdX8YSo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dIKGpIVN;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nWId6TYUkfJ6/t3it0YrPfMYOglGY/HZukMnNA/LpCXlerd12tB+FEyd3Dor22q4Trh9vHdqMlouYZRXo4GjSHvAksjQV50uHs9VGicHSjbs7n4rOidFZDXizP+oSQjsDSAqZVmLHBUoYnngJEycqSXRlvdw5kenXQ2SNIIV6RTpbYCUcbbyar7IwS3ARaML1+MbG0e+3J6OKz74olWDlIxfa8g/m6AOokCmmFZPYsAqno3fUo43wO/Uh3LKF+Vd53WGn5xbSai/S1ZbeU0CVuOKM5zj1NpKPnzBebQklpVzWjuz+TKjGc6dYK5UOLyajh8fpIZStjQEBQh2txPzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsV9gm3txVLjt0lv/Gb8zkhRBqZiTuSWK53QAI+Z1Bc=;
 b=LZuYnK1eNBc1r/j6ZymEMDKtbU9teGNVBN45TV1gJ4xhPHE49fQb8WcwaYakTWPC3aqPhpT9w290bg4tLSjjaaUqc4LNMyzqNim0zaSFz7E7J/+396YiDJLhKRk2SSB/nx71F9SqcQL6sG4+yEQHEOko5HgIvMgWalTR4zs1rFjW5Ap9z3cAlOYvFeCR/gkJm1t/KCXu9paAguOBirkDrtyyPm1gx0HJ8Zoo8/rN+4ctDRXG2XdOx3hm/eHsmxN9n7GKBB+G95JF/tIIUiHek+FBISXra+HnIVcHYhenhy+yL/kunPP1qb+2rnThSWbI/QPPfB3oABj2VZYJ9RhLjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsV9gm3txVLjt0lv/Gb8zkhRBqZiTuSWK53QAI+Z1Bc=;
 b=dIKGpIVNdq4tzHMli3y9r77H/JK4W94Mqigu3w64GcFiQyMOoewMedk/kPTNrqUhRFuAWvRl4JaL4VWo7sJgb7nBXjjfKRPRdZl48rCu4RCNmgoS1dk1UAkYnzi5oMJD6+pM7uA0YKpAfdnfiQMl7ZPY+gHEAIbAZnqjFZzIgIQ=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MW4PR12MB7239.namprd12.prod.outlook.com (2603:10b6:303:228::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 20:40:36 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 20:40:35 +0000
Message-ID: <e0b16bc6-45ad-4383-a4c3-f0265dfae1b4@amd.com>
Date: Tue, 9 Jun 2026 02:10:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, kinseyho@google.com, weixugc@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
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
 <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
 <c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com>
 <27f6f5d6-e81b-4e0a-af39-b175187299e2@kernel.org>
 <8EAC3D9C-6956-44DF-861F-A4864F08273D@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <8EAC3D9C-6956-44DF-861F-A4864F08273D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b9::16) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|MW4PR12MB7239:EE_
X-MS-Office365-Filtering-Correlation-Id: 10399f16-3e07-4076-e0c6-08dec59e3134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ky+7Urw5jnH1xDy6uCFT5FtlVRldCNDTGA4ZfQnwZhy4WKUrDB9G12A+xbNdupui97QnR1+0rVRNiU4uq82p9k5KYgahoWPLxPDONKzkJU4f1wSD9z8PPZ39/Cxz6be0utTK+CE+pw6Kf+9v4dUelbwR308zSA+fMAFwwDd2HIbmlPDprQKRJW5ydg8mNVx+LflwMyB38FSkzPmV49h2XNAoYNxE62kPkCY5fPit1euupThrnO0m8bOGhQPQ/8YpzpzW2o1Yd26/l84mjx57RzKdkVmhAUOe3RWkoj8HI1x5VqBYnS6jekymTgxvJRLkPNmCmAIbvAroe1u2sku1E81TT1bgY53rvGEftEwDRN/ZAHrlWT5lFF3bMS9LoBBR9wtu6X97t1fRzY3fTKULURaLOnPA3wcKa/c56yTHJ2Q3AiICkrsqIz81DGkoSQGiy8BDkDTwtSr6lNCFNKBB2mSj6H8v3nWYMjw0Btjkuw7xuznGmW2ZDap2ePhMspT7YLr/JFS3RE8oRNvVqXTrVdzHJDGFe/bXQpzVRbWrI25uPf5kTYGaZPsYlP2uvvnlJIqccCgkHjETxJDJsumiGxiJn0iwv0clrvrd6ehrskOaM+JMlRfO9Tbf6iALIHA3+CDFKj08h7eJB+L62ET1JU3RM2QHTnuYEdRdDyABEb/XhADnBTPLKMCSlvxkpMDgHI0+iZBljWS7wPozBGUdWA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qzk1RlFlN2lvcVZHUE1XSG9QdnpEUFkvMHRUQVJobTYwaXBVQWFZRjhRVUhu?=
 =?utf-8?B?aGp3Nmg4VmVJNE1XMXJvNkcybS9SZnVmZUd5VFlOYUdQblAxUlpTenZEbUh2?=
 =?utf-8?B?MkxvYTZkcHR5WjJvWExHQlA3enM3cklIMlNOQzhEWVR0d04vQ2ZmUWtqZWY2?=
 =?utf-8?B?TkVyZjBRZEhDZjBvMWUvdnNMcjlnVGF6aWN2ellvV0o0OWxDSG41eFFMTDc1?=
 =?utf-8?B?dndPTXNmS1ZjMWZHM2p2OTlEeDVKMnRpS1JVVnZYOStDVFdWMXIzZjB5VVlz?=
 =?utf-8?B?Nkp6M2NGZ1RTdDFYSTUveUFpNlZhMkdkYm5tOTlpeFdrL1RYb3kySkk4SXh1?=
 =?utf-8?B?Z0R6MnZ3aDhUR1ZIcUU2SkhiQk56MzZZODFKQUpMUzdWbUF0VVl2R2FJdlZQ?=
 =?utf-8?B?bVp1MHdMV0w1T2Z6a2tCenlxNm05d1ZkV2d1ZUhFQW4rNzRmNTgranJ0dmg4?=
 =?utf-8?B?QnZBd0luYnJqTzBmWUtLR1Rha0NVV1JMM3ZEMlVhOVF4dnNQejRrQWlzeU9r?=
 =?utf-8?B?d1ZuRGJJL2NQRTYyeDRXUGJhdDJZVDF6T0xmVFYwOTJZNEJOMXpHR2ZKb0Q3?=
 =?utf-8?B?NnhTRVYwMWpsU2FPV2xWa3lVdkVUZGpFZTFiai9hLy85ZURWOEtjalRZZnR2?=
 =?utf-8?B?cTl4ZWpkWjlicWduY1VVVitrbkZlYjZ6aFAzYnowOVJqZVRhelpvdjZRR04x?=
 =?utf-8?B?Q0F1QTBiVXVzbDJqaVFVRW5VNVBFOTR3ZmNQSlhUVEU5TTR2V1pSQVBYNHg2?=
 =?utf-8?B?RlhadHJnVnRMVGJWRGVMK2VTUkhwcWZPVmlsSW1hRlVzVmJQRjFBZ2lyUDRv?=
 =?utf-8?B?VFd6cUNhbFJZZjhrdW05UEdJSXhmTGJzRFcvVUdCRjhyeUQ3Uk1kbHcvNmtB?=
 =?utf-8?B?RUFpOVJqUjdGbWY1OEtQcE5ucForR2hTNjZMMVJtVk1uWUQwRjcxUjZCTnFn?=
 =?utf-8?B?VElxZnU2UUk4ZWJRSjhqd1huRWlxUm51MUw4cFBFWlVCR0tnaStYY3RwSEdS?=
 =?utf-8?B?YU1KeTRrcy8xazZ2SGF3NUZPR0JVTVFUcXBySXo4VTd5WEdHcGhhOStVcjl2?=
 =?utf-8?B?ZkZUTEp0UW1uSHpROUJCVXBiRnk4bG5jR0pOVUdiZkh0SGRoMWhOTlJDNHl0?=
 =?utf-8?B?a1B2LzVEMzlyS0FVVUhCMXBZTEROL09WVlY1RGFBOCtXTmI0UHRjRjB1MCtj?=
 =?utf-8?B?TWsyMzJVTE5CR3l5aU1FR3l1Y01qb09xM2Y4K25qbE5GU3h5RHp4NHVpNDVm?=
 =?utf-8?B?WFViTk1ZU2pkbEljdXRQRFVzNE54WGZFMFlyTG5GQ01WKzNLVWpZemdrMDJV?=
 =?utf-8?B?MWxFOWVDY0E5Zm9vN2NFbDM2M0Jwem9QcUhndEIxdkNtQ2Q2UlpNeWs5MDRn?=
 =?utf-8?B?a0E3VkVaUFZtUVpSZWhJUlF6ZnliZHc0RTdRNXp2dlNEY1pkVDdaTDdMbVdN?=
 =?utf-8?B?Vll5azBDU3lJeXRpdW5PeUl5RzZRbnVCblJmRE54UCtIc3FpcGxHaVZsSXZl?=
 =?utf-8?B?a01lRFFZWGhoOCt6TTRIZ1B6VVVyRDBaT1JlMWNRTHBFUVlIY241WlpnUTBq?=
 =?utf-8?B?MHlDQy9rd0htTW81UTZQNDlYVzhoUDdVRHVncmJRZ1QwSmpGT1hFb3lZUHlB?=
 =?utf-8?B?Z2gzRXNFUVhtb0ttZjZEL1VWckpRSlpuUzBNdCtQSEhxQW9OQ1ZVbHBqWHdr?=
 =?utf-8?B?MXZhZGFoWkJTUEpMYXIwNDhNbThQdTBlSkY1dWVHTTBSbitiNGNOK05OSzJq?=
 =?utf-8?B?UWFsUk1MaEJMV0ZnVTFJK1BwUXY0QW0vWkFqMkdyWjFxRlpYL3YyQnJCODFy?=
 =?utf-8?B?YzU5Z1diRmpwUzZITDdyR3RWU3NsdXI0LzBxUlNxa25oK0pGenRGTEppcDkw?=
 =?utf-8?B?R2NxZ3lRTnBuQ2wzZGg0SkVreU45NXFFUjRUV0tPQWxYa0xvUURLTUZDaEhT?=
 =?utf-8?B?NEVDTUxRRTEyalgvbEhvNVowdW16d29SYy9hdnh4T1Y2ZCtJaEVPMU10T3dp?=
 =?utf-8?B?bmoweWZXMGhMQ3NVQ2dFNzVZYWV4ZUc5U3YyUXVEdVUxZUYyTHJjOXJ6bUFn?=
 =?utf-8?B?amdISzFpTy9qSVhIRFduWFNLQ1lJaVZJcjE2aVdwKythbHFwL0IrNUt2eEFL?=
 =?utf-8?B?NG81N1UyMWhYVnpTdDdnaXZZZmN3VmpJME1VQjVNVDc5ZW1nN1hvMXNGdktv?=
 =?utf-8?B?YTZJWFl4RjUvSmpabVNQOWE5bE0yQ0YvM1BPUTNkT1l4OU5JK1BnZXhzbm1T?=
 =?utf-8?B?NElxcEN4QlRON2NMdGRXL2dkQXFsNXkrWDQ1RHQ0REpERG5zUzJEVjlacGFP?=
 =?utf-8?B?TDVwbFp4VzN4UmhwUjFORXRnVGY1U3VjRldCSUNKOVRRc2Rrb3BWZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10399f16-3e07-4076-e0c6-08dec59e3134
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:40:35.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaEGf9UXibtXqxctvJiM08iwN0Z5Jp+s7nkYg1meg/emm0q9XVu6CINHHleDSOGHm6YAaRsLP0SGJLRNWksnzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7239
X-Rspamd-Queue-Id: AFCF040007
X-Rspam-User: 
X-Stat-Signature: 6dqeddqry7ehmqu3cdt83d6koqqp4t6f
X-Rspamd-Server: rspam08
X-HE-Tag: 1780951243-175965
X-HE-Meta: U2FsdGVkX19IDYvHXU40ChIL0+ovo7ZuH9+/EUmzf60NCK9cuTkZweOnlJCXtlobvpQiKdgMfeRjdIkn998a5SpXMYndWwoHmZGgjX3/fkLYrtUzGP4LnXUztHAPRp/kvXIdk+iKdHllQEy+GWRrnH+COYJv+QdU9bDTO3ECkS/j8uYcQP4Eeu2rYCxhZK4BCT0QV3vsHW9X5iX1cllukMEsr1gdLl0OxQGya9FjzT4E3zYNz5BRtw4eCcKiaWBYMOPdqXB1Z/xQOuqCKMslIGRBNU2WVXh9Wj+9Cwoix+cRRIseu8XLmtV+3XBx+VT7hV75KbYq3EXAsqZ7qeZ0KOemWp+Ba5YNEmmq0ZnxBoJmJlTqeIHDsR7F/N7U8KpFEmFxV5Imub2B9PNyLYFcc/Y/Xmprd+5pw0SY6QiNJlbwxDDm1Ys2lv1pZkSeTPuUAQvk2hxD9tWqpYJ1DyerXOviXdkHIJkMc3XceiexXwMBZ2LZ/KjStHJZw+j1ZIxykMIPtAoKaZyx6NhVRkHfjd6FgY8Z5ZHo4gb6cACo59d3nOnCI8uXiEgtfZX1DEGzYo/bNsjgiEukuHaTkBqq54qckHQUL0fcGNi6wDitTtEcvSK5MXkOpZer+gVgk/CUjInO8IYowWfKnICXtq17PD9ONZqjYtGk1UYR9J55UBGhQq5Oj+XVai6+/jeMRIF6B2bjk4lk0nOvf716iwxjMhPGmSJG0WhpjDFles15V8KBph0+qmwdD/7uC4uy+2rCmIehI+PjhsGhAjW60SFvRDcAwbxsQe0JgkjWpUOTUMajNR7z7noLw12I7UKMifwahiatoRt01lHrEI/UX+KGKaIs/VHyAUzZo/Xub+E8zHcFkRpCtFZriepHAugRujlc7Jd77LDAJDUOwQLn8hz1Yn/rgv6vXVcP/G7CUWoKaU2KG5WwSEeVcphg1PWBO0MNz8aUUeI80HEGWGOuVBo
 RlAHCr8O
 5OZC3kaCPI0Vi8kD+gRiesVu2bmmT/El5LqWByxAMDx0XB3mMzBbukmtEsvfAXXELNr3YLP3/35Ev0r0TNfs3Djnmlq8vaG1/ISnYnL1PNWZGIn4mcajt++knmC8zHgXBli2xZLsQe7tB1DjbXKFyF0XfIfKCuiXDTi8MLY3ABwyBe2oGcV2ymPO1EsP/4dDGZ/688f2POA0ZIQg+6JOwpilIt7+lLSiPS9BOYvRJLvx9dc5TrLYhRcS5LPGQdBiNxKNU6UOxXrpe1N2WHPzFM/E1jq/IwFnyT1QIMFgm5BsYWEbBMBxIi7QXiAy1Dal0OnvH7PNLQqaHV8TNyN0sYyMX6ih1jnmCjNv0URwwAe/8KSFqlPYv6zEa4Itzcf1j2wU9covrb6/KtX96/QY4T+Fqvenitk46pUFHRE4mpuSzL9Vu6M8uand8/6mtc4z3W8ScbPM8HveYTBjxJYRFoshWLAhBANObGAPgGwCTI1eEc4rVTUtjzUGwusJEiNLdZWULAzewYqSV5rTzkas0Dwt63Mb83RuDjxl/sTnU8Dykgzxp0htQqfRih3mYP8SRHBnUpMu60gE9sb8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/8/2026 9:06 PM, Zi Yan wrote:
> On 8 Jun 2026, at 11:25, David Hildenbrand (Arm) wrote:
> 
>> On 5/20/26 17:06, Garg, Shivank wrote:
>>>
>>>
>>> On 5/11/2026 9:10 PM, David Hildenbrand (Arm) wrote:
>>>> On 4/28/26 17:50, Shivank Garg wrote:
>>>>> Add folios_mc_copy() which walks list of src and dst folios in lockstep,
>>>>> and copies folio content via folio_mc_copy(). folios_cnt parameter is
>>>>> unused here, but is part of the offload_copy callback signature used by
>>>>> later patches in the series.
>>>>>
>>>>> Split unmapped folios into batch-eligible (unmap_batch/dst_batch) and
>>>>> standard (unmap_single/dst_single) lists, gated by the
>>>>> migrate_offload_enabled which is off by default. So, when no offload
>>>>> driver is active, the branch is never taken and everything goes
>>>>> through the standard path.
>>>>>
>>>>> After TLB flush, batch copy the eligible folios via folios_mc_copy()
>>>>> and pass already_copied=true into migrate_folios_move() so
>>>>> __migrate_folio() skips the per-folio copy.
>>>>>
>>>>> On batch copy failure, already_copied flag stays false and each folio
>>>>> fall back to individual copy.
>>>>>
>>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>>> ---
>>>>>  include/linux/mm.h |  2 ++
>>>>>  mm/migrate.c       | 61 +++++++++++++++++++++++++++++++++++-----------
>>>>>  mm/util.c          | 30 +++++++++++++++++++++++
>>>>>  3 files changed, 79 insertions(+), 14 deletions(-)
>>>>
>>>> [...]
>>>>
>>>>>
>>>>> +DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>>>>> +
>>>>>  static const struct movable_operations *offline_movable_ops;
>>>>>  static const struct movable_operations *zsmalloc_movable_ops;
>>>>>
>>>>> @@ -1724,6 +1727,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>>>>>  	return nr_failed;
>>>>>  }
>>>>>
>>>>> +/* movable_ops folios have their own migrate path */
>>>>> +static bool folio_supports_batch_copy(struct folio *folio)
>>>>> +{
>>>>> +	return likely(!page_has_movable_ops(&folio->page));
>>>>> +}
>>>>
>>>> As these things are not actually folios (and callers will have to be taught to
>>>> distinguish them way, way earlier), I guess you should make this
>>>>
>>>> /* movable_ops pages have a separate migration path */
>>>> static bool page_supports_batch_copy(struct page *page)
>>>> ...
>>>
>>> I'll change this.
>>>
>>>>
>>>>> +
>>>>>  static void migrate_folios_move(struct list_head *src_folios,
>>>>>  		struct list_head *dst_folios,
>>>>>  		free_folio_t put_new_folio, unsigned long private,
>>>>> @@ -1752,7 +1761,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>>>>  		/*
>>>>>  		 * The rules are:
>>>>>  		 *	0: folio will be freed
>>>>> -		 *	-EAGAIN: stay on the unmap_folios list
>>>>> +		 *	-EAGAIN: stay on the src_folios list
>>>>>  		 *	Other errno: put on ret_folios list
>>>>>  		 */
>>>>>  		switch (rc) {
>>>>
>>>>
>>>> [...]
>>>>
>>>>> --- a/mm/util.c
>>>>> +++ b/mm/util.c
>>>>> @@ -778,6 +778,36 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
>>>>>  }
>>>>>  EXPORT_SYMBOL(folio_mc_copy);
>>>>>
>>>>> +/**
>>>>> + * folios_mc_copy - Copy the contents of list of folios.
>>>>> + * @dst_list: destination folio list.
>>>>> + * @src_list: source folio list.
>>>>> + * @folios_cnt: unused here, present for callback signature compatibility.
>>>>> + *
>>>>> + * Walks list of src and dst folios in lockstep and copies folio
>>>>> + * content via folio_mc_copy(). The caller must ensure both lists have
>>>>> + * the same number of entries. This may sleep.
>>>>
>>>> This *function*
>>>>
>>>
>>> Will add function.
>>>
>>>>> + *
>>>>> + * Return: 0 on success, negative errno on failure.
>>>>> + */
>>>>> +int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
>>>>> +		unsigned int __always_unused folios_cnt)
>>>>> +{
>>>>> +	struct folio *src, *dst;
>>>>> +	int ret;
>>>>> +
>>>>> +	dst = list_first_entry(dst_list, struct folio, lru);
>>>>> +	list_for_each_entry(src, src_list, lru) {
>>>>> +		ret = folio_mc_copy(dst, src);
>>>>> +		if (ret)
>>>>> +			return ret;
>>>>> +		dst = list_next_entry(dst, lru);
>>>>> +	}
>>>>
>>>> Wouldn't it be cleaner to remember "already copied" immediately after we ...
>>>> performed the copy? (succeeded with folio_mc_copy)
>>>
>>> IIUC, you mean something like:
>>> 	list_for_each_entry(src, src_list, lru) {
>>> 		ret = folio_mc_copy(dst, src);
>>> 		if (ret)
>>> 			return ret;
>>> 		dst->migrate_info |= FOLIO_CONTENT_COPIED;
>>> 		dst = list_next_entry(dst, lru);
>>> 	}
>>>
>>> This will be cleaner. However, it will make the folios_mc_copy() specific for
>>> page migration and can't be reused by other potential callers.
>>> And offload driver (like DCBM) must set the already copied marker
>>> themselves for successful copies.
>>
>> Right, maybe some helper for that would be possible?
>>

I'm adding a migrate.c specific implementation: migrate_folios_mc_copy().

>>> This will have an upside that on partial-success (even a single failed copy),
>>> it will no longer forces re-copy of the whole batch.
>>> If that's the intention, I'll move this to migrate.c itself.
>>
>> True. I'd probably have to take a look at the end result to see if it looks
>> better that way.
> 
> Maybe do this optimization in a separate patch to make it simpler to review.
> 
> BTW, the whole migration code has become more and more complicated due to
> batching at different levels, I wonder if it is worth the complication to
> optimize for the rare memory error case.


I agree on complication, but I think this change is actually simpler than my previous patch.

Using per-folio marker lets me drop the already_copied arg that was passed through
different function:
migrate_folios_move() -> migrate_folio_move() -> move_to_new_folio().
And there is no separate error path with this.

Whoever performs the batch copy (migrate_folios_mc_copy() or a driver callback)
sets FOLIO_CONTENT_COPIED on each dst it successfully copied, and __migrate_folio()
reads that marker to skip folio_mc_copy().

If copy is unsuccessful (e.g. memory error), FOLIO_CONTENT_COPIED is NOT marked,
and __migrate_folio() will not skip the folio_mc_copy().

Since the per-folio marking is the natural implementation for this, I kept it
in this patch (af44801ee).

Git Tree for reference: https://github.com/AMDESE/linux-mm/commits/shivank/batch-migrate-offload-v6-wip


Thanks,
Shivank

