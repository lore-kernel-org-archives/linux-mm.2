Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E47C606A329
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 20:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PWQxl4Vq
Received: by kanga.kvack.org (Postfix)
	id 141BA6B05B4; Sun,  1 Nov 2026 15:08:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2C96B05B5; Sun,  1 Nov 2026 15:08:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7006B05B6; Sun,  1 Nov 2026 15:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBD736B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 15:08:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B88F40B13
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:08:06 +0000 (UTC)
X-FDA: 85387636572.19.55865ED
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49F8040006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 20:08:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PWQxl4Vq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793563683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHE2XQAXzUh2NAaDZ3bmkVtT2edw3j2E/yaBCpKhDMQ=;
	b=uMk50U5fa/VA3Hm2gLIuVaIiUOcj5npuPyR9XWt/MQoJ5MlsiWOjepTEPGsUghThiwyAUS
	g/OFdOQU0A46CKcFhFtCNi/f4XD6nHmxc5o6bDVDO0Q3urz+3XuIYiTwW9bdugFDzze/K0
	aMRKL93DcnEWStsWrYsrBgFAzZxMBxg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PWQxl4Vq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793563683;
	b=LF5Wmy1SWe2nQEWnOwWvpB4YDysd0bLq67MQXLC/z7/Xle9qSQ1UEDvd8e3LlUgIbc6cBv
	E0gI1WGj66QbZ1ZIjZy8cvEZf8dZrczmibvd1KTVNK+VixLRxBnl5J9XSM657cMTTH7uXa
	0CpYF58+taGZhQYiA8q7mXam+9bv5dI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTLv6einZebrYA9uYscVdpgfdxjjvjP74ac/hpjScIqmgJeUxBcLrYS5IXBYBt+yEsk69GITDUFWVLdT9md8kRZeASCWZnlSgvwIKTJ6Wpg2BdGwDtqPowyTlCt2Q97QpNMwRGsmNAXZBJ9UqUgc6dfKfXLosOFU8iKUtN1jh65bsCE3hC1JNDXqWAywtuyRFniFFKUR0YBBlJkM53fkjmoBEZ8+BksSJ3iPhclzAo3DALBg6DAELE22PDZL7wXp8j4b+Gm26MioX+1srncb11S0fQQY7Dy5uM0VN0bQHl5PrP7i3MMLTSp4Evrc927kyqHPgDAxllQatwSmSmpRvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHE2XQAXzUh2NAaDZ3bmkVtT2edw3j2E/yaBCpKhDMQ=;
 b=aCghTDk1E4u6nYlnmD5isNaEZqgF/CkYt1MIyP+gDUt3skR0fEBX1jV+AQVwA9BkS++KAlEI2MPQt42piNm5/rQkLAfsD7yWl3M7Kj5FNx2yxTVbSYwmQBilYCQIaxAc8sX9E1lCqDLA8K27yOvfWDZ/mKZv7Sl/Kjf7yhOItyLQErfhRz6wjfrhAIobWrbMSeIog74cPKAqiOb0/bNTiNm+S3KANXekiJXFy9eeP10Zqr7KdnF/CL+g9SDHdbT4AXt6drArq9qWSiOoH2QfVUFsEDfc63kkrqoChGHfTs6M37SvDiGdUuFepyXUdJRvFDvS99W8IyL07jw6ELsd/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHE2XQAXzUh2NAaDZ3bmkVtT2edw3j2E/yaBCpKhDMQ=;
 b=PWQxl4VqToq8HZBO3a0FLix+2F0Jwl7EzUwfJjBHvDwAqCqQTYFRaya+YGel3q8WjE8ZSkO81ere9a+l1piuNx+244xCkVoUVekjvVvVDoOOcfV2Z7qUFSiurU9hHqIvTRZiG4Dh/E3dqa+sBqV8U+txY0BIGRfi5lsOkVQgb8ffU3mwBydkwWdN09NCAr3wUd7Ygu6a9t6MN2qXSkP+ymN7wsV9uIt3xfsEIiImZjvfbt/EtJU8hKA1151cK3LG8l5Za4QvsTueUKheaUHzMIb91hDNix+vOjrWjfempPyewU5fNQpNnDXmuTRiLDqr93vVk1A97vA6Yrmy9q74SA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Sun, 1 Nov
 2026 20:07:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Sun, 1 Nov 2026
 20:07:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Nov 2026 15:07:55 -0500
Message-Id: <DMK59DO8M3AP.3OTG2YR62D9WO@nvidia.com>
Subject: Re: [PATCH v5 02/12] mm/page_alloc: keep the pagesets of an empty
 zone
Cc: <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <baohua@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <baoquan.he@linux.dev>,
 <baolin.wang@linux.alibaba.com>, <rientjes@google.com>,
 <rostedt@goodmis.org>, <mhiramat@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <ying.huang@linux.alibaba.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
 <nathan@kernel.org>, <ndesaulniers@google.com>, <morbo@google.com>,
 <justinstitt@google.com>, <Bessel.Wang@huawei.com>, <jiang.liu@huawei.com>,
 <mgorman@techsingularity.net>, <anshuman.khandual@arm.com>, "Josef Bacik"
 <josef@toxicpanda.com>, <stable@vger.kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-3-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-3-gourry@gourry.net>
X-ClientProxiedBy: YQBPR01CA0159.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9a8cf7-6e56-48a5-66b0-08df3853d2c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|56012099006|4143699003|5023799004|11063799006|261009223027099003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261021123027099003|261021121427099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BHjbccvyC94Ik8lVLRb+Ds+cmc+tFvEyjVxmxG6J5tBbKYW45iDfndCuZii1zPruwzETkf0X4qEa/RXq3wIdrRzjvU1T4lWNA4lqxEjYgKnTQKeRFwshfQ07Fove9pPpdY7uLln9tMREIfxjyvLKuMsyJIff4qMnZNrJvyh25qtz3CsvL6W0qMbKiD/HAMs1CaCbRAD2QXNCrekGB2bemIeDRHTg7svm13SnasA+iIZ+kQZP+U2iN2Q9ZwXmfTtnnPRqL8c5NgViu7QXS6RcKtdteUsR+VsjgXoqLvg9dCM28JNCu/9wYtFrdCRqETLHSKOiZlfdZeuJzGJVFMqGLLNTv+3XFJEQhQTeCV5WYMZOCgi3ApWHBcMiDP5dudFiYAWe63trfCZNRSlOeIH1AG+F0po7JZMvQtfFnn7AKz1s2RxAo3u6N7jt4dq0Y5PI4lmu/dOFMMwDHT1CqRp15VyogxTdW305qZVSncy6ZiRFOywStRmIo+becXvvqMutLco5oXcGm4CdWxO7aKC7SIExv5dn79rmSy4vuXiK7IuQARr+CrpDJg7xMRJK4NuazZkyf3EyxPmLy3uyKacepOJM60iUfD0jWL5SYTMW9FCX72qqNZa5xssWsrAYKZFpKX0lQ7JYH+IARuUL6mYnrSXx6rOl5Eo2SofuPU+tjVE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004)(11063799006)(261009223027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDJRT0NGcDR1ay9EZ01tNnZNMGVCT3JZZEV2YnVXNGRhVlN5Rmd5VkFpc2xv?=
 =?utf-8?B?ekNuUFNQYS9Wb1E5Z0VpNzVMSDYwR0huengybG5kM3JmWHhuQlk2WnRRcTUy?=
 =?utf-8?B?ME9TVXRhVitLOC9FTEd4T0ZodlE5MzR1WHc2bFN4TFN3Z2cwT2VXWHJ4WXRB?=
 =?utf-8?B?NHNSeUc1QlhRK3paa2lRTVFJOUN5Z2xwM2ZjK2lqRER5SDR2N2VabGpWRU15?=
 =?utf-8?B?cXB2Wlo2M2Y0bjE0Sno3VVlTRkMvdnBUYXpIeUFaald2UDM3WDlmYWRMRktR?=
 =?utf-8?B?eE8xZi93ZHZuZVVKL2dEVFFnS2NMdm12RlYyUVlmWTkvSEkyYm5JcERTcUNt?=
 =?utf-8?B?QlRXNUVvdTNGSEdtWjlodUVFNmtPUlo5QThuMlZuK0duV2U4ODFnQ3NEc1hH?=
 =?utf-8?B?dGJyMTI3dlRTZ1hxTXlEUEFTb095eTMreFE4ZUpMUVFQRlkyWmFtZmJsWE5M?=
 =?utf-8?B?NG9xR0RieHVOTzcvYmJya011b283L1dGMCtQUGVDMnhuaER2VjQzVWZoQ0hC?=
 =?utf-8?B?WnRyRXFIVzVSTTE0dG1ZQ1ViVElGTUpWcUlabU5zdXZjcUdTN3lBMnlzT3lk?=
 =?utf-8?B?eFVjaG9FeDk4aXFvcTY1MUM0dmpmOU9Dd3ZtdXBSS1AwcXVPRWt6Qng5Y1B0?=
 =?utf-8?B?bmlka3pITzNjdE11NndSVHJxZ2swVVVBSlZhOTRpTEpFMmVMZnlQNVJ4cjdL?=
 =?utf-8?B?cE9UWjJHeE0xOHZ1L1lERXlnQ0JmNUwwdS9JVnA0dTNIU1pOV2F3UmJwN1VQ?=
 =?utf-8?B?bHAzTTFZM3c1dTl0RWxtTUxjc2lZWkJZaXh2QTRWN08xMFlKdkNmTko2WVZF?=
 =?utf-8?B?K2hHREZOcG02aHNyTTErcyt3VzdYOHFsdUdxamlkK2tyekJrZXJOU1dKWWZm?=
 =?utf-8?B?aDE1c2F6SEZrYUx5VUZ2NnBsN3gxSzZ1RlJRQjQrcHZTWjQ4MDh2Zk5oaEg2?=
 =?utf-8?B?dTZheVFQWXdycEMzM0Q4ZnpIWkdJSWlVOXFjTmhoK1ZLaGxhSGYreGxsRnlM?=
 =?utf-8?B?NnpOamZ6S3NzMEgvaEhyWnpBelNvbEpTVjg0dDZqaTRpcFpLeURyRnVaemZY?=
 =?utf-8?B?eEllZ2dwdUpaN3JiYkExQjhIcnZkc21DYWpidkJoQmZnMnZiQXhLNnRIak1H?=
 =?utf-8?B?WllUUjNSMjNvTUJ0dVAvQTRBMUF4TW9kNUpyK0ZtcmtFR1ZMRGw1S1JuVUxH?=
 =?utf-8?B?eVJhb2F4RVptaklHZ2E5UkRrL01ZR0RxWUMrUGNZUWFiSFc3YWE3MUZUNFE4?=
 =?utf-8?B?Qm1xR1FyNC9hYk82VkZhUG93ZlUwVlgyeWJzdXFQNXMySWRrQnR1MWltckQ4?=
 =?utf-8?B?U0pjRWdWWDE2c2dnbFRHWStDZ1NDaENYeGJnZlpIa01oSSs0Tno1ak1iVFE0?=
 =?utf-8?B?VG5DTHdCMXl2WEJQd21TMFN1S0VlM2JUOVFjRGFUSnBvaWpwNnlGWEVLUnhD?=
 =?utf-8?B?WU1aOTd2TDVSdjdNb2hUV3VHYkIzMTN3cUdlZFp2N3Q0M3JFa01sbHNtRkt3?=
 =?utf-8?B?WmNsVjd4SjFuNGg4Myt0YVlEZ1V5dURYWWVoUXlDNkxaNGk1MTZJZzBoL3lM?=
 =?utf-8?B?ZVY0WmJWckFYRGttVHdIUDdoK0VmdVB5d09vQVpyeGZlTEYxcGFacEJIVXBq?=
 =?utf-8?B?RHprdW1wekxnRUJSL3FhMDdaSjlDSmZtcmVkaStMWmZpNkYvUW1zYngycEtS?=
 =?utf-8?B?a2hFMURnR1ZEU2Z3TjAvZDdhL3FaUi9WckMvcStZdTViT1FvY0tJeXQwQzRD?=
 =?utf-8?B?VTdhWDlIc09MR0JUUlpJYmE1OXJXUXFLQ2x0YW1yeUdYY01aemtMRGdKWjlE?=
 =?utf-8?B?SWRrTzRjZUZJcWZkMmNMMTVzOWZSVDNlcm4rRGU2VkErazltdFBEcC9MVU5i?=
 =?utf-8?B?OWpTYXVvS3dDeXlZT3hqdjAvUWZNUGJMNS82cWYyZ21CZE9oVFIvS2JZbGNS?=
 =?utf-8?B?cEtmT3ZSUjhsK3F2dDc2ZnEyRlhua2lVTkFTUzNubTBwNXZ5RnRBbzh1OWE4?=
 =?utf-8?B?VWtrWWdzT0JSejRRN3JsanlKWGlnWXJXemZ5aUNZME1aQXQrUjJGVkhQdlZ1?=
 =?utf-8?B?UDBmblFaMEh3MnIxUlF3dU1DZnRTQWlzb2xQbnNnZnNLQ0ozM3lnTjRsWnVJ?=
 =?utf-8?B?VEN6YTV3blZqcFNUbUNQSGg4OGYzNW5aUVpIaTRSM2ljS1c5WnpmL1lvZHNC?=
 =?utf-8?B?b3dFZ3AzVE1VWUZpSjR5N3hualpFQjlKL0FPUjN0am40bE9HRGEwVTBpUWpT?=
 =?utf-8?B?QUxYcWtNVzJ1S3RvcnI4V2xXUzh2UG14OHlzdThjbGNqcnhsWU51aStIUnpE?=
 =?utf-8?Q?nMq+h01pwM3ZZC5ebn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9a8cf7-6e56-48a5-66b0-08df3853d2c5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2026 20:07:58.0240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQePEbi0nCxb0uziX4WWNV6m5J/xhkM9SwxkXvGi8tPWqbEFEqg4f6aljWddYhxe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49F8040006
X-Stat-Signature: ywf5pzdsugi4uhwwkrna4n6g48t6hzxx
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793563683-269407
X-HE-Meta: U2FsdGVkX1+fBLkOdV/td7RBle6UeBqkDkhmb8KPiA+2xNfB5t5HqLSa1fVS0NNfscz6pdMzzDbEyPP3owdUKoPcr+0Z1jSTAFTFmqY6ZHm9u5M+/yiltbZ6If2i4HJJIu0lsRShEfLUJsjDYPHXnPlwEkRsxDAuq3BMsXZ/0ivsd+zPD9YgG110wKWN+6+9s26WPn6gAwXftJaIuBXov26Y9NyK1fDXX0n7p7kaK40Q/UJdkgZU0uEnmBygbdIF6/ha2Lq5LZiLDsENCrJhQmrYxdmgLcR2sEM6exRAqBp/z2Sbf15K6ot5bHziTY7H0O2cCwAAhkUvFUlUJq8nVHfuW5VhXB8PVPWo+/y07Chou0XCLwkfp3EIQSUf0O4hWyt6PubBz2BgfG9F0ulgRCh1nlL4QWTzrYFjCf5Pus/wRbiY3NCalfm23KcvKLHpSH2ORGnx8q9q2sYkD0ji8Ng3XYTkiVgueF3WiN5JRbtj9w5HHiJdR9f6uqQUsMGy7tkMTbJOfQrCux3BGBogmOYOB1U7S1uWR2EZyxDGfC1LroJt/SwvJgKM9PwAX+qH6e1bBbe9FgDI77vbV2SkwbadWNO26Ro4zyX8fR9A2oAir1l4kj2fz6gKqBUE/szkwHPuRBDQustxkJ9GKEgHkaSDocu1gKuJO1hj1fzcEIkqZnHFzfTnnFD1XPrtir+PloRScNU47DwfkuqSlzCXqIbcKpzG18L3TmXOFxLm/2+It7te0D2REZld5BBeAkrEXFCFZ5Zk3xOm2kWqi7k2lt9Y3HJfsrYAYGZEX9H6iVinbCcE/ewXgZF8zywFsfOXHjDlyypCxPFWyBM1hoJb+G6W3OTxhnobVi9mo7daSc89r7MwuuQDsr//20UPzgBAlCSEECw7gSnnkv0HsEI31IPPPigv+VySaO3g3gKux9uPZG0nhnNWuF1KmxyE9K3DCZJDFEaCuROkEi7zUk9
 NBnXZGU4
 FyVvw1aDQd90lb+bC9D1Qc7H2T6Ifu+EAtPBdIqaFjKjEJEXhkzXS8OFx/qSI9AtDpYODmQlYHInP++cV2WcCDFPTogjjORhOFtK2qNQ5GfwrLa4+3nTD2c0CMAnD28i+KPkz2Xtt4ZliCnNzP8eB+zt0noO5rEnvboT6CV+AyHfs21YNGMTkwb9DpuK39lPIAoxJ2VwCxm+jYB9MzcEI3cQfKCmCmUoWfJihgFaxYfOJNz5ziHKDfGReSMdsNqHTKSU94q77mC5vCdb0jykdW8hS7R5MWHeBhtFvbBSuxBNCJVGPn66NfGUptrGhc8rum88KJIv9JRU9mTfHvLeYa4nR8pNpbfJIxPOnpD9tyIuvClpFHLufoq/G/BT9tFlYEi0N2/FLnJcnrFEnzlwxS7BDMpsOC/hw7w9rIiCGN0oXceAfmgkAlA36spZLCE1V5wewnW8oIyMn4G49tO6Rzl043+PfwOk8uMfiDCzhfrWsbnDkNKiRU4+f7ky/t8r9Yd0Nkzh+PMWQ1Ubjaf+d/1fO6iWFjMBp8N+m/4nGC+d2aWctSvVPTvJdc3MkldtQMPtskWoFNguycoR2y+B6lV8S5zgJUCRBk3nYXS2OgEjpDnlhH67a58DjZrv+CQOQQ778IDDzgTvnQTZWxqGE5n/Q1ePXi5FFJuIKMw1cpk5A6IFw9iqW8IlS8q6WrIOiwt5l0huVM3tgSyhCdSk8MAlz4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>
> When the last memory of a zone goes offline, zone_pcp_reset() frees
> zone->per_cpu_pageset and zone->per_cpu_zonestats. Nothing waits for thos=
e
> who found the zone populated and still use the two pointers. They take
> neither the memory hotplug lock nor any other lock which offline_pages()
> holds, and some of them can sleep:
>
>   CPU0 vmstat_update()                CPU1 offline_pages()
>   refresh_cpu_vm_stats()
>     for_each_populated_zone(zone)
>       pcp =3D zone->per_cpu_pageset
>       cond_resched()
>                                       adjust_present_page_count()
>                                       zone_pcp_reset(zone)
>                                         free_percpu(zone->per_cpu_pageset=
)
>       decay_pcp_high(zone, pcp)
>       __this_cpu_write(pcp->expire, 0)
>
> The same goes for drain_all_pages(NULL), which takes pcp->lock, for
> zone_pcp_update(), show_free_areas() and the readers and writers of the
> zonestats. If the per-cpu memory has got a new owner in the meantime, it
> is corrupted.
>
> The pagesets are only freed because setup_zone_pageset() would otherwise
> leak them when the zone gets memory again. Keep them instead and let
> setup_zone_pageset() and zone_pcp_init() use them again, like it is done
> with pgdat->per_cpu_nodestats. Their lists are empty, and their limits
> have been calculated for a zone without memory by the
> init_per_zone_wmark_min() of offline_pages(), which is what
> setup_zone_pageset() would come up with as well.
>
> Fixes: 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes =
empty")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)

LGTM. Just a nit below:

Reviewed-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f1048168c90c..1850a41f24f7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6308,6 +6308,10 @@ void __meminit setup_zone_pageset(struct zone *zon=
e)
>  {
>  	int cpu;
> =20
> +	/* The zone has been populated before, see zone_pcp_reset(). */
> +	if (zone->per_cpu_pageset !=3D &boot_pageset)
> +		return;
> +
>  	/* Size may be 0 on !SMP && !NUMA */
>  	if (sizeof(struct per_cpu_zonestat) > 0)
>  		zone->per_cpu_zonestats =3D alloc_percpu(struct per_cpu_zonestat);
> @@ -6400,6 +6404,10 @@ void __init setup_per_cpu_pageset(void)
> =20
>  __meminit void zone_pcp_init(struct zone *zone)
>  {
> +	/* A node which is added again, see zone_pcp_reset(). */

it might be better to explain zone->per_cpu_pageset can only be NULL at
boot time and it needs an initialization.

> +	if (zone->per_cpu_pageset && zone->per_cpu_pageset !=3D &boot_pageset)
> +		return;
> +
>  	/*
>  	 * per cpu subsystem is not up at this point. The following code
>  	 * relies on the ability of the linker to provide the


--=20
Best Regards,
Yan, Zi


