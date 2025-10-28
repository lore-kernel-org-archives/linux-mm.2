Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD24CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A251A80132; Tue, 28 Oct 2025 05:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D58F80131; Tue, 28 Oct 2025 05:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875EE80132; Tue, 28 Oct 2025 05:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71AF080131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:24:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F39CB8B46
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:24:26 +0000 (UTC)
X-FDA: 84046987332.27.D9B8532
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011003.outbound.protection.outlook.com [40.107.208.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id 517B3A0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:24:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U6liwPNt;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZLw6x4j6lQCb7UfuzYnJ9ANN5vNykeYj7TuVN4S01k=;
	b=5FWUSNO8HdOtO9wzF9hPzrGkCHOczpABVR6JRTfWMJRlHCNw+sz4aGK1KYTxYM060wKyHH
	fr07VOqrXJUcmAO9P44z+hQ6FWUtazJEDj8VbpWwxO8t8CYBlbZmydElePeuHxQP12Xqjq
	7CadjVtLJxITEUar6dAtLveazRSEIwM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U6liwPNt;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.3 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761643463; a=rsa-sha256;
	cv=pass;
	b=JUO0fzjw2kZoOK1gPCUYQ6/ihmyvwML5Ibqc5GesDSVdTXm58tGZTGohOwwtttRlPcKZL5
	8ObSt3QxQGgdjws0CU3md0SAFcfUxZvBvk7aNIjRA0SEx4K+p1yBc/7I2DRreegL/zyz8X
	CGJ1NQQ6iq+wjFk8QXmYbq9/K4UcwY4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLOxsYbnoQ3jJ0s/iTlBMPW639LTnFkz2Y0GjUxD//flC3yojs9AoVd0NObsVwkgjIy/rBvJxmIfGset1sL9APH5Zq3tkzRW1NcZYZm3rhBh+qUPmY/q7S4GW6aOmKFeRH20e6F6FfEnQqbIeNZG63Ftr/aUFU+iNIewJ752bM98cI/Fq0H67rKZzVgnceJ+aNSw9OIrt+miAZIGH4awmOkSrIwLV4XYrJpyTnTpGLrOSVOIh4/wb3Vn7+Ofhna+nMESZhvoUoT/MHgvOt+bS7O43j/rTRgcR8IiTjJXCR9UAfG+t5Ntuv65wUr0a07KEN3ZyS2tQV8FSlbgawkrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZLw6x4j6lQCb7UfuzYnJ9ANN5vNykeYj7TuVN4S01k=;
 b=JbYupypextD0hE+k5DU9Z3Rk6wt3qo2cuMcmNK14WnZNQImlZpg0/ZPphpSvUUt5iir2eLhfGrB25buXg5wM21+JUiy18ZkNBxXtG9a8U9qMXs2w9q79NgKzjCIAFVu/Zt8fDRcE4giH2Y8Ctdmyg6E3jxEiXSsRkVCemlacQwc22inpY/KIFFs7Ay0/BsJ9j0LlacbeknlcWDmmMOyZhTHeCDQTnThgY7saD1JUXZKRh7ihxx9a96sNboD3NvVpkTmEOX5UvR+OL5j6ouWC/b0ZESjlT9lApMjCMVlpRqyVV0sOToSxSsyDcaquWurnbpAURAUdhvm6xX0EgodNvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZLw6x4j6lQCb7UfuzYnJ9ANN5vNykeYj7TuVN4S01k=;
 b=U6liwPNtsFj1F0gvMaw2U74/BiWbRLVghCQSm0AMfKzwBbV30Q28GKLQyX8jW2jZyX51AcMK09u5Ln34Pnt6q6MTvO+yb25fXihTuFOyyWNlXu58++2rOao3lxSyICUuvYaYv5Tdgw4c5XgVMbCIz/CYlcoVPbg7Rd84CLtLrE2ysZh2T/7BzWhTEWI4/VcX8LA4OMAIRwvwcP9PY05xCUIu84h43N6h7a9/N5+5fEn3FNqV0VqtoAnF8gvtpUQDXcZuWIC7JCUcl7nkC1NeY5CGpla4eA3aw81kIrV7aBRuIB44zo/Ki4nC9qWU9Ad6HlwiEPkvrfe4FInV4/eVyw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 09:24:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 09:24:17 +0000
Message-ID: <0e38a555-b7dc-4e5c-b0d9-ab3b447dd460@nvidia.com>
Date: Tue, 28 Oct 2025 20:24:07 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
 <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
 <84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
 <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
 <f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
 <748cdc18-e32d-41bd-90d1-a102b1c51e06@redhat.com>
 <20251027174726.5d8fcce7@p-imbrenda>
 <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0051.namprd08.prod.outlook.com
 (2603:10b6:a03:117::28) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: dad75d08-fabc-403d-3b07-08de1603c46e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnAxbXdFRUxYc0xuTE5nbDdEdG56bUNDWU9DT0xDRHJycmVpeVdabWhTUXVP?=
 =?utf-8?B?UEZUWlZGUjJBajY1M2V6aEhGcDZVZGRhUDAyTDk4Wk9YaXpuMW4xQXZldlFW?=
 =?utf-8?B?eUV2RGR6OXZTczBYMnBFZGx0UHYwSWNrWUM1U0tLdXE2ZlpSOVhmOS9FOER5?=
 =?utf-8?B?ekhvRjJ6R29SNkpIYWtmYWo0Unk5ckFZV25CVjJvYUhNc3FOcHNhdzZ5Mlcy?=
 =?utf-8?B?Lzh4Zmk0NnR6ejBjNGYyWHo4cXN6aktSaGpyZGtVVDlYL0ZBR2UydHFtQjE2?=
 =?utf-8?B?bnpaZTQvSnRGeXBYdjJLSjhLWGIwYXhuYlk3SHVNaW1iOTNYRFVHZHZiZW1Q?=
 =?utf-8?B?bGRQQitZeW15Z2QrcHhIRWZJYnc5eVZRaDl2ZXd4bFdlVm9VRHRpd2FSL3p1?=
 =?utf-8?B?V2JLb3lrd21LSm5FREVBK2ZGNW9oc2xYRlNjZjlrNlRPMnFTaythdWhDR3pV?=
 =?utf-8?B?WTlJRG1iMEZZOGdjaER0UGdjYmVFbDJRNVhmTkIwZE9jOVZXcU5RYUluMitW?=
 =?utf-8?B?WUxhcWd1SXVGbDhyQUtGaWdzU1RsdVlMTGsvWE1sWkdmM3lEZFhRUmxkYk94?=
 =?utf-8?B?dGVPQXFjYWVvUW5HNmlhRWtJMDdtNnlWOFVKNmJrUUcvREJaRk9JejlETnNQ?=
 =?utf-8?B?R0VGVU5jTnkxMm1iMWE1bkJOYTFGL0pFcDhJNjdxclp0RXFiTFU4WEVJcDdU?=
 =?utf-8?B?YVgxMUQ4ZEk2Z0VjbFQrRmVEQ1VkUHZrNHl5bHN2MzNyMHFGV2tuQ0JqVzRR?=
 =?utf-8?B?TmFsMWpkcDJDdjkwTUNnOFJPNE5JbDBINHBlZXlYb09uTGhoZTNtYjlSMExB?=
 =?utf-8?B?YTJVTmNLK3hyQkhvN1ZLVjhkb2oyc0s3YUZLSG9LeWdna0ExU2d1cG9BT0JK?=
 =?utf-8?B?V1RxTXhySnpxcm1sTlE5VHhFYldzUDhwck1zbm92N3NFY1lVd05nZTZGbVlD?=
 =?utf-8?B?cWNDbmNSYTBlZ1NaR1hCeE1mL1ovODc1SEtuaFpCSjgvYlVKaU5ockpHcDhV?=
 =?utf-8?B?ZTh5S2RjdkVBM0ZmOW16VTV4QnFiVUp0bEpUMGc1Mkt3cnZSa0UzTGpOT01X?=
 =?utf-8?B?cXBaZHlsdW1GcS92TFlMa1JsczBmdVpPRlZEbC9wSnJUK01PTjZXMnFYK01K?=
 =?utf-8?B?NGRDSTRiRng0T3dRdEJMeTZxZFYrUlFTSlpVdHF5SlZvTU13SE8vTXYvKzR0?=
 =?utf-8?B?bVNFb3k0MjFNSDUyOEphSU82QXZyOFBFTkc2R3g0WWFLQVcyVlllMVUvREpT?=
 =?utf-8?B?U016ZkdCMm1sVTNINTBqK0ZRUXo4UENETEpIWjBEcXhUeXRqcDdSUEZ5NUlQ?=
 =?utf-8?B?SjNFMlpBaUc4N2JNYTlzQ251ZU5GRkdaOVhvOTdQRWdSNDdMRHlZeTRGVjVy?=
 =?utf-8?B?TTNBbUU1R3dRRG81M3dCQ0x3K1NMd0hBY1pLSHZvQ3hHN2JqQ1hpN0RRWlFQ?=
 =?utf-8?B?NmU2TWJJa0ZMZENqMmRXRTlUT0tkRkdEYUpMWjN5ZlBZQ2xYWTdHejA5YndJ?=
 =?utf-8?B?Umd2SEF5MFJkYnZaMVFHUG1EK3pyRzBydUM5b0FQYjJCaTA3U29hMS8xOTB5?=
 =?utf-8?B?L0t0RjYxOE53RStqaGRET1phaWk3T2ZUS1RZYUlzSkpqL2FFZkhBbi9xYlhr?=
 =?utf-8?B?YTgzRkY4L1ZIcWlxMm1vc1E0NGJrZ0Q1Zis2VmxHMXZ6czN2SE10VmhPTVpj?=
 =?utf-8?B?N3AxU2FaVmlJVDkzOVg0TGs2ZW9lVmlBdTNITDBEOTJLQ0ZudmFMOUpCemcy?=
 =?utf-8?B?dEw3RW02am1DM3BBWjd5Q2dLM09acmhZeHh6UmVLK0x5cGozL0pRb3lLMWQw?=
 =?utf-8?B?SzQzYW02S0hQN2FqenpWdGkxNzY3VkpUNW9EdDIyNFYreGd3SmFQRktJS0Jv?=
 =?utf-8?B?d0JrL011dEFFTnpONzZNaitTNFc1WHlBU0plYkZjMnJucC9CN1NKN1BtNGtq?=
 =?utf-8?Q?GsMXL0fwucQdBZVGBZZV86qXMht7kKYj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0pVVjl1LzBEOXlMU2l2VmRiemxNdW40WU9UU0FJWkhvSEovTk5vUlh5WUpM?=
 =?utf-8?B?YlZEelZ1UzY4NjU1a2RoL0NSRGREM3hCODloSloraEJGZDhLQTZRNkZkUmRG?=
 =?utf-8?B?dm52YlBUVzNTakYvQVUvMUFwR01ZQmUyWDB3VXJXcW5RZTAxOHdCaVhmYzJZ?=
 =?utf-8?B?WjAzWGxTTUV3VUwrbTV6MlQ2enNkMEQwVTJ6TVhCR2dWY3l6VlpMZ0ZGRXlh?=
 =?utf-8?B?MS9jbG05eGlJS2g1cFhhaHdsNmdhUUw2MnEvSGlLTW1SUXRqTEIrRkdzeWR5?=
 =?utf-8?B?OHpmR3Vwd21iZ0pLMkZpQnU3WmxwK2FwT1l2Q2lqVEpZaE1QdENqVWx6SUo2?=
 =?utf-8?B?UHNQWCs2WGZwK2wxbDhJcjdtN0hVV0FTOC9HTmw3SlJmT0w2Nlc2L0ZKaGVD?=
 =?utf-8?B?R1FGYm1Jc2puRTVWbEZrU3h0aU53L3NDR3Z2SEM0SVlKekppeUN0Rko0dWpi?=
 =?utf-8?B?eHQreEcyR2ovemdHQ0djT3krekF6REgxRjAvcW9XY1hMN1VnODFnNkszdFRj?=
 =?utf-8?B?QmJDNVNiUHhiMWhScmg4WUNESDhWWjAzc25TdlE1RkdqQlFoSXBTQm55aVhB?=
 =?utf-8?B?bVA3VkZKY29uNkRuVkFuSkYxYzBIQ040WmtWYTBLUmNSTmo0cjZlQVBMV1Ry?=
 =?utf-8?B?amI0dkdZUHRCeGVoc2xBdDRwRVhkbUVGUlJrWFhYOE5ud0dHanA2Tm9rQ1FX?=
 =?utf-8?B?LzlCR3NPZXM5QmJYYVVrZ05XQVlYWTAyWnR0TDB4QW1HNjAzekIzNFI5bTEy?=
 =?utf-8?B?d0pDNTI2c1ZDdHNBaDF2ald2eWFuTTZ2WDBrd2taTXBwM0ZHdzZJUktDeDcz?=
 =?utf-8?B?REdudWt3RWxEc0tDNzZjcHFDY29RWUJ6dCt3Qm0rUHRhRTkxcERwMVJFdkNq?=
 =?utf-8?B?Mm9mU2pLT3Z4MkNlUVNENEtiOERLZkxPTjJPbHZyUkhMUEluQTZKT2cvdWdH?=
 =?utf-8?B?VEdZeFM2d0xDenpJSHdCYUo0Q2tmR2pIQUs4V3M5OGM3QkdHbVNOMG5FcWly?=
 =?utf-8?B?Z0lhb3JWaERycXpSZ2YvN1JMeEpYaE5IMXo5SkEwaGJlS3ZmWW4vTTZJWGEz?=
 =?utf-8?B?ZWI3U0cwbjNOTmh1UEpIY1FWUXJYaUdySEVTRnNwdUdZL20vTWpuajFSMEV6?=
 =?utf-8?B?UHFOK0ZoSnNnam9PeXhrbjFKbEIrTlpGamdSdjZYMytVa3pVSy9TL0VVaDdj?=
 =?utf-8?B?Z2ZuQUdFZ3lHd2QyVmZ3ZitJL3A3R29xUHFqaHhnOXF2OG41MjBHMWFxT09N?=
 =?utf-8?B?R2k4UXRhd1lCa1N0V3dUTC9hVHUxUHhjRjI2MWdJYXB4Uk1rc01GY2FIZVho?=
 =?utf-8?B?aG1LcS9ETWpPQmZvUGZLTnhHeGtjdS9CTzJ2cndoakd6UWp4MkFDNXVONWN6?=
 =?utf-8?B?N1NjU3ViTGEzOEVsK2lmeEM3WHE3eXVtTXFKdFRyR0k4QlJiMVRENHJscWFW?=
 =?utf-8?B?NmZEdVlIUytsOVVxWktZRDJRcEtjbzNheWRsbVd6MEEzRUR6aTNMSzN1aTQv?=
 =?utf-8?B?Z1FsT2psUHJaaEVyUVBKVll0ZXpaR2N3NWU4Y0Q0WlltQmJTYUk1M3JnRXNj?=
 =?utf-8?B?Ty8zZkE5S29xVnQ3SXZka3dXaTg3bTZEZXkvU1hWSFM3cnNRaEpBbitCU1Nr?=
 =?utf-8?B?dWtIb0prcHBCaTlza0RCb0RocmVGN3lLYlMxeldZNGxMZGRWcy9WMjFGWmhV?=
 =?utf-8?B?QUF1bzIxRm9EUjZMbDFkUDRYaEUvcVlvYmJWVzJwUTBGZEo0dVlyeituTFNM?=
 =?utf-8?B?cGlvUURmUkpYWXZ3VzN4R3dxSTNCZk5nTlkvSEs0YlV5akpKaFB3OWtmZEdE?=
 =?utf-8?B?bUZPb2VOTXV2ZkpWU3hPZmZtS0N4UWl3V2Y5MGlEaEdYbkFBS2tTWGt4UldW?=
 =?utf-8?B?YS95NmhRTVVxZDNLcVJiOHZaSndhVVJNY3ROeU54YkxqR05XUi9wVk9BdEJJ?=
 =?utf-8?B?NGZKeERYcDY0S1ZCZ05TcFQxaGw3LzBBZzJtZXB3SjQwZDBKSS9EMHBTQnVL?=
 =?utf-8?B?cXRiTFJ3T3hoaHNqUjBMcVNreXBNOEp4Um1yaUJVQnphTmd4MFdKVEpPSjFE?=
 =?utf-8?B?c3lRWGRDUjJPKzhwMUh1bGFhb2QrVC9vajcxOUZjWmNlK3hVUU8yTDh1K1I0?=
 =?utf-8?B?YUhIOE93TktRL0xrc3JpZmluc0xCSDg1OHpieWlPcUtJditURWhkTkg1OG92?=
 =?utf-8?Q?wxo0ftIUP0PXtSczCvrqwBHRpikfEKgiSI/yNjyxAdTv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad75d08-fabc-403d-3b07-08de1603c46e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 09:24:17.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtGJchnuFQRv956PDHVZAP3JFUEYJVRfmpQxK75dz+jSlsE1K64W+7WP0U8G/ubf6zHvfWRlhtRL12AbhywVQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186
X-Stat-Signature: h67xosc9ec4h6r7c7izj8n8pqcki4m4s
X-Rspamd-Queue-Id: 517B3A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761643461-219062
X-HE-Meta: U2FsdGVkX18wXdZKNrXyFQ4Pgf/z+Acq1ca4n87I9CqzH2GgEaZmYjSUkj+GvicCzJTXEti+nd5BfxKT0FLRzaaxqdCPeR5RqaFWaSXIhrb4M4sOrqkwFlaqTUVJkzR8mC9L0hZIIdkY5P7t4sFUt/a0eRIDe3nDzXWMe7gqdG9dGWCHDZe7uXEUBQGQxF64PEDxQz4mjgTDQBh55uCntW5c1RUrk4XrJMSV2qdotHGzm1iy3TKsm9NsvV2Wf1OnGB+RPoBSYSjsI9fG12X2pstlWJYUjF7f+B83EOLTPbnKnwaeIvonUyijjg9LSfXnJWd9/FmvWmA1GcMJEnB8JaEqJ2SuuT8ZHCv81p+7SrbVqljZXLZSXcAOM8E3FeYwnIyvht3kKcRmuKRkyVpg0bMbGsuqIVjo6PpSRr5bbQEFLtsYkVt1W/tqxnaGifacVxBH8k0KIma4qIkUmQ43Kin5KS9DvquFDIGb+MPbs+Sx1iimi03b1W2rl3b0sJWtyH5CG98oCYux6sgkauCmkbsx3GvDqmr8rDGjdAjMEYkxw+xqVwTMFMHddxFFtQj2aJQae8mjd7XKMMc+RY+/ZeOjKXwA/acwci5ORT898uVsKdUwgdOqm1SNIS/UFwEaGP6/g5CDLOs+7+LUqEI5RaPu2vpF7Sy9KI+yOOI3LnelEia/zANbIR/Z70nYR1Uqm9AnGnYwWJrs7VzEXJesM2ZOlfEr65q83BgSvcTlMXd/R1T0zVbno0EZ8F8nA5ALjrYSBmIGwaFpBxHOxGdrSmC2SigvU2Hua7xgq9pReYGO2cEqgCn1ZPjqve03ocCq/vxIuKIi2HuUH8eAmLN/m2i+bg6aHVg0pWfych8+XT68On4MwpoPTSgDAvrDH/HEYXUY8Ukt7GntX6gcLtcY+S7AtjpT3s7vZUfuotxxPaVEFCjNyxDryo+M616GFr2UvK1n8/YdS7x8iZ6Jp85
 1SPeoE1W
 fOqBA7Qf2WsbjegvZrCNP2nwxER1UJrbwitzPD4XEf+IscI9pLrLxB9Tqfj9SMJJyaYS8ndxjbb/6XDXws23E/qGWl5iJAw+8uTnW+QLlJdaytBPi7QeRSKN9w+pmfP8JkyQCNmMsfCo1diTwYXfFs+VI7IV42YiJt0EAt45i2GWGBUOpMgu7EgGM2YtkseCvTaWnNujf6fhYLyqmUiQPUDla/WdjANmBswBg5I4OSDIxdrZk8k3Ku8eT6Z4KHscwgz2ykorDBVRhLE5crvlJ86NNmjXLVtNQSn9bWurwJpp2+11dbAbUUumtbB3Br/w2vFCCflCAK9g5kgSYVPsmxiw+rOGVg4kBWTwIVTeeJo78ZuMUBNs4CRWbnuAJYM16V7ben/Cax0iMpbP8gKkmbLVRJrvfAa7IRKCnnxBeB9AO+1H1AMQEsaMJjpvGNZ+yMnlvvuCPB500jQdOv5iz4EpYFmqHhcdgTkfodS3RjdfMRLjMjgEYs2r0YTPBxzFrw3Bx8dIlkv5XSgX5tKLphvpx+UZWl1jOPMKAvhGky0IGWAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/28/25 04:06, Christian Borntraeger wrote:
> Am 27.10.25 um 17:47 schrieb Claudio Imbrenda:
>> On Mon, 20 Oct 2025 10:41:28 +0200
>> David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 20.10.25 09:00, Christian Borntraeger wrote:
>>>> Am 17.10.25 um 23:56 schrieb Balbir Singh:
>>>>   
>>>>> In the meanwhile, does this fix/workaround work?
>>>>>
>>>>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>>>>> index 0c847cdf4fd3..31c1754d5bd4 100644
>>>>> --- a/mm/pgtable-generic.c
>>>>> +++ b/mm/pgtable-generic.c
>>>>> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>>>>             if (pmdvalp)
>>>>>             *pmdvalp = pmdval;
>>>>> -    if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
>>>>> +    if (unlikely(pmd_none(pmdval) || is_pmd_non_present_folio_entry(pmdval)))
>>>>>             goto nomap;
>>>>>         if (unlikely(pmd_trans_huge(pmdval)))
>>>>>             goto nomap;
>>>>>   
>>>>
>>>> Yes, this seems to work.
>>>
>>> Right, but that's not what we will want here. We'll have to adjust s390x
>>> gmap code (which is getting redesigned either way) to only take the page
>>> lock.
>>>
>>> In the end, we'll want here later a single
>>>
>>> if (!pmd_present(pmdval))
>>>     goto nomap;
>>>
>>
>> this seems to do the trick:
>>
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index 8ff6bba107e8..22c448b32340 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -599,8 +599,9 @@ int __gmap_link(struct gmap *gmap, unsigned long
>> gaddr, unsigned long vmaddr) | _SEGMENT_ENTRY_GMAP_UC
>>                                          | _SEGMENT_ENTRY;
>>                          } else
>> -                               *table = pmd_val(*pmd) &
>> -                                       _SEGMENT_ENTRY_HARDWARE_BITS;
>> +                               *table = (pmd_val(*pmd) &
>> +                                       _SEGMENT_ENTRY_HARDWARE_BITS)
>> +                                       | _SEGMENT_ENTRY;
>>                  }
>>          } else if (*table & _SEGMENT_ENTRY_PROTECT &&
>>                     !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {
>>
>>
> 
> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> can you send a proper patch? I guess we should add it to Andrews mm true to keep it close to the patch that uncovered the issue.
> s390 maintainers cced.


Thanks for finding the fix. Ideally, we want this fix just before my series if possible!

Balbir

