Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4546AC982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31146B008C; Sun, 20 Sep 2026 22:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA446B00B9; Sun, 20 Sep 2026 22:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82426B00D9; Sun, 20 Sep 2026 22:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A57116B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB7E1C051C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:30 +0000 (UTC)
X-FDA: 85236185580.24.DF5759D
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD6141C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CR7Or2zB;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957708;
	b=vR7sZMucGnEw6MptN998AzdOwe0OOPIZUZq2n0duaHhO0yiO5PcEo/8mOytq+P9MKU9+jn
	Bih77iRFRSi/GKvHRMfcFJ259wmJMYHvIyRMmKGv46uJ/V00gAmVAPhn7X+67BrRp4SznQ
	x6uD+N1wEad6dfe0CTjh/o3N21KPsnk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CR7Or2zB;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2exs/HrKls73cpHbMG/JtXwC2lJhkBDc5l1lfu+a19A=;
	b=VrWkzJHtUxE8ZLpjyVGDrwMGziV02kAG9U3R5p+PChrHoQYfltimwzee9iSC1ukwKiYnHv
	I+c8hu3k8AbJe0vlBc45n5mwBaejk7L5KJtV9zFGxbKUU5yWWZAlWb8FgrjGlr5/SK3KSL
	htMrTg16W+REqnbpQv1OH6tZ/+Rrb80=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooao1XNUX/X7BQCL17PHG2+OTFEIAjsPzf8VTw/cmbe3wAeWmlQ/tDsLW1MKK5zYfeAIvuNOrcKcdixMyrKKfNaJv7C1OGs+f3QuvCsL+DaExzrHisL0f7zxz8WnGDGWpGZNTy2KQfj64lz3FLOLrELLgdyl30zgwxviPI+UkFULmfglihOMc5PMMTzywoJq1pSyXd93DEqHtr87tnaLSiFY7VJHgdylIb/7EjAxzdJc4zNEMxw9pvNmsdtJ4jbKkPrM4/SRZg5tvMqFwS3YEdfKCpaVBmsnTsJHzUpV93kp3vBFd53QGrbmz+FHYHrnizh6jj80TgG3tGnvA+GsLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2exs/HrKls73cpHbMG/JtXwC2lJhkBDc5l1lfu+a19A=;
 b=xa7RgjkgAxgW/KZPea5Y+uyHnu2x94SnpWPtmxtzeo6vg9k7J0jJJ8JIT2DHKlWntgqlB1DshMfDlnlJLMDPOeK3GbRqdaihB4UYBIUi1ODuuUIaGhXKxqnS1jF/UiisuKirurPP30TNndoh8ULWLRqvAJ/NYGIz+caGYW8LOGQ7TO94oBWPx1wU+UuG2EQ2XERaeRyRUhmP8aIGTha0aADqwWIJtfDVEgUyQcURRF6lAbF60wktlxGy+LeY3AZZFV02ECbH5CSvLXnjI2/swA/zLLrTroFC9W/ER/7p/NLuicSI9H3tuzeYoq2v+OSgCBwvZWf9nIGn6sLZJoax3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2exs/HrKls73cpHbMG/JtXwC2lJhkBDc5l1lfu+a19A=;
 b=CR7Or2zBviiJFyz67NaDg0JkL5AL9AZtEob9R5DSpscJKymMbJ7LQ4QP+PCjk4eL729UGWg+Csiu694c2lzRIdyD4SjlV3nIcXmERvPPB/Tlny2IrQw5KH0G4lUh6mkm9FStuYA9aOy+wbOwHBpq9eK4t3Z3HjnROqwGR0yYfAUsgdQYFXqkw1G/YDhUjW+PWmTvsWT0YZmYijpnfarHrftrcZ15AySEsqQ3F/eh+HjLE5A7tLLLzBJD8Mlz6RF2cewMmHkZEPXYEDzAvDFhu0LVfwANem4yCZJ4KXI3X/Rd7jKOYSqsHJR4t0jbPqEjrRVHdSl2FNDyskAOBFmgkw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:21 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:27:57 -0400
Subject: [PATCH v5 01/17] mm/zsmalloc: replace PG_private with pointer
 comparison
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-1-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BL1PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 51394719-9726-4384-7bc5-08df17880101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8o6ozca3sc14Wyc5c4TKwCRVyrPqLuGAi4Vb6M9SDYCuQH+3ZKZ4iFe/uKZW8z0XcdzQzWO6l7OL9N+BFaN2NWnCStp97Gf9B55ojuX6/LUft/26pqGWPsLliRAWGaJe4/n/6r03kjymmP9h6JNjWiiGFpibc+cBbXDLMsno62/2DK/Qc5X0y67oj/Fsy6PP5DtghBJRwgj2/s5BTJwRNnljztIQSjGDq9+UCu1BRt2/0YFhMEKntWfylI6xERN7CnbFo/pISaF2mZra3jJrinXDkoKuS1ddcWVK1MwAobwkDva5FHeHEhffj7SVCCtgwGnyDEqpUqclUtl1zKsa/pxvexbuxJtHSI0SIVItnWnusegI+g3Rm7fmm7tCXJTSnVxrLlJwQFt5H95P3DtLbj7I0BuAXR4CxYJwM5DL3ToOQljgoRH8R3I7uPkDM5brQNuz0Y9/OKxrwIkF4M1SUXEU5t2g/AA+cfHS/A7N4B8WBUllHbEVzOaUrqMoznP0y1B4DeeUWOu+bqozWY4eu3p/qNvOrQZrBsXxpc78/DVDSL3R77ellbYVXcAQRPofFM7PTwZPcE4ycwQVQ3JzT1NyrLTHs0iuiUMNzTAX8V+F9XYae1C6awkEfIu8tUZDbmigGw9IucfmN69K77Ekmy3E1p5Gk2bzZ6mzHZW77kwtSb+SLrz9WFMDBSiQ0ddoqhI4LQ1eMloSicXRbulpQQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVRHMmo5a044eU5xVVZmVHRUZzh1bUg5ekxwRW5LeEpLRmdZNjJ4WFk1Q1Vj?=
 =?utf-8?B?VHI3N2Y0QWowcjBxakI4THhkWWJVSlFqWlU5ZnN4UUdsa1QrRnJvTW8rZTBl?=
 =?utf-8?B?OFB1Q1BFNG5MUWVtVjB4ZCt6Vm9CYXk4blBLa2VkK0FjdFhUOGx5MG5hb2Z2?=
 =?utf-8?B?eFpQSUwva1ZsMEtTNnZBNnh2K2o4MDlxRGpheUJUVlpWcG5zNkJrMmgrM3o3?=
 =?utf-8?B?Wm80Um5nWW5QNVo1UDdMUmNYSVdGNjZteS9PZUFpVm1WYjlRczRidnhEeDlo?=
 =?utf-8?B?eGt6Ni9WS2R2NU5RUzdST3ZOYnJlVWVDU1c4VmVWWi9wV1N5U0NXY1V4WUly?=
 =?utf-8?B?djRpeUt3UlZORWFrcFMyRGw2WEcvM2NWUVlTczlnMWNxdThMK1NQSTZQWHFZ?=
 =?utf-8?B?UW9rTkRieWQ2dXBlblZBbVV0TVZEQ2hwZ05INzRLWDRxUE8ydjBoSDVsbEVr?=
 =?utf-8?B?QkdJTDY4QUVnVjVtSFdML2h1WXVyYVJEQkttYkw3K2F6TzRBZ3RtblA5QlMv?=
 =?utf-8?B?RzluTkgxN3dxcU4yOENaQXBkTjBrQW5GaGZnaGtCcXNKQ2xHVFFiR2owTGxy?=
 =?utf-8?B?bGk1NzZxSlppenZySU5SaEY5eUhJVlQyUUhCZURWejdkKysvakZlVWVnL0VT?=
 =?utf-8?B?bWRrVW1UYjZBZjJxWTh6Um9kTUYzNVUwRkREcFA3OU9lM1lCS3cyUmtwL0xF?=
 =?utf-8?B?bGRNTGlDM0VOYlJmUmk2NklxN1hjMzFQRXJSSUdqK1JyR1J2NjQwWmRwaDR6?=
 =?utf-8?B?elFTMU5ac2U2UXNTN0l4eFAvZ2hKQTFLU2hreUdvMnNqaTRzOTlJaFQyaHRs?=
 =?utf-8?B?NGtDNEltakRnTDFYZEJHOUpOVHhhZFhVMGxYdStHbHV5NTYvckhzMW16aWlJ?=
 =?utf-8?B?bzluRndzNmdtMUZlN1R4Y3Y4QUNLOEh0WTFQd3hub1YzYmFlYkVxNEF1OTBD?=
 =?utf-8?B?VHdHVExWd0RZei9OYTN0c2k0NGcvak00WkJqamlGYmtBUld2cnRQa2tNVnZz?=
 =?utf-8?B?UllISWhDN1d5MHIwYUpMK1dLK2Q4WFhsckhCU0FiUTVvY2l2TnBHeTdtVkJJ?=
 =?utf-8?B?SzhVTVhVWlUyYmVicjBmalNBY0ZncjU5bllpT0dUeDVwbGtmU29ja09aNFNa?=
 =?utf-8?B?K1hoYmw1ZU1DbS9teG12VFg3MnVObmJDc1VqU2NWK056NzVmU2R0NW5OQ0R4?=
 =?utf-8?B?ajFjMmw3YmRKTXFrYlJNQzU4b2NSRHRyRTBmckFpckxQbWw2Z29jd2hkUXVh?=
 =?utf-8?B?QjZaTTJZOUNTMTVjY0YvUW0zME5QeFVTTmlWdlJWVFZFOXpxM0JUdkFYQU1u?=
 =?utf-8?B?OXV1SVh5dkl6UVpudXEveWwvZ3hVdUxTeVdxYjZ6VkNOdzBqT1hyQ0pQV3d1?=
 =?utf-8?B?b3pSVENiMUM0blBXWDY5ODJTT1NZNWg4dmVuVDdhZ0RROGlkOVZLekErVzIy?=
 =?utf-8?B?M2lZR052QkdseVVOWlpXaUxYSXRwZEdLY3dZeWE3VEJtZklVU1RNT3E5UlNp?=
 =?utf-8?B?ZWVrTnhXTVE0aTk0cHk1ckRSUmRNbGlKdngxYUE5d3pYMEVyanhESk54T2hp?=
 =?utf-8?B?eFFVUWYxM3BNbkgxdkw3ZTJNTFF3ZEFQbFQzc2J3aGlMdGNFMm1pd1lFM0Vr?=
 =?utf-8?B?TGEvM2VGSEdBQmdvNjh4ZlBQTFhhSUVrRWl6YjRKZWRoYjNjRkVSN1ZIUEpF?=
 =?utf-8?B?cUY1Yng5MXE1SEVMWCtIRzhjaWlDdDE4ZjB2NURrOU4vWlRRVTBBSGNFdC9E?=
 =?utf-8?B?VGhYQW1CV2ExRkpKNG1lZUtTSHdmU1RkWjR2dlJHUDl2eWxpSzhZdisrelJW?=
 =?utf-8?B?azVKcTIwUUR4WUkyamNleFZ4MG9lT1h4cXUyWjljNzN6dWg5WGE3blZYeVpY?=
 =?utf-8?B?em1Pai9JbktuNitONTd4L1VDem5iU1AwK2w1ZHQrQTVieXhOSjMwUC9jOTBQ?=
 =?utf-8?B?SXhmd2RYdjNVZTJISmRNZ2RpSytFTENQZ05RV0Q1dGlRWUdpNkIrbS9xUVcy?=
 =?utf-8?B?RlA2b2plSDZuVjkxNDcyVjZpbTh0L2pxdW01ZWtsN3l0NzNIdmhCMG9sZS95?=
 =?utf-8?B?VjBISlpGTy9BTG1ta1d5aGRqaHhONFlTTUltZk9leG9ZWXl3bmdCMUVFRERJ?=
 =?utf-8?B?OEdJdGZhVUdFb25oQjlNenV1Z2pPRUlXUnJjWERaZEdMc1hWcjZSTWI4UkEy?=
 =?utf-8?B?MXphT2J4Nzh2V1dic3BQUnZJb3NsOVVUTDFhZGU2SVFCUEl5N2ZJOVlvR2RE?=
 =?utf-8?B?bWFwNytpUWx5Y3Q2UmpaOFJNY3o4cnRBOHdIUE5HOFJWNHhJS2k4Z2NMSVNV?=
 =?utf-8?Q?kVBBHcTsjdnNCn/yJn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51394719-9726-4384-7bc5-08df17880101
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:21.0817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHJ18d5xEOMyCONjhjnCYgHxnxce/Dt87QXpH6Gr/8KCUJ+RJhe0fIqk2VkB3eB2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD6141C0003
X-Rspam-User: 
X-Stat-Signature: o5937fb3cpmuixbcw8noxjrhbk7hnhm6
X-HE-Tag: 1789957707-822734
X-HE-Meta: U2FsdGVkX19LScjcRHbjC40DvuwT/ZG10TB2vv178H5PNa98A9EM6SW7Ws1EPnLfug0iStK0Q30MiuQ5qZxR3C32XyF7hf3naREM4rGd5Nf4beJ61zkVO7Axqp0bl1sj24OCWBX4QnHarJdDhhYGi7koTgfU33pKp1nnyTvcPaL1ExfKyH0mRPaLxvN+xu/YqA1voCAbxzAm2qXq8TdXr0AX4QNHHLJs9cdgcM6IfLUFdXKrsPs0mSNyN9w8BKYEVpWBSliG2woH5EtNVyTzz4gY+NnLp1tmWowPLrnCdZyBBh9JXkDbijyEULl/MOIKfPD37bSP6777YpNFv8jCyVltsgwvIxeqDNbzoitqV6OPuxwJxd/Z0TsuDCn3rR51YFYgpDEiB4afRFajVd3SgfrQA9odkptviDjktz9aO3IFz5ZFvOtpIrwDj+2FSHgZ+mzJhVRt0Dks3fVDJvTu/9z4aSE054eIQMXJmofG3LxJ5SSUIb3/o+R87/zlKdaXFiVn8Fj8aqxkdHQ03FTGQf/1m0EDfG2XXyH/It59b+/VvObO3jKO3zZlXOL7RF3ztnBT3YTwIduv6UdO8KPWmcbpqmStxy+bxXOv/fOftcecgq4BTgtKO9LpOej4lWQbOWG6BSJOaEtRY9C0plBOrt1L9nZ+4AkLlpDJ+y++48xOzl0QanFTaACW7wsZ2AzSwIROrh6gXGM1BtHBwgFUvn9R86PBlIRLcqiIhKQJS5Y/a5/EI4cVdPPwMOG0AWRFF+TdMbGev+d+xSae0CDf8DJfMTPnAxlm0+3pnzgxWZgIra17tcmlkjV7FSpV/FjPMMecVYk1UFY3WVcPCsRX/O2FYowQ4kpWsh8iWxZnnuoCWvnH2Kc4UR43f9jK10Xmr0YoJBC/fS/e62uY+C/LdIhK90R1lhda2mieIbAR67vcsPj1QWqXJrvMkFseH0lck3XHb5KWzZPSYnVT4ly
 ixWHv3BX
 cYXIcKCx5MXGnnB386ac/+AjCGJRg5aNfxnjMVrsf6q48H76L5Q8LNVwpJm/tdRjr6OCmx9ePLcLD0WPmow6LkA5fzQ0vnH1jNfCkNx6xrAAE1Ief4vU3W/z6URP0YIYJ7HTKiLB+cTileH0Bo6tqvFugsgbSYmiA4BGxE6rCNXhslHYgIt+5S06m2ZRuWrryRh00o2mtKS6b6R80e8Rztlbe5BfIggfJ45Ueo4nuAt575uk8G33in3Cb9I+C7MejBDpk+l03jPbpGga8Pk1+pQQo5hE+Ey0lFbwz4CdjsAI41TGEPue0i2o2TGBl//eJTvUUXXZRKmrpTW85zZSZGKvIYEvaOVZG2yK1+DK9ARZMFDVDJm7d+4b92b4dJKGGcrItgS1CZ2ayGKLGuVEn0ptCDK8V3EBsG5J5II8aCwRhSr1MQ36YG1q2d//LlmSsIWKT9V6M0hvM/1hwxApxI6l5ivkpl/2WLF78PHikvRrIe/nUkbGTtAJU+lZlwmp/9EYG/aP1oygYdT6/uyncjFtdU6gX3SfgG2lOi2brbZz2trdnzusq+N2BOrbSKKTiw9jFUW0Hwldrw9OpA1x1qPLwhecipel0RYDQlB6pNt886Z1prIF9U+YvQX3+wnabPYAoLuOkOUHXK7H0NrtTDAbtiuAkGPVSpkzW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
equivalent to check zpdesc == zspage->first_zpdesc. Replace
is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().

For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
requirement of a zspage chain, where all zpdescs point to the same zspage.

is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
should be negligible. While at it, change VM_BUG_ON() to
VM_WARN_ON_ONCE_PAGE().

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
To: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/zpdesc.h   |  2 +-
 mm/zsmalloc.c | 24 ++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548d..4fd81c2e80769 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 11be37c431718..7ef80e0da6267 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
 
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -476,11 +471,6 @@ static void record_obj(unsigned long handle, unsigned long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
-{
-	return PagePrivate(zpdesc_page(zpdesc));
-}
-
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
@@ -496,7 +486,8 @@ static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
 
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
+	/* the first zpdesc must point back to this zspage */
+	VM_WARN_ON_ONCE_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));
 	return first_zpdesc;
 }
 
@@ -838,7 +829,8 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		/* only first zpdesc holds the handle */
+		VM_WARN_ON_ONCE_PAGE(zspage->first_zpdesc != zpdesc, zpdesc_page(zpdesc));
 		handle = zpdesc->handle;
 	} else
 		handle = *(unsigned long *)obj;
@@ -853,9 +845,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page = zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1006,8 +995,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i = 0; i < nr_zpdescs; i++) {
 		zpdesc = zpdescs[i];
@@ -1015,7 +1004,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 		zpdesc->next = NULL;
 		if (i == 0) {
 			zspage->first_zpdesc = zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
 				SetZsHugePage(zspage);

-- 
2.53.0


