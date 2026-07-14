Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CC0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238CD6B0093; Tue, 14 Jul 2026 09:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E90C6B0095; Tue, 14 Jul 2026 09:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062BF6B00A2; Tue, 14 Jul 2026 09:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5B9C6B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:24:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26686C02DE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:24:21 +0000 (UTC)
X-FDA: 84987451122.18.978D0CB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id 873751C000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:24:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E8vEJ4PC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784035457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=82mRi5OZY76QnM07Zc/8ZqpibVK/MpX/Avb1M3sLfoc=;
	b=OLyCoqI4NrZTUMkszwkFOjYAT0fFNiEMC2XHiG3bgin6YEh4bCUzq7yBZk5dnUGwXHjOlT
	d0SLTwkIPK9+idL8/ZSYXMDT7qN9qJ6r6v9XUCi7eUjW+hrZfAAahIfvcl8hPntfVZzTw1
	d+92umI7PnWm1HkK0+9zfoEayOKWn8k=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E8vEJ4PC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784035457;
	b=vvIVqNuKI50JphrwX1wLYRNgL0s1wUG9HtDsHVUB904yUtCH9spFKuL1PSLx2XihjUNxvd
	/GEMhQtXYci07gQ6DG/i+2uAVL80MuMUlxzY3+aIUaY+o+RlaJxKyYsTK1XnZuESbi3d2i
	h8RTg1d3P3KBzFA5UGVrfI3y+F2MZhg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784035455; x=1815571455;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=c3DB/ZgCaMxVc0Kt/f4Y1GzBXfHdilBPzG9XFB8H42g=;
  b=E8vEJ4PCwnVXrCvKVzUVEzJO2qOs3L11xNS3Lnk1z1S8MtZeGunoWlvJ
   cdsDnDn87EqOXsju4dgEnqRYhf8JjgEY+kguyp1jWLSH5bcJczvKDYDLK
   GYslQUT3lxFMxT0qCR8bcyh5+96OYirr9bFBu84uQ/bHNTij5klXYDRzh
   yB0SkQMXUcmTHpLraSykP0av8W6yhBMqmbw9BKI/Wqz5DX8O2M+ObsS6Q
   +SOmuZU97rTKH4rujQaIaMV9CB07dWDXJ9hvULBb2XV62SgbkQkk75qmU
   EJ1nXJqa/0/yUYufx0rnnDCCWBRzaRJqsWB9lPqqS019ZNtWZS9H/nswc
   A==;
X-CSE-ConnectionGUID: /EeHGtcETb6zhb6sHegyVA==
X-CSE-MsgGUID: btkEKoxrT2KxpCs0f90Mzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84775619"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84775619"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:24:14 -0700
X-CSE-ConnectionGUID: jLJnAuZzQ4ylB3gLxblpcw==
X-CSE-MsgGUID: RpWOQLPaTQK2+wT/hgl3Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="259703069"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:24:14 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 06:24:13 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 06:24:13 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 06:24:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JhURp4dl5D+AhUEjMSF08XWVssgU8HMzU9tgc37bW+y9DnLoj+2Q2zV0kZ+MTJIY+W81AqDF7EBlILQNToohthOKw/5NhAKJ3LitIrWxgDumaAL2sesS3x8GhXIapmMM0y+g8kOQgZtmeEvSNKtPlTCeyAm7u/Y9bMWzLoyS86V0GbacsDc1TRnGaf4ClsaQy6PlcnOucapmQmnE+iC1rifpOzj/JMkOYx6vrj3f8xC4BRS+DcwEmlCbOqGeWbXY9p/cJ0h8zSqnTyAJfOwepn3dPWsxeApZ+9evQZVuj+JCHJxVX2gf+CQrJZyHtt9ceyIj/8ZFujGzRbzrz2yoAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftVDJ/YKkmYMiWg5Nu2OhCYRL7o/S7xJ5NFfWMxdOhE=;
 b=jWsyc+97Knmw7DZdkLxLu94vYlsnczWCVym5Mc+pMxH4zGvRdr2w0CgUB76lKzxJ8f6DMCt5xNk8o9CJr/TxEJsF2qCer2UYdCURTnMaaPN3Fpg1QFKDQAljk0XlJH7+TBSPYVpwV3hwEltf5W3Qz62VeWqsZJxSobLu9eT2T0JL5yESj5QQFJRenS/tV2Ih6JW4L9PCBLADTssJBvcTttoUr+PtCwdRl631Oa6Ladkhw55OcQeLHfX4x4U6RK+3w5Ae1ZwtfKms5VLc7AFoGkWA8uERWu4Tjga4ATFydl7ezn3oCHSEkM7Uz49v1/5uG/6WD/5USM6etaIdQiQRCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
 by IA1PR11MB7822.namprd11.prod.outlook.com (2603:10b6:208:3f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 13:24:09 +0000
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7]) by SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7%3]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 13:24:08 +0000
Date: Tue, 14 Jul 2026 21:24:02 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Hao Li <hao.li@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm/slub]  0fc52deec1:
 stress-ng.pagemove.page_remaps_per_sec 8.1% improvement
Message-ID: <202607141635.962dbf6-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0041.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::7)
 To SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5815:EE_|IA1PR11MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 4693d976-908f-4ec6-431d-08dee1ab2f63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|3023799007|56012099006|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info: 6osjZrnoLykOLrGSQqchaTMe1AXT3zjIcnzOZCikVAMrSp5kdPHOJj9C7pLKirJNrubuV7pF8Ky68FvwsOIs5+QBX8jqXy1sqAvFMU+XtfvN91FrxSb/rxE4HNTQ/AQL8NXkJWTAjWL3gmbAN9DvvhVFEhT8hZBMS1D2PEBVoND7exnch1mKEJTpRtZVJLEROvHTOQVAcu4YPQjtW5K+o0MBIA/8sieVPSwpw2ksEZ+nYX5X0L6WxfzJhvHVjP/Hr54vGzFXATUSOMpsqFVXHvNw3QaizbOXMNbKxJhgQi9W8smwQx+Wrac7NLdoj3HjLzocE80N+ByXz/Mttkk3wUwCYVKa5g/DvwWZLHR/LKR0HZndhzsIV24AM9+dVV+pdz/mw2xcwFPL4vZFRh+QCziQfavag2gxyomWI7QZ4f0GC/pOz5NReb8qZvB8xonszbTPEU/a8zHf7kkCKsKSxszVzBVMntPshvdfETbS/j+Ubh/8VRHGSIoNPd2W9VPDFzBd8oReLJwG6y4p9/bk9MSBIDG5cHItN3XhIw9LF8SghfLcywzazN1u7fLlII1Noft6btABV0ghFO/lvOOKZoP8mbPjI4N0K1jHoHlcdFZcv6jJdUsVDPU4diQquYh8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5815.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(3023799007)(56012099006)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/HO71K5pfIppUqr6k1aCafUxaIfizQKyMbo9jiCvx3BVprFv2ouTrWek4s?=
 =?iso-8859-1?Q?7vw2K0cFoLhtmcXVd+PPCU+2NVzrsbKWcjDtuX9QGCEl23TSdbbMj+mRAg?=
 =?iso-8859-1?Q?tr0X8DEacTPtO0cZsasAdHiP22Zhr1SMaLAYy1vYsHEQPID8sirsrV1Y+A?=
 =?iso-8859-1?Q?7thre+WWn2aNmWGavgN+Vzu5TH7DFfi7tPLKyF9mCYGDXudhqmRWN47Zqd?=
 =?iso-8859-1?Q?znPUdfpYAurnmB4SkObJmpzrzVavZ137L5xUfJijckUF9jSv3gyp8Io1it?=
 =?iso-8859-1?Q?WmcyRnsLuot4Az4DJPTpfUL2sWArgi7dkYy2pGVIzxKLVg4yww/2Jun6rt?=
 =?iso-8859-1?Q?PlWqFX2SibB0EDYdt8LjBnE/UUU6aWlJM1qHJ1qJqxQan7Bx0iyWVRRHi0?=
 =?iso-8859-1?Q?x7kBilhGFVuunFRu6Ge3pgV5gwVc0XeM39bcbYA0o+ExEODA5GPjuY0U6d?=
 =?iso-8859-1?Q?z6Jm7ht0QQL7VWWbXC2EaMjOP+iCCjRjZoNsDmoDqndC6hqZKcupM5TZ9Z?=
 =?iso-8859-1?Q?PSTUrHJSDzzKuln8nx7r6zAlo1ixZIvClVor0FLuq6M4Y0L2fQdW4hZsW9?=
 =?iso-8859-1?Q?FIvl08C8Ijct92XWnmY1yw6BTRzi3JUhxQxFQent3DoM+0i6bXLJ8UhKKr?=
 =?iso-8859-1?Q?QrzBxl8+c+uxCcMRHW8XHEk6nG4ZrjRHOfIO2h/YvXtI3P5dXtEoiGdPs4?=
 =?iso-8859-1?Q?U+5sbgXOTwDZ4CbPsXrMkBErxpti8fyt96ZQ6BGi9GTfunXT7MFPFjcat1?=
 =?iso-8859-1?Q?7KLU66ztgXxHUNlOFPbJeIG8MebdSblqEw4Pwi+pgQ3h6+IICWmGlxspXw?=
 =?iso-8859-1?Q?2+5abNLlYM/ZO12FdE50ZtMduETyDz34W/5yL7kUOAD4uQ6AVJ0m4XmOxd?=
 =?iso-8859-1?Q?zUuAGP9RYHBYgFrj9RoG0YkQNQVErr4iHq71gj+HoCQDFxsidvkXfTBteu?=
 =?iso-8859-1?Q?fwIyGMOXnKAVp1EUSiN2JtgY/8oFHOIVHAgisLgKzNn5YBkCOKX6BDOsdB?=
 =?iso-8859-1?Q?cTYrWCPl3CFReGKzoZfL37kE8itrLgIGnT7HJLt3G6p81mxUFGElthtGjB?=
 =?iso-8859-1?Q?r19gVR21MTYC20At3WHo711CLhiTiZJHl767VxVGp4gBWcGq0Juz2Xqdkv?=
 =?iso-8859-1?Q?BpLo2emMZ+xvAJFLx1GfkQ9UlEKiJ9CVhBECCcVGFeCLtWUb6mPXICIFQL?=
 =?iso-8859-1?Q?xEnpi5BYqtZe4VKbESpxmp+cP7rTWMwkTVe3yAziQrRKF109i6KkpbsB55?=
 =?iso-8859-1?Q?vmtqbPwygs0iBL7goHhqxz3UxbFyfO1ND7ruOUqFwevSXfPdqO9ot1uoxA?=
 =?iso-8859-1?Q?AksOKCjXTAXU1T7EzamPGV9XnOq9KEtPUWP3CUvnByrWCYwLdAbMYOgFCo?=
 =?iso-8859-1?Q?cLUSO/RB6tnRs1qxqyhOanpsWzNy+mnWXwTpjcQorAE914XTkfuXHo58oG?=
 =?iso-8859-1?Q?dLlh0xcevLqTeUi56DvJk5v7G/hdhebdvZ0EEDpEGQVfXlqZitx+mAdMRz?=
 =?iso-8859-1?Q?VbTrObMEfOWpwmr6XGYbMzaC7MnLp+HmyBofVV3uayhnKHrqgNXHxEZgBn?=
 =?iso-8859-1?Q?oOHlSyXdzA9JEoKKSKrBiZBF+ss98A3UmGe0DyQ5k2BJ7VYD431byI0hda?=
 =?iso-8859-1?Q?fM1Tb5ynAAIz49fgdDW+Ck3dWTMj4o2Z2iwxJtAlLWkknfcAnTmkLAgy61?=
 =?iso-8859-1?Q?jR5XVzngeiMxRP5m4SPZuGx4BAqfTtGRBaXj+6kXSK1PK1K9A4NR2rqbim?=
 =?iso-8859-1?Q?bu37z4gZGqUFGrCXZxdY1OBfy4hnvTuzFT4sWh5m1mQVOyAmDX6TZymDe3?=
 =?iso-8859-1?Q?YcK8tuQYAw=3D=3D?=
X-Exchange-RoutingPolicyChecked: OgmsMtrzY+W5tOc4wFDFMUu83LRq4kzZlh0hw5WoNz/VdsJlze3gsuubn5OvBZQKt7l46dqkW05YJtUAjBQELKao2hgCLOXAuVlRQEb1Jsd2/n5gY5vwTmEajLzgV2E2cXkjQWwRtux1FskUpcJmUNW2HYblxnSwH0IuROcicjOI1yOAl0iRfUtugBgnDbMWChFUK/FmJcSFP/Yd6uG5r52FJiG7xz1ZQXXnQ5wozMsHW5HtFQcZLuMHAzQGL0PHQn/WQ3sBooGsnblUMc0z9AOXw64vKZ46HBCgXXul/K4VoNpK9flZIb9ZaR29lhd+986NW/khbynIy87wHACoAQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4693d976-908f-4ec6-431d-08dee1ab2f63
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5815.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 13:24:08.8690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJ7vMKeeXxnUY55rVrqKwJ222gRJr049flakM20Lad0fIVS4/Tm9SHtwIhWApgDJMots8CxAQI8IRCGyvD+9zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7822
X-OriginatorOrg: intel.com
X-Stat-Signature: c8q8cihjs6aa34mup58xygd55harwo8c
X-Rspamd-Queue-Id: 873751C000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784035455-752368
X-HE-Meta: U2FsdGVkX18hhoULHQ1cVal+R4fajBraswhasLSvKiq9a29tkhk4x4U+p8uILm2v1GHpQek35h8YQa4F2uV5V/U29acE+d9ERbt/zQ/8mD0eem2iGCD7b/1RelbGCTQiRN4zKrTm5FmslUhxwvNqrHqDHHq9f05+QwqtPBcdze3wB8T/O/BLXWEoaz4RdTjsHiWwaqPzHTJAD6p7DEwQRiZFGvy/2RE3Z9C+pCmYPzRXI93+EoH096uIwJWPLv9k9cAzsADlnDVgWbrPN5egWk0AbL6BZt8N2d+sWZBoxr8I5NQ7tVr3C1c5wfFq5iLBWNfVNs7fxwBWlQCYW+FvPIc0o2JaLgI5aBiAPUIVLzW9xNBBABnV9DRi2Jtd5NZRwg6oPwyAxHn20bK5Nx7HjZlaNKkHMDtqPhZ1llaCkB9wL/1Lz8LhfYsg0wqpqF2Ep+IwrwCKEGGJGz3ga0Ded5earCBzJrmKyjfq/VvwmHhfXO7MuFkfC1n5Id92Tpqa1DyzR+VM4FFWPRkPr6MCKakagH5QtxGzeHma+fYAaj/jkySMbqrmD8J3rlZpL6LeReRc+KoBXj3ZDOsU98G2UOnLq1ObC2GTatSW1yxquk4ZZoxhMA6XO4XtX3mvtzKo6j82biph3Haq+yOueyvrN/IuNr4micIf8MDMxHLrWe1h584ydwIIMbso9MlRnWkJoyzZmDsbH0dQG6qfj9vuAyp4ImqUiwKZ6jS+tXypavTh+n8D6YpgRBQ+UYfqJVR+rTQ1jz5G4apoWHJrD0Yp+8kUuHQ6N1I/18eca4+z5gJOt3ady1d6szVV8gZSS9o2mVu9D6hqhKIeaGXOrseCj7odaQAEZDvY+1jAyrU8IJFGZ5XM323/9G9Y68+sfFBqSHCvYMwkQTliN45XdOe3TB0wBvF/nn/2X9q5BRfxx4lOLJhusjskK4hQ3qNLyOtdie+6CsUsYFv5/i/avbE
 /KEIeHuJ
 qyB9EtOdCCMLV8WYvn4+CZJVzFewbyM4cPSPUq68VMiXfPpO2tJahoWMHTS4D6vhT4yFLvupB2IaerfyFK6prTdjAjTlZ+pf8X5Vlm7QScFsJX0IrFjupnQhDBuBTpd5WPVYPtBI1y8W8/YaNju80CqULaOMqBX/sL0fa7G5YqZN/OFsdTdZEbGAuvuoYkClmyiTPlx43DDITqYT3mtOmpue/3uV66zAXiMY2Ts5eEh+tHn9v3QB/U0JPjr0gXuSwOTBs+dbxYWMdLJm/WgnNVedu9P022+YmvJaP8vR2VEjT2PlpTqcZx4AUHL7XcA+MQ8+xxaxAQ3AQOuCk6D8eQtqrLAkw/BY9u7VVjX201EpTCWRibpIRV6mdVNUZpzNNpdX0weDYcAnchswI4DLXZes6Fw7TPOG7qUT/hUfHuEI1VAIqHi2Bqo3VZpABjbsY1Fr6gl1rx730r2zeQ36LcVS0vYdDTGrQNIKqrAXbm1ylcn8mSnJerxfyH3Vu9M9HOOeJ9RbrNt8R1wy0eDP/s1H5aIN4dtjBGa1icja2C4mp6eGLcnxIh7K+9D4u20jjaIzm2bFyxQaiSBa+qsdLI/Kwq09WYT2dyt/6H0pyG2EJfvm3hO/ogPFy31/R6uQt4h0GlWS/v07KkCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 8.1% improvement of stress-ng.pagemove.page_remaps_per_sec on:


commit: 0fc52deec1068ea3cc8eaa6e045c96fbf73f20e2 ("mm/slub: detach and reattach partial slabs in batch")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: pagemove
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+---------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops 6.5% improvement |
| test parameters  | cpufreq_governor=performance                                  |
|                  | mode=process                                                  |
|                  | nr_task=100%                                                  |
|                  | test=mmap2                                                    |
+------------------+---------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops 6.9% improvement |
| test parameters  | cpufreq_governor=performance                                  |
|                  | mode=process                                                  |
|                  | nr_task=100%                                                  |
|                  | test=mmap1                                                    |
+------------------+---------------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260714/202607141635.962dbf6-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/pagemove/stress-ng/60s

commit: 
  7e23073874 ("mm/slub: introduce helpers for node partial slab state")
  0fc52deec1 ("mm/slub: detach and reattach partial slabs in batch")

7e230738746ce9a7 0fc52deec1068ea3cc8eaa6e045 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  70342530            +6.9%   75221222        stress-ng.pagemove.ops
   1173310            +6.9%    1254602        stress-ng.pagemove.ops_per_sec
    272867            +8.1%     295033        stress-ng.pagemove.page_remaps_per_sec
    582290           +34.6%     784039        stress-ng.time.involuntary_context_switches
     16621            -1.4%      16383        stress-ng.time.percent_of_cpu_this_job_got
      9785            -1.8%       9612        stress-ng.time.system_time
    204.30 ±  2%     +14.7%     234.32 ±  2%  stress-ng.time.user_time
     60390 ±  3%      +8.9%      65782 ±  3%  cpuidle..usage
     19250           +33.0%      25597        vmstat.system.cs
    865538            +8.1%     935886        meminfo.SUnreclaim
    701990 ± 21%     -21.9%     548537 ± 10%  meminfo.Shmem
   1008091            +7.0%    1078157        meminfo.Slab
      0.19            +0.0        0.22        mpstat.cpu.all.irq%
     11.88            +1.1       12.93        mpstat.cpu.all.soft%
      1.94            +0.2        2.11 ±  3%  mpstat.cpu.all.usr%
    844506 ±156%    +169.4%    2275081 ± 75%  numa-meminfo.node0.FilePages
    409429 ± 15%     +21.6%     498064 ± 15%  numa-meminfo.node0.SUnreclaim
     95006 ±143%    +237.1%     320291 ± 34%  numa-meminfo.node1.AnonHugePages
    896456 ±  9%     -45.6%     487965 ±  4%  numa-numastat.node0.local_node
   1030690 ± 10%     -44.2%     574831 ±  9%  numa-numastat.node0.numa_hit
   1345616 ±  9%     -41.0%     793920 ±  8%  numa-numastat.node1.local_node
   1410929 ±  9%     -35.7%     907067 ± 13%  numa-numastat.node1.numa_hit
     19636           +34.3%      26381        perf-stat.i.context-switches
    410.01            -7.0%     381.50        perf-stat.i.cpu-migrations
     19282           +34.5%      25929        perf-stat.ps.context-switches
    401.96            -6.9%     374.03        perf-stat.ps.cpu-migrations
      0.22 ±  9%     +15.2%       0.26 ±  9%  sched_debug.cfs_rq:/.h_nr_queued.stddev
    187.42 ± 90%    +166.6%     499.67 ±  6%  sched_debug.cfs_rq:/.load_avg.min
      0.00 ± 10%     +53.0%       0.00 ±  8%  sched_debug.cpu.next_balance.stddev
      4921 ±  5%     +15.8%       5699 ±  2%  sched_debug.cpu.nr_switches.avg
      2954 ±  8%     +34.7%       3978 ± 12%  sched_debug.cpu.nr_switches.min
    211170 ±156%    +169.3%     568705 ± 75%  numa-vmstat.node0.nr_file_pages
    102318 ± 15%     +21.8%     124604 ± 15%  numa-vmstat.node0.nr_slab_unreclaimable
   1031040 ± 10%     -44.3%     574682 ±  9%  numa-vmstat.node0.numa_hit
    896806 ±  9%     -45.6%     487816 ±  5%  numa-vmstat.node0.numa_local
     46.40 ±143%    +237.1%     156.43 ± 34%  numa-vmstat.node1.nr_anon_transparent_hugepages
   1411107 ±  9%     -35.9%     905096 ± 13%  numa-vmstat.node1.numa_hit
   1345794 ±  9%     -41.2%     791950 ±  8%  numa-vmstat.node1.numa_local
   1198383 ±  3%      -3.2%    1159953        proc-vmstat.nr_file_pages
    175636 ± 21%     -21.9%     137207 ± 10%  proc-vmstat.nr_shmem
    216218            +8.2%     233963        proc-vmstat.nr_slab_unreclaimable
   2443814 ±  6%     -39.3%    1484396 ±  5%  proc-vmstat.numa_hit
   2244265 ±  6%     -42.8%    1284384 ±  5%  proc-vmstat.numa_local
   6235118 ±  5%     -55.0%    2807449 ±  6%  proc-vmstat.pgalloc_normal
   5591656 ±  3%     -61.5%    2154838 ±  8%  proc-vmstat.pgfree
      0.27           +23.2%       0.34 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.27           +23.2%       0.34 ±  2%  perf-sched.total_sch_delay.average.ms
     29.43           -26.6%      21.59        perf-sched.total_wait_and_delay.average.ms
     96746 ±  3%     +34.5%     130085        perf-sched.total_wait_and_delay.count.ms
      4592 ±  3%      -7.3%       4257        perf-sched.total_wait_and_delay.max.ms
     29.16           -27.1%      21.25        perf-sched.total_wait_time.average.ms
      4592 ±  3%      -7.3%       4257        perf-sched.total_wait_time.max.ms
     29.43           -26.6%      21.59        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     96746 ±  3%     +34.5%     130085        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      4592 ±  3%      -7.3%       4257        perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     29.16           -27.1%      21.25        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4592 ±  3%      -7.3%       4257        perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit: 
  7e23073874 ("mm/slub: introduce helpers for node partial slab state")
  0fc52deec1 ("mm/slub: detach and reattach partial slabs in batch")

7e230738746ce9a7 0fc52deec1068ea3cc8eaa6e045 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  35782436            +6.5%   38114764        will-it-scale.192.processes
    186366            +6.5%     198513        will-it-scale.per_process_ops
  35782436            +6.5%   38114764        will-it-scale.workload
 5.148e+08 ±  4%      -7.0%  4.789e+08        cpuidle..time
    794321            +6.2%     843755        meminfo.SUnreclaim
    945453            +5.3%     995121        meminfo.Slab
     20978 ±  2%     +33.9%      28097        vmstat.system.cs
    256601            +2.3%     262434        vmstat.system.in
      0.14            +0.0        0.15        mpstat.cpu.all.irq%
     16.90            +1.9       18.85        mpstat.cpu.all.soft%
      1.80 ±  3%      +0.2        1.98 ±  2%  mpstat.cpu.all.usr%
   4401116 ±  6%     -56.9%    1897324 ±  2%  numa-numastat.node0.local_node
   4504175 ±  6%     -54.9%    2029341 ±  2%  numa-numastat.node0.numa_hit
   5629560 ±  6%     -45.3%    3080499 ±  2%  numa-numastat.node1.local_node
   5726620 ±  5%     -45.0%    3148207 ±  2%  numa-numastat.node1.numa_hit
   4504314 ±  6%     -55.0%    2028792 ±  2%  numa-vmstat.node0.numa_hit
   4401255 ±  6%     -56.9%    1896776 ±  2%  numa-vmstat.node0.numa_local
   5726830 ±  5%     -45.0%    3147938 ±  2%  numa-vmstat.node1.numa_hit
   5629768 ±  6%     -45.3%    3080233 ±  2%  numa-vmstat.node1.numa_local
      1399 ± 58%    +183.3%       3963 ± 22%  perf-c2c.DRAM.local
    226.67 ± 61%    +132.4%     526.83 ± 14%  perf-c2c.DRAM.remote
     50692 ± 54%     +79.9%      91219 ±  9%  perf-c2c.HITM.local
     50697 ± 54%     +79.9%      91228 ±  9%  perf-c2c.HITM.total
     21068           +34.0%      28231        perf-stat.i.context-switches
    270.68            +2.2%     276.54        perf-stat.i.cpu-migrations
     20949 ±  2%     +34.1%      28083 ±  2%  perf-stat.ps.context-switches
    267.72            +2.0%     272.98        perf-stat.ps.cpu-migrations
    198268            +6.4%     211004        proc-vmstat.nr_slab_unreclaimable
  10234916 ±  5%     -49.4%    5180699 ±  2%  proc-vmstat.numa_hit
  10034795 ±  5%     -50.4%    4980977 ±  2%  proc-vmstat.numa_local
  33957271 ±  6%     -59.5%   13761981 ±  2%  proc-vmstat.pgalloc_normal
  32552299 ±  6%     -62.0%   12377664 ±  2%  proc-vmstat.pgfree
  20120469 ±  5%     -10.6%   17993595 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.22 ±  3%     +11.2%       0.25 ±  6%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.22 ±  3%      +8.8%       0.24 ±  7%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    631057 ± 10%     +58.4%     999906 ± 24%  sched_debug.cfs_rq:/.left_deadline.avg
   3566705 ±  5%     +27.4%    4544203 ± 13%  sched_debug.cfs_rq:/.left_deadline.stddev
    631051 ± 10%     +58.4%     999897 ± 24%  sched_debug.cfs_rq:/.left_vruntime.avg
   3566674 ±  5%     +27.4%    4544161 ± 13%  sched_debug.cfs_rq:/.left_vruntime.stddev
     28545 ± 17%     +51.1%      43134 ± 22%  sched_debug.cfs_rq:/.load.avg
    132932 ±  9%     +32.8%     176498 ± 15%  sched_debug.cfs_rq:/.load.stddev
      6.28 ± 16%     +86.7%      11.72 ± 13%  sched_debug.cfs_rq:/.load_avg.min
      0.16 ±  8%     +24.8%       0.20 ± 12%  sched_debug.cfs_rq:/.nr_queued.stddev
    631051 ± 10%     +58.4%     999897 ± 24%  sched_debug.cfs_rq:/.right_vruntime.avg
   3566675 ±  5%     +27.4%    4544162 ± 13%  sched_debug.cfs_rq:/.right_vruntime.stddev
-3.866e+11          +214.3% -1.215e+12        sched_debug.cfs_rq:/.sum_w_vruntime.min
 2.244e+11 ± 12%     +53.5%  3.446e+11 ± 24%  sched_debug.cfs_rq:/.sum_w_vruntime.stddev
      4507 ± 47%    +108.9%       9415 ± 46%  sched_debug.cfs_rq:/.sum_weight.avg
  20120455 ±  5%     -10.6%   17993579 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.min
    672.57 ±  6%     +19.2%     801.68 ±  9%  sched_debug.cpu.clock_task.stddev
      1233 ±  8%     +20.0%       1479 ± 12%  sched_debug.cpu.curr->pid.stddev
      0.23 ±  3%     +11.9%       0.25 ±  6%  sched_debug.cpu.nr_running.stddev
     18196           +30.3%      23717 ±  2%  sched_debug.cpu.nr_switches.avg
     14757 ±  2%     +40.6%      20752 ±  2%  sched_debug.cpu.nr_switches.min
      1.14 ±177%    +435.9%       6.13 ± 13%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.43 ±  4%     +29.7%       0.56 ±  2%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.43 ±  4%     +29.6%       0.56 ±  2%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.45 ±  7%     +24.9%       0.57 ±  4%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap
      0.44 ±  6%     +28.4%       0.57 ±  2%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.__munmap
      0.41 ±  6%     +35.6%       0.56 ±  5%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.testcase
      0.21 ± 45%     +95.0%       0.41 ± 17%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.__munmap
      0.31 ±  5%     +23.6%       0.38 ±  4%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.02 ±142%   +1335.9%       0.31 ± 83%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.irqentry_exit
      0.19 ±136%    +256.8%       0.69 ± 82%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ksm_vma_flags
      0.51 ± 31%     -63.4%       0.19 ± 72%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_vm_enough_memory_mm
      0.09 ±179%   +1075.0%       1.04 ±125%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.30 ± 14%     +48.4%       0.45 ± 19%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.perf_iterate_sb.constprop.0
      2.27 ±178%    +438.9%      12.25 ± 13%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      1.08 ± 29%     +75.3%       1.89 ± 34%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.munmap@plt
      0.02 ±142%   +2008.6%       0.45 ± 78%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.irqentry_exit
      0.30 ±137%    +207.8%       0.91 ± 59%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ksm_vma_flags
      0.81 ± 44%     +53.0%       1.25 ± 21%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.memcpy_toio
      1.37 ± 32%     -65.3%       0.48 ± 71%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_vm_enough_memory_mm
      0.16 ±162%    +761.1%       1.39 ± 87%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.81 ± 75%    +182.0%       2.27 ± 35%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.fget.ksys_mmap_pgoff.do_syscall_64
      0.22 ±  4%     +27.9%       0.28 ±  2%  perf-sched.total_sch_delay.average.ms
     28.10           -25.4%      20.96        perf-sched.total_wait_and_delay.average.ms
    103626           +33.9%     138794        perf-sched.total_wait_and_delay.count.ms
     27.88           -25.8%      20.68        perf-sched.total_wait_time.average.ms
      0.86 ±  4%     +29.7%       1.12 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.87 ±  4%     +29.6%       1.13 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      3.10            +4.8%       3.25        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
     40.30           -27.9%      29.04        perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     22983 ±  3%     +31.6%      30242 ±  2%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     21521 ±  3%     +42.6%      30683 ±  4%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     46708           +37.9%      64415        perf-sched.wait_and_delay.count.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.43 ±  4%     +29.7%       0.56 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.43 ±  4%     +29.6%       0.56 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.45 ±  7%     +24.9%       0.57 ±  4%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.__mmap
      0.44 ±  6%     +28.4%       0.57 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.__munmap
      0.41 ±  6%     +35.6%       0.56 ±  5%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.testcase
      0.21 ± 45%     +95.0%       0.41 ± 17%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.__munmap
      0.02 ±142%    +975.8%       0.23 ±114%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.irqentry_exit
      0.19 ±136%    +256.8%       0.69 ± 82%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ksm_vma_flags
      0.51 ± 31%     -63.4%       0.19 ± 72%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_vm_enough_memory_mm
      0.09 ±179%   +1075.0%       1.04 ±125%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.30 ± 14%     +48.3%       0.45 ± 19%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.perf_iterate_sb.constprop.0
      3.08            +4.8%       3.23        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
     40.28           -28.0%      29.02        perf-sched.wait_time.avg.ms.perf_trace_sched_switch.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1.08 ± 29%     +75.3%       1.89 ± 34%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_apic_timer_interrupt.munmap@plt
      0.02 ±142%   +1318.0%       0.30 ±102%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.irqentry_exit
      0.30 ±137%    +207.8%       0.91 ± 59%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ksm_vma_flags
      1.37 ± 32%     -65.3%       0.48 ± 71%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.security_vm_enough_memory_mm
      0.16 ±162%    +761.1%       1.39 ± 87%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.unmap_vmas
      0.81 ± 75%    +182.0%       2.27 ± 35%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.fget.ksys_mmap_pgoff.do_syscall_64
     31.76           -19.8       11.96        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     31.61           -19.7       11.88        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     10.93            -6.2        4.68 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     10.93            -6.2        4.68 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     10.92            -6.2        4.68 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
     10.88            -6.2        4.66 ±  2%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
     23.32 ±  8%      -4.5       18.85 ±  4%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
     22.94 ±  8%      -4.2       18.70 ±  4%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
     22.10 ±  8%      -4.0       18.13 ±  4%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
     27.97 ±  8%      -3.8       24.13 ±  4%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
     28.23 ±  8%      -3.8       24.42 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     21.74 ±  8%      -3.7       17.99 ±  4%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
     26.52 ±  8%      -3.3       23.24 ±  4%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region
     26.76 ±  8%      -3.3       23.50 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
     27.39 ±  8%      -3.2       24.20 ±  4%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      2.32 ±  8%      -1.4        0.96 ± 17%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      2.13 ± 12%      -1.2        0.94 ± 17%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      0.65            +0.0        0.69        perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      0.54            +0.1        0.59        perf-profile.calltrace.cycles-pp.vma_merge_new_range.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.53            +0.1        0.58        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.58            +0.1        0.64        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.59            +0.1        0.65 ±  6%  perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      0.59            +0.1        0.64        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.52            +0.1        0.58        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.57 ±  2%      +0.1        0.64 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.61            +0.1        0.69        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      0.78            +0.1        0.86        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      0.60            +0.1        0.69        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region
      2.49            +0.1        2.58 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.65            +0.1        0.77        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      1.14            +0.1        1.26        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.42 ± 44%      +0.1        0.57        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.98            +0.2        3.14        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      2.03            +0.2        2.22        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      3.36            +0.2        3.55        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      2.15            +0.2        2.36        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      1.43            +0.2        1.64        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      1.40            +0.2        1.60        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      2.22            +0.2        2.44        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.95            +0.2        2.18        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.75            +0.2        1.99        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      2.01            +0.2        2.25        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      3.48            +0.2        3.73        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      2.16            +0.3        2.42        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.51 ±  7%      +0.3        2.78 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      3.03            +0.3        3.33        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      3.16            +0.3        3.47        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      3.42            +0.3        3.75        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      3.55            +0.3        3.89        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.52 ±  3%      +0.4        0.88 ±  3%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      2.33 ±  3%      +0.4        2.77 ±  6%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      1.62            +0.5        2.08        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      2.52 ±  2%      +0.5        2.98 ±  6%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      1.62            +0.5        2.10        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.25 ±100%      +0.5        0.75 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      2.77 ±  2%      +0.5        3.28 ±  5%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.5        0.53 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      4.86            +0.5        5.40 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      3.63            +0.5        4.17 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.5        0.54 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      3.10 ±  7%      +0.5        3.64 ±  4%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
      3.66            +0.5        4.20 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      2.94 ±  9%      +0.6        3.52 ±  4%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      9.34            +0.6        9.91 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
      9.47            +0.6       10.05 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      9.80            +0.6       10.40 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
      0.09 ±223%      +0.6        0.73 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.24 ±  5%      +0.6        2.88 ±  4%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      2.43 ±  4%      +0.7        3.09 ±  4%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      7.10            +0.7        7.80        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.69 ±  4%      +0.7        3.41 ±  3%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      8.74            +0.7        9.47        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.54 ±  4%      +1.1        2.69 ±  4%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      5.47            +1.2        6.67 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.26 ±100%      +1.2        1.48 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf
      0.26 ±100%      +1.2        1.48 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.26 ±100%      +1.2        1.48 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.3        1.29 ±  2%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf
      0.00            +1.3        1.29 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf
      0.00            +1.3        1.29 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.00            +1.3        1.29 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      5.39 ±  2%      +1.4        6.75 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      5.90 ±  2%      +1.4        7.33 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      2.13 ±  4%      +1.6        3.70 ±  4%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      2.13 ±  4%      +1.6        3.70 ±  4%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      2.14 ±  4%      +1.6        3.70 ±  4%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      2.14 ±  4%      +1.6        3.70 ±  4%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.15 ±  4%      +1.6        3.71 ±  4%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      2.15 ±  4%      +1.6        3.71 ±  4%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      2.15 ±  4%      +1.6        3.71 ±  4%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      2.14 ±  3%      +1.6        3.70 ±  4%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     11.14 ±  2%      +1.8       12.90        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
     11.12 ±  2%      +1.8       12.89        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
     11.12 ±  2%      +1.8       12.88        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +5.5        5.47 ±  2%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk
      0.00            +5.5        5.48 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node
      0.00            +5.5        5.49 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00            +5.5        5.49 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node.refill_objects
      0.00           +12.5       12.53        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node_bulk.__refill_objects_node.refill_objects
      0.00           +12.6       12.61        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00           +18.4       18.45        perf-profile.calltrace.cycles-pp.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     45.44            -8.4       37.01        perf-profile.children.cycles-pp.refill_objects
     44.70            -8.0       36.72        perf-profile.children.cycles-pp.__refill_objects_node
     54.52            -7.1       47.40        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     55.78            -7.0       48.80        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     60.08            -3.7       56.38        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     60.59            -3.6       56.94        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     27.40 ±  8%      -3.2       24.20 ±  4%  perf-profile.children.cycles-pp.mas_preallocate
     94.46            -1.8       92.63        perf-profile.children.cycles-pp.do_syscall_64
     94.62            -1.8       92.80        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.72 ±  7%      -0.4        0.28 ±  7%  perf-profile.children.cycles-pp.alloc_from_new_slab
      0.35            -0.1        0.30        perf-profile.children.cycles-pp.up_read
      0.12 ± 13%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.path_noexec
      0.75            -0.0        0.73        perf-profile.children.cycles-pp.perf_iterate_sb
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.07            +0.0        0.08        perf-profile.children.cycles-pp.prandom_u32_state
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.__call_rcu_common
      0.15            +0.0        0.16        perf-profile.children.cycles-pp._raw_spin_lock
      0.13            +0.0        0.14        perf-profile.children.cycles-pp.can_vma_merge_right
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.vm_get_page_prot
      0.14            +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.16            +0.0        0.17 ±  2%  perf-profile.children.cycles-pp.__filemap_get_folio_mpol
      0.10            +0.0        0.11 ±  3%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.17            +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.08            +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.mas_prev_setup
      0.20            +0.0        0.22 ±  2%  perf-profile.children.cycles-pp.mas_wr_walk_descend
      0.18            +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.freader_get_folio
      0.21 ±  2%      +0.0        0.22        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.13 ±  2%      +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.16 ±  2%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.current_time
      0.17            +0.0        0.19        perf-profile.children.cycles-pp.may_expand_vm
      0.22            +0.0        0.24        perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.14 ±  3%      +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.mas_prev
      0.26            +0.0        0.28        perf-profile.children.cycles-pp.pte_offset_map_lock
      0.26            +0.0        0.28        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.21            +0.0        0.23 ±  3%  perf-profile.children.cycles-pp.freader_init_from_file
      0.30            +0.0        0.32        perf-profile.children.cycles-pp.fput
      0.24            +0.0        0.26        perf-profile.children.cycles-pp.downgrade_write
      0.08 ±  6%      +0.0        0.10 ±  5%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.14 ± 10%      +0.0        0.17 ±  2%  perf-profile.children.cycles-pp.mmap_region
      0.19            +0.0        0.22        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.20            +0.0        0.23        perf-profile.children.cycles-pp.remove_vma
      0.08            +0.0        0.11        perf-profile.children.cycles-pp.unlink_file_vma_batch_final
      0.35            +0.0        0.38        perf-profile.children.cycles-pp.freader_fetch
      0.34            +0.0        0.37        perf-profile.children.cycles-pp.down_write
      0.23            +0.0        0.26        perf-profile.children.cycles-pp.fget
      0.35            +0.0        0.39        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.29            +0.0        0.33        perf-profile.children.cycles-pp.down_write_killable
      0.66            +0.0        0.70        perf-profile.children.cycles-pp.__build_id_parse
      0.37            +0.0        0.41        perf-profile.children.cycles-pp.touch_atime
      0.52            +0.0        0.56        perf-profile.children.cycles-pp.mas_wr_store_type
      0.42            +0.0        0.46        perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.46            +0.0        0.51        perf-profile.children.cycles-pp.up_write
      0.30            +0.0        0.34        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.35 ±  4%      +0.0        0.40 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.42            +0.0        0.47 ±  8%  perf-profile.children.cycles-pp.prepend_path
      0.40            +0.0        0.45        perf-profile.children.cycles-pp.shmem_mmap_prepare
      0.54            +0.0        0.59        perf-profile.children.cycles-pp.vma_merge_new_range
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.__pte_offset_map
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.mmap_action_prepare
      0.54            +0.1        0.59        perf-profile.children.cycles-pp.__vma_start_write
      0.59            +0.1        0.65 ±  6%  perf-profile.children.cycles-pp.d_path
      0.57            +0.1        0.63        perf-profile.children.cycles-pp.mas_walk
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.uprobe_mmap
      0.51            +0.1        0.58        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.57 ±  2%      +0.1        0.64 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
      0.14            +0.1        0.21 ±  2%  perf-profile.children.cycles-pp.vma_is_shared_writable
      0.56            +0.1        0.63        perf-profile.children.cycles-pp.mas_next_slot
      0.16 ±  2%      +0.1        0.24        perf-profile.children.cycles-pp.vma_wants_writenotify
      0.62            +0.1        0.69        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.99            +0.1        1.07        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.46            +0.1        0.55        perf-profile.children.cycles-pp.mas_rev_awalk
      0.54            +0.1        0.63        perf-profile.children.cycles-pp.mas_prev_slot
      0.61            +0.1        0.70        perf-profile.children.cycles-pp.zap_pte_range
      0.23            +0.1        0.33        perf-profile.children.cycles-pp.vma_set_page_prot
      1.21            +0.1        1.32        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.66            +0.1        0.77        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.14            +0.1        1.27        perf-profile.children.cycles-pp.vm_area_alloc
      1.48            +0.2        1.64        perf-profile.children.cycles-pp.mas_find
      3.00            +0.2        3.16        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.04            +0.2        2.23        perf-profile.children.cycles-pp.free_pud_range
      3.37            +0.2        3.57        perf-profile.children.cycles-pp.perf_event_mmap
      1.40            +0.2        1.61        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.43            +0.2        1.64        perf-profile.children.cycles-pp.vm_unmapped_area
      2.15            +0.2        2.36        perf-profile.children.cycles-pp.free_p4d_range
      2.23            +0.2        2.44        perf-profile.children.cycles-pp.free_pgd_range
      1.95            +0.2        2.18        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      2.01            +0.2        2.25        perf-profile.children.cycles-pp.__get_unmapped_area
      1.76            +0.2        2.00        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      3.48            +0.3        3.74        perf-profile.children.cycles-pp.__mmap_complete
      2.17            +0.3        2.43        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.78 ±  3%      +0.3        1.07 ±  2%  perf-profile.children.cycles-pp.mas_update_gap
      3.09            +0.3        3.40        perf-profile.children.cycles-pp.free_pgtables
      3.18            +0.3        3.49        perf-profile.children.cycles-pp.zap_pmd_range
      3.43            +0.3        3.76        perf-profile.children.cycles-pp.__zap_vma_range
      3.55            +0.3        3.90        perf-profile.children.cycles-pp.unmap_vmas
      4.08            +0.7        4.76 ±  2%  perf-profile.children.cycles-pp.barn_put_full_sheaf
      7.10            +0.7        7.80        perf-profile.children.cycles-pp.unmap_region
      8.78            +0.7        9.50        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      3.26            +0.9        4.19        perf-profile.children.cycles-pp.__pi_memcpy
      4.96            +1.1        6.07 ±  2%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      6.04            +1.1        7.16 ±  2%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
     16.56            +1.1       17.70 ±  2%  perf-profile.children.cycles-pp.__irq_exit_rcu
     16.70            +1.1       17.84 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     16.72            +1.2       17.87 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      5.47            +1.2        6.70        perf-profile.children.cycles-pp.kvfree_call_rcu
      7.52            +1.3        8.80 ±  2%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
      5.90 ±  2%      +1.4        7.33 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      2.14 ±  4%      +1.6        3.70 ±  4%  perf-profile.children.cycles-pp.run_ksoftirqd
      2.15 ±  4%      +1.6        3.71 ±  4%  perf-profile.children.cycles-pp.kthread
      2.15 ±  4%      +1.6        3.71 ±  4%  perf-profile.children.cycles-pp.ret_from_fork
      2.15 ±  4%      +1.6        3.71 ±  4%  perf-profile.children.cycles-pp.ret_from_fork_asm
      2.14 ±  3%      +1.6        3.70 ±  4%  perf-profile.children.cycles-pp.smpboot_thread_fn
     13.52            +1.9       15.41 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     13.53            +1.9       15.44 ±  2%  perf-profile.children.cycles-pp.__slab_free
     14.12            +2.0       16.09 ±  2%  perf-profile.children.cycles-pp.rcu_free_sheaf
     10.96            +2.6       13.54        perf-profile.children.cycles-pp.mas_wr_node_store
     18.66            +2.7       21.36        perf-profile.children.cycles-pp.rcu_do_batch
     18.68            +2.7       21.38        perf-profile.children.cycles-pp.rcu_core
     18.69            +2.7       21.39        perf-profile.children.cycles-pp.handle_softirqs
      0.00           +18.4       18.45        perf-profile.children.cycles-pp.get_partial_node_bulk
     60.07            -3.7       56.37        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      1.88            -0.4        1.49 ±  2%  perf-profile.self.cycles-pp.__refill_objects_node
      0.31            -0.0        0.26        perf-profile.self.cycles-pp.up_read
      0.56            -0.0        0.53        perf-profile.self.cycles-pp.perf_iterate_sb
      0.56            -0.0        0.54        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.12            -0.0        0.10 ±  4%  perf-profile.self.cycles-pp.atime_needs_update
      0.14 ±  4%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.11 ± 14%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.path_noexec
      0.09            -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.__build_id_parse
      0.11            -0.0        0.10        perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.14            +0.0        0.15        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.11            +0.0        0.12        perf-profile.self.cycles-pp.free_p4d_range
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_prev
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_prev_setup
      0.13            +0.0        0.14        perf-profile.self.cycles-pp._raw_spin_lock
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.16            +0.0        0.17        perf-profile.self.cycles-pp.may_expand_vm
      0.19            +0.0        0.20        perf-profile.self.cycles-pp.rcu_free_sheaf
      0.08            +0.0        0.09        perf-profile.self.cycles-pp.x64_sys_call
      0.19            +0.0        0.20        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.20 ±  2%      +0.0        0.22 ±  2%  perf-profile.self.cycles-pp.kmem_cache_free
      0.18 ±  2%      +0.0        0.19        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.16 ±  3%      +0.0        0.17        perf-profile.self.cycles-pp.freader_fetch
      0.41            +0.0        0.42        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.13 ±  8%      +0.0        0.15        perf-profile.self.cycles-pp.mmap_region
      0.27            +0.0        0.29        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.19            +0.0        0.21        perf-profile.self.cycles-pp.freader_init_from_file
      0.13 ±  2%      +0.0        0.15 ±  3%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.42            +0.0        0.44        perf-profile.self.cycles-pp.mas_find
      0.20            +0.0        0.22        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.22            +0.0        0.24        perf-profile.self.cycles-pp.downgrade_write
      0.05            +0.0        0.07        perf-profile.self.cycles-pp.remove_vma
      0.20            +0.0        0.22        perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.17            +0.0        0.19        perf-profile.self.cycles-pp.__vma_start_write
      0.26            +0.0        0.28        perf-profile.self.cycles-pp.fput
      0.18            +0.0        0.20        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.16            +0.0        0.18        perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.30            +0.0        0.32        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.29            +0.0        0.31        perf-profile.self.cycles-pp.mas_wr_store_type
      0.31            +0.0        0.34        perf-profile.self.cycles-pp.down_write
      0.07            +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.17            +0.0        0.19 ±  2%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.17 ±  2%      +0.0        0.19        perf-profile.self.cycles-pp.free_pgtables
      0.34            +0.0        0.36        perf-profile.self.cycles-pp.vm_area_alloc
      0.21            +0.0        0.24        perf-profile.self.cycles-pp.fget
      0.32            +0.0        0.35        perf-profile.self.cycles-pp.vma_merge_new_range
      0.38            +0.0        0.41        perf-profile.self.cycles-pp.mas_store_prealloc
      0.27            +0.0        0.30        perf-profile.self.cycles-pp.down_write_killable
      0.43            +0.0        0.46        perf-profile.self.cycles-pp.up_write
      0.36            +0.0        0.39        perf-profile.self.cycles-pp.perf_event_mmap
      0.46            +0.0        0.49        perf-profile.self.cycles-pp.__mmap
      0.41            +0.0        0.44        perf-profile.self.cycles-pp.__munmap
      0.26 ±  4%      +0.0        0.29 ±  3%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.37            +0.0        0.41        perf-profile.self.cycles-pp.mas_preallocate
      0.52            +0.0        0.56        perf-profile.self.cycles-pp.mas_walk
      0.30            +0.0        0.34        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.05            +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.touch_atime
      0.38            +0.0        0.43        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.59            +0.0        0.64        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.vma_set_page_prot
      0.30            +0.1        0.35        perf-profile.self.cycles-pp.__mmap_new_vma
      0.63            +0.1        0.68        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.52            +0.1        0.58        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.48            +0.1        0.54        perf-profile.self.cycles-pp.mas_next_slot
      0.52            +0.1        0.57        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.13 ±  2%      +0.1        0.19 ±  2%  perf-profile.self.cycles-pp.vma_is_shared_writable
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.uprobe_mmap
      0.88            +0.1        0.94        perf-profile.self.cycles-pp.mas_store_gfp
      0.49 ±  2%      +0.1        0.55        perf-profile.self.cycles-pp.__slab_free
      0.49            +0.1        0.56        perf-profile.self.cycles-pp.mas_prev_slot
      0.28            +0.1        0.35        perf-profile.self.cycles-pp.zap_pte_range
      0.42            +0.1        0.49        perf-profile.self.cycles-pp.mas_rev_awalk
      0.98            +0.1        1.06        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.46            +0.1        0.56        perf-profile.self.cycles-pp.kvfree_call_rcu
      1.44            +0.1        1.56        perf-profile.self.cycles-pp.mas_wr_node_store
      1.87            +0.1        2.02        perf-profile.self.cycles-pp.free_pud_range
      2.38            +0.2        2.54        perf-profile.self.cycles-pp.zap_pmd_range
      1.82            +0.2        1.99        perf-profile.self.cycles-pp.__mmap_region
      0.71 ±  3%      +0.3        0.98 ±  2%  perf-profile.self.cycles-pp.mas_update_gap
      0.00            +0.3        0.33        perf-profile.self.cycles-pp.get_partial_node_bulk
      2.90 ±  2%      +0.8        3.69        perf-profile.self.cycles-pp.__pi_memcpy



***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale

commit: 
  7e23073874 ("mm/slub: introduce helpers for node partial slab state")
  0fc52deec1 ("mm/slub: detach and reattach partial slabs in batch")

7e230738746ce9a7 0fc52deec1068ea3cc8eaa6e045 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  35949149            +6.9%   38424030        will-it-scale.192.processes
    187234            +6.9%     200124        will-it-scale.per_process_ops
  35949149            +6.9%   38424030        will-it-scale.workload
   1130464 ± 14%     -15.9%     951025 ±  6%  numa-meminfo.node1.Mapped
    765203            +6.8%     817048        meminfo.SUnreclaim
    916508            +5.7%     968444        meminfo.Slab
     21415 ±  2%     +35.9%      29105        vmstat.system.cs
    254768            +1.3%     258105        vmstat.system.in
      0.13 ±  3%      +0.0        0.14 ±  2%  mpstat.cpu.all.irq%
     18.10            +2.1       20.23        mpstat.cpu.all.soft%
      1.73            +0.2        1.91        mpstat.cpu.all.usr%
   4375386           -50.0%    2186988 ±  6%  numa-numastat.node0.local_node
   4460280           -49.9%    2236714 ±  5%  numa-numastat.node0.numa_hit
   5597529 ±  2%     -42.1%    3243169 ±  3%  numa-numastat.node1.local_node
   5712900 ±  2%     -40.6%    3393053 ±  3%  numa-numastat.node1.numa_hit
     21530           +35.8%      29239        perf-stat.i.context-switches
    263.83            +2.2%     269.76        perf-stat.i.cpu-migrations
     21371 ±  2%     +36.1%      29093        perf-stat.ps.context-switches
    261.10            +2.2%     266.90        perf-stat.ps.cpu-migrations
   4460290           -49.9%    2236236 ±  5%  numa-vmstat.node0.numa_hit
   4375396           -50.0%    2186510 ±  6%  numa-vmstat.node0.numa_local
    282371 ± 14%     -16.0%     237208 ±  6%  numa-vmstat.node1.nr_mapped
   5712955 ±  2%     -40.6%    3392995 ±  3%  numa-vmstat.node1.numa_hit
   5597585 ±  2%     -42.1%    3243112 ±  3%  numa-vmstat.node1.numa_local
    191228            +6.9%     204459        proc-vmstat.nr_slab_unreclaimable
  10177434           -44.7%    5632836 ±  3%  proc-vmstat.numa_hit
   9977167           -45.5%    5433226 ±  3%  proc-vmstat.numa_local
  33527355           -54.2%   15349765 ±  5%  proc-vmstat.pgalloc_normal
  32033712           -56.8%   13845940 ±  6%  proc-vmstat.pgfree
      0.21           +36.6%       0.29        perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.21           +36.6%       0.29        perf-sched.total_sch_delay.average.ms
     26.08 ±  3%     -25.9%      19.32 ±  2%  perf-sched.total_wait_and_delay.average.ms
    110198 ±  2%     +34.6%     148367        perf-sched.total_wait_and_delay.count.ms
     25.87 ±  3%     -26.4%      19.03 ±  2%  perf-sched.total_wait_time.average.ms
     26.08 ±  3%     -25.9%      19.32 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    110198 ±  2%     +34.6%     148367        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     25.87 ±  3%     -26.4%      19.03 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.21 ±  6%     +18.6%       0.25 ±  5%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.21 ±  5%     +14.6%       0.24 ±  2%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   3324769 ± 12%     +28.7%    4277348 ± 10%  sched_debug.cfs_rq:/.left_deadline.stddev
   3324734 ± 12%     +28.7%    4277309 ± 10%  sched_debug.cfs_rq:/.left_vruntime.stddev
     27152 ± 13%     +57.1%      42666 ± 16%  sched_debug.cfs_rq:/.load.avg
    127543 ±  9%     +38.2%     176277 ±  9%  sched_debug.cfs_rq:/.load.stddev
      6.75 ± 11%     +91.8%      12.94 ± 14%  sched_debug.cfs_rq:/.load_avg.min
      0.15 ±  7%     +29.3%       0.20 ±  7%  sched_debug.cfs_rq:/.nr_queued.stddev
   3324735 ± 12%     +28.7%    4277309 ± 10%  sched_debug.cfs_rq:/.right_vruntime.stddev
      3746 ± 36%    +147.1%       9256 ± 41%  sched_debug.cfs_rq:/.sum_weight.avg
     39887 ± 41%     +90.1%      75816 ± 21%  sched_debug.cfs_rq:/.sum_weight.stddev
      1195 ±  9%     +24.2%       1483 ±  5%  sched_debug.cpu.curr->pid.stddev
      0.00 ±  3%     +13.8%       0.00 ±  5%  sched_debug.cpu.next_balance.stddev
      0.21 ±  7%     +18.7%       0.25 ±  5%  sched_debug.cpu.nr_running.stddev
     18361 ±  2%     +32.9%      24405        sched_debug.cpu.nr_switches.avg
     15708 ±  2%     +38.1%      21687 ±  2%  sched_debug.cpu.nr_switches.min
     34.64           -21.3       13.38        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     34.48           -21.2       13.29        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.24            -6.8        5.47        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
     12.24            -6.8        5.48        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.24            -6.8        5.48        perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.20            -6.7        5.46        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
     26.52 ±  3%      -5.4       21.08 ±  7%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
     26.02 ±  3%      -5.2       20.87 ±  7%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
     31.47 ±  3%      -4.9       26.54 ±  7%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
     31.67 ±  3%      -4.9       26.75 ±  7%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     37.72 ±  2%      -3.5       34.26 ±  6%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     23.32 ±  3%      -2.6       20.73 ±  8%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
     22.88 ±  3%      -2.4       20.52 ±  8%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.02            -1.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      2.51            -1.1        1.40 ± 14%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      2.54            -1.0        1.50 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      0.77            -0.1        0.67        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      1.87            -0.1        1.81        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.22            -0.0        1.18        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      1.62            +0.0        1.65        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      0.62            +0.0        0.66        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.62            +0.0        0.67        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.53            +0.1        0.59        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.65            +0.1        0.72        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags
      0.59            +0.1        0.68        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      1.41            +0.1        1.51        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
      0.74            +0.1        0.84        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.43            +0.1        1.54        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
      1.75            +0.1        1.87        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      0.54            +0.1        0.66        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.11            +0.1        1.25        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.92            +0.2        2.07        perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.25 ±  4%      +0.2        1.42 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      1.98            +0.2        2.15        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.65            +0.2        2.84 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.26            +0.2        2.44        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      2.03            +0.2        2.22        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      2.39            +0.2        2.58        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.38            +0.2        2.62        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.62            +0.2        2.86        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.45 ±  3%      +0.2        1.69 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      2.85            +0.2        3.10        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.63            +0.2        2.88        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      3.01            +0.3        3.26        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.29 ±  3%      +0.4        2.68 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      1.58            +0.4        1.98        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      2.47 ±  2%      +0.4        2.88 ±  6%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      1.53            +0.4        1.94        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.55 ±  2%      +0.4        0.98 ±  2%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      2.34 ±  3%      +0.5        2.81 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.71 ±  2%      +0.5        3.18 ±  5%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      6.19            +0.5        6.72        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.5        0.53        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.17 ±141%      +0.6        0.73 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      3.62            +0.6        4.19 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      3.59            +0.6        4.16 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      7.68            +0.6        8.31        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.96            +0.6        5.61 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.19            +0.7        2.91 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      0.00            +0.7        0.73 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.37            +0.7        3.11 ±  7%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      2.86 ±  3%      +0.8        3.64 ±  8%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      2.59            +0.8        3.38 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
     10.48            +1.0       11.49 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     10.61            +1.0       11.64 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      5.37            +1.0        6.40 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
     10.96            +1.0       12.00 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     11.04            +1.0       12.08 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      5.92            +1.1        7.02 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.00            +1.2        1.23 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf
      0.00            +1.2        1.24 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.00            +1.2        1.24 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      0.00            +1.2        1.24 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf
      0.17 ±141%      +1.3        1.46 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.17 ±141%      +1.3        1.46 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      1.53 ±  3%      +1.3        2.82        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.08 ±223%      +1.4        1.45 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf
      5.27            +1.4        6.66 ±  3%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.18 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      2.18 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      2.18 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      2.17 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     12.27 ±  2%      +2.2       14.47        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
     12.26 ±  2%      +2.2       14.46        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
     12.28 ±  2%      +2.2       14.48        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.00            +6.3        6.34 ±  2%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk
      0.00            +6.4        6.36 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node
      0.00            +6.4        6.36 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00            +6.4        6.36 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node.refill_objects
      0.00           +14.1       14.13        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node_bulk.__refill_objects_node.refill_objects
      0.00           +14.2       14.21        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00           +20.9       20.94        perf-profile.calltrace.cycles-pp.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     49.86            -8.0       41.83        perf-profile.children.cycles-pp.refill_objects
     48.92            -7.5       41.41        perf-profile.children.cycles-pp.__refill_objects_node
     59.17            -6.5       52.68        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     60.32            -6.3       53.98        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     38.28 ±  2%      -3.4       34.87 ±  5%  perf-profile.children.cycles-pp.mas_store_gfp
     64.39            -2.9       61.51        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     64.91            -2.8       62.08        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     94.44            -2.0       92.40        perf-profile.children.cycles-pp.do_syscall_64
     94.59            -2.0       92.55        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.92 ±  2%      -0.5        0.40 ±  7%  perf-profile.children.cycles-pp.alloc_from_new_slab
      0.81            -0.1        0.70        perf-profile.children.cycles-pp.perf_iterate_sb
      0.38            -0.1        0.30        perf-profile.children.cycles-pp.up_read
      1.88            -0.1        1.81        perf-profile.children.cycles-pp.__mmap_complete
      0.15 ±  3%      -0.0        0.13        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.20            +0.0        0.21        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.07            +0.0        0.08        perf-profile.children.cycles-pp.prandom_u32_state
      0.17            +0.0        0.18        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.09            +0.0        0.10        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.11 ±  3%      +0.0        0.12        perf-profile.children.cycles-pp.testcase
      0.08 ±  4%      +0.0        0.09        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.06 ±  6%      +0.0        0.07        perf-profile.children.cycles-pp.__call_rcu_common
      0.14 ±  2%      +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.mas_prev
      0.14            +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.14            +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.up_write
      0.10            +0.0        0.12        perf-profile.children.cycles-pp.x64_sys_call
      0.07            +0.0        0.09        perf-profile.children.cycles-pp.unlink_file_vma_batch_final
      0.06            +0.0        0.08        perf-profile.children.cycles-pp.vm_get_page_prot
      0.16            +0.0        0.18        perf-profile.children.cycles-pp.may_expand_vm
      0.13 ±  2%      +0.0        0.15        perf-profile.children.cycles-pp.mas_prev_range
      0.24            +0.0        0.26        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      1.64            +0.0        1.66        perf-profile.children.cycles-pp.perf_event_mmap
      0.24            +0.0        0.27        perf-profile.children.cycles-pp.downgrade_write
      0.36            +0.0        0.39        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.29            +0.0        0.32        perf-profile.children.cycles-pp.down_write_killable
      0.32            +0.0        0.35        perf-profile.children.cycles-pp.vma_set_page_prot
      0.46            +0.0        0.50        perf-profile.children.cycles-pp.vma_merge_new_range
      0.53            +0.0        0.58        perf-profile.children.cycles-pp.mas_wr_store_type
      0.46            +0.0        0.50        perf-profile.children.cycles-pp.mas_rev_awalk
      0.70            +0.0        0.74        perf-profile.children.cycles-pp.mas_prev_slot
      0.30            +0.0        0.34        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.07            +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.kfree
      0.53            +0.0        0.58        perf-profile.children.cycles-pp.mas_walk
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.mm_get_unmapped_area_vmflags
      0.54            +0.1        0.59        perf-profile.children.cycles-pp.__vma_start_write
      0.45            +0.1        0.52 ±  3%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.mmap_region
      0.65            +0.1        0.72        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.00            +0.1        1.07        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.strlen
      0.01 ±223%      +0.1        0.10        perf-profile.children.cycles-pp.vm_area_free
      0.59            +0.1        0.68        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      1.28            +0.1        1.37        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.42            +0.1        1.52        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.44            +0.1        1.54        perf-profile.children.cycles-pp.vm_unmapped_area
      0.54            +0.1        0.66        perf-profile.children.cycles-pp.kmem_cache_free
      1.76            +0.1        1.88        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.11            +0.1        1.25        perf-profile.children.cycles-pp.vm_area_alloc
      1.92            +0.2        2.07        perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
      1.99            +0.2        2.16        perf-profile.children.cycles-pp.__get_unmapped_area
      2.27            +0.2        2.45        perf-profile.children.cycles-pp.free_p4d_range
      2.04            +0.2        2.22        perf-profile.children.cycles-pp.free_pud_range
      2.40            +0.2        2.59        perf-profile.children.cycles-pp.free_pgd_range
      0.82 ±  2%      +0.2        1.04 ±  2%  perf-profile.children.cycles-pp.mas_update_gap
      2.40            +0.2        2.64        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.87            +0.2        3.11        perf-profile.children.cycles-pp.__zap_vma_range
      2.70            +0.2        2.94        perf-profile.children.cycles-pp.free_pgtables
      2.64            +0.2        2.89        perf-profile.children.cycles-pp.zap_pmd_range
      3.02            +0.3        3.27        perf-profile.children.cycles-pp.unmap_vmas
     14.89            +0.5       15.36        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      6.20            +0.5        6.72        perf-profile.children.cycles-pp.unmap_region
      7.86            +0.5        8.41        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      4.10            +0.7        4.83 ±  2%  perf-profile.children.cycles-pp.barn_put_full_sheaf
      3.13            +0.8        3.96        perf-profile.children.cycles-pp.__pi_memcpy
      5.92            +1.1        7.02 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      4.84            +1.2        6.00 ±  2%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      6.11            +1.2        7.34 ±  2%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      5.31            +1.3        6.58 ±  2%  perf-profile.children.cycles-pp.kvfree_call_rcu
     17.71            +1.3       19.06        perf-profile.children.cycles-pp.__irq_exit_rcu
     17.83            +1.4       19.18        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     17.85            +1.4       19.21        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      7.59            +1.4        9.01 ±  2%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
      2.16 ±  3%      +1.8        3.95        perf-profile.children.cycles-pp.run_ksoftirqd
      2.18 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.kthread
      2.18 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.ret_from_fork
      2.18 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.ret_from_fork_asm
      2.17 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.smpboot_thread_fn
     14.64            +2.2       16.86        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     14.66            +2.3       16.93        perf-profile.children.cycles-pp.__slab_free
     15.25            +2.3       17.57        perf-profile.children.cycles-pp.rcu_free_sheaf
     10.75            +2.5       13.20        perf-profile.children.cycles-pp.mas_wr_node_store
     19.86            +3.1       22.99        perf-profile.children.cycles-pp.rcu_core
     19.87            +3.1       23.00        perf-profile.children.cycles-pp.handle_softirqs
     19.84            +3.1       22.98        perf-profile.children.cycles-pp.rcu_do_batch
      0.00           +20.9       20.94        perf-profile.children.cycles-pp.get_partial_node_bulk
     64.39            -2.9       61.51        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      1.90            -0.4        1.48 ±  2%  perf-profile.self.cycles-pp.__refill_objects_node
      0.27            -0.1        0.17        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.58            -0.1        0.49        perf-profile.self.cycles-pp.perf_iterate_sb
      0.34            -0.1        0.26        perf-profile.self.cycles-pp.up_read
      0.25 ±  3%      -0.0        0.23 ±  4%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.12            -0.0        0.11        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.14            +0.0        0.15        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.05            +0.0        0.06        perf-profile.self.cycles-pp.do_vmi_munmap
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_prev
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.testcase
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.unmap_region
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.unmap_vmas
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.prandom_u32_state
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.up_write
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.14 ±  3%      +0.0        0.16        perf-profile.self.cycles-pp.may_expand_vm
      0.11            +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.thp_get_unmapped_area_vmflags
      0.17            +0.0        0.19        perf-profile.self.cycles-pp.__vma_start_write
      0.17            +0.0        0.19        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.18            +0.0        0.20        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.09            +0.0        0.11 ±  3%  perf-profile.self.cycles-pp.x64_sys_call
      0.40            +0.0        0.42        perf-profile.self.cycles-pp.__vm_munmap
      0.27            +0.0        0.29        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.20            +0.0        0.22        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.40            +0.0        0.42        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.20 ±  2%      +0.0        0.22        perf-profile.self.cycles-pp.free_pgtables
      0.33            +0.0        0.35        perf-profile.self.cycles-pp.vma_merge_new_range
      0.27            +0.0        0.29        perf-profile.self.cycles-pp.down_write_killable
      0.22            +0.0        0.24        perf-profile.self.cycles-pp.downgrade_write
      0.30            +0.0        0.33        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.47            +0.0        0.50        perf-profile.self.cycles-pp.__mmap
      0.33            +0.0        0.36        perf-profile.self.cycles-pp.vm_area_alloc
      0.11 ±  3%      +0.0        0.14        perf-profile.self.cycles-pp.do_mmap
      0.64            +0.0        0.66        perf-profile.self.cycles-pp.mas_prev_slot
      0.37            +0.0        0.40        perf-profile.self.cycles-pp.perf_event_mmap
      0.05            +0.0        0.08        perf-profile.self.cycles-pp.vma_set_page_prot
      0.38            +0.0        0.41        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.30            +0.0        0.33        perf-profile.self.cycles-pp.mas_wr_store_type
      0.43            +0.0        0.46        perf-profile.self.cycles-pp.__munmap
      0.37            +0.0        0.40        perf-profile.self.cycles-pp.mas_preallocate
      0.42            +0.0        0.45        perf-profile.self.cycles-pp.mas_rev_awalk
      0.48            +0.0        0.51        perf-profile.self.cycles-pp.mas_walk
      0.06 ±  9%      +0.0        0.09        perf-profile.self.cycles-pp.kfree
      0.40            +0.0        0.44        perf-profile.self.cycles-pp.mas_store_prealloc
      0.22            +0.0        0.26        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.52            +0.0        0.56        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.30            +0.0        0.34        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.57            +0.0        0.61        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__get_unmapped_area
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.mmap_region
      0.63            +0.1        0.68        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.52            +0.1        0.57        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.87            +0.1        0.92        perf-profile.self.cycles-pp.mas_store_gfp
      0.48            +0.1        0.54        perf-profile.self.cycles-pp.__slab_free
      0.50            +0.1        0.57        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.99            +0.1        1.07        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.42            +0.1        0.51        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.19            +0.1        0.30        perf-profile.self.cycles-pp.kmem_cache_free
      1.48            +0.1        1.61        perf-profile.self.cycles-pp.mas_wr_node_store
      1.86            +0.1        2.00        perf-profile.self.cycles-pp.free_pud_range
      1.76            +0.1        1.90        perf-profile.self.cycles-pp.__mmap_region
      2.42            +0.2        2.60        perf-profile.self.cycles-pp.zap_pmd_range
      0.75            +0.2        0.94 ±  2%  perf-profile.self.cycles-pp.mas_update_gap
      0.00            +0.3        0.34        perf-profile.self.cycles-pp.get_partial_node_bulk
      2.77            +0.7        3.44        perf-profile.self.cycles-pp.__pi_memcpy





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


