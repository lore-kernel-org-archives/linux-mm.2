Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39EBC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B8E6B00F9; Mon, 17 Aug 2026 12:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBD46B00FD; Mon, 17 Aug 2026 12:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECE96B00F9; Mon, 17 Aug 2026 12:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E91C76B04C6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:40:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28F488081E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:40:13 +0000 (UTC)
X-FDA: 85111323906.14.56B9476
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5097B4000B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:40:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rDkaW2Gd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786984810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRxah7E0qyX+cJMrpoZKbEhaIb3D6wGIYLakeSyndDs=;
	b=uRoRRbQgvtwfcmY8lk4s0s6KBsCqkKSWC8uwBT/BzPC9T6EeW8klFGSj7V+PSXgqYuFeUi
	LPm69V30lHvNo2/AZ2G8agiH962sWyKn70PFEye29869kcYe9z/9DXwd1n2aGT+gfdefVy
	d52xiu0GqtQREeIDgW2EtNhRx3sDGZA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rDkaW2Gd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786984810;
	b=ezfmPy6NnFEoqieNFx7x5C9HT9WlZlja+SQYJ1TJrglRSCe3gSAGP1t56dyfnAboGLHRvp
	b/SX8CO/bEoN/mvfICAC7f17qOEVSHSnp77VJTftlMdS6N+ZxI9eeP5RE+IbeSF2KfhGk2
	f3C7mB/t5VE9FUnE6BIzsQ3/0sonSm8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBxQbtE+5DyRDNgxX2HxrDA9hpPzz9hnw188o8ihc72t0Uy07hmCsC2F8a6ndG6IVBzHt6UiU/0aQ9e/KWxE7Ncc0zcuL06f2Knz/V7E6Si/oqps6AiJmnX359klV+GHJunyiebFR4izNaQRZfbs4iVCTJaHcjENo0nA9y3Xccziq0jQ/Pr7dL/5sr4uU7Tq5Yn4l08MDY3Ac7RbhWafUBRpfSGZEBywhPWvGoWxgFLZaQwpQ5cnBEcvm7WF1+w2Nnhe5sM0YhBYJ11xfjsni2Bjq7pGz7tT2er5txV4nNqvXHCON4j4kIHdMqVG+6bRhKfiNjZsF2fWxCHMsjFxPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRxah7E0qyX+cJMrpoZKbEhaIb3D6wGIYLakeSyndDs=;
 b=m/mT3KEzDtnb+2fxb1VMZHOsGUT3MORz9SjDFK0ZIpWlanvSZTMUkFKUAdpzV7FvywR3vN3Ld8O2vra8JKoA6VnlkLEUWT+lTfVR0ajwOk94Ko87NWHVt2uD/GBQuDbti84bQ5a5FIjeQoiZNjy9XMqGKloMubC4mG/3X6oGKJXtm6e33AXVJUz6cjYZ2tyF9BSi7506TK8MS0QBkv0okJXdiiLyk0wov0iVfJ9vFYO+A2D9rNoTbMPMUwzjqu8V9WzDIeh3FcmHN9CSvdXWqbywqYTlb3lzo++d76imknnFZqaSw31Qbi1/HRt1XJRoYTWX5Uw8eqqCo2eyi9sewg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRxah7E0qyX+cJMrpoZKbEhaIb3D6wGIYLakeSyndDs=;
 b=rDkaW2Gdzxp5ECzO8kGJXq8kCbLbfjdWAcPtNHsUuPR4fyx70bDTucFd+MNafPn+YOY2ISLkiuWCZqd373/hRQVwZWAWih+gOv0pnaIwUvT/UKE5glZrkq9N5MwYhCLzzBtqGsW4y5iImgA46R1JXrPSaI5yI1WxmJfTgGYxUlmVB23C/exAevGVNqLMsBFxihSIgwWsoVWsI1YuJ2PLTu9GNKrvHzWteb0mhWHq+5e4L1TeK2m8DHHKAkTuf8wlxg2k/VARzK9iKCrUS5nS+tW9Mj+XVwPUDPQfZ3ob9RGmAnKzBPC+jypjKQSd61rON9QFDlbxpoXNYbTyArWCmg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PR12MB9718.namprd12.prod.outlook.com (2603:10b6:610:2b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 16:40:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 16:40:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 12:39:58 -0400
Message-Id: <DKRD8RERQHHC.1CVF14YIY4BSA@nvidia.com>
To: "Hui Su" <sh_def@163.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge
 zero PMD
Cc: "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Balbir Singh" <balbirs@nvidia.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260817060845.377800-2-sh_def@163.com>
In-Reply-To: <20260817060845.377800-2-sh_def@163.com>
X-ClientProxiedBy: YQBPR0101CA0088.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PR12MB9718:EE_
X-MS-Office365-Filtering-Correlation-Id: 557adab8-5f69-431e-6abe-08defc7e2dff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|7416014|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	udyaQdfmipYNmYE0M+FXJtPaaCRvEWItsmcBRals6e/FH9PsWr/oRyJAi9pPxd6Y1Su20paiQr4z8LOPfeK3YPLepSsuMl8p9bEw1Wln9J9kwPZzt4945fDQnJKuYqC5ivglQICxYdUgnJD1ThYwcPSNKaXVw67ngcbPJHOq47t5vHttdcMK7CR3esMpKHU6cd/9Go6f4+aCQzBMz3zhy2RuuAMOL061fzxyBLkRjHCUN3sTxeO88aCldeI5gQ8VjjRhpvW8eMEc7aj9fd6SaHCMw1mXjRw9DuxIWuwb565wDdAwo2jWLHemqwxy45ec/D7V+LG3oMzxBB9Yyuf/7yBmsXEy3lrlm8GxbHtAn+/IAlvMukZkMIkgmd48o8+IRqkiD3FJouvX96a6X8H0YrhZfQtKc/1CAGivg3UJZ66T2oc3bApVRwWf+LLnkeBqkUDqbXdpY4o0DXKuPzlsCT4zSWfD7PVYxEOz05/smRp3e6Ot/4Uzxfn3WfkNrYoeXsBQmeJ5ezJbWWDPyCbRFG3882FY1NHrNqJeFeMLi17ICFKw9Zyze4XqAgt4WWaKyl6MRyO9ctDZhVi+jTz5fpcQHAsb8At3XVjatHCfpPpitiq2+66scX/BRjzdjpHSFezWfLLLVj1je+4b2HJI4kIYvc4cKa2v1Dqpt9JzBzI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(7416014)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1NTRHU5NTlsV3JaZlpLUytPZWc4ZEJsSnFmUWhEMGVQM3dyclc2UVJMYXFY?=
 =?utf-8?B?OHRqQWJtbjk3THBFY01vVHRMTm51WjdZVGZwQWYwamd0SzFzN05UUUludm9m?=
 =?utf-8?B?dGtYWlRMMU9wTHhZUUZYU3h2eGtabmppQ2xkZkhqaXJuUHZhOEpDZ3JiSzFn?=
 =?utf-8?B?NUVxYWxkRysxZncwY2RUbE1ibTNxTEVMeHZnNGp6dUlZMlplRHNrcXpPWHgr?=
 =?utf-8?B?SXdodHdCTko2YnhYQS93OFJrU042Wis0aXhzT0hZSGp4MTRZSmxyMDRBazFa?=
 =?utf-8?B?U3luNHNob3c2UTI4V1l1MEcyZTRzWVpqdnFMTi9paGVWOE0xVmFvQXpwaGVm?=
 =?utf-8?B?aVptdDF0M2c3T2tCUHhPc1hWdVF6MHBlWTgwNERTUU4xbGdzSVR1V2pBMXBT?=
 =?utf-8?B?cXcrNVd4VUVPYnhaOWg0d1EyNFRueXVEY2FSOGFmaGlEZmFxQ1N1NXFOaitm?=
 =?utf-8?B?blBHdWlqbHZJR1IzeGFLTHVMdGwzaU9hb0dLWDJwVTJWOG9taUpVZDRoQ3lq?=
 =?utf-8?B?QTdCUzFRMUNHQ3ZZMWJqWDc0SDZNdjRvbnExamQ1UVBDdzc3M1FtUzB1SCtG?=
 =?utf-8?B?aU9YdExxdE9MM3VNNUUrMk9DN014REQ1OHBmLzIzVGtLakliQ3cwU2RGZjVS?=
 =?utf-8?B?NE1pUWNSMEJ0ck80ZXozV2RRdDBaYnRNT1JRMUJrc2pxVEl5VS83VG45RC9Y?=
 =?utf-8?B?dmFJU01VRFFNbUUrZWxONnF4RnJvQmsrV3g5aDIycUVERllmZXZ6ZE1wY1hU?=
 =?utf-8?B?bnNFVHNzODFtczJVWHB1RnF1endESlRDL0hIcXNqSXpyYTllMnZGaFVJTHZ1?=
 =?utf-8?B?dVV2RFZGM1NHNjBOaTBodVoxcDJNaGtGbndRcHcxd1pCQ2pQcW80SXN5bDNG?=
 =?utf-8?B?bWRRY1V4MHB1cVI3bTRQT2dHSlJrdkViREZTMldUZitPT3pBNVdNQkF5M2h2?=
 =?utf-8?B?MEdjcWlrTndqNXhKM3pmU0IzRlJIRzRrZDNzM09UMnZGQlFUaVZ5L0IxbmQw?=
 =?utf-8?B?VHVRRmplZ1JLaGQ2WFhYTEtCcGhMZUhiZWp0VVFPZGVxcGhFM2p4dFJleU1v?=
 =?utf-8?B?bU54TFRueUc2WXRRSDcrNUYrVlZ2VENGNlBwWlZQTS95eEU0dXdOcDE5VGFi?=
 =?utf-8?B?SzFrY29mOU05NlZLTWdKWWtEWUIwYitPWWhrWmdld1pKVHZ0UVE4Ri81U2NN?=
 =?utf-8?B?NjF0NDNXSVdhWHdVZFhkT0l1OEZsOGYvZjhnVVhKcUlRa21Sdkc3anF5d2Vx?=
 =?utf-8?B?TTVyK003clh4dGZBekVKU0ZoZERGMDl4bG1WaTlWSDBtNTAwajZyUTNGNzFO?=
 =?utf-8?B?ZDMvOHg2TnpTUkdNdlRoRnh5bGd4WGNqUFlGMXRDL0VrWUtsdGg3eko5VmFj?=
 =?utf-8?B?SVhIQ2hMTXRLSDNEb3o4NWFMUTNWSSttVnZQdVdEbjRrOVJ1engxWU05Nkpl?=
 =?utf-8?B?YjQxVk5oenFxcVVNTUU3bzIvMVh5MUFuTllnOGE2VWdCcDNqbkxJT2VGNExv?=
 =?utf-8?B?MzZpYTlRS3lLSSttVmFuaE5JK2wrczVkVk5SSDdGb2NxRm96TGdaZHIzeTRq?=
 =?utf-8?B?VFJiamtoL1Jkd3NCRitKOFlkWCtRdlhHWml5R3Z2UGtwS0NlbWovSS9SdWtN?=
 =?utf-8?B?ektLeUtlSVRtVlVxLytGbE54WVFyREc0S3owTjJDV3dTR3grN0V6KzRBTno5?=
 =?utf-8?B?UVY5OW1zSkFUQmV2akhISW1acSt1UWNyWlFxRnlWNWF1Rlc5OC96bVZpc2hI?=
 =?utf-8?B?K2E4TTRGbk1heFJxZXZDa24wTFNaa3NscStacnRpamlKalQ5bzRFQnVBUXM1?=
 =?utf-8?B?MVVkVjZickpRdklnWkkvQnFjMWdaMXVqUFkyK21WMXRaU2JwNWJhbmtQNHNP?=
 =?utf-8?B?MGh1NnhSRGljb1plL091VzBIc25pQTV6aTFQWHVsbzBzdytabytyNzM5dnRG?=
 =?utf-8?B?MWxFcTJ2aUVEMWNiVEdaVlhsNldERTF2VTBtbVdOVWYzOHZXbjh3NnZ6dmdF?=
 =?utf-8?B?TGpYWUNJWkJyenFUVWxhLzlDNy94WlhjSS8zUmFaN01oT2tKWWYxUDhyQjU3?=
 =?utf-8?B?a1dpTFJuVGg1L01Rd01uWkd5YXRZNjEyOCttZHp1WitMalU0dVF3Vkk5RjNq?=
 =?utf-8?B?cGx1aVdvRi9vbHgvcDQ0YnQ0elUxUEU5SFJ0K2MyTHRUdjIydThOamVpVlQ4?=
 =?utf-8?B?VHhPOER2VGU1RExuVjUyQTFTQ0xXTlVITlBsWGpwS2hVK2E5M2QyQk1Ea2JQ?=
 =?utf-8?B?VURUcEEyemdBNGdHckpja3Zhd1d6N2VHOFhZOThnVXhGcFhWenN3amFZUFlW?=
 =?utf-8?Q?et1QABbWoVWF1n2Kbf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557adab8-5f69-431e-6abe-08defc7e2dff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 16:40:00.2081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gy5rVcMhc1JejjwR70cSf8Xq14h08jYqctCNnGj+BcZlHN/ejBa6sJIup2awHUDu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9718
X-Rspam-User: 
X-Rspamd-Queue-Id: 5097B4000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 7g3b46x4oejzjf6p9fzh7jny9qf8kn9u
X-HE-Tag: 1786984810-313186
X-HE-Meta: U2FsdGVkX18oyLX0PBnnBoDGgqewEk4Zlm7lUFQRyJrHXIergbcLZWD6wFzadD4261oeqW9NlHT0jUIgLbIeVjs2cZgIczpnhSWHVbR++pRyfTTs/BVRH0U0QnaTujM/xHDW1+T8QEYE7CpiTZZs7PN6dZGkOVDo1p41RttxNDAVmFR0o/Ur59ASxfaxVbcRn/V9BqOnAVUdU4AdrQ6Ac0zViLj6bLfkp51kTyOq5n6uQp7BeXOrSplV44GKhN12yvD9eAA8Z4cDsttakB7y5qPzr6emywszNCljnmNP+X+kk/1WozIUvL5GY8J1beVZH3shhTVWp/j2gAZWkaXAkigQFOkqs4+EtNNH/cbeKsCedeqZzSRDM3LFBKmvgYUmj+hOX9AzxPbwnWFj0aUoqUEWTyt7DKnMSP096yJ7gHNEzRm16irqm9B7vUQO0KGqUtvUZd8xtrEuqSDgragG1PnZ2Bx41dhQAU+GX7D3jSSJUXekftC83tweiYlxQSdFXcj2VowARYNh9d7xhE82A47SUkxdbf16smtmTF5dVOsPofjIxHoN4ox0MJ2gUFqcIqBZi6/u3gDy5hVBIwkIM0dvSCvbdqCa9MrbS8lalxVlfRGygpIHS28IvxPXG8wGloSGAfOvqLz3rwwxWJjVqhWxYWEMZQS6Ddab0KUEKCWeJZkmOWLy0Ow9ObSK9FGNVTD5CtPQD0zsyK2iff/mSJymUoibdmmCg0yfatC5w80BgYFWSeHBknL8PliGyvTTLbW+0lEAqjXukyTe3fjaMlvvj0z8JNC9+mE5eS2PY1tHmOPSNJm3MiSkJoPAfEalnUrZUoDLDNZj2LiWKpgYkk3pY1her+qMIbFu48IOZTXzwig3iA93XRB/m4z8ZO6K+DlQTk2B/OKnjSL+lAM3G8/Xhgq8Ktm8gbURwn3Yxg9AlCNp5UwSqZ5FxsG2BTk/S4jcXBP4m1W0LHKNiv9
 hBeLx6v9
 1fSXBRxlCwp4fq8jHYda04zWxGJHUfIzl3r7GCi8qTVKIlSe4DHls8f/xR3XNx8JOl9zuHuFNPxRSbDPKDLCOaQhZIl/LZrpOzPur8gCHT1R1wlzSYhMCd2xW7UEewsNKcSy8e2e0okZ1IncTtG1aP4Mgq4j6BptF/0/2uVQ82787j8IJuQWuYi4kheuScCsVpwjA+KJ5SnefmUsAX+RX25ad6VqUKuNNA7CaaIu7iHJzJpDxbM7tvWX1WpcuVNqus+qJeJ0GSlzgf2VfHvEHLc+nKXe+3psoBDhhw0b2vFyrK2PVKnxBWDgF0Bu2uLfrA8uHD6UpBHhi5ZJJX2Jn/HePbhgrfcq2DtbKVRW/6B1+c2S90ftEthRsNqLtL/LaDyeYH//OGJDBNkl8dmIfCrM6mwfQU92hhf6WSHYtvPSYa+nf4mee1mA4MKlKkA2w4sb/dqHeQjTEirws0df9NwLHiOOt9ANMO5Bt3pgTiAUKFW6VA1LjszPscOeqGTWEBm5QqWD0lumvQGUinAh4UEP2JsyN9f2eh7w6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 17, 2026 at 2:08 AM EDT, Hui Su wrote:
> migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
> replacing an existing huge zero PMD. However, the third argument to
> flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end
> virtual address.
>
> More importantly, the mapping being invalidated is PMD-sized rather
> than PAGE_SIZE-sized. Flush the whole PMD range with
> flush_cache_range(), matching other huge PMD invalidation paths.
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone =
device pages")
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
>  mm/migrate_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thank you for fixing it.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


