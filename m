Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A73C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB006B007B; Fri,  8 Aug 2025 04:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2AF6B0088; Fri,  8 Aug 2025 04:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44036B008C; Fri,  8 Aug 2025 04:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C29526B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:45:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 541761A0CFD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:45:51 +0000 (UTC)
X-FDA: 83752957302.26.98E2FC8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1FDDA12000D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:45:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m6PZ+eJD;
	spf=pass (imf29.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754642748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=imWnHra0svNW1aMgYf8t37K9bSPETg6G1ZMrVQNnagc=;
	b=TAqcJUAogdckSbeQp1cn5SrRcuUJPjPoIqX215CW/rU+p8fXX1yMOiHIycBZ661vmdYWn/
	HQSXD8N6COVn7E0Y+L6WvTwk5/fmcGl9DbBykwiTWPxGv54ZFjcwQsPB5bNeAWREGDkhIA
	JrbOqm49uD6V3KqVs77TvBhc8PDGFQg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m6PZ+eJD;
	spf=pass (imf29.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754642748; a=rsa-sha256;
	cv=fail;
	b=Ws25MZjWraTS95SjQqpQhSLZ0Gzo1YXLH2LqsxuGUb+FmZdW180JLg0gBqNR0hWjNc69Zx
	YBsFlnhmR9FD60ZrabHFmU4u+JUEq7W2g/23GTCAVDsbdsc0KzxVG5Aut15dMVdb4Yu0jM
	/8nmUvDcfx+dEQw0YODORuL/JEuo2SE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754642748; x=1786178748;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NdaXYcbjH0p5yAObG9Rrh0L18ng2uYmjjKZIv7a9Jhg=;
  b=m6PZ+eJDdIAuf9rLu5lJk7Ipda6k2/gdfN/mzE7g9tHWcjf1YHeItt4T
   V7S+NBL2lBBDxNh3uNkzXfgurXIsJmat2rVg9KEbOtga+se/+FB+lcFgd
   ARWM/OnsG5Z8nU7LDETSfKb8NPYqwrubTZpxUiHIc11nKHjQKwQ2+84OW
   102EdsGQcQIKGZtgbKKOZwJd5bFad4YrsZR2dYfkP7oXbtDnlyRWjXCg3
   DAdORswwMpn8cpMUdxkf+p5FICS6VT4KTfcyvB/qncDpNdFXhrPKNbS05
   9Rk2NZ23HJI8esxp4nKYJsqpmbdBTORbanlilO82emqIsxPXWAngbcM+1
   w==;
X-CSE-ConnectionGUID: 1mLNC5ulTwWOn04o6sY3gA==
X-CSE-MsgGUID: f4Kq8scbTnieGmPMiRnlUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="79545374"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="79545374"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 01:45:46 -0700
X-CSE-ConnectionGUID: bSNedXszS0iGxZagk6iYqQ==
X-CSE-MsgGUID: 80MZkGbqQPKsuKqF5K3kfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="165664680"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 01:45:45 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 01:45:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 01:45:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.41)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 01:45:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NS1nNV1D/i+tHRMDcp97RVeyWfyBznMS+QXVJKyhAqgaMTQiCGwksQmYi6GjPd7RnhdqlmznPu98Y+3HU1xwnUVQnc6Ai+cRJkaoeqyMo/PLMv4156XGJoU45iE9DecDsiK4Qsyz3Bxeia6l7c7HVqngX2OGKQT4KT/tBPA7H8x7hH+ABsla6r2qn1pMsLhC6MC3rqnWqLsb7lUQ5kLYZvbetZkylr/rf1wye6afPkAUsg04MsnY5913cyoQL4s92rlEQLGCc28qvPbKkOfbAReKJVX/l3ia4EIDlk/FgBK9J8C2vlKlBmoh6BUAcwXFMuhmEq/ay+gw6hoarfDvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imWnHra0svNW1aMgYf8t37K9bSPETg6G1ZMrVQNnagc=;
 b=vB4N0nUJ04BN/BbUZcMHbtJHRC/MycnORt2Yxr67OcyXQ7p0LxZCkSfs7hSvHEPdR5IsTZqdTbqDGepaos/Q4CkJ+XJ/edcn/8X+7uVFFyZyP5GQ01dMx/ejlnOQIZRO1K50Ia3F6UEcfexzHRCayvMXvFq4Ka7IMPllNoNshiRX48N4C1VbJBiLdEoyPDT41YSrY3AyG3+pzu/2nctlJFtC7KaKekl1i6IX5sxVywV2VukGh9C//Ii+ZoU6t8b/67XWWz11CEamrh4UWR4aL0vSQnyoSjhHz/zsl8iiD9Y8ApQeGJzqalYKaU6DBSiFWaGO+pffYXqCWx5vkPyE7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BN9PR11MB5324.namprd11.prod.outlook.com (2603:10b6:408:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Fri, 8 Aug
 2025 08:45:42 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 08:45:42 +0000
Date: Fri, 8 Aug 2025 16:45:31 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, Shuah Khan
	<shuah@kernel.org>, <kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [kho]  b753522bed:
 INFO:trying_to_register_non-static_key
Message-ID: <202508081032.1450e413-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0197.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::8) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BN9PR11MB5324:EE_
X-MS-Office365-Filtering-Correlation-Id: 197a84d2-2546-40df-ed31-08ddd657f51a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TO6s2jY8+XjU1NsFx9ZCvlo64M/6ljn8iiOaHv7blIBCJ/5FclXQt8wv3De7?=
 =?us-ascii?Q?EM8nLQL/OLwkpyZqUr9f0qCDxQ92QaZs6owqCsft2mNqCxyIj5fTXuZOOOdP?=
 =?us-ascii?Q?nR/QRgAnMNWaUw476yXojdNV++xHRvdNqgFqpK/PtC7l0VvLTSOzooZJq4yW?=
 =?us-ascii?Q?plphRDU5zg+DGq5zl6OoG0hV/C1oNNc47QUpU48NkMbfVBjpdpQ4pUUBcoMo?=
 =?us-ascii?Q?nf7GdMKX4SXxMDDp/07tLZxMwx4PNI8g0HwHrub3An3BKZ+Q1xjbdIEtceW5?=
 =?us-ascii?Q?8/FtxsSS0Z1d6NLLibpQ6CsgTbo7U+N3CpR2EX3BK2Re3gS/ds8P+/IhFYU7?=
 =?us-ascii?Q?6vwDtkw8DEmbyiH79WNs7XrCHJiE/KG0SzhDfRTZo/jRqG5BwKk+8b4gcnnU?=
 =?us-ascii?Q?6tWHBMGSPefY4Al/Ot+1uz9WQg0fSQvptYIwuBAIB27/PYB5yNFCwXQWajgO?=
 =?us-ascii?Q?mq4HEWw+/g0qCZP1EWmcPFZD0Hx+dNafo4CECvAgUMsfpHsIoCF9c/Jaed1n?=
 =?us-ascii?Q?tiaQk0OCGz9d0KWxfKbrrP4iLMEiUuXpRfvJrnoK4UDRQQI+9Q58V7H/x0XY?=
 =?us-ascii?Q?KZu6ovwTB8bXIp9XkjmHAHnL6s8MCYf6f1laN7t6ZEaOvdP2ZxO0LHL2QZcB?=
 =?us-ascii?Q?fqpQa/gME8Z7xIVs1oAuuCa4byY1ac7y7Q3NMz4oZ/gkHI64Th9m5NCPt39A?=
 =?us-ascii?Q?WS93ZZOlT22GL17OEOJqLEAyVaOk8TOyWTHl7D+Z18rnbw15vgSgoYrf3rbE?=
 =?us-ascii?Q?eAKAlDhNA9dpHOHYPS4XtrfFIkJ4zBmrK+f8wvYt++IFZPOi6LThmJkgXME+?=
 =?us-ascii?Q?aBZBN7Dr4irtF3xEPy2PVK327/S2tdCxeSbY4zHLrOH638swlztJJBcFXA4w?=
 =?us-ascii?Q?Eyx6Gyk/AurgjWKXATf/1Cy/r3ExHEmt/5moo+eCZCh/yj4s9pKVlBlou0l0?=
 =?us-ascii?Q?qgp4ehcFX0H6BXycaRiozOLwgukionSPg3/iCPdMJxRjBN/KrY+mmqqrCIWs?=
 =?us-ascii?Q?JpmNEK+tl7c1A2kC4zabq5BlwvY57wCjAAV1hJDy6ZdjDbVl33KgFEcFPpal?=
 =?us-ascii?Q?6PiFdGwuPwU3hoh5iIPw5j74Pe0HotdwPJF5ft+nMxNzilwcJaXBJIMQNbIq?=
 =?us-ascii?Q?YbonsoKLUh6Gw5LXSTGpSP97R1U01+DSsa/SKKhLMERVJcbNu3Mwyw7w1O9b?=
 =?us-ascii?Q?7Zw07xaFDhU8vjiq56e53MEhDI88tS+xJJDSFPMBR6eVMDB33GbeXVEMDR0b?=
 =?us-ascii?Q?hvsgrN5NV8mXcRbCtVLGprFSj88Dp8uyhVL3f4PNN7Aj3AVN0h38Jv0e+xLT?=
 =?us-ascii?Q?mLeAc40LE5lhdrXQzQAPme5sndDSoLsUIjus9CAAbUvZ2GEUmxBIibP79KcK?=
 =?us-ascii?Q?ZyiSa/fHZPLSDYWvbyeNJLyURbgo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ae740CzQiHuE/igf+BaNCtrFCv5nB70fIUm3ieUMQGMGifQO5YyY6lNunyHK?=
 =?us-ascii?Q?zNfZjDfslNyWwS9YfB771UcfCe01OJFA3rbGUczklHOGAseLSTr9dmlZR84Z?=
 =?us-ascii?Q?o9jEGW9q1PIT93GSak24FnpoQsZNAnSNM3ISIr1fY3/oYOHIX0t/TQXx4rbC?=
 =?us-ascii?Q?IOka+dFmn0Q8Eo9HCJnXFYI8s7BaXHyENOyKDYiCoekjOPuyP8iKNsnwoffy?=
 =?us-ascii?Q?8MkjE4w8TWaYchGURdQfLhuzHJPkFURJTMX/2n8WnbMjrGhSDTUyFsbGvdgJ?=
 =?us-ascii?Q?Olag0syFK81tVdpLjWY5DtC04c1bqHvD4m+MNwhDWfyWbQScwJUmJTFgfKre?=
 =?us-ascii?Q?WNGqKELzF+YQaDZFh79L/d4Bwd0xgkKGNKNFULaFO0lsd8rWU4n+1fdqv3xW?=
 =?us-ascii?Q?dBQNvZ7hzGUbkNqQ88pqb4vcjZgHqd5D8DjxettXJvu8y8mPR9EHFZaSyONF?=
 =?us-ascii?Q?s/AcFNBmre5fIBhrNIGNhjL1H/XfnLfoWtMsuYpRqJ/O7vq3THizgMWZfBHV?=
 =?us-ascii?Q?D3g9E+IbFyDQEOVbouUfaevvDRpzYhs7hOV8oPyMUFalQ0ybUy2XJ0qG/7NM?=
 =?us-ascii?Q?7x3Xk8VkjMCGJP/GBQ3y9KPJoAjVrmPR0r3UHokbRH+Gq/zhqdZAWzTYqtRm?=
 =?us-ascii?Q?0bpgXQJ1p7ICwpT+KvVLvVGRLeleEacVC2AxHjDjVB3VgngIo4wMNJExcwro?=
 =?us-ascii?Q?7jCs3I56M5Uk2j6mAU+Xr3T9MCOm/wcLT66+Y2vPy1NC2tiI4pDALJKB3Nr8?=
 =?us-ascii?Q?Oik2tmM5uYeLFN2SQ3uXtcMOllTMzxZlfMJXD/vERkF+hLSS9J+jTuX/AV/d?=
 =?us-ascii?Q?rOtyp94lKnbv1jTp1fUtplcsMIVKQBUv+yrA/RoXFCcrq289LEurhZD71ecE?=
 =?us-ascii?Q?Y7+0Kx7dG0K/N+BepKRFmvr8ns44frh3X0gL9jtK0sUrMyuLrMgurRPHC7w/?=
 =?us-ascii?Q?izKYugC7AnP3kblGoqIynq5A+nS0/dvkTtcNAjyFApwHtwroLHxAxU3H9YKK?=
 =?us-ascii?Q?JAVLNTg96vIrMznHO5bfFQGcKJbrMh3Ko+FWWOieriGek3umJCXDH2zTGxGV?=
 =?us-ascii?Q?NjjbVP9lWJQAUru9SXLf9998KM+HpRijtNAMG73/gtDKWsqgMCTdLJYq/onO?=
 =?us-ascii?Q?H43g2+UGJKAoC9C1l/+W5PBtN+AeMiFt2JveBWEPht9lfCrARR0nlNPxJd3l?=
 =?us-ascii?Q?8g9Y3HHS8MnXB3m7Wm9W3z8J1bJrb9sah5SZ8Z4eeu5PnXMiqrHD81aikNmd?=
 =?us-ascii?Q?S8U/g1OmmYvK1apXdZerUxWkP6H+0dN86XGL8uVwiHDmCq3YFfLk4BQxYynG?=
 =?us-ascii?Q?7uBTYGs4c9Cd8yVCZXD9ew6UyCfadPz+IM2qHyiAPFi5SYYBPmzP1B5/wZLp?=
 =?us-ascii?Q?WrOn5sgY4eE3ZF+7i6HhcB23QTnCXiDTAV2Ki8Q0yHj1N65wvBT8kNfI0kjK?=
 =?us-ascii?Q?RAi3d+JgOeZlo1+5vHOD9Tq99FezOEoUAbSnCDYN67LJDbArFY8LC3GLpApl?=
 =?us-ascii?Q?gOtcXSruE2r6XHn5ahrUuwSTpUNRhlQd3n0Zv2oKBXvxJ4pe2Icvq2Z5LyIc?=
 =?us-ascii?Q?DB8VA6OyrS9EmSvB/HtQed4oosJCOsp4Y32UFjoTjm0cQAn+EN/T0F10jkzW?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 197a84d2-2546-40df-ed31-08ddd657f51a
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 08:45:42.0164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/kLwyPqvsOvT1wOdckHXMERwTSrMvYD7OP8FIwFKnw0tQYdWfoo0ePgEsTbbplljP4a9zgnYkw+mcZCUaQ0mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5324
X-OriginatorOrg: intel.com
X-Stat-Signature: 7rd5shfu6cphq8mrgomczzout491bhm6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1FDDA12000D
X-Rspam-User: 
X-HE-Tag: 1754642746-240790
X-HE-Meta: U2FsdGVkX18OOoY1guyoZG/aKdNjVls4cISwXFVNxKFhJf0nmL5nAwrXUJvtQaUmGJfWdX1hA+QNRztUMl37gfNndoKo6oY1NjNyvdSCXD7Sk3B6LrGVMazWcciPIrN8FbZSG+Iu4qoJp9eHdDGIIHEGtWqPBUVFX6aqfl9bW+snb2BL0z7jEprD3u06oSuTx3qWa+5H/DXLDK7C6zYhYbR5BoijTHNJ/qxiqbtuz5YHeYZIudWYM0C89UM4BtgOsdF0gjxSZuvRacx3IDoaGAItBLo+z8TvhZvpsPf5R9wKJ/wiiTW3U+EvzQEJ4kbMKGdq7rVJ0Wc9+5vYcuZdAgYFZuzLLsk7oxRvhhwNN8FK0eBqrg7tm5e1r7hO8Hf8QyBbu08ajVJ06mMjuTbQN9Zp9bx0e+A/OM2qOwsfKZ6vOIW9ULCjCW57CYvilL+Nba99DrZ/RV/TYEHuQ9xNrLj7byhwsZqHjv8hGAgpVywDaMVJxUDLi4j53fOYQlCNwqBBKZz0OtcHXhjUfy/uHnp2G9lU1ItbetrUEn9M+AbpeJAf2oHeV5/cNPDegHs2zTQ2hAwJpcMlmLksj6vb+9MFqmhKIn741VI/g3cd4Nse2e+X6NQ90RHoAGQIk/LU2jevoRB90jgMdUfcMCbd3M4CWMeizBnyhDTqxTTd47+vfSeS9dTylE9RnaGtmAiFkBpeW3dNnPT4YDqq3zcairtXEPFYks9j73lR8uWkguxyOjzKxyZnmBFLb6fFP5W0Fh9mSj5JOYpPZkx1wpbMm9SyJU0G4E8eVPZhIPMtLCaTjN1Wr1dMfJEixsrV6MWivHmVfRV0ph76WyzLLAUidJLpx+mmpn5HJopt3V0K/vo5uUVDm+uYOF6IpV10K/I2FacZQX4fcGTPjj6Ov+OkoE5PFbc02mQPoXFhxc4afDkxrR2TeA9tnFeisBOIh9aCU45ataL55Yq4rpRyKnX
 LqJnq3vs
 vnzzh+AM19jHj5U50/WG1RBuRKd+nkkfaWFK5gT55stxIdjmH08+vMR7UaerCRADjiWukYeRxS7C7K/O85uJuEEvDMkuiaidkkrKNZVldoiWcJr7CAwsXQ9F3Cfs6BAseuvpFKaO1NK8AbdpDiEktgOdL/hUvOdoQ3okvcWwjch+FMNvln+X8t4MTwm6uHptGi35VBpawAdehjVsELRzr+uuCMOaEjz3kJcyL0ce1PqnXzebMtrXseABbc9GdP5bL5d6ooqFBTmZxuRrX3L4SL5Gh6EB5u1oodpyELxp99DIHbxdoibM2+KmqzOFPSzmy1W51HbYc30dSpUFeoHBKISRKHYBPcK+ixarXmbgz+qh/7RWTM5RyKyhnXMqUURcN1yrHpo2bVeY5At77Qb+NXKk4nKUS7GSe72RMI42DDnrPGcUrdGYApzsTOMtQ46LKLAdAWsnagjK0qURBKd4l817o/92Jkk61VrsqwI1NLQnp6f7lM6XOp1Pd7anZqEdG/OWahS3N3KUO6AaSte+2G/mwcW8IDktEeiiYsYJf4D0ppCSNPUYONXw4St8xxyTt9xCbkSC6D0HBzOOavRAHIfaKVg04CPQXLheGQyoXEIaNl0GFC0k8Aw+H77vufgxu6T0E2S5QYEgAfWALHPnygwc3D0lHr8jrKAdFC02bLgqx8GRscQeMiJiMDxF0ar3gOzhTHNqIMefkfd0MgXcrq8qDZJw6ZkSdcEFSPsQatXdyl/aChjlml3SyaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "INFO:trying_to_register_non-static_key" on:

commit: b753522bed0b7e388a643f58d91bd81d8849ba43 ("kho: add test for kexec handover")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on      linus/master cca7a0aae8958c9b1cd14116cb8b2f22ace2205e]
[test failed on linux-next/master b7d4e259682caccb51a25283655f2c8f02e32d23]

in testcase: boot

config: x86_64-randconfig-075-20250806
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202508081032.1450e413-lkp@intel.com


[   59.011407][    T1] INFO: trying to register non-static key.
[   59.011783][    T1] The code is fine but needs lockdep annotation, or maybe
[   59.011783][    T1] you didn't initialize this object before use?
[   59.011783][    T1] turning off the locking correctness validator.
[   59.011783][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.16.0-rc5-00079-gb753522bed0b #1 PREEMPT(voluntary)
[   59.011783][    T1] Tainted: [T]=RANDSTRUCT
[   59.011783][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   59.011783][    T1] Call Trace:
[   59.011783][    T1]  <TASK>
[ 59.011783][ T1] dump_stack_lvl (lib/dump_stack.c:123) 
[ 59.011783][ T1] assign_lock_key (kernel/locking/lockdep.c:988) 
[ 59.011783][ T1] register_lock_class (kernel/locking/lockdep.c:?) 
[ 59.011783][ T1] __lock_acquire (kernel/locking/lockdep.c:?) 
[ 59.011783][ T1] lock_acquire (kernel/locking/lockdep.c:5871) 
[ 59.011783][ T1] ? xa_load_or_alloc (include/linux/xarray.h:699 kernel/kexec_handover.c:106) 
[ 59.011783][ T1] ? tracer_preempt_off (kernel/trace/trace_irqsoff.c:412) 
[ 59.011783][ T1] _raw_spin_lock (include/linux/spinlock_api_smp.h:133 kernel/locking/spinlock.c:154) 
[ 59.011783][ T1] ? xa_load_or_alloc (include/linux/xarray.h:699 kernel/kexec_handover.c:106) 
[ 59.011783][ T1] xa_load_or_alloc (include/linux/xarray.h:699 kernel/kexec_handover.c:106) 
[ 59.011783][ T1] __kho_preserve_order (kernel/kexec_handover.c:156) 
[ 59.011783][ T1] kho_test_init (lib/test_kho.c:84) 
[ 59.011783][ T1] ? __cfi_kho_test_init (lib/test_kho.c:271) 
[ 59.011783][ T1] do_one_initcall (init/main.c:1274) 
[ 59.011783][ T1] ? __cfi_kho_test_init (lib/test_kho.c:271) 
[ 59.011783][ T1] ? kasan_save_track (arch/x86/include/asm/current.h:25 mm/kasan/common.c:60 mm/kasan/common.c:69) 
[ 59.011783][ T1] ? kasan_save_track (mm/kasan/common.c:48 mm/kasan/common.c:68) 
[ 59.011783][ T1] ? __kasan_kmalloc (mm/kasan/common.c:398) 
[ 59.011783][ T1] ? tracer_hardirqs_off (kernel/trace/trace_irqsoff.c:412) 
[ 59.011783][ T1] ? do_initcalls (include/linux/slab.h:909 include/linux/slab.h:1039 init/main.c:1345) 
[ 59.011783][ T1] ? kernel_init_freeable (init/main.c:1588) 
[ 59.011783][ T1] ? tracer_hardirqs_on (kernel/trace/trace_irqsoff.c:452) 
[ 59.011783][ T1] ? tracer_hardirqs_off (kernel/trace/trace_irqsoff.c:412) 
[ 59.011783][ T1] ? tracer_hardirqs_on (kernel/trace/trace_irqsoff.c:452) 
[ 59.011783][ T1] ? irqentry_exit (kernel/entry/common.c:311) 
[ 59.011783][ T1] ? next_arg (lib/cmdline.c:273) 
[ 59.011783][ T1] ? parameq (kernel/params.c:91) 
[ 59.011783][ T1] ? parse_args (kernel/params.c:?) 
[ 59.011783][ T1] do_initcall_level (init/main.c:1335) 
[ 59.011783][ T1] do_initcalls (init/main.c:1349) 
[ 59.011783][ T1] kernel_init_freeable (init/main.c:1588) 
[ 59.011783][ T1] ? __cfi_kernel_init (init/main.c:1466) 
[ 59.011783][ T1] kernel_init (init/main.c:1476) 
[ 59.011783][ T1] ? __cfi_kernel_init (init/main.c:1466) 
[ 59.011783][ T1] ret_from_fork (arch/x86/kernel/process.c:154) 
[ 59.011783][ T1] ? __cfi_kernel_init (init/main.c:1466) 
[ 59.011783][ T1] ret_from_fork_asm (arch/x86/entry/entry_64.S:255) 
[   59.011783][    T1]  </TASK>


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250808/202508081032.1450e413-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


