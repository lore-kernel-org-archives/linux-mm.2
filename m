Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4055C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 22:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284A16B00A2; Mon,  4 Aug 2025 18:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CE56B00A3; Mon,  4 Aug 2025 18:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124C46B00A4; Mon,  4 Aug 2025 18:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F28DB6B00A2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:47:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EA0181546
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 22:47:01 +0000 (UTC)
X-FDA: 83740561842.04.668561D
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4D86CC000A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 22:46:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IGmJCKiX;
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.44 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754347618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dPEYYIKpQb1AE+cr8RbqWVU3lweoJ2rNKFDkHj+6Eg=;
	b=Zat6rJfjWmHcPrQffo7fhpxN37e3BuN94lvoj0N2goNlqDvR3v+uLhFzK8tt3gD61rarbC
	14ru0FIgxgef/IPVxaAtJmHeT732H0x6E+7F5va1VOBQFvYxaCHM/l73P5CkpMPaOQbjjZ
	sozlpbMSXonTItu227soR1H2PfRqiew=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754347618; a=rsa-sha256;
	cv=pass;
	b=F9riBImDtMvkubB994xeG0WtcC64V78OnOJJZT1yKg6ImsDMcyj7kT3lUA1HT3d3jhbgn+
	gUWXyPXpH036QAsD+Ba3F8oBf8vf+8nKytOZwwJIYoBASrMYlXxxL8hHKJ6XQaJ2GcqJM/
	9f8wJvyn+2HqTMiP7eOGgJ59U/LtcUs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IGmJCKiX;
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.44 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LDhjkwHlKrB4n5Wr0lxUMy7TuThNtQOf1GPM+bXysGSEklRdmXeQ0s5iNJw9+ieSDHhD76vvor2fRKWG6Yz8lANqJwULo3SAEG0je6JtoGXkjxjpu6SltIVhxitdyEpMnaeffGvq+VWtLRTzNWDnmTTiS9TNFuqP2C/lwnRHneIdmMV4WeVVX7EmKeX64MoTZrMXQ58S+Hn2TS4Za/godQejpCQ7fqu4H2tMVnMcALfyqwqOoKYYQsAne/WL6I/zyaflFLkiQ45URUQqyYXnQtFcqPHVfDKlo/5qsVW1K6MWs2fvmjRlY5nudVx2I6xf/xRF1Ye+Sl6SOznMqKvZDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dPEYYIKpQb1AE+cr8RbqWVU3lweoJ2rNKFDkHj+6Eg=;
 b=XQaUukZHTLdmbAbIVR0pLfPUVGqS+lzhx9urWkSKjWy56QAwUyCpRDBNAupTumaes9aSNtz1BjWLaWtsua54Eot3O3HwVR1eEsGTVuGLLIxAb6pOqHayxWiqCPJuFHwzA7E+o+aLtOh7XOPimhDXDU0yPBQDwVr0M0RNSmh2VBJxHqtGoxq3kmNfKxPPyCuvLD0B7WmJdcLSFPKPMV/Bka3kWZQfkPMCInQG4Qf7G5wtRW0COG/KgsSfjMDC3ipej9CMgkaZT3Td8FhqpxKMSkOjGJ3SiyhcguF2IXWdbnx3dL1/0F7gKNyAaLPIZv11ujhQqRDm0CBNh3bbnhl4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dPEYYIKpQb1AE+cr8RbqWVU3lweoJ2rNKFDkHj+6Eg=;
 b=IGmJCKiXG/bnRl/r8Ys3A1fFOtFBmGrmBoP+IQWQQUecv2s+xs0Cv1x9AlY8BglKPaXeDHU+5xtiszYF45LjixBajnWead+9PuqTRSZfvPDhsrpchcM0J2qZ7w72yBHwt81tO6Un3Fouam4V5vpVEaEc2WhJE6ffs05kM436N3Jmr8mQwNyibVDDJ+tZNfdYCpZE/uVVz/fWIzMs7KePZQ09xANKp2BQ99JCZB7Cb2Q/1CEkpG8toedSxup/dNTbFSCCwhKL0tB6KO44m7KFxW6Z3T3kmRWAIPF/ErSoOHdwioSj1n4pimYuHylowTjzdPSFvtJPbjhRaKJMB6e1Rw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DM4PR12MB7695.namprd12.prod.outlook.com (2603:10b6:8:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 22:46:53 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 22:46:53 +0000
Message-ID: <f3e85850-bc5b-461a-9efc-d1961fb5d340@nvidia.com>
Date: Tue, 5 Aug 2025 08:46:46 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
 <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
 <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::22) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DM4PR12MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b928a6d-d879-4829-0dd6-08ddd3a8ce91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkxpR1lGY2huSzUwd0ZKMzFndXBpT2FZQjVPUWxpbSszOTZtSHVveDlmS1Zk?=
 =?utf-8?B?emoyMEZoM1cxU0luOGxFcjA4MnoyYXVCM0loUmJCWWtFdnNlUUxpRFR3aWcy?=
 =?utf-8?B?eUEreHVCWnVxK1FrRk94SjBCdlJKMkpFcUtmcDhqR05GT0RuQ1ljaUNrTTFa?=
 =?utf-8?B?ZGtVWnZsSlFNOVNxaXJiazA1K1BzWmJqRXlicUErMWkwSit0cXY0STBTZEJh?=
 =?utf-8?B?N1JkbHc4REhGSGNOcVQ1Y0ZtcEZKVHd1eTk4Z2o1SzYrZEhPVytlOTlKS0lM?=
 =?utf-8?B?SFIxTi8rb3ZtUGxCbEIySDMxSUpQUjNhQ3UzTVVjZThMWnZ0R0MrVFBFS25L?=
 =?utf-8?B?eDVVYktFNjhCcW5ZRFgxQzM5aWNmeUJXdHJ5aE84ckhUTmFBMHA4a1N2OWtD?=
 =?utf-8?B?eGV4dmswWGFGVmltbEZuRVpXMkhidk4xZThqcTBPaDBNMWw5NW5Mc05wZXBD?=
 =?utf-8?B?SHRUTE1GS080R0NkU3Z4VFZ6WEtMdC9WeFdFSzY5dlNhT0FPbzlVSnpnYzF2?=
 =?utf-8?B?a1RuYWNQejU2NWtHcmJKRHV5ZzRJT1pYSWI5QmZoSUJMcVdaUTdSNnQrVUNk?=
 =?utf-8?B?a1FUODhqZ0VCSmVwSU1teTAyYzRnUVo5RU04N2dxWmlZZnUzZ0txUG9qdDh4?=
 =?utf-8?B?aUxCMFR2RmhTR3owT2pJdTZSQXRMQVRiOVVOeVdZdVZtUDVLNmNMTTRHbVg4?=
 =?utf-8?B?em9IZklocmwwZ2VTeHcvWmVVbngxc0R6Z1h6c0NpdzlyVjRBdTlBMXI1eWpp?=
 =?utf-8?B?TDc0emQzZHJxemxkZ2t0QlNmSWV2SlEwc1Q5RlF6QXBlSGx4aTdlL054OVJ6?=
 =?utf-8?B?R1A5b3hWNEdFemJTNVdvK0RYQlVMcko1cXB0R0lkWmw0Z0VMOU9XN09IdFhi?=
 =?utf-8?B?ZktTZGtmUVYxUUFJYzJPNFVBbHBQRkxMaExFTmIvbzhVTFNwZnd1Z0RHeElm?=
 =?utf-8?B?SjF6azJOZmFpZm96Z25tamoyalRVbHhXanVRT1Bzc2FBRWZCYVlkbVl4SUFJ?=
 =?utf-8?B?Yks2MXp2dFp0dnpRa3piMlBqZUZhOVd6bkc0dFk0Y2dZd0xXbUdaS0ZsNHht?=
 =?utf-8?B?aFdlQUphVzZVUlQ5S3BlaVRpWFNPS3lmZktBQlZTQkl6UHZ3YzUxTU1TZXVM?=
 =?utf-8?B?cHpkUU9OQzVKaWVaYlV4b0VjaHNGM3d5bmNjdFAyMGs2b1Y3LzVKTWVoekJ5?=
 =?utf-8?B?MDU0Z0pjSk9lbEdPUUpqaCtvTkE4OHZVMGJQMFc3Y240elRQaGRrdlRJdlVv?=
 =?utf-8?B?RWFtdDJRNTlkL3MwQTU2ZlEwcGFZYVdCZldxQTB3b2wvY0ZNUU9BOHFBZDcz?=
 =?utf-8?B?aW51UGVoMFNDaG9EQjU1bGJaalZmV1hyNjlrOTJlRDgvbmZRdTd6aDcyT085?=
 =?utf-8?B?R01tdGRLNVplcXBOZHgwRkpCYUFaWTJWMDBvOXpod2RYTWFnM3JQcmR5UXRp?=
 =?utf-8?B?alBLWGoyLzk2cTR2ZEl2enVsOGRqay8xQS81NWNZRTNJY00wYmpQQTJ4dUwy?=
 =?utf-8?B?Mmd3aC8rWmJnNVVTckxpS2wzb3R4QmZsMDJTN01YdmFZbDFwSzMyaExwQ2pt?=
 =?utf-8?B?UVJxMmkwWFYyNEFPRGNXYWNGY3EwL2dZcGZxWjdYYm52dWRyRFlWVlFNMm81?=
 =?utf-8?B?Mmo2bjd2OFkyVTB5STdUNlZVVnp5MlI5V1R4MlBtWkNVZ3YyVENwM3lYdHF0?=
 =?utf-8?B?Y2RUOXhsZ3lqVkwvVUdLTk1BdnBCRVorVHYxRGUxL05mR1F6d0h4NVoxY2Q0?=
 =?utf-8?B?L1lBVVZqaXJydjVqR0hDRFBLRllMeUNtVGMrbHlKOHg4WTJzRXQ3ekJJZ0pG?=
 =?utf-8?B?cUY1ZFFqaWMzU0Fpc0pxMFFNYVZZRm9sQ0plWWNSeUxWVnZwakl2UjZGdWkv?=
 =?utf-8?B?TmNZdWtoWE1WWTB5dGhRa0ozK1oySy9HeTFHb2cwQks4S2xSa1grYmFHSFds?=
 =?utf-8?Q?LlvWZvc9Pvo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2FzQWdsZnFsc0h4cVFoeHYrTC9RbFNUSjBETVNNSU16TzFrN0lHZXRUcUhj?=
 =?utf-8?B?UGpkTG91QnV6SlBKQ3d6V1R3WEZ3YktIY0FQTXBlb2RHL3RUVXJYaEs5STRQ?=
 =?utf-8?B?cGk4djFxSjdCUkZKSFgzdHZTVlRQTlRXT0FMUldzQ2tsZFJnanpVOU5qcFVZ?=
 =?utf-8?B?WGc4alBrR3JuOXVidCtGNWVVdnhVR0FZYXZJaThiU0h2dWh6U3YvdWlPMDNE?=
 =?utf-8?B?U0UyK2w3eWJxdVY4cDNUNUxTV21pQ0MrNTJaSFVKUGJMRkpZR1BqNEdubFow?=
 =?utf-8?B?djQ5SU9BL2hMSjBESWprcjVoaXA1RXBwVHFNS0tJcm5ob0IyRHBTMHZZa1lK?=
 =?utf-8?B?NE82QW5JY0xja2FhL21LZnVTYitrS2RSZXM0K3lJVTZkdVowTm5aWUs1TDda?=
 =?utf-8?B?WUNxc0RsUndEenZPSkhnb3AwQjRzWWhncHVCZWtqU3lUOUJ4OXRGamVEOGhF?=
 =?utf-8?B?WkdqMXBHRWpyMG50Nm85NmVTSlNKTis1WUZOaWZPNnJoeWwrc3J0VnJCMkcv?=
 =?utf-8?B?RTIxbDhaWjdweGFxVEU5ZzJ2T1dTZHVhZndFcytEaFNUM08xNFZ3RGwxaHRW?=
 =?utf-8?B?dGtuV0xmOUFWWEpCZlNONnoxMWJtb2dMenNLaVJrckVBeFk2Y0hVd25OWm90?=
 =?utf-8?B?dFJWUTBiWi8xdW1wMjNUa0srK2lPOG9pNlZIT25Ld2pFdXFhTDBoR2NxNHVl?=
 =?utf-8?B?VFVrdmk3WEZ3bzhxQ1BZclRraCtWbFZOdHlzUmdhWmlYQ09GTmNXT2lSek9h?=
 =?utf-8?B?ZVVoeHY0ZVp6TGVES3dmbWk4bXlFTm4veGhuamJQcXlZbHhPdjc2MENoSGRx?=
 =?utf-8?B?Vmt6ZDkweE1iamxUVVFhRVVEdzNaczJFVVdEWER5KzZxejZucTgvbE1QSGVW?=
 =?utf-8?B?TWhqNzVYckFueFNwNXYxZDIveWNsVmdUQWFZSkE5c0psemJ5Qks3U1hwRXFR?=
 =?utf-8?B?eGRLRVIxVmYzbkxkd084MGRJdVpkN2tFZ2Y2dEVHYytWTEMxYlFVdWVMZXpJ?=
 =?utf-8?B?Y0FvdEg2eFY4U0EwcDNtdmxEU2ZXM285bDRnVFVybEFNWkZhVXZ1NTBVSDIy?=
 =?utf-8?B?anl3MkRFRHY3eTViVDFCY3ZXYllwak0wNittbTNjT2s5eG5YQ0k4bkNvcXQw?=
 =?utf-8?B?WmpjdG1RS3VnSVVPNkQ4NjR5ZDA1bUNzWHpOa1FCajRtOFRHbjJwTTJaazU5?=
 =?utf-8?B?aDVzY3NhcTlZUGpXaGEvREpsQ1pDeTNDcWNscUhMZ3VPcVNhbGhMazJVbXBE?=
 =?utf-8?B?byt6R2IvVFhzWmlrWWV0Ri90cnZZMkxGcHhrbEVIcytWYklJMVRaQzFjMW5P?=
 =?utf-8?B?TXFTZTVUeWJTZWpGYU12RzQ1d2M3VUVYdmpqSm4zdjhKbDZKTWpWd0NOOXVp?=
 =?utf-8?B?V3kvcUI4RzJ0Smh2R0Q3QTFibTB6TVE3WjdKeWZJSlR4cWdWOUpwcWhvdTh4?=
 =?utf-8?B?dXdOd3BXWXRUMW5PR242TWs0MkdTQmZXbTNWRHVtT0VpeVhtc1E4d0RYVDRj?=
 =?utf-8?B?SnZuRG5JeDZ5R2ZoVXJGcVJUcnZwbkxVcnJmV1NmTjc2SEoyZWpNNXpLNGFz?=
 =?utf-8?B?bGVpZEtWZ1k3WE1mcW84Q0Z5VEM2U0x5VzJYU2I4YmRvVkFFMmpJMnFTQng0?=
 =?utf-8?B?cnNVRGRWcCsrQzl6OVVkNW9TcnoxTnZzMDc3eU02VlRPV3I4c0RYWCtHWVUx?=
 =?utf-8?B?czFSVW45OG05UWNYUmZyZmVITHlsU2dzektIRS9tc3dTNHRIOWZaL2xldVI0?=
 =?utf-8?B?U1gyUXhmc3VFRys3NHJDc2tVbXViMmJzdklYMUNyU0RESjJFYXZZS2hzelVx?=
 =?utf-8?B?LzNpdndtRVEvUXkxT3BvWm9zTVBTRnFwb2JCQnlPaE5ycldncWJiQ2hSWGNr?=
 =?utf-8?B?TFhBL0FqeG51N3Q5eFA3VkZ0NC9hQTlxSE9XcUtHZEpiN090b003b2w5SDFJ?=
 =?utf-8?B?a3d1VTNTV21RODMwRWpGMGcya0ppUXVVSzE3Q3dwNWF3Tlc3ZXZPb2YrcFBz?=
 =?utf-8?B?QlVTdXArUk82SmdyQ3pWVUtuSHpMVkxLSHVyYVZJUThEbjloYnorVUZsVjdw?=
 =?utf-8?B?RjBrL0tUR0RPUHF1YjFJVy81NW1YL3FKLzJXbzVuYmpNMzJXaDRVdGVqNm1z?=
 =?utf-8?Q?wu4bspzPGSCVmYnZL690gWJ7D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b928a6d-d879-4829-0dd6-08ddd3a8ce91
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 22:46:53.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vzrwb1eYnQBeRqiUKTlOVkji7jTUOjTKUUn98M8URXGd09yjmbXt7MvCiYANgYrQFxU4Gl1u5skZMaaOuuRTSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7695
X-Rspamd-Queue-Id: 4D86CC000A
X-Stat-Signature: y1rzxqqcowmxfutpeazqkmusgu89q3ie
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754347618-241880
X-HE-Meta: U2FsdGVkX1823vc0cc41vDgs93ZoB13rT45lC3oZROl8bLTUpJkXqBiDxI3pmYV+xIftpn7p0JW7QQwizftku7huxEG43IsXbw98xL1iXRfqZVpDjJmLR+SvgtsBN9aA7cmMfscl9gdVIVsqu0L5UoUoCOZOl40eZ2OESd+16o7KJvnAVojT52tScrHIVYUv36HI0Sx7vzgwl4D7v7IRXRIlz3sN9h7BkdgkVGNvU1jvdgFl1gM4aorCZWtIzjlZJZSIUBYKA38SS9mWD+eRuBX0SKNK7tN65CWkAQAW1KszKpsvWANKC1EqkVAGX9uDqg+u58jg0Lh5yWde4DYdy3sDZvogLf/Tdm1JFpmrOuKvs34rNTntWZBf2pZGWZV9SWgjDEQzEcvizNBGXMyx3uxBn/QiJcAIuY3wpIgqrcn1omPJ6CoRywC07ZxDWtyvg+V0C1jj1JNnjiTL+kRfy8vrW1BlGdNVlNczHpW6yEQLwSpN0fQSANZMPrBqXtqFY0oWAlYXWY6c/3YnjLQirDzJQ48kSJwrEP2bWsDMjhuX8c2jfCD0dekbAhevt+eSb/83+hkvYQCm0Y45gjZ4YP+6jJ3x7Ymo2GchfngArcr6E3NLgOuf4HwnKhJNeX1aV0BgmMLhpnZrpI9xlQE6afVSkimY61mWOiG8CzggBk48KasPTpwpBAKCceN9K11D0Zaqw29WK9kBLQmn/wG35I60HbjufaZ1untTpGOKPEaWxF6ATBpgGnUoAEKsxUNWMsm+J1rqyVIbNBLzlM2QQOALmq9VsBIKctuA/FqgjB83vuIOVXqdE9kMmhvoOY9cHqtKDSBRGuSEPEPrmB1efz05dsNLJweLKEVJv68lj7AA6j05Wg0sam3FRoRYx0yxjVGkvwtGYCZdTc6jGFa4gMsUCm8y1VuGPIrtD2pyrCPVVZuJtrpyk4+yhtvMb6KTUiHLFbQWLqG8O06Zn9L
 EVwZWD/A
 mdHKuYtYZFpD3zsWKfOl5IFOd8Arn89z2ti82r/ZBc2/TOLSI9jNO2omTd/sd8gsC3KTUuGS9CyfyCpVFReNfuumjqsN4iPaApS1ylXKw6uTFDlSY78Ux3mwpk+uWed/ZzFzeUW511hZVHS/vHdrouzKJmx2VuyEpg9IeSpJmzb6xHCEVkBV6dURvBjFfvAK2D0nhh8wX9pS9Gjs4mdNx/xhipvnmCrmgjjOHMSOY5YrzcGfooLxsKs05jluLO+LYwxvYaVUp8p4YN8TeSKpOYW3rCiik8RQjXlfuUmGkkFA2I2x9nDXEmj5A3JYeIrg495h9df6FWBCGGSCjVq50ot2EQR0qKhJuL2uuOjiKX6f+0lGQN62LKSnLqJHlkIgTnri7TZoU9hPVHmW0G+rRV59d/ezOekNQ+mRZ/6lNSE8CwnfPhRdABwRQO+CnuKhtMywNO73o3K+eHlHjXNMtPatBTf5ciql9ouUNxs0NUrR3ZDtOeZQl11lL0T4SfLQiOLOPIxnzvwhxsc3I2PQYYWewFsuxsNnZp6xvvyZG2enJKgzagaoUNuL5zK3uRb8lI3vqee6sAmtSeBwRgs+ymL0gA/g2p4ShZJ0jPguHOgrfMGzT9HXjDgy4LAXXaA1vUTYJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 22:13, Mika Penttilä wrote:
> Hi,
> 
> On 8/2/25 13:37, Balbir Singh wrote:
>> FYI:
>>
>> I have the following patch on top of my series that seems to make it work
>> without requiring the helper to split device private folios
>>
> I think this looks much better!
> 

Thanks!

>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> ---
>>  include/linux/huge_mm.h |  1 -
>>  lib/test_hmm.c          | 11 +++++-
>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 19e7e3b7c2b7..52d8b435950b 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>  		vm_flags_t vm_flags);
>>  
>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>> -int split_device_private_folio(struct folio *folio);
>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>  		unsigned int new_order, bool unmapped);
>>  int min_order_for_split(struct folio *folio);
>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>> index 341ae2af44ec..444477785882 100644
>> --- a/lib/test_hmm.c
>> +++ b/lib/test_hmm.c
>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>  	 * the mirror but here we use it to hold the page for the simulated
>>  	 * device memory and that page holds the pointer to the mirror.
>>  	 */
>> -	rpage = vmf->page->zone_device_data;
>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>  	dmirror = rpage->zone_device_data;
>>  
>>  	/* FIXME demonstrate how we can adjust migrate range */
>>  	order = folio_order(page_folio(vmf->page));
>>  	nr = 1 << order;
>>  
>> +	/*
>> +	 * When folios are partially mapped, we can't rely on the folio
>> +	 * order of vmf->page as the folio might not be fully split yet
>> +	 */
>> +	if (vmf->pte) {
>> +		order = 0;
>> +		nr = 1;
>> +	}
>> +
>>  	/*
>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>  	 * large number of cpus that might not scale well.
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1fc1efa219c8..863393dec1f1 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>  					  struct shrink_control *sc);
>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>  					 struct shrink_control *sc);
>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>> -		struct page *split_at, struct xa_state *xas,
>> -		struct address_space *mapping, bool uniform_split);
>> -
>>  static bool split_underused_thp = true;
>>  
>>  static atomic_t huge_zero_refcount;
>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>  	pmd_populate(mm, pmd, pgtable);
>>  }
>>  
>> -/**
>> - * split_huge_device_private_folio - split a huge device private folio into
>> - * smaller pages (of order 0), currently used by migrate_device logic to
>> - * split folios for pages that are partially mapped
>> - *
>> - * @folio: the folio to split
>> - *
>> - * The caller has to hold the folio_lock and a reference via folio_get
>> - */
>> -int split_device_private_folio(struct folio *folio)
>> -{
>> -	struct folio *end_folio = folio_next(folio);
>> -	struct folio *new_folio;
>> -	int ret = 0;
>> -
>> -	/*
>> -	 * Split the folio now. In the case of device
>> -	 * private pages, this path is executed when
>> -	 * the pmd is split and since freeze is not true
>> -	 * it is likely the folio will be deferred_split.
>> -	 *
>> -	 * With device private pages, deferred splits of
>> -	 * folios should be handled here to prevent partial
>> -	 * unmaps from causing issues later on in migration
>> -	 * and fault handling flows.
>> -	 */
>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>> -	VM_WARN_ON(ret);
>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>> -					new_folio = folio_next(new_folio)) {
>> -		zone_device_private_split_cb(folio, new_folio);
>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>> -								new_folio));
>> -	}
>> -
>> -	/*
>> -	 * Mark the end of the folio split for device private THP
>> -	 * split
>> -	 */
>> -	zone_device_private_split_cb(folio, NULL);
>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>> -	return ret;
>> -}
>> -
>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		unsigned long haddr, bool freeze)
>>  {
>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  				freeze = false;
>>  			if (!freeze) {
>>  				rmap_t rmap_flags = RMAP_NONE;
>> -				unsigned long addr = haddr;
>> -				struct folio *new_folio;
>> -				struct folio *end_folio = folio_next(folio);
>>  
>>  				if (anon_exclusive)
>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>  
>> -				folio_lock(folio);
>> -				folio_get(folio);
>> -
>> -				split_device_private_folio(folio);
>> -
>> -				for (new_folio = folio_next(folio);
>> -					new_folio != end_folio;
>> -					new_folio = folio_next(new_folio)) {
>> -					addr += PAGE_SIZE;
>> -					folio_unlock(new_folio);
>> -					folio_add_anon_rmap_ptes(new_folio,
>> -						&new_folio->page, 1,
>> -						vma, addr, rmap_flags);
>> -				}
>> -				folio_unlock(folio);
>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>> -						1, vma, haddr, rmap_flags);
>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>> +				if (anon_exclusive)
>> +					rmap_flags |= RMAP_EXCLUSIVE;
>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>> +						 vma, haddr, rmap_flags);
>>  			}
>>  		}
>>  
>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>  	if (nr_shmem_dropped)
>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>  
>> -	if (!ret && is_anon)
>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>  
>>  	remap_page(folio, 1 << order, remap_flags);
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 49962ea19109..4264c0290d08 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  			 * page table entry. Other special swap entries are not
>>  			 * migratable, and we ignore regular swapped page.
>>  			 */
>> +			struct folio *folio;
>> +
>>  			entry = pte_to_swp_entry(pte);
>>  			if (!is_device_private_entry(entry))
>>  				goto next;
>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  			    pgmap->owner != migrate->pgmap_owner)
>>  				goto next;
>>  
>> +			folio = page_folio(page);
>> +			if (folio_test_large(folio)) {
>> +				struct folio *new_folio;
>> +				struct folio *new_fault_folio;
>> +
>> +				/*
>> +				 * The reason for finding pmd present with a
>> +				 * device private pte and a large folio for the
>> +				 * pte is partial unmaps. Split the folio now
>> +				 * for the migration to be handled correctly
>> +				 */
>> +				pte_unmap_unlock(ptep, ptl);
>> +
>> +				folio_get(folio);
>> +				if (folio != fault_folio)
>> +					folio_lock(folio);
>> +				if (split_folio(folio)) {
>> +					if (folio != fault_folio)
>> +						folio_unlock(folio);
>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>> +					goto next;
>> +				}
>> +
> 
> The nouveau migrate_to_ram handler needs adjustment also if split happens.
> 

test_hmm needs adjustment because of the way the backup folios are setup.

>> +				/*
>> +				 * After the split, get back the extra reference
>> +				 * on the fault_page, this reference is checked during
>> +				 * folio_migrate_mapping()
>> +				 */
>> +				if (migrate->fault_page) {
>> +					new_fault_folio = page_folio(migrate->fault_page);
>> +					folio_get(new_fault_folio);
>> +				}
>> +
>> +				new_folio = page_folio(page);
>> +				pfn = page_to_pfn(page);
>> +
>> +				/*
>> +				 * Ensure the lock is held on the correct
>> +				 * folio after the split
>> +				 */
>> +				if (folio != new_folio) {
>> +					folio_unlock(folio);
>> +					folio_lock(new_folio);
>> +				}
> 
> Maybe careful not to unlock fault_page ?
> 

split_page will unlock everything but the original folio, the code takes the lock
on the folio corresponding to the new folio

>> +				folio_put(folio);
>> +				addr = start;
>> +				goto again;
>> +			}
>> +
>>  			mpfn = migrate_pfn(page_to_pfn(page)) |
>>  					MIGRATE_PFN_MIGRATE;
>>  			if (is_writable_device_private_entry(entry))
> 

Balbir

