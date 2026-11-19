Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C9C60A2603
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZJYHgQoV
Received: by kanga.kvack.org (Postfix)
	id 5DE096B0685; Thu, 19 Nov 2026 11:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5A76B0686; Thu, 19 Nov 2026 11:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C996B06A4; Thu, 19 Nov 2026 11:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CADC6B0685
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:47:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B87D2A4110
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:47:32 +0000 (UTC)
X-FDA: 85452449544.15.16C8167
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011022.outbound.protection.outlook.com [52.101.52.22])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6A3AA0007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:47:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ZJYHgQoV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795106850;
	b=Tuvs+uOcD4aIQjy2qPhXy+9b0KprQVLsz7KRuHyGFBGpdosKcYfS8QJnt0Fi+vtLeUiuXx
	TMqixiqLPYuxi44jbcEeyiOcM6KTnl99FERefsgonQO9Wj7VIfbB9zAUV2D3LzzmZDc/++
	FYsniMs7LtNLApKc5aSnkZfKU7aMcj4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795106850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuYFhjs7mCVDiJ2gP24B9f05HZH0srWTAYA9BObVOWI=;
	b=cuCu/tJ8rf0WIghAZ1vuXQfE7/IitSGGuFsF9coEUzkOaHkv6DcVKMfHK+FhrD+LjmqHUE
	F6/Rr7r4LbppfMno1i20MUmENLLAZ7k4nwlG0zSo5Oj6tJAVHioOYE7figL6sIJzP0AI46
	SFyB6ZW6WfNzSIl2Rik5e05Q/OYYosE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ZJYHgQoV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJBpUVQnq4j5fJ1VWLGxKEVk4TyG0012K4A6wDyHunBb0imwzCNWeLklPsJc+sseWn9/QLyzkgqP+OybZcZuaOeyASe/dPClo6NKX7u60yCy02SPNJDhATFWbaxTcnjykCMuIcPRBeQkGvw2DBRlEIjbGtvXnekU6hj/ScSDOtkUhfDHHDaIwvpegdJryy/Ou9oe8ejhXl8FxtZ8r2rXwCkTFdril8PoMPSA2hvHWvTaIQdnL8utnI/xwMvb142vWI6a+Frc0DBltfVb7taTxyy8p3dDKZAc0LIanysQKd/4Iu8tyNUbA8TKMggO30FUNFtTiWETdvevyrCvQq5K2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuYFhjs7mCVDiJ2gP24B9f05HZH0srWTAYA9BObVOWI=;
 b=ajptfLlrhNvJoOcg2BE8nC69d/CBevMjAblbTOYse7gUgpDLoesn4IH/6uxchZPrL3qo2d3QFtFDWcYTWYOfSbts7uwCyJt8nd+Un6Ru9QTck27GljF41MMaCT5tygLtsoG1Ez2NGPVboSrWikJab+I5VQBKxkbH8wUWYGuPoL6jrKIe/YxEGKhuFUTdd+VgLq5WPqkSRacIJWbr+br52ht0i4IeHeMoIxg+SC1XDZK1ek9bi01wnVbLoCDmwRYO4MlQQ6Ygz8HCqJXdJEwuSJvmZKHiimPaNOBFPh0fjqSfO2DxU7JBpL3aKTqz5n8JqInza+tA/W/lk6ZfqeLz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuYFhjs7mCVDiJ2gP24B9f05HZH0srWTAYA9BObVOWI=;
 b=ZJYHgQoV8rhYQzgF90uYiKoZG+SuFgwp2k4txzZ8yXEZP0SecyIWdqs8w/YfOM7UCQ92anT54EGzEmpXd314xTaGD25TUS0taI9pVawFYYOFLVdU7Jj6M+a1ka5Qba8gbk9bQjtztCqRkCMISRjw6q1BQHHFOpBL+DEMEHwksSQKxoHWNr3yzba/qDaa6/yNqfwXv60YE5BYZNHqoQPeMEemZXRXls8bMSzNUFxCUyJh6kH0belpj476Mft/Gcz/WxS9G+F7pEVj375OF/rRMORiibFlQBx8Afu3eVJlvR7yf80AHZP+lXIJBXggifLXwjl4ol+W3YUtCMpZru5www==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 16:47:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Thu, 19 Nov 2026
 16:47:25 +0000
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
Subject: Re: [PATCH 1/4] mm: flush stale TLB entries before installing a
 CoW'ed folio
Date: Thu, 19 Nov 2026 11:47:21 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <22DF2F1E-2692-48AC-AEE5-79B61947D86D@nvidia.com>
In-Reply-To: <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:408:ea::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: 7011a649-115f-47d9-ab17-08df465cca4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|261102123227099003|261026140227099003|261026121527099003|261028144727099003|11063799006|261022115727099003|261021121427099003|261021123027099003|261022105027099003|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Hh+wY8QD9WjvvNlU3Bt7k1cCdv9BwmM1a2ZcD335H67IpiFxkWlTxSh1RL2XUW1iAlucrYQFFWxKeIdM4MJFTZq5th1IXSOE/WV4SMgR1yMfgnvAwPzxkwgf6yHp7msQcZzEg/tbUAhpiKYnqVrLuE58XPMwAkdlfchfuHMDygn8lGnOMDX7753Mm3I0UEwtJtY98U8B0F73zjXwhH/Xi4YHLZ25FDfZ6G8sRBN/oxNkQoUo0/IMMs6nPNGQpth4znLkSOHKqWN9udu61H3O0IMCZz8+VlmNb5UbSRwFKlUYXugoPNMSt5GBXpn/MeuRoEHYkDXLtwefQQsQUhm21BSQBHtUGwpsPFOT/IsRKgTHmOgnW9UY9oQ0caasmDh+gyzWjBTvfteMrklGBo6hT4lKCJGwDKVvm+SU+A0PBkWd6n78rrupVCY/kAGcrPmpLQm7orDgV2DAxPUQP6qUPikQfphkbGmSlbrWQThBVDHJQOku3EMcUeHlKPZJi2v8r8KgGfEAn6m/tV/+BxbmZ8dpu7EjQ/7o6i6NL4h2zZZh6z0rMLGHJfTdSMWljgERtpqYHU9hz0wrNQ8UwwFuImBl+3XYXxm6C13RqoQhIABLf0pi95WM6mzwByQlG1hbcD5gUiBcrfMzRXhJZrELmoOM9/Tq6nRtrhE1EQevaMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(261102123227099003)(261026140227099003)(261026121527099003)(261028144727099003)(11063799006)(261022115727099003)(261021121427099003)(261021123027099003)(261022105027099003)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjlQd0JuU0hxTmsybDcwbHlRNGR1d3NmVm5nR3Z2SFg2Y2UzOVNtYkhsMk82?=
 =?utf-8?B?ZGZTRi94aVhubjVVSXdsWkVjSU5XWW41c1Z2NE5JTHk5dXAycHNCQWJQdVZh?=
 =?utf-8?B?dm1iUTBTUFFKN0NVNEtWV2RRR2M4eGlMY0lLNnBtTzBSWjY3L2E5RHN0L0s3?=
 =?utf-8?B?dWpCc1VUdElraEVyTzhMdzc1UE9scnFZUEJiKzdvMGRBNEgvd1JTMG0rOEFW?=
 =?utf-8?B?bDE3M3JJaUJ4bXlNN3VHVUgyTUtwZ0UzMUpLcnRSUWRDcDgrUGY1OUFuazkr?=
 =?utf-8?B?KzZDZ3pxMXNST0NzVWN5N1duWGlQSGUwNTdTT3RWM2lPOVJFcmNEMGxoQ0xm?=
 =?utf-8?B?a1FacGsrR0R4MlIvWWtpMHk5WGZJQlVJUE54NEdqUnlTWkVCMkMya2txQm1V?=
 =?utf-8?B?Z1RLVXk1cVJtOFlwMEFCZnpvVjNhS1dDbS84QXJJLzF5cnFuak1HcjBsQUNB?=
 =?utf-8?B?dk1EMjlEbXlqMmhLcmgwWG52Y0hzOTVId0dsdlg4SisyZlkxQTJPZEppVW04?=
 =?utf-8?B?REk0TVB4ZVF1MUxrVGliYlF4d0k5VGREa3U5dUk5bjVLZmFYRlJWRnpXM1p3?=
 =?utf-8?B?emZtcHJ2by9iZVhoVStaTEo2NnFrSE1SNG5xOGtLb2hSOTNBdEc1Y1I3bW9E?=
 =?utf-8?B?dWhDRVVpcXg4YjdUbkZWYzhNYldqbDhMdVNtbTRkU0NuYjFTNVFiSTlCcGc0?=
 =?utf-8?B?bHIrK0hwaHlXdzlBSE1jQmlxbFZ2WTQ1MkpNZGs2eFVleFlQc3RsUFZ5UGwz?=
 =?utf-8?B?Ync3djJ2emZsR1RvU251MGZYeTV3S3RtQVhnSEU0VGRhTVBlQnlXak84amJH?=
 =?utf-8?B?U0NrQS9NYStRNVVuc016ZHFlVi9kMHF0Znk5cFBUVktDUldSNytYbmVKM2pS?=
 =?utf-8?B?N2ZBZ0ZNNDdORUFMUys3Wm1nR0lIczFNU0VHbkZFZGFlTWhlTVk0czN2WWFS?=
 =?utf-8?B?VE1CeHVKSEZhR2haVkxCVlhsM2lxQkUxeFJLZERod2VkRTdSNFVEOHNZK21X?=
 =?utf-8?B?aEczWkhIeTFsSVptZUZzYzN6bFF0MTIrZ25qTWRMZGNsUDk4aDlQZzFvWlA0?=
 =?utf-8?B?L3FJRGRua0p3TjZzS3U5M1BINEVMY0VoWmRuUyt4MkJuWUtUSkUrODlzQ1lm?=
 =?utf-8?B?ZTBpcnd0d1lTR3NZRG9uRk9iNzBTOVRzWDJsdVA0THFFUm5hdncxcU82QVRj?=
 =?utf-8?B?Y0M2QjdhU0M0WUo4Qzg2UTRET1FIZWFoNVFYWlV6aUxqWUMzdm5MRVUvUjRP?=
 =?utf-8?B?K2Z5clI4K0VoYk1OaTZmMHhQSGdzN2I1TDdQYXhmc2VOZEtlZFQ1OUswc1Ev?=
 =?utf-8?B?TnZyaGxJdTBmZ0QxemZMUUVIRWtOS3dLcmQ0ejltd1hGQW02em9QNHRiVzhx?=
 =?utf-8?B?MzUvVGxxTG5LamNMU3JNN21IQndqWW9NaldoOEYyalJLTnIrOUhDMnBIODht?=
 =?utf-8?B?VHc5SGhUdFovdkU5VWNNejNHQVJGWjArLzRuMkFFUzhmSVV5RFcyRjRCczN3?=
 =?utf-8?B?QUU4Tmlua1FuQkxKRXBmeEhzSGYwU2REbVJROGIrenUyMFk2NkFDMEc2ZmE3?=
 =?utf-8?B?WHR5M0hqbE5EMXpNd3dQakJjckVVcmo1aWxQbDBaSUlacHU5d1FTRm02Tkdq?=
 =?utf-8?B?WGlTV1Fsa2JvTUI4RnEzdkltSWl2M0pJSDlRZ1N4VTUxWnJBMGFTQlVndVU1?=
 =?utf-8?B?R2Q5U3BGYmR2NkFzTXI4NnQzblgzVlZad2c2RUd3ekU5UVFaSnd6TUxISms3?=
 =?utf-8?B?dTZNZEZqOXZVQk5ZQjNQYWpUSmtwV1VpSU1Vem95YUZ2b3BSMHJaTGhUMkI1?=
 =?utf-8?B?eTQ2cDh1VjFhR2FFOTk2N0RnTjIvVE5Gc1M0eFdRUkZYTnVMVnVJclY4cmQ5?=
 =?utf-8?B?d2tzMDJhWWpnS2E0NUJLNHhpcUF5Nnh1OXFrbXNkNWJmeUpIbHY1M2txVEV1?=
 =?utf-8?B?S3c3WFNMMmgyRWJTakRIM0pSbTdDdTJVWG5WUU9VUEdKYWhQeTJPenYxTXU5?=
 =?utf-8?B?dS80ajVaV29oOVdOaERFaG5MdlBLYTNVQmRlODFha0RlUEc4eGZTNnFnZFZS?=
 =?utf-8?B?MExpY2dXSjlCc2xFUTVzbHBONC8vRG5qMUVsWkhKbHNUTklSSHl2Nk00dmZ5?=
 =?utf-8?B?N3E3UVlTeEtWeXFkVUpIaDBrWXNjcGZTODlYZnVJU2tLM2hjZ1Z6bkxpeGlh?=
 =?utf-8?B?SGVsVUJNQVM5YUxWZjNMb0JZdGVNK28xV3BhSDlLQUtVVzF1Zi9jT0tFM3Zv?=
 =?utf-8?B?OU92b2s3d2JWaGtoZFJCaEFkc3Z4KzFZdjU4ZVJTSWl2RHhqMVNkSUtrNStY?=
 =?utf-8?Q?PKRK4LBPXu7u3Sj93X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7011a649-115f-47d9-ab17-08df465cca4e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 16:47:25.6016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSi1R6rhhA+jFCxuBkLGokgCNEE1LsRtC3P5JIgZWVuBHIzN14yvoPgWt36v2Rnb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
X-Stat-Signature: 957io6ykazfqy5qj39fbnxbpr7pfnm3y
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C6A3AA0007
X-HE-Tag: 1795106849-521074
X-HE-Meta: U2FsdGVkX1+8byVV2gakXuvsvAAeuqmfO753osXzFexeMrrvcQ9yeaI9q8GiItGYhnyJu5aAKRnOHeBb812dRvw4q9xT2HBfGllEoPSHoKoi3ayMmQjHzev8jnYtJ910gYKcyLeHAyCtTsWAqqQhVq4h0yx2IKj0GGsUY5G0eERBqzC+2iG5ViXxrLx27fZNNEorLi4jHz1OugR93C8sQFETc08Mep+dXmphdNPXcDrIa5rQgTFPUbqsM6pqtUQKyYeu32vrsMWmFPQeRYqN0fO/miEBXhBUHYobnBlhcZO+siLo4nEPer2OGNKxiqi5+0aHEB2v0agPSMJsPj/nINuyZaH5JwFMEW6p9Z0LTBOJH/STPhspGJe9K+jFIeO+umEztT/MKDpVIOu11cm1635l5nKb61iUEcQy9HrXzwcE3KKpLdCDiPb4IVKW0lfXbTKMYEFn9b/krskrGXNDdoLLAo0cpnDlFBblpzqCQPEvN8HUU+b7oC00VXjjuFAO3Mr7uzmLhB5mA3pR7dajXtmQcdcGwCNgzg62GB6PZt3FOcfvh40TMMm+c3nIIiVfY2pfdQOTMZlofMS/yyUXoy9+iKFgjxWs1jDl62mvmO6k+P4OMsaqsD3wZFq1ekc0uqdbPoin4YnfeHrLvKWJifXSdlEmC0Q3mNwnXmIdje6Q3kzvzK28zGX9MT7SMnz6Iis7pT1vnV2Dfr9RWFS3U6BBDNvqTtcyeSMRohLoUTeLGLQjc7E6REzd3dcLqS+z3UcTVNBFhZ+N07RcJWhU9TzQuS+qe175HiRFYd1GRRLxt9yqG0ph5zuOTsb2Itvgi3MESDnsZALkzw3UrlPvdyAVuLi8IcRKEFi0ZEjSf54mhv1OVoFg39I1QjnmamOG0ryi1hQVPEZfoY5olBa4jW52BeBgw7xyFAZ38hSlSr3ZCW2pEEOAGbaTU76guyd36DvCK+aq4ROyxczXzRK
 y2fKtO77
 NCpSyMcrjvub9QaVmkOiHcLvJl+7m4wAf5kp/JZ6K8gyjK3Det8rn/6W3jI5mMEcFi2meY8lYGrONsKzY3jKVHfAenGiiablCbn7O96J4LvtFPN4ZWi5S4YSBB5LCC4Coz//ydEQz5DiWmE007ttOkcCa2JXgmr7qhaFeziGHc+gSZK2zEyfQ67jnNDep7+MRCQVujHVGNoAsFjYGena1v/HnVgIudIeL/etER4lBMYZfKZ1ISTMNd3UDwhCkiBO//vvYeBCIRC8lxj31pUaDeyzuiPLBqY6v2sik+mkkqevvMjjwEOS8M4pt6ygYKp4s6MGOSSESImXlfE1EwT8mjMiuTtoHtmOLDys2jmcnU7RyyIv2Ytsz8htmklJrX27C6KxgMkpgM6eKC3qmjLnQq0QdT168p76s9n9AOAkoX5MBcxMYj8/x2+Np9ZzdFmzXXr4qPt3IL3I8wdY7hEsFI64amjcnbGPRqno+ZzxdL361w319p6c3e3r+xqEbki4ovzcPivRzWlAhuzUM8KGDtRj5BRvxmTzfyH0hkpGd0u499TObIJvmXTCBtfzTizOf0F/hcVq8t1TMv42HcRIEbETu0M/1pGA+lObb7bsNip9ciJ6PZz6xB/oIbnmT8zQOQP7rNPIlkrq0BabuuLnRM7MVPqbLu1nmzaqT9FHWSws9jdRiIDMgbLk3nxx8BulUKjcpvO2WVufjHEj8X3I3BPiHfQNQh9VSSj2OhiCgqA7o4MXBQW1qFHDr2zdus1jOY5zkfRmozvtp+vLFZrXIfo70c9g74pQgVy1VntEonWZ2PqTKGGXiPASvFuxkcSc2mTaCuJZZXvfb2WY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 18 Nov 2026, at 4:20, David Hildenbrand (Arm) wrote:

> Zapping PTEs in zap_pte_range() defers the TLB flush until after dropping
> the PTL for clean page-cache folios.
>
> A concurrent write fault in a MAP_PRIVATE mapping can then CoW the
> page-cache folio and install a new anon folio without a prior TLB
> flush:
>
> 	CPU0				CPU1
> 	LOAD(ADDR)
> 	 -> #PF
> 	    installs R/O PTE -> A
> 					fuse_open()
> 					 -> invalidate_inode_pages2()
> 					    -> zap_pte_range()
> 					       clears R/O PTE
> 					       // delayed flush
> 	// Other CPUs (incl CPU0) still cache ADDR -> A
> 	STORE(ADDR)
> 	 -> #PF
> 	    do_cow_fault()
> 	    copies A to B, installs R/W PTE -> B
> 	    // no TLB flush: PTE was none
>
> CPUs with stale TLB entries will still read from the old folio while writes
> go to the new folio, until the TLB is flushed.
>
> We really must process pending TLB flushes if we are not faulting the
> same folio back in.
>
> Fix it by flushing the TLB before installing an anon (CoW'ed) folio in
> set_pte_range() if a TLB flush is pending. Zapping itself stays as fast
> as before.
>
> Other faults are not affected: unmap_mapping_*() users only remove
> folios from the page-cache after their own TLB flush, so until then, a
> refault maps the same folio again. The exception is a concurrent
> invalidation that removes the already-unmapped folio from the
> page-cache before the zapper flushed the TLB; that is an unlikely corner
> case that we'll not handle for now.
>
> Note that we don't care about MADV_DONTNEED followed by a new read
> fault, as MADV_DONTNEED only guarantees its semantics once the operation
> completed. CoW faults will flush the TLB either way.
>
> For example, imagine that MADV_DONTNEED zaps a page-cache folio and
> doesn't flush the TLB (but still holds a reference). If the page-cache
> replaces the folio, a new read fault might map the new folio without
> flushing the TLB. That's okay, as MADV_DONTNEED did not complete yet.
> Same applies to MADV_DONTNEED of CoW'ed folios when re-faulting the
> page-cache folio.
>
> Memory reclaim, which removes folios from the page-cache before performing
> its own batched TLB flush, will be handled separately.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

This is really old.

> Reported-by: Cenk Yılmaz <cenk@deepfinresearch.com>
> Debugged-by: Cenk Yılmaz <cenk@deepfinresearch.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d2f48d78b0d7b..e1d9759e6fde1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5888,6 +5888,12 @@ void set_pte_range(struct vm_fault *vmf, struct folio *folio,
>  	/* copy-on-write page */
>  	if (write && !(vma->vm_flags & VM_SHARED)) {
>  		VM_BUG_ON_FOLIO(nr != 1, folio);
> +		/*
> +		 * Concurrent zapping might have dropped the PTL but not flushed
> +		 * the TLB yet. Flush before installing a new folio.
> +		 */
> +		if (mm_tlb_flush_pending(vma->vm_mm))
> +			flush_tlb_page(vma, addr);

This looks like an adhoc fix, but it is minimal for backport.
Hopefully we can find a cleaner refactoring later.

>  		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>  		folio_add_lru_vma(folio, vma);
>  	} else {


Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

