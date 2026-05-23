Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D65CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF66C6B0092; Sat, 23 May 2026 10:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6C36B0095; Sat, 23 May 2026 10:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6EF06B0096; Sat, 23 May 2026 10:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF9E06B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:26:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 549DC120B6C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 14:26:15 +0000 (UTC)
X-FDA: 84798909510.09.E7F3CB4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CECA80008
	for <linux-mm@kvack.org>; Sat, 23 May 2026 14:26:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jb0xGj3B;
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779546372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=m6h0GgB7cA8OdGXMMv2bnzChBrj8kBSD8nzsgv7j1WY=;
	b=ZzbyiVdw6ShbYrgTvFMsI0nfUKUlv6rPxqoX6/1frS5Tibl5qBrX5QptmyWADhcTo04gMa
	ol5+RCY3ws9xk6mG6L20C7CRNoz2ukDbiQ1dj6WJz3IBzRwUtRgfjin/dZ0CWdsPXJhgk7
	V3mAffZx7eYlUVqOyKu+gVPjZCyjoqY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jb0xGj3B;
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779546372; a=rsa-sha256;
	cv=fail;
	b=OX1x42BqzROK6MXUNcpm/vOW26TFUJO+0oxFMnnPiXgLOgX41OCk3whAzUHFzpCriveppt
	SK55T7WnQU3mYfASKiLZcfNSR+kx+t5RzRvRtiIwMvnxkHlnQ+Le8kpaM/DHAFyHXpDY+v
	EvLooiNwKGKIq69lZs1IgK1HDAQv/Oc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779546372; x=1811082372;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=CCoZWiLiKuy2OwvIMM0USVlA7+YyzThwNq9Q0rgUC4k=;
  b=jb0xGj3BzHve/mqbWzNxwE/yh/OshR4MjVG0HVYwscYLcrMsCV3xQUeb
   vFQxR+uEw/V933pEW+TWb3UbbottUVW2ZfrLtzIbJ7QPLUHoFmdJKQRNV
   0GYI9sBTNA6a7BxEyQ8b6MgM/sFKB6hsDhhWhOJZDW9bEE+7omJ3nCZsi
   Q3UDdCvHLtuprOYlcKuzbE/IaQBlaomxXRrscZifVyeqLtITJsw3mkBy6
   2ttl4qDACZGcO8bfomg1YNxpX8SwL+NzBfES0pAPnGJOHyCGn4+/hK0cs
   0xhTSsYEbECOsUlGWlXRvbbh3Nz0mrKQoiLRZbMtHnMdwEUPivh8rNMYN
   g==;
X-CSE-ConnectionGUID: VvjQm4u3SEqQbt2FCG3XKw==
X-CSE-MsgGUID: ewnZXRxvRxqcgMi1wOlxWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11795"; a="84066031"
X-IronPort-AV: E=Sophos;i="6.24,164,1774335600"; 
   d="scan'208";a="84066031"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 07:26:10 -0700
X-CSE-ConnectionGUID: stsF+8EZREev1k43tB0OaQ==
X-CSE-MsgGUID: gIUY5tUPSeyyR0oHQZi2vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,164,1774335600"; 
   d="scan'208";a="279278460"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2026 07:26:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 23 May 2026 07:26:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sat, 23 May 2026 07:26:08 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 23 May 2026 07:26:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k3gNgXO/HQwTq1s70CKdgD0QK3bPkkSS7GVJSGGsvgcQn72+k7TguZ0FVc/3LQWLnOo821+vjoaAm4Q16Duf58RlNHXmw7DAzrRoojO0oFvYE8TEgd0aiPwDwSgnzDtm/jUOtG1XzMAjmfGtSxkFbkC6lEzI0vMhmXD322/cHZluxqKrQ3mjxHnLxXQ4gTsl7o1ZKXseqUloKlX7IFM85Y1p2Ww338U6oID1fWdoL62M7YimiyEGaykmr/pbgSG+VBJibeUrAMEewAfTKuxZgMxEBaOI5XkFeyV9eaHFwQ/l66+dJ4hUnA/7iSvJ6AZxPRICkwh5hqT9njA5n8X9eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6h0GgB7cA8OdGXMMv2bnzChBrj8kBSD8nzsgv7j1WY=;
 b=NCv4qtsnT6/ikfXQ3h/5ST1uh/cPFgQIq1wJfz8sd9PltmpO3bO5reI3ogKeFDWJldOEVs3e0JFui8e+nO/QRybtfkwL9vUBKXrsxHBAsUBCNC9+lg3SQIcfbFoH24r1WHrdos1Yr7rHBcQ0RC+cI+17kfezUG2xaIOy3+MlNVVfKY0m95/johccIapDNsU8hpVxx0+ZLkA5kDBR7hfzZGhyeRmJ8xXQ7sPNKVwhDKbXA8r5GNDnuY63aUef+Xyg7MxnVyLgzjQfm2sw1m0lM7PcZTfY0tzztoLdbf+7nE9lijLOgMVMtWSHNRJwPS72vqbAndJwFpRsZ7gCWAIj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 14:26:05 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 14:26:04 +0000
Date: Sat, 23 May 2026 22:25:50 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Luka Bai <lukafocus@icloud.com>, Luka Bai <lukabai@tencent.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
	"Nico Pache" <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Jann Horn <jannh@google.com>, Arnd Bergmann
	<arnd@arndb.de>, Kairui Song <kasong@tencent.com>,
	<linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, Luka Bai <lukabai@tencent.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH 4/5] mm: enable map_anon_folio_pmd_nopf to handle unshare
Message-ID: <202605231645.88096ca9-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260501-thp_cow-v1-4-005377483738@tencent.com>
X-ClientProxiedBy: KU2P306CA0013.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::17) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|BL1PR11MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 312ca272-dc9b-4beb-b7e0-08deb8d738ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info: 0AtV04F3WecLuCWNpkXra6m5JoKOgNIrOH5Wpj51DZRTZPLlwH/MWLb8VfFhP9T53SdW5MgpTjfG5rkso49IJDa6wde1GHZjyX1iiFtbGGg5B+IVf7krJRiCvGX+3yBIJ7hMDT8oWZ8qbv76SPNSC38XVG24kmGGJvRSufhzm8uSvzrk3c2lCtf4hhlmaKjsFhvTNmnsW7oU1ckZch0LSdW6U3qEZu2yFdgaqt828r8R3zuXCwaLHnxGCUOeJfrL5T60kfxpat2ChL7Tz897vxsHiLgZjDSnhwV+I/QVp/u/QLngP2gzeI3yUwvpNbNR4XJeL1nzXuj78ulk8QtEL69jz3m/9hqopmQWQ4ivdpHDV39UAtupv3xXbzvlm4jJDMxwLADNYZ9+3XrEvQxWL7wi4CRMvFemsVIjMKQTlRsmwrMFmf9N57awA0dYx70lHoM4010pJcNSzuL2VVFNqRk65V/YXufm7nRJeMPQJ2HCZJqLQaQaIAXnqBHT/5p6oFnVvsVTHKa52D2bT5Ac+jVdFQRLaQa/knQ4jEZyoPLPEScTrJdXAn4g97PERvfW4TcFbJfyMcqStkgRsHNNFUmc4axZL/BoByr8fEQ0dmntbUNxIZdZ+xuN4YK4l23GWxEJVxZr7pNlYmEY4rKPxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5yn77dJQeBCbah0d0xCsdt9rNzuMVVCQ5sjLexBpHwQa5FGoMPtVimm1SqmU?=
 =?us-ascii?Q?EqqGFdEmaO9fXxYRMj7fai+m0WTKtvHUuf55X1f4Y9RGkq+Q22EO+Cw94ZJ+?=
 =?us-ascii?Q?upGDMQ3a2H/fuq+o0pXg3j4w96KMEUcFzrzuGE9tWUt6rTGNtdCco/C4sQ3k?=
 =?us-ascii?Q?gX7arQ4Mb0EBk12vUmVzjEa1PXVjn1wACiPZGq0phz0OUtKvyjH/AG7KvCXo?=
 =?us-ascii?Q?yLtMrFRJONZHSBlYT4GjSvkwIjMJyS3FYTOUZlssYA7nCW52gSZG/3nDR+Mw?=
 =?us-ascii?Q?gQYdZs3UJitf3FtdTNCQK+nofl6SgAK1ddg0bQJBGhdjCjTY1PGvjr42Zb/R?=
 =?us-ascii?Q?VAJEHLhfJTEWomn93beX4NgO0p2RCk/iMwoX6BbvWzsOngWvejC0EaD5OE9C?=
 =?us-ascii?Q?5bV2D7ZnVxMlfbS1YWiNPDLvE5iXUAp/WgPrPkhvyFWEWWjSYi9sB5XvvBhX?=
 =?us-ascii?Q?dNcVzJnILecNZNpIbGSjSEbp3iEZB5Sre12Vr5L2CjuGB2Wh7Oglagpk04US?=
 =?us-ascii?Q?G+UGkp16fb2e9nMuLy330ww51Xy/mwaP94Icersp8PBu/x9nhPnmIX89B3B4?=
 =?us-ascii?Q?7cj+Bym/QnoJfGlkcFUT7sPtfB6xDHex4zlfjlpws77g4YvTE1HbEl5Qv/2g?=
 =?us-ascii?Q?ZEMyNjNro9eLwKICI9pZbtxG+JFgEiwbI9qvRnPaS2YG9/dsvj6SlQFXPxQA?=
 =?us-ascii?Q?5Pyth8nl/Z5E30g4hgnQQNg6RGCZ/nt53VGojKY7DMBfd071RuK1W2BqmGXd?=
 =?us-ascii?Q?w/8pOmbMOC8xyKjD98qJFBmIVs7hH2XEKnFyM4eqcwpSkB9CvD9FzhKyhyTX?=
 =?us-ascii?Q?1Xpg7yWpj8Wo7M8wIYO3rW2gSAqFGCrVn/98vN1AwrBjij2NjkLIuuB/Wb7F?=
 =?us-ascii?Q?lG7hmC5OIgdR1Qa0X5syVBJ/QpSgFgV8xGyrdPOMysMG5Pi7ZaCna/2TD3De?=
 =?us-ascii?Q?QpYpZvz/q2YQhVkEKRFFHcGnT0p+f38FD+VvfCoIEWSUxde+y0hoVM+70BGV?=
 =?us-ascii?Q?TvWyGXvML+pd9SdXlZPtTF1kcEAFf1zplFxoHlwpAj75IZjzavPwdunidZvQ?=
 =?us-ascii?Q?tu4kdrfZGd+1LUqPZFFfXFvpSIfbAZa/FAKIJrCRoY8JLU8Eep7YwJ6ZOVQA?=
 =?us-ascii?Q?RMv6AXOjgpNrY1X20E03b08380LsXADybkOTY3PMunegqwiVh8nAFNyoww48?=
 =?us-ascii?Q?PYv0g42Nr5yrprvPTGrtWQ6kCQ5tzrhZa5ZFl+VTAgjSpsxfxrF2A8KKJYl4?=
 =?us-ascii?Q?J47WCWmo6vma2g9p5CATHSRDfUPcREzR0YmZHCJskiK0OVl0+wD8ThNzlMux?=
 =?us-ascii?Q?ZhulPT4AQXIkGBzyCMXELOAd/pqvMXWXqnkfGYH6a/YqEe057LaMtNYUKJwj?=
 =?us-ascii?Q?Z7hw+ji5yW6DkcDNsyorBxBx06fM4vhfsWGobUBOdmOrgnCeib4UZfqw+S1Y?=
 =?us-ascii?Q?m4eDXZXBCp8czilvy8u0CRi4P14ZpUKWQ1RQRBJv6naZqi1zY6CW30ylh3+d?=
 =?us-ascii?Q?1RW6+GU/DFhoxbbKJqH//bjsZ9iDE3TIIgv3KgDou57qnncJv2dURuW+R7Xy?=
 =?us-ascii?Q?G1B+vx5W0xWeO6c1CtJSu/tSlaU1/rDgCaobhsNRD5gYOX+PNsaxe84Fl+4C?=
 =?us-ascii?Q?ghKyrZRLgjqPxgT1bb+td3M3Nmd8y8YknJzvpDMBlHwZWz2NjihqAx+UHfah?=
 =?us-ascii?Q?etl/BkG2AsUhdkdzMguYEwZhPFm82veqs430s3FWF9BCchd0pKV/eZq35a8r?=
 =?us-ascii?Q?pBNM257d9Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: aRe8tXx0eUY+gkHiVk1ytLqNbxKkhBekMrhjgRWMbP/3byll8XcKz1dYBmQXofuAPosYaudtejhsystNXVTviMp0NPUu2y3JBrC4xXOWG3VqYzUKLDwZMb8MDwneCnxZ3S+89v9Neob5ehDV9ZRE/1ByrP21Oki/RVajvxz5jPio01T/r/qacdiM28pFVkIixkbdu0h52nIcZJhIUeZRv7LEKGH21U9KdaBkIttZCzTOoqRvG1eXOBnC1CjIVKjwv1yK+EYqxuj+jlKQo8l8Pt23qTNnpHm32v5Cw+Dpk2sQxvkFzN5BBtEQl77pNW+2jgokK6kK1hwGE22/CG2WLg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 312ca272-dc9b-4beb-b7e0-08deb8d738ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 14:26:04.2843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyRWhuZVOhaVRzQGn91SSo/B/rF/QEs8RPxPxQx/zU7KmjyDO0wsuOOUHiICs4fIVwChCYKsHFWl513IHzhpqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0CECA80008
X-Stat-Signature: ih5uymbksikad5f3egiwp3e6zmbqa84s
X-HE-Tag: 1779546370-125076
X-HE-Meta: U2FsdGVkX1/r/+6YesFpK7qKGccef/Mb01L0e0RlrulNt+fRXfLuo1h1dVBkm5Nqz3FxhiEoD2pntNlImz6Gt47JOwKERVe+0qoYW6MyV2kNat/MHIvfpTeJwZKCUw1zYJi2JO91dlZEFej3Ga8KNZs25f266vsfeiHwKCp4RQvamkUb/DwcWmrn/IbXdnS+Co/jzjWbXTnoyUVlHEQjGKVxYv1KhzXJGvxhKuxhsdxorDXgquuIxqa7MumRswNs25KiftDqJdEd+jC0m9GgwHZ2VJvnhG8RctSaKanJotj8w/Rnlk18C42QzhtwNkcLZYubu3YYsDdMTWbahS0lksmopz4yeSb+KQ13Shw9IVuC66vqSI7p+5CtxzH4UoSqYDu4aMuNeOllnJEbMMVLxANIYYqoGcdnf6bSpU/a4H5+TKSEmhiBJllpM4RJwP5wftPgYqZ3vSG/HATNYabHXwiXpDyb7MmfMDGNuhwLJVdkJY6bTpgUvMo/sDelZvaqGWoSu7LeskT2ZsMoafHRMmvMS1fxHKWZEMe7bPMWaiZ4Kmz68nzf2wXD0WcPhZz/dP03lL/pZlCiqTRbE5pL98Wusxd+BnKKae0xF/Y0Gf1+nz3x/7F5iyRgVK1yuGrTxJN9sG9Qc2Y07lmlKzHbTjLjbrFugM3mr2V0cNpfpiia2K8yJHACJerlMxChEpVMAykPI08cHss7emmZyL0Lo5FgTBOJiCT/DG6xR3KBPkqzsvHJNd3mD2DwIJ0hE8GjVhglBnYoAP5k3JRaDV4IuWiVhrrWGePuA2qT2IdQAr0dhJ3+3RSJglUc4TeVlwTm8fd3zL6CSGyyPqQSzfNo/L2NEcdS/iuwDNN/DaVQqORj1Nq9jr7QXvEcJrdM/DMDECeZB7EFlDsGXfQApp6llT1uYkO9/AS9J4GgazHkBJa2GJBf4YQueeXJEn7ZN5BfoB5gAU9nUYLXvIm9Zmb
 x2MP+Ug4
 ub9+OKp9Akn/wq3VJr71SVgvGvQLItLB4iKCOYPX6HdL6h3ycX67rbKykgp0gUAlv+c67MZxtQCOWJ+Sycpc2PNn8CCH33sjCiRYzxbchToVWPfft4fww18Z4HEqURR2wZSNQyxyUv5M65I9qOiIKncYBRBWIANp/lusyZfhamAxudTZhwcsLjmiV+L2ri8QErUskl8OxQuyV7PuyqUvdEkyqu3jgAjyzDdwQeOenAIzpwuuW51kSZMGxkFPhuBhcw/aG5weX26LRlNiyGP7xNZc8+WCZ/EgOgJU0VLEE+KuW6GaK+SktQ5qFXP4c/89ep63mu6YiGGLj5RwYcZaKRh2v6VCPQzHwf1XXTaCIIVbC1KrxviSHl/qbeBfB6rBywk+ZheRDi/QMRh6aTQJ57tCLZs1B4L4uZ2l8c08oZopxGjm8g2h/sRzMSx4tgUVTYLDtevfnIH5MDeLqufSFpns+oS57sLhIjt7f+2qPntwadH0Gn2/ne9h1vqQCPITH2NL7wLJ9e/YC6NihqC2Juhy/maJnphUTw5d+2U0Jelif/XTQbjDh7RVMh+b8hDnli+wesO63XR2tSO1DFJrDwQJYX55CkMoRT3LZe8ApPGSugCR5CO0We57SiL2s9lB7a9KOqez9ron/PXUJ3BWFikdECdpunwa5s9lx+3J0CRmx8pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: 419ac88f7d747a174b48e12d2fd2178a128f54de ("[PATCH 4/5] mm: enable map_anon_folio_pmd_nopf to handle unshare")
url: https://github.com/intel-lab-lkp/linux/commits/Luka-Bai/mm-add-basic-madvise-helpers-and-branch-for-THP-setup/20260502-230731
patch link: https://lore.kernel.org/all/20260501-thp_cow-v1-4-005377483738@tencent.com/
patch subject: [PATCH 4/5] mm: enable map_anon_folio_pmd_nopf to handle unshare

in testcase: boot

config: x86_64-kexec
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202605231645.88096ca9-lkp@intel.com



[   15.354503][   T37] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   15.355458][   T37] #PF: supervisor write access in kernel mode
[   15.356077][   T37] #PF: error_code(0x0002) - not-present page
[   15.356690][   T37] PGD 0 P4D 0
[   15.357088][   T37] Oops: Oops: 0002 [#1] SMP PTI
[   15.357612][   T37] CPU: 0 UID: 0 PID: 37 Comm: khugepaged Not tainted 7.1.0-rc1-00099-g419ac88f7d74 #1 PREEMPT(lazy)
[   15.358688][   T37] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   15.362222][   T37] RIP: 0010:map_anon_folio_pmd_nopf (x86/include/asm/pgtable_64.h:79 x86/include/asm/pgtable.h:1210 huge_memory.c:1448)
[   15.364849][   T37] Code: e0 ff 48 89 df 4c 89 f6 4c 89 c2 b9 01 00 00 00 e8 b7 a2 fa ff 48 89 df 4c 89 f6 e8 6c 93 f4 ff 4c 89 64 24 20 48 8b 44 24 20 <49> 89 07 48 89 df 31 f6 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d
All code
========
   0:	e0 ff                	loopne 0x1
   2:	48 89 df             	mov    %rbx,%rdi
   5:	4c 89 f6             	mov    %r14,%rsi
   8:	4c 89 c2             	mov    %r8,%rdx
   b:	b9 01 00 00 00       	mov    $0x1,%ecx
  10:	e8 b7 a2 fa ff       	call   0xfffffffffffaa2cc
  15:	48 89 df             	mov    %rbx,%rdi
  18:	4c 89 f6             	mov    %r14,%rsi
  1b:	e8 6c 93 f4 ff       	call   0xfffffffffff4938c
  20:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  25:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  2a:*	49 89 07             	mov    %rax,(%r15)		<-- trapping instruction
  2d:	48 89 df             	mov    %rbx,%rdi
  30:	31 f6                	xor    %esi,%esi
  32:	48 83 c4 28          	add    $0x28,%rsp
  36:	5b                   	pop    %rbx
  37:	41 5c                	pop    %r12
  39:	41 5d                	pop    %r13
  3b:	41 5e                	pop    %r14
  3d:	41 5f                	pop    %r15
  3f:	5d                   	pop    %rbp

Code starting with the faulting instruction
===========================================
   0:	49 89 07             	mov    %rax,(%r15)
   3:	48 89 df             	mov    %rbx,%rdi
   6:	31 f6                	xor    %esi,%esi
   8:	48 83 c4 28          	add    $0x28,%rsp
   c:	5b                   	pop    %rbx
   d:	41 5c                	pop    %r12
   f:	41 5d                	pop    %r13
  11:	41 5e                	pop    %r14
  13:	41 5f                	pop    %r15
  15:	5d                   	pop    %rbp
[   15.372240][   T37] RSP: 0000:ffffc9000013fb70 EFLAGS: 00010282
[   15.374712][   T37] RAX: 8000000143a000e7 RBX: ffffea00050e8000 RCX: 0000000000000000
[   15.377932][   T37] RDX: 000000000000021f RSI: ffff88881fc271b0 RDI: ffff88881fc30640
[   15.381250][   T37] RBP: 0000000000000000 R08: 0000000000071ce9 R09: 000000000000b2e9
[   15.384563][   T37] R10: 0000000000000001 R11: 000000000000003f R12: 8000000143a000e7
[   15.387726][   T37] R13: 8000000000000025 R14: ffff88810e098900 R15: 0000000000000000
[   15.391175][   T37] FS:  0000000000000000(0000) GS:ffff88889c101000(0000) knlGS:0000000000000000
[   15.394883][   T37] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.397492][   T37] CR2: 0000000000000000 CR3: 0000000163644000 CR4: 00000000000406f0
[   15.400508][   T37] Call Trace:
[   15.403414][   T37]  <TASK>
[   15.404723][   T37]  ? lruvec_stat_mod_folio (memcontrol.c:993)
[   15.406687][   T37]  collapse_single_pmd (khugepaged.c:1411)
[   15.408449][   T37]  ? __pfx_wq_barrier_func (workqueue.c:1144)
[   15.410197][   T37]  ? __thp_vma_allowable_orders (huge_memory.c:124)
[   15.412115][   T37]  khugepaged (khugepaged.c:2901)
[   15.413596][   T37]  ? __pfx_khugepaged (khugepaged.c:3113)
[   15.415388][   T37]  kthread (kthread.c:436)
[   15.416719][   T37]  ? __pfx_kthread (kthread.c:1738)
[   15.418155][   T37]  ret_from_fork (x86/kernel/process.c:158)
[   15.419600][   T37]  ? __pfx_kthread (kthread.c:1738)
[   15.421001][   T37]  ret_from_fork_asm (x86/entry/entry_64.S:245)
[   15.422510][   T37]  </TASK>
[   15.423538][   T37] Modules linked in: sr_mod cdrom sg ata_generic fuse
[   15.425454][   T37] CR2: 0000000000000000
[   15.426674][   T37] ---[ end trace 0000000000000000 ]---
[   15.428142][   T37] RIP: 0010:map_anon_folio_pmd_nopf (x86/include/asm/pgtable_64.h:79 x86/include/asm/pgtable.h:1210 huge_memory.c:1448)
[   15.429793][   T37] Code: e0 ff 48 89 df 4c 89 f6 4c 89 c2 b9 01 00 00 00 e8 b7 a2 fa ff 48 89 df 4c 89 f6 e8 6c 93 f4 ff 4c 89 64 24 20 48 8b 44 24 20 <49> 89 07 48 89 df 31 f6 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d
All code
========
   0:	e0 ff                	loopne 0x1
   2:	48 89 df             	mov    %rbx,%rdi
   5:	4c 89 f6             	mov    %r14,%rsi
   8:	4c 89 c2             	mov    %r8,%rdx
   b:	b9 01 00 00 00       	mov    $0x1,%ecx
  10:	e8 b7 a2 fa ff       	call   0xfffffffffffaa2cc
  15:	48 89 df             	mov    %rbx,%rdi
  18:	4c 89 f6             	mov    %r14,%rsi
  1b:	e8 6c 93 f4 ff       	call   0xfffffffffff4938c
  20:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  25:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  2a:*	49 89 07             	mov    %rax,(%r15)		<-- trapping instruction
  2d:	48 89 df             	mov    %rbx,%rdi
  30:	31 f6                	xor    %esi,%esi
  32:	48 83 c4 28          	add    $0x28,%rsp
  36:	5b                   	pop    %rbx
  37:	41 5c                	pop    %r12
  39:	41 5d                	pop    %r13
  3b:	41 5e                	pop    %r14
  3d:	41 5f                	pop    %r15
  3f:	5d                   	pop    %rbp

Code starting with the faulting instruction
===========================================
   0:	49 89 07             	mov    %rax,(%r15)
   3:	48 89 df             	mov    %rbx,%rdi
   6:	31 f6                	xor    %esi,%esi
   8:	48 83 c4 28          	add    $0x28,%rsp
   c:	5b                   	pop    %rbx
   d:	41 5c                	pop    %r12
   f:	41 5d                	pop    %r13
  11:	41 5e                	pop    %r14
  13:	41 5f                	pop    %r15
  15:	5d                   	pop    %rbp


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260523/202605231645.88096ca9-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


