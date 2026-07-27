Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4894C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0DC6B007B; Mon, 27 Jul 2026 17:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8E06B0088; Mon, 27 Jul 2026 17:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769FB6B008A; Mon, 27 Jul 2026 17:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF436B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:10:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D20FF16020F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:10:38 +0000 (UTC)
X-FDA: 85035800556.08.39271BC
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020079.outbound.protection.outlook.com [52.101.201.79])
	by imf07.hostedemail.com (Postfix) with ESMTP id BFB644000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:10:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=JnIjnYDQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.79 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785186636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k18PovvMxNajDVAWcYv1jIJ6CMxZ+TzBA5bDg9iIO+g=;
	b=bqwCMf2+4ogrVkqcENX8Gdkpx2Uj98/u+NoOKV8byKy1lN5G34dZS2ybwt3OEEP5mjsocG
	D9X/nLFtda2iituX8eOgsOIob3xx+bNQzbBr6kUsf/Gi5JQpnrA5RqsfeeHHuqY50GzhLZ
	rNbKqquke+B8qCUGvzr5Fdib80HNX6c=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=JnIjnYDQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.79 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785186636;
	b=y+DvX7mwky9axhJq6hPD7aAKHyHlZdo/IMyH/jRy0t/RsIZAMlmIKgAtpyLSGb0STaw3Vj
	ioJfdCFWD1DKBp7Ap1G6Epjs6tSq1FpFaUmHckCGd0QQQnrNvHToEJScZHudzN1n9C7gdR
	cudro6w+PriyTW0BTw4BtBLsRJu2QY8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVFwN7RKkXUmuMDzp+AQ26wJdnG7AqanJdwWEKG2H7UyHr4tU1tpCYwsUBtucB3qrzNNCblpL3bvxueBcc/WS5G+xgNzfAJR6RptpfugGnfbcroHseBbUE7trXcSfSSz3lEIcnDFfax8yaAFZWWiD83ZQ3EWWlJujLSMDV8c3jCxDxuIDofTMK92y4SH+ojx0owOhWisZZK06U+UpoQHeUVDA9tBJa52tewhw5ujWmOF1L7sSHuoo877wwWFPwBjBeBOtRb2ICBv7CWi2WeM2CEU1icZjkY8R0lhKQTOCobKC1f72EknZoStA+Tq9Mt56Lw1iRHLGx9qNLmUU+jMKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k18PovvMxNajDVAWcYv1jIJ6CMxZ+TzBA5bDg9iIO+g=;
 b=aGPlWOpRmngZHNO0OQqsgtwM3TiT8QN6CiotQYoWGDsBFVfgcV+yNlxKd9lZkECwWSgYZN7YEbW0venwhlQu/pWssAiEWPrY7G/b3HFDB0B5vuzuv4H/wcmzHnArIKMyHgjqlO6h++5+eKqLs9GvgOyDdveqmM1OYd67qCmRf4/OAqUoyatJcLu5dOnlvlAfRmpYf/hT4vrwAXGi9/MqPdfqAv50C/rNOH8fhX9Y9kjkd5Sm78J8Col4uv1+Uqh2Oc41Agbfo/GS8B5VUOLdIlXAgPfhuzZABEBrlMvzejitKnwQkPzpMq6yWCPxNhR4GbPdJNQgLZgi7yINJINwag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k18PovvMxNajDVAWcYv1jIJ6CMxZ+TzBA5bDg9iIO+g=;
 b=JnIjnYDQH+7/flLoLNJtbClqyJD+WE15safe9OYWFfGW0ODgeQrS4s4jOLH/pI5DpBSYiTl845swBmsCB9rhcR1fCnMpFbEbR9jH0l8WzvFUedrHwEYtbv5qzd2oBoFCaoLHd/eWHj6F83TAy4e7KjHnm3GDM9k23nO9k+OMqd8=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 BY3PR01MB6530.prod.exchangelabs.com (2603:10b6:a03:368::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 21:10:30 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 21:10:30 +0000
Message-ID: <87b5d158-f78d-4473-a831-575173a56aff@os.amperecomputing.com>
Date: Mon, 27 Jul 2026 14:10:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, cl@gentwo.org, dennis@kernel.org,
 tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 david@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux@armlinux.org.uk
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <amCPBrdltFSE_fEf@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::7) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|BY3PR01MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 060bcee8-e18f-4af3-44f0-08deec237ceb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|55112099003|18002099003|5023799004|11063799006|22082099003|4143699003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	YJ0K8nslaZJQl7e0lLvnisww5iS6h1/Py25CVkHgO5q3YvTpo+Cj/3oMX01LdZ7rYg0aw4dvZU+42uZklj65/v/ZD6Jz2HmiWLOSBHc1UXoNQrrYhIDS8LWE90lvWIvZ2aTcSD3aYbdK2CeXNmgNQFvQHQxFYy3yO1WbGYMMmQjVujIMoY9mHUzof9c7TaBZ8ByuUPZHnbQT7AQs6atHqyiZt2s1u9tP/jKg4fPoKJ2Ogb6TkILtPJaWmA0aZ77HjG30djnztzSL6MR0ZkibpAktLnWPG77/C8OkVX4vyPJgrWikf29VBZxr21cq6xYn7fudNhKaaQ3UEnKjAu1+fZH4sZj9HKddsbjkH5f7ci2SDkGog8+1eTtdF8xAHotg/4hv+ZV7LVy6sGV9Pq31iOxbm3z98sAmGBtSXUg99hrGOghmB22VIW3MIW/U0hyqvIqawh2LPjBHIU1Gdi9EksWy5GVVh6IDKMqFWpw/f7oHyQjr1vA8QYfYzubvm3IF/SF80wbwP44iIou2tXCGfKgTGUciuzCY+RTspdA3dagLLeCINsoJbJ79C/C3IzSunrVbzggKzC816unWhINtxbYnTgLZdRPNh09OQXkkIFuwZ1D9opHb9gvCn0F8z5f7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(55112099003)(18002099003)(5023799004)(11063799006)(22082099003)(4143699003)(56012099006)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGJHYThnbkNHQ0dNYzdxVVl0ZnZzdUUrT0NIM2pnQnB4WWZSWHR0WVBYNkZL?=
 =?utf-8?B?OXowaVZZZExNc0ZLb1djOWNaaHh1SFJhZG5hN3M5dG1Qa0tFYVpxSXRWbWZl?=
 =?utf-8?B?S1FiRTczUUJnK25EcVJqemNiVGpLUEcydmRKcFpuYmRLUVd6SGtqQWlkSk16?=
 =?utf-8?B?akM0NTVPQWZ2aXloWmVhS2lrSTJMVUxDdVllMHVRQk1DbzA4NzM5L1d4cnd4?=
 =?utf-8?B?djlUeTc4YUVRQ0IweGh0MmxpUWtnMFV6ZG12VXYrT0tBYUF0cTllcWNYMS80?=
 =?utf-8?B?ZTA4aFp6VUIwMmMvdnZYZkhSdVc1V2thRFpDUm9kK2k4SldhY1NDNDVBN21w?=
 =?utf-8?B?bjVidjZIbjI2ajN1UGtLaDBmSmxWblJMUWxlK09hckttclYyeWlyS2l1U3FI?=
 =?utf-8?B?NDhKOVkwYmVOOUtpRlFhNW5VSlo5RDE2UHhjVW5FT3A2NnpWR2ovSEJzOGls?=
 =?utf-8?B?QVk5ZHgzRElMMlVJbFpFNlBPY09mQlZiRVlDVzNFaHJKQWJlOVZiV05od3Jt?=
 =?utf-8?B?cVNlc3Ezb1VRSDF6eEZ6a2x0Mm0zR0E1V2ZGdkRNRm40eHhTcWhEZW5tSzg3?=
 =?utf-8?B?aGcxdXBKV28yUjFINkJRWmw0YUJqQWI5N2hBV21GWUNQUjNxYmxLV2FtNURl?=
 =?utf-8?B?M05EK1FSQVpKVTlWVi85Y0c2Z25TUGpaY0Z5UUg1MkNkVkV3ZkVtR3NQeENl?=
 =?utf-8?B?UjZ1b3NRVUw2RFRxYUVNWE9UM2YwYkRhQnEweUw2OEdYdytqYXNjQnZmUGtm?=
 =?utf-8?B?eVlFRDJleFB5Um5FVnUwK1hmZ0pnK1lKY1NrbmsyZWRhZWwzbjM1dks2RE5I?=
 =?utf-8?B?T0hVOGF6eEZxcEU5c2NOdEpaMmpyZlNXU0QyN3FnblJZWGtXR0VQZ3ZrTWl5?=
 =?utf-8?B?YVhaNTYyMm50QXRkZFVZVHhGR1l4T3FjOVRhYkFwTXB1akNyS2I1MGFocUIy?=
 =?utf-8?B?Ny9leGZxRFAwcE5HT0dRZUVOKzVsaytaeDFZK3lVR0locEtUZzBudUZ3Rzc3?=
 =?utf-8?B?KzdKaS9PWTAvcWt0WVkyOE9iNVY3SzNOYTJNay84YnNJdFVuQ2taR09ROGU1?=
 =?utf-8?B?LzJFRS91TVptaHdmOFZvUmRhM1lSZGZTUjZtMWdjMndFTytldmVzTEhJREtD?=
 =?utf-8?B?eVcxcFBXaDlFN05QeDVXWEtKcGwzT21yRUxWUGJhNDl1QnNPM0lST0JsRm1G?=
 =?utf-8?B?V3pnZjI3SXJXYmdlYklUU2tKM3pIbklFSGVJTE5UYXFWQy9ZcDRZN0xRZzlK?=
 =?utf-8?B?NW81a0ZhY3VaU3ZxVGxNRENjaWV3eFVPaVZmaTc4a2NnYmFZZXJ3Z3JSQm9L?=
 =?utf-8?B?T0F5aXFSeUQrQWlPdGQzcWR2TEgyYXk1V2VTM1Jrck9iOUNsc09RTktoeHp3?=
 =?utf-8?B?WEVNRmxFZU51ZTFQQ2xVSTJBbmlraE9NdTRPVGI2SHRreU4wQy94dFZkME1Q?=
 =?utf-8?B?eVVrUktKcFluNUZoOWc2R1NQMkhKWFV4TFFhVHNaZk9QK2F6bjdldkV5ZFNV?=
 =?utf-8?B?aGM2N2tEVFVkM04yWFY2eDNGOTVpNU14OEY3TEloQzFWVlIvbVVrWEMvSVhC?=
 =?utf-8?B?d2l4L0hYUXhNcHJ1QjM0ejJpZGZrdVdhVmtOc1p6YUlqUitUWmd3UFJvTEQ1?=
 =?utf-8?B?d3dWdllGR1hZYUhKNEd5NEpBM0h6Rjg3dUNRbzBDVWRrL0FNekhoUjFya1VR?=
 =?utf-8?B?Yy9lSmlzMWlpQ2pLWnc3aW5icHgxWVlGUDZybGd0ckNnVzc0NVFQaDNZYXA1?=
 =?utf-8?B?NVAzcWNXMjlxMmhFc3Fod20yMmx2aU9UL3JHYVQ0OTBUbVQ1ck5pdXRsUUR1?=
 =?utf-8?B?elJGeFd2MmFjTkRaQ2RXVlBNcXJZbTZ0RnNuTW5XaWM4dFJ4WFY3TWlQWGEv?=
 =?utf-8?B?N0F3c2pIa2dlQjlCcEF5U3AzZHl1b3E5Nm5ITElBZ0xRbzVLSkxEcjVUeWUr?=
 =?utf-8?B?dFY3Sk05WEw0YmtzZ2piTmpUU05yNE5zUmxFWlNkZFV6VlR4NDZTVkE4aVBq?=
 =?utf-8?B?Nk41RElmSFdCaHNrd0lBN2RZUUFFblJGRks0UGRldjNRVmo2YkV3eVFoSytj?=
 =?utf-8?B?U0IzbDlOaDFzK3I0SHF2Uk1KUk9BYzdSaytRWVI2K0xLS1YzdmxJTDZkeVJz?=
 =?utf-8?B?U2F0MkNrMWN1Q2hORE8vWjJZb0xuMEJLNGtTRmt2ZktiRXpPUDduVnZ5c01i?=
 =?utf-8?B?dlA2eWhsQjIvRTZmK01IVXpPZHFreWh0OERKbDhscnJkcjA0cnQvUmJkcjdl?=
 =?utf-8?B?dCtnYXlXbjJIWHlSRHJjSGxta294cmlzN0FSODNKMEp3MGRtd1VIL1VBRDdG?=
 =?utf-8?B?bU9qWklpczIxdVJmL1RXWFpER1JsODNEK2U3bEVaOXAyZHQ3Vkt0RkJTVlJ2?=
 =?utf-8?Q?SBOGU5byr4Yrk+/8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060bcee8-e18f-4af3-44f0-08deec237ceb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 21:10:29.9640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyWh3ORimru5Fo/lO+PK6q/g0VwsvQ/M0meDbYF8NKw2+mJPvgGVOjOr8csWpp1UyQBKcLHgVnWX4khBk0rxZXegpSYDe2mkteZ+ymbs28w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6530
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BFB644000C
X-Stat-Signature: k97rks594pyx4sxw9hikotu5uy343u7p
X-HE-Tag: 1785186635-292840
X-HE-Meta: U2FsdGVkX1+JSYJrCnu9s8MbHyLtkP7JJ14nz39eV1/Brz56d8x0Mm2lIrnrf7PwP010lWbYu5WzgtjZcuQnHhcN6nqwaC+q8KwBFdRTht5nXYCW8xJTGyF6iSWtuVoksVSxrUdnt+9BW/7FsnAkGRd50tL0D0mMTgdsvOwQz9DcXoGCIcH39xLy6OcPUmqmdI7iI2dM6k/nnN/HwVOsAol2Q3Lslj/fzbtXADNDza0j+NXootf8RqoUtTunTMSnoMPsaCK1NTvUQaKJFiJFsoXQyTFvKSStHkIreCDG/WDvJxY8rGWMfGjm1rxUpxG3jnXojMg+xAhL8Wmd9CjVUHruWXjbWwNeN+loLuyvkNvNYCfEa0vIheRUyeKPnA6DvP2WdzJt8McvrFy6Qv6U05Ju3wVkcyqfP01+CQgQcz5tnU3yYaqjYupebGS4FUCwRTDcqoZJ/XzJCwORpksY8CwqrQkQzv/x348g1DN8PGPgCu7hfNXV4BF22H6DYPsXK6rXoKbu1r3FBjTr3FF7XQBPoPylEL2Cvs9b8OteqpwuF9IWs0H1mBS39MkaE7kPO9lMI16VDFUpLUg3+r8SS3s0DCDqJeLZir8JQSPzrPjeyPXLLn3iLJpdrw6J0INxT/QiSnRuEG5pi6MUh3PpnHgJdEkEnb7RWPtmVlvlMinmcJqdx4Uh817aXrFPJ5CraEk5+fexTMT7M4wFBvofbGnSPcCKODlgJn/Gm5JpOfbFVcNMk7C6skVEYuP+gngodZ2JHM2Xa24Oj6p2jqcPhS7InzKv8LQOhipOxxghGvRkttSlmG/sGWY7Z2pZflSQBK+BwsgOg7dsUAzU1aCJ5mbbyug9+PRg//IbKWykFzSKHhRqDCmVR+mP0gF+N0/Nw83jd88tnszKP8Q2apC1eNexC0eH3FlQFyiPFCyvhzU0bQB3rxLyEEFKzS81wzmYjn6Z5FsoPQqrYAAtvuQ
 9ZGhcggI
 8yfnhVs2bPBtze+80Rt8uisC+ymJf89rmc1X9x5EgHwc73ARS521+lCAUIODRZMlf+qgqMpbhUz5QjKkLIUKfmLz5YJRk48N4LhsaJb9ly27e35K0gSX1ZEQU1etP6z18fgSngeLTdyXhF1CLxqFGaJYyZHO2VXDAbxe/7+XIeLAnQyBfsD2OOAqlptbhBQH0p5aKhlDuMqpqcaaDSkaK18QYsYEc2wTcIlaQ3a4FbLwNmpcNW086O+slebFFkAJqvNPu2fNzlxBJMgwFPDFkvDk0+QRVql3zynWLndqklX2sow6D0Qo/G4l3AFeubR9Ki4a19KLp3wrdio5CxgW6qDFgkOL+USPVnA3HPmkMagApzjpURRbYG9q3QuDW+vwZlOwur5Y9KqgdnmB1h4NTi7uLUyE1FmqUfAsOz8qaI2bkbQKbMECHbd07bZT2uzrxAwV13qzO1JcZ6qF4entqVCFFENaO1S6csttZyOfsZi48D5O+eu/n+F1yWgkk0txHtELtiw2Ds+c1zxZsSgcFF8I74zJ5hAwda/Rafuii99VCXAEmFswaMeeHCVcHSeYAzGRVspD8W2H5BW0UvTyt2iqRDNyRF8ILXh0GlLl5acqTM6mxm8UMlGdfDDuW0JseGa8c42V6pjC4PIm8wrwbkBqsMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/26 2:36 AM, Mark Rutland wrote:
> On Tue, Jul 21, 2026 at 04:20:50PM -0700, Yang Shi wrote:
>> On 7/16/26 6:23 AM, Ryan Roberts wrote:
>>> On 15/07/2026 19:04, Yang Shi wrote:
>>> But I think that there are other issues with this concept that likely block it
>>> from being accepted upstream; see below...
>>> We have observed a few performance regressions recently, for which the root
>>> cause is increased use of this_cpu_*. We have somebody at Arm about to start an
>>> investigation into whether in-kernel rseq can solve the problem.
>> It is good to know someone is exploring the alternative path. But I doubt
>> restart sequence can really boost the performance. It needs check whether
>> preemption (or cpu migration) happens in the middle of percpu operations
>> then manipulate the ip to restart the operation.
> With the rseq approach, that check happens out-of-line in exception
> handling code, *only* when preemption occurs, so in the fast path there
> is *no code whatsoever* to check for preemption/migration, and no
> branches to cause a restart.
>
> Please note that with the approach I've prototyped, the exception
> handling code doesn't even adjust the PC; we just adjust a GPR
> containing the address. The forward progress guarantees (and behaviour
> under contention) should be the same as a single instruction. The fixup
> logic itself is trivial.
>
> Please see my message where I outlined that approach in detail:
>
>    https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/
>
> I expect that should come with a reasonable benefit, but I don't have
> benchmark figures yet as I haven't finished converting the xchg and
> cmpxchg implementations.

Yes, but it still needs prologue and epilogue which consumes 4 
instructions in every inlined this_cpu ops if I read it correctly. I 
agree it is still a very good improvement. I just tried to compare it 
with my approach. My approach doesn't need prologue and epilogue, and 
the fixup in exception handling code as well.

>
>> It sounds like it just moved the cost from one place to the other
>> place and it also seems hacky TBH.
> The existing (high) cost is removed from the fast path. A new (low) cost
> is added to the rare path where we perform an exception return into the
> middle of a critical section.
>
> I don't think this is any more hacky than percpu page tables. It's far
> more contained to the relevant pieces of code (only the this_cpu_*() ops
> and exception entry/return).
>
>> It may reduce the preempt_disable/preempt_enable cost somehow for some
>> less contended cases, but it may be worse for high contended cases.
>> The percpu page table can work well for both.
> It entirely removes the preempt_disable/preempt_enable cost.
>
> I don't follow your concern with contention. Any contention on the
> memory location is going to be independent of preemption, and if a
> thread is preempted mid-operation, the impact is going to be the same
> with either the adress fixup or percpu page tables -- I don't think you
> avoid that.

Contention means this_cpu ops is preempted and migrated to other CPUs 
quite often. If so the fix up cost may be high because you need to 
reload percpu offset and recalculate the pointer every time, at least 
extra two instructions. This case may be rare, but the percpu page table 
approach doesn't need to worry about the worst case scenario at all. 
Manipulating the local percpu counter is guaranteed by page table no 
matter how often preemption and migration happen.

>
>> S390 implemented restart sequence. Heiko didn't share too much benchmark
>> data, just confirmed there is no regression and I had a lengthy discussion
>> with him
>> (https://lore.kernel.org/lkml/20260520092243.264847-1-hca@linux.ibm.com/).
> As above, for s390 Heiko didn't implement a restart sequence; he
> implemented an address fixup sequence. There is no restart.
>
> The discussion you had there seemed to focus on the s390 implementation
> details (e.g. why he used an address fixup rather than a restart), and
> the benefits of removing the preempt_count manipulation (which all the
> approaches, including mine, do).
>
> Am I missing some key detail?

I was trying to understand S390's implementation so that I can compare 
to the percpu page table approach. As we discussed above, both S390 and 
your proposal does reduce the cost, but not remove the cost. This is the 
key detail.

I also admit fixup sequence approach is more simple and self-contained 
than percpu page table. So we were also seeking other usecases for 
percpu page table so that it can be worth the complexity.

>
>> Improving this_cpu performance is just one of the usecase of percpu page
>> table. The other potential usecase is kernel text replication I mentioned at
>> LSFMM. The idea is not new, someone else has explored it, see https://lore.kernel.org/linux-arm-kernel/ZMKNYEkM7YnrDtOt@shell.armlinux.org.uk/.
> That was looked at in the past, but people weren't keen given the
> complexity it would lead to, which is why it never saw much traction.

Some our customers are interested in this. Russell's 2023 RFC said "the 
performance results from kernel text replication are workload specific, 
but appear to show a gain of between 6% and 17% for database-centric 
like workloads. When combined with userspace awareness of NUMA, this can 
result in a gain of over 50%.". The performance gain sounds impressive.

Brendan Jackman also mentioned percpu page table could make his "address 
space isolation" work better at LSFMM, but I have not explored it too 
much yet.

Multiple usercases may make percpu page table more convincing?

>
>> Percpu page table can make kernel support it more naturally.
> Perhaps, but the only difference is that you've moving the support code
> into the core kernel mm code. I think the general concerns people have
> with percpu page tables still apply.
>
> [...]
>
>>>> Known Issues
>>>> ============
>>>> 3. Shared TLB machines
>>>> ----------------------
>>>> Some machines may share TLB between CPUs, for example, SMT machines may share
>>>> TLB between the two hardware threads in one core.
>>>> The per cpu page table just can't work with it. Maybe we need a new
>>>> cpufeature to indicate whether per cpu page table is allowed or not. Then
>>>> just enable it for not-shared-TLB machines.
>>> The architectural feature you're referring to here is FEAT_TTCNP (common not
>>> private). There are many CPUs out there that use this feature (not just those
>>> that support SMT).
>>>
>>> FEAT_TTCNP is mandatory from Armv8.2 and the presence of the feature only tells
>>> you whether you can legally set the CnP bit - it doesn't actually tell you if
>>> the HW does any sharing - there is no way to detect this. So making per-cpu
>>> pgtables mutually exclusive with CNP is a non-starter as all CPUs from v8.2
>>> onwards advertise CNP.
>>>
>>> Even ignoring the CNP problem, you'll end up installing the per-cpu TLB entries
>>> tagged with whatever user ASID happens to be installed at the time. Which means
>>> you could end up with lots of duplicated TLB entries all differing only by ASID.
>>> It's probably not the end of the world, but it seems... inefficient.
>> Really? I thought ASID will be ignored if nG == 0.
> The nG bit only applies to leaf entries (Page or Block descriptors). All
> intermediate entries (Table descriptors) are ASID tagged.

OK, good to know it. But I still don't quite understand how come percpu 
page table can cause duplicated TLB entries with different ASIDs. 
Doesn't the current kernel (one single kernel page table) have ASID 
tagged intermediate entries too?

>
>>> The only way I can see to make this work fully is to rely on FEAT_ASID2, which
>>> allows specifying separate ASIDs for TTBR0 and TTBR1. Then each CPU can have
>>> it's own (permanently installed) ASID for local mappings in TTBR1. That would
>>> solve the CNP issue. FEAT_ASID2 is optional from v9.4 and mandatory from v9.5.
>> I agree it is safer to handle CNP problem by depending on FEAT_ASID2.
> I think that depending on FEAT_ASID2 is a non-starter.
>
> There is no extant hardware with FEAT_ASID2, and I don't think we want
> to maintain distinct versions of hte percpu code accross architecture
> versions.

I agree it is not perfect to have different version of percpu code by 
depending on architecture versions. But AFAICT percpu is not the first 
one. We already have KPTI, SW PAN, bbml2_noabort, etc.

Thanks,
Yang

>
> Mark.


