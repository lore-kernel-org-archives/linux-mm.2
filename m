Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1B4FE5202
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34436B008C; Fri, 24 Apr 2026 07:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B5A6B0092; Fri, 24 Apr 2026 07:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA926B0093; Fri, 24 Apr 2026 07:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A246B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:27:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 321AA1B89C5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:27:12 +0000 (UTC)
X-FDA: 84693223104.18.F9F34E1
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012043.outbound.protection.outlook.com [52.101.53.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 590071C000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:27:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5EU5WC5Z;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777030029; a=rsa-sha256;
	cv=pass;
	b=v745IMZEL238wJk0Wn1STgN7VhAIXCWutHd9prBi4Hmh/I0fDNRW3z8PZxB43LnllvgNWP
	SCVq9OvLK9BvljSPs6sgTYGKiOkTKlUjZou/LlV72Vf78XzcXKxXjLKLJ+Mf5domeD7O14
	yrxfqZwhj0489GlrwUOP+U/YqX5yFWM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5EU5WC5Z;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34FaDdsrzqZyIaHZtybk0XZJ6PE5UsZMbkA5Hhsn1yM=;
	b=KimhRZl7rBOpSp1eB70wOuZ6AoWX50vMTJly9P+/NQHneRCPlGOvtGoZ0x5EI81h81VvTt
	mBRLfWVRT7Id0V5UgN2KNsv2R/kU6NE0IM+nk4ui91oE/6BJJh/wq39RHfkH5e5eu8Flgd
	b3Hn9hAlJyD+PN8z/1H9RJX/TYbxuiM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hoozV8/jwqOBN5hCfLDDD8wCP+DFOCdkt04Doo8Y/PrgNjBHMTPgk7yCk17Iksj5BNwBhF7TeTxMQoLcdofm4gqyI3KGpKDUY/hgzbofYqk13/l0kT6huCyDIf53UcPobyYrFkVzB7HhHVj2HXYSfwbYnCAG8JzakZlpBkhCC4PKaa+WxZgTT1eHgQ0nC8Z7pqNkBLQBR56KI2XgxqbZtwDBPrE4wpu/prmibbsdQh0SrlFlDf3mTlrVSmsv7lBkdsLzVQT0oAnGCvNA4S+K6MJWlZKegvzNt4CTSDNWbcNjefqTtz8oHVjrthdtkBfMxOByuim2qD8njQQC5RjUCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34FaDdsrzqZyIaHZtybk0XZJ6PE5UsZMbkA5Hhsn1yM=;
 b=uK4wxjNb4kYRuk4aXTNHrqSk07eCn6Zs7Vx/Umy4VH5PmkY72mRvg8sRBkL5co+WNi9mGUs94NrSWAAJzUmMb/Go9LRnVwabjx0TWqGdyGcIa3CSMRWeeNv1zGJa5s3HlG/LaHLqdZ9Sy1MkLYevcJ5bnhn5eu35qN0xcy/LTfTqKpHmoj9EZF6TsIzmaJKrf9Dkt5VaeY06OyBj3LA/52/fvNJjovr8TPuKqephi3z8oAeNygSJRm5eeL0upLdjikceGAGuAjLjcmdR4CuZc9/NfFI+Wf5+KjJJOJ//WlTfjzZMgXeSnu/toycgn7z28KAaZfmPLA6p9mTctQhWBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34FaDdsrzqZyIaHZtybk0XZJ6PE5UsZMbkA5Hhsn1yM=;
 b=5EU5WC5Zb+F+v8sPkcTmybWDDm76KZoPKrr0454WqxZ0WLT+v/qYy/76Ky8qMRUHmiCHadbiH6ALeGnvIH+0n+YjPUXWq4nEA6YPR0+1Nmzk9Hgnz9tMMKA4ADyAhQiG3V5qAHIr73op8/msg4Ed0bxq4Zd5nCkB089JDkafGjo=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MN0PR12MB6199.namprd12.prod.outlook.com (2603:10b6:208:3c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Fri, 24 Apr
 2026 11:27:04 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 11:27:04 +0000
Message-ID: <3e73addb-ac01-4a05-bc75-c6c1c56072df@amd.com>
Date: Fri, 24 Apr 2026 16:56:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
To: Vinod Koul <vkoul@kernel.org>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, bharata@amd.com,
 sj@kernel.org, weixugc@google.com, dan.j.williams@intel.com,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
 david@kernel.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-14-shivankg@amd.com>
 <396b4be1-376b-4aac-bd1e-2854c88b3757@amd.com> <aeopIn_sCBR2CFrI@vaman>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aeopIn_sCBR2CFrI@vaman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYPR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25d::16) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|MN0PR12MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd585e5-ccaf-46bd-4bcb-08dea1f4694f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	C3MaWfOgAk6TDKZn6TrZZ9hwF18oB48hTCVrQxXi+6v/O8mRoBFq8EIAyGTGVc8pkLMdUfrIZ5A5rIb1NknB5lR6CanB68bTYTAnEhHGJPIoHHC9nZ9NMgL5NbH7T3hsg3b0JE6zKG1e7s3n6B+SLDWDdkydVNYQIhH7ccDhJVF9Pna7735ktugs5FJMf5PlnjirDnMG+GKKRcpcg32ToUlNmIAtI75w6hF7YymlC6NtuHfMjh9eBfiW582NViixkw4xzKZaemZHIo4xmFYb4pNobTRdcRPXsF7rGl+eTA5vajDCqc+CeyafKh6I9pTsSVf7c73jf1pm8S3ihOqtNM/dCGeVa5dOk2JdHgZWwMr8SpIiTgzQ1QtyShXKRYJDmFhXiYBxEOERpcjo0MwIrozhErBuIXMrklJSdcyY/ej75vLmZy32JUp1cZixFBLjtQWZTfWcJPk4K277Jg0QvxkNgUNyYj559akJlYC61mwGAkqotvelskaADcmn2cj6mbyBm3pCag0s0f6iidMDT8ct78v5VOMDrR3S8CxNsM4cXABA0BrnPBZSfff4QvUDXAy/d0V2gmI+LAw2qVzUhLD/ZDWE2Ahd7+pJEIvNgJ9Q3hjAEuwFHEiQ5zEKdZGnk1MMNesVxU3zjZMRKUJl+svTeXJfOqKEX5rax5IjwBhZcRKX35qNTyaFxuuDVgk32I62n9uNyDO61jn0KT3UmsDZwAb/NG1BSAu7WvI9tsI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3dUZUJ5akZwSmJNRlFiN01zRDVBTlVCTm9KcUlYNEVjSFRySU83elBydHJW?=
 =?utf-8?B?ZzNLVXUzQkQ0cStQVDJaczRpdVgvMFU5RkZXYW9Xa2UzTGwrMVF4RnBmMW1U?=
 =?utf-8?B?blBDck9MeWpPditxbmlOWWdkd3JZYVd5aW5aa25wQ2F2QTZTWm1NN2R0TzVY?=
 =?utf-8?B?QVM1ZkFVMDV2MkFabTJrYUpKOUdiK1NVT0JqRmhLdHNFTXZuRy9HLzhkVmdk?=
 =?utf-8?B?STR5a0V0RGRjTm5IbUkzQVdFK2xzQ29VQkZ6Z3BrNDlFQmtFMTdUYnc5dlVm?=
 =?utf-8?B?d015aTlacDBnQ2tGTFdnTlRKZ29RSk1oZjFYaXRqSUFrQzg2WjRva2wveUlN?=
 =?utf-8?B?YW45bFFtd1dtUVgxa3BET2xxMjJPQis0Z2lLbFNmTTZYTmk4OHRURDBIU1JC?=
 =?utf-8?B?alRRaGZ6dWJ4MFVscnpDQXNtdUhkNHRzaWRiYldySmVzM0llQTlKK3ZZdFp5?=
 =?utf-8?B?cjNQb3JhUmw2ZVlVMk1FWVdwU3gxbDh3OURpWFdydjZOeUF0K2xLNHAyMlBu?=
 =?utf-8?B?OTFSVWMxZGFBRk4yUktZYWRNVlJzWXhaVzczR3hZeTBPUkhRUVVoSW8rQ2Ns?=
 =?utf-8?B?djVaaTFZc2pHbGRndG1vMU1yYXQ4dlBvbEFzdk12SFQ3NmFmeThiV2JhVXNT?=
 =?utf-8?B?aVFSMWVrTFRUMWZVbDBqQ0RJOTFPcFhkWnBpYm1kM3pydGlsTGZ6NDNKR1J5?=
 =?utf-8?B?MkRqbGlERC8wQmY4b0wzNDUwV0lQM00waEQ3VUo1TUhlUFZZaTFMZG8yYnVv?=
 =?utf-8?B?UENtcmR1dFE0Si9Yazlycy9DT3JCa0huSjRoZm5pZXF5ZU1FV1dKVVM0blpB?=
 =?utf-8?B?WDF0cDdjZFdyRlliQ01qNmhrTDdpYkFpL1g1aEJwWjVVSG5RajY0TGVGUlJM?=
 =?utf-8?B?TEN1SmtQd0U0cW43S0dEdi9PRmdYUXhxYUFSUnRRRGxpV1J5S3U1MzRlMGl0?=
 =?utf-8?B?MTd1MGdTQXVPdVZnSjVQNitxYm1sK0JXOUs5VzdxQzRGT3RCQm03WndwR0Fs?=
 =?utf-8?B?ZDNpMm9yY1VWaldUM1FwNTBxVVZIZ1dmS3J0VnNHWi9VcnZETmlkMCsxK0E1?=
 =?utf-8?B?YVZWcW42dnJaZW9ZNjhsY0FNVThVSjAwOTFFQmEyUGVZajlaUzEzVXErMkNp?=
 =?utf-8?B?VjBuK1hBRUQxeGFOWGJzbUpkWGFZTGI2R0xzeklWVXhwSGVhSUFBcFQ3UDRD?=
 =?utf-8?B?aGJSK0UzWTk2RVIySkNBOVAyUkExRnZNZHZMMWRLdXhMYUU5V09OTDluTHhv?=
 =?utf-8?B?RGV0OXZpZTZRMEpNTWNFeWRlTjFQdlVXencvZHAyV1RncnNhQm5XcCtnTXVL?=
 =?utf-8?B?aG1Ua0xPZmVFanFLM3d3Q1QyWklhZHJ5MldXbHBJZDB1Y3lhbVU5UDlmbE1Y?=
 =?utf-8?B?RW1KN0pjVDZzRG1ZQmN3TTU3OUFCSHU5RlBBMml0azZCUVhCSi8vbWFib2t2?=
 =?utf-8?B?aURaeWJzd09HMTFtL1dBamo0T3p2Zzl3VGRDdi8yOTdWbzA3ZGt4cE9wZk5Y?=
 =?utf-8?B?SUpWRnFmV1RFbVZnNDhTOVhGYm5RdnhLK09kamljdC85NEtaNFFDS0c3bHY0?=
 =?utf-8?B?RWIwTDZqYURCbjg1TGJOMXRTMzU4b2J4UHJrcUMzQ3pHak9aaGo5RG1wM01M?=
 =?utf-8?B?RHpQRVZYWlJRMWpoOVdDWkdWTkQvNkFyNWtlWjVxOEF5SjBhQ1poQkg3Y2FD?=
 =?utf-8?B?ZmI5NkN4akIyd1lTTno3Z3k3eHRjZHV4TFVORTNOSE1PdzFyUytrcHhkZDk3?=
 =?utf-8?B?QitYSmR4OXBYa3c1MyszNkR0RS9CMzIrYy9BSkdiVENxUHFhbmgyRmtiYmF4?=
 =?utf-8?B?SlZPS2djMDBFZ2pGY3NRNnpGWnpXSHp1WmdaQ3pMR1ltdmVHbi9IUFlZSjBB?=
 =?utf-8?B?dy9vdzd4bEN3YkRRa0VKY05uV3pVM3Bzd0JsQlc3akR4RFBneDNTbFVxK2dn?=
 =?utf-8?B?aHZkL1g1ckp5bEtXRnR1M2dBR1haeXprRVI3VGlEajdoYm80eVpmYzVRUzZL?=
 =?utf-8?B?aW5NMGlFeWNSZzhncXJSY0pXRFFIRG9zL2cybTBJZkV0akJCN1hSUTN2bG9E?=
 =?utf-8?B?cjNPTUlwSWMvbDY2OFhoais4c2lFQTl0c3daYjIwaGNuakJpdnRDYm5pbVdD?=
 =?utf-8?B?UnRHTDJ3SUNGazh5SC9QcWpjTXRIOFpCVktZdTE5UEc2TWRQdHlPY0ZvZlNl?=
 =?utf-8?B?WE5aOGd4VU5vWCtydVpsTnRTeXRHelBzSTFMZXI3LzVCNGhxckY4bzR6enFu?=
 =?utf-8?B?T1NTMlJWc0FER0s1b0Z1YXlNK2kwTjloVk9PT3NnVGVqRDJsQ2lINDJLN0R0?=
 =?utf-8?B?eFkvWElMR2lRYm1QcVdENk9zQzlVWWxEcnlkNnUxL3ZVZ09nOTErZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd585e5-ccaf-46bd-4bcb-08dea1f4694f
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 11:27:04.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWqFaVEqGlbJYYAHROqcszh0AQIz199Vk6yRoprYNQyHWbcPfGb/IEpVEJZadJnluQ7IhKe+vwUztFGbixl9bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6199
X-Rspamd-Queue-Id: 590071C000A
X-Rspamd-Server: rspam12
X-Stat-Signature: wzexko84dtufa7a9ef9j8qi8z3ujzuiu
X-Rspam-User: 
X-HE-Tag: 1777030029-542200
X-HE-Meta: U2FsdGVkX1+a9SPhLrIhY2SRDROTs4caMTkr7j5tbmH78O9cxCXI/WbneJjawTTktZ+gg+rkx/z19fmxpEFCa6k94813CZSs6LWBi/L0PG85rNPTIo/dMaRc/WatJxY0kWtnfQK/3MdMyDMbeOLOHyU0FrJM4BiX+dnyKDyV7oenMrNeeDCrB19H28aEk264doOtSYgkVbpEkAwsNtDVveyACT9QT89TuF6TOFBu9JjV0YWXwWIhEJPrwher6jHR03wipCgjv0QUBYlszyprYD2rAPyndIKaagFXSpN45OZ+C2pDtEmRYSWm237Vo+dp+dpmCo8NISWojHjqjtrc2MFgKsGw9hDtO0vT+dlqQ3oOUZOhWQXNq7p3+gGVpvBpMMjeeKD9y6GpDisnJidd3Vd+7NOqmbNBRlx3+Csqwsdmp7DiN8O3IxLfZUDtc/lJi+Lyv37TwxrjN2tItuAn0uBGMFHz6SVT402uZg05PZJJ8rP8GKal+YEvwlJWhUBEWs1hmKY/8f1Au/9+HrGYknK6x7bTk1nAkTvRT/mBqPm7hJ8ca2KE9sLo6AJy9VUfpILXre/1X2dMo6VxuyaECExp4TqYQorwCjCappo2lfSQJektjm4ETSM7bxN97x+eb3MvRTYk2NI/H6tk2FbCj+ELeFd0BOlVu8rHoK5udqKdTGCbOyxo/h1ARimBbaqeGX+/0v50qAiFujL5GHH6obDF9t5675de2e7HGLaBGv+ndWJZdUN3m/UqQ/EWJ5BrBFQibEK4RSdCTpE0KQpvnsFIRqDcfgathlAxeZ6cYYgt6w9jKwXxg5xyTmTUnwFKjhKPQhAahWpP7SDToB/5Vn2Gi7sLvf0oWS9sTZm2OwpPN1bGidbIB9js81FLU9CVDQ2Zxov/NG1ncbw2Rxy/XPRvyjq7wsyCZnkt77M1H52iHNKXt71okL0cscF5zj+fouET0A49xKDJK8Eu3Mp
 MrtBPHzf
 RdrEWEky4Rurxkhd1i59vTuo9ywjbbFjkL52WOIxBqWGowgDjr3HLzvvTTWIRkV0VdLbjpcuFLP50dQsTWWUWhSvpIHDOHSH7MQQQevrE9sb/LnH+Oy1xviQWFCPvh2fnkeOCHmpFfIKN/p1Kd3vCWFcFlNfhARxH6qdGceBSg4rY9jnQBEwBjrb9Fv5aCuP9HCpfmq3naaW4udU/kMa+uGgtekyHJThTmTY4C1e77zAUPrcjQwTrQreG3WM0W8KvMEi1I/Y1wYO6TRJ3p46CkGBmq5hN02ilJtJMFZxRBrJ6NuLMQ9dKrzMp3pp21NH+UGzk35Fp7/TmCOzzoZv7wJ2RQejVoDsrGG/L53/FCcjXLZQCCDbT6LiqSRJPS5YywVCJTaxnrkJUovWTp6veymR57JoM8HN/+sHWrVEmwzpwi32ekibViZfCI2iSadpTQ4b2mGE+R/XMaAMTPH26yBe22SLuKZja0J6iP9xBv16tAZmvQX41XPl72vkLliPUxrNKaGaS7OZlUPcTi6g7TqSKR3o7V8FmycpKATMjuaSDbdE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/23/2026 7:43 PM, Vinod Koul wrote:
> On 23-04-26, 17:40, Garg, Shivank wrote:
>> Hi Vinod,
>>
>> Following your suggestion at the Kernel meetup in Bangalore (11 Apr 2026)
>> to check 0cae04373b ("dmaengine: remove DMA_MEMCPY_SG once again") and use
>> DMA_MEMCPY_SG / dmaengine_prep_dma_memcpy_sg() (I added a
>> device_prep_dma_memcpy_sg hook in drivers/dma/amd/ptdma/ptdma-dmaengine.c
>> for this experiment; not posted).
>> I ran an A/B comparison against the existing DCBM path that uses
>> dmaengine_prep_dma_memcpy() in a loop over mapped SGL segments.
>>
>> I'm using the move_pages() workload to move 1 GB data per run. I do not see
>> significant performance difference, and results are broadly within each
>> other's noise band).
>>
>> Throughput (GB/s, mean ± SD), ITERATIONS=10:
>>
>> Page     nr_dma_chan=1              nr_dma_chan=4              nr_dma_chan=8              nr_dma_chan=16
>> order    dcbm          dcbm_sg      dcbm          dcbm_sg      dcbm          dcbm_sg      dcbm           dcbm_sg
>> ------   -----------   ----------   -----------   ----------   -----------   ----------   ------------   ----------
>> 0        2.33 ± 0.17   2.26 ± 0.19  3.24 ± 0.21   3.18 ± 0.23  3.29 ± 0.10   3.45 ± 0.10  3.29 ± 0.13    3.49 ± 0.22
>> 4        2.77 ± 0.21   2.99 ± 0.18  6.26 ± 0.99   6.75 ± 0.12  8.01 ± 0.58   7.70 ± 0.64  8.22 ± 0.89    8.72 ± 0.87
>> 8        4.57 ± 0.70   4.75 ± 0.83  10.64 ± 1.97  10.94 ± 3.52 10.30 ± 1.22  10.36 ± 1.24 11.27 ± 1.21   12.47 ± 1.66
>> 9        12.71 ± 0.09  12.68 ± 0.08 27.13 ± 0.15  26.89 ± 0.27 46.50 ± 0.73  45.17 ± 2.46 67.25 ± 1.42   62.78 ± 8.24
>>
>> Notes: order 0/4/8/9 = 4K / 64K / 1M / 2M folios
>> 	dcbm     = per-segment dmaengine_prep_dma_memcpy
>> 	dcbm_sg  = DMA_MEMCPY_SG / dmaengine_prep_dma_memcpy_sg
>>
>> <snip>
>>
>>> +
>>> +static int submit_dma_transfers(struct dma_work *work)
>>> +{
>>> +	struct scatterlist *sg_src, *sg_dst;
>>> +	struct dma_async_tx_descriptor *tx;
>>> +	unsigned long flags = DMA_CTRL_ACK;
>>> +	dma_cookie_t cookie;
>>> +	int i;
>>> +
>>> +	atomic_set(&work->pending, 1);
>>> +
>>> +	sg_src = work->src_sgt->sgl;
>>> +	sg_dst = work->dst_sgt->sgl;
>>> +	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
>>> +		if (i == work->src_sgt->nents - 1)
>>> +			flags |= DMA_PREP_INTERRUPT;
>>> +
>>> +		tx = dmaengine_prep_dma_memcpy(work->chan,
>>> +				sg_dma_address(sg_dst),
>>> +				sg_dma_address(sg_src),
>>> +				sg_dma_len(sg_src), flags);
>>> +		if (!tx) {
>>> +			atomic_set(&work->pending, 0);
>>> +			return -EIO;
>>> +		}
>>> +
>>> +		if (i == work->src_sgt->nents - 1) {
>>> +			tx->callback = dma_completion_callback;
>>> +			tx->callback_param = work;
>>> +		}
>>> +
>>> +		cookie = dmaengine_submit(tx);
>>> +		if (dma_submit_error(cookie)) {
>>> +			atomic_set(&work->pending, 0);
>>> +			return -EIO;
>>> +		}
>>> +		sg_dst = sg_next(sg_dst);
>>> +	}
>>> +	return 0;
>>> +}
>>
>> static int submit_dma_transfers(struct dma_work *work)
>> {
>>         struct dma_async_tx_descriptor *tx;
>>         unsigned long flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
>>         dma_cookie_t cookie;
>>
>>         tx = dmaengine_prep_dma_memcpy_sg(work->chan,
>>                         work->dst_sgt->sgl, work->dst_sgt->nents,
>>                         work->src_sgt->sgl, work->src_sgt->nents,
>>                         flags);
>>         if (!tx)
>>                 return -EIO;
>>
>>         atomic_set(&work->pending, 1);
>>         tx->callback = dma_completion_callback;
>>         tx->callback_param = work;
>>
>>         cookie = dmaengine_submit(tx);
>>         if (dma_submit_error(cookie)) {
>>                 atomic_set(&work->pending, 0);
>>                 return -EIO;
>>         }
>>         return 0;
>> }
>>
>> The memcpy_sg version does simplify submit_dma_transfers()
>> (one dmaengine_prep_dma_memcpy_sg + one dmaengine_submit vs a loop).
> 
> Right
> 
>>
>> My current DCBM path issues dmaengine_prep_dma_memcpy()+dmaengine_submit()
>> per mapped SG segment and sets DMA_PREP_INTERRUPT + callback only
>> on the last one, so the IRQ/callback cost is already one per batch.
>>
>> My understanding is switching to dmaengine_prep_dma_memcpy_sg() mainly
>> saves the per-segment prep/submit calls and hands the provider a single
>> multi-segment TX to program.
> 
> Right, but the analysis you showed indicated the dma setup cost was
> quite a bit, this moving away from N transfers to single one should have
> saved a bit more...
> 
>>
>> Please correct me if the benefit you had in mind is something stronger.
>> Thanks for the suggestion and for guidance.
> 
> I still feel this looks better version... 
> Can you compare your setup time between the two please

I wrote a small dmaengine bench module to isolate the setup prep overheads from full migration path.

prep_memcpy: loop of dmaengine_prep_dma_memcpy(), one descriptor per SG entry, single completion callback on the last tx (same pattern my driver use currently).
prep_memcpy_sg: one dmaengine_prep_dma_memcpy_sg() per batch, so the provider walks the mapped src/dst SGLs (proposed)

Instrumented with ktime_get() for each phase - prep / submit / issue / wait.
Happy to share the module and the runner script if useful.

Workload: Copy 512 MB/channel, 20 runs/cell, src_nid=0 dst_nid=1, Folio sizes 4KB/2MB, batch = 512 SG entries.
*_ms columns are thread-time summed across channels (for c=16 divide by 16 for per-channel time)
run_ms is wall time to copy the 512MB.
prep_calls: total number of dmaengine_prep_dma_memcpy{,_sg}() (512X less for memcpy_sg)

mode            chan  folio  sge  run_ms           prep_ms         submit_ms     issue_ms       wait_ms         prep_calls
prep_memcpy     1     4KB    512  632.86 ± 8.18    18.00 ± 6.38    4.44 ± 0.09   0.09 ± 0.04    603.54 ± 5.03     131072 (= 512MB/4KB)
prep_memcpy_sg  1     4KB    512  611.34 ± 13.52    0.74 ± 0.33    0.01 ± 0.00   0.08 ± 0.00    610.48 ± 13.68    256    (= prep_memcpy calls / 512)

prep_memcpy     16    4KB    512  675.70 ± 14.13  416.19 ± 27.49  79.19 ± 2.27   1.53 ± 0.12   9590.11 ± 206.81   2097152
prep_memcpy_sg  16    4KB    512  615.43 ± 11.55   19.61 ± 3.38    0.17 ± 0.03   1.55 ± 0.16   9202.33 ± 138.41   4096

prep_memcpy     1     2MB    512   77.19 ± 0.15     0.04 ± 0.02    0.02 ± 0.00   0.00 ± 0.00     77.10 ± 0.15     512
prep_memcpy_sg  1     2MB    512   77.21 ± 0.11     0.00 ± 0.00    0.00 ± 0.00   0.00 ± 0.00     77.21 ± 0.11     1

prep_memcpy     16    2MB    512  186.01 ± 0.40     2.31 ± 0.17    0.32 ± 0.03   0.00 ± 0.00   2712.56 ± 4.24     8192
prep_memcpy_sg  16    2MB    512  185.63 ± 0.37     0.09 ± 0.02    0.00 ± 0.00   0.00 ± 0.00   2711.20 ± 3.75     16

dmaengine_prep_dma_memcpy_sg() is a clear win (fewer preps, fewer submits, no per-tx callback bookkeeping).
However, the end-to-end throughput gain was modest earlier because migration path cost and per-descriptor execution
time (wait_ms) dominates.

Thanks,
Shivank

