Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C411C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6AB6B0098; Tue, 22 Jul 2025 01:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77236B009A; Tue, 22 Jul 2025 01:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17F06B009B; Tue, 22 Jul 2025 01:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 932F16B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:03:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D2E580216
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:03:52 +0000 (UTC)
X-FDA: 83690708304.30.F44944B
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CEE0C0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:03:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Gyvt522G;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.107.244.79 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753160629; a=rsa-sha256;
	cv=pass;
	b=T8NHt8mUlIuXTZ6L2QPb8WxkLv5Uzze4zzuXcipKGflSuamAEAssuRplxuJplFkgeFuaTp
	QTchiTs1sJEW1FrlNwMaP/QwlsilWOpdKARVwxdHjjbjFdq8h7fO8bXYRnrNixKpZp/3Kp
	EgVVUOV18bbo36mOHYL9Nj9A8i+/0P0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Gyvt522G;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.107.244.79 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753160629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpziEwX72ofLhYwd8I8BEgyS8aRVIk6TgbweiHUswVU=;
	b=VdilASgTC/Wi8N0qYPSvfpSnQ/IepWdZBgsCAkKQqkHQ1RIN6pQT/alhqh++3oVEVh2ELt
	R2IAn6NrcYbJU4ax0CU+G7+htEV/+Tn3xEYu4dDDV4ZW7/efOsjk6dG4f9/1rOLs8D4dEM
	DnrYon+kS/F7S8HqJzxVTpBWL3qps00=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tuWW1NJS0w5sBeuFqpX5rgKC0hrmSUiP84Y1nkrNIONz8BLE+v2iqzA0TCtLCkvMcd0O42rM4lUP91L7m1rdJPvSnnX+L4DY8xI3ffFxa8CJO4H+DW4u0An68sBBYO829QBM9Z2sSGwuN1WpZBrK88B/OgibX7cdYp+J+ye0/vwtAzZSsMMO7DQNtQRT2upE7CJ1AZ9ttiY7BKbljiiGR82bgn0PAIiVTk0UCd+NJ1dSjKt/Bb3sIVl3hRhZtq71vXz5dB3lbSpI5jHzslYsdOwNUuGkcFBvjO/PH5X0qQJr5o0zvrSUvoj3Tqid4I1OTVAAVm4c8lVIsTLQlE/0gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpziEwX72ofLhYwd8I8BEgyS8aRVIk6TgbweiHUswVU=;
 b=YPFaR0NGbD4JTD6iV2GodjVy2VAGlu1jyxJOYA76Wi7pbJM6BBWcDTt431wHRSyskPuU2BL2434+8/vJ/16veUu7Oi0Bu+NrcnBsn/U7wiCBpLUAroNL3Mmt8cl+khBmKUJFLXLHFQAtsDMbvIVzBF07j96tPWgfsPOh+24G/Rq5lygwTyK+R+WgcVqht0SL4ItfJ6MphlVNvWNvN4UxL4dxjKUPIZJOxphuq/5N48BoR7udERnwzGVfQ5vT3qPEw/l0sDl5XbmowM+2YGfYFPO1xdP6hFJ4QEzrdSF9Ed4l/bKcY5ru9vP+XO4zbQmq+QIkBGFT17cUZzVmnC+NGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpziEwX72ofLhYwd8I8BEgyS8aRVIk6TgbweiHUswVU=;
 b=Gyvt522Gv6J2BcgvvW/IJhwtmhZyfdwND/2/Z/gplnlvi+d1dMSZ1pO4/CxC6RNi4jrWp6p0PFNiwpAlq+mROjmDlYc3yBkVuxgnOaBoEIpfKZ9wy+unaDz41uDZ9iePaN9Vh31fE7ZR6iEalLr7hrjDNXbl+pqTFUkEAmdO+SM=
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa) by PH0PR12MB5630.namprd12.prod.outlook.com
 (2603:10b6:510:146::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 05:03:46 +0000
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf]) by SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf%8]) with mapi id 15.20.8722.031; Tue, 22 Jul 2025
 05:03:45 +0000
Message-ID: <696256a9-8acd-4036-9a97-b0aae6411d5c@amd.com>
Date: Tue, 22 Jul 2025 10:33:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 5/7] KVM: guest_memfd: Add slab-allocated inode cache
To: Vlastimil Babka <vbabka@suse.cz>, seanjc@google.com, david@redhat.com,
 willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
 pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk
Cc: ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, tabba@google.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, rppt@kernel.org, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 kent.overstreet@linux.dev, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <20250713174339.13981-8-shivankg@amd.com>
 <78f3032d-dfa4-4907-be42-6a7e8a34371e@suse.cz>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <78f3032d-dfa4-4907-be42-6a7e8a34371e@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::15) To SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPFF6E64BC2C:EE_|PH0PR12MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd604dc-81e5-40be-4424-08ddc8dd21f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWRvSHA0YWJYbTBybElqVGdjQ0JmVTZRdUlyVy92WXdUSStjYW50RHVJL1dh?=
 =?utf-8?B?NVZOYnRJRlBhZ2dRYkRxcDI2dEJPTTIzY09mWStVVmJDdGtxdkdpSENZRFFV?=
 =?utf-8?B?Q2FjMVpCTVk1cUZ4czViakZSdllGYXlrVzNmc2ErVy9OVTMyTklkS3Q5Ykpy?=
 =?utf-8?B?MDFNNFdlYkJVbno2ZHYwblR4bjZPWXVqS3AvcHVMeUJIZkE1OFBqYXNYRXpK?=
 =?utf-8?B?YWhnMzA1dzZibG0xRUZxT0Zwb3M5djc1SS9NRSt1clhCNXVKbi9rK2pJNU53?=
 =?utf-8?B?QUhlWVNlaFU2MXo5RmtjdnZLWnBFSXhKNzc1RXg0UW1lNDVuYktzNEt1QXJV?=
 =?utf-8?B?b0RnRUI0M1ROSWJ0dEtocE1IeGVFOE9XNzBhdy9ueHZialFwaTg2SzRqQVZS?=
 =?utf-8?B?emFoaWcvMU5Xeko5a2tMdUVIS0lWK1RMdS9DL3kzMjg5QnQ0emlsdC9VOUtF?=
 =?utf-8?B?RUFCbGVOSzNrNW44cHJBZzRmVU5TTVNaZmFyZldwZWpVUlBseTBWTzU2WjBF?=
 =?utf-8?B?aVBzSkNGYzhneU9yek8zVVl6eldSNEpMNyt1NzZyS3ZOUmlKUUs0OHNWNUZs?=
 =?utf-8?B?N0tpNkd4aXIwd0x4Rk5EcHZ2dVRxUlYrTDNaUkhOWTJrckQxdk90RWc2aFdO?=
 =?utf-8?B?UDJCcDhVdlRBTjRZSDBUNUh2SGh2cGZZc0FnTENkNUpQeTUzSFlXWnJLM3Zk?=
 =?utf-8?B?czBQY3JiL3M1OU44SG84WnphSVVlRFVzQ2xSTG5FUmpUTFhQc0thcjlmQyt5?=
 =?utf-8?B?d2xERE9RSXR4T0hvcGFCVW01a282REVYTW8yWE1FNjBRdWVQWW9UWHF3RHU2?=
 =?utf-8?B?a05xZDFiNDU4RiszZkprVmdHNVBnTFBmNnZtdFdBZE5iMFBDWjJiNTZMQnBW?=
 =?utf-8?B?Skp4UEVXNHVqQklHQWE0ODB6WmlEb0FqSTV4TXNkRjRPcWpHQmFxMEZGOUIv?=
 =?utf-8?B?NlJ6ZDNmcEtkTGRHZEdjbEE2czduamtIR29TdUgyazMvemxyNzRGTVU2eFly?=
 =?utf-8?B?a1BlaGVGRGgwNVNWdzdsSFJYcDZpcUZNZTFHN1NTVStUd05xbC9HRkk4ZnRK?=
 =?utf-8?B?aVY0SXBpem94WGxTNEhzeW0rMVh3ZEs4ZUV3QVZqWGxMcnhMUjN1YmN1Tk43?=
 =?utf-8?B?OUUxbXc3d2V6T3lobE1UamZaTjBMWm5melUvTUI0K0dzNGI4RElmVmxEdGRl?=
 =?utf-8?B?VnZVbUIyK2V5TDMraEZGQmpOS3lnSW40Rng5dlpDWUJSUURIQ2NBekxDL21h?=
 =?utf-8?B?OXZIc0V0VGwwcEk1dEIxZ3owK2ZDNHBDd1JGN0dodlVyTjNldHozSk44N2ky?=
 =?utf-8?B?SHovckoya0NCUkR3TVV1aEplWkxkbDYwdHFQT2h6R2VscEJWbVJEYThBek44?=
 =?utf-8?B?MlNyMUJmZURvcWV0Y1hHWWJoY1ZQalArclJiM2FiZ25nRXlOQTVhZ0lyWVlH?=
 =?utf-8?B?endEcTRPRWtSWlVXWW9uM3BQZjVjdnNzR3l3UkNNMVJRTGlmVjBLSHU4K1JK?=
 =?utf-8?B?Z0VKQkJsMnRSa0R2Vlg1dVdTOUVIenZRdEdWdWg1M1Mrek9yV3Jvdnh0ZDBm?=
 =?utf-8?B?Qm9uR2FvVFhPTXhReWROb2d5M29jaVo5ZDRjZ2xKMkM5eVVkOGIrQ1I0UGtX?=
 =?utf-8?B?TE9KTm8vWVZYOGxwdTYzaUN2UmxqdWxydER3L0NCaU5ZUXpWSnZvUS9POGZW?=
 =?utf-8?B?U0ovM3hBOWhzQ05tRWpEV2tzMkpad0NjS0ZBNUM3ZUFjM0wvMWJnZ1h4U1Mz?=
 =?utf-8?B?OG9vMmYrZnNsYTVkWFpueTZaeGxoUDZKd1YxNWptNW10RllRRWpmbzA4dU9N?=
 =?utf-8?B?OElYMzNGZUJjLyttTEx2QXRnZkt3ekRLUm5PSHUza2s1Q09NZlQzc0N1M3Fx?=
 =?utf-8?B?MXNLQWY1R1JsRVhpMm8yQkdXQk02enN3UjJYNGNHVk1FVkZ6WUp3ZVdraTBj?=
 =?utf-8?Q?/FMmKHpmjrw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPFF6E64BC2C.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTd2bFRxSlh2RURrMzZybGJWUVFoQzlDdjhQSnFZTXVtM05hMEZWeVZrVDJJ?=
 =?utf-8?B?TlRIM2dSUUhaa1F6ZGFEWTVEaHFsVG1uWmZrZXZOTzRsRHdPbGZYRHdLVG9H?=
 =?utf-8?B?bkxYYVAzNDByVHRPT2dYUVk4QXhmMEtObTl3L05UT3NyeW9XbCtnZlZoMlh5?=
 =?utf-8?B?aVBXaS92TXB0bCtUUndTVkZmZktjU2l4WEIvWHdSWHY4SlhGcnpFRjMrcEh5?=
 =?utf-8?B?UWkrK1RGNnFXN3hjSGFDaU9qQk1JU0k5bVVmV2w5QVJ2ay9yMXhsbzgybGt5?=
 =?utf-8?B?YXpWMHJTMTNtREFqeWwyenV3RDhrc1pVSDhNWWhUM21KUXljTkRPeGFUNDZ1?=
 =?utf-8?B?SHNqQXpSeDhMVURONGtma1kxaWxrc3J1R2szQ2xrNVhDcERwMWZPbDVxVXFJ?=
 =?utf-8?B?SmJKckpRUFpNRFBXVC9nNTVmMHVId3FUaFRVWjY3QVZqVXJYcllDN3NnOGc1?=
 =?utf-8?B?ODR1d3MvcUhxSHhZN0N1YUxlTlArV0RGOXdkR3NVeCtKTmxEUzYzYVJqeWFR?=
 =?utf-8?B?ODBqQllrMWFyUWNiWTcvUTBLaXZ5cmFnenlnUW90YW9SSE9xSWpEeXg3RkNB?=
 =?utf-8?B?d0xRY0xsSGFLUzBQVk4wOE5KTWs2WW5GTGZGRFE4cEs2TFhFQ2NLcDExc0Nh?=
 =?utf-8?B?Y1o2WlVxV0NRbnZDbmVrY0EvSytxQ05KaTdINTZNT1A5ZzNNSnJBUG4xdGNw?=
 =?utf-8?B?cGVtZHh4YTNqOWdqekZwbHY0Zm5qQ1ViVTBmT05jQUQraUtRb3VLOE9EWFpB?=
 =?utf-8?B?K0RDeWVlakhZN0kwVDFZakdsMU1kWTY2ckZIMjFtMy8wMjM0dnVLNHQ0QmtF?=
 =?utf-8?B?UlAzNlVKbFJZZUVKS2I5eHhVU2xzT0M2OFFMVjVzd1ludFVaODE3eTRkR1FS?=
 =?utf-8?B?ZUp3R2JvWVlBSkFvdlFUbGtBcStIalo1S21vbG9yZ3lTUWgyRVRUY0hvSXgr?=
 =?utf-8?B?S2lCV1k4Q2xKampYSE5hRXN6ZEppL21XWUpLdGpJOGJxRXliUUxGSkJET2VG?=
 =?utf-8?B?Q09rQU5kYXlnQmtacUJlWDljMk9QRGEzYUYwUldVSWlGSFBaRUN5R1lDQVho?=
 =?utf-8?B?M3MyTlhEM1c0TWxEbDVNSVNXdFFndHRyOGdSb2htS0dLODJocFRhY24vWVY4?=
 =?utf-8?B?QUNqazlGUnlSYTFFRHBPZjJQbjJLTG1Vak94ck0zdGpZVjB6OXdGTi9XM0dw?=
 =?utf-8?B?V2E5OWN2VGpzL2hhR1dId2pFeUhyUEx5eUxKekgra0dBZlllSzduM3orbDNX?=
 =?utf-8?B?TkhwdU1CejBYcjJQTnJsRjE5dHdzdWtyQnlCOGF6bFNPQ3Y4ck90K3I4V3ox?=
 =?utf-8?B?WVNUYlZGRk9nTTNBbjZ3clV5TmZ6aU5RK3FoZXFXR3drZnBwTVVxeENGVG4r?=
 =?utf-8?B?dkNlYWdPSkxoLzc4UFBwdFZiYzJJQjdJbUVyaHFuTGxMbTZTZjVubm05eXgw?=
 =?utf-8?B?a000YU5UZWxqWjFrWE40MTk0RFNHalY4WUR2ZS9MWmNNZi9rOUdjWm5KYWRP?=
 =?utf-8?B?a2NLOFFaai82dXJUd0svc3IzdkFDdVgyTDFBOHdUYkh1dXZ3bXlnNkEzN3o4?=
 =?utf-8?B?OWNHc01nUE5vTGdGcXhFTkdBUE1zSVkyekxCQnZlazZiN0ZxUVlkMFVrQ3Ix?=
 =?utf-8?B?VjgyekJiVnRHM3dRLzlHbmVXbVFIczhhY2F2OTVSaGRWQTNrd0pXdmU0ZEJt?=
 =?utf-8?B?OTE1UVZDejh1NDVSSzJYUXZmYkpIUHpHSGJITERabC9Obk90Rk5Fa1JCcmRF?=
 =?utf-8?B?QW02Z1AvZENwaTdaNkgzM1ZyRTBzOVJHOEZmS0NoSnZIUUpCdHZSamJ1SVRQ?=
 =?utf-8?B?c29vQ241dHd1VkhvdUlwWVluZVJLekpzWC9kbGplbm15Y2JaZUFFTnhxSTBP?=
 =?utf-8?B?UkpEWkJxbTNvUjlhcG5HWUQ1djNHR0ZYVzNXdVQ1M1A2YkNiRGlWb0lwVVBS?=
 =?utf-8?B?eCt1bGVGLzl1R1RMVzEzM3o1TU1IZlJTdUEwOW9UZytXLzY1V1R2elRVUG53?=
 =?utf-8?B?M01XV1Bnc3d0M3VZdkJyNnFrQ1loUjlUajQ4Zk53VmZSMzgwRms4dzNES2F1?=
 =?utf-8?B?OVZYU1BBRStrZW5LV3hFM0FiSmRUSmw4OHhtMjR6V2Z2UHQydmhFRExCK0RY?=
 =?utf-8?Q?Ei9hT/JX7LSuW5gELMFmbZ43O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd604dc-81e5-40be-4424-08ddc8dd21f4
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:03:45.0011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L72FraOX+G6+UJbbjh/X0VRU+LqmGHa7KYgLfDjBa+gtFZrawVg0xLeXcL7MUkbAu06AOtAvWOJatf/6Cw3tLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5630
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3CEE0C0006
X-Stat-Signature: s6gi6tr47gyunyhw4x7shbgxbhrwy5xk
X-Rspam-User: 
X-HE-Tag: 1753160628-956992
X-HE-Meta: U2FsdGVkX188agrN0JYPeqkwd/cLJtsOsFV+cz/wnSA6CkPndVLu2vjCS9XbPTpDYSfmfkuN3ue/wSvXBtf8sE/8Q8hJIsePTETcT0nu6vSoIg3ThwkNEo0MERF0cDJVo2hjOdYNCrdWUMhItVQndGgOUd3V5vsEsa1MyhTL2y1arXxyaj3kvRqpE/cvmJE+/+DXFf8pb2kh/53ckuKvJNzyPIXrI+bX+6RGvJxyuy1bUpbJXXDXYmFBPYZ2dSmdUoIQsEAVc9x7+wJDsUUa0XcoL7lRGL4SbXQ6mxe98Qwxgp1xsYEYqcR4Ixcc/rJoa2xjMZp8MIqHr+ZHM/joXofvQSIrzOC57sCI2M3kVu+RLkxUk1yQwaNA3P66fF8S3FNIy3gd2W6qqCnMLGkN+Lgaa/c4BYrj4HGYLeBiMnm96C/T8+/UHoowBS9/Lghgogv1oK+u1tCERZViZ2EBG19mVBiuvTgZhmlG4WbDxPWk1Moiq0jIeEVYfM3lgH/3XMmWD6R1zrdGdqH6K9/jnKT4PrBAaY8il0TER+ai+12XDfPEYPZyeDlji7jTCoDDaqe/l/+vVbWBV+fQ5vhAOnDnZ3Zohj5B2bNeNE3/vabcDDCvucr5XTGgpb/fQSAY5vaKTOyqPg67ioGaa0JjuRfSqoX3TfpgcliHjIyaTfK3HvjL9xkrWExdyc22JWpRQckxXyvdjbrtezNNnCPsSDJCgeLE1M3NW5j0xaRzJmzQD16wbEJEmjz5Wq1JaN3PA6A7u7TPpMMFsevojUSVkyQocApq07vzqzjhZ38k7h7OnPRSwpdS9z4WzVw3Lv+aXnXOgN3hkU6sTtS3s41K3kN2A5wjUH8D460oqE41bP38Sdu0KUyjyErYpmYvI9/UWRVoNlvUCREU2WXSwgIAbX5sucfDvJ7Ux2SPQZDaTgn9iEqKUPVLqUNSD3di5gColIsVcozqPTXK8UNp9/j
 YZABbrxd
 PcfffWEBV9YGT1zkZcTm7WwefP9iQOvmODngq8nS/Yg6wYhEMhOSJuLGkixeZ206aZcPg68NYNHyA+wPQcf6dma2hWDRP0koCOeGo7KDkYyotgkEQ4zYoFTtDfxaLN5VfatAJKS9mKtBCz6ZpZbVjX/ZYCEEqRY3PpcwlGSmz7tplwlu//PNDZkJi8uzhqifS7cpXdCV3euWFrkvl8fHQQALwIBRU+WXJwT4yLuvwiBtl2sLl7qVjNCE16xhlDzZipFKcMdUuLJdBBXMQuGLnR/AfZ//58zmzPMEDbi49R6OP35kExXu7W0LitY6M3VjMGe7ZXhfV/ss9QrVZdpWUwXZ5BDW0ZCvfPyVorRJETdicG8vD5SdnEyMM3mmjq0A3H9hUnhxtJwEcedVIVCihydW4YQpL+o7YYx38vpOtZ/8uzUBaKvgRqX3l3Tj5CEc61GiYNoAHmzKkGRbmef9f5n+XntABo0e0IYFcTTkYEnJBZ6NsNa8SNb3PYOSBwDlpjiaXn+JFAsPULzpWH6VGrzJjWcgiYP49hEiNE6VEIo+bHASz51kS6RWOeWMGjEeZrrBJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/21/2025 5:14 PM, Vlastimil Babka wrote:
>> +	kvm_gmem_inode_cachep = kmem_cache_create("kvm_gmem_inode_cache",
>> +						  sizeof(struct kvm_gmem_inode_info),
>> +						  0, SLAB_ACCOUNT,
>> +						  kvm_gmem_init_inode);
> Since this is new code, please use the new variant of kmem_cache_create()
> that takes the args parameter.

Thank you for the review and suggestion.
I'll update this in the next version.



