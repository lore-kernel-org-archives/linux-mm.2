Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2561C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04196B0095; Sun, 23 Aug 2026 08:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB54A6B009B; Sun, 23 Aug 2026 08:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CED6B009D; Sun, 23 Aug 2026 08:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5346B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:14:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC52940205
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:14:33 +0000 (UTC)
X-FDA: 85132427226.29.4A426CE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id E3E8318000C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:14:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d7yiZTKr;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=tFsLwbAMvlk7T3VsAbaypJmecjvt3xgCM/mHCdnVWOQ=;
	b=nFim/YRBQKNC2xtaGUr6Jtq0wFJKYe6v7WBwYQ5hqBmRRU5TZD6MjTVgyZClqfHb6mXJaa
	kQLrqZRMiIERHItN4zZWzzYtTSOqByyZNCaAFSeKLnMew38MvQ/MsGT03TgmrBsdtC7OQi
	aLXacQmXdSQqVp8jfnusMujRh8LSB0A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d7yiZTKr;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787487270;
	b=hr603MIHpoTOVi3sLrZzp4A7rWFeeHFihmRV2GO8NCCj7o6E+Vli3bVVlVjVWPR+RS5pb6
	06QcGf/MORoCfhLuKmjQoSu0eAAonqQVfF2wyyyWSwSoKDGrCckkarXU+B3oijX99l6KnM
	Yb117XKzn2MkS/7LCU+8mjsgvsOxuDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787487269; x=1819023269;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=mbXGQMMBVD0m1echtyWuZ27w1mas5bi2uKnlS6CHH/0=;
  b=d7yiZTKrtSe7QvZwYMnEnGb0CYch29YXonpSCwxn78fVdndFRrDf7AH3
   2lrRLPLsA6o3e5PhkfskiBi6ELcslOJjEdoZ/XXwWJPN5Zsf7K3xIpJPv
   xkXrisz1x+MzK/HvIb4pNLf6bykMWktbwNvPfpo8oOJbuzj01x38BDqUc
   50WPL2pzRKL25nRicjRg5XMkUcisV/8G3pPIi3B088wwVvhonw/mHbCrQ
   JmEp4Nc2nWnDbapiu499UtZVsv0ar3R+4h5+CQ6EkyxLOUKTl42pPqN4U
   p6iCJ/6YrQvZmQN+L+00eE9TT1GCOCunBZt3RtHmcdczX9KZdmz/xJqey
   Q==;
X-CSE-ConnectionGUID: 7vMRO7V0TkyQztTy5xJKJA==
X-CSE-MsgGUID: 0LOpv8DmT/W7szJPPFSFkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="88088884"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="88088884"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:14:28 -0700
X-CSE-ConnectionGUID: oZoDpNcdQFumRUhuJQ3wwQ==
X-CSE-MsgGUID: kwP9ZLlpSJ2yealLuGWzBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="260603105"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:14:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:14:27 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 05:14:27 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:14:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gG6QwldGaaRjbDouXf6R/r0pfMSZOm8IpGIhJGMhhagf3DMCZ1X3s4FNflLLeFFrKSTJFHbFX5Rov3nEkHn/Coi2/9bUz93tvNGNGG+2C3aoNU5e3vnUAiIy+n2htRlULfZdj/EPOJsVLlVWTtqz0FVTPy6uXWIjPfV88JZRGatU21pe0ck6vGoZoMRcWwBlRWXMhOi3hfOD9ZS8Q4rpNu8y6Lh9fB+uNx7li1HcXz4hE33WT7P8iGJQmhrETpbsq3RI/X0D8S9xPNkDYoEIIIQFksl4V05c1AYDSJ2GC42vhQCf5upfzYy2AwTNA/JHXl+BJcQ+agegQhESf2E33Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFsLwbAMvlk7T3VsAbaypJmecjvt3xgCM/mHCdnVWOQ=;
 b=k0wS+P3ewK8FH8l7xcNcZlfhMKUmEd80SQzsuOOH/TBacakx5af04itVKXH16KiGsTI8Z9L22su/KlhU+O3sIoSz679vnudj1TikswJMNOhz8OZYvGQxtuExWubQXzL1CjUYOSKKXKmRXPPg3nnLrcKBanB7nFklDkdEvxRBuEmDvaxrdDgUO26lhhCAlFa9eOzTOiYUBOpAoYM4DghF7YSlC3ZFKgDiIk93XlLMHOdyVazIgGZYqIgTR1HizYr1dD9X/vRvhWdNjax24nYlkaHR9NXZJ60RdV2q5l7xi1IlFNmHubciAGkP0Aw98P7QEHJKpR/kFsAA0pqvKmYMAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by PH8PR11MB6998.namprd11.prod.outlook.com (2603:10b6:510:222::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 12:14:25 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 12:14:25 +0000
Date: Sun, 23 Aug 2026 20:14:15 +0800
From: kernel test robot <lkp@intel.com>
To: Meijing Zhao <zhaomeijing100@gmail.com>, Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
CC: <oe-kbuild-all@lists.linux.dev>, Linux Memory Management List
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Wandun Chen
	<chenwandun@lixiang.com>, Meijing Zhao <zhaomeijing@lixiang.com>
Subject: Re: [PATCH 2/2] mm: memblock: show all region flags in debugfs
Message-ID: <202608230255.AL6UNOZq-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260819075422.2387980-3-zhaomeijing100@gmail.com>
X-ClientProxiedBy: TPYP295CA0016.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::8)
 To SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|PH8PR11MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 37733273-2360-449b-5a83-08df01101262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 5L/VOoRCeqLKzxM522IO2ll4lavRrC9m/k3yfH47D817uqXriUSxkM9/sdlYNQPn4l4IG5dmJqtpYNeni42u5L7AOqU4aZ+casfPBGK8GbqhgN9hCTlKKFfNQMZS242z2APLSgqdAmRoZD3O+TM9D0A22AYFj82xpxEiXIQ5tQWgOXO81ycffTswvZTkv5pGBX18mbc/hg/j5y1ZskwS0BpIqweXfCfJzNDdJFhm0Ul+Gd1xR98KlWuGn5CXwdEPrVJQZrdQiaxeK7B14YUXfxRC6cD+9aCvvVQfqPiQ9IxrMF8WorqNGUuZ9B+VPl/6/nmNPKuX1TWK2yypD4cmsho+YI6nbGzA2bc2/hKDVVJCKFfIs8DnBv05hTZVCvWM1Rx98IBuTIUSuZoveDO2zQcVf3FC1o9c9GU4kt1SF51a9nHdWh4EpLfHnffZoClnfEZHvDpaTZgEU9Wy3iRxNxXhGFiGg/Bsfj5W+drlTA8/SKDBNo/gzP1mFNhvRXJb2hiH1JFQjPnoogOoln5JZrUvtf8KshXcN21TAPkXCwA5TZGrCWqpRsLnELrYpSQ+Nm494dNmLiPxLhuPMjO9PcbjVDaTwKydnds0qDIcgQGYZYY+mSZ8dMHxP/Hz/oym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iaaQW8l526GvEda7BWYSX34HrcKFnMUiAm/q0vdWWEwZPlILIz1u6sqtNCgE?=
 =?us-ascii?Q?8jeuVN8XSA8+N9PAZLemhRHgLBkChVYHrV5bHsb/27LhyNB+yuwhKBFSVaqb?=
 =?us-ascii?Q?2vyofAyHW+cHgNd7EKtVt3cSAbe5SX2yXNWnR/MZFQPz/KX1g2g5kTJkxv/W?=
 =?us-ascii?Q?ufk6nnC/MTIOQ+dXF4fvBjj3qUuFZ4Hmt7nC0B+nBnEBRBIAFRi4a0BUth5+?=
 =?us-ascii?Q?KLGPgXbRlWDe+AeKsqJe1cT5PA00HhbQ0xihlyOmdq7/u7Bvsl5F5NbnacCj?=
 =?us-ascii?Q?GHfXCdtyagqjC+0zibekjOZ6Zprkkj8o68maGlyIVx2lJjPiwOZ3fLOYv1Xp?=
 =?us-ascii?Q?f9WCHcMe2uvumXeSWK0Tu0/wPd4cdY/F6n2RKYVDJh+JteI8e/Gplleozcyl?=
 =?us-ascii?Q?OmucRdQ0k1govIuHUoyS3RA85iiRBy57c/QWVYOQ1tngEh8x9/E3bHVbWU4n?=
 =?us-ascii?Q?dCVIvQRRl/KJNzXxwRzP7g+fLD5uADsvyyjcguE8VifR7cupCJWhuJ2Z7fUd?=
 =?us-ascii?Q?aGuhDNxu8mJWELZuyUvuH/Gfkn9h/dTPLrw/q4/sXYFP52M6tdVLpfaMhNor?=
 =?us-ascii?Q?xa2dFVf/t4ay3LS8q56ivi6Q8Ctw+AHL7YoE34vc8Y8c8UFsrRZP24vAohkP?=
 =?us-ascii?Q?lSfS6j0dsVw3qYN1P9ZY/HXJq+Dx+rqUM6N65YsiYsQ4TO1T3K16QpdqF9Ag?=
 =?us-ascii?Q?NOYTLKZ9OrJXyYVyMiJ32rHE3+Cg12C5XcI5wBsEf6zAxhrb+ouMmgvuHNhV?=
 =?us-ascii?Q?0mBAMbdCNu3n+WU5GdMjLYaCLcq/V1ssTI7syWx0ZDLwGzwDko1zRajVfpLw?=
 =?us-ascii?Q?6GXlkMKwr/f+/mRjdxbVxYQLUuit+EhPSDSZtZGMZaxyr90S94qj/Q9RVvBI?=
 =?us-ascii?Q?jXnDw4VoizaRJpCwlKZHk9eIThCk0Q3A1L0b7w2Kww9AxtKJBDTPwp7ywhzT?=
 =?us-ascii?Q?4BacVJ7bZHOjQAyKcS/bh4OvgB2wVOuRqsfQYfwdSMnSyNtO/S75SlPQ4Xg5?=
 =?us-ascii?Q?FoE8UBOe0djvFqYQCFSpab7WqgQxjjdy0JZ9yX3CFq5mR0qWF8tRVkwv3OT8?=
 =?us-ascii?Q?jojDeDJXrEteyl0kblcfGIje8EUepaoqbpXLykurvOUuXE2mj518vZnamrLu?=
 =?us-ascii?Q?QTEA6Jucdp5l2wRwjx0txepRL92GNKv+xHaz3YVKOvYYDhEfVWaqjp6FywHm?=
 =?us-ascii?Q?3moke1nkKaldEhNc98NoQGdf5uO32HqdNLkd4MXDG43PQtCrZP4gc3yQ6Y7r?=
 =?us-ascii?Q?C5QnHd5Ri66wkFaQ1MP6LAwbHyIKAonyGBi8A9JmuR20Y4eBiT0NJ28YNPz+?=
 =?us-ascii?Q?w86QsqVXtvjJ3lGQr+lNxjbc7yQiZGHoGF/GdtOz/GSlVG4A/7nIs+rmJCVz?=
 =?us-ascii?Q?dxSgt1/2XYRDDEewguReE05g0HJxDpEhJEcWiHjL7Tpz7EhXWJ50jlO68p82?=
 =?us-ascii?Q?kYJ6goUXl77Larj01cOnPIVYK5YdpIMvAnhFaEbSj0Xn7HluOc7/cjpeNA68?=
 =?us-ascii?Q?aI6FqPQJdVto5Xv7+WbnWQewsA7jt4s2MU9tT03BQ77o3PjoXDtYDa7sns3D?=
 =?us-ascii?Q?KW9tYZgc7cf6DSIv9AWQFQ0Kh4vPQhHdrUEoLw48WWiftuAGshV9XfEqSsRE?=
 =?us-ascii?Q?RUirJT7ga/Oe8O1u3239Vi83OUDGfViBlmmNI5V89HXdYYpe4SjO9EY9eW5O?=
 =?us-ascii?Q?QBrW0zglHAhNdOxYr0g0P00r8g2kBeB2L0D2hbIkpnQh77nUrKs3jEY1jxlm?=
 =?us-ascii?Q?8YadV35wdA=3D=3D?=
X-Exchange-RoutingPolicyChecked: OAm3ulL0cBQiO2L+0VJC5Pbt8rS29t+kSLjW1RRHV+9r8aUyAIky+8z1KvqyfOxABclNQ5FnSGvqczBLE+yHBi/2eGEAEClnyOrlpMo3h5lnK+6SggrG2pMMOXzdoLAH916CDAoSaV4ZsIX53lMGsc518Zh3T9sbSXpuVy8ig8A4iAQsMxAYgkGYG5+FBUjWjDcyZ1MJBozwNMLyHajRapa5qC7hbkdM8gH36xhyYToDqGzz23ZwwesJEP6Ge5mOVFw+QLynmv3tldPKxIwkiBg358Nz9gpgRNx3b1kiW5qY+VGmdbeG4PDtbhNx2lpeg7xcIA+t1cqfB5B5w0BR0A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 37733273-2360-449b-5a83-08df01101262
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 12:14:25.1584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wap+MIvImXNG9NxbAQksaJeOlhleoLKhEjBtLAa9hDCeMLwb2HWzSweqGM6kQ7M6ifGQUrmLemHRRBIrculefQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6998
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: E3E8318000C
X-Rspamd-Server: rspam07
X-Stat-Signature: e1594phafozokrhbusq5grc3hzsuz9kf
X-HE-Tag: 1787487268-711299
X-HE-Meta: U2FsdGVkX18CBayy20puM+xZLh+YZMfiddflEyPWLMld7eo3G7EV/RIwbasaGEYazJVk8lTCnVbnv26O0+VR/R3WTPUoUJGUMZFoNn9Yqc1bglYKpuG3Sv4Fx5Q7mE4niDSpebHC87CITWs6+kFMd2/2nXI1aHNiymd4hX/ke1HfGmhIE/UvOJlj43OvLKMpTv95VDsnsSobZWXuYgTQjmsII8GUACmojZJFcqvb/3CCrOkqwfaX/Qd/xsHi+TWQp41RnMggrlXg3oYkvAARkFgSEPvSUrFJ7xt0Uq1Lh2UTrjiE0gJ/sCld9GKBW22dNObbyo3rDorclCiGXL/Dr93HE4bomPMlnBBCn9rg9q6BKSpU1EoJJ/Ea8yDlRih5EyIwfxBvXZJJbom9PEAeSHTdShe+c8Mz3WxX8urGUOZ3GrG3C4qAOsEDFgxiVxMwALd+mGY7bsccmxTGqU/HW3razJRBbR6fLDvgNdvvKzIpms89L3BThTUKVPFdaT7IDOTL+NiPBhqNcG8oQCQAVRi7D8l+2ZUz2rELMx+ViwfeHNqxvJtUy4Xoya8hpndPpudXAodbcQXtWyI+eTSJ9YjG16xqugizp3v7XOdqQjJY2F/skgQFUJALC+x8BaWACfGXZz3AGYNaGyQV1XfECrdn4C4H32rORnYG/i8EPRQ6HXisCh1q9PMXNmETdO86vvwOLk9goVMf5JyHovb5b+NNnSdHdupIR8wrSriBsNfopjhR0jSHhxU1kJSjM+TH5J2BRhnF/r+4c6MCyH2+jC1xlZ+zCx+dpf+D4d2Xcr3U4A+R4YesQjc8Xoi01PZ3NLYDxhkCPKGg9jo4UyH8G4yWU7Nn1sWpMk3gYVyvlELszgg7XqeLYyL1+belEBWYUBPAPGbJwtknD/XnMZiyAaePw5ri80d75Uo6O3J2+cO7QzrXcgZTDKnq3y9RApxh1Aww/9NGbmGz0CFd1Sk
 oiUv9oG5
 s0aHTU20aUwKsh01Pu0DFT6+qbrWhBZ294WyzQVcLfbzLhpkTvW1pHPHN+rP0/KMrlzNdo08D1/Opul3i/pUC7wbTJPW/+tNChiciS/5odDQtn5b9JyK9SZnwhD23Wh6MRjN53qS2h5yCHL7LPGqAlBpbZfLG6EggxvevwWX0YoTee48g/K7ba2VlST6aBlxWAkaKceOBl4rPpSrdI+gp1vSESCTbV8u5WTRl/AeKlQ6uie3zc6vkF3PoXhDhs43wzEkWDuqyUCgIR7ydK/5yffH6/RGvOSrba4K80mOiAHkwvF8xc6IB48NeYfR0u9OqtuQZjpLPgJXNjkFwt4Pvfz4DH9Xez25hi4pr0zIvV5Orc/uopCyn0t4naiuRCqkn+WqzGCfymhszdp53IK47wMMIVsS0Let/95cczXb1ETZaahl3XSz+YZkrJHkCwOSECdMSoGO4FxCG9DrGR+IaZWpAclk9cBK0jnk7G9Lcxg9pDDadjyZfWCvb86JHWJk823Vx4jdYwC3xlY51SXOuYcYQ+ZFQii7EJ9PkZOvd1RMJw06nPbNp88NIQgY1GvLu5/s6aQEzQ7zmk96/3JmwTgWznL//SCBZOrq0k6zosIYzUyluF5CsogWMaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Meijing,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Meijing-Zhao/mm-memblock-add-missing-HugeTLB-flag-name/20260819-155421
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260819075422.2387980-3-zhaomeijing100%40gmail.com
patch subject: [PATCH 2/2] mm: memblock: show all region flags in debugfs
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20260823/202608230255.AL6UNOZq-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260823/202608230255.AL6UNOZq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608230255.AL6UNOZq-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:25,
                    from mm/memblock.c:9:
>> mm/memblock.c:2805:16: error: 'MEMBLOCK_RSRV_HUGETLB' undeclared here (not in a function); did you mean 'MEMBLOCK_RSRV_KERN'?
    2805 |         [ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
         |                ^~~~~~~~~~~~~~~~~~~~~
   include/linux/log2.h:158:30: note: in definition of macro 'ilog2'
     158 |         __builtin_constant_p(n) ?       \
         |                              ^
>> include/linux/log2.h:157:1: error: array index in initializer not of integer type
     157 | ( \
         | ^
   mm/memblock.c:2805:10: note: in expansion of macro 'ilog2'
    2805 |         [ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
         |          ^~~~~
   include/linux/log2.h:157:1: note: (near initialization for 'flagname')
   mm/memblock.c:2805:10: note: in expansion of macro 'ilog2'
    2805 |         [ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
         |          ^~~~~


vim +2805 mm/memblock.c

  2794	
  2795	#ifdef CONFIG_DEBUG_FS
  2796	#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
  2797	static const char * const flagname[] = {
  2798		[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
  2799		[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
  2800		[ilog2(MEMBLOCK_NOMAP)] = "NOMAP",
  2801		[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
  2802		[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
  2803		[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
  2804		[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> 2805		[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
  2806	};
  2807	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

