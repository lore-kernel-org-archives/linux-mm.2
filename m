Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A53C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 01:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6FA6B00ED; Sat,  8 Aug 2026 21:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DEA6B00EF; Sat,  8 Aug 2026 21:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165DD6B00F0; Sat,  8 Aug 2026 21:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C332A6B00ED
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:59:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D051403F1
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:59:16 +0000 (UTC)
X-FDA: 85080073512.01.652EA05
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011048.outbound.protection.outlook.com [40.93.194.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5A4D8100002
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:59:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L5zsBul9;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786240753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zFXC1cabfAiL4htnSSPQYKMqiTpluK0c56uIOj6qX4=;
	b=PeX8KY6fSVUxSBkV2HegsTUOuguF3fe7g+q/VAa4OF3hcZLoITRf8f5wLcVEqP30lFQaeq
	9blcJwxy/0msX1V2mXyY5+n1/3zQMy6hwKt2K0hordLWy5iBWOy7WNiZoWvNCCZ3NxHu0J
	ENZL4I2/2dsGwo6PocJVtonOzTvbgVo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L5zsBul9;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786240753;
	b=zjL8VICDy2WqU6lG8SWEmQsQDesFSkiARa6s2ludW1JGUqm4qI8Vx33xYaoiX+LyKvRrpA
	uoQ19/lEZmUL0HR7YzaIvkgBO/mqAQw4MMxDTJk9tUxJajSCYjb6n3Yc4ao4SN550Vt4Ek
	WJYrYX0gWNX2NBJWK4CHJu/Juo75vD0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jrri64lflP+e1TtoTe8I5akVQAahk1MS1PMstcPhCFIhFXpDYEkW9dmo2Zz1vcI0htGsiFDUGpFPcq092Oqv1pJ8ix02duVRskxpyPUGQ7T4m1ruquG1wT9ckRIeGGvGUSQYJ95UnGBCLxG9BNQSsQM/cK1l5378x/gcPJBin9j56ptOQjvlz0V9dUJTKGSxyJBjLNp0sqHHqiau2jQFCYhncqjVSMWQvwF7w6QzBNo/fTQrPEi0DC8PGto+3/vja2+5/u7go9OJuQE1xPEgAAMTRdMz2K1NHHgCMqQf3HNPiDO0J/keTSY52t81DtPRzrW1BCNFhs4Jfe1SJCMmhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zFXC1cabfAiL4htnSSPQYKMqiTpluK0c56uIOj6qX4=;
 b=rMwRSqPGcHO9Av95jcmN1UPMU417El18u+Axb5yBbznSD+rM+KyLGZVW7sI31lwAwj8Quqq9sqz+H5sXoqDDsZa3kiuNl+vUUKi9+6F0Gd0uJc0Vn7Xy8y0zNyvFVEE9pfi0HgE4993zOsTU/32Z81N0t9rkKiWj2+MAgwZHQOauBuvTSAZWZ7szNO2iDZbE29RWyiut5oF5TFOUjmQNyFZOqK+IMQ7u7dwJubdI5tWrOsNFyDi2S1FIrO97fyAIT6NmWVRSExmBa2xBeDYWxfcFUNutlhO9MN27TFj1Qb/nuvtyfDPXClzUCVMffP4tD02BoUW34zUzVO3mgwJlLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zFXC1cabfAiL4htnSSPQYKMqiTpluK0c56uIOj6qX4=;
 b=L5zsBul9Y+srXrS/UtoriuNq3Xw2NIibj8T4I6+QuexoqMTtAfMadhKLhE3cDT4pdMcpVWyIHgyHMNkrjGOF/lkXulhqQV0yu80qO4MhcOMurvNTjACE67SGfB0/84b665FtVNyy3/4OVTqagaWSwP6PIKWS3iMoBd2xmd2yprx6caKs46LYmEAMklQJyoi8t80c8BAmyL1Hwa5GGOfWswQT6ZPs1SziG+6Fqm5+bDln9Y3vG2zJxK4KjH9p1Ch3uj7de432b/cN4UWD7A8WT1p6t7ZQHwedvEujpQCXV+TQImdDYxyRa1Udpum2JQ8LKqBLtrZuNjyozQxgl+RJmg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6258.namprd12.prod.outlook.com (2603:10b6:208:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sun, 9 Aug
 2026 01:59:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 01:59:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 21:59:07 -0400
Message-Id: <DKK1HZ677BAQ.1KY3MDB1CY4MB@nvidia.com>
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
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 06/13] mm/huge_memory: move EOF trimming into the
 file split helper
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-6-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-6-689939a7ccc3@tencent.com>
X-ClientProxiedBy: MN2PR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:208:239::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 27be6df4-54f6-4e02-8e0e-08def5b9ccc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Evjr+Hb1NcipAucj9Oy9vdwL7xlLsiGl2aodwTqRoAo6EoHU8pbrgA3YdT/LPDy9QoVUm1R98VPn/uqC91TCWX9cRQLiHfMj+kwYRcpffRrdZ/h9wtBCuTl9VLX/9GJ/AFHooC+BFjwPPIkprJvENByZkpVrSWR1Dynofy3Bu8uD3pVyEUAjys1N3D3hOebF2opmf2QHoE/6vgiluZgz1y3qqO3AB6sdg7DfeYhk4gf0XsC/Ik6BeRUNhPSJdjvv8LeCzocyz4gUoyS+tH2HHtKwdDEIBpSXsFs3u8deYESqjs5EU/10ZC7VN7XpUWdKN5hoxjoaMsa5uuqMQmBnXVf3fE/6/xfImo4tta+fRKQvtr8Z360zuinPVLgk92BeBRgkdixfYEasm6961mTz0BfXyJd2LYi9UVb+v7gj2fIWqlbaCx+ZV2mWdlK+lZkgSG0KwcZifLuJ8PVnq1BEM46xFOhaidzYEESyoGYF84CRY+v3Tl1PMO/NK37lCWPWE0USKrnc54YjPTYxeAhYfEUckOVAsEK5ZVJ9t29+fAGS84ns2Abr4wFWnvbj8/LO3QionMupZbS1E+ZLvEA3F4qr2qP5aYx2XpoibePfzJBgE5hZ9V9SrhlJcovigy8PyNm4TnpWX7BSBv7dzZR0a1qvqNG4hWR0S/EJo8fFEvg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHNMN1JiTGdleVJtVUJ2UmJkdjBac2ZoT0NsTlFraTVpUDRWbFpMKzUxTFNj?=
 =?utf-8?B?c3RRY3FlNTZjSVJyNFpFZkVtWlpmUTNTeDFRWFFTYTIvRGxIZmt0NjFFM0JP?=
 =?utf-8?B?WGovblJBUFNOamRUeU1ZZndKbGJLSVFIZ081R2pQNGszU1J0UmNIQWxnYy90?=
 =?utf-8?B?bkxWYVhGd2NhSDBxUXMrUm9HWUtSOGtsTWxieTVLRkhtbjkxZzRKV0hSN0Ra?=
 =?utf-8?B?SWxQdENVaGZadVVkTnpvMGx1RnJSWUlOOVM2aFc2U2RKTFNFdkVwaGR6a09Z?=
 =?utf-8?B?ZjlUdHE1MVlPN2E3bXFOMXJydzdDUkRieWtEK3dHQ0lVbC9ZTzNqaVBzVjFC?=
 =?utf-8?B?cGpFQ3NiemFTV3pNQndVM2Q4bEk1T3NEbzE2SGpadmRiRHpQR2RBa3N6dDlv?=
 =?utf-8?B?NEVUNkYxY00rdzBlTzdzOVVudWxmYVo5M0RGMUs0RWxFT1JPanZQWkJEWnFD?=
 =?utf-8?B?VHZhUERkOFcxbnoxRHRQeHBzTWs3WW5VZVVIS2NFbnB0bVY3SzJKOWl0UHVE?=
 =?utf-8?B?RFNWNGJLcWxLdnhLMGpuck9YMVp1M1RrUDUwd1pzYk1lSDdxTGpyYlJHeExq?=
 =?utf-8?B?d3VFQ25PeGxKTmc4KzIzOUswSmp4eUJMTFI2RTArNytQTFRtNzhpM25zU0FF?=
 =?utf-8?B?cUlCMHBtWXoxeWpCSVRyc3BiTWJBeGxYcmZVVFFONU5vN3QveXBMYW4xUWdv?=
 =?utf-8?B?c0NHSFlCNFcxQTZ0ZDNFa3NvOUg3Ymt6SXA4SzBFNzhxRWVGTE1PeVJGNHRP?=
 =?utf-8?B?WmFNcDdoaDJOVUxsOWxGcnl3WXFBcXptWG1laVBtUGdUaDlxaXI1THg0Yjdw?=
 =?utf-8?B?VDFLTmZKcnQrQTl3S3h5MnV3YkFtSkljMUE2MmZmNzBmNGZZOWxwaFZ4eVJz?=
 =?utf-8?B?TVdsdG9tM203bFBucTJVUG9qWE45VVpNMXN1S1JQYzBneVYvZEZhcm1vN0dM?=
 =?utf-8?B?WmhOaGZZcjZXZVNBWlpuUEYxYktpSkhUcDh4dTNNUjhPUjdVSk1PMlk4RUxz?=
 =?utf-8?B?cUg0aVRnaDRxU2d4ZW5wRnpqSnFCY2lHQTR2VCtUY3BwN2pHVDlNc041aGZ6?=
 =?utf-8?B?TFdKQVk0S3BSdkxjUmg2MzJ4K1E1Lzhwa0hjeFFLNndlb1pwK2tDSExQUmV1?=
 =?utf-8?B?S09wdHV6aUxubGtLbFg0eEtJZlhoWlYrMU1sNktHQlg3RURpaWhNcU9KQ25D?=
 =?utf-8?B?Rkoxd2F2VGtzdlhJNDNBNkw1eGtFc2ltNHFUTnBNMlNQbmJ5S2hFbmZGVUlS?=
 =?utf-8?B?ZndESzFSREdGU3Q0TE1uTDFEQlpmNkQybVVLOUY4cGVDSC9MeTNaS2wxY3Z1?=
 =?utf-8?B?MVNHS1d1UXk2bzhlb1FnVmM5RUN4WWhmaG9qWHBFYjFPUGJucjd5VFE2OHhM?=
 =?utf-8?B?MFMvaUVMaWw5cGVJZDZYN1VIeUllQm9RQ0Voelc1YXdkTWdrU09DVzZlSkln?=
 =?utf-8?B?L0ZPOFV2eWIwTEZKNngwQW02RkxHQ0pBcUxWTHFmL2FLQnNKcktGdHJBbXIw?=
 =?utf-8?B?NlJSendaNXFvNndBL1dFT3ZSTU1jemNhSE0wRXFvSWhESFM4MDlOalNHNi9s?=
 =?utf-8?B?UjE0MlpiU0YzNDFQdE5oM3J3R0FMOW9lL2dyOTdUbDd4MHg0c1pGOEJJMkdo?=
 =?utf-8?B?Q1dwY1hpTEZLNHVrQlNiNjFqSGJadnhFcExIOU1ldHIwcFNFSDdjdDZzUits?=
 =?utf-8?B?Q1hsaldMZWZhbmxidEF1SVlYR21zdzhnTnQycmJnT0VaMEhLZXR1Tzl2ZW5K?=
 =?utf-8?B?WW9hL1czdHpUOGJScnpXaTFpbGZVbzQzZ3ZCZHVpaWFZb282dTllUU0rZUtL?=
 =?utf-8?B?MGVnYmhxRTA2aFBtaTFmOXhxRGxVWkJGbjJMTE1IY0tHQmlLRlUwTmFzS3ZJ?=
 =?utf-8?B?eCt4M1h0OUxBV2N1c0s1UzI5dGRwZ2JlbklWYnBSeUlzbjljQW1pUm50QlJh?=
 =?utf-8?B?RzJCa1AvaXVnSEE4dE1DZmdpbDRhbzRDWVBOS3Q1WFZFaDFxRHM4c09WZkRi?=
 =?utf-8?B?bXZoSzliNjBvQjlUazRoR1hIak9lampNSlF6aG8zeTF6ZFdVNldoVCtHRGhE?=
 =?utf-8?B?NHhPS3dqN25uZUU2NGdGZWwrMmpWeDdPODY4dmY1NCtFVFNmOFFmQWNONEpm?=
 =?utf-8?B?eUMyRVZ5bitxZlJWSCtKVWpyNWtHRk1Xd1ZYcEhVMGw5Yjk3VUQyQ25QL3Z4?=
 =?utf-8?B?K2FrRUczSitXQndBUW9vQnN2RVV3OFFoT0UvdGh2TEJ0L0krZWs1eTZTUXlh?=
 =?utf-8?B?VVY1OGNGWjZCMld4a1puajNhRGF2VmRFdU91OXlzSXdYZlp6MHU5M2VobGZZ?=
 =?utf-8?Q?bfb4pceT8Yb7Kui2tO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27be6df4-54f6-4e02-8e0e-08def5b9ccc0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 01:59:08.6969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 954NYgPLl4+RgjWqS+JKSLv4/3I/TGY6/Y5KCAeoIN8b0ZfQ3QPXXiFGttR4gdSe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6258
X-Stat-Signature: tt3w65wcgisri8gj9bo63y9gwhq34g1q
X-Rspamd-Queue-Id: 5A4D8100002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786240753-655145
X-HE-Meta: U2FsdGVkX19HqIouW9OzzdFVZzGHPwJO/11V/tCiuwuGFuWDsEg35Ql4zwUvAiJzj9KrXCV7SC3Ls1upbfjiic4VZwbgV2N7uBMxb4THmHAwm08YzYiu0UeAikSuO/RcIi+5e5yQorD8BS9VRKlvnc85YzQH5Gmrce6otJFds6AxeoWsZpB56dDPlLAiZUpDjQlTQtsRr0lwyeVBe4MHxCa0rsDITq6Km2PAQy6zubgv1Z0q0wc/t4BjBmBRk/d6Z0K2EcqWQFOB7tlVQx5oBMM/xn06zYu31ZTd4/Oia6ahtSWDxdrS03WjnrEvVfWq5Pq2ghRFPJNO28rfy0QzL8yhD2qCtEo4GQRHqwQD2qMzzSD95NcdbzHwnDJA6tqbu6A5/e9tMGJzRXT3xKrTzYcyi4NCE7GLKMx8wYekr0lLctO50GCP0u3xCUvZ+YhK6sCy+W0Aq6O9scNuxb/W9KeI8fGj3x/hQPUfaSzqEWxKtjUHPW8IxYaxU+DiVGZjtI9X3HeuCgE/9LkwoG/Oav+2FK33vBDOPuD2Lq1y2iWl2hcBJEvPb3dRXupQq/iubk6E7vAIHMq7PDyKL/5QJu0jn4LRv4JZjWH7t04gEOgbkWoWiNktaykJoq8n9MPpA8aVt1n1tu3+pWt0O6RLpkYqHFxx3a7lRjLANBT65eBlFkFWdvTAI1m44iceI/a8e4owCMYE6GQsw33rKI5I+S2a6rY6sw72YNMWr8/J93a9/gZ/1uZotf0OVjlo/VsQTPIdZPDIyivLEiPkY+X2y9Qw57AIu4ENQMrucK994ZF+B+5g9nTPjA/8tcPei7kN17VIylwk3p6dlWFbEw0cl4NY7/6IM36yMT7KJota9UnkhPn4DQEUrwfhlX8+BNUY9n10PsDSFmsRBT2E2vbGXYPRcggYfNzh8KX6iXgtaa16IAN2NUQ/HGToRLe05LZZIRoqK96Sjd9al2w5Fxa
 lE3nvrX0
 Urz1VitgxXUd1piwb0V2dCBpGshymLqokyY1KOaJ2g4hGU0yp0z7LPVlmjFpWdWiOz0D3NZn9p+REtRx/ELvVvPONOlrd73c806GoRIVBmsizieo4KHiP5d2yYiDD/Rt/cJWlsLhzNnG2qJWWieAJmaGmC1BHwWKht1nqjsuFEA442/HS1b58LIdAnEvnoBVGKdQVRBjwWY8Qu7seF+BEyqGTkkK7voqZmA2BXK0lPY8xJVKVECWx/otdt1CbU8Svud7GIPTh/KEqdPEbUL17CyuTc41iKoP8ii8+Z+czzP6I32iYwfVxxLEW2sxaES3EoxyvONuUmO+HZOjDIy/PEtEgv7AhYoGe4FG9l8rcsk2G50p6npf8JGEG2igdeAdCIWI+OKWCKNyNcCcAK9Yd69qzK22TB1XDhfTVNDOrRhyUIEhPLSIal+0fuKnTm7oA9T8793+v9cNNBN2SKtJlRvmjWLcuIInZtDW56FrQfDj4Kjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Instead of receiving @end and @nr_shmem_dropped from the caller, the
> file split helper now computes the EOF boundary and trims pages beyond
> it itself, as this is only needed for file split.  This drops the
> redundant parameter passing and sanity check.

And the end calculation is done under i_mmap_lock_read() already, move
it inside the locked region should not change code behavior.

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 42 +++++++++++++++++++-----------------------
>  1 file changed, 19 insertions(+), 23 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


