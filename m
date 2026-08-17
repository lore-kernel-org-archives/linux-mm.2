Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C35C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 18:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0076B0100; Mon, 17 Aug 2026 14:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6216B0108; Mon, 17 Aug 2026 14:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5907E6B0109; Mon, 17 Aug 2026 14:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35F936B0100
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:51:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CECDA1C19AE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:51:32 +0000 (UTC)
X-FDA: 85111654824.13.22A2E19
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id F3F3F20004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:51:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t99yOyGu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786992690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJi/r2v10jF5cr+SfLkVbGNufL9Q/V2OciweUyd43gk=;
	b=aEa2S9645ykByS98zcMPs+JHDZCi6s5Wlkr1cDY7/ftrooVS5oPYHTYjr15KvWhPd8FC/7
	Id2Upl/+0aivwS3KogtYoBbBVMXIQRjhz1DvxPyJc9buspK5OZU03gtTDph9WvlSpm7QWj
	RdmgB89JEyZv5CeUrYQwhQxy+3XP+oY=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t99yOyGu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786992690;
	b=D3IRaMpcvYxOLkXeKzPeHCLx6X9ONvOb0FuyaGhJmFwok8TyHoxUyn8bqJkQvL4OKWsNXG
	pmNlmejb5dj28RgsrwLhrcNwfooYpLN/LqoYOCVFu/Yjb2KzrxafSsiQCvjwUA7tuG5GKA
	zJ2T/vUwnMlkYNGrX0yBgpqfGZgHb0Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdfI8t/BtwRm6JKkA9x1LJB1EwURZja+U2N+KOez/4wSpgu0qHTlkYduLl222lGJ3GkUETluKAHwY5bEathjC1J7Eniy08ZtSkJoDq4O3YgO3q1rq6AvKDtkQQlRt+NwncLetyj/jG+DpvF5Tc9gTgfrf52is8BmI3uFIoCzmQ0ubYU0rbF1EEfLTaeDtmITN0vEv9NKbbHWF8kmtOZ5ahdD9rDTiLSCBzZT7VrmXEeQ9jqmA5F0zmQjJFxNQrAnjbkngF6YeKTwXRViN5w4J4ZzBy2E9fwjWxZCFfmGimoxiWI4YGNF821rnLU4bjIMijYDn3wjKShiKGV5thEtvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJi/r2v10jF5cr+SfLkVbGNufL9Q/V2OciweUyd43gk=;
 b=QudXWOgMcjBFg2R6zcuiZGmKBDLQRGwIZkx0fvJQB4QZE7zPc7IJZ6Xw9Mb0hE3GykVH1HK6gP99Liq2BtdB8mJnzin10muSwF/1l6+XvrbTgFuEGfSL1jnjEWoREygFR8H+PFCdgkNk1ZCpVPH6O9P9MLa2r4hX2YoPvQPmgpuVnvDNq4Sli2GQPW9KFdGqwLNBoS8HYQh7pjbtEdZgEHKZYgJDpJ+pk1Kp/cMRPmnMKWiRI3KweSOxG/nmJ53dg045iVR/Jb844djBjT7tF4fVOEqcSlLIl0tWN1PbntW1jfImQacaG74MGFzrXznP263/ZA7m3SNh5/IFlBcg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJi/r2v10jF5cr+SfLkVbGNufL9Q/V2OciweUyd43gk=;
 b=t99yOyGuOu/uoV99oxPaBsNVXjaI1jUy8Rjc98pE1doRdf9pkLW+qp0kDTzNruGegqpZKk2Jx5vCph4wyzdUKzn5FWKj1nwe2wrs9Ajii6IxMNJw8XZIAaf3ZRHfNAZd3BIAwBsdC1m626iv45/+jfqUAttPZXEf4caCW3EOIiFD8W2IxJtU6KMGu5Sm8HpsdW6d7B84IZ6ieHKHpzjMSnsChrQZqYDsTAnjew76H/n6rsBWFTDp696rLyX8lOotC3Ztm9Kq1f3xWmbQc4wUI5dmtXeVYqzUbYIWW6z4ZDvzux/d5YT4oeUeVCOwPVhvE4rWlpNbOXKjmRtftkLpWQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB7478.namprd12.prod.outlook.com (2603:10b6:806:24b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 18:51:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 18:51:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, linux-usb@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Date: Mon, 17 Aug 2026 14:51:22 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <92B3A471-F7BF-488F-94FA-6A011D33D31E@nvidia.com>
In-Reply-To: <2026081732-unaltered-regime-f91f@gregkh>
References: <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <2026081745-unshaken-retread-d744@gregkh>
 <1ED81A86-22F2-415A-8CC0-7E9B4A4446C2@nvidia.com>
 <2026081732-unaltered-regime-f91f@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:408:ff::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB7478:EE_
X-MS-Office365-Filtering-Correlation-Id: 19601078-fe0c-4048-1889-08defc908959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|6133799003|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SNYeCg2NpHtK7BknVn8r3rEJshE4+EwPQ4XXZk7cint2NqEMTOd4Ziaqk5NxmcoY9bIRxy3u3B2unJDyFTzxu2IklU/NqXgZteQVbtddOI4EQRRAW3Dgb1nSW1q4iLh/D+GFfFpMeJnGu2AyAYo6R+/zL5T8S0g23UVp5YWlKqj3RgYDmOXawFEWg9D7yZVpeXFgNwR+Ex7lnLydKDI2lgz7jyhfEWcVP36zAv7va+Ia948PoOt8oRWtNxisN1ZLm/8A6vqZgjWhWp2AZnzQxAStCDxbS/udBUeQEvL16T+3lflUyQVrxW2aRzzbBVsqXG88GqqEFVWPQNMsfI7HU5A4VTC/JRMu4uunyJN3RugVXiyMCJDPFMjGHMql4yLDIZjTak4sZT2Hy2vtw0RjFovoQePwD4kx4IYlEAwViqf+Vs900V+tk+aaNbX7QRAtVOySBZzvBiATcQwZA4wqFVmIOmTcQnc7zp18kk+WFit8K1w+ZS7bKsQpt3sMh3aN0hZwu+s5EQITjKt06qj5GWUm9Fo24xw9ZoswR1XfzyogBi33/Y9qq+6pmccO+EIzT2+ipKjh9ZcULk30x80Ni4ulwB31vg5PU1/60bvVYA4Yvk2eIK496gUv60zpuowzPg19bVv/zL0bxOBDHpDdy9yscQxs0mYc1CHUqipgH4U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(6133799003)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUY5L2lPWmJ2TzNBWDJoMENCcm9DV2d3RVh4SXdQR2s5b2xDeWxVd0ZhcUl3?=
 =?utf-8?B?ZlExWkRlbG4rcUpGa09kdXpycjkzMDFvbmJ4MUkzMjd6UU91NVNhOUhSMjJI?=
 =?utf-8?B?bWJFakRmVUJ5MjkrODk5QU14cTNOalBuMzhOQ2YxS1ZzdFpMYjgzY2F4RmZJ?=
 =?utf-8?B?cEVocGdjWjRZUzlRSnpQZ29JWHc0cFVrVmhRVGE0UnJzbEovU0lrQVZUamtl?=
 =?utf-8?B?NHJoM1AxNXRWV1NpTGNiZ283ZTNFZmg2SER6c3NUSDZnRHorRGhSMCtUY3BS?=
 =?utf-8?B?VnpnV3I2b3lVdFM1SU1RZml6Y0cyTXNnTFk5Y21KWFdEQUtrU3BnTGdicGpr?=
 =?utf-8?B?ZTN0N3h6MlVPQ3pCeHBPOEhCVHhPTERJS2d3SnpZSlZ5RGtUcXBhVUxLNkNi?=
 =?utf-8?B?NmgyNDl3Qjk1SmVNMTYvdDdkRXJvb2NRdXFCNWw1RWFRWVhCbGZWYU83bmV3?=
 =?utf-8?B?b2Zaclpkb0c0MStHY1AybjRHdzBaLzJ2Z3BLZ2hFMXJmNnBWN3YrcHJ5clVo?=
 =?utf-8?B?QncyVzR6dG9LMnN3WWtVaXdvS3BXdmtZdWJET1cvOE5NZndTbVR1RHhhTUI3?=
 =?utf-8?B?cDJsakdRTkhqUy9OaktvM1U3L3FVdVNGZm9QWmpkTi9PWkIvWWU5ZERSRC9q?=
 =?utf-8?B?MUNGc3g4OWxRN08zTzhYK3hENXBlaGlwUmcraGNFN1R4MEhkWWpIREI3bHgw?=
 =?utf-8?B?OUc2amduZS9UeGhweUE5eVY1RE80ZXRmOXFpR0NRZW1XOW1FRUpSN3hSMFdP?=
 =?utf-8?B?bXNmMjNGNldNRm96cGhWWXhFZXBtSUhnbUVBL2tjMzlLZmJrcnV0MUVud1RZ?=
 =?utf-8?B?UVVZTGZXSTZpTU8rMmVsSGRJc3kwWE5OdEgvb2lNdkd2RjRNa3VMdkNOWCtm?=
 =?utf-8?B?MGhTb1o5S3dtMGQ1YXZoNExoZFpNTVR5bnRnWlhaRnFyQlhSVWcxdVY0T2lI?=
 =?utf-8?B?TlJqVWEvcUI4QVJyeUlvcjZCNUFKdFlLMWZTbFVDMktOYk9mME9yTndyY1dH?=
 =?utf-8?B?RnZMczRpY0JkWUxkd0hGUzc1Q1hENzl3UUpGd2M0Mis4WmNIN1JmVHRoeUlv?=
 =?utf-8?B?QTBzSy9tbXpzQUszcmR5MnhtbE1qRzlqd1FhOFBXMU1mZ0JGaEwxU210R1Yw?=
 =?utf-8?B?NWozWW5NcXRQYWRDQlA1L3ZKY2xmYUFaTThvdzRRQTJSYVBCOFc5SFkwRlo4?=
 =?utf-8?B?Y1lHMjR5SDlpdEo2WWsybjJqY2RpbE5GN1lleGFaQkk1ekdkSnJoVjhXOWtJ?=
 =?utf-8?B?Z2sySVhtbzlxQkw2bERaRjZoNEI4QjduSEQ0ZzRqRmtOTFZmWjFUaGptSG03?=
 =?utf-8?B?U2hxRTBsWStDTTV2LzdMdk5IejBabXcyNktJUmIxcncyc2VKVHdpancycThD?=
 =?utf-8?B?cWF0UnZ1Z2V2YUJjZ05Rd2llUnJFWkNoN0NxYnpRcnhKcUVFcmVYRWYrTzBm?=
 =?utf-8?B?eUQ3cWZjcmdVZFNYSFk5aHRPcjkxKzNBeDlIb2VzSi9TREVrYmxCWHBMcXc3?=
 =?utf-8?B?cUFXa3RNVnhVSkpDY29tUTFIVUZYSGNCYzhETW9PQ0lNN3VOZHRrMTZUSFZE?=
 =?utf-8?B?ZEJiR1haR2hqV0QvdS9kRGxHNHNHSUIwMG42UzZtL0VLcU4xcHljdWFOb1hP?=
 =?utf-8?B?QkJtbW5sRU9WYU5Nd2F5TmloTDREZzd4ZWwyLzRYbVlmNmgxVjVKd3J3UzVU?=
 =?utf-8?B?ZGRNZlY2WkRmVTY3aEgyYVBOWC9QdWRHRkgrNW9mTWsrNEkxUWNzaWExVVYw?=
 =?utf-8?B?b1pRZ0MxZVdjenFEV2crRTJRNU5ZVDlucWxVdndJVmRnMnMxMFVVd2VkZXFY?=
 =?utf-8?B?SEJDcjhTR2JJUlk4Tnp5bDZBYTQrNmNhem9PMkdoam9yNlROK0JraGJnaVQw?=
 =?utf-8?B?c3JRaktPdFhnMzdJclc1amE2ait6Y0hhZGQ3WTcrZ1RIS3hFdzdjd21Hbmt3?=
 =?utf-8?B?YllobzNHQ2hHT3AxMWdaRzNKMDF3TWduakRMQVlXcmRsL3pxUnhKVXJ2clhI?=
 =?utf-8?B?VEkxUWptdmNzbGxzblhUL2NYOXE3NENSNmpZbXh1Z210MktwZG1lckxqVi9t?=
 =?utf-8?B?RmVPMnJLNEZ3Y3I4Y2xXeXdlQ3prSDcrcWpTR05FZ2ZuM3F2MDNOd3plSk9E?=
 =?utf-8?B?eDVKMWlvdlNHdXRZbzl3cGtTaFZFWE5rczgzZEVDRG56M1JFcG1INWlTSHIr?=
 =?utf-8?B?K2ZRMlJMUkJOdmFKVTEzajUrRWRDWE1kZmEwNjU4VHZLR3crRVlJdXVacVk4?=
 =?utf-8?B?RlZCcUhEajd6RFZGZFhVTzYwV1BSTXNXSFUyQ3BNUFpDVmtVVE5lOEV2QVBV?=
 =?utf-8?B?MCt2YmtkSTlkMmV3czhGc2VlZlVkRElWSnA1Q2N2aWc0amR3SW5kUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19601078-fe0c-4048-1889-08defc908959
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 18:51:24.4089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YS05ZLFOk9R9egwAoGzGDtCCeDx/BDAKlXyyp9KDX/IomwpUAslPTnLsQWbsqMe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7478
X-Rspam-User: 
X-Stat-Signature: 3e3zkyejfdtss6wsax6gue6fzkm5ahak
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3F3F20004
X-HE-Tag: 1786992689-689591
X-HE-Meta: U2FsdGVkX19VKiXivSgsj9jhzrF+QK2UVR8D5IXho3l18SUAKpcZU6Z9rG3B2qCVUBXXHVG7N9ztCGO9Ch6MXE5oILoKvbjRMueR8Q1oU5usZOE6SvD5Y6wZL+XzRqSkFf0/WxEX1ubo3G8K66UThyek0PUkQ+6oewD6YUe4lvO+lsJJJtSqzZxcTol+4Uk1Pa4rLetbyDeGOI6oTl7VusmEa2PnPciE8jZXPYvwvsMTE0+laJsoElpxWTDlZ9OTHHV5mUW4jEG4KYeK2SWzZrELsYNoES99Ijnl00k+AViVaKK8cCUwKvFkWR260zylAKb70x9S25Y7kd0+W5ttcZmQkVnRpdlD1pnXKr1TzSBx8hwbT0KeFRO9OGNDLAUB94EBZJBU7YymOvKDmLyDppMnpg4UjdB6wJI5q3tHODw+lkXCXyuj4qsBp16CkkvTAZLvYWNJvujb6anQww9r7Rn3/Ujem0XdrGD04VuD9n9hHaSijRJGgpTYeMNb/k1KQkStv80myTgrlGWin4chBIxW3zeXuyM4SBwh7jSIlVUc6enGYUBlpTkGgoP4aM9zvQ+pzef+cf9DsrTMZW+5KE7p8PNxOBj/7mW5HPNiVAO0wMQPm/ADPsTPPE5PEJl1Shmszvz2BWzcho9vKN0LK0uoWa4GUrO6Y9CHg6vFT9zPE04VfP8NaittGYXPgjgwXmnwJfpVVUqGuRTta4hOaKNggx3A7+G6Jn8tlI6QRRmyo+EUt1DdchXxKZxFWjO/J1gNGh19f+cWHmPz7uNavC1Hx1eHRGz9zk3Ib1gNfuSu9ZBnEr/rkUKXeELrDRoA2zNX/bQIklwrHGGmJtCetuNQEmKxap+85JLlGi5pVL3R+dL+1mwq5bnCycNPVhzjnQgybfSDMwiRG1sQyaEtqwlRCPoVHmUP5nDR196vh+oDqUR0KLRcn6g7dH+fbUk9Ka7zfPZi146YhDqpt0A
 frbAh0yq
 uCSsNkM48yCSAjxTCnVtg2mCn0jW68Oeu9oOLdCyqc0J0A56zBAJKJfuk0tndTKchdi1FcVZJsB5lLew4LkwuRenpXzvduDuz9Nu8pEB+XxJwZ/RhgEzCP7JJ8Lw9RrwxMK5HhccSeRIlKyA37YeGrUeuoy6NSGdycsScgGOgKeyAvmRfE9dGMvMGQZLwNSp0eEDOOEtccfliHFsOfWm9nJSGIy/Ty56OXjng8GZshX5+9HYmoSO1lXTG+Tyy5NuB6JVD4nSARNlyfJ8+UkOyq707YTeGy9RIbZTLQuo43thRFnlNUOaW9VrQV5lU/Yqm84ZYHtl/m7axX6BtAWVyykkgqvPV0ZGL8hwZfMBkjiA4A4DjeURLSgrGuQwKylH7LU0NTsAF5FQFDBAA7x46LVgBuNzwtsDDklHOj/zFenyRJbdkSQhzKHpzXHMox1vM7+K6pRcfN/N/Jk/ParoUUdYaoohnJN74Kve7QB4nIfEk58BrVpPlEksJF9dha9Mk+nlUKVwNkEIYai8kxoxKsOXMYYK3ap5tRw96oo9xlLV9x0VDedEtsJ0BTq2QZvxyBMwqBDGqwwl0KpMgbuTe0ZgZBqLFC6z+rKORobb9KHDnbPR01AlLj7nvvQKiTFx5Mi/31iGrgEcOt3vrds4aVF6gsrrzevvw3h4W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Aug 2026, at 11:55, Greg Kroah-Hartman wrote:

> On Mon, Aug 17, 2026 at 11:19:23AM -0400, Zi Yan wrote:
>> On 17 Aug 2026, at 11:06, Greg Kroah-Hartman wrote:
>>
>>> On Mon, Aug 17, 2026 at 10:34:26AM -0400, Zi Yan wrote:
>>>> On 17 Aug 2026, at 9:55, Alan Stern wrote:
>>>>
>>>>> On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
>>>>>> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
>>>>>>
>>>>>>>>
>>>>>>>>>> I prefer Andrew's first suggestion.  If the user asks the kernel=
 to copy
>>>>>>>>>> too much data, just fail -- with no warning.
>>>>>>>>>
>>>>>>>>> __GFP_WARN gets rid of all other warnings, even if user asks for =
a
>>>>>>>>> reasonable size. Why use such a big hammer?
>>>>>>>>
>>>>>>>> Because on many systems, WARN causes the kernel to crash.  You don=
't
>>>>>>>> want the entire system to crash just because the user asked for mo=
re
>>>>>>>> memory than was available.
>>>>>>>
>>>>>>> User asking for more memory that what is available is pretty common=
 and
>>>>>>> should not trigger a WARN or crash, unless you have panic_on_oom se=
t.
>>>>>>
>>>>>> I assume Alan is referring to panic_on_warn.
>>>>>
>>>>> Yes.
>>>>
>>>> Right. That is why I said =E2=80=9Cunless you have panic_on_oom set=E2=
=80=9D. So panic_on_warn
>>>> will not crash the kernel if user asks for more memory than what is av=
ailable.
>>>
>>> Are you sure?  It kicks off syzbot, what prevents the oops from
>>> happening if panic_on_warn is enabled and a warning like this happens?
>>> Am I missing some code somewhere?
>>
>> usb=E2=80=99s inode.c uses kmalloc to allocate > order 10 memory, namely=
 >4MB. This
>> caused the warning.
>>
>> kmalloc=E2=80=99s doc says:
>>
>> kmalloc is the normal method of allocating memory
>> for objects smaller than page size in the kernel.
>>
>> Shouldn=E2=80=99t usb inode.c use a proper memory allocation API?
>
> Normally this function will be making >4MB allocations, as that's what

I guess you mean =E2=80=9Cwill not=E2=80=9D.

> USB devices do.  But if a malicious userspace were to ask for more,
> well, that's what we are now discussing.
>
> This isn't the "normal" case, it's a "bad user, so what do we do to fix
> it" case.

Right. IMHO, USB code should not send unchecked user input directly to
core MM memory allocation APIs, at least the code should make sure
the user input is reasonable.

BTW, kvmalloc() also gives a WARN if the input size is bigger than INT_MAX[=
1][2].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/mm/slub.c?h=3Dv7.2#n6912
[2] https://lore.kernel.org/all/CAHk-=3DwiRq+_jd_O1gz3J6-ANtXMY7iLpi8XFUcmt=
B3rBixvUXQ@mail.gmail.com/

>
> We can bound it by some magic value, or we can let the allocation fail
> like normal but just not cause a WARN message.  That's the two potential
> solutions here.

Based on my discussion with Vlastimil on IRC (he is out until next week),
I will send a patch to make kmalloc return NULL without a WARN if the reque=
st
size is bigger than KMALLOC_MAX_SIZE.



Best Regards,
Yan, Zi

