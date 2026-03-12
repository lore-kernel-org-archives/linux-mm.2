Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D5BFED2F6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DB86B008A; Thu, 12 Mar 2026 05:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB296B008C; Thu, 12 Mar 2026 05:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0791D6B0092; Thu, 12 Mar 2026 05:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA5686B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:34:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D0005B976
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:34:16 +0000 (UTC)
X-FDA: 84536900112.30.3BCAE70
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E13B1C0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:34:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="W5/kka0Y";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773308053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvzKK2cTLSPc1xAynHB5WNoWPKNa+W+rr5tyQiOg5UE=;
	b=gbIYZw6J6MjAjQ6zdoByAj/lIG3kDHH5OFddgOX+wRXhostueroa8QCsG31EyuW64WsTLz
	gVmwoRnrSbZ5p8hm6MqhHPBB2/qdn9DOjZSulikcbwgIKYlBvq9VQ1yFACV0rp5a4Ks77n
	c8J45xoKrQ5aZT1lBgvCur7wlmFrvFE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773308053; a=rsa-sha256;
	cv=pass;
	b=as+ylAVo6XbRks544BN2A4xKFznzSpRU0AhaSs4AyqFg4jOIxcog1GsBaxIj1N53nplVbV
	jvhfiz6LPzksF9XsBVJFMMtuexTgbtm+nShMP3QjhmQmQxaPKy+9PbDx7I8kNC6FVDcbNm
	WOU7uwCPN/FDYk0LYI1emkvXDjvOF3g=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="W5/kka0Y";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtrHU5fPzwOWFH7Xbyvl7roxNPHelkkGcB2U70F/6MjeJ1hduYrAPhOtZJ9tidhzND+ig+ALepRdjZcHAGxvl7k8drE1/z1ABY60NfyD6QENzLqhfAqyOheaTBOdP79ysnXv40BZ2929RaOJiaG3CeTTmjCV6Uz1Ud6iTOKXc7Po7QXPAQ6okOUrvOinRdh7YW633OMRyQFIg5TLXNQbQ5EtTQYz2yWP30pd5slnG5pFtGIzzBEv+2GR0PRoHbA/e+nC0oCz8TunouxSuZTlcmdF3olctP/zEfQm0erIh0Q/XWKPWSKIcMxn1w7Txdx8ZKOgqaZqI+TJ3venU+/1Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvzKK2cTLSPc1xAynHB5WNoWPKNa+W+rr5tyQiOg5UE=;
 b=sLLmbJYKYxvvR9B4UrXIndm86x5xR09MENwu5mCeXw/WFyCSs9iJYwmOgavfM8Imy6ik5hmXpyCGEOghbY0hur0fZ6fUP1ob4UZSXB9/kQ+hs5uxrpkPDsjhLltkm85MjAXXtbhVmQQQhesRJRuq6VrCgfRe2DMoeMvE4qZcdJCuac9yaySafxE99JqI++OtiK3V2yR/F1G+AjOvAyEglU/6cYnFsStPdGcem8vI5skGyHMjCpB+XspyzewcjiluI0Mmu+uw8yNMVXbyG2HWorgt5+sBcuUgB5clj6CI1MFsYdWYslTMmkY1u3S7cPAqsozfDbgLf9fNfcJ82hZyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvzKK2cTLSPc1xAynHB5WNoWPKNa+W+rr5tyQiOg5UE=;
 b=W5/kka0YPpEG6vdTik9DwZmBCvuP1pZQ3pcnRajOTaBUidu6wJT/NIkUaBPAaenSaojhc0f1VozOQUy9eMj9IDvkH2vQr4JlLJ+kO98cBT95/4P7CqTdr/pCgqcrS9wc2pLPBYYtpwwYDDj2VjY8gxj27O8gbaDgMTDgPXNfT6s=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB8217.namprd12.prod.outlook.com (2603:10b6:8:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.4; Thu, 12 Mar
 2026 09:34:07 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9723.004; Thu, 12 Mar 2026
 09:34:06 +0000
Message-ID: <ed36a994-1e15-4f6f-9e91-6306b7b15447@amd.com>
Date: Thu, 12 Mar 2026 15:03:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-14-shivankg@amd.com>
 <aa8LvK8COQwFuAeg@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aa8LvK8COQwFuAeg@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0022.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:269::12) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DS0PR12MB8217:EE_
X-MS-Office365-Filtering-Correlation-Id: a4133b8f-8161-468d-2917-08de801a817b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bYr81zDFx/y0lixsmP61fGoahjGjRs7prIX/EB8m714fOIim6FFEcLhmQ/gdL1zk52MIwxqAjPWyWaZVC/YQeNjVKuvk3aJHxlQrXxtrx2H5ceaJLEa4JR0txH0n0Yc+poIarjuCxEW60k+7Y2Ftm5ZXXuSBILxuNF5GV9ylSmxtSoWTMQ+q6TA33IONtsKdLddfqjCICTpzHi6fotqspGqY0JrDjT/+QvX6XQXm4zue8S/C+ZzolFfF4XSaPPHEvGzwwt5SrTM1auVWmCV7Tsw30FxjVVbc/NBDxs0GdU7XC6XnsMQJvNBH/mPvQC4YJeg3aWVvjiUVZQ7SVGmpOTHHOalQ0m6Jl40tQz2hPlFC5bQkfQ0/QqphoWvXdzE++EjHOMUW7RfCkjOTfa48PcKe2NdCYrMRQzJhe65rSb64fMtAJ0kTSSBV2IqumP3CHQkhDR69mDxFxuNDy5wyEi4e52QUxibFl1kdZrytEiVa6MLBaYYoxuiEPzeRaJfQKqLTbeAq14U5xIDs/WEc3dlj6fIASltfgvX6pzJZohUNBGF9TCmcXVvhk+D9F9FRfLw5DG01aTxo2GjUyYnOWXULc3ygWbT3coq++JPr9Z/8ZhU+tcAPgHDi5LUtz5cg3Yps5jc+iAdWOxRzCFL8LyIRl03yhhpKuEKwRoO4oLJPv0AByZfh0PR6/5LCS8vLVJzqCHp/w5orc/ifelBibL+nn7ml3eAANIPtt+G1kG4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHRqcGg5RkxLVFdnNms3TGxPUDhieWNTNmJkRXJ5cTM2TVpVK1M2Rng5VlNn?=
 =?utf-8?B?OUN0MGowT0pKenZraFdYRDViNk9PcU93UkxnaXQ5MHlZeUtsVEphNFJVV3o4?=
 =?utf-8?B?Q0JIN3YyRW9Yay9xNnVNMjMrNlZjNStWeHRDWWNtR01HMkROODlKOSszWG83?=
 =?utf-8?B?YVN3ZzRGNmMxUWdDYzZYWGtoaFl0eHUvN1BLRUd1aW1Nait0dHd5SEpSaG51?=
 =?utf-8?B?YlBGMVB1ZlNZVnB3OHlGTytPSFI2SUhJMGtJTStFWTRLUmgyYjgxYXNRMHpv?=
 =?utf-8?B?WnhPQmhPQzFaM0VkeXdmdEtkaWJkbzJWQVoyc1VTZzM0R1ZiQWh6VitBZEtB?=
 =?utf-8?B?b0t1SE5GL09oZ3JJTTlnbjhoZ1hPMkl0TitoMUxrM1R5NGFGU2Q0dWphWmhK?=
 =?utf-8?B?alhPYWxESm0zSUZyS0t6RWdCU2pnNDloRnMweEVRYTZLSGw1WmZwdjRwa2pB?=
 =?utf-8?B?M0kzMG9aalhPRllxVTJ4OTBhbit1N0hUS1RuRm81UnBDb2dJZzVLNjBTKzU5?=
 =?utf-8?B?Z2x4ZksvSXg1ZXcwTXFTdnk0cGN4RU5yS1NGRmEzanhqNFAzTXYxK0tWZzkr?=
 =?utf-8?B?L2Y3cXdJZnI0a0h3QVVEYVY0Wk55cGlOOGVvblJZbFlPeCtkSFFMUTFzVDl4?=
 =?utf-8?B?YUZ4MjdUK3JIMFVNV0NPWm9XTjRHTWIza0hMeW8wY3hqODF1UUovellXZVlH?=
 =?utf-8?B?K29ocngxclFaY1MvSzRkaWJTeTg3WkpVWW1mU1NLc1kvU3JtK0RpMXdMMmJO?=
 =?utf-8?B?T2NreisrK00rNE84SEQzWjd4eklKNGl6NWZ1ZUszZFQ0eWxjTnN4MFZwSmUr?=
 =?utf-8?B?SVhJbFUyZjVkUTdrQ0VUTzR6NzFHVUtIc0x0VU9GSzl5Q0pHcms3b2ZrL2I0?=
 =?utf-8?B?cE14eVQ5RXljejN2MmJNQmpKSWM2YjhtUGd3OEZSZ2ZJOWd6dlVSbXVzK0h3?=
 =?utf-8?B?SDZIUVhWclBVbnVYT3RDa3drbisydWZWay9GdHVkUXo2SlQ3aC90djhkbnYv?=
 =?utf-8?B?Y3krSVF6WUdGTVFuWmtISG9EcjZjLytvQUNmU2FabWRxbzAxVmR0YjJDYlU5?=
 =?utf-8?B?eU1idnVwOXlKUkZVZTR2WTVNcDM1SkdRTktRa25vTXJkVWxXODdjMEtFeVlv?=
 =?utf-8?B?WE85SW9yUTUxNGw1VUNab3VnSDhvemdSYmk0VTAwOUlQR0o1NHdIQ0NyMldm?=
 =?utf-8?B?aUtaZ25BalJJc0NkdSsyUjY4N3o3WmZsaGx4endoV0RtVnFScFUvWXAzT2U0?=
 =?utf-8?B?SzRobitYQW5rL1lnY1l5MDRqWXVReVBLTkVIZGZSUFFySGYrZml2L2prVDFo?=
 =?utf-8?B?L2l5MFlPeW9VNndqWURxVUhyd3EwT1lUdnV4d2FGWnAyK09Cd2x0ZGxIUjJL?=
 =?utf-8?B?QURqaHFEUWdrSFNmQUd5ZTQrT3pjU0dsOUFubXdCM2t2b2Y4RXBCRXNoajVC?=
 =?utf-8?B?d2NHOEVsZVBTR0xsc01EVG41U0NvNnpYQVFTa2kydW55emtSOWlhUjhtSEdC?=
 =?utf-8?B?VmxvMnNnUjFLU0J2WGxSQVg4R1IzMGFZQlN2eWoycFhGTGVmR01zMEc2Mm5R?=
 =?utf-8?B?YmdZbGVwOVYwVHlnV1VlQlVORHlNeVdDbnB1elcwaUlUU2J4NDFvYmJycnZj?=
 =?utf-8?B?UjJNUjUvRW5ON0lIbzZNUE1oKytlSHZ1cUh1djB3U280SlFvWUNzeEtCbHpW?=
 =?utf-8?B?YW5EcGo2OFpvWlFzR2FxaldMOXBxcVJBeTZ6eWdETmZmaUVqcjcxbGhCTmxL?=
 =?utf-8?B?UHBFUGFqVnlhRFRYa095M244WnpLWlNBcHFjNnhPNWQ2QzRGOStueWFLb0RI?=
 =?utf-8?B?U3QzWll6YW5zRjRsRjJXanQwaEh3SkR6SWtRQ3MyMHArUVlSa3dmVEl3SGZK?=
 =?utf-8?B?ZDZzd3pJNlR2dERSZlJ1YjVZSEFpc0VvVVUwUTNRTzgxQWhSNmhSc3cvRHAx?=
 =?utf-8?B?eCtCNkxhNFgwc2ZoeFR6Ylc1VTNMNElNY3BwOXo2bTBTWTdDbXRFdCs4TjVC?=
 =?utf-8?B?SjlsU0ZHU05XSy9YekRSNnB5eUd6T2RPelJ1dDhVQUp2ZFdINElCczF2TVBN?=
 =?utf-8?B?WTRleXkwdmF1L0R3c3NtNEl6bE9QSzZ2OXJYLzhhbCsxWlBCMFdzUVo3K2VX?=
 =?utf-8?B?WnJvUXkxVkNmZzlFNlM1aC8rL1VURm41WXBVQVNXT0NCVktISkoyWHhJcTZC?=
 =?utf-8?B?OGxuak96NDJBTGd5ai80TGdsS1JBQitNNnJOTVFTZlpaL2QxZUpNdnZqcTJv?=
 =?utf-8?B?aVBxMVBQWGVXT3VmVFEyLzZIWGNwVGdQZTVzeWVNUDNqOXhpcTNWZmhZZHhT?=
 =?utf-8?B?NDg5OWVWNUZXU1JIeUVvUmU5WWhQQXFQTHdaSXNDazU2QnV3L0ZDdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4133b8f-8161-468d-2917-08de801a817b
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 09:34:06.4507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6NO9Ic2ojKu/5we6XQl3QnuHyRGnX1Ssofx1fAEsQR+iHrPfwAE8usCThRzBCXYShb/2FaamLQmrkR3hyVSI4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8217
X-Rspam-User: 
X-Stat-Signature: iab8zuane3g9ou5kwd64tbrfrpanb4be
X-Rspamd-Queue-Id: 5E13B1C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773308053-96694
X-HE-Meta: U2FsdGVkX1/eTr3cUAJLCy0lblydUty8k5qiWq8csMrnLlB1hOksgt8U/eY2+r7wcx+nQqwXfxvltSssuk7yiA9LayxVRMKvrOAeOi+uzqoHRqj3FayEVDBhCO9DAYf6GfbtRTbs5p6u8KQMx6+oWorSBcvVxz8QLYI64xBvomHKNRfTgzHByVr/J+pcfE5xsMQL0BVmJ8l+nD8dCr6Hu+m1tu0aKcXFRLLgNblXylT3xkbXhgJ2GWMK9mQXzhyoss1Zj+U6IRAOkEdzDrcBT8VWL3tkzaX1FlIJaoV/PrB7p5A40j8W75299Z0yLD8DFyCyZ/1+5/UFfy4RuqyK1qmv3oDZMzLtXwv4cQsS4mp/9GO4VT+G4lLs2zI8nnNCMTvLfVZFQRbLc9BlIYxg14+m1WkvwDeHBU3MnCJzAwBsYvMO/+UJ52EepG9mrMGoSHvfkIrbAE6c5tqZo7W8mE+LzWy6ug01aZpw7DMMRWFC9VhD2WyxkAyhV1LOB1gDhU+99bXUQXdqVmwMMCkYR9xTpFnkJo+Ks5T/WwD51tzLgqO7gYdkJLn1nxzz4O39g6X45CbJ4Cg4OMvpqJ9BTGsPHYVKwyZ6kdPOC2YAcYNN3o2xilJDLsDqQSr7SesMSoHLPDQ2bDeh1kVb+Pz/Eg4u1cI7Z4Nmm3zYN0hkttAqcA+Y/ER4i3QxuXLOrv0KjTi2TuwvebSyYn5BH31TDOYwdsRK8f0J5YR/JwMKd+s/A9zD2u4Y2QucxJnWyJMEDU8VzY6MnMFGu2SwMc+cMThw5bVYcLvEXvLgFsrZf1KyflA8FI1Rg864ZEeDqJJImRdUASVMiZVoHoeq0JYOFlBXej4lNNVAaIOLGk6ZjRiv+UT3q5d6RxzLoM4zsW2Jd39ptrDaSVSsAvz8BLv0FSx6ru7Ft38CASBt7gM9EBliNEsz0lXRAGkN+WZ4Gdrcyid+zDzXnvIzAfRrcy4
 3vKUNff2
 8Whz0whZgRXc4s7J0XC6il6IYG+uzFFMEIews0k8tP7YD9dri516FNwtj7gxMmbiaCjaDos4x3ILuiHfKLicHj63mTHldeIY0jbquP8OjkN2DDI59eay4BcyrPrLbv3GxMwMGPTRhZVGHjzk/nz0SvSjNbsqCMbtOCLyMXIWk1fA4YFmPjKNjasWpL+kfrl461vBkDPjTf/gv04dSTg5gupF4LtcEyJPWFV+7t5GBg0lkqbz5OAP/D2XfIIE8IvpA+emTOOJF4KXYaJ0mX2hfh7Q7pAWOWtRl0YJ4XxLe7O+XAJQ7fjCFGIhvrbGpCSoIDMOHWzzXKQ9zuZPX92b/RfGFPEwQ0RAVP+CfXHd+JRcVohmNoCZFLLWGvLj8mn8ibq1MZu9vPLHl5eASmPs6pTit1HnrMX+SDtxpNnFhJiXcO/6Z9zg9Z1qAzcVAbWqA5QAm7wiO0q7dt88ruNw2ppC/nv7+L8l6d9JV/oCLQDtc3yjD4y0SH7FtFl8BEpfZnv0v7qzPXEOFXzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/9/2026 11:34 PM, Gregory Price wrote:
> On Mon, Mar 09, 2026 at 12:07:31PM +0000, Shivank Garg wrote:
>> diff --git a/drivers/migrate_offload/Kconfig b/drivers/migrate_offload/Kconfig
>> new file mode 100644
>> index 000000000000..0bbaedbae4ad
>> --- /dev/null
>> +++ b/drivers/migrate_offload/Kconfig
>> @@ -0,0 +1,8 @@
>> +config DCBM_DMA
>> +	bool "DMA Core Batch Migrator"
> 
> Should this be tri-state or is built-in the only valid state?

Right, will fix this.

> 
>> +static int setup_sg_tables(struct dma_work *work, struct list_head **src_pos,
>> +		struct list_head **dst_pos, int nr)
>> +{
> ... snip ..
>> +	dev = dmaengine_get_dma_device(work->chan);
>> +	if (!dev) {
>> +		ret = -ENODEV;
>> +		goto err_free_dst_table;
>> +	}
>> +	ret = dma_map_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
>> +			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
>> +	if (ret)
>> +		goto err_free_dst_table;
>> +	ret = dma_map_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
>> +			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
>> +	if (ret)
>> +		goto err_unmap_src;
>> +
>> +	if (work->src_sgt->nents != work->dst_sgt->nents) {
>> +		ret = -EINVAL;
>> +		goto err_unmap_dst;
>> +	}
> 
> Fairly new to dma space, but I thought the dma stuff could merge pages
> on iommu systems. Wouldn't this check hit fairly often?
>

I tested on Zen3 system (with PTDMA) across different folio sizes and
didn't see this check hit in ~1000s of runs. I'll think more about this
problem and discuss with IOMMU team.

For now the focus of this series is the batch migration and core offload
infrastructure. This is a reference driver to test the offload plumbing
potential performance benefit. I'm happy to refine this once the design
settles.

Best regards,
Shivank

