Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9842CD98D1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E158E0003; Thu, 13 Nov 2025 20:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6338E0002; Thu, 13 Nov 2025 20:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF8C8E0003; Thu, 13 Nov 2025 20:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC2FF8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:22:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84E2A160202
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:42 +0000 (UTC)
X-FDA: 84107462964.25.D404436
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1E9B140009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=feyTwlZM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.21 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763083359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Los++RRRujPvNxcD/CfUBXihaIyoymGZICgfg3fKSas=;
	b=4y4poYR0xgZrg0DdDmqMFwjVODKXlRCBE6M36rVrhEYRnjEjkKUr2By95B6/XGce5QAcna
	JA0G1DryRx2GieVKqI9ydNBdb5oBLirMzjk/RhquplVaHT9aqrdIZPZMZ+JipAgVnHkPA/
	lqmJvuvSHvx8mlmiJNvUy2sfO50QfgI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763083359; a=rsa-sha256;
	cv=pass;
	b=zKMeMKHaKFDo90Y8Zt+bRq7M8NaxzxfIG8S+RbAGZNEfCyBQYkqh4JC3ZdcpXWM98VY1uz
	YgfYXhuHHR9ZJ7E4mQCsMpR0Agr3lfIhKwiOg1wBC20QFd1QwfEs3Gy/mJL+O+oJc7+P3Q
	C0SyVoLv5/BsHGw61I0H9Ywb0mwHkKc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=feyTwlZM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.21 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pe05IdgtnxHSH+rHEmZu5feyovTCdBHZQ3AVOV95JgHKvZ6y64ZUFvS0OnUmty/SS5943liQYg9w8wwk41aQrJsiFP0EZk8msf0TDyN7UHWydszicFuCMOXqUOYdvPzJYlo0Xd2EYB9qhADC10Nt59AYFvnaie90l/jtJdMYH3M1qlXRvN20BzIVMCpdBuBAkiRMdFxpquY7BN6sngyL7mCCQ2ErXqRXy9rKlmzHaklCZafP4lj2z6JgXGhBFvB4nxvY3FGxlsldAnGkeDAUo44a7VHrCby2EYTffQZbd5qY1rmUtF82yi2Z/te/fNiNMCX2xa7/VLmyof1CiwhFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Los++RRRujPvNxcD/CfUBXihaIyoymGZICgfg3fKSas=;
 b=f/NrVn4CFjdFamrvnetjC6sqRvjjenvIAFvUlk5QG6Z9SnBtGnVVjaVwxQTyTKoJMPNn9xi0o8POSzHfnjYawGJ3OFLSfIlGrQYyGFL8+hiZbbQzfR52tMowld5PBxHdoQuEIqEBCZSWYX93ERBZyuq1D18zvhdtEnM4ww/RI+pj+IqfzwX/mcb4o2bCghl3dUp3Y+nu9bo1KuvXL0/Q84sqcr4b3lLcPCJjZmcpIqRcX9ozsvmWbcV2R3dE4bYm+BCmmeV7zRzaAPFyPfhL12avSACkoh22bEOVHBW5JAN1x72pQryfQGu2LLfEA2qVxuPlRaKh+RtV3m33pmAsfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Los++RRRujPvNxcD/CfUBXihaIyoymGZICgfg3fKSas=;
 b=feyTwlZMuKy3HGWQJl0sIqm93gVAFU4PJTCsOpfbbsiErsHDCvGy+iPLfkuGVT/GaY+v0xsSk3vGbejeKdQS98yCT+X5l9hgTkIrYACwomMbwwvrH6EdNy0lEfALhoypW+TKYuNWVJtJrGKE+HtnGvXw/ESQHxmeIe8J86OmVRAGdaczoVisgVIghKimD6f6n73TiBO2E8z1fxqNATY3EGYnrD+ju02r2FTSe3JDTrTf8HYbQ14GbTNGXERck18YJjAzJjjXVt9gZ0nxWz+5mfYDUTxXRPPkjEcC9OW64ENfLiPER4ykCjLtiGu++DxrjJTX6tr6skdc3n1Xf9Hfuw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:22:32 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 01:22:32 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org
Cc: Balbir Singh <balbirs@nvidia.com>,
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
Subject: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Date: Fri, 14 Nov 2025 12:22:28 +1100
Message-ID: <20251114012228.2634882-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY1P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 86091080-9ec4-4faf-cfa1-08de231c48f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHIyTTMyeGRBMDkyekJBUFI3S3d1cDN5SmxBdDc5b0RhUXZzcWhzZU5vNFhi?=
 =?utf-8?B?dFEzM2tCRElzSUs1d0pBZTFxSVYrT2VZUnpJcDVXSjdvdXgzVFhQczhFcDZE?=
 =?utf-8?B?RnRQdThkZFRVL2JSZUhPdjRBOEVyczFFdWZiS21BZUQwcE9URzA0emtNMFhk?=
 =?utf-8?B?cnZLWXQyZzVkUXY5RFBQUXFOaloyaWllcFozcUpJcmxsL2V2MGdkUzcxNXdC?=
 =?utf-8?B?M2lXLzdPYWEzYnk4eDhwU3VZK1YxRkZqSEpSQ1JaNVowQ2JZR0dSWUZGdUcx?=
 =?utf-8?B?dFV0V0ttSnFOd3J0N2pnNklsMjdKeWFwRnc4ZlFqN09jeU1yUjAzbTFxNisv?=
 =?utf-8?B?WnpXZHZvWTFCVHhyMElLQU5PbC96R2NmMXRBVC9nU2lpU0JWRmtGT002bUdS?=
 =?utf-8?B?aFRXa2JuY1hWWmhoU3J3MWw2eEsya1Zzc3F1dzR4R2Q1dHBMMEIrZWhIWEsx?=
 =?utf-8?B?ZXc4a3JHbWQyOWNTeDlqa08vZmdjUE5zVWF1ZDgrUXFrT1p2Z0hubzVlVnR1?=
 =?utf-8?B?eWJhM2FvRnhCa1VpQW9OLytjeWdrMVJQQllPc0R1dXpkaVhPbGY1T2V2Q0Nr?=
 =?utf-8?B?TWpoNkI5L3lVa255VWtMMmY0R3FGRmc4MTFnOE5LMFdqQlR1eHdKV1RpRE1D?=
 =?utf-8?B?UHNXaEUzKzg4dGhDb2UxUmhOcHMzQ0VLZG1MNStqaGZrUE84SU13WDhaTUNy?=
 =?utf-8?B?dE9PSUMyY21QMXpjOWlFTTRraCs2T1BjUk1OWDRoaGRpL2lHdmo0R3JZSGwx?=
 =?utf-8?B?eHM1SHhLejc3bGxDTGl1Z2g2dXFpVE55V1l6VnIwaUNLbEkyaHlEbDM0QlEv?=
 =?utf-8?B?dGYyQnpHQmQ4MVNmWU1pOVhaUGU3bXpBR1JtNHBMMUZOUTdCRkY0bHd3U05p?=
 =?utf-8?B?bFJreDVjZWtaTFVCM3h3bnhEVzgvUzJ6eE5RbkgyTXFHWmhaRTQvZUxaOXRp?=
 =?utf-8?B?bzZkcDBqK3czcDh1bVpaMVBNOU9ZSDhTZVh0d2RNSkczOFJrTlo2UGNkR2xu?=
 =?utf-8?B?ZTVkSFlnQ2kzdEdMdXZJbnR4c2FYc3ZsWWdXUTU4eEVUM1VNUUNaelMzRTYy?=
 =?utf-8?B?Z2ZPeHpNT2pNd3ZkS1Q4azVkMDcxcXpRVFFCZHNycWpud1NYaDl3Z1pjRXVk?=
 =?utf-8?B?NHN1SU5aSThNQjkvYWVxcTNpZEZhWFZLU04weUhkQURKbGtITTFkTUtoS00w?=
 =?utf-8?B?NkhlUGpzSXcyL243RGZIbjRJMzZXTlQyR3U1a3QvZnpMZnpoYlFxek00UmNI?=
 =?utf-8?B?UUtxTmltYTZPeVpNbkZtbzBDeWNBLzVjQUVXSFNieDkzQk52NldrVTBSamZW?=
 =?utf-8?B?SzNlMWJ6ZldPakZGKzRjYmMvU2JBZE1SVDRGZkVhV29kYUo4eXlVUDluTVZL?=
 =?utf-8?B?N1Nyb0ZZRWliZGZteUNCUk9TT0V3bDE4WXByOXNaSjhTV091SjdvTVVpV2M2?=
 =?utf-8?B?NHNZTDVIRWpmRlJ6aS90dmdKcFlvdHM2eTRSRnNrYmlQaFcva2RhWnh2WDVr?=
 =?utf-8?B?b3FLbmo2alcydmI0aEFDVWI1TFBrU0hkN2MvOGxiWUxOcXNBb05mU0FJbm91?=
 =?utf-8?B?QzRDWU1JTHZGSXV0L01UOWZnQStRSDFnSFcyMVdwR2poZFZMK3c1VDRLcktt?=
 =?utf-8?B?ZStzN2V1ZVpCbkZEeCtJZmk4a21sT2RPT01qWlhYMnNweG04SEdYdlNST3FR?=
 =?utf-8?B?cG5pT0ladmZYQVlVeUFZSE11R0ROWE1UUEZuS1lNVWYwMjVYN2swQ2ZwNGdo?=
 =?utf-8?B?NlhRbUR2VkVPd3RYcmV5aEc3RmZKRGlYRXRLVWdMMGJpYnY4aFZ4dTVkUGpZ?=
 =?utf-8?B?NHlXN2Fpcy92Um9WRC9iMzJWMXAwVnRxNEZ4VUpGbmVEUWkrNTZxNEZvRC9u?=
 =?utf-8?B?UXByQjhZOGFSdm1xeGFnNXZwRmhaYTN4SDNnT3JaMS8wakR4cWNIL0ZkK2JF?=
 =?utf-8?Q?Th6MrdXGt2/wGEm/C3wep0lMNzbwHbN8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z245MHBqaGY2SlYvSUh6NFZ5Ly9HdzV3bWVzRjlxaG9MN1IyQ2JYblllWnBs?=
 =?utf-8?B?L08zRTQxMjlDbXF6dzluTk5oenloM3BHSE1JVTZtM0RMbUluUE5HbkQvSlND?=
 =?utf-8?B?YXIzQ0oxVzlzOU1OakZ4ekdvY20vUUVsSGNNSzBXeVozRmx0QmlibmczRmFJ?=
 =?utf-8?B?MDB6OTloWWlQRktuWjlGaTJVZ2l4emFiaVlPaHRiMUlDdnM5M2k4aEM1NERy?=
 =?utf-8?B?UWE1TWQ1SVprYU8yK0hpS3Z2Mk9WYnUra2pnU2pNWDRQT2gvd2orOEFzLzJJ?=
 =?utf-8?B?WGV0TXAwaVE4TGFkU1RLWmJDQXpMUkZxS2N4R3o1QklNTHVqSm9wVVc0cW9T?=
 =?utf-8?B?Rm5NcjdXSEVSSzA3eDNvQkNLR1laOXdGUzdkODFYeDFDZlh0QkNnWVdSRjVN?=
 =?utf-8?B?TG5kNEx0YlAxMWpBcXcxejhiSXl1Y0pUOWJySXl6SlN2eHgyL1pBaWU2RU4w?=
 =?utf-8?B?NmNVU3JNVHQ3UVFuQkVOcDg4am5ORXFHTlE2aHFWeCtrWnNWanFxS0pUK0Fm?=
 =?utf-8?B?MnI4aGF4RjU3Q1F0bzVST2JybllZRE54QkdxOVhLcVhWaUJFcVRiNFNjOWpx?=
 =?utf-8?B?Nm9iT3Vtc09nK3VqblVkNmRYNGk5U2dKYVBOTkxrSlR5N21iWE52Q015K0s5?=
 =?utf-8?B?OWJxd25BMWJjdGIwbzVQN3MzUG14N0I5aG1tNDFublZwelYxRGtubUR2ekJm?=
 =?utf-8?B?MFlxb1NyMTRWTEJLS3lCeVJFUnV6NGNST080U2liVlVUN3N2QkY2NkhXTVUz?=
 =?utf-8?B?YzBwVEVkOGF3VEY3OGZyMUxackxMajBENVpYczhGR3UrUC9YbldmbVZyZ1hX?=
 =?utf-8?B?N2xNNitWaytadnZIMmhqQkRmQlExYUNtME1naVFMc21tZ1pGS0xKa0Y2ZkJl?=
 =?utf-8?B?dlAxSFcybFQ1ZTUwREN3ajNSSEdXQnU1VWg1U0pCZXpFWjhYZlhkejJxU3B6?=
 =?utf-8?B?bWdoYVV3QlhYNWlxV3V1ditGa09zcVByWW0yUGFSMXU2NHRVNE4wL1pCSjND?=
 =?utf-8?B?SlBLQjJrVmZHb0lDc0h4RndPaTNmMkdhS2hWM290Q1lwZ2UyZFlOMWNuUkR2?=
 =?utf-8?B?WVE4eWpKeUpGbXk3NVh4REIzUUNHL1Bza3Y4OVV1YVBUV0VaRlV2U3FWdmlj?=
 =?utf-8?B?cHFlcXhZRXRweVNURDkvSnI5VldFVUc2ZzVrVzVCNWo1NGZZN1lTUlJSNUhh?=
 =?utf-8?B?aElxTlU1eDNEKzFtRUNaNXdUNDlWWElvU0J5TFg3TysrWERETDBWaDY0d2tZ?=
 =?utf-8?B?R1VSay9VRUUyV2hacXVIeTBCT3RmOHVIUnpSYnRpRmhERldnSXAxTzQ2aU9h?=
 =?utf-8?B?ODZTZUpYZ1BObEU1VE90YktBWVh4aDBXMWU5S0Q1TkVoNTlDN09YTFdjd0VX?=
 =?utf-8?B?a3NFSnNHREtoUVBZZWRET2paaER0VHl1N1VUbldBT0d3aTh5amhxT2RXTzNB?=
 =?utf-8?B?YkdmV202dlgwWHJBSXZBN3NDb0JYOHVJampuWnE0V2tMRDMycEl4WWQ5NFB2?=
 =?utf-8?B?UXNVbHhGRkZWT0pyK2ttL2M0bkIxMDlUeFBJYThORUlHQ2Q3TTNiemMreGxt?=
 =?utf-8?B?RUIwaStCSmV0YWNkM1JNWThOZU1UTXlzbWJvc1JlQ2FRZExVY3JEdU9OVzE4?=
 =?utf-8?B?bnk5SEtHQS8xM1RSWVBmcGwzQ3c5ZFNWbWFHelpRdTNYTUZIVzh3Q1J3dVV5?=
 =?utf-8?B?NVlKaGNxeEFSangrM2FBb2kyd3l4ZVJ5NS9VYXlXZkJpeFgybzJxVnVmUHIw?=
 =?utf-8?B?aTJBZjZTcTJraGpDWG5qUHkyOGRqYVVQU09FZWV2Z2U2L2RMdG5ENDVtQ3NS?=
 =?utf-8?B?NTl4Y0JxbVVUMyttZGlsaUIvbE9leXVGV2NGVGpzWE56SHNtV2hQd0ErU29x?=
 =?utf-8?B?LzB0UWhQbEg3N2l3Q3BCU0NUSWpUVTBQMElBUmszUmhvREpqNXE4T291Y01p?=
 =?utf-8?B?TUpjSC9DT3ZwQmMxaVk1eDc5eTE1M2tKYVRRcFUrMzJYdlQ1MVRmM0lWcFlY?=
 =?utf-8?B?U1loazliYzVQeE9Xd2RDUDVNKzVnN0dHbWxNc2hmRnp4UXQ5TmlweFhvZnNw?=
 =?utf-8?B?SWVlczZQVmgvYndsNmVndE42S1dpaVBiUlkyK2N1UmpDYWNaTUl0djVkVm5r?=
 =?utf-8?B?MmdnVUhKT2RGLzI5MkJqUWRLeDlNZXNKbmpQVGlqazA1bHRVSnhQWDdpRWF2?=
 =?utf-8?B?eUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86091080-9ec4-4faf-cfa1-08de231c48f8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:22:32.6216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFzsa8X3Y5kT/xKCQ3gUtbfDXJXeAq7LrklWacE+fpd0gKdCaUPXTvDh0NhCwzbnHFbauwlyW4k1VbtQGW5Jcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769
X-Stat-Signature: zexw6afewyzp3bjze73acgmug5fzwbce
X-Rspam-User: 
X-Rspamd-Queue-Id: A1E9B140009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763083359-306576
X-HE-Meta: U2FsdGVkX1+pkgGrPYQ2G6T+vUqEPfrWrr2snipdxrkjMV+HUNXHw/VlRxVXMhHSSsYO3gBi+8B74YKCRpTQw+uzIjOBxQUcP/ECyTYipK+w+8A/oPyrNa3Bs54dazVpAtMI7PiouMI/BaM9ZaIbps554NFo5R8oJl/OIrx1+MV6FNSM9eGsW8OCMkM4sIsZDCeyyeAgGfQnd4H5jWDRIgw4GVOCS/aO/un1LYIj73RYWirPDepYGCh7JYnozu0dHZy/MS+PYx2Dnwc7e1/e45WgUsM7cjs8byUY8crZhMW+h1MvB1sCczUmUuU535CB0/LkY7EpKjNWkOqJYO4guDJgVLluWLfmrlaBcCDGD8QPI2mouSM/GKnmG3ubpdS0xp96aJaOFtJ9Z3UU0wphOmS4mTLsTEuYWsGBVBjEy7ICTDOPo2i9cKTdK4pNV75nA8uL3KdNRZS1kSoFhp1OoIM4dKOCiAhjt5nNMdLKv5ay3wg7wVqSXEpn+G/ECbXfhvPvXtX/kjBlMDouYDa5yWE6tm1wmy2DooUxmyLu3Ev/5FOwWhKNblyfPysE9t+9+4VGIPDFwR4wZSbQFfzgscVTaJ4PdKCMTGogQrBTto3tRCp4set8EeO6DnYeONP4nXcPxv/RQA/JbSO9Sh1h80lTYjQPo7krR3KD/Xd7iT6p2WXcLQFdb8lQ5XPJ8Gu4NM5kjXfya19h8TQkYobNftHF564/WO3EtIfQ1ZCeuPihFiBVdei/LnX9ZQlkd6DrZ7Bh6LIUYQp/bbBA1AoVTlzovFUigHc+RpSZvilr+vbMPZ8HqKn3By76ASwHncrVWhrf4FxFzlZrwJyTF2yNHEJri3ihHdX9YUKf26oLn1+0xtMpUtRVFikqWuXShfmOnCq9iknYOu4z/x8ua4M/E13y/El1EzoWW//Jbxm43WAlQwoW0Vzjo3Sh+4BH49403j3wCKemeis5c5QmStv
 nMIzvTOG
 FYfTeyh0qE8Tetxo6TuWq9CLDmsy35Whu91vC64WdM6HVr1OJes/8rxwZKw6aIPWVxhZ6w+PsljLd0/xVmywdmzUW2zv368JGgZ5kqYP4fXI31U/t7ERqQbfC1uxF7/hjE9BOQW5SbRnJemZO+PxixVaXYhGQGB+lycodJhXUNAcX+WaLsuvFkqhdIlkzm8+xx+rw0WUKr5YWUsQvnWtPr/2tY683e7KVvuxuA1/T9IlKwLB4TrMzVxHqAGRDFNsFxFir2zUv4PyTq5z8hZg96rsNXmHmMR8g1dNCTxeY1do9ECunyLgCeCC2M/6Vykn0veqol+UE+6rDa9SSZRFEIJA3sgHQnEkY3iVe4kcqRSCqdkBGwYJ6sYDmMSLR2YligLG2enHrk4bCnpcc6WWkYzkfOttP4UtJytyPRxtczdVxqYlc44nXRcuNxtIts6OeTZc7Qkvwm8u1wzvH0E2SsDd7KbVjkuunMfukfcncPD6zC0oQHWpLns9sCdzv5TbNWUZrROWlsjQa0Sy0e8GxiEpEMnb4YzkFnZ1ZZ/s8DMPSU4mo3dDmeBGKEPpHZy7GYfl5RF4VohTC1ghMaFe1DntX3ayAVdp9Lw/5HkBcrzevudWXdDWOOnXhBvof0tRkdlbomQNdTJLt2ugafnsyY9nhQrqJi2j8KgRFBxfj/S90THekkrsPxXtZJ6xGqkqiCrM5zTPOmMhBS4q/bbZrX19nHIWpLEPGfc6dt0dnnaZSlcqVlBQCXEIlAOq8jNdwcB61dCpcBTMvV9powmcaoqoejN+8Tvur8z3gq8SIxv4U5ozVMox1RpUaRv3OCGpfGgO4l/cVX9o/eGnIHUBT+JAqpxQczE2N/CK+BVcaI3bY+t/GoYOaTWOgsKfx4gFkBOwuA8DCFTYaLa11aLoNplbe1e2l04cosTIN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unmapped was added as a parameter to __folio_split() and related
call sites to support splitting of folios already in the midst
of a migration. This special case arose for device private folio
migration since during migration there could be a disconnect between
source and destination on the folio size.

Introduce folio_split_unmapped() to handle this special case. Also
refactor code and add __folio_freeze_and_split_unmapped() helper that
is common to both __folio_split() and folio_split_unmapped().

This in turn removes the special casing introduced by the unmapped
parameter in __folio_split().

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

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |   5 +-
 mm/huge_memory.c        | 332 ++++++++++++++++++++++------------------
 mm/migrate_device.c     |   3 +-
 3 files changed, 191 insertions(+), 149 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e2e91aa1a042..1d439de1ca2c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -371,7 +371,8 @@ enum split_type {
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order, bool unmapped);
+		unsigned int new_order);
+int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool folio_split_supported(struct folio *folio, unsigned int new_order,
@@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+	return __split_huge_page_to_list_to_order(page, list, new_order);
 }
 static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e4dadcb9e90b..afc10079724c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3739,6 +3739,151 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 	return true;
 }
 
+static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
+					     struct page *split_at, struct xa_state *xas,
+					     struct address_space *mapping, bool do_lru,
+					     struct list_head *list, enum split_type split_type,
+					     pgoff_t end, int extra_pins)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio, *next;
+	int old_order = folio_order(folio);
+	int nr_shmem_dropped = 0;
+	int ret = 0;
+	struct deferred_split *ds_queue;
+
+	/* Prevent deferred_split_scan() touching ->_refcount */
+	ds_queue = folio_split_queue_lock(folio);
+	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+		struct swap_cluster_info *ci = NULL;
+		struct lruvec *lruvec;
+		int expected_refs;
+
+		if (old_order > 1) {
+			if (!list_empty(&folio->_deferred_list)) {
+				ds_queue->split_queue_len--;
+				/*
+				 * Reinitialize page_deferred_list after removing the
+				 * page from the split_queue, otherwise a subsequent
+				 * split will see list corruption when checking the
+				 * page_deferred_list.
+				 */
+				list_del_init(&folio->_deferred_list);
+			}
+			if (folio_test_partially_mapped(folio)) {
+				folio_clear_partially_mapped(folio);
+				mod_mthp_stat(old_order,
+					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+			}
+		}
+		split_queue_unlock(ds_queue);
+		if (mapping) {
+			int nr = folio_nr_pages(folio);
+
+			if (folio_test_pmd_mappable(folio) &&
+			    new_order < HPAGE_PMD_ORDER) {
+				if (folio_test_swapbacked(folio)) {
+					__lruvec_stat_mod_folio(folio,
+							NR_SHMEM_THPS, -nr);
+				} else {
+					__lruvec_stat_mod_folio(folio,
+							NR_FILE_THPS, -nr);
+					filemap_nr_thps_dec(mapping);
+				}
+			}
+		}
+
+		if (folio_test_swapcache(folio)) {
+			if (mapping) {
+				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
+				return -EINVAL;
+			}
+
+			ci = swap_cluster_get_and_lock(folio);
+		}
+
+		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+		if (do_lru)
+			lruvec = folio_lruvec_lock(folio);
+
+		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+					     mapping, split_type);
+
+		/*
+		 * Unfreeze after-split folios and put them back to the right
+		 * list. @folio should be kept frozon until page cache
+		 * entries are updated with all the other after-split folios
+		 * to prevent others seeing stale page cache entries.
+		 * As a result, new_folio starts from the next folio of
+		 * @folio.
+		 */
+		for (new_folio = folio_next(folio); new_folio != end_folio;
+		     new_folio = next) {
+			unsigned long nr_pages = folio_nr_pages(new_folio);
+
+			next = folio_next(new_folio);
+
+			zone_device_private_split_cb(folio, new_folio);
+
+			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			folio_ref_unfreeze(new_folio, expected_refs);
+
+			if (do_lru)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
+
+			/*
+			 * Anonymous folio with swap cache.
+			 * NOTE: shmem in swap cache is not supported yet.
+			 */
+			if (ci) {
+				__swap_cache_replace_folio(ci, folio, new_folio);
+				continue;
+			}
+
+			/* Anonymous folio without swap cache */
+			if (!mapping)
+				continue;
+
+			/* Add the new folio to the page cache. */
+			if (new_folio->index < end) {
+				__xa_store(&mapping->i_pages, new_folio->index,
+					   new_folio, 0);
+				continue;
+			}
+
+			/* Drop folio beyond EOF: ->index >= end */
+			if (shmem_mapping(mapping))
+				nr_shmem_dropped += nr_pages;
+			else if (folio_test_clear_dirty(new_folio))
+				folio_account_cleaned(
+					new_folio, inode_to_wb(mapping->host));
+			__filemap_remove_folio(new_folio, NULL);
+			folio_put_refs(new_folio, nr_pages);
+		}
+
+		zone_device_private_split_cb(folio, NULL);
+		/*
+		 * Unfreeze @folio only after all page cache entries, which
+		 * used to point to it, have been updated with new folios.
+		 * Otherwise, a parallel folio_try_get() can grab @folio
+		 * and its caller can see stale page cache entries.
+		 */
+		expected_refs = folio_expected_ref_count(folio) + 1;
+		folio_ref_unfreeze(folio, expected_refs);
+
+		if (do_lru)
+			unlock_page_lruvec(lruvec);
+
+		if (ci)
+			swap_cluster_unlock(ci);
+	} else {
+		split_queue_unlock(ds_queue);
+		return -EAGAIN;
+	}
+
+	return ret;
+}
+
 /**
  * __folio_split() - split a folio at @split_at to a @new_order folio
  * @folio: folio to split
@@ -3747,7 +3892,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
- * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3763,9 +3907,8 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, enum split_type split_type, bool unmapped)
+		struct list_head *list, enum split_type split_type)
 {
-	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3809,14 +3952,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		if (!unmapped) {
-			anon_vma = folio_get_anon_vma(folio);
-			if (!anon_vma) {
-				ret = -EBUSY;
-				goto out;
-			}
-			anon_vma_lock_write(anon_vma);
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma) {
+			ret = -EBUSY;
+			goto out;
 		}
+		anon_vma_lock_write(anon_vma);
 		mapping = NULL;
 	} else {
 		unsigned int min_order;
@@ -3882,8 +4023,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	if (!unmapped)
-		unmap_folio(folio);
+	unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3900,142 +4040,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		}
 	}
 
-	/* Prevent deferred_split_scan() touching ->_refcount */
-	ds_queue = folio_split_queue_lock(folio);
-	if (folio_ref_freeze(folio, 1 + extra_pins)) {
-		struct swap_cluster_info *ci = NULL;
-		struct lruvec *lruvec;
-		int expected_refs;
-
-		if (old_order > 1) {
-			if (!list_empty(&folio->_deferred_list)) {
-				ds_queue->split_queue_len--;
-				/*
-				 * Reinitialize page_deferred_list after removing the
-				 * page from the split_queue, otherwise a subsequent
-				 * split will see list corruption when checking the
-				 * page_deferred_list.
-				 */
-				list_del_init(&folio->_deferred_list);
-			}
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(old_order,
-					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-		}
-		split_queue_unlock(ds_queue);
-		if (mapping) {
-			int nr = folio_nr_pages(folio);
-
-			if (folio_test_pmd_mappable(folio) &&
-			    new_order < HPAGE_PMD_ORDER) {
-				if (folio_test_swapbacked(folio)) {
-					__lruvec_stat_mod_folio(folio,
-							NR_SHMEM_THPS, -nr);
-				} else {
-					__lruvec_stat_mod_folio(folio,
-							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
-				}
-			}
-		}
-
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				ret = -EINVAL;
-				goto fail;
-			}
-
-			ci = swap_cluster_get_and_lock(folio);
-		}
-
-		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		lruvec = folio_lruvec_lock(folio);
-
-		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
-					     mapping, split_type);
-
-		/*
-		 * Unfreeze after-split folios and put them back to the right
-		 * list. @folio should be kept frozon until page cache
-		 * entries are updated with all the other after-split folios
-		 * to prevent others seeing stale page cache entries.
-		 * As a result, new_folio starts from the next folio of
-		 * @folio.
-		 */
-		for (new_folio = folio_next(folio); new_folio != end_folio;
-		     new_folio = next) {
-			unsigned long nr_pages = folio_nr_pages(new_folio);
-
-			next = folio_next(new_folio);
-
-			zone_device_private_split_cb(folio, new_folio);
-
-			expected_refs = folio_expected_ref_count(new_folio) + 1;
-			folio_ref_unfreeze(new_folio, expected_refs);
-
-			if (!unmapped)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
-
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
-			if (ci) {
-				__swap_cache_replace_folio(ci, folio, new_folio);
-				continue;
-			}
-
-			/* Anonymous folio without swap cache */
-			if (!mapping)
-				continue;
-
-			/* Add the new folio to the page cache. */
-			if (new_folio->index < end) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-				continue;
-			}
-
-			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping))
-				nr_shmem_dropped += nr_pages;
-			else if (folio_test_clear_dirty(new_folio))
-				folio_account_cleaned(
-					new_folio, inode_to_wb(mapping->host));
-			__filemap_remove_folio(new_folio, NULL);
-			folio_put_refs(new_folio, nr_pages);
-		}
-
-		zone_device_private_split_cb(folio, NULL);
-		/*
-		 * Unfreeze @folio only after all page cache entries, which
-		 * used to point to it, have been updated with new folios.
-		 * Otherwise, a parallel folio_try_get() can grab @folio
-		 * and its caller can see stale page cache entries.
-		 */
-		expected_refs = folio_expected_ref_count(folio) + 1;
-		folio_ref_unfreeze(folio, expected_refs);
-
-		unlock_page_lruvec(lruvec);
-
-		if (ci)
-			swap_cluster_unlock(ci);
-	} else {
-		split_queue_unlock(ds_queue);
-		ret = -EAGAIN;
-	}
+	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
+						true, list, split_type, end, extra_pins);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
 
 	local_irq_enable();
 
-	if (unmapped)
-		return ret;
-
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4079,6 +4091,36 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	return ret;
 }
 
+/*
+ * This function is a helper for splitting folios that have already been unmapped.
+ * The use case is that the device or the CPU can refuse to migrate THP pages in
+ * the middle of migration, due to allocation issues on either side
+ *
+ * The high level code is copied from __folio_split, since the pages are anonymous
+ * and are already isolated from the LRU, the code has been simplified to not
+ * burden __folio_split with unmapped sprinkled into the code.
+ *
+ * None of the split folios are unlocked
+ */
+int folio_split_unmapped(struct folio *folio, unsigned int new_order)
+{
+	int extra_pins, ret = 0;
+
+	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
+
+	if (!can_split_folio(folio, 1, &extra_pins))
+		return -EAGAIN;
+
+	local_irq_disable();
+	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
+						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
+						0, extra_pins);
+	local_irq_enable();
+	return ret;
+}
+
 /*
  * This function splits a large folio into smaller folios of order @new_order.
  * @page can point to any page of the large folio to split. The split operation
@@ -4127,12 +4169,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order, bool unmapped)
+				     unsigned int new_order)
 {
 	struct folio *folio = page_folio(page);
 
 	return __folio_split(folio, new_order, &folio->page, page, list,
-			     SPLIT_TYPE_UNIFORM, unmapped);
+			     SPLIT_TYPE_UNIFORM);
 }
 
 /**
@@ -4163,7 +4205,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			     SPLIT_TYPE_NON_UNIFORM, false);
+			     SPLIT_TYPE_NON_UNIFORM);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c50abbd32f21..723ef42550dc 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -918,8 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
-	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
-							0, true);
+	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
 	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
-- 
2.51.1


