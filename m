Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCA2CF855D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 08:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F76D6B0006; Thu, 20 Nov 2025 03:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7236B0031; Thu, 20 Nov 2025 03:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849156B0032; Thu, 20 Nov 2025 03:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 687C66B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:47:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAF37140800
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:47:36 +0000 (UTC)
X-FDA: 84130356912.27.B8EB664
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 136A0180004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:47:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdIJoajf;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763628453; a=rsa-sha256;
	cv=fail;
	b=L3rXGNTmrguzmlOpLrCtKDkhZaghknf/bkIiczAlUI2c3R0ITSedGyADgHC9tbhtk65Cb6
	FOiLcrG2NrNR3uiQmSGsAEd6WYb/pfZWQSjYi2upYgUQWqnZNjg0mwRcButefj59wkBA27
	ZPsLsANp47c2vZc4cTsYpwl/STF3Cxg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdIJoajf;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763628453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8RrkimM5WElRh4dIoyQ6BeecoiYnWXBjPAbNjaX5vlo=;
	b=EcEyNZ8xiBFLlbXPPlZ2AwomYDFQ5m658ceyYb5Aaa6Az5+sgH/xIYCRE2VB8CpYbkjnVK
	8oULV7uk1Rjg1CXrfKrtTSFIgD7sRv/YjmaDLYV2nhLw3Jfe/nfQiW6p7eQcmHI2B6Ea68
	kJ3CI4oxSJL7rvKOt7ILv2tAMhx7uhM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763628453; x=1795164453;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=8fpoo+zOmmZqn2jH+z7f0ma8tAWl9fhwYIMq4BxptS4=;
  b=cdIJoajflKUIgOhbVMJZSf5QX6cERIYgOGWW0vovnPV1w+pxKXN5hIXS
   ufcmVy/gIqOQH737Mzu1wWOWu31lKh0T2uWp0IWIZ+FaJ69TBHnPO+NZk
   vDmlt68FtakIPSHZMWlGGGlNCguSzGi8jArcRRkPhghKNmM4I42bPdw4g
   YjbChPEQeZQVnsKVqy3CGjl6jgiCTP6FWHWwCKZ6MKrd4QmMup1abAsi3
   6eiFIzGTH2Ex2Dato//spdLHaSERu+hTcFJgySe7WyaZWdov7t+4a9uHg
   gJIop6sIucnAx60n9UisbBmfb4/3n2YTbUVhc/o1MYKvGtrp9vwGqBQ9B
   A==;
X-CSE-ConnectionGUID: FU3eHCkNQP2NqdyHbsinlA==
X-CSE-MsgGUID: cnH83Zq2RDOhRn9BAtIgiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="64698090"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="64698090"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 00:47:21 -0800
X-CSE-ConnectionGUID: UWfmbOdRRYKJSn8NXsfglQ==
X-CSE-MsgGUID: NLWN228HSwSPsrGsjWTegQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="190555212"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 00:47:20 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 00:47:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 00:47:19 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.40) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 00:47:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S0MH8Er5ykzO2ungQ8tytUJJjj+Ow0TstUjCsbqhYFRA/Id9huYHPHc4rPPnde9Wm+Qrz7tdW7ZwHkpB4j3N1nK9s5pMC3SSq+oxL9SLyu23Sv76IVdEeaZD5oM8Ar4+CFl/l4QDsv1lQhDiZRky3iBOBmJEX8PeK9DyeKXCEXCjWW9J3XxhjYPl5pVnqwthiwHeGPpcTMC6CaU64uhXNgQLsk/fnnOd+7TKLH8SLvNIapcBpPHIXZyEcHVS6iJJJc4PXSWmp1kWojT78XPjBHWxxTGmzeHxPG7NjaY+N/3vqjFC/9bt7xw2xVJ0HeOv6PKZIsikC1jRRYs+43BSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lVnjQegi9WFUlnqiv/pBkLqSVgYm4H6AhAD78fR5wY=;
 b=Cg2adI4/OU/YSKeN/DP+U9WSauQUw/FlgfjiJZ7g5+i2CYPZm4oOZOxPKJ3Np+QsVjeiQEEutUHb34XD5QFtRdAiwqGNV00X5FJgI5K5p4NGyARpW6Yjam2WNMHwStlsSLrV5KbpeQb91UratHV09WKtB1eEW2M4pNNkfG3thgoFajhatOpt+5SNLZjMQgv8VrcZAlMXgT5wtCxcDkyNxwCXO8fheUY0KXChya3L6itN6mqfq6mSM3awAhV29FUFCYbBOwEKyOrVspMZYjA3UAHevUT133+g1AzbK/HmM2d9kA8T+VDVXzvdzRgRcclpGOUyKdYjiSuDX6uGRGt6NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by PH3PPFFA27DACA6.namprd11.prod.outlook.com (2603:10b6:518:1::d63) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 08:47:16 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::fc95:158a:24ce:885b]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::fc95:158a:24ce:885b%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 08:47:16 +0000
Date: Thu, 20 Nov 2025 16:47:09 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [slab]  ec66e0d599:  stress-ng.mmapfiles.ops_per_sec
 51.6% regression
Message-ID: <202511201550.3efbe5c2-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0049.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::13) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|PH3PPFFA27DACA6:EE_
X-MS-Office365-Filtering-Correlation-Id: 1382213a-f308-4c11-a4e4-08de28116808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?GUjzrn+VwfpKpgEukyXpRdxdc/hRyeOPHpXOGvi+rvu3olyO+B1lrq/JZj?=
 =?iso-8859-1?Q?ZU8943zpZQD+9q4JmZBhB1iaim2T8ZtUo/To5bQnh2/FdLRW6lURloNELW?=
 =?iso-8859-1?Q?z6e2Il/d8ut15tyhty60pkC12pucOBJvKYsC22DIwez5LSBZtXoZvMb7OE?=
 =?iso-8859-1?Q?FxC2UPnqhTO38UmNnEc6ZD5B5oYxVwvVUx9bljhrc/5760IwOtx5TPJ/IU?=
 =?iso-8859-1?Q?Er4yxGyHs6UCkN2IiR3z+Q7QPDVM7Tce2bGFS/pcI9Sa+8fkGpN1m7Dvhv?=
 =?iso-8859-1?Q?MhNizms5+qasXqweaFsEEs5UmekzccNXKDuq3H6rI+RTUq6T/PpOslL5nt?=
 =?iso-8859-1?Q?njG4ONW0IHEDEHOgWWD+6RAK+slxBgAnQ3LlDuYGpaxa7K7j/BHOiFdtXy?=
 =?iso-8859-1?Q?2X5eiHc4GHPUGtSGq4vRuoFEaVwlS/Udtp85uKOM02+yo7Ts0Tnv1QNwkw?=
 =?iso-8859-1?Q?aVM6RwwSypLfL4rE03FnL73cMzLnzavHhAoW9YEYXKrEpFuYwCe00FeRTs?=
 =?iso-8859-1?Q?vaEJX05Ggim9u6vy2t51ARMB+idKPwwqJu49hYIHnWCgqMWnDWaSo0MWen?=
 =?iso-8859-1?Q?AoF8TsfRc3J5giz3Bq6NwNYgge13vTvcVfCKuUFmFizz/U1Ukr8+0nI6Om?=
 =?iso-8859-1?Q?fAlJ042XDyHbH5qDiHptg9mhq+3a8HWeD8i6ungwzS3Ann3Ge5Uxl9eNMN?=
 =?iso-8859-1?Q?9xUS0mUygDEJE8elclRwE80UK3SqbqGA2cTndXH4VgqXjj5oyalZLmgNQz?=
 =?iso-8859-1?Q?08oNj00SmUcPF9XFOaJynaykCsM7fv2B35HW/pI1xFekJES5Q4SVfiNwNb?=
 =?iso-8859-1?Q?4C7GGoTMOt++Eb2rk3d+ARG/AsxsKtMNprJnlEnZab4cZFX8ay1b7vC7J5?=
 =?iso-8859-1?Q?dZQd2pDvhpB1kp+tRznnKuO/XaM8Hpu8zYvT2b1gDi4DeBQo78HwSMbjIt?=
 =?iso-8859-1?Q?vxB9xA+7IkqzIsScbfAPM75ahCixt4qeKxke9DV/A7/Z3DcLx+nqjCOmAH?=
 =?iso-8859-1?Q?PvrnipuOQLzTP1fvak21DiGFcelEscPL6fSx7K8t6lYg/M2vGqyzHE3Pgg?=
 =?iso-8859-1?Q?5f+ru/dDEVfx808JEEaE07ibuEGrIBiHst3qBmsw78K7fHds5fDpM6P9fl?=
 =?iso-8859-1?Q?ML/Q5nrDJy67KmNHDa98v+VWSE+F1MWv+vcC5Y/uQAPbHHlFajXAiDWuj2?=
 =?iso-8859-1?Q?xtq8t++DRRjami+yW9schUk2fLxs7UUHfD05Ow/tMMDH1F9PgeXKdndUEs?=
 =?iso-8859-1?Q?Sgd2ifWnDC67jA80V6Zgl8/VuH4S7yKe2Dmsewc9I/S3AUS6qwZbFDj4pG?=
 =?iso-8859-1?Q?FmslObXkSK/MUekh0/+4g9E9BdKxN/A+9OFgvDDFhpgYEpaLjoVjSBOoRh?=
 =?iso-8859-1?Q?7ac6mi6zeCW029u5X+zZNFs6WA10//qubaUuLrnWG0QM56w73rvoYFbFmt?=
 =?iso-8859-1?Q?xyS5BobZM6EYv19v25gmVwpQwGUlOUYsT/O4StU3XlnmBTZSobTPKbDNtN?=
 =?iso-8859-1?Q?008SR1NmhBqZwe6TMxJvo/s56YYJuON5HBn5M2MexBzQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?q/MOwYiJVTPqEdYqmZIXO16orgId8SKv2AL/DJT3JNqfdx2YYLaQLeg7yS?=
 =?iso-8859-1?Q?L4zRoTYln4AEG69E84RAppjQIlm75kMFlNL+Ofeq8jONgytpZkwSo8jsiu?=
 =?iso-8859-1?Q?9fj8P/++pUQaCddLdiUuB1yFg7gnyixp6t93+RsH2dK9TyKZxHJZNmzyU4?=
 =?iso-8859-1?Q?E8WXuvw8Yk6Jbs30ACcL1pA+m5iC8hhA/IJh3sC2C1AsYEtytehTEwCT4y?=
 =?iso-8859-1?Q?xza3o7kqRWoOZ8LoC2wi1/9hiPKt2iL8ujRD2rnHra9oGtd4p8B1NU1mLD?=
 =?iso-8859-1?Q?4+aY51WQByhSn77qpvm38hGgpTCwZ415Ur1Q2THN9kc/BSYFJ3iENzQAKJ?=
 =?iso-8859-1?Q?f5Hp+khEfLJic+aHSEoy5u0wMd+yPqd2B4SM4Ks58u/7liX20j2MkiyDWj?=
 =?iso-8859-1?Q?L+nrwBuhMzmdOwMwrw1G1mapFxFLxVgbHPZUWZgJbEiW5nqxM455rpf5d8?=
 =?iso-8859-1?Q?oM7Usi8jS9Ks0IjkmtSFurdDQp+OeiuyZ7VMlK4BLfiLvtAsqPJg4re0Vi?=
 =?iso-8859-1?Q?HvCTlLAnv4LWI7vBTE2X5jYP8paS+ovNytMErfrrUieDen6gCEWX3rKBNi?=
 =?iso-8859-1?Q?FYjwgxBo5fr/5N9yqlYlWaVxNMtY5xGYP4lAwUdXJNIDUKiARpq33CO1HB?=
 =?iso-8859-1?Q?fQTcHSTDHRFzipaBTwxVwTTeofTPtuEVHRBBFgArjTOd1URb3uY6xoFG7e?=
 =?iso-8859-1?Q?OswkovE1bRGDkEoShEUN8JfqWy1UQyvtM9y7EAht5s6Rv7z5uL924VKYrc?=
 =?iso-8859-1?Q?SGtecFcoQEtYodexQVxcguxOcihVrJKAlwFZ0F/anCVJhWDtXEOSmLzpXj?=
 =?iso-8859-1?Q?KnVFsrdVjjCbO1wJRhaPcPQi7JQIbTHDShtY9PxNoTVr9nHXWiF4DXMCPh?=
 =?iso-8859-1?Q?Jc96aR18lqVGK4YDGOOc8PmFPd/LbACyS6Jq4rOr2PxTEziMm1ygISWvO3?=
 =?iso-8859-1?Q?5E8UFfB6YJ5KEmIX4/P9FkOyf54zeVVK+EhkSQxcCNdM+S7wetIv4qyvMs?=
 =?iso-8859-1?Q?e2SuEwCk1ZkduFOyZLH43PgJ2B+CTM5ddpo7rRL9SA/Xlf5uw1CgxHwo1k?=
 =?iso-8859-1?Q?Qimi9xcw0KIvhasT0PYS/Q35Rppfo62tGcunrhzFqNac3Pnj5PA2HDHANS?=
 =?iso-8859-1?Q?L3j8ZFRDr5SX0a68TmHs0weXrR5F/QJngcfb2U6/f09KGq2npyzcMzpD12?=
 =?iso-8859-1?Q?i2iGxg1erajogYov7lTfLBBbqWAEiMcWWp9uj3IiKyCzb/586lhI6PAHu3?=
 =?iso-8859-1?Q?APqD12NuO550b3NzHR9IjOKLwvo7ZOtFiG4+P3e9GxkZxu6EWFbG06X0u/?=
 =?iso-8859-1?Q?VrNvexZNR6axV2IpWdHKwJzPlDCPU1RzucFFIlpOT3LJg3PRki2fxKlyBT?=
 =?iso-8859-1?Q?IcRHdbL1y9fI5ExMUgBIB8SvwWCGz5HDOC80Wq81wWVFnvZCTIPqhJgvJN?=
 =?iso-8859-1?Q?zyZ8fhSgBTuDJtDPh4uFZ/DcsAXH95SXIzwL4FZmalIfUow9VMo0NLx+YP?=
 =?iso-8859-1?Q?fKUJrstRh+2hR763f+OxR2wLGY+kKSxsu9FXzIfH5ndMaw9zAQZMnzpO8e?=
 =?iso-8859-1?Q?DNUBaGBSRjSr+fLQLJy5XJlCUJ1mZvYoM51YHWJ5igSoIT+GaXxKpz+Nvc?=
 =?iso-8859-1?Q?BWWDXKFvHg/JUv0Zd+JItgs9PK1QaIS9TC61EUYOEIocmtKZvHuLincA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1382213a-f308-4c11-a4e4-08de28116808
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 08:47:16.1376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecxvHl4zlLrHyrTCw5NOvdQhnAtRs/SG5zLUbofidyOdwG0Ua9LsuxTBiN1823PgWNJJX7EOtpEsEBnDLwxIhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFFA27DACA6
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 136A0180004
X-Rspamd-Server: rspam07
X-Stat-Signature: yhae8q7qbi6u5nw5xc5cyd5f4wjx77q7
X-Rspam-User: 
X-HE-Tag: 1763628450-173608
X-HE-Meta: U2FsdGVkX19PwYlcW27gI/kypSq2VIoIcZzl+YTxs/pQmOzkGNYQ0VfMmsLIymMOuMRZBbeCw6n+emS8A9F66hZn/XUX4kdZ8Hmp4jTa/JbNtlXW3vNr0svgaWcYArjL47F6NTLTl//V6+i3IM2E6lANXBSIikH4+zFthSwuKUereIXBgKHzDVsyDzfT3zgMZySH02SOSg8yFOidtbQe67GogVV/2/ydeqIKRQ7EIQI0i6v466S/T9emraHsf69qazTGpIhEGCMik1CYOgvqL6OjeS0pVLAj9Rs0BswiZMakQey28HNJhAQvBc3u1Rn0ZAC/txaPdetq1n9JhY7/T9tuZ0AdHo1V4Eh9UV7l/rRiSYbpYH3e3+1qhVUZ0gmppJE5fxaxJPhXGHvGphpsBucRllST3IjcB7PGPCppVlhKrGl/6kFlzO2lowQLJo8sbdNXe/w3nGefteeoVvplwlcmnUdDu5EmRdGXevBuZgLn/4sU1nmYK6eDrqBdTFP/DenOmTpuaNyC44koTEbQIDWrjA4ysb6i13bWTuMhmAtSxCmYhPK8iQMDPlP0+RqdATdWmiVZYxS1M1HRTiNEBSt2p/AU6fqCjciPWRF2B6/is4eUMGD1ZifZkjmUgRWD5YLrA2rzR0+5G2qYgUHCeMO1aMSIZFLXcOF4DsoG2P6nAiNdZ2UCtKrGP+YE73MUL1U3BChnE6wHxlEMItpIXxbazHVJBPVF9qYoFVtZ9VD6uxGJvuOY2v2IDcRxxFI8G67oaCdoWQWzLvqmymH1SM7h9+Dx+s97C02OXGDn+hG1rbzRf95uW27DnKV65ezqwOkS8ISHDpFgx7qgoN484mwbBgp1YprSKd9ezktzkiDSKmJoF6X4yEYeHU2xoaerocSeJbuYB28xrBi++9oRQmRFSNttfZNsZELsN8HumYKI9uZgouTUoSg6ehPUdAJIKKz1sIm2GMxrCm/83oX
 +C2rNe2I
 PrEXcoKDIhq6Xd5PJX8L6wTsC+v0pGgVgrQPmhpUczZFPtA5PCJBn1fYWxaqRcR7524uSplzFO4Cd+hSCvrv7dGT3HaTGdOrMd99u24An2Ej2sE/F5XNEjnFcftkzqBefOS5oivzfuATUejZgSInf10GVhCaeXajAW4XtfJ84h+2VX/6UHhmI/xn6xVeaWkgRS3M2HhwaeSo8R+kvXIts7ltpq0o6Q6kZ4L0RzIE61wbN13+vcJw/HpHhfgPO4Nh6c829YOpUgofdPfo23rG7zm6V2uDD6o1vuCFt+42Drr9/V4eNfunJbRFqyBKSooO2CYbMVGWAvLxtABCWmLf+Oou0DP7vGpNlNYDnp8WZRh64pEqprSivfastF7E+ntMIKuCTv/EA40HDZ0H6ZvJ0eUf7YTlYo7px4JDBdHfBhWrCXYmkKCb+K+gzScHDMd4B4RquabUYQ8k7DHILoYycSGWH+BWtpjw1uUXg2fyYv2oPNf+rroyrNGH8iePDN2//S28IRvjhJ2TUVLK++1IE/qXxgx9TgzjRY+/Yj3E56XDE5+k0WZief/g/3vmTRl0o+Q6uMfig+EZblzaj07gqqsqIoaX4aVNg1TGNsZ22tzLdWt8GcnW73142LsHh6k6cTmrUbjra5aU/pmzRcDhsrUFKo5E0n52nrpUjIfk1qOrlIhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 51.6% regression of stress-ng.mmapfiles.ops_per_sec on:


commit: ec66e0d599520ab414db745544e25d80d0ac5054 ("slab: add sheaf support for batching kfree_rcu() operations")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      23cb64fb76257309e396ea4cec8396d4a1dbae68]
[still regression on linux-next/master fe4d0dea039f2befb93f27569593ec209843b0f5]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: mmapfiles
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511201550.3efbe5c2-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251120/202511201550.3efbe5c2-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp7/mmapfiles/stress-ng/60s

commit: 
  2d517aa09b ("slab: add opt-in caching layer of percpu sheaves")
  ec66e0d599 ("slab: add sheaf support for batching kfree_rcu() operations")

2d517aa09bbc4203 ec66e0d599520ab414db745544e 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      5101 ±  3%     +31.9%       6730        uptime.idle
 1.945e+09 ±  8%     +84.4%  3.587e+09        cpuidle..time
   1066989 ±  4%     -52.2%     509858 ±  2%  cpuidle..usage
    111039 ±  8%     -23.1%      85351        meminfo.Mapped
    117474 ±  9%     -64.3%      41938 ±  5%  meminfo.Shmem
     20973 ± 52%     -66.9%       6935 ± 51%  numa-meminfo.node0.Shmem
     96825 ± 14%     -64.2%      34686 ± 12%  numa-meminfo.node1.Shmem
    805213 ±  6%     -37.8%     500443 ±  8%  numa-numastat.node0.local_node
    846564 ±  6%     -36.2%     539718 ±  5%  numa-numastat.node0.numa_hit
    926087 ±  5%     -43.7%     521121 ±  8%  numa-numastat.node1.local_node
    950918 ±  5%     -42.4%     548005 ±  5%  numa-numastat.node1.numa_hit
     17592 ± 14%     -86.9%       2310 ± 62%  perf-c2c.DRAM.remote
     26251 ± 15%     -97.9%     560.50 ± 42%  perf-c2c.HITM.local
     12343 ± 21%     -98.3%     212.83 ± 33%  perf-c2c.HITM.remote
     38594 ± 13%     -98.0%     773.33 ± 28%  perf-c2c.HITM.total
     49.06 ±  8%     +38.2       87.22        mpstat.cpu.all.idle%
      0.26 ±  4%      -0.2        0.07 ±  2%  mpstat.cpu.all.irq%
      0.34 ±  5%      -0.2        0.14 ±  2%  mpstat.cpu.all.soft%
     46.59 ±  8%     -37.0        9.54 ±  2%  mpstat.cpu.all.sys%
      3.75 ±  3%      -0.7        3.03 ±  2%  mpstat.cpu.all.usr%
      5301 ± 52%     -67.5%       1725 ± 50%  numa-vmstat.node0.nr_shmem
    846980 ±  6%     -36.3%     539228 ±  5%  numa-vmstat.node0.numa_hit
    805629 ±  6%     -37.9%     499953 ±  8%  numa-vmstat.node0.numa_local
     24340 ± 14%     -64.7%       8598 ± 13%  numa-vmstat.node1.nr_shmem
    950685 ±  5%     -42.5%     546781 ±  5%  numa-vmstat.node1.numa_hit
    925853 ±  5%     -43.8%     519898 ±  8%  numa-vmstat.node1.numa_local
     42.78 ± 20%    +128.7%      97.82 ±  6%  perf-sched.total_wait_and_delay.average.ms
     27411 ± 17%     -73.7%       7217 ±  7%  perf-sched.total_wait_and_delay.count.ms
     42.68 ± 20%    +129.2%      97.80 ±  6%  perf-sched.total_wait_time.average.ms
     42.78 ± 20%    +128.7%      97.82 ±  6%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     27411 ± 17%     -73.7%       7217 ±  7%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     42.68 ± 20%    +129.2%      97.80 ±  6%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    948660            -2.0%     929444        proc-vmstat.nr_file_pages
     28101 ±  8%     -23.3%      21556        proc-vmstat.nr_mapped
     29493 ±  9%     -65.0%      10329 ±  4%  proc-vmstat.nr_shmem
     37019 ± 36%     -66.8%      12299 ± 70%  proc-vmstat.numa_hint_faults_local
   1799984 ±  2%     -39.5%    1088731        proc-vmstat.numa_hit
   1733801 ±  2%     -41.0%    1022572        proc-vmstat.numa_local
   4027921 ±  2%     -43.2%    2287803        proc-vmstat.pgalloc_normal
    515117 ±  6%     -14.7%     439270 ±  3%  proc-vmstat.pgfault
   3875358 ±  2%     -43.8%    2177651        proc-vmstat.pgfree
    162347 ±  2%      +6.6%     173058        stress-ng.mmapfiles.file_mmaps_per_sec
    227714 ±  2%     +18.3%     269275        stress-ng.mmapfiles.file_munmap_per_sec
   6730769 ±  2%      +6.5%    7165751        stress-ng.mmapfiles.file_pages_mmap'd_per_sec
   9440223 ±  2%     +18.1%   11149909        stress-ng.mmapfiles.file_pages_munmap'd_per_sec
  14347199 ±  4%     -50.6%    7081102 ±  2%  stress-ng.mmapfiles.ops
    238147 ±  4%     -51.6%     115229 ±  2%  stress-ng.mmapfiles.ops_per_sec
     40725 ±  3%     -61.7%      15591 ± 15%  stress-ng.time.involuntary_context_switches
    130760 ±  5%     -44.6%      72390 ±  9%  stress-ng.time.minor_page_faults
      3062 ±  8%     -80.1%     609.00 ±  2%  stress-ng.time.percent_of_cpu_this_job_got
      1822 ±  8%     -79.6%     371.22 ±  2%  stress-ng.time.system_time
     27.22 ±  7%     -62.5%      10.20 ±  3%  stress-ng.time.user_time
    128468 ± 14%     -92.6%       9544 ± 13%  stress-ng.time.voluntary_context_switches
      1582 ±  8%     -74.7%     400.00        turbostat.Avg_MHz
     51.16 ±  8%     -38.2       12.94        turbostat.Busy%
      1.84 ±  7%      -1.5        0.32 ±  8%  turbostat.C1E%
     47.08 ±  8%     +39.7       86.77        turbostat.C6%
     17.56 ± 14%     +35.8%      23.85        turbostat.CPU%c1
     10.91 ± 22%    +419.9%      56.73        turbostat.CPU%c6
     66.50            -9.5%      60.17 ±  2%  turbostat.CoreTmp
      0.25 ±  8%     +98.0%       0.50        turbostat.IPC
   6165713 ±  6%     -76.8%    1429713 ±  3%  turbostat.IRQ
   1607348 ±  8%     -85.6%     231500 ±  8%  turbostat.NMI
      0.21 ± 64%    +151.2%       0.52 ± 57%  turbostat.Pkg%pc2
     67.33            -8.9%      61.33 ±  2%  turbostat.PkgTmp
    193.47           -26.9%     141.49        turbostat.PkgWatt
     14.64            -2.8%      14.23        turbostat.RAMWatt
    692012 ± 11%     -95.6%      30567 ±176%  sched_debug.cfs_rq:/.avg_vruntime.avg
    843998 ± 11%     -87.6%     105070 ± 59%  sched_debug.cfs_rq:/.avg_vruntime.max
    586404 ± 12%     -96.3%      21456 ±217%  sched_debug.cfs_rq:/.avg_vruntime.min
     50250 ±  9%     -73.3%      13437 ± 22%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.43 ± 26%     -49.1%       0.22 ± 22%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.43 ± 26%     -48.9%       0.22 ± 22%  sched_debug.cfs_rq:/.h_nr_runnable.avg
    191.51 ± 25%     +49.4%     286.08 ± 21%  sched_debug.cfs_rq:/.load_avg.stddev
    692012 ± 11%     -95.6%      30567 ±176%  sched_debug.cfs_rq:/.min_vruntime.avg
    843998 ± 11%     -87.6%     105070 ± 59%  sched_debug.cfs_rq:/.min_vruntime.max
    586404 ± 12%     -96.3%      21456 ±217%  sched_debug.cfs_rq:/.min_vruntime.min
     50250 ±  9%     -73.3%      13437 ± 22%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.43 ± 25%     -48.9%       0.22 ± 21%  sched_debug.cfs_rq:/.nr_queued.avg
    125.12 ± 14%    +100.7%     251.12 ± 26%  sched_debug.cfs_rq:/.removed.load_avg.stddev
    140.75 ± 38%     -63.2%      51.76 ± 18%  sched_debug.cfs_rq:/.util_est.avg
   1589174 ± 17%     -31.7%    1085437 ± 24%  sched_debug.cpu.avg_idle.avg
     84100           -30.2%      58725 ± 19%  sched_debug.cpu.clock.avg
     84105           -30.2%      58729 ± 19%  sched_debug.cpu.clock.max
     84094           -30.2%      58716 ± 19%  sched_debug.cpu.clock.min
     83671           -30.1%      58446 ± 19%  sched_debug.cpu.clock_task.avg
     83965           -30.1%      58706 ± 19%  sched_debug.cpu.clock_task.max
     75446           -33.2%      50369 ± 22%  sched_debug.cpu.clock_task.min
      2514 ± 27%     -57.3%       1074 ± 18%  sched_debug.cpu.curr->pid.avg
   1144485           -19.6%     919879 ±  8%  sched_debug.cpu.max_idle_balance_cost.avg
    915997 ±  8%     -45.4%     500000        sched_debug.cpu.max_idle_balance_cost.min
    180422 ±  9%     +95.0%     351823 ±  5%  sched_debug.cpu.max_idle_balance_cost.stddev
      0.42 ± 25%     -48.3%       0.22 ± 19%  sched_debug.cpu.nr_running.avg
      7294 ±  4%     -63.9%       2636 ± 24%  sched_debug.cpu.nr_switches.avg
     16562 ±  7%     -38.9%      10112 ± 13%  sched_debug.cpu.nr_switches.max
      3591 ± 13%     -89.3%     383.00 ± 35%  sched_debug.cpu.nr_switches.min
     84094           -30.2%      58721 ± 19%  sched_debug.cpu_clk
     83382           -30.4%      58008 ± 19%  sched_debug.ktime
     85326           -29.9%      59776 ± 18%  sched_debug.sched_clk
      1.30 ±  3%     +12.6%       1.46        perf-stat.i.MPKI
 5.487e+09           -49.8%  2.754e+09 ±  2%  perf-stat.i.branch-instructions
      1.62 ±  4%      +1.6        3.26        perf-stat.i.branch-miss-rate%
  82380569 ±  3%      -9.7%   74393638 ±  2%  perf-stat.i.branch-misses
     38.92 ±  2%     +21.7       60.64        perf-stat.i.cache-miss-rate%
  33723559 ±  2%     -42.5%   19401136 ±  2%  perf-stat.i.cache-misses
  91887377 ±  7%     -64.2%   32858366 ±  2%  perf-stat.i.cache-references
     10263 ±  6%     -68.9%       3193 ±  5%  perf-stat.i.context-switches
      4.28 ±  9%     -60.7%       1.68 ±  2%  perf-stat.i.cpi
 1.026e+11 ±  8%     -74.6%  2.603e+10        perf-stat.i.cpu-cycles
    271.97 ±  6%     -55.8%     120.25 ±  3%  perf-stat.i.cpu-migrations
      3718 ± 11%     -66.4%       1248 ±  4%  perf-stat.i.cycles-between-cache-misses
 2.512e+10           -48.8%  1.286e+10 ±  2%  perf-stat.i.instructions
      0.28 ±  7%    +158.0%       0.72        perf-stat.i.ipc
      6900 ±  9%     -18.4%       5628 ±  3%  perf-stat.i.minor-faults
      6900 ±  9%     -18.4%       5628 ±  3%  perf-stat.i.page-faults
      1.34 ±  3%     +12.4%       1.51        perf-stat.overall.MPKI
      1.50 ±  4%      +1.2        2.70        perf-stat.overall.branch-miss-rate%
     36.77 ±  5%     +22.2       59.01        perf-stat.overall.cache-miss-rate%
      4.09 ±  7%     -50.5%       2.03        perf-stat.overall.cpi
      3050 ±  8%     -56.0%       1342        perf-stat.overall.cycles-between-cache-misses
      0.25 ±  7%    +100.8%       0.49        perf-stat.overall.ipc
  5.39e+09           -49.7%  2.709e+09 ±  2%  perf-stat.ps.branch-instructions
  80929629 ±  3%      -9.6%   73166120 ±  2%  perf-stat.ps.branch-misses
  33114569 ±  2%     -42.4%   19077924 ±  2%  perf-stat.ps.cache-misses
  90432277 ±  7%     -64.2%   32336218 ±  2%  perf-stat.ps.cache-references
     10086 ±  6%     -68.8%       3143 ±  5%  perf-stat.ps.context-switches
 1.009e+11 ±  8%     -74.6%  2.561e+10        perf-stat.ps.cpu-cycles
    267.93 ±  6%     -55.8%     118.42 ±  3%  perf-stat.ps.cpu-migrations
 2.468e+10           -48.7%  1.265e+10 ±  2%  perf-stat.ps.instructions
      6756 ±  9%     -18.1%       5531 ±  3%  perf-stat.ps.minor-faults
      6756 ±  9%     -18.1%       5531 ±  3%  perf-stat.ps.page-faults
 1.515e+12           -46.8%  8.056e+11 ±  2%  perf-stat.total.instructions
     58.02 ± 29%     -49.4        8.66 ± 48%  perf-profile.calltrace.cycles-pp.link_path_walk.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
     70.23 ± 20%     -48.0       22.23 ± 38%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
     70.28 ± 20%     -47.9       22.34 ± 38%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     61.36 ± 19%     -40.7       20.67 ± 37%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     61.38 ± 19%     -40.7       20.71 ± 37%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     64.54 ± 16%     -30.3       34.20 ± 20%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     64.58 ± 16%     -30.3       34.29 ± 20%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     20.45 ± 64%     -16.8        3.69 ± 55%  perf-profile.calltrace.cycles-pp.inode_permission.link_path_walk.path_openat.do_filp_open.do_sys_openat2
     18.05 ± 69%     -16.1        1.92 ± 54%  perf-profile.calltrace.cycles-pp.kernfs_iop_permission.inode_permission.link_path_walk.path_openat.do_filp_open
     17.76 ± 67%     -15.6        2.13 ± 42%  perf-profile.calltrace.cycles-pp.lookup_fast.walk_component.link_path_walk.path_openat.do_filp_open
     17.87 ± 66%     -15.6        2.29 ± 42%  perf-profile.calltrace.cycles-pp.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2
     15.70 ± 80%     -14.7        1.02 ± 58%  perf-profile.calltrace.cycles-pp.step_into.link_path_walk.path_openat.do_filp_open.do_sys_openat2
     14.93 ± 86%     -14.5        0.38 ±103%  perf-profile.calltrace.cycles-pp.__d_lookup.lookup_fast.walk_component.link_path_walk.path_openat
     14.74 ± 87%     -14.5        0.21 ±144%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__d_lookup.lookup_fast.walk_component.link_path_walk
     14.77 ± 85%     -14.3        0.42 ± 74%  perf-profile.calltrace.cycles-pp.dput.step_into.link_path_walk.path_openat.do_filp_open
     13.41 ± 96%     -13.4        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.__d_lookup.lookup_fast.walk_component
     13.02 ± 99%     -13.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.dput.step_into.link_path_walk.path_openat
     12.96 ± 99%     -13.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.dput.step_into.link_path_walk
      9.36 ± 74%      -8.8        0.55 ± 85%  perf-profile.calltrace.cycles-pp.down_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
      7.71 ± 68%      -7.2        0.53 ±109%  perf-profile.calltrace.cycles-pp.up_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
      9.55 ± 23%      -6.6        2.95 ± 41%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      9.55 ± 23%      -6.6        2.95 ± 41%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      9.50 ± 23%      -6.6        2.92 ± 42%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      9.49 ± 23%      -6.6        2.91 ± 41%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      9.60 ± 22%      -6.5        3.05 ± 42%  perf-profile.calltrace.cycles-pp.__open64_nocancel
      1.91 ± 78%      -1.5        0.39 ±101%  perf-profile.calltrace.cycles-pp.down_read.kernfs_dop_revalidate.lookup_fast.walk_component.link_path_walk
      0.38 ±108%      +0.9        1.28 ± 29%  perf-profile.calltrace.cycles-pp.kernfs_fop_open.do_dentry_open.vfs_open.do_open.path_openat
      0.00            +1.0        0.99 ± 46%  perf-profile.calltrace.cycles-pp.generic_fillattr.kernfs_iop_getattr.vfs_getattr_nosec.vfs_fstat.__do_sys_newfstat
      0.24 ±150%      +1.1        1.36 ± 33%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      0.12 ±223%      +1.2        1.37 ± 52%  perf-profile.calltrace.cycles-pp.copy_folio_from_iter_atomic.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
      0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations
      0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.x86_64_start_kernel.common_startup_64
      0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.00            +1.4        1.38 ± 29%  perf-profile.calltrace.cycles-pp.errseq_sample.do_dentry_open.vfs_open.do_open.path_openat
      0.65 ±100%      +1.5        2.19 ± 40%  perf-profile.calltrace.cycles-pp.record__pushfn.perf_mmap__push.record__mmap_read_evlist.cmd_record.perf_c2c__record
      0.61 ±100%      +1.6        2.18 ± 40%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push.record__mmap_read_evlist.cmd_record
      0.60 ±100%      +1.6        2.18 ± 40%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push.record__mmap_read_evlist
      0.58 ±101%      +1.6        2.18 ± 40%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push
      0.58 ± 83%      +1.6        2.20 ± 44%  perf-profile.calltrace.cycles-pp.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.55 ±101%      +1.6        2.17 ± 40%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn
      0.53 ±101%      +1.6        2.16 ± 40%  perf-profile.calltrace.cycles-pp.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.7        1.66 ± 47%  perf-profile.calltrace.cycles-pp.console_flush_all.console_unlock.vprintk_emit._printk.irq_work_run_list
      0.00            +1.7        1.66 ± 47%  perf-profile.calltrace.cycles-pp.console_unlock.vprintk_emit._printk.irq_work_run_list.irq_work_run
      0.50 ±102%      +1.7        2.16 ± 40%  perf-profile.calltrace.cycles-pp.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64
      0.00            +1.7        1.69 ± 44%  perf-profile.calltrace.cycles-pp._printk.irq_work_run_list.irq_work_run.__sysvec_irq_work.sysvec_irq_work
      0.00            +1.7        1.69 ± 44%  perf-profile.calltrace.cycles-pp.irq_work_run_list.irq_work_run.__sysvec_irq_work.sysvec_irq_work.asm_sysvec_irq_work
      0.00            +1.7        1.69 ± 44%  perf-profile.calltrace.cycles-pp.vprintk_emit._printk.irq_work_run_list.irq_work_run.__sysvec_irq_work
      0.70 ± 86%      +1.8        2.53 ± 34%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      0.74 ± 85%      +2.0        2.70 ± 34%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      0.85 ± 83%      +2.1        2.99 ± 32%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      0.85 ± 83%      +2.1        3.00 ± 32%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      0.85 ± 83%      +2.1        3.00 ± 32%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      0.69 ± 85%      +2.2        2.91 ± 39%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      0.97 ± 83%      +2.2        3.20 ± 42%  perf-profile.calltrace.cycles-pp.handle_internal_command.main
      0.97 ± 83%      +2.2        3.20 ± 42%  perf-profile.calltrace.cycles-pp.main
      0.97 ± 83%      +2.2        3.20 ± 42%  perf-profile.calltrace.cycles-pp.run_builtin.handle_internal_command.main
      0.32 ±103%      +2.4        2.77 ± 41%  perf-profile.calltrace.cycles-pp.__d_lookup.lookup_fast.open_last_lookups.path_openat.do_filp_open
      1.10 ± 51%      +3.3        4.36 ± 37%  perf-profile.calltrace.cycles-pp.lookup_fast.open_last_lookups.path_openat.do_filp_open.do_sys_openat2
      1.30 ± 36%      +3.3        4.58 ± 38%  perf-profile.calltrace.cycles-pp.open_last_lookups.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      1.04 ± 68%      +3.3        4.33 ± 37%  perf-profile.calltrace.cycles-pp.common_startup_64
      0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.ast_mode_config_helper_atomic_commit_tail.commit_tail.drm_atomic_helper_commit.drm_atomic_commit.drm_atomic_helper_dirtyfb
      0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_helper_commit_tail.ast_mode_config_helper_atomic_commit_tail.commit_tail.drm_atomic_helper_commit.drm_atomic_commit
      0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.commit_tail.drm_atomic_helper_commit.drm_atomic_commit.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty
      0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_helper_commit.drm_atomic_commit.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work
      0.26 ±223%     +11.6       11.90 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_commit.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work.process_one_work
      0.26 ±223%     +11.6       11.91 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work.process_one_work.worker_thread
      0.26 ±223%     +11.6       11.91 ±118%  perf-profile.calltrace.cycles-pp.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work.process_one_work.worker_thread.kthread
      0.26 ±223%     +11.7       11.91 ±118%  perf-profile.calltrace.cycles-pp.drm_fb_helper_damage_work.process_one_work.worker_thread.kthread.ret_from_fork
      0.47 ±128%     +11.7       12.21 ±115%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.67 ± 93%     +11.8       12.44 ±112%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      0.67 ± 93%     +11.8       12.44 ±112%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      0.67 ± 93%     +11.8       12.44 ±112%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.27 ±223%     +11.9       12.17 ±115%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     58.10 ± 29%     -49.2        8.92 ± 45%  perf-profile.children.cycles-pp.link_path_walk
     70.25 ± 20%     -48.0       22.27 ± 38%  perf-profile.children.cycles-pp.path_openat
     70.29 ± 20%     -47.9       22.36 ± 38%  perf-profile.children.cycles-pp.do_filp_open
     70.86 ± 20%     -47.3       23.61 ± 38%  perf-profile.children.cycles-pp.do_sys_openat2
     70.88 ± 20%     -47.2       23.65 ± 38%  perf-profile.children.cycles-pp.__x64_sys_openat
     35.18 ± 65%     -35.1        0.07 ±141%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     36.83 ± 63%     -34.8        1.99 ± 37%  perf-profile.children.cycles-pp._raw_spin_lock
     95.60           -19.4       76.22 ± 15%  perf-profile.children.cycles-pp.do_syscall_64
     95.71           -19.2       76.47 ± 15%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     20.38 ± 69%     -17.8        2.57 ± 49%  perf-profile.children.cycles-pp.kernfs_iop_permission
     18.81 ± 62%     -17.1        1.71 ± 44%  perf-profile.children.cycles-pp.dput
     17.89 ± 66%     -15.3        2.55 ± 39%  perf-profile.children.cycles-pp.walk_component
     15.83 ± 79%     -14.4        1.47 ± 45%  perf-profile.children.cycles-pp.step_into
     15.19 ± 70%     -13.3        1.84 ± 55%  perf-profile.children.cycles-pp.down_read
     19.12 ± 60%     -12.2        6.88 ± 35%  perf-profile.children.cycles-pp.lookup_fast
     15.62 ± 81%     -11.8        3.87 ± 35%  perf-profile.children.cycles-pp.__d_lookup
      9.24 ± 66%      -7.6        1.61 ± 49%  perf-profile.children.cycles-pp.up_read
      9.61 ± 22%      -6.5        3.12 ± 42%  perf-profile.children.cycles-pp.__open64_nocancel
      3.56 ±131%      -3.1        0.43 ± 67%  perf-profile.children.cycles-pp.lockref_get_not_dead
      3.12 ±132%      -3.1        0.05 ± 73%  perf-profile.children.cycles-pp.__mutex_lock
      2.68 ± 33%      -1.5        1.15 ± 58%  perf-profile.children.cycles-pp.lockref_put_return
      0.47 ± 51%      -0.3        0.20 ± 73%  perf-profile.children.cycles-pp.set_nlink
      0.17 ± 44%      -0.1        0.04 ± 72%  perf-profile.children.cycles-pp.mutex_spin_on_owner
      0.02 ±144%      +0.1        0.09 ± 26%  perf-profile.children.cycles-pp.schedule_idle
      0.02 ±145%      +0.1        0.11 ± 40%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.05 ±117%      +0.1        0.14 ± 34%  perf-profile.children.cycles-pp.kfree_rcu_work
      0.00            +0.1        0.10 ± 49%  perf-profile.children.cycles-pp.__evlist__enable
      0.00            +0.1        0.10 ± 30%  perf-profile.children.cycles-pp.load_elf_binary
      0.00            +0.1        0.10 ± 29%  perf-profile.children.cycles-pp.exec_binprm
      0.00            +0.1        0.11 ± 21%  perf-profile.children.cycles-pp.shmem_add_to_page_cache
      0.08 ± 23%      +0.1        0.19 ± 26%  perf-profile.children.cycles-pp.native_sched_clock
      0.10 ± 30%      +0.1        0.21 ± 29%  perf-profile.children.cycles-pp.seq_open
      0.01 ±223%      +0.1        0.12 ± 36%  perf-profile.children.cycles-pp.__kernfs_iattrs
      0.11 ± 53%      +0.1        0.23 ± 29%  perf-profile.children.cycles-pp.build_detached_freelist
      0.00            +0.1        0.12 ± 34%  perf-profile.children.cycles-pp.bprm_execve
      0.05 ±107%      +0.1        0.17 ± 24%  perf-profile.children.cycles-pp.sched_balance_newidle
      0.01 ±223%      +0.1        0.14 ± 31%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.06 ± 55%      +0.1        0.19 ± 48%  perf-profile.children.cycles-pp.strcmp
      0.00            +0.1        0.13 ± 54%  perf-profile.children.cycles-pp.__x64_sys_exit_group
      0.00            +0.1        0.13 ± 54%  perf-profile.children.cycles-pp.do_exit
      0.00            +0.1        0.13 ± 54%  perf-profile.children.cycles-pp.do_group_exit
      0.08 ± 68%      +0.1        0.22 ± 20%  perf-profile.children.cycles-pp.__pick_next_task
      0.04 ± 75%      +0.1        0.18 ± 39%  perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
      0.03 ±103%      +0.1        0.17 ± 32%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.00            +0.1        0.14 ± 40%  perf-profile.children.cycles-pp.read_counters
      0.00            +0.1        0.14 ± 59%  perf-profile.children.cycles-pp.evlist_cpu_iterator__next
      0.11 ± 68%      +0.1        0.25 ± 24%  perf-profile.children.cycles-pp.schedule
      0.02 ±223%      +0.2        0.17 ± 46%  perf-profile.children.cycles-pp.sysvec_call_function_single
      0.05 ±110%      +0.2        0.20 ± 29%  perf-profile.children.cycles-pp.zap_pte_range
      0.00            +0.2        0.16 ± 43%  perf-profile.children.cycles-pp.process_interval
      0.06 ± 55%      +0.2        0.22 ± 55%  perf-profile.children.cycles-pp.get_state_synchronize_rcu_full
      0.00            +0.2        0.16 ± 41%  perf-profile.children.cycles-pp.cmd_stat
      0.00            +0.2        0.16 ± 41%  perf-profile.children.cycles-pp.dispatch_events
      0.08 ± 64%      +0.2        0.24 ± 40%  perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
      0.00            +0.2        0.16 ± 52%  perf-profile.children.cycles-pp.idle_cpu
      0.07 ± 72%      +0.2        0.23 ± 37%  perf-profile.children.cycles-pp.kernfs_refresh_inode
      0.11 ± 38%      +0.2        0.27 ± 35%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.02 ±223%      +0.2        0.18 ± 46%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.07 ± 85%      +0.2        0.25 ± 30%  perf-profile.children.cycles-pp.zap_pmd_range
      0.00            +0.2        0.18 ± 39%  perf-profile.children.cycles-pp.__x64_sys_execve
      0.00            +0.2        0.18 ± 39%  perf-profile.children.cycles-pp.do_execveat_common
      0.00            +0.2        0.18 ± 39%  perf-profile.children.cycles-pp.execve
      0.06 ± 74%      +0.2        0.26 ± 31%  perf-profile.children.cycles-pp.strlen
      0.09 ± 52%      +0.2        0.30 ± 50%  perf-profile.children.cycles-pp.x64_sys_call
      0.15 ± 57%      +0.2        0.37 ± 27%  perf-profile.children.cycles-pp.__schedule
      0.00            +0.2        0.22 ± 65%  perf-profile.children.cycles-pp.sched_setaffinity
      0.12 ± 67%      +0.2        0.35 ± 27%  perf-profile.children.cycles-pp.unmap_page_range
      0.13 ± 41%      +0.2        0.36 ± 48%  perf-profile.children.cycles-pp.kvfree_call_rcu
      0.17 ± 33%      +0.2        0.41 ± 42%  perf-profile.children.cycles-pp.cp_new_stat
      0.03 ±103%      +0.3        0.29 ± 43%  perf-profile.children.cycles-pp.__handle_mm_fault
      0.02 ±141%      +0.3        0.28 ± 44%  perf-profile.children.cycles-pp.vfs_read
      0.25 ± 25%      +0.3        0.52 ± 31%  perf-profile.children.cycles-pp.native_flush_tlb_one_user
      0.02 ±141%      +0.3        0.30 ± 47%  perf-profile.children.cycles-pp.ksys_read
      0.10 ± 37%      +0.3        0.38 ± 27%  perf-profile.children.cycles-pp.shmem_alloc_and_add_folio
      0.03 ±103%      +0.3        0.31 ± 42%  perf-profile.children.cycles-pp.handle_mm_fault
      0.20 ± 48%      +0.3        0.48 ± 23%  perf-profile.children.cycles-pp.unmap_region
      0.03 ±106%      +0.3        0.33 ± 43%  perf-profile.children.cycles-pp.do_user_addr_fault
      0.03 ±106%      +0.3        0.33 ± 43%  perf-profile.children.cycles-pp.exc_page_fault
      0.50 ± 26%      +0.3        0.81 ± 22%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.06 ± 74%      +0.3        0.38 ± 46%  perf-profile.children.cycles-pp.kernfs_dir_pos
      0.04 ±109%      +0.3        0.35 ± 41%  perf-profile.children.cycles-pp.asm_exc_page_fault
      0.19 ± 42%      +0.3        0.52 ± 38%  perf-profile.children.cycles-pp.filldir64
      0.16 ± 35%      +0.3        0.50 ± 31%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.52 ± 26%      +0.3        0.86 ± 21%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.30 ± 36%      +0.4        0.65 ± 36%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.07 ± 67%      +0.4        0.43 ± 31%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.64 ± 25%      +0.4        1.05 ± 24%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.64 ± 25%      +0.4        1.06 ± 24%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.34 ± 66%      +0.5        0.82 ± 29%  perf-profile.children.cycles-pp.unmap_vmas
      0.05 ± 76%      +0.5        0.55 ± 88%  perf-profile.children.cycles-pp.do_poll
      0.07 ± 56%      +0.6        0.62 ± 82%  perf-profile.children.cycles-pp.__x64_sys_poll
      0.07 ± 56%      +0.6        0.62 ± 82%  perf-profile.children.cycles-pp.do_sys_poll
      0.08 ± 64%      +0.6        0.64 ± 59%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.08 ± 67%      +0.6        0.65 ± 59%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.06 ± 90%      +0.6        0.66 ± 64%  perf-profile.children.cycles-pp.sched_balance_domains
      0.02 ±223%      +0.6        0.63 ±115%  perf-profile.children.cycles-pp.bit_putcs
      0.02 ±223%      +0.6        0.64 ±114%  perf-profile.children.cycles-pp.fbcon_putcs
      0.11 ± 69%      +0.6        0.76 ± 54%  perf-profile.children.cycles-pp.sched_balance_rq
      0.17 ± 46%      +0.7        0.82 ± 42%  perf-profile.children.cycles-pp.rb_next
      0.08 ± 59%      +0.7        0.74 ± 71%  perf-profile.children.cycles-pp.do_softirq
      0.02 ±223%      +0.7        0.69 ±114%  perf-profile.children.cycles-pp.fbcon_redraw
      0.02 ±223%      +0.7        0.72 ±114%  perf-profile.children.cycles-pp.con_scroll
      0.02 ±223%      +0.7        0.72 ±114%  perf-profile.children.cycles-pp.fbcon_scroll
      0.02 ±223%      +0.7        0.72 ±114%  perf-profile.children.cycles-pp.lf
      0.11 ± 59%      +0.7        0.82 ± 66%  perf-profile.children.cycles-pp.flush_smp_call_function_queue
      0.02 ±223%      +0.7        0.73 ±113%  perf-profile.children.cycles-pp.vt_console_print
      0.57 ± 48%      +0.7        1.30 ± 28%  perf-profile.children.cycles-pp.kernfs_fop_open
      0.55 ± 28%      +0.9        1.40 ± 37%  perf-profile.children.cycles-pp.its_return_thunk
      0.38 ± 57%      +1.0        1.37 ± 52%  perf-profile.children.cycles-pp.copy_folio_from_iter_atomic
      0.12 ± 61%      +1.0        1.12 ± 50%  perf-profile.children.cycles-pp._nohz_idle_balance
      0.43 ± 66%      +1.1        1.49 ± 33%  perf-profile.children.cycles-pp.intel_idle
      0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.rest_init
      0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.start_kernel
      0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.x86_64_start_kernel
      0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.x86_64_start_reservations
      0.87 ± 50%      +1.3        2.17 ± 33%  perf-profile.children.cycles-pp.mas_empty_area_rev
      0.76 ± 57%      +1.4        2.17 ± 40%  perf-profile.children.cycles-pp.shmem_file_write_iter
      0.19 ± 63%      +1.4        1.62 ± 30%  perf-profile.children.cycles-pp.errseq_sample
      0.72 ± 56%      +1.4        2.16 ± 40%  perf-profile.children.cycles-pp.generic_perform_write
      0.68 ± 56%      +1.5        2.21 ± 44%  perf-profile.children.cycles-pp.kernfs_fop_readdir
      0.37 ± 61%      +1.6        2.00 ± 38%  perf-profile.children.cycles-pp.generic_fillattr
      0.18 ± 35%      +1.6        1.82 ± 34%  perf-profile.children.cycles-pp._printk
      0.19 ± 33%      +1.6        1.84 ± 33%  perf-profile.children.cycles-pp.__sysvec_irq_work
      0.19 ± 33%      +1.6        1.84 ± 33%  perf-profile.children.cycles-pp.irq_work_run
      0.19 ± 33%      +1.7        1.84 ± 33%  perf-profile.children.cycles-pp.irq_work_run_list
      0.19 ± 32%      +1.7        1.84 ± 33%  perf-profile.children.cycles-pp.asm_sysvec_irq_work
      0.19 ± 33%      +1.7        1.84 ± 33%  perf-profile.children.cycles-pp.sysvec_irq_work
      1.50 ± 36%      +1.8        3.30 ± 26%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.96 ± 61%      +2.0        3.00 ± 32%  perf-profile.children.cycles-pp.start_secondary
      1.10 ± 60%      +2.1        3.20 ± 42%  perf-profile.children.cycles-pp.handle_internal_command
      1.10 ± 60%      +2.1        3.20 ± 42%  perf-profile.children.cycles-pp.main
      1.10 ± 60%      +2.1        3.20 ± 42%  perf-profile.children.cycles-pp.run_builtin
      0.86 ± 64%      +2.2        3.09 ± 33%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.86 ± 64%      +2.2        3.10 ± 33%  perf-profile.children.cycles-pp.cpuidle_enter
      0.91 ± 62%      +2.4        3.32 ± 33%  perf-profile.children.cycles-pp.cpuidle_idle_call
      1.49 ± 36%      +3.2        4.70 ± 34%  perf-profile.children.cycles-pp.open_last_lookups
      1.08 ± 61%      +3.3        4.33 ± 37%  perf-profile.children.cycles-pp.do_idle
      1.08 ± 61%      +3.3        4.33 ± 37%  perf-profile.children.cycles-pp.common_startup_64
      1.08 ± 61%      +3.3        4.33 ± 37%  perf-profile.children.cycles-pp.cpu_startup_entry
      0.12 ±137%      +3.7        3.78 ±128%  perf-profile.children.cycles-pp.delay_tsc
      0.29 ± 87%      +6.2        6.45 ±104%  perf-profile.children.cycles-pp.io_serial_in
      0.42 ± 96%      +9.9       10.30 ±112%  perf-profile.children.cycles-pp.wait_for_lsr
      0.46 ± 99%     +11.1       11.60 ±114%  perf-profile.children.cycles-pp.serial8250_console_write
      0.42 ±118%     +11.4       11.81 ±118%  perf-profile.children.cycles-pp.memcpy_toio
      0.42 ±119%     +11.4       11.86 ±118%  perf-profile.children.cycles-pp.ast_primary_plane_helper_atomic_update
      0.42 ±119%     +11.4       11.86 ±118%  perf-profile.children.cycles-pp.drm_fb_memcpy
      0.42 ±119%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.ast_mode_config_helper_atomic_commit_tail
      0.42 ±119%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.drm_atomic_helper_commit_tail
      0.42 ±118%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.drm_atomic_helper_commit
      0.42 ±119%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.commit_tail
      0.42 ±118%     +11.5       11.90 ±118%  perf-profile.children.cycles-pp.drm_atomic_commit
      0.42 ±119%     +11.5       11.91 ±118%  perf-profile.children.cycles-pp.drm_atomic_helper_dirtyfb
      0.42 ±119%     +11.5       11.91 ±118%  perf-profile.children.cycles-pp.drm_fbdev_shmem_helper_fb_dirty
      0.42 ±119%     +11.5       11.91 ±118%  perf-profile.children.cycles-pp.drm_fb_helper_damage_work
      0.59 ± 86%     +11.6       12.21 ±115%  perf-profile.children.cycles-pp.worker_thread
      0.54 ± 92%     +11.6       12.17 ±115%  perf-profile.children.cycles-pp.process_one_work
      0.79 ± 64%     +11.6       12.44 ±112%  perf-profile.children.cycles-pp.kthread
      0.79 ± 64%     +11.6       12.44 ±112%  perf-profile.children.cycles-pp.ret_from_fork
      0.79 ± 64%     +11.6       12.44 ±112%  perf-profile.children.cycles-pp.ret_from_fork_asm
      1.14 ± 71%     +11.7       12.83 ±109%  perf-profile.children.cycles-pp.ksys_write
      1.10 ± 71%     +11.7       12.83 ±109%  perf-profile.children.cycles-pp.vfs_write
      0.49 ±100%     +11.9       12.35 ±114%  perf-profile.children.cycles-pp.console_flush_all
      0.49 ±100%     +11.9       12.35 ±114%  perf-profile.children.cycles-pp.console_unlock
      0.50 ± 98%     +11.9       12.45 ±114%  perf-profile.children.cycles-pp.vprintk_emit
     34.91 ± 66%     -34.8        0.06 ±141%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
     14.53 ± 70%     -13.0        1.57 ± 59%  perf-profile.self.cycles-pp.down_read
      9.15 ± 66%      -7.6        1.54 ± 51%  perf-profile.self.cycles-pp.up_read
      2.59 ± 33%      -1.5        1.11 ± 60%  perf-profile.self.cycles-pp.lockref_put_return
      1.04 ± 27%      -0.6        0.41 ± 70%  perf-profile.self.cycles-pp.lockref_get_not_dead
      0.16 ± 44%      -0.1        0.04 ± 72%  perf-profile.self.cycles-pp.mutex_spin_on_owner
      0.02 ±142%      +0.1        0.11 ± 27%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.01 ±223%      +0.1        0.10 ± 38%  perf-profile.self.cycles-pp.__kernfs_iattrs
      0.00            +0.1        0.10 ± 43%  perf-profile.self.cycles-pp._nohz_idle_balance
      0.07 ± 21%      +0.1        0.17 ± 10%  perf-profile.self.cycles-pp.dput
      0.05 ± 85%      +0.1        0.15 ± 21%  perf-profile.self.cycles-pp.kernfs_iop_permission
      0.08 ± 23%      +0.1        0.19 ± 25%  perf-profile.self.cycles-pp.native_sched_clock
      0.06 ± 63%      +0.1        0.17 ± 48%  perf-profile.self.cycles-pp.strcmp
      0.10 ± 51%      +0.1        0.22 ± 30%  perf-profile.self.cycles-pp.build_detached_freelist
      0.05 ± 74%      +0.1        0.17 ± 40%  perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.06 ± 74%      +0.1        0.20 ± 50%  perf-profile.self.cycles-pp._copy_to_user
      0.00            +0.1        0.14 ± 49%  perf-profile.self.cycles-pp.idle_cpu
      0.01 ±223%      +0.1        0.16 ± 50%  perf-profile.self.cycles-pp.d_same_name
      0.05 ± 76%      +0.2        0.21 ± 53%  perf-profile.self.cycles-pp.get_state_synchronize_rcu_full
      0.10 ± 23%      +0.2        0.27 ± 31%  perf-profile.self.cycles-pp.rcu_all_qs
      0.06 ± 75%      +0.2        0.25 ± 35%  perf-profile.self.cycles-pp.strlen
      0.04 ±104%      +0.2        0.24 ± 42%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.08 ± 53%      +0.2        0.31 ± 30%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.05 ±103%      +0.2        0.30 ± 38%  perf-profile.self.cycles-pp.shmem_write_end
      0.14 ± 26%      +0.3        0.40 ± 42%  perf-profile.self.cycles-pp.step_into
      0.14 ± 38%      +0.3        0.40 ± 32%  perf-profile.self.cycles-pp.filldir64
      0.09 ± 47%      +0.3        0.36 ± 30%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.25 ± 25%      +0.3        0.52 ± 31%  perf-profile.self.cycles-pp.native_flush_tlb_one_user
      0.06 ± 74%      +0.3        0.37 ± 46%  perf-profile.self.cycles-pp.kernfs_dir_pos
      0.16 ± 57%      +0.4        0.56 ± 50%  perf-profile.self.cycles-pp.kernfs_fop_readdir
      0.14 ± 65%      +0.5        0.62 ± 28%  perf-profile.self.cycles-pp.kernfs_dop_revalidate
      0.16 ± 44%      +0.6        0.81 ± 43%  perf-profile.self.cycles-pp.rb_next
      0.36 ± 57%      +0.7        1.02 ± 22%  perf-profile.self.cycles-pp.copy_folio_from_iter_atomic
      0.15 ± 38%      +0.7        0.82 ± 43%  perf-profile.self.cycles-pp.may_open
      0.33 ± 37%      +0.9        1.24 ± 36%  perf-profile.self.cycles-pp.do_dentry_open
      0.43 ± 66%      +1.1        1.49 ± 33%  perf-profile.self.cycles-pp.intel_idle
      0.19 ± 62%      +1.4        1.58 ± 30%  perf-profile.self.cycles-pp.errseq_sample
      0.32 ± 65%      +1.6        1.92 ± 37%  perf-profile.self.cycles-pp.generic_fillattr
      0.40 ± 31%      +2.4        2.82 ± 34%  perf-profile.self.cycles-pp.__d_lookup
      0.12 ±137%      +3.7        3.78 ±128%  perf-profile.self.cycles-pp.delay_tsc
      0.29 ± 87%      +6.2        6.45 ±104%  perf-profile.self.cycles-pp.io_serial_in
      0.39 ±118%     +10.8       11.20 ±120%  perf-profile.self.cycles-pp.memcpy_toio




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


