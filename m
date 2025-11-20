Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDA1CF8555
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 08:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC706B0022; Thu, 20 Nov 2025 03:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4636B0023; Thu, 20 Nov 2025 03:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392F46B002E; Thu, 20 Nov 2025 03:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 295916B0022
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:18:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34A1185E98
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:18:06 +0000 (UTC)
X-FDA: 84130282572.26.22EF425
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7423C4000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:18:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=asCsqtgw;
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.3 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763626683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xCNONfFZHZpBZDqEZCiaQajDnbALFKwagXC5pW44o8=;
	b=A2at8o2VZss+0aZ3FEHzuwFWdNert2PYPywCoQMRZ9CKn/Rxn2N6o0iDl1jidyj6YuiK0S
	LrUfy9cZng98ThAbu5FFOrVGhZYDXLUJxCX4sHQcycJLGfd4TgftuZCrT5Occh9mqu3G/9
	k8qXRwPne0nSq9W/yfnaxHRnKC7RJ0A=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=asCsqtgw;
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.3 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763626683; a=rsa-sha256;
	cv=pass;
	b=mQOlkFO2TFvegIFkij3utXqbHXwLm+Ig+KI7GlaXxQYzrdzCp5XXRrYZ6JOaiZ24CakAwe
	aczxlG3cvERTs3Zz/MEeeI4OTIVFmhwNZIYa9rYDA5bmwDtBfj82iSUoBTw7oK2mWD+q2Q
	0igeW+Krx9d7iMHpIFp8gj5UM5JFoj0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtgkM68YPuOEZ6McVpQC0kS8gI3d3m90gxqOm8gcQ5VEZbRaAsrexi5t0rI8amt5SwHTklrwJCQp6smDRSISVSC3Zu+k+IwcciNXeiQIX6E9ktp1w9ul++jNhXdS5k8bWfBRLwezhNZsySzztvMkTpNEPS5ou+Trb3IuMbTomN5V5BMnVEF9yhs7ik3AunLgF3/Hl9Kf3FMCdHVi9ymXTnybe+ihBF0//FsEnlUk/6/nDyUpOsZ7esgsatTVSYYm7c3KRF0rkZeuVAkHjvXOXTpxhZyFeG+4gVOC8GygDcWj5CX+wRP0zY8Lnq2MmeuL0Abq87H19lQyyH8c1Uru5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xCNONfFZHZpBZDqEZCiaQajDnbALFKwagXC5pW44o8=;
 b=xvTTxToJp21LghYjBBIFm2+Jz2k7jbvCRLqtt4iCJF8k1pQ4FGbYJGD5MxLkclDAwdkh8x0I0c2HxLCw1Y4PMTUvWP7XKRT/ldE6maC0VSpnx00LEvov/A4Uw/ag3sxpI/9ZnMAwb+crJqDiK8B7s7qNOIPKfQoWNyRTXRJ4SbaxvNdK3IFcGxQWlxSQLxLq6FhlQ49GuLu+TbhyfEak91QiAvHNlhIdBiQF4i/xy+peLIEDcj/OMgo2nR3nQj6x1Kr3d1uU9VxlQLqoA+Vq56i8A4YiNW88gaBqm1mABePnNew4YHnmKzvUhlq18kLtyToRcRXFmLFkWl6+3I7w7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xCNONfFZHZpBZDqEZCiaQajDnbALFKwagXC5pW44o8=;
 b=asCsqtgw2RdRjku/y2S/U+9uHq88H4OjLghOzraZ4t7/pZdLHENF2LdzIUCyd3pTAbNaf3cVkXq3ZC6djPDjozoeC3Hr2ramO62tWnuo82w7wIA1LW17WWEXzE8XDxYyIw60OyPUhb1g+52vBpTm0Hoc2rZgOc3cB+sDNx4Yx44=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by DS7PR12MB9041.namprd12.prod.outlook.com (2603:10b6:8:ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 08:17:59 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 08:17:59 +0000
Message-ID: <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
Date: Thu, 20 Nov 2025 13:47:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-10-shivankg@amd.com>
 <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0048.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::19) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|DS7PR12MB9041:EE_
X-MS-Office365-Filtering-Correlation-Id: 746c2c86-161a-4984-08d6-08de280d50cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akRVUW1mRlN0a3FVUHE3VGtyeE53MGlDY1hYSGVuc2JMekltSHNGblhYMFVW?=
 =?utf-8?B?RVZpSU1Ya1hTeDBXdEV6eStYTnpDUXQyVDBhemNIbnNURWN2OVFuRzVOWDBS?=
 =?utf-8?B?VFJ4MUozU0dHM3l3a0Fad0crTG5wSklTZGhPQXZYN244SEp6US85UCtJa3lr?=
 =?utf-8?B?cTlTK3BKMVd5cmM4Mkhlc1ZwemN0T3dSbHVkektzM2NMUFhQa0k3Umxra2lF?=
 =?utf-8?B?RmFtaTR3VFBtTDlLNGV5SEFVaTMwNG8wbVN6ZnBQZjEwdDVJemZ0US8yRyth?=
 =?utf-8?B?TDVnaXJ2RzZObG9ZcERnODhGWHFSaW5aak5NZit3QlQwdWc4QU9zWDNGSmlL?=
 =?utf-8?B?Y3JZZEJEbFUyR1ZWNkp4djlUT0ZodEhpd2lMM1diU1hWRisxMVQwQzZSN3ZZ?=
 =?utf-8?B?TzBrUTQ2Vk1TRmhLWnpYak40VVRKc09KWmFQcUJGV0hJZUxaR2t0L0FWZmxK?=
 =?utf-8?B?bDdFbk1vVXJsb0hlWW9WbmNrSU54SmRkdnUrZDlOMUg4amJjR3VNS0cydUx2?=
 =?utf-8?B?Y0xkVWJRSTFyWG5sTkl3N1VRWjFweGg3bXpQcldHTkkxWmh1NkI1a1hoM05P?=
 =?utf-8?B?SDYzV0FIZ2FmS2FoYmY2S1hLNXFrbm8xcEJYakowSFh4QnhhazJMY3crR3F0?=
 =?utf-8?B?SjdwQ3BQbkoxQzdtZWNoWFc5VzlOa3E5SDJTTHc2SGl5dEhCUjhneDZhL1Nh?=
 =?utf-8?B?VC9wRjdaQU0xTk1VenVVTm1XSldPN2czTmc1WHdFVXFMcWlPaXNiYzR1eklX?=
 =?utf-8?B?UjZRVk1laFhzMzMwMDhkK2pkWkh5SUNaSmtod3Q0djErbzcwVUVjUUk1UmNQ?=
 =?utf-8?B?bU5MSFl5T3NUbk5zeitIZlRIaVg1NUk1Ty9iUVJSOVFhTmp3NWhybHZoY0k5?=
 =?utf-8?B?bk5rcFdLeFRjSkFFMnBSV2tKVG0vV0Y1LzZ0bUJGbEs5azJBejhlcG9icHZm?=
 =?utf-8?B?VmZ5Ly9kVnI4WFNOK01qK1JqV3NBekRFNHd6MTFPTC9FRkFIQjN6dS8yVEp5?=
 =?utf-8?B?dG4vSFI5R0prOFhyeDVya016MnhMQVJobzNTRFIxQVpONUVSOWJySWgxeGJM?=
 =?utf-8?B?Y1VJM3BsMW5QbDEzWmxuNzVvMjFMTXphVDFQSHA4cmQvUzBML2NmclNhQlNZ?=
 =?utf-8?B?dUU1dlR0OWdZMG8rQm0yaS90UGxDOFRsYkhyNnBFQ3hzUlh6VXhPalpRY3Zo?=
 =?utf-8?B?K1ZzVWdTN3FJRkkxb3VhdncrZWRiM0UwRTRQdkJKV2ZZV2xBQm9oaGhaeS9r?=
 =?utf-8?B?d3l5OTZ1cDhUbUVyd1BNbnI2N2IvY0RFekttSFppdmNXNWw4VlVud2JKVzht?=
 =?utf-8?B?YXdMMHhiOVlFZTNtRzRvWE9wQy9EalpUZVRYVEZUR0c2S2hZeUJja2thYm5y?=
 =?utf-8?B?Z0pGZk1oY1N1UzU1dFgwbFAzOVRaS0ZDeDd0T0ZsNjJqU2VRaW54aG41TEZZ?=
 =?utf-8?B?VzZwZzNHdlRZd0h4SVNqbi9neG9VMXl6ZlRBekgyVWNRUnZuNjlDZE41SWpX?=
 =?utf-8?B?Q1lncy90VnVIUmRBaDdQVzJqR0VUSWFvNmpRN1c3VFlLZHZ4YXJ4Q0x4NlBp?=
 =?utf-8?B?My9DTzRZbS9zSGZseVNlRndtSG1zWUU2Wm95Ni9RZFExNzdxSkk3VUZOTTZS?=
 =?utf-8?B?bEQwS0RmblNobERlUHpxZnFQQlpRR3NUN1drZDBuV0loMnc4R2ZRSmRWbDBE?=
 =?utf-8?B?NWJUV25DbmhnMTRhYzRMRzcwcFBkMHNISGw3ejE4VFlkVU1JaSsyNVRudkQ0?=
 =?utf-8?B?bmQ4WFZIUFJYQ0FQcmtnQW5GbDVTcFM1d0h5MndTajJDbmpINHRlVDV1ZG42?=
 =?utf-8?B?NUt3dXlFL0ZYV25wNERBNjhpUkJWTWI1aEJ6bTBxMEM0WE91dm0rL0ZKVDVX?=
 =?utf-8?B?RmJNR1dXTnhtWGJ6cHFCY0k4VSt2bFVnQ1c5K0tKQTRrdE5jRlpNZ2ZlK1FG?=
 =?utf-8?B?MHArTUh0ZkpvSUIrdXVWYzRPSit3QzBVNUZYQktLYXQwMlFTc3I5RnJYMTRY?=
 =?utf-8?B?U3l6MElVRlR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0c2TVRjNzVrc3F6SlNTMEQyRHd2K0EyWk1nSGI4bmJVdFEvUDBMZzVFNHpn?=
 =?utf-8?B?cUJJZmQwcitUdkZ4UnJVb0NhZHkwVFZHTXFnY29ObkdkUncrbFpYNVdra3VR?=
 =?utf-8?B?ZEVSNjNNU0tWV29Bb2swaE1Qa2hXQ1dVUDdRbitSbklMMmJtSTgxUzF1ZnBR?=
 =?utf-8?B?Q1NBQVhkWHNFcEJIWWZ1QVpqeE9jUnJucmhGUzVENTEraFpiQ3p5emgwQ3Rl?=
 =?utf-8?B?R25sNExhQXBkdmVqMXVycU9RUmpxMXdTTHdFUHVBZUVKNTZxUzlqOXFjQUUz?=
 =?utf-8?B?aGdudFd6b2pRZEUrc0xCN0ZzOFpNSWduaHJLVXlnN21DUGFqblFZZGhEOFN0?=
 =?utf-8?B?Rm8zOXN3MTkrOVZsR0FDUzhFTnFBMHdJUk0rV1FidEhZSFVEL0krazdDcmEw?=
 =?utf-8?B?VnlSdExPL3FPUXZWMlN4YlRVeHhDckZwcjRFWmg1U0lhWUJTdW9ScTJ4cDVh?=
 =?utf-8?B?bm1yOE9mc2hiaFJCLzd5YUNDN3B5WmwweXNWN2hXcUc4RWh6empWZStXcGx5?=
 =?utf-8?B?a0pkUkpjWE1TWFltU1pma01maVB4YzdMRDhpRlBmN2ROMm5UUzB3VmIzTGhG?=
 =?utf-8?B?U1JBUUt4a2FxS0NLdVFzQkVERDd6QkRvMldDVDdTNk5hZnJtK3J5TFpMRW5q?=
 =?utf-8?B?WmE1N29BYmFubFI1NWNHaE85bTR1Q2dUVmVKcExyVk04ditTVE9iN0lxNkRz?=
 =?utf-8?B?YkljWFZCM2RFc2VZM0VGOEY0VXpoSHpmU1hXdTZmeDlQb1dXamhXTnRpRlIw?=
 =?utf-8?B?aFU4b29DYzdqZkFCY2dMSURXNjJSV2FMVDgxWUVlQWo3SmJ6S3hSazQyQkZm?=
 =?utf-8?B?MU5kbk9yVUdYRlI2NC9XdnFqK2dsY1ptUTlMQjZFM093V1JpTUwrQWtZcGhC?=
 =?utf-8?B?YTlsY0JjTEVYYzlNbWh4eDQvWW1obGI1UFNqTFg2Q2ZQbkpRWDYzQ3krZHBz?=
 =?utf-8?B?bzQrdGpIaGFJQVZCQjBZekJXMXdESnlIUEpLWGJyVnV3U0pKYzg4eW5mOTJt?=
 =?utf-8?B?dXMwWFhySWVRWkJZOFRJNTVOa3VoQmFuVHBLQTVZM3RXNnRRc3pYZ0xKWlh3?=
 =?utf-8?B?bnc0eVJsSHlhOXJGNkJITkZCQ0lZU2JzTFVrRjhPSjlORjdLZGlBNVVhYnpT?=
 =?utf-8?B?QzFkL0F0Z3JNTWZqY2tOdzc1THJrUmZaWndnOE5GcksraTFBVDNYMkUrZUtM?=
 =?utf-8?B?MWU1eEVSK2FlVDErbmRNY3pHbG1FalV4QWVsUTlWZ0hoSzF2YnZRcGcycENC?=
 =?utf-8?B?Q2hVREI1WGhVakRVdHNGMlk5aW9DSUt1VFQycjRuQzkvSzloQ0QyK2lMeTNj?=
 =?utf-8?B?ZjFreW5abHdLTnJpNUI4ek9SNXJlSlJiNGt0M1l6WEx3RWRVYTZWMmFrMW9T?=
 =?utf-8?B?aE5XclZMSEVlaWgwTS8ySDRNVjBrUUhrUklPbU42bExmSjBiS2QwQk1NRkRi?=
 =?utf-8?B?cnpOdDVDRUZSbmtSU2p5UzQ2Q1c1RUUvbXMwWWt5UHBqb0o3Q0ZjU2xOK0Zr?=
 =?utf-8?B?MWdGRTJ3NjZCTXNjKzFHVWJ4WnhPSWtzekVBOElEUExOL3dNWU5LN295azVC?=
 =?utf-8?B?RnJwVmFpOUJMSFR5a2luL0ZHQTFGYTBPc25kb2U1b1liSVVmUSthaVBLNUhv?=
 =?utf-8?B?b21IQkdFU1lGZXBkRUhaRXBXdUJISHBrWjJFRDNLYTFqTHhZQ0RSbGgvMlEr?=
 =?utf-8?B?LzJDZU96bC9sUjBSQVhhV2FHWFNFalovSHI5eUowUXJmK3ZxUjRsWVkyMUlT?=
 =?utf-8?B?YjZ3VDI4MElnTTNkZ0dCemsvenRscmMzUk1lMVc2Q3ZpdmtEY29MWG5Gd29s?=
 =?utf-8?B?N2Q3MlQyeWtMNzFxZWtUc3dpdmJTN2dTY0FHaXdKeTQyTDVKUVVBbEpMZk1u?=
 =?utf-8?B?Qnh3OWNLZFRaMUQrSHZVRzkxNFRPVldicFp2bnp5bnY4d25NTzF4WWc5VFFH?=
 =?utf-8?B?c0hkMmNoeklaS3Y4MXArMmJVT0JRZEhmYWxZOEZ1QTJIcWVvdm5PWDdDcitN?=
 =?utf-8?B?aVhOdWVteUlMUXBleVc3cUdaS0ZYbU1SaC9Zck45R1ZjSStNVWwrWW10WCtk?=
 =?utf-8?B?c1hUNWhoNkw3bFBIS25kdk1HS013bzI2Zi9EckQ5ZitPSlVTUXFIb04ydmRZ?=
 =?utf-8?Q?NYv8WA+qRsPLobfYZ7TJNBhzR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 746c2c86-161a-4984-08d6-08de280d50cf
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 08:17:59.1987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBNo71idlhwpSEYfb20ksiSzdtxRzrjmtNa4GeUd5mxBC+zkcBCxLIg97/UHH/vS2kOr3oyKTQ9e7ha9W0ZPyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9041
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7423C4000F
X-Stat-Signature: hd4uky45rwzakqr64j5jimcu9zcqoazo
X-Rspam-User: 
X-HE-Tag: 1763626683-431333
X-HE-Meta: U2FsdGVkX18cD1M0v/3i/qsN6O2mAVqoGPApWRQzfDEEF+vlU342hnIYKSK6XB5GaqhNwW5+8puJbiJRTj+jZq+snQSumZx7/FPSTTE0tbAeDsB43lW9rMCKaPYimqhsrH+cb60IbcgBfSK+iOw7R8PI79Ai/ssB+Bj4+AjTBKr5lSNgN9Ou95VdAnsyBjvhiB0QGQIsVVQhcCqMaoCZOGB99BxGOhIUo+btcDJp9oHSsJQ5WsNJ+ilRe2rNa1nYd6StmdMv2D3M8G2T/WasPJtq69KqZW1WKxYY5GxeozBDePkjHkYpvJYA68qo0hCr9R5CI4mpayxb5vbs2XCLl/SLWw16GQMCNHNIlmnVrQO/REm7JktRiBgZJZD8Lt0x+cF8HW3YV4uWBnp3No75L65JuO8JDFZz9mBhltcqNx1Se8dgRYMlzofOti62EO3IEz3/5MtGXTtSUOPnizsNb+5VyakmrRN/Gw1pWOiH2qMGkYlqvYIsZqB+XaW4VUZPORkXOZgfSZnOhda+jzWdA3Xj3iaIqipT6oAg/ldp2Sk9f0p+gBjV9tQezD1LPuk+NE0Uve6SUZVdg+kBNrCryBBJDWcFFCZCoOBHQyOojegstLgPt/j9H2FbKRditR7xaXG8i2uVPDy2Hj8blGK8xvFSooefJ0l5otIJx/hasiEtuRY3QzBWt2WRBkl2YrjRcJ31hSCeqvQ0CxOw5M3SfH3atCPahOYbZZSVvQrf74sVWzllxqLfasxLQr+OJE+HjwFcDTlLQz6rt6IJs18WiUG1Werb4OkhMK/N4iOkUaynd81arvGU+pd45NzsvBprkSh4ccMZATG56w1G/NH1F5EIa0j/BtOIltcwWF+QkHl6WLye7GiwgUcZeOldFEkB5DGJNL70PM7UEMA2b2CG5UzDHzct7G1LvQKoJXoI7k2x6nP05sgFYj3BBuuswuR85YM42HTZTIlD0BYbZ+D
 T5xZw2Ib
 2S6dKZZa8JJUX4mHq+Pt8uvzhPUGeHUfzab+1rabbTARDNxgbZg9Qelo4ygWOQArSqlePVrjv0iBJBCaB2+h9bwV8oNu2vQhq5054ZvTXs//gE4HCq2Dj8ZV5/W0VHxm7raPbrjw0CBkpgc5QDYSuuEJXXADBCwNzv6QY2iUESWBjpRAuMCa6gZX42A9bZalJv6LV7zwPE0jCBGXq8FLImvey8o2F8CHPoG6F2qI/Bq3LFJ4Apqnz8QkooXOg2qoM8/99O0bSJxOFiz6F09ZNdZpSil7mNCUc0Je9Xq1jeozEI2Io6ekqizfbKqRYSXAvdy1xh8Iy87oWrY81xRr2Pze7xbwHYjHteOXcCqrVXVPKtpmfrXAmHurPYk1mrVR38VQUxbEtZEJ63+M53iRxcCl08ebnfTvncHKizbFh0QAq0JZ+1WFPBc0xn3iwJM4yQNYKexBBrcj5wkLFj41iKPhHw3/AIGGeGEjwEfMsIl8YwOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/2025 1:33 PM, Dev Jain wrote:
> 
> On 20/11/25 12:20 pm, Shivank Garg wrote:

> SCAN_PAGE_NOT_CLEAN is confusing - NOT_CLEAN literally means dirty, so why not SCAN_PAGE_DIRTY?
> Or SCAN_PAGE_DIRTY_OR_UNDER_WRITEBACK? Since folio_test_writeback() is true as a result of
> the folio being dirty, maybe just SCAN_PAGE_DIRTY can do.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
Thanks for the review.

I chose not to use SCAN_PAGE_DIRTY because dirty and writeback have different meanings[1]:

    Dirty: Memory that is waiting to be written back to disk
Writeback: Memory that is actively being written back to disk

[1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt

IIUC, a page under writeback is no longer dirty, so using SCAN_PAGE_DIRTY would be misleading
for pages in the writeback state.

I considered SCAN_PAGE_DIRTY_OR_WRITEBACK initially but felt it was too long.

SCAN_PAGE_NOT_CLEAN covers both states that indicate the page is not in a clean/stable
state suitable for collapse.

[1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt

Thanks,
Shivank

