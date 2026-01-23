Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE95D6CFBB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C150E6B0394; Thu, 22 Jan 2026 23:20:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6166B0396; Thu, 22 Jan 2026 23:20:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACDBC6B0397; Thu, 22 Jan 2026 23:20:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6B06B0394
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:20:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FDB11A01C7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:20:23 +0000 (UTC)
X-FDA: 84361926726.04.FA2984F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3C7980005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:20:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IpOb1XHG;
	spf=pass (imf02.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769142020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oajmQb7xaVn3Q9EtmddOGMZtMTusFuIHkkc2iXP5ZyU=;
	b=rDbIK7Bsv5Vl0Swb2p4HNChR2dZWsbplaU2VlUHd9Z08woA8ali4Q9gHyH26sYvvTW4Ifg
	oFjU3qWHzGIOSsJ4EgTl06+GYUakvIz7Wc/M6ZRaHN4BlHQ4hppH+fe5w2BhnuiD7Di/R3
	yj/A9+d3F0uTYeqzwxOBp15bky96jTo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IpOb1XHG;
	spf=pass (imf02.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769142020; a=rsa-sha256;
	cv=fail;
	b=UVC38cOExt9XcU1QY32uot8ewbTRtHAfNqDylLGWDLPbpTYf+zqmig+NaOYBbV47QYpaqQ
	dgAijV/H7BmMLWfUWcRIujH9jlaZH+Kbu+8Kq78WdmyWmKK2+hEK28SZ0ZVdAO8OK4FICn
	3SY4MhRqE8W1sfklKdUDQUag+0VPATs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769142019; x=1800678019;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vrfFmAkok5h8h4ZG59UphjI92PdiBM2CV74yvrHJmYs=;
  b=IpOb1XHGetbPvTB1tkDnQnpFW9rcMHAUAkYut4v6jW2x0ECGhh2FuHF8
   Pq7wI4D9wKa8m+uN/gkrn9lvf6AdwRzNui1+XmNX/A0tEgW0H+yNkEKhO
   31qYNBkPbmW9TAiwc/6/rZ7l7SZxizYt5Yx3YCenstoDTffnhvm0ZS2ij
   AE07AKyTY36uFZ0cownCX3KfJoR5IeGQ8cbLaQPXCSN9mC1pZeEYZWKtN
   W2mweI7jCFKJAlWKB0gEnPKd8qJskR5ayTRTQz4lM9/aVsDNWPYQ4U3kW
   QiRtmIbTNfx06m9BPaQSk5HQAmqhxt4nNIQIXu0heDA/o1Hft2/se4inw
   g==;
X-CSE-ConnectionGUID: wu4HOwxBRVW9K5jWW66WIg==
X-CSE-MsgGUID: UkmlTeztTsmoxw1hM8d0iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="81114084"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="81114084"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 20:20:17 -0800
X-CSE-ConnectionGUID: ZXE0gvygQfSDD4+8Na0XIA==
X-CSE-MsgGUID: ec3HSI0cQHW0yvHG6mlBsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="229887883"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 20:20:18 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 20:20:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 20:20:16 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.67) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 20:20:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRRuQ/EWlldMHoa98W52p6+XRXTkLj2JLra/ykerJ3FOZbopX7+I2C69IsW9oPqV957xE4wYuOLuGRi7tRnBMTWU+Pe2f4f88V6zZchBSO/Ala9wNaaJFIpaH+SeQ/5x+uIvkZFZZvi+sDQ9IZ2PsTV6AY9d8pECS/VtvLl+Qfs0YJesnnMBSFd7c/x5TyWKWTi9Q1g73zVILI9KIkCItKO+NAtATr+6WlA9LbGtLv1UWIhY0/FplgjJ4DKYAwBLxI7nurlQFOgFU0rvNDSZxUmbtPnQAvaZtjG5wNqTeJNhGurs+3NcI0W1G3SyunSQDBiANowwecZAdi1p5krTYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oajmQb7xaVn3Q9EtmddOGMZtMTusFuIHkkc2iXP5ZyU=;
 b=odtqfjAN9RZdEqpvZgPiE2QORD8jjCw/4HCxjPrL4ReV/LXssAw3Sd9zqIrIKpE7bryCmPVrLj0YW4WMLVHhZZxWlvoLfcdpNI85aZF+d1SAwUJJndS8LWP2aYXhid1d80xORttVg3snYjgUg8pwZGoT9QBLWTyaBdYoiDtJIxczl6vBuq3SOpIBGV3FsC08PMBJLfMAutBN5Mi2rLLL5xuA65sqY7wCZmil+rEERXNnDAPk/XijCbVUE4+EZ9RWw9NELihWJsfTDMYT7E2/7E9HbbSz2CU5JvfK09Gu1ddV1o+wjUMfQXLEvk+IjsvEiP/BmJx5tPCydmQIoK2+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
 by CY5PR11MB6282.namprd11.prod.outlook.com (2603:10b6:930:22::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 04:20:14 +0000
Received: from CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394]) by CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394%5]) with mapi id 15.20.9542.009; Fri, 23 Jan 2026
 04:20:13 +0000
Date: Fri, 23 Jan 2026 12:19:59 +0800
From: Philip Li <philip.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel test robot <lkp@intel.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <oe-kbuild-all@lists.linux.dev>, "David
 Hildenbrand" <david@kernel.org>, Linux Memory Management List
	<linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 420/429] fs/romfs/mmap-nommu.c:66:42: sparse:
 sparse: dereference of noderef expression
Message-ID: <aXL27/BZ/xIwNfT3@rli9-mobl>
References: <202601221505.RxftadLx-lkp@intel.com>
 <20260122132335.5f3160dd20dfdb68c57ede35@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260122132335.5f3160dd20dfdb68c57ede35@linux-foundation.org>
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8468:EE_|CY5PR11MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ea4d8fd-6299-4a09-e15a-08de5a36b467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lDRcybmn0kK2mEdsiKxmO/dY+ePRCAm574D98ycjkXJIE7SoobRlXIQIjvPC?=
 =?us-ascii?Q?qVQ2enbc9nDv19bLKP+jXyGjqvg211wzo/BYc3AXz/HmHvzURoFjylpzRn+P?=
 =?us-ascii?Q?YOiKhl+UAM2i9qUq9ByQP3wdQmTlYUsxv8S6DwGTzYygiC5gRAS7Co9cYZ4+?=
 =?us-ascii?Q?jVG9BQ+F3VxIDVTKRWtQDPX5hvWjHM16MlFKob6IArRYUCOyHsxK4kTGnlzt?=
 =?us-ascii?Q?vlbZ3EBIV6llm5Ojbjb/v06P6A2Uf+ppU1/c2/c1E8UQky2VJ8DHEroYfANb?=
 =?us-ascii?Q?C162Ac3tA7SmAO3sjYHdHZYlxVnh3Lm85PEAITAqiy2IPcgVJRnW6SxkSBoC?=
 =?us-ascii?Q?9i/B05wgMXW41dyiUda1NB+P5ysAmG3rI1TVM8z4aPl2Ulur44DJQ/U+pg0E?=
 =?us-ascii?Q?uan9V/wnK/eTpdatL6Wr99BI8559MvraDRIBra2t56dMpN9pcBMlUK3aH+YQ?=
 =?us-ascii?Q?hh/V4kkIg+N5rgViTeU+qnLs/RkX1tpdcWIMOT3vIeXyUbYnvps0HDk0/hvS?=
 =?us-ascii?Q?hJpDAPSBdBlvd4fEAbwnOZ5Z9jQwEx7HKaEZOWGd1saroLHBRZDrbE7BVOyB?=
 =?us-ascii?Q?tEgISs5ZScWZAl5hQet3WyEJeiVd2d5SQmQ04nZn+2njC9Edw8S6cL4HrAAN?=
 =?us-ascii?Q?pfTMquYLOb2vWN2G+c03Pra7ypWxildXCl1JqwoAQDQGAyTDKhXn4i8BE/+T?=
 =?us-ascii?Q?HikEdcR82R/ripm7SH6a3SB00oEdXzTkfX6BnhkfnubYCF9o5fWnazPHseND?=
 =?us-ascii?Q?14NNoi1olcOypAWNPPHIqw1M1EHYOxg2v73AzjbQFysalp2e5Yq3y/VUMEtK?=
 =?us-ascii?Q?u/P5+9DCBfZSiuOv7SqybJSXKqwnfshWVDH2F0c0pmHwq/1v84oOp4bMX7Op?=
 =?us-ascii?Q?83Qot5N/lRatNoBEYdPfvutEx/Kvy2BgBk/XiNmF3UlebpTWT7EOFT0sVs+K?=
 =?us-ascii?Q?ce8FNCkbPgLp50HcG5f7Ar5LSbM91JWRk1FsjPYwsyNzMiZMBb8MOTjGW9a9?=
 =?us-ascii?Q?vXLUavchHPwMf/pO1MafLPVEMzhFT47FOgXKaRDmNP76NtuZf3IjZhNVMQWg?=
 =?us-ascii?Q?1OFPkpqHKML1ldvtbK5vLj5tOG+6+D7w9rTTImhyme3x1VOwQlmFjQKBuASx?=
 =?us-ascii?Q?cAVytlyiUj1w19HaZKUgThzOKQI2EDFbrj+gTHzxyletCKkQuy81LDjGQxdK?=
 =?us-ascii?Q?PqkAJouetVnuxsrAkinkqz2UgY9Kp6EmmVXmAQKJWM9UyvmrYUkJaoWEMtHe?=
 =?us-ascii?Q?U42Q+IfudM8zAz60hQ5XqxLHqp/GNQH6WRkgIk3cLhath80VnAX/FjKHUx/B?=
 =?us-ascii?Q?+uY0UQswQymBvQA/fAbvC41IwOlKnciKy83Nx0M3y/1JVtlpgbw/bagb9b5W?=
 =?us-ascii?Q?JmjydQJ2qAuyLpOKf2ua1dOcyqkuNzXrTE1G8Ujt0OtiHUtNFtYmNWfrB4bD?=
 =?us-ascii?Q?MdDCnsQDRUn4jELrGHaBko2toduJ6L0Ow1IrvZrEI8qJIiuT5zsaJw8nSdH0?=
 =?us-ascii?Q?DP7VfCsSeB86M5PqcPFY/+1bU/lbvzcr3yOYPyTEQw7Nu0DWF73UJFDCjmNO?=
 =?us-ascii?Q?9FtJldw0YIikcI7O5u/IZtDAKvE3sTutwdxy1eM3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w1M0e6vrvcL/jZFRiWQflx8ebgqjP6qwcMmwv45nz4lmN8oqUlSOQiC1HR4D?=
 =?us-ascii?Q?P9hLsRBgA6LFHAZ9NBqaDs8Qw/labRzgQKy+JADxOv6ZqehHWWYHCIF//jP5?=
 =?us-ascii?Q?qES47/qzF/+kBNKgYa9NaTXdcsRNp0POzJiAoOcgx60xUrtfyF9n3lfqBuS6?=
 =?us-ascii?Q?dKuZSbLt7Rs2+qGd0gtBLCxvmolG2/RzA8ORhFTViVbxvzhCn5pqtxNe0xUp?=
 =?us-ascii?Q?wbnaqCnKr7tTX9632GP81kwaNFkqATxsf/hyhUMjRMLhuZDlw7qDEoy2KwPq?=
 =?us-ascii?Q?uXqxI1h8lcisi3C8kslWS0Ada7hkIh1cSYU3MovhaGGBmNeQpU+qT98TJc91?=
 =?us-ascii?Q?30lLKDwKqMvRMUPFgHCiHT3vblv1CxmMc4cmygWMahgW3LRBJEniSEDMg8Y+?=
 =?us-ascii?Q?xSEPNj+mQ4m3mi3lgeWICaYBUgVnRSg0FYsq1jkBjegK+Kahi+KLWwHp1IT9?=
 =?us-ascii?Q?QLTNBtKMcFf3EzWrMLIQM6YWmi35ZhSwBVg885JbAFW7g289G9IMs06w28Tj?=
 =?us-ascii?Q?u76JAxG3lohoP/NZfVqtgNSGp7S5AV4k76FjZfmdzeiOR/+TpBd4ZdNMeuDi?=
 =?us-ascii?Q?uESIgIxkaUs88qBF0rJGoPdXx7AwdG71gGld6EAxv9pQ06xXnPfb0OksArbV?=
 =?us-ascii?Q?ps8I/ckQDQWjc8SrLlRJE76TFZyZSKBj9v3bABhm0hsPRNAqzOkoDaIEagCT?=
 =?us-ascii?Q?lIKud5TAPW4E94hiphxwdAypQwnIKYQpAHJfZjQUwiBIf0cOis3QS8mM5mmd?=
 =?us-ascii?Q?/q0ddewW6TEYd4ikCZz8nZ/NiQx6pqKXc2osvp4bKlUfL0iatFXK7NcxPaux?=
 =?us-ascii?Q?8IMapDQjohnX2tv97MN9xK0ULgI/PqNJoOIGSEUv6fTrQf3qIlLiMH6FRkZB?=
 =?us-ascii?Q?I8ZKkKnE4rsAEEkmzc3mgq8Ax5GtvaU5t0bLR06g/MkSQZw6P/92HWt6ki8Y?=
 =?us-ascii?Q?jcuNoBg/hUengmMEYpyNbekq2gYrr9JqJDgEditw+vokbL7mFjrbXoV2/2Ok?=
 =?us-ascii?Q?QThmrpmYfKBfgKtNWNCq4HwHyywjoVC0QtBUdTXnA/ZEGHTB+qBu/5+L6bnI?=
 =?us-ascii?Q?1haIu8h9cAI4hHveOMCq6Ja3j2hc3+/4YQpMGi3YE/UotGXaDFQsuNpUQi43?=
 =?us-ascii?Q?6a/fQ375JfBIEsbWthElTvnQ8tQj2fZRUuJHyicbhBJEdxxD2LXdOH+otPd+?=
 =?us-ascii?Q?titxzbREPkIiDBJyrAQL3VyAzZg6KgLu2IsoV6qwSc11ReAjnueoVJIo/yUa?=
 =?us-ascii?Q?CLceIA5dzPdLBJ7HqV02UNegm7FvwpZy4hg5aUF+qv4bGHZ5BuSrSbq9sRWA?=
 =?us-ascii?Q?cE8C0aFxh7Q83CnkjahVVlfUlgsU3GfuGtoXrb+iBaHUPBBA7Sj9LZe1Xi0v?=
 =?us-ascii?Q?/1WT4sJLu/Sd33nmICv7DjTpq0VFaIRQDhekIMV8D2jkWOfC3PDCchR27XqK?=
 =?us-ascii?Q?ygRvAlPZSPxWqvoBLfCt1gk27unI4ThS2i+wScW1pH4B9ulhXJ1iLn64ha/S?=
 =?us-ascii?Q?YUiWoaqdCy1v9oZX0MjDtwLZXnrIGSgW72KnpylB3LLFJrrGMrxXYqZDJUBM?=
 =?us-ascii?Q?rjYxGUqvvbcX3W3TczMp0RpeR1QZVOMr5B3zgCoIriYqs5OpUP2CHsM9Wt3V?=
 =?us-ascii?Q?nQS693pmpI/+DY4ZNV+IOl1ily7Fi7sFvrwJ+jrhIkgFjRE7z4mSbAT78KeG?=
 =?us-ascii?Q?pOUCbd+EtOyQwlTa5Gw9CzDIQHloQ9uN5NCVOPpVz4fGO8Shn7pgVr0ffpzk?=
 =?us-ascii?Q?9hZHlZyfxg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea4d8fd-6299-4a09-e15a-08de5a36b467
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8468.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 04:20:13.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4gnzOwoOu+h/NMeu225jCd/ApMgRo+7h12CI6R7JWvQNnk7gwUNtolYXI9g1Z8cLWCPDkYsL4uKRTDzgDr7Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6282
X-OriginatorOrg: intel.com
X-Stat-Signature: yfit8569hbub4ioddt7bebeqpffbmpye
X-Rspamd-Queue-Id: E3C7980005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769142018-816860
X-HE-Meta: U2FsdGVkX1/5WmWY7c39izMNL8TkQr0zoMi1+Hml5/7szQpfORo/q87hymqc8iC4A7SeQ4oteMHoPpWn1dVrJXxThdPwZMGqMenPUrShZNJUVF07Ai4xs0Vfsbdeh4GlHYi9BjREF1Ll9VfjppvMkK4v/ppyOXA04slcyJMg90cmeFTT+yW1bzrXLZX55Co8w1PQqEDZWLbjc9lWgSv+iCAmTkGU6rxwil0NZMf4U/pf1mP+C5Kx/kw6oOm7PYFm40jyuZ5gErseJZD6vWs3ccszOC1xXxURNljjXoRr6sf1wY2sO3I/RDwTFAEsJ4+Xmit6GuNNGSy8tzuGN7G5GHpel0L5zFxk5ufOyUuQSfHTPIxLqBAZ6sUGeVaccgeTtRoAhpO5EKgwXiLsDi6oQprZErpY8VG0UQXPS7lSXSUQv0Hv8a61ryV66f1UiCbqWtmUCYV7oagYixUQjbqQL14KLpYS3/9GTK4yEDNDHntZ8csl0NnJEuUuT8VjGiUhbIa5tvVUA8ueBMPpW29N4DTJbinvKM1oiS5EjmKxzXtAKLqAl+xXzLTvXE2vmZgYDWnTTpfBTUSUzTLQYJhWriJwv/bS8rLxGE5yXe46hs5e2thUHOkBUD3VQfzBjSP1kz3bUctGr0XE9j/FPlUFcCAnRFHLued1H9WifVi5C6NOp+MniiVaWnvPReDdJRb2x43UuQ77yIDSZWtuZEq5eD6CxTIpTMbCU/hNhSECcGMOK31I6HYDKQa5T1NbiNCghGmdYv+BzxiOYxtOMPSjtec1ZdNWgVgmVDvJCnLF+Do7hbnEakOzueO5+mUc0fdPF32pqJkf61RFrmz7DOxoEN1mOTNNjmjznvoC3FmW962lw7Z/0CpNkK0xF9sb/m7BBM0Rfws9+rNmqZiJ3zrKTYsVhjVEjIuAf+FZw0YoIerI6iG0z2L/826sDGCI4AFFh5euk7FsLaT0vVT0fZu
 ZaOJMqcz
 Shp2B9So6T+FrXff/gx2O/uoZAnxWvWVj26BAKgdo+hied/rluLGbALSu5jaRltNebPHfDnnCB5tAmVnotm1SHDWPs40xQDVeXni7xz3BApHqsz6uWA6VuU0CxTcaxilcMjD2TlyZsGIPZqe2FuRTfhDfswdFB6C/w6bDTdk0FZ+oPCMY4dRThYkjjpKRD104vH6z5jBr442tnjl4YOEOqVTsiHQxTLWcBInEm2OaHwoLjKPFq/XKxfk4VdAIQ+nde6RlIPiF6/Vi9R8MbktyvmjbybkjKTWC2i4jSawxqNBYdmTj8K2PXWi/nxj+0PaT5JIQ6lH8KKpQ1SLSql5znwSz9+Nn853eQrSSefsRqO/FHI+Pb9SmUDAlNRgcpI/A96ybVi3OWkAn+k6B8u8oH8AFWb4wDT7X38GIuhRxAhGfFQzSAVS8QPWN+HbdoFG88/j0qEPP4dHmNM9OfDq/8vQdNm+tpt0EctF03Ub907RzBintOYjKC9jNHxyEstF3qNeO0CYDQv+v7v8ygWQbSH1Kxyau/pFqVWXMchtn14ShTX/HWjnWkTHxiknipXwhYG4rT3Jf1/a1hWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 01:23:35PM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2026 16:04:37 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Lorenzo,
> > 
> > FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   dc4fe40a11269aead253fa0beb098b00417b8694
> > commit: 57a654376d4bb67119d436edc8c3c4c0ecb3c369 [420/429] mm: update all remaining mmap_prepare users to use vma_flags_t
> > config: sh-randconfig-r122-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/config)
> 
> Has CONFIG_NOMMU=y
> 
> > compiler: sh4-linux-gcc (GCC) 13.4.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601221505.RxftadLx-lkp@intel.com/
> > 
> > sparse warnings: (new ones prefixed by >>)
> > >> fs/romfs/mmap-nommu.c:66:42: sparse: sparse: dereference of noderef expression
> 
> fs/romfs/Makefile has
> 
> ifneq ($(CONFIG_MMU),y)
> romfs-$(CONFIG_ROMFS_ON_MTD) += mmap-nommu.o
> endif
> 
> so why is mmap-nommu.o being compiled in this testing??

Hi Andrew, the related configs are set as below, and this is guarded
with CONFIG_MMU, thus the build is triggered for mmap-nommu.o.

# CONFIG_MMU is not set
CONFIG_NOMMU=y

> 

