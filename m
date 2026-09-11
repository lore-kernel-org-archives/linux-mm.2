Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB612C88E40
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DEB6B008A; Thu, 10 Sep 2026 22:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EB46B0098; Thu, 10 Sep 2026 22:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818C06B0099; Thu, 10 Sep 2026 22:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 413AF6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:06:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB2EE1404BE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:06:38 +0000 (UTC)
X-FDA: 85199842476.14.B415F4A
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4D17140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:06:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LmdafTtn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789092396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUzPei/aaVMv0fOBde+MU0Pe4R8As3p3aUp8AA7JYyU=;
	b=xjFXGUKs18rgGWa2EXni2QSJdYXTRafxEoLkjRK30o6j77B4TG2ghH5T7ES0UD9kl7I0Gc
	BcD6j4EodzrbfsCLqG5j9BtZtAGlVV6Tr6KEZYT6C2eiIUF2ToCxqiAOgAyc/w+ET79gxO
	kZWB+jiyMXvKJgVZmt4GYZl7a9DOwsc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LmdafTtn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789092396;
	b=CjtfZKsEjUTbZI6o/xNGdace3bFVqVWsvec0daMgBMpDKcw3Lz9CvOK++fF/G24ZFim52Z
	PCkCMQktXuckT+7KntbDX/YEgRvY+hdlUwdivBeHGBeSKKHl4XSD+bnO5P/h9Fbaj+OhZ/
	uQdYUq+oR8I1909AMYuSN2H+52pHtCo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcWhjDLijNhJu2s6iRWz77FkbSFOpqYnAyLFoV2YFllBdYv3cSzPengJpOMemEXSCsEr/WuGcd/1fksRSFKHsm1xZi+/GNvUSpH510kL4qZ3JZi2OMWAEI3SRWhHj/iInjrJZcETqWqWdX0m8N0jDFLvA08zkgrnZhslwy/H8uMRi9F2ew2ybfVzxVSeuBB+lUdUjtxVsijRJSPmI5Q5YCQwOGBQ+33LMxw4omdzsX6PILFc/EXc4PRv58q8dl+k//VgHGx8Y+N9jSh7G5DSpneig7+ohojUdOpmTutkVv24H1VyA38Co935XZvmKlaZpVnqUK2hdm5M5x3VG/6P7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUzPei/aaVMv0fOBde+MU0Pe4R8As3p3aUp8AA7JYyU=;
 b=G2gledzt7d+ALGZRp55poDLjVBnn9rWwbhNvnIRvaLjsEja5Id1f2A2QJ46E+fLQBK8tHUV8jrumk1kN5Vr45YN43nRY3qW5vYMWDbR80IwJLslUvpc9KikN26+fhxMqycpYH+0dWGEc+lyavyYiyFdg65thYYTdyNjNQAmDoVFuZnFftnlEBjQEl+U1kS8f4aziAfbxV2wj23AjUMRlCHLCsojaKYtN+FZ5jezzVq5hUGVp/UN8Sn2iW86Q00Qgg/tC9/hVbJDer9psM9VxWNvSuEz92H8VLtjQdUUQC7AR91aUwKARUIxSRu17k70cNqjDMnSQ56ZWlRZZMimsig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUzPei/aaVMv0fOBde+MU0Pe4R8As3p3aUp8AA7JYyU=;
 b=LmdafTtnxuyZI2mHGr7Hmspz8TOYBbiseEWqA+v0VyVNQmGiOiQgs3DzrEu2SnjhQJ5ifK/9ce/k7b+w17Wf9J9v+LV7aMhxdJ9GFjFtu/sdPaaFYPYg/v2XVIwIL6knQmAwlM9x9LixcOvUDfspAnsKiTgnDw4MDFEWntc/57td3+lS/B/X2iJZZJrdjB7V5wMgx5oQCG8bRH4GOZmxqy879//A+elj3TkdkWyGKUiWKUN3+rudbv6UG8is5ZS7GoLjcn7eB+k3ox1V37gdlmdi17V4FAMPdcAdd1ttB7DIF/ADU/u2HS3IDw+jHKQ0ocLpKBEFhB5wNqEBVGhLzg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9456.namprd12.prod.outlook.com (2603:10b6:610:1c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 02:06:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 02:06:29 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 22:06:28 -0400
Message-Id: <DLC4BKO9UPN9.2VM6L3Q8KO0NR@nvidia.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 05/12] mm/collapse: state what a collapse may do in
 the policy
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
X-Mailer: aerc 0.22.0
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-6-kirill@shutemov.name>
In-Reply-To: <20260910120238.2529819-6-kirill@shutemov.name>
X-ClientProxiedBy: YQBPR0101CA0249.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9456:EE_
X-MS-Office365-Filtering-Correlation-Id: 6530db24-e409-4f45-f05c-08df0fa94b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|10067099003|4143699003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	nx0YIxUiD192QS884Pm7tVFhyzoELVLrOeyg20QbNLv2PRRUwKYECwPwxLJrMLdld/K9jNV9n2ZyZmHNmEdzjqm3guJmBqgxEmABpcdpPyY8YUXWzJz/UZWo0brVNWuj6JOFiMx87+ZWy/zHe05RDZuae5jYS/7LvBQBVAfT7eg6dbDT7RAKA70zH3jNJzJNAXY7GNIdXdg4uiqY8dT3X0D+DsYEuFImNVAfA6+MgZqHTmFyopAec5zCAI+uCB54Lolh/Nt2ZWTGFULRPL4Q+7zuZ/P3CQETw2bqFbxQyalYrPfWMBp4U4NfXI1sqG2uJ2g5NphCktpYblWvmphz8zWbLVxaIkXLXsxGRY/GwuDKu55+Q6CSbhLBWTuKSQzZAKRk5CnYM6BUygOISrTWdRNgB0rJDYW94hWQJt2T+VWUDouHmaUke2CBU/yygZy79RsBC9wk9BFdn0KzK3J9m4c0iEJbmwZj286SWlZEdm0pIXMTe+LSD1r6A9dwM3MGs2lFBQy5Uu29S3TA1B5n28az2oqe6O98ZWk0iIveDbYcfR3/nea/2+q+OOIHrfDNtS5alwR3I+ZxzCOeS6T50PAcFv0PM/xyQufY2hDrunbUkn+7l/bNMOXTT/CADKGwijq2dbVwI0g8TmXx89frD+Sxw3RCAWJSzr9Q3ZIj9mA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(10067099003)(4143699003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnlPSGxHSXozR1pzSnU4WHBiRHlxMFJqTmF2Y3M0S1djeXV2UGI5UWRmOFB3?=
 =?utf-8?B?dzVEcWJZSms0Q0V3MDhEVnpyQ2xkTTFEQS9aOU1vQ29TSThwWWpTaDZBQ3dF?=
 =?utf-8?B?MTNkbmlZUVZWUFlqOXVXOGtCZ1IyaTRiUTd0bklER3p5UFBHVzUxZVhqQUdQ?=
 =?utf-8?B?azNud2MzQldRYXV2RDRlMFgvTFFxRUcyMkJLYXF3c3VrcENoVnhJa2ZNZG5o?=
 =?utf-8?B?NGFhSU9kQzZjb3FpUzBVRjFxRkhkNHJKTEVxaGYrMERTS1lxRUVLNWRSR3Y2?=
 =?utf-8?B?Rk5EZU9CczRZS1kyd3Z4bzZVOHRrSU02MEJqT0txdVdmNmdCdVdYZ2lzRWxh?=
 =?utf-8?B?NWJabTd6VnA4MEZhZWNNS1BaVWpwTTloTlQzY016VXdoeUhUU29sYnlMcTls?=
 =?utf-8?B?NHFlOVM0eUx5SDlTNmZyRW5ML1lpRXhBUGNPMk9Wb2dObHFndFNGSVVtc09H?=
 =?utf-8?B?U2ZqT200N1Y0Z2ZJbG9yUDFPMy85VEk0ejlrYjRYanZ0V2o2TlNWa3VqV28v?=
 =?utf-8?B?SnpRMUFlYXFZa3RkR2JwbXNEVWpUZnhKMXlpOTkxcUhRK1Q2RUJMWjBXRjJ0?=
 =?utf-8?B?V3RsQVR1OTVOSnR2S0hZRFJXdTM2SjN6ak1JbFh3a3krUHk0RmVBY2xHSnM2?=
 =?utf-8?B?MjZYN3A1SzNPcjVyQWdvR1JmdEZ0VmROSTkrZE9Rd2p1YTh0T2FTbnhEWmZM?=
 =?utf-8?B?UFV3L2dRdCtremlMOUlBbDlkcXhER2lySDZaQ2tlaTN3eDBsRG5hY2hUd2Vk?=
 =?utf-8?B?bVRmZ1ZDb0EwV3d4TzZiOHVMZVJ5Z05iRlhXdkJDUGVBMzVYSWRnem93QUtQ?=
 =?utf-8?B?M0hOaWdRd2RzOTVlbFJ6aFJ2aTRqRCt1bmNjZG1ZN1lRd3NpdFJDTEdHUTA5?=
 =?utf-8?B?aVpHbHBzOEVFN0NQQ0pFOTNHSUlxbUUyOHN6enFBNTY4cnNoMDJGUE9hTE5q?=
 =?utf-8?B?SitlRlBSeFYvK29kK1loRXVaZWJ5YVJTK29OWlJXZEtLNEVHYUQ0dHpjS0RT?=
 =?utf-8?B?NW9xR2g5N25vUEFYd0pLL2dyNUhlWnBuVEFSWllvcTlFVEtIK0JHSG5SWmM5?=
 =?utf-8?B?UHdYQmFncTF2M2ZIUHNveTVZM0RvY1FGSys5ZEt2RUZrakc5ZVRnWlhYNHVo?=
 =?utf-8?B?Z0xPNXRBbUxSQmpDVXdHcHRyRnluTmExLzhxMHZ4cUFDaTFJZzFhNk9qNHJK?=
 =?utf-8?B?dEJnNDloUzZQc3RlRlptSGF2NEtUMm0xNW5iNjZObGlMWUhOQSt4M21HV1Zj?=
 =?utf-8?B?N0xTODRURjJuQncySVZDK2dxNVZFMUVvSkJjTTlpSGRWcFBLVjhpZU5BWmJh?=
 =?utf-8?B?QmVuSnd4MVhzdGFIeXlsTjUrTEhEQno2Y0ZiR0hxMytwNXkwYnBVa20vUjVO?=
 =?utf-8?B?ekVRSCt3aTBIZnpYa1pENHBNRU9yS2tZVS9GVVY3QUVqVjVQTjdOUVdpNzQv?=
 =?utf-8?B?Tng1ekZkUFdYcE5valNYRmxBWlo0WWJVVldTbm13dkJwR0hnMGVweUIvbXN6?=
 =?utf-8?B?MzBDMU85WWxFb2R2ZTdMRm1YL09TM3hwaW1kKzdOWWFiTjhwck0walY1alFB?=
 =?utf-8?B?c3B4TnVnUW8yaDZSZG5CYnVZUzEyN3pUdGdPdStBZG1lUythWVUvMmdIMjls?=
 =?utf-8?B?L0hFK2dmT25LTDZQSEppaWFybWRGSUsrM1FUWlVnSGt4dHRjU1NrWklnTHVS?=
 =?utf-8?B?MDNmZ21PNlF3V0ErNGlMUGQ1bUd1dFNLU090blhTUFBJREhzMnJzenlJQW8w?=
 =?utf-8?B?MXczbVFLZXAxaFV1YkQ2N2VXanhrRnUrZjdKOG5nTnFIbmxQT3puK0J1cFdR?=
 =?utf-8?B?aUo0M1U5U21qelZVdEF3akR1UlNGZnVNUkltZkM1Q2lkbnJWZUlHUjRoY0d5?=
 =?utf-8?B?aDNZeXo0OGQrZ2JNV1hIUDVSMHdNSzk0RzdFNXExQ0ZCcEl6OFYrdFNadzZ6?=
 =?utf-8?B?SGlGT3lhMDVYS2JOenJNc01rdDRwVUlQeUV6b0Y0Z3MvYnVJQXVSQ2drU3ZG?=
 =?utf-8?B?bU90a2NGY1oreGY4RTM3dkRFR1NHaGpnTnIrNStyZWcxazVVUXlOUVpsV1J1?=
 =?utf-8?B?c2puS1lTcnFtN3RTU251ZEdPb2xvUkdwOWlCSEQ2WUg0UC85L0psSTgySUN2?=
 =?utf-8?B?RkM2dWJCMXhkTE1pazQ4ZnhZclhpektQUEsrUlZjeUNlbGF5STIyT3VyV1k5?=
 =?utf-8?B?d0R0WjFvS0xYTjJNdk9zNjJVL3ZRMnZsTklkd3Z4Q0dxK2JkbTdUT1BueVRK?=
 =?utf-8?B?ZXduUEJocXBpVE1VMlNmc1ZuQ3pTRy9OV2NWRDNwdG41ZmQrekplVjBlamV0?=
 =?utf-8?Q?s9g4Jm4INxgnPWAyd6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6530db24-e409-4f45-f05c-08df0fa94b49
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 02:06:29.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QznZgdSMAYqwPYOYqpYU4A5y4SCwTSA/pNn44KcDJWtscaDoG+aNMUKovCbpwuWM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9456
X-Rspam-User: 
X-Stat-Signature: wbocruraa415tq6y1hojipca7kd4eaei
X-Rspamd-Queue-Id: C4D17140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789092395-684411
X-HE-Meta: U2FsdGVkX19kSd8PIBPpX1gVTAR4wvdbtKdIpilaiOqRhYlRMzBKuGNPvfiVB+h+4fcYp/073VchidIcDvd9AE4/HGn2M2JZyphYkR7gERlp/C5Gpum675e/vASaVhyanBl7NcYtsc8u1B6bhrG5CVVOUeKtyMQaTPu2Mls6bFA01oXTGjaCtwkU/KGHEtoBk+enuW9xN3957u5v98uHe/sAZXAWGyi9EaVWXp4/cAFHRhDserSCZ9w7kZP4mgAlZtjf5PHaPNT8Gqlbiat6XxKUCEHA0JwIk1V+jL6GtzkcAtoDxLXPY+kHonioYnMrRfF4TSseW59kWT6ahTzYeD9cu3ognNosmVc/E6Im6RGgtzo7AfJW2lnVumpU+hHjUCWnF886FfPqiIWNhb+2/7Yoe6nD6bnGiXNh9WDttMG8Yo6ySGkd/s/lcjxCOAbelzxOgy7B2sjTnXiGJ362VVwhg72lwihBL34pwWrE1NN3oHg6PvDjzI9TpBvhIT4uVkeoK5x7DLHygQMyQOdRGfSIYz8xNTU8TmST0I9z+XOCVpqL1dqXqulDPqdFNav1JxLEzB8OJH7ydueO68kpnbt2TVdsSNPsTPcxRlX0gQfRnBCDb/nNjS8WHCBDNTH3Tj6k6K6n0QzcGXZQ3NoOVZsNZcmkp/hGTsRXYNXSWW1/ujkGZqE3T6wt175LQbZd33Naq+5YyJIFEq/PdGQ27nZd7FgH6pYxASmZ3sECn7iw9Aye/JgI4h5uYDjolLoWQG8ggYQjz5yoW4E10bLt+CRFejaKzG3Qlyjb4h9x5DGbv4tcPUBMkNGp3xGIcgmTFZsNDHFpr1iV2jtxhnEhW9f/77uCPrwIVaNrAaYMbVtByzVyEZZXLeEF0Y1ejfGoHWSteN2vcdJ63zzX+TuIF0wDu8GJAlMSvDrKAOPUSOMXfflV/qP+9FxZHofi6PU+V6pdlxZEJNrBV2uaTQg
 D1Vqx4v0
 RGEs9BzLlkdrH8yw1DgNJI5jdH5SaeoBoNmTJNF2KtZ0VFbTqt36C84Tk7Uu5PIeeNT0EukxSUA/oc2rq1laQQF/7GkVvh0r8adD/RIwHFTQ7/umZGOWWPXrRbLh/DwEvz8AnmrAdAKcmLJynV3cxbJLdE5IOQAc/mrji8fJUyu0eoKQPl10rXGzqAF4BfyZUu4zkjuntIPqStmlVuG7CNtXyKlv5QdWj3W7xmevvRrTem5J4aAvFKxDlpyazIMPW0Z+dfHMTXQvfXs3RD/v10coN3cHSNutiEd/W8V4k414iHgxdi9z66ST/7uE/Gogdo2yitVKvFMqQlb4C3PzFYsLfgUy+WG/6CXFu1rY/c4R/tI9JjelJlkdyESN9Bp2lBFy36G5b19Qw50PTGDPPEtX4h3XBqLejKKZEXFbGH4o6nzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
>
>  - which VMAs are eligible, and how hard to try for a folio;
>  - how many empty, swapped-out or shared PTEs a window may contain, and
>    whether a sub-PMD window is held to a stricter rule than a PMD;
>  - whether a range has to look used, and whether a MADV_FREE'd page is
>    left alone;
>  - whether the PMD is mapped as part of the request, and whether dirty
>    pages are worth writing back and retrying.
>
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.
>
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
>
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and th=
e
> defrag setting behind the allocation mask are sampled once per pass rathe=
r
> than on every table.  A table scanned early in a pass and one scanned lat=
e
> are then judged alike.
>
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereference=
s
> cc unconditionally, so the check was already dead.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  31 ++++++++++++-
>  mm/khugepaged.c | 114 ++++++++++++++++++++++++++----------------------
>  2 files changed, 93 insertions(+), 52 deletions(-)
>

Great cleanup! Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


