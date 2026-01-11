Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B3ED2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9746B0088; Sun, 11 Jan 2026 14:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079476B0089; Sun, 11 Jan 2026 14:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69BA6B008A; Sun, 11 Jan 2026 14:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D313F6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:30:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C4858D7A7
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:30:37 +0000 (UTC)
X-FDA: 84320674914.08.A3605FB
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020077.outbound.protection.outlook.com [52.101.189.77])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E3D64000B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:30:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=rWlV2HU4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768159834; a=rsa-sha256;
	cv=pass;
	b=qhtEZYf2yCEsybSuuScmSwO33TcbXz0qHvuY8k87fPFjtUuhk3TDSCu1tLdirG4m8Z8eVF
	qfPvfjZLu25TvygEDR1U/LLgr1sstdfbmafE4PvJZQigY+cYTuGgs0/gd2WGc1uejRIQtE
	ygs0wRpRyN44ipbiKHiVMPyMFO48S/I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=rWlV2HU4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768159834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ji9nRJAe8sbQ3xDrKCECdgcu01PCumFPB7/lrsWzS8=;
	b=AZfM2OyBSPNqAm5f9kcI1LOWH4eMdxD7177faphnwBbr76RokKhe9RWnfE77g7XwQCtGre
	HvPAyST2GXN0rA9YS/W8yGQ/dOS4gAE9V4yz70ZmU2N287NM9vLI2jGZlP5kDDDODmlm3f
	5OUyqu5/HKetiB589rLTWF6IPujVmhw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBP8hgKqcx8WaVnbDkRbDpOmy7lT99y9orxPSQBQP6q7z1rw5jyMZn1kKtwGCcZfFi3YUjKwAa1Ub4ou08OPBMLZYtZE9P77MMiwIWBU8BaA97lcYEuCUQIAnUKkWKd8Lyz6h5URD/o9HPTZOAUqx4cnl91laEGdYcx7WQJwA0shcYFRgmhFDX2jPgiVTZFYhgML6oU1zQt5L+clkZGoHUwgPTQqxhzqrYz0Vsk2L73KTPITz6z7Ep75DDXUj4/T1svJaR1F/3H70uSGG4PmCg3n9kKcPkYagj76tBQLfs26kj1M3jMaZTR9YlhY2v/LVN1NzpSIzH89LxCcUYmwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ji9nRJAe8sbQ3xDrKCECdgcu01PCumFPB7/lrsWzS8=;
 b=klgYPp0OEGEClic9nvhOdCCBsJlQLnSKKEHb95V7zUfMk6iDri5obicIrA1kXyTOcqalSkM6KLEAoS5TzHscx3FyVAi+44anYKpduzuuITopGpJ7siDEx/MFi2+5u0EMC9h3nSQanlqEnnlErrP0jfMpKCsGZmdFxDw+3FHS76fzZiTtNYVD97b41Mxa9fGEw7977NLg+lTzg3rliv2K+UG5DJ84sQhP4suhCrk4TBdUYdMgnFF2rll4surLa/xqIYEkZskx7ZgpasToWmcUFM0FtaLIRGmo7xITrJ7IXjMxE0+U15OBEXe/+v5MQKK26QIlx/yH8bIIJpTuq87umg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ji9nRJAe8sbQ3xDrKCECdgcu01PCumFPB7/lrsWzS8=;
 b=rWlV2HU4W44XZhk8B/22ou8G2QTA8c7oO5obpKLzwLHF3cnSJLvOnIA8NZdnIlnslohJ2PB7wWk8ZRSXh/eeK/PblhfrUpVoiDQrcY9YsY2MFNEnv9Ol0ZhDijPs3dVSjeNxa1PS4bJ3XQsBIqGapKsOMuNL7I7k9V7+PVHlYJ4W4jkX+/ZYjpNJhquyUXCVvislqmjg5v0RrTGgGaIbHQyJVrYbaCTsXzpGQjxYUGL42kNqASeb1E9+cyT+PB355yXf45eRoTAr1rHC0GzjAYgTtpAOpzw+0fWI9Tvya3/njBixHWN+UN3r2Wa0BZCwgdM2r0VE/+NKPnbGdj3uZQ==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQXPR01MB6557.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 19:30:33 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 19:30:33 +0000
Message-ID: <0b1ec996-47c7-4ca9-84ca-78fe977c4dfb@efficios.com>
Date: Sun, 11 Jan 2026 14:30:30 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
To: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
References: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
 <202601120122.xSlEJ1AJ-lkp@intel.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <202601120122.xSlEJ1AJ-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0031.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::39)
 To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQXPR01MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 83543852-4c65-4664-5d7a-08de5147e32a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzdhT2crYUxEcUwyUlFnY0pGRG1xZWl2ZFlNZWJRYU5PdzBqWFdSeHZRcmJa?=
 =?utf-8?B?bEN1WTZEU01JMWVyOVZWTlY2OUo2dXFGRzRjNXZRQ004MHlrOHNuVnA5bE5O?=
 =?utf-8?B?amFQcHNSYjhMOGpldHhqZFVzRzZXMUxmYm92bEFKNmwvdHREZjdPUnB0WXNW?=
 =?utf-8?B?S1ZSVG04VzMya3lUMERrQ3RGVmRIVjVnNUd3VVdMeXYvNlBpWDFIVERUcTZ0?=
 =?utf-8?B?YldxQmdOdnQwS0o0V1N0ZTl6QyswZGw4RkpVL1BlRkhLcjZFaDRpQnFTMjFi?=
 =?utf-8?B?L3lIeXJyUzZPb0JtWGlEWUowQ0FCTCtLelNRQTIrVXFmQ2ZTZHdldlVaZzRU?=
 =?utf-8?B?aXBHaEd0dU1oVEZ4SWlnL0FnMlBzcGl3NG5FeUd1c1NYME1vMEJ5YkFpOGFi?=
 =?utf-8?B?ZWxLRzZPcXJTekdMd3YrYmxVN2JaY0pvVkZ1amM1ZXZQbC8zTUowK2RjRzg1?=
 =?utf-8?B?cmcrWFhBV3JsYXBOSmtyb0pzc3dMd20yRUZrWEVXblhZd1FaYkE3a01CWkxx?=
 =?utf-8?B?ZmlodFM5ZzByRVZueXVjbnVFV1VZUmdtVHVSanBYZ1RtSHVBN2p0ZFVoWTB1?=
 =?utf-8?B?dDhJYm1zSmJlTTZJTGdwc3hOSHllWFdxWVZ3S3JxVCtCcFdJWUxOajZTRm1S?=
 =?utf-8?B?TjZRUG03OFpmaHR5RmFKUkUyaFdKTzByZUpKZlhEVVF3TndaQkVWaWE1ZGla?=
 =?utf-8?B?eWpzbTMwQzZTVmVoOURxMDFVTXYrL3lNSXorRHh2V0NVNnFwUU9XazFVZkYw?=
 =?utf-8?B?MTcwckRYWE5WQytaZk1xc0pOQWNSR28xbEhpS25EcTBsM283YzVsc2NOTjIx?=
 =?utf-8?B?MWJSUFhLTUhkVEdhVFEyOEpxKy9pOE5JNlZ1Zk9VK3NreWZrcWNYWHZyQk9p?=
 =?utf-8?B?ZUEwQ3BmQU5zLytSZlpUT0MwQWNKOXp5Ty9QeVg1RmtMWlVMUm9IUG5ndDlB?=
 =?utf-8?B?anFVQVdiUm5wVEg1Q3BDRkFLaXkxbmhFbWFtQ1hOZzdkdlNrOUR1dHpTUk1u?=
 =?utf-8?B?WjBwV0dvMGtlZDh5T0hUUmdZbWZJTE00dkhIdWs4YlcwbW9KU2Z6aWY3dFFQ?=
 =?utf-8?B?eHB0M3k1eDRVVUE1WDB6OEQxeUFHL2R6ZFVEREVxMk1RYzZpNDVJRkd1QnJT?=
 =?utf-8?B?MXk3Sm55MVZtUElJL1c4bHFPSFE2eE13ektxbEFkWFNzakNFSHpYVXhyT09V?=
 =?utf-8?B?bVNJRmZLWGN4ZlVseW1GWlIrUjRldUttWnM4eU1RSG14WThMeWJ0dkxpRjFS?=
 =?utf-8?B?UCs3c2o4TzRHMFk5RTZkSmM3THkrUmF5RGNpZzkzZWZYenBzOWpUaXZ0Y3ZT?=
 =?utf-8?B?V2xMVjUwU2VHSTJrQ3dXNXNNbkRwSjkvM2R2MVdLWG5iVzZtNDdOeW9kSGFY?=
 =?utf-8?B?RVhPdUxZNnhFb2VGVnVmekZSL1I5Wk5yemdaZVk4cy81Y2hGcWVMcUg4NFJD?=
 =?utf-8?B?NmlZajFRZnFzRk12VnJqSUJlcXVWMjRDZGMvS0hKUllTeG1zelNib1JIa1Jz?=
 =?utf-8?B?ZytJOVJuVVJJL21QVXc1MUhZUzJ0dzBNZDB5VHhkam1mU3d2cTZoTlNoYzAw?=
 =?utf-8?B?eFJxdXVhQzdFRWZBT0Zsb3cyUXNSYWllRWJ2QWdWVVZOeTRZTERBSjhnNW94?=
 =?utf-8?B?enVnWk5WMU8vcStVM0tCTHRYeHBTSXJIOXJzZUNWTThpQm9EQWlFMmpIZEd0?=
 =?utf-8?B?ZUhIbDBIYVFRRnhrcmoxMkhPelNWZ2dVdDBsYWErSFJWMkdmWlRMeWYzbXFW?=
 =?utf-8?B?NWc2TlBZTUFvNUdyYnAvSlpMMUc2NnVIWmt5TW9rSU9KU0toTWJ1aldXZzJk?=
 =?utf-8?B?SEV4S09yMU1jcThxK3RZRWQzcU9CU1k1MVk2SmFITDRpWGxVR1lEOXpaWE5y?=
 =?utf-8?B?SFR1WE80aEJMWEhMZUE5R3h2WlMwNWd3QVBXNmZnWE9mdmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm44anhiQVFka3VBeE5OODhObEF4WTZna1FQckpjV2NUYk5Ed2pHQ1ZuVk9k?=
 =?utf-8?B?U0NXTjJIeTI3VmtSdjN6d3BUTy9iSWxyYzByTm5Cem9LRTYwdlZkSWk2bFdx?=
 =?utf-8?B?dUZLVGl0clVMYWFJNXEwSUNXRGNBSzNHbmVRR3lrZm5IU2pRVW5jZHBGMEwy?=
 =?utf-8?B?WVhHMFZBQzllbnVxT0NMTWhmQVBjM2x2bHJlQWVTNXJJYXdxTFFyQkx1WDBh?=
 =?utf-8?B?cERkQnpGcmdkM3BQU1p3a3BzRXd1dSt6VWU1WXhRclQrZWR3VmhRS1BnTzRp?=
 =?utf-8?B?WXB2bk5HaGsxUEZFQ3FuVWFPQTFQQXRTbFBCakpmRHJQNE80ZGs0SFVHRnRP?=
 =?utf-8?B?VXBkRzVhMEl2YTN6UEVjZ0Y1SWI0eng5OC9TckNRRTd4WnhoczIyMXloeUVj?=
 =?utf-8?B?bmZqajJCOEJpMFFiOG5ueWUweXU2S1h3cVI3YmpJOTFyS2dOOVQ4ZTlabjcz?=
 =?utf-8?B?cm5ZeUlteGdzNUR3a2hCdWVTc0hyWXV6Vndnemxlb2xrYjN2bGFSMEJaa3dZ?=
 =?utf-8?B?Y3psSXRRQ3hhR2NXdjI4THlxbGR1dmUrMmtvTitxeDYzUjU0VlRMN3Bid0Z6?=
 =?utf-8?B?N1VQTlhTU3hzdTdqM3NkVU1CMzRmSmJ6Lzh5SVoxWTNMc3gvYStYdHYyVEpm?=
 =?utf-8?B?K29Zb0tNMWFtOTd0TnJlREVORnhZMmhyRGljT25nNStQT2lQdkFaeFNZeHF3?=
 =?utf-8?B?bW1hcDMrR1NjdUFxQ2dydnM1SWVqaHpudXprdG9waG5GcHpVMjd5ZXB4M1pR?=
 =?utf-8?B?Z3J1SXNmUmlnVlh0OEQ0M29KbWVBTGltZit4bEY5VUVWTG85UmcyNXJVSFN5?=
 =?utf-8?B?RmZNNjlocEJxMCtOTlFqemNWaVFiMlVrcHlXSzBTVTFMSFZlSVlwckQydzVj?=
 =?utf-8?B?Ri9uTFZQTkdpc0NnZURpOHFFbVZJNmMxWG5yWHp6Y1FFQUV3YjQrWkthelJK?=
 =?utf-8?B?OTVpWUtUZkNBVTZzVERyVHJoMFpBTUdOVkw3QklrVjdjTGI1QUt1WXM4THpr?=
 =?utf-8?B?K1AvZHM4YVF0RGhMN2tJSGp1L0NQYkxXNFpCZml2R0oyckM2STBGOGxVeUsx?=
 =?utf-8?B?WUhxTTNkWFYyRFdzd2RPbExFK2lxOGVXbDBIRXZyK2ttTXQzOTdrVU1ZOEpm?=
 =?utf-8?B?NFp3VU04ZUMyZ1hHTktJUmR3NnpNQzYzZUY2dm1VU1llRWVtTVFnSVg5bWZy?=
 =?utf-8?B?VU0vTitYeFVPKzBaVDlXeUJ0MHA2Nkk1V3ovUjJCaGs5UkpaSkhyVlYvemNj?=
 =?utf-8?B?Y28rdjNCMFFTc1c4Qkh1UFVyVUVMZmQ2bjlpTk9BaUFJTDIxMGpidzNZanlJ?=
 =?utf-8?B?TWZwdHRMYU5XNVhHcG1WRU5tZ1ZuQnA3TlBkeFlvSlNHeGxZYXkwR0w5S294?=
 =?utf-8?B?bDcxNExYTm1Bc2FEWlJLcDRaWUJ0VEJKZ3dJcHk5NVdSeVR0Q2JCNHd1Zkho?=
 =?utf-8?B?RUQ2NlJ2cEMvWXpMZG5YeUhXZEdRSUcyd1FZdFc2TkxxREQ1WHFqaUNFaEh6?=
 =?utf-8?B?Mzhja1J0ZjJwc0lxZHdsdU9wTGRtZyszeitNdzEvMWtoQytzUitiYW93K0hP?=
 =?utf-8?B?WU1uSmg1a1RDa2pscjdxWjd4MlVhdEk1WUtzeDBKaEpMSFpDQkprVUFYYWdT?=
 =?utf-8?B?VlRVQUVRZ09TMXZEZk5SZ0FJKzNZSFpRMTRMZy96K2RDSk0vV2lOSm9hbGFi?=
 =?utf-8?B?SHpPUW1maUt1czJWQzh4Zk5FWFFHbU1PTTBHSTBwa1Q3Mng3RXhaVnd5YjBO?=
 =?utf-8?B?Q1BpdjJQS2pWbm1jVHVxbU9VbHUxNUtlU04wOWh2RHR4YmFXRWt0NGhiZmV0?=
 =?utf-8?B?WWg1UERlcmROV0k3aGJ0WDBwTWlwY1dSK01zT1JzWG5wVWdRNnBYRXRjTGZY?=
 =?utf-8?B?M3hWajBFdS9lL2lXb09OVEFFM29tN2Q3Z0NNRzJuNkxLa1dKeXRLejdHby9P?=
 =?utf-8?B?V29sQ3dqT09kNVdBcWdEcDdnQkpDczFkcE0yRXNWT3NpcnBFU1BEYThQQ3BI?=
 =?utf-8?B?MWR2N29uT2psRlEwdTRuU0hTeTZ6SC9ucTJhc0tvWHpaemQ3OGdKUHd5OXZM?=
 =?utf-8?B?ZkpJT0FKZjFqSCtVeERSWDJ4bnVONGt5SC9kYThnaldvLzhMcWE1ekJORlN5?=
 =?utf-8?B?UWh1M3o4eWU3THM2ZVlXendFaFVDMWgzVWRoOWZlbk1vQk13VkxXRnhVQytr?=
 =?utf-8?B?SkFPeG9Obk1Pd3duanRMT2pDYnR6NURuUzl5bEh6OVltOWJRYWxnUEdFcERo?=
 =?utf-8?B?K0FySmZUaEtZc3JhYVpQeWNPenBRM2g2KzJ4N2dTbnROS3UxcC9mbjlUeldy?=
 =?utf-8?B?L3VVWExMSThZc3pQY2d6SnZIWlFGenlTVmtmMzE3QlJhRE1GNTRPRlk0TUJu?=
 =?utf-8?Q?+JfegQ3I0Lj9cc3oHNuLqQCp5ZkTaOLdUlHU7d6NL2QK6?=
X-MS-Exchange-AntiSpam-MessageData-1: VDSRMBT01rUERXk2gBN4ADUNrFZcFP4yUG8=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83543852-4c65-4664-5d7a-08de5147e32a
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2026 19:30:32.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CZQpnvaSqmdQ1A2FAQSavBjONz/id1U4czkY/b7993wSJeXEYVrqQLApgy3t4ed+HaveZ8rQM8JRfv3TPpyQPFj4PUYdgoHocfPFyiZeXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6557
X-Stat-Signature: hbg5zc4iwhrc1wn9j8exbihgjrrrzyht
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E3D64000B
X-Rspam-User: 
X-HE-Tag: 1768159834-529000
X-HE-Meta: U2FsdGVkX180p7A2GxyMkFjyX+mhUAmaNOumMxZrmvkAKewiC4+6zq5Hml3q+5mVpTNVHtGLjwi8P3tn592F5+FvqrgL8H8wGTvs3wIsbFhebUVX5+sPEbbv81e18DRjAQxqlz4GACi676Pxi5Y6hgYlPg20hkOtftxJF73nIUR1h37Ce3DncH92gYHrXmxnhogoSano5vw6So4sAehIqodPhUUHyIY7+upKPilo9VNPq0UEmk4LcgS2guWcOq4JsqG/S/V6Kx0c5hzYLv8oYR3kfKSaKuclWbwf+KNWtlfo/vORrXs5F5n9/p+lmizFjDgOit8iGc1ITkGtBOYlpjsq53AZA6G/uNy9MvuAM05FeNRT94FWunyttQExcPuZuviUhnkZ1i68uiWtjA7lnZEW7VkbgEnEVK9ZUMLI+4m83CGjuWAmMMoV9sZ3R84kEkuFqmG/Gwk+lxGGKIPmURatTpf17Psa83TXhzwmNIvzho3RS+OKoxRToUXSs9cVb2VW0FdsGIiEvKjTzbBESdDnuYzZmTTXuz0ag4NKBMtB3lsE5cTfebUQ2v+ycPWE8PDGJynhF94Z8efqlDK+hMfAKi4pSg9WlrFd/iV9U2Sklz/3OFVHsezaGYsqKWMtzMt6Sp9O6JAgmi3KIoBlTOMyH5+XdhKlmHtAk+BOJ+ujUFmNahnoHo5PTzfjSd0fJJ1IKcaoqfT42psuVKEIh0mZvNOovSLUwAHpyus/biBKnFIqhou7vo/FaM1o72LrYZLg4+NjTQAzXfYn5by/nzgu/8eHLT0kKcm0XkvyXKKFQMMr0W9MterukoZixE/Y+M51pJb0Sx71Xkj8GtCqGlFwZ0wK7iFn+oTi0qxXWGb/3T39qyRgE/9s78VxXddgvrE9oT2s5QEfXgAsfg82GEP7/A6/NKb06ZeoVvHCP+WoxGZXB7xUuEITKuv6Bdv8knam8rLM9cwJiei+fz1
 e/yiW2Tr
 w2DeS04/mk5B7KJ5yuaNrzJRrsBQ0qV1Y0hbuffLn6IusC4qOrjzJ4ca7bZ0840aW4z7sWniKA0wywAiuXOfIkRIc7W3FGPiinpYvRfPzk65Qhcf3wNzkpB80nKMwuP7BClZPQ+J49TCCN0QepE5htDL12Y2WrOpZ7E4W8ox+2owmv+hnscUC6xFZoYZpcw437CyEN3lo2D/thsdq5marLg1EyMUWx+AOZCIfR14L83CsTDqHtKB5ErdGBVyEEqY/2YAWB9VFNi5ZLWuEfNyulUz5IIHNQppQejxRO6Pa6LCQeQ4gONKvVfUTnkFEJG0QhwVuYwniAQ9KVLr+JfqOzCkcs1ZhZzc+Ff/6nTbWC3mxmD3ZGnsGYsTUltlSy7w+danPV7z5WLqXGTz2YxJ3DXpkike6KWEfHulYIkx13E4e3csrmblcycmOZVigtHpGyOAVaNMTqWNM8xIQQvUCBU5o/P/sD2ETUamcsta+jghPpfAukQM1FUXzBOMaWkuPQkb7HhxiDtapSqju8zVMbqx5d6x4a5d7cpk18QK5+AFETRKhiNgJgF8zRvb7Ryqf7MeJMIsgHXL4Ws4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-11 12:50, kernel test robot wrote:
> Hi Mathieu,
> 
> kernel test robot noticed the following build warnings:
> 
[...]> All warnings (new ones prefixed by >>):
> 
>     In file included from include/asm-generic/bug.h:31,
>                      from arch/arc/include/asm/bug.h:30,
>                      from include/linux/bug.h:5,
>                      from include/linux/slab.h:15,
>                      from kernel/fork.c:16:
>     kernel/fork.c: In function 'check_mm':
>>> include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'int' [-Wformat=]
>      #define KERN_SOH "\001"  /* ASCII Start Of Header */
>                       ^~~~~~
>     include/linux/printk.h:483:11: note: in definition of macro 'printk_index_wrap'
>        _p_func(_fmt, ##__VA_ARGS__);    \
>                ^~~~
>     include/linux/printk.h:534:2: note: in expansion of macro 'printk'
>       printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
>       ^~~~~~
>     include/linux/kern_levels.h:9:20: note: in expansion of macro 'KERN_SOH'
>      #define KERN_ALERT KERN_SOH "1" /* action must be taken immediately */
>                         ^~~~~~~~
>     include/linux/printk.h:534:9: note: in expansion of macro 'KERN_ALERT'
>       printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
>              ^~~~~~~~~~
>     kernel/fork.c:635:4: note: in expansion of macro 'pr_alert'
>         pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
>         ^~~~~~~~
>     kernel/fork.c:635:61: note: format string is defined here
>         pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
>                                                                ~~^
>                                                                %d

percpu_counter_tree_precise_sum() needs to return a long, not int.
Will fix for v13.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

