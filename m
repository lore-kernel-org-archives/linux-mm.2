Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F675D39010
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC97A6B008A; Wed, 14 Jan 2026 14:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A777B6B008C; Wed, 14 Jan 2026 14:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904156B0092; Wed, 14 Jan 2026 14:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3916B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:21:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32C4C1B9C0
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:42 +0000 (UTC)
X-FDA: 84331538844.13.969AF86
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022135.outbound.protection.outlook.com [40.107.193.135])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7591F1C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Iw0AMdLP;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.135 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768418499; a=rsa-sha256;
	cv=pass;
	b=7yrcf+s9oGmiXF7STN7EKCfkqa3mb4dwOLuRpo1jXolSOuupBEezRq8lzNkZI2tALD35NL
	PXRHHQsWQRXbmv4BHb4OoviDo9gyUpjmPeBtU/EnlAEe9KFFaWewbP97Jpfu791Fbr9F9P
	LgCYvciGBtpYZww5vgTMqIilBW30ENQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Iw0AMdLP;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.135 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2u/7ogJNvia6EH0YSQkofhuXKCwzceq8Jd/0MxeG/ks=;
	b=COaJNqDS9EnEZ2XpXw9TOjF8xqdq1k0BilNRyW+YhVt6G3/U4YiwtnQBzkAVO90D2eyMT4
	iStI7x/WYKv8hzKV+Z+BukG5eFs/gqPqz+xBQJjmBIxb2NNdOShalYnTC4KLzWAuiWiC0m
	Km6TI11n/8zuW33cPwJ42xQcY74OISc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2lqpbf5pq0/SdQ6ob/Jv6lzBvIXnrpAAqMZi5WEPrH6xPc7Lyd75ER5X6k7uvvrT5Ou1w+r9SKHDS7bnMbwzZgYkze7NS4KGYahBIS73ELEQMDUdulTrvCfYjthuFd4UYHz5OApeXu0nOnLZ4gLl7p2F8IMFBvHuS4ttEb0NO+9r4CmbGHOZBKyHeKtu+gMGl2pnhBQJG7YuuKZmWxHjbC/FdEiNKB8Tmz4JyWdAeKEFpWrLIlq+wo02fxaAONB0DaRwr6LAnhz8jxJnMRfB6e6y3js4rfEWjuehTz19Fdyta4lZ2wwjrDcY6REcrl+1D12tsVakMh1Pxk/LfunSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2u/7ogJNvia6EH0YSQkofhuXKCwzceq8Jd/0MxeG/ks=;
 b=wGt9SPQjI5Stgl/1ac1neDgJW7F85HPJJdNCS2Ya1mER8rWOFG86Xa3FIrMbNWKAKF+lZp3Sf4NwNmEZ8eFRo1Pv54bGVtXj81WCueC4DjcUa7WE8UFHBCSBipc2pjF7wMcNQozouLiz3k1AyowH42EjdVSvBhUCYfbae4HRfdo6jeC28lMKc1z0eIXVw4QnMzX1GO0tUK31b8FGas53S9MBS7V1pWPZ32pyjwX8/w6gOQkuzKwxs3X2wsCqC1ZNZp70KbywdWiaQ4451IGYf3ADs5TO0SiICNgW71uvmrl0iUk94EUilunRYSPxqy9gVK2A2SUttIBSueIp2Bm+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2u/7ogJNvia6EH0YSQkofhuXKCwzceq8Jd/0MxeG/ks=;
 b=Iw0AMdLPcOEg7o8h0jNIxVnaoc8vVsBdKBhILJOcwrAwV5k7npsAGG9/p60eESMEH89IzGtWNvO7X1Rk51RWdcBJ4//Wb1S81+Bir7U0EXSCT+eAcN62d5H0HifjleoBc1BGxqcWkQwZnFhUcnYjojUaaDimvPno0ggxt3gl0NDOJLsjpDP3qN9ZKCvQOFvuMGuLLgHGsCh0d9ShWeSV8ltas8zR0hv3iZAVJNFp3OJKTPgpbIKHbQWT/yP6wudqMoR8aCLWkMc7JpRkGSRYiJMHPktgEzCSABMJ7ZM7QVLaPMCmW2O/mjAKTdK06HiGpkkc0GrePetzRWkgJWusdA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB5807.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:57::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Wed, 14 Jan
 2026 19:21:35 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 19:21:35 +0000
Message-ID: <56bafa34-073e-4791-9f21-c625723ffc30@efficios.com>
Date: Wed, 14 Jan 2026 14:21:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 2/3] mm: Improve RSS counter approximation accuracy
 for proc interfaces
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
 <20260114145915.49926-3-mathieu.desnoyers@efficios.com>
 <aWfIwKzzIihhByJ9@tiehlicka>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aWfIwKzzIihhByJ9@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0288.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::16) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c8cbfe-dfb3-4b20-8ed8-08de53a2221a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1ZkMmpndGN2aGROblRjbTRQZnZPQmh6bDNVQjFldXNQZ1Vad2hrM21kVk92?=
 =?utf-8?B?cGNFZGwrUGdLT09EU1dzTGdOdmgrNXZrdlgzWGNRQUF3U0lJNGswZXd4NXFk?=
 =?utf-8?B?MGIxVHVEeWxHdmNXL1djZHEzZklFUlU1N1h1Q2lxQmNwV2MxSldmS2FmVlAz?=
 =?utf-8?B?b2dYVnhiVTN4WERsVzlVa2ZSdThvekdZN1RKZ2x5YUtTKzl4Mmo2THFhNHNk?=
 =?utf-8?B?RE9jZGRaT2hTNW5sQ3doSjFYWWQ0YUE4WjAzYWcxOWEzUlN0eEkrdUozd1pW?=
 =?utf-8?B?ZWRsM3ZKOU1oRldSdEVYeGk1dkVOdTg2N0prTytwR2lUUS9UdzVNRWJDZGtv?=
 =?utf-8?B?aS82dlYyY2JEWUhXYWNCTDhmUW1xWnludXJtNkgrME4zL0Rtd3lWNXh1ZjJw?=
 =?utf-8?B?eWNRL1g1R1MyTUo1NDNXQ09yRnFDYkNsdVl5c3hzVlFwVVB5dnBjMXBjS1Rl?=
 =?utf-8?B?dGJQYVJ1MVQzeW1xSTA0R1QwVEtKSjM0QmFVYlcwTVhmcnlBZXZjTzBvaUJW?=
 =?utf-8?B?a0krUWs0TnF4N0g2a2xFQVdZRVBvK3dwRnV2Z3plR2Y0K2diS09ubFN4bkV3?=
 =?utf-8?B?KzVMT0MrYnorQTBkeTJKZmdJWjhpYVo5VmNJV2NCK1duc3B4MGEvQzJyaDdy?=
 =?utf-8?B?YnpLakpJR1RQWFZlN2xPa0dXZ1c0OHkxSmlyVnhrMkZaa0VqVk1UWUcwTXps?=
 =?utf-8?B?RXRIY2g1WFU4TnFqL2Y4blB3TFhJR2JhNnlxbWhUUjM5Y05zaXJzQjh2UGtr?=
 =?utf-8?B?RFJHWGtUOHhBNUdnN3YyemtQNW93THRtNzk0cFBGZC9ScmJZOXNmTEdJZmti?=
 =?utf-8?B?eW9ONkRaT0lBcENsZWNkS1pFV3MvY1VIMnptNVRvWTRycXJqK0xuRmFSTDN6?=
 =?utf-8?B?RFJaSDdrS05hTVVzOW9yb3FBY2hKR2JzdUQ5dEhOSmgzaEZjSytzeWZyYjVw?=
 =?utf-8?B?NzVPTnUycDJMeG4rb2FIU2lTbHNFUEQwNEswajJhUDZYNSs4QjdCVGVYeXlw?=
 =?utf-8?B?dHg2cFljNldVSmNZL3owS2pyVnZFbEVvN2h5bjUzdWJ6M0s0RTU5NDBMRmND?=
 =?utf-8?B?UUdHcmhudHVadjlubDhsOE4xL1F1NUlzSWNDYWZoRWtDTVBwTFhoVm1OOEgz?=
 =?utf-8?B?eFZwL2t0eFAwcnY1ZmNTL0NqTGZUVjlqTU53c0kvRDdhcE9oc0VlT2ZDb2hO?=
 =?utf-8?B?SnlBbXk3bDlWZDFQNlZueUxsRFo4OWorWTFzTVlidUpoZGJ0cGRLSXRkbmp1?=
 =?utf-8?B?SHVxL252RGhUUERjUTlKZjhOTDBWcDBHRGNGOTVXUjQwYWFGNndNT1U3dnpp?=
 =?utf-8?B?Z2ltTkVCaDR4dWFNMGdzR1NJRml5U3pRSXorRDJJL29keGZvMUZPZ05wMTMx?=
 =?utf-8?B?R2U4dXAzNzFBR1N3Q0VsMHIzRnVjdjNNNE5nTk9pSGlOSUNwcDFKZ2s2d3Zi?=
 =?utf-8?B?NCtlVXIvZG9tZ0h0OVN6a0kvL0lPcnBaaEtaaGxhckJuM0xtbWx1bnQ1NHpN?=
 =?utf-8?B?djhqK0YzbVNuZnlRczVETDZ1eEY2b2QyUkJSMHdKOFU5VHVtZ2VYTEFZdmFq?=
 =?utf-8?B?aGxyTWRWTkJraUJBMTErNEg0OEdKNGxuNzhBUTdmdGFmVzQzQ2gvS3lFYlFx?=
 =?utf-8?B?elYzOXpoWnhpVmk5U05YcnQrSjFNNUJBNng3S1VKWDVzdGtmbm5lQTR3MGZF?=
 =?utf-8?B?VUlrUUM4QVR3SmRxMGJtVmZveDVLMS9ydy9OZ3QrSmRzaWt3SDhHK2d4d3Z2?=
 =?utf-8?B?cGJQSGM5d0t4SEF0UjFMaEdXTDJmZlRXc0J5dWhJUCtCYkNuanl3QWMxcmpM?=
 =?utf-8?B?TnlKUi8rREd6S0ZzcG10ckllZWRJN3BVSGNLb0hnWFpYR21zTW9NYW1iZ2I3?=
 =?utf-8?B?Mk5Ec0VMaVpWRzdZZExuWXJwMzk1a1NTWGFRSTN5a2tHY3FCT1dHeGxlbm02?=
 =?utf-8?B?UGxMUndwM2I5WkN0b2xtYmJhSHg1S2hWcTZaNndyZzMySnZPVm9IS2NIWUor?=
 =?utf-8?B?czlrVXlTaW1kb2ROSDZmWkFaclVIWHFKSFc0N1p3M0EvS05mTlZHYmFtSERp?=
 =?utf-8?Q?XOnt/Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3F1NmNaenlFMHFaanEvaEIrbG9QRXlETjhJVUVVa2JqaHYvVy9qL2NXUUZI?=
 =?utf-8?B?emlFVFhJTU9Ba2NSdkhBb0JxOTJEdnpNcHVpVU1maGhDeFlhK1h5WFhJZEQ4?=
 =?utf-8?B?U2VKOExDSG9hTFRCcENvUTVtZVJOdzZ2TEsvMEE1WU5ITnprVkowUmFWTGVp?=
 =?utf-8?B?QlVhNDhzS0ozNHRKV09kRFIzZ2YyQW44N0twY0VvRDFGNzgycDZKYnF4RC8w?=
 =?utf-8?B?SHY1RlZGdDFlRnFwcGl3OHlpYzZKUTMvRjU4V2JCR2ozaW1GUS9kMW5VRkwy?=
 =?utf-8?B?QmRjakJ1WGlKVUhXcWZuY3FDRGEzLy9uZ0JOcDFzaHZrWWRGbC9iOTF3Z1Fz?=
 =?utf-8?B?MXhBTTFrVkg0aUswQ2ppaC9ybFhuYmk2OTJyUWJqR1NPaHlQY2l3WFp4TTBU?=
 =?utf-8?B?RC90dVNQV3JoK0VpenZMMS9nMWQ3b3M1UCttOUUzN3hzcUxrMDhVdnRsSk1l?=
 =?utf-8?B?dFY4L2hKZHlHck9vdm45cnZBZDhVVytrc25FNmdYaGE3Qm1zc0llRmtyNjBp?=
 =?utf-8?B?OGxuMUtCTllhSUo3eDd3QU1qU3BYdmhCdUlmQkI0ZWVWcThSdFdxVk9FVWtN?=
 =?utf-8?B?V3VONEFGSlg4YU1NWVVXSXNHVHU5RDZXVER4bi9TSGxVc04yeGc3dFFlTzRK?=
 =?utf-8?B?M2dQM1Jjd2J5ck5uNE5ORVlNM1p0UytOS3NqTHppa1BUMGRMaWZYSmNaZFZV?=
 =?utf-8?B?TzdpbXFjejl1NUUwNHdUbXJvMFRIRWJLSmZGaGJ3dnhXWUI2ZVVEUXRJTy9U?=
 =?utf-8?B?RXZqdjZpWStrcWVGeVlQWkxYMEFXRldWdWViZDFzMWFBaUlQTmtFWlE4Z2xP?=
 =?utf-8?B?VkY0RFBTdEJMZUV2ZXdTZHlQSXJGUnFxYUFhVzc0d1c5SGNBY2I2NkpTZ0NJ?=
 =?utf-8?B?M3IyU2hCWHRkeHQ4YXhoRGladndOQlRkUWk1cll5Zk4rYWxiZXBYclRTTWtR?=
 =?utf-8?B?UFNkOVJCN2ZoUUdnK1hmSDg0YlRwbWNiVkhnZGVvV0c5UzRYbW9aNGFPUE9K?=
 =?utf-8?B?Q0hUcHVWS1lRelRFTStnZmdMTGtCQ1FXbitGYW5nNm5wL2tBaVZWU25iY3RE?=
 =?utf-8?B?Ui9KNmN4YUR1WDN3R3lHUkJhS3M3cjRHSmMzLzhQazVWOTlPbit3KzBRWkpZ?=
 =?utf-8?B?Y3R1YXUvdVJ2UDdzbmI5WitvVlVHNnQvSmpyd1pFeXdrcDVzK2VCS2xSdU5N?=
 =?utf-8?B?NDVGbk5HUGF0clk3MWxGcXhHZVpvd2hyWWtTUmNCTUZzeW1iRGV5ZWF4RkVi?=
 =?utf-8?B?WGNZbFRmTFRlSUVJRkg3OEFXVlBVZGdRVGlvemFJRHlCZ1VHVkF5VEZscnpK?=
 =?utf-8?B?SHgvOWdGaUcxZ0lLbU85OGx2SzhHeVlkOTNVc3ZSWCtLNEYwSksxOTV4bFc4?=
 =?utf-8?B?ckQzdjlKeVRXczJxaGxiWmgrNEhaZzhYZTFXY1Y2Ylg2R3MzWG9xcVV0dENK?=
 =?utf-8?B?K2NXcFdkY3BPTEhtckpvYWZrMUZBOEdub1BCZTkvb1NkbnQvdXg5TmNkNHhw?=
 =?utf-8?B?TmJRbjVobEpPMC9FNS9PMVR5WWxDT2pjdldoWjZmcXAwVzc3VStVS1lTSjE1?=
 =?utf-8?B?Wkp4dTNieFl1YVk5R1VvcDFFQjFkdSsvaWswRWw0WTdMb3BQSWdielFxc0Er?=
 =?utf-8?B?T2xBWmFMam1KUFRNVHJhOWIyUGV1ODBOVUFzUjdhZXRQL1V2Nlc2QkZoMHIx?=
 =?utf-8?B?M0lPTUo5Zmh4QzVhM0hMNVpiMGpsZEIxRm92Zk5pbC9FajJqdmt6Q2NaVHo1?=
 =?utf-8?B?Y0Yzd1JZUHpCZy9XOThuSHdqamhMVFlhbHM1Z2Ryc3NCSnhDOVg1c3J1MkxU?=
 =?utf-8?B?emNxeVNzQ1lpb2lQRzZ4ak5oWElQYWVLaHdYYTdsTUJWYm50RGI0cXg3S3R5?=
 =?utf-8?B?ZG9IcE5Ud2RVczBsMmNrdS9sM2ZCck5JR3dqelp6QXBtcDhFT1VzYklJTHFm?=
 =?utf-8?B?aGN6TTBOZ3NZYzdyVVZJQ0drZHVDZjM0eHJscFdKbTB4VkM2NUc0cUJ6a09u?=
 =?utf-8?B?RHhWcXZvTERRTFozV0ZYSCtGVElMemtvVFkxclVUek5qUWE2R3VtdTlGTjB6?=
 =?utf-8?B?ekdNWGlpSmNkOHFiN2lYQjZaV1FZcUNyYUJwZjBSLzM4d09KK3hhKzVEWkJZ?=
 =?utf-8?B?YlJZVENHMVdPOEhnVDFFa295MVBxejh0bHMxUTR0cnVjUTVESngrWGhvSnMw?=
 =?utf-8?B?NE4ycEhSOERibHpNZVVjdC85dXFBU1MvRnBuN2ErV2JVLy9wTHlkUXdzaDdm?=
 =?utf-8?B?TlVzSEVuRnRFTUkraVRrWHpyUzZrbGtPNHpqTnE2WTg2MWFHQm9Xa0tySDZm?=
 =?utf-8?B?NEpPVU9rU2EvdzBheExMUHF6TDJvQ2NjSHBuK05jTXpRTmhIajRjZXBrcUtJ?=
 =?utf-8?Q?ihZgJ6UJuoWjQ8lc=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c8cbfe-dfb3-4b20-8ed8-08de53a2221a
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 19:21:35.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LK26UqGyQFAM+2Y7N+t1Hv5ZSYYlT0GXF17Jz2d1ZkjmsXjrjybpPQ+zWke9PJ1gNdvE/EftvYF3tKi6ggq0Dtb/4GL/Y5O/H0NBIYcl2MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5807
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7591F1C0008
X-Stat-Signature: duf6owjpgtwgbc4ws51ksbswm7sa1k57
X-Rspam-User: 
X-HE-Tag: 1768418499-504394
X-HE-Meta: U2FsdGVkX1+ucwM6XBJPro1alZqIl0wOCkh+EvDzPAFtBmCDhfNgT5jofjQH7SM/FLFlfyWtD/XZeYsYeygmWMI4SxBUDzqzBdwe1Zxs9GSBN2lfvErvQ+Sn49OyYhYbmLRBGOeZAKWeDjygaJalz9oZqNjDRu1gB/7bg5dGfPZHXAZ8cTi9iv0sgLEjJ61uzIF9c9a2LHMnL1DNIRWKHjNbKte0o4eEoXQqKtYQelZ+8MffsBng/RQ82MkeonWDsf+Ag42zi3ghCZqpNb0OuD24QODd+ICJuLJ8rEk4TqzaDLr37xY51Plz+JxltjluNYJgzsFPK4+2dX2frywvarDjsOQCG81KmuB2bl/SrCF4LzS0JKqPcveGnDF7GRRGcCm+ptofZQmqIeqQT7pE2dopC3+ujB0m+4hB7OdQKKGSBxem4satf8wHrNd/TMgWEylgTN0p8B8fgCLZx3nnxKkel2avXeZ+bR/m191SMwz468NqsGT9QxgpOON15Gk2VjknGpW3s8E2XDOlLiPL9x+EPsP/XP3+jtbx/O9q/b7Kf/oGK8eTJz9FI5NY8FXrIjw/ihVhxDHVzwLaaAnEGE/k0jLVlzNcLWrQNqjkkbGCVmyUyNjhpAgGWSrMyF3Q9dV5Si8oifJXcun4hQ4FPi9Drcen2AH03lpgf2NoDZE4r8/lLLAJuFWUxcfvAsoxPzKUIBfI9zr19pLmf4Hmm1N6Cv1Q2BCco2B8WTfvJvuyZeQnwAdw8uvdF0lU6JJc3eb35wPvHvwgQZ+ZKwvDUu9AzDyHV+zSvUsmGd1j9ZlYSCs4WtjZAcslaVFqZoFAU8SjS17eegkwiIKHRpkamR+QpICFMoPKcYziHh1KxMOhm7t2TwvXAbUeyK8SIB1HzztkdfwHhhhki/BymAdD1L+Nqe2eWXlK0Wfo5kdQkVguXReHLF+1ijSxCEPBf9Co4WHtREPAk3xVCxGSPu+
 HMoh2llS
 tBk8tR7yLbgQGB0YDvwe3wVQYZZ8wlNKVzD/vTtLL9DkShJyBe0eiEN4wiJ3VbXfMC5GeMAUjFCursRExJ3Z0FgYsCq/B1F5IAKCB2TkQapxyf4SKHz48+Am2YFv+Ushkq90DtyeJRZD2OjnnBjtgFoN8qz8BLhQ4xVH9z+Ugop7t82J7jRwYQTSlcNHNR6e7EcMrrflT2OpzkFC7qppwugGYpZhjLSmC+MJMSX8DjgcM3SVXhXea9pZI8hx/JmIqWOfvqmwPVRSGr7kPaF0nBqxjyrzolkRlx/+4OmF+ujNBGezZqoAJZ9fuxEFVlHzXpdpZp0pSlE8IQTksAqaqnZ0JZ+j+BdPPB530f3ogBmUlLyTY6mfkRwg3vJsx4KXdF/Mypr7CxJchJomX3PdC2jP7q05GAzx3zpK2k7S0muzcCA5zxv5tA+q7d/VwXEdYtQw+GtB72KrC2ieMBmik7MWg7+cEFDf54NKGK44jjm2xqvu5v4OZk4qrgVsiJ7+sB/7urA/orA8C2aofc+mpK9BrpZCFdLg2pA1n5WCF32QAl8A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-14 11:48, Michal Hocko wrote:
> On Wed 14-01-26 09:59:14, Mathieu Desnoyers wrote:
>> Use hierarchical per-cpu counters for RSS tracking to improve the
>> accuracy of per-mm RSS sum approximation on large many-core systems [1].
>> This improves the accuracy of the RSS values returned by proc
>> interfaces.
>>
>> This is also a preparation step to introduce a 2-pass OOM killer task
>> selection which leverages the approximation and accuracy ranges to
>> quickly eliminate tasks which are outside of the range of the current
>> selection, and thus reduce the latency introduced by execution of the
>> OOM killer.
>>
>> Here is a (possibly incomplete) list of the prior approaches that were
>> used or proposed, along with their downside:
>>
>> 1) Per-thread rss tracking: large error on many-thread processes.
>>
>> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>>     increased system time in make test workloads [1]. Moreover, the
>>     inaccuracy increases with O(n^2) with the number of CPUs.
>>
>> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>>     error is high with systems that have lots of NUMA nodes (32 times
>>     the number of NUMA nodes).
>>
>> 4) Use a percise per-cpu counter sum for each counter value query:
>>     Requires iteration on each possible CPUs for each sum, which
>>     adds overhead (and thus increases OOM killer latency) on large
>>     many-core systems running many processes.
>>
>> The approach proposed here is to replace the per-cpu counters by the
>> hierarchical per-cpu counters, which bounds the inaccuracy based on the
>> system topology with O(N*logN).
>>
>> * Testing results:
>>
>> Test hardware: 2 sockets AMD EPYC 9654 96-Core Processor (384 logical CPUs total)
>>
>> Methodology:
>>
>> Comparing the current upstream implementation with the hierarchical
>> counters is done by keeping both implementations wired up in parallel,
>> and running a single-process, single-threaded program which hops
>> randomly across CPUs in the system, calling mmap(2) and munmap(2) on
>> random CPUs, keeping track of an array of allocated mappings, randomly
>> choosing entries to either map or unmap.
>>
>> get_mm_counter() is instrumented to compare the upstream counter
>> approximation to the precise value, and print the delta when going over
>> a given threshold. The delta of the hierarchical counter approximation
>> to the precise value is also printed for comparison.
>>
>> After a few minutes running this test, the upstream implementation
>> counter approximation reaches a 1GB delta from the
>> precise value, compared to 80MB delta with the hierarchical counter.
>> The hierarchical counter provides a guaranteed maximum approximation
>> inaccuracy of 192MB on that hardware topology.
>>
>> * Fast path implementation comparison
>>
>> The new inline percpu_counter_tree_add() uses a this_cpu_add_return()
>> for the fast path (under a certain allocation size threshold).  Above
>> that, it calls a slow path which "trickles up" the carry to upper level
>> counters with atomic_add_return.
>>
>> In comparison, the upstream counters implementation calls
>> percpu_counter_add_batch which uses this_cpu_try_cmpxchg() on the fast
>> path, and does a raw_spin_lock_irqsave above a certain threshold.
>>
>> The hierarchical implementation is therefore expected to have less
>> contention on mid-sized allocations than the upstream counters because
>> the atomic counters tracking those bits are only shared across nearby
>> CPUs. In comparison, the upstream counters immediately use a global
>> spinlock when reaching the threshold.
>>
>> * Benchmarks
>>
>> Using will-it-scale page_fault1 benchmarks to compare the upstream
>> counters to the hierarchical counters. This is done with hyperthreading
>> disabled. The speedup is within the standard deviation of the upstream
>> runs, so the overhead is not significant.
>>
>>                                            upstream   hierarchical    speedup
>> page_fault1_processes -s 100 -t 1           614783         615558      +0.1%
>> page_fault1_threads -s 100 -t 1             612788         612447      -0.1%
>> page_fault1_processes -s 100 -t 96        37994977       37932035      -0.2%
>> page_fault1_threads -s 100 -t 96           2484130        2504860      +0.8%
>> page_fault1_processes -s 100 -t 192       71262917       71118830      -0.2%
>> page_fault1_threads -s 100 -t 192          2446437        2469296      +0.1%
>>
>> This change depends on the following patch:
>> "mm: Fix OOM killer inaccuracy on large many-core systems" [2]
> 
> As mentioned in the previous patch, it would be great to explicitly
> mention what is the memory price for the new tracking data structure.

Yes, I can add the explanation here as well.

> 
> Other than that this seems like a generally useful improvement for
> larger systems and it is my understanding that it doesn't add almost any
> overhead on small end systems, correct?

Indeed, the impact is mostly on large many-core systems, not so much on
smaller systems.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

