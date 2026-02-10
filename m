Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984FFE94625
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57F86B0092; Mon,  9 Feb 2026 21:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FBC6B0099; Mon,  9 Feb 2026 21:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD96E6B009F; Mon,  9 Feb 2026 21:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABA106B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:32:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4965A1A0236
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:32:12 +0000 (UTC)
X-FDA: 84426972504.25.F353502
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012045.outbound.protection.outlook.com [40.107.200.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8195940005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:32:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fmHunqU1;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770690729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INY26cD+R+naI7N4XMbmp1knUGYP2KF/uVwKo7vpE+Q=;
	b=YZ2kKKD4RkQP1E302TpG7SdbSqPamz5EibnRv6jQI856B9lEzpSj8563u+hIn9BjAGNicN
	VE9qWw5slOFcIeua7xTeu936NpbRCi7jXHYjR8Wj6/RttA6VfjTPUmm7EegWHwoP+NkJW4
	7wkqwzv+e0N9Ddh8OSqv0kawxnpgVT0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fmHunqU1;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770690729; a=rsa-sha256;
	cv=pass;
	b=KH7KqAB1BR0kb/ujub2DXDshpQaeDqd1Bm0xJLLmU0l4eGXNS8nc+dWNfCUL0hMIjHX2jG
	RGTYfptrrCNQIjAd2VnAfGNePvNFsO71TwCrBchpPjrL7O7E4MRC5PLBYkEo5HXq332ZGI
	sMJpH5Ml6MJ8wqbvGxOg26bB9MbEt0o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DZJXQ0jSWLEBycVslwiveknG247WE1c0fs6V6G0NliKfGBxZvc25R7fbj/8C2AOr2eXydYcZoqz4ms1eSf3seQ3XfD1YDayfY9ienFdnGmFgZXH7h0f5dlFQMINpHQqQRimJ1kqsmw5/7S1zxwtKYy/b3Hx1aFHCiR0E8KK+sughqAW07hr1HAGrdscJuUhmxR3U5L7qECwK1FzbJlg5yG2HCZOHbEDo7NdPrMcmsKcvDP9XgPcVOz4DfuvjHK0OzI6UDnKymk1RSp96bdobHWMKfJP+TZlRBaGm0APxVAB2txgLjtEWEJf3slZAFTgkyvoN4w7yNkTeaGlWicZr8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INY26cD+R+naI7N4XMbmp1knUGYP2KF/uVwKo7vpE+Q=;
 b=iiClQKKP1ZXQQOX0WkKDItePnh0OTLVlkvvTknHXy9XsB/he4i2dcFrv1rrQrOpewGpsflAwKnwpFlr+PLzu6qKk+hm/cgypEFWydsJOdeEiDT44BEv1Nsovm6S87F/whnEOUJ00B6arnnD7j/GVnn8AaCPyrjnvdf38ZhQE0EeoVtp0j2ktPTzBG7LmybE01VqWBdWg0B1o+KKFNPMnhZvaRY4rhtr/zpcx89lTXcwEzqd55JLPmadRngPcXAjz/5cuqqdqYWq5wKZiyODdhuQ1IxjobEMRxLrggzKWbc8ckn80mnlMiGeChvLClFFZtEsBJAvd2bwiqm2jcoXgpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INY26cD+R+naI7N4XMbmp1knUGYP2KF/uVwKo7vpE+Q=;
 b=fmHunqU1eQj8GjrJtkAe/2IizBbMJahBy4prafmOgAwEPEJ5p1hDMOkUt08BMjfLkRFCq1CiF/AhAm57IjOTq59vE8Ctnw7NSx+ZS7NnMSmGB6M24X8X5MBRb/ypc0ROcyyGLgwhgoWMCLiD7lg+QMnjXN+kCbHdXiVIYqP6Fo1Q/2Q7l5PnCyEjHqa5+4Liqiy+CG+V8xHa9BWPB3s974oMmMs86tLPCuFk+UBym/RS1cOQIS4os64CM9g4fZJr4GY2ZNOLn8S0qUptlVWd67Ei4Yfq2FNVVzagjYN0cld6eqyqMglqUZh/Pt9JKS0PQE6zwnPH4CxEkq/ZTu+qgw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.19; Tue, 10 Feb 2026 02:32:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 02:32:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Mon, 09 Feb 2026 21:32:00 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <92E87FB0-4C98-4E03-A2CF-AE365237D29A@nvidia.com>
In-Reply-To: <42cc23b4-4fd9-4286-8090-371cee180687@linux.alibaba.com>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
 <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
 <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
 <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
 <72534BCC-2581-4BFA-B3BC-2CC6FF1B1E7A@nvidia.com>
 <e69270cf-dac1-448c-ace8-3f789e5cdc6e@linux.alibaba.com>
 <71370B54-A462-4F72-AF82-8E076AF112FC@nvidia.com>
 <42cc23b4-4fd9-4286-8090-371cee180687@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fd9abd1-6fad-41b5-ff33-08de684c93aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWplWkJEMVV0WFpPdERpL2VVVzFSb1dmaUVLNTR3SlpZSnZLOHpTVlpxRkNL?=
 =?utf-8?B?NExEV0cxa1FkSUU3aVRGZ1UxdFQ2aVhkY2tlc1ptTzR0NmowbGdPNG42SUt3?=
 =?utf-8?B?SlhNcE9zSThqYjc3bm94NFVXOXE3cmg1UlZvNUVMTVQ0dXNlamxZS0xMcGtx?=
 =?utf-8?B?eWkvMS9pRXAxVU9OYTd0Z2VqZXBRTmlMc213Qm1XWW1iOFE4NTRLaW5NelY5?=
 =?utf-8?B?VjdMY2R1SEdQRjRZcHh4T1ZmSGRTYXFGVElYMzVaZDdLMlhZM2VuTW0vMk5R?=
 =?utf-8?B?ak9YNkMxNUU2WnRXSEx6SXJJc2tDSG1lNUpyUnRIbkJHS2N4b1R5QnBFWXhx?=
 =?utf-8?B?SFZyam1hTGYyTlcvMW4zcUkyR3VXMnRhYUpqZ0dPS21YRG1kRG1UekZ1V0hD?=
 =?utf-8?B?Q2FMVG9nUVFuTTJ6eFpSVmxtSE5za0R1enpKYjJPbnBkSHBFQjhqUHpCWWVV?=
 =?utf-8?B?cHlmZnlxYUhDYnprN1FPZGlzWnhWU2p4V3NTY0VoeVRtSFMwMm9TenNhOXBD?=
 =?utf-8?B?bHBQa1NIeWx1bTFUQ3MycWV6WitxNVgwNWJ0ZCtYRmZSVWlsM24yc0NOSXZZ?=
 =?utf-8?B?ZGUvMVVkSXJ1OGJ0ZDdyM3h2MUlGaFV1Q0x0NGprZWpkLy9KNC9kZ2F5YWdB?=
 =?utf-8?B?bXR1UkZNWWRtZU5mTm05TVJCME1DN2ZtQnJrZmlWSU9yYWxhbG40OVd2aWhS?=
 =?utf-8?B?eGw1aXVPYTRnMGUrVzVLTU1xcFVQR3lLTjlVUlJhdGxlSDdqQnRFZHZRNmtK?=
 =?utf-8?B?M2wyZFpvckcxNnFRWXdvK2JQS1IzaWdCdWVwK1dzRFpMNGE0M2tiLzJ0bmRa?=
 =?utf-8?B?Zk01eFpkSUxsUVc1TElManFuL1M3dzZ3WWFPUmtLY04zc3pTTEhCUlNtUWNu?=
 =?utf-8?B?WjFzTUk5RFVVeThndFBtNHF5WVB4eE9WOFA0S2lVM3pucGZZK0lzb3UyTUtN?=
 =?utf-8?B?VGhFcDU1RDFpTm51UG9DQlpuQTYvK2d6ZjZOazVWOEhndWNFaWpydkZybGx5?=
 =?utf-8?B?RjhJNW5TZGlOSFRBTWFhbjR2NzBDdy9GN1FQUmdTK20vTTJqNjFHSzBIRmtP?=
 =?utf-8?B?QTVSS0FzUkRqejU5WWhwY2U2YTZ2amFHOWJZc0M2ZXNzQjY3REtHUHhWaU1y?=
 =?utf-8?B?MVVLbXhXV2NXRjBmdm5VdzBBbVlSMEZNbEdUdHJ4a2VhV1pQL05iNGFCOVhx?=
 =?utf-8?B?WTIrMDJUQndRZDBTZG9MV0xkM2NobHU3c3U3MzV3TUZtalNIcmw2a0ZTNkl2?=
 =?utf-8?B?allDUkJQMEVKaDNNSkZGalBnWVhNUkU0S0h0VkxJZFpMY3RlMmJUaE0wYXVn?=
 =?utf-8?B?TEJtSnJVVDYvbEdqMWk1bCszMEk3RE44QmpLWFJPdzI4RHByR1NjSjU4RmZp?=
 =?utf-8?B?NjhWdnY1UUVZNjZTN0M4OEtWZVZMN0ZvNDdkcXJ6cmtuN1AyallQd3hXMElL?=
 =?utf-8?B?bUkySFhyY1BVTVFYbVlGbW9hZlluaFd3dXF5N1JkYmY2QWlkL29jdlpYWkNi?=
 =?utf-8?B?UlZubjBOVEkreE1ESGVMeFNLd2ZBSlN0aFBIK0dzMXBOWkFQNUF6UnJYaG9M?=
 =?utf-8?B?emd5YWx2dU1Oa0s3UStNNU1zUWZENmFXaXF2NFk3QnNiaVhYcWNiYkExNnBD?=
 =?utf-8?B?d29LbkI3ZE5pN2NTMmt5Y2RiQW1VYklqN285cWlpZXpBcHpJZjVoQ051eW1Z?=
 =?utf-8?B?SVFoMkV6MGpkb2lpRnlZbFk2eE1SNFhKa3JtY0E0aGdPdGxydmlXL2t0dUd6?=
 =?utf-8?B?UVd0WVVBUjE0MlYrbEYzSzU2MGJ3ZkhYREhBUG0zVDdoU1NMQ3ltaE5zZUFE?=
 =?utf-8?B?UGJmMDMvU2NsWEhFK1V6WVQ1V002b25vY1U5ZDV4Z01Gd1dlRzRuRkwxaHE2?=
 =?utf-8?B?akM4SnlzWk0xUGlaZitOTWYrZGxDV0xzNXhaeGVyNDYwamRHT2dUTld2MzhT?=
 =?utf-8?B?NXc4cFFDczBCSjMxMHJhUEdsNzdxajB6MHNuMVpaUXNCOEFQa3hjaEgvY1hC?=
 =?utf-8?B?MnRnNm1NQTluQ01mV1FLVHBLRTkwdWpoYXhZMzdqY0JMTkZ2MW1YbVJZaGxm?=
 =?utf-8?B?bEwwVmQ2dDNpMklDaHkwM0lDdDBudVNrK1dPb1JwUEtvSUM3UDdHZ2RXMHdz?=
 =?utf-8?Q?fvSA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0ozbFBxUHV3M1Jvb3VBZ0R3Q2pSWFFMa0R6TE1SWE53SVNtdS85c3c0Q1FV?=
 =?utf-8?B?MFRtR0MrT1lzYzRhUll1VHNqbWc1Q2ZqWXRSN3Nod3RRMFoxbkFFMENmQTRk?=
 =?utf-8?B?TUVOa3JPNW9xdUFGNExUWkJlOXNvL0tyRm0wNGdFSjZpR285ckdyUlMwUFdz?=
 =?utf-8?B?VGRxSVRKajhlazNMTzFtNExFTDdLOHlaMUFjTGJYcVBGczNSK0VKcS9mZDV3?=
 =?utf-8?B?SG5sL01ldm83RURTaDBPeGlFNDd4ZVNEMzdtZHZPQm1xMlVWV1dzZHRmYXJC?=
 =?utf-8?B?bFNndEMyZjYyV3R3UzBLTnMybHhXdTZ6R3cyeU1BMHZEUExyZ2hZY0YvUHRs?=
 =?utf-8?B?WTdKZUg4LzFQc3l1OHhQTXFOOW9TcVU5U2JGS1pPeFdEMU9wMFJoc29yckxM?=
 =?utf-8?B?T2VOc3BJZjBRVDJrSGdReEpGRGhMOFNsK25JcFZPWkxLNk5jZ0J5QjdLM3lD?=
 =?utf-8?B?MkNrVE1vNWJiaFkzVWRmWGNLamxValZHZVBOT2xwenVMb1VnVWljNi8rMkE2?=
 =?utf-8?B?QjRtYytjNTdwWHFhcDdzUERsdVR6eFh5eWJzbXc4a21DWmNVWEFrMGFia09S?=
 =?utf-8?B?NW1iU1RKRmQwNWdzR1VreVJ1L0NMMTlXcmNlQTVkcm9lcWMzVjFPTCtRejla?=
 =?utf-8?B?RG8ySC9Ldkxyd3pleDE2QmRKMGJoeGRxQWJQWnA1YUJvZDlDdldobWlSWUJp?=
 =?utf-8?B?aG1mWkhOd0oxQkUvYXJISFMzb0pJcjFQbzQrUzdOODQrR1Axc1lYM0Q4Wk5Q?=
 =?utf-8?B?L3NvT2N3R1grRU5LTkk1WTRXaHc1QkRVNVpMejRLU2RWa2huYjkzRXoySFNZ?=
 =?utf-8?B?WkkwZ0tDZmlDeHBUVVFpNjgrdmlLSlVkakgrTXR6dFR3cUVOUXRUbGEvTFRO?=
 =?utf-8?B?eFRCQ0wxR3lxNzVqL3Jzc29kWFZDZXpvOHFucWVGN1ZwMTRiTmtyOWFFQUIw?=
 =?utf-8?B?SFY4cG12S1o5T2NPbnNCcU9sM05aTDhFTm1iWXJPdEEyNlYwblpPL2Y0MDRk?=
 =?utf-8?B?TGJrYXVsZnR5UDdMYVQyL3J1dnNlREx3YVlBUSszQTE1RDIxUkpCQk8wYmdK?=
 =?utf-8?B?aHorWkRLSUtkOGtFYWhXSWgyTjlYdHpZc0ZKeHNHYU5vZHlLRXZiTUpFdlAy?=
 =?utf-8?B?RE5kYzVtZlZsSnVWNjlzQlZKYUZGaUNFVHBnbTVoQUZkMk5SQ2ZGS2NWZkZE?=
 =?utf-8?B?cW5NZE9tUW5ubHVNc01NaUpuVkdNbFNaREIvTTNWNXExUlF3aWlqRXRvRVp0?=
 =?utf-8?B?WGlyMWlxRkdMclRjWTZNUStNV2lsRkRXd2s1aE1jWWwzbnFXK2o4ZHRiUFg4?=
 =?utf-8?B?TGEyRDMveVp4Y2syR1IvbHRRKytnOU1uS3J0d3VuY0dETEtTdkMzeW0xU2hS?=
 =?utf-8?B?ZlBVUnJuUGpUM0h1cDB1NWRQLzdVeGhwYW82NFcxWW5aVmhnN0tSeEZFUUd5?=
 =?utf-8?B?UUozSFloUGJVb3MwdTF2bllOVXVkMGFFaGlvNVl5L0xBd3hEMjIvK09zaVFn?=
 =?utf-8?B?eFoxYlhJcmRVZjlxTTdYTXhITXZqUEFrUklKSWx3MDM1djNXbE04ZEUwTFh3?=
 =?utf-8?B?R1JqbHhjYkZkcmpjTVpVNmoyWWxtMkNoWVJKWmk2d1pDUHQ3YktCcE13K1Z5?=
 =?utf-8?B?RXNIbWwyc1hGMUZLNnFmeWxSa2o0cHRYc1BDelhHa215dUJKOEQ4R3k5ZGwr?=
 =?utf-8?B?cmdnLzVqenVKd3pXSksrUkQ4NTRralVJd1RxczNHZUFKV1lSZkpWQ29FdW9l?=
 =?utf-8?B?MzQ0QVRSOVF0a1lGb09UTDFWbjFOeU1yd0Frb3hKdnRiOW56RnJnYTJmV0dY?=
 =?utf-8?B?WDROWGNFTTRqVk8zZXZhbjRWT0ZheFZYZmRvQWx1ajlVMW1Yanp0RW9rbitH?=
 =?utf-8?B?MzFXcGNwQStXdWh0cEgwR09KMDdqd3FJRnBBNGliTjlIbUlPZURVWXMwekg0?=
 =?utf-8?B?eHhJb1Naa3M5aWtvMUJjeUtJa0tHZWpaRnVOQVVNQ0hOZ29kNXZYT2Vaa0Y5?=
 =?utf-8?B?U3BsKzcvdGtQaHp5UEhzTWZnb2FyS3FIUktMT3lyaEZabzJnMjBseTBUSEwz?=
 =?utf-8?B?RUR4TFdWOVpKbFJpNDIycHlXQjRjVWs0dkpCSmNBdVFSQ2J2M1RET2VnOHJF?=
 =?utf-8?B?ZGZDQXVvTmJxNXI1eHFWakE4cXAxUVU0d1FQRld5ZDhNbGYraExCa3hHZ2g2?=
 =?utf-8?B?ZjJvLzFDVElLYnpMV0FQdUJ5Q0U2UDJrNzM2Ymw1dVZjc1BWbVpITnNOSS9y?=
 =?utf-8?B?ZDA5cW9HUFVTUjlwZm16cUY4eVNwaVBXK3FMMENaOUM5TGQvaUZEUW01Wlpl?=
 =?utf-8?B?ckhSSU1ra3oyRmRVOGVtWlZnOEZGRDA1RFFFMHM1Mi9pSWRMWDI4QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd9abd1-6fad-41b5-ff33-08de684c93aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 02:32:03.8532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UABxb7LSi97ZmlbDDtOldazDLyET2n8i7CLwxeX5E25W3labalUYbJxeluksu/wm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8195940005
X-Stat-Signature: r1h9p3fthejuto8a3euqzom9crc43n6t
X-Rspam-User: 
X-HE-Tag: 1770690729-144379
X-HE-Meta: U2FsdGVkX19LfCWOLX4kWPZ3lR/BtPdflWAaHIfzqCaVBsae3bbqWGt18jEpuNHHFOYGXbcbhxeyFGwB82hB7QUahKIBTuRtyqqNk7heCIoiYjh7sSxDoNuTx1it0Po95y9GJZDTZSr+I4qcDSyxTiqjGxyfKrxFi1SVAC7aLllb8eudZga9kEHjz373MMKlhXb7SXGLIuHmqp9G5od01iHmnvSxfPy10t2Zcm8YLUe9/QNe1EpzXZnH99zAX46SKAZquUzR+gXK3xwogA15+t4Ncjq6LSZmlbrIHErIRfL1tA6x4qMpbpbwUO+AEHTrjspnF2El6IKvx6y91zk7nDfpnhrqHHkKO1LtIGiSX3po04qu+CC/f3auPbbtflc5I6wexSlqb7GOUHyNKtqaWOSrbltLz2dWZx5Q13wuJpqdCUgDAvTFl6c8nTgtX/+l2V4U2xHaQecltvr/4lY21gMGllUgYnIT/VY8p1MEzQMyTg5Z6jPwHSx+swoOmhSa18nE4TOeyubVFjTEvGV6idoeV1QlNonLScfMNomHB70HFA3+t5PmkVHfFcya4wwNjMC/QymT9M+Vhf61FLrDN2g0peCtc5kpVJyyEoFO6De5cSBLxbguBs52mAx4dx3RP+8ozw/+m3I4hBEIuOHf1Au9Xgja1leZv0RJurY7K1ahDJH+T8ewwOABvRWunQc8rEsilJU2Vy4MJXLcr20ph2no5KvcggdYVaA7q2cjSzC3qDo6OGqXB4qqmujn4Mp5+Ya3FB0YS6n++k+14l2tinHT1gdIlbefZXeAlfs6X29eu/04kM6zql38DNW1B6Oy6Jfxrs3kgdxuZWiO8WXTUkk2pjqFx02ch2DiEfIE2lNMrTAIEs36G8pLBdo1CQsSfnUWhM4KY5w/Dr9esCO7WWBXOclxUNyXC6OiUnayWh1Z8JUbt0Yx/ltIh398RnfJPsTlNGv5zKdMnhqR7Ht
 /HYI8JhK
 SAsi9MH0GgHktEtAZR3u/cmcBqPOSrpWuO4QPKIQaNstVQDRAaJ3BJtBoiA6/K9NqPRptsxQ8iUo7m2d0gXpScgfA+mXYXv4M0RhmgDzgwlASRY5lsJvnF88lddvoKvHh+0oxvUmTqXo4SGNMN5Cewr5aCf5mXy/ac/jKRfHAqahgiBxmuN+Q13U82k0OQGKQAykIieB17a002Pfo/f7xG+8XjW1jMRwigHaqE4NpTNb4RzGFHhX1XW6gBj28suF+Lj1YPnmemtsYDiBjp8yMFGeSGLqWEdkx5cWWFbpna3cywcVSA2A9YZnMyrJXTVcdwx3dUEUxFFmAU/EUv5LpvMdzVkwf45hwhNm0nKHOY9UpqdaEMAsdkDuAuyTbwaBzJlb74ub6PaL6zdFaVM5TNvBSeUioK6BkYZimjWq6Cdekr+bs/PdhjqlN6ZQM44aWaV7ZRA2hU9JOCa8xK/ucHE2qqAKz6+1AlV/qjn/3eaU/cZoflXUoyTh0N6Eb8cwKalSMtc1kps0KLBy+a08mk/ICA3SaoxCQqfnA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Feb 2026, at 21:25, Baolin Wang wrote:

> On 2/10/26 10:12 AM, Zi Yan wrote:
>> On 9 Feb 2026, at 20:20, Baolin Wang wrote:
>>
>>> On 2/10/26 3:42 AM, Zi Yan wrote:
>>>> On 9 Feb 2026, at 14:39, David Hildenbrand (Arm) wrote:
>>>>
>>>>> On 2/9/26 18:44, Zi Yan wrote:
>>>>>> On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:
>>>>>>
>>>>>>> On 2/9/26 17:33, Zi Yan wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> I agree. Silently fixing non zero ->private just moves the work/re=
sponsibility
>>>>>>>> from users to core mm. They could do better. :)
>>>>>>>>
>>>>>>>> We can have a patch or multiple patches to fix users do not zero -=
>private
>>>>>>>> when freeing a page and add the patch below.
>>>>>>>
>>>>>>> Do we know roughly which ones don't zero it out?
>>>>>>
>>>>>> So far based on [1], I found:
>>>>>>
>>>>>> 1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (over=
lapping
>>>>>> with private);
>>>
>>> After Kairui=E2=80=99s series [1], the shmem part looks good to me. As =
we no longer skip the swapcache now, we shouldn=E2=80=99t clear the ->swap.=
val of a swapcache folio if failed to swap-in.
>>
>> What do you mean by "after Kairui's series[1]"? Can you elaborate a litt=
le bit more?
>
> Sure. This patch [2] in Kairui's series will never skip the swapcache, wh=
ich means the shmem folio we=E2=80=99re trying to swap-in must be in the sw=
apcache.
>
> [2] https://lore.kernel.org/all/20251219195751.61328-1-ryncsn@gmail.com/T=
/#me242d9f77d2caa126124afd5a7731113e8f0346e
>
>> For the diff below, does the "folio_put(folio)" have different outcomes =
based on
>> skip_swapcache? Only if skip_swapcache is true, "folio_put(folio)" frees=
 the folio?
>
> Please check the latest mm-stable branch. The skip_swapcache related logi=
c has been removed by Kairui=E2=80=99s series [1].
>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index ec6c01378e9d..546e193ef993 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2437,8 +2437,10 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
>>   failed_nolock:
>>          if (skip_swapcache)
>>                  swapcache_clear(si, folio->swap, folio_nr_pages(folio))=
;
>> -       if (folio)
>> +       if (folio) {
>> +               folio->swap.val =3D 0;
>>                  folio_put(folio);
>> +       }
>>          put_swap_device(si);
>>
>>          return error;
>
> Without Kairui's series, this change is incorrect. Yes, only if skip_swap=
cache is true, the "folio_put(folio)" frees the folio. Otherwise the folio =
is in the swapcache, and we will not free it.

Got it. Thanks. I just realized that the above diff is on top of v6.19-rc7.
The fix to mm-new/mm-stable for shmem should be:

diff --git a/mm/shmem.c b/mm/shmem.c
index eaaeca8f6c39..a52eca656ade 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2447,8 +2447,10 @@ static int shmem_swapin_folio(struct inode *inode, p=
goff_t index,
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (folio)
+	if (folio) {
+		folio->swap.val =3D 0;
 		folio_put(folio);
+	}
 	put_swap_device(si);

 	return error;

Thank you for the explanation.

>
>>> [1]https://lore.kernel.org/all/20251219195751.61328-1-ryncsn@gmail.com/=
T/#mcba8a32e1021dc28ce1e824c9d042dca316a30d7


--
Best Regards,
Yan, Zi

