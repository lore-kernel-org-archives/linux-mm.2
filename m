Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A578CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 07:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9F18E0008; Sat,  4 Oct 2025 03:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1EC8E0002; Sat,  4 Oct 2025 03:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888A08E0008; Sat,  4 Oct 2025 03:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71BE58E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:06:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE86F13C02A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 07:06:29 +0000 (UTC)
X-FDA: 83959548498.04.739C4C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC7B3160012
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 07:06:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CVnnIqAT;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759561586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1ROH7NavhHicDaRe6MdQWEek6o13feLYpl+Ve+gfRQ4=;
	b=ZCSdKqD08boVCxOAvhlYL8zG0eId6bBc+FlWTrkgIFPxZE1bXuTK8npITX0JWTt9TgtpPI
	BAt/N2MnrhoPTT8NMERDPaBpVnz00FTlgwyg1C3rBnwQZ7PbiV8ZMLu/kvZz8IQE3HGmyG
	NuU5EMZUAkDGbwi7vUZZOUKnMn/r7uM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759561586; a=rsa-sha256;
	cv=fail;
	b=45y08C4qCvWE88aXTh1lKLacRA/fW+O3qjVEat86H7SOmTnT21MWKIul045J9bMtTXRWE9
	K1fKnJYuxvGMkdUyP2EYTIyJI02ncvwK+Iwy+2ZhNMUK8JtVoiah/9OFhZ1PTudkM9lUOD
	kpMnhzqwshGFApxWDnUVbMpY7pBfOFY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CVnnIqAT;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759561586; x=1791097586;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=+1FYl31KZidhCnciGAStSBtehQZ1PnJs7WKVPmCssHU=;
  b=CVnnIqATsbMNceDzW770cQv+wbeb0UtwZx5N+eL4MWbkb7oe28gIiin+
   H5pHuHNYHR0KssrlB3vOfz6sdM2aYADGVt9QtBxNtIoyzkOj9LzOg1N/9
   x8262x25PQCP8KAyHhTtete+aC2OPzL1e98v8gwvEVx9Q0XZKwuy3S3uE
   BnqJWqv+CcfAPbuqi5M5Bc3eThNE0nI+HiY7f/8vWpKulZ1zrQU4uBlf5
   j2iBo0NU7hiUfhW+vi5leVovJqrTzZGZVHwu+XciF2JZ48L847JpiLMMp
   Ztr/k8P9aqr9ZHKSiLKiFbitCpK5BC0LPG0UqPCKHJT+CWhNYAWfO86cT
   A==;
X-CSE-ConnectionGUID: +rfkWR4GT+S1hTQ4hV4Fbg==
X-CSE-MsgGUID: BSELlnGdT36w3xW39cYvoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61997555"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="61997555"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2025 00:06:24 -0700
X-CSE-ConnectionGUID: xrSMej8mSV+R/Ah9zlVa8Q==
X-CSE-MsgGUID: 8VSP5vcmQROE+Q0K9z7+yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179889215"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2025 00:06:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 4 Oct 2025 00:06:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 4 Oct 2025 00:06:22 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 4 Oct 2025 00:06:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LW5RKxs50918mML04INnhl+WtBYl3Fso/wJjXxlDM38QPWFhQSsGLlF6LdfMZjRzOk5YZHUsT7nr6KusoavtPI8qwt37UQXfh+kZLeQzun8Oiww9zI7B6piP0HpNMYUE9Rx8ugH82qBNh4Yzm7V1xmadTLgZlRq+ejQVunPOI+fgpRfUzMPjIbYCkcLHghaFZMcfbU3WjcyAolzskDBpbesBF3idozEvdeS1+BzcqTi3MtlhYrECl63RA0WL2QLtlsuALRwlOTvsNsNAJpXwYDD7bcAXXNU78BpeeNjWv1myEKUPHWAFTFLUJB6gPYiomWhIx69SVShev1liekxweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3a+6T3Myb+8vZkC7VTY78Rn70+VcXNedNFYtFmdhNQ=;
 b=v8+V1l6FP1RpzG5NpyWVC1ttWRq7JynMHtrUnVbLVizSTtGMrLWgqQUdHjov/mQFZHTC/0Nzr6rtX/012LIu4dl9CnKTE1kxZWst7Hho+zMu+XsUHqABoMakLFvW77byifkHVxdzUVB0EZhBOIz5utm3SfOhCdEkn16H5HGqW/3T9P9yS9f0dEzxaqP1xhS6PKB+5wQTE8WnI8WX9YuMcYRkG/2Kkpe61VDJlflJ/X7OQStIWi+9lNVqIDMQjsoGrIPbKqzEY5TRSy7DszTDPF73yW5+87PM7VoZUXL5wKZh5rtiAyYJcBEQXPqy/e00xfjO9QzP3xzQbLQ8uSbQNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA0PR11MB4688.namprd11.prod.outlook.com (2603:10b6:806:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Sat, 4 Oct
 2025 07:06:11 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9182.017; Sat, 4 Oct 2025
 07:06:11 +0000
Date: Sat, 4 Oct 2025 15:06:02 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Suren Baghdasaryan
	<surenb@google.com>, <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [maple_tree]  59faa4da7c:
 will-it-scale.per_process_ops 20.4% regression
Message-ID: <202510040805.37ced754-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1P15301CA0041.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:6::29) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA0PR11MB4688:EE_
X-MS-Office365-Filtering-Correlation-Id: 940265a0-2c2d-4b11-e58b-08de03147fc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?VZk6aOWySFtENJrHUhd6UNC4cGvh8K622kXqeH1lHWu5fnYT0oVkwVrpEB?=
 =?iso-8859-1?Q?baxoh0X004+jIViXY4UkKIKlYCYUB8amJxMO41Pv8MmfoUjRWB6Rg5cKg1?=
 =?iso-8859-1?Q?8txHhQ1oivISx/Vy7Mdy7u1wffAjN4hfljZaDk4T5TFYY1/z4ISARnB/fE?=
 =?iso-8859-1?Q?s2Ms40RScN3PpN3fNAzW4+Mvvm0lo5iACQTd8G4R4U3ooi/UjUtIEk3gXK?=
 =?iso-8859-1?Q?+nQIkY+oJDb4Va+cmZlytjwCZJIHnnvEOEptSxTVYr/b1PEKL2FC1aUi+T?=
 =?iso-8859-1?Q?WFXpWTfwXBrN3IuQxUYNRrrbQFgOAP0N/qOEef6BC3UWpLtbryWoHDga8B?=
 =?iso-8859-1?Q?B9AnQ3UNXMF7DkjAToKkaSvd/aSG3ndr4B3MN23gVm3VR8bTH9MymGpu9c?=
 =?iso-8859-1?Q?gdTRujT7DBz/fzf0OEBKKDJo3/OLzeRd7fTiQsjXeqSjEdL09ZRfZXPxsp?=
 =?iso-8859-1?Q?6un+kdVPeSmlJ0lsdAAIlluvTpTi2qSMhCqh0Xuf5LOUShPSf1rHAK8LWK?=
 =?iso-8859-1?Q?5lFk0kyX6f+2bh/OaxkDVnMCHfBqoza7Lm8Zddwbc9L50uv4vFzIKZfWJD?=
 =?iso-8859-1?Q?4Xs6j8jlEpYb6TSrGM+YA4zBzY1wsh5vSeZryjFy9l8x/zlFGmA+Ciduhl?=
 =?iso-8859-1?Q?fBmpeVyX8863ShUko6bBY5Cd4MLnOdzZfEx62E3R96DZm0Af3pAazvAbhB?=
 =?iso-8859-1?Q?g9BcIfsoWtOiuOcVn7hlM+1hVGoFxkVfL3L6QTtABD+fHYdWm4LDiKEgV3?=
 =?iso-8859-1?Q?TjHb0uzfaNEEKvtQEAduVufAVMgMnCTgRcM+nsLH2QgSXvv8vo6MCshVtV?=
 =?iso-8859-1?Q?nOfacxB+ld4Lc9Qg/rtmxex2XThAlZ3NVBvAltVGvlIeCchxhpLHCdUFDv?=
 =?iso-8859-1?Q?dS10MHrzAaGUgLfyS/eZrrvaDi/2vX0+worSCNyhrtVKBX6UY9YlcVgVVM?=
 =?iso-8859-1?Q?1R+SJWw1SzORmrEgpA7eEdUj+PfIIk479J8zwvyCek3jt5Wx/1R/FdQO0Z?=
 =?iso-8859-1?Q?SctQjxUwG0rRqz9CWpO3bfsx9JVf9DOA3nhK5f1vXKm7O2rsaNMeD/rTtQ?=
 =?iso-8859-1?Q?wU9qWwGxlJij7tgEF4JVc7XZUi/uGh6+30IXxqrTS/i5bZMOaoLuahLBzW?=
 =?iso-8859-1?Q?LbfxSFJnnFJC4zNMKMV/OW+whxZQsB+LhQi+Ab44z/NyRaCEhP5X3WC3d9?=
 =?iso-8859-1?Q?dBi6NdPk04iJ5QMPkspwH6hssHNsTJR4nOQhCX2a4jBZLYN9S9CJWDy8lU?=
 =?iso-8859-1?Q?7ybFk+Ie8+qDdMtiNUarFQLI6P5vNC9eZTJ0CPRZolU9knldVxVCSuc3qW?=
 =?iso-8859-1?Q?CtGRj8hpgqaSoSw2vP6n0qdQVJYedxY1ugrZ3dsUvM2EOlVHh5qcmxoFGN?=
 =?iso-8859-1?Q?cwkLl4/soFOaztvo+TPqv/UDj9+IbPempdUpA+43q9dygiASH+4/8qvXYA?=
 =?iso-8859-1?Q?MXnRk1OiqBeFdIjC5tPvETOMot54E75VHL+os2JrPZdZ2aZWfi8MiZcqPg?=
 =?iso-8859-1?Q?A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?AkQCjvBwtPP26rebJLAkVDEO89MKWbn+j69Fof8qJfmadbIuizRRFdYgs6?=
 =?iso-8859-1?Q?gVFtT6LJahFIHFmXzBTe6Ylz/pG8NtL6PnijjqSwtJ6IAqiAyMj05pGk6m?=
 =?iso-8859-1?Q?dgnvQ4BB7Eccn7BWfuPtAoskU1NLXLSy4pSoTvq6WnwEi1SDUpfI0rvbTW?=
 =?iso-8859-1?Q?8zpK96MopNUkMQstQiaLPfZC2tIHatyknri4qiF1+kbcZrYiM8LtGOpNpg?=
 =?iso-8859-1?Q?nVzxV8w7Dy91SeOwnprW4xp6fPw23Y2nrrQghg8IiGQbjAJ4dddx5stei1?=
 =?iso-8859-1?Q?IV7gjAAcAFLB7nXVqcA+kRrlYBWDei6bTAPPEaYml11JPOi8QIyzuroPqc?=
 =?iso-8859-1?Q?V42FThd3D0WpgXqdXusbsRB6FrfDCYnINNaqmlDDW3uRv0ayff3w6uPN1m?=
 =?iso-8859-1?Q?sXVqinJBIdj45YHaS1n4ablW2yZsDwC9HlszmQY7iHzKO1gjoTkPSgRkIn?=
 =?iso-8859-1?Q?wxs9WQjFn5YHXiOSa1F8MN7ohT4KdoYOR+SorVz8rPAHGs2oadg/Jmcu2n?=
 =?iso-8859-1?Q?JuO9VsEA6FraocpNeO6CzzEHm8GhdPw3MM5qAH0C8ymtz4vI0C5wLGjh3x?=
 =?iso-8859-1?Q?yZ7hwzvecYOuuStmOcfnKh70yhLeLSRshNcV+Pn/cSy3BPotpITWYYdu7S?=
 =?iso-8859-1?Q?yBs9G3j4Kj4NXeJArpLqyIUEdACfubtD7vqfTt7iVKE1zaba/OhGz+8D9S?=
 =?iso-8859-1?Q?99lBQfU2f/CSOy8JguLKunHcM4ilgiuguqQnNPni+spJxAYpxvsEXur/3d?=
 =?iso-8859-1?Q?eLzgbgkyX4UjSVp6CE12qPQs+mjPuUlIDHG7fTif1JYitskjoEm127Equb?=
 =?iso-8859-1?Q?59GVXNKr7xxipEfx1nyuHjxGiJCJFun9lULf+19ZffFNhogC/U6fNt4AjV?=
 =?iso-8859-1?Q?THQTavo8J3ZvnTlFs9VKQvIAjjZVAlORBb49HJUJZApcNkoHr9ewA5fSK8?=
 =?iso-8859-1?Q?4PSMW2XSpxWYMBbEixurrJHbaOqy671OYXcdbWcDTRWxh7SIg9UrGncdmw?=
 =?iso-8859-1?Q?5yMLrjNETv3WncnOQ2sv451yWtCL/6ymaMZ68te2rZ/uuclqL+//vc5xbx?=
 =?iso-8859-1?Q?euKikIthHA1BQL93ly/CFfvuJFLwEjCs1fJ70G09vEwC0vao7hudIbBLv2?=
 =?iso-8859-1?Q?rhXl8Qg1vAbmFI48GInq2aeqjJ41Cx6FL83ZM4zjOtBaVxnYgDqokT/PZG?=
 =?iso-8859-1?Q?zxS7s4ObfcWtX4ggZC9k+p/Wmxs3zT7q32NEkmTXk4KGNeEACl/CUl7oSR?=
 =?iso-8859-1?Q?NZonV0l5EaWyBkmaBO/dVw9CBDweaPzAoa0zSNqrMn65iDZdnUW7wPhboS?=
 =?iso-8859-1?Q?Da9oNxR16FfYpuAIIfSFMlcE7+H0neKZJOSERjC874hzDrs2EBuid0w2E2?=
 =?iso-8859-1?Q?lCvFi7CxZ2FlspvN4euaaLGikgTBGYlSvbh18+NkdOd6goUw3L10j9/hUt?=
 =?iso-8859-1?Q?xcafz+C/CYfvFdnWGXTTUz1ka6IySnaV2wOIG1Nw21yy1jiYiRoFQFyK3f?=
 =?iso-8859-1?Q?FakAeLJeFrMQwfqiFCa4CKzI54o0hIax1Di3KuVsXwLv79gowZi1725dU/?=
 =?iso-8859-1?Q?34l2/W6v/m/zdhDbdol5HhMB+++FsNL6mLmfTMHmDEK9tkrxc+NZC3oNbz?=
 =?iso-8859-1?Q?ATdGVeGOHmKLutK1Dg0vo/ZT+rC+IqRH8Q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 940265a0-2c2d-4b11-e58b-08de03147fc2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 07:06:11.4521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riiyTkS3SVYbqdfBv+LTmSsxA2wJisIy/Uzh9sZYwSjDedYAY0wYc1a1QWr5+RKVpsSQIWMpkZ8rzjjqD+ZtEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4688
X-OriginatorOrg: intel.com
X-Stat-Signature: 15kpq3n9hpwzogues88kktsaxtj5fsap
X-Rspamd-Queue-Id: BC7B3160012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759561585-532896
X-HE-Meta: U2FsdGVkX1/1SlvRMjdGi0RsaO/SAg9YL9Tfkv08VvWGlHsF50ZlGAYXzyBY45NA0O+7wDssTUiXTqz2Z88gHKkEtx6cGd4GjHRAgTxIZaCgQies3rQIXij927ivNmpNCJy3IwsU3nzRB8R3g9iQsc/gIavs3TnqNKR5YInvDkEGa98io3kt7CitATmKx9iWHn+7vJQ475GVtQSnNwvcrQoof6PGi1Hbx2AIZk6+wV6HXhOjWXbBjR6wbmWrOgKo0xOxRfYP0yNm91MwRYtv5zFI8QpW1BUxhcfnuk4iZ4SYfPmzRfAXOhayvD/HD8bW0akVIttvRLUtl/Flwd3lgtj7AyqALzAszMq89LmA7bEXoeMXia/5bxxL6ED/v2uFfHX1WV4l/N6Sai0w/9KyOBx2uVdE7OVr6L6iRepGiyDSogYNYB712PXUEEdLsp6A93ZIOWNjil3GelsX5xdvuJ4R0OmzSRs6ccjpbd/k91+9m0tKAutBMBnyOOvAw8iLts+4KDhru/7q8sqWfBBhUmt+uajHiVGvcOKiBa28JiBZ2kWjg6ZQmB+g+qBhyfISGvJx/iIDxCd9EoDsV8JFPmP8/YX3OneEIBVrG5EFvlxoWrqmvA4EHYBGfkLS5X9hVyA55MbM2OUQsU17fyar4WMtc5EaOkAwInM6kymguUtjH9/FwA+7mb5S25f0+JPhJpZW59VUSrerO0eiK2p3ajjPyip775GH95NErpIaMcj0ndZbPLl+1cE7K40547Fc7NAadR6ilBWQ36sn04Ixu3WTXFATC/Ky0ibLIzyaBCNMChjS720AonomzT6jAPkrepWqU2NoGn/aMuaMtKMgtpEi8FZsxGFTSEDwV5RY/AGYhwNqATfeqp35XG0s1CB5X8bWpTT+w2LwAgiji5UCCJv/KO3iaqYiXHLPa24CfqfCw+D3uk1OcdUEY0dFE89bCpQC5ug3ckIthF/MJTP
 RWu59RaK
 O7owF/jJQnRUxVYs07OrssqaBzdP5tTqT96BUmFRElOCMYaYMvQuJkUilqRNeRtJSx6o+HIajVOm9/68cOjSqEQO/Qyfs5+khE5P+d+Cq1GzDrpaplfJwd7IE9kQlT7tnqGuyJmu5Gw1VedkUzTbvJC2w8rnKiBdyWvjYa1911Qt2TF+ECvqbWHo0QU20gKgR6DIFOxOdblyj/Nfhiw6p6s0rd6U4+oUC7jC1no+QQOgV9NEMBK5GuxLZOwmHFd7po02yzADm18FVwrrXR3I4uR/wAk0J7ZWKkNMHLhKoorqsJWXDRSY3/cJteBV2iE4Q7zRnlWjTAAkcvz08fSyyJ4FuvwCOI7DxTUIX1s3tAR+R6R9LCrsdrWMDe1Tvo8A6NgqVFAAwDvNzhg/6sOyUXmoATrMJrrX09nE0dq9J4z4zadJhHrI3bhLBi+478L8ZaKqnrIQ9NTmoLTHNdeMk9jnhFFDI/BDOdvWfvsxE03MOm55oST05HoJXlh+jg72ikPSnwffMh+rc2YCYvLZLF3xQMJZEtzi4LoRUZO9/W6bg3X2F0Y5HXklTgc8Vhw3M+Xev50H302+1UPROlbjqqu11TYFCtmLXFw05PAlD7VgzUdc21uRzQQ701XAMDEY0fa1dqc2/UMUssODHzjUcJ7e/Hc8Re0fCseBpnhrOGDIF+FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 20.4% regression of will-it-scale.per_process_ops on:


commit: 59faa4da7cd4565cbce25358495556b75bb37022 ("maple_tree: use percpu sheaves for maple_node_cache")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on      linus/master e406d57be7bd2a4e73ea512c1ae36a40a44e499e]
[still regression on linux-next/master 7396732143a22b42bb97710173d598aaf50daa89]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
parameters:

	nr_task: 100%
	mode: process
	test: brk1
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202510040805.37ced754-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251004/202510040805.37ced754-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/igk-spr-2sp1/brk1/will-it-scale

commit: 
  3accabda4d ("mm, vma: use percpu sheaves for vm_area_struct cache")
  59faa4da7c ("maple_tree: use percpu sheaves for maple_node_cache")

3accabda4da1b00b 59faa4da7cd4565cbce25358495 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     39.64            -7.4       32.22        mpstat.cpu.all.soft%
     56.05            +8.0       64.05        mpstat.cpu.all.sys%
      3.25            -0.6        2.68        mpstat.cpu.all.usr%
  97485349           -20.4%   77568497        will-it-scale.192.processes
    507735           -20.4%     404002        will-it-scale.per_process_ops
  97485349           -20.4%   77568497        will-it-scale.workload
 1.699e+08           -27.3%  1.235e+08        numa-numastat.node0.local_node
 1.701e+08           -27.3%  1.236e+08        numa-numastat.node0.numa_hit
 1.734e+08           -31.3%  1.191e+08        numa-numastat.node1.local_node
 1.734e+08           -31.3%  1.192e+08        numa-numastat.node1.numa_hit
   1.7e+08           -27.3%  1.236e+08        numa-vmstat.node0.numa_hit
 1.699e+08           -27.3%  1.235e+08        numa-vmstat.node0.numa_local
 1.734e+08           -31.3%  1.192e+08        numa-vmstat.node1.numa_hit
 1.733e+08           -31.3%  1.191e+08        numa-vmstat.node1.numa_local
     45.17 ± 18%    +404.8%     228.00 ± 21%  perf-c2c.DRAM.local
      7830 ± 16%     +60.0%      12529 ± 20%  perf-c2c.DRAM.remote
      3370 ± 15%    +114.0%       7212 ± 14%  perf-c2c.HITM.local
      3535 ± 15%    +111.2%       7465 ± 15%  perf-c2c.HITM.total
 3.435e+08           -29.3%  2.429e+08        proc-vmstat.numa_hit
 3.433e+08           -29.3%  2.427e+08        proc-vmstat.numa_local
 1.368e+09           -29.4%  9.653e+08        proc-vmstat.pgalloc_normal
 1.367e+09           -29.4%  9.643e+08        proc-vmstat.pgfree
      0.72           -18.2%       0.59        turbostat.IPC
    126.28           -66.0       60.32 ±  3%  turbostat.PKG_%
    656.59            -1.4%     647.68        turbostat.PkgWatt
     28.10            -6.7%      26.22        turbostat.RAMWatt
      4.02 ±  4%     +19.3%       4.79 ±  5%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4.02 ±  4%     +19.3%       4.79 ±  5%  perf-sched.total_sch_delay.average.ms
     40.47 ±  2%     +39.8%      56.57 ±  2%  perf-sched.total_wait_and_delay.average.ms
     73296 ±  3%     -26.2%      54076 ±  2%  perf-sched.total_wait_and_delay.count.ms
     36.45 ±  2%     +42.0%      51.77        perf-sched.total_wait_time.average.ms
     40.47 ±  2%     +39.8%      56.57 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     73296 ±  3%     -26.2%      54076 ±  2%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     36.45 ±  2%     +42.0%      51.77        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
  17718811           +13.3%   20079918        sched_debug.cfs_rq:/.avg_vruntime.avg
  18048681           +14.9%   20738718        sched_debug.cfs_rq:/.avg_vruntime.max
    593442 ±  9%     +20.1%     712781 ±  7%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.43           -12.4%       0.37 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.43           -12.6%       0.37 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   4090419 ± 10%     -24.6%    3084805 ± 16%  sched_debug.cfs_rq:/.left_deadline.avg
  18003705           +14.8%   20663365        sched_debug.cfs_rq:/.left_deadline.max
   4090351 ± 10%     -24.6%    3084762 ± 16%  sched_debug.cfs_rq:/.left_vruntime.avg
  18003453           +14.8%   20663106        sched_debug.cfs_rq:/.left_vruntime.max
    210494 ±  6%     -34.2%     138478 ± 13%  sched_debug.cfs_rq:/.load.avg
    369593           -15.2%     313425 ±  5%  sched_debug.cfs_rq:/.load.stddev
    306.81 ±  2%     -20.3%     244.64 ±  3%  sched_debug.cfs_rq:/.load_avg.avg
  17718849           +13.3%   20079940        sched_debug.cfs_rq:/.min_vruntime.avg
  18048710           +14.9%   20738723        sched_debug.cfs_rq:/.min_vruntime.max
    593439 ±  9%     +20.1%     712784 ±  7%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.39           -13.4%       0.34 ±  4%  sched_debug.cfs_rq:/.nr_queued.stddev
   4090352 ± 10%     -24.6%    3084762 ± 16%  sched_debug.cfs_rq:/.right_vruntime.avg
  18003453           +14.8%   20663106        sched_debug.cfs_rq:/.right_vruntime.max
      1578 ±  5%     -26.9%       1152 ±  3%  sched_debug.cpu.clock_task.stddev
      6524            +9.7%       7157 ±  2%  sched_debug.cpu.curr->pid.avg
      3489           -15.2%       2959 ±  4%  sched_debug.cpu.curr->pid.stddev
      0.43           -11.8%       0.38 ±  5%  sched_debug.cpu.nr_running.stddev
     12935           -23.5%       9891        sched_debug.cpu.nr_switches.avg
      9992           -29.9%       7005        sched_debug.cpu.nr_switches.min
      1.78           +12.0%       1.99        perf-stat.i.MPKI
 8.009e+10           -17.9%  6.573e+10        perf-stat.i.branch-instructions
      0.10            +0.0        0.13        perf-stat.i.branch-miss-rate%
  69402409           +11.9%   77663413        perf-stat.i.branch-misses
     68.30            -3.1       65.21        perf-stat.i.cache-miss-rate%
  7.15e+08            -8.4%  6.548e+08        perf-stat.i.cache-misses
 1.045e+09            -4.1%  1.003e+09        perf-stat.i.cache-references
     14887           -27.2%      10844        perf-stat.i.context-switches
      1.37           +22.5%       1.68        perf-stat.i.cpi
    655.70           -25.5%     488.81        perf-stat.i.cpu-migrations
    773.72            +9.3%     845.79        perf-stat.i.cycles-between-cache-misses
  4.03e+11           -18.3%  3.292e+11        perf-stat.i.instructions
      0.73           -18.3%       0.60        perf-stat.i.ipc
      1.78           +12.0%       2.00        perf-stat.overall.MPKI
      0.08            +0.0        0.11        perf-stat.overall.branch-miss-rate%
     68.53            -3.1       65.40        perf-stat.overall.cache-miss-rate%
      1.38           +22.4%       1.69        perf-stat.overall.cpi
    772.89            +9.3%     844.78        perf-stat.overall.cycles-between-cache-misses
      0.73           -18.3%       0.59        perf-stat.overall.ipc
   1248082            +2.9%    1284430        perf-stat.overall.path-length
 7.967e+10           -17.8%  6.549e+10        perf-stat.ps.branch-instructions
  66818507           +12.7%   75293544        perf-stat.ps.branch-misses
  7.14e+08            -8.4%  6.543e+08        perf-stat.ps.cache-misses
 1.042e+09            -4.0%      1e+09        perf-stat.ps.cache-references
     14721           -26.9%      10766        perf-stat.ps.context-switches
    634.91           -26.0%     469.53        perf-stat.ps.cpu-migrations
 4.008e+11           -18.2%   3.28e+11        perf-stat.ps.instructions
 1.217e+14           -18.1%  9.963e+13        perf-stat.total.instructions
     22.70           -19.5        3.16 ±  4%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     28.31           -11.3       17.02 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     10.86 ±  4%     -10.2        0.66 ± 18%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core
     10.64 ±  4%     -10.0        0.65 ± 19%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch
      6.44 ±  4%      -6.4        0.00        perf-profile.calltrace.cycles-pp.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
      6.04 ±  4%      -6.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core
      5.97 ±  4%      -6.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch
     31.46            -5.6       25.88 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     31.54            -5.5       26.04 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     31.54            -5.5       26.04 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     31.54            -5.5       26.04 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     31.51            -5.5       26.02 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     31.51            -5.5       26.02 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     31.53            -5.5       26.04 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     31.51            -5.5       26.02 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      6.32 ±  5%      -4.0        2.34 ±  6%  perf-profile.calltrace.cycles-pp.get_partial_node.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp
     10.36            -2.7        7.69        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.37 ±  3%      -2.5        3.90 ±  4%  perf-profile.calltrace.cycles-pp.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap
      6.36 ±  3%      -2.5        3.90 ±  4%  perf-profile.calltrace.cycles-pp.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_brk_flags
      4.15 ±  5%      -2.0        2.17 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes
      4.10 ±  5%      -1.9        2.16 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.kmem_cache_alloc_noprof
      6.14            -1.6        4.54        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      5.69            -1.5        4.21        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.55            -0.9        2.64        perf-profile.calltrace.cycles-pp.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.37            -0.9        2.50        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      3.03            -0.8        2.24        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64
      2.73 ±  2%      -0.8        1.96 ±  3%  perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp
      4.87            -0.7        4.14        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64
      4.62            -0.7        3.90        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      2.70            -0.7        2.00        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.01 ±  2%      -0.6        1.42 ±  3%  perf-profile.calltrace.cycles-pp.shuffle_freelist.allocate_slab.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes
      2.22            -0.6        1.64        perf-profile.calltrace.cycles-pp.vm_area_alloc.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.91            -0.6        2.33        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.brk
      2.10            -0.5        1.58        perf-profile.calltrace.cycles-pp.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      1.84            -0.5        1.36        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.do_brk_flags.__do_sys_brk.do_syscall_64
      1.77            -0.5        1.30        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      1.66            -0.4        1.22        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.60            -0.4        1.21        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.24            -0.4        0.88        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      0.68            -0.3        0.34 ± 70%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      1.18            -0.3        0.86        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.do_brk_flags.__do_sys_brk
      1.21            -0.3        0.90        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk
      1.62 ±  2%      -0.3        1.33        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.11            -0.3        0.82        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.10 ±  5%      -0.3        0.83 ±  2%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.09            -0.3        0.83        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      0.96            -0.2        0.71        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.27            -0.2        1.02        perf-profile.calltrace.cycles-pp.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      0.91            -0.2        0.66        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      0.88            -0.2        0.65        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      0.88            -0.2        0.65        perf-profile.calltrace.cycles-pp.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      0.82            -0.2        0.60        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64
      1.12            -0.2        0.91        perf-profile.calltrace.cycles-pp.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.83            -0.2        0.64        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.89            -0.2        0.71        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      0.66            -0.1        0.53        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64
      0.76            +0.1        0.90 ±  2%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      0.77            +0.1        0.91 ±  2%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_brk_flags
      2.30 ±  8%      +0.4        2.74 ±  7%  perf-profile.calltrace.cycles-pp.get_partial_node.get_any_partial.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes
      1.68 ±  8%      +0.8        2.49 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc.kmem_cache_alloc_noprof
      1.65 ±  8%      +0.8        2.49 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc
      1.94 ±  7%      +1.2        3.17 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      2.05 ±  6%      +1.5        3.60 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      2.05 ±  6%      +1.6        3.60 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
     31.05            +2.3       33.34        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      0.00            +2.7        2.70 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free
      0.00            +2.7        2.74 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +2.8        2.78 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +2.8        2.79 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +2.9        2.85 ±  4%  perf-profile.calltrace.cycles-pp.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      0.00            +3.0        2.96 ±  3%  perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +3.6        3.60 ±  2%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.00            +3.6        3.60 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf
      0.00            +3.7        3.66 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +3.7        3.67 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +4.5        4.45 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +4.9        4.88 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      3.01 ±  8%      +5.6        8.63 ±  6%  perf-profile.calltrace.cycles-pp.rcu_cblist_dequeue.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     67.44            +5.6       73.08        perf-profile.calltrace.cycles-pp.brk
      0.00            +6.3        6.30 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
     64.12            +6.5       70.58        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.brk
     23.91            +6.5       30.38        perf-profile.calltrace.cycles-pp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     63.84            +6.5       70.36        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     13.87            +6.7       20.57        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
     61.89            +7.1       68.96        perf-profile.calltrace.cycles-pp.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      7.26 ±  3%      +7.9       15.14        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      7.04 ±  3%      +7.9       14.97        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
     14.14            +8.9       23.06        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00           +10.0        9.98 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      7.30 ±  3%     +10.2       17.45        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64
      7.04 ±  3%     +10.2       17.25        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_brk_flags.__do_sys_brk
      0.00           +10.5       10.50 ±  2%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap
      0.00           +12.8       12.75 ±  2%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_brk_flags
      0.00           +13.0       12.97        perf-profile.calltrace.cycles-pp.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
      0.00           +16.7       16.74 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +17.4       17.38 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +22.7       22.71 ±  2%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp
     28.05           -17.9       10.20 ±  2%  perf-profile.children.cycles-pp.__slab_free
     39.76           -15.6       24.20        perf-profile.children.cycles-pp.kmem_cache_free
     41.92            -8.6       33.35        perf-profile.children.cycles-pp.handle_softirqs
     41.90            -8.6       33.34        perf-profile.children.cycles-pp.rcu_core
     41.89            -8.6       33.33        perf-profile.children.cycles-pp.rcu_do_batch
     31.54            -5.5       26.04 ±  2%  perf-profile.children.cycles-pp.kthread
     31.54            -5.5       26.04 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
     31.54            -5.5       26.04 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
     31.51            -5.5       26.02 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
     31.53            -5.5       26.04 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
     12.73 ±  3%      -4.9        7.81 ±  4%  perf-profile.children.cycles-pp.___slab_alloc
      9.40 ±  4%      -4.7        4.70 ±  3%  perf-profile.children.cycles-pp.__put_partials
      8.62 ±  6%      -3.5        5.08 ±  6%  perf-profile.children.cycles-pp.get_partial_node
     10.96 ±  2%      -3.1        7.86 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     11.00 ±  2%      -3.1        7.91 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     10.40 ±  2%      -3.1        7.33 ±  2%  perf-profile.children.cycles-pp.__irq_exit_rcu
     10.46            -2.7        7.76        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      6.20            -1.6        4.59        perf-profile.children.cycles-pp.vms_clear_ptes
      5.88            -1.5        4.36        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      9.73            -1.5        8.24        perf-profile.children.cycles-pp.mas_wr_node_store
      4.52            -1.1        3.44        perf-profile.children.cycles-pp.mas_find
      3.57            -0.9        2.66        perf-profile.children.cycles-pp.perf_event_mmap
      3.44            -0.9        2.55        perf-profile.children.cycles-pp.unmap_vmas
      3.19            -0.8        2.36        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.74 ±  2%      -0.8        1.96 ±  3%  perf-profile.children.cycles-pp.allocate_slab
      2.74            -0.7        2.04        perf-profile.children.cycles-pp.unmap_page_range
      2.44 ±  2%      -0.7        1.76 ±  3%  perf-profile.children.cycles-pp.shuffle_freelist
      2.25            -0.6        1.66        perf-profile.children.cycles-pp.vm_area_alloc
      2.25            -0.5        1.74        perf-profile.children.cycles-pp.mas_walk
      1.81            -0.5        1.33        perf-profile.children.cycles-pp.zap_pmd_range
      1.78            -0.5        1.33        perf-profile.children.cycles-pp.free_pgtables
      1.79            -0.4        1.38        perf-profile.children.cycles-pp.mas_wr_store_type
      1.49            -0.4        1.10        perf-profile.children.cycles-pp.mas_next_slot
      1.30            -0.4        0.93        perf-profile.children.cycles-pp.zap_pte_range
      1.49            -0.4        1.12        perf-profile.children.cycles-pp.mas_prev_slot
      1.47            -0.4        1.10        perf-profile.children.cycles-pp.__pi_memcpy
      1.71            -0.3        1.37        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.22            -0.3        0.89        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      1.27            -0.3        0.95        perf-profile.children.cycles-pp.perf_iterate_sb
      1.17            -0.3        0.89        perf-profile.children.cycles-pp.mas_update_gap
      1.13 ±  5%      -0.3        0.86 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      1.04            -0.3        0.76        perf-profile.children.cycles-pp.__vma_start_write
      1.31            -0.3        1.05        perf-profile.children.cycles-pp.check_brk_limits
      0.99            -0.2        0.74        perf-profile.children.cycles-pp.__cond_resched
      0.95            -0.2        0.71        perf-profile.children.cycles-pp.down_write_killable
      1.09 ±  3%      -0.2        0.86 ±  3%  perf-profile.children.cycles-pp.mas_pop_node
      0.96            -0.2        0.74        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      1.16            -0.2        0.94        perf-profile.children.cycles-pp.__get_unmapped_area
      0.76 ±  2%      -0.2        0.56 ±  2%  perf-profile.children.cycles-pp.setup_object
      0.64            -0.2        0.45        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.80            -0.2        0.62        perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.83            -0.2        0.66        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.55            -0.2        0.40        perf-profile.children.cycles-pp.up_read
      0.49            -0.1        0.35        perf-profile.children.cycles-pp.mas_prev
      0.57            -0.1        0.43        perf-profile.children.cycles-pp.vma_merge_new_range
      0.51            -0.1        0.37        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.51            -0.1        0.38        perf-profile.children.cycles-pp.rcu_all_qs
      0.67            -0.1        0.54        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.46 ±  2%      -0.1        0.34 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.42            -0.1        0.30        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.44            -0.1        0.32        perf-profile.children.cycles-pp.mas_prev_range
      0.42            -0.1        0.30        perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.41 ±  2%      -0.1        0.31 ±  2%  perf-profile.children.cycles-pp.refill_obj_stock
      0.34 ±  2%      -0.1        0.24        perf-profile.children.cycles-pp.sized_strscpy
      0.40            -0.1        0.30 ±  3%  perf-profile.children.cycles-pp.static_key_count
      0.34            -0.1        0.24        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.38            -0.1        0.29        perf-profile.children.cycles-pp.mas_prev_setup
      0.29            -0.1        0.20        perf-profile.children.cycles-pp._raw_spin_lock
      0.26 ±  2%      -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.32            -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.kfree
      0.36            -0.1        0.27        perf-profile.children.cycles-pp.can_vma_merge_left
      0.31            -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.31            -0.1        0.22        perf-profile.children.cycles-pp.up_write
      0.25 ±  2%      -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.33            -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.downgrade_write
      0.24 ±  2%      -0.1        0.16        perf-profile.children.cycles-pp.get_page_from_freelist
      0.28            -0.1        0.20        perf-profile.children.cycles-pp.vma_mark_detached
      0.24            -0.1        0.16        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.31            -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.__account_obj_stock
      0.28            -0.1        0.21        perf-profile.children.cycles-pp.mas_destroy
      0.33            -0.1        0.25        perf-profile.children.cycles-pp.__vm_enough_memory
      0.25            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.remove_vma
      0.29            -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.27            -0.1        0.20 ±  2%  perf-profile.children.cycles-pp.vm_area_free
      0.23            -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.strnlen
      0.30            -0.1        0.24        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.25            -0.1        0.19        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.22            -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.x64_sys_call
      0.16 ±  3%      -0.1        0.10        perf-profile.children.cycles-pp.unlink_file_vma_batch_init
      0.19 ±  2%      -0.1        0.14        perf-profile.children.cycles-pp.strlen
      0.18 ±  2%      -0.0        0.13        perf-profile.children.cycles-pp.unmap_single_vma
      0.18 ±  2%      -0.0        0.13        perf-profile.children.cycles-pp.free_pgd_range
      0.12            -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.19            -0.0        0.15 ±  3%  perf-profile.children.cycles-pp.is_mergeable_anon_vma
      0.29 ±  3%      -0.0        0.24 ±  2%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.14 ±  3%      -0.0        0.10        perf-profile.children.cycles-pp.rmqueue_pcplist
      0.17            -0.0        0.13 ±  2%  perf-profile.children.cycles-pp.__build_id_parse
      0.27 ±  4%      -0.0        0.23 ±  9%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.15 ±  4%      -0.0        0.11 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.15 ±  2%      -0.0        0.11 ±  3%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.13 ±  3%      -0.0        0.09        perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.16 ±  4%      -0.0        0.13 ±  5%  perf-profile.children.cycles-pp.cap_capable
      0.16 ±  3%      -0.0        0.12        perf-profile.children.cycles-pp.security_mmap_addr
      0.14 ±  3%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.mas_nomem
      0.12 ±  4%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.14            -0.0        0.11        perf-profile.children.cycles-pp.mas_next_setup
      0.11 ±  3%      -0.0        0.08        perf-profile.children.cycles-pp.userfaultfd_unmap_prep
      0.14            -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.testcase
      0.12 ±  4%      -0.0        0.10 ±  3%  perf-profile.children.cycles-pp.___pte_offset_map
      0.57            -0.0        0.54 ±  2%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.12 ±  4%      -0.0        0.10        perf-profile.children.cycles-pp.mas_node_count_gfp
      0.58            -0.0        0.55 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.10            -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.__mt_destroy
      0.08 ±  4%      -0.0        0.06        perf-profile.children.cycles-pp.finish_rcuwait
      0.46            -0.0        0.44 ±  2%  perf-profile.children.cycles-pp.update_process_times
      0.10 ±  5%      -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.brk@plt
      0.08            -0.0        0.06        perf-profile.children.cycles-pp.flush_tlb_batched_pending
      0.15 ±  2%      -0.0        0.13 ±  2%  perf-profile.children.cycles-pp.may_expand_vm
      0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.cap_vm_enough_memory
      0.07            -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.unlink_file_vma_batch_final
      0.07            -0.0        0.06        perf-profile.children.cycles-pp.ksm_vma_flags
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.__x64_sys_brk
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.get_jiffies_update
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.update_se
      0.09            +0.0        0.12        perf-profile.children.cycles-pp.mm_get_unmapped_area_vmflags
      0.07 ±  5%      +0.1        0.16 ±  4%  perf-profile.children.cycles-pp.mt_free_rcu
      1.57            +0.3        1.84 ±  2%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
     31.11            +2.3       33.38        perf-profile.children.cycles-pp.do_vmi_align_munmap
      0.00            +3.7        3.71 ±  4%  perf-profile.children.cycles-pp.barn_replace_full_sheaf
     67.99            +5.5       73.53        perf-profile.children.cycles-pp.brk
     29.36 ±  4%      +6.2       35.57 ±  2%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     24.09            +6.4       30.53        perf-profile.children.cycles-pp.do_brk_flags
     64.22            +6.5       70.68        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      3.60 ±  7%      +6.5       10.10 ±  5%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
     63.97            +6.5       70.47        perf-profile.children.cycles-pp.do_syscall_64
     62.09            +7.0       69.12        perf-profile.children.cycles-pp.__do_sys_brk
     29.84 ±  4%      +7.1       36.90 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.00           +11.1       11.10 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.00           +15.0       14.97        perf-profile.children.cycles-pp.__pcs_replace_full_main
     29.19           +15.3       44.52        perf-profile.children.cycles-pp.mas_store_gfp
     15.99 ±  2%     +17.7       33.65        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     14.62 ±  3%     +18.0       32.65        perf-profile.children.cycles-pp.mas_alloc_nodes
      0.00           +22.7       22.73 ±  2%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.00           +23.3       23.30 ±  2%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
     13.05 ±  4%      -9.5        3.55 ±  3%  perf-profile.self.cycles-pp.__slab_free
      2.74 ±  3%      -0.4        2.30 ±  4%  perf-profile.self.cycles-pp.mas_wr_node_store
      1.90 ±  2%      -0.4        1.47 ±  3%  perf-profile.self.cycles-pp.shuffle_freelist
      1.92            -0.4        1.52        perf-profile.self.cycles-pp.mas_store_gfp
      1.00 ±  2%      -0.4        0.64 ±  4%  perf-profile.self.cycles-pp.___slab_alloc
      1.88            -0.3        1.55        perf-profile.self.cycles-pp.mas_walk
      1.68            -0.3        1.35        perf-profile.self.cycles-pp.brk
      1.52            -0.3        1.24        perf-profile.self.cycles-pp.mas_wr_store_type
      1.27            -0.3        1.01        perf-profile.self.cycles-pp.__do_sys_brk
      1.16            -0.3        0.91        perf-profile.self.cycles-pp.__pi_memcpy
      1.22            -0.3        0.97        perf-profile.self.cycles-pp.mas_next_slot
      1.25            -0.2        1.00        perf-profile.self.cycles-pp.mas_prev_slot
      1.14            -0.2        0.90        perf-profile.self.cycles-pp.do_syscall_64
      1.06            -0.2        0.86        perf-profile.self.cycles-pp.do_brk_flags
      0.96            -0.2        0.76        perf-profile.self.cycles-pp.mas_find
      0.98            -0.2        0.78        perf-profile.self.cycles-pp.__call_rcu_common
      1.60            -0.2        1.43        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.82            -0.2        0.65        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.78            -0.2        0.62        perf-profile.self.cycles-pp.__vma_start_write
      0.91 ±  3%      -0.2        0.76 ±  3%  perf-profile.self.cycles-pp.mas_pop_node
      0.70            -0.2        0.55        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.71            -0.1        0.56        perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.74            -0.1        0.59        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.70 ±  2%      -0.1        0.56 ±  3%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.65            -0.1        0.51        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.71            -0.1        0.58        perf-profile.self.cycles-pp.unmap_page_range
      0.46 ±  2%      -0.1        0.34        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.64            -0.1        0.52        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.51            -0.1        0.40        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.20 ±  2%      -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.get_any_partial
      0.56            -0.1        0.45        perf-profile.self.cycles-pp.down_write_killable
      0.49            -0.1        0.38        perf-profile.self.cycles-pp.zap_pte_range
      0.45            -0.1        0.36        perf-profile.self.cycles-pp.up_read
      0.48            -0.1        0.38        perf-profile.self.cycles-pp.__cond_resched
      0.45            -0.1        0.36        perf-profile.self.cycles-pp.mas_alloc_nodes
      0.40            -0.1        0.31        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.42            -0.1        0.33        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.34            -0.1        0.26 ±  2%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.42            -0.1        0.35        perf-profile.self.cycles-pp.free_pgtables
      0.18 ±  2%      -0.1        0.10        perf-profile.self.cycles-pp.__put_partials
      0.36 ±  2%      -0.1        0.29 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.40            -0.1        0.33 ±  2%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.27 ±  2%      -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.sized_strscpy
      0.32            -0.1        0.26        perf-profile.self.cycles-pp.mas_update_gap
      0.32            -0.1        0.26        perf-profile.self.cycles-pp.vm_area_alloc
      0.24            -0.1        0.18        perf-profile.self.cycles-pp.mas_prev
      0.28            -0.1        0.22        perf-profile.self.cycles-pp.mas_prev_setup
      0.29            -0.1        0.23        perf-profile.self.cycles-pp.rcu_all_qs
      0.28            -0.1        0.22        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.33            -0.1        0.27        perf-profile.self.cycles-pp.zap_pmd_range
      0.25            -0.1        0.19        perf-profile.self.cycles-pp.up_write
      0.28            -0.1        0.22        perf-profile.self.cycles-pp.unmap_vmas
      0.25            -0.1        0.19 ±  2%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.26            -0.1        0.21        perf-profile.self.cycles-pp.vms_clear_ptes
      0.21            -0.1        0.16 ±  3%  perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.22            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.18 ±  2%      -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.unlink_anon_vmas
      0.26            -0.1        0.21        perf-profile.self.cycles-pp.downgrade_write
      0.25 ±  3%      -0.1        0.20 ±  3%  perf-profile.self.cycles-pp.setup_object
      0.24            -0.1        0.19        perf-profile.self.cycles-pp.__account_obj_stock
      0.24            -0.1        0.19 ±  2%  perf-profile.self.cycles-pp.kfree
      0.24            -0.1        0.19        perf-profile.self.cycles-pp.static_key_count
      0.18            -0.1        0.13        perf-profile.self.cycles-pp.strnlen
      0.24            -0.1        0.19        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.22            -0.0        0.17        perf-profile.self.cycles-pp.vma_mark_detached
      0.22            -0.0        0.17 ±  2%  perf-profile.self.cycles-pp.refill_obj_stock
      0.12 ±  3%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.get_partial_node
      0.29 ±  2%      -0.0        0.24        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.21            -0.0        0.17 ±  2%  perf-profile.self.cycles-pp.mas_destroy
      0.32            -0.0        0.28        perf-profile.self.cycles-pp.perf_event_mmap
      0.11 ±  3%      -0.0        0.07        perf-profile.self.cycles-pp.unlink_file_vma_batch_init
      0.19            -0.0        0.15        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.22            -0.0        0.18        perf-profile.self.cycles-pp.mas_prev_range
      0.20            -0.0        0.16        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.18 ±  2%      -0.0        0.15 ±  3%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.17            -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.x64_sys_call
      0.20 ±  2%      -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.10 ±  5%      -0.0        0.06        perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.25            -0.0        0.21 ±  2%  perf-profile.self.cycles-pp.__get_unmapped_area
      0.13 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.unmap_single_vma
      0.14            -0.0        0.11        perf-profile.self.cycles-pp.free_pgd_range
      0.14            -0.0        0.11        perf-profile.self.cycles-pp.strlen
      0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.can_vma_merge_left
      0.15            -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.is_mergeable_anon_vma
      0.13 ±  5%      -0.0        0.10 ±  4%  perf-profile.self.cycles-pp.cap_capable
      0.10 ±  4%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.vm_area_free
      0.10 ±  4%      -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.vm_get_page_prot
      0.10            -0.0        0.08        perf-profile.self.cycles-pp.___pte_offset_map
      0.13            -0.0        0.11        perf-profile.self.cycles-pp.__build_id_parse
      0.13            -0.0        0.11        perf-profile.self.cycles-pp.check_brk_limits
      0.13            -0.0        0.11        perf-profile.self.cycles-pp.mas_next_range
      0.11 ±  4%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.mas_next_setup
      0.09            -0.0        0.07        perf-profile.self.cycles-pp.security_mmap_addr
      0.14            -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.08            -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.__mt_destroy
      0.07 ±  5%      -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.rmqueue_bulk
      0.09 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.mas_nomem
      0.07 ±  7%      -0.0        0.05        perf-profile.self.cycles-pp.userfaultfd_unmap_prep
      0.10            -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.testcase
      0.06 ±  6%      -0.0        0.05        perf-profile.self.cycles-pp.finish_rcuwait
      0.08 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.remove_vma
      0.08            -0.0        0.07        perf-profile.self.cycles-pp.mas_node_count_gfp
      0.12            -0.0        0.11        perf-profile.self.cycles-pp.may_expand_vm
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.get_jiffies_update
      0.07            +0.0        0.11        perf-profile.self.cycles-pp.mm_get_unmapped_area_vmflags
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.barn_replace_full_sheaf
      0.00            +0.2        0.18 ±  2%  perf-profile.self.cycles-pp.__pcs_replace_full_main
      0.17            +0.2        0.36 ±  2%  perf-profile.self.cycles-pp.rcu_do_batch
      1.52            +0.3        1.81 ±  2%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.6        0.56 ±  2%  perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.00            +0.6        0.62 ±  5%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.49            +0.8        1.32        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +1.6        1.64        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      1.23            +2.5        3.76        perf-profile.self.cycles-pp.kmem_cache_free
     29.36 ±  4%      +6.2       35.57 ±  2%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      3.56 ±  7%      +6.5       10.03 ±  5%  perf-profile.self.cycles-pp.rcu_cblist_dequeue




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


