Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 205F6C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2192A6B0103; Thu, 16 Jul 2026 10:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFFF6B0104; Thu, 16 Jul 2026 10:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8CD6B0106; Thu, 16 Jul 2026 10:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D18A36B0103
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:58:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57C3F401EC
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:58:16 +0000 (UTC)
X-FDA: 84994945392.09.1AEC973
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 699F7140009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:58:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eEUXBal+;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784213893;
	b=8FhqR6//dL3NyqZ2Wf4P2F9hJwXS6h3DPDnOOHlOVV46vKhk3vn3SZxjRLJhWoWcBCu6s4
	nCmDpY1uRT8xajyvtCb3A3BsuPN0FBdzIR+7VsEiBe8NKKhf0Dmt3asy0l2S2beWw/dl8t
	ANJmX5xwgB2HVdPRaR9x/sKi3VcySRU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eEUXBal+;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGME73iXV83J0kQGfxPss0TeI7jeOHoAufEllS+BAL4=;
	b=yDG1hjKWIXhVzFiKqPwo+vDpykB1iFxUutf6Yht7gQwOFiLDwfx7Xo/gKZC2m0RXEp3N6k
	Fdzo2cSFfEPkmeAunCgpOSlv/eYbQniim+ZnyalZf5t4ICelssnX91HgQJEQExXvYU6gB3
	Swh3S1V58uJVOxsYWfrPgQhWKVOHXns=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p3rjQRMEyVqYS3YfizhglXMQMq0Vzf3XktHPDXPk6S+2Evh5B5BlVNFEw8AM4Ki8MBoLknA3QSxFXCXzRCKnHEbBU90OJyQOQOdoTKu0nFVaK8yPwjOe7Kl7GVEet3Yy9Yne545qBs/ZBz7rHYVCOsr02PwHwP1BCN+e2QyvW+CfcjY4bhOfA94XCpgDRmY4QGY2M5RVsRCWxR3tkxISW5YQ5wz5lUSAcX7to8vLRARoz+eupeN8f0V+A1jgl+1LcqqOPY+iUrp5MNUnpQQq3Df0icqjunA6WWG6RH4F5E9J/Wkb+S3JKmqfnIVLsPPuGIDwhOr3akdd21ME7wIPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGME73iXV83J0kQGfxPss0TeI7jeOHoAufEllS+BAL4=;
 b=j9tdWana5w2GxR//gcu8xhuTOynUt4iDbL021dr0I8XZzb32F5AWYNGIvrLktRPhXap89AJm7PCzlegutiZObOVKKHIBK0bbg0NDnOwaS3tmImrlyarN/O70pXlc3DpnNAnqKDeXk8Uiuq/EZGl7jI22hOeU9R4A+lHZkPrXybEdhWxwvSy4lz0vju5xXybZ8KuVplqivTF32gM1m2EDWxdvZ2H2k3JjPLBv1GW99/eA6HO6H1m17o6mPTEQzkOvAPgo3JnHRrwLElscOjboxs+OcRkjFJeEgaTkTXCr3ivzfRaWc/DqH9jTEXnGi7V4EFlx+HCdaQmZ+wkl+D5O0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGME73iXV83J0kQGfxPss0TeI7jeOHoAufEllS+BAL4=;
 b=eEUXBal+48W0J1N2X6Hu5njWWJ7QutEBG2WewZKi5pauOdTz2Gf+VWNZ4DjtF0HYpEnHBtnxMgUPGq8T7kTzngEJvlbTStZ7odTPucKJzUx/jHTeTFGWl3xBVdCYUtmGKQFgNtkZ6OxOJIH2DbfciRziDY3OzhmSBXaTEaC9IIm2+WcY+GUVKt0WtgrTUzx1s4XeywgsQACYpOq///e3UzzzN6dnOJknJlzi8WexZOs27ho++kbB4w06X4lLim89aOtNcZO1zSw29iO+sgrt2ROg8KWiqsqIRsxQVIcTVhmBm4faZBbxEt7Ipqxva5S1lnZglrRbUjrTFYN+9RFr0w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB8524.namprd12.prod.outlook.com (2603:10b6:8:18d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 14:58:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 14:58:07 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 10:58:06 -0400
Message-Id: <DK031C5TU7CZ.2OVB1YRAMM4ZE@nvidia.com>
Subject: Re: [PATCH 2/2] mm/huge_memory: fold split_folio_to_list_to_order()
 into split_folio_to_order()
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <npache@redhat.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260716100345.473473-1-kirill@shutemov.name>
 <20260716100345.473473-3-kirill@shutemov.name>
In-Reply-To: <20260716100345.473473-3-kirill@shutemov.name>
X-ClientProxiedBy: MN2PR01CA0059.prod.exchangelabs.com (2603:10b6:208:23f::28)
 To IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB8524:EE_
X-MS-Office365-Filtering-Correlation-Id: 64184bec-04a4-49e6-02af-08dee34aa577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/UarNXrBT/4ww8dggysrnlprewwZV79jFEhsrutKxYoHX1jwNSnoIw9hwlMpg3QN2qoEjit7oyhU3pazyxE6ZJv3W2q/WGr9tbgElzIz5V33Y0L2MiNaD6vraNbeuQmm0ffosMILjZvIYIt3lBZq7UR3vJG6BCjYWr8LgMYulWff0zc0DPRo3FHR0tkVvZBCVUgFvJgwyZsA0JHRKElIuwJE20k4LJocorOl1NNl0gDWQQh69bIxL9me5kgoEJ/RzJv3NSpuZvoCW8THiQHkmvI1OH6844jJm25fYK/RWgI/Bls1H3smgOnMykzIMeOrL/2pshsooVClTiGUoqEsLBIXEP1ikHSpfwaWDh/2VRRTISYWZfh2GN+atR8/MWjKb1HNqtM6OHJJnINnL4GOw+ONyoGObS4Cin6AIj9XJ4bhlA/Z5WfcFz7UCFk/EkVm18M/0hsTR5tDTP7X9JhXS27JAlaD90OOOAZcl239VAnv/ASH7ZI5rgQKZx+p8WxopRvMi7BnJWbCt/4wEIlkAkeAELGTRVpPVpHWNfsWaqqzPT5nAEtS4ewhxcKWsVarHQCFiVu4DY/i3yW3j6VcU8rPczqC4k/hiurWqjF2C2R/mzw8rM/MeELcUhV/Daaefw6fCuTK4qi3DeJw13FPnGa502qlVUKnkQiZ5hdgEqg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1ZVcGxjSG4wSWFNeDNIUUlJZlR5T1hGWHdWMXVTMWcyOUpPQktYempmTFVO?=
 =?utf-8?B?dTBsRFhUOUlKakNVSFFZOSthYzFMdkU0T2VpYmJXSjI1blB6bjdkY1BLQ0xM?=
 =?utf-8?B?NHlMaG5RVmdialBTT1dZeWd6dDJJaWdONnhzeVpockhWRzVNVXZVQm5TWmU5?=
 =?utf-8?B?NHMveXFMd1k2ZHVpNUwwck9mTHNVOFEwaWxSTTNhUFB5Q3ZOQUVQa0lRRDB1?=
 =?utf-8?B?alhYSlAzZEVkdTJpU3F4ckczTXVIeis3bEwyeXFpWUF6dFd4blQ5enhhdHd1?=
 =?utf-8?B?T3dIQnlyZGhxUG5QOGU2TGgyOWNCVFZ5U2RnT1RvTW1YdlF3OUFnTVlUZXlj?=
 =?utf-8?B?MDF1RDhmUEQ2ZWhJWUxQNFY5cURuUXdoNmorRm1wakFVRXlXcS9kN015ZFh5?=
 =?utf-8?B?Z1lVQXRrN2E2TCt5RU9iK0ZmYVk5SUw0aExwRFpNdVZOdWN1N0Nva3BiOWhH?=
 =?utf-8?B?MzFpNUJYdmxTSy8wRmJwMWp0Qk9CTy82dEQycXZQbzc4TzQwNkhiWnI3cEY0?=
 =?utf-8?B?SFBxazVzUXE4Lyt4ZVFyNHZjTTZjbU1aa3ptQUVEMXYvN3JzL2dVZGpMVWRZ?=
 =?utf-8?B?M0pMSzZad29GL3ArMjYwK1RTL1o5VVBSc0VXSFhXc1ZQWXp4bkNuSDVYSENa?=
 =?utf-8?B?SDZONWg4MTlITWVleGFaOFpuNTNtckQ0K1lBMWl5TkVDNkNHU2FJOG5GNXVW?=
 =?utf-8?B?Vk43NVVHaWdwMjRaeFh5dVV4ZVZzSEJnNGFrcnZ6b1dkWnovcm1BaENuN1pF?=
 =?utf-8?B?eUdjanpGQmZjSW04M2t4VmFkZzc3Tm53eTU0aTVFb1NIVmV2ZVY5SUFtNGV2?=
 =?utf-8?B?d2M1b0VSU0I4RVBWU0lBRFQ4Y1pDSEE4aGQ4WXNRVmNBVDZhUVM3NXpmaWlQ?=
 =?utf-8?B?aUlRNWRORmtpWmhWMVBPcjB0R1poTm93WEdiR1lScmpzck1lWXNac00xazdK?=
 =?utf-8?B?VGtoQU1NNUVnS1FHN0QxbzR4OXY0RW5XaHRESHRKKzFOaDhvY2h0Mys5M0tP?=
 =?utf-8?B?THBPbVNVQkxQdjlvbUhmcFpQS0NGL0lsVUFNNVhieTA2QWx0bVB2YVZWOSt2?=
 =?utf-8?B?b01QWkpjV25nd2pDblpiM0RuNXEyejR3TjFTYkxXbW5OVDlvc0hBM1hLdzNM?=
 =?utf-8?B?cjIvOE9xcWltenlUa2VMcTMyQ2tEUlJOc3JIQXEzWHlIOHNpQzRLS2JpTFdD?=
 =?utf-8?B?MU5ld2dhUjFxZDAwTXcxNk1Da2hhR1pWei9MUmFuTXJlY0Y1T2s5MjNiRmxo?=
 =?utf-8?B?a1djRU9Tc2M1N1VrTEJkaFBEQVZvWHRnR3ZQM01LSmRURDFTY2FEVWJOaVNa?=
 =?utf-8?B?YURSQVNJYnBXNHZadmVaQXlpZTlBZ0Q5eGlkMGRJNkZVdFpjczkzVjMrU21h?=
 =?utf-8?B?OGlOVXh5NFY0dXZoalh3eVMyTFdwRitsOWxzdjlnTmFZTGtqY01RYy90dDRW?=
 =?utf-8?B?MUxMM25VR1Z4UEdoMytHTTVqM3c3ZzJjc2VHbkIvVHpjczNoMC9WeWxiVVJP?=
 =?utf-8?B?dFhrdFU4ZDMrQWVmV0hvL0tKcnI2ZG1GMlhKZGx4VDlSTEFpSWttYVp1Q2lC?=
 =?utf-8?B?WlVLNmhyaVpXMWJPckJTTjhjNHViUmFhSWY1WVdHZDU0S2wrcUQyU1YvT2Rh?=
 =?utf-8?B?aitKTjVSSHg5cHpIQWRTVUtqaVJwb2kzRFpvM3c5SXZpa3M5RTkvWjBEMVF6?=
 =?utf-8?B?QStnZkV2aGl2M1BQRjduUGtTSDJvNXJuOHVWNGV0bmExVS9Xb29kLzdKTWhE?=
 =?utf-8?B?MDdxSXlvQUxiMVpWQ1Q2Smh5VFdxa0hXOUcxRHJaQVhENmdyamtlT2Z1eHR3?=
 =?utf-8?B?WnBlL3FJODFIZ252a2JOSk1LZTFyNHFaV0ZOYjJJT1NUMDl1UmROUXI1ZUI1?=
 =?utf-8?B?a2Y5ME5vT3Y1a1ptY3c0bGpSZU5TKzdnSElTaE56cHZMd1V0cktQNHJuYnla?=
 =?utf-8?B?NTdPWllYb2xLckhPaG1ieEQrSlZMVHk5eDdZTmVlWHZ0MjJBNmFWUEpCMEFF?=
 =?utf-8?B?MFhXM28xY0pTaDdPbDJYWm9tSzEwNlpuVlZWMzlYZG9oOUtjcDlleFhvOXha?=
 =?utf-8?B?bEM3ZkgwcU1LYTE4eUp5MkhpdFZZaGdvL2NYRGpNaUFTRDZZWVJIRldpTU4w?=
 =?utf-8?B?ZEFSYm0xNlZRWlVQVklGYlZwNmphK2R2cURxMUJYV0l0WW9hVEZ2alI1SHhH?=
 =?utf-8?B?dlRrNTFxL0M5dFo1bVpJK1dMTS9oWmI5OC92V1RFSmpyQ2FNK1F4RGZqRm9u?=
 =?utf-8?B?S0JWVDZjdDFpQmVGMUZaRHJ6bzNTa2QxT2h4K205MytCcmVqczBUc2FnN0pQ?=
 =?utf-8?Q?QYxEr7SWvG2jRbDLiC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64184bec-04a4-49e6-02af-08dee34aa577
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 14:58:07.7740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVZjGBkCsmVdvCxIoEmjl0U5IIBNPoWyROG/RO7DM72xLLJ7qs8urD94OwfK6vTi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8524
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 699F7140009
X-Stat-Signature: 8cy1qpzbpz51n4wbowgrncs6i6gj8a87
X-HE-Tag: 1784213893-740623
X-HE-Meta: U2FsdGVkX18xoEm6yD7dJlBFCXxhUmY9qsJKKujymjkV0MjLs1dfA8WwXMW3cTGvMNipBORxFPfmnYAaJ4HzBXZoSoIBy8TsUAtmfMBSPI+P1QR0Z9DCoea+qSU5daq3X+J1Pa+Ew561PQV7Yu7U6Hl1FtQC6WRL60O60PF8cpOEWS49BVXDeLTQknIvu+PiXDwqO+IrPyzdvjGhpGTa8GaXoz1BQE724pLonjPGXTB1iQHK9sYtbnkqpOtoBLRU5v5k8e1igc13mURtr1mxshx/8Vpj1GgR4LFZ262fYlwrgfGbq67gBrQtSSCSKjIfO29ZCnBTqyPu2d1m40RQRkt0NzMIP1ZpYlYmVb75OW4G1tyv39NgEN/JjJeANFzci5zs3/1lqpgCeanqq5oMDxPiMSjrsEnqIXcdQAJqgptY2e5b0l9f6VNv109Aycf9TNSn8BTDQw2IsCgHVWmKdPXkpJF3ksLMWXhq6Rudo9B9Z05PPWrJ5As++x+NpPE7yN81o0cUdiWXOjP1oZRV8hj4du2+jHiVbSo6esd+Onid8h3PJo2DCBpZOgWZ+TGHOEGIwAGLFw5Hi5k0zrQtTo5sl7qEIlNk/oLPbeQT+qVOelHfCMCzP0M7oKBrHvSmeVZ5+gjXetsBhunr7zX3W2vohy0F9IDK9F5s6WD/fBt9AACc2LrWKqwQ4QX3D0eguxkNz/KCPhB5JOMbonYjskvhKcBUTRZii9CeaJbb/jA01z7nGcaJ6Lr0jcO4ayr1YCl7diCV+srJT7RCxE6ygpjWGcIFBiVFeROQNElSPhWtQxcVwhVWyNfu6U9e+QJFEX09RrunuHASJ8EDHCWxKjo98UfsMKng4DVvMAkXWjuuFhGKQ5Ql2iUCRV7erAfRtOXcYG9XRhZqByZGuOzP/wxgyfsw4gpPbvBj6yrnRig2jvKM7Lf/PGjvy7wUT4IGqftnRELxxt9LGDlAGI/
 m1G9Oxdn
 QBBm72MUat16BLK7ahMX+lWodrnK5rIGqDGc3TzmzJ5jDaaxWQ7DDjnu/IZfzxpcAYeZ1tvvMgHiwPZmxlO0C72pIpZilhc1k9jvOqRgDuj0jxsgJB7JbMhEJgOKlKMpmCUp4RypZlyHktPz+5PNpYl7r+tbMYo6IDse+xVWKO0fw0Et5ivpbdYVUc9eMc4C7MditDtTKXQ6ZnCXYPpoti5KvtCdtIqJ3sxSg8dTyS8YZWppI+C+BgbJ7avA2FnBjhOACrmVhKDa+WU/XRrBwxv0Tw7LYGiKet05eY9G3Oy0uAN6HrFSGK6bqZKQJjFVEKlzZtAxw8SH436hrNJbIddZT93g7kmnCOr81ObS0lCQrdLAqkasUT2TSOTT3Zh7GwrAgSkTzg7yg+zk7P7BcdO0KvIOfwXHv7XGmlgGfa4WNra32GzTMk0XXbl3qGYCEdi3/lhrjHDf38L7ztVrCwNh8eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 6:03 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> split_folio_to_list_to_order() had no direct callers; its only user was
> split_folio_to_order(), which always passed a NULL list.  Fold it into
> split_folio_to_order() and call split_huge_page_to_list_to_order()
> directly.
>
> No functional change.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/huge_mm.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


