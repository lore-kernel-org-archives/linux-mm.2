Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F54D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 05:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CC56B010E; Mon, 19 Jan 2026 00:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35716B010D; Mon, 19 Jan 2026 00:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1AB6B010E; Mon, 19 Jan 2026 00:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6E176B010B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:51:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5838E13B6C2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:51:03 +0000 (UTC)
X-FDA: 84347640006.30.DE39A73
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id ADA4D20005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:50:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KqMIg+DP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768801860; a=rsa-sha256;
	cv=pass;
	b=8n0GOqYjTnBnd8q0NSQ2mb+6I/pfDrAXY+qQPsKdbnRH2rFP7aaefMHM7BNhEuCtM7ybO9
	lL2eEyhV4WSbzDwifsUTT8XJ6dXhCPSkx8bP9QscmqfQRwi9dcyFtAnYDNMckwM4RulHsb
	pUMG216+p8yUnB8PIOirhR3KK2AxGqE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=KqMIg+DP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768801860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmxrkpossN0nLR9O0Nnkq0/qOsLazKYax6afd0XuEUc=;
	b=0sU9A03zmsGX3yvb3pBw5/YsoIQPDInSAO3Dl4wpGHpo019ip/hIFI9vRwirKifqwAiR6S
	8/U1z3/TGCIAwr97SsF66/zyCh8GAM/5GmBS18gNu4ynEWO+PjbM9IDIAAuIeY1mQpvMi8
	TBS44ttJ4/0CpFNZTW23byGFIPpW3Rw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zATjNSu3bbGBdAlwHvZGEhReA8ncW0qck/yFVGgAeEWKSQHUbHz32ztxbulY+9UL47RnibS4R19vdcRkV33Hn+DBAAplOsPjOvoP3d1YAN9vI/vXTUiGiTx8SWHCdrj6MB4etKZn+iwxGIplbFh/aA+G9255ECBTwglQEMN1qqg4Njww70ANBnDCHLcakFtkY13RBJdcY0NLXVwxxlRuEVqUX6xMfNDcBmctRS+hKmKx53D9O5UOHprlOjbN1XPGCscAr9k2JFL1O6F4KKaem3T3Y62IEfcoMv23upoLqorg/it1THh4p0Yi7uipIiJhXKt5K8/8DyA+D3NBYhvDYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmxrkpossN0nLR9O0Nnkq0/qOsLazKYax6afd0XuEUc=;
 b=mRryy8I0k2F84SYJKPHU0FM4LXkt7Cog3B4bPh+Np1EFJ+lsIFDgqhxX6f8+CKMPACVPio93y5BlGp5J6LR9GXKkmaU9exBB9TntgFzcdhyEfhXkK/ESMWG3OLA9AMzgglDgltAKmR+DVd/WF9zBDzCWjwVTvxw38m1rm9KirvwH+OMHqusMJpTEZt4+RStkZYzIkBXOSTmmhuuuJWPyJX50HRyBh446de9NQBJzodxn6KIC402nXTTyOj4IyJdYeFneURNVjWFq3RMFe8vz7HKNlsT0olsHCo5uSyiALYZ1OQZ95U6PziMdWNULl9nFM+/pshNkOmkEYOkoBFRTYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmxrkpossN0nLR9O0Nnkq0/qOsLazKYax6afd0XuEUc=;
 b=KqMIg+DPX5euwLyUW5XRYmTbmosCMZjQ+TSpnkUCjH3jsw9Xp7jIEKvsxh81t5G7FC/8yVntZovbFC2L2mI3lEDHVa2aR9wgzX5hwmSXW6OLrF5qIdXbKo25Nj+S3rXLVRYXQk4ICitaJoznyQvL60MqGCHG848k2YoGByCEdU0=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by PH7PR12MB9125.namprd12.prod.outlook.com (2603:10b6:510:2f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Mon, 19 Jan
 2026 05:50:56 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 05:50:56 +0000
Message-ID: <2a0c7109-a142-4c0f-925c-c821616ffd8e@amd.com>
Date: Mon, 19 Jan 2026 11:20:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 0/5] mm/khugepaged: cleanups and scan limit fix
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118123442.f55db3e141388836df0c7785@linux-foundation.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260118123442.f55db3e141388836df0c7785@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::22) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|PH7PR12MB9125:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d2b87d3-dc09-499d-4a17-08de571eb6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWNyY0FvRU5BUTNqcnd4dVBCYlJ0ajVQQlo3U1lzNWw5UDJKVnJCckZ0Smtn?=
 =?utf-8?B?OVFyN1pOdjlTQmt6QytaQVBmdnZaczRneURNTmZpNW90cXhGd29rUDFQWlMx?=
 =?utf-8?B?aktTeEZPTlJIeGhyTExtanZvTUd4ZHZHSUxJa1dJWGNtMncyakVidWVKZHYx?=
 =?utf-8?B?SWcwOElVMnFYMkZtcE9mYWhONjVXZDFHdzlrQVBoK2RXMWdmYnIzZFBmL0c4?=
 =?utf-8?B?NVBoa2RMb0VVOFEyRzI1SkhyK3BzeFh5MTM3Tkc3azY4SkZvci8yZHJuQ0kw?=
 =?utf-8?B?YW9Qd3ZHdXZBNlo0Tm4yOW5SVnBOeGFKbEF2c0pBd0R3QWZpRDBxYkJrbUEr?=
 =?utf-8?B?cEs3cE1VSmlIdks4Tk1ab0o3VVhLdDBvV2Jnc281SWh0VXpJVnJVeFJ1Wm1K?=
 =?utf-8?B?S2lXbS80c1hTWU5Kc3cxenN5THBuQ0h2ZHhKL2hZMUprZnFOMkVJWFk1SjF0?=
 =?utf-8?B?ekRvd1lzVFlDc2UxZnJqeUUvNzBCQU03V3N3RnQ5WnNBdEhnd3NoZzdBOWFW?=
 =?utf-8?B?bWNDd0JNT2MvYzBaQzQ5YmdxbldRa1lyazliczd1UjFVT0ZUZTZoNHdhOFBU?=
 =?utf-8?B?STEyN01VM0dleVAwL3NpcVNpc3dYdnJXQzBpNzhHVExhVEVxRE1KR3RBR0Zq?=
 =?utf-8?B?VVg0Z1RmbEdwOHE4R3RSVFJ1djU0dEdDVWNoeWkySmV2bG92bnRiK2tiQjRr?=
 =?utf-8?B?MnpxWEl3b0N2M3RGdXI4Z0FZQnUxVFNMS3BEbEtibUNGNVBTSkU0d2dWdzVS?=
 =?utf-8?B?ckl4cHJ3VlFCRlFyK0U2SUxBeDNqTTIvaGFIQXptOW9zQ0RjMko1TnE5VFlO?=
 =?utf-8?B?YmE5UzdoaS9nM3lzRzBzR01oYW82QXFiMUZ0di9pZUhCSEk3VHFEUmZteFhV?=
 =?utf-8?B?STl2OGpYN3JsNmE2N0RZanZGZ0JIaU1jVmU1L1czR21YMFBjRmc0VmdBVjMz?=
 =?utf-8?B?NGl5L3FtbENUMHVOWVVxMzd5SzZTNlpFYzZUUHk4L2l1UE4xYzFvN1JqS0RZ?=
 =?utf-8?B?UWdNYnpLRUw4RkhWNzRaRVlUd0JUTEdCNm15WE9rQXl0eFF6RzFvSEw1azR0?=
 =?utf-8?B?NHlHSFVPb0ZMRUJFZzhaRjJxVFRsZlp3M1JhYU83MUg1UzVRUk5vcEZ6YVJv?=
 =?utf-8?B?MFA3d1Z1eFRsY3Q1OGdoWWZXSmpqcmYyRFYvUFJCc1h4Sm1xc1lBSVVNNFN4?=
 =?utf-8?B?MGtOQWtiREJuSjBjS1RuWGZ6bldiWDFvL0xENVY4dzJUV2k3Y20wdVMzS2hu?=
 =?utf-8?B?OGtPNFByMksvZThESXY3UmtES0tGb2pMaUlORTNTTFFwWFZtTTBXTXR6VXpH?=
 =?utf-8?B?Y05leW91YkV6cWxXL1dFTXhYUTRVK041VmhWWFllRldBcys1WUowejNZdnVy?=
 =?utf-8?B?aFdmcnZnaWFpcFAxN1QxSUdzODNWTFlqdDkxZncwakZHNTRCQTFCVkdhRUJF?=
 =?utf-8?B?RnE2Q0tJbDg3am1sV2ZRcDNuT0taTDJad2VYd2Q3alVqWnVVenpERnpDVGxq?=
 =?utf-8?B?UW16T0Z3VHJtYnVxOUJLam5QdHFERGdJR1pYdmtPUFNBZUcwTnhTYzd0eUhO?=
 =?utf-8?B?ZmxrOHlVNDVDM0hiUXQ0NzF3clIzYjNvRlExaExWaVg4Uk9WeFlRb25tazcw?=
 =?utf-8?B?SXMzZUVPeCtZRUJTT0FraytzWjdGcDBBV1FyaGI2cDFtdjRhL2Q2SU0ydTA4?=
 =?utf-8?B?Wk1rNUJKS0UzNGtJOWE3elc3WmRlV0FSMldkQVkzdXYxRDRTWUhyWDEyQmlw?=
 =?utf-8?B?UU9jUlN4NjExWElRWTJOdnRyVXhtYkQ0UkNwV3kzZFA0aHlvZUhTTVBFK2pm?=
 =?utf-8?B?VVZlNFUrU2lISmhudkFibVBma0d5eENPWXFkM2VaWFpTeERpWUVDTzdFMW1T?=
 =?utf-8?B?T3JIR0d5WmhVSjZia3R6SzgyaHJmekhReTB2emJYRjdtMTlRUmZGZEs5NjVY?=
 =?utf-8?B?cThxblRHWS9wNXdWd3ljWDNBUlpjUnMxd3lobHkwTDRYRE1RUFVzcFh3cEly?=
 =?utf-8?B?WjVkKzQ5MU85Y1pTOHNQOVBEN3JaSHplT3NpalYrcWMzN1NvdmZYa2xDVFBT?=
 =?utf-8?B?VExZSzVaQzlqY2lrQlBCWlZnWjFiR0F4VTlVRjdBMS9KTTZxQWtQWlhPSnc4?=
 =?utf-8?Q?FMao=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cm4vN3J4VGFqUmhaMjJ2NXVpK3JJK0htY2g4WkxWUSs0ZW16aE1nUlhNOW1H?=
 =?utf-8?B?YjBRTk50a2M3eit2SUFRbG5YVFJRZUhFWVVyL29meHI1NVpKc2o4ejhUT3lV?=
 =?utf-8?B?R005N2JvRXJXOU5QU0piYzYzeDN5aHJXQmh2dnVhNjBVVGVvODZVa1N6eUFY?=
 =?utf-8?B?MEJINFFXQVYvSnErWWI3a0NsWEhKeTdja2M3cTNWZldiV2VFWHJTc1haRXEv?=
 =?utf-8?B?eGZPNFBFVXZ4TTQ2ZnNMeGR3LzJZTU96TmhDZ0xpdDFNNjdTWksxMHUzYlBt?=
 =?utf-8?B?RDFRM04zblpMQmFTeDh4cGNCcVBoMnBIZ1lCRE5rNTQxRTEvT1hlVTFCRWRP?=
 =?utf-8?B?b2tZaHZJNU83V1E5ZUlPMVFQclR5U2RnQnFpRlFGT2VjM2ZkM2w2elJXaGdK?=
 =?utf-8?B?VGVyQUZFTU5KNENtWmU1VmxKTGZIMjNvdllKeWxlTW16bjMzOWJwNmtLSnoy?=
 =?utf-8?B?TzBZV290OVgvM2ZoRlFWbFRWSmprdi9QdHk4NlQzR1NNUWI3S1RiSW04UHJY?=
 =?utf-8?B?RS84YzloYXdrRFZBT0prU2w2b2F5UnJsbFkyTTlqcW5DNUlXVUVma3pKRWVV?=
 =?utf-8?B?V1UxS2pEcS9Wc3hyaWNpZ1JIUTloZGhmL2NNR1I1S21hZzRHTEpEbkRJRlNC?=
 =?utf-8?B?d0paZStwelI4WjdYYVlTTWVNT0Z0aEtFYlVhdkVtK3U4ZTQ2RUdKU3YvUkFT?=
 =?utf-8?B?WkZObFFVUWp6Ny9PbjVFeWF0cUo2Zkk1TEVWQnJvMlgxM1d1emRrRW1Qb1U2?=
 =?utf-8?B?U09wSFJCWFZ1TnUydUlRZEZWckRKYkxSWkdldDliOXRNbitEdG02YkFEUGZ3?=
 =?utf-8?B?bmY3NlQ1dHE1RGQ5UCtHTmQxUGU2SmNyeVRCdnJJSFFLMW0yM0c5ckZFUmRo?=
 =?utf-8?B?S3QxU1lVa1ZtdkRxWVJrNkhIN2Z4N3pxSDRJUVo0elFKVk5FY242UnNmc3ZD?=
 =?utf-8?B?dE1NQ04wbFRkSjI2ZVRXVWF2bERDc1RPcWZSTFNTN3MwQmMyMDRhb2dkNUVy?=
 =?utf-8?B?dE1OTE5nV0NOWG5ubGd0VzdPOFM3S0ZPU2d1ZVFSRzEyWkg1WFpib2tJd3lv?=
 =?utf-8?B?VmVSMkJKTXhxOWoybnhwU0lDcXdMaHlFR0NQclp3SHVRbmtCQXI4UDEyQmNY?=
 =?utf-8?B?QWlISHJ5U0w0RFhDQXNwcFBFUXVmdFhTQkYrZjk1eHo1eVBkOTgwM3hYRmt0?=
 =?utf-8?B?Qjd3THdCOHBwTStsendVVVpPNit6RlQyZGhqd2VPbHZtQmFJdjVNWUNjMXV2?=
 =?utf-8?B?OHVsaTlFNXdVdXRCd21PNnBXVmZzVXFOT0E4RVhOeXdQOHVBNi9NUjZWbXhW?=
 =?utf-8?B?NUZ4d0hBRk92VmNPdTk1d25FaXg5K2FTZDZ0SUh4dk15WW1Cc1N1L0h0cERV?=
 =?utf-8?B?RGE1WW5PTnk2TUVqNU9HMnUreEV1Z3hqL2d4ZjlJTW40czhmM0JqYW5VeGhO?=
 =?utf-8?B?NDd0eVFoSndIV2NPa0xWM1dHMHIwRFpjUHI4eWtDMHZrTklSVXRucEc1U0pY?=
 =?utf-8?B?dzVmelRzdjhJRmZuVnFTcjZIbCszK2M2Zm5zelNmbzFyaS9QK0VLT0NkSm9n?=
 =?utf-8?B?RkJ6NlRoRXFjUFd3cG5hNjZ0cmdIQktXZHFWOXZsWGl1ODZSaVlNQlNEV2ZS?=
 =?utf-8?B?T01tVFE3Y3VRdUNLbmJOOWhwMEhJSzRWNkJyZHhlYnpvVk9CczMvbTFTR2Zs?=
 =?utf-8?B?TEtJTEUwYjR6c2RsSnhCVmkwamRVOGdMazhSMkpsWlovcXlQczM4aVZyL3pp?=
 =?utf-8?B?Rk1abEZBdGJVUW5uV2lqM1F2dVZuY0JOMjZ5d09SdUNaNkVqRCtFRHZxc3F0?=
 =?utf-8?B?RTl3NkRScEI1TEJTS3EzRXhsT3EvOEJZRG51VXlGTkdzeDZzOTVmbnJvRDFx?=
 =?utf-8?B?VDcvZWdrQlg3bkFPUFhlUE0wdG9hSTNUU0NIbnd4MU1TbXN4Z1pScGE0Ykty?=
 =?utf-8?B?bzVjKzVJSlRyUDRySEFoVFZhMWMrUU9KRG1WVHZwVlZKRTNYNkk4R0RqeURX?=
 =?utf-8?B?Sm1abDU0OUs2dEVNQktaOVBLSW9IQ3JkWDI2LzNuSUVBeDIxVlJjRS9QZGRz?=
 =?utf-8?B?enBuTE5xcU96RHplU0ZXaEtoZzlUTWx5UjN4RU5aWklUc3dhT3FEbmR4ek5H?=
 =?utf-8?B?dGluRG1TUDJaWFZaK1RMQ3NXOWFVd2Z3aUg3Y3pSRGVTd0VYUnhvcTE5ZE5Y?=
 =?utf-8?B?aFRISzF0bEhQUHhOMWxEUGRiMVRlb3NxOHlqWVVEekozVUpNc0FMZ0M3VjZE?=
 =?utf-8?B?K0tJVERIWVI4ZTkyNGRaV1liRTFZdlNWd0huSm9zQ3JTWkMycCszU043Mm1s?=
 =?utf-8?B?Q2RDb2tUcXhobTY5clhJY1hUaDFxV3h6cXNPZmFPdWxGdnhhMWo2dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2b87d3-dc09-499d-4a17-08de571eb6d9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 05:50:56.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jnnb+77IUvJ74YuwEAes+NXLHOrfktrN5vd9/ACrznihuk1RdTRz6S9AfUB3YranmhC0tXH3MVv+zwHZlVQMZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9125
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADA4D20005
X-Stat-Signature: np86ynxxhnmuimzik54di8dj6s6j6fz3
X-Rspam-User: 
X-HE-Tag: 1768801859-372374
X-HE-Meta: U2FsdGVkX18KQ0EY9R/AykoVJrstpxLCRb4R5pZUNp5ViJCZZxxGeCNvxPZZxmPTY2I8qqvrYXNMHm14ddM9EB5hJbtJneQjKkEgUUaspA4pNpT2onmCI8YEcbawN8eZFr7B3RfPFoh9fSGrSqdRJuR7mU59dpW5D7ht23KE8BBOS0KQdODdI67VxuXZKUGLhJo5uyc2gAnt9d4g04tmLpemXE9glrXGiQBmR68wU+vMCRt+K+OFwtmdo2zj1+rNlMoQaEtOZ4AVhiq9xFF74vk1UBrlQ5uoYnFpfK5pI6Nr++eRyFRKIfIr3pYvzdz5mjZN68m/G4pusQIs782zg+rj6eHJ57aTettBbhNrpiJk8QAKWLym8I0/5u4JkVr51C1j7uxj/Bjw+tItc5WBF/PazkR8nWggy0rnEdA+hL+Pyymp1cMgAxv01ouNqoUgVIinDxfxiTF4IKQdUfUpLK95FgRe0H1CaQeizEwcyjgSOpcC1z7pyiu5Be+u8/sUPWgDu8akEiMEBCP//SV3QcwgpKoPjHnUWVCu3reDLu7xCLJs8dmju31zZseHZW8BpkMVrl83zUXCY0IstiuDkXnwqJi4fnBt4I2i/rc4KRkLeL+WtY+2n2QyrpSXOyRVrcy7/vM2+ou3mKiZeasGZibi1/uIERXTxtCrry4lDkTteO+XLOPwRFCh0w3xj9QEQV5+1QyEY3rASAztAFqQsqOJgOHghogxZh+l4v4tsFAA89hbem33r5EwhOtkF3fAE2d7nVUksc3im5+xzewj0iexrMbkeq1pw1qKOwsVRKl3+Ssg1RFXSOi4mcUwECKL2+JyhsFBPPc1ic1evSKXGu5lCuoztKMT0z6kGKGmnpxA+32fm74rc9pn04U8c+faxO7C/57sgSoaZefkEVK4uYwJT5WHYdmv4BaBELoC/avN9yaxyUu6ofddKTdS+uP5DwLQbHFcoY2WsfBgvqj
 XeMgcWm/
 iQrfQjLNEGoe1n3M3TwA4FZEyj/FiYM31RYBKH9ts25m1u9HHdVKmF6QuF/AbbbElVlqBbIjLX/3DiZJzq0EsIgUmSsQaRg8KihWDH4od5UpaKCCFYA7TsfIUrztRKV5HyNZ3pWQZIx7byWUgz115n8FtO60ELKfXBovaENhQpfBZLsjzlIGsUgWlwdhlr1naLX78qmCaHoHhyXmLhNS6CT0VXquVMnC4dlkR8aoJtNqr5qE8/+A93Io+xoCaao/UXCnwrOcGAxHl+gJm8Tvxto9PSvPJOgiNNilvG+OHQ3IaB679wsEFHT86iL70DZ2ovvWMz9wQa4T4z4doS/Or5D8iRRD0FJHxXM8LDEYTui+zS+gNwodHEgfcAU62sbxuPTF2dSGcu22HOamU5f6/c9PKZU9rqFQ44ZwI1p4BjmPEzVVrzhbp60yZBCXXOLI/u1eC6Bc/karqw+tN2nzceM+ePQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/19/2026 2:04 AM, Andrew Morton wrote:
> On Sun, 18 Jan 2026 19:22:51 +0000 Shivank Garg <shivankg@amd.com> wrote:
> 
>> This series contains several cleanups for mm/khugepaged.c to improve code
>> readability and type safety, and one functional fix to ensure
>> khugepaged_scan_mm_slot() correctly accounts for small VMAs towards
>> scan limit.
>>
> 
> That's a lot of changes to a well-reviewed 24 day old patchset.
> 

Sincere apologies for the last minute churn.

>>
>> v3:
>> - Fold mm-khugepaged-count-small-vmas-towards-scan-limit-fix: add comment (Lance)
>> - Remove extern and use two tabs indent (David) 
> 
> Are you sure?  The v2->v3 diff is large.  A lot of (unchangelogged)
> alterations from `int' to `enum scan_result'.
> 
> It all looks pretty simple/straightforward to me but again, can
> reviewers please check this over fairly soonly, thanks.
> 

The diff appears large because it somehow did not capture V2 Patch 4/5.

The correct V3 vs V2 diff changes: 

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index 37b992b22bba..d7a9053ff4fe 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
-extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				    bool install_pmd);
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -43,7 +43,7 @@ static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
-					   unsigned long addr, bool install_pmd)
+		unsigned long addr, bool install_pmd)
 {
 }
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..fba6aea5bea6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -538,10 +538,8 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 }
 
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
-						     unsigned long start_addr,
-						     pte_t *pte,
-						     struct collapse_control *cc,
-						     struct list_head *compound_pagelist)
+		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
+		struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
@@ -900,8 +898,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
  */
 
 static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-						bool expect_anon, struct vm_area_struct **vmap,
-						struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -954,8 +951,7 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 }
 
 static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
-						unsigned long address,
-						pmd_t **pmd)
+		unsigned long address, pmd_t **pmd)
 {
 	*pmd = mm_find_pmd(mm, address);
 	if (!*pmd)
@@ -965,8 +961,7 @@ static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 }
 
 static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
-					      unsigned long address,
-					      pmd_t *pmd)
+		unsigned long address, pmd_t *pmd)
 {
 	pmd_t *new_pmd;
 	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
@@ -986,9 +981,8 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
 static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
-						    struct vm_area_struct *vma,
-						    unsigned long start_addr, pmd_t *pmd,
-						    int referenced)
+		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
+		int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
@@ -1063,7 +1057,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 }
 
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-					   struct collapse_control *cc)
+		struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
@@ -1091,8 +1085,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 }
 
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
-					   int referenced, int unmapped,
-					   struct collapse_control *cc)
+		int referenced, int unmapped, struct collapse_control *cc)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
@@ -1247,9 +1240,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 }
 
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-						struct vm_area_struct *vma,
-						unsigned long start_addr, bool *mmap_locked,
-						struct collapse_control *cc)
+		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1442,7 +1434,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 
 /* folio must be locked, and mmap_lock must be held */
 static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-				     pmd_t *pmdp, struct folio *folio, struct page *page)
+		pmd_t *pmdp, struct folio *folio, struct page *page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
@@ -1478,7 +1470,7 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 }
 
 static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-						    bool install_pmd)
+		bool install_pmd)
 {
 	enum scan_result result = SCAN_FAIL;
 	int nr_mapped_ptes = 0;
@@ -1713,7 +1705,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
  * as pmd-mapped. Possibly install a huge PMD mapping the THP.
  */
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-			     bool install_pmd)
+		bool install_pmd)
 {
 	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
 }
@@ -1864,8 +1856,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  *    + unlock and free huge page;
  */
 static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
-				      struct file *file, pgoff_t start,
-				      struct collapse_control *cc)
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
@@ -2296,8 +2287,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 }
 
 static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-						 struct file *file, pgoff_t start,
-						 struct collapse_control *cc)
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;

