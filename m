Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A8CFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 23:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7C76B0088; Wed, 29 Apr 2026 19:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598776B008A; Wed, 29 Apr 2026 19:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45FE06B008C; Wed, 29 Apr 2026 19:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352556B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 19:03:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA394A0244
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:03:27 +0000 (UTC)
X-FDA: 84713121654.03.3B587BD
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021135.outbound.protection.outlook.com [40.93.194.135])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE929C0014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:03:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=Txret2kA;
	spf=pass (imf28.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.194.135 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777503805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AU+p0CcQfeRomrCedGmxP4NYMnsa6kbrYNsfrNE7U0Y=;
	b=jXswP8l+d7jCoNovW95ps/dGl4roNRQw5C2S5627kyF6h4H32xFemeAvGvnudOIB3nljbN
	a3tJ3MeKdbNOjTKUrk1oZLkpJ+I7XXGY9hanb/hWbsStpLhMC+AQEAnG9Qz7k3/E2n+qMl
	MjBUvBwlu0USn5jplSym3IgcTf68moE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777503805; a=rsa-sha256;
	cv=pass;
	b=ZDRQB+jp9l1Q9rKgq85uJGdyWx5jmIFpWR3U6tgZ+0KWtWB3j0gWb7hxSqBVjIqN2x5RWA
	BqoV+VCo88KT+rkc2n3Oqn3FbOERfljbYYopbdrbEM81/2oSUBd4mtmygJlXWhgpRKFBtw
	cb+mMgEUipFCUUCzM8MfCpiQAKkc1XY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=Txret2kA;
	spf=pass (imf28.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.194.135 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W5yBPzJkhQ4+4WDVsMeeKCKJgrXwuAl4+1u5l3sRNJJs6e+woltN7WyW9KSqKL9DbmTHjS5RvPRb9zMNBhBliCe4POfq7VOUUMO2NSqTsHsoFFEzHBFgnK3w8on3kHexV5hY8Wa0fNuXNJCDN6npKRlRpvJipqdOOGneXGQjBWlk+gg6C5kEt4XJjy3BSJPH6253pusTWrQvfSflOkPW6TLCZbmZFk8XhdjT3CHoHBvzvTI5oJsoIKz5kBblTCfjM6sJZxVVZht04IujNydOYRjKBtxapYXieAAjZ1VANvsyWPLf7/9Bo243vDrSLnj+LxYLaVVUxHK9yQwW2GVs7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AU+p0CcQfeRomrCedGmxP4NYMnsa6kbrYNsfrNE7U0Y=;
 b=kMP8iS/cLcMVVxEKrm4JfwoHQz/c9VBlJ7zGrc5Gm2nqz4ZSq3AoVZs3OYA64OXzHjQJqIpI2uwxrIC/wEbZudb6Fg58tytIgPQuSzBkV9v5p62RXEv0N6rQhhmwclQnLkNNBDQecuRQMkyBeioDm4J/TscnEZ7WyQl3ftl9zKCBYa/Sa0VfvMhm0G/2T7Y0OU6I6aC0g1Bdfz7TIVZUgcxtSApqFltb5PkISjBXnLMR9BSND6Oxoi+Dy2pT8FzaBJnWBeFRPEU/cRmyG3QS2KZ4q7kgjfnjIfbNygqrL2NTvoG4vowXKvZ1RyNu+Gcmr5AJQ5bmXPbHNkmTeT9xgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU+p0CcQfeRomrCedGmxP4NYMnsa6kbrYNsfrNE7U0Y=;
 b=Txret2kAAXl2vZTWQ0wtIgabtT+bbK4kQna5hX+QxbGk0qe6RBPqYswxtVF6NsxPC82jxntQfezdROI/JPjm925SlfMCfuZEw+BV6x5HGhS3KD58eBEByoNb/vP5zZ6hg2rD7m+h8g0UQDlL353hwb8WvTmkILStjE6628Fm90A=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 BN0PR01MB6847.prod.exchangelabs.com (2603:10b6:408:161::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.19; Wed, 29 Apr 2026 23:03:19 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 23:03:19 +0000
Message-ID: <25245541-0e8f-4ffd-b9d9-59e7ffabf37e@os.amperecomputing.com>
Date: Wed, 29 Apr 2026 16:03:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
To: Heiko Carstens <hca@linux.ibm.com>, Yang Shi <shy828301@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
 Tejun Heo <tj@kernel.org>, urezki@gmail.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <20260223095020.8139Bd5-hca@linux.ibm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20260223095020.8139Bd5-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0052.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::29) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|BN0PR01MB6847:EE_
X-MS-Office365-Filtering-Correlation-Id: 44225c6d-4865-495d-46db-08dea64380f4
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	SIzJOTQRb25xyTC+YJy0aFGqOoEaCqIhCg/9COK9nBZm3yGZac2+k3t1GbuJ2uRGqGBEcwL+JjuCrXGKvLwTh3NJNGqlYQ8Z0kBGTjqTX6zcczYhuyuzQihSBRKnJADEgl7P0SGIsz3U7A8zAhPoJ/ZTyKsQSeOrilxEo9gm1kW2FQctTcq4kvjiRKcgdlx3Fkf0e6QtntuezA0S9ladxVQVq5ahaTAYg6WHaiDELn4KVaFAEtVrBmcsl5T1ibvXQeYgDLL4IfMl6eoG50LvKFmNLXEyUmwnLjxFgYrqo1vK/2xUPFjoOUWZ8t6haszYEUMBQec9z3DrfKY2cO6RHa796n/R/FJ6pky3I5J/vIfV7wBI7c06VRGtx2leXU8x50eCyMb3c0CB1rMtVD9EoJhfOW+LJUIqod17QbFzXLncVrQqyqhvGzVN34lz5epRwFlce7wjCxplZgfrIR1crZh6fSvP0q8szQ3prVAbzutYR+Iy+mjPCHX8jW3UZ8h2BxNt62mXRk4VLd3TPLDqmMaHpQXkCRpFKa62hXp+mgGPII1IKOIamXvS2iS/Wy+IpF2ri6PRbAFnPQi4nKra7El6Zn7G5LDDyG3JHl9ye9jpqxgQHwyF5QVs1m+EDAU80T5E+PcOdk65ySM7lHtiSgVMmlzApTf/2+jrR39vOb8HqHI4Iei3cbol1R/x1bVYMk30XFiOxJNZzKmuNP9Zazx1kIL80krMvo7kA2CUDr8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0NMODcwbnBxQytVRVJ6NkxGcDRlYStLeWpjS2ZyVXdsd2p4cWxzREpxTktJ?=
 =?utf-8?B?QytNdkgvWDZKU2NES0ZQem0zeHVidXhGOW1tRFpVWlJ2MENWN1I3TGZicVRz?=
 =?utf-8?B?c1RtRXhtV1RmZ2RjSUFJSFJFS2UzenBoN1BqNXdwSCtxOGJGYWxCYVFkSWpH?=
 =?utf-8?B?WmtZbytnaHQ2bHFWc3orVFdIWmNqQlU2cHdWUzhhZGhSRkg0bDFxZmZNN0hN?=
 =?utf-8?B?SXlyQUFUS0JkeHR3cjJOb2syTFk4SVVNUjBoNzcrZUt2ZVNlRXJQWTJtdFJJ?=
 =?utf-8?B?Tmc5ZVlYZ0R2UTk2OTk5VEJRZzFTRjA4ejA4WGVPaThCT3NXYmcxcXRyMjM1?=
 =?utf-8?B?cjNNODBTVzRTM2x1RTZGN0tVNjdrcXgyL0kreUZXKzNuUENUK2FDVDVobnpo?=
 =?utf-8?B?VG5ocGhVMmhCZDVkNnI2Q1VGcVZCUTZDbElGY3FUWUJJVVdhTlN1UDZiS28r?=
 =?utf-8?B?YUZRaWU4eTBUVEduWjJ3VXJ2TjFScFhMcUUzbFZyTUVlZUxZa1Z5UHRBMmVR?=
 =?utf-8?B?djNFOW5KL3VtY3VITFp6WmRvWHRxMW5EMUZack9XdGVuL2NYWi9NUjUwUWNJ?=
 =?utf-8?B?VG9wNFpEYk43SHZsUktkZDhKeC9TRklicm1IaVV2RmhXdUdyWUl6VUV5d0Rt?=
 =?utf-8?B?OHF6NEYxTEZ2MTkreDFQYlUyZ1VmcVN1WngyZ1FyaDc4UGd3MEdKZmtjbFVv?=
 =?utf-8?B?NjNEcUI4SksyWjd4ckJCWFF2YkEzczJGeEhJY2tKSDhoVTZ4dlhWaWEvYmUr?=
 =?utf-8?B?L2NkWmR0bC9WR1YvcnJSTzFJUkorbGsxU3Y0ZDMxM3hyNWoyNFJkSWo5bjE5?=
 =?utf-8?B?eW9YUkdTSkFtTnlQQ0x6T3QybnhMRzdLN3lORkt4K0JsRFdtT3JHMzhVUWtt?=
 =?utf-8?B?TGsxbFBESiswYnlXTzdwNW5qWGROUkU4M2Q2c3lIbFdnNUJXTE0rOCsrSzNG?=
 =?utf-8?B?VkJvSmFwSFQ4VmNvZjFFMTJnK1I4bE1mRlZxK3djUXNuaHR2STQzTERXSjR1?=
 =?utf-8?B?ZlJ0clA1d25ySWxUejZYSzE2TGt3TE9uZitGYitLd3ErVTZrSDc4Z2ZjVTYv?=
 =?utf-8?B?ZGRGNlB2YkxhNkJvd0Jza3gxZkZ4MGZ0dC9xMzRkNzZHbzZHZGV6TVkyZGp4?=
 =?utf-8?B?K0kyc24zdlhwc2lWR05lWDVvNmM2eWNsMW54YkdpSmU0SnBIRDRiUVBCZzhu?=
 =?utf-8?B?M3RpY2ZiOVlsa3U0UHo1TFZyVmxJaVRKeDZMdGZFMTZjNmFKVUVlQW94MnhY?=
 =?utf-8?B?L0xLd25KUlZocVQvNFRVVGZxUGw1c1lwWmM2UW9nbklKQlN5dkMrTGxzUU9Z?=
 =?utf-8?B?WTRES1RjSGRQZlBCc3RnOTJObkdSc1dtSkh2NHQrUENMNFV4bWw3YVFCV2w0?=
 =?utf-8?B?S0FtSTFreWIwOTNDK3lvYU41LzBJSVhGUEVIejNuYkcxTU9jVEZOOUYycStM?=
 =?utf-8?B?d3dlNXVGTkk5M3V6QkFqQm1hN2o5V3lieGdsTzZreE8zUEZZQjU5RS9LbVgx?=
 =?utf-8?B?UHBvMm13R3FGY2ZDbzZodk0yZHlwMlZMN0dXd1NINm9yNXpIdzBhaWlJZHRw?=
 =?utf-8?B?L1ArV3pGVDlKWCt1U2xaNGtUYXM2dlVKSEpQV2drUzNLRGNYbkVBL25RU3RJ?=
 =?utf-8?B?NWFRNlhTcGp2OExjSG9pcS9sSEtsb0hyUEhWMDMxdmY0WVJuN016UGx0dHVu?=
 =?utf-8?B?RklGTHlMOVc2MmlRM3FCTjhlUmxrUmpJNVkyMllWRUF5UmFsVUNOWCtBTVYz?=
 =?utf-8?B?WVIxY3pIOC9tNXV3QlV6a29URTBrbSt0ZTA0UHlERlpsWHN4TWV5QmhiUWUw?=
 =?utf-8?B?UmxEdERFMkgvQmRlWWcyNW4zL0Yydzd3MENGN0JDeWE0TXF5MFJaMldQRXk2?=
 =?utf-8?B?Z1VVSkFKZnFNUTlIb0NiSSs5TWFTTHF4KytlaVRNY1h6dmlhMVVVUmRyTlR3?=
 =?utf-8?B?aWF1TCtaU3l4RFFNaHFvWDJsbnJHQTFvL1NRZEdGZVFZLzJTeEQzK2o4RVRJ?=
 =?utf-8?B?OURsczNWMjNUZmFmZDYxTWJxN29aa1JTWTQ2dzlYazZvWFF1a3ZkVXJyV3NS?=
 =?utf-8?B?R3Z0WHZhcklTV25Ec3grQzRNN3J4WGEyNi9PWEdIcXRXMTE4WVlGQzRITEYv?=
 =?utf-8?B?OFhkME1oS2N0KzRNZTRvUk1uTDRzcHZRaysrUnh6c2lLbWhSUGJhT3NRMnk3?=
 =?utf-8?B?azFEcVBBZmlIc1ZvSlkvRU1obnRRdTdNN2FNNUFVOHFHRDR2UkQ2WU1xM0VC?=
 =?utf-8?B?UDZBMmwxOXlDMW4zd2Rtd1ZyZjRPa1BGc3ZDWnhvTXhIais2bkdvdUNnODVR?=
 =?utf-8?B?alM3b2U5ZzNrbHRGSWIxdnNiejVwQitsRElkYWF3THhkc2dZWDRoaERHbmtT?=
 =?utf-8?Q?587F0NEBYtnwsDmrr9m8BlFbNJUFApCRmEBJm?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44225c6d-4865-495d-46db-08dea64380f4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 23:03:19.4422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BywEQScd2cHbSBotEfu3kN0LqgdLDy5QjxsGAV+ZvpUV4DvSjPshiuhr52tKcYBTI2E3dPT34xfJcnuC+xBBMmWZD6u3K8sfSXbBbMGG1bY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6847
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE929C0014
X-Stat-Signature: fu1tgcsdsjzfj3e5oyffrdnepyt19kpq
X-Rspam-User: 
X-HE-Tag: 1777503804-369952
X-HE-Meta: U2FsdGVkX18Egqr53HZ4mCtck8slVKcSjr03PBBT1BtQmv7KR9F5EaZxpCP63kqQ4vUWd9IGxzFOrZ34Lm3+NdnSoo0QjV5fIlmcCckWZUS128FCQXG9ixDYOXhV+NY/DOcD47TPcQN1rEcf/PTm45XZapARfafSmKgQ5NlKKpBn2r3c0Le+xGw7ZiRx48xLzbbnts+BPOwGwGacgWJEn1sxmNgZD4rXig8Aa1P7k53048uDX+/GDy9fnb3+pF+NVGVREu7IKdfoXKMrA8WM8zQamreWjJym7zp3VET0Yv/Q23QQUpL/ltXjqzERc4YJWOQDNBfu5RYbf3D3uAiTEG3+wNXZiz1lg9rYLn9ralCbFXV9uPxcF8pZuUIiVybzgXjqEXjDAVr7kvigruS5MEEdTv39ausAOXhkMNAbYwjQF2S4iTRFTHNxKezYRY121h7PBd2wYLWATDdLIVJK3kVtoES/ZTnLv3MNnWvo/FIVr1XteqUob1Q3/MipAmanfnZQxPzqWjJgLddHrWs36V/KcvpWzpZfYWcg8RKn6Mi4n7a5M8qloC0JZ/GzU0ijiwSuFhfH++Lp1XS66nobI1b/HKJS2aRurSdjWa2+l0kZDafQvYCiRYilaw3JIoyngFyY9KYxyhH/WjTwr9OECsmNMJiHlzl5T4LL0MB25bywXGe+PZvMZIZKRV3g6rZhh2Y79XJffHfbPcaFseyu4ozmD+Q2uiFTGV8QqkDAeQe5ftnwEzU9/HmRUlVOjfXuLj7Xxuq3QltESyzyoFGBVGupfnFScVqMeCVUheeAnHpcD0PmcuMAy0nOfbZgwpp2v33MIacHHQ8VOJYMD01CSbEXYQgx8FrGBuQMjM/jD2Kmn3V4ut0x/t4/5tbL09DT2M46Uevi3y3n8LFLR9GkL7BY1StewVh1NZyBbWTfU7N4WTlHCXZyy//GumjMi9N+fF/QPupMM7z0sKQUfhD
 IjdxPQVJ
 dadsnzmkTvYqvZ9WkjG88amzmHk/xZkAZZrEpv7NAnPfVpzDpQU4TA3KriYawiHp6RvbPMrHCn7Wmy97pEQUaEsJJnAgssaJgesdOxv0J7SdZWeKDvow+I1x4CLA4IySi3RP6domf3OdGDPmhpHGIWYXQAHR+q66Am9FzJ1mMULKV+f4f77HUVxEz4WREx8oVqlWCrRrWhIdFLVasEIw3OSG+n8wiPETKyXUoICUGYEOOqTnDfArFcfmwDzVRzPTapyIUSEvRZ5B6V3OE5GOzknyELxNowl2DMdpFhumqw6FWEZkDnz/J3zwRFeA8zFMrLAx+7qKqKSbLFGHRvgvmZkGb0bMjSDEwFEogltdZ7+8520GCn/EXD5HMIf8uf2tO4FurSU43mJFC9bi7XaFpB5Bv1ospt+D7f+QKFen/DbFsHzFx1UzaY6uGT/2yJcPO7o66Kx3fwMWl8XQC8H3DgPG0isNSsEgG1vc++Q3KA746Qi2F2Hi+Y7oW95LV/G0Myb9gPNyl7DyWSiocugJ/S8tzUmQcdIpSUbQh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/23/26 1:50 AM, Heiko Carstens wrote:
> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
>> Design
>> ======
>> To improve the performance for this_cpu_ops on ARM64 and potentially
>> some other non-x86 architectures, I and Christopher Lameter proposed
>> the below solution.
> ...
>
>> I have done some PoC on ARM64. Hopefully I can post them to the
>> mailing list to ease the discussion before the conference.
> FWIW, from an s390 perspective we have been relying on that preempt_disable()
> and preempt_enable() pairs for this_cpu*() ops are optimized away at compile
> time for PREEMPT_NONE and PREEMPT_VOLUNTARY. Which is what all distributions
> did, until now.
>
> With 7dadeaa6e851 ("sched: Further restrict the preemption modes") this is not
> the case anymore. So the overhead will be there for every "up-to-date"
> architecture except x86. I've been looking at some ways how to get rid of this
> extra overhead for s390. E.g. we have an "access register mode", which can be
> sort of compared to the x86 segment register approach, but switching the CPU
> to this mode and back is more expensive than the preempt_disable() and
> preempt_enable() pairs.
>
> To make the long story short: I'm very interested in your approch from an s390
> perspective (aka "other non-x86 architectures").

Hi Heiko,

I just posted the RFC patches to the mailing list and cc'ed you. I 
separated the patches into arch-independent part and arch-dependent 
part, hopefully it makes your life easier. Please feel free to do your 
experiment for S390.

Thanks,
Yang



