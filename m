Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A647CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 04:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8618E0002; Fri, 12 Sep 2025 00:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0458E0001; Fri, 12 Sep 2025 00:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697A08E0002; Fri, 12 Sep 2025 00:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 555E98E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:49:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3059C06B1
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:49:29 +0000 (UTC)
X-FDA: 83879369658.16.4F2F8E4
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 358C340008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:49:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qEGsnToP;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757652567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZbnvhPcJkwG7QOK/UjP2uuHdcWwysF8q7nlHm5aGf8=;
	b=F+C4Gr4xLLrgaI72jQamPb4/Yuhi4rec/dd2hnlylR4weE/H784HsnnV7/Vodf+Krs3Bpj
	sVMc6QwjPLHEkRaSXqDHIESJAr+pplo6P9Mulua+Ymf+SPIEPNyuVMdB6AU3Vhm5dKcK5+
	b5ARVsB16BQkibR7TNQfgIuyA6DA+H4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757652567; a=rsa-sha256;
	cv=pass;
	b=MU9bmRaa6OpzjGwGquarUjLCOValLzQ0ANvVDc7osf53oQIrXBVWlufL1e7h6s+eFmNI83
	rK687F9GXzm7YGyj5011DqtuqxO1/rVY0A0T65cK4+zoCjk4Z8QglyeQS5Hy6s5yFhFQUu
	EOCi9Qooavgp4oDIOgd0OR/iDKRlznY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qEGsnToP;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkxHmzsCS6Dt4OOE8LE0zVmMdpMxZ5EZoRCa5t6eu00RW46RbWrkyhFC3Z10geVhas7X95QKQeKUII3Y3RmNVbBbteqc9aa2nmfb/q0AQ9qGzh/ZNFuc13ogKMOO9Fgvr+oivlp5MJ7AM79mhwovqtn7vPSE8EWdz9e6sMAdll0YOI6KNjuPTYczN0zedNyC9Aj5paGuAdNIOfDZfEdFZkk43X3CbZgbZrceHvN9ioPY+YwRWjVkO0WcKZEpjWuIOGRlH64FctBcOvqSPY/m68YweJq3m39dcL/nKEaMqVjrfWf+DLNyBTFJdy1jLjibJBeKWGxIjptkBGRzccHknQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZbnvhPcJkwG7QOK/UjP2uuHdcWwysF8q7nlHm5aGf8=;
 b=tY1LHYVngetkADEfMRWkl2zwjcQAWOsp7Nvx5sRSa2aCPcKrvSUfAAQX2zuL+ZIWksT5oawJAd6RoovD9cxNjUZlPzEs98BPpI6NPWNOxFy3CEKaOqC3kajoJa+++BBmOuwqH1CFjeWIgFbv5Hs8PZ4u9qiLY1iZ7e94B7G5Hlo0Z7MuNLIIcykEXIWrDkXz99K4CsRa7KzlytkQS770SKAApxfiggl2qVrXul11SEu5rSo3RsSOIVs7b+ngEDPXeZEc+ilK/tydxMLZltTjeqeY5gTYC0mfGyRUbHbbYP99V1Z6j+gnleADDL6QGHyNBpZwlTZzjlWtIU03b6P+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZbnvhPcJkwG7QOK/UjP2uuHdcWwysF8q7nlHm5aGf8=;
 b=qEGsnToPCjH9YInxx29jlRcIDg9HBiCQyangVSonn+l3rVfrAyavwUmN3UoLp98dr0WhwSplxi5io6ZBXCOtoGVRyQwElsDk1BLlIUGaYVPi/OxbWVDiouvg69d8jm+/6g8l0nIvNnoL+a/B9STW+Yp22sHBvJYQesv/pLNBJPQv1aUOMN13y1W1mThK6GX+xNYAB8TGXPqFlcwp9bkAhViC1Xs7WabXde+MWqU7mERzTEuRjK0IcDSR2vsANZTYoN5nr1OjWyWkimBrrm7fommTyJQbI6cQukRdxPpnx/YI8ixabr1/XCIyWLnXlRS8T8VbOoYkDDLb9tIgVQxxfw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SN7PR12MB6791.namprd12.prod.outlook.com (2603:10b6:806:268::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 04:49:23 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 04:49:23 +0000
Message-ID: <ce40579b-4ded-473b-8fdb-a41d5b5021d5@nvidia.com>
Date: Fri, 12 Sep 2025 14:49:16 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 01/15] mm/zone_device: support large zone device private
 folios
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-2-balbirs@nvidia.com>
 <8c5267ec-cc85-4eff-b890-eb705472e2b2@redhat.com>
 <f98d3149-9cc1-4211-af8f-e49547134b8c@nvidia.com>
 <244005a2-4796-4985-853e-f916bdfd096a@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <244005a2-4796-4985-853e-f916bdfd096a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:a03:180::44) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SN7PR12MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b987d30-a074-4d46-9676-08ddf1b7be98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnAvTWw5YW1Lb2R5UnNaRW9LNFdudURyT0s0anc2UnRadCsveDEvUkNJSEdq?=
 =?utf-8?B?bncrRElPa3pyQjJvd2dGTXJKQ2phL0U3Rms4b2g0TzJieE9aSmFOakc4S1VC?=
 =?utf-8?B?TWtucU1WRE5xTVdYSnRUcGRCQUVyRGlFdGRtalhJU0lhcjRkamI3aEVGOFFE?=
 =?utf-8?B?VURjSEFYMW9tbUsyRFo0RnErSkE4UU14UjZLVmNtdTJqWXNGL21PcktScWFS?=
 =?utf-8?B?RWg0ZzdDNjd4aDlBUzBiUHZNdk8wUDdBZjliZDNWY2FWT1BUUFNHampZM3c5?=
 =?utf-8?B?aUNQa3FiakRReFB2RFJsVG5SNlJVNzhLclNrSS85QnRTWmc5c0g1THJ1dWpP?=
 =?utf-8?B?QXUyTmg2NEtmVUk3K2hYMzUyUUZXSzBzSE5ZVmZaeUgrL1NkT2xLWnhLaVV1?=
 =?utf-8?B?ak1DOW1sbXBRSHkyMGdGbEFyS0xhSXZWejF2cDB0MWREczZLQU9xTHFnU2cr?=
 =?utf-8?B?dlpZZzhQanl0M0dwN1JpYktBU0lLV3pkL2JISXJQMnhldzlnVmNvaDN1VUxn?=
 =?utf-8?B?NWNZSCswQUxIQ2J4c1NRUU5mSEkzUFJ0U3hERFEyVkhvdTN2T1ZJOFpGREgw?=
 =?utf-8?B?RHY1cXZwcGR6RVFiNjQrV2lXcjFYN29oNXZKTGlXdkhJWWZDTkNJMUwrdXIz?=
 =?utf-8?B?bDNKek5mdXZoZ2E2eFRGaytLckRkNUNCY2sxNE5JTmVJWW5VT1JQWis5WTM0?=
 =?utf-8?B?NTUyVWg2SzlpY1lGVTE4eW1zMmI4Z2xSMzJWVndBckd3Q1NlbTg3Sk5PSUpy?=
 =?utf-8?B?NzlXb21ldWZKdkJYWi9sUXFkcWQzZWtjWGhzTkdLMWxCenp0Q1Q1NWZaN1Vp?=
 =?utf-8?B?WExDN09lQ1RZNEpFSXlWK0xJNy9RQ0k0c0ZPSGpNYk82eE5WVC9NMHRrU3N4?=
 =?utf-8?B?OC8vWmJTcmhNY3F1UFpEVUNUUWZlWHVWcThCQXoydU9xaXozSmNTU0R5NGpX?=
 =?utf-8?B?YU12VnU5SnYybTY1dUFnUFJEY0J1YnRSV0FPOUU0MG5YNTZNYzN4dmx4R1Ay?=
 =?utf-8?B?OFNjQWJTbk4zZzVRUmlCY3BQdUpCU0dTN2FYNG5OeGFoaG1oMnFmTUFsZmxZ?=
 =?utf-8?B?UVl4elozVDYvT2RsNEtlUHFGZmJyeUd6SVJtdlVCTWRZNE9YY2NuUHRCdmhK?=
 =?utf-8?B?b1BwTy9nR3UxYzhQeWpnRmd6cEJSRkpSbzFGUjVmTDcvaWRQd29xYVlOcGN1?=
 =?utf-8?B?TWEyMXZZTGoyY1JNYWxncGZFQmpkOTFPdjhWT2xDb0hxcjhMWTEvbTZmRFlh?=
 =?utf-8?B?dkxGVW1GcThHd3loSzJaZ0lucGEyVHZkUFlrKzBpdWNKMzBMZ1VtdE5OVU4v?=
 =?utf-8?B?T2orQzM3MnFEeDUxN1I5UHNQczZrTUNRQ1ZqT3NPK3lRRkVMbHNLemxUQmFS?=
 =?utf-8?B?RWdwcXNsOFpnZnZYdHZHUS82RmZFdlFKVVVZOFM1eTZBYktOTHBCSXlmcDJ4?=
 =?utf-8?B?SHEwcWRQcW8vRE9oUUZUUmxLczFlRzdJRXZvYXlaUDZLbVFKNStTTUNmWEY1?=
 =?utf-8?B?TGgrRUttYW04am9GemlMTm92eHQybDRvSmExSzl1Q1ROc2Zmd2R0VHpQVlk1?=
 =?utf-8?B?cG1tU2ZmOWN5blNUcWZqeVBmc2NqY2VoZUxZTmZNRXZVeWdjYVFiVVk0aGJl?=
 =?utf-8?B?RmsxRDZ0M0pnY3Y0NzlFL3VqUjQydGJZRzNiQlkzUW11RlArdGJOVDdhT2h5?=
 =?utf-8?B?QUVyU3BVZ2VSeUQreTU5NURRaWFXK0Jjb3BpWmlncjNOSGVUemp1aWNUYWtG?=
 =?utf-8?B?LzVpOG44NEpVZ0JGODNnTWNFVVZreTQ2OGthRVpCd0FXcHNzOTN4RVdESXQz?=
 =?utf-8?B?K3Y3aW9uQlE1ckFtTUtqdk4wZFRoQlkzNkhqK3RoVlF3QTh3c0k1VHNpR0Iz?=
 =?utf-8?B?QWpINHRUakxRS25MTmFjbHFpR2tXR2kwMVJPbWxvY2tFakdpbHdiQk5wTkNz?=
 =?utf-8?Q?rjTHKvVTrQI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2NuTEFheURCQXF3Z3U3L1hNTVpiL1U5NGtZZitoWWYySGxXZUpnOEVFMlYv?=
 =?utf-8?B?MFh4RE9IbWlKTURqME5uNVZHa2twZ2xKNjkxQ0UrZ01DNXdoOVEzbHhZYzJ2?=
 =?utf-8?B?ejZjdWp0VXdIcldGeDMyYzBQdVZ1Y2hLejJwd3JZRWRoYkNMN3RPcjV6bUc4?=
 =?utf-8?B?Vi90QkRPN1lzblpiNDFyM0R6b3d4enVkZlRONTNaL1lqeTQwcGFtaU4xRjhJ?=
 =?utf-8?B?eXR5NnBMcS9pVStZM0FwWUVlWFBtWDBteW9JZndJMGYwRTE0TTMreEpLeW0z?=
 =?utf-8?B?Rmg2NmVPdWxrd0xNdGlqdkZieDFJdmlwamthZDV0UkdDNkQvemFsUm1ETXpQ?=
 =?utf-8?B?YWd3dFRKTyt4bklvczNCVGMzVktTeElNS2M5d0xkSDB2SWRpQlhNczlMaUZR?=
 =?utf-8?B?UzVBZGZkaFhIWEJiSyt3QkZjOXo5WnYrYUR3T1Qyd2tOTHNRc25YRG84K3RX?=
 =?utf-8?B?T0hqWDIzdUZMR1VyZkJDcDYzQmowb3Fsd0tsRG9UTTFUTUVZd0UzZ2NJNGFp?=
 =?utf-8?B?RXYrbnRBYUFaMkN2YWswdEp3NmtRTDg5SngycHhxSzVBdS9SSkJ2RmY3Mjhx?=
 =?utf-8?B?NzMzcUJaN2RpbWhmWWFRSUZHUDI4TnZ2dHNuUjl0bTNpaWszZ2g0b0JWUjBD?=
 =?utf-8?B?aXNXQVZOMGJrVW1TMGR5a09rL1hldVF2NjZtS0t6ZFkvbHg4bVg1eTNwamtK?=
 =?utf-8?B?QVRYQ2xwSzEwbHp0L0F4bm14T3BnMnY1dklaUTNDT2MvMnMwdk0rancrd3d1?=
 =?utf-8?B?cWNLWXNaNE1lVittek1HRU9sWkIrdGxCc2hlaXRHOVBOM0xUcXJxQnBPWm4v?=
 =?utf-8?B?S1dDdjBtY3lMYkJXeGdWYXlnL3BtMVBHbEtLRDJMekN5czVncjNCRmUzUXdT?=
 =?utf-8?B?cldVSnBLQUVFeXdpOFdibFlKMVlKZ1VPUEdsWi9UOUFNQTM3MGpHdzNDQmd0?=
 =?utf-8?B?NnBKSXhxYmZmSEV1U29tbFpyTEozSGJnbWdydzFmK1NZOTZZeVBuOUhEYlEv?=
 =?utf-8?B?VUN4bmpvS3pPQjVUNUhpRVh5YWNHdGhWSGdSY0xBaEFXMkpGcHUrOFJGdXY5?=
 =?utf-8?B?VWRvR1dNZjRkdE1YUzIxQzd6akd5NXJ4ZlF4Wkx6dHNkdTA2UWRxakNObFYz?=
 =?utf-8?B?ZTJ4TndPMG5lMk1zN0JkTjlFM1pBMysvRHV0Z3liY2VXMDFuWEt4VTdnWkE4?=
 =?utf-8?B?UzNOREJuQ2tWUTQ1a05nZkluUEdrTHY2MUc1cDRUbXd0MmJia0c3cXkxbWND?=
 =?utf-8?B?VHdtOGdMUGEzYmZ0eW9ndlVvekIwandYVXVObEN2WDlsOUpqVnFKWmp6RmVD?=
 =?utf-8?B?SUc0a01idmFwY2xCNDYrRDRWMHNXVytFN3cwUWVNSGJEblhhcjNaZFAyTUN5?=
 =?utf-8?B?Q3hPcHhiaFJscFhQZ1ZXaS9HWlA2bnpTaEpVTzU1SDVFNzZjZXE1d3VGNHlC?=
 =?utf-8?B?c0hSV3Z2RFN0cC81UEsxV0RHSlBxNGEybFdZZy9sWVptUnFQNFFyUW1zYlpz?=
 =?utf-8?B?M3N1Q3dnWmllS0w5MlZndlVZeGZsa01PRGRNZHlUUUt2UzZSbXhndDd3Z3pK?=
 =?utf-8?B?MEZONlVaS3F2RHY4cHBUMnpFSW96a1g4dlRkSWlNL3lPK1NsMnN6ZE1MYnI4?=
 =?utf-8?B?ejlrcFIzVFdGbkg4cEsrYlJvVEpHTFNDSXh0MUlnR2MzUGFudWN5ZXRIS0hh?=
 =?utf-8?B?NmRDbzFiOGp4L1dVUEk2TlJCdjhXOEM3T3VSaHlncFV3UGhNQ1JnSnhWWkxk?=
 =?utf-8?B?QUZ4VHBsaERySnVlSy9DemEwdTRDbjE5Mi91ZGRzMG1mUTF4dmNvUi92dW1V?=
 =?utf-8?B?Z2tFNWlGSXJhUWRVemw5bzZmQ1lubTU3eVdEK0doakRzbUxYcVBRQitnNWNP?=
 =?utf-8?B?d1VrODlzeXRqa3drVUhxRGoxMHJ0Y2U1NTN4ZXNBRGpBZlRacmYrZ2lRa0Vo?=
 =?utf-8?B?R2YrTjhpWjNCYXZpTE81NXF6VE5Wd2puOS9ZUUZqRi81Q0NmU1BGWEZCaFBM?=
 =?utf-8?B?cTRTQ0ZoL0lZUFpuYklFS2U0b0p0TUxRdzFhV2IzSDdVVXUyaktGYzBWMXpD?=
 =?utf-8?B?WFRPMlNIem1OZkwvRmZWdk9LWmVYUXNTVTV5UG8yRkIyMmlCMmkrYWlsR0lE?=
 =?utf-8?B?cGk1WWt5R2JXbjQ2TEpGUFF3MDNCeENiR1BPMnVNS21oOTdJVUp1VDgzd3dS?=
 =?utf-8?Q?iE9g2JdR5/2NFmE9VazT8KQu4b3ky4PEEtFUEjkBS+Nu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b987d30-a074-4d46-9676-08ddf1b7be98
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 04:49:23.6891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdcxWec91nFVgWU54n9LNNp+qAeTjlPGtAZudeIA9kq4ctZJJCC6hB9DHz8pChT90cd7AB53HY7Sg4IT7nwJtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6791
X-Rspamd-Queue-Id: 358C340008
X-Stat-Signature: 6tqkhtmk65cfx5cseodx5zkkaquqomty
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757652567-457197
X-HE-Meta: U2FsdGVkX18lM0K/RX2c80oj+gyxESpv77SV6z3PynSAjFHEyM2yjjzfVx0a0/SF3kg9bDkayE3uHa9uXSQNo59Zraeve7KYxlvCsj1ONyO3n531txH5dF9WdZ+HfKOa8yiZTYYf27AwDjj96PgCiL0meDAVkKu2g+i6qP4HXVsjR1a6hyiYZ0Nbzg5Ju5LFYrtTw+RZ42Um57iEs9h/Nws9W+qnOdvknzc+2K7fSTPhfGS2Yj4aL+5AYvlMcf1AcbL0R+/KRKWeOgS/8dKbZLa8Xu58zUgv2/6VNICor0xHf2tmRfVnrqOPIbjs/iZVFhAB20rvN1JxJzHqGjWdc3Fpex89MPgCa8B9/UsBmsOil9oG7RAx1iD5J4ZnjcckiJhElL9DFCc9NmO2n4C2ou0LbVKAXP1Ov7H00B2Z4rx3EyCBk/zXLODGBt1Z9JKUu6FRWB3hJLpP6vreyaAAtHfnTznTu8W3IqCDWDPTNXiz5raOGDid3gJqHTfV61ARXiAi3NmA90DsBu9pGz1ee0r3aYaOO/fA4kjHip4P1fTZmxyeGhEXDY7kq+oP1HZJuV4iyQsIVsFSNxS79RuLmMLXiqojlyyWRcLYuFLgjH72KHDwZgC5xRDDZiWjKI2XS4GCI7qJrG4PYQClX7L8Rb5IOYQO4eL5/HrPQYxx+qA1vRgtDRTj6ax54ZcaBFtjjuQmNGP+OUhilrR1S1ww2qD4fbBmkD4NZ+Mk/HjmdX/bKIH7zlFhrvW+2rAGVoVLnU8IN8X+ZMyQXTcpjkBgFF/0ZlG7zqmVgE0vvklTuhoSOqVnN+ilECuVL1dbr0xpruMWYaqR02x4gY9t6UEbW9nz5G1jLZHfiId7v/o071umKVp9oDtlHr1UpKhWkg80caVIM3cJZdXiSQtIpAplGJw3QBFHG2B/OMPHNKqKwxHYVrVz/QeRqvyEXKUXn9BNWdhjnFLyL2o/IizRsG1
 7zYfpWtK
 fcd3TbLUgKZ4r8tjgn126AGKFdTKwTyqFE6o9fzh/ytLm7Eq3n8zJsdEctM4mwXQh4xaHli8PkLOkb0ulg3vWFxaH0qqQOxd5VnO00AJJxZZka1ApZ1lBvQPnU9Ux5XvxLrIkSsKqryVeF3drsAui1gbvjGJQq+4uogJSsC7RknZ570HzEPz8m1tBjAp51ZHE4maY0Ay3pKWMroTDCnw2Fss2Dd36s0uAyTQvNu13Usmol2Rhb2RqGEt7FBSAL/JZmA/GMtM6a8dB1R3Vdyf8JgYbWfJA6npUzxGvXMmIQ5I3y40dGGrBXBN4bwW0HAazV5FCRy8A1vJY8Nm9iz39cQCVkNSC34wWDY3Ahzh715bwn+1j6YiY9HoogmpnIM4HZ3JJ0d2B88su3auFGJqnL3I+uB5YQnCblD8jgsDHd2xHgR+G/lBfO7NEQ3ForSIE/jbOXfsXIacUDZBm+Gt/r3ZRUUFC60TG+i1h7fcgEBPF9anXfGEfkNQYrwIoVuhitsDx64eB38qbeLgqc7pIhQsRqmxqtGxxcERqLBHeRDtG9wYTxSXT6ssyhmVCTFtUyay733n6rRpb2HwtfzvKWO5ddWW0W8NJOFkBf53CMnpW5T62zy3tcrddsRnBtwrno4lmkHfWeAlaJgAVLNITgB0QRHERULICFjpNlxr1PqHL1kXafWBS9v98feCtW/fNfpeAJ5bTkZkvxUUP68kPJN7UWo63LiPDBIfpfwkm8bM0wbtpyXutyOp8ac7x28SnKzDzPgvGAOaYCm9adGkjhXfjf/6XIsWMOXll8MllnCpG4xeDVu2inVQAj/11tuTWg5fScE8r0zchASLrFKugJ9oPgNI10wMEWL0G4kf0FFUK7jSjKNGX7QF9McKTSOVkdHF5bJpCMCotiBRnaH76H//Vyenv7xEkcRik4GFz2Vpon0MljtA/GXd/7ivEQAG9If0+WUf6yDnk2wEIx2raRPUpqWpL
 yOodHnk0
 WrT32uK1lH7HPzno2iqLTMR/muwYX27bNPY+Pn1BzhYaQPKhKPOL2iYleBaCsRC6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/25 22:52, David Hildenbrand wrote:
> On 11.09.25 14:49, Balbir Singh wrote:
>> On 9/11/25 21:45, David Hildenbrand wrote:
>>> On 08.09.25 02:04, Balbir Singh wrote:
>>>> Add routines to support allocation of large order zone device folios
>>>> and helper functions for zone device folios, to check if a folio is
>>>> device private and helpers for setting zone device data.
>>>>
>>>> When large folios are used, the existing page_free() callback in
>>>> pgmap is called when the folio is freed, this is true for both
>>>> PAGE_SIZE and higher order pages.
>>>>
>>>> Zone device private large folios do not support deferred split and
>>>> scan like normal THP folios.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>> Cc: Gregory Price <gourry@gourry.net>
>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>
>>> You missed my comments of this patch in v3.
>>>
>>
>> Hi, David
>>
>> Looks I missed your comments, just checked those were largely about alignment and
>> integrating the code for DEVICE_COHERENT and DEVICE_PRIVATE cases into similar looking
>> bits for zone device folio free and code-alignment. I'll take a look and update as needed.
> 
> Yes, and the confusing folio->mapping = NULL that I cannot connect to THP support.
> 

I can remove that, let me reunify those bits, seems relatively straight forward

Balbir



