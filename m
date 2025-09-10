Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498D7CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 00:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843CF8E000D; Tue,  9 Sep 2025 20:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BAF8E0001; Tue,  9 Sep 2025 20:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709E38E000D; Tue,  9 Sep 2025 20:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9ED8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:24:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00B1111A430
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:24:09 +0000 (UTC)
X-FDA: 83871443418.09.AA8795F
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48DFAA0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:24:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Upch0roM;
	spf=pass (imf15.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.223.50 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757463847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEbj+g6J45BdqijmpSzYinP/nCQm4Gjx7LcdHixG0tY=;
	b=Tj+BM/8cReei6kZj/jL/qs4OBNMFygkuwvcUZDR2UGnAIpxsvI0nMTyWBozAYcO9W+oCp8
	CfGFo0Ll7C7f9/lNCfoH54DX4LY0mixKPog6Q2X9f05q/drtLwNBYB1KAv+iXe21bxhRwu
	PjHCZmLCN9jIk/pzXA7EgEmbNyBEqS8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757463847; a=rsa-sha256;
	cv=pass;
	b=AYIXhXgHAj2RG5SM9w3k11Y+KX0n9Mdr1oUSfFdsyVjNNyFO1UwAvwGshVbKVSizwDJn3Z
	SLCAcfLXs88yLcCv2yyBY8SUGeNoauIsudi6WcQ/ueRDMdqcI9gMKPA1N1IxBwITHKM2JX
	WNcyshewsZ5MovO8KwSFomN69nKBgbI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Upch0roM;
	spf=pass (imf15.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.223.50 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELHtDR3GY+1/XnW9X/zknQ+A62+zm8fy1iw8NabN42BCF+GDJLGLAme0obIjPcdITdHXg+5uhLg+9+RmAJnDNjbPlq6hJcV02wCrHYt6x0/OY8h3+gZmxOYhBROuEeXznkk1nlswhmnudEXkjHQzOGmG7XpXd6uXnhFW2SEyu+aaDqS6He1EVT8Ezy9foN4jLLcmj0srAZPOLkzc6b62KsSVBZazftZKmb4D5W9DoZnZ3vW1NbnHUleZ8VHHOPQTg1j01yXXmk49DCI6Z4cAQRa2uJi3OQQX28E9WCsbINsOaZoq7Sw0aUwPO9qumwba4dqe11EgufNGOsXXYxgVhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEbj+g6J45BdqijmpSzYinP/nCQm4Gjx7LcdHixG0tY=;
 b=BHkHZOMuaL7YbF/fOkwlL0mPfUC81QLyLLz2xKfArUOY9S9DqCmNZtv5bwbOjFHH/0e08etW8v5Y4L22faur2OhNb3wzV3GwSRqH+eUitbWOvsZXDQx6c5+UirO7UBzGdSpPVO39N0ZkKr4yjuQIsrsl2Dtw+93LZkcfyiGiZwMA8J2JRrM2RWzyIqC7bv/EriVRzf7pzzsOt2wm/bbTzac7Lg1jsEQqv8d/dyIsl+S2oei+3CMGrtS/NSieCOaJ86FI23PnFJFr688DsH/PasCQ6ixv5YYxgYynEwShEYIj8w0pS5c1EX/4AqLkb9RWspc6cmpTPmxwwOens7orYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEbj+g6J45BdqijmpSzYinP/nCQm4Gjx7LcdHixG0tY=;
 b=Upch0roMo1TwNqCftw8sVJ2X+m28gW3fCpTJ3m4ABunwaT4NvjGqS86eoAHoA7HmGFRAkoIqEA4O7m5WEqL8xKTd2qDJ7R9zNrk7wat9frdfj9X5Yk2+n++ikXcc7hmkJ5junOAumhgWTkMY6SNt/29dMzQQp8i86aoNgGFdPjex3wAR7oTb4E3q5JI03chcCX4ZRW/U99voINkMKoHbNLxMQXL8TaoBvDerBVfAt/Rgb8620TNaT7lvojeC0DKe/GL54g4g5aTscGp2+5REKAKBMd6R9E5cDAu47M/MTCZdyeCNSXKMTidLItOFUojaBF9maEJ3nytGaKUgYTWB0Q==
Received: from BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
 by LV8PR12MB9417.namprd12.prod.outlook.com (2603:10b6:408:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 00:24:03 +0000
Received: from BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4]) by BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 00:24:03 +0000
Message-ID: <6a93bf8f-b46f-4c68-a03d-f3a8b2a1589d@nvidia.com>
Date: Tue, 9 Sep 2025 17:24:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>,
 Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Ge Yang <yangge1116@126.com>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
 <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <aLGVsXpyUx9-ZRIl@willie-the-truck>
 <7ce169c2-09b7-39e3-d00b-ba1db6dd258c@google.com>
 <aMAR1A1CidQrIFEW@willie-the-truck>
 <655d2d29-8fe6-4684-aba4-4803bed0d4d0@redhat.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <655d2d29-8fe6-4684-aba4-4803bed0d4d0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:a03:255::15) To BY5PR12MB4116.namprd12.prod.outlook.com
 (2603:10b6:a03:210::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_|LV8PR12MB9417:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd319ae-6e52-4d45-4a79-08ddf0005883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTlqN2xJTGNWZVRubmFwWndlVzJ2OVVJUXRTMm82aUNTL2kvRUdyMnluSjRq?=
 =?utf-8?B?Q3ZmblZIV2tzOUFUalNRNTJzZHNUQ2E5YlRwWCtiR0NCUHo2YUs3cjRrMWZ4?=
 =?utf-8?B?OXUwMDM2Yi9RaXYwWFQxUFNMQWZmVk1VR2ZLVEZMS2h6M0lzU2p5UE9wOTBO?=
 =?utf-8?B?WDdqejdaZEU1ZzhER0RkTlRveHprU0NlbFFqYjUzM0MxdGNXZWE0YkJibXpQ?=
 =?utf-8?B?bnYzMGprWm55U2h5Q1k4UXQ3UmhESlBoaTNVbzlmODVIeE5rQUJkQUVUcXBN?=
 =?utf-8?B?TExKUUpIRGpFZEwwa09hRnduQjJCYzNYSkhHNkxMSTJCZnl1TTBkUjFwVWNj?=
 =?utf-8?B?V0lZWmZYOXlWLzM4bjdGSTNmRkJJZ0o3dXpYa0NDeDViK2lnUUJmMnMrdjND?=
 =?utf-8?B?emhQU2JyTk9VQUVvelUzSUdIbit5dUxsRjRrYlJYR01tT3pkeFZha09SNmdr?=
 =?utf-8?B?QUhPTTVDSGNoZnNKcDhHSmU4N0JMekJiTVZXc1F4VUxadVJZOG83UG53NThk?=
 =?utf-8?B?ZGFZSmJ0OXp0TTl2Z2V1TGZ2K2VHb0RsVVpidERsYk9TK2RiaUFDeVJmZEdP?=
 =?utf-8?B?eVhQaC9GT1UyYU9ycHFnd1ZGa3ByVFJzUzFkOTJpYU5Ya3FqbVdCK3hoRVMr?=
 =?utf-8?B?OXNUQ3lwMGtYcXlhN2R3T1hkS1krTXkzbDR1TnpMMkRwdkFiNFN1YmxtNmhB?=
 =?utf-8?B?M0lCckNLMzJzODJ5WTQ5c012RStnbFprWEcxbDg4T00vVnFoN0l5Qk5QQWdW?=
 =?utf-8?B?NXMrZmFBcGxFZmloN3ZmNURmTmM4YjBUVW1hMkpOeTkxN0RWbGVHZk8vZklR?=
 =?utf-8?B?amE3Zjd3ajZXVGVRQ2FjMGRyTmNLcXV3c0RURllQVEYxUVo5OG53NEVBcVhH?=
 =?utf-8?B?RFV5aUp6ZTZ1ZVZRRms2M2VLNDZqczdoejNIY3RzaTlvREpGVzI1MlFuWUZj?=
 =?utf-8?B?cnJzZXNoVFpzck9xUmxBMFB6VnRIaVRJU3p0OHAzcTJKVGs3MjVRZW5vb3c1?=
 =?utf-8?B?a282NGY4WjhkanVqcitEMWliZTZXQktMTGF1TStINzc1dXZRMFo3am1LUzln?=
 =?utf-8?B?cjRBendnbjlCMXpiR2JJQXR0TnFJRXNQUFJ6N2djOFZnOVp4QjF5ZE9ZMmxB?=
 =?utf-8?B?ME4zYzMwT0RHNlBKR0p3WStBWW9UY2tCNXBtVkZEeGpDNHVhbWV0bEZNVDFx?=
 =?utf-8?B?R3ViMjFEWU9GUnZocGJQSHZ5YzNUeVRaRDlvamtOdVV1ZitRVjg1cXNlTCto?=
 =?utf-8?B?anNWeTd5TU9OUFUxeGhBazJtQlh1N0RzcXdZazZVWUVmK2ZUNGdCS3dtVlpz?=
 =?utf-8?B?bkxzNXN4L0U5S21aN2FCNEpXamlaUFFjcjliZVNNYWpzWEdLNmhHMFQvZDh4?=
 =?utf-8?B?ZlZJUG51amRhRVRUMFUxeW9mVElBU1dVS1BnUnhDSVM5dkhMcy9aSjdxaHYw?=
 =?utf-8?B?cWpaRlhLb1VQNHE5STdRUlB5TmdqbXorMFVoaHd2VUQwNTlMK2orOVZvVFpD?=
 =?utf-8?B?SE83OHpoUE1SZjNVcVNPcEgvU1I4dU80RzVwTUlqWjl2RU9YRW51WG1lWWZZ?=
 =?utf-8?B?VWE3bU1HdlFQYlJ0TVdSMkJ4WjJvRmRlak9XQWZReGtReVRXZ2dtUmIxTHBF?=
 =?utf-8?B?UTAzekUzUWhlU1VKRTh4b000ZzYzYVRaL3ltVDR2VElldFIyS0F4d0tFWDdv?=
 =?utf-8?B?THhtallDWTQzaU5TTWUyUHB0TTBuK1MrSDcreHd1NHRDTVVncVVXY2t6TWx6?=
 =?utf-8?B?QWNzc1JXb1lzZHllRWJaVW8rdnZZQ3lnMWkxNUxHclVxbisyZjdMeXhKZmx0?=
 =?utf-8?B?ck54NHhRSHY3TFRTeUhsVkdNZXFSK1JzRkNYQ1BWL0VaMkxaYTJVbkJOL0l6?=
 =?utf-8?B?aTNid1V0TXpEaHZMUUltUERNdTNuUzFvNm9VQzhWRm5WWVNaVm1yZEkrckRY?=
 =?utf-8?Q?LXXm1+PDL4c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4116.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFFvbXNNajZ4UWRtV0preDNZOXRSZXZ6YitnMXdNNEpMZGFRWFRTc25xcGtQ?=
 =?utf-8?B?NURIT3lSd3F6TkR0VDZKR2VkbXlTbUR6Sms3T2ZqbEpVYVZabWluMHJhbW5v?=
 =?utf-8?B?WHZxQndDUjdTMkl0YVdDZVR1SzJIdWFZMkxFR0dCaXNsTmdnbFVJalExd0Zp?=
 =?utf-8?B?QXJKMmR5WUV2NVBpVGVQZGFGM1dmbXAzY1J5R1h5eEpHZHd2akhwekpqRTZo?=
 =?utf-8?B?cTFZU3ErL0tuWDcwSTEwUlVDTENUenh6eTNxS2tNT1lNTm5CWXIwRkNRYk1u?=
 =?utf-8?B?T24wZVhtcjUwazNkYWQ0VHlBeFpYQnh1S1dHeUtCQXZpcGtEOTlJZ0s4NzFL?=
 =?utf-8?B?SXU5cC9LYWhmb2h3Q0RtZUY5K2VaR2hPTk9VOHlTSXJyYnowRnVFdW9DdCtH?=
 =?utf-8?B?cWM4UnhJZTliQzZGbzRNVDhDcUttZU1IZVdVUEN1bGMxSUZEdXhYblRPSTAx?=
 =?utf-8?B?YkcvN29NcG80K003bXlFaXhVdk83d3ZyYitzd2hwMThibldJazhYMWhLWWVH?=
 =?utf-8?B?cFlPUWdFWmhFWEVIWTROM2VyNW41REZkakdydGw4d0dwSGs1QnlKa0pzSnpr?=
 =?utf-8?B?dEtqdGxmVDhyNDliaVBSYVlDcitIRkFub3dNNVloQk01cm9JVm9lNTJXQVNu?=
 =?utf-8?B?ZHUvYXF5Y2QzcG9FSnlQL0ZlOHJpYVRKS0Ztbk1teFNwMExoWlZ3YWI5NHFY?=
 =?utf-8?B?SHFraUhreUx3WmlNWUFOUDAvWDhQMjZMdWNRelFUdXBiYzZIWTNoNFZDUUd5?=
 =?utf-8?B?clJTTzMvSFRoS3hYbmVGK3BYYmFIN2RGQ0VRMmFRL2Y1VkdHUTZ1b2JGOUFS?=
 =?utf-8?B?UkcrU2N4RDZzcVhIZnVUVWYvVXVnTDE3MlhkaW1reU5mNnllMFM3L2dNN0Ru?=
 =?utf-8?B?S0FEWnpZaDNZakhCSUFQN2hoWEhYZHBnTVFHbHp6OHYxcHdqVnB0eEtxbUp6?=
 =?utf-8?B?UUJnSlBPRVdZNndFM2xmYWMyRGdkMWMyUUJwOVE2NnVuR3NCUUcwRHUvaVZo?=
 =?utf-8?B?a1JSWkw5c0NrUGdaUWFpL2M1cHpqQ3ppbDlaWnFrcDVrZ2JlWkdYa2VmQmFz?=
 =?utf-8?B?czVMUUc0TVlXNkxuNE5HaDdZaVhyTXpkL0FrejZ5YWJmSkgxTU9RVVIxMGp1?=
 =?utf-8?B?WHlSdFpRYTV2ejZQb0xibUhGcVkxUUVpalEvOFdyTXZTUnphOTl2dzdnMUJO?=
 =?utf-8?B?YzFPU2U2U0RBcU1vWmVMTXpia0NFMnJWWmg3V3Z2ZDFQUnYwdW5EVlhTUzNJ?=
 =?utf-8?B?ZXJuRS9lVTYwR1NPTURYRFhwSmthd0dzS1RXTi9MdkkxWnVkanJtWEdtT0RU?=
 =?utf-8?B?amkwVDR0TzZIa1BCc3hjSVRhTmZqTzNnMGc1czdYOEpEQU11YXlzaDBzU2Z5?=
 =?utf-8?B?bDRhWURDZ0pnTGt6ODVuSnVYV2Y4SU03bmhCNDZxbUVNTlNGLzRJLzlPalRm?=
 =?utf-8?B?cVdSUjBNM1E1a0RQNGN0NDk1Ums0alpYY3ZWRzA5cllpSy9FYUwwOUw4UXhm?=
 =?utf-8?B?bU5tYVFoNW9rRzhvaUZtN05uRk5RL3QrTS93bkt3d1g5UFdReXRnbGt5b2xp?=
 =?utf-8?B?T3dHc1JZNlhTQnNFWUlXYmxMUnlybmlObGxZR2xrNmtvK3VvMUFlby96UlNq?=
 =?utf-8?B?MkNCSzgyelFpdmR2UlFpeGFyRTZzVXVQdzQrR2dGYkIxUnJzQ0ZmaTVHRm9l?=
 =?utf-8?B?UTJvMTBZS3dsczRPMko0RHkweW5ORU9LWndYTERSVnFzWm5YS3REdEQvam9T?=
 =?utf-8?B?R1VpYWtrdVNKcHBhV1ZNM1plNUhrMHlIbnNmRUE4U2lacTVwbUpwVmIvVTVZ?=
 =?utf-8?B?Z2pqTTI2SkszdzFsSFltbDB0MlNjVlJHUVowZVVVKzhDalVsVGljUjNGemhz?=
 =?utf-8?B?RkN0UW04UUVFY2hJU2Uwc29xalhTdkNaejQ4OG1VL0NpaVdJZjFSUlptKzZ6?=
 =?utf-8?B?ZUhXMW5kVFVrNjdOZjc5MkZGR2hud1RBY2hteTBCcXdNQnBHZkpMREJDRFpT?=
 =?utf-8?B?Y2JTZ0xZcHZjc0hzUmNFbm1PdXQ4ZWVid29EU29MOExBRTdqd1g1VEZPTE1D?=
 =?utf-8?B?dEtjR3QrWFY5b0dyNnRramU3OFdvUmhxVnZqNjJrVnVBRS9oQkJtTXkrT3hr?=
 =?utf-8?Q?YL4IzSvpAKWNWEzgv0TpTv8Yq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd319ae-6e52-4d45-4a79-08ddf0005883
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4116.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 00:24:03.4430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7KXFuWlNz4mRB93koNIdazD4e7VdEZ/yGPdxj8ibkyGeJcQJj1RS5hWTyPdQ/BM6J5zXNaNeerEDfP/dlquiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9417
X-Rspamd-Queue-Id: 48DFAA0002
X-Stat-Signature: q58xedoyjpqgpga19bgyximw6kznpif7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757463847-877436
X-HE-Meta: U2FsdGVkX1/umI0SRxk9W2r3dGDZxbgBv4jZsFZt2jzyZZb3ziq73CeLa3JFbASE3zIF3WoLYIgdloucvNA58smkdp6735YeLNYh2nYUmbb2QP3NvXQsbFe1KDBThCve3JtMKAevza9fcJHxW5IBaiFkomVBG4V1k9gNhUudeifqSNmtIPTiVQAQ4XAxmnAp7uA2N2ipHgbSJfx1iVhdfmqXd9IXzKohHzylroz/in2rRuL4IYl23vM50yjOCCqt38On9ZSje+a3I9WYNptsChD9Zw4FHEc3MvkJ1gRZaWy8WvPMBjfpdIPONf2kJQu73iEIdNjY4RnFCPH/Ch2450d6La1gWMAaOkaS4bat8kUfm67IoYOimveXekUSWpjqDLVC/BpDsIlCyOGRL/3U/8x7SgY2HIVALLzH11N0T2JtYgc7LyN8btU7IuH2h+x8XdLVTufcggaerDrzYWN0pf4z6aA4umM+uD3poQ0JnNOqf0Xckfju3RCYkC+KdF66eKVHsJcgWUTUROcpf+Wy964dG+Gcclqdqu7Bkhs5zHdJ7DOTvmDwDJw7xIn4wxXtVmQ411LeoPkxz0mK4YSu2StfJF/m/4HpKxcNabLRRHVM3NSiwc/jOBFRs/IMjqSuK56MnUwms+aMuRkuHXZtwG/6kaFdYUonOxb4DcyF9EyxrNetfLnHRaGKwHHm3qlluyuyU0QfsAUvt1koInGAY9FLNWdBPYuER8plI+twWc/5gn/D4UyzlJgvOFpVimTS0mS9nENK7j2fwIUgEo4LiRvH6MBbMZlrZG8IGC01FYpeixA/VonOsBccEqfEQ9ZEn5KfEanAUSMFpuRUPSjmcV0rPAkqLd2hh+mzrGvfIBtSLfzXdQjZBTxukm0asBwh0u849dMPRiqOWtDdfTjKHqdnOMI5xEO5YOutiZIs1OzNuAHz0f2Rv+xTrbE75Zz+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/25 4:50 AM, David Hildenbrand wrote:
> On 09.09.25 13:39, Will Deacon wrote:
>> On Fri, Aug 29, 2025 at 08:46:52AM -0700, Hugh Dickins wrote:
>>> On Fri, 29 Aug 2025, Will Deacon wrote:
>>>> On Thu, Aug 28, 2025 at 01:47:14AM -0700, Hugh Dickins wrote:
...
> Migration code itself will retry multiple times, which usually takes 
> care of most races.
> 
> Not all of course.
> 
> Now, I recall John was working on that at some point (I recall an RFC 
> patch, but I might be daydreaming), and I recall discussions at LSF/MM 

Yes. I was trying to improve the gup scenario of "try to long-term pin
pages that are currently in ZONE_MOVABLE, and must therefore be migrated
before pinning them". The problem is that the current code just retries
in a loop, when what we really want is for it to go to sleep and wait
for the pages to become migratable.

Anyway, I had trouble finding something to wait *on*. David here at
the last LSF/MM suggested waiting on a page group, but I only partially
understand the approach--and what really happened is that I am
"temporarily" (for a few years) consumed by this entertaining new
Nova (Rust for Linux) project.

And so I've failed to make any progress there this year.


> around improving handling when we are mixing a flood of short-therm gup 
> with a single long-term gup that wants to migrate these (short-term 
> pinned) pages.
> 
> Essentially, we would have to temporarily prevent new short-term GUP 
> pins in order to make the long-term GUP-pin succeed in migrating the folio.
> 

thanks,
-- 
John Hubbard


