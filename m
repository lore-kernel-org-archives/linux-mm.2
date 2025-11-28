Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C42D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 15:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62BD6B000A; Fri, 28 Nov 2025 10:17:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3AFE6B0011; Fri, 28 Nov 2025 10:17:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCBE6B0022; Fri, 28 Nov 2025 10:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9BDE6B000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:17:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6436E1A0567
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:17:33 +0000 (UTC)
X-FDA: 84160369986.19.6BBE88A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2441FA002D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:17:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mW6wsC3r;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764343050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuU2Lpe+xcWbT7m4g/c87+hsgJjecCzp67+Y9yOMoTE=;
	b=gE9tVT+axx81FpZis2QENIl7zCyHNfYkPZQGt5j91+qJQvyx7n+s2YzZ25DyyT6bLwHKkM
	o3U/rDvjhbUPPKa0rA2wcuGM4qetTiwsXcInIhU6YBQKZFEMf+O5OopK2nhLfOKUHVxBDU
	WJMSAotIZaUvL7OQHJumWyltz4sPucc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764343050; a=rsa-sha256;
	cv=fail;
	b=s918wnW3f/XjkVZT5RAYgOZfHSOgykwuytbDhfRhlBbi4uMDxpB3JKlJzL4OLFSUFfABcO
	4DevLqXkuhRKZumI61aKanQGFAter6q5+p6gACVtx5kIQKPMYsvBbvrehLvBZc3MfKVMNw
	76zdw8bsjWCEhZa1Y1t2sB3K5l6xoPM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mW6wsC3r;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764343049; x=1795879049;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KV/TZbEP7DrGxaFNnOF0rBlW9N2ea40s9OsWwA6T6IQ=;
  b=mW6wsC3ruIiBj7c2I/iy4L6GnM93MQpuJ3n4fHPm3/zuHUoVOT9n+Z7U
   H2BMyEl2Fr0aKROjXp9lsHlp3N9roOnwF4kpPLl4mL7a2mY0UL1P96ROv
   xrzI9yrXl3FRrRM4cQMNp2H6QVddnUXqS4DYwp0SXhRnLqCQS7DOay1Hy
   ab385kBJ75FukGxGAd8LZhpTA6PmbgTxyrJDl2yX0PXhHcRq5Uuon21vj
   ZfvJumKU3der167vuUb58xfBpH9grvzyeYfEm2iaaT4HLSL1y0Ej/5N4Z
   viMYW00Hz3hCveOEItN6z0WxImiIUsbmZLYpC+wzJyKxDoNBPOqdF8KhR
   Q==;
X-CSE-ConnectionGUID: iez5nO49SHaFgHqdVW4Gxw==
X-CSE-MsgGUID: RdNFTAi6TwCWBLiexRHVCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="76699982"
X-IronPort-AV: E=Sophos;i="6.20,234,1758610800"; 
   d="scan'208";a="76699982"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 07:17:27 -0800
X-CSE-ConnectionGUID: ANiepkXKRuyE2up45JzQwA==
X-CSE-MsgGUID: PvlkIGGtQGKj5zTEjCv9pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,234,1758610800"; 
   d="scan'208";a="193375797"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 07:17:26 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 07:17:25 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 28 Nov 2025 07:17:25 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 07:17:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9H+1zgNURxvnemniuoMOsggvWeWB5J2ClB3hj6Ov5k9gvPWNJQAuDJUXQGYiYn/MDDszrLRaqf5LOYfiXmF7CAUggnydgQCA0VAFA7Vx+3gBDnzw3iBZKOCNXj08mGO545SHhEd19GVoVzq2bIY/M7rz5JMlFfns92Ko6u6ojiE0gcIhHjn1aWHNrccgaaWwdgu570tIgznNBg30+6XgZ6i3b4Fu6ArFLllxX5HfjnEKUhPhwxpxdqUn4txXciG8ktR/afjWainRn6p2SXkQ6KwG6HqDRF2ehsRhM6Gz6Gg4j6081zSMxx+SfMUUwCH1D4tDsRH6vDEm6EjFh9DXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuU2Lpe+xcWbT7m4g/c87+hsgJjecCzp67+Y9yOMoTE=;
 b=rkXC7h7HKC9TmQesDxUNwkNTbfbzmsi65B3NL5krUfjpXwtQ8Xs7kRNuajykLSfRi6d+4EJotq9Bcs5Zz0/uG1BA7ymZpFqSI9hNBHBytUd3q+HNQ/fM1wCCs5SaFDTueNFWOV5QYTs6SpeEKEdg6BUrLz9isLvvsIk74CUggz6PGXBNamDHlxbq1YcaHxBRIMxjBmm6krfTDgjpvlrOaUsP4ejD4AgnQBfh4yTP0tDPjfAZSwW+ARi4RvHNcOLX7YzpUNPWr8f5PXZ2hevC+enqtUBTJcKSRsQUeoNXt0s3PcCdocmJDov9gjtJuNzwnOmODnlW8uyDovG6ogqshA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS0PR11MB7926.namprd11.prod.outlook.com (2603:10b6:8:f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 15:17:23 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 15:17:23 +0000
Message-ID: <9b6e39ae-c317-4433-8171-0927bce3acad@intel.com>
Date: Fri, 28 Nov 2025 23:17:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251119114252.oykrczprf3ecd7ak@master>
 <20251119140657.3845818-1-tianyou.li@intel.com>
 <872562fa-5dd7-4cc9-82ab-5b7c09ee8fe3@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <872562fa-5dd7-4cc9-82ab-5b7c09ee8fe3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096::23) To
 MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS0PR11MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: d01205f7-f98b-4b38-c389-08de2e913b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2hJbXlQTW9EdVh2dUhsajJ0WmNVS0p1L2dMM0F4SlZrSVYya01aK3pWRTFJ?=
 =?utf-8?B?dWdIRk1YVEJlMGlGQVBYck9QMlN5MFBEWXJNekZsR0dzdTh6Tm5iMmJuaHN4?=
 =?utf-8?B?WmVSbWgvTFgxYUhwOG9EKzNnWHhGZ0dKRGVXMVp4THNsSHVGSnJyYXB0ZVJE?=
 =?utf-8?B?eVIwOTByQURBYjI0Z2RWM2pROVpRRFRlSUliMnZ6OUpmQmtZZXRWc2pJbUN6?=
 =?utf-8?B?VUE2bk0vKzNGMjlacG5tU2Y0akNlS01KNUFSeUh3V3lyZ1ZyZUIvNTBiTmls?=
 =?utf-8?B?K01VSmdiaW1hejRodmNpakhPN205NHR4b0srOE9zRU5GVUpvWnY3cU55bk5P?=
 =?utf-8?B?VFlTZkF3cGRyRGFVMVFrcXNKaExSNlBwUnNjMDNXRlkxT1lNVit5NlRoUmRZ?=
 =?utf-8?B?OXp3bFJudnppa1VGb3VWYnZlNk4wZ1ovdGJzWmdqUkxEV3QxV1hwMEJsS29V?=
 =?utf-8?B?MHRaZnZZVUFsK0xQMmw0OXNOZjJ4TVlucFNHamxrL0NSd2ZhalJnQ3ljTVFL?=
 =?utf-8?B?Tk1mODB3a3JJS0VmdjFpenluaDBGbFdBVU9YNm1ZalYxZlJmV0hnZHBlVzB0?=
 =?utf-8?B?ekcwbmVpMmlucEk0Q2VLSkNIL3dOSFpMM2VVRlNHa0ttTEE2eDg2eWFzbGlD?=
 =?utf-8?B?djZUZ24wcGk5WlFCbzJBaks2NWdvemtCVmFSMFZUV0U2ZVJzTnIwQXBXTnRQ?=
 =?utf-8?B?cSttNWVQWnROeXUwc1RzVUt1dFlzaEIwUm1CNE9JbkNBRm9LLzhNc1NwYXR5?=
 =?utf-8?B?VUVaSTNIY3pIOGxqbitLQlFyOTlWU0FRY1JDcDhVRk5VNnZMcmI0WGQ4Q1lQ?=
 =?utf-8?B?TksvWml5dmhaajlCSEdCQkNxbWw1OE1wZTdsR1hIVnMrL3VHVjBEZTVrWmNM?=
 =?utf-8?B?dW1vQXFOQXlxOGQxa09lRWdhTktkMDNmcDRTMmFxQVRtalBKdFM5MWhpSUtZ?=
 =?utf-8?B?WC8zdEFIRFF3Mzh1NHVTOUNEK0ZSbVB6a25mVDNPdlNGNmpndStGeVBPSEZV?=
 =?utf-8?B?OHpNMUl4ekFyM3NYbFA5bmVBOE5MdnFPcE5uRHR0VkQzd3J2a0JsTVdFeFdV?=
 =?utf-8?B?OWFsdm9EbVhRU2szQXNzZkF4ai9Ec3VjK0VCV0czUjU1ampvT21kR0V1UXVn?=
 =?utf-8?B?YzdmempRU1BZVjBYTyswaEZQVHRYMk5BSng2SmFvQ2hoNWdRVGNMNThicHN5?=
 =?utf-8?B?cmdTdG1HTlhBZGVSTUtMMHI5NjlVR0FURk1ESkFmR3AzTldsclZRUjdVZFh0?=
 =?utf-8?B?VHRBTHBVWEFYQWNTOHd6TTJFOW5TU29STHZjZ3Zkci9yd1pTOGMwdnF1ZHVm?=
 =?utf-8?B?c3ZXcnpLNmllZEwyRjkwa29uREEvdVVRWGJrOWdRQUFlc2FmUUx4U2pISVhz?=
 =?utf-8?B?ZmFYUFAxYXF1WCszV1RwNGZFZXMvWlBPbTRkSUVKRWpiTzlDaDU3WkdhTDlR?=
 =?utf-8?B?c0xGOEZJbVIrOUpMVmJtY0NPYWZtMC9xNjAzN2ExeWpiV092STlnVDQ3S3dQ?=
 =?utf-8?B?THNBcFFUdTJPQkkxVFMxU0JDbmFaVmppTVcreTNBc0xzNVMzVXFoNGM4Tkp5?=
 =?utf-8?B?QlFobGtBVVNQNHdyQkNISW9IZ09FVGsybTZCZXNxUXI0ZzZHeU9NSXk2alhn?=
 =?utf-8?B?RkVieWZ5b3hEcWduMmFZUzd6NzNlaiszM2dUbzBCbGlBUnRSL2Y1dVNCZjZw?=
 =?utf-8?B?TkJWd0NkYmFrOTdJWGZCUTFmNGNWZkhKbHVDMEQ0VFh3MG9oTFZZZTA5NGpL?=
 =?utf-8?B?RTV3UURMOHdHUFVmWGtGQVVxcC9tQkgzNnBMTVZWTCtjL3E4dS9iL0s5VGRk?=
 =?utf-8?B?eUlHVU5jS2hUdWtueC9mYjIvbmpUUVBwUndBa1phM01SajM1L0hWbjZ4MEg2?=
 =?utf-8?B?bGtTeGdBeG1ZbDBZd09ZRTROSHlhMU9SV3RXd1BFdzcycDZaSlMyYkU2NER5?=
 =?utf-8?Q?Fnlcx0SgAwlvArMmJvO81uhQKxFJQUgr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmswalFMUEdwVVE5aGNHenJ0OVlrUkdpdlZienBqRmpzSHJ1aWQzdUdYc0JD?=
 =?utf-8?B?Q0FvODB6RmhOT2lsbHlaSmE2eDZwc0xHckRGcENramZaSUNPM09NZXVldHpT?=
 =?utf-8?B?a1JSZGJGRXMySDY4ZjJRcEx2clNOU0c1eVJaTzlDalZlQXNWSHN6M1QxbUxE?=
 =?utf-8?B?OFZPUCtOSmNvcVJpVG9uTlk4cHFVRkk2dzRtQUY2OFpZWHZ5YzJRRFJnUnhv?=
 =?utf-8?B?dlUvbHBvbjBYZ3RycEU5Mk5iWWxUOXlqRytFL2syYy9jVVlmbk5sbjBoeWVQ?=
 =?utf-8?B?b1I4cEE4ZlFyMlc4cEorYkMva3I1d2hJNmRtWm55MVhuSytSZlhSYWZyYUR3?=
 =?utf-8?B?SGJ3amVuc3AzcmhYa0pZa0pYTjdyUUNLdy9ORWNHMzIwNVpCUzRKbCs2TGQ0?=
 =?utf-8?B?WW16M2VoVGwra1JvUzJsTWl6UVZjQnlRU1prOExhNmNabzZQSEtGb2ROWE1u?=
 =?utf-8?B?UmM1aEJNSW1xaGV1MXdNak5mZHorZnNmTUNXU3o3dW83L2pPay9GZ2ZDd2hJ?=
 =?utf-8?B?WjRPeUVoelBXaDJiWEZCTlNHMmd5YnlGb2RpYUFUSFp2V1IrWm1NdUplT1RC?=
 =?utf-8?B?NXkydEtXd1RqWVNZajVHak9PRm9FdDR1V2JoMGo5V0FTYjE3Z0kyTEpWaitt?=
 =?utf-8?B?SklyRFZ5ekZMbzEvZWFVcGNEN1ZVODFEaG5qdDhOalBlS1RqQXVWWlY2Njc0?=
 =?utf-8?B?MXliTExxM3JlZGJTRFFQenNwV1JHbTErSythaUZvRHBFbjBpZUVBMElCWDU5?=
 =?utf-8?B?dHFiZUI0L0NjUzltZ0lPUzUzb1BvNVNFRS9Ub0RseEtqL1BXeURpOTFRTmRl?=
 =?utf-8?B?UHhXbGJlZWpKdjA5a1ZnNVphTmJ4aWh6M0hPTlJJZWdjbGVBUzIxU1NIWmxK?=
 =?utf-8?B?VFRxR1NabDRJZm80UHZ0di9LWThwODVyblF2WnNwak0rZTVORUNET0NkN3R0?=
 =?utf-8?B?aUlvOFk1WVFSby9PRXN2R1pFVC9WcDhxeklaMk5aeUpidEtRZHFac1lhVHdS?=
 =?utf-8?B?WnY1M2pRaEc1bXZ3aUpPeHBsckFhWDhBUjJoOGt2eHpHcXNIblhPR2M5VmJH?=
 =?utf-8?B?b09Ea3JIUHRkekJBdGxMdXhteVhrMGQ5UVJTU1Vkbk9XWG9NbWtpVXg4Y0tN?=
 =?utf-8?B?OGxoOXRZUytiR1BDYit1azMwemxiYkc5cTRzSnRiby8vOEJ4R1hRQ3RrUHF1?=
 =?utf-8?B?bGNKeUxTT2dtS3Y3MkZjaHNta3FpNTRwK1dhb1l4SlBaV0s5eUpWektPSGll?=
 =?utf-8?B?QXBxcG91T2hZZmtLUm5KNnYzT01oRUF1RjRzRStBbDNQc1BGVEdLamlNR21Y?=
 =?utf-8?B?NlBmeVU2TWdNcXh0cUpqaUJlRG5VYWhrb1dyd2dZa1RCUTIrays2U0NWcmJW?=
 =?utf-8?B?WWhkRzBzd3hINU8yR3pTYTJnRGM5dk9HWlVMV21pck5JQXBlVytpNU41VG1Q?=
 =?utf-8?B?cFpoMitIMWhGVm9lT3k2VXBCRzZudk90TUJHNHdCelpDVlNJeFpwT1BKc1B0?=
 =?utf-8?B?N002MGxudDZrc2ZvK1FkTlNPd2lpUk5HbFczUkErOWV6a281TENYb1Q3NFNj?=
 =?utf-8?B?ZTdOZE83UGhrdGZGN1pzWHRWc2lXYnlLWEp3WjIxTDRXeWNVTjZ3cktFM08v?=
 =?utf-8?B?QUcyOEJzU1NPenFsdytVdUJ3OWVjNDZhN1grdXJMMS81WkFRbHIzekQwWmxN?=
 =?utf-8?B?b0pZOFVQM0lOQ1hmQWdROGdRTmpiaGh0cm9uOUJKWjl5VGlnTEpnT1kvTDk0?=
 =?utf-8?B?amgyQ09tVGx3ckhQaFB6TmREUjhvVHRwbVY5THlHcFluMkR4WlcwK1I0NlhG?=
 =?utf-8?B?YjczZTNycHBFTmJmbS9hRHRUS1M2SzNsRzJybnlwazE3SUo4a3AxUVkxM1Bx?=
 =?utf-8?B?MElFT3pZVStvdE1nWnBJck8zQjFuS3VzanhjcTJFU0ZrNCt2a3lxYnNaT2d4?=
 =?utf-8?B?S2F0MmVGSjNOKzNnTm9idWhUVVhpRUxWRVl3UFZjNzlOaGJQcnRWbytpU05R?=
 =?utf-8?B?MU80Q0wzZXAweWYySS9jYjd4ZTAzdUwxaUs4UVlMY2tHbC9pb2pJd2M0Q0Iy?=
 =?utf-8?B?bDQxdUZjQUZoWFVwNHEyT2ZJUkVMMEhNdXZBd1daWi93d1lnV3paZGZlRkE5?=
 =?utf-8?Q?MtvQYY7aluJEgu/WexKD6kw7c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d01205f7-f98b-4b38-c389-08de2e913b37
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 15:17:23.4504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFherE64TM/vUZ91ENjqipdHW0wkKa38gsY7xDoVtf4ZmF8LZ7hg4V950qjJWLd1jyHcWt5ESAQualq/2uXcwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7926
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2441FA002D
X-Stat-Signature: xi6pdrz8uye4thc7zg4cjcuzc7oq35yx
X-HE-Tag: 1764343048-360605
X-HE-Meta: U2FsdGVkX1/UYkBWChybIz+NF/JWALLvuwEgsfbN4DSxB/sXmPVzuHv2vvm6g0UbwAgyZk4UQhZ14DIvMjyamOHuwisYw1ITjAjMmY2aleTOWapM+Xd27mAAUcAQrwKFLvFsMCxUTwmqsLWK4f0mVNff0Rimrw8q4JCwsewFxB91d4uhtpdcBt0/JLA2iyfglkjdbPmmTcj+NZ5dF1muzlhdtNEBTfwodXizKd94UwhAQ565Ykp9deXYPJd1aZBELyFoNWn6ndrqzjkli8fMEWQNZFucqzD9oGBGjSasaX3zczZjpJcomL4mWXryQFWNkqFTY6OhLiYQe9MeFvnlk7eTy2/YbCSuSFDxFdunbpDX1BHv96fSZ9LO1phm7Uy6KOfqekUmbS6+0Cqq0Niups7iCEEaYv+/5eMdx9Nm3ql98xN2bxjFDZY8gxZkEMPTKczYCLSJ2/HmDkZtkR5/mvYBc4bbRJfgOa9atckrzK7VIJDuxy/INcrxUYjq+f4zsWQaE7LztaLm4sLBilfUqQljcUQOtyocXUbYnrc3RompMCJlJH0XVChIiQNHPSxn0b/pFpP6wU0QErwhKc/onV+2YJlhETWPhy+2+PF6fbtHGEx81Y/F0dBeMFNHEIQsU35EQQMCQXgDcp2N3z2Ipr7LU5FZxOmukInkME7eJN4yqIRPvu2Y8g8+xr7X7gyQWlY7cP/Gro4JySt3jpCrV+n97JLW9vNf972Pl+Dlhb0K0SvVPhqQPihGPO3Hnqs4Kod69SfCNObfv++5c7qOk7PbtJH+ycALxq+q9gXPLMl77EaG1Rr0u7DZvaaJj+CP1QINzF5VVPgc51typ9gGVOqRPZ2FZYDx9Ia91TFIEwCwuRvylNQ37fsahLqt5B0srkS1LDZmvpq1TzXdKx1O/UZZXpNqDZpUc+7FEwhzEblvmAeRe4e112g9BW6UwcMoO2lrfUmUbtlSzkgck/O
 6mSBSFJP
 Cb+VG0KP+yV8wD9kNgUchVFAUeTsVJJ/s25MbI6mCdw3Ca1ZfWLb10EAKar8Qjt2Ds/L2aMPNLv3RIysyQc4CEQm3mdVQ/RV3dSpQrztTAAMFl86SxcE59Uf7uT18SZfEO/YDO+nsHxaZUeAgu7m0GPDiw27SpKOuv97Tnxh1Y1+g/tme+0mabN113DE3jqpyaOE+KqpjNoVYFC0iXsKvyvWcpkOfNWH4iVNJTwNupflfpQRTi2o7LIdgv2V4tTH2NLFHz1rYRPaA/ZjE1PFioBfG6M3Xq1sfCmPF1L6WAI7VXCAXjfMUsGDsF7CeMpTfrFE8IEs+flNI+qcJCL/wza5axuVZhJy8P8EJwtD8nRVz2YMou82YUDgD+tkoWPL15QIHZuUyy8yl5m1BhNz9ABENyovS96ufyLHw6pupeugTvHtYiXrKQpeF14OFhv2DCUf85/XO60zvRp6p8FTGCS6XwkwYEUElwyhRpbnDxj/m+WPFm+pE20/j6sCmaDovbrYRZY6n4V2F9xcuLmqgqWgW+9dQBBQOBgbPI2U8Av3DigODXUnlq4MWpmkrOAxa1ypgVhqgShEj0cnT51sPXPYj60WtIPJi5CyspIyLvKBH2pAqteOJ2KGWRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for your review David.

On 11/28/2025 8:01 PM, David Hildenbrand (Red Hat) wrote:
> On 11/19/25 15:06, Tianyou Li wrote:
>> When invoke move_pfn_range_to_zone, it will update the 
>> zone->contiguous by
>> checking the new zone's pfn range from the beginning to the end, 
>> regardless
>> the previous state of the old zone. When the zone's pfn range is 
>> large, the
>> cost of traversing the pfn range to update the zone->contiguous could be
>> significant.
>>
>> Add fast paths to quickly detect cases where zone is definitely not
>> contiguous without scanning the new zone. The cases are: when the new 
>> range
>> did not overlap with previous range, the contiguous should be false; 
>> if the
>> new range adjacent with the previous range, just need to check the new
>> range; if the new added pages could not fill the hole of previous 
>> zone, the
>> contiguous should be false.
>>
>> The following test cases of memory hotplug for a VM [1], tested in the
>> environment [2], show that this optimization can significantly reduce 
>> the
>> memory hotplug time [3].
>>
>> +----------------+------+---------------+--------------+----------------+ 
>>
>> |                | Size | Time (before) | Time (after) | Time 
>> Reduction |
>> | +------+---------------+--------------+----------------+
>> | Memory Hotplug | 256G |      10s      |      2s      | 80%      |
>> | +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      6s      | 81%      |
>> +----------------+------+---------------+--------------+----------------+ 
>>
>>
>> [1] Qemu commands to hotplug 512G memory for a VM:
>>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>      qom-set vmem1 requested-size 512G
>>
>> [2] Hardware     : Intel Icelake server
>>      Guest Kernel : v6.18-rc2
>>      Qemu         : v9.0.0
>>
>>      Launch VM    :
>>      qemu-system-x86_64 -accel kvm -cpu host \
>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>      -drive file=./seed.img,format=raw,if=virtio \
>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>      -m 2G,slots=10,maxmem=2052472M \
>>      -device 
>> pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>      -nographic -machine q35 \
>>      -nic user,hostfwd=tcp::3000-:22
>>
>>      Guest kernel auto-onlines newly added memory blocks:
>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>
>> [3] The time from typing the QEMU commands in [1] to when the output of
>>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>      memory is recognized.
>>
>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> ---
>>   mm/memory_hotplug.c | 51 ++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 48 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..aed1827a2778 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -723,6 +723,51 @@ static void __meminit resize_pgdat_range(struct 
>> pglist_data *pgdat, unsigned lon
>>     }
>>   +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
>> +            unsigned long start_pfn, unsigned long nr_pages)
>> +{
>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>> +
>> +    /*
>> +     * Given the moved pfn range's contiguous property is always true,
>> +     * under the conditional of empty zone, the contiguous property 
>> should
>> +     * be true.
>> +     */
>> +    if (zone_is_empty(zone)) {
>> +        zone->contiguous = true;
>> +        return true;
>> +    }
>> +
>> +    /*
>> +     * If the moved pfn range does not intersect with the original 
>> zone span,
>> +     * the contiguous property is surely false.
>> +     */
>> +    if (end_pfn < zone->zone_start_pfn || start_pfn > 
>> zone_end_pfn(zone)) {
>> +        zone->contiguous = false;
>> +        return true;
>> +    }
>> +
>> +    /*
>> +     * If the moved pfn range is adjacent to the original zone span, 
>> given
>> +     * the moved pfn range's contiguous property is always true, the 
>> zone's
>> +     * contiguous property inherited from the original value.
>> +     */
>> +    if (end_pfn == zone->zone_start_pfn || start_pfn == 
>> zone_end_pfn(zone))
>> +        return true;
>> +
>> +    /*
>> +     * If the original zone's hole larger than the moved pages in 
>> the range,
>> +     * the contiguous property is surely false.
>> +     */
>> +    if (nr_pages < (zone->spanned_pages - zone->present_pages)) {
>> +        zone->contiguous = false;
>> +        return true;
>> +    }
>> +
>> +    clear_zone_contiguous(zone);
>> +    return false;
>> +}
>> +
>>   #ifdef CONFIG_ZONE_DEVICE
>>   static void section_taint_zone_device(unsigned long pfn)
>>   {
>> @@ -752,8 +797,7 @@ void move_pfn_range_to_zone(struct zone *zone, 
>> unsigned long start_pfn,
>>   {
>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>       int nid = pgdat->node_id;
>> -
>> -    clear_zone_contiguous(zone);
>> +    const bool fast_path = check_zone_contiguous_fast(zone, 
>> start_pfn, nr_pages);
>>         if (zone_is_empty(zone))
>>           init_currently_empty_zone(zone, start_pfn, nr_pages);
>> @@ -783,7 +827,8 @@ void move_pfn_range_to_zone(struct zone *zone, 
>> unsigned long start_pfn,
>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>                isolate_pageblock);
>>   -    set_zone_contiguous(zone);
>> +    if (!fast_path)
>> +        set_zone_contiguous(zone);
>>   }
>>     struct auto_movable_stats {
>
> Agreed with Mike that we should keep clearing+resetting the bit.


Got it. Worked with Yuan Liu to understand the risk that if set the 
zone->contiguous before the pfn range fully initialized. It seems 
pageblock_pfn_to_page code path could be affect thus potentially it is 
not safe.


> Also, I don't particularly enjoy the "fast_path" terminology. Probably we
> want in the end something high-level like:
>
>
> bool definetly_contig;
>
> definetly_contig = clear_zone_contiguous_for_growing(zone, start_pfn, 
> nr_pages);
>
> ...
>
> set_zone_contiguous(zone, definetly_contig);
>
>
> We could do something similar on the removal path then, where the zone
> will for sure stay contiguous if we are removing the first/last part.
>
>
> bool definetly_contig;
>
> stays_contiguous = clear_zone_contiguous_for_shrinking(zone, 
> start_pfn, nr_pages);
>
> ...
>
> set_zone_contiguous(zone, definetly_contig);
>
>
>
> If we can come up for a better name for definetly_contig that would be 
> nice.
>

Instead of a bool value, could the clear_zone_contiguous_for_growing 
and clear_zone_contiguous_for_shrinking return a enum value to indicate 
one of the three states: 1. DEFINITELY_CONTIGUOUS; 
2. DEFINITELY_NOT_CONTIGUOUS; 3. UNDETERMINED_CONTIGUOUS? The 
set_zone_contiguous took the state and skip the contiguous check if  
DEFINITELY_CONTIGUOUS or DEFINITELY_NOT_CONTIGUOUS.


Regards,

Tianyou



