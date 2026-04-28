Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5694FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 17:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D006B0005; Tue, 28 Apr 2026 13:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD5F6B008A; Tue, 28 Apr 2026 13:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C859F6B008C; Tue, 28 Apr 2026 13:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B36806B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:11:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4645E1A019A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:11:46 +0000 (UTC)
X-FDA: 84708606612.24.0DF7604
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012020.outbound.protection.outlook.com [52.101.48.20])
	by imf11.hostedemail.com (Postfix) with ESMTP id 437474000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="BR/Z5mga";
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.20 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777396303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ManBLRGybzTT1WcRnI7E2sDfCUc0wlONizqfpLjV028=;
	b=vL8NInIazU7LUHiLtaiZkjVcBR7S/D9XAz6KMfKBcdubfoHKRkQwjcaYHGCyWQYd141e6x
	Fiely7F5dsdkWf+59L5rWVy5ToUBbqeTbbBzj/QGhJZ46IeALvDRoikOnX5R0IduqyKLsO
	LAwRD08ND5Hzy/LKL3A2FDL+RTqqhlA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="BR/Z5mga";
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.20 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777396303; a=rsa-sha256;
	cv=pass;
	b=wDkMYF5gXAdmkLtYS3x9F8TXyqJgFK1YJ7ATUVCfx4Um+6AncJsEIcmv5sEhv/Us8c4WO/
	NsAt+OK1ICMsPWGn/VSwAQE/bS1JdOjs0lBIhlF0ZfSlF2BbqyH6IFT6uyRXTd+NLZXBX/
	XrW066vX+gL3zHQFkkwWBy4nf5zgMo8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMz3TJYKxeW5yzQ1EikRkniPIzihYHLg02Kcir9oKzZ6gJnr0WPi3QCtVR69QqZu23uRk7z/VCQn4XTH3fxCRiDMvH7B7ZkYGXnJ18RjOaIjuDMlz+Z0epRGPTmc+z62Jh7pLBYRN8teTfbaoCn/4w41ZIFM0OIuSayQ3NzJWk6/m8cjvoYE7B4uNROgRQCCrC5FmsN4F4x1h31Qh30JhJ5RW1oDB3yrA2ezyxuNiWHWEXTIiWfTnJE7ZrKUi8Uo1vNv4LgkkrhoQXstCF1Bkdo+5FkZEfBkfBN3MsX6k48HvttXUSDmGvr8HSen1kYJS7zMoeCXyde0uFnCanw6FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ManBLRGybzTT1WcRnI7E2sDfCUc0wlONizqfpLjV028=;
 b=YuFG0cndsKf0NUiaWOIqNaYHxxE4wwks23wg8562BGPTsw4bu732wLLMqXVmOIEyIre/Bx7AVqB/faalAvN4ZSuqMnxcxMLWhrxD/nv4g/HgcO9AXPHup+0XMw1RB5X2+hPUSe5eVFbRfY/zylkaSfIUzqHXU/LMBZsFtD/OeezeYYv/J+KxTx4JYzA4B+OgfOEuZuyd66UGday7GasvsoIVVU+Yb8re6Itv1PXzVy0ZJM92Z1g7zAZrpAP1VL5ZS4lTnllUHTdVw1o4cPXt1HQtwT0xx/ccXgq6sLcfd55MLRcI69V0gfpebI6FutYpBHqmTVo9sej0QmpuFINGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ManBLRGybzTT1WcRnI7E2sDfCUc0wlONizqfpLjV028=;
 b=BR/Z5mgamnkUwTc4Sc4Kglya+JyysULpHED4d4P0j3ys3lqL3W11aCClpRwVzNFw+1QO4vNhmoURb4lUEzIZvZrIF+Emz7Rexzemgdlvw2QF/v+jB/4qUdPeqvIOhKEzBV68EJqSRxApefAqS3fcBjTzxRvUW9YgUK0rxXgHeyw=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 17:11:31 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9870.016; Tue, 28 Apr 2026
 17:11:31 +0000
Message-ID: <cca382ca-861e-4bfd-a628-45a5505b8b31@amd.com>
Date: Tue, 28 Apr 2026 22:41:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
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
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0081.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::15) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: d816dc21-da1c-4900-5753-08dea5493126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tEryem5E5Gc8U1RtlaUxdcrP++zYTSqfpvVDJF/E4dRfuHFWwDdUT+2jAi3cfUESDDIUJPK1fYermThddTpZqgurb3LhftmAHk/sW6KZmqepBS3ZHbPgsyXZlx068dWt7Ql7JTgTmr7kNwsZ2p/VUQxs+XOb97rAF9zWny8/JacqsEVN74yayVK2NCbaYkrw50oHcwgPdRH/NvEuKiJsh3GnOIiu46a4DasFP5eibEWlniosm63R6BVAgoWFAne6jFLxJONVnrZzchDz79/cXpcnQU7Z2IFQuwSb3asoTWUtMyEry6t8hXT3T5n01BXvKGFD+82ALlaGtznsYmMiCfK70sYRR2EzHaLtRT/QKoMohgECm0SahRsxUbEilOfleSyw6qVLCrnQuNt0l9yw7BQcOslCVpBKU0cXUcYX5snzRoH+Jl+/XD+rApbn7UvxWHhYczrqgf12DP7Wf7/iewPPPXWOZJkzUBXFOIOWnJ1yIV1GUmFp484CPExMt5J5DxMm5Mx4QyLMXA+UTHh107qIyIXv5D6RL9nA0J8XCWSqoeoTpTcWjWxeHZ/ZWo34gZzwcamhkOMnI67XyD/8eHihyOCBIrNgePZ6oRUX0/oD2P+gp7bVfJlr3pmrSuAgUO7pP7h9loTT6B8uvqBqCbCmi0j5zEqJmCvCKyD92LC2E7ixlEtaPAO9TnSYd7F3cFmlV6vp5YNCvCaTxKh1nRgbetvpAdiDsbStgr9xxtI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djR0THVLZ1FFT2xMVk9pbEhtZkRqU0tmUjF4T29ha0M4dEpRSFRNZk9PL2hl?=
 =?utf-8?B?bkpWM3U3cExGZUhNSkliaXR0RUVHaTY1VjkwNlBvWjJMc3JPR2F3VEV6ajgx?=
 =?utf-8?B?UlhWdkpBOVo3a2dYSEJlemE1Y3pzSkFXcFBGUHBhdkRrRVhxY0FlUklrQkdF?=
 =?utf-8?B?NTFXVzZqY0FueHg1aC9YVVorWmJMQml3ZkhYb0VaQUNEZk9pR3NkczNXRlgv?=
 =?utf-8?B?czNhaTBORUJRV2xSdnZEVzgrelRRSHpxeEtBWEFqejVmZGZSTzNlYkFQaDV2?=
 =?utf-8?B?MnRwUEhPWkhIRkJkd3d6UitqdDJ4M1lGYVE3QlViUFU4UE1mUHEvNVJ1T2Rv?=
 =?utf-8?B?VmovNXdJUEs2WWR0ZEZzanh1V0VuVExXQzN1OUwvdUU1d2pMYmk2Y0t5MG5p?=
 =?utf-8?B?dHhMUU9LdVlWbkg0YWcxcEhtWDVuTVdFMElnQnF2NDZEMlhjdzZWRnRHZmNt?=
 =?utf-8?B?N0pWNmpxWTNEY0hHWkRaMlZwTHNXWExXOGtQQWpqM3B6RnRrempvZEdrWnU4?=
 =?utf-8?B?b0JKc0xIaHdQcGYzREJRYjQ3OHNyTlAzN2Z0NUo0OG1tU2V3MlR0NW1SSHhp?=
 =?utf-8?B?M1VzY2k3d2ppZlAxMDJaTVpNUG4zRkxZcndzYzc2b3I0dTVIQStaVEUrRkND?=
 =?utf-8?B?M1o0Q3dKS1pFZC94SmVrRnpUSDEwd3VMdXozdU1rMlFCVHR4RE9BdlRLeVE2?=
 =?utf-8?B?cGh2Q2xkcDE2a0IrVUFBdXBScTdPZUsvcGhZVEVhcXNaRUU0M1RzcUplWXVH?=
 =?utf-8?B?dHFQSlY4VG5SQi91VFVCTEhiQ3ZrZUtlUWthS0JseEROSmJCQlBhNE1KU3d4?=
 =?utf-8?B?dGhpK2tsS0hJYXh4MUVzVEcxRWNNang3eWRoNlZjaDl2b3hmTFV3T0RMM2ZQ?=
 =?utf-8?B?Mzh6RFcwREdCVUkxUjk0NzVvakNaV1RVSXppeVl6T3NMSXZqRDc5ek0vMERR?=
 =?utf-8?B?djBid3ZpSElYdXREc2tRSGhDU3NFMjZYTnRqUDA3dit1TDhTQWVWWEFQSXlY?=
 =?utf-8?B?QlNFaHpSV3JSaHJNQTcxNW4xZTJVS0dJcXo1MUxsaUNwbndQalJJMWl6WmNN?=
 =?utf-8?B?VGVNQm04cTVUMjNmWEhNVjc1MkFlcGJ2dlJHd0kvb0N2OUlQWllTZGtvZVU3?=
 =?utf-8?B?NUxzaUdpbW1NdGZ1b3ZZc2RJMWtBZEtGM3hyU2x1RkEwbDA5aEJrV0ptSlRY?=
 =?utf-8?B?b3RjZ2NhaUtmeENESng0ZXk5NTFETEZsQjNsWWF6RmZQM045ZWptQW5LK2VR?=
 =?utf-8?B?TVh1TEFCUGFTK05sd3crelJ2YzJ0VTVUM201WFVoWjJ4cTBwb0llS2lSampL?=
 =?utf-8?B?djhsRk83MXZlZmVXaURmK0Q2eTIwSHN6WnFpYWJkOWpQS0ZORTZXTzlMZk9h?=
 =?utf-8?B?RTB5cDJZbm9RT3NkZnJoeER3Z2JuekNJRlFFQ0ZWdk0yTUE4V3BIODMyRzBx?=
 =?utf-8?B?WTBwQ1I0Rm5pTWxGMlI1NkFJZXZOWktYaklnZlVqQ2Voc2FTcEo0RnRVYU02?=
 =?utf-8?B?YmYrOHUxbURjTjlBdHNWR1pCQlRhOEdQeTkxdFpCd3c2REJmUThha29qRHN5?=
 =?utf-8?B?dmV1OHdXM3M5SXZtUjIyYnYzdE1qOWN3YkJ3YVQ5N2ZmaCt6Qk0rN0I4ZGpK?=
 =?utf-8?B?cVRpbWRKT2kvRXJaZ0pHdGVHZ04vT0grbzJ4UUpxMGtabFpSTkhMK1d0aTNO?=
 =?utf-8?B?SkxrY2FiWndFb0JKMWMwOGhVTzU4TnlVWmNrUTRNNkpreTEwbFVtNVJteGc2?=
 =?utf-8?B?RnlNZDBFc0Q0LzhuWkdjUVdOT3Z1a1AwQmFnQitjanMrQWJWRWg1RFpTZ2w5?=
 =?utf-8?B?cW1JcmFzZEd3cmZlNm96WTAwS3Q3NlNyUzdCR2pVYmZLa0trMGc0K3BaRk1T?=
 =?utf-8?B?VDkxK2RYbGJ4dFBRUXhuVDJZUlV4SC91QTNERnNvbU50M2RveWhjZ21VelRG?=
 =?utf-8?B?OXl0bENvQzVNNE1WZDBYeUdmaE5sc3JFQVFveEJhbDdXS05pNERpa2Rvd0dT?=
 =?utf-8?B?Z1NQWVdYdk41dTN5NUNsejUrcWtIU0p5aVVnenBKMTR1WmV3Q1cyVjI5QXVt?=
 =?utf-8?B?a2M0KytDK1JNeDJTVDBPRnkzek9FVVZIK1lJVmxjQUFuSXE3b2VFOXUrQXA0?=
 =?utf-8?B?REF1M1hnQmR3bnBBcFNyYWZoU2pubkduNHpOQmhCelJ5MGljZ1lYc2E1YXZO?=
 =?utf-8?B?Z3phVDR5TTZZclg3ZlhqTEtQZzYvWTNCaE4veWJNZnZiVmJjVlFSU2pHZHFk?=
 =?utf-8?B?M25DT0RSRENxQWEvdlNzeDVKMDFkU2k0dFpXbk1KUk16M3l5MEZ5SElyei8r?=
 =?utf-8?B?Y2tUa3RWaEZuN1Q3ZkRLSlJTOVhldFJ0Z0hZRWpXcm1aS1g0c3FuUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d816dc21-da1c-4900-5753-08dea5493126
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 17:11:31.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VpTRiuilP6Y3HRO2E19JVOBW2FRHk+CX1YsrYLLnORxxpyzMayLY+qppg3XKScLP7Iix0eJFzxj7wHC+3vlfNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 437474000B
X-Stat-Signature: oxdd1qb57brfjqjzcn5ea7mg3t8p1f1c
X-HE-Tag: 1777396303-97633
X-HE-Meta: U2FsdGVkX1+QwOxijP6zki9NtUsKi2UQx1SJg6TzOZAvbnllbxaQCtm6i1tTzfIhU/IBOG1po7Zwc4uulWuNMmxhRCTkEfriqZBRrJadf4oehBYhN6Raw5ezeqFQPV/mMwtfxdeR8tGqDSmhhu/MKofJRm7Mq1SoWftnQx5X5R1eBqCl4ha5kUcjCH8OvA7Hd9wP3indZuce81etxRqKq6BEv4/SMG2MX5fRNpVI1MLqO0QaOxMY9lAJi96BvdlyLI9T1phHNHJ1gimszBw/q44fy2nMEJF05eQd7jfgao9voocKmK+/WXHYA1RplvZi/bWsVinswAXnp472CX8dra+8VtHE5knCEJKKmoJLBWZRcKQfRceqVPRqNlVeSkYBKFkHyJQ2IIphyJMKl09AiSUw8nFd3UD19gp0eIdo4YhmLZZ+QqdvlpEUsPGTvr96Og3FguRNPxSSyGzkLAydBuf6eMnjU9uy3sJgAJbZOV9tZVqDw5XuJv+BTIp4I9DXI4V3B5K10sNnTvVuXpND2/nuBwnVclwq5UKN/q5USH5yAZ04DamVpuCB9R4dOrtnJJRO6Pu1mvAC3WyhYzHveZwgHgIzQCOWNvg/0d38fcL6q02ILv1j0dGNyCuQ8tKbe2MNa+6CFE/lFHVCI/zVcECcz9/bGX4cQsJ+vYLd9xw1jwB9VFaGHfSbElej/E5tLZ1TJC/35Afh4NkfVtVqI5hArbHEGOyRWBfWorsRMDQV3nAeJ+utP7GC6/Uay4kZESZnZ5OUG1KgegT38wy69MnHyGUMLn7AKhFBD+qBiHbipLV6qaVS6WiXmxBVITXuF25Ed6fZ9Kv5uklonDYUUBhW5t8kUzBTF4Sm3AUtyhUu/8oSebVlhhQr6Erd2goxlBCrZQ+y4GpjE/QCXT1CduNF+MVmCxoyWtHtzLGG6X/gIj4BBY7s37+0UUZecwcUErmZdxduYqqdPAUitCx
 e2iwwRel
 zcXcMj8sYtGlvgojoCXlOJcPTne8Si/QbNGPOatHTyXLjt+FJHixG+R7dcXRL9DI9z9HKYMFuz4lMRFtj9aGTXH0qnF8IbYfBtUZqsctusrnfyAY0NymF5WOXWDA+Wc0Z0RYuA5XNZLwyamm0dAsvAUxl2Y/+BMkEeDcLst9jd5KFMfYNBIXdOhVFd1LZL4QA+VUv278+USkTdYwrgAJ98N7w81lD/AO1swDh9gzW82UO41FzIxPvyelxoUI/4i237P+Ue32kRux/OUCuaNULK1xbdwsKgmx4BuDXwDbVQFv01F4H7FtIhlkRqdq0GIyLRF+L81wFFs1xa7YbWVVRv49dL/QQ209M9B7euxgqpzhQI7K1TkwD2zBcm3e2ZUNzrYspPQXeY1flvqlJh9XfDoEJdAHVa7kXbSOohokjiPWN2sKpIC0oYj+Pt8GGjDcLIo3lBPe1vPVh7LXoc14nWy1H2AOEBh5eL8yKH7qYliMoL+iVkPiON3TBTlo89MQVvxg6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Apologies. The subject prefix should have been [RFC PATCH v5 0/7].

This is the fifth RFC, as mentioned in the cover letter, but I
missed the prefix while formatting the patches. Please treat this
round as RFC v5.

Thanks,
Shivank

