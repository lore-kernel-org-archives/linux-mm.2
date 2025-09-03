Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98697CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 01:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01EF78E000C; Tue,  2 Sep 2025 21:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38AB8E0003; Tue,  2 Sep 2025 21:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD98F8E000C; Tue,  2 Sep 2025 21:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C75128E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:20:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56DD9139D9A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:20:05 +0000 (UTC)
X-FDA: 83846182770.28.23259C4
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87D9AA0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:20:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DdohzEpH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.92.87 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756862402; a=rsa-sha256;
	cv=pass;
	b=CLUV/Vcb+noma3vNR+sNdiVGCVJfFivnXCcf7AyN6HxAi+19itRr2XUOV+8/jf3agEzJ8b
	fHulWe9h2jBEJA0e20IXcm5KNWS5E6QKbF/l0jmyho0kgMMlGCkn9I22gDxWA/E5QrUjCk
	DwSSE9899A0CanquowjIItyjJG1vd34=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DdohzEpH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.92.87 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756862402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/w49IMVGk3JbxRWISkJAbSZ59CLQl0lJEn2YUbK2iw=;
	b=1vHhEmDf+eb5ChHRLs62ZVhptbgmqe3dAyPGZyVVoB/ENhjrnmSNcMv76+5e0dNVo3Lf13
	MBztqA0Yd4aEqnlsInCWaxwp653n/USudEl2FyIbKjNZ8lwCMv8MgonzRY3IwvH3r0/ipg
	yLb4MM2icGMsW98TSCFeIlDfbH9Tbw0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yRf1oam00rqnVk/314lOFxhl0FpSMJj4yZIE8GBw3Y1a5zwPHrm515BWVDxAn5kjarHEKKMXg/C92zJ/biwXQQeq3K9km9q9HN/r+FjkBSgn8QjcNZwyKPyyNGqnIY34ybgB71kELSZzE14tBVMxHfSFbKH7J8F4R1rVAINYhVeQpHvKa7z5i1BRK0yex5ff89T1MXmQPhmW0PBWP5i5BRwuYlSv2akbCR5Ta/jABHHzT3mQat5TYaXS1tVlExepXBfgpQR9YXGlZDAo1fieiDjxF6DEloB+CxynUFwYiY1DD2tWJgmhqR/syGTVvliXIiAotMEmhy2KmygR0WcI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/w49IMVGk3JbxRWISkJAbSZ59CLQl0lJEn2YUbK2iw=;
 b=p2M8W4/qOop+QMFNzjnGR0PRE8hJCWT4ODFNrT8tZzfrlNZ4Zlk0pWk05mtVy3BilSyyEOxmp0z27p0YmN+JLoAL/X9IcBAHNXYBpZWXXyzdJjFfCnoeLP5uDP/pvcpHN6fDhTDjmHzRRVKnzMgObfXur41OM6i/MqSgfNxqKb1/GdZmnbifJINoi96KpxexFaV1+aHv7qP/Rmkb1/jcOJ/44hX1TfX5ghUOf6aJ2hNrw02yLo/bOxa5x0VNuWBnDKcpAmrx6iswJQpoaQ3GbSo5IG7SZqFJ9pKIBk/0gkx/DT5c3A5GEPqhLPFCa8U8a2My94jpkHg7TfeuRwuK4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/w49IMVGk3JbxRWISkJAbSZ59CLQl0lJEn2YUbK2iw=;
 b=DdohzEpH+7dBfXgCHAnpyftqQTZbGYbJXt1oxcl4O9P7/yoUTWb0VkUpOZTkYRUrUd7VgVPQyaet3UpzuDH9W6zmWNljUI1I/N4gVDZoyuW1JeoYZib8ffACVBLgr5mlCy4+HxB2STMB0ZKb7e+giu0d6ORhUcm0bT/aKVZFO7NgiMNzE7PuAMBuVwgVGxj/AVcuF//qTtMklXY2CVX3S4gc9ycMUPqmIpjeDJ2CFDScgm2MfvaliACF0SAAFs5HHsRF6pS8XTOslzW4m5I/VEo525CXZdmUgc1NEzCQSx88Su/pc88WWhDI2FbE1U34dscX5FapGIZnaM4qkFdoKg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MW4PR12MB6708.namprd12.prod.outlook.com (2603:10b6:303:1ed::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.34; Wed, 3 Sep
 2025 01:19:58 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 01:19:58 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [v4 07/15] mm/memory/fault: add THP fault handling for zone device private pages
Date: Wed,  3 Sep 2025 11:18:52 +1000
Message-ID: <20250903011900.3657435-8-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903011900.3657435-1-balbirs@nvidia.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::22) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MW4PR12MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: d2de29df-8e39-40f8-471f-08ddea87ff15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUZFVEthMVBMSDZaVko3dFgvdDFaSlJWcExnUzZnbFIrazRCcmtqZ3RVWTE5?=
 =?utf-8?B?eDFIWGhGcXZ0UzBJei9zU1ErWmJGOVRkTzlNTktzOVpuNENwOGpWR0dHUnJl?=
 =?utf-8?B?ZkpaaWxHc051TXJPM1lubHNWTFN6MUxTcnU1NmhMbmx3WTZYZFB4S2R1MGNL?=
 =?utf-8?B?TkdNbng1MWJWWVdTNDZHZ3JVd2txU0wrRmxSbHVnWGpTbEdnYnM5YTdpYUVW?=
 =?utf-8?B?VDNlTHBVaWhlbWFCcElKUEZFenVYeTdhbWZKbmZBYzZ4aitRbDIxNjNrNWZY?=
 =?utf-8?B?WjdJMlpBNmZvVXJ3d1JxbGh5QVNiNXJvUVBXZm91QWNCUUxYVXl4cHIrV0ha?=
 =?utf-8?B?eGl4L1huYnp5djdya3Fhai9USzUzcFliMzdFdUNBWUN2c3ZXNTNVeHNvVll1?=
 =?utf-8?B?dU5YYk9taDNDcU4zNXcrbXJJWnFWTmJUcUkxM1J3bjhTcFZBSkRFcXJPRUJk?=
 =?utf-8?B?Z0IvRzRqVS94ZEdZMTJHVnlrUGtldzk3UUpHUFlTYTR5b21EUXdKUHdUQm9B?=
 =?utf-8?B?TjFZOXp4TExBYVlZanpVNmJ4UnB3QksxNmFNZkc5ZndweVM3OHlVVXIraVVo?=
 =?utf-8?B?VGRGelM2ZHN1d0t3M1d3RWRQaGJnTU16eGtnUUhURk1ZYzBOemNKaFlxa1RE?=
 =?utf-8?B?RXVVRWV3cXVXRmdmb3dsWVU1U3M2cy9NMzFsWldxMzZZQWJGNVlwdXpZbHRo?=
 =?utf-8?B?VytmK2JDelEzRmxFOGdjZzJIRDE3dHFHUFluRHc0clJtQjdGSGJSRTV3bTRh?=
 =?utf-8?B?dUE0WHJSY1pIbFZlTTAzRnVQRkQwNks4VU1vL1J4Vk40MzFMdmMrTHZyWDhD?=
 =?utf-8?B?cVVYdjBuZUVFOWpCbTVvS3QxV0Z5MTQ0aGVuQXI0OWNQRnVMcTRpZk5PU2x6?=
 =?utf-8?B?RVVjMWMweHc2OVBqRWU5dDhhdWtXblE3M3pHT09JN053RDlzMnl2UmxzNVhn?=
 =?utf-8?B?SjFDZjROSk8yVElUN0RyN1VXK3Y1WFdaekJFWjA0K21pNjZPQ2J5S0h5d3E0?=
 =?utf-8?B?N0RQQU14MHY2MG52bkVMSUV0KzlhV3d6dmIrVVFHZzlVdXFPL3JYNjJTSnFH?=
 =?utf-8?B?VzZlSGUzRGlzNE12NXlQdm0xVmh5b2JDUlp1ZDhhVmx5SFpWWm50RmM3amFO?=
 =?utf-8?B?Wm9UVDRYOThRcVZLbHJJTTRnWUFLOUw4VGxaeEx6VlgyOVhMTTdSWnhRdng2?=
 =?utf-8?B?WlJrOGxydE5WdXFsOEwwT044cTdRSElaTjNTemJpTVp5MVdsQ1B3TytmVE9T?=
 =?utf-8?B?V2V0T1pKUFBuckZEdngvY09MYlNFMHpIK1pVVGZCYmkvV3QyRHFlK1RhOWRv?=
 =?utf-8?B?c2dhVnlZeGtRVW9QMFhrYTBwT01XcmlKaFFlOVRHNWpYNTVTcU9HcG5Kc0lW?=
 =?utf-8?B?UGRQQzBaVzlxaUtNWVpsYzgwMk1RRVN6RGR0TW1uaUhuL0k1ODdrcVZTWERH?=
 =?utf-8?B?QmhMcEVCYXhQOGhleDI1YUNOZyt0VGd5MmFONGNINVNkK3ROQkRKWUdkYmtT?=
 =?utf-8?B?eUJ2blk2K2p4WjlTVEN0RmJvZTdrZWNqVHRmTTlGclhVQnNlWEFQUjl3VVhT?=
 =?utf-8?B?RytVT3dKTTd6d3plVzFzS2tPUUw4SjhFZ2VGc3V2OVlGMXdRZnFuMTBqbVFj?=
 =?utf-8?B?OHppVDdmOGFIS3Nvelo4V2R4VlVMNU53V0pKY0dJWkhZQUxQM3dkNW9CUzAy?=
 =?utf-8?B?VDRnREsyb25rZXBaTVlvdkFEdVJzNGVPN0NYcWkvL2tSZjhzZU92RGRHYkZv?=
 =?utf-8?B?T01rdElRR1pzSHJkWThOSm5sZlJZRkdncTJERjNQMmltR1BMS0JydFZNSlVo?=
 =?utf-8?B?cGVQWDZrdUY0ODRiRVFSMHU4UWFCeXdNeS9pdDVBd094TE9oZjg4aXVBK3NC?=
 =?utf-8?B?L1Fid1dUWlM3Ky9SRDdtdFNYZ3Y0MmJVVjhtYy9ESnE0ZW03RlFDMTM1VmlU?=
 =?utf-8?Q?7ZJ4++tl9EA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d09NM2tRRmhncksxM1VpZnMyODVTZzBIQVNDaXdYZit4WGJCVUlMVWowbnE1?=
 =?utf-8?B?ejg3RzNyeWhZZmF5L2MvNzJMQUMvc1VsUnErRXZqN0d2bzEvanh2YVhGa1p3?=
 =?utf-8?B?ZmdLUVMrR3MvanBHa2tQV2xCMTNmclRNSXdvdzlGRjJMTDBKRnVTTk9rWUV2?=
 =?utf-8?B?Yi9HT0V3MGxrVldTVmVsSUNKcVEwZGhHajVkUFczZDNTWFg4L3dyNEJXNzg3?=
 =?utf-8?B?UXRSbE9rdFdiNTl5SlJ3RG40NnlYVVBXQ3Fpam8veDhzNm5rMkVkbTR2RGtq?=
 =?utf-8?B?V3owd0FlZkEzOHF3T0tLblBpWFVFaktuWTZadDNLaXQ5NFBYZjVCRTV1cDlT?=
 =?utf-8?B?U2VPZkQrUG44em9iQU9MQjg3L3ozdzJQTUhCZjZaK1FBTmFzMGxmMnd0Z0Vm?=
 =?utf-8?B?SEY2TGUxTlkveGoyQlhHS3h2QkF5RytTNS9IQjBxR0UyUWE3cXpodGcxRVRF?=
 =?utf-8?B?a1dyQmRtaUp6VnZUSGkyQ2hMWVRIZExTNTRmd29ML0N2eVY0ekdGVFhQUXpq?=
 =?utf-8?B?RjlhSUI2amU0amJYR1hRa0d5aDhqSE1iVFRWRUNOdWhoUVZ4Y0ljVDRYMGRR?=
 =?utf-8?B?Nit1Sktvb2wxZjU5YXhqNXIzeUpVZlcxSm1LeUVtd0lZeHBQNjV6dHFzazY0?=
 =?utf-8?B?ZGRFWHJxcC8wMnc2cmNzZ1lTRDRZbHJaR2tpbFRmTDM1OThJcE1IR2RxS2JE?=
 =?utf-8?B?bTlXTElrME5BQVhiRlJIVnlrY2sxSElYekRnQm5kSDFCaE1sdzVaTTVWclFY?=
 =?utf-8?B?cCt5aVY4dUxuUXZxcEIwSGFteEttZnpYRlFCOUl4RFJtYW1raUN3WGVNTEg3?=
 =?utf-8?B?dHZldlJqVTNUUE1tbkJvazUvdHVydW1kK2dhWml1S3RmblJtOVI0dFI3RnFR?=
 =?utf-8?B?WHNSdEI0WlRNSUc0LzNKVlMzUjRyaDlsRzhDWnprZC9MQnRGb2ZPNm1VQnJS?=
 =?utf-8?B?VmlyM3pSTVJFZHZlWG9yaHF0Q2dObktOdkxHNVcyVlFaRXFNcFFHaVYxc1dR?=
 =?utf-8?B?WVZzSTFEbFBqS1Q0bFhIajBSWjdkcVI4VFdiREtIMVFlMEJhUWZmQisyeWV4?=
 =?utf-8?B?Q1JzRmthcDNjb0VQS0xuSTgxWDhlUXNuSTVudVk2am1VaEdZSUwwRnAwRmFT?=
 =?utf-8?B?WHVHa2E2Sk91UzFoUGRRaDRzaXRBUnZEVUhzT1lKMDhXODRNZHZYNzN6SHF0?=
 =?utf-8?B?OVFyd2JhTXkvM1k0dG1CWGxYdk5aMWJQSDhtVDRYMGVscXc1SVJ5S21KNUJj?=
 =?utf-8?B?ZWVNREhHZm82RVJCNytjQWlvQ1M3cnJ4Q2hlcjZOSUhXN1VQbWxuUi9RUmFS?=
 =?utf-8?B?SW5SSGZJTUdneStaOVhYaGZnSGIrMnNrRVI4WG5nb29yV1NPYmlRdXZDNGtZ?=
 =?utf-8?B?RWlwYUVha24yVjFLSDR1TkJyclhLODE1VlRjWm5qWk9uWnJFcFAreFdRclNp?=
 =?utf-8?B?REZ4NjZqeFQ4OERmM1JJZE5lWlJiaVJEdVRTY3NCeDBTWFVnejFNbC9TVkdh?=
 =?utf-8?B?RVcrRzM1K3FlVXVPR0xHdXN0YmI3SmtIRVYyajMyWEk0ZWtidWZjZkVLRVpa?=
 =?utf-8?B?eEpQUW9ranh1SWJqOFJack4xd0hHbVpUTm43cEs0VzEvVHpUV1ZFdkw0end2?=
 =?utf-8?B?T0NRbEVOWVBLN2xiclRkMnN2UjRTMjhDR3pFRlRCWS9uUzB0d2cwUlh6ZzNz?=
 =?utf-8?B?a1pBQVR3NmdSdCtpZCtmZzl6eGFoZWRXNjk4NVhEQUQrejNCMHF6cFdtTGIy?=
 =?utf-8?B?OTlqbmV4NUdRS0RFM0hWSit0bnNYQWNvbVJXQmwwQmp3ZFRFMEVyaVpDT0Ex?=
 =?utf-8?B?Ym5xYmJocEFxUGJFaFE1eWxNSlFhcFBIb3FycktWYWh1OGNHNjFZcmNaL21o?=
 =?utf-8?B?dFhESHNCdmtKTHRjbllmTG5hMWFFajlRVXZhQ1dodVpSanJCUGRyMzFnM2hq?=
 =?utf-8?B?cmJUanJxODBaU2tmUnlOZndVc0FpdDc4WG15TWJnSTg0QkhTU2srUUNjMlJT?=
 =?utf-8?B?eC84QmR1bmplQllYdzRpWjYwbnZ4Z3F5VE10WEdMNlhwOWdIWjlLWVJHTHpz?=
 =?utf-8?B?U2wxdklraWNkd1VLbU1DakNIWit0MHZiMzBqNVRJdFZ2MzA2RjlQWWZ1SFk5?=
 =?utf-8?Q?zF3y1cL9vFmCPs5ut91e27N2O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2de29df-8e39-40f8-471f-08ddea87ff15
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 01:19:57.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mh6tZB20RFioCm/58GNGKyVdNGzcxZZiUKX9NOtuKVngFSlcQ3Zs7to5kjEylfmhwCGRaKEMEN6wkDgDdguXtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6708
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 87D9AA0002
X-Stat-Signature: aiooucoyc84pkho6awqyi8dcsjjuucog
X-HE-Tag: 1756862402-245674
X-HE-Meta: U2FsdGVkX1+ij68tAnikcoINgdK1AlU/RSjHW2F4dNQuKkxeFcLoJbmoGvSikK87zsfRz99RSMP33z0o5frpgWeCX1lgsLhbs/yqx/soCCVNgPorMqW65zNdXKI8LeqB02vVEMuDlkz5QU1bCu0cDkkVGMHT4LoFcQx1YfmKUpmPo9lqVTOPNhxua0fbds5QNQ0/R9A9XR0tg+J0WQkwFw1kA5DyesNqMEf2D+blvljEM4oDxawt/y7l7PoNj1wNNb+CE+0d/aZkaliNBrDdxKlfxKAMb7/v29fPQWCa7tU6KfZO1M8gRzzxxl/cbvT+9Z3bSnzn6Hx5Fdn9Ne837ErIwHNGw2IPruhyiY72/SNNo2jjrbn5QwRVpULESa1di20EUdzmVpTl7qLLltXZ168LBGAs53ZahkxuCw9PBz65/kdmxq1oK/DFpO5SDNi9Uqp4wYQCwfLEL8Fll5kk9NTNLfrXBpQBUoou7e61lo/7c9Y1M7ezV/o1OuJHO708bW+D+0jKObzIrCLAn+xHSvwGksJFJYAgyNnD8+JT0TLN9fz26AkraNAknPOvr7c36WLva0lxPzxyr9EWB4dObOiM2hXci69lUBnB5m6H7rYbRzrPMvkRRujZb0boQOPGzhKGz5PEApi6HyyGzUL4iYrkj0fhs6ve0W7RDzkz54XwgeOb/XP8loeGpAzN+mACS4NFxl8BvEGfMkHpGXxvNI4mvN+X5+VspR06kG/XYXgC7MbIahAfcvvYNeQWMjUHzuVG5gWPOEv2J5cCCNL9tp0Gmx994YfD8VMXFZYYbHbBqkX0xaAvGne7SH5dXaMzN6KB1FxvqO4wIU0CMLcmVqAZDsmc4ILNFv7pe9R6tQmRBpI/+begE6fiLVAePf7ZlCqi/Rk5GYRj1e7WmVVue9alDoo/HOvM15sfWACpQ9sDSXjOCCTi9P78T1ecK5YzTzJ8pGswqa94V/LDfIC
 BCif7pSn
 cMOLXn5cQA6cqgy1TY3k474giPlGWCitmhBxFhG+6vpdaSx2vkZ7UEeVGtBCZr1nqHTqRZnpF0b+ggJrUisIvQpQ57Ts/+QlDTIZLFoyrAku6eNy0nqQaOD3aggRUaOC5LEqF2vBZDMWHCDLQiwfB+746QIWPODwuYkYrybn0HKmp2+sApD6ny9s0q0FOUrokEj3CaN/Z6xbA6rkCy0T5Ao1GstdrkASGK44bS1u1uURWlh8F3Dpnl7dDjYrGKZKVy8CIluALjn4FGWQHhMicvgfJDD4BC4DJBtT4/HP22Y4h7dxhXuTxdGs3WDKFBs+dTaqvg6T3ACqidDYUa8KR5SE6RHsMiTIrd1cEYwK7pVeeFl/SPeFFTopL+j18SLZu49R5ggsX1Zk/YBUXY3r1sL7no7g6Jw583EbJxXGl4mfeoO9shdDM2o0YnyMh5rjQvz8rAoTzGfo1CA66aVcjhnITRMqsbEh3ayWo4VqsDFQlse2IXDjHBxL/j5k1I2ef+akd02mKwEp2Y9LPgtFUNQZix9t7HGjpyAOaPp6+uDXEv18EXZyVz8jUc3JIN0Cj8D/22TnAPwkrbJf8cP/tD0uz8sQJZb1VsHYckSFzomm3f7YXs0fsdgFAo7jvDy9ft3oNozRBMnBGrhiSlANE+L0R7xm0MvuoPNqQ5kz1xMoXU2IsinjVOJL0SiT02F4LQ+DWnKsk6rc58z1grxCxkCpbU84RipusMJmdjVXTwFFyRuGHZKzqlomvlUCVQr4clIEJDjC4BwJdw7gEpZ3QNS+kV/+MXINlv8HTOyTMmwJSJyNd+quwKzvWrovOsDjfswRAkCZWkqtyEn0ejAwaBlTXZMyMuQAgsN32Q4BGWNQZXyaqKYaYceaeIy0/m3baGiRxOlolGpa07LkiU1A6vry4f1GC53VlnAlaELHar38G0tjEr8lYdS18Ka4okFGPaIKUAPSc2vljF/wPHgqjhUThZv88
 7FkqnsEL
 ajh0cYeeHcQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement CPU fault handling for zone device THP entries through
do_huge_pmd_device_private(), enabling transparent migration of
device-private large pages back to system memory on CPU access.

When the CPU accesses a zone device THP entry, the fault handler
calls the device driver's migrate_to_ram() callback to migrate
the entire large page back to system memory.

Cc: Andrew Morton <akpm@linux-foundation.org>
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

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |  7 +++++++
 mm/huge_memory.c        | 36 ++++++++++++++++++++++++++++++++++++
 mm/memory.c             |  6 ++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..a4880fe98e46 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -474,6 +474,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
+
 extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
@@ -632,6 +634,11 @@ static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	return 0;
+}
+
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 47fe07b9fee4..9adffe343de4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1267,6 +1267,42 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 
 }
 
+vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
+	spinlock_t *ptl;
+	swp_entry_t swp_entry;
+	struct page *page;
+
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
+	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd))) {
+		spin_unlock(ptl);
+		return 0;
+	}
+
+	swp_entry = pmd_to_swp_entry(vmf->orig_pmd);
+	page = pfn_swap_entry_to_page(swp_entry);
+	vmf->page = page;
+	vmf->pte = NULL;
+	if (trylock_page(vmf->page)) {
+		get_page(page);
+		spin_unlock(ptl);
+		ret = page_pgmap(page)->ops->migrate_to_ram(vmf);
+		unlock_page(vmf->page);
+		put_page(page);
+	} else {
+		spin_unlock(ptl);
+	}
+
+	return ret;
+}
+
 /*
  * always: directly stall for all thp allocations
  * defer: wake kswapd and fail if not immediately available
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..ad05a38bb232 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6170,8 +6170,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
 		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					  !is_pmd_migration_entry(vmf.orig_pmd));
+			if (is_device_private_entry(
+					pmd_to_swp_entry(vmf.orig_pmd)))
+				return do_huge_pmd_device_private(&vmf);
+
 			if (is_pmd_migration_entry(vmf.orig_pmd))
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
-- 
2.50.1


