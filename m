Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B24C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 20:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178426B008A; Fri, 24 Jul 2026 16:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F1F6B008C; Fri, 24 Jul 2026 16:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DE46B0092; Fri, 24 Jul 2026 16:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C46F26B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:26:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36723A03D1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:26:53 +0000 (UTC)
X-FDA: 85024803906.24.531B932
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5ECF04000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:26:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AZFFVPqq;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784924810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHiGWRtMEM112LYsHZm7yHmQQ08qlE1Iko9BhrHmTHg=;
	b=B9eF3aGz3uBp+k65qYQCFnaOGhjy8zQgjlbVueOabHjTcolsDQ5f0ISxzt+/ErF8LV7lWU
	muCEVh/ZB7mZdXiNon079jV24WZsLtFT3w/O1X5ArQ51zVkOWLgxJ600MXV+YsLvqYSlW8
	1YJ2D6IBQZtJwL4uiJV3kZBk9L3vuG4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784924810;
	b=Wr5IFR02tu4fxNd1AT7e/y9HIYcl/bImz0KLJePVYqP4Rg8QBeRpBD+HEK6MToxboB5xgN
	ENMUhu88Cza0kN1uVFDXcatymtfI+hHweMvxViwGjk/HiFzj1ZCiOg/IY2ft/fEbxOud+D
	m3lpM4rXF7RsjxE81ZaBPLG/PjUFDBs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AZFFVPqq;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzf7wHY9BYOEYNLkAyGxYYPVDwetiX9z5FcqW8RatwsLvsO6Cd1bgpUqnCLHo40hYnk6cdZ7Wk1uoYa+FgsNH8tuApp5dzHbceylR4YoopzoJoMtKXt1wMYvl+mIsN5vECei8mow89djDDs+nCgsTfCjcBjZUeXBmlKYZtY5uEWKMXliuUyMJ+TuKTff37SWwu4obgPzgf8uJ8HTxmT5bNMUk3b3p4x9p6tWyiHxxTgeOJ4lDa8lEAIBu78Y+BY+pTsW07+8esn9lgozwPNHQOEb027JztI2D1akeszts04GpbAcysdtqMBs8SVignFh5rVppQR6HbEdtwL0r0vbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHiGWRtMEM112LYsHZm7yHmQQ08qlE1Iko9BhrHmTHg=;
 b=EXYI1nvPC2hqM3nQqMEdLTpkuB89XK3y0szQKOqtzDef9cdOQotKwWqpw5d6pEgD8NJncBhLMd0FIu/qS1N7TfT7SesumuzPdFrQwybcYAgyxUj/QYdSQX+ssUeS26ygaMd4JqMO8QCf5sjJPX1FI2uKrGYg7fSsQPsY6txBX9u+dxkusCCMW/2UoI/QPEbAB5nPvaeNNR4U5MM5G+iUsMVW9eO9lrtwLN+s5q8FR7IphgO2UrY/jaGx78uVf4/1LMtbLqlriwV9uEO5Jdx8t6GxZK6o74acQgRzOuSqEHjqxJLHaPdePGttoGTvJ2tPdHU8A4sF5ciuEWlxZ1qJ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHiGWRtMEM112LYsHZm7yHmQQ08qlE1Iko9BhrHmTHg=;
 b=AZFFVPqqLnK1PXIBZpeZxLG2Ip7b45b+yMpHWq1ah0H9WUHs73wZ9yxywCnNJ4Eh/hl+WTQqGXvTHE6nU/jYoTuCef07ThaQVdDHESOPJQqmF8oiLFlK3LcaX3aHSgGz/6NQWxkTibhkZNuqC0cy3ok7MwfWeROsWlWddJjXXax4eGBdOMNDIejNBVQxvkC/wCJZyr87Ln8zp476Sb4uVuBlAX53AC4crNaSxVYLRYVBvjbgilHgwEHMaYa+60gsSzH5U454oGcHe44YsP68YWAFWZIGmhPP05MJDx2YF9mbfcAB+X+i4ZFqKignyEZ25LZlpsFQgdobO75S1+5nag==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6531.namprd12.prod.outlook.com (2603:10b6:208:3a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 20:26:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 20:26:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <ryncsn@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
 stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>
Subject: Re: [PATCH] mm/huge_memory: Initialise workingset state before folio
 split
Date: Fri, 24 Jul 2026 16:26:44 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <CAFF6190-1325-49BE-825D-FDD9DA91CF03@nvidia.com>
In-Reply-To: <6449A238-AA0D-4EB0-8B78-2A669532AEE8@nvidia.com>
References: <20260724195244.3715130-1-matt@readmodwrite.com>
 <6449A238-AA0D-4EB0-8B78-2A669532AEE8@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:208:23c::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: 096513d2-02a2-4ef7-fd18-08dee9c1e1a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|23010399003|376014|11063799006|10067099003|5023799004|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lno6V6ELK+mXSnz5ZxbhZpgkxN/wXM17ej5PUe+NpnVxv6MEAWitbaIZRTCnUCWSko3y+3cmkPk9GU4RWfDG2bGMblunCfd362RB43ZZ/Y6yjnqUYEQntc1glZTG6SRWBloGtrnDFCkODbbqdK90FzkKtl6Zm1ESMgYr5Vt6/rCFAvqPbKO3TTHdwdXJ3Q8nhGkti886G5aX+GNNR4PZcuWo+HGbBv7RVL9XlEvnNoP6TFduaTs9bpt8i/kCEERhaF2BGqHU63L/6p6l2MgNjnAX1rM8OHEpVVsI1acuLKeF1m7SmbPqcEvYlr9xdQ+AphMJIDpPww3zlqHRQ9b3awD1NkTs74WSEDFHi4U7GhPU97q4+zJoz6K6/aYdqBMzrgiieGQEr/XHHiaXh8UE0UNPVplBiioaTmKZriUpgm1yc1ibY0DERA5nfO5DpjuN2L4ROXPQni5N6VoN8MJmrQRm/qv/HKStLXH3A0+pI6gyFe6FTf/wnCm6z7e57q4SFKLoePaADQMBo7UG7HYNpjxidJJuaA6ii1wValwPjgxIuouSTmOdXYioGpvM6yAzkyk67XuDNi/Glfe4cdpwKYQmcVyseofEDaLo9W1GZhH0JTXCZieaeopv1j2qm49E9KdAu3yQuqAqEte3LrtRNqwO/H/XPv5ktBkYmwWuSVg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(23010399003)(376014)(11063799006)(10067099003)(5023799004)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnBOTEVsTktVWFUrM2I4R1BNLzIyLzRqdzhrbUJjejMyZmdWVmNWMXBHclN5?=
 =?utf-8?B?aTNrZjE2Z21ZK1N6MGZ6LzMxV1dHeTY3M1JZRDBvWVYvTWpZbUZZUDFoRFZC?=
 =?utf-8?B?WXhFTC9MbDJJakdVc3YxSDVGYjY1ZlJocC9VL1o0R3dRajNaWVkrVVNwWWtB?=
 =?utf-8?B?TUQwbUJJQnA2bTNwNE42c3JVYW1oZHBkWHFSTHFpRE94aHR2WWlOdForOGZE?=
 =?utf-8?B?MFQrZjhJQ1FKaEt5U240eUEzcitRSlBjckdGdERoWHdqNk1WRXRmV014N2No?=
 =?utf-8?B?UmRyNmYwbHEvQ3ZPOGJqKzFnTFlBWUtFVVorbWxzbVZCcDh5YVRiUXI3WGFp?=
 =?utf-8?B?eXZOU1lhUVY1WWNFWkMvTjM4NW9ENnA1MHBuV3JoMUx0N05hR2RsRDFQaG1L?=
 =?utf-8?B?MitkeFNoUG5qSkhNTG9GM2dWL0hmT0IxeDVjQVBiMHFXTHBlTVNCMUhQNW5a?=
 =?utf-8?B?NForcHVVT0JaZnNkREQzQ0o4NTE5cy8yUkJDcDBwalRGWFRMZCt5SXB5L2lp?=
 =?utf-8?B?L0IwaWdqRnBoWXZxaXZqUm10WjByL1BxUDFnci9ZMzZmZVY0NW81SWg1UTRw?=
 =?utf-8?B?QjJQbHQ0NTFNL1Q3RzdnUzFqYTZGcmJ2d1MzQ0JFS28zVW5pZjZxME4ram9R?=
 =?utf-8?B?YnQ1bDM5eVlJSXcrTVprZ0lVUHFwc3RTcTZxaUxOMHJKemcrM3BRdkpXQm9C?=
 =?utf-8?B?WFQySi94eHpsTE0xamlTaFZqM3VXQzVpNll3dnZwSW4yTHkvdlNvbVNldkQr?=
 =?utf-8?B?VHdxWmNka1JkdlVBU29qaUJrdnJmeC9aTHk0VUhDbTV2ZExnZk5UWnk1dHhQ?=
 =?utf-8?B?N2RzRFZ3dE1KdHU3TEVLMU4rSHhsd2c5eVhMeURMbVlhOHpSK2lOWDRIQXJ3?=
 =?utf-8?B?bzBlSE9TN2JwOXBnT2hmMDJkbEJKUTlQcTB1Y0dxYmhVZDZYYVM0TDY4dXZj?=
 =?utf-8?B?azBtRjAzM1BxbHBVQ3ZiQ1EvbitpZ1RMaDRieGNqRmkzZXNrTWx5SndNTjJZ?=
 =?utf-8?B?VXZwMGsxenlFWGI0eHV0K2NwWTZJWnZmc3Jrc0RDbkRNNVJkYk5uT2F3Rm5X?=
 =?utf-8?B?OVdhY2wra1FpMFQxZHpEcDd6THBrcHdpZktSZzhoejE0bzNPUmx5Y1gvVzRS?=
 =?utf-8?B?QlVxUC9CMzRJMWtmamFWMzFRZlc5VjdXbnFnOFRaSzJmcEpBM2o5QXB2VjUw?=
 =?utf-8?B?eFpDRUwxZHdrbHVkRlQzYWJ3VlNVdG5HKzdxVGU2dzc3YXVnRGFyWEZrWk00?=
 =?utf-8?B?V2gycXBkTW9wZW9YSzV3Y3NUTW5NdGx4R2F3c0NteHBYNE9nTXRxRytYSW1j?=
 =?utf-8?B?am5vSEYyYUdnOExkQThGVG9mMFNrWVVqTENmcVFpdVd4WGZIWXVlMnlaMXRR?=
 =?utf-8?B?S0hma0d5dlQ2Ylo3N095aFhDWTFYNUpaaHduaE9hZmRiR3NlTjVCNzJWR1E1?=
 =?utf-8?B?dlFJMkc4anhyQm5rM2RvSy9VbU1VSm56ekJ1NjY3UFdkVTFrUXBSaHFjRms0?=
 =?utf-8?B?Q0hUT2g2TFRFZzFTNm44a0hyL3JFOVBIWmpJaUVjUkZ0ZGRnc1RySnQ4S0Np?=
 =?utf-8?B?MDhJQlBUUmJVQkhtZUhrckc1RmhMc3Fqdmh1R3NEM2d4MnhmZUhZSzFmbVNF?=
 =?utf-8?B?WWJES1hRdXJXOWdwSENZMEFsbXRyUDFaZEFkOS9ubmNuQUk4NXovSTJNS04r?=
 =?utf-8?B?eGtGVzhXa3NXQWVJTFhzZUIrWTN3anhmb0lhRmpYUEYzOW14RWNlaU1PL2dl?=
 =?utf-8?B?VFZwVEFNb2FUSWs1UFpDN01ZdTVKSWRoOXJ4NjBjcFVnVzVQSnp0ZnBrcHkz?=
 =?utf-8?B?a1ZJNFYrR3BvbEMyS0ZHcGgvOVBFVW5pclBrWWlKNVNtNm1raWR1dkY3TEF5?=
 =?utf-8?B?WGE5VXV4RG9NUFVQZUFvK0U4cVBsM05Mbi9PZWJOcU9nZGZPSEVXWGN4MzVp?=
 =?utf-8?B?ci9iY3dBZnBGYWIwWnNnOTdvOTc4Uk8rUFU2UTZkUUtWYlZ1SVNOQldVUXgv?=
 =?utf-8?B?OXNheXJJNm5vcTZlUmxoOEFTd3NYQlR2ZUVOV2dUUnZKc1VHdjdiNTFFclM5?=
 =?utf-8?B?aGk0ZmNjTlJobW1ZWUEvaStNQ2cxWkV2MWhmdkJ2TFVnRUFiOCtOaGpoNzBQ?=
 =?utf-8?B?M0FVY0RXSm90ZUxvYThSanN2Qmd5OWE1U3RVbDZoYVA5Q3VhWFZFVnk0Tnda?=
 =?utf-8?B?MHFNWnB5clN0VFhFdXA1aEdRSGI3N1VYTWlXNHh6MlFpMTUyY29IajZLZzNI?=
 =?utf-8?B?TGxESUVQek1aaExYWnpiRHdMTnRvS3k1dkt3aHBGRVFDS0JXMnZBMmFWQkpS?=
 =?utf-8?Q?VdGHI1vnJHq2niLnzP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096513d2-02a2-4ef7-fd18-08dee9c1e1a3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 20:26:45.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLia5VcVImX3GP9KvjJUaGIq1aCHThrppJ06HK/R2fZgWe4MHFxVJDEtQevX6hp0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6531
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5ECF04000A
X-Stat-Signature: ewhijnu66tesd44ddaju17ryhdhgc7eo
X-HE-Tag: 1784924810-326629
X-HE-Meta: U2FsdGVkX1+CLk5v/ENVB7s3lhoxsjvsPoXCb9QsbrwNyAnZQVhdMYjx7prpAZDG0PPWxbLk/TgM+6qAQqNsjFHik55HvaHNPJE4B33i37OmaNgKGId9SHKUUPDjkWDINx1Fy2EB7ifXTODwfbbzic6fUjgkv9Wy/mj0lO65xE/qBvwDlAAV1kUn2HXs7qN0jH/YYDV9QxqBTX9bQIp5L+SopbEN2dSfj+hoebNv862UUjzq/0d2ul+W/WnHzwZDyaRg2iDMZCTiwW3m3DEPfQMCXf9RVlA7xIXhGUkWgU2pfxZxJREjWz1binB+VJkteN5eSuDKNs8XWUVyrEz24K8xgsTxF9zmyIUEK7wMKgh9gAFzXAhUyNjkOAJpP7R6Dk3Y9s5iCJemjCPktBmjjxm7xkDl/C8afpsS5IpyFBXAi2d1eMwCVXJeGg+6ZXosV0fP4pwfw/s3VjJ5SE5dfyJGWGpPCGTOD5CU9nlusI7LkNl5OaFOjjteFLnDBOK7PgCHLDKa8v6h+4WWX0U2edea0vgAyPSKWAthho+FeXZxoVII4oHh04vuo/hj+j5Cm+gNDCG6WNpLsmAzgtUyFnsMXGyrcotB7vxvGihnzXHuGnHl/hdYwcc/xrGLBqBn0ue6uxV9R2rbtLDosVTcB3lNVcmIZGOWjBFpYlrAh+yH0FyouGyIedcZzajn0BYCh883IdxmfZFFmFJQpQMaBO+ziBSn9eo/GICI7Gm1MC1cmVs+UqMCt6XxjFokzZXp/+Z8Ug1vIn9wpw5PBvMgvO16Fhv46z9ckpknb0QM9HJBvxUsxcOm4D3TXtM45wxfygJ0ehqj29wmNN/LHL4knNmckSS4eRF5H6lxdGo/YifCDieIWxYNdHhozmmvCboHPxsutriFxYB5pJVsxaZGW0KfzI6Lgt4h93exAX0+y/KEhY8N6VWsal7PWC9W3CXvCWqXyWGrhr63inZtYmS
 HmNXuUZr
 BcxnlDIJdFnIUSaz7+8xSEB1PvhhKj0RlMc1IDNmP4tl4v4ccMRTMkAb1C0FgFECWnwDmOoqiZuGT1icwakUmu9yF50Wjc9K+tnYlVi8rgluYYGYPCjVlwb7rCluFFgUSfOCHg7Qx0W1BONLwC0FpityJKFSE/K8CEomuABVXvvdqXCtimOF6Y6sG8boPjSMWDJ/ErwxiAjqIjVRemmeBRmv9Dhr4OiIh0PJZYdxEarWZ5LJc4lfPimQ13/biQKgQDAZC1Z3ONzuERhhwmJkgLZLA1jOaIs4JLVe0IDrP2qHiLlmpyCF2dkUpZ6QFPkRMbtE8h2MugCPGHJGOMcryFPTFzTwVk28BQnbFOGVCFmXauig2cbLmSNQV9HHdX9WXx11XncxP60VAFh6qW4A3HMccPFjDdsHlY2Xx0uEb094avJzGHsZLvBuK/1yGmjeq14egIkPglDBbR5FjEoE/VU2DG0nMYkzcxlf3jtDiaTMEC4OqQEqqz2DAv4dcy4CIHU+xA3wJQTU4dUaViPmKAqKPWpH1W64EOAYR2zxDg3MK/AY35qggPX831/irMIrYv617ma+c0Y6PjmyCe+/KiOJgKPXrOUGDl4ANmKdyP8XOBkE4Cp2gc754N+uaMMvTkFY6e7PTDIxdaCIEyTqSN9QU5zjZ96v/1/9eTm0Wc1FtXUx6VGMN2ZmzfDMO7M99nSoWE9HWle/NFRwCMscz5feuvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Lorenzo=E2=80=99s current email.

On 24 Jul 2026, at 16:18, Zi Yan wrote:

> On 24 Jul 2026, at 15:52, Matt Fleming wrote:
>
>> From: Matt Fleming <mfleming@cloudflare.com>
>>
>> xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
>> __folio_split() leaves the xa_state's xa_lru unset. That lets a live,
>
> But mapping_set_update() is not required for xas_split_alloc() and xas_sp=
lit(),
> or at least nothing triggered for uniform split path. Why?
>
> xas_split_alloc() uses
> gfp =3D current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK)=
,
> whereas xas_try_split() starts with GFP_NOWAIT and follows xas_nomem()
> by adding __GFP_ACCOUNT if XA_FLAGS_ACCOUNT is set.
>
> Should xas_split_alloc() also take a gfp input and the caller gets
> gfp the same way as xas_split_alloc()?
>
>> memcg-charged xa_node exist without being linked into the mapping's
>> shadow_nodes list_lru; when reclaim later walks the list_lru it trips
>> VM_WARN_ON(!css_is_dying()).
>>
>> Use mapping_set_update() to install both the workingset update callback
>> and the shadow_nodes list_lru on the xa_state.
>>
>> Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=3Dc5b060ce82921a2fd500
>> Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-unif=
orm) folio_split()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
>> ---
>>  mm/huge_memory.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index b5d1e9d4463d..12d0e0b14e83 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4033,7 +4033,8 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>>  		gfp_t gfp;
>>
>>  		mapping =3D folio->mapping;
>> -		min_order =3D mapping_min_folio_order(folio->mapping);
>> +		mapping_set_update(&xas, mapping);
>> +		min_order =3D mapping_min_folio_order(mapping);
>>  		if (new_order < min_order) {
>>  			ret =3D -EINVAL;
>>  			goto out;
>> --=20
>> 2.43.0
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

