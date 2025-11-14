Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57B4CEACCB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 20:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A8E8E0007; Fri, 14 Nov 2025 15:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB428E0005; Fri, 14 Nov 2025 15:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82AF8E0007; Fri, 14 Nov 2025 15:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4AFE8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:25:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CBF9894B1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:25:30 +0000 (UTC)
X-FDA: 84110342820.02.4D9AF74
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012048.outbound.protection.outlook.com [40.93.195.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id A6193120005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:25:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f56ilUMS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.195.48 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763151927; a=rsa-sha256;
	cv=pass;
	b=0/f/qw/9oazaem4RrSuiyCykooHUldDyoyBzGTdz7jwbDNBWmtqbLsSj5aqZt4w5TJBi/N
	wqqYqsQeeSsNcPCkQfFM2nO1LR9W+4xGaxBNnTXujcH+GAoyqDGy+FAviENyDjfn0x5186
	5aJ6bOREH5p9ryzcGM2DWU1vZDQGKgo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f56ilUMS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.195.48 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763151927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EL+ClSt/yLnSMdn9SVOBffB6uZm1orGkxtOjKbnA0Cs=;
	b=BL7lRBQCkC9+Qqq4bsuljEz/4yBpcL3qFNJNlJM5JGojOErNxcx7dV+5PGD4Ya9jVsc6pm
	N5CHVUhsQ4yJWTBv131dbi8EmaIL/8gRXab959zym7kMfhQF6JxeKZ8v/xTvAuWZeow0lo
	C5c6kIs7Ceh7qMyR6JNS9shmL7vC9Y0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ero7oA4QaFGgUpRaNs0GR44kG5FO9cM3ulY5Mh8C4zQT1FwaqKqC6Hd1t62zvSNh+63DSxxswTC968rkObUybHC+VLWZsVVHCxkTQqJ+T1hZOzCAuj//JnJgRYP4vNVjykifit+1iGjx8tzVZjLQ11baNM+7GPdHuRhbWxIjd/w+CFYabyX4gGblpmzQk+zMG9PQePRWSjqSNpmsIXzDc9j2NF9wLOqNbJc5pklkZzTtbnXIOgP1pz6sLDPDTvKBuR4Ho7Md5AcysbUmz7IvrIOjc3EdiXGbsW5OFo11wG/IA0sSkNsIJx0yx43wIF0Se6mMYXND2M0Ictly7Q2KwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EL+ClSt/yLnSMdn9SVOBffB6uZm1orGkxtOjKbnA0Cs=;
 b=ftdwu/r25+XGvvY27mcEc2Jq62WlGqCw/a13YQ5qdqSKYOvucb+Z3yoU16xu6GK5Ot7guk53iLbMsYq9kEiBpl0OIe0xr/aiQ43CHEnLWcrd5rOIy7mesIj5nbTJu4SEpgbnxFQEoc3s9c8vikLISjVtEUdV32pGeIFi5qyoJ/+ShVpzgqn4P/Zy4NLF78ySeV3br64OmcwZdV3+HnnHTXMSJMJ7+CpLYVNPUOtGSqf3+P1R3rtHQBClOSArjI+7fTjIAjf/M7YRVo9DquCB4kS7Ys7l4Jj6yqancj02NBDk87OwVTWP0NiJDMnX8GC2nk0PRsxJdVlBWSpmzbXkyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EL+ClSt/yLnSMdn9SVOBffB6uZm1orGkxtOjKbnA0Cs=;
 b=f56ilUMS1JpV0ceBqdJpqsbPsJ4aok2lGxNxPVU0IB2hzx4YyNh04vW+LejUXlsTrj/J7TfmGMOtdkGGUDSDS+hvqtc70ZMXHzCl9+eIJMORIF9TKrlNiSZP7c6WXsh/IBokfEYTHnv5V/QoTilnjLuFjepUMVqdZb+LwhYbEWP6ExP6T3a675QDwuIJOWEE2BqJ0Z5Mr0+z8AApEXp21xas80o4bS2haqLJqQM3BPMDzEwHzoSBTheUXWaKamsLAoJTJShhsimm5E6gIaGVG3PBFaS2ENFr0UJuLoAq9P3nuUSU/GZFXLRW+4HddFT3VIKzWxyEyIjHefike5EGaA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CH3PR12MB9249.namprd12.prod.outlook.com (2603:10b6:610:1bc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.17; Fri, 14 Nov 2025 20:25:24 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::d622:b3e9:bfe1:26bb]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::d622:b3e9:bfe1:26bb%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 20:25:23 +0000
Message-ID: <6869aee5-0093-489d-bac7-fa718bdcb362@nvidia.com>
Date: Fri, 14 Nov 2025 12:24:51 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
To: peng8420.li@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: david@redhat.com, osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251114161127.193707-1-peng8420.li@gmail.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20251114161127.193707-1-peng8420.li@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::30) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CH3PR12MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: 849948a8-9d5b-4a57-cbb3-08de23bbf086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXdCUi90MTZwUmtPSitJbUtOQWtCOTJISGhLYkIzQ2xLY1dKSk92S1ZPc1Ft?=
 =?utf-8?B?WS95dTYzQzVESzFDNzRXbHZNS1FYTlMzWjJzSXRDWEVrRnRyUDNmK3VjeG53?=
 =?utf-8?B?Z0ZtenM5VTlFSkJVdXczTWhCVFFVamxZWFR2UlRFMGJLU1lVVHk1bmpiTjdv?=
 =?utf-8?B?MmVPaUp2cm1uOSt2VEw3bXk1bXl1d0RGWmNyRm5CUG9ZVWgyaStMeG02TGtT?=
 =?utf-8?B?S2NsandjdjZWc3VDVE1LT1VyWjQ2aWcvN1ZKZXNDOHphZFhxLzZVNWRMRW4v?=
 =?utf-8?B?Ty9TOVNIakRZbm1FWWtrcEJlVHI2U0dySFQydHlNU25OYkJ2amdiYmhuR0tB?=
 =?utf-8?B?YVF0NURiMG1rSUtCaWNiMzg2SWFIU2hub21qTUEyQ0E5NzJIeEZMK0ZvOGZQ?=
 =?utf-8?B?U3ZzTEpKOTUydmg2eWRqdXVwVzM2Nml3MWpzL0lQRkxRWG1xVzMxaSswMzR0?=
 =?utf-8?B?U3hDR2diTUJuRjQxaytxNm05UmRZUWdpQk9WaVA3ZmlCeWQ2R240WldNTHdN?=
 =?utf-8?B?VlpsT2dNZUFGdmJJV3FvejJxWWJtR0xhVFI5SHBUblRyN28veGsxZ2JwTEVh?=
 =?utf-8?B?d24vMmlCQ0xsZ01NUlZHc0o2bXBpN09YU25mejNSMVJJdzN5bEN3NEZLbUg3?=
 =?utf-8?B?clVkR1pRZ1BZU2E1U2xpalluZjMxNDRDTDdNR202Nys0b294MjVtdERqMFNw?=
 =?utf-8?B?cWUwbjVwcVhxbFk4Vk5FOVlGc0JtYTlER1JSZitUNEppcVZ1VG1qaFRGRjl0?=
 =?utf-8?B?RndkeElmeUtQWFRGOElJWlF2YkVPVlBNSUhwL1pJbWhmeVpyMU42TldWTmtS?=
 =?utf-8?B?OXp0cGQvYS9BMmN4SnVPZ0Zxcy81Sm5Ra0dyV2ViWmthR1pnKzJPTWNyY3hx?=
 =?utf-8?B?NG5RaVBHSWQxbWpKei9vMVZEeWM0ZE9FaTNzMzBHanFzR1RLT25vK1lqeEJN?=
 =?utf-8?B?ZHZsSGwrcE85OFJycHNpK1JHQVZQRXBoKzdRWDRVc2hid3hydG42MUFhWGNl?=
 =?utf-8?B?ME9vT3FNYWtGWjNweU1vQkxPODF6S3F6MFJJbkluRVRLYWZDSjlTdTFGQVlN?=
 =?utf-8?B?R0NnOFVCS00xT0VURGszNmpUcEhlVk0rZG9ZaTczLzc0elVkRGRncTZXNm9h?=
 =?utf-8?B?L0YwcGRjaVJjd2JUSWp0QWlzbEZCVVd5R3FzMStra0dmVXZQOU1xN0wxaU54?=
 =?utf-8?B?b2M1ZVlTcTEzbyszMTZBdDVBUUROUmdoV0Ruby9KL1U5STNWSTFXVk5mNUJi?=
 =?utf-8?B?UHp4aHlmQUVTOVJNZGk3eGxVNEMxQy91eVpYT2NqMzVRQVh6azU5QVp6TWJK?=
 =?utf-8?B?NVNYTmdFa0lPNWpFVjJ4Vy9UV1A2ais2ZGFtV2FKeEQwSm16Z2VCWktpU0JS?=
 =?utf-8?B?aktCTkFIVno2aW1ya1FacUdHejNBTWVTM1JvWkw5V1p3Q041dGJLSVl6NUlK?=
 =?utf-8?B?MTdkcVRKdlFCVXFTcEY0bTJlVk5YTjdYOHR6OFNBZ1RCNU0zKzZOdTV2T3Rk?=
 =?utf-8?B?QkJTdFFMUnhEQXZVYmlFN1ROUmszWEpxVDdUdk5VOXBOMTBBSHgvbkIxUWpt?=
 =?utf-8?B?U2ZjLzRySFMyQlFiRG0xNGpGWTFnU3BLTXhQSGhyM0tGZC9pbEZmOGdPSTRT?=
 =?utf-8?B?RVhtb2ZhZzVXb2l1endhUElPMFNpSTNSMTNLMTlDVlF6dWlldDczdkVjQmFN?=
 =?utf-8?B?cCtNQ0IrdHkvQmpMSVJFK0FXTUZaaXRHL3p3ZGhncVhKYjRCb0dCQjFnS1Bz?=
 =?utf-8?B?ZDNZVzRLYVJJbElrb0taNEZkR2JJbmxMK2M4QTQrT3BNNk1wcnhCb2dHWVRj?=
 =?utf-8?B?M3RjdmtFMVdXUFo3Tlp4WVFxVGt1Y0tyWnV0bElOVDZycjRYVnVwR1FyNWFQ?=
 =?utf-8?B?akY0WnpobmhjeW0weUxLeEFZOEVuaFFuYXQ1d2lTb2JpY2dIZHNXdDNTeENP?=
 =?utf-8?B?WmNZdVhLbldyQ2tFWnNMSWpCblphclBSSndGV014cVNUalRwR2Q1aTZFMjc0?=
 =?utf-8?B?ckJjdTkyWmFnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0ZSMjE1RWtyVnliTFVUTHV3VFpPY2psRDJwaEwrN0xUME1xS1Q0RWpwYS9I?=
 =?utf-8?B?cHdTUTVHU2RrRElsOTdSalNMK0g5SDEwVHFHRU5JQUVFYkxEdDREajNvRys0?=
 =?utf-8?B?dlMrdktiT0N3R0ZxNDVRT01KRS9UUk1QeURoYXZ4YU5kL0tTS3hvaWkvLzhB?=
 =?utf-8?B?eUxVaGtzNWRxczdON1RGWjVBUG5SMFNzRy9WTlhpSnFvZ1EzZnEveDZYY0xD?=
 =?utf-8?B?THNCbXQvN3JDQ1U2Zzd4Si9FREZaU2Z0MFNsaGhZU0EzZFl0OE9Md3BCSW9x?=
 =?utf-8?B?WUlhNG9RN2FJcTZGb01LbEd3ekV0LzlCWjczdUt1UmFnb0FPcmxjb09McUpp?=
 =?utf-8?B?T3FQU0NkRExhMEdQNDFOVHBMazhLR2hqVkluaEU2RG00TjFWODcyUDZETHBi?=
 =?utf-8?B?UnJPMzk3VTkzalNMTUR6dVd5QVNQWWthOXI5YVlpTlAzOVNyOWorWER1bmZu?=
 =?utf-8?B?eDFqNkc0dGxSMitzcUxsbU1KU0EwaHkxZEpSbmxxejVwZ0hlZk1TdUxxbzFv?=
 =?utf-8?B?U2RxcFk1SFg1cC9MRWIrRW1vNTdFandsaWZJdmdBZzlmOG83SC9vWHFaajFO?=
 =?utf-8?B?SFVvYlVDV1pQcGk2eXd0ckMyc1pHT3dueUdGamM4T2lyTG9VNGx2MzlWcjdZ?=
 =?utf-8?B?ZTkwY28rUllibDZpay8vVllhMTlrSHVDcEdGOE9JL1FmdEpnNlI3Wmw4RkNm?=
 =?utf-8?B?bHpUYWpFK3NySFFndm84VWdZU05jSUFIVE1Uc01uT2hGNm54MGhSdnpBT09o?=
 =?utf-8?B?Z1doTjhwNFA5amtKOGR2emhvVitvV2lLMS9iNTNia0dnUytqTUpQai9tL2pB?=
 =?utf-8?B?WUVjY2s5WDY1ZHUwTmxxSVFQTWhPMWdGTlFxbGFQSE5sekc3Ri9KZzUzbE5Z?=
 =?utf-8?B?SUpLcGc2emY2UXRHdU5hWE1oaXpPUHZGaEZjWjdYY3UwZnphRTFoRDZlYmFF?=
 =?utf-8?B?TTIvcHgvbllHaHM3TFNJaDZhTjBoVGV3Y1lZWDZoZlZDYTdKUjQ1VE9BKzAr?=
 =?utf-8?B?V01sZkpDK1JIMnhqVHZVbDRYMFNYbW9LcWNWT3haVExRN29aQVdYRkYyMmk4?=
 =?utf-8?B?NGllY0VWeldXemZZK1JWV01Bc3hmc2xGcHp4RXVKVjlDaWd5RmVnOG51dUdh?=
 =?utf-8?B?RTd5ZnViWE92SEgyZ2ROclVwTTNZZ1RXQnQ2VkI4OXArTEZlSTZNd3gyMnNO?=
 =?utf-8?B?TGZwN0JEdGZQbjJrWUFRM1lLYXJrWFdlbDF1VVhDTFdEUmZ0emxodU91WnJr?=
 =?utf-8?B?blh1RUI2Ym55blI2SGxNd1lDR0pQRFRRVFdKQmJCaDREUFJ0bkJVZk5QbG9E?=
 =?utf-8?B?Y20yeGNrdHpub1JqTUdYUVE0R25YbnZJWUlEWWhUZWZ3MDhkTU1GZGJLM09V?=
 =?utf-8?B?UVZhdCtkMC82bFE5b3E3bC9XUUFNSUd0Y0gxc0RlRTY0RE1yYkNrMDhMcE9J?=
 =?utf-8?B?bkhUYlp0RzdXZXd0aTA3RUZjQ0dxaTdyUGhseU54dVBhenRNU05JRU5Ud0Y4?=
 =?utf-8?B?YmYwYW41NnRjK0RNOW9iVm54SDJzd3JaQWhiZEliWUx5YjUzSVE3bkVPQlRz?=
 =?utf-8?B?aGlZMzlvZitPbVZtMC9DUGVtdDV5WEJVdjYzYnpvSEpBRmx0Sk4wUWdHK0N2?=
 =?utf-8?B?cC8xNjhja1JWcmRLcUJmYm5iUXdsUFlaOXNXbFZJdGkvbEEyVmRlN3FsTGFu?=
 =?utf-8?B?WHFUV09RaEM0ZzNhQkxLSTdtWGlTMjFXYkRJemVLeEk3UVgyUC92TE40bGxW?=
 =?utf-8?B?SnhTSU5IKzdURnl1dWhuNWNZY1hHcU93NU54L3o4bTZHWUlwMUppb01kK054?=
 =?utf-8?B?bklYNTlSMXRyOTZoeXV3bjg5WDU2K292amtmc2p3SFpQWWl5OGNzL0s1a0M3?=
 =?utf-8?B?RC9sU3djZFFDeDZpMTVNb0xFQUR5WnpzZ3NtMk5PRVorek1hT3BONHZZS2VG?=
 =?utf-8?B?S2k0c1AxSFA5RHVOMmFldW1CNTB0cTNCSzkzL1lqNzMySUZHTFZDK3E4WDQ2?=
 =?utf-8?B?WWlNcW92UzExUWMxY1dORHBFL1Vleld3TXVKQXVTcUpDMWdKNERWNldsS1JG?=
 =?utf-8?B?RTdvZlZaVXlRRFM1c0lhQ0NuNVZWa3FVTkpZWGZic3c4L0J6VXFXOFYrbFlL?=
 =?utf-8?Q?kX8HGpoOGEAS/CSZ0GMP0MnXu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849948a8-9d5b-4a57-cbb3-08de23bbf086
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 20:25:23.6368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkJmUk3ot0Z6Vku3qzi8F8wwD/OVy9RRKmlSlBPUR5Hr/ItLTNuAYRlP0D3OJ0bIuYh3gukvzRzZdlGeEzhetg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9249
X-Rspamd-Queue-Id: A6193120005
X-Rspamd-Server: rspam07
X-Stat-Signature: ro3s3ac8zsjfdzb4jo1c5unnqxk738py
X-Rspam-User: 
X-HE-Tag: 1763151927-389255
X-HE-Meta: U2FsdGVkX197n4Thec1ygV0ChuPgnNumOT5zz1syUXId1U1dhWY1D7OLALmNEt9tNS98bQk7EG+1Tk0YegAHRwjOFhaI7/INkXyEOEZ/cyWDJ4JdmO+9KydAKIue2k65FgVSaxC4145dDKkMA2fken61tR/lWAInqAfbQXcE8pvDSzpWKY6H5t3REY0/LJ6iO5wJf0HKxSfAXouTG4c0pi+lAFY8vdFNd40Yo1YOLv+4cCX/Oci9taFbAJCFLKffy+B/FChSdO1/9txz2aq9RwtyhQYHDKNvoIeQtcANXBxwa4l0bgjsvudnozAVhzsKkMUET3q+SFYCB9CPmQml5VZ7F3z3f/pIYCOMLRPA0bZMnlq3M2i9AOTVXBfSGuNQnork6xVpMFfThWLnJsLSWmR6H6703AX+x25VRos9nlLjR1FmA+ONKch4mgd8BAf4sFbQvCc5VhMaBIqoxYyzUbgFTzFKqbmDhkoZ1B/TMq9Y3VSDh9qQA7KpBmfwv2eg4uqoH6O3M5CFSZz1gizDIejMuTCNF6zeoQy9B02Yn6bAuqg/XHM5STC2P/hnTK8WWoSaYgXm6dJecblHb+NUIzVPRPBAM/IFhFCyDoZsWMzaDzjIciLHttKt6PrBW/LAwwY3GTwgmmHItBCVkW9oeDMpoIktsOTRjxRjqM5ZZeiLu//SlySkVvZg4yS6zQ7fSzUrYarx+6ab40adXeeSuFAUTB3rego5osIVlIOKXjQTKwIeA6jPR8BNUnQF2SzBGOZuvtTPrS3FjtYUPIf8Wz4vtplxcEjUkWPLgm9e9eWJXbzUzR+ePjMDfc1Lgip1OX9POrCHYXdjAI2cpFBZL7MlAfWnEE67MaVZNtBYK7s+fKtI+N8iii/yUN+kWkFz8yDNPJqa6EWOpGjUBUYbmz2gOe6AjgDtJcyjjcHLcwhJEWrxhURMf+oEcZte1OxouTdIcRo4g3biHTQ11z9
 +z6n47wa
 gh0e8ge5byCeQuZ3EP/CHdpSlLRcTv6WTJtLAaP3o8CvQ+m95mDIT/ZhF8aSBqQKHmg7UTkf9FYYEL3WYxdXsX/0uNuoLnqqfIRnWt+Kdmf19hpkKeWG50bqc914oqjvLLa/FXY8YSmJf+fGkC9miyobLcwVzKGGSyCqtDWizr4PSDJj5wfYHH8YAaJoFSCHeAL6GLTHlz6V10FCkKfzwcKQ4ybB6BYre4IXQs1Uxhy2Ag4gocN4yer5q8kAHtBFA2FNxkhOTZFAgo8NLE17huAIG7KLkUeeigP+4jtpMkv8ftjyB1yEVEVOm6TIvIeUXE24+A6FnIpn8pUOrVAc/WiqXhSAvD4YaDNy6uxOWdlcp/vG9tcMTxDXoTc/P1EaTe6+r9GB6X+fHtt4g2yQ/znq8kebw3AkoZNQS0s6vZVEJVNHOgvGpoHH3RhlRxcNw5/DYgxUotq2zHMsqPjMH7C5lgCg/QHGR8LFM8G4QljuRzE+a9JdIFxmEhgWn+qPJJhGeDSzRAY/LGNoH+lUM2aHNwDdn61E1ue1QdxpMO6q4XHZsrlb2ESglEH7pekraiHZ/iBIPC0Az8DkDB1ef7uipdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The diffs look good, but the commit log and your replies have many minor
issues that add up. So you'll want to avoid them in the future, and with
that in mind, I've listed all of them, along with suggested alternatives.

On 11/14/25 8:11 AM, peng8420.li@gmail.com wrote:
> From: "peng8420.li" <peng8420.li@gmail.com>
 
This should be your real name, such as (my first guess)
"Peng Li" <peng8420.li@gmail.com>.

Also, if you are sending from the same email address as your "From:",
then the "From:" item shouldn't normally show up (it's harmless here,
but could be cleaner without it). Check your .gitconfig send-email
options and you can make it go away.

Also, when replying, your email client is apparently using HTML, please
fix it to use text only!

Please read the patch submitter guidelines, too:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submit-checklist.rst

> Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
> internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a GUP-internal flag.

Not "ever since", but simply:

commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.

Also, it's best to keep the line length within about 72 columns for
commit messages.

> 
> Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;

Trailing semicolon. Should be a period.

> 
> Otherwise, executing the test command "./gup_test -L -r 100 -z" will report the following warning log:
> TAP version 13
> 1..1
> ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
> get:2818 put:46 [   39.364043] Modules linked in:
> us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test Not tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
> (size: 0)#
> [   39.364434] Hardware name: riscv-virtio,qemu (DT)
> [   39.364546] epc : is_valid_gup_args+0x66/0x8c
> [   39.364596]  ra : pin_user_pages+0x38/0x78
> [   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff2000000041bd20
> [   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 : ff2000000041bdf8
> [   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 : ff2000000041bd30
> [   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 : 0000000000000000
> [   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 : 0000000000000001
> [   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 : 0000000000000000
> [   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 : 00007fff7eeee000
> [   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 : 00007fff7eeed000
> [   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10: 0000000000000002
> [   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 : 00000000001fffff
> [   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
> [   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6 cause: 0000000000000003
> [   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
> [   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
> [   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
> [   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
> [   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
> [   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
> [   39.365220] ---[ end trace 0000000000000000 ]---
> 

We don't need all of this output for such a simple case. Just the
warning will suffice, and even that is optional for this patch.


> Signed-off-by: peng8420.li <peng8420.li@gmail.com>

Same rules for the Signed-off-by: real name needed here.

Combining all of that, your commit message would look like this:


From: "Peng Li" <peng8420.li@gmail.com>

commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.

This causes a warning to fire when running gup_test, for example:

    $ ./gup_test -L -r 100 -z

dmesg:
    WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c

Therefore, remove the "FOLL_TOUCH" test code from gup_test.c.

Signed-off-by: Peng Li <peng8420.li@gmail.com>

With the commit log fixed up, please feel free to add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard

> ---
>  tools/testing/selftests/mm/gup_test.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
> index 8900b840c17a..75f7134d529d 100644
> --- a/tools/testing/selftests/mm/gup_test.c
> +++ b/tools/testing/selftests/mm/gup_test.c
> @@ -19,7 +19,6 @@
>  
>  /* Just the flags we need, copied from mm.h: */
>  #define FOLL_WRITE	0x01	/* check pte is writable */
> -#define FOLL_TOUCH	0x02	/* mark page accessed */
>  
>  #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
>  
> @@ -93,7 +92,7 @@ int main(int argc, char **argv)
>  {
>  	struct gup_test gup = { 0 };
>  	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
> -	int flags = MAP_PRIVATE, touch = 0;
> +	int flags = MAP_PRIVATE;
>  	char *file = "/dev/zero";
>  	pthread_t *tid;
>  	char *p;
> @@ -170,10 +169,6 @@ int main(int argc, char **argv)
>  		case 'H':
>  			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
>  			break;
> -		case 'z':
> -			/* fault pages in gup, do not fault in userland */
> -			touch = 1;
> -			break;
>  		default:
>  			ksft_exit_fail_msg("Wrong argument\n");
>  		}
> @@ -244,18 +239,9 @@ int main(int argc, char **argv)
>  	else if (thp == 0)
>  		madvise(p, size, MADV_NOHUGEPAGE);
>  
> -	/*
> -	 * FOLL_TOUCH, in gup_test, is used as an either/or case: either
> -	 * fault pages in from the kernel via FOLL_TOUCH, or fault them
> -	 * in here, from user space. This allows comparison of performance
> -	 * between those two cases.
> -	 */
> -	if (touch) {
> -		gup.gup_flags |= FOLL_TOUCH;
> -	} else {
> -		for (; (unsigned long)p < gup.addr + size; p += psize())
> -			p[0] = 0;
> -	}
> +	/* Fault them in here, from user space. */
> +	for (; (unsigned long)p < gup.addr + size; p += psize())
> +		p[0] = 0;
>  
>  	tid = malloc(sizeof(pthread_t) * nthreads);
>  	assert(tid);



