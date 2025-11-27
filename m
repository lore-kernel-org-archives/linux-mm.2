Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE21D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FB16B002D; Thu, 27 Nov 2025 09:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57066B0032; Thu, 27 Nov 2025 09:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F876B0062; Thu, 27 Nov 2025 09:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6CC6B002D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:03:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F71F86E4B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:03:37 +0000 (UTC)
X-FDA: 84156554874.27.56EF41D
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C98440021
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:03:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wvcZrZaW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.200.59 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PX4KDy0END5xjWVpycCPgFlsoDMsS8Ie0THXG7f5WeU=;
	b=W1fLEyKc/jKhSPGxXOSiG7+iZkUhWbIkZ7dPLPxExDZS08s2uthy6/PABMJWLVjNwceV/E
	gq46zOk+YQv7IlVv+GXwRqToKmai1l7UZlfSrtj3e4eOZEN6VM87aFsclPiZv/lwu3a3Y2
	d7+klA0W1MCCLKmneHyJJj6oHYSH6T0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wvcZrZaW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.200.59 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764252214; a=rsa-sha256;
	cv=pass;
	b=orUP3wfKeSgFB9lpVw/MstKJGt9SgiBuRQYGIeXPIaoXjywJPlYZoXwHtzoJ+truxlqhQ6
	gkiaYhmN87L40+MON9GdFxnZpWck8N3P8CJU3ezxEP6mx0qMmq7t2tBVYM2xjkEgg8dy88
	KX6m1zwQzXa8xclhA/pIZWDu72srfoU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wvo+IKYEnz0E6gZx9iZtg5Gmg6SVIclflHr4CMUVMmTrzDQ1nSOEBHVNlo0SO+wUtqmN1UEw7jbSptkBJKNtPwP2IJmkGw9EKx7GQGPksANTdkixV2I4bxQ47HHmFOasedOJWXuC5RuhM3s0N8cWb9B/PHQA3XWgRx5LPn1gjvCqMwiKz6v4ob5nbeqo/ucd+x5DTnNnIwDPVBc5egevMTLmlWVFzFw1LDPnYJQj9UbA4k+nFju4b5GU1TqUhUgTOd92Ce6uU+X7HK1W4lzttRP4Y2e7QSB3G9pXldwbayVqx8gQv1yb2sKbNikHgM2W+AJJ8Pz3wncuVpSs6wN87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX4KDy0END5xjWVpycCPgFlsoDMsS8Ie0THXG7f5WeU=;
 b=KDlZMXxGIE8kgszWeB15AAgtXb+WcgZmbBzxlJvE5WSjHjML/aEhdjlu5livV3NG/93DsB4RhaUU1EW//H7+PS9DawWK6Tmsh29jksI5KvKRzsVaTWiRY8KOBFgTsIHNbO/1m3S1uPovBYg9V8SKVCGt+vU+zjdcz8f4OAn0P32NRd8lGsglP2dtUh9pd6JYr+PA8mxbAt6b/CqXN7eeG+Ni5yE8o+bg70PqADCT5pTNlkz97oNMlbEHOM4JnirGzuVGtxbtBgimj1z4HAC/JDIabHFcRfEBDt4FfNGCDhStJ9ygCv2PqvfAOMiAAYllRHZWj3tvpYYSS7h0Nn6yGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX4KDy0END5xjWVpycCPgFlsoDMsS8Ie0THXG7f5WeU=;
 b=wvcZrZaWk8HKJ9wsFoPhmLcT0+P1nrUe/aeTdP5A7fES4RiUS7wLJ/U8OjCpxoP/YSpe0vhHEZqpDmAqmWvHv0opU/C/Otzta/jWjtrRsT8obqz6EgPGspeDPXHr0huedkiuj8wexLk4rVYbkt8UIsDwzY6Zki5b0ndM32Pa++s=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8548.namprd12.prod.outlook.com (2603:10b6:610:165::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Thu, 27 Nov
 2025 14:03:24 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 14:03:24 +0000
Message-ID: <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
Date: Thu, 27 Nov 2025 15:03:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be outside
 given range
To: Matthew Wilcox <willy@infradead.org>,
 Jan Sokolowski <jan.sokolowski@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <aShYJta2EHh1d8az@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8548:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dcecc02-207c-4776-c432-08de2dbdbacf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmhUUS9XZWxMa0JsbVhhNHdmYjVyWEs0dUV1QmZ0WTE2WTVleElvWXN0aEg0?=
 =?utf-8?B?TC9SazNJUzVWRDNJakE3NHBXN2NZVm9LTmlyQ0JIUms4dWFHem9SeUloWFhN?=
 =?utf-8?B?YlhHbEpxL2FEdWlBQkpHRm1oQTB1eTNVRG5IWjFkeFd4eWpyQklldTN5a2wr?=
 =?utf-8?B?L29TZGx0dmZSL1llcEo0NHZReDNsQjU4U2RZNU0zU3d1TE1jYmM3Y3loMmVD?=
 =?utf-8?B?MCtHR1VtVWNRUW04OFQvVzVQZjhIZjVDZTdFRTZLS3NMdTd5VjhnS2N2WGRS?=
 =?utf-8?B?bzNDL1ZHM0R5endDMk1VWGhtK2E0QmVXc3hjRzBpaFMwcHl0bzNZU3hySTJT?=
 =?utf-8?B?cm9BOVBHdFpQRkE2OHFMRVM2U3FJbW1JRWVlc25lUlRpL1BoaWtLNTREcWJU?=
 =?utf-8?B?YzJBbFpSUEFwTVRpTFZCbW1mM3phYW45UlBWV1BtajNMYVhZenVtTmJvUmha?=
 =?utf-8?B?TkFNbGJ3M005a2hGNk9NWExlWTNoOGhYa2lqK3FZSUZaaWFXbHgvcW1LSU5R?=
 =?utf-8?B?K3ltdHRrVmNyWlNOYlBkN21ldXJDM0JITytQL0cwVmlBTUpQeEtKZXhWV09u?=
 =?utf-8?B?YXZyelJTR29lM2Eybm80T2lNdGhvRTVwejNRalNjQVpzSFpGWThlSVd5a0w1?=
 =?utf-8?B?WGpxMFBhcGs1a0huMm93WXBxdkcrVXF5SEdIbnpxZ1M1bXlTNzZSUTQwUGNq?=
 =?utf-8?B?RmZmNFJGR1ptb2pETzI0MUc1RUV0U25aMVJ0Rml4SkJYU0kwaTA0MGs2UFVS?=
 =?utf-8?B?RW8yUkNEd2ZUQnlCcnhjWmRTMmRSK0Iwd1VoNmkvMkFFV1d0bXFsK1ZoZENL?=
 =?utf-8?B?OFQ0OXBmNGNUOTJhRzYzZUcxYUViMTB5eStjbWl2QTFWRkdHalhYWkc1Smdm?=
 =?utf-8?B?ZFNKZVNyNnJzc2JKTDVUdXFVRkhIN3d4R2dKUkdBVE5xNTNkVjNTSFdDbHFr?=
 =?utf-8?B?RlZjTFBtU0hMR2l6NHZGejd4ZDN0Z0hEejdmZ1JrWVlDalo0WGpSNFBEWkNN?=
 =?utf-8?B?RW9nZ05lUndyL2U3WWV1NjBUTUxhV2FNZElxTFEvVDN4TWhXT2hHZytxYURa?=
 =?utf-8?B?MFNrR1FIazNPQmtnR2tIbjZ3cHpDdHlVcFNZSENuVGhNTEpSeDFwMGFDVHEw?=
 =?utf-8?B?Uks5ZHdFZHR0VFFYZUNMTlc5Qk1hdTJWclpRUDVLU3lCeVRqTkQxdis1UEtu?=
 =?utf-8?B?VWwvOVZ5T3FteVdkandtRVdwMW1rVnQ2a1JWSkxSWTFHdGdaRklrdUowK1E0?=
 =?utf-8?B?M1oyRHF4MHJHMzBiTlNXUU1KemgrUHYyZmZBbFFsMjZLVEJQbk1saStvLzhQ?=
 =?utf-8?B?ejh3VEo3UGJUalVkemVCZ3BpeldTendKNDZsMnBpM3pVMmFIQWU2S1BZZkZL?=
 =?utf-8?B?cHl5Tjc0a2sxcW9zYzNpM3dZeTRDeDFUS0NkRC84WEJvTFJyWlR1MFR4Y3Vx?=
 =?utf-8?B?Q2JaRVVvRUR4Q0JsWHc1UkxOdlJ0UUtyeURqQTFxYUd0NzcwMGpDVnpKL2Jq?=
 =?utf-8?B?ZkJhUGE5anNzamF3ZnlhUTdOL0hodUhwazJ2U3VlejFhTyswUkx5Z0E1Qm45?=
 =?utf-8?B?bFRvRzVReWpHeHFIOGNYemZFbFRzVHBRRWpIN2llazZiQzFPYlRwTmNWcmUz?=
 =?utf-8?B?MmQ2aDFpRngrMzAydkJHUUlrdFVPSnE1azcwUlZ6TVFYc2RxUXFpZGRlWm9X?=
 =?utf-8?B?QnN5VEZBbnNXcXdYWlE4SXJteDZ3aHBQV2lST2RnL0NhZkVJaG5YVFZrSDJh?=
 =?utf-8?B?ZUk2OW4rTlpXR3VaYUN0VmhlQ1JESlFWdDZLR0U5N3dudmwxc09pTHBkOWlz?=
 =?utf-8?B?Wk5zYlpTQjZpeHcraCtmQ1hGSFRGeDRjNC9XeURKamJkT2xuK080eEx4djVl?=
 =?utf-8?B?NWNGTjc0T255Y1dZSGNNUmp1UzAwTGVwazZpa3lwN0Vpek5PK1FsQThJYjRF?=
 =?utf-8?Q?gwRwnRbkd+slgH8neprucUSg18vQaItm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTE3TTdyOVRnK1VvdUpGMUtGNGIrUHo5UFFVT1RDeWFUbWh6dFpKTmR3aEZw?=
 =?utf-8?B?alNkQUx1dDlIT1hPOTEzUWhGQjEwOTJ0cUMrSnZWZ1dMd3gwNmFSMEhFdTBM?=
 =?utf-8?B?VjdwM1B6bWpIdEo2N0hkR2tuVWpjYnVYVk1GQnRCMEFBazJBOUl5WFV2cHNK?=
 =?utf-8?B?di9BVWt1bzd2SzlSK3ZXdlFYYzhNQUNxZDRGZzNvWmsxbG1BdmNyazJIaXRX?=
 =?utf-8?B?SWYzaWk5aHJ2WXRRRHRGNml6Mjl2M0ZCeExhSGIxL0F1dFlzczEzVHIyeUYz?=
 =?utf-8?B?S2JtdkNnayswRk40YzRrSUgraDJFY292S3B0UnJuOGQ2bXNhakg1aHRkVVJ1?=
 =?utf-8?B?TmFOTXp6TGFUWTNxVytJejU3amwxRmg5YjVkV0hXNHJXb0N2YlNqVzBjaEMw?=
 =?utf-8?B?Y0J1cU9NK29aNWM3M2dYSFhMQTZUcDFIcmdDdVBHbm02VWsxM3dkSWxqYUdU?=
 =?utf-8?B?S3RFMW9lblVHYVZoL2p4aXRnaDlwVUExNzhoVzhmU3NUbkFYaGZYWjYrREUw?=
 =?utf-8?B?K3RyNUJVZ25BU2NxTkJNL1p6eWtxZFB6eWlVaXhzaEtvakJiUno2MHNVUUY0?=
 =?utf-8?B?aml4Qjc0THJxRXU1dXd6RVo0cUlpdHFFUS84Qjk3Ri8rTmNCZ2JQbUhoSW9o?=
 =?utf-8?B?dmhpMWliNkJUR2Q1NHZUNnZTL20rVlZhc0ZiQXZzUTFSZFFWKzNFTlZSL3NV?=
 =?utf-8?B?NURrRTBPUkkwWDRJVVo3bmRhSnVkRVZkUFpuZno3N1paVFRDL0tFa2E1V1Zi?=
 =?utf-8?B?WUs4ZFYxRjh5YmRXSFJRMmlBOHVqbjd3YTJnUGVjVHpqWG5USjVkVzR4RFVw?=
 =?utf-8?B?OXgrcS9MTjJUbUFFSkFiT09TUGhkV2hNQms3eGJBZEZtSUQxOE8zRmlJbTIz?=
 =?utf-8?B?aW81RERnMjhXNC9ZMCtHY2o4SDV4RFFGSDlKaEgweUdOSjNMUHBJeU00Z3pt?=
 =?utf-8?B?TTg3eW9wb0l5dlh1cVNIZnRTKzVzNkxDNFdhMUZ4R1lnZi9BdU1PeDNULzYv?=
 =?utf-8?B?VFV5bGVNR1J6WHJHZ2l3VFRCenFackVQcVRWYWVhY2dVRlRHUWJCWk4wcERv?=
 =?utf-8?B?RXRtaGtENWxDdDB3M3hlTk1ObzEwWVpJOFFxMEQ4MUtKZHREUVJ0NlpYVG9z?=
 =?utf-8?B?NURJSzJwZ2VBZzdldG9COW5qMzRxbmkrRS9uSFNQVlVOMTFVdDVqNm94SmF4?=
 =?utf-8?B?R3poSERPY0phdG40dE05ejdvVE84aXJTYW96dTZTZCtWZXlSZlNoTVpiZmxC?=
 =?utf-8?B?dWlyMVUyZUc1bHhVdlFhcUNhblhkZzZ4NGU4eFRjdjIyeGRuOWNucjBjbGRI?=
 =?utf-8?B?akRYWTR0R01hMThkSzB3OE1vamErZTZuS1pjRXFBWTBJdXlQakUwRVdRankw?=
 =?utf-8?B?SW5HY3N1TzNCMW9UK2dDMGM4OXZzSjNQYUhEaTR1a3ZnaXNuZzFoV3BhRmdF?=
 =?utf-8?B?Z3ZCTVJUZDRiclEySmgzbFNUMEpoVG9JOGN0OE1mdXdGNDAzL2FqZWtVcC80?=
 =?utf-8?B?Y2tNQ0pScFB6WWtvVXdpbTFvblhQNWhoYmU0WmwvL2U2aGxGajJzenpXb05o?=
 =?utf-8?B?Lyt0UTZEeUZocm82MnZCUCtaa1lVejFIako2K0lncWs5VHBSbWFQay9mamtD?=
 =?utf-8?B?MzZMRThjbWl2SVg4TndJdkpNK3Z0TlMvZ2UzNVVzVktjbjVhMEVJalFUUmpD?=
 =?utf-8?B?czdQUEE2WHlReXdsYTRCSDZwQmV5aSsyYktoYW9zZlZLMmhVSnp5V3huU0FY?=
 =?utf-8?B?bGVxQjBuWnZFVllORDFwbGpLMk1RUFpzZGpxaDBxWFp6dU94ZThrWEtUenFV?=
 =?utf-8?B?NVlweGFVTmNJNEFXYTV5eURYVmZxWnpmYzBiOFlEUUlwQk02Qnh1VUpTYVlF?=
 =?utf-8?B?ZFl1ZEZQU2lxKzZkQnhnNVNzNnllM2JjcGpybTIxaTJMNHdJa29QQXRDemhY?=
 =?utf-8?B?SUlWcEZOSEg4TlpXNTBYcml5UW1Yb2E3K0ludW1USE1LNis2bXVSOUdlYmVB?=
 =?utf-8?B?R014dGZIRUMvY052Vk41Sk1GejdNWlhYdGxpelQrWTZteHhWSnhRQW9UOHRQ?=
 =?utf-8?B?aGV6a3FaMGdaY0JsaVRGelpLZDE2SW55cTdkZW8zbCtJOFlUcXQxTzFJOWJL?=
 =?utf-8?Q?8uyQI4+w/E2W/I/q/y1Y8OTZ6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dcecc02-207c-4776-c432-08de2dbdbacf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 14:03:24.1020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lzBX9/K2F6TWvfWnES6u6MsCFdi3iDWDC4JAgFOz5/zyh96aC01BPt9WwiIzvNEp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8548
X-Rspamd-Queue-Id: 4C98440021
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7onfggxp1hw4prww7f58kn6zxoid6qpf
X-HE-Tag: 1764252214-92728
X-HE-Meta: U2FsdGVkX1/Ou3/O/FVGPA7fOsiCTcvih2DXn9MkYM9HrY9aVu3jozaDarmgpXZrGbkRM6jrqJpAdXj25V0nj0HelEcoK1dOzU8rPyx5GKPC2sOvnbsVwbU/u3+JKDWjfdBVSjEXzUZDGKnbplRHUAeigl5fyZOVMGhJg1gnwn1NatqFfvjHBUJghdBhFCbISIBd4Anju90P4F9VbqIgrbAkg6au1WuumkryXwfxoye3OeNQFMrX2yG8GiWtRR5QW6OypCBAVeQ1YbZIk2B0DhLwidoXb9V/YbqlNW32u4LctwREFf20BtTBaEO/O6yCNzUP4IIFTr0K9f9ZNzd2mtdlTHMQrrBybb00/t2EPUHpraMmi88uk5jO5+Lt3Huw+MSodokwMbIbI30C0TG8aL64aQ85I8+ui0/ARh0yxm125kOairuzSrR+0fubcRiAa7jgtHcsx5rHwb+CVcrIjCfXNqfRBB2WtgrswLK1RxGK55d+fEL95wX9/8jrIkgzBx8XJwbRtQQJltPQz8bu2mobD+WSSuyb3IxZX7a54iTEbWPtKXglHVpCUukkS5QhXxkjAqXfgowN/ckwLp3jx0V68bKJl49V8hijjpBluHKu7Fz0nY55BsAGDgZB65kBv+aaEOCPG3x+cmnFr+N8T/JcmsxZrvRsw9uNXsIEeqVQVuozMwmxEVVlLsqjReuZQSQJZ0WVOoFy7yUQoEVqUoxkqjJAOw4VnMfj4+BzZFtm59jg+3eCjpD4o/Mqh5YJGhXxeTqIBMv9sHhpXN3maHEEHaAyqx/WT44JeeYBfQoWODhdwDFQFze3QdNRz8XO6At+Ye97bsPmkNkxy1PAkcT9z8AfCnX2agxZt5ksJVD1jRiSR6s7PLhFKFBszfiBbDjFGiHW7x2COKwwK2rHJOkqCk8O/ndemA49u5tswobFpTwaw1saoAG9jgbi8gXJTWSfsiI14dPA9HRs+HZ
 vYKxZ2BP
 5d8l/fKeSiGv9SsTXL2PxDv4rsbTeIXCE/RSySHzDIZ66Ol61X7z0l/LQYcBVMUI/WrgpwTmCAuJ8l6kjAJbVk02TWqT6Mffm1bpodb+eUaBkWGWbJvHxPVYUfDAAb4tkM9Vt0g31nPGfxgBA4pVWOLDaYTdI5Zz5Od09cYNP6KyrFdoRf/jXMgOeL7wloFh1hgEs5D4QS/UrNfn6X6FAvArXDwiziVQQNigkx+I7qRU4pxvSaztMFMzjLiXcYbKPqlbDAkRrqo+0f0Ait0ff83iqm5hCSapl2HzXo/g0OkS/AJ9XFskFsceDiPZ7LnrL22mPUIQw1rYRYSomqIr5xHw4/4ZM3W/eXqOv+ALmjgh3TUPJ+IWj4YPC9GlWLWUcn+Wa4Z8G0xUm21lvQ/2PNUDdPs7jCKeLCdxiNLf9jUI/1Cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 14:54, Matthew Wilcox wrote:
> On Thu, Nov 27, 2025 at 10:27:32AM +0100, Jan Sokolowski wrote:
>> A scenario was found where trying to add id in range 0,1
>> would return an id of 2, which is outside the range and thus
>> now what the user would expect.
> 
> Can you do a bit better with this bug report?  Under what circumstances
> does this happen?  Preferably answer in the form of a test case for the
> IDR test suite.  Here's my attempt to recreate your situation based on
> what I read in that thread.  It doesn't show a problem, so clearly I got
> something wrong.

According to Jan the observation he has is that this code:

idr_init_base(&idr, 1);
id = idr_alloc(&idr, dummy_ptr, 0, 1, GFP_KERNEL);

Gives him id=2 in return.

That clearly seems to be problematic considering that start=0 and end=1 should either give you id=0 or an error because idr->idr_base should be initialized to 1.

But I'm still not sure if Jan's observation is actually correct, cause I also don't see how that possible happen.

Regards,
Christian.

> To run the test suite, apply this patch, then
> 
> $ make -C tools/testing/radix-tree
> $ ./tools/testing/radix-tree/idr-test
> 
> diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
> index 2f830ff8396c..774c0c9c141f 100644
> --- a/tools/testing/radix-tree/idr-test.c
> +++ b/tools/testing/radix-tree/idr-test.c
> @@ -57,6 +57,21 @@ void idr_alloc_test(void)
>  	idr_destroy(&idr);
>  }
>  
> +void idr_alloc2_test(void)
> +{
> +	int id;
> +	DEFINE_IDR(idr);
> +
> +	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> +	printf("id = %d\n", id);
> +	assert(id == 0);
> +	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> +	printf("id = %d\n", id);
> +	assert(id == -ENOSPC);
> +
> +	idr_destroy(&idr);
> +}
> +
>  void idr_replace_test(void)
>  {
>  	DEFINE_IDR(idr);
> @@ -409,6 +424,7 @@ void idr_checks(void)
>  
>  	idr_replace_test();
>  	idr_alloc_test();
> +	idr_alloc2_test();
>  	idr_null_test();
>  	idr_nowait_test();
>  	idr_get_next_test(0);


