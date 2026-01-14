Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0FED39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C206B0005; Wed, 14 Jan 2026 14:19:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E302B6B0089; Wed, 14 Jan 2026 14:19:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF44B6B008A; Wed, 14 Jan 2026 14:19:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD4B46B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:19:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CB8986E70
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:19:46 +0000 (UTC)
X-FDA: 84331533972.03.35D45E4
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021138.outbound.protection.outlook.com [40.107.192.138])
	by imf18.hostedemail.com (Postfix) with ESMTP id B80701C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:19:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b="VG/3U0Mb";
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.138 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cnxIB+8E9Uh6zM9kr46kDWZKmgUHSmjnoRUk2iQ+LY=;
	b=PkKk6EQ7nXWchJmKdqpN9IYmaYq7TxQ6oErJyHUtkqXqDA13+hDafdTe+iVBmuX5V9jlbq
	jCv6dyIchQdvxTeTc8jlvPbhUK7y1UYlYhMR7q8WBKvTZgticPNOllWzNquyeipZQdo5l8
	gc0Ge51ftsyDTibwiaorm0XPtTy6OnA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b="VG/3U0Mb";
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.138 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768418384; a=rsa-sha256;
	cv=pass;
	b=aB8E7vBatO1Z9YiJoKEXLCOSd1sfXo58j6E3UP0A00o4H4+Wub29ZuIyiOyf5Gd2uU7yHw
	lU0s5P9QwE21bW05UMW18CqzLRVsMEAx4b7Gn9ON4gKrNs0X/NB0WsDThGzzqwVGjvmXYA
	J2LLRN0cnYy2xlQrTbZ/vykcrA1kZGg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMUfkbAjAh32lgUNDkc4yMUtvuKUWERlXdaqq98SKJNosjuyL+si90Cx1kxMNWO8sZKI5NUS5pKB5FgIEC5SvlxaMMYg8Lh3gK3fP2ujj11bHPgsIwGSDKsYpkmM3c04c6N6iljR2TvQi/qPWMBpnvjDntF/limQ8Bo9lxCKZGabda58oKUQc/3cuU5niRI1cHwJ22+1O02KtFf19yQW5Pmzt8MoEJIe1kDKMRnTqYiTGiu9sOuE4L2JIJLwtvzX5dJcoyiXtPlLrnCtfx2yt+766yKYJeFHfPSYmtORo/hT/4BTCyjEdTNbh8uY6Q60bFME52grgrVsPSicicnZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cnxIB+8E9Uh6zM9kr46kDWZKmgUHSmjnoRUk2iQ+LY=;
 b=PUUe5Ckk4eW1fZv7XEAlL4az0DWGUBbw4pcquxsBQ+g8gfaCxDgZfWkvtm2Lmj8AmEU8ihWYW8VPkw4HLoN576WfrSAwtAYORVLpNmQ2UQH8UvbalsP4RE5+Bnmw6Q/Qmcr0yTEg9IOwA42MM+66PNKlXXHwG6z7en2OXLb5En6VVT2Lr3vCHpNQCVuBxjNonBIc1pgbAowasyAvTHeOwHbQcMXeLjy38b47Uu7AAZBl298+1hKzLpa+G2vgEoyixbTCPldFPB3MTnrmIxbQdtLmhr+WvsLjyx1AJ9BDqPPv3+nzyfP4rEXVSgntJRNIN5LvvAoxOXAIUawcQaJzwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cnxIB+8E9Uh6zM9kr46kDWZKmgUHSmjnoRUk2iQ+LY=;
 b=VG/3U0MbEGFE4fdOzPycJRI4Llh2eesRGcDyusyuhMSEZOvzIC8mj9tbrkQk90av/vhPEITAX9+AdYc6XCXUYwM1t6fehQ38JVJvbznL3gRKqPoHMAYy+0nOsefJuI/s8m6IcE5zRTBwnKyE/aKwBFe9rfqfHAguUnHL52ugk6P6Z4s3S1gTJIH/jOdgXtZqWFrZeT0T9JuJ12JvVwd7lyTrIraPnQLPv+UgMgJJUM/UplawrxQsQpYDMkXCG0nxFmw3IGTx9xk947SPfNzdYhp7n3ouvHYwsvGl0zq0MvRqi633U13CBOU42nAczNUeFW/Bwbs1cWPzsFpcMzlUVg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PR01MB8330.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Wed, 14 Jan
 2026 19:19:40 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 19:19:40 +0000
Message-ID: <67bdfd38-1acf-4b90-9e34-ce752632ddb1@efficios.com>
Date: Wed, 14 Jan 2026 14:19:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 1/3] lib: Introduce hierarchical per-cpu counters
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-2-mathieu.desnoyers@efficios.com>
 <aWfHTLDA8-Fja_gD@tiehlicka>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aWfHTLDA8-Fja_gD@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0267.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::22) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PR01MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: 01d9c280-e972-4b52-4ee3-08de53a1dd54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SW9FY3JacTVhdktHb3FyMCs4ZFgyYU95ODlZTC9hdng1bUhlYVpxeFRRS1Nl?=
 =?utf-8?B?QmtqMmxDVWthYVpEeWs4dmk3K0pueTRPbzB3V0wxci9rVUVlQ2hhWkRYOFpQ?=
 =?utf-8?B?U3hGcXFiTTZQUlV4akVFdHZLSWFhSUZncklMQWpnSnRuZk9mUjU0MWh3UjI1?=
 =?utf-8?B?d3R6RHhoenpDanpPeE5LS3J1UzdZeWRUTXBZK3NBU0tHdFo3ZysyN3hzUzhY?=
 =?utf-8?B?ZjI5ZCtSUFNldklFVnJCVEFwaFhacFlPUEFpaWN6SGdVMzlHdHM4ZHJQMnFt?=
 =?utf-8?B?NHc4NUFGVXBsMXNUSElaMmkwVVFTSWJwM1dMcGxPRkdENTlIcFRYcFNmUkc3?=
 =?utf-8?B?dFJTYUJqa2FETEN1TjQwbmZNb2FmaVFXNmNleHF2azM3TVI1NW5vZ0hlakI4?=
 =?utf-8?B?ZEdxUFBPQzM0bnlmb21rdDNYek40WXI5cXM2ZWtIMjBQTjVlZk52bWRpRkx2?=
 =?utf-8?B?YXFydnpGMjl4NThKcEdEV1lVSzRDeUJzT1lKK0d5TUNVSml3eW85cnRSaXNq?=
 =?utf-8?B?ZjZYMmNsem8zdzRJc21sVFI3NjJDQWU4cHZKUzd1dkhkYUNEUW9jNHVGdUlH?=
 =?utf-8?B?WitoSVRmSmx5K2VLV2l6WDErelR0aDZqVm85czBtMnhPaDliUmVrSHZ1TDBF?=
 =?utf-8?B?cWsxWGx5Y1d3M0V5UU50SExvU0NYQm5rRkRranY0ZlJGb0lld21OWGpTYUs0?=
 =?utf-8?B?K0dheSszTXNIM2dRUC9LR1l6NzcyRW5ScnMwQnRDRGlJOExiRHQzby9MVXBI?=
 =?utf-8?B?VHdEdTBjamgwbEZXekFIMVEralFIeUVpSTc2YzZtTUZXbTd0TC91ZFFnUHI0?=
 =?utf-8?B?bzQ2SGtXa2U3MWxkSEZtUndHOEpYWmRVdjVSK2JPWTE1Lyt2aS9VRUZ1cXds?=
 =?utf-8?B?dnJNS0xkUkZxRU5ibmhkS1hQd2dPVlk3bHFwOHdzdjdnUStXU3B6Zzg3Qjd6?=
 =?utf-8?B?aVdsV211eG9pd1hFcGdFUkxZaS9YVS94UzE4QlBDRGpzNFNhd0FwUWc5czVF?=
 =?utf-8?B?OER4VHRibFB4TjZqZUhYTHBwTXE1aXFvSDI3OGRhVDhWOWNha2d3Tm5JQzJC?=
 =?utf-8?B?emMwUmgrSHNBa2xoOUdnRXhqbUZLS0dtUHc3Sk9oOFgvT3l1MWNBOFlxb1JV?=
 =?utf-8?B?aUVhNUJMQWtsTmlDRGNQZFRqbGVuZXdJYnhaWnNjKzYwSEZ0ajFZcE5pNTlV?=
 =?utf-8?B?bVdZaThFaksyUWtFcjRPSkkxdFV4L25qTWRKZnNEQUJvcU9pZy9kcUFFNW1M?=
 =?utf-8?B?VXF3K1RjY2xSWUw2R3NnY1hiSGFxRWNUcEdDZ2JKdWdZZEtzazZtazN0bWZx?=
 =?utf-8?B?eENqeUtxOFRFdDhGZ1RrWnh0Wkoza3VKZkJhYnpGUndEYlA0WkZNcit2ck5G?=
 =?utf-8?B?QkFuTGl0Vm8zcmpWeEROR0Rwb0VLazkyMzRtUlFZcEx3QitoOE1haWdNVERY?=
 =?utf-8?B?elpXOFFncTZtRStHUFlDZERib01TT2tqMy9vcm9pODkwVFdiZEp5TG1tRWV0?=
 =?utf-8?B?ZnhWeTFJTlYvTjRyd2FscEJjTFAzRzlZTFNXZFZ1NWJpWmx4TzJiN3pnY3Jl?=
 =?utf-8?B?bTh4U2g4dWloN09sTDhKdWtUcjEzYjEybzRIZS8rd3p2K3Z5MWF4aStOSmJ0?=
 =?utf-8?B?QTNUOXJlTzhodURWZ1hhdVZ3cDFDY0pwS21aSlNueVNZb29QOG5oZENwbElX?=
 =?utf-8?B?aWs1QlpvSTVNVjZlUE9XTTYvdk4xMFpqWnI0QXYxYkF4SWpGZjlhQVNyR1Y3?=
 =?utf-8?B?R254UFVwSnlaeU0rY1hNKzZZbExrSXJEQTRlbU5lZmxrT1lLSHEvRVlvNnBB?=
 =?utf-8?B?b0JTcWFXYkt1UnpVSXMwdDhhSGR5dVp4YnltU003amw3TTRtNS9acENpY3Nj?=
 =?utf-8?B?OURybHVOVGgxZ3pkQWRrekthc2dGdXk5UlF5MHJlVjZQR01Ca2JDeEhoVWc0?=
 =?utf-8?B?bFFNcE42RzlMWUFTUG5FKytlVzJpcHZQT0FZM3J2RFh5NGQvYW9nVnZvb3V6?=
 =?utf-8?B?N1p5QnZzQWozTnZ3V2NGY1NBSE1Vb0s0UmdxMmRWZlBibG9iNWFRQkorelJ2?=
 =?utf-8?Q?938GQ9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nnp5Y1NaeUhqbEM0ZWdSMmJLZnpWT3NXRDdhSnYwZWhSbFRsbk8wL2xIZCtl?=
 =?utf-8?B?UVJ6aWJaV0tzUHpZS3JiZTNLa05PSzhWMTE5dC9rM1ZKV1dEc213TjFheGRu?=
 =?utf-8?B?M3c2bWcwUmw0ZC8xb1hWUElCb2Exa3pFYXBMTU9XVDV4Z0ppU3FBd1JFT2tW?=
 =?utf-8?B?OWM3M2drSVNFK1J1Y2N0SEhwTVovWjlnRmpFR2x6T0VOSFBkVGNCbEJubWt4?=
 =?utf-8?B?TkQxcXgzN3c5bFhjRkFqYytqQ1FTdFNHVzBOVnNDQ01aV1ppdXVTZGMrMlJ0?=
 =?utf-8?B?clZOZWxEdnJ6UjdFQ0crdGdPRThsT1dIdXB3dWhaQ0JSWHl4TTd2V2NJZUxY?=
 =?utf-8?B?eHdNeHFJMjQ0STZPVno2QzNpRjZFWkZma3NwUUd3enFEMVdDNTJvZ3NPSmRN?=
 =?utf-8?B?MHU1VFQ4WTZjVGI1L2EycUIwVHROditaTnJkRk9PdVJFcVYxTUJ6dVNJQkVL?=
 =?utf-8?B?ODcrQVFxVkZwdWZiTTZ0b2ZibTdKMVpHaG9CMkdjUXVmdEZOVGhHWWU2aE5r?=
 =?utf-8?B?WFp2bGh4dm1xN2hnWG5GTmxWRXRyN0hvZTNCMk5vei9jWHB6d1luUjFUcGZX?=
 =?utf-8?B?SFVUUDBhdVFHb2VzNDVyeUpjTEsrbExGWDl3Sm0zaGxSMklwWC9OelBxVXBG?=
 =?utf-8?B?V2c5WlNVQzFJcCtFRU5xZFR1YlVxbG5keGcwa1M4VmkvTC9TdFVPMVBCMHFZ?=
 =?utf-8?B?bExZU3cxY1NlY0ovdXJ5bk92NGFXQS9WN1hkcFNjWitKdGJPbjJCMEs1d3JI?=
 =?utf-8?B?Z1AydythWFdZRk1OeDZXTy93cUFPYWxKT0w0TlQyTURyYlYzOU9BZ0xjK3Bv?=
 =?utf-8?B?Q0NlZWIxaEExUFA1MmtRWFg3NVRsSFk3ZE1jRFpkV2NQWGVsQy95eTVCTWxu?=
 =?utf-8?B?T3N5WHVuT3BzQmNzNEtmRUVqSHJaQm1zYW1ROW1jVUVucG5RcjB0UkNubFlC?=
 =?utf-8?B?ZnRuNkZCdlc3S2NRelNxeFY3eSs3M0h3cTlUeVppbUdQQ0RnSTloR0hpdkRi?=
 =?utf-8?B?SVFCV0oyUUo1azVuME1lOUtHSjNKUkZFZ1Nvckw4SnZvUHJ5bDZvaGtqUFlU?=
 =?utf-8?B?ZmVRUlJzMXc1bzNJRkRXNUFKTGt4VEpDRUhIdGp2RCtsOVZuVDV1V3hzVDRp?=
 =?utf-8?B?YXQ1MG8zcnhoVFRpMlA4emIzOVRGTWZ6cDZNY3FZVS9HQlo5cmhydVB4aVov?=
 =?utf-8?B?enBxY0hDVUMvYXRFbU1OU2orMlpOS21IR1NMdWFHYW85YU5pR2JOTERpWVll?=
 =?utf-8?B?OGFoQWRSb3MwRmI3OVQ1NzBJcXg4WjJWTGNpa3JnUEhhMG81N3JuaEpuKy94?=
 =?utf-8?B?WG5NSlRlbGh0VWd0TXhUQmRvay9ua0h5YTVkVks4MzZrZDhRZTdoZVJaamd1?=
 =?utf-8?B?VmNrbVdqUjFQbzVIWnY4cmFDN1I5VGRFQ2c0QURHYlFkeng0d3hsTCtWRm5I?=
 =?utf-8?B?N1g1NEgyQnR5VUlkQ0lQeE5jWFFoaVNoeVU4LzBVc2ZQMkRqOFBmODVISjJo?=
 =?utf-8?B?bzQ0aDBQMURqWU9EWlZMUGdjekRxRVVvZUJCRGtpOElNVzNBMFVsOEN3R1Zo?=
 =?utf-8?B?VkJtZG5ZS3MydElBRjNZQWt1VFQ0Q0M2dWFDUjhqNHBZUXFkNXBDTFkxeGZR?=
 =?utf-8?B?R3NLNG5sdDBYQm0zaklkN0hYazNWcFplcmZWRmoxVnh2YmpPSGthMUVGK2M5?=
 =?utf-8?B?dFovQVJwVVloaFpJelNReWhTc0h1dDNKVngyQU1vdzh2ZFAzMDFhSmJCaGFa?=
 =?utf-8?B?aXc4UXRjZzdESFdTZG1wS0FkdWU4NkIxV0RSYnRzUU04MlpYSURacDRxeG1a?=
 =?utf-8?B?YjN5Y0ZnREQ3MTBja0l4eWNTa0J4YjY2WTJ0ODNIY0RQT1c3VTRtR1VGdkZu?=
 =?utf-8?B?Yjk3SXBIQmpCTkhucXhBcERYYlJLamY0SXh4bi9WZitLRVU3QlJkb1d0ZTlm?=
 =?utf-8?B?SnRjUzJaU1BTSDhVOUVDQnc1Q3hpYzBXVEMzbjB0Tm5EYXBzTlhWc2FGNzZQ?=
 =?utf-8?B?QWF1OE5MRVAvQWFINXdzaVFVd3d5UHRtcDQzdGlZM251TktyZFlhSkZualZG?=
 =?utf-8?B?b2EyZmlwb0ZreVkrV0I2Y1NQaFhyZFBuTHQ5ZFJRUHJnUlJ1d3lFb2FWYzFl?=
 =?utf-8?B?c1lvZldscnU4ZXNHeFZKRVozRE5WS0wzdnlhZk9jQmF3L3BXaGlLT1NERmZw?=
 =?utf-8?B?ek5hMVJkN1Y0SGpiT1R1dTBvWjFsWHJtaG9aZnp1b2dON1RVdXJtR2hGU3Nh?=
 =?utf-8?B?WXkxMEFVdGNOc1JSbEFvYXpFM0IzV0tWSkZCbkk3dUpiZlUxMUcxU1JVSVNO?=
 =?utf-8?B?Rk1oRHJSeGcwM0lLNDBtMWUyUzA3Wjk5VlU4YTlRKzhMdU01SytqTjhiWmtU?=
 =?utf-8?Q?7arXjFrnDyIFCE3I=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d9c280-e972-4b52-4ee3-08de53a1dd54
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 19:19:40.2682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdeVvyTuNZtSIHHdpenqSViEA49QgLSU9mUytuDZgM5MQ5OwvgAgXkAoFAQnsC5XxcUwJOy32JGf5Gj7REwqpMgj2aM3ZKlShYEBUTtrTPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8330
X-Rspamd-Queue-Id: B80701C0005
X-Stat-Signature: 3i1c94h6ji8ai7z6cfsbeji9wesbkxoz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768418383-877231
X-HE-Meta: U2FsdGVkX1+f2IrrMhDW8V6UTGmKCwLMUMuec7GB+tg8lY/GxCJ2n374tFrax0W2lBeg0njp/nb/929cVQLBYQS4nVLNPKR7y+dpn/Kam5/ET0rd9r0hHi/Fcx72mRxQS4k9OeV/TgyvquXYlBMigNPOOqfzLcETh+PiKsZIGDvXPEBxURyrT11c1j/gsC0YKseBVToSYQJVbpfvUiYIQtisGNaPD3bjlrDlKBrq+HWuZulhB4FSZZ5fnSifTvTeFyF47pmgvxtlAYf/0Vjj2ha2qeMknJytOvG01Hj0KGN+lKDUoVCiInd9tJS0r2IpAugv5C2fNLrNW2aQ/MrHj5/WwRxEUtBxOPmlv7x6dEBY1693OOrk4z2cJxkLL8fkHd2xwXa/B0cW6isbItVNQn1f/hdv5FBJyJMBZl36bvb0avbPZqVpsLkeRIKx82GMDfFL7ssf06TbtGkJbQlRTMBZyloPbLRvN9ZAsKy3YqyjOVH4urZAyYsJZfdpvV1Fh5vPJYQ3IcvCxOBKe6Jc1yzBbYiIdRjrVLL6uZg17K9jMTx2NH8bN1SuANkiGskUhE4KJJ6zAP1lLQQoeS3aztOz4Vr1o2fkYa0Zni6FtFm0jetqsyavMQiqUjymBCoguoky3JbPHAbJCdLtaJFL4ANLlC0CZZ7z0jsUw93OiYeCTsmrXIFL1utcKBd3L8fJFsYTH6xcrIB8/R2jmELL8uqZHmwMTdg08W5yNPEDCfR5PYdxPC7mJ+M6kqSfMq5xB1xBc2gpsjzXykvrFQ6Gg8Jm/lHGExkaiu4MTlTHNy+WamC8G+wesiEtf990nvI5tSMytWQXsA9hYaJpbES/ULgPcIpvXIvpuVz3eiTpfiaeqGirPSMJYGiUtCM4iZEPSo9JkRUvJMdQbWF8vfk9XnlpcoxbLMdwebOKrPi083FgwfxYmbCQIdfW3RLw2++V5ku9R0UGJ9gNzhiNCda
 9Ad2pNwP
 Ll+CXlROwFot7MpnKfnlHyKpvyqIew4lOx6ruKUi7GLxDWPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-14 11:41, Michal Hocko wrote:
> 
> One thing you should probably mention here is the memory consumption of
> the structure.
Good point.

The most important parts are the per-cpu counters and the tree items
which propagate the carry.

In the proposed implementation, the per-cpu counters are allocated
within per-cpu data structures, so they end up using:

   nr_possible_cpus * sizeof(unsigned long)

In addition, the tree items are appended at the end of the mm_struct.
The size of those items is defined by the per_nr_cpu_order_config
table "nr_items" field.

Each item is aligned on cacheline size (typically 64 bytes) to minimize
false sharing.

Here is the footprint for a few nr_cpus on a 64-bit arch:

nr_cpus     percpu counters (bytes)     nr_items       items size (bytes)     total (bytes)
   2                 16                     1                 64                    80
   4                 32                     3                192                   224
   8                 64                     7                448                   512
  64                 512                   21               1344                  1856
128                1024                   21               1344                  2368
256                2048                   37               2368                  4416
512                4096                   73               4672                  8768

There are of course various trade offs we can make here. We can:

* Increase the n-arity of the intermediate items to shrink the nr_items
   required for a given nr_cpus. This will increase contention of carry
   propagation across more cores.

* Remove cacheline alignment of intermediate tree items. This will
   shrink the memory needed for tree items, but will increase false
   sharing.

* Represent intermediate tree items on a byte rather than long.
   This further reduces the memory required for intermediate tree
   items, but further increases false sharing.

* Represent per-cpu counters on bytes rather than long. This makes
   the "sum" operation trickier, because it needs to iterate on the
   intermediate carry propagation nodes as well and synchronize with
   ongoing "tree add" operations. It further reduces memory use.

* Implement a custom strided allocator for intermediate items carry
   propagation bytes. This shares cachelines across different tree
   instances, keeping good locality. This ensures that all accesses
   from a given location in the machine topology touch the same
   cacheline for the various tree instances. This adds complexity,
   but provides compactness as well as minimal false-sharing.

Compared to this, the upstream percpu counters use a 32-bit integer per-cpu
(4 bytes), and accumulate within a 64-bit global value.

So yes, there is an extra memory footprint added by the current hpcc
implementation, but if it's an issue we have various options to consider
to reduce its footprint.

Is it OK if I add this discussion to the commit message, or should it
be also added into the high level design doc within
Documentation/core-api/percpu-counter-tree.rst ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

