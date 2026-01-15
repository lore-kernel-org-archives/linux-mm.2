Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C607BD44C63
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363A36B00A4; Thu, 15 Jan 2026 10:09:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306F86B00A5; Thu, 15 Jan 2026 10:09:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DC66B00A6; Thu, 15 Jan 2026 10:09:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 036306B00A4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:09:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A57451B9A8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:09:35 +0000 (UTC)
X-FDA: 84334532310.10.BDA3044
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C13E1A001B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:09:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HU8wgar4;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768489772; a=rsa-sha256;
	cv=fail;
	b=FD/XxgS0uX9DUarFZWqi2IBP8DjqXdj8QbnS85QPNc3ShO49hmMk1WhrhbW9SmFErsOdVB
	UR1JL5RNpSx8fOVnrLVavmXmGQrE2IMijSGPHzU8v4CRWdmZqAI9IzL4dOUxYxp4or9q31
	vyZxzljNc4a8ZP/koVGvs/SrZVHzK60=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HU8wgar4;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768489772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r00f0gPq1SfRtg87KvDwkgBpBCmMrx5Q1lBx54RB/aY=;
	b=ZNwTQOsaXpE3niLk1AgIOyO5kKUCTsoBoli8TV6owllwEP/YaHf7x+1xNmcautRrOzVW9G
	DVbcLprM/5nNVsRGozfWi04j4mr68EOiU9+D6gsdJ4iv6dUw5YyCrMSXLfFo4AkTfgL5m1
	GEvXwCksArenpNTDa5ewcSOwhgXLmbc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768489771; x=1800025771;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LrSojkchd2NpOb5RCIF8R97gSDaqS3HgR5aCV8DRQaA=;
  b=HU8wgar4vgc8gZf5xRSnt9xSu0GJAB3ea9tFIbztUfrbPUoEdToD/9fq
   qJyUfk+ObMHEQpXMS119lm/zl8WNDFEpOghW14PRuu2Irz/WvQo2U7NDa
   akkgqhq8u1GgGMx50UPxQpuIWfD43yJM/o2Ihjax9R1COOL9cPu+YyF3f
   ida/zj7o8UaADlnKgU8A6NkaYOurev4P6TmZ56+KAQcC1EPevPuWmfKtf
   Dozy7gqcl+rLmmYNeAEwtH8MqnTscpMdTwAWd7SfBO4w1rH2xw9adAWjl
   JfEW9bthQnmToL7+0ld4BfvXXuCgXvLTY3l400SZVU8FL1UhP4mDBEpO+
   A==;
X-CSE-ConnectionGUID: 3Ob1Fw2WSA6dOf9pxY4RxA==
X-CSE-MsgGUID: OBjyKvQ6S1e302Jg6Chw9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69696289"
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="69696289"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 07:09:29 -0800
X-CSE-ConnectionGUID: RD8Qar/WR1yI86yCrrYNCQ==
X-CSE-MsgGUID: mB9VEDaIQ3ySuIymPLb36w==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 07:09:28 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 07:09:27 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 07:09:27 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.22) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 07:09:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXSpDCt5qXwsyVAwl8yslgxBJTbTkiiYH5CRQCww7tLyyHSyjgERrPOdWCNVE/FcO+1ld6vrrWS5Slx1kQKSiQQfPOzVHFcTEh3Uc7NqjfYNBjyBiLawPmL3mX7DYVy/fnfUVGnzljJJqGB/BbwL3rmp1/wdE/ciR4su/9vowGAqB9bBLvreL7VmLLiG+KEkFWbZVbWFrcG1t7XBVHK7GwaTKeoqjsLiLvsHlYY/J4kc1tII9L1XPPCMrRQ+6BpMkjDIhSRR4VovkI3tpKZzPRAZ9z9j2cRsKOv+UL5a+JopsdP2QEmMZEKAcQzHrR9U48PBqzRcHsFPKaSpZbbZKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r00f0gPq1SfRtg87KvDwkgBpBCmMrx5Q1lBx54RB/aY=;
 b=q+CO7K/Fbmy6XtbteIpWqZaHn3xqZ1/Znja0uba/al5NVHWTvYkVuAYZF4y6vCvIYkYA8pjpbG/rkAa2SMyH71+73XkB/q1wfMHbWOSqcyQ5zynJ9MGcBpfFSmJnCkOnuO3brgraYlnT9O+Kyq3iyUmHOrTsGwzmgdxMxeOPZrjuYJqjHp4fPZktcPpcSLG00Gw+8bIH8pGyvai/7AaAiTn8UyR3AihvzHYY20pJIB7KOu9KYkqf3sjxFClfvcfMEAVKs44TQ0F2gAXLRT81sD5cSF8XRWqkmb/9SXfJWpEkRaShpgVtiFP+Tb4di2HILsSelHPDueVxMJEZ3XV68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SA3PR11MB9461.namprd11.prod.outlook.com (2603:10b6:806:47f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 15:09:20 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 15:09:20 +0000
Message-ID: <d97a8744-6d49-4582-82fc-a38ee2ae06fc@intel.com>
Date: Thu, 15 Jan 2026 23:09:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
 <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
 <e9d52093-d11e-4e0d-9bb9-88e0ffb78a19@intel.com>
 <a7da047e-0064-4f21-9f8b-fa4bcf40dca3@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <a7da047e-0064-4f21-9f8b-fa4bcf40dca3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KUZPR04CA0027.apcprd04.prod.outlook.com
 (2603:1096:d10:25::19) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SA3PR11MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: 04be40d0-9d7a-4a8b-d355-08de54480f17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VEJPYkhtUzZSTlk4SUNKYTJvWVI2ZDZkMFFYMGJzZmF5ZzZuUlNIdnZPc2Ir?=
 =?utf-8?B?TnVxbE9WTTVJUitLa2RiNm5UM3NoZndpVE5RWlJSUjd1WTBpeXJvUE9wMGZZ?=
 =?utf-8?B?N2dOWEoxYkVwSmdJMWtObU9XS1VsMm1GeVM1dUljSGJPTWZQTXVHRlBUVU5t?=
 =?utf-8?B?QWEzSHRVSHJzQnlKMkpaV2N4bzNBU2trSTNPcit3WVptSmV4V2NtTUNDbm1V?=
 =?utf-8?B?eHZKdkx0aTdvNENpRFdIZTFGRUMxSWRvTzhYTVlkUDZRSFFlYjJ2dFdVMGw2?=
 =?utf-8?B?ZzNWTWFEbk1JT1hZWHNsWGZuWWJuL202VGdsZTA0TTVmYitwTnNjV20zRVJJ?=
 =?utf-8?B?em84c004MmtMTzVNTDVLYUVtTTQwVG03WEtQY3FOUFNPZXVMR1BlRm9uVFZy?=
 =?utf-8?B?MlVyZXVrN3BVN1JSUUdVQ21GME95KzRpU3VUVExuYWE4b1R3Mkp0ZWwzQkxU?=
 =?utf-8?B?aGFCQ3lDUXlsVXVHb0xhd0NSdE5VY0VpNk9QSTN0VWRlQVBRb0IySmlEa3p6?=
 =?utf-8?B?RkhWWS9OdG8rY3VJdEZQU1grVjFUZVpmVVd4VW5PL25hWWRHYnhVOU83UTdH?=
 =?utf-8?B?TnkwYWJnY0ViVU1MSHhPaE1ac2kzVmJGdXJSdjYxNm9UWkdCdis4dDFqVGxt?=
 =?utf-8?B?aUVwVWRnTmxOTFA3d25zU1NNOHBWQmMvdjduUm5lWVdnU0FvaUkwa2ptTzhj?=
 =?utf-8?B?Tk5hYnJMcTZER2ZpdUlZODJEdHp2QTM2VEtMWWU0RVlmV040dmdmTGo0WEZr?=
 =?utf-8?B?TmV0Q2pZV2kyN1hWZ0prdmIxb0g5NnkzTm9GcVVneUdYK2VVUEV5UHgzckVM?=
 =?utf-8?B?QVJyTXJsQnBVb0orSm1MS05nbVRNd0cvRE9wRldyUmFqMklUbDZpVkM0OXFQ?=
 =?utf-8?B?T0pCMGtIQ2txOVJWZXJrdHhWZjV0dCt3UDNnM2tVbzBxZy9hT25uK0tvT1d4?=
 =?utf-8?B?MkpncjdKdWszL0d6MW1jdVkzNkxLeXljVXlYV0xCVGo2RVU3ZGFEcFhUNFcr?=
 =?utf-8?B?V0NlWFg3UFNYS2E0VWJWOW9FU0RsUkNsN3JLVFo1K1pGSEtIL1pCb2d4KzhJ?=
 =?utf-8?B?UkpIVitrd1Uwb0VLeHBJRTVIRloyU3BYMTg2NGlaOWh2dkdReVFnZEJKb0Zs?=
 =?utf-8?B?eGZiM092Ui9ZVGY0TnJtK2RUTkdIV2M0UlR3SWNET2cwbW9Jenh4NjExQzI5?=
 =?utf-8?B?TVhFVE9mcGxJOGxObVVUWE1YVC9WOThzWmdFOFhnQWRkQVZrL2NVdGo3R3Ay?=
 =?utf-8?B?MkQyejJScFEvSXNGai92cWo2NW5QZkE5M3ltcDhhcDV0Unp4TEZ5K1JWZUJC?=
 =?utf-8?B?c2sxZTVGK0lISVRoZlY1YkE2YXk0dG5iVDRja0hpV2c5djVpV0crUWpscEc5?=
 =?utf-8?B?M2RuSHh2TmQxZ3I4Q2h4OUNlb2k4R09iK1Z4aHN5MklpelZTR2hacjZkNGRj?=
 =?utf-8?B?djVGWk05U0J4NHBYK09RZlVKVEduTFI5cnJVUzFFWGhkQmdWUTlVdVFlMnJ0?=
 =?utf-8?B?ZkVpZUVza2Vsb24zczZHb3ZjSGlDSWhSdE5GYnI1MnlzaTZlNkYrQ2VMQ29F?=
 =?utf-8?B?bnBDQnR0ditjQ3dFVHVFaFZ2bXNlNW9mL3BYb3drZGd5QzFCdDVOUDFmdWpO?=
 =?utf-8?B?cWZrMkpDVkVzb2RhbEdyQmxONnVBVERpOFEwMlM3VDBkTm1WTWVpQ2FDV3Yz?=
 =?utf-8?B?SkVoTXdmTksxZW5PWHlpeTdKTXlqc1QzWEpZdEFhTmhpQ2lpakhlQmxMMDh2?=
 =?utf-8?B?NGdzdlJ4Vy9zUHpyS25OYUQwVGE2ZTlFdTZVcFYwbHRXMjBTa0cveWpwVU11?=
 =?utf-8?B?N09QRmcwZUU3cW5aQ1g5dmZLaTFOekduc29EaXlFSWFkWDBiZXhwa3BHUWM5?=
 =?utf-8?B?blJPZzBnb3pveDM0K1g1ZGQ3QUJiOFZySlhua1oreVpHVE9JZnkzdFFTSTlV?=
 =?utf-8?B?YU1XVzgzSHk2dTBsKy9YMnhlaUh1VmR1Rkl3OXBNTHpJQjVXSWNXNm8wMnFh?=
 =?utf-8?B?TGp6K0xRcUlnRkcxNVBjbG1SUFdWR0dxMHRlNzdMQlllNkdBckFPQW9jQy96?=
 =?utf-8?B?ZUs2ckJIdjhrT2QzUFhzaURzZ1pHSVVvcWF6TjNLWU90anlnSmEvdUovelNW?=
 =?utf-8?Q?vyc4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWNqOFVtV2s4Nk43VDMzd1l5UnRSQTdzUnFMR2s2SDg3amI4SlRCSm5YOEto?=
 =?utf-8?B?QkliSlRhU21BRWFnMmFpUitTSzFYeEpWZ0VVQlZSOGxQY0tuSlZTZ0dsUEUy?=
 =?utf-8?B?dmtsUmgvNVVvL24rTXltSkdwdHdrNi9OTGZ3RGY3dHhHb2RmdDllRDdQbWNQ?=
 =?utf-8?B?YzZJVUdoK3MwRFl1STZ1bzJieGVZQUprL1RyRDhZWUNYaU9YTTR4cWhUNDQ5?=
 =?utf-8?B?TlVMRzUzd3Q2dEtmQnp0bG5nZFR3MC9CemhFNWl6NXZZYWN5c0MrMFhMQzli?=
 =?utf-8?B?MFRnbGxEM1hpWlc5bEFGa0lFOStROVBpRW0vVEJNd2dxbWlqWm5ybmw0WDZn?=
 =?utf-8?B?OFJ3Ync0TlNOZ2UzaUk4VFB0NHFTYnFsUmxrcjR5ZEFiTlNGa1Qzdm5mYVlF?=
 =?utf-8?B?NkxZbjl4UlZaQm5PMmhPOTJ6dDc0VjhxVHpBTnNtdDB5UzFMOWdjM0VRQ2pW?=
 =?utf-8?B?MEpGbmoyTERJL0E5YWtENzVDclQ1RlYvMmNscmRKU21ndzdhbmV1VFkyOGth?=
 =?utf-8?B?VW5iSGE5N0RheDlCRWV0a0FsVmsvVDdBOXR6cEhPQ2pjOHEvL2pGd1hMcGFr?=
 =?utf-8?B?SnE0SHNEUTBaT3VmODV1ek11UTQ4UVY5cS9PRnlUc3BIYy9Ibno3Wk5vOE4y?=
 =?utf-8?B?ckEwdkZ2Qk9DN3NyWHB0cWZVVDBwU2gvMmFYSlhzaGRrMUlQOUZ2OC9OSWxX?=
 =?utf-8?B?VXJ2N2NGNE02K1JyZjU5RFNJSmgvRFFOa0h4UEFnYlVtS1VaSmk3dndqNks1?=
 =?utf-8?B?cjhCenZnaEdOb2NQNVBJekJpOXA2ZmhaVTJWTnNDOXB4MzNjRDZCdDBCNUtU?=
 =?utf-8?B?Z3dFd0t6UnBySWFZZGJ2QjE1K1pNMGdlWWxSZzFoakdlRDJjQk1XTWMvU2Fr?=
 =?utf-8?B?V0E3RDZxek9MVElHb3hHeVJndzhVckp4Ymt3clJPZHZQK2pNeGd1emN3UHcr?=
 =?utf-8?B?VEdKV21EZFpjZUlSOHNBUCt3L0FUMzVNNTdBWnRsbnN6VHB2bXNNSm5TUk9n?=
 =?utf-8?B?TWF6cW5BcSttMzl6NkExdm9MWStNWmZTaHBQNFQ2cXkya0l0emVUM1BiTTV6?=
 =?utf-8?B?UWozNHg0SGRrTXMxTHpONDFWTFRiOENmS1RMeDhGcjhFS3pLZ2dvMnNKb2wy?=
 =?utf-8?B?Sm9rS1JBYmY1cE5wNkhJaUp1VHBoM3I1ZklWRFdTWU1JWkpCUCt5Nkw5TXRo?=
 =?utf-8?B?SE9JemI3MVZNSDg2dkdFS2x1MWxOYklSaVpTN1UzVEI2TDViSHdLZUtycWdH?=
 =?utf-8?B?eFRnakp3UEtCS1JYU3hSRWZ6MEExcVVFekM2UWJDWlZBVGZ1STNQR1h4Y0Zu?=
 =?utf-8?B?VUxpRzZpMzhhVVlRbEl3ZWN4bmxVZ0JPUUlqd0xQR0p2UnBDV3BJNDZsM1c2?=
 =?utf-8?B?Sk1BSUpUa0FEbEdhRnNWS0pEU2doS1ZRaXJPQVJuUGt4dGR6aUg3VlZlWlpa?=
 =?utf-8?B?cFJDMDBUVU04UHF2OURYYXhRWHN5cnNXYW4vYVY5Rjk3ZWJjKzVhSnR1MnF6?=
 =?utf-8?B?Qkx2QitKZUNUZ0xNbGZNRDgvTGtrZU9VSlBCaW0xUDkxWk1WOUQzemVDTGx1?=
 =?utf-8?B?bkNnbElMcGNPaWtOUXhhWkVxN3pucnVWRDZiNHIxOFVpR3pLQm1PZkRnU1VD?=
 =?utf-8?B?L0JxNW4xYW8vYXQ1aE5uUVlkUFl1emVmWmdpcnp4Q2k2eFZTS3kyczdPaWkv?=
 =?utf-8?B?QTh5SFBLSVdyNTJzaFRTci9lbEpPQndIUUlDUHBYaE1tNFFSditwOWdWS1pw?=
 =?utf-8?B?bzZJS0ExM2x0ZHdPUmVseldoMVg3WlhZVDQ1cWFBelJhTmh3MUxUK25ONzcr?=
 =?utf-8?B?RTVRWnpKREtRUG5HNktBMitJeTNLSzY4NWZ3alJmUGVKYyt1ekY0OEpzMXN1?=
 =?utf-8?B?bHBVTGxnYzNock52U3lzenNBTGVGZzdOZlo5UVpOQ0ZWY0orU0Z2K0tiVGhF?=
 =?utf-8?B?Y2FwYVk2WmJGaGRXdkhqYXlOeTNYblFFbmtZeUU0bnlCaDFsaDhxV3lvUGRT?=
 =?utf-8?B?c1BzZzNEcUxic0wzYzhPenhDa28ybHRLaEhWK001RVZ0Y1ZkUVVmR29TUzJT?=
 =?utf-8?B?MUlYTkdaNTZMRlBncWN3OXgvbFFlOXAzSzB6a2x5c3MyR3AvRDBRVXUzTTh4?=
 =?utf-8?B?V0xqd1JVTXhRZVVXYXVYeWFPeDBTTTRzc3BnUUVCTDk5dU9HQ2t5L0Y5OWFO?=
 =?utf-8?B?Y0RPN3lwVzJUNFlEU01mWDRXMCs5T1luUzRTdDREanpUc2RRbHB0QkFkYkpE?=
 =?utf-8?B?K1RkdHhlSzlQcGx3Yi9sL3B6VE1BRTZWU0NnNk1HUFd6QmtRTFRsbE05OWVU?=
 =?utf-8?B?ZGdZNzA0T3RUKzB0OVdWeHNOcnI1ZlUrOEN5OGJkYzhEMVEva2g1UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04be40d0-9d7a-4a8b-d355-08de54480f17
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 15:09:20.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tt4m/EtHokUxUdTlPbkSUzw1eZiFfFFt0llkz3Fzr4wizJW02YU25RJXMvs7YIhUIdeyB2BnBRPjiYV0OUi04w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9461
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C13E1A001B
X-Stat-Signature: poz9zyqni8urxtpu4i8dd43fj9zt8zm8
X-Rspam-User: 
X-HE-Tag: 1768489769-65792
X-HE-Meta: U2FsdGVkX18HWZl4lRo2ON4ZNLDueGV/LwI0uOUZf6kU6/oZTlRyxwyR4lL0jejafgatLK2XDPk8/dYlBmgGC6mgcjVl2gmk1ZebzHX0JdJSHDxVaMsKl7QU/+tIod739H2mpVBw/TtlxTAZIik/ni4ci3oOl2SALeojRfDrfGIUx7xx32AFiT0JP/WukypztJ0sBcdiraspEVKbfC3R0HdmaRHcQmk2EcyVvhb4crYlnLoxwVr2K8+PZx8Y12q4e9tWZc5xAQPueReX59ZwDhfDopF55E/Dw5KyRKmiBIEOdJI1zr807X6F/9jGUb38N0/OW63NnlupDCUK2kVU5ESfpcuc7wP08Yn+BUlbkrsxMjRj1lDFWsQwWEf53eiQzsSXoSuUBd3V4Bd0bqWj/w5W30hv5PriPQ44iL+bzvOPg9r7bh8vWlRNGeCHymoMqNMq/GZbbqKPXBOI+UDBZtC/8csC31eWypFreCE45t/lxwjRq37InCESidf2qJlrShERvdVTyaMtVAgVU7FAg82wBZ0yRF6/amSAv2vNN8oxdVwetYhDx1v7+/ADSB0iD/BAvVgn/QFjurRpJEE2IFof8GhPslMt2KtTjVAH2cpezXejB6VBTTtLnmAa5lKfELxD044hq3ruo0bthVF3IELoEkzlTX9Xrncbk7ZdnTL6GzaS0vlTxrNwO603jHBaP6eR5q9R+FMRl1q5gH65rVZHFQ5C+TquDNO5Mgf0ypJkRw0ceTZXtnhnWHv9bK9b8X1bKWxwgHlnJUcOHj+lG8nucHV9lm9H7v2BEN8790N/lMa9Eius5uZsH8E25OGIFM5D94Iv5s760IV7yr4gAs5hrlCLxoPCjS6kBPpgvfob/8NRp+r3CVgSLa8kTLxzC6Nru94FsbKgd7F6zsEiFzzNIfj3DiHs7A8RHzTVMbr059Ahku1J0AALrxw4BHh2yWQHj3qOSmlm/rMxVWP
 4iHXAqdR
 isOnJn6WObupnzv7A+RZatjfI+EJZEMa46ewMVqzgyYphcnh8I/uhwiv68u/aWy+jDAl7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for my delayed response. Appreciated for all your suggestions 
David. My thoughts inlined for your kind consideration.

On 1/14/2026 7:13 PM, David Hildenbrand (Red Hat) wrote:
>>>
>>> This is nasty. I would wish we could just leave that code path alone.
>>>
>>> In particular: I am 99% sure that we never ever run into this case in
>>> practice.
>>>
>>> E.g., on x86, we can have up to 2 GiB memory blocks. But the memmap of
>>> that is 64/4096*2GiB == 32 MB ... and a memory section is 128 MiB.
>>>
>>>
>>> As commented on patch #1, we should drop the set_zone_contiguous() in
>>> this function either way and let online_pages() deal with it.
>>>
>>> We just have to make sure that we don't create some inconsistencies by
>>> doing that.
>>>
>>> Can you double-check?
>
> I thought about this some more, and it's all a bit nasty. We have to 
> get this right.
>
> Losing the optimization for memmap_on_memory users indicates that we 
> are doing the wrong thing.
>
> You could introduce the set_zone_contiguous() in this patch here. But 
> then, I think instead of
>
> +    /*
> +     * If the allocated memmap pages are not in a full section, keep the
> +     * contiguous state as ZONE_CONTIG_NO.
> +     */
> +    if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
> +        new_contiguous_state = zone_contig_state_after_growing(zone,
> +                                pfn, nr_pages);
> +
>
> We'd actually unconditionally have to do that, no?
>
That's a great idea! Probably we need to move 
the adjust_present_page_count right after mhp_init_memmap_on_memory to 
keep the present_pages in sync.

When the zone is contiguous previously, there probably 2 situations:

1. If new added range is at the start of the zone, then 
after mhp_init_memmap_on_memory, the zone contiguous will be false at 
fast path. It should be expected as long as the 
adjust_present_page_count was called before the online_pages, 
so zone_contig_state_after_growing in online_pages will return 
ZONE_CONTIG_MAYBE, which is expected. Then the set_zone_contiguous in 
online_pages will get correct result.

2. If new added range is at the end of the zone, then 
the zone_contig_state_after_growing will return ZONE_CONTIG_YES or 
ZONE_CONTIG_NO, regardless of the memory section online or not. When the 
contiguous check comes into the online_pages, it will follow the fast 
path and get the correct contiguous state.

When the zone is not contiguous previously, in any case the new zone 
contiguous state will be false in mhp_init_memmap_on_memory, because 
either the nr_vmemmap_pages can not fill the hole or the memory section 
is not online. If we update the present_pages correctly, then in 
online_pages, the zone_contig_state_after_growing could have the chance 
to return ZONE_CONTIG_MAYBE, and since all memory sections are onlined, 
the set_zone_contiguous will get the correct result.


I am not sure if you'd like to consider another option: could we 
encapsulate the mhp_init_memmap_on_memory and online_pages into one 
function eg. online_memory_block_pages, and offline_memory_block_pages 
correspondingly as well, in the memory_hotplug.c. So we can check the 
zone contiguous state as the whole for the new added range.

int online_memory_block_pages(unsigned long start_pfn, unsigned long 
nr_pages,
             unsigned long nr_vmemmap_pages, struct zone *zone,
             struct memory_group *group)
{
     bool contiguous = zone->contiguous;
     enum zone_contig_state new_contiguous_state;
     int ret;

     /*
      * Calculate the new zone contig state before move_pfn_range_to_zone()
      * sets the zone temporarily to non-contiguous.
      */
     new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
                                 nr_pages);

     if (nr_vmemmap_pages) {
         ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages,
                         zone);
         if (ret)
             goto restore_zone_contig;
     }

     ret = online_pages(start_pfn + nr_vmemmap_pages,
                nr_pages - nr_vmemmap_pages, zone, group);
     if (ret) {
         if (nr_vmemmap_pages)
             mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
         goto restore_zone_contig;
     }

     /*
      * Account once onlining succeeded. If the zone was unpopulated, it is
      * now already properly populated.
      */
     if (nr_vmemmap_pages)
         adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
                       nr_vmemmap_pages);

     /*
      * Now that the ranges are indicated as online, check whether the whole
      * zone is contiguous.
      */
     set_zone_contiguous(zone, new_contiguous_state);
     return 0;

restore_zone_contig:
     zone->contiguous = contiguous;
     return ret;
}


I am OK with either way, please let me know your preference. Thanks.



