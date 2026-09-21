Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 837DCC982F0
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101086B00E4; Sun, 20 Sep 2026 22:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063BB6B00E6; Sun, 20 Sep 2026 22:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFB46B00E7; Sun, 20 Sep 2026 22:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99A856B00E4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22E3B1404FA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:48 +0000 (UTC)
X-FDA: 85236186336.18.F7775ED
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 469F240007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uEUoc5GX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmJueOys4162YTP727zQmwKPUht4GWCKnV6YwC01lf4=;
	b=x+gUBq5QNmodQmyR5DDPO93mnpmzWtR3YeXpYPpwt1cInPFRxX2/Ysym3+9jDfma3EzxOL
	l6lafaORzkX3VYojc8JyGcw9/9reLAi2BB0GrIIdrANX0yIUq6x70rh4IJvZt5S8MAWBlt
	L0K3Hz9OvfeFX5/4zFDify9oxr6A3+s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957725;
	b=56BplMngwBNuiG+tKn6sLJFydIvTZc9yaUUYGyD9EPRFDEuCEurscOgF93bCCfgZkjx399
	zDG2TaqOKslrseyiovx/q7KuA6ef0TiBwz3HTvevcYI/tXkXi9H+jfKArfoDMY/+fLg61m
	9yQJsRfTI8EFEdpj76NUb3+4x5Ailzw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uEUoc5GX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ew0tjMGi96qITxQaP3AzmRtWMu3QYEHiRLVv6Zxc8Z3CpHgTo5JvR6vAPLrJlZrV0HvM1Uscr+idYj5EN4GWLsVWD4gZuCsZN7T98q0V/KGxAF2M5qapTEYquJpCOZB1EdwS3OnuYJgI8Tk6gGXDekMIgDg/PJzqQadMM3Kfo7TBBbEkZNJMrw/emiL1GDkVM1SlUZkz1XZwWObK2nXYb7x4mNwgjfkWDRKdNRatelYAD7oH3jbr8E20cELTQFjAOXHYD5dIVA7KhMbN0HGZZW5t24aMzkPrAJECKOdvubDohQdwF4D6qGifPIWv3rV/zssZBtTrAoFYHXYZNE25Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmJueOys4162YTP727zQmwKPUht4GWCKnV6YwC01lf4=;
 b=MjTldpxNWmVle2w7B3YvD4Wv088J8GnXZe/jRicMiO16ZhuPWXDwghpJ2yUg/pogXNrbXyZl9472PWijxY3fLBaxoQ9oqFJyrPZVFzRW+xWCIBJPlm9h3uI0wc573UgYzj2FVaHAtCAo3kK2hFvKZZwNZHHb2qH4P8msJXQzQ+RN5c0ARXvtC8q8yui4V2DecsuZ28PqouYGA51IEoTmSkXxt5vl6FrAisgw5wDstngxqMi5yZGKgulY9wnvYpZJQkxZgZ/bLw+ZByEZRXN8ypElpKxjXURj3tcEW/D8WFRlJw3AGrrf2CxdGT2cavt+fk7peiyAal8vdnDgUp7FAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmJueOys4162YTP727zQmwKPUht4GWCKnV6YwC01lf4=;
 b=uEUoc5GXfnS9DGhSfA11C+/JqAhms9JOydqPKqDokaZcCmrHyh9Nw4npTklBb+fnIYr9Ultbwd/Fw1aFR2ZMJRcxoZUP/9BOFyrXgH5FdmMCTxIx4jC0K5hsOW3Oh6k382aHGQw2Y/NO1Im4Pdb9ieN2k7fEIJB1x0K02sbiwCtWd2ksbzLf3ru8Ki4sHAChtq4kUOEnBjiKEEt/Ue1Rm0WSyDqwmqvVF5EjdKPjFVL+nNjtrBwHTCLYSzDQwLhlQYqjZHJH7HnFfcYBiGBMcZEadq8so2qcClffTOblqJGBcjCb+bevHqspIajISGrh4755MIpzwkh6f75/k5QNlQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:29 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:03 -0400
Subject: [PATCH v5 07/17] f2fs: convert the ->private flag helpers to
 folio-only
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-7-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Tal Zussman <tz2294@columbia.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
 linux-f2fs-devel@lists.sourceforge.net
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0224.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a94a36b-f020-4927-9e1e-08df178805a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AydPEs/Aix3I96J/WvvOafHxezp1m/v09/tY8Y/X0HVjiB3HovzjW74YVh1cWMgo1fIyMT21g9RqVh7+43V/5EbvCF/vWqid9h9/idqiRxiEJg6w5ue9x7ZdQ2RzBOZMjaalz7RbTv3Cox+UoXX0JdbWmVQuyPgtUNt6xZJWGIt221t+IM0YQQogZq8AfcmhSgxn4ugKSg1EkIEmw3XR4pdP8kJm3Fu9c2p+f1xrT7kqj0pFO0EbEZQl7xMyBfVLVqPC71QaXtrgSJKZqFVgGQmk9FPjEOLj+n6n1R1kKyL/ceDLE0Ig296jW1kpPI3yfiVzAvJCPAIUhFVnLzJfIS/2A6HTbUnSsJptQ2dQVOsyCzPQspyRPlYkU2rceqzZY6ufzvlhVz+GRZwDqnJxeF/0KFeH9B/ONk0TMfjYiHq/hL0oLi25PjASI/lQOZvXtCboCHKusuyl3Sujiy/YlQSBocaRNknpziIA0Ldk4K56YTejmiWGXYn3EaEc43Rm+UMkBRIYZiQCJLiVnLyIrEX1vlUKKUCO+K3ZVADD+mRbL5wi5RfZ8nVBoaJnJ+TJwz76J187wH0YtNaDMEASIrdgtWszmAiRMeGaNZd7scamtITuQrCobu1l7BR3xpD14MZQ2+h1xJ5CU7/ZuQ4Z5tXwC59mykyHY3wHz4LRILfDz9gY1d1BF9v2gEvM93QT8h65GdCbDNqJ1+hp3Ooz7w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjhVTkpUcmxRNWFWK295NFM3Nklib2UwSS9VemVIdGhaMGhoejdOK2J5cm9a?=
 =?utf-8?B?NkMrcXVDYUkrSmRkZjdoRWtGSjdRZjQ0UHl4SHV2c0Z2cFM1UmJWSnhuTU9N?=
 =?utf-8?B?ckNCREg5RCthV1d3ck4vL0JBSEh0YVRJcjc1Q2IyMTdxOVNuQTM5Y2JXSjV1?=
 =?utf-8?B?OUc0YzVPMFNaTDJmYXhZYmEyWUhIMTR5RkZzK3JNTGNscCtReEVJRll1RHND?=
 =?utf-8?B?ZTkzME0vTWtiYnArZ09VL0R6STdFT1JaRnJyY01GcTRIWnkyYjVaYlRCS2x3?=
 =?utf-8?B?bGdXMGpTWkxxcFBXRkdFNUFXOGhVejBnM3psNWwxWWtOQ0RIeE01YmJaUFpi?=
 =?utf-8?B?MUVJM1JxYmMvU094ZXBYSWZLYStlUzk4TWl0S25IRkgwNWU0YXRrZTJSb3lD?=
 =?utf-8?B?NFhDTm80M1VzNU0wOEk5ZUZWS3NQYzFVNmVjcVByc3oxSVdPWXJwOE5hakVQ?=
 =?utf-8?B?ZzdUbi9ZQTVZUGFjbmUrek1OTkZjNmo1T1d2TkVsMVF6K0gxbThzR3pWbjlG?=
 =?utf-8?B?NWR0dklocFMvRkU2YmZzU1Q2eDByZFpMbXc0TUhCd0dQNWpkckd3VmVDYy9z?=
 =?utf-8?B?eUJ3YldyMzFJNVp0ZDI5RVU1V3pVOExjOHFrK25TSzJMZUQyTG5zVHcyQWxG?=
 =?utf-8?B?SWlNKytUQkplU2t4MDR0c29DanNPOFNwT3R5S3RraGFiME8xOGRjcWsya0Nu?=
 =?utf-8?B?dHAvUGhQZ25FcERpc1VQU1lGd1BDUHlaUkdIbFNaOWdvTDAwTENOZXhIcko0?=
 =?utf-8?B?MjUzZVRXOGNaM0NremlON0NCU3krcnB6ODZtekFjaS9kajNQRGdsN2F2WWU0?=
 =?utf-8?B?UkR2NHQ5a2tGYTdSajRkZVh0d01SaEVjVzhsZ0l4UDB3Mi9lT1htTkRkbURn?=
 =?utf-8?B?b0NaOEF5SzZMaDhxY0ZsK2FjTzB3MTVGTGNybzdTME9sNDNCUGgzakZmWVRo?=
 =?utf-8?B?S2ZTTVhLRjVMVGkwakV4SmxVNFgrUlU5cXc2Zm5SUHNCUXZRSUJsSUVBcWtz?=
 =?utf-8?B?SXBDNGN2SnR3MGFqSnBTY1llM05XMFBTSzNJSlg0am5RcURKNVREZjdFWS9E?=
 =?utf-8?B?V2p2dGpjeHgzTUU2UDdSdmpZYmpuSWRKVDFXcnkwRTdnYVBnWWNCRjJwK1RR?=
 =?utf-8?B?YktiSGNHMTVFN1BiZGdOa01oVUl6NnVNOWJNeXFSN3hqOVVHcjBKQXZWaEdO?=
 =?utf-8?B?MFNGQ1l6Y3hFeUpiMk0wMzhMT295TWxBNGRMVzFXQnU0TVY2ZnUrY2VOSktZ?=
 =?utf-8?B?aDlFemtsY3M2RTF4RlRycTBFTmxRNzR5cXB2RDl4SEIySjJ0Wm9xZEpXSEVI?=
 =?utf-8?B?UzdzY1Fia3FZOHRDQ25aVGZoYzdQVEtBR3ZnaEFkMHFheEhFa29OeDdqSGto?=
 =?utf-8?B?RzV2WmZtdk9kbWlMMFJ6TmRxVTRpb1g3K2YwVFUySUNqWURvRlRPZnZzMEha?=
 =?utf-8?B?UUNYUzNpTzlhRTB5OGlEUXdSa0toWklCUGllMmZDeXpjUVU4VDVXVEdvc08z?=
 =?utf-8?B?WENvS2tYaXg0NHljSGszYndEalFHVHpsY1hHWHhUWjhhRUtJKzFkeHc3VDda?=
 =?utf-8?B?bDNEY2NqSVBOSjBqWFdaZUdySzQ3WDJIcnlZM3c2QUVlRFhDY0NQZERuS2pC?=
 =?utf-8?B?QUN4TGhSZkhIMDZwK3dvVjlTemovcFh1Nll3dzdBVkFVL0RZKzV4dElrOCtI?=
 =?utf-8?B?djEyejNuWjlFRkh2TldyTDZJVVhyK3YzVEk1eWFWcDh2T3RCOGVjdDNpaDJI?=
 =?utf-8?B?UGxDYUxzWFZSaTkyQ2ptTGh0Z2NXT1ljWi9ua3pzd2EydGpvVVpwbTgxbnAx?=
 =?utf-8?B?NkpiVGkvRE80T1VQdm94MnVRaHdyUXV6NXlVd2pFZVhyMkxaWkxkQjMrQ2pK?=
 =?utf-8?B?Mko0Ujg0Q2t1bzduaDRMNFNuZStBV21rTnpybjRSUFY5cHVyTy9rdWdsbmw0?=
 =?utf-8?B?V0FUeUhhcm1XblNrTGc0bVFzTDhiYzJQSlhYRThzdm51V1NRS2tmcHIwVlFL?=
 =?utf-8?B?ZWUrRXpSQmRoeHorOFVrdzhUUG9mQ3ExZGpuOVpyYThkR2p1QVR1ejVKb1Bl?=
 =?utf-8?B?bDFaSzNuOGxPS2U4VDFRcFJlZFZETU1FNGJicDEwZ09zNkJVS2I2TE1YV0NS?=
 =?utf-8?B?Qmk5RmRudmN5QUJndGlscU5ENHpkNkltOGxjQzhWUGVmUk0xbXFIeEM0Z1h4?=
 =?utf-8?B?bDQvblp4SDJHVzhJNncwYjNwK2N6TDhJY3JYM0MwclNoWDNzUUpWUGdtVTd0?=
 =?utf-8?B?cm91S1VuWUlZN3JMYWhvRk9mWXlxbi84UnNUZjNscnhKaDFJODA4Q1AxMGlX?=
 =?utf-8?Q?8qUs/NZgMVC0wdAp6C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a94a36b-f020-4927-9e1e-08df178805a6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:29.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 261BU3h3CZctg/tt17CC9EEj19Jh4X9xsOuPBy2S//54Tb64udFeTRoAsAiT/i77
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 469F240007
X-Stat-Signature: 19e494f1foz98yhnd83gjsfdfc4fmaws
X-HE-Tag: 1789957725-533433
X-HE-Meta: U2FsdGVkX19nXFv0IFlQGdXq8F/FBRgB46AKjuQeLDiLXXtdaVFsOgfEVPDWijy96BmVpnkHrJ1NCkXcY82yhUPWt37MCbeQgQX0YkZtfB/P9HeVR/hPbv9sAkrWMVT6JSch/bS4bk7kgj9HEXrTipACOPH9XXZHOuxE5+zMVgySZO+fIYg6QJ46Apn5b3KTiOW4yukdrClwNDkB4aBZFoTotFD+PcaXZlK5H/vRxDtgqlrqCipNY4vvQF3os157UYNVkvXwD6AWrLUQ2iVBeN877MWC/K6233ZLOgleWDwUJWY3uZaZBSfbNLIu+X20d1irTfW46xCP2505sxULrCSz0VAGW87gS9rVp/KSGkw/zW9K+xr149p/vZhE0h2kjtMC+wHF7l9xT0Mwu+DyCTdw5UszIscWSctB/Mzdp5NS4VP8seU1YJvfocRGy72DIgBt77UQtqe7CAb9iwq74bg9BSeqUHotZiiYVgh+4Gs4wjQ2GUnGmlJV9Tjzj8J6eX8O+P3Pz8eVqgNDR+3ShX1fRmZtWbXUr5HR+Nom3yHqnabhAUVu/xvF4f+mVY/U4CmoE9nDU3V8PUrTzj99vL66AAAuHknDT9b4HLSdtWfNvih9K8N6dR5KMleR3J1WMCV2NhLZzmxd6YkSgaWJVUpVkVmgc5Sw7JXKIeZFhgQ99UDlsLIy7RlJOPdN8dnvil3dt9PnnU+xvRpC/Qko2/NN1p3RA3Rw2JWE/lv4E1cyxZsA+Cct5oChmty0T1BCOB4NbqEImPAwC1iwuWfyJR1iKHYbuCybXGVTZwxRIEBWXXF8TToUqjsB6kYBrJ2Ll39oOdQNWiGc1tqpQOKANtLdb18VBqAQQBeJDQtr1p6MnnCunb6XZ+LLrlQ9ODlqNXj4jDv4ttLdWLeMaVFjjIoQunJcQiPNgZQm2JjkaczBnenOZVDMpDa8rHDThukL6bLN70aOddlohw5Lhbl
 iHR4/3Gl
 JqT+tY8hTUosZzHU/q/aKKpAZaP8Vi7SbNhHgyuixN5go15CVKVKhqyHyc338/Be/dK71kp/OwUk8mrN20rQiX/UcKUb6rMmkB+RejoBuuYfQ1U7tOqPrbQ3pkZsONfBsBlxgbnA/UGzJBK3N5tjilKn7i0P8QtU0jYEEQ+KJnwxBPslqEsIj1zJaw1C4dMj6Sj5P+fOLbLmqC1azd2cK5+UN4DdYOmt8Wh9SQdLaR/VjGzGkdQdi43xZTQyqS2DzjpV7zZQ1/Z8Xc+FxF+KDIILOln948P0gDyMnYJs5SojMpvynAO4Xm6R7G+xwhOJdeA8+C7+61cxuCcvc3Wl6c5Srp8bHgjugP8iJKnknYkXG4wlKiKrMU6aDE2cbcjE2wbpsgs0iCt88N+PYTntT2CbLUti98Kd1/YWXk5avZdQ7aNZ62CyMKXk0xNhOmn3+XWRn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page-based ->private flag helpers are used in the compression path, where
large folios are not enabled. They can use folio versions with
page_folio(). The two remaining users in data.c and segment.c can use
fio->folio instead of fio->page (two are in a union).

Drop page-based helpers after the conversion and rename
PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
f2fs_io_info union to folio only, since no page user is left.

The folio helpers do a plain read-modify-write where the page ones used
set_bit()/clear_bit(). It is fine because the converted code either holds
folio lock or, in f2fs_compress_write_end_io(), matches what the
non-compressed code does in f2fs_write_end_bio().

Assisted-by: LLM
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/f2fs/compress.c | 35 ++++++++++++-------
 fs/f2fs/data.c     |  2 +-
 fs/f2fs/f2fs.h     | 99 +++++++++++++++++++++---------------------------------
 fs/f2fs/segment.c  |  2 +-
 4 files changed, 63 insertions(+), 75 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index ce88092d9ce26..09d9b8d0fdcce 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compress_ctx *cc,
 
 	/* Cancel writeback and stay locked. */
 	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio = page_folio(cc->rpages[i]);
+
 		if (i < submitted) {
 			inode_inc_dirty_pages(cc->inode);
-			lock_page(cc->rpages[i]);
+			folio_lock(folio);
 		}
-		clear_page_private_gcing(cc->rpages[i]);
-		if (folio_test_writeback(page_folio(cc->rpages[i])))
-			end_page_writeback(cc->rpages[i]);
+		folio_clear_f2fs_gcing(folio);
+		if (folio_test_writeback(folio))
+			folio_end_writeback(folio);
 	}
 }
 
@@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct compress_ctx *cc)
 {
 	int i;
 
-	for (i = 0; i < cc->cluster_size; i++)
-		if (cc->rpages[i]) {
-			set_page_dirty(cc->rpages[i]);
-			set_page_private_gcing(cc->rpages[i]);
-		}
+	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio;
+
+		if (!cc->rpages[i])
+			continue;
+		folio = page_folio(cc->rpages[i]);
+		folio_mark_dirty(folio);
+		folio_set_f2fs_gcing(folio);
+	}
 }
 
 static int prepare_compress_overwrite(struct compress_ctx *cc,
@@ -1281,7 +1287,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		.op = REQ_OP_WRITE,
 		.op_flags = wbc_to_write_flags(wbc),
 		.old_blkaddr = NEW_ADDR,
-		.page = NULL,
+		.folio = NULL,
 		.encrypted_page = NULL,
 		.compressed_page = NULL,
 		.io_type = io_type,
@@ -1370,7 +1376,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		block_t blkaddr;
 
 		blkaddr = f2fs_data_blkaddr(&dn);
-		fio.page = cc->rpages[i];
+		fio.folio = page_folio(cc->rpages[i]);
 		fio.old_blkaddr = blkaddr;
 
 		/* cluster header */
@@ -1476,9 +1482,12 @@ void f2fs_compress_write_end_io(struct bio *bio, struct folio *folio)
 	}
 
 	for (i = 0; i < cic->nr_rpages; i++) {
+		struct folio *rfolio;
+
 		WARN_ON(!cic->rpages[i]);
-		clear_page_private_gcing(cic->rpages[i]);
-		end_page_writeback(cic->rpages[i]);
+		rfolio = page_folio(cic->rpages[i]);
+		folio_clear_f2fs_gcing(rfolio);
+		folio_end_writeback(rfolio);
 	}
 
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 21f396ebe22ca..ca8232a9095f8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2923,7 +2923,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 
 	if (fio) {
-		if (page_private_gcing(fio->page))
+		if (folio_test_f2fs_gcing(fio->folio))
 			return true;
 		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
 			f2fs_is_checkpointed_data(sbi, fio->old_blkaddr)))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2f7ab5888b078..85937de3d7016 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1357,10 +1357,7 @@ struct f2fs_io_info {
 	blk_opf_t op_flags;	/* req_flag_bits */
 	block_t new_blkaddr;	/* new block address to be written */
 	block_t old_blkaddr;	/* old block address before Cow */
-	union {
-		struct page *page;	/* page to be written */
-		struct folio *folio;
-	};
+	struct folio *folio;	/* folio to be written */
 	struct page *encrypted_page;	/* encrypted page */
 	struct page *compressed_page;	/* compressed page */
 	struct list_head list;		/* serialize IOs */
@@ -1613,27 +1610,27 @@ static inline void f2fs_set_bit(unsigned int nr, char *addr);
 static inline void f2fs_clear_bit(unsigned int nr, char *addr);
 
 /*
- * Layout of f2fs page.private:
+ * Layout of f2fs folio->private:
  *
  * Layout A: lowest bit should be 1
  * | bit0 = 1 | bit1 | bit2 | ... | bit MAX | private data .... |
- * bit 0	PAGE_PRIVATE_NOT_POINTER
- * bit 1	PAGE_PRIVATE_ONGOING_MIGRATION
- * bit 2	PAGE_PRIVATE_INLINE_INODE
- * bit 3	PAGE_PRIVATE_REF_RESOURCE
- * bit 4	PAGE_PRIVATE_ATOMIC_WRITE
+ * bit 0	F2FS_FOLIO_PRIVATE_NOT_POINTER
+ * bit 1	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION
+ * bit 2	F2FS_FOLIO_PRIVATE_INLINE_INODE
+ * bit 3	F2FS_FOLIO_PRIVATE_REF_RESOURCE
+ * bit 4	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE
  * bit 5-	f2fs private data
  *
  * Layout B: lowest bit should be 0
- * page.private is a wrapped pointer.
+ * folio->private is a wrapped pointer.
  */
 enum {
-	PAGE_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
-	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
-	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
-	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
-	PAGE_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
-	PAGE_PRIVATE_MAX
+	F2FS_FOLIO_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
+	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
+	F2FS_FOLIO_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
+	F2FS_FOLIO_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
+	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
+	F2FS_FOLIO_PRIVATE_MAX
 };
 
 /* For compression */
@@ -2681,86 +2678,68 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	return -ENOSPC;
 }
 
-#define PAGE_PRIVATE_GET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_GET_FUNC(name, flagname) \
 static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 {									\
 	unsigned long priv = (unsigned long)folio->private;		\
-	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	return (priv & v) == v;						\
-}									\
-static inline bool page_private_##name(struct page *page) \
-{ \
-	return page_private(page) && \
-		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
-		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
-#define PAGE_PRIVATE_SET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_SET_FUNC(name, flagname) \
 static inline void folio_set_f2fs_##name(struct folio *folio)		\
 {									\
-	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	if (!folio->private)						\
 		folio_attach_private(folio, (void *)v);			\
 	else {								\
 		v |= (unsigned long)folio->private;			\
 		folio->private = (void *)v;				\
 	}								\
-}									\
-static inline void set_page_private_##name(struct page *page) \
-{ \
-	if (!page_private(page)) \
-		attach_page_private(page, \
-				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
-	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
-#define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_CLEAR_FUNC(name, flagname) \
 static inline void folio_clear_f2fs_##name(struct folio *folio)		\
 {									\
 	unsigned long v = (unsigned long)folio->private;		\
 									\
-	v &= ~(1UL << PAGE_PRIVATE_##flagname);				\
-	if (v == (1UL << PAGE_PRIVATE_NOT_POINTER))			\
+	v &= ~(1UL << F2FS_FOLIO_PRIVATE_##flagname);			\
+	if (v == (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER))		\
 		folio_detach_private(folio);				\
 	else								\
 		folio->private = (void *)v;				\
-}									\
-static inline void clear_page_private_##name(struct page *page) \
-{ \
-	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
-	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
-		detach_page_private(page); \
 }
 
-PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
-PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
+F2FS_FOLIO_PRIVATE_GET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
 
-PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
 
-PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
 
 static inline unsigned long folio_get_f2fs_data(struct folio *folio)
 {
 	unsigned long data = (unsigned long)folio->private;
 
-	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+	if (!test_bit(F2FS_FOLIO_PRIVATE_NOT_POINTER, &data))
 		return 0;
-	return data >> PAGE_PRIVATE_MAX;
+	return data >> F2FS_FOLIO_PRIVATE_MAX;
 }
 
 static inline void folio_set_f2fs_data(struct folio *folio, unsigned long data)
 {
-	data = (1UL << PAGE_PRIVATE_NOT_POINTER) | (data << PAGE_PRIVATE_MAX);
+	data = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |
+	       (data << F2FS_FOLIO_PRIVATE_MAX);
 
 	if (!folio_test_private(folio))
 		folio_attach_private(folio, (void *)data);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 63b712d3d599e..8c156e1fd37d0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3803,7 +3803,7 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 		if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
 			return CURSEG_COLD_DATA_PINNED;
 
-		if (page_private_gcing(fio->page)) {
+		if (folio_test_f2fs_gcing(fio->folio)) {
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type == FS_DATA_IO) &&
 				(fio->sbi->gc_mode != GC_URGENT_HIGH) &&

-- 
2.53.0


