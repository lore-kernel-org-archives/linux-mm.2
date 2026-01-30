Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CE0E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472706B00AF; Fri, 30 Jan 2026 16:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446FB6B00B0; Fri, 30 Jan 2026 16:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F716B00B1; Fri, 30 Jan 2026 16:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 201E06B00AF
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:32:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEFABD4D41
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:32:44 +0000 (UTC)
X-FDA: 84389929848.17.B3461CA
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010067.outbound.protection.outlook.com [52.101.201.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id C43DBA0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:32:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WkeuEN2E;
	spf=pass (imf15.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.201.67 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769808762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/aV/7HBoj4g19Y2R3DKUij5lYl9D7Ted6hVeQWZkXw=;
	b=HWuFM3dPMICVbleYAeS/2JFLezo8EclENT74OIYFTB3LkkXxhK1gSXDjDMBYBBgt3GE/fV
	B58+eCvCuMPnUyLblp6VCyCgJYSP4fkmIs/ZNMnzYBlOpv6AcikR7RT6jTBW9KekWooUne
	ljEENw9imxDvRh++3gW5LgtCJSRnLiM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WkeuEN2E;
	spf=pass (imf15.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.201.67 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769808762; a=rsa-sha256;
	cv=pass;
	b=LrPKc+EHBGSOxIjH1Ylv9atZoOv7X57YqkXDb/fpo6OFjw3k0/sY40ilIT3S0jLIB4Pdpj
	/nChjNBOm96XHFK+GJ3qwvCM7X+tkBOCIsVgnqhNS0qVB5PvA5BzDtLdM7ceA+8+E29I3W
	TL9FFJqt6Zr85+CHfo9Ne7qNHkLFltc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvSH0uV4hG+NRWtEX+r5Uyt4PnOMf0k9GHqCFcoifRRpbJzuM5zt7pYgBizyj/Jlt+KC2x30tRU+OUSHK5ROlK/I2nS6gaQj+wXvaRtn4Fd8y5lrbwarsKMs57QuTVxQ/fJbRAW2e+9ZE3buUz0OG/JC2mWNnGz06v/SVpJsmnvBGi2cJZw/FVRC7HUpV9I1/zxH9pBgDlo1K9/V4xT34EKIn8h0PTTZXb2DgA1L/jfBxzpKjl0J72ksb7Ptl/As0EOtbxxWacZdfQBG3iW0/52LXoos+6o97FNPEHpLgECZxMkK0K+tG8PxGvbyGI3Po5YYCGfQ1C/rM2VEW799Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/aV/7HBoj4g19Y2R3DKUij5lYl9D7Ted6hVeQWZkXw=;
 b=dBoCnYc7VXlN/UDIt4ySwMk580bSlHMCat88y/TCwW4OSxAH5K6fTcf/YcyaTPT1JPLaOjmKKtkS1CQt9JWucl55y1gSvyEkPSKcyIZVtaZrcZC5UQBPLgX/M9oMIMwqmVHW2GQDZJhpckWkSfZi3WD7ha7bU6QOyFi+gmHcIlScwsdNuH7P5bKN+s1nGLfp02JJfu7B8b4zGYypwO/yNllV8ofuXFsxRHrsvCS2c9FBw/SYfoAA1/7Fd3nkVG43dABP2QRhyKHbIpB9PCC6t4poIZyiu6+nR8au5A9bRjQNcGKbb+EZ6G7KIDV84Dm54Z51PI3JKBJoTt47Xml0hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/aV/7HBoj4g19Y2R3DKUij5lYl9D7Ted6hVeQWZkXw=;
 b=WkeuEN2EujdUqso+Xu4PUK7Wxgy291NNvNQpHjm5PGUHP+U6XH5G2+IuRUkbKDhrgWjXCqshCX+77HK+cCP1/7yq6Vlyci61Se/jKOizQooC59O65FQmU5iH78AbnpqOJk1T8UFvvKoEvqaMZXOavIU9DxxYBlpCD73+Mtnz8lSkyxghT3MsNTV970Dq1s93yUFRlWcM7W74kK2IpJOngwOY+/AahxqePHnKmMDrdv/kb0vphmRPpjE59Pt/KfLsEq6U5j97z1SW3Gn/RrB8QONGrAJDVfKVLKvw5ls+zd/L1gZVKRgb2/SCtBTak2ITS3TuLRJ4uY9d6uL8junMyQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SJ2PR12MB8955.namprd12.prod.outlook.com (2603:10b6:a03:542::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:32:36 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 21:32:36 +0000
Message-ID: <443f2a0f-b9be-45aa-b977-d9a32196f122@nvidia.com>
Date: Sat, 31 Jan 2026 08:32:26 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/13] mm: Remove device private pages from the
 physical address space
To: linux-mm@kvack.org, Matthew Brost <matthew.brost@intel.com>
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com, jhubbard@nvidia.com, maddy@linux.ibm.com,
 mpe@ellerman.id.au
References: <20260130111050.53670-1-jniethe@nvidia.com>
 <20260130111050.53670-14-jniethe@nvidia.com>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <20260130111050.53670-14-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0019.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::27) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SJ2PR12MB8955:EE_
X-MS-Office365-Filtering-Correlation-Id: ffbf7dc5-7205-442c-8715-08de604715ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZktFMDIxWkVyZ2Rxc2xVTkRCZ3NPNkdiOTB3ZTNTZjhJNnUxa3FPMC9JMVBS?=
 =?utf-8?B?cXdPNjVsQ1gySWtnLzgxaDdpWWt3RVl3Z1RZZmxlQkxBZXMzbHV1TmlVRkxw?=
 =?utf-8?B?ZDRuVitUQklQSnY3NFU1TmRkVlhjWk15MlJKK3hUeEcxNmJ3SE9zTUtFencx?=
 =?utf-8?B?cTNIZjNEckdXdnh0c0dIS3BqTlpUVDJreXFDVE82ZG9RU2kzTllLcU9rS2lk?=
 =?utf-8?B?eGl3K2lidU5sTXpFS1c2TDdsZlNoTU5taHFOTGNTTTQ2TGFCUWxJTVBPUHND?=
 =?utf-8?B?d0hlMTRIb3A4K0xaMkloQ3h1bDJrMDV0MlRraDFSbGVsOHA5bHNWVEcyV2pB?=
 =?utf-8?B?VU1jSEhNdnk3S3NlaGhVY1VvMVgyanJTVStJcW1hWEFvTnNFQzJBWmtHeEI2?=
 =?utf-8?B?ZHNnUDV5VzhjU1k4ZzVJa29YTUtLV2FoNExXNWZGbGJGS1NMUGozQ2laNTIr?=
 =?utf-8?B?dFVPQnBPYS82eXJsd05mUzFkaTdXK2x5eStqK1p5WEtKYmFZaXAvcWFFY3k4?=
 =?utf-8?B?ZFB4U01WSnZLNk9ZNVJ3TjVPOXJkckFqQ2Rxa21aMWRkTjlSZXVZOFZ1aCtZ?=
 =?utf-8?B?eCtPV0lFVnQ2bkxlMmtDL2NVRzY0UFkvVXpIenJZU2RLZGhOWGVPYitvSU1Y?=
 =?utf-8?B?dGtKWFJSd3pxSWYrbDNuOWx1RE43L1oxNWVkQ0xWMS9JVDNUTDZ2eGppMlZG?=
 =?utf-8?B?NkFnbzFHSTNydDN4N01objRrZzNBaVZzOGRSSStaMVd2R1dneDQwelZpZkU5?=
 =?utf-8?B?YkFSa1FEVVg2NWVidjdVM1VyQXdISnFYYkhXeXFiR0Z6V2QwYnUyYlR5aWJk?=
 =?utf-8?B?RkVGVGRrSVEzK3NtbngyVGFPNnh4emJZbW5Na2dFMmZpT3k2VDdTK2Mvckdo?=
 =?utf-8?B?NU9jenVtelJjeEhpUEpHTlFNUDhKN0cxU3hqaTZERHFISHA1WlhOT3FGeW1I?=
 =?utf-8?B?YnRMTW82V1NZWFl5NjJ3Z25tTkhMTEZET2ZUTCt3MUFLTlVBYWRVZC8wTk1J?=
 =?utf-8?B?emJKL3dLdGtTOVAyV2hrcDRDeWxqRi91NVVoVThKL0NGSmdJUG1RTmkxTXVt?=
 =?utf-8?B?UVpQblVDcWgyMk1DYW5YdmpIaU13ZTBLblgzZ0hMbzBGRTQwZGFnbEJES29p?=
 =?utf-8?B?ZXJ6N3RCUUovMXQ0dCswa0dGaS94cDdtdFF0U25JL0RMTkY3TTIzSHljNjMv?=
 =?utf-8?B?eVFkbFhpVWxsbm55QVpYczNvYXZ6UFFaajNUU3VUYjRTLzJ3Z2RJQU13bkUz?=
 =?utf-8?B?aUlaN1FKRkRaK2M0N1hXbXIweWZvSUxaUjRJTnN6Mm5xc3I0VndSL3p0OHg5?=
 =?utf-8?B?cERWams0OS9MSFBTWFd0V3d1UVhHbWVqNU8yNFBOOWIySnczY2FOcG9Ea2ZE?=
 =?utf-8?B?Q3cya1hEN0YrWUFkdTlOWGRKZDdVaVlpNVhGaUpMOTRYWU1Bb2ZzMndFa2Ru?=
 =?utf-8?B?bERBekVkc2xBTjZrUmdxZFk4QmcxckhQTTFNdmVsNHZaTUNHaEd4cjJPZCt1?=
 =?utf-8?B?VUpSZG9JZmVMZ0kzQWhuM2NhYkRqbkxZY0R2OVdxZzhDQVR4V0dNbm00V2lr?=
 =?utf-8?B?cXBMNWxidHFjRWkrMzl5R2NqQVA3a1BGMzAwWWhRUmZCS1lGcmpib2ZyQnhP?=
 =?utf-8?B?TDNQS2R1eGRPUjd3RTJRK1dudE5nUEFBdUNob3lEL1FHUjd6bkdBU0ZzN2hs?=
 =?utf-8?B?L0x1ais5MENmL2dZMGpla0l5eFJqWUpaRHdub0pxcjJvUzZHZVBDTGJYb2w2?=
 =?utf-8?B?SnJITG9vRHIzNXBaU3NHbzNaUVlZUWVCaUpaU0pOWlVEbEVpdUxIOXgvdDI4?=
 =?utf-8?B?dWVTclp3b1FqZ1hmU203NlRrbUdTTWJucjN2aU0yTjhtcGJsT3MyZ0libVZH?=
 =?utf-8?B?MnByT2FHemY1K1NsWGhzNzRLVGhjR1VBVzZHeHpxZFBTZ3BIcHNMZG15ODBF?=
 =?utf-8?B?ZStDZHV3OGhuTTBpcTJsbkxURTFrKzZZOUJuR0prY01oSnN6REFLdy9sOWVO?=
 =?utf-8?B?RHZuNmhUQ3BLai9pSjE4eUg3L3NFd0tFekdqWERDclcwdnFSWDcyWUhoUmM1?=
 =?utf-8?B?OWJTTnVBMGY3NFRRcUFPS25nVUFvdlNuUVNDYlNzMkRFQ3JWM09udXFUcjdi?=
 =?utf-8?Q?NEwQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHBCUFdJNm85bExSbk9adklUYXNKN0RWWkxqQjU1ZSt5VU5IZUVvZEY3cmEr?=
 =?utf-8?B?Smc2a3diUkdwUytNc1FxQml2Qktabmx4V2VoNklQSEprdFlwQmYwRnVjVXNn?=
 =?utf-8?B?ZHZIOE9JQU00Q0lWd2p1M1VHMStXN2ZVRnJHUmk5UHdKVmo0Y28rTVBNNUNC?=
 =?utf-8?B?akZVTUIweFBsQzRuaVB5aSsvOUVROG4yUXJGRGdBdXNLeENINW9DdG9VNWc5?=
 =?utf-8?B?eHVTZ0gxTkR1TTRFUVA1UGwrR0JOUnpPWk54cGJzQTFLSXBzLytaS0NtM3pQ?=
 =?utf-8?B?S1RPN1ZRWFhPTy9IY0Rhdkx6WkhIcGFmRW1pYktTT1JLQkpHQVdQdnpSbzN2?=
 =?utf-8?B?djh3V2pTRm1RZmtyc1NSSXFEOXNraFJoWEtkZUNrWE51b2xpNnNvTit6c1lt?=
 =?utf-8?B?TEo1b1lycWp0S3NTbkdnK3ZtUmpnMW5HU2lmZXFhTUxMMFdaZXQvcXhNTGtU?=
 =?utf-8?B?NWNGcjRjdUVyejVYeHNJQjI3TUhvejN2YWlzbjdyaHk4Umg0K0JrVjRuWGdR?=
 =?utf-8?B?UnZyTGREMzhVOGc5ZWx2VFpzNk9BcnlWelZ5LzMyRWZPdlNFWC9xZlpiNGR5?=
 =?utf-8?B?NWJocFlQOWdjT1dVb1ZyNmtoWHpRa0tjYWhHUm9PNG9kVzRmV0tHaktpSFpR?=
 =?utf-8?B?TWMwZWxkRzl0MXJvbG9kMzhyZmVDRzVFZzlsRXBXZk55QTlnZ2NxeTdIcUZu?=
 =?utf-8?B?eEJoSEVXT1dSMUJqTUJScUswcjFtRk9rcDJ0WXprUms4NEMxSTVHbFFBRzZ3?=
 =?utf-8?B?OWNvbXlFM0JTcTFGa1ZINTB4NU1Cc296b0hiVDRrbEk0d2loaEpsVUc1UVpy?=
 =?utf-8?B?cWduTzdVSTJ1V29oWTRrNlhtUE9Pckx1UUczTUtUQ0UvZEwvMXNkTll2b05x?=
 =?utf-8?B?RlhaUEhpTGxLZ09aS053emZaamx1TDUvaDVNdW1NM0pLaVVQZG11WkVEVkp3?=
 =?utf-8?B?ZVE3RDdXdG1EUzVMSnVoa2x6VDkzMDBsSDdicnkrWlZDei9oNVM4UE1LbXJG?=
 =?utf-8?B?TnUyOGIxWkRDRTFTMWdmNkZTR1g1WlJ4cStrYm9kQmJhb1p0YSszMWc0bWJn?=
 =?utf-8?B?c0Z0NUljelp4aVdFazZ1TDRuSEErWW5hNzhKTjFLVDFrSFBrbXlNbmVBNHRh?=
 =?utf-8?B?ME45VWlQWWJkRU80M00venJrRlR4NDdXMnJtelZBV2hYTUNabGFWNFkwaUlk?=
 =?utf-8?B?c2JqbGh6bkxZSVM0UFZBODU4aHJCeTlQYzJ3dS9YNkdhaXF6T0V6bHM2OWVx?=
 =?utf-8?B?UUROQW11TTIwRmZKT21XaitWdEE2Vm14SW1NcHZKOTJXMUJnK0cyUW0weVlu?=
 =?utf-8?B?U2ZTb0dCT1JCQ1pZT1lGL3FnV0JERTB0R21vc25aMlpIN1JaZTFqTGVReWtB?=
 =?utf-8?B?dVZhaFY0aC9nc0xES2tCeUdWeHdiQW15bllFVzBBUnlPc1lvbE9HR0k5bGhG?=
 =?utf-8?B?SVRHSUFybDRPU2I5SlNmaUhOYThxY0VQSlRYTk1xcStDeFZETmwxZFp4N3Nu?=
 =?utf-8?B?NWpFUlY1Mk5KQ2IzblAxK05iU0cxQ1FmQ1dRUGRvWENuVjJPaUJLKzlJZGJo?=
 =?utf-8?B?bXl2Q1hnamd5WVdBZ29FYlBvN0tYSnM1SG8yZjVGanowSUwxNmFseFF2d3kz?=
 =?utf-8?B?YVF4dk1uL0svMEx6dGowUFJKeWxNVHU4dkNvTHRKZFJBVE5lOFM1Y1pZTmUy?=
 =?utf-8?B?U1lWQ1ROOWRSNi9KQ05mdzZWTlNWSnc0U0M1TU4zSk9nZGFZNnlQWmM3RFQ1?=
 =?utf-8?B?YVpSUjNVUFV5VGtnTCtZb3ExL3FWTDZxZlpSVUphek11QjNQOFpiSm1ubHQ5?=
 =?utf-8?B?RGFJSGxrQStPajF4WVhqeGEwRHdpZG9zNFVlcm9XQlFRS0tEWTh1YW9YNzUx?=
 =?utf-8?B?dkpLN3I0cERGYkQ1MnJtUXNIbSs4VlF0YmtIaHU2NDhXM1hrU0Q1K3ozemNR?=
 =?utf-8?B?M2dCMGxlR0VJc3hrS1RtalZTNUpCaFgrbVZhTCtNQlpVeitscGt5WWhlSHRs?=
 =?utf-8?B?NFlGazFSSGNjd0JUKzc2SEVibDBmYitVTW1oaDJWU2lmNTkzOVE3TFZuR3hy?=
 =?utf-8?B?eGE5SG9FQXZlT0l4bkdGMU5YVTE4WlVGRTR2VXZKWjlrLzlqWHcvTi9tcU9m?=
 =?utf-8?B?dUlGdHZ6SHhYbkNrcTRlZzJUTnlrRk51V2hlc0FpNVNpS3NpVXlFSEtLaGU5?=
 =?utf-8?B?OXpFbjdkcTRQVEN4ZURRYTNhV1BibDc3VW5qSk00aWNTWWEyamkyY2hnaC9i?=
 =?utf-8?B?OFR4WWNUTlpHcHpseFR3UjNoSFJpaS82VjBqQlNsVXU0U3ZZbEhrMlF2dFhT?=
 =?utf-8?B?eUJrNklFVVlqT09Ld1hTdEJaakU5Q2pGN2NDQ1ptc3ZJOFNlWWZqZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffbf7dc5-7205-442c-8715-08de604715ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:32:36.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+6cdXI/N9AhDRy2zo1G4pdUxStumAa4r3Crc02bMKkqQ04Su5GDQGLoI8FH/zyuJ+8O7wLlXCFPLKKmu5DJ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8955
X-Rspamd-Server: rspam12
X-Stat-Signature: arkfc9emr3tkktb4aehpiobkjrswppxk
X-Rspamd-Queue-Id: C43DBA0006
X-Rspam-User: 
X-HE-Tag: 1769808761-281157
X-HE-Meta: U2FsdGVkX1+o3bfWK+wsIfAUsVZhCvnF+1UF2bshD75L25uUmtarp0Kipx/KHrkSN69DXkeoeWPjptGnVAzgijR9Sr2UPO12VW32jK1GEe3Cc5vGv98B2+WK3aULzTYhI4AQiGDJ4IU8EqFO84/X4DWrxeOECQ1xYDfPb7sX08uxWbRtw9PscegM0C6Qu6Bc8Ziu7nRtVgINUik2P0YDYD7iTXeJhxVyKowC0vJMnYMr9MKHNES+UmNJRbSgcXaucRE2gKwxCV0fhutyzdxIpqy7jW188kRg9NXwrVsct53+LTKYDjxNWGjfHOzCjXUvoe/fEE3PAY27PkTQaNOFTKa6CnjLRM2k4a958kFT4VVNs2bKz8jUcamKWwRU7Z+tILBmYxvc6muA/Yl6bH2ZqzoF8l94U5gYnvCSveFdYDXWutsKyVSibU2tmKRrNhBFHp/pOhhAeOG9jcxARF6FW0rKcUu8+wRhXtYGjP/VkOLC4iPO6lNjoF5ykt8DIOAQQm4IdG5eHTURXNludUSdooEQJcb/lvZHvCHhaD+pokWwwh+De65tGBpOvsi8TSN2PrIkRTVDWks2vAeOFZ67HrRhylko0OLteVd6fjO0GHGeikF45RYkcvsHAcCaBNrN5Wjmb9dR0EefOGwqf/+s8WUpOi3euKEr6KH0kZLRSYGVRMUuy6SGsNm3OuSTfi6Lcvlmx1eRT3rLuotdfhq47+CQlOTa0tjSDdsqf10CkpHer70q2MBQVUoDB/BiTASG+oB90XxY2BYbuuMuGU5Mok2JhtZcYbYdgIVL5J/pok76YqYmmrhDXpoF36HKhelKcmF53h+5XEh9ZMu/VLeGE5KC0L+z54aRD+SrjMM1lT6DhnUYkdNOuykGN1CRSRiU/dsBeg5Pvii/3VD+NT78tFikudkyVRY1qljoRTs3CxJYwqHbPzNw1YF9aGx5DtqrCpW3lfbPjwsSB92Ks7J
 meNn+f9e
 V/tONlLpWf0JjJhGjKU6sHI3fdSwxoW2d1FCbmO+w0c8LFmM/CZwdT4hiHTbRZqDbxWU+Zw1qbSNwneRXHoBgS+hdrwtzneDuP6g8/9AgFjaXJ4R5sSrxbaD/26DSwnHOL85vkKFLGzzvvoOQk0HZOEA5QEZsvm7CjZnzieG25bWymqQ283gJn/hxPODW5Ggq4GOkGTvK4taFptr2FzjLf6S3S8KotdxvOIi6jifUx5Hs8Rx2Pu91/ps0x+i0W+uYF2kbxX33M8OWqiUFHcYrQ39wLxY7z58dMUv8NLpbLf1VPr1afBV+ksTIi7Nx8JZ2NGA4NsmRND/1x3nBW6wo60o7Yt0BkbkLfufY5VgmGoV4egwqLeC9zHuDV8Wc8RbL65iyomw/oxfNtphSZYhufnldrt58aeYfntWr99q0RsR8Ar+/O0iCqlabgH7fkHgPKUX4b9F+BYHUrgCxkwXv2uR7pPXWU0DGFwCGfejW/A2BPwbx1vY/rs4WpMyD9oGdFY2SVtZ5yzayQPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 30/1/26 22:10, Jordan Niethe wrote:
> The existing design of device private memory imposes limitations which
> render it non functional for certain systems and configurations where
> the physical address space is limited.
> 
> Device private memory is implemented by first reserving a region of the
> physical address space. This is a problem. The physical address space is
> not a resource that is directly under the kernel's control. Availability
> of suitable physical address space is constrained by the underlying
> hardware and firmware and may not always be available.
> 
> Device private memory assumes that it will be able to reserve a device
> memory sized chunk of physical address space. However, there is nothing
> guaranteeing that this will succeed, and there a number of factors that
> increase the likelihood of failure. We need to consider what else may
> exist in the physical address space. It is observed that certain VM
> configurations place very large PCI windows immediately after RAM. Large
> enough that there is no physical address space available at all for
> device private memory. This is more likely to occur on 43 bit physical
> width systems which have less physical address space.
> 
> Instead of using the physical address space, introduce a device private
> address space and allocate devices regions from there to represent the
> device private pages.
> 
> Introduce a new interface memremap_device_private_pagemap() that
> allocates a requested amount of device private address space and creates
> the necessary device private pages.
> 
> To support this new interface, struct dev_pagemap needs some changes:
> 
>    - Add a new dev_pagemap::nr_pages field as an input parameter.
>    - Add a new dev_pagemap::pages array to store the device
>      private pages.
> 
> When using memremap_device_private_pagemap(), rather then passing in
> dev_pagemap::ranges[dev_pagemap::nr_ranges] of physical address space to
> be remapped, dev_pagemap::nr_ranges will always be 1, and the device
> private range that is reserved is returned in dev_pagemap::range.
> 
> Forbid calling memremap_pages() with dev_pagemap::ranges::type =
> MEMORY_DEVICE_PRIVATE.
> 
> Represent this device private address space using a new
> device_private_pgmap_tree maple tree. This tree maps a given device
> private address to a struct dev_pagemap, where a specific device private
> page may then be looked up in that dev_pagemap::pages array.
> 
> Device private address space can be reclaimed and the assoicated device
> private pages freed using the corresponding new
> memunmap_device_private_pagemap() interface.
> 
> Because the device private pages now live outside the physical address
> space, they no longer have a normal PFN. This means that page_to_pfn(),
> et al. are no longer meaningful.
> 
> Introduce helpers:
> 
>    - device_private_page_to_offset()
>    - device_private_folio_to_offset()
> 
> to take a given device private page / folio and return its offset within
> the device private address space.
> 
> Update the places where we previously converted a device private page to
> a PFN to use these new helpers. When we encounter a device private
> offset, instead of looking up its page within the pagemap use
> device_private_offset_to_page() instead.
> 
> Update the existing users:
> 
>   - lib/test_hmm.c
>   - ppc ultravisor
>   - drm/amd/amdkfd
>   - gpu/drm/xe
>   - gpu/drm/nouveau
> 
> to use the new memremap_device_private_pagemap() interface.
> 
> Acked-by: Felix Kuehling <felix.kuehling@amd.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com> # for MM changes
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---

Hi Matthew - the latest intel-xe CI run is passing: https://patchwork.freedesktop.org/series/159738/#rev8

Would you mind reviewing the gpu/drm/xe changes here and in:
- [PATCH v5 01/13] mm/migrate_device: Introduce migrate_pfn_from_page() helper
- [PATCH v5 03/13] mm/migrate_device: Make migrate_device_{pfns,range}() take mpfns	
- [PATCH v5 04/13] mm/migrate_device: Add migrate PFN flag to track device private pages

Thanks very much,
Jordan.



