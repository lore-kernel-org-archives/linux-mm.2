Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA58FCA0FED
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 00:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD3F8E0003; Fri,  5 Sep 2025 20:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784718E0001; Fri,  5 Sep 2025 20:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674228E0003; Fri,  5 Sep 2025 20:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 544268E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:56:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6DB21403BF
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 00:56:44 +0000 (UTC)
X-FDA: 83857010328.30.1D242F5
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD81820007
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 00:56:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GYPa3otQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.92.43 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757120202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulyrv72imzgvBEmRd4gms/VVhvwxfm/xNHNteLnPDUw=;
	b=KHy3/vtal+4EbEnFN4rsDfm2Kkr/ORUgjVTnaZOhug962G7jO1BqK6bUP6gzEXFSTJ9sRs
	LOI4hBtffBMjH7sVwOvlq7nQEkYGkB81M6wssfAw0X7suLyCNdwya5YQelKGukikbuyNAK
	HaElHfBP8N9D/dlQDE6iYiN1qHD+lc8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GYPa3otQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.92.43 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757120202; a=rsa-sha256;
	cv=pass;
	b=srbQhZOP4/2JhAscBRhx2CABMiBUj2oU3gYYxc8wkVBJDN6ojOJcTJYwFVJiepVCJYQcNn
	Z2DnIgYYRf3fs5wJlu/33acWBvQHpCWQp43nJ0BgJBI3Z3tQ1GOpShZkmkwklH4Sybpuad
	OQJ+tj7foAbr+T29GfucioFOVF048YQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rqx7y9eNIV/J32Pe66dXlgUZOZ34NLHMF98iDRICvWz+QP0ugEKrSJl1PrM67Ore/WYZ0mAtBn+3O/qs6fIAhDXbSMQSoWBsG+krpcyTOASfouVmhr5ED9pDbp6xd3NAyKI6Vj54QsfWmZoKrM4Pfr4pD4QjaZrXCs4/u/oiS1M5CJ4KV+ktd3F6mrFOpNmFUlNcFT3hJgcSZcjOUbTqKTrAwah7dkPiUqSxp9XRFM6GbHjbImI4vdvfHIGwS2Kn9Vid0KZTC3dd12C8JK50hzYSZ8DWKpiP3oa4hJ1jhm1dd8hhfvknQDcsaoubjBWdDrfwT3UAEpAq18pJZxYzNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulyrv72imzgvBEmRd4gms/VVhvwxfm/xNHNteLnPDUw=;
 b=YO6W57sZ4V6W3Ksl+C3/MyvkY3VDpS2KamfXf0/1dXYSS2PPc8FrFZ7XsSXOxNNPSvbeg41WER4MNCZqp92YZ7AsQYNjuoM4abGqWRbtsdoqQJG6MQpIzjfQpOsiQV1rtFEQT4iOsld3SClbVz573t9aFD+mvgE7V7LDsY525te3kzU/1hDCq/g5mc3NiXCMkmXY6iJD0LJluxsCwU7cEvvK8FYiQQgls5s7o8c8lX31igPj6zPLaRWeLW2DHixdZLf0xL4EvXHUxxrlmk9Tp6EUoQvH4aO2mjbcgRuLs0rV7ttymtalUCNSSFHPsi+CYK3zp6erbW9ebTrc8lutJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulyrv72imzgvBEmRd4gms/VVhvwxfm/xNHNteLnPDUw=;
 b=GYPa3otQvYtMEwnTXbpBtF6VfL4hReenOq1+lxtrXl23MvtIi/B25sT4gu/IvHx3nXYVLIF2qbqPRru2Vdfx230ov5r8JReboHS1AbB406LtDuj8MGGx+HRqljjpynSL1t0NErxGx9gDyQIZf8HTNMKAOcHF1/0jWnhk99cjJcs4EvUV6OFM6C0yGY1End6j4vB0fxGr9Ef/iPZAtAR/TNlfJzVWgip98NJ/4Gg7yUPeNIeimtrbSnw6BV4++qAWcUgSpY+v79MbKToJemiTXvWHkF4sejbEJAuoAOtzq1f1+xwGH0XGA5CZh82/aivcfg7g/ycuQROb6Da0tQa9LA==
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by CH1PPF931B95D07.namprd12.prod.outlook.com (2603:10b6:61f:fc00::619) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Sat, 6 Sep
 2025 00:56:38 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%6]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 00:56:38 +0000
Message-ID: <5f3b6bf9-1762-48b7-bc36-705055c99ce8@nvidia.com>
Date: Fri, 5 Sep 2025 17:56:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/gup: Remove dead pgmap refcounting code
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: david@redhat.com, osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250903225926.34702-1-apopple@nvidia.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20250903225926.34702-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::32) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|CH1PPF931B95D07:EE_
X-MS-Office365-Filtering-Correlation-Id: d27d84c4-bb2f-4036-4137-08ddece03be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXBQOWVsT3RJRDZRSjE0aVdSOFpRME5hZXdFUWtnN2VkcWtCR2ZyR1d6R1VO?=
 =?utf-8?B?cHM4S1pDditSL1RBOUlMV1JTcW1mUlFDZXRTcTh6amNVR0thVlBPbkt0TGxN?=
 =?utf-8?B?NXRVRWdxYXZ0Y3JBTE1oODUyL0dIcjdQaUlnYXlzVURGaldhNlpNb1RZckxJ?=
 =?utf-8?B?R2lGbEVLRkhlNjIybUI1UmoxYlJiUzFUMEJMbUhPUEpYV2FuY3lwT0Z1ZmVl?=
 =?utf-8?B?Z3JKSFFsSW94dkpxZmM0c0hZVFNUYnd2ajBkaWJSTk8yU3BKcUdraGp1Ti9B?=
 =?utf-8?B?R3VZWnVTODhaSXBSeXhmeStMbnJkdGE5VDVZeS9ENHIxeU9LWU4yNzRldlBT?=
 =?utf-8?B?dEthUjdlaldSRU5uMEZlYlJGVk4xaU80NzIxTkxaOG5HZVhNR3d3MHNZSDh3?=
 =?utf-8?B?RWZIV0czQUd1bUk5YzdrSkY2ekVxWHZURWUwQWwxWWprZHlZaldWWXYrcHQ4?=
 =?utf-8?B?cnBsN2lmWnJwQmY3Wnk3VVNuc1ZOY3lheUhXYVUzdTRnc1VIdG9SeHFxV2lV?=
 =?utf-8?B?L0hXR0d5aDFQb2FPZUJCMmg5MFBXcUxEQmJpMzR0TEFrRGxMY3NGZUR2anBI?=
 =?utf-8?B?c0dsTzhYOXpuRHdiL0RUdFpnLy9CVWFsRjRJVllCSXlvNVdMQkRlOEs2bUZ2?=
 =?utf-8?B?N2puSlByRk01dWg0ck5mQytmM3k3dTRyeUQ5RTB1ekJuRmxHSEVDd3ZGenBD?=
 =?utf-8?B?UUs3cktodlgrd1phVTNFSkNrYXBuSTNldzRlV3J4bjN5cGRqNG5xSHZsTFIv?=
 =?utf-8?B?V2dqdG5aZzBoa2dLQmgwYWExT2pqTUtSNms0M2dSdnByQnV6dDJBd0toaWtu?=
 =?utf-8?B?RTdzUmZKM1BzODBXaUNlbUFLZDFJSGxRbng5Ujk1MFE4T3I2Q1FTVHhVVFVJ?=
 =?utf-8?B?MGRxbngxTXgxU3ZSdWQ2OXpDWlgzMmtJNzVmcEtTODl0STZFdTlCUXRwVklZ?=
 =?utf-8?B?RFpiTXFLeWVYS0tXaU56NnVvcSs5aGV3YnhEd1JRL0FCUm16QnJzRWJvU2F3?=
 =?utf-8?B?dHFobDFuTXgzYjlMczIva0RHMy9vYU56bk1mbHYzV044TGdlakc0bVpldWNt?=
 =?utf-8?B?NXdUOThNMFJlSnYyM0dWN0YrTVV1Ni9sQW5uVnlrWUg4QVl4VkFxYWlNc28w?=
 =?utf-8?B?b2srRTIwOUhEWkppNlhGY3oxK2NNVjA3VUNzMVVJVldCUjdGSTc0SnQvbXRz?=
 =?utf-8?B?VVVETzRlcWRybFliMGhGdFhWNG9TZVA0UC9kNUs5Qk51b1gxejVSVEd4a1l2?=
 =?utf-8?B?Sy9NMm1HOUYxQXd4NklsS1h6SmRtdzhOMGpzNUZrVDdJY2ppSmw2czJDYXBC?=
 =?utf-8?B?MWt0QUpFNjdBYVhkZXNmL2hDL0Ivcm9vb0pmeVU4UDNPTWxIbjFzbjNFeVBn?=
 =?utf-8?B?TTViclNyYW1LZ2lGQlRobWRCSHpDZFNINlN4ckN5d2xhTnpVcDV5Q3Mra0lQ?=
 =?utf-8?B?V3JGNE83K1FMdmptV3o2aGtkcmYrdVlxTnlrZXQrb1dKRzdUTVgxYlJ2aHlF?=
 =?utf-8?B?cUI4dDJsdWF3eXZNVzlwWGRWdTVITVlUTm5pa3lWb0hQRjFkYitJR21HWUU2?=
 =?utf-8?B?UXZ5bEZnWHdUUjd1SjFrb3AxY3pOYWZsbmJsRjJuWjRaOVRBUGltanJ4QUtH?=
 =?utf-8?B?QWQ3MFZPM2MrZUNwbGNsSUxDOXVLK0xid2xCZEZkQlR4eElVQ2Q4YUNpRHlp?=
 =?utf-8?B?VkVILzVpaS9wb3VqOEtITW5yYUhSek13bnBYY0l4RUlITDQ5eVNBMjhZTkY1?=
 =?utf-8?B?Z3FkdzA4SlhVVTlicS96VEpjeU42c1ZnbVgwa015NW11NlU0Ti9mcHVUZ25C?=
 =?utf-8?B?RElVaDkrUWU1eDkzNEE2Z0RHczI4TUZkcXN5M25jUWRyMzNFNzJ6QXJQVFFz?=
 =?utf-8?B?dnZiekt2S25UdXJ2blZNQTNzRkFmclpKd3k4V2phalFERHlkQm5hcmROd2FO?=
 =?utf-8?Q?OxmwGKZwfi8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Si82MzAwWHVpL1Y1a1laOUxYeEsrZkhRQzJZTTdNc1EvaDR1RTR6YWlXMURX?=
 =?utf-8?B?UDcvaTkwYXlaV3FKVTc2TWNSK3A3NktjVmdTTk4zTzBNQUFPdDNXZ3MvM2ta?=
 =?utf-8?B?NmNBQVRrc2RXdXdiNWxGd1g3dTVPQWtsM2xKT1ljRjJoQWtEVWl3NzBVcHJp?=
 =?utf-8?B?SVZhSEZGakczY3BycllkdGdpWlp3NExocVh6dkVDc2FVMXpZQTVwbnR2NmhD?=
 =?utf-8?B?NUhvM21HaURTcEVMMXMxK2ljVm5kb3BVZ2xVeHhHNEZXVUVBMXc3OGxYcW5R?=
 =?utf-8?B?NmhFM2haREFXb2I1UE9PM3dQS3lkSXlBeC9qTUF0QXE0a0JCU3Npa3VVZjdt?=
 =?utf-8?B?d2ZMMHNPYlBSWG9sNVNYVU1BSkZtZGdkdTJleDNkWnFZRk1JTEdrMGJwL0cz?=
 =?utf-8?B?UTVsZW8rektZMnA5SC95WmFGY2NLc3htMW1peUllQ3Z4VTlTQ2ZMRDhIMHlz?=
 =?utf-8?B?ZWVSM2JzeERWYzBMb0VPSjl6NHNMMTNqTmNNZ21ZYy92OGZDcFBhZVFpWjVE?=
 =?utf-8?B?Wmdsb3I1SmxKV0lTVFhDaDg1d0EwVXJJSDl1Z1dvRU5Ec3c1R1JtTFB3TGpD?=
 =?utf-8?B?N29NN1ZnZ3JFcnZuSmZ6RWNlaHV0YmUvTEszRW9PeHhGeDBxbGFjeHVzQUww?=
 =?utf-8?B?NlZ0L3EzUlMyVHpqUEpHQWtvcWowN2MwME02VSs0a0RFZU12NnJhZTJMNTYr?=
 =?utf-8?B?ZnJMMVZLdXdBejVjbGZWbnRFcURXM3ZNeDNnWjlJVjNqNWJ6Q2VFYUNPZXlT?=
 =?utf-8?B?M0txY3lSOGY1UFdGclR2L2RXd3BxK0hyendxYXV3TExSald4NHcwUCs5a1la?=
 =?utf-8?B?RzJVTk9Id0dTSGp2NlJvMGFmdGI5ZVp2WXJ2Y3FienFvTFB3T1BqeWxJMTBV?=
 =?utf-8?B?RzNZWWlQUHA3NkFLMlJEc2RLdWRKN1dmTTRvc0RYdFM4blpRT0hzZmxsUnJq?=
 =?utf-8?B?YWwyaTZUY1BOMjJwR0dFeFJHZzluZmtOenRUZTYrcWMrenpPM0xNRlRTR2t3?=
 =?utf-8?B?STRTSzlsdUg2TTVCL2JBOW5BQzdTRW9zaWx5UTk2YmVRbnNBNnNpK0ptVWlo?=
 =?utf-8?B?c1YwNFhCWVBkdDRjenZKb3k1TkRhWFF1RHhWQmwrdEdMaTUvZnlKNjhoa3la?=
 =?utf-8?B?QjdSSWwxN2ZXZVBjeXJFS0hHV1VOK1M4ZGlrajd4RlU2RXAvcllZZEpBQUpF?=
 =?utf-8?B?eXUxcW9JdlF5M0FGSHdDSGxoN01xY2VENkJXcGZUNGgxaXhoRE8vcTN2UVlI?=
 =?utf-8?B?bld1NVhGeVZUc2tkMVQ5UGU0VHN0TUxiSGVheGZvUGFUY1BMTG9IRDVEMnVJ?=
 =?utf-8?B?OGNyRHBEYVQyRlhGc00rRGRYc3VQSVQzdGdjNzN0NHBJM1FDTHRJWXZLQ0lC?=
 =?utf-8?B?SUptOEo5NlVXQ0Y2d2NFOHowMXJCZkd5UzFGWWgxdFp1ajJ1TmlCSUtGdHV6?=
 =?utf-8?B?RTRjdHRrblNLZ0IrQ3Z2enMyM0tQaXpNS2hVRFEvL0VkYzNrOGwrWDlMWmRW?=
 =?utf-8?B?TEUvUmtRNmJJTG1lR3FOUHdudGN6YjdETGEyZTRqWUUwaktZajBhMmliQTFX?=
 =?utf-8?B?VFZNVmdmWm5mY1VyZk9xempOQXNqTjJOeE1MVmJ5Skp5RXI4Wk0vMDNZQitS?=
 =?utf-8?B?RWIwaU9IZGMvY2xJNE9ic3NsQU5CbXdiUEduNk1iMHpVRXNnZTF3V3IwMWR4?=
 =?utf-8?B?WjA3ZnlLeEtJOWxJNUttOGk5OFRQMWNyQVFQYUk4K0pFa2ZQSHRLanhaalpt?=
 =?utf-8?B?Ym4zbHlmMHN5VkNORk9YV1BkcU5WUGVLYmtzNy9jUEFINlZqbXFvcFhhWTlS?=
 =?utf-8?B?ZkR1Q2Z1allJRlVVNHc4VGJDY0JsNlJmMWRLdVVBYzErak5nVzVHZXNsSXEx?=
 =?utf-8?B?MHJkUlAvanR5U1V4ZVo3K2xIL25vVjlyeSs3Q1hKWHZpWlM2ZjZjcWZhTk5N?=
 =?utf-8?B?WkJ3T1JtMXRVMkx2Y2FONHMrblhtZTNDZlBLeklrL0RacDI3N3BEd2RHcTE1?=
 =?utf-8?B?SUtYMDV0a0lGeXNMTmRpcVE3Y0Z4TDh6amx2L0c0ZTdiY0JHekVKZDJyZVdp?=
 =?utf-8?B?ZlBFQ3hkQVN0UzhmZ3dwN2VhbkJZVlN6MGZta01TWHNrKzFmbC9xMUVmTUJP?=
 =?utf-8?Q?QGPa0BGuCe/bad1Gu7FFGLkAA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27d84c4-bb2f-4036-4137-08ddece03be2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 00:56:38.0180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYI5WIo9vKtoe8KhUTC9nNRJYbht4WtXNHwuAcHONQmItRrJqlHCh9hF3OtuOeFAxckbba2keiF3xbfkhHsUYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF931B95D07
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD81820007
X-Stat-Signature: 1yg196qnzpjrf9tn7dpb85ziwmgi1xf6
X-Rspam-User: 
X-HE-Tag: 1757120201-278519
X-HE-Meta: U2FsdGVkX19t0LrHTwxRNOluL/+NaGsSTt8KGtpzSFckjNOCHlCm9E+SA3o/VdGDvjUbhn8qfAp0fUdXkMCxsmPIrtEodr4t3Z0lr3k8PGJyhJtdL0ToKlkCHm6gAMYtzfs+ODuuHrK0Ub/zOYsYTevkUFMiwYtiOubnFeS3geJJu9Ctia2w1II/z9S3TV12mJ1k/iQTUyb94aaUw3zKCK8s9NFisSL90kt559dfVx7XSNNA9C5nCB34ywoKn7wEmT0EHKXvzdQf0VcYuV2RUtDF7YmftK+NM9SApDDEcry+Q7LXDuIfigRHgUceKdd61/w9rsoCYyruMQdW8uZrlc8qib4BQ58CnlSDRaL1M+0qZyRucjpBUofh/QJMHEBPF4MdN8bWD3DD9ZkYYY0aD96yiBUJdcuYtUasEG63m03hnoBLR0u2WjYJMNkHSRW05FlY/JV2NQ3S3iFSV52CS+CO4ZzeIMvORBeo31b8aa84hJtiVN2WLKc/YwoM9YcRcfBrDvrbq88n67dgSaAxaUK/swYRJbW5ZsvYroZPM3D2KCUC4BpKdpWmT/cRypqc7h67LyBC5beAihAGWP9xuqlODCW0d5PkV8i3mQPRLRz0aPAwVnwahWq+Y8/sb6clPiXDQwPRGRy4ix/UzP6xJ7IMCU3JYhpaQuy/Qu1GTiRxphC5Fag8vp7ERp8MpnHN8WGXWjDBuEmdksqgOnot2tTFXKrizn5jHZWDAEXZiL1YwseMe72tYYIB79NS78xb1sJuiHFD4hgQyTb98/SnfNNSBFlun6PR35+n0t2K05Ib2LQrVuOQkx4xj6KNJGqJV2KxZut6k45URicsTrz6CXUE0Jgf6JgFuwSF8n4l4yBSL4toUKIgjUaK/YLdj8nxqFufmcJlly+zLWHsR7/yxbzRATAy9YPhy5oNiBIN6yovVnDJmLxvzDuMweKsj0ozUtuMwE/zvUlAwieHaGZ
 8vdEqA7V
 6yHgj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 3:59 PM, Alistair Popple wrote:
> Prior to commit aed877c2b425 ("device/dax: properly refcount device dax
> pages when mapping") ZONE_DEVICE pages were not fully reference counted
> when mapped into user page tables. Instead GUP would take a reference
> on the associated pgmap to ensure the results of pfn_to_page() remained
> valid.
> 
> This is no longer required and most of the code was removed by commit
> fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()").
> Finish cleaning this up by removing the dead calls to put_dev_pagemap()
> and the temporary context struct.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  mm/gup.c | 67 ++++++++++++++++++++++----------------------------------
>  1 file changed, 26 insertions(+), 41 deletions(-)
> 

Wow, nice culmination of a lot of work. So good to remove this
complication!

Maybe I'll post a quick follow-up, in fact, to remove page_mask
as well. No need to pass that around all over the place, I think
it can instead be computed by the single place that actually
consumes it.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard

> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..be5791a43c73 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -28,11 +28,6 @@
>  #include "internal.h"
>  #include "swap.h"
>  
> -struct follow_page_context {
> -	struct dev_pagemap *pgmap;
> -	unsigned int page_mask;
> -};
> -
>  static inline void sanity_check_pinned_pages(struct page **pages,
>  					     unsigned long npages)
>  {
> @@ -661,7 +656,7 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
>  
>  static struct page *follow_huge_pud(struct vm_area_struct *vma,
>  				    unsigned long addr, pud_t *pudp,
> -				    int flags, struct follow_page_context *ctx)
> +				    int flags, unsigned long *page_mask)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct page *page;
> @@ -688,7 +683,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
>  	if (ret)
>  		page = ERR_PTR(ret);
>  	else
> -		ctx->page_mask = HPAGE_PUD_NR - 1;
> +		*page_mask = HPAGE_PUD_NR - 1;
>  
>  	return page;
>  }
> @@ -714,7 +709,7 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
>  static struct page *follow_huge_pmd(struct vm_area_struct *vma,
>  				    unsigned long addr, pmd_t *pmd,
>  				    unsigned int flags,
> -				    struct follow_page_context *ctx)
> +				    unsigned long *page_mask)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pmd_t pmdval = *pmd;
> @@ -751,7 +746,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
>  #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
> -	ctx->page_mask = HPAGE_PMD_NR - 1;
> +	*page_mask = HPAGE_PMD_NR - 1;
>  
>  	return page;
>  }
> @@ -759,7 +754,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
>  #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
>  static struct page *follow_huge_pud(struct vm_area_struct *vma,
>  				    unsigned long addr, pud_t *pudp,
> -				    int flags, struct follow_page_context *ctx)
> +				    int flags, unsigned long *page_mask)
>  {
>  	return NULL;
>  }
> @@ -767,7 +762,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
>  static struct page *follow_huge_pmd(struct vm_area_struct *vma,
>  				    unsigned long addr, pmd_t *pmd,
>  				    unsigned int flags,
> -				    struct follow_page_context *ctx)
> +				    unsigned long *page_mask)
>  {
>  	return NULL;
>  }
> @@ -813,8 +808,7 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
>  }
>  
>  static struct page *follow_page_pte(struct vm_area_struct *vma,
> -		unsigned long address, pmd_t *pmd, unsigned int flags,
> -		struct dev_pagemap **pgmap)
> +		unsigned long address, pmd_t *pmd, unsigned int flags)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct folio *folio;
> @@ -912,7 +906,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  static struct page *follow_pmd_mask(struct vm_area_struct *vma,
>  				    unsigned long address, pud_t *pudp,
>  				    unsigned int flags,
> -				    struct follow_page_context *ctx)
> +				    unsigned long *page_mask)
>  {
>  	pmd_t *pmd, pmdval;
>  	spinlock_t *ptl;
> @@ -926,7 +920,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
>  	if (!pmd_present(pmdval))
>  		return no_page_table(vma, flags, address);
>  	if (likely(!pmd_leaf(pmdval)))
> -		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
> +		return follow_page_pte(vma, address, pmd, flags);
>  
>  	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
>  		return no_page_table(vma, flags, address);
> @@ -939,16 +933,16 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
>  	}
>  	if (unlikely(!pmd_leaf(pmdval))) {
>  		spin_unlock(ptl);
> -		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
> +		return follow_page_pte(vma, address, pmd, flags);
>  	}
>  	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
>  		spin_unlock(ptl);
>  		split_huge_pmd(vma, pmd, address);
>  		/* If pmd was left empty, stuff a page table in there quickly */
>  		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
> -			follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
> +			follow_page_pte(vma, address, pmd, flags);
>  	}
> -	page = follow_huge_pmd(vma, address, pmd, flags, ctx);
> +	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
>  	spin_unlock(ptl);
>  	return page;
>  }
> @@ -956,7 +950,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
>  static struct page *follow_pud_mask(struct vm_area_struct *vma,
>  				    unsigned long address, p4d_t *p4dp,
>  				    unsigned int flags,
> -				    struct follow_page_context *ctx)
> +				    unsigned long *page_mask)
>  {
>  	pud_t *pudp, pud;
>  	spinlock_t *ptl;
> @@ -969,7 +963,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
>  		return no_page_table(vma, flags, address);
>  	if (pud_leaf(pud)) {
>  		ptl = pud_lock(mm, pudp);
> -		page = follow_huge_pud(vma, address, pudp, flags, ctx);
> +		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
>  		spin_unlock(ptl);
>  		if (page)
>  			return page;
> @@ -978,13 +972,13 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
>  	if (unlikely(pud_bad(pud)))
>  		return no_page_table(vma, flags, address);
>  
> -	return follow_pmd_mask(vma, address, pudp, flags, ctx);
> +	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
>  }
>  
>  static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>  				    unsigned long address, pgd_t *pgdp,
>  				    unsigned int flags,
> -				    struct follow_page_context *ctx)
> +				    unsigned long *page_mask)
>  {
>  	p4d_t *p4dp, p4d;
>  
> @@ -995,7 +989,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>  	if (!p4d_present(p4d) || p4d_bad(p4d))
>  		return no_page_table(vma, flags, address);
>  
> -	return follow_pud_mask(vma, address, p4dp, flags, ctx);
> +	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
>  }
>  
>  /**
> @@ -1003,20 +997,16 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>   * @vma: vm_area_struct mapping @address
>   * @address: virtual address to look up
>   * @flags: flags modifying lookup behaviour
> - * @ctx: contains dev_pagemap for %ZONE_DEVICE memory pinning and a
> - *       pointer to output page_mask
> + * @page_mask: a pointer to output page_mask
>   *
>   * @flags can have FOLL_ flags set, defined in <linux/mm.h>
>   *
> - * When getting pages from ZONE_DEVICE memory, the @ctx->pgmap caches
> - * the device's dev_pagemap metadata to avoid repeating expensive lookups.
> - *
>   * When getting an anonymous page and the caller has to trigger unsharing
>   * of a shared anonymous page first, -EMLINK is returned. The caller should
>   * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
>   * relevant with FOLL_PIN and !FOLL_WRITE.
>   *
> - * On output, the @ctx->page_mask is set according to the size of the page.
> + * On output, @page_mask is set according to the size of the page.
>   *
>   * Return: the mapped (struct page *), %NULL if no mapping exists, or
>   * an error pointer if there is a mapping to something not represented
> @@ -1024,7 +1014,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>   */
>  static struct page *follow_page_mask(struct vm_area_struct *vma,
>  			      unsigned long address, unsigned int flags,
> -			      struct follow_page_context *ctx)
> +			      unsigned long *page_mask)
>  {
>  	pgd_t *pgd;
>  	struct mm_struct *mm = vma->vm_mm;
> @@ -1032,13 +1022,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
>  
>  	vma_pgtable_walk_begin(vma);
>  
> -	ctx->page_mask = 0;
> +	*page_mask = 0;
>  	pgd = pgd_offset(mm, address);
>  
>  	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
>  		page = no_page_table(vma, flags, address);
>  	else
> -		page = follow_p4d_mask(vma, address, pgd, flags, ctx);
> +		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
>  
>  	vma_pgtable_walk_end(vma);
>  
> @@ -1376,7 +1366,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  {
>  	long ret = 0, i = 0;
>  	struct vm_area_struct *vma = NULL;
> -	struct follow_page_context ctx = { NULL };
> +	unsigned long page_mask = 0;
>  
>  	if (!nr_pages)
>  		return 0;
> @@ -1418,7 +1408,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  						pages ? &page : NULL);
>  				if (ret)
>  					goto out;
> -				ctx.page_mask = 0;
> +				page_mask = 0;
>  				goto next_page;
>  			}
>  
> @@ -1441,7 +1431,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  		}
>  		cond_resched();
>  
> -		page = follow_page_mask(vma, start, gup_flags, &ctx);
> +		page = follow_page_mask(vma, start, gup_flags, &page_mask);
>  		if (!page || PTR_ERR(page) == -EMLINK) {
>  			ret = faultin_page(vma, start, gup_flags,
>  					   PTR_ERR(page) == -EMLINK, locked);
> @@ -1474,7 +1464,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  			goto out;
>  		}
>  next_page:
> -		page_increm = 1 + (~(start >> PAGE_SHIFT) & ctx.page_mask);
> +		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
>  		if (page_increm > nr_pages)
>  			page_increm = nr_pages;
>  
> @@ -1524,8 +1514,6 @@ static long __get_user_pages(struct mm_struct *mm,
>  		nr_pages -= page_increm;
>  	} while (nr_pages);
>  out:
> -	if (ctx.pgmap)
> -		put_dev_pagemap(ctx.pgmap);
>  	return i ? i : ret;
>  }
>  
> @@ -2853,7 +2841,6 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		unsigned long end, unsigned int flags, struct page **pages,
>  		int *nr)
>  {
> -	struct dev_pagemap *pgmap = NULL;
>  	int ret = 0;
>  	pte_t *ptep, *ptem;
>  
> @@ -2926,8 +2913,6 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  	ret = 1;
>  
>  pte_unmap:
> -	if (pgmap)
> -		put_dev_pagemap(pgmap);
>  	pte_unmap(ptem);
>  	return ret;
>  }



