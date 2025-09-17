Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE80CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E03D8E0002; Tue, 16 Sep 2025 23:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290F08E0001; Tue, 16 Sep 2025 23:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130EF8E0002; Tue, 16 Sep 2025 23:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4408E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:21:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9805C13AC5B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:21:04 +0000 (UTC)
X-FDA: 83897290848.19.C2C745C
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010030.outbound.protection.outlook.com [40.93.198.30])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2EDFC0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:21:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WRVUfNBX;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758079261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwCsTvqgCNM9qgcrjQ3QpR/kZrfenU2IUrVEuCcgctQ=;
	b=tOWDDAvmLoFL62A3C909ypPx9Cy3sRBKRV2I9zeWdPnDp9OVp1Yhfva9gZJTs9UOwJjKyC
	/0jEE0ai2SKZcXBFfIDt1JErKedQtO5I86G9cpHmzzkTuCTjiNj8SBf6o/Ri9VFXjE5CgA
	xKk6XDBpBCAgAYaNPad0UuujDZ0rPJo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758079261; a=rsa-sha256;
	cv=pass;
	b=SemI+t392bK1HeyFWEUYaj1mTsLVv2Qcc8TBnPCrlSPXmPOfJFj8ZAhBjdMutiaAuhpkns
	qm2VkKfQHKZhK4k4EnX9hd3t1LjIN68Gh/GuX6C/jpEcyhaKec7tVYVKLD/jcU4eIoTito
	fnuEgJgSN0NQVLZUVYmZKqZbbfKYYl4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WRVUfNBX;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.30 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEAQY1JwtLGvU+ZVUA7i577XLOWiAVUvGDQ+6pY5BZURlTOqbqORCfIl1xC3dw5ESHA0NjLPKLhgtvDAYIfqTsAX91kCscsmHWO3TAtVlzvPg298BjwuYP3gnEIFInplH0UyW1fStsf3K3Zbkw3Wwt/UKOFRcLcZL7X5dIcqGv5Hx/gUoxEYvEjlgpiTIeiox6GrqFQKausn0BFNyyCKXttjAksMeyNVDQKlq+N9KLtDCHlOBJzvqQSdkPRyyAlGv2mZJXa4oO9gDA1DpU6U7BfSyErRLdafveLwpq7FqDoUdttRmvAYEUALMox/YVX2uFH0G9Bj+1cYqzE1/t7rEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwCsTvqgCNM9qgcrjQ3QpR/kZrfenU2IUrVEuCcgctQ=;
 b=sr8/DTkIJrEv947EnzBmfZcAETQmVN9wIBMvgsRlkyuWZh64ja+hkjYSI5caBY2cGKLQeFjL0a7e5udChW6E+QmxlJbB8+dg/nW1NKpEDuATZMrNTxm61QxTmjQO8NeIjJyvpWHSZUA1qxO3VZ5ArKEuOvt4eAo/uj9JQfy32xAV7KQE44+zbiTUyZrLEXsvNYn0RwA0ar/rfOUvMflT9A3cy9p5wgKWh9XOs3qlWOtWZxuaDlmAXbMdkMKZu46JILyxDwxOI5CVe/oJguwvxeYMn7po/6d/lBT6wSc7SjCouvWigr7UhHJmdBAQZ3guwa6h+xlcmyUsNQ4bb6rINA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwCsTvqgCNM9qgcrjQ3QpR/kZrfenU2IUrVEuCcgctQ=;
 b=WRVUfNBX0K81LhWeWZqOewRKmE53em042bH/jQvckn92IkzRJmT2NDJr5vKrAzw9iUyw8Q84kSYHUeMXdxCPlwSPYHyMPYB6EBaF8GzErgS1SL9cfLQN7i4gqzyK9DF03IZqSmoGdFpU02YeQ4IC3FEsOG4qQ5DVTowDxfLGYZVTfyCTHIiqT6UlmvpcihU1Q1XQwMuyIcFen174a+sZSsNQo68NDDxIeK2wGufQKxd3qd4calnhgvNbU6BkEKhgjqPNCZMvjbbxxhW7S89jDlQyoNhw4Eaizs6Mkf+SO+Gg9einPtO42hbOzqcAushSp8UJc6iQb5osz9KxU88HFw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by IA0PR12MB7627.namprd12.prod.outlook.com (2603:10b6:208:437::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 17 Sep
 2025 03:20:57 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Wed, 17 Sep 2025
 03:20:57 +0000
Message-ID: <71ac5779-d535-4b0f-bf8d-7a60bf6a6ecf@nvidia.com>
Date: Wed, 17 Sep 2025 13:20:49 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
To: Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
 Bharata B Rao <bharata@amd.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Jonathan.Cameron@huawei.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
 raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
 nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
 kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
 alok.rathore@samsung.com
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0140.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::25) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|IA0PR12MB7627:EE_
X-MS-Office365-Filtering-Correlation-Id: 237f59e9-74f4-410e-0058-08ddf59937b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z20vdDI2QUhFMzBUOHh1Tzh2dUV6R0lxeHBzWlRTUXlOUCtCK09NZE9tQVVH?=
 =?utf-8?B?VjI0c0Q3UFY2UWhKcjk3MGRHM0xQd0lVOHZ0SXhMTndtcWxtVmJyK2tRWnZ5?=
 =?utf-8?B?UnV3djhIb1BFak1yN1E4WXJOaFhnQlo1MFhkOXdHRDRyc2Nsc2lUU2swRDRH?=
 =?utf-8?B?ZmR4SEFlRHFIc1I3S3E5djFBVHBiaUpTQkxBY2ZWaU1yb1Q1VmZuczdUSFF0?=
 =?utf-8?B?NU5qMFRNNjh5ekFXdHNqekZ1T0dvZ0RJbWFUQnVKejJSS1RBdG5VYlZLR3RK?=
 =?utf-8?B?YWZETkxwVnEyRm5hSjVBdENqV0NHM2V4ckxtTUVTNmQ3ZlB6dEF6bUlYTzhG?=
 =?utf-8?B?VzRJMVRmS000TGZkajdWTVpNUHYyY0EvbW5IU2tneHNvSjBVT0pYNDRvU2ZZ?=
 =?utf-8?B?WEVsdzhlaXd5ckdlc0ZVQnVMUnIzTVhKcEZqeXNDK0ViV09ZaHJEV0UrQWxZ?=
 =?utf-8?B?QXlZaGlLejk0S3l5R0VRQVQvOUpjSzgybUNtMVU5bWNVK080d0J5cXdxOURU?=
 =?utf-8?B?eGpDWi9hRitQU0kreGp6aUVMV1QyNXEzOWdFeGJnNTQwSExkZEY1UkZxZEVs?=
 =?utf-8?B?VmErS0M4SXR1U3M2RVZsYjlrcUlYWUlkc2E4eE5TM3JERXBtU21SdTQybVMz?=
 =?utf-8?B?L1BOZHJWazh1R0dJYnUrNy9OWVRNeWpqemg1ZWR2ZnoxMEJiejQ4ZzBibU4x?=
 =?utf-8?B?SXhtbFhTYVR2cG9zL2VDaTNiaFM3cnY2R3VUdnFmdm8wSzIzdXgrUlRYcU5x?=
 =?utf-8?B?elF6TVFHNSsrU1J5YWNrRVliMXZnbVp6enpJRVBkeHdrOXBoQnlkM1ZNeWk2?=
 =?utf-8?B?M2xVck91RG5XOXk3R2kreDllSk1PaVFUa0JuNEYzMVZ4dThVSmxtSmhFRTRS?=
 =?utf-8?B?WG9leHRDQ0l0dGxZN1NaK3BSMDcrbml0NXdSTlJkblRxNCtpUGxDeCsyNjZt?=
 =?utf-8?B?b3ZLdncrZmVRTXZQL2l3amZFMWJ1aW1IMWVEVEwxb3BWSHYxNmtkNmdneWFn?=
 =?utf-8?B?bTBsZzRrMnA1VXRPeHp5cHVCb2t3aXVsU3o3L05UaDJkdURudHlaYm0vTlF6?=
 =?utf-8?B?NE55eFhnUjRKcFlwZWh0TXFYdGRRUjkyOXdEc2dsbjRxYTErOEk0Z1ZFSGpu?=
 =?utf-8?B?NXZSQk5ERlpzN3R1a0FSUm9Gb1lVWTE2ME9LUjBucEppdFIwRHpQTzlJdU1n?=
 =?utf-8?B?b1BBd0hNd2Y4OUpudVZhaklZQWtGampFUTZFbFFDaEFGMHVrdlFNWjJYVkdN?=
 =?utf-8?B?dUNMVENhaFNmUjNQS1ZEamNnLzRvVUVLaTNiUG9SWGlVT3Y4a3N2WUJReDkw?=
 =?utf-8?B?dHZqV3lBT1pCVTExck51SGdBZk9FS1lIOXBES0NzUTl3WUlpQmdwaU9qdm1k?=
 =?utf-8?B?UE9wZVc1UmgxbmFrZ2pzcEJXSHRVVUdlOFdwUjN4elVhbXhjQUx5RmZHdm5a?=
 =?utf-8?B?bGc5ZGRhMUNwWUlZc2FQVGpGY2dGR1k1UU1xWDNIMkpCNm44Szg3S3RmUnk2?=
 =?utf-8?B?Q1ZWUURpN2FhdDRHbVF6T3V3NGxEMUlwN1JFblhJZ0lNYTl6bFRZcmN0UzRQ?=
 =?utf-8?B?T3B3N3FJMWlpbnhrR1h3Vmo0cnJyTlo4WUNnUlZvanRFS1Q2SlRqQjZWL1Jl?=
 =?utf-8?B?a0djRDhxOWZjS1VydFo3STYrQmxQNm5JUk5USnF6MkdnVXIrRnBFNmxMd05X?=
 =?utf-8?B?SWZSdlB0WDRuZHhXMTNtVERPOHcxU0J0UGkzNzR6WCt1WmVTVVh3clNoT3RE?=
 =?utf-8?B?TURtNlNHdi80S010Y21QWFZXZzJaZ2hQOVpmYXl5RGd2NkJad3lmTVNrYlJx?=
 =?utf-8?B?dEFicFhvRmFLcHQ5LzRSbjgwRUsxZnplL3oxL1dweVZTQ2tGd3FLUll4eFp4?=
 =?utf-8?B?YkpMZTUwZ0xmNlBTNnR6VFd0SEtydUUzTUk2YnQvZ1haV1VJK3paVjJYU0ZP?=
 =?utf-8?Q?asSVtBKCEMk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHNqam1wNEsva2ZOZi82MU50T1lXSFRRb0NIU0JDSzVWS1hDaVFSYjhIQkpn?=
 =?utf-8?B?MnBhQUFHZTFCNzhGYml0NUlXN0dVQTY5cGFvc2EraTAxd2FUS1lFSytBY2l6?=
 =?utf-8?B?QlFNaDRFcHVTRzVxU2cydmZFUllpM2Y0NWdFb2dWSTcvTTI0a0ZEc1JUdUZ3?=
 =?utf-8?B?TXgxazVCOFBBdjFuS0NhVFN5RzFpajBjTkdKSDNVQ3pEWURHY3FFUGFPYjJv?=
 =?utf-8?B?SEtYcExrU2tlNXN6aFJ0ZUNlbXMrRGt5N1BkS3ZSV1prY3l3bExrc3c5ZmVY?=
 =?utf-8?B?WkFiYUk0QkZ4R3dSY092UHpUb1NBYi9Da1hIaGE4UTVLMGJSS0hoQUNMYUhH?=
 =?utf-8?B?ekN6K0NTSGsvT3RRSGQyVnlRZ01BSzg4cSs3RmZBbWhOZU81SDVvNFc2QjR0?=
 =?utf-8?B?MHBLOXlGYXRreTcyNS90RndrZ3AwOFp5M21FR2pZc2kxaW5MYytHN3dad3Fh?=
 =?utf-8?B?ZlBqZ2QwRnhkZGZsYUJiK3BsNTA3NlJyWm93YlBpQXhwQmhCbmFFY1huYzdH?=
 =?utf-8?B?aEcrSGtqK3R0blFuSlMzVUlnMjhvQTdJUHVOODBFWVlVZ3hLbGVqcmVjdVNV?=
 =?utf-8?B?L1JNR3kzbXllSi8rZzZWZVZ4Zm85QitwMHJ6d0MxUHVnM3NSSTVpNzJjbzcy?=
 =?utf-8?B?Q3ZiVjdUc1JXTGwrU3c1S2RRY2pjVER6NTNjZGI5SkcxYkpRb1AvK1pqMGlY?=
 =?utf-8?B?amxhWFpVcENBMzdFVlk0ODVqSVk0WnUxUzlUT1JRTkc5dlVoOWFNcjdFdWhw?=
 =?utf-8?B?dTZESTJ1dWZUejUyL2JBTlRWTlE0SFBJM1FzQTBHZHAzMGNwTVIwZEl2Wjla?=
 =?utf-8?B?T1Q4ejF5MUQwNGZrSmxZL2hPanVxQlI4R09JbHdEVldPZXd4Ui9KZDRpTlk2?=
 =?utf-8?B?RllMMDZRVjhGb0RvRVI5K3FTTE9nbFZBek43RUQ3bjUyY2N6YzFXZXJKS1lG?=
 =?utf-8?B?SThMdjdSOW8vV1IxMjh6eXJ1emZwSTQ2TUhla1BodDBVTk1vcWVEVkxKR0Yy?=
 =?utf-8?B?d0xTUWt1UGsrRXVuVzlUeG1BcW93cjhWWE5HblVGeEl4bkl1bzBkTlVLdUdS?=
 =?utf-8?B?ejFQanRZYUVTNC9JUGRzQWVXUW1XZUhWSVhuYnMySlEva0MveUw0NE9SL0lN?=
 =?utf-8?B?UHM4UGdQOHdEWDBMYUpRdWlycmREMkNaK3BIZjQycm1TdDJRRTVKSlM2Q0hY?=
 =?utf-8?B?R0pjeXgyR2lJWHJCR1RQdzBKMlZRTStHZVRGTGJGK3B4TWowamdObUcxaU9F?=
 =?utf-8?B?Y0RkYlk3bk8zaEpYMXFTYlQ4ZXJVR1ZQUFhnRXk4bjFJU0R1RUlMM1JQNFNW?=
 =?utf-8?B?Q3EvR2QyYnM4WXFUQ05CQy9VREkweHQ0L3ZKSFBxM3VWMFZZdW83N2trZHM3?=
 =?utf-8?B?c05mVk93YkJLb0dsd2ZEc3I2YlA1TGtDZXRKSTI2Q1A5YXJMRTdud1pHSlBk?=
 =?utf-8?B?UnhtQjlVd3Q0aXVFTy8xSExPNEhmdUt5ZkxHWXVvZkVKTnhXNDd3My8rZmJR?=
 =?utf-8?B?MFE0V2lWaUtUeHVIaVRFN2piWnlRYjE1T0hrMkI5WGQyMWRQUklGaW9vbldB?=
 =?utf-8?B?RVpkaERkcmxDenR2ak10NHJPRlNlS3JOZTFPNG8vRXBUaXlJb1VtK01sZjF1?=
 =?utf-8?B?ZGNGa1RKeGcxTkxtcU94NWZqVUszSlFldi8yNnZEUzBWVW5XZ2tIeGFXRlZO?=
 =?utf-8?B?TDVCekdQNjFGeTBUUEJlZ094RW92SHdBb1ZuUWtUZU5ETlc5QkVUUmdEMUJw?=
 =?utf-8?B?MmZEa1lhK1JITGh6Ty9LVEkweVJvcFR5V3BTZTNzelJpcG5CbzU2Y1NNVkxE?=
 =?utf-8?B?dW5TNzc5M2k4UzZNZzFOUVY2OU9BNjFyVDZlNTRZTExBK3hvTS9rYi91ZjFX?=
 =?utf-8?B?alFrbjZ6SHJta0tTejRsS3F6UXZoNTVObFVaeGUrbWZBOWdNWlZoc3VjbGZp?=
 =?utf-8?B?K094S2M1bnFVZlhoTkRMR0VZZWhvR1BIdnZFYzIrNFpFYlZIQVRwckVuZ2tS?=
 =?utf-8?B?TEhJdzRYWEY3azBKZ2pYR1ZlRHc4SjFWWVVHcCt3bklDeUlyVVBHbWhKREtX?=
 =?utf-8?B?Z1ovc2Y5TndXcytaTVJqYzRpVlJwUUZvc3IydURrbjBFNzRxck0wQTJ0MGZE?=
 =?utf-8?B?ekErYzVBNnp5VStTdEJrZDRNMEZ1ZXNMbnJkVlNTQ3g5cW1IbE1SbXhYaDNZ?=
 =?utf-8?Q?X4N4IMgfk0EZZ6PUYY/rZ4Cfm5pm/oCnltX9qGfbf4w1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237f59e9-74f4-410e-0058-08ddf59937b2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 03:20:57.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MowUSxVVptBmYq6lrfVUnMJ2xkLCgpw91+b2LwzabuYqjhRp2hYWNyMrI0z6HFsXvl0yREqPRPOF8Z7tsdadKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7627
X-Stat-Signature: g6ar5peahigrk3fj9tc8du9p1ozm3uij
X-Rspam-User: 
X-Rspamd-Queue-Id: D2EDFC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1758079260-569302
X-HE-Meta: U2FsdGVkX19BjlCT+39ZBaZcmvX9FwAJwUOOc/9AMyvDvssxuYfNIQv8Dv5pVhqXxuggEVt6OfmnDk/ziVil1REvXTLbh90s5fNZ68yGeqzlI9e59pd44g+ySx2+HvL+n5Wqi/cMK2VUIKpwhvBuVCR+t4EzG5uN1Vy3HwuYuFA6+sGtcgj8Q72QYPiyqWn3/ATXq8pHi3u9/BZzd+S8XwiEjgryUuioM5Wrw8pMn+whtG7Tbs6JRtGSt1Oiu2hPsq75iZri9sUSD6zRq6PhkGMtI2+cyL+Kv6sTqGCa1CUGYAht3gS2IafIycgylYlC+PBn68H0WZ4B0XFzGTiv3V4dwzMpvy9RcyBP8RTAEdRz0PSEOEH1l0KfN9kmCSHv/BEhqy/XULh93TbJeYpVDB2cDtZCrUvVaWmu55MyYBpiS7KHE/UoQMEA3pQeR3uhvbjGuUvpLcnFj6kWt9dxP8Sjy6lgq2yOvGmjJgPrk3B8KCU2hqpKSl8ZIVGnHr7cMvwMJZAdkx7RLNYi5zwR6v4MhE2u9rhnHB7g9ZRBHKc5cSKY5SblcMWuIKAqUMm981cmONLLAYSuAN91kc+NhhqXpJfHULZORiUXqUjhFhXJ+Z0Ojrq8n4O5MCT1n8N+rb7ugIiSDTHXfbPljSTsEYR0y+f7h9iYPaKIbZ4OKO8t8IY2nMaANRrq/q95AOgu3kNQc1ZTNqtYpd6wVg6zfh7JuAVvPdf3IY0eID+5NMbX8CayMnADXhJ3hfSneq6I8FHyeeEXzw6ZXW+moX7cEV1vxi38mTveCNogoGzZvhHUS9EtWt50s6ujCeassdwBnoXHWhfn3ge/Um5P0T3AVbJJUkVvLXWwdiWNcOhKC2nS9FxtgmPmK7XQwbZRh6jpf9iJ+qWtsnvg+XiuYKv7zvRwu3yD8BrvYf571ouFh45JtqV5hi6pFlIbvrGo7CibD/EiuwMIoTIjk4HF5cg
 8nuQsPYK
 zJ50NRokr5DVhl4qoJsjqOKGEUadrJy97+hnXTxp2Ew7Lyc77W9nj6uHHrDROBwhuFf724dkQCNsPY0Uh5fVQcnKw8HXi2Gys0jZnZrnYEF8lo/3PA6gF1enwV8zSSLe/S8wr8LAuyusE01oxxCmnMNT60OSy0Irl6JjvIjsGPx2jAgMuLGjATN3Sh4XCERe6NUyUYnxKWjj8St3LVUT0QWGf+7vwois08g5h50BbL/OFvdY3FPpGRNvbCyJwP5qV+c2adTlT4rHIZW9so5paQ53hNL3gv2rcnw/Nm89zo75/JZ3GpTfd0/22tL6WteBPjTLsLjRNkZtiM1iO49LfXWy+2/hF61IddZo/AyPrRySuHwwfeYxXlhUZLmAn2BpnikWNzf1H10bI1PVV81ksaNHLMiHiPx0vYc6ZN8vNy3y55i8P2HOZUUb+Z3jDR0MexK9t+PJ72ukU+i78an193Fq42TG4ZbhUQ+XtZLEeY3wmbzvLTFrhqIS85J5qzgRamHEy8U1UZ+enqFkws+BbSLs7uTqPtBtH1mEcCV1ICjbtu214s/xBMpDyDPS4+y+7utoqqBfzbzaiBoYTkzKcvjoP8cmx91bL0UEMKn56BfW8h1Cwwyh35l4tJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 10:30, Wei Xu wrote:
> On Tue, Sep 16, 2025 at 12:45 PM David Rientjes <rientjes@google.com> wrote:
>>
>> On Wed, 10 Sep 2025, Gregory Price wrote:
>>
>>> On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote:
>>>> On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:
>>>>> This patchset introduces a new subsystem for hot page tracking
>>>>> and promotion (pghot) that consolidates memory access information
>>>>> from various sources and enables centralized promotion of hot
>>>>> pages across memory tiers.
>>>>
>>>> Just to be clear, I continue to believe this is a terrible idea and we
>>>> should not do this.  If systems will be built with CXL (and given the
>>>> horrendous performance, I cannot see why they would be), the kernel
>>>> should not be migrating memory around like this.
>>>
>>> I've been considered this problem from the opposite approach since LSFMM.
>>>
>>> Rather than decide how to move stuff around, what if instead we just
>>> decide not to ever put certain classes of memory on CXL.  Right now, so
>>> long as CXL is in the page allocator, it's the wild west - any page can
>>> end up anywhere.
>>>
>>> I have enough data now from ZONE_MOVABLE-only CXL deployments on real
>>> workloads to show local CXL expansion is valuable and performant enough
>>> to be worth deploying - but the key piece for me is that ZONE_MOVABLE
>>> disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of
>>> CXL, but allows any given user-driven page allocation (including page
>>> cache, file, and anon mappings) to land there.
>>>
>>
>> This is similar to our use case, although the direct allocation can be
>> controlled by cpusets or mempolicies as needed depending on the memory
>> access latency required for the workload; nothing new there, though, it's
>> the same argument as NUMA in general and the abstraction of these far
>> memory nodes as separate NUMA nodes makes this very straightforward.
>>
>>> I'm hoping to share some of this data in the coming months.
>>>
>>> I've yet to see any strong indication that a complex hotness/movement
>>> system is warranted (yet) - but that may simply be because we have
>>> local cards with no switching involved. So far LRU-based promotion and
>>> demotion has been sufficient.
>>>
>>
>> To me, this is a key point.  As we've discussed in meetings, we're in the
>> early days here.  The CHMU does provide a lot of flexibility, both to
>> create very good and very bad hotness trackers.  But I think the key point
>> is that we have multiple sources of hotness information depending on the
>> platform and some of these sources only make sense for the kernel (or a
>> BPF offload) to maintain as the source of truth.  Some of these sources
>> will be clear-on-read so only one entity would be possible to have as the
>> source of truth of page hotness.
>>
>> I've been pretty focused on the promotion story here rather than demotion
>> because of how responsive it needs to be.  Harvesting the page table
>> accessed bits or waiting on a sliding window through NUMA Balancing (even
>> NUMAB=2) is not as responsive as needed for very fast promotion to top
>> tier memory, hence things like the CHMU (or PEBS or IBS etc).
>>
>> A few things that I think we need to discuss and align on:
>>
>>  - the kernel as the source of truth for all memory hotness information,
>>    which can then be abstracted and used for multiple downstream purposes,
>>    memory tiering only being one of them
>>
>>  - the long-term plan for NUMAB=2 and memory tiering support in the kernel
>>    in general, are we planning on supporting this through NUMA hint faults
>>    forever despite their drawbacks (too slow, too much overhead for KVM)
>>
>>  - the role of the kernel vs userspace in driving the memory migration;
>>    lots of discussion on hardware assists that can be leveraged for memory
>>    migration but today the balancing is driven in process context.  The
>>    kthread as the driver of migration is yet to be a sold argument, but
>>    are where a number of companies are currently looking
>>
>> There's also some feature support that is possible with these CXL memory
>> expansion devices that have started to pop up in labs that can also
>> drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able to
>> chime in as well.
>>
>> This topic seems due for an alignment session as well, so will look to get
>> that scheduled in the coming weeks if people are up for it.
> 
> Our experience is that workloads in hyper-scalar data centers such as
> Google often have significant cold memory. Offloading this to CXL memory
> devices, backed by cheaper, lower-performance media (e.g. DRAM with
> hardware compression), can be a practical approach to reduce overall
> TCO. Page promotion and demotion are then critical for such a tiered
> memory system.
> 
> A kernel thread to drive hot page collection and promotion seems
> logical, especially since hot page data from new sources (e.g. CHMU)
> are collected outside the process execution context and in the form of
> physical addresses.
> 
> I do agree that we need to balance the complexity and benefits of any
> new data structures for hotness tracking.


I think there is a mismatch in the tiering structure and
the patches. If you see the example in memory tiering

/*
 * ...
 * Example 3:
 *
 * Node 0 is CPU + DRAM nodes, Node 1 is HBM node, node 2 is PMEM node.
 *
 * node distances:
 * node   0    1    2
 *    0  10   20   30
 *    1  20   10   40
 *    2  30   40   10
 *
 * memory_tiers0 = 1
 * memory_tiers1 = 0
 * memory_tiers2 = 2
 *..
 */

The topmost tier need not be DRAM, patch 3 states

"
[..]
 * kpromoted is a kernel thread that runs on each toptier node and
 * promotes pages from max_heap.
"

Also, there is no data in the cover letter to indicate what workloads benefit from
migration to top-tier and by how much?


Balbir


