Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD27EE20A7
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B3B6B0093; Fri,  6 Feb 2026 08:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A526B0096; Fri,  6 Feb 2026 08:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E82D6B0098; Fri,  6 Feb 2026 08:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9366B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:56:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E59E9136D2B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:56:50 +0000 (UTC)
X-FDA: 84414182580.04.4AFD669
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9F67140004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:56:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lfnpMlXZ;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770386207; a=rsa-sha256;
	cv=fail;
	b=y/Ki4wVRfijEg9wP3/K4k9BvB96NDvhy/EQJPHpGXpzDxT9Hure/j/vsLThMCYaiI2/LI2
	D8qbbxrTUptLbPfCYUkpCbBjGXHzCXZzsrhaQLHtsBPYGMSSh64gVxHKBcCD6jwfpHnkTI
	4K43VjEm9UbKIxFIc0YiSaN9oedNYrA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lfnpMlXZ;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770386207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnTg0djbl6LoBIqZBzEtTkVVyB9Me/yh6KlDEPjefbA=;
	b=J4pkA1VaV7UNgOw7DGUUOfeBBRtl2Dmo8R1UceYY4wb2prpbZhaK/sFupHANfsXQzS+zAP
	uLsZJ2R8z/yoOQBBQSNXAVd5tqxPisXxs+9AcIIVkb8hcHjDqa8sV2prCqUFe3wcPrgjQ9
	DtGr4IEAJ59obVkrwnN26isbETWow94=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770386207; x=1801922207;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mBN0B36ITz+dpD4BXnAk6MFVguTDcmRnfm5RQ8g1hIQ=;
  b=lfnpMlXZLC076Npw6YzJK4dsANfG29/HCDR5NR9/qLIa59KlvwOdsBMy
   TxZGmIiLuVn0SsmCPpUykDzAWHiGRc+CxRryegQJNtvlttQnFRq/RZLmN
   +Ro4sI770EcivpPRXZIDLOZIObv+2vGSJRhcWGQuLrtALXA4I2tgUrKzM
   Fe/uHlN2gtYpYlyXKAC1JTze/MvSBCYCWZF4a2hvBCSH0TWMKc+EPLjfF
   KmkXBXl03rADjjNT4FWW5glyaF9O5HQzIKiufGuXGvh+4L9A4vXFz/+kI
   /J9I6I6ycg481/RbEwc03TZsvpMrtcDWaVA5aR3VZdqfkzgVH6avrjzgc
   w==;
X-CSE-ConnectionGUID: jqCfo4gjQjWRtq+42d/Kfg==
X-CSE-MsgGUID: ELjG7L5iTAKgn0dDTA5IfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="71483837"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="71483837"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 05:56:45 -0800
X-CSE-ConnectionGUID: 7zovsFPcTEaamPAnRXCeoA==
X-CSE-MsgGUID: wrGCeyXySUye3heoDlAhDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="215447552"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 05:56:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 05:56:45 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 05:56:45 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.0) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 05:56:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QoxJZfzhVlxVYWWSUgIMjJUpz9uP3olElZjR1djaIzstejZI3gzJsegCr0N97ESSUIxkRrDfJj5/HH8HEIkWJ3a7o9D6o4usT3D3qRohzz6MUeXP+RIGpjK3rH2mjN/VmTnCLkI2dMB+OFsZK0FRkmaucK3T4Exsd6niVIBiEAyQJdpSxDiYkFO6ARBuGT9zQG9KZGsVdoY2SFa5bVb5U7T89xHSIUcusJZvQKzTvANyEpHkgAFt2an58bFm33hMl0bY0yJjNpqVs6XW+gNu3mPqAUaDFajTmhHGJUzShl5MIN4yegSvjHZPKNhBYcCjWJcA+lek5Zl/LJ07vQttIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnTg0djbl6LoBIqZBzEtTkVVyB9Me/yh6KlDEPjefbA=;
 b=NQR3Xo8WGDtJcctkfhFhtEP6OIKUDqe8v6/goTakVb1ZQ2OQAmRaDmlgMjR/getHlvopoZZ7u00FbYDnlWWStxWf7xnVVOLfzsAq1ZLOUCLQvdMUf8C0tT9Wk22+J69U0bDYjKJjqPKaFlcz4NCzDmE2kwxRSzfSZrv8WyRzFPZEYDwkxYyDGCpAPzogy2VE/bUu+x/CPBGntvqB3LPmi/LJwu5wF8/k3gCvhbqpVXUF7rPWQX2wBsZKw9C1aCeodmyOq6cLCvKsh60j+wQiKkIH0Z+RTUOxXVlkMBim8zPUwI4lMGc9CDpqvrt5PFIO8rYJyDb5qIDdhswvnC9mCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DM3PPFD83941681.namprd11.prod.outlook.com (2603:10b6:f:fc00::f55) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.13; Fri, 6 Feb
 2026 13:56:43 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 13:56:42 +0000
Message-ID: <a670fc3c-e298-4430-9c41-d51598d25e06@intel.com>
Date: Fri, 6 Feb 2026 21:56:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] mm/memory hotplug: Fix zone->contiguous always false
 when hotplug
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260130160635.2671167-1-tianyou.li@intel.com>
 <2bf497eb-47b0-4eb9-a66e-607c82c36c20@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <2bf497eb-47b0-4eb9-a66e-607c82c36c20@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0023.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::7)
 To MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DM3PPFD83941681:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1c3e1b-9587-4bd2-51f0-08de65878eec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHl0T1NZTHJEYUVTL2NEQ1k4TExiQjhzUWxnLzFaSXFoSjJkdXh3NEkySXlW?=
 =?utf-8?B?ZHlGTmQ1V01rRExlK2pLcUsrRHR5VFp4Wm95elNHSzFXc3BJVlZMVHZEMHhG?=
 =?utf-8?B?M1J5d0dGT0hSODYvRVVZZnFvNkdzaS91RktoTWcxZUtWTXh1WEdyVW1uNkVh?=
 =?utf-8?B?QUxsZVNUR0xIY1hDRDlzcGlOclkvREtkeVBMWU1MSG1VcVRtalZmZmJESHdu?=
 =?utf-8?B?R3M2R2YvOGwxOW1QVS9SUmhlejdib2hXWVNpRDdhT1F6T0p4dmJYTmEvY0tj?=
 =?utf-8?B?d1g5N0Q2T3NXWlkvRWFQb0VpZ3UzUFBaNm5PYjI2ZHFnTmsvUTdPL2FPYmhM?=
 =?utf-8?B?bFdOcGY0NklyeVJFV0FEK1NkdGlEZHVqcm14YnVKYzZ2NW1PbG9jbG91Nkps?=
 =?utf-8?B?MzBpa3V6dmJMcmlrQ3RWRkM3aktUMUZHWS94UHhGYXprbENxZys0MzVOaXh2?=
 =?utf-8?B?eWZ4UE5TRE9pK0VmdmhUTVFlQVBFZGVXTU16RHRqWXVUcnA5R1NiZm1BL2Zx?=
 =?utf-8?B?b1REZ21VQ3VCYnRwQ1QzbjdJelZOQUhQb0xIYkRWR2tzeXBhc3FMRmNLYk9u?=
 =?utf-8?B?ZHpmcktGTlBScktmSWNWb3NPR2E2OExLakdGSlI4dFAxbnpLREplUEluN0V1?=
 =?utf-8?B?aFRJS1hGTHczMXQ4dHF1UDBOV1dEbXRMNkpqcStMOXBYWDNWRFpheTJYMUxk?=
 =?utf-8?B?d1dyUTVEVWl4TkY3Nm51eXErcTFYTVJQNmltcmdEZ2x4a3V3UVVmNVJRMmZK?=
 =?utf-8?B?a0grM3VRdzBoamQ1S3ZkczBGY2hqVnAvc2taUnBzVkxTdW9iTU5zM2d4Y1p1?=
 =?utf-8?B?UXkra3VuYllwTFJlQWlTKzNoOXFvTHBxVHdIZ1Awd3cvUStpakZHZUsrSG13?=
 =?utf-8?B?MDhvdXB2WVFIZEFMM21OQVNDek9iZGJlQ09RalZGVkRsLzVHZ1dVOWdRTUhj?=
 =?utf-8?B?MkpHWkQ5VDVGaXhYMjZOemdVbXc1ditadnpoK0orRk56K3V3NFlQc3pzY2sz?=
 =?utf-8?B?Y01jVWlFaGVJYkMxWnRCemNSeU9WWTBCSXBneHZWYmpPM05WaWNTK2dCaU5G?=
 =?utf-8?B?a3ZWT201TEgxbDZVNFpWZXFTVTdnMW5JRnVNVk1nWmVhK1VkNXRYSHB0VlQy?=
 =?utf-8?B?dVNEdkJaTzU3TWNmbDhoYmNUZFV2eVZxWTdYSXBCT2tXb2ozK2dNRHpSSkwr?=
 =?utf-8?B?NWppMmR4cmx2S3NVVkppM3ZjL2hMWHdpd0UwWmRjZVppUHJsb2lJRDdqVHJJ?=
 =?utf-8?B?UFpIL0F6bm5SYlFvUWJsVUxDQzlraDJ4VkhVSXEvV0srN0F6N2dyMURzTGRn?=
 =?utf-8?B?YXNZWmhTN0NvN2ltZEZiSk9ETHR2MW5QWEZmKzdkUG12dVJNVVV1TC9TTnhl?=
 =?utf-8?B?MnJUNWU0d0wyMzZKZFdUQUdQS1k0Z095YWFldlZSbDMwTkVUeGxJTGNUOWxa?=
 =?utf-8?B?WmdqWlR6dnhpdGYxWGpoOGdxV3Bod2ZHUFpzVHVJSlpHS1BETjRBTm9XT2xV?=
 =?utf-8?B?YWpzTURpWVI1enFXWHVHekozNDhiMDd3bjRHT2FTVGN4cDg5b2lRV0lCWllV?=
 =?utf-8?B?TWk0QlN6V0FqaVQxUGF2UkliY3FrRUs1K05JMmRkUnBtRm9iVWtDeGdXTHRu?=
 =?utf-8?B?TlBPelNOZ3E1bmJubU8rS0lrTm1QY21zcFcvVzNBUmpZeDdSbGlSNVcyakd5?=
 =?utf-8?B?ZlRNNU11bW5ETUozWGRIWVUrRGtPRmlVa1FaTTMycENadEtSR21pQUdvdEsy?=
 =?utf-8?B?R3EvdmNxUHdYWldPZm8zcXpTb25EZ2JyZ2VWVmI4RWdsSkg1YVcra3I1N0lZ?=
 =?utf-8?B?d1dpd05uMFBUbkp6Uys4SW9tRW9qZUdaUWZ3aS9hTk0rYzhhQnpOTVJybDY2?=
 =?utf-8?B?eTNGU3FsZ2VpWmhHQW04OWlWQVBxUTVyRGhhdFlxNlhXdkdScHZYUWFFUVV0?=
 =?utf-8?B?b2R0Z291ODFtdXc0S3plbUYzR2d6aGZPbWNzUVo5U1F0bUM4am4zUzBlSkVr?=
 =?utf-8?B?UkFmQVQvN3hGRUdaOWtoWUo1a0xxckE4UGJPRHBPeDBSRXdZTXUxYmtDbjg2?=
 =?utf-8?B?V2hGZlBuSEZpWVAxZDhkcmJpOENDSTd2b29NZHF6MEhJUFc3cTZCMGJibzgz?=
 =?utf-8?Q?GxQo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEZnbFRoSWUzeXNDMHpOaHdwd1Bwd3dvSm8wZUluSmFCMnEwSzlYbnJ5Nmhj?=
 =?utf-8?B?Y1NmUnlFOHgrakwrc2VFelA1TXJRaEE5NnRYNkwrRjBPYVMyWnp5bUR6Ymtm?=
 =?utf-8?B?Mm5lR3JhR2lvTm9mcmFOZGxLNHRrWTFlV1FSdU90UXZnNWJMK0JhY0FNeG5j?=
 =?utf-8?B?OG0vOTN2MHBqMVJURndUaGFLTEw1RXd5VksvNTJicEVOSSt6RGpYWHhGcHl0?=
 =?utf-8?B?L2orWkxTRUlkMWNZUzlCQis3clJYY2RGVmwwZjkwME9pUVY0QjcvZkVUVW9J?=
 =?utf-8?B?eWpKSUlTNytScGVvejVTSlJCOXM4V0dwUENpS2MxV2ZqQTZCNkJHY0hscFJu?=
 =?utf-8?B?ZXBXMGR5TUFpdXNjcFBZSDBzcmRtVlR3ODlYT3NNbkVYcXNNUmZBaGIzZ2la?=
 =?utf-8?B?c0gwTVFvS1hvWGw3Vkl5R1JHMTh6R0Y2dlhReHlLZmpVUjZyOWVPLy9jUnR5?=
 =?utf-8?B?UFltL1BTWmZjNm0xS1BnQW93RkxpUys2WnFFdUhYdUdLRktiK1hsMnJjWVpI?=
 =?utf-8?B?RWxPM1JTUEllM3QyOWUwR3pmY1ZCR1NJL3ZuaHF2NFRZVjg3dXJ1eE9xd1RS?=
 =?utf-8?B?NUdwQ1YrNTdjWEtNeWlXUUFnNjVSYnhYWFdlRkRrS2ljZXpaV0tleG9FL3Ew?=
 =?utf-8?B?b1pKa2t4aTV4WW9ld3FVdTR3Q2VnNUlYbkFIeEtWWEVUdGxLb2IvRENJZFdH?=
 =?utf-8?B?U2NCQm1IR1R5T3JHT2ZReFMzTU1ZdFZreXZzSW5JSTh2YlhyUWVVajBmTng3?=
 =?utf-8?B?dlJHbllSemVURkRXbFU1UThZZFNWNzFpZnpQTW1QQVMvQjRwTmw5OFBIZzVj?=
 =?utf-8?B?aGxEL25WcHhpWlBxank2MW5kUXJLTUc5TlF1dCtQek4xZDBFMzN5Lzd4R3JT?=
 =?utf-8?B?STBEZGFpUE9zdW5uNGh3UkVydWRtTllOQW85RUhzeTNnQUFueC9tWWtCMWtr?=
 =?utf-8?B?RVRpNzdRQXY2WEo5YnY1cENZSzVuVDlSWHRteTZ6OXNOa2JoMGxBZDZqNDY5?=
 =?utf-8?B?UmJidGRwckUzbXI1L1AyUmlzSEExQUQ1NVpWQjB2dnJPU3h5bllVRnkzclEr?=
 =?utf-8?B?YWZUVm1PYWFhNzBJd3dsZ01LYjdaeWU2cHk4cDRpamQ1NjZwQ0FnK2x1d09L?=
 =?utf-8?B?eUFodllFUkRuSmZBUTNIMGpMcUtSL2s3MzRLd1NNSnlCTE5uY2ovNXVXZktE?=
 =?utf-8?B?VFJGT280cndCeUI2M2VBNTVCcTZmZkJuYVcxUzBETE1aNVl5UTQ0TFhmd1lP?=
 =?utf-8?B?OHFRR2xIYXBaT1hGcmFGeUJqbTJJWTEzWUdzMFNtSjhYbkJXbFY5VUZ5RWQz?=
 =?utf-8?B?VHhuL2IwSno2WUR4N1hYS3ZtRmF4MWVDZU5Kbno3cnF2S1ZKRGs5UW94bXU2?=
 =?utf-8?B?Q0F2VHVTWFZtL1MwaTFrMHh3cFZjRFY5WUloanFMRVdBOGlSbVZidmJ5MkFV?=
 =?utf-8?B?TTdFSTVWbXlLUTNlc21HeExnRlljNEx6UjNaZ3RHUVJOck51QVJOUGJaNUJy?=
 =?utf-8?B?ZHpxNjdmRDluQ0hQYWx1OWpKZjliY1MrVG85SjJueVl0VjFnRUV5MXY5TmtB?=
 =?utf-8?B?NFAwMWE3NncrRXVJOFIwRGljUUwyNklMK2RKTDNLa0NTQ0p3bnR5ODlJbHJC?=
 =?utf-8?B?R1dVL2wydXpjS0RhNWVsZEM1cCsyU1BzTlpDeGw4R2grd1BhaVRxMHdtenJT?=
 =?utf-8?B?bFYrS2hlRndzK05PcURnbXpiNmZqWnhzbXVLV1FveGtlUXRyNWU1SWg0YzBT?=
 =?utf-8?B?d3JGeGtQYXBKUUxydzFBNDdGbHNRZ2RrdXdnTWx1dDdBbHVzVFNrMVFiSEwx?=
 =?utf-8?B?aEVKdkxHR2h2eDdXeERRMU1MSGhXcXpXQU9ZNEZNZ1pwb0ZvNjBwbFgzVzJm?=
 =?utf-8?B?SHU4bWVWN0pZRnNQYVJtYitYek9ZOUlPa3I4VE5BdUtkSXBiWk5jZERHRTJu?=
 =?utf-8?B?bjZWVG1JS044RTdHcU1DbTJFWmk2anNuUE81SDRLRllDWWMvaWVxRGZsSk00?=
 =?utf-8?B?Ynd2WVpIZlh0Qys5UXlVSWo0WlR5ajZZb291SUZkTWdCR3VJTTZwNnlJb0JJ?=
 =?utf-8?B?OUFKNE90aGJRUk1TeGVWVmpRT0hLcW14YmYxQ0lNSVk5N3o1SWdqUVFXOUdT?=
 =?utf-8?B?Nkw2VGFWcVdYckltdlRsWEhVZWhMbFVpaHpNSVNocWVFK1VxTmFyVWRKV01h?=
 =?utf-8?B?R3FyVjJrT1FiTVYxUVY5QmFiaUhPdk9UcGhZWjBpbEFwNlcvZkl4OTBYWFYz?=
 =?utf-8?B?YXlYUElGNUxxTUJCTG45Uk4ybmNpSHduYU40S1FFbzJtZkt1S2RWZVVmRnFv?=
 =?utf-8?B?eWlpdi9nei9qRlRJUmhMcWE3djQxdEJhcEk0dVB6ZkFkWEJybVZmdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1c3e1b-9587-4bd2-51f0-08de65878eec
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 13:56:42.9170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjHzwxtAC+uqVuNwR/qPo7uV8jbuK+IX/cdyE2CRnCL0i8SxsMRtl+0Hv91u1wkPTIz5ro8fASjMzWJ4Lh6EDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD83941681
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9F67140004
X-Stat-Signature: rnnis6po9qmt1cxemk9tktotzfnjua7o
X-HE-Tag: 1770386206-331476
X-HE-Meta: U2FsdGVkX1+QF1W7ZjYn88jiVOybtVi4HO1AlLLpgAi3W3f3Hs6aZpy1LdU37ACjvKm4D5SmRNfcRNbyCzxhxRctYUXU2i4oDcTRXhaA9dss9GQ9N5cB0VE4jw+UXe/zkHvz5zDhwO757jFJNlX7sBLi4QSb4mD0EtwokuSxV5R4Q6dKQupYNqlaRcYYOuWqmiERLgpRuKcWmWOvBL5DEQg/WffRxib5tsWGQsaGMOgYhAhOEoDUgc9hUK3PX7BOHz2tk/FYD2uUYDVm2/TZMiUKEtn3YDgfbeBlyYIWXtLtmgMTmpX5sfDuYKkTcjzQnwb8EtvuTilnXXZ+trZje4n1jD2hO5n8AwNF+InA1+QwDOYTOSFFZIiCjRYkmItO32UpDST1TnKM2BC6zj6FQY29DEqf6SZSzou2tSFdNbhxFixSf2Rh1kJCKo11S3h6WcdSB5AbRkIBEOjrNgLDXTaVS3paZ0HtGok+bmThg1PU+Wjmp6H0dKIsrgPiWFwBXTdTF3yYBdA64iHGyf0QFa81Ibn9XSe4D05VhxI5F8pHuSVU4jDPDBGhtHjgH6aBXftRRXN8QIhw6h11RJBkP+yoyu8jY6dqCFQnJwsrHXiuYSB6Gcq/cupPg1YKFK1nJ03uszs75AQPjRfLt1J0AgQb7WWQMj5bF/pBDM+cZv2sfddWJa1Rq6n5WulNOVsd0pZUxpZqa5ZaeVn3CacSkYA6GCoGpi7cF1oPoxsPnaroANu4hkmxNN4grFiylVSL4KdLR/SP1mC3BGbvtr1Z4ix2nY6wxVOgulZ/4kK1+iGoZ5nB7AqA4U7BBEtopQ7Tc5MFxNGFAleh58JXxfJEe88BlYYfEC1vCYjSGE22Rpf610zX68YZqPk6FxQgdvhekO2gdBLIqJY4t3WOn4tzjq0phJc15pHoh4U7b7fV+q3BkIgVugeH0/i9m3nfbN1528ZUXx+vMAcWzfodXjy
 F2DMJmXc
 XigGPMUF/dYKb8inE71iMJBiOY9jJWvV2d1UrR8GksqZYQN8MnSUXPawQHKiiRa1HZr+Ev6Cdf7IE6IbXricaiIJyMTLPNseTVP2c44f8/UCLF439Ta4JpKVf3wahaVr87MTNmQvwi/aN/YWemIl8gsPRTooCvKzlwrj48zUtj3HYKf3c4spo1OkHU+qT8Ou8Rjau3rEiTJDxxVeuFQjbk+CB+QdNh7ugGF+meZB6QXauIAq6vl28WTi5vpoRYzI1s123IwxAEwENxanvMrJxQi0a7ngZ1LAhTT53kKpV19scNS/w4UbLM7Wxjy+rAQg4ECdEiIhYTyxciP/2jz/Yfy/maYSsDAKCvqiyqh5FO6ftuuPyGUi2R4n6HCx/MhocRL+5JLC09ls6HWsG2boQnNDeuftVTnJGlYf71c0TR+M+1XBODSCR3yQA5o2H+m1jpk6B6v+Lks7Zto6oI4wONmvO0pIQ+RmoP7ty0saVm90L3JNlnYBNjz4uxKAb0u08RIfwp1A/bMw7VRzBN1oRe+D94Py1YV9IElamlsT0Bu5NhcT4vc/LFJQAGNyZlHlnxGjvA9hxNDv7UKgg9p9xeI1eUKpFQoLhIQfe2OCHASa7+K9JD5m8bBLsUF6D+srPjzc6anZ82lc0wNY7yIZHSRx74g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/6/2026 9:00 PM, David Hildenbrand (Arm) wrote:
> On 1/30/26 17:06, Tianyou Li wrote:
>> From: Yuan Liu <yuan1.liu@intel.com>
>>
>> set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
>> pageblocks that either do not exist (hole) or that do not belong
>> to the same zone.
>>
>> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
>> effectively always returning NULL for memory ranges that were not
>> onlined yet. So when called on a range-to-be-onlined, it indicates
>> a memory hole to set_zone_contiguous().
>>
>> Consequently, the set_zone_contiguous() call in 
>> move_pfn_range_to_zone(),
>> which happens early during memory onlining, will never detect a
>> zone as being contiguous. Bad: the fast path relies on the zone
>> contiguous state may skipped.
>>
>> To fix the issue, move the set_zone_contiguous() call to a later
>> stage in memory onlining, where pfn_to_online_page() will succeed:
>> after we mark the memory sections to be online.
>>
>> Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated 
>> to have holes")
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>>
>
>
> I assume this one is to be ignored :)
>

Thanks David for your review. Yes, this one should be ignored. I should 
clarify that ahead. Thanks.

Regards,

Tianyou


