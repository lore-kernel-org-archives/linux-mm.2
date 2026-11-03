Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67422606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DD66B05B2; Tue,  3 Nov 2026 10:49:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8626B05B3; Tue,  3 Nov 2026 10:49:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EC16B05B4; Tue,  3 Nov 2026 10:49:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9B06B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:49:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB9FFC0473
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:49:15 +0000 (UTC)
X-FDA: 85394241870.14.5FAC7F1
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021117.outbound.protection.outlook.com [52.101.100.117])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5F4510000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:49:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.100.117 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793720953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2XykKOaEX7XUj1gS14Gn+ztX57QDQUXLilHcM0crdY=;
	b=7ZHIxxJ+lKIyaR4Ejy5kL3ZapmGU3onvVY6+mlSzX1mYgJ7LQSAM0wAwKv05vzKMYMbRwg
	j3kHTREykMPT5LRtswQ5qRJrw/XsnmmJyVRHPmOFq24TXiicrsM0Eoein0N0XGRRj9xxod
	G31ZYroXGnmLM0a5IQsSt8MV3VjlLX0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793720953;
	b=XOYl9OiDTdzjl3TUEPixOAx8OmZHZhmYvIWiXUXbCKmEfMLpGB99E9Ec9cKe7UFBldTVxk
	YuJsuX+U1mlPFMHFZo7rokRJZ2XA7BQ0wG6KFdziA9CGHvs4lBmPcwFh6eHbpf1V1KgiFh
	9kzhKCG/aknNxoOvQLdE7UJlho6RdcQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.100.117 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndo/vIWw1x34Mc8lXtE6ITp+Z2onAABvLJ2E5jfKRp4Jj6hs5alPbDzVjtjpPiwlmuIntoMk8gjbG9wMgA0r6QR1d7tfw6bgQp6P0W8oh9Z35aF0uTKfuWUqGVUjzz4IjYUe9xFpSpnVD5Zu4SeyXH6mbBwbWyypRCZw4WTwDqhXRGAw8W+3QPE3quRvn4bLRpqx8h7x0WiXdyPQi28KYnN1u9jBCQig7CJE0AFVJ/kH2BGUNWmGLGaeXUWbtKIbDz0cDmfuVZi70lQ0a9dLZPbYBPoANf03rY6PY27mAdrYPbdAsFvJptuevm5aHElhOTv+Vo2VchhIIdXnqTtC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=G2XykKOaEX7XUj1gS14Gn+ztX57QDQUXLilHcM0crdY=;
 b=Yw2RrgCDYy55dUYGKVM1zjbUh2vkaBzIT7epvpMhRfcyuBXJHcxo2HrGHpg6/+ICgEWozKpZGDcSRgj5qZAKb5MS4uRNCA1s+iDDNcMUxxoPkOSeT65mgBhUCkgWN9AM6h4JQFZ+OsELZnwOE270Ridy8lU5ZSR0lKyF4M18eo5kfm2xEklsF61z+Ey9DPTDxQ18pLF1feLrmjfNhIkIgTNm6qpqPjWs4LSYmyre/hw8dYMAimRoUlZbIHQlgXU57rN5q9Y3Kehz7fAz5adL1fpE0+qLl2E26XQY2408CDF+nA1VZj1NXnd2pv4Y/1mNH2sz35D3Ixb+sPHAkPXTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LOAP123MB8863.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:49a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 15:49:08 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:49:08 +0000
Date: Tue, 3 Nov 2026 10:49:04 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: pmladek@suse.com, john.ogness@linutronix.de, senozhatsky@chromium.org, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, akpm@linux-foundation.org, 
	baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org, 
	anna-maria@linutronix.de, frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [RFC PATCH v2 4/5] printk, tracing: Support console flush
 suppression and tail pinning
Message-ID: <ow5u2gfpdarlp7b32p73j3rp42zbr5bvece5mteyir26arjq57@f7rklmb6wwk3>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-5-atomlin@atomlin.com>
 <20261103095512.7b8c2d3f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103095512.7b8c2d3f@gandalf.local.home>
X-ClientProxiedBy: BN9PR03CA0956.namprd03.prod.outlook.com
 (2603:10b6:408:108::31) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LOAP123MB8863:EE_
X-MS-Office365-Filtering-Correlation-Id: 181ca7cd-7f3c-475e-b7ab-08df39c1ff44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|4143699003|56012099006|261009223027099003|261022105027099003|261021135927099003|261102123227099003|261022075727099003|261021121427099003|261028144727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	7LYcTW10L6p70KlGrtPwtrGjWfFHYM0S4Jqc8UbcSguHFj2cW/3aR4Y+L8CxlkLKquXsGnEflzhWql+cNszvoK7/gFECE9M997IszXmPrw512VkyJFXDUP3IQCYEDgHeNlrTyz35QdYIeCQ8rmZDTOPMiAqc4mPW9bl5kssRBJRt1b1T3SQ6VeuY14gesNgaFUeGx8Ea7xBWfFCc5p05Ttr7mpwtJl1XY5UWzNwvlqR+fayy7Rj2b1eS2Y4eGaVBJI3lXeygm0l5HGAXjQEKgywS+/6fOQctnpJfdZoylCK54ECLcpqdV86BtdMKI/TBGlVB1NF5lWQZXn60ClOwKJJfOEwH5pYYTYqgPClKTlZwepUtfrQXRkQs3qHjcChkf9FsnqZsuKVdheEfaoR9bvDt/iELyteJBAWTqEBPIA2CWy9mqBZSxIhWQLbd1709WyCf+kRbldGqmI/Jzt/6INhVwyTvKwLU7YLOjMNa2tpXB6m7mHtTZmQDtl4bgf8mMAz5ZG0faYQpWN+VyU5/NnCbNnzj2U7KDdUMUmJd43NZzJpXAVXX9hGaqYPVsSfBjDBIy0+4IUrwMPwXucUwvNG9peMtTGZ3UYyV84G7673i4oxj9KlpiH64XkSXtJtIhkOdoOPBYFoAky1DHpKlE40jD7qxg+75P2v/sBWCNI8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(4143699003)(56012099006)(261009223027099003)(261022105027099003)(261021135927099003)(261102123227099003)(261022075727099003)(261021121427099003)(261028144727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVNRQk1MSEtVcWY1MENiMldpRXdFZENQd29TQnBRQUYra0pGbTJPbTNCNEI0?=
 =?utf-8?B?NTM0Si8xWGFzMFVkbWE4L0RQRjBvdVpTNlBBQ0E4eDVJdHpXYkplQXYwQmRu?=
 =?utf-8?B?OWtzVndNZWFVK3ZmTUw3M215bGNTUktzLzg1c1l2MUtNMnJTd1Bsa1RZTHRW?=
 =?utf-8?B?ZHdCdzQ5UjRBOXZQQVBJLzgyNGpMTi85T2dsclpCVU91Slc4QS9ZU0M5U0VS?=
 =?utf-8?B?SkdQVFRyRyttaFp3c01jRjZyNTB1elZKc3RPMkhpNzNKWVMvRitGa3orWUUv?=
 =?utf-8?B?VlpCZ0hKZXNGaTZ6VkRDczY5Qm5lRmxocTYvR1FtZFU4KzhId3V5cWZQdW5n?=
 =?utf-8?B?Y3BMUUFUMzdOdnRXd1cybUFaVFU2bkNVL0dENVl5eXRuQmV0QkpQNWVEQURF?=
 =?utf-8?B?WGxwTVFaU3lJOC9TTFpsZzRqOXYrandhSFJUbDRpdkxYK0dSam1NaDFLVStv?=
 =?utf-8?B?My8wRTA2VWVPWjA5QTZEbVdFTFJwY2ZuUk9CNytwM3EvWnBZeTVyS0VRUnlv?=
 =?utf-8?B?WnM1ZjVPNTlPTDRMb3NwcUxxaDJyckpCMktoM0dNbHRodU9LNVgyQ085Y0JE?=
 =?utf-8?B?NnFydldHRHNXNXVPdGlob0cwN0FQZHNpTXdoeFlrSDR0VFlJajliVWZVbThX?=
 =?utf-8?B?SG1ucGZJMnUxNy8xVkE4U29qSnFtWmgyVXVrT1UvVXRoY2h5TVlUd3BCUHR1?=
 =?utf-8?B?a0J4aHBNdXRZRWFLS1FqUlNmTldXRU15QlJ1YXZ2ZDVBdzJnWEl2MHhadWdL?=
 =?utf-8?B?TjhnYzFDWE1GSjFMZmlIaXBNV1lORjFiQkpDMktTS21VcE1LcGZWUTZvSHU5?=
 =?utf-8?B?YXJCVUlnZWQ4andFNWFmNGtJV2V1R1lTY2QzQjZTU2tTWUFTTno5LzVUY01X?=
 =?utf-8?B?ZUpmNTVNYTRVYzV2U1hNKzRIVndVcHg4WjQxOWhkcDhjakw5UFpRbHZseXBC?=
 =?utf-8?B?UUJ6Uy83Z1hiVUNpUXY2QVhHQmlQYWdDUndzODg3Tzh2MG1jelkrVEh6SlBu?=
 =?utf-8?B?Q0Qydnd6bVhUcEcvN1M5bEJhSnNjVFNpa0FCSGlTTVFTeGw0b252ZlpmUFFC?=
 =?utf-8?B?ZHh3NnYvbFRqOWx2Y210bUgyNkNYa1UwUVM1SC9Pclh5WEdybjJhcTg5Y2tW?=
 =?utf-8?B?UzVCa1JqL2hMMHR3VmxQOUQxOCtDRzFIMHY2K2R6SzRzc0RvQWtqNmpyUHpK?=
 =?utf-8?B?K3NGMkc3UnVOM0ltVGJBd2tBK0h1WEtPUmljWFQrckJXbEtJVnZNSFFhYWRU?=
 =?utf-8?B?NTFDeVo0eFpWSzJDOW5iZklkYUVSUUc4NW5RenNOenpSUHdFRWRjUUNQdFlR?=
 =?utf-8?B?eWZ3bUI5em1JeEhNQTJ3cEhLMGZNZ2IxZlRyT2pkQUp0aWV6UUNCMm5sNzZB?=
 =?utf-8?B?RHVjZXJ5b2hEcVV3aUw0STZyVld4cVZFNlIzcWRvZFZuNjdqa2dDaW4rWlE4?=
 =?utf-8?B?K2ZmMjcwdzVCYUFzQ051WEJic1hEZllYQ3NNZU1QRnhnRWZ5OURCQ1Zxdlox?=
 =?utf-8?B?Y1EvczRSb2pmQW45cXR4emZwMUFpOVI1cEtzSW1UcGpMNExZcTk3QVZYTVdj?=
 =?utf-8?B?N1VRR3R4OXZBbTUvQ2RETERrWm5hc3NmMGhIdTFnSnl6aW82VjRGQzJLUmxr?=
 =?utf-8?B?bXlhTEZwU3ZMTVYxaXVncGV4Z085ZVJCeXpXODBpZXVFbk1GZ05LWjVWOEdn?=
 =?utf-8?B?VU9kZVJpNDR5VHZFeUFlZyttRUZNTkQrclhQa2dnTlROTEg3bzI5MFlTRGNI?=
 =?utf-8?B?R3ZVSGFXc0JodC9nbUJEWUc1ck01Q1VFaWdJbDN2WDNTOVdrWFZ6Y3FYQTcw?=
 =?utf-8?B?eTFZeDFzbEVyR0FpN0ZxQzl0ZTJ0Q2xmLy9hMGNLdU5IbGpML0dtTTlnS0RB?=
 =?utf-8?B?WjhxUXIwNlVhZ01yYnZZODcycjVUNmFMR2hadVQvQUNTSnhZNkMxQTM0Vmg2?=
 =?utf-8?B?RmR5c05EQTJCTFBvb2dJbWp2NkI2WVpyMDJMVE9wOFhIa09rVUhLTnc3T1JH?=
 =?utf-8?B?dE5tYzJaUGR5ZEIvT3pCSDJML0NhcExjS2pvcC8xZFhvTmJOTVlFUFliQmJT?=
 =?utf-8?B?L0Jzd01uMG1jR2Q3TGtDdzBwQThSSUwwU3JPK2o5eUtvZXNMcEhBN01sRHZl?=
 =?utf-8?B?Y2dlWEhMWUdhRmVSNXNRNHNBUDh6SjUvZWpxV0hlMHNYZGxvSE5zdEJJMFFs?=
 =?utf-8?B?U2xxRnZzSE9HenlaVHBjVDc1ZjhEcVJUMmhkQUUxUG8remFIQ2xVd1VIQjdl?=
 =?utf-8?B?akRBbGhyQzhMNDdBSGltbnpCeFV6ZjVLWmp1MmVkRWh4Ri82RFZRR3pCd0FX?=
 =?utf-8?B?YlMwR3I3Y1hFQ2FXQXQ2RXJKQ2h2NHhvRElQTm5SVHhDaTN2YUJLZz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181ca7cd-7f3c-475e-b7ab-08df39c1ff44
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:49:08.6471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogMQhGivZRbxD489Prv79NSdFg3UPIb7XZgc3pNmWvH55y80y8Vd5KUHhh+R4jaYPJCicHMF8RX9DMNWtWGsSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOAP123MB8863
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zm49gkbdhkgr7phojujhxkr7ust3hnfq
X-Rspamd-Queue-Id: D5F4510000C
X-Rspam-User: 
X-HE-Tag: 1793720952-363432
X-HE-Meta: U2FsdGVkX18ybLG8WNcXbMov3IC7+tNCe0jjWeNAws6QPRJgaiUJST/CrsKx3vJUqmSaYbHtZm1v68gwLozvBwahQSwae2txhg9Dkel6+XBn3nrsz4XrEXnEm2Av/X5lvWVi0gHcmCzbnrb9ohXJ7zkgTLP1JirbdmufIqtBNZy0MAR8spN+yGZHj/jgKxdFnvY3I7vrvmlLoo0q5uNvaqyRGC3eky5XHygYZmaGb+dYSWmiukmUjvikYsOLxUM1htRTnRobqCbDDUdl2Iihvr1iLzmETT0QlpcUa1Ch4//kvgdLI4DRd0tha9We0CCpmI0qF/tXAQnKZApGGa8/AoULkOucGwoHMiP9ZBv6FIfJkwD/KFr8I6yNrOjd4tFVM3s8xv5WZcAFEP9YLylMcrbmEmrAqK/hgy5nLu7cNBxFSkHF7nRxCaMuEzg3K1E4/DlZsBbd3bK5k2tGQaQwHanbnXuRPAJSnT7Ba73AfOs4c65hA0B5QXyQDOtXG70REMc/rZ3TAfDleU8GIIbiCyrIw6dzo1KJZRgWULEMNl/xlAWBGPhE0GBbdloZa5HKugFd54RDtJet8DTQFWIxHtwjMXdGv26vEEbMogob/sK34nBX+uAKW0cgTevlUtHWJl1ehhtTtebl34tEv9ph8o0GCVhkOTqhuPN+nX1YAfVpRD6mYgvZlMLubdPjlDvIa+a5nzBornB5uw3u9NsxMmh/cVaZjeOoQGUFVJuxJfhqwIi+zfxQakmdBt6XIgCNC8khxn1lI0+NJ3AShJqwzpkClDvzRCpFxhBAyCHh9gpIV6pge/am3s/l7VE/5nKKajPs/9NR2RJVy9Fhnl9GNb4uhqNH2TIXUIwBST28J2h0JtDB6CWGPRNHqdWKnysZvPEMK/2t8XMKJ2o7b1+ZMi32F06ygOefUffIv3PmvH7pa7ZfkssNTdwz6fQpwSsV79yipUYMgDM10GFu8hw
 JoA8bqce
 koNwoshddEAUUFPCnQ/e/8RF4VHR9SunzZd41TzlIz5DtZ7316NRmljav91ydWovN8Ga2WT2dpESV7nhNqBeqGJWGNva7l1JJwrwe7oDzFf49mX+IG4JR9VGsqmZyMhZOBvEZnT0rsfeVNqRYQMxLIQax/pN7p3oM0dW1F4Gp8s9sA6u1xBye6Gwo3NyZ0E57BrlDySQYoudX0SOX+JmvjmyCNiUchxCONC7Rp+xyavzq+WfmlaAhla92YaYYhXRFEYlJ5fOkSquUcO+kAZO+GbMPEKozyTiDcTOnB08J4wuDSRBRyNkFaVhznA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 09:55:12AM -0500, Steven Rostedt wrote:
> On Mon,  2 Nov 2026 21:44:52 -0500
> Aaron Tomlin <atomlin@atomlin.com> wrote:
> 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index e8c4efa8107b..35a56f04e9b3 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -9519,6 +9519,9 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
> >  	else
> >  		iter.cpu_file = RING_BUFFER_ALL_CPUS;
> >  
> > +	if (printk_is_tail_full())
> > +		goto out_enable;
> > +
> >  	if (tr == &global_trace)
> >  		printk(KERN_TRACE "Dumping ftrace buffer:\n");
> >  	else
> > @@ -9537,10 +9540,13 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
> >  	 * and then release the locks again.
> >  	 */
> >  
> > -	while (!trace_empty(&iter)) {
> > +	while (!trace_empty(&iter) && !printk_is_tail_full()) {
> 
> Wait? Is this to prevent overwriting the printk ring buffer? If so, this
> is wrong here!

Oops!

> In your change log, you mention not losing the initial oops or registers.
> But if someone is using ftrace_dump_on_oops, that's not what they are
> after. They want to know what happened that lead to the crash. That output
> is at the *end* of the trace.
> 
> By stopping the output of the ftrace buffer early, you just lost the
> information you are looking for.

Agreed. Because ftrace_dump_one() iterates from oldest to newest, stopping
once the pinned printk ring buffer fills up retains only the oldest trace
entries and discards the end of the trace leading up to the crash.

If a user explicitly enables ftrace via panic_sys_info=ftrace alongside
crash_kexec_in_memory_sys_info, freezing the printk ring buffer tail
defeats the purpose of dumping the trace buffer for the exact reason you
described.

I will drop the kernel/trace/trace.c changes altogether and skip
printk_freeze_tail(true) in panic_in_memory_sys_info() when SYS_INFO_FTRACE
is requested. That keeps console flush suppression active so the dump still
completes at RAM speed prior to kexec, while allowing the printk ring
buffer to wrap so the end of the trace is preserved.

Thank you,
-- 
Aaron Tomlin

