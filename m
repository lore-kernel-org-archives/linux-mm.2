Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59ADDCF31BA
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884046B0027; Wed, 19 Nov 2025 07:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B686B0029; Wed, 19 Nov 2025 07:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBDC6B002F; Wed, 19 Nov 2025 07:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4BB6B0027
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:41:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA1C858A87
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:41:31 +0000 (UTC)
X-FDA: 84127317582.15.C65D788
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf02.hostedemail.com (Postfix) with ESMTP id C9B6B8001F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:41:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d4GBcaGH;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763556088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWBgzqW94RnBPpMvPRCia4Nkgy4Ef1Ctz9T/PmnBCHE=;
	b=XfR4HBOEjEd6nc19ulImy7fMfRGzZyn4VIXE0cgyzq8TIvRXyuMCuPqeAhMXHyZU+DsPpM
	7zUC3nwi6eNqNERI5LyOL/KpvNRHGCLA5zBL8YiY5YxU43Iy32CjVY9fCm0ZkrPjUgmVaa
	8oSjVOcqzRRYwcxgblkEOuvdlEWB11E=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d4GBcaGH;
	spf=pass (imf02.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763556088; a=rsa-sha256;
	cv=fail;
	b=svR931bRUmMz+sgrlZSRTsO99yrjcst8JbnUjuQCZdBZebHHfgg3Yffh/aMkc9u6sXmja1
	jq57WVGPzuyWobZpLudnNwCasNVj3Y+FxHCmD4IIZY4GDcAiNi4F1N73N7JSdqUulnPsoX
	lGiSyVa/0S0a9lf0l49tamyWGW7+f6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763556087; x=1795092087;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jz3MqMJ7CPp9NhZAB3g4a4xnzpwD/0ahCyTLco9ja58=;
  b=d4GBcaGHrrKEVucR7psWNnqQeZrOnsj+/CmfWjoXZJhEXOpiT+KFuV5a
   DgnbBM0xtRtFxKKvydKxLaAPVkG4GCCzhPlGNU8eQRvX0f66LoGWSLt33
   kQDMo/G++a6Q30r3b8UmhG/QypL8+cS8TD5Ak3JT6s5PrtgqZEkOypxgP
   akauKa7En1IkgGJHEztpoq6WFPTR1tKmDU62qENBB3n7tEUF1nFoOz8fi
   hmXyUnFTJp237ApGHYgoHzqq4p10CeWEGHoGZFN5y4mgQbkZyzwf1pzSK
   oXlr10taTxkha6zpnFzRiwgaJB+jH1y68DFbv9A3s3ILkYnkpdBuH6Ik3
   w==;
X-CSE-ConnectionGUID: NzqejwczTGCV2sLFd9fQmg==
X-CSE-MsgGUID: YY7GMHh1TU6K9CBR9PkPDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76700399"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="76700399"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 04:41:26 -0800
X-CSE-ConnectionGUID: IqMPxPQlSGi52xjDDkX4tw==
X-CSE-MsgGUID: YS3N/Cp9TXqwgF5HFM09RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="221682046"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 04:41:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 04:41:24 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 04:41:24 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.45)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 04:41:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssu1E+SKrZZhazFfFtRV6j5K4EifC+dUUM7RwLKpjWwSusP5suSCEYd7XRw69graQ/fdpIjMyCbHo6DKNuLwH16/rSrI1YCIMbo6bvrlVmzbadX5eU6ZtNQErBjH3WAjJvsCr2H3lfD317zSCQefVrG7chb/MPlr452Eqbt4495kGbJ3VHV8d51p9d5f8ZF9Mv1CZGTLJOd6GdSLZTUKQaeeYS9hiYTBP2ADQIhGk466MY24/ViHJ7F2sGHdq0eQYNB7Zp5VLQmhDRxmcUso9tL7qQwcOgS1MpDHuI8Yqf3hAUw6ZOcRnOJaKGmznY4kyBwJ+o5cg6+y+Kf2pCPuRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWBgzqW94RnBPpMvPRCia4Nkgy4Ef1Ctz9T/PmnBCHE=;
 b=Ykge0wJ7fRu/ZmEUTaUzsbcqnLsUUt8FqFJT/cv56hRTd2pQfQh9hnki+ZynrVr3cmQW0+0ktpmYXjuat6XWB/wgY8KtVuILYcecVjOqqSxwRQ3olO2LQtTA8hbbneZyKYdKbXWzH/E7fKaxNQ73Y/cvlwMQFMZnvIuaPLdI2mg5FamUOA2TeSPPrcHcR0zqYQxcGtsFMQ2KgrxLucDNddLaj0W5a3YkGYO43MgRYDEMA6Hp5vlQkqVC5zdcGP5JA1/44JZh125sXXB1HQXGSsOJvDbyydJylhSFk6Bv04N+PC1XCKNlYf/Mkj6x2avAR1oepUEFZTlnRUqmPJ1f3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by PH8PR11MB8260.namprd11.prod.outlook.com (2603:10b6:510:1c3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 12:41:20 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 12:41:20 +0000
Message-ID: <ca02b44b-fc3e-4626-a331-d0348ad5e9f0@intel.com>
Date: Wed, 19 Nov 2025 20:41:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
 <20251119114252.oykrczprf3ecd7ak@master>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <20251119114252.oykrczprf3ecd7ak@master>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|PH8PR11MB8260:EE_
X-MS-Office365-Filtering-Correlation-Id: a1d87a5d-a391-4c37-7744-08de2768f093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ni9SYmlSVFpDVFloQ05yU0JIQ0hxR05oVGVzaVdtSlhGTDFMQ3BPWHFmVUJE?=
 =?utf-8?B?Q0VuT1RHWEtKN3RVV2lZWmN4NUtNS3RSWWxZZkpwV0xWakw3c1RIbkkybVIx?=
 =?utf-8?B?cFhZK1pJMk5mc2Q1SW9JSnhOWGp2Sll0VmxheDl5VXpKT1hIQm9PL1hBWWVY?=
 =?utf-8?B?ZlFuQWw3bWdFWmRBbk9qMVU4SjlZd044WFlaL0p5YjdRVHd6dWJIYnVWa2VV?=
 =?utf-8?B?R2QrUkZ0WXNnWkF6WHZ1alZVbldBOXN6VldUWkF0c2ExTVlwbTd3bzJuN3ha?=
 =?utf-8?B?bnRJWEZJOXRlU1Z4Y1FrOUlqUGN4a1ZGeU4rRGlDMmxabVc4U0FIN2RRMmNP?=
 =?utf-8?B?NC9OYXlENXZMNlJCUEgrWnkzdlRubURwUHR5TzlXQ2lyczcvS28wSTdTYlNK?=
 =?utf-8?B?bXJ1SkViTXJ1bC9CM2tCQThvRFc1c1JuaDdab2tKcVBMRXdXdTBMSHoxYTF2?=
 =?utf-8?B?K3hMN2J5cG9DM3FIeEh4ditYWnp5MFpYWVJDVDdiSS9GaDlITkN1ckFwTU1L?=
 =?utf-8?B?RTIvemR0cjk1V3Ezak0yV2VBQzlYckx4d0pBQUNKUTQ3dGNiazZvRXpnN25t?=
 =?utf-8?B?SncxS1R5SFlVdm9NdFJNRm5LbGo2dVJHLytZc1BDODZia25kdHcvMUtqbVA0?=
 =?utf-8?B?R1FHT2h1Z3VnMjZGNE5nYUlrRzBlRWRzTGxHdkxERThiSWpvT0wxeU1weTZn?=
 =?utf-8?B?QkE3ZXpWeCtqZ2g4L2F2OVA5bk43Qm9ZK2Z5bllHZEtZNEtNQTI4S3Fhb1dL?=
 =?utf-8?B?dEVPdmNCNkhsVnpOVnIvZTFVaHQ2U3lGL1RNWHp2Yk1mbFZNeEgzck5ZeThs?=
 =?utf-8?B?U0lhSGJjRVRjYlRJcU14RGlpV0VnSmFlTDgrYVQ3TFkvd2tRSFo2RWNUL0U5?=
 =?utf-8?B?d2Z6ZHgvcHBVMTE1aENpY0NMcjRWVXJ4cjI2K2RwV1poQjdvTEhmVDI5ZnNz?=
 =?utf-8?B?bW9ZU0xUVk5EZFQ4bkMzMzk4djNoTGlWNk43TlNHZE9xTUI3L2Ura20rcmNU?=
 =?utf-8?B?cjBiMUl2VnptVWNMa1cxWVZRaVBnVTd4YlROTEtLRnA3Nm1IM0RaVS9VUXlZ?=
 =?utf-8?B?cko3a0ZUSFByb0ZEYWpHczZ4SHJSTHZuUHVPNy9wMUJlYzcwN2x5eVhTdHFq?=
 =?utf-8?B?dGlWTWFtb1FzTzNJcnNMRSthZlptaVFUbXRjNjYzcU1jdTVQL1dBV1Q4WUtO?=
 =?utf-8?B?UmJTNDFSWjdOenZmeG9vSVNFbFdhTmlpTW55UGZ0WnlPank2bVpzVE1ENTNy?=
 =?utf-8?B?V2dsUFVjN21lMXcvTUlSVVBESnhEcjFOYWZtemxRbTQvUW1udVJ2QTJQT3hH?=
 =?utf-8?B?bVFySHhHZk5ueCtaY041R1QrcGVMZVJHL3BsNjgvWjB4TE5tVWdxMHlTbVJK?=
 =?utf-8?B?ajcyTGM4YXFySW9rTys5QnNQanBVdkErM3Z3MWFGYlNoZDVsdGhMY2VKZkJD?=
 =?utf-8?B?cmVwVHA4U0dUaEdHalVGQ2RxZ3lCQUY4Q1J4WnZXdDRNZG8xcXgwMWd3TkVW?=
 =?utf-8?B?ZmVxT0xnQ1ZBcVRsdlpWck1tUHpjTnI1bXFIOFRBY0pzU1ErYm5iRlpHR3JL?=
 =?utf-8?B?QTdJMVpVUCtWU09ETUlSQ21naVkrby9hemtHa3VXWEVNMGhRMVpCUmNuWmJx?=
 =?utf-8?B?VXpxUTJHRTlqNEFsR2U3SFZIaHVRVHI4VTU1c1Nnc1Q4bUV1WHNpSGY0R09j?=
 =?utf-8?B?UklidFoxalZZSm1UMmZjVmhZWjBlMFNzL3pNYTVycnZ2TEYwd1MyWTcvU1h3?=
 =?utf-8?B?cFE1N1ptc1dCVzZPbWJzRExna3ZObGNndUF1ekFaVlBNcGFmY3N2QWh4R2Vk?=
 =?utf-8?B?UUpORWc0UUtUenVOZGduZkFWako0cjUzMFZlbTZuR0xYZjljdTFkQTlGb2dB?=
 =?utf-8?B?aTB2K2Q2bFZFRnd0STVNQ09zZWRUN1c0YVkxU25LVzNkelVIOXBQQnNyb3VW?=
 =?utf-8?Q?QN2o9l0Wb+I/PGAtA8xwoHfyIL/1DAk6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djJOclBXQ1NyV1lTaEZSZXhsOGF4TDBEZFVsS1d2Y3doa1ZjOVBoTG9pUDR6?=
 =?utf-8?B?WmFFVVp6cUNESHB0ODl2SUlOVFlQYjhIQTVWeG4ybmpOYmk2QVYvM2d6bmlE?=
 =?utf-8?B?Vmx3TEhWSnMrSlYxNnQzRzYraEpDYVZsWXdJZGVVeG1rMmpJbkswamVkQ1JO?=
 =?utf-8?B?N2ltamtWY1V5RUxuU1NTODFHaWoxRGJVSW1YenA2eVk3UkQ4Y0RpNXlKajNi?=
 =?utf-8?B?ZnZzMkFCMFFhNFp5Z2lTRTd1UUJieTdCN0RPRnRjTzJ4VmVqWDJmWjNZRGVM?=
 =?utf-8?B?UkJtbUY2WE9DV3E0MkxqRG52YjF2cE1BZCs1T204SFdOUEVaZVlRTDUwaU10?=
 =?utf-8?B?aXN0cnVlQUQ2d2VPWUNXcTdMYit5UzJKOTNMZ3IycEwxaDAyOW0zTFExaG1P?=
 =?utf-8?B?QVlGTnpFY3Fjc2dXTTlBUitDRmVvblA1NjVtOXlvQnBUVnlzZ3YvWEZhazA0?=
 =?utf-8?B?ZFBtc0loWXhIaGFxOFc3Zk5oWUlaZ1lRZGZSTWF6NGlzMmdpTVhtZUFsaC9q?=
 =?utf-8?B?cXVMRmxBSDV3TVdmVC85UHpxQUp3WkRNdXVTdWRweHRhUlJVcmRQRGxvVlF0?=
 =?utf-8?B?UTlFS3BFKzZpcjlQc2dJVHJFS1lla3psL3hjSDN5RkZDeG1mMEdxREx6b3pE?=
 =?utf-8?B?bERVQ2tQWnQ4S0F5dVJ2Mmx4bWtaQzM2SklDdkd2Vk05VkJuazBFa1h1ZWt6?=
 =?utf-8?B?dU9qTUZLQnMxN0RqNm5GMlpYNmk3MkZ0UTBsQ3hOeGZwT096andEb2xOTHdF?=
 =?utf-8?B?cnl2c2RIRC9EN29ybVFOSzk5ODgyRFlZOUVDSFhEdFdENE1sRjQvN0VWNHdl?=
 =?utf-8?B?cnpCUmZxNnNkd0FjWmhNcFFxbXBWVEg1NHlmRnorRFVHSmlRd2NtajFUYmMv?=
 =?utf-8?B?d2xBUHN4LzVQUEhJWXZ4eVhidkh6L3FuRWZ1cEhlQU1DbmkwU2k1TXB0WjFV?=
 =?utf-8?B?NjFiRUVRMWp6RlYvaWRZL2lDanRaNFZodHNiRUZnUVhZaUh5WUI2TG45V2Vo?=
 =?utf-8?B?dlZEZlJRQXlkWmI3bmR4Um80WlgydzdPclZvMEZNblZmM09vZy94Q3JFTTdI?=
 =?utf-8?B?cHNZUWpTOTdzbTFVNUkwWGlKMHlhUlV5cmNJR1VYbEZXZTBVQmdUcHp6a0Fw?=
 =?utf-8?B?alNLUTI5YlcwU1pXWVlNVlpTS1lLWGNCTWxiRlRMcGw5cW5EakNzaGIzbllO?=
 =?utf-8?B?YjFtRHMwdWxCYUpVaUQyWGNCT3BRaFlkUmlxRTdCNU5VSVRUUTUvM1JSZDNX?=
 =?utf-8?B?ZEpxTGxEK2Z3cHlmVVdIU283U1Q2bzgvQlJqZzR5Vm55M2pRckN4Znh2VGVS?=
 =?utf-8?B?SFJBQWhEWERBZk9UT01PWUo0TmxLZEZmVHE0YUpDNUsrUEtpQmNrcHN0aUxz?=
 =?utf-8?B?Q2dIYTg4aTVnenhCWFZHTG0yeGtkOHZVQVJOamdsNkpKdzBzUkNEd3ZpTkZP?=
 =?utf-8?B?dTBURmZlbFQ3RVI2WXArQytvS1pOMTdWcGdsYVpuSEpsaWhGcU1JL2pHaEpH?=
 =?utf-8?B?RXd0Wno2ZTRXOE5FQUlGYzJ4R2dJaXE1Q2dGUmxaZHRLQ2g1WmhYMTBXQU1R?=
 =?utf-8?B?ajQvT1RFbkxiUHZDS2lEb2VpcDVOZThZbnBTQ3FJSFFJY0pXMnV1Q3RsamRQ?=
 =?utf-8?B?MWxOMWN5SkNRaTRXR1pqclEwaU9pWmlJc0R1bjFaaCtaVnFVVGtWM3VVY3Jw?=
 =?utf-8?B?L01SSjV5SXRxempWVTJsWS9DQzE3bElWMjlteGxqMTBhcE5FZ2x1NEluV0Q0?=
 =?utf-8?B?ckx4RGRibWswTElHb3JBdkl1YmdzSXVTa3V5ZU9UVGJvb3VxdkF1WGFiN3VS?=
 =?utf-8?B?MEJyUUVjYmZaK00yWmxoWnJ4MWpBeDZMQ2xtbmRUTXZsa2ZlR3E1M3hadjBR?=
 =?utf-8?B?UTJXRWlsVzJQRk5pMDJDdTV6cnVzNkJyUXZCUlhtcXU3dUJiTGphRitXcHhK?=
 =?utf-8?B?WmtnWmd4aGxzZE1JMzBxOWFrd1hldE53aUpCS0tnSlF2TGxQeW9sUXYvcFFo?=
 =?utf-8?B?eWtrVHpaa3RwY0NPblJ1dmVGYjMrU1IwaXZ3bHB4anl5K3E2S0ZlUnRVYkZk?=
 =?utf-8?B?U0xOeU9OV0hmTGV4VkJXTjFoODBncUt0UGZDeTk3dmhFUjBUanFZY0dqTkZS?=
 =?utf-8?Q?qFnETuXiwioKBKNNUy7N34lV8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d87a5d-a391-4c37-7744-08de2768f093
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 12:41:20.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJQynieHTPaoDEJQZ6O6JtajxT2mgTrKDcphzto/O78USBdgxb8pmZSSCA90o7JIXZxnHGPCb5AGCUD3QoTV0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8260
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C9B6B8001F
X-Stat-Signature: 8btm1mwu4tut4emr34sxwdyuy1aoi3hu
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763556086-623719
X-HE-Meta: U2FsdGVkX19lelRD6594fJEOvIm5IhGISRLye6yGsK/7+I43Lf4QMmRc6ILf9dcaEU0Rxsm6MdYr/PDd/lTFXgvp76H2yW1hSTM475SsEtRWSzFKas1ai/FeStV72ZqMU9wG3M1WfXXF4oFI0cfzNxjXjR1Cq0voZgQOvhcjaov/4v6LnaoVLjGOgFDv8u/h38nCF0Vxb5SPwDF6J44Pe8Tqxez9hfBCsRz7L4ZzzZ2dI0WT4NfoW19ZFR0uPY4NLzE3kq6TutdKwNIDBmLY0zGmHVOW93afcE899k2CdASQYWOnlSLCHwWtfBIgziM8v/mCovTBb2HY7LYobsLw/+tuYwkVAwedRKAZ5Jy2z/LfoURsQIQrg7pF3MwX0UrmfO313ahA1d+42Tno6fWjf5sJrmeB/gal34pjNMwg7tFx2xTZFKQLjiVgR4lTN/N5YEk0IgWNiW6LCiDaoaFerH56x3xGsSFVG4vyFE5KtNsmsT0fiE7TszgRPc3HBc492RJQp7gNu2aRZbIeDVvBikmn/74yi1aCng19sUFws4dQYFIjwyMFakLm+RZ2P0r57Uu1e+h2GuaF03vhTBU8PKcxRUloKBogL+N/iUJRDvBs1/cnBZIS/iNYFOAx1aLzgvOn3A1RivMqMyRBzrE5gPr5WdPh3hCPBBOW+J8KMJyc5kbQg7hfBSrZf2C+AdS0/11sSDRKBYvXaWbSrQEeyHVaxosyemzpMCMEg9vUd9diHT04SNJc1LP57m/zROGo6scQnZ9Be3+5AUXQ8LLvFyJxOsIBo3nrMDNz3dHKfIx44xKJ3wOROeO7VITmLYbbnrLss1zvQzC+1muXXTJhka77WFs4DHi5gGT0dKMRbD6+6alpqO3yBLH8O52XpI2Hg/RQ3HwFwowkHD4eMqNTkqVMZI/eJWFAUY4gtRA7HU6LlcTcDVM3HDcj8NRWTyNiGDGKZLUmE3t+qmdFJWb
 nhbMq2QY
 u6c+aPbWVRY3pm8sH2RZdRdRDXRFvhBDdmKpgIhiqDyjBXBF4xybFi0932XIL4urW1lh4dzhM8bfBjGHwvUWYMfJKi61CJhMzr80+NcZHLdrTFMn/QKPNOcNxcAcjhAJ5bWN1qjJSV36gRV0+RpEkZwzStV8EhDWHxfHzCoR654sDh3n2w7jJC0jPEUPhFuFc8huRlvGWWbN42RIJGekY+KzP7ZVoJO8p+jZvytYGUeAOJNhPTXvp2DkIEBBlBrIIhiDaUl9IFnFhuukdUxbR1pD03ztILBjIOFpPTJx4oYSltgstksshhI4HL4B2oEHRetqRpXmcNfzVhRseT1XpSkrFqruQrsIAeROE1Xw2RqXhTiBJkVmyp2jYQ4Lma37cSdZixtFLDW7g/KlxgY/aNRE5Bx0ngtiBauhfokBF2QTz9fNT9vaaFa2qOLNMFxbW5xRo84hpfhg/mU85VfKxZ5JN8J4wV11NM0nWonkD4bV6/ky87amApBjD/UMO2G3uuOc07WV1BCLRWPADnp2SFSrXeQxhyYIa4VMVPufh39dYXZQ98NLm38yrAus0z7VDmck/4pXySb447x4VqgvswjZ58pTGcAcE+KE3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/19/2025 7:42 PM, Wei Yang wrote:
> On Wed, Nov 19, 2025 at 12:07:18PM +0800, Tianyou Li wrote:
>> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
>> checking the new zone's pfn range from the beginning to the end, regardless
>> the previous state of the old zone. When the zone's pfn range is large, the
>> cost of traversing the pfn range to update the zone->contiguous could be
>> significant.
>>
>> Add fast paths to quickly detect cases where zone is definitely not
>> contiguous without scanning the new zone. The cases are: when the new range
>> did not overlap with previous range, the contiguous should be false; if the
>> new range adjacent with the previous range, just need to check the new
>> range; if the new added pages could not fill the hole of previous zone, the
>> contiguous should be false.
>>
>> The following test cases of memory hotplug for a VM [1], tested in the
>> environment [2], show that this optimization can significantly reduce the
>> memory hotplug time [3].
>>
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size | Time (before) | Time (after) | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Memory Hotplug | 256G |      10s      |      2s      |       80%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      33s      |      6s      |       81%      |
>> +----------------+------+---------------+--------------+----------------+
>>
> Nice


Thanks for your time to review.


>> [1] Qemu commands to hotplug 512G memory for a VM:
>>     object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>     qom-set vmem1 requested-size 512G
>>
>> [2] Hardware     : Intel Icelake server
>>     Guest Kernel : v6.18-rc2
>>     Qemu         : v9.0.0
>>
>>     Launch VM    :
>>     qemu-system-x86_64 -accel kvm -cpu host \
>>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>     -drive file=./seed.img,format=raw,if=virtio \
>>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>     -m 2G,slots=10,maxmem=2052472M \
>>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>     -nographic -machine q35 \
>>     -nic user,hostfwd=tcp::3000-:22
>>
>>     Guest kernel auto-onlines newly added memory blocks:
>>     echo online > /sys/devices/system/memory/auto_online_blocks
>>
>> [3] The time from typing the QEMU commands in [1] to when the output of
>>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>     memory is recognized.
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
>> mm/memory_hotplug.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
>> 1 file changed, 54 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 0be83039c3b5..8f126f20ca47 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -723,6 +723,57 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>>
>> }
>>
>> +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
>> +			unsigned long start_pfn, unsigned long nr_pages)
>> +{
>> +	const unsigned long end_pfn = start_pfn + nr_pages;
>> +	unsigned long nr_filled_pages;
>> +
>> +	/*
>> +	 * Given the moved pfn range's contiguous property is always true,
>> +	 * under the conditional of empty zone, the contiguous property should
>> +	 * be true.
>> +	 */
>> +	if (zone_is_empty(zone)) {
>> +		zone->contiguous = true;
>> +		return true;
>> +	}
>> +
>> +	/*
>> +	 * If the moved pfn range does not intersect with the original zone span,
>> +	 * the contiguous property is surely false.
>> +	 */
>> +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
>> +		zone->contiguous = false;
>> +		return true;
>> +	}
>> +
>> +	/*
>> +	 * If the moved pfn range is adjacent to the original zone span, given
>> +	 * the moved pfn range's contiguous property is always true, the zone's
>> +	 * contiguous property inherited from the original value.
>> +	 */
>> +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
>> +		return true;
>> +
>> +	/*
>> +	 * If the original zone's hole larger than the new filled pages, the
>> +	 * contiguous property is surely false.
>> +	 */
>> +	nr_filled_pages = end_pfn - zone->zone_start_pfn;
>> +	if (start_pfn > zone->zone_start_pfn)
>> +		nr_filled_pages -= start_pfn - zone->zone_start_pfn;
>> +	if (end_pfn > zone_end_pfn(zone))
>> +		nr_filled_pages -= end_pfn - zone_end_pfn(zone);
>> +	if (nr_filled_pages < (zone->spanned_pages - zone->present_pages)) {
>> +		zone->contiguous = false;
>> +		return true;
>> +	}
>> +
> Mike's suggestion is easier for me to understand :-)


OK :-), with the clear votes now, I will change it in patch v3 real 
quick. Thanks.


>> +	clear_zone_contiguous(zone);
>> +	return false;
>> +}
>> +
>> #ifdef CONFIG_ZONE_DEVICE
>> static void section_taint_zone_device(unsigned long pfn)
>> {
>> @@ -752,8 +803,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>> {
>> 	struct pglist_data *pgdat = zone->zone_pgdat;
>> 	int nid = pgdat->node_id;
>> -
>> -	clear_zone_contiguous(zone);
>> +	const bool fast_path = check_zone_contiguous_fast(zone, start_pfn, nr_pages);
>>
>> 	if (zone_is_empty(zone))
>> 		init_currently_empty_zone(zone, start_pfn, nr_pages);
>> @@ -783,7 +833,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>> 			 MEMINIT_HOTPLUG, altmap, migratetype,
>> 			 isolate_pageblock);
>>
>> -	set_zone_contiguous(zone);
>> +	if (!fast_path)
>> +		set_zone_contiguous(zone);
>> }
>>
>> struct auto_movable_stats {
>> -- 
>> 2.47.1
>>

