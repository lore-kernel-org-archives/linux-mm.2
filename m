Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F61D148A3
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 07:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A7C6B0088; Thu,  8 Jan 2026 02:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F22E6B0092; Thu,  8 Jan 2026 02:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9AC6B0093; Thu,  8 Jan 2026 02:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 060586B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:35:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A87678C086
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:35:45 +0000 (UTC)
X-FDA: 84307987050.16.442706C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 72905100009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:35:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cCsfhH+T;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767857742; a=rsa-sha256;
	cv=fail;
	b=BKrlxJx3jz5ZguX2dR7JJOM9FdhIA59Di/q16ai8Xi3Wt/6BFJDwO/kqkNebj5jtUh+Pnz
	R6aaQDFDL88YgFxupibiuFTKi0lQRpAd+OTOFNqpaUVdK3gRplfTuJVKxYUCTyIKkrnI0r
	989BVwUjA4oS6299NErwu+ueGblJgAk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cCsfhH+T;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767857742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiI9uTSRJ5NxvDVfjnJNoVmK/8B+P1PMneBBQrjMwcg=;
	b=xu7L1F6CJ29IamBvfNng6aVm5jJHn8HTTxSWUSSuJroJE8diSHLZOMeDUuVA28FzZA4H6T
	DVD+tlq43UlHQ1RtWShzse+7icvK5k61FfAuxmKu/0CIKNuo9cBcSSJV8fHxH2s5Uu3bp2
	T+SE51RsyJDFZ9t1n1XWzVYXpTz+TY0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767857741; x=1799393741;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kvKxp0U1Pch0YuH7jSUjdhP0rb8pGyxI6eauXTjXujU=;
  b=cCsfhH+TVT7tILFJYXtwfwbqAKwZMax84EG+nfxfPxwjLDVGdwa9ZoTX
   N8TUv8caF+AsQ9G0NLnk5O3aUR9EtwnGKmXPF5AV8ghGMSzs8/ITC3XYi
   kCXpnUcuCYxYD39Mhq8VcQMP3/Z06K/ByHY3WvfAl9brDEs/KDO9qrAzl
   KloGLxcJpmj7CurEsTo3HOwyMgYtJ4O4ssn8VPGLTeb+tdnbTIZQv4vkf
   q+WTTnN8adK6MjWAqoMlcV3I1D+eapDFlFT8DtTnMhzsjXded21PiRj1s
   vFcNxSXkQfuouf5sDXCxqeqIf9STnT3juceU68e/fNFuAyP87Hndxzfmu
   w==;
X-CSE-ConnectionGUID: bJh5fPfVRDau1vD8JROw1g==
X-CSE-MsgGUID: 6O2mgyfqRwWAj7wmFAZwfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="56790463"
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="56790463"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 23:35:40 -0800
X-CSE-ConnectionGUID: B/M2M5uxR+2NVVds9aDvLQ==
X-CSE-MsgGUID: MQsI1V5gQ3Web5SBWMLv6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="207666743"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 23:35:40 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 23:35:39 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 23:35:39 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.67) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 23:35:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V3GeMYbgjg3s+y/J+czIHU6RALGVyTCCw0s8C4dy/YQu8Wlk7DXraNGdUYm7C2uoGJvFCdlqYx6pydctD53bi4XAoGYFLHl9ZOtvxbpqGHNJKGKAo8FLA1A8lRCGPO33V4auw8zNXLhN6gtZCJn4As9GGOehErG0H1L9igOFjhR60rM/Vs5ox/OYYb2YJDwdwzHFUmmpCrHx8zgU4/GZznoSyp+JaH+bDx6cMIu+sYkz2UNX7fpn1lH3igKfYZoCAr2tjWLjxLdNuBXhIvUZv5Xtdzqq6qJEZcbAFJ9BPKlhbSltfq/uWUgmk0eOGoLuIJqbRyyTBKovX+7Yqp0Q+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiI9uTSRJ5NxvDVfjnJNoVmK/8B+P1PMneBBQrjMwcg=;
 b=K0I6Z/oAljXcT+B21U6qV+gcOsg+ACtW78pRhq+RHWBjlITVS5vCujDCcIFSpCMi9bT/NrGowOd2+LpRpOrQFll4MJNP9HBePRqC8qy/xBF4dI9sl4YRWvfvVDnTAbRWJoLZJ5TaAK1A5hQw9YWDaupiKhQx2ol0BuQUpqIHewmehLghAGkBECFhKfXPZnGEghlPEKGjKydew188BWgMV3Z66gPhyO8wvXAtS381+oWi5ASmbHwTtP5iCfZZe0IaElfZ9D6NDeQ86o5VTvPAs/faPvY3xcTsSMcEg4Ii13xvFS1e368vRemMUlOf1MdpsjWe9TAJnQ9sX24LyVRcSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by IA1PR11MB6395.namprd11.prod.outlook.com (2603:10b6:208:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 07:35:37 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 07:35:37 +0000
Message-ID: <4b9b29aa-b643-439e-b71a-be9f9241b384@intel.com>
Date: Thu, 8 Jan 2026 15:35:28 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-2-tianyou.li@intel.com>
 <857be078-1464-4e29-979d-0459cad8508b@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <857be078-1464-4e29-979d-0459cad8508b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|IA1PR11MB6395:EE_
X-MS-Office365-Filtering-Correlation-Id: c6ec0bc8-12d7-4341-3827-08de4e8883ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGExZWsyaEwvTldoTlFYRlR2eUJXSy9SODZvY3RLdDV0RldlOVdMN0s3VnRW?=
 =?utf-8?B?M0ptc1JHTVJUYnVMOFdQT2NPNzA4UTFMTXg0Z0ExWElzdEQ1ZkhhUzFHbFAw?=
 =?utf-8?B?K0JLRUttcTh3bmZoOW5BU0NoMDFJbGg3NjVZY05lbUV0SFd1SnFWM0lOMVVn?=
 =?utf-8?B?V2RsQnlzaGlBZHdlcmNMVXpWM25qVitkYkxrK21kSm9wWjcvMGpDUjcrT3Bs?=
 =?utf-8?B?MDdOTnJSYitZdWVlSXBYNk9mUDlJQStsZWVVRXVJWHlTcEJybk9peVM0VENx?=
 =?utf-8?B?Y1poaHFsS0drZk5iVmlFdmR0UkdNOW9xUDZGd0Z3WXA0MUFJZ040bDFWa0po?=
 =?utf-8?B?SU1SQmNTYWxPb0s2MmpRV1ZQUUtGeThTN1crNnlWQWlzWEtWalhnYmQ5WXRn?=
 =?utf-8?B?aGd2N1FsQjEwdmZidHhyTlBLcDFTQzRRRnl2VG9sWjdIT0ljMWc3Q0tDUjl6?=
 =?utf-8?B?KzFwdXFZWVhBZ3ZaenlhWGNwRUN0bk5IMlhrd00yd0p1WWRkZFNxelV1aHdh?=
 =?utf-8?B?VXY2Q1pKYnlXVXYzejdWZ1ZvTDhPWnRsUnlXT0lOcmpmdnZCQ0pnb0R6RUlI?=
 =?utf-8?B?b3QyRVR6TTZrQ3VCRTNjWVFUanhibmpsTC9VNzIrQTE0cjNFQXY3bExyTCtJ?=
 =?utf-8?B?aDBpYkNxNzFpeEJaMzlTMlRRUFBkdkdzbFlXbFgzQjZnOGVlRlI4NHliRkJF?=
 =?utf-8?B?RGgvbXRuRW9ueGxYUDhuMnYzQk1EM0NsTjFlUXFhOHNYTTl2Zzh3SEUyd0hF?=
 =?utf-8?B?ZXROWE03VVRsY21LWGpKb3VqMFVmUGYrT2Z4SEtMVFFhS24xNmczL0psWG5Y?=
 =?utf-8?B?SDJpR296UHNIQzdSVkdyR1pMdzFBODFwU2hKM0JKcVoyNFBqMXdqbXZGSkpt?=
 =?utf-8?B?RUU0Y3hwTzRQNGtKcDRYZU9MUGhyRENKaXNxUW90em5UdXBudHVFU1hVTlM4?=
 =?utf-8?B?c3hLUzBSdGlZMGY0Q2dNbzNqS0Y2bk5GVklGd0JCSXhhdmsxSHZkcHJ2bmFJ?=
 =?utf-8?B?NE8wRXpTVi9nMHd5b2hTL0lpR3FvSy80THJSeGxvVVpiYnJiUTdsTjhhQXZF?=
 =?utf-8?B?eUEwSUxvNDJuM1dsRFgxa1Nmay9wS25uUFBpanJuRldXWWhuaHVaNjY5RWJW?=
 =?utf-8?B?NXdPZmxVOVQ4V1RpbEVpSXV2d2JjMEZqOVFhaU5FNnIyK2s1MzlrTkpPdm9E?=
 =?utf-8?B?VHRvaHZyV0M3L25SSFJ5ZVlSNTBydWxYazkwZFl1WmtnbGJmVVZvNHNteDR2?=
 =?utf-8?B?R3pRRnIvT1NOa1RBRmhBMWk1VUljWkpsbmg4SnZnQjJvVWJ2S29GOWdibjB0?=
 =?utf-8?B?RXROOXp0VlB2eHp6RXNwQmxzTzZXbFJTSVpkTEtTZmUwNHVoNkRMQjgwYkR0?=
 =?utf-8?B?WitCeklQUEpTdHlPZDNxcEdpb1lDdEE2UVRHNDZVZzBkYTR1V0FicUs2MU9G?=
 =?utf-8?B?VW5Cdk5XZDJxV3dTakZDdGZCZGphYlBJZlNRUzZTUThBL3orYjIxeXh3L0xx?=
 =?utf-8?B?ZGxoQ09RSjRMQ2I3N3oyQUNmeTkzN1p1ME0rYmpxemZDamNEN0F6dlBsMUlm?=
 =?utf-8?B?cTcweDMybmFXYjFpMlAwT0FNOUVkVDVnRHRWUGd2Y1UvM1FRbG9EbVp0ZDZT?=
 =?utf-8?B?Y3FFVzhCQkZmU29QMEhIajJGbTJEZXhVamRwNE5INUpWWHlsZ1VNUGNQdy9w?=
 =?utf-8?B?R01JQzFjN252ZUFhUnBkUDdDWmZUOGJGeEY4aTQ2clpSTERvM2R3N005TmZJ?=
 =?utf-8?B?b3ZHOTRnL1pvRWxFaWNWZzhBeVNtbnZrNXhtSmVHN240SmMwdk9WZDdZK0hy?=
 =?utf-8?B?Zk1IcXkzVW9uM1dhUnhzU3Y5d3RvK3ZWanBjTllucEtTVnNjNUN6eVhsQ1cv?=
 =?utf-8?B?blZGZ25zNWRvUFFTY1J5YzlnVEtyaFB0WjVmSmhIeVJUaktHMHpiVzBHMENk?=
 =?utf-8?Q?8RPwYxczm2vhDT3ivIaaiJh0cJejWLbP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUxRRG9nZU5QL3hSU3l6QXhBWkpsVzJXTXpIajdoVzdFbzk0SjR1ZzY2ZThu?=
 =?utf-8?B?OFB6WTRGSUIxdXBRMjRjTG5FQXIzWm9GOUMvRTN6Q0I4SkhvenY5QjZVT2Vy?=
 =?utf-8?B?aEJ1MnllcWEramNaUHVQZDlCbVBMY0R4Y1VraW1ZTHpKZ1BNenBKMkVMQkZ5?=
 =?utf-8?B?Qm8wNmJ6dXpDTmhMNTF4ZCtGbmtFRzYzeUFad29CRldjeXZ4dW9YL29OMzd1?=
 =?utf-8?B?OWZwenhWQS9tWDJmcTN5RXdBYjc0Z1ptcGxwN2tLMW5pUWZQTHNzbnlrZnl5?=
 =?utf-8?B?OVAzOGErVDFLeGVtTHo0c1BrVCtQNWJjT0x6R0NwajVtdXcyRTlnZ3JwcE9Q?=
 =?utf-8?B?SHgvREdtSEx6cS9uZUU3VTRqQ3hXZVVUUUNSZ09ncU0wQlVMUVJrZE1HYUNz?=
 =?utf-8?B?cUNFSXltbVMzMVMva3NMWkY3RkFsWGs2WXBpMG5WUGNmMmdTemExWUxLNTRl?=
 =?utf-8?B?TVFrTVhxWXhRMHFlMzVoYnozeTZTM0wrUXpEZDR2SmRLdDMxd0RVWjBMelVI?=
 =?utf-8?B?SW9FK0ZYZXhVMktkR0YrSS9UUFAvTG9aU0o5aEE1ZzNRaHhqMEpvcVlEckVp?=
 =?utf-8?B?WVpGL3U3S1RsNGJCUmFHNTdZcGRQbE5ZTEdCalVNMGErRnZydmYrL2hyYktS?=
 =?utf-8?B?SkJWNzgvSGxTTytoSGNnMW9zK2F3aUdSSktzT240TXo4dms1MTFoNEVHZG1S?=
 =?utf-8?B?MWdkTytjSkN1dTVMbUNkbzlMSEJkY2NHSVhoc3ZDUlFJbFMwZExwMkFobWdE?=
 =?utf-8?B?RnJ4dyt6UlNXeDd3QVhsZ3BVcXRsREQ0cklkUXRxZnFMZTlXT2psbjY4Wjdk?=
 =?utf-8?B?ODNHYTFKUkF3ZGtNd2RINXBVTE1DdXRTSTA0TnpsMFRPQmpOV0dqbkp3U0dm?=
 =?utf-8?B?UWltcklsa3NyR0VOMk03b2RXUUE4L0tyQ2ljaDh4RS9WVk1pdHVaSDF2OWRW?=
 =?utf-8?B?SGUvMUx4ZWY0cEJnT01vTWo1Q1AvaS9vQ1ZORHhhRllIS00rNGdvOGRpU2Rz?=
 =?utf-8?B?a1hGMis2QldqQmJqcXo1NThaa0FNcmZ4SHNHd2NWTzRUd21VV0laNnNTUnVE?=
 =?utf-8?B?UnlDMEhHRDBselBlWUNGT2JML0xxcGNtSU54ak1RTzZzcUVLaE1sVXFneGhF?=
 =?utf-8?B?SFppcVZDaHRLODlvRkdsZzRTdmp4L0NKblFxc3Q4MzR6QXZLWjN3R0FsRStN?=
 =?utf-8?B?OUpZNEpkZ0pkOHh3dXVJR2dwdkhmcUJVb0FJeEVVaEY1YzBwN1hKUjBYeEhT?=
 =?utf-8?B?a05TOEZ1L3V3eEpXMWU4SnlFSklDS3lqUnFOSllJZmFqOVhhRENwTzF0OFFh?=
 =?utf-8?B?dkQzTG93MFcvNkZFSUJSVHlqTlo2b3duSGh1R2d4akdtVHBhMktzTFFkUStT?=
 =?utf-8?B?UUhneEtUVmsrd0J1cDh6N2d4dE9IWEdNSVhyR0d1bW9MMzU1UlBMQzdPV0Qv?=
 =?utf-8?B?dmdJQ0NNSnlnL2JDc1RlV3FDSkFzRTBOdi85bE1VSUpabTEwMCtSRWtZSFcx?=
 =?utf-8?B?OTRwNzdzOEFRNHVLbjdUVWQ1NHpQMVY4V3dCTVJSeExpQUhHb1NrRERrRmZD?=
 =?utf-8?B?a3NoL3BlRWgvL00xeXd4TWtIK2xwRU9KdnJ6V3lxOTQxQXRSRUpYUkp0L3My?=
 =?utf-8?B?N2sxN3V1WGRxOE1naXRDK20xOEI1Nzd6NTJJbWx0eUFuVDltVlR5OFFneHZF?=
 =?utf-8?B?SHhhWFBzU29FdTBOTG1veUN2TGhPUGV3YVJScU5xeGp0bmE5OEY5MzUzaFVI?=
 =?utf-8?B?MFhmN1F4aDNITkNTeEl4NVVtUkl6Z0NyR1RVc214SmFwNllWNjlzd3NUZU9k?=
 =?utf-8?B?YlFRK0hMeHl1L25yNElGSTVDcXdFVkZwR0tUUVdDVUhud2NsWldrL2wzNGE5?=
 =?utf-8?B?a2k1RTI5bEh1MHRzS1lwSmMrT1Vud0xUK0FPajBzZ3FYdDFkZDBlUG5tdito?=
 =?utf-8?B?K3JUKys5ajlZWEVjTUs1U3NzTHFZY1VQSTlzbWk5VVVjRTFVNTdNbHVIVXQ5?=
 =?utf-8?B?eGI1WUw0b21iK1lBZUduVGRnR1RiODhUSExXdGdpV3E4c1dLUnJYbjVqaGww?=
 =?utf-8?B?YWNOU3puSGZYUzhudXRDeklIZ052SWhtM0xSZWdITXVsQnVWYU5MQjkvOWh3?=
 =?utf-8?B?UGcyZnIrZkgzZU5tVkU5czJndzgyRE1LTzhiZkxzakRWUmorQWFuVHRYaWU2?=
 =?utf-8?B?bnNtVHhGUHJvYSt3cDRkNDFvQXc2OVFRVVhaSVFjbkdydnRSUjRRYURUQ3A2?=
 =?utf-8?B?NXAzdFVpUXJubUpiWSsrV0dObmtxNE5RZHgvbGJyN0M2SUdiMll3emtUc05L?=
 =?utf-8?B?d2NZU2tacGR1K3BNdnRmYmlkRzJRWklwYU1OZVYwenNnQTR0QTNPZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ec0bc8-12d7-4341-3827-08de4e8883ed
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 07:35:37.2095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFFLng5pNJtdikQSq0SWKy538ixCCbuLimmG6F8euLsvgeCObqO+FUdXt46L8FFORHM6N56anRwPvDZ+TvlqAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6395
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 72905100009
X-Rspamd-Server: rspam10
X-Stat-Signature: 1wak6caywn6b9ng8dcbt1usgs549rsbb
X-HE-Tag: 1767857741-238841
X-HE-Meta: U2FsdGVkX1/ySp8RX6+NXuPqok9z9ulNAOYWznCT0uHfY8x5oQSUeDbhAWl5Pyh5i5KHNjUcpxqzuVK1+C7pLeM2KK/AhsxOT6ifHndU/0nB+lTYvV0EJzSN48n81zweetMiFwfPuOI28uhkPesWo7kGJFlIb7841d2MJG/4KCtEzgxcKjGieK0clEUl+JqIxbdF25SHVmpBqNotf+FzUc23K539lc9SVcglsW6VAujDqIBji1cqGNMJWs3Gx+iKVYjPHpfj/4uxp3jwsv2dDAZJ4anbuwbsPXPyeTzxdUq10gf+BQNNOKfALiZKFewLRQRMyOSG3of+eS4Js/FO3YYHApZ25AdScvxcvSsIrwHerZ1g/qgrSLLsw+d7LSzsLj+S0DAsfZUk6K2gAgMHFuWVzkTJQ1jW1QxoQ+izxQfjX1/W2iHf8NPA6LXjVgnJv0fQ0D/7jkw1ZoPgcwJh0UG2Ss5tUcWYoVnbpjKXosJ10jeATnET27ECHwp0DiRynQKKrBJVD8aQvvtoFZWTJHK7iQd/BDWXih3A2qdOAQZ38xZgs8HH54w8hFqQUSFMx6Leyy3kGqhg5KXAf1620grHJE6B5EF7LINfueYu3sdqvw0ioDRWGO7KLUHPBNXjYSdKVCF/cWDr0Obgczp5nPQdPrQMg8fKDAne83krGWMYFw0IRR8xF0ZS98yEEwvjhjLSKA00CTrcv+UC0Sf8by8ZUOHcCp1ZvnYw22BSco6oc3TaCn/iK5a1Dt+4/omZvuY3O+4Zmlsquet4rsCJhidYAnaNJylRtnSmyyhxNRQx5PEbPjBDLPAePHQPJ4MCCbxXg+1cG42yeWluTzi/5nemlTAHUJNKm4oCfJxHrmK9WW/nMGlhHP6esxjVHtgEubcAxnl2+VqBRvYRqkk/p0ce91AnF49jd1S6o86qJEkST/cOT7SvoHH/AFCCyXr/KviLhm+T+D/wcvM6cZQ
 4Ae0+bI+
 HtKHCoEv4cXBXjDrTNYnl3W6azi1DbfVvh/kqmtAVwL2l7PBy2CLntfiOjj1ceSyusHpmY0rpQI20BO90VCMVjr+Gzo1LnOKW2RKCY46ZJpEpR978T6/1EPHpg1i3uzXb1yPlxXV5QQqPOdjTtNBubxAGtflmzW+ZKBMsy5MghSIkjk3Gc43xhgHsXMvoRWHmmsyK3M2VztHkaNYOi1FFvXGq5TLIh3M/xNQQCMagcsgqHf0r21+/sAYDjT1oPtubNg23swlDCCCMtZnm/OqcUJB8s3rKFCRBWJjsD0ZMR++I/DNhq7ousEgyEgMMz2dvVweMnEkcW4qNRFIHkW6eU33ftHtCHEBo8vvJQHCIMG0M9ojXDZ9iOf7nertAuLlj8I7rv5W9ZDMkWtqTrFrQtp5HGAbd+apynMKtDahNoKtAwN+TTep8CMqCjtRnZ8Ve1kQM5ZplUipndedkULlOkZLHsf/thFxKAntBoAyXiNuLq3McSfjuYZEzUF1sdujQf8Kh6aHw2O2fmUeT+RgP79AUL8kYMy0ZpnMbQLTCpoAZQX4hoF5loVfxTsqjML5w9PabhoNWpJmz/aRgcLDDxoSX8UeESzhIuMQIkI66os43O3A6ryQKa4DBnnQH4/zqbM4G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Very appreciated for your review David! The suggestions you made are 
clear and the code/comments you posted are well formatted, I can even 
copy/pasted without modification. Thanks.


Regards,

Tianyou

On 1/7/2026 4:03 AM, David Hildenbrand (Red Hat) wrote:
> On 12/22/25 15:58, Tianyou Li wrote:
>> Function set_zone_contiguous used __pageblock_pfn_to_page to
>> check the whole pageblock is in the same zone. One assumption is
>> the memory section must online, otherwise the __pageblock_pfn_to_page
>> will return NULL, then the set_zone_contiguous will be false.
>> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
>> memory section did not online, the return value will always be false.
>>
>> To fix this issue, we removed the set_zone_contiguous from the
>> move_pfn_range_to_zone, and place it after memory section onlined.
>>
>> Function remove_pfn_range_from_zone did not have this issue because
>> memory section remains online at the time set_zone_contiguous invoked.
>
> The description is a bit hard to follow. Let me try:
>
>
> "set_zone_contiguous() uses __pageblock_pfn_to_page() to detect 
> pageblocks that either do not exist (hole) or that do not belong to 
> the same zone.
>
> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(), 
> effectively always returning NULL for memory ranges that were not 
> onlined yet. So when called on a range-to-be-onlined, it indicates a 
> memory hole to set_zone_contiguous().
>
> Consequently, the set_zone_contiguous() call in 
> move_pfn_range_to_zone(), which happens early during memory onlining, 
> will never detect a zone as being contiguous. Bad.
>
> To fix the issue, move the set_zone_contiguous() call to a later stage
> in memory onlining, where pfn_to_online_page() will succeed: after we
> mark the memory sections to be online"
>
Will change accordingly.  Thanks.


>
> Now, there is no need to add the handling to 
> mhp_init_memmap_on_memory(). Note how mhp_init_memmap_on_memory() in 
> memory_block_online() is always followed by online_pages().
>
Plus there is no dependencies of previous zone contiguous state for the 
set_zone_contiguous now, it totally makes sense to remove the 
set_zone_contiguous in mhp_init_memmap_on_memory() as you suggested.


> So, it's sufficient to move it after the online_pages_range(). I would 
> also add a comment there saying something like:
>
> /*
>  * Now that the ranges are indicated as online, check whether the whole
>  * zone is contiguous.
>  */
>
Will change accordingly. Thanks.


>
> Can we find some Fixes: tag (which commit introduced the regression)? 
> Likely we want to CC stable.
>
Yes, probably we can add the tags as below, where the pfn_to_page() 
changed to pfn_to_online_page() in __pageblock_pfn_to_page().

Fixes: 2d070eab2e82 (mm: consider zone which is not fully populated to 
have holes)
Cc: Michal Hocko <mhocko@suse.com>



