Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 427D6C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2581D6B0776; Fri, 14 Aug 2026 22:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F646B0777; Fri, 14 Aug 2026 22:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145C66B0778; Fri, 14 Aug 2026 22:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC9396B0776
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:49:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FC26A239C
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:49:20 +0000 (UTC)
X-FDA: 85101972480.03.9F126C2
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010011.outbound.protection.outlook.com [52.101.193.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D4BD1A0003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:49:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="N/W9Axs2";
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786762157;
	b=5FyO+R+NBnWiu3dGi30A88Z7ii2NHL+li4/1Sr/YOgQ/V0lfhHoVdU1YtzlphPCzon8lIB
	/jIK8WgrHk+JT1OkOeBX6PHJsVGG+Yi8JOBVPvZbGRCGFGfF0iSa5SBq2HUvxNAOVGxb2z
	eRLLUjFOq0snu1hpfzPbB5DJ6xVxGmc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="N/W9Axs2";
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786762157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTG4kI64exgHJAiJXJOzaExuL3tZULdrWJbDRWkEHcY=;
	b=DbnGnYtF+cRii0Rufh/ZwvOBq6Uv+lMGy52+RTxDJi7u5tY4lqtmTLAL8NcMvhjJGHy3kh
	22BX6ZdU0gf7hMTWsGuWnjAL73Sy8c7Eq/JJ2Y/mZgwvUyv6eDTuEaU3dFBoM+JmATVLDy
	7DnsZbG3w0CeJEk5BbH/fG8Hmb1yZng=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgvnKy6MvnrToT9DtJQNNi8VKi6zKLm2zO7AcjQ0QKrb8Y02B/Rlq2lAjgW8A8ra8KdxsIlpeI0yHgLpY36BkGI96nMpAyXeHBerdC+udt1yIyCIrgIrQbXUAwSYOnx/koE60qrbcf0vtkxSZKTi2vSIkx50t3qOSQMNOWo9lVzQOgCAGaTmhaspAhL5vcbFeXsAbwNOxKwbfvU/IRDMMExhyVMJBx1VkEb69m8si58PJ3475UpJwn67sdPoZnYFFnTo/velx43VZDbihdk27r69YYdhtW5pO0lrsG6D0EDNtKiF2roO9imqLrr8emmfPSdKhVepbE5BlJiX2lZTmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTG4kI64exgHJAiJXJOzaExuL3tZULdrWJbDRWkEHcY=;
 b=giEmwXWJV0/418FCcI4ey+Dt4Ebs+B6Uag48uZYnucbNPazFvdyGhYEuwgHDutxr4RVDaioVDuIFdNwFBXyNPCsg6rsSkMFSn5CMiQxzuNa+B2QIDOrHR2rq+cmoj2KCs4/q+sS4f8UjImk0rjbtP0lvvhaqxYNHWb8PD4zejSAP54T8w4N/nI1KmcGU1xHwIzvEM+LHeywTCxftQh1qGWN9N+uAE2kRz4AsugV4fKt2cRFdkmSXKluVP79ycFtStqmOxAUhvroiCAx36mFv7pplXMIzPhlPJ450fhz+z3NKqKDhlPnm/PvcCvGouDv/dLbf+qTJ/wZKYGK1BxrIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTG4kI64exgHJAiJXJOzaExuL3tZULdrWJbDRWkEHcY=;
 b=N/W9Axs2jDXDGlzDhEBrJNF9nkNbZkZMA4tvmgDij9sNqMaunoxhdz4RWYJTM+nwuBqQiVR8rYwkAovfBofNyBGh9rqUF4ZyuYd/xrgtO81bO2fNvuQBY1cWRTixlIDmjMXOcvIsK1Zm7A5WJUabau6WGBHBRi0liiaA5WaER6wjiDkDtjCN0/FfUBM811Mmsty4lbfo7UNz0hFbxBRZtGN9gvQFva5vCObn0qLc0GGdrGUmh5jYsdzVGkQSpdEnYZ5UKC4/JSMaXXpyQYvHelh9EkLnGG3UH0dSxAmBX+OnHZ5fIOjPuhJ/9vQ77Auaztby/tcS3lzHgtW7GPwCsg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Sat, 15 Aug
 2026 02:49:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Sat, 15 Aug 2026
 02:49:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 22:49:11 -0400
Message-Id: <DKP6BKJMNMNF.2DGMV4A5WM74W@nvidia.com>
Subject: Re: [PATCH v2 06/17] mm/huge_memory: consolidate irq and locking
 for folio split
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
 <20260813-swap-thp-cleanup-v2-6-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-6-d2ee48c6aa49@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0298.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb3c204-4577-4f75-9149-08defa77ca32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|11063799006|4143699003|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BaTtn7kd7onRYkNDLrNaSfl/+8p329N+oDI1qcZY8BxB2QuNy6YbiR5NTr2Am/1x3t5oWS7QLTvdZZ1pDqLcm+jX5qnH3bI7VJ1R0I1DMoQNZQhhGBpAEnoMSmpK37DckTWvVDeoA3/5WhFUO4FRop3ptT9sLNhUBogBcXikz81zdf+CriuVfBibVlQ5s88yJJMmFiW7Gsd4SLooxYamNVtPwnIBV74cZIx1xHAyZQ5e+TlCRc9SADt1ePq2m2XBrimhfaQhineW7bXe9/Kui8PLFjpEa8jhVz8qL/VWLMnDr+dSXlEjAIF85aH3pvbdRRa7HIMleC7zV7Ou+0wCndxPUWEkqhnmd3Tilold73tJqXZPWLNbrDJqf5OeqRi0WjIpIlrPsP+0EDMSh5hCG5ciJnayQY/4IsfpGhxS/5vfVT/pfUh/27Ay81QC9R2jCg0X1A1cAWs22/8kOmJvjxg6guaeEOTII5wnCtdh41wkog0cmHDGXlszpsn4lucAzeBiKpFpMW6jVmVb+/aqXjTRQfGhvhMX8A732newe7r3cZTet4A/GkuJGxjKh4t4yTHkc0eOkns4AnHQkKm7XYhdXi4MpipEFy+oGgP27MfUPHHWQSWi8PVK/GMMxXzA62eDHgktmEJxPzm6UKc6H+6etSfcrtSkE9q5BVy4V2Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(11063799006)(4143699003)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NndRREp3Z0NZYVJUZjJHSXBrMnpLdmFJN3Z3M213R0tSZXlOcWpiSE5qSkxW?=
 =?utf-8?B?b0pLcFJjMGZZSEdYT1FrTmhNTmY4WXJzUGlPSGY2a2JLaFNMVDZRNTE4b3NF?=
 =?utf-8?B?cDV3YlFFb0xDZjVZZ0tXUjBiWjY4a3hvczdRMEovNThCRGhROE4zVGNsTWcw?=
 =?utf-8?B?NGFKdkJYU2Y4V0JUZCtVN1EyVkRUUThCaXFXTjNMZ3ZJR2JrVTkzWnQ0cnRp?=
 =?utf-8?B?cEdxK3ZKQWdTMVNlVVpXVzNMa0M3amY4Z1UzcTd1Y2UrV2N1WTJkbkRZRmZP?=
 =?utf-8?B?ejRWaDlPOGtQY2Z0YVR2aG1KSzIyY25IU2U0OHhhTGcvKzViRCs4WFg5UFVj?=
 =?utf-8?B?SnRQd0hlaW5wYzUzRWw2UXdyRFgzS2hJWERKZUVuZUNuVW42YTB5US9CSElt?=
 =?utf-8?B?SW5BLzJXYnFyR2p2NHVwWlNtSmNlY1RISU95cXlUcTZYZkRKNkU3T0hzdFF6?=
 =?utf-8?B?ODRDS0xIMUZXaVVjV3VYb1pkNTFEWHdENWpQcmdabkVva1YybzlZS1dkTGpr?=
 =?utf-8?B?ZUlWWmxPbGdqQnl1T2ltWVJGdjVLUzJta0o0SW1JM1hjOEhUWE5wdzF0WXhD?=
 =?utf-8?B?eU10bG5Dd3g2akFWT0NaNTcrdFQ3TGhNV0NZMDcyY0w3TlJHQXJZRFpldDFm?=
 =?utf-8?B?dUJJVlYxSHBkQk9wVEg2bzMrNmg5dkJFa0hMeXB6bC9VUC9IblpUbWg0eUFw?=
 =?utf-8?B?TkNHcnc4SUhiaEhtcEN0VmQyOTFaZkgvbTFzd0c4K2x2NDZSWWZBMjd0UllT?=
 =?utf-8?B?dm53S2NNN2dnR29QZVZYd1hYa2E5MkhjekgzRC9OeUI5azc5RDJTL1pNNk1W?=
 =?utf-8?B?eEI5eHhmbE9DOTlyRTZDd2dGZ1NUbVk0clZrVjQ0S25yUEhOV2JndkxuN0hy?=
 =?utf-8?B?amRKQ1U2Wjl0Yk9kY1pZbjVYeUlUQ1pBZjRUSXpDNVh2dlRQcStrZjFaUzAr?=
 =?utf-8?B?U2Z3emYvTjBCc0crOTEvSmdYY2kybTVFcU1lVVowNUZ0UDd4ajJncm9adXh6?=
 =?utf-8?B?RnhCbSt5a2NjMzgzVitsSVM0aUZyTkV6Z2lBSFhxVjNDT2dsQndNVzM2TFNq?=
 =?utf-8?B?cUFRVVNzTWZCT3RHNWcyVzFqV05ZaTJVa3paRnRxZDgwcUxSNzNlU1E4SWZM?=
 =?utf-8?B?YVBtMEZQNENLRGJBUHdBMWt1MXJxTi8zbDBWZXU0bzBRL2J3eFpoeWhFd0Zq?=
 =?utf-8?B?TXM0TXNMZjJhOHRuYnp3N2hGSW85Mm5pb3krMWx0SlpMeTJzNHl0ekxhZ015?=
 =?utf-8?B?ZEdHYUFKTmwzU1pBOTJUckhBcEFOV0Q4Z0ZWNWJYZFJKeSsvYW00SEpyOFBk?=
 =?utf-8?B?OEhwTjYweFNpSjdHbnJ1UGZoTkIySXU4TEd6THdTSVE3RmRCT3F5Y0pwUUsy?=
 =?utf-8?B?bjM1VjVyUVNaeXRBeDErRkQ2Z3J2dXNQZTlOQXV5VXd6UEJ5bkNBdGdTd3FV?=
 =?utf-8?B?QjR4Zy93Qk8yWWhLR1R4dGlkbUpLQVd6QWx3ZTVZZkIyaUZkeWNMeWpKOVhk?=
 =?utf-8?B?YVl5aDhlQkduVkNGZUZnRkxQL3lQMFVNM0Fab0xtVTNsMjJqNWJUYytycFh0?=
 =?utf-8?B?M0lWUUpaZHl2VUkzRHNaUFJMaDM4dDVTR3VQVGM0ZHFnVVlsdjVMbUNVVi9H?=
 =?utf-8?B?TG80KzhSTDcwKzUvZ2pOZFNHTm5oR3BSNUFCSWVVZTNHZVU3MGdKUHFHaGxI?=
 =?utf-8?B?Q2MvQ3R3enVlNVZNZFBUUDZOMWlHUDR1eG85c0tjYjZwNzdIMUI0K09DODdQ?=
 =?utf-8?B?S0h2aExaaXozQ01pU0xkN0Rsdml3WVZVTndJTFZwbUNRMmVMWGtaZzhrUUg4?=
 =?utf-8?B?cFhJWHk5YStybERHUVhLYytnL3dJZHRkOEpaRFdGZ29mblFveXdSd0s3ckpF?=
 =?utf-8?B?RVZzQmpPMTZnMVVPMnFFTEpSOG51bmJNM1FyYUZ3K1dzTTNMZ0RobGs0YS81?=
 =?utf-8?B?MlBaV3l6aUdVVW5DMVF1WWx2cVRQYWdTbWRrakY4SUxmNE5iNDBQUjVOeTdx?=
 =?utf-8?B?eVRJUEovODJha2dwTXBJanBiaVp5LytOaVlnTEJuYTQ3djNBK3VLTHluZlVu?=
 =?utf-8?B?TmRMclpQU3d5aVBXOFBTVllWYnhGNjg4VGNheXR4VUpDOW5CSHB1NkV6dUlF?=
 =?utf-8?B?bFdkZmo4NUx3ajBCNVBWMFkvcjNOYkIzMXpSeHpzZC9DbllRYjRaRUNFcjZz?=
 =?utf-8?B?S01KR2g5UVUxUEFkVUxyUGkwdWdsVGtHd2p5Ynp4SE9HMUxWdDdvaFpXRnRL?=
 =?utf-8?B?V0ZBQWoxWVJTM1VYUXZRSEJPbUFmNnl4OW0vYllhN0EybmV5U0VJbmJublJt?=
 =?utf-8?Q?Pk/D/tqTjzDT/mBUIx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb3c204-4577-4f75-9149-08defa77ca32
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2026 02:49:13.4856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DNI4Q4RjkwGLSX0pLdnRmM7WNJv8HwIM+rwJf44xGNhM6et7FlzxMFoAjSJTxDq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D4BD1A0003
X-Stat-Signature: 6jz971gq1uzztgu95b339mohswxjxgt8
X-HE-Tag: 1786762157-858241
X-HE-Meta: U2FsdGVkX1+G1Vqvkm44Holh2u/x2BeLohBC5xdY7o0wzI6w85Ri8yM9zj6tMDgFG0Jff/KZd09y8Ci23NHDf3TnDoq0N5Q+/GCNfN3NsyEc6FeggYjJ3ANCCesj7nl0oLvH8Vgf+IOMKtejov9JisCTs47+Rpd5IDvet2H5SjdAoimti0a3tqwCYhpOLvL/JcxcCUuw87iUvde0svhyKwbrCKTQLWZIkVUcgyYFFCfIs0t/eHVtH3HeDY86kt0ykp2V7e6Qbqz6MohF+ubxCvhL+g9IfsxSSaxeqa4V1SfUO31WmOyGjn7fYkTPreW68iXWrTD1BlEnk7uJYSuLiYuFy3+skpvg+ebPcwnEA8o56hWgSn3E5FqosdcbiaIQnoZA8m/jw6bncoktYxxazkyHAj0Ym92LjzfhO7F9VnHRYNk5wXvuLg91DwytFpEn8bEkTFsLjkfzVj89WTqNLnUModblSAiWiH9rRbxJNpd/sXyFCjxY/RmbrYPYo5XMXS+fCnyNf8P6+NK1AJCYhZPS/fQlDuwD/8CxWXbSCYizz3o4Shdk9/YWoJ9xehXR3mj8lO6vtdA914skOuR3ogN/4Ah7DnJ9LhR5gC6oeSIXKg1K2qoUtWR0TPtsBag1Qr6fxEnJ40jAEE8vFvfoH4KaoSAqkGi9zxdXb0xPxdzte1W+ooxjh8MmRdMiJ2bJvq+RiLs6gMdmR8lwEiCEzYzpipySbxiD6fKR3AtNlRTSzd8eoK/77PPX8IYJgdiUrCHSU93MRRJcdIXBW6vZIPiGU+30IABki/JrX7APNPZK95w+IIyfL88J/UopSFrzMiBrHecg22m4AjP/IYTbpedjp4MMdkMnnmZgqb7+MUZbYGqDOH17VgbAiQ7g5St16aKdt+EJFr2JrI4u/R89/s/dHILELm3DSLW9yjeue2QPrg7zDJpfOqmAOm1Kr3c4Dh/JN38sezTI/OyrLk+
 vZ/WbwS+
 K7X3bFoxRFUeFfcboUDitgSrhcWfaCUQlyvaErQMvWzJ3m/u4gxSa1zs/6o56SNXEUtvbmZ4a7hi9a2Kedxu3Je5vwtGe21tVEe+R/zHMx/nHJRKGg0d8wvpNBw5DHrIOed3eY6FIR2nqvBX/BUbsF2TY03yZZaIP/XgagX379MfZU3bsbrGv8iabje/0+0ddsTd8gBAHgUxKrCTXZZKrIogoxAcnqmaIY/E/PIn37yTsCsE7JVybE8hV9U6hW1xOjCXHIBiESiVuWkFGRqNS2x55NjygUjt7FnjDp+ZOkyylE7UciV2f+a33dYFacBS8XYwVrUCkI8FyKe756+33LE8fPZ3/+HKn+pa1OXAxn44oVsY1EN/+3UrbK92NhA90Qc4StEiKvprixkYrAhvqd5cPGBgTrKBuq7NK7vm2kMKNvUos2252wfAUGxnAZzN06Q0P/XjMAOhq9Kg8V5WHXFKkVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 12, 2026 at 2:48 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Let each split helper handle its own locking instead of relying on
> the caller, so both helpers manage their own irq and locking state.
> This lets __folio_split() drop its local irq handling and fail label,
> preparing for further cleanup.
>
> The file path now uses xas_lock_irq() instead of local_irq_disable()
> with xas_lock(). The two are equivalent on non-RT, and
> TRANSPARENT_HUGEPAGE cannot be enabled on RT anyway. This conversion
> also buys consistency: every other place in mm/ that freezes a folio
> while it is still reachable through the page cache already takes the
> lock this way. This was actually the last plain xas_lock() on
> mapping->i_pages left in mm. If we are going to support RT, spinning
> on frozen folio refs could be a problem, but it already exists in
> many places and should be fixed generically.
>
> The anon helper keeps a single local_irq_disable() as before, because
> it has to cover several plain spinlocks at once.
>
> The dropped xas_reset() was a no-op as the xa_state is not walked
> before the xas_load() under the lock.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 52 ++++++++++++++++++++++++--------------------------=
--
>  1 file changed, 24 insertions(+), 28 deletions(-)
>

The changes look good to me and the commit message looks great!

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


