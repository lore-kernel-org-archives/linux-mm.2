Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99712C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4E28E0003; Fri,  1 Aug 2025 00:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395AD8E0001; Fri,  1 Aug 2025 00:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236608E0003; Fri,  1 Aug 2025 00:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 061D28E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:45:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD25A14100D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:45:04 +0000 (UTC)
X-FDA: 83726948928.09.99351BD
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by imf04.hostedemail.com (Postfix) with ESMTP id B0B9940007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:45:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=puEbXV5q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.94.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754023501; a=rsa-sha256;
	cv=pass;
	b=GcTiLq1R7jOHL6Uamff0DMGDqsm7hIm2EnCs3opUAjpHMUBGMkTZLXMaXYoCpPpGoRNdVX
	GLrLNIDJmS/dEEnmMtPkSgh+cLugLG0L8w4BWy4vKUXlOL1HA3sI0+3UzoHIcVc9h1fBmJ
	AijcfVdsoJBLQ8g61VRvM0ty0hFXy34=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=puEbXV5q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.94.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0CVUhpstJlR+tgNhF/PnIvbZMp5LhROL+w5noXxzeQ=;
	b=0/0Jb/wsStY38oZDEDl1HbiU2SpfuX/ZjiRFdhe39W+Yt//oZvlqY6RLyKSRhOohRUxhsm
	FCvIpXeo0qZ8VpkfhIY7zgBZIAxuklJn3COG1bwweihOKhdv3utxXnLcHe7qy4LPufTw1d
	aSPuli5N9Ud1Xn9Cig/sCqc/58IjGlg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlDvIK1D4sBLjWsS9IICfoZWdZEod4CEaCZy2zzPQgAOQyKsm0kDj4Xkd1iKUrkRs8zNJfv4XiWgo2vySQFeRvoJ/8UTUB7eGfm8O05HR4ZsOE5epsEX7mnLzwY83grexEuaWMc0afd+UfIch330VSctQLZ1TNgg5rymrPB02qj8/jMj2T/zwwym8WUOIESwiI9mfJd+EYJmeI8qPOaod6EwQ3xBFlohKSJdueTru6jrLjubb4Wo62ciAPScBdL4urJPUPW2TUmcvtndreyTp8jJfiox+p12z5etlhdnZdGzCv2i8RXut0T9J4aXx1OCAorhY92B0PEBKrarqMcyJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0CVUhpstJlR+tgNhF/PnIvbZMp5LhROL+w5noXxzeQ=;
 b=vPCoVXl6v5cb4Ubhd49/Ou4W+178eq/Fj+eXw/v2m1HNWZtMfjJt1AMB2fkwqDIAOkKFXi9fCMuBUhYl6cQvVe62m72eqMKYmH4+xrUWsJwyesJ8DfCWAM/v4aM/Chh/UVQJYbl22zFotjXSkpIrnpx64dH/O+oWPL/2IU2vqnxxEPACPlIIZA9WydTmrxJfJ9wdEdEpaqaJxguj42uHVl27n+hE3TrSoFolp3LUwsh61C5mEaSkYSWp4F6gwoA2aIlI0ovN6oy0OItilll+Xl3imLugImf75ZMBZs7cGl4lh2R1lu/hRl++EyeDoyYGA3g1Qrb/6P3LRR2HOhYOTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0CVUhpstJlR+tgNhF/PnIvbZMp5LhROL+w5noXxzeQ=;
 b=puEbXV5quD9j5G0Ud0YuKYEYmFPbhdaxrggT6kWNGW9KyQDL6mDBkltvnR2ZeHImgr1eTzaSVJNLbObNacGDeiam43DDHmLJQRimEuyh+gt64KDfeeKUI0idRz8tCZXt9MHOlFDY9Zgzy/IDHIJMfVI413tOLSZw8XJG2VQPeik1tNUbmQPSQ1oNrsIVzDSC/w+GnyZl/W6mNKB+JS2u2r/QlNTsa+HxvZpLh5GZKl8mX2ofu/Pxi8FEaluyePaTz4CovOjt+wgwVsqAn0E96Vp3AJD6W9VJ9DMhRo7MWmt1UTB5exrJaWFdzQ2FhZz+VzJON/NwMHuwHLhrPOQG/Q==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8825.namprd12.prod.outlook.com (2603:10b6:510:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 04:44:57 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 04:44:56 +0000
Message-ID: <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
Date: Fri, 1 Aug 2025 14:44:50 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
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
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::31) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8825:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf1f98d-abbe-41af-f65d-08ddd0b62a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzEzTER6VWt1djdvbHdUV1FuQytVdko5NjhaT2JOY1h0S1pEZEVvSWlvbXU5?=
 =?utf-8?B?dmp5Slk3d1diUGprVCtSaU01YTRUNTBJeDBLbkxzUzBXYkxHNmNQaGZKT1h4?=
 =?utf-8?B?Nm9yaTY0U2MrdTF2bnBvc3BETTFUYld3ZEFNSC9Fek9paDRVZitmcEQ3M2p5?=
 =?utf-8?B?NVVhWmZHeDdQQ1crdTlkbVpHOE5XUFlSampUbEhoSmlVUjcrbXBUMUhWNmpC?=
 =?utf-8?B?N3BiMEZOeUpwSjNMQmlPYnY5Q3hqcFVKd3htaTBYOEtyOGZqUFFtQUVNbjA4?=
 =?utf-8?B?V3RnUlRDTzFLVTZNUExBS2VNRkFpMGpGQ3NiSW45UUZKVmtsZlFNaUl5SW94?=
 =?utf-8?B?OE1hMzJUazFDSmZvL2dqWFBSdHliQWgxMzZMcUVQTDJMLytNMXh0STFLc3U0?=
 =?utf-8?B?a2xsVXllZ2NzcDBNcllWL2o2Y2s3c0ZyeHRwSER6OGRlcE5UQVhFVmJpUG5S?=
 =?utf-8?B?TFZLYzVhSDVWL056ejdTR3M2TGlLaEI1ZkxYSW5QN3Y2VHlXUlBmRjJsOFNU?=
 =?utf-8?B?UVpTYkYyc1BWU2xVaGpDY3A1b0wvc0k3bUpJYkIrb1hnS3o0bVRzRHdMbElr?=
 =?utf-8?B?SnBweHVZRkE3NjJFR2RKYWJ5TXpaUy9JS203eFJVcjM4eTB1N3N5QkcvanNi?=
 =?utf-8?B?ajlydm1GeXB1OUg4ZFhBUyszZGxRY2h4NUFrVVY0S1JYV2RGc0h6b01sQjBX?=
 =?utf-8?B?SURickxWclVQN2xaTytjRjBQMlp2Z0dwZUFtWmZ6bHUyOGh3M21ya0MxN0JM?=
 =?utf-8?B?SEJsdEFOWUl5MXMvRE5NMEl4Kzg2aGhsZ3VmTCthRjdHaHhYWFQ2cklMblJ2?=
 =?utf-8?B?SGtRNlpnUFJ3L3dHZzB1aHF2bTlPbU04Z2MvSGp0aDBWQ2RLL1JLSGdXclM5?=
 =?utf-8?B?amtJczVaNDFjc3YrTUt3V0FoSHNOV0FJMEtxeEdYRDdyZ0xrd2RVaEhqb2tL?=
 =?utf-8?B?b0hqb2FtVnkyL1dqS0RhNTBIZVUrUnZTVmt4aDlSTmxIV2VEQ3haTDFwemlG?=
 =?utf-8?B?M085RW52VDBiOUUvZ3pyUFFIbzZqUHVEMTBrbUpKN0tRazdQM3Ayd0xHT3g1?=
 =?utf-8?B?ZVRGbEl5K3RPZUZBbEZGK216b2c0ekFlVDQ5Smt4Q29ORjJZNkVCeGF5VnNO?=
 =?utf-8?B?UUtkYkJZTTlZRDdLSTVwTlY1RmplQVVsbDdoRDc4V3V3OTFCVlNXU1RLUGtp?=
 =?utf-8?B?a0gxS0tDVmhteDczSGtVdUlqUjlPcHZZcWVlMXRPcGNqVGZjZjNhTENaUkJO?=
 =?utf-8?B?aWNsQ0V6RXBHWFFUMWxoUFR6aEJzM0w1VmhpNU04Vlhyc1BFMHdHYVgydkxP?=
 =?utf-8?B?M1B3NXhjZFd3cGVjWUpPTEg3RWNjYS9hYzdlcWJnUGpOSUQzSmc2VWZoUm9v?=
 =?utf-8?B?TEdrUEpPU2dQeHNZQVN3M0xNb3AvNHZlRXlMSklXZ3NPbnFrZ05qOFluQXhG?=
 =?utf-8?B?L3ZaUjczOFdKZmpBeUUvVEdsbnQ4cWtSNEtsWnc1R1YyQndsN2hsSXgwZzBm?=
 =?utf-8?B?aXFqWkhzYkRhWUU2V01sU0xIU3BRdVh4NHhiMDl6cEZaK2lPckZ3bTNnTlJs?=
 =?utf-8?B?VXlqRStXcVJwQ1hDRk5WY0RqOUtSeWJzTnRNTWMwbi9ZenQ4ZXpla1BhSXZr?=
 =?utf-8?B?U2NadWJTbUxFeEUvdzlRd0pUaGE3RXE1UEZqYkFsMVdYazRVU2c5TVVsVTk1?=
 =?utf-8?B?K1pESXBjMWhHYzE5bDRNWkV0K3k4RDBBc1gzcm40ZmdlVmQ3WllOQUE3eTVn?=
 =?utf-8?B?K3duUzRVQ3JiNFZxL1JRMHhxMnNhQmRmUjRGeUw2SWUvRWdCNUl6d0JjMC84?=
 =?utf-8?B?akdNbksvSzVRelJvcTBpc2xsNllYQm9EandmRE5VZGp6cW92WGNkaERjdXVx?=
 =?utf-8?B?SnowbzRFb051TXBVb09kaFhkZHM3V2NkNzYwSStiY1ZIdDdnakVpRlRVSGND?=
 =?utf-8?Q?nv5s3zW2hUU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1ZsdnU5T0hwOXRFTmNJdU8wNC90NDd1VjZBNXVHR3gva2RFQzkxZGxMUnho?=
 =?utf-8?B?MHo4bnlMNHcrMElKTjllTGN1eWdqTEVXNW50ek1wampLZUVjNE5hbU9QdTQw?=
 =?utf-8?B?SG50dGttZ3hSNllkVnVHRzFNWWU4bjc0aDJ1RXB1b0xZUFI2TTZwaEtGVzY4?=
 =?utf-8?B?SXJGdzFPVjcveDBzYVF0Y2ZOQ0hHRmpXVy9PUWZJSWRROHcwN3hhdXM4S0JX?=
 =?utf-8?B?TmlaYXNmYXdrQUcxTEU0bU9lNXRuL04wcWs4dkl6R25MM292dGJUT2Z0R28w?=
 =?utf-8?B?ZGdyYzRST2ltREZyenpEUlpmTURZZTNsWXRORGhMY0tlcDg3dFkzMGpwblJF?=
 =?utf-8?B?L2tCZzdNN3BiczF6Q3UzYlNWOFhKUFdSZk4vTUpHaHR4TUhwQXo2Qk1KbThN?=
 =?utf-8?B?N1BpbVJGekVkMVRwZlU2UXlVTWxsQ245QytYVkhMRWhoaEd3cGxkbjN2bjhz?=
 =?utf-8?B?OGVvL25EZXRTL2pEU3Q0VGF3T29BR3pLWXFtWlQyVUN2SFQ4eitJbVN2MmFx?=
 =?utf-8?B?QzN6VUlwbmNDTUdzTHBJckVkL2FIU0RqbUVVc05rZGc0N0ZOOVZJZHFyV01R?=
 =?utf-8?B?M3didGw4RDlUM2JzdmUzOHBiQmwyMXdaSGc3dVBIMGQ2eitmRTFmU3RXQk5n?=
 =?utf-8?B?ZndmL1dOODByZDYwY1hlUXV1TXk3YzFzN3JibmtQaGFORzJ4cTFYMzliaFN4?=
 =?utf-8?B?VEc0Nk9rRkd1allGa0ZHK3QzSS85SWVSVjhuNjRGR1A5RDdOcHdJb2FtTzh3?=
 =?utf-8?B?UWpDWktmdlJRdFdKRTVhRWVwRkgxeE0zVVQ4Z0ZCTU1zRW9rVW83Zk41RFpN?=
 =?utf-8?B?UWh0TUlNSUgvZCs4R3dYOVgySldjZXhza21iM3ZQdjUyRU9lMTlpcVBmSVFX?=
 =?utf-8?B?TmFZNURhSzByazV6WnR1UGNscThLbEtpMERuZWdvSy9CdTdIM014TkE1bXFv?=
 =?utf-8?B?TkdrMHJyMkU4REFxb0RzVTBTenVBdmt2T05NSGlyNHhHWU9mK3BOZUdZUzlG?=
 =?utf-8?B?V2dXN0ZGWTU3VUhuR25BUUpCeHpUaXoyS2FOblhQRzFUbHA4RzlaR0RGbUUw?=
 =?utf-8?B?QkVic0UwR2R0MkhSaDVqRnBBaStrdUpYNHF3VkxRTWlMMW4rYXJnT3FFcWVi?=
 =?utf-8?B?NXM3RTd5WldwTWdzdG5mYS9pL3Q5WFFuWWpHczE0QXBwMXV1MlJkVXNXRjJF?=
 =?utf-8?B?a2pTQytWSXdmQkM4Y3BUazhGbjM4cEZaV05BMy9EcUt5Mmt2UXhJdVpqUTJN?=
 =?utf-8?B?L05LQzJ1OEovdTlsaTIra0hlcGkxUWtLak51NHhac1JCZ0Y2ZWQyckZ5WVRP?=
 =?utf-8?B?NGhDOU9uL05GTWxPK3pUclpwN2dycGVUMUlXNXNqUnhRcVFTM0xKQjU0b0o3?=
 =?utf-8?B?eDFFUEJINUlydDV2cVduejdvZHNFTG1WS0lpcE10a3RDOFRTeER5RTh2WmZx?=
 =?utf-8?B?T3hHc2E5SGNxUlF6Wjk1QnRVUHcwekpaOWdnd0g0VkFWOFl6RkhHcE1WY2Q4?=
 =?utf-8?B?allyYllUYS9ZL1BabWxzSnRKc0paaWNGWFg2RDVOV1g2RHhMZWVmNHUybnpP?=
 =?utf-8?B?MjVBU0RSWnFvc00vWEdsUW5wZGNrSjQxYXFTdWFhLzZXZEt0UGdFckd0enVX?=
 =?utf-8?B?dnhVYkZvZEl1QzhLSEoweFJlVXM0WHlYUTc3bHlHSHZkbmp0ZjUrWUc0eHpz?=
 =?utf-8?B?MEFiRnUwVlpDQjFvQWNFak9rUHZZMWZURzdyZFdhdDJTWVlRcHpvelA1ZmFZ?=
 =?utf-8?B?OXFyTmJlM2NJN2srbWc2eFRLaWlING16a3RaTFlMUHlSTXpYYXZUeDREekJD?=
 =?utf-8?B?RWNaRVFCay9HQmJUOUZCZjFvVU41S1c5b21aOHB4Y0FyU1RnTWZGS0E0YnUx?=
 =?utf-8?B?V2ZGdU9UMHhjZHU3ZHhSV1RKN0JCeE0rakhZdnRLTlJzbFRmSEVGVWZzcmw5?=
 =?utf-8?B?L241SzFYWSs1YkdBSy9QcDJMbTZHT0ZTNnJyTXNJbnQ0K1VPang4Y2xhUEpI?=
 =?utf-8?B?N2RyaHEyeCtUdmpkSXhwdkVmMis3ZEJONjkwMTNvMGdPQmhjQ0l1UHJ1NnlT?=
 =?utf-8?B?ZEFzbHpqbDdnNGwxRlRKc2JCdXdaUVI2eVNxZUZ2bmY2V0dNTXFIMXVMTjlH?=
 =?utf-8?Q?zvB+dqVbfVjlNGPW9PLd4a4PH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf1f98d-abbe-41af-f65d-08ddd0b62a07
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 04:44:56.5854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /g1K39rjLPy7ta9zyDZuxFaiqJONRv0vC3N9dev16/he+Dq44BUaP/mPqj1Pi5CtKyUIOnesK+ggB72wK74JcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8825
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0B9940007
X-Stat-Signature: 1ykt3mp7qmkhpgatimwgg4a9kuked3jy
X-Rspam-User: 
X-HE-Tag: 1754023501-936385
X-HE-Meta: U2FsdGVkX1/VNq6B+DZKbedz/bR9tr5AwlTWnFo97GZdBkIK02lpzFFgtTpqRpz9ZhsJPUZDUiRHQEwE49SNHOK2Bn1M1H80Jq1skJMQeajJxAaVpJmShg+aYKkhIibNT8/0tSUEjnC/1EaAVlleaOXpc79cHdjL2vWLZeWhh+sizzRXgYz+/NiN/ZdOXqdvJb1DhdOSnFi9gpxfEmM9aQaRN1x3oAgt57bys6E5X7fk+8+DX/vZaJil+0RdPgD2vmhtzO6KgEgWOX+Bk0IRzwPLMcOVCR7OkjIh0NxZ/sTrbt6KzZwcZuGV47KuNXt75q4T1qeEMW6k7BbSBrC6SqV97KwPqG6n8gU3ns7f1v02AupdqoTF7Qz7NH0uW/xvVei+xg8XWTVaY9Nx/Eob9y/xqfZhqc8F+tjUTxfsFe9GBVg08avUjmRnYJK7LC6Bdf/VZWsCG/rAsXakE0jJa89+EfnvDkdSUIP9vTTjUIG9xrOXxq1gD6XzX7jvJdvJG/8pGFGjkZ04/8vYMC2vdQVCZcIYWk5pWhmOxrYXfXA9Dn36LVcyzbD9fEq/041b5dbsbdvB4Xldkkj2CapxbPzWhMY0Yhm0wUPMHnL/R3qel5x99yCZVSQsLFFpCO21MB86Zvab6XkNVWI3dsF5bzaXs2DqL4ovhQ42syUOoem7k5ePnspVF6PDdOhgavgFRasSesMvh8wlznJSzz+dhVdGp8LY/l0aJLr4GUWTzhQxS1eyrzB6JF7/kombeNFmv9qCki7D/dLAGkY869L9VsQ8t0flHL/engP3g6twk14IUwv0p7gYd1rqiOdrxjBtrKRslDkRL4jQImWLJCOOU6/SbGIo7P4DLez5a2WoFGU1iDxRd7iu3OZYnVRHcQIr+zxqU9bfIzyqPxntDDTdokM+er9XeoIipJRZybjWCZZgpQCVUUqp7gDkKaAgPdBdS0rx6U3NPNLmk3sI2fL
 9JSaduKf
 R1dhVo7oLOoja5/bFzmEjWUT1vM9R4MS/Slh0r0kESQSAXZ9th4GzYhxSM6Nfjve5EyBTUiI6GJSSLD7tMTpm6DvE2CEAvJ5ieQXqkqMWpbOGfC8Y1jZu/FFl9inNLoAiz3FaJSAjy9hSK8qOnFeruJMDujXvIFpKtgC1MDg8kHOpW8JkxqieijHP5/qp8ArEPnbc5njupa2QPLggvSmzvqITiEVYdD9qrE4C7efBC1SwYmB26QAafJ6xJi5AePO1CSH9+g2068y/zKdlKIMewlEV9cFT/pu39zxKgYxeSgNa/qPu0s/h2pYJz055IaUe0iI0nOqcthCfAmSzP+1QOjWjQumY7vRKo9E3IrKFWv8zmERVbGB9XAZ13FTZbnSXL8wgBBPVXoszs5c903VhD0x/0E1RPHTelCkjlJz7Bw76rRTLILVo6RcvxSP11ZDHeQYiTbFb+auGz2g/9LbsZo69CnQBEI5eUOYUBVDD1/AtjrRwNjdx5w0FGmn92FLG3S6CC352fQz3Fkbn8ME7OrnG1j9HYCw0AZJtK0G30OZkoA5B7T6+6tU7uAPNZ7jcG8d0ikIl4fCg8iEwqHb+mIC5PJYiZlU90s34M2GvVBn20ZnRWSDBfAWTsXFhnkYqnq332QVB9UScMO2uC6IMS+P8Uf0bRvfayCo4JaSnHIJwqmZcMrr2qNoBoyROLClEnETfXSCcBrhbCzvEvv9pOM7W+fW0FCQGHiqo1elgn8CeW7mUgzSBFd7o+nF/cV6IY2f45gR4DxrE4ULtJbnnAOOnQ8zZmX5sDVg3vsX8+SlcdtE7hGwmlS6R5bGh+fatdAYqntkd+EHTXsb2Idv1LnnpKVtNoJvBnz7xQAUsGYELoR1sQOEhU6VwrLi/3C34eaVpMR77rzcKKh3zl22GNFtXYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 11:16, Mika Penttilä wrote:
> Hi,
> 
> On 8/1/25 03:49, Balbir Singh wrote:
> 
>> On 7/31/25 21:26, Zi Yan wrote:
>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>
>>>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>>>
>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>>>
>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>>>
>>>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>>>
>>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>>>> at CPU side.
>>>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>>>> CPU unmapped and device mapped.
>>>>>>
>>>>>> Here are my questions on device private folios:
>>>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>>>     perspective? Can it be stored in a device private specific data structure?
>>>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>>>> common code more messy if not done that way but sure possible.
>>>>> And not consuming pfns (address space) at all would have benefits.
>>>>>
>>>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>>>     the device driver manipulate it assuming core-mm just skips device private
>>>>>>     folios (barring the CPU access fault handling)?
>>>>>>
>>>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>
>>>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>>>> someone could change while in device, it's just pfn.
>>>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>>>
>>>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>>>
>>>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>>>
>>>>
>>>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
>>> Thanks for the clarification.
>>>
>>> So folio_mapcount() for device private folios should be treated the same
>>> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
>>> Then I wonder if the device private large folio split should go through
>>> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
>>> remap. Otherwise, how can we prevent rmap changes during the split?
>>>
>> That is true in general, the special cases I mentioned are:
>>
>> 1. split during migration (where we the sizes on source/destination do not
>>    match) and so we need to split in the middle of migration. The entries
>>    there are already unmapped and hence the special handling
>> 2. Partial unmap case, where we need to split in the context of the unmap
>>    due to the isses mentioned in the patch. I expanded the folio split code
>>    for device private can be expanded into its own helper, which does not
>>    need to do the xas/mapped/lru folio handling. During partial unmap the
>>    original folio does get replaced by new anon rmap ptes (split_huge_pmd_locked)
>>
>> For (2), I spent some time examining the implications of not unmapping the
>> folios prior to split and in the partial unmap path, once we split the PMD
>> the folios diverge. I did not run into any particular race either with the
>> tests.
> 
> 1) is totally fine. This was in v1 and lead to Zi's split_unmapped_folio()
> 
> 2) is a problem because folio is mapped. split_huge_pmd() can be reached also from other than unmap path.
> It is vulnerable to races by rmap. And for instance this does not look right without checking:
> 
>    folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
> 

I can add checks to make sure that the call does succeed. 

> You mention 2) is needed because of some later problems in fault path after pmd split. Would it be
> possible to split the folio at fault time then?

So after the partial unmap, the folio ends up in a little strange situation, the folio is large,
but not mapped (since large_mapcount can be 0, after all the folio_rmap_remove_ptes). Calling folio_split()
on partially unmapped fails because folio_get_anon_vma() fails due to the folio_mapped() failures
related to folio_large_mapcount. There is also additional complexity with ref counts and mapping.


> Also, didn't quite follow what kind of lock recursion did you encounter doing proper split_folio()
> instead?
> 
> 

Splitting during partial unmap causes recursive locking issues with anon_vma when invoked from
split_huge_pmd_locked() path. Deferred splits do not work for device private pages, due to the
migration requirements for fault handling.

Balbir Singh


