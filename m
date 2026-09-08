Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6042BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EBA6B0092; Tue,  8 Sep 2026 07:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036546B0093; Tue,  8 Sep 2026 07:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E685D6B0095; Tue,  8 Sep 2026 07:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEBD36B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:13:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32773C0534
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:13:08 +0000 (UTC)
X-FDA: 85190333256.12.4D3699C
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A32780005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:13:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dr0hhpDk;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.24 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788865985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luPmZf4cp5dz07FJBCmfrWE0TCBNjfIMciZMRi4hj6Q=;
	b=6U0sviUIspwhzpRIPDG6KBGhcaBaJySGDM6x8IdhNOJly5cJnjakFcIYjdQWYwpA2t/ysc
	eb3QJ0fSNUfgHWuOdrKZs74bSrT9f3BCSqpkNEpMnWmbovtM7XA2erwrnXbfasRP5GDOjX
	lawHaxFlTMv1yeiiYtlejLq6Y4WAvn0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788865985;
	b=0dDJKoD0Tjy0gKS+yVg4pio9VSJYLCUpKO7NjodMF4e2TS1fGfKF2wsx1fsXvfwNSmG/uN
	MzrAY5dAFQYK9FUleFlnlP31trWnGkefuOU8wajErsD5OByVUaby88kO3ObZWcmmIFAjwI
	f/XDyU6rztnzedewqvyU30qjxRyW2iU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dr0hhpDk;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.24 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L67qYjddTMm2P0rGNRF78cZn6GBnN9sdbL7Cc0r9mlxexdWCGZ8JnVtIOGMWCBHAZ+ikzBMCYHhMLX0DNzz7QwkAiwnIqzYvLnRjgACuKOYBG68vcsdXpJJoQY8vxeNT+DtGiaio9eaKOm77iXoYdjvUYy1/6Cb4d0Z9sGB2dqlrDSQBw+Ww7iYb/wseKHGz3vkRnnSxwl6+gCaRPmLFecESXJQJSKlXulS9KwR9cUsmfjYPSvrlzNusZLZZ2usB/SRkfD2cG2DH5i+mjSBMGmURFx7Nvzkv9nIH8nZaBIHf2bgTIm9dW4fFuHMauJmQNHUgA710ugV6fuVrYesR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luPmZf4cp5dz07FJBCmfrWE0TCBNjfIMciZMRi4hj6Q=;
 b=MpO40Aiy2W0EKKWZLp1PUQWnnTqX8k5szvClDJOeR0Kb3T8Cf6TkvU9kqkrb7DZbWDxageejqhX5aCvwNJ8NW7qeXCITgIopCd5Wl24xzOJb6ZH8ACOJnHAA4NW5Jm438NVMsZFm+vshauDSfFHkU4TKePve3JcxNceg59PJJ9YG/ZCcCD4kMwlGyvpFgcpdEP08yP1qBnQaO2UHSztHsidSVxp+gFVgETrZu+AdGeDDYmNBdVPpqYsL0jNFCstSb3eDv2h+QwZiiYNekfSZtVaX05l0lyjyV0sz68xjHTfxK2A0tAWaM25rAlL25ld10eMP9aQZQJlW+aWbSff35g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luPmZf4cp5dz07FJBCmfrWE0TCBNjfIMciZMRi4hj6Q=;
 b=dr0hhpDku61yROLDyGeFPghYPWzWc9Rjr02KrqPALA+0o17KJvJWEGiWUTNryn8AXsV/ziEc+uvWmQYfwNh++DNLBKa/z8t0d8In6tWWcUfnTr17PbDxhWkmUai9RjaZUmBTEPYuV27F5A3LMA1lTaGxIQQNoOedB2NXDenGWUaS1zbPuaPQrWdNEzy47cWxipnPAavSCsEMoObie2tLS1mSoUzaMXXfroYXm21gsE8/snD+ZVf/Tj0roCyuqYwj3CoajRtLM0ixMJbizmhTwftBGOLDzuKE2q1RuSxw12L9rk8fleDoZORSb4yeP1PSXS7vDcJAS0fviqNU3lIVsA==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by SA3PR12MB7829.namprd12.prod.outlook.com (2603:10b6:806:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 11:13:00 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 11:13:00 +0000
Message-ID: <9c78491d-83cd-4ed7-93fb-c228adb778a7@nvidia.com>
Date: Tue, 8 Sep 2026 21:12:45 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ziy@nvidia.com, hannes@cmpxchg.org
Cc: ljs@kernel.org, usama.arif@linux.dev, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 kasong@tencent.com, hughd@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260907183340.1446132-1-kirill@shutemov.name>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260907183340.1446132-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|SA3PR12MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 379d13dd-c1cc-4c58-c5c6-08df0d9a24b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|10070799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7gfaS7MUeKIdsMfO4eYJj6+dmixHooF68Vh5dx+kgA8WovOGD/0lqo//4KNZyBSNqOnxEtgqSaC/MFHdRpLLOqSLMkfhEucP/qKutl2zPZgPhCV4alJRYDmGOqtyuSXiQKw+P264UtQz5n7wohN54J7WPD+7KQkaroCb+8kmVISV5/W+wYOCgjxDge820HKlkBySrxoW2Nnily1VcUyHjsqicHRIhuG4RitdrdNToUeIPUAneuM7g6VRVBgF6IYo1tcVycTvtDoYazvYx3oeLr7YqjQ00xmrswvcWiS9XWY1o5SzsgbtvQu9p7f9G13Le7JW5x+RtjMyJkI457z8H58wU8BNhizGb1+Mbn9eri6CoOlo6luqQaFs9vsrkXR2oL1S7rvT1dbMU2LiTR08caKPV86liCGOCqxxvPwTDENMX0RGKbR1guX4omr8E3ydnhUmrTVFV5zA4/+hEsawwu7j+L7f//apm9kvC1lH3QahgkvcVeER4UByZde8jRvWg+aZrcU+TUs2BShu722rWSZ+W3HFNsUFqktJ3FOQKqFa/jSZkeomtpKQ+8GsqiVPrjcrbncsI2fidd84nECY0GLH2zwEsJ9LLt660SP4/Zjs3uL2R135FQM5+6G5fnuHAo8by6V3RW0HYfHfOE4l1hNh83abJiLwMyQECT9H8RM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(10070799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHRKdzROUUVUZmR4Vi9WOTY2TzM4bUpBaUVOUC84RjVibnJZQWxVdEpLQVR2?=
 =?utf-8?B?Vk9rc2FPYUc3bG4zT1R6aFFMOFY1enJPUXEvVk1wL2RPOU1LRlpBMTV0OERl?=
 =?utf-8?B?Mk8wOE5UYm94QXNWTWNJSkF6ZEFkUjFyQkV6a2tsbUdaQVBFb1BoVkVQOEhs?=
 =?utf-8?B?TW9oczY5eGg5TEhqUytzaXBOQ2ZUVzRGbG1kemZXY3NVSDZ6a0t6U3VDTFl1?=
 =?utf-8?B?eHN0VUk5eUJyQ3lLQU45STc5WXRmZHRjRVhlYVNZV1lOZGFwZEVucnpDN09R?=
 =?utf-8?B?UHU3YkVyb013T0ZqcWVuZWk4R05WSjVWS20rUHhWRy9JZkxvUVNzQzIvSll1?=
 =?utf-8?B?T0duNVpYbXFsdk56bjNoOENpcU9NOTdITUNFZjFPNzBHazNyVEFVc3NSVFR5?=
 =?utf-8?B?R1V2NUEwNnQyWUxTSnJYZlg2SU1RK0xVUTNGUDMzdUNCYjJPT2l4N2h5bHZP?=
 =?utf-8?B?RGs4ZDUybW9OM2d3UHdaWFdMTXdtZ1ZEelV5SnBqVTlwUE5EY2E4ci9hbnlz?=
 =?utf-8?B?c2hRV0NqajNZbWFXZkhMZ05UQnIvK0VMSGZBOGdCZUY4cWxFbDFncm1NbXY0?=
 =?utf-8?B?akEvYkZjY0poc2REYUgxQkY0clBqNUJJeWFzSGtRTjlEdlRNdXc3UkxpWnVS?=
 =?utf-8?B?U0VGZVNxSFI1L2hNc3NJc0txYlA4akQwckxnMEltVEhjV3hDREhjYjIxRHJD?=
 =?utf-8?B?bVZROHlpRkcvMU9nU1NacC9xeklzSlhSUHZhY1hmcm5jOHMxVjRrV3VIQXM3?=
 =?utf-8?B?K3h6ZHRxdGV0UFY0ZEQxYk1NQzAycTBiTzl1dmtHTzZEZXhyYzZZK1dyVG5F?=
 =?utf-8?B?bkduZHcydG5ZOEpJek8wcVhVWVQ2WkdPRERsTmh3Y1RwdDdrbW1YUS9kVzd2?=
 =?utf-8?B?WFV1V1BhY29CclRaT0JmeTlWWEdXdmxGbW16QWt3b1VpY3hod0VMdm8xUHJR?=
 =?utf-8?B?QXl0akMya0JFZ3ZGcDRqeEtOYlN6RVNOODI2VFlVdTVqUlNVakVqbmc5REp5?=
 =?utf-8?B?NlVOdWd4ZDFOakdMb0FuT1hJK3JGdEZOOVpnajNYRmFpYThsd29xVkYzZ0du?=
 =?utf-8?B?djIza1ZqVk02TFNVYTlzd1JxbkJZVVhvMjA4UlBGdG81cG9SODV3K3pkdTR2?=
 =?utf-8?B?ZXQrNEJJdmdzUjcvWmRYbVFZSjRXOWxHZUF5ankwTzZmWnA4bC83UHc0bjdh?=
 =?utf-8?B?dnVicXFjdnBQY1RFY2FIdjBmSjJyVGN0RkNmUW55OHl6bGZLVHpIRk9SUHcx?=
 =?utf-8?B?N3BOQWR6bGxTSTB2MGwvMG9ScGlwMWpOemdnZnJnL3BIb0hKZ0N5L2ErWjV3?=
 =?utf-8?B?Mk5Oc2x3a1YzY2MxaVdvUUhWMmFsUXNMNjFYUEp3bVV5cWZDZXBJNlhMSkVo?=
 =?utf-8?B?UjZvbjBrcSs4SzhiZy9OUlF6bGNid0MzMGVsM1liWU0xdHUrOTNiOG9DUWVx?=
 =?utf-8?B?NWF1L2ZZWmpRbHBKeTdqK09oTjZzQUozbzhBMlhpdzhmZElpcjFPWnV5WGF6?=
 =?utf-8?B?SVpBalNmTWk3VDhHTzhLbDQxeGVqYmkwMEVXNjRnTE1aQWlxNHkrd3RFeGxJ?=
 =?utf-8?B?Z200d25KL0trZldVb2h0MUEvZk5ZNWkyUDBXa2ZTeXEwd1U4a28vMWd4Mndk?=
 =?utf-8?B?VlJyaHFsMXNiLzUvTlliNU1ucVVBMGtlM3I4ZXMzb1llNERneWFzWTNqN0FB?=
 =?utf-8?B?cWZ6b281WkpZQ2tSRWtBSTNaRHNmK1VPeFFYSlh3eVNZalc1QlVRSkJ5TWZQ?=
 =?utf-8?B?b3ZWaUZQSU13aGNUYzZjUTlkZ0tqUWxoTnFVaEtRUFp1UGMyeEdyWW84dDRt?=
 =?utf-8?B?UVdUMDYrb1k4WmI5dTZVekpFbVIvV2V4QkVWY0ZkNkM0dFkwYjBkbS81ZVEw?=
 =?utf-8?B?U29lZ1YyK0ZnRi9lV21XSlNNNVRzd21uTnA2YUppN1JRYUNzRFhjbnFaemlm?=
 =?utf-8?B?Qjc3dXVjblFvd0MwWjQ0QWt6Z2UvTUx4V05LbHJCNjdQYXlPY3BiN2UwWjNt?=
 =?utf-8?B?VW9rR1RhamQ5ZDFUVy9yVkhIYzV4T3VJOEdLUXRIZ2dOZ25KZnZrckRUU2pY?=
 =?utf-8?B?NVQ1MC94aUZtM2QvY0lBbmVDZ2QzUzlpR1JhL0l6Qllja0pVVTJBb2xHYnZz?=
 =?utf-8?B?Z3NLQmd4Vnk1WnI5UUZmWERqbkxXVzZrbTFoN1hWZkpJNjd5MHNIVnFWdmxL?=
 =?utf-8?B?czBLaG1RRlliV0xqYjNjTnR5SmlRQjBvWTZSUUg4NnNFMm92cTZTeWpzVXdN?=
 =?utf-8?B?cWVFaW4rRXFocUNsOTExeDdDWk9aV2krM1VxT0oySENlOWlIRjlEK3ljWGNE?=
 =?utf-8?B?R3c3dW5RTks5NTJlTnZETWh0OGxINC9scjY5bDV3OHlPSzBUT1c4MWNVUlJZ?=
 =?utf-8?Q?y7BRdkWSiNsqvzI2/BD1hpbBGX+aq4jwNu0+kDq76zXzr?=
X-MS-Exchange-AntiSpam-MessageData-1: wdl/mau2cQeKIw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379d13dd-c1cc-4c58-c5c6-08df0d9a24b7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 11:13:00.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUsoQVf0UPBFAYAVGc6XrtdIU1x7oILQwbeTmQ2fm/+tqW+7c4p10esc2gu8ZbMtjRGiPhzuvydq/65ylbowfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7829
X-Stat-Signature: nj5hzsyzcz3ck1exfcek5ffbmwtkibht
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A32780005
X-Rspamd-Server: rspam03
X-HE-Tag: 1788865985-850094
X-HE-Meta: U2FsdGVkX1/TqAorkywzf+cH7ZEmbQ/3XK2S2iXWqYB89Wu3NxjHdX10Z3e+zNVCrzRmjYac4+6JRYwT6750mCnwH9G1l5PDTeqXCcpw9R4Rdpm5oGGmMmNROVgxnihPzKPNU5+DWX083eSgaoJFjchipnbS66J9Y19NknSdJR+1VZHIjmfyjEYRS/oiJwp3GZuVAItAMh9SZtdCjJqd4MzxU+MsqNONLfejoOgllf5sMTwsYLGQ2/leCo7E0ie8tNbOg1ZUNGtkjBLf+88qIvdwZXQ41nRci9BFpblJl3VcFFadx1X6y9m6IxHgJ/ynizPAayRk6GKFC9luHzIE7iWYICU6Nk+99r0o7TBNeiKYozllY0sl4DzaKeXfl5E/KJlBhAP5w/NWEsws5xrSwyt3N9pbRdYSH+//6nrHc/uD1+KB68VbHFY+oOO0lUdlQoki5IHhSZMr8G/DkV4G3ARiypR/AjV4klqvUQ+ldeX9SBweRNjaMPaNB6pUEjLb1zmorS9tTz0R9UaOt562v77Z+vAyB8Qc2BjpubGN8PZDBZjw5ZkaKoUy+dVAnYevxZu6RmvpfVLAgv3BC8c9elcwKGa2NchSzWldfS31Z+jvwvGHpcFwFwv6xwHB9ceilXmDkqdQaxXVmy3fv5hwQCKdhmrw8KudtMGo5sumiu6SleexM+No0tr79osD1kJusVGi+iTFJvbjzorDtzzOHzTTRMw4kS0SYE6kWRaJJ7DkH82iUYl/fvRP4NLn735WA9agckBWhdo4XB3RU6NP5e3FGztDHgxE20uGaAKo9MzIXZRj0ptksjJn2JOrht3tRAp0vHN41kHmPZpXdozZUfknPGRNYMcPD9eLx+oZcT6yZV0TsYrIZrCHy2amkJH8eEnVQq/woTVaE0tt+G4fNxifQUZrV8ivdR8C/iN3FcLOsC4ai2/82BUij+vw7KzzzYRTdWNJyzZCYnMH7jj
 Kl2Br8/2
 V9JEW8slrTxdMM8KjDHEQ86NKPL7GZVOEfz4SYxgfX9mdjEHflYXCxAFaKmnzEkLsnZybL5fZqypuWY2cm/cwc3Za1kNUomxTxKclszzJcHsL2SwUWqTLXTpO36TLnm3QsFJIAHiHMZJsBtEY2yosKGFHmmt3a42vuHlTJ/0o9gy6m1g/tuVCrKNh44HztaJGAjGS9Lu52M7mBEAbuFk1aD2CB6KXS07SyWPY2DagWIGvt+FkO/ShWjCj+TQdDa9Hgj4FEdr2S2+Kq0tVEffQl3buvh2HSuKCmZrwN2EyeOCZ+AQGenwzocVs+r6knTdpS8S6qxWd4f1dOO5/5CpsGN0lf4qcxBp5qVGTJe0c8AMU+Z4FgxI+FxKOhZpp2U6s2qpDWdBaoLHkkMgL/AQGfSQPuJPftPAzDhCJANPDAV8WUP79IjOu8tQ9BCALI1RttNsXvywlZf7a1OEc5xcuf8Q3dhu6vYml6BaSK14/EkhTEcVFm2n/v8nfM+wKPE3e4jvR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 4:33 AM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_unqueue_deferred_split() and __folio_freeze_and_split_unmapped()
> both clear PG_partially_mapped and take the folio out of
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED with the same five lines.
> 
> Move the block into folio_reset_partially_mapped() and call it from both
> places.
> 
> The helper asserts what both callers rely on: the folio is frozen, so
> deferred_split_folio() cannot set the flag again under it, and the folio
> is already off the deferred split queue. The list check sits behind the
> flag test because order-1 folios have no _deferred_list.
> 
> folio_order() is safe to use at this point in the split process: it
> still shows the pre-split order.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Assisted-by: Claude-Code:claude-fable-5-1
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/huge_memory.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index dd66c6ad5af1..23ef22c2b5db 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3972,6 +3972,24 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
>  	return folio_nr_pages(folio);
>  }
>  
> +static void folio_reset_partially_mapped(struct folio *folio)
> +{
> +	VM_WARN_ON_FOLIO(folio_ref_count(folio), folio);
> +
> +	if (!folio_test_partially_mapped(folio))
> +		return;
> +
> +	/*
> +	 * Order-1 folios have no _deferred_list. The flag is only ever set
> +	 * on folios that do, so the list can be checked after the flag.
> +	 */
> +	VM_WARN_ON_FOLIO(!list_empty(&folio->_deferred_list), folio);
> +
> +	folio_clear_partially_mapped(folio);
> +	mod_mthp_stat(folio_order(folio),
> +		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> +}
> +
>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>  					     struct page *split_at, struct xa_state *xas,
>  					     struct address_space *mapping, bool do_lru,
> @@ -3980,7 +3998,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
> -	int old_order = folio_order(folio);
>  	int ret = 0;
>  
>  	VM_WARN_ON_ONCE(!mapping && end);
> @@ -3998,11 +4015,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		 * leaves PG_partially_mapped set.
>  		 * Clear it here: the flag does not survive the split.
>  		 */
> -		if (folio_test_partially_mapped(folio)) {
> -			folio_clear_partially_mapped(folio);
> -			mod_mthp_stat(old_order,
> -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -		}
> +		folio_reset_partially_mapped(folio);
>  
>  		if (mapping) {
>  			int nr = folio_nr_pages(folio);
> @@ -4516,11 +4529,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  	memcg = folio_memcg(folio);
>  	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
>  	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
> -		if (folio_test_partially_mapped(folio)) {
> -			folio_clear_partially_mapped(folio);
> -			mod_mthp_stat(folio_order(folio),
> -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -		}
> +		folio_reset_partially_mapped(folio);
>  		unqueued = true;
>  	}
>  	list_lru_unlock_irqrestore(lru, &flags);
> 
> base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4


Makes sense

Acked-by: Balbir Singh <balbirs@nvidia.com>

