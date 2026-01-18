Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AFAC98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C842F6B00C6; Sun, 18 Jan 2026 14:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C4C6B00C7; Sun, 18 Jan 2026 14:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13766B00C8; Sun, 18 Jan 2026 14:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4C46B00C6
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:42:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5693CBA0F9
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:42:54 +0000 (UTC)
X-FDA: 84346107468.05.8448B80
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010039.outbound.protection.outlook.com [52.101.46.39])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F80A4000A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:42:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gEX40Upf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768765371; a=rsa-sha256;
	cv=pass;
	b=C6UBfpbs2rW1/yG4zIGvzzDb9YQ+Pr0y/67LqK0wdVG4QCWPrbOtyX2eMOXzFYgCEo0oYf
	y6TEW3R6chsH2Khc8ZMDXIzV9ClaRkITveGxctk9Vyn+oPEofHIepbpY4Gv813zwbw4uaU
	3/hGyFNpVT5Hz7JFuDmfyrNg+T3WTrU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gEX40Upf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768765371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=288mlZPxIIU+U9kWZySw3+lxMxdqjfTllYONGkzxnLY=;
	b=cDEsdY1eYCaseVD1SF+uc2EXHCO5TTkE7GW/zJGaVK/H+OhXLiHgWqnbU/i4aoBxR+muG0
	3+wETAjb9rDmUFQ9EBjnHxs37W9Wx4wMfoK//ez9IA0O+6YMFGT9RQipUOpAs7qfYCRSE9
	KSyzKzxJO9h4rqy6GZc9FhlAt4YeGoM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=titqBbxGgWxrvHLx4QTc+OMM7y9cJ1v7hZbFyon1m7jqdaKglp9o+VhUnnSSZ/tlLVcvfkcHeq0waVqVczaCAKFKHDdTxaDHhmtBzn1HM+ISK6C4CqebCcO7TsNXKf5i16/9/2hKeh5d+bryX7xF10ZsUCvBJfwxE2a7iKTyvUME/Yc4U8GaDt+cDgoq8/3XtbwD9mz/RqvsU7hlz3GPn75L8rkjhPLYcTYF/kZ5zAB3zl08A/EAv6Va2AeG5xfJJ7nPnu9+dUzc09jo1fqM7tFWIRuU2/yxPziI8ZtV/gR9TwFZK8v+GN0U30hN0mZhlYVG6hJ14AlIrZRMCC0gvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=288mlZPxIIU+U9kWZySw3+lxMxdqjfTllYONGkzxnLY=;
 b=uPEFLc0IJ9HNWylDrEQcKFF+oSpaJYZARYTcchNTXDuZsUfSxSV0Nka+Nv7Rx+16R5EVXi8ldMJbZs6fOU/Bh8PRWLCdpK5g0Bs7VVUx0kFQA8Q0PaWY+VIK5usEbnq+112M00NLoR3v2cdmwWrjFi72kmAA3uwPWM+D4IwIH7UKeDb/n92IEcqwrxpEzfpnMqTPCBYvxXdbOtu0hRXN/GkuOuQxxfQS9G3oNxPczUIGxbSS9C8NwQ1R0mk471OHxLyA/YbXsUTWa+7AX+hpUc0nvb+ZyCQjv/MjRx8A9MZPttSD5LPS0IOejxpVsSxcgRJ6usbjuXmWfVV7m6qVcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=288mlZPxIIU+U9kWZySw3+lxMxdqjfTllYONGkzxnLY=;
 b=gEX40UpfChRERmOdogDIRcYUF99ttpUE0BbT8dpld8kxzMwj/JrBYnU1s4pinFzAeyxwZyYroHOUrEP9DmvyT5IKBEcZb8BzdSYDRlbWNVifdGhxEvMC0I+I7TE1qRGzW+ptZ+m8MRUnM9SLBfUlXI8YLsWygNeiSRRVvdQsJiw=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by DS7PR12MB6095.namprd12.prod.outlook.com (2603:10b6:8:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 19:42:47 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9520.010; Sun, 18 Jan 2026
 19:42:47 +0000
Message-ID: <3c8f62c4-fd86-47d3-958e-7fe1305ef0b5@amd.com>
Date: Mon, 19 Jan 2026 01:12:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to
 return void
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-10-shivankg@amd.com>
 <719f9bcd-0990-48e7-bf3b-929417a13db5@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <719f9bcd-0990-48e7-bf3b-929417a13db5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1P287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::34) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|DS7PR12MB6095:EE_
X-MS-Office365-Filtering-Correlation-Id: 086f5eca-3d7a-48c7-6629-08de56c9c1b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1VmNU1WRGUvK0dTWXNFUzFZTFVlMEo5MURnemc5MnlubDhWQkxrNk5RV1RT?=
 =?utf-8?B?eGxVZXFlZlJSQ3E1YXY3dHhpVnlzZnVBb3RMMDltOTB4MlVidm92QllIT3VY?=
 =?utf-8?B?UVgzQnlxWlFMZDBtUjhPc2YyU1cvWG5oOFN2b2k2WHc2VzV0ZmFDWVVlbDZ2?=
 =?utf-8?B?djZqa0FCbHdBUUp4d1RjU1V5SlRLZ2dVSHo1TEFwd0dZR3l1U3FzRndpN282?=
 =?utf-8?B?aTBwVDlnbmJGMzNIdGFuQU9vaXpvVUFzamp5dGNoNlRueFZTTVNHK212ckUy?=
 =?utf-8?B?clBQNUdjVXplMEZBUFRYWFVuTEZUQXhNeGdjZktGMnBMSmVhT1Z3R3lWVE9j?=
 =?utf-8?B?VCs4Yi9zbUZpY1pWSWorYUxvS3VUZmpEeTJJYk1OL0VxY0dnTjdCK3dlU3RM?=
 =?utf-8?B?bjRNWGtWTFFJRTZyNTB0QTV6ODh0YXRtTHFST0NVVFNsVHhrMkkxUmtmeWRw?=
 =?utf-8?B?NU8xTmIvV0E4YVhZWSsxRmo2UjlpNGZhRVNtWnlJcnVseEpkdXJGamRiM2My?=
 =?utf-8?B?bXF1L2hWSU83UWFqUkl2enNxbFlFRW5MMFd0OEV2NnJZRDE3NVFCcGFlWU9p?=
 =?utf-8?B?UnhhYWM1WHZiOTRDMTEzUjhWTTlta2FtQzlaYlhqT0dGY1ZPajAxNUhwVXpu?=
 =?utf-8?B?L3VwRktmUkpwNEJNMlZkUkw3a0JtZ2I5MDlpNE9NKzVWS2JlYVZXMTdwWGds?=
 =?utf-8?B?TTFiZ0R5Sm9rbzQxc1hnSWpRYjI4dE9kYW5ZNVJwdHhFQ1pVemtidlltc0w4?=
 =?utf-8?B?UzZDTkI5MTBUdmdoM2krbC82dTAzbi9qMXlsbTI3T1psTmVvT0NkWnRORjRB?=
 =?utf-8?B?K09oNWx3eDdrMGhML1VPUU1GRFB4UHZtaDNmVktjd1RjRkg0ekxOL1ZKN3Zu?=
 =?utf-8?B?MEoyM3U0MWtScDFxUnZPV3N6aFJ4RHhwYjNLQ0pzZFZ0ZnErbmNaUjI3Vjk0?=
 =?utf-8?B?eWJJdzF4Zy9NakFnSzVDMmI4cnBMNzkydHhGYWJhWGE0Q2gzby9GamVoVEkz?=
 =?utf-8?B?VkNmWFpJYkRGR1kyTXlKdUs5QzAwWGw5em1YdThoOGdiTlVncEVPZFZTMFpB?=
 =?utf-8?B?cy8xSHIvOUVtYUdCcWRJUSsxRXFKTGpDcHNDZlo3WTlmR055TWFPVU9mOGtM?=
 =?utf-8?B?eXE3TUovQkRmVWczN1BpRktEa3R3MVgwamx0alE0SWFkOEJOdy9rbFZ3OEVK?=
 =?utf-8?B?bGRkWnp2dkFWd3E4UGdaR1JCNFFmZW91d2ErbWRLVXF4bnBBWlg3NUdlR2x2?=
 =?utf-8?B?K2xCaUJOY0tNRHAwQ1lqWUkzRU81Znh2cCtUdG1RdzRUSW1wTzdWWkhKa2J3?=
 =?utf-8?B?WkdOQmZCUjBuclQ3djY4SERNVFExTWNoancwaHFhRkpaL29UbHAzbVZSS0Jy?=
 =?utf-8?B?VHdGMFNYRDIzV0krb0RPbW01eHBzVzEwUGRYS0lLQlRIOTh3WTdjRDhTdjVN?=
 =?utf-8?B?TWlNZnk0NVNPYnpPbkpLellsck55ZXZwT2ZFL3JocmZUZHgwM0poelNQcUlh?=
 =?utf-8?B?SFNxc3hEWGNpK2pSdWd4eUw5VnViaWtyb3kxa1VoSE9abitHVkxMZHhLNlYv?=
 =?utf-8?B?cmVQZWM3dzVNeFRQODZIbnhYSVRmZXZYUjdPVjM0RjNkOHhMKzkySmlNS3dn?=
 =?utf-8?B?R0JsVVRnUEg0MnRJVHNpaXpQNWVLN3BQV0I3RU9XdjkwZ29xR3R0d1k5VjFm?=
 =?utf-8?B?MXNlMkM5eXVnWVJ2Qys0K0ZBTm54UzcxVHlyRzBXVnFVdE1JV2YvY0xEUHNI?=
 =?utf-8?B?cnhoL0hUeVBjSTdCZEM1M1RmT1hQcUErS25oTDR6cEJyOTdvNkZ2Z0xaMUwv?=
 =?utf-8?B?elBJSjVuT05Pc2tySml2NmRGR1RCT2dsYVVVbzYxNklDYUZpaFNocHlXSC9q?=
 =?utf-8?B?SmV3dEd3MlMvR1FldVl3dnBiU2ZYejBqSUplM0FVVGJLQkozbjUzRjlld3hY?=
 =?utf-8?B?WU1FMUd4bkpTejliSTQxbFRFWlVYOGh3a0pxK2xodlorWkFXdlBjMEQ3SlYw?=
 =?utf-8?B?YzUydzJIWEU0RUYxRjZmZWF5R200a21pbFhQTXNYbVpZc2NxQjB0Z1AxajIz?=
 =?utf-8?B?bCs3YjRMVmxyYWNqU204RkxMaGcwY2dMK3dZWmdrenFpRi9INjZ6ZDQ2T3FW?=
 =?utf-8?Q?QC3bL3dEvcnRB3aiFFlvUU+8X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGlpdWdCa3QyQzBvcGhGNGFwN29wT3VkczdHWjlrYnp6Q3o1ZTZtUVRnbmY2?=
 =?utf-8?B?c3RNQlN3N2VNcjhjaU9vQWtTajVRclV1endNd05vK2h0Ym5SUHRmYzFjQ1FB?=
 =?utf-8?B?dTNxY2dmcUVDSnprcWVlZ0FXbTZwcVdVeDY4SmJXZHdNR2R4NG9hZllYVWtU?=
 =?utf-8?B?aXBqZTNQWkVzeVo1ZVB3amxTZStSa29nTjJhdXo1OUgwdzhja2x2aTZJL1dL?=
 =?utf-8?B?a1dMRTk0aHpXcGdvS1E2YUpHaWprK1dvSnhlN2xTa1V1UE1BcFNRV1M0U29n?=
 =?utf-8?B?akE3UmNLQ0RlSmxnVXRhRExrRUNndmFWYzN6YUFsaDYwWWg3akFSdmlXVG9z?=
 =?utf-8?B?VDBCM1dvVFFMQXBqUHllaVJkZ0s0QVgvT2tQS1JHWm9hWjFCTlFvV1d0Ny9Q?=
 =?utf-8?B?VVdpMzdqSHVRMUdTTWJKQzVreG40YzZRTzNRRCt0ZkQwWld0T1VEY01QUDdi?=
 =?utf-8?B?VnkzZGJFK2MyY0xRcU54UGRJUmphNU5lYW1CTElSQTJrWTVMRWdGR1ZKeDg1?=
 =?utf-8?B?TDBZK1pIS3k1MmpuOHM0Sm42ZCtxVUdsYXdRN2MvRDIyL3BXVzEvTm1VWm4y?=
 =?utf-8?B?L3hqV01MVlJYdkNVZFBMMDFFU1JtZnNuOUJVM3ZFc3FDM0w0dnEzSVVXbU1x?=
 =?utf-8?B?MTdYdGg0S1BDNlhzZzZNdXBtSHVnMEQ4TXBHejJWTTZaSml5c2dIOHNFNzFY?=
 =?utf-8?B?L3pqcGcyREFSbkxYeUlhejRNZ3RoVjU5R3NENk1BUjVkM2djZjhZWDJBelNy?=
 =?utf-8?B?UTl5TDhTMDlPd2NmbUVIbm5OVmxZTTVEREUvUGVWRFpNb1M1a0I4UTZ3NUdt?=
 =?utf-8?B?UVBWcTBOa2ZtZy9qbk1DRGl5MU1mVWp2c0paRnRYVWg3VmZKY3hyYVJ4a2kr?=
 =?utf-8?B?eWhxVWlldEIrenRvTEc2U3hkU0xyQTVvKzF3bnRzTHAvTll3RklpUkdnWFhp?=
 =?utf-8?B?TEloY3ZCWUlEYitma3YxQ0Zpd2czWi9WbGt3c1UzUVJOWHhuMElaTXkyTC9r?=
 =?utf-8?B?eC9JdXBueXpZa2tWU1NGR1NpZ2FKMW9WLzg0cVBudEg3dXNiL21YQVFKNW9x?=
 =?utf-8?B?V3J6QktrVDk2dzMvNnpFb2JsRUtGQk9HUG0xMTYwajdIWitpMzJHM1pveXc3?=
 =?utf-8?B?V3cvOG5EbDNOS2tKWFBFV3FCbTBwZG84NWcyTXJHSE1rdms0VTQ0dWpKLzdn?=
 =?utf-8?B?ZTdjQ2lqRGVEUFZBVTVlaTRoWXU0VkxIemMvb1A0dGFJRDJOZDZraUdRZkVk?=
 =?utf-8?B?WnUvelo5WkEzRGxWT3FFL1JERlROdWI5blZpUXdQdWR2cTlIY1I4dk55R0x2?=
 =?utf-8?B?OVhKLytieUtudkx3eFBzdklnWGF6bEdtSStSY0k4MUN0cy80RDZ0QkVqd2dt?=
 =?utf-8?B?Q1JLTjJkT2NEVVhYQ3FPKzZGemk4cld3R3BLNTBQMFFDZDBPR1JBQVJpR1hn?=
 =?utf-8?B?dzF6T2NXNVVIQ1F2aHVCSU9rTm5CRit1NTU3TFdJZEFOY0h3M25PVmVoa3hy?=
 =?utf-8?B?cEEyY0QyTjFiZXBzY0p1VzBnWXJoQjF3akFzWGZCaEFGa2pqRnd4MGpFbW42?=
 =?utf-8?B?dlZER3RxejZSUk14NGJyL2FFWnRUbTlDaVEwNWoyeTd5V0FhSG0yMTQxV0dN?=
 =?utf-8?B?NlpyRGxWT3hwYnJyQWtjMmp5eHQrbjA2MlprTjJRdzdoZnJZM01ZMGljWWcr?=
 =?utf-8?B?WXcvMVAyc1c0Tlc2Rkd6dGJHckNmME5mR3lKc0tkRFdYRFlXcjBrMlk4dktm?=
 =?utf-8?B?bnpLY1MzK2NLQ1M3aE5HSnI1OW5SK1F2cnZUcW9tdG8wUkNvQW16enFKc2lo?=
 =?utf-8?B?WW9GYTJEcDlwTG1ucGZ3UjhkODJjZk10QnNrcXJ1ZmFSQllxSFJpZkJDNXpS?=
 =?utf-8?B?b1FiV3h3a2tGcDBWV3Y0cUhqNEhGWE1GQnJ4b0NkNWU4ZG5MWVBRaGxsTnB1?=
 =?utf-8?B?VFRjNTJIMk5nSy83UE4yT0tBWldRQUNoZU1FTWtNb01IaDFGVzdlMTd5ZXFj?=
 =?utf-8?B?aUkzcUVLNnpWLzk2T2VDY1RNZGQ4S2dSK2Vsejh1ajQ2cklwbUpIaU1BVnZu?=
 =?utf-8?B?dDhTR0FjdjRwRVo3eTEvWThXSjRhWit2UGZtKzBRMExSVUJETU4rcnlSR0pp?=
 =?utf-8?B?NlFlYnFpSkdVU0UwNkl2Vks3QU9ZSjRpTGhScnNMYmFpN25hWmFsVGp4cVFt?=
 =?utf-8?B?TUFwZGVDb1Jic2lGMFExY3hTWEZYL1NVNVdHaEM5Q01EOUxmTlZpcUNkWkEy?=
 =?utf-8?B?c2FXM1QwWVNHMTZSUHVEeTJpRk9wazUzdVFHd2VpaDBYNUdQWTJVSzkvM1cz?=
 =?utf-8?B?QXNzbTRnZS8xZ0dLWnh0Qms4Qm56azZkdDJkUmRuektIWE5SbGtyZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086f5eca-3d7a-48c7-6629-08de56c9c1b3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:42:47.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76fMarVhQIBRC5TMfhGjWY74jN2ycoobvrLPB+g18vVsE5DAOQr5/pRSbcHDUv7rVZGRN/fR49ElDEuwY1VV3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6095
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F80A4000A
X-Stat-Signature: x5z365jz966mtircgy61qjkkdi9rqnns
X-Rspam-User: 
X-HE-Tag: 1768765371-126291
X-HE-Meta: U2FsdGVkX18dXyBMZ3k/QR7+4VE4Y6IfvWibucSlscC42pshffWpeC1dun+zK8Q5mKC8yjSsEgUwgL2J6Lpv/zYGSwn/onNh6nCjoyjpP29TZWoo4MqR9P7tKum+I8bdXUu8XaoHNVaMlfEKzXxDk8z+lgngFKeALEbOtYxlUfJCCMuL9/xqaXhi9/nVkMlMeKelNHnbkhGKmBFFLXRilSrvKfTMndDFhRanR7M3/xrhONP04py7OeOkHMtTP3zYODVgLMHWOP1G1DVyraUNn+FrCcCQpCFotw9ew1tfhiVxpgRmWU5gMOb61QAS3y0GmxRMUjyVpT2XYQlwLPlc5XH/kXsk7wgq7MqJZjDVz51CdOWBP5YfnVms2abZsQ8iGFTt2v+oz3d+edArSVStbrTz/j6C/sPyuyzJ6c3WI5ErhUbtRgZJl/7gxSrlVFty0H9JN7su/it4i9Dq7dAx2Hpzyj7BNjhVJAfLXiNaUfYrh8AM7Lv84WrNfZGq12NvwQIp9mi4ACnC9R31fyMOGrAjjcSHBFhvG7UCQmZQZbg8BYBtrwRHEiWd5FfXwupbgDwyMIdEw63VMCldiOpXTHIR5xeC4iO7aXS8LprWE3nAKXYooQ8AtRZ1GpVbalKMB7BFJsOSi7PKuvDCkVi/iIHkPK2mWkbys4eIJ7kJS3IUFsJi5RLkFIuKpdSgo7e0KJimqJDqMYIU6a5f/Te/RJ1ta4FmEGQ8X4SUIsKv6nRm6htPGEbVYh1MxXy1tmZ19rWLA5tKwj9EilJisFW5jdutUKO0YnGTMbAJOw36aZmwxfFvJXJJAJHLL/Ogx7bTkssuGxv+OQWXDESJQCRXkXwYGUF8ue8X2fFnb+Wv86Q+2c6q/K2a01fied5WBMxvzsYUmlxbjUdRfpsy7ar6z0/3SoUCz845fyTyq9Eo8Zl6+oXPye9Ww1EUoDC8Mrz40336qFUd5RXyadDeR+k
 cV/A//DO
 4L0c/+P5znuK/YyhMyNJJqgyP3+DxK0QGTUAM5LsIX2+NKeRZA20h0DAPv0CIpm0Aw3wXoZK6SYGqfQ2R/NbuUSvYvusaT53DuTHoCZ8Vu1+Sg6sMnLetlUER8kxc2DuOYStgD6dt2aIBPILbDEXb79rbCwTsNOHXq0ExsswD/vaSWvBVNmjhmtiGoUBumvjWfFLio1/R7Ruk7q+RqhFlPS/uHhyajrETS+3dR92L6AJXT/2HdbERepRtIMOf+4c8eEar03QLl0sISO07ah3tR5U9Drr/uwraIV+VF41LdCUEwcKJxhfB2NDvOtgJe/F0HES/oOHXcbieIohdFn082uPPve5kkcGjIXjuygcwqPN2gydPSKhLQqHCq7cLQ2igNqGCyIQTX/RCbIEMGizCVgzG/B7mWb3fY/qZF9ddxL1/amKaNlncJmiezEYTrmW5rQbCV/YaP7O+PajNn+kesOW6lA5FO9bgq4lsFnGUa2fm4xyL3IgBR238s0B7qJWVbqqtanwTmYUetAVzSbY9mh0LfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/16/2026 5:18 AM, David Hildenbrand (Red Hat) wrote:
> On 12/24/25 12:13, Shivank Garg wrote:
>> The only external caller of collapse_pte_mapped_thp() is uprobe, which
>> ignores the return value. Change the external API to return void to
>> simplify the interface.
>>
>> Introduce try_collapse_pte_mapped_thp() for internal use that preserves
>> the return value. This prepares for future patch that will convert
>> the return type to use enum scan_result.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   include/linux/khugepaged.h |  9 ++++-----
>>   mm/khugepaged.c            | 40 ++++++++++++++++++++++----------------
>>   2 files changed, 27 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
>> index eb1946a70cff..37b992b22bba 100644
>> --- a/include/linux/khugepaged.h
>> +++ b/include/linux/khugepaged.h
>> @@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
>>                    vm_flags_t vm_flags);
>>   extern void khugepaged_min_free_kbytes_update(void);
>>   extern bool current_is_khugepaged(void);
>> -extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>> -                   bool install_pmd);
>> +extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>> +                    bool install_pmd);
> 
> 
> Sorry for late review.
> 
> We remove the "extern" whenever we touch functions.
> 
> Nit: two tab indent on second parameter line. Same applies for the other code you touch below (if you already adjust that line, just indent with two tabs).
> 
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 

Thank you for the review.
I've always been unsure about when to use two-tab indent versus aligning 
with the opening bracket. I'll follow the two-tab indent convention going 
forward.

I have incorporated these reviews in V3 here: 
https://lore.kernel.org/linux-mm/20260118192253.9263-4-shivankg@amd.com

Best Regards,
Shivank

