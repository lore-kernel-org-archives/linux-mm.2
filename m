Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD566CEACCC
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 20:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264CC8E0008; Fri, 14 Nov 2025 15:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C7A8E0005; Fri, 14 Nov 2025 15:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B6F8E0008; Fri, 14 Nov 2025 15:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 021418E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:27:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82526B8B3E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:27:07 +0000 (UTC)
X-FDA: 84110346894.22.5B2F01D
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	by imf22.hostedemail.com (Postfix) with ESMTP id ADEDDC000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:27:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AmBaor1h;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.56.60 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763152024; a=rsa-sha256;
	cv=pass;
	b=lOJAzj/EJgRxOb/nBhyEvdlJ85lhKqLE3KTBE5EZfi9M06XUAs8NKrFYF5CfgeeYzDSmuM
	kSbjQ4WO8Nw6v11xEkEaz/m0/5xl6ORQMYTNRoXV5EqVFzrHecPygG2jX0gQewgMwEdZPl
	+Ivm0pPHcM+Ek1yN/vf13EzqI6jQBWg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AmBaor1h;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.56.60 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763152024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnaldgOVI8hU+CJuVRIUzHpB34MrOKTm3Rrlni37Mr8=;
	b=l5dyZoMCXBdO1ffgh5/MLNizzCoDIYeSC81U/rcaP9KRVEiM9CHVZbAmaKxKx5WHBr3Bal
	DdROP/vxCpTHisQCFxuozPU9Czyb1NpMoT0vGwkj2RlgqbJu1R0Z38vMSsymrMlbqMDyB7
	v9sV8f6j24qkHbUVUHoZbkazEXiNwDo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=btBvggtkGCo3xUlrP8M2zo/aIAcc7+BXJVku/rDBJz6S/aw2v5t6KLttpGd4qltoTj1DmnNdzjpLvq7DO6+Rxy12hAauUG+GLzBcIw8q2mwDcTFL6C8im9/utEn3weJD4cp1+fgK2h8+Pop/xsUk850T9Oqa0OIAv2otJPOoqdg7tIC2Ewz5ayCgkAk9MjGqGxee1QsObcNhAOCkTWuT9gH+rT8YSIWFC+C0fTEEyQY7ezNEwF7/m0crWBrcaBbbNnLmmtk0MTr5ZJ5wgAdiXtIJ7fPy/pvhFyM2gO90r7OjtlBLkaA+v10AMdxjDBtve/cPt/aamxjufyY0/BIUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnaldgOVI8hU+CJuVRIUzHpB34MrOKTm3Rrlni37Mr8=;
 b=ekkeN8QhD/hLNUX7neeLMUaVNK47sn5RG9XYPJSBeCLvGP4txaoEMo0VL9Ryg8e8rEx/Raf331Fq9jNR4P/RCsZJOGL3Db5Mp3jwmC4aj/Nuk9FYb7SjBfPqhLQDJnJJjViCAzWY1Pjar6uOffuL1rAepnoAHsW36/Fos0KmGr6JWuR+4wGtA2x5HYBnlYZvUloHaecVBTlHN59gpRH5JFvDTcl2iRL0Ho/Cpcum9/qVil9cKfdkKpx3sssj80sdNGQEHLzGhIAVn/D0a+5nyAFZLpo17mxHI5AD81V1J5Doy+u1zeYG38d36jSi2F4zdExP6SFIIE5s9ZlrMqoz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnaldgOVI8hU+CJuVRIUzHpB34MrOKTm3Rrlni37Mr8=;
 b=AmBaor1hsJIa0y8iG/JR9Nfm+a74vRvlGNNlmOlaEBQUqooh2udGszPHpSlGqo4G5rfHM5dWsKaQS4FEraOqFxosiy6uJeg/pHCGEcHsbmF9TLsYEkRW7bfc7Rb0OyXN+77nTi8Ve7h9ySNdSPD9eTuYjbobkjWivhwj94hA7SFgSDGxEhIulp+IsASJkH2w6CttFX5O5tYLo0Dbgh13IgdyF/eMObKbz4gW3upVA7OOUk3KVKu5FWE+TnXpQGXbyyjIlytlSqCg/J6U8rVAVlOowyFGKFfSYY/isFqv3x9IeXHQj9w+a4fKqEmSYTWQN6gyLO7IJXxB3ozwYCbPtw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CH3PR12MB9249.namprd12.prod.outlook.com (2603:10b6:610:1bc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.17; Fri, 14 Nov 2025 20:27:02 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::d622:b3e9:bfe1:26bb]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::d622:b3e9:bfe1:26bb%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 20:27:02 +0000
Message-ID: <70d7ef58-8556-4aa4-86c8-b7ed79505471@nvidia.com>
Date: Fri, 14 Nov 2025 12:26:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] Fix the source file annotation information for the
 "FOLL_WRITE" macro copied.
To: peng8420.li@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: david@redhat.com, osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <20251114161127.193707-1-peng8420.li@gmail.com>
 <20251114161127.193707-2-peng8420.li@gmail.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251114161127.193707-2-peng8420.li@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::26) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CH3PR12MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: b567ec48-ce4e-4dee-77bc-08de23bc2b41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGNYUFk1MjZ4ZVM0c3QyMzFSYzg2OEkxa0x1clQzWDN0bmVMSUExa1NhZTJD?=
 =?utf-8?B?THlDeGx6aXFid0N5V2lMaXFFZDZSRXBZSlhjT0g1eEt6WlFYZTk4Tk9GeVBH?=
 =?utf-8?B?QU5DZlVPSVdDQlA1K1VDUkJ2bUN5RWI1UUVHWkV0MUZCMi9HT1lxSFBLSzNa?=
 =?utf-8?B?YkdLZ3VZcjFvaEtjRnVVWkMxSzJKTDlMQ1BQNWVkT0NBWHErR1MremxxUHNs?=
 =?utf-8?B?b2lsNzRycVlVMlJ3anlxOEVnN0ZDMVJIRlNBNjBzMEh4ZUt4OWZaalVVYTNq?=
 =?utf-8?B?OEFYa1p0cVY2ZythSU9PVUo5QzV2SnpQdG9kYWdRQUw2cjBzMC9sbG5HNWNH?=
 =?utf-8?B?WGNZMEJoWDVrWVZST3FkZUwwdXJSeERJRjBZdHZRUFVONk9relBGc3gxTkNT?=
 =?utf-8?B?c0cwb3lnNzVkNE55c0NlVG9tbituVWk4WUg3WnA5MldNcU1kR1B3Qjl5Tzd1?=
 =?utf-8?B?TlgyWTl2NGhJTnpZMWVxa2NJL0JENG5neFJuNGtrak1XZEttNU9MYTUyS2t0?=
 =?utf-8?B?N1FNOC92N3dnUTVFbzhiNkZaQSsxd0t4UjBWUUplT3RXS25TVXhLQU9wVmIy?=
 =?utf-8?B?SWpWVURINytlVkcwQ2dwa1Y2VXVvbUljU1ZJaHQ5WllEa3JYV0FGdWgwWVNF?=
 =?utf-8?B?ZllLM2xvd2N5K3lFV3NoMmVvM2M4VmZyN1NRMllBU1hnbUhaRCtERXNpRXp5?=
 =?utf-8?B?ZjErWkxnaUdlUUFvbDJ5NTNtMjU4QytLaXNtUVhmbENSY2t4MHhYeWdGc1p6?=
 =?utf-8?B?L2Rxc0JiMW1Kb0Z5MUNRcXRSczJ5b3dzVGlpU3RZeGV6OVg0anhNQkxjRkNm?=
 =?utf-8?B?UkNUdWFWa1NFVWxNRFB0REMxbGdwTzBnR0VtSHI0RnJ5REhDNGRtZHBZME0z?=
 =?utf-8?B?ejZrbTF0QTBzdW1MdWpnT3MwY0RIUVY1UXJUZ0hBNVpQOXFLQU93RDJ0SzZS?=
 =?utf-8?B?WlFJS3ZZOEZ1eVo4QjRiT0o1RHgwNFlnMGJWK3VOZTI4aHo5OEVRMTlUU2JF?=
 =?utf-8?B?T3FTTmRMcktBWG9Qc1hJR0dSWU1vNXBkM01tOTU2b3hFYzd2VDE2OENHQWcx?=
 =?utf-8?B?TjA4cU9XL01TREhkNUJBbG5jMjhXVU84RlNnN1RINjR5Z1NNYm1QeWljaW1O?=
 =?utf-8?B?bUF2aWpTb09rMmxYMFZBenI5NktFM3NpODE0STZ3bkRjeFlCTE8rdjRYeVBK?=
 =?utf-8?B?RmFFZGp6ekcxaVJlcHE1Z2NaSzlGZ3d6TFpaUHVta0dZUytwZm52bi9DZmRx?=
 =?utf-8?B?RXMzMWpZMW1RNUpKVzI4elViOWkrNjVDMi82NW5mZlNIRGJHMUwvWWRnZGgr?=
 =?utf-8?B?THA2V3M0RE9yYVVuMHJhcXp5akRTb3RoejR6bVFyNGJ1SS94dFNGbUMySDJL?=
 =?utf-8?B?U3VBNWlpbjVLTHBLWkdtU2ppVzZ5WXA4bUlpTDNCOHcxTmwwcVdndTlEc2lv?=
 =?utf-8?B?NGh6MmFmN1lISjRkTjRDNC8wWUxnejN6eHZNdkE0NW9sQVFRU0Zmb0Fodnhp?=
 =?utf-8?B?cTlwZVpnLyt1bDFySWhKU1FCMkh0UzVNeWoxSU15Skx5NmFMakpQWHV1WmlD?=
 =?utf-8?B?RXZxWjVhdFJRV0pMa093Mi9LWTF1TG9rZTh6d0tXcG9pOEZHbklUeldEam1o?=
 =?utf-8?B?d3JjVzFoWFBCeVYwM0w5RzBjS0R5R0xkUi9OQVNCSDhuY2Yzb3ZOWlFXNHFH?=
 =?utf-8?B?aGhtLzlJcnE1UG9TKzQzM3hIYUh2ejcxV1FJeVRNUVZPUFVZemkxWmUxOC9s?=
 =?utf-8?B?Ym5GUWdzb0k4TzVUaGUyRXF5cDFQN2YrdCtFUGhHL2ZRYVlsd3Qrci85enJ0?=
 =?utf-8?B?NW5aMWFONkZ1dWhMTTh2L3NjUGVLTHdGWk1yZ2pDUGw3UXh3aGw0VnBaWEVO?=
 =?utf-8?B?YXNLdGE3Q20vYklIWVFRSnNKOFBkMmJJTWt0WW9IWU9LUEJ3ZDcyUWZyMjBm?=
 =?utf-8?Q?oteX8Dm+BfiuAQ2zKzptR1OSluQz8Gal?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjJUY1VkV2IyOFB5VDdJOVZLbCs3dVNoTkhPT0FWVHAvNjhwWjhTSXdKZ1RB?=
 =?utf-8?B?R2lLNW1sWHpHREZuNFpvcms1TDBmZ25YYnc5S2xRNVY5STNobFUyZmIyUEtC?=
 =?utf-8?B?SkhKNStsZ2FhMzNXQmxqdW1yUFJ5Mko3Kzd1NEp6azFodWJPcnNmSXIxdW5X?=
 =?utf-8?B?elFaanJLNFVFbm5xcTlYWE5nRmV3UE1XWGVIZXNNREFKVGZSTTZpTlBuQXlP?=
 =?utf-8?B?aWQ1algrV29kaWhZVnFLTzNDN3ZDbzJ1SG9WY0N4R3YvRHoydkpFTTY1bzRL?=
 =?utf-8?B?RXhLUjlnTzNIU3ozOHN2SzE5QVpaZVlJaEJiSERKOEZqK0VxbGFScU1tN0ZD?=
 =?utf-8?B?K0FuTzVIZy9qUDhXbFRzWDlOWng1NXFzNVBFZDJwS2lkbXBLdk92Z1NncTJX?=
 =?utf-8?B?TkVxY2o5ekhMcUtnVTA3UFBZaHRQa2laSHV2Y1gxSlFpQ2tkWDlRcGljcGdY?=
 =?utf-8?B?clZWZjBwcEhCM2JLQzZkOFhVN1lac3BuSWJIaXM1OG9pMXM2TFZ0NThFUGsx?=
 =?utf-8?B?NGpaRVQwUjRPNm9qNVpmR0JKNWdpUWI4MGdjMmJYWWE5dWVBT1MzK1hjb1FC?=
 =?utf-8?B?NzUvVjE5UEdEZE4rQmh6TUd1eGxOWGUrdGlLcTlXb3hqbURLTnJIZFlmdlpn?=
 =?utf-8?B?N01NbGNGbXRENGdFdFRyck5Sd2xnUG9UTHcxNjNZcDViREJpNTlLcXRYQ1Ra?=
 =?utf-8?B?VExpY09selc4V0JZOS9CeC83b0NMblBZWFpveXo5VnFCRXhsQWR2UEU2SGIy?=
 =?utf-8?B?eXI0Y2dsNlJ2UDZWSXJjbmVMWk5GbWxQRzErUzhaZ1NTVkM1MTFVMlZZWFg4?=
 =?utf-8?B?WGJrUDZiRjNvdkl2TVpUNlZtbldjbStVUnV4SVpxUmpkZmZzRnVPM083RFpD?=
 =?utf-8?B?WVRFMmNRSXVramFUb3RnNnI5WW1vWUFUSzJ0OFNLOUZIVmcvYXFKMm9OOVZM?=
 =?utf-8?B?WTNLWkVqTGRBdDQxOW9icnE4cm5HMXdEQkl2SktvWnZmanl5S2NQczU5Y2ww?=
 =?utf-8?B?Y0tkSCtnYkxJRUdsWmNXTHpEa0JmVHNZRWxwV2crWnZ0WGIwcHZlbVVERTA1?=
 =?utf-8?B?S1plZW8wYlJOcHh0eEpwSm52UStCQXVXTTFHREtGSDBGMTFZcHdTQzUrOFRJ?=
 =?utf-8?B?SklqMm54U0l3TmUzY09HYURsSmdMWmkvUUYvSWl3dmdsQ2p6QlV1SmYwUkI0?=
 =?utf-8?B?SzB6WFV1dFlXZWppYllHdmNKemRuZ0ZWYnJab21SdnB3WDVscUJEdGxMK2VN?=
 =?utf-8?B?cStpRHZkelV4RGVWK1IwdlNIb1Bkbm5KMFkvaTY5ekh5TlE4QVdsYXpIWVpX?=
 =?utf-8?B?am0vRXZkb1FwVjljUzdXYVYyc3lqMkhhUXpCZkVnTUZyNk4zZFNRR0doS0lS?=
 =?utf-8?B?MmxwY20zeGVEVFFRL3ZaQzVXenhQbnRDanl5VHc0c0diN09WRjZ3bmZkSjFK?=
 =?utf-8?B?RjNuYzlxbVJHSml2WEFYckZlRDR3ZVpndElRRVB1b3NwUW96aEdRQzVBbWlt?=
 =?utf-8?B?ZXdBVzFKeUY5a2haTjhrVy9rcVkrSXFMTmxocjdOYWdhSENCQ3JYMDhvTDIy?=
 =?utf-8?B?SnhNRVhyRzlwMWZQR3RkL0dMSnJGcmE4K1pIM0xWamZVV1BVVkNDQXlGeTBp?=
 =?utf-8?B?Z1p6RSt2T2ErYXdvWDRtdXVJbFpYbkI2VEdKTkpldUkwbEt1SnZFVTlWQWVB?=
 =?utf-8?B?Sk52M0pjVWdpeUNLMktJV0R3VTVhV3pxeVBQVHdXOGNQNEdCb0RuTmhQNUlh?=
 =?utf-8?B?WEdROEN3REE3OEErK3ZiSzdhTVN4OTBZVE5mekZyQlpsZHFHSEE4azVaTkJX?=
 =?utf-8?B?eDhwQzN0cjlFcld5YW5xK1hzdW1GMU51cktaWDdxdytodVVjMU41c1laRGcy?=
 =?utf-8?B?UlVZT2FVY1hsT0ZSdFgrNU1RbzVHL2I1WG9HM2l5L2lSUncyanZtK0IweVlJ?=
 =?utf-8?B?S3Nrc1Zhb1ZPRUVOOGZVSFNLWWRYZy9TK0I4NmlKdEdaOGlLMDV3VUk5UVVC?=
 =?utf-8?B?ZzhEc1RVTW16RjF4VExSN1MvK2cvOGNSU0VCcDd0cW1VVTdnZ215cnhQYVVB?=
 =?utf-8?B?S3BWR2dKZUVGZU1rc3ljUkkwa245dFV2YUh2Z3k2ZGdkMmlCNG9idHhvS2pP?=
 =?utf-8?Q?4WKZUFJJoMzyFFDn1S9cGIYWq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b567ec48-ce4e-4dee-77bc-08de23bc2b41
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 20:27:02.2541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtaGWpJX93XuOzrAXMFUktLKu6qSprBgqrol/G4bK2bDFDJ1G9F7Zz/ID57XYkb5p3faDD43EWAOLFalX0Lzog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9249
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADEDDC000B
X-Stat-Signature: fd65xifaih9uzn7mtgwuw4uup5d531nz
X-HE-Tag: 1763152024-339406
X-HE-Meta: U2FsdGVkX1+mifY+c3H4ygfX8z2VR9ab3OlE3NiQ6J5iKaCF3PsuUxwqZfz9sUbxDmmTnij81rwvLJ/0BIrMLgTnzMCAloiyx9B/YOuR3FfOqfkACwixAhVAPD/zj9ArEdZizwSJh0rRrHXAth8vPOlcaNRol7dguUiN5cCqZR+9RVKGJm/N0zBBvkv/9DnXD9nuW8TSdpbV8DTcBiLqvljgXHhmflFE9Asqdzx+lw+815DUl7oJXyYZXnlFeB/3IEU20NdphuFC1hbv9KRzC0M5D/d+ZGPMQjd5of8ZLHFt7qehazOXqtrflrl2RzhgF4oVjm0l4NWpLmJs8BF8wJANMj5kUXeoZRhfpM+eRVpES4Szel3j4uXku0/9QMHWnNp2GAWG2SxQ4xC+sAwFuZSk4oDNvAIlXHH/mcrRgJiNcJah+gLcSYBgv24K8kfgMml9JsqmqqG4oz+xnLu9Qwct70oGHLALK1vcX5bbfxckr0egYcfTJ3N2EAZcjqpz/Sw2jlq8ApH4iVHAeXsCtsdr5rufcXgvo9AK7foOzdcuVbos0cBGBGmvPYw3sbHS0CQ+mQYxogGTBi2416QTPlfkAlfZLXKMUt6f+un7wE0Mp1TwoOnO6OZy6t7CxK7g4KdcLjTJ+W0MG0R19Ej1LtSLsOAWifCKP4dp83gS3KfmEXKJJp4/G/QxsJsoY8m/80omubddz1Me8pR00l/I99qYwprvtuHn7LLaCdd9n4tBkPmL6yXMqS90umJgoFdX4YjHQs6oLrF5kTHi7NA6R95ZjwSt3ay/4cILUfxi1l31Lq8y3gF5raGPTZTh9pww9wmSsI0onj6WGBeiG//CtFIKmPrh5L1OKKQbRvFLkIT9hHbiqZETMPs4RYZUNzk4SHKmbBjazE9yNjr6+5FoagU0C2YXG6cdWFnt6SxD59D0/eMpb18A7VxLM28g1G1k8b1O8wo1+E3MV7MPhIK
 cBWMi4Mx
 f0+rbmxqGymOrDbNGPKebmtEk4CMcw7yYYWNBuv62RoSxatYWsBDVIyeYivxexQOX2JYs8XObbDZTM5O9r8aJegZhFMbr8jZcwmNm6mdfLtcxmXtYWWIL2Gt1woAlAhXoAG+fPSc73hWPUmW7pfHU+o5n5MUnNwX5v5onQuO4b8zprLaMc03su02FOorDXo09etgNB8akXbyjQXfiJsbssROqT0XIns4EDne6XGCj7qM4CKZ3HpSEKyq41kTNnIOcg1GE/WCm7BgzDBSIVz58wsrdBbxwrOLgXOehvRovsrxdHcWqeAyAyRvJBxpgKBBG/NjEwWWxzORYSprVwwStmr6+SOHSvJ3JHURv20UAx+xsAvzr9UTFydRWh4Q2Y+O9HOHNHGQG8zbLn0HuSq/1dg4Dl/szmVE4JjZx6187uhK5IXAGtOaAv2DYimmhVaP/7SynDaylG1x37xkk9hUppGSPZdtFKp9peYvTgChcs9LXuxR2RUb9R2mV9YDY/yIh9Rcl8bB1S5hejljk21F4UnzhhallcPX5rKBX6O9isJjZYiNaaBAX1v79qmG8LCNAdX0Fhqyd8kEoi0fIIGevE4k7DMu6NXw5QiDF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 8:11 AM, peng8420.li@gmail.com wrote:
> From: "peng8420.li" <peng8420.li@gmail.com>

Please see my reply to patch 1/1, about the real name, and the
From: item too.

> 
> The 'FOLL_RITE' of the copied source is located in mm_types. h of mm, not mm. h, so fix it.

"FOLL_WRITE"

Also, please wrap to 72 columns.

> 
> Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> ---
>  tools/testing/selftests/mm/gup_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
> index 75f7134d529d..40c1538a17b4 100644
> --- a/tools/testing/selftests/mm/gup_test.c
> +++ b/tools/testing/selftests/mm/gup_test.c
> @@ -17,7 +17,7 @@
>  
>  #define MB (1UL << 20)
>  
> -/* Just the flags we need, copied from mm.h: */
> +/* Just the flags we need, copied from the kernel internals. */
>  #define FOLL_WRITE	0x01	/* check pte is writable */
>  
>  #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"

With the commit log fixed up, please feel free to add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard


