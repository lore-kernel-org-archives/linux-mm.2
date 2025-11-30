Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B766ECFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 23:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9D66B000C; Sun, 30 Nov 2025 18:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9586B000E; Sun, 30 Nov 2025 18:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872296B0010; Sun, 30 Nov 2025 18:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70B2B6B000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:23:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08E89BE448
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:23:48 +0000 (UTC)
X-FDA: 84168852936.18.C698090
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2EE418000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:23:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D96fSeib;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764545025; a=rsa-sha256;
	cv=pass;
	b=5aIe1q0VfwYqJC+0nWIhpRpiCzyIEZfMvYEoGVLh1HAOOfAItuNjuGp/36j6cJXw09jBL5
	KHAAmw2uiKujLo54rGKVEG+BUMEsqsQPsO3JOnXHCpo3kgTxvptNhkxZsV+lmjahYxFfjc
	iDPjVHeZ7VFdrO232Rkb0OS3561B/eo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D96fSeib;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764545025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RP1N0ALNZbzQywE9FyLnOH2Mbd0kt0GCOD0Mvkt2hS0=;
	b=uiwXa9a3b5E+79hXe4ZeJESVqRUhjp6eKcu6u5iOA2x4Np4r6OO1Uv/zc0PbAoGtu5pSSM
	wSV9FpNpQMhjAK7D5RxlTDZzYiyPdZ/bVHKVqoH8YNOMi2qk6MVGk1xMjFwE9b5HRAQAKS
	IcEYVAGa//tiYloQ1HoHH6uV2N9QSL4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VAVIEA3AJRQjKHHkW4j3ubXAvz1giatuWPz6+mhGMdk145h6NFOdtLDLuCmHzBsME+BUCGhKsalT93YHmS8iJxTTx0M5SWHvbPKz37OApKhHgkq0s0Wvwc1GIMnMbhkR5ex+TzQVFvfaLQiAvb43Vs52vhy75pAVNFsiGnzZ/zz+W7O3nmzFCh66oGb+j1/pNKvCXO4APCV65iCGjifAHUevqEtB3wjujt6XWsZUxBRpbINeilc41ZfycfR3uya3/dTGjn3J9SyO1KBDh/TBUCGEYOUepcNSWTRUMGEbYuOV3FR5cjvf3ThiR/PfKq3iJPQfhh/3/LRFGXtnHukPiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RP1N0ALNZbzQywE9FyLnOH2Mbd0kt0GCOD0Mvkt2hS0=;
 b=blEywvHGs18VkXgTodwnMgpepxaFYFqyXwONAh7L60rss9FB3r5BZ+1NCzABRAp+KfnruqQQGdQDnlFxs9ZblZ/ooG30sDeq9tB0PbFIuHoSoshA6CB0oeXYxHQuZHu8H+M/C2dMkZLMzCJQUaG0xTteUW1pIsgG4wzWSIyNoLLcdmh58LrDq0iMaK6+Ipp/OaCb4/V0L9iepgcasgLkW8FPymc27Bu+KmNS7F9m+5eM+XGDqWW5JxxCGzC6R8Vgv3LIW3iLd5a8YK1TFMa+emXO0PWgmFMAizXl6LQHUPjG9FD5H4CKwy7v8BfRISiUA264nK6DYi4AFRiRDg6XwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RP1N0ALNZbzQywE9FyLnOH2Mbd0kt0GCOD0Mvkt2hS0=;
 b=D96fSeib8rq1IydpstM+5qEbScWpbFpATmngU7VRRz8rIQbutq8/twVpXc9sbu/A56GNmGbU86eVfSNdmW8he++zC9FlkSCcNTtaoc4AYOB657XHfdZb9tKgpFSAF5kp3wjEMZelMKGfJz3UXswkq+/I937FzrMnYFjGON/JVkSusETTXCJt9WJtSq05iClemV9fDhHNplWlcO2oOp0mG1pXXisKqI7ah3nxTAa8bYScxt1++aqYi20A3U4lQDqHBwizZr86COvTvVh3t6iGe1b1q0OgM4nMvb3X2a8NeuOyOL6PBN8qSdGQ4+uk0Nv9bozz5Uz5kG1ZpmyLdwZHOg==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 IA0PR12MB7749.namprd12.prod.outlook.com (2603:10b6:208:432::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sun, 30 Nov
 2025 23:23:37 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9366.012; Sun, 30 Nov 2025
 23:23:37 +0000
Date: Mon, 1 Dec 2025 10:23:32 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org, 
	balbirs@nvidia.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com, 
	lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, 
	rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org
Subject: Re: [RFC PATCH 0/6] Remove device private pages from physical
 address space
Message-ID: <anu425gyhd5w3boribueuyckjlg73r356kkoy6iv6dcsy6b5ar@5qnbvtymgmje>
References: <20251128044146.80050-1-jniethe@nvidia.com>
 <aSn2kXNG7X0UZJFW@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSn2kXNG7X0UZJFW@lstrano-desk.jf.intel.com>
X-ClientProxiedBy: SY5PR01CA0093.ausprd01.prod.outlook.com
 (2603:10c6:10:207::16) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|IA0PR12MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a84b86-0410-4e51-1011-08de30677d09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YnhYRGVOV3N0LzUxQTlMVGdteVY3VEJWOEU3SnhpM2tpanZwcFVvL2FrTWF0?=
 =?utf-8?B?MHZ6RlRPbnVEamJNcE03cjB4dzZtLzJnNXY3aU43dXhsSE4xWTNkSmR0VGJW?=
 =?utf-8?B?SlFiVUFrTU5OWVk3M01wNUJpWVNaYmxOVkZQbjlyaDUvOER2alNRdlZCeFVQ?=
 =?utf-8?B?WkR6SkR5VU5PSHpiejJjRHgvK1ljb3dtdUxnWGJMTk5CbWI1aUd5dE9mMzBv?=
 =?utf-8?B?dzdsY09UeEZ4VG5KdUtERjRVT1JBYndWR2czcWw3dXdjaE9xaEkzNzZxejVm?=
 =?utf-8?B?T0JINE9tZ1p2V3IrUTNyVGFkRnV1dU9MNVIxTzVSSWFkTGhIUkNvQko1Y20r?=
 =?utf-8?B?RzFDQUFjdC9sQ1NlQit6ck90SzNaQ2J3NmtwdHJSelNsWUxhaG8xWVhvRkto?=
 =?utf-8?B?NlY4T0lnQ2QvMGk4aGxvNW9JUVdIYlR6eE1nQkhlWkx4MGhWNkgrcTZ3UnV1?=
 =?utf-8?B?anFBSUFVUitLenJwRE41REJ6cXYySUtqSXdaQ2NsSG5pTmJRNkVoZUxaazBN?=
 =?utf-8?B?Y0RPMHFMYzhoWWt6YjJpNTh0Lys2dExiZG5iWEhkMGw3VVJwSE4waWFWYzVO?=
 =?utf-8?B?UE5oVzlyQ1hMOE1XUDZMWGI4WCtpREFmVzVQVzRjWE9jSXE4ZEdycTBtSEZV?=
 =?utf-8?B?MHNxY1NXM2xWdmRiaDJGb2tINkxPUy9iaVFsWmIzMFRkSTlncEl1TzVWZ2g4?=
 =?utf-8?B?ck5OU21vRmlZYW00V3ViMVZjazlKbFVYcE4yZXpBU3h5dm5DTjN1S3ZNeFkw?=
 =?utf-8?B?b1UrRW0yR0NMK3phc3JpUHdEKzFXcXFvYlFiTXAxS3N1MzlnN1ZLUmovR1NC?=
 =?utf-8?B?T1RWZWdQQlJMTGxVU2Uybm9MRjNTSXNPVzBObDVGRzhNMGR3MmN6VTJabWxR?=
 =?utf-8?B?aEZDZnZuOVZ0TzZYa1hjYWdvcjJKeWxqS3pYOWxjTjVBdmFkaEJRWlpPaENW?=
 =?utf-8?B?YVpYcE1LM0JxNWN1UUlFS0NSZFZnbEpZT2Y3Y0dnTGRRUzkvY2VVMnhyZXhk?=
 =?utf-8?B?K1FDekNwRi9iNUpER1g1OU51TkdJTi8rTkphUlJ0VENNQzlwbk14NnRFM0Z3?=
 =?utf-8?B?TTN0a2szY1lBUHd2b040MUM4cVM5b2ZtRTIyTUg1ZG5rbm4ySG5xb3YxRktt?=
 =?utf-8?B?MXBmNGJXVWtNSUNRNWowbEFPV3VhNlFoQnVzZnY1eXNxUUc1azluaDkwM3lX?=
 =?utf-8?B?cFBXTVUwY2tGK09VVXBmalExK3ZvOW1RbjB3Z21XbHBLeUljK2poMmgyTzVM?=
 =?utf-8?B?VHFWQnNjblhLMW5RaEJ2VkIxR2FYWGMwM0RwQ1IrMS91bzVUdTNZY2NDVW1O?=
 =?utf-8?B?R1VjYTFIRGNCSTNCZVFOL3BNSE1OcVNZRnlZNzFQc0xTV3FXMHVlSkxvOEQ5?=
 =?utf-8?B?Tk85YnRFYTZwTStWa1RlTTVBNFh1bHlrdlAvb1VNdVZjSzc1M1pJeTNlYTVL?=
 =?utf-8?B?RUpDNU80aC9MQ3dPSlNzRGgyVFZMT0pvS0E1VmZ3ODJCbHBGMWpiVFo3MGpF?=
 =?utf-8?B?Ukx5cHZnZndyZk9OdmZhTUlUcjRNaWMvemEyZG1YaWRiVnA3VVVORUUzNFU0?=
 =?utf-8?B?MjlLZ3R5RGFOendMZ2piZlg1Z3RYQzFJcHExY3NYMlpUNlU0bmtLbTdKa1F5?=
 =?utf-8?B?cWRoMEhRbnZkTHNUOVlyaFhiV2M3ZWcvQU8yTk1KUlBzRGlPZnVwQW56b0tE?=
 =?utf-8?B?SCtzTkdVaUZXNW5NWjZmN21YeW1QdjY3eW1Kb3FpdHdPb003QjhFd2hoM1Q0?=
 =?utf-8?B?by9XdHpGd2RaOThzTWNKREVIV3NZSXVxSDN5dE85S1VmcUFsN0tLN0VEb3U5?=
 =?utf-8?B?Y0dDR2VwTkh3V1JEQkV0cDJaaktjVEt6UTBUWTNDK0FpMGJjVm5hRDlnQjUw?=
 =?utf-8?B?TG5rQ3QzYTZVNDM4UmlSRXRYTU93M3A1dExUMlV6V3ZFSXhIWEVSeGhUWXdn?=
 =?utf-8?Q?7T1rgmMA03FbX1ElfavFUArC2PrOr5rn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTRtbTZVYU8waUVYZW1JSHJtc2FTcWphbDM0VTAzbThtZlV1YkRESzQ0YTBX?=
 =?utf-8?B?cGE2MW92MWVRbW5rQmJZTmR3WGxPVlVrekdMc0JRamdWTFB3SGRQUEZOdUFP?=
 =?utf-8?B?NytOaTNYaXJUTk1tOStNTjhDNTJESGxkeXQzSjI2NXRWamljZ2gybHU0UU9r?=
 =?utf-8?B?T0ZqNUQwckVKWVoyQ3Z2cERMK3FYalV0Z21mcnl5d1I0U05UTVRtRzE2U2dT?=
 =?utf-8?B?a2sxUFRxcUp3a09CZFVjTkx2OFBTTHBjNjEvWjMzZkJxaDBxcUZOZ3QxYi9w?=
 =?utf-8?B?bXNHRURiYVZETnlFZ0pCekZFNXhxamIzb3F3cGFhVE0zYTRRYTRkMXMyaWFw?=
 =?utf-8?B?M0QvcnNBNG5kQ0RvZTAxRVpueU85NFV5LzdjY0hCSkdwdEE5QmdrV2VNSGNR?=
 =?utf-8?B?K0lqcExxOXpJR0lmeWw3SFY4UFhLZWw3Szk1RFpIV2sxWGp6NEFsR1BnakZ1?=
 =?utf-8?B?eTVOWnFLSUs4cjgzc044cUpzai9VS0tLR1h6WjFSQkN0bkFrdm03eHdtcmtl?=
 =?utf-8?B?TnhUZGNZanB0VXdsZEp1SmtjbWpnS0FIOFdnSE9IVmE0Q0Yzc2NmbjRiYUV6?=
 =?utf-8?B?aTFnQmhPR2RBQmZQeXRiZnluQnhhc1NGeXl6VXAvWS95MW0wbmVqWFdWQi9J?=
 =?utf-8?B?Ky9DTWc2ek85NG9vT00wQyt0MmRZR1VsSS9HcjloN0E5ajlUTnRzcGpFeHRS?=
 =?utf-8?B?dGpTT0lOR1NqMzl0MHhoWWpzMmIycnpzazF1eEFkRGRhK3ZCTHAzZTF0TWpl?=
 =?utf-8?B?QnpiYlIySFNCRlMveTBENDl3dTJ1bElZWXo3NlBveUYxSTdyTHBUUzhqK3Va?=
 =?utf-8?B?SEVuRnRqTG94d2F6dmRVK2d4TGR5dW81ajZxZ01BQ205eitqYzNMVHlLRjJj?=
 =?utf-8?B?V2V3ZG96QU1uQkl6MWkvdytnMmdRUzdBYzZ2QW45TjVaMHFZZ0xsd1NUQXN2?=
 =?utf-8?B?RVBhUjZWMzAxODI0dEhZdVY4cHNCVjZ0dVpJRHFqZ2hNYjFCM3J3Y0dsVlFa?=
 =?utf-8?B?R1RTaVpDU2tyN3RWdVJiVjlnK1dGaWh5WXNCTnlySlo4QjdYSHdvYjRDaENk?=
 =?utf-8?B?Rk5PWXhqVHcyL0pOYnpKY1FTdExxc2pGVHNZbVc0cFRGTmpmZnAvVnJYMlFG?=
 =?utf-8?B?ckM2RjRRUG5UNG1Rb0laSnVHZlRhRFJkUjR6WUZwL2QwM1NRNlhtcFdxNnRV?=
 =?utf-8?B?eVNtc25RaW5tcmlzdTdXWm9rYkV3ZjdRT2UzcnhWQ3RVMml2b2VXdU9iakUr?=
 =?utf-8?B?UkpmcENXY2dEczkzOHJNWnBHS1hlQUwvbUdwV0R3SURRSUhxeG1SRmN4cC9N?=
 =?utf-8?B?ZUJCS2wzWlJmdGVrNTNmWE50S0NIbXZvaXJGYlNOUFJlUXFOdWVlcUp5dTUz?=
 =?utf-8?B?KzM2em9rUVdlcHlKMnVyd0M1YzUvUDRucTlhRWZnbG5Zbmk0akE0YUNhbUNi?=
 =?utf-8?B?L2g5UFVIMVY0NFU3emJsenRSL3hraHRoL0EyODI4L3dvMXFuRzU0ZzBYYjd2?=
 =?utf-8?B?eTd5NkJUeUVBMVpkeVIrK1Ruc2lvN0M5M1crN2NaUlhPYnlvdjJVeXJ0bnhD?=
 =?utf-8?B?V3ZqUlVTSGdmU3FkQUhJZFF1c2NacHh3QS9QcFlhNkYzRk03cUdOM3FaTGhh?=
 =?utf-8?B?MVB1TWZOMTdaVmZscm5TNmJjQnVLTm0zTkhpQTI0NFRmN0hvV0V3a29PaEZS?=
 =?utf-8?B?YUNCcWZBdDRPNHhCM25WMEQ4OFlNbVBoSXk0WCtHdk5DRmtvV2N4ejdscDJR?=
 =?utf-8?B?ZSttNEtRNk9MczJDNVo5S3ZSL0JuV1RoQVZsamQyY2s0UWZNZ0xaN1psZnVa?=
 =?utf-8?B?UGZhMG9nUDFXanJQcHBsbC9aQWFxK0QxeWxLSWc5dlBOTkVNV0xZVFBESlV6?=
 =?utf-8?B?aG1FUnlyNVZnV0R2bnNUSWtoZXFwdEZUdDJ2QTRXSnNSVWtzdFF2VmFXNkZq?=
 =?utf-8?B?eUJycCtwMEJMMzArOGdzZ3N3TEJQTjdVVDZuMkJBbHFtbE5BemxxQlFPQkU3?=
 =?utf-8?B?SzVzWnU0VTdNU2NOSVo1RVk0UjdXZHY2VmpRL3J0Sk5TNVpuWHhCc05IN24x?=
 =?utf-8?B?TTZpd25FNlZaL2FIUlNlNzJyZUl4dTZvVk4wSU51RWYzWWJJTmZZcXZaWHhR?=
 =?utf-8?Q?i0eYmNkDbLhxRWkMKsrSdxI0H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a84b86-0410-4e51-1011-08de30677d09
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2025 23:23:37.4303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwayP0xn7lfR7yhtQ01mbasiou7gge8GkLVu/RLWiLvohwRP9KLt5JsrOKuDwM2aiMiJymBCAfPr6huTucwqxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7749
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2EE418000C
X-Stat-Signature: ky1ff1i9a84365fsa7fpf5i94jn85goz
X-Rspam-User: 
X-HE-Tag: 1764545024-173019
X-HE-Meta: U2FsdGVkX1+ZwcN+CwMAbXLkZY9YlTzLWlcSJh60fsld8rv8unRtKj1z8yIZe5bfOIrzTrCO5QrtBADmmnvlWC4W+MURnweFrhlpxkav3rQrjAwEIQKLI96gp4J8BgeqdwPEd2clb9wovzPUTrYHbQrx5GO+ZBeFa65qnGC07sn0Fav63FTY8AcH1NzU+0OJLzTeGG2Z4sYa+YJ8CRBAg8gkZyvM/csqOlxlc8WwY16gBpxunyw3cUYR/jBrLcxDPToFTsTDm1GOxHygYV3poGavM6Oly2xvJwiON+qThoWzQK5c+32XDG1QZZVcBufGrWUqvlD1NBEntoUhxsVZGQA5gAy+OUu1KHhDlKjBp/KxPhpjc/3Oxa8+WbXyBGCAm3Je7BSOSmyNkeSaDG4Yg4oBbdOotQ1Omwc44415WTjCKZXKM6hIZenyyNmf3zyDZf5+Fg2FAlircWSiQ7HtYhHuHOJYdQNLKUfTxA2kJR8f72B+zc4LeBA9EdxsqJE6jtYvul76ZnGM2nClmG2rSuna+gT/m61kMJlXUXvTDrK6bIkgj0vpjtvyO8zKBOLrOUMKpkXfDL0hgOwbn/o7pb/Vmtae8ztbTXD3diqOXh8CM1BeocWjsTHTpVWqC6f4LHXH5icS/D/Ixizc3iHDHwf5n+b7+SSmIw0UyWbpmzaGn4eTDYNbOKsDsm67jJblBgz3XQeuuJjWoCsJQZDEviJCyjSsMWe/S/faOiYFaTRWkZkd5qa+PuC8Ga3GsGaWJ6kRadw5zCEI+zIAv0yoFPTvbVK/Jm7mhLh2WEGqIaeLOIYXR5aV8RPzOyv8fwqxgvrJEleUCCnGtHdFv9oDzul5SeRB2CBgZJ6hOcNJDniCj6JpSIoAvE0onbM7YNh6SeYZ5n8/D7lLUSKi5WHAcCy889gPkJDpn6T84LMH0KrZ72Kd7EwIqZBxFgPl7tgNkhgkPaZz/S7VINgnWEd
 maBDPYAz
 E3frFU9H/NNLaBqhUhJmyc5LBksV8+l5AqCds7Pbw1EIJgZ1hXCS1BhFF/fHdaEox4IOFblKWE3/F2cknxCHZx6yZIB7TsulkFgoA0SR/otsdtZB4CbObV7QIDeEvY6u2uiZqQy/BCi66oDFgK8CRb8Rq2UL+VxCftVCnOSS9ZOXkjXaLp5H3pzAhrSjKcTkeJ8wEwkkrqdsjbVgn98bVNtlGsYfvaYiOY/+TZS5sCyK/hu0nWdrUIHXub+ZoYgyXRjw1HeRH9+GPauQSvMAY/S/CQF8ecrCvhfhauODE8GfV65s0AbcHvh4DB2FBN6ODV3QVuikhncOKVjta7qa5gNCRJddmDAvOMwvDMioOS+xe2RKybERH8EIp9MLlT9cVVtL/dessaDaU5REphp16LFCzrXifj0fC8rEDt/p0695ripNXZjm/IZmiIu3bD8BhQb8apWE7TAowhhVJTJSSczrXwFGrFYKCTsr2GKwF49spDwZOv6e4GalwWXkB6P/dTXsXkFxBg72vPzrMYDmd9botI06bjCBGciFpcbT0vpOTk9VIlbFdemj/Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-29 at 06:22 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> On Fri, Nov 28, 2025 at 03:41:40PM +1100, Jordan Niethe wrote:
> > Today, when creating these device private struct pages, the first step
> > is to use request_free_mem_region() to get a range of physical address
> > space large enough to represent the devices memory. This allocated
> > physical address range is then remapped as device private memory using
> > memremap_pages.
> > 
> > Needing allocation of physical address space has some problems:
> > 
> >   1) There may be insufficient physical address space to represent the
> >      device memory. KASLR reducing the physical address space and VM
> >      configurations with limited physical address space increase the
> >      likelihood of hitting this especially as device memory increases. This
> >      has been observed to prevent device private from being initialized.  
> > 
> >   2) Attempting to add the device private pages to the linear map at
> >      addresses beyond the actual physical memory causes issues on
> >      architectures like aarch64  - meaning the feature does not work there [0].
> > 
> > This RFC changes device private memory so that it does not require
> > allocation of physical address space and these problems are avoided.
> > Instead of using the physical address space, we introduce a "device
> > private address space" and allocate from there.
> > 
> > A consequence of placing the device private pages outside of the
> > physical address space is that they no longer have a PFN. However, it is
> > still necessary to be able to look up a corresponding device private
> > page from a device private PTE entry, which means that we still require
> > some way to index into this device private address space. This leads to
> > the idea of a device private PFN. This is like a PFN but instead of
> > associating memory in the physical address space with a struct page, it
> > associates device memory in the device private address space with a
> > device private struct page.
> > 
> > The problem that then needs to be addressed is how to avoid confusing
> > these device private PFNs with the regular PFNs. It is the inherent
> > limited usage of the device private pages themselves which make this
> > possible. A device private page is only used for userspace mappings, we
> > do not need to be concerned with them being used within the mm more
> > broadly. This means that the only way that the core kernel looks up
> > these pages is via the page table, where their PTE already indicates if
> > they refer to a device private page via their swap type, e.g.
> > SWP_DEVICE_WRITE. We can use this information to determine if the PTE
> > contains a normal PFN which should be looked up in the page map, or a
> > device private PFN which should be looked up elsewhere.
> > 
> > This applies when we are creating PTE entries for device private pages -
> > because they have their own type there are already must be handled
> > separately, so it is a small step to convert them to a device private
> > PFN now too.
> > 
> > The first part of the series updates callers where device private PFNs
> > might now be encountered to track this extra state.
> > 
> > The last patch contains the bulk of the work where we change how we
> > convert between device private pages to device private PFNs and then use
> > a new interface for allocating device private pages without the need for
> > reserving physical address space.
> > 
> > For the purposes of the RFC changes have been limited to test_hmm.c
> > updates to the other drivers will be included in the next revision.
> > 
> > This would include updating existing users of memremap_pages() to use
> > memremap_device_private_pagemap() instead to allocate device private
> > pages. This also means they would no longer need to call
> > request_free_mem_region().  An equivalent of devm_memremap_pages() will
> > also be necessary.
> > 
> > Users of the migrate_vma() interface will also need to be updated to be
> > aware these device private PFNs.
> > 
> > By removing the device private pages from the physical address space,
> > this RFC also opens up the possibility to moving away from tracking
> > device private memory using struct pages in the future. This is
> > desirable as on systems with large amounts of memory these device
> > private struct pages use a signifiant amount of memory and take a
> > significant amount of time to initialize.
> 
> A couple things.
> 
> - I’m fairly certain that, briefly looking at this, it will break all
>   upstream DRM drivers (AMDKFD, Nouveau, Xe / GPUSVM) that use device
>   private pages. I looked into what I think conflicts with Xe / GPUSVM,
>   and I believe the impact is fairly minor. I’m happy to help by pulling
>   this code and fixing up our side.

It most certainly will :-) I think Jordan called that out above but we wanted
to get the design right before spending too much time updating drivers. That
said I don't think the driver changes should be extensive, but let us know if
you disagree.

> - I’m fully on board with eventually moving to something that uses less
>   memory than struct page, and I’m happy to coordinate on future changes.

Thanks!

> - Before we start coordinating on this patch set, should we hold off until
>   the 6.19 cycle, which includes 2M device pages from Balbir [1] (i.e.,
>   rebase this series on top of 6.19 once it includes 2M pages)? I suspect
>   that, given the scope of this series and Balbir’s, there will be some
>   conflicts.

Our aim here is to get some review of the design and the patches/implementation
for the 6.19 cycle but I agree that this will need to get rebased on top of
Balbir's series.

 - Alistair

> Matt
> 
> [1] https://patchwork.freedesktop.org/series/152798/
> 
> > 
> > Testing:
> > - selftests/mm/hmm-tests on an amd64 VM
> > 
> > [0] https://lore.kernel.org/lkml/CAMj1kXFZ=4hLL1w6iCV5O5uVoVLHAJbc0rr40j24ObenAjXe9w@mail.gmail.com/
> > 
> > Jordan Niethe (6):
> >   mm/hmm: Add flag to track device private PFNs
> >   mm/migrate_device: Add migrate PFN flag to track device private PFNs
> >   mm/page_vma_mapped: Add flags to page_vma_mapped_walk::pfn to track
> >     device private PFNs
> >   mm: Add a new swap type for migration entries with device private PFNs
> >   mm/util: Add flag to track device private PFNs in page snapshots
> >   mm: Remove device private pages from the physical address space
> > 
> >  Documentation/mm/hmm.rst |   9 +-
> >  fs/proc/page.c           |   6 +-
> >  include/linux/hmm.h      |   5 ++
> >  include/linux/memremap.h |  25 +++++-
> >  include/linux/migrate.h  |   5 ++
> >  include/linux/mm.h       |   9 +-
> >  include/linux/rmap.h     |  33 +++++++-
> >  include/linux/swap.h     |   8 +-
> >  include/linux/swapops.h  | 102 +++++++++++++++++++++--
> >  lib/test_hmm.c           |  66 ++++++++-------
> >  mm/debug.c               |   9 +-
> >  mm/hmm.c                 |   2 +-
> >  mm/memory.c              |   9 +-
> >  mm/memremap.c            | 174 +++++++++++++++++++++++++++++----------
> >  mm/migrate.c             |   6 +-
> >  mm/migrate_device.c      |  44 ++++++----
> >  mm/mm_init.c             |   8 +-
> >  mm/mprotect.c            |  21 +++--
> >  mm/page_vma_mapped.c     |  18 +++-
> >  mm/pagewalk.c            |   2 +-
> >  mm/rmap.c                |  68 ++++++++++-----
> >  mm/util.c                |   8 +-
> >  mm/vmscan.c              |   2 +-
> >  23 files changed, 485 insertions(+), 154 deletions(-)
> > 
> > 
> > base-commit: e1afacb68573c3cd0a3785c6b0508876cd3423bc
> > -- 
> > 2.34.1
> > 

