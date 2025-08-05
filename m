Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C540C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325666B009B; Tue,  5 Aug 2025 06:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6CD8E0003; Tue,  5 Aug 2025 06:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1771C8E0001; Tue,  5 Aug 2025 06:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 028E16B009B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:37:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A98B31DB71E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:37:02 +0000 (UTC)
X-FDA: 83742351084.28.77432DE
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF5A640009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:36:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FUd476xP;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.80 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754390219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEv0n4I1lQFTIOCckh0ApS8kQ51k7s/LlsHmJPxHutw=;
	b=E/5P7i9HngvNtPSs3qWxEf6ZHBH7e/lZnWLTy3Xdxj3eGz4cCJJ5P8TWk5RWH6XXFAfC9T
	quhEMLbe7WFgkz6TtiPv6WOg7VnuiWKZ0M6AspDXTUOuB9CJthz6PplDKx8FL5VJWAxlk4
	SKehqK2+//69ZyU9ajfrg8ZAiBDPQ2o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754390219; a=rsa-sha256;
	cv=pass;
	b=V4ljAJPV4Ai4zpHlSxFeLTfBGVBHHLv5+6XJfhzb9RSiKYvTmxS1UQ3ArMMX98dsUfBUgl
	zgZNpFLYOyHHBiFfEVmTekU6IWxuSXNmAQmWiYVEP1GKGHLNXPMMB/PIQzHDWl77h63ZWL
	RSb/up3LK2ppaRZiCRRMmQnOyYGY3Hs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FUd476xP;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.80 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Co2x11bfYVIAOmx8Y9hDgdCXi4yN9BxZRdlJttMpH43ticLzKRSqIIHHm0BQ6HcJxUFzYn3QrKVIYl85d/uM/KZ+AXlAOXO28PI5viWlPbUXqMuqunuOckIvKosgM6gRBrnV2e4XYEjaKhPr0DZ7vaVabw6yvyhRCM0DXvbU4lbUtgPAo6EA4gsGh8RkTljwzULkL/5UxotHAFUpD4aNz2iDAbW80SwldAPD93l9H4d8O8eoU0+OquQygv+i2HOubPAfSbIRg/Ci4ZiS7cli8+GBWp1/0lp2Hi4FMwG5lX8sd9cmuxxlxjPiYxf3YV+z743c8XzZ3Ucir4Mi1Y+Jaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEv0n4I1lQFTIOCckh0ApS8kQ51k7s/LlsHmJPxHutw=;
 b=p9tPsfLzhnR0WMiqNolrb/gPUdIlY0BM4nCUqo1gxDgAtltiv5M3rXEoWraVbhHWntFgHkNQWtBdd8+k8L98Nesc00hFXlA0tVHw3DKHnk4l+5fQa4BaX2XMZfRqluC0u7sO2nvfwG8SJZ5DxVehks+v515Nvy8kZMy6kzj3RX1pBNEkvG6pYR5mDD1sX9EeKf0x4Yqi1QrE3sJi7rkq9eu/pZ09HrqyG4GOfX2obCVvbgyOgSbNKa97GYFK2WrxKuEhUcgsIZFO/q01Nss209Gpi9ZA6z3wNJzcELghAsgQMJpn7EQuaH0idFJuA8CI5m8nUoTYCk02+3dmGpL8ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEv0n4I1lQFTIOCckh0ApS8kQ51k7s/LlsHmJPxHutw=;
 b=FUd476xP2rPl99G8UT7CqLc+lmPUEoWkwRqf9TqVPREvDorxlgIOlLBnyTS+kJthBga3gs8byUn9/hULqIeo98rkTH4TCbhNqnOacTPQsv8uEfnj9jddHcKVSPRQNc0EEgxyrL3PCCXmlGgn4DhUOziwO0nv8IgYLZOrCeVsChtZcv5fe3Q2YR0uO8MthhXc3n96JiUgTeYBMGGkrFgczdXNUPop9ykjZ73tv7ky4fysiMYgaJbk9B3Cw7Mj3iqoS/BsNP8BJLTIOGfmqG6maFPIprXaaVdWkDXDFqcLQ1j7PXBlQfID+LC2HQNVYmXJ6MCs8ElqNaX6QcE1jdeEQw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB8956.namprd12.prod.outlook.com (2603:10b6:a03:53a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 10:36:55 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 10:36:55 +0000
Message-ID: <6442f975-6363-4969-a0bf-55d06eec9528@nvidia.com>
Date: Tue, 5 Aug 2025 20:36:48 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
 <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
 <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
 <f3e85850-bc5b-461a-9efc-d1961fb5d340@nvidia.com>
 <196f11f8-1661-40d2-b6b7-64958efd8b3b@redhat.com>
 <ede98867-bc17-4894-a375-d17d8f83dd55@nvidia.com>
 <087e40e6-3b3f-4a02-8270-7e6cfdb56a04@redhat.com>
 <b3f97ffd-2e25-4df6-9da5-65264ee6916b@nvidia.com>
 <6a08fa8f-bc39-4389-aa52-d95f82538a91@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <6a08fa8f-bc39-4389-aa52-d95f82538a91@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB8956:EE_
X-MS-Office365-Filtering-Correlation-Id: 69386ec2-b4cc-48a5-de15-08ddd40bff98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnFtSmFwSXZsSll1TmM1V3VUOGhMcXR0Y0MwSHhIcEpFa29DTDFpM2VwVVpY?=
 =?utf-8?B?aG9jV2ZWNEI0SHMyZ21XdDFVU0ZOTkozOFpmQ0FkUFlVdFFXaVVlRDdTQWhY?=
 =?utf-8?B?Y2thMFJZSlNKbm1ZUTdyR0ZFd2RTU2hxQWd5NXJtRmI1REc1dUJZRzI0Q2NH?=
 =?utf-8?B?c2lhdFVpQzdyMWFaVGpJNDBNbCs4eWZReVp1R3lYalBQc2g4TlNlS215UUQy?=
 =?utf-8?B?UFZHZlpFbWtrUmJtVjNYQkQxSWREVndOSncwOTY3SHVPT2dPTmc1ZXhybTVP?=
 =?utf-8?B?WUJGQ0VPV0NWMlJIcURuZE56Vm9MYWpCK2pKMlVLTld4L0dHVHN1K3dXY3pS?=
 =?utf-8?B?Mkg4Rkc1RkRtOTBKc0xWTjlreXZxVUU5SW9zWDRPdkludnBuN3NtZll6RENY?=
 =?utf-8?B?cWh1QXpXeXQrUnR6MjNoWW41SHVLc2lnUmljQ1BjWCtnM0ZrV1E3RjRXeHNH?=
 =?utf-8?B?eGl6UkZVbUFEOEtiMW9jSm9uSUY3aVk4WjJrTXUyOEJWSURycE03dnlQRWxF?=
 =?utf-8?B?eDZCSy93QzZqWjloQXF4MWRIaG41cFA0ZE1DWExUUkJUcHg3UXBrYW9Ub3g1?=
 =?utf-8?B?Ulo1eWI2OHZqNUFrV1h3aEFWTDhwMXJTSVZFSS9vK09EamN3YndPTFpzdlp2?=
 =?utf-8?B?S3F6S1lOLzJPalUwT21TamYwUVIrVU4rYnFBTUNia0tGSzJSQ3g5K1hqRzA3?=
 =?utf-8?B?NUhPZzFRRitLRkJyRjY2bWk1UDdaZjd3UkU2TGl2UnNMV0tSNXB3eW8vY1Bp?=
 =?utf-8?B?dTJIWTRKa05EZG90RWlHdzZZZ01vOXRQbE1vaWdYV1FoeFpRczk0U3ZmS3Ja?=
 =?utf-8?B?THFvRi9JUTBMLzZtVHNYU25IY1ZZKy9kcHQ2SFdGTjA2c09vWEZXejVzOFZ3?=
 =?utf-8?B?cFFySnJDeVlkZWVTNE5abFFmVnBJTGY0RGx3ckRoa1RETjBYTVRDTUZndzVh?=
 =?utf-8?B?RytHcTBBS3pCekVzejhuSFY5aE9NeHFHcVg4WFNPbVdrRlpyNFJmN0RDWlNw?=
 =?utf-8?B?NDYyN3B0RG02SXBDRzVUUU9OUXRFS1l2Y2xJbUkrdzFnUmhUYlhMS3dYRmNQ?=
 =?utf-8?B?Rm10czNRR2xsVEoyR0p2TUg4b2ltMHlNbXdTdzJKbjRleXVZWDVqV1ZNMnJa?=
 =?utf-8?B?cXI5U3NUYWlVUk5QZTJ2M1VwYXdiNDhGS0hhTlV1T3hSek4yQks3MkMwNjdu?=
 =?utf-8?B?cU1ISnBnaDBGK1dlVFVrL1lEbWliYm5PcVU5RUxlZ0g3VUtHSndXamd4RVpH?=
 =?utf-8?B?aXh0VWc4Tk8zSFYvalk5bnl4TVk1YTVPbXRIWDlLNzBNc0JCM01UNjcrNTh6?=
 =?utf-8?B?T0JNWHpMVG9CWjlqMUZiSEJmMmRoNTBBRlVvTitjdUFjY3FKSVZGQkRpeFdr?=
 =?utf-8?B?M3JGQ05EU3J5bGg3MDF5TUVBTWhIV0xEWDh0c3lQOERaM1lHR2V2TmNhT2VT?=
 =?utf-8?B?eUpaS3Z2TW93SGR5aGM1V21kdWZnczYramR4Q3JjMmtNVnhreEhHVVRtY1Bz?=
 =?utf-8?B?UDF0SzhhQUJtKzZWazBzTmZ6TDk1L0c3V21jT3o1K1VFZ3o1Zk04NmNmbitM?=
 =?utf-8?B?QnU4RG5xSUI4cWNSc2YzOXZYM3M3cjB5NWxDS05YQWNXaWpEZ0RuQm1mdko5?=
 =?utf-8?B?bHNOQmlFRG5pcnYwNXN6U29DT3lubTczbjkydTErZk9ldjdOVlY5Umd4WStD?=
 =?utf-8?B?bysra3F6MG9kdVRsbXNWTjI2RlNYVGxkZkpxR1ZRMHBrYXp4QlZ5eXVzM1h1?=
 =?utf-8?B?ZU5kK1M0K25ZR3pRYU5kUUp2SlozLzJjdnQ0WWtaMUVHTVFVRXVMSzEvWERj?=
 =?utf-8?B?NkExclVBODE5SmVPb1hqamF2L0hTb001eUtOKyt3TC9Dd2xwVzMrOWFPTENU?=
 =?utf-8?B?M01xY29waGZJZ0t6MU40ai9uM01BMTlRUjJpckNFQ3duRmVhaEFMRE5EZnBH?=
 =?utf-8?Q?bm9sGociu14=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjRTcjhYYVZkcTcwNGpMeEdSRFR1MDQwNzVhZVEycjEyR1VXVko4cVBaaHRT?=
 =?utf-8?B?c25QMWQzcGlTQTBISjd1b2NQTzJ1VVFrdVBZUVBqNkkxVnFBVXhtWW5SRUpw?=
 =?utf-8?B?OVBES3VZWnRCYXdJck5xSk9wK08vUSttbWFIeVQ5TmhqOGZmbDdFTEVVRE45?=
 =?utf-8?B?dUw1Q045c1Z3KzEvd3RWSk9HbzgxVEF1WFlZWFhyaU44SnNFVURJWFpxZHQ2?=
 =?utf-8?B?Wk1mRnZZUVpDOUZid1UzWXZpY1Z4MDNqaDdmejhzNlZFSTRPZWEyR3ZOOTRR?=
 =?utf-8?B?b2Zzenh5eGwyQ3R3RGFhS3dQY1h4Tis2cFJvcUFiOEEwZS96ZXBMM2ZaTUpm?=
 =?utf-8?B?bVR1TDdNWE5XcUE3aU12NWdIMnJBZFpReUVJMFdLTGdQV21RdzVRaDdMdmF6?=
 =?utf-8?B?cTJOWjJjZmdwU2E4allCM3BZNGUySVAwV1ErekoyRlNjTzZsYmpGRmxFelpC?=
 =?utf-8?B?eExUTGhyMUJkTUlsczFNd1VVT1o5NjVNVEZ1d2ZtK0dvSGlVYU9VYmxndE83?=
 =?utf-8?B?M2FzaFZ4N0o1YjZUMStLck1IYmV4WHRta3RBdWxDczlBa3dGSjA3M2d5YzAy?=
 =?utf-8?B?NVQ2WXJ5ZWlTL2l4MjVQRldMZ1Q0dGU1WFI5WHBSb3VON1g4cUY1TWpKcXUr?=
 =?utf-8?B?Wng0ZElxclJkUksxTytnNHV3WHg1MWhSM0tGd25zS2dIL1Y4TjNnRGIxeFRx?=
 =?utf-8?B?dFY0ZjBjV2wwSFJTb2wyNmQxL1dyQktiOGpadVpGdGRSL2gxMDYxQm5nbmtW?=
 =?utf-8?B?TjgrZWUrc1RsWGxRd1cwcVFlK3Q3ZWVVYUVhZmNxSGE2WUNsQm91dzFPSEh2?=
 =?utf-8?B?SHJMdjZIOG55eklUUE9RZE1lOWxmWU5mMFdIaDkwK3pnOEcwRkdSeVp6b3NV?=
 =?utf-8?B?U0xCRjhOVU4veUJ4SmFpcEVkcE1ac1VYeTZXNlFSc2lXUUJCQTNjSHRmbkww?=
 =?utf-8?B?Q3RDNGFJZjdmMEZCU250bDMzUzdTVHcxMlBxc3V3MU5SMzJJaHNVZWdGY042?=
 =?utf-8?B?Y0IvTmJockI5UW9pTmYxZUFqVFBqeWk2K0Qya3BYWlVVbENUOVI4VG9pWEUw?=
 =?utf-8?B?bVVQM3M1YzNVVSswUDdSMVlNNXh6LytNRGlFVEc0ZjhkMXRFR0pha01EOGFU?=
 =?utf-8?B?WGhNTCs4Z0t1dkV3NldFRGkwKzFETmhlUTkvcDJjODJlUWxpREhYelYzMlZQ?=
 =?utf-8?B?ZFMraUw1SlBJamxMcE9jZlNodEEyb2VGWXJ6cFo0NFZnWXZielZJUXJ0ZUkx?=
 =?utf-8?B?ZlgwZ2k5K3lZUXdJbGF2NW9Ha210NlNLZ2R6aFljYjBOQ0djaFRxMitCaTZt?=
 =?utf-8?B?WURySnp6ZDhhdHgwMCsyZXJSVFB2WURGaHI2TkI4OWZnb2s1NEpwb3ErV0lJ?=
 =?utf-8?B?TEtaTlhLWnU2SmlVZHl2dlRhbkplOUJjcVpRSEpTTk0yT3U0S01oemNDYk53?=
 =?utf-8?B?TXZiWXN3dGZiQnRodFFpNzhYL3NhS3MyMlhXOXhSQnEwNUhyNkVwamk4T1px?=
 =?utf-8?B?N25DcGYxYlVkZ1QyU1JLd3VQc2ZQU1czS1ljQWpRcFVQMjJ0YVAwby9Ja1Z3?=
 =?utf-8?B?SmNXeVFHRTFRa2ZJVm14djNkUldCYUZVVDVta2N6Y0xBRjVzZHljNnV2RUdE?=
 =?utf-8?B?Vy8veUl3Q3g3N0ZLd2lEVXNtWGVEbDc1UlBWYWVESzVXSDhxRVdkZXd0a3Vq?=
 =?utf-8?B?elQ3WVVDQ1dNdWhXQzJmMG9iSyt3ZUppWE1KTDJORjZmZ3ZoWHZEdWdyODlr?=
 =?utf-8?B?M2R1dUJYVUhtVjNLemZEVzBQQUlCVDBJUmRMaFUwRXFaYk9saEppTkZnYTB6?=
 =?utf-8?B?djZ6QWhMQ2p1UnBObzVQY2xVN0FLeFlUWWJDTTgzQTQwZUQ5SmNvT05yL3p2?=
 =?utf-8?B?eEIyUzlhMlh5QTZsYjZXb1RQR3Fxa1hldzBUVlc3bzUvekdrYVJoN203OGNq?=
 =?utf-8?B?RFJNcUc5amlsRnhtQ1dodjJFT3FOSFpRczl2a3RPckdsb0kxSUJoSEZYdStn?=
 =?utf-8?B?RUovK3VpcEZCengwdmRXRm9YYTJmNVdjWmxNU3EraG1sVnVFVVJoNFMwcnUr?=
 =?utf-8?B?cVBQMmpaKzNoMmtUOXB3Yis0MWVFcDhZWTVMOGd0RmZSTmxNTlJEQzNqYnND?=
 =?utf-8?Q?RA3KuscXCrQGZPMoCI/iD21vj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69386ec2-b4cc-48a5-de15-08ddd40bff98
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 10:36:55.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmdDqUjYsXJh575aZxRdQP4w8Dt1vfgIu+2ELPOTGR/cn6u8AMXb/OKeyPB4vUh+vrulMUrqsi6NmUxnojtTVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8956
X-Rspamd-Queue-Id: BF5A640009
X-Stat-Signature: ty356jd36khh13qnny39qojfi64s8fyb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754390219-239584
X-HE-Meta: U2FsdGVkX18PB2csY+wJ34MivzAljcUr7ywBCJvBMmNgaK0k0Hzz7+fKg6SeLqt9V14A9BM0BzSUdVV6eV9EhKpOesF19TnPNGYn5lLPZ+5LF4d4Q0hffRN7n6FI2306oqz0cHlcDwHLeDHAOaAGzMnh3W0tbck9wQIgX8reQuq4M8kn5vu4vi5w1eI6MT6BoqmOpa3Cvm7Kr1hlB3TKEH8yk5PtOVv7urYDA3+yw+Iow81js2p9Qb8FMrSgRwN25cwBg2FNlIKBC1KWo7j2ztzeiPLn+xNObfnde1otHw6VaCoApatuH9IEILTu1jqwlnT0FltpOC2ihDFsLwgRsF5WlHoFPdxQ/LYnFJwao+InS3XLD+ZG7yE8YlqwWiw3GXPSigZcAZhUyomxCHf+zmyqBxN5TE+FdIKlCUdguWIymdjoHmuBBKSqhfao9m3xVoi+KzhYCtcvIjA4GVy2ncvkSc+dfdg2qigE2A4dl2gv7uHcJ5voiaK+6IQdyReBhqCWDmVCk4O6UlNQOT8EqTNpsrSxofAcV7743DRagGOYYpNm31hfUOQJpxRRgChSB5UfdaweakTzpB/om1/Nt47n/KgLBXTjePY8PIYj9U7I1SzZg6p2hKXYTWLVG0XmcsncBPkQs3oX4PdO6EtayCGzsxY7jeOfOyj+MQP/poOjeoHS/9C0hLClj9W5yW7xeB2VyTZLjBepoiFzDBZ4pur33aKTG7foxfqDUQArce2EPaZeYrX2t0vSriFFhhqxI2KMzvhLZ1SDHYM0vSZyu0RAPLgbbuaPiVIV3ItEbqcpZ6yWkrw4Wma0O8YV+ugrfHQtlYPWgnesAauPrIuW1MQezI3R9ErIu6W0KJWbMQnV6GRQMznv1QLD1jUlYpHXKPsuCYXbohwddgrMvkQ+zgm+k1CKQZIPe0AVyXdYt4kdgGjniYZg38COR2Oak+rqWSBaJ2cT3+j2EmDva/D
 yXQ4d4S7
 QbWjJg8OX9v60jmpFqwt/auGb7aZpsrQqNYsMBzoFaFqSVwL9k6DeOwFOpreAHCvtZL9mpHT7YEgZw+IuLJ5ilmrfo75nWoTN8uWdvfq2DRYhxFn7fu/vxUHcom2DOxpkgaR68mJLsh1MVwKpu3i3vlO3ZkeaylJJA+Vyj9ikL28lg1pazHzbV1fAH6JzYXW9Ko5Ct7mkEOOdHuU9f8ku8K/GT3AqWUlpAgnYUirEJQlNHU78EJJuR9hGSps7m3BWCtW/CwtRV4DdB8BeCZMyg/sLp69rUGu80NhruBS9X9rr/gcxovUWgDZuPwXDcynarT8v506f5weQF1F4H75G7661VbXny+ELN51lQDqz1n50uvRmEF+yLIF37utCn/ZV/UbC7wCg3V1rFzwdkT9ZbMS/M0LPPrvM+0dqyRVFGFtpJAhXmpfhoaENr7UrT+0FTHhOFF1DmY4cCtQ1NEQwCILsQboJ49Y0H0LrJW05mt22WqBMFyVC8e1tOWln8V+81jzCkzChuQX+B0qYrXRnhul7q2YfhBgrTOr5d829tA1cmoJqsaGzQ6iXUsYqoDdMlWtBIFk5MP6/KYBvwS6RCUooKqHGR3nPAztJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 20:35, Mika Penttilä wrote:
> 
> On 8/5/25 13:27, Balbir Singh wrote:
> 
>> On 8/5/25 14:24, Mika Penttilä wrote:
>>> Hi,
>>>
>>> On 8/5/25 07:10, Balbir Singh wrote:
>>>> On 8/5/25 09:26, Mika Penttilä wrote:
>>>>> Hi,
>>>>>
>>>>> On 8/5/25 01:46, Balbir Singh wrote:
>>>>>> On 8/2/25 22:13, Mika Penttilä wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 8/2/25 13:37, Balbir Singh wrote:
>>>>>>>> FYI:
>>>>>>>>
>>>>>>>> I have the following patch on top of my series that seems to make it work
>>>>>>>> without requiring the helper to split device private folios
>>>>>>>>
>>>>>>> I think this looks much better!
>>>>>>>
>>>>>> Thanks!
>>>>>>
>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>> ---
>>>>>>>>  include/linux/huge_mm.h |  1 -
>>>>>>>>  lib/test_hmm.c          | 11 +++++-
>>>>>>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>>>>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>>>>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>>>>>>> --- a/include/linux/huge_mm.h
>>>>>>>> +++ b/include/linux/huge_mm.h
>>>>>>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>>>>>  		vm_flags_t vm_flags);
>>>>>>>>  
>>>>>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>>>> -int split_device_private_folio(struct folio *folio);
>>>>>>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>>>  		unsigned int new_order, bool unmapped);
>>>>>>>>  int min_order_for_split(struct folio *folio);
>>>>>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>>>>>> index 341ae2af44ec..444477785882 100644
>>>>>>>> --- a/lib/test_hmm.c
>>>>>>>> +++ b/lib/test_hmm.c
>>>>>>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>>>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>>>>>>  	 * device memory and that page holds the pointer to the mirror.
>>>>>>>>  	 */
>>>>>>>> -	rpage = vmf->page->zone_device_data;
>>>>>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>>>>>  	dmirror = rpage->zone_device_data;
>>>>>>>>  
>>>>>>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>>>>>>  	order = folio_order(page_folio(vmf->page));
>>>>>>>>  	nr = 1 << order;
>>>>>>>>  
>>>>>>>> +	/*
>>>>>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>>>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>>>>>> +	 */
>>>>>>>> +	if (vmf->pte) {
>>>>>>>> +		order = 0;
>>>>>>>> +		nr = 1;
>>>>>>>> +	}
>>>>>>>> +
>>>>>>>>  	/*
>>>>>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>>>>>  	 * large number of cpus that might not scale well.
>>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>>> index 1fc1efa219c8..863393dec1f1 100644
>>>>>>>> --- a/mm/huge_memory.c
>>>>>>>> +++ b/mm/huge_memory.c
>>>>>>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>>>>>  					  struct shrink_control *sc);
>>>>>>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>>>>>>  					 struct shrink_control *sc);
>>>>>>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>>>> -		struct page *split_at, struct xa_state *xas,
>>>>>>>> -		struct address_space *mapping, bool uniform_split);
>>>>>>>> -
>>>>>>>>  static bool split_underused_thp = true;
>>>>>>>>  
>>>>>>>>  static atomic_t huge_zero_refcount;
>>>>>>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>>>>>  }
>>>>>>>>  
>>>>>>>> -/**
>>>>>>>> - * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>> - * split folios for pages that are partially mapped
>>>>>>>> - *
>>>>>>>> - * @folio: the folio to split
>>>>>>>> - *
>>>>>>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>> - */
>>>>>>>> -int split_device_private_folio(struct folio *folio)
>>>>>>>> -{
>>>>>>>> -	struct folio *end_folio = folio_next(folio);
>>>>>>>> -	struct folio *new_folio;
>>>>>>>> -	int ret = 0;
>>>>>>>> -
>>>>>>>> -	/*
>>>>>>>> -	 * Split the folio now. In the case of device
>>>>>>>> -	 * private pages, this path is executed when
>>>>>>>> -	 * the pmd is split and since freeze is not true
>>>>>>>> -	 * it is likely the folio will be deferred_split.
>>>>>>>> -	 *
>>>>>>>> -	 * With device private pages, deferred splits of
>>>>>>>> -	 * folios should be handled here to prevent partial
>>>>>>>> -	 * unmaps from causing issues later on in migration
>>>>>>>> -	 * and fault handling flows.
>>>>>>>> -	 */
>>>>>>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>>>>>>> -	VM_WARN_ON(ret);
>>>>>>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>>>> -		zone_device_private_split_cb(folio, new_folio);
>>>>>>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>>>>>>> -								new_folio));
>>>>>>>> -	}
>>>>>>>> -
>>>>>>>> -	/*
>>>>>>>> -	 * Mark the end of the folio split for device private THP
>>>>>>>> -	 * split
>>>>>>>> -	 */
>>>>>>>> -	zone_device_private_split_cb(folio, NULL);
>>>>>>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>> -	return ret;
>>>>>>>> -}
>>>>>>>> -
>>>>>>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>>>  		unsigned long haddr, bool freeze)
>>>>>>>>  {
>>>>>>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>>>>>  				freeze = false;
>>>>>>>>  			if (!freeze) {
>>>>>>>>  				rmap_t rmap_flags = RMAP_NONE;
>>>>>>>> -				unsigned long addr = haddr;
>>>>>>>> -				struct folio *new_folio;
>>>>>>>> -				struct folio *end_folio = folio_next(folio);
>>>>>>>>  
>>>>>>>>  				if (anon_exclusive)
>>>>>>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>>>  
>>>>>>>> -				folio_lock(folio);
>>>>>>>> -				folio_get(folio);
>>>>>>>> -
>>>>>>>> -				split_device_private_folio(folio);
>>>>>>>> -
>>>>>>>> -				for (new_folio = folio_next(folio);
>>>>>>>> -					new_folio != end_folio;
>>>>>>>> -					new_folio = folio_next(new_folio)) {
>>>>>>>> -					addr += PAGE_SIZE;
>>>>>>>> -					folio_unlock(new_folio);
>>>>>>>> -					folio_add_anon_rmap_ptes(new_folio,
>>>>>>>> -						&new_folio->page, 1,
>>>>>>>> -						vma, addr, rmap_flags);
>>>>>>>> -				}
>>>>>>>> -				folio_unlock(folio);
>>>>>>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>>>>>>> -						1, vma, haddr, rmap_flags);
>>>>>>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>>>>>> +				if (anon_exclusive)
>>>>>>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>>>>>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>>>>>> +						 vma, haddr, rmap_flags);
>>>>>>>>  			}
>>>>>>>>  		}
>>>>>>>>  
>>>>>>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>>  	if (nr_shmem_dropped)
>>>>>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>>>>>  
>>>>>>>> -	if (!ret && is_anon)
>>>>>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>>>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>>>>>>  
>>>>>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>> index 49962ea19109..4264c0290d08 100644
>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>>>  			 * page table entry. Other special swap entries are not
>>>>>>>>  			 * migratable, and we ignore regular swapped page.
>>>>>>>>  			 */
>>>>>>>> +			struct folio *folio;
>>>>>>>> +
>>>>>>>>  			entry = pte_to_swp_entry(pte);
>>>>>>>>  			if (!is_device_private_entry(entry))
>>>>>>>>  				goto next;
>>>>>>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>>>>>  				goto next;
>>>>>>>>  
>>>>>>>> +			folio = page_folio(page);
>>>>>>>> +			if (folio_test_large(folio)) {
>>>>>>>> +				struct folio *new_folio;
>>>>>>>> +				struct folio *new_fault_folio;
>>>>>>>> +
>>>>>>>> +				/*
>>>>>>>> +				 * The reason for finding pmd present with a
>>>>>>>> +				 * device private pte and a large folio for the
>>>>>>>> +				 * pte is partial unmaps. Split the folio now
>>>>>>>> +				 * for the migration to be handled correctly
>>>>>>>> +				 */
>>>>>>>> +				pte_unmap_unlock(ptep, ptl);
>>>>>>>> +
>>>>>>>> +				folio_get(folio);
>>>>>>>> +				if (folio != fault_folio)
>>>>>>>> +					folio_lock(folio);
>>>>>>>> +				if (split_folio(folio)) {
>>>>>>>> +					if (folio != fault_folio)
>>>>>>>> +						folio_unlock(folio);
>>>>>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>>>>>> +					goto next;
>>>>>>>> +				}
>>>>>>>> +
>>>>>>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>>>>>>
>>>>>> test_hmm needs adjustment because of the way the backup folios are setup.
>>>>> nouveau should check the folio order after the possible split happens.
>>>>>
>>>> You mean the folio_split callback?
>>> no, nouveau_dmem_migrate_to_ram():
>>> ..
>>>         sfolio = page_folio(vmf->page);
>>>         order = folio_order(sfolio);
>>> ...
>>>         migrate_vma_setup()
>>> ..
>>> if sfolio is split order still reflects the pre-split order
>>>
>> Will fix, good catch!
>>
>>>>>>>> +				/*
>>>>>>>> +				 * After the split, get back the extra reference
>>>>>>>> +				 * on the fault_page, this reference is checked during
>>>>>>>> +				 * folio_migrate_mapping()
>>>>>>>> +				 */
>>>>>>>> +				if (migrate->fault_page) {
>>>>>>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>>>>>>> +					folio_get(new_fault_folio);
>>>>>>>> +				}
>>>>>>>> +
>>>>>>>> +				new_folio = page_folio(page);
>>>>>>>> +				pfn = page_to_pfn(page);
>>>>>>>> +
>>>>>>>> +				/*
>>>>>>>> +				 * Ensure the lock is held on the correct
>>>>>>>> +				 * folio after the split
>>>>>>>> +				 */
>>>>>>>> +				if (folio != new_folio) {
>>>>>>>> +					folio_unlock(folio);
>>>>>>>> +					folio_lock(new_folio);
>>>>>>>> +				}
>>>>>>> Maybe careful not to unlock fault_page ?
>>>>>>>
>>>>>> split_page will unlock everything but the original folio, the code takes the lock
>>>>>> on the folio corresponding to the new folio
>>>>> I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.
>>>>>
>>>> Not sure I follow what you're trying to elaborate on here
>>> do_swap_page:
>>> ..
>>>         if (trylock_page(vmf->page)) {
>>>                 ret = pgmap->ops->migrate_to_ram(vmf);
>>>                                <- vmf->page should be locked here even after split
>>>                 unlock_page(vmf->page);
>>>
>> Yep, the split will unlock all tail folios, leaving the just head folio locked
>> and this the change, the lock we need to hold is the folio lock associated with
>> fault_page, pte entry and not unlock when the cause is a fault. The code seems
>> to do the right thing there, let me double check
> 
> Yes the fault case is ok. But if migrate not for a fault, we should not leave any page locked
> 

migrate_vma_finalize() handles this

Balbir

