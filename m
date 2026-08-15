Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF715C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8BA6B076E; Fri, 14 Aug 2026 22:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59A56B076F; Fri, 14 Aug 2026 22:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920796B0770; Fri, 14 Aug 2026 22:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 523FC6B076E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:19:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFEF0402BC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:19:21 +0000 (UTC)
X-FDA: 85101896922.23.03C8ABD
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id EE6F140003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:19:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UnmxaW+2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786760359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPZ+zXV9/I0usV1GPyjP/cQ0Xgf0HbZYpwz771U1Cbg=;
	b=7TxeDw7al8Q90NxwAeVJee1y6wm6t8/LzdtHy2y5/JDynt8Z69qGFYaWKs9V3Xp+cgN6ay
	Z57Q6qv2SQIMAH1EWvoTjq9MBzJhJGmCzYDjuFWFXj2aNAsY4++OPub+RthbUgPgkC/zeC
	Ldhp7b24FShC490BCuiI04ktbKuuTVA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UnmxaW+2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786760359;
	b=rgUyTJayvuS3I4AwIT7DIJR1Km5LZKcHJzr1NrXSx/5HNoeUtsuVmXNL9w/Or2wm0ClEs7
	FUNqBrvBkD5/HOI9Zlv1mhDTIaZNVlnZvZxtE7ZGxiNC2aUgtGPxZcIPSENTkl0sYKaZ37
	6aa0GqfvcaZwQGMwwZ9uz9vUMOWr1Es=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h0a0nV6pTGtVWVtcnnDNR+2MbzexYfUu/OBvzqHF/ZE9Aeud8TjYoGWYV1MmAdxMgY8Gk9ujUHBTTfc+wgMeQ2X2ApUex0D1POQMoOLkw0+jq8+FydttFMqArcpmm7B94Y130aXAvR7PC+9DCOVIyyHXwnwDvKdCHYje+sR7gMgn+WIYcgYXnpnU3TrpU2vBCemgftpC89imz7N7JmNwxgmkiuIi3jsm6gK0+y8UmoKcNGL+GZ7Kkor0utcMDYypXXk5r3b4gYqhs83F1XNz8zvK0v31N29Bc1ltHWCy9smnSzBGzDkV8X5LKx7qg+z4rtdV//7y/TkjRG/vASkQPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPZ+zXV9/I0usV1GPyjP/cQ0Xgf0HbZYpwz771U1Cbg=;
 b=CYYd1vg52AAto04zlNxqioj4sXL1HNFpv61NxNjhylIAoe+ACH1SaG4Anmv/q67vN4nmYmZEiFBAVJ2uo38GHlJlTqlHBI0oT1li2wN+nx1GaOS4r1u58FV4yCDWFvRTBABkewdm9buAbJFrNhwN9gDuE4hnGenI//9iiZbpxbNyYZkaQLN9bqORqtMl//YxR6/9a0zH5UR7/uL9PeXQBAIM07wdhVLoXp+WuF6cpoRRadgvCWQqHlB+O7CFYndQKMO0+/BY/VcgXSk0rHCwYQumP4QEu4PPwR+sLeuo1NWM4ShbKtpnecrwj94OWncHKlGS3C3nV05oVH0VD+1p/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPZ+zXV9/I0usV1GPyjP/cQ0Xgf0HbZYpwz771U1Cbg=;
 b=UnmxaW+2GeP2DHztsdv4zWfsJV0NCiLIaBmGK8wi/gZrBr6D8iJpLyQR1wQhr5Pxh8w945M6h8yFMpOKeLuFq5opMSB3xFCpSKSLL3R4JtaCKln5tpMGh0l/cdi94XZ5S0wYQTYjVKO2/jT4JGM6XNn714yoMTnHQOUHRoTtDkno4Q73BdEjProgCWG2+C05FUjETGjduIKde3WhVIHt0ZG8oij+/oZRwNLxSpeU3YI4LPPXNFQvRgQ1d3vrdJKRMWtBF1/2c3kTqdBQvZH9scyYu8WXPCxAnk4hi2o7YtQsm60tV0B30xFuXyXL7zTdLxh0gqZyr0rL7PoSpyTbRA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8880.namprd12.prod.outlook.com (2603:10b6:610:17b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Sat, 15 Aug
 2026 02:19:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Sat, 15 Aug 2026
 02:19:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 22:19:10 -0400
Message-Id: <DKP5OL93OG64.3DAD063ZKEA9O@nvidia.com>
Subject: Re: fixing sashiko failure to apply (was Re: [PATCH v5 00/16]
 mm/rmap: index MAP_PRIVATE file-backed folios by anonymous pgoff)
Cc: "Matthew Brost" <matthew.brost@intel.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <an7ewWbMwN20xklN@lucifer>
 <F700B4F3-2068-4DFD-975A-6324DAAB384F@linux.dev> <an9FhK3wSJHkEi3j@lucifer>
In-Reply-To: <an9FhK3wSJHkEi3j@lucifer>
X-ClientProxiedBy: YQZPR01CA0111.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8880:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e0f11a5-8fb8-4701-b5cc-08defa73983f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|11063799006|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZX1aw5b8C2pe0nACT8sDTkU4jnUBDgYNJ2YesnoQdUBzUNKkGS1POXp6CcRtAX61vcciAmxEQE/ul7HvCBP0KZ+gXdxK7/+s7H7d4PzLwtHN0JHT8fQXeWYXgZ+c4d5/EnEhTPyK9HTEZ2ZaMV1aB4tj2jGUjis6RwSVlxt8y30y/1wZ80KqjHgCX4OLCNIrOzag9zSoHsK10/aR0ceZrMSBkwrwGW8jcyP8j9ILHS6tta8GIIOrFs1NlMbYc6+tEW8U20A9Tbbx9yiHFxUF+AA8LpPdbY7tSP7hXBR7flTj+Fj+6eTcYsTjDuFHjh92/dAS26jSdC0Cu+1CqM3qwllQ0AEW5mkzh7YHDy9quEwYP5jLRdv2aCaIDtRt1d/4hWg4uwXt2RYiDtUC93EB16mwIFyohcMxd5nmBrJ0Dgke4jd/o3uPopg2Co2q60cYQpp2KoYfqj5t64qRdOPN+otJEAhLQuyvpKSzeWlY7FZvOFPNtyPZJEbIaWLKtlJE6/isdr1jt0LKO7lVfZm8TmyaVVKT1mqbLnn9usKUTzR5c7REVbsf8/OfO8+rTNvWLLlBb6tPtUcKiIYzKoeyk1DIicCeRCHDTBcJscwMjQb+n3b7XgfdK4hzhcEaG4Vqu7yPHLogRJU3PUtwfn5dHH771Np+62P2hDI0/dsHZWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(11063799006)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGJsSGhIazdqb21PQVptWmxzczc1eDJGWGJzdm1yN2ZGU1Jsa3NUK202V0JY?=
 =?utf-8?B?QVhDMUJFZ21aWVoxY00veDluQ2lmNlFNcjJ6Z1Q0STYraVF3YVUwdUd2MGlN?=
 =?utf-8?B?SUJ5WUZXT2J4MXhTSjVGbitlQU55cjhNTkhaNnNWeEZ4c0J2S2UvdEZNYTJy?=
 =?utf-8?B?aGk5RlFWeHkyeEd4QkNTZzk2K21vSGdMM3ZNTlFFOUR6bUhaNTliSkVlTUN1?=
 =?utf-8?B?TDRPNlhlOHhlUWZ3TmZuT0FnZ1F3eFVucWdzbGZicFJBZ3NIZk4vREc2bHI2?=
 =?utf-8?B?V2RKbG1GYUdSSUpOVTlJVDNQc0ptUHoyZVRXTkIrVFJBT1BYaGlyK0ZhbU03?=
 =?utf-8?B?NURlNlJMYjBBR0dDYXpaTldBK3dlMTdtVG9QZHdwN3RVNGlGalNZS0ZvTFpl?=
 =?utf-8?B?RlpwYlo4TkhRY3BHczBYRjFsV0s1ZDg2V2htc2Zha00rdTBQMTZ3WFUzd2Nk?=
 =?utf-8?B?Z3FtWmQycXNwZ3Z5eTZLL1BYbzlldXJJa0xUWEJVRFFnWXBYWUtjL1hnYWlW?=
 =?utf-8?B?UTFCK3RKd2l5dWlvVUw3dlhtQTZDTUNqcjNWeitsOGdxb1pqSmFJSXh3cUJ2?=
 =?utf-8?B?amltRUU2djR0bHFodEZtMG1oQWtWS0VkTUVnL2ZjZElQMG9LRitzTSt4cjMw?=
 =?utf-8?B?QjQ0ajZDbWlwRVplR0tHdWxWSGlCVFF1VmxMVEdBTmdicEZ6SjhkUW1nVEVl?=
 =?utf-8?B?enBkSmRiaGdWU3lHVldEUTNFaDNXQXNvcmcrVkE1bUQvNnZaM0RPL0hDakdS?=
 =?utf-8?B?WkEvb0dKYllabUJYNndvRWF1M2ZzTTRNSnI4VVBvenk3bFdDanRjR081cUlq?=
 =?utf-8?B?dkJWQ0RRQ2dVOFhYYThYOUtQSmRIbnQ4cDcxSkVCTEpnODVibGZwUmNhbGJL?=
 =?utf-8?B?ODFtQkV4QVpmaUpuU0xRVHZYcGNCZ3VZbnhTbWE5WE5yaW9zN25hTTJhNW9o?=
 =?utf-8?B?ZHl3N2xIaTFMVEYvcGVIcWNBKzhRK2M1RHlWUUtJTUM4Um1nSUxyeXhlTGFG?=
 =?utf-8?B?ekNsM0s2Q3JicU9HeFdqK3pkV3k0VFFUdytjaFdOUGpNbzUrSjB5dkFxdnVO?=
 =?utf-8?B?S09SV2x4c2tzYTg3c2hNNE1ZZFJ5ZFZjZTBJVC8xNW1MNmVMMFJERk9uLytB?=
 =?utf-8?B?OVpoN1BnNjI3OGdqcVprWFlKek5lMm43NnZyRGZiYVFMTFl2Szl1TzF3K1pR?=
 =?utf-8?B?aXZTS2tHUGlaTXFvcE5pcjVYd3lSaHBzZnBTdkYxWkI4SW1xcEIwVWd4RnEz?=
 =?utf-8?B?MDJnSmwxb0NrcVlDM01sNEJER085eE9CUTNoQVFKbzBLbFVFb2k1SWxvVFg3?=
 =?utf-8?B?eE0wT1p4RHpNS1hIL2tteGhmTUY0MDVMUEJlN2ZTdDlFejVnN1hwdFcxQVZH?=
 =?utf-8?B?WFpFZjV6bmNPUmR2VzJ4ZnY1a1lROGNVaVRrK29pNGNpMnpwUlFoSkJrL1dZ?=
 =?utf-8?B?RW1rY3dDSDRnYUR2NEpNdmZpYmhGbktkS1dXTDVxcm0vVS8yRkpJRnhVSHpH?=
 =?utf-8?B?clJvOWhxMGNhdUV4SGVjUTBzMjhpZDlGNXJSS2N1bzc3NWw0Q25zdU5LUDhG?=
 =?utf-8?B?QmxteUpUMjVqM0hTdzNrMzBXMkdCajBvNjJvOFRhZVpzdzZFZHJ5NEE2Vlh0?=
 =?utf-8?B?cEZ1K09rQTZOOUE5NFh6dGVnUFM2TEx0U2dXbzNka29SaE5jRVZyQnVVWjFK?=
 =?utf-8?B?YkVQcENBckl3bXF1SGgvaUV3ZUNtTFYyYnRoSjhpenBhZ0psdVoxWnZFK2ZK?=
 =?utf-8?B?Y3NjWEZRUmc1MkVuNnVJRlFHVDU4U1R0dGswNklWSUZKdWd2TzRCRXlKSFBY?=
 =?utf-8?B?R1NITGgvaGVWVzBlOE4yajdqSjNZSFBieVNlMGsxa29TSFhkUVY4cUh6TnpB?=
 =?utf-8?B?YzhOSGFxRlpjQ0dVY1o3OXBJaUE2OFdJeDN2WXk2TXlJVWsvQlRxL1dIVEdU?=
 =?utf-8?B?V0FBY1ZyK01QQTV0cHBDWUs3eUNnMzdMQXVrUkhWTXlKUjU0Yk5veTJXNHRt?=
 =?utf-8?B?K0M4UkpIZFRJMVNtcm1relMvSGF4ZVREVkdmQmsyZWJ4Mk44R1E4WERUY3dx?=
 =?utf-8?B?Z1daS0s4bEdIa0xPcDdlRVNjb0Uxem5rYzBuOVNBNldWN2JMcjNYeHRtak1S?=
 =?utf-8?B?dmp1N3g0blo2WDNHbWJNcmg4ZUFCRS84Ulc0b0I1bGQzTjZ4S2krcnFMOVFF?=
 =?utf-8?B?enR0NC9pZVdLUXlNOTJ5L05Ba3paVnZTd2NHZzduY2xhT3E2UTBBYXVXTGlr?=
 =?utf-8?B?dG5tNzB5UjZha1VrWVVtZFdXdEprN24xWDdYZTBFdCtYa3JFN1IvRmhrUTVk?=
 =?utf-8?Q?IDOYEfKBvPEAusMdeM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0f11a5-8fb8-4701-b5cc-08defa73983f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2026 02:19:11.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwFqGsxo2u4F0IdggN0OUzVloNKvWA4JEJAKv9UFAIBLaNZXFWIaUGyn2HNeH2kk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8880
X-Stat-Signature: e6o4oukz3bogeoxcsbedw3pus9xbhmow
X-Rspamd-Queue-Id: EE6F140003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786760358-72525
X-HE-Meta: U2FsdGVkX199s/lRwaPWexos/uTxzT3svJpcaqL+LaBayplAb6HRErPqOJbzcCXXOv1H8JBrCURblqe0FaT/qrMfIMv+6jqJGm+ZG/R4KogizAR0CAFqbxY6608fmHWSUlifZdWpiFRRs3RZmK+gNwDDy2JLZuJiryEdmThLiyn39p3UhJZVFI3Tn4qJHFn7nvsPwMl5wqP3LSYCfUk05URCm0bkBsbtbffovva6KzG4qzAmGGEC/ZCFuK8Ppikf8URvfXL8wC9fovhMsOWizQWvp23tW82IyUvE3qREd4zOc73WIwpmR1vZKpDtf6HQ6H5pVOD2VB07t6hvTXupRb5KDbvLSPQxWxVQi0U5X3+5aBA3ceI7rw/M2nhcUafE+BmFSrpy9DQ0ojSWb4GQmWs8BPno7Fe8UZX1R41AdnDVnzMLSdPEUnzu0wIVZdXFIplJm3PPN87KuaKO11SQYoTAiL3o1nOHP9+xTtAB6IFZ2hLE50bYztslpLMN6rtFAPGJo/HIibHXVBNSmzstT0ohf5zUgvXtdFnBwAnZ5NcbDYnv0Jviscv9qUK0MtMnfsJFuwMGR3uPddAjzprP71eE5knuFByDtGcYa5HJy6Pskr/YFC6UH5IPuNCsSKzGoTCpcw/9874dX1VGM+k4KChESVJkKFRiCkO3Z8+P8uCKTVdtgAkanREq3Q6vpHH+/fu9sybMKpDvb9Gyf5gXPDMwm3Gci4JMx/u7pTkwDn4t2V+LesL0XYqdHh4Ctk9+jyecQ0zQfPP6Lq2/sMHJHwRGZ1HK1TYxmGGotHLe4h8laUlGuCoN9lFXYJFFzR4gE/HUIdJhQhlJHx3GrB4UgCbJKUtAHE2DINR9XC5ClZhm1O20HwYf+bNq2RjgYOzZxJd/qcCQLWXtZt/7MZItQJ1O39l0IfHFTt5ow28RgDB1E7/Hqm4FqoFvmVkzw0FMPPNqfBHWFzEWfadaU1c
 +2fsMjjr
 0D0ck0kDIwlzygT0dIX3YDmZChy43qv43/BSW8LpfnaYhpf2i4Um7JgiqEYJqHE7uZYH70tymZNYH5Jpx4KpjUqYF8pHKs4vPx2GxbY5k1IWoMz4st5PzL9DNBx+yhhg4RqnnsV4wrgmrhH4jRQmcgtvCHV/c4PU0wMamIqivMoITRpZ4WOki3AEjo+rMLe/qRG3pZZgaKOyIFrNPuPvBgJkdkX9x+1T19j0ywBKyhzY62HfxRYYElkV5RHUwf7WSAPQALLHX8GcYlzVSfCptVJdcObUbisYSmrDNWeFORVwmNpZ32YTfQC1+chDarpnF84OX3yHLFQ1AE+qFWe8cqrMd66RUI07nxkyQWvy+em+gomzN1AXFhB8ILEKPwbSgjVmO4a35forCyeXDHlVFqa4CWJrXXKna+psOTFmHDXBN1vQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<snip>
>> >>
>> >>>>
>> >>>> Sashiko can be guided with a base-commit: tag but I'm not sure how =
to
>> >>>> tell it what tree/branch to try, or even if that's necessary.  Perh=
aps
>> >>>> someone can figure this out sometime.
>> >>>
>> >>> b4 gives a base commit, but I think because the trees are rebased it=
 ends
>> >>> up being the incorrect one.
>> >>>
>> >>> Not sure what the solution is!
>> >>>
>> >>
>> >> We have seen this on the Xe list (our list is based on drm-tip),
>> >> typically with cross-subsystem patches. Some cross-subsystem patches
>> >> apply and run correctly, while others do not but public CI flows run
>> >> based on drm-tip. I do not have a bisect or a clear understanding of
>> >> what works and what doesn't, but I think it would be very useful if t=
he
>> >> community could better understand the root cause.
>> >
>> > As Mike said, mm-unstable/mm-new is heavily rebased and also carries t=
he old
>> > version of the series before the new one is applied, so it's super unc=
lear what
>> > the base commit should be there.
>> >
>> > But in general, I wonder if it's possible that we could tell sashiko
>> > after-the-fact what base commit to look at once the series is in, or r=
e-trigger
>> > it somehow once it's in-tree?
>> >
>> > Roman - any suggestions on what we could do to help sashiko find thing=
s?
>> >
>> > (Once mm-next is in place everything with change again, but can addres=
s that
>> > then :)
>>
>> I can implement any reasonable logic here, the problem is that my unders=
tanding is
>> the current mm process is a bit vague here. Which likely will be also an=
 issue for the mm ci.
>> I=E2=80=99ll merge a support for b4-like dependencies specification soon=
.
>
> Yeah I suspect things might be tricky with mm given the rebases honestly.
>
>>
>> Re re-starting with manual selection it=E2=80=99s on my todo list, but m=
aybe a bit lfurther away, as it requires
>> an authorization, etc.
>
> Yeah that's the fly in the ointment I guess for many things like giving i=
nstant
> feedback on accuracy, well you want to make sure the person giving it is =
who you
> think they are :)
>
> Probably an email -> author with magic link or something but thinking thr=
ough
> how to avoid abuse/spam/rate limiting everything etc. is surely all a pai=
n :)

If b4 is used, the cover letter comes with a fixed change-id. That can
be a good id for new patch series replacement. For patches do not use
b4, authors can add their own change-id. Without change-id, if the new
version comes with a link to the prior version, that can be helpful too.
If none is present, author email + patch title might be the last resort.
But I think we need to encourage authors to provide some id for their
patches to make replacement easier instead of spending too much effort
on identifying different patch versions.

--=20
Best Regards,
Yan, Zi


