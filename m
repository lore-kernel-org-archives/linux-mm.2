Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E67D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F646B0088; Sun, 11 Jan 2026 14:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D096B0089; Sun, 11 Jan 2026 14:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF456B008A; Sun, 11 Jan 2026 14:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC3E66B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:26:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65FB25DA4C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:26:04 +0000 (UTC)
X-FDA: 84320663448.07.A1147F4
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020096.outbound.protection.outlook.com [52.101.189.96])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6CB59140008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:26:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=r9Ssqwzm;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.96 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768159561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW+dB+XyS2eeQdorBL35bjJ/ysxwN2Qaeduw9cxeNI4=;
	b=kCR9ovZr4Wx2g4GjVGtnUlbmOkRfcCcqQMVfAV8ehiJ61j1nLWyUgl8ooA+2mmls3qcxKT
	ucfJrPCj02H10RXKWGKNGLlxvEVMzgjVoLHssBIobwg5QL1l+kUv7f1S5Vnkdui54SwafB
	lrgrtekn+6DM1yyZ/ERS3Mv2sqXwi1M=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=r9Ssqwzm;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.96 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768159561; a=rsa-sha256;
	cv=pass;
	b=Qm3LN2mXY8VbM2cTZmDo+dM/NG4/tsfPj4O5nud7MSscOPd44wo+RdeKbo77ZuPNFBI/iX
	SwWvedj3DimQAmVpq4ZX8NlU4ZIvQ0y2ZsuEFmvrmsmlELKcDaPJjU3WKhSOcmQbR5P/8L
	+qQDLMV1eNKJBB81JNfNc6NE9FOdTrM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jHXnPtaWZ+mq/QaerkW/bYvtyBRVviio1Sg+Z+vvWuLeBT9XBMC1PLEDDucZqN/Vc9FNqXud6EilMKWiXlfauLIhDY2e5FQHO8R3VBZHbEiVITosXFBTNTc8QIlXWmzGgZUmDs5Nt59AfHL1qwwTkXdGYvg7DepIdDiEVZvx8R8i+2fEpxW7X4m1x5unaX404MbgkTlj8vQ90tjDr5YhbDhgCvWOZVjS5FB+CMkxED0/Us5B9aG2iR9OvWtuQFBkyNUMNFJOqdU1pua/ORz6sc5oBOu2NceG3sJ+SKxGtAYx9LZ0HX7O9G4rW2Su0phzKmKNxr4pJMJS4k4zj1h9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uW+dB+XyS2eeQdorBL35bjJ/ysxwN2Qaeduw9cxeNI4=;
 b=GJwzKk+1cPKAZNpDwPG1iOcthp9TuAc+LGn02zS2je6rotVAUaonGsXJYWgJ/aeK2TnlLgNFZbyeyk3MS1T9bupzyo0Wpe8biBY10vVeDsCFVYCirx1IGBq8+kSX1aWIjUhsQfXPf4/VkeVThxHAlRBxP0EFvwbZsJhygwzKtPLtO4igqa/E24qTNTs0JSGGgTbYjuvYTi+KEhagiiK4UYNPxql5L5CUm1QuvoDPyhu379oDWwoiWgFi0g0AjlCamDZheJbeQyp5ZuxEop+o4zVX/f8IQYBGfrEAO1Lgq0McaAkKyayLi61DgB2uF6WtBvf9zK8CAH1VkKAUBga5Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uW+dB+XyS2eeQdorBL35bjJ/ysxwN2Qaeduw9cxeNI4=;
 b=r9SsqwzmD5JDbnqhZE1Wqn374Ror0Md1xemi6GQywb3OU6wcR20w+GvplRZNhN4lzsJtC7EysATBH8kKz0fW1ObaIBekJY6vEPd1U9bR3duZNBoagN+hOcwn2CjETPVnYhK4sRZuWJISSeygf0hd0zgQljP6PImdeJiMw0eenwT/3b2DmGy0JNqy0ibkwqcoeWrNvUY2JS/RDp+1knyO00bk1JU7sjENnhrHB1xKXtCIkOh01hKHNEr4Epyd9DS8Zpl3OOhdT5CHYTpoER2mQIC9UEnZkTrhSzETSGBWhA6q51DbkzJCaZyUjjHa1w6l197zIq2tlpkTtxWtY52i6Q==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQXPR01MB6557.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 19:25:57 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 19:25:56 +0000
Message-ID: <24a78f8a-202f-4d25-8967-b15a665b89e0@efficios.com>
Date: Sun, 11 Jan 2026 14:25:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 1/3] lib: Introduce hierarchical per-cpu counters
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
References: <20260111150249.1222944-2-mathieu.desnoyers@efficios.com>
 <202601120245.v2Trbgck-lkp@intel.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <202601120245.v2Trbgck-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0312.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::17) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQXPR01MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: a94a90e7-0b55-4bf2-c756-08de51473e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L01Db1FaZzltVldWbHBEY2VRYjRPT25RTTZBZVVBZ3o2Q3piejdUWGVjSlM4?=
 =?utf-8?B?U2d4SFVaSEk1RmtlSUxHNk5nTHlTRHR4RHJiOElaM05GUUYvdmU3N0N4QUVk?=
 =?utf-8?B?ZS92RXAza0dyWlVrTWwxNkhhREdkcjhHcnNzRVdhOUVHTXJldmZUZGV2cGxo?=
 =?utf-8?B?NzVPZ05OZnMwc1Q3b1pNem1yclhwQTBieXVvSWptTnI2bXE5TTFKdW5YaHdC?=
 =?utf-8?B?bGtiMHoweWp3S0p6dXdSYjRQRnBncEZWeGk0SCtpNzcyeWNxL0JQaEkraEZF?=
 =?utf-8?B?N255SVdnQTFjNHlIalhrZU9wRnJKYjhXTmQ5RXBudThyR3o2OTZpZEpxYmR0?=
 =?utf-8?B?YjluT0dxMEZhQzFDWEN5Q05sVjZMUlpXTmZJTFQzcXdGT3lRYlZEL3Qva3l6?=
 =?utf-8?B?SlU4dis5REM1ZUZQVUVMNXE1UlhYNHJDbmxkWFlqQVNETExlK1BOZ2F0TTgx?=
 =?utf-8?B?OHBLZ0cxQ1c2NHVMRlJCV0VISjB1dlFHQU1MbW9QTjB6Z0tYOGZRSFJNRUFB?=
 =?utf-8?B?Yk5aUlI1OWh6dFdVRXRwRmlLdzl4VU9KUmVsWWJQR0UvaHBXaWF6R09UcXRL?=
 =?utf-8?B?Qk82bDczZHdMR2VpZjRrY3U1aVFrNnZoSHFzaVJ2czJJQVpsQ3lLTjg4RlJF?=
 =?utf-8?B?Zkp6UkkzYW8yNThLRnlVMWhPVDJMMXZvb3F3b0pva3hjQ3NuZWg4RCt1azZy?=
 =?utf-8?B?MmxsVTNOck5HRmF5azZsdFRCR3dCcE15QlBIK3cyTFlaWHFLcVN1SFVIMU9p?=
 =?utf-8?B?TlFaTEhEYVJUU1VpYlpqM2RENWVsUXlZVWttYWh3V3ZjSjdVVEJOV1VkUzYx?=
 =?utf-8?B?aWNpaGpWNnN6OFhmZ3ZaU0NmZE03VXJkUVUxUnpBZXIydnFUcURoaXptdWNw?=
 =?utf-8?B?b2MvR0dwaURmVmxyU2dQZEhYQytOa0I2d00xM3c1RCtDYnNodUVoejJDdG5Y?=
 =?utf-8?B?OUZxUGlNQ2JxaUE2RHVkRVNrdG1Fb3lRQ2h6ZnJ1MEtjbTlNY2pKL29NcHJK?=
 =?utf-8?B?dEYyUVJLRkg0ekFuS1hycFBwREtYL3Q4Z0xkZDlxWklFeHllSTk1eHFFUTli?=
 =?utf-8?B?VnU1LzFTcndNUXcxanNONHA5bm1hWm5wV210ZmsyT3ltTjR5UDR4a3IzaXR1?=
 =?utf-8?B?MGtpRmNFbDJyS092eWg2Nm5OMWZFNDU0WDZmVWd4c3ltZUZlcnhab1VJUTg1?=
 =?utf-8?B?UmFVbHZjNjZMS3doQXpLOEdNUU56bk9jbjFzMGxGNDlhZCtTU2ZPbFg2Y2tD?=
 =?utf-8?B?SHJSNFBTVk1kUUVmSVF2Sm1wTGR4bVJqeGxJTmY5b3U2M0JtMThGOElQWUg5?=
 =?utf-8?B?YngxZ0dVM3VCQXlueFN6TENFejVrNGlDRkpmMktIZGw4L2FFT2o4OThOVGFO?=
 =?utf-8?B?ZjBYTmxJQVpZMVJJY3RpK2JVVWR3cVUyOWN2STBEOVEyOFpRMnFOY3NGbm5I?=
 =?utf-8?B?eitjK0dRTHFLM296NjUzenBqbXQrUzc1Z25kS09ockpzQjNoTnlWUGhEV0x4?=
 =?utf-8?B?cXAxdmZIOXBwdnU2RU9Ub0krb01NdE44cktJbzI4OXZCWkhlQjNSeGdrYkhT?=
 =?utf-8?B?dnFCbzBCcUFqTCtBcEd1MjRyamlnaGV2L2xYZmN3alJhdDYvTFR2Yjh4eVZU?=
 =?utf-8?B?TzF1SjllemVIUXVyYzhGRU5PMDk4akhzOVpnVi90WFRnOFhuc1JwYWQ2U09H?=
 =?utf-8?B?bXJKVDA0RXZ0WHFyd2dZaDBvRCtGUnY2T1lsYjA3TGFLQkU2bm0vSTFsQlZE?=
 =?utf-8?B?UkxvamFneDhoSEdTZHhKcE1BWlBYUnFlWGhybmlESkVNK3NPZENYdTducTdB?=
 =?utf-8?B?S1dMdmJpTXhDZlBFQjUzdGw5c2VXT3c1QVZlYjVYQmR2dHF2UElvaDdBbWYr?=
 =?utf-8?B?L1grcnpITnREVEdNTFd0YnFpa0NjUDRvNUFZQTRyUFJJRXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUhCVmpBcE12Y0FuMVRwWG9BN1JITW9rT3V1ZmVxZC9ZdE5qRkVIaHF1VlJv?=
 =?utf-8?B?MlRDV3cxbGJveVhJUGpIMU5Ra0s0MWNsQ3hsQS85MWdpSnE5ZWVlR2J2NGpP?=
 =?utf-8?B?Kysrb3hKZDUwbGkzVUJobTJCNWoweHUzeU9jRTJxTHUrSVRaUFNXZW9iR2Jx?=
 =?utf-8?B?VlJibFp0ak5TcmsxNytWRXlQbjVYZk5nY24vZnpOZ0VVNWR3UDNTOEVrbWJh?=
 =?utf-8?B?VUFYcnE4QVJSYW1VRnVhWjNYTXNxMlAzbzQ1N05LRjhKeHdxYUN3OGNjT1NW?=
 =?utf-8?B?TEFONDlML25mTHZ5akxsbTRYRldCMkhEKzNkYVJaT2ZLTFd2NlB6Z09qVEpy?=
 =?utf-8?B?TlVzTzFEOWdmZE51eU5YZDNVUmZIK2RtSnlVeWp2MFQ3L2hNS0JnaEcrV29X?=
 =?utf-8?B?cENjaW9qZFhHUnBZUndMWWYzUFJSd2YxbzdETXBmamd5R09OdDluWjBicGxE?=
 =?utf-8?B?Z1N1Mm8rSFFkZS9nOXhPOFNNc25vQklpRXhoUEUySWlvWnR5b2tlVzZIR2Qz?=
 =?utf-8?B?aTZqKzdESC9YaXNUMllrTnAxanFGYU1HcHpKZ3lNcUV5VzBKWGRYY3FjUFEx?=
 =?utf-8?B?NTlvTVZvZ3N2VGRPNFRDK3F1aXRuVHY3anRJR2RWa05zSC9RQmZjSmZ4NlRi?=
 =?utf-8?B?K2VLSSs5WkNFb25hWk45S3B5QXBmM25PSE00U2tocWRFVlVFQkEzWVBJM3lH?=
 =?utf-8?B?c3NZRFM2M3d0anVhbGViWkJVa3ZHWStQMHhsTWJ4MUpQa0l3QW8zMmtLdDZO?=
 =?utf-8?B?WEdLSDVPWEtPWjl4dXVOT0xQNlVwS0QwYVpsNUFyUEVXTzBFRlZ5WHZDMG9s?=
 =?utf-8?B?Q01LSk5DbTh0R0R2TE1rRDM4eWtjYThaQVRYK1A2SFlRaTlnS3huLzc0RVdW?=
 =?utf-8?B?R3R4Sy9PN1hDVUFGQ1l2MEVIbEovVkliUEFOVzJTWTI1MGlEVFAycnRXeEhm?=
 =?utf-8?B?SVpEMHMrUk1sdDIxeFZvay9iT0Z2bTIwQjU1bTc2SVJNSXpzY0F0R1kxbDF5?=
 =?utf-8?B?UE1aeEhCaVlUTGVnT1dUL1hnaEJZQWZIbWZGZDg3R21wMytNMWczcVViSkxU?=
 =?utf-8?B?bkNnQTFYZEVQelRybUZVRGFkNnJHZkIzNXFsc2NvSno5Um5uT090OHFScXRE?=
 =?utf-8?B?ejhKSVVMSGlJK0dkMnBBdjYzSUdVbTd5bTdrWUZROGhqU003Z2c3STVrS082?=
 =?utf-8?B?MnZ6RG9DVFBQdTZYMU40YzR1MmY3QmpESDY1akcyYVRqTm5mM3E2RUg0QjZa?=
 =?utf-8?B?ZndITHFRcGZjcnRCeE5IbGo5Qmpqd3hteGIrLzlsb1BxWnlYRU96d2RpNWlt?=
 =?utf-8?B?a2ltdlI3K2UvY0dtOVJzSWJxZXFxdU9JMjFUMXNqTHI0dGQrSm9yYVdGVFZt?=
 =?utf-8?B?UGp6ekt4ZlQ3M2dLcTBxa3Z6elZCUEFIM0JuWnZVeitldG1JZG9yL3NFREZX?=
 =?utf-8?B?T2tGTzdqaW9HQVZocHZyUUZCYkdYSHVzNXN1YUlEcDEyMHdWbGEyNWZCQUQw?=
 =?utf-8?B?bWsxeFR2eC9nUTBBRk9LTUxtY1MvT21NY2lBMFcvOVRGNjBPNDRnWFBqSEti?=
 =?utf-8?B?VzFwMElMS2dZSE5OT1R4ZEVPaEdDRjB0VzZteGx1dmUrYlVBLy9Ca2ZtWUtF?=
 =?utf-8?B?eENIbVJDRXB0Yy9xSnIvZTlDZFZHaGpmS2dURGE5WTMrRWhVMGZDUWtnWEQ4?=
 =?utf-8?B?aW9YdlI0TlB2akZ6dnFZOHlGci9TdUNZWWxIZnAxSWlwNFRXK09JVHRUYkF3?=
 =?utf-8?B?WGFCeG1yZUhQUEJDb2ZZT1JoeXpURHZncmVPSzREWndpVlU2bFE3NlhDcU1k?=
 =?utf-8?B?TUlDWWR0QUZ6UmhnODFXRzhMUkJpejB6M2ZYaDBVN0lTa0tTVlhMMjlKZW1w?=
 =?utf-8?B?R1RQcmVjY21abFdiTDNXMUw3ci9HREZvR3Racm9CL0NZV09RLzc5U0FuNVFJ?=
 =?utf-8?B?SEM2ME8yb08vQ1Vwa0MzR1RrUllMM2RtRk9UWEJFd0tIdjJaQklVSTVlSURD?=
 =?utf-8?B?RmV6MG51MjI5QVJEcnpYUnhQakJqOXhmM0szVTRRMVd3ZXN3L3l1Nk50c2ZR?=
 =?utf-8?B?ZG01ak9vVHM4UncvZ1dJbFNQOHdjbGM1ME10cis4SGsxYnlPUGs5ZTV1dWg0?=
 =?utf-8?B?R1BSQldmcU5weEI0bmQ0L0dIT0RONW11YzYwampQNkRvN01KZ0oxY1RYYm1v?=
 =?utf-8?B?eUlRUW54azNqQXYyS1htYWg2VlNYOU41K09SRUZLeTMxU0poN0xUTDJTM3pC?=
 =?utf-8?B?cGVLTytHL0ROSkk2WjRSSkV0bXhScG03ejV3QjNReWwwYVZnTGc5a0p6ZzBx?=
 =?utf-8?B?aWV5M09SaXRTMG5DSlgrWUxsVndtZXZaSFpQbi9idkZHeGMyRExUeUhRbG5t?=
 =?utf-8?Q?zrp1ygdty8ihjxg6S1AJj0oPBKZ5yeDj0b5Ca+afXkep5?=
X-MS-Exchange-AntiSpam-MessageData-1: n5g1zr1fDzFUDAQqkpDFhPsLymPYnGBMoBg=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a94a90e7-0b55-4bf2-c756-08de51473e77
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2026 19:25:56.7280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwVJ0UtLrD8Cibfl/qiUypo7sszwOcLLZZVEX1KUlfhUmwgts/jc5SLFFMvxYtCUK7vPWS2vW9joDlBWhwr6CvCLU2AqqreBoWzNQ8wtidE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6557
X-Stat-Signature: phdkfbeq81kcmhm9m93exfengwd5sw4x
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CB59140008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768159561-471288
X-HE-Meta: U2FsdGVkX1/cnybFu2Q/9jcm8Es2pTK+NvYMoQ06OqvRuN6PAdDKf5yFjvoRdvTkHl1xCZ8pJY0PjXL8BVFyt0mrwOmamaSZv563X+iHWfYNvUmDWmz+7AnhlTU/YrF/sYdWTOaxLPCpzaR6UtKCzSrLppqyt++spICTQIg+Cj/rD8+GOgGCJf7HGG0zO9XU/5uZ+CP1cwjjPd8Bos40MO2k5ijWZpByKh1R5ch9LlsSLcWkved2TcUT8nqepBjaU61elqFPEXLHncJVvD34g47Eb3qrbTO8SnavvNvyFQpU5oFowEAnbiXg0cNdhTD9haDRpmhOIFzrQTjVYbPF9wuP2ujbdl9L3+A2fA2dh+CEDCEjfkLUoNlPYbgxYBzmP77kxP+xn9+5XaVBeSMa8aldwG9B1fHZ3lTU23u4pPOQOQQSN714ylB+RZOxVmXdHZotHCk0QvbvjrJQw/LhscNwxXDDjUfybCkbxTxtXRXaFR9/3TeBgQTgXB9hKKgSJ71wjehu6u23Uh5Q2C71TY16xE3rHJ8ajHR/5Kob3Eh64VPIVdxjG43mZ1crfgDePjs/aGRytz11eTOFAxo/iWLb0hlClV5OVi14ui3r4WM5X+z9IOT+LSW6FD+fR8PdYuev5cxM36j7RSJfYaqRgzwbGZFYqnWLqekV1HuMbFg7RfLkK8GahL7QMqhKJdkNlxvbVsqLSbDZx3Yt4r3nSfNkgJkLHxF8MdEOdpuSbBjXjNHThC7OyDefVIQq4f3IIGxKZ9iBG0GAAbq+I8Sb8GOSJfNhPRFC1gC1RN3GgWai1d5w0iKoynw1aR8/mBhXD1oUWV6C82zeVPR7f46VSsFNkoBqpyvLMO5w/s9lp2ZmaCnPcl8PqolR7epIDEF9d8BRdR8IaA0AQmGK0KBOQs2tf3gZqbTXPIjLfoYePxNTqmCefFaqMx283q/JYR5TEnQ9WVNS0UkOOvH66RE
 m5o6cA6R
 vNIgawiy4wgnyhEyI/zlfH21XsMrf2TcZcw1BWwfmUiV1Jm9OAGf6iTsxVZppJyj8USTPtRA+EGVa3r1K1H+TJzX6Zy575f2hnpF5cBT0iPk42OMI50cmS3GFsr4wPXpYQQ5E2a8DEq+9m1E/jGK+LM0u+mZOP5k7atySBUcllZ4nNCPXy4bDS2XtFUm73N5UwXHTlgVf8+Jp1cbRWXBA0rCnmp7w12iMFEVcTX6c1ysSvE8NGBkTCutQifitX0188J9MOS0wqTkBhZAteVXSE21riRPAD51Oou09t12GsUjoEtjChrn4f2l42h7xMzgLlJzXISRcK9nzK6/Rw/eiWuW/OBqQ3axxw+2tPqqXLgRZUChD4jjeJt4RT9A/CkPUsQ+okfHtt+9n9GCid4MfP4MFhOXrUGEaIMVzLvUIpJOg8nK6W5R6XvGJ6KJSJshGh4Ab6siSVo3M1IVSzE9JgaMmgM0nmOB4msAgzV6oV66s4dspW6oOXmYsFndVVhg1hcvrqs62HgQcW/ck+5zLVACqN1afAWXCV1xQ+uchbptRhIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-11 13:36, kernel test robot wrote:
> Hi Mathieu,
> 
> kernel test robot noticed the following build errors:
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from init/main.c:107:
>>> include/linux/percpu_counter_tree.h:230:13: error: incompatible pointer types passing 'atomic_long_t *' (aka 'atomic64_t *') to parameter of type 'atomic_t *' [-Werror,-Wincompatible-pointer-types]
>       230 |         atomic_set(&counter->count, v);
>           |                    ^~~~~~~~~~~~~~~
>     include/linux/atomic/atomic-instrumented.h:65:22: note: passing argument to parameter 'v' here
>        65 | atomic_set(atomic_t *v, int i)
>           |                    

Will fix and send a v13.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

