Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB66EE369D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8407F6B0005; Thu, 12 Feb 2026 11:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EACF6B0088; Thu, 12 Feb 2026 11:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E36B6B008A; Thu, 12 Feb 2026 11:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9C56B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:11:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C26B1384C5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:11:23 +0000 (UTC)
X-FDA: 84436294446.16.A380C63
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012064.outbound.protection.outlook.com [40.93.195.64])
	by imf01.hostedemail.com (Postfix) with ESMTP id 61D8D4000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:11:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BGohSnqd;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770912680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oeh7YYEHw1l99rxc2tutg06pjGmwWcaZ0msZtS0RWc=;
	b=I+rwVhvi3uCK1XvfCkBcemA4bG2hkyzBPh9SLrYugc71g4Ed+ESwhDFpbo1kO3AfmsoLiG
	sG6MsdqCSkxAjXj1jUrcKq1ZROwUNxFflmDSsSg4mmMuPBGPFOu2v4H3rwnd8bvPjYknI2
	Q4ETCyd7BF290KdXtcjmlCXMQwGoLOc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BGohSnqd;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770912680; a=rsa-sha256;
	cv=pass;
	b=G/70WZ6T6cRlUw89I3iXEihC0sjMR9PR5EYGApHC/AedK18L2goysaYsSiNK/Jj2lvm35+
	3XrNAJYXAX+qmooHQzJBuFE6VvTov430JBl1oR0nhHhITPZsr+xCUsPirMpdKTbI8jqvF8
	YrkcJ1ZTJIA8mrISQ5BSANDs1d4s15k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQ03saeoNebabWXu0ULNyu6y3OL8HZb1rKRbiF5N+7wRrRGi/IrwcS8mdSEoT7k+HFAhs3EXsRbBh9ma8OrRxMmNOjxOEWVVF2NDjfDEywdMTy6NheF42vK8RLLccCujycD4Zi//v5rWzZT3yQZUKOZkf2lcaOfPEZjQ+IlfmDNkWKlIWHfYPSOA0J30/ebyc3uW8/Ji6buSqOU9x98Y/GUwE7B+2wUYv1RcTKM12CpCcELEn7d5iiSMPVCDPiWT4TykBOgG1vdHwGHQzizr/WM4Qs3rq899lBXqP6kuuOBcioFmegDwGb/YvjwAaZoCQ87VWNs8rrbgurmTzqfQMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oeh7YYEHw1l99rxc2tutg06pjGmwWcaZ0msZtS0RWc=;
 b=O50iQypwdD2hiLIJY7N3LRzTxguzR4wljxiIMssSU+uPZf81qT2l5AA1m92iMV7dRvNKY62mV3P5AuwuRWRx7k3hLYUHxyxxVL0yW1l/ANM3sPyWo4aQfwC7iphFrdDOEmXoNU7B/x+gEBn5so5gEillaEz+TxZi7gjB2hQgWK+Y1IjJsSpPWIlq2xQFdf2WixiwN1/UDK1GoiFUEXahuTgR5vpUasAA/MWFa7+3k/cUqCHAsYwUMbJlQGyhEMzOb2DqXMqLPu4EBRaU8b6mQVeXH0EAIr3qzb7/7ZdFb1+FRzaHaVcmhGQzrjBkHcP++0UWUq8yK6RbHCGpAdq1Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oeh7YYEHw1l99rxc2tutg06pjGmwWcaZ0msZtS0RWc=;
 b=BGohSnqd7R+eQPFRLpZduLDde99vRWp63AHhD4+iPmwjQrpTwb/izQB3m4uUh1A7RrRs8L6Kgo6gImjX56GRydxcIbh3Whf98siR64FQ7NE5+kJo92w4nxFC4bULAzYYeuLJyWOWL5nkpCdrTPlVmPqnsP+VIvIPftlls26WWUoZjTW5IQy4VlQt+QHs8a2oEcEJeaGWJ1n9Mkp3X2MnNcGBMfBoSnF//7kQ/MtcMtSbXjqIHbM73ug/BQV+GvkvlLszED0xMtpbSY4rJV4mDtrNJHehMI6+PZC/MCTieHcBSjZ2eTV4Zq1gRhdXBvPOp//z3VB6iVXMILl+xJ+HrA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5594.namprd12.prod.outlook.com (2603:10b6:510:134::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Thu, 12 Feb
 2026 16:11:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 16:11:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com,
 jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
Date: Thu, 12 Feb 2026 11:11:01 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <6137D40C-C781-44DC-BF8F-68EEFF582326@nvidia.com>
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a0933e-54b3-4b90-e165-08de6a515643
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hZ4zk3qXlPw6S84nT60ju0l2zQwnCcr4vTVd8YwRXYBZGWp/1trTP2nQc2rp?=
 =?us-ascii?Q?qQ6gjRxF3KKxXpqxlszBIwPth3V0CWku7JH54rxhyCxSihjUzDW8/ZXSFgsw?=
 =?us-ascii?Q?GFyxuOwhIjzzpWaXfT/Jk12f8/bsB8LxV4U2yfL1qsqjipf8k7Ko2/ZgEmog?=
 =?us-ascii?Q?ucEB5WOz7JXi38UyEwdQCt33dCE68G3UJFrGX/3XS59EYxIC+0QSN6P6FTQ0?=
 =?us-ascii?Q?syAsnjZpUnAf/jRfuqbUdrqHu89EV2XGNZjYYejVkQHyd2fqF6y5DUK7MdQ+?=
 =?us-ascii?Q?BY6smuwplMf7I22AcQiu74345ykXpn9aHAb3/hFlHyR9Qktvs4a0thgE6G8M?=
 =?us-ascii?Q?11xvH86cgiukGe3Rf+ziORru412/hzIoQSuo0Nv614E8E71uHkCoIx4FZgHR?=
 =?us-ascii?Q?uKGonT5Em2uko86G8//2O9zMDolgJV+vQ9hxp97gAx+lenTRsFwlb4QHP04+?=
 =?us-ascii?Q?R0PALHzy32BZNhmdK43ulf42fXnMp4tgAo2DpQHcj5qCqcqbCJtALunZyN1/?=
 =?us-ascii?Q?jP9pMEvRduC8Aq3/EMmvzUL524g+2Vp5FIp06Q0lXIdrudLogWkXNft9jPXz?=
 =?us-ascii?Q?QIxgvVw3AWacdPNjYU/6drr+xwch6/toHRJc+O0yRGtOS69Saf4RWW9OypXe?=
 =?us-ascii?Q?wy8Z60OHEUC9+5Z0lBv0tNhBbnlS4+izKCCgVMZ4DSsLMx6tUxVcY2Eito21?=
 =?us-ascii?Q?7/r9fsyW5ncp3lowNV5rhqHJoKGvyM7Wl5HKMx6phJG7uVcEhsXefb7Rg2qx?=
 =?us-ascii?Q?rDDMZpSwyUkpO3so6rRlm3323BbsnS/SpeoUqly1Jiw3Hc/SLfzDaBUa4PEq?=
 =?us-ascii?Q?Tlyp9SsAtFn9rn7QznTOVbYdZWxbdmUF+XT2ojHUl/AKjS6usSaKahALusi6?=
 =?us-ascii?Q?JWZ2cHDCOjcS1vJU0L1EyuHC/+uyuFqHn4T5SjwXDcnq4zEkJWMAQC0LVXHU?=
 =?us-ascii?Q?Ow4MCn6OhN+vQX0rSjA4s5cka9S8jC+nw6NZgK8AAqxjz5z0keRzXyIdVfrR?=
 =?us-ascii?Q?eiimYbrSEqUxZFMqYWdP4rZpUFuif3zPeIMHFGSq/MG94DGGS7Pr/V8qCuwm?=
 =?us-ascii?Q?Ub2fGolS++W2bikoC40NDxGT7NBlOCGYN+B7bGN5D4qcMZT2EuluzYqgptRZ?=
 =?us-ascii?Q?GW1gaeZIsukwOPxIijsXSe/Ce+5Gr8tNcQsQU7EBuA7NYv8Qlmqaz0phY8Ew?=
 =?us-ascii?Q?oeXl/DTMTfJkn9wzi8cHvlRnEdYcHu5zi+iz9GZWRV/VZIkYGVgaI6JU/7SP?=
 =?us-ascii?Q?baAFHFmtoxpi2nWAWSa9G7CJH0ZoN+CTWy+s85qwT0rAoKvPVk1w4wFQlEMs?=
 =?us-ascii?Q?daKJWFFrBmRD6yHzGFAewvGcOFiTvk7lMIL9dWhP+fTgYqpkwuXsJpXLezvO?=
 =?us-ascii?Q?G3sbwyvFfiVsEhCOtBktlmz5kIcD5na2GCbfpn0cnBcLLa+3Dskc+X/ZVYC8?=
 =?us-ascii?Q?O70v18liCHheOSZTKX1hlqWOqDoH9johgjOajziDurNVmdyslq0g8eVcyqfl?=
 =?us-ascii?Q?JuP7u7zq/OxeGcZfA+EqYADdf9ESvA9YdUYVsbNhB0J0aHepazjCHdbDwZay?=
 =?us-ascii?Q?LEa57kh+dh7VdXrpjwM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PLNBhv4IKEt+aAgzj+Qa+4U2dcMdCnthsJBcLs1qfXH1D5viy4SZiqW+N+iw?=
 =?us-ascii?Q?uG0Wsn0FcRkUfpMOmqmYKWpuX0DLja5K2IyZJWEiJo7w7oMNxpb9UbolQwbp?=
 =?us-ascii?Q?fQLEASL4xfbHEwsUVjxbgTiNQN/YKDr8oivnKtAUnKaTR+04bNeNulLRT6ki?=
 =?us-ascii?Q?p3YaBNaIwM57Q2NUT25azJsS6R4taC705mhmjwZwAR0Go8/9KbWA0bCj34AK?=
 =?us-ascii?Q?3rw7nfhXK70w7R3yyXaYUI47zfJNeHFjrff9tltDJ+WWg2TeonLmnnroKPkJ?=
 =?us-ascii?Q?xVxcaF972sud3uFpjZKANVuervxlBA2sm3OT57IQjFSLhsH2we86EHVrp/qG?=
 =?us-ascii?Q?5gcvEkaTNa9Q+OHI+N/7+Rb8GYZttHsHAJYRsg7+6qlo+T+dHb27UmeFW9+K?=
 =?us-ascii?Q?OrwwKHd1+/lnJ7YeE95c78lR6/Lu9E7Y973PIGS1Q/cHYW11tsRbkavyYvHi?=
 =?us-ascii?Q?Fy2rh9cpAG0s9Vay5ee62mopBV5f5bfpS8JjNiv2AFPDzyDSI/VK/9sP27qy?=
 =?us-ascii?Q?CWr2hqMIL49Fl9Yoij8ve95GoqOTYYjAM3iRrns+v4u595eUQaO/wQzmMDip?=
 =?us-ascii?Q?ap1La+ZkYidvtc8fxdaXatck3gE5OjUICoIIom9r5E0g7WTrrxHED3dH4Rb3?=
 =?us-ascii?Q?Er/aPw13A1PwxTLd4zEp0BiaFCjFn1BDliOJlZVPlqhWrFtzISC1NFLJMMbz?=
 =?us-ascii?Q?R+LB0CxwMB0SbQq08fIkHVCDF9ECXShd0e5/ANYB4PL0sS/XVQYfs3ohGhgC?=
 =?us-ascii?Q?xFi9rBJ2PI1q0LEPSuoPGGHKS0De7UTc2ITBQSeQx4RjSn9dfjvcallJSJaK?=
 =?us-ascii?Q?fuT9EEJbfw7inlaWqs7fobC+YvEVm2vWLYCfpYqR+LyTJ2FzB8a5jH83MKOr?=
 =?us-ascii?Q?8bNRgI/6FAhyeDl7yEZiTi4S0VVeXGxGIwuVeaZR7OoiojNH42Wx42ps1J43?=
 =?us-ascii?Q?g1wRtn/j4PzAtPr3ZFi7td7fc43sWdNe6t5kgXfYpFNNwnfOslFn6+9cKjGl?=
 =?us-ascii?Q?GMkUa0nSw3jLmbX/2QdWSRJZKhMiZOITBihugOl6dTt3o4xXT9/INOuGAeXQ?=
 =?us-ascii?Q?cqiiqJkOKvAewW7ZxrZD7CtPM0CnMmyUD0owZ84e4F6248TEeb5FYcIGBrkz?=
 =?us-ascii?Q?sIW1UHXdJFuSZEIFYbHOgOOIxg571MUk5Vw848IvJ1OYk7aWhnp0phbCOsOj?=
 =?us-ascii?Q?7I9e0ZsWmN/bS3wLHJG5j1j34tSB9rqK7m2l677thSDw+YfGr6zpO0sHO/+i?=
 =?us-ascii?Q?5MmFnX07mEiIT3701Ku0SvRoXvWnXI7b/AQJTJLyjJr/NTrEpggcRyI9dw46?=
 =?us-ascii?Q?m6oMoRwMGuOcTe8+EcyG7tlm2YVhhhGQYb8/oyyXR/m0Sq9f11Yb8xh1bI9R?=
 =?us-ascii?Q?oNc5BJqHpBxzHGQkjWK3zIt1O3lolnNtUed9xYpSvVDIkq85J+4N4wZRFERW?=
 =?us-ascii?Q?mRZcRGxO3KXf44VSBX2LCYqt9wD8zYetr4dR8Ji/D76a9DFjdRYQR+uH011z?=
 =?us-ascii?Q?U4Y7Ij6QG1Ox0Gz2yrIMAxmrWVtdA6bgbe1fLsv4IKM43U/YOOPRSWOQLRwP?=
 =?us-ascii?Q?BF4+8jyF8WHtTS1JZAsz67UyTlkPXHFtArdJ2twhFYFRJ/e486BfyU3EVqYy?=
 =?us-ascii?Q?I0gQMygItsVBV2psTuzZN9xbOBFSGdT4jonwbPkoWbff9XG57NggDkwpSwXw?=
 =?us-ascii?Q?1fx4n3+E//xqRkfFS6lHEDw43ampiNH9gvQY1eSEjYbWbB88?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a0933e-54b3-4b90-e165-08de6a515643
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:11:10.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfXAeZMs8dKV4ow3dnrsbQrZXaXd6fbKtDI4Jze3qIQ4Yyg4S6hG2XgZsOkNbbf6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5594
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61D8D4000E
X-Stat-Signature: an64qy4ni3kg8aopugk3gmaqhnubfzp6
X-Rspam-User: 
X-HE-Tag: 1770912680-185931
X-HE-Meta: U2FsdGVkX19TYzEpE9folkMUFYFBIZqKzrfUza0NpymwOJHfCdsUf29VCim9Zw1OXjpPuuCKZL+AU0n/8qXqsDxMdrfWV5sCzemE1J09ygpZJAnRbhceu1/katTr2y3ogl8U7azki/y+CvAiGwsxnsSDDcfYoYgir+VIf/92IyjySZzUEgZoEnh72HxH7PlMaubOrXyDsJ0M3GKxyQz52wFBL5v8v/Eq/wjYBiv7B1CxIs2Oi52W0EsQ+DR/IhO/yb6NbcRvF0bhgRr3TJ1K1cNEPRcDhd6KdcRSp9e3LBR0Karm2zN1MwY+qcXEOzUF1rF/hs8ZVFkoTxJ43FnJ+wNF96imcVusdSNkkTl2IFjQuIZUxuWPUSne1Q3AhQaWPBdu+QlkBxeObP6Cn39bLBe+Po1bTWBJz42ifj1nSTqlhYG5SPJ5B4/Bw20A2JgaAitB1McIOOYXCrfPRJqig9SbQvYg4Fo9cjJxTX77HN7x1RsI9mynxOFTkQfY++B+4JWm6xvV1lHAOho9AwC+4yugH/f8okS0Eq8AhQp7Hz1qWVKOQ278ABV/+syW4NmfdPu6hPYsltDyPTlgtXSeItbY8mU0X4xtBY+0DYS3Nhw+oNRkAVL30BgqHnp2QdWIYXBpLSru7XLKoUeBX3PYAZXOzAElih58MVKI+IdxM2wWvNEaQ2RIX4ml8NhCtxgZOWGBqwZtIFVGsPX7vF3OLGJc/L6XxS1/v/vlQluUaAarMq7cNTLuWwCad6PBB6YkGA7i5gPlLZL1B48abBlSnCaa5afIFHao4/MweGE8PhR8MywqRgL4DxOhGOtGgDmoF7SwI0dL+S1dDVDbKXiOEdTgXJbm3+uadAhf4fPYTrFSJBO29Fh1kFXcuOG8HWCcFIaD/7Yo6WNOz+0pGPYDLCIHnq9ntc4qBmQ5eXekBSfEtZPk1ygshAmtL7rle3N+lTbugBWHytMIn6nuqeq
 zDvQGWfm
 dKOxEn8tbks1QStD+L4P+DsjGSJX8JXVTsGSit66ZCOX7ItCPyUho9B4pojNPsiiweTb7vUjjCGgHIxrSqroflCz33oCk50Q+Eiy9GYIZeDbUPXQXa29xcrpYfV/q/2ZkXUHY9FYuYAT2aqk76VSMTYOpNadUAfvVgOIudSbDeq6rY1Kzl5sECssRy4XClnKgYoqyHqvpSM3f3L0s8F6mCLhs11Gmw62bIWuQpHLxFJw3uxlaTbAS4mJYoYpcNoNhG2cEqVxisFTsAUTAvZPqD+RyhCzRsaYLBDIOEiYO0XAqC07neOBIRAVYl83AAcLuqceR5zMC8gbEyZgQnesEMb/1kBRtGmEqh/w9uOHaswMoCt8CWnfgNzhOokd3giSJCHyawd+zg3V4lxK1L0YmJhAdZoXHXldqa8jZrLJIdAELWks0U6oW246leO17muY2SbwhodM3jC0ICHMCPl9oVLVA1U7vatwsWy10ryouv4oFAqIm5/38j57mjomgc2rL0gVKGfi4rqflvXP8IdhRfBVNyVBw+Y++VU9F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Feb 2026, at 21:18, Nico Pache wrote:

> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
>
> arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*
> ---
>  include/linux/huge_mm.h | 5 +++++
>  mm/huge_memory.c        | 2 +-
>  mm/khugepaged.c         | 4 ++--
>  mm/mempolicy.c          | 2 +-
>  mm/page_alloc.c         | 2 +-
>  5 files changed, 10 insertions(+), 5 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

