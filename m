Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E12CF45CB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D5F6B0005; Mon, 12 Jan 2026 20:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAEB6B0088; Mon, 12 Jan 2026 20:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F8B6B008A; Mon, 12 Jan 2026 20:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20F3B6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:35:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0D691AFC48
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:35:44 +0000 (UTC)
X-FDA: 84325223808.21.3D2D405
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4BEA160003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:35:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s5el5HDF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768268141; a=rsa-sha256;
	cv=pass;
	b=uNFQkhvHhVTR7+NvWIlSpYczanWmS7qEzX7ZGJiFSnhYHF82xKfHlY5z0krNdWL+hl0b4s
	V8bS1bk4ptGYudupwKhFQeUVM488oAFg0TcMNllYq8S/QwQg5V1En1iljhhBDMXX4SjkZE
	VqHzeROGNe9iUsV5ri0IQ+MObaa96Qg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s5el5HDF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768268141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ig2WzQNs4uZD/mPYk47IqnKWC1PBrIvc3N79qdaDHXQ=;
	b=fg1drENy7z0td/AW3vwVTwIeQHJ+oojYYNAKxpHiHx9hmwMt3U2itZ0gvWc/bxLBkcr2fW
	UKb7zEBl/F2Z1Uu74N2AL9YD7FXmSI+4FyUg/l+xlX9IFDEQVECZBgipnTmnEk18X31p3i
	6bbIYzZmqnAS8XU7vExk89U9xL9Agbk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3iKDErvKvpbAzDpBf4aFc1MAu9xpaow+pFDe4DH4phbs5EiZILWR1nz7YSesA4J3tfnSPajOtgZ8/vK2CQhAr4aHXuMAQBb1UWPrrBYy5xLeXdJH1xUCVfAaXKVYm/uJwue7fyfKtIN/Nhl1Wr3iBPuyw0OOswVN98iDbYFMK0mk2ApKpRaFtF0n7Tnh6h++f34u/Wv3p2LD3y07ArWj53bzj4BxWNKAcwfD3U789GwxYkQhqpCthHjQcLYazwpEyYGqAj3Wo7uD7ZryOwvjK5YrZlE8Mud0SAENvFiQhGrIjI/6VMxIgwSIPVCprm2pWJtsOIacoa2hvwR6by3NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ig2WzQNs4uZD/mPYk47IqnKWC1PBrIvc3N79qdaDHXQ=;
 b=Eel801OR577Ku4DmiPOes82vDoERrlIaER2I2TsyPukWY9LFAheC9PHThG9+ET2WF5uGIW/bL1y7/DCJ4RXTHFqeyi6wVhpc8jBpuZyQrQvX0tVpuFqgt4OOUGu4qwQbTN21aD0Pl+Xd8ycufOeE3d0LzyX7UYZi7I0pWJwPi8vsDjDGHDXVnWKjpeQu9/oVBfc/jCT82mM1o8B321ydE6LiAK623/iuvzS/iYiWsojsHIBQFHdfubPm6N6RWBq878FTCQmIVXfzM5XSn4IbKpWdapu86tKqCi2ubpW1SXo8pG9eyoGOveoppRECBgRzatzHaF6VtbO+cjDwnu5ulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig2WzQNs4uZD/mPYk47IqnKWC1PBrIvc3N79qdaDHXQ=;
 b=s5el5HDFuUhDzgC8ZR2BGvsNJtkoGthg87zDxCkKhoaTmKcF8foNFCyt1NrhUwN0pqn1mHiIe77XcOCKH7LO2XBGL4ffWV76H+uwiLmowMZPY5q2XDKH5vpbH7EtvwukqXmrXUhYTla9yE4XMBc3qvzHjrSu/m1np8bdxRb9UaUdWffuugHtYwfKFsIN71Mhb1C9oeZisvtQ65wqpkT3MTLF32+1enARkmb3nauZBFgbnL8gfDwP5h9fiwfoZDua/6nzC+uVwZrWDFJXNUZdAmJY47DK0iyxiOpyu9lXDQPRHT/0ChXNyHYfBr0uMnxjVT4yHT/ZCmFG/aqUO+jVwQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MN0PR12MB5884.namprd12.prod.outlook.com (2603:10b6:208:37c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Tue, 13 Jan 2026 01:35:36 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 01:35:36 +0000
Date: Tue, 13 Jan 2026 12:35:31 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, 
	Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] mm/zone_device: Add
 free_zone_device_folio_prepare() helper
Message-ID: <bgbjzeqbvdrlusnt2gexc4joosukgxddca5w5zzq6dz44rjkfq@nt2qd7eu5cak>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-3-francois.dugast@intel.com>
 <706ba3a6-5be2-46d7-9e7d-d613f2e061cc@nvidia.com>
 <aWRLeoUJAYAWbLD3@lstrano-desk.jf.intel.com>
 <k25qmqrfmhzkls2ngdaq4wdk3xtl3epv4z3dvukon5yj2cb2hl@yci7xdpvauh7>
 <aWWQhOD8g8oLz1vX@lstrano-desk.jf.intel.com>
 <ntawk3mmrg2qihe24dk34pevtlgj3cdxnshau3wgyi5lygtuvo@jcsz5hmt4xth>
 <aWWaxakpRiapWw5X@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWWaxakpRiapWw5X@lstrano-desk.jf.intel.com>
X-ClientProxiedBy: SY6PR01CA0117.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::18) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MN0PR12MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: cd500d79-5428-4d5b-ee36-08de52440caf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWg3U2g0bmdZcURmVWpMSVhVN1FrMjVIZGFJVUdML3lEQTlZMUppUW9CKzV3?=
 =?utf-8?B?SFJtWUxCRWNSYlE0ZXVOdFhuUXJHSjJ5QXUzK0sydjltOXVCMm0vQlN2ejZy?=
 =?utf-8?B?YVpKc21mb2dBSGxNVkt2anIyWE4wbFcxaDZxSGxCb2M1SCtOa1hrUjZwSW5p?=
 =?utf-8?B?Mm5ldEh0VlBkWVBYUm5DVDF0R3NKN01kUXBrRXlsS1dTOHF3SGFNOHJCQjlT?=
 =?utf-8?B?U2ovT1FiMWxhdVdNeVhHR1RPd1VvZU0rOVpybXNtTUhyUm4rSXkrV3VoTjNZ?=
 =?utf-8?B?WEZXRU12Y2V0WXRFTTIyYjhqYWsxbGhrUEF3ZXZoRGVRM2MxV2h6cHJsTWtK?=
 =?utf-8?B?RjNZb1Rzb1Z6OXRpd3ZwN3pmZlQyNUJYSGdPTGpwSkJiaWJjMS9McmNMc2JP?=
 =?utf-8?B?bVh1UlZ1RjlYaTNEMzIxNG9vcEN5T2phUUY1TnpLREVwOVBRVnJMaVNRdFpW?=
 =?utf-8?B?ZXcxbFNYSVhQNGwzR2kxekZ4aXJRR2ZJanVockxpS3JkeFVMY0RhNVVuQ21n?=
 =?utf-8?B?YnhlZXRhS0hoNGNnT0UvS3J3YjBiN1ZFR2NFREtVZGtIUVVyMmZJWU9UYVox?=
 =?utf-8?B?ZnlQN1F4ZkNGazgyTU9uRFZlWGM0NHVodmFLSkdqekttV2VSSkNjWjV5QnQx?=
 =?utf-8?B?MzIzWFR0TGw2SnZxalRlWW1jU1YvZWIwVmlyZXQxM1d4L0NvTkhoVXJRc3Zj?=
 =?utf-8?B?c0ZPQjlDUTdtN3lRYnVTQWdsbDV6MU5vWG1uSk5rejhabHAwL2VaZHRqYzVS?=
 =?utf-8?B?OWhySDJITmRiN0VzeWtUS0ZuV2MybzU0RTBIaVQvd2p5UWkvK3Nja0tSRld6?=
 =?utf-8?B?OWRHcUpYV0xaZlUxQjlJU21sRHJHdU15Q0ZacGIzWTYra2NPY2ZGcWM3UTQ1?=
 =?utf-8?B?OVlKNjhRTEtnMGs4d1pQVVk5VkUxc2tjczJ2N3gwcHduTkpGTHRINlR2Mk9T?=
 =?utf-8?B?WHpaYllWQVBIaEpGajdCKzc5OE4xdlBEWGZhT1NBZGNxSmlGK2NMRmlVcXlz?=
 =?utf-8?B?TWs2MlE4d0NmaWxiU3Z6NUIxMzBXdHpoaUpxZ1RFL3hZc3JkbHBrMjdNaXNh?=
 =?utf-8?B?TnhPcjFSL3VTYmlkTGl1c2tDV3Z4ZnJPOEJTcGFnQnEvVCs4TTRadW5GRnE3?=
 =?utf-8?B?TjVablFHNjh5bXluZVAvUXFiK1ZMT0xDcUZqZ1BxT0poNVN3MG90WWFvdngr?=
 =?utf-8?B?aENSZEVtM28vU01oUVRLZXlNbjh3R0k1K1kzRFRydDZkNERqdTJFbFg0c0ZU?=
 =?utf-8?B?cnhtbmJxeHBvVy9nZHNIaUJQTGY2b09oN29kVVY2K0NZaWxLUy9lSmdRQnJP?=
 =?utf-8?B?VjgyaHpjY2czZzdJVE56TkMwZjgzWlZLZ010NXdldW94Q3NMUTlNU29KK0ZR?=
 =?utf-8?B?NGdsQUZzQ1Q0QzJwcVFRckpmYkR2WXAvQ0xCcis4cGJWRDdtNTQzTm5nTXlp?=
 =?utf-8?B?ODlaYTF1SkhKUDNzYWRQYVBmdGZzMVNCSkNtQXp1N05nZ2hjN3JXcFNVZU1l?=
 =?utf-8?B?ZFdDU1VHaHh0R1RIYzdQdFFOeElRZXBHSElJL0VLTDZIWmJ1TFd0UUV2ajgx?=
 =?utf-8?B?YTlWTDBkeG9IRnRjYmhBUXF2eWd6TzBIUWRxWUVjOHdMQ0NLRVJSeHF5Zkhu?=
 =?utf-8?B?TUNIYW93SXh0L2JGRVJ2d1Ard2R1dVVndWozVk9LTkIza2IxK3E1VytROWtN?=
 =?utf-8?B?QTNRT281V2h0S3REbTd4NG9jTDR1a2drUWdZckFVYkFFVG5qZ09CVTBrU0ty?=
 =?utf-8?B?M1ZEczVwcXZYWkFXQ25FaWFOSG8zUTNtNS93RTl4OUNsMS95R0pYdlB5UEtr?=
 =?utf-8?B?L3QxZ3I3T2NsZFJvUmZJcXEvUDhUTjNzdkhJTHphRnVXeHB4ak84Q05DRUNy?=
 =?utf-8?B?bWZTYzVKMUpLbjJTOHA1a2V3QitBV05icW9ObFAzOHNRMC9TdUJZdXNnY2ln?=
 =?utf-8?Q?Ybrp8vJ7DAoC3HOP3Zr8hzqNI3TT9oWn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qlo5cG1VeDBMcGZ1SjFGM1VEZXdPQzZhMFNLd29SQ1NOZlg1SDZNTzJOaFVu?=
 =?utf-8?B?SllHbVBDSUQyNVRyY0xLenBVR2ltdjlIUC9KTm1VUy9oZXZEOGpnTXR1cDBm?=
 =?utf-8?B?YkdqWm1JeHdrb2pjbWlzSnNZcVF4bFVGUkdHRW1Ebnp5T21paHlydFhDQUw3?=
 =?utf-8?B?UU5BQm1mMTc0ODZIU1BzeUV5azBnZVM5RUhmMTkxNDk0a0FUMHJINlk5TlMy?=
 =?utf-8?B?dmFPQ1BUeUNHdi9oVHhTN0g4ckNkTzJmUDhpTXFVbWVXTk1tWks1VU0vZ0Rh?=
 =?utf-8?B?NnFvVkdqZ09WZERwcVdJcUlGaGdocURpbExJVGFxbFIvMEgzQzliNkw3Z0NJ?=
 =?utf-8?B?RDE5ZjBkbjNDVEx6NHYyVFFMRi91bXB1ZXA2U3lVOW5tUGZQKzJkZGdyRU4w?=
 =?utf-8?B?ZmEzb2w3a0lLU1ZQVDVjeUZjQ3FzT0xRVnFidnpBdVc2MGVqbjZxMHlnODVj?=
 =?utf-8?B?VVgrTWFGK3VrZlpDdnVIWW14Y3U4ZlRRdEhGcUVZdVFkTStVK044WFAzcmt6?=
 =?utf-8?B?UkVtWVM4bllacGsvWGxJb2lGZGtiOEdNM3FxeTFWNDluOHd6WUo3U1NsSTFv?=
 =?utf-8?B?ZURnQkhoelpTcFk2ZGQyV3dpYk5PbGw3N0ozY0NSell3eG9yQWFmZ0xtSTV6?=
 =?utf-8?B?Wmcrb0oxNzNyQ1RKRmVSenJSaHRDOGhqOVlLVW9xMTF6SUErZkVIL2o1N1h5?=
 =?utf-8?B?K1J3MFdFZHNiVURIdVdRdlNtYkRsS2xTd2V4NDFKNysydmxCVmZBNmtLbjNI?=
 =?utf-8?B?VXJPeEgzZW56K2pmWFdhdVZjUlR3L3NsWlFMLzNjYUQ0RWcwSCsvM0duQXQy?=
 =?utf-8?B?dGdTQlVmVjRad002eHVXQXNoOUNhaEs2NmtIdXdSNVFURCtlSnlVcnB5a0Nz?=
 =?utf-8?B?a2pCSnZ5ZUJtWGxMb1ZxZXY0S0ZlbmMwdDl5T3ZSQU83czZPZGYrN3p4TW5o?=
 =?utf-8?B?Z0E4MWdLSHh4K2crbml1RThtS0lWM1JGaWhoeDdiM293VmdVSGhPb1Z5UkVK?=
 =?utf-8?B?cG5WbkE4NmY4OERqUmhPTEpOMUxJNHdMVXcvQlJoaXFscTg0d0NFVzFSU0Zz?=
 =?utf-8?B?V0drUHpEOGdVVUZUOGNwRkJjMnZBem1hakhEU3ZDbXZQODQwZzlLWndyeFcr?=
 =?utf-8?B?M1ZUZTJuakpGK255V25lcVU5bVZYclExRVl2WnVIeW5ZTzdzaGNPNEtNajdJ?=
 =?utf-8?B?Q0huUVJBZ2ZmYzNKaU5aNy9RSkpnS3NKWnFmL2lUUHhvYlR4NUZxMEpqdlpV?=
 =?utf-8?B?Z0xlcTBPcXRlTktFdHJuWU1tRE4wNG5ZRm4waVhvd1FESjZ3ZHRFUU9sTjlv?=
 =?utf-8?B?UGZEdlJydU5lU0JDZnFPeFFLd0RsbkFRN2x3b1k3OFZQc2RKaGNZS1NKVXZo?=
 =?utf-8?B?VXo5dVlWZ0NvVWdxZ3U3MW91TUlmR1FOOUw4Z2VVcFEvblRQbDg4L0hUVTdS?=
 =?utf-8?B?OG9kQkNBeFlOZGROd2E5VGw2K2pOTDNHL0tMRXBJeEFHTFg4K0VydnNiSDlZ?=
 =?utf-8?B?aFB4c01pWkF3VDRFcDBSalhtd1J0a3BXOFRvdFB5d1hqQU5wS0lKREN3S1lX?=
 =?utf-8?B?N0JQQWdOaVd3NGx1cWlvbWtaemJmdzQxOGx5SmdENnpSU1hlZktmb2gzeG53?=
 =?utf-8?B?VHkyTjVMbXoveDl4azJLZExzUW5vaFpCV0I3VWRIWmZyWDVIbVMvSlVTSWs1?=
 =?utf-8?B?ckZNV2dJeWZiWklTL2VmU2JHL0xkZDYxZFZIcG0xbzNWOGZFZWw1NEVZbkxK?=
 =?utf-8?B?eUZUdzdPckJCYWNNSUJ4N2VuKzVPT0doQ3ZHZTFLOGJsRTRZeDdBT2Z6OGw2?=
 =?utf-8?B?N2tmOW5BWEdaWStsbnFkU1h4YUR0NXZPbkpxeW8xUnlLYnI2ZnFjanR0M01F?=
 =?utf-8?B?ZTNlL2NoL2NRK2lBTEFNbUxkV3dqUG15eHRjamRNeEZ2QVlOdFgrOTFqWlJn?=
 =?utf-8?B?cW4xUDdKaVlQMjlFeERzbnlkSk0wTHd0WTBjTzZZdU9lcklzYlVlcGVsaDRJ?=
 =?utf-8?B?R3FNeFJoeTh1SndMRnlvZ09iOExyVmdHcXJlaE9ZZWJBVG1RM0FLbnVsaE1a?=
 =?utf-8?B?MUQrNUE5OVZnRWZ4aW1YQkxTK2NvOGdYeGd4YmtkVndMQ2lBNmd2NnVqc2RU?=
 =?utf-8?B?T1YvYWJ2YTZHUlFBUzZ6R2xaa3R4Q0wyYW5KUk9TMlN1SGVuQktsQ1orbTZT?=
 =?utf-8?B?RFhtZlJjbVRUNjhjZllSNFVIMDBBemxtd09lakx6YzlXa3NpNHBZcCsyUmNF?=
 =?utf-8?B?SXF3UW51bDhzdng1cDB3TkdOc2xOUFZPWjc1UXNHYWpNUlJHbWlHbFNPV3dj?=
 =?utf-8?B?cDVyVitkdVZjbmpPeUlrY1ljUUROK0ZOZ1o0aW9hWDJXQkl0WWxNQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd500d79-5428-4d5b-ee36-08de52440caf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 01:35:36.0152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bohnMu76FRjpNgL2XnRLxkEyA7wHpyaY1iy06xKwYTY5jkGXY2Cr9DeyldHddAmRbuBAtp8MOZW1RHKj/okPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5884
X-Rspamd-Queue-Id: A4BEA160003
X-Rspamd-Server: rspam06
X-Stat-Signature: ut3ghwht1xcijjwgqmenmtap59npxoxu
X-Rspam-User: 
X-HE-Tag: 1768268141-229631
X-HE-Meta: U2FsdGVkX1+CCvMqhU0ZwMQXUT2HDu7Mapb5Y23M2VDdgNydk+viA05l38t4WEPfS7oD9u0+NkUNWwB5N/CKKBwyRyK43yjhEJ2nLSvzOgK+G7Y19NQhAg5u1VfYlnyXgmKVSSmVBxTMc87fjlIFVpBYq4Q6IYHGoJuMjG0kr9DOiE7Itp/oDDE3ev18rif2HA4e8mDIOZHieZ+bfmh8EFja14yBjyTL9VZyToQVflhcNL/P/FMiigr/Mdum0+qKMEQYDGtdPuAPRpDo5FfZ2VdDGSfHbS6R5DjJ225vPlDPUep+LxzemjqJhmRsuhazBX3UCeMlul8GTHl5Hj1RdfToXZWmR4k44tbbhOSdLrq2GLnJTFJsoBI5pTg/CEXLvQk2i1LrEPGmzLGlsSDmwisj6a4uac1pHLHRU86qXANTrTbcB6WP8vtFHytZbt0Oe4xLjOJSl89Sos0XAohi8YDk2sb8JGV5GYPU5l21PxvrpQ+uVmwBr17Q+MYKue6UFRc64mhsJHaz1qSO6TJcih2KVQ3ppBKUJPsDGV/csEAI+jShoQBQDnaEG2UqcgV0DtCoeRDD4+SK+LDEBbMF+3nujnOy5gY9DtU5G7r3cWwIfYQVru2u+AnlU8P+PZvpbroyrLPDbmAhxA5GNCN2YABStuISuaIuOselb4roBFiE9CvZcMWrmCHsb1AZ5GIlBmRkFuLuacPbz2XiVAqYOWEBYpJg/MdNhtAeAMVD2wGdX261euTNeT/RIGnV+zE5wDwrWrQXCzoFGBI8Ugfot2fhN0UW1bPIZliJzO7Z4iVaoyowjpcTf/ix4Rri+D9xhRyOYI6bTKKNM2y2UDa/blGXIkJ2tOwBWYG0THewAyp46jTEniUFplcIatnzTN+cL3uPu+9Jcx+K7joxRTnl+0tML2iXV7vT4/hwfyJBrsW8y7Pi8WWUN09WeWa9rbeU16HbiKVUuCs6hRWiRB6
 7HZ+LZ2h
 UH3huOpheF3vQJ5EuNzeWwX9RJKCVJ96x6ALMQJozXbUEn92yzvr7t3m/CGBbOuT3ISEx8LX8h3z2QQXQFABqnYhTic55dRXd4tzLBePTSxX7JmHMZ5mCOIH9E1MwLcKroCmLqc3VnQnCTetqI97e6+eDrE9fpnA97NESmSqUj35D7E0Vi5SleIbcWqSTFTUDQ+Dbr06c82vgN3hSWmMIX3pJeGd9TpF4OtBVyMk1tpBbMfQzzQQpZPo0ir8eNROtMYRgfmA34GfRHRJ8GBw0COQo5wMN+xdqR/gAC81ZmWRK/jCpTyURC4u2vo98YI75zWPc8OI8sOQvSE1wzH9+Qtab73uhe+sKsAaAlQ1boQz/Z/0JRV0uZm1mr70/A05f87M2TBZivjHnzHbCdmCV+IJVgz32PCVCeEcr6oKyD4fQMsNxBZL7oEFspQuAHG5k9l8rdmgSGHzBFGwXEUWVYnxmGPFXQlzO+98TKMRjDuO/pCWHWHBWRBpnmwm2OgDtM9m+H6cxxSl0yHlUy36Ynfe7zejjFUn6s7tGVSpEBx2VAvcna5ZsVDu9HlEr7u3fIcpybsefUxtN6jvaSqeb/OA33aZo+DmfZyCtqqIifAO4PKYifCJmkqnINn44FMzWwAJDEqneK3vEkUCnQKIUBjB4nGVMzLAYhxJbAk0jyOF1fkeWo0whYlZUU6dfU4EszvWa1liNn+NtrWGl24hpGxMYQ7tj7Z18sm8O14MIb+D77o/aoqTE0MM4IA0x6Xnmgi8ClZy+f6jVapxF0dAgW/Pens+oDdq4zjRaFrMWWMSga/oPFwuwkpAhxtbNHTDgsoC7n50Cazen67g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 at 12:07 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> On Tue, Jan 13, 2026 at 11:43:51AM +1100, Alistair Popple wrote:
> > On 2026-01-13 at 11:23 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > > On Tue, Jan 13, 2026 at 10:58:27AM +1100, Alistair Popple wrote:
> > > > On 2026-01-12 at 12:16 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > > > > On Mon, Jan 12, 2026 at 11:44:15AM +1100, Balbir Singh wrote:
> > > > > > On 1/12/26 06:55, Francois Dugast wrote:
> > > > > > > From: Matthew Brost <matthew.brost@intel.com>
> > > > > > > 
> > > > > > > Add free_zone_device_folio_prepare(), a helper that restores large
> > > > > > > ZONE_DEVICE folios to a sane, initial state before freeing them.
> > > > > > > 
> > > > > > > Compound ZONE_DEVICE folios overwrite per-page state (e.g. pgmap and
> > > > > > > compound metadata). Before returning such pages to the device pgmap
> > > > > > > allocator, each constituent page must be reset to a standalone
> > > > > > > ZONE_DEVICE folio with a valid pgmap and no compound state.
> > > > > > > 
> > > > > > > Use this helper prior to folio_free() for device-private and
> > > > > > > device-coherent folios to ensure consistent device page state for
> > > > > > > subsequent allocations.
> > > > > > > 
> > > > > > > Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> > > > > > > Cc: Zi Yan <ziy@nvidia.com>
> > > > > > > Cc: David Hildenbrand <david@kernel.org>
> > > > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > Cc: Balbir Singh <balbirs@nvidia.com>
> > > > > > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > > > > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > > > > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > > > > > Cc: Mike Rapoport <rppt@kernel.org>
> > > > > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > > > > Cc: Michal Hocko <mhocko@suse.com>
> > > > > > > Cc: Alistair Popple <apopple@nvidia.com>
> > > > > > > Cc: linux-mm@kvack.org
> > > > > > > Cc: linux-cxl@vger.kernel.org
> > > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > > Suggested-by: Alistair Popple <apopple@nvidia.com>
> > > > > > > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > > > > > > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > > > > > > ---
> > > > > > >  include/linux/memremap.h |  1 +
> > > > > > >  mm/memremap.c            | 55 ++++++++++++++++++++++++++++++++++++++++
> > > > > > >  2 files changed, 56 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > > > > > index 97fcffeb1c1e..88e1d4707296 100644
> > > > > > > --- a/include/linux/memremap.h
> > > > > > > +++ b/include/linux/memremap.h
> > > > > > > @@ -230,6 +230,7 @@ static inline bool is_fsdax_page(const struct page *page)
> > > > > > >  
> > > > > > >  #ifdef CONFIG_ZONE_DEVICE
> > > > > > >  void zone_device_page_init(struct page *page, unsigned int order);
> > > > > > > +void free_zone_device_folio_prepare(struct folio *folio);
> > > > > > >  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> > > > > > >  void memunmap_pages(struct dev_pagemap *pgmap);
> > > > > > >  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> > > > > > > diff --git a/mm/memremap.c b/mm/memremap.c
> > > > > > > index 39dc4bd190d0..375a61e18858 100644
> > > > > > > --- a/mm/memremap.c
> > > > > > > +++ b/mm/memremap.c
> > > > > > > @@ -413,6 +413,60 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> > > > > > >  
> > > > > > > +/**
> > > > > > > + * free_zone_device_folio_prepare() - Prepare a ZONE_DEVICE folio for freeing.
> > > > > > > + * @folio: ZONE_DEVICE folio to prepare for release.
> > > > > > > + *
> > > > > > > + * ZONE_DEVICE pages/folios (e.g., device-private memory or fsdax-backed pages)
> > > > > > > + * can be compound. When freeing a compound ZONE_DEVICE folio, the tail pages
> > > > > > > + * must be restored to a sane ZONE_DEVICE state before they are released.
> > > > > > > + *
> > > > > > > + * This helper:
> > > > > > > + *   - Clears @folio->mapping and, for compound folios, clears each page's
> > > > > > > + *     compound-head state (ClearPageHead()/clear_compound_head()).
> > > > > > > + *   - Resets the compound order metadata (folio_reset_order()) and then
> > > > > > > + *     initializes each constituent page as a standalone ZONE_DEVICE folio:
> > > > > > > + *       * clears ->mapping
> > > > > > > + *       * restores ->pgmap (prep_compound_page() overwrites it)
> > > > > > > + *       * clears ->share (only relevant for fsdax; unused for device-private)
> > > > > > > + *
> > > > > > > + * If @folio is order-0, only the mapping is cleared and no further work is
> > > > > > > + * required.
> > > > > > > + */
> > > > > > > +void free_zone_device_folio_prepare(struct folio *folio)
> > > > 
> > > > I don't really like the naming here - we're not preparing a folio to be
> > > > freed, from the core-mm perspective the folio is already free. This is just
> > > > reinitialising the folio metadata ready for the driver to reuse it, which may
> > > > actually involve just recreating a compound folio.
> > > > 
> > > > So maybe zone_device_folio_reinitialise()? Or would it be possible to
> > > 
> > > zone_device_folio_reinitialise - that works for me... but seem like
> > > everyone has a opinion. 
> > 
> > Well of course :) There are only two hard problems in programming and
> > I forget the other one. But I didn't want to just say I don't like
> > free_zone_device_folio_prepare() without offering an alternative, I'd be open
> > to others.
> > 
> 
> zone_device_folio_reinitialise is good with me.
> 
> > > 
> > > > roll this into a zone_device_folio_init() type function (similar to
> > > > zone_device_page_init()) that just deals with everything at allocation time?
> > > > 
> > > 
> > > I don’t think doing this at allocation actually works without a big lock
> > > per pgmap. Consider the case where a VRAM allocator allocates two
> > > distinct subsets of a large folio and you have a multi-threaded GPU page
> > > fault handler (Xe does). It’s possible two threads could call
> > > zone_device_folio_reinitialise at the same time, racing and causing all
> > > sorts of issues. My plan is to just call this function in the driver’s
> > > ->folio_free() prior to returning the VRAM allocation to my driver pool.
> > 
> > This doesn't make sense to me (at least as someone who doesn't know DRM SVM
> > intimately) - the folio metadata initialisation should only happen after the
> > VRAM allocation has occured.
> > 
> > IOW the VRAM allocator needs to deal with the locking, once you have the VRAM
> > physical range you just initialise the folio/pages associated with that range
> > with zone_device_folio_(re)initialise() and you're done.
> > 
> 
> Our VRAM allocator does have locking (via DRM buddy), but that layer

I mean I assumed it did :-)

> doesn’t have visibility into the folio or its pages. By the time we
> handle the folio/pages in the GPU fault handler, there are no global
> locks preventing two GPU faults from each having, say, 16 pages from the
> same order-9 folio. I believe if both threads call
> zone_device_folio_reinitialise/init at the same time, bad things could
> happen.

This is confusing to me. If you are getting a GPU fault it implies no page is
mapped at a particular virtual address. The normal process (or at least the
process I'm familiar with) for handling this is to allocate and map a page at
the faulting virtual address. So in the scenario of two GPUs faulting on the
same VA each thread would allocate VRAM using DRM buddy, presumably getting
different physical pages, and so the zone_device_folio_init() call would be to
different folios/pages.

Then eventually one thread would succeed in creating the mapping from VA->VRAM
and the losing thread would free the VRAM allocation back to DRM buddy.

So I'm a bit confused by the above statement that two GPUs faults could each
have the same pages or be calling zone_device_folio_init() on the same pages.
How would that happen?

> > Is the concern that reinitialisation would touch pages outside of the allocated
> > VRAM range if it was previously a large folio?
> 
> No just two threads call zone_device_folio_reinitialise/init at the same
> time, on the same folio.
> 
> If we call zone_device_folio_reinitialise in ->folio_free this problem
> goes away. We could solve this with split_lock or something but I'd
> prefer not to add lock for this (although some of prior revs did do
> this, maybe we will revist this later).
> 
> Anyways - this falls in driver detail / choice IMO.

Agreed.

 - Alistair

> Matt
> 
> > 
> > > > > > > +{
> > > > > > > +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> > > > > > > +	int order, i;
> > > > > > > +
> > > > > > > +	VM_WARN_ON_FOLIO(!folio_is_zone_device(folio), folio);
> > > > > > > +
> > > > > > > +	folio->mapping = NULL;
> > > > > > > +	order = folio_order(folio);
> > > > > > > +	if (!order)
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	folio_reset_order(folio);
> > > > > > > +
> > > > > > > +	for (i = 0; i < (1UL << order); i++) {
> > > > > > > +		struct page *page = folio_page(folio, i);
> > > > > > > +		struct folio *new_folio = (struct folio *)page;
> > > > > > > +
> > > > > > > +		ClearPageHead(page);
> > > > > > > +		clear_compound_head(page);
> > > > > > > +
> > > > > > > +		new_folio->mapping = NULL;
> > > > > > > +		/*
> > > > > > > +		 * Reset pgmap which was over-written by
> > > > > > > +		 * prep_compound_page().
> > > > > > > +		 */
> > > > > > > +		new_folio->pgmap = pgmap;
> > > > > > > +		new_folio->share = 0;	/* fsdax only, unused for device private */
> > > > > > > +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> > > > > > > +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> > > > > > 
> > > > > > Does calling the free_folio() callback on new_folio solve the issue you are facing, or is
> > > > > > that PMD_ORDER more frees than we'd like?
> > > > > > 
> > > > > 
> > > > > No, calling free_folio() more often doesn’t solve anything—in fact, that
> > > > > would make my implementation explode. I explained this in detail here [1]
> > > > > to Zi.
> > > > > 
> > > > > To recap [1], my memory allocator has no visibility into individual
> > > > > pages or folios; it is DRM Buddy layered on top of TTM BO. This design
> > > > > allows VRAM to be allocated or evicted for both traditional GPU
> > > > > allocations (GEMs) and SVM allocations.
> > > > > 
> > > > > Now, to recap the actual issue: if device folios are not split upon free
> > > > > and are later reallocated with a different order in
> > > > > zone_device_page_init, the implementation breaks. This problem is not
> > > > > specific to Xe—Nouveau happens to always allocate at the same order, so
> > > > > it works by coincidence. Reallocating at a different order is valid
> > > > > behavior and must be supported.
> > > > 
> > > > I agree it's probably by coincidence but it is a perfectly valid design to
> > > > always just (re)allocate at the same order and not worry about having to
> > > > reinitialise things to different orders.
> > > > 
> > > 
> > > I would agree with this statement too — it’s perfectly valid if a driver
> > > always wants to (re)allocate at the same order.
> > > 
> > > Matt
> > > 
> > > >  - Alistair
> > > > 
> > > > > Matt
> > > > > 
> > > > > [1] https://patchwork.freedesktop.org/patch/697710/?series=159119&rev=3#comment_1282413
> > > > > 
> > > > > > > +	}
> > > > > > > +}
> > > > > > > +EXPORT_SYMBOL_GPL(free_zone_device_folio_prepare);
> > > > > > > +
> > > > > > >  void free_zone_device_folio(struct folio *folio)
> > > > > > >  {
> > > > > > >  	struct dev_pagemap *pgmap = folio->pgmap;
> > > > > > > @@ -454,6 +508,7 @@ void free_zone_device_folio(struct folio *folio)
> > > > > > >  	case MEMORY_DEVICE_COHERENT:
> > > > > > >  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> > > > > > >  			break;
> > > > > > > +		free_zone_device_folio_prepare(folio);
> > > > > > >  		pgmap->ops->folio_free(folio, order);
> > > > > > >  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> > > > > > >  		break;
> > > > > > 
> > > > > > Balbir

