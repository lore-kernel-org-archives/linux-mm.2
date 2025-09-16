Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF05ACAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1355A8E000D; Tue, 16 Sep 2025 08:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E60F8E0001; Tue, 16 Sep 2025 08:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8998E000D; Tue, 16 Sep 2025 08:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D193A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:22:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A85A65648B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:10 +0000 (UTC)
X-FDA: 83895025620.23.35BC451
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010061.outbound.protection.outlook.com [52.101.56.61])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB4B6180008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=alLmTMBM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkJsayUQ9WeqaHEAG5BVnhagrGHSvPSfdVHrNe53WI8=;
	b=GASy036TlyqYvHCSDU0UQH66LSxos4PqUSv51eG5GM5cKyxopvg5hjAraPXg5gwtBzZ5h9
	SrjxL8Vrw4hbJ0n3k6aqKnXd1qOt8tk9qEw12EpkNMrwJalLYT3Hd90EwloYJ+bLdIIE8j
	aX07I3r0Jst38MCuJVuD19X5h3yAjrk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025327; a=rsa-sha256;
	cv=pass;
	b=B+Jw6Wzb12k7oQAfYkJDb6kVv268iMH6SX0KK2KMfyZXTJY1RO6+6hEfKlRoX7tKeGwVBZ
	Z2ne2P/FziI02ElfTrpvPzzWhVLQd/XZMCGX7cLz7R/CZA0aNK+4Icw+nfb98HzBIGPUWq
	X0SJ+ABDYsiLJv1yAtlHKoY/9jyvYMY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=alLmTMBM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSt+WazzKBm0O596zQvjwJsKUc/USZ1FMmPyzBZbTnnttqa7DyNub2sRFx8BgEcdAAR0T0tA+IphsbQJSJHUmSf6sjr2xcO2xZy4G2HlbFYKcA6dpAnGHx/9bV4RyFI0/9oNAvj/+cPJbB8LYhYxzNKS1gW8qC2osHjhaxNAqU6gSj1uMLUEve5+NG5TQvOMV3kmFTpUSv2mYQa4kOpWrcrw6R19m0qfZcc+Vb9c5X9WLgipU5mctiNpSXNzGidoUCehqH6eqRnBzv/Mp+uC0h/NAiVXRtQGhjwscslR0umMDfZOD3/B/bQ5jJD9mGGloJdx9gjur66FuwpjMGQeBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkJsayUQ9WeqaHEAG5BVnhagrGHSvPSfdVHrNe53WI8=;
 b=QDr8tdd5rDqeErur9PwZ6UXgkC6ZwCz3meNeQvU56h2scONgTtbUra4gIEDnJ0V7uo0Nze9/DhBQrq9OP/OwrY4k69r4jdgDZABvS21MJ0t7kepmnLh481sps42pveeSCXDPTHHvCWGSCSnB0K0lprNMvF/QqNhyeUxHJ8zM4FYjh1FA2XGdYsMyUJjNeLMl2b+tG1JSLc/DBIT/PDGawLSGCzkcRXoPqa7MI8k83gbWRfHnBMGXofhCd1VRtYei5JeKkeNu0zysK3Kvv5GdG+dH0TAG0wKLk3H88x6iDyMXAXtclk30OHpuoYdoqgYW8iZQjiCVRBcBmhe5ho3BPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkJsayUQ9WeqaHEAG5BVnhagrGHSvPSfdVHrNe53WI8=;
 b=alLmTMBMjAV4KjZrEuDNsTAIfn8YX4JAgE8pCzZJMK1SW5ji/Okbcq0MthGrYII306oA1ScwobPt3Y9x800robVIXuuftoTSlG4JW/TlUUfOqkc02tOIkynPRWMWBt9BH9eBFBSIvemnK2KDVWWZ73AMAGmf21prZ17CccLx38IV0qOD86HwiY6484SIiPux+cIBB0M+AicDCzWRqlWYTB4sMefO4CSp/kl5Nl7cQvxLf+O/d4j1armQgPCyeLkcpHImKzU7CNIhJFotAG7jLo8IEL6g4lPeg66eKclkR42nLTXGX5x3oC17yVEjJQwz5vFaxsCJhcOjet3PCClxrA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:21:49 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:21:49 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v6 04/15] mm/huge_memory: implement device-private THP splitting
Date: Tue, 16 Sep 2025 22:21:17 +1000
Message-ID: <20250916122128.2098535-5-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::25) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: e0f96ec9-4c42-4746-011f-08ddf51b9c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anRieE1YbFZOY0ZzRUtrK2tnZmgwNkV3Nkd0d0xkWURxSXErTW1wdVhLLy9x?=
 =?utf-8?B?bmNOOEdxRlRXSGJIZTQ0VExqRW9uWGNPUXdBR1NXb21aQWxZNmdzOUJML3E0?=
 =?utf-8?B?S2lYcThDN2p5N1VrbFBKNC9RMW9ldktqNTlvQ1dvZGQwWjY5Y2RrZ0l2RDMr?=
 =?utf-8?B?MGFVVUFMYnovdUJEMGtldWl6Yyt3VHIzbHl1WHhzOVJWZlVTMmkwNnFZZlly?=
 =?utf-8?B?dU9GNlFBdW1vYnYxLzBmOTNWaXBrTW05dkw3Y2NnYkNVV1VWWWlPS3Z0WXlx?=
 =?utf-8?B?SlFaQ0RFaDVTb2htTzBIUU5rbm4vaXp4TjgzeGgwc3I4WWVQNmppRkpNek1C?=
 =?utf-8?B?ZWVoU0gxZWd1dG5ETldrTnN4dGJFdnlkQVFJOUZGcmgrS3Rtb3hRcVV2eHpK?=
 =?utf-8?B?MStRMk9zM2Y1QkR5blB0ZVdKcmR3alJxWWFXS0d2Sm9LWEl4MzFLeUg1Vy9h?=
 =?utf-8?B?Vzg2ZG0wZW8weVp1RGlFZ0NadEJQekk1aGQwUFg2emRRcXA1cG9KemhMc1ZR?=
 =?utf-8?B?R1lUenErVWxUV1RYaHRXd0pkOEZvcGlFTDYwdDR4MzZCcWd6dEEvMjBqcUFn?=
 =?utf-8?B?ZUNNUXJQVGNEVW9hdWtPZnlxMmxobEVFalc3N1MxMWZNYjRqM0hHdlpiZERD?=
 =?utf-8?B?QnlsRVREcWp1MzFaZ29DRUdnOHQ4S2hhWm45b1NlRFcwNHhLUlFJVmxGZGRV?=
 =?utf-8?B?d0RKNk52RU5STS9kMnpNZDhYdlMzcDRkM1BmRTE1ckRFVjlqMnUva0prdjA1?=
 =?utf-8?B?aitiQUthWE84LzRVNlVsZHNtQzRReFo4RXBNWDk5SGZyWUc2ajY4c0d3S0dM?=
 =?utf-8?B?SldOS2xpcGFrUzlMdDYxMmJZam9hVThqZGVHQmhxcVF6S0Mvd3Irc1htNERv?=
 =?utf-8?B?ZXM0S1ZuTVVXdXNUUDdTRWZhNzZkQXU3bC9hU3ZKYWJEN0NWdWtaS2JESGJx?=
 =?utf-8?B?Vk9WbHVoS3VLK0tob0xmdjlGUjRyVTBFUmlIeXJDQ05UNXRtYjJiT3FPaGNT?=
 =?utf-8?B?eGJQZDlSalFOSW4yeVBHSGZ4QUkyK2VVMlhtVUlvdmF6dDdzeFFycXlLUU5F?=
 =?utf-8?B?NUVJYy9NaVdmUm1NVUpTWFBrOStaNkMyWndSai9meXpLTytXMmxxc0ExSXZw?=
 =?utf-8?B?TjhpNUxCUEFTWmVWTUU4WGovam80RUpEazQ4U2h1VlUzVkN3bmJPeUZnVkZC?=
 =?utf-8?B?UHZmdnRjK1IzZGhJUVdXRWVNTVdreWJ0a3NDRFVLTGRWYllvYzdkbGFhODlB?=
 =?utf-8?B?UzFKYzBRLy9GQ2F2UkEzUTdFTGFZaURrZHMxa0ovcXhKVVRseG04bXIxVytm?=
 =?utf-8?B?N0ZhY3NnRlBrcGI2aXpwclR2aENTbDVIME9iYVZkRm1WTnJLS0FPTndoQ2c3?=
 =?utf-8?B?Z1BBaTB5eTVVSTd0c1VNRWlldzVJMXRhNDhmM1BJTlFHNU8zcHhNSjhtSXpD?=
 =?utf-8?B?YUxCQmU5NUwrWXZnaXl3ZDM3ZkdxbU1XQVhvcTlwUTBZUzJtbWFJaG01RU9W?=
 =?utf-8?B?ZUN2SDdyL3VSNk1kUnc3K1M3ekF4aUNRVy9nQk1RTlhoSXFWOWNZM21uamU2?=
 =?utf-8?B?bjVPTCtRUXB0aXlZNjBBVFNvbDIwbHFsdDdva1ROajJ1eGV5QkpZbC9rY1lk?=
 =?utf-8?B?cEl1ejhuWlNWcnFhTE02cTAybnhGb0xzUGthZlhjSGhjc1NUTlJvK28vMlk5?=
 =?utf-8?B?ZkZuLzgwOGg3emxGNUFWQUg0eTZsbDVZVWVXREpKeFNQQlhyZTZ1QUNZbElL?=
 =?utf-8?B?TkFLTmUyaFl4V1hkNlNQaDdnbUVoRkI2TmRqZ1F3elB3dWNiWE5UUGM5UFkx?=
 =?utf-8?B?S1dvamhtQm8zVUNEYnBmazdUbDFsTnUwc05vcXR5QlIycGtlYkVMY3RYK1RF?=
 =?utf-8?B?VmRFYURaWkNNUzZ1MzVPZ242UDNINVVRSElUaFZhRUJobjFjeW1tSnpFRGVG?=
 =?utf-8?Q?jB4P8CSoxPg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RG9IMTAzbnJJR2Z0ZnY4ZEpWUkU0WnNZZzFoYXZYYS9QZFlWMHdyME81L1V4?=
 =?utf-8?B?bzdwVkgzQXZjTWpKMWpIbjJ1bWpXa3M1SHlPejd2TXdxZXV0VVptOWtUbUZC?=
 =?utf-8?B?V3J3Z2xjeDBkaVBjSVlUK2kvSFdMUUF4NU5QcXJnNW80N3ZPcElNUE0wcWxj?=
 =?utf-8?B?cjM2Rld4dGlhRjM1MVNWL0NsTnFvTFhZclp2M25MMHRvY00wU25WZVNRNUEz?=
 =?utf-8?B?K1NSRldUdEk3aDBpUDRPYnQ4ZlJsTm5GaFFLcFZwQTV3a1V4WEQya095Q2V3?=
 =?utf-8?B?ODRVRlh0c0Q0SWdaRW81TEo4TWpuM2ppdXRMTEdhVGJ5L3RPNk1VSEd6akcr?=
 =?utf-8?B?Z3JqcnMwbU9YQ0pmWUIzM25Ncy9qWUxsN1FOSWxLNVZMYnlIcDUyRGwxSGdG?=
 =?utf-8?B?ZlNnUHdVMmlPdTQySUNsTEhaKzVyUXU4bDduc2VZbkNZUlVNUUttVm9mS3A4?=
 =?utf-8?B?ZHFvbkIrSmJZVC93MUh0UGJvZDVrT1J3WStTc0N6enRYNUZCa1V1QmlVeTky?=
 =?utf-8?B?enpSQTl4aVlCZ1FqSmxscW90aU1rZzNmZURia21NVXdKWGk1N0hLVlV1TGFB?=
 =?utf-8?B?Z2V6MUFEL3FwMUJnVE9GcFJ6OXpDL3NXSng1ZmF0eGIrTmc1WC8yU0JoaDd5?=
 =?utf-8?B?bGF0akhPL0dVdmNuVWNVbUFqb3oyaTlDa2ZheU5oYzVJQy93MkI4YmYyMGNh?=
 =?utf-8?B?aXJGM081MnBsQ2dTUys4dlRQd2dHWEkrUmlCYnN6d2IxTWlCMXR2WEwvbzFM?=
 =?utf-8?B?R0RFOWdyRXcza2UrUEpZQzcwVFNyS044cWY0SWVVMTZscHdGZ2pRb3lDWWtM?=
 =?utf-8?B?a1JoMzlUYUNFajFUbitUMEJWVElvNXdzNEpVTFFkRmhVcmIwNm9PMjJtY253?=
 =?utf-8?B?V05rb1h4YmljdC9WdGx6cVRFclFGYTllTDdWblVkbnoxcXoxWTF6NDg1TkEv?=
 =?utf-8?B?cys1aENmK3VLeGpublN6Sm5QZG1ZSnFyUlFnYi8xdU1jVTBnUExCdHFDcHll?=
 =?utf-8?B?SmdES2h3NXlwa3BTekFjMExTeWRJMlBjc2I4RU5heEhUL3RrSkNjcGJFM080?=
 =?utf-8?B?RUFMclRRVi9iK2xPSXNLNW5uMmJoRXlLdTlaZUlRTytIbHY0ZlN0RlNnSHRK?=
 =?utf-8?B?eml2LzI4b2p1Z1k1SlpsVGtKUFlXTzdZTFRBZDFVODgyMWdwWjJCR1pvaWQ3?=
 =?utf-8?B?bmlueXJXR2duSWpkMTQ5c05tWTlwK0RxVTcxbVVZNDFFcmJDdFYyNnllY3FN?=
 =?utf-8?B?a3JNTkk5NXAzZFBacldablBJaWU2WkJaNHgwQkZrN3NnMnQ3QnMyMDNkT2F6?=
 =?utf-8?B?VnVXY1lIbHhqTERkVi81RGhJR0IxSGhvakI4cUQvTDVVR2FadmphUExrd1N6?=
 =?utf-8?B?OFdndVpwWVE2bG5KdWVxdkVpTjRYQURyckdpQjNYWVMrdXBXZGk1bS9CKy8r?=
 =?utf-8?B?emJORHBBb0VLQzA3UWp4UUJMcm9iaW5tTy81UlJuMjRDMGREOVE3UGhjdHFj?=
 =?utf-8?B?cFZra3NYNkRLQitCVG9xM05KU3pJdEk2a2dld2V2ME5lbzZDczhFTlQyNU9N?=
 =?utf-8?B?dXZUcGcyOTRmckZzK2tnNHU0Mk1EWGttSUZFQmIvaTlLaHY4NGdjajQ2YmVO?=
 =?utf-8?B?L2VnVTI5MmdqSzdxR3lnNlM3WGRxNEJlbkJxRkNsV3A1QTI5MGNNVlJWd3Rx?=
 =?utf-8?B?YjlpNDY3QkJSNEtteExlM2xJL2t5UjhMYnpDNGxWWXpqc2lPZ3kySDJESXVY?=
 =?utf-8?B?WmMzK21DUzBTdEllRTNTeWluT05wcEFrQWlHTjlGb09qaHRtWEtnN281VjdK?=
 =?utf-8?B?aEY2Tk5OUkVkY01jOTAvd01BbjBhQzFVc2FySlFMdmpMY1h5TW9MQ1pLNEFF?=
 =?utf-8?B?RzR2T1NZdThmbzF2OXRzV1pSenJyMXgrR293dXNTejFuSCszSFlpcGRkOTh4?=
 =?utf-8?B?WnlCQzJ0RTJCZUxQZGNvRXBTVlRKeHpLamw4TWpra0ZLM3JuUTdVRi9pU1lS?=
 =?utf-8?B?WVowbHlIM1FESDRiTDVxY2VtNG9KWkd3VTZRNnUxN2Q1Z2RybmpWOVVDNnNw?=
 =?utf-8?B?bVgwVXV1VUJSbEhxRjNMK1RIQkhpQjNKQzR6dFgwY3pIbFZqOURqNG9ZMzJj?=
 =?utf-8?B?MktTNzNuL3BITlpIRVY2Z0t1NXBiSmhqV1ZIMnlqc2I2SGt3NnF1eExVSklL?=
 =?utf-8?B?b3c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f96ec9-4c42-4746-011f-08ddf51b9c26
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:21:49.1848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZU3ceYu0PH23/BqxTot3Xau2Vi6lCq2kI4PP6E4ry/UtVx12KHCn80CWVPvE7G9L0n0jhFvcuj/T7pY4CEmySA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB4B6180008
X-Stat-Signature: jzetbr4484wg1y1w8819uu46oymnnajo
X-Rspam-User: 
X-HE-Tag: 1758025327-347478
X-HE-Meta: U2FsdGVkX1+258l5CchPMPh08R0zyjEHDalCWY8R5qZM/5ZiZ17y2Qd1kBjqWPV9LPE9smwdnAAE5HY6FqkOvMqp1tw80FajaM07MIo2C7jwRWWIAsjj++/lhqLlC/amVbD7ntGsG/LqRJyAPmVxKwhs/GuVI02Y7EDMQNYTeYdknJJgDS587TEYmUbksDwAGxK3Lco9TO1XIlRHc424G8dPOrVULZtj52KXTlMnEm63JYYRPprxOaVTJLBXsWZAZO/1L+R5zGM1jBl6qq9Y7xqoF4kqcXU5GGCS8DjFiT4D/ILPo1BIn7OYIR6aRrhXQbZSHPEyJgalb8xN1YOMBLsB4RzRQmPn+MbjEToGiidQ5dOxt8eIJ50JBrq+K6MqvRp2f+JIN19jVPxqywU14J9jL8kupVd2MtxF2HFg/VLpMuaK98WWPBNzOdmJ8QII+8Jti52ctxNizq1J2TwWIL/IsiIqmxfJJ3TV7oT2b/SIWqGxwlywejXAKTHG/URXoIwFyO48zU4Vp/G1yduBYKziLF2OjWw6JC8lEeljeBBn5gVVXJL6d2u6SuQLJEkWh65Lzzk3nW2gO1i5RuelOWLkkdzlNanUYmiTTraj8IwSjrCTXE7hJb4TnIjkBOxVGUy6Z7yBoHaq+laVeI5WXRjXJrGXOiVDiXPqGolg/bmm2lsmxJpfdl8kqGgpTHqslqwop+X7upzHQmQcdVKO+auUDkjoMLHkqllW2vuwLrVG3w+/Eo0WDA8XGAGiBEZw6XNApQnO9h/x5ecBP4dpnW/v9yW8qRTyKpZqx70muwioidb32kaFFQb5Int8apZeGt286LXqtl6kM4anCh1CbZxIlKu8Y5noKM1SQXq7ZlqlC59TSej6yZwEzqwCh65R5Wgn/Ok49ip0VcrZGDAw2cgcaAN2X/5eDn/UztsN6t5tdnsV2HU4nVtsECL2uFwSDeCOYcsuZrOR8FqrEjB
 6CORE5CP
 TWmIur9/q/VM66z26sDEfqdZrVOPkzv+AxDmpL6MverGtJz02yYPgcqX5Tfz8aC87LT5/hVm2aYAXzpQAjarryEKGoctryTcdD92xnlc+yaC6BucNqERB8Ex6J/ozrLNqs4kiXAGmzOkh3H6DRkZ9CicrwHKuBRYJJnD8k0YhO7T7tDcUJhToFcVZ3ME4ewvwC7HeVwWHoNyBTXuPh5my4Fes26mc46NPmP1tHkMC1EP+tfECWdx21f/m+EyuvWjr+XfT5sO+vPSFhPqlAgUlQsbNpopJPDesHfNvfGUsm8T6wdWpw/CBC43j76h9wSpudAO7Gxi+TQbISo7jrAfyXuNUqL2vs5hpDQ3OHsSGwZ0ifMqaLXVWrqZs1cQcTBKTBZBQ9Q/cIX6TbhJrs/v91ne2h2WLQfQ+JrahBQnsyyuOYaQ24ziSFFdernlF19JsGjaWP1miIK7rRRmwdaciFBigtUF5Ra8nGztMcy4Sq6eyLCpevXrLK6C6pbFy0x4QCvA3Th/DnpE6KVggDrnrcdupSe/9+1/OpMJZrZgomg7VbxtNiiK01FFs/WUYY9GEYaWqwqFHf3sekPSHu/jq8z9Gt4AHWz3+shswvPjdgMMUJ+i/+y0TGcFGov8uwyhLSThAjXfIW/NHv+P7YPobdEydBTw3P7qtlt6C24+ldHCHwqp+Qdv9hzrqvzGh5hpJTaWY6EGYoUO7KsOxIZTQnrlk5TJ+iBTewYDgw6g3Wr//cUPZwuSM90IL9PjOMmnnep02BS+8/QbDMXJUc7Bb5dVjbxlDgPtjU94fWgaDwCBW0H7xOxZzUEicUaNktNARWtSXn42d2bpEy4e+9C2+UDq3iiPyF7Sl9qaK/9VK3L48xus/D3PrQlP9KmXIH1/siNBnToWlyKNLLhQBpOeJoXrWvzhZSsMcfh2gwk2lFnf/HxL6x2MHqkbCG4ru+9PA+OZw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for splitting device-private THP folios, enabling fallback
to smaller page sizes when large page allocation or migration fails.

Key changes:
- split_huge_pmd(): Handle device-private PMD entries during splitting
- Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
- Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
  don't support shared zero page semantics

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
---
 mm/huge_memory.c | 138 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 98 insertions(+), 40 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 78166db72f4d..5291ee155a02 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2872,16 +2872,18 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
-	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
-	bool anon_exclusive = false, dirty = false;
+	bool soft_dirty, uffd_wp = false, young = false, write = false;
+	bool anon_exclusive = false, dirty = false, present = false;
 	unsigned long addr;
 	pte_t *pte;
 	int i;
+	swp_entry_t swp_entry;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
+
+	VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd) && !pmd_trans_huge(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2929,20 +2931,47 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	pmd_migration = is_pmd_migration_entry(*pmd);
-	if (unlikely(pmd_migration)) {
-		swp_entry_t entry;
 
+	present = pmd_present(*pmd);
+	if (is_pmd_migration_entry(*pmd)) {
 		old_pmd = *pmd;
-		entry = pmd_to_swp_entry(old_pmd);
-		page = pfn_swap_entry_to_page(entry);
-		write = is_writable_migration_entry(entry);
+		swp_entry = pmd_to_swp_entry(old_pmd);
+		page = pfn_swap_entry_to_page(swp_entry);
+		folio = page_folio(page);
+
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+		write = is_writable_migration_entry(swp_entry);
 		if (PageAnon(page))
-			anon_exclusive = is_readable_exclusive_migration_entry(entry);
-		young = is_migration_entry_young(entry);
-		dirty = is_migration_entry_dirty(entry);
+			anon_exclusive = is_readable_exclusive_migration_entry(swp_entry);
+		young = is_migration_entry_young(swp_entry);
+		dirty = is_migration_entry_dirty(swp_entry);
+	} else if (is_pmd_device_private_entry(*pmd)) {
+		old_pmd = *pmd;
+		swp_entry = pmd_to_swp_entry(old_pmd);
+		page = pfn_swap_entry_to_page(swp_entry);
+		folio = page_folio(page);
+
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+		write = is_writable_device_private_entry(swp_entry);
+		anon_exclusive = PageAnonExclusive(page);
+
+		if (freeze && anon_exclusive &&
+		    folio_try_share_anon_rmap_pmd(folio, page))
+			freeze = false;
+		if (!freeze) {
+			rmap_t rmap_flags = RMAP_NONE;
+
+			folio_ref_add(folio, HPAGE_PMD_NR - 1);
+			if (anon_exclusive)
+				rmap_flags |= RMAP_EXCLUSIVE;
+
+			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+						 vma, haddr, rmap_flags);
+		}
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3026,32 +3055,57 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_migration) {
-		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			pte_t entry;
-			swp_entry_t swp_entry;
-
-			if (write)
-				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
-			else if (anon_exclusive)
-				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
-			else
-				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
-			if (young)
-				swp_entry = make_migration_entry_young(swp_entry);
-			if (dirty)
-				swp_entry = make_migration_entry_dirty(swp_entry);
-			entry = swp_entry_to_pte(swp_entry);
-			if (soft_dirty)
-				entry = pte_swp_mksoft_dirty(entry);
-			if (uffd_wp)
-				entry = pte_swp_mkuffd_wp(entry);
+	if (freeze || !present) {
+		pte_t entry;
 
-			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
-			set_pte_at(mm, addr, pte + i, entry);
+		if (freeze || is_migration_entry(swp_entry)) {
+			for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+				if (write)
+					swp_entry = make_writable_migration_entry(
+								page_to_pfn(page + i));
+				else if (anon_exclusive)
+					swp_entry = make_readable_exclusive_migration_entry(
+								page_to_pfn(page + i));
+				else
+					swp_entry = make_readable_migration_entry(
+								page_to_pfn(page + i));
+				if (young)
+					swp_entry = make_migration_entry_young(swp_entry);
+				if (dirty)
+					swp_entry = make_migration_entry_dirty(swp_entry);
+
+				entry = swp_entry_to_pte(swp_entry);
+				if (soft_dirty)
+					entry = pte_swp_mksoft_dirty(entry);
+				if (uffd_wp)
+					entry = pte_swp_mkuffd_wp(entry);
+				VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+				set_pte_at(mm, addr, pte + i, entry);
+			}
+		} else {
+			for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+				/*
+				 * anon_exclusive was already propagated to the relevant
+				 * pages corresponding to the pte entries when freeze
+				 * is false.
+				 */
+				if (write)
+					swp_entry = make_writable_device_private_entry(
+								page_to_pfn(page + i));
+				else
+					swp_entry = make_readable_device_private_entry(
+								page_to_pfn(page + i));
+				/*
+				 * Young and dirty bits are not progated via swp_entry
+				 */
+				entry = swp_entry_to_pte(swp_entry);
+				if (soft_dirty)
+					entry = pte_swp_mksoft_dirty(entry);
+				if (uffd_wp)
+					entry = pte_swp_mkuffd_wp(entry);
+				VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+				set_pte_at(mm, addr, pte + i, entry);
+			}
 		}
 	} else {
 		pte_t entry;
@@ -3076,7 +3130,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_migration)
+	if (!is_pmd_migration_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
@@ -3089,7 +3143,7 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
+	if (pmd_trans_huge(*pmd) || is_pmd_non_present_folio_entry(*pmd))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
@@ -3268,6 +3322,9 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
+	if (folio_is_device_private(folio))
+		return;
+
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
 		VM_WARN_ON(folio_test_lru(folio));
@@ -3885,8 +3942,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon)
+	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+
 	remap_page(folio, 1 << order, remap_flags);
 
 	/*
-- 
2.50.1


