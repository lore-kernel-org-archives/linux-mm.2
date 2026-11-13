Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F1F606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=Tw/oKwI5
Received: by kanga.kvack.org (Postfix)
	id 267336B05C2; Fri, 13 Nov 2026 09:20:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EC86B05C3; Fri, 13 Nov 2026 09:20:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106D56B05C4; Fri, 13 Nov 2026 09:20:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCC576B05C2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:20:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C59E40243
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:20:29 +0000 (UTC)
X-FDA: 85430306178.13.AAB3C6F
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021077.outbound.protection.outlook.com [40.107.192.77])
	by imf15.hostedemail.com (Postfix) with ESMTP id 740E2A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:20:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b="Tw/oKwI5";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf15.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlj1VHIvMIhokJ0S/I4jje3LcJk4c5K8IdFpClvui20=;
	b=xQxTtT5VPrGWZCHiN0j2aUHo3BSNHDwFd3jG7zHUO8Vpus9SoOa554MbOdGSfUJDXz3/sB
	/p5jlYQZObC8ViwoBTWfXypuZeb9OEH0yFnmU2w30dPUQ7/6M2T/F/oD2eE3Sd2n3MQCG2
	ArYvreE3f2yohhDhnUiiZla+Fku1cZ4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794579626;
	b=YOSXatNrhDUX3OH2If5f9O6myuEefqz6WVAkc4E/MqgpDBzNmZGL82I0yJzthrQm2wienT
	vHz0+TmaFlhtcr/vfsvlzLlrwYoQb4Eiw73w1r3YFEroURjI1iRgghJe0zd1iTBkc8N2hH
	CEbHQiN9gzRNqgYUPNDBcs++OiCyGH0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b="Tw/oKwI5";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf15.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.77 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dtFpp92fO0MPlg68DZOLLVUVkyFZxlC/b9k4tXZ2of2dLdJWzGpy6gkjaj/n4z/DbeEChJJOSLTrCioIv2WQMb5ShDUVq2sy5GvmfKEm82e8j3lMkIzkqva02AzQ0ALeg1jU8TH09JLITJCALUSw8gdOaBasuwhtHGozsy10w7v5OF2rr8n7TYOsoAXYhxkJcKTyk9Ky1hiFFFTXpA3OG7euYrZp8P3kkMxx1KIVLMq3Nx5KTzqMvVjoD6lKFKWMaz1ojeVlnb46kljwsnfnmRN72M2Fi9gRf4EQBv3Ll7q2oq0lgYOMrysTwnK1NUkcDG4Rg3Aw0x7GofnLAmCjzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlj1VHIvMIhokJ0S/I4jje3LcJk4c5K8IdFpClvui20=;
 b=s4bGv3kGgq9N4dcdoPLA1ITMe75O+fO5TYv1evsnfs4Ue1aOccDtslquxH9EBVCEESsJK8spTMbp6dUT/5ID2Q7cBxidXqOJmN9uaf5Icip0vWPME+kcgniprINmLwf41Mtb2OIjpmdqfo3wzY9e69z6opijeuPSIbp5ZKeMWf+Xv4Zzo7ZMZuciUM1wRj+m56+M7jTpa2z6ed/gptuThoXRIqC3aB1N2Yixs4YQJ7RIgUUHJ4qVB3bO2Ohd96vjr1QRF1fCVrqCDpLdT129OgyNpjksY4SB23yPheuH6aE20avPONn6lWX+9chHIbKRQE+KdkuivALC0Dz9fxIZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlj1VHIvMIhokJ0S/I4jje3LcJk4c5K8IdFpClvui20=;
 b=Tw/oKwI55y8oR/Zsca5PF1TniY1Gwt4q/gxMCYrCkwQVw6GJf5OJpxcFY7TFqoZM+BXoYOh/yoA2i67CzhtpRaR/yX8rpQS9CN995GjUecYSEMdnt1Wp0a7h+QPI/1nTgfNF4VwCED8405nU4jht29vPTLSHW11vnH9WHhQovjx/Zc4rcMX/qJcWcEUcG6UWDyrVE58SFi07k/7kjPjAikPbyLreWARL389wbon3GUzLzZY0AxBk95Buf64wPxhg7WsngGKbHAjWbApbnsaV9yVA2zJu5BKmkGZ4SailtZsD3+UfxkygYjj+Vz39LArVnZ/vBTXN+3gX155Zfw9YzQ==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB912907.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:20:23 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.008; Fri, 13 Nov 2026
 14:20:23 +0000
Message-ID: <f45a858d-61c4-41c0-883f-c2465bbf3983@efficios.com>
Date: Fri, 13 Nov 2026 09:20:20 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v25 07/14] mm: keep the RSS counters of
 single-threaded processes exact
To: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 linux-trace-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
 Andrea Parri <parri.andrea@gmail.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Hugh Dickins <hughd@google.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
 <20261111203626.95838-8-mathieu.desnoyers@efficios.com>
 <sashiko-outbox-211802@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <sashiko-outbox-211802@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0088.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::27) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT5PR01MB912907:EE_
X-MS-Office365-Filtering-Correlation-Id: a9d4e602-2d63-4b27-8ec1-08df4191411e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|261028144727099003|261026121527099003|261102123227099003|261026140227099003|261022075727099003|261021121427099003|56012099006|4143699003|261022105027099003|10067099003|22082099003|261009223027099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7wYBMrPDI8qbX2VtjdPM5Hv38JW0clz0l6qMI5DQW7YY6oLYzBRsdPYC0ir7G2dvYjWWblVRT9eHgDaZwQTFspeUrlFkXuUsfIM1NDvqYzTmHE0ae1MkDkGQkyH+Mi1OBVqfg1ZIiIXyXlYqagGbeZLafAHjeeBiADyPHTgjtm/2Rmbduun5WCKKVDEDAk4E+6VA5sGYaUZXcJqpEx5FQ+a9ig2HokkZmLRac+GQAd5yo/5Lqx8Ezho0iuSvYly9dfJrmGN+9TWPdLlnyEdAU4+dA7ZqoUVSMHGV1p42Qbls9WackOI1ZBYxENyLFWa0BXYNM2rCtPsymQYO+ujNbiCn5ErU/Bk36drmtCrG3sh89OlXq8/pAOxnmUYAZQXUXCiYD41qJWuOeNOZM1kaYd2mOAm4MrHWAn+rAb2dE9qhQsyXr7XcVDyZTiTxjQuNQW5HmkGQzPUgPaRRHZc2qzHT+xpC8vjb4dESuDqY8bLBQFHDbgoK8/kVxfNGh7RUzM6IGPFMYEWvgDI54X3ZIQwI+g/TOqaGpkv/3AAcgcJLnkIBkkB9hwgf0ZndGVOeUDm+1gXi0RpNyK7untPhZhX/A/x2hThgKNxmVsU39dk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(261028144727099003)(261026121527099003)(261102123227099003)(261026140227099003)(261022075727099003)(261021121427099003)(56012099006)(4143699003)(261022105027099003)(10067099003)(22082099003)(261009223027099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VytnQVlJejdGdGRORjVQZlRkcHp6YjZkQ3orcG1TQ0VBWE93TytWdGp2S3Y1?=
 =?utf-8?B?L3Y5anpPQldjNmZ2VE9vcHVJZFhXcGE4cklXSHVGejk0TlFvN3Nhd240dFRL?=
 =?utf-8?B?UUhoTDBrM2FrV1RBVFVkOFhkcEREOEZxV0NKcGpCM3hucUNVemZnM0RQMWRW?=
 =?utf-8?B?V1ByZGVpeXdSQ1FDbHc2ZGs2cHJiQ0VSMkppazdlbko3bFRFam5NVEJqL280?=
 =?utf-8?B?ekk3MzVjNVR1WkVHUUJSWm10TFhmL0hiWTcyOEJiTmZNbWE0OXNBc2FhNFZP?=
 =?utf-8?B?R2RINEVwQlE5Z2ExV0VMUm5oY0R5bG04bmFqZkFKMmJCUmhBa25YdGRYdlpH?=
 =?utf-8?B?cE82dXFpSkhpUXFzSGNRRnJVUTh6VGorYkwrRTZkQlFkYXV4S0k5WG5jeDgw?=
 =?utf-8?B?cmRVR3ZQREtJRDBoVnl1UVJQRUwvaGpvTmFFeUZmc2Z3KytHcTVSZjJBWGVr?=
 =?utf-8?B?Tkk1eW02Tzd6dDNIZVhUMk9PNWpHRDNBQmhHajlvYTY0UFUxNkt4RnFDUm1a?=
 =?utf-8?B?UmV1cTVqSDlDQStsWUROMjF2ellWSlRhV01QTGN6L2trOURQaElmTmtsaGNX?=
 =?utf-8?B?VmhtZ0hqNGphcGFGd1k1dnZLUE1VdnFEWEtoM3Z5Y1Yzd1FvZWNsdDN3VjA5?=
 =?utf-8?B?Q0NCT09ZWE1HRTBqVFl3OGdSKzNSSnZkVWxOY1FZRnRJWDJ5SzRZeTV2V3VC?=
 =?utf-8?B?TVpCSGxCbFRxVkV5Qm0yWmxHeWpUazloekxDQm9rd0NBN2UzcjVPY1YwVE84?=
 =?utf-8?B?dy9LeDlXMXJrNit6RTJFcUc5OStvdURWbkFwY3BOQ29uTzZRT3NWNFZicXlr?=
 =?utf-8?B?dnc0RXdyQ05KcExpeEFQcDl1dmx6ZGxOYXNyZ3VRV1ZvWHZiZ0t2ZWNrQnJB?=
 =?utf-8?B?ajhjRk5xRGxHdnFVUjNWNmRQYTB2Z3BKd1JwWElnL2JLRU5JaFBZRGRZM1N0?=
 =?utf-8?B?cUtiWDhsS2h3YXNhT3BWN1Y5TkpFU2dJR3MyQUo0WlNzN1A2N2lobEMveHpD?=
 =?utf-8?B?QktUSmNqVkVNd0VYczJFZXhYc3d4M0Y4d0JPYnBFTzc5cEpVcUMySm0xSHBq?=
 =?utf-8?B?ZndnRWNSMUxiSXRCSHZqWEdISTZMK3hQbFUvbEpkaGhRdVQ5Q0hIb2xnVC9m?=
 =?utf-8?B?Q2k0MXEzZDdzV0pCTHFFM0dkay96NXY5bE8waXQzNTZON0wycHJsSDBadSs4?=
 =?utf-8?B?dTZFR0lTMlpuTzBwNXRyUzR0ZUFSTlFzT3MvS2hqQnRzbnljK2ZaZk5KZElS?=
 =?utf-8?B?WlhCZktKeGVOUkdXYXkxMG9zQ0VqdlNYZ0Jrb0pTY0VEV09pTVQ2R3VKbXdK?=
 =?utf-8?B?WFcrd0VuOFhNT0hWRndSNm44dmllTzk2NXpRN3dvaWoydFZsWHBGOVdUd1pX?=
 =?utf-8?B?RVdTSlplYjhGRUc5eHhNN0p3Q0pDNmRoYWllWjFwdlZUeHZsamhCbnR4VVNU?=
 =?utf-8?B?Q2crTVcvMkx0TEtFZHFrbzVVVVlXZnlBb2tvc2JTZ0FHR3A5ZFg5cEJJeW11?=
 =?utf-8?B?ZmtyKy9Kc09ZNmF1eU1ydTlUYldVMXZ5dlpTQkR0UUtqeFBNSDBTTENBbG5D?=
 =?utf-8?B?ODlKUEdtK1VpQ2dPUjlaTmhBemFCRE4vVHZ0R2xiNEhCUUlDVEQ4eFVtZFJY?=
 =?utf-8?B?NE41aU1VTkhGRkR3MEJIVlZCMlN0cTE3bjBFZjd0NlNzTzRCRFNOSGswM3Az?=
 =?utf-8?B?VHBjZWoyVVpibGdwOVI2cU1ZSTFjTENpSk56ZnpsZ2UwdlRUZll0RU5iYWtL?=
 =?utf-8?B?NGxUOVA5YUQ3SkxyMWdHcXNvaFNsSmZUMld4VXFWNVdZRHJpek1tc1RVaERR?=
 =?utf-8?B?WUQ2aURtMERjVUVzV3dUZUtlMldoVXE2eGticGtoSWVvcWQzZFBVOXEvTFhN?=
 =?utf-8?B?OHRzV3UyZTBlcCtCZE5mTHo2dGxRLzFyY0xRLzlFRWtIQ2R2UHdOSzI1c2k0?=
 =?utf-8?B?aUtKOUdlT0RXUkgvcXRYOHlNSjcrQVBIRnNFY0ltL1RsWXp3SUhYZDI2NnJC?=
 =?utf-8?B?citsS2x5enVLUG4vdC9FdzY2VHZMUmUyS0lCNHFUdWFCazUyeVNDdEQwT2Nw?=
 =?utf-8?B?bjJnbXNkNGsyTlV6RDlmQ215Y2JqdEpKU3p0SEFwYUtoSmxRVHRxZVVVVWN2?=
 =?utf-8?B?ZGVKcmV3Y1VQbWlTZDJUY21jdlVtdGI3YWdoVWNwalBjbFp2ZEMyODR5MnpR?=
 =?utf-8?B?YmNsRWVYeXRobjBWVW9LeVJpSXhSdENVZ0ZrRXREUXlzRy9FTFB4NUY4T0Jo?=
 =?utf-8?B?MjdZUVprSTF6T1h4ZWs3cC9CSEdTbkRMRHJ1cC95bW5UeUFtcnBhdlNNei9r?=
 =?utf-8?B?TmFud2F0UnNobjkyNWFRL1Q1Ym10ZWw4enFWL0kxcGltZ1hMWm9YU2NDWHow?=
 =?utf-8?Q?Ij2Zfw7lrPCBNi6g=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d4e602-2d63-4b27-8ec1-08df4191411e
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:20:22.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtH2t8FYOg8O+6vGV5DPdNusHFOsGJ31zovDosi4q7R55TQbbvp0lrujJ5NYaWVYz8R7+CKvGDAH8egktddw1sDYRtzxlpdTk06L3czD+fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB912907
X-Stat-Signature: gqtdsizpnjtaej3jba8ihmbq397hfam8
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 740E2A0002
X-HE-Tag: 1794579626-828505
X-HE-Meta: U2FsdGVkX19Qbvg26abfN9aWc+nk5HXB/HoIF1kEs8YQlI0YBTJCfamerIxRfzZUicEwmYvQtyszEP/EE2vbEC1jQDEHPoSf5RDUSjK9JxraIB0KWSEdRXVj2tVhdRQYsBvP9d3rkHQcDwjT0Iyk2XS3GMq17wkSkPalTx8WgFijeOMoRm1EpHcCvxlhShGssVMOXGzaLmZswqjeCLukdgDGjd1FucJPC+6s6Coh4sPPxPEjC0ih+B4akbp/hal4mI6NaUo+aBNwvNp4D76UUNpl4009vowcNTT5HWPNi7NBIg3hT2KTZ7iKYQrEJljvrXMuFAYGYbKtQNqMHlgXjuHBgCe7RxlzNHKIPtY4tD4K85GuD7CegeNM2EUjBUBgSHYBbnpdfIbLGYz6LKfqxlegyFaY/MTBQDrtlEEHcVkh12zEydZO8xo9FJV63QtAbGtPV0GB9SvcgmZ6KE/R5lDvoz4ftvlrfQhD2dQA27P1tsIc/LpUr8Ypvo7sDXx2cvOZcR58RDFT9tNH3ygQjmTbX42K//+ta+xhHD7atBQroYC/TZtbrkbnys3WqBycUDD7CSVqabtx2e828KD/UbStoNeZ/OowJb3tJDlpFw5/NiFQXuhJfvA7zkNogE15zMdYWelFsJ2+9+nEG+S5fhfH3XewTS08ROMgxqGsDF9K60O7qzoFmt+Cwxkr2FiCFKf8HZIDtiIitWRxjbiemxGXMq0bu06yrG3ebiwP3YLppjuSY4kYZdVqDORaqUqO64PLBfvJDjRLX52e+hFbix6rq/z4YHhEebpbJO70JrrUgN587r2SiZRiFsZQsUyYbEPwzLkhjNL0fQXQviL3LRAoGsoo8mvBx5bdiqGrOF6GgPyier7S4pIzu/mbCTaNCZLSxlKQhXuIN6tIzbrSbp+DzT2XW/yk6Ml82SUQ3KkXkSEB52mRMAydyKSSn4nNtmibUn4TnnGxUWAizqI
 vEO3LBVh
 P6mxdIDaVa4jyM8Yb9gn0CRRkdqmpw3wKHblDSZDoGXQq1ok3TzVDHHmLlkJb2DlAWRUk6BWmuNWhTJmSow+fZXpOUReKaBQPhmaBMZXn4HgK1rpCPh2vFCOFEUmyeHe8AMm2rZDCr4k5iMlo6+w7nSLIMoWsS0Tgfe156HxBxLf7BtZYEvAYxEAGEHXStiEq+/CqhQaKQHeiqvyQSPDHNY0GI7MW+WAw2Fh4CU3y+Kmg/kkOfSxtNXkVCCXaHeUap22bLY6YCQ23aAuSkUkwFXzWdVH61zA+vM4p8bFh5JitQKt0P6J6rtJeKjo5oF+gsYKnn5/6opVQUfi3JBa7Kb4ZjnWm9gdd0brqDUFhK1cDQsJ4171QMueK5/iH2rii/ismbS5zr8rDaYgi7SYvAv5ojMo3ycd3mCh2U7JzNYuVdMrw3zCFAkRnNi8vE1cGcvR+hF3SdpqoXv0YtAPK1dy4SHX07TZPGz11CtJpgsHsM9Ih5U5nOjjrCGWWmv/v2IwxNc0Yj62N1wiZRUWR7m6WTHExSIIgONe+rbbMbrhj4z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: Medium]
> Can a failed fork leave mm->rss_owner pointing to a freed task_struct?

[...]

> If an external reference holds mm->mm_users > 1 across that mmput(), mm
> outlives tsk.  A new task allocated at the same slab address as tsk can
> then match current == READ_ONCE(mm->rss_owner) in __add_mm_counter() and
> perform unsynchronized non-atomic updates via
> percpu_counter_tree_add_owner(), losing counter updates or triggering a
> Bad rss-counter state report in check_mm().
>
> Clearing mm->rss_owner alongside mm->owner on both error paths before
> mmput() would avoid leaving the dangling pointer.

Yes, both error paths leave rss_owner pointing to the child. This was
found by reading the code, I did not reproduce it.

No update would be lost, though. rss_owner is only compared with
current, never dereferenced. At most one live task has that address at a
time, so the plain counter still has a single writer. The other tasks
update the atomic counter. The counters would still work.

What breaks is the identity of the owner: a task which does not run on
the mm would update the plain counter as its owner. The owner should
stay the task running on the mm.

Planned fix for the next round: clear mm->rss_owner next to mm->owner on
both error paths. In copy_process() this is done only when rss_owner is
the child, because with CLONE_VM the mm is the parent's.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

