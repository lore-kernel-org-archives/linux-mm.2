Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F7B1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639406B0148; Fri, 20 Mar 2026 10:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA626B0149; Fri, 20 Mar 2026 10:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9206B014A; Fri, 20 Mar 2026 10:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE3E6B0148
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:20:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6DEC1B704E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:20:50 +0000 (UTC)
X-FDA: 84566652660.28.2F3DF55
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020099.outbound.protection.outlook.com [52.101.189.99])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9545A40017
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:20:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=OSFeqHqD;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.99 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZefKfBcnqELEUvfygumT+9YwiFTLDE+/q2L8SmoUfFY=;
	b=Gaw5APyQfgvomzrwhXfj2QUibOz48d2wgiYckHrqI4Ubc0cmtvDb6ucYse6gqMnm4UnlQX
	nkwxE/+ME32MDMmTcH3aXbGSVdY7C/nZgi80x+U2tk78xC57SYdf8vxvTgKNUDSD7gUAf8
	Idh3Nxqr7bWGQj2cOc3KTzj09a2Y3sM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=OSFeqHqD;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.99 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774016447; a=rsa-sha256;
	cv=pass;
	b=sqV8Z04F0hA9pFhGTRZWdsxTT1PCnBZUshUdRGigQLKIqn2ux3axpi+AaoHeXpvMb21W0y
	bal2c/K9JVo1KBw5ZvsnZaeU6/p8NoWWdNeKNXteFLCPKIocJKR8g2XFa1J2/tw9GdaS72
	H9U6KxCZEzIVgVRldJrJZg7JVRbD9tM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B35JD69BemNvpZ+5YRoz63W3gCHXElJsozoHtlFh+Pnw8F0wcy3rc5HsNMOCd7T9gQLYGkGri0KGSap/uetmMe2l2CJ8gpKcZqfrEO+9rojU1fKcMANvPPKWdPqMUveE9G9mp1+MIa5nRBzLdeLxT6vsTZRRWAAX1uqzow24i3T2z4p7n9Jdw62eqAWoM676eDRiiFhMD3B0Hg8IyabEYOtJ9JuS/4jL2k7png0tWsTxgKZBkXsTqJpDE8OYWDiACzYQm2ucjENXCmAYygd7LWie2+P82SwUPRJqkUoxya1YjryiHV0ceLh9RueSCImjAYJWRcJj+T/HTjcFbUep3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZefKfBcnqELEUvfygumT+9YwiFTLDE+/q2L8SmoUfFY=;
 b=Fi8cxJodig7kIfVAbJ2IZL2pjGdO1ECPxv0cjJX/0snbI7HOsUtnZE75vicF+omyMVNH3dAFoKms572K/AY9RT2vuRkqiQV6KXxvO/faszI9r4cdKYsAKtWdxKWU2sLRa7xYmqVgOTQ67xZdCrnKiW40ppLAawpVMD46Ok6bVUo+w8QLaIe7i0WQakM6R4PueXZ9qWTEY97vQoiCZ5qFceYKLUfh2IxIov3LX9WruJNRtk0kluGUw7BkcT2p8RUYinCGQsBrRTA2DVaIlhTELrQBGIqGc6o9KoTajGmjSbVs3r4Ix/3tYPGk3P2rq+Ei83FrgWzUKtw1A+TwmdCDtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZefKfBcnqELEUvfygumT+9YwiFTLDE+/q2L8SmoUfFY=;
 b=OSFeqHqDKnyJApsSZH6WMd6y/6GWqVefa8zQMQGnfsXGG3u5kGz2U+QZHi5wLe8rh6jmuB4T4AglRox5AmqnmRXwRnYUlPEtGDjx6EySBmh4e6FNnaYSnJF57ie0h9140H8vVt5M3ynhsBWOW9QuiOUtlYRmwXTr8mdwnt6PNST35NiTTMMciDDu7JwXfGhXzWUPev+q0XHgH5ktCeobYJG9rec8xpsQk3p1795Mp5eNsZrzr/FkLK+myN2ksCUpuh4CPMtTv+CLTD+m65dX5YTMFiZtmhNkuZp7ZdvohThtm/U2VjcAFY90VqX2BxfO02awfVs1dS9jkSmgeO07GA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB5702.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:31::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Fri, 20 Mar
 2026 14:20:38 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9723.022; Fri, 20 Mar 2026
 14:20:39 +0000
Message-ID: <7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
Date: Fri, 20 Mar 2026 10:20:37 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Michal Clapinski <mclapinski@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260319233745.GA769346@ax162> <abzKcGiRSR_E8lLN@hyeyoo>
 <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com> <ab1J9ODkX5iChu-C@hyeyoo>
 <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
Content-Language: en-US
In-Reply-To: <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0279.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::17) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f215cec-4025-447c-2d1c-08de868bdcad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	s2xMijAGU+79/lUOUm9Ch0NolLawM3QMeIodWhMkzseBmccmGi8jo7VypVFu7+ySqhh246Aann85ExD/h/nEk55uYaExVu38wIERLSMKtzM1Fd8M/Otw67sHyp9HTucbdfCHjcw6qUgZW3REe1CqXbi6/AnMDd7g/zmOvkFvSfJn83E06z2w4RFcTCEg4RhvbP96ExuSe88RSYGoCnM4sGT50mIfOlt3uEbAR4hECbn0P/wbcX5LtKn9j5GGJxDli8ookB6XxnGJ69T/tQW6cFkjuYtk68tddJUGCt2rN0m6H7mgt+y4AzOQXejl3RNkqOIus3u/kRymw7OKrPY/cvuc27Hr0EtvzzHkHnVAA8tDxznmy5L7QTLkB3mHKh5upU8R8bZBRUSy7xH96Iedy5LmjQMDYC/ABSVZYTw9M2Qo2O+OdCw1UlhGlfLMCLi0lUSyIjfSc8soIacNzIQanF9Z1NRRcnucZl4NliXcBPnvm/tobgjyNXLKeST/Gk20JXX48MEvxC8ImK50GRo2YN+MScq/N9GHLfBSBaMwnGHIAM14NAj2t5srjfU3SSFZR5mJhbEbNe9wNCElYRSTCvCE0khTmvNU0nbIFnEhhzydHUbP3H6yDny9ifd0Z7YJRhKicK12DKrLstJg5Dn2+5qkY3jL002P/eBLwGElg6VSbQ2FiNvEEq0K2J+jEVLJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3BSTWJWdnp5ZXJaeEVVRVBFYzQ3d3lTcitYN0Y2MW5yMmRIMHJMMmxBVTFI?=
 =?utf-8?B?L25BRlRQeEFjWXVFTjZUMzVTSlNaMUl2YlFheW5xVXZIOW1lbTA3TzdxaHNl?=
 =?utf-8?B?bG9UNmRoSXdOSU4rYzdmMXZSdGNNQ3A5V2tNcU9jSm93WWFTS0hTTG1NdjdJ?=
 =?utf-8?B?MCtCY3Y3MDkzeDU2MXNMbHFYSDZHS3N2MnRQQ3YyTDNHSzRuSW5CSkZCVEZS?=
 =?utf-8?B?czQrZHQxcU11bEVSdVJ1T1pmaTZGK2VheUVSTzlFeEkyUTBaRGVzUG9aWHFP?=
 =?utf-8?B?c2F5QTJPVWtxc2g4aUUzQkFWMUNOUXZQL2JYUUREWGQ3bE9WbkQ1eVpJQnho?=
 =?utf-8?B?YXhaWG9SRUNlcCtNb0JuK2NLZ0wzSEN6YllnRzdLWUJScGJscGdwVVN5ODRw?=
 =?utf-8?B?SFdUaUZFSFpHbjJYNWNneDFFcXM0MHZOeEJ4U3l5RUpQOHFZaU1KUWZ2SkQ3?=
 =?utf-8?B?ZTBIYitsMitha1paNWFRYlVTY056aUhTSEFrRDNyRHNhaDY0d0kwMnVFd0F5?=
 =?utf-8?B?ZWVTdExRcFdvakU3RFJhS1pyNkJFbVI0aytNT0I4OXM4YkpXQmk1ZzNNbmRV?=
 =?utf-8?B?UmVMVERncUp4RllHVUUvdHM2NG4wRU9jWUViWGtRWWppRjJ2aE44Z1doK2RV?=
 =?utf-8?B?WkRieUJlK2xQeG1kNndRcCtsNnhNU3pnU1duOGIrRmhqOExpZm9WRWNYNmhH?=
 =?utf-8?B?ZU9qcWZnaElKalVpWUw4QjkvRjhDTkxtaXJ2YVhjdEVrK2FJZFB2cmhTdFBq?=
 =?utf-8?B?NnFUT1dHUDJ4c1hoL1hFZlR2VTgrcG9VRk9OZE4ramp0dldLUGt0MGovM3po?=
 =?utf-8?B?TGQ2UDI0THZIaEMzeENkUkxBK01Dc2JYc1pKVmU0UjlGdmU5dlZZRFRBbk1l?=
 =?utf-8?B?cURlVDNlTzgwUm0yZVRaWmNkbjYvMkxjTklFeVVFM1l4d2ZhSGNmcC8xdEN1?=
 =?utf-8?B?NHJQNjVlcWlDeXJqeTg5RU1GZEdxQkFGRVNPZnl3Sk9ha2U0SGtlYUtrZTJN?=
 =?utf-8?B?RnZDYm1LSEN5M3h2czgvZ09PSEJnMTJ5SVdCUVJtTTlZc1gwUUhnSlRpWXYv?=
 =?utf-8?B?R1ZuS04xWTBrNHpmUyt2dXk4TWNYdTE2bTZMZEw2Ymhuc2dtcFQ0OTNXZCtW?=
 =?utf-8?B?eC96MWV3MlR5b253djJwemxOM0RwTS9Maks1UTNCU0piOEs2RWNOY2laeXRq?=
 =?utf-8?B?NElRM0JvOXVIc3ZPbzNDQTJEa09vZzBLaWhpcnpwTDgrVEMvcFpIbmdMby9G?=
 =?utf-8?B?MGxlbWhML0pWdkNlN2s5WEZQNmVJajlPRko4MXlkQWErZVF2a1ZiR0JZSy80?=
 =?utf-8?B?UFZyWDdlL2lNcG5MaXR1L1E5dUhNR3RqQzlvMUhSSUhwS1NPV2xINkNWNDUv?=
 =?utf-8?B?K3VlVFJ4aGVkS2xLZi9XVnA2bHVrMjk4OHFTdGRkbm0wU0FjZkd2aVJ4MVhR?=
 =?utf-8?B?VzFkdk15MUw5aHZwcVZkdHJLd3V2VVFycGo5WlhlcXErUFFzV0c5eVBENS9R?=
 =?utf-8?B?cUIrNFdjNWM4bExURjJwTGRDYjNIbG1EUzVkdmI0TXRqOGpoVzdDdFQxZmZn?=
 =?utf-8?B?dG5SNkl1b2dhUDE3RUV1algwN0pabWRUaVlmQmdqNlIxNjRjZWJpbFUzYnRx?=
 =?utf-8?B?NXB0cjdpWjF0K05NQmhJck1lSmY1MkMwVmhTdUFqd24rNlY1bDdtb3paYmdj?=
 =?utf-8?B?RWhjL2pURWN0NWVtVXFYU0U1cExxaVUvSjcyU21iM3k2bFJlVkg3eGtPbHZm?=
 =?utf-8?B?L0Yvd3h2Q3kvaTBsVUc0S0wySFdrRm9Tb0U3bzZOL3UreTlGUWRSU2Q3d29q?=
 =?utf-8?B?WGVLNGVKZzlRVnBsWTlKK3AvVVhlVE1wRndvRXZmQWlvcUFpNlJQQnBJNVJv?=
 =?utf-8?B?alNjSHZaQUtRVGUzazJJWkN0T0Z5REYyR2dpOXNLRUtsdjlLMEVOUkt6dGNq?=
 =?utf-8?B?elVISDRUOGpTcktVOWVzNHptRE51ZUxNbm15NllndGMra1BCMndpSU81V0I5?=
 =?utf-8?B?SzUwMmhMOEpLVlJSbUNDNDR1Z2FCVlMvWmo0YmRmc1dCSUJsK0tMS05GWUlQ?=
 =?utf-8?B?MC8wTEJ2TmhTYXRVSjh5WVZYR0dsRyt3NW9MTVNZV3JMOEVaRHNCR3BNYVQz?=
 =?utf-8?B?OXZNbm9xRVpoN2xGeWxKWlgzaWRnRG0rTE1hY3VZL2RqaVU4K3lvMXhUT1N5?=
 =?utf-8?B?QUpjR0pZT2xQTVFsYjIyaWt4cVpuUHVkOVcxNlhvNHVlSEZtVU9HdGdGVzFR?=
 =?utf-8?B?WXRsN1R0Mzd4WVBjcWhYVitwTm5YQTFMbEVqTnhxSmt4azE5WkxGZGVEQ1h1?=
 =?utf-8?B?dU5jTVBKT241Zi9uTlFpMUlJUXoxWkxBKzZ2V2JIeGZUVzF5SkJFekQxSVY5?=
 =?utf-8?Q?F7MjvDaw/vdy6vs7uq7Zyl0rFeO2mw5Nyx1Uz?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f215cec-4025-447c-2d1c-08de868bdcad
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 14:20:39.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyI7O0Fm7ZnlgHUx3z6O87Xu7MqjEh2EYUZHkAFhyRhMjC9iodaIujX5xV+uU+w5saPa+g25zEobikC6Q1HWtwnPo2dlUqC8hXvHyq/yvEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB5702
X-Rspam-User: 
X-Rspamd-Queue-Id: 9545A40017
X-Rspamd-Server: rspam08
X-Stat-Signature: t9nzu5cf79s964scys9e7ghpz66guset
X-HE-Tag: 1774016447-840990
X-HE-Meta: U2FsdGVkX1+uTTzVZNqMlgL6fUlBR/fDowIK8Zn/WObndfHfcYZiRZpGRQrdzqVwcLnvI64J5EPzz6Dib/J3NG+AFUMGD8/AH20WmwIKFgxVcvt5NuS0Umgu3lwBpzvo22Ah4br3McG2l8X4qVU3I3VzDCXJWSfx/tVQBrVUfLDs3O1O9zZ8PVhB9qdIvn5NAjmEHRALtZIhp5gmihAoqddJYzCZE2CAz1vP439sIoZChaix36I66MD3rNwLeipBKNDcNYkZA4I6XI/QHDX93K3GyRHlC8gL7rPqlxiJBIlD4nDrrTLykwU2m7h+iBxrc4A5dK3W7q4ln0PHVG40Jl54rO7Z6CqNaiPHRb0V4V9sntenxwVZdHymsgNG22hCC4eVAWg16HNkTap4MhTInKTUHhuwx3BEBe06qoem7DSB4ZSPYFFSANK5YUfcFmvDTRMkMp7ziqjA5WOnp1t5aBOSksNz/4+7KFZ2p9g9ReyGgZe8nyzg4eXS7FMKbvCWY1oI8xZ9RoHYhHom3vbe8r2u3dLT2TJTNFoneGPoMPNCRWPNN12FSPcnwMBlyywwe2HCsq+GTEviXpCl9hOi6WjpPX+2smdHxWoviNGe0SsASJs+NQcKlAIiJElidMu0S2xzQKCTp8oqwb9eWV3lQErSTeg3Gpt77sjSzS3uCagTR+fkFvWnrto5t/T0L35DR8Xey4Il+TzEVX4EvA3Jk8isnMEV3gmzTzPDAV8XaR7uR5x1dc048j1VZJrSuoQzqAFtj8Tjhu6o5kOkcKh5diJW3Hjn/eQZu6hntPlSBDwpAy/ldJG674L37DWH5gHZ+U0kGyAChY5CMV3Q+/zwXt8K0FXnqo0atW1Rb6h3STQQQA3cQS/AQ+4RkPHGUGFvj+fkeqqYW0PAFEzo39e3RNwsOT+WdeBNiOclNWTgBLDaA60w62G12zCWyqn+ClptlZKzwH5a00A10Dt2GGP
 EtT9NPmy
 7m3Wq3OZogeGJXrW6k5c6cdBSLimgJ5TUX1b/F9M4h7/ASjK5ZAwvdlat3ZRWw1FSI25tf42XKKmZ1txm8tag45QuLQp37FL2SqN0KcbDl6Silp21uHDBS/3xjt1I4HcVxC4IuntE2Uha9OCmjaaXV5U8PUEhf23hsv7a2qG9d4iyTxdxH6LXBtZp4+COlPkERMZnqtxk3+9LvuuQDrgW0hGJw0jlQWd2NwfqZ45nvQplBAQQG3E3LeTZL2lB4XdXpIqvjJ0k857uPaaLw0O0yzRl1GDsilHlL63xk9/gY21oMaBg7chJwLiWH9Vj9ZR9SWDpar0lc/s3VFXfJaFZypXsT3r4K3nB0pL2ZtTeIuYoOdB28VOH+jhapUDmcfGUsA8kbpYbnvjCw/0OrRFLvEe67yIu1DY4XM52TafE7qAlaHKAh2MhyKUa774kNCu03NvBFEffDJWOjoe1f3sbr5P5RKZGjAvk/OR6N5ELILBZrs1PSkKilGkToX78SenE6ggmtL5F3YcY0oF6GpIFOSkJ4YOhlcUmNlzoPfK+N4X+oGRhSQgm2958clPCHeW69amy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-20 09:31, Mathieu Desnoyers wrote:
> On 2026-03-20 09:21, Harry Yoo (Oracle) wrote:
>> On Fri, Mar 20, 2026 at 08:35:46AM -0400, Mathieu Desnoyers wrote:
>>> On 2026-03-20 00:17, Harry Yoo wrote:
>>> [...]
>>>>> [1]: https://lore.kernel.org/20260227153730.1556542-4- 
>>>>> mathieu.desnoyers@efficios.com/
>>>>
>>>> @Mathieu: In patch 1/3 description,
>>>>> Changes since v7:
>>>>> - Explicitly initialize the subsystem from start_kernel() right
>>>>>     after mm_core_init() so it is up and running before the 
>>>>> creation of
>>>>>     the first mm at boot.
>>>>
>>>> But how does this work when someone calls mm_cpumask() on init_mm 
>>>> early?
>>>> Looks like it will behave incorrectly because get_rss_stat_items_size()
>>>> returns zero?
>>>
>>> It doesn't work as expected at all. I missed that all users of 
>>> mm_cpumask()
>>> end up relying on get_rss_stat_items_size(), which now calls
>>> percpu_counter_tree_items_size(), which depends on initialization from
>>> percpu_counter_tree_subsystem_init().
>>>
>>> If you add a call to percpu_counter_tree_subsystem_init in
>>> arch/powerpc/kernel/setup_arch() just before:

[...]

One thing we could do to catch this kind of init sequence issue
is to add a WARN_ON_ONCE in percpu_counter_tree_items_size:

size_t percpu_counter_tree_items_size(void)
{
         if (WARN_ON_ONCE(!nr_cpus_order))
                 return 0;
         return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
}

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

