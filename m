Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE7AC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 20:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EFD6B0113; Wed, 12 Aug 2026 16:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56CC6B013D; Wed, 12 Aug 2026 16:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9454E6B015D; Wed, 12 Aug 2026 16:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 698446B0113
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:10:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2FBA14048E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:10:24 +0000 (UTC)
X-FDA: 85093709568.14.C1F9BEF
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010026.outbound.protection.outlook.com [52.101.61.26])
	by imf17.hostedemail.com (Postfix) with ESMTP id EC97B40004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:10:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FhVJE3Q1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786565422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yt5nLK9TZwZlfK5MrUus1dOU6QWg8+fs2SaJmfVJKpQ=;
	b=tUGiWUeWzYY68eIoR76q5Cy6tpNZgg/BmZoLkHQ3D4WAY8exQeZS0V2zOJmhBCg5hwcN1s
	lbmyXK+bGB9KdrNaLIsOCyg34dF9TRfCPYBKbP5Ks2t3TOpSEiameBJdrtKAh3nvw+N+FW
	Nkfvi+FTsAOSUDbqbIAfKt+yA9LySyQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FhVJE3Q1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786565422;
	b=Q906gDyZxvwtPeGb7UuXTcRgj4Rdkri/ZXQ005zehWNMD41fjWL+KyAYKbrzmagLKJLc2y
	Shn6WwY8DlO5QvGc6Gg3644Pa44bPr36RerDA9QezI1RXyh6bfM9c6IUO2QMiiHcYzf3hA
	Dk2xxFaIu+c5n6CRew4rvHwUKIIStzE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TsP/+0M0h6NRa7aOA3UCpwIkq96msGvKkZ72DaisxPUSsRp9ktRW8FpJeMa9wrHP5jykSTOo9YcTd96Jg3tt3t6ouWyxH3CpQVirLtQTVxzWkPnPATj2mnQ3PPjojFPvSg6QIuAI9ulIT4pxBJ81WuQE1jWUuNonG9K5GZ6O5UbMYA8gTliXHNB8f4CK4Q2aGQPABt/dZfGwjWAbm51GWkQ04XPN6W9ArOAWhTR45C4HVhku4CULLz9txbUJSYjHP0pE94eEb33ZrmNG+N4b6WY4XyHHM3cjeUlZDno6fxxN6c+Nuf+OqvZfzXGYY9oeJZVlKYOQTdJIk1POFhRZ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yt5nLK9TZwZlfK5MrUus1dOU6QWg8+fs2SaJmfVJKpQ=;
 b=FovmcblcltvirXWhyk/h+WBv0hJCf/6ssYAnkRnFy6dKnbebrzG3H4Z47lMVcTvl0LRbcQ4WG+I9iRJPCU3sj2gCi/SG+fbvJgcKMZUmHt7G9MhDb3iIiTShtWX0zdvtQO0Fu0Vucv0dCD/AZB2/SB+vekmcfA5/q9AEDHR/luN5xgJkWHR/OvOIOzhq6QnzlB8v8rJCleZpOIhoG0fR2DGxPN/EoYx82GI4vuBLuGZUsyeHs4B90eaccc8b3jADPizZdlyAgrJDgI62+slDlrog3OD3fXa20ugt28BZb/kgkXJJ1F1y6o8auB+Hl4wLz0YKuEuCzSYtYtvTsSfq6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt5nLK9TZwZlfK5MrUus1dOU6QWg8+fs2SaJmfVJKpQ=;
 b=FhVJE3Q1eewe07t2UOcj0b3KIEHiX5NgT35pzvilAx/BakT2vxhcGBpMNj39mrNYm99st1L4s6uExRABH/JkU4LGD3olYa+hC26eg+JqCLmimq8VuZw2ygtIUF3De7yhDWBA7YxJMqUf41gah+dyJClCJXq6tMI3GVIlrIhedziLLxXK9UeGaceGqXdHd+5p88w7KhYDkKIf7XNdrDZM1lFgsvZVPqDmRi45dLc4bDn38ZBqECP4BCF+RmF1wEH/Ghco9wzkJBNiJ/O+EulyH9LDoszVlRouIyE26VA8cUnf3BfffnEmLkfl2cSdQ+kJsme5NCqVqVkutqZdMIbtXg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7264.namprd12.prod.outlook.com (2603:10b6:303:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Wed, 12 Aug
 2026 20:10:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Wed, 12 Aug 2026
 20:10:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Aug 2026 16:10:07 -0400
Message-Id: <DKN8KXM1XAWF.2N62FWNIBYMQU@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>, "Baoquan He" <baoquan.he@linux.dev>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>,
 "Jonathan Corbet" <corbet@lwn.net>, "Jan Kara" <jack@suse.cz>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Dave Young" <ruirui.yang@linux.dev>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>
To: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 14/14] mm/page-flags: remove PG_private
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-14-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-14-142c97ba3562@nvidia.com>
X-ClientProxiedBy: CH0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:610:b2::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7264:EE_
X-MS-Office365-Filtering-Correlation-Id: 57d4e04f-3b14-4192-10bb-08def8adb6c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	N2A8ol8XyrTdjQ+xpCQYUfg0h2EkaVKPzkZsKU39aGrwKpMaCeAuPtzyIhk/LRo+c+W8w48Cc8dshifaff9AN0XM0meZJIh8RQNlhpU6FSlqm5n6S6UVO54D4p8g4x4ofXHrZecF2sAg4/WgyT7j8nyuE1FcjhA2iTvsQKUHlC80NmIJDN2Kn7SgVR5FWkeUNO143eHo7ItwHsul5oYBOKYCREkK3x6kKyV5VTq5fyGwJCd0Hef0ALhz6vsaCEDNgOCgEPk1MxnAo6LFtp4x9lHjoV2/heSuylpxJ/j0oDX6r4BX/64qWVHZiZFf5zGcUqpqJLbERrngNQBUB34kbcg9xAXegh7G1CDfmwIifTTPQuyvHgiIu2kTsKFZ0EU4ErC0wR9u3c4DZ1R7aQEh9M6h70DOjaytXbhYJxI0kHdtMltR+JCf3J/1sfRgbEi9pfNr8ZRobS09RpdaxcpLqVVFo3qNX7nppbPfctVuzS5axnbefM1Cyi6GzXvhAkLmfv2a/KSZKVbKt8ZQ4Qw2irmbmD5DJxVagzKXasJ23h6bs/6NHp39UyqvbyzppJryhEuLf+q6vO7mV2By8VEKU4l3UPExrttiWVMfUygv8hzZMAE4srXFhW70G4yu54aHCn/lrXeK+g5TMWK/OxWwIAYuJLYUFE3jAE0Pnd1jGgF+T3SLLPu1y3ZW5yQdeU8PsJDxcMOZv0DOzla8R0pYjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U01BcWtNSUgrQ1A5clF2akNjTXRRdFU2RU5IWUxiVnFYK216T01PWjYwREli?=
 =?utf-8?B?bDJ2dWNyWEYzbGdGTVdvdnNIRnZJVDl2azNUR3c1MDhYNmZ5djlxWkZQeHlF?=
 =?utf-8?B?MzB0TVVVMTVBbE1oUVNySUlFQ3grY1AydG5hdDVDZ3k5cG4yWk52TitzSzI1?=
 =?utf-8?B?ZEVJTzc0Y0NGK0t1SGZ1aU1CTFFvNEJWUXpYRnJDdmlXN3RlUHV1cFBlWG1Y?=
 =?utf-8?B?VDRjUTUwendzL1J0eGY5VXgya2gwZ2dnekpmNndRYUxXajRnU3pmMnkwQnpL?=
 =?utf-8?B?aGg3OS9QTGx1NGRrVmE2K0svV0dUZ3hKK3VlRXlQMWJ0Qzg0bXJwN0dEcFRR?=
 =?utf-8?B?dFErREltL0haSlV5NTVvZ1E4cU5kdUpnRkdwY04rUVFYZUh6elluSEJUZS9s?=
 =?utf-8?B?VWIzNHJ3ZFB2andIenptaEpzc1VjaEVxWVV4WnN4TTBkNk5wS0pwWWdsUzJk?=
 =?utf-8?B?L0RweFhRUFE0ek1pYUdIVlNXdjg0aFR6VzhIUk1IVm5Eb0FjVldVc2hMTjRK?=
 =?utf-8?B?SGVPMUxGWGFqNm81NkRJY0Ezck5KaGoyUDJTZE9kU2NnSGpFVFNWL0NndktY?=
 =?utf-8?B?Yi85ZmxQdkN1eTI5ZDVPcklNT1Z1bklWRGdhQmJLQmlhNlZHek9wbEJSazc2?=
 =?utf-8?B?d1FwVmZXQ1RxR0FST1A1MU5iSkFUQzlSUXg5WUlhT3RLWnVnTDlLazV1bW1B?=
 =?utf-8?B?dXZkVUJVMDR4eGJvVEF5d0o3N29NL0hwZTJDMzVKTXh6NytDaDNFUm1tS0Vw?=
 =?utf-8?B?S1NDYy82ZDBWNFlBMXMyVitaWHhOT0Z3Rmt1QUhpZHVHcEUwSlFSR2xEdytY?=
 =?utf-8?B?VS9hclpNREo4dTRwRVQxZ3U4YWFCeWZhazZTRk8rMnVCcmRqMm9tenY0QWR6?=
 =?utf-8?B?b1p1b2c3NTdlb295UDJXdlh0RGIvWTMzdzBTU0hZenVPYk5PSUp4QmdJeW5O?=
 =?utf-8?B?WTJZdUoxL1JTQlBSbmlIampnVkhXNVJXbVZzVkxJUWl3VTZVSXRZdEIzYVhN?=
 =?utf-8?B?SFpHMExpZVN0R25PMWc0MlVNN0lmSi8zZUc1Nk9GdUZLTkE5TXJ4aFl0VElS?=
 =?utf-8?B?dnoydkdsNzRZN0pzNS9wb25HUy9rcU80LzRxSWJVZjJmSEFLU1RMT0dvS3hI?=
 =?utf-8?B?K2R5VUIzbDlEUDhoNEFib2R0dkJHUXd0UmtWa3BHSm82Wm1TNCtBbDd5ejNH?=
 =?utf-8?B?S2M1RENMMjRTK1AzUG9OZ3RMVGVKRE9aWmtBVWZyUDBTK0RXdFlzdzZtMnlh?=
 =?utf-8?B?VkRDcmNHN1BsT24xL0lqZHJJVTg0UGR3VDJ6bzMzQkhqdjRMY1FGWFJScHQw?=
 =?utf-8?B?M0dxUjArUjRtT2trQm5YUFRWQjVnL3Rpb0JsYkJ5bFpmSkJzd0RiWVFrelZl?=
 =?utf-8?B?bzlaSHVQVXdtOHFUK2hLOEs4NGNPMFhRZW1RZkN3NzA4Qk0rVVQvb3hVdElF?=
 =?utf-8?B?Q05NakdheEhJY2FzdVB0N1ZEelZ6WnJ3US91Uis3ejBzdFJ5akc2L0lNWWtm?=
 =?utf-8?B?MlNPaGJ4NjNhY2Z1ekFONFBVd1NqcW5xa1QxYnNhZmhVQUtPaXZMNjI5R084?=
 =?utf-8?B?UXBaUzlxTXk2SGVXSjNOaThkN0xTaFhRbHNMbXJHRkk3UTM4b0pnUnByY3gv?=
 =?utf-8?B?dDBMZ0hTRkVDUnhwVStSekhTUDJEdXpkd0FhQ1FocFJuUmE2VVZ2ckNTV2xv?=
 =?utf-8?B?MnE4SFZRL0VaS0tXdkdydkRCZC95VmpTaVpwVHNBeU90blZwbEFvY01JeWV4?=
 =?utf-8?B?VmNnWmFJcko3a0F4UGFtd1I0U2hQakFPZUx6Nm84dWh1eWxZQ25LQ1h4cHZD?=
 =?utf-8?B?TWYwRU5VUVlWQ3NrbkFzQytmbGxJcGJMZjR6L3ltNkw4eDRhOUFxT3BNV08r?=
 =?utf-8?B?OGxuSiszMDFIbGRWMlpIUnphdld4cFdqN2VGNlF6MElzZytqWStRRElyRytQ?=
 =?utf-8?B?TWNyTGxQZ2c3UWY3eUZ6UU1WOVV1UHNEdzZxd0NLRFBYUExnRkZQYVQvd3hP?=
 =?utf-8?B?VnlqWUt6bUZOSVhpc3I2NDZ0QUJPZFRaUkR2OEJyaE12T3cwaEhibERyYzk4?=
 =?utf-8?B?eXAwaE5ZcGpPMWZhVmlaWmpXZml4S2RKR0EzOFNzY1RMN1pXb3o4WnZzbEFa?=
 =?utf-8?B?UVhaRk80Njh5bUl5RjBNTmZCOW1KejJYdWI2ckU1clZ3MmVqRHlmanhrdzNJ?=
 =?utf-8?B?Wi9tZkJFZmRtRWRDa29RT1B2R0ZUZzFhZnAxUnRpRXcyOWVja3FBY0ZWMEoz?=
 =?utf-8?B?QUtZNkdKMnZrMTV1Q0RwU2EvbWFmVFFWRnZWdXpCM09HZlFxay9FWTZlQWdj?=
 =?utf-8?Q?n+k4MpVd23+QaZsuOp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d4e04f-3b14-4192-10bb-08def8adb6c3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:10:11.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESrlsx0jfYAy2v/p3CLd/+I9g7kWMZSqYZNXD5/yEDLcS48YtMXl4W7xbGzLF76b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7264
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC97B40004
X-Stat-Signature: fxtsbd7ty8hr3wpae8qugbwr4rwzxcyj
X-Rspam-User: 
X-HE-Tag: 1786565421-886749
X-HE-Meta: U2FsdGVkX1/1K7gU0bGs5X+w0KlvQiIKBxXUv6lIrXfyEnRXwwI9WO+wBGvuyAkssP+SgyNsJ86zt3hqoaZae6SUg4r71d+8UQ9BxsjpDbMH8O8zY2nDWHvcK5BtxClKgLNwYY/M93Njq6ZgK2H8NKU22LittlOQqW5EwU2vnSJuyV4bCDVxngz5yVyzy5H9681EJmWYAeYpN1xaCsj5wP/hEDnn4foRJEAIL9ylP4zQGXBSKF+H3Qt9kEKeEaiEzwB2lGMio9eFxBS5YqsCQuzcxfJGpuUk8pGdYb9sqHVGmYutV1k3zIXq4/TCMi7BbaRm2f+1DxMeinmnoTgsyWve/Hqx0D5LOd2MdR1a+Phod1fod5Q+5e4D+P+DdDPEN693iHRG9c8uriYhHwPe9djYu3AX/6+bt1Go9uzHVh33egY76qTjulYUD71+43aIMk0M0hoxhY3oa1aExRXwI4/E94mb96yqufyxa9TNd5bDUtQOZ9aN0qyYr9+82Gdh7YC9l3JpX7DQdhU0Luj7BeG6thIdL2ag1ohz8wjOZoAf79oeRmeh3UjD/0ZI9MrIhwX89g0iiLBrj1W80MaEbT5LYTMAXq8ovNhIQUDmpP6Cve8nXJkO2qyS3pdBdQaGl2mrmjNiomkYdQNc/A2CqA30494njAWKt9mLukUDLLNJy8DVn2Me+LOk1ZkN4iVpgFliY/U2A1Iqo5+DoFwHnLfVWO9ULHcbj1uU+ONu+2SYRQ3pq6gALaezTjPX5Nl3eFkGRlzjcbBCaf8TU6EYwxxtK+9ATO+l+GYjGNHBr8b2AQhVDO++qGaZqSlTwp4cICPx6FDDffEZvZPlATitjDTd4DZU8y7x3oNPnPYKAnnlOrHi6bd09mg3hn9zJNKnHBhzZRd5D1xHXL/znGmMuuqoKWUSuj2qVdm8dAvjt3GxocgWenmkCYYTqBV9A8u41yPhNMPUL0curkHqj2v
 /2+F/dNk
 eTza36Ig5keMP384Ro0lOJTfErHe0ttawTe2AdEHh24pXih0A7kz4WW5OIaOCpHrLoXv2ttGOXzUzc4qEjn1bVH8R+VxVFheUiRjHu8fPEsAxinDot1sb6cyzvMbhJdZ53WvdaxG4+EO7H04OfKed72JRQiAXb16doyEzBhfg4NJzO0iXR9DLt/s4HmP/5ov4WRULDWmARxEtHDiZCY7TodCYGAmcENCABU2vHAy80FZePIogno07S+tolHt3cvfFyYZsimeiN2KCQhvPZG0uORU6zFhcPIGCcInb6C8dTPdXh7h+jtnUHdCZQ+g8F9kTZQovoU6awCK9QtVBIt62//hxc8Q5vMPTI2TieyCwTR8dIhN6KSW+YDHWOp6Rm3GDjSdhNZx8yy+8FufybIx4HD1sezjqI8oEafbobWGHDb58TYG3g2HzvZpzDdehQUePSsLixyVLxW5Bk4GW6oU2meiPjlbx5+gq0jhwJzguqN7FFbj+JBu10MTxdHYGp93YkF5QvHYR57DA/9U1FxjmwK8ERKK9BkV/bonQvqfHOtbkywnyssSu9+EPFGWlsNgoIQWUauE9UYzcxxPFxuKJYVvzoFjiTF6RWdBKo5T8rNP4ZYoHNmNlhEqxdc6VYYpnwfRHbX/KYmbfpSkDRymhygCq5r+XO4rJuaxAJjwGAN9Ue5zcdLDs54OXPfQtFGWZUqIDMAgoEodc2R274ls3YEif/soj4+pmYGRt9h3iWXHR6hzWWNyKz79qvLzuJ4Rckxr/mt0lxxbHeZ5GYhQvqeBTz/+pKu56pFESqxaMxRKrlaM5F9+VXRphiMacEN8kW8CmBhgjwh2SHB9+3OQ4u82QjQH3RCT9aL3kzH2Z5ohLliUUdwEpRTKSjbsKIlgqfcwx/7a2HBi3vhfy4Ro/6i4HdHuEx9YtB6Wt/vwUvDaYNvVmHwsDe4gVoalDPJ2r1pqwOUR6/A2kUa/h9feiiRQgVVZF
 RW+Hy0DG
 jbmSreTOSNNGes4yOhJzo/dGrgxzU5mSnOTcrOxPwZMQpzCJ3kcaeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 10:13 PM EDT, Zi Yan wrote:
> folio->private !=3D NULL indicates a folio carries private data, replacin=
g
> PG_private. All PG_private users are converted. Remove PG_private and
> reserve the space as __PG_folio for future use.
>
> Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
> left unchanged. It should be rewritten.
>
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Baoquan He <baoquan.he@linux.dev>
> To: Mike Rapoport <rppt@kernel.org>
> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> To: Pratyush Yadav <pratyush@kernel.org>
> To: Jonathan Corbet <corbet@lwn.net>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: kexec@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---
>  Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
>  Documentation/filesystems/vfs.rst              |  6 +++---
>  include/linux/page-flags.h                     | 19 ++-----------------
>  include/trace/events/mmflags.h                 |  2 +-
>  kernel/vmcore_info.c                           |  1 -
>  5 files changed, 7 insertions(+), 23 deletions(-)
>
> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentati=
on/admin-guide/kdump/vmcoreinfo.rst
> index 7663c610fe901..5f1df6d080508 100644
> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> @@ -325,7 +325,7 @@ NR_FREE_PAGES
>  On linux-2.6.21 or later, the number of free pages is in
>  vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
> =20
> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
> +PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
>  ------------------------------------------------------------------------=
--
> =20
>  Page attributes. These flags are used to filter various unnecessary for
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystem=
s/vfs.rst
> index e7677423a20f7..5cc07f82fe371 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -649,8 +649,8 @@ Writeback.
> =20
>  The first can be used independently to the others.  The VM can try to
>  release clean pages in order to reuse them.  To do this it can call
> -->release_folio on clean folios with the private
> -flag set.  Clean pages without PagePrivate and with no external referenc=
es
> +->release_folio on clean folios with folio->private set. Clean pages
> +without folio->private set and with no external references
>  will be released without notice being given to the address_space.
> =20
>  To achieve this functionality, pages need to be placed on an LRU with
> @@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to=
 complete.
> =20
>  An address_space handler may attach extra information to a page,
>  typically using the 'private' field in the 'struct page'.  If such
> -information is attached, the PG_Private flag should be set.  This will
> +information is attached, non-NULL 'private' field will
>  cause various VM routines to make extra calls into the address_space
>  handler to deal with that data.
> =20
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0e3628ea080c4..eb2961ed61018 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -44,10 +44,6 @@
>   * Consequently, PG_reserved for a page mapped into user space can indic=
ate
>   * the zero page, the vDSO, MMIO pages or device memory.
>   *
> - * The PG_private bitflag is set on pagecache pages if they contain file=
system
> - * specific data (which is normally at page->private). It can be used by
> - * private allocations for its own usage.
> - *
>   * During initiation of disk I/O, PG_locked is set. This bit is set befo=
re I/O
>   * and cleared when writeback _starts_ or when read _completes_. PG_writ=
eback
>   * is set before writeback starts and cleared when it finishes.
> @@ -105,7 +101,7 @@ enum pageflags {
>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>  	PG_arch_1,
>  	PG_reserved,
> -	PG_private,		/* If pagecache, has fs-private data */
> +	__PG_folio,		/* Do not use: reserved for folio identification */

Sashiko asked how to detect leaked filesystem private data during page
free time after PG_private is removed.

Answer:

After the conversion, folio/page should have an elevated refcount whenever
->private is set. That would help detect leaked private data. I tried to
enforce ->private needs to be NULL at page free time[1], but that might
cause trouble for certain use cases.

[1] https://lore.kernel.org/all/20260223032641.1859381-1-ziy@nvidia.com/

<snip>

> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> index 8614430ca212a..5a417f8a922ab 100644
> --- a/kernel/vmcore_info.c
> +++ b/kernel/vmcore_info.c
> @@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
>  	VMCOREINFO_NUMBER(NR_FREE_PAGES);
>  	VMCOREINFO_NUMBER(PG_lru);
> -	VMCOREINFO_NUMBER(PG_private);
>  	VMCOREINFO_NUMBER(PG_swapcache);
>  	VMCOREINFO_NUMBER(PG_swapbacked);
>  #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

Sashiko asked if removing PG_private from vmcoreinfo breaks back
compatiblity for related userspace tools.

Answer:

Userspace tools will adapt to the changes.


--=20
Best Regards,
Yan, Zi


