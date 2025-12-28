Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1F5D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 17:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E226B0005; Sun, 28 Dec 2025 12:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5536B0089; Sun, 28 Dec 2025 12:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD196B008A; Sun, 28 Dec 2025 12:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 257276B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:58:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7F581A04FE
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 17:58:26 +0000 (UTC)
X-FDA: 84269639412.21.D20C7FE
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011008.outbound.protection.outlook.com [52.101.62.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id BBEFEA0009
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 17:58:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=s87LqPxk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.8 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766944704; a=rsa-sha256;
	cv=pass;
	b=H5AH3DSq2JSIECN3u2Y9hmMgo9iaM1POi50KybNtb9pnpDnaML40zes9rEua0KVsFG7PhC
	zOgk0EvwITA89FEteOmFezLKZcQtpOvBJM0VelZo2cwYeJIcKLj1lJ7JcdrpTj4wc87KcG
	eVddNNEfEpsIzcYNInBhNMEt6wh9BSo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=s87LqPxk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.8 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766944704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VAAuHbsyX+xxelQ1SSh9r9mCp87MPzjt+kqPfv1VC4=;
	b=8a0jhZWBchduuBxahyCGgZW9iXjkhrxdDXEN2F82k1WkCLGarBmQVryP8t5fqMiiNv0AUv
	T6Nqugpf+SV/e8DUkrbrfgWvUO7luL8ttrdqwNWJwWj3MUvrPrrbxddvmFz4nYG65CAYKM
	jEpGGVmWUQUTC/W9u9Z9QZAlCP06zaU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXf+lxnYt3gbWkWfsttSoc9ZqedakuD0K/yLKqVwjporBh8K5M/FtD+Rqq0OO4XjKdRVUXsnCwJE84hXohzn8QD3TM/VXLnbF+M4XIDhnawUywsShl300zQ5WXNzrqbZtAYGDEYdR4r6BNkQwyryQ1qqUeoZ1CjKjc8ujQ+BdRFf8JM5vK4Z52R0LOGl4fSliWf+Zkv0873XX1T0CfBzL86sUPGXM8SlkjHGi9lf9ctWJW7iEQ88jwEEtH/I/MYZ8RfMc9Kuo6y9T3LZN6JR1YzvDqWWAbEJEm6LmzmSMpw5Jgnx1oiBnarNXmw1s3SFn83VontPTTnhIididOhYIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VAAuHbsyX+xxelQ1SSh9r9mCp87MPzjt+kqPfv1VC4=;
 b=tPGmbRO4ea8M5/6DTygsLvuYvKeiRiGw8R56FxOUlXeTsY0H90LRzfkovDnMkPa7iIdNmh46qkdvl+SXM3fblrMrPYNCs8PWxKrh0wzJrKRb+WLM/XxODwzARr/1L4PcuNHhVFP2Zt94jHbllPVFx+AdvKf4r54u2KLa12pSgeN2KKW5POpuLqKFKVquZV67ElURAMHCvy8GddunGycRrIs10sHhZuaUBuwCx0H3KEJhTbFauKTvkMtoftAPhG+C4Qq2d+zlvHEX2fel7/EciGshhUXi2s3QDHtTsG1W2RK0TY5mUGZg2c9yvmHyDRl8gtmuN93WaeCrkX5FffIPLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VAAuHbsyX+xxelQ1SSh9r9mCp87MPzjt+kqPfv1VC4=;
 b=s87LqPxkTOW1yaQwz8muM23SvaS7R4K6ZDfIUJCbYwwofRNkC7umIqAQK7NgkEVdf0ZAwR3VcuVgvNN88xJ5MBYbwNoWL6dkUVO5QQiRlgoCM/ih0r74wfzFhJXwryQjZajHzchRzWm54NBktWN+uw2UqN3BTRjUGKvehp5kZHY=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by IA1PR12MB8222.namprd12.prod.outlook.com (2603:10b6:208:3f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.12; Sun, 28 Dec
 2025 17:58:19 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9456.013; Sun, 28 Dec 2025
 17:58:19 +0000
Content-Type: multipart/mixed; boundary="------------W0rvxkEU0Hr4p7IpwYTh3e80"
Message-ID: <24ed11d1-4761-458f-900b-8fa79379ace2@amd.com>
Date: Sun, 28 Dec 2025 23:28:12 +0530
User-Agent: Mozilla Thunderbird
From: "Garg, Shivank" <shivankg@amd.com>
Subject: Re: [PATCH V2 2/5] mm/khugepaged: count small VMAs towards scan limit
To: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-8-shivankg@amd.com>
 <6b408736-978a-4d40-adfc-97819951c3a6@linux.dev>
 <20251224144954.2bhei4bk27f462nb@master>
Content-Language: en-US
In-Reply-To: <20251224144954.2bhei4bk27f462nb@master>
X-ClientProxiedBy: MA1PR01CA0181.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::19) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|IA1PR12MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: da06b420-23b9-4b25-8843-08de463aaef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|4053099003|4013099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1RzbVNGbS9WTlF0Nnd0NldqK2dib3FldnVGMlhjTU00YkZRbmc3Z2lNRUtQ?=
 =?utf-8?B?cjlUQmtYMmlRaFhGUHF4OWw3RXAvaVFmMTNyQzhlaTI0eHBMVVdKNlpTRU12?=
 =?utf-8?B?ZzVxZUc1aTgyOG9nR3gwSm84S1lWVUJEY1NvUkNUdGZqZzlKU2dRQ3pRVyt6?=
 =?utf-8?B?MGpmTGlJTXFDY2duRmpnaVU5byt4cTBRekRRS2V5MWZHdndOamU3QTBxYUdI?=
 =?utf-8?B?bThkZ2pxeHNacUVnQUtlWURpT0sralFoL2w0NTF4UlBxWERWR0Z1czMwaERl?=
 =?utf-8?B?dWg1N1JSSmZwWmlwKzhBUGUwMlZtZitnc2xkR2ljejBpaWFzR0p5cERVV3Nw?=
 =?utf-8?B?Y1pwTGR3bDFHYlhnNGtUZDJiUXZ1MzRTQjhjQjlGdnJFNTEvQUwwTlVWNlZB?=
 =?utf-8?B?eHpKUE15cHFFUDg5amVMZDIrQWtTeHBLd2pBOFlqUURpbXJ2UTl5RkFjZEVx?=
 =?utf-8?B?WE1OS2tUd0dKQnNJTDdidnJCanRLOTJyYk4vemwzb1ljcGc3NU5ld2ZZcFlO?=
 =?utf-8?B?Q2FGOUthMXRGUEVWa2wzRXFUajRJVi9lUVMrU09zZ2NjVFliNzl6b2g0allz?=
 =?utf-8?B?WjVqMmdOem4zWlo1ZklCc3ZFQUFQaW1MK21RKzAzZUJOYmVZSFpBdm9JYUQ3?=
 =?utf-8?B?RnVyRGF5OXozdGtvMHN4VUFXK3Qya21QYmtnSjJCWGJLOHFWNkx2L1dQUEpp?=
 =?utf-8?B?bXl3c3dtS2ROT04xclZCcVpZR01NcUJHZU55QmFJcEx1bDdzM1E5aVRkYVpy?=
 =?utf-8?B?S09ZR0IyZ3ZhMWZ4QTZ3cHRrK2NJbkZvQnVmYnByOE1NY1UrL2xzdGhvYmxC?=
 =?utf-8?B?d0tlK2s0NzBId25ISXNhckZDMkwzZmJJbWs1bG5OT2JiejFyQzV4UHp1ejcx?=
 =?utf-8?B?MW5NRU96T1Rxd3BuTjZndUNvTktHZTNDYzVWTVIyVDloQVIwTTRVMHRwbVNF?=
 =?utf-8?B?L1MrQW4xU0J3RTFqV0c2UHAvMFJqM21lL2I2dFJmV1p1K0t1b002U1ZYaitn?=
 =?utf-8?B?UUdpWjl1WXF4Y3FwdCtteHJTT0R0WnhqMFpGenZ0ZFU3cmUreVZmTk5DUlBF?=
 =?utf-8?B?Smx4YUhQMW8zSjlyMmt2SEozTFhuUndzSUQvNS9PS1pqclVmK2NQdXFXcnlj?=
 =?utf-8?B?N2ViKzB1d20zYXFrVnVjanpQa0ZuNEdSWUI0N09DYjV5TnIzYTl3YWtxR25M?=
 =?utf-8?B?aTBPbGRIY3E0cGwzbXVlRW9DelFHeFBNai8vNW1LREtEZHl2WlJyQVBqd29Q?=
 =?utf-8?B?cTB5ZmtDdW11alRvbzFlT1huUDVYaGFOZFBObjM2V1RYUzIxVXl3dzByZEpM?=
 =?utf-8?B?N2NjeDJURmZ4SzFiZ2FKRklQdENKcHpKTlgyQlQvMFdBdnNwLy85RjRIU1hL?=
 =?utf-8?B?UDhZS0tIek92M3J6SnNlc0tPa3pIbVdHZHFVR0JBZjVxVFQzZWZNdExkYUNV?=
 =?utf-8?B?b3NVcC8vWWFNZXpUZkFGb1oreFM1NjArQ2oyTFhNYnBBQTZkMDNETGtOaXRj?=
 =?utf-8?B?MldjTGhFaHczaVZuNmcvbUR2SGlRM0JXRnovc3NHaGFNRmNadmNoNVg1MmZI?=
 =?utf-8?B?ZmQzd0dKWFgwNEhjS2JXTWQ0RFBRZ3JhRXBjL2pjZDhvczMyZ0FjMlR5bHZI?=
 =?utf-8?B?bkdEaVFUNWpkZUUwSU5EQTVuQWR4amR2a2VHQzRnUWxhbUtYM3hPM0NwNnZa?=
 =?utf-8?B?U2NSSkJrcjl4SWlueUFTY1VsUTJZUlFCc0prWnQ4UXA4R2tQRkNFVmZia3hJ?=
 =?utf-8?B?OE53djBMY0xlT3RRa0JTNjJ1MTFEZG5BWU1mSnArL0xTdmVCTFpWUDVSMW5s?=
 =?utf-8?B?TWZxRTNuYmxRbVl4QmUxYUZaTzBjT3RPaXN4R1licTVJeVdQaE1vcVNlZTFy?=
 =?utf-8?B?d3EwalhqTjU1S0xsM2dxOFVqMGlTSTZlbmpxcEFuVlRIYVNCc1dueGFBbDlJ?=
 =?utf-8?Q?5fk1JXVFlKmMbxb2oaE5um0+32wMKaMl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(4053099003)(4013099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azhWV09SMkVhV1MrdWhHUnBpa1BJZ085L1BucWNMd3pkZ2RtSXlxYXhBZmVN?=
 =?utf-8?B?emJhZWhDT0RYS1BIenhtTWdHUndyczI5NjRBbHhzQmFpV0YrcGFxZS8rWFBm?=
 =?utf-8?B?dU5QNEtKeDZqdFJyWnY2SHo1cWVnQTN5UXIyUFpMSW11ZlJ6QTFzbFRUQytU?=
 =?utf-8?B?MEVMMUJBOWVUNVpXYjdaYmtjeW9mMDF1YkY4c0RFbDRyR3FpWUxtdWh4TUdm?=
 =?utf-8?B?ZVIvbXVDa3NYN1Z1OHZueXhHdzFUQnZvSkVqb3RCeFFiS0k2WGhYTUZxSU1u?=
 =?utf-8?B?dVpJWFp1YktnWEN1dU1KRDQxYlgxOWx0enBqUmhabmFCNStLa2JYOGhwUGND?=
 =?utf-8?B?R2R5Ykw5K2NLbm9JQkJJdG1xNU1aY3FRYkxWS0kwU21PRG5sN2ZMT1RUbmIw?=
 =?utf-8?B?SUxFbG92eEVEN3ZWNWZQeld0UzFrT3RWd3NkUS95bDExcXgvcmIrTFRBMzBv?=
 =?utf-8?B?R2QvU2dGWUhyc29BU1h1MUkrZlovc0pCdmFUb0VuYkcrUGkrbHArSnRJU1Nj?=
 =?utf-8?B?OFQxZExOY0crUlVZTHpEaVNGM1paVFU1WmlpVncvQmphZmZyM0hjNnRVVkJJ?=
 =?utf-8?B?alpCQWdSN0wzVzhvelBLR0NoTWRiUkwwalFSMTVzUjJkQkRwVzhxZFAycTFh?=
 =?utf-8?B?SFhzd3RqbGtlc0JSNUxoK01jczRLWjZUc1FZV0ExSzRJdlBaYkYxVUI1clQv?=
 =?utf-8?B?MFJFYXI1YVp2czRJU1MzWmNRVGVTbWpJNFo4ay9ZQmtWYjg2dm55aHdYdUtG?=
 =?utf-8?B?TzJSRjNwYmRlV05EMk1ZNlpIRktnR045a3ZoZnV2eXF2MW1qUEIzV3dJV2JY?=
 =?utf-8?B?OVRjQXk5WTdoVHVaYXRDVDdQR0JQSkxtZ2xBdjlYcHliY2NURE4yUTRoMnd2?=
 =?utf-8?B?aGZHdEN4OXUvY1pWZDJRR1lDVldzTGwySXpqQUV1ZlRBZW1vN0d5OVhhUXJm?=
 =?utf-8?B?RUZ4bldTZ3NpS2NpVExqYUFzNmVzbUtPRzJXNzI4SWZ2NFk4ZWpHTHgwSi9I?=
 =?utf-8?B?aTVjdU8zTzBnMGFVMzV2Ykd6Z2NDYlR3b0IrNDlDc0ZQZFB6VUUvVWxWM3B4?=
 =?utf-8?B?dlZxckkvR3cwNkF2R3M1QUlCampyT29SMzFoZ21VVm5mY0xTR2xxUS9qaUo5?=
 =?utf-8?B?cUdEMVFqTTFsZkxrUTdCRlpDSnRMQlFNYjdqZDJMRmg5d1paVHRzMlRoYjJr?=
 =?utf-8?B?anNZNXVoemR4NUQzK0hoRFNnaUVCeW55Ky9Ma01GYzVYZDluRFhNd2FkbThV?=
 =?utf-8?B?Vmh3cHRMVHY3QmIwQmNldHBjdHh5YWhwdmpyQ1hETmh1TFVFWmowV3BKcDZo?=
 =?utf-8?B?UUludXBjVWoyVlYrcGhpU05oRitZQzZKM3psVXBiekJLaDFjMmZZOHlpM0lK?=
 =?utf-8?B?TXNQbFBhd1FPelQ3UjVPNk9YcmE0cHJNeFJGbm5FcW1XbGl5ek1uMlp6NS9x?=
 =?utf-8?B?aE9sYkdaZEhwcExzUzltRVgxWnMwU2prSEdQWVVSRzFoYmZmLzRBSDl4UWdZ?=
 =?utf-8?B?VWpGSzNjc0Jsb3RsT3RKWlBULzBRQVBsRDlLamR3a0FrakFaemF0YjNkM04y?=
 =?utf-8?B?U242Y0NlNVM2ajhYSVY2WjRKNlhzWFFldTBtcUgxNEFBWDQ0aXhzdmZiYkFz?=
 =?utf-8?B?Q0E1L2R2bTN6UVdySDhXSTFsRm9lSE5GR0Y2WDJOOUZ5aHlLZ0kyZHZtSkNP?=
 =?utf-8?B?cGcwbUI2Nkd5STFhbWg3Q2JJZjJoelV5VDN4djZEeEluQmdxL1JRSjdqV0th?=
 =?utf-8?B?UmdqaUx5U08zL21Nbm1YQ0NDZnljVHlkQTdXWDJMbktlMkhpLzZtdUc3RytF?=
 =?utf-8?B?bDFaV3IxUkNpQ2N2aEhnWkdScmdlaEJLUEduTDI5NGZpWGlxUnF2QlEySU1w?=
 =?utf-8?B?eVRZSDMzWDVLSFVWMlEzWjgrRWE0eHVieEdpYi80NHM4bHdjdGY3WDZFRC8v?=
 =?utf-8?B?UThMQ05nT2I1c1c1UWJ1cm9GaDZKNDZ2aVRXbTMvZ2hxRHF1MHJOb01kU2FH?=
 =?utf-8?B?TEFNRUxRT0VFYkVuQ3orV3Z0ZkEvZ2FYQ3psaDhGUmpNSVVYZlJyY1hpSTdl?=
 =?utf-8?B?NHJXbEpOQ3FyWXJFTXdEY0I3anc5QURKNndRc3VSYWdaMjVxK1dqMW5aR0Z2?=
 =?utf-8?B?NlY4K2Q3RWN5Z2l5N2Q1UHRnaE1pOExQaUJ5TzBWczlTUTU1dlJuM0xOczgy?=
 =?utf-8?B?bkM4VC9MdHNrSlgzanVHc2NwR1h1eXd5V0NMMjhYSXQzb05jTkdZQVBjdGto?=
 =?utf-8?B?TDhzZXVSZUpsVFZiYXpPUDVSek1lZ2RsTG1aZVc0OGF2TWVEcTZ4ejk5V3NY?=
 =?utf-8?B?VWpSWXRxaHBORnhNektDK1V2ZWlEUkhyaVVxQVo3eFVqZExFMU9Cdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da06b420-23b9-4b25-8843-08de463aaef2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2025 17:58:19.1474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhxUrllBeGWbFBx0TUNaKSSX6RFEHd80PGM7Au6XMQ6w7SSm0zzW0x6k3+C5y1mvk+NmPcZvK0PXhj1BtiKVqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8222
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BBEFEA0009
X-Stat-Signature: snoxgt71ebhzt33wbmifgyraedgz6xoj
X-HE-Tag: 1766944703-9291
X-HE-Meta: U2FsdGVkX19pIRhWfUSdc/CLJbl8ek0eLYmw2oKa+ggsStjjzbimRcHwICnsYgvkhes6b0pm4KMGhgnD/p1qCNLJdwyScBKHFdWq+YCjVruISKPte42QuJyU85ImBd52L0uX13idiBToTLsb0uONueXPeKQiNERwEOefab/ArEaLvxVMQd+XCmCKnFPzlnK9oxs3n8Sl5tzr90NXVQvRkzLQC/A+AQ3oUcBxGZ5d9t+sF/m/KRiMUFqlt2XzGI0rxis98dMgzo/8D54tkOiCp65IEU9QVv/JJ6ej09BAzJnv8YVGPIzc0ebogsSZ2sj3YZm8AlIa7M6bMsR+aCU3TBd2ETqXzvAkgRuQZoCke8HPa6vnTb2dcONdo3fWE5PRV0AYs8FcwcPsDQ13+w05xx+VKgGWqg+m++/Ayw9FlADpQW1Krt/lxLOaxPVeWBWXWuCViGCeltuZBoR9tKVyCGDB+WJ2+KGS0gYQHh5STKSNwnYKehZKLXR4oid7RvUGPcoshoISLr3XrY2vm6Tpx8EprPZitsZRHA85OaNbrwJZ3pn/1OQ6GzvxDIdkudBmgN1eUUpKc1JYdEyhirRgtBLISYzWwuTY0cMpboMtcQ1jzB+nBsY1OSYCIVlM3+7H+FZWuMvxiWMwIxxI5pw9fw9mGQuHwelBOVKlULYeoOZFIztm2KG2/ZMOC9iJUINP0Y/ABob5VgGParStoKdndL8DE9VosvzxyIethpO2vfr9KzVkbAGB5+ld9RTbbxEWJa50Py+RDNye5+JxVubtkyiPSyJ24Os74TtU+x9Mj9DIb8Fm6Q1rLg56Plx6h+KnwXNftZ/VyZnETr2NxBWkAoU37I2TQLB8lI7fHQ3vraOUUBQmV4xR8lsGUUMKHVnJly2S5/jDgjrXNrSKm7T3DPLYYrBPwlbxrDGJFZ2v5q8tpkPDpFDyw1abwTiwm61cf14sm0hrqt2xuZnW1FC
 dHP12Lyg
 F8HjW91IAv2hZaX3AZuC8RtnTlYXKc2p5RfmDN6OyHAD3DqEr53ubH38QHHpl+plgzdmIDginFIOMna0LplaiZFSPb/bDQt0g5RxXJzbLeQxfbKsmI6wtf7idtnvbd/hXgC+YidNdneJgTIq5ifGjOZDDM+Uy2v2YraAJNEUOiLArFgnBkRHaFvj44gg3uecaI2Dx5U0rXVyBI7F58Inp11AlnR+mEeQDLJFrXeW2fggCi4CUEb6itwP4a2KxvcAAq8B8qHo0IfX4xC7ROdMWetgiCRwwFjwhh9M/g4hZFNxd95Tz0ym9a167tFdHNamlw25B8LtErDlLH+lKFmIYk1HUh7SlWo49svNwcCURcE/39EsX7u8aWoNNHHQ/QQtvHpQd8u98tbirw2OjAfn7oxvJMjOoF9dt6voYmfKbqgcjnzQaAY8aawUwwLYHpYYptGQMW3sIZ1OFuBCl38QV1yXkGlsLpzTSIGnhm5gQTSxurSVKOgIdgc2998+GvbD1u/uPGFT1T4p0u11q3MsqvRSvjhwkJCIGUTO56ErDKpjnl5THUv1l36Dp89AWwQ48Zat9vX/7jY+DuPtaqCwCMWrsekmP4P6AUd88SZD0oqarDFvZWSO3ggbNX8k4HhN7TojHehsuHmbnrUnogUxur8UXIq9UFVrgNfY/HFhl56DuSfENIBUuItBcSwfqnLRYmUiHU+piaMSgzAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------W0rvxkEU0Hr4p7IpwYTh3e80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/24/2025 8:19 PM, Wei Yang wrote:
> On Wed, Dec 24, 2025 at 07:51:36PM +0800, Lance Yang wrote:
>>
>>
>> On 2025/12/24 19:13, Shivank Garg wrote:
>>> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
>>> amount of work performed and consists of three components:
>>> 1. Transitioning to a new mm (+1).
> 
> Hmm... maybe not only a new mm, but also we start another scan from last mm.
> 
> Since default khugepaged_pages_to_scan is 8 PMD, it looks very possible.
> 
It makes sense, will correct this.

>>> 2. Skipping an unsuitable VMA (+1).
>>> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
>>>
>>> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
>>>
>>>       vma1       vma2   vma3
>>>      +----------+------+----------+
>>>      |2M        |1M    |2M        |
>>>      +----------+------+----------+
>>>                 ^      ^
>>>                 start  end
>>>                 ^
>>>            hstart,hend
>>>
>>> In this case, for vma2:
>>>    hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
>>>    hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment
>>>
>>> Currently, since `hend <= hstart`, VMAs that are too small or unaligned
>>> to contain a hugepage are skipped without incrementing 'progress'.
>>> A process containing a large number of such small VMAs will unfairly
>>> consume more CPU cycles before yielding compared to a process with
>>> fewer, larger, or aligned VMAs.
>>>
>>> Fix this by incrementing progress when the `hend <= hstart` condition
>>> is met.
>>>
>>> Additionally, change 'progress' type to `unsigned int` to match both
>>> the 'pages' type and the function return value.
>>>
>>> Suggested-by: Wei Yang <richard.weiyang@gmail.com>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>   mm/khugepaged.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 107146f012b1..0b549c3250f9 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>   	struct mm_slot *slot;
>>>   	struct mm_struct *mm;
>>>   	struct vm_area_struct *vma;
>>> -	int progress = 0;
>>> +	unsigned int progress = 0;
>>>   	VM_BUG_ON(!pages);
>>>   	lockdep_assert_held(&khugepaged_mm_lock);
>>> @@ -2447,7 +2447,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>   		}
>>>   		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>>>   		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>>> -		if (khugepaged_scan.address > hend) {
>>
>> Maybe add a short comment explaining why we increment progress for small VMAs
>> ;)
>>
>> Something like this:
>>
>> 		/* Count small VMAs that can't hold a hugepage towards scan limit */

I'll add explanation.

>>> +		if (khugepaged_scan.address > hend || hend <= hstart) {
>>>   			progress++;
>>>   			continue;
>>>   		}
>>
>> Otherwise, looks good to me.
>>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>
> 
> The code change LGTM.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> 

Thanks Lance and Wei. I have made suggested changes.


--------------W0rvxkEU0Hr4p7IpwYTh3e80
Content-Type: text/plain; charset=UTF-8;
 name="0002-mm-khugepaged-count-small-VMAs-towards-scan-limit.patch"
Content-Disposition: attachment;
 filename*0="0002-mm-khugepaged-count-small-VMAs-towards-scan-limit.patch"
Content-Transfer-Encoding: base64

RnJvbSBkNDY0NjA0YzA5Y2VmNzBmMGYyYWEwZjk2MDdhOTc3YjRiY2Q3MDgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+CkRhdGU6
IFdlZCwgMTcgRGVjIDIwMjUgMTk6NDM6MjYgKzAwMDAKU3ViamVjdDogW1BBVENIIFYyIDIvNV0g
bW0va2h1Z2VwYWdlZDogY291bnQgc21hbGwgVk1BcyB0b3dhcmRzIHNjYW4gbGltaXQKClRoZSBr
aHVnZXBhZ2VkX3NjYW5fbW1fc2xvdCgpIHVzZXMgYSAncHJvZ3Jlc3MnIGNvdW50ZXIgdG8gbGlt
aXQgdGhlCmFtb3VudCBvZiB3b3JrIHBlcmZvcm1lZCBhbmQgY29uc2lzdHMgb2YgdGhyZWUgY29t
cG9uZW50czoKMS4gU3RhcnRpbmcvcmVzdW1pbmcgc2NhbiBvZiBtbSBzbG90ICgrMSkuCjIuIFNr
aXBwaW5nIGFuIHVuc3VpdGFibGUgVk1BICgrMSkuCjMuIFNjYW5uaW5nIGEgUE1ELXNpemVkIHJh
bmdlICgrSFBBR0VfUE1EX05SKS4KCkNvbnNpZGVyIGEgMU1CIFZNQSBzaXR0aW5nIGJldHdlZW4g
dHdvIDJNQiBhbGlnbm1lbnQgYm91bmRhcmllczoKCiAgICAgdm1hMSAgICAgICB2bWEyICAgdm1h
MwogICAgKy0tLS0tLS0tLS0rLS0tLS0tKy0tLS0tLS0tLS0rCiAgICB8Mk0gICAgICAgIHwxTSAg
ICB8Mk0gICAgICAgIHwKICAgICstLS0tLS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tKwogICAgICAg
ICAgICAgICBeICAgICAgXgogICAgICAgICAgICAgICBzdGFydCAgZW5kCiAgICAgICAgICAgICAg
IF4KICAgICAgICAgIGhzdGFydCxoZW5kCgpJbiB0aGlzIGNhc2UsIGZvciB2bWEyOgogIGhzdGFy
dCA9IHJvdW5kX3VwKHN0YXJ0LCBIUEFHRV9QTURfU0laRSkgIC0+IE5leHQgMk1CIGFsaWdubWVu
dAogIGhlbmQgICA9IHJvdW5kX2Rvd24oZW5kLCBIUEFHRV9QTURfU0laRSkgLT4gUHJldiAyTUIg
YWxpZ25tZW50CgpDdXJyZW50bHksIHNpbmNlIGBoZW5kIDw9IGhzdGFydGAsIFZNQXMgdGhhdCBh
cmUgdG9vIHNtYWxsIG9yIHVuYWxpZ25lZAp0byBjb250YWluIGEgaHVnZXBhZ2UgYXJlIHNraXBw
ZWQgd2l0aG91dCBpbmNyZW1lbnRpbmcgJ3Byb2dyZXNzJy4KQSBwcm9jZXNzIGNvbnRhaW5pbmcg
YSBsYXJnZSBudW1iZXIgb2Ygc3VjaCBzbWFsbCBWTUFzIHdpbGwgdW5mYWlybHkKY29uc3VtZSBt
b3JlIENQVSBjeWNsZXMgYmVmb3JlIHlpZWxkaW5nIGNvbXBhcmVkIHRvIGEgcHJvY2VzcyB3aXRo
CmZld2VyLCBsYXJnZXIsIG9yIGFsaWduZWQgVk1Bcy4KCkZpeCB0aGlzIGJ5IGluY3JlbWVudGlu
ZyBwcm9ncmVzcyB3aGVuIHRoZSBgaGVuZCA8PSBoc3RhcnRgIGNvbmRpdGlvbgppcyBtZXQuCgpB
ZGRpdGlvbmFsbHksIGNoYW5nZSAncHJvZ3Jlc3MnIHRvIGB1bnNpZ25lZCBpbnRgLiBUaGlzIG1h
dGNoZXMgYm90aAp0aGUgJ3BhZ2VzJyB0eXBlIGFuZCB0aGUgZnVuY3Rpb24gcmV0dXJuIHZhbHVl
LgoKU3VnZ2VzdGVkLWJ5OiBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4KUmV2
aWV3ZWQtYnk6IFdlaSBZYW5nIDxyaWNoYXJkLndlaXlhbmdAZ21haWwuY29tPgpSZXZpZXdlZC1i
eTogTGFuY2UgWWFuZyA8bGFuY2UueWFuZ0BsaW51eC5kZXY+ClNpZ25lZC1vZmYtYnk6IFNoaXZh
bmsgR2FyZyA8c2hpdmFua2dAYW1kLmNvbT4KLS0tCiBtbS9raHVnZXBhZ2VkLmMgfCA1ICsrKy0t
CiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL21tL2todWdlcGFnZWQuYyBiL21tL2todWdlcGFnZWQuYwppbmRleCAxMDcxNDZmMDEy
YjEuLjE1NTI4MWM0OTE2OSAxMDA2NDQKLS0tIGEvbW0va2h1Z2VwYWdlZC5jCisrKyBiL21tL2to
dWdlcGFnZWQuYwpAQCAtMjQwMyw3ICsyNDAzLDcgQEAgc3RhdGljIHVuc2lnbmVkIGludCBraHVn
ZXBhZ2VkX3NjYW5fbW1fc2xvdCh1bnNpZ25lZCBpbnQgcGFnZXMsIGludCAqcmVzdWx0LAogCXN0
cnVjdCBtbV9zbG90ICpzbG90OwogCXN0cnVjdCBtbV9zdHJ1Y3QgKm1tOwogCXN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqdm1hOwotCWludCBwcm9ncmVzcyA9IDA7CisJdW5zaWduZWQgaW50IHByb2dy
ZXNzID0gMDsKIAogCVZNX0JVR19PTighcGFnZXMpOwogCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmto
dWdlcGFnZWRfbW1fbG9jayk7CkBAIC0yNDQ3LDcgKzI0NDcsOCBAQCBzdGF0aWMgdW5zaWduZWQg
aW50IGtodWdlcGFnZWRfc2Nhbl9tbV9zbG90KHVuc2lnbmVkIGludCBwYWdlcywgaW50ICpyZXN1
bHQsCiAJCX0KIAkJaHN0YXJ0ID0gcm91bmRfdXAodm1hLT52bV9zdGFydCwgSFBBR0VfUE1EX1NJ
WkUpOwogCQloZW5kID0gcm91bmRfZG93bih2bWEtPnZtX2VuZCwgSFBBR0VfUE1EX1NJWkUpOwot
CQlpZiAoa2h1Z2VwYWdlZF9zY2FuLmFkZHJlc3MgPiBoZW5kKSB7CisJCWlmIChraHVnZXBhZ2Vk
X3NjYW4uYWRkcmVzcyA+IGhlbmQgfHwgaGVuZCA8PSBoc3RhcnQpIHsKKwkJCS8qIFZNQSBhbHJl
YWR5IHNjYW5uZWQgb3IgdG9vIHNtYWxsL3VuYWxpZ25lZCBmb3IgaHVnZXBhZ2UuICovCiAJCQlw
cm9ncmVzcysrOwogCQkJY29udGludWU7CiAJCX0KLS0gCjIuNDMuMAoK

--------------W0rvxkEU0Hr4p7IpwYTh3e80--

