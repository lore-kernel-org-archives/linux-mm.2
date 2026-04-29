Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCCBFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114266B0092; Wed, 29 Apr 2026 01:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4F96B0093; Wed, 29 Apr 2026 01:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4D06B0095; Wed, 29 Apr 2026 01:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF6B46B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:51:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 713521C0C3C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:51:56 +0000 (UTC)
X-FDA: 84710522232.22.87EEEE5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011065.outbound.protection.outlook.com [52.101.57.65])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7E0C9180003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:51:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AZ7Dw+nU;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777441913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wq/Hakn/zygO9H0xktY6vDwmIOORdpZq85J7PBcuNCU=;
	b=a0ZoXvrczMcC3Lax4XwTnAot9v5azrlPtXXS1hqN5rwmn3BThhPGL0uWyzzCEnwAAFG+Ne
	DYTww/YxEKQh+V3FnQ6eE65jsdB2poiA+icJOTaiIjjgCDL/7Zdiki4xfyL7bP4rlEzMVU
	SMSgUhpujiFdioj+l8dA0++PQNpyXLA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AZ7Dw+nU;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777441913; a=rsa-sha256;
	cv=pass;
	b=Ajzv8z5FjARksDkxAQad27bN/yQqXfNQzDGUzu/bpPg1Gf7ReVrUOWFyLGsyJ0K98bnpPj
	FpnC5Da/ufH8mZ3ScE+23BslpSZkbSbJkWTj7Qyj8AVy7MxJ67i2VwljOkYCg/n6ez+xLv
	4NVbaEzYqYDxSaM1uy1FlF7T3DA4Uog=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvZUwCAgr3Hvh5/uNQhF461otUEYAxTD5OOY5q0vokvcldI9c7aP9r7XwVqaEuVX5Byqc6kgLkO7a2DLAOSdIPJkgXPZRYNOTJgXqis+bOqptaUjdrvwiIne90kL0Gbf0znUnKIs5DwTFYtetAoR6GYW/KbEVdEkzKuNVgEKF7VChkiyimKGER56/paTl/HLKEp8sCZ/w9/kqQOAN8OB+IJ82FcvMyohV5JdmqX4vGq0jh/+u6cBEbsEYrIkhLjYGLV2r8a07OdUSB7s5LjDRI3F/H0RdI0kLfJiBqKBDyDwB/bSXm7kbhZufEGFAb/CCRFWHDoLDAfDy+iP1r4kDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wq/Hakn/zygO9H0xktY6vDwmIOORdpZq85J7PBcuNCU=;
 b=IhymsECJjUTiH1ptlGI7im0SLRibGkUDPXrpAgrRMHXzQv7ChqWA8smIdj/U7KK/wxyOJwf7A48Z+gKUnjik27b9cZ3GfH07k9X5m+HVg3kYEhUZ24lB3DRExRF39Y2OyApHnjJFslCudRImI7bO4hkcVCHnqx5AqkLP8xjafb/94dYy7F1b0Ru5VItkACHbHSPyyRhoaFhlBsM9TOlAF9KE9X76abygx/wbV9fd8wA6WQObirEJUvXMUbxpqcaiZwy30G6zNxdWgLkmTdFCck9Af/eQ5o3Mo3sp+xs0l2agF+nKhEgHf6xA/Ao4D+ovSrZLl6hv+I2m3LVH0K/x+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wq/Hakn/zygO9H0xktY6vDwmIOORdpZq85J7PBcuNCU=;
 b=AZ7Dw+nU3G/3RKfnGyqW2ctyH5UMXzXbOwIOM/d7K20RtBOw5zBbLimaLmGyx0HOxcdBp0rf1ej2oSOXoig3Cujw5RYw55W2OrnigG7D8XSH+FR6LFueB1TujbS2rcQoqaaeefz38C9Tj+3hzPhiblTnCCq3EegZFECR7iG/StM=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM6PR12MB4281.namprd12.prod.outlook.com (2603:10b6:5:21e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Wed, 29 Apr
 2026 05:51:49 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 05:51:48 +0000
Message-ID: <9919627e-e4d7-4904-b80b-4ab19b6d8428@amd.com>
Date: Wed, 29 Apr 2026 11:21:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <cca382ca-861e-4bfd-a628-45a5505b8b31@amd.com>
 <da60cc10-53ae-4f09-948b-c8c9f42d822e@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <da60cc10-53ae-4f09-948b-c8c9f42d822e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0111.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2ad::8) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|DM6PR12MB4281:EE_
X-MS-Office365-Filtering-Correlation-Id: bf11fff0-89a8-4512-0ddd-08dea5b3677a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lPvNKVb73GmB4s9NTADb7r5RoQ2UW+bVwn6JvZRl/y9ljafrH6qrDcPf6ppLj9hCS5PaNHUqf/yZa4uG1oQos9z+WRLZqLsWKVWq12LInzApPbee2xi9nUk7dZNgJ47VA+wRQV+faWb4jLNS2rlrSj+Dqc38ReB6CQNxvmebTdB8moIwqUPwabEhG0SbPCGoJSnbs5NNsoHbVCOTs0QkBGGGo3Dwfy69+BWpqBS7s5ukEBxvElIvcDAIQaOPx5ZYmg6IQpELa6HE0w/J5uL/BSIOi5okxjSFMGb2p/V1a2udB2U1xBq/LJAI58OjI7lhmPGl50vH5i196/I71mtd1ufP3zbCxFuMMVe3PMeurL1pTenRg+aWiFOkMiNwQQpxKmh1YvN7c3JBn4HyHS7sXdWskeDhYTeiOOfFfJisjKkNP3dSvm5/KF3903HW0EauxHlUl2DM2y5ybzUMyHUOs6wz6P+LY/9J5W90tIFIEaHZsdPpOxHulc/5Kh4gVqfqzNo0HKVO4P+WBZjIyoG5TtOwprj5r2lBvNP+qdmE5bWd3EwKvlDTktj8Gdl7BzumIlA4OV6ay7HcJ+Vinw9DatfscIpl3PVIFWtSp2x0KPmxZS4HtBAdDD0iyvjIlxFLpZ3FXYNUfmKRDhE3E8OA4tCP/NEO+l1bz1FYk2VF9WybVLso9Mzpjel7H9guovWWuX6Fv47a5bD15b/huNpoNiKraGmxqRAfXH/DwFRJd+I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emF4OGpHZDRpTUdkYXZzNFo5MldGaG8vSWJLY0xLL3RscTNicVAvc2c0RWdW?=
 =?utf-8?B?aVNwVkFTOU5PQzEvZC83YXF1MFY4eDdrNEFxSjd1THlLeFNqTFBxdkdsQkZR?=
 =?utf-8?B?aWRXbVMxTDYwQW92bEx1b0pDKzFQblRSRDUyT0xxSXZ0dW5RM3NkUFFIeHZo?=
 =?utf-8?B?eHU2Y1BzN2NhS3ZBN0E4VU5Md1Z4WnB2bmx4N0dJcTBPdytHME9yYzdTeXBu?=
 =?utf-8?B?WU1aMXJBNC80MlFGMWo4NC8xMVEvNDl0RGtYdGN3cWhza1lBeXdGbVdzWEZ0?=
 =?utf-8?B?aWsxN0N2bEExQ21QQndpdTF1U0llbG1XTTZPVm5lQlRVeUJzdkdnaXZTZm8y?=
 =?utf-8?B?Q1JIbTBFbkpUUFQxRGEvdTRUQTdmckJyYXV1Q2RUeGpMUXg0Y2JVNVVSWER1?=
 =?utf-8?B?b252VG4weGtxZlh4R01oM1N5WkYvNnlHUkh2aUZ4T250VGtHSUtHZVNRU3Bj?=
 =?utf-8?B?UUw4UlY1RDZ2S1Q5UXBsdVRFK3Rtc3J1NWc5Q3B6UjVGYWEzaE9KdEMxWGIz?=
 =?utf-8?B?WUlsY3VaaE9FQXl2WVFsQVZBSnFoOVNIWTBnTjNVTnNtTVNqOFY1MHNnbldq?=
 =?utf-8?B?NlBPR0dUZmxqUkM1M1QrUU9OYVVYZG1JUFh1ZFA2eSt5RkVXMzN2b3VXUnhD?=
 =?utf-8?B?eVhxNm8yU21CZHJDVlp1cGpKbVlwVjVZMTJGazZ3RzRPOVFQYTFrbjNhazE1?=
 =?utf-8?B?M1Bkc2ZtZFYySFdoWXE3RVlPb3pFZEJsU3pDWmVTVzNLR1ppWUFCbkN0NFVQ?=
 =?utf-8?B?cHRlWWI4QWRXMG1wRzJxYUlKQ05uSkRtYUgvYllPcTFmR2ZLRGsvTHc3Zm5O?=
 =?utf-8?B?TFVuRmpqQk9NdU0xa0dDb1JUVitFY2lqUElhbnBHS0ZTV3RKYjVUa01HK3Js?=
 =?utf-8?B?UzlXdmora3VndGJ2WVZtaG5JQjA1a2M1ZHBMblMvRHJDUW9GVmdKMkc2Zzhx?=
 =?utf-8?B?eUZxaWlHSmErdGlTVldIMzVvbWRuY2VKaXhPTHMrSlFtOXZPTVh0K1VFWFVF?=
 =?utf-8?B?SmRTSXJCaWNnRU5HRWVxT3lEdkluQ01DbEszaHpIbnJvK2RyNytOdDFqUWp1?=
 =?utf-8?B?clFKQmswaXdFR2NGSnBTYi8yYkJtWE8rKzgyT2NUTDNxb1ZWUXdxMDRwdFNR?=
 =?utf-8?B?eUdpa0hiRHBMRmZITE01aUJOV0FzcTF5NEdFL0ViMGh4cFc0ZnRXOEVmdlE0?=
 =?utf-8?B?dDI1U3p2emdOU1I5MThvNy9hTmNVTjBiYVYxNTNBM2taODZlekZjOHFra0dG?=
 =?utf-8?B?c1JOWDV3YjV0NVFIZjNaU2U3Wnp2SUIvVkMzRlFKb0xwOHZkKzNHaW1sRi9G?=
 =?utf-8?B?aEhDSGZEdWZlc3dLSjZIUG9vNm1kaXNSdnd1RHFmTnJoeVFsTkYydElTRTJQ?=
 =?utf-8?B?QmJFY3Vremh4YWIrOTJyU0REQk43dVRFTHdnOFFoZ1UyL1RpUTdKZ2VlUXg0?=
 =?utf-8?B?clFVRnRwajBhK2c4Z0Y2QjNIczNEbU5lcU9jbkxrMUxqNTZXM0xoNk9SMG55?=
 =?utf-8?B?d2xXc1BFRjBFcithRTdyWVJSMWJXTmM4YTRmVWVlRVJXVGlITVJ4eDZTdDBR?=
 =?utf-8?B?ZUVMTllqLzducUdRYXo2K2loQ1lOelVveSt0TU16TXF3NFdkNm9pOS9XQVZI?=
 =?utf-8?B?eUQ1a3QyQUl5WDhpZHlnVnZJNWlBMkFTbTBiWDQ4U1NianFYRVFxRnphRWZZ?=
 =?utf-8?B?MVNxSStBODhxVnZWeXNudjdLMGdpcC83Sk43dWRPS0U0M3pNTFhucXdGYW5a?=
 =?utf-8?B?cmZKbTcvVWJ0cm5GNDI1SkN0WjU3ZGJnb1ArV2VqcWVjalZHMFlDcjBsTkJm?=
 =?utf-8?B?L1F1VjRhanZGelNDb1VjaG1ubGhHZ3FHS2dyY2h5RW5qVkwrOVFCTzA2WE1h?=
 =?utf-8?B?cVFQYlBRNUlXcVgyNG9tMGprUWdqM0kwOVBUWFlWM2o5b0RGSTE4RzFOUENP?=
 =?utf-8?B?RnB1M2pnaXkxbTljZitlVXlIWGxjUU0rSmNDaEErMTYvVW1ZMHBzS1VQMDlk?=
 =?utf-8?B?UlVpelhGQVNKM3AyQ2EzK01jcUtJeFJadmtUdHJRcWFJUGoxdk96R051TUZN?=
 =?utf-8?B?eExhSXZ4aUp2a2tGYkRqYytSNUNMdkNNUWNRYnN5bTEwQ2xoWWRjZlp5WWwv?=
 =?utf-8?B?YjlQWTAreERLdnhzL1Y3b3JLdVRUMndQdCthNEd2aFR4ZW04VHlDdUpYak1G?=
 =?utf-8?B?RElJcWJ5bUQrczZoUFZXaFIxYmc4dDhlT3FGZ3NGL2s2RlFyL1lnTGEvNDFF?=
 =?utf-8?B?cGs5cXFmNTNmS0tqTW4wcklhNWEvUE5GdHBtM1FQRkcxZkxsQjFMOEgxNEpV?=
 =?utf-8?B?VzAwTVVXWWgyNTdKK2lyWUdtN3BvamwxQUJzaGFmYWYyWXB1QWk1UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf11fff0-89a8-4512-0ddd-08dea5b3677a
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 05:51:48.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ka2ctQaRZK2ICRbzX3dr9G62Zo8IcHdfEQmQ4/3QzI1cT8zocgiPuyN95mwe39oLI1k+vi2AlEnwdm6ngucw9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4281
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E0C9180003
X-Rspamd-Server: rspam06
X-Stat-Signature: pjy7b54yhta1e99qwbxzfwyx65bck65d
X-HE-Tag: 1777441913-657895
X-HE-Meta: U2FsdGVkX1+DpxYlrkqobor5rG85LVrbaNGVMvqOpYrgd7cn5tntbTocOjqkrbQ9JPG1fNZO69dm0LZZbwef4+xNi0FlyLOm6JYnXkPI9+3ckWm7zGbpuS9cPbdSjk50KTso9u/gje8pa0gv7nLqjXFQ7i9GKovb03pa5m14SZOFnI6HV7WKLgjFF+Qhk8kDhYK7YJV97fUlFK26SrQRGyQgvTAC6ZEKP6di1uEu0gebIu6n8c8Wiarmzyd5SmSmxslg7NQSdqpEtoZvBeHzJm8bZ3Oe8JYH78+MisImW8YGo5AK4ClRdV0/X58HJNHgbI8gzbwlUX8IlujVaJ4AfLrAokUeo19dGGUKaVkZh+5E6LT64otMEy89mlyjboW0Uar7WpBrOxXpNUfHqoTM7Q1exgyEbzhbVq4C3P5qX47agx6SKIq7G3rXMe9Fl3wpnJdDyeZnqxMyox6bNrofoTHfCaxGhcEsKB5F9eAZdD1QdgHZSM+PVe/UuomCnkHgJ2eLbG+p9N8N/++08fmmZBpB/fIbPxsYZoY/ZT5223ZpWRrbvT8OQ7H1H4urizmvBtvL4kNZeyo6fl1TEY/7AIeGn48ZgS08IJ5xvRZl03CECrr5lqOKoyDydQjuC4CB4HnGlnPaqnIHgv4uTolk0ItGGYY/upgGRunfqfCJEjgJgzsVJa+xC7E6N76SAKiQYZe5RT7VCHaBBET+zH+Eup5kBSJRmq0GqLRBmD2PT+oxHaoh5izm5rTLeYtFEzU9tZOBPsWLeBSx7dV/p5Mu7odZMKGEYaFRs1nLiJO2sq7lDJpk0jOGGovkpdJQmLKBfz7JJ/ybHcegjU+Lc4+z1Kwm3PBjFYAVXcCRZr0443nwznslK12UD3zjHb135V+GghC2LAi6ZdIb0Gh6fJg1mB1wkAP/BflF/BoMfyMqVwxP5zwKcF9hz9vMb2w8wEAvhhcclYFTLh/khPn5M2S
 OGJ68FyG
 Nu+2+gnn1h2U9sz9oGKZtHP+K6+2+Z0GGwxJX0kGUe8zS5YPEag6islXI8WONY94X333io90FBuo9JjMGCfI+aI21tdVY91sGYj9rV2QQCQk5yIDSal27Xp0aczDjgJaPqeip6pQP1vwXTQd7I4hsbuDcby2fGQqQW4g9dOq2ESP5KKFZ71ScW/aveAuFFHcBZTbuN/DPtiRN7Z1QCmVxI+IYJTDML+CTzlJlzOFI/OSzLEqg5KjKhFywZseZ7PQLalq5n8fYoPbfrkyzGQlSj8n13mP1mOKYlQeMMC+vIwUYmqyl/n2GaNqYHt+81CAM5YHwZuTwEnn3YjFWMVRGY6kbzQ9Ilctn3ABBo02/lRmlZYF5zQWQAWLO83zCXXhACi7avq+T0jCZ+ivWF7Qg4m450MsKSuuHgFWJv1CRCdtrUMT7rjU5I3Qqs6xRDuvTGORmNKV9bHLizn8OBROAYcTAiQRvzBH8nbrJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/2026 1:03 AM, David Hildenbrand (Arm) wrote:
> On 4/28/26 19:11, Garg, Shivank wrote:
>> Hi all,
>>
>> Apologies. The subject prefix should have been [RFC PATCH v5 0/7].
>>
>> This is the fifth RFC, as mentioned in the cover letter, but I
>> missed the prefix while formatting the patches. Please treat this
>> round as RFC v5.
> 
> Ever since I switched to b4 for patch management, the quality of my life improved :)
> 
> $ b4 prep -n SERIES -f mm/mm-unstable
> $ b4 prep --set-prefixes RFC
> ... add patches
> $ b4 prep --auto-to-cc
> $ b4 prep --edit-cover
> $ b4 send  --no-sign
> 

Thanks, appreciate the pointers. :)
I'll switch to b4.

Best regards,
Shivank



