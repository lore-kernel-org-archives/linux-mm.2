Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC58606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pvCGl8AE
Received: by kanga.kvack.org (Postfix)
	id 2F4436B00EF; Sun, 22 Nov 2026 23:08:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC476B05B2; Sun, 22 Nov 2026 23:08:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193B66B05B3; Sun, 22 Nov 2026 23:08:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE886B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 626C414069C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:20 +0000 (UTC)
X-FDA: 85465051560.08.0BB46F9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010042.outbound.protection.outlook.com [52.101.56.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62444160003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=pvCGl8AE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795406897;
	b=AUE+CnOXktcB3y6t1C4cT6fT99s77Kt7in8wkO4+FrdjLmOms2i+DittdMSNX+TD/+bdxe
	hDJ1e+7aunMyXmeI4uNN0TER5X/EJUdzEM4sEkgiLjts/Sf9kOA8sqfXF3Pt1m0asi3rnA
	pkgi3sEvvq5Qywo+/kIc5b0mv+Wdg9Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHhahUGeh2Rlwdj42mBZu/QYRQb40s1atRUuomeB++8=;
	b=dG9TokFl2Nw9wgzfxjinh8giVgBl639BWW2HIza8aah6vb6xubNB5fnn+C2RbH/uUfcR2p
	EP1bNnWvq/XspMaN5UlnWoE0m/CZLC74lFK6Ouz4pUqV7yyPO9UKXozQ9Gg+7b2DacOjbO
	16wyEpfZM3hXYw0mMeXLrOwE5HHT800=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=pvCGl8AE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ii/RC/IPsYMsxQCU2PanwMyzM8ITVMHwrzOX3KmLp++5RLj5LhgbbpI8JS0MocdPvK5CN8R2hEUYaxCQ9TQIjX77vwH1UioxE5K3BBlS5SdH8cMKjJD71I7swQ9aMN50YzSqHNMl4Pqp/wViu34ojAgUfAyIFka07MveasYwznpDV1KJaAHRmw+cc7NHVbRJpABrYHXjBu8dl5zCZ0HPfqjpmGgpj89Kaa5Gd2PoDTJvw/V+1VYE8Gd69PJJCivyyL8rJZL4SUCtb2JFkv9Wp1VhaqXBjMFryg61U3cunQl+tXo5/YQ51JtXWSBsxzNF4dO+aYcQT0YTovjo4VyCrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHhahUGeh2Rlwdj42mBZu/QYRQb40s1atRUuomeB++8=;
 b=i5IjulkoXZHkriCDk8lPKcBgJoZWk6lDEYSaN+gH2KdSfoThasgCTQMxLiB/fz91R6YNunCD8syJ73+jP4E2VaJCcbZWZlUZgmc1DaXcXySzI/91e9mdb7LJ5/cKToL7YkYBmO+orNQGnqcfg6M0R2KVBBcXSx26H4/qQs3ZSHb0mtD76iyV2dHbObpwYFPTrwqUFGDKWZEOKiXWV3cH6U29oa/kalgmH/91viWGTxHgkMstBOWKDQs7rldIuqkiFqvMCT0paCon2hveKyomcueTUbGqKmULhoKtPXcV7kIRJYbQ4UUqfM37gitm/NBieEbrn2e3+5P+dxniCFT2qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHhahUGeh2Rlwdj42mBZu/QYRQb40s1atRUuomeB++8=;
 b=pvCGl8AE5dWZ4UIRMFi2u3re/ruvnP8LDqfBUJnpC5BJHc3w6q3zx6bzvJjfDDhn4/jVu5Mk05UKcUY7yS2hOPegWVwZVUB0oIqQSP3VC5xmAcbeSJppvOmbV8cUkbBXguUg8aUd1970aFEyMJqJ1ydJCqg8UcoNNKxSpMHe1Kbc54d5TPPFKkTxkSAUd+4M20OtZ30Kwzu3Lnd3H0tft3e+4SsGFeRDh7nB99N80gzCft2/lmA6jEsr7498oHBNBzMdGo7fASVSblXCyFbGKHovogsueqDFu8NScgbMMZH8x+E9IEKF1hvIOFcWKlCvKDfHftXBlFzGK98vEUemIQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ0PR12MB5635.namprd12.prod.outlook.com (2603:10b6:a03:42a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 04:08:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 04:08:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] RFC: mm/vmscan: unlock unmapped folios only after the
 deferred TLB flush
Date: Sun, 22 Nov 2026 23:08:07 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <A4AA8719-376D-4AF9-BD12-0F0CCA49F68E@nvidia.com>
In-Reply-To: <20261118-file_folio_flush-v1-4-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-4-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:208:239::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ0PR12MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: ba2bfeb2-527d-4173-b9e4-08df491762e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|18002099003|22082099003|4143699003|56012099006|11063799006|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261021121427099003|261021123027099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	7YQfDp56MsF9TpPh4WoGKKZ2TLR8eUhoQbKifpdxNT/eqmthMkKmnlrC58mtCYRQ3lEf4cRUmTQnF7jzCTjy4POScxmcihcXw5T0uUmCt/1aqZ6wSNlryU38wV+OSCM/jkJXMbSmP5wW1hFRr/xEEPWBdzi6ldvfa35Ix9gdzMdVrxb/3+DXsc2pzor3JOr1tfiFnlutEfn09wTKeJe6jMmwM8Kz9lYR4qys8WzqAGJgzAfVSEdxoXKgeezL3+lSCKWB09Z35TN22yfvS4Fq4TsfLxR2fjvJLTuPFwxn8yaGdky1uyy58dUqNdUsHorT5TjVGsPiIie1qoe948s4/YROQ3LpeH3GBImYRxBy4RBZWFO5YhseEFumQrUeCwgijpVANGotTR6G231fvSH6B/KIXGAal9qrY0ksqZEaM7vpFFVQQFrqtPs4e2MzG4ULOtzGBq6C68uebmnZhDwiNseoFLy5SNoZgmp2eRQbmH9tSOOk9yNola6JcrXDcOrnH/qwViutFJrYeP49NtZnTHZ7+6TpT4WiRjLuKBqladYWhJNFn38nFQcTsFLmsxcK9qUoDf6C31DJo1jyx59TbDTLnQX+rnjFX0mrLTx3R6I4GXl/r33kHGYoCq+T9ut4MD+kLbHjiRh2dRQ5xX95PnlxBDChpsysyOcePysz0T4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0FEcXVndGFTWlk1YmxXYzVWWDRBeElscExsT2poK21Na25TSDBhTTlpWWhu?=
 =?utf-8?B?aGpLaG40WDhaR1ByanFmZTQwQ3RQUktiMkZraCtyUzN6MDJiaWRCc09paWRF?=
 =?utf-8?B?c1lSQys0N2d2WXdCN0pDRThFSFhvZGVwQ2ZwNzgyMkRaSG9oRUg2NjVOdlBZ?=
 =?utf-8?B?bmtpRlVockhkS213SmorT3VSMGx4TUZZSHVBdXBoSnB4ZnVhT3ZBSWF5VjNr?=
 =?utf-8?B?N05VL08vNnppWENaaUsybUY3V3ZXTWdtKzB3U3B1WU9UU1EvejF1Q3VCd0pn?=
 =?utf-8?B?eUlSNE9mbk1MKzdUeHJWQk1kUFAwcG5GQ2NEOWROdGlqNzBQN2s5dnQwM0FU?=
 =?utf-8?B?eTkzNEFYb1QraTU2aGMzNndkQ1lIZS9SNGNSZVdyMUJFeldWSGZhRU54aVl2?=
 =?utf-8?B?MWR4bEd3M0puM2ZHUDd5T2VZdnNiN0xZR3E2NEpTc0NZV2k5VVR5TlNJLzB1?=
 =?utf-8?B?Y1VaaGhNM3pNMmZ5UTlObXpOaEhvbW9mM1lHSGNzSWJ5T2hjdlB1Z1dKV2FJ?=
 =?utf-8?B?eGxoNnBFblBRMCsvWGNya2gxVXY4bEFURnhJZ0hwSDhZWEE4NkkzNGpSdi9F?=
 =?utf-8?B?OFc2azFGM3ZKaGU5dVp0WjhNdU1kU1JZdy9iWmUvbFROdWJxcVJybkJ3cUp4?=
 =?utf-8?B?U2Rhbll1WkxXb1RtNk9QZ2ZoRE9iN2VzbXUwUmNpZjl1T3dkYlpJMitFUnJB?=
 =?utf-8?B?NnlqczRZSU9GbkJ4a1l2MDFiSE5KZkJGYWw2bmhxZG5Lckw3V0FYU2Z0aCtY?=
 =?utf-8?B?TjI0N1h6c0p4UEtQZXRiL2g0K2tmVE9ZZ0RleGFXWWF0RkxiU09PZ3dST3ZK?=
 =?utf-8?B?S2tZWUdzaEk2NU8rSFBTRWxMS3U0YjZITCtQN0hEcjJiaVVQL2ljc3lEaVJa?=
 =?utf-8?B?UGw0T29RZlN3Y3c5WXNGd00wOU04Y1NaZjRBNVYzb0RNdVE2TlNnRnpOSTF1?=
 =?utf-8?B?TCt5Q05pSks0cmg2dnN1Z3B3emgwN1J3Sk9ZMmcrUFpiaEtTSjg1dmZVdGFE?=
 =?utf-8?B?bERtZXlsV1RTcG9ETnhvbkVJeGJtOXgwZFh4R0JmWXVnN1U5ZGl2R3R3QllL?=
 =?utf-8?B?UHZNWExMZnVZdUJXMitzVitTTklLcjVFd1Frei9EOTFyRnQ4RVl3QjVUU1VB?=
 =?utf-8?B?SCtYNm52cytxam10WEdoTmJoOE9wOWtjc0duZlFXNkd1MXpHR2c3bzJSSFNX?=
 =?utf-8?B?Vk9iaHlVczlHbDJTZlVmTkl2WFRRbWVQYlAwOE15T0QwY1V2S2wydmtlWkQv?=
 =?utf-8?B?SFNPMmRtVTNSNi9kODZHaC95Y0dOMU5EL1FxVXM3aExqaTNPSmo2VVh0dkh0?=
 =?utf-8?B?eTA3UFl3VXZEcllZdkF0dml4cVgzR2Fuc1p3eG5LRHlnTHFaV0t1U2M0aFhD?=
 =?utf-8?B?VlZ1NWh4bzNpZWtzdmlUNHduV3J2RlFseHZLeGE5VXpVVEtFdWJBSGVoNi9C?=
 =?utf-8?B?cmhwVFhndk55QXZZdDhxOGtCZ3pGMlVybklTcmFqOWVXaU5mQVp3MGRnOVF4?=
 =?utf-8?B?RjQ2ZUNvNVdVS1dPMDdjMmdzSXB3R3lldFdwVnRjODNDMjREWlJhWitkK2p5?=
 =?utf-8?B?R3ZNWXkvZ1U4K0ZoY3czVUpMc1hLM3ZZZ1A1NEhjRDJLN08zVm5GVUYzeitz?=
 =?utf-8?B?VnJsM3hDMmM3dTZreDkrNlJlR1pnS0o4Ky93ZW1yR2tGeWgvSUpkcllRSVNY?=
 =?utf-8?B?SEpsOXhBV3ZIanhuNzA3dDBrL0pGYXJjVnZlMW9OTFBLb3ZOaVhpcnNnSzlK?=
 =?utf-8?B?MW84a1RGR2h1V0c4VnhOMnBZbm9URVYxbEJydi93QXBJZUlLSGhPRCtvYVQ1?=
 =?utf-8?B?TTQ2NDdlTEsxcDhybjUzanFZZWczYTgyUlcxTWVjZkwxT2NWZnFFSmw4NXVH?=
 =?utf-8?B?L1dIaDBVc1Vpd1Y1ZDUrWUl4MXlpeGc1MFBzY0lZN0pOR0phTWl1b3JDcFpP?=
 =?utf-8?B?UXlJdkY1aWtWVDNrb3c2Z2NQZkgwOGkxK3NGT2w2UUNHdVQ3dzBoQkZvb0U2?=
 =?utf-8?B?ZnVJbzZkN3BLYit1NmtBNmFrL2NMcmFweFBPbW5FMzFZcG9YZEdYY241Q1VW?=
 =?utf-8?B?dTgvRGF1Zm91aVM1b0Y4VTFkNkRkTUdkZ2syZmR4dElnaVRHaThHeWxJNzky?=
 =?utf-8?B?VnMzRUlkRUNYWGpWN1ZRZmk3ejI3b3daZWg2L3Nsd3E5UmMvYlZCMGdBaFlF?=
 =?utf-8?B?ZlRyRFdBd0tvSFBZdWZjVnJuNHR0OHF3bmtodmZndlF1V3pXRDRNeS85Rk9G?=
 =?utf-8?B?ekdaMnl5bm1MNzRPcUNwOGsyb0ZGQTNkeWRGejBvRHk3THdjcWc5ekU3VlJS?=
 =?utf-8?Q?SmMP/j0COX/m5L/ERJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2bfeb2-527d-4173-b9e4-08df491762e9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 04:08:10.3914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOKOawyElDB3stQYP0DORghI0V2g0QE9Yr2bbwSWmqHVhLO/uMLP4p4Hs3qYIf2l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5635
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 62444160003
X-Rspam-User:
X-Stat-Signature: 6jazbuyot9q835o4kjpqh8o6y35uby8g
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795406897-140530
X-HE-Meta: U2FsdGVkX1/bs+VIUK6rYZd4i2/ffcHWRVn2UDOzmGo9MuaTk5UnaxkR2TA7YzWlrw4fWtwRVNmZG8AoqNzRVu1VOVpKK6XI/7RVMUozUUKR4neIN83NvYxtbYMZQJk21GgvYt40zjPdU2Bo9ciVqHZ7o0EK8QR/TnxVU770o1YWn8jrrfkZalHCb4LhV54deLJ4EKZEh7iISKFjLxJ5VMo6/X2vxFNfHOZFwZoTsc0xbk09UB7nxcS8fa2ljReMZJx8OOl7x1awsSm3zmx6fh3rJGM66nN2A5ap5pX+xoTAEyHw7kjTHhU4EstLWmx5N4qQyrQ+Fru0hhapRmNI7QZx12/G1/fdawwrW+3MiFES5oxZxxhHrZz+15n+9DOqaC9Nvu4KUu+Ls9XLNK6LQ8HEzgyyAu3VpKGbXJdh76qqmRAO9Ftqm3TK4Kul2oQBoTK5V4t76Z4JHd78ai8ejkYgv8etSepei8WtUysMqDugXYae1UmZ0eLNNChUqo5A/+89lKXIm7YpP/lf6IX8hohddt6GREpSjBoYh29rQUbb+8lOJ52BXf6ATzaCsWJ5Iv5mo+YMjhbrI4S4pTiZmhH04A7Kwy0LD/xgAFe8AIzzu8BAIAOT6E3ti5LSD29Uvx6U53aVKHFC86VDvZA/iu2COQ6I5przmDxIXloFQN/q5V2VM+aglSXL5lhPb75PLy4BhH2ab55+TJp1L76bcYET8kqW3LxGq4Yny2t3+mi22aLYz7I/rAUEOlCgYqcxhV67BvzYIiZoaKph4CdgISGMXTKTiTtCDu+3CGRweJBMBJRPamCJ7KBPKfOP5OgWjG8uv5omhinMOA7LPGxQVDLgfHpkIa0CXZtSmbwIsU9KYPNITr7VL0tBJ7NJ4WokgwKxu2mdwbcpkXKZ72cfzLPe9ET36qNYCVe7dUtIkVcnCNmgJ8u+oxpUvQIE6GZHcdQE2lCpj+3VF8/JtFQ
 nA9fIN55
 aaN8AOs8EfLAy42jJqAOEiWYeofCphBS8ACc6XAFO2nIDJZBGzBHjA3Bnbg4uzhpzhFmlwG4SowVfcI0TMJsoxSHz7+Av0iFRmtPfKQVPQdG4I8H7JwOcG7Lr90snTyu7/QNFv9w6yjEZyVHL2kWCuYkTQz5QX9G7vObsGkg7oIoMER7ZFj1GCFu6x5Mj8oNlOPHWnQCarTNXHNEUSll0vuuGzg3psdE+x9nC9H0mag1W+70HJbraTxH/R5SlpZ3m+ZfbHXqjkh70Ntalqj8PoEeM712Dbw7A5+ISYNUmbNnDm0GV6FXnvBCLQ9NVJDffnFXZVvpF6bTtVyu0XBJeeED/YVeHU2M+xd6mxwYTcbrPgi8ywlsoiFSj/N3GM7LQNFMB3WOQDtyKV5cKnRiUD72/Fg+e1ezp5FV+4YlTUr8RJ+H9VqtRvf0duZMfsgPmwF0OLGTxgnqPq354jHdDLDr5lfagypf5XMbDw29v8YCuO81I7FtuAVCwftqu2K9FtAA0H4dq93q3eMJcTcO7DnQdcFvr2rxmAlwQUPrpUZKleQZ/+pgcKrl/MmNyIYIeRCIQeUdb8DAcQ1S8mXndTJlxabgqhw/aReLY5vEuNubXesTbvtD0A9E9AIcMx/7+cZkn894h7oNX4mp90ddt25qI2yuPBBUe0xmq5GgLARZ4fAHwZNxyKvr3W8EzFvIflbPXIB+A3lv+8lPEImZBubJ/7aV5Wmev+sAQ6LgDvR12I5oPNq/BtHbgZ8iASFVb+Sby5IocUAd7vvCJSN6XK9dQXx18aJ+dpeSYYtD3lafnqaUsykLhD7gDWMsnszMSAry7MMskx7QQ+iGJqVzM+PQs/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 18 Nov 2026, at 4:20, David Hildenbrand (Arm) wrote:

> try_to_unmap() with TTU_BATCH_FLUSH zaps the PTEs, transfers the PTE
> dirty bit to the folio and defers the TLB flush. Until the TLB is
> flushed, other CPUs might still access the folio through stale TLB
> entries.
>
> However, reclaim unlocks folios it keeps and removes folios it frees
> from the page-cache / swap-cache before performing the deferred TLB
> flush.
>
> Stale writable TLB entries are currently handled by flushing them right
> after try_to_unmap() if the folio is dirty, so writes through stale TLB
> entries cannot get lost, but they are also not batched.
>
> Stale read-only TLB entries, on the other hand, are problematic:
>
>  (1) A page fault can map a new page-cache folio, or swap in a new folio
>      once reclaim removed the old one from the swap-cache (e.g., a clean
>      swap-cache folio, or a dirty folio mapped by clean PTEs after
>      synchronous swap-out to zram or zswap). Modifications of the new
>      folio (e.g., through write() or page table mappings) are then not
>      visible to CPUs that still read the old folio.
>
>  (2) A CoW fault in a MAP_PRIVATE mapping can copy a page-cache folio
>      that reclaim kept. Writes go to the new anon folio, while other CPUs
>      still read the old folio.
>
>  (3) Invalidation (e.g., invalidate_inode_pages2()) can remove a folio
>      that reclaim kept from the page-cache without flushing the TLB, as
>      the folio is no longer mapped. A page fault can then map a new
>      folio while other CPUs still read the old folio.
>
> This can be reproduced easily by swapping out an anon memory range with
> MADV_PAGEOUT, reading it back in, and swapping it out again
> (MADV_PAGEOUT) while one thread keeps reading the range and another
> thread writes to pages as soon as reclaim removed the folios from the
> swap-cache. The first thread will occasionally read the old content.

Who would have thought about it? I also wonder why we never get a report
for this issue.

>
> Fix it by reclaiming folios in batches of up to 64 folios:
>
>  (a) Lock each folio, check whether we want to reclaim it, and unmap it.
>      Keep the folio locked if any deferred TLB flush is pending after
>      unmapping it, otherwise unlock it right away.
>
>  (b) Flush the TLB once, and unlock all folios that are still locked.
>
>  (c) Lock the folios again, one at a time, to try reclaiming them.
>      Activate folios that are still or again mapped, and skip folios
>      that are under writeback or poisoned by now, or that somebody else
>      holds locked.
>
> As others might map or unmap folios while they are unlocked, we might
> now activate or reclaim some folios that we would previously have kept
> or activated, which is fine.
>
> Keeping folios locked until the TLB flush makes sure that nobody can
> remove them from the page-cache / swap-cache, copy them or start
> writeback. Page faults will either wait on the folio lock, or find the
> old folio and map it again, which is fine.
>
> Unlocking folios before trying to reclaim them makes sure that we never
> hold more than one folio lock while performing I/O or waiting on the
> filesystem.
>
> The idea of unlocking folios and locking them again using a trylock
> before trying to reclaim them was inspired by [1] from Zhang Peng.

This solution makes sense to me.

>
> As nobody can start writeback before the TLB flush, we no longer have to
> flush stale writable TLB entries right after try_to_unmap(), so remove
> the try_to_unmap_flush_dirty() call and batch these flushes as well.
> This effectively enables batching TLB flushes of stale writable TLB
> entries, which is what [1] tried to achieve.
>
> We must not wait for a folio lock, a folio flag or I/O while keeping
> other folios locked, as that could deadlock. So flush the TLB and unlock
> the batch early before waiting for writeback (legacy memcg), and before
> allocating swap space would perform synchronous discard I/O
> (folio_alloc_swap() now returns -EBUSY if allocation failed but retrying
> with synchronous discard might help).
>
> Allocating swap space can otherwise only sleep when allocating memory
> for the swap table, which cannot enter direct reclaim or compaction,
> as reclaim runs with PF_MEMALLOC.
>
> We'll limit batching to 64 folios for now; the limit mostly matters for,
> e.g., MADV_PAGEOUT and DAMON that can pass more, or when reclaim splits
> large folios.
>
> Note that khugepaged and batched (async) folio migration already keep up
> to HPAGE_PMD_NR (e.g., 512 with 4 KiB pages) small folios locked after
> unmapping them with a deferred TLB flush; migration even allocates new
> folios, possibly entering direct reclaim, before flushing the TLB and
> unlocking them. Both also call MMU notifiers while keeping other folios
> locked, just like we do now.
>
> Keep code churn to a minimum. Some follow-up cleanups and optimizations
> make sense, in particular:
>
>  (1) Cleanly separate the stages of shrink_folio_list() (see the TODO).
>
>  (2) Avoid unlocking and locking folios again that do not require a TLB
>      flush. But only if it's worth it and doesn't make the code too
>      ugly.
>
>  (3) Remove the remaining try_to_unmap_flush() calls before freeing
>      folios; we only free folios that we flushed already or that we
>      never unmapped.
>
>  (4) Remove the now-unused try_to_unmap_flush_dirty() infrastructure.
>
> [1] https://lore.kernel.org/linux-mm/20261031-batch-tlb-flush-v6-0-190539=
839eec@tencent.com/
>
> Fixes: 72b252aed506 ("mm: send one IPI per CPU to TLB flush all entries a=
fter unmapping pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/internal.h |   5 ++
>  mm/rmap.c     |   5 ++
>  mm/shmem.c    |   2 +-
>  mm/swap.h     |   5 +-
>  mm/swapfile.c |   7 ++-
>  mm/vmscan.c   | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++----
>  6 files changed, 165 insertions(+), 14 deletions(-)

<snip>

> +static struct folio *staged_folios_next(struct staged_folios *staged,
> +		struct list_head *folio_list)
> +{
> +	struct folio *folio;
> +
> +	if (staged_folios_empty(staged))
> +		return NULL;
> +	/* Collect more folios until we have enough or there are no more. */
> +	if (staged->nr_folios < MAX_STAGED_FOLIOS && !list_empty(folio_list))

One thing to note here is that !list_empty(folio_list) can happen
in the middle of phase (c), when pageout() splits a large shmem folio,
and the code switches back to phase (a) and folios on ->flushed
will stay unlocked longer. This is discovered by AI and I verified it.

To make the code strictly follows the comment, you will want to
add ->draining and set it to true at phase (c) and back to false
at phase (a) and check it instead of !list_empty(folio_list).

Or add =E2=80=9Cmost of time/usually=E2=80=9D to the comment below.

> +		return NULL;
> +

At this point, the code moves from phase (a) to phase (b).

> +	/* Flush the TLB and unlock the folios that waited for the flush. */
> +	staged_folios_flush(staged);
> +

Now we move from phase (b) to phase (c).

> +	folio =3D list_first_entry(&staged->flushed, struct folio, lru);
> +	list_del(&folio->lru);
> +	/* We handed out all folios: start collecting again. */
> +	if (list_empty(&staged->flushed))
> +		staged->nr_folios =3D 0;
The batch is done, we move back to phase (a).

> +	return folio;
> +}
> +
> +static int staged_folios_alloc_swap(struct staged_folios *staged,
> +		struct folio *folio)
> +{
> +	bool may_sync_discard =3D list_empty(&staged->unflushed);
> +	int ret;
> +
> +	ret =3D folio_alloc_swap(folio, may_sync_discard);
> +	if (ret !=3D -EBUSY)
> +		return ret;
> +
> +	/*
> +	 * Don't wait for synchronous discard I/O while keeping other folios
> +	 * locked: there is potential for deadlocks and long delays.
> +	 */
> +	staged_folios_flush(staged);
> +	may_sync_discard =3D true;
> +	return folio_alloc_swap(folio, may_sync_discard);
> +}
> +
>  /*
>   * shrink_folio_list() returns the number of reclaimed pages
>   */
> @@ -1166,6 +1251,10 @@ static unsigned int shrink_folio_list(struct list_=
head *folio_list,
>  	struct folio_batch free_folios;
>  	LIST_HEAD(ret_folios);
>  	LIST_HEAD(demote_folios);
> +	struct staged_folios staged =3D {
> +		.unflushed =3D LIST_HEAD_INIT(staged.unflushed),
> +		.flushed =3D LIST_HEAD_INIT(staged.flushed),
> +	};
>  	unsigned int nr_reclaimed =3D 0, nr_demoted =3D 0;
>  	unsigned int pgactivate =3D 0;
>  	bool do_demote_pass;
> @@ -1177,15 +1266,41 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
>  	do_demote_pass =3D can_demote(pgdat->node_id, sc, memcg);
>
>  retry:
> -	while (!list_empty(folio_list)) {
> +	/*
> +	 * We take folios from folio_list to pre-process them (lock, check,
> +	 * unmap). Then, they move to the staged(unflushed) list, from where
> +	 * they move to the staged(flushed) list after a batched TLB flush
> +	 * and after unlocking them. If no TLB flush is pending for a folio,
> +	 * it moves to the staged(flushed) list directly.
> +	 *
> +	 * We then take folios from the staged(flushed) list to actually
> +	 * reclaim them, or to activate them if they are still mapped.
> +	 *
> +	 * So we pre-process folios from folio_list until we collected a batch
> +	 * of staged folios, or until there are no more folios to
> +	 * pre-process. Then, we perform a single TLB flush and reclaim all
> +	 * folios of that batch, before we pre-process more folios.
> +	 *
> +	 * Once all lists are empty, we are done.

I wonder if you want to label the above three phases/steps and
add comments in staged_folios_next() to clarify how phase transition
happens.

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

