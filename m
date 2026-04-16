Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1DF8F8D74A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A866B0089; Thu, 16 Apr 2026 09:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B176B008A; Thu, 16 Apr 2026 09:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A506B008C; Thu, 16 Apr 2026 09:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2A5A6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:57:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52F54E4A01
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:57:40 +0000 (UTC)
X-FDA: 84664571880.28.736A605
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	by imf03.hostedemail.com (Postfix) with ESMTP id 89F332000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:57:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UBPBLxXe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776347857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RIyPpq7RnDhRO3VlXwxN2xN3+lLTTK2lPrz4KRlAvc=;
	b=T7i7227WKlH7XYRsaFy3p1BTizRNypuxAMfRFQ57Li9oD4KRBcOeHtBoGDNYfyFXliXERH
	Rym5712S04udJQwCP/Wi5PX/hYhZrT6avXNc3SRjQPurVQScAx+MxFyxxmmFNPakLcR6S9
	cfobGzVVCIdWDNx37JiMGX3+D03g+qs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776347857; a=rsa-sha256;
	cv=pass;
	b=tnMEMvvG1RCHx78R+6Hwwye9vTkit8hiu39zV4JIdXA9cY36n4qIDneGn0b6f1wDGWPMbd
	dQciR3oE3y2FJGsUy8mLfhG8OlZyKcqeiI4cCsYGvEubrTJAvJeRGswbbZM7cmXMJYc9zi
	+rKukl21l5HmvqRSBhlSYx+tvQ5WPec=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UBPBLxXe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BIHCEHvGPrJQ4CWmDTBlcDgJikQj+sMj/72RF8w1Q58akcHFF99aGj6dqju0iM8ju+h5hbrc4WHXY5/qL8f3ew0r9jNLrPvBHaaZ6BmxlqqJDfO88MRabbR3K1MmJtketnU6W4cD/0Pn+DwBsnN3pw+DtdRHILMWKKnYqzmPVRVBvgpl03u/g1obnqr37nJm5jxSCWO8yuX0J7s6AhX0OPRHHm3JnrPYa8w9J2YB1hbClIIPWNQLIq5ixcj6DdQ2Y/3vXUF/jQIuWwAu+ZxNcY5rEWvAGwxBfuQgOE/LbaFXBRtG/L3Km1nFv3WnJsExIT597wDGpYDqxLQ0HEXrwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RIyPpq7RnDhRO3VlXwxN2xN3+lLTTK2lPrz4KRlAvc=;
 b=AX4k0KLVmAoovzqPjSkeBQorR879dvk/r7LU3fih1RXpkqQJkjOHWowE94mO0b0EWrkIPiKHe+b8C6sMwA87CSuyQV7o9fkMgcjhJdgtrdiA++ggM07NlVlptIbuW95XxFVChUYh+h+HhC1avtvSWo9sy1dTR+zmPzhrcHBEKphUq+9EVvam+Y00d9ryBJ1YZRlhUybmIz/VUeMXrJlEYJEfKqwEHnHc9qcgj3/Kg5gPisNkNVy2rkwkmK9s1GxRHgAjljuKY210Ss3kdVKXY48kO03b31t/gqtGF0QBHgkxF8F8Er2U91yV2ziWZar8K6I1NvxQyDHSQmQ6uhZwNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RIyPpq7RnDhRO3VlXwxN2xN3+lLTTK2lPrz4KRlAvc=;
 b=UBPBLxXetlSrkaXtX11graOwQH+yuBK4nwjSbIQwkZpP2hoSxuqJqyfhwVnWsYMbNJCFJQjbEe+oVoczota4n31R6r2Oc4+7BnCwU5SrbhuTO7SXIK9p+/OUjiJs4CAmWmcOEZmFUtEz13JO3V0ErneU9UCaCxosFXrZwby75KzA2foQ/KtDOUU6LGRRKUxfziF19rAdnXkYO0nUhMCvnih0yhCjqdkEb+r0Ias6Dr7NjV6tjOiOJk0uEfZG6OmObJuXjQgA0D3Yy3Ii2WhXuJnfAW+lKBH2DRjcmCP31mNLDSLHjPOR3pD8zrVht0OxQW8D0dn16ucmARVgwtzT4A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.34; Thu, 16 Apr
 2026 13:57:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 13:57:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, willy@infradead.org,
 akpm@linux-foundation.org, hughd@google.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
Date: Thu, 16 Apr 2026 09:57:32 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <48E18E39-B3D3-4BA7-9291-D9B293CD6CBD@nvidia.com>
In-Reply-To: <82c7ab7a-dc44-47a1-b13d-5119453bc82c@kernel.org>
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
 <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
 <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
 <907b3a20-52b3-4969-8456-bd3a8d2571f2@linux.alibaba.com>
 <D29FD39A-50FE-4EE5-8D14-A7B40E565074@nvidia.com>
 <50a01c86-fbf1-4f93-9557-6e5cc1dd1dd7@linux.alibaba.com>
 <82c7ab7a-dc44-47a1-b13d-5119453bc82c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e91dae-54c1-482b-1936-08de9bc01c4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	l2YBnmsOzwWHngQ/UAG/Qph8+vlfqDVihU9+gsyXrfxvsJ77ZaN/rSW4+14kzJHFFT3exMXawI/56m5WJx+dUyQuRBi+kRZeaiO61oOACIVZ75lXnwgUsEpKetwh1c52WTPzJmMnhuW4tCT5hiSR60uUiqorI1l7rKe5eFkyu57WlJPQ+/mr80qtmWZfJn3U+hRww/Iazy1tZkLt4A72qaCrFuH8VBUtwi1SkOvSCXKBBsEgHML47vd8o3UJBFwJgBS+LnlDcsIkwD9Iw73Juv3Uiv8+T0u/vMPr5oXgVarnZBJcxsNhyMn2ndvBnKXquW3OfzSx78scoCT7mfuYr1Djjmbn8u7cmjyi14ROnhB50VUGsaQ3UwEPbKP6KNvedFihnPyGIRPO1uccxkz0xRDXSW37aDQYNBmbSgKLD628RSx3ueVZhTZ27KtwaCZKSL2Ua6C5s96mYLue0QXCbokrpWCKno+es+ylhLLO7SuqNir0Vbl6Kvri/Zq5r3I+0vBna1/pCIMI/S47ZjsI3K5Svm8iOtW7izE4vN9IVjNTPDToZe0MBufd/qBbOMRg2kylIZ/bt/ykAlZUimg22ghn2Hra2BUJRxwyGdcDwNNRgqf2+b271t/6aUHUEe5s1+6GaaGg1MdAcznc+0fdXQgA7Voqpm5zrfJsnTf/Cq5cIt9k2Wjclhacr1BUTYDFh5R/t9Jo7nBRxEfxodcXmkSIt/LRp1t5h0PhC/w7wIY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGFJUHRBRGRDcGQ5SkhLSDY0L1RMUDBBUm51eWZ4OU1ocTR5bUQ3ZVd2NDZZ?=
 =?utf-8?B?ZHBKWU5LUEdKWVhTaGl5aG9GVGtiN0NzYnlTazI4UTRwbVNML2M2WWl6VXFS?=
 =?utf-8?B?Ti9GWUlQc3V1cTQ3eDNsRTBON2VKbHFIVlhQWGpXblduN3VVS2ovb003ZW5P?=
 =?utf-8?B?M2gyWmlpUkdIR2ZWYjdEMDc3KzBFWDlEc01nMjkvaTZiWE5pT1Q3UFhmdEpN?=
 =?utf-8?B?eTVWY2g0TXNYemVXNDR6UHVUUnFhbWE0WnNCaDVtZnRrWHZaUTh3dEk1bXUx?=
 =?utf-8?B?d0ZBcmNLcUhQMGhPMXI5d252SDAvR3BXemhJRUdxQ3Y1QU1MUHN2TEI0ak9C?=
 =?utf-8?B?ZXczQ2JGNVBkUUQ4enhEV3Y4NFp0eUo4VGtKUDBPNlR0WnpqRW1FOTdhQUxW?=
 =?utf-8?B?U1IxRGMzdFBmaHFST0l4ejBhYkJqYUlDYnFQeUdVemtCQ2V2WEVUVGxPY0Vx?=
 =?utf-8?B?N3M5R1loMFpsR3VZNXJkZW90RkRTMVMzQnQ4ZFcxRWlaWk5KWnk3M1IxUFFJ?=
 =?utf-8?B?WGNJOGlaR2JFRzRaL3k5VTFDUjBPL1NuWFlwSzA0MWROcjVJNDZrdnVEc3Ny?=
 =?utf-8?B?SE5ROG1wZi8yUC9RQ0xCaUZTSVNLR3R5Um90L3RmQ2s5L3pWTy9CTm5TcHRv?=
 =?utf-8?B?VnZsL0Q1MmswSlVCek4xSHpQZDU0WWJjaW9ZamJzNmpsNGhmSXRhb3FkZVp5?=
 =?utf-8?B?VWxNYzBOYVN4ckdhblRyT1JYVW9BdUJ6YzVScEo3K0MxdVFzb3pnMFNSd0lL?=
 =?utf-8?B?MGR2WmkxbmQ3YW9JNXJOTjlYZjRNV1dIYW9RUHI0bjQxMjhRMkFBWThCbTdY?=
 =?utf-8?B?UVNKUjBDeHJwQ1UyK2I2c3BqUFpaOFNoKzFOVFp0TkZZWndFcERtYmF0ZlJD?=
 =?utf-8?B?UUllRUdOVmIxYTdIb3NMcFVTR2tjU1NSNjdCUjltdXI0NDA0SFl3RHkrcGdi?=
 =?utf-8?B?SUc1M2ZseXdQenRWQWdTVjR6Q3pkclhsVTdOOFZISjJuSERUdFhCdmV2SUVa?=
 =?utf-8?B?cHJadU0reDdvWU5rYnpUZjh0Z3lqM2hidmVwWVl6bGhhZjBxdTZWNHdXcDBB?=
 =?utf-8?B?dSt3UjYxUjhWSmpyNWM0NVJMMHMrNFdNMXNEek5sQks2emg2aSswZlo4dTg1?=
 =?utf-8?B?aS92STZQV0FZN0hPS0g4Z3ozaFVUdVVKcmJrTEdYeUF3ZCtEeXlZYWZoRGV4?=
 =?utf-8?B?eXl3RGFMeEo2QXhFOVR5dWNxLzIzUXQ3RzdNeU1ldk81NWF3VElmbWRoMzE5?=
 =?utf-8?B?SktYL0JMdENCeUo0NjJSYmg3aUN2RDNJU0tqVkVwUm5oTzVteU5ER0FrS0M4?=
 =?utf-8?B?STFxaUY1UjFPUHJxcVArdDFWenpWTlFrT0xobU1sd0VkZTU4V2FvL29MQmhL?=
 =?utf-8?B?SWlHdWdPblowb0ZORGk0aW5yUzU1bFZBMWJYdlA4TUlBS0pJU2NlTG40Mncz?=
 =?utf-8?B?clg0OVU1SUdDYzAvM2lzYjNCWk9mNGRTZ09JT2RmMGkzN3RsTm1UVVA1RzE1?=
 =?utf-8?B?M1ljdFAzSTd4eGNBNVo1T2lvNEVFYW1la1NBQ2loQ1JwVURPSUgwaHcxdk96?=
 =?utf-8?B?OWhndi83MVNncDNta0FBNzl5bWF6UnNVOGlMYXU1NEliMzMzbkFZZG1GY3Y0?=
 =?utf-8?B?S083NHhGZ0t0ai9YNTFZRzNHWnE0Z3JjYkl2OE51cDhyUlZtVkVRaWF4QWph?=
 =?utf-8?B?ekd1bzNMMDJtaEJ4ZFhreUd6NkFiUkRDMVRxc25uTSsvNlE4US8wRDMwYnBK?=
 =?utf-8?B?M0J0dDNNc3R4VHFKTGZoT2ZweDRFaDYxeXd4Mi8rRzNoVVBMNDVCQ3NDZU5z?=
 =?utf-8?B?MVNQaWVlemcwZDRXUEQ4TUF1NXRjZ1JsdEx2bXdNYmZJelpxc255SUUrN256?=
 =?utf-8?B?NUV0UFhOMVhkWlJVVzRweXlKSUFWaVRhRkpaWjRVaXpwc25zWW8vRDVHRlJn?=
 =?utf-8?B?aEpIZEdHSlI1TXBQNDJTcU10WGxOdmptbXhTOHBDdDA2cXhVQWJ2V3prYmZn?=
 =?utf-8?B?elhKRElJYUs0K0hwZ1lRTUJIR3BPNklmanJBQU1Gd1k4R2RaQ3JNelhLS3Ix?=
 =?utf-8?B?NC9NTmhkRVBzYTdzazBEZW05ZUR4ek9NclZvZnhlSTFWa1dxNEVkNDN4ZEFS?=
 =?utf-8?B?enhCeDUrUFJUUzNEY3RDTkJDQ09XSG9FeCtmNXJOcTlORUJtTnEweWxCaWJU?=
 =?utf-8?B?SjlvZVZEenhSRGZDQWZzbVNhbGErMWE5VjFleEZoQlhleGM2bHp6VmUxa0Vx?=
 =?utf-8?B?WVZKWGFUWjlDMmxYTzBRWVlTQnUydlRqNzdLaXVCOWxVN3JucGRzRkk1SHhn?=
 =?utf-8?Q?JvuaPnrSpZWmvArOe3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e91dae-54c1-482b-1936-08de9bc01c4a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 13:57:34.4850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycHfQ1ZDIk1o+omb36ixTkeiAc2jhyZ7hO2oynqIYhYs0JyrAYsubh1nqE5BWHk7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Stat-Signature: f7kjpseywo7eszoh5bdp5i7y385xfx89
X-Rspam-User: 
X-Rspamd-Queue-Id: 89F332000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1776347857-483913
X-HE-Meta: U2FsdGVkX1/az7pRPgdoN+YDC7wXGCnPAGNdauSxj5Vvovez03eQSnY6JZfsA0yY16SEA35CBisqn3qQiGKWhG2OAHG2YfSc+HFl64Ispdm8wknvsmTYFXDkBCIzOkVTtRzBch/snjSWxlJ1U7pmW58crWSsWwAxfTadi1pjWfv/EcKWac/uVigDRsEdnUfQJc0n4PtZx+2Ki8ccOVzTXNnW6YnzD5sTlXp4ag8OMOODvUcRwm9VQYNv/tFFoEoy/VBWPtkp3as0ie5NGwEZhocDkF/ORTUlbnMfFBBxbTYwJH5EB98m3qh8kezDhgGNWXrFr50wAUxpo5aaMMZh4oDQrusZPjDQG/Z0lZwFved54uABXBUNcomH+swccpnoKZLMHdOlXEsGrBq1/nl0B8XIHu8J97Cyf/XYhqSnltaM1u+hND+Afocx3slPIUR7hBBPHpCKU/JdE3HkJvyKr5havqPUEdffa4Q3tFHhiFkjSb4VxkT4e+vW5fWrHA3LAm2ieN9GrqLoLxEdfCsQYx7ujat9o9+CYDrjGO6twhEBgV43/dWCCv5WxtWQ7sUrC8cTJF5msLTKDwvlc7EaHiSJtAApQUK4BxElvCB/WRL+uNqhK0k5lLiwr4gCQLM3BUVVnHfRCjk8b7FhxAx5hwbgmT7Lzw+GxcpKu6HbiUZ26pIjgfaSYiQmbB6GC9FadSHAy4DUZhiHFvcfEE2T5iY63oXbCPReWGQzUb8hQTVfk2/xREuwOZUCqiC/8HdWy9BfNuHs49eIuz0tR8kkZEpBAieYsKk233BskTrxYQlPQZLBsKaNcp/0YMr3n/GRL74Pan+uIkOp/QUvaZNJzHr/6FcLiBXTHy3Ta3rIHDueX9+sJoKzwb/EtletJMkjglxW+mWPQ9hfog0Tz91TXCnpkrSnJA+79kD0a8DMbcqXOCnPq0XI+cJxhypMZ9QzsVcKYhhUG/1zYyUdQ1O
 2ZA9Lxx7
 FFlW+Wlep7EziKRUdCvuLsrT8tGN63xiWWTRyQ0IkOmlOftbmjgy2wUvMcN7sPB6lduEHvw6PoS4SfweAEMk4xDbil6Sm13B1df6o+3J1kvp+hNc8CAayplmsnc2J+4ZRRcuzuNAdXm1D7UCH8YpJ82KqJe3qYhEYKsaNIZwsSJ8ZnG/xYwieK5nch7bX15RYx2wu1+srNgXyxT4QQRItJe2+EEsqc5Th9UvmxGkKwB2i1aM4kV2jCfve+6In/5MyOWFO+5kDuQRglmclYGQSPciB8KN38QbV1J8jeUpOC8alZzQunfJktwyw4NVTAEZFA0/N6mKN9P1sPFT58I8agybEwL35pydGapkyfIFBobTWxobdmX/j2Hy+K86pe3yGNb0o6x2AYYTzzEYrj8Cgwba6dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Apr 2026, at 4:44, David Hildenbrand (Arm) wrote:

> On 4/16/26 04:08, Baolin Wang wrote:
>>
>>
>> On 4/16/26 9:52 AM, Zi Yan wrote:
>>> On 15 Apr 2026, at 21:45, Baolin Wang wrote:
>>>
>>>>
>>>> Personally, I still prefer the current fix (commit 5a90c155defa). We
>>>> should honor the tmpfs mount option. If it explicitly says no large
>>>> folios, we shouldn’t call mapping_set_large_folios(). Isn’t that more
>>>> consistent with its semantics?
>>>
>>> Filesystems wishing to turn on large folios in the pagecache should call
>>> ``mapping_set_large_folios`` when initializing the incore inode.
>>>
>>> You mean tmpfs with huge option set is a FS wishing to turn on large
>>> folios in the pagecache, otherwise it is a FS wishing not to have
>>> large folio
>>> in the pagecache. tmpfs with different options is seen as different FSes.
>>
>> What I mean is that tmpfs is somewhat different from other filesystems.
>> We have tried to make tmpfs behave like other FSes, but differences
>> remain. For example, the previous fix to tmpfs’s large folio allocation
>> policy, see commit 69e0a3b49003 ("mm: shmem: fix the strategy for the
>> tmpfs 'huge=' options").
>>
>> So the tmpfs specific 'huge=' mount option is another way it differs
>> from other filesystems.
>
> Personally I'm fine just not calling mapping_set_large_folios() on
> mappings where there must not ever be large folios.
>
> But for every other mapping where there might be large folios at some
> point, we should just set it.

Sounds good to me too.


Best Regards,
Yan, Zi

