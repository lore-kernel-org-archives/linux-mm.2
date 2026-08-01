Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BEDFC55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 02:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2BE6B007B; Fri, 31 Jul 2026 22:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363436B0088; Fri, 31 Jul 2026 22:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22BC86B008A; Fri, 31 Jul 2026 22:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E93A76B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:17:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 650CD1C039C
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:04 +0000 (UTC)
X-FDA: 85051087968.26.D901E72
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6CB0DA0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oeCXZyv/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785550621;
	b=minDqa3EY8uCNSXk0aNKG3RJnHwEVVWxwH6fb0sjCsMrPccpJDUtEJhrUkKtSmhLdCkCnS
	33DDCCJJtMwm3w+fILiC+PSNwGq34cwpfkpoCCmWfrTY1sQTpV6qxyRPoS8D6+AwBwiK9f
	FAtkKgVTJBrcwIe1RdoL5TtauZX0efo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oeCXZyv/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785550621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILJcL94MpWYtIXWo6a2IwejOPXzRpZ1W3tm6C12OaCY=;
	b=f1eWp4TM31U9GaynETFmcoZ0T5U3aKyJqGQSsDFnCYhxueJTjeV2vpCeXlZ0WTS+SHVHSm
	28Mmc0n3o5NLO0r516ZD3ArsD9+RtUKxpGW8I0qSJj6BJ4VRZZ4L264C3eVIurdfMpqpem
	UrjUSRgD2zH7JsKLMVHBgFFPy8M6RLU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEhlOzbcbTOUpTfs8AdeU+OVksui8YtjloOsPuEViSDiZKvk5OkzXOyxMWTDj/RRXiiEZ+7xEEsIRwvasDZDacTJcYRpawxCLQcIFxmW7KSW/BZTxJfN/lt4kt1x48OB1YpDesqsAEZXoZ+tt+ROq5ypfSpU+O2xW12GUgopM+hmhGlLDfCWU6cMJ9Xh13X5OjX6a/Z94Q5FdblkgeMQfBMPtbvEfrRx15Z4v+YxAL1ZCu/xbQtcKn93dH2noxSt3FZ88Xv5LVEMyHogY/v4bekXdc5YFygnP7FgeIZyfy8zDKHBcBwv6l8DRLE+sGsdYZ5eGCP0v3f3MBx0I8F5nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILJcL94MpWYtIXWo6a2IwejOPXzRpZ1W3tm6C12OaCY=;
 b=ry4S33S36eTJsZd7hW8SSWrjhdok0EKihxcf/BCvsnwXeXubcBkteRAgybiN4aM+peGAJm0sD+L27gcfE/HTwhnXNO2rS60DYdw5Y9lAt044zhOmlbbhCmkFaI0cW72e4GQq7hOiktXvuDER5pQ5VjXQNridkLf/GW4s4uidaonWjSsqcO6UBZLFsWQuuskeyeSx9pgNaryqXdnB7jRnYXDpl4Sq2r+Q1wyWMwfmufDWtghCKPRneRrbQFB/88WaIpSt64SXTgQfSHAW+OUzcNB68NiVMpWBxFMyhBSqaBTCFcC2rMb8/QKtP7g3k5FBYkeM4HkpSCeHb6b9mTNq+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILJcL94MpWYtIXWo6a2IwejOPXzRpZ1W3tm6C12OaCY=;
 b=oeCXZyv/okpb81fiF5Q2CaiGY+UmX63vT0sMWt9wnEl+RXmTVGbD3ByzUCSIv3TnsYWSW2YjwDdjQSehOy5YLiqdzZ6E5YE+GqDR4zGZfFN784HGvydywg1UE6u1jPK7mlBuP2SIr4klbkWwmGjEaNG1oQ5AxUwP2KJVrj1WAPLl6oFzt7AnoU/qkyznXdbAULnjCFfYaucohTogHARnZFfbKrjtNaksg4BIeqby3jITcPSQONOuNcvTN4UaH3zt2Q3bwSuPe9nnjg+yPSmIe1tq9AHFJICW5QIgYYaKzb5+F2ZRKsw40OjzAgfQcm/AMzUXMxcgM1557krG8j1GEg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:16:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:16:55 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:24 -0400
Subject: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: IA1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 08511ff4-c132-4d5b-d159-08deef72f58b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	YIC61CpsDyUDE9V6qJfNb4UhW4uAICncDoT2KAx50mNODyJcEGmmRyqhbbNDtH++R1m0YRRUFdlar7HvrNLHtoYfmNlt4vIgwKAbUcu9VOVD2budSQntElIwA5L5Q2j1ldZI/FZZv7z+cuYRtErN5Nrdj9/TauQA6sdMGw3ydB59nt11oS2B76UDMvMmcUcLUIcdutaDdxjf3FcCrOIZsJjLfLwkai3GZt1kVVwPM7qvZXP47dpeY7YTPtIU7v0lDYLE+H63lZWeUMvzR6X2Dnb0JwNA5m5vFVuwEO24xPJMm9KDrhdnVHKqIizToWjSiyiMmLnGwaZf4hicVy+/kqQTdyxcGv7ZnASMP/Z+2OletC9xogkSc8lGyI/9WRaQz/8rv6xZZmM5sC0UaqzbAD1bZGdodq+nCJ2B2BRPb25DwZeiUrPOBwiGFWf0/jug/O4BF53ATtvF0T9tDfGUzIP4SCYFgTnRJepdCL+JLkNT7VtIiNJHPZf8pWOHEnTM3aBqk6ES0EBLTPq4k5FuDCyrr5nHo9+OUes0GlRnf/u0AjdsaxgJICOC3DekCTb+PyiTOhsxLi+LSsRek6AKKhqegMbFJrSPk3mGUZC6kevkv1vnrlu/CUIk6gxJsm5AopBFZpiCIewDbxMSmbY1FNAC1w0kg1DiXonVdyhl5CyVhR8Ogw5Nj+R3lEgeUJ3SnOfagKS+kfp9sm/EFoDVuQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUZlLzJIbWVNL0lkdGN2SHZhRmtrQXpURG5TbEo1MVBHUXBmTkxzNzdBK2ln?=
 =?utf-8?B?M1hnYTNsaGRET2NkUk5ta2RZZkk5SzAvZkltRktaT2Jaamh2R3cwL2pBck5Q?=
 =?utf-8?B?RmRSdkdvd2dBWGY5RUc2Z29LZGJKM1hOOWdGYTk1QVc3bnZzY0pLZGxHN3BK?=
 =?utf-8?B?RDIwbFU1QW10aUI1dHRkWGRkeVRDS2ZkRndLd3MrTFA3S1lhM1JRK1hjc1lB?=
 =?utf-8?B?VXI0SnlLbzBrOWd0V2V3LzV0NzUrNnY0ck9mdFBnaFNFZzJIRmlWbXhPdWZQ?=
 =?utf-8?B?eTQ1V214aFZZYVVsMUJrWGxVSWhybTlxbml6YTFBbW45RTMyTWRQL245dmZM?=
 =?utf-8?B?YXcvNVNPbFNwalZySnk2cjNKcFU2aDlGekhNRGVSYXhJUkpON2phUlRTanI2?=
 =?utf-8?B?b3JoRzdKTUdqK2JPWFJYOE9wRlUxbVpBR1J5UmR0eENBK3pOSFlyR0l5b0FN?=
 =?utf-8?B?V3A2S09ZRVBlV2RCVHhBS2xJTnFLMUtkaVF5bFVMT1hud0x2bVlhVUQzVXlC?=
 =?utf-8?B?ZWszV0Q1SEwrN2o3MWFuWTJzOUVmem8wUFJORnMzbDUrRFZkS2NjQjRoUVZQ?=
 =?utf-8?B?UzRNQXgySGl5YUhMa1U4VWNkTVZOSnduZ3dVbGhON2Erd3RicWNydHIvQlNI?=
 =?utf-8?B?NzFMR0Ztdi9ZV3BMVXVmamxTTVFKSi8rMXZ3ZDBQbm5wdzVJdHN4Ti9DODZX?=
 =?utf-8?B?N2I0K0JqbHVEYnFseFNDN0pTOWpIVXFuR1hKSHRHV1FwSEROV1RRWkV5RFdI?=
 =?utf-8?B?VVJyUjk5d2xuTmhVcGZ2dDFsbWMrZmE4Wm83Y1ZQMWljc3l6WExZU1pFcU1i?=
 =?utf-8?B?S0pkVEpCK3NpRENTRnF0V0RMUVhWbUo1OEhYTVEwQ2NrbjIyTFpIWVdUcEd6?=
 =?utf-8?B?Z1UwRHd2ZVo3SEswbW1ZdTlFQnQxRHhLSXU2dytMRUo4azFxRmdoNXNGMmN3?=
 =?utf-8?B?SXJwaHhkOW93RkdqbXRxY2U4QW9ac2trOXpmbVlPWWVDdWkzdE1rWHdCK04y?=
 =?utf-8?B?UnVCQSszV1c5aWxBRHpwaXpHTFRtM0Z2eUF2RmhVeFZ1dXhyYkRJQk4wcFRy?=
 =?utf-8?B?WnBJdHA0c2tlaG1xTVU4cGRDbjVab2lOMTRHZ3A4ODB3Tk12VGNaa0NhUWEr?=
 =?utf-8?B?cEhrMzFheDZyZWtiZzIrK0ZtNnpSbG5LNUVqWW1EMWg2cXRHT0ZlTVRwbm9L?=
 =?utf-8?B?K0JBTDE1ZXIzdm5Dc2ovU2xlMW5vNVdzU1JkSkdZYm9jSW9FMHlqN1JVSEls?=
 =?utf-8?B?LytTQ00vM3NlN2NpT2xXZTJ6REcrc3B6bGw2cGJhakhSc1hEeTFrUDdHMlV2?=
 =?utf-8?B?K2xzSlBiZnlKdm5JSml3YnJML0E5Y3daeUF3NGFsUTJ2Q1hoMDBOeEZEWjNG?=
 =?utf-8?B?RjA3TTl5LzUzMnp3NGVFWU5KVmhZNmx3VW50SlBOOCtGOFVxQmFtNzByYVhF?=
 =?utf-8?B?Y25UK1hxNGkraXMyWjlkTWFablJjVzhEcE0xTWNEcDMwcnZUYm8zQ2k0YXpo?=
 =?utf-8?B?cEJ5U0Nwemo1cmJCUTg2R0M2RmphT0I5c01zTkFtWmhEWlQ5VjJ2WVJVKyto?=
 =?utf-8?B?ejN4WUg1cXZKNUNaa3dDeXpWS2tzampxTzdUZmpoMW02N20wcW1yb3hPb2h1?=
 =?utf-8?B?Mjk1Q3lYeDAwYThnT012ekI5bGxTK3JXYkZUc3lGSVd5aVlDeDQraFZueXk4?=
 =?utf-8?B?NkdVck5mYkRTZGNoSzdkN1E5enM5NlZYM0xIbkpzTEEwMDh4d1M0bmZkM1Y4?=
 =?utf-8?B?a3MzTkxTYzlheTEzdkhpdXRBNUR4azdFcjhMUkJwNUhzUXhXYkFGbG1rZ2RN?=
 =?utf-8?B?d0Nlc1doVFJUN3lJV2dFcmhucUpaRmlqaWdKTS9SQW5Bd1ZFSTBIK0tvTllL?=
 =?utf-8?B?bldTR21ONU91Q3pnVlpUY3lpZEJTNGMwSUN5TGJ4OElqVUhORzd1NWFiZHhE?=
 =?utf-8?B?aklsSU5Uc2wwUDhETUdHSDhFOVM1L0JuV1dqNnppVkVBc2Z2U2xVQ3phMmsz?=
 =?utf-8?B?akp6SE1GT2RhQk1iMFNkRm1VSk1tT3ZHUCs4d3pyNzhQTFVhYmErdkx0OGJH?=
 =?utf-8?B?WEY4V21aZ1ROKzNPVkFlek9PTDhYS25mczVwYWx2d01zUEsvUE5tRXZadDhk?=
 =?utf-8?B?bm95M09YREd0RHlBRXZoMnJFNVkwRHF4bUM5TFRXWnhkM3U4RktoNkVYT0p6?=
 =?utf-8?B?K3F2blNmck1LK3Y3a0E1QlN1ZnVlRnJLaXlsY2JTNEF4cnFOWlhLeUFFSXdj?=
 =?utf-8?B?RERhM1JoSm5BTnd2bzJRbDNwSWJaczArTGRpbGpNUXZya3NOb0FzRUxCUVZi?=
 =?utf-8?Q?twiqibKLeRV+Y0sbwz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08511ff4-c132-4d5b-d159-08deef72f58b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:16:55.8827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEkqo/Z4gDhZxi2sAugF1YhuKzt5wfCyzrs5WWb4IaZleTE5cOoHlxToNFF5HkUa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Stat-Signature: etxmtd5g64hxr4mna7g9ub5ja6pcfsrn
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CB0DA0003
X-Rspam-User: 
X-HE-Tag: 1785550621-685532
X-HE-Meta: U2FsdGVkX1993EEgYliy3o9VfozAr7cssM03eodw5sEdx7MTkEFgQU88QnOOnqOpk+dfTLCGSFSH2UuKUhbX4nW4OeOpHWTyGX3PEdsGpHZv22K3LL/dg1kqNg7N6l3vkj7vaN6ROe6ay+5Kb7DzxS8TeEeVEdGd97Y1d5V71WZPLkTpx3redK/v0zN6CLT9hLJFnkiKa1rGl0Rp/nbaDIaA2qHisQGj7cAh7ZDB2LNnp+EvVV5eoSHxuhujsrzqT4EKalrkBiIKwXPuPXFGlX9d3NRa/2CNs381izwDRaMPmThKMAX95nC8xMlOV+4s4zi1DlQ5sn92qMoTg5uF/LsQVQ8mvUcxm4oVQ1PbamPI8ac/I24Oe3XLD1fD8R+DFKCpQHZzRaN31R/IK38kfr36V4f8+RQEmpICj+ygv8ERoLddH9hOxxyI4KGXkJ8Sto8tTNnGWmzBHpJ9/5cZ7kfn6AS8Ekbu27Ht7jIcpbUtL/yoFZyu8uaHvRQ3CO4AA8BsWse4DdUzWLRcBhAeAYh+ZKsheFqRdZtiwE0s9eqprekcKnwFvSJe0pHPumybYIydIoTrgoBoDOaJssIiWXZBYWK4Jg/ZGk7+HLq3gfjx9y/dLjGUpcbS6eJq6ZkbS2bHsz8hdgKordcauRrlaEqs64jRAThoCJbnyPbMVvGESDyUUcDKQrg+sVg97Akq4LHTWD+Zaw0K39nLEUPhCw8r93xSRvCrhAWCoykoNA5CpsoZV+z4FgXFbJ7yvuihJ2DHVlb2LXeIyN15Hxcm+gKWvbi5W2ol0j6GZnyVMzmF3PpByTa2qFn1W6186K6jHd+TEQ/1jbItSEnBf8bzGba/28GhBcG2CQUYyNkOdiGi0nI9ZQMxkqmk3fnLGRk/NZz1Ryz+LvEzDLkzgP6ou2o+q6CEAfSNPc4GzJ90zR5cCTgYZ40IlN/lDPLMkKte8Y4XjhB+/vpOsLsgQ2v
 BTeHb/P/
 BjMB6U8TrtfWpbgJea87DZo68fnbHFIkzrEhIikncxmKXY+0tvUrFevIvqINOuBBFxOndPTW0P/ryvw/5oGpslYss1Y/zSuFFvhf+TiCqReChCIDsRpVAtf0ya3NJhPsDWwDeBuGUuc0snqufNTxJ/yg8bSFn7LM3CHG89ih8WvLa9PvLn6uX1TzIN80GzalmyXnHh1be25gGnspnvI1u6DwWkQvADOpAjXPWUk8OqsRIDdbGfp6M/DTVDm6g6UWrRydfxheSbLaS7V5+XkXCRwEuuEo7bgoIvUWtkmWqQxMKUTCNYO0hmMUgJuUu86Rdg6ZxgHERYFV1W803Gqtc7olFNn7RMUwO5hlpHAjRmbDEnSTcs32Nd3pJLX0vGUhzuLFcZOij++JHnXhRVNZwk/8WmWsyIX2pq+7sC0vy5OG5oRKumGcWaT0tUZRahdXlUkA7kTnGoUcbtKm1ZKKCYC8ADG6+unf4VwWR1sWCs4rSxsrdJt+uLQECG9Q4mkOMTImxVVuRFEWd22NN3VRCEWeLgUHaDV7c44qFw9+7HTYNXEjXjbHg+6PGuAk3uWy+Aq7uoMOsxIIEJ+jwb6eVEFPEDKOafP58iUNR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
Replace it with zpdesc->zspage->first_zpdesc == zpdesc. The check,
is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
should be negligible.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/zpdesc.h   |  2 +-
 mm/zsmalloc.c | 15 +++------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548d..4fd81c2e80769 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 8204b76f78308..e8ef227624efa 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
 
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigned long obj)
 
 static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
 {
-	return PagePrivate(zpdesc_page(zpdesc));
+	return zpdesc->zspage->first_zpdesc == zpdesc;
 }
 
 /* Protected by class->lock */
@@ -848,9 +843,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page = zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1001,8 +993,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i = 0; i < nr_zpdescs; i++) {
 		zpdesc = zpdescs[i];
@@ -1010,7 +1002,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 		zpdesc->next = NULL;
 		if (i == 0) {
 			zspage->first_zpdesc = zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
 				SetZsHugePage(zspage);

-- 
2.53.0


