Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10884D2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 02:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FADB6B0088; Sun, 11 Jan 2026 21:54:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A83B6B0089; Sun, 11 Jan 2026 21:54:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560176B008A; Sun, 11 Jan 2026 21:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42E616B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:54:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC1B51AF63D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:54:41 +0000 (UTC)
X-FDA: 84321793962.01.D0348A8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id B463640003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:54:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HMFOgieD;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768186479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kUMUUq3YihcE0plyggu9j871uc1KKkhmOzHMXqf9vGs=;
	b=l4ox3zPvSB99Bl8B/TMwh7n7yZIEC0rWbwsq2Veikm+ErPj2feX9zkltIv8FYlySa22FW6
	ONs0OgsMvPm83uHs0IfNfHQT15EB1MIfmME4jVgEyGVz34MB9cPvgR804hH7tviqHMtLs3
	0+Hal8tgW0t3ibKYn0dvuBK3bP24Zxs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768186479; a=rsa-sha256;
	cv=fail;
	b=yL4Ip/Zas4lT9d4dfcjd3DlLU4UCDbvCOn+hoXDyEFpvMsodxBcZ5cZbM5LsFRAF2Iw9zL
	+VZSz52FQQeLCDuZQjmwsPX741l85/GLbvNlmnqMm0AX9UqzhFqmBTI1XkxcO/G8Hn7ewc
	dNCMtCzSb2ACNmxIyhpEGrB2Q5q56+k=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HMFOgieD;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768186478; x=1799722478;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=o+wSvmCUze5Bike0hfiy40HVD/c9gxn9rwNKLunG+Jk=;
  b=HMFOgieDWmWF0ZkuLjy/qOpiAqKxznDHpJW7ptMo1+GrN6ou8VkIUDpr
   NybfBUOBqbRDE3Ys14l9seXoXoqgIQ5IZkVCOFZTpVLjGZE6v6/EAP/Dh
   IH/3GW9YkzW0Q7RcX11WaYnxpCF5FiS5dmSE97/h4yWx0+F1erETGJBQb
   YNkaQxiV5WbcfKr++u5CkRGJ4lx9kCUTyhkXtdwtIqtRD/EhW+SSwAQtE
   QIXTnwnBj4h7TnHOO17I7CfkpJC0tPvym07AotpoBJUzdtMAnFpvXOEWT
   xPJCODsH2sEuvIyhYFHJBHspii0J+MFlK4oy5BIEunWYR1wramOx+9tjY
   w==;
X-CSE-ConnectionGUID: KV9wwAMmQIaFZsq7DrH2yA==
X-CSE-MsgGUID: jPkZ59ovTo2rWA9aoZ9dnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80565757"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80565757"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:54:36 -0800
X-CSE-ConnectionGUID: TMn4ugdpQ0yj29RAxVt3Yg==
X-CSE-MsgGUID: zKgUqsPOSsO69KwMdmU1Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="209039815"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:54:36 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:54:35 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 18:54:35 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.24) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:54:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpKZFIA8OedWLbnFi7xnynkiXjG3ytQbX2NtFZsjNhdYyRYp8OyohXD9/WKSyXxdTxecyP0i8M4uAMfegiToNAneFwhjwzwv1LLvUvPWCi+QWigSI3SELHFLlYH+U52ENjR4uZ4uHBz3IzeWoyM2S5hYeulxsjIpMu4+dpLox3D/Q1bppiL8Ikdi5o3yxbFotr+qHnveZQ3mcVqCfXuk8TT8/p6S8ULywdhJSqeAiqxiKQ8d+wJhU3MoMVN7h8xKTfe/iolhH7s5ZjWQVq7amSncEXS39g3+ZSJXDK15S8QNafqS7Ja3nLsMFLVs6IN/DSDihDa+f4AWwzxuoAC0Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUMUUq3YihcE0plyggu9j871uc1KKkhmOzHMXqf9vGs=;
 b=we59BhF82yECt0L2OsOBQNB1kXxFk0xKHWc+P1t4BLFl3OH12LVHljevb/LCrYxE39t2bxe6LOZfFMOjFMLqaMRvAkLqPFKffKb5aSVYpXhVl3xbSN/L03fRmHGIYpywkiDsnZzChgQl4nS9NvaEPoOB8xVP+5W//z8s5fcondR5CFCUXqKm/vTOWP0gsPTzMcCN5Un0nT5WS3lnfl55mIWvGR9pPsFtQfDqFQ7XbWqE+D6Xa3Pwbam7UZmlKH85m1ki89Lz2T2hOp+TMkIFjn9JGmnX3ei180yZjSmtO8XIl+fZ5EbiGMDYN2CbUlS6OMr9pfgyT/HZSP3EHvg9jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CY8PR11MB7169.namprd11.prod.outlook.com (2603:10b6:930:90::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 02:54:33 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 02:54:33 +0000
Date: Mon, 12 Jan 2026 10:54:25 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all-rebased] [slab]  9b0317d1c2:
 xfstests.generic.629.fail
Message-ID: <202601121022.41666cea-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CY8PR11MB7169:EE_
X-MS-Office365-Filtering-Correlation-Id: cb535ae1-beed-4289-57be-08de5185e9dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cw71bBLQlVsO8jQ9V3D1TDI5zJDO30aV6Um6pjziK4ggzUvR2/AXt1ZN9kFg?=
 =?us-ascii?Q?ZbJm6OOeDkHBCpElvBPt6bywJgEIPDZBFaQVSdruhfdzNCRRJ1GCLjAvfGmF?=
 =?us-ascii?Q?uGovXSpSmLiWBc3oPrt2egMUCpDRgVubQbcigXStEGsBNKqE+4UAtC5OBDdx?=
 =?us-ascii?Q?XftcSXxLUyakpQoGGg+KTG44GraII5jUf4QW2HEWAdV+NmXfvWNKSdeXLS7Y?=
 =?us-ascii?Q?3xuoYV8r7tp5cLPL/Z27o+w4zbzSh1xPySHKto65aOu/pBwOs5TSXj2BhWe8?=
 =?us-ascii?Q?6JTguBTS/cGN3auFeX65W6KcmhaRMvIIpVMvpl6zDF9IszOWaxUgeK5S56gP?=
 =?us-ascii?Q?392JD1fO9tsd14vCDV7iUPL647dIwT8VGL/6L+iMlGPYCmagpNbL8k05WVKz?=
 =?us-ascii?Q?vUMvPYHgbjsmCnRQBA/iu9t+2yg4oZQXvD/c+BYGJ+SgAkv4CywUyq7gitGZ?=
 =?us-ascii?Q?p/rK43ZiOPloRkLhc8gQEygK/JiCGZ2sEgEObmqq0irM+IcP4KMetZFnZLLH?=
 =?us-ascii?Q?VHTC7moIRmKSIRskMfNKGdWyrHuD2vhZtHcjeuHV+/KgsHH9PSC0umAN/JVF?=
 =?us-ascii?Q?28A4YabKXW413iboLFcoG7W88LBAQjv5a1CU1Hc2EZKN4ljVkJ/RNokB/zq8?=
 =?us-ascii?Q?1u/6IBaZG2qlZ++pRPKpDZbSRfzhEGeKIJSNQKIINuGKSXy7NXLj238gp5+d?=
 =?us-ascii?Q?E58PKuFZsrTqIxDcCGG7zmu91jgqcHHQUmFeItYimMXNOQLjx0RtA0NLwxN1?=
 =?us-ascii?Q?d42x5vWgov8RMCAnCkkiemIcH1rp5sei6Wj3xcQLk3UdunAg4o4BKOp1laIB?=
 =?us-ascii?Q?RR61Nt+a8zpVwKoexK9ZL9SAN/wSwrklAEPtOS7x88snNVkSoWqE7H54v+LZ?=
 =?us-ascii?Q?cxAFcfVuVVwRUxxrpHVox4ZWkyRMgTb2APbjK1jVvN/5eyu0DKv9zcbr+Jt7?=
 =?us-ascii?Q?lyLa6efYoLLK7u7FZuhHwLNaOLLwc5yxW0oNSUg3hsJX0rqCc5k2algg9PZN?=
 =?us-ascii?Q?0eKISP3gGRkr4csi3sCooCKlt5zQRoymQalWjpK9zYR2ziO7KC0BgAYJyfF5?=
 =?us-ascii?Q?T47d6uIJ5uPmNEqFZNysXbyM85I6YjGu9WYQsryEj6NAIqOPX+z8N6KxJS6I?=
 =?us-ascii?Q?XEy5SrTpAnQQ/izqSTzcpD1ryiIksCOp+PmunNScQNcLgLcZsgUYzr+Xf8km?=
 =?us-ascii?Q?ZHao4m0dMsD2t9HJP4ihXgjxWSK/DzEyua6ttgcqvI1qxZbu23vsKz04DY8I?=
 =?us-ascii?Q?nwSjYUkCB0l9QmiFeCVG0PreZP4iDyk0NKoKdGB+DA0NFnQKei9HSlDwjQTB?=
 =?us-ascii?Q?3c0X9Xp4eDDbe+DHF1sZpnHRg4V7rQBi9pV5x9U+zAA2+QGYImq7tCcAk0kG?=
 =?us-ascii?Q?1KGJUdZE8YjHAKiKITtKVxhfOE0TR5/+dN3Lb/Wf9PwtwfTk0zzF8Oz4PrKG?=
 =?us-ascii?Q?CFf5haOsQu3jP7bydC3g0u8kVKifUp9JlSo7MCWtOk1eyhJ1p/Bx5g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yPk96mGEG7MquXHWzxqi3mvS97Lgzd7m0m4TF9sgXQTsJsEiDWKaIQtVYxWf?=
 =?us-ascii?Q?pG8mx5Q5tOxRtRgn0AkzxIOPG1X9jCnuvgCRbgPKUYlMK6Bi+gh8Mg3gu/Ul?=
 =?us-ascii?Q?QFo/uG/uyLErVGMesOhRi41RS38mq4HqxrhD3Rx5bOYX6cPF+4nIiVWWrqMs?=
 =?us-ascii?Q?hYfdtQq3lUit6XxRKTT974x71fobF+hgt21SwxQ5qoOvrxMppBrEOfilQwEs?=
 =?us-ascii?Q?JwWi+Vf6IuCobeKQyXuNmUUxCJeZaGJapYItZ4e+sQO2WNNSQnBMZ+CohOHl?=
 =?us-ascii?Q?FmDKkIp5cH+XInvyxzh6q2dAkUyJKYj51jvOn3FWlbeRp3CTiJrKuNlAw3Tb?=
 =?us-ascii?Q?Tb4ZIGlP3qx0HUmNcscpzt1e9Rg4e1lOwz+wbXJH7UAnm0oI5i2V+xfT0xkd?=
 =?us-ascii?Q?rJ3NiN0L1I7GGYLL/nwypV8c37VnGSPptk+X25KMmbm2AoOV+fRJ9eCZirOv?=
 =?us-ascii?Q?k8WZJ+7kfxWFqbUKLwXn9ozhihcCyQnfPEHish4sOapHrObMxZi7BY/0IoCz?=
 =?us-ascii?Q?7p9Q10pG9KdIeCGIG8B+uZPmL4gUDdKSLWoUNvtXXDS23iNgtT6U6rjB1NKR?=
 =?us-ascii?Q?Gt6525NL8iIpb3mCALeFLaLWwBmesie34yBpuSnjOxrBxKAQG47XGYLPRw2G?=
 =?us-ascii?Q?qwa54o031mzhPeMzGqhoj0h3yNczkqEq+KBYcF5n4DreL3kXeSlDWrElGHtS?=
 =?us-ascii?Q?4A3saYXJr7jXQneimzYH+oX/A9yNLAVuT12AiAThgtZA1mlAIkihtYoRFQDi?=
 =?us-ascii?Q?J7UhQxy/qu7STbKtETz2bnYpZ8GoDJDe2xawwLfyO2JfeSDpBDevhxO1wbw0?=
 =?us-ascii?Q?yxLj1OcGlYwTRKbT5GQgaW8h9HUyxjTBNnQvaKwEMn49JcCAumiEa3MwkAda?=
 =?us-ascii?Q?YUpv4Wv8TWhMIhpLhoVloqDH7tx/gAUz0G/dcJIdcFxDn+mFSOv0HFFAGRKe?=
 =?us-ascii?Q?I7iBfxnt+Xr7QZOfGY3RZn3Ronh24mWE0VvPsZr5cNJCCo9cbUO0A+Vs5sN7?=
 =?us-ascii?Q?/3z2wjS6nI8CVxs2O8KAh4oDPxlYaZqVy8in0XBEBI/9iNpSp9ZzQ7HiT6iv?=
 =?us-ascii?Q?n1Rae73F0sidgV67+8jMTPsH4s+jZO1cNPOl+sqyhQD9IHhgZRq2sf3plV9N?=
 =?us-ascii?Q?deKVaTP1WQIaX7o5UhcxSDj287AtOVQYMq7/XENu61QDSPe1nQbsRK7qko58?=
 =?us-ascii?Q?zb2KiOAH7egM5DqctUiJPVniSO+rHcFdJ61CvhdrXs9M/1yx045pveuX+ZwX?=
 =?us-ascii?Q?ZHXuv+b6ZFTt71OdZJYu1Utsh6sGEBvkLraMaYFuHcQWwVVlUFJTz4EQKPr9?=
 =?us-ascii?Q?zgJSaao4Mx4LGy8ahp6ZszGFvbDuPnSE9/r6mplabhEwY0M9Du6sg5v6UZRD?=
 =?us-ascii?Q?swhfxLMzVYxNjEF8wBoYsoGd3fuOYhFpCQUst0g+lLNxw+DU4fdloan+F0Hc?=
 =?us-ascii?Q?SQ4fiKlsatJ39ci1ej1GKQYxm6iOJaejKezrHqyAxNLOEdg0Z3AWz8TNmzsG?=
 =?us-ascii?Q?kH5sZXrxCYAGrhEcpTpvENK646px9IlgGlw9mBWklDgliliuUiB/qb2K9Yvi?=
 =?us-ascii?Q?bl+ycRv5c6tt9TAPK1rQXawIO0Tb9CClUNKbKOj67BjxUfJrv4Y7kPZMexQK?=
 =?us-ascii?Q?V0PlHWZC07jmqMqo2mXQqQkXpY/3GIUv975b1fZK1mDBWE7H21HC+71Qu6zy?=
 =?us-ascii?Q?od+W25wn56Smc83upQptBW/DlbLiADvn6Riqr+M7dcPp16bQM2GM735mFOST?=
 =?us-ascii?Q?136LH9xZtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb535ae1-beed-4289-57be-08de5185e9dc
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:54:33.0980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lcv9xmCjuazGJjDBxKnbpxF8mlt41Tjh3X3+/PkSdP0/eXgc9zDJSNYiSwqOK/Cpi6Hd2AilYVtW2VpUtlquDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7169
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B463640003
X-Rspam-User: 
X-Stat-Signature: wfi1s3ak6jdzheo3i8pypxnyzfgqeyku
X-HE-Tag: 1768186477-208525
X-HE-Meta: U2FsdGVkX1/2NQ4SbTIZPM3i8OqufBZ1InGGz7XZxr+domnJELwVJzjLsQPJJHCd8fzyIonSsOnNgDczyVv5Wru4l61Q5fwvtxM49TRcsP0/fOAk6mCuG24KEDoMpmiP3GHKLMOl7sTc7fdCFVxdCLOkebonwDeNE0fbwz9t2qn7M0KUmZxuBL3OYT5SKA9xS/lJrhs31oxPRnaEsnwnf5OQ3FUHrf60xa7gY+zBMZ/XEwlR5fNfJjEeraBGmv1wI/moAt8KQXSY923GG9HmSuEr5W+6r4yeIOinGXEcHNDKDhKtQG95ESowvTKTdyfOBDPNvuoVmmRQK6NpIum+VyTqCvt2ALGWc6+cHbPjBQTRh9PGyU522qVlSfVMrSwIIxoMrO9FwYLccDzApcnpYbl7XIohiqCy2PR2j3f9kwBqGnzPinYAPt04KOKSF1xv/7uhO+hVvV5SvcDz5wHxBiqzn271MuRBvAUhB94bMKDE8wnIyz+9TSajXWu7lF5mPYQs+mlurx6HXcJ0NMoUVJHJQHX28mgj++kdPYSqgg+d8LMMDN84y/mPSe/kGhYTr2nD0JbaKYHTrCawGcYgNFvgHYAJMfd69BWul9xjU88hn8qrpB+g/lW8znJisq2CkzHENm0PYK0Pma7m+Gb9e4LdnzUsslZviJp6rYysyZ6zYVZJd6uzCGMZI8CbJrerwRu5HzSmzetTN1+Mmzwad8lkHMAx+INfkiXlRRckYT6Og7X3qw+oPr4YWJi0kgNVy9DQ6XnNpzRJbuI1JbuvRGk+NZYm1oj0UfzcQ+hUIKcG0WOtcJN+syLYZy2DP70pwPUbEzWFS0sn0VPqIpU8/gMx8VPDBZCeGdRHjCaKUj+E35ErklDdp/DTi6vJvdftP09Cn0RSzmPmNs+A5BpsuO8gAHGbjyBZMM7Z6KwsFyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "xfstests.generic.629.fail" on:

commit: 9b0317d1c2ed590d69d39eba701cd3eb082ecc31 ("slab: remove cpu (partial) slabs usage from allocation paths")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all-rebased

in testcase: xfstests
version: xfstests-x86_64-df16c93a-1_20260105
with following parameters:

	disk: 4HDD
	fs: btrfs
	test: generic-629



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601121022.41666cea-lkp@intel.com

2026-01-11 11:59:36 cd /lkp/benchmarks/xfstests
2026-01-11 11:59:37 export TEST_DIR=/fs/sdb1
2026-01-11 11:59:37 export TEST_DEV=/dev/sdb1
2026-01-11 11:59:37 export FSTYP=btrfs
2026-01-11 11:59:37 export SCRATCH_MNT=/fs/scratch
2026-01-11 11:59:37 mkdir /fs/scratch -p
2026-01-11 11:59:37 export SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4"
2026-01-11 11:59:37 echo generic/629
2026-01-11 11:59:37 ./check generic/629
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 lkp-skl-d03 6.19.0-rc1-00010-g9b0317d1c2ed #1 SMP PREEMPT_DYNAMIC Sun Jan 11 19:50:05 CST 2026
MKFS_OPTIONS  -- /dev/sdb2
MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch

generic/629        _check_dmesg: something found in dmesg (see /lkp/benchmarks/xfstests/results//generic/629.dmesg)

Ran: generic/629
Failures: generic/629
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260112/202601121022.41666cea-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


