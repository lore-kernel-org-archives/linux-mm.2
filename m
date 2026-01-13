Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FECCF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36646B0005; Mon, 12 Jan 2026 20:27:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E0E6B0088; Mon, 12 Jan 2026 20:27:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC0F6B008A; Mon, 12 Jan 2026 20:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C99946B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:27:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60E061AEFA3
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:27:24 +0000 (UTC)
X-FDA: 84325202808.23.F81CC3C
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D933140011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:27:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QY1Tkwqw;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768267641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZAjWJMu4EisdkC7Z/zTmBMAkevkvV3OaqJ448lnH8k=;
	b=q2D0ofcDfTHRw7I+G6p0FiJvhNU/gsCBgOYZIe5eOKuYCBEJNbBXUYy2KhBfpg7EagUJFC
	/+5jidIFt9S8xqCV1YT7bJqL/0khptCXelMRWVlOTwAAwifx+u6efdnpFBCP3/oopD9y25
	XJg4obkQkGKZx4fQAZb1hzEfZEMPtkI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QY1Tkwqw;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768267641; a=rsa-sha256;
	cv=pass;
	b=qbOGZXJiVdzq5u5aWuPq95t1S9++FY+WfM8IXDR2KHKS9nCY7jfUSPYrzZLrPipVv6eaZd
	1QyTP/VEM/qndQzCW6gmenkMHtXUQMmzYBn8P1kCc+a+E3X0+j0P8dN3iEef5ET6erAf7S
	PChYkQ/mySC6E9Q4saIaVijIO5X6lc4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tg3LrfnKMZ/wXnG4KnlR2n/UQsY3G6TlJXHQim3xrn77l/xpYGrHGPU9po7YfEyQIBhG9wN0vIWNcQmlIuf0mBQuN6GiohEizpGXP3m57qsnpQMKPkDpckIxMEA/wjxsiFVoImZCYfiqG2itcuzG/xApma/+B0NRGxF2qVTGOZfdet9I9cZrB28oexqrEDNd/PUZEUpj0rC6o2j0P+wQeRpylGrRQqDAiA9QYk2OVZ5ViypUeyr2hSNgdG6FhBkxbkI761WwjO01Hibku/IEklhIlEaWI30ekhKVWqV2wY0tswT8Q0UWv8zw1geRJe4rxUPL6DyAcd0LKloPULUQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZAjWJMu4EisdkC7Z/zTmBMAkevkvV3OaqJ448lnH8k=;
 b=Ep64XWXeMwksZcnJR8hsmO87uvxHzjINpf0S+8oZRBYOLXt5OVggNp50ymE2kuQWeS0WItZZU3k11UVu2KPOZ1bC23Hl95ptTnA1AwNKhUguXtW/RU7vpC7eeXgWa7VVcJ2H/64SS9G1IzKnkGmxKs3UsRQiITvL/6tazaK7DLu30X8nDeHwyP71YeWUI9wGqcZXlkkdBi3nxd8t74xbMghBl1mSNp8qnFrhiQxmsDciFJCv5xPeAnIfOiVO/hlJ5oY7qqk2N30xODBDA8VL8UEgqCHnbRFCm43OypqM0W/PjpeC7LMih3cOsbSDfGj32dJwW8Ms3Zm0bb1Ubu6S1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZAjWJMu4EisdkC7Z/zTmBMAkevkvV3OaqJ448lnH8k=;
 b=QY1TkwqwR455HdQwYXwB49Itp12NcJgxkNnGC9RByc4UdFLYKoOlCwEPPpwQJTZXsJAbprUjaYbTm/KN8hV6Onzcy1RvXYIU8c0gZxbhPonTtPsr2vDXhfoxJKAybEFruK9rlW5DDPXxm/AQWDk4TP4h6qzgn+bCT0SsT8gpHP/lqkB4igWnxNGN9Np+vlFkC2QVUhAUkfxm9FsB8aBa5HSgK4GO04+nEA9OG8OX2ICiJX1rMNkrMV5/554+piI8DM8yiiHKtd4PkoR8NjXk7urXSREaTW6NtQxbhV3spSQ6mum2/Nm49bliJ23PQP8dThqTp+SGhir9GO9HhFEaCg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV5PR12MB9779.namprd12.prod.outlook.com (2603:10b6:408:301::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 01:27:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 01:27:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
Date: Mon, 12 Jan 2026 20:27:15 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <9FC904C5-1C5A-45BE-BE0F-556AF573AD4A@nvidia.com>
In-Reply-To: <db7a38dd-77c5-4adc-b0b1-ceee45fb1f51@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
 <926A149E-FE2F-4F88-92D6-FA607398605F@nvidia.com>
 <db7a38dd-77c5-4adc-b0b1-ceee45fb1f51@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:180::39) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV5PR12MB9779:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5c3b71-fd85-4fc8-8130-08de5242e497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGQ2T1JhMWJaaWt6WThjeUVuZG9iNThSajFGc1VkUFQwVGxOUUtoNUNpOTB1?=
 =?utf-8?B?VTI1ZUJERVRTRG1RbXB0Zi9VVmtWUGJMSFlLLzNncjdZM0VCc1hJbmJ5Z1Ba?=
 =?utf-8?B?N1hVR0dVRFRXM2JnajNBZnYyRC90cVovVGMzYWdxKzlXQk5PU2ZEU2JlUlRU?=
 =?utf-8?B?RkVUdE9HT0VsTXovTUVXZlBaSUs0eWJyUmFQTzUzTTlkMkNuQy8wWGtqWDJk?=
 =?utf-8?B?NU1tdUM3ZVdwelBPVkhpS3pLU0JLRmlhQ1JoVTJ0QzJITXJXN1MwUDAzMiti?=
 =?utf-8?B?UFNROEZjSlgyNFJMNmlmcmNoS1UvaFl4YnJnR2pvZmxWVXM5bmpwMGRad3VZ?=
 =?utf-8?B?RmRZaEtCZUFpNHBjNXErTlN6OERYTXVCWVpxeGNoLzQreXV4RC9uODRxUERZ?=
 =?utf-8?B?eEFDdWpFcWJmUXMxMjUzcUNvRjVEMmZwSnNUc2VYZ3orTm1jdlFTZFNZdU5n?=
 =?utf-8?B?TFdyNTQxWUtXVFNCWE95Y1hVWHFxVkFqaXJIQTVGU2Y3UWpHSlZmb2EzOHFO?=
 =?utf-8?B?bkprUFg4bCtoTkFxYlRLcjZIOVlHSG5vbHpJd01VRWhwaElqOFR4MGcydDU4?=
 =?utf-8?B?MmtKV3U2MnJxS2JYTFpkTFNjRTBGdXkzRmdCY3lFRjRFMG9sVXU0UHF5M3lq?=
 =?utf-8?B?c3NjR3RmZHB0cUNqWE1DWlpBdm5BM3Z0Q2g0clR4SXVWSHR5S3pFMTI5YVc0?=
 =?utf-8?B?Zm1lV0t5ai9rbXYvN3hLWkdyWitINndibmltTmZ4RUNSVW82MDd3b2NhWDls?=
 =?utf-8?B?Y1AvMk4xMnRtSG43UmI4c1NXM1Jva2NFaXAyQzgxWHlUYytlNFFidy9rbTZN?=
 =?utf-8?B?STIybmNsZjNQMG9TSXhDMkNsd1lKaUJab0x3ZDZlT0ttbm1yODE0cGVBNFNv?=
 =?utf-8?B?STQ2ckh1MHJYY3ZFWU81T2NST1ZQLyt1dzRqb3JDNUhyTjAxV0JIWERKR05a?=
 =?utf-8?B?R0F0dXAxRnZLRHBnMVFRKytsTHVoYzZFK3lxVkovNHdzT2ovSTViQW1GWDJO?=
 =?utf-8?B?VzBweWtjaWRWSHNnTjhocTVXSGpEdUxxTTRaNXRYSHY4ODc1bS85VlpEc1NX?=
 =?utf-8?B?cGdoWHprOGpjSExCdzhYQWNWVWExWllUSWdtaG9FS3FNL1NaMWVhS0FteWw1?=
 =?utf-8?B?WHZWcFZBajBTNEZrczRHZ0lkQ05WMmlQbUR2ZmxJWkVzTEtmRmRpK1dwWFpy?=
 =?utf-8?B?akZnQ3NTU1ZLNHJ4TGNCWjdrdkpFdmJ1WHdtbGpmMHBob2lxZmhjaERpcEhN?=
 =?utf-8?B?T0pvU0tHN3R2MEhlR1FXWGxGampROUVsWHBoTitSWCtHTURhSU9UbVlvK1B0?=
 =?utf-8?B?TmF0WlczN2dHNWJxL3B6TWorNWlBc1ZtV0Rhdlk1RjBWK0tQNkRvVGhiakJr?=
 =?utf-8?B?SDVFQmQzSTlZb3R6a2NpYlhCcUJ0OGhLWm85QkFnSGhmNHRsU2k4QmtHdVRl?=
 =?utf-8?B?NFJjNE8rUWs5QkRaT0pXemJVcGRrd1l5MUVsang3T1JKb3VmM0RWd29iOVRx?=
 =?utf-8?B?aWpsMFc2RGJsZFBReEd3VWF4bW5hdnNmUFpUVHJZVEZyLzRFa0x0cUwwb3oy?=
 =?utf-8?B?anBsdEdOZWNKVkZrYkwrdjlCWWpOVHoyNXVRenNvc0I1U3JUTDVHek9QbE9W?=
 =?utf-8?B?T0dPQndWUGpXZEJkMmZNTHpDeXd4U3N6alg3NWFBRmxYWXdnb09DdGxqSElC?=
 =?utf-8?B?dzdrRmZGMGJnTnd0dzNEa09vcW90THBNaWRYU3hGMWlSVkU5YUl2YlNOVlVj?=
 =?utf-8?B?d1F5ektUeUdVUU1NdlJ1eFY2TG5yeHMxK0ZvYVNZRStPVmxkQkRidzZ5OXRP?=
 =?utf-8?B?TXJ2Q3BiN0I5ZWF6cHFmSFdHam40cDBOaS9yK1BLOXh4RlpFYm5BbXZwKzR4?=
 =?utf-8?B?Y0x5TGhhT3JPb3dldXVMYTVhQzJMdHplUkZZbWxuK1ZuWlE0dy9hcmNLdkNy?=
 =?utf-8?Q?CJVWN+2U2+nFT1doL+wrckjAZKmuMNRz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEdSYkQwUmJHY2hYUFJOT1RCTngvSmZvN3B3VkFqdE5iY2lZSmRTVnM5ZFl2?=
 =?utf-8?B?ekhkeXpGUzU1WitQaFUyYlR6NlRiZkJ3UkJwbHYwdzJqM3MyZC9iams4VURB?=
 =?utf-8?B?Mk5IM1R1YXhEcHBJdDVwb0ppbG9ZZzZwbU8wdHNhd2NoVnIvV1YxR0k1aFUr?=
 =?utf-8?B?WmkyN3NVcmlzUHNrUDVodzFjLzF5OUtqTEFWS1ErbTg3TWwyamUvOFR2MDlC?=
 =?utf-8?B?VnptZHBtTEd2bTZLemVudG9tTTFaQkttVjh1VHdwUGt0RXA1cnd3UjlyVnlR?=
 =?utf-8?B?c2lFaEhvejBZL0JTdEcwMW9pUzg0clA2aXo3NkhuckVqMk8rS2FjUSs2U2F5?=
 =?utf-8?B?TjZKazdteHZNYTZWY0wzak14Ly9jajZnRmNUMHE2b1IrQ2E5OTJyZGtuTjZE?=
 =?utf-8?B?Vmp3RHBKSk4yMXF1MWFvTUc3ZGM0dHdNdEgxbGNHaTB0enJ0SnFEZmdNM0Ja?=
 =?utf-8?B?d1hDRTJ6NWFlaktVbDY0WkdZVytTa1hFY1JhTDMzRldUa1FMcWNxL2dUYWI4?=
 =?utf-8?B?ZE9UYngvRGRNNWhaY1RiQUkrNTFQZnJ0cUlwa0dTN0pFWWtCSUJWcks3QTI5?=
 =?utf-8?B?bmFoVkpsUEY0TC8zM2kvOGVjbWpING1kU0xDWGRCVTJoUkM3czZsVlkrWDVu?=
 =?utf-8?B?OXd2MVM2eno1a2d0TEE1eldmdWNVWVhZZnlUU1l3Qi9YV0FDaEpXKytpTWtI?=
 =?utf-8?B?aHF0Vm9uSGt5TFRhUThSK20wZlo5SVpJQ3JSQnBDRTgxUEM2ZzNycUhpNjB2?=
 =?utf-8?B?ZzFmY1NFS0JXeE1YT1h2NWI3TU1Ca0ZNTExSOG1scVRKRGY3aG1lczVtTXFq?=
 =?utf-8?B?WHRVemM5bWhsUHdGamY0NzAyaHlGTldkZVdSK3lMNDYyWVpZbk9QVFhSWE9i?=
 =?utf-8?B?bzZuWlZkRGdWa3BqNW93ZzhXUjRtYnJZdVJ1WlJNSk82SEZ4ZnRjTG83Y21K?=
 =?utf-8?B?QVNwclBBZHRYaVNUcGlHcHJDMCtsSDlMRXJWaVJPM2JFeEtacHI3cGhwNmRv?=
 =?utf-8?B?ajdtSHBndUZhcndFdVFBQ2Q3MWNHQWJjQVBnU0JROHFRaE5ZYWExaDl5RElZ?=
 =?utf-8?B?T0IzOHFWTm9sRGNxdEhlWkgweGF5V0dBdXNaUW5BNHNmNzF3SW1Fd1NMYXVH?=
 =?utf-8?B?UDhRbEMvU0dMZWtJSGNxdTVEVWtPeWI5M1IvTmdYZ0YwL1NaaVJET1lBa1Rh?=
 =?utf-8?B?d2VKc3RjN0djakFCNU1XbmgrL056UVdUb1lIYjEvdTNPbHNHb0NvUFY4QU1G?=
 =?utf-8?B?N1JqSjM1bDc1VzJTc3lPVEJDd1hQSk9EODdmeGNnT0NOdVBlZ1UvR0JIMnQx?=
 =?utf-8?B?UWNMczByUG8rRFpaR0h6d0k3QU9xdkVJVGxvLzFyR0I2OWlWVkhpRzRFWG9l?=
 =?utf-8?B?SlB2ekd5Z1pxclI3dmdxNllHdHZwbURmUUZlL0h1RVhjRFNwa0R0eGM3RzdL?=
 =?utf-8?B?S1p3eWFlR0ZDaUJaVnZpUFFOMXlHWjN3NW9oVWVoWVBQVVRBUTA3Z0lDcGJj?=
 =?utf-8?B?bk0wUmJvRnZOSW44M1kyRG5oNUI5a3cxYVIvdHNuSzdEZm9pckhseWJ0V0FO?=
 =?utf-8?B?MzJWc1NVK3FGZEttZnFoak13a21QK0R2bmJ5aVRkTzdXOTVrK0pBYkF0SVFZ?=
 =?utf-8?B?TCtmTkxVTndNVm5kNkFHV0RVMElJaEhydnpUa2FSZTFWeUNnSzl0MjVoWGIz?=
 =?utf-8?B?c3dKVW9OZnVqM3crbjNrZUFPZ1g2YnNIVDljd3JnNVoyeU0vajhIemtSQkk0?=
 =?utf-8?B?bzZOdTM3aTdYK2p6QWFJdUlLOTNSWWpXOWVHRWNDbXY5WldEMkNUWTh5WlY4?=
 =?utf-8?B?UnZrOVpZUFY1N1BjWkNsTC9wamFmcUcyaUpHdnBKbzloYkExOWRwbWI3WE5L?=
 =?utf-8?B?SDVROU5INzBwVEZPdkFpNGRTenp0N2JoNUJuam9VdWtiblhoR2FRNS9MQ3g3?=
 =?utf-8?B?cCthVVhBZnlyaFl1cEVFY0FJaEZpSzQveUZSS3N4ZVVqSTQxcnZtMEJJdjB3?=
 =?utf-8?B?bjBxUGtjY0hzRmpRQytTM0RqRlhSS1loM1FtZDVKZmVURCtGVlNDWC9OMS95?=
 =?utf-8?B?WlQrRTRkL29Talh0UFJpaEFQNHlIWVZaTklhL3B4T0hVbHBKMDhjOXk1VHJo?=
 =?utf-8?B?K3RBUkFQUmRSUVQxVkNZT3A3VnhGL2xYQ1VzKzM5TjE1N04rZ2tKU3BpWFNm?=
 =?utf-8?B?S1ZsU1NGSi83ZlVnN1ZkM25BNzZKNEdjRHlsKzlNOEVqKzZIdXdqLzVZS1pD?=
 =?utf-8?B?QVkreXFQbUpLeTlyb3c5U0p6TEJSL2tyV0tLb3gyVVpuOWk2OWNhU3lLSTJV?=
 =?utf-8?B?R2ZLZ1ZnaVpLUGRyOHFsOXI5ZlJTNFFyOFNGRTNtbi80T0M4SlN1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5c3b71-fd85-4fc8-8130-08de5242e497
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 01:27:19.0729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXA6RzbfnlIzgPX8U8y8Rf5xiK1ist4S9WrMnSx0jeq/Ikw8iZMx2bjq20X5cruA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9779
X-Rspamd-Queue-Id: 8D933140011
X-Stat-Signature: g4yq5itp3aeytbxh7feyx9xghxj4wf9z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768267641-978093
X-HE-Meta: U2FsdGVkX18gkUnSLDPiGPKwqKM623RsauycBDpag4LFPzSg71Dg8i8Gdq3qC7vsRjl0km8z/K0Zas30hmWk4dKLdsEl0qK1bhawyfTcil/GoX5nmQbfoY24SX+PneArmDtQROZUf+KPP+OteSTSNzpqgdN7/Fmhq5l/nnFwenC1g9ObF1Lwap91unJDP7jZ8TKFsWvPmU/Ln4WDSb0Y+B8nE3UxphwMbuUmuqa9Oa63JZiSGapcSTeAgG/NvmZaEVbXEa0F88Z8pLCKppKmm5vttrpV8fbCGFAIRPp8Okt+c80tiZW0qV16mLWUX9dW/5hqYBht64LoX9fVDNd4zCB4xh05FkT31uMha3UDOSBoRL1lh6B5puokehjWkDXeydC2s4izuQfc0SXUi6AwsEakQusxZAz4K1azQB4A2lRdl+vs8R2Ukm8LaAJw+uFqNDViJTVSjrL9LPJ8pwUZunBiy/tAh9g45RQZKCePl0y/3B0Jvf+WcvkmswHUx1GuEcrukILqxKmE5zx8ORlR9j9Lgj1vtoEcRiHZi5u1Zc15IgVh74IoggTjhEt4L+20LLapAgZUuZef7vUfjsyIjkRy6NU4wjnBhRhCjWBqSV549z0usBBAFX9jNMR7WsPjZniJNUXvuKmJH0Kz5duDhzNDyuqIpXx91erbZWuCyrxIHiqINcO2zNaB/8NxzEhSaatcOfvl1DHFIrJdeHkknbrt6rQHeELwKF7BHX5oeC0HozktrSXt0IskKXLHAzLZHuiwi7k+eE6nZN6i5P/wwBScruS8ol9qpD0kgeQxOmKXMbxSWQb07FltiR6w7wce1p6tFbtD9VrX+b9Sbx2FhBiOtNE/EddNqd+/TVh3eluIyEnO0TUPU83KcWguCygvcKPMKguYhoJI6Z5pBEkeeNBIkSf+rOOgB+YfftpNika3zTvfgygVZWR11fJyeXYaJGoXIK5s+Q0Rye3dxYh
 xuRIVG7P
 mH3gLmMOEIi6FVYw+zI0/WgqnG6ZN6stRzp4v6qLuxhF7u2hbrH9vkO+JLXWGJ569hS+VnPzwrD5oNSzHTCbdQ5KIAMMu3/QhNZ6Xb90wa234I0paTq7QP8QmQlFqPs48tdERVWnMf/Y2ret95YkcQxiBCE4AtosguBq671W3lJVr4ouJj08RuFASLncAruRWQa1XWs+c8p/Zan7xKzAlic3tckcoIy7W0dLZEUa0DZ/MbYY8OXrURH2ar2MtxR56dKPwdQcTHUpLOa6BAQ8jZCPZtyMobBlT2/bnlEriVQ0pZl9mBB1EOdTtdxfT/H/YIjoULsMYQJbzchgcoB50+X4qIOmjrxPVQeWPon+x+7B63HFWRuS5iZB5a06Bqepjq8QzXVFu5nAcIK0iB2P30bXJjYfpeeubHP/3rnsEaDrPpCYEqJpKn9XeIIJsN1LEMw1RIs2I8aIOh9JPfUKuYGaz4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 20:24, Kefeng Wang wrote:

> On 2026/1/13 1:02, Zi Yan wrote:
>> On 12 Jan 2026, at 10:09, Kefeng Wang wrote:
>>
>>> The alloc_contig_pages() spends a significant amount of time within
>>> pfn_range_valid_contig().
>>>
>>> - set_max_huge_pages
>>>     - 99.98% alloc_pool_huge_folio
>>>          only_alloc_fresh_hugetlb_folio.isra.0
>>>        - alloc_contig_frozen_pages_noprof
>>>           - 87.00% pfn_range_valid_contig
>>>                pfn_to_online_page
>>>           - 12.91% alloc_contig_frozen_range_noprof
>>>                4.51% replace_free_hugepage_folios
>>>              - 4.02% prep_new_page
>>>                   prep_compound_page
>>>              - 2.98% undo_isolate_page_range
>>>                 - 2.79% unset_migratetype_isolate
>>>                    - 2.75% __move_freepages_block_isolate
>>>                         2.71% __move_freepages_block
>>>              - 0.98% start_isolate_page_range
>>>                   0.66% set_migratetype_isolate
>>>
>>> To optimize this process, use the new helper has_unmovable_pages()
>>
>> s/has_unmovable_pages/page_is_unmovable
>
> Indeed.
>
>>
>>> to avoid more unnecessary iterations for compound pages, such as
>>> THP, and high-order buddy pages, which significantly improving the
>>
>> s/THP/THP not on LRU/
>
> Sure
>
>>
>>> efficiency of contiguous memory allocation.
>>>
>>> A simple test on machine with 114G free memory, allocate 120 * 1G
>>> HugeTLB folios(104 successfully returned),
>>>
>>>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_huge=
pages
>>>
>>> Before: 0m3.605s
>>> After:  0m0.602s
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>   mm/page_alloc.c | 25 ++++++++-----------------
>>>   1 file changed, 8 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index d8d5379c44dc..813c5f57883f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -7157,18 +7157,20 @@ static bool pfn_range_valid_contig(struct zone =
*z, unsigned long start_pfn,
>>>   				   unsigned long nr_pages, bool skip_hugetlb,
>>>   				   bool *skipped_hugetlb)
>>>   {
>>> -	unsigned long i, end_pfn =3D start_pfn + nr_pages;
>>> +	unsigned long end_pfn =3D start_pfn + nr_pages;
>>>   	struct page *page;
>>>
>>> -	for (i =3D start_pfn; i < end_pfn; i++) {
>>> -		page =3D pfn_to_online_page(i);
>>> +	while (start_pfn < end_pfn) {
>>> +		unsigned long step =3D 1;
>>> +
>>> +		page =3D pfn_to_online_page(start_pfn);
>>>   		if (!page)
>>>   			return false;
>>>
>>>   		if (page_zone(page) !=3D z)
>>>   			return false;
>>>
>>> -		if (PageReserved(page))
>>> +		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
>>>   			return false;
>>>
>>>   		/*
>>> @@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struct zone *z=
, unsigned long start_pfn,
>>>   		if (PageHuge(page)) {
>>>   			unsigned int order;
>>>
>>> -			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>>> -				return false;
>>> -
>>>   			if (skip_hugetlb) {
>>>   				*skipped_hugetlb =3D true;
>>>   				return false;
>>> @@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struct zone *=
z, unsigned long start_pfn,
>>>   			if ((order >=3D MAX_FOLIO_ORDER) ||
>>>   			    (nr_pages <=3D (1 << order)))
>>>   				return false;
>>
>> How does page_is_unmovable() interact with the code inside =E2=80=9Cif (=
PageHuge(page))=E2=80=9D?
>> page_is_unmovable() only identify 1GB hugetlb as unmovable, so skip_huge=
tlb still
>> works?
>
> Initially, I wanted to move the skip_hugetlb processing into a new
> page_is_unmovable() by introducing a new PB_ISOLATE_MODE, passing the
> skip_hugetlb/skipped_hugetlb/nr_pages to page_is_unmovable(), it looks
> very complicated/ugly.
>
> if (PageHuage()) {
> 	if(page is unmovable)
> 		return;
> 	skip_hugetlb processing
> }
>
> Back to the current code before I made any changes, skip_hugetlb logical
> only works for movable huge pages by checking
> CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION, the checking is not incomplete
> since no runtime check, but the new helper made a better judgment.
>
>
>
> And after changes,
>
> if (page_is_unmovale())
> 	return
>
> if (PageHuge())
> 	skip_hugetlb processing
> =09
> I don' change the skip hugetlb logical, the only drawback is the
> PageHuge is checked twice, Maybe I miss something?

Sounds good to me. Thanks. I just want to double check with you.

With the changes to the commit message, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

>
>>
>>> -
>>> -			/*
>>> -			 * Reaching this point means we've encounted a huge page
>>> -			 * smaller than nr_pages, skip all pfn's for that page.
>>> -			 *
>>> -			 * We can't get here from a tail-PageHuge, as it implies
>>> -			 * we started a scan in the middle of a hugepage larger
>>> -			 * than nr_pages - which the prior check filters for.
>>> -			 */
>>> -			i +=3D (1 << order) - 1;
>>>   		}
>>> +
>>> +		start_pfn +=3D step;
>>>   	}
>>>   	return true;
>>>   }
>>> --=20
>>> 2.27.0
>>
>>
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

