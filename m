Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2865CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 06:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB178E0006; Mon,  8 Sep 2025 02:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABA98E0001; Mon,  8 Sep 2025 02:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C088E0006; Mon,  8 Sep 2025 02:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87E968E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:52:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 016A2C0A19
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:52:54 +0000 (UTC)
X-FDA: 83865165510.07.96CA6D0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68289140008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:52:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qtau6YTr;
	spf=pass (imf09.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757314371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RD548XasJSygk6TWGD8aCfopKsQ6z3VAuJLW52x9tHo=;
	b=4ChY93oIJz49kuZQlZxGS439r4arBvD7OY0ypOVmZW98u1KHBD2/6kkI7hEPyjJPPMer90
	QgJiGU8Ymdk22mZJwd1VyZz7VaI2pvRmacdr4fxCudU4JQStRxgsIt2G6HJfCTp20CVhJ2
	OtYvRXBBYOS5v8/ObBwGuB3foHWPJzA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qtau6YTr;
	spf=pass (imf09.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757314371; a=rsa-sha256;
	cv=fail;
	b=rceXjZOozHYg+BstmSD6I3gqJJV+hwjNpiO6z1ngiinAaEJnmFQaJUn+xXY+I3O9f45Tq/
	UBl74yXOOnp6p8wL1YmOHrjJf2kTk9q09YokF2RStsNnP9TYCfGAkEGUAw0Xlhzz8WMSdY
	UlBSbhA/2Dh/IPyWIpeTv4rfyimCg2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757314371; x=1788850371;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=4Eeqj2k1DIK0c3JHPAR/OsYQ4uYJDfFWYBlctf3rXWM=;
  b=Qtau6YTrlxaA8vfsKr+Kds3YCMQDKUMn/vq6vUfZdZXIkMmOx/6LaGqP
   1T/AtKd+6f62fONL5UpmClA9Rb3PnSPz6P5sySSh2+Mos32eolT9MmKpA
   Cs/hv7dH5L2+J7BaCfYFbgaKG9p1r4xWke9UGgIX2z4AcNlxz8dPwM6zo
   dScLH9AVHUMNzyHSJPR1/H9srWSLdVvr+Xl+gq8CnF01AI3D1XbwHBdRt
   xB9xOyCfJ6iqbEwJcFKsFGb/0+nDAIAC71ePCY4q33nj1WIeY3mdPBecJ
   Ju0KQdxiOzux1trbmMRGCto1tEvi5NjFLFSw0WH6SPLztszZ9ep5lByLW
   w==;
X-CSE-ConnectionGUID: owq7t3OTQI6x+3q66WLzYA==
X-CSE-MsgGUID: dJl1Fbj5REa/BKN7twmzWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11546"; a="58776797"
X-IronPort-AV: E=Sophos;i="6.18,247,1751266800"; 
   d="scan'208";a="58776797"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2025 23:52:38 -0700
X-CSE-ConnectionGUID: 7qQwCxi0TXi5Nj9l7y9+bQ==
X-CSE-MsgGUID: QbTrnxY0QdO+a8fNMbD0CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,247,1751266800"; 
   d="scan'208";a="209870849"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2025 23:52:37 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 7 Sep 2025 23:52:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 7 Sep 2025 23:52:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.54)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 7 Sep 2025 23:52:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VoO7Hvik5X1U07bY/5OfraApU7nys+nyPso5rXlzSHJDgwesjYDmI7umILoD/A7u6Vo5VN41qI43EK0SZCBRiOa3sdBw0oQcEuMTOhxfWB2lQds9daDVbjPR9W2+gsyKAWj0cWqX+bc3yFYsLH8aFMMB3kUEEXSliysRjrPYiDP5vu0HfbFZT5rkTODRxDYHnLR6Z5he8IPz8Wz0z3B0OfQaZXzscUkqtCVbDZ6osQDuYWA6IUA0a8bJ0nXaZf+bmX+SG9kAgZslSxueWHYeOHCoO3rsPQ0cEaB+f0yvVHZY2Ow0HYT8UDUjZE88bASVk2EW7G2+DYSlR1uY2FUUnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RD548XasJSygk6TWGD8aCfopKsQ6z3VAuJLW52x9tHo=;
 b=PRLbM2PFyyEGbhoOGg2fH5NkdAFftz4JbQKsFC0+f/dMvGujj0IYJFNCI4AMWizzx5hDrk3M4AoMJ0e+S128iux9LCzBANAjdn9jgElXThvK51YGTdV7sxNhnCkpoMN7BeXiJ2UdcXHB1NBdszx0k7OQb2OyjrWPfI/WP/KSOUFu9U3kfG9ftNPQZIKi9y1ml7WqLf1+xf+WAPoSrase1nzY+fbO/sqNV7pKNRVUrOeDjRr9CZEfXqv7c4D0U42nZpaaiSzRuffrkrEcE0JW6lDdSB9Yp4IBd3lj0ctdBBhW/fE9uQ/4PvUQDpoV5treHBfTFmnY9z8qi0qvYCcykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB5913.namprd11.prod.outlook.com (2603:10b6:510:137::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 06:52:32 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 06:52:31 +0000
Date: Mon, 8 Sep 2025 14:52:22 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Joey Pabalinas <joeypabalinas@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kees Cook <kees@kernel.org>, Joey Pabalinas
	<joeypabalinas@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] fork: simplify overcomplicated if conditions
Message-ID: <202509081409.2daadf50-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fb34b66-c0b4-42a7-716a-08ddeea448a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BcGMaKyDyE44ozEYt1Kl/9qfiag+kfEMtycF1bdg/9rI8pcljbjtjxEXwuuh?=
 =?us-ascii?Q?DbmFaTgTXL+ol0dA5b/Gldy1TY+PWp8Ir/NEKAy1jd05cKTs0k0gcf4jmcIN?=
 =?us-ascii?Q?XjbooZcJWWIMvqvni20hiBHLy1+PaybKRze0ZXyH7ymW70kLLDd28kF8duCe?=
 =?us-ascii?Q?7U5OzIcFEFjX/4bykcPO6IcP+LdqT5lmgKWEyPpFKxYnvQc8qFtSsXTio9Mw?=
 =?us-ascii?Q?56Puypo+XD9WcufrMVj3fViuFZguGI2zDQxbnTmb4co0WEX81G+qYRj1F/DZ?=
 =?us-ascii?Q?zizH85To0HKrtW864/9Oi3QfCmwJNZN3vjeELtQHgseer7ZLxjwqnD9PpiEb?=
 =?us-ascii?Q?RB687h9k+Pmm1oJXp7A5WY0hmI2lhRvZlY/T7AlDzXaeNyqgxh2wjMh80Pl1?=
 =?us-ascii?Q?vX7TVDMfk9xhBS8yAvzeKR/0GwFdX85CTaYQVQfYu++lTwzvglNysgta+t/5?=
 =?us-ascii?Q?k8H3laEkJ/uYFTSpDvMfrshq/qAN/dYnwbbpvj4rNvhMG7p2q/d1sIs1i3qT?=
 =?us-ascii?Q?bjIQCTZhIG8D7Tz8pIX4t8NvSI5QtqcRAHctiXam2zFwk226u+vfnWo+izb9?=
 =?us-ascii?Q?bxjsngS4J1cuPwC5QGRgn+oQq+fd/Ii/s+h8l07Z1AGCqvtjCDwI7jIrlf67?=
 =?us-ascii?Q?mw05TO2ffEbPtmH8L2Fuwxboc+qyB9WbbKgBsuaFMYRj4cJEcFZUy8gEZIrW?=
 =?us-ascii?Q?2qWIZdvP7iNozUx1NUYli3s1L3IAirbsMt8Ec4YE68NFWhQajcNuJfMo6tCY?=
 =?us-ascii?Q?aw0jmx3jRdGmc/y9vaDuvsjNty7CBJJvZU5bBWCAi9RNDyeQRatbEpQlulhn?=
 =?us-ascii?Q?WqskYpPFdzYOfxG9TMHly9WA5w7AzPmPmjzlgzani3zw39FOm8TRtqqA1gtp?=
 =?us-ascii?Q?0tN0H5bMMV1QgpDBiUdP2/BPC8X5ZqH4D+uVFzgjB+VRymLu8nFzMzPu9EBI?=
 =?us-ascii?Q?uKcyj3sWRGtxnJ9DkIO6x1hydzhevBQvQNwSP3VSyekbyyHQl2rHzYLArEHa?=
 =?us-ascii?Q?/EHrYieW8A6NV1xEB9eJH+QbGjnq5QM9xy7oohid9Dd4LepIRq2NjAns69dw?=
 =?us-ascii?Q?6/o8eJAAcCalJgPVKPxVNUxmCBFEHwpqpLSITHKTy2z1jxqeP4YOPPI6LLGY?=
 =?us-ascii?Q?jF0yFMOEcN9t/KcLBVD/GrJ5QT7bu87zPU2yRz/9IByk7W4rP4TIFkQy+LgT?=
 =?us-ascii?Q?hYhE5rglpXYJejRUrBkhnnVSKLZGwHEJDHESj3t1sFd36GItnPMR98cdDIrr?=
 =?us-ascii?Q?fdBmKtjsxkSy9X81MtJjUgkUXKFRAmqOQFlpE5tWmihpHTBvcK6HaPptj+Sr?=
 =?us-ascii?Q?jAkYWFaP2fLrrYJbHu49L8M/OQRHw8ePHwC3Z5GKO7dsHxf+9LakxieuqjRZ?=
 =?us-ascii?Q?f6bnk5Mh7BFsT5/V+BAUq8EAoe9R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?loxcXBTIC9QLheVG+1RuzOXaANS4ZbNzOPcjZTj+lxcoLT7ZjaceK6YYe34F?=
 =?us-ascii?Q?bBIvOxikfD0fM9IwYrrDcTnDZ3sNPTxooUZAVs4pfA3m4o2b/T3dXCC1PVAU?=
 =?us-ascii?Q?Vq+WWHevbs9Sbl1QtrHeKPIVCmgBPfSwcZzXwQBedUeYLJ+MkNJw5q4WzoRv?=
 =?us-ascii?Q?yFBFfK6vwnJUdS/WqKFvB+zO1dNa5szXvxlk0CMj4bXFZYp7eFpYDr+r/Qw6?=
 =?us-ascii?Q?j6kAre/aCXzuhts0ELSqtPezZojfyx53Did248bfHRhOv0VSxWuBVMoEkzuz?=
 =?us-ascii?Q?IlPvhY/4WJIPS7S8rv1jbJWVoIwlptVJG3SUYkj0KigewuknNGZNWnvDBomT?=
 =?us-ascii?Q?aBst4pFj67/3VEVJv7XLsrk76xs/L/lxVTJKnsGeJJZ+WcNU73E2ZtGIkZL8?=
 =?us-ascii?Q?XUZRIhISBLjw2DfwS+vGgLv7iV/ti8HQS9s00cVFuhYSEfQtDXh5QrpBgPA6?=
 =?us-ascii?Q?sTovONU+rUHzgJ8i1V4RcHwDOMB71uxLblohZq/SiP4pfVRNt+GCNvhapgOY?=
 =?us-ascii?Q?8KjO7W1i5I3mhEjv5e8mjpMgnjXPjFWtTjj30nzbMRHC4Dui6Q8Tagxsf+w5?=
 =?us-ascii?Q?JFkfP2e8vI0FvpNIVAqaLsk/x9sakjK38h2il28GQcAsELLeSLiUjBaITk9A?=
 =?us-ascii?Q?A4q0+vy9YiWUNx2xveQyH9/pBZ6OUcmvhz86kczNZox/xxLIr76Ia3bIt6mq?=
 =?us-ascii?Q?dq18V5Cw7ws6peO96RroRzEJheoD+lowFnNeNaJ1nKCPJKfkqL5X+zCM8tp4?=
 =?us-ascii?Q?FsfGaL2XGgVWoO4uqRttHQsd93qXhVkGr8Sqmvofs3pcRMgIOxmVwiM4k8T2?=
 =?us-ascii?Q?F9S+Z9qnPkxfE7ThYKW17029gq0K4tMmMDZHJKSy6v/qRh/8lV3srLXORhvZ?=
 =?us-ascii?Q?q9VXJcD0tRp+d2CpNMhk+TLC+870Ar//yQcS6dyC63OgxLya56UXCQKacgcX?=
 =?us-ascii?Q?ALqI8TmK+YCUwSA+aIQc2CQRYJEr3KHwxxR4LIdTEmCv+zaS09UTnkEYvSEE?=
 =?us-ascii?Q?StfI7/P9R2KqUuBoEipY8aVDAslj4SURxUz97zihr4LQWkyjlB2qU2qqQDzv?=
 =?us-ascii?Q?PaWNQYCvZWhdCEsrYVHgeeJy5ipp3BPyun4FLbxyqGn6yPoUN1iyVbZVkdQa?=
 =?us-ascii?Q?RKyjp5BglwoYfVRnqhIu6W/7owtsZE64Jcw/AsbcoXcqo7hKqaw1QEEjBfji?=
 =?us-ascii?Q?Pc26fbYHHd3vkb7Cb70IB+BpT4sNxEcQgdNAya18EAm3NDMHN8npbOKCTJza?=
 =?us-ascii?Q?hbfkYPx7tSRkUHYUofRvYf51QiIasIUdakqpWnYQf/m7uV1M9VS/J8SE9Txq?=
 =?us-ascii?Q?gJwNUOISS41WdGn8/APpFNXggyvRlniXfPVwPwYsCDiKbYFBzkk1D0AQMINS?=
 =?us-ascii?Q?ihTNPf6K6/T1v8rFHbx4ge0wXTJO+g/MrZCxfk8yXDlxT4e56j9bUjOWF9z4?=
 =?us-ascii?Q?QbC28+3jatFMzITDroSDgmuybzaG2jj3oGY/8LOki6eI7ZVlXiy22dzEUjpn?=
 =?us-ascii?Q?SbWH5mnS60EfavcksxSuKihv2QEmF1TTyrtQX8SBYmRcGQ/1rOipWUOoIMN3?=
 =?us-ascii?Q?v/53ks++lFSvYAksMfWS3lSAWxhew82DsV+zxiHw1SjTeMM9FMdmnpIvU4p0?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb34b66-c0b4-42a7-716a-08ddeea448a5
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 06:52:31.8292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVE2XpgjoKDOH/U2kyqTMhTv0HVlnZVASQ/Zkg1zcvnXAPWhzyFZLpkfRIgaT3QOfzK8FHAAusu2N3cSvFWJNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5913
X-OriginatorOrg: intel.com
X-Stat-Signature: nub8c9ea548fupaskp9688p67y6a35st
X-Rspam-User: 
X-Rspamd-Queue-Id: 68289140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1757314370-860371
X-HE-Meta: U2FsdGVkX18X6dcb9D2YAI0r/wj/VyH7kE6gzLQpx/A8jHl8IsIW0KnsPCSPTEFV/eOkhpcDkYD9DQQKO7YR8+tplymyhX0ggaH50VkW0LY+W4uGFrEYtQNlC2WtOCXqfC55DVjQradJ2BhT0UfwlKAoss30VaxzqB5vxO8k/FckQLfE6CgFiPTeYQlhl2RyHolMQtdGp1fw1V+7O/If3RcTx/IOcDzBK4G8XzfHnwPKK0Qot2biKFuoeAZdICSxLhCYcIi4q46obB9AWj42xpo60CDp8NJCxFO67xB3jmjEIFafVU3SCVB16D837FBsenTqayMHpYNd2UEAZLG4nIxpqjwOJ+X5xFnfApvmGbiBSOOkFlQXMWCN3eFfJYpKbUXWp0C0puIMDCaz5/Jcqr4C4t1bjiEwY9SNRYTROs4Kxrdrqg6s6M1UPc4vQZaQwVzxS+s+m3RV1W4iMI66bveCn+YEUtM9c6hu3v6/3dsPraEMNYN44J4oX9IsRMkoqi9t7gzZiA1Dc8O1tuHhyWkBWHwmjtZJfYdRDaV6Lm5y5woy+xiP9Kf6oTXqGS9pjOpiE4Isx0AobbB7chxm+TCJrsqLqtd2e3ZWGdLbKzLeXvgjratK8FQ6/E33rxX1Laegawym9aWrkh2T12RhxItZlyRtyNVsVCu+2dppV5yxJUsDgsOruMk4fidb/fA5MPAR9W41TaeNcJCaI44Mon1ZzQ6lilyLNiuIKf72XFfdcIDnlcK2FfyNRJIJpYus/ZHxLFcGLWlF1luGF5ycgxs8JIIU3UffKPjxZSn7gua98+1e0gPuWhHwKgyQXDmcGloFu/7fkdPqcHpGFF/WH3EKX4LFZb2Iq9WfUThHNh5C3fszqJLTGAuWx4Z4ajUkB1rT9QczRhcK0KAlgmATov9YDILo3QruQaF3efHyizfCLW/ZyPGbvTesb7KwPrQKZzea2BG+fI93cMhzgRj
 WqaNlsPF
 HW5pHRNtCMWC4WPgEMEclRGOP+xUiM8lkPz3ymzkul11jIQ9U1ZjlEsOfvcZUtq+b35X+JflZ2elR0JB2uj6Zkkw/Gr9cbaxD70B+QDRq53775kcW0vVfEs0Vbawr36cQCwOuzIT4wDMJkpiGEOrG3k1eyaUJ+gGls0LHj8PGKNxgR/062a8BlSkbl9gulMry3ouVkWITw5GTjvpeJFVMilyQrG14rVzbp8waSpfh3ZqO4gfzL5ytBWXP1zjuD4+k5B1qF4c4WWQf3m3rwo3a3GoE/F0txUeHwVQ2Um6IxAiVpIm0Xfw/vlX5rnfj/srDgykvtVqOnkBVxgnLjGR60O6CVhyzYt1meDHQ1CUCTIJ1vlAORjxrMqezqEEQ4/stKeBBc5ZNvv81AQMUPv4hpV5fmufOxdcrF2TrnIZCsdx/yDrXI+yxoq4rfGiall+NGhDlKqp6cVyBMnxtTMavDyWLt3lbNcfer8O6SXbbEOi3i+fE2wKVgQwOP1+cRnlc0Tz9Vzr1HADo5OL7x9YwMQqQsq2IQo03wdUGxSJE6+rMGvfgGNBdNjg1SC2W5SapRCLxVpR1Qvn2WBLqxZo/GXODJADwhzRC3n1gFCBQJXZKA09WsK679SApL6Bh4bZDqdeQ2ln73PJSLyuMGotdgiivRddUXVP7iYV1dvEMIy/TJh22CA58ayzRP7n/UXKuc8oqez5aoK676ArsRPZHNCiBMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: 62b2846e29a8bec933d0dd7a3a4ccc7af409d8d0 ("[PATCH] fork: simplify overcomplicated if conditions")
url: https://github.com/intel-lab-lkp/linux/commits/Joey-Pabalinas/fork-simplify-overcomplicated-if-conditions/20250904-144729
base: https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git for-next/execve
patch link: https://lore.kernel.org/all/357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com/
patch subject: [PATCH] fork: simplify overcomplicated if conditions

in testcase: boot

config: i386-randconfig-004-20250906
compiler: gcc-13
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | 8c94db0ae9 | 62b2846e29 |
+---------------------------------------------+------------+------------+
| boot_successes                              | 6          | 0          |
| boot_failures                               | 0          | 6          |
| BUG:kernel_NULL_pointer_dereference,address | 0          | 6          |
| Oops                                        | 0          | 6          |
| EIP:rest_init                               | 0          | 6          |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 6          |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509081409.2daadf50-lkp@intel.com


[    3.204615][    T0] BUG: kernel NULL pointer dereference, address: 00000020
[    3.205081][    T0] #PF: supervisor write access in kernel mode
[    3.205081][    T0] #PF: error_code(0x0002) - not-present page
[    3.205081][    T0] *pde = 00000000
[    3.205081][    T0] Oops: Oops: 0002 [#1] SMP
[    3.205081][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.17.0-rc2-00004-g62b2846e29a8 #1 PREEMPT(full)  cdac75d461890a0b0673a9c64f8f62c890a06589
[    3.205081][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 3.205081][ T0] EIP: rest_init (init/main.c:717) 
[ 3.205081][ T0] Code: 00 75 1b b9 b4 d6 a7 83 ba 4a 03 00 00 b8 9b d6 a7 83 c6 05 25 19 68 84 01 e8 80 c8 7f fe 89 d8 ba c0 ab f6 83 e8 e0 aa 7c fe <81> 48 20 00 00 00 04 64 8b 3d 18 20 8d 84 89 c6 89 fb 83 e3 1f 43
All code
========
   0:	00 75 1b             	add    %dh,0x1b(%rbp)
   3:	b9 b4 d6 a7 83       	mov    $0x83a7d6b4,%ecx
   8:	ba 4a 03 00 00       	mov    $0x34a,%edx
   d:	b8 9b d6 a7 83       	mov    $0x83a7d69b,%eax
  12:	c6 05 25 19 68 84 01 	movb   $0x1,-0x7b97e6db(%rip)        # 0xffffffff8468193e
  19:	e8 80 c8 7f fe       	call   0xfffffffffe7fc89e
  1e:	89 d8                	mov    %ebx,%eax
  20:	ba c0 ab f6 83       	mov    $0x83f6abc0,%edx
  25:	e8 e0 aa 7c fe       	call   0xfffffffffe7cab0a
  2a:*	81 48 20 00 00 00 04 	orl    $0x4000000,0x20(%rax)		<-- trapping instruction
  31:	64 8b 3d 18 20 8d 84 	mov    %fs:-0x7b72dfe8(%rip),%edi        # 0xffffffff848d2050
  38:	89 c6                	mov    %eax,%esi
  3a:	89 fb                	mov    %edi,%ebx
  3c:	83 e3 1f             	and    $0x1f,%ebx
  3f:	43                   	rex.XB

Code starting with the faulting instruction
===========================================
   0:	81 48 20 00 00 00 04 	orl    $0x4000000,0x20(%rax)
   7:	64 8b 3d 18 20 8d 84 	mov    %fs:-0x7b72dfe8(%rip),%edi        # 0xffffffff848d2026
   e:	89 c6                	mov    %eax,%esi
  10:	89 fb                	mov    %edi,%ebx
  12:	83 e3 1f             	and    $0x1f,%ebx
  15:	43                   	rex.XB
[    3.205081][    T0] EAX: 00000000 EBX: ffffffea ECX: 00000000 EDX: 00000000
[    3.205081][    T0] ESI: ee7fd750 EDI: ee7fd740 EBP: 83eebf80 ESP: 83eebf74
[    3.205081][    T0] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210246
[    3.205081][    T0] CR0: 80050033 CR2: 00000020 CR3: 04910000 CR4: 00040690
[    3.205081][    T0] Call Trace:
[ 3.205081][ T0] start_kernel (init/main.c:1335) 
[ 3.205081][ T0] i386_start_kernel (arch/x86/kernel/head32.c:129) 
[ 3.205081][ T0] startup_32_smp (arch/x86/kernel/head_32.S:290) 
[    3.205081][    T0] Modules linked in:
[    3.205081][    T0] CR2: 0000000000000020
[    3.205081][    T0] ---[ end trace 0000000000000000 ]---
[ 3.205081][ T0] EIP: rest_init (init/main.c:717) 
[ 3.205081][ T0] Code: 00 75 1b b9 b4 d6 a7 83 ba 4a 03 00 00 b8 9b d6 a7 83 c6 05 25 19 68 84 01 e8 80 c8 7f fe 89 d8 ba c0 ab f6 83 e8 e0 aa 7c fe <81> 48 20 00 00 00 04 64 8b 3d 18 20 8d 84 89 c6 89 fb 83 e3 1f 43
All code
========
   0:	00 75 1b             	add    %dh,0x1b(%rbp)
   3:	b9 b4 d6 a7 83       	mov    $0x83a7d6b4,%ecx
   8:	ba 4a 03 00 00       	mov    $0x34a,%edx
   d:	b8 9b d6 a7 83       	mov    $0x83a7d69b,%eax
  12:	c6 05 25 19 68 84 01 	movb   $0x1,-0x7b97e6db(%rip)        # 0xffffffff8468193e
  19:	e8 80 c8 7f fe       	call   0xfffffffffe7fc89e
  1e:	89 d8                	mov    %ebx,%eax
  20:	ba c0 ab f6 83       	mov    $0x83f6abc0,%edx
  25:	e8 e0 aa 7c fe       	call   0xfffffffffe7cab0a
  2a:*	81 48 20 00 00 00 04 	orl    $0x4000000,0x20(%rax)		<-- trapping instruction
  31:	64 8b 3d 18 20 8d 84 	mov    %fs:-0x7b72dfe8(%rip),%edi        # 0xffffffff848d2050
  38:	89 c6                	mov    %eax,%esi
  3a:	89 fb                	mov    %edi,%ebx
  3c:	83 e3 1f             	and    $0x1f,%ebx
  3f:	43                   	rex.XB

Code starting with the faulting instruction
===========================================
   0:	81 48 20 00 00 00 04 	orl    $0x4000000,0x20(%rax)
   7:	64 8b 3d 18 20 8d 84 	mov    %fs:-0x7b72dfe8(%rip),%edi        # 0xffffffff848d2026
   e:	89 c6                	mov    %eax,%esi
  10:	89 fb                	mov    %edi,%ebx
  12:	83 e3 1f             	and    $0x1f,%ebx
  15:	43                   	rex.XB


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250908/202509081409.2daadf50-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


