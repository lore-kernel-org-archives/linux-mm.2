Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873F7CFA459
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 00:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C4A6B0006; Thu, 20 Nov 2025 19:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415836B000E; Thu, 20 Nov 2025 19:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD456B0010; Thu, 20 Nov 2025 19:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 169A46B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:16:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0F91140425
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:16:40 +0000 (UTC)
X-FDA: 84132698160.18.00115E5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id D9D50A0003
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:16:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ow6io0tK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.201.41 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763684198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2vwd1yw4iqvAu3CiROfsYZfFAeO1t0jkl7sT50nxDM=;
	b=2Gc+h9/wh49hVwbMzp05y7PWoEVp5XnxpPVlJY14i6nBcv4sFdCBcRWhTf3dch+2/MJ0c3
	MRcpQG8OOu32BVfz/Y/eyRVvNyeUhoy8ARxIHhSe3JSGmHePH8fkDtybDXiLrukN9zDj50
	QmlAtLYnW9UOD3EB6ozqGvxbokMLxQU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ow6io0tK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.201.41 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763684198; a=rsa-sha256;
	cv=pass;
	b=tCivp7lDDFoc8WxxOa8wJ54MyZwZft0yGb/u6JIVygexvNII/zbmf8JnDBJZ9T4ITgbxC/
	owLkXaPVpW7TsAeyOuN5+/vYtGEDajAuaPHuE4Iyj+tWHLmBhGrfDSOGyFJnFo7i57/9x2
	vJz+KZdIMnNA+LCZdOpoNNsqa8iYorw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qfnGVNpNE1PAp7HAniyO3PX0xjvzvYi/ZNE4srbcUvGlaWDHwWGcTwjja/zht19iZNVHlEC6wxjViUJjVRbMq35clTtmxby4AdYFPv4mf0d1/2+t75O4OtXDu2fSdx7jq9bJ1NEwAlTSuSOi2kbDoOrq4qxJa68bSG+qQgSmmgS5iiyZ5l8QKdvu+qY+zCG9NG/ZV5RTHjw7S1whB8jxCkWIbPrHCN1nmnr49c+7X+JjLAYTpYI7Ey7ml4JjwVEYfM9llna2wGK5W12YbOSIjQ4F32ZuM7hwxCS+FH3KQ5BNvE0ibJMzXzm2mDm1VEAm7Z/RAWdd6uiRbanC4vDwBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2vwd1yw4iqvAu3CiROfsYZfFAeO1t0jkl7sT50nxDM=;
 b=CO4aNMvj/gVDi1cTpPVDhBDjMeU6V2+qJoYMrZUGtr63NEz0Uxrz/v71nbfc09ti7HIMkeHKwQXJ1Cw7lo175I8uUYhBZa5xFjbE45g6zkitSmFDQkdVrcnp6k4XXfWuD3x1qgqdCnTfqP8GUgJYMQ8iRnR03Zm3XE6BdC46p5GCUhlF9xF8rio6eOY6FE8zeRfPv4NXLWAy8nvON86tR/js+LirbQFg3NFOtVRl6aWOC7TEm1duEGsPSMTZqZa+Xz2+JisgnmPFj732r6ELHrGbsOIP1TMmt9SfBVC3oaTGmL+WoQ1XGOsy4zEWtfx08haN8oMbbz8Se7Y11JwIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2vwd1yw4iqvAu3CiROfsYZfFAeO1t0jkl7sT50nxDM=;
 b=Ow6io0tKi+gFsIIyogUFzGmmrS8bjNA/NlcUl7HOFc59a8xADfCFqbnrodinkTPhBsp1e9Jo4RIz/VEcYWZSvFH/aPk1rb/j0DZLoNtIv8JSaOc0ecADyy2oJCpRQ165rnu45AGfQwO9D35kGiM2XVfVUEZ8ePaFTWrSTC3vIJG1OCGDL67YosE/ah6OVutLlMr2ROLixQfz09Ho56ab3DdtAJOpQCgjhsvI9Wh3PdjTyfqfaxzTTbWxXs8EkuiKxW2O1Ftuywg2BjF8WpzpMaq2GOH+yd5nYQzPxZDU/4n3wGE54kvwdN6/04lnuqrRUS31qrU66/64CZRtSBwwpA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 DS2PR12MB9613.namprd12.prod.outlook.com (2603:10b6:8:276::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Fri, 21 Nov 2025 00:16:32 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9343.009; Fri, 21 Nov 2025
 00:16:32 +0000
Message-ID: <021c87cf-03d4-4871-b752-2f2afabf113b@nvidia.com>
Date: Thu, 20 Nov 2025 16:16:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: fix build error
To: Peng Li <peng8420.li@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: david@redhat.com, osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251118155034.273696-1-peng8420.li@gmail.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251118155034.273696-1-peng8420.li@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::12) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|DS2PR12MB9613:EE_
X-MS-Office365-Filtering-Correlation-Id: d0b27ce8-a1d2-4d67-a788-08de28933950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3FTSmxRYmJPbm1BZ3FDdG00MVJBay8xanpEM01QQ3RiNDM2MXFuVzdXanZN?=
 =?utf-8?B?aDc0Q2RrcS9hczFqUTR3cXgvQjlwdjRVV3F1cyt1UC94YzdmQzVPYm4wL2pt?=
 =?utf-8?B?amF2bW9tZ1VESmwyV2pCVmN0VUtDYVlXd0UwU3pIZnl2SW1lR2JpZDk0MUNs?=
 =?utf-8?B?ZXJsa1Z0QXVZTHN1UzVKYVluM3prWjlmTXcyM2ZNbWhGQlM4N3hkWSs1eHds?=
 =?utf-8?B?K1ZpVS9ud0ZsMDEvR3d2dWFob2JPWm1KbmtvaVptVlRkTmpIaXpBdHRMOWhv?=
 =?utf-8?B?emVXSW1kSGNEU20rRlNnZndqM1RPUWhYOXNxVnZSbXhIWmJzUzFYbjQ2cFR1?=
 =?utf-8?B?QlgxWFNGbHhCeDJBZGlKY2tReWNQeGpkOEpkdlFzODM5clBiNXpkU1lzcWN2?=
 =?utf-8?B?c2ZKd2czUndrMW1XRXlCVk5CZXgzYmVhN1FBNDJ6amhubm45ckRaN01SWjNy?=
 =?utf-8?B?bDBKT0VBUnpGZ2JUWnhHaTFjSGx3ZWc5RnlwOUR1ZDBTL2VQZEMvaWplSllp?=
 =?utf-8?B?elZyYU5wOTNVSk95ejNIbWJUMmNmSU00SEVWMi9kQ1BSRlloaFBhWGxDcit2?=
 =?utf-8?B?azByVUprQnUrSzZDRExjYk8zTkllb0pxaEgxaXUxMXhQczlwbGVKNmhySHB1?=
 =?utf-8?B?SkI1QTJRaThuR3UrTzFDTGl3cVA4WUdsSGEvUDU2c3JlYXlFMlh6UGlZZnlu?=
 =?utf-8?B?TjVsazVlejA2NFVkTys0eHh2bjQyY2IxZ3kydkRhbVVRcGhNeFhwVkU2a2hO?=
 =?utf-8?B?N2VGd3FEQ3NZUmJmbEhaTTQ2MkJxRGl5aS9qSnFmb3A3UDhhNkpnc2ZWd0Jt?=
 =?utf-8?B?ZHVnVTNuckFEOFZDcEI1RWwzNi9kTW9OZTBTVnJqb0NaT3BqZXVmME1JTmxU?=
 =?utf-8?B?YVhlNCszWGNMbnB3cDlSUDFzcnJXcFRzZm9jYUpTbCtzb2RCY3B4dDZWNzdW?=
 =?utf-8?B?MzY4aWJzbGM2ZGxMSVc4Y1phSkVyZGQ0bHV3c0puakxXcXExVisvMzdXNWlw?=
 =?utf-8?B?UmFWVnRLZWo5ZGkzV1h0bm9hL3plbmNNNUlsblFVRmFTN2Rib25vRUVGWlVu?=
 =?utf-8?B?YVFrc2NRRXhCODdKdFRxMkRFOXp0OXhKSEtmQUp1VUdUdUs3M2IrTStjY0ph?=
 =?utf-8?B?eFdMcFA4QytuNi8wM1VEQUZFS3VjVlR6Z1pIMnN5UXoxcDBIMWpEK3I3VS9J?=
 =?utf-8?B?SERaM2dMU2I2ZTFsMDhKQWI3S2xkcm8ycjJWdHdzU2lGSDdxN3IvQnVEWCtD?=
 =?utf-8?B?MGR0bFNjRnUyOUVHNytMdVpMQXRRNWJOWkp1WU1hL2U4ZS8wc3YzU0Jxb0RU?=
 =?utf-8?B?R3V6RzA1enJ5bE5STnhPNnM4NkNRSU00OVlxMHczbHhybjB4cmxlM0VUdHhI?=
 =?utf-8?B?cTR0OXFqaDQxMThNT0JHWmpMMFFoS0ZzenN3ZEVKbnJLZUJ2dVQ2dHU1WldT?=
 =?utf-8?B?RTgxS1BteE81MEpLci9uTnFhNG1JR1JLaEpkRjFVMm0vazZRMERoTDFYbXZJ?=
 =?utf-8?B?NnA2MzVTdWt6NWM4ZDhFdXFSTFhtQm1YK1E2QUxoNVlXTzRjQXlQSUJYN3pZ?=
 =?utf-8?B?UWRFZGtha0p6VndIbWg1dmlaMGtycW9ic284bWxXRlZKS3NqZDE5cnlUcGdB?=
 =?utf-8?B?UDVaU204ZHYwL2FlVklXeXdmZjVKdmdXRVc4K2lhZVN5cTBmemM0UVFxeGR0?=
 =?utf-8?B?Ymtqem1CWis0SFRtWVZXUTdtT01QbUpIeTlURXdoSmp2MUxjM3crRmFNa3ZD?=
 =?utf-8?B?RyttTzk2R3hUVzZjU1hBdGNMTHB4dVVmaWdBRzRWN094em8zdTN0TjVDblZQ?=
 =?utf-8?B?VTE5aU5taElYNWxwRGtZNGxyL0hEUkZwaEJBclYyeGNWT0dFN2RmUUlRTFRI?=
 =?utf-8?B?TmczUjlRdDNQNWtvMlQrZXNMc3JsK0JHYjdLRUEraTBFMEd3TFNQd3RiVUFO?=
 =?utf-8?Q?dov4hy0IyVVkY2iP/Y5yCK2hd7pvT8Rx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVZPZ3QxSTRzRzJCeFZkZWc3QXVtdlRlaGhLbnljUkY5ZjBiakh4elNmS2g5?=
 =?utf-8?B?WmVBRUJjenF6aXFlRCtwcjhyK044SnZFNGlKb0dySGtsU3hseGQvR2pIREg0?=
 =?utf-8?B?UzgzN3oydzZWMmJ3b2NFV0RIbnd4bDduVHVsTWtBOUQyd2JzcTU4VUFhUkNT?=
 =?utf-8?B?VXFPVDVzamJRVXJraG96dkhUeld0c1ZBRzA1eVBSN0kwTCtBditGSGVXd3k2?=
 =?utf-8?B?OGE5S1Jrb0pqbWJkS0NYemhqdlZQeHZJVGZXWTArd3BlNDJrTks2alBLS3RZ?=
 =?utf-8?B?Vi9PZ2hHSjh4ajZDU0RnSWVYRXBtbm15R0NrREVadHRVanR1TnlMUk5uWk14?=
 =?utf-8?B?TlZQRkpMRWVwY1dyblJRMHllTUtIdnozUTNZLzAvbTk3L0RodWpqYW9sem16?=
 =?utf-8?B?U3kySFV3a3RUMFF5eDE1RXpJaXFoNjRHU3BjYlk3dVZDSVNHN2lFZEhDejFJ?=
 =?utf-8?B?aGxRWi84eDFmYWdoZ1V6dFlrT1kyam1SejUrUHltL09XZlRqSWhzZk8rVjdE?=
 =?utf-8?B?NGtvT3ZrdVJORkpveTdlaUJXQ2VNQ0QvOGViNWU1VW5CUDVKT05SeE1Wdmw0?=
 =?utf-8?B?c0hxMDk1RTZycjdhMjZodkQ0amNHZGRLZUR2TVB6ZVRNZFBMQXdDUHdPaGlB?=
 =?utf-8?B?ZWp5QTVpWjhHUFJpY2dJcDd5bFMzZHh1QWFib3JRZkF4Umd1cE5YQTkzWWdn?=
 =?utf-8?B?S3RBODBnbDlGMm85NEtjQXN2WE43WnpSQUsvYXFSUzlUVzlDZVlmYlpYbzZP?=
 =?utf-8?B?RzBqNkVCRk1FY1lqSWxuOTlDK2FVTnRPVkFSVDI5VVFZUUhoa05tT0pFTVNV?=
 =?utf-8?B?NnNrbE0vWVpkRkJDTXNxTDNuajhpK2U4QlUyYkNueXBhTjFEVWcxaytUQ1FD?=
 =?utf-8?B?YkVHRFMzUk1FMzhPdTNnZTh5WlVqdzFLQ205MkYrWkttUjFQSVh3MHMvYmE2?=
 =?utf-8?B?b2lpNjNmSXlNU3NNYWs2T1c2UTc1SmJqckphM1hMdThtWC82TGc0cjNsZDJt?=
 =?utf-8?B?VnlKV25UZ1NXa0Y4ODBZM0xSS1BpL2dOWDJtMHBHM0tFQmZSQ0w4MEJhZjFO?=
 =?utf-8?B?K0RpdjFOcEVHdFNFUnpJVHFtbWFkR29yVkZXbmR2RVNpampvc21GbEpiK3FW?=
 =?utf-8?B?Wi90aENHNWwyWkU3bVZTWDVETW5KYnFnUzF5R1ZFZUplRnJWUlExbWxHbVVt?=
 =?utf-8?B?NW53dUc4T1FqRmpxVGhVTEsydWI3eHRVNi9SdXlEZlpMbzUwMUNFc05wT01F?=
 =?utf-8?B?NUlPaE1LTXpoQmswajNpQzhiT2ZwZUNxdDV4c0ZsRDR1WEw0V1lpOXhYOVoz?=
 =?utf-8?B?M204TmQ1RTJhNzlvNkxhTFdUQm42TUNTVGwwSjcxTTQrUUJVK2szRHFnSWRk?=
 =?utf-8?B?VDhuTFErYWRVa2hNMVhiQndvTDFVWktEazZlVzZaaGZZeC9LZDFZbEJ4dUdS?=
 =?utf-8?B?ejUzTnF3QVlvMW9JT0MyT3kxSGxpdXBNWmZ0aWo4dm00UFp3N0k1T0M0TzRw?=
 =?utf-8?B?YzFqcm5lcHc5SmlyUUN2M0FUOU5tRk5abkh2UnpXTUZlVDgrSDBkRWk1WkFG?=
 =?utf-8?B?NFJndEswNkVnaDB3Q1Q0VXVCU2FiSTJHYjhvSEhRODdxZjJSbDc3Z2UvZWpS?=
 =?utf-8?B?OGtqN2EwUkhUeDZ5TmZZNDJrVU4ySVJQR3MxR2JUeER2UU1vZ0lFU3VERWRF?=
 =?utf-8?B?aDFUWWg4aHhtKzNoeUhwWmhJRHJjRjNJSi8xakhqdUlheFdWMUU5VUpFdlNS?=
 =?utf-8?B?aVY1T0JXRGFXd05Ta3ozZkhmWmdGWW9aN0hOU1hocEE1aGFoc2didmhCbi9i?=
 =?utf-8?B?bHRZYnc2ckVoeE10ei8wazF1VGp6UUExdzdpODhHL3ZCdzVUbDVkZlJIaTZ3?=
 =?utf-8?B?WDE5bUMrblpaUzVVUlVyVlFObkszRGRvTGVCZGgvbE1sSEwxQzRtUkVBY0VT?=
 =?utf-8?B?ZjZ4ellLWjU1cy9PV1V0NTFEVHFMT25ETmFpRis0NGMrSkhQMWlHdi9Ycjl2?=
 =?utf-8?B?cDNBcHZSRUE1aVNTclA1SDNPeHJqK2VJQzV2c3ZJMk9OSnVxbWZwVlcwdjVn?=
 =?utf-8?B?TWFMWlVwVzJCYU0waGoyUXF2ditPNVpaNFVvdUlKN2M4ekFMMHQ4QytnYU5Q?=
 =?utf-8?Q?WQ26VBzvuxilsthLBrjOP0Swp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b27ce8-a1d2-4d67-a788-08de28933950
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 00:16:32.1927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9zCJNUR/MAfeWyg6jCgVqBw6S5Wm3qmCVT0WXtVobQ8w/umWeSro4KDHjWgQ4RBRgswiMm7VIaNdXh4ei32jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9613
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9D50A0003
X-Stat-Signature: 5ixif3kc1zhbjgddtit6mcrpanyabmre
X-Rspam-User: 
X-HE-Tag: 1763684197-977811
X-HE-Meta: U2FsdGVkX1+SR/c8bwD8V+dAOsgoejnRjafZiCzPVDBCeEWBiQwCglzZu3KGvRQ1syZgLBpK+KQjh1bEbSf7CzEIYeEb9o/fc9VZFBXF876AtXclAjfmmzS4LqY9NFdfHFSUdET3i00xPjENeK4GCQXVDKCYHQO9HjTwyDUFmNSs63hOzkSZYjtmV///GozivZeqP9AnrMraCbYQKJIFnEcDXTenpoa3xbhBrAbXGzUDmpRUEIwzuwhgiUBJDTV2i972ltPYm031m828U4ai0pz40Y81A7eBKpRNHqGOAlCQTX06Q905PO2OvOFSL0sV2cMS9ySWlktpLfHxz5H5TJf0XNSvuIApU+aQGVlJk7/gBnzgHrEzJv1R8w3L7rcE6gJXEkqyekS7jySOXFv1GLRh1+WUQkNYUM5KsP1kBspnBaanVkIfiaFpL8c2xMA3MRCh8v/d4DxZgdruNW1uracRe5moiC+EPZVWHzbG5Mq2bZw2hEKlXUJO+GZ/9gbroOaFPJ9vHq+uKZIMiCyV79uWlXAN0npdv1ESMzErsPmAxlrESKQFkrLoewPM9TVAq94Kh9UBXiyVpkDKYRYPYDwwfDc9w09zZYJZivAM9rSO3mn6w3f0m5+3cvufc+BGA849ol38DUoqDNtLykRIxJ31Ry0G32MIMqjsgHBEQ8/2IVlPeYKZfQMI0go40Hb8ZtAhHcXzLx6+evXif/svJFyeq04pddEIzTh3iv+ZHTdep9ZHfn0wRWysBymdwjTbde/bQIS9gCXTAt9pPRDGoQlkxROZ5Wnmso2P9eZwk5LjuFSRfc/ynqAOxz7dhiHAYRGyg6S0qhygOpqf7mehE99MupK+IsLJBZ4K+kds6z2GDliWz81F8CyTn9ZcpNSFxsPwoFcvbrfdZ6mELtq8L/WfzefKLFZ6u2bmqC0FTtx4KCldfF0+PX7/bUQT3TOGsRp9FskuFAnsE+RNuWa
 G2AcrBsH
 nYwqr/SbQE89LqItEeRXmSasksf/6aHgjGoGYZk5NMEWZi/n/i4FBCQZCQ1ZhLbrthq3bDxcwL68XW/3OshyRIZAO3Q56sveHA/RnReqj1yJ5ZEPKMGG0p/myX+TSdVMswr1eP2kMsvUGhzGuamUazx7QvPp7KYXUSW3M9qcyv1MK1uKNKaVhuOBu9LfC/qn4SRt8xclua23mDYeeSqYoXLyBDUjaxfs6XYPnEJ9MmWGzsfwDjKNgb+kJCc9fVpLtdJPLGFPLz9t7c9XIpl8GEo5BtCqPBhef0AHhIR63R+hv6HhzJWFMm/c77xWpYqvfwVS7SdlI/8vSLHqmWJoT+/JD+WIOzzOSCyZp7OulWJvFIlexi+2JBSnhDDmbz4g4iIxO36GJSXfg1ntEXRkJg2bOY339QVD2ini8ebF+hVo4SXooRoHEpMtyA0lZUu9UwmaLB4ZKqrBrZrVIcaWNWmeIiTbcCwxsoza6Oq3er6hsI3Thg1c5slyYVW515Yi4+8wQ0Ii2CD17FbXJnHqLYli++2aWhLrPKzGTaaUTFUHcDyB9cLtC057KsuD7yAvDbbN6MaWEpMLCH1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/18/25 7:50 AM, Peng Li wrote:
> From: Peng Li <peng8420.li@gmail.com>
> 
> commit 056b93566a35 ("mm/vmalloc: warn only once when vmalloc
> detect invalid gfp flags") modify the function call from WARN to WARN_ONCE.
> 
> WARN_ONCE input parameter format error, missing ',' tag.
> Resulting in the following compilation errors:
> 
> mm/vmalloc.c:3940:19: error: expected ‘)’ before ‘invalid_mask’
>  3940 |                   invalid_mask, &invalid_mask, flags, &flags);
> 
> After adding the "," tag, the compilation passed.
> 
> Signed-off-by: Peng Li <peng8420.li@gmail.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d78c4d09d6ea..0469ba2c230e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3936,7 +3936,7 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>  	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
>  
>  	flags &= GFP_VMALLOC_SUPPORTED;
> -	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
> +	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
>  		  invalid_mask, &invalid_mask, flags, &flags);
>  	return flags;
>  }



