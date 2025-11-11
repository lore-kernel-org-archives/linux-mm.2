Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A8FCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 23:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA398E0010; Tue, 11 Nov 2025 18:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A878E0002; Tue, 11 Nov 2025 18:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D284B8E0010; Tue, 11 Nov 2025 18:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDDE98E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:55:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6306013A110
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:55:51 +0000 (UTC)
X-FDA: 84099986502.19.A8C06D9
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4DB1C4000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:55:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aG8pOoGd;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762905348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Vy2x4bxI4SxkmvOuXZTw8wOf1cXcr4/3ScuE3J98NI=;
	b=77S4/aKvTWRseOXAnfDewFiQU8SIUaNFsAb7Bc+E9sFA/K4QHHN1UbwhUeJI8rc7cGFxWT
	y+4N7AAWm3J8Gt9diM+S6MgvKMtfLX59Za9PtnBsrXo+S1hHLIZaI8UyJFQakvlmj2dVPM
	dnihqcJz9Lh1hp//YBTNb84Hs+G/TuQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aG8pOoGd;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762905348; a=rsa-sha256;
	cv=pass;
	b=nD4nUQBgjxq7a725ef+YYu77XLTnJ5oHhPmN2zcPBpcGtyeAY4h6fO5OSGC5840A5qTLiX
	LKA3UsAUYa9pi2ehL3k21rNfNWRcxgsglD3G6NykaVI1mcWUdYVG4Y16bh8s+e1i5p/J9l
	gVK+i3aue45If/ZjkRhVTFiw4sy/Hac=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NEZ8C4YfTi94uWuGScgQk+esGq2oRCAxMvTPCe+fv+FUltYyMMKbAcyu1XaT76tPT1hkQLnXcfrjUdwwjjJRQMCFfHe3N23QXH1TsNmglwZhEcFNCuaRtNwbG+UI7V7+dt0rNKcm4fhZk3tyE+sOfIHNa/QFxNLkmuG1w/wp2+PKfMVmFRkrGSWfER870zwhEtD+F8jBYSX9ri2RQ7hjxv343OrPB5sS26NrdgwGKDdxN0Zj5/gvSeSsxLGfxARp2dzgiELF9pWWeAHnSV2c65XvLESADaJ6a2ORVbSjXXrNNtUMK8yRY604dhngS6TEXSw+d14lm/o1rs+ii7UM4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Vy2x4bxI4SxkmvOuXZTw8wOf1cXcr4/3ScuE3J98NI=;
 b=yrBSBWkXlilwwH+XINlD/rEAhkrNHP9etHIgEJ8hpLVW/AZcjTxraH9APKG82vzY6lDbgZluoWt+QmJSzLsSXLvN/wx49h3Laist9sSYCKeZ3HjHbzzfu+r27LOn2CKpVi++jxZTD/mi/C63CIHg24FTFQdsaV0UAZMYMcfeauRP69EDUADRCJjYGlVcDssQmONAIZvberr5JYv009IbUvYW0ffYy/1wVsBMPCAqwvcb3NLIdSyBy83J7pz7JBBzBG3uSbm6bVO0TntfSIR0oFeqhRVlSY6WF73pg2UUr/MtLBVARytLzedAZkn8uH7eKB9S3HadvGR/HVlHU7aM1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Vy2x4bxI4SxkmvOuXZTw8wOf1cXcr4/3ScuE3J98NI=;
 b=aG8pOoGdhJYu0hkzGu0IJ48A6VnJ7RnYPk87WFYxDD6JX7vAI1eVkwMW13a7QGoIvAIN7N1tgyMIepK0gAjZSaGsBoi6i/nEz14ASbPeoOjOl+MB4FsKK29S2KJhR+wtYd0MZg1hQ44oVQ/KZL3tXAvDWouhT34Pyckw5kP52Q8t1QEG4kvZY9ODb16RO1snYh8jp/sODhu/OvcQTkzoL7YTcvUR2wsPd76CwNXuUyaMnFE6hKh60CNnLuisI6Hj7rJf+xfqz8mXdA9jSkk6dZgAQKwHhEv28IMXhzs9GdfuVICSkX0z7aoRfbNTdq9nzi5EJrPt78K2nmY5ii6TVQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB5840.namprd12.prod.outlook.com (2603:10b6:8:7b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 23:55:42 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 23:55:42 +0000
Message-ID: <19887745-170c-4cf4-8028-63a091a5493c@nvidia.com>
Date: Wed, 12 Nov 2025 10:55:37 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: Add tracepoints for debugging
To: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20251016054619.3174997-1-balbirs@nvidia.com>
 <20251110161954.47d88433@gandalf.local.home>
 <20251111155042.b07ecb045c978fe4c457b1d0@linux-foundation.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251111155042.b07ecb045c978fe4c457b1d0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c5f11f-d167-45d5-229b-08de217dd2e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|10070799003|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZitVNmdyRldjVG42OWxVSkRmQlFwNzdwdTM1WUNKbnA4NzJpQk4wdUExcldD?=
 =?utf-8?B?TE5acnBrcWZ1bUFyN1RoZW5JdnNkdW1OQzFuN2tGN3o3Q0RmUllCZEJsVGlI?=
 =?utf-8?B?aEhrRFlyR0R6b1JIaU1SelFJaVoxVWVUQzhyaTFQWjRIcWVIdXlXazlPVmpk?=
 =?utf-8?B?R1Y3VFVXQzgyZWVIWFJqa2lHVXZHOVlucnRRQllNbTM4blRlZDlPQ0JPRHNN?=
 =?utf-8?B?SjNHcUpLK0Q1d3B3ekkyQ2p3RVo3NWRIRFRtcHBWRzBvbGsrTXIwd1VKcDhJ?=
 =?utf-8?B?VW9VTHo2QmthaExKQlowMHZjUFBlR2djaWhnMGx3MWkrOVh6a0M0a3lMdllj?=
 =?utf-8?B?WUlZUXBLbjZRSUt1Q3IxYzBaT1k2ZFk5a0VpL21hM0ZQOU8wd0JTc0VxR1gv?=
 =?utf-8?B?RXhlMWNvY3lZaG1NLy9CZ0tSK1A5dzBySmZPNU5seGRBbXhoZVRMdURmZlpY?=
 =?utf-8?B?YkpCSU5PdWNXR1NRcCtvd2JwcWZsREk0M1owT3RXYzNPQXVzekRlYXZ5MmdC?=
 =?utf-8?B?RFZOazlrVTd4RzViR2xubndLUW8vZ0o0VlRKVHNuaGs3RWFubFBVR3hkeHpL?=
 =?utf-8?B?S0V4VVpYTzBUM3BWT0dNM0hPZ1B3TEFPR3hPQ0QvZXcrdmhzR3huUGJXL012?=
 =?utf-8?B?bURsRHN1b2VncmNGWGZkZkt1cFhrSkE2cXZ6YjFKK2JZMEVRejAwdVNTSDRM?=
 =?utf-8?B?MllnRis0a0F2UnVtMlVQblZzTnVkTzRQdjRRdW9UWURJd2lDVDFBenFsNERO?=
 =?utf-8?B?NFIzaFhzcnNSYjVTOWc3VGJCVXVCSDQrZEY3WTltMzFxTWNTS3Nic3V6L2Ey?=
 =?utf-8?B?RStnOHg3VlU3ZE1DOXNiMVpwUVA3Ti9Da2xRT051Z2VJQU1yYmtRK2p4RHlu?=
 =?utf-8?B?dkxSMTVQVWRjQ3YxbEMwR1N6THl1TnZvMXRQTGhWOVcxSEU2NFZlaGpaOWRv?=
 =?utf-8?B?dlFVb0Fzdk1PVzFLUGJpY3E1eUZaZTlwVjRuUDV3dU54UmZIQUY1QkJoeXNx?=
 =?utf-8?B?bzFyRzYzK28wWGdPeFczRkNDR3FuRUV6SllsOE1IUjJyNGl1d0ZCZE5wMzYr?=
 =?utf-8?B?NnlYZWRxL0FSTHJOR3g3UnVubzJ3cko3QXpaTHVHWHUrb0JmaEZscFVVYVc0?=
 =?utf-8?B?dXRZMWI2UFBKejNjcmh3bGVxN09pclFvVzZaLzdHcGh3L2dHaW5DS09ncC9Z?=
 =?utf-8?B?U0gxcnlwV2FFOFJ5OHJpTjdOYVpBbVNQRnZOZ1Q1ZExiaUdGdVJJS1lBSm5S?=
 =?utf-8?B?dlg5cHAyU2gwbzRMZHhhUXV3SnpvZE5nU2hHa3NteWpoVmk5ZnU4endVLzFh?=
 =?utf-8?B?NGRHZVF1T0RKOTRNV044bVBDMUs0aDlMZW5tZGMweXJvN2huZVNNbk90SzZl?=
 =?utf-8?B?N3czc1JHcU96ZU9yRGl2bDd2SHBieHFxaW02VzFwN0ZVTmthL2VJYUIyTkNU?=
 =?utf-8?B?NmJvSVVROTVBaVlEb3I5NWV2bkFTOE82QUFQMU5aOWZaWE5FcjNVdU1wanhF?=
 =?utf-8?B?QjUwYlRtRFI1eXBuZDBKakpIVUw3RjBjdis3VmRQU3BrS1BzTmFvTVpQNjdn?=
 =?utf-8?B?N0xDSmFrV28zeWtBbXUvZHBYRzMxSUU4LzljNHdIU2Yrc1B2TUhjMVhiVk10?=
 =?utf-8?B?bm9JZ29TY3ZvSW04RDhJazVhMEZqZkJjM21CMTI3WEgzTVJvNTRWUVVOSVYv?=
 =?utf-8?B?bHIyQ0NIU1VsQzViQkhpZWhDVWNJTDRTL1EvVW5OWk4rUm1sZDY1UkdBRnF3?=
 =?utf-8?B?aUFNK0l3RUI4QjZRVFFKcEI3bUdmL2FzM2JCdWhmeXcvZjE5Q1lxSlRPQkxV?=
 =?utf-8?B?Mi9yWXVJY3IvQXBORktnYmVua3l1MVRZZmgzUjNRTnB3S3Z6MU5CL3l3ZmFs?=
 =?utf-8?B?OTdCMU5nYjQyUk1melBON0pDU1BuWll4Vk5MU3M2UHJqZjlZYXM3REdVbWQx?=
 =?utf-8?Q?YuPhCeFOC6uKN5CS6lBv+krfOEv3IAZu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yk1YdW9iQzhyVldlZlNXSjJFTGZRUkxmNDlhV1krV3RDVHI3MUptOStiYS9n?=
 =?utf-8?B?M1BsM3h6dVVvREVkRDBmQWVSYjF4a2FYbkY0cU1BMlJtYWxHUVl4Ni90ZHJr?=
 =?utf-8?B?RXNidjM0UlZGbzdweGJ3WXZUVEdvZzhLdWphZXJxam9LMUdLN2FkYUErOWhX?=
 =?utf-8?B?UEgxTzVLVVZBY3UzeGdBSkY3U0JhTTFhMUxiZ25ZWGExVlhWZTYvNDh6QURz?=
 =?utf-8?B?aTZFUE84Z2RFdkJNUWJ4YWUybENidXpqUVhuUzZRUEUzY2ExMWZjYUJNbUpy?=
 =?utf-8?B?QTl6SDgxM3pkdmRMekZPTkZETWk3OVdpeFQ3YUE5STFMU29MQ2FHOWtIc2RV?=
 =?utf-8?B?VnhaNktrQ1JCOUlsTWREemIzMlZsQmxmUVZuYlUzcTdhYys2UTlMdHhIaWh6?=
 =?utf-8?B?d0xUQzJaRlMrVjJva2hWK2YvSWNWcHhDa292dDl5Sm1NTjdoVjloTWR5Y29D?=
 =?utf-8?B?ei9HVndtRjVhKzRaV3liclJkM3N4Qlo0NkgzRmdEREd5TzhhRTM3UEhybGVU?=
 =?utf-8?B?YmxRbmhRU1QvVFM0T1kxWlA5UmJYUld5ZzBMNk5hS2EvcWE5OG4zOWdmaUth?=
 =?utf-8?B?MWRYdklOOTNFVklzNjJIS2laNGVxY3F2REVoUjBOL25vSmE1cE1qVExwTVBr?=
 =?utf-8?B?WDlDRDNNZHdhVklrYkw0ZXVnNTdlVXJxbEFJaXI5endSNVNydUJQN2xwUThO?=
 =?utf-8?B?bkQrR29zRTNJSUcySzFlcXlpaDg3S09BbnFnQTc4a0lrZXg5ZHprV1J6Y1hO?=
 =?utf-8?B?ZDVzTnphaUFwRlB6QkxtN1I3TzY2YXQvZVpYZ2VVUXhMc2RNQXdoMk1YMkx3?=
 =?utf-8?B?RFdNazIzL2FEL2I1am45cnFHRnlVZEdFWmh3cGhEWnRHN1JRcGdOTGl6M2dw?=
 =?utf-8?B?WVNuR0hCV3duVnp0LzBBL1Byc0xRWW1tVEhRSGZiamRTS0lsYzFDR1N6YjhG?=
 =?utf-8?B?eGJFMm1VVnNBc3NFS1FkaGZPeFRHQkx0VkJHVlpJQUlQdDJIaGFtcld4S2FB?=
 =?utf-8?B?NDRsYkJvTi8rWlJBZS9sdis1eUplMm90Q3hRMGUxMWRUNHZrMzNUSUVwZGNz?=
 =?utf-8?B?SkpLK2NtQmlUU0liZG9vMDRFYldIbng5M2l3Q0paV1lDcFBTYmNXdDR4MTN5?=
 =?utf-8?B?Zlh4N2ZXcWkrMW1HRzYwYU0wMnlFK01zV3o3NWdabjkzNjhaRWcrUjlJV0VW?=
 =?utf-8?B?aGNObS9tVG5IbGJWcWJGWFo3ZHNlL3VEL0ttN00yNlZMNDBOMGRsWHhJWUF0?=
 =?utf-8?B?aEZUNm5nYWhDazdEMlpSN2trdjh2MzFGWVdSeXlPWi9FS3RkMHUyUWhMb1J5?=
 =?utf-8?B?dFNnSGJpYmlHKzZLSE5qcHA1K05qQ3VrZTNxVzVKSTdqa2FYUFhoQjV4RFJr?=
 =?utf-8?B?dDdSaWVjaHVtTkRPUTQ0WVdPT3lOQ294MGcxSTRWSE04WCtCdXFiU1AwSE4r?=
 =?utf-8?B?cUhYckFFdHR6UjNWdzI5N1dCdUEraWlmN201NFhoSGw2THpuZ1czQlRYSGhT?=
 =?utf-8?B?dVdGZ2p0RWRZZ0FKWjN1RFlsSkhPNDJhSEtWZnlKMlFqdzZBVjN0WDBpMWxk?=
 =?utf-8?B?M3NLbXAwak1nMFpBbnp2dWR3akMxVEZBVGwvTTRhUloycC81ZTk4c0VFdjht?=
 =?utf-8?B?K2VvSHRNN216ZDhFZk1KWmlLWEYrYnorUHFibjN5VjZrYlNkSG5NbjljbGo1?=
 =?utf-8?B?V2tKemxnWlNpUHV4WDQybHdJanFPbzNtSEtJcEcwajFZN0ZnQ1R1U21uYXVZ?=
 =?utf-8?B?Ynkxa3IwYVlTczBSSkhaZTNiZ1pubWRvZVBwcERuSDB0SXJOTWN4VUNWdzVw?=
 =?utf-8?B?aXRPd1ZWdVhmZ1p1VTRkUXRtU2toSkxpdVkxcXF2S0x3U3hZcjM0KzcvSjhy?=
 =?utf-8?B?QSt5dUg5ZjVaQ3I2WVZMajgwK1AzaUgyVHBIaExOZ296VkRiNFhuSkhnek13?=
 =?utf-8?B?L0xQeVU0M29vSXhqOTRLVjhIK1M0NkcvRVZsMkJXZThzTlg2NHhFYnR3OS8x?=
 =?utf-8?B?NmRKSFRqYzNsWE9GcThoMWtrR09IZlNVdHpRR1dmTTR2NGN0UFd0dXdzWE1r?=
 =?utf-8?B?aGJ3bmtoOVhORE5TWFhueUo2aVB3Wjc1Z0JxVjc3YWRLRmV3SVgwaVJ6RXBU?=
 =?utf-8?B?S3VYYkZxL1g1VjgrUXBTYnlRcFliWTdTN0k3T1FHaEhyb2tSblJDbW5WYmx3?=
 =?utf-8?Q?8YkpxbHK5JjYzvxyCgy1f8TmijI8JmZ++GK5nfj2IDLi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c5f11f-d167-45d5-229b-08de217dd2e6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 23:55:42.7565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2RYI12JHb+n3YvSA29wk5Smowk6548QaEIZEyhPnRBMy3/55+hE/Sk0vNQ+SvgwtOn3fMZvpTSRZHCcasE32g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5840
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DB1C4000F
X-Stat-Signature: 3ponz7t47awdueur3c6nbkm1ce4nudfc
X-Rspam-User: 
X-HE-Tag: 1762905348-650209
X-HE-Meta: U2FsdGVkX1+89sL4zNLRcYpV9ldXE8tJOY+frEKcSNbvOUkIqELxHYSHBXMpXPYIusAZ7lSuu+qxgg6sLQvpYQ8NioG1nmzwoOznnGuDANJVALR3N2EyP+lwkOIZeE9o3jvCKWTcasx4YZ+7AhqDn26Epa9AQyVTY33YzFOE9BvHpJwdlqUZgS/BVZqN3ri90z9LIl5xu2TSBssUYJwZe8du1QtWwisbCqQqyDBjoyThTIUinSPhpS2FQJMA2WCxNerRRaO+1jasdK1Z9IQhgV15NX4JJUAZQG6ssTmEAdrtIiTUjde5Fyv9cyAMq90n5IWJIGLtyJw91QWUeD2s9P49PubM4yqXeFqjZ9PS5CZHhewLu24dYb1Z0PnBijg8z6yFDwtTEeI1PPdMLG3RSrS5ignhjryYPW3xGGmlnulk7kYreUNbEUjnyHve2HRiWbM30l0ZBjw+FGCXnjRzEVONsD2ZN7F4l5IOCQdkJnEi79eGXKeCN/DU5zlNjbjH/m4VnTfQoec2fd2zdo9srlW6bbpB+n57pDwhKJoa/8DWzRSlO7PYiOUyt9/KNdpRarNBocxZbPiDrY/LHVjpg0R1Bu9Tj8sgItuTTrXmaYkYaiJP5Lp7fVpUNuHxuSqv8tsACJ/9hTgpLurX+I6YozP5xPiLyH78S7XpZ8J3X86EPo+xRt9ajt33ADNVV5+djp9zegxU/gIRWgcRGSl7qimdPMr5Nw+ACALr0DHAOBdIfA0k2sTURo9juQ69z3O08WH4ZX4173p1brmOKZ/a2A1gLzkkAOvhAeCvrqM0Rg1okvYZHsv3JJT/8EIRY0qKpIHOMddhao0DYm2sN9V66GGORKE5aO4HTGVrDKeASiKU8BHollXfXyNngCMyhLbRvvxxcva0tQkVoKlwdtcetK/+MSh9Idm0vl8k4xCU68SlV/C+hcemr/hvdUiZQTxm56JUS1FmH83BY4edxCi
 b+eGqiSU
 dcvsD/YwQECLzKRAopmEACvE+BtdXwPJDBZdhQ7rVUfTQKZSLgcmCf/nb+nfM2aCeTtwGTqmfAqPnVXlS7in2PeYLUqvFNTMg3sxUANhvLMjFyOz8yuUTH1mJCG47oFu4x1a7aksFSBtUONS357kvuiUgmKrvNag7eZxBixxiCA0xn7G4IO+2qMvfNUpTUhrbJdXHVE5caBikQ3+PzvPhBIFLxKoX0LsaNDik4hGtT/3AEUf8FH7ARwGfyVoNFG1PRID+Z9iFXza3KxR7LLzcyYrpgCJo1r6ZskrJxLhYbSeNDjuag8Yq2AnAOwjL9R6NPonJPFqTbmfAr9bbhQ7PmNWNftm6mKDp4ihYPpX0uhoSHZ2cnmDnFoefA+Frsjwul7oP/CV2dPD9+NhfdFKWr8ujJB/07WaRTmjDgHXmBQYrDbAislIuE+VyFjW3QndpFsN216r1QUErwVZaY6ZTOuunPG+MHUdPYFpYG3OjxoVjf8l7iowXyQSYuMnp5y9ddhv++0xHCv1W4+kAgkRyfwy3Wf7tF+NAVtoUwD0EkN4VOxXPMPvyv8ocgGnkuOj+Wwp5grdD+pD9lIlgRMlrSC3fzo+FG+OYj9oMxEE5d4nl3lc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 10:50, Andrew Morton wrote:
> On Mon, 10 Nov 2025 16:19:54 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Thu, 16 Oct 2025 16:46:19 +1100
>> Balbir Singh <balbirs@nvidia.com> wrote:
>>
>>> Add tracepoints for debugging device migration flow in migrate_device.c.
>>> This is helpful in debugging how long migration took (time can be
>>> tracked backwards from migrate_device_finalize to migrate_vma_setup).
>>>
>>> A combination of these events along with existing thp:*, exceptions:*
>>> and migrate:* is very useful for debugging issues related to
>>> migration.
>>>
>>
>> ...
>>
>>>        hmm-tests-855   [002]    50.042800: set_migration_pmd:    addr=7f2908a00000, pmd=dfffffffd39ffe00
>>>        hmm-tests-855   [002]    50.062345: remove_migration_pmd: addr=7f2908a00000, pmd=efffffe00403fe00
>>
>> Each TRACE_EVENT() is equivalent to:
>>
>> DECLARE_EVENT_CLASS(event, ...)
>> DEFINE_EVENT(event, event, ...)
>>
>> Where a class is around 4-5K in size, and the DEFINE_EVENT is between
>> 500 and 1k in size.
>>
>> By using a single DECLARE_EVENT_CLASS() for multiple events, you can save
>> several thousands of bytes of memory.
> 
> Thanks for the detailed review.  I'll drop this version of the patch.

Thanks Steve and Andrew!

I've been looking at EVENT_CLASSES and looking for the savings you mentioned. I've not yet
finished my patch, I will resend it as soon as I have a new version

Balbir

