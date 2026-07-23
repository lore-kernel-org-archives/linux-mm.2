Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC42C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA056B009F; Thu, 23 Jul 2026 13:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA5D6B00A0; Thu, 23 Jul 2026 13:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972A06B00A1; Thu, 23 Jul 2026 13:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCF96B009F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:53:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6C2380123
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:53:13 +0000 (UTC)
X-FDA: 85020787866.22.2F9AEAB
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022096.outbound.protection.outlook.com [40.107.193.96])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6B40140007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:53:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=W5YcDbA1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.96 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784829191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KBn5DiYxG+GbpoHUPwo9I0Tclsx4w9FKrPNs8Ba+ss=;
	b=ignP2PN9K+TtLYVs/uHx8IEtsVnwNMJ9zlQECUp8AeQVIS0NNRHtDeIq/Ixg66MvBkErov
	+GH4O7LRzimUSW3TOmvfJLhB3DOIlBgDITmo56OhE5ZbXpeAwmyLJZbqjWN8YAETh3NgBJ
	xUy/u++lHuewhlFesFjTlUpx/ldDOrQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=W5YcDbA1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.96 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784829191;
	b=C4Nz3xmGmkYevOFVdfkay+9bYOx04Oct+Ps14C15Rcd8nWIQw0Fs9Nx4qfMdL7fXk6Nf5C
	+Hrpd7tIGLZSfzF6kxdGOnIlg9uXqOVcFAzXuNhPtSEUwQqUHE8M+FXDmDwjWU/V05AIsJ
	iS3d5tyG4GfpqsTJErfKHdX0WX2ATt0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DdliDw3Mkia75t4HxHl2z10AumsPfFALlesxA08a/xd1DsR+HCjKVslaB4iEz+rxQudFras18HgzL1PqxZrq2VpydkMQ3l+9dStSesLSdZPgSgV7L9fXcUmKpJOiJLIiQsUw1/j2CG+NnThum7wwoId9RM51eJldYDeAhxlQ4+boAjlSaxiPtttdTKjwTLZ9uCNfICu0aZSXLfF5q6W2wVERdnFhK6AmceLQJzdqTzVqvRd/+YlF0/NmqPCA1WS95JBCd//mjzUPIso+oZ62KXws0saEZMwXwinb/zw/L6rviBOq0x88GIpo++i+jnyrALlnAohiT2BH6iM9H4G0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KBn5DiYxG+GbpoHUPwo9I0Tclsx4w9FKrPNs8Ba+ss=;
 b=OB4KvTZ7z+O10tQLsDq+kxSt2ThkJxCMnEnBbEh9Y9ocFI5CgWkT+byX5IV9bO3Y25lJJX0XKCalDAXva1fxGThsR/CWpDyheNhbpt+guqN1ahJbD/VuDM30QUWev/83kSQYoe3iHng4EZC+gU3Yh1owPDz5PB5jS2a2hwGuU7ZUbDG/rfkaLzlVnxBjLE2Y9mioulIV49iHjVaoyF/IqooM/tvi5FaZv86lNxTy4PmVpPPAkBnioZ5JP8LsjG1DK0J2ruF5MpS4O9v7WaUdEIEGBabk/Jfv1u0NY7XSTfW6Joh/HCcv+YQ22MbtBqkDErg2+i36p3LM3gjr+QnKKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KBn5DiYxG+GbpoHUPwo9I0Tclsx4w9FKrPNs8Ba+ss=;
 b=W5YcDbA1SQNTGit+33JlCCDZPz9z0zQXPQUykoReB1MoZbOxr1Nqca+Jd7AF2+ccmLBw/wu7JseCHTf63vKYxv4ZvlXNS2b3t8ngReEuvDl9P7FsystBvBMutWHXmTpyEDJ9F85VKOPoV5PagkRobMvUxEBltdI8QDXJl5FWFx8NXNujac3qYRBY0nr/PGd2DTnmEmvo9YgHly79KHruxVTZ0hNGctDttFCQWpXeQ3R2kqOB+TtgDXFjUKeHSAR6FRKZaLuFZov2yWJAA9ovBEcDVkLpry7sPrwCiq2o4X7L96/sG6XVDhUND3cnC7e+pNMX7K+6iiSvMOT8Zs8kwg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB292281.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1c8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 17:53:07 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%4]) with mapi id 15.21.0245.010; Thu, 23 Jul 2026
 17:53:07 +0000
Message-ID: <0d454717-be7c-47c3-bd5e-2ad304c3423e@efficios.com>
Date: Thu, 23 Jul 2026 13:53:02 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 0/6] Hierarchical Percpu Counters for RSS
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>,
 David Carlier <devnexen@gmail.com>, Josh Law <objecting@objecting.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm <linux-mm@kvack.org>
References: <20260707131544.75906-1-mathieu.desnoyers@efficios.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20260707131544.75906-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQ1P288CA0002.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::23) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB292281:EE_
X-MS-Office365-Filtering-Correlation-Id: d7fd9bd3-fd9b-400e-97a5-08dee8e340a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WiWei0ehLdB70TtixozVrk3CC93jm4qxi5BVNEPMNwapffHhso0p3HE/kfNY/SO5jnP+qO3GMamxXhlEbkOFQYNVuQlFgYy0bMsd2W8+L1meQnhA4VHywVChyLxAuj7klPpI+BG7FNXACkpiveLurKOkfHNksTNlHenq3GtN4020uAMW4Ml23jbgWFRCrE28xWmsPlySNrJUHPHbfq2UtTLhC6SiYJv+fN6R4hQyq8B3yOU8+RR9n8nIjUYtWzMIDMznDaCnjVaRyDW3gmGe8jxJ2QJyyYIax61C408kvMtevkT0oViL5pImRUZXQiIB2x2P4kHdSBk5Kw/0nalYdkhARUMgZ9acV+E93IPM7gEODph/mdHGdcHzw9Ym9nJVstpCst72MyYf1i4i15si1i9L/rz0D+1vThxImJRKpsq7UrxroC8T6ArWg3YMd0ZTOrbfL7DvKw0YHCLwrZ7iWtIhTpqMWU1o8M2nZsjYU61Rg3u3YMkD9SMuM/QdZGb4hS49kHTxJ2EN3/aqSGVHdSRwZ/BNmALsArc3br4kQen2P2+KzhDGH3Jg2oOjqcEaV6QFnSCnb0lCSbJBnRs45C/m5/AqBPdJZzghIoKvRWs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXUvMFp0d2tEYUFJdUJSd0xFdXhxYStseVhKRDdHWjdNOGhNN1Q2allxL1Vn?=
 =?utf-8?B?OVgvZ09zbWF3NWF2MHIvVUVXaWlRdmpNUFlmelk2MnVIOWwvVjJ0NkkwM3hl?=
 =?utf-8?B?TEFFSzAwWFZoZUF4bHM3MldZNVdzWVdqQlRLTHRwLzcweHZPNTNWQVIzdUhM?=
 =?utf-8?B?UjZROWRiU1ZIL2R5bGtRemJSMGF0MUhNWWhWWGwybDRLZTNpN1hSUytNSTh1?=
 =?utf-8?B?b04zVTZUdTZiQlFuT3JORlpSWjRkN1M4bHhVMjdmMzVyNEVSZkhpSC9zMW43?=
 =?utf-8?B?TGdOWTFmR2R1NUFLbU5ibG9xUXYyY3U3b1VCeURUN0YzdS9Ud09XZ09yaGFZ?=
 =?utf-8?B?aERjSDUrQmN1cVg3eXE3NWZaTkFremJXR1h5WHRFWmVKTFBrKzBMelBHY3NM?=
 =?utf-8?B?R3FYTWdQV085Qjh4dGk0cUpTOFNiZlVJcnZrWXpBa1d1Yk1ISElhM0lHckkw?=
 =?utf-8?B?SXBYMVV3dkxrZHVQUVRjeS9kemlySUZmRkEzNnhZNG1JZHBGWWx0SURJMG1O?=
 =?utf-8?B?bUgwcDVxSHREVEdJWkNxK1A1aDU2RFBtbmVha3JDSERBblB6VTM2bWdsWmUw?=
 =?utf-8?B?Unl4bld5cFM4OFVzNHVXb0RsVUp4VENwOTRkcHh1WjNqK1pCN3JkbHRpRy8x?=
 =?utf-8?B?UDVaZ1FsVmIvcUV1Vy9UT1ViM0p1Z3R4T29LOVMrNnBSNlNjZjZTWDFwQitq?=
 =?utf-8?B?aWtROU1tM1M1NkxiMGpEc2o0VlIzWWFzLzY4SUc5NU5kWnRwM2daWE1xeGdB?=
 =?utf-8?B?OXBrNVN5T2draG9nMlF1VEFEYm9pZmh2cFYvTDNjRE9JWmZIZjdIY1I4dGVG?=
 =?utf-8?B?OEpISkYyY0dZS3N4WHFVdEttM09wOVNMam9QQ1VVWm5FWFljRFhhUTdISTd3?=
 =?utf-8?B?NWp5SmgvaUNvd2V3VFpwVkphNFRmenorWlBxSDdzbWhaYzBmN1FpOThsWnNU?=
 =?utf-8?B?Z05DMnBCd1gxM2xGWXZHaHVuVXMwTVljaUJ2ZjZISGhOYU9Yb2JJUllpamFy?=
 =?utf-8?B?ZWxqNHRqbzFpSVJCVS9waWhJVVV5dFBVQ1N0T1RRMlc1Q2pncFp0cXQ3RUJm?=
 =?utf-8?B?TFp3dElSV296dEw0dm5kRmxlY2U1SjB5SDkvYVNWeGVmaGlVdklRTnRBMFhp?=
 =?utf-8?B?MHQwNWxzWWlNejlnMXh3aVZIRXpISk1xNlZzTUJwc0h4M1hwa09ZL2NORFZq?=
 =?utf-8?B?Wk5XSlg5WXk3Ly9QZldTQ0hSaXFCMjJ5cDVYR2daL2JTVTVyODBLTnJmd2lM?=
 =?utf-8?B?MVYzOVFKRjVrTnJndUpEeitjcWRacDhLdDlDZzEzMFdiVHZOY0FIeFhqNE5D?=
 =?utf-8?B?NG10OXp4c2dLdW5HdTB0RTNGcnNMYVhETnhZdnd6UTN4a1ZzV05LV1FCRjNu?=
 =?utf-8?B?eHZSR0JyY2ZibGYzTnNxbTRPR2xmYWlWQ2lVUG4rN2lzM05POUNnT3hDL0Vh?=
 =?utf-8?B?V2hpNmxqWm5JcGtraEZBMnBjYjk3TTk2cGJmQjh5VEprb3RYRHJobHlMSXZK?=
 =?utf-8?B?RHI0dFdQRGNuWUVzdzR5cGxVWDc5RUsvakxyVVUwUWFkOFVJYjlVSjFvcHMv?=
 =?utf-8?B?SFZ0eUJvODl0Y3FTUFNJaUIzbXhtT1piNzFlQlc3RVVNOUZDYzMyRHdvYWY5?=
 =?utf-8?B?NmJUK0RvS05RU0RJTjJoUWxpVFhTUUJMYjg4cmtWNk8wWnJqSGxtRXVKMG5y?=
 =?utf-8?B?YjFHVGdoUTRraGlaaUlLL3dYZTBsaCtLUFRoWUw0dC85NE82SnVUaUttNURZ?=
 =?utf-8?B?RHR2R2tVNVRiSW5BV2xsMHBuT0hWWXZ4UklDZXhER0lMMWI3M1F1RjhhM0FT?=
 =?utf-8?B?dVhnc21HU3djNUJKNWRLTURVZ1hETWNCSFhtWU81L01FMnFMTXhNR3pCWFBP?=
 =?utf-8?B?RXE2blJ4dWREMFpMMHhwa3dVWTBJemdocDBXMjdEMkxweW5wL2lOU1p4ZmNU?=
 =?utf-8?B?YWUxU1FqSFM3SURIdjV5b1l4UThFdjlTd3RvbW9DNnZQa1RRdG9ZUnloNmNR?=
 =?utf-8?B?RHY5Yzc3RHBLVVJDaWg2MGt0K2dlRCtJZVJEcUVvd3ovWVFFRkhEZXRCS0Iy?=
 =?utf-8?B?ZGVmVWh3RHVlblJaaVFEY01VZ3hqT1J6cDdTRzkzbXF0NjNxeUgvOGJUWmdy?=
 =?utf-8?B?WmF4ZmxZRHdLajBSWFk1eEJabzBib0FBc3RBSG5lUkNUSlllSFRPbFdqUURC?=
 =?utf-8?B?c00vaWFHeU5wU1JiT2hkSSsrN2JMeUZUR3E5Y1hmRU5kMHBGRE5iWFFGYXZl?=
 =?utf-8?B?a1Vyd0pSeWJPS0xlaFNxWGtyYmV3cGxpNlFQbTRjNzEra2psM2svbmtpMU44?=
 =?utf-8?B?Tmx0Z0pwUFZackRNNDEwWFF5eU85MG5uMHdReVpYU0xjUTk1SzVYTkp5c2pU?=
 =?utf-8?Q?bL2YQCSwJeMBwnyTTU0rjBofiqCbs5olUP9j7?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fd9bd3-fd9b-400e-97a5-08dee8e340a9
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 17:53:07.5387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhKDiLSapotsPjIDDqF3kkpPp2hdD+4ds1PLq7wHyiyXDS33lV/Ob5tmsPPhPlZltiquA/e78PwJB9PI/GtcCD1pVhlVyOWg1wbCpAfrrV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB292281
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6B40140007
X-Stat-Signature: xxc4ejkambftk94tfpmxeabytmntymkq
X-HE-Tag: 1784829190-302661
X-HE-Meta: U2FsdGVkX1/P6q2T/dmJBFN9YsH6eabEOZRMXBi0HLO8qanF/iLAvC5kUGYstxFFv5zpnIQDhdBmtVFPE+rsFFLicLZm9ce9wrxDMbaxZaW8nUaVTMqfnWASvqejQ9dnimD44H20J2tLXHTpnoasXOzg22s98Ky/sguh6cc59y/M8VBs6PwjC+pLA6kNi8w3HVN3+b7xelv6lRaDMAPRwFU/HwM7EsGGxT7h36GKaI8Fh2O+2G5pNn0kVC/UfyxBpHkXmlt+vPKGGzgLtu4fw78AbwonI0UWYrkrC+bk3ceTmUcAYuy1l7xBPCRzwl644WoKq7MuH8M7x7QE5qC4V+qv61nArLWywT6XpiEIXVyvP7T86SUumZ/pclwVyGNlWJBLX8++RIlaK0hXMXctKjqe9LQtfPkfS61Ue2Ev7mdgbEx/g1+5FzaFqoR/Dya7IEWAd0Are1z8UHA/M75PG4zegzU8+my2MUvzcNmsDpD4xz5IJNJD9Ue/7iI3C4YKq94IiHdqURvzgAPbrd8asv8nTeH683vEq4RMzBUqrke4KsJS30b3US7l7Wq7eJfSLjex2k+j2XwmVCdEe1q2Y6QAGjel6BQe0obQnRdBEyxgImtEu80pbRQQAlVH3pK3ZivSpgf9jrK0mhjCHi3UGKzFLz5uU9xgoJLWqikR8Xj+7sVX0MTtqoe0DUPffCXdrKZcEsCngVTwe3K2MQmJ/rZuoR7fs2PWHqpSrSQhphmCa+e6d7HePaIGrk4YmJYxi3LOs3C+YAjjNMFNQPgyXUlzzws+GE3dimcWXz0o2WnmsOeKUTs8U9yFDikN0itom68uFZVfx/LpekH/BwlVjXSDX01bDgnLN+sfYb0QX4ne0R7DNBHxIinAeX/5muPUoa5I7vmenFtPLHOA9XKiYxrd0eQAkyIA4GL0Qs5YTu/c/u7fY4X/+l2J0LUYNPEhiA5ibNrgwPb3wc+eWae
 qUOdEfKB
 p8Wn+3kC2OyOK4OHsgXhfAdIZdvL9sVSeZczxbLMy0Tmd03Y/9hBQggjuRrGJDhJNa1ZYfmaKmBqXT39IyVTcj/YEFbRkcPn+w7QLlMRq3AQz1J2TRk9qndiVjpaRCtZU/gOvhg8L6KOkj3brTQD5dSq0pqtyZinlMRWK0fRACEsEpdDSU99BKgIigoHDrYAlQ38yZaGqxvRuCy/6uRCzNMcZ55Y8y61lqK572WOg0VTagNuPlXoliKyc8taAENzqiTI8RFjU6e+fKa8o+k08bAaNGq61VBFd6wTgse6Y5E8LTMsn8ycNSneqPIVbgkyHlCM8+yr0LhrHW2fKhl2I7E9MDmOfs1o+HInxDiOWO9bLCga5dYqP8FgnQyINXrsE450KK0TK37p7HEtM6qWdHP9KfhYjEVzjPRHAsy6tZii7D/AECafw31aBRwIFx1BUc+rBqQPDwOdjoCekqXpawr6kFviwKZRv1z++ZzKCiRePA1JxETQ/G0gGz7+HWsE3557vuATuRzM/hB0NkD+NJOgvkaFj30+hVhFKuktsFT3XXK3CSgzaJFoIQfFxlVgMtkBgU2W959lvMyR8eGVKfLsUwITB3kIMcuzJrRqMpr1yKa7usxouo65VToQpy0Me30f1TiBgfPdrZrAi3Eh8JIQSL14kqohC/2qMQ4cpRWoaWspHNMuOfu15CYq65kOIyAECBMp6zQmTYLiM1qJpYqqDPXzxXgEEigXxnIq0b0t/iRsYna0JJYvn2ao6qx8br4i7uCZ2ZcATLFQgPlbretEAlNLyrlqEYpY0w0GSAnvpkmEmwVq+n72LVMxc4h5YeDh1yz3hiN+sw/vScYWGLMix2JQPiv4niWpKbJ9oT6WH3hjYrs7sFFo7ICVwrHHj9a4Vfdr9yqfGOAkPusjF2KSSD3aMCIi3jLXP5jbdUFF35/UDxGTmPIeYlOY7ELA/OvNOH0lO/Ne6kE+fTSoVucZS+o1q
 ebgsK6Ix
 tKAkEyOFk+HPfXaeH4fgjTq8Tam7miXEaTLX09dk8CuCOZ+yUND2wiynXU8a5IbC0kZx28IQmApdEQzulFawnF06gKER1DpviJ9psG+kBaNqkjXWaVuxXOKXrh3KIrw0pLgzVdATuLuYIME1UDqhw6wf4v68zUl2hJKoWUy0jZrsU3Bh+swdGuu/dxAlK4uCHE7JR2B1PwP1b1lGfW4R+XgmCYoMTv3q4HELDKQFC2vtbUm68KkxTzVHItEn3IpB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 09:15, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> Here is the hierarchical percpu counters series rebased on top of
> v7.2-rc2. It includes small bootup fixes which were needed to fix
> bootup sequence on specific architectures, and a rename of the
> test config option to include "KUNIT_".
> 
> This aims at replacing the prior version of the series you had
> in mm.
> 
> As a reminder, the goal here is to provide more precise RSS counters
> through /proc.

Hello,

Just a gentle ping for feedback whenever it's convenient.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> Mathieu Desnoyers (6):
>    lib: introduce hierarchical per-cpu counters
>    lib: test hierarchical per-cpu counters
>    mm: improve RSS counter approximation accuracy for proc interfaces
>    mm: reorder mm_struct flexible array to place mm_cpumask first
>    init: move percpu_counter_tree_subsystem_init() earlier in boot
>    lib: inline percpu_counter_tree_items_size with boot-safety sentinel
> 
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Martin Liu <liumartin@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: christian.koenig@amd.com
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Cc: David Carlier <devnexen@gmail.com>
> Cc: Josh Law <objecting@objecting.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
>   .../core-api/percpu-counter-tree.rst          |  75 ++
>   include/linux/mm.h                            |  20 +-
>   include/linux/mm_types.h                      |  65 +-
>   include/linux/percpu_counter_tree.h           | 387 ++++++++++
>   include/trace/events/kmem.h                   |   2 +-
>   init/main.c                                   |   2 +
>   kernel/fork.c                                 |  24 +-
>   lib/Kconfig                                   |  12 +
>   lib/Makefile                                  |   1 +
>   lib/percpu_counter_tree.c                     | 694 ++++++++++++++++++
>   lib/tests/Makefile                            |   2 +
>   lib/tests/percpu_counter_tree_kunit.c         | 399 ++++++++++
>   12 files changed, 1651 insertions(+), 32 deletions(-)
>   create mode 100644 Documentation/core-api/percpu-counter-tree.rst
>   create mode 100644 include/linux/percpu_counter_tree.h
>   create mode 100644 lib/percpu_counter_tree.c
>   create mode 100644 lib/tests/percpu_counter_tree_kunit.c
> 


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

