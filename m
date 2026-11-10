Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C71D60A261E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LfA38yFt
Received: by kanga.kvack.org (Postfix)
	id 2F33A6B00EF; Mon,  9 Nov 2026 21:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3956B05B0; Mon,  9 Nov 2026 21:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146FB6B05B2; Mon,  9 Nov 2026 21:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C472E6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:53:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 505561A0882
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:53:09 +0000 (UTC)
X-FDA: 85417687698.21.CC376CE
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5EC6C140002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:53:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LfA38yFt;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794279186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZAdhiCpZpKsu9HyEjwrULwfk2OLKc74szWYYCdFA7Q=;
	b=ATSnb+HX+gULlbu/XQwC3cjYQhPcC2VKJ4T5n3EMLAIYAFfXwqTlmKl/fkuQ5flLSpsMII
	4NNZ4L19HoXTLFUyodin37GfmEFVa6c52oiczwGuEnc6+1hBmdioc+4vzHHHvwNO/yhGeT
	6zt4r/r2SfodYDaLngps5nYgSP8R93I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794279186;
	b=QcIgTqBnWfvWDhINOTpvO5LJaPOg/JEYYOp0wn7hSNLvwc5yP0bJ6gXjO4UNzR/vAT46M8
	L2oC1UDYGHfYLuSky4xzMN0f/Fz1+HytJFubO/MEJfN6BvUHmkopFSs9dm5W/cc6CS6JkO
	ztZyBRpPBsRrkx6veghMdPmmTqjFR78=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LfA38yFt;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fu5Uig5kqbV2nt08K0YFAP+s2Bu4fbwj2Tb20rQvhuhdWp0koJfODSvbqgE5U6S8c2eQU07PLWRbR7U4ibJRkGv49DMvbAAsbGO+TM+GmwcAgwUFAqM6wBCDT0riOyrHmZKFse+nU78qYc5n+REViLXKaz8DBXqpkq07atgdVSi6qxaLpnw9k0jYKbLeyQdI/qPSaNmt0OAB6zL0vEI/DplEEGTqrJSYs6WF9yymDxmhQ1ugJ4XBHBzM+GzQdw1qon3SSJL3u88IHT1Fq0GB6BJsBA9tGJ3JrYVHI/0VDtUf5YSSbqLPZh2/WFvCpCjEE4qMlbhHEnKtN7KD0yBwsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZAdhiCpZpKsu9HyEjwrULwfk2OLKc74szWYYCdFA7Q=;
 b=f9I0UHPoM58HW0MOzcRIjpKfZLjXKS8tsXWAl1tZWaIjEycYzeu2Dgisntd8x5KBVeGVjM2kciqR7qLAEhiIUgrJ+8kZYqDLJVuTAeF5/AdRlxT5xaDPBY+IAzpuN5s4ZnXKwYqLLbhFna9WhBEajlJ4LpLsw7LEEBOYUkGNo9A+Y9SsaQw8yLHRgrhH0okAM2fv3Bdyds0ELmm5a2/xvsOVVPssGcp9LZsdvY0aV86eZrvJ8E9fB4oDbSUlrg4bwuhmLl+Oblu003xorcEZG65XUtu9LnJ8AEmYK78GCKKAApHwm5NADyC/owejVlCqAGR74b8RqENZQTdTaLbH4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZAdhiCpZpKsu9HyEjwrULwfk2OLKc74szWYYCdFA7Q=;
 b=LfA38yFtq/x0nyYUbfT10gZrMhQZtMf3Wga60WE4rlaCbdxzuwiC2APUBuCZOIIiQvmJ4zmoJqcZGpj8Tgm+TqeKeiB5MVmUnoIOaRSCi+vIj8jtvvwm7N0A8gYmaRy77H/A3FA9b3cn2h3Rv5A0bpi44rmzxQdvhpOugdoijzrbe3JY5h2o4grZ8Atb8d4huWiGbSeIpzgZrs5k5NjPeAyT6OFCjnjISeBEbpdDK200r61stvxTr5sdNatSwGM4hMwq1PStvBKde4wBoxu6tfm0Q9NJYTRWNzCGKe2ygg4zvxiUbNugKkWfwSm32Y2QLcZjJpToojb14gCPjhqQBw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SACPR12MB439974.namprd12.prod.outlook.com (2603:10b6:806:540::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 02:53:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 02:53:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 21:52:58 -0500
Message-Id: <DMR6VVEKW3XN.23D8JAIT65YIU@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm: limit pagecache folio refcount when mapping
 pages
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <fuse-devel@lists.linux.dev>,
 <linux-arch@vger.kernel.org>, <iommu@lists.linux.dev>, "Chris Mason"
 <mason@kernel.org>, <stable@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Song Liu" <songliubraving@fb.com>, "Rik van Riel"
 <riel@surriel.com>, "Miklos Szeredi" <miklos@szeredi.hu>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Hugh
 Dickins" <hughd@google.com>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar
 K.V" <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Arnd Bergmann" <arnd@arndb.de>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Kevin Tian" <kevin.tian@intel.com>, "Joerg
 Roedel (AMD)" <joro@8bytes.org>, "Robin Murphy" <robin.murphy@arm.com>,
 "Steve Sistare" <steven.sistare@oracle.com>, "John Hubbard"
 <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Josef Bacik" <josef@toxicpanda.com>
X-Mailer: aerc 0.22.0
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-1-c38f6809b106@kernel.org>
In-Reply-To: <20261107-refcount_overflow_stable-v2-1-c38f6809b106@kernel.org>
X-ClientProxiedBy: YQBP288CA0045.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SACPR12MB439974:EE_
X-MS-Office365-Filtering-Correlation-Id: e865cef2-296b-4478-9cec-08df3ed5bc30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|18002099003|22082099003|6133799003|3023799007|921020|4143699003|11063799006|56012099006|10067099003|261102123227099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261026140227099003|261009223027099003|261102130727099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	UDDX70LXrzHA1+rHkGFUYD/esW77XFEgIrrQRAT+Vk8DSD+yHOaye0eyC/OlPflNzMZ/6qENqEA0ym2VyeeTFQncRAuBI/io9ldhBcN75QHrRpqjiLh0r2ywEf5a+DNm2z/ONdOCdEEu9a+tA+PgJ+1Q8DalclOqZ591qjSfO9UmeB3Zxlc4LzvHhhypvDZovh4nXe9CebjJc2aJrjbkABBJvBor0D0H1B5d6KJzl4yH03CeWIZWywAefY49wN6rzosmn8ywkILKNLRD55PBur4n/FlADA020pU5iMpuOBR9fPM5h4G3cSXapsHypwz6shuCqP0dyl28mtLQ9nvzJcp4My5lKqhJb30RaCCukVHCQgGxR8yJkJIIcq1K7/TA8EdnTUrqecdsEpbuIEffMERVJgN9RtcUIzPsAdYTVSw8DJCzUEj7pnt8lOD1uE90GcBqZNICepe7RndIrN9dT55jSe0twy3YkKAW7jJv3QxqjKyqy1X7vY3VHTbCxDW2I+MxYplpuGeOuunMY6UvtuByhdPNHVd+eHdwE3qrrL7SVeHpTBj4xhY94s6bO2gkzq+mFMFoc788LiJOA64KRABUkmbpVP1LnraO/Vz/NxxP+DfueFF4VTpofD9ub0USmesNGCrD7bTTbeiNBTKtzMaz4KgV1omdQEpP82I1Pzn83qFcJQGxpStkJkyIlMxJiwWcHSVk+GBJhcSpCjywWg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(6133799003)(3023799007)(921020)(4143699003)(11063799006)(56012099006)(10067099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003)(261102130727099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHlzL1Z5RG10dU1id0l2eUlLUEViVjdvSG0rN05NM3FNRGpTZkhmQWNNUkxh?=
 =?utf-8?B?RjFoeHRNemlrdlVPYmZsTGhaUG1UQlg1N3N0Q0p4b3JXMW5OUEo0ZllVWERy?=
 =?utf-8?B?S0h2MWhOS3ZUakJjM3IvM3NGalVpNGtKc3FYcEhTL2FNUGtMTDBHc1hIWGh5?=
 =?utf-8?B?VTRSYWt1c0tWMWt0b2tVRi80VTVRaWpqS21ZYVpJZnFIeDArcWk5NFlvQ1ll?=
 =?utf-8?B?SkhPSHhqVHBSTkJNYWxCUlVDWko0SjFaSDZFTUVyZHVQNjZ1Nm1NRFJzejlT?=
 =?utf-8?B?bms3cC8rK2I2ZkMxVlZvbndtUjR6b0JlVkY3VSttN2JiNklpTldXZkxwdGNw?=
 =?utf-8?B?ZlpCSmJaOFZhcXBScVc4NmYzcWw4RFFEc3FYdWkyVFBGVVRUWk5lMjBZZkd0?=
 =?utf-8?B?WjZxVUZ5VXQ3T0h2Nmc2ZnhQTGw0ZHV3Yi9hcld4OS82blF1azJkMDFPVmxj?=
 =?utf-8?B?Y1hCWm1zcnNCZERlcVFyNG1Ic0FabW1QR29WczQ3WklEZWdkQU9GWmJTMFJT?=
 =?utf-8?B?WEpYYldTT3dDUUdxQllhZ0RmMnBmRzJ4aWFVNWl0QWc4Tkg0TjloSkdUM2Fk?=
 =?utf-8?B?cTVBV2hNU1lYR1hiL293TEFBT2pWekZKNFgwQS9zVEwwRlZaeGVDYWVjSWx5?=
 =?utf-8?B?UGlFamVHQ3FBTE8rbWlILzhpeDBQUlB0SWlId1hQdi9UV0I3UFF3SmNMNS94?=
 =?utf-8?B?dm9CVWdaVWFBcjB6MHBmc0dtV1NSNlpiS0RDRmk5bnBEVjNMQXcyclBpT3pt?=
 =?utf-8?B?TlVxbmJQclNlZUtoVCs5N3lpM3hWU29mMzRLU2ZSTUxIQU9SYTIyaVF3ekcw?=
 =?utf-8?B?THFkUlB6M0dHUzlUMS9hVUtZWHhZM3FyeU8rcDZ6cGFmTGRNeVFrZ0xQaXMw?=
 =?utf-8?B?VFIyVisxU3plcmhFQXkvSFpVd1NDaldBUGgya00yekhZT1dwb21lTGV0NS9q?=
 =?utf-8?B?Vmo3WDVHdU1BSjZUNjAxSG9hekI4NTZzZTJldURPOEg4QmRqdERSSllQeERv?=
 =?utf-8?B?SWhjRjVVeTBJZ0FSZWFBNlVWdkpXeG1iWU5NaDRPODJDTFJSK3kySWdHU0pa?=
 =?utf-8?B?NG5jR3BTZkFoeElZNjJ0WHptMG54VDYwKy8zVHpGVUdmUmFwWHowL2M3aWMz?=
 =?utf-8?B?UlBhWWJFSThsV0x6ZXBOVTBodGRnWUhFRVU2bGRmeUh6RGkyTWlsMXVjR0s1?=
 =?utf-8?B?bHlTME82ZkN2UzFMeU5WSEJCQnQwbWFrVkVZeGRSRnpKVzN5eXlBcEVQcHBE?=
 =?utf-8?B?aUpVdnZKTmpQWDA4aDRKbzlpcVBQSkJTTG1TNU1UMURYbVNQQlhFcTM3dU9O?=
 =?utf-8?B?S0l1Z2hDR3FUNUZFOXNxeUFjbnhxRi9lNUZyL1ZlSHN1emMwN2I5NjQxbHc2?=
 =?utf-8?B?VjRCN1k4blc0MmNhYTBMNzNKMnBDZGVmNHZnVFZRMTNYYVZObVgzSzFYU3hD?=
 =?utf-8?B?bkpNbXdwdlVjZTR3amxuT2EvckF0RzhkSDlNd0hSSXlrZlo2LzlndWN0TDdv?=
 =?utf-8?B?RmdRZEdlWkFSdEtQM1p6dTgvNkhWVXljODYwaDlIazlTemYxclpTMXZCV2RM?=
 =?utf-8?B?LzZ1RGdPbjM3Y2lOTXNNUG5tM3JrTVNCb3huOGw4VjM3ODFjamY2c2FybkhS?=
 =?utf-8?B?bHJ5aTNabXc5U2JtSXpnTVZIZW9DY3BLWDBqdTFCdGsxRFJJTlY0ZHBuNExq?=
 =?utf-8?B?SHhNR1lhQjhkZnorM2wzU0VnTFhWc2tjMzNzdENvc1JoRWJlbkJzSG50T1Y4?=
 =?utf-8?B?cmI2YkE0SUFIZllHTHJHVGhPUkIrVklzRTNsUGZINTd0cFZHVmRKS1lhMEFS?=
 =?utf-8?B?SzRiTklkbkhTNVhhYkNXTVczTFV1cEhhcElQbmtKRW1BcXZGV2dMUjBNZWI0?=
 =?utf-8?B?YVFVU1BpeHcyNDRNRVBrUjJCc2VjTkRNenZIdkkvUFQzckxKM1FCMHdzMjNW?=
 =?utf-8?B?MVNpbFhsR0FaMmM1WnRnK1ZXRHBjY2dmVFpnUEdaTGxQemtpbVhnMHcrRmMr?=
 =?utf-8?B?bWk5YUZpSW5nd2hRUXF2YzQzUWk5N1FSL052KzdidEpvNUFuOXdlT3dsV3BH?=
 =?utf-8?B?TVkwK00wZ1JqMFRzMTB0R3FOb1pJRmJ6Vm5QVmcza3dydGJuVGhyMFNMQnR2?=
 =?utf-8?B?dEZsaGYzeS9BVkZhVGtpRzk3ZW14MWVJZWdQenZ5aHRxMStuRkVOdDV1NUh6?=
 =?utf-8?B?RFdUSTdDa0g5TFlyT05rVUtxUGpSLzlveElBcWxwMmZqQXZmSTZodHZwSk5l?=
 =?utf-8?B?b2ltV2w1QXcwclp6V2h6T0tGNU9GbVlsY1NxWXJZQzhnOUNhbTBIWDZtb3dW?=
 =?utf-8?Q?9ktksxT72WfLn8GXGm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e865cef2-296b-4478-9cec-08df3ed5bc30
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 02:53:01.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6khoUyqXNsaifahNTZy+BhFA2PIIOVmUSLhCQvA7CqdLrFkSgN7xood9JmRaW6M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB439974
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EC6C140002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dkkhgcsf3gqrxod4buoxs9j5hgr9hz34
X-Rspam-User: 
X-HE-Tag: 1794279186-219277
X-HE-Meta: U2FsdGVkX18sQAIwrBaw1QsdfVCoMSlXIraOvomYBSz/gTkqL+KFTOyBlpFw0Gn4pgedUfjrR7Ngh9CxfwAk6Pj+oVgr79OsXPb19IgnAtfgHhbfs30fF4Tzq7xx6Pjr0VxnvO75Up3gk0y8ml3I22vbMB7akW747zpQ627eZIm9kcS3AdZ+EbsC60ElvuiJHI6NzeCsQZRkD3nen0H2VvVhTA21AX2L8Xh3Uo4/RXmk4X7wrO4gDfaY/xmPcQhhlWoXmqY+8OxXa2TBWmNVGknz/04AKkwpkq/zbgbXDeUmm1M4TnQQpin2ITKlVFdVI1MxeYYAgxph1HmBTs+dvKa1jOvlRptfREV4ohY0bxvBYZ74wJ7HVyyD3IlPJm/gjexXm1qGzwdqRZ51QIK6MTilFPtd/VZDTuTWjmdrYgNduyOdFilFecXEkGopbl/Na4OKLO66K9ntEtZtWKRSMc5Yb5gXLfiiKHygbf4nPgYLImiW8eFL6lhVc4aoGkxrHf+XgWzMvkHKprW6ORAYLU+2ypQpmOP34QqP+I2lEBhzuSNxT99xwcCQZpCHgO/YMnqpYFOKgScVD5oDMTkQnFpLCuMdRhdC1GlrmX/AP7NxDUY9Cc132uLU6F6FwFMvWlpzY1COQpi8TCzWclY6LraqGQO+J/W8AtQ7zEK70zaG/zTN0rmXN+iLq/kkaTYq5eeDs8Yd+RU+y5YS+WzFsRovlBz/lAoVRUuu4Jw0WcNYwv3kJTnfwO/LBwPSiKfc/4EcY84UPPRCLAM/WCCb/HSvB4KZXklQERYB1pu437gAQrLOtLktagQGcMnQx65R+xySzPhMjFPDV72ys8nc5jr4Tqq8tI6L7m96jK8UBYzwtdP9N3fryNOwHw6m3mSRf8HUqoZK5C9d+0MlzU4KmDyZditzhd4yBi9dM5TJR0AF4UquUbtP7+uNxo2moZHpz2N12KbX5tkfbGf5u9R
 X+vDpgFC
 WpYaLqoyB4PNNKgT2TesutbU1lOu2CXcQoJXbnhZpJXDGKHzCKxBut7lByP+m/jS27BIwHvrY1qQsF7AzGJrHw0NpwPBPQ4sE57OKArb0Pty1JF0UNOnWzj9tWYCtgPRh6mEPM78+3zP37PS0hcoTp+lk4/537mgw14aiLyGwl/WHyn4huJTU2RWhDaMv87JBbBbs8WoXoCgnL21Lem5C5FZKIm2YiAfwpcdY5VuUSWWt2fZ1qe1N1BBE7CObH4ZEP3npi6HgRVse7vqGmmc2QOI/OixsLHIsoLJmWljG0U9syqhELlMdHYk8biRNzvHqceSdJ8+DJ5n8d1vx0XbNFCp845VM9tLdxBtwvB+3kQpPfrJjrHiAKtFlMm/T3dsJHCINdllkS+CR7Hhr7ho4AboXiKXqzzlgy4xwYnloVfjalDk+kczwljKeyfMxiBAasbSnxbiDKfGB80B6JtpBQeZSt+T5hKN6GfnDwjWHt207TTg5HbQutjgN5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Nov 7, 2026 at 5:23 PM EST, David Hildenbrand (Arm) wrote:
> With large file folios, overflowing the folio mapcount and refcount
> became possible. For anon folios it is currently not really an issue:
> each large anon folio can only be mapped once into a process; on 4k
> kernels it would be more processes than usually allowed on a system, and
> on 16k or 64k kernels the processes alone would consume hundreds of GiB.
> Something to be sorted out at some point, but it's not as urgent.
>
> Being able to overflow the refcount is not really big news, but it's abou=
t
> time that we do something about it because some modern technology might
> find ways to abuse it :)
>
> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
> refcounting"), however, file thp support was added later.
>
> File folios can be mapped multiple times into the same process, allowing
> for processes to hold many references to the same folio.
>
> As a short-term solution, let's introduce two folio refcount limits:
> one for ordinary consumers and one for admins. Leave some headroom
> before the refcount goes negative, which we really don't want (having
> the mapcount go negative is also not expected).
>
> Start reporting SIGBUS if we run into limits. When restoring mappings
> from migration entries, instead zap the pte/pmd entry. We allow for
> slightly exceeding the limit to keep things simpler.
>
> During fork(), prefer not copying page table entries over failing fork.
> Export __folio_ref_count_over_limit() right away as that will be needed
> from fuse code next. Use has_capability_noaudit(current, CAP_SYS_RESOURCE=
),
> so filesystem credential overrides do not affect access to the admin
> reserve, and to not generate auditing messages simply because we access
> optional reserves.
>
> This is far from ideal, but better than all easy alternatives we can
> backport comfortably. For now it fixes the big problem: letting
> the refcount (+mapcount) go negative and cause trouble.
>
> This is only a temporary fix, we'll follow up with something better.
>
> Check order 0 folios as well for consistency: each
> folio_add_file_rmap*() and folio_dup_file_rmap*() needs a prior check.
>
> Also, just document -EHWPOISON for copy_present_ptes() while at it.
>
> Note: When zapping file migration entries, uffd-wp is preserved using PTE
> markers, but uffd-rwp protection is lost because there is no correspondin=
g
> marker. try_to_unmap() already has the same problem when unmapping file
> folios, so we'll happily ignore it.
>
> Note2: For now we don't let migration or PTE table collapse exceed any
> limits. Admins can always refault, and if we are already operating in
> admin reserves, something is already off.
>
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) F=
S")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
>  mm/filemap.c       |  6 ++++++
>  mm/huge_memory.c   | 29 +++++++++++++++++++++++++++--
>  mm/memory.c        | 35 +++++++++++++++++++++++++++++++----
>  mm/migrate.c       | 11 +++++++++++
>  mm/userfaultfd.c   |  4 ++++
>  mm/util.c          | 12 ++++++++++++
>  7 files changed, 121 insertions(+), 6 deletions(-)
>

LGTM. I wonder if we want to add a VM_WARN_ON_ONCE() refcount check in
__folio_add_file_rmap() and __folio_dup_file_rmap(), so that no new
caller will not miss the refcount limit handling. That also requires a
reproducer for verification, but it might be hard to trigger all
possible code path. Anyway,

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


