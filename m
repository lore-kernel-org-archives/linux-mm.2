Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FA2CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934F76B008C; Mon, 22 Jun 2026 04:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CAB6B0092; Mon, 22 Jun 2026 04:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3B46B0093; Mon, 22 Jun 2026 04:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4338C6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:51:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B69561405FF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:51:32 +0000 (UTC)
X-FDA: 84906930024.26.12DEF0A
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD3928000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:51:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Oj464p5y;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.13 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782118290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1CTmu+6LGlgB/BKD81AcsdoGTuKCbZDkKyItYzOVJo=;
	b=s1zRlfQJ+Q8LQKV7MtA0cbXS8/2AzQ7WfrKc6gC4Lxi4vgi7Qw8NDOCRjkIc0h8jWQqu+4
	8jyZiY3F/S0MVdXhMm34h7gRxJeaqPg/ZD+yUbjuLrgm4ftApwNvaQ/HX/UnykeVoMP/4y
	k6cxTfzuKgDMUNJghEPdK8h0qnD2Ewg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Oj464p5y;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.13 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782118290;
	b=bf95EHRcRLNVjsxdrFCAuySkBdXGo+dOehLV2CiHcBB44Mv6ykHhbi69P5/RO8TZNxTMnB
	UbRqjfkqYCXaZqmNw6vMaUFM/1Cer4phZypjKRMvVPJVarh6ncxVGlTilAYeJtknMHgEWU
	6qCUIOENtNW5VYzpq8MrhGsDsAw4D/8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nwQEh21o2VSckybAsizVeLRP7aTQEFc4SNJ0W9rMBBl7zoo8WGU8Mc/X0VHZvDlOeUm8vF41TVCHv1zvIWYDnaDUneW/1gBrbztOfzufGEaqS3BE2IjU9VOKDAFNUxLIJAzJu8bR0hODDMG7+BBipKPx4k4TNZWBVZV2X9/zYZx+hU8+d+MHc9Zl4OfHM4/YvOkqJHtBbW3KoiD3Ei4h/9i542in/JhC/S32kgZ+nMScNTtScKx1142XpMQdnioZ2EEj3wXGBQVcLbI0P78AfMPJEtx7vknE/8Vhidz5f0DTraRsaZPFx2HSmEAD8FxRiJkcowwTYcqIiC1IcmTElw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1CTmu+6LGlgB/BKD81AcsdoGTuKCbZDkKyItYzOVJo=;
 b=v2BY7tj0h5oxjj5yjsfFWtN6tFLH1gBgks+WFLJ8PSOPB7aoNyAVL0vDPzKTPwTOrGmnSA7hQkXhi3bwmVz8vho6Sl8SMT3wr+E0jWH+MCC+yBqfbtDGMYbpdmEudGgvNcKe8wV+zzL5dGk+PzpFfNcTLxG71TbWPjnG+rUcJzlgQQXNn5zrlkRJzozVkLPbZcQwUq5yWwoQ9rlLYR2bxt64rKBWZg757AbAoP3JQbsp+9M+yU+avHJgkPUIpIUYzIMBfmAyfV6vCu5Jsntk6q8FjvoqJiaMMivEeQIQLtE4mjz3kF9snAu+26NgmnaEr3QD8xS9+ouPCxblF/ZSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1CTmu+6LGlgB/BKD81AcsdoGTuKCbZDkKyItYzOVJo=;
 b=Oj464p5yFx5WkTQKYW8C8t7LwqSVyT6K0+Eerw7lOm1sv/TNiWcQQ12aVmFPOGW8RHuWPAaEUnGLM0cm98TZ162SScfM2ZUYlKAxuSj/Opwr+nDe74rJojsk35fGlijgwwCpXUr1RSNLZCtfh/zo5Xq68aZg8LGT0MwX4rNmDvQ=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Mon, 22 Jun
 2026 08:51:25 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0113.015; Mon, 22 Jun 2026
 08:51:25 +0000
Message-ID: <4f55fc00-e83f-43a3-9dd3-739c75534b14@amd.com>
Date: Mon, 22 Jun 2026 10:51:10 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260622040533.29824-2-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA0PR12MB4365:EE_
X-MS-Office365-Filtering-Correlation-Id: f5843db8-2292-4c6f-6373-08ded03b7106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|921020|4143699003|6133799003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UrYmGbn8maWnHNc5D1qlVh+jrcQmrgStTdJf4BpRRFgI09yY0t5o3kI+QFue1RhDqmkyHpxlbNIsUyVgifZBOfhgqCKTMcjX995MBXWc20TEezTy5dAGaJra4KOqCesvs8RpPueT0jpnFEwuvTeS3ivGUM75dL6izUy8aZ5IA9mkAlRyUxcdmVBWoVuN3m3FQa1T1jMdGsfOLVZIi5pGVsHI8Vg00YPKD0qr5kXFjd/sNeinWHYCNkwR1HIcyfjeFoWuBJ0xuPLSv0ZQMLm4nUaJ6/fCgDfkZysVJyYCjdU7AXJ/tAW0o8wmQbWA4/AEwiC0MmyWuVg8HaSTBShQX4TNauMFcLGutmZSSNW077PQwIcEUnKRoW/FA0mQ7TkpSflOuOgzVUJFfXfRiduI5+807QLgLHM09PTDE2r9q9MOVMatD74eT2o1BBGRwrLLJolVQhYpkznZ9O6QMSF3KFOuL8uEA/nRzKJz9LorWYPkk5Z++5e8KmAoMQvJBwwh7V1k7jSq6csJb7X0EKS7JAjrpUsCe6Kd73jW5zEdBErveu3sVf1+ktIcyuDFF18B7xKsBEIP7CF6PAwdRDJuc8lNstT6A14JkeH+9nJwJTY7BI2jnUP7ZE282Y7U9nkglCXQ59yNkgS/WDdKg6jk3F4gDabH999DqevpnZFnlGpX921G6ifWu98iLl/S02N/shf0Me8MgGWkt8E+cGwGRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(921020)(4143699003)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azFEQUF2QnZLcC9OTzB6SkdoWk9zdXBGTHNqdVlzTWNaVWVTRHN1ZDVQQUpQ?=
 =?utf-8?B?UFdNTUhKZWxsd2hFTitYRmw2aTYvZW5sc08vZWdYeDdaaXdLdzBpWkZuUUFL?=
 =?utf-8?B?MDZWTVE3dzExbzNMQnBlTEt3RVN0Nk1aTjJEdlQzamhvRFU2SWgwVGVoUUNt?=
 =?utf-8?B?ZjJhQVBlVGZ2WkRtVHh6SzZHbHlPNUtJZEJKNDJTT3F1YkVZeGpCNjVmenVr?=
 =?utf-8?B?WGpXSW0rLzM1TThvQjBoRVBJNDlIQUsyK1M0TmRFNkphQWJCVzMrRWxGQnoz?=
 =?utf-8?B?VmptY1F4SXZkdTBrVjhMZmp4SmdVVkJKT09vQkVIOU91bXlZeEliZmFNYVdh?=
 =?utf-8?B?eVViOE5SVHdPVmVqaGdMSGs3MjMydVBmR3A1RFloL2llSmV1SFJIVERWQ1F3?=
 =?utf-8?B?RC84R2kyRHkwVjFzblY1RUZHRjN3aFhISi91VUQ4Uy9lc1RTMkRIK2JjR0VC?=
 =?utf-8?B?SDE0eSt3R2VBRm1TN09RdzcrTzB3by80Qy9DcG9acWZnRDFJanpObWh3NHlr?=
 =?utf-8?B?aGU5WVdCMUhNeEwreU5HNE8zQW5iZmltR2Jvd2FrYmN5M1JabExEMGtTby9U?=
 =?utf-8?B?TjJZaXpObGJxWmNrTWxYWGdZdUE1bHRLMVdCbUNCelR4MjI3OWJsVVp3aFBK?=
 =?utf-8?B?NzUvUU9Ia2NTb3N5VFZveWFPZVR2bkFSeUgxb3NzS0ZCeEdHRTRiMFJIN2xI?=
 =?utf-8?B?bjJyMFQrYTZFR3N0YlpXRE9VY3J4NVF3d0FLNnlITTZIcGk2ZnhFTDlzL3RO?=
 =?utf-8?B?QTBROFpwRjUwMTZFdW5QNW1VYmh0VUxoZi9LMnNtNTV2QmtWSXlqT3hKMlZS?=
 =?utf-8?B?UzY4aW51Q0kyMWZkaGY5MjB1VzdLTGw0MFVaYnZOcHVHKzFwT09xSXdqVU1U?=
 =?utf-8?B?R0dJWW5jR0RFc1JIMkVkM3lkS0JlanFUSWVwblQyTlZVV1BjUEVrbThjUXlY?=
 =?utf-8?B?ZHN6TjlrbFJrRDc2MklweWoyeFdFdmNVemRMejRQK0NINFlycFBnMVBzSmpM?=
 =?utf-8?B?L0RiNU1PZXloakd6VVVwVXNwTzA0aHZuMUNXOUpJQmlPakkrQWpTTVR4QTVC?=
 =?utf-8?B?YUk5VGVBM2d6ejdibE9YVjE3UFRVWFBXc09XeXVBMUQvYmE1Y0NXQ01VRWxI?=
 =?utf-8?B?QkFpcTQvTnpOMGZ1a3cxeFdhOSttME1LTVplUHc5RWJBWG4yREp5SmRUc0d4?=
 =?utf-8?B?ZWh6V3MxNXBWK0pWUFZ3b2hyazdOa2xvSEUrWnRsZjVWMHVQVGJ1WEhNeGNy?=
 =?utf-8?B?L01XSFhReWk5QmNFRTNLWjRmS1o1Rm9qMzNPenpGNHdYZS9oNjlha2g3MERW?=
 =?utf-8?B?cHc4cnI4QUpvN1FoSzZCQWJMNkVTWU9MU2hBcGZEM0hvMHM0cHc2RGtkQmVS?=
 =?utf-8?B?ajIxeHhKL0ZSMWJxN2YwTGdjVkJyM0J6eDBIZGhJTDVVejJrTnMyUlFmamI2?=
 =?utf-8?B?aWJUMm5QN0c1d1V1bm1oSCt6Mi82ZkZGcUx6aW85MGpVcDVUQkpHaTZqNFVW?=
 =?utf-8?B?cVBNYVVMNzd1T25kUWVhNWczTGxhV0hRZSswYjRFdVZSRlRRMDJkcElKclJD?=
 =?utf-8?B?bWdJQ00vdVFxbXZWYUhVTURmNUhTSVhONWRUbjFUaHdTd21UcDk0Nlpna0Z0?=
 =?utf-8?B?WEs5VlNvUC8vbjBFNTltMDVqNEZaY2tpRmcybmZvL20rRWtJRUZXTmVoRHVk?=
 =?utf-8?B?dGwzYVVoUDViSkxPeFJOR28wQ3N1YXNtdHlDTGtwZk5xbnFBTTFWaGtybWxM?=
 =?utf-8?B?REJnTTBFTnRydjhodnkwd3U4Ty9tdStqMDdjbUpIMjVQU0ZNUmIvaWN1d1pj?=
 =?utf-8?B?Q0JubWNkNUtPTExteUtRUUdUalpydUJDMXZHa3hMTERhWFFCZ0I3bTk4dnFV?=
 =?utf-8?B?YklhOXZ6MEtaUnhwUUMrOGtMOW1EWjBMZUl4K01YamZlZkFoOG8yNStHMERt?=
 =?utf-8?B?NWordldKV3lBTWVmVW1TWGtvRzh6YjhpZzV3L3h5aTJRMVB3YTdkWi9QZTVS?=
 =?utf-8?B?UHZaMUt2UUhsYk9XcEJmTE9neDFJRHpiSlhHR3dhWjd0SWJLUS83bVhyMEl6?=
 =?utf-8?B?U0RweUtUNHRYNis4TFhYNU94U1A0S2JabmIyQ29qWU5tUk55M1FadC9ZRU9T?=
 =?utf-8?B?NHlxM1E4aDF2RXYzd3ltOHlBeEVFUHp1REF2cUovemZ1aFJyVHFtdFE4WkR5?=
 =?utf-8?B?UGxUZ05XQWFsVE1FNEptYXV6akl3K0JEVU5EYVN2eXAwUEFtMjJ5RUdSd1hN?=
 =?utf-8?B?eVFRTzZNOHlHayt3ZGhXbEw3ZWl5SER6SlpOc2d1WG1IcVRhRzJCZEY2cmUw?=
 =?utf-8?Q?I/sExwDfVHkzWno0CT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5843db8-2292-4c6f-6373-08ded03b7106
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 08:51:25.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MyQthcf0k8t8V1QPq+PMD5vm3w+cwazXpSklvIukCqaryCgt6VPENiHsqHAftsLd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
X-Stat-Signature: ndcktj9fcnutwruoi811mybgk96nusoy
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD3928000C
X-Rspam-User: 
X-HE-Tag: 1782118289-740133
X-HE-Meta: U2FsdGVkX19JUKKwg6XunHg0aD1qoLwz7Z5A0AhMPRcENlmVlQYSVc/cOxWkQVwtaLX7ZKqr6n34Kd8nRM/CyQaL6bf3XE7j/kOJ2Kedqrt8DZaZuB9pwgNZeZDjiHy7jde5xzblk7G4jUEQuf9yLtM11r07NCCs0xMbbkGT2l2/S2UHJ5PLZzMpiWGQKTie+B07nS2K1dFeUHmlGDAzvJRC0TS/M4MJ821vwRP5lK/0u8Qza2cTF/PqGPRE3RBU95h/8wT6D06WM3ojdZW9IHMecmHeWZbDvqstfItclUjzaOBHkW+L5ui2RSbldMKn3RNvl+7spvzCjdENaIDZzdkmUeNUalPRTBZ5wObxc27UbXouFJe2qyJkotZB87OTUbvmanu6lHrAA3SIYs408CN6kYaraOD1mWfHUFqCroOjXLrOaTzoKOV2kl4NKjI9+dFlkPEc3q6erlhx/XHGRwt7x7F7BYKfuLjZWGItWcloJFSzGmIGbUXDTgjr1W1X8YWzBy5EjC//FD1+RZiHD4QdmzUgV5R4EBD5lBpt8GFQriAThzvtB7VBMJeqz6YcPqbt6u/EAQDldCD0PjJq1ULMRUwe5wawpune3hdid2SOMWyP+m+aW5xtssf6p04jybo91KAXNy1L3xNQbMJSz9jHdTrBHkpXplQmaKyGUvyhO02LhxF/SRmpkcj0xQM8o5Koe84AJvfsPJQLSHNQw/kC1V1glgqjzBmpk54VKNvNBtJ2gXrhDRQQS/gDIKfRkkLBeg2mfORwhvM3SvT0MDcITpvOEuEZ0OcuZq+jizyLttPI9JxC5W/Y8nJYdBR9kUTDNOzB2t8CPWkwOwFR63Woo8uIZ0/FedW/was4sLNmK0XD303HdU4o63TOx6KTVlHTOnsSWP5hF2zI6qezH0FIPU4Xfe1ApEqhlLevchfgkZ2y7FE5Bm3hMUz8LqcQ+UJGJ3ykYty5MUZTeJr
 5NjrsE22
 aRbPYvDy6d7lDki5opQIQ3LRuPYhty+fuhtOuwvwfYusM/dzH4H6tdjev+hxJAPOwW++7fI4wj6vWPIfP92Vfgg53LApnWRJVdXZV+ZQil9eKs+bOcIFjvYu4U9JV96L6Fj2eNAYuUODaU++sLlN0uCAVaMHeZYjH4Ce0KEs/5+s3PPkwCejS6jsH7Y0odAhuhOdxzccTOXBw82yWW8xp8herN3vq25YpcX6gsQ0ER22teAuNywkIJjUJzX9PrTG0I4AefnjLbZYoVYnNUFLpwW+YRxXMZ0hPbq+dB2+2bqCZNtM7sixU2twcBmqE08DeMh/gh58hrFZwCWSVBLl6WX8UpiTshGBKmk80Jg7SGfDAZzC/NlB4MwoGYsfZSpiMaiC+cLGPVVmoW6nxHVIpXnTCFBkiBXui1+hSVY9p5WPni8Oq2Wvl8hsjOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 06:05, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The list_for_each*_safe() helpers are used when the loop body may
> remove the current entry.  Their API exposes the temporary cursor at
> every call site, even though most users only need it for the iterator
> implementation and never reference it in the loop body.
> 
> Add *_mutable() variants for list and hlist iteration.  The new helpers
> support both forms: callers may keep passing an explicit temporary cursor
> when they need to inspect or reset it, or omit it and let the helper use
> a unique internal cursor.

That sounds like a bad idea to me. The macro should really be doing one job and that as best as it can.

> This makes call sites that only mutate the list through the current entry
> less noisy, while keeping the existing *_safe() helpers available for
> compatibility.

This can be perfectly used for code that which really needs the separate variable for the next entry.

Regards,
Christian.


> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 231 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 09d979976b3b..1081def7cea9 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -7,6 +7,7 @@
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
>  #include <linux/const.h>
> +#include <linux/args.h>
>  
>  #include <asm/barrier.h>
>  
> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_for_each_prev(pos, head) \
>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>  
> -/**
> - * list_for_each_safe - iterate over a list safe against removal of list entry
> - * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> +/*
> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>   */
>  #define list_for_each_safe(pos, n, head) \
>  	for (pos = (head)->next, n = pos->next; \
>  	     !list_is_head(pos, (head)); \
>  	     pos = n, n = pos->next)
>  
> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
> +	     !list_is_head(pos, (head));				\
> +	     pos = tmp, tmp = pos->next)
> +
> +#define __list_for_each_mutable1(pos, head)				\
> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> +
> +#define __list_for_each_mutable2(pos, next, head)			\
> +	list_for_each_safe(pos, next, head)
> +
>  /**
> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
> + * list_for_each_mutable - iterate over a list safe against entry removal
>   * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> + * @...:	either (head) or (next, head)
> + *
> + * next:	another &struct list_head to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your list.
> + */
> +#define list_for_each_mutable(pos, ...)					\
> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> +		(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_prev_safe is an old interface, use list_for_each_prev_mutable instead.
>   */
>  #define list_for_each_prev_safe(pos, n, head) \
>  	for (pos = (head)->prev, n = pos->prev; \
>  	     !list_is_head(pos, (head)); \
>  	     pos = n, n = pos->prev)
>  
> +#define __list_for_each_prev_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->prev)->prev;		\
> +	     !list_is_head(pos, (head));				\
> +	     pos = tmp, tmp = pos->prev)
> +
> +#define __list_for_each_prev_mutable1(pos, head)			\
> +	__list_for_each_prev_mutable_internal(pos, __UNIQUE_ID(prev), head)
> +
> +#define __list_for_each_prev_mutable2(pos, prev, head)			\
> +	list_for_each_prev_safe(pos, prev, head)
> +
> +/**
> + * list_for_each_prev_mutable - iterate over a list backwards safe against entry removal
> + * @pos:	the &struct list_head to use as a loop cursor.
> + * @...:	either (head) or (prev, head)
> + *
> + * prev:	another &struct list_head to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your list.
> + */
> +#define list_for_each_prev_mutable(pos, ...)				\
> +	CONCATENATE(__list_for_each_prev_mutable, COUNT_ARGS(__VA_ARGS__)) \
> +		(pos, __VA_ARGS__)
> +
>  /**
>   * list_count_nodes - count nodes in the list
>   * @head:	the head for your list.
> @@ -895,12 +940,8 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	for (; !list_entry_is_head(pos, head, member);			\
>  	     pos = list_prev_entry(pos, member))
>  
> -/**
> - * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
> - * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> +/*
> + * list_for_each_entry_safe is an old interface, use list_for_each_entry_mutable instead.
>   */
>  #define list_for_each_entry_safe(pos, n, head, member)			\
>  	for (pos = list_first_entry(head, typeof(*pos), member),	\
> @@ -908,15 +949,36 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	     !list_entry_is_head(pos, head, member); 			\
>  	     pos = n, n = list_next_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_internal(pos, tmp, head, member)	\
> +	for (typeof(pos) tmp = list_next_entry(pos =			\
> +		list_first_entry(head, typeof(*pos), member), member);	\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_next_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable2(pos, head, member)		\
> +	__list_for_each_entry_mutable_internal(pos, __UNIQUE_ID(next), head, member)
> +
> +#define __list_for_each_entry_mutable3(pos, next, head, member)		\
> +	list_for_each_entry_safe(pos, next, head, member)
> +
>  /**
> - * list_for_each_entry_safe_continue - continue list iteration safe against removal
> + * list_for_each_entry_mutable - iterate over a list safe against entry removal
>   * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> + * @...:	either (head, member) or (next, head, member)
>   *
> - * Iterate over list of given type, continuing after current point,
> - * safe against removal of list entry.
> + * next:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + */
> +#define list_for_each_entry_mutable(pos, ...)				\
> +	CONCATENATE(__list_for_each_entry_mutable, COUNT_ARGS(__VA_ARGS__)) \
> +		(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_entry_safe_continue is an old interface,
> + * use list_for_each_entry_mutable_continue instead.
>   */
>  #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
>  	for (pos = list_next_entry(pos, member), 				\
> @@ -924,30 +986,79 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	     !list_entry_is_head(pos, head, member);				\
>  	     pos = n, n = list_next_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_continue_internal(pos, tmp, head, member) \
> +	for (typeof(pos) tmp = list_next_entry(pos =			\
> +		list_next_entry(pos, member), member);			\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_next_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable_continue2(pos, head, member)	\
> +	__list_for_each_entry_mutable_continue_internal(pos,		\
> +		__UNIQUE_ID(next), head, member)
> +
> +#define __list_for_each_entry_mutable_continue3(pos, next, head, member) \
> +	list_for_each_entry_safe_continue(pos, next, head, member)
> +
>  /**
> - * list_for_each_entry_safe_from - iterate over list from current point safe against removal
> + * list_for_each_entry_mutable_continue - continue list iteration safe against removal
>   * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> + * @...:	either (head, member) or (next, head, member)
>   *
> - * Iterate over list of given type from current point, safe against
> - * removal of list entry.
> + * next:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + *
> + * Iterate over list of given type, continuing after current point,
> + * safe against removal of list entry.
> + */
> +#define list_for_each_entry_mutable_continue(pos, ...)			\
> +	CONCATENATE(__list_for_each_entry_mutable_continue,		\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_entry_safe_from is an old interface,
> + * use list_for_each_entry_mutable_from instead.
>   */
>  #define list_for_each_entry_safe_from(pos, n, head, member) 			\
>  	for (n = list_next_entry(pos, member);					\
>  	     !list_entry_is_head(pos, head, member);				\
>  	     pos = n, n = list_next_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_from_internal(pos, tmp, head, member) \
> +	for (typeof(pos) tmp = list_next_entry(pos, member);		\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_next_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable_from2(pos, head, member)		\
> +	__list_for_each_entry_mutable_from_internal(pos,		\
> +		__UNIQUE_ID(next), head, member)
> +
> +#define __list_for_each_entry_mutable_from3(pos, next, head, member)	\
> +	list_for_each_entry_safe_from(pos, next, head, member)
> +
>  /**
> - * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
> + * list_for_each_entry_mutable_from - iterate over list from current point safe against removal
>   * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> + * @...:	either (head, member) or (next, head, member)
>   *
> - * Iterate backwards over list of given type, safe against removal
> - * of list entry.
> + * next:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + *
> + * Iterate over list of given type from current point, safe against
> + * removal of list entry.
> + */
> +#define list_for_each_entry_mutable_from(pos, ...)			\
> +	CONCATENATE(__list_for_each_entry_mutable_from,			\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_entry_safe_reverse is an old interface,
> + * use list_for_each_entry_mutable_reverse instead.
>   */
>  #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
>  	for (pos = list_last_entry(head, typeof(*pos), member),		\
> @@ -955,6 +1066,37 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	     !list_entry_is_head(pos, head, member); 			\
>  	     pos = n, n = list_prev_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_reverse_internal(pos, tmp, head, member) \
> +	for (typeof(pos) tmp = list_prev_entry(pos =			\
> +		list_last_entry(head, typeof(*pos), member), member);	\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_prev_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable_reverse2(pos, head, member)	\
> +	__list_for_each_entry_mutable_reverse_internal(pos,		\
> +		__UNIQUE_ID(prev), head, member)
> +
> +#define __list_for_each_entry_mutable_reverse3(pos, prev, head, member)	\
> +	list_for_each_entry_safe_reverse(pos, prev, head, member)
> +
> +/**
> + * list_for_each_entry_mutable_reverse - iterate backwards over list safe against removal
> + * @pos:	the type * to use as a loop cursor.
> + * @...:	either (head, member) or (prev, head, member)
> + *
> + * prev:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + *
> + * Iterate backwards over list of given type, safe against removal
> + * of list entry.
> + */
> +#define list_for_each_entry_mutable_reverse(pos, ...)			\
> +	CONCATENATE(__list_for_each_entry_mutable_reverse,		\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
>  /**
>   * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
>   * @pos:	the loop cursor used in the list_for_each_entry_safe loop
> @@ -1189,6 +1331,31 @@ static inline void hlist_splice_init(struct hlist_head *from,
>  	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
>  	     pos = n)
>  
> +#define __hlist_for_each_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->first) ? pos->next : NULL; \
> +	     pos;							\
> +	     pos = tmp, tmp = pos ? pos->next : NULL)
> +
> +#define __hlist_for_each_mutable1(pos, head)				\
> +	__hlist_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> +
> +#define __hlist_for_each_mutable2(pos, next, head)			\
> +	hlist_for_each_safe(pos, next, head)
> +
> +/**
> + * hlist_for_each_mutable - iterate over a hlist safe against entry removal
> + * @pos:	the &struct hlist_node to use as a loop cursor.
> + * @...:	either (head) or (next, head)
> + *
> + * next:	another &struct hlist_node to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your hlist.
> + */
> +#define hlist_for_each_mutable(pos, ...)				\
> +	CONCATENATE(__hlist_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> +		(pos, __VA_ARGS__)
> +
>  #define hlist_entry_safe(ptr, type, member) \
>  	({ typeof(ptr) ____ptr = (ptr); \
>  	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
> @@ -1224,18 +1391,44 @@ static inline void hlist_splice_init(struct hlist_head *from,
>  	for (; pos;							\
>  	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
>  
> -/**
> - * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
> - * @pos:	the type * to use as a loop cursor.
> - * @n:		a &struct hlist_node to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the hlist_node within the struct.
> +/*
> + * hlist_for_each_entry_safe is an old interface, use hlist_for_each_entry_mutable instead.
>   */
>  #define hlist_for_each_entry_safe(pos, n, head, member) 		\
>  	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
>  	     pos && ({ n = pos->member.next; 1; });			\
>  	     pos = hlist_entry_safe(n, typeof(*pos), member))
>  
> +#define __hlist_for_each_entry_mutable_internal(pos, tmp, head, member)	\
> +	for (struct hlist_node *tmp = (pos =				\
> +		hlist_entry_safe((head)->first, typeof(*pos), member)) ? \
> +		pos->member.next : NULL;				\
> +	     pos;							\
> +	     pos = hlist_entry_safe((tmp), typeof(*pos), member),	\
> +		tmp = pos ? pos->member.next : NULL)
> +
> +#define __hlist_for_each_entry_mutable2(pos, head, member)		\
> +	__hlist_for_each_entry_mutable_internal(pos,			\
> +		__UNIQUE_ID(next), head, member)
> +
> +#define __hlist_for_each_entry_mutable3(pos, next, head, member)	\
> +	hlist_for_each_entry_safe(pos, next, head, member)
> +
> +/**
> + * hlist_for_each_entry_mutable - iterate over hlist safe against entry removal
> + * @pos:	the type * to use as a loop cursor.
> + * @...:	either (head, member) or (next, head, member)
> + *
> + * next:	a &struct hlist_node to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your hlist.
> + * member:	the name of the hlist_node within the struct.
> + */
> +#define hlist_for_each_entry_mutable(pos, ...)				\
> +	CONCATENATE(__hlist_for_each_entry_mutable,			\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
>  /**
>   * hlist_count_nodes - count nodes in the hlist
>   * @head:	the head for your hlist.


