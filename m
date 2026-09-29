Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBC3CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938346B0088; Mon, 28 Sep 2026 21:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9102F6B008A; Mon, 28 Sep 2026 21:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DABB6B008C; Mon, 28 Sep 2026 21:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3EB6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:52:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4495803A9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:52:57 +0000 (UTC)
X-FDA: 85265126394.24.B315355
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id D03D0180003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:52:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S7Ue9AhX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790646775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXYxAZ9m7UJndTCehaAcsYFtF+EyXG0B7m+hXglqxnc=;
	b=QPdsFmIG/Ed18VvSgR43qXGFrCvRqKSY3jTDAm44R+nmuS68G3jVbnqW0U0z70abzyNjw4
	0+3eyJ8XtVssn7r8HwUMTwcgfaMgMs2tdR+x5mvR6rpTxvk8qdY7Hl1QxHIKcTEHUFehUK
	0L6PVxQHA1XHNSNQVjCitnhnaP8Lnto=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S7Ue9AhX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790646775;
	b=aOOuImHGGfscTDBf1wKodplehiPKKv3zx2UdvjxtkqBlIiwFn/f95W3OKLB0Zw7RRSv2ec
	1AjE49W02p+dfNaqrSEERKLLJlKPymfggKBFNDn4j5hf+qp1vAIiRLznCiWPBQ5htBWfuu
	PAIqEF2h6+JAlwf4ApZGWVqiqmihJoQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xsmCrY9MTv1nz8eby5VWpPSobjvbSpQKcZbbwhFbZbiyt9xaB4fEgYEaTo5qPAQQhgQ0Ge52gDSL3O478xV5uDT8iEbPx6WWPeoI6FMrDxg21DEg/m4+X6nbr5tUFncqMQxXgnzQdgiZdP8mT4KOQSweAOFXFeaZQKwmgT4S9T1tb18yoIi1vlm290H32GxO5G7vXu+h52UqWJIBfwB+jivgGaLMsFVRstv+PPKkbhabKvJCVBUm+re0i5eOQpuLhxbgyFEeJtEfUrSANJgM52YKidvDyQnSeyE+GHm4DMb46GwMNeXljp1pU4JP0r+Mlhr0zl89LaJikRjimIFC8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXYxAZ9m7UJndTCehaAcsYFtF+EyXG0B7m+hXglqxnc=;
 b=LIt+K/jY5eIBviH9FmffSMTeZBfEq6CCu/DavXk2yBQey0b1oyvH2Wb9UkoEzRUyg/Q/xXdl88TTDLktchX2ryJTRTe85NzFWwujWj2HIo94LEGWTgbHrK5ZDhZ9sC1bxAqtb4N+WBK6/BzJia6KsWUuvuO4uCc7o5aM4nLRjpJg+oU590/xRrTnMGCF9+i+J0xgCF1O9Ci31KxURfPyKIPqOtaCuozrMTB9HBLev4E09B6fWSSNiHnNQOMPfb22OeF+hf1vQtBGSftSOmnGNSx1dqae1LKL6Fjt38najuSxIYCwmI8/mB5Htv2Ybl6L/d0bWAd5/8oRsXFor7f/ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXYxAZ9m7UJndTCehaAcsYFtF+EyXG0B7m+hXglqxnc=;
 b=S7Ue9AhXDNyzd+oiDfGLPnMx7hCIyjbupDkOVj3V4k5zkGiwbZCCAw6W9+rVMJasmAcaTcbfvDovpItwCNz3QaRCo3maXCyFPQALHF05vD/zrPwJZdyaxKhRBp2pBuBcsonHz891GZRgRHcDE6nop5FHwgMO42XihY5llyTXwlHXAGaLxYdGGClkOrDYOIq6wxmjXdioZKCuPF6+V4BEaZ7LthkhBckTpsk9eRA/h1zLDRPvi+WjIXPf6ct7h9EKklwxCoG4vBywjNEk9KYwxuPMiRVFFu2KzqPTbEs1HpQxpLL59psYR/ar3i+PYAbOQX8jRxZMi5eljOnUiJggsQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB5626.namprd12.prod.outlook.com (2603:10b6:303:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 01:52:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 01:52:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 21:52:45 -0400
Message-Id: <DLRFAVOI3XTB.3S2NSHAW7QLQ8@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R. Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 09/13] mm/collapse: separate scanning a PTE table
 from collapsing it
X-Mailer: aerc 0.22.0
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-10-kirill@shutemov.name>
In-Reply-To: <20260928100630.21870-10-kirill@shutemov.name>
X-ClientProxiedBy: YQBPR0101CA0093.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c83a928-2ea7-45c9-bc40-08df1dcc5c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|22082099003|18002099003|6133799003|56012099006|10067099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	aCl4mvEoAhS2GMxnGXPdF1nVOZDm6vyjevzMIdJBALGeFb8EC0ZewfgVp9etJu/vQDTn9h8yBhorSENYr/wdawkQkZXrO7J1CJptVFFHaeH+klTZ8CtQ/RE/ZB8FKllrdINyNrYRrN1yFDbQsEVL6HuR0z7zFIGr6lvTJGqzKJ90Lsx4stCMVmMEANMpB0txQW6Elih+NSsNLJILys/8nL5mFPiC7FVZ/5ZQaJ6maxhUGGstmxyrvN+awYzNFNIh0Nvdo1x+vRvhAZbG/qoysHe+f5thrmBtlv6EIBUJ3B8vhSRs+53z+9XFPoMymOy4c1vQa6qtkHTGb6WneyJeqbahjlbXtfnkqKd6kvmKu51ku8epXQA126bF3DG/roDXVdwhGrhjf/vgFZNEZ99DCBoRNaJbCOYyHWvE/6EB7dfdC4bPLtWUo4qDfL4r23OSB4H51ZYvR7sIfKABMVfqRRHsoBRgKMLI28XcXI82hMa5EECDBScPq8ZnkVPMduHX4U3VSDzQQvX1C8zdlml920IkG0fQLTrJPKmgWkrSYG9O0/M1mANZ8vSb9WyAyZi/gW3GM66PSCAyGGMvp331c4xrc1eh7Z4IFK8FMxMLPSc8FK/60lzGxCAiZWBFcGSTOvu/u25+6Tn7Xl+cVPgCY06gjPJ2Kzip1WjODGVRwwI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(22082099003)(18002099003)(6133799003)(56012099006)(10067099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3FQR0ZVUkFJRXNRME1Hb0F2Ujlsb2VzV0t6dmpKZy95dXh3SXBnSnU4Q0Ew?=
 =?utf-8?B?SlFJcVQ5WlE2NFROYTBwUG9YdjlUeXFCQXorTXdkWDU2QVYrRk9QQjhSeXlj?=
 =?utf-8?B?NWpjMXI2Rk5BZ2VzWGdoY2I2U3NRMFI5SmhNRVEvNElOaW90M0N6S25DYU44?=
 =?utf-8?B?V0xLL1FCeUxtVGhQbnIyR2xFVGtRU3VkTFAwMVlKcDFSc0NuQjlLS2pMSjUz?=
 =?utf-8?B?T1llc0ZiMlNUdzVneEtnV2NHNmFBOTNka0FDcUdGQW5ITEl5LzJDZndFakRB?=
 =?utf-8?B?R0lwNG95L1YrRitJVkdSUFUrTEpEcWRZRmIvZ3RXWkJRNUx0eU95Wml1Y2NY?=
 =?utf-8?B?QWkwMTlHSjNqbUs5MVRBY21tZTdsSktnUXdJMEhvV1kwT0VaWWZZRXl2SG9W?=
 =?utf-8?B?d3gvOXg2ZjRwdXgwR2l4OTVha1NaNGJLaDZuMnJSemkyaTJHOGlsdHJja0Mz?=
 =?utf-8?B?SDBCNWNtaU9wZFNoK01TL1JpTy9sSG9RbDNjZTEvbzZqa0FjWEVpeFNrQmxp?=
 =?utf-8?B?NVoyRXE1cHVyd2FHbzhzTXNTWENPZXVadU8zUUZXWXlqcGNheWQrRlc0YVNm?=
 =?utf-8?B?a0RERUh2azVRYm9UVDZlaTE3cCtYNHJ5bURRTzlQVk10Y3ZOU0xHUmROZi9K?=
 =?utf-8?B?OHpaWmh3WC9idHBWazVXL0hwVngxeUNkN0lQdUlpRTRIMFNxeGlGdEZzTGd0?=
 =?utf-8?B?RmZKTUNIT0VnbzhxTTRuWTB2S0xjbTJJa2lvQnpMbG9rKzZ5TFNHek8zTkF0?=
 =?utf-8?B?Zyt3eEtmTzhLbUI2eFFnK2VyR1ZwSjJzYXZtZTQwWXVZOVJldW9aRHZFMEdW?=
 =?utf-8?B?bDV1YkFlaCtRY0RUWmNpS2VNUHhSQTFTZWNzeGJsU080Yml1RDRWd1lIZGRD?=
 =?utf-8?B?SkhCbEsvRVRWRklsQ2FyRGdORkJiS0ZiZjB0ckVhTEloNENldXZ6TDhyU1NP?=
 =?utf-8?B?MGlTamVCRjhvRC9RZjR6TTVhNmYvSW9DZENveG1ScUFzc1gwVis0SENNaGh5?=
 =?utf-8?B?eFhRbFJBR2ptVjJHd3Zqd3loUG5kdVNOcGhBdUdUalNnbVVwWmxoK0hia0dH?=
 =?utf-8?B?bnU2dDJ6eFdwQThXc0kwUjlmN1pJY0Q2SXd3anJETUlVR25yNXM3Yk0xSDdh?=
 =?utf-8?B?Q3R2SDBQRW1uR3BKODdKakhWdFljODFZL3lxbEdOeFlFU25lb1NEbkRLOU10?=
 =?utf-8?B?cXBHNkxJNEhIaUR0anpXeXJCMmRHNFpXOEthMFF5MEYyZkV0QzY3VHMvbWtQ?=
 =?utf-8?B?dFhheTRmL1hDTkNQUGV6bVhNUzRrZ1dRQ1pibHpFcm9lRU5LYnVKVVZZLzRW?=
 =?utf-8?B?ZElMS0VXYSt2SGVEWHZmU2ExYStjaFhGdDdMNEpscHM3TUViZHV0SHpqZldD?=
 =?utf-8?B?UVdzdGY3VXZ6VC84LzFLK1NFY2VFNDNFMTNxOXcxNzRkOWdrdGI2NmgrakYv?=
 =?utf-8?B?cGhJVkI4TXZaK2FIUEswWWxxckZUdmYzQjk0cjFxU0VCeHh6cVpWeHV1WlE4?=
 =?utf-8?B?NUUvVG5HMENKMFJKMkdBclBLeWpKY3NSY2wycXZXbVRxTmpsYnFHK1J0VEFw?=
 =?utf-8?B?Zk1pWi80RW1HSDd0Wk1VaWxLVFBNMkZEUW1ja0lOSkgreEpuVVdxWHRuV1B0?=
 =?utf-8?B?RGNybGgyZ2xab0QwVVJHZ3NnRlQzQWwvNnRCRFo1aDVTZjlMS1VoNnl3M3Bv?=
 =?utf-8?B?NTlYcjNPSThRZXhHUGhIY3BMRmZvQzdBbWIzbGJQM3ViQTI0d1FkQ2pESGhW?=
 =?utf-8?B?dGlsbWI4d3oyMXZlNjA1SHZ2bjdhWmppV0Q0djNOUFlxOVpTMStxdmNYSloy?=
 =?utf-8?B?WUVuOWhiK2k0NTNpSHlncTRNVW5wS1l1cEZYWkdIVnYwei9jMmdlc1JLV3F6?=
 =?utf-8?B?Y0ZxZEpmcnN2MUprY2RiT0syVmUydWhpZjRaTjErc1lwem1PS1BHbGVCY2hh?=
 =?utf-8?B?cHh3NW5CcHEyOEdBdGdNR0lvbDhmeEcvZWRWZFMyRjZoMmZrSERCaWpab1VP?=
 =?utf-8?B?L1hsOGlPU0hQRWM5SXcwSCs4NnlEbll3R1Zsc1JHUG92cThBcm1HeWVFMmxN?=
 =?utf-8?B?eUxXZmRjdEExdmZ4eHZLZnFnZlR3SFl4VXo1NUJGYmlycEt6NDhDSVVxNlpM?=
 =?utf-8?B?ZmZMYW1xYzF0Ynhna3dpR2pJRGdQN2tSL0x4RDV4bkVPanpzVmU2Ymc0SGJG?=
 =?utf-8?B?YUxTeGlJVUZKWmVxYlNTWU43L2xqL3N4RmF2aGJTUVM0NWlkMVE4bFhTRlJr?=
 =?utf-8?B?c2J1aS9YL05YUHE1Zm1pQkozQnFaQ29QSjlRWEQxdkRWZ1hjT0hUTnBPVk5P?=
 =?utf-8?Q?r8JI6pnWJTgcDB4hlL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c83a928-2ea7-45c9-bc40-08df1dcc5c4b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 01:52:47.0102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wXBzJlbuzHweME8QqbXORYxSO8I0QaEq26qQWsDLsUBikmMIdeso/UgZqNNHYnp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5626
X-Rspam-User: 
X-Stat-Signature: i7cpmnk3gbjdcft6f5ydy3mj1x6f81rc
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D03D0180003
X-HE-Tag: 1790646774-686875
X-HE-Meta: U2FsdGVkX1++rK3idjshArJIkHmD2GYCyrfZbCAjqLU4D7S9Ol6odORJK3n9X8spUIY7EhoLRL2y9lbi4hIapzsTpgsqws+Du59LODeG9G/9ZD818FXYxCQeJQtS6Oej8NKrlSPaAw2PR5aqQ1YB38SNsPnZmGcHuz87b4YzzNuA2h+frQtNY64t/xyXUrSoALLrwfC1yyW6WXD3bVUXFr7TUDRoMAvkKLt0euq7WE9dBwTEPLLKoiLe7rbvXp+HUpz88xaipyqsrVFy/rVNPvAf+1CmWegWQ32EY9/dMMwl4JuPiN1MXnu+jg1e8r+7IWC//kdNQX9CE6S2b1eBm0jKoJX69tAq9CGtwzwth8UsXFnOf1DNooQXnBRtNqbvV2bL/klAvll3kqGroiDJceB4vfaB9cZkUSvSNbXF6CMWrEVuxlaZbi4sm7YtsNpeYTcWuxfXdjW2P08RLIZNEGhD7vy1woWY/Hj57LVGgIqApJtZHzU+jzCnbJplm0znMz9cNCkiBS75xoG54J9CcQEYzX0+C78hXhZD5f6QEIohE3YEPZGjHfsxDUk4oCFzEp6qH2nKdxTudEaVr6vIN3pHFkVP/4lRUTQSnyiCPyE6A6iKkVCPWCip31sPwssjKkQ6O8jBfrdc/6w3Agw54hmfqoWV+FTF1Kgu3dhPu2Yzs9V7n7XRVX+7SKUG1eDblXBcadfGpKr1j+3Y3LXBPp7zcCRLkT1SPVu2N7pZB75ZNNMxCL0nU7XRgVWJZ7tpwsrE5XzdxgjEUlppy3W+THSMQQjkQa6ASXP/rrsxZUQQ2gKFP5TXodpf3mRen9SV+RNM+Fjse9gpEfsFRmlgkL2gD5KOZuL0D0QfqVlpFDmdQJQJhBwxXvKPtZ0dcLNk9PlxGUToShCup6NMX0Sy09DehVmVtcSRFUFtWS2nVxHq+JXn/cyY/4VsCcVCIULaTT2IDIodj5xnq5uKbt4
 Z4ovztJH
 3a2wtH6/yQzwczAOxW2Gzf/dA4OQkKpTZwZVzWDk5foURU7mNAEMcGFIBoWpD/4FDlTYXJPpr5egdFSN8B1OFvOh4SnG3n4JWuGzoefMt71s7xRT3wI2Ct/N8U4DyHCRCT++3+4vex9iDYt8OlivrSFHGN+5Txo1/Ga0pFoBKRISwbsiV8QcUK5ihH0FP4mix9c+1pJuaoMcdIuGntBHtjYQD6zl6uxDs6TFtVe0WghlTwx9AAUOO4KYfqAgKowJIVBSAvFU+0Op9dMZOQbI8muIfdGXZYMVAFxmTjjx/wMlB6r2VMdc84F3urhDb/TEQQKGXvtOatHbaOxzF11tkbnfAdv1ZhSf8+6ad3W0DCAmyCY0iuWOrCJNDRcRcA8zgn1qVNS/tZGtQTSzMqutOa/xQZljg1nRMZStVxGEd/xHEedA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 28, 2026 at 6:06 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> A collapse is two jobs.  One reads a PTE table under mmap_lock and decide=
s
> whether the range is worth collapsing.  The other allocates, isolates,
> copies and flushes, and wants the lock given up first.
>
> collapse_single_pmd() did both, so the boundary between them was somewher=
e
> in the middle of a function.
>
> Give each half its own function:
>
>   - collapse_scan_pmd() scans one table.  The anonymous scan that used to
>     carry that name keeps its body as collapse_scan_anon_pmd(), and
>     collapse_scan_pmd() is now the entry that picks the anonymous or the
>     file side.
>
>   - collapse_run_pmd() does the collapse the scan asked for, and is
>     handed what the scan returned.  SCAN_SUCCEED means there is
>     something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
>     cache already holds the PMD folio and only the PTE table is left to
>     retract.  Both are work for the run; anything else is why there is
>     nothing to do.
>
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.  collapse_control_init(=
)
> sets a control up before its first scan.
>
> What the scan found and the run needs travels in collapse_control.  For
> an anonymous table that is the orders and the referenced and swapped-out
> counts, which mthp_collapse() and collapse_huge_page() now read from
> there instead of taking as arguments.  For a file it is the file itself
> and the offset in it: a file collapse works on the page cache and never
> sees a VMA, so the scan takes the reference while it still has one and
> the run gives it back.
>
> The file scan moves under mmap_lock with the anonymous one, where before
> the lock was given up first.  The lock is now held over the page cache
> walk, an RCU walk over one table's worth of slots with no PTL, and taken
> fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
> dropped, so a refused file table used to cost khugepaged an unlock, a
> trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
> only a table that goes on to be collapsed does.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  14 +++++
>  mm/khugepaged.c | 141 ++++++++++++++++++++++++++++++++----------------
>  2 files changed, 108 insertions(+), 47 deletions(-)
>
> diff --git a/mm/collapse.h b/mm/collapse.h
> index dcd117071955..ca7b367c89cb 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -98,6 +98,20 @@ struct collapse_control {
> =20
>  	/* Each bit marks a PTE the scan accepted as a collapse source */
>  	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
> +
> +	/*
> +	 * What a scan found and the run after it needs.  Live only between the
> +	 * two, and read by nobody else.
> +	 *
> +	 * The file side takes a reference while it still has the VMA, since a
> +	 * file collapse works on the page cache and never sees one; the run is
> +	 * what gives it back.
> +	 */
> +	unsigned long scan_orders;
> +	int scan_referenced;
> +	int scan_unmapped;

They are used by anon only.

> +	struct file *scan_file;
> +	pgoff_t scan_pgoff;

They are used by file only.

I think the comments need to address them separately.

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


