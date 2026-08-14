Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253BAC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140E46B02E8; Fri, 14 Aug 2026 02:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F99B6B02E9; Fri, 14 Aug 2026 02:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFCED6B02EA; Fri, 14 Aug 2026 02:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C53BA6B02E8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:31:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CF37A2A63
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:31:20 +0000 (UTC)
X-FDA: 85098903120.14.A816CDA
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazolkn19011028.outbound.protection.outlook.com [52.103.43.28])
	by imf23.hostedemail.com (Postfix) with ESMTP id E03F6140006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:31:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=MdQePM90;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.28 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr;
	dmarc=pass (policy=none) header.from=outlook.kr
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786689077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6P1Or71+ETzIOZsGY49m4ngIJtdBzdcmC3Fbul2QUO0=;
	b=IVAVnk7Um3ltIDVJgAS9ze7Rr+UQ2rjXv9lY9sa091/KnZRoHnBxwHvrKfcdrh+L9NiDwA
	Nn/HbEXZONs1Xr+z+VeyI8AHTcP/CEqZ114DGQfwVnb3CRLPxJeix7MTevsGmo/ULM5Gb/
	FLD7zvuE/uYx06XbggpYZige8f1cL+8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=MdQePM90;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.28 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr;
	dmarc=pass (policy=none) header.from=outlook.kr
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786689077;
	b=K0nFzAvncw1M3XeKXPUig090a+7Qj9CIvrxgNUkHuwWx/5paaFF76JfdlkjQW8V2e7V8I1
	ZIFzzpICpxHkALbLOU72o1bMcAIq4wtUbAZSRpqQD0F51a0kftumJfa7hfPqlN3wckvT8G
	ILmEzSuJ/47iTLQmrUJv8pXeoAwQv8k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyf5DnnqR73n7W5/nBJM568HnZeehaxpHpZZxshvi2xoxnYarCHT6yDSME2raROJTPT7seKtKsoocJy6rq8YJMDC+QpHDfCT2aUfgCH/+iYZUaULlTXddP7AOFUlZCUD6rO8PZJkG2MPoiH5DzNfuwaV8raMAIq/BZiPNXvRJv8Dem+LiHzWj/mVCBkSwXa4W9xpDw9TuT1V31vPJASwl7heiF+74ypolGEVa+dmXBfimKzcxHUvq+eHgTLugzkEPzVcDsaRJqj0M1H/S0VFu2adFeE8W7FXxLDyAzGc+tvWPzH+LYn7sCcFqbFdy1cmoBtKMLD/2lVFNgs1Y9Zpbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6P1Or71+ETzIOZsGY49m4ngIJtdBzdcmC3Fbul2QUO0=;
 b=n1G0oA+NP0O8vBKFKonl0Dv3GocurKSXZcEsEQeHwa5hIY64RiGtpZwHaIfcDQ1A0W5z3nmXuD+CZav0gaT0xxUF05gCyRKKqvhx+5fYlpcxu5iZro70hBGDa0LoyIAOuqKq43tcrWSydoAXYQJz49/mmSQQB1dZ7+YZCXB6FLwV+GM05GbpHbvLbeUUk1Pu5YKrncjoGSpBvT2laZfqscqhXw4/lsud07Su9pNaTFyMpihLO+PgdsZ6iF3SMqc5B4wa18tGx+VxWLMRvfmz4FxiIn/otAIGYbdoG0ZYiPHNRJRYwK/8udlaSzufmmnhAcjiOHS5757aW+ZnGyAhuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.KR;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6P1Or71+ETzIOZsGY49m4ngIJtdBzdcmC3Fbul2QUO0=;
 b=MdQePM90jpp2EJD3qkAE1xFNd25B1xlXGKEF4Rw3nT7uST8VetAwln/3Zdf+bpzQUzIcP8LRQ+Gh4HA4STULoWP7WbrIU9NgXWIa9SXC7SIuKyWakuV3+Qk0g2KS4hY0he4sE6E8HGppw2DeoyqdABPmCNSAjc8MQJjt/BoDDrLp2pn/kRe7sxkPWQzH6Zm6TraAsEji7pGmpJdGYpTp6cooY/RV0umnrxa3S69i1DT+5LZVPLNI8h4TVh5j43EUTe5PXblIuxyhH2JsbGfcbzghzC8VtWpa+dnoDvkpUL6LQSYelQbiRX9GXzMxPuaTI+0HbLgY/0C+50uxZSX3tg==
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13) by TYTPR01MB11066.jpnprd01.prod.outlook.com
 (2603:1096:400:39a::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 06:31:09 +0000
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc]) by OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc%5]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 06:31:09 +0000
From: Eric Kim <seohyun.kim@outlook.kr>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Eric Kim <seohyun.kim@outlook.kr>
Subject: [PATCH] mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Fri, 14 Aug 2026 15:30:51 +0900
Message-ID:
 <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0119.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::9) To OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13)
X-Microsoft-Original-Message-ID:
 <20260814063051.7239-1-seohyun.kim@outlook.kr>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7PR01MB13914:EE_|TYTPR01MB11066:EE_
X-MS-Office365-Filtering-Correlation-Id: 1575c947-29ef-426e-f106-08def9cda043
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|8060799015|19110799012|5072599009|5062599005|39105399006|4140399003|25010399006|25031999004|23021999003|22141099003|24021099003|440099028|3412199025|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZLkHWOsfncDaPVrXVjJUzBem+2VmHaMjBE/pLQSiYAvoDA6ctNxFgqtB3IP7?=
 =?us-ascii?Q?s70f0MpJp0ORmdI/P2fIPe4a+Cd5vItnTO2DQkVzDBOWfn0SCFDnXO/KqRG+?=
 =?us-ascii?Q?VZ4heRn+K5wAz/eL9cQv0UyXcFN0hWeqmSGBM/Ov+JrKQbtzVPR0z7o5za7P?=
 =?us-ascii?Q?dukC0KX4UD4C61dfVusxzsN+SnTIdxoghKXJxvX33Z/WNf75bkvq4OU5oTwQ?=
 =?us-ascii?Q?sRoRfk9INV3gIBHgHb675Xf5lzKiChU1R9tbdnuQ7P7jpLSYx1cQso9MJWc8?=
 =?us-ascii?Q?9f0KabGSsD9466VLoHYJcBM0KZu6QJUPLYe8MQYPthzIqU87bq1HRHrckZio?=
 =?us-ascii?Q?wsKU1A5QLIT4ZjJIxH990YfkI612OAApUR5fyxv+qU6SPPC3AVke9Jgm3wV6?=
 =?us-ascii?Q?MmWv41idWf68nvVMf2LwcXWh99ByePTteXrjPVRgUbOa4WMIG8zs1R6NUp2Q?=
 =?us-ascii?Q?c2AzVhMABGtvs2VyT4egTGJGP0R6IiPmXJtnwNSen0KZDZLW+L04+eiI88c1?=
 =?us-ascii?Q?8QnXAhOGiqv1W/vT+mo+15kVvnwcGnPxMzs8XUFuSq0agcyk4nkg12sauE29?=
 =?us-ascii?Q?D2awqLhlO7MiHIz/nFKv3G4sKaZdFiB/a6NhL4SO8zoF437zaeTrPWYupWA4?=
 =?us-ascii?Q?tuciZHUMK5/MYBGDVu8dgE3uXRXb2Gvn0znLiCF5HdiUzBNwVP+MJTtwWaez?=
 =?us-ascii?Q?9lZY+XyXXiKPWudtnlffzUC9P4lFyxz4tatDOiZAss/+u4hz4hRZllJu1gL2?=
 =?us-ascii?Q?fDtS57Erx2IER/jbrd6HrGRI+3AnpXa9AZHoDWVDrI8QuFdOK39C8L7Oo9Sw?=
 =?us-ascii?Q?xvKKiD0JByTqCapbcON87gYKggxilSzGCfjHBxOSKKaZgYsqAgN6R9+Jm9rM?=
 =?us-ascii?Q?c8DTTMKpftqSDJZDBHx6vtLfxcVqJMFHor2GN20dGYNwKJICUC7vSYhKRRlc?=
 =?us-ascii?Q?MjEz/noqP3WQatU0tMmg7vf24nxzsVSQ+lD8mix4MjTNSKWks8Rs4c9MF3qC?=
 =?us-ascii?Q?JdFLvHmy9YvEpXpcK+RoOjO2hfja7jGDwwof8yJqayfSKV1hTWyo0GQnoiY7?=
 =?us-ascii?Q?mL4oPLzi?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tDNvwnhFfaavwAFKILVplrgf1z2FR3FFRK8vbAnG9XEcfOG5Muz7kY2z8Bxd?=
 =?us-ascii?Q?iep40NRTBDoZy6H1nIihYj8Rllh3doBj5FyC/Y7AOGBX7vGW8R240ONrCK86?=
 =?us-ascii?Q?uAcIaBeYOaCZUWExgvzWqFtNN1XlE9v6qyxsCX1l91wW8evsaqP1vaYIF1pt?=
 =?us-ascii?Q?CdZZT0Edx3BHxdGqRR/837GGPAOtsuBcgiwenW/rANBsgZyJrpM5+O4qHJw2?=
 =?us-ascii?Q?+IoQ8+hGwHF2mFj54fJogpgbkLni9psShvvNMEqGmZV5wW+JSavKx3F07pEC?=
 =?us-ascii?Q?6uwMaDpwF+IYpcHBQhuTNfpfPM4mX0NTMVW4ccYDxSxvVtkzWpQYSNRXbfeP?=
 =?us-ascii?Q?qYgALTDAfY3oHua/Yxx3bDPiP4KvcXU4ssnSBJleyiVGOiBx039Fnmw7577W?=
 =?us-ascii?Q?hb0VmjkzVUKlaHNbuctpjYIP7+uh6UQVKCdVDCwEPym9rP+uHbwvs96duLe1?=
 =?us-ascii?Q?pP6KAsm8i3OcutHWRh1vWJGouR6/PE0qy6THZlAtPUJvQ5Rd7H0HLXchSSC7?=
 =?us-ascii?Q?j03Ahp2MfL4vNEUfTeg5ZuQuSeK498Gb9D4V6mAaGRNJNVVRLeza6IK1CBMN?=
 =?us-ascii?Q?c+ILXOJgBFg4Xl6HD+aLwJnCqH2dxY2h2QfxLbS7sFeJvEs86N/x6/smVpr6?=
 =?us-ascii?Q?5CBpW7WCGiBTAdkCnSbdgxyvCI1adQkPneXnwWqMv30pvxnlEobG47bn030b?=
 =?us-ascii?Q?FTvr8LGmQfIaVBubvu2CNFdXEdtDgBufQqCn2jOVlWDNoZrB2x+lo7mHFcO7?=
 =?us-ascii?Q?2v0SE23hYriAvUnbJaw8ujEuO17r12GBqUMYSvWNYjpoNLtIH8MKRrcfu6iJ?=
 =?us-ascii?Q?n+IA0wSls6QIrOmScOqhjFYe1rC+eP89seb1wYl0js46YICwEAXrQZbrLtI4?=
 =?us-ascii?Q?Hy3kI67ypLDrwo9WTY367Q/rHRxpwdcWMrzecRv4b2w/6MZfB3ewBdAxub32?=
 =?us-ascii?Q?pdkuXkWx96LIMZdArLc1JgNr6v0oQwlrNgP1zmzATkxw/zp2xuvDQCKr6L49?=
 =?us-ascii?Q?4HAU/ZTG8pbqDZLmQRzg045gdevENsAbjsEFYTMrNfEQoC9CM8wJcYRumWmW?=
 =?us-ascii?Q?utYvDy1AKdStZZU/DYCwHbyoPMGzr+5YcJ1LXcuHr0tHi07X186Vsb/YuVoy?=
 =?us-ascii?Q?xd6qhk/0d7dQrxL0cpni7hqieu3dQWGZxtgHQ9A7NGampkKsh6IgjwYEGUsK?=
 =?us-ascii?Q?on87f0QbFCmF7tr+CnT2yZEDd32yqvoRzFFn65RxqVJOvcwJM9TYm8KnfvWu?=
 =?us-ascii?Q?IJZ8HOXyIbxAHFsCpyhiZQ/KCygO9FBjvMHifoE00AwxLZBoC+S0eaHAjZFW?=
 =?us-ascii?Q?4gEp4zGbpYq8cNoixZYRV3ghqzzJouwg6Xpe8B3f9bXHX70oP2G0/uPJEPF7?=
 =?us-ascii?Q?iUeUFWwjn5BJBXknExY+N4oVLPQo?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-b83fc.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 1575c947-29ef-426e-f106-08def9cda043
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB13914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 06:31:09.0424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYTPR01MB11066
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E03F6140006
X-Stat-Signature: 71kh1b5wmnjii1g7ky1f94gqio8y4rfx
X-Rspam-User: 
X-HE-Tag: 1786689075-147295
X-HE-Meta: U2FsdGVkX1+tPodt7TcQYEdeZbVmUhKc2C6o2uKhoZcS5zNJhiuERNQ4VnxHafqSbx6nrOTyG+NgUatf1rrgg4LEKSMXcVTIbtmlV+2oUr0C+dzCZWtWeOAHeocZMybZ5Fk5cw0Is+/ZSJ+kld5nwL9HkzmdFjWrKAfvrLynJ5CmDD7cJrW9U0Ik6QtITUVgAYdy5gRCeaplxIC4KSdexSAPRv1qA/4u/GZfzyh2UjNVqdGE6LVCkQOYmosNsGLsi4FbuWjVLssUnYw/raLUQVuRjBwDuvRlM4UzkoT5xNZm1cHe/zPLcDQL58BDoVtZLHdqFO0Usn9Lrka99mfCZ0776z6shQmQOAplKwAQfl/0fb74vvWphsiHKo+Wb2cBcsqofGcf+qhMllufEiNW9TQO0nkfdhKUoVCYy+U00xW91hvYeAeL1DfN9u7BYCPoakVjcg8ClmdUlVQ3P2I28C6ZurOm5RMBJyKt6lkDWj0yfJD+/T8YYjfS/mRMGLgJ3dWXVt1DcPuJHCKh8NwSSBFOoQxUWNQiKrTmcDhwLP13FJGsykbfPtp8/g3IEc3KVKwvbv8ejnCTkwCnz3oIPlPkp+iTgYRr7C+Kfs1IynS9JbjF0YgLBjftwLbHhGv4GhLsSfhv1Mn+b+w7z8yX2BMTmVmwlrAcusXqNOYD7mBNbnZZBufU+Q+aEHPnUWIe1yq8bCy+VEJfCxiLUXK3PIbj6oZTT0nhBXCroeGiG39Is1KVK5Eq7kowtzUNX2nLcjRa5qQ6Q5gH4yqonfEjlnCz1RI7hMDChukp2mqM7Ls91W1UHjEn5anjebKWlNIZVXc9XY8EAAecLHXWKBlDQFPzYRO7kLHPgRvZptSD8cei3rRae8lYmif0+wGfPcinmV23G45MCpNtT+A2PhGxbLMQwvgnhecJ0k7HTSHkJKgFBuULc+8WbseJXZcWgsWk00k+DnVJqG2BRe+W/2s
 NfePTV+h
 iEQt9P3SzXe96tK511W0P4c+pn8Jk5fbOVPYaSoMZenk+t5VwbXXvQSpGAdONf+nQ0gg61tCG6p9oycM509UVfpKmv+gZ9HEbpzRSaBrbBzs+R9bEnNNTq+7RjumZDnT11l4fPmZLwjDeldIPDqI1wOrQkqSZwp+66VIqVWx9tII2mUY78ILV+k8pmc4nxBzOUItJYTEmc47JYXBPI86RCcY+zU8u1wDYlH5p0oz4QIzlFKT5zymcntgi+ePAlwqRYboX6TxLzuYLkgREBfP8RsS4YtMmCEFlt//+XeuirHFpBo2v5Cne1/gF+7sPU99YWX6GAAQQPEBn0FgJVyQ7Z7kk1ubskDBUr6LLSW2K0vJTBMZUjs1/iYDZcFWhu9H9dcqaDqxd3nZvkTxTsOZYRwjTPhTk43+ztl51q1J7nTq2CPYba2457DfJJlXfrQpi4Kbt1XVtpkqdsOl4OBCTFZh13NUx04DdIFFly7a/oULIOm+8cdtOhhyKv0jh4eSdm53YGSINUHyxQVX+MTq/N7q9P2dRvL9Dldd+DrxHoh9Tsa6mf3I9JZl1Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
active_anon_vma and is used when unlocking anon_vma after linking new
AVCs. However, the anon_vma is locked using src->anon_vma, instead of
active_anon_vma, making the lock and unlock target inconsistent.

Use active_anon_vma for both locking and unlocking.

Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..f3fadfb69c7f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	 * Now link the anon_vma's back to the newly inserted AVCs.
 	 * Note that all anon_vma's share the same root.
 	 */
-	anon_vma_lock_write(src->anon_vma);
+	anon_vma_lock_write(active_anon_vma);
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-- 
2.55.0


