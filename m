Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03176E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C5A6B0088; Tue, 17 Feb 2026 16:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2B36B0089; Tue, 17 Feb 2026 16:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0801E6B008A; Tue, 17 Feb 2026 16:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30196B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:34:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BA9A13A99E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:34:47 +0000 (UTC)
X-FDA: 84455253414.02.68EF1AA
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5977F40013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:34:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ciKwufWS;
	spf=pass (imf11.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.0 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771364084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6B666VYJV6Uv16k1n7VI7P+3xsyveJ4LMI2MYa6fgM=;
	b=T4Zjt6hO113du87c9/KC3nEUpMpKLTJmVZC1RYbYzh3B+RB8nNUNfeBm6ylMP4q/LSvoU8
	WCtRZAO7PdoW4KCCbA2wzbvsr0dY7ogl0oqBQEZYcYBkr2/hrd/HRUZHxPtT7ihUT582oJ
	Udm6QecoSDaCvU75oO/JDrd1UuxYXvw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ciKwufWS;
	spf=pass (imf11.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.196.0 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771364084; a=rsa-sha256;
	cv=pass;
	b=ZshvR3ilobsSLPKP6sqNrBqYRBx5KngZ5C5uSZaBoHL9sFv8gUFL/mWou0yycxQt2yzYwe
	prV7d/SBcsqGTY+5Q/paDjRkGE32TjcIt7BaKxYLlt7fTFnKp1fol6lCsOuleH3kasnhnV
	W4ZyFT9m5m/qfdAJ9EDgP/8hmvWIcEo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXd6oZ9j65Q7fvCx6U5n0nGPmjd0HKvZc0Ic6eJkAPISIQYk+MrNymoxtScHbL5lz4FNsOaJc/hP7g8t65ZnAZquDk955iKqwQXQa7UHQunFacl8yEzYJssHTAjxeRKXdsrcym5LCo5GY+XJlcB63qA98x6W2LiX3GL43BBi/jQ+t5seyzzRfHRRmxQH43bcQ60DuUUoIapGlIb+pdTjVf69sDcS78uXqhH9hxzH0Wf3YoJtoCSTFIyW7Ciq0kWP+6soiJsGMspdYbEISnMo6bgbhbWeMFuU+CLYAdobR/cDfsOMud1q5Zk/wihkzCb1Wa8KwaAax4B361zsDa7Z0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6B666VYJV6Uv16k1n7VI7P+3xsyveJ4LMI2MYa6fgM=;
 b=ekMF9HsHQdmIZLU3Xjw7XaLgHO1n/K9OXgJVIlrOgCIQoOHg0g3wQ+P0Ej5rtFCi2tOGblMSKsr6sKEBBmQl7t4LiMBTIQQ2RETGLSm4WPR0xIjjEXZ+/OYNK/7OiXgd60J5XpALMcpvnUAJK27V2PYnWAS6EVhksCwuyJnQi1ezMM53ogrSf0a2hhjQuJ4g1JCyC+UJm6Zw2ENrI39AlcvkFK9GhGmksq76q7oDm+onqUiOeHljeLKQk+pDkRN29gwBYG7I1H2qbRA3vmMOuzta1H5UM2+1c7Zt669MCAkTxQDgYVJOr8t4HJqGRf7EZXqMgioA6hfT3ZU5yaPMXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6B666VYJV6Uv16k1n7VI7P+3xsyveJ4LMI2MYa6fgM=;
 b=ciKwufWS2QgeQjMGuuJxuwO4gDKYYcUg5eDbhJlbfR6isqaKKYmSixAzfh5A6tfv7AGQGHTXILLvBXGswwYGoQ8vnGim6Rkzr5dZSFLEDlbOS/JlBrebFIK/1DOdbaNEjqviinxJ9r2b3+oAwd3lvkKj/Xq1CA8fE/NCZ2Y6hKVvWiyMT6Lq7VbZswXAv0yIFCL749J5z7WMjJGR43xhyT89fUfLBIj+QQAoq4qnqIbG8dZMh7xf0cdSaFu7MB6P0X4ZPfCGAwZp/6FoqEzGvp8oI0yHLNTip2ijlG077uEX294Omlp+lkg7W93/FdIDxiv60UHljrxeWJMbEVqoVw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 PH7PR12MB7870.namprd12.prod.outlook.com (2603:10b6:510:27b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Tue, 17 Feb
 2026 21:34:35 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 21:34:35 +0000
Message-ID: <70c6e1a1-afd9-4fd7-92f4-6d53acc58daf@nvidia.com>
Date: Tue, 17 Feb 2026 13:34:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in follow_page_pte
To: syzbot <syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <698f1877.a70a0220.2c38d7.00c2.GAE@google.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <698f1877.a70a0220.2c38d7.00c2.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:a03:331::31) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|PH7PR12MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: d241df9c-7435-4dcf-c520-08de6e6c5877
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZU42cXJJTlV4QVVIWGdkcUh6WWJuTTFtWXVmWGErYWFHM1JzQkVxdi92MUVa?=
 =?utf-8?B?SmdTcjR2ZXdZMnBja2R3M1k2dDlCcXR0SE83a2EwcGVueHlZUVMrdklWM0Q5?=
 =?utf-8?B?UncyeVJMdEo0SlZ6bkR0dnJ0VmVpMWYwWENxRWNXN3ZaY3J3b1ljd3JFVEhL?=
 =?utf-8?B?eUVpQ2hRMFFPVkM0aHYvZmRzbWd5WUJTdVd0K25sdktGWWNrWG5MOXM2aThX?=
 =?utf-8?B?RG43YmEzQzRrNkVGbmg1U2w5U2ZuUFdkdFJVeG5sMTdEWjlhVlByZzRyNEps?=
 =?utf-8?B?d3ZiQ2ZEMkF0WlJELytnVlNiVmdxRzkvV0IvTVJrallwaVRQZVNzaVRIaDE1?=
 =?utf-8?B?cnE5Q0MvZXVMNzNpNHNSeGdKQWgzTkQ3RXBkU2tiQ1FxL3NpRlhuWW9HU1dh?=
 =?utf-8?B?UGMzdDNnNW8zN000TGt0bjlUaHlyTElhOUN6aTJucmg5MHFZV3J3Sk9hZS92?=
 =?utf-8?B?dDEwZUV4YkdYck1QWXFBNDBuR3JyMEZuRUlCeFBocUJFaU5jYXlkRiszZWpx?=
 =?utf-8?B?bjVRRXdZTDh5cUNEKzcvRG1qMkk1SmVvNGtZQVdPY0hsZDBNWTVldkxPWmsw?=
 =?utf-8?B?Q1RCUU1KeWhpR2svOWtaRmw2aHROcG95YWk4VEtvbmczdFZnUmFxSUQ5QnBM?=
 =?utf-8?B?RkZsNXlwdDV0bS8xaEJSdFA4RkROWkt4WGw4SkNVc1dTVkQwMm1UbVBMeFIz?=
 =?utf-8?B?dEg1RDl2UlM1SFlyVnFLdkY0TW5UUUVTYUIvZUNFakhPdWtlcWxFMGVpRmZS?=
 =?utf-8?B?VXo5K3pieE1McmFrUkxrL0g1L0dvdnVKZ05vYjJzWUZNTW92ZjcwVktIWXVU?=
 =?utf-8?B?c3RhUG9HRHdsQlI4N1hISHNkVVVjK3ZXTGx3TUYyWHRGMXFtVGUweHR4L1lF?=
 =?utf-8?B?VEVmd1dBT1VXdDF4NHVQZFVheVVZMnVSbjY5eWkydE1MZXJxYlNFeGh2Y1Za?=
 =?utf-8?B?ZWFUT09CcUJzekNTdzNFMEpwY2lVN2N1T3dsdWdhSzJ3WTdNdWx1N0VVUU1s?=
 =?utf-8?B?MWc0TXpidVltUGRuemFCcDlaY1FWK0JiWmt2SXl0WWxUTW9ITk5jcHl4R0dO?=
 =?utf-8?B?VXhYeDY1OUJXNTc2N3puczdPeklnVlJWcFh4cHpCaEZ5N0hTcU0yVko4S3Rw?=
 =?utf-8?B?ajM1OEUzSnVjSGlCWCtlc1N0dy8vaVd3dXBWQlQxeHh1VDVrVGdjWWcyUjUz?=
 =?utf-8?B?UjAxbU01L1hwOXBYUExKeTAybjBIVU9FTnhaL3pFNEtmMndITTNkdHB1Vm5X?=
 =?utf-8?B?UDQ0TVVIQUtuM2U3QTNlZy91Z1NqWHQ0dlQ4OE9CN0JhWkdSdFpKcGFQSUlm?=
 =?utf-8?B?d2ZKSnhPQW5sY1VHZzBMZmlmOVFVQmczazRhV0diUHQ3RERiYXcwOWlURnp3?=
 =?utf-8?B?MzdwY285VE16ck9RQkQ0ZHg0QzFWYTk3N2hkdlNQZWlMSkRNUVErSWRHWFdv?=
 =?utf-8?B?T055eW1oN0ZaYXlrWlY5M1kyb25JbVZJcTBWc21ZM0tBSHdNRFIyYUV2SThq?=
 =?utf-8?B?ajMvQ0FTN1RLWWlEUkE3bytyR3Z3QnBsY2JwMHNwYmJGOUxUdUxHY3BXMXV1?=
 =?utf-8?B?R2tHT3ZmSGxydXRWSXdaN1VGN0NzbkZrVDJDOTR1cXQwRDhzNVNZdjI2V01u?=
 =?utf-8?B?NVN5QUEzc08zNGdtaUVCb3BOZXN5eEdqaFBoNGhUQUg4c0pMWld0Y0p1dXNj?=
 =?utf-8?B?L1VBV01Jb2c1SENqWmdxeEdVNDgvMkJoUzh3ZXMrbW5pQVBjWlRuRStVTERQ?=
 =?utf-8?B?OVhLa095QXVLT2R0ejdWcTBlT0oyV0RQejRISERoUVNBVnNpTzRDV0FpRzlv?=
 =?utf-8?B?SjAraDlIVFhGc0RrSEdSM2RUQXNSc0UwZVJGdkdZcXdJd0tBTjhTU25QZDJK?=
 =?utf-8?B?enBrYnJ2RmV1SkY2VmtLTFZ0aEpQaHpXVUVUTkJqQ3A3VmhvYlZxR3VWUExx?=
 =?utf-8?B?RExyeHE0TjREYUozZGdtTnhWUU1nWjJLUkFGandXVFk1bUpoN2xzSXo1MTVw?=
 =?utf-8?B?eFpwMXlFdm5zcjFjVkxRK3dlYTIxZDdITWJ6Vkp6R2tmbitaVHVYc1lEc1Y0?=
 =?utf-8?B?Z1VYME5oTWVqMk13Qm5LRUhrUGJ0YlhxY3pIdkVnTnZSSEFoMzdPelhGdjlI?=
 =?utf-8?Q?NIcs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEx0UlZUV1QzRzlTcDFtWlpSL1dNZHlFOFpZazBBVThxYzBiaVppS24wTDJZ?=
 =?utf-8?B?eVF4VWFNblpMTmpjSkovRWpFTkJJTjJ4azNnZXkrcG9BNE5LWFh0OXl0TWVx?=
 =?utf-8?B?enFNTHNwbGN5ZDNjaEFpcGRIZTQ3dlB3QjJhRi9rSC9vVDV3Wlpua1J0Zmht?=
 =?utf-8?B?anRsYXE3bWw1OGYwRDVXRzVLSUI4MTRhT29ELzdTMVF2cnljWGd1d3lNRWE4?=
 =?utf-8?B?T041M3JHMUs5aEkyN3JaUTV1QWdVU09qMDNDRWUyZjVBUVNsN0RRTFlpeE9R?=
 =?utf-8?B?TkpNLzNYeFVFeUl1YjEwVmoyL3dUMHliSDVsY1lCZzVTN1QxcUJWYkJNSW4w?=
 =?utf-8?B?UzdyYWJ2SUNyb3BpOUhNeHJSN0FlWmdVSGgvSWl3c29Sam0vYWVyNGNlVHYv?=
 =?utf-8?B?YXNiOHFjbGhUb2JpOVVnUlRNdUxvNGw3eVl0WXVtVkR3a2xJc3RTMXZUUjJr?=
 =?utf-8?B?bFlQR0lUdmIrNmlqTXZ5Z1crNHJ1N2xMN1JWZXFxSjlNL1phT3Y5QndqSEFW?=
 =?utf-8?B?Z0cweUVyRXhpakZFTjk5azV5NmlkRHF1aWN0OUZoWUVBc1NvSkFJemlTZHQx?=
 =?utf-8?B?ZFF3V0NTaDBTL0t2ckFPbndsWi9GM2lyaWJJYmtISzRTZk9TVk9FbFhDek1m?=
 =?utf-8?B?alovMkViMnN6SDZKWVliRE9RaFdrUHpFSitxOW0zVThQZ0NBVkUzLy93RG42?=
 =?utf-8?B?dzVrNEZGS3FlUUxoN2labExEbUdNZkRIQ2QrV2NFZTZ0bit1UlBHeXUrd0NH?=
 =?utf-8?B?bVlnVEwxU3RnWFZDMWNxM1Y4N3dSV0VXUkJxOEVycTRhTnMzMjBORnlLZjZt?=
 =?utf-8?B?dGo4UURFRjNyTGFCSVFIN0x2d0ZtZzhYeURRS00rcG5jU01sTGloblNzQlVS?=
 =?utf-8?B?b0p0KzhvYklBQUJ1VjBpMWU1TVFhNTZBVHlONnI4ajd3T2kyYnk1QmhCYjFm?=
 =?utf-8?B?UzFpajZya2tLWURrMnYxTTZmcDhUaFFOWWlOMGJyS2x5dkFURkNPZDdnWjcr?=
 =?utf-8?B?MEtQQUZndi9BQkhTUExTcXRxK1J3bFVER2ZYWWtuQk5WMzZvNUNWN2xIcjJW?=
 =?utf-8?B?bnNKNmF1aU5ybVZTZU1PT1JDTmg2Qm1NQjE3azhxUGZtUk8wVmQvWS8xSS9Z?=
 =?utf-8?B?WUc3alIrMWR6MGdCRy96MUIzWjhiY3ZhY1FRc2dMU25KcldsMi9IU0dZczZl?=
 =?utf-8?B?ZTMwczN3T2I2MW5WQlQyaURSVlJVdnBqQldSTTRrSkFEQkxEcVBUdXMwNXFV?=
 =?utf-8?B?RS91ZytQdjZSRURBTDFiNFFHVi9wMmZEblduMmlJWHZIRDRzTlpuVFlFcDFJ?=
 =?utf-8?B?dGYwelJGaGZndStvdGtra2J1WDkwTFhzMklKUTlSdnFGZVVsc0pxS2Mxekxq?=
 =?utf-8?B?TzBXdWU2aUZ6NXBKWTlXMTkwbWx5K0JQcWlTUjZvV0tWRzk0NkRGOFo5ajdr?=
 =?utf-8?B?MHpDekdNNy9INGl4VWRZWXYveXRJQmdhcjFXWElZUXJ3QVMrOUxieHJmRStu?=
 =?utf-8?B?RzFsekNFVjZrR1M3YXliVXVPZDNpWHQ0R1RFbCt6V0p5Z3JzTXhjcUJWR3g5?=
 =?utf-8?B?V2pBUlBSUVN0SklQUW1La05FM1hpVG9DL1dRR2ZwVk1NbE1XTHhpWHUvay9t?=
 =?utf-8?B?a2duS1pmY1dKVTNKbklFekRhbVQyNkxzakFOZmJYSlczV29NR01Fa0dMYzND?=
 =?utf-8?B?eVZtOXVtOVZ4OThmK0YydVBCcVEzZjlYMWEwc3hnelBESUJ0MEcxVFgzOVYr?=
 =?utf-8?B?ZXZtSFlwSHhoVmVveCtmWFlsL0pORFVOd1k4Uk9nNzVJMVpncXA2eHpVTnJ3?=
 =?utf-8?B?b3ZqWDEvamEwTUlVOUxLOHBQdTBYNkIyNDhxbEd4ZTlGQjdCZ29GUGd4UGJv?=
 =?utf-8?B?Q0hPT0Vqa081dnhMdW40SnJsYWhxOUFNRk0xUXVGMWQxaHhkNGs5WDFrSEVN?=
 =?utf-8?B?ejdHbytIZHZqMVhpTG10aDgzSTVnZjFSUFRXVE82cWVjeGUrWUF1eGR3RWh2?=
 =?utf-8?B?aWVUUnByRFU5V1VTWHlrZHpBU3lJTE52QTNtMTM5NXlLdnBOTkw4WjFjcm1D?=
 =?utf-8?B?cTk3Qk9yWllKRGdIRHVnS0U3TzllNkh1cUFrQk5PalBtSGdLR2ZvNnpMN3pC?=
 =?utf-8?B?bDVnMHNlcEZNVmx0V0ZOYldXbGpXQ1hxTkhCamFDUG8vQlh1NEFlWm95WkQw?=
 =?utf-8?B?S09SdzdJVHAxVXd2U2dnVjNuakY2bnJTbjdtTmJvNExBSVpRcVB1aHcxaTkx?=
 =?utf-8?B?WTRjK0VxV3FYT3R1WnRLR1p2VDRlcnNHUHQ5Q2RhWEFWWWtuNi9NeEFyNWxp?=
 =?utf-8?B?c016cWdlZzJsaHgyYVFFTHZha2Vka052V0Q2b1krSCtGQ256eU5Bdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d241df9c-7435-4dcf-c520-08de6e6c5877
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 21:34:35.5510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7N0G+em71BU6A6Uz6fmjzEYM5nPIywXePuHwcSGLuQ140TeiJLL75za5SRjnJKXJgsTIVN7qvEmyhaF8vbRpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7870
X-Stat-Signature: 7exhfqx65qgu17z5cskaqcqtok3jyjud
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5977F40013
X-HE-Tag: 1771364081-278890
X-HE-Meta: U2FsdGVkX19+hLTbSx80ryTE3U4yne/ZP/ENofbzFBE0LBsPgss0WVH3LQOx8BuminBR6a9a1lqTE1IwJlQ2YM8Wnn8JNfI/XYN5NzVObdGAmz0k6/oR/BTHt/mw+oB7xDtJk2HFkFmmmw1Iv+qPRZjphySKPswN4EbFfRZAlSgpa6FiuZARX1VPbxl1+PNsRd7UVvnZ/uSCfa/rSkIOS9nK7GPufyz1iQXwoo4anngyTvYC/DweJZSl26zS3cpXtxpiQJMz6DScPxiRil+70BTKGbH5SB0uLVc7I1RE0hu0qtLd+aDII9hTVTK3zRc5w9zcLfjaWjGSK6gMoP87nd6vyUpdtGss/ZNfv5/f7A6sagM2gDJ7BBvcAUpW2VAi9cYX5Sr52gQFi2HJOWwTk0zjbNRqkG1ymKtR82iWFG01TO0hgU9IQzm7DL1Obf3LmPom+cfi3ZgbVtWe/wqANhZFKb9qhGRtT/oW/cigh7CyMBPcQ5ghkbHcQd3ygFmKKQUGY/9WwvMlzNweyhJRPWNUVV4gsaMMfv2YN9tUxsCKFvuHWE+TdliCglSaoRdQFGpLbMMwiEQbl5+hg/G30nvl3Xmnrgsh8egMp5A1pERzYCepF0HXsQOsqWvs2TAgRGQjlt+zwkxtukXQcz3pTgfaVOSRG4pVxsVAvm/81or389KasQkUtWNrKDWpM0HXsezKtPiLPEiL4XkLKzrp3c4T765P7GsWUetz6ooP/Hjju2kStnfdT+5dkKeHCKp+2dy+LqexB8nanu25AbiCEOrms+O9rcckPT6TCA6zkrIJyPbN7CCTgrNo9toQ650wConXuKo45ACKcTUy0IGDZ2zRz7QNEag4zIc3fhuUWkoI55NFDkcl4yI7oE6b56evT3HS28WFdgEaWSzgvYAJMek0sw3kEJxUzqRyjsRx79nKG9QAOv1e9WIb7O2BxPYqLNd09LVxcx35Qn1dr6t
 7y9vV1FH
 q1mI9B4pl6hycsW5Ze/2IrDy+sjK7wOdgmMH+s/iW92i2sy084+31sa4ean7h5Cx/Unfd5h3PXpd/4+TUdD+EQ4c0zfNf/gpMD/HGshmmTir2f08iFvX+fZqt+9EJNcG2fUA1XYOMMVpXMzDw7TZBjmWkBR1cOOjCXKzibYOj+684xmdeea9Mtu6smvxUSAlAbKsCeYJX1w749/VfrojNq/rzw1mgGA82lvQpwmT/vcd3Dq86kWmCV8oiFtQM22l13D66WpEZqA/HvT8Tv1CcGf3L46BvZ2Zpdkvvd2pwkbn1IUArjv9dP9RIGgFlEgSBzFgFJWrj1KConAF17wkmoxeKD6p4bYCEIQ/fO87ZzjM7p4WNBwtg+0Aeb1fF27O6iDU9Usigs8HQ0FhFL/BSyn5MifsCH+ym7LpBPVjZLvjHYzlkaMVs/9vtNRnB2HhA3d4FB1tXlmWZDBhyzpD9cN6DSsE31COCuS+bgHkjpZDKwEiD3MbbnQzwRJTx3DGaSea6rOFNuObSSxtWvrvZ2Wt+jJQT0HKHLNQuKPOnfAzw//bw5cQqaRDzcoI/EhJTXyFWF39rJlOzl4xvn/hbLoJyV+jFvCZ5bARfuTEJQYYaATHnJom//jlaeG7o2oqP+wJfMY3X6qekKIbf91BlnCtow+8jS2mTSHBACTNjbH2PvFujGDL17sFsK66bUF3+ccBbnX7nv/qvr3sQ9sTM/MVRf09lt4nWWZsQ77bLPkYvoMwVeKK5lqRfB57puWo9vQR736Ck5vNOe6T7rbN8/RaAQ353xwIfao0ypxki5Mf6utOBIP0Tx7XoKxVva9TX+E/Sb4pCEUSr0J/P9nEgszesrPQx6t1f7gb67CLJOakE9nHZ9EcQk3J0gz3ZSY4B8DLbo4VPcC+hM1LaV4TW8KYjv2ePOYQt8Ce/Tty82s0FvwZQ8msPc24F+0iEqA478e/BXl1zLcCH25LgQ/9GI3L+zFZI
 viGi5A2p
 9LxZC2jVDfQL6tXOAZdZHXuTCJBbXDJ30oxZXrn/nOAgqpfQozePdGXEO7Z8uqaRhAm6RSnT9RNpgpVB3fKN41EgtnKOMFVqCUPiegMUyPk8UG1NBn2yK3sb3+SMnqKeZCn7Ms3Ze9QP/kFLCl7BvnKClY8tK5MHOVhtSt2iH7yQUaC9nX8YKJJpYaoqTNKJiVuoo523+EhTrHe2UUYxR58D8CWqkc3rcdu7yXg0KYAFIViREM2odAVy2O2plfkt41N8VhHcz7kB30y5eCOEHS0Dzr8+juKk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 4:26 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    05f7e89ab973 Linux 6.19
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16c324aa580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9682a42d8ec8b05c
> dashboard link: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b9c0cdc82aa9/disk-05f7e89a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e43670d95943/vmlinux-05f7e89a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2c8401722932/bzImage-05f7e89a.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com

I wasn't able to boot a KMSAN kernel locally to test at all, but I did
notice some page allocation paths that call post_alloc_hook() but skip
kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages:

  alloc_pages_bulk_noprof()
  split_free_pages()
  alloc_contig_range_noprof()  (compound path)

So it is possible that we arrived here via the page_pool network
allocator, which calls alloc_pages_bulk_noprof().

Then later, the page is passed into follow_page_pte().

thanks,
John Hubbard

> 
> =====================================================
> BUG: KMSAN: uninit-value in follow_page_pte+0x385/0x15b0 mm/gup.c:816
>  follow_page_pte+0x385/0x15b0 mm/gup.c:816
>  follow_pmd_mask mm/gup.c:915 [inline]
>  follow_pud_mask mm/gup.c:967 [inline]
>  follow_p4d_mask mm/gup.c:984 [inline]
>  follow_page_mask mm/gup.c:1023 [inline]
>  __get_user_pages+0x1524/0x5f00 mm/gup.c:1426
>  __get_user_pages_locked mm/gup.c:1692 [inline]
>  get_dump_page+0x142/0x570 mm/gup.c:2192
>  dump_user_range+0x26e/0x2230 fs/coredump.c:1366
>  elf_core_dump+0x697f/0x6c30 fs/binfmt_elf.c:2111
>  coredump_write+0x209c/0x2d30 fs/coredump.c:1049
>  do_coredump fs/coredump.c:1126 [inline]
>  vfs_coredump+0x7a08/0x8d90 fs/coredump.c:1200
>  get_signal+0x2068/0x29d0 kernel/signal.c:3019
>  arch_do_signal_or_restart+0x53/0xc00 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:75 [inline]
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
>  irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:270 [inline]
>  irqentry_exit_to_user_mode include/linux/irq-entry-common.h:339 [inline]
>  irqentry_exit+0xef/0x6d0 kernel/entry/common.c:196
>  exc_page_fault+0x7e/0xb0 arch/x86/mm/fault.c:1530
>  asm_exc_page_fault+0x2b/0x30 arch/x86/include/asm/idtentry.h:618
> 
> Uninit was stored to memory at:
>  ext4_xattr_set_entry+0x1312/0x3440 fs/ext4/xattr.c:1740
>  ext4_xattr_block_set+0xc74/0x5040 fs/ext4/xattr.c:2030
>  ext4_xattr_set_handle+0x1e25/0x2b10 fs/ext4/xattr.c:2457
>  ext4_xattr_set+0x2ff/0x5a0 fs/ext4/xattr.c:2559
>  ext4_xattr_trusted_set+0x51/0x70 fs/ext4/xattr_trusted.c:38
>  __vfs_setxattr+0x742/0x840 fs/xattr.c:200
>  __vfs_setxattr_noperm+0x224/0xad0 fs/xattr.c:234
>  __vfs_setxattr_locked+0x43c/0x480 fs/xattr.c:295
>  vfs_setxattr+0x28d/0x650 fs/xattr.c:321
>  do_setxattr fs/xattr.c:636 [inline]
>  filename_setxattr+0x3a4/0xcc0 fs/xattr.c:665
>  path_setxattrat+0x6c8/0x7c0 fs/xattr.c:713
>  __do_sys_lsetxattr fs/xattr.c:754 [inline]
>  __se_sys_lsetxattr fs/xattr.c:750 [inline]
>  __x64_sys_lsetxattr+0x103/0x1c0 fs/xattr.c:750
>  x64_sys_call+0x3c8b/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:190
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Uninit was created at:
>  __alloc_frozen_pages_noprof+0x6df/0xf50 mm/page_alloc.c:5263
>  alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
>  alloc_frozen_pages_noprof+0xf6/0x200 mm/mempolicy.c:2557
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x1ea/0x1700 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0x1048/0x38b0 mm/slub.c:4656
>  __slab_alloc+0xa3/0x180 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  __kmalloc_cache_noprof+0x9e0/0x1710 mm/slub.c:5775
>  kmalloc_noprof include/linux/slab.h:957 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  sctp_transport_new+0xb2/0xb60 net/sctp/transport.c:95
>  sctp_assoc_add_peer+0x440/0x22b0 net/sctp/associola.c:617
>  sctp_process_param net/sctp/sm_make_chunk.c:2546 [inline]
>  sctp_process_init+0x11b0/0x3bc0 net/sctp/sm_make_chunk.c:2366
>  sctp_cmd_process_init net/sctp/sm_sideeffect.c:712 [inline]
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1395 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1204 [inline]
>  sctp_do_sm+0x1719/0x9b30 net/sctp/sm_sideeffect.c:1175
>  sctp_assoc_bh_rcv+0x88b/0xbc0 net/sctp/associola.c:1034
>  sctp_inq_push+0x29d/0x350 net/sctp/inqueue.c:88
>  sctp_backlog_rcv+0x3ca/0xd80 net/sctp/input.c:331
>  sk_backlog_rcv include/net/sock.h:1177 [inline]
>  __release_sock+0x3fb/0x7d0 net/core/sock.c:3213
>  release_sock+0x6b/0x260 net/core/sock.c:3795
>  sctp_wait_for_connect+0x451/0x810 net/sctp/socket.c:9393
>  __sctp_connect+0x1483/0x15a0 net/sctp/socket.c:1248
>  __sctp_setsockopt_connectx net/sctp/socket.c:1337 [inline]
>  sctp_getsockopt_connectx3+0x7e5/0x8a0 net/sctp/socket.c:1422
>  sctp_getsockopt+0xd9b/0x14c0 net/sctp/socket.c:8174
>  sock_common_getsockopt+0x9c/0xf0 net/core/sock.c:3946
>  do_sock_getsockopt+0x3a8/0x4c0 net/socket.c:2383
>  __sys_getsockopt net/socket.c:2412 [inline]
>  __do_sys_getsockopt net/socket.c:2419 [inline]
>  __se_sys_getsockopt net/socket.c:2416 [inline]
>  __x64_sys_getsockopt+0x32d/0x520 net/socket.c:2416
>  x64_sys_call+0x3a97/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:56
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> CPU: 0 UID: 0 PID: 9815 Comm: syz.4.1167 Not tainted syzkaller #0 PREEMPT(voluntary) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> =====================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup



