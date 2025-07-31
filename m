Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68EDC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 11:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747436B007B; Thu, 31 Jul 2025 07:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7E46B0088; Thu, 31 Jul 2025 07:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599556B008A; Thu, 31 Jul 2025 07:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 415FC6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:26:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B8E05AE25
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:26:52 +0000 (UTC)
X-FDA: 83724332664.26.E63AA07
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55A1640003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:26:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WmRKWrAf;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753961209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1urd7OAX+7BvmLpYo8OKddJ4Qpm0g/38s9MpAWc6k+w=;
	b=MV4apqDOD2VdvVw2IjLNSXUO6068ActdjjuXN+GrCHUk9eb0RGc+Y2ZVbJltaVV/v7ptLW
	zZ4qzDDieBaGLe9fYdtCPslWF2gayq3lDrIfdUocqa+U6m0BXjxgox4TNmn5pp3bwn9rvj
	7ljIVZdlW8vtiH7QqteU0dHHl7l+xuI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WmRKWrAf;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753961209; a=rsa-sha256;
	cv=pass;
	b=pRZIWPiEPWu51csFrmRhklhmEaAWivYNsrtlOVEfLzfmqEL9srGCfuhBQae13mCeJesYlG
	SyUSnFXI8LDg9vykfBYqM82CfnWUXFcIyHfQvdBrLtDULX6ZenH1fjhekw0ATvX6sQnEQR
	p11LOAQoWLXRoUeBFCBcrDvWzqN7yFM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdiBOjBVS6HFTKW+L3pV77R1JruAGj7QTkvp3PNIxZcbNLM4zb8ztsQ2YePH8mfwNuRrb+qxqYSLtdZ77+hP8mP/ThV3uyjyjLOs9IrGigVUK0IwzKpOdzFORziO1kXcu+vMlIwyYzzYZCp4NXA/g9wDCRw+lhxtotoNoE3TkVSXb9LAcvf2d+OGRo/6f7yCSLtC3LFFXv89a+4Bus6N7V1x9CiKrjMt01WAeIi/ho7Bo8fKQblVeRhTHbqopSJ5C6Q0NFQAisHxMe8y2OW81fnvUr/yw167wIrQn2nSJhjgFZ/31v84pbJXHZ4Em++I2nmR7zRJOqFA1SrcFqkSoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1urd7OAX+7BvmLpYo8OKddJ4Qpm0g/38s9MpAWc6k+w=;
 b=XLQGQp0lnhmIOFpN3q8mssF8HWDCQbRVK3OTR4bBpD4k6l2+HDyHnVoX0HdU2/DP6eyvp07jvPRQnCxB3w4jVF9Sti9e27OxlQmaUM5yNHlB5lSAdTthyEvGd5kh6hAXgbdaforRLoVahYOGxMvzYXpb7MvVpr3+AeFoN1HjiJ+ehVT4UNpJ6PIu3GobRxop6ELcvGCtjdH9vVDli3n36pMrU1Lb8pNCoE/cOZ38G0XNPXfStSdPxXaW4LqY9bfOvtb+M0tCZFLBa2UeW4tneKzP1jNkh0D9Cw6y4F58RuvB7ED6Mk48B/mowoAFO0Rf8iwmDkEmJBPH2zqU1ot10A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1urd7OAX+7BvmLpYo8OKddJ4Qpm0g/38s9MpAWc6k+w=;
 b=WmRKWrAfkGjJY2h55wO1rB7+wDxPQzzX78ixJ50QUM11d0rEdcTnUUBAtwmu1S+4CPYpLFgqBXfrJg1ii6fxXbNnDmBzRjrOmxmDOiFiutTUrbO4vWKvm0QF4YOYDisrScI70KcpOTpaZ1iOrR2c1Q9e2otfBV1jZJ9xnDE5kzGI6wVnlBzGso0NHdxZwVWBlRlgrVyQTCf+9q47+/U/RJMI7JvKmxn4cx4mL08G41TdRqG2Wdpe7fi8rbXSchn2eGch8B6hZiWxq40faK12Doejq0jZO3AKa7QYeWiOayj8KDV/Z1YmaSa6bfCXltaobgn2mMoWo6DAzyrRxDbF7w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB9739.namprd12.prod.outlook.com (2603:10b6:208:465::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.13; Thu, 31 Jul 2025 11:26:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Thu, 31 Jul 2025
 11:26:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Thu, 31 Jul 2025 07:26:36 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
In-Reply-To: <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB9739:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f66f00e-6aaa-4c10-2186-08ddd025216b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGlKTkFsQ0s1MjF1RWRrNVIxazRXV0tsc3RsVFZpQmFLQmZxN0JpWkhoOGlz?=
 =?utf-8?B?TnRvMmxuTEpSY2MzTDk1R242Y1dMUHkrSzloN2N5SHZVQTZjVHFPY3hUcjNL?=
 =?utf-8?B?aDhWT2cwRDZyQXpUbUx6Zi8yRXliN2xQYkR5QVFuR0F0TEwydlJoQWd2b3JL?=
 =?utf-8?B?b1V1bm9wNitRWU1xVGNzektXV2tNWFh6bW44ZTVvWEhicUFmYlFQSDVpN01D?=
 =?utf-8?B?YmxSOUVmdXJNTit4TDhTVml6ME5QUlhJWXF0VWJkdHdBbzdEMHN1YWsxMUVN?=
 =?utf-8?B?bVd6a0ZVYzFhVm9oZjM1eUxsQzVPOWlKWTdnS2doYmxid3d0NE9yU0NtSHMw?=
 =?utf-8?B?TVVjODZlblZBOHpuRHdPRGZlT1o2UUNveSszMHBJTlUrQ1A5d0pCcHdsODk4?=
 =?utf-8?B?QTZBdHRmdHo3RnIrZTU4VzAvM3ZxcWlDR2VzUmVHN3U4RlhkaSswOCtnSGJI?=
 =?utf-8?B?RWFTcUNDOU5zLzNSQ1JYbXZZY3RUOXplZnNKdXF6UXErSkE2TFlwSWoyNnRu?=
 =?utf-8?B?RHg1RVlOSjdzQVluQVpFa0wyankrSlNjUXhBRklsY0hNMHAxRnhXREVsNjB2?=
 =?utf-8?B?ZzF5dDZmQlBJeU5MWW03N25LejJlaE1yL0U5cmdWWVM2MWpCN3cwNDRFcnRm?=
 =?utf-8?B?NUVaQUNhQjFSanlqbzhhbEpYVno2K3pqMCtrMTVlTVNEakVOeEx1Y2IzUjNt?=
 =?utf-8?B?bHc1bXZRM1VXbms2ZHFOZm1Eb2lPZlRYb3VtOVE5R1hqRkhDTHpZQnRDV2VE?=
 =?utf-8?B?NmlyMnFLL2E2a21SSGhzTnRHN0Z4MlZGcDJWYzlnWkVvMFdEMFRUNzhoSGFU?=
 =?utf-8?B?NXNEWk9hS2piaE9JcXBmdFpLYnFpeGpDUXNFaGthaEV4U1hyZDF0bEpGT2J5?=
 =?utf-8?B?S24xd1V2M2tBZUd6dHczUEo2bFRIZHV5YWF6TjRXaDNLWmxMQ3RWZml5cWNO?=
 =?utf-8?B?TUxLbHlkZTcyK1dOcjBaQi9lQURhZXk5eFgvWThQSjkrdlRsd2ZhMFBraE9n?=
 =?utf-8?B?MVBTWUo4T0krdVFjc1pnZWl6M3RoRGl4dG5mekpGVWp1eDBOUWlkbUE4N2wr?=
 =?utf-8?B?NVlRSnNETHlGMDZmb1NyQm81ZE5iZ1ZEeExxemNqUENCc2V6aHdGRWwxWHIz?=
 =?utf-8?B?aWdoUTJ1MHBNbkpKK3QxeEdyK2U0dEJJbWw0M2xTVng3ZWY2VWxka0VHVWFJ?=
 =?utf-8?B?NkdwcTRxRU9hNVhyNkk2WEc3STlvWkpsYVVsKzBzWnFrWVR6d01sTDBoZGU4?=
 =?utf-8?B?T2FmYlJadm9PeWdEV3NkWHFnSExxdGNjcnFqaUZsL2RwakxlYytlVW91OE5Q?=
 =?utf-8?B?S2xPQ0FaYXpFTWxqODF3am8vTkk0SVhrVFl2dEhDTE52NUlqTWszUVdWOWE2?=
 =?utf-8?B?TVRvc25uL2wrUnJlVEZNL3RVUWp1RzFOaEc2cE5OOTdjZlQrQUVZMU9wL25L?=
 =?utf-8?B?VDUzcTQ0azBiT215b3E0QmpCWk5qakh2WlFrRWFLQU1HenIwNnB4czVXTVY3?=
 =?utf-8?B?MUhzTHAvUlAyMUcvWU16NWl4M1dXam1pUThTbXBLMmZSdTBQS2p3dmhQOTVJ?=
 =?utf-8?B?MTNKVGVJKzJDKzhJRFI5V3JHL285clB3OHF0U0drTGRvMGNmcW5YbFIwVjBB?=
 =?utf-8?B?QTVKZzBBdzZNQUhpWFBBVFg5dVFES3U4N005R2lEQ2k1cXo2cHBmdTJQaXZJ?=
 =?utf-8?B?bDZoeTVOeHp1NkdGUW5HRFBtSWRXdHVUN09HRmh4c0NZazNTU0V5ejdXNGhw?=
 =?utf-8?B?RlcwQStUQ0tSenNBZVZMcURPcHlnQVUrSjE0NitDN3ZnREIyL1lvSkZLRWZw?=
 =?utf-8?B?WGh0NWUwSFZOQ0MzZTM0SjFSaGhHS3VPNjdNTVNGQmV2ZTdhc3ZCdXJHYU9m?=
 =?utf-8?B?bysvbjhhQmJKdC9xc1cyOHBhVW5NTzlsV1ljNkQxU0VYbGt4M1RBeldJYlNk?=
 =?utf-8?Q?0YYzbBsZ78s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0ljNkRDSFllV1BwNjNld0FMSmNZQ1M1ZUQ5S0VhWHhDWDBLbWRIQkxMa1Iz?=
 =?utf-8?B?STkxcWY0Z0FPSWtlNXovUjYwZHJIdStkWkRKbGR0TDcrWXB5aFdmK3h4c1hh?=
 =?utf-8?B?VGJzdktsSXFnT010NkxENVN1NG9pam5qTHlndSt3ZHZRRGE4dkdGcmVoOHBZ?=
 =?utf-8?B?SEtSTXpmSVhJS3ZZaXdrYm5qN292RXRpTDFpdDdqUFBRZklWVjFad3BZWTVD?=
 =?utf-8?B?bkw3a0pjcytRdjd6bVgzZTB2enVreFVDa3M4b3BOTnlwcTZRNEd4L29aNmFF?=
 =?utf-8?B?azhrb0R6cCtWa2pQZUVRRXZ4N3NRTjNoRlZYSWM5bGtxQ0c0SDBMbkdSUlIw?=
 =?utf-8?B?RWNIT0RkMGIwMndjYjQxbFZHYnlKN2pLZlgxT3NmRUI3bitrNnErM2hHL0JY?=
 =?utf-8?B?NE8wVHoxMkxvVjBwYjZWYVR6VlE0OW5rWit5bVY5alZWcEIxQUhQeVJ5ZEZz?=
 =?utf-8?B?R3Yzc2l2Nm13QWd1RG8xWWpDQVFkNWsxV2xFWDdyNnMrc003Z1dJTUpiNWpH?=
 =?utf-8?B?clU2VVhib1JrakpxUStCbW8xRnhYczNGWWI4a0pyNUphaFhwZTljMjhlTzhP?=
 =?utf-8?B?Q0pHODV2dnBBMlBKcWR2bURpR1hUZE9saldCODE3OVI2bjdtU2psdkk1VU14?=
 =?utf-8?B?VnNOSFBpUlRVRDc1YzJ0RFU0YWVFN3JKaEpHTUcwNzJtVk83V3RpRjAzRkdL?=
 =?utf-8?B?OGN6L01QbWpTWXAyejZVbUp0Tit1cnV4V1pPYUxzaWMyM0ZOaldLUlNlOENy?=
 =?utf-8?B?M0ZLL0E1emV0TjZvdmgwMWY5V21tT1ZHT0FNWmNsYk13T1YyS29rWjhmbW93?=
 =?utf-8?B?dG5yZUFsVC9TL3lTbldjM0RKc0VKQ2hoNkQ5K3dZSCtwclhMNml4TVRoNHpp?=
 =?utf-8?B?RTY2VkplVzFPc0IzQ0FIZzFaWEs5YitmWTNaclZaR0NlTzNoTXNFaHd4dEFw?=
 =?utf-8?B?aVFUYUlVSkRQTmQ4a1QyZHd1d1U3d1ZHeERVM0FGcXc1K0N2eDc2ZzlTaVR0?=
 =?utf-8?B?WDRvRXBXdXpEWmhja1BtOHBweFdaTHA5M3dHVTFBanVxVFpOYU5mUUQ5ZVNi?=
 =?utf-8?B?M2lhQ2Z6QktaUjNvb09NV2lOWFRoZzRNa3dBYStienFmUFlKN0xNVElsRlFw?=
 =?utf-8?B?YmJCTlJIM0FjdDFxMXpJRlBwL29LNWs1K2JlMzkvV0s0Vk82N0psb0MyeVhJ?=
 =?utf-8?B?YXNEby9FVXh4THlLZFlISWVOcnZZQlQ5L0ltdFliK1J0cWFtb243Q1BTN3NC?=
 =?utf-8?B?YndoOXJGSFFGcXVDcjlza3Q2b21xZmN1SS96UW1OYWdYQkppejQyQTVXYjVM?=
 =?utf-8?B?OGU0MDBPWm9tZmc5bi81SWpEY0YzWHB1RjZkMytzOG43SFJVQUVpdGRNOVk0?=
 =?utf-8?B?aTNRZTlaVGZWdzdYcHQxbnltSmdkS3FoU2pLOTczTVc4RkZWNWoyb3dmeUNG?=
 =?utf-8?B?enJKZkg2bS9CWjFZd1RJV0JNTDkyMnpWbUM4SFNvaGROdW9yTXduR3QvaGQ5?=
 =?utf-8?B?NFdqSHdGWkhWRE5BSGcwazh5QThqYkRZTkxQVEg3R2N6NVI1dUIzKzhjV2s3?=
 =?utf-8?B?bXluSTRyTlExUW9YbFo0d3NYK1FTcUE1SE16KzQ2dWlZS3pCbGtrRXhGcTJ4?=
 =?utf-8?B?c3p3OEJQYVB5M0JydHdPTStLNGpaWW03dUR1ZzNpWHpRSEVFM3NJRUNLOFhn?=
 =?utf-8?B?c2ZacmJ0RVlUTHpBZ2ZMTHJyb0IwTFp3a1pUR0xXYURhNW8vY21PZktRbG5h?=
 =?utf-8?B?TE43TVVPaG42WkxlRTBVWmhIdDVWQVBTaC9YWDZ4cWltSXRzR0M3eU1IdXMw?=
 =?utf-8?B?Z3BiWDlhOFE2cSt2Smxmb0lSOVU0dXVJQ3cvcnB5QTM5MWNENWs5bjQ0dEVh?=
 =?utf-8?B?NDBkUnczOHNkY3Z6bFl0NTlkaFQzRVUzOFZIUVdqLzBpcFBsUWJOVnN2RGJC?=
 =?utf-8?B?cU1wOWZaMVdEOU5FOTlBeFN6TUM3N0pYL2FaN29UZURWR1FPZTdYK0gwdkRP?=
 =?utf-8?B?eGEzT1pNbDVFa0NaWXF3anRHOUJ1MzhwbXVHNmphMDhpWGYyTURXaHZlQU83?=
 =?utf-8?B?dVFKQ1NkSTR5VmhGSWozZ0EyLytyL2pWYy9UcWFwODFFVitXYXlEcWxsTFNv?=
 =?utf-8?Q?E58g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f66f00e-6aaa-4c10-2186-08ddd025216b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 11:26:45.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXz5X9x19Q9GL/k6VRnTlR1htpjHFbr083Sh8MXSEAcf5UiKUsnYzXEhDqq16/Vw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9739
X-Rspam-User: 
X-Rspamd-Queue-Id: 55A1640003
X-Rspamd-Server: rspam06
X-Stat-Signature: q11togyrgn5bjqdwup4migg653sz8e8w
X-HE-Tag: 1753961209-603925
X-HE-Meta: U2FsdGVkX1+X0ls9lZB/IoyZZSmTUgzndfyHXXyFSRI7LMRgm2a3P0nen+J6ziUIx3uQ3+3dkOE161xCQDj9PG4LDiHSSFv2z2DyvEs8vAOk7hl+gFYPIZ3j759AGt/ykW7cmgng3QRkkQdkoYWPrZhBEqULSxT39pHiqYVIV5gLpkYw1NGgZcRtE9JouG0l/p5x8Vo7yxccblbMK+NW3IO4Kyy83/X8278uxsK4+7Mc0O6oWusZy0iOwFlUeDbCuZ1zqDbzfxo/OEXtlL5D8yWbjUDFXSvFEGXEgblwYXRXdo+6zS8xUE8kwyv5fSHstJjyBkVTb563Q4GFvm96pKV2KJJ7PVrh2OuI/AK0sjuUbju5r8I5DmVhq6KGL7amWODA+XsLOeuGoV8e+TjoyzmBDkHjZvHNf/O7h+BD0e6VtyYYi0bogcrSfL8DlUEo9eyjj8PCmipkL500g4LU9YoSgFoSdV5Ma3gVzJgVBNXct+oXSjh2zcOvo/xy7EdkfuKct0+eTbAbgRVIUEM+8h6ppPI/gHhduHAZ5SD9kup3yMwPCxJBUSp13cs4LIzksWMgVgirQIasw73XMom+k8i2mOkRFgIlbsIu/WAye27R3rP5Bb+0l87jGQi3lKQana7SJRMKqn5UEdphiC2swCOcr1FGjIIbQE4ijJWJghNsbaaKz8+0XlcRMoIfQF5c5mH9EurhoxXRcctOVvAsv4v6iinOUxXA7+O4feMOiG6GONTWZsSZMlFFZGsKzsQA/vk4iL1UazOI8CaEY24dZV+PTbyZ0kyH4I1u5mQEaUF83/7qooXwJylE2h5Pe5pH5nIdqJEV4OMGJ1D0veH+8mVb5mJ3jGLDDi/SVOWBX3pJNFb+oNabyClqENyLAUWTFNlucmBG/OfZYoOHqEyw6gefP8SVmOgZ3DGecmACRlUPm9HSsugtM0DIuii0AyIv4QHtzo2CyijkfqQDrpJ
 tK5TcLIY
 MG7uHAy5IfKkq0N9mD9QR1AnswdQg2eJN0psGFRXH/vWeW4iUYa0CevJ8KQWglEdvsqzLEsuifiCKVAgCZ99R/l/fXXqgq65PC7wtXR72Y+aT0ABKUHbIYqLWasrNeKanZrGV/xcIuumdkd18zuRU8r1dsoLks+rUC9c92m5Nqc8RJSz3/UVNl9/WuV93SqmUgijBB1wU7DMetAEDJ7qQGsJOmjqQWUxeHPnFXw6EClRq5Ymf4ttyeNxiRusPnOn0GYmoAo6722vTChC5ukxWKwwg+MsJRnjSQqM37alLLnleo31Ctk6oY+wf0GrrtKHL6K4CdEHEniKcRgyfFBjUj9xGiDczwV4C5I6d9UWyYuS/6+COFeVDCpOPYAE5FvNySiucPMx3CoggUGy2NmUFUh2IDu6MSuIQm1ett9WyF8f8QosMm0hgvdno9ChJWQ+DtvOaiWTkGLzwOOTBhldkpTyqLW3Q6/Dd8aKwLdx0lSmPt4KVa+kvjZC3m/qcMk/3Qq++IDFgKOMD3pvD6zEnchho8o0S6pMQs+Sjb1BG8aXA7O25zroPPH/Z6WnzQCiQXwrnOdnIZ5cN2nS7dVyiPQ1HiEHKoIsqr+PhLwHaFMu8/TuSm5IJctu6x/4LQ5diqGlnXl7de7NEPq3nMMoD6a2DyQ88p/r2TBq/cnnUUTqrV8uq4nzpU5DKS3ACkmCk7k0cNTCaJX4NkpeP3gvMTgrbNcoLb41FbicDLuyNvdM5W50rcJs+AvbSkcNSglbPfTZXyXR+eqPOHPcldzzq7s5/rxE1dXA6R0WD7Db1F3BQO+2ghKyZuX0EnzCTfLHFtIx24eiOoYdpqn2ghDXbR3feSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Jul 2025, at 3:15, David Hildenbrand wrote:

> On 30.07.25 18:29, Mika Penttil=C3=A4 wrote:
>>
>> On 7/30/25 18:58, Zi Yan wrote:
>>> On 30 Jul 2025, at 11:40, Mika Penttil=C3=A4 wrote:
>>>
>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>> On 30 Jul 2025, at 8:49, Mika Penttil=C3=A4 wrote:
>>>>>
>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttil=C3=A4 wrote:
>>>>>>>
>>>>>>>> On 7/30/25 14:42, Mika Penttil=C3=A4 wrote:
>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>
>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>>>>>>>>>>>
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages awar=
e of zone
>>>>>>>>>>>>> device pages. Although the code is designed to be generic whe=
n it comes
>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work =
for THP
>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone devi=
ce huge
>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code mi=
gration
>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_wal=
k() will
>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locatio=
ns that are
>>>>>>>>>>>>> not zone device private pages from having to add awareness. T=
he key
>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The ot=
her
>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bit=
s, which is
>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>
>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zo=
ne device
>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Zone device private entries when split via munmap go through =
pmd split,
>>>>>>>>>>>>> but need to go through a folio split, deferred split does not=
 work if a
>>>>>>>>>>>>> fault is encountered because fault handling involves migratio=
n entries
>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected =
to be the
>>>>>>>>>>>>> same there. This introduces the need to split the folio while=
 handling
>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped=
_folio()
>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap an=
d remap
>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++=
++++-------
>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>
>>>>>>>>>>> <snip>
>>>>>>>>>>>
>>>>>>>>>>>>> +/**
>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device pri=
vate folio into
>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_dev=
ice logic to
>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>> + *
>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>> + *
>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via=
 folio_get
>>>>>>>>>>>>> + */
>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>> +{
>>>>>>>>>>>>> +	struct folio *end_folio =3D folio_next(folio);
>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>> +	int ret =3D 0;
>>>>>>>>>>>>> +
>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio)=
);
>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, =
why can't there be other references in addition to the caller?
>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unm=
apped in
>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not a=
ware of
>>>>>>>>>>> device side mapping.
>>>>>>>>>> Maybe we should make it aware of device private mapping? So that=
 the
>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private ma=
pping,
>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfr=
eeze,
>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>> Ah ok this was about device private page obviously here, nevermin=
d..
>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio =
is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>> The folio only has migration entries pointing to it. From CPU persp=
ective,
>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps =
a to-be-split
>>>>>>> folio by replacing existing page table entries with migration entri=
es
>>>>>>> and after that the folio is regarded as =E2=80=9Cunmapped=E2=80=9D.
>>>>>>>
>>>>>>> The migration entry is an invalid CPU page table entry, so it is no=
t a CPU
>>>>>> split_device_private_folio() is called for device private entry, not=
 migrate entry afaics.
>>>>> Yes, but from CPU perspective, both device private entry and migratio=
n entry
>>>>> are invalid CPU page table entries, so the device private folio is =
=E2=80=9Cunmapped=E2=80=9D
>>>>> at CPU side.
>>>> Yes both are "swap entries" but there's difference, the device private=
 ones contribute to mapcount and refcount.
>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>> When a device private folio is processed in __folio_split(), Balbir nee=
ded to
>>> add code to skip CPU mapping handling code. Basically device private fo=
lios are
>>> CPU unmapped and device mapped.
>>>
>>> Here are my questions on device private folios:
>>> 1. How is mapcount used for device private folios? Why is it needed fro=
m CPU
>>>     perspective? Can it be stored in a device private specific data str=
ucture?
>>
>> Mostly like for normal folios, for instance rmap when doing migrate. I t=
hink it would make
>> common code more messy if not done that way but sure possible.
>> And not consuming pfns (address space) at all would have benefits.
>>
>>> 2. When a device private folio is mapped on device, can someone other t=
han
>>>     the device driver manipulate it assuming core-mm just skips device =
private
>>>     folios (barring the CPU access fault handling)?
>>>
>>> Where I am going is that can device private folios be treated as unmapp=
ed folios
>>> by CPU and only device driver manipulates their mappings?
>>>
>> Yes not present by CPU but mm has bookkeeping on them. The private page =
has no content
>> someone could change while in device, it's just pfn.
>
> Just to clarify: a device-private entry, like a device-exclusive entry, i=
s a *page table mapping* tracked through the rmap -- even though they are n=
ot present page table entries.
>
> It would be better if they would be present page table entries that are P=
ROT_NONE, but it's tricky to mark them as being "special" device-private, d=
evice-exclusive etc. Maybe there are ways to do that in the future.
>
> Maybe device-private could just be PROT_NONE, because we can identify the=
 entry type based on the folio. device-exclusive is harder ...
>
>
> So consider device-private entries just like PROT_NONE present page table=
 entries. Refcount and mapcount is adjusted accordingly by rmap functions.

Thanks for the clarification.

So folio_mapcount() for device private folios should be treated the same
as normal folios, even if the corresponding PTEs are not accessible from CP=
Us.
Then I wonder if the device private large folio split should go through
__folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
remap. Otherwise, how can we prevent rmap changes during the split?


Best Regards,
Yan, Zi

