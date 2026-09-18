Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55102C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CAA96B00A1; Fri, 18 Sep 2026 12:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2656B00A2; Fri, 18 Sep 2026 12:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590A36B00A3; Fri, 18 Sep 2026 12:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 360E86B00A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:57:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAB6240766
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:57:27 +0000 (UTC)
X-FDA: 85227488934.24.1BE23E3
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	by imf23.hostedemail.com (Postfix) with ESMTP id 216A014000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:57:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cm5UNesk;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWRPt7StXWLMd8+VoHMnhrGpjeqqS4LHa7QkqTHcQy4=;
	b=yIo8zjcZLSRg0aeWeG/4GHDm+HqF20F80hhcwIgqUehFdiTm7LqBS5J+nrhDjEd22LH5xa
	DFI2CkMN4fr6bh7uYxbdcu/0rx0NG5+gPeMLE3SzeVRutp257eM21vdy7Tv7AU6TCAmyDU
	OpV7NnScdZh4StA7A4Q7nL2xhGU6yfA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Cm5UNesk;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789750645;
	b=p0UkRaoZWQ6Pi7u79scGs+mddRfwTo/Yhjg9h2tRebEoxZs36XpOd+XF39kt97hjS7t9In
	Sicb+oCMsIAYRDm452LkvRmXwTqDYnYM0rn1bOFF44DqjAHVh3aSdLi87cLVvcskYpAbZq
	EZmSvBMeB+KnIsXM7cQ3EnetNjfQ4Es=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOwSF+GZDiznSAkQ4lG41s1GO6392uadHBYbO5EV7GFiy6OxnEE+R4oo5cowsimqAbWGF6L9dLJe/Vtbe+j9+qJ5dBLLwhOLCgOkAA/S/Zdw8DY3FGkAwOZBMd+05DcSp/WBFiM77gjghPp4M5YYwjXUeRHbRIo7MoKy96xo8gDfFj1oZBxMMjx9ae0PfnAxYtiW/jcrKsasHRp4w6u9ae9s63kSYBWT02Y0kpqz+Hpk4UObvdybVYfaqhK7dLBuggvF40bopok468mPwLOkANn41IH6D5192x++6ifFBGN1PG8aQHnf4CCnNRk5DfbiE/P/wGbMyyhYquBTSRoIAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWRPt7StXWLMd8+VoHMnhrGpjeqqS4LHa7QkqTHcQy4=;
 b=TndprIyw2Rn5+r9CV8R0ARPJzQR8FPA4W3sCgutCfPF7cg+somitG949mJj2kBiPw9lgzRkeebaQigwJi+Sh+HO5F7WrvsrKsC9B75co9L7zQDvxsOcb3QRp+Ev+OlgHeAEsGEqb1yRuF12I+qw6VStkpANY8sA9q429Ita0ftBtQw/Zk+6NFiaegBQwzgo6vrysdY0aq9Fw5nDxSHnsAbBvJIBwzUwtBV5AHAew7RCX9E7ENwQcIJz0GmJG2qRAnElRy/D3/qqQQQpJp9kiJCMCoJUid8Vmkwtd4lDg39NJl4GM3Hr1Z3fMxPhrddrgW5X5tQ9ceQhQPF2xkdmsig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWRPt7StXWLMd8+VoHMnhrGpjeqqS4LHa7QkqTHcQy4=;
 b=Cm5UNesk87BF5d0ZmiV7oRFdiJXrGuwm3iYOzTAkQBC2Q4xDfXC0emszBMUtyc8Sfb0EnJDr5ZWvtIwe//0zuYudvXi57XWzy+3ujDf4qHs1GOBidfLkSySIgnEAXqixg4xVcfYOjD6G+OVWGwNW74Ow/Cjg/7UUWWtl+X1jdZtBAjEQqDqM8RJxqjtq5EH+AhgQNcIp92FITnI9Le82uKr/Q36fl7SDtm8Ts3B3dwzujxjgZ4ca/6atHudrUVb3/UjIfGxcOSf5IxHJGj5LX/9n9BZ1OyZyfOsS89VyZni1oQoRAcZiTDVJizImjNV6s3k0ErrUeheWN1KXchx3sQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 16:57:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 16:57:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Sep 2026 12:57:18 -0400
Message-Id: <DLILNGV3Q62R.2VBQCCZHVD3NX@nvidia.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: make Gregory a co-maintainer of MEMORY
 MANAGEMENT - NUMA PLACEMENT
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Rakie Kim" <rakie.kim@sk.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
In-Reply-To: <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
X-ClientProxiedBy: BN0PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:408:142::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b347c8f-532b-4a71-46a5-08df15a5e6ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|921020|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KqmruhjXdFMzQAALIbm/IXC5hyf3Ph4PwREX/M/BRz5ZMk4ygsRPspT7fnMo1E8a9jMgkhuAuf9ygsF7BvTnqKIvG0Arp4WIZr3KVMuP+7Pk8dNWW/P1tDFNRYDPJ8Bj85O7yt80sn+NH+VkSQXe3joO8SeGN/K+hw9+OgBvw+KoczCnuWJDqkbIyMGSwSLph3Vu2vE1MqSbL7m+G5GeD6E+/fLy0n7JTBNnRPLNpsVDCuLKWbxnYE+HgstKA7nOojMqE9CcRrrmeUjd7Ou+0tPGk8myJEejTyfjU2BNnuBVhsd7/O8aLKiho0wZsruKvAPHiAPVq9SzfVdNTFY0lVP+d8ts90p1sp8bn08sn/ygmu29z/mpcOVa7AzgZp0WXONY0qXd9q2k6ONWMgDNYHif6uwMW0pSGv6Uy/3twao6TO1jZX9ou5gMvKjjQ9Cz+31oNawXOCr85CJpid9Ux5xZ5txIO2IOIZfQM/yVrinlq19krNhDDsjl7WStB/RLgoFj5AFr4wjJfB4O1AJC+VxtfXWAn7aZMuaPuK86kUmtYmr4zjwcM7n1lWWB1e6V7K08r/v6b2O5UI3pYnOpFIqWkaWgRUkNfAchi1Vmq1kVACTsElSm0bg+qOS19HOkFVWTpgFdIkZnmAIRZCWbnxHJjSoTRp2yNf0SUf5Lyp5YxWHvm2zysnZFyZkzqqaMPJtTY3pxGewWEXs+7gpp/w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cllZUVhhNHIvaXpNN052ZGxIcXo3V1NQcm9iWnBrZzkxSFU3VitHTzIrS0Vx?=
 =?utf-8?B?YkZwMVVzZG9OVVBYQUYvKy90OUFrblh2bFhTTi9sN2oyTkRCdmJ1eTZBVlBI?=
 =?utf-8?B?dWY2bkNWZnRFUnF5Mm50ZlgrWVJaQTRmUThNTjJPY2ovZGp0VXJOb0pSdzg2?=
 =?utf-8?B?Zk5LUTVybXhZMTBvUGpEcEJqYlFEZXBiRnJEY0s3Y1RVbDl6bnh3NWlVY1FW?=
 =?utf-8?B?TGZmTkIrVjVXcUNTbkxrOEdmZlc4aTJhenoxN1ppMzh3d2ZzL3pBZ0lxMHdU?=
 =?utf-8?B?WE1taTZ1dmpmRUw3VlBuYmdmeGJLRWR5ZTBaNjZyZXdaU1lkaEZsMG43Qldj?=
 =?utf-8?B?WE9JaHNocmlpUlh5b3VFM0xSdXBaQis5R20zLzRJYjIyZXMreE9ZSjVCbVl5?=
 =?utf-8?B?YzJ0NFd3Rmt4RFR1aWtKUEJabVc5andlVEQ4TXViQ0IvcDRTa3F0N0YrZXE4?=
 =?utf-8?B?NnhoODRIWFNnb3Z1Z1dLdXoyV09YOUJOcHBNLzhXYnJBeHZqbmVmWlkza2xC?=
 =?utf-8?B?Ym16VUlqNm9rc1NYTFQ1NklhcjdQbnM0RFhnOEpBUFExdFZSejdhcHJqci9W?=
 =?utf-8?B?KzZBMHFDQ2JyeVNTc1FmaFN4WVBIWjBRSy9aK0ZoUWxLNFZ0WExIalNKYjN1?=
 =?utf-8?B?b3AwY0dsSXRCQVpkOWxhZWhOSU5RR2ROUUZESlJ0K2NQbDk4QzFhWkRLMHRo?=
 =?utf-8?B?MVdyM29MdFcxL3orYUd6ZEFUU3p2Z2RzZnF6ak9MOTRRV295c0hDWlYyS3FV?=
 =?utf-8?B?NDlPd2wxTVAxUVZnZzFsTWNHMm9iazE4TiszUmt3VVNmVjR5eEptbExUbmZF?=
 =?utf-8?B?K09JSzdEYnh0dWdqcHBZRkd6eUVkWVRhWWdidnFsd3lOa2tiTFhUZHpRaHlN?=
 =?utf-8?B?VU14RloxSk9FblZTUkt3ZnNrVTk4ZEgwZzhZcmRVRGpXdkF1aEYwaFRqcFU0?=
 =?utf-8?B?NmR2OE1Qd1NINXJQc0tKd21ERkNSb09qWXFIVTlvYS9PS2w1ekJDRXkybXdu?=
 =?utf-8?B?bHlxSjBzT0RRcFdweTZ0R0dCSVUvdThjS2xmMi9CKzErTWlMVkpsZ2tDWEgr?=
 =?utf-8?B?LzFBa2w0UUVKdkN1allOcGlYOUczY3hmcTI5cFIwSlh3N3A0RHpJSFUxMFor?=
 =?utf-8?B?NGNhamxBd0x2bGxsZzNveFVOcHJtdkp2MUFHK01ScVVYTW5nR0RESWR1TXN1?=
 =?utf-8?B?WTZxbWVrUnp0Ti8yUEc5VU5QSENsM2VtVGVpSUNiR2lOMkMvZUsrK1FMRGlM?=
 =?utf-8?B?S3V3MkZDNzBnQXpvZU5JcllZMHRBVmt0azJBY2thNzArcm9vZWJVRTJzQlZm?=
 =?utf-8?B?NkRwMUFxNDArbHFNcnZZUkcyMW9pV09OMmF6VHBWM25ZRnlYakdkTHZTLzk5?=
 =?utf-8?B?NEVhek9VSmVzV2ZydFRpbXlSWGJWRndJL0ZkcXFlZFVwQkVLZDFzVDhrQWNR?=
 =?utf-8?B?Z2RUVndBMHM0NVFIVlFQUGdPN25UWCtKc3ZKQ3lGRlhBYUtnd1pBYzJqVXZI?=
 =?utf-8?B?bkFSWWxoSHVYU0pHRzlhbVVrcDRXNGQ5OVYwSHpnb2NDWTFwcllHSUdEVTM0?=
 =?utf-8?B?cy8zbitySEJRZ1FnOUJ1NDExYkQxcXczWXd5MTJzOWludGJIMlhsQjFEQ2sv?=
 =?utf-8?B?Z09VMW9wbjNFSFJkYnl2TlpLdnpmN016WGJCOURVaWhxZ3IwZklGeVc0bWFF?=
 =?utf-8?B?RDhqMkgyNUxEdlJwaWd4Qis2ZjZyQk1jRlNQSGc2TGk4SU5yc3dDckhlTmpY?=
 =?utf-8?B?THNmVkV2dFZBNEpFQ2ZLRFJ0RVVrTy9JUzZIOW9aTUJOazdZNkw2a1V0bkZG?=
 =?utf-8?B?dVU1QXRRbER2WEFpOWpLcFAycDZVTDFZRHZEWHd4bWJPNCtOWlN4WWtETHR1?=
 =?utf-8?B?ZXN6N1UwbkVoNWw5TGJlWm9yS3ExMDNjYzBqV25VeHJiK1MrazJQZ3FjQkN2?=
 =?utf-8?B?VGxQM1NDWjlBNkxQUGp2TDNwcnUrcS9FRkVPaVp6Wmc4SHBRQ0phWklZdG9j?=
 =?utf-8?B?bnA5S3o3cEhDTm04T3d2aW11R3h2RWgzNlZvYW9VRnVkV0RrbEU4L0NCSTdz?=
 =?utf-8?B?SCtzdE15UlZlM1FpczRXYUJiOStubjVHYzExc04xYzEvWi9MMDVNbll0SUhC?=
 =?utf-8?B?SHJ4MEd5WjNWaGN2SDR3TmtPN1g0WnZEdEhmMVU1MVJOV1FaQk1PanJtUmdF?=
 =?utf-8?B?WWRoTFJGazltS3Ribi81a2gzQ3gvd1lTb2hRL3JSSUsrM3VONXE3eTc5a0Za?=
 =?utf-8?B?UjVnVThLRHhGL0p6WXBKK2plR0YrdHhvcTZaQ0RXTTBXUWk0anc0b3dISXJV?=
 =?utf-8?Q?xTZ8f7EyF9SNiYKGTI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b347c8f-532b-4a71-46a5-08df15a5e6ec
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:57:19.8997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FltUL+g06TrPAdTyr8jH0IpfH4+yreH9EJNZ5EHQYA1ww1UZaP5CRcpXuVle85B0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 216A014000A
X-Stat-Signature: fkeramj7m4whsjpou7c1cm569hf4f6rd
X-Rspam-User: 
X-HE-Tag: 1789750644-51592
X-HE-Meta: U2FsdGVkX19cSNKC5NqkAKc2W1H9vGAnnuBzFVX+PXUJI1VtftSLj9y+jRqp66JYwOIMxFPjPN4geg2gWAB5d86JUsEH3YRBnTNGsRO7i0+X/+WnsB9XANmJeTjuRwl8sjb0va2Ztl9TxqA1UfVQxLaBDd4Xm2P+nY0vJ33nrMXQVz3P5R2TAuuh4pRUNvQDXR2mV2xb+X1SB1HsHSX/A9lcjAYjTFbTrCTiCvRA3nGtkpl38Me8SNBAA/GFcsd9GnR4YwyrIqYhYcVHwmfGQKxVNg5sWbbop0XpMWq7hTAycJmu1+7QHkHsv8w3j2l4s4JOM4RDi6QnC59mb0AUcOXgcRCuwu4of3WphJUeMSUuYCiBdKa+R2EnTo21Ti34aEu4bxkANRNKH5Db84n/FH2onkHlDB+u05djgSQGs6fQho+JCJMAswlgUXRsglSug8jg5SPHRxOsN7gRDQX+ggyXY7g4MY3KlYYB/wt67xgtA/wHy3NKsgbxxHAnLVJrdeINewh0fxEiswosXpBZ0bdUC9xuAEqeMSQxHTFe5IUn26aiQU8ptwHaLMaon+Gz29Jd4wpsblVVlh84SBItrPLbrTXFeOennwl/9X6NMnA81AyzWqSJcMdepQ3pxgYyqtbrLUeYnZU3DG53hkGPiaF0Dh1pMLVLVRbglpoCD1PP4hoUe55ozz3aU88MTTYPVpyhYfTsSR63D2XWJh5odLjC99VbOVuwiOPNsDdDAQqB2iJpX1+Skmar7kdqv6R/X0TakniE+nbpgeDfIQ6nMhch0FJU4Ma8Pyb/Co59t8zxi3vvYK7Y3+THHxxtztUh03Lnou31WxngHz7wZe2mJVbZiSHya/JCRLWks+8969m8Jjc1DzosO4VYI+HSth2q4KlUMCreotzRJB1tPBpsCK+gvGkVRg1BmwisTeLFzcB5knDR8Cw82swJyehQfNI0gezZ24gjS98+PIw1laO
 qMRLUBJG
 Q0IC/aPKEDqhM/NaDpJc+IjfCf73gogeIBi/71b/BlUMMNRcU9E4zhK0t5d/1wPNEyYW8xtmAd4o9NtHNU+Zn1F/dRQx5IuWwk6sS/XRkMYEQ98GDBYJo+b5NdSWeCf4D5mOCl3Ujsmxu18xkMJ7L9dPFyNFQPGRqlFj1+xKq/QzhaGgyRjlod6kr6jt8u/JNKO/xgibD2Ui0E7NzDxdnbacjlN5XjV0zK7TNI+Sp5xO/Dfof0mW+9AIp13l6RLWjgPc4/0DJguV1jqBSEQhUNFQTA3BZrPZxIabedCO/OMPmJHHCb94WmPJ3UJrqvkqj8EXLn9KPjehocuprdI7qEB6456fRyrJ+TJdrbZAyLNWn7txpth8yvWajU5Hg+OMN23PIzs2KjBmlhDR5qd/LzvuLXvVJY0Xt+tKB8dTGgt9vM/svnNncxCnx374FyMOGBr1XKg6XsbWIAK0qRu96iU9ZmlrMSh8MKq5np2sj+1AfaZsbOC3ligHVHqCRvKqHDD/gegWy6Zqh471Cju5SXmVduij85UeU0AJbWrx53BvMHyhFJEQMJfcY2mEtyEU+2tqXd23zjQ8NqE1UH9AR15u3BSfWfUK5zboC06S7ZNv/T3NTkuPwVLrZUSPFszPTHpzKYaL/zeQH9YeA+Y/Ht2uS9TDcBDiw2FUmC025EB2OqGQQtrCd69oTljMxH5D7NWRdv5EvN4aYSljgfbT7vJA6WTPlpF0tJasUWV6gOcIozKxE7GruTe5ovC33TW3Ccb6B30ZjXbTjrEafLd6SJ4t1Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 18, 2026 at 12:34 PM EDT, David Hildenbrand (Arm) wrote:
> Gregory is extremely familiar with NUMA placement handling and volunteer
> to help co-maintain the numa placement bits. So add him as a
> co-maintainer.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 344875eefd175..2b99a593436d2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17298,10 +17298,10 @@ F:	mm/numa_memblks.c
>  MEMORY MANAGEMENT - NUMA PLACEMENT
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> +M:	Gregory Price <gourry@gourry.net>
>  R:	Zi Yan <ziy@nvidia.com>
>  R:	Joshua Hahn <joshua.hahnjy@gmail.com>
>  R:	Rakie Kim <rakie.kim@sk.com>
> -R:	Gregory Price <gourry@gourry.net>
>  R:	Ying Huang <ying.huang@linux.alibaba.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained

Great!

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


