Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD3E1075273
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3BB6B0435; Thu, 19 Mar 2026 04:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B796B0436; Thu, 19 Mar 2026 04:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63086B0437; Thu, 19 Mar 2026 04:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91FF66B0435
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:28:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B8601B7EA2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:28:39 +0000 (UTC)
X-FDA: 84562136358.09.B01B9F6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id A54F220005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:28:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XeGkrCVU;
	spf=pass (imf03.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773908915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svb9ReH85WugA/rW1cQQo/O4UPdn8D48tAN8beaqkgQ=;
	b=aJonhwkTkAEOGbBe53qPUw+qtAdXdNVUee1d5HFzLe1qcxMDy0+guCuAc7EV4OGOazpnMb
	NPgUWz3bh9DQTodjXXXTLiVXPehLCnmwcq3QqllKkNRSMVYXNmVMXyKaLU0FMAcCsD5K1i
	w+A8unnK2WstqOiggmZdpjHvhK/QDYI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773908915; a=rsa-sha256;
	cv=fail;
	b=rLBCrBva6Uf7E3iVM5kXstAbZ75O24Fy1ASmcxIv06t5yjHbKUyX0PT13UDF7VYI6KXoWT
	drPeD3lXj7X43l5ow+t29dSd/hneFU0xZSb97dqbdaIk7zw886TNspGwuyfeYEAEPycg9S
	szSNgfctvKsm1ERjrIKavSPtBK6peLs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XeGkrCVU;
	spf=pass (imf03.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773908915; x=1805444915;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=duxkJ6QUvvXBiMeyu2ze2qGiRvzc79Ky0p3qALgxaCM=;
  b=XeGkrCVUXuVSSiZhaOxE+zHpXNLlHkgurAglglySIVIxIbu9k6MmzJA3
   BCqLaiFt2pdE8lk4Jae23qqNNS0NUMdbzw4BKdM86Ire+OZzeQll2Ywcu
   xkQFVCyzgqjEN+zc2NyIXuz17OW2e1TEgA1mwQPIimFNSGW53UHiWhkzj
   6PAR/0WB797PVsc5327dHh1GeYoQF9+BSpC+kTsIG62pXSRy7wBuSYpag
   7CvXmnwsGqtuhyR6RFJwSaOTdDtHpQyLPBdVfueubmBJbCKL61JTfJl6h
   LjM49pPEcrpyR6byZGBJhoDBIJAJ3N9IJ/GRPWkAM6IYZc4VjFgEVlonR
   A==;
X-CSE-ConnectionGUID: o0Did87fQdSjuF2s48NLIg==
X-CSE-MsgGUID: 5xaUKvJORzyKOaP2l9sZlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="85603237"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="85603237"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 01:28:33 -0700
X-CSE-ConnectionGUID: w/eYrXlWS3WJDpZT1xXwcA==
X-CSE-MsgGUID: BHBDYeu1ShqTpBqfxz09/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="245918304"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 01:28:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 01:28:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 01:28:32 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.4) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 01:28:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nOhIBseKMelFt5hjtu8tVCZIZG20p2W+u6EvEMc8vGR2XFEfz/4Yi7sWIZgXrJI8gzg4gl8s0E2K/61WyziLAxB5azhfDgGnxQBockMi2aCflnp8jpuzl0ApY2toXDybPyEuNXqrt8L/DSpOVKSl7d4d6Uttr6owPtMOjfAe9tQMcDHzK8nlGU1Ilqj03gN1x/jtfKPPd4cpIAdou02OaRWuC/8/olBEqOJAd5+h+EYlPB9+XyD9WI3aDLHmL1eBm7qv+iHPSnzABRuHGa0bCbqKKz2iwlKHumHnkxgP8YVXFhFISc7HiTkHfOf0+Murn/pSDq1O/i6tw7FHBUgRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svb9ReH85WugA/rW1cQQo/O4UPdn8D48tAN8beaqkgQ=;
 b=C1T21kXbua9wvk0jJwe+tNtfkryBWsJw5+KaijalDbxXDkMggxHtiObzQuRWmOACKXrjfvifdTYNC+gVNnIoh9H9dLctKS9QjzivncJEjaSzQkeZq/EvEToh5a1fgWrBSPYEEStiLxdF07jEm9UFpxN36JRL2RUYStSMDHKJ8gkP0hl04rt1SV4WWnhOxuY2G3NbSVobiaHRfB0ZA6Vld4Mw/9fuUve/iarpT3BewvtE8vHKmZr7klPLfxENoydo8QAPJ3AUJHNAzzkj33VFuZ99LR9/wFw8ikU5aiQQWGmc4Q7g5IWZcyBKn71xa+DL20DU9Y+91nCREhFr3CU6zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8286.namprd11.prod.outlook.com (2603:10b6:510:1c6::15)
 by SA1PR11MB8576.namprd11.prod.outlook.com (2603:10b6:806:3b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 08:28:29 +0000
Received: from PH8PR11MB8286.namprd11.prod.outlook.com
 ([fe80::4b69:94d:4eed:d920]) by PH8PR11MB8286.namprd11.prod.outlook.com
 ([fe80::4b69:94d:4eed:d920%7]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 08:28:29 +0000
Message-ID: <aaf3f7f2-4e20-4210-a65d-0157ad24c958@intel.com>
Date: Thu, 19 Mar 2026 16:28:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
From: "Li, Tianyou" <tianyou.li@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
 <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
 <24ef67e7-6f0f-4544-a50c-90c4de368c40@intel.com>
 <383e1567-0966-434e-a818-f70bff1d5220@kernel.org>
 <214b2cb0-e0d9-4482-956a-5bc599bae45e@intel.com>
Content-Language: en-US
In-Reply-To: <214b2cb0-e0d9-4482-956a-5bc599bae45e@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0037.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::16) To PH8PR11MB8286.namprd11.prod.outlook.com
 (2603:10b6:510:1c6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8286:EE_|SA1PR11MB8576:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9739a2-5b65-4328-7399-08de85917f64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: sD5hMDNCzMKa2XBUr9CGUViOd6xZBnwNX435MfJ3z07Jc/gXSrXaZ1VBS5/lFSYfXfpVemAY77aUYY0lCXAZoyGJTkqnUHKVlcFeewhobhTqflb3Y28zLKJmxQvLCivIP0Uz6AVkVqwC4wm/QMuib6kKx/4F52Z5guwTa2WN66d96zBL0gf23LSio+3aK3tQTAvHzR5bxc/8vhjp8iCmBazv0Fh02y4MPM9WpaMHYOQhd3pZMreyv7Df0AvSAOmBX6uNAf++tRie7Tfw7E9uQyrLnrH57w8tg6l9bxfjHhOqFLZWUomyXhXbrwVs9wVa1PHgMYxZ6iHtCD0NMamgZiWZRlf+H189KGRAcXtS2rFVujEAZxXfzC0zz3u48JtSB69Bgi0ZafoF04Gp7udmbEmOD3akR6ZbMS7frYt/eOH8LRyDgO0srD7ajbD5maJ8hk2/It8N7BS5QLzN716J4gJ4VUT3tR0i1YTmEVuGH4cwnO+j10qYcjvFJVsiqOfemOdx8ZSDGEH4BwMefqDS61iXcr7HTAMk6jhXIXei9Da5PSGkNzTPfhKurJcRHlzMwxr6SvJ/MHVncSYq+Q6wP462wwR8bO2BU5rzSw60bLFzBLKFVI6ah8nNX0mVu1YLAH7oSsFjxMo2FomMwO4bwIbaPyIarTIkD5fiuCjA6oj1jmidnzIMBFIOCUXIRRCZFzIAn8h6CZayHgzgoYhIwWFt9Bgk9LcqUWO+skIJrsk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8286.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WitkY05WdEMyWDJZUUxtTlNWOUMrZ0JIc2lVN0RNUldySExDeVViaWZsSDZa?=
 =?utf-8?B?S2hLQmpDMEx1K2owei9zMzFReUJSYnA0emhoUjJXQlRqRENsTE5jeFpTK29O?=
 =?utf-8?B?SjNQdXhBQ0s2NTVuaHNCVWNvcVlsaTJ1cklZU3JLQVFmU3lSYlQybXErSVZ5?=
 =?utf-8?B?WHE1WDkvd0wrQTBiSy9WRGtMMkZqR2c2Zk10cXZkcEd4eVBydnVnQytIWisw?=
 =?utf-8?B?RnhBaDFWTGdXdUdLUnU5MjRDSGs5eGMrVWp1SWJVVThjcTF3UUpiYmoxN25X?=
 =?utf-8?B?enBXM1RkeDJmV3JvQTEzWE9zWFBpZ0V6UlRya3BzMmphQ3FOVTMxaDhmSjVY?=
 =?utf-8?B?MTJEL2NCcGExb0Y1cXkyeHNwT2JFc2djQjB3YkFHcXJqMW5XNTlab0Z4N2t0?=
 =?utf-8?B?c1ZUSjFpNTRFRjdSakJkVVZCWWdNbHhNTlhoU2xJaFpNL0JHT2E2cTlDcWhn?=
 =?utf-8?B?RzJkVkFyeGNQenBJdUVJRHlXamhYK0l6TU9SMmtjVXI0aHRUZm95Wi9mdExN?=
 =?utf-8?B?T05NbW40azk4QnBHM1o3d0VVSmVaYXB3ZVBHbXdrYnlDRGhtY2pUVCtwVG9z?=
 =?utf-8?B?R3k3VGYxZ2hVaVRpQ2lWeTNSNEx5NUNlRnVhcmswUXIwQ1RJM2xmTE1SOG94?=
 =?utf-8?B?Nk5HWTY4bTZRRktRWi9QUXdOVU0rV3lkMXB4MS9WU0FjTE9mdjg2cVJtMUJT?=
 =?utf-8?B?cHROSjNKSmlNdVp0cDluVndFNEovSXFJMm9GK1djbE1EcDFvbklwcWl0V01m?=
 =?utf-8?B?dU53UDhvZUczOXdKUnluRHJvRTdrSFIzdUNCcHU2NFlySTU1MHlJckF6K1c1?=
 =?utf-8?B?K0toU1VFQ0NxaXVmSFp0b2pCY1I2ZGdyMmpUSTVEVXkzWFh6ZFlqQ2I4QjhV?=
 =?utf-8?B?N2tCNmRXMjBJRzNiRWl0VjRvY25UNVNGZzBwKzdmcHFKTnFzckNDeW1ITDRk?=
 =?utf-8?B?N25zQ05uZDlIT3RPV0xEYlRFYjFnbkxpQ0ZMQXhPSjl2aitqby9qM0lGT01o?=
 =?utf-8?B?emJ5UkFxWWNkV0c2ZWYvNGlqN29QbWhNUWErSVJkVGNRaCtyRitPQ2ltNzlp?=
 =?utf-8?B?a2xmL3Z2bE1taGlRV1VSaDNoSHczRkMxM09MY2ZlZGpCbStJRDlCMk0vMUs3?=
 =?utf-8?B?NUR0TWFvQmtHNks0cWxHdXR1MUt6OTFNZnp3ZHRiNm4yL1ozMjVXc0VhSXk2?=
 =?utf-8?B?RDFKT21BT3d4cm92a3dNVnV4YUZ0anovUGdUQkFnOVdEekJxRE0yRTN4ekc2?=
 =?utf-8?B?bXloWE9ibDFoK3J3MmhocG9yOVN0S2xRYmRLam5YaDhwMWFMa1NpSG1NNGs4?=
 =?utf-8?B?Mk9BdmFmTnV2Vm1iRjNiSExjdi8xQjF1Uk9xWlQ5Y0JqMk5oMEdYd2YyNW9C?=
 =?utf-8?B?Z0FpQ05jU0hlSlhHYXlHZnZaVXhXb1dSWWp4cnBkalpLWjhUaHBGaTZyd3U0?=
 =?utf-8?B?bDlXd29GZ0VlMmxvb3NvcUJHTm5FRzhXRFJIdkM1TVdiZmRRbEVZbUgwYUU1?=
 =?utf-8?B?Z0lFRkNSaWg1c0pGd0o4aTYrVTZDdGR3enJOQlIyV2NzN0FKdjBVMUxLOXdB?=
 =?utf-8?B?T2NYbUN4bktHT0szejhqTHhVR0Z2cUtlSW5jVDRYcDVhc29Sa0dKZlJqcjhv?=
 =?utf-8?B?N1k4dFludU5iSkIwWFZZVHVTUXZIVVNCQTg0MlpjamJiTGRlbjFJemZPMjdz?=
 =?utf-8?B?N3cxR0h6Qyt3dXRVNENqcE1OMGg3S05GR2JUcDVNL1dPdDhOUEQvK21UQ0t1?=
 =?utf-8?B?QVZaVUZ5c3BqbDlmMG94UWFQalZQb01YUlRZQmF5L21vOFFPanBRT1V4akcv?=
 =?utf-8?B?WTVoeDZmOUZ5Wk04VzZDUFFyWjhGQms3cndRUlBmV3ZnamJVa0lxTlE0QXQy?=
 =?utf-8?B?VEFUMDZmbHhFWm9pRkt6cXlYR1ZDSjZaQmF1ODEycUZHMTRJS0RaOUxLTVhJ?=
 =?utf-8?B?cHA5TFN0b3o5NTR0MEZIZWZFcWp0N0cxaE1vZGZ5TXROZFd2aHJVMjlDZmlV?=
 =?utf-8?B?NFV2UG9jMkl3YUpVb21ldDZKM3R3dDExamRsVWdpTWR0THUvaW16NEx2bE0r?=
 =?utf-8?B?Sjl1Y05wK2cwcU9PVUV4Yyt3U0JRM3NUVmprSE0yU2FNN05LMkRKRDJseVR4?=
 =?utf-8?B?dnlKQ09PQjF5cHZaMVNXU3Rlc1RlUm42U0FmYkExUUNMb3dEcHNEbjd4N1cw?=
 =?utf-8?B?VEE3ejdTdGRKY1drWFpDN1dBcFVwQU95RUNEcVlPMEJYekE5dUEzSXczQkV6?=
 =?utf-8?B?WThqSWl1WHhFc3FEbE5ZVElXZlBFdlQ5V2U5NjFEeHNuQWV4OStlMmM0Y1F4?=
 =?utf-8?B?WkxXM3ZoTkFiZ0NidUo0ZTlBWDBxdlRKSis5U05ZdlI3WTRmNERHZz09?=
X-Exchange-RoutingPolicyChecked: WQOt8yDxwTzgPhNhgYImhX7/UZF2KTculiFT6DqFqPfAmnlEO2+fT0EuKAF5p7A8boaXgC/vK9kYwZGkNvIROwWLrVdhm5+fP8HMs7mWBJURWzb9hBO/GDGhZ6LOfyr0rFWa02bWhtpxC/i9ccjD7CsDpUIhigPpva8MEKvwLtIBAe1Ubg9/KYXRxS2cUtyKyC3+WZY6F7uV/ZpzWYvTCvMjaPdRTgwcKg4ALcJSSiGggPZuAX1ICDo+rL25b6YyL5j9VPGd4zxs/xwgwpEKvPA4GanEwonNJBWobwqCmZ2rBVQWooQS134CpI8KJgQYvInwHD568WcXr4Cu891Z0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9739a2-5b65-4328-7399-08de85917f64
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8286.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 08:28:29.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3I6UybshXX/WmlCoo50YPJJW5Yhs3jHl4fNixtfaEEggjHbskKPSJv6+IGlqZ1rWcBdsZsRGIWUULh2/2G/tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8576
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A54F220005
X-Stat-Signature: ob8ornr7uz6yzp15mwcyz48io9ut364p
X-HE-Tag: 1773908914-20124
X-HE-Meta: U2FsdGVkX18dEiaea+4M8ZSU4BblZAPyW3Zuh8bJY5SpHnRQR8gN0eaaup0J9u55Nu1KQ1mq94QqAI+pK7wm4gK18W/IpUUHZinrwY/2QJ1Te8ShZ5C1RcRe28pjb5ZkNGD/pHpmcc2oex1iY2zPwzWq9VAe3hf06s6Hy4AuoptrLX50zEFdp1nLNQOa45+GpbO7fi+q/HE9ryjRbZUiS4C1hxqb9Iw+GgPXAeI5qmXMpzG6iZf+IqNjPCt9dRHkdga9QuqwTESxOX5JqlzHPLCYJ9RiUFDRryA9w40NhjWA+WGTwitW8ltqN4/eNUilSYJu9eEw9GYxXjgM2ExdED35giCiXlCiFE6Nc+wkhM5Dp7wSx8FNMlXuaOFlS+KG7WrmrDOGSaT/8cn+hqFUHJWAjuv/BNv7erKoj15ixTEKZihF5BhRt8uaQ3pAoRZ6y/B9T5V/q2zDlmPPW4y548mQw1kTuIkuaNX52qVxYsHAWoa9kXBW6cBKQOcK3FjqZnpFPHP+XMz7wxCV0BAWtNUvbkXjoKfu19tu90AJ/vEPf+4BvH1FaCQS0Wtjy3HXVIWvjJFemieGFwJefK6LIodQ4QYYFG3PtefSpLmA8ICYOT1eELjfRDrZSyhn+Cb5IDx/wI5kzXpWcsLDbo5LCp+d0E04rZQhEsHW3TPpnGeWI7eo0yWkYF0tJ6Fzj52R6p3EGCLWHSgQQTzAusDhtiH9ovZwXpa58U5rsTm1vvyO5OzP/GKkRzALYfj+7oDMzUfqDF0ZADDoxmQvTwpBmT7iQs/KCdiletpPUZt/YU1tzWyLKieSIW+rjT04lMvKu5w230AHBQ+9P611a76tyAn8ZfL2onlWEub4nNSbki3uIt5mflrP8anl0twFz6xZsQCThR7bnfByQa8fTEXKpza1o/pntzR93+qXVgXK7HuxkegE97DYjZwsZRqXIXjimNT0qScc+iVljiv7kLt
 tElxiOeo
 QUusSbOqK8DZqRP9Hn4npOXtQju8Zu2BdM6SmzsONVLoCMkoEh8Iv/6NKWnRx8y859WYHjnaaPfIL8SyZKdiE8HqX2MwdqqEt0zYO2ZjBKarxaKj9Gq/DaN3umi0IOo0Z4MusHK5Foiw3BmkQveqiyKhom7x9n5aiF1tufAfqe+4VPDUgBWm/rg7pqoeyIW0YYD7Zx1o62QKLBnSyE1ZjWQ72z+CP88ezCmZS6KKwkAbQkPPTw74tJ3+4aE+psJ0UF0QXAnQMT34ngd9nEacTXYIe5C1aB0dJPhHXa1AqYM5dg9xWprohlPMiomT+qlXTcOwaldTJ5A7KwR3eE+JF4usnvUUHAWwaa8k1FH4qbtiws/daZMRlrk5PWrfz8ejF+LaGnH/T7zQObuD4gTv/z3rTdizf/R8CbHN8mvOT3GpD5mjdZ8cIuJlluzTqVv1ARZhUoizDV3+5+egawD0WVQfmUk0h2tuQWmkgR70XA0QTgDXL983yan5e53XWk5bydedOi8mnoS6mNOdskC+fwDydkyRVDLAUz8zbf1xBalF+QsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,


Yuan has create another patch with test result. He will submit the patch 
soon. Thanks in advance for your kind review.


Regards,

Tianyou



On 3/11/2026 11:02 PM, Li, Tianyou wrote:

>
> On 3/9/2026 10:26 PM, David Hildenbrand (Arm) wrote:
>> On 3/9/26 01:42, Li, Tianyou wrote:
>>> Hi David, Mike & Other maintainers,
>> Hi!
>>
>>> Just a quick update: Yuan and I created a new patch based on David and
>>> Mike's code, updated the documentation as well, performed the
>>> performance test, double check all the references etc. We observed a
>>> slightly performance regression, not sure it was caused by the
>>> environment configuration or we triggered some unexpected behavior. We
>>> might need a bit more time to investigate. Will send out the patch soon
>>> once we have confirmed data for the performance regression. Thanks.
>> A performance regression would be rather unexpected, unless we somehow
>> don't ever set zone->contiguous=true any more :)
>>
>> In which test / code path did you observe a regression?
>
>
> Sorry for the late response, I missed the email by accident. The test 
> is simply hotplug and unplug the 256GB memory, the time became 3s 
> instead of 2s for some reason compared to previous patch. 
> Interestingly, for 512GB memory hotplug/unplug, the time remains as 
> 6s. What we planned to do are: 1. double/triple check with the same 
> and other servers; 2. collect the perf profile to see what is the diff 
> compared with previous patch, if the regression consistently persisted.
>
> I will work with Yuan on this and hopefully we can have more 
> information to be shared here soon. Thanks.
>
>
> Regards,
>
> Tianyou
>

