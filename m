Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48ABCD4847
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 21:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3CCF8E0009; Wed, 12 Nov 2025 16:19:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC44D8E0006; Wed, 12 Nov 2025 16:19:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64498E0009; Wed, 12 Nov 2025 16:19:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF5808E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:19:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6123E140387
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:19:57 +0000 (UTC)
X-FDA: 84103222434.24.04A71E9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010022.outbound.protection.outlook.com [52.101.201.22])
	by imf12.hostedemail.com (Postfix) with ESMTP id 413924000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:19:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oCrvEDPL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.201.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762982394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCfeALJXTqxQptKoyZhgfk+Z6pf353N6RO+2EOgw7Hk=;
	b=JvZ9dSwzHzflDHDLIjU83SM86Jv/Nd0Vo8U7Rw6iUZDvknWlXQEaVotXe5nK81AjsH7M0/
	P7Mpn60/LxGDtKi2QT1odXbvJInM00+MWEorXaFs7GiydNk5bmxEW/XsruT0BwJO4m3ULx
	vzXjW8hxoUZxPk7JiFeDbTrh5CUxEMc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oCrvEDPL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.201.22 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762982394; a=rsa-sha256;
	cv=pass;
	b=CkJuI0lzfbVDyn459sDJv4r0G90YbATE+OA0jyX3SBIlnFuasYYD2h+XTHFc9VhO2a3Tr1
	zElsab2EHJi5jh+2wDxkcsrOh3TdOYqS42jp/MeAyG91YdBoqHAzlj6GtdjI/0cb9bXF8B
	jReMsX+dxEAlmq06kBAarhWo2JxBgbg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zjehgwz3fzC7JaDOIgXlM89e5gNveCZasDPZ7GeRxl1p6fMPDLwJy8mKhgI+Ppa+V9VeZXBDg8YKt067km+PaQ5gfCpjQF2NeNmcvCrAC/684GFiElKFTCnE033uhUUkonuQ0fuCVKSKo8tfXFQmumR3DR5klZCYi+XUaKHg8syJdkBCnZCjYOjzQbl2Bc/Dbm9trpem9qjjdvPxi0IYRSxtpWQJuyubf09RYqWfAP2K7vN+MliEOF83NVkWWhjjv0X9Ue4di31xUGwVQ6DhycZ6Y4J2UdBuFw5DoMUlVHk3Xyh2R3UrGxgipXLkrvNGFOaJ+dJjeSyKTd8qtY3vgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCfeALJXTqxQptKoyZhgfk+Z6pf353N6RO+2EOgw7Hk=;
 b=oke/DnEAKsJkJBYV7Oyig7zzy7R3uCoZFP6iNsOceWfJ1DX8Q2qqkG+F/a4esK0twAiwlG5JIiuxdFEN2rFqbZLANQsukquDV5C5EpbAkWu12seBYKKB/goA/3/8QFDbpjUwR6BKbr3h3DxNy/ZhQy7ewmYrG5Hg9dSGfPnw8B1rtrHfFEVn7CLN2EPD1ADDBP2uQdf/lJuNLg7XxuBKqbZMw6eknfBNJg0tQycVjRHSlM02FE4aXLSqZLsOZ8XBovN8VY6WvSLHRWaSVs486BF5sGzqzPfE/qeCGAwaJ8cYMyBWSHoI98yvuM3HCRbDgITNs5LTkFKi80l6BDBWBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCfeALJXTqxQptKoyZhgfk+Z6pf353N6RO+2EOgw7Hk=;
 b=oCrvEDPLWTH46UP35bL9DiYLuZDg20RyQIM7UdxBFdbenkX5g17JV+LUmVhpdhPVHGrhFFwUXNXAqHURJid8gWm/fIfu4t+fMK8u+P8X2/+h9aWPU08qbVWRXRxKRTVyKNnwlge4AkuivummPlkKKKYax1NIrs/vICco0kutYojEH/w+oF4pyZ9MXqsjPy8I439n9NTMvsOLcb6OtbTggQomcMCIneV8Fli+fD+p5nQsZIf2J2CMzSgEjwlphOWlBLNoqOqL6CzFd9226qZzweQy9hcd7yQyqnRIxR9ZyMDZNoScmSnUbX2y3FruIwAt+2VgqDuiTiX9g0+SEjpaDg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB8066.namprd12.prod.outlook.com (2603:10b6:930:70::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 21:19:50 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 21:19:50 +0000
Message-ID: <4366d847-20b0-4828-8f40-203fed98401d@nvidia.com>
Date: Thu, 13 Nov 2025 08:19:47 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master 6752/7613]
 drivers/gpu/drm/nouveau/nouveau_dmem.c:259:13: sparse: sparse: incorrect type
 in assignment (different base types)
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202511121922.oP20Lzb8-lkp@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <202511121922.oP20Lzb8-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::48) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB8066:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f3c210e-6e4a-4fb8-dcdb-08de223136d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWxkc0JNYVNjUTUzSjFFOWgyNjR2S043OHg1eWpVNnZ6QzJRMi9YWjljTlpv?=
 =?utf-8?B?Z29LQWNiWlJTMzlJZlNyR1ZkUnN2a1dzYjRKbTZhb0JDdnF2bnd0U0txdVhG?=
 =?utf-8?B?SGhDZExRZjEwMHBuUGFkYXBZTmF3S3BSQ3IwV3RXRzFKMStSbThMMGRnY0hm?=
 =?utf-8?B?SytkOGlmTXdMaU56L3kyZnpkakM4dUczbnJuUE85R1hFWTJDY2E2ZkpRQ0xn?=
 =?utf-8?B?U0pGemczeWUvV3JTTi9yeEhGemJyS1g0NStXbVEyU0pKcTZNcnRaaGJyd0ky?=
 =?utf-8?B?VlFiQTB4ME1MWXRsRzdTVG1pRU50MVU0QW03ejY0WGYyYlVPbzFwWjNCdlha?=
 =?utf-8?B?OHE1ckVGM0xiYzVXb2YwS2h4N2RzRmdMNi8zVFRlY1Z0VitSbHg3WXBoVWdw?=
 =?utf-8?B?OFFiVUFhVTZJK0tWYkZPWjdyU3dsb0dabmZQL0k3Wm8vNzNSQ2NRcTZiU29H?=
 =?utf-8?B?bDdyc1dZWUg5elNqQ0R3bW1pM0xtVHpaemFpazRqSEhMTzNTR2RaaWxPT0lk?=
 =?utf-8?B?UjRUb2kzeHVrMjZneUJTZmN5ZDlNUGR2VW8zdzlaeHlOTXlYMGQ0YzVMd0Ev?=
 =?utf-8?B?dDRFL0hXbmQwOVBubExtV2ZNNEpQaWVtRU5QelpRQXFlS2NoVW9pWDRDb2ZE?=
 =?utf-8?B?L1ovSS9vWmllWi84YmVoL1M3amRDWkNuSS9POXRTVHlQM1hMbnNpUkNJblRv?=
 =?utf-8?B?Wm5DOUxtd1BXL2xIdS9nai8zbDdlYjJWQUNnQkJRcldIS0ZpMUdVT2JEOVFT?=
 =?utf-8?B?ZEZiWmhaQUVnem5SVitwclpXbzNIMjloVDhjTnd5d1BSdW1LMHZVQ2tDYVUr?=
 =?utf-8?B?UTY5WUVVYWdjeUxIZE1NY3BMdHpKTjd6N1BpcVpCS3pnd1gxcVp1UjY5T1Rj?=
 =?utf-8?B?c2ZVVWhGYUdLMXM4VnJleUZ6c3YvUVJ1dllQU1A4N2V6cFd4WjkxQzF3cExQ?=
 =?utf-8?B?OXZLZDl5akNLU3pFc3UxYkNTQzFFaFJzSDN6OFdmY29iR0gxTFdHc1ZtdHA0?=
 =?utf-8?B?Y2MwelNZQXE4MUdjQldnR3J1YVRhR1BwK3ZSdE4wTVpJNjlZdC9CeUxFTXBi?=
 =?utf-8?B?MzZwRWo2K2RvZTcrTHVBbVhlMC9BbjRsR3NLN24zZkJURnloNHZ2R0EvTGY5?=
 =?utf-8?B?WHI1UDVXZVRTRWpKTzNOSXJMZWV2KzdNVDJGSk0zRXVhcmlQV0VxL1BHVlNU?=
 =?utf-8?B?cjdodm4vL3VpOHNtMzRpdlpibGhMTlJUajFIa1RZNHlCRXl2bkFHell0NCsv?=
 =?utf-8?B?UFVZdlJlQWtYeWZER0dQT1M1d3VveGZNZ0RScFByZXdtbDhDeFhtcXR1MU5V?=
 =?utf-8?B?dDZqU0NLSVJQblRnUFRGcm91cEduSEVwaXBBT24xQUxUSE42UEJ0Qis3K0Nt?=
 =?utf-8?B?emFkbXZvU3NMTGZIUi9GMDdHZVZ0OEFnTllZNHk0OXNGMEVSVXZGU1Z4TnJ6?=
 =?utf-8?B?K3pxbUJEZGVEdVl3WmlVbmF6cmVESFBJU3czVTFLTWpCR1QzSFpORHZRUmNu?=
 =?utf-8?B?SGFIOGRIMWh3dWh5ZzVBZXFJa1hmNi92aEV5Z3NsdXQwQzFDaytVUEFKeThK?=
 =?utf-8?B?V3plNmdhY3M0K2tDRENWeGNmZjNxdC9DYjk1dXBDYnYxZlFUR3JEeFoycjNS?=
 =?utf-8?B?SlpuMmpvNUtXSDI4eWMyVmwyWXhRblppTHoyYWQ0NDFxUVlyMGN1RHFzWURY?=
 =?utf-8?B?VlptSXlSZWZvVFo4MlA2WThhK21zdnlLdmlVajl2aXdIbXh6MmdUS3grb2V0?=
 =?utf-8?B?Q1RwdzJVbkVwL2QvdVZ6amFpdWZPSEJtekJOUEUrVVM5UXYwWnVUcGZMZklN?=
 =?utf-8?B?QVBGdTZ5N2RqU2dhd3NWQnpucklDT1lIZGR3N1c1bmhUVWY3dTNJS254c2Vs?=
 =?utf-8?B?MlRZTldEOVY4VDNKbTlTU2FRL0NaU01abEZCcjA5VVR4LzRuSFFKS0xzYWxC?=
 =?utf-8?B?UHJEN0NHM1ppNG1CUTVyL3cxOFJnRWRjUnFPNXhTNWZPbzcrT1dTM2Q3RlJ5?=
 =?utf-8?B?ZTI5N1Z2bTlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTAzSjBBUGNLNnZINmtXdFJtTkhpQ2hUKy9EaHphcytXcEZuYmc5S0Y2WS9D?=
 =?utf-8?B?SmJvUDJuMWc4KzNFNDZ6ZUc2MmdDQVdOZTZRNmpveGRYaFF5S3VsOUhPOC9i?=
 =?utf-8?B?L0ZCOHQ0K0RkZTNCTzZPYUwvelFMcjg0K1BDRXVTRXpZNU1wVnZlRlFpV1FX?=
 =?utf-8?B?SUlOb3laeEIwL2tBcUZmSjlmMHNYMnZyR0J1S0NMWTlSSzFLbWdGSmtiQ2dL?=
 =?utf-8?B?T0hOcndMT2FORDkvVXJHQnJTTjVQazdOZW1wZEF3cVpHMWgxbmdUSnBVRnFu?=
 =?utf-8?B?U1hwenRmdzJxWUZFWWc5L3dXOXpyYkFpQ0k2bU04SUNGRlpNWFFlOXhUYzJU?=
 =?utf-8?B?VVhWblpja2FQUVkramVseFlVM0c0S1MxZVB0cENpUWlpcDg5RmMwSWdpRTBK?=
 =?utf-8?B?OXNLSFVxTTZtT0FIVzFsKzFLSDBZMCt0K1VUcFpXcTdxdHNuUExvcHA2dHJW?=
 =?utf-8?B?TDQ4THNFTG52eXNrNGhBVk5DMFJIZ05TclQ1QW5PMDF3VnNDWE9vMERqRmpy?=
 =?utf-8?B?RlBEamdrMDluZHMwQ014UEUvL2x3ODlLbGpHYzBVMnNJM3kxMGRTNGNqdlFT?=
 =?utf-8?B?UHYzQmN4aUY0WWxmejY4TVZxcm1VWEtVVjl6UGhLOUkwNFRnNzFNTWNhaE8v?=
 =?utf-8?B?NUhidDBLZHp1UVM1dnJUVEdOZUQ1SnJXOHdSMVQxZXZldGgvVnhNOWloNHU2?=
 =?utf-8?B?VW5nRjJTdVRPb3JnMGZYVk9MNWRLb29xVEZPTnZaL2F1NU11V2NvSTd6MldS?=
 =?utf-8?B?VHMxMnY3UmU4SlhUcklIYVY1ZmZOTzR2c0NpcUJDRHZPZzBWNHpjbnYzMVBi?=
 =?utf-8?B?OU9mUS9DMlFEZnJ0b1hFM3pIMURkbS9qUGFSek1GS2NsNjlWVWo2cEtXbG92?=
 =?utf-8?B?R05LTThLM1dKcG1zVEdmWDBvU0x4a1pXMUU2dlZsaUVJYWlzOEkyTHl4YkpP?=
 =?utf-8?B?QTBoK1Q0YVBLeTV2ZHE0TnhNZ242Qmc0cUhKUVBKRTM1bjJzRjBlVUIxcGhl?=
 =?utf-8?B?cHdiT1N3U3R3QTVVQ2xJbzdZbnBDbGpFUElPUm1ka3ZOVDRXdDNzK3AwdGU5?=
 =?utf-8?B?UmhoQUx2ejJEMEdsNk45N09PWG1KM0JmWXMwZW5veFJSYXNhNS90RXBDcUs0?=
 =?utf-8?B?ZDlIdUkveWE1S0ZXeGx0b1Fzclpsa2J4SEF5L2NGZCtIS1BGRUY5ZmVOK0Vq?=
 =?utf-8?B?anJrMGJsTkZQTVF6Y1ZMN0M4QlE0Sk1rVXk5V0kzWmRLTEd5L0k3UFhYYk9N?=
 =?utf-8?B?RldLc2JlWjU0bXlEekx1cDJlY29WdHhpTHpnWWVXS0U4cjk2dHZyazlVRk5h?=
 =?utf-8?B?WEpIamRqUlBvWjNvM1h3N3VsQVFJRTBmUE9kVUNhSHp0S0c5cmp5ejVGZUVB?=
 =?utf-8?B?akVWWVBBRWI5OTQ1dithaW9QaHc1dE1BdjJ3ZEIxbUJjOXBQZjh0eDZiTEo4?=
 =?utf-8?B?bUpUUnJBdlJ5cHRneXZOT2gzZG81Q2FtTk5QUzBudFNWYUhRQUZ2bm9kS0V0?=
 =?utf-8?B?KzgrazJoeFE1RGxiVk9iRFRrYUdISkluVklHUlRIZnFzMS92eHFycWwrYm5l?=
 =?utf-8?B?T01xZjdpY0IwTmhIUy9leEpwdU1iNC93UXFxZGJ6bGU2UlJ5VVEvRTRHQzNX?=
 =?utf-8?B?Z09Vd2hMRUZna1h6VDJsSDIvTWttNEJsNjl3UHhmY1VURzRtSlNxelBWeW5G?=
 =?utf-8?B?aGMyOGgyalY3a1RHZVhsTGVkMFd4RC9DMWJNT3EyeGo0bS9pOXFseHdBUzl6?=
 =?utf-8?B?ajgyQmZSVFl3ajcrZThmTlFUM1hiekFIYmREdVlPT1UzZmFZWTRGam1TdENr?=
 =?utf-8?B?L2VoUGRSTHZsTnpIUmphZEp6VS85WWdzeGZoVmozUEJ0MWtLbFlmMTRYRzBC?=
 =?utf-8?B?Z1lKc1ZxS1hvUzZCUWppejBFVjlocTRrNkRwQmxHdmlERWpJTHQ2QTlXeElu?=
 =?utf-8?B?OVRDS2hzQkxPczFWdmJJOCtDMS92ZVUySkxwanVNMDBwZFJBd3ZqWWpyaEZH?=
 =?utf-8?B?N3l2djJ1ODB2NlFUSmlhdk1PV0ZQdk84QW10ZlpDblRzWFlyTGw3ZVV0bjhp?=
 =?utf-8?B?Zm9MNllmdHY0Ylk1eE53R1JtdkhDeVVLWHBEblFoOGhvNWNGczg3N3AwUVc2?=
 =?utf-8?B?SVRPZm1VQVRrTTV5emVwTm8yejhIMGFqOUFjd0FsWWVPcFN0VzBENGhadWFy?=
 =?utf-8?Q?/aaZLy+pjg96w5JhZeF4RJdXny2qXXeMNJ1BnZOg3xDt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3c210e-6e4a-4fb8-dcdb-08de223136d0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 21:19:50.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efo575X4YZxJhFCGNbrJRWWdSqGI7WaESW/4NTut58scvd4JRUw5ShnsTv5eeHfcmGfjAd7Vkk79MGi3Eckv5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8066
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 413924000F
X-Stat-Signature: fuyaezwurhwmjjwyp9r6bygpewfhksw5
X-Rspam-User: 
X-HE-Tag: 1762982394-271325
X-HE-Meta: U2FsdGVkX19A/gi0A1IoyLeGKY0EDLsgVvM2qfpOXVmURmoDEuKTqNjcn0FBZ58xI23NxCey72NS+82Ny/z8LFaNzfBu0y1CULtwQSspLrj/K8ZLgOachB8pcy3FYfWKTb11wMAWY/othEVF0dm5VnUyfqPeyQG5JjDb662lcoWllsF/4Lnw0y6/CoJCBBaSjMhJ0hhUvmPXtAhHOBMrZaiQnKEU0NmXfWA26k+wOe9uh2W3MVVLiUT1OW53nxlvLCNqQD7/O5pdIaXsZ2K5HghOkkTu/Q5bwu4P5NacOKr47EK1lc3r75dHdAa+hJUZqAUg5m453dkfBZg6FgsqMvRVIbdUnEdRNRedX3LDxyvIonxTQH4Bfyw3QUrM4bp0GdOLtKMtK3MAZK2zK8780l7jcOGozD2kG7567AwxmWbgT4qepwlEJEeRBkbZ4bm3AXZBElNPPTDzcuO2dPo6BwNWc0vZIZFeChESYFUQ267ejU1UoV1LfQaiw2eOUBpOATjd8Cl+u9uehcCh+Ld53DTejrOr5++zkXycuYckNAdUSxP9Nh6bE84S+Aw64vK31o3qlTG+ZLArR6DimqNbvqqizbSkVsX740NL8xT7kADe2NQ56ppZWD8nsFVyqQy673fGZTNiiFTtsgDgi+qZCJ9VgMDc8eS8cdExKYxH5DWPKp5Y5FLXQWT9j1S+BDWdu11ieMHvUz9i+uDi44trY/FEQdzyeLxa4CkJJqozh63y34TtHci4wvbOlq7JFDFulDeBh3UPpkKwRwLvFDvzYvmZ3oZrVv44K6EpmXYJRX88h9ey+X8BKQxu0caIbDkKPFh2zok2AeMylxN63dqPZegqoUSrHOWapB/23XNSRpkrzr+8q7IsKOh7bElst28KaeSe5xbOTZWSqa0b1RD46fP4WHpSX5Y4Ery18FzUPI9QujoNnkP5SvJY8vN5dt0rakxSKmFNJjLvJS3FyIz
 4NDIoHKK
 huxOmOrmIUmK0jltB5PvHcn2cHvp45laHytiqv5FTi1WrAyfFBejDqR9NvI5HkV5i3KroCdE0Bl/1G4gfNqO+C7+b7ODYurXmdInMfrSQdxV2iyJl1GJuRrQZbvyGrs2lNAzGgDCaP/+aPHZ9t9mEb9nnFi7at5p9hzi4IxiXjnb8Kx/fW8EInoD0lZld2OYPS4tSTLMxCh0FD+D2bPdMu2g9gZaYmOIwuDFDCpoahHSCduvJXLJ0w5NcD0uaA4WL7MvI8IKYcelH8tzMT5v/rrTf/zpyC2GixX3G1Vo+6klSfR/qGOQfp+XluczvX6LAoHMXDSxoiYriJesoJpnOAWpSRCjR6q6MCxYjgN8bxlgQ4c8RT9Pya/R+YL/Ie+78qXTcr/rNtKqcxf2JziyJ0x/VM1cgBSyha3WxAxlyPDpZdlPehCPHHzY7tUiUv9QBngBOjNccZrSEIf46a8h/RKd7FhXN4O4qy5+aNOPSHStUBNnQ3p2kRxSjAkFLWWEpN7yL443Ek4ePVbeQpo3T+kEwbfczWxV7+FcB0fze4WdqrHH9fLMlK/1e+wv/32l3XaMk2IhEjCP9O2EBaC6a3pghDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 22:57, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   b179ce312bafcb8c68dc718e015aee79b7939ff0
> commit: d3b4177bcf978a441cf98b7515d043eb23728194 [6752/7613] gpu/drm/nouveau: enable THP support for GPU memory migration
> config: x86_64-randconfig-121-20251112 (https://download.01.org/0day-ci/archive/20251112/202511121922.oP20Lzb8-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251112/202511121922.oP20Lzb8-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/

Thanks for the bug report!

A similar issue exists prior to my changes, the routine was called nouveau_dmem_copy_one() and had a similar signature.
I'll send a fix out shortly

Balbir

