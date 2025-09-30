Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C48CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854048E002D; Tue, 30 Sep 2025 02:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B1B8E0002; Tue, 30 Sep 2025 02:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A598E002D; Tue, 30 Sep 2025 02:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E75F8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:01:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CF5B1405AA
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:01:47 +0000 (UTC)
X-FDA: 83944870254.17.7943D75
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012063.outbound.protection.outlook.com [40.107.209.63])
	by imf23.hostedemail.com (Postfix) with ESMTP id 15EA614000E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:01:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TLqooRIF;
	spf=pass (imf23.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.209.63 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759212104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvepkgKPUwBQiQAYn/7ajZjIxNVocXX9LeuIU3ERPDQ=;
	b=F+Y7pZQ1OanzXy6X4BwAFJ22Ha7UZQ+AnKr+bkok7cceHm5Ss4VDgHPQnlLrqjcl3aUq4C
	DBVPVsPkjHCD/sEnLLSlYbXUA/8kEQlQ2dEsfKvZbBKUP0iSm4N4kEI8lRdW6V8T8vZHA+
	Bc1zC7B+jzKNIlAEuozlW61pAayoRs4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TLqooRIF;
	spf=pass (imf23.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.209.63 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759212104; a=rsa-sha256;
	cv=pass;
	b=onwOsUU0ympcfCVkEc+MXb9BDNsttuJsBhOr9iqzGJc4QoS7VONLSWP18rhThPdUxthoCi
	pFmtV4167fsGYQ2axOEyfQBmI9lspmLHVnOGpsVtEnhyD9CSjgsdumtK5FiYLQeXHBRu3m
	2zXEB/FSiRlfPSEGHL0z6guSk/Ja4v8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m8lS3fF/b6hNDmxt0bzMBN8Ys+Fl5P1zlwIm2X37AjZ93FcqHRj3POWTDsFghBySWycSu/pkG3dc+QQaSR4DccMorr0Ynst0MIL/zrHDimlblz4kLNWjLG4wISa/WgjAPyMu0aLHLbCRWgXq9BnNx22s8J5aXGKcxFUgvF/DZ4R/KAqXAVrD99l8rHiDxmKqTDgPJeSVfLjCW+wClkZ1xEUoUG1kCF1LjODFphfKO14oDJvH5JQ93Q8pP3duIPoZBTbPQFGP6FqhFrlLDhzCWKLd/uuvLXOZwBuoCQAfoH37Fji+oLPWeK9gHB28+eNdx/NPAncGWWmG5QJGG3R/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvepkgKPUwBQiQAYn/7ajZjIxNVocXX9LeuIU3ERPDQ=;
 b=j83b5yFCaItpfQLvJE1YJGkr1tGZT3bRt2U4PSdlZmyaTCzRZ3gA0obSD6Y4Wnpf1NCz8ZHKo6qTbJCz3Aa4F1UdiXkMYAO1+owaNjb71ajKb/NhFHxM4OZHCGCm3bFnoi9JkvgshJigvhHx3COYVEc4yjxn1SvP1Qd/TCPE08/x0XEzWiCbQJyXQqDHzx0udnRCAuy3iEt2P9WtEuvJWHL62pzzdDfBpaC76EFcFnvHQWPIAqk5B6KHfFY+S5VxGCvm5ktOHwIaETQxxlLMRG0rQonU/+xKfww0CmlwuKxLjH2zuF7rdxGd0HwKP8ko35YbRa7IZ6GEoPNUA98bxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvepkgKPUwBQiQAYn/7ajZjIxNVocXX9LeuIU3ERPDQ=;
 b=TLqooRIF41hLep5whIfCoiAwjsT9MzAD40dySgO+9J0xX1ogm1pyvblgjAUWkTmS8v4rn2R4W1VrC2ueTTUVt+d9uDHV01tPGaz4WFZ+5bm7agrGalGq3A/ycfiuZNVZRKRaGMYlrr2c4s/c51rpd199oA+NBPhMtP+uLWcMCQc=
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by IA0PR12MB8973.namprd12.prod.outlook.com (2603:10b6:208:48e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 06:01:40 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 06:01:40 +0000
Message-ID: <cf25616a-b51f-48e3-8f1d-2d580b29244b@amd.com>
Date: Tue, 30 Sep 2025 11:31:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-3-richard.weiyang@gmail.com>
Content-Language: en-US
From: Raghavendra K T <raghavendra.kt@amd.com>
In-Reply-To: <20250927004539.19308-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::10) To PH7PR12MB5805.namprd12.prod.outlook.com
 (2603:10b6:510:1d1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_|IA0PR12MB8973:EE_
X-MS-Office365-Filtering-Correlation-Id: 340f2e7c-2cee-4ffb-36ae-08ddffe6d2ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkszdTNiR3pWL2krWTVYVHFzZTRZWnZFdldMRzRPWXFxMTZ6T3k5ZGtYTVJi?=
 =?utf-8?B?ZllnZnl2aFpWdzRGajhHQVJ5K0M2SHFBei9nMlZmZzNqbTErandObngzN00w?=
 =?utf-8?B?enZSVDZNTHNqTjRSV2p3aVR2Y3NKbXQ5UG1KWGF5aXBJSW1MSXdPMzFwVHZV?=
 =?utf-8?B?cjZSZVkxVWUyd0VpdDVMR043S0pxNDRGNG9jclBSWGp6d3pWSlA5NGJaaFlY?=
 =?utf-8?B?Y1l2SUh3VE0xRjhpV1FwNmV5TFRIaVpCWGZuOHlHRldoN0NrRTVlVmtpdXZB?=
 =?utf-8?B?dWk1OXdyVWRjMElqNzEwaXA5UmdDbUdBVjI5a1R6ZjlEQjJPY0thNXJOWGdU?=
 =?utf-8?B?c0pLRFIyUUZHWG0wR0l3RmJuMGw0UlRwak9udWZoZzFIVVMrdFU4ZzY4T0kw?=
 =?utf-8?B?Q0trSnB3L1hub3A2WXJKTHdkWXhESVpsT1VXbEErWG1ISlpZT0l4WXRPK3Er?=
 =?utf-8?B?ZTJNSHJBT1h6a3dwRlVGeEl0Z0FYR1BxTnFVWHEvQklscC9GSjlTN2VuNFZR?=
 =?utf-8?B?UjVOWlI3VmVtMTloNGVLZ0psRHJWQ2hIK3BxakhqS1hyYUZQZ25HU2JNU0g4?=
 =?utf-8?B?eW1qMitQUk9Hc3FOVmRyMkFaK2dlbVRTWmVtSEwyMVdEUm5zT3ZJVy9pWEN1?=
 =?utf-8?B?SG53Vm9CbVpGOVF2RDh3T1dGcFkrR2lOOGxQUlltZTNjUmVqS1RKRkpGT1Zz?=
 =?utf-8?B?WGpIbk1vRWF5R09NK1U0QWVYdWV0MXF0elFSTXJhbS9MWkp1NUVhaTdwcUhX?=
 =?utf-8?B?TGJtc1ZuWWVkUFlpNVIxUVUzL0lKalo3QU5sbjhHclBjRkJnVkM4SHJYYU14?=
 =?utf-8?B?THJvSFpucmNjUUZmd25BRWxqMGJPNWpJZGpzcFU0aFQxcGswc09vSy9RRW1D?=
 =?utf-8?B?amRac1Z1dkduM3c5bDFLZnNNcGE5S0JKV2Nud0hEejlCM0c2bjA3UmxhT3Rx?=
 =?utf-8?B?cnpBYVdRT05Ed0hzOVMyM01mT0NHaGYrUUFneExSS2hhKy9RU09rVW9Bclk1?=
 =?utf-8?B?RnZqL1F5NmlpWXdVbTdzbm5DWEZ2aGxORHBNLzA2N0RERHh4VDJXVXRCYXRL?=
 =?utf-8?B?MCtRQlRYVDJ2MVRRaVJnOGZwQmpLb3NGMjdRUk9jQWtkVDVtTmhhcDRMNkFH?=
 =?utf-8?B?NjVHMjdKK2RsZFVrYzJtR2thOVdQYk4zWkJ4aERNYTZ3WTAzdmJBaEtCaDgw?=
 =?utf-8?B?aXhJaWJGeGFVOGsrTVFITHFzTU5JV1VGdW5ITG9MK3RlMzQxSWZtM1hTUmxx?=
 =?utf-8?B?SFJ0cnc2eTRaZ1FZalpEbUEyUFA2Y3lsa0FKTHd2S2lpcll0UTlWUUJ5dlAr?=
 =?utf-8?B?Q1B3U2Q4TVRTbnZ3YUF5TUFuaFZJY1VxbzZZTWl1Yy9iVUFBTVdoQzMzSjJP?=
 =?utf-8?B?WCs1aXdZU0JOSDlLTmNPc2lzMGxvOWxHZFpxak5CMXZRUFVyS2EyZ3psMWVt?=
 =?utf-8?B?VW1hQ25BcStOWGZUUEIwNEMzdHJqa05aOHJPTmc2STNRVFR5bDJLTWExZmVS?=
 =?utf-8?B?OUJDR0hSYjRNSThuRjN1QXp6UFpaUHFDeHJXTDVNMS8vZUZiSkYxb2pDNDE5?=
 =?utf-8?B?dzVKNGZ4RUdOTDRhN2NZM3NEcndyMCtKT2c3ZUYwZjJieERRTGhlYUlGeVJ1?=
 =?utf-8?B?a2pqNk9MQUxkUE9GNmJCZ08rVlplaTBMZFJTZ2d1VXhNM0k1cE4xdi9ndHhK?=
 =?utf-8?B?Ykt1RGRtbEc3dnFzeUFTUzRkWjRVMW1RNkhwVXRMUU9hODNOK0E0Q0ExVDdz?=
 =?utf-8?B?ZTB6L1FxK2U1d0JWakVxREQyZ0lvYkp0NzlycllZc0FLUWZBNE4xZ0QvMSti?=
 =?utf-8?B?ZzJyRnlpYmF0SjBYSnViQ01Pam1qVHF6TUN2RHpkTW5XbjZ5WUVhU2JoMTB2?=
 =?utf-8?B?Z3IwOXhocUtSYmY4ZXYvNDMwODNXZXh0eEFGL3k1SkpKek1zcmN1RFhtZjFm?=
 =?utf-8?B?TW9sQWcrSERVQ2ZqTGc3S3Jsb0RjWE1JQ3ltS0tpQkRIZVV3aDRnOTBsdWJZ?=
 =?utf-8?Q?3RCyxkJNirXva7ugzm1p/T0xOxqkT0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTF0NlZyaStmZFZQRTNxNFBEUkVtTmlpZjZwVkhsaCszQXd3aEYxWFh0aFJ4?=
 =?utf-8?B?OEVhdTVrMnRITXR0ay9Dazh5WGk1dmFpeHJFTlZjc29JbTAzZU9HeHFGVkUr?=
 =?utf-8?B?ZXNZTy95U2xFRG1JSXF0TmthMUw1N3VFZEpJM2pVd1QxK2x5b2Rib2NWVmh1?=
 =?utf-8?B?N3N2a2tnaHZaaE5VRVdqOHNIVnlBZTJ4YlEzRkg3ZnJpdHhEdGVpbmp6c0Yy?=
 =?utf-8?B?Snh1ZlRURWF5aGtFRGpDRnY0MWZObHNGeWlXa2sxVkFJTWU5ellMK1Q1UVhY?=
 =?utf-8?B?WjBNUTBVMjlTdGhDOGpiejUvOGNvTERRbU1tMTNUK1EwcGlsdVJydW45WmI0?=
 =?utf-8?B?SWxDVWI0R0pTZmVyU2tMUFZhc294VW04RzQ2SmlHMWZqTlhFZ1IrQ1orSFdp?=
 =?utf-8?B?RWQ1WDBKVE5CVTZ4aC9lRTNJV3huLy9VdXg5RzF6LzRlQ3dWcnpTVXlVeXVD?=
 =?utf-8?B?Njl5eEo3OG9BRk5ETDdPREhKVkZXSWg3bnF1N1YrRlNDYURLbG1LQUcyV05F?=
 =?utf-8?B?OHJQTXdyY2wxeDNYMmpLTXduVkJEdE5UZUdBQU41OGhoL2lhdnRROUxzNVFu?=
 =?utf-8?B?NmhGdFhWald6eEJ3aHdZTGI4NWIwam9WeGVrR3hIQ1NHL2Uvb2VNczBaWk5z?=
 =?utf-8?B?WUFrdW9Mbkk3QVlhY29yUW5jRXBzbnBYY2UrL3A0NEF4K0txbFFzc2pFSmIx?=
 =?utf-8?B?eUNHL0RFZERxRUxWbWlnYjQwNDhQUTh2dXNQTEFmYW5aSzFPT3NvdUhsaFNp?=
 =?utf-8?B?TEJKbHQ2Ky9tMHRraDQzajNHd1RuU203RVNKVXlCTnVrTkFxd1BiMnYxRnRF?=
 =?utf-8?B?QXdoR2JLMmxUVUYwS2haOVRZbVF2K1ZJYWFtTjEyRlBOOFZCVGZKYmc1clBD?=
 =?utf-8?B?aFRqaE9LUjJDdFlnS3hpcUE0R0VEWUk1TVNKK0YvTDJBNkVoZGJRM21EZE54?=
 =?utf-8?B?YVp4RG9CZ2p5c1Jpc3pRbVVtVHNTWDVDVC9sS040YjZENENJb2FSQXB1WTM4?=
 =?utf-8?B?MWtYWFo5SmZHaVZWcEc2a3BreFNUOGYxbi96WHdPbnFPa1U2MjltQU5KTDRk?=
 =?utf-8?B?c2Joam05Z1k0eEFnck8zWlN6QkpvK045cGh2bUI0YjAwT0oxZlAzaE5BaTha?=
 =?utf-8?B?RU93VTU4VVFES1N4RXd4L1YwVk1IaVdGV1lWUTVhRmpsNS9kRzhaRWsrUThK?=
 =?utf-8?B?b2dsN09tK1E2TjQ3c24ycmpXLzNwV2tNb1ZRWDFndi91d0tTd1NMbzl2N2NV?=
 =?utf-8?B?ZE13K0p0UkRYdm1RaklKSTlJTnJLUm5sZHVCVnNldVI0T2JRa0duSXhTamxv?=
 =?utf-8?B?SEp4WWFkN0VRQlNXc2FWalFOdW5DSDg0N0N6YktEN3E0b3Q5VnRNY1VsM3lw?=
 =?utf-8?B?Ri96SklvOHgyb2NxWjVNQm80cS9BWDlFR0VQcUU0T2RSazY3SEdTT01YUzN6?=
 =?utf-8?B?WFhRakRIUVRmN2UwSUlscjdBd1FaMXIrTlEyaDVCMHhuZGNmU2dhYjJCRU1E?=
 =?utf-8?B?U0RaL1FLR3hMTytKSUdKVytRY09lVDRQSTVzMDkvNFpFdFdwMDNKUWltMDBG?=
 =?utf-8?B?bkFkY0hNQXNLUVlxemI2dXFteit1TitFQ2ZvVTYvT0VlNlNIbXZtNFVQSEJ2?=
 =?utf-8?B?eUgwOWdIK1BVUDg3YThFYWFwRFJDS1RHU0FFWXBGcnRIN2V4bVFRWGloQWUx?=
 =?utf-8?B?Unl6WjFIMlVXczZ6TktQUnV3dEFtM281elREdXB6c0tyUjhJa1plQ0QrcDJK?=
 =?utf-8?B?Y1ZjY2dtYStJdmhEOEhaMjR1anB4ZExlVnFWZ243UzVIY0RMbThpeTF5L1hS?=
 =?utf-8?B?YmxYOFFuYTVscGtBdGlSZ3paYmVMVjlUMzg2b0MvMGtTMGRndDlndHRsd2pI?=
 =?utf-8?B?NEtjZlpYSXRUSysydk85K2JMY2tLdElJRmY5RjZua2puZzkvNzgrY0gydlJY?=
 =?utf-8?B?SWdqdHJWR3pueVVodjN0MlZTVzFmSStMV1dOdjhKSCtIUklIR2pNUlVpTGVK?=
 =?utf-8?B?UXYvV2V5ZTFkaGdzUW5DM0hMSzBEVVc4c0dSUSt6ZUlrNmF0dHpGK2NmSnBa?=
 =?utf-8?B?Q3hwU2hSWGU1NjRLVmNrN1drQ1YyaFhWV2J0aFhWS09xL1ZRSnAyM2dBMkdP?=
 =?utf-8?Q?3S6tFZdG+D8/xhajKP+arQNXL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 340f2e7c-2cee-4ffb-36ae-08ddffe6d2ba
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 06:01:40.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niOEUyH39f4H0mzYeY9OzbUKoVk0oGqDDEv2bYjrUIrpw2P/QxyLb+pVPPNUYkucO1yOF0oWeHYoZ+y7+JMqvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8973
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 15EA614000E
X-Stat-Signature: oqxnzp6xrud64hsnf68714o6eebizihg
X-HE-Tag: 1759212103-899914
X-HE-Meta: U2FsdGVkX1/6VmmWaEnm4sl1xJiVYY4WwuDX9Y0LvWrboSaraIQGf0FnGNuTZksnl/hb8j2bbuf4WaqXj/WxALI/WEdog/Xxiz0xK4wx8bEkjdZatWGQXjY4q6ZKL4QDOzdAcssn/+URt4vSOEpke5CMcspR5tlNjyR5vgz4BWOIf2QEjySLpFC2FYRM7L1FCrY58Lx+/XZvbmDu/p3UxpVDbtOH6WUOEr3PTCaGhi0ciZNvjWwD5Ze8SutB6Qo9XLhxmUSBy4eCcHmZ7/lpVLRJFUEQsBLvHe3JAW99+JKsHz6vBHTM2ViFbBS404YhBXcU3dB0fuyaaSQ89+MyxMOPV5bhT+XUHLHNnlLjrL0BBPL1feDofeY0luWOHK6iNS97ORw9Z+jAqEAw5cv0Nuzgp3A2jucNWpCxMJxwjxNIEOl6Ybt9YTakeGpzsXJhB1Rqy7xvxqdpANz1nEyxJE3OVNedrPAaJfogdD5pvhRgRK4krFrtrDUMQ2qbCJLZ1zRJ7MekUABgGL21a5nTihoHRMIYXdFFN3TYAqzp2tZxW45q9lVwbNczxFwgGu6Vx8B+02jUk/aS2wf+Pg7hKVcYlRjGRBtkBXog1ZZhU1vh3gW9Jw2H+lRfI4xyBnrhPIt1Hsx0LhJOOnuPtfvvO/eYl/WxmcbMehEWYvGGK3S1V7gaS2AJXLO9+83qGXIo52CblggAmWe9IARegtN2re5WiAB9Q5454MM2Kvxfi3Zi1CbJdvCYEEeREjta1pk9GonxfYTOY9ecHFDOGdg1dcjMwO3xtXiLnu9eqM1hNKZMErDxI2iatLZ5v0hdVyRUPZKe40V0A53qfz4OyuwAdTC0owVSHzUMpRCINx3AHa7/C0ImvLYEIfC+8E5aJxRBOlrnfBpC7mN2MwM5GaUmjZ1CWgwZnAzZhIzuT3AVAnnFiEkoYJjHF0IEjPLdWTUqGps4RvNgxmXFXfqDgfN
 bBTpLDmr
 0kA8OI10FPuE5tAiweTjWlQpacYWHZuZ8p/dnTDoujBZaVYJWq1P89OO8YAu4rhkgUJ9zri4k1bTtzXKd2YBtSoJLamuzd9yPKtPKaytAmeGTsGBVpS8u3SALqXDdCP/M+kiQyvfA1lJvvTDT+kiRT8n9NWGEtFzbIpbVdQ27LBX+WNuXbdLKk3SuONCqJcgq6YWbbCm8+aWMRT8M8ne7liSMDHsRZ/zW+7XZEsMVLXOBTFIAdWNvA4BjkXP/yLw7vtVzKYwU8K/VX7g3c9BFVjZegwcaDQ1mA0uFiCWzHydoDmJPT0uwhQfde4RB24H4zXz9MT/vFkxHZ8W4P8h5vmR7kYm76zcGT+La1P2xAct3+Q1i1Z6B5ovWeknPnCzVuWx3GzoXN7tneF6m9Q+gPW2ihlwb9/ERTGYYi9JQyUJ1S9TEKU1KxS4Euhcw/hBARK7YcnMVmDcYixf3mKUTMSx+z8NxJTWUhaHH/8+939XOHOcOcHphFsGGzFcYx+xU1youcuHI99qksoc6E2Vqaw0wlDrVBjPV3q5taHrUGtCqWEK6IpDysqQ/aGQyZjVCxfIR6AA/5DeYTLv0B9PCmrhiub76Q5UCq5DPFW1E+ZJKg+BUX6LQQRvYI1XubhRcDMXMWXu5CnIcZfOxf4DkSF6a9JEwWUTpONDdKX8zSLZTR+puaS/QkEl/ZY4qjWzvew7/HiRuye7H2UQFWk5PnVs38SVMImyGazeCTrc7PygoLAfKDc+9M3xbKb1rT24euqWRIR/CRAnzDqfzTVsynsD0l1+ZWjre0SwoJCuGFPJjcjmRJFlA6ux4OEnJBuK1tlBUwPlAsxattuo4oyqxpVujNjmkuzOy58ScdMdhfI2j4OJ5SqF2kpeGft3Y2F5pAr6pj+PJ618S69UbHbaWoK2nK8xNvX4w3gepm3ZNiBsZ9CuAsURZbEzr190Tfu/9s714FlqCWfuClQCH9kwtENGrhW/r
 fvfhQyCR
 VoUACp1mps4W/BsVaZ/5hCPQhoDIbOzNTUnQa62pHf0StrPs9s1+HvUNjw4CA/hi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/2025 6:15 AM, Wei Yang wrote:
> Current code calls mm_slot_entry() even when we don't have a valid slot,
> which is not future proof. Currently, this is not a problem because
> "slot" is the first member in struct khugepaged_mm_slot.
> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>
> 

Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>

> ---
> v3:
>    * adjust changelog
>    * rename the slab cache to "mm_slot"
> v2:
>    * fix a PF reported by SeongJae, where slot is changed to next one
> ---
>   mm/khugepaged.c | 55 ++++++++++++++++---------------------------------
>   1 file changed, 18 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 204ce3059267..67540078083b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -103,14 +103,6 @@ struct collapse_control {
>   	nodemask_t alloc_nmask;
>   };
>   
> -/**
> - * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
> - * @slot: hash lookup from mm to mm_slot
> - */
> -struct khugepaged_mm_slot {
> -	struct mm_slot slot;
> -};
> -
>   /**
>    * struct khugepaged_scan - cursor for scanning
>    * @mm_head: the head of the mm list to scan
> @@ -121,7 +113,7 @@ struct khugepaged_mm_slot {
>    */
>   struct khugepaged_scan {
>   	struct list_head mm_head;
> -	struct khugepaged_mm_slot *mm_slot;
> +	struct mm_slot *mm_slot;
>   	unsigned long address;
>   };
>   

Thanks.

The change definitely makes sense  since there are no other members in
khugepaged_mm_slot.  Also slot => mm_slot name change makes it more
clear (from my experience using this code as reference in kscand )


> @@ -384,7 +376,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
>   
>   int __init khugepaged_init(void)
>   {
> -	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
> +	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
>   	if (!mm_slot_cache)
>   		return -ENOMEM;
>   
> @@ -438,7 +430,6 @@ static bool hugepage_pmd_enabled(void)
>   
>   void __khugepaged_enter(struct mm_struct *mm)
>   {
> -	struct khugepaged_mm_slot *mm_slot;
>   	struct mm_slot *slot;
>   	int wakeup;
>   
> @@ -447,12 +438,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>   	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>   		return;
>   
> -	mm_slot = mm_slot_alloc(mm_slot_cache);
> -	if (!mm_slot)
> +	slot = mm_slot_alloc(mm_slot_cache);
> +	if (!slot)
>   		return;
>   
> -	slot = &mm_slot->slot;
> -
>   	spin_lock(&khugepaged_mm_lock);
>   	mm_slot_insert(mm_slots_hash, mm, slot);
>   	/*
> @@ -480,14 +469,12 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>   
>   void __khugepaged_exit(struct mm_struct *mm)
>   {
> -	struct khugepaged_mm_slot *mm_slot;
>   	struct mm_slot *slot;
>   	int free = 0;
>   
>   	spin_lock(&khugepaged_mm_lock);
>   	slot = mm_slot_lookup(mm_slots_hash, mm);
> -	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> -	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
> +	if (slot && khugepaged_scan.mm_slot != slot) {
>   		hash_del(&slot->hash);
>   		list_del(&slot->mm_node);
>   		free = 1;
> @@ -496,9 +483,9 @@ void __khugepaged_exit(struct mm_struct *mm)
>   
>   	if (free) {
>   		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> -		mm_slot_free(mm_slot_cache, mm_slot);
> +		mm_slot_free(mm_slot_cache, slot);
>   		mmdrop(mm);
> -	} else if (mm_slot) {
> +	} else if (slot) {
>   		/*
>   		 * This is required to serialize against
>   		 * hpage_collapse_test_exit() (which is guaranteed to run
> @@ -1432,9 +1419,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	return result;
>   }
>   
> -static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
> +static void collect_mm_slot(struct mm_slot *slot)
>   {
> -	struct mm_slot *slot = &mm_slot->slot;
>   	struct mm_struct *mm = slot->mm;
>   
>   	lockdep_assert_held(&khugepaged_mm_lock);
> @@ -1451,7 +1437,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>   		 */
>   
>   		/* khugepaged_mm_lock actually not necessary for the below */
> -		mm_slot_free(mm_slot_cache, mm_slot);
> +		mm_slot_free(mm_slot_cache, slot);
>   		mmdrop(mm);
>   	}
>   }
> @@ -2394,7 +2380,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	__acquires(&khugepaged_mm_lock)
>   {
>   	struct vma_iterator vmi;
> -	struct khugepaged_mm_slot *mm_slot;
>   	struct mm_slot *slot;
>   	struct mm_struct *mm;
>   	struct vm_area_struct *vma;
> @@ -2405,14 +2390,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	*result = SCAN_FAIL;
>   
>   	if (khugepaged_scan.mm_slot) {
> -		mm_slot = khugepaged_scan.mm_slot;
> -		slot = &mm_slot->slot;
> +		slot = khugepaged_scan.mm_slot;
>   	} else {
>   		slot = list_first_entry(&khugepaged_scan.mm_head,
>   				     struct mm_slot, mm_node);
> -		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>   		khugepaged_scan.address = 0;
> -		khugepaged_scan.mm_slot = mm_slot;
> +		khugepaged_scan.mm_slot = slot;
>   	}
>   	spin_unlock(&khugepaged_mm_lock);
>   
> @@ -2510,7 +2493,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   breakouterloop_mmap_lock:
>   
>   	spin_lock(&khugepaged_mm_lock);
> -	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
> +	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>   	/*
>   	 * Release the current mm_slot if this mm is about to die, or
>   	 * if we scanned all vmas of this mm.
> @@ -2522,16 +2505,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   		 * mm_slot not pointing to the exiting mm.
>   		 */
>   		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> -			slot = list_next_entry(slot, mm_node);
> -			khugepaged_scan.mm_slot =
> -				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> +			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>   			khugepaged_scan.address = 0;
>   		} else {
>   			khugepaged_scan.mm_slot = NULL;
>   			khugepaged_full_scans++;
>   		}
>   
> -		collect_mm_slot(mm_slot);
> +		collect_mm_slot(slot);
>   	}
>   
>   	return progress;
> @@ -2618,7 +2599,7 @@ static void khugepaged_wait_work(void)
>   
>   static int khugepaged(void *none)
>   {
> -	struct khugepaged_mm_slot *mm_slot;
> +	struct mm_slot *slot;
>   
>   	set_freezable();
>   	set_user_nice(current, MAX_NICE);
> @@ -2629,10 +2610,10 @@ static int khugepaged(void *none)
>   	}
>   
>   	spin_lock(&khugepaged_mm_lock);
> -	mm_slot = khugepaged_scan.mm_slot;
> +	slot = khugepaged_scan.mm_slot;
>   	khugepaged_scan.mm_slot = NULL;
> -	if (mm_slot)
> -		collect_mm_slot(mm_slot);
> +	if (slot)
> +		collect_mm_slot(slot);
>   	spin_unlock(&khugepaged_mm_lock);
>   	return 0;
>   }


