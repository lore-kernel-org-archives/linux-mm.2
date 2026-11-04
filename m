Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D74606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZFS5wUhr
Received: by kanga.kvack.org (Postfix)
	id 8949B6B05BB; Wed,  4 Nov 2026 11:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BB36B05BC; Wed,  4 Nov 2026 11:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C616B05BD; Wed,  4 Nov 2026 11:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7B56B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:40:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3918A84C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:40:45 +0000 (UTC)
X-FDA: 85398000450.20.9EF9DE3
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF74320002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:40:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZFS5wUhr;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793810443;
	b=CjwDfT6wbht2zmk6LBxRULiSs0zJ+FdSVAJnt0XT3DtLgiAdifwlupgj30o+OYao1GZzPM
	gKIOSC3txpJ+E8ooTR/RQtRWHwHxK24mEgfl4qOl/mqLhMmEMqJiJ9BGoXNPHJjsbIdyQU
	rKKFpChi+a8GN0GMsYg6Mcjt81G6Ihk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZFS5wUhr;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7uzjATlcBgQ4C4QznzH2i91eUNhhj35MPUel0ON3OE=;
	b=8ZmBaEZ54p/GFQHDoWRWfT69MmMHxZVYJcAJNp0dcPYJkhXkDKXtLsLO+59z9KBwAT98xc
	8C+k5T7+KwjPGYIIJXT1ofrrVGciSiNku26QAJGXsVw2uBW+UrzxL4MHkfWlzHF4FSpEzh
	niNbWtkN+C6NRZ2fj3hp0E/cPgj6YX0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUqEmO/FMG6kDtyvzlgNNBwrOzBBHS6mpIDVWcQOIoJmOfROSdyaudJChgi/z+HC9NJmzqAc6+n6L0aDlaGsDYobmRLm47KLeL2UxgUgaSdp4c+ymu9zvY9UpxnK7QuzawJBo704D79OkUz0UOtn0hLHVmZfSXffhqBFBfQDV9OIgPwrtmfi248lG2cxA/IiRB0wrjkfLxxRMov8ikxSvwOe2kvoS/ZtzkukxoVq9UM8lWgdMW3PnuDiD8aNyERsw0Kt+DFIdM5f8WR0eDHYjDLPLkuuK2LrTgu5JEvmJhV3e2EKlwKQAq6e7YGzAIKT8WR0wRwXqXXJPTPyVP2HpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7uzjATlcBgQ4C4QznzH2i91eUNhhj35MPUel0ON3OE=;
 b=JbevP5ImN9qsNxzpIWppg8fZoNVjB9eDCRYERhmrEk9H6a8mUZOc2jZOCPu3xjcFSLGmRjWqKaO0cfl1EZA2NFZKa1ECbGU3AEcw8voQE5M4SRoYpjNTYKwuBQ2gZqXT0xy3M+BcqrEKT91f6cmxKEa+GKhJlFeU/hkzCAalkfUxbJ2p6CuZYAAq8nSZJW8caq6sPZ6zUlfZ6tky7uex0QGwwbvlAFLzAHOaAMf391r3GLWfjN9myLWSLhB4xUWEwHB14JRze55DGj/vuwYy5efFcLSh4T52BxN3gCWHbfRlS/Qod7+530Flwjtt7YgmWb7W1/ESCHTqSzzPdUlOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7uzjATlcBgQ4C4QznzH2i91eUNhhj35MPUel0ON3OE=;
 b=ZFS5wUhrk4+Sq4EwJ4oI7MFWazTCghwDgo45f8wlSFAjpayU54/l80gRe+taRcHT2fq/iUEbQkSC/ePdf6U3Y6Jh/Nt+oU5tQIXHKu/7cJVcNqWdlyk/mDYmektsTwJ9nMVmm2bo5T41fH73KgX8oq0Z4j03Kbk2Z1UL1ivZinhbSdamzINWcz0jYDfmEc1gwILJH4wyk5CCwqQg9V95ZqZeUFpriOBT4FWMoTNE44dn3wZqN6zriWySmCmcxEtXdVXemzV+i+cbS5LkSdgAt4D0eXrMfcDT0yIcsx9gz5SdBAYyzG56pyEAglmSbSUMeXddbOtUWsZxbIOv1AZ1iQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9119.namprd12.prod.outlook.com (2603:10b6:408:1a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 16:39:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 16:39:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2026 11:38:57 -0500
Message-Id: <DMMKP0WKXN68.3RZSH6L49OXZP@nvidia.com>
Subject: Re: [PATCH 2/2] mm/page_owner: also check PageTail before reading
 memcg_data
Cc: "Tao Yi" <escape@deepseek.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand"
 <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, <linux-mm@kvack.org>,
 <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: <daejun7.park@samsung.com>, "Andrew Morton" <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
 <20261104-kpagecgroup-split-v1-2-f70e947fec85@samsung.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-2-f70e947fec85@samsung.com>
X-ClientProxiedBy: YQZPR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9119:EE_
X-MS-Office365-Filtering-Correlation-Id: 65c63abf-e10f-42fa-8284-08df3a9220a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|11063799006|4143699003|261021123027099003|261021121427099003|56012099006|261102123227099003|261028144727099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	MIxpN6Svivv6fumL0p1j2ilum3aiov0ZmpeEbpyVtixlcY1U8/DKayHcMYLdEq/WXF+DPoSuYuhLafoLycrjrwm2RPB20y+WkVXQVF7ymXpRlNVNjdDzMIe+Ocr64cqW6wn7LrFRs4hpsS38p3kgk7y1wBpDX+G/+TuTBNGjLPWsQle/YjL6kw/i3Ms9a/+6Q6JX3A1VwLlDXwT/TwLKVTN7LZG+x+U5KkFxeEq9wdsvkP51TB1smd/YGhBCmuK6FX2a0DZRAaKnvfzApxi40wFmLmWADNF8C6fKEiEHpnSAitLCKW5DbAVHdp2ji50X/Ibdyu6wTjhx0oLri1K/Zjx5KQdnP4SQMto8gGWm2KOrLOCA6Pznd00OErxjtVN9mB+jN7V1MM1Od8whd1OjRcTd4Xkw7Y5rvoY0HU0WhwGuVqpOtfNV2zIroKtXmmr6M47s4+q53IsAvmdmZpdCwv4/cw0efgBtNlnEJ7nJBnLZHOeS+qMY2haQPFvhOIHB/eaBg6R5MPoOGsZna/UcDpOLhfMjpNSWnpqPA9k7mlEfydrH5bSZvyZSXi/usY1ZBO/h2LbSyy4i9ZIGtTn5XHPtUmbbdEoVTa/OU6bGpgW1Br/HfdpRZCSnRAz2xU70PeZYNj0cj2Achdnbh2KCllzTRpJw/35JHZkcDsure8o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(11063799006)(4143699003)(261021123027099003)(261021121427099003)(56012099006)(261102123227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGp1Q29tdGl2ZFlOT1dvNG96ang1bWxOeHlodDJjM0I4MFBmeklJeWhVaW4w?=
 =?utf-8?B?dEZWZWg2bE1GaktINUsza2MzNjlDeFd2eTJlUWllbDdGM2NQWTRYSkxOLy9M?=
 =?utf-8?B?Y2NGTFp6dy82RjQrWHMyNVd3WHBKZm5WcTdXelQvMFhISkdDZm9NakdBeTd3?=
 =?utf-8?B?RlVUakhrdSt0ZzdyU0xrTEVFY2plaEkyZHlaZTV1a3FHcGNSQ28vNWFTYnMv?=
 =?utf-8?B?K0dwWDVtZmMrZmNBdnRhZVFZQjJCS3FQMTZUL2lpZFFyOEppNVVEV0s1NDhC?=
 =?utf-8?B?VHJ2WmJNZXNXakhtOHFnY2d2Vnc2bXRJVmk1Z05qZmZqenpjS3ZYMW9EUXFT?=
 =?utf-8?B?R3REZGRHbENBR1oxaHRuLy9sN0lyTm5WN0d2L1pNcVlWd1htNk1mN3RsZWU3?=
 =?utf-8?B?cVZTOGdkZXhFZmUvS29xQU5MVzZhd2FuS2ZRbVZtMTM5UHp6QVZKT1g2MTc2?=
 =?utf-8?B?QWJoZ0ZKZHZoQU8yaEo5ZGxINGtZTURyL3JkT0hrY2xmOENjbEVjczk1MnpF?=
 =?utf-8?B?cWhEdmlHMnJsVE1DWFRmSnIwNG5VNWZ5NTJXanRsZS9NckRnQXEwazRsS3pP?=
 =?utf-8?B?ZXFJL1IxSmp0ck04b3pUNTZJc3FnakNzc2dCY2FOT3dtNm0xNWlDRjBWdzJH?=
 =?utf-8?B?WWtqTWsxQWtDUWZyYzVPMnFraldmZlo1SEtERUxXWUFTRjhheFhhalVubkJC?=
 =?utf-8?B?YkhiQzlVMWhkdytEQ0RudlVqL0xNZ2tqcHRKbzZRMGhTT3JMWXIzMkJyVGdk?=
 =?utf-8?B?aGxqNjk5bDRPWkNicDRXYVpHR1dMMjM1QzhxcHFCTkZMdGdGNmZBMjVjaWhY?=
 =?utf-8?B?bGs0M0VJTXdxQ01uNVRqNG41RHNTcGpmZm4xNVBFWEZaNThpNlRHL3hvQnR0?=
 =?utf-8?B?SGdkVHozYThoaGlucVRuM2M1cFliYXp2MHl4a1FieUlDK2V3ajdqLzdqY1Z4?=
 =?utf-8?B?bWxBbDBkYnppNk9KZXVsM05CaUR0U1Uxb1Foclp4WmsvNVBITDdFRG4vT0JL?=
 =?utf-8?B?QjZDdEthKzdkYVNRUTZrQ0dKNFVCSEJteXlMZ3dSWC9ob0hmTlNaS0htanJw?=
 =?utf-8?B?WERxUkhKSUlaZWNPWXgxR3FoMnhQVSswTjN3WDI2ZGRBeUNBTDNxTHVLSmp4?=
 =?utf-8?B?N2ZrZDlaWWl1VDA1ZE9HaTF4YlQzZ0FUWGJWZXk0RytkRVp2WE9jZHFnZUho?=
 =?utf-8?B?T0JpU25veTU1MEV1OWMxZEx3VWJ5c3JyckNFR0szMGM0SlNBUUVvRFpsM3RI?=
 =?utf-8?B?VllvbVRrZnhYem5LcWQzOE5VTk9ONEhKdEQxbTNucFEzVm03NFUxOVVLaUFI?=
 =?utf-8?B?VUY4dnhTVldTaFJHbi9LTnJ6eWVaWG04eGxHSmhNWDFMKzJYZjUzL1dIdkNP?=
 =?utf-8?B?MThZTTZZRWlvazgwUkVtNXFKLzByMXVCTENlL3NhY0JXOC9kUEhOemZrYjFT?=
 =?utf-8?B?L3AzUEZPUTk5QmVpVGk4OG9Xb3ZVL3dDZUEwOHZuR0FJcVBzYW9RRE9ZTGRL?=
 =?utf-8?B?UytESEI4Slp5L2N1eWJBV1V0QzZNTXE3bkk1NnlFMkh2YU9xMDFzNlJ5Vldm?=
 =?utf-8?B?TE4zRU5pQUR4czVzNThZTUp4SU1qaDU0UWUxVWd0ckg5Qk1rbm1CZkcxejhI?=
 =?utf-8?B?Y0t1OHNacmhXN2M5WE91R2g2QnZKTVdFQnN6aVJrbTlsTDR1bmd3ZEZMTStj?=
 =?utf-8?B?OWY1U3FOMDN6UEJjS0Q0cldqb2d3YnRPWXBLbWxqZXlDczhIQzV5TEZPMm9L?=
 =?utf-8?B?QmdURklPR0tMeEVXVzN1M1h4dmR1WTRTSTJ3NTI0UkhIWDFRSU8rc2U5d1lB?=
 =?utf-8?B?bXRPdEttTlMrM0xLU1ZHcmo0VlhiNXdaejBncEZ2K1pMMSs4TXhtTmg1VWt3?=
 =?utf-8?B?QXFPdU53Z09VT3I1SyswMGJxVlQ3ZWtsdmtDejMyRHRiWG0wMnFVeUdpbmFq?=
 =?utf-8?B?OWFQWTNKR0oreXlqTXRtSzBrWGl4RE5uVkR5Q29vSStxOGF4dnZRT2NPcndk?=
 =?utf-8?B?NGNVbnN0b0w1SG42b2k4MlRKdjRncnVIc1JoemJpcWtIV1ltbDRmYlFwdkU2?=
 =?utf-8?B?eEdaWTVUN3J1SFdUbDVZZitTU05FRzNidzlXdlltMUNNbGR6Y2kybUlzSWZJ?=
 =?utf-8?B?WUNCOEpMRVVmdlJrZFJxeUtHSFplQmJPL3ZzTlN3YllKKzYrSHRNSTRza29i?=
 =?utf-8?B?dkdNNFd4MjFTNkw0eDloQWExWEo4Y0RmNXduVTFQMFRpc3VDM2hGbmxtN2g4?=
 =?utf-8?B?WTRvSjF1ZUVxUXBVbWdZNmttdzR1MWVBQjFwdWlZd2lWT2RjWXdxMmh4WnN6?=
 =?utf-8?Q?ztyqipcRLVLxwdRNqD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c63abf-e10f-42fa-8284-08df3a9220a9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 16:38:59.8846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RM3FVXbIYb6NmZRJUZhK/E0ZpjKzxBHuZZ6fc8XqWpagr/v4xqGkkV0WqmdNlmr9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9119
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF74320002
X-Stat-Signature: bbk6rxrqwrqcacg15i8f8rrxdmr3kc46
X-Rspam-User: 
X-HE-Tag: 1793810442-594212
X-HE-Meta: U2FsdGVkX1/QM8mFGKWl5AsI+Y90tMTYXIuygrzpzXf0KuJWyPZQbwpJIaocqzqhDVv+8GM1kqDOtvNS3nfZDuHpQFyL776ik6PxNwaLcu/+ucN1DwYzpE0SG//AfIt/uamMMVcnqW14y7cS4dH0G+LwuxBMxdTnTzHFm95vDP99lC6SSj2W3ZVQBSLbIJfQ7rLXwkHnqoMu6RUaLd+QsJcOc+jsMGNSe3oVdleJj+0vV+1rkwoU3B+rtXt8TKdh0gmBsb5qWJhJkSKJZ/Lodq9iHxnp9u+cSVZksYKw8qN7tgkudZp6xvkB30WKLL25v82oKabZVHi6TTRH0DT5qOSqK7a5vtf21cRLpnjXp/H/4ICvHaZXXdm6J4zk7NszwK82ICmC6nSqsWcnCj6P9/YECvzw61jBmxdESq/eHiBpjSI8lxWgdCGOcCoTgmptbWYzKCOSCitizrK4hIOlyw8ngeUYfREJF2QEwdiplhH5D6R8VslKA5iVzm8FvCtFoLpoOf1RA4lxfc65FRB5J7TsYSH1GDTdA2BFSrpDWoIAXcYXOLYud2H+Z0Hpexp5fWi9qC+GQkz2PXLeWfODUA/ofkF3Lmq52Uc6mxYkDMKucn9+DF4694S2BzZkpj1d80nVKRxj4RbKfK03/HWHYHVERs7z+Pfqof+GwiNpjCwVYFoMREqHFmqT5zoAzKvNYzUKON8mt10L6f0POoa+z54in1x0AKinUsEgB6cAT4i3exSRBRjAWbkXpDwFVRdri+HlU5BIBRuohKPn1ftNmtBelqlci8hvXTsb2RX4qKRo+ZlwOdwUeD0mAOBjZpcKFV+XIYoPs1C8RypzxN0h9SEcp+BQfK+TP933MTxfpHMSnrd+ZAiJM8MHrAJcalUvhy5ldps6eK3DjFuPpJB4eheIQPZDndYjZCE36pwVLthzJEg009+7iuAYRCYGFgj+ksnYmynJfP58W6BMiK8
 VRI2VX4h
 QR4xWSf1nNmIm8OiL0QWp97pIDmpViHd4WuVqWqs+8pvgPkhbOfznbmZSUEmGkXTWklVyabdcBgrzHRH2yXVR/H7Zf9nAOLp8mqLKsxISguY7yyikrbzOwaJDiHtpp5amXqrmajzY8GuTDDwsNPzoJL+GoPXkWVnO+Pxp2SlAVL4f9gTRbKwlPJxfrfYu0sbBbdF+/tsDpBOLglsHoRNnauHPWKbhwthH8ylZKsiWbtRu/6dnJVsuzzVxLp0veTxLpWb4Ra41IX3t/UhyYv6VQe95uC919NCbfZVNhpeHnTYnVToM7TLPoKmBALNzSITpANp791hYLbvLigwPQVd9wTYf11T1h/ST/3JuelquYQm9fzIzD1d/2WX5FnbFuH4U/YHlLuoXfbCalbG7NQLXwutDqeFR8RccqDuS1l9TVy5StPYEreyiUcHyy9jD/zOWafoXnn7rAWkabVei7O+xFqO0IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 4, 2026 at 4:59 AM EST, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
>
> print_page_owner_memcg() loads memcg_data before it tests PageTail().
> In the first tail page, memcg_data holds the folio's _nr_pages. A split
> can make the page a folio between the two loads. The stale _nr_pages
> then passes the PageTail() test and is used as an objcg pointer.
>
> __split_folio_to_order() stores memcg_data before the smp_wmb() that
> precedes clear_compound_head(). Also test PageTail() before the load,
> with a paired smp_rmb(). Keep the test after the load for a page that
> becomes a tail in between.
>
> Fixes: 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first=
 tail page")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Needs patch 1 for the store order. Found by reading the code, not
> reproduced. The page_owner oops seen with a delay after
> clear_compound_head() is the window patch 1 closes.
> ---
>  mm/page_owner.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>

Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


