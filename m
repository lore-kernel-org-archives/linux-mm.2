Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7567D29DCD
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8C06B0005; Tue, 13 Jan 2026 00:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66326B0089; Tue, 13 Jan 2026 00:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13BD6B008A; Tue, 13 Jan 2026 00:52:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2286B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:52:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46BD2C0287
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:52:11 +0000 (UTC)
X-FDA: 84325870062.23.B150D0D
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	by imf21.hostedemail.com (Postfix) with ESMTP id 576F71C0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:52:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jHcC8Dch;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.85.35 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768283528; a=rsa-sha256;
	cv=pass;
	b=E7T5kceBj8c4EsnX/EV6lc8gDrPnr/cVcynuX9BmjAJ7VK5eG8AFPWvzfvBW7z3gj+9/JA
	svXXIvrauboeM5lPoWtxL50de37tMbgM4Rr/Fw/HYjqo/FFyYG4UGmjY0K/twZsK0PPkHK
	7cc0tDeTs/u/egcFq5GHg6WxBeK/D4Q=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jHcC8Dch;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.85.35 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768283528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wmLVXRCGzCrXu9aLdPRcbY7reMcen67M5duzJf6iCE=;
	b=Z+hWnLR7cCcGJAtSHQOv0SAWRdt1+IR08nUvHfa/tNjGe1SF+pbACZngiHoH+iSzgWTXi0
	R5PaxfwUN0i2tyDAp8O+sGc8/Z4IWUtbgj7VcmqLZ/J5nFgHrHu/MePXvey1IanNzwTiSc
	BC4/BigHOqCM8MywMFYgBh+BFIp1ZYI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrnUhpZjfd00hZKF/XeJsNuMvzBJPajpaB5nfgTGt3YCf8zJE/a9qIa1GuaPTWa0MEm4iB2f9wj845oC3PISvO2gpKwC0o98ud5kAkONEjGeWetVxellpqZIczRxbA+95zLdtI3rj0czugv8cR6CM67VD42XXHVPoaGQXGzq+FFLkV201VuVW2gqab9wUk1Ci7HLazYLzZWpgRzSEcK8x5gvpstbv+1YF7OXJBWtyw/JipvHb4MDP4h5TxiIA7CBmffE5dOG/nZVm0VnFCfqZH0MHaBOruKH7FC4yTVAqgjpw/kW2hlTfZhKN/DhTANw9E44ljBEwpJitcGnIGrczA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wmLVXRCGzCrXu9aLdPRcbY7reMcen67M5duzJf6iCE=;
 b=K9VLOy5Ea3zilHEoTZRrGyCtEhL4tRhIMCd5QCN80qk+BcVEQJdp76nYud98X5032wX08Op4yL3St6YgFN3C8y1TQXrhV5TWvRDD49e7sAv/H7JEeHpI2AADz8BW5/hUr0GTFb9Bd/Lk9MbFYuYbbEjRG6TkGJz3PLiY7ASOAECrupzxA1NdfsigeczyBIJYT3YiMUbkqH8/1h9vK1GjaBp7g584Thstc71GvNBBO9n6Bxju/XGADsU4wRa7iGmc0pY9YyOUHmeTcI4e25VHBj0T6XJSzGmXONWq2Bo8+V1WclV86kA1KRuQp46RwHQUqjbXw7JPS41iB1Q2F/l23w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wmLVXRCGzCrXu9aLdPRcbY7reMcen67M5duzJf6iCE=;
 b=jHcC8DchaYvQorZnfoiZLPquTVwQ2RDG08zzG0kmnKxNd8gj49qOZ6OqSaq1b/+ZCgIFFxwkc1FMDpgRsR8OiNDk5WV4nQkrT/svZiTfLYoIQdWxtkrUxwtR7W5rRSQZr1K/1itSA1+UwPCaVsndOjofm2WttCEAHRkvduwlLOk=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by SN7PR12MB8817.namprd12.prod.outlook.com (2603:10b6:806:347::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 05:52:04 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 05:52:04 +0000
Message-ID: <b8285bad-533d-426c-bcad-2010a7c043a0@amd.com>
Date: Mon, 12 Jan 2026 23:52:01 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 david@kernel.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-2-prsampat@amd.com>
 <20260112130401.a857fac6abcf104ea9bb5c68@linux-foundation.org>
 <2f9b180b-c221-4631-93d0-c131332ef178@amd.com>
 <20260112144314.69b850afad9ee67143f30a85@linux-foundation.org>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20260112144314.69b850afad9ee67143f30a85@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::25) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|SN7PR12MB8817:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c389df-6052-4f79-0d17-08de5267e0e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1B1bUs4aGEwajlmVmdKY0FBWXB6UEZWM0RUY0VnN0N6bEM0VFhVMk1aSWgx?=
 =?utf-8?B?YjJCSHNZVkNSeGRndkoxRERXaXhWdTh6enpITHRGUjlEL1Fta1JRckNkQUhz?=
 =?utf-8?B?cEYyQ0E3dmxmb09rSFozK1dveERObVczUmRpem13bTZZM2VUVzNvbEdTdGVs?=
 =?utf-8?B?Y01GYjdETlhWKzd2QUNEMXVTTlpZM21YRnBuUmhrTDR6WHdsNjlMSjFpZXFu?=
 =?utf-8?B?REVQZzhoTVA1R09SL2kzQlhFMWVjSC96emF5ayt4VEg0bTFhaGMzaWp2bmEx?=
 =?utf-8?B?M2JLZHZCQndGMm5VZU1MQ0hGelFQVFM4bC9KQUFxQTNHQWw3anNjTVVrN1d2?=
 =?utf-8?B?c2xKcFhVcitCVGY3bGZJbGd2MDdOSjBYbzJ3SGlsamNVQUNiL2xPTmRhR1hR?=
 =?utf-8?B?VXVYUklyRnkvK2Z0ZWZvWW8zdU8yeU5SRlVlUlNra2RSczBZTGIxRjJHK3dm?=
 =?utf-8?B?WXlNbnd4L3Bha3lqYXdiakphZVVDbkZXZm9VaFBSQWRxSU1rTFdNUmlmS3Fm?=
 =?utf-8?B?bDM0VHFjcm5yRjhhazdKTUlJVlFtdVRhVHlqNU5VcVlYTS9kd2taR3BsVktQ?=
 =?utf-8?B?K1ZvZEZVOHBiRVIzTVpGVGNBQS9udEVsdUFSaFQwQ1ltQXp6TEVZM2tNQ3Y1?=
 =?utf-8?B?MmcxMlBCejNzd0VtQXBJMFp0dE1CSFRWZm1MTkFaY21pb2hRR1pnWDRqdG5v?=
 =?utf-8?B?RGhpZnVhMHdXU1ZXdm0rU0J5WmQwSUdQZjZ1dTBVUWpBcWxaVW4rYnkvR2tK?=
 =?utf-8?B?TVVRbWFRcldCR3UvNVVmcHpPN21rcnFWWWdDVWJrRjhUNXZiSUFWeGxQQmEz?=
 =?utf-8?B?czE2SmpPd002WDdBWTZ3SEdXazYvZ2k4c2Yxa2xyRlNrUUVaNTlmZ3lrQjRT?=
 =?utf-8?B?OXZmbmZ1bW10M002TlI4QWg4dGE5OUhUQXN0OFVOUmpJeTIydTg3eUJxR0Rn?=
 =?utf-8?B?Mi9vTHA3Q1M3VHgraFRydHdNM0doWVNmQXFoRmJyRE8zWm9zNDBWVFppQjhZ?=
 =?utf-8?B?bFdmZGdicnNIZW9sbFZtMklSMXAza1NaSXd6L2JuNTUyY3EySXQweFVOTFZ5?=
 =?utf-8?B?dDBQMTEzNHNHaUlDYjVxMU1wRlcwZng2MllMQmhScjg4RzJIMVRDSHhxZEsw?=
 =?utf-8?B?ZmdueFdCamVCZHFxZjZURWdCMDdocDZMMm9ZT1ZzR2ZRdzd0WkVMNVdxUktY?=
 =?utf-8?B?LzJ1TUJFQzJKYTVrQlEwZTRwVkRJOFF1OTRYU3ROU3V2RllOZmZKRUZKSUhx?=
 =?utf-8?B?UUNMZDJYS1B1N3ZwK2pjQmhyYW5CZHRqeDBUSkczRjhBYVREd3NOVkZrcjFT?=
 =?utf-8?B?aERaMG9ITEpYdzIvNE1COGQrWXR5QlJHZjBnSDZQeUhCOFV0ZnBFa1dGRHJS?=
 =?utf-8?B?TlhYaEJ0RFFYSTN0emYwN2dkSXEvelFBT0trYllxTFhTdGxzQ2tZbDhKNHRx?=
 =?utf-8?B?UVMzOHVlZDVTbTYwbTlMQTBmbVh6U1JBcGdlaUkvcnVmeTFtMW1zT0F3SDVU?=
 =?utf-8?B?UkdVSEdPdk5TYnlKc2x3Zlhnc0F5KzkzRmN0aWU5Yk90WUxzQ3lTbFVWMmNR?=
 =?utf-8?B?Y0FxRWZQSWM2aXh2TEhXTlAzcnVIU0ljN2M2TEE0QkpuS2NENld1ZzFyb3dX?=
 =?utf-8?B?MDA5SjFYVTk0Ky9mejdDUnlQTHk1dnZQSEJjaExkUlVpL09mQkt6bUhZcW12?=
 =?utf-8?B?T2p0SjVyU2dlcXpnZkovZVZVYmJxdWFhMm1lS2h1eEhTZ3BXTGNKYVAxRDJu?=
 =?utf-8?B?d25jckZ6MjBpM0lVL1lLdFI0ZitWN1NJYUw5ZWd2NUoxN0tpRWZjZVh1d0lH?=
 =?utf-8?B?S3ZLSVVDandyNGxrZFgvR2N1RlgwUlA2TUxJektyQmhGa2xTVjN3QWh5NzNu?=
 =?utf-8?B?MlVsMFpsRy9oU1R1ZENwS2cyZW1tbUtkdS8zeFhQOUtrNUZ2RW5CcEZtbXVl?=
 =?utf-8?Q?HdChtA8LqKTXsW4jO/4KsvH0nPdmu47a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTBvaFR1UVRGc2R2V0h6bDZDR1I0S0xCeUxRYXhFbkUzdjYydWpSN1JtU1Ix?=
 =?utf-8?B?M2xYSDNoY25jdWtvK2w0ZzhVK3U3RlVoci80WVJhZTV2bXN4a0xTWlA2UzNH?=
 =?utf-8?B?d0RIYmQxRU1KRGp6dWtSOU9kT1ArcG10QVpqSTdBcUZCa0tUNG4weEJoMGx4?=
 =?utf-8?B?NlNrUjF0TkxTZmdpdGdRbkZzaWVobVQ2WkFOWUdkSGY0UmEwRC9DN1FGNGYz?=
 =?utf-8?B?c0FYQWdWTEQyam1QcTJtMFEvSmhlUkt3cVlhZC9JWUJLaXozYjBrQzZ0WFFh?=
 =?utf-8?B?U2RDb3gvR28yTTUvVk5kbW9rMTBjZm9HVVpuRWhiTFpKcmFpeGhWSWxHR3pa?=
 =?utf-8?B?Q3pUemxtdU5xWkJhNzdHVnE4djJrM1Y3U2d5cGhMc1Vya1hmb1BIV0lnYXFE?=
 =?utf-8?B?UDdRY3J3M20vN0J1b0ltdEFIRDhmcVdlb1pkaVpkWkw0dXpLbVhpdnJXUjF0?=
 =?utf-8?B?Sy83OG1DZmsvV21GdncxVEhjWXFNZ1FrVTlHcUdFdmdaeXk5N3RiZnNKcUJ4?=
 =?utf-8?B?OXRZYmhtWHgwUWZIR3NQR2Fkb1lZcDBxU1hsbGdyZ0hhcXE3VGc5UUFuaWVJ?=
 =?utf-8?B?ZzcxQjZTQTBZVlRmbVNMVnhUT2Iyc2I5OVNzSVQwV05FcXBZK1J3UndGQ2Q1?=
 =?utf-8?B?VFl5Ni9HL082RjdSUUVUcDdKMmwzNFNmcEo5LzlEVjltOC9zTHBDVHo2SExt?=
 =?utf-8?B?Nmx1WFVxcnIzWkdpSXRhWUNGRzJlclg5OU1MSXNySEF4aGVRL0J1NUx6blRh?=
 =?utf-8?B?d29hY0xST2xxWWVMckNWTEVLV3BwV21YOGlmSW82UmZKbUJKdTRxOU9hak1U?=
 =?utf-8?B?b0hwOHdhVnpkSmUvcGhMUktRUTN3bUtMZHRvdys5VngvdHBKMERvQjg3WHRp?=
 =?utf-8?B?d1dOczR4RDViUTFNWlArak0walNZbXJ0MU54VXJNTnN2TCtObHpzaWU1LzVU?=
 =?utf-8?B?YkduSmxSb1pyQmlDQkxnTmxOR1BSaGp0Z2E3a0MydThlYmNPQ1NzY2tNZXdD?=
 =?utf-8?B?SGx0NGdOeHBYcDJFazdJVlJiNUtoSXQ3QjRsYkZhc3BPdkkvbGFqL1JtSGg2?=
 =?utf-8?B?aExmdkpsS2xlbGRqcmRaaGhuNUZjZThDbUpxYkJUOEh1RDJiUWpUbThnZDhS?=
 =?utf-8?B?Vmt2bGcxK29mc05qMHIzc216YkVFeSsvb0tTRmRQUnBzMVB3eHhORklkOUpD?=
 =?utf-8?B?YWxud1lJVHp5Y1JJYWd2WUt0N0Exc1NLVmZXUGZIMmhrd2Nwb3dBTGR2My9J?=
 =?utf-8?B?Y1hYZ2pHTHpnOC8vZFQxbXVjUTV6WWRDMUkzZ0svSzNkeTl1bGpsclkwK1Av?=
 =?utf-8?B?MWFrSU41WTYxR2hZTnA5cStScnplbU9KeFFwMmt2N2ZETS8va2lKdWVmMmE3?=
 =?utf-8?B?UkRPbmFlMVhLWThXUXl3K1RXdlNnTVhhZkxNQjMzWWM2U0NBNWROWFZiWjBV?=
 =?utf-8?B?NXpXSjVNbjROTGpyaFFPMTh0MDFReC8yaHFseGp6NjJ5anpTdXdjelh5bzU0?=
 =?utf-8?B?TVZlK2hqSkphVmFRNUR2bjg3c1d3aFY5QWpvMTgweW9VR3JEaHAvL1JCSDFx?=
 =?utf-8?B?M0NkYTczUlU3cDVRTk5qdjZxYzNSaGQzZUNvNVNOa25SOUNsVTlOZkVZTHhp?=
 =?utf-8?B?VWVwL05LTWFZUTJoMnI4QjFTdWVxekc0RlpxNTNBSkliaGZWcWxiUy9peElN?=
 =?utf-8?B?YTlOK0VqRFRhMm1Md05Dazl2a0pwMjNYdTZCc01panM2OGFTR3BjS0N5djl2?=
 =?utf-8?B?QzRpeVgxTGUvR0kya09ISnVWbFhzRjdvNk9yQ2k5WkxpVU8zRE4wMG9Ma2pi?=
 =?utf-8?B?b0pMcHl3ZU9vTzlNQ29lWHBrdVJuZmwrejRJQzVxL2RNcmdBVTc2OVpuNFAv?=
 =?utf-8?B?MG1jM3lZTkt3SmRNVEorWlJmN2xaL2FlSHZPMHE1MXIwc0ZTdVZRU09zdHE1?=
 =?utf-8?B?UjlFZjZUbk5JbUVHZElOS0U4VFFuOVBFWmJnTkwrRjliNkRTVkU4K1lzRjZp?=
 =?utf-8?B?TDFtZ0NKV0JndG8vSHI0b1NVdDNwUEx1R2M5UU94Q3JqTTZuWXJKR2xUcU5M?=
 =?utf-8?B?YTBWUk0vbUZIWVFseWJ2NmdIZHNhcEV6QzJYZkhQRmQ0WDNoMnZPeThDczV3?=
 =?utf-8?B?S2c1TWsrT0lyeGdQUFFJQTBEdnRDVmpVb3ZEVjYrUzdwdHhQb0d6aUxiWHFt?=
 =?utf-8?B?SGRPNGxnL0RSbGc0USs3bFpPaEZuUVZpVEMrMG5GUC9qNUxlQ1REYVlyZklk?=
 =?utf-8?B?VEFrRHNkY0lVU096NXcza2diOTNkOXJGclhRdXpwbnR3R3ZZRko1QjNtMGZi?=
 =?utf-8?Q?DA4VW/+odm83+EO+zD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c389df-6052-4f79-0d17-08de5267e0e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 05:52:04.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0jDey0yuiD2t58pjsOyXBz00EPBt9+c2PEnuuxaSSF1b2DDGF+19Nv++eTkKIrNtN5Na00VJ/EtA1xFBhUW0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8817
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 576F71C0005
X-Stat-Signature: fta9mxqgw8ojjmgzmgadzsd1k7pah5rw
X-Rspam-User: 
X-HE-Tag: 1768283527-107257
X-HE-Meta: U2FsdGVkX19u1yUMHxqYzTpavATMDxoeqwejG63IMbmLaoXlkqOUdr81PjO4PT8Aet8ujE//ZlVeTDQkXn+c/0vUfO+ylE4yD57ig8bARtlmwNed29w82BCYVbljJfUbgiHQyGZS3/Hl4N1HJIxFL4fEW2aRvDbM/wmBUnww1+uw5jMZS6bpO/rfX6CvgCKOjceoWkDcMXUihlMSkQ2AnDEYy72eTtMwzUTASSqYYe/FWfTLkL9eyuXpXYP3WhSEt37c/0Bsrv78bDsROM/ZGDsBjCJCGioOWGShhhwRBPBOK9tBBEMEuHr9aB21GLh5vFLtqElggTSLCF/NAqGDeER/s3OOuuumhjl+HUPjYRU/oZiR/nOb/OJ3Tcpc2/ZL/6AwpWxnRYiHTpvYp3GenZdxrpRsgX0nLIMDnpjSJqjFb10s9yW2efmO/WFxKZMrwd+iIOUoIyaX1eWckR9zbMNOyks+lFqi/ut77wON5cH98ZZ/KpXz7LR3njDrGzXAiFegLbAdxDHcjMPRafSYHkDT1SI9asyv+CUdNe47HttARCD36WZKZhPjsi0Y+J1/G5VYACBO9b3y1HPn+4AJSBOYNT6t4mBGNxEY3hnpyrAb2H0sh6QPKr+6h43uCUSgN1Mhjc52fsOZADn4erfU09YUOzWZAfXPneb0eBnm4aqwh/DMnoOQKTtpnvXmGh7968yatTDtCOvkgMo8NkGwSaI7m+NLfCXH1+uzngxnUGREmZ5VRTzIrrtSkIvPkcVMJEo8MYMRWyMDsRAIRo9+ySJOplsMHos7UCSXjeMViuyVaEVkj2j9IbGtiqjXxNPZeA/IafrzSqqLlVmsh1zYEIogkz1L77GnJQtoCSdndT9GC5Z02WhXCdbaHAMrmeMf811238idOnm4dkWBtCedsT3bq+Nst39ME3MPwDnM5hlzhggZQTqsSfq04hn1rYzhcUN57pNJkZHJ1JbxkJ0
 F3XkW680
 lJDYAu1bmLeBBP5r52qF5APc6WGkaCaub0MLmToo2YFmQsoEifI6p8AArusN1WX66Hno8AXNSK3RyI6Hhp0JMd6j5VagUE84CtolPrIreETJGWIgZZghb8SGZ10PRnbbHK7CwWFU6vB8EEo5GW3BhXDIZn14iFcYgLXUgA20Cl5XqZt43QxC0p2sxx2DCiAWhATHSkjSYDa0llbBJSt3ig8x3PsYt6herKkU+ZWFm4gKm0fshNij7jyIMBoXbMb0i5XPALeYaCsoeEwgcJsasCE4AaiivZ2ReKNen61qopjR2ilOnfw0V6JZLKEzff17Asubz3SIInE5UV8JtM8KuqyvzE8PkXK3FLp4N3+ocvRnCf1Bij0O+9JXsjFtCAGEEDQKX0qbLqgdhjWOPoFzAR8mDDbOkShwH1I+OMlgiheD/3jZJygj5itw4HAJxYEZospctDDYYViSTsz8y7wibsMV6RiiRWpeISoYajwH0K+y1qTYdkJDOiF8Ko3xYvTuHvUwX8UaPh4T7NbwmS9YCRHgK5Oo7I6JzopUSrrYfGyE+VXiduX0eOMMomIqOsU0aBubFQ4TGNS0GfB8vMWPBhTZg59x+dmJnciRvjYQSM+LxjFqxqowIRNOtwmGGvhpfPPLSKgOl5PVeimIiySqDGoSm5dBBKsdGUB8C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/12/26 4:43 PM, Andrew Morton wrote:
> On Mon, 12 Jan 2026 16:23:37 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:
> 
>>
>>
>> On 1/12/26 3:04 PM, Andrew Morton wrote:
>>> On Mon, 12 Jan 2026 14:22:59 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:
>>>
>>>> Confidential computing guests require memory to be accepted before use.
>>>> The unaccepted memory bitmap maintained by firmware does not track
>>>> hotplugged memory ranges.
>>>>
>>>> Call arch_accept_memory() during the hot-add path to explicitly validate
>>>> and transition the newly added memory to a private state, making it
>>>> usable by the guest.
>>>>
>>>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>>>> ---
>>>>  mm/memory_hotplug.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> index a63ec679d861..8cfbf0541430 100644
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -38,6 +38,7 @@
>>>>  #include <linux/node.h>
>>>>  
>>>>  #include <asm/tlbflush.h>
>>>> +#include <asm/unaccepted_memory.h>
>>>
>>> This only exists for x86!
>>
>> Ah, I missed that entirely. Thanks for catching that.
>>
>> Probably not the best option to have a generic unaccepted_memory.h as well.
>> Maybe, I should have arch_[un]accept_memory() definitions within mm.h wrapped
>> within CONFIG_UNACCEPTED_MEMORY instead so that its cleaner.
> 
> Something like that.
> 
> The idiomatic Linus way is to use
> 
> #ifndef arch_accept_memory
> #define arch_accept_memory ...
> #endif
> 
> Lots of prior art here:
> 
> 	grep -r include/linux "ifndef arch_"
> 
> 
> Oh, arch_get_idle_state_flags() got it all wrong.
> 
> 	#ifdef CONFIG_ACPI_PROCESSOR_IDLE
> 	#ifndef arch_get_idle_state_flags
> 	static inline unsigned int arch_get_idle_state_flags(u32 arch_flags)
> 	{
> 		return 0;
> 	}
> 	#endif
> 	#endif /* CONFIG_ACPI_PROCESSOR_IDLE */
> 
> - shouldn't have needed "ifdef CONFIG_ACPI_PROCESSOR_IDLE"
> 
> - should have appended
> 
> 	#define arch_get_idle_state_flags arch_get_idle_state_flags
> 
>   in case cpp hit the same lines a second time.
> 

Got it. Thanks for clearing that up. I'll make sure to do it this way
in the next iteration.

--Pratik


