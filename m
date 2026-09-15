Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93344C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A963C6B0092; Tue, 15 Sep 2026 13:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E3C6B0096; Tue, 15 Sep 2026 13:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9361A6B0098; Tue, 15 Sep 2026 13:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4416B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:59:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8959404E3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:59:29 +0000 (UTC)
X-FDA: 85216758858.13.C1B960A
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021107.outbound.protection.outlook.com [40.107.192.107])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3D0D180002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:59:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=jpu4L9K+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.107 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789495167;
	b=P/VkFrpQKqdpP5o6cHrS+PsQT/T/TYaMuRmKVgfsXzFn44wdQBl3Yqi+sO3SeZXpubSkby
	LyJR97VgyrsZGvriOgpglA7U0h2wJsV3Mxg0USZmGypISd3caIUbs8xrUYcGeoIYX4102J
	k6zl+lR/0NYM9gZ31E2vZxPRtj6iH6M=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=jpu4L9K+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.107 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789495167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gFms8gSvxuMp6rKHYTHNgqoSPKYV4YypQCV8Xi7628=;
	b=dOqPyvBCWx1yZbOY4i1gpYK0mrCXo50nYL4dzOCCKoS7lEsc55fTj305+YwXTfluA7aHfc
	ASBwTfLgBOhZz4iDQa6QJPQvk8xRQm3WJ0PYecS4Idb4fFexdsQrr4WXCuV3/CMbggh658
	sQHehVZilZtLEv2UY2eJ6T/PjNdoevQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NliOlUvXBrH7vRgWvk0pPW+Ueb8LK4uOUuKAAk/yxT4h6OX4ulMk6nQToWTfMetVqY+44AISU3H4HcTycIaFen8rW8nY+HVmdJ8nhL6mUGRY25eZU97wb0r0pTQeLtG7dIpZW6AqwT93gkepiXYbAvIZdmf4jJn7uUjYuEpQMXRVVEN0qDPT/Tj9RZ66Z0QJjc7iCBtFmuGMmBy10KV191QvVc4GPHbeFcsTViPupX4KZvwcWJKc21qikXFi2vOKneyxc6AfIQ4NEdPSlGKoa2E+EXxLYju1rQWwkzbugsgW+7WsrOTM420Vo8s9JmKrR0AaH2a7llMLF+BbKz/CWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gFms8gSvxuMp6rKHYTHNgqoSPKYV4YypQCV8Xi7628=;
 b=PwX9mPGCXmmNs8dsIK4GKPYNmTk3yUcqfSLdAUEViyVu7SvFEDVwHMygkj/Q8qbejgOI6Kb9kXvm5b5FJil8e0dPCkHMNfM4X6K5ug5zCBlQaYQRK98GMBgN9t9P0iyf5pgakV1oGfra3Hg58p2cPViZpaQF2bEcDI92iB1+wAUEDeDkC0uHJrESQymRpWzhSgv6HvLfq/uu5JKCalZHrQZXgIexhTNGiJcdu3WNJ2Rh2aTg22fqx3DBx9JTdeoAkWd0XyPVrKS8gOGxAdzdaDJnyBbTQMZPILVdVPqTlzijXrvQHrrw9L7zspJifD2STkiT6hVtSmvmv1zQhpjMpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gFms8gSvxuMp6rKHYTHNgqoSPKYV4YypQCV8Xi7628=;
 b=jpu4L9K+qL/5HyMOhS37Pvo4/+VlkBJvurWszjg7JLWsaWH02ClB/yiJJjkM6zrCW/5Yird3GcRL6IRzqRPOflRlT24hmj3ZNSHqxo1ZBAa7wc3GifIhXk3xfpHFrUe4opItRbSYUKKVSApwdBt9AIqoT0SoZxST2Z/XAb7RERufyj0qmJHoHRdn7jMLAJqHX5K/HE32HBrLtFER9pTrfHWzKCkFnn+P73JhFe93GVX0ktnyGpH51/gZcIPAw4bBbC5FUhZ3/r2P2hDEPZPkSbZuDX+QArrPRgCxUw0dwQ207/A+n7lyM4xFB8Vc/aGDhC89bPIdaUGIAkGBL//Weg==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT5PR01MB107174.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1b7::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 17:59:23 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 17:59:23 +0000
Message-ID: <604b7546-31ce-4a9a-b2d6-f0895c745378@efficios.com>
Date: Tue, 15 Sep 2026 13:59:21 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 1/6] lib: introduce hierarchical per-cpu counters
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
 <f576b7d8-d8d5-4ecf-8663-015c159e6146@efficios.com>
Content-Language: en-US
In-Reply-To: <f576b7d8-d8d5-4ecf-8663-015c159e6146@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0204.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::12) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT5PR01MB107174:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd7c8ab-7997-41a3-e3d4-08df135312d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|18002099003|22082099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	9smACpxFtOc++IkJ2dXCtXY8psIeqFWoIPOjY/FevJBvjig2jlG+cfLYlcc82wfdMK6tIRz2QUqJ7epM5xp8VkUi4M3eqiTUM0HBIIcGVxL6xTq4l7YPS5FJ+OfhlaLXCdVwV7wX5kWkZeAUDvJrTUnuql2HzBu9fcGe1jTp5gAF+zvKf6KC5Fy53vAe+9Im/TSKh9OE/xIa1fUZQzakEFx6PaIR5MyUqI1JtQ0cK3va586E9cOMVcj9QBWziNMbXzagTuz0MrPnOqNamM1coztkp2SgMYmlkgDUmv+KtxscXwlVCEYnJylW0DEUJoVDJIUrLLPfycwpEgUXRkOpMRPw1EAz3xAwM7syi8bgRlOv7/F39ixJJWiTnvQlGCtxS1ddgYt/Tpx+uNDc+WuPaWZXMWmxP90cCNnhOxRvaZCESypY1WUMT5z2ENi7/tdV54ozp+fKgYRkVteiaDAWZVheARVrMKRxrue8fDPRFOwMCbeyAR0pOE1M2GVVYW/U8c2OZZRMW4l9sjhgvZ5jW8Kd+7MdTh2vC3oeow6zNE+d/Q6CVy3PuBue39VuajpLaeRdJWlkwksS5GRfHv16FPMlfsLRHjned0LtkfWwx3g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1VMZjNSQksyZFphTGZqRjVGWjRwRGVJTURJTGpNSDNocG15M3NIYXNkdjdW?=
 =?utf-8?B?YUFqcVdudUZRUmlTSk94TGVkcHFIdFFMVU5PNWVaS2s2aVZCZWx3dU1BSDZ1?=
 =?utf-8?B?NUdBOENFTmo0Ym8yazk2eFR2VmFVTkhYdG9vRVNJcjM1OTZpMWVzOHZWSkJP?=
 =?utf-8?B?L2JrTEdGa1NTV3Z6NWJGUHhETG56Qm1VUlV2SEdQQThsVUh1ZDUvTEdCZURl?=
 =?utf-8?B?VlNZOUFVd0RTWWgvK2ZENDBUYUZQVGlERFFGa3RCVzZxWjFuM0VMVmoyREJo?=
 =?utf-8?B?QkZCZk5iakk0eVdaTUtYdlc0WGRGeThVRzk0L3FFaDJ0RjdSaEZFeUl6azcy?=
 =?utf-8?B?S2JhWk05c1FrV3NrdTkwYzdJcVBCRms4a1JzOWVqQTVFdk91RHdqWFBUanMx?=
 =?utf-8?B?L1VDMk96T0w4MWxtNVNleHBIU2w0QjMvbGVBSFB2ZlBianZ1N0V5R0s2OC85?=
 =?utf-8?B?TCtlMVlTTTRHYjBWaGlqTmJ1cU5ycU5UT0pjZnZJeC95eG1OeFp1TFZubE1U?=
 =?utf-8?B?dG9LbStRa3M2YlEwWGdmd2svVGI4S0ZjQlZJdXkyY0gvd2pqTkxrOWdzZitD?=
 =?utf-8?B?S09hc2JBRUhjWUk4OHdTUytoSVNSa2lvenlKcFNIRnk5N01UWHJray9JVkhD?=
 =?utf-8?B?Q0JRWDIrRVNUMXNhMzNXOUtBS1dVVllOZFBnRHYweDFKNEdaVzB3cEpwRGdI?=
 =?utf-8?B?OE5jbkpWWDI2M1dBWnlPMG9WSXRRUUs3KzYzVTB4aFltMGlyeTZNUThQNVRn?=
 =?utf-8?B?d0w2Z0poM0hnT202RnNPQXhEcGFuZytFNFhkeWdFRXpaaThYdG16THR1SWJt?=
 =?utf-8?B?VXZudEh0cFdPWm9pYjhEelA1MnF6WmdZOCtEY1ZCbi9NVUxvNWhqWkoxckxC?=
 =?utf-8?B?Zi94UHI3QmV6bllEOUp5b1NuRHF0R0R0bFlhK2dCeklFTlRmVDBkRmVVQXNP?=
 =?utf-8?B?VWV1UVJNV2dNdmw1am82ZmQxTUNtUnZIMU9taHlPR0lPZVFqeTZ5Sm9sUjZ4?=
 =?utf-8?B?b1VLLzBUSi9vd2NZV1BWMm56R2piQytVK2RmUDRteSt5TVVrT2RLUlkxVFdP?=
 =?utf-8?B?Z3dVdnBJU3ptZnphaUxYeUdPRUJraUdxallXRHovemx3ekhZcWgyZEFVcXhl?=
 =?utf-8?B?b0FJTmJOenZMNTk3YlNteExBbERCWmx1TzBNUVMwSXp4OHlmcUpoRFQzR2xF?=
 =?utf-8?B?bTRBNTRzbGdLREVRcEtkSjJMOG4zUWhyR1AxMHdSVnhUcmY3dDNtYVVOaFFY?=
 =?utf-8?B?aHdEY2hlRzZGVlQ5ditsVkE5bDlydkVmQ3JnbmliSE00eSswVk5tU2dRSkNn?=
 =?utf-8?B?UTJLR2xzakxqUTZueWh4dCtTWncyRkg4dUNQNE5TQys4OFJqQnVBeElLbHov?=
 =?utf-8?B?enp3ZlJReXBDdlVxdi9WaVdOQWY3WTlSdSt3K1A1K0ZROWFZKzlIa2QxOXpM?=
 =?utf-8?B?OVJ4R2lTS1h2T2I1WDZ4L2k0NTJiZFhPZk5JREVGM0RFenowMEJtVTZQRnRY?=
 =?utf-8?B?aWcrNW45K0JLZ1JSR2lYNEtObVFJckJRazVkY0dza2U4RUIyK3NrbGUyY2Zr?=
 =?utf-8?B?THhpdnZOMHVZVldUMlJVbTJpUTdTSWRWZlBINCtTaUxGMFNxY1luM3hSaGM1?=
 =?utf-8?B?OFJUeXJHOFV1TmdsZmhTOHhUU1BjN1QyTU5pR2hFWGVCTm5aamR2aVc2QldS?=
 =?utf-8?B?RTRuREhDNjVhdUhZY2UzTnRWNWI1WFdScEJuT201aVcrV3pqdVZEVDlBTlho?=
 =?utf-8?B?VEJjR0l1NnRRNERmRmlEekY3eWI0S25lWHFyZFFzWm9tcDlTKzdzVitDOG9M?=
 =?utf-8?B?Y0RHTWJJNUUrTjAyeHNqZ01wcE8rQmZKVXNkVW1RTE54TGtYNGFjOTV4cXhl?=
 =?utf-8?B?MEhrSFFMbXFKeUJDVG5RUmNweFRjOUVrUzMwU0dGMHRvR2xqT3lhbHpoYkgz?=
 =?utf-8?B?R0N6Z0s3bklJam1YUHc1bTlzTHBNN1lyemhjZGdqSVBYQjVpNGVYSC8wZkFR?=
 =?utf-8?B?aVhhMnYyd3ZRVUorUjhzZUwxNVZpalRUUWdUYXV5SmhobzBub2JiaFg1VTJL?=
 =?utf-8?B?Nm54SUVGbEhTQkZDbWJBWkdZa1dwUlV4SEtLaEtwVm91aXJRRG9HN1JrODQ4?=
 =?utf-8?B?TGxUek9uQWJXSEluR2Zma1NNTTV0ais1R3RCc2J3ZXlCbDQ5L3YzSDFlVVBN?=
 =?utf-8?B?TXpCZlFkNlV5REZxTERYc1M0TXVxUFc2czVRNndhWFJGTklrQ3lFUzdvMy9n?=
 =?utf-8?B?VnpUWTJKZDA1REFMRU8wUFBLaVQzSysrTnplVS95dzRnRHpYeTRoNGZQME44?=
 =?utf-8?B?cnFSQjQyOGthZXQxM2ordVFxa0s3VFlXN2NDSU85TmZGbExkNjJObys3ckk2?=
 =?utf-8?Q?DM4OQ3mM2UvvDlx4=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd7c8ab-7997-41a3-e3d4-08df135312d1
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 17:59:22.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcYdn/OwFitv5lHH/X/3b+av9XDCPbGxkteZxhkQYX6wOQ2GSX80aGGebhuJp/br1F0zXe1nDpjUVouOWMThM4GfnOd8yWPXsU0y9zVJWuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB107174
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C3D0D180002
X-Stat-Signature: ufaegr9j5srajz1fnhztknnwczaf5bkg
X-Rspam-User: 
X-HE-Tag: 1789495166-915307
X-HE-Meta: U2FsdGVkX19x/oqdqXv7sP5vgmpICnSMiAPTnNBaPBqvY3g0VnqZ7tNl3mb3OtTyA38imqxe1Q1c9xWVyBLrxBtpF9Ej/wXD4Clsx6m/yUmMai6DZWVy/hJ8oWIfNt42euDr8B7i4Zo5mSgnHw/WY7n++E/ENDcQx9QZpMzzh8G/qUsPWnQfAUbcwvlrT5BsrBFrS41qfPefpsnRvuNT8q/iosNs/6oc+7uQN/cDSt//EK1a8sPd2/yq8Ocu8iqYsjZQdKSInca6UStHIsbwxafXEeMHR8+qgqvV2HwijN94WYA5X72vu2VUC5r4s+/2LVdEFpBP4IWYaRZ2ZLlt4beGNtSk/jdVKou50h07eb4z2+2e8K5ogrulnMG3rJkhfxgjhwiUX5iMhbp+yS4GvsLe/4j19T21Aa7VcVJnbZzlgscdhonxYhWuwT+lIhCe4sbr8x5jbNe68JRiVs92GW0ha5BsIa1eXz5Gl+iX6pvapdlP996bsmkxYgGKg6fRwFlKcxRzAtPsi8KUyxz9ax94WA3GgPGGesExqb8Zt4ytSM3VOXrPra2ChEAIujuN8l7bz1De6LnKBLGg0md4YgfH7KlxAoQa2evvouKoTK6H5vHqLCU2omzdW6DoSM61XnteT0hd96wfe7ZiZlMqLGNJIRmC2nUOzWzUdGuqyG08/o62FPcp5NTTy7nAWAJlsMjoCXNhobIEkk51ZxW1bh/D1NapcOqirGsfsm16/xnBTru2myxpX4RR14+yz7PEL410qFwcnEO0qeA0IkfmE/M36O6Z48rsBm3SYShx/QZtqsuP4jpfVYOpZCYTXuLBqA56Cypcvr+uITDTXAM0ql3h8j4kSXHi9CJGmuaNPfIGd+8VhrLcbk6gHrtRQFo0q10r5FDuW419NMvhhfxWrrA3W7vs80BMYoQYFV1Y9JCNX7ftGSS8KOsMPQrn2bo9HgJG31QEAAVTaF1sOYO
 lWF2Tc3J
 4wuQMcI2XLqwu/w7vomazvYYS3wVLqBGShDn1aqsCVvdrfEdj0zDx1x4s14sTXQ3gJYbc5CaLREG1rCvPm7y2DPZv9s+xGz0JFwQAEV+WY36dtqAp0XUUP0zx/g934SvyC4khsm7xLMWm+m97LDBOL2WBxQ3Qk08oaEN7XwaimY+vYMVrRtzzXJX3ukK/TTPEOuzZ6PXSSiudUOp4UXLIavUXlvL18AAZou8zdrbLt7Umyco7Pb+dKWTjECkdm9bLG1KQsbBNfp3rjpHdB1CVsAyAh0uMi+oyTLyOrxK4T/+HjtiUno+5QdKbKBRSAe4BsXhdxNDTmfmnSs95k4dDJ8NJrkebFoByTMMoJPpO9N1FbWL4tAl0uujq6s9iBs/n0/xEXOQDPtpwpop23Kx1Ky2kUgKOWwikNldgR+OZ1f5VPasA5Nuygm5ikmWA+MlWR023hc1VLAUsu8TDV7LsgYMz7UHKAGzqKQOrB8GMZzj+8JDsdQphTSgAu02PNW13hzadus499GSS1ycIcn5PE38f81ux67gM+aJDEGG/7r37PvNWj9CjEeABVJEFpUPS7YMXN30euMkwufw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-11 12:30, Mathieu Desnoyers wrote:
> On 2026-09-10 08:24, David Hildenbrand (Arm) wrote:
> [...]
>>> diff --git a/include/linux/percpu_counter_tree.h b/include/linux/ 
>>> percpu_counter_tree.h
>>> new file mode 100644
>>> index 000000000000..828c763edd4a
>>> --- /dev/null
>>> +++ b/include/linux/percpu_counter_tree.h
>>> @@ -0,0 +1,367 @@
>>> +/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
>>> +/* SPDX-FileCopyrightText: 2025 Mathieu Desnoyers 
>>> <mathieu.desnoyers@efficios.com> */
>>> +
>>> +#ifndef _PERCPU_COUNTER_TREE_H
>>> +#define _PERCPU_COUNTER_TREE_H
>>> +
>>> +#include <linux/preempt.h>
>>> +#include <linux/atomic.h>
>>> +#include <linux/percpu.h>
>>> +
>>> +#ifdef CONFIG_SMP
>>> +
>>
>> Would it be possible to document here how these values are determined?

Do you consider this a blocker for integrating the series into mm
for testing ? This has been repeatedly postponed from rc1 to rc1 for
many cycles now.

Thanks,

Mathieu

> 
> Those come from lib/percpu_counter_tree.c:
> 
> static const struct counter_config per_nr_cpu_order_config[] = {
>          [0] =   { .nr_items = 0,        .nr_levels = 
> 0,         .n_arity_order = { 0 } },
>          [1] =   { .nr_items = 1,        .nr_levels = 
> 1,         .n_arity_order = { 1 } },
>          [2] =   { .nr_items = 3,        .nr_levels = 
> 2,         .n_arity_order = { 1, 1 } },
>          [3] =   { .nr_items = 7,        .nr_levels = 
> 3,         .n_arity_order = { 1, 1, 1 } },
>          [4] =   { .nr_items = 7,        .nr_levels = 
> 3,         .n_arity_order = { 2, 1, 1 } },
>          [5] =   { .nr_items = 11,       .nr_levels = 
> 3,         .n_arity_order = { 2, 2, 1 } },
>          [6] =   { .nr_items = 21,       .nr_levels = 
> 3,         .n_arity_order = { 2, 2, 2 } },
>          [7] =   { .nr_items = 21,       .nr_levels = 
> 3,         .n_arity_order = { 3, 2, 2 } },
>          [8] =   { .nr_items = 37,       .nr_levels = 
> 3,         .n_arity_order = { 3, 3, 2 } },
>          [9] =   { .nr_items = 73,       .nr_levels = 
> 3,         .n_arity_order = { 3, 3, 3 } },
>          [10] =  { .nr_items = 149,      .nr_levels = 
> 4,         .n_arity_order = { 3, 3, 2, 2 } },
>          [11] =  { .nr_items = 293,      .nr_levels = 
> 4,         .n_arity_order = { 3, 3, 3, 2 } },
>          [12] =  { .nr_items = 585,      .nr_levels = 
> 4,         .n_arity_order = { 3, 3, 3, 3 } },
>          [13] =  { .nr_items = 1173,     .nr_levels = 
> 5,         .n_arity_order = { 3, 3, 3, 2, 2 } },
>          [14] =  { .nr_items = 2341,     .nr_levels = 
> 5,         .n_arity_order = { 3, 3, 3, 3, 2 } },
>          [15] =  { .nr_items = 4681,     .nr_levels = 
> 5,         .n_arity_order = { 3, 3, 3, 3, 3 } },
>          [16] =  { .nr_items = 4681,     .nr_levels = 
> 5,         .n_arity_order = { 4, 3, 3, 3, 3 } },
>          [17] =  { .nr_items = 8777,     .nr_levels = 
> 5,         .n_arity_order = { 4, 4, 3, 3, 3 } },
>          [18] =  { .nr_items = 17481,    .nr_levels = 
> 5,         .n_arity_order = { 4, 4, 4, 3, 3 } },
>          [19] =  { .nr_items = 34953,    .nr_levels = 
> 5,         .n_arity_order = { 4, 4, 4, 4, 3 } },
>          [20] =  { .nr_items = 69905,    .nr_levels = 
> 5,         .n_arity_order = { 4, 4, 4, 4, 4 } },
> };
> 
> Currently they need to be kept in sync manually between the public header
> and the implementation, which is error prone. I should do something 
> about that.
> 
> Note that the nr_levels and n_arity_order are only used within the 
> implementation,
> so ideally we would only have the nr_items values in the public header, 
> not the
> rest.
> 
> Those values are calculated by calculating the number of items needed 
> for the tree
> hierarchy of a given topology, excluding level 0. For instance with 8 
> (2^3) CPUs:
> 
>   * Level 0:  0    1    2    3    4    5    6    7
>   *           |   /     |   /     |   /     |   /
>   *           |  /      |  /      |  /      |  /
>   *           | /       | /       | /       | /
>   * Level 1:  0         1         2         3
>   *           |       /           |       /
>   *           |    /              |    /
>   *           | /                 | /
>   * Level 2:  0                   1
>   *           |               /
>   *           |         /
>   *           |   /
>   * Level 3:  0
> 
> we need 4 items at level 1, 2 at level 2, and 1 at level 3, for a total 
> of 7.
> 
>>
>> Without that, ...
>>
>>> +#if NR_CPUS == (1U << 0)
>>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS    0
>>> +#elif NR_CPUS <= (1U << 1)
>>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS    1
>>> +#elif NR_CPUS <= (1U << 2)
>>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS    3
>>> +#elif NR_CPUS <= (1U << 3)
>>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS    7
>>> +#elif NR_CPUS <= (1U << 4)
>>> +# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS    7
>>
>> ... I'm confused why two separate statements share the same number.
> 
> This is because both 2^3 and 2^4 have 3 levels, but the fan-out changes. 
> We go from:
> 
> { 1, 1, 1 }
> to
> { 2, 1, 1 }
> 
> so even though we have twice the number of CPUs, the number of items is 
> the same
> because the fan-out of level 0 went from 2^1=2 to 2^2=4 (it doubled as 
> well).
> 
>> (should we simply drop the "elif NR_CPUS <= (1U << 3)" in that case?)
> 
> We should, it's indeed redundant. I kept it to have a 1 to 1 mapping 
> with the
> static const table, but if we introduce a compile-time check that they 
> match
> dropping it is not an issue.
> 
>> I do wonder whether there is an (easy) way to encode this into a 
>> formula. I
>> assume you tried and it got too hairy :)
> 
> generating it with a formula gets quickly complex in a way that makes it
> tricky to review.
> 
> Something like the trick below would allow us to make sure the values match
> between the public header and the implementation, which where I think we'd
> really need validation:
> 
> * Public header:
> 
> /* Number of inner nodes for a tree covering @nr_cpus CPUs, -1 if 
> unsupported. */
> #define __PERCPU_COUNTER_TREE_NR_ITEMS(nr_cpus)        \
>      ((nr_cpus) <= (1U << 0)  ? 0     :        \
>       (nr_cpus) <= (1U << 1)  ? 1     :        \
>       (nr_cpus) <= (1U << 2)  ? 3     :        \
>       (nr_cpus) <= (1U << 4)  ? 7     :        \
>       (nr_cpus) <= (1U << 5)  ? 11    :        \
>       (nr_cpus) <= (1U << 7)  ? 21    :        \
>       (nr_cpus) <= (1U << 8)  ? 37    :        \
>       (nr_cpus) <= (1U << 9)  ? 73    :        \
>       (nr_cpus) <= (1U << 10) ? 149   :        \
>       (nr_cpus) <= (1U << 11) ? 293   :        \
>       (nr_cpus) <= (1U << 12) ? 585   :        \
>       (nr_cpus) <= (1U << 13) ? 1173  :        \
>       (nr_cpus) <= (1U << 14) ? 2341  :        \
>       (nr_cpus) <= (1U << 16) ? 4681  :        \
>       (nr_cpus) <= (1U << 17) ? 8777  :        \
>       (nr_cpus) <= (1U << 18) ? 17481 :        \
>       (nr_cpus) <= (1U << 19) ? 34953 :        \
>       (nr_cpus) <= (1U << 20) ? 69905 : -1)
> 
> #define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS        \
>      __PERCPU_COUNTER_TREE_NR_ITEMS(NR_CPUS)
> 
> #if PERCPU_COUNTER_TREE_STATIC_NR_ITEMS < 0
> # error "Unsupported number of CPUs."
> #endif
> 
> * Implementation:
> 
> /*
>   * X(order, nr_levels, ARITY(arity order per level, leaf level first))
>   * Row "order" covers nr_cpus <= 2^order. nr_items comes from the public
>   * header and is checked against nr_levels and ARITY() below.
>   */
> #define PERCPU_COUNTER_TREE_CONFIGS(X)            \
>      X( 0, 0, ARITY())                \
>      X( 1, 1, ARITY(1))                \
>      X( 2, 2, ARITY(1, 1))                \
>      X( 3, 3, ARITY(1, 1, 1))            \
>      X( 4, 3, ARITY(2, 1, 1))            \
>      X( 5, 3, ARITY(2, 2, 1))            \
>      X( 6, 3, ARITY(2, 2, 2))            \
>      X( 7, 3, ARITY(3, 2, 2))            \
>      X( 8, 3, ARITY(3, 3, 2))            \
>      X( 9, 3, ARITY(3, 3, 3))            \
>      X(10, 4, ARITY(3, 3, 2, 2))            \
>      X(11, 4, ARITY(3, 3, 3, 2))            \
>      X(12, 4, ARITY(3, 3, 3, 3))            \
>      X(13, 5, ARITY(3, 3, 3, 2, 2))            \
>      X(14, 5, ARITY(3, 3, 3, 3, 2))            \
>      X(15, 5, ARITY(3, 3, 3, 3, 3))            \
>      X(16, 5, ARITY(4, 3, 3, 3, 3))            \
>      X(17, 5, ARITY(4, 4, 3, 3, 3))            \
>      X(18, 5, ARITY(4, 4, 4, 3, 3))            \
>      X(19, 5, ARITY(4, 4, 4, 4, 3))            \
>      X(20, 5, ARITY(4, 4, 4, 4, 4))
> 
> /*
>   * ARITY() is never defined: consumers paste a prefix onto it, so that
>   * __PCT_LIST_##arity turns ARITY(3, 2, 2) into __PCT_LIST_ARITY(3, 2, 2).
>   */
> #define __PCT_LIST_ARITY(...)    __VA_ARGS__
> /* Pad to COUNTER_TREE_MAX_LEVELS (5) entries; "+ 0" keeps ARITY() 
> valid. */
> #define __PCT_PAD_ARITY(...)    __PCT_PAD_(__VA_ARGS__ + 0, 0, 0, 0, 0, 0)
> #define __PCT_PAD_(a0, a1, a2, a3, a4, ...)    a0, a1, a2, a3, a4
> 
> #define __PCT_NR_ITEMS(order)    __PERCPU_COUNTER_TREE_NR_ITEMS(1U << 
> (order))
> 
> #define __PCT_CONFIG(order, levels, arity)                \
>      [order] = { .nr_items = __PCT_NR_ITEMS(order),            \
>              .nr_levels = (levels),                \
>              .n_arity_order = { __PCT_LIST_##arity } },
> 
> static const struct counter_config per_nr_cpu_order_config[] = {
>      PERCPU_COUNTER_TREE_CONFIGS(__PCT_CONFIG)
> };
> 
> #define __PCT_CALL(m, ...)    m(__VA_ARGS__)
> #define __PCT_SUM(a0, a1, a2, a3, a4)    (a0 + a1 + a2 + a3 + a4)
> 
> /* Inner nodes at level @j (1 = parents of the per-CPU counters). */
> #define __PCT_LVL(j, order, levels, sum)            \
>      ((j) <= (levels) ? 1U << ((order) - (sum)) : 0U)
> 
> #define __PCT_ITEMS(order, levels, a0, a1, a2, a3, a4)        \
>      (__PCT_LVL(1, order, levels, a0) +            \
>       __PCT_LVL(2, order, levels, a0 + a1) +            \
>       __PCT_LVL(3, order, levels, a0 + a1 + a2) +        \
>       __PCT_LVL(4, order, levels, a0 + a1 + a2 + a3) +    \
>       __PCT_LVL(5, order, levels, a0 + a1 + a2 + a3 + a4))
> 
> #define __PCT_CHECK_ROW(order, levels, arity)                    \
>      static_assert((levels) <= COUNTER_TREE_MAX_LEVELS,            \
>          "percpu_counter_tree: order " #order ": too many levels");    \
>      static_assert(__PCT_CALL(__PCT_SUM, __PCT_PAD_##arity) == 
> (order),    \
>          "percpu_counter_tree: order " #order ": arity orders do not sum 
> to order"); \
>      static_assert(__PCT_CALL(__PCT_ITEMS, order, levels,            \
>                   __PCT_PAD_##arity) == __PCT_NR_ITEMS(order),    \
>          "percpu_counter_tree: order " #order ": nr_items does not match 
> levels/arities"); \
>      static_assert(__PERCPU_COUNTER_TREE_NR_ITEMS((1U << (order)) / 2) 
> <=    \
>                __PCT_NR_ITEMS(order),                    \
>          "percpu_counter_tree: order " #order ": nr_items not monotonic");
> 
> PERCPU_COUNTER_TREE_CONFIGS(__PCT_CHECK_ROW)
> 
> One alternative would be to derive the public header nr items from a 
> formula, e.g.:
> 
> enum {
>      __PCT_ORDER  = order_base_2(NR_CPUS),
>      /* at most 8-ary per level while that fits in 3..5 levels */
>      __PCT_LEVELS = MIN(5, MAX(MIN(__PCT_ORDER, 3),
>                    DIV_ROUND_UP(__PCT_ORDER, 3))),
>      __PCT_DIV    = MAX(__PCT_LEVELS, 1),        /* avoid /0 for 1 CPU */
>      __PCT_BASE   = __PCT_ORDER / __PCT_DIV,        /* arity order per 
> level */
>      __PCT_EXTRA  = __PCT_ORDER % __PCT_DIV,        /* leaf-side levels 
> with +1 */
> };
> 
> /* Number of inner nodes at depth @k (root is depth 0). */
> #define __PCT_NODES(k)                            \
>      ((k) < __PCT_LEVELS ?                        \
>       1U << ((k) * __PCT_BASE +                    \
>          MAX(0, (k) - (__PCT_LEVELS - __PCT_EXTRA))) : 0)
> 
> #define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS                \
>      (__PCT_NODES(0) + __PCT_NODES(1) + __PCT_NODES(2) +        \
>       __PCT_NODES(3) + __PCT_NODES(4))
> 
> static_assert(NR_CPUS <= (1U << 20), "Unsupported number of CPUs.");
> 
> It's more compact, but it's also less straightforward to understand how 
> many
> items we end up with for a given order.
> 
> Any preference ?
> 
> Thanks,
> 
> Mathieu
> 


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

