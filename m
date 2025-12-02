Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF93D1267A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 22:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C606B000E; Tue,  2 Dec 2025 17:40:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD6E6B0010; Tue,  2 Dec 2025 17:40:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA58D6B0011; Tue,  2 Dec 2025 17:40:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C24986B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:40:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57DC058963
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:40:24 +0000 (UTC)
X-FDA: 84176001168.09.9D469EA
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 631EC160003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:40:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="T/wdydFt";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.2 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764715221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5pPWCakI3AYQNPvASEOrToodYNjBOxnDOr8huKd3NQ=;
	b=qYtwNd2ZRanhZAzHGEtrbs1MMDkwz0TkwCXV66mzMrCsWYJSNME0SplNrg78isyMpDKPUl
	QckWbBKO7PyL/Plc7oE2uKYBTvcYDuZUuSXjypxYs+TKtgFycg162Wq84BI/6O9PwxCgl2
	M4rtcd8gMUP2svrEIciItfRXEHXWlkA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764715221; a=rsa-sha256;
	cv=pass;
	b=XfVDwyefOnQpqjuZwSntQKf+EJtHtUvBvR79g1TOfVrZ5AstMgGV7eXfD9O515GUnG6Hlc
	6VND21VR62UBcGSA1VAytkqFZqOpTVBRh9/Zc/oN5Ce9KOECnOJQiPpNj5JUlk73XD/pQc
	DPPlJznnkmUCvIDpKWxoyo39c33tLzQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="T/wdydFt";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.2 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfMyHDBg8J5Vuwa8LQ5fPmH7gQOGjhG2FBikWT5LRY4MWLRDtfiOgVnnITsveE6ZDeEqPa9TffxIp37M/hk1FZgFX61DFadkRWMUKz01n321khhc7sn2O8OhEktXBXZ9fzkHSaL+mdYjb7ccBBIUrMTREEzZAgAfrqz1o4jhGdRTgLFBUUlEj0jTYdALCh1Ykx00R9XUxF8S+AStPmTCGDVJ/Mmmlu6nA5xAR3w2JyEfr2txfqajxCxPTs+9MZ8yOw4twvg91X5AWBlQrGrU22nPjVGDoWPHVA9FKYKjiXeyGOb1GxRDhrNXCscaIdxtVpd863qQ0TAHRsuorUmrmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5pPWCakI3AYQNPvASEOrToodYNjBOxnDOr8huKd3NQ=;
 b=l+GQEWhswtt/SQtQ4Uqnu9C4uwK7RsB+1KOsjTzA6f6+CcbrnEr33SLeAMo1hJWepkQ9xDkr4idCV5tbs9HTGeztAMj7UYyoIm0D/44RNOzQjIVOylDcxob2NV6juJfjvfTTzB++xYzBy6rwih8n4uGrMUvkwHYU3W4THaThc069aBeFazCjf6betI3a8VuxNda5LI/thy8XpI68Zu8trtGRQ88KhKQpGflkFh+hd9pmLF5oqh/U6bCtDPr2NpUptWgZ58u48HelOjlwn7CGLb2F2JHUJzoyRXw+tG4ayDpH6UuNWcWoDctFTMOjFjjHEsTYPFyd+dfaq5moBjddZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5pPWCakI3AYQNPvASEOrToodYNjBOxnDOr8huKd3NQ=;
 b=T/wdydFtZh3N4bIyArwVcO9X9MWDZfnStev3stC+gcZyYXYDkzc7K3LarGI+B767bWvdrv7owc0BzabewTh6kAfjO7nt9p5aUt5NgIKVr8dPNJ7KWTQaNnMJtwAkeCctshBkdJxOL5RZNtqyFSGfUDrZNxiylcFSOdsoUCHnQFbQHWv2XERtEIoZkleBvuJBGPkOvrmbtVpViemWDvwovAgIdPB7ivg0MJHMc5xomso2i3cJaaMBRRTgQEVTKuEmu0t1z3ZD+7TY/Q6OEKJxgehtd/f+Nmx1WCasirzv1iDSzqIC1F22WUGXaR9r4iYYGrBE4eIER2v06NH33kaxow==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB8787.namprd12.prod.outlook.com (2603:10b6:8:14e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 22:40:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 22:40:16 +0000
Message-ID: <daf462c5-83c2-4e85-ae7b-490d5aeb42ff@nvidia.com>
Date: Wed, 3 Dec 2025 09:40:11 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch/x86: memory_hotplug, do not bump up max_pfn for
 device private pages
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Ingo Molnar <mingo@kernel.org>, Kees Cook <kees@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>,
 Alex Deucher <alexander.deucher@amd.com>, Bert Karwatzki <spasswolf@web.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, gourry@gourry.net, linux-mm@kvack.org
References: <20250401000752.249348-1-balbirs@nvidia.com>
 <692e1297e3b6_261c110064@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <692e1297e3b6_261c110064@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB8787:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c51eda2-5373-4bc5-3d90-08de31f3c3fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|10070799003|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YU1GMjM0bTVTWUxSaHlLakpBVDB0RmZGQnptOUFyczc5KzlSb2ZXM2xyWkVJ?=
 =?utf-8?B?d2l2aUhXcWJJcGNYWDNLZHhwVkZHM2pOaE5UQlN4ZUlSSHh5emV5YllNYkU1?=
 =?utf-8?B?aldqM0x5aHh1VFMyRXFqYjl6OVF5MmdNWmRjZi9BRGh5eHlVS3NlUVZwdGhn?=
 =?utf-8?B?bGJkM1BtYVAxMlVNcUliT3BOUlR6amNlM2ZNMjR3WlZTRGFoS3hXemd5YWF1?=
 =?utf-8?B?Q2d5di9OSmp4RlUrUDBNaFpScmIwWFpQVDM0d0xuc3BiVFBBOTgzS0o4M2hr?=
 =?utf-8?B?bjBUZE0yOS9ZNTJxcDg2anVQZjZGT2dUY1lJcGM1QUl2NG9iUENIUitNRzZx?=
 =?utf-8?B?dGpRRVpQRlJ3NWo1bFh4a0ltTXJMVHF2M1BRWFljUGpEU2FUckhDNUVVVVQ0?=
 =?utf-8?B?YWR6bU9YVzZQcXRuTFFhQmtFaVMzZVplbStiNDhVRFQ5WDBaK1lwNlBaaDNX?=
 =?utf-8?B?eFdkSk85RWNiczVPVG5lNGZIMVBaYUhOS2xvVE02Y1daNGVtNHZLMW9TQzk2?=
 =?utf-8?B?eDJLLythWldhak4rMi80eHJUK3hRcGxVOGxrNXRCemc0eWVtbGdFd3hpMS80?=
 =?utf-8?B?VjBxeXhxcFVTWS91M3VGL21NNklPUVp6YlNaU3dNaEp2OGVIQXNGNEI2cXA1?=
 =?utf-8?B?bmVnWnBuZTBqWE05YlZLUmpXUHVraTBCUGFmYU9pQnNlVHU3cVMwNG1BMnkz?=
 =?utf-8?B?L3M0RWVWZzFwdHpQU0JXeWZVeGRUYXVZT2g4S1R3cVRtUDY4QkVnaTIvNUxh?=
 =?utf-8?B?RGlIVVZHZWxMOTFpRUx4RjZoT1hMcTNmalBoYXludm44MFVCUHl6MXlUaVlC?=
 =?utf-8?B?TEMvdTR6NXozMGhiWnNYenNQNm9KSGlzamhHeTYrR3NBTHhGVWo2bUhhVHh2?=
 =?utf-8?B?U01saGxLS2dPWTZFWWRoM2ZFUDZzc1VNZFlVT0F0Tkk2YTg5VjJnU2wyblFt?=
 =?utf-8?B?S3Zkc244MXRTQXBRejhKZkVyZ1FTVk01K0FhaEVaRU9naHlUQS9GaXNFZk1l?=
 =?utf-8?B?SGNVTWMvcXFBdDc1SGZJYkM3YmppRy90YkV3K0E2ZUZ5bDAxb1JWQTBWTXRO?=
 =?utf-8?B?YlZ2dW51NFI5R0ZIb0ZWYksySFdIVG91c0l5bzJDVnpVRk41cXZqZ0NwQWdY?=
 =?utf-8?B?eW9IVWVnNHR4YVF4eC9zVXZ1RjBPdE9iUlJvdmMxdWFZeG1HbFNyOFJFb0Rk?=
 =?utf-8?B?QU8xSDFBejB5Kzg0SW5ZMEIvYS84dG9scXdzcXI1UmxTVjF0QXRkMTNaell2?=
 =?utf-8?B?azRLR0p1ZG4vVlpKNldNNVRneE05QzA3LzFXQU1PSkxMVGlpaTEzSFBKTHB5?=
 =?utf-8?B?Vkd5WFQvMU03K0FtUGxlOHE0ZDJJT2FGMHFvNWJLNEtIb0JNVzArUmlCUzRQ?=
 =?utf-8?B?cDFOWDRLY1h5TnlqSnN5dzdRcmJoSkQ5TmZ6RHlVVGNXT0hxWHhGU2tpcUtu?=
 =?utf-8?B?SzU3SlN4S1J4OXJOZTNDT3hIK244bjJac3dCbEtnNkhUY3QxbHozNGNWZ1VK?=
 =?utf-8?B?U3lOa3dLMnRzUzJINWVBZGdBOXpEd09FMWxzRGxmdjRtc0RNV1U5VmRPa2hr?=
 =?utf-8?B?ZkJ1UkVjSUJFcnJiaWVsaVBndkhlZjVpRGhwNWVXTktDcm01UVAyM1g0dE5N?=
 =?utf-8?B?Z3VyYkl2TVJQWDN1OFpVOEFBdXpRUThvK0pNTStiV1dtVDZKZ1E0Tnd1aHls?=
 =?utf-8?B?dVRKZTJUTzFrM0pIb01kWER5cjMyMENDT3VoelVCQXphTkhtWG9HMzQ2K1JX?=
 =?utf-8?B?dUExU2JOQklCaE1xSTIzV3RSVHRTUUUvSzA2Y2VsNTlDMXBaNmFMZ2lYcW94?=
 =?utf-8?B?WUU0M3pxVG5iQ2VhSUdXT3loWUd1WWhPZXVraUVlVCsxQWtlTHhVclE4akhD?=
 =?utf-8?B?MUFnSG50WC9hczZQbEpZVmVYK090akliSXRPUVQyZE5QMTYyR3BrT3pJeCtK?=
 =?utf-8?B?YncvT2dwRU1iV3NPVFB5WEdxeG1sdVZnRnd0SitVWHJQS2hpbEVGdlFlK2lj?=
 =?utf-8?B?cWVIV0RqbmZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(10070799003)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTAxK1lpVmQyZDRZOGNIeHpNdHJaMG9vY2ZpY21zOXN5RTlWNjZ1T0dvcGdC?=
 =?utf-8?B?bXVaV1lUUEJJbkw1ZE9lM0JvcHM0NmZRSEZkRExNVTNUUzVxcTFtWVdseTIv?=
 =?utf-8?B?RVoxVnZrOU4ybmtuaGdtMTRNM0pLOVdLQ1l5R095ZDdoTUdkUVhQUVNFZVpU?=
 =?utf-8?B?QkRGbEJpdDVnQVprZVpuQW9CMU5QZGtKSndNQXpyRG5heVc5a0p5Z2hJVkc3?=
 =?utf-8?B?U3FFazBBTDJFUHg1SDRXMkt3M0wzeUpQUUNxK2R0Y2lhMWZDMmZjbmVuUSs2?=
 =?utf-8?B?RlhvdU50SHh0cnpndWNIWUtxRExkU2cwSnBPK2xZeTd5WkNjakNOamxjSXNO?=
 =?utf-8?B?aUxYVnJlMXZXaEttM3F2L0R6VUxGVUJ3cE5DakUyY0tEblkzOU44U1ZhQVl4?=
 =?utf-8?B?OVR1eEkrZWVSYjNZbDBpT29jR1cwWUZlQms0T3dybVJQMndZUnFUQ1lKVUFq?=
 =?utf-8?B?Nko2NDlzOGdEclpVeXdvUTZHYmVtczhaZEo0b2FMUWk2aUlxYmVpT09mM21t?=
 =?utf-8?B?ZXVZMWxNWjk1eEFEOFpxeUg2L25yVVFndU9DZDIxS2dyZ3RDNFpIeS9PVnpC?=
 =?utf-8?B?bVFTT2xyekxvNHRQV3VMa3NsdzYrMUhqZDVTeVVMajNXemFwNVNBRzdVL1Za?=
 =?utf-8?B?K0dDbU5za0ZNUGJra2tQQmE4Rmx6V0xiQlBoSjBWeTAwMTdMVTNVNEJPS3kv?=
 =?utf-8?B?ZTdNbG4zblZWd0xKQ0l4UHh0RjkvZ3Q4aTNBRXRRSkREeWcxclpSWWtGbEc0?=
 =?utf-8?B?amNQT2FQNzNRVjhHZWtDMFJXdjBneldyZSsycWFNS3A5N1JmRE5Gd2FmOFdn?=
 =?utf-8?B?TXkrSXEzZVZIaU9HU0taSXU1am9TVU1OQUhlRkRzRkxRcG9vZEZITld0aHUw?=
 =?utf-8?B?dFh4S2tZbEhlNXdMSTR4MVB5d3JGTlkvRU81S3pmdWlTenN1U2JNVGRhZ3Fa?=
 =?utf-8?B?YnhNaFNsYkVMREZWY2diYkgwdldJQUhPdzgrZHA4U2x0dFBiMkFDdk5Jd0tP?=
 =?utf-8?B?VkllMlNTTXFPbm1wREU1TEMyK29ENTZKSkw4T0UvaTl2azFHa3dTRHNVd1hk?=
 =?utf-8?B?ajNET1B1R3ZueVV3SHVMVVFqenJ5d2F5eHUydUZCTDVYVytuMjVEVzNXSFd5?=
 =?utf-8?B?cStjbXN6YlZMeFo0TEpzMjBzKytTblkvOE9HVGMzWktOZm16ZmFhQlppS2pU?=
 =?utf-8?B?ZDcvVHI4VE14MlZ4WW9xR1BnTUVNTUNLVUtpUXk3SFNFRm1RU3BqZ3R3RmFY?=
 =?utf-8?B?WEN3U2FKOVptcW9WZ1VhSU9JWVN3RUkwdmR5UjZPZW5mMDZZVzR2cCtPZWVI?=
 =?utf-8?B?NzB2MEtSZ0dOSjkrdDh2NFRyR1JyRjU1MnJ6dytVVmQrcFhjRjFGVWJjaUUr?=
 =?utf-8?B?SC92dUEvVlEwT1ZOVXl6VFlDVExPL1AzQ3h4cUNaUThnRTFBa3I1RTI4K0Rh?=
 =?utf-8?B?dytwQi9NM01uK0hZazQ5Ymgycmh6dUdMS0dodzd1Q3lYRG5hRHRRdWMra0Zr?=
 =?utf-8?B?TXZFSktMK2N4a04vblU3ckdPcWZOZklLdzM2QWVkZnNWci9SQm9oWFVnRnVP?=
 =?utf-8?B?U3A4SzNwY0UwOU1naWR1SktPYTIrcFBkL1RRMHFoTVhBOVEzVGR1K3RlQ09m?=
 =?utf-8?B?cm1ObHlOQk5ZbkhXNkFucE84d0Y1TXljSVkzUHBwekFTV3BGZXVHbUUveG1Y?=
 =?utf-8?B?SVhDMS8rd0o2VGlzVkc2dFJJZ3lvUXdzTXA3TnpSYm5SVGJOU2lmc2RDeTcv?=
 =?utf-8?B?WWd6VXZEbnlWc3U4OVI2VkJLNjMwTzBZTUxoRTN5dTRCMFlQZllycHZJdGpw?=
 =?utf-8?B?WXkrM25EVFBtb3Y4R3c0V005ZDhRV3k3dXZjRlhQS21BKytGSnZTWGFCK0RH?=
 =?utf-8?B?UTErUFlERVltUnVUUWJ6SUc5V1ZvWlRNMENmaVBSajJoM2w3WjE5TWxmU1ZO?=
 =?utf-8?B?RGY5WEZhWmtXeFhzeUFnMWsyd1NLUldScDBHYmlveXlpUGtxVTgyVk45TUxi?=
 =?utf-8?B?N2NvQlBsL2syR3g4NWg5cXczOFJ3dmVxbG9pTUN4Y1BjUDhad1hNMnRVNDNY?=
 =?utf-8?B?K1gvcndWK0plVXcvUUtLQmg1Z3JKTWNjWjVlcStoZTVpLzNNckkxZ0oxemxm?=
 =?utf-8?B?WUUrSGVNUXhOcGExVUVnd0JiNkRKSTVvRFpKU2llZmRlVy9JRG8weGR0d3hF?=
 =?utf-8?Q?9X9Hh9JWktWy2/cfNemPUtprKor+cwR7Xy1TeqYiPqTM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c51eda2-5373-4bc5-3d90-08de31f3c3fa
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:40:16.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UqFLpbYYnA/XjdeG8dk15PxdDUzf7T5Ag/2U3oz/bqP7EcnYYZafGT23WARrjNR2X2AxuI1ko6OcIavzK/quA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8787
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 631EC160003
X-Stat-Signature: bfaow1spiirufu9a85m9i7kzw5di7i9d
X-Rspam-User: 
X-HE-Tag: 1764715221-772942
X-HE-Meta: U2FsdGVkX18F99OamZm474nf3lE8p2Dc3sHbMiZ6eLeCQ1CyX9wW9h1g/mITrvqiNOYF9gogVLZ5QavyYjzBv4He6b4qHkBPS7iJ6kuCgkYLbGtt4nUQwY+9/mvLwFyxlhNdO6eDYsfTKCVPG38A1uG17yw94+jZXjGS1rCvvz012UmvTUjrvkXiZ4J8x2i5GbKWrUkObkDtezUAM4XhzH0v/MzzKu4f9boV3nsYIBCfMVrTvnvakXZiA1FiKXz9vz43BO7Ufy2Gufbl9yiecEGAGMrtJMLHqeYNhNED1HxG23eroxTIzSOvfV4Avw225pDyx/1Yu1Yuca0SSbqHzCJtiJ3qtFru7GeHdCZ2d2PFzC/nZA1qM0VNmFLKX4bLyfaHRWLPW+lzzMdzcLNhtRUBdbe3027jzPfql6HSr7ya+2B8S9WVAor9YLWyFKYvUfVOqjuBP+dGzJA1M/9ynmoJbeNDKp/euuXtZvHxqrXzcMq0EGjozjXoldwa1yvxOmfJfBz1BuB3yw/ad4KLWJeDpmNupo5t9sTJ4FAjFTDmEVl+grYmn0ghRbkYrBSUg+wSGKYP4Y9+8J6IscIux08Ap4/HYTPTYX0AbSmuzlM8IW/OAmlquUWzdPjftgQkUwZIdr9Y4lbDXfdq4zR8XtIDoySTWhdznzMfZIjPqUn4CXOAG0kxpzFt0LRQsAlvFzkRCuod+NNUnwMFw2MGjW1kEaG4oMltcoITRhl06Pw8KDCB07HJI9SydtnyD1ZuJ3javjg14RMHlfqOAsHjfD6X5P0RJ0Y+qOMHuJosPxBH9wMnIss869XRHDDfWZsbtqVKUDFytuwd0UHd8jdMUaMEipB5si5xe0VoBz+5m6CvyhkrSj8qVEeKmlyUMesXmCCuqSzSK38C2y0l4esGg2n/L2o4YxZTp9KcKgBGg3eA/DFs7h59YrgFRV8+Agzf+WVB4mySsXrNI9vgmGr
 9hCLknJ+
 of1pzso6U2mOJlpN5aP6ebKyEXehXgrV7hFdZ3eXCV7TVioIngT3zdejmtTgwkih4UPqqCxd821eN2xYGTJ6bfjV6vVt3BKD+nskKxjAhmNaUAH++gdSQkTlbGr9sF2LP5w0zzT6PfVGCtkprs+GUeWKfJktIUuytRDekTO+i8VAiqOeUfsfsdTr/6LCE7GAItt6QS9pp8lv1e2qfEI2ogH6uNAgVwDnUqkWGIrHmxgnAznV+piMJx0OtP4o/T42zjPS4763/Ton/jwUFp7FiUak7M0sGfATf8NkW0+kf6MeYAjnxjt9SwpmRMj+D72QMYnfJK1UBKhVSoDqiJkZ5FX+lkOUf3GoUwL/yAYKBpcF9d0KYToMOqCSEA4SDSxAW6Fwulb/f+5czrhuiL91pSrywPbI4WLOh11iEPYO+OTQptUvohXCjkvjvzg1l5P9PvtNaz4UQqkaUulI3ctYVO3Sa2M4CKhbzBEscpwlgaB7K0xwLZ4w5CJVgbQGrsgoDntMOwhUkZKL07lHmBK1MKZr8de8sOUkVBmpkXTShCxowU5rvx/hTGZnGcgRkL029seFB3Vl/TEx+JBjGKwTIm/3IA37oMfkC9h2LBGQYm5xU/+duP6QB+S/4HrApKkBuWxfUOQxfxjLqYDxywsCbjbWwUMSBtrM4BSSUDYX7WAe/v9nbVNlBAGNibxiipHYsVbxUDkSjMoC3IvM/dRbHnt3pPz81QnOZNioVNSYX6meUaP/2ev++HTUyuVUzk/F2LMbe2vy7PbBPjAQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/2/25 09:11, dan.j.williams@intel.com wrote:
> [ add Gregory and linux-mm ]
> 
> [ full context for new Cc: ]
> Balbir Singh wrote:
>> Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
>> exposed a bug with nokaslr and zone device
>> interaction, as seen on a system with an AMD iGPU and dGPU (see [1]).
>> The root cause of the issue is that, the gpu driver registers a zone
>> device private memory region. When kaslr is disabled or the above commit
>> is applied, the direct_map_physmem_end is set to much higher than 10 TiB
>> typically to the 64TiB address. When zone device private memory is added
>> to the system via add_pages(), it bumps up the max_pfn to the same
>> value. This causes dma_addressing_limited() to return true, since the
>> device cannot address memory all the way up to max_pfn.
>>
>> This caused a regression for games played on the iGPU, as it resulted in
>> the DMA32 zone being used for GPU allocations.
>>
>> Fix this by not bumping up max_pfn on x86 systems, when pgmap is passed
>> into add_pages(). The presence of pgmap is used to determine if device
>> private memory is being added via add_pages().
>>
>> More details:
>>
>> devm_request_mem_region() and request_free_mem_region() request for
>> device private memory. iomem_resource is passed as the base resource
>> with start and end parameters. iomem_resource's end depends on several
>> factors, including the platform and virtualization. On x86 for example
>> on bare metal, this value is set to boot_cpu_data.x86_phys_bits.
>> boot_cpu_data.x86_phys_bits can change depending on support for MKTME.
>> By default it is set to the same as log2(direct_map_physmem_end) which
>> is 46 to 52 bits depending on the number of levels in the page table.
>> The allocation routines used iomem_resource's end and
>> direct_map_physmem_end to figure out where to allocate the region.
>>
>> arch/powerpc is also impacted by this bug, this patch does not fix
>> the issue for powerpc.
>>
>> Testing:
>> 1. Tested on a virtual machine with test_hmm for zone device inseration
>> 2. A previous version of this patch was tested by Bert, please see [2]
>>
>> Link: https://lore.kernel.org/lkml/20250310112206.4168-1-spasswolf@web.de/ [1]
>> Link: https://lore.kernel.org/lkml/d87680bab997fdc9fb4e638983132af235d9a03a.camel@web.de/ [2]
>> Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
>>
>> Cc: "Christian König" <christian.koenig@amd.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Kees Cook <kees@kernel.org>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Cc: Bert Karwatzki <spasswolf@web.de>
>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>>
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> ---
>> I've left powerpc out of this regression change due to the time required
>> to setup and test via qemu. I wanted to address the regression quickly
>>
>>
>>  arch/x86/mm/init_64.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index dce60767124f..cc60b57473a4 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -970,9 +970,18 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>>  	ret = __add_pages(nid, start_pfn, nr_pages, params);
>>  	WARN_ON_ONCE(ret);
>>  
>> -	/* update max_pfn, max_low_pfn and high_memory */
>> -	update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
>> -				  nr_pages << PAGE_SHIFT);
>> +	/*
>> +	 * add_pages() is called by memremap_pages() for adding device private
>> +	 * pages. Do not bump up max_pfn in the device private path. max_pfn
>> +	 * changes affect dma_addressing_limited. dma_addressing_limited
>> +	 * returning true when max_pfn is the device's addressable memory,
>> +	 * can force device drivers to use bounce buffers and impact their
>> +	 * performance
>> +	 */
>> +	if (!params->pgmap)
>> +		/* update max_pfn, max_low_pfn and high_memory */
>> +		update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
>> +					  nr_pages << PAGE_SHIFT);
> 
> The comment says that this adjustment is only for the device-private
> case, but it applies to all driver-managed device memory.
> 
> Why not actually do what the comment says and limit this to
> DEVICE_PRIVATE? I.e.:
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 0e4270e20fad..4cc8175f9ffd 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -989,7 +989,7 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>  	 * addressable memory can force device drivers to use bounce buffers
>  	 * and impact their performance negatively:
>  	 */
> -	if (!params->pgmap)
> +	if (!params->pgmap || params->pgmap->type != MEMORY_DEVICE_PRIVATE)
>  		/* update max_pfn, max_low_pfn and high_memory */
>  		update_end_of_memory_vars(start_pfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
>  

At that time when I audited the code, I did notice that max_pfn was already set to the upper
end of physical memory (even if it's not hotunplugged, because those regions were parsed and
added to memblock_add() and I noticed that all hotplug regions changing max_pfn were coming
from the device private).

I agree we should check for pgmap->type, so definitely the right fix

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

