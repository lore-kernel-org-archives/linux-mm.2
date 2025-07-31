Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9261AC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 08:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C946B0088; Thu, 31 Jul 2025 04:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154E36B0092; Thu, 31 Jul 2025 04:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CAE6B0095; Thu, 31 Jul 2025 04:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E58A66B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 04:40:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B54FABA663
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:40:07 +0000 (UTC)
X-FDA: 83723912454.29.BB1124E
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id C049740008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:40:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fdSj6Fch;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753951204; a=rsa-sha256;
	cv=pass;
	b=gcKnszeRuFCIAqS3cg2EPRt3J7DBPgbOPRGe7j2l7v3PiE28TRMH1aZ8MTNPBbWQlK/n3s
	ON/a3zEpU+zSKomLoXZGQqgBlTjKICzE7nqz3ZxtBQBdsH/uZn0185/rN51k96zzsdM9sb
	fWCXfwaTfjVsCFtIDjb6wUPX5s2j5P8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fdSj6Fch;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753951204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VFSgDJ4NhZPMmGxfPrju8V+Hrt/F+cFV1B9pZOYG9w=;
	b=UGtuuJJ3rnLuSNNO3YnRQOYgwTNdslX5hfUbmhNn6jlPcSr9CIkkEgh9KRovy104UCFfmW
	8MyMspX3M9035KlS2fY6tSxAANoYrVlmrpKEDU9YAd69VlxRPTbwSQu7bK9XRV/JgFRTz0
	SKiBfWyuIr7AHOfYu1lCV1VdRkoZ4QE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t9VN7i3skXGopx/IF8Xgvel84z8g5kWx1GZUQpTb4qppXzuoATCCQ4dYBMrF2q780CT9qGe5AfGKqBi1/JMcruXKZz9S5tnKvL4FojoByA31QrTEnD/a214p0Qhg48yzCbOJsZQXqzbtOtpiTvSaJmKEAi0NBOgKcbcWufY0oJxkZKW1LbjAif5XLZTvKT9QFDhVvUFQ7h6k1jfRa8P0EfX0kPWMQ5gFb5NH/ypqtWct+Gj3Wxyp8DCHsT7Xjy2jXqiUtOf6fZgLH7qsO1Zo0YNqMMrN+g60f+mCiVaHPElInNlsJOEGVnZ0XLmkQDMHdtFBVOia8+LfYGX/H65dxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VFSgDJ4NhZPMmGxfPrju8V+Hrt/F+cFV1B9pZOYG9w=;
 b=EC4RmDeimyNxwi3doFc6Swou4YyjPWXaB/91ABzHZkvxGPM5WlyHWvx7iqdKdLAnkUAALkrif1X1ugMFFjLSuAm6gaUJdAB6avWP8oEiJUagvvlNXY0FT/ZCiEphzWikqRgo1Vm8ES7Gbm2dlDPLxn4MDgdbPdkXf8DrTDG6lwu460snFUwh7jb4W6xVGH9b/jvIharpzpjTVNcbRCOFP9yEdm8GIVrF16ROjjiEQwW6aXHnvcFEfVBinZCl85xIFWGuu5MK67aO2ACiAWmA1qO4mMpwDJzMD8fTHBmUfdtVMNdpNRe4GzI/WuOiOYJaJ8Hnq0ABM5TJkyUa3G/8Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VFSgDJ4NhZPMmGxfPrju8V+Hrt/F+cFV1B9pZOYG9w=;
 b=fdSj6Fch9xW4H2bA+hkoZ751uSKfAB7BsMSEHEIvV181gCaxIQl4Lc9xN73KYN7l4sLHFBz91HNWLxbp1/ikI8B2vx8KrQdVJemp9TWz14+5mF6aPjyM6o8Wf7pDl94w56tnZg2SSPMnGBO+zIGcg1IHsQkmVkDnF65i0ltTNIvf8Q+DdaL2beqd4oqFj1yvpq4TtGHu9179Sx02teWMDMN9C9gESNAfVRyzx7qGPSKDex2IqTSSuVtLuvXabK0j5hBKI1P5uXQmxEsFatN/9BelkG8WsmaOUHITOtGVM6Y73sJ1xuLAd42BUEs0ppZknY5jrHEvo//tfGDRTDw40A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 31 Jul
 2025 08:40:01 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 08:40:01 +0000
Message-ID: <fe6681de-66b4-4d8e-8bc2-a425bcacb342@nvidia.com>
Date: Thu, 31 Jul 2025 18:39:53 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:a03:331::33) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: d30f1a74-fa83-48b7-e418-08ddd00dd67f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZC9vQTd2ejNzdmptWVdoUEc4UGVOVlg2dE95MFNnZWx3dG5CeXZtbVcrTEFn?=
 =?utf-8?B?dy9MOWdjaUN5OE5vWGUwN1BPUVlWT0wzS0R3YlRBSnJvR2NHZFF6aGRJcUFV?=
 =?utf-8?B?aWJNdWdpR3pBQmRpTkxjelMzcHk4V29OZ045cWh4a3p4MzhVOW82dnM4TDVD?=
 =?utf-8?B?QlRGM3psSDFHd2l5RFRTTzY0SGVXRjNxbTMzdnZPVFl0bzlJRDNaRFk0YXBW?=
 =?utf-8?B?S25icFhNUHpyVjcrZFBzZER0K0s1MnVzQnArZm9GRi81TWxzR2RwU2hMaita?=
 =?utf-8?B?UVg5WVp5MlF4aVo1ZmN2cjZvZ1J4QW9nMnNFUk82SEpaaS9FMkhHSS93OGR0?=
 =?utf-8?B?cHZnMzM1dTBYVVMzL1FubFM0ZEt4Vnp5OHViZHBSWFRKRVlEVHEzUDhFQ1FG?=
 =?utf-8?B?cmtsakxnYzhDcHdKTWl3Z3A5Ky8zZ2VqdFFhV2VTTFRZNHlBdmJEcWJvd2lD?=
 =?utf-8?B?YnV6ZWRQeWpuTFJ3NGd3alJ0ckxzbmw2MHJReWsrNjgzZFo5dSttMEhRcUZ2?=
 =?utf-8?B?Q3VNalNySTBiZU1yRVJoNDZ1cVplU25PdlByZmhvRlVNN1B2Q2xmcWhMTmdT?=
 =?utf-8?B?bW14WUFuTFNrNDdXNldXSFViSC9Hc21BR3hQQzU2RjNjY1ptR0JSVmtHRFdi?=
 =?utf-8?B?cGZ1WUNDajB4U3BBcmNQVHNhZW1pNGlHU1pGV0QwSDl1MG1UUy94RlpVR2c3?=
 =?utf-8?B?M1NtNmJBcWlwNjR6dzBIL2JyVElTa1dkOW5xelFkVEtvd0pvQUlseG5CZmZ0?=
 =?utf-8?B?OHVtOUkyTFA1dGwyMFBGTFRaUDNZajZxZE9RejNFRjZLaTdCenZWUnNDZ0Vl?=
 =?utf-8?B?SXQrTEZZbzNJUWY3eVg0dG41bEhHNFYrM3JEK1M5dWpSRHBsLzlaZHpSMDBz?=
 =?utf-8?B?ZVRzenp6U2pGTkdWNTV6THRLZFlvUjR2clRlUTRNbS9MWTRBblB0OThwajlY?=
 =?utf-8?B?TU04K01WUGR4TWM2eU5lSm1qWm9OdXBscjBUTUxLYmdNUW9hZGZ1MlJCZ2Fn?=
 =?utf-8?B?UElUQjZqa3MvSkRMT3ErQ3NQT1JNMDdwWERDamhSYk1EVmZIWG44c1RjZ3lp?=
 =?utf-8?B?bkZsQzROYVEvUDZuMG81STZuY2xISGs2YWRQSUw0V3JENG5DbXBBNmN4U2Mr?=
 =?utf-8?B?b3hQb2QwcGVGbHFPTHo4aDR3bmgwRUlGSSt5SXh1Q2RWTjJRMlVEdE9TN083?=
 =?utf-8?B?eDQwS1o4VHM2aExEUTFFWTJ4dTNwOGVuR0IzK29WS2lZUmZVRFh3anRZczhq?=
 =?utf-8?B?TWRkZTJrOUFuRStLdnVRUlhqTHZySVZ2ODRYOEZTdkxaQjJNNm9mTnZEQjhD?=
 =?utf-8?B?ZFluMW92Y3oraGgwSnptQTM0ZVB3SUJDN2g4S2NOQkRjREwxVXlOcGw2YUJF?=
 =?utf-8?B?KzFpMnNLZGZlbTloeWtWcTR2c2pScmRiZzJ2dDRaWmVYUEEvOWJVQldoYlcz?=
 =?utf-8?B?VTV5eCt6cldvcjE4NzRnK2V5U1VFZHVTdnFvUjBkYkI0aHhmWCtnU1l3UTU4?=
 =?utf-8?B?UEpaMWQvdTFzRXFUQ1NVNFNRSXVPamZndC9nOUtNdVBDNzR5a0J0Tlp2alZ1?=
 =?utf-8?B?ZmJCaGtDcm85NElyZ1c5UFl5SmM5V2ZHbG1RZ3hKYTIrbzNDc0U4dzhVZjhU?=
 =?utf-8?B?QXh1WGZqUnZTenBxUjNHWVlHRksrdW5BRjVxYjRDQ0RLYzhUNzB2aWhWeVFW?=
 =?utf-8?B?T21zVUNveTFpdTZzMVhOQWJibmRjaFozbEM5RFlrTzh3NExZSjNOKytpblZ2?=
 =?utf-8?B?ZU9DNHFuam42Mk4vMCtTaUN0ekJsZHlYcm96M29MU2VqbmNpQWlzOXNlRjl4?=
 =?utf-8?B?RzVKTkMvMWRjN0VGWEdTMGZiZi9JY3FycjVPbk40YTF6R1NyaHZ2ZnpEYTYx?=
 =?utf-8?B?Umw5c2ZxaGt1S3Q2QWxyZzlvTW5QQ2gzb3VEWnlhekVtc0lBLzlkY0pmYXhI?=
 =?utf-8?Q?wxp7TioB0xU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm1WT1V1blpmMHhQbVB6WkJnZjI2dEoyTXdUMWh6aEh5S3Vsa3FjYjkwNG5u?=
 =?utf-8?B?cFl6dTRUZXdWOE1wajhSVDZaWFJDOFdxWWd5a05iaDl2WnlWV0FtNUR6c1Fq?=
 =?utf-8?B?WDVIeEI0SmE5MWp3T0MwVkw1NlIrajZ6MlRrbHNtY3VoaWUwQTEvNm4rQWFs?=
 =?utf-8?B?WDVTbU9SSFNhRlZZdThrMm1LbXVDcVBPWnJqZVpBVnltWnVYWHNIOVFjUm9N?=
 =?utf-8?B?KzVSS04xK2ptOUxqN0VFeDE3L0NveUVQZmdGdzN3NThwVGx1RlpmMzQ2b2Vp?=
 =?utf-8?B?bC80bzBvbzZhbzEyMGVJdmFxSHA5bDZCMG1ZdlNldEI3K2dBOWxmRjhGWDNG?=
 =?utf-8?B?d1BYcGJuMUcrVkFHcENHajBMWnBPdERNRDRWb0JkZnJlaFdDTkl1MTJ5dGkx?=
 =?utf-8?B?SWVKT01nWFE3U051L2xUSkNZemMzTWVtOGxkYTZOZDR2UjYwT2hlNDZzT2dV?=
 =?utf-8?B?WTVlNk9tL2xsc2taOHlmbFF3SnZmQUZqbHFZc2ZDaG1xL01KMXlGcXBDM3JL?=
 =?utf-8?B?UjdmNm9vSVpNMzdqanhzbTBlUEpUZkV1WGgxNXRyZEdDSTgyMG5NM3BVd2pL?=
 =?utf-8?B?NUk5SXpFMGYxTUFvVys5eHpWSnRYam1POWd5M2hLMmgveURkbVRybHBYREdV?=
 =?utf-8?B?SmRlcjVTNmE4TUU1aW9tdkM5WTFIVE1Nazc5blFjS3NNNFR0Y1BVSkpPNDg2?=
 =?utf-8?B?czA5MTVaZ3lHWHBUa0FoRWpYc3d4RlVjbHY1K0RUeVQwbGtxWFRVWkpCK1Ur?=
 =?utf-8?B?SzB0dmF6cWJDM2o0NTF3aG1ranNoNk5OSXArcjBZMThOa2pDMm9ydzVzUEVj?=
 =?utf-8?B?aFUzSDVnSlFlaWFTMzhFUlJ1TzhWUysyWU8xc0hzaTE4RGxORytWTFJRZkRm?=
 =?utf-8?B?U1dETVl6dWZkYlE2TzI3dG1PNHVKdjgyN1BmdHh6Qll1YnhNSGxMeXBHZEYw?=
 =?utf-8?B?aFlWeHBzS0tqMVBET2J4b2pBVzZYdCtBY045RWp4WXVHOTFMNS8zZ2tMbk5X?=
 =?utf-8?B?RCtqdlRnei9PN00rUXlSWHozWDIxcFhFSW9hclJzZktFT3psWmI1b3hIajZV?=
 =?utf-8?B?UDE4MVRIRXdKbXNUeTh5ejBlakVrRXlLQ05oMkhWT0ZpbXVsR1EyNXZPVitx?=
 =?utf-8?B?SzFGMHltWTZoL2E1SmFOSjVZcURuaDZ1bHJrTGZHTnFxMFBVQ0tyY3E0dWF0?=
 =?utf-8?B?MnpUdXV5MDY1ZE1Md08wbStmZGZVUmZGL1BCcEFQbFhIQ0ZFOW9PMGI4RnRk?=
 =?utf-8?B?eWVzendLcDQ2cW12NnhHbHIxeUFzNlFGWDAwYzkvTDdYamtlY1VlQzY3dW1B?=
 =?utf-8?B?TzJRTTAwZ1FaK2NCbUwrOHQwWkNFS2hTaHMxT2FWRm9LVnJweDBSQ01uaENL?=
 =?utf-8?B?eGlJaUtOWTZmR01oVWx5dWVnTDNYNFpRZnVTTnFBUGQzMlI2YUZJRnJsLzVL?=
 =?utf-8?B?d293RG5aUkQzbzZKdGNOMlpQdkEwUGtkT1RYMkFwUzdWOGtoRm9LTXBBdXRo?=
 =?utf-8?B?ZjkyYVJhdVpTLzdMYmhJdGNDSzJIcmlzSFRFa04vVW5UZGROK3VSK0ZmdTIv?=
 =?utf-8?B?ajA0d1VlelZFMzBCN0hMdVQ2TTRaemdUdVNaYXNrdkt6YVRXTjd4R2pyNjQz?=
 =?utf-8?B?SlhoNDZTM0FhTUxnV0tyckJBeis0Mmo2UENhTmdYTkh3L2o4S2tjL0RGVnNt?=
 =?utf-8?B?ZVRrc25ETFIzb1o0OXZWUnRRWjh1R2NaNk55bDQ5eEROWjJRckFhalFBTzVY?=
 =?utf-8?B?VUkrLytCTHRBWXRZZFQ4SGxFcUI2MTU5TUZwenNWeS9JbDB2K0RzaGFJWktS?=
 =?utf-8?B?S2lYVG1aaWp3KzNYRCt1b25CaW5kYzVEUElqNG1HNkhFNzV3c2JMWVdJN0lo?=
 =?utf-8?B?cnZKcHJacGVPQVZKd2xpVGQ4aDIrYnJJZEpEU1p4QlJkVWU1NkdqRnlqa1VT?=
 =?utf-8?B?R3A2VVlYVnRmYWdVUlkrZzFRbU9iYlZoNDBpRHc0ZjNiRCt5cXIycitnUUxQ?=
 =?utf-8?B?R29DN3VqL2xUNnR6bnNOSjBzMGdFOW9QalgrSGRhWDZVMXQ3Z2c1eWFKSlRO?=
 =?utf-8?B?U01peCtac2ZNcGFWQWtOOVpKQWN3emlpdkZFQzZNYk9VK3BmdHhQTTNjbWNJ?=
 =?utf-8?Q?O3AQ9+ZemcberDYoi1GHnRtVe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d30f1a74-fa83-48b7-e418-08ddd00dd67f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 08:40:01.0030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mS/EB7ZVcwDpTaOHtiyvTOZjlHUkKwDqQSf9L9pBzns3pLPYFSfRtoCnFJhyXE2ixeDE58stDdyj0BP64qDb9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C049740008
X-Stat-Signature: pq8j6ipwje4rzfmikuxd4tx6uz74mrdq
X-HE-Tag: 1753951204-54432
X-HE-Meta: U2FsdGVkX1/KjugqCKMQ/XBKafmVAoRu5dcGrWqq0Ma5UuwNjwLFhE7GvV1z97qKR77mhYf8mPlM1E9OYsPIAVzG356wqIrtMnWAkWYiX8vLRzhzJ9zJ+/PhkCpqKb0F9mF8kKLjNUv/2ccJNdfFhJBE2C4bZr0K63BoJYB0Pkw4DcQiFE+c8wmEhjP+LnyoxG6c8aKenZKbjTbojwqga+rLTg2qjVAW+7nN9NUaO849BGpsU/8mbVgURbfmyW9Xy6QkUihG4FFvVrkEZv66QUrmOt0yzCTkSvfQTkqyh+swExszjgSAMdCHhmbX44Sys+nu0VoPnQL2I5+7xytZoMCzEuMZDyjc+dB8cSqdDYAE6tNPGUWZLC71+wamzwn4pfqeT/tvack4051ohjqhTZtuLthXTz2iYqFQpF/+NkJesmstsMibxdep47oIg+qFgAX5F0/CvbSwY9Ha4PaVWRYeRp35e35JtaPF1I3WGxb0culdv/YN8YgW4PRGvi9m4E1pG3SC1JMNNUPIC8TAM6Zy5EPYqjkuANPnpJmsJYgBokc6TJVtVIZfMavuV2HXair2jegcFgncvfCCzGgDKi4yVkzHML/GWRQ7yP+nPJpCkOMfQbSjVzwQigQQ/URKpRPmDFuqjXVGwKNSBd2m5KLhBCiv6QA5V6aRcyayi6BsDpUwo5z5CYSJcAC7wbPxDQ27ywNxUKPu6T4j5FtdJxeasyXoveL4M00TBkysJqbsLnjauBcvZyfqkfE/762v3W/bZPMeK5QsXeh1j9RlAz8pbvrjV5axvLS5ZORMCE+yBsWzeYmSpoiuaU8NTJD+QTKAuxLFxCJdf8++paZwptxPUGLv0AHhPAfcGXW1DZGnB62qrZ9DgA2/fLbmDcpuPGLQOmVdemsWK8HIfIfo5W66p7Xmryoz6rLcfX6F4YmQDRRfHRfOKBto3lhiOTezdR81V5y7DGnts0WO/vQ
 Rdhvaorg
 rwULP0pssHbw8Ba5EH6hiuZ6ACfVOgBRjjbpDcyhBg6ip58ByS6Ow/kUCP3o9ChrSG2PHNysgQXE62avCgvzziSWqNibwRmgnxZ1FB3gPF+mxna+G016BuQvZCF0x/SU/OCpMTEM6P41qEeT69HXSFEFmB6vwpnYczFt0/p31yGvVI89gzWl4pAT6T4o/I/UTdjcjn9YETFFubMqVaYJik4Z8gpGZCOGItBWjnujO5fj6J30sm5Si5zp1o1m6JjPTeQ3drbTI1waZaAYn8fLGfJUxNby2PiHy8X+II7W6ulW82otuIGbG0tZ5OqfAaMGsRydPFo8AVSp3/NhNYd3/MfXJ9sQ0DBUXQC+EsUzI217079IgP8xm96AIdbzqA/C5lFJZoYo3lkdt6dgM0cvxE1K1mVSRopKnE51vb48J9dwSUdKnwFocFu/psSJnMUySv2YkEiTb99qJ4bx0hVr9uLlSLJDooWRUutq17DLaMxIVeClN+bJrjP6tq2/onRKji3bUaGbuqa7IE7Kxxx70CS0l/hmwC7/qtkKWlNhRJh7CdXfd5odAWSHbrdPEL1UM3SGTHomou+kjwwvuFJdwW3CHjGjcekyfjK5wgcYtrEtvO7Y9lv1JfDLIhLq8NUszDL5D+5gDtT5WHhc7mN3AuwCSHsu4AyZO+8BT5/9pqP7y3qe/QQrArAqxMFcmUlS5zqaOdKFDVGC0rKjGlIk3xnsP59gvE90XUyhcggW3Sgfdhuhq+RbeWIS8w7bO6H60luDKnK6nTgz9OViM7j+wfAyk9QiWV5Umd4ovpvTo+GQsRpnEuYbNEbS5wzZ1cT3PAhvTZe+rsIJmjhW97cWztg1o/Vp+3eJNe7ncCaf2NW93Axk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 17:15, David Hildenbrand wrote:
> On 30.07.25 18:29, Mika Penttilä wrote:
>>
>> On 7/30/25 18:58, Zi Yan wrote:
>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>
>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>
>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>
>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>
>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>
>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>
>>>>>>>>>>> <snip>
>>>>>>>>>>>
>>>>>>>>>>>>> +/**
>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>> + *
>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>> + *
>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>> + */
>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>> +{
>>>>>>>>>>>>> +    struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>> +    struct folio *new_folio;
>>>>>>>>>>>>> +    int ret = 0;
>>>>>>>>>>>>> +
>>>>>>>>>>>>> +    /*
>>>>>>>>>>>>> +     * Split the folio now. In the case of device
>>>>>>>>>>>>> +     * private pages, this path is executed when
>>>>>>>>>>>>> +     * the pmd is split and since freeze is not true
>>>>>>>>>>>>> +     * it is likely the folio will be deferred_split.
>>>>>>>>>>>>> +     *
>>>>>>>>>>>>> +     * With device private pages, deferred splits of
>>>>>>>>>>>>> +     * folios should be handled here to prevent partial
>>>>>>>>>>>>> +     * unmaps from causing issues later on in migration
>>>>>>>>>>>>> +     * and fault handling flows.
>>>>>>>>>>>>> +     */
>>>>>>>>>>>>> +    folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>> device side mapping.
>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>
>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>> at CPU side.
>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>> add code to skip CPU mapping handling code. Basically device private folios are
>>> CPU unmapped and device mapped.
>>>
>>> Here are my questions on device private folios:
>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>     perspective? Can it be stored in a device private specific data structure?
>>
>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>> common code more messy if not done that way but sure possible.
>> And not consuming pfns (address space) at all would have benefits.
>>
>>> 2. When a device private folio is mapped on device, can someone other than
>>>     the device driver manipulate it assuming core-mm just skips device private
>>>     folios (barring the CPU access fault handling)?
>>>
>>> Where I am going is that can device private folios be treated as unmapped folios
>>> by CPU and only device driver manipulates their mappings?
>>>
>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>> someone could change while in device, it's just pfn.
> 
> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
> 
> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
> 
> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
> 
> 
> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
> 

Thanks for clarifying on my behalf, just catching up with the discussion

When I was referring to mapped with Zi, I was talking about how touching the entry will cause a fault and migration back and they can be considered as unmapped in that sense, because they are mapped to the device. Device private entries are mapped into the page tables and have a refcount associated with the page/folio that represents the device entries.

Balbir Singh


