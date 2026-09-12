Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E0CC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 22:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3FE6B00C0; Sat, 12 Sep 2026 18:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E671D6B00D1; Sat, 12 Sep 2026 18:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53F56B00D2; Sat, 12 Sep 2026 18:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A71226B00C0
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 18:31:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3A20120595
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:31:13 +0000 (UTC)
X-FDA: 85206557226.09.8C89084
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C154180004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:31:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DbLv3GMc;
	spf=pass (imf16.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.62 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789252271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHEjjqc8wgzXRK5/Xi5pns/Gr7ESKUCrsNtBKl2anBw=;
	b=viE/Y8ntxY8DhCweIxEJNNffp7MEm71Pd/DcnB9NkuuIC+ac93LZwpiKmcAEQ064SMmfbK
	06sSD3ve6KEoFZ7rABnkN0OX4mHfTdtYssPOqDOhiRcZiCdFky/NxwGUJgqOmOz8Ga8ctF
	xzW26Sk0YspgXxKPu5Eh1pLK3TbnQcI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789252271;
	b=MUjmwrZRIgQ8KlGfyO6stGLoa5Z1NQOBI3wE/sJlDybN9fUmoLa3+4QzQFcZqlG2tK3/cf
	eL4xOvTJzL95+/x7xHqINs7YmAm4BGW9it6Dtyzeof+fXhXyAYqmweRxp3mb76Gi12ipzm
	HBTJh5kGue2ooZqHRw1l8c1GSiFOpIQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DbLv3GMc;
	spf=pass (imf16.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.62 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D75EtOLXzy7PZcAFFQ+QWEJI6qYABNyXKtalXrCm0hHiPt42hMr0YdC+t6/B043VPE+QWSY7g5AC8EBEZSsc9C35lnq5EbYJml9RKHQtNrdlsoOhnfCiqZ04IRZL/mD7uXcM91iKzacnLYpn12n1hTOOhJiscg7KNuXSRAGGHQ1qehSJolgwT2zb+tvyY/Sj547ZrRdO29gR2WmIpafaSLUyUAE6OZy1ejCs0zQ7/ygumwmnDqL7af5S03NG2gWDHRf3PV4/USztFmlHxvqowUGuQf8pFzTrpWQFnSBVlG5vnLUmhFwAsoEcgnMH5Dq8CtZtWisd/JOU0sEsVh+5oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHEjjqc8wgzXRK5/Xi5pns/Gr7ESKUCrsNtBKl2anBw=;
 b=eUbmjHdiDb0MtKgux5TK/S+LX2QI1f8RZ8f3ZEqziFiCRoNzoBam0Rbs42cynIR/lgn7MRR5NhTn1LNyil0IfML91C3OXiFRNVwIkAvHMkYUiGJoOUAxUWxmuwVZQLKlxOAud/v3/3IJ8DgX5eekzSKXTExnGqMxqHt7YS3JG0f07g9ipRL7hQftl+OfcWrGjHSU/YwWs6pC6z9DBNDD9WyAPqmEvnD2LRJ4G+eb8yIxyHzmslZMEXnrRpWJuLbt/OriRbKvXbmpJHemfRP7XWZRA44MxcjNxp/XBjw6oRYXQR/RWgmjXCxQ+0HHduyOBUgPA3zet7HfDutizanJgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHEjjqc8wgzXRK5/Xi5pns/Gr7ESKUCrsNtBKl2anBw=;
 b=DbLv3GMc/nfU/lMG2zrG/sLj7ClxwTKJf1hdD5Lz21gZ+IqathWHS6+Z5v1NJw2ZcnIAho6OHtfA1FfGfLW7B8XCPAYttK+yoRDagfGCTAO2BaaG3tghyPM7khoYX2pOte5F1d2w7EMZXpQTc1KH2bfJdLniSjgQ0RaxhuvW1GaGG5mZXrFiGKfzlaeX90wMKhkhWQc9Yv/q923kv+ElMbWRaKt9AOB+VYjB5qBqL6VC8Xacg/m1vL8fZhBmv6L4j0MQXEo2aIrbv4kW1/cPOQ+FhxmUvz+KegcWjkju5u+LM/xGGVZkKoeW+zjX4AZiey/v6jgOFThM2Rkv2vfB5Q==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by DS2PR12MB413088.namprd12.prod.outlook.com (2603:10b6:8:400::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Sat, 12 Sep
 2026 22:31:06 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 22:31:06 +0000
Date: Sat, 12 Sep 2026 18:31:03 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <yury.norov@gmail.com>, Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Chris Li <sparse@chrisli.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 1/3] compiler.h: add ASSERT_STATIC_STORAGE()
Message-ID: <aqXSkthkUVJNu2FD@yury>
References: <20260911221444.1523311-1-ynorov@nvidia.com>
 <20260911221444.1523311-2-ynorov@nvidia.com>
 <20260911225749.8727d23eb76b93141f08e574@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260911225749.8727d23eb76b93141f08e574@linux-foundation.org>
X-ClientProxiedBy: SJ0PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::12) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|DS2PR12MB413088:EE_
X-MS-Office365-Filtering-Correlation-Id: 62acbefe-5c72-4241-698b-08df111d892e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|6133799003|10067099003|4143699003|22082099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	fG0cwBWrHGTO6myXt8bFnL5wmW8Fq+aPvHWAuUEaQIPbeQf2k0/ZG09yvo4d2kmYnvUDxPkwbEcKqrT1QrKfPRTivtVH4KuR5sRnLIBvGbqhCvMBbwxKkAP/Q7s0wc69y71C4rn9dST4qkqjHYHWRU99bd5aikGraC+FtOsY/+VJLzFedGGWu1K+pDLJWfhjV8JR8GaBroaX+8Wgt/K6cLchpDyFEujI2gE0yulZYey5d+S+XEH1V+66ydmWuh/jthm0EipHt7prZwnLTBC+Usn4iMtkKluo6BC5ZDdgI8591ONIUr+tyicRhyFgUn6/7+Q4tCaLzGWNka5kFIk2ihQymGvENHIUstXoVrUW/7y2BZYpP9JbXf7zfv1gryt9nc0lGYT1lkjzE3zqJbI2UYqUrF8xiy0mC84WwA/eNdQyaN2JZHgLv13+SrPzUjV9jPX4tqmGh9vlW8X15rFU1Gc1Pbwuyos55sJ9PyzBXSBb63TnOxKhUR6Y+wuea17JzOWK4yjUIgDwmArQRc3qbYbVxK6SM5NjklddP9FKnvK/BUzsMNSgsl1kT2SvX5MBw46TTYlY3XRZgE6tMpEY2AhGhjoWfqezW2tR4a5NgaD4vINc72YdyaVG5yCpHzm0FQ5PqwrjA3KYeyumrWx/1+BorrvjAN0swB7Ym0rjc48=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(6133799003)(10067099003)(4143699003)(22082099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUpROVVYcDVSS0tTTTV2UTNGK0d0dmpMbWJOd1VodkdDV29odUhsR1B5dDFD?=
 =?utf-8?B?TDRGeUZNcmt0N2xhaVNaVFZjL2VSZHp5dm54T09CMGxaaExERnlBK0VxY1lp?=
 =?utf-8?B?K0R0dERQaExJMlJQOXVyMGJNay9mUjk0WUMxTWU1SlVnSW95emc0ZzF4KzR0?=
 =?utf-8?B?b0JBZUtwOWRXMWNWM1ZUSHdaTkM3QXpMamdpL3UwS3VyV1ducmlWa0xTU1gv?=
 =?utf-8?B?M3BqRTVhQzhQWUV1SGRscjFnOWVDN1RqeHRzR2RhZUxDaW5JTVk0Z0U5NHBI?=
 =?utf-8?B?aDNvUytGRTBNcHlSU215USt2VEZ4SDdlbURrVm5SM2FBZ0F0V2xLRzZSMU1i?=
 =?utf-8?B?WWdxYWNUcTBIdGRlcTJESlpuSXNnalRFTmVlZTkwcEt5SjdkR0ZZMDg5bGRK?=
 =?utf-8?B?aU04RUdaZUh3Y1hIRzFNcVZROW8yTzYzNXUyaEFOY0hjRno0K0hjak10MmF5?=
 =?utf-8?B?S2E3VEwvZE0xZ3B1cktyVFByS1cwT2QwSE9idG9zdVZycWU3MXZwUkQyQkpx?=
 =?utf-8?B?eXdxeXBsM0FIUWtjazAxRTROemoxOWRWSWdabGRCWWo1ZnFTTGY3ck5hNStN?=
 =?utf-8?B?bDZRK2hQWVBmWEtRZUoySE4yN29xelVpV0pHNzV3dTlzOHJ0alIwRHBlUFJz?=
 =?utf-8?B?cG5TRzVJeUxwV0creWFOR0ZzdTl0aFFncy9Ya0psQ3FmL2gvU3ZMRmhqb2Y0?=
 =?utf-8?B?aWR3TzZnclhZUDVucGgzbnFISnBWMzE3Zm53ankzUGpxMFJJeUZ1SldzMjJz?=
 =?utf-8?B?bjdkMko2ajkyNlc5Q0pLY2hpVG4rcDRyT1lNWnhPY3YwREUvMVp0c0QwWVh4?=
 =?utf-8?B?OEJmYTB6VUk3Q3N4Ny9tNFJhUFFwQUEzcGFIQURHb1huZDdWellxcVd4Z0Zn?=
 =?utf-8?B?SkppdFBobmlNRmlVNXRZcHZWVTZjSVU1YzN1YXYvQzMrODYrSlBJTDhHQzdF?=
 =?utf-8?B?SXZQT3FKVU1ydDlEcERyQmlTWWdkQTdUY1QvQjFRdGUySE41Y3d3YVNzZWV5?=
 =?utf-8?B?WnVxUk10QlFUNzc2SThlb0dObzVzK0owS3JxbDJrQnZhVDNZUlV3M0s4ejdu?=
 =?utf-8?B?Q1FrQjBRMzhYTnZDK2M0c3N1bnowN3FZS0J6L09Od1cxZ2RkTUpRMmdoZzJE?=
 =?utf-8?B?Mmh0OEk1ZVBnUjdiTWxsZ0NMeHN4VndNaEdISWE4TWpZTkRSUFBINDNFak9R?=
 =?utf-8?B?M0ZyZ1ZDQTNGUm5GZXI0NmMySWMwdWc5WE91VHA1Tk1yVXUrMkY0QWpweWlv?=
 =?utf-8?B?ZldhSHR0UXVSbTJzT3VmYzZTYU5WSkltMXo2ZmhweXoxMnRtWjRLMVV1YVk0?=
 =?utf-8?B?MUVtYUg4L0lkb3FoY1BVUmxlYXVUSHFVdFQ3NTJnaHFmUTV2aGMwOW5kaXFq?=
 =?utf-8?B?MnJBK1Nzck1SYnRlVnVsWThBSzJFUXpPdFlkcGpCM1RNVVhCcldIS3lTcmlp?=
 =?utf-8?B?b1FWYkNreUFKSVJ5MllFTkp3czE5bGZsajRJZUphbFlxdFJ3bW1FYzlDY2g1?=
 =?utf-8?B?am5ET3pEdjdYVXNiV0cvUGJIMzZCZmlPYTc3ZjhuUDlhWEo4OUt0S2hvK1RD?=
 =?utf-8?B?SWlkWW9WSXM1c0FmS0hJS0FpU2k1MnBmcFI1L2J2QVgyZnNpN3FvU3haaFJ4?=
 =?utf-8?B?MVdRSFp1MWIvSGNaQit5OEthR0VLaWNYdkRFYnNSMnBocWgrUFhUQzZLZ2x3?=
 =?utf-8?B?T1VFeUthRG1iNUlQeFRvQ1gvWFk5aVQ5TmdFRkhVWlFQd1djRDhPS0VZTGps?=
 =?utf-8?B?S2RaT3FjakYranVWZ0lOT0pBQ0VtT0lYUjlESjJNcFVialRMM1grenBMM2U1?=
 =?utf-8?B?dTJIV0Z4UzFyUnA0bGorei9uM0kvRlNYVUlwOURyQlVlOHVFQk9GSEVJb3ho?=
 =?utf-8?B?T0w5TGE2QzA1ZG9Kb0hKckthWndkWG0wQTRmellNeC9Na00yYjdua0paUHZQ?=
 =?utf-8?B?WTduZ2xrWjNzM3BzN2NjcVYxM1JoWDYwaEdHSTExSmNMQnR5S0xYbFpDNnlt?=
 =?utf-8?B?WS9YTzFlZVc5Nk83UkhTOUJveHBjMU9ORTZvbmxEbG1lLzlqUCs0dFh1b002?=
 =?utf-8?B?R1ZqanhNN0pkaDhoVWNNUlBzejJLeGt4RXBlV2FiLytibkVhMlRuekFOTEsr?=
 =?utf-8?B?TGxqRDJiMUZYckRiMWZMRGYwTWtHR2RpKytzUDg5Ykhqd1pEZ0RJU3RqRmc5?=
 =?utf-8?B?ejR1dUxHM0NxY0s2OVROS09jTXFyRDFJanE4ano0dmRteUFEcTJUNGpUdHFM?=
 =?utf-8?B?NE5OWVJkbm9kU1ZQd1dJRjZ2M0VpcU1WUmwvUEVOUUdLaytGY3ZTanNvU0sx?=
 =?utf-8?B?U2lWSUR6cEViS1FkKysyL0MzenlWRHFwY1MzRnhMK25TSStKSFlWQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62acbefe-5c72-4241-698b-08df111d892e
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 22:31:06.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlQURjnOEj8mvWImdxWEEFklfIhSB6Zok1w4zrs9xw15UrvE5lz0QrZXBobFyPhcGrPnsU56e6gm5LuvwlJFdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB413088
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C154180004
X-Stat-Signature: 6qzf1kk3unkzh7om54po51budeag917a
X-Rspam-User: 
X-HE-Tag: 1789252270-474536
X-HE-Meta: U2FsdGVkX1/S5j2TlIZDUzl+hSF5EFkxk3V3+O73xnZLoFW6owvoff2kpuv4sYvhL9thyvYFCCXr/BLiQbhXJ4tAsu1N0KTcTo4YDS+xFb5Pfa3b9x5oLfsmkGmwlQKqbTtWmQgJxRNMQWZLXE5lTBvFa9H+19oHBRUDLxz8FlQwbrHM6gD6hgP1OTs7U3nJgUDk5glF4mndap+kThtsa0QnSEO2yA3hNHSH4PGB2CzPUmWB3RzT+afPWpiyKUVzvguRSBXv94nfzuSldijJXqMNb363XzgYL/yx90aMqrNMO0nDYhdexrFcT9wayCZvuett0gA/n2BHvOh8SEANEnzDDilRoNXZAjyKZNGoh0Xgk7EfZ3tOFJswC4yrQoMXWZGWp7jTOf7XkeNpJeg0spEM2zE8/3Gkjk9rOkcXlclUxUYpWpmnlL31ASWTc6b2L3T7V2FjLBCtxz5MojG4tsyqaNCJMpiILEL9cQsQ6A+jpyKUtv920aicPXsRL2dfAYodgfcqFD59+eX/KzU0fSUn3FRBFkR82VcRARZGoT3TAbAzRRnBIIlXro8Z83D5nFxTgJmHqCX3XuSE+bafL6iHYVYNsZotLor+obhYvLgH+TVU+KPGw9VO/S0IVi3AeZ55DFXPGjB+Ay59KEughZPvBSh9RYrTdumR2wN3TW+e8ZxVRjB4b/78rxVmZm6tohc/jEhWNDfCceXl83geTOXPHwY+qtJWDLOIbGIGC7Q5CUEnpD5p6oeeZAUAOpsm/vyghJ6DJEEkUng7LRWQkv+LohxKlL6fJroJhIwGlbS1YoUTj8m0ojzu+iqZXIL44TJRWi6ZOoAh+aVJ8kFRri4BhAWwK4uG1ZNCwsWh6jAktYM+RvJibWbJOXrbQiVws1auP6A6evHqOuougxvcCekdgOMRBtlYqrQjhM+YcvpDzS1+c3JozpJhuZCLzoDlsf0K7j69QXhjpc3hr86
 9cyQL2FV
 eF1btqBmyNfuYj6mKwwIozcCXHb5lqQpHxZstia2TPENfwQbKAkCQ//lEesq0+sFELo84YITi2BO3qHadttaxUq69XoBWxwTZX9vxQ9yoiQH87yUcZW9oKAqfxGXNUtvsTVP0O4BxctgzaqTypIrYt+rEdkiYL6i77+dzzXFdnQkATPhl69It6X2BXtPTjAwZeTKw8js8wMtrb6W1M668SNnFml7hNM2su1tcovgwpyZgkEO29BcaQH5WBM5iPLJGGcmpq3FyUo4OTUqL8EcBh1u04cdENifHncAV+TyQ7Gfwxdqvcdv4QwQSTQvob9vdivhN8HrSt5cdC2s5lk/t6a39RThEwP4iBR9nRqBnGx7SW/6TWoNoQkFZRbW6EGhSjtKA7Fb3CSMvvcuFOWKC7tz7S/04cBcmskRjO84IL7ihdJ067k5Q+GkKgvXo72KKfVmYXODYFE7vYHD8ioz2u6P9uTjzCAj0klVkKip0EUyyO9i2a4y/F92jww5SIangf5jO8adiWtopuwtFZqoHLW51IYnGWr0emfcUpruPaaALxbqNZaThdW69knVyvFOxrw735BWTvl+YrfJK+9g/ZM4oc8OwgtiRg7Xmx0zV9s++ei58wZbrmcBnG4KracAdIfVRimT09ckp55UwGFsTv2ePJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:57:49PM -0700, Andrew Morton wrote:
> On Fri, 11 Sep 2026 18:14:41 -0400 Yury Norov <yury.norov@gmail.com> wrote:
> 
> > Static lock initializers rely on a persistent object address when lockdep
> > assigns a lock-class key. Using such an initializer for an automatic local
> > object can compile successfully but disable lockdep on the first lock
> > acquisition.
> > 
> > Add ASSERT_STATIC_STORAGE() for declaration macros that require
> > static storage duration. It declares an unused static pointer initialized
> > with the object's address. An automatic local object's address is not a
> > valid static initializer, so the compiler rejects it.
> > 
> > Mirror the helper in tools/include/linux/compiler.h because the userspace
> > radix-tree tests include the kernel IDA and Maple Tree headers with the
> > tools compiler definitions.
> > 
> > For example:
> > 
> >   void example(void)
> >   {
> >           int object;
> >           ASSERT_STATIC_STORAGE(object);
> >   }
> > 
> > GCC reports:
> > 
> >   error: initializer element is not constant
> >     name##_storage_check = &(name)
> >                            ^
> >   note: in expansion of macro 'ASSERT_STATIC_STORAGE'
> >     ASSERT_STATIC_STORAGE(object);
> > 
> > File-scope objects and static local objects remain valid. The helper takes
> > an object identifier and must be used as a declaration after that object
> > has been declared.
> > 
> 
> Thanks, I'll queue it.
> 
> Sashiko wants the same treatment for a few other macros:
> 	https://sashiko.dev/#/patchset/20260911221444.1523311-1-ynorov@nvidia.com

Below is the list of candidates that my AI finds relevant:

 /* Primitive locks */
  DEFINE_RAW_SPINLOCK()
  DEFINE_SPINLOCK()                /* both non-RT and RT definitions */
  DEFINE_RWLOCK()                  /* both non-RT and RT definitions */
  DEFINE_MUTEX()                   /* both non-RT and RT definitions */
  DEFINE_RT_MUTEX()
  DECLARE_RWSEM()                  /* both non-RT and RT definitions */
  DEFINE_SEMAPHORE()
  DEFINE_SEQLOCK()

  /* Wait queues and completions — preserve _ONSTACK aliases */
  DECLARE_WAIT_QUEUE_HEAD()
  DECLARE_SWAIT_QUEUE_HEAD()
  DECLARE_COMPLETION()

  /* Containers */
  DEFINE_XARRAY_FLAGS()            /* covers DEFINE_XARRAY(),
                                   * DEFINE_XARRAY_ALLOC(),
                                   * DEFINE_XARRAY_ALLOC1() */
  DEFINE_IDA()                     /* already enforced */
  DEFINE_MTREE()                   /* already enforced */
  DEFINE_KLIST()

  /* Work and timers */
  DECLARE_WORK()
  DECLARE_DELAYED_WORK()
  DECLARE_DEFERRABLE_WORK()
  DEFINE_TIMER()
  DEFINE_KTHREAD_DELAYED_WORK()

  /* Other objects containing locks */
  DEFINE_RATELIMIT_STATE()
  ATOMIC_NOTIFIER_HEAD()
  BLOCKING_NOTIFIER_HEAD()
  DEFINE_RCU_SYNC()
  DEFINE_CTL_TABLE_POLL()
  DEFINE_BPF_STORAGE_CACHE()

  Lower-priority or configuration-dependent candidates:

  DEFINE_IDR()                    /* normal operations don't use embedded lock */
  RADIX_TREE()                    /* normal operations don't use embedded lock */

  __DEFINE_PERCPU_RWSEM()          /* covers DEFINE_PERCPU_RWSEM(),
                                   * DEFINE_STATIC_PERCPU_RWSEM() */

  __DEFINE_SRCU()                  /* Tree SRCU: covers all six wrappers */
  DEFINE_SRCU()                    /* Tiny SRCU: shared non-static declaration */

  _SRCU_NOTIFIER_HEAD()            /* covers SRCU_NOTIFIER_HEAD(),
                                   * SRCU_NOTIFIER_HEAD_STATIC() */

I planned to submit this hardening for them per the relevant subsystems
after at least landing the ASSERT_STATIC_STORAGE() in -next.

If you're OK to move that material through your tree all in one,
I can prepare it as a single series.

Thanks,
Yury

