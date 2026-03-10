Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1220FEA8550
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A936B0088; Tue, 10 Mar 2026 06:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B46C6B0089; Tue, 10 Mar 2026 06:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE766B008A; Tue, 10 Mar 2026 06:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 150CF6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:08:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B33585970C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:08:08 +0000 (UTC)
X-FDA: 84529727856.07.4F6B21A
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010064.outbound.protection.outlook.com [40.93.198.64])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC7C540010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:08:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Rr8/G6Ia";
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773137285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zl/JdBdNLtbzGiP6lzmwQNrIiUG3GqEbTd38qdAPNG8=;
	b=pL03VQDrsqe2X2Xa0HhLURPPsZjlSXohQ2mrxCWnxZVnP3CFJw/0NB+QZx3GC1i8PLEejp
	D0S5qbpFcS2N5Ss8mMIrL97NC1q6cFBDueGeznMcxhC2G0ZkG0+Nmq5Tdp8+882woLnZaY
	W29dNO42/0JER1DVetsenn6xwdXu87Y=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Rr8/G6Ia";
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773137285; a=rsa-sha256;
	cv=pass;
	b=LuEa6RIWx6+gqZaV0tDRMy1hvZFV+Oj5YUgZ7SXTHIkxmiAGoAkKNnxfg1Cr+ATRM6T+SB
	T8udnn/82Il9OvY0lmy9R49kIcSuLFEXtjT8rb/PGd1GIvNbOh2Aw/Ncwz3I60UN5ao4/B
	27mJGr+46oJAg4YKZIPgloohIZLe0d4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lySp2pQ8L1/dCjpmMg6DHYSRY9GY++nlOBXrQaxD6xj0Bxluu+W2ItuV61mHwu66qeFGM6UJ0hrCRxbsCscRTOApxh4Rwcd/dFiTR6HvKPId0aCMnz/Y1oj5zoJKMvJvsBDNwELca3hIdghvcBXlEu/1JpborvN9qJ77MiaigZAJfT2Rs82k2DlhkM/QK4ggH5tP4Vht+2v69yLVhFPquGrL7cmm8MApg4TPX5zv+TfWX+QEziMDRaoU8eL5kl6918s2ZN/JlAdPe0ZnfZkRTGGS5Q78B09pbcGcUr7mBV3IAvRwg3H6FBr+fHsKn9qD3RywhCn1C348T9kAYEXuOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zl/JdBdNLtbzGiP6lzmwQNrIiUG3GqEbTd38qdAPNG8=;
 b=fUZpjMvDXDSV7zWxcXPXe8N+Uqs1yA6vfPhUghj3tnPlwyVkvfmY2Z6z5mRTSaNCz9kP2mchMG57JXmY+xJy/H3avmHR0c62m0u/8Wq2GXqZhj56HUZ5VfJwn8NAaFjwnzU6BQeLCfFE3m6NFsBxNzodfIogxNC6Gt7yrRDMtmeLL1mNi8gzCEAB63L7QZmYYEupxHwWqN7wvK9nkZi7Rw668ecJmBsQx8U+dRhpoVGiEJ2hhgbhbO1sPovKujIbqh11igcwcvgf8qTSTA3aKIl3gjw/LodKPrP3GxhDE8fojc2eMT3Gqu6aoYr6XLoQXjn7Dy8GmWWQmVXH0Ox64Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zl/JdBdNLtbzGiP6lzmwQNrIiUG3GqEbTd38qdAPNG8=;
 b=Rr8/G6IaJA3tnsiy9lC6WqrhK16q0QyHPIbSiUlM4kL1g/TkVoVhYNtbv6tlb5IyV5iYodf+q2RNE+H+951a3ysx52H/naTkCe5QW/4pu/zWX2f4WwLw1J1odmiMyVc0SJ216lk7KRKet8yWDbiDoJXvdVQT5bHYgbbLm+HZG5c=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MN0PR12MB6176.namprd12.prod.outlook.com (2603:10b6:208:3c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 10:08:01 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 10:08:01 +0000
Message-ID: <84643d33-66bd-43b7-b3b0-cb6401a134e5@amd.com>
Date: Tue, 10 Mar 2026 15:37:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Day <michael.day@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-12-shivankg@amd.com>
 <aa8JTMda9oafjzcf@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <aa8JTMda9oafjzcf@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5PR01CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:261::14) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|MN0PR12MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a9071cd-170c-4e75-fc4e-08de7e8ce958
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	QpmEH2UtVno7cYIvDNpy2rwBVhPOA4GukEdkORyEjHMnnl0Z6U8nPjvSZ7ZrGzxnENScUWj/w9mEDoCuF37GxMn86BjSPFLmy6qfBxQicwWsPsosxtG5IK5F/76RA565QVBdgRvzKHSHClnYuuoyC86sXSr+oPdSVEuxlBpjeA/MwX04YLnB/3fLKRgWD6ppEu/zjTj52bd1CZ1axqsVJNg1rqhYAGfMnmZuPDis7RmzJkAFQc52l2sBVzb+eYTWZiH1JB798pmsaReddZQgPKcHQe5H5Yf2vV2FhLb5iR6FueNF1MPDyt4LJRplZQlZr+JINe3UUUcyUFqHyu4hIx2uQxy+xkG1NSrweoBdU7SKyvtH+uBHQ5iZ53/2e9XpKwTOpO8O7RurQcAwxNDF/lHyyaiwC3sEkreeJnhTUTi5y4v+quk0Uaml3nnD7FT02RF64sKfW1LhrUAXe3J/lcxtLSZ71B8CNZ69bjAiIent8+qN61zxRZ8kga8G0as3WD3wkJmRFNkWlqi02mMF0J37kt44P8Bh3hkF3tHcRlNfmafoeUl3ZXaPxjmBS4y5dINqxHke3bwSXKacZ1u3TN4KUdCtmNX8EM21B1lJPbqOOn0x9beq61vvuo9XlckC4l1FzLfgGRP/PSvSlC2NwgRMy1EgtcEVeg/IKKN8ls55/FYh4ktF5mYSvYG7YewR0DCIcCqqBOX0AJsbt145SG3W75dCQrDPyLNapbVzS7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dk12d3I4Z2dXMUNoM1VvdHFIS0JCQWJMWlREL2lQK0ZXZGk4VEViVk1Ib08z?=
 =?utf-8?B?bzdlSGNvTVAyVXhMTUpVZW9sNlQ2L2ZzVjU0azBGdThaODhZcWhjT25VRjYv?=
 =?utf-8?B?cXdJdUUzWG1WZ3IvdUhQaGZjTFBtbHFFL3RaQ3ZNRGZBTXB1Z0VmaGpTZVpt?=
 =?utf-8?B?Mk9JMXZmTmRldmtNUFhROVllMi93L1kyaitwVU9NOVVXdWxOWExiUTFvYXNQ?=
 =?utf-8?B?Q3FJaWNVTWozNE5lUExiWmJKaE1zK3RxUGtjVmYzYVhVMFNOODJIVzBQeXdB?=
 =?utf-8?B?VUFXbFRMcUFNVmxqTDFjQzZ5OTRWclVHQXAxWGhST21QMEYxWHRHTTRVRFQ2?=
 =?utf-8?B?N0N2UTY3VURUYXBVLzNsWnp6OEJLK3ZCV3c0ZTQvZHFxTlphUXJCR1IrMnhw?=
 =?utf-8?B?S0h6ZTZxTUhNQlhtWkRXbDdFa3hRZ093QVFESU1tN2pkd1R6a0ZpT3RYOGEv?=
 =?utf-8?B?SkNvZjVueSs0YXZhV1dSSi9KeUJVS3RxajMyYjVUVUdIbG1zK1NCMFJmVHNR?=
 =?utf-8?B?VW8zbzF4Tk1pN25McnhYcklmOFFYb1ZxZmZNZHNuUmFlMk5OWE9Zb1JDY25V?=
 =?utf-8?B?M2tPaHBsOTZqdE1rZnRxd0xZSjN0cUdBSjdRNlZZdWhWTFBQaXNjQUN2cFlB?=
 =?utf-8?B?TGl2S1RIcms0NytrbFdCZ0RSeTZ1UFhvay9waW8zdDB2aUJsRWRTSzlJVjJY?=
 =?utf-8?B?TjRYcEN6TER0UllLanl5UVJ3Z202dDkxV0JlOW5ob0JxWElickRaR202QlVB?=
 =?utf-8?B?dFdyRGZjc05yQWRBMlZIQUJ1aWZRRStlU1cvaTJCNzlhWVFCZUpFb0pnVWow?=
 =?utf-8?B?d1RyNFRFMHBTTjdzRnFrdDA3Skoweklld25OK0tyeWNiVzBOQ3dXRkhLNUZn?=
 =?utf-8?B?NTZMZTloVjhuUGVTUnViUHNMQjJMVk1xQmhBOWdDQkhsbjcwN1F1dHR5M0hW?=
 =?utf-8?B?QnU5WU1SaWdudGFwQkJrSHFSSnNhZnU4UEdqVmk2K3h3MUVGN3QzR05HRVRn?=
 =?utf-8?B?U3hySXp6YTlpQStXQ1BXMys5UGg5OWZjakRWaHp2RW9RU3dPRW9janJtZFFx?=
 =?utf-8?B?YWZvWWFlUEY2MzJoK2FuR0F3MVJjQndobFh4SGpHV1JnaHFyVnJqVE51bHh1?=
 =?utf-8?B?L2IwZFJOVUl5b3BlWHhKMHZYL3V3Wm1DKzFLNHRzQUJYMk53WFVRUWVTUjZW?=
 =?utf-8?B?QnJ5R0VqTjFkN0RweElnNy9CUXJxOTd4bnFNVm5pRHc5NkRpZlpwVlFkZ0lB?=
 =?utf-8?B?VGxtNHRQRHp6dGJBTE83Y1EyY3h3cVdwVlpVYU8rK1VPeEVsZ1EyL1NuM3pm?=
 =?utf-8?B?K3VWdGR2dlNoWm1yOXo2a2hQVklKc2NYbUdFdTZTVmtSYXZGeWtUc0VsbHNQ?=
 =?utf-8?B?YXFTOUxsam1wZXhvUDdmamtSYStUKzB1bWxscEZjY0cyQXhiQjczV1gxQ083?=
 =?utf-8?B?c1hLTUN3RE1FalY4N3ZGSzhPY0Vmd2tpY3VTak1lcktodGVGVml5SWJUcUgw?=
 =?utf-8?B?TEpqVmRwbmFMTzRQRENPZlNub3RTaWZJUjhMTXNxekRMN1lPS1pqcUZQVXI5?=
 =?utf-8?B?UXhyWXBEWmM0M2c4T01QbW9nQW1MdzlEN2xKbWZvOVFaZmtTVFJtY0MrV0hu?=
 =?utf-8?B?TnJYNFgxaFExbWpka0V4SVhMaGEzZERzeGRCeUljc0tzaWcrMzQ4Tndmd0xL?=
 =?utf-8?B?NDI2UEpyTWNoS2k5QjNuMEFCQUE0SE8wejd3MUpuS1BUVGlKeEJlSDM0ZDBo?=
 =?utf-8?B?RVczdU9JK1ZuWDRkOTFIMnFTRUpQSmxWbk5CT0lUMWp4TG9BZnY2eE10YkZz?=
 =?utf-8?B?YVNmdDg2NWxGTlI1dE5zQUh6SnFnaFdYWGFkVUo4OWlBeTk2eCtsa2pPR3lw?=
 =?utf-8?B?ZFVyd2p5ZCtkMjQ4S3EyM2VMa2pJNVZudUVxQVFnQmdJUCtrS016aEdDR3A1?=
 =?utf-8?B?NEl2elBnR01IdGlaN1l3MzZYWGxVdUJ1SlI4YmxyenpwbUNPQ2g3UnFyZUd3?=
 =?utf-8?B?RWF1ZHFBaVhnY3phMlhyZUtqSVJmbERxclVxUHJtemRHeGc5YUlueE1OYi9t?=
 =?utf-8?B?bmh5WGIxRytrUWI2SUdGK1draGtuUlpMWVV2VVpyVHNMMVZ2Y2kremxjODNj?=
 =?utf-8?B?eHU3bzVWSXp2NG9va2xqTmhPY0xrNC9BMlp4V0IrbFVPSGlyZ0RHaHRaalA0?=
 =?utf-8?B?WkFHaW1xTWZnSzU4WUxQcEQwclI1aXZEL3p5THRJTXhQajNTZU12YUZVYmNu?=
 =?utf-8?B?ODhWNDRwd2Q1Um1POGhMVmxyUnJFbGVuWUtmZW94VEpRUFhEOFFGT0NSZFcr?=
 =?utf-8?B?QXM2Z1Y0Q0dUbGY4cklFUGVWRGhXWktEMVRNQlRFdXBWcmdLVnpSdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9071cd-170c-4e75-fc4e-08de7e8ce958
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 10:08:01.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAVbteiOb9SQ+zH40GSrvYYwe/EK8IgifKCWeShCiEJC3Fe2hASgp57p5Rmc3FzY+4XRevzS2kV7EhCPKXZ0LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6176
X-Rspamd-Queue-Id: BC7C540010
X-Stat-Signature: z5jtjzzf14p4yqih66ichpcww3b1snec
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773137285-4382
X-HE-Meta: U2FsdGVkX19RAGlCkDXW9uvTvnIUMea7XDl8ZlLq9jYiE+U3oEOU/Dx7/16C6YyoYhZUgKk9DrwSkB7xowgMR7V7q6NNdDqiJZd2h8JeuZrfAHNnhkEi8jD2D0MS61xGPs43Tb8lW7fd+gXLs4jE2H7DxcZLoDgen1tsMT2dfrE90yWetnvX9dwjrXJCeOLxSPtbk3oWKprckvdQfPnjIVGvSuatwj0/ktgACHtIAENEXZ/A1RjaQSxvWoARS1n3fHqIslWnbrpBAmy7Njg3hTsD44wiE8n3/7OrgkS8GoEC69KN701W+PBnTv6xdC+o2CZnSyx2MWXlGht/WrkrvdkzmtsE1tXEVIA+bRkSn+IC2M+J09e4pL3X/S5+GriPoEvJstv6HPzinxYXX9gChn7XyjZyEigxSIPQ6Lx/tDHTenXnnWJlg5QdP5s1ADm5UL/cFCbLCwh9xUaLqc8S2ITNAvwwe9fdU/EdCrz+MLJto6dGTdX41A3dMrCPae0vcquo3xU4NbkPOZgR5JiviBKhxUW3d7D4UBI3HKR4k7BMii3mSztOODaXdH6oWN/rROvrC0ZdhAvHk7fqhe8b2ZB7JY16UW4/2XtKfhp8dtFsHz4rVJwk6+0h/hFOC1KAeZRLaH2HoskGfNP8Az4EyxmZc7CtDarR5PVbr0rUwI16zLoO7WHiqDY4APUK0bxpO3LEWBmPv1Y6VfETrqC2o37+Ykedmti1NRePXvWgMLYM0+2p85/7Jx0Zci3UDixDzkn6kt0uPgBHoskd+lftngoPqIoIcxRo2XA1zw12P8eN0Uaiq0HJWwMgzNMQPFHD8iIEIC4YktBLJrjHm6U7FiHNz5xEwDREOMYp/lCVLgFoYP8v+8lM/dCA9JldLiObZUNv+/x90DkbiC+199LrC7lqh1eUFWnX1R0oqrB/PoTUZWccC/ZfO+Zpw2fMFWOItqHVgwqvxfZ6uq+uopH
 ZlzoWQ7U
 mG3AWNVjUwxzkU2hHW+gE6U6UCCSk3tHAll5mTtsgZIdZtY8rZD0FV7JRd2qXPKE61aZOSkaIjCnoY4xHcapuHZy++eB1LNi08bKCqwcokNsLea5lIZzO8ZNN8Bv6C9Az7mJex8MaeOhYcmwsS7F/Leoya5Xu1HJ/+Xpom1LE2rO2rK86MB+YHr+PYdsf78QMKSVzqsUgqxUT5fPEpXkyPPfW2tDVW72EO15l2vHLYmsfxOhpDRIMJTA9KF8yqnAIbj+mMo3i+6rQrXX2O1oWm0hQmV/Y/T1oVOFc+SIy9Ss6jUGwWHhrHi5LbyN43FjJGLZm/+PzJaoyxLCbmkAhSxnisZq3ZNHwUOpVNHLOHWwIQHRcTJXT225iOfNIDlDBsY2JupSRWKxDqG4QLOmewGN4Elr1WDmxJCDptvsxlwj6LN0mlfQL22l15CVoDSMFet9YN08PCTZ/73B+X5+AXr5V+vD6ZsxTAech
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/9/2026 11:24 PM, Gregory Price wrote:
> On Mon, Mar 09, 2026 at 12:07:29PM +0000, Shivank Garg wrote:
> ... snip ... 
>>
>> Only one migrator can be active a time. A second registration returns
>> -EBUSY, and only the active migrator can stop itself. The static_call
>> dispatch is under SRCU so synchronize_srcu() in stop path guarantees
>> no in-flight copy before the module reference is dropped.
>>
> ... snip ...
> 
>> @@ -1820,11 +1833,18 @@ static int migrate_pages_batch(struct list_head *from,
>>  
>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>> +	/* Check if the offload driver wants to batch for this reason */
>> +	if (static_branch_unlikely(&migrate_offload_enabled))
>> +		do_batch = static_call(migrate_should_batch)(reason);
>> +#endif
>> +
> 
> should the migrate_should_batch call also be done under srcu?
> 
> In theory it's an incredibly small window, but there is a race window.

Yes, right.
thanks for pointing this out. 

Best regards,
Shivank

