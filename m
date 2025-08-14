Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A3DCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02154900178; Thu, 14 Aug 2025 10:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F149F900172; Thu, 14 Aug 2025 10:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29D4900178; Thu, 14 Aug 2025 10:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF79D900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:01:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D9BD82A31
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:01:51 +0000 (UTC)
X-FDA: 83775526422.07.05F9DFE
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	by imf19.hostedemail.com (Postfix) with ESMTP id 976B91A001D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:01:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UGDRZoAH;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.79 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755180108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eh0lIZAv8UqET9TsdWCGcooP8nZrVP5IWt9MpzmE3NM=;
	b=CawtNghgyKgyEGE1wRV3xrkbNz3dxFZCfzYG6imJK/hmliu1JtzY9E9ml1Xi71hnTJ5ngt
	4MLhJvoW2MEtOsTVpqfAv3RNKTvMls9/jyZas3SqqkRrhfParMkkzLqEtQciKd1ysVs+TK
	sD/sjTOOnV1kUJc5J77WIHg5cQFH40U=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UGDRZoAH;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.79 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755180108; a=rsa-sha256;
	cv=pass;
	b=InlYee7R4Ef/Q/Zt7R75688X8dMvode2wZSeHefI1kY//jzbc3n1Brtvy5W6oYhJFfbFAO
	9B2dojpODgOuGD4hTtlngawaM2VeBg6lwKsPYr3ZMN1b0QvrVUu0iJ7y2ZCx4ZCVSIgHKK
	Zny+vAEllc+xBtD2VJ092zOuDASw5Fw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eeIAZyviMA6+425q53wg6Cc3zZAv6YXsV0m6uB5JhbeNjMSeZG6MkIrzpIqKwyF4wWVNPWKLI8GN+I8Urg2O68f7W3MP8mhMkEwxMQOVWYAllYMvSWyPgOsBsXKzp2QIR0O0qdu3HPG1KOsB2aPiYYCL2QjbqZZE0sf0KbdUgbJEqRefpXm4QMLPTrXB3CrJeu6BFUQbPl//f2QRiYe2QNm1QCPqnYhiW3CL2kcxfkhfJ6HQpfzSya9cYNtEAMQ2Qtg3WU8/Hmh7Q+UXCsSzPsJndKWelw2e/AARixiVPC+yrlLgC+5xdI7nk9bUIBYHQ6jZikRXES8wGQ6FoWfBNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eh0lIZAv8UqET9TsdWCGcooP8nZrVP5IWt9MpzmE3NM=;
 b=Sr/FLMxmV5hKMjS6uxqTdorrR9Vq0ueTKOMMjqrhnEl/mbwEahYX7lvhiVbkGgnLXhrVUna8n5HMVz63dhH1Dx1x21g9ZfCX+lS2CeLnZcY8LWqoty7SvfBs5Ix6/vuhkmKBshP/oDovltVKDSKasUFhDCiEfqWOr2vI5JkgHq9yyy4drGdj2hbhQ6ubRxWax+8CiFW80HkIjI5X+dVx88CwNODHbG/MuCS57ZjxYfleUFymABYkJeZr2sMPsq8kqA+ZrM/o8Vwr9D3NSgCMI9yjQS6/W1JmHoAaR/ridNcCZhf6m01x5+MDO/mq9sU1OTEz2zvuz6gfOkptRvSDew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eh0lIZAv8UqET9TsdWCGcooP8nZrVP5IWt9MpzmE3NM=;
 b=UGDRZoAHJKkVlucvhb/nB7XMwg2XyW18VfBSRTb7JyUFSQpL0o4Uaf9Bdn9Jnl+1R4YsDcIFwT1qa4iqBeNflYYP40B38VrdS1jJOsvrFEG8lAUluk8tSjKhaD9NMwNdV/T9fZur54YOF3Q3i5a2fgBboWtddPaHVBdWrTC0M1oMhmeLSS1jcKnvzH6v3gIG+opVSkleGg211H0fRVp82oJpJsiEbW2Ds9HBWf9zlJ+NLt6LvbuWXBvnwWzNxW+Nyp2ZBQyjCModDjheJUZP0Rm6uuYXJwviBFV2UPST8U/4JJGfqFFmOIRBQorhrcBbA0Y3b7cCAGhXVcK9TZRX7g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 14:01:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 14:01:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Remove redundant pcp->free_count
 initialization in per_cpu_pages_init()
Date: Thu, 14 Aug 2025 10:01:39 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4C309170-5096-4794-8369-CEC9DD45F2EB@nvidia.com>
In-Reply-To: <20250814071828.12036-1-ye.liu@linux.dev>
References: <20250814071828.12036-1-ye.liu@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0367.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: fe1a9233-4abd-42d0-bad2-08dddb3b185b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zH2oLv0sCzXlq9oNOvJc3gl8ldKZqOd8nMyx9H3qqYWN7kCAFTdY1l59BiFZ?=
 =?us-ascii?Q?PvaF8QQGD8OT+VSHpjxmuQ9TlVz3O59fGYAwxeu6FQGt3xVhfNbvdhGJwLyC?=
 =?us-ascii?Q?WkqHRqHO9CBhrMiyzBit7zHPfyUuN2iCkgRj1x/zop571ajx22v9W+V//Z9P?=
 =?us-ascii?Q?QieggUGFnJaq+Wxe7rp8IyL6QkqLzPTQmpu3NueuC08Y7HEEJDBzvzG0olU6?=
 =?us-ascii?Q?wNo4KplOxy5YN6VCb96dN4KdP3/tSW+YwZSxvBhs44dfcT0qklBcOBuJHniX?=
 =?us-ascii?Q?R7q1jTNgdSlGs3aGcnwMyVr/5kybQMXg8hDezCtIQF+YKmRlKspm1woamKZw?=
 =?us-ascii?Q?W2dKaBCQ1SlI+gn+GkNUMIZlapOYg+I0NiXXTOIatCV8gYoAHLs2XLZlr4S0?=
 =?us-ascii?Q?2UoaprLk7u6cMv74KaUJL2DLTT/uM/SyS/xWMJh6KjK41Zoei9coJITFngoh?=
 =?us-ascii?Q?6MsjIC6i/yKiC1QQIwA8tmuftV+d27WMsfM1YUDRLN0GFB3dlZLletHYwpOu?=
 =?us-ascii?Q?MIEOrujDLa9iL3FrpLPuWN7/fSHyRrzZrhea/ZfYqieOaPFff0Ep9aMKZmJV?=
 =?us-ascii?Q?2s1X1azjRxC2ew3WygWohq00WO1pzH1B7sq+uH3ajjeOPP67pISsXeszpIrr?=
 =?us-ascii?Q?+E+y/01qQOYWCFELayxj74/uTkjG/dfGwdcZI1NSO9g20bRyRoI3D2EOLYk6?=
 =?us-ascii?Q?AvCyWk1MdWySqsUhHkgrVoAiE3tyoelbmK2q8gcUkX7V1dVBw9cuvo2jTjba?=
 =?us-ascii?Q?s65rLW7DK0f5Nd+z3zAqqdYNuSYXxPT6kqk+/8tS11J3KPSlXB4BbNwid8Pr?=
 =?us-ascii?Q?mAemlBuKtQXv1wZ5XnZbXTkU/095cpMsnNMMkSnxEjayVjtbQRGbxlqo4O5f?=
 =?us-ascii?Q?/VMs1vMP4gJSl7g/kH79eMAmNGH9v4RDds0YB68frL5PU2/XIBj9gvNQiyDi?=
 =?us-ascii?Q?rNkGr+qU3utLtfxwH/eEEgiL91ZlLZ5z9UiKkkW4Wvc0IVpLU0nH3Sl1oojR?=
 =?us-ascii?Q?R6Y5wI3OD26rUO8JenGB5sedtYfXMfYuy9UuaQfYSw1V7LdbqlAH4o8CNPvd?=
 =?us-ascii?Q?Q5K2RwW4hgPgHxqLQZCzJP9DqQTNqFmn8OXqFBOAM7xzNn/Kspk36BEKhI4H?=
 =?us-ascii?Q?tKXSmbfrTZe+Raj1HLAEXJwwwTlb1CHvpTzGrgC3rrbeUvD+zZ8LyL/6gAS1?=
 =?us-ascii?Q?Lz+L/E0hfoDC4lqFOJHwKRLHF1DLLE6SvQC2UeHBoYhVGt+jLHIb5HZG1LiJ?=
 =?us-ascii?Q?+BkfOdivO8y1XNgrUJd78C2w/0reBbO8W/QBegmXvZF8fsXTnziBsokhsiyL?=
 =?us-ascii?Q?ghdWFJSUmtJjmePiyZyIansnjWTLexhlH/i/Lk+Z8wAFDSagl1YzuehzVqrz?=
 =?us-ascii?Q?fZP6ZWik1a3noacnZsuAbszZ8xDy3zFwa/gKN1fBc1PGYd8EZy8I8IMgHvvU?=
 =?us-ascii?Q?/yvtjXSyCCw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xr1ymfkV+Tb1i32VhWuyWYYxvr2YYzy6GohgVa1QNSXpYjqjKVDM907oUTU5?=
 =?us-ascii?Q?2lv+gyYdHVT8vVSnoDH5JcjeIKJ5k9nzaWBVm7V9tW1Ss7paW1p5A1b5GY81?=
 =?us-ascii?Q?kFuyCN58PUadnNnjF5XMVIJg6tIMS/hSi669Hh33PvXxvaTrL/wksP7pgIqi?=
 =?us-ascii?Q?rejUUOS82tEc0rdBSdpC7pnXlHP3/YDz1r57hMBE9cBY58qGi4jZ3QFqElWB?=
 =?us-ascii?Q?EOtqPnc7Tt0GNlO0Z/W2GGCqdSldrMnuIARvOEHAcsQB6V5ddA61E78AGDwF?=
 =?us-ascii?Q?1A4MyQRcIs02sW9WqLpK9SOcS/1qu7Bb1z96jvlzIlNkL7J8v9rqsRtWPrln?=
 =?us-ascii?Q?LttYLAzJ1jtgwR+pasow3n8sReKPRW3rENCP/b4xqNg7LtPPtG5iKNWB0peV?=
 =?us-ascii?Q?L8z/vobj6tRRiHhNX5DqvKTAKFRCMP+hBC3wTzV+rUOs5us5fOBUzV1PpcGD?=
 =?us-ascii?Q?+898dHv+Z8so4yoFufSQQJclTnzTMurfuzszNw1NxDMY447f/9zWMYgDr1VY?=
 =?us-ascii?Q?B7JbiZfz/vHyFNXgcdh5f9VbhZlbOUWFRAimvg+3SQrG5s20fuuR3GlXLDNi?=
 =?us-ascii?Q?yUH+hUahq9GBI3D9SX88B0VFfc32jiL4Vs73Uu5xy4gjjqEupEih4wwi3vaf?=
 =?us-ascii?Q?iiYywG/RWVUYeyu+hXorwDqB55LdG1gOR9mSWINx/dc/5zQ9/4f/3tjLq/ZP?=
 =?us-ascii?Q?ZBPHoyV/sH3rK0U1sfslSLhJinh+o2dleJzePXnkXp8zS7Y0Rh//kjLWsNGN?=
 =?us-ascii?Q?FSoC7qBA6dwNZ9yb0dqCI10ZeAuuZYxB9m+szduwFjJZdKrgyKFE10TZ4k9z?=
 =?us-ascii?Q?8s2areJb4oF+cNZndbI5iMt/CC2hxZ2yrBD+5GqcVXWliHb26/eUKkt1xler?=
 =?us-ascii?Q?Vctl7A75KyCaMY+1F/CF3Zpo7q1D6tLfp3XE5k0b3CrFLDfHlqN7DB37YW9f?=
 =?us-ascii?Q?Cq0PlXz4Wc9KlAG1P6OdPQageWZ3HK9kEvYXedempBq57bOi9qzCA/lz3Qdg?=
 =?us-ascii?Q?+13tpjV0VKWgrtj9KPd/2OnYw/8wMANmOuEKyLcLF0tC6h1bK64/kcARl8AL?=
 =?us-ascii?Q?AsNS29r8m1dUzhzUB9j7tkQpeTEBs/EtmBPT6Si5N3mAsWChKCehaVH3QCRl?=
 =?us-ascii?Q?cj+JjYAMt8m5XoahTOL2skPAnzBiVGoBfMezjfzVWlmcHuivgOIy1PiiAhIa?=
 =?us-ascii?Q?PofLZKqky4EWzhhoSUd0nqHbojAe9XYQ9ftieIeF9IXZGRFNRxDyfJgqg8dc?=
 =?us-ascii?Q?U1FbDRUcyUDZnhOUy20h47K0dyag63EX99sO903JfXgFufucrONgjAB7tFqZ?=
 =?us-ascii?Q?AH8E7Wgpy7+wsw9VrYugN8C/KCRuv4oO34mYDRIvLvNrCSAbzekiKI3t6NPG?=
 =?us-ascii?Q?PoMNIP6HQcZx97tjYOCP3NkjqijVWBmjXDyjDpeiO5yt6exJ8yxno+4g+zWs?=
 =?us-ascii?Q?M15VEGEN2IF5Hqq7qmF3/AARLuUb4IWjB355P6nSHUfQfodkOvrr7SyHDeeI?=
 =?us-ascii?Q?vgRw6aCPbNKQ0qbv1h0Ov0JvT4ztcV8BvmsX1ZWgUEb72NaxoVPJOkWQ0hvm?=
 =?us-ascii?Q?zqoEpNYYkKalQZhKAtLWAH4J7ti6mi1UWAQeUzRO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1a9233-4abd-42d0-bad2-08dddb3b185b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 14:01:41.6144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYfWnKYXWzs+V+tdsyDGK4LtMW1pnAxwaZq5fyiQ4xIoiDkxkfwPqp9TIrtQdCpp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Rspamd-Queue-Id: 976B91A001D
X-Rspam-User: 
X-Stat-Signature: tzza63k1p46pcx7zyco1etmukgztobf9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755180108-977888
X-HE-Meta: U2FsdGVkX19pFMcn0QGV1QCVZxKyBadKZTZWfm/SgrunNrbJDPi0MoTTSZUnJPCbQN9sCb4BpWcOz/Qe4XVt2d76G1rdhgS1Bx8pzI1a/Agqq/G5q7OywUD9xH9LiiFm8vxlAUvXNO4Zv1LBy4DMs31I/bhcOj8FSrC7/9CG+SZNlI8I1OU0ailWNMbJX9k5VOjQmeIpba3v/qB5XxQ6srJ2nuFOL1vgCjj9adnOevdE6j2ZTRuUHyMKPRSv0vUGscWs/XmrDk6kHyzP8FymsFrsPsGGeU5vwXlbOWKPkharzI3O7jTSbFTQGuRNHGtoCKApYWouRXpiLcBrTQEfr6RemLf6xviCwTCZ052U4l9nPMOxbvZjl+5DCUJ91zK9PBSG3XgHK1ZXC3PcIKKqqRrrK1AMwAjHNlbqKdSCB64NpzdOZaXW8SuvP3y5JMFNEKIvBJr4rywyYSYvVtjB4qHW8KGKSYfSvaygMIjAw7SO57/estL2aldS3hvpkcG+6/qbRHJ2BhoXmiy7fjrFK+wzvm6H18M4h5ICj6iFi+4X30PlUoa07k4uKxie78xwSOVdYNk0eHuZCfOK5Wo+utO4kJNrgCjPWuRwi0vZL5zu8+gOOU9cGuM35rb26RpDH17XENHSmleJJgichYL3qfPihUS+daIxY9kbl3sBKySCwduuQyeHFusE5ENjTibsgg4QHANTAzDJrhYml9QTHf/SkQNOtLqLpEw9ESP2OFEjHh2hpGIjaG5ge0Uf2Jg8qUqMTvnG+XRFvdTUxNFwCeQW6M2DUAZ6HIzMxjXpP6ykG9sAX5qY1XY7NluSxw/lt5USNsB4daoRTIx/tfkayOgDa+LRkjRBMy4Jjz3eVMQtMQ981FCCtz0Thf/DRhY5zJ7KYakoabSDt/NSwlSCD9mAedO49vergKeXgmr9vEbI4uVCpSjWRtiGjbJoQdy99yXpJfLKmeaJM8ohYSb
 C1wy1cHd
 iZP5GdCpZBogetjK1+fRpFvmKhqeKZJRFihhz3AEhqWFvk6KeyaVbZpO1TKLeSg3AXV/0zbikLgh4y7sMh8ADW+KUsacx/AqogQCW+cIJh7RMox18QAH6WSO9foZvJTDfZwdmSLuB2i5tlwTJVQk2yMHTwfV4MB9AVIx8znskuZnHm2JZVMcCOo416asec40PPtD5gSvQqItyJB+AcQgOzsFrwMzbbhJg98QRBsJzOz3qehpBpsjeaHGwpYoCYaeNttnF2OTvbEL/ky5VBXmVYzaZlt7pbiUbEuI3AEt+fPfGi8qKrat0r/tLXzgFjRliaZJXxSYDxfZEue7ad33RiAIZ5e2amoHoKar5Fu0Qt/mWu61pLcPhv8vEa9mdN+7gNz02eSiOgKffGPl03LuQ14YsZZsvQ4YyIeFqURcFvipszN4Gk7GnpUSnWI1WjXPvVXZ0sccOYYxJpq4gnl06R6DpViLwuQK+Mqvr6TCYv2clbpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Aug 2025, at 3:18, Ye Liu wrote:

> From: Ye Liu <liuye@kylinos.cn>
>
> In per_cpu_pages_init(), pcp->free_count is explicitly initialized to 0,
> but this is redundant because the entire struct is already zeroed by
> memset(pcp, 0, sizeof(*pcp)).
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/page_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

