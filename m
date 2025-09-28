Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDE2CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 05:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A350E8E0003; Sun, 28 Sep 2025 01:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5A68E0001; Sun, 28 Sep 2025 01:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886788E0003; Sun, 28 Sep 2025 01:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67D198E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:18:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10FC35BC48
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 05:18:08 +0000 (UTC)
X-FDA: 83937502656.01.4880F45
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 935061C0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 05:18:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I+/rNulv";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759036684; a=rsa-sha256;
	cv=fail;
	b=YWQ21xObWPwXP8QKI+0eIj3/NRrKqlpCNE9ogemsUXT7H5rF9MafHUI7jJDlH14m3DKKHL
	xLjTgExtdwXxLAZPk4rpAjxjCpEtKv8lOY8e6BmBqsRQooZocO8MPHawHIhcYsKV9Ii55l
	Pa9MC3jwdB9tNNxSQ4358sjELH7D6e0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I+/rNulv";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759036684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=oO8gNM8CDFAsvfdOtUS0PPLToVJ2vKpaspq5PRPwAPg=;
	b=wZncROSXa6A5QLJgbQx0fLq6ICDY/V80RSmsE9iWySzihvG7spx22FiMIP5nzkG1B1uBei
	Iy/3YI7rb/JRummUPe8Egzkq4OQiI445YR6D29FYbo0QyUvkNJSNkj3wksNlPQZGa6DfRk
	qKZy2YrhHj049Ckl+6/um667uhhdvwg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759036683; x=1790572683;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=P+t1B2YEd3UxaUJkoUJvQUI9Ffpwtkjc5JQ3cwaqyms=;
  b=I+/rNulvzqM+Hzcg5tODGcthiXmlq1PqB0E/8BSSAzgeBA9hB12xVWeW
   TqbS5yceAXKZzhdvfWQ+PaDVXa2hTXYAyW9F4b3DzLCRXk2dUoDB4Po0j
   lWMe4kI9efg2dg3wT/kUwPmrN6UbDLsg4uLL99l5WCPJL8JP71Hd0EMZT
   WRzgRDuZg0ri2qKLG/dlmlgUsoprFa872Ns2srHeqIjKPVvoks5zzs59x
   JXHm2K5x4GNxp8QdWInWiQyiNVnhvAbF9pyo9en4HvIhxtuvsjqREpUkc
   EPekiStp7xtLujGZIcUVILF83uT6PFeOErfHR20VJDmINQ8CwV5/+0SJJ
   Q==;
X-CSE-ConnectionGUID: vU4S5yuBQFyswTafS7ww9w==
X-CSE-MsgGUID: Gf+6uwT+SYOaZ3AfsJx59w==
X-IronPort-AV: E=McAfee;i="6800,10657,11566"; a="60525131"
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="60525131"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 22:18:01 -0700
X-CSE-ConnectionGUID: yHXpyEm4Rw+cOoa+RKRaog==
X-CSE-MsgGUID: e52QGFXVRPCBGmJ0qXZWjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="177530741"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 22:18:02 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 27 Sep 2025 22:18:01 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 27 Sep 2025 22:18:01 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 27 Sep 2025 22:17:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3H0oXvelUzAlSyKKILG2SlIKZAiSXmHVpAsFkH0bWZmfK3eNR0KkAb0qvqarCZ5DiN1/R/hY00lF5tbfzhTbXL+GffKpA/O2C6YavMcGu5DDuhwWkQTViJnj+I4yAqRIUiW9//XiOF2RYkXVEkP3xhM1iMFkGh2w/H8BI5i9EXQvlpBFKMgkJSiLMPTMUvGR5kj+InbgprFCu5/hW8ewxC3muy9WUMh76cWQGVlNQKOgo0KWbmYd2jTPQmt9/thuNUqfBFw5qrAZOG31WnkRdWb86+0FfN4aTHdEYcShy3NzcPCI1f9tn3BC6R0Bkecktze6Rh3BHP916axGa4I5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oO8gNM8CDFAsvfdOtUS0PPLToVJ2vKpaspq5PRPwAPg=;
 b=NqN8IweZlZYQtjPnvQCu3IPkaBG2HJ1I1GsolJwJWVxktOAVXx0+gLyAWZNrFOiYUmmt6dHdSb0wHYYw77KK3GvIA9GAp6WBIfzikVfCAe4OFSgmCnFXG8S4R+oRdIOfr9DMvLbdBLvDyLPCgDxeqtfZZp1iY6yu+GyGr5KvE2D6wGbXp6ZXGxkiRpXQm4xZ4m6+1rPAVlFo/sdFhDG3UgWoJFEkknn6D9dgaKR+UmKh1O3JgJXhAxI3Mo56jQewd+vZvPDTrDR57ii2e9sj0pBUCkuA183AZ9Zcxpo3y2FJpu424a2EIfFbr3RgotJpS1zn1IpWWVy8ASFVwlNiYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM6PR11MB4612.namprd11.prod.outlook.com (2603:10b6:5:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Sun, 28 Sep
 2025 05:17:48 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9160.014; Sun, 28 Sep 2025
 05:17:48 +0000
Date: Sun, 28 Sep 2025 13:17:37 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Chris Mason <clm@fb.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>, Andrew Morton
	<akpm@linux-foundation.org>, Kiryl Shutsemau <kirill@shutemov.name>, "Brendan
 Jackman" <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>, "Suren
 Baghdasaryan" <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan
	<ziy@nvidia.com>, <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in
 free_frozen_page_commit
Message-ID: <202509281204.3086f707-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250924204409.1706524-5-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: TPYP295CA0057.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:8::8)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM6PR11MB4612:EE_
X-MS-Office365-Filtering-Correlation-Id: 2834982b-e6d3-46df-1c78-08ddfe4e5d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Qvc8Y3CpTRK78j1VmH805ZQcxrZHEoL6jYJ+e+VXAf76oNQCa8G4wp09scur?=
 =?us-ascii?Q?OaWXb73X8DFs2N40KZMazljr4NKbrbh3TLxo79T+TW9pEKrSYUhVZH6dv/q/?=
 =?us-ascii?Q?fO5HsGkyc6SW62UqMX7yegwxhGsft44DSFOJOdOwonODDENMyhDMJVErv9C2?=
 =?us-ascii?Q?y0DfnhJTFSch4h/N+HLZ+AZuWBxDS/qlaApugOee9FhbkdeMWjXJjHij70np?=
 =?us-ascii?Q?6ByQgOFgsoSiLVGNvbN5j8FY+pI7mvzd4qNGWXoMInoNZ33yao/u3UFcBcqF?=
 =?us-ascii?Q?io8Qkz1LcddV+3CEN1EvPIUEh36LkQwGwfhaqK7XouKw1gXhDHkOSIu9BBKp?=
 =?us-ascii?Q?MZLnv3ICrvGVYc51onU55jwUa40PA4f620Ol6YTgg3pzHPMDSmQZeycFWnpq?=
 =?us-ascii?Q?DinKdLQlBjPnydUJKJ2k3AY04IBvkeTTodEtIVZs8rLDaWQhSc2MPIvR2FBY?=
 =?us-ascii?Q?3FpcBbzyAcWzZ6O3EcBfhwuYd2EJpDaI5rcgsydVTiHeisAAQeQw/drc2oio?=
 =?us-ascii?Q?IjB6E8X7a/bNymMP+R7ffZ9Awr4C5txGrfTZIl3dQjad7UBZggnB59ChaNA1?=
 =?us-ascii?Q?PMorvx5Jp+7sY7QuOPT4Zp+JSuF4OhDiihsN/3jfyYzFy2cRhY2H4jag7ItR?=
 =?us-ascii?Q?jPlmlXsrWe+NJB67/U86IYx0gx6g7z02j3L7SUFBPpoSGon8LP6r118j+/4J?=
 =?us-ascii?Q?FmS/qxcbv7DG/BzawHjEOGT53vveMkhnPSBHia3F9GXKZfyAFvdyN2GsKuVp?=
 =?us-ascii?Q?MDDp6tObTk9pBJUr/Eqj9CjZ5I2Za6kpa+XB8Dnq8I4HF1gWd4XhLzcXBINq?=
 =?us-ascii?Q?0kKSZOpdqUS1o5Xi4iGc0hm3nDWD6t5Ty6fns5G0PYN7a7zJbZPNIYmma2GR?=
 =?us-ascii?Q?SeD7xwWc3Xu+aXxnhgJbILcpCxKGdxHUbZsikIC+xLWvKcwDdPZLRd+qMC1D?=
 =?us-ascii?Q?U2DOijaCm66RjXIUvDWt4UAvu4tejf7hxe4GicG6PvVO5K47FXIx20fS7dy2?=
 =?us-ascii?Q?vgNec9MBqLkF3/3+lz0oAlCUBpvY+q8w/djrtzXiAxo1JiqVi5S+9Yql01NY?=
 =?us-ascii?Q?+ws/s3hi5tl5VS3LzAUlOu9cQDpkYJ33K9rKPfkzJDTDviQyJONvDM9qzSGb?=
 =?us-ascii?Q?+XLlpXoewf1vEWKhbfUhw2PbSJ32uhzh7w1CYSsnSR+DaY+j6sYZZvdB33Ql?=
 =?us-ascii?Q?+ZmwSOBQu4LnCJfjdaClcsMWNmPb3vrSwoH+ayOx/0Z4KMG8gLWEBgPyF+tv?=
 =?us-ascii?Q?7ClKQMYPJMJrsJAq8yBVDXlSXJckJD9yDKCb+xFNTizPGyxL8pTNFWzENLKn?=
 =?us-ascii?Q?49Av7oNep0seyiOE9H2nT17pf1NsNMZ8xlsEXgYRUJCNx3oXlmazbPG+eETq?=
 =?us-ascii?Q?x9hbWrLulHu63KUIG2bbiySV+VR7On0HmWOApstiXEL0l0phJFnh88KJmlYI?=
 =?us-ascii?Q?9/QK2/xkW9M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tDUpq/a+lD6SpywiYq2azpxpS06CY5Jt24GfTTvN9ZllrxbbjJnY6Xg0mPQg?=
 =?us-ascii?Q?Vv/4hPGJsq5f9jSuVVlLgpPVLB1tZzwTBvdMl7sO6MUhGzcyU/QsNjFETJ3d?=
 =?us-ascii?Q?A08I9mKr7W0Gnn6GjMfVHUvgALDdxoLUvMeR7TgUPWs4eHiTvkuUivXICG1B?=
 =?us-ascii?Q?CcBGbBuE7PCFjGhKzebT8WNGhnE26UrmLaoYlFwjiqO9ya7ANV91wBJs+vSh?=
 =?us-ascii?Q?zUAZhXVCxH2Wgi+CgRItiD7mwmdkLrOpycGYS58JOadVM9OMdl6cdmnSRNex?=
 =?us-ascii?Q?Ne0m7jEtfZLPEDgP9C4J6XvIFPQKs6WgLOdEaLJ+CvaaMUEfQs1yCC8vM4Yn?=
 =?us-ascii?Q?IhugVN8sbbbsTfeLylKPk+8KH5/MqRwLd2Dgc7njDd4zHlUas0yZGTlu7j8y?=
 =?us-ascii?Q?z9es0KLWBTmifd8YbHRrVpRgfpArGvSs7seQ9oghvf6M1+wdjpvZgok6Dy9R?=
 =?us-ascii?Q?vFhHm4O2MRncJ2Z46l5BDjKK24kJj8oDoo0bQlcndvQS0ZHJ9Og5KRROIwPj?=
 =?us-ascii?Q?p36OoHYn4DBbIw7l/hlWdrE3AgOCxOx803STQgIXhq1LnUvy0ZTFaF9HHJkn?=
 =?us-ascii?Q?jJ9zMnOtE0VB/uTas8lXEBU94LetkGTiBK3vc7kbEXpMB0TSLiwyaKNZ/gV2?=
 =?us-ascii?Q?SRICivXV/YNNOW/erL3dK+xJHxjzTy4sEVC6tdh+SSgxRhA/YR2ycXkj8C6D?=
 =?us-ascii?Q?m9/16bKphHS/f3N3Qhsjnq8NHpLqQlOkkBvHXv7BT4dWDwnucrCl2ZJ42FFO?=
 =?us-ascii?Q?Td1vHnDlNsk1RhEJpJpQqpEapeBuBdpnT2Q5SrsZ7F7kkvNEJqZ6Q9ABIHtK?=
 =?us-ascii?Q?Fgy+w0RV2ACieYk107ssk3JxSxd497n199RHzDHdAErhXICwzLVYrxX3rD85?=
 =?us-ascii?Q?LcbOeNJlm8DYiOGuB0hCjKrZDr8dBIy7AYMlte3TExmc5s71bp7z8iaRGxV4?=
 =?us-ascii?Q?bDDELeWttRBWRfoTSsLiPPPIes01NVl76qA5yioAtL3zdI9et8co88QvUCBV?=
 =?us-ascii?Q?FB21M0HaBpMlWci9/bsJkN0I5hD6B6mmbLQCVMj9D/JVYUIN3ECsxhPqJvmT?=
 =?us-ascii?Q?vYdw+0uW19naY7a8Fyy5SiP97iqeD/4mdRKSVx5IdEVjGML3SAJuJwZ7aem+?=
 =?us-ascii?Q?ph73Wcd11vv9yu7IbJH6iw9GSUexhApX1fW7L2Ylqf8LtOI6kzva9WkRw4lu?=
 =?us-ascii?Q?cVvstT9AJ/DyoRGzyB2v9LVyOqCpFD1CKGVtU5vaRYzvOSssCzNe4o7dTcju?=
 =?us-ascii?Q?+w0MFtdvTn0sf+PZweNEaNaRPGzoWUGoHz80BqTKOzzNXE1aF0pGV/Tnxs5R?=
 =?us-ascii?Q?UrXCNXlMHJGp4kXWclE6YeR767sPVtL+g4ug+S6KUoH7XJbKjCCBpuXrL7Nb?=
 =?us-ascii?Q?lvdzFfR8yep/kgLz2YX7x7kicfcYnqHHFDwEoEhkMsDM4orioYjgjNS3NnkQ?=
 =?us-ascii?Q?ee3VOQyvLVsYTLsep6z0AEdFg1NjNoazFDOhUenMkvssydCnP/NB4OUWPk1t?=
 =?us-ascii?Q?VAcvMUsSEZ3D4UeV1XZlTeqSgC2Mg3rDCtQjbm21U1bDwpWE5U34WPemFFs+?=
 =?us-ascii?Q?los/uMs2n4iqdPcVXsVPN03P0YpIIRKrN7C4IemJMNJ+4AMaSAVU4HMHDeh4?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2834982b-e6d3-46df-1c78-08ddfe4e5d73
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2025 05:17:48.7107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: heAwqj9Sy9KfxF68Vw6w+oGtm1TFliEFx3ZgUFAvt+8xfzbw+IqCuJW+Fd/FjlN/DEdwBwqUMzNLFQQpVvzaIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4612
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 935061C0006
X-Stat-Signature: nfcahbck7r1ck59863x6etbt3aauf73x
X-Rspam-User: 
X-HE-Tag: 1759036683-496092
X-HE-Meta: U2FsdGVkX1/+DeGRD09YBeavJhr9I2LtBf4vhWTtRulFVtnOs/PetGbDM8k8HNUQ6i4UxQevXajeTwz2IViVhyPyejnt7VRLFrHrXOLhwyu5Y4U0yllxuEuUu8R467msTYJlIEgy5C/D9SI3WZ2qLtg+AaogIPUOQE97evVGwlSFMRXykXiui+vyqVFG4xLbID61MSAFdDy6vcF12wN4P01CwZX3e7CJzECaPnh4wR5bXwRAliQndkP3pA+oUdS6oS7wxpPpleTAEg2kVyQsI4Trc5y48joUR9GYFt7e9qNlAtU8tuMvThKxilps9C1U4mI2IVZVbabzJp850f7ys/AP4CAQKcQLUt8zA87pZrupTBsEeSFxFrMUGMBNGFiKmnG+AuxCyxqtp6HVJtrcr38P54H/6yKuW9DHsPZs01JRSQIROQt6oEOw+iqLzQbTe29Kpi0eE9hzFOV6pN4FPF1YWD6Q0bsQWJHvcXFOn9wpYPvLaUp/bJRCd9ACassN4mqPtAKjZuVII7pbm72sEHopm7MEYxNLEbsO80emdllz1eu7SWFu2d008ARTQwTXCJPJVuZVJiu/zT2gJy52PpybmR37HhBzav5Mqo2CnMXsi/qHj8wfFM4qh22yUx0owTIhBF1ooshnv5/HgGHY9I2+w9KuhLGgip9PZaLMlSSz2/CIrsuU/31w3lCIPPQc31PIoWVFKAGq/hg8fIReaS1VqksU4+FcyqOwq7Xm71yHIdeIXW9fLTwHN5Wzg+YcBET5YLXFINsvxgW6lwLFElfEn0X65M7XsVMdBDtLQWwt7V8G4M3n2a24Q428oJlX1UcmQ+x1Q696PAZhPbkFWT3GoWYs+vXNLiKi6ATLxPFdCidFRL9bgonac0sj9DvwzSnNwgjcLobBn9khVuJMmezDSVVdICjKf+Ia9vRAClayFgxfKjRnoh0gvZqn+nCk8y9JhUUbjYoWo0ZXVOX
 yBPCqMmE
 JpkB5cy+4SCmLaTXhp8wt0X5RTix7iy+rwezfDvma+vUdYLxCTH8w8Q++hG7paxdHowqd1X7LYsj/erfAtVKZG3zvMDR+am7GT16BZzGqCpr2NwBFkS/CegwcVc0UHGMahOf+A7pWQ8xUuQpwktdL1Y1M2a0VtSUoc+o9yIK3ck3fOCtfHBwksEpVyhi5lMWf2eGS/O2aIPRgX/eodPS8Osrs+PutsN4uNTPcgQOuV4juRZbi34/tH+/gvRPc46BmWHf797LOxSKoQ0dnBf/wF5gWvXHKKOj/0DBtFHmuo9ZKsB+3LcL6VssUV877IDJ978n2zK9+Yvwmh03SO/tAZYlEWRk85qZAtAfXYElmWGMnsIu4KyG4ODo5XBqL8JyXZVsKEJkwduleqEJ+iapWcjNGB3dF0VHEYB0Wdb1IAk7FUmoRrJIBCIVmLRmqst6Cu/+HZTMJT8jwcv2uQD+HcewlLOdz9icXJda9+3cbe2NM9I03ZFKCUmuBx7vXSBJ2mSfjsfWfhX+Sc/Vh1K0u1t0kOdrtsFBzhTpJDBrcTMJxO76NcLJ64SUtLcFfYOXC0c4U3ZcTlpyHResbHzPM0U/ZTvEpPmfoVdmmY0LawLGy1VhVmBJ21ScgK206Aosso5H0B7Pg17/kma5V2EuP8NxhKZgm/iplIfXStVp1Iqkt+JNH1XAZIU8PuIihceXYyr8ZYSJ13cH+fN9B+hyBN6Jsu9Ux8HshrmHeN3gJaCPB4OE/s5LA2DxXQBCUCCwnBbEq7Vdkql7TeBH11Y6z7p6AYgsEnQeC22BjKFZ1CozEtrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:bad_unlock_balance_detected" on:

commit: 7e86100bfb0d65a17f3228a9af4c2a49ac38f057 ("[PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit")
url: https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-page_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250925-044532
patch link: https://lore.kernel.org/all/20250924204409.1706524-5-joshua.hahnjy@gmail.com/
patch subject: [PATCH v2 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-03
	nr_groups: 5



config: x86_64-randconfig-161-20250927
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509281204.3086f707-lkp@intel.com


[  414.880298][ T7549] WARNING: bad unlock balance detected!
[  414.881071][ T7549] 6.17.0-rc6-00147-g7e86100bfb0d #1 Not tainted
[  414.881924][ T7549] -------------------------------------
[  414.882695][ T7549] date/7549 is trying to release lock (&pcp->lock) at:
[ 414.883649][ T7549] free_frozen_page_commit+0x425/0x9d0 
[  414.884764][ T7549] but there are no more locks to release!
[  414.885539][ T7549]
[  414.885539][ T7549] other info that might help us debug this:
[  414.886704][ T7549] 2 locks held by date/7549:
[ 414.887353][ T7549] #0: ffff888104f29940 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap (include/linux/seqlock.h:431 include/linux/mmap_lock.h:88 include/linux/mmap_lock.h:398 mm/mmap.c:1288) 
[ 414.888591][ T7549] #1: ffff8883ae40e858 (&pcp->lock){+.+.}-{3:3}, at: free_frozen_page_commit+0x46a/0x9d0 
[  414.890003][ T7549]
[  414.890003][ T7549] stack backtrace:
[  414.890867][ T7549] CPU: 0 UID: 0 PID: 7549 Comm: date Not tainted 6.17.0-rc6-00147-g7e86100bfb0d #1 PREEMPT
[  414.890878][ T7549] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  414.890882][ T7549] Call Trace:
[  414.890887][ T7549]  <TASK>
[ 414.890892][ T7549] dump_stack_lvl (lib/dump_stack.c:122) 
[ 414.890904][ T7549] ? free_frozen_page_commit+0x425/0x9d0 
[ 414.890914][ T7549] print_unlock_imbalance_bug.cold (kernel/locking/lockdep.c:5301) 
[ 414.890923][ T7549] ? free_frozen_page_commit+0x425/0x9d0 
[ 414.890929][ T7549] lock_release (kernel/locking/lockdep.c:470 (discriminator 4) kernel/locking/lockdep.c:5891 (discriminator 4)) 
[ 414.890936][ T7549] _raw_spin_unlock (include/linux/spinlock_api_smp.h:142 kernel/locking/spinlock.c:186) 
[ 414.890945][ T7549] free_frozen_page_commit+0x425/0x9d0 
[ 414.890955][ T7549] free_unref_folios (mm/page_alloc.c:3051 (discriminator 1)) 
[ 414.890963][ T7549] ? mark_held_locks (kernel/locking/lockdep.c:4325 (discriminator 1)) 
[ 414.890975][ T7549] folios_put_refs (mm/swap.c:999) 
[ 414.890985][ T7549] ? __folio_put (mm/swap.c:949) 
[ 414.890990][ T7549] ? check_bytes_and_report (mm/slub.c:1253) 
[ 414.890999][ T7549] ? check_bytes_and_report (mm/slub.c:1253) 
[ 414.891005][ T7549] ? look_up_lock_class (kernel/locking/lockdep.c:933 (discriminator 28)) 
[ 414.891015][ T7549] release_pages (mm/swap.c:1035) 
[ 414.891022][ T7549] ? folio_add_lru (mm/swap.c:1016) 
[ 414.891034][ T7549] ? __lock_acquire (kernel/locking/lockdep.c:5237 (discriminator 1)) 
[ 414.891054][ T7549] tlb_flush_mmu (mm/mmu_gather.c:137 mm/mmu_gather.c:149 mm/mmu_gather.c:397 mm/mmu_gather.c:404) 
[ 414.891063][ T7549] ? down_write (kernel/locking/rwsem.c:1588) 
[ 414.891073][ T7549] tlb_finish_mmu (mm/mmu_gather.c:157 mm/mmu_gather.c:500) 
[ 414.891080][ T7549] exit_mmap (mm/mmap.c:1300) 
[ 414.891088][ T7549] ? do_munmap (mm/mmap.c:1255) 
[ 414.891093][ T7549] ? kvm_sched_clock_read (arch/x86/kernel/kvmclock.c:91 (discriminator 2)) 
[ 414.891098][ T7549] ? local_clock_noinstr (kernel/sched/clock.c:304 (discriminator 1)) 
[ 414.891106][ T7549] ? __x64_sys_io_setup (fs/aio.c:893) 
[ 414.891115][ T7549] ? __mutex_unlock_slowpath (arch/x86/include/asm/atomic64_64.h:101 include/linux/atomic/atomic-arch-fallback.h:4329 include/linux/atomic/atomic-long.h:1506 include/linux/atomic/atomic-instrumented.h:4481 kernel/locking/mutex.c:939) 
[ 414.891128][ T7549] mmput (kernel/fork.c:1197 (discriminator 2) kernel/fork.c:1131 (discriminator 2) kernel/fork.c:1152 (discriminator 2)) 
[ 414.891136][ T7549] exit_mm (kernel/exit.c:583 (discriminator 1)) 
[ 414.891144][ T7549] do_exit (kernel/exit.c:956) 
[ 414.891149][ T7549] ? stack_not_used (kernel/exit.c:893) 
[ 414.891154][ T7549] ? do_group_exit (include/linux/spinlock.h:402 kernel/exit.c:1099) 
[ 414.891161][ T7549] do_group_exit (kernel/exit.c:1083) 
[ 414.891167][ T7549] __x64_sys_exit_group (kernel/exit.c:1111) 
[ 414.891173][ T7549] x64_sys_call (kbuild/obj/consumer/x86_64-randconfig-161-20250927/./arch/x86/include/generated/asm/syscalls_64.h:61) 
[ 414.891180][ T7549] do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1) arch/x86/entry/syscall_64.c:94 (discriminator 1)) 
[ 414.891192][ T7549] ? lock_acquire (kernel/locking/lockdep.c:470 (discriminator 4) kernel/locking/lockdep.c:5870 (discriminator 4)) 
[ 414.891200][ T7549] ? kvm_sched_clock_read (arch/x86/kernel/kvmclock.c:91 (discriminator 2)) 
[ 414.891204][ T7549] ? local_clock_noinstr (kernel/sched/clock.c:304 (discriminator 1)) 
[ 414.891208][ T7549] ? local_clock (arch/x86/include/asm/preempt.h:95 kernel/sched/clock.c:319) 
[ 414.891216][ T7549] ? fput_close_sync (arch/x86/include/asm/atomic64_64.h:79 (discriminator 5) include/linux/atomic/atomic-arch-fallback.h:2913 (discriminator 5) include/linux/atomic/atomic-arch-fallback.h:3364 (discriminator 5) include/linux/atomic/atomic-long.h:698 (discriminator 5) include/linux/atomic/atomic-instrumented.h:3767 (discriminator 5) include/linux/file_ref.h:157 (discriminator 5) include/linux/file_ref.h:187 (discriminator 5) fs/file_table.c:572 (discriminator 5)) 
[ 414.891224][ T7549] ? alloc_file_clone (fs/file_table.c:571) 
[ 414.891231][ T7549] ? trace_irq_enable+0xba/0x100 
[ 414.891239][ T7549] ? do_syscall_64 (arch/x86/entry/syscall_64.c:113) 
[ 414.891247][ T7549] ? __vm_munmap (mm/vma.c:3155) 
[ 414.891254][ T7549] ? expand_downwards (mm/vma.c:3146) 
[ 414.891265][ T7549] ? handle_mm_fault (include/linux/perf_event.h:1596 mm/memory.c:6263 mm/memory.c:6390) 
[ 414.891272][ T7549] ? trace_irq_enable+0xba/0x100 
[ 414.891278][ T7549] ? do_syscall_64 (arch/x86/entry/syscall_64.c:113) 
[ 414.891284][ T7549] ? exc_page_fault (arch/x86/include/asm/irqflags.h:26 arch/x86/include/asm/irqflags.h:109 arch/x86/include/asm/irqflags.h:151 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532) 
[ 414.891290][ T7549] ? do_user_addr_fault (arch/x86/include/asm/atomic.h:93 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:949 (discriminator 4) include/linux/atomic/atomic-instrumented.h:401 (discriminator 4) include/linux/refcount.h:389 (discriminator 4) include/linux/refcount.h:432 (discriminator 4) include/linux/mmap_lock.h:143 (discriminator 4) include/linux/mmap_lock.h:267 (discriminator 4) arch/x86/mm/fault.c:1338 (discriminator 4)) 
[ 414.891302][ T7549] ? trace_irq_enable+0xba/0x100 
[ 414.891307][ T7549] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4351 kernel/locking/lockdep.c:4410) 
[ 414.891315][ T7549] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  414.891322][ T7549] RIP: 0033:0x7f1f0ec31408
[ 414.891329][ T7549] Code: Unable to access opcode bytes at 0x7f1f0ec313de.

Code starting with the faulting instruction
===========================================
[  414.891332][ T7549] RSP: 002b:00007ffc16600ce8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[  414.891340][ T7549] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1f0ec31408
[  414.891344][ T7549] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[  414.891348][ T7549] RBP: 00007f1f0ef25820 R08: 00000000000000e7 R09: ffffffffffffffa0
[  414.891352][ T7549] R10: 00007f1f0ef2cfa8 R11: 0000000000000246 R12: 00007f1f0ef25820
[  414.891356][ T7549] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[  414.891365][ T7549]  </TASK>
[  424.617670][ T5443] trinity-c1 invoked oom-killer: gfp_mask=0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), order=0, oom_score_adj=500
[  424.619318][ T5443] CPU: 1 UID: 65534 PID: 5443 Comm: trinity-c1 Not tainted 6.17.0-rc6-00147-g7e86100bfb0d #1 PREEMPT
[  424.619331][ T5443] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  424.619335][ T5443] Call Trace:
[  424.619340][ T5443]  <TASK>
[ 424.619344][ T5443] dump_stack_lvl (lib/dump_stack.c:122) 
[ 424.619359][ T5443] dump_header (mm/oom_kill.c:74 mm/oom_kill.c:468) 
[ 424.619370][ T5443] oom_kill_process.cold (mm/oom_kill.c:1041) 
[ 424.619377][ T5443] out_of_memory (mm/oom_kill.c:1180) 
[ 424.619388][ T5443] ? oom_killer_disable (mm/oom_kill.c:1113) 
[ 424.619397][ T5443] __alloc_pages_may_oom (mm/page_alloc.c:4055) 
[ 424.619405][ T5443] ? __alloc_pages_direct_compact (mm/page_alloc.c:3987) 
[ 424.619415][ T5443] __alloc_pages_slowpath+0x735/0x1460 
[ 424.619425][ T5443] ? warn_alloc (mm/page_alloc.c:4625) 
[ 424.619434][ T5443] __alloc_frozen_pages_noprof (mm/page_alloc.c:5190) 
[ 424.619441][ T5443] ? __alloc_pages_slowpath+0x1460/0x1460 
[ 424.619446][ T5443] ? __dquot_alloc_space (fs/quota/dquot.c:1683) 
[ 424.619476][ T5443] ? trace_lock_release (include/trace/events/lock.h:69 (discriminator 2)) 
[ 424.619489][ T5443] ? trace_lock_acquire (include/trace/events/lock.h:24 (discriminator 2)) 
[ 424.619494][ T5443] ? lock_acquire (kernel/locking/lockdep.c:5833) 
[ 424.619501][ T5443] alloc_pages_mpol (mm/mempolicy.c:2418) 
[ 424.619507][ T5443] ? xas_start (include/linux/xarray.h:1210 (discriminator 1) lib/xarray.c:191 (discriminator 1)) 
[ 424.619515][ T5443] ? policy_nodemask (mm/mempolicy.c:2373) 
[ 424.619520][ T5443] ? xas_load (include/linux/xarray.h:1226 (discriminator 2) lib/xarray.c:208 (discriminator 2) lib/xarray.c:246 (discriminator 2)) 
[ 424.619526][ T5443] folio_alloc_mpol_noprof (mm/mempolicy.c:2435) 
[ 424.619533][ T5443] shmem_alloc_and_add_folio+0x3dd/0x4f0 
[ 424.619544][ T5443] ? shmem_add_to_page_cache+0x900/0x900 
[ 424.619551][ T5443] ? trace_irq_enable+0xba/0x100 
[ 424.619560][ T5443] shmem_get_folio_gfp+0x42c/0xfa0 
[ 424.619569][ T5443] ? shmem_write_end (mm/shmem.c:2497) 
[ 424.619575][ T5443] ? folio_mark_dirty (mm/page-writeback.c:2849) 
[ 424.619596][ T5443] shmem_fallocate (mm/shmem.c:3813) 
[ 424.619607][ T5443] ? shmem_get_link (mm/shmem.c:3713) 
[ 424.619612][ T5443] ? debug_object_activate (lib/debugobjects.c:837) 
[ 424.619622][ T5443] ? do_raw_spin_unlock (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 include/asm-generic/qspinlock.h:57 kernel/locking/spinlock_debug.c:101 kernel/locking/spinlock_debug.c:141) 
[ 424.619630][ T5443] ? validate_chain (include/linux/hash.h:78 (discriminator 3) kernel/locking/lockdep.c:3798 (discriminator 3) kernel/locking/lockdep.c:3821 (discriminator 3) kernel/locking/lockdep.c:3876 (discriminator 3)) 
[ 424.619636][ T5443] ? mark_lock (kernel/locking/lockdep.c:4731 (discriminator 1)) 
[ 424.619645][ T5443] ? __lock_acquire (kernel/locking/lockdep.c:5237 (discriminator 1)) 
[ 424.619653][ T5443] ? lock_acquire (kernel/locking/lockdep.c:470 (discriminator 4) kernel/locking/lockdep.c:5870 (discriminator 4)) 
[ 424.619659][ T5443] ? ksys_fallocate (include/linux/file.h:62 (discriminator 1) include/linux/file.h:83 (discriminator 1) fs/open.c:361 (discriminator 1)) 
[ 424.619670][ T5443] vfs_fallocate (fs/open.c:342 (discriminator 1)) 
[ 424.619679][ T5443] ksys_fallocate (include/linux/file.h:62 (discriminator 1) include/linux/file.h:83 (discriminator 1) fs/open.c:361 (discriminator 1)) 
[ 424.619685][ T5443] ? local_clock_noinstr (kernel/sched/clock.c:304 (discriminator 1)) 
[ 424.619694][ T5443] __ia32_sys_ia32_fallocate (arch/x86/kernel/sys_ia32.c:119) 
[ 424.619703][ T5443] ? trace_irq_enable+0xba/0x100 
[ 424.619709][ T5443] do_int80_emulation (arch/x86/entry/syscall_32.c:83 (discriminator 1) arch/x86/entry/syscall_32.c:172 (discriminator 1)) 
[ 424.619718][ T5443] ? trace_irq_enable+0xba/0x100 
[ 424.619724][ T5443] ? do_syscall_64 (arch/x86/entry/syscall_64.c:113) 
[ 424.619730][ T5443] ? kvm_sched_clock_read (arch/x86/kernel/kvmclock.c:91 (discriminator 2)) 
[ 424.619735][ T5443] ? local_clock_noinstr (kernel/sched/clock.c:304 (discriminator 1)) 
[ 424.619740][ T5443] ? local_clock (arch/x86/include/asm/preempt.h:95 kernel/sched/clock.c:319) 
[ 424.619747][ T5443] ? __lock_release+0x120/0x230 
[ 424.619752][ T5443] ? __task_pid_nr_ns (include/linux/rcupdate.h:341 include/linux/rcupdate.h:871 kernel/pid.c:518) 
[ 424.619760][ T5443] ? trace_irq_enable+0xba/0x100 
[ 424.619765][ T5443] ? do_syscall_64 (arch/x86/entry/syscall_64.c:113) 
[ 424.619770][ T5443] ? put_timespec64 (kernel/time/time.c:910 (discriminator 1)) 
[ 424.619776][ T5443] ? __ia32_compat_sys_gettimeofday (kernel/time/time.c:904) 
[ 424.619783][ T5443] ? __x64_sys_clock_gettime (kernel/time/posix-timers.c:1147 (discriminator 1) kernel/time/posix-timers.c:1135 (discriminator 1) kernel/time/posix-timers.c:1135 (discriminator 1)) 
[ 424.619792][ T5443] ? posix_timer_unhash_and_free (kernel/time/posix-timers.c:1135) 
[ 424.619797][ T5443] ? kvm_sched_clock_read (arch/x86/kernel/kvmclock.c:91 (discriminator 2)) 
[ 424.619803][ T5443] ? trace_irq_enable+0xba/0x100 
[ 424.619809][ T5443] ? do_syscall_64 (arch/x86/entry/syscall_64.c:113) 
[ 424.619816][ T5443] ? trace_irq_enable+0xba/0x100 
[ 424.619821][ T5443] ? do_syscall_64 (arch/x86/entry/syscall_64.c:113) 
[ 424.619828][ T5443] ? trace_irq_disable+0xba/0x100 
[ 424.619833][ T5443] ? do_int80_emulation (include/linux/irq-entry-common.h:98 arch/x86/entry/syscall_32.c:145) 
[ 424.619840][ T5443] asm_int80_emulation (arch/x86/include/asm/idtentry.h:574) 
[  424.619846][ T5443] RIP: 0033:0x407d4c
[ 424.619854][ T5443] Code: 83 c0 01 41 89 80 40 30 00 00 8b 44 24 04 4c 89 d1 48 8b 54 24 08 4c 89 de 4c 89 e7 55 41 50 41 51 41 52 41 53 4c 89 cd cd 80 <41> 5b 41 5a 41 59 41 58 5d 48 3d 7a ff ff ff 49 89 c4 0f 87 5c 01


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250928/202509281204.3086f707-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


