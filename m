Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39BEF532C2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5668A6B008A; Mon, 23 Mar 2026 20:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DEE6B009D; Mon, 23 Mar 2026 20:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CA66B00B0; Mon, 23 Mar 2026 20:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 306A86B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:12:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB7C8C407F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:12:53 +0000 (UTC)
X-FDA: 84579031026.10.AA2D0EE
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	by imf17.hostedemail.com (Postfix) with ESMTP id C95A440005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:12:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DsO26Gx5;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/8iBfRIvk3cO1WzR2FfgAhfZigwHsFVpCAUii5jnQY=;
	b=WiGDYSXzRSWDTmCeFAk09AFCNH9Cq2jr1W8/2PPY3jtbs0COEqn4aIr8n+b0Kz33Iy7lD4
	AekEJDiuN4d9XXwCHB8KDk2X9gA0Q24Q2ULeaOTLcu3L5MGi1co5sT2Ka5e0REiit/gpf9
	48HjXGBU2aAJw7k0YfNlZ6aNUPVuVNI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DsO26Gx5;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774311170; a=rsa-sha256;
	cv=pass;
	b=Avxj5okhQW4/oYGIqqxfr3RvXfzmiEVnEgelWpuyZJqBqAMgf3HQaMMJjxaggmIKNKpUiJ
	hdo/uO86q3upWh3Q6zFhXDTeeZPtOkuJBRtZ4acr2NU14HQvd9cggKXlZ/spjl4qgehbqJ
	qa2fj48IrGdwTMM8vgv7+m4WHtO2Ui0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCFJn+gpwP2BUqnlQI8c9RBkojK6hakp0jUHtfcqUQ+JB6iWHus9bGEqVaYGlROfOSkhLEJ5BEeW1anNy6yS3sIL7hb8zG31g4heInEcsYXMyAcnyJzFmcREbCGwy2/E7jnUGbJ8RWtuK7igZB66pum3B2+B1N7pUEdMAwtWBDjK49/7N7hN1nDzVCCNu7rIYFik1apoobDaRy1AEEP2DsbMSkR4DmvvpTw9Zh7bckB8VzWERUdYevGZBmakmxJqiFkaD+d9F1tHVidY0zqzW/8cf57gvRfqLi4GcSLUCIoPBfFOVqMl2v+iPBrv1pPTm40zdb0w7mfySYgrd4XRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/8iBfRIvk3cO1WzR2FfgAhfZigwHsFVpCAUii5jnQY=;
 b=syflU6f4IhKkZA3INjnqvALbakVG+M2hGnIZJsZV9+UTzWBwbjSPrbtyvtJglXNXmJ4z8EstKyT8rWr0dhVVCNN3ImKVV9CdbB1l/9rzSeIQWc484B3KvzQqQUxPjpZiWKsB0aymNS0pl7xVqAGg/4snF5vXpvyjsAodkavjCDvLF4+k53SvMUxW6/WAkS7BV7C39E/gfWwtNg05Jq4a4jtCUOX9Y/KbM9uhYKUi46fklcHOakIDqiWhdkhgxleW9f5I6PQUfb6ag8XdnpcO4crXD10ogKuc3pIhgzezSGRVdEB+mQxl0hqyXAitHscNDvTNw+Ra/Oo+bZyhL2xEUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/8iBfRIvk3cO1WzR2FfgAhfZigwHsFVpCAUii5jnQY=;
 b=DsO26Gx5N4n6RfrRjkXir5qpfZyKQF5vz917UnnLU7tmcuH8+d8LkJ7Di6qGxyuh3pwcjqGLIuQ/BPeuvoNe/01uJIuT/a2I9kowO4+4rAkg418k97YW9b2MkTZLtRVre71XNTzJvSkNNLS++fFIFihE+vm+PSYDo1Se2FL6m+0pIZwOw7ueQe35lMaENs8fWc/vtJV+gRwfLu8riqGICP7hw0K295xM/kY0fM+bcXNSEAkaHBYPVJE5/Wd0+bKnsS3ZeatL2htbnj4sxsVjg8tePu6jbw2y2sFIatbMxsVIrw9i2bs9X+BeYPFTs5Vq/AnwKg23WRKECNxw0e8BYg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 00:12:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Tue, 24 Mar 2026
 00:12:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
Date: Mon, 23 Mar 2026 20:12:42 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C3591451-D910-453F-980E-C12CC66D731E@nvidia.com>
In-Reply-To: <16117b49-d83d-4ceb-b85d-d117d6993ce1@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
 <acGqbeSjktT4biku@casper.infradead.org>
 <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
 <EA39EF46-4331-43AB-8602-D0A73E9C9C9B@nvidia.com>
 <16117b49-d83d-4ceb-b85d-d117d6993ce1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:208:23e::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: e1271589-29ad-4d26-df94-08de893a12f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xR6fdW4yyCf9CYfwrWksF1a1wPyZMFHWIMv6HOaVKfirVUB880bi4cV/zCvAfcoYzIzMI9iyoHEPLO5sw9qfvPhnR26wfL6SZbetOh1pazGXNNowgFnJRnWiw9GLDUhA12cNM/Vmu5ifrxSjJMCmlfcF8MZo3L81ORxtfnzLyL6AQOtCRvZhEjk+1cuWJaEt1r47pXSawY3+FHj9y4HS5dp1vGC59VPK2Lrh2q8Gs/JHfdxDkiZ0jRCqHTOLH/u+Y1cFIAzHZDV0XHRQoBigH0VnZ+QBV8CuJFtIxkJuiJpSupnapj983S/CKQcQmxibRRdIzja1KI3kZ8ViZFXgyp8+/TeaPFFms428vywID0qJnk+XHnQzbQmm0RhZHemEN3MbIjWEW/45r/Xx3nXnN4aDvE5V+xi1FlK+nz1Q0lT5THgGblPqzUPMo09BxYZVR4sfxY0xGcpNqnjMB9PlaE0Ak3M65bcy9wBX33UzHziN86EGHbnBc12SY49/4t3QbQAGBCXjQEtoviTVAezqtOFZIfwoXgPnUlvwJsiWf99Lhrcy9rdFST/8Ti9KhY5NU4ZqqlCLG4AD867i3vaBOT3fBATJ9uyAmDWA2vhwTGJm66mbOarghYhQ8ac/3bLiTFriexvIKploBudaExvVdM8vuv0KNC0B21kdWL/SzQBxJrRnKzgU/1bahwzMjkHwIcWBHLSmugtMwDMWfXvWINFdPwr50EDtGuCCT4LgA28=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDlEZ1JTaWFBMDA4QlNzaytJOFlSMTU2eTd5T2wvcE53NTZ0S0NXUVBqWldG?=
 =?utf-8?B?Q0xDMCtpTlhNdlBBRWFqaDY3eDhGbW1XNUwvM2ZWTkdGeUV5ZXdpa000VjYr?=
 =?utf-8?B?aFlYd1BkWEZSaEJiZ3VoRnk2QUs5Wlh4cVJUK2k4NHYxMUxQdkxYWWZTbkVI?=
 =?utf-8?B?Zll6MEttaUROWFZkRktxUmJ4S1JnQzNHSEZwYUtvQVRqaWM4WEN2UGpjMnhC?=
 =?utf-8?B?bWhJL1lNem5GQUVDVDZLb2w1TWxMNlNjcFZWTDBRbE5JNnR5aWpUVWZVcWlQ?=
 =?utf-8?B?bXZ5MXRYZ2xqd0lHN3RYaFhHZWJERm03M1k4dklhcThRdXRJcUp2cWI3L2N6?=
 =?utf-8?B?cTZjQUtxWUpWd0hFYWUvd0tqYjlvNDBteHp4UVQ0SDE2cFB4U3R5RnZ2RzhZ?=
 =?utf-8?B?QnFFU3Z4WkFjT1g3MWtRbzFRcWZKSDJDWDEva2ZacUZGem9EQ1k0YjlMdmQ5?=
 =?utf-8?B?MnNEVW94VHZEQldlbFNzWnY3TGdZT2VvMTkrNzUxa1hvaVlZVzJDaEhFajZa?=
 =?utf-8?B?c0dxM0JjQXYzY1FnL010WFdscjJGUXdMZ0pKY0R1alVnTnp6M21FNndPa1pJ?=
 =?utf-8?B?WXNvY2NJU1dsYnR3Tld3K1M1YkVyRHJBSzB3N0d3dzdNM2dYZkRTa2gwYzkw?=
 =?utf-8?B?Wjc5TG9lSlYwTEhnNThCNDI1RGZodmhSZHpQbVZDY2dGbWZGTnc1dHFTclpx?=
 =?utf-8?B?WDhKc1M4RlRZWFdMd0JrQzZrOFRHaDRQS1padnFGZUtXUC9kRU1xMDZNdWtJ?=
 =?utf-8?B?Zk5GWkZRaGF6YTU3cFBxa3NPN2xwNjArdnJ4dDNnTDJETmJsaGphMEU3UkNP?=
 =?utf-8?B?cGl4MnMraXlpc3Q4R2ZCK092U1VoTXJZMEwzTFlFTWV6anJtbjR0S2QzZXlF?=
 =?utf-8?B?YXFVTXE1cEZ6UVZYdlVrdzBuSncrdzRhN1RXTTIrODl1SE5CUkoxWWJXL2hX?=
 =?utf-8?B?YS80L3lyNzZnbmlYdHdnWXF0VnhpeFVCRFNUVHlVd21IWnQzbWtQTUo2b1d4?=
 =?utf-8?B?Ym1mcktWd2V4WElZbWxlZ3pDdlN5dGNuRWlHTlhSVWQ1eTQyMDFPWC8vSXcz?=
 =?utf-8?B?NFg1bFA0ZWtORitkTVRCWFBxUUpzSHltTURYYlJGV0lKTVNjdUNIUEkwNEJq?=
 =?utf-8?B?NzhEaENaUHFaUWh5dFRlODFHeHp6My9GZ0ZYNElxT3pxclA0bDVkMkVuQWUx?=
 =?utf-8?B?RkhEcG1nTUZlbnZtWCsyTnREWFBiejEvZFUydFJoSE16TGlSVzBRVTF0RGZG?=
 =?utf-8?B?YWVVMlh5QzNhRkhMQU81WHNhbkVMRE1NSWFlVTZnbmR3aUF3bktFbzVXZFFz?=
 =?utf-8?B?UVRIOTV6dGV1amZtSUJJZFRqbDViUjIyTTR1SW9CNEdqYTdxb3k5SEdnZTRn?=
 =?utf-8?B?RXl2MzhaeDlaR0tsczBQV0o3aFFRYWdZL2dORnJoOWZqeUYwd0xXeGE4VUhN?=
 =?utf-8?B?OU9uZXZ1YnJ0dTFTU1ltN0VPYzBTTktGSFNyL3RYOThSOGRNTHBQM0hQUGZV?=
 =?utf-8?B?cVFGS2M0ZjNDQWRGL29LUm9iVXBNOFRKU3JNbjJSU3J4Umk5VGt0ZndTYjYy?=
 =?utf-8?B?S0g2Nk92MnhzelFYZlNCamxRMkdzR0JiaW5xVmNnTmtBNFpSUGxBazYzdkd3?=
 =?utf-8?B?R1RkZkVvSStkc1F6ZWY1WWdKQ2w1V2U4QW1vSmZsTGs5ZXVOQUMxSUkzY2dZ?=
 =?utf-8?B?NTBNU3BodGdkRHFOdDFaQ3VRVklETFcvdFM1aFBrT3BsTGlFV0hHbWJoS2Ix?=
 =?utf-8?B?aXNYNnhJU0h3MHE2a1JHeCs2UndITmJmMXZaV3h1bU1iQlNQM1NQZ1V4Q0F3?=
 =?utf-8?B?aHZ6MnljYXFJVHdXWTdtSjgzbHRkdG1wOU5ESGxqWU54QlpVaUZJVTVHTHFi?=
 =?utf-8?B?NzVRY0toQzFRc0UzSE5ucXBSNmIzOS80R3g5VVNoOXlPM1JrYVVsek1La01a?=
 =?utf-8?B?bVZ5NFpmVllGaEpGQW83ckU2U2tqZ243em5XVGtkS0RYUFJrRVdKTFN0c09Y?=
 =?utf-8?B?dVhiaW5jQVNWbm9WMC9iLzJWMUR2YUtGRUV5UlBPSDdyMXRZWEVrRGljT21h?=
 =?utf-8?B?SkV5STN2MXljUnJBRkFkMUJqMEJJVXM0ZlljZE1jbXJMa2Z4WG1pZ1VDdU0x?=
 =?utf-8?B?SmV3Y1JsM0JMTjZwZkRJQzBYMGRlQmNHUFYzYVJJcEo4RERISmx4U1gveVBt?=
 =?utf-8?B?dlBOUUtwZzdUYytnSWdMazB5M3pMNTFxcC93U0o4aEtJbUt2ZFRQRkdmallN?=
 =?utf-8?B?emVzeE5aRFUwSlp3d2xxQnBMTStiQ3JadGRnakRoRitka3B2VlZyRXI3MGw2?=
 =?utf-8?B?b25uODFvTlgzY0xia2orZE9xeVdNOXlmeWoyaGpaK1BIWlFaZjlwdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1271589-29ad-4d26-df94-08de893a12f5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 00:12:45.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okVYexFUmHe0A9latyVDoESU9Uhk3b9jzrYIY8OGXLeoZFcAcQmTwOuB5llWzvHy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4130
X-Rspamd-Queue-Id: C95A440005
X-Stat-Signature: wc7cjkuwanw171sr5o4gn7k3hnqdwss3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774311169-929657
X-HE-Meta: U2FsdGVkX19wDhx3A7qvghIxpg81ZVsZV1vpooMxd+UPb5s8qyOXpwEf+jY8MkRysk6vrAlrkV4K0gxDm7gmoPLDbu3vlz/ddFrT+Ot8KOuN2PCZLhPiwDi1ri84uqmp/FGaRGFPxn3Ht575tdgBsbRneFRs49lDKmL5G9pYcX0Lgf8YpeiDRHkKko0Wq/mDyXv2OCqCV2q5U3DGKIQrZAGadc7ijDuBBISNXHmTZq1jITe5sPrvA9BLAqn45QwM9sA9dw5YBAJ5jiKZWkh3CjuSeeRj3xKd4K+c0606y/ZWldZC1vID/kC7F8Dy/WVS1LIlXa3664MNpAf0eIp0TFilQslSrHeR5ThE1BsKbJGCHD+NbWF6aKeyYq8INc+KmS5l89SgsBN7l5781RJ4ReDK1E3DCoR/rfZ/NxBnMxmB6o+xGyOL7aMimwYyVMe1qYBDnIktC8i6MKxA/xXVhpj642EY71fksUfOdjxWD6uwaBB8vSSogzlAswa9e2GF6FzqW90LBcg+pVsYQa3TxKrQ7RwXZ4XmQzryyNork5JRRuhbVk+BTUfc478pqMHLArGYIXm/9hV9xoxORCtheOBgrySx79auVV+vkGhooffEGEtSPOKu4RrL3gxVg93USp5D1jFST3F3kOQQyOke9DeV9k4RFRvg9sDl+x2Esy2ngAJhNYa5t0zdcbV7S86rPVoWV2lPI5WB6m4oxiQVRMzp8sSeX3MtABkfL2Uim2LMintqJBa7FBU58Ubk5LA9tdnGVQ4yC/iFNj8bU2imcxkTpgJQG1lqDs8rJnxLa4/n+JAASTbSxoKCJL03BiULiOe9n28VRuh1p47E5q+2dzSQouJsRCL0Mf8W2dXLs9RcLbMOaIVrt6Wl3sosQMqV5D6BhD34HbMWE4UJi6RZCKiD3PJ1lMVDfBoAMpDCZgFJEiA+DICz3UQ82OjjFWVEV0pEH3dt3i16rY61uGf
 xBSioHP/
 j7/yCJiysJO/PGlfhL+tc168zsW5ipSUgAH95inkns7A34KnozN3twSoSsNO5w7JSRpZ939x5WCsMaOvxTuppmqcY1JUqZBn+SpxaRCJshEih4Bb2AuIZ0xuoV0m/YpcVVgmObYVoWBTusW91pYDrhCDapVlwAg9yYbaRg5IrNl5Aifr/Pk84Ao0DMzCydTXCsqNeDDdJWaBZ+jM0CJCk78ga7QC3ByLLMPeeClGKidXqAJQMOxFEDDfPq5qvrRV2V16Efx9lujofoCM36CsacajoLaVlQkvqB0Ms0Ci9KT/dOwBzYtNNNLj4pxtANPeEq+tbwtgc2QsIF8Qs/jmiuNioblGE+gY+vbYHPCZaL6f5Khr5OZ+6ZUKKO3E1+jl4lca/DNJx2dNNyUejU9hlsTddvWoQ+mlWJKbLrLIT9MKv3Ic+E1gxejl6Ka1RP2Guy0JG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Mar 2026, at 17:21, David Hildenbrand (Arm) wrote:

> On 3/23/26 22:11, Zi Yan wrote:
>> On 23 Mar 2026, at 17:05, David Hildenbrand (Arm) wrote:
>>
>>> On 3/23/26 22:02, Matthew Wilcox wrote:
>>>>
>>>> Not necessarily that lucky; if you set VM_HUGEPAGE,
>>>> do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
>>>> On busy database servers (and is there any other kind?), khugepaged
>>>> takes too long to run and find opportunities to collapse text pages.
>>>> Like, days.
>>>
>>> Yes, in particular given that the default khugepaged settings are awful.
>>>
>>>>
>>>>
>>>> I think the test needs to be:
>>>>
>>>> 	if (mapping_max_folio_order(mapping) >= PMD_ORDER)
>>
>> This is very helpful, since I was thinking about using
>> mapping_large_folio_support().
>>
>>>>
>>>> as there can be cases of filesystems which support up to, say, 64KiB,
>>>> but not all the way up to 2MiB.  I disapprove of this situation, but
>>>> this is where we are right now.
>>>
>>> Right, that's what I had in mind.
>>
>> Does Nico’s mTHP support for khugepaged include changes to collapse_file()?
>> That might change the above test.
>
> At least not regarding adding support for other folio sizes. Baolin
> (IIRC) had a version for shmem support, but that will come after Nico's
> series was merged.

Great. That makes my life easier. Thanks.

Best Regards,
Yan, Zi

