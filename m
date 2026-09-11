Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD37C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B481D6B0092; Fri, 11 Sep 2026 12:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2A16B0093; Fri, 11 Sep 2026 12:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B95F6B0095; Fri, 11 Sep 2026 12:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEE46B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:30:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B785A02F1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:30:09 +0000 (UTC)
X-FDA: 85202018538.05.C7A4126
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020077.outbound.protection.outlook.com [52.101.191.77])
	by imf27.hostedemail.com (Postfix) with ESMTP id DE82340006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:30:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=UaJ3HZ5p;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789144206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shtp49dbgB7YekIiLqSxk9tNQF9HIMjuEvjP0S+aDKQ=;
	b=sfhAoz1u7goCn4jRZnx4xn/m2zlGPGxUqaueLXW2B4PqkmtgrARkLdN0USWB6NejUt84OO
	uHwM6oc4435ul6ifQ1fDUNDTnVup3XSEt3A1ZiEZr6BgobzQduP9ATxsYfDdAQ5XrHuPCs
	EGLr5xX6EWWT+7X+spqdDPTZxjRcNlI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789144206;
	b=RrQoVFtBwMdb0r90er+dpIMa/6Giu8AaVbHk1j+iJJkitSAd6yJ22BiuxrMMruJ/1Svi5X
	+5hNxmDEF4kKSKYfApHtBpX6m1Apjc1MGT80s0wdU+cB3WHXduD5LuzirUUqvbp2WabtEV
	ERbbChvAZu2bv/odKu9Fju8EANX+De8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=UaJ3HZ5p;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrX7zHAQ/I0NRGDCdCIs/D2j4r1e7cw2IUK5N1j068CSDuak2INhuh6+xTL6q4/6vhxoGPCMa93tV9Jnbeh89wyR/mgoh7q4vztlCLqEWuxJVwMiNs5/ee473KFWULbXxBxq8u4ZcG63fa2wry65+C11NohtyB9ySwmsp7+3j0zpeyUUMZuszXz5hMsZPcX5Tiy+jSbq/1I5/m9JKu9kuvaY3yBAYWgvp+3OCLp5t7VzJsWbHhBKVFSl+AE2/Ls36hfyzJ96VWfmAsNW7j2vNQcK/Y9xyAmD1goaatMP7RrPAhad056DC7QS2MDgYLLq79Gy872HA5KQ7YzuzWsOeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shtp49dbgB7YekIiLqSxk9tNQF9HIMjuEvjP0S+aDKQ=;
 b=aBIJ52fxvDfVtPHtr+3mRKFMkq8mJMVihsgcb9XL5ITRU7u0ovrLIXh8AG3jx9WnqBM3WfA2HqxGzDPk7ZRbeLlVPrkFfePnvN8jK8pWCE03TMWyMH6StHzYfF6Ci3UMxeXLkE39F625BEklDPBE6/J5FhkKC1JTQWl4PAGAEDnuIevC4XqnW3Zl6EZsSVfmnM8/6WFSwOlEAmFPkt9OGypfw74Rkhh8gnzXPW/l0XoFzO9Xu82X/At4DCu88DQBoouAhlXGxcx5yL9Nx3XPIjo8yO9F/98Kj8LYDj3JK2wiJo41w+0a26mpVQD80MLmfWRVl3fK6ry206aa+wGGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shtp49dbgB7YekIiLqSxk9tNQF9HIMjuEvjP0S+aDKQ=;
 b=UaJ3HZ5pMr2UA70x0fAwTYH/e1DCpbHeA5lzqlcS61UlGYrYP55v2ioRJfVnbHQiIF9D2PLW/PLixOaVDIUOQb7eT/9X2gSSKxgqDyaUw7CMTNeEHtFUjhjfWcDG5bMzOvN8wGoLJDURCtMK2ylCg770oZVN/WQUY6aaBNJCmximMGTNvJDHfI1GVC842aZmA6JcsMkOHUjpK8GLDcSU3Y6RcspdUdR7VWBXlbZBsapsF7Tej+t0e4TjmV75y58L08zkYMIOn9m6YrWVzFV020A+zNiOg35nMCEbSP8pnl9xFR1m4INPC8oliIT4sRsevjmI8C87F2nzIWy44x/nFw==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YQXPR01MB5540.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 16:30:01 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 16:30:01 +0000
Message-ID: <f576b7d8-d8d5-4ecf-8663-015c159e6146@efficios.com>
Date: Fri, 11 Sep 2026 12:30:00 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 1/6] lib: introduce hierarchical per-cpu counters
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, linux-mm@kvack.org
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
 <20260901182857.26690-2-mathieu.desnoyers@efficios.com>
 <9c4a267c-921a-482a-91d1-6e84f611e7d5@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <9c4a267c-921a-482a-91d1-6e84f611e7d5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0078.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::9) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YQXPR01MB5540:EE_
X-MS-Office365-Filtering-Correlation-Id: 68310353-8e0d-4202-c721-08df1021ed69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vNAG1P/0hbUvmmyjsVyV3cHEULt5lUwOj9QNoslD9TcTfGU9oTrajEWlBXiLQkV58GprqJ5HIwFnJrNSOUc+BN+ZNtvi47Vgg0IzE+javirHPm+7g64tCfRNKNGw3AsAMkDiSDmfjfirATDw9w5dJm4BxCDbXPJAclEB9nLZ2Dc2AtSAO/+p5aLC8JNpo3gUwy1A94qgIpS01RtNlghS6w72CYHWxWKfqUhmWtU0dJ7d5eWAwUgC1i6qbRkwYm+i9KVJx/QFAtJ6ZOZtrdJgnA6nqBrhr6CFstqPSRFET/ndQSLTzvSeSGMPt1EwsOzFtEqrEQdNWH3hYPN4AUW1XBVSv3lUckah7avx0SrALBhwRehNTt9qzEpjzsG84mYX4Q0rU+hBV2ABEH05R4smf1oHfQ3i9i7/UH2kcTKNGNzvMtdFD97KXwyGR/f8ZOcOKKeWLnIobvopDFxdRHM90Jfx4ju6mrbBQuEB0SgEOVjbTLLPL9MAxHlAkz9x8Y1K1itFpaXiNV/pTWW/WNJHB4sKvA51C39tgzArB/Sv6iibastslTaomzybJVJBgHGll5Y0rzDMT9JfQUcrqQ7L7PhgiNoXFXeQcFY2700kT5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1hkazFicGRPbXorUXRkbzk3SHVWZ1BQVEt1M00zYjJoZmgrSWhDVEVxUzM4?=
 =?utf-8?B?MDljVDQvcFdKSWRPS0toOVJGdG1Za012dlYvaFRNR0M5elF6UDBWc3l1YXJV?=
 =?utf-8?B?dmZpZjJJSXY2cWgrRnQrTTVIcGVPQnFwd1pUUWhWYUxQdklvcGVMMGRNUGFI?=
 =?utf-8?B?cUlFMG5RUk1BM2QySXA2Uy9sV0N1OTNwM3l2NTZ5aytLQVZ0VW1qQlIvNDlr?=
 =?utf-8?B?QlRQem5XaGJiSEFlNEQzTEQvZVgySzZoVVl2T1N4Z2pWWVZ6d3NKVWNKb3VK?=
 =?utf-8?B?a3JhSW1yaUtGSFNJK204YnFwdmZ2UDhaWWJ3Y0U0d3NCSE1jMlAyamlUajlD?=
 =?utf-8?B?dCtxTlQxSVpsQnpKb01Rek9ONGNaaFRnb0hmcHA2a2wyQVhvMnRBSDI3Y3lz?=
 =?utf-8?B?eTJGRnVoUnNJMGVYQnJ2b2JpdURiWURqL0k2TWZqbkYvMlVvaks5RktFMmUw?=
 =?utf-8?B?NGFsWVVZVDk4MGgvRjJ2cDlCU3IyQTJIUnl2T0M4UHZHNXlpcWZqTGlDVUFl?=
 =?utf-8?B?TDhUbUJlUGdNSFlZak1PdnBsY3B6YS9wblJtSUZwQUZoNzRvMU41UVR6Vk55?=
 =?utf-8?B?dGw1dTByUTczZFZhUk81RlNyVjVUMGN1bnpGRGpKcFlBUTZyTnM1Y3ZrUVV4?=
 =?utf-8?B?cjR1amszU1d2VDhhUFBTWEM3VFY3UlMrL21Ea2V6R0hodmw4c1VPNjBTWEdO?=
 =?utf-8?B?UmN3QTVjeUp0aHZuOFdPQ2pnSi9KV0pTSWp1M2s0NmVPZXRxc1JqMTkrbzQw?=
 =?utf-8?B?WnhkVDdrbDFYei96aVVnWXZrL0lsd1E0QjBLK0p0UjY5MENjZi9OSUlwNkNa?=
 =?utf-8?B?ZDRmM0gwT2prSlplclVqaFFJZCt2ZmpjQWRocjROSDA5YXZzU21WUjU1VlFt?=
 =?utf-8?B?ME81NjJOamlOb1RCS0dYenNyUUUxMmEzcG5pQUdPQ0NpNk5OaFUxdE04Q0N2?=
 =?utf-8?B?c3llNGdyaVRLNFdGN1pFY2ZWNHdVY0N1cDBCMHI3dDBZKzU5K0E0ZElWdnR1?=
 =?utf-8?B?N2l5RFNNY2xlbFB6NG03bk5yaFhtY2duYzQxQ3U4Y0E1QXJXUzNuK0lDS2lK?=
 =?utf-8?B?RWM4RkRpV0NvQXd2RnBXTEkvYVRFV0tnT1Y3TFBjOUlIYy9EVEJKeUI1OG9y?=
 =?utf-8?B?U3REeUZaSEZZVC9UMklvMmVudUx2WXJVU1JxVnlLQnpDZTNPV1dEa2I5M2Nu?=
 =?utf-8?B?ZUZMenlBRnpkalBXaVRHdUladW5HTlZzVjh4b3M3Z243cGtlczNUU1hON3lZ?=
 =?utf-8?B?NHduN2FxQnlESUJDdzFVVFN6ZGt2SHRoTGlLdU03M012amJhWXJOMU9TWCtE?=
 =?utf-8?B?TExSV2pCZjUwNm9NczNCbnBoMGpnUjg1NHFuWTYzY1BmY29sRVdYQ3ZrTWp0?=
 =?utf-8?B?U3NKcjM5VVNBUDc4Z0dWNTVMdDVPQitGWXhvcWgxcUROYzRWdjJrdUZMZDBJ?=
 =?utf-8?B?LzVpZW1DVkNQeGRUVHROSEZ0Sm5Da1FxdHhkRGdGc1NNODdrV1NDeG9ZS1By?=
 =?utf-8?B?bWxQeHNMZ2d3TGQvZTF4TFEyd3Iza2pqTko4bFA3T1VManE1aSs1MGpVSVNJ?=
 =?utf-8?B?d0VlVTRic3ZxK0h2OXFiZS9lekVRRjNpMTBIeHdpTW9NcUNZb1hDM1ZBSG9S?=
 =?utf-8?B?RDZ6NDhqTVhmVnZXVUVMZXpxRVpLZEhJdlpXTTROS0k2NUt0ODNmQ2pWeXl1?=
 =?utf-8?B?eUpkSjBWcGJORWppK3hoVlEveDVXajJlL2FlWFFSSHprMVpzZ3I3SWxUWUFV?=
 =?utf-8?B?OFpmb0daV3NmbWZUS2tHNXNmamt6Vm4wcjNhMHd5TWRZTWRJbllDMmRpQlZW?=
 =?utf-8?B?RVQ5TVAyVmFDVzhsMGhHS0kwZm9MVWtmZ282VGpEQlFsa2p0T3ozSjU5ZExm?=
 =?utf-8?B?NitUZlhPTWpKQ0pqenpSV2VvYlFkWUZ3VS91a20zMXBMTTVFRVBJMHh2aUVP?=
 =?utf-8?B?YUZGcGhWSEZ6T1dhTzFVNDNCQ1BlTXhacGVKQmUyaldOaG84MmF2L3pueXR6?=
 =?utf-8?B?T3dJUlZCemZudHlTalpZN3ZZa0JyMHNvSDFGWWc3QnBDbVNRK1JleXkycW81?=
 =?utf-8?B?cnBZTytxMnpEK3YrT3pGRmZEQ0ppTVV0SnNoWWVZaUZMbmZ3WW1VdGZhVkJI?=
 =?utf-8?B?ajMvdU5QNXZpYlg4L1dRWXhYZ09EdnF0blR1c2Y5TFU5UUgxWU9KTHpyb3BG?=
 =?utf-8?B?L0V2ZmZZcTR4aE1LUGV5RCtzVkU3WVVJM3lMQTE3dXBCVlZhRndJSHg2UHI0?=
 =?utf-8?B?b0xpKzQ1YXdDZ2kyS1VMS3QrbnQ3WGxYcUVjekVMSXNwWkp6b3ZSbnIrem1H?=
 =?utf-8?B?b0x5VllMQXdrWUhQRDU4MDBQUS9aSzFTSUNyYmxmUTVEVGZrMFNKN3dtVXRO?=
 =?utf-8?Q?ZWlqnyVhi7vaVmEk=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68310353-8e0d-4202-c721-08df1021ed69
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 16:30:01.4427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8L9UxOg9zYiYL5Xn+qcsWtUV9qk3mX09qKe+24xbdjXYYe/FAT57qZAZz3LfNoqSg/nPjDblsCUr0yM3aIdhjTr4x+z8PI1GuBG/zpLdPHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5540
X-Stat-Signature: paporwuydpfr4h5kswmx5n1qtqcf7b94
X-Rspam-User: 
X-Rspamd-Queue-Id: DE82340006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789144205-803687
X-HE-Meta: U2FsdGVkX19QrG+3zNBwWO1UjpfFBonAsqwjRS3mNW0GJxwvgLvIt7PrIJD2TTLt/MDmhEzdhPkQ5VfYK78EJz3okUqgPqFXiwxPZ4HP6JLJa+YL8HWLK8WP3MUwaOktZ+9TOMTeQ2OQBe6vDaD3fat8LR1uMQcl3TDYJPQD3iIiEF0MhL36cEvtqxEko30/Drs9CptuD5wHXHoMjJxU2ImAKlfnNbbsOQX90KBPzWO8tZfnWZ8vunYrvG+wFiTDXWnO3XwskteL6nZP0u4nxDz7/dTY76yHrGvj1GKrQe7qgUnR0olr9pG5NWmcEN9HuW6wMsfta0FUjCjMEyLL4V4pMz97e3pmlNezh/91UtQEfIkL3YcY/K6tAZeL4iALaEgzDGviYcB2G8VTakUTviJsaZGRLuQkCZvG2OcwlKZaua67Xigk7cyO+erSuaZiQZ7X1DKVHyw0ksJ52H9Llyjj/vtBK/95jS/rCSwZEKt73WdiRaO78n1iRTFEbC/RLEyYR8UqVkXqckTF6t697JMml4TPc7ZAs9WCRLnxdnTXEzLsdhvY3HCmji1jDMa+4ghGHMQ9sg7ejuT1ctBud6HiCLf7iOv53TqKDhR9jvrrPnILKSvn9w3nYPVgq5tKZCY2iewUFfLFaZyVLUlp+hv0Xm2FA5Q12UO3k8vV4LbJ3GAiQ9kCm8XPjtghs2UaEUA4yx3llEhSYzAkskSNlv6ylgc9/NMI3/iSwtpu9OIiaEKQ/u0SIN6MeKk6DYNK1KbS6ODnSeIyztGFynv3HDAL2hCbENdyY+GpQ5+rpTV+lRqbfAjVs++R2Z6kXPdipmarqdD6uqSl2HhDT63l9Ri7gAOWj1JOtZwgS3A2uAtwqir0+xspYrQsieX+Tn9xZOLgFyIq+0IVKIYyrOXp/riQW4z4uhiDHYe4X1wfbq51fmoYCGX3mLMLa0hiXpWomIyJhF9Xb8GClZCjRqE
 Oj/lOiVO
 Ua8s96MfrxHkoSzC73Yy4AtUTbm8tiMBCfisY85KkjeY/S4sAjsHf9RSgfng54mHHrdnScBjcBuyYPucqW0LKm0R6cUAFoxQMVzCrg9QCNEYZnbwTWMhadXdQeQChxZ9wXmYBFvuu2hC2jkXhA/R0DeX7NxnTicQ5fYjjHeVnDegGB9bmgniC+tnBO9FEUfu8ZkYWTxpMQeNsjJwCd6DXGIAZLJ/4R78QvXH475FqCfBG43JexkInGrzLLkfpDVy9iP+GGH0UtLyau9z53MPXN85xp+mlG+KNHvl+FBS1SmlEvnj+Uhz/DH5dwKg6l6xdda1BEeaIaJgPlXERP6lU88t9LM9K6kuXV9JDiRvc955KLTZQ/dYNyYq6EbidBGP6NyTU/pT24jCSHQDeDoZtFMgpEVccW+mZTpIxKAKtJIcL+FcyiP/Hg4STD+OxrLc7xy8iAWVkoKWOC8HiA6xOxHitwYNov8cwJo4SmPTuhvIwvl+wvTNJKrTH2jQWH6w3Fb7qvQU5srK3aOC7JuQN+VUvpIgUxVUzoNtT2JySaYP6Mkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 08:24, David Hildenbrand (Arm) wrote:
[...]
>> diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
>> new file mode 100644
>> index 000000000000..828c763edd4a
>> --- /dev/null
>> +++ b/include/linux/percpu_counter_tree.h
>> @@ -0,0 +1,367 @@
>> +/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
>> +/* SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> */
>> +
>> +#ifndef _PERCPU_COUNTER_TREE_H
>> +#define _PERCPU_COUNTER_TREE_H
>> +
>> +#include <linux/preempt.h>
>> +#include <linux/atomic.h>
>> +#include <linux/percpu.h>
>> +
>> +#ifdef CONFIG_SMP
>> +
> 
> Would it be possible to document here how these values are determined?

Those come from lib/percpu_counter_tree.c:

static const struct counter_config per_nr_cpu_order_config[] = {
         [0] =   { .nr_items = 0,        .nr_levels = 0,         .n_arity_order = { 0 } },
         [1] =   { .nr_items = 1,        .nr_levels = 1,         .n_arity_order = { 1 } },
         [2] =   { .nr_items = 3,        .nr_levels = 2,         .n_arity_order = { 1, 1 } },
         [3] =   { .nr_items = 7,        .nr_levels = 3,         .n_arity_order = { 1, 1, 1 } },
         [4] =   { .nr_items = 7,        .nr_levels = 3,         .n_arity_order = { 2, 1, 1 } },
         [5] =   { .nr_items = 11,       .nr_levels = 3,         .n_arity_order = { 2, 2, 1 } },
         [6] =   { .nr_items = 21,       .nr_levels = 3,         .n_arity_order = { 2, 2, 2 } },
         [7] =   { .nr_items = 21,       .nr_levels = 3,         .n_arity_order = { 3, 2, 2 } },
         [8] =   { .nr_items = 37,       .nr_levels = 3,         .n_arity_order = { 3, 3, 2 } },
         [9] =   { .nr_items = 73,       .nr_levels = 3,         .n_arity_order = { 3, 3, 3 } },
         [10] =  { .nr_items = 149,      .nr_levels = 4,         .n_arity_order = { 3, 3, 2, 2 } },
         [11] =  { .nr_items = 293,      .nr_levels = 4,         .n_arity_order = { 3, 3, 3, 2 } },
         [12] =  { .nr_items = 585,      .nr_levels = 4,         .n_arity_order = { 3, 3, 3, 3 } },
         [13] =  { .nr_items = 1173,     .nr_levels = 5,         .n_arity_order = { 3, 3, 3, 2, 2 } },
         [14] =  { .nr_items = 2341,     .nr_levels = 5,         .n_arity_order = { 3, 3, 3, 3, 2 } },
         [15] =  { .nr_items = 4681,     .nr_levels = 5,         .n_arity_order = { 3, 3, 3, 3, 3 } },
         [16] =  { .nr_items = 4681,     .nr_levels = 5,         .n_arity_order = { 4, 3, 3, 3, 3 } },
         [17] =  { .nr_items = 8777,     .nr_levels = 5,         .n_arity_order = { 4, 4, 3, 3, 3 } },
         [18] =  { .nr_items = 17481,    .nr_levels = 5,         .n_arity_order = { 4, 4, 4, 3, 3 } },
         [19] =  { .nr_items = 34953,    .nr_levels = 5,         .n_arity_order = { 4, 4, 4, 4, 3 } },
         [20] =  { .nr_items = 69905,    .nr_levels = 5,         .n_arity_order = { 4, 4, 4, 4, 4 } },
};

Currently they need to be kept in sync manually between the public header
and the implementation, which is error prone. I should do something about that.

Note that the nr_levels and n_arity_order are only used within the implementation,
so ideally we would only have the nr_items values in the public header, not the
rest.

Those values are calculated by calculating the number of items needed for the tree
hierarchy of a given topology, excluding level 0. For instance with 8 (2^3) CPUs:

  * Level 0:  0    1    2    3    4    5    6    7
  *           |   /     |   /     |   /     |   /
  *           |  /      |  /      |  /      |  /
  *           | /       | /       | /       | /
  * Level 1:  0         1         2         3
  *           |       /           |       /
  *           |    /              |    /
  *           | /                 | /
  * Level 2:  0                   1
  *           |               /
  *           |         /
  *           |   /
  * Level 3:  0

we need 4 items at level 1, 2 at level 2, and 1 at level 3, for a total of 7.

> 
> Without that, ...
> 
>> +#if NR_CPUS == (1U << 0)
>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	0
>> +#elif NR_CPUS <= (1U << 1)
>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1
>> +#elif NR_CPUS <= (1U << 2)
>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	3
>> +#elif NR_CPUS <= (1U << 3)
>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
>> +#elif NR_CPUS <= (1U << 4)
>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
> 
> ... I'm confused why two separate statements share the same number.

This is because both 2^3 and 2^4 have 3 levels, but the fan-out changes. We go from:

{ 1, 1, 1 }
to
{ 2, 1, 1 }

so even though we have twice the number of CPUs, the number of items is the same
because the fan-out of level 0 went from 2^1=2 to 2^2=4 (it doubled as well).

> (should we simply drop the "elif NR_CPUS <= (1U << 3)" in that case?)

We should, it's indeed redundant. I kept it to have a 1 to 1 mapping with the
static const table, but if we introduce a compile-time check that they match
dropping it is not an issue.

> I do wonder whether there is an (easy) way to encode this into a formula. I
> assume you tried and it got too hairy :)

generating it with a formula gets quickly complex in a way that makes it
tricky to review.

Something like the trick below would allow us to make sure the values match
between the public header and the implementation, which where I think we'd
really need validation:

* Public header:

/* Number of inner nodes for a tree covering @nr_cpus CPUs, -1 if unsupported. */
#define __PERCPU_COUNTER_TREE_NR_ITEMS(nr_cpus)		\
	((nr_cpus) <= (1U << 0)  ? 0     :		\
	 (nr_cpus) <= (1U << 1)  ? 1     :		\
	 (nr_cpus) <= (1U << 2)  ? 3     :		\
	 (nr_cpus) <= (1U << 4)  ? 7     :		\
	 (nr_cpus) <= (1U << 5)  ? 11    :		\
	 (nr_cpus) <= (1U << 7)  ? 21    :		\
	 (nr_cpus) <= (1U << 8)  ? 37    :		\
	 (nr_cpus) <= (1U << 9)  ? 73    :		\
	 (nr_cpus) <= (1U << 10) ? 149   :		\
	 (nr_cpus) <= (1U << 11) ? 293   :		\
	 (nr_cpus) <= (1U << 12) ? 585   :		\
	 (nr_cpus) <= (1U << 13) ? 1173  :		\
	 (nr_cpus) <= (1U << 14) ? 2341  :		\
	 (nr_cpus) <= (1U << 16) ? 4681  :		\
	 (nr_cpus) <= (1U << 17) ? 8777  :		\
	 (nr_cpus) <= (1U << 18) ? 17481 :		\
	 (nr_cpus) <= (1U << 19) ? 34953 :		\
	 (nr_cpus) <= (1U << 20) ? 69905 : -1)

#define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS		\
	__PERCPU_COUNTER_TREE_NR_ITEMS(NR_CPUS)

#if PERCPU_COUNTER_TREE_STATIC_NR_ITEMS < 0
# error "Unsupported number of CPUs."
#endif

* Implementation:

/*
  * X(order, nr_levels, ARITY(arity order per level, leaf level first))
  * Row "order" covers nr_cpus <= 2^order. nr_items comes from the public
  * header and is checked against nr_levels and ARITY() below.
  */
#define PERCPU_COUNTER_TREE_CONFIGS(X)			\
	X( 0, 0, ARITY())				\
	X( 1, 1, ARITY(1))				\
	X( 2, 2, ARITY(1, 1))				\
	X( 3, 3, ARITY(1, 1, 1))			\
	X( 4, 3, ARITY(2, 1, 1))			\
	X( 5, 3, ARITY(2, 2, 1))			\
	X( 6, 3, ARITY(2, 2, 2))			\
	X( 7, 3, ARITY(3, 2, 2))			\
	X( 8, 3, ARITY(3, 3, 2))			\
	X( 9, 3, ARITY(3, 3, 3))			\
	X(10, 4, ARITY(3, 3, 2, 2))			\
	X(11, 4, ARITY(3, 3, 3, 2))			\
	X(12, 4, ARITY(3, 3, 3, 3))			\
	X(13, 5, ARITY(3, 3, 3, 2, 2))			\
	X(14, 5, ARITY(3, 3, 3, 3, 2))			\
	X(15, 5, ARITY(3, 3, 3, 3, 3))			\
	X(16, 5, ARITY(4, 3, 3, 3, 3))			\
	X(17, 5, ARITY(4, 4, 3, 3, 3))			\
	X(18, 5, ARITY(4, 4, 4, 3, 3))			\
	X(19, 5, ARITY(4, 4, 4, 4, 3))			\
	X(20, 5, ARITY(4, 4, 4, 4, 4))

/*
  * ARITY() is never defined: consumers paste a prefix onto it, so that
  * __PCT_LIST_##arity turns ARITY(3, 2, 2) into __PCT_LIST_ARITY(3, 2, 2).
  */
#define __PCT_LIST_ARITY(...)	__VA_ARGS__
/* Pad to COUNTER_TREE_MAX_LEVELS (5) entries; "+ 0" keeps ARITY() valid. */
#define __PCT_PAD_ARITY(...)	__PCT_PAD_(__VA_ARGS__ + 0, 0, 0, 0, 0, 0)
#define __PCT_PAD_(a0, a1, a2, a3, a4, ...)	a0, a1, a2, a3, a4

#define __PCT_NR_ITEMS(order)	__PERCPU_COUNTER_TREE_NR_ITEMS(1U << (order))

#define __PCT_CONFIG(order, levels, arity)				\
	[order] = { .nr_items = __PCT_NR_ITEMS(order),			\
		    .nr_levels = (levels),				\
		    .n_arity_order = { __PCT_LIST_##arity } },

static const struct counter_config per_nr_cpu_order_config[] = {
	PERCPU_COUNTER_TREE_CONFIGS(__PCT_CONFIG)
};

#define __PCT_CALL(m, ...)	m(__VA_ARGS__)
#define __PCT_SUM(a0, a1, a2, a3, a4)	(a0 + a1 + a2 + a3 + a4)

/* Inner nodes at level @j (1 = parents of the per-CPU counters). */
#define __PCT_LVL(j, order, levels, sum)			\
	((j) <= (levels) ? 1U << ((order) - (sum)) : 0U)

#define __PCT_ITEMS(order, levels, a0, a1, a2, a3, a4)		\
	(__PCT_LVL(1, order, levels, a0) +			\
	 __PCT_LVL(2, order, levels, a0 + a1) +			\
	 __PCT_LVL(3, order, levels, a0 + a1 + a2) +		\
	 __PCT_LVL(4, order, levels, a0 + a1 + a2 + a3) +	\
	 __PCT_LVL(5, order, levels, a0 + a1 + a2 + a3 + a4))

#define __PCT_CHECK_ROW(order, levels, arity)					\
	static_assert((levels) <= COUNTER_TREE_MAX_LEVELS,			\
		"percpu_counter_tree: order " #order ": too many levels");	\
	static_assert(__PCT_CALL(__PCT_SUM, __PCT_PAD_##arity) == (order),	\
		"percpu_counter_tree: order " #order ": arity orders do not sum to order"); \
	static_assert(__PCT_CALL(__PCT_ITEMS, order, levels,			\
				 __PCT_PAD_##arity) == __PCT_NR_ITEMS(order),	\
		"percpu_counter_tree: order " #order ": nr_items does not match levels/arities"); \
	static_assert(__PERCPU_COUNTER_TREE_NR_ITEMS((1U << (order)) / 2) <=	\
		      __PCT_NR_ITEMS(order),					\
		"percpu_counter_tree: order " #order ": nr_items not monotonic");

PERCPU_COUNTER_TREE_CONFIGS(__PCT_CHECK_ROW)

One alternative would be to derive the public header nr items from a formula, e.g.:

enum {
	__PCT_ORDER  = order_base_2(NR_CPUS),
	/* at most 8-ary per level while that fits in 3..5 levels */
	__PCT_LEVELS = MIN(5, MAX(MIN(__PCT_ORDER, 3),
				  DIV_ROUND_UP(__PCT_ORDER, 3))),
	__PCT_DIV    = MAX(__PCT_LEVELS, 1),		/* avoid /0 for 1 CPU */
	__PCT_BASE   = __PCT_ORDER / __PCT_DIV,		/* arity order per level */
	__PCT_EXTRA  = __PCT_ORDER % __PCT_DIV,		/* leaf-side levels with +1 */
};

/* Number of inner nodes at depth @k (root is depth 0). */
#define __PCT_NODES(k)							\
	((k) < __PCT_LEVELS ?						\
	 1U << ((k) * __PCT_BASE +					\
		MAX(0, (k) - (__PCT_LEVELS - __PCT_EXTRA))) : 0)

#define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS				\
	(__PCT_NODES(0) + __PCT_NODES(1) + __PCT_NODES(2) +		\
	 __PCT_NODES(3) + __PCT_NODES(4))

static_assert(NR_CPUS <= (1U << 20), "Unsupported number of CPUs.");

It's more compact, but it's also less straightforward to understand how many
items we end up with for a given order.

Any preference ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

