Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 058E6E7E371
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FAC96B0005; Fri,  3 Apr 2026 07:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2996B0089; Fri,  3 Apr 2026 07:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8906B0092; Fri,  3 Apr 2026 07:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FFFC6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:11:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B16491B865A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:11:26 +0000 (UTC)
X-FDA: 84616978572.03.ECA92E3
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012015.outbound.protection.outlook.com [52.101.43.15])
	by imf01.hostedemail.com (Postfix) with ESMTP id F41504000D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:11:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZtrLKAWU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.15 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775214684; a=rsa-sha256;
	cv=pass;
	b=gWha6gN4MOI0DbUdR15Kab9/9EuG3ZBgrgp+gLzNjXIvBJs7GBsbzvdqbv93HQvvoph+IE
	3L28tBBPFco4TWNiLZosQEe0Sdo15dUkxzgJ4ZweajS6UDBMCI9iizXop45j2ZcDVSFXI8
	M0s1wPHBJ2OLYwM3cdS8gBKcMRMCJWs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775214684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JEH+XlZhHXB1jNVJ9FAa/WSVWOqoPRdt0NfUj09v5M=;
	b=78Rot5Qz4YmUl5JxpdfSaAQHjnCEtpVpvoqMpMVITE4Xm3GcMKwrvBa7vt2W2iJavvf8Mo
	MUSCjcxgFiL9ttNRiIJsAv8+pF1TjyRtzlYf8/AN6v0hl5wNX3eWHJA2+TDHTiqLDHV2yC
	2ZZMuO1azMKwO4sUejixzgfYciHz87g=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZtrLKAWU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.15 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qyrOrwhyDLQ+4RjSQf2jp0GNixjezRW3vmgn4+itvFPJ/EdpdEb60xoAWpOFXT4ohXD8ZVl7nAnSyQngMAazv7Tu1Ygia1Dyh0znhYAAUz1ydvNdvNRf3GR9wJyJ15XddzF/jcSXs6l5ZSM0tghVml+UQloqYt0mxUGuqfWKW3nVkrpcB0gXi2znbXz4T/wh0/vmS1fh3+q51vittfQCMIT9TY3iQg59UblH8DludptVzDJ8mFubT0FYluzvXY5PeKTBeMNOzQV65Gq7BHTQFqJzp+GsHRNX9BOpGUn5DMssKQa1FdC5Hp6R0T8+tT4mDIFYRWLcgMq64kxYwck9nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JEH+XlZhHXB1jNVJ9FAa/WSVWOqoPRdt0NfUj09v5M=;
 b=VOqNfw0tmr33YxVYRcdH5yiGoZFvmJJ0YuNbu84TQkkXAogelwj3HELZviUR4u7ACjLI8UjQA2fkbYh9pDqF2KCK/796eKwoPmC7mizAtbCOIir2JOiiRbSwiBlE9nXRoxAc0wAk3V9A74F2GA7oaa1fZ7efJlUJyONXrXnooTCI45MHJNojgnvnLZhwMlsRkpe2CsAMYAM6NWU9GX98mCAUazwW6PDqWRg6yFEEd1R8tORQ2eLZNsv4rHM8boZCo2BYC2FJn1xQeqKgvinFrduN9TWMgR/iqTjQwB4uWl0aLYhoIB++JqxERPeCqJnCJUCM6FpbMY2XVBJ7ULzfIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JEH+XlZhHXB1jNVJ9FAa/WSVWOqoPRdt0NfUj09v5M=;
 b=ZtrLKAWUR6Q/kYVyQKZXWb1MUWEpuXNZJQpjTkd9Yi3hJutx9x+9W4yaUHw1psZOpUQozfRZ32NO1f8sVwefisfMorKy50+018BSi3SeN7dkao+mA/2nUrzRHB8LU7ghtEQzDYlTtHCQgJ3xXn8K7TvkTvlBRvvfs9UZV1YA0DE=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Fri, 3 Apr
 2026 11:11:18 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 11:11:18 +0000
Message-ID: <70414c31-d928-41a6-89db-eeb0f34ec07d@amd.com>
Date: Fri, 3 Apr 2026 16:41:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Day <michael.day@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-12-shivankg@amd.com> <87o6kdzeei.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87o6kdzeei.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0002.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::17) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: b2ca6d2a-503e-4b3e-b1ad-08de9171bab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	S3Nq51dgzGsIOLUMh+mXKYmH077XuzIzy2C+QL9B2Uz+aqoUxpwiD2pulT2vRs9nYpJD7At3tSf03KUXbnej8E/FLwacIk0diW3Z8ZoVLgkIOhmZuDqnWoGN9Rk4gttnAjcnsiWZcUfH/2uFgH/mlEL/u/5VGoFqUiWPSH1hwhIxfzw+idJMucY/LYF/vkoFWi+jJ3can+IREwxjMePAagkf346/P+n08nt5AseqQbn+f7rAOKHmrb5NXUMP7XHdMn3pmFyIfBaFEGPnsSKqkFvNe5wMzLYzaJpM0DuEQQBdFtsojJX7BxWaxdpfyZ4fe/GLOE/OVgyq+FuSjChUJ7t7JC7q87rSkjMFKsNEorHpI+KM0NMehzl3vaMWu2heLBYCDr3chKedkcyqv9QMQljWgZ80pRdXUgbiCSXP/JToLIEA2f97ZsEjKOVZTMKjiXAhuDYyAet4uELLYq3/ot8BeYcH7ZiNWSO0YQCjKsh5N4YloAgU+Ua7yGEhl8vB6oNCokCz0RHLLaTu90LtOfAcbqzdnCLWj7FCuvoiKjjXPP8nQTHHRa0EQpmXQy6Mkxy0rq/461v2pUSW8Y6vEacuTjMsPCOo4EGoOrpTZdZzOsQigTST3isP5fy4UggYNdE6N9TCJpqogzJSH/m5fxBAOgGSr8UHSDNPNjG3eo/GNEJ2dNJl45gMiK3R8La+vG7C/YXi8uijNgLC8PqEiAq8pKcmFtV2zuGodNQ7HIw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW9uVldmdnYwTU42SkxHYlNUWm8yVTlndFpVSjYwVjY3Tzl2YjFmMDZZREJN?=
 =?utf-8?B?Z1ZDUEZ2LzBSNjJMYWFvTmNucmlKcExISFhmUEFieSt2NWNUZ2NsL21NZnNy?=
 =?utf-8?B?S050Sk1kSmNJM29QS2xvR0ZrVndrRWs0UzJFWlk2SDVlL294MEhWWFFwNXhC?=
 =?utf-8?B?NzgwWkRkRzN0V25FSkRuZldkZHQ5VDdVdVZyRGZjUzhaeVBVK2c0WHlCeDZ4?=
 =?utf-8?B?eEtpNmN0OFI3SGhQQm4wVGxSYzlIL3NNZUk3OW5raDlvaElKWmp6R0NSZmNF?=
 =?utf-8?B?MDZwZHBweTFlT3pVblh6cTRLNThVSW91ZHBmaGtyV1RkREI3eE5WdFk1N1R1?=
 =?utf-8?B?ZVRJNjgzMnp1QXMxUVp1UVpNSTJuejlJWnU3RXpBUmpHQzBtMGEycWJVN01I?=
 =?utf-8?B?Z0N4TVEvL2pqOXp4K05hYU9KdkIrQ2RXU3V3aFRWVGdVYkxCZnFJK2k5Sk1u?=
 =?utf-8?B?SDFTRDgyTDJsV0pSRUlQaGc1ZzNNV09sejd1U2hqZkdzNW5ZaWpoZ1hWUlpR?=
 =?utf-8?B?Mlk4WmY4TzlJQktSWmcvOUt1dmpRb0UxM1FLQmw2L0ZaQVdsWlNaWlNFME5l?=
 =?utf-8?B?YkJ1RFZveUJhWEFzb2dKcXRMRmNHR1RWb3lZM2F3YkxnNlNPVWFySzN5V1BY?=
 =?utf-8?B?Yk1XbXcwVVZVWnZVOGN0V2txaHpPSGJqTm9qM3lERm5TN0NkcVhrL3FpMmN4?=
 =?utf-8?B?RUhLRytETW1yQjNENzcxM0MvZ1ZhQlB2K3phRTY2clFrN2I5bEdsRmNpQ3BS?=
 =?utf-8?B?N0cvU0ZWaEt3RXBpa25KNFBITXl0OC9BelVGcDJNZUpWQ3BCb0JrdGVEUFpJ?=
 =?utf-8?B?Q2NsajNlWldPRDBiYWRUSUZVNDNhTXd6ZFF5MkVUMldMT2Z2MnVpQnFqcnk1?=
 =?utf-8?B?S0VpQjBtUEM4T1Z3cXJFYkNONUtGZEplc0Z2empTbzdQNGR0bTI2SmNObFN4?=
 =?utf-8?B?WkZLQ0pvWjg2R1I0Q3h0NStPOHRxRjNjZnNJS0loZHJ4dWVEbjcwRG5Zcldh?=
 =?utf-8?B?aGlIdy8yTmZ2K3dvR295cy9Hcnk1a0xLYW94NFRBazA3NXhlVWVxc0lMM0dN?=
 =?utf-8?B?bjdZNEZzdHUxOEc2Nnh2Z1l1OTBCaVNobThEU2ltQlhVZTc3a0dhRHQyUnhZ?=
 =?utf-8?B?WDJ5bzRMbDZlMzlERkhtWWdXMVU4MGkwVkpVRVFQS3ZSdGdQNWVMMTJVWlJa?=
 =?utf-8?B?TXVsNVB6ZURDYzV3dUZuZGlsQjBtS0xOa3hoY1d2RTRVbm52dlFYOVg3TlRB?=
 =?utf-8?B?ZkY2ci9vclVNcHpSZzE0SDYyNWthaWJRa05jTjdjSllmN1pEbnNINjkxVkJX?=
 =?utf-8?B?MHhub2lMQzM1WlBEU2NjYkNaaWZsMDlqanAvc3BlZ3h4UmNSQUFRa1BoLzk5?=
 =?utf-8?B?UjEyZmRzYjNHNVlpQ0gwb04rMlFKdi9ZZ0JGOEc2cG9IVkpmM0JRYVIyTDN2?=
 =?utf-8?B?YTRLUTJwWk9sLzBGa2s0eUswbUVWanhhazFiMzNzOGRSdmhrcytFcUFQVnpN?=
 =?utf-8?B?dEt1SnpnVitFcVNYaS9sYkRjVzFQNmFCUS90SlR5dEc2djI0UFRUNExLOVFV?=
 =?utf-8?B?SkRad2VKZHdEMW5JL3E0M3duZ1pGV254eTc0N0ZHcysvaGJSMWlUSG9QWk5X?=
 =?utf-8?B?cWxPQjFkMmtESDRnS3RtWTZ3TDkvOERCMXBicGxudmxZcXozSUFlb1RHMTRo?=
 =?utf-8?B?RmVNWjVibkFONDY3UGRyZy9reU1ZYnRzYjhBTy81eXVUbVhtREpxTGJFWDE3?=
 =?utf-8?B?SitxY083Z3Z0a0N1QzBYcFpsQVp2a2R1RFh4aHNoa2VyQW1KMVgzMFZ2WEJT?=
 =?utf-8?B?cDBXb0RONnVWYy9jM3I5Q0RkMTg4WWFZS2lGTkZWMEdoTWpLQmtkWFJxczht?=
 =?utf-8?B?Ty9VeXVrbWV5cHpEYWdzcjc1UmFCR1dkOW9CbDUxRngrQ3R0b3cxa3ovS0pv?=
 =?utf-8?B?VkhpNVNIVmQ4Qmp6YmxxVmxpZjBUT3BxSTFnU3cvcnVFSHBISm50RUJBTlJV?=
 =?utf-8?B?TFJmejZ3VjdGbk1lRER1OWZnVEp3OEw0S3lTc3AwRHZ6L2psYkxpR2cvVjN0?=
 =?utf-8?B?eG1hZDJ6RmRkSHpuNjE1NjU2Yndoc0NlbzRtU20vTEdvdEpwVGFoT1dvZWxh?=
 =?utf-8?B?alJNUTV0SnFkV3lydWtqeTdxa1JKOVlXODg5cDJVdjZUNEFUaWEvcEZNVTl0?=
 =?utf-8?B?K083dlZZWTNBOXdlSW4yejRPdGNFRDFmOTdnR3pCYWhBT2EzZjNvTFAwa3Y0?=
 =?utf-8?B?ajJneDBKMjVtTnB5QjRFWDV3NThGbGxQbXpqK2ZiV1Btclp1d3gvRW5URElW?=
 =?utf-8?B?UHJPcGpUMEpnNmxFbHliUVJKREV3eGpxeHlnNytLUVZOR2pqZENwZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ca6d2a-503e-4b3e-b1ad-08de9171bab1
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 11:11:18.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNeEv5db2gh+yF+LQzHlvG/vHlBH/LTC9x6ODunzZWCVUIn7ZJkpUDma+zhA8unjJmpaKqmGwnk8KSc2Z85UEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F41504000D
X-Stat-Signature: pxckgraouexnwgs6jwtqd6qrneyuqrqf
X-HE-Tag: 1775214683-305377
X-HE-Meta: U2FsdGVkX1/qiRWwHmo8I95O3t1zgpXers0hgK+F4GI50ZSA5iQTWXNsbgseo6u7IGSGBjpmhduDqbOzFKW2tpV4pOh/5JHYZUAoSp36lxWsukxn9LoA/catlhfcVYF1/gJ2qtaGFgyGWAhEMQaryVDrTBh3fTDamcL08cNxiFiWQUQtCcOexr5PEubXRqseGxgNdW/mLruNgT+qEGdHDdWSvkmg7dvY6Qx35Ts1ckZXBPsiFOkwzJdcho2mtNh0NlJq6/jo5SFN+MnVaL03L7mUodPONQcn+y9J+5UXED/kYlOO8/+ixfSN8DBK8CQnPpvIwo1yO7DASn0LVnOG8och3mX4PCENML3s7MoqGH2p7j2CO/HR9flT+P8LaPjtCIL9x8pvGWWOK9cxG/lCvc5yRh9vfw2b3UjONbr7ZeKUhVA+UYoP5JTI3uyR1mOsPhLjFtCAqXpe3aAdJ+Wnoc3JtV3nJGQDI6NOMMQlsirvKZ9SlQoRwk4ChDrilI+3h7MEUd2sdE4Oaf26PHVe4nGF/o9NfQPO8qtvl+VM2wWIllrsPjTN+Xd0lJwLsBDGjJWegp8CqJ4mCevbhwGYy7uZNh7McEMuP/0ux9wldlUAaYuR6zApj/Jmu0V4Jv9KaMEeaJcRkDHxcdvp8lyDPo/7ILY+MO7lCsogDqx7mmT/Z+JfEhNvz6pxsuwP/2nnRYoZuwE2NCVaRCpqHGaOWdy2ShEcVtjE9FSxQnz71F87UPYDQGBSAEprM91GvFNdnCNlKatbw1vBdLXLXyupNh/0iPvaErqYK43Jp1FhTa/bFHSDup+Hu5QDKsgDgZft6hlF3IiFv5SFL+bBnWzGWZVSfVkF71oxjxYVwgPIBy2Gl96A2pH3lHItKZtJQkJNzpX6kcBPsweFSmy80ov73MvNgWfCQ1OEkOObe8C5RSkxRUk+Frvl8kvmtzCk6W4zwxOrxQhWQBFLTDkV4S+
 WCnhlUbr
 ROY/WDDF/S4ViAiaoNYkOoA/PjVQ+stJqAulZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 4:24 PM, Huang, Ying wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 
>> Introduce CONFIG_MIGRATION_COPY_OFFLOAD, which lets offload driver
> 
> Do we really need a new kconfig option?  IMHO, we have too many now.
> Because we have a jump label already, the performance difference should
> be trivial.  Can you measure the size difference?

BASELINE (offload=n)
   text    data     bss     dec  filename
  23577    1632      32   25241  mm/migrate.o
39202900        14159750        6502152 59864802     vmlinux

WITH OFFLOAD (offload=y)
   text    data     bss     dec  filename
  24444    2568      32   27044  mm/migrate.o
    676      64       8     748  mm/migrate_copy_offload.o
39208218        14163942        6498120 59870280     vmlinux

WITHOUT CONFIG (always-on)
   text    data     bss     dec  filename
  24444    2568      32   27044  mm/migrate.o
    676      64       8     748  mm/migrate_copy_offload.o
39208405        14163942        6498120 59870467     vmlinux

It saves around 5.5KB of size, when offload support is disabled.
Is it meaningful savings? What do you think?

> 
>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>> +extern struct static_key_false migrate_offload_enabled;
>> +extern struct srcu_struct migrate_offload_srcu;
>> +bool migrate_should_batch_default(int reason);
>> +int migrate_offload_start(struct migrator *m);
>> +int migrate_offload_stop(struct migrator *m);
> 
> Why not naming the function migrate_offload_register/unregister()?
> IMHO, that sounds more natural.

Ack. I'll rename to migrate_offload_register/unregister().

> 
>>  
>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>> +	/* Check if the offload driver wants to batch for this reason */
>> +	if (static_branch_unlikely(&migrate_offload_enabled))
>> +		do_batch = static_call(migrate_should_batch)(reason);
> 
> Should batching based on "reason" be determined by the general migrate
> code instead of the migrator implementation?  For example, if we only
> batch copying for ASYNC migration, we should determine that in
> migrate_pages_batch() instead of the migreation implementation.  Or am I
> missed something?  If so, can you provide an example?
> 

My idea was that different drivers may have different cost/benefit
profiles(e.g. setup cost, migrate batch-size, etc..) 

For instance, a DMA driver may want to target only bulk migration usecase.
And a CPU-thread based driver can be used more broadly, without worrying
about setup-costs.

But I agree it's premature with only one-driver.
I'll move the reason check with target usecases into migrate_pages_batch()
and drop the should_batch() callback. If a future driver needs different
filtering, we can add it back then.

>>  
>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>  	/* Batch-copy eligible folios before the move phase */
>>  	if (!list_empty(&src_batch)) {
> 
> Guard with "static_branch_unlikely(&migrate_offload_enabled)" first?
> Better to define a inline function to shorten the expression.
> 

Sure, will add the static_branch_unlikely guard and wrap in a helper
function. Thanks.

Best regards,
Shivank






