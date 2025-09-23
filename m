Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322C1CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B55D8E000C; Tue, 23 Sep 2025 12:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265768E0001; Tue, 23 Sep 2025 12:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEE88E000C; Tue, 23 Sep 2025 12:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E90BD8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:08:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 384CE87548
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:08:58 +0000 (UTC)
X-FDA: 83920998756.01.0A4DE77
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011056.outbound.protection.outlook.com [52.101.62.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 40D011C000F
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:08:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A8nvoD4m;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758643735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XI6XnkqldeJ6SpW+Yofyc+MRF5rngl67Ao76rCtJOLE=;
	b=UnRw9x/PTJpz7wEFRoHJ2exlIVtHp9LBRbhF9gGnTB1zN63VWpnJ+WX0BSYkMnO0hS3rDs
	qfYgXwo8s2gIWoi3xT0SlmDdAFiP85zBvf1uK6+hdhZB7rp+CcyXvgzhDjMMipLZSNS+FR
	/AXI44SRMQD1taJLyuqtu+KQJcrAmH4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A8nvoD4m;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758643735; a=rsa-sha256;
	cv=pass;
	b=awqxibApn7hiOAYO29J/lRpx0jYbDsTAcljBYVrH5rcTzBf/p4x8YloT1Mrt7aZTuD2A2u
	Jf0J2S3Jtt8YzWexmSX1dL/Ka0rFi1QDtqI3GjK4Nuua/jVk8qFsOD2EUD8wmM4VzKWUqF
	rfqsdIZVGTDym78LYlAbRNL6E3gJms8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfR3sqUw1lqzjT9fYXWRNwG+KKcJDYPkXJOfzGnlopb56ibSimsS3mAFkUiP4z7lZ4Er/yIT6zwSBwc00k+2UhRqSQuMEzslS1FlTjD8kC427a4NwpfL1MhLZIjIM76F9aEsG6tgZxWoDzmanXLG2QwnXivreE78tgqdaVph11ogGv55F5gbtQPeeLPlWMoWr9s7n99kv4yhXPM85lbo5hYPiNTLjMWmwQkm27Fmo2gRG3bgztXjWwX/KhJYfiun+fniNbbQ7cR9wGJ6JslZWv5kvQ6Up5Ar2jlENXLEqTBSoAvxSfjjpJxLXf5J+nfMcsappm7eLKd8R9FcJsknog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XI6XnkqldeJ6SpW+Yofyc+MRF5rngl67Ao76rCtJOLE=;
 b=qnLc9nnRGU+CSr+Ow3aKkz1DhH0pe1ZZkJbi/mLj0+Ll0r4pMFPMCpaikXNtenQj4BAXwLr9IdEIfaif99JMgLp0t+Hzy/gDkoM7TopxND1+MlRwwK281sRT2lq58NpvrH9YkHgaEl64uZB8uquTodgrhRoIcu/505XqXy3mW6T+7KiK/f3uviwFzsw9N/YwzeDJScrTgB8k84vBspk5Z1Gml69/cSpdL3dGrsfUgS7VtwqX7008jieMPUdLlbMNvgPmF6m8otUg75Oj6hvJ+YZZqPXF2Xxwlo29mbJWlB8+sImt/v25qR458ZeA5SWM95eJ5Bva7TV7tEP0UWycoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XI6XnkqldeJ6SpW+Yofyc+MRF5rngl67Ao76rCtJOLE=;
 b=A8nvoD4mPxxbK70fmg2H4UKekpglbHhsnOWn5BKKbQ+H28xwg+IoIFDno107t+pFGYv/sY4u6TWfvKu8dIFhqATAg+D5moWrPt9GzgtEVzYgukhF7IOXUdD0n8eG3ImpR0kSM6TXIi1ts2ZiohMJjrcqR1nL6pyjgcbfGmqss1JqLFgq4ah7Gni1mMiVx/1ZAD/y0hBWbwXz/DtukAWcv8DnBb4pbWSMJA5jVYYFRS6JUMSuaNg9zrbYMgzGh1x6V7r+GIy6U5Pa5NYtG7kedD3s4qeDfczoaPoY/zeJC7FtZgo5ayXH0LxCONyS4Gw4G4FPhxu1SHG8LeneGLF4WQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8256.namprd12.prod.outlook.com (2603:10b6:208:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 16:08:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:08:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v6 04/15] mm/huge_memory: implement device-private THP splitting
Date: Tue, 23 Sep 2025 12:08:43 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B24E4F6A-F61B-4E9B-A2FE-4004C62A3DD2@nvidia.com>
In-Reply-To: <901c82e7-0442-4791-b249-b035f8ee428d@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-5-balbirs@nvidia.com>
 <7987AB89-4E80-4A0D-8736-E95F998698DA@nvidia.com>
 <a77b03b8-508b-4bad-8913-fb825ecd8a0d@nvidia.com>
 <F6F6DB2E-C08B-417A-A8CB-3E759FE2C3A7@nvidia.com>
 <901c82e7-0442-4791-b249-b035f8ee428d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:208:52d::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8256:EE_
X-MS-Office365-Filtering-Correlation-Id: 89c3a23d-f362-47fb-8cd1-08ddfabb7a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTZnejRVYTdCZENvRHRYWFhGR3hwckk4UDR5djIvTGhuOXRTMmxISmwvZ2wx?=
 =?utf-8?B?U1RxS3o2WDgvSXZ5WHdHVUR4b084d0lNOW1SNnRLVkdmWmEzV054R1oyYmJN?=
 =?utf-8?B?cVVvTldMUmdLUm1pME1sSi90dklCOUw3akhmdDZDbDlzeVllRjl3b3RkKzJM?=
 =?utf-8?B?ajFDeTNTTVNzeUw2a2I5TStQZXovMGEwMmx0YjY0SzBwbEMzeUQ2UklNaGk1?=
 =?utf-8?B?ZnhGb2NhaU8vUXRXcCs0ai84NnBUSW94NTZVVmMzc3NWc3lHc2pZUHNIMDlj?=
 =?utf-8?B?TExSZUJ0UVc5anJ1SFl0ak10dzRRbm80R2NTREN5VFpnUWRabmZoMFplV05z?=
 =?utf-8?B?c1g3WGRoVzhaK2gvMWl6akdnVGpxaXRhZTRrd0Y0b0RWWnlsZDNrQ0ZpYXoz?=
 =?utf-8?B?SlptR1QyeDA0RkxjT0NaR1hNMHZHaEM1UWRPOThXMXh4YnVKWnpOSzRvRS94?=
 =?utf-8?B?YlQ2Q3JWNVY2UmdubVh1MjMveEtKTkVHYXZnWWpNcEVna2lmWkVIdWtVUGJU?=
 =?utf-8?B?bGVYdkpac2ZuamJJN1VGaFpnd0tMQnkzeTBwdDBaV29ObzRjMGR4cnlqd3Rr?=
 =?utf-8?B?V2wrQTNwcDVkMlJzME14WEpnVkZCSGhvaG5JemNqaDJ1ZXY4VE1XYitMK05Q?=
 =?utf-8?B?UFRIQWV1N2p1cUVYTTladVdHazdHdEJtdURoUmc0QW9ZU09GVDY1aDNNbHVG?=
 =?utf-8?B?azExQ3pxVUh0eHVzSnErNlU0dGVJT0U3bW9MZnRFUkNlcUJhNnFtS0ZnZXFY?=
 =?utf-8?B?dlBiRjlLTFlsaVlhYkl3Smp6SWZTc29qZEJOeE5TdG0vVk5RdFk4SFI0WFVr?=
 =?utf-8?B?MDJiSHVmVFpIVUdYa25SL1IzRWt2dnVnZDJwZEh1TVIyVWxac0plamxtN1Bu?=
 =?utf-8?B?QTAvL21pMmZnR096cjMzNko5QnByczJ3a29US2Fvdzkvb1ZrZ2xGSzNVTlVI?=
 =?utf-8?B?Y0lQTFZYQTd2ZHhXYUplckdNMExIVmpuZmJ4ZzNXVThZeUdoNndRU0lheEZQ?=
 =?utf-8?B?WEdadEhGcjNCaldWWWVwbS9sdlZkQWpub3RzYTN2RjdhZitIeVlUdzJRTUV2?=
 =?utf-8?B?QXdObTIrNFFBOVZ0WGxjS3hOT3JFaDQrVURvOGNPZ1UzeVd2bWYrb0lOV2Mw?=
 =?utf-8?B?RE83WmlpYUtVckdDWVVtR0lWVnVRdDRuU2dRc1E0WmpBOUd0cWZ2amJTT0w4?=
 =?utf-8?B?dVE1V1RCaXloTDFnWnB5QThwaXduVFN4ZmJ3Y2pTdkR4bmtrOG5rczhjaHFJ?=
 =?utf-8?B?UXFQK2w0TXJCckpEcFJUaVVyVGVaKzE1Y2V6bi92UDNjN3k5MTJSclZXa0tw?=
 =?utf-8?B?UWREL0xzUk1zRnlkTTRheTE0alEvQjRXSFh3b1RIckdaYndIUC9XV3duOXg2?=
 =?utf-8?B?Slp1d0Zqek14b1BsbXB6TFV5Q1BuMHl1TE8xbDlBQ2JQMGJ3Qy8xU1ZoSWJF?=
 =?utf-8?B?NFRXdkMwRFg2TEhBUHhEZVNBbTlhLzJSR3A1dExnRXFFeGdCZ1Y3dWFmZ1lV?=
 =?utf-8?B?VldzUGM3Mi9RUDQyWUJ0NkpDdTZhc1F4a3NkOUx4QzY0bjMrR3pkWnJKalk0?=
 =?utf-8?B?TCtWWXFJNkpUQWtlWG5WYTl5enlLNVpTSVpLSkpsMWF3TWJGY1h3NDlWKzFi?=
 =?utf-8?B?cnFYTE50cEJJekQybzVtN214bzJCY2VGUlNHK2pxZThWeUE0c3ZWbVBnOGFu?=
 =?utf-8?B?YkdyZEloeHB2aHR2T2lvaTRpVDdZTFVvWEdKTTR2am5CTm5FS0RZWHZpdVls?=
 =?utf-8?B?cEoxaE5ITUw0bEg2QVo1eENuWXNHNUVzSUxMamdPK0xxcWpKVTZubEVETUEy?=
 =?utf-8?B?d2J6bW9Gd3hVUU8yR2ZONzF2THJVTVNrRWhTQVppMGNETkF4MHN2ckpNZVUw?=
 =?utf-8?B?YXVPaWdTcmpJeThQdmxYTWVuV2psMkg3Z1hIWGdhbGVpSlNuQUJDekhjNENy?=
 =?utf-8?Q?bsTAjTWTSxwx27oMprZkhuny3xrFllRc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVNCM2E1SkR0Zm1zblF4RjhlWmJIQUR3ZCtrd1A5VEJocmFSd00zaTAzRWwz?=
 =?utf-8?B?aW00a1d1SjBQWmFnaGJsTUs5Z3FJckgrU3dhQnh6bEFhQXNuMkM4R1A5bFh3?=
 =?utf-8?B?bHB4aEVuK25YakYrMWdzcTZxZlVhbCtLRU00UlZpTUFYa2IzK2xsdUdCcldN?=
 =?utf-8?B?dGppS3ZHZ1RHY01YRldTQUpLR0ZZTSthcU02cUM5RkJCNFBVbnZzeUplS0cr?=
 =?utf-8?B?WVNUUWxxbGM3cWozRWJNNkg3U3NkMDFOcUFpdnFyNWFjV1JiTlE4NllHN0RO?=
 =?utf-8?B?NzZUVTZINDlYYWppQWJRdW1vRzBOY0pRUnNQa1ZMdnhGdTRKTzVHS0xEUllo?=
 =?utf-8?B?TEtMcTFUclJiVU1wazdJckp3RFdKRnBGVnh2VkNuTTdvS21WZWY0Y2pLNi9K?=
 =?utf-8?B?cklvb0FOQlhjMzFDbkxqYzV3YXAvbUdDZmVwSFdmQTZCdUowWHZtSUxma1E3?=
 =?utf-8?B?eGFhQXNZdnhyQ2NiZEp5QmRCQ1BYdEM5WHRQYWpVR0VqUmJUb3AyZkV1Tk5U?=
 =?utf-8?B?NDdReTRMU2NPanYyOXdubDVGZVJDUjB1bnNMb25FRUR4QzZPNnFjcnR1cVNu?=
 =?utf-8?B?bmFPeVVMUkhQYkpra0JzWmFxY0NxRmNMOVplOExlYWR1T2tTL0lxTW1zVzVs?=
 =?utf-8?B?bElEUFJVRlJUb3F4UDFwN0pRcXRxOXg2V09HL2YybzRGMk82eEFPcTdTY0FT?=
 =?utf-8?B?SmxsamJZelkxL2tWVGh1VzFsNG9FVGpCaWp0eWI0V09GQm54MjJBOWJ1eFN5?=
 =?utf-8?B?WmoyZnhUT3NDbjFIRUdoTzRxWVA5S0ZLS0dsMFkySUh6ZjdLdzRZZENIT1pX?=
 =?utf-8?B?anByeG0waDQyc0QvODA1cjFGRTJJc2FUWHN1cUhvRUtlWG1FN3dZaHkyVWUv?=
 =?utf-8?B?SU0vbDU0d0pnOU9CRktJWURHQjlYaXg2Z3AwVXY4UThVVGUyOVBYWjRBd2I0?=
 =?utf-8?B?UjIxN0lVTE94V3NxVFVuVEVub1hjU3ZpZVlMbkdabGZISWZNMktIcWdHdDRU?=
 =?utf-8?B?c2Y1M1ZWQUl0L3FZd1U5am5McFA4Qk80VXNxRnFHdEVUa29NQkJwenhNT3F4?=
 =?utf-8?B?WlJGdGpEc2xZRUt0eUlTZ0FsVXVQMTZGSXUvTHFabXFoTWhINnRjbXlEYTV1?=
 =?utf-8?B?TlhjT29sZitwNFBqdnpsWGJNc3VvZ2daWW9NTVJHV0w4Mi9NWC9tak9YNkZR?=
 =?utf-8?B?YjFCa21iVWljcWFWZXN4S1Roa2tyN0NmYUZyTXZpUG9hZ1A5Vmd5WGVINVpr?=
 =?utf-8?B?RFYvNE5HOTg3d3pOcFdsbktjVEtMalMwbkdsRkNWcnpZc2tHZkIyL1ViQkdL?=
 =?utf-8?B?azRwaEczd0pYZGlPM2VMR0VIQzA4amd4akZFT1NtbTFKa09iUCtLMEdBY2kw?=
 =?utf-8?B?VDNRbEMyQkZ4cUQvZzRXY0lHWmZTaEk0WnYxeEE5VXR0Z0kwUHZ5akRJQ2Vy?=
 =?utf-8?B?YW5SVlJxRDljNnl4STJPdG9yZFZiYU4rdU43bm04Wk9Gcnk0RXJ6K0Z6RlVC?=
 =?utf-8?B?RnFwL0RicGtocUVGaGFXemJFcWZvUFRudi90ZzBtaTZsKzJOZ2tIeG04YXNC?=
 =?utf-8?B?c09Sb0pyVTRtMUFNRVhLNXJKcU9oOHFDbkRtS3V1WHhsQUQvRGdNVWU0VFhO?=
 =?utf-8?B?U1piVFNrd3p3WTV3amwxT3NneW9tRm5vZmN3UlMyMHZkRUpObmZiWHJ5cURQ?=
 =?utf-8?B?ME9LYU9scCttb09QeEhWMzZLVFBJbUs4MEVhK05WY3NGQ0JHcklUaXZ0WUU4?=
 =?utf-8?B?UEUzK1NUUE5KYUpLM3JIL1lERjdOaVlnclozTVozcm9jU1hTYmk2SmNaMmQr?=
 =?utf-8?B?dVp2cDRUUXNHUTRrcjNDTGZGMlBxRDF4NWhGb2gyRS9BN3JES3RnN2hwaXZ1?=
 =?utf-8?B?UmNBQ2NJOXdWaTFyQ3hBQ056WmxUb1QvYXBDN1VCemhaTDlKaEduU2diS0t1?=
 =?utf-8?B?ZjdEZFA4NEQ2NUpFaDIvcE5oUDMvZ3RtZnBpOXF1ajFrbkI4aE40dGxsTjRw?=
 =?utf-8?B?UzB0dWQ2dTd0WEs3a1lsa28xQ0ZFanA3c01ZMnNjREVPYUpIWjVUU3JsL1pu?=
 =?utf-8?B?R2xsWG5UVGFqV2tlbVUrd0RrL0Y5WjE4emgwVU5TeXo5YkkvckpiT2IvSjhm?=
 =?utf-8?Q?I1BhHDsk7kfcfnT00tRn8eVSt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c3a23d-f362-47fb-8cd1-08ddfabb7a1f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:08:47.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2EJFbLB8wXTl7SstxHbQqhHLL5HBEtniBvjUtqiWH/gkXArH2K8LV3fv+CPZWmT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8256
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 40D011C000F
X-Stat-Signature: qjky9wnu87wyauqku776crxohnpbxaso
X-HE-Tag: 1758643735-635801
X-HE-Meta: U2FsdGVkX19Ex4qTskYMGQw5cjvHSV4rpvr4STWRbDffbqBfFAveD3cewOnxpjSKMtBfqJhtmN7noOuiO5nL+S1F2l8r6sySByS/GX5l9/3rTzRaKmJ075nTAjFmnrqXoo3oGBbtdwwdpMj4PYCrvyzVZF4ItgKXdfw9lhF8UehrplUA0JucUKiS0xfN28OzRDmcMsM+8u+CnDAa4971y18zP4+d4KwS2jIsa7Lp43XwcHwKwKXPlVCp0yLLb7So5pSE8c9qnuwAX9sangMRjGwF25BHgKzw+JZP4qT9f+muhsTKtj+IHmaipED/LmcoWlcz/tNTGIHlf+V0mXHlWH85I9L9Q8X+defqcMmlbMJ1+USiz/LiwL+vUPiCYhhZjwEyuImCdU+DaWaJalrAM5mSgNdln0vLaUYMGFMBbXxX0HuC+JFKb/AZUH7NXlEa019UnnJlTnCeDHgpAgaWsHS3GwIpItt3Bn8L4i/+48KRUVxIqx0Ce0mMQ+yj2mwK947iT/wFk3W2Wo+dMp0+vVkVDSHad42QitDm4rIa5SmQehQBUh0eZPtMN9EVdmFdkpkY2fHxx7BqRuFRwelQ/U4dYYuPd+f0o5IY+4v7/JoAduT9kRoIqHKRRUF9dXKW3uGXoiGNiYm9Vh6aMrDZ9ARF8eioixQVFd3dxLtDbLlRbt2HsWvudMDBeGp93tWmtruzFzjmeyE4nyoKfZ2WTaGwQxYMoTNSW0vYmpAYJ2fFsYeAVD46FQthSg34QYRFBUd6fwuTqCb2DEC7olxE44SCOThsFBQccovRz/e5jW8A6akc/3fI/aZG5vkWZXm9ds1jQVauf9lmScE9Ow8EvwwxUmFJa8QqMj9b5qDUTRF/I4tBbxk2uR+zd0C2vLNFA7iolqG4Is5LiMNYWIaOKeJ+nu6aYAzyiI5Z4uqCSk91orSizTP+UgR2++l/B4I79lTp3u0FO1YvtedtoRM
 I1HLT8HT
 6bJGfyPK8lan2HUZQRgIkAoOI8m9MeJ+enQ0iG+UMQ8H0V/N6Tof+PYhqQ2+uIm3IxlPx0aawF9K2DDLtJLeSw/7Cr0Me8iMYH/79DLq+frt3E7dEHV9uIQFrq6P6c4tyuU07lXHKO8eCQxvYG01x2zDEk2bTmiWD9eROqgbshzsVIHRmXt1LiJ782BIgRJrj41Rk0dkRBzJMPP7Ef4+x87fyOUa2MZ82rQx7DM2Xin+kXiR/pwdEa8I9ErQ448K0Lbwtqm6JHkYSP7YbpGaL9/B53bTjf+UnQjefpqk79g5y75JTdQ9Q/UX6Ewe+MO8PQ4PknrUNQZoFUnZxpaSQAYpPJ3P2E6wDM7qS0qOZJWHtDSsKpgQqea4JOk4DRjxVwYNtj9LSeDGg3XKxBnH1QdR3QD6ikX9xOsuRxBpBcPTXbm7VE/edppx+O320U4KJsZsnLoD4tQcb0aeQz7CdAxT+4Wi7x67rZg98pY3FpOBTs294emHqLbZnNvPkSifeBSkEOPcdbEZ3hENtdNL7kxAvUAXFH6C6G4sej7wIXlvQRI2MTh52N9irVGVqZU1F4jdwuEpG5gqFKCCKfQEoJzCzF2Yp27nQ50uyY05SArN7Wf9XxVML4Vs1E4X/PpO9JO6loag4uktxHz+PQ9FAAr6e6iOnnBMBl0EoWZZOba7MMLYtNRSuNG+rvL17J6jksyD0swp6puDiLwYcL67i8B+zhUxXQ3dwHSZaYunV2ySDFhL66L+VYiYIxYnA2TtMeZpLQzFqPrdgKU7hKGMbPFKn7S/lATWHrWUjhDtos65/G9krlvvsvLeUZ/DQwMunmJ4i/CvuG8SdRAMIUw5Ry3483p7c9cN08GVZMsdQQmke4bSKvZ/o5T+H9GkyWMzbC3XiQZu4tKj/qQ79p/sSueLCYCENo2ifDHNJP1rxKsNOJvk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Sep 2025, at 0:04, Balbir Singh wrote:

> On 9/23/25 12:09, Zi Yan wrote:
>> On 22 Sep 2025, at 21:50, Balbir Singh wrote:
>>
>>> On 9/23/25 07:09, Zi Yan wrote:
>>>> On 16 Sep 2025, at 8:21, Balbir Singh wrote:
>>>>
>>>>> Add support for splitting device-private THP folios, enabling fallbac=
k
>>>>> to smaller page sizes when large page allocation or migration fails.
>>>>>
>>>>> Key changes:
>>>>> - split_huge_pmd(): Handle device-private PMD entries during splittin=
g
>>>>> - Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
>>>>> - Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
>>>>>   don't support shared zero page semantics
>>>>>
>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>> ---
>>>>>  mm/huge_memory.c | 138 +++++++++++++++++++++++++++++++++------------=
--
>>>>>  1 file changed, 98 insertions(+), 40 deletions(-)
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 78166db72f4d..5291ee155a02 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -2872,16 +2872,18 @@ static void __split_huge_pmd_locked(struct vm=
_area_struct *vma, pmd_t *pmd,
>>>>>  	struct page *page;
>>>>>  	pgtable_t pgtable;
>>>>>  	pmd_t old_pmd, _pmd;
>>>>> -	bool young, write, soft_dirty, pmd_migration =3D false, uffd_wp =3D=
 false;
>>>>> -	bool anon_exclusive =3D false, dirty =3D false;
>>>>> +	bool soft_dirty, uffd_wp =3D false, young =3D false, write =3D fals=
e;
>>>>> +	bool anon_exclusive =3D false, dirty =3D false, present =3D false;
>>>>>  	unsigned long addr;
>>>>>  	pte_t *pte;
>>>>>  	int i;
>>>>> +	swp_entry_t swp_entry;
>>>>>
>>>>>  	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
>>>>>  	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
>>>>>  	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
>>>>> -	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
>>>>> +
>>>>> +	VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd) && !pmd_trans_huge=
(*pmd));
>>>>>
>>>>>  	count_vm_event(THP_SPLIT_PMD);
>>>>>
>>>>> @@ -2929,20 +2931,47 @@ static void __split_huge_pmd_locked(struct vm=
_area_struct *vma, pmd_t *pmd,
>>>>>  		return __split_huge_zero_page_pmd(vma, haddr, pmd);
>>>>>  	}
>>>>>
>>>>> -	pmd_migration =3D is_pmd_migration_entry(*pmd);
>>>>> -	if (unlikely(pmd_migration)) {
>>>>> -		swp_entry_t entry;
>>>>>
>>>>> +	present =3D pmd_present(*pmd);
>>>>> +	if (is_pmd_migration_entry(*pmd)) {
>>>>>  		old_pmd =3D *pmd;
>>>>> -		entry =3D pmd_to_swp_entry(old_pmd);
>>>>> -		page =3D pfn_swap_entry_to_page(entry);
>>>>> -		write =3D is_writable_migration_entry(entry);
>>>>> +		swp_entry =3D pmd_to_swp_entry(old_pmd);
>>>>> +		page =3D pfn_swap_entry_to_page(swp_entry);
>>>>> +		folio =3D page_folio(page);
>>>>> +
>>>>> +		soft_dirty =3D pmd_swp_soft_dirty(old_pmd);
>>>>> +		uffd_wp =3D pmd_swp_uffd_wp(old_pmd);
>>>>> +
>>>>> +		write =3D is_writable_migration_entry(swp_entry);
>>>>>  		if (PageAnon(page))
>>>>> -			anon_exclusive =3D is_readable_exclusive_migration_entry(entry);
>>>>> -		young =3D is_migration_entry_young(entry);
>>>>> -		dirty =3D is_migration_entry_dirty(entry);
>>>>> +			anon_exclusive =3D is_readable_exclusive_migration_entry(swp_entr=
y);
>>>>> +		young =3D is_migration_entry_young(swp_entry);
>>>>> +		dirty =3D is_migration_entry_dirty(swp_entry);
>>>>> +	} else if (is_pmd_device_private_entry(*pmd)) {
>>>>> +		old_pmd =3D *pmd;
>>>>> +		swp_entry =3D pmd_to_swp_entry(old_pmd);
>>>>> +		page =3D pfn_swap_entry_to_page(swp_entry);
>>>>> +		folio =3D page_folio(page);
>>>>> +
>>>>>  		soft_dirty =3D pmd_swp_soft_dirty(old_pmd);
>>>>>  		uffd_wp =3D pmd_swp_uffd_wp(old_pmd);
>>>>> +
>>>>> +		write =3D is_writable_device_private_entry(swp_entry);
>>>>> +		anon_exclusive =3D PageAnonExclusive(page);
>>>>> +
>>>>> +		if (freeze && anon_exclusive &&
>>>>> +		    folio_try_share_anon_rmap_pmd(folio, page))
>>>>> +			freeze =3D false;
>>>>
>>>> Why is it OK to change the freeze request? OK, it is replicating
>>>> the code for present PMD folios. Either add a comment to point
>>>> to the explanation in the comment below, or move
>>>> =E2=80=9Cif (is_pmd_device_private_entry(*pmd))=E2=80=9C branch in the=
 else below
>>>> to deduplicate this code.
>>>
>>> Similar to the code for present pages, ideally folio_try_share_anon_rma=
p_pmd()
>>> should never fail.
>>
>> anon_exclusive =3D PageAnonExclusive(page);
>> if (freeze && anon_exclusive &&
>>     folio_try_share_anon_rmap_pmd(folio, page))
>>         freeze =3D false;
>> if (!freeze) {
>>         rmap_t rmap_flags =3D RMAP_NONE;
>>
>>         folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>         if (anon_exclusive)
>>                 rmap_flags |=3D RMAP_EXCLUSIVE;
>>         folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>                                     vma, haddr, rmap_flags);
>> }
>>
>> are the same for both device private and present. Can it be deduplicated
>> by doing below?
>>
>> if (is_pmd_migration_entry(*pmd)) {
>> ...
>> } else {
>> 	if (is_pmd_device_private_entry(*pmd)) {
>> 		...
>> 	} else if (pmd_present()) {
>> 		...
>> 	}
>>
>> 	/* the above code */
>> }
>>
>> If not, at least adding a comment in the device private copy of the code
>> pointing to the present copy's comment.
>>
>>>
>>>>
>>>>> +		if (!freeze) {
>>>>> +			rmap_t rmap_flags =3D RMAP_NONE;
>>>>> +
>>>>> +			folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>>>> +			if (anon_exclusive)
>>>>> +				rmap_flags |=3D RMAP_EXCLUSIVE;
>>>>> +
>>>>> +			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>>> +						 vma, haddr, rmap_flags);
>>>>> +		}
>>>>>  	} else {
>>>>>  		/*
>>>>>  		 * Up to this point the pmd is present and huge and userland has
>>>>> @@ -3026,32 +3055,57 @@ static void __split_huge_pmd_locked(struct vm=
_area_struct *vma, pmd_t *pmd,
>>>>>  	 * Note that NUMA hinting access restrictions are not transferred t=
o
>>>>>  	 * avoid any possibility of altering permissions across VMAs.
>>>>>  	 */
>>>>> -	if (freeze || pmd_migration) {
>>>>> -		for (i =3D 0, addr =3D haddr; i < HPAGE_PMD_NR; i++, addr +=3D PAG=
E_SIZE) {
>>>>> -			pte_t entry;
>>>>> -			swp_entry_t swp_entry;
>>>>> -
>>>>> -			if (write)
>>>>> -				swp_entry =3D make_writable_migration_entry(
>>>>> -							page_to_pfn(page + i));
>>>>> -			else if (anon_exclusive)
>>>>> -				swp_entry =3D make_readable_exclusive_migration_entry(
>>>>> -							page_to_pfn(page + i));
>>>>> -			else
>>>>> -				swp_entry =3D make_readable_migration_entry(
>>>>> -							page_to_pfn(page + i));
>>>>> -			if (young)
>>>>> -				swp_entry =3D make_migration_entry_young(swp_entry);
>>>>> -			if (dirty)
>>>>> -				swp_entry =3D make_migration_entry_dirty(swp_entry);
>>>>> -			entry =3D swp_entry_to_pte(swp_entry);
>>>>> -			if (soft_dirty)
>>>>> -				entry =3D pte_swp_mksoft_dirty(entry);
>>>>> -			if (uffd_wp)
>>>>> -				entry =3D pte_swp_mkuffd_wp(entry);
>>>>> +	if (freeze || !present) {
>>>>> +		pte_t entry;
>>>>>
>>>>> -			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>>>> -			set_pte_at(mm, addr, pte + i, entry);
>>>>> +		if (freeze || is_migration_entry(swp_entry)) {
>>>>>
>>>> <snip>
>>>>> +		} else {
>>>> <snip>
>>>>>  		}
>>>>>  	} else {
>>>>>  		pte_t entry;
>>>>
>>>> David already pointed this out in v5. It can be done such as:
>>>>
>>>> if (freeze || pmd_migration) {
>>>> ...
>>>> } else if (is_pmd_device_private_entry(old_pmd)) {
>>>> ...
>>>
>>> No.. freeze can be true for device private entries as well
>>
>> When freeze is true, migration entry is installed in place of
>> device private entry, since the "if (freeze || pmd_migration)"
>> branch is taken. This proposal is same as your code. What is
>> the difference?
>>
>
> I read the else if incorrectly, I'll simplify
>
>>>
>>>> } else {
>>>> /* for present, non freeze case */
>>>> }
>>>>
>>>>> @@ -3076,7 +3130,7 @@ static void __split_huge_pmd_locked(struct vm_a=
rea_struct *vma, pmd_t *pmd,
>>>>>  	}
>>>>>  	pte_unmap(pte);
>>>>>
>>>>> -	if (!pmd_migration)
>>>>> +	if (!is_pmd_migration_entry(*pmd))
>>>>>  		folio_remove_rmap_pmd(folio, page, vma);
>>>>>  	if (freeze)
>>>>>  		put_page(page);
>>>>> @@ -3089,7 +3143,7 @@ void split_huge_pmd_locked(struct vm_area_struc=
t *vma, unsigned long address,
>>>>>  			   pmd_t *pmd, bool freeze)
>>>>>  {
>>>>>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>>>>> -	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
>>>>> +	if (pmd_trans_huge(*pmd) || is_pmd_non_present_folio_entry(*pmd))
>>>>>  		__split_huge_pmd_locked(vma, pmd, address, freeze);
>>>>>  }
>>>>>
>>>>> @@ -3268,6 +3322,9 @@ static void lru_add_split_folio(struct folio *f=
olio, struct folio *new_folio,
>>>>>  	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
>>>>>  	lockdep_assert_held(&lruvec->lru_lock);
>>>>>
>>>>> +	if (folio_is_device_private(folio))
>>>>> +		return;
>>>>> +
>>>>>  	if (list) {
>>>>>  		/* page reclaim is reclaiming a huge page */
>>>>>  		VM_WARN_ON(folio_test_lru(folio));
>>>>> @@ -3885,8 +3942,9 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>>>>>  	if (nr_shmem_dropped)
>>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>>
>>>>> -	if (!ret && is_anon)
>>>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>>>  		remap_flags =3D RMP_USE_SHARED_ZEROPAGE;
>>>>> +
>>>>
>>>> You should remove this and add
>>>>
>>>> if (folio_is_device_private(folio))
>>>> 	return false;
>>>>
>>>> in try_to_map_unused_to_zeropage(). Otherwise, no one would know
>>>> device private folios need to be excluded from mapping unused to
>>>> zero page.
>>>>
>>>
>>> I had that upto v2 and then David asked me to remove it. FYI, this
>>> is the only call site for RMP_USE_SHARED_ZEROPAGE
>>
>> Can you provide a link?
>>
>
> Please see https://lore.kernel.org/linux-mm/20250306044239.3874247-3-balb=
irs@nvidia.com/T/

I do not see any comment on removing device private folio check
in try_to_map_unused_to_zeropage(). Can you try again?

>
>> Even if this is the only call site, there is no guarantee that
>> there will be none in the future. I am not sure why we want caller
>> to handle this special case. Who is going to tell the next user
>> of RMP_USE_SHARED_ZEROPAGE or caller to try_to_map_unused_to_zeropage()
>> that device private is incompatible with them?
>>
>
> I don't disagree, but the question was why are device private pages even =
making
> it to try_to_map_unused_to_zeropage()>>

Then, it could be done in remove_migration_pte():

if (rmap_walk_arg->map_unused_to_zeropage &&
	!folio_is_device_private(folio) &&
	try_to_map_unused_to_zeropage(&pvmw, folio, idx))
	continue;

Maybe I am too hung up on this and someone else could pat on my back and
tell me it is OK to just do this at the only caller instead. :)

>>>>>  	remap_page(folio, 1 << order, remap_flags);
>>>>>
>>>>>  	/*
>>>>> --=20
>>>>> 2.50.1
>>>>
>>>>
>>>
>>> Thanks for the review
>>> Balbir
>
> Thanks,
> Balbir


Best Regards,
Yan, Zi

