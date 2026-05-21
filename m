Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18CE9CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF21E6B0088; Thu, 21 May 2026 03:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9A06B008A; Thu, 21 May 2026 03:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9356B008C; Thu, 21 May 2026 03:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7B936B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:56:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D94C120570
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:56:22 +0000 (UTC)
X-FDA: 84790669404.19.E83685B
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id 824C640006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:56:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZhGs5Vpn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of arighi@nvidia.com designates 52.101.53.14 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779350179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIiW66qx0F9DSyV5uctvgMYRil/LIhoKuBpwPIhOdGk=;
	b=u7iTVFM/+tyG8Qw/WzU33/bF35ozLOgT/HSbhqzhkn1zCkPOnpw2xTk0XZIw1AYTxOClZ4
	STt2haxvxROqUymdqqLDzijOEmFyDqIb35Fr8/FeRvQ2H384wQe7/erDHEN1ga9tzxIH5B
	JNtQOu+hwttaSbtK/JH00gx+GQ5k5/A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779350179; a=rsa-sha256;
	cv=fail;
	b=cgeL8ZtMMWmkWm+DUoJHNdw/7TlHk/IcR2DKLGgMdt9IGhFeC7dOVfIour8v9H0x+EQ3u+
	z+GczQUOpyz1pY4sOZMAexbOL7vE/q+2c1x+uD5MLCyvyHKsnuete7Qc3OQUuFtf0m3UTa
	4dpKOcB21sPYfZ7O/JE69PjTaMy+xg8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZhGs5Vpn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of arighi@nvidia.com designates 52.101.53.14 as permitted sender) smtp.mailfrom=arighi@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXSYp8RNA17TqgUqGoFaBTPBXwumI6M4Es3qjweGvfAXU0KwWHCyBt8xQ+KmqYr0JYMZwopTCtIatdKNSCuXXzUXptpxkq8OzUnt3ljdu1bzf15e8uwsSE0FXECvhcDpLGZPSD28d1gG4+IRQwaFcTNdF3R4bkQeCTHGIM/acfFbQteVEdf/LUm8GKVRLQ9NfILS6D8GCTvSolniXEWqvrhJm5rQrwFQQ/NCXYO9xUCIGFzNuV2wFQeGgFOowJf+wR2FTIEaRnNtpRlA9rluQMRcgTsC371KWRjMWRwtT2OW9bNgy/cZtJunm0yfXMNDfnylc1cU4nTgUPghfidw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIiW66qx0F9DSyV5uctvgMYRil/LIhoKuBpwPIhOdGk=;
 b=LW6MKYZ0FeXeDhKb2GP9fmTjEmIeB0sbIdt0CUpwwJyICenjIPf/mKdzAT5zotuVKp8MKLM2i5QkvREZJOc/szLP80kD3DO68B9Q/AaE2VOf+1MctamBmZKDOlqVhbe+JvHfiueqc0M42ToV6P0nGnYtZteR1Vy3FG3r4099+zxWpgNW/gekTzgWR1ygp13sxpJIO2UpkecJGbQItBkGaqL+B9ZxXir2sBVhWdpyoDCSOydA5ljMkrxVaIXHiUWsWn0mS85cryKaSK4kpOa3PTgEH44xrtXGeZT815r/31+pNulIj4YKXRxpw/T6Oi65wCyD/KSOPf+Wh+AXUpoMLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIiW66qx0F9DSyV5uctvgMYRil/LIhoKuBpwPIhOdGk=;
 b=ZhGs5VpnkvqMKaZJHpUY9FKW9uyQoMNK+hVHtG2WaGa1fIfsUITv3LOdYUVlGePmQOMgQbHqOmO9pIwBZ9KV79/JUV4yjfLL7Pfb3tSnB+Bm5MsOirD46D/DykXNrmKqfFYEYxXd65BEv4Mi1OKJ4gqgSuPp+AQM25L5tN2VnCdqgVHPBNmC9OLkGp4s9QZZOsPoKp4t/SlRd3No6dq1a6u0nOe4DHFaHmCJEGO4m0RqgmsRRnVWA/SkbLB9Zl4cziPs5VOTSphw45TCYku0ocsnGW1GnW6TPf/jJcSUAlYBJpFH61acDNm6VatYFti/ERRsMzBH+5InLwtVAPtRGw==
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 07:56:14 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%4]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 07:56:13 +0000
Date: Thu, 21 May 2026 09:56:05 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF
 arena pages
Message-ID: <ag66lfvACAEAI9w8@gpd4>
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-8-tj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520235052.4180316-8-tj@kernel.org>
X-ClientProxiedBy: ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::23) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|SJ2PR12MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 38d48788-97f3-4b08-7736-08deb70e6e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|6133799003|11063799006|4143699003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zJ7ZyyliXRY8UKdLKHBcehBjLSoLNU5NJbwdSskic3rAVjgLg5cH8+c7sEJDaACQOGr/sut/fo+ZOy0igBQBTHWb+qRmvYQAs7l3cGqjhCqwmcyr57FiFmtB3Aez9JS67yqKnOatEKeqDHpCeH/7usj5Pjos41m0hmtrdZJDamDXMKbI+EPLRom4XDqgEOHXcXhS4bZ2qcdpcfCf3KdiBT83PfuCnJPWvh7sHB+RsRn4/Q8K7vx3BDVCCdwN7vMg3tYxS1ulRXPt7M8Dy0alWnCTuqWY8Yb0ZYoAkTw7Omz8mfXrhFKQ+7Ub6VAHfOHDoPkaair0MS5KTJNxdv8kcA3A5MqmiST/ieexrIqxqv6eRxDrdJlPDx4VECflSb3/qHQ6L5c86UuSmYxS/iBtDoGJnfNHLRR+5TjqCrOgprP7fEHLLPyfvgMsw4d8be7HoFpNMsxamgurqTRRmte46+9cuqmsBObW9SpW2BTZTE28NwVAIcMfQOKyWccRhCZRYSvjoJ9H//LF+woybjvqKxsYyw94kC+AqAY4UKro6bYZYTfXND6jaCCwCPPgWZYWEszBw7xlCxHfW1nnJf5Dxenszu146Jvw8EPYTjx0jXtT5iVxgTyqkrC61PN5TEj2EY/2yFVwMkAafeA7y1ZMMmjrUTvLGj66h4cODUKhotQAHTqKpheJmb2blLnLbsiU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(6133799003)(11063799006)(4143699003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BQm6JgcsbIFN/Mo5fIfdIXN00QYqKz0ObZHO3T0K8naDV0Kath+Ny9f2UWkM?=
 =?us-ascii?Q?2AiJJ87o9QT2EMYW9o6FIluhlOwC3I6WdI+xGaSPDYyFL2tjl2JJffb8rcNT?=
 =?us-ascii?Q?ZE/tWRgPRY5wxeobprX4MUSh+fHGvpN2qy5PwwVnclU+bc93oLeCQDBiEimm?=
 =?us-ascii?Q?waWyoOBFPxGw0AuaRtk5w3mBX8kJFRAI6HYB17Zvk0Bei+S+VAji3fOWHWK1?=
 =?us-ascii?Q?IjZZjm6ogYpcaHFzC7oVJsixDKPk4mJT+EiF8IVDuL2vidrQwNZM7+yswDMi?=
 =?us-ascii?Q?IEmMGhBY5/mEdo/bYLs2DViC6hgFYWk7bPSUzGH7eNwS3Kp5moS3DunwMxTE?=
 =?us-ascii?Q?VbqRj6hAjFPABnbrub74oxufBfLnzUfisrvmlZcJz7w4ssywa6L/UX+kcfPf?=
 =?us-ascii?Q?VBy9KkMD090ea6uVHnun49KXtdY7oLq4T6rEOoCc8m3FL32pAihr8dKXe7ef?=
 =?us-ascii?Q?oWBmdMld/ILue76UpT4CFd4b9mDIE1cDm2rpzMXsBJTVyF0DOnzfk0xH8Wku?=
 =?us-ascii?Q?rtFGJ1pc0PvDW+2/fd5LxcYX4RiCNugV3LZmIDRv/zqXbgEY/rdZ4z6g2QTg?=
 =?us-ascii?Q?KrcPMClza9eXQ0I5wlhSy4BqYKU5BBNinBUU12N+KcWt+FPm41ai4+QylW0e?=
 =?us-ascii?Q?RfYvQl7dP20VqGPKffs/oiuwyanFM1CB8EFg/o1jUhAFGRbgEeGtYO0K3pFU?=
 =?us-ascii?Q?XtMGDyAFD14fXZbSbf2NZrQ1mFme7ByfOYnOVcB6dfz6Heg1EJsA2eFh/Yru?=
 =?us-ascii?Q?iTzPHIbccTwvpgi1hqMibptLaNTikbhxtgAc/ILCC4D/n8Tz8n8yPnzWy3Dq?=
 =?us-ascii?Q?SYn4LRM1hbgitgu8oucXz09Vwb4Z/OsKYx3MdcIyem3lglLwvNMw0wDRy9IK?=
 =?us-ascii?Q?wLyYjmyEDt7g43IRk2LPBcD5ca1scTNNRSgtEXgGFRWHmcf2+fmcx9jVUnTj?=
 =?us-ascii?Q?URB6SdsSbxmWSZSxcrDc+1XXHt02yFQA0EPUHp9onV5EUpG8ETMN5dw3c4Mb?=
 =?us-ascii?Q?oTHMKZ880slk2+rDa3VJq+gAoJ8j8hrKRzi3uePe1mGigCaTB7TvdBiVg5bH?=
 =?us-ascii?Q?3EBvBfebqHav7ZLhzHFFSbnE+vjypm7HEUwx/LUi6PAan0JVHtbXd9tE72uW?=
 =?us-ascii?Q?ctDSeKSTURWbT7tB3G5r5KCqIvaaPEFZ5xjqoboN1gHJJKch7ZjWiZ6gdwYr?=
 =?us-ascii?Q?O+twzK+b+4EuYGaE4fRD7f6PxgpBVOKwNvO9/3yunUBEVC5qxvRRNqBcqKQp?=
 =?us-ascii?Q?E8QMPzWmzzJyqcCCrlgkMTbhphdqmGF9jFNjk21xRkbk/YtrcIo65ioY8anz?=
 =?us-ascii?Q?thHzkVqqe3mzb2fFtCm6gFAeB7vw3/rf7O9YIRq+gb5HQzBFDQWci9RmxodV?=
 =?us-ascii?Q?z3pTqrNybzG5NvcMXYIaHbEBasaA1i86v0dha2mCXO90nyrC3HQVMPVy/8wF?=
 =?us-ascii?Q?kDw7oLIuSQpnzq36AfF6p0A9AktkeFZBfU2gvcgol+S1c1jLwSUSA4ahIuci?=
 =?us-ascii?Q?1e5NaDyP0tqr9qRNonI+4LccJnE4CP5Q0q9ZLjgho4UjOBKs3p8fPcoQ3t7Z?=
 =?us-ascii?Q?DDigP3erfQmlab7fTCZH4+2oCUbv+2fPezPUFoaklKRuIZHyzh50g+IhC8Uo?=
 =?us-ascii?Q?8ggHJEVcjTP+JHgH9b10TaNgDGO2dpCyyTsRVxTBuZfLKN7gEJqNK6ujqq5c?=
 =?us-ascii?Q?2toNFQh2lgkdUPPawjgjrwyHOdJe4+/Q42KZrIL+ozb+Raot?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d48788-97f3-4b08-7736-08deb70e6e07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 07:56:13.7977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+wBdQ/33wh2U0dK9vgbo8i5v67O4qztBcxhXHy4klNIQSfeRCUcvDfRKmjrfp9icvrpSiesO4DTJjw3Ld9Ohg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 824C640006
X-Stat-Signature: xpstkmh83esd8z84fn7xyeuph5x6zdq5
X-Rspam-User: 
X-HE-Tag: 1779350179-847577
X-HE-Meta: U2FsdGVkX1+YyaSkt5zFeNEGCgoLEEr9M8eUVy+fznFQjqkcNawhMdXMlhtXwiEpl3FEf5cJ4F8LZ9xPPH9CBp/G0Ab1FDEM7hWaCH60HVN5L28qxjBZz/hvGHD6OwbRCQvS7dxDZMnu7cIkM9raqLsmjM+xpoP9LrT8PJPxZ+xgi0qCpZqn0V9zuSO6ThO/+xd7iA9RXtrn7iT+zJ+6CWar347HBUiIIubcaLuyotLqsnmWsI+hqMbqhQJtsG6QMR3vVtvq9IWObElVNIcZrKkIsIafJZSHTeZ2rPWD32sLcEUlhm/qcmDm1+AhPEapCRlekdS9i9hG0T9okS2rQrEz4LhXblsiRwIlnTjcJTvysXUnHUOv+m706K8NNw5u79Zd3erBZEqupS0rcRfTCICJppzaC/Yd3/oTNaGahWrPTGUVTt8MjSN5uZse+vI+xBt8LNK3Kd0rteWj9clc1bc10j0DsL/79+p4O6u2KvTu5Z6Peg8bTZxX+TMIv6EUYiOSvAj+FMxL5y9i5RmXGVBFg9df/N9mmtq0CljcmXNC3+YcsSnySq2H/HttbrIV87HvDdHkS+pIVHKhJd5JKk+oCSnzEm3wlwoI5WZ1iX0VdGybHAVH4z2vumL0e6SuQUkse2874UI6CZRNzaY23HIcHox0kYv51NYz+SZjEj9Lx/Lj31tNJpu1Wl8y346aKAirZTWg2CE7Tv6/L7Yf/QAPbi9yCE4hMeGklRU/hmcbC+yjSh1vNLLbdu3UWZF5Lkcee0RCi8yvTJfJlczsDEIKY4ccFP9ha03XaDvJAFU+24Gxt3T7twVni1DPig4jWOl8WosILYqT0MDPRN7w9QvhJjZAMetPQDGiHmZgEwZjGJgAg+t51l8nAQpRQf7DFSEuY9FZYbRGQLVRux8s4zQCNVZWT4AcoemeMzod8G5Nyjkjshvt/A7ChAAJ8ygSQtGE/oMu2VofB75Tiio
 hByA5ij5
 TWLV8Dl67crnY/Q/T/Kv54ume6fSU2CUC2yp/Pfth/Tqcqo3MWtaZ/kDgAfeIw7jC1HhUKKSLriRgzFl26A/yLaxYDGU1g07FknCDlBSivjTB7RYiE4cOFZUNFhtEG/mGeW0AZjJNd19JZuXlax6y+w0p1Y9Ji6JwZVef8/pZ89svtd1XU/K+mlTTCZrQQBsurEjLbvq57Q6PylcUNkvDpyPxxBoGK4oMxXsR5gFrTDrM1M3FeXcrwGkUwWhW78HheQSC9usDNQy8tEdOf3ERq8f76V7apUxhy/Y4w5vScyU2m4kjqTqhLvBXruOH4QQ9fTVsl4RZjvRc66hIKGayssMc4WZLYWqYhu/IlTk03GjTaWymS5GZcwLmU9CCeer6+0BZ/WTj9Jh722gPQfB3Qdb10mrO5y4VFT1rAwY/y/8E2H+RJUJz6zT6bhUghaL32L9haikc3rL4HteXblz8ak827vTsj6Z/DC2lceN/AjpPqY9LeptE7TFanOoWVi/LZU7f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tejun,

On Wed, May 20, 2026 at 01:50:51PM -1000, Tejun Heo wrote:
> Build a per-scheduler sub-allocator on top of pages claimed from the BPF
> arena registered in the previous patch. Subsequent kernel-managed
> arena-resident structures (e.g. per-CPU set_cmask cmask) carve their storage
> from this pool.
> 
> scx_arena_pool_init() creates a gen_pool. scx_arena_alloc() returns the
> kernel VA. On exhaustion, the pool grows by claiming more pages via
> bpf_arena_alloc_pages_sleepable(). Chunks are added at the kernel-side
> mapping address; callers translate to the BPF-arena form themselves if
> needed.
> 
> Allocations sleep (GFP_KERNEL) - they may grow the pool through vzalloc and
> arena page allocation. All current consumers run from the enable path (after
> ops.init() and the kernel-side arena auto-discovery, before validate_ops()),
> where sleeping is fine.
> 
> scx_arena_pool_destroy() walks each chunk, returns outstanding ranges to the
> gen_pool with gen_pool_free() and then calls gen_pool_destroy(). The
> underlying arena pages are released when the arena map itself is torn down,
> so the pool destroy doesn't free them explicitly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---

...

> +/*
> + * Allocate @size bytes from the arena pool. Returns kernel VA on success, NULL
> + * on failure. May grow the pool via scx_arena_grow() which sleeps. Caller must
> + * be in a GFP_KERNEL context.
> + */
> +void *scx_arena_alloc(struct scx_sched *sch, size_t size)
> +{
> +	unsigned long kern_va;
> +	u32 page_cnt;
> +
> +	might_sleep();
> +
> +	if (!sch->arena_pool)
> +		return NULL;
> +
> +	kern_va = gen_pool_alloc(sch->arena_pool, size);
> +	if (!kern_va) {
> +		page_cnt = max_t(u32, SCX_ARENA_GROW_PAGES,
> +				 (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
> +		if (scx_arena_grow(sch, page_cnt))
> +			return NULL;
> +		kern_va = gen_pool_alloc(sch->arena_pool, size);
> +		if (!kern_va)
> +			return NULL;

IIUC, since @page_cnt is sized to cover @size and the new chunk is added empty
to the pool, gen_pool_alloc() here should always succeed. Should we do:

  if (WARN_ON_ONCE(!kern_va))
      return NULL;

to catch potential logical bugs / future concurrency / exotic configurations?

Thanks,
-Andrea

