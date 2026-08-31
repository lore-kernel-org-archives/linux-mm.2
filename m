Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCA1C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F389A6B0088; Mon, 31 Aug 2026 15:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2736B008A; Mon, 31 Aug 2026 15:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66626B008C; Mon, 31 Aug 2026 15:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 974E46B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:25:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E67DE120210
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:25:56 +0000 (UTC)
X-FDA: 85162544712.20.8CF1884
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id E0352160003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:25:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hhMAysU3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fw3H63mFOM5wM+X5HnSTRkGMbpfnfajuq1vd0Z/41I=;
	b=Qz9xitcKEwGZ0Scke0xKvBPTxAVfXk2J7uYbI/I6B77e2yPHP3ozgISyh8KAX2liAkp+vM
	7M1kk73Yl4Sl2uGQCgeGxHr+J2llpfqfeJKdl4MqWrQn2LdYC1/IK/2HyOWsd6a0QOwbHd
	nl4tJqGk+m1ycIUzQlNePubz1cOTLQE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hhMAysU3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204354;
	b=LZ9DRwaenwzvTpOUU3IaNWpw5wmNNF4I3/V1wgr6UcUweFMUZgwf+9Dj1faLG1uqbqdSHO
	sExxj0ypGS34gTIuAFuKBOTw1mwaEvKVaJfUO07qehLpHh4JHaOlpP/3WJ20+t147pcf14
	YTX2VmNW1cRbqKj+cPtl6jBe3sOZ50M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KAvxKIc7u+VLwf84k6RTe+SeHDFfmq7KjI9tZXUvvBjevVcOcGNn/EeG1pxAPSpKJESYsEcKx1domMbjyKsc3jD6JTAUJY0UT0EN8nrwQ+c1pFojUGC2D1QC3pHgA7ygw0E8Mwj9dUrODoT4vAuUnNFcuYR/+KpZJX/v0iii09njS7olSu4WxjTOoDLTeIJLDhD1rhp7RghzTKunyIgib9Vfp9o9dVA50zNvho9NcDxigVdKaLS6rm6lplTK7oshTfAU9AkVCbhSK5Dct8hSw8+0hC+2eCsEl57bxiDrwWJ/+mVMZjep7Fdq+5TsYReNPIwGRRbi140RV6YaIAraOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fw3H63mFOM5wM+X5HnSTRkGMbpfnfajuq1vd0Z/41I=;
 b=MTo0yUxXOCwzV5LyEsREXS72h5dakA7E1vI6MUkO/LHRvG9hhWQ2DvlWN7DS5JRFt1H/G/Z1InS2hgQQfasfB0Be85mHH/X+HDb0QPmydxrC+SwExZDyh7c/nwYfUrExe6s+tZ1ItPZk5jhE2J57+SFJbyKAecbR6hYKWIj/bK6XdlWEIWcR1RHLdQXU4uyJbsR/qcv5DIUSWthII0NXUmytDYfKWNlTmbBNso3WK/NDAA87WYUgoquIjisrMLYA2l61cU0UTM11Uw3cqtr9J7KDN5dpy+RL3bfHA1WpZVax8e63eMBemKSjIHYgRj6GadARDKm+S5jPU+es6wZn3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fw3H63mFOM5wM+X5HnSTRkGMbpfnfajuq1vd0Z/41I=;
 b=hhMAysU3Jho+ptBNp0ouEPbU4jQulzRGo7tFZtj2gLT062tpPkraB1S73RDxgiWNUYktfXZLsgIvRnu6SKKzLclAggH57kGgaZTSbH2jyKCuuwI+KZ6qoqmOD05Cdw1mVVnk/dH2dFeMUgq05nIiZJBSWCgf/zB9pDsCl9tysZURj/oLc2cdZDr4asKlOeeHe/xpbe7wQ23DC1M/P0M+q7OyHjddQ7RP/5gkONMsbfa/NnhOicE0eR+3jhiWvrR/JZQ8EmTB7t2/Xy1Z5WXSp1cVBR6hcGGHcHEfiTwk9zPAS2UuWpySlXFOydpWq5IkCg4EUcT619Kbi6oyJv69pw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:40 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:40 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:24 -0400
Subject: [PATCH v2 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-1-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
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
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0095.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: a207c8c8-1b96-4e52-509e-08df0795a452
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	9N4+k1uT9ztyHSu/4Rq8zYM+D/w2+TtUh1iuiemo0bCul8Hn7hsEx7nEsxUjIDYRuVsc/X270qFHbHeywYW0sZ2Hey3XheUmHXYduka7WXYt1ewVbwC8BMyaRMSTcnWl0RugvFHE6Q08FjXfV3Dv9A3fhg4gmVr+pc4+/gG1y5UGBpXv5dg61t48jsDoZhYPO4qZbV88K8/+jsOGlr/UEhjLSiNI/i5YtivlDH4p6zp9wqAOFfrzrAFBXvFsoBQAhwbI+usgQMtrvmClnpDPAOngTuGwNqzhV8Ek0MP3hQOmgDSF/yp2qH+ERnZC7hZTkcs1cZJSCAuHUuQBI9MU2Wjge2WY1e9+a2FT4GIJ5IKTnovrzCknzQg6cGr+/M1HONDUlgWqY782rQ/CtTn9iDWQRJ6rxYAUWPWsiuM3YhU9Alx5xOYREhzCo1KC8/zabj/PMGy8InMmz7fORYj7PB0G37W9qRZfffGkxJjwDXO/TlU9pizIBUEhlL4uFoPkRTGJswWTTxWziMruNFcJjlklPc4CXlVSgLxLZ6Sh+M4ftZYzTqql01Kr7HbIOVwN6ptoqAHEnwbZecHNZs0ra2uqJOxtJl3Q+ASAomnXRikDLYtc26nELBWZ7ZvK01uZi0NM6KXBD1DcMDQuplOC/2KCtpfdnzW2L2EsqzYHXBFLmioZlPoQaSkLvg6H6dsg1438MLjPssWsjQn29OL5gQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVIwMUZ3N2tBcUtNWjd4OVJLV243R1lrenB1a0dMeTZjUzZKVHVWVmxkSjhT?=
 =?utf-8?B?ZnRLNUtTK0RpckkzQ0RYb2pmcjVjN1FYQVVrLzUzOHNpckVBL1dHd2JVWm9V?=
 =?utf-8?B?bkJhdzdLTUh3eHVuWkRJQVcxQTNrWXNVYWUzamh5QTh4T2FVRjJWenNkRzdx?=
 =?utf-8?B?SXo1eU1JSXdudk8yUGtRaHRxMEpDMVFYY01wWVB3a0tEM3FLbENqZ09wMHFP?=
 =?utf-8?B?MUpmY3NabG5MTkZuMzJWVVlHL245OVY1M1JQcldEb3U4SEJma3dmZ3EvZmJv?=
 =?utf-8?B?RnJYcWNxZ1lwMjRxZGR1Z1U4Skp2cnI1bjZudHFhc280NENUS3VSYnQ4YU0x?=
 =?utf-8?B?NklPc2pIZk9TUG81YTlOVmYzSzA0VHliMXB2dWcyemFINGZtYjJRanRhVTR5?=
 =?utf-8?B?bktsV2FGejMraXAwS0huU1Zid0FSTG1rSlNPbURXQW1NRGdhTGxXV1o3YWdl?=
 =?utf-8?B?dDM3QmJmUHdXbDBKK0xOTi9RM3BUR2hnY2ppTDNETGFNcjcrcjUxS2NWaFY1?=
 =?utf-8?B?NUxMQyt5NjlqU0c2bEw3Zy9CS3BCY25MV21PL0ZRWThqQXVsUzJvcXcrTW92?=
 =?utf-8?B?M0FPTGRGY0ZwTFlTSmhrajEzTStSc25tZW84N0x2Nzc0VzQrQyt5cmpGaWtm?=
 =?utf-8?B?STlzNEdoNWNlVHBEb3Y4eG1TZ3lIN2NiRTRyVDdOeVFTYnJCeGhKRmcvcCtM?=
 =?utf-8?B?V0o2RENLOUh0ZldSbGFHQjVCZ1ZpSU9KKzR1WFhGMmNkYWJ2MjUzTSsxb1BN?=
 =?utf-8?B?NTZYczIyM0Uvd3NUbzJhMHpBUFcyV2M5RVloMHpiL1MyTUhFL05vYVJUVDVS?=
 =?utf-8?B?TnQxckt3Z1JOTDNYMnkwREQ3NFBRa1d4RXIyaldyKytwTVJHaXYyLzgwcTgr?=
 =?utf-8?B?UHlncC83YlJ1dkVMU1VTWkhUVTJjNWZkMFBSdmhRLzB2U0prNlBKTEhncURj?=
 =?utf-8?B?b2ZuYWZMRHIxMERjVVdRSUNUSHh5VHVLNmtDZXdoQUt3ei83L2dtQzhvODM4?=
 =?utf-8?B?TG42cUxmMDhwTml5a2tuK2lXNGFzM2RjU3V5Yis4NHhJbGpVemVXYjVPSDJS?=
 =?utf-8?B?V3hkODVDS0U3aVlTclFEdlhlUS9odUpyb3I3TElKWGc1NDJvWnpyY3RpNkVh?=
 =?utf-8?B?bGJ2dzgxSTAyVDl1R0ZWeGR2SVZEMlF0c2lOc082RUdXMG1GcUNpMGpCSDFt?=
 =?utf-8?B?NXk5RmFKaTFiRTFnQ0NNU3pxZElpSXprL2xzRXlKKy8yMUU4aUJ3aUhTUHZu?=
 =?utf-8?B?OThjV21iM2JXdE8wMmdPZXdXYW10aGRiQVk4eklKV3B5MVpQYktRY0w2SFlO?=
 =?utf-8?B?Wm1JUzZKdGNRd0xqY2RwMXlnUDhJWUhRYWFScXlEVUpiVmZoMWJINW9ycnpV?=
 =?utf-8?B?cFJDYlczZk9FT2ZUZis5U2pubUhiYzlyazhGd283SVlhYjRTaFdWdzNNaWNX?=
 =?utf-8?B?VEpjeC9mVmZGa202V29SREYzVEF2emFZdXJnVG9SM0ZaNU5iak9vb092VVNX?=
 =?utf-8?B?WEZWbDhJRXJiWDFRczF1RTZrNVJFdm1scEhmVjgzcUdualc2SEx4encveHlF?=
 =?utf-8?B?amhjQVdNQmJmeFl6SVZ1UkFPeU5Ebit5MDBHOUU0NmVXQ0JQbHJzdTlmcmYx?=
 =?utf-8?B?WlEzY1NPZDdmaU1BdWR3a1BRUUR1T09UZ0x6dkNJVjlwOHowcjR5MmYxbVpp?=
 =?utf-8?B?L0ZqUTdJYWZmdWVoRFdCR2hhT2ltc3hVYjZNbDI2a0Y1MkRpcEhSWnl2Q0Rp?=
 =?utf-8?B?cERwOEdsNjRKZWdDT0pGSjdSYys5WUFINnRFeVpEazJqT29qa0M3eUtOZDht?=
 =?utf-8?B?MXk4aHhmM2Ewc2k5eWhGcFB0Nk1la1BZUGdycUczN3VWSlJuVW1CaTNnM1VE?=
 =?utf-8?B?dG5ObEV4OWVZWXcvdjgzc1RmMnZvVCt0bk0yMUlyS256MjAvWnZ4cURKQklL?=
 =?utf-8?B?VXQ1VmtUZmpMVUJ3d0ZwZzRjclUvUEMvMlJXa29VU1FzV21rZ2tOUExZeXBL?=
 =?utf-8?B?QThnT0RqNlF6dUwwVlJXKzYwYTJuQ1p5TkE3bkdBOWphVFRjM0U0K0dtWE1t?=
 =?utf-8?B?T1RxT1paUUUwWFVEM2Z3bWhONWJXQytXaDVPakVwM251MGtHS2FybW13aWZF?=
 =?utf-8?B?RVZUSjNqbTBNSzlaaHVuWlNUWUNOZlREOC80SlMxVUk5aTlrTU1IRE00K255?=
 =?utf-8?B?U2ZtWnB0NGpEVW1RUWVDZElmb1lpaHMwRUdIanhpcmFZeVNxdys0VHQ4MjJQ?=
 =?utf-8?B?MHZCTmhKYTlMTWh2dks2dUVmUzZYbmltV1drMTJZOHIyb29zd3BPaDlOYzJE?=
 =?utf-8?Q?LTrSKg/VHbWTL9p22E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a207c8c8-1b96-4e52-509e-08df0795a452
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:40.0138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwDsDYvakaOWEylBL2z6PSFzslmfq8aiwaSLmdG1wgxBp6GP23kmFuBbx8FMNOIj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0352160003
X-Stat-Signature: xk9pq7pt9xsrdjoh1jp456fuh647xugb
X-Rspam-User: 
X-HE-Tag: 1788204350-37538
X-HE-Meta: U2FsdGVkX19eAX5V4vWidQ/L9/n/ouBepbtGZHS2ge4K9ilUHQaYYF41bXjcjtjVpSOIMv4DJxUTS4edPSNUSY86r3TSMTWlqbhaTm8H4jqpFuPT1bd3M9sF2guc2Ab4P41SwyEsaazDe0THps4irssSOhZt38sCGugYKCXRyQRbfCgpY4jnIoAbc/yA49AR6GrP4P5lBQBRDQDywcqcYYv6JNO7y5b1ZgbTOEtY24VxdiAuAf1Lmk3PhkdLTyrItzIDF2kDGDc1ctMvO1RLFFsVi8hnZT2uZk64adkzztrS2oGmAv4PPF6q9DLSxag2dtOJKDCnKrTL8L97a4XpJ+Co65vnJnlqlpwz1POhijKsw0r4cSasOfvrFOUfTPb5LV20feRnVX/yYZGcOxjWnwELZpCMMxBgiNdUye8oyiQJCDkDK3mak7yK0bxb/6IJFHfR1hf3OPry+hbJpFzvoXExtCKeUUEG+//nCGxbVwJ1qOH/i2BBbetUhAyrniU1i3hGJ1ieeH4l79R7DQeNQ0e8jgx2E2yNHHaUmuaYaKL6mvhVqlPEmydcRJS2IC+GhkVdS2bZeAh5CDwZxpjYdIy6OdoIhbRpk6bKGl8vSy/tGrqCrryAVe26FRv5OmxJew+rH3mRsjjOppOXZ5ABGSuxobRfwWX0eJE2uKnqaWIzyNbvxin5hsiPWEMYwFmdUdmtM9DvTiQfkGXXUrnSNbaw4bGE2oWKkeQjY7Py6IvaDx5aRddBFtC6cA4yNMoQfzxFtKe9s+HrlxL/PRN7tnDmzxZZycSh4nySrufI4AStsegzOqBrgvLFEcPjvHQCJmIoL0BA2v9+fEQKOvCqL/AazEqAZGivJMfMh4X7wy2njoM0AZ3/bD7TfSLLg2dmfqQnozW2GdEJvGeo1uduFjljG06kYorsxm6S3ccxS/PDE7K0ApIbba6eJ+gISoo+2tIUug+j+fRNQz8aaFC
 J0RRkiDw
 N8uFE9/7xfNbyzHfMclHhHmao+G9H+2JSiGuFHcQV0NnKqQmAQaMiy0fDEhEdpIgC9m8bU/ac4lPFPC+8vxyOliX0blicMZWTRBTJ+tcMlCGJtyg/R2angniEDbKzkT4dzrM7YdDQf9YYhUERAMJAO+2MN1Sx9yIv235dyxuC7KlUN1XMwpJP2uEib3y2ZGJcFTPeiO5wt5MZW0Xqzn+gp3zplZpKp/A+c2iiStJ81xn9kshuDjDARDhmp/DL7gKhDm5QHX2abXsg3BQ2W2OcuxIotwIgB3T/uS9mDzAKFISHRuf7q3Tie7ZIGi11bhn9OEQBekqqrLouHRq7o0DbFVbgSu2LvmoBakfmyar4TpGRtd7m9AogTAO27+2kEi6YrYZ75kZX1lBYA+4BuW77yvb6s1PPbJX7AZOG6fWUTu+7ovyhDPDo4j9yZWJYfFHUDaknaVdzUPT9CJ9xEK+2QFE0sPMMqIbbexQWt65U0pKwaHE5N5hWu9g4HZ0lTufKaFtNLMKqe71w1aCQPbmmniqAIW5homRf1g5oXRCdAoRVAporbsH0j2m18pr1CAcLSPImZ28Qb+inv31vlHEwDUJzTDACjGVxotjBDI7WyzImKwutGHTwyOrk06+Yvq2z4+OCIlb4oxiPiLdc2K3HPxtORnyWKhtfmo30
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
equivalent to check zpdesc == zspage->first_zpdesc. Replace
is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().

For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
requirement of a zspage chain, where all zpdescs point to the same zspage.

is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
should be negligible. While at it, change VM_BUG_ON() to
VM_WARN_ON_ONCE_PAGE().

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/zpdesc.h   |  2 +-
 mm/zsmalloc.c | 24 ++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

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
index 825022a7a328f..24526185fd31f 100644
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
@@ -476,11 +471,6 @@ static void record_obj(unsigned long handle, unsigned long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
-{
-	return PagePrivate(zpdesc_page(zpdesc));
-}
-
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
@@ -496,7 +486,8 @@ static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
 
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
+	/* the first zpdesc must point back to this zspage */
+	VM_WARN_ON_ONCE_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));
 	return first_zpdesc;
 }
 
@@ -838,7 +829,8 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		/* only first zpdesc holds the handle */
+		VM_WARN_ON_ONCE_PAGE(zspage->first_zpdesc != zpdesc, zpdesc_page(zpdesc));
 		handle = zpdesc->handle;
 	} else
 		handle = *(unsigned long *)obj;
@@ -853,9 +845,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page = zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1006,8 +995,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
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
@@ -1015,7 +1004,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 		zpdesc->next = NULL;
 		if (i == 0) {
 			zspage->first_zpdesc = zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
 				SetZsHugePage(zspage);

-- 
2.53.0


