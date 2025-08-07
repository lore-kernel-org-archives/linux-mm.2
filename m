Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45519C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE096B009D; Thu,  7 Aug 2025 13:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95466B00A6; Thu,  7 Aug 2025 13:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64976B00AA; Thu,  7 Aug 2025 13:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58B86B009D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:12:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E4791A09A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:12:13 +0000 (UTC)
X-FDA: 83750604546.25.EEACB8E
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012029.outbound.protection.outlook.com [52.101.66.29])
	by imf20.hostedemail.com (Postfix) with ESMTP id 38D731C000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:12:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R1ggiPmo;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R1ggiPmo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.29 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754586729; a=rsa-sha256;
	cv=pass;
	b=5YDex4j4EQo4mBFR15Q8uA/P6aQHKaZwOizl7SRcB2xACfKr5fXM2+HamwfFKImSOTMCw4
	rYYU36Hp7p9IF2PfX4RaVTtsWgqqV+tQIbQwJPSDOg4/P82LN4oRjiSzS6ZinpNSGdcP9v
	1yapkBWTG0VLq7Ssd2pWY/3c4JOsv5c=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R1ggiPmo;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R1ggiPmo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.29 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754586729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rs0SnpLECfKo+bZ99GCeZlU8aIUgJBOZ1fGXXCGTLe4=;
	b=6eB9cQFmvvzasVFQbqBnTudvIUMBfNOpc6YNIxI7C8V+0DcEhA9FGmnhDScZrr3n8grQ0h
	LVccp3qSxrJoA+AuGlk5p0sq7XHdeu2fYzaCi6gAFg/FgTn2Xi4+CY3IGPOPb7aIm8qaru
	V18lvNO0GRviarpahislkxQg0YzzX48=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=K8FuYZZaUy12NEq/rhp1ltYwhM/AHmVJBDoPAYHJa9yJ0Gwp2VIBXhF68azxiMt+qWruHGjzPvuf17liuPYSJzcA/hks52KVMkwH00CH6LeiQbgHC1l80aydXfczfNMLCSx6MfpKpUOHSnlN3ZOl3vbn73M+4xTMcbhQCuMH6qzwAbbvZ3+3Z+oQ1rrDtzGruLxfNkrtUpKdZZqrUgM7c3S8nwfVcKjK2/7kHivul+UZAjDH/Uc8USXdLb6M+p7BrxX8c/0pK5YtmdwokAoeYgbt+efvUndLMlejruUNYFuyHSWfOX94IgBJ/S+axGwnFSyYQ4IFZoNI1NjOCFG3fQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs0SnpLECfKo+bZ99GCeZlU8aIUgJBOZ1fGXXCGTLe4=;
 b=N2JMUOJcrDlJkYsTD06ypwi3Ej0drp1mB0AHBMCUxgwvMwFmvjVY66EzglspOyY/wM2aRk43GTsqMScujUGgADLyYVfAZivcXO+vuW7KeElR/+y6zDeihUMUMsdDs6v29MMvCQLIP9F6tv5gpLYghbqeGQvBrV/OCJ0B7T5kjlIvR6RMAsFvaXZCAJyYLqdIkC0j1/CtNwt1x1kjON7J12SiOg4natSP1gH6h9n5yjUiQmjK43wrr0s0hbs1CArPtHsbk1zvWhFkec6eyibikRoRaCihpH+fLWC5gMzXiMfPKbh1ipvyMK4GqBhNBY6AZgBYCXx2Bul2NZgEMQty8A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rs0SnpLECfKo+bZ99GCeZlU8aIUgJBOZ1fGXXCGTLe4=;
 b=R1ggiPmom4Ix9e6ps8H/ZgLHX3vrSNiRhxmr7VrSAMbvlM3TEAu+IjFCnQ9kEm3KxCi+POHiFdt6rtvTFPR0oB+dbDxRIoj+3m0Mal0UxMoDs4EiNklFGQXkYYFc7VYLUHboMWM8rcFIHLrULEKkUampWYPYMidU/pmbCHBNQrY=
Received: from DUZPR01CA0054.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::10) by AS1PR08MB7499.eurprd08.prod.outlook.com
 (2603:10a6:20b:4dc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Thu, 7 Aug
 2025 17:12:03 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::65) by DUZPR01CA0054.outlook.office365.com
 (2603:10a6:10:469::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.16 via Frontend Transport; Thu,
 7 Aug 2025 17:12:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Thu, 7 Aug 2025 17:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHp9VzCvc7WyqL014X4UXAAKXW0z8vwE6DCRxl8ofFjyk4eZFGw65GXOOsMnhe+gFDC63UiBPYxeeX2tp/0K/ulEf1u9c9LunEHf9PsGOraZJNIwp8rh3bo5hNUflepdJBXMDKPUN25ddCE9lDiuWwLD65F0RkOzbMXUdysw3qOJOY6oDyhndVMsP0NPFqjWkiY31borPHeFJlXx2+J2skHhlQoHjCxz4fDqrfgi4ZYshcQEfm5DOtJOLBR5pYOR0asich50xCI1BmSPNDVKK22DxCWPJZ5IgaR4cBxL53PLHXvef8mFsmEzkuV/XMsZtHotqHUkfC9W0j47QkL+ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs0SnpLECfKo+bZ99GCeZlU8aIUgJBOZ1fGXXCGTLe4=;
 b=One8nAXS6Y5h1+HK0hdFnW7Bb2zMfrxTxopZrAXB1dlUKVNL/2cEymg+xYjPTqOxqZUpZsJl0ABEg9WQVRuydQTN6jjTIe5dgXeZ5LcpSohqyPmB1urj/vho9ys5h6jwJOjXfTqn9OMyTFkqmqmwWpxim4K2MXsGUcRfNSlL/zkATfVdVMKvejvs61KSiNbKKSjjstlPJFIl/daqrvgoxr2H/daLwKDRgieCMNiHzCQ5ssiXWURKRIW9XozzVRThXVG13p/n1ol3na39gyZrQp7cwJUAoHeZ9KcUF0a4ogC3ZYbGzc1jSnORqQhOaVQZJmX9RrCXrKfLBmAj7VpAsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rs0SnpLECfKo+bZ99GCeZlU8aIUgJBOZ1fGXXCGTLe4=;
 b=R1ggiPmom4Ix9e6ps8H/ZgLHX3vrSNiRhxmr7VrSAMbvlM3TEAu+IjFCnQ9kEm3KxCi+POHiFdt6rtvTFPR0oB+dbDxRIoj+3m0Mal0UxMoDs4EiNklFGQXkYYFc7VYLUHboMWM8rcFIHLrULEKkUampWYPYMidU/pmbCHBNQrY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 7 Aug
 2025 17:11:29 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:11:28 +0000
Message-ID: <7b4e14b1-c212-4207-aa4d-aa5610148abd@arm.com>
Date: Thu, 7 Aug 2025 22:41:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
 kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <ioworker0@gmail.com>,
 Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox
 <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <97419aca-af5f-4328-84dc-c97bb73ca1ac@redhat.com>
 <96e931a6-c70e-4a11-9e8c-c5a08da7f512@arm.com>
 <66f44615-8df5-4e81-97b7-1f6a01401687@lucifer.local>
 <923f1a9a-4e34-4922-ae2c-c8d974c2522b@lucifer.local>
 <507b057b-8130-4f71-bcb5-11a2000f20af@arm.com>
 <404ae0cb-9c70-4aa1-99ef-b5e90c500140@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <404ae0cb-9c70-4aa1-99ef-b5e90c500140@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXP287CA0011.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::21) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|VE1PR08MB5792:EE_|DB1PEPF000509ED:EE_|AS1PR08MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3ca2eb-3868-4667-3922-08ddd5d5876f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SWVRM2E5UGZDVGRXVGxmOVdyOURsL3VOOWVNcmRtaTFCbGFtLytRUHdhNTdB?=
 =?utf-8?B?dkhiemxGR2JmNUxrMis1T1pBWjFJMVpsOGFUS0FBMTlTTElCM29lcEZ6VmtZ?=
 =?utf-8?B?TElvSEtnVUFyc2VUVHZncU42YUxMU3NHQU5jYSsrT2J5T3FsUUpidVlWeEZm?=
 =?utf-8?B?d0xEdjhLa3ExYkJnZUY1Mm1DcDBHVkJDVW5pdWVpdFpDM2VHYUZJMDRLWmFs?=
 =?utf-8?B?M0hONU8xVW8yZlZBekdkWGFkRFlZZW1xYXgzRGM4YmhrSDRBYVdkT0RSQUpN?=
 =?utf-8?B?NDVZVDZFLzVaUU1IS0oxMkpXUjYxNDZXanBIYitpaDc1MWpNbEh3eU5ma1NL?=
 =?utf-8?B?OC83a3ZVaHplcS9UZ3h4bWdmbWFzd01GQXpDaC8wTjRMeE1BMnFGMG12ajh1?=
 =?utf-8?B?SlcwWUlMTXZQNGF5MitWa0xVK2FMMW4vOG4ydVJ6NjlEUXdLY2toYkpoZlE5?=
 =?utf-8?B?NVRLNUh5Q2YwS0U4bm9LYXNqV1pnd1VGSU90N1FPUzZIVE9pZy8xWXhLNVZG?=
 =?utf-8?B?WWxaa1orYWZ4U0RsbzBhOUlxOU1JTXZYUkUvWFRpcDVDNno4UzJYcURvWjhs?=
 =?utf-8?B?ZkZJRVJESDVsSkZseVRub2R2SFRnZjZ0V1l3ZlpwU1VWWmQ0NG43bVVTMnha?=
 =?utf-8?B?L2RkSnNyUTVKeDJrd2VsMTVUdVYzelZLT0JjRjlKRW5rRlY2QTdVRjlKeElJ?=
 =?utf-8?B?VmJpQ1dZMzVjUUhtZ0V0RmxJazk0RlBVMHNZK09kTTRRY2xOblBleVIwdG9k?=
 =?utf-8?B?SGJXLzd0aVVPOGpYVjd2WElUVFM1L0hkUEFNdjhpMEZpN3NqdW9MdGJyM054?=
 =?utf-8?B?cTdic2dIK1Qwd0Z1ZW93U2t3QXlRRW1UQUhGbHVvU1BxOXJGVWN3dW0yQjBE?=
 =?utf-8?B?aFJRdmFUeHJaYlgwYjMzQnBKMTQvMjJGVUtkM1JoUm9vOVAvcEcxQk9ER3lz?=
 =?utf-8?B?RFY5WUdXelR2OHVvYjR4dExSODM1b20vK3Azakg2WFdzbndMS05YNnh2VWR0?=
 =?utf-8?B?cHJUSEVqejAydkxtKzRGNGFTSjVQWWd1VzBKYjJmclJ0cHUvTUw2TnQ5N3pT?=
 =?utf-8?B?WmF4UFZMODFLaTV5cUNPcW5iNm0yQ2hoUlpkYVpiclhueW5veDVLbFNvSXY5?=
 =?utf-8?B?UVB3WitRM3U5RGZ6RlhZcmU2V0swRVNKekI1K3JBamRsMUtKT1NUb2cvMWpN?=
 =?utf-8?B?eTZvakpDdUtsdTNQTi81MTBKRUhkOVQ0dldDUlF3YWZmZnBhN3NZd2RTSm9x?=
 =?utf-8?B?YStmNW03NGpHdEFra04zbElEcWFaQmdXUXdYZDljT090M0lDd1NEZVQxdjZv?=
 =?utf-8?B?V1IxN2t0WmxGbTBvN1FkZWY3TThNN1JSeG85N1hoUUwrbW4zVFR3SXNaRU9v?=
 =?utf-8?B?akpOdUhmNzJpMkFpeDNkZlA4UzA0WktEUGF6dDlZMnltdTVXa1hHczRKenpV?=
 =?utf-8?B?NFI4UnFYSCsxY0RPWEgzUTJOZWRONXNSSGFFTlkzR2M0ci9GcUI1MWJTVzBl?=
 =?utf-8?B?Umt4MUdVUCtJK2pvbTkwUXZaN29nam42cjdVOXZxVzM1ODhzRUM2dmg3ZXg5?=
 =?utf-8?B?dEN3MHVMeS9JZkNCQzRNai8rUU5nbENjUWk0RFhuMU9rNUdZTy9walpYZHJT?=
 =?utf-8?B?K2I1TUpFazJpTEU0NTM1czNmL1M2ME1EbmhLenpBei9GZ2xCTERTNlM2RCtY?=
 =?utf-8?B?TWV6S05DVDVzKys2ZktzdzM4elQ2QXB1dDRqa1hXVTlkRkFsR252WUJQeUdz?=
 =?utf-8?B?WHVBU0M2aXIzdmxZMHRjTWhqdUF5SGI5V1RIbFJHalMvbS9FanQ3UFhIbG5x?=
 =?utf-8?B?TXZFVC8rKzNIMGptbUFFSEJXK0c4T200a09OeHM0R0JXTWppdEpYSXFraXVp?=
 =?utf-8?B?aUlTNVVwWDhRaVdFSmJ3bGxoMzZSMUsyNk5FeEFqTGpGV2lwekYvWWlCZ0ti?=
 =?utf-8?Q?d0yS5irojf4=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fd74a72d-fa5b-4a76-214e-08ddd5d572bf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|14060799003|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2lxZC9weWlvcHRBbmZrNjRTenBCbUVmd3Z2YXVBaVVwU1dzSE1YSC9rYlNu?=
 =?utf-8?B?emFQMDFPNHJXRnNybCtydm1qUUVGSXNGWTZGZjVwSUVudXdxbHdjUFgybGxF?=
 =?utf-8?B?aEpyYXNyeVhuQXZ6WU9pSTZKYVc5MXB0WjlWdklybXpWRGdmMkNma0NHMXkr?=
 =?utf-8?B?SmFJZE8yS2NXRDUySCsrVnlZZFd3dW5sSld5WVJHaDNoTkJwYmhod3E0SHZQ?=
 =?utf-8?B?K0FEK1hoL05lQmQwSEJ5SHRmQnJ1Zk03UjZoRlhYQnBwNDN1N0dtUXJEVWFR?=
 =?utf-8?B?RlJaZkRudHlYQlRlWG9tQklXNzJsWHRhdHMzT3JYY001Yi9ZcTI2dHFYblp5?=
 =?utf-8?B?TWJpZDNLMWZCa0RJMHdKc2cwNkVrdzV1OTdqanhWdXBTUTNGV2pFZXFnL0NH?=
 =?utf-8?B?aUNCV1NHZUg5cGE4K1ZmUFlMV0hvNXlmQUpSRllZU0hxT3lBN0dqWFp5dXNE?=
 =?utf-8?B?MCtVYjJTOW5FZHVmVGpYeFgrUERHRDJWNE5FRDBFVVZIc2luRkg1MS9oUjJo?=
 =?utf-8?B?MUFPNnVoZXhQTkZQeGdFbEt1ODViMHFOUis2ekRlSzBVSUI3ZTlGbDUxdGF1?=
 =?utf-8?B?M000WGdBdDJBcklpUm9penE0L2R2aWIwZVRFbWpVOVM1ZXp5dkhuVHlkZ0NX?=
 =?utf-8?B?SFc4UHd5eEt2V0J5aDdkdkJSZm9TVkMrTUUyb0RIMTBNMklmQzRTby9GLzZW?=
 =?utf-8?B?Tlk3UEhURERvN0dONG1PNnFnY3lZMTFUaDY4Znk5aEZ5SEtLaEE0eXNOSW9K?=
 =?utf-8?B?UEd2RllVYVgxUkNiTVQra2picndhNVo2bmRzMko0dXcvRlBBOXp0WU04cS9n?=
 =?utf-8?B?RWhmTmp6NW1ITmt6alFWQkRzb1V5MDNPMnZhN0FNdlhqeDZpMU1QWHgxYzdp?=
 =?utf-8?B?R1RuUG9oRzlRM281SGpPc1lJVldJUkdUZWxCcjZBNzlFb1VuLy9RRmVnT1hO?=
 =?utf-8?B?WDNMbHJhQlRYemJ4TU5tWE5rSzM5cHpQbFNqd3lsaVorYnpGcVhYbmF5QTBi?=
 =?utf-8?B?RFRrTzRjVFFTL2kvaXFNb2pvQ3lqN3FkR2pxWVFENmpSNHBCcTYyejIvL3Jh?=
 =?utf-8?B?N2JwT29UUk9VaTBWRXQzM3pBL2VXa0JuM2hBd0JseHpMYXppZm1iaCtXb2Vz?=
 =?utf-8?B?dDM3ZDVnZW5zTkpCclg1ME40NXZsWUpuZnN2Q0psaVpSMlpPRVIxTWFDTEI0?=
 =?utf-8?B?ZzVkV242V1dDdjdwbTNnQzllejhESi9CcGNNRmNQWTV2RG5EanlaMi9LdHov?=
 =?utf-8?B?M1hMSzFmT3o3dXBpSU1lL1FUWmw5dzJmdjBFejVhZythMzh3UHgrRHFRMDVv?=
 =?utf-8?B?MEd0NEdJTnRxK1NQaTZnMW5ScHBSUHRZWlI5VGQxZGQyTTJPbnJxUWVNaDdz?=
 =?utf-8?B?blNOclRDbTRVbTV6Q0JjcEl0ZlJycTFWL25XdGFtTG9mRUNMVExHWXJFeU9z?=
 =?utf-8?B?cjh5U2ZXV2V6c04waHlFOUtlVXhyYzZHY1RQM2NHcnAwUzA2cGpxT1NYRTF3?=
 =?utf-8?B?NFpwTDdUaC9Sd2JWZlh6b0RTRHBYTy9KTk9mNGY0czVsNkZESm1IcXU0cGt3?=
 =?utf-8?B?UmV0UkQ2cDFQQVJvbGlsWEQ1dEFud2RqUmVLM3BNcCtrUTFJT0xIOVk0U1dS?=
 =?utf-8?B?VEh6WENFOHBvMHIzSjRHOUJ2clBMNEJZT2hoSk12NEhVYTY5Z3pROE5mVzRN?=
 =?utf-8?B?aENnM3BWSHgwSERXcGh5WW4zOGFyS2VqV3FxTU51REdTbnFUclhScWZ6bjFw?=
 =?utf-8?B?MU9hM1RkYkhoZXRSeUZwTGtmYUtGSDhPUXlIYy9zQjhNTWhwOExjbWM1ejl5?=
 =?utf-8?B?Y0ZRVVpsT2gzL3c5WGhYL2E3S3NzeFZ0K0JneGtyOG9OWllyMSt4M0RBKzFw?=
 =?utf-8?B?Mzg0NU5NQ1F1b1k3VzVlZ0V3NjNpcGJlNGozdThCOWVRVEVhVDdGWmxVSTMy?=
 =?utf-8?B?c2ZkM1JRVFNtWjhUL3B2OFNPUWZ3Y211QWg1NkluYVRtUVdFQ1hURnYvcHRU?=
 =?utf-8?B?UlJaNE0vQ3FLU0daeXVmanNqSzltMitnc05DeW04ZVl1TXFCQk5RZ0pHekJW?=
 =?utf-8?Q?vJuanB?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(14060799003)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:12:03.2375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3ca2eb-3868-4667-3922-08ddd5d5876f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7499
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38D731C000E
X-Stat-Signature: fco53x69kfenuu8trfhsb4pszpc3ep7b
X-Rspam-User: 
X-HE-Tag: 1754586729-438069
X-HE-Meta: U2FsdGVkX18jZXgOjTAjZiJliSx5CZicI5iyBV/Bn541fsWSkiNl2+W09wa/wqO2e3+R6TKdMbRxw8O92g+vUbvl5diBzEfVwYSyvEeIzBysFPDBMDTObR+WiAkbXTi0GZZG+7zA6sx7jj2ebfkTybFOiHIcf2tHREmthY8SnCcPke3vHG1s3USDF5wqlBKuOzOnNtK3V2BQ9R3g5yS5r8J8MOT89APDlDgxh+zqZ1TqtAHPEF3jsbaExr7Ojg81UZiZvOMlWy2j8S7qWLkChTXsqxIP/Qi6b8pJqj98dv4h7uWX0vBkN0iAW5vPe0tYDEAPVWtcV4qO9i9ZHbSgrbHnG6x8gDynUreouiSKYyM7qSGgRNqbWLz/pGo0nJB0tzRcP87ezXYlVusD2Kgx58SIrEcBV4D4mLeWOLaukQd8swru3GTHgvxr/HdWURvxJHwZJzDzcynxLTrcbmHtxp939t0wQAs+yoXQ9GHO/mh83eWlBFzqz5rkHPPKnm3Z1D17MEHl6Tbe7H/6XSGIY/NdspNNAhvsdrZ90NTq95IV5e1mxju59/zv+ji9JoF35ffynWOxt2ChUFajZb/n/+hEYwvDUqSPrGabvJy2zaYX68zAlPkEc6WNlADLb16xVIUw36YfZABP1dYa18jVKOihs5Dmz4ZY2e0EXE4A6a+LzZ2HnxBQxDh+YIdescatfLJZRX+EkaUQfMoA+m+Zj30fa62Fm+lkhNUMztDHX5aFHC4UizMlEk2eoB3BXXh93z542mGr1H8Hn25Akj+o9WhQ77JyVOgL11xxwArBebqPAVS6d40thY7Hau/gzITTVlt+WgSYhfCYcgwV1rEqo+ezVAA3tgWEDTzylqp8OUn4gzv2h+gqnPVh9vaHPxizubIR9LCK4K1RHnye81zmOOkSOe33GIhPfcdZjfvhQbuTy4P30l231ywUfbZnmJ3Jw4HbpRgxFFClE0kJSYO
 ijlKIXno
 j6N5eVt9//mIOtbmUByfsymQuf8ayVT55hMOwAjBh4lokQva3YnNQ9eWN3o7J4lgiH+GfxjVD9IPad0Ht/acpL1VwIk/9zIQvsMNkbZHgvZdeC5sSCpdYCA4DaaFAtLD1lKjkFU3i0G/NfqRIDpvwgxU/QI2kBjnFgBJTmg9t1PhUedXfu7eysUUoNOsaFF4J06l8RPXsEnyKaysI5ycrYcLcHz8bhsP7+AyvShcsA+57+72glNWTd87IT+9P1Uxx6sJ6lswMBQPJtQP1PH4wBovuhK06QgWrXgrGlhTDAbhIErqho+LK5sq6A0a7PzWU6XladCgKCKSEHYUQU8KKQ7kvE+1mIwbTJFOn2EPNuB1xV7B+7bG16VmmUyiNKtDfLlwqJvC0dZCp2DMOsUOonqFvkYVqr6z/oRWfvhFd/OHJigrQ029ZMxyad9owQnuCNcC6fJyYZrzPBTZ7MBnfREMRX6pC2m8Z/+OrdYWnSnbUQX2KixUFGY4OmkUrY0JsIRkDoCL3794q0PmuJ32KwXk+l20BM7GCTLrIkxItzLO2qe3ne56myh/rK+LQzZiwgx5MZvPLt/RQgoUmj6lcyJ1ENy0KtgE8tgLWMQB3rjG/e1wShClRP9AdaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/08/25 10:37 pm, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 10:34:43PM +0530, Dev Jain wrote:
>> On 07/08/25 9:46 pm, Lorenzo Stoakes wrote:
>>> On Thu, Aug 07, 2025 at 05:10:17PM +0100, Lorenzo Stoakes wrote:
>>>> On Thu, Aug 07, 2025 at 09:36:38PM +0530, Dev Jain wrote:
>>>>
>>>>>>>> commit:
>>>>>>>>      94dab12d86 ("mm: call pointers to ptes as ptep")
>>>>>>>>      f822a9a81a ("mm: optimize mremap() by PTE batching")
>>>>>>>>
>>>>>>>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>>>>>>>> ---------------- ---------------------------
>>>>>>>>             %stddev     %change         %stddev
>>>>>>>>                 \          |                \
>>>>>>>>         13777 ± 37%     +45.0%      19979 ± 27%
>>>>>>>> numa-vmstat.node1.nr_slab_reclaimable
>>>>>>>>        367205            +2.3%     375703 vmstat.system.in
>>>>>>>>         55106 ± 37%     +45.1%      79971 ± 27%
>>>>>>>> numa-meminfo.node1.KReclaimable
>>>>>>>>         55106 ± 37%     +45.1%      79971 ± 27%
>>>>>>>> numa-meminfo.node1.SReclaimable
>>>>>>>>        559381           -37.3%     350757
>>>>>>>> stress-ng.bigheap.realloc_calls_per_sec
>>>>>>>>         11468            +1.2%      11603 stress-ng.time.system_time
>>>>>>>>        296.25            +4.5%     309.70 stress-ng.time.user_time
>>>>>>>>          0.81 ±187%    -100.0%       0.00 perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>          9.36 ±165%    -100.0%       0.00 perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>          0.81 ±187%    -100.0%       0.00 perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>          9.36 ±165%    -100.0%       0.00 perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>> Hm is lack of zap some kind of clue here?
>>>>
>>>>>>>>          5.50 ± 17%    +390.9%      27.00 ± 56% perf-c2c.DRAM.local
>>>>>>>>        388.50 ± 10%    +114.7%     834.17 ± 33% perf-c2c.DRAM.remote
>>>>>>>>          1214 ± 13%    +107.3%       2517 ± 31% perf-c2c.HITM.local
>>>>>>>>        135.00 ± 19%    +130.9%     311.67 ± 32% perf-c2c.HITM.remote
>>>>>>>>          1349 ± 13%    +109.6%       2829 ± 31% perf-c2c.HITM.total
>>>>>>> Yeah this also looks pretty consistent too...
>>>>>> It almost looks like some kind of NUMA effects?
>>>>>>
>>>>>> I would have expected that it's the overhead of the vm_normal_folio(),
>>>>>> but not sure how that corresponds to the SLAB + local vs. remote stats.
>>>>>> Maybe they are just noise?
>>>>> Is there any way of making the robot test again? As you said, the only
>>>>> suspect is vm_normal_folio(), nothing seems to pop up...
>>>>>
>>>> Not sure there's much point in that, these tests are run repeatedly and
>>>> statistical analysis taken from them so what would another run accomplish unless
>>>> there's something very consistently wrong with the box that happens only to
>>>> trigger at your commit?
>>>>
>>>> Cheers, Lorenzo
>>> Let me play around on my test box roughly and see if I can repro
>> So I tested with
>> ./stress-ng --timeout 1 --times --verify --metrics --no-rand-seed --oom-avoid --bigheap 20
>> extracted the number out of the line containing the output "realloc calls per sec", did an
>> avg and standard deviation over 20 runs. Before the patch:
>>
>> Average realloc calls/sec: 196907.380000
>> Standard deviation        : 12685.721021
>>
>> After the patch:
>>
>> Average realloc calls/sec: 187894.300500
>> Standard deviation        : 12494.153533
>>
>> which is 5% approx.
>>
> Are you testing that on x86-64 bare metal?

Qemu VM on x86-64.

>
> Anyway this is _not_ what I get.
>
> I am testing on my test box, and seeing a _very significant_ regression as reported.
>
> I am narrowing down the exact cause and will report back. Non-NUMA box, recent
> uArch, dedicated machine.

Oops. Thanks for testing. Lemme stare at my patch for some more time :)

>
> Cheers, Lorenzo

