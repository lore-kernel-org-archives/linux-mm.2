Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E81CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6C58E0005; Tue, 16 Sep 2025 17:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2977F8E0001; Tue, 16 Sep 2025 17:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138198E0005; Tue, 16 Sep 2025 17:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDEFA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:38:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 802F31DE279
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:38:08 +0000 (UTC)
X-FDA: 83896426656.13.1D578DA
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021072.outbound.protection.outlook.com [40.93.194.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id B016A80009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:38:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="vk3NMri/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.194.72 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758058685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orBFuXH7gjcPJ1rKlnogQfDJ8juaaigawOjQzApBHLE=;
	b=lS4AACpOB4hrbDl1dH8go6EKJMYM3pxkg5xmjmf6hZGCZF0loVqnxed1hghmpzHgzj1xwN
	y1m/FEY6qZ6DoaGcKWBTISwgb6hj8z0pBcJ0EZYjE5P+IAuIlcXaTL6OUYi6HDaeu/dvGS
	7cvNAawahn5eMV5fqdsKrRzmgTnpryg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758058685; a=rsa-sha256;
	cv=pass;
	b=R0n3clUwpORMKXO/6hQ1bSB1GFAahFnBPD6lcX+pAuEXB2L5MvKAhan9StDEasMjrARc8c
	ga9ISD0dw9lFdemwv9qC7waDONuCvu9VT1nENcSb8pTOsVjd6CxwJib8ldEarXq5zx2mz3
	Xtb/sNhdG/YpcWA2TA71+FM+TiXcpco=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b="vk3NMri/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.194.72 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IND/fVtlJjp3hjlNyp3RsCKw9/L+nuUiNxFJRnQvMYef+pJ5Vz8Pw0E8deOWsIQcRgajPUi84PftoaulxKRIgIgDYSQ6BSS9Mc6OZXxMO0aOjR4HRR5UUgJC5sDecap3Q7zaRG6tDW3DY8K+Z392fyFlKVVmNEWOvTHHwl6KbEsYXBOmFCOo74gSU+6evceTvheCFknJgdziG7BoNSzT8VRRURBQ1Rk8iQoQtnylwPhLQpYVvMKgolF336cGPG2YKzfb8a8VJQgjpT+lwwGbXhj3hY8zvHx3s2DSkCsIMZyWAwhJlL2pgRRGbbapZlGH5lGq9/luSmOE7ajn+O058w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orBFuXH7gjcPJ1rKlnogQfDJ8juaaigawOjQzApBHLE=;
 b=f7GdtMhp6KtnCnkRK0VR0e4lrVTb2kxLbAB45ZQyXMD6RjaLJtlQwJ11zhcXAfUjzd050QCL55W1mGLcq/RkHXm3OA21prEdLMT/sZVzlQjnlxjFtqsE8WGqGcUoJYIlTULRPXN1BpfoLp1yCnqbmr663g0p82vBFLmKlWY0sYlhooYBFZxMH2vx1uc+s00glyn6FqQBI+r0oFzUaNBatkmwvsOg1Jcg8nZnU1aKOLZaPvJMykRUShWOamSfoJclt9WFbPJOET6CHklxwEmWcGyZ5fEaXKbSmua4xzW0afmgqEhAd+KJ8tT1zcsYN5XELX4yz3ZCTZt2VjEpioAvZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orBFuXH7gjcPJ1rKlnogQfDJ8juaaigawOjQzApBHLE=;
 b=vk3NMri/jj8SjBOjYofxHdkn+09jiPANHCqOTqt/bEOb98LTW0id9mnc1c+0WNyaZsdJaEjmky+p22NVRJ4nTM6nkiMM6ZtwxG4YMY+mdCps5/vdgeK1Q93VLmyRoQaieQgJAC+zVOc+HEDajpeuIMl8gHGtobc2Lw4h0oxzPWE=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CO1PR01MB6616.prod.exchangelabs.com (2603:10b6:303:da::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.22; Tue, 16 Sep 2025 21:38:01 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 21:38:01 +0000
Message-ID: <0eef7406-ad95-490c-b69f-e37f3f9e0a8a@os.amperecomputing.com>
Date: Tue, 16 Sep 2025 14:37:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] arm64: Enable permission change on arm64 kernel
 block mappings
To: Ryan Roberts <ryan.roberts@arm.com>, Jinjiang Tu <tujinjiang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-2-ryan.roberts@arm.com>
 <7705c29b-4f08-4b56-aab3-024795ee9124@huawei.com>
 <42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <42b3b394-a6ec-4d70-b5a1-941a0628cd25@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY8PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:930:48::7) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CO1PR01MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: 57188e53-7882-48a5-f508-08ddf5694f90
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vm1DRHFheXRiSFlhZVVwY0djWTJ6OERkNkwzVmFUOFB6M0lsNVVvSlVydGdh?=
 =?utf-8?B?L2EvZXh0NTUvc1FzM2ZnWUl2ZTFYOStlOExyaTVBOXNsb1czdVk5VmFZRms1?=
 =?utf-8?B?Qzg4Y1ZsZ0JTdWJyd0F4d0J2eTJQMGE5QVc3Sllyb1Q3ZkZ6RStrV0oxcDNR?=
 =?utf-8?B?RFJMRGNZYjc0MVExbEp2R2s2ZC9yYkxUM1llampOQnJab3ozOGloQmd0bDJM?=
 =?utf-8?B?NDNOaFAvbE4yTDZBRU4waXM3aUdyMjZTSHZYR01CRk8yOFcxWUhXWUdiK0s0?=
 =?utf-8?B?VVlNNFgyL3lLQjNRWGJmODhKRmF6Vy8zNGgvNElXQlFNVVpZT2lZZVJESVdz?=
 =?utf-8?B?NXpQaTNpenVCTm9aR2p2MG1QR2gzSkdKQjJaMmNSY1ViWE4rTmtOd1FmdUlQ?=
 =?utf-8?B?ZFdGQzhtWHlVa0lNNHhnRm9pWFRUVHIvc2cvbHRML3piU3pycG5TMUpDUEFC?=
 =?utf-8?B?RitQOWxmb0NmSEgyUWdwemduM2RwdHJETlY0amVmUmNXTkgzQks1TExsclJK?=
 =?utf-8?B?bVJna1lFQ3JoMG1TbERuclBLV2ZOb0I1MDdwR29NZjRHcWxFeGh4a3J2dnBE?=
 =?utf-8?B?KzZnaU53Rk0yTzFYTUtUODJxV2tqVzZKeXYzQi94KzUvLzdNTi9YdVIydjFX?=
 =?utf-8?B?NytmL0J3N2ZiVzJCRFI4UzR2SGttbk9ySWRHYmVuTTZqdG04MGhZRUphRWFv?=
 =?utf-8?B?UlRxYUlvcWk5MEZRUllFckg0SDU3blR6VDV0bm5MTjZBNERPYWxObGV6d2tG?=
 =?utf-8?B?WU5QcmJHdGZISEhyM0pmd3VkaisyR1R3S0gyQS91L1V5Y3RSaldVTTdTSkpw?=
 =?utf-8?B?SVhtYkpodTk4YnZrcTd2TWlsb2FqUldyNWdFZzFFOEZnd3RxZFlFTnBhTy9t?=
 =?utf-8?B?cXBaNHV5SjZzaXF2aXJycUtiNU12TGhyRlNhOTRLSVFrZDhNKzFmT0lTcGVh?=
 =?utf-8?B?U0lnbUdnVnVjaVlqcTA4VVROL0Vwd01vdkRZRzIwSlhKcy9DVzhvUVJPR1dr?=
 =?utf-8?B?bWZyVmU1UnEwcmRCbW41Rnpad1NkOVg2dlBrc2Y5QXloc0VQc29KRXIxcWJj?=
 =?utf-8?B?enU0R3dCZTFncWtrYkt3R3Z0Q2FXaUV2Q3hDWnVJQzRGYWdFdHJMOVlmNjR2?=
 =?utf-8?B?SU43K3hVL0N0Qk8wazFObVpOSnllVUdrZmhuK2VPUU8xZW0zeXljWlJJdWE2?=
 =?utf-8?B?U0d1OTJrV21wckxXNmhiRy9EMGxTM3lJcDVWZ2lxckMrNzhrVmR6emhaTHFD?=
 =?utf-8?B?dkh6Ym5aTWRzb20xVGJDOWlsVmRBZjlpcUorV3BFelBvemZCM1lLUmlLYjJE?=
 =?utf-8?B?ZG5OQy9mKzNGbUN5Z3MxcE5FWGxGMEZGemk5RHBPdk5IT1FRUFd5QzhwYzlp?=
 =?utf-8?B?WlNoaEd2YllBZGJneDdaZXNraWZTWHlmZEV3dTYyZzJSY2IrdVlqd0pianIz?=
 =?utf-8?B?Y0lHYXMzcnlvSHF1a29iS1lHTVpBejAvcS9PQjVmNFdxejBheTNnSmZISmJa?=
 =?utf-8?B?NUtyMnhJaEVtZ0IyTFh2Q28reExrOVloelZIWWdCaitFTm9XS241aGU3NDFY?=
 =?utf-8?B?d1dOOSt2OG1KeHFUcHdNc1RJbzA1ODR3WG4zRWx2cFQraGVJcEM3eUVGSi93?=
 =?utf-8?B?MWRvckV2SFR0UHNuMklpWDNYdllSVk9PNXFuRW50Q2p4L2JiL2pHK241RFps?=
 =?utf-8?B?dis0cVVsbG1ES0szelBJQmd6Uk1ZeFVNc1l4bS9jK1ZhL3M4RWhVTHp3RTNQ?=
 =?utf-8?B?NnZuMi8rNHl3UEdxeTFtZVpha2tHVGIrZUdqa1kwRkxndFljWlpKSXJmbXpM?=
 =?utf-8?B?dnE2S2ErUFlQOXpHNGs2RmhnNHV1YjlraFk5U1pOVEQ1ZENNY2YzVmNuYmcz?=
 =?utf-8?B?UWViUVpiWGZpK3Nra3BIRnhNcU9LbU1zcy9JNEJ3UG5VL1V6YzY2V0wzcDVU?=
 =?utf-8?B?L1p1dmpITEN1Ri8yQkJVcitrZ09lQTROanFvcXc2VTVPbW55d2dGMFJjSFpI?=
 =?utf-8?B?eW1CTk5teUhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YllaZjVybXlkU0xDVnc5aFhUWU5FdXlIVEFaNzA5d1FPQkp0WkFVU1g3eGw5?=
 =?utf-8?B?dHRGZkZtTjlKc3NSUjEvU3Y0UitQczVoWUN4YUVYc0NXTzBCUGtXK0dLRFF1?=
 =?utf-8?B?amp1bmhMblhrTVdzYkZSR1E1cDZneDB6c2FOT0Z1QTVGTDZ5MlVzOHgvZlRG?=
 =?utf-8?B?akJYbFdMK05vbGVnMEMxbHB5SGthTzJvbFg4QVErL2podUErSzNFU0JGUUtB?=
 =?utf-8?B?Yjd1WmljMVBaSkJHZkxYYitNakYrbUtlZXFIbHl2VVBsenB0aUdBeDFVd283?=
 =?utf-8?B?YitwczA0LzNTSTlWL1lOTlZEL2ljWWhab2p0d210UWxnU05MMXFMTEtLSzRM?=
 =?utf-8?B?ZVNZdTR4d2orT0tpNGVUNFNxVVZOcHZ1OVRxSkdYZTBDdzl4eGF5OGlpazhm?=
 =?utf-8?B?dzhZWWpzWkpUZ21zKzh1T25icCtrQTRwa0pZaXFTKzd3c1U4SkZGbGdQeVk0?=
 =?utf-8?B?bUJmQnEvbkRnTkQ2R0oxUVhXZys3Y0Q5WkJxZnJXQXcvQmFGTlhRcldRakN5?=
 =?utf-8?B?Qm1aYUR1N2tDUm5YMGFQdkx5WVRmN0RNR0NWeDlaZGE1T1JlYlkzQjdtMWRu?=
 =?utf-8?B?TEJ0S2p6L294V3lRNjNuU1V0bzZkQTkxMzBzUnY1WlJLbzZBUVR2N2ZCTTdI?=
 =?utf-8?B?VGdOWDVwSnp4RlUyVllLbFQ3U1Nqa1JBbXpNbklnMzEyQnlSclgwZ3BCWFZw?=
 =?utf-8?B?eFYzVThpeVhFRFlscW9hdk5NNVFiY2lQT0lYcnhGVTVQRzBCcU81UWIyOUlB?=
 =?utf-8?B?Qm1FbE00S2owNUhrc2xUNTJ4WGV4U29ZV0lhMnhtc1djL2VEUU9iTnU2ajR4?=
 =?utf-8?B?SWtMMW41cy9RUFl5emtnTkFlZ1ZGeThQNmoxdzZaYnZHMmVBa2Y3RGpmNDV4?=
 =?utf-8?B?Njd0c1hJd1pLcHp2UmEveVU4RXl0Y3hKQnRnRTA4a2IxV2ErYURKRGozSHlJ?=
 =?utf-8?B?QXZsTWt6ZHJZL3dnOXJsWk5hYVNQN3g5eldKd2hjcnZ6Z08vTVp2VngrRldq?=
 =?utf-8?B?VE9jNWV0MjVURmFhZmJQT2RDMURobEFQZkF6VmNyUVdDcDk2d2lXcmVsdWpm?=
 =?utf-8?B?QmFpbTFGcXBSSEZ0cDkzWUxZNUs4NGJjWC9la3FvNVB4RUVrbjREOEp3Q29h?=
 =?utf-8?B?cEdydGZna3JXSzY4S0cycFNuZmtPSEpHQnA4Witjb3lKL2dBSmdEZWFSNFJ4?=
 =?utf-8?B?VzFmVVpBL3JhaFJ2WVJrK0ZZUzlnVUFla2pwdXZhUDkvNWVEVGlVSnRKOHRt?=
 =?utf-8?B?Q0dYb1M1cnArdC84OGZLNFk3THVHNFRJRjVGeFN3aXZXNnRwZ1FpS2d5a0xj?=
 =?utf-8?B?bDVTWXVwdUEySTkrQUxGWUNhZ1NXRk5VWlN0T09kZWhkMVRzUDkrQm1FcUd3?=
 =?utf-8?B?N1pWRW02eWg1dU1BbGVOZU1LaGVEODNrN3FQblVDdzZXb3MzTWZEb1FqNDBq?=
 =?utf-8?B?WC9rOCtHaVVWSVkxS3BSQVRZZldwNHVFY2RsZ3dISFhCVzhRS2ZNYlBXZGtB?=
 =?utf-8?B?KzJYL2Z6R29Gdjd6VitkSmR2Zi93bWhZcHFlbmVaYSt6UTI0UjRqOFhZdjhs?=
 =?utf-8?B?SUVSMm1NOUIvcjJiUEVqeXdsd3gvejc2dmhpVFJvY0tVdWw3WlJ1eFV2aHh0?=
 =?utf-8?B?MnIvUE1zWTloelYyUGVqRWM3R1Q1SFYwOXJnWUhRczlWZ21tVjBlWmhKNkhJ?=
 =?utf-8?B?RXUxYTBzQkRidDE2andxbm9pMk1kU0g1alJpeFhPSUJlU0N3SFpMdk5ORjRT?=
 =?utf-8?B?Tm9BSGtScDhYMDdVaHBTSDBlcUh3cXVRbkJOQks4bE9sSE1zR2U0ZDNqRHZ5?=
 =?utf-8?B?QVJWblo3L1RqdXAyVjB1T0tFdURtN3lJUzlFbDlzZDNTaHQ0eUM1NFRGZnUx?=
 =?utf-8?B?MDJNWkFxWXFLSEZHYUJYeG1WYmovMVpaemRJMktqamV3VkRlSU5qZXJWYjND?=
 =?utf-8?B?akpPWEF0aDVOTm5BS2RHYm40SGtyVDZwdzdxV3I1K1RHdnZrQkVQMHhXTXUr?=
 =?utf-8?B?SGRQR09KcEdxVmllRDUwZDdBbmd0SWhaOThBNGNoRTBnbW8wVzV2YU5iVlEy?=
 =?utf-8?B?OGdWSGszeWdJc29IOGpYVG8wVDJFR1UreUJFVjluSzZ2a3BNaVdLYlF1bzBk?=
 =?utf-8?B?NUEyekJwNkZET2JGNGZvNkZzNEM3R0hKcHlyUzZBWWdZbENFTFNFRGx1S2ZW?=
 =?utf-8?Q?zGrEOW0poVXHrVhhp/wj4ZI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57188e53-7882-48a5-f508-08ddf5694f90
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 21:38:01.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AODMBbITOUQpOcE4XwQPzGSysSolC47pbUUGifHvrA9O7A4JWayGOVQL7dCMSbuR/elfoJVddkGuQdUHdl9Ke4pOUq7GDXRGqdusbUJpLbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB6616
X-Stat-Signature: 1zw1d59hginxz1emwtjxxrk5rkf4qw39
X-Rspamd-Queue-Id: B016A80009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758058685-394449
X-HE-Meta: U2FsdGVkX18flPYS01WFknR39M6SPSoP4BmzcMpocolVFnaF/4DgpvlCXb2VSBJNd3LFqTG/5PlXTmrzV5baz5lz8qkk7BCrHvzTj/WOxnDtmLiLuFaDRw9mTsGFqu2OfB+qD7aMEFu/3wOaiFLOc6UwBUMjzJjvZ9pgX4D5M6Ge+1K/JH9zhjoq6I9vSoI2mNaZ5zgERSglOMNbW0NaD77szS9BxSPv91q1PFTU2FfgTCO6IeuoCZhJleUFbtdSoIjm0td/vS5elfVMD0cKmfBd6A9hV6/htBQsJ/Hh363VMC4/1UUMvzl3Gote4SR8/qQv2l0Bzo1nw5LH0+k0MJBuZY/Qr/Gxbyr7uCo7JL9CpVchBH3x08Ic3Q248t6JTeZfFdC+ZxF6RXTDbwIVmcBE5Ug72uDmwwc8LHR0jrdI0zo9xmlHpgbOhZSnT+DEKxoOYzWCl+VfsT7RnuMWVLEVEiKvMv/8wYOWSJ8cfUqhXUkSk8mwqKay1yNfQX+wvi2uH0SkPQOGcWZcJxw9JnLDlRRjjdfScaIwm0tAOE8W5Gc5nBM+vVzIEaCxyeNxIcasUiZk7cvkkFtZIe0YtK8slhnOo5EyKhRrA5CvxvkxlJouHM1tJ/A8Ze8E+RFsPJ8tDS73S3lbAOwzoSJ2jLRELWfYA5es6CjmdaTXS1v3Hf0BZy279acajNKiVHx22+VhpPKYDxE5Y565I397qz5x8YJNlkxmomVlQlVQ+RiDA6Q3zIwcjhexhsHwN1hKFmwo7rHrd4yFb4wVa3Ao2GjqVliOEsoMqjXtHOAg0w5qym8k45GN37yy7kpguV/TH4GTcVylGiTtif7xoT4I4t2zpOPv0Eb4/XMFY6IIjH3dWrChnjM53M+MTn4pN5XWnkh6OccdAyf4xmz4yAcaSVee25tEsE4NwYmXS5weuMKxL+MLZNQYOwfNIisVgnXKCLLsNPrGsNyu2H6bbxE
 GQBkc1Fh
 n9lWtCgQikkz5eMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/25 4:06 AM, Ryan Roberts wrote:
> On 04/09/2025 04:40, Jinjiang Tu wrote:
>> 在 2025/8/29 19:52, Ryan Roberts 写道:
>>> From: Dev Jain <dev.jain@arm.com>
>>>
>>> This patch paves the path to enable huge mappings in vmalloc space and
>>> linear map space by default on arm64. For this we must ensure that we
>>> can handle any permission games on the kernel (init_mm) pagetable.
>>> Previously, __change_memory_common() used apply_to_page_range() which
>>> does not support changing permissions for block mappings. We move away
>>> from this by using the pagewalk API, similar to what riscv does right
>>> now. It is the responsibility of the caller to ensure that the range
>>> over which permissions are being changed falls on leaf mapping
>>> boundaries. For systems with BBML2, this will be handled in future
>>> patches by dyanmically splitting the mappings when required.
>>>
>>> Unlike apply_to_page_range(), the pagewalk API currently enforces the
>>> init_mm.mmap_lock to be held. To avoid the unnecessary bottleneck of the
>>> mmap_lock for our usecase, this patch extends this generic API to be
>>> used locklessly, so as to retain the existing behaviour for changing
>>> permissions. Apart from this reason, it is noted at [1] that KFENCE can
>>> manipulate kernel pgtable entries during softirqs. It does this by
>>> calling set_memory_valid() -> __change_memory_common(). This being a
>>> non-sleepable context, we cannot take the init_mm mmap lock.
>>>
>>> Add comments to highlight the conditions under which we can use the
>>> lockless variant - no underlying VMA, and the user having exclusive
>>> control over the range, thus guaranteeing no concurrent access.
>>>
>>> We require that the start and end of a given range do not partially
>>> overlap block mappings, or cont mappings. Return -EINVAL in case a
>>> partial block mapping is detected in any of the PGD/P4D/PUD/PMD levels;
>>> add a corresponding comment in update_range_prot() to warn that
>>> eliminating such a condition is the responsibility of the caller.
>>>
>>> Note that, the pte level callback may change permissions for a whole
>>> contpte block, and that will be done one pte at a time, as opposed to an
>>> atomic operation for the block mappings. This is fine as any access will
>>> decode either the old or the new permission until the TLBI.
>>>
>>> apply_to_page_range() currently performs all pte level callbacks while
>>> in lazy mmu mode. Since arm64 can optimize performance by batching
>>> barriers when modifying kernel pgtables in lazy mmu mode, we would like
>>> to continue to benefit from this optimisation. Unfortunately
>>> walk_kernel_page_table_range() does not use lazy mmu mode. However,
>>> since the pagewalk framework is not allocating any memory, we can safely
>>> bracket the whole operation inside lazy mmu mode ourselves. Therefore,
>>> wrap the call to walk_kernel_page_table_range() with the lazy MMU
>>> helpers.
>>>
>>> Link: https://lore.kernel.org/linux-arm-kernel/89d0ad18-4772-4d8f-
>>> ae8a-7c48d26a927e@arm.com/ [1]
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>> ---
>>>   arch/arm64/mm/pageattr.c | 153 +++++++++++++++++++++++++++++++--------
>>>   include/linux/pagewalk.h |   3 +
>>>   mm/pagewalk.c            |  36 ++++++---
>>>   3 files changed, 149 insertions(+), 43 deletions(-)
>>>
>>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>>> index 04d4a8f676db..6da8cbc32f46 100644
>>> --- a/arch/arm64/mm/pageattr.c
>>> +++ b/arch/arm64/mm/pageattr.c
>>> @@ -8,6 +8,7 @@
>>>   #include <linux/mem_encrypt.h>
>>>   #include <linux/sched.h>
>>>   #include <linux/vmalloc.h>
>>> +#include <linux/pagewalk.h>
>>>   
>>>   #include <asm/cacheflush.h>
>>>   #include <asm/pgtable-prot.h>
>>> @@ -20,6 +21,99 @@ struct page_change_data {
>>>   	pgprot_t clear_mask;
>>>   };
>>>   
>>> +static ptdesc_t set_pageattr_masks(ptdesc_t val, struct mm_walk *walk)
>>> +{
>>> +	struct page_change_data *masks = walk->private;
>>> +
>>> +	val &= ~(pgprot_val(masks->clear_mask));
>>> +	val |= (pgprot_val(masks->set_mask));
>>> +
>>> +	return val;
>>> +}
>>> +
>>> +static int pageattr_pgd_entry(pgd_t *pgd, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pgd_t val = pgdp_get(pgd);
>>> +
>>> +	if (pgd_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != PGDIR_SIZE))
>>> +			return -EINVAL;
>>> +		val = __pgd(set_pageattr_masks(pgd_val(val), walk));
>>> +		set_pgd(pgd, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	p4d_t val = p4dp_get(p4d);
>>> +
>>> +	if (p4d_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != P4D_SIZE))
>>> +			return -EINVAL;
>>> +		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
>>> +		set_p4d(p4d, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pud_t val = pudp_get(pud);
>>> +
>>> +	if (pud_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != PUD_SIZE))
>>> +			return -EINVAL;
>>> +		val = __pud(set_pageattr_masks(pud_val(val), walk));
>>> +		set_pud(pud, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pmd_t val = pmdp_get(pmd);
>>> +
>>> +	if (pmd_leaf(val)) {
>>> +		if (WARN_ON_ONCE((next - addr) != PMD_SIZE))
>>> +			return -EINVAL;
>>> +		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
>>> +		set_pmd(pmd, val);
>>> +		walk->action = ACTION_CONTINUE;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>> #define pmd_leaf(pmd)        (pmd_present(pmd) && !pmd_table(pmd))
>> #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
>> #define pte_present(pte)	(pte_valid(pte) || pte_present_invalid(pte))
>>
>> When PTE_VALID is cleared, pmd_leaf() will return false. As a result, the
>> caller won't be able to set PTE_VALID for the pmd.
> Ouch - good spot!
>
> So this will break set_direct_map_default_noflush(), set_memory_valid() and
> __set_memory_enc_dec(). I wonder why it doesn't cause problems with mm selftests
> - I'll investigate.
>
> Anyway, I think the simplest solution is to replace the pmd_leaf()/pud_leaf()
> checks with !pmd_table()/!pud_table() checks. (and I think we can entirely
> remove the pgd and p4d callbacks because pgd_leaf() and p4d_leaf() always return
> false on arm64). As long as no code ever clears PTE_VALID from a table entry, I
> think this works.

Or we can use pmd_sect()/pud_sect().

Thanks,
Yang

>
> Thanks,
> Ryan
>
>>> +
>>> +static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
>>> +			      unsigned long next, struct mm_walk *walk)
>>> +{
>>> +	pte_t val = __ptep_get(pte);
>>> +
>>> +	val = __pte(set_pageattr_masks(pte_val(val), walk));
>>> +	__set_pte(pte, val);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct mm_walk_ops pageattr_ops = {
>>> +	.pgd_entry	= pageattr_pgd_entry,
>>> +	.p4d_entry	= pageattr_p4d_entry,
>>> +	.pud_entry	= pageattr_pud_entry,
>>> +	.pmd_entry	= pageattr_pmd_entry,
>>> +	.pte_entry	= pageattr_pte_entry,
>>> +};
>>> +
>>>   bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED);
>>>   
>>>   bool can_set_direct_map(void)
>>> @@ -37,32 +131,35 @@ bool can_set_direct_map(void)
>>>   		arm64_kfence_can_set_direct_map() || is_realm_world();
>>>   }
>>>   
>>> -static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
>>> +static int update_range_prot(unsigned long start, unsigned long size,
>>> +			     pgprot_t set_mask, pgprot_t clear_mask)
>>>   {
>>> -	struct page_change_data *cdata = data;
>>> -	pte_t pte = __ptep_get(ptep);
>>> +	struct page_change_data data;
>>> +	int ret;
>>>   
>>> -	pte = clear_pte_bit(pte, cdata->clear_mask);
>>> -	pte = set_pte_bit(pte, cdata->set_mask);
>>> +	data.set_mask = set_mask;
>>> +	data.clear_mask = clear_mask;
>>>   
>>> -	__set_pte(ptep, pte);
>>> -	return 0;
>>> +	arch_enter_lazy_mmu_mode();
>>> +
>>> +	/*
>>> +	 * The caller must ensure that the range we are operating on does not
>>> +	 * partially overlap a block mapping, or a cont mapping. Any such case
>>> +	 * must be eliminated by splitting the mapping.
>>> +	 */
>>> +	ret = walk_kernel_page_table_range_lockless(start, start + size,
>>> +						    &pageattr_ops, NULL, &data);
>>> +	arch_leave_lazy_mmu_mode();
>>> +
>>> +	return ret;
>>>   }
>>>   
>>> -/*
>>> - * This function assumes that the range is mapped with PAGE_SIZE pages.
>>> - */
>>>   static int __change_memory_common(unsigned long start, unsigned long size,
>>> -				pgprot_t set_mask, pgprot_t clear_mask)
>>> +				  pgprot_t set_mask, pgprot_t clear_mask)
>>>   {
>>> -	struct page_change_data data;
>>>   	int ret;
>>>   
>>> -	data.set_mask = set_mask;
>>> -	data.clear_mask = clear_mask;
>>> -
>>> -	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>>> -					&data);
>>> +	ret = update_range_prot(start, size, set_mask, clear_mask);
>>>   
>>>   	/*
>>>   	 * If the memory is being made valid without changing any other bits
>>> @@ -174,32 +271,26 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
>>>   
>>>   int set_direct_map_invalid_noflush(struct page *page)
>>>   {
>>> -	struct page_change_data data = {
>>> -		.set_mask = __pgprot(0),
>>> -		.clear_mask = __pgprot(PTE_VALID),
>>> -	};
>>> +	pgprot_t clear_mask = __pgprot(PTE_VALID);
>>> +	pgprot_t set_mask = __pgprot(0);
>>>   
>>>   	if (!can_set_direct_map())
>>>   		return 0;
>>>   
>>> -	return apply_to_page_range(&init_mm,
>>> -				   (unsigned long)page_address(page),
>>> -				   PAGE_SIZE, change_page_range, &data);
>>> +	return update_range_prot((unsigned long)page_address(page),
>>> +				 PAGE_SIZE, set_mask, clear_mask);
>>>   }
>>>   
>>>   int set_direct_map_default_noflush(struct page *page)
>>>   {
>>> -	struct page_change_data data = {
>>> -		.set_mask = __pgprot(PTE_VALID | PTE_WRITE),
>>> -		.clear_mask = __pgprot(PTE_RDONLY),
>>> -	};
>>> +	pgprot_t set_mask = __pgprot(PTE_VALID | PTE_WRITE);
>>> +	pgprot_t clear_mask = __pgprot(PTE_RDONLY);
>>>   
>>>   	if (!can_set_direct_map())
>>>   		return 0;
>>>   
>>> -	return apply_to_page_range(&init_mm,
>>> -				   (unsigned long)page_address(page),
>>> -				   PAGE_SIZE, change_page_range, &data);
>>> +	return update_range_prot((unsigned long)page_address(page),
>>> +				 PAGE_SIZE, set_mask, clear_mask);
>>>   }
>>>   
>>>   static int __set_memory_enc_dec(unsigned long addr,
>>> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
>>> index 682472c15495..88e18615dd72 100644
>>> --- a/include/linux/pagewalk.h
>>> +++ b/include/linux/pagewalk.h
>>> @@ -134,6 +134,9 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>>>   int walk_kernel_page_table_range(unsigned long start,
>>>   		unsigned long end, const struct mm_walk_ops *ops,
>>>   		pgd_t *pgd, void *private);
>>> +int walk_kernel_page_table_range_lockless(unsigned long start,
>>> +		unsigned long end, const struct mm_walk_ops *ops,
>>> +		pgd_t *pgd, void *private);
>>>   int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
>>>   			unsigned long end, const struct mm_walk_ops *ops,
>>>   			void *private);
>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>> index 648038247a8d..936689d8bcac 100644
>>> --- a/mm/pagewalk.c
>>> +++ b/mm/pagewalk.c
>>> @@ -606,10 +606,32 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>>>   int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>>>   		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
>>>   {
>>> -	struct mm_struct *mm = &init_mm;
>>> +	/*
>>> +	 * Kernel intermediate page tables are usually not freed, so the mmap
>>> +	 * read lock is sufficient. But there are some exceptions.
>>> +	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
>>> +	 * to prevent the intermediate kernel pages tables belonging to the
>>> +	 * specified address range from being freed. The caller should take
>>> +	 * other actions to prevent this race.
>>> +	 */
>>> +	mmap_assert_locked(&init_mm);
>>> +
>>> +	return walk_kernel_page_table_range_lockless(start, end, ops, pgd,
>>> +						     private);
>>> +}
>>> +
>>> +/*
>>> + * Use this function to walk the kernel page tables locklessly. It should be
>>> + * guaranteed that the caller has exclusive access over the range they are
>>> + * operating on - that there should be no concurrent access, for example,
>>> + * changing permissions for vmalloc objects.
>>> + */
>>> +int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
>>> +		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
>>> +{
>>>   	struct mm_walk walk = {
>>>   		.ops		= ops,
>>> -		.mm		= mm,
>>> +		.mm		= &init_mm,
>>>   		.pgd		= pgd,
>>>   		.private	= private,
>>>   		.no_vma		= true
>>> @@ -620,16 +642,6 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>>>   	if (!check_ops_valid(ops))
>>>   		return -EINVAL;
>>>   
>>> -	/*
>>> -	 * Kernel intermediate page tables are usually not freed, so the mmap
>>> -	 * read lock is sufficient. But there are some exceptions.
>>> -	 * E.g. memory hot-remove. In which case, the mmap lock is insufficient
>>> -	 * to prevent the intermediate kernel pages tables belonging to the
>>> -	 * specified address range from being freed. The caller should take
>>> -	 * other actions to prevent this race.
>>> -	 */
>>> -	mmap_assert_locked(mm);
>>> -
>>>   	return walk_pgd_range(start, end, &walk);
>>>   }
>>>   


