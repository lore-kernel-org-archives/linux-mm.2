Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFC2CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2082C6B008C; Tue, 19 May 2026 03:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFB76B0092; Tue, 19 May 2026 03:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEEA6B0093; Tue, 19 May 2026 03:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F08116B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:45:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A69F51C0C7A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:45:15 +0000 (UTC)
X-FDA: 84783383790.21.04299F1
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012036.outbound.protection.outlook.com [40.107.200.36])
	by imf04.hostedemail.com (Postfix) with ESMTP id C35FD4000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:45:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=e1fdPUlM;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.36 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779176712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPnnIvNWqiCrOYilSiuw29/x0WkIOiKc6HVF8aHyRxM=;
	b=ozJRMOiuAnJsDw5s3rpCSQDihjnb8t9lJJEkj9C2L3rO+tIA4eJzXVoonrIJPWcAq59urT
	ddSIblR+2OL4kRgl0YHjyhZKnwxS+GrbciLgh8YONUS6yGVch6e213CtKKZsdGY3EcnBG5
	9l/sOZwTIaitYjR5HQBBcYl4h79eoSg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=e1fdPUlM;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.36 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779176712; a=rsa-sha256;
	cv=fail;
	b=iRTl0VkNl06JpXLICMxYzPEj57VChtPawAUTJsyjiNm1FANcdrAGEETd/0N+mwbO1d0xAE
	bGGoKyemumxt41zEQNJPk3GnrasVSv2IpOiTM/XH4un4Y3M5EX4B4G3xEgPt5x+MT1dw/o
	uBHPAKKCPDsPVZCIBml5eKZBw8o4PbQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Go4h2Yll1MXpJjnxykpaKfOOj6H2Jly/ebhK/VY7uR1EcUSvIp3QEs3Yxj5fZSolk9q6RdRQusa8QIkBMK46uk0dFIPvn0I389E5ri3o3hOGF2Px4lwPixgj7nDxpgPytPHBfLyLQCqbEsIfzo2UrNjKK1dVcm8TiKx0fOnrJ0gl/V34LVU+CzvBskuJU23gDzNnTyLVkiyaytDQKpgJBuwW83R66pqmIllMYzZVmUTUS3fW2qSfY2TOimdZiF5LxT8k6a8AsphbjqTB3lwDQs5ki/phq9DDTRXvQCdZ4aq3T1Z5ILwzFG1LJdLp+Bcjmahbq7RdbCfOOMEcYT4eEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPnnIvNWqiCrOYilSiuw29/x0WkIOiKc6HVF8aHyRxM=;
 b=dbKXop0kHzR38DsJXmhrt9jr0/B530Nu3GQ0OJ6y4uPSopxIcyq+6NeJtReZuPDK+TvUc02O6mOxUeZS9OBG0Ke4Wdcd4BYc3YkqpcsHKG0Il4p8+zQp9p+pZ0t0e+x++ogXqADLfeLzJ8Bpmi4txNnx4rvth8svqwT1h9TxFVmKtSDlZ8cHUxylCXErY64Vzyp0qm9SLsgAC0eCkEmA/72PKh06v+OwukCrWcbchejLkiGg8yin27PlswqmchYF8Nr7Fm4xnM+gEGAMft0LiyJ5Ateuky4f5MsHw7pZ0k13HKPtAEQLum8ydronDKjGVtZK24Z1LlJCABeEfEcwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPnnIvNWqiCrOYilSiuw29/x0WkIOiKc6HVF8aHyRxM=;
 b=e1fdPUlMTv4V1Cy9SZOjwVMKCPLQnEcPTOcUO9oWX91H94XVZOZZxyjTvt+TW3ulWwO4FAG5ZqgfRgneLLdEEwutNxi8WANb8fzXghUFDfbE16I3L4Tvxvg4BsC9AY3p2qa+3BhzGzeIJ7LJ2CocntGcILj33MZ90F5ZbXnokeI=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA3PR12MB9180.namprd12.prod.outlook.com (2603:10b6:806:39b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.24; Tue, 19 May
 2026 07:45:07 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0025.023; Tue, 19 May 2026
 07:45:07 +0000
Message-ID: <0558da9e-1d5c-45b9-b69f-99d50d22d090@amd.com>
Date: Tue, 19 May 2026 13:14:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] mm: batch page copies in folio_copy() and
 folio_mc_copy()
To: Borislav Petkov <bp@alien8.de>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ankur Arora <ankur.a.arora@oracle.com>,
 Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke <hsalunke@amd.com>,
 David Rientjes <rientjes@google.com>, sandipan.das@amd.com,
 torvalds@linuxfoundation.org
References: <20260427142036.111940-2-shivankg@amd.com>
 <20260427142036.111940-4-shivankg@amd.com>
 <073e5e2c-7102-4141-b0d7-fa5635f811f5@kernel.org>
 <6a5e794a-a608-4126-9abe-0d512a57dd67@amd.com>
 <60fb497d-a35a-42b9-8bf1-7f9ccbde8ade@kernel.org>
 <20260518160036.GAags3pIMyN8YN7fPw@fat_crate.local>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260518160036.GAags3pIMyN8YN7fPw@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::10) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SA3PR12MB9180:EE_
X-MS-Office365-Filtering-Correlation-Id: f067d8c1-d19e-440b-9908-08deb57a8c35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	sl331r5yF4PjkISkUWOaMXQ9Pu9e6i6vTKqsxtxgkWYSCAbFcw0AwemwFgX9yJZbhx1P3x+WMNZH8K+IUhSfjiL28nFW3t9MtstywIMTUruYYy7t2OrZmfk3eUMSheu3ig+2hhbfxWBZ/oWg0ttAmBjGXnZoKbTd1JC4BxrPQv/jEN2qu5CMLUFPOtVxWYEe4mSN2EDHHD4CHP8qQDr4L1jEVtapw2SuM28juM/tWZQ1gH2CUcPlS/231o6593ycJgkt0i4Gr/dlB2azjFuFD2eLwEXWrmDKRA0avgxbYIstjw1MXF4B1aPdOWRQnY7hS8QhnQLcO2sEqxEanocD0nfbbYxVmKqg/rfFKCbyxvW07pxGQLk1RGsAcRD9DcRsWu8t7LX3AaIoMwJVzaXBMKC7oTCfO5pFon9sWbOrbQXnXDXakjGlt81WYpSHCfxVeRwZF2CESqc4SInvo8HWonxbz/HJ1rP8257k05i3LsyoTra9ZRlyA9HY6UCrVHJJNlHbh6Dz75KleMlfP9FgkEI0FGqD5f4baSb0ZyrE6omtNKLF3o8oNXPuq6VqazHba4BHocynpFFwzQCRjGfuInwcpXGK6SwHkDvUe2rYrmFGLxZY5vMMXbvCfQmcXEfTeV/Y4E7+lQ8UsqsvX5N8JzqjGetfrsh7sX5Aof5qgkkBRGC0ya2Nh0ofrFYvxOgB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V01JSVNmVy9Fa2JzQi81TmpDRzQ0eXVvM21FWEZFNXYramJjQldHS2RabUo3?=
 =?utf-8?B?YTZJL0xUVmhiNjYzK1NaNEpFeFU2ZiswdFBkNkRSOEl3cUphQkM1S1pJQWgv?=
 =?utf-8?B?R0RHTVVITmlzamowNndMcEUwczBLaFJBL1g2M1BCWWc4ck12NFl2YVA5QStZ?=
 =?utf-8?B?NW95ZEcxbSsxZHlrU0hDTUpTRy80ek5hdU01ZlZEbWExUHREeExVb2VESnpz?=
 =?utf-8?B?SDF6VnNhdFFNSURFdGxvVENXQU1XN3liL3Zqb3Q5STB6bkNFL1pKTG5jSEJ4?=
 =?utf-8?B?OHJSeXZmbHhCS2hJZkxqTGUyU1ptaEliZUNlYWpmYWJMTmFWd2x4NDZORzFQ?=
 =?utf-8?B?M0JEVS9NNkN0bmVtTGYwNGxjcjdNSGg1NEdpTTZaVEY4NWR6R3VZZWNYRU52?=
 =?utf-8?B?MDVkekZ4MkNqSmx3UEhDc3JpMlRQU2dOTFJMK1ZaMTg4VHVGRUtRYWJSQ0sv?=
 =?utf-8?B?VHRVaGFtM2VlMFZpenlYNnpCQkZmL0NUTU02S0ZFckIzMmF0N01TZ2MvbkVR?=
 =?utf-8?B?QXovYTRCRkVFUURsazVoelVwcFp4c3FCWTJvZWx1RU9OTmVnQm9NSkpyQkZH?=
 =?utf-8?B?QWxYbFg5THZVeGpncTNUNW1FMjBpZ2UzNU5CbVMzUU1tWkdkenp0MWpCUjhH?=
 =?utf-8?B?Q3J6VHdaRm5sd0xwdHJFMVozYXNsR3ZCTXZwRzE0WXNyeUdNYkRwUHlTNG1T?=
 =?utf-8?B?UWQweVJrMW5yZ24wU3NPdCtad1MvT2NNWmM2azRPelF3Ym5KNUMrazdZbkJL?=
 =?utf-8?B?bHRNZ0FDK01rRE9acUt4eWtBcFZuODd1aGEyNXMxcEZkbVFRVTI1RFJ6OGQ2?=
 =?utf-8?B?dWhabkdjNjdocENiUWVvL0YrQ2hkdzJtb1ZRa2t6ZlQ5dGhaRFdzd1dyYkkr?=
 =?utf-8?B?QU1PbGplZUVKaE41MmIzaktvdnJWUEJTNVFnNnZKOC8rWmI4blREeHAwVmhq?=
 =?utf-8?B?dTgxRUFXdGR5RmMydUZRWDhkTXI4U0JqQzYzSmczU0JLVU1QMzlaVmJ0Zm1Q?=
 =?utf-8?B?Z0FHWVYrNFpkbUx4TGUvVkhSUEtMZlpFWWV0TDhNdnFvcWZpYXJCak15T1Ix?=
 =?utf-8?B?T1MwdjMyU3dJdXcyVW8yTXFhZHZrSDcwSXNxbEhIb2k5MUdSSjZoOWFwS3R1?=
 =?utf-8?B?WDlPeXd5Mld0NTVRS3dtOWJ4dDN4QjBwbXJ0S3lkbHZadGRqa3hTYjF3Tjcw?=
 =?utf-8?B?djhnNHB2SjBkblZ3TFVhb1NTTVV1SWxPTFFoWTFSbTJGNFJkR0VRckVkYVVQ?=
 =?utf-8?B?Um82VTEwcDFzVmxIaWwwRjRtdU5VMTlmYkh1bFM1a1FkcVZUc0Z2NzN4YUFp?=
 =?utf-8?B?ZWY2V055d1pwdzFFbjhTaVBFcGVQTzlkcWs1N0JoNnZxcjhyckhmU2JUZEFW?=
 =?utf-8?B?L3JvRlRxZWtCdCt6K3RDdEEwQWpZRi9EeXYrVldNaVczUTN2OHZLcUg4WStP?=
 =?utf-8?B?OVROYk53dU1Zc1BBV2dVTDN0MFltS2lmZ290Q0xsNGY3RnE0a3RKem9BSFNl?=
 =?utf-8?B?akVWN2lvVXFHaEI2bEtrMjI1SlZmMVBQQVJKcHZsUVFDNXRhdldCNGpySy9k?=
 =?utf-8?B?UVhVb2daSnRxaHRnU3FKd1pTK3JVRzNOSUZGU0J1aTZvM2JkU2tBak5CT2J2?=
 =?utf-8?B?WVUzTyt2cHVMY2lKUWJ0aE5teVdxS3FmRE5HQ0V6c2FYTGVsQXlnaU0xNTdO?=
 =?utf-8?B?VnJtRVBISWVaVWR1dzI4MjV4N0M0RTlVLzhXaEt6aHZPUHJUMmtRZEdPNVFl?=
 =?utf-8?B?a3ZqWnFxL2J4TE43bUtwd2IvZnUvdUROOFIxd3lySmt5TWJmMVBPaGxuVDk2?=
 =?utf-8?B?MnA3cm9nS0pPNEpZTTlrdG9mSUU1azRBM05aZFNZSVhvbWhsOHF1WE1SeUJU?=
 =?utf-8?B?dEhRbUhiVC83MmFIc3pNY1RkZlNtbkdHRVh0cHdSUUc0OVQyelZXUmtKb1pK?=
 =?utf-8?B?UGlDYVZpR3FPVEpiRUg3cyt6dlZjMGFsekhJWVlCRTlLN01jdVMvU0hmQlov?=
 =?utf-8?B?SXBOV3E3bDMzZGUxc2NESTZyaUdFb3NDVDdrT1lJUnEzTmxtdDBSeDRwU3RU?=
 =?utf-8?B?MUhpM1grakRVdjBlZ0xPWGozZi9zaVcrNHBqRlNtRWpzUDFRaXJXaWl3dGc5?=
 =?utf-8?B?amJqOXFhbmsyWXFWZE5qM250M0lVcmVzVUhxT2ZaM1FLL3VGZXBwaUJwdmN2?=
 =?utf-8?B?TkJ0OUpJREs5cC9Md01ObUNkMjJrenBYb211eExpYXl3VVoweWFWTmhQV0xy?=
 =?utf-8?B?bjJ6MDNnT1RxZFo4dlRrZ3d2eGRXQTU1VDEzUTJydElXcmFFejlCLzBYZHBU?=
 =?utf-8?B?MlpZV3pJOWt0UCtKeThvOUU2Z2l3TGxsSmQ5eVVtajRBbGdxRlVVUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f067d8c1-d19e-440b-9908-08deb57a8c35
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 07:45:07.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJ+hjqcBGp0P7QnsfxF3kuuw6KP6HC//pSHEBW2cnTOeko37KiOl0gauvMAT36LgdL7o6e/TsXnLvVcehAUQKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9180
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C35FD4000E
X-Stat-Signature: 7uo7wiowij7nckfpgbosjapkbkjo3rx6
X-HE-Tag: 1779176712-759427
X-HE-Meta: U2FsdGVkX1+8zIAwe13puqrTqwyo694MiPQp1q6LrTPWmGjlY7ji0MtyXX0Oefv2iIfY8k0U8KZ9fGquxn7CWrT2tH+m+TbfY/aPreupXu770elhrBPu9dECWGuBkfsJu3dXcRsrPUV+w6c0a/OjMjyYwRGHXJw5+t2LeegAAXl4s+nP4WcuLiMN6108BIayyxRV1/O6cA5a2bJZaEKIn0bBG7fVRapPDhB1kt+q7EFK/CCxgWK+ppBT4afVVE90lZLYhO8DaaJC/fRku0vnAa2Sk8hBU067YxRj8AOkm5mGgIQMBsm+H+8crCI6ikTHETq505GtXWbX1i3m0tAKQS65Xav6qDXuGw4AAVCuNXpGN3rQzjgRRlhqTaOC/c6JRoTOpvydsFpQK2QXvtmBS9/Veychnlol6aekd/dRbvrd1a0Y1O0+IkXmvuAc2X7pN9fjxN5DQP8msQp0E0v/tW7qVJe+Ic+a6QBRNmi9ZohOIpMG7+sDs7o8j0rOlfbbbbhaVY3+mCzZs339oYNeqv5/TUOQEVr1kiYtryC38S48gwgMQhW0qbtwMzC5H9QtLUCdMqJadyPmetkLnrNYJqNN2itLwUYv5FiTG2K3d7QclL3HozX8w4Z9ExQvAA6v6wKHUx7lQeABm+9tv8ne9Pf7SluKl6GR8Fs/NxBnfCzElkYUjykqLcr89g0mQY80+vNQjZ2Ikv9mvSzu9TpShDrokIZdAaAFy32USvJv1Fytdk23toCUhjcblpoupVdCA781rr6KvP+GN4bvraOrqJbR/dAxuvbJh7sLpHp2kXDJmos9vzCiqFfkrSyyB3ez57b6LVkd9fmYuT6mDe0ZDpenoNWOGuG69gJaC1UTm2kNU9hZZK1X5rTTuVVymanNfAOeeZCzqvyVj92kHMvMnE6FjV+O94c31L7ThzWNPm2CAyTjvjb00KNc6akFay8nwIhdhJf2433nUU60XSe
 eZUyhqv4
 A7kHIdQ7KWYidLTAZ4HOyvZUtV2Bh2V6aQFneYKR0OYtvjPn88Jzur12s6eyg9IHHwN5hS1mH3Iw3X2Qp0p8q0PtqtljnrIRyDiv2fHnNXZBixmzpUTuwAM20zEge70gC+iTUV1joqNMtjRJKwSi8A1CHazxtLMjekwjCDrp7MP8QnF8lmzSO5B6FnwhXZU+yKsUK4x5pAtrHrl54B7l2lw9GjiQNw/cz3JFmnE1M0A8EpJjLGI/LrTehJv4vERbzmJTzCvnUuRCyoJ8HOHqk5v1SoX5F0GJzNbkzgbfr9NFC7MjXUITvSqZhoTBkz2dwkSNP226yALkxE+6leRkd7CQcAi9dgrUlPNVTnYKYwh/Dj3VolHW4oRuG2voJbqgpNHaZ+kK7hUPpuirf4KC1RaUrTk2h04VR0wGuPt0cuTW1ysFdrgnQfVPbl5HbM4NLLoT+F7OUZq90J48Razc7urc79ttfSQzU4cK9QAMAdxm8jBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/2026 9:31 PM, Borislav Petkov wrote:
> On Mon, May 18, 2026 at 10:43:22AM +0200, David Hildenbrand (Arm) wrote:
>> I was wondering whether optimizing memcpy() further would be of value elsewhere.
>>
>> Of course, we wouldn't want to degrade it :)
>>
>> Some direction from x86 folks would be nice.
> 
> We can talk about it... :)
> 
> With the proper perf numbers to back the changes up and if we don't regress
> others, we could look at improving the !FSRM situation.
> 
> Make sure to CC Linus on those patches as he likes to look at optimizations
> there, as one can see from who changed things around that area.
> 
> :-)
> 

Hi Boris,

Sure, I'll keep Linus in CC.

So, the story so far:
- Current folio_copy/folio_mc_copy() do not fully utilize the potential of rep
  movsb for large pages (up to 2X speedup with FSRM)
- On Zen 3 (no FSRM), memcpy falls back to unrolled movq (memcpy_orig). (using
  rep movsq instead would give 1.4-2X speedups over mempcy_orig for >= 1K blocks)
- folio_copy and the mc variant are asymmetric in their primitive selection
  (memcpy, rep movsq):

folio_copy -> copy_highpage()      -> copy_page()         = rep movsq     [REP_GOOD]
                                                          = unrolled movq    [otherwise]

folio_mc_copy -> copy_mc_highpage() -> copy_mc_to_kernel() = copy_mc_fragile  [if enabled]
                                                           = copy_mc_enhanced_fast_string (rep movsb)  [ERMS]
                                                              = memcpy()         [otherwise]
                                                                = rep movsb           [FSRM]
                                                                = unrolled movq       [otherwise]

Introducing a new "copy_pages()" helper can make this symmetric and
optimize the bulk path.
memcpy() and copy_page*() are fundamentally different in that memcpy
callers don't guarantee alighment.

However, David suggested avoiding the new helper would be nice.
The direction from thread is to improve memcpy for !FSRM situation
(without regressing others), this would address the Zen3 regression
we see when folio_copy switches to bulk memcpy(), while keeping the
gains on FSRM CPUs.

What if we modify memcpy to ALTERNATIVE_2, adding a rep movsq for
REP_GOOD between the FSRM path and unrolled movq fallback?

I'll gather more data for memcpy experiment.

Thanks,
Shivank


