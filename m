Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37109C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F806B00A1; Mon, 21 Sep 2026 03:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0196B00CB; Mon, 21 Sep 2026 03:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CECA6B00D9; Mon, 21 Sep 2026 03:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9BC76B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:34:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BFDB1605E7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:34:01 +0000 (UTC)
X-FDA: 85236955482.03.B7ABE1E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013013.outbound.protection.outlook.com [40.93.196.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C86B40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:33:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DrkLF1WX;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.196.13 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789976038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zV+QACpXjEvm6RJAXFhj4Occ7Mw1vd18DFNj5epZ9qo=;
	b=hMORIFnmiLC/xPRkxiCZ7ZqHie76ADGbcwqfWg6+7UZyJoTnncvmoUhUQECrA+aVMQooOM
	duQBWKOEpyUOLjPVK10VXJzL3oHO1pp621zEfXOop5qNbSz9NzQxQYWiawXW2NnlbIJntl
	SD7JTomml/tKEpLlNSqom/YkqItoE6E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789976038;
	b=hniHf/yPCeh5Sm492qtGIy2EY5T7GyD7eKQBbPBOsE0KEzeUcmP+NNDd07Waep9CxX6dRG
	p/TKXRYEprTD/nLPspq6m9gJ02pGF+l3Fu0ba1Db2IyuPUwHQD+/leuXiCETN2ijkyTJ6M
	gL6CqqHvGVWLDb9Ax4mbrww7Sw53rac=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=DrkLF1WX;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.196.13 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=amfFQuqlJoK8y0AQB2DT6VJhXz210dymOf0TCdgbHdBkGYBSN59S7h8TnFqdRUs5bbYpvHI36z9YRHY3SgfU6U8N1sKMJktwR0tXqh0L6iqBzyJDG/MR9LViOYhz0UumFnjU1b0qIBiIaOWndfbA/+iLS1x/d5VAwUzVfZ4cjsQNNoAX99Y/UuVuVAPy/py+ZRZ5rGf0GuToDFS3BqBf8v+xZDvswp3RY3SYnIpQKaBndN0xwh1zR5tZw+2zV99wHl4fHO5p/O7qaaYu3alI09dfIeDvNc1+Qe52CgPuY7gIIJGWs/9lUTslySeKy4vYDAycbKaY14RVVFuad1zftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zV+QACpXjEvm6RJAXFhj4Occ7Mw1vd18DFNj5epZ9qo=;
 b=srU3wPQYFOHYhufvc/6eMpNguoeTFNTYle1jviTb/Av9PWKLM5Aqi/fWNJ2XiFp93IULebxdPo7diG2dzrSd7HHnRUaMAwjUgwWCGcZWQdqw1ClzgvwupvYqSPJSch758mYCrsyfsau06co0S9Kmkld1wMmSwBA/lr4IXoKmjMVg1G8snU3BwlotjtfwdSYfNBaIBD6RVfQokT/+gtUdqZV34yHC2kaCfPcoZausKm7lGbp/iDYwzm8fZy34fPGSmJmqDeO//RStvSnWV3HpccAz1r7ange8M9bc7G3wpoWH5XQ+5ZVF/bqFRYcKRI/L8Mx+NAqsa/ugKe4uKFw1WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zV+QACpXjEvm6RJAXFhj4Occ7Mw1vd18DFNj5epZ9qo=;
 b=DrkLF1WXHXzC7ro39kLxXLNIiGDjR4oFOkDJDzFta9D6FDFS3aHwbbbWW1f/lyMXw41ye7UVdYkaTqU33iKlP5NOqD908t11hmzHuPaL4B/RbkZvSe84SAJaJbbekfI8agDLKoZvBfluC1OCuwFcNSsv4tLR9R/p/O+HAdMdqCk=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 IA0PPF6483BC7EA.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bcf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 07:33:53 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 07:33:53 +0000
Message-ID: <ca48b82c-75a7-47db-b259-86b44e9bd789@amd.com>
Date: Mon, 21 Sep 2026 09:33:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean
 pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-3-songmuchun@bytedance.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260903122128.12264-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017F.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::4f) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|IA0PPF6483BC7EA:EE_
X-MS-Office365-Filtering-Correlation-Id: f1e08333-452f-4982-d05e-08df17b2af7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	AF7sQBDlGlRdnxoczmg77YG0CjiW6gnQvZpRWeLGewv0BUVHZsbjcXS8O+A5jKlNTy0BMfLpFKA4mwsyoPDDtip7C8UKvOted2ZBRVWi1YaFsoAMTDxNCjtIs5yETErz6f10hPJIiH8bNNJao3Us8tyGJj4IYs8L++8cyriawm+FX0XY+eOGxoM6xGeCD2LLKdq2eLvRsCPGkuNS9AwF42TXxMiQ/WbhZVP2Lt49zpYOIK1fH45Dm7ggBBqrYzmMTuctd514tSm5Yq3QjAETB0qOC9+nUsaTHfD8vWjyNrdfOQt2JWVMP5gLOT5YEVDpHa/PSi1ZwPO/GqZqYuTxClBIHBhs1Oa1ahRTZxA7m9/VnDBbMtl3i1zh1S8qG74eD/FzOzIPRDUA+44cgQe7sRtUxvfPfrqdq7OZKmdfU5Elj3fc3GbdfPf1VtVv6RUdVB4tNTeBSnv/HSruzA4oVctXlJnSSpvinR1e5z1dFX2ip1FbalCygvmwP+fX1J5OOXIN7/EN+kUFs9dUZnAI8tNc98AazND6PrOTGFNMNkqEXlRjkaKhMZXov5WMpFtVVpOO0MGzXYEsnUbVNd3prK0FePM8ymv8o84g2o95Ny7k/335IncmckV2JVH5mRmGWINgxUsqhl3cuSYCcm+/wDX4g1Nd1jsFa/utZV89mmU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTVaaUJNeDdlN01odGIxWU9tdzBKYk43SWZzUkkzQXVNWFJYOGdBeHh4VXlH?=
 =?utf-8?B?STdWQ1A2bFI4bzhUby9TbXB5N3cwdUJHU0I0SzRsODRMMzdCTlVVL09xNnJ2?=
 =?utf-8?B?eFgzWUx5RVFHU3ZLekdmUDZjY3ZMbXYwWkJCZW9JMTdBK1FQYWVnMWR5K2xV?=
 =?utf-8?B?bkMxSFFlMzAzVVVHZ3Jzb1dQM3pXMTloT1VEdCtEeWp1c01nbkdYOGlYVEd5?=
 =?utf-8?B?LzRFbytKSkV2OW54M1NjUkVmZ2NidjFKZWFtd29XNUhFaTQ5eGxUQm4xSGhq?=
 =?utf-8?B?Q3VDOS9YTEZLL2xFUCthS3pidUxuL3M4bW10ZjZvY05XZGkwTDJEeEFnK3Rz?=
 =?utf-8?B?Ymh1MmZxM1A1TVFtRHRwYkdaYXpnT2xDdjFYV2FRb0tRUkhXeEZFalhlbHdo?=
 =?utf-8?B?OXF5OStEMzVIK01VVEI4bjF4Z2J2VGk5dWs3cWdDQWg3SmhDT1g2SHpiamxP?=
 =?utf-8?B?UXlGYVJPOHlsYTZtd2VyVWNlTmx3RE5ubEplUUt1MVJ6a0hOemhYdFozdGhG?=
 =?utf-8?B?YjRUbUFyeHI3NDVqNC9XbGlrSG9Ud25wYkVPa0FJYjNyendUUFlZb1o4dmFT?=
 =?utf-8?B?UUZ0V1VKaHNNQnBtWFZzVzNZM09LT0M1Ri9adGZKdXMyQ1EzUVBVN0RYZGNS?=
 =?utf-8?B?dHFKTkZBMk1XY3hCeGVMTnlja21FdFJmMHYyaFZpVXhncXgrY2NnNnFNdVNL?=
 =?utf-8?B?TkJtMmJ3QzZ0UngvdERZT2JQaWtobEVnb3VZaHAzQ3o0K2dDZDlUNCswQnZv?=
 =?utf-8?B?TGl5TTdGRUp6WE9NczVkSVlWZXRMYlVDRWZTRG52RVNJdVJGVXZid3RLaklp?=
 =?utf-8?B?bE9EWUJTK1N4d2FDdW5Ia1g1T0Fzd3FZQndxZnlUSGpLNVBhbkhXTjZya2xq?=
 =?utf-8?B?MEhROEJvYjgwdDZwMVhjM29NRnM4Y0t1SzI0R0R0Y2JGd2NDWWFYbUU5VWdY?=
 =?utf-8?B?WWxHTkRnYzUwWGtKY0YvcVNSVHRIN2QyQzBjTkRvaXZ5UEZvOWRhRHl4WTZr?=
 =?utf-8?B?UWZLT3VkbERPanMzZUt6SWV0Tjk2c3oyL0ZqRFllaGFzYXBjcUJPZjA0dTd6?=
 =?utf-8?B?V0szWGFoVGhNQmdwYlpBREMwZTR4QnF4QmtoL0pIdUhYaFJkcUMyVi8rSGM3?=
 =?utf-8?B?MFRjdWR6V3R5SGgwTXptbFRNM3BwYlh3YmwyYUt5VGMrQlVYbWdJUHllbHpj?=
 =?utf-8?B?YkU3aUw2S1BXVlJvV2lVbWYydm1wUUYzc2FYdUI5bWVQQWJZYVJNSjNBQTBv?=
 =?utf-8?B?SkJqZmpaVEVBcWxwaFovVm1FdnZ1eXp5Z3hpV2pEenVhdTIvV1RJdkZoQkVs?=
 =?utf-8?B?ZXdnY0Q0djIxKzhTY28zM2pWaC9tajNmNUJ2WDBFN01uaHByQ2VRd1IvWS9h?=
 =?utf-8?B?a0ZqbmxlcmgrRlBYVW9lS0p4WjlEQ2d3bFQwNkwzNFdkMHVkNTJaMGMrWFU4?=
 =?utf-8?B?TmZiTDZuNlZHc2tiKzVUVmRsaGpubTdLcHJjZjBxRTlJSFBKbG1TUVY3Skhl?=
 =?utf-8?B?VW5sQkI5UHlVTE10NFErdVlMQ1ptU2xNVVRaOGEwSWlLTEh0OVg0ajkrOEh3?=
 =?utf-8?B?OXQ2eW0rZmFaS05ZZXMyakNmTWdvd3RldForYXBpUGl6MVhBZERrVCt5NHhu?=
 =?utf-8?B?d3RJY3JOQno5aFhZaGM4VC93NitzVEtVdkJlQXZCU3Z5a1VXSUZMNmRJSEFM?=
 =?utf-8?B?c01BdlNpUHNuMUNFdmpTR3kxYUt0R2drb2Q1ZDVlMWM0TmpiUUVsMHQ1Qytp?=
 =?utf-8?B?WmhKeXF4UjhtRVZrYlU5c2tBaERkcXVjY2RqMCszYVR6OGg0MGVzZ3k5SlFn?=
 =?utf-8?B?ZzU0d3R2c3Q2YWRHWWRrN1UycEQzWWZlOWFiZEU2N3FQbFBQckRPTXJzbERn?=
 =?utf-8?B?TDNXQ2dWdnVYRkFLNy9PVk96cjJCOWJONi9pb2pxSW1wTytQa1VBSkE1dDUz?=
 =?utf-8?B?N0RhanhBNm9BeUpLZThhRUtzMmtHQ1JtNkdHNnVwTXRzcDFKZzMycEJKYVFt?=
 =?utf-8?B?VTUvNS9pR2s1STF5NElCSG5pK3ZUSm95Vjl3RUF0UnVMUVY1czJ5QUphM2xx?=
 =?utf-8?B?NGl1MWR3Y3BFYzQvR3V4U3NVYmNONFlZVnJSMEdlWUJWV2dYWnJtQk42amcz?=
 =?utf-8?B?bzlpRE1kSXRsYnBVb3lvNWpidUtraUhjRzBrMUExeVlkem5BYm5vK0tIbG16?=
 =?utf-8?B?UHNTcS9vV255dWFCbWYveHdqdHhrYS9Jdi9KWUNKcHJuelA5ZXFWTnROM1hD?=
 =?utf-8?B?b1hvYVpybWJiT1V6NnB2RnNSRHUrcUlKMzhWUVVJR2MwZjJKTlJWTVpwTkhW?=
 =?utf-8?B?bm15dWJNWU0wVXdPS2lkT1BxQURvTmdpVDhnanYybkJtYXNGMDIrQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e08333-452f-4982-d05e-08df17b2af7f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 07:33:52.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IsJSYDfu3pZ694+mDP4olYgJiey30YsZI5JN/zPmOquZ/gG2zHpE+PIal1UtmhMWcbqtIQRApsnzFTsJpC3Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF6483BC7EA
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C86B40004
X-Stat-Signature: qgeiwtpcad43fwm8mozdwq6uron69i8k
X-HE-Tag: 1789976038-160862
X-HE-Meta: U2FsdGVkX19imaiYfd9yjjaFDHKNmMoXaJfZsTs9DRxmzrkvOXUq/S1B521xFmrUaSOMlALXnmR2tWiHLMpyc5AVOjEtVI4O0p2TtjH0zCqYWUtxDvVfntrKum9ZVLc/tZ36t/cG1yx8pyAyAZIjRmUUdhem1o3+DeLA8re53qKYVpaHkdT5JIfdK40+6aLX5B4mVcjpCj80qAp170UKqYg5Vfbh5ndDcJSLYCNL5qFi2da68lAhrN3NEfkeTxBc61zSGzxlgOJszoHLaMj54hSXKNTuOk/yY7ggwCEF3PrOuelhJkt5JLcA9YWyru8Z3toh3X3UVxYsbOSV6V82NTLMZGjaU0jIHvWWnnIuNLr+w94bcji/FTqnE5tyuOf7O+iza6XFOtPb2aRcQLlIqC+dJJDYCkXepQpmsiRzca6tmosN+4x9ALzXIlTM8RlYiGREerXH1UD5/rO6OBBJz/FnJidBYBr4VYBTzglWrf8qSZewzzLVS4AgDSdNdi4qmIsKJGkzTslQq3aHFmGunUI8nb+PxV0nzdb3igH9JTbG5MlNu1kHACeo16kU9I4U/TFaEbl/nVll1+zvcMQW3ByIGDqYvJFrfUVh2kkz1zO1Pgo/oYVYuVS8vshipcGvIKnJKuCkD2BtmId2nHkS8UWQMpHDw2LdUiLkd+02lvTe+8A4LjE72vGN3a2syz6LVMRYZWhRkUJEBlJRddcXKuvutMNUijdrLzazWio/fHbE+NFijq4oIEqX1S8p1tFXGVcchnnfbvMfR7RlQUnadgVA+UZ8CAQzCKMWIItJ+jEM17dfA5TRh3fO8yOCwEz6+cxd/bWnMgbqiAezY4YYioJWGO3I4kVLF2q5ME9yO2QZ+aFaVaZkHAOYY9Du8l1FCZ34YAzQhxoMwpcV/6wHPAj6eVwXXLZ4FJyZSz27ftVVblWmGYrJo864tMMGyRUrD0Z1PjZ0mBh2x2eml0o
 E/+mmQvO
 Ps2sEgUJA29lBhFCqBa7XjOKUi6lGTZafW8kE3Bo+2rn8p37FTMTvvB9KiAaW121mMD/ocrUPdg8+5Cf5EneuHXo029mKyb6vDG9w3AyGgFCcBXGsJRPDmf5uXQVp77HydWgd471q9M31Sncgu6z9xelgZzC2GQ6M3L6HEZC5Fji2uUtHkiMuf2iLERnv+LcZjZz1MNBU1Z4cjeYzmRiAKpV9qhemDZjzZSBqGMAxQG1Zw2jcLfli0uKosM8iyFS8Sq5iPU/T5LXiP36VfFF7yK/qhyeXxFOWWwo9WfI7y2kb9WzVADcoM8LSDny8Yhyr1pUoOL/OmMuMfJ6/bOs78sPPf3JXXtqfZk/t42/8BDuXrH2VyLeCPq5Qmvo5V/xt75Ez0/zrS6TrgX8Dn8Dxppo6GH9K4Yx023aEs2KqFQ3yWujPeRYGxtNP7tBSNxLSU2No8OGJRzLOhvBAPVrqkOpv+hUh+o5KN9Q2IJk2LytLPGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> pmem_mkpage_present() is called after persistent-memory poison has been
> cleared. It only needs to clear PG_hwpoison and undo the MCE nospec state
> for PFNs that are still marked poisoned.
>
> For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, but it
> still performs an atomic clear operation against struct page flags. That is
> unnecessary today and conflicts with the FS-DAX vmemmap optimization added
> later in the series, where clean PFNs may be backed by shared read-only
> metadata.
>
> Check PageHWPoison() first so only poisoned PFNs update the page state.
> Poison recovery keeps the same behavior, while clean PFNs no longer require
> writable per-PFN metadata.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   drivers/nvdimm/pmem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..b14f75daeda7 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>   		 * here since we're in the driver I/O path and
>   		 * outstanding I/O requests pin the dev_pagemap.
>   		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (PageHWPoison(page) && test_and_clear_pmem_poison(page))
>   			clear_mce_nospec(pfn);
>   	}
>   }

