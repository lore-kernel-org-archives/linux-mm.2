Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0719CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B11B6B00DA; Wed, 20 May 2026 11:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288E56B00E5; Wed, 20 May 2026 11:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177736B00E6; Wed, 20 May 2026 11:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0415D6B00DA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:06:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF58B8C69A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:06:35 +0000 (UTC)
X-FDA: 84788124750.15.D2353F7
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by imf16.hostedemail.com (Postfix) with ESMTP id C0E58180015
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:06:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0aGL6wUu;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779289592; a=rsa-sha256;
	cv=fail;
	b=rF4iHR68/rR6X/E/fqhvVIDvxU2+G94lGlm0Tn3JoWSkgDh+8Jt6G/q0OJHhir6Y73fQxd
	m6kSiRGrlnYcM7VYid+h3pQgObw+1wFjBbklTBA3ZZ7+4bdmcDTtCrKdyfSZeAogSrnygs
	oN2VgGGf0inyb1nms/zUEiJ/xfBLbDU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0aGL6wUu;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWpH07FRj7FtIb2oAktLMxHVMr3NL9JY6LbLZaVAw9Y=;
	b=n/ukzGGsquqbZeRinmJGGgWCJUcQcTk+acgo22qqakPL4whlAl8WDHRG1zCZ1/k1//7f/T
	KNyxr8FlcT87iU0Z66mCUnXcJS9d0tWlEdwIaq43sfLW506Q+L6tcVhIHDI5kD7tiemcz6
	Cw+8mFphgRzBD16/vUIoD1jBo6/70Cc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQ5b4Z+8SfB6wgSuh3FopAJlW8qt1TPEpEGfSEWX12d7XAKL5nogMc7RV59B+Me+U5HklsIpL819i8GZExulzWDD5p/TBDJUjFAPsJptYXfMpkfA4QJ2DJIuSb7T/EeufHhgybdwwbNmdTtNBRcjw2MfcsaK217l9cj5WJhIEvyRUYgx6PzKCdfapKPtYjQa05lsMy1De80HM+AXxJMLchYa815LRyzQCj7Fc9V6YyGrkKjuXokHx3lf3Q1akc83dVha/GPJVP9KeP95EhbtrgnRBOQb9WgVlzjQy5WGfA/fSHJd9Wz3zjmYde8mBROesTz9Y4xzkNG/TOU8i/nfuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWpH07FRj7FtIb2oAktLMxHVMr3NL9JY6LbLZaVAw9Y=;
 b=LpV8N6UmSN+Pgac4qg7LFmnt/su43blTpkr4AWf/+ag2jGJ924BAwl7J3Uf9gQbsHYTg8facUMP2M5imFfFDwa06zQaDntiOTUBWTja/6pK1AFa+bB3LdVeXwPqEM6X6PERMwZDJucPp9fF06lYVBvNGapsJGWwhKpH+1cGpLWLVdLla3wufNKmhyPrqcJu5YU7OKNriv8w+7lOT+mvrTw4DsxfLlQGzzXn8y6WVhoK+nSgFMh+yAk3XRshsrwQTQLokw/kEPyar9twE/8TqHnOSv+SgCfgGhP9eNtQgxfBPOq7en5F17K4+ZHRYjzEfLcR3A2mMEJKgMiLWbIYTmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWpH07FRj7FtIb2oAktLMxHVMr3NL9JY6LbLZaVAw9Y=;
 b=0aGL6wUuO6uLwxpO4i9+D8N0e4gkSpO6VVwSVk/5SOHiTKDRjfEvEWUxRLbT4oseAta3eVQ0KdUhvrPzvzumpT6K7ddD9IAYPGOQomom1OUcLnepYoHhE/W0UGR9lQAaHHxLOMI5oP+oZfwJjL9mPGJFM7o4KszKQyXcFlX1zGU=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by IA1PR12MB6019.namprd12.prod.outlook.com (2603:10b6:208:3d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Wed, 20 May
 2026 15:06:24 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Wed, 20 May 2026
 15:06:24 +0000
Message-ID: <c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com>
Date: Wed, 20 May 2026 20:36:10 +0530
User-Agent: Mozilla Thunderbird
From: "Garg, Shivank" <shivankg@amd.com>
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
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
 <20260428155043.39251-10-shivankg@amd.com>
 <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
Content-Language: en-US
In-Reply-To: <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::24) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|IA1PR12MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: 3076d27c-70a1-4436-93ca-08deb6815bd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|4143699003|11063799006|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4aJxMLamDQjz/Ec11sOzn6f32I94Sd5AIlcfT6DTO/StYhgMm6bnEBnUJF/GsaQcNAL0ORPyZ7qxX1F9r4v7KFRAzbxanSojurhYVqwRxGmWIEPBu22ZKhSUtmrfZipazW2APATYn7mh7F8qRwtrRaSXhAodFf4oxwlp0Oy2RZOoCsUfTkk3k38KIN+EKmVj+Lms7Z4j5vWMfPWOzCOOstwj3AO5Cc7muifLU+b5BW9PHz8NmPIpIhTK3NB1e9jQRDFRcmZhlYIAivtIVS6XEiVQxqptuXIYQKIk0ZQBTMnRdciZoRml1Q+mGHV0eHOe1xWrxfhEGeAOmlboD3fEBmn8s1h6NroVd194sB81QSadKL0nqyFBNTND0WfV+7tyZXEoMziRdVJr/DkPumiOU0NkFDqZdBnhYb3D46Q+XwiwGy4//Fr2nJxeruRmiP7bKFQ/lUuyLuzXIDn+KHy1+EyPU9jg+fQQCvXNsx+mFg8BV7lTbSCUNo1bbr6RJfG2PDyiciE15QloWVALkoNmnN5LKkOtox87+pjiBpxroqaOHhocGGTL/CqbS33fntJSV76CmoxZZNvKECm0AgO8Pgv9hEhtbXr5MnZnX01rcRjHqw+Zmj0axnmIxQMA0Gp9uzkId6meGB//KqicW2GrcBTHU8hgNrOeQRFU4mHiPII812pXc2wW7/4T7y/4s2e2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(4143699003)(11063799006)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE1RdVNhM3hyZ3VndlZIZ0xSVUxDK2ZmbVRoTHI2eHBFb1BoWG8zSk9OL09B?=
 =?utf-8?B?TXJWSXZiR05nOWxVWU9GWVZvd3Y5eVpTYkQ0Yzgvc2VyRERFZ3ZyRER4WW5s?=
 =?utf-8?B?NmZoemE2SmxzZ2J2YU5ROUxxQXdpV3BhTDJCOWZycjREMWsrMFR5dVVkYStz?=
 =?utf-8?B?WHdkVEtqcVhDREE5Z2FRMDQvaHRXc1RTVklEbkdmUDZXdTdLNmR0dGlJVHdQ?=
 =?utf-8?B?VzdpRGpxTHpUdG92VktwWC9MYmJodFM5Q0ZPSHVudmgybWVXbTNwTXlHYlpO?=
 =?utf-8?B?RGxFdSs3OGY0bGdraDJISnNQZzY2Y0Nrak11VmJCRWNQbUlTNkQvNFJZbE14?=
 =?utf-8?B?bGdNRVNkMEtHdCtlOUJodWRrODNUcTdSeWFkQXFsVEtvOVJHL3oxd1FhKzNl?=
 =?utf-8?B?VXA1NlVocFIwNkJOTmJoOWRoR0ZzL0pLREJyVGxiNzlISEtMNkJESVdqVWdJ?=
 =?utf-8?B?M3BkQ3RtOG1URVVoUDd4T3cvdG9BSWhvVUwzV25HL0JxRXJRdGtQOUZsUWVJ?=
 =?utf-8?B?MURiNkQ5QnZ1c3JlY2FkME1OZ0ZmU0RBR3NRRDRqMkxnUGdyOU9lY3JXZWlM?=
 =?utf-8?B?V2NUNUZEMHNzaDVSdzJ0allkaHZsSnBYNE5zQ2JHeVQ5aHg2amdRdkM5TWVZ?=
 =?utf-8?B?cVF4UzhwaS96bXlGTysxQ0V1NERzWlhCaDB5ekNidHAxaFV5Q2toc29UTzFz?=
 =?utf-8?B?L2QwSTA2VUhydDdnMk1tWHhNQnJwb0xGMW41UkNWUTdxQWsrcU9uVzk3Y0px?=
 =?utf-8?B?MHlKTFlqeFBIMlIxTFVoRTB1UXRtSW0zV3I1REtNT3dvTC9JanAzbkZVTlNl?=
 =?utf-8?B?a3NKV3RhTVhpTWxWSjh4ZjR3UGdKZU41RUxtYUFZSjN4R3A3OENReVphWW92?=
 =?utf-8?B?bW9hT3k1aENSUzZ1ZmgxTjk1dU4wdUZUQm1IMGgxeXZGeXJvSTJnNlVQVGRm?=
 =?utf-8?B?U0NVelZUdXJuUGtiQlp2TkJUQTZ2anlYRFJPRFNhTmpWMWh0ZFRya1ArY29u?=
 =?utf-8?B?R0MySTFkdjZGYTQrYlZ1WkJnakpPUlJzL1RVd2R4NGd3RXBRcUdrUXJkb1dN?=
 =?utf-8?B?b004ay9DbVUrVDlJVDZldmlIMTdGSmJmVXNXQVBNVysvUmhtN2RvRWNCSUpJ?=
 =?utf-8?B?MnBxYXlnZTRJcVhjQTZhTU1mbDB1ck1SREdHaTZiakNUUWszMkxqcUZGaGla?=
 =?utf-8?B?anNtS0VIVzVpSXVMdG5qU09OTHdIVVh1dUplRCtSb2NwRGJBd2FXTGdvaUd4?=
 =?utf-8?B?ZnhFRmtCNlMwYlFZZ3NaZXl2S3NOakJuUC9TdmxHem0zR05QOWxxbFpxV2Zy?=
 =?utf-8?B?QUR5eEx1bzJ2RzE2dHhzdmt4ZW9HdDVGc0tYbEhaU1o5SGJaUnpJQ3RuT0VV?=
 =?utf-8?B?aWc2NXNCeGJvK1JnZFJWNndsTjNNRy9iODNGNXl1MnU4TEUzaG9oTkZjV1Q1?=
 =?utf-8?B?S1VQTThZemN1aGUyTG56aW9UVHh4Z2N2NzBkQ3ZJeFZUUVg2TmV6YjNnZTBs?=
 =?utf-8?B?VXRLU29WY01vME9vUWh1RS9nYUpZV2pVWDZFeXFwaXRheG1iamIyWEwxUTdz?=
 =?utf-8?B?dGJNOGk3VGR1Tk1TSVVtT2pPVm5SNjNHZlFQQm1QU1FLTWpZdDJQMG83VUpI?=
 =?utf-8?B?S3cvYVQ5aWRkTksyWDJKOXl0Wms1WkR3bWlPcmtDOEJBdkc1ZDBzNCt3b0lV?=
 =?utf-8?B?Q0FnZC83R0djTEQyN3pPNllicXBZOXV1TE8zZk12VFVpZ2xpeDFtcFErRHBs?=
 =?utf-8?B?TnhJenYxR3ZHVVN5TmNRaEJRT0xPK0grWG4zMWhZTnlsQXNkZVNUYVdwT0Zt?=
 =?utf-8?B?T3hqK2dhOGEzb3JUak8zSkwxWnRuVE1Ya3dDK0p5NjdScHVUUVhBMGhlQVNw?=
 =?utf-8?B?QXlvNnlydjM5RGJoV3VKRUppTUNFS0VZUHBnTUk3aTY2SDVJTjJMTWUzdUo4?=
 =?utf-8?B?VndoNkdadlFmQS8wOGMrUXBJZ2F6U3BidDhWTW0wWE9waFVmWEYxYWtTMXBO?=
 =?utf-8?B?UHcyaEhHZ2gza2lLYWEyMnp3UW1hOGkvMVFZSkU2WDFnM1ZTdzZxL1lTWG9B?=
 =?utf-8?B?ajNRQ0ZaRjR0Vm1jSzRsYTd5KzYvV3RtaWFiQmVFSVNIL1JvYzdRSnR0dnh4?=
 =?utf-8?B?dGdVVE8vQVR6dGkxSjRQa0xoNkcvRTJ0MnVIbDQxd1pEelFscWNINUs4WlhE?=
 =?utf-8?B?T2NzZjlWRm9RRmlSZXB0YjhPd001Y2JvNTZmU1NTYnFORnRYUjN3NDNlOWx1?=
 =?utf-8?B?anVLeTdpaDloUm9KNG5lM01IT1JycnorZXVUV2xrUVdUTDRneGNOL2tPMHh5?=
 =?utf-8?B?TkxDSkcxaUk4K1ZKcVhuak9QVjdtZTZmQksyUFQwSHFOQ042cmlUQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3076d27c-70a1-4436-93ca-08deb6815bd2
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 15:06:24.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0R/gJv3cIvte4P339OjlOCDKOGDKAV3eYVCroZxBuXCvBjNJtPWRnFIPcxbFfIBBWT0aDrA0ArJZD50USMVdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6019
X-Stat-Signature: pw7tn9e6bcpps9y7jkssycbdagk4n1tp
X-Rspam-User: 
X-Rspamd-Queue-Id: C0E58180015
X-Rspamd-Server: rspam07
X-HE-Tag: 1779289592-965619
X-HE-Meta: U2FsdGVkX1/0aWr1U/y/yXfmtMJqChKTxA4yuFf46AESvLbqQBqDbO6shqFhv97/BOAYQfl54h9+dYU6hf3iwDm0P1XnKIVW0Z3FP6bsLALIeRuQtxlUgMAEA+m8sn7UVePEGvarCPOAFUHhuO3v5YQFuz6NOLtBWlUuGkyJvl+6N5EphioRjx85est4NaMyJX1KIm3vy6O3d5gFg3On6u2uN5zZOzepvbwU6sTRLGDbVLFqd6qc5yv6fcmbiENoLem9Ug3MEbhFCOs1n74sIuS43aCpLLQMl5CM/a663cCkuhuaOZDgU3fQjsx5wFtS4LnnFVK0fRd33wbAUDJS/we6fYNl6NPoDjzpnXlfFrtQ+4AeMGLLkqMS1OrteHE0ILXjQnpWtyfEB2XsvI8n7l2fs9uQiov7AWBngo37oK1TQyI71lerWjejZlDRvzstC9BftIFX0WvYXTBnHrj8eKdFP3RaZOhV0vtH7aA0VlwXUCegqNe0s6R66zMs8elnn179GjKLtRgUAzqFlnJo+y4rDQ03/1GbmUHXtqFCzd4FUmU/Q6MxjQdzAuHoAo5sMQjRc0oyWL2t9+yLU5reB2UHWfPV/gvxtq4VRo8vTP6gLnku6HD+tbVaOrovgi5MUvb6b1TfhSixRKFYF5p9QujfbzQxK2LH4X/5YcksEsyI9KiN0U14djA/zdSXpQ6wFO1e7X2vyNQy8DOX5ur48EgGMNN66yuuBWS6xux9KSw31S07OHSEQ87amy+AwimaSqFBJgvawPZz1t8ccc52FJkuQTicScxyuJR7sJ4DsLdCEy0llJip92nP35HWrY5r+As2UQ66B4bCDfv1xlT02ImFBrkj/Mm8Ht+gg4Y2u1PliChO9kE0qIsuKisGgALxR6OZKrmcWxbEhE3ha5IvN8hsvVFA62+TLHjFbb3xaPcpAM5PO9VoAFbbojh/vr15y5HmdtAhRAhxNCa4fsA
 m/Y8JUzH
 DMbtoC3DP/ykGlPJs2U9QXWBTVyHAS6Ky9n8BsSPC8CPTA7XoWTG2Nm6j+8psKtgMf8FxS1SlEgmAuUM4qM6IYDHvYaWegVThJryJIL4xKlNU41IeK65uvKG2jZRg0OoZYKjJr94D2BimTO+D7VTgLj8C37a18FE52zF/Z93PP7j0SJkWjFFytG+Kh+pAmtGKuD50jX7nXiiyeizzQUs3JLwbZUXak42gGeWXPIQHMT2jGCWfxzPij0GzZ4/AQVwh7IMC+Gj/7seEnvWfg4WteOuKCppqVJJpjKCLKYrRX1pt/BsvYxGQjen8sWXnDYVrTS8viAM+ra1tAGiDT1EOnl2V5xhatXj8O49+wLzbL5RW0M3XhxhmPLrxJiv2SU2xgMoBQYT5S458GAGlAKWteSEuH2iU7tlmp6q8cTAihJLfsQGUEvfCpPS8ABkEuAI3KaTx+wDyRl79i9h7Jd1z8V2+n5KAVHrPFyf0AEmNlgW7YAjH7QJ8LlFczeS1tgVaXeiqqSm0iv1t+Bu4bVP7vpOjKBTyBNX/gijLtekVdmcgMBbL0DiderI6Ofd/+iUkWd3X3iEbaU2M9z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 9:10 PM, David Hildenbrand (Arm) wrote:
> On 4/28/26 17:50, Shivank Garg wrote:
>> Add folios_mc_copy() which walks list of src and dst folios in lockstep,
>> and copies folio content via folio_mc_copy(). folios_cnt parameter is
>> unused here, but is part of the offload_copy callback signature used by
>> later patches in the series.
>>
>> Split unmapped folios into batch-eligible (unmap_batch/dst_batch) and
>> standard (unmap_single/dst_single) lists, gated by the
>> migrate_offload_enabled which is off by default. So, when no offload
>> driver is active, the branch is never taken and everything goes
>> through the standard path.
>>
>> After TLB flush, batch copy the eligible folios via folios_mc_copy()
>> and pass already_copied=true into migrate_folios_move() so
>> __migrate_folio() skips the per-folio copy.
>>
>> On batch copy failure, already_copied flag stays false and each folio
>> fall back to individual copy.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  include/linux/mm.h |  2 ++
>>  mm/migrate.c       | 61 +++++++++++++++++++++++++++++++++++-----------
>>  mm/util.c          | 30 +++++++++++++++++++++++
>>  3 files changed, 79 insertions(+), 14 deletions(-)
> 
> [...]
> 
>>  
>> +DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>> +
>>  static const struct movable_operations *offline_movable_ops;
>>  static const struct movable_operations *zsmalloc_movable_ops;
>>  
>> @@ -1724,6 +1727,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>>  	return nr_failed;
>>  }
>>  
>> +/* movable_ops folios have their own migrate path */
>> +static bool folio_supports_batch_copy(struct folio *folio)
>> +{
>> +	return likely(!page_has_movable_ops(&folio->page));
>> +}
> 
> As these things are not actually folios (and callers will have to be taught to
> distinguish them way, way earlier), I guess you should make this
> 
> /* movable_ops pages have a separate migration path */
> static bool page_supports_batch_copy(struct page *page)
> ...

I'll change this.

> 
>> +
>>  static void migrate_folios_move(struct list_head *src_folios,
>>  		struct list_head *dst_folios,
>>  		free_folio_t put_new_folio, unsigned long private,
>> @@ -1752,7 +1761,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>>  		/*
>>  		 * The rules are:
>>  		 *	0: folio will be freed
>> -		 *	-EAGAIN: stay on the unmap_folios list
>> +		 *	-EAGAIN: stay on the src_folios list
>>  		 *	Other errno: put on ret_folios list
>>  		 */
>>  		switch (rc) {
> 
> 
> [...]
> 
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -778,6 +778,36 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
>>  }
>>  EXPORT_SYMBOL(folio_mc_copy);
>>  
>> +/**
>> + * folios_mc_copy - Copy the contents of list of folios.
>> + * @dst_list: destination folio list.
>> + * @src_list: source folio list.
>> + * @folios_cnt: unused here, present for callback signature compatibility.
>> + *
>> + * Walks list of src and dst folios in lockstep and copies folio
>> + * content via folio_mc_copy(). The caller must ensure both lists have
>> + * the same number of entries. This may sleep.
> 
> This *function*
> 

Will add function.

>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
>> +		unsigned int __always_unused folios_cnt)
>> +{
>> +	struct folio *src, *dst;
>> +	int ret;
>> +
>> +	dst = list_first_entry(dst_list, struct folio, lru);
>> +	list_for_each_entry(src, src_list, lru) {
>> +		ret = folio_mc_copy(dst, src);
>> +		if (ret)
>> +			return ret;
>> +		dst = list_next_entry(dst, lru);
>> +	}
> 
> Wouldn't it be cleaner to remember "already copied" immediately after we ...
> performed the copy? (succeeded with folio_mc_copy)

IIUC, you mean something like:
	list_for_each_entry(src, src_list, lru) {
		ret = folio_mc_copy(dst, src);
		if (ret)
			return ret;
		dst->migrate_info |= FOLIO_CONTENT_COPIED;
		dst = list_next_entry(dst, lru);
	}

This will be cleaner. However, it will make the folios_mc_copy() specific for
page migration and can't be reused by other potential callers.
And offload driver (like DCBM) must set the already copied marker
themselves for successful copies.
This will have an upside that on partial-success (even a single failed copy),
it will no longer forces re-copy of the whole batch.
If that's the intention, I'll move this to migrate.c itself.

Thanks,
Shivank

