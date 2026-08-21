Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77421C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2821F6B0095; Thu, 20 Aug 2026 21:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BD76B009B; Thu, 20 Aug 2026 21:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC786B009D; Thu, 20 Aug 2026 21:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFFF56B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:40:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD00280345
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:40:41 +0000 (UTC)
X-FDA: 85123572282.14.15B99F8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by imf09.hostedemail.com (Postfix) with ESMTP id D44D6140005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:40:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YFpBwLn2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787276439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVbhAloWGYt77M4jSU9bkGa8+OhZdDonr0wv/vlrNHQ=;
	b=c0Epzv4hlz4eYFki+ZEZbQZavH1RsLEEsxiapr2riE78GWZT3z2yh375iDtmzMQDooVs3M
	ZWg2a7MPn8E9ObaZxgp9qK8cRXwikO2sz+EwH0KvT8UE3VfpfmgcBioUrAxwXso+JjR074
	uU53axqWoQTINKcSrph7vEKvl5G+RCc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YFpBwLn2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787276439;
	b=gn7M5la0aahuhczTKV0f3UuojYOAPqcq5huCi60U54sXJhpo944yfYlC8Amrs0Amm+O48i
	YSG8rlDILxrr4ydq0ViENm4uv5OP0DlbCn55zPaS6QjkB7yZcrjQ1zgdmjLIeZX/8oDwsG
	MHm7yJXQDZqGn6O4sOK7zGxPV5M84Rw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BCcDQcYtjpf6udkVcX+3tucfx2Tw72qXAXWDnPo2KPgpgFwDsOs5NazaqKVLWVvPuQawfktOl+wcZxPLMzV6iswWUMQOpY5e3UqxevVkb6ZIxI7uzIq8JGDWcUIsgXPphI5Y5Xd3W9v8T1wqGq2omu6XI5/ZZ1dQqsmgn0IvYKquCjJY7ReIELXa7as9bgYnDU9ejJvljQKnz2sN/qd0KrJ1GDZw+z51Th/v1PNtQJAo5yI9PD1JeyK4WaxDQdNcQG3XPOwaljWwWNDHwtQgC/MRhlsTts76rZUDfQdrhOb4DcPZCebA4IEi1LK2I/yarCevyVFxY3rEIh76lpOo2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVbhAloWGYt77M4jSU9bkGa8+OhZdDonr0wv/vlrNHQ=;
 b=ulNbSP7I3PHweh0JQvoIt320RCTWEmfat27htWa1UBCxFu9G+yq7Hr3j7KkfsbCMZa6tU9apODiIEEnJ0jt9hD24Zqc/KJeG80c5cmUu3B5VjibcYHnnBg+LJucz94JMOOxj95DmSpeWF3zrhHJ3Np0rLu/Tk4Zen35DQ/kAhFuJtS4iAy1UpTZXroFSAi7yixt5ArscbAOxVlkbZ0gznnm6X9O2r0tQ++1pgsgEXTp3XvrD72Y3gtBgSLJxHugOs3UWNlKJ/KU5RHrVer6VBz10LEnY14Y91m4MtSz/qwsXxaqLhXbR/1AYNkg4TDKK7bI9uU7DvNeNDjwdFWAafQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVbhAloWGYt77M4jSU9bkGa8+OhZdDonr0wv/vlrNHQ=;
 b=YFpBwLn2Zcp6vMHp34ylnSVCVdBgNrp+GqSbhuP3aWktlZR8GzCTo3nNwnxD020F24NP/8fvZpsCUC/JvDdWF2736bMVpT0Af1maS8fBGHd2H98dsbPqsyD1A4FNbiSHIEqTumZ2oZ68pJeUwuXokNRyCIWJMn6txAgjUrry1lSfYBqO+fjEzPG0uA5QLkXPUY/NLKEOl1nVtKfpmdD9t7RWkrc4gow92dcAPL12CnRWQ95nRz//90xQ2vE+DOyxeEGq0ygJF0nAN3r0ZSCC0XbCh6aUkKvLfRAbAO+ENATMNpj5ktCYXkoC+9fqr24vwD+4EodwMGIBi4cwH76Wdw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7768.namprd12.prod.outlook.com (2603:10b6:8:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 01:40:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 01:40:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 21:40:29 -0400
Message-Id: <DKU8M8TD17MK.32V5M766Q1B6B@nvidia.com>
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
 <DKU1AFIKNMNE.2A0JUVSTKHHLC@nvidia.com> <aodxH5Qc6_zVay-M@e129823.arm.com>
 <DKU6OCPNSECE.O9BZZWTSU1H4@nvidia.com> <aoebR7VhQH8kU-xJ@e129823.arm.com>
In-Reply-To: <aoebR7VhQH8kU-xJ@e129823.arm.com>
X-ClientProxiedBy: YQBPR0101CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 566d8b27-fd8b-46e8-7e3d-08deff252fb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cv2n7VmGgKyvnTioYhCKW+ul2aa+I0Zf6tSidbfs5igpONMnJmUahO4YqnJ0yV95tUhFfytQ9VBZ6s4geXjprWTdY0xbAANNFM2o/tTRz5Hr7kNLUbJZo244tlh19j+FIHGtjj9gA13jKsRvqMc9/22grYmUtkvhyhrEEJHuy+iX5Lr/tK8TbbNI9FvHT1WpYXnS/jOxKfqTq7lly0k2SDyh48EBxplIemg45GrZ+lmlzJC6i4X9Z+C3vP7qG7gMjyf/6g5EUtydvxh2NzGLjmCd9a39v4YK4TXm5QllDRUx4zYoUkWvsLbFDt1fhRG/hKLTbcBaTUFmZR7BeXAaU8CnGBisAKizWiQWA0MGTnKlzTHpR6rwWjjAWanIxlX5Zgzko0HGg6bH3cbdMO97CQeFFjG57kP+NKxvvZAB+ghSVglkf4JllJ/wBrrmDsS2FQ+tISolvcm7NBQrNd9YF3qHQokyAei9t4Mdn5tsBqpQzPJThAQF4gkPny9O6lUvexbBfgL9n84zuwg1+nPIc2xcQMQLyKzVfPfC1UHXaBDkatKKCFLT5SubfHi85S6MXvHJwD3h597ZdJwLP+zSApYUkMuaTEtBzS0gSAtwrJyb1VwhlG4RxHf6hxNBvuOqCa4DwvuZFM8K654/NwWLllfkRYUus+53WZ/YDH2EEx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHIxb2YyMjJUQk1FNlFOQ1lGTWd1YlE3K3YzYkVoNWI5eFRUYWkxM2NOTFd4?=
 =?utf-8?B?RUxMeGFnVmFpUndXUTh3Vng5WGFkaXNmLzE4MzRCd2tGVnRZdU9TWjZuMUhu?=
 =?utf-8?B?WW1UMTdtRTYwdU51K25Hd05RZGNwdjZIL0Q3RVo1VUZhV2gzcHphSUQrbits?=
 =?utf-8?B?M0xUcGg0YXlWNUlzWDhvbWJlekh4MlVXVENYUHJVdUc1YWVBazhpTlJWYTNj?=
 =?utf-8?B?ZmdkMFVWa2xMeGtBcUxFMVlPd09LSkJXaG1nVUVnVlpmN2dxRDhLdTduQVhw?=
 =?utf-8?B?eXBjVnZxVEM1MnpHTjNYQ1hDeXA1c3B3QW9XUm1mbHZzamNJbngvYmlIaW9L?=
 =?utf-8?B?YWY2NDF6WTZLb241Mk9MdlZaZFF6cENGWWJDaDlBOFFTSk9FQVZlaFVjNUtY?=
 =?utf-8?B?SjUvSmYzc0tYaGpIajJwQXp6MU5oWFB6eHY2bERhc1pNRU9jQ2dWZytiT0FZ?=
 =?utf-8?B?OHlGcHdEQjEwKzBKU0kxMGRmbjhKWm9kemtiUm5vWm5ZenZQRng3UHg3SEJW?=
 =?utf-8?B?RmVEMWJEVDZRYnhQK3dqUXpYRnFvTDkycDgxUDlyYnVtd3F6MEhUL1ErNlJD?=
 =?utf-8?B?K1ZhOVF3Z1dHR0VkSVVVckwxRFVqSWtEQ25EOVpPQUdGWGR1QzRuVGZocU1J?=
 =?utf-8?B?V0ROd1BUc29wSThKM1FUcmFWaXNYNy91RTY2NUJ3aldhTi83WnpUdFJFZzVG?=
 =?utf-8?B?d3JKV3NoZGRVNWsydjl3VDJ6eGhURmN2dXduZk1HRGFlbFJydVFMNThyckRp?=
 =?utf-8?B?SHl2QnFxQ1FTRldzMGczbUdqUW1iZHdMNTM3NjVnOVdsVmxMMmlKa01KdXZM?=
 =?utf-8?B?M20rUnVrZUxPL01Qa0tieDcxUGZYNncyTkwrdHlHTUF0K1VOc2ttSXZBeWp0?=
 =?utf-8?B?aU10Qy9NOUFNTlJpSjdmeHlxY1Rhb1FRWTRxS3FDaGpnaWE0dngxNjF6T1pZ?=
 =?utf-8?B?UGZQa0h5UlFwcnJaMHprdkVjaXZaSTlxWmwydTc2dmxBeXdEczBicDVNUHVV?=
 =?utf-8?B?S1pLUlpTbVZLNml0Z3pZSlU1ZWtaOUduckNYYjV6MTNyZzhHelhUb202aGJw?=
 =?utf-8?B?MEM2bmd5NkNkeEVUYmNZOXI1RFFManZBa2NkZUx0alZXaFdxSUhmYXJVcGRK?=
 =?utf-8?B?M0Q4TWlWdysrNENWalZzMmM3enhHUmcwZXBEdy9OSFhNZ3EwNm9jaktVK2Q1?=
 =?utf-8?B?MXNqNHk0cHhGNkswMGlwOGxXc3pHckF4VG92dm9PYlVwblNxTmtMNElWdXQw?=
 =?utf-8?B?NmZpaUFyNHhBbUVlMGVMV1BKWWJaR3U0NUk3cnowdFo0UlphUjZLYVB0RHJO?=
 =?utf-8?B?OWJOUk1NSjhmVEdmc2xPNEhrazBVVE9LdEpqT1lzUVE2bmpvYVFwRjVZb1V4?=
 =?utf-8?B?K0hGZkJkb2YvWnBQcFdsUWJuVjBGenljN0MzSzBmVjVhZTV5WGg2eFZPVzNp?=
 =?utf-8?B?Sk1UdFUvWkQxSVRqa3NNU21nc201WndtZG1tWE1jSUMyQUh5dzRpMVE3MkQx?=
 =?utf-8?B?SVd3QWl3dy84VGc1cjAwYUFzbWRMaUc2allKV0l3WkdoazZtbEJsWUF5aGVQ?=
 =?utf-8?B?MHpSbXRPeWZXZFZpNmFNQjdtMVlMQzd2OGgxM0NjeFYwQmJnT1NwUGxIc2pS?=
 =?utf-8?B?c2JBYVpUdWFNUUVKR3Z5OGlLZFBwbFJMaDE0cXlVUmRYN1RtRmlCQURta0Ex?=
 =?utf-8?B?S3lnU0ZQVFJXNTZRQklyOWdUcVRJS3hHNDBqK0Nza3poa0RZdkxld2w5VUUr?=
 =?utf-8?B?WDRNOEpDZGpLYVp0NlBlb0hXZ3oxVnlwcG03OEZycURLS1BDT2xnY1R1c1pF?=
 =?utf-8?B?QUJQbkJHTzViekcxQ00zcWwxcTFUMWdnRXhWV3pUL1ZEblNlZGdmaDJVZkE4?=
 =?utf-8?B?Q2V2amxzYURscFJxeGs5MmFuNndDWnJCS1RYMXJRc21BdERHY2ZZeTRFNmV0?=
 =?utf-8?B?Nm96UDVqTFNvMEJ4STV4L0pLYlJFQ2lTb2Z0WEowdFdEZ2xKSXhkamJvekVa?=
 =?utf-8?B?b3ZNZnExSnhSMjQrY2RGNGpvS3cvbkZZYkNQdjZWRUNVWmJPT2VJK2N2cUtp?=
 =?utf-8?B?RndWUzJ3UVJSZGIvMmJwTHhoTXdMKzhFckpaYnp5OXU4MENyL0Zxc0JsaWFY?=
 =?utf-8?B?RlpiNmxtVVQraTVQNE9nTkg5ZkpkMklwNUd3dkhtRVkwOVJISDRnQS9ZTVRM?=
 =?utf-8?B?UHU2VVUxMFVlRU5rdVppTEMzWjNTRFdFU1JCa3MyRDcyM0ZQOW1kM1pIYW5l?=
 =?utf-8?B?VE9KdDhzWE4wcVFjbDlNUmM3Mk4yc2NCb2w0b24vSmswK2k5b0ozRHA4MjdF?=
 =?utf-8?Q?Ey/E1TrFUkkfiunw+B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566d8b27-fd8b-46e8-7e3d-08deff252fb1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 01:40:31.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x1DBkF5MB45xbjeT75sdGDBy3xx8P+b8kmfj/ptuCydSobhXwp/EhkBHdUKNwzi0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7768
X-Stat-Signature: pfzh1s7pzzhhawjwthb35ebiwnuwg6wp
X-Rspamd-Queue-Id: D44D6140005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787276438-224910
X-HE-Meta: U2FsdGVkX19dGNZNgDka652EW5gDb8/tLDafJUA1B/hlRXzCWL+rd+JGnj5AM8r00w2uyUjcKNJaEIlUbE2EHGomkhxH8X7zngQCcSy0Rz5wOjZsysXTthYQ/BG6Q+V3N/lYkVgX4ywzDLAio4hhm/2eBCZRDHVHSSrOjYnYz+zhZCHoOgzjbmAQw1P/hatUontuL8kMKZYlKd2ixWiQ3lCNlIxFhqBKCd/aeWR/WJIZjmyNrp5b1V0zXJ9ScPG6DfsQjTQhbrIvZ08QvcGSeACYHN7xdTGINlBGhL5ArbUXOIy5H0vIrpsWGQ6X503CsiIoHfq/V6MQaSZvIoN73SQZPGZ9qPv7jso30hVyEDcKG2T3XmEydgyAIbA+u3Bx5O6kFAuhQ6dYu1RKcsXGOpm38Lgl2FdSevm4wK1lLCuYaSd4fWgkonZBoZRn5kxLu7r+6zkwH1mWnK637fau3FYbv7ZVNdRpKWyPkR3YZ3KcZnig5CMfuCgkyPtpRZmjcw/VzBHDno3KgWg7tFlBb+z7htyg/UJUpAxgQ2FbpbsAZ3ooiiZbW6wmphF+/APY3QgWu6JXH40esJXtrK/BDP7+s3jtWNA3eqZRLCK5TnuRI17EksoIqdwjURvVLCpUbvaX5e/WKSYBiZeKwP2roLQXIKxtz12URthCkKvRZyOorAl9S9gPUDOOoFGI8/KT09NmczvMCKdlCl34Y2K44gqzeiTJLvxa+lVDQoVnyQpYY1W2pWo4CUNHo6B4cHZtmzh4M+3+eNZV1Go2kyhjWgQRbrcZ00wOI/nGfGgsUbonj2lzA5HioM52sqrjM3TmBFPyFqWulxK9vQYIWnVHgzrFU+hNMUGxy3JtMNPY+ruJBLiHA6ekeTNrlca5cCzVCU5MOLkC8yeUm+nI6hgy3jV3RWVeZZkLyBUVnDTRsedvXpCI+/D6yf6bPNepwKZw3z95XHfkJX1r54tjsFs
 RXwd3BoZ
 XkhPiN0FpkoAuUN5DaoteHjOMdtLAijQufynMTZJRuCLCsncJURQOLQXFOQALawCTp0uKoNEgnN3IPpL9qhJErHkPIXAudyrSP+HHNOIfn9dvBy4mG/pBxZTHhZGfAUfB+izihr859GiHghyPoZ4Kf015YRlRq4FKZl48O+v2pgass3Vb+ciKT7t5PZQW2Fpzxvz1pK/ucO+zXa9MTXWjOhwnjDOhaVRXWjhtPzbEBdeNAz39AWyf0Ej9mPV9GCQ5stRZVPBMi6Ebhq2/M/FF9VEnp66xlaGwEcxWlKCK34aL7+aaL6b6J/r8YCroG6Lqft4ChkxRFBOx4boGRnG/eFatXNwp2cTFgMZs7uhhB5lYBl98QAmK1HGQ1hYYs3F1YdMw59He/SMdwWds4Ox9zgTjs2NZGF6VzMpnPze6Ejw1PpRqvGWQAiEv5te/zoqLhrI6/VOsuIjXS9MVe7hv7uBZdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 8:26 PM EDT, Yeoreum Yun wrote:
> On Thu, Aug 20, 2026 at 08:09:12PM -0400, Zi Yan wrote:
>> On Thu Aug 20, 2026 at 5:26 PM EDT, Yeoreum Yun wrote:
>> >> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
>> >> > Since glibc commit 321e1fc73f (=E2=80=9Cmalloc: Enable 2MB THP by d=
efault on AArch64=E2=80=9D),
>> >> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large alloca=
tions
>> >> > made by memalign().
>>=20
>> I just googled the commit and find that Dev did that. ;)
>>=20
>> >> >
>> >> > The underlying VMA may start at a different address from the aligne=
d
>> >> > address returned by memalign(). Furthermore, a subsequent
>> >> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag=
 is
>> >> > already set.
>> >> >
>> >> > This causes split_huge_page_test to fail because the check_huge_xxx=
()
>> >> > helpers incorrectly require the address returned by memalign() to
>> >> > match the VMA start address reported in /proc/self/smaps.
>> >> >
>> >> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead o=
f
>> >> > /proc/self/smaps to detect huge pages and change the meaning of
>> >> > check_huge_xxx()'s nr_hpages argument:
>> >>=20
>> >> Have you checked Baolin's patches[1] in mm-new? They resue
>> >> gather_after_split_folio_orders() to reimplement check_huge_xxx(), al=
so
>> >> based on pagemap and kpageflags. Does it fix the issue?
>> >>=20
>> >> [1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linu=
x.alibaba.com/
>> >>
>> >
>> > Unfortunately, No. since __check_pmd_huge() in check_huge_xxx() still =
use
>> > /proc/self/smaps [1] for pmd THP, it still has problem though ths patc=
h
>> > series applied.
>> >
>> > [1] https://lore.kernel.org/all/56b16691f605426b33b5cf47319233de6127a6=
b3.1785985999.git.baolin.wang@linux.alibaba.com/
>>=20
>> In that case, is it possible to use and extend check_large_folios() for
>> all check_huge_xxx()? You still need pagemap_scan_get_categories() to
>> check PAGE_IS_HUGE to identify huge mappings. Or at least
>> check_huge_xxx() in your patch can share most of the code.
>
> Agree. but TBH, I think check_large_folios() can replace checking
> PAGE_IS_HUGE and keep the later part to check wehther PAGE_IS_FILE

IIUC, PAGE_IS_HUGE comes from checking page table entry (see
pagemap_thp_category()), whereas check_large_folios() checks folios,
namely physical memory. A PTE-mapped order-9 (4KB base page) folio is
!PAGE_IS_HUGE but check_large_folios() returns true for PMD_SIZE.
check_huge_xxx() are checking PMD-mapped folios, so PAGE_IS_HUGE is
functionally equivalent.

> and SWAPBACKED according to check_huge_xxx().
>


--=20
Best Regards,
Yan, Zi


