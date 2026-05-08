Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37977CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 22:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBC56B02AD; Fri,  8 May 2026 18:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C936B02AF; Fri,  8 May 2026 18:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B4E6B02B0; Fri,  8 May 2026 18:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72FCB6B02AD
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:48:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32A214038E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:48:55 +0000 (UTC)
X-FDA: 84745744230.14.C590A0B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id 30EA84000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:48:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=li8LpX1H;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.14 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778280532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtHsaDOG0G/RS5BFBaXjc5/luro0MY0moUQyetHd0p0=;
	b=Eui6EHUUdLHkhxr7JtvwFtKn+1T7UUr2tm4XeiaW46O94QpoYU4nuMS3wf7gOaA6kPKgTB
	uqBUxA2xFlMTv8RUXaFcw30jgDVUD5z7vqpWg6yre349lsxpGaz7Zn/tWEb/R7ru4JDWjb
	k4JB5BVtNNbsbIpExUth4I4UzPLaJ1Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778280532; a=rsa-sha256;
	cv=pass;
	b=JPI2rLRqB0VtTEvYSHdIr9Rk9pSIZ/Tf+kWCKD495X39j0EHWSBKM/7SW+LA+0EDJDwN46
	tgRAmjg5Ym2aMogWBr9p9dI/ke8KWwVUMlhlCi6Gi7BI2yFqbf4GIsxfRencevTqEN0LiX
	PzKviAhjsmz/uFx2YW5tjrzQei/DE80=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=li8LpX1H;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.14 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l2ui43I/hYMRPYQfksy7ICdznj5CBr0evoNGSJeF+suwlvQr8VHlR2yqSzLJ9Ggi7qYRdojljDohDe7xHSKIKJqH+Y5GTV3psKXdn8Qo6syxNPNGUMMv7LKzPKZauD86HKdSzeE16sWBfHMXGOQMe/1h6n4cmxfgG2KFJ/G22xFjZU5Kmsy3p0swNyFZwdH7Z1zGG/zdv8GJ1o/DLIq3+GtBXt3PwgGy/lwdVLE4f0p6XVPFHOz53oadEqmfcbCX7L0p05P7D6WqfJTupnA9HcHaQlqXFXkn0SUE72QpkzT1yKlAlFufqxPSMywclkZ0q8QKqGpiMypffSAsu2NZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtHsaDOG0G/RS5BFBaXjc5/luro0MY0moUQyetHd0p0=;
 b=LQ5IutGrLh7OHsRM781snYd98ueUxK4J4EqOitip4NieAQ/QimhQT006jVURKBpv5oP3HJ9S8ds12fSzB59zsQDFqzZgfa0gvz+juWAn2DJjoX39jF+LqWt70u+ScwMwdlDhWHGpcYAa+9wIXFouWP45LRf/bZj35n7uYS1j3mzmNAWBjH7vO2qkioGNXkQPkxPX+8PrlC8v5gkhQg9aiMCPQIUaXi5KkWQCV+8NfxqgQ7pOmCnXFLb3k/NPfp1z+NLN/PYuoqBV2ohJlJONVbM8OuAO0kgWe31fuGN6sg9Nr+PWUgFAT+wU8EQlYoLkh1/l0F4zSGK4/l7/vyRmTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtHsaDOG0G/RS5BFBaXjc5/luro0MY0moUQyetHd0p0=;
 b=li8LpX1Hq+h8VQNM4KH5Cq9pVFbgge0fjPK/jYag6uncWHkGfMjwQqatMCaJ2HxPuBeRw5OORvpRNw3jQwfS4labvIUjki6LjbPcXKuest0fW9J2Agr9Qc8T1HwImXxMeUkWjdv6miqQC1JUarVqp+dlHn9Cxd6JAXV631zI2tt7rpSnHKDJgwJ9yByvFsyyRglgSEdlWCDnrETdrzPc5PNGFS64TGvL6RxQmWf2HB1XJ4HrzRTg4y/kS/O/zcrt6eE4c81Z6CbDBGRerlrCZI9F/+vXMP+7NPNP1XbWpkA56roLdO3p/VG5/8ZVp0Uoa3AEa8KQR2B/Aj52SVXDVA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ1PR12MB6313.namprd12.prod.outlook.com (2603:10b6:a03:458::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Fri, 8 May
 2026 22:48:46 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9891.016; Fri, 8 May 2026
 22:48:45 +0000
Message-ID: <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
Date: Sat, 9 May 2026 08:48:37 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, sj@kernel.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 stable@vger.kernel.org
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260508013728.21285-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0195.ausprd01.prod.outlook.com
 (2603:10c6:220:1e9::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ1PR12MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 34402a53-9f03-459f-7fcd-08dead53f5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/Xyh1zyyfMkVnBlZeu8sRplKsJuccPLK6N/9q3VZSjFUQcU1YjB1YpgP6AElQ+GjwTMUU9T1CVL1ZTgsybq6vsPyMAImrWg1FC/9dqlwNdbKY/Gkyja+3deGXOE1IrRMdcOTKJuClN9cIip4hUE9qWB7RN3tPHsgKYAYI4BctDFCxaLrtNEA0s1wAtgNusEGCIJXmEJSkD99fGjXpOSvLkjlfcGt8l6RlOSdjUXPUx04ZWmvdq0t90IfhXYSkw/CmVF+Ok6PpxDr0+8MAPw7jJNcc/Bu5BeP6TUY5s+tCK152Dg/7ww+Jo5n3nYFk10Sz8qar+x61KajaEsr9/ClBE+PRlX8hs6b0zK3OLTsoYkrd8FkPzE5ITWfsNK1bV6fTcZIjh9mvrQ67kB/WBQKt3901e6KMKUaVBnRLaXPfa4JrkOYoVUxZps6UBHt2uW5REpYiVUSx+AB7Z3vLhgWVr9Sf3c1dWO1DUO/eY3njvBDfgRk0zNV6DCXEjrNuJoS73Xw1bJBHlQOy1iZYdOU9ePdqN8MOrsHMFSkTJSMhoEhIfxYscokLO+DN3O7v2stDtQDCVyXiA/1L560MuHeYmMFG6Lz6Hk+e60jqGk3wr6zbsBkTs6vp0/kmC89DIVKklaoSMpBsA3ZrvJDdr+Xvs4sb2gBrgsS+LnGvO8gjIsdSX8jWVpXAQkZgv/p29IIWkJIkxef8/bieTI3/ggs/IDI4jZJSyVMzCc8WIlck+Fvm2oXaHIDj8HfCl+EJC8J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEtJVVdBMG5xRzB2S1V3dkVmM2FYNGZtTThqTmNUQm9iNisxNGc3OUNoTVh6?=
 =?utf-8?B?bElTVHZ0bTlmZDdSWGViemsvSkN2NHNkZ01ndzlzUWhzOFh0cFFvNDZYZGNR?=
 =?utf-8?B?S0FxWXlrdnBrTW4zMXJRVWxyQWd6RGRUU0FlS3NaUUl6K3RDWmJKbFNTSkRv?=
 =?utf-8?B?UXpTWmtKN1dBandacm1QNnc5TmNTcFd3bW5oOFdTTzBrbm02WDZrN3hOTnFh?=
 =?utf-8?B?VDBJWWNDQ0QxZm5BOFc4aGlEakZpOEprTmFmOW1FTklTam1rQlJyS1lGaWZS?=
 =?utf-8?B?enZyVGY5bVBFRUtyMk83U3lJTVJZYVdGQTJGSzhQRTBDWXNnd3k2R0lBY1BZ?=
 =?utf-8?B?Wkt5SmFLNlFIT0xQZEIrcEUremRxdjlRU1RMc01raXVBbW5RWkIzR1FRVkJw?=
 =?utf-8?B?R2F3UDk5K1c2Rm5kdzNMQ2Fnb0tGdnMycDdUbVNaQnYrUjJEc2Q3cGdPcTZT?=
 =?utf-8?B?b0tFbU5pQnNJZTY3T1JaemwrSUxHSXF4cUVwVS8wTFFjU2prTDVpS2RRN0N4?=
 =?utf-8?B?NXV4cHV0blIzenZQTVhFUmZHeUcwRTI5aUlic24vSGZoZ3gzNEwwVTJCTEhR?=
 =?utf-8?B?T2hxUTVCN25sTmtBL2ZTdnlQWlRORjNTdmlBTFdVT1dsM3NQTVo5VWhoL0Fn?=
 =?utf-8?B?bWdlUk1tazB2ZFlMb2JDVnRPYzRKSE55T3BhLzYzajVrS3YvNkJ0b3NRRkM2?=
 =?utf-8?B?WE5yK0VrMmlMd0t5bXZ2WGhTR3BSNHpVNnp2YWZVQXhLQnhmNG5CUWNXTzN3?=
 =?utf-8?B?WUI4eDE1RjJ0eDBLelVzZ1ZQN0h3cnNodnBhSmlNajFONU04YjB4cmhDRmxU?=
 =?utf-8?B?NExtU1JYcVFGU2pvOUp4R0RybW53NnhPb1Rsd1E4YlpsZERNVXByZHI4cnlE?=
 =?utf-8?B?dUVYVUVGaGFpUFg1c0Q2cWRvVDNxMkNJS3Q4cENhUGJOMWdrRjVzOCsvV2RC?=
 =?utf-8?B?d0FVcHVtVjNCK2VkaHdEQXVvQkpndFRHeVdmbGJWSXVHWTZuM2YrbXFxK0JR?=
 =?utf-8?B?cXRRdEFqWlM1SWZQYysxcWZLekU3bEpFRGRwekxuZHV4TE0zTUhHT01COGwy?=
 =?utf-8?B?eVJERTFsWm1lK1lBNVFVR2RKcFlTRnh3OW9lcHdvMDF3ZVREYlRJU0cwRnJX?=
 =?utf-8?B?MG01K1J3Wk9uYnk5VUU1ZXEveDVmM2xHYzJsTXNJWFJlUlU5SjBMVFM2Y2VH?=
 =?utf-8?B?cHNjUFpDT3gwYjl5cHFYdC9BUEFObUtVdWQ5RkFYYk1JT0tQMWV5NitNcDlZ?=
 =?utf-8?B?cGdGNjJyWGtvSnVuS2hnVkZxcGFmWFRMdThsWG9Cb0xIT2NOaXFPSnI5MEtr?=
 =?utf-8?B?V3VERHFBODA0bnM2OGVrMEZiQjVsdFhEOTBCT00yL045enRreUdnRXJsNUhY?=
 =?utf-8?B?a3IzQS9qWjY3VVpwU3Yyd3dMWUNnbDJweWwwbWlDRW0wUXBrSkJDSXZHb1Yx?=
 =?utf-8?B?NEhkMkVtYWtOSDhhM0daejg1cmJZSVJqQlJjays3TEFlS1pPa3NzUkM1Z3lK?=
 =?utf-8?B?ekdWaHV0bVhDYWRoRVZCZjlzU0ZEVlRqd0p3RGROd1JQU1JkLzcrK3lIY2RS?=
 =?utf-8?B?NXV0MzM0ZTlyQ1ZQUFg4cVpUamdrSnVpdXNmQ2xVd2FhZEkvM3VuL25Wc0JI?=
 =?utf-8?B?eVlueWRpMGkvMUVpQ3I0SlpSeDdHRi8wOS9uVjRQRXB6MDZwTnBtd1NQQXdH?=
 =?utf-8?B?TWJsSDNZclF2WXpEVFRROTN1ajhyLytZKzVuZU1tL29aeXM1N3lYbzM1VFVQ?=
 =?utf-8?B?WTlSTjVXR0NnbzZFdWJmQVBsMXpvMDBWbzBzNWoxakJmeUEvMlhxWHpSU0R2?=
 =?utf-8?B?OTN2S3NpdERTK1dmZXhpVGRDbVF1NGMvamdvMklzR0Y3VTVKL0tKamZUTnI2?=
 =?utf-8?B?WE1adGhvMHJjaVRGWWprWVBJckluQ2lyZnY0eWVvTVY1eWNKdTNPTW1Yc0FH?=
 =?utf-8?B?clQzakg2RlhNMi9BRDg0LzFBa1Y5bnprQllCNEI2K3hRWVVYVUFURU15T2tj?=
 =?utf-8?B?T3VOY3VDRS94SHU1bG4rQjJhenViVm1VQjFiVzhBSTdtTE1FK2pkQ21KdkM4?=
 =?utf-8?B?MUtoMjhubE1ZUGFxek5IVERWdUkxdXBSUlJwc1NSbTlvWWplQ1FNNGhRTGpS?=
 =?utf-8?B?SUI2VktUSW8vNFJIZ0NOMHRRMXdNVzNLWTRVV01VU1hiKzAxUkp5UWV2MDF6?=
 =?utf-8?B?dzc5NzVneXVlRHVHanhlaG1SWWdVeklGOE9zbnQ2bHVuSFljMXlZUU11dCtr?=
 =?utf-8?B?SW1oZG1PdXNhWGpiYWphelJlcThXNk96Z0l4UEhHVFdtZEVxYXc4bXk4alJD?=
 =?utf-8?B?SUZvSXd0S1A2cDZidFY0czFFWWtMNkVha1lNRkZMb3lvNzBWSjFzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34402a53-9f03-459f-7fcd-08dead53f5b3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 22:48:45.3047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvD+WM/mDFLZB/nfj1oVSACaLVqRq5tkSS6Ifa7mStYLtxP/Gx5bmuidT4f9iXWeewblWuZoAx+QR1pChAoAbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6313
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30EA84000B
X-Stat-Signature: j1q3qq5zjpnfdpam1szywpemm6ouwk9a
X-Rspam-User: 
X-HE-Tag: 1778280531-294718
X-HE-Meta: U2FsdGVkX1/nvTO9RuQByCySruAbGzGkdQpMXpMXGBls/tKm/yOr5APFw8KIEgNVn0xc5RbOzR3leULirfTsHw+ka/NJiDCHGgRF/czPsLCIeZsonJgviArdjnIPg+UowWEKE4fNia3WsCFRHDxOfj/c0Az0bGjYIXCU7gfOgqyhUCh+ufpaIQg1cgAge++ENT5zBEYKAtMdZF+Sw/vstwlK7NqWvp3PWpnnIJ+fgUWz32by8PiR+AjUzRGnQVAEK0z/HPMddg60bX/aDudNFO7xgm+YD6e3zeNE5/H0pIDuytWCcfbx96Czsepx2S4BKa2x/4UP7eyNUmP8gwIUQ5+oEcvvStF2KTgrh35b2Y1lUliHiNCTjRTOqLr54W5fSBOUyRkfcI1V1FR7cWUhGEw2VPJ2PXfrtK5bHQ5BFvFKphKaEfuMyw2OMbG50zXGyUb+qpa64xa93n3F/e7SoG/0UA/q/w7YiN4L0EDaQOYaHfV+YfApN6OqpzOKGfK/+ZvgSCt3jfk5UwmZcfrIAOgiBi3nA4bRFqv2Bz3BznkJ/5gHZr++uBWX0ommTmX3NUlngvfqlGFZDpPdrwrmZ40msnynLhvQ6EluaGGJ+uxvBvkLJakLKerRM2NWXpXLd+70GA9fABMdm5vs0wClswrpBBiafSube/ubX0UI00iGQOAwajdVKAofG5M/lvriYKf5nct5Qhb3WrYf8MQ9trUXTBWXdtIA0bsAiAo6W0A7fN5DpXu8X+/88bKr7KdJbuFpITE7hIiOfTF0YV2ofC2YhaXSbgkJGXTrLWE7cls5Vo37TYmaZl+DWfC57ghgyD2r94OCSE6xwpYZkud71/qIvORN9AlkK/4yDxXO8qH4fbcH49q2Kaw1yJfBDzBwY0lmtag3Sn+nD1/p5bXsVI/ZuPCTZh477pj7qmPOg0pL1mP0EfMSfEWigR8GbwIKpVFRgFxc/c48A2iylzP
 Qf1WO8uO
 Ra/7M6hPxOE2g4RILFnajjgjZq1A051HS5IQuj4BNuYxr0LKVbzrisMLybITogAQifam4pmfNqeugLOyldd0GZr6pzZfJ1n3JIYd3R/+t+9oPVnE8CnmnQfJGy1/m++eWAOMpof8AecikWodWIvHUr4EiHQS7PHBA6iJ84kPMHYSFCzcK/OPkkGdgukUFINTAqro9x7PvUFPGileZUNdFt0KoO3/gGYS7JMU/OsUXrOqfTjoHaKXVFjOCwuY4lUyGW07rHangaHC+3EaGvDYjEFhgelKc8Oac641Qr2+oTFyYwUu9VHfja9jh7UteO10FbKlisLSQHUxASqJTSnqOAJNsFYPTnAuDWJwmLxQk4UDKyPWMGzdDm3KiaKbfKsbKXYziqkQSTwyTz+bL/9poKAr9T9NSEpVwSv0rtTmtSLJjmuxGCWK0WAAgcmOUoEF7dcLrVffoUzNs/YL24Q0OwUKvv3DbqtjC0Z1f91sRHF7r93DtgySPWeNDThxkqrmuYdWXZLTGthM0ljCrhX5PTs1oXbIckJ8IyxuhS9/fwHlX8UyQwc5p9PXiMdZyka//aOHXZwovrXxTyASAf2ginvEDzJwEwVn1NANZUaQuT1ufcdJ1oBoOHlpUoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 11:37, Wei Yang wrote:
> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
> before return the pmd entry:
> 
>   * re-validate pmd entry
>   * check PVMW_MIGRATION
>   * check_pmd()
>   * handle on pte level if split under us
> 
> But for device-private pmd, we just return after pmd_lock(). This may
> lead to inproper situation.
> 

Could you elaborate a more on the improper situation?

> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
> support device-private entries") by following the same pattern as
> pmd_trans_huge() and pmd_is_migration_entry().
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/page_vma_mapped.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..5d337ea43019 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -269,21 +269,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			spin_unlock(pvmw->ptl);
>  			pvmw->ptl = NULL;
>  		} else if (!pmd_present(pmde)) {
> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> +			softleaf_t entry = softleaf_from_pmd(pmde);
>  
>  			if (softleaf_is_device_private(entry)) {
>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -				return true;
> -			}
> -
> -			if ((pvmw->flags & PVMW_SYNC) &&
> -			    thp_vma_suitable_order(vma, pvmw->address,
> -						   PMD_ORDER) &&
> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +				entry = softleaf_from_pmd(*pvmw->pmd);
> +
> +				if (softleaf_is_device_private(entry)) {

Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
lock and check once?

> +					if (pvmw->flags & PVMW_MIGRATION)
> +						return not_found(pvmw);

Double check, do we want to skip migration pte's (from remove_migration_pte)

> +					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +						return not_found(pvmw);
> +					return true;
> +				}
>  
> -			step_forward(pvmw, PMD_SIZE);
> -			continue;
> +				/* THP pmd was split under us: handle on pte level */
> +				spin_unlock(pvmw->ptl);
> +				pvmw->ptl = NULL;
> +			} else {
> +				if ((pvmw->flags & PVMW_SYNC) &&
> +				    thp_vma_suitable_order(vma, pvmw->address,
> +							   PMD_ORDER) &&
> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +
> +				step_forward(pvmw, PMD_SIZE);
> +				continue;
> +			}
>  		}
>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>  			if (!pvmw->pte)


How was this tested? Did you run hmm-tests? Is there a broken user space
that caught the issue?

Balbir Singh


