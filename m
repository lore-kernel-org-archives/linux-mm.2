Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A76D25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 03:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5782C6B0088; Sun, 11 Jan 2026 22:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC3F6B0089; Sun, 11 Jan 2026 22:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351216B008A; Sun, 11 Jan 2026 22:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8816B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 22:01:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A36D013CD5F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:01:29 +0000 (UTC)
X-FDA: 84321811098.03.1DDE3AD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf16.hostedemail.com (Postfix) with ESMTP id A59BC180008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:01:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rr3mg3eW;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768186886; a=rsa-sha256;
	cv=fail;
	b=E2ts1WE04OhidlIBGkap/+jNJIwpSfld28swIu3FknXINE2NtTEc8OhLxCsLgmD92Oniwg
	1jGBhMawLg0iNTTIhGbHvws8ewM/naI4f0EbOwTQc/4cbtl0OeEpuiNQ5fyrmzQ9r8x1co
	ldR1jxuDmPOU3z84fgm+EMMSm+Wiksg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rr3mg3eW;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768186886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=S0nhR5Mj8xbD16TQdglcQ0P+im4FgqzEUmyNjZSFGP4=;
	b=TFWqH13jkRzLYjhMFNygYTmm17bPdHbwZVTKcTGvAR9XWKjlm6075wMdU+RndlidJdAMk9
	049Zij7IXkz8n6xlAO2XQ9bPIc+CZIWEPmZcjkH1vGPm5Hb6HgZsmhivnPATaRNArcjzO2
	nF9EHXZXmuPmCR4NR0Psmm0KyRlgVbs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768186886; x=1799722886;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=9Z1el8uLR6ep4ZQI8QZrjSGDpwF1M3ML37A+UsdZ37c=;
  b=Rr3mg3eWMwaP5S7GC/uFLOzrGIXG/p8Itwo4L7RVShe3r0cI8zZnTBl5
   o8eHtuXnZLNq9HmYmV9A4FnCHb8jc8HSRHB9tWOx4zERpkyexgM1W+BSt
   nI70eMtqJvPFGS6c8HGcC8H/Y+Oeq9r//SUml9egYoe0uPK+x9toWLSA5
   XFc1nW3nhOIBXaRQU2VNixtGxQR/sxRs3a9iuj43dqTSvj9dLfoa6G2Si
   5Bd43ixj9XvID2Vz4APs1uNA5UYhs+7xq5OlKV/wMPVJcfj/oU969A/SW
   kwl0akJnXgbsCekOqDgDLkL4YExQxiJhYalLIwMD+4E5LMhs6VxYWz7/I
   Q==;
X-CSE-ConnectionGUID: Vme28MvTQfKS9RdR/3SMww==
X-CSE-MsgGUID: jH49S8oSRiaYACLOUZ/DPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69194624"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69194624"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 19:01:24 -0800
X-CSE-ConnectionGUID: NOoWxzKNRbCvISZpVzCIxw==
X-CSE-MsgGUID: 8agz5tKVTwqmrRoydtlZMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204680926"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 19:01:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 19:01:23 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 19:01:23 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.17) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 19:01:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSO+iFQA9MLJ3gcOMwn6BAOeMEwlH/JrKgYIRlj/GObZoo2A7IOfVnVbB85C/5mBMO558IXhRDzK+WD+vT/nrIUAgxT5e3wNTy1GxGeHvm8opaP4Lj6ZIwn4Ld0mtzZvxddy8ctaj6nsJc7jEtwwxEaI5TkKch2cZSqLH6AhB0m8Gn5p53EbnCFDH+4Ivcw9YrQYPO4A7fRmiq10gtPTF8pmWs96LWxwsqmJMNnNtiVa1gFFkMLJWP2rX5RFI145G6w8aWjtSonH2eZEAh98Y47GKH0qh/hw5JF/3cFVhq6Q3sRqo4vnZRPoAfHK60BItfbuR8380meYOCct8n1Omg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJw7iYBYwrvSOj6O3fj1G6dh0xlJiDO88kfhuyPJQlg=;
 b=LrPw2eMb7tSuHG0UAycEX5RFKswblrrkxKrSY26OSza8GqKU8WMVnwT1W4aSTPFLvMOwUUjhvrCW9gy8y1US/vZxRC72zk1nVxxC8LujoRYYFWoIlPQbB3EX2ooIKM+tn4F/gfQEK7i5qfJ1WgZVmExHeaOP8QZCgpHgJ9PcUpQJq/P3cdjCP34CdUxIZoczVV40UozZuBkocvmR5CpsBzLb7eon86PVifZK8tv+E+7YMqyagzV5rGdoFTpIlXN5jRBGXBhbSneo9aP0uG7CAU+O5htfKgkyXEe9a5B4gc/UyIbDYW29Z3UL1A+PIRMKWbPX++rAVoB9L6nRaXtM7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BL1PR11MB6004.namprd11.prod.outlook.com (2603:10b6:208:390::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 03:01:20 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:01:20 +0000
Date: Mon, 12 Jan 2026 11:01:10 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Daniel Gomez <da.gomez@samsung.com>, "Jon
 Hunter" <jonathanh@nvidia.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm/slab]  0f35040de5:
 stress-ng.mmapfiles.ops_per_sec 76.6% improvement
Message-ID: <202601121000.9df978f9-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BL1PR11MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 395c39eb-5e35-435a-f259-08de5186dc2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?II7PQpOLz4/Km3qV0HtMDQoSIGNO1Fm0DKjq5m0WE93qSyaPahpVNpB7KQ?=
 =?iso-8859-1?Q?Z3uIVUlz/IsV6sk8+115xBsuo1yQUAf5MJNmZnJSgfPoVPLxiRcAQ/d2VI?=
 =?iso-8859-1?Q?Bk085Di24vzLNYjTGbRmnr3SboWGkNSazW9Fbc3fnBV9qewsJvb6vn3MJb?=
 =?iso-8859-1?Q?VYmWuMTxTOsvFzqNT1NVySoLnxZQWSM7Zl5/U/VaqdcX1LBDJ+A3pT+pLz?=
 =?iso-8859-1?Q?dHpDNTNqJsL4h6LzGZojr5nSo5GNtoZasMbkfpVyp82hXZDWN/K2Mbtf0e?=
 =?iso-8859-1?Q?Z4XGlLJGgek1OaPGD68lhITzlMhSb1svqdHYsI8eAzntU+ra2dsfNDXVxZ?=
 =?iso-8859-1?Q?BRoIHWEAyBBSqhQkMt5qiVwRePLRUF/BvyOnSDG6ai0Ev1O7xL4nM87rm1?=
 =?iso-8859-1?Q?E3u92coMpWjuO4ahKrgpA0pgLyWbx5d4W1Vz1gkbj0Xlw2v050px71wRwQ?=
 =?iso-8859-1?Q?46eKuUKlC+1Bprh0SA3FYng2bkCkynq1vg28IzMU3NQYEcuUwI90AX1zDy?=
 =?iso-8859-1?Q?UD39S2J8+rec+VcDWk0VESvDGHN5NH1irfXKGpUhbQVvN94z1u3QI2fuz3?=
 =?iso-8859-1?Q?n2kpBZr3sdqPIYKY+jp1zkvPTaY2Lzyf1wrSMSUaiIAY9zrlGcJlWrFkVd?=
 =?iso-8859-1?Q?Muj2CQd3twXgPMfw+2D/yIRVuTJPS9rfDRngKlqAB/rLO7+BF9OODfZd3E?=
 =?iso-8859-1?Q?hGODf2X/heDORpGN66xkqvVHjjiKeiVQVCyDujSg/lC9Vdxe/s1ZhuWwYF?=
 =?iso-8859-1?Q?XnqFbdRTBoAsREz+zw+qqHzee+x4vW6UdW8fuuyChhCVQF/dk5oJF8w3nS?=
 =?iso-8859-1?Q?gCY0N4Y8MZpq4ZnalKBIspe3n4+lR7R3m1unUOsYFrLLyS+7ADEJ2ABKxv?=
 =?iso-8859-1?Q?q8pzuE9VS+4OBJa5vxe6JxDseHTeYz2Cpd58cA2yLzLuCvlpRy3otR00Nz?=
 =?iso-8859-1?Q?vGLlGzpzgytcTkaYBo0hQ4G/Pw7IJJmy4ZREiRHtgcI2ul08mA36nnvXPT?=
 =?iso-8859-1?Q?jEu5jWS3OQf1o0IF792itlIXtw42OBFaTqyW5ISGemyCtRHHTdnBr30bIl?=
 =?iso-8859-1?Q?Az89moTitOn/d1elJMSbJkYHoSYcUtc2kyDIw4TrQe2NAIOLpvmR7cnliL?=
 =?iso-8859-1?Q?Nt7NQDDAWkvUhLhE9WLkrJEJ/Af0sV7w02WKOS4cFyeRGZnGhGf4hGl+v/?=
 =?iso-8859-1?Q?LaK2895+95obKDC/uyN//RcMXYlWyQTJn1gBHsFD3HBCGGUZN52C+dsLwl?=
 =?iso-8859-1?Q?w1JSXsFmXu27cCGqybuBa27K+saups/wssxwkbT62jtbUSu5GFHCgniHCe?=
 =?iso-8859-1?Q?wbgXN3+aXlAyxxA91ifkyplQcGUumhVRAxnb/6eyjqensXz7++hGjSLFW5?=
 =?iso-8859-1?Q?czKKL7+fVYUHsAAcS+NQjr+wNAzexbcJH1VYgLnMcCPRWdwfYPp4VC4oio?=
 =?iso-8859-1?Q?mAd3dBTaG2BTMKCowypecAxhEjuNAWqVbdJre83j0nfW/Akz+PcMBAdIIc?=
 =?iso-8859-1?Q?vWoQPv1LIiPOkemaLXmz+19FcSE98Id9QMB82y+DXq6Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?lJEaavKFqZWHzMsgfJVtStzCiipO1W5YPkO6cH8bF7k9g4dlVeulfxlcHW?=
 =?iso-8859-1?Q?GLX8pX62lDIeV6S6NmVZ18/57uw/ohK4K8IKj9kmDpJ9aRUYQX1rEvmPq8?=
 =?iso-8859-1?Q?uHcDd2NqecWXWOngIh/bvyX43KrZeU5z/fBbizIaBdxDxFqP5cJVSUXG+c?=
 =?iso-8859-1?Q?sItlurj3h8FTulCf+TGHp6JFsLMskOusKPfmBzKmHIoqsmyf4v/bgN2Jhx?=
 =?iso-8859-1?Q?HG9PHFezIlSNlg+ElfNuP86XMrQRW4Pl/zP0CQcTo41SULO1a1fe5M99n1?=
 =?iso-8859-1?Q?TYFOxCrXFaN5kGjlKyy6+m+sr7GO+wZGpD7t6gJI7JHtMGXlKeRT67LQNV?=
 =?iso-8859-1?Q?nYTy4IQWphn8stxhiylj9z+PsmqkZn10WU7tbOvW67x+/29IM1GJQHFFMT?=
 =?iso-8859-1?Q?QXA2iZYlCVmkFJd9O1MJ85t0RJ1bfuZ0x+FHrI1E8/TV2G7K9/MigDj/Kw?=
 =?iso-8859-1?Q?2DWXSVluy9iecnVbCcdNd8ENTID9J7te2aDQZ1geetu0wwh4w/Tv99ViLh?=
 =?iso-8859-1?Q?tId9oHZpMATW/ifcZ0ovubPcwgvFAIC9aqnv7Evkh68kn8YJ1GXJv4IeAQ?=
 =?iso-8859-1?Q?a8I4hbVa75Qzk0a/zX7o2McjaW1C2ZEm6nhW9PRa+Drvj7ztzoitEImXV4?=
 =?iso-8859-1?Q?xUlLF105WbBAXZbqfqh6qTYWyVilC9IGvLvXDHH/9HlVaCJ+XrGDtjvwFS?=
 =?iso-8859-1?Q?n0THSICkwvAgaIfxNmhfahoJVvCq7LVLGv26iWUoXSBv4V+GXggkZ/9Aiw?=
 =?iso-8859-1?Q?6BkPqopsuvWStooCM9XfA+dLxEqRRfoBGA7kAhHIb4BiYsLuet85BY3M6Z?=
 =?iso-8859-1?Q?kXIfH18BlNeNygUwApZBeqgGy792V7XOFR4/LAz03Dwiz3WpQh9CiEYj5+?=
 =?iso-8859-1?Q?SYnTimcU3oewiaLd7PJH8lyjMRMs0KfeJjmMhhIwCN22xzXNhhTuTGU4Vd?=
 =?iso-8859-1?Q?ls0gauzVlnZgqOibVhUAR/+rJJ3DzTAYgq/2TXFgEBfyctDgzNxH/hiBdy?=
 =?iso-8859-1?Q?Ya/q/XdOffYNSSuCerjsVNM/6qLsFJaLU4dBw81q6ySWPfbQ26tg9sWyuT?=
 =?iso-8859-1?Q?Yq0IuIUdbZSHRJjkCQPiOg5EyFwtR/IF3C7XefTmFSEDH9w4XnQoD3vucu?=
 =?iso-8859-1?Q?5JjgtHqKRejdH7LTAHRqe7zzuhDFNc4lM+hPK0gunmb1F54aYU1WEYqZdC?=
 =?iso-8859-1?Q?Pw0myhZMUmYWcHUWLZYtVjNxjY+6IEY+pWgD8ZTP42/G55d1dYx/4eNEoh?=
 =?iso-8859-1?Q?lWiFuT7tSSA6PmTsiaBD7XM7NrSTw8nH/Tp0haHh8Ayo3ITcynpQTXmw+4?=
 =?iso-8859-1?Q?6RhVeWqv7VPW5J70LXDQiKuE6MpQjg4wjVmeXMu3R4lhG605AkBrQa/jul?=
 =?iso-8859-1?Q?tmYD2NibFxUYc7DGqDzbihk5mdXSjxWBBZe6RlnfkCb27z7WhuNw9pfIHs?=
 =?iso-8859-1?Q?k+qU+R6551jh1WB26O4ONrmFXkwlUJvE8vJM0ZeeurowtRMiQ0qF60UrI4?=
 =?iso-8859-1?Q?jvku943wjtYHLrxKZiwoEPw1Zgj8h4hG1olUwJcZjDnLjAJWf7IGEBaS+A?=
 =?iso-8859-1?Q?sg60rUVVGoZrlyVxU9UtnQl0OlgPlYVMFjOE1jrpCWSu5eKpyurfr3dExw?=
 =?iso-8859-1?Q?hfjNHRAeGhJG1r39zJ7IVJ6hwow365VtlGcnMeMVuBf4XNvt409JPhGvxO?=
 =?iso-8859-1?Q?G1SrZK1HDxtrbAtvpBUKV3hbUGF0oqKka+vBjfVNpSh6Jm0J58Flg3kWA2?=
 =?iso-8859-1?Q?Nr86O7Ajqherw2d/gnf5BLwuicYUKMUlPq545JLxOgwzmMIK0tmFo27LHR?=
 =?iso-8859-1?Q?Cj8ELYrf8w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 395c39eb-5e35-435a-f259-08de5186dc2d
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 03:01:20.0104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pm+XbNdgB/hKKmrE7JaaZS6TFIt9TvKm7l9fVbDNGXGTRaQZ7166JS+ByP7TeazeGY3GNflM5d3H1XzMEPeHzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6004
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A59BC180008
X-Stat-Signature: yhhro65iydgswd5obgjnjwzmzgmt4fu9
X-Rspam-User: 
X-HE-Tag: 1768186885-586897
X-HE-Meta: U2FsdGVkX1+2BzLh/oRBmhx1o2XZ1Xy9/rgzXX3n4mdxQ2ILWpwA72uxzEW45YzDKh0yyf0zHNjRBgShNFctehh3u80MO3WTd114P+lZPoGo4+P70u9h8QQm5/LJnHBsQ6HAgRYJ/LQ9MhL6h3QXBvu4IcsSm7QGC0q90xvCP6iU7OWLtywDjE+6wS2MqBYLP63iwxsI6J/MZgFvfOAmr4mEJ9ArQ/eZvMQiaBUypxsdVJVNU4u3jCBZ7Ig5Qfn7MLiGyR2i5Ga/DUeoxwrC3yE/cKiqcntpxQFckiF3sF+2Di/u8NU8/b2x5mNRPrx2RWM63oZiHT6afUFN0y8KNR7hUK5kPk9V1waE5LzYQ1antErgSCKzfVvsHkEYT9i2jpYNXUYrTA/Um1ZaAMskLaNtmBUO7dMXyLNtiPtYOJw5TDjdvdNjmTVn4smj3JByM5/P5PjQo2uCoskFEue+AQZaHygJm5rW1CptkJABjsLlFAu0wTKg+5NaG6JTMWyjKQDpsi1YBbWZVdORrFqjr17zl4GWYOY4V6egyDSk7NRo77qHe0TG/xRJ+7EaCox+MyRZ1VdO6/ihLZh5gc+78yQoIhMYdcK1ss7kTW+iqkEC432YsyO/uwAx36cTDTLlvf6bDOxmx1qm6uQVg8qgflVyGX1HjnY9l6mMxTY4phmkVAlIlBSic8gGyDMZ38N1vdCQ3rb1KuIG15iztKanYFIvhTNW2TWkz8w6NV91r+vepGuA/BwiN7mNZb0tgdmHn/jEcBgnFKQb1MM35/3CNwxcYy31AIvtwd9FBAeIQPdKRJL5vT9Oo0rNOB6sJ9/sf9zlOUquFZOnrgPVKUjrSK9JA+2Dq4oe784Hf19V0QCfXKjB4ZFu2yD5wgMtHnB5iuyo6YY5SLP+Jm6DwL1/8hvWlKkEaJmEkEiVSBXjCNqgjal2X1pWf8rcRjL9O7zpFNhJnp6Bo9NuO4Rz8zm
 HelZI2bP
 t8O8VXRGXCDWn8hNInL6ueoZmDfaf4p1CJs1Hm5tPZU9erFcAwta3jx+51GadOLqEoEortgM9+ig+EVQFXo2nVY8Lcm5sOfJih7sA9eG0JR9GfXWPqPq/mgP9GzfsEMV1/cjCK+m1vMqnzwjU5i8AbQSjMrYTNo/xvfbzrcPU2lIt0fdeDp5GYXS624irWgQdZ+BDEPQJYfeSswVNgNnNpUPJLQk/zkqqrG7khjUebCbgPcsysrRxXh4GpSdu11bUnngMK5SBU17o+e904DKDBGW9G9ilpB0cTvTtK0B01oeSNqoHJqGNvoanizOSW1tW222Fc7riMFB0mquzSFGFRl0szx5CgrD9pEMX9gXrgX51uNeiyAVlGwSarTbk7CNfnwfD1SJGwn8PmX/ItHbyiexDij/kqfXvqYmE7orUmc/rJUZFT+CuNXV5PD5L9k4YGD2CIAZKkKXOJJMGYPN8UhEfYIdwi98xReVvVOsqPdWw45Sp7TwhoKPGoDawNCZBsOYtn+Fdi5zqgUEsRAxoSVghut4F2L0NuKCPc5EglxNk3dC5yXQ6bAcu8WJwUbQQlQdV+MMd5P404VnRZaiaV699BZiCHXvzS0KB+IJz20hr3I5jPFuWkpZ3F75NNEegBemL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 76.6% improvement of stress-ng.mmapfiles.ops_per_sec on:


commit: 0f35040de59371ad542b915d7b91176c9910dadc ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: mmapfiles
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260112/202601121000.9df978f9-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/mmapfiles/stress-ng/60s

commit: 
  b687034b1a ("Merge tag 'slab-for-6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab")
  slab-for-6.19-rc1

b687034b1a4d8533           slab-for-6.19-rc1 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 3.885e+09           -11.0%  3.457e+09        cpuidle..time
    548127           +46.9%     805428 ±  2%  cpuidle..usage
    804535 ±  5%      +8.9%     876030 ±  4%  meminfo.Active
    804498 ±  5%      +8.9%     876003 ±  4%  meminfo.Active(anon)
     55470 ±  3%     +62.6%      90204 ±  6%  meminfo.Shmem
      0.04 ±  3%      +0.0        0.07 ±  4%  mpstat.cpu.all.irq%
      0.04            +0.0        0.08 ±  2%  mpstat.cpu.all.soft%
      5.69            +7.6       13.31 ±  7%  mpstat.cpu.all.sys%
      1.10            +0.3        1.43 ±  2%  mpstat.cpu.all.usr%
    543183 ±  6%     +61.8%     878606 ±  7%  numa-numastat.node0.local_node
    584635 ±  4%     +56.2%     913219 ±  7%  numa-numastat.node0.numa_hit
    608975 ±  6%     +52.4%     927910 ±  4%  numa-numastat.node1.local_node
    633867 ±  5%     +51.4%     959726 ±  4%  numa-numastat.node1.numa_hit
     93.29            -8.3%      85.52        vmstat.cpu.id
      4.81 ± 11%    +110.3%      10.12 ±  9%  vmstat.procs.r
      7005           -15.9%       5889 ±  3%  vmstat.system.cs
     17980          +105.8%      37005 ±  5%  vmstat.system.in
      1102 ± 10%     +65.0%       1818 ± 13%  perf-c2c.DRAM.local
      1282 ±  6%    +277.4%       4839 ± 57%  perf-c2c.DRAM.remote
    316.50 ± 22%   +1932.8%       6433 ± 50%  perf-c2c.HITM.local
    284.67 ± 28%    +873.7%       2771 ± 79%  perf-c2c.HITM.remote
    601.17 ± 20%   +1431.3%       9205 ± 58%  perf-c2c.HITM.total
   3516848 ±  4%     -61.5%    1353981 ±104%  numa-meminfo.node0.FilePages
     78289 ±  9%     -56.4%      34115 ± 69%  numa-meminfo.node0.Mapped
   5170183 ±  2%     -39.7%    3119937 ± 44%  numa-meminfo.node0.MemUsed
   3511726 ±  4%     -61.7%    1344941 ±105%  numa-meminfo.node0.Unevictable
      7406 ± 95%    +674.1%      57329 ± 38%  numa-meminfo.node1.Mapped
   2021257 ± 10%    +102.9%    4100815 ± 33%  numa-meminfo.node1.MemUsed
     47495 ±  7%     +65.1%      78423 ± 13%  numa-meminfo.node1.Shmem
    252.83          +113.5%     539.83 ±  6%  turbostat.Avg_MHz
      7.04            +8.0       15.03 ±  6%  turbostat.Busy%
     93.02            -7.9       85.08        turbostat.C1%
     89.16           -16.9%      74.13 ±  2%  turbostat.CPU%c1
      0.79           -20.0%       0.63 ±  4%  turbostat.IPC
   1161434          +104.1%    2369952 ±  5%  turbostat.IRQ
    139727 ±  2%    +215.7%     441105 ± 16%  turbostat.NMI
    258.37            +7.9%     278.78        turbostat.PkgWatt
     16.88            +3.4%      17.46        turbostat.RAMWatt
    879212 ±  4%     -61.5%     338495 ±104%  numa-vmstat.node0.nr_file_pages
     19574 ±  9%     -56.4%       8529 ± 69%  numa-vmstat.node0.nr_mapped
    877931 ±  4%     -61.7%     336235 ±105%  numa-vmstat.node0.nr_unevictable
    877931 ±  4%     -61.7%     336235 ±105%  numa-vmstat.node0.nr_zone_unevictable
    585020 ±  4%     +56.1%     913216 ±  7%  numa-vmstat.node0.numa_hit
    543569 ±  6%     +61.6%     878602 ±  7%  numa-vmstat.node0.numa_local
      1854 ± 94%    +673.4%      14338 ± 38%  numa-vmstat.node1.nr_mapped
     11875 ±  7%     +65.1%      19609 ± 13%  numa-vmstat.node1.nr_shmem
    634048 ±  5%     +51.4%     959864 ±  4%  numa-vmstat.node1.numa_hit
    609156 ±  6%     +52.3%     928048 ±  4%  numa-vmstat.node1.numa_local
    201131 ±  5%      +8.9%     219005 ±  4%  proc-vmstat.nr_active_anon
     21407            +6.7%      22832 ±  3%  proc-vmstat.nr_mapped
     13869 ±  3%     +62.6%      22552 ±  6%  proc-vmstat.nr_shmem
     38217            +1.7%      38885        proc-vmstat.nr_slab_reclaimable
    201131 ±  5%      +8.9%     219005 ±  4%  proc-vmstat.nr_zone_active_anon
   1221409           +53.5%    1874979 ±  2%  proc-vmstat.numa_hit
   1155066           +56.6%    1808549 ±  2%  proc-vmstat.numa_local
   2768142           +60.7%    4447822        proc-vmstat.pgalloc_normal
    353846 ±  4%     +15.1%     407147 ±  3%  proc-vmstat.pgfault
   2722411           +60.4%    4367868        proc-vmstat.pgfree
    586929            -3.7%     565247        stress-ng.mmapfiles.file_munmap_per_sec
  24139835            -3.7%   23252834        stress-ng.mmapfiles.file_pages_munmap'd_per_sec
   9339622           +73.8%   16229674        stress-ng.mmapfiles.ops
    151192           +76.6%     267038        stress-ng.mmapfiles.ops_per_sec
     18364 ±  2%      -6.0%      17263 ±  2%  stress-ng.time.involuntary_context_switches
     85205 ±  8%     +46.4%     124766 ±  5%  stress-ng.time.minor_page_faults
    366.67          +140.1%     880.50 ±  7%  stress-ng.time.percent_of_cpu_this_job_got
    221.84          +135.6%     522.66 ±  7%  stress-ng.time.system_time
     11.46           +81.0%      20.75 ±  2%  stress-ng.time.user_time
     12290 ±  5%    +295.1%      48561 ±  8%  stress-ng.time.voluntary_context_switches
     59363 ±  9%     +51.8%      90128 ±  9%  sched_debug.cfs_rq:/.avg_vruntime.avg
    113379 ± 12%     +29.1%     146372 ± 10%  sched_debug.cfs_rq:/.avg_vruntime.max
     40057 ± 12%     +49.6%      59929 ± 11%  sched_debug.cfs_rq:/.avg_vruntime.min
     12470 ±  4%     +36.6%      17031 ± 12%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.14 ± 14%     +31.6%       0.19 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.32 ±  7%     +20.8%       0.39 ±  2%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.14 ± 14%     +29.8%       0.18 ±  5%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.32 ±  7%     +18.1%       0.38 ±  3%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
      0.14 ± 14%     +31.6%       0.19 ±  4%  sched_debug.cfs_rq:/.nr_queued.avg
      0.32 ±  7%     +20.8%       0.39 ±  2%  sched_debug.cfs_rq:/.nr_queued.stddev
     31.83 ± 18%     +31.9%      41.98 ± 17%  sched_debug.cfs_rq:/.util_est.avg
     59319 ±  9%     +51.9%      90078 ±  9%  sched_debug.cfs_rq:/.zero_vruntime.avg
    113112 ± 12%     +29.4%     146352 ± 10%  sched_debug.cfs_rq:/.zero_vruntime.max
     40057 ± 12%     +49.6%      59928 ± 11%  sched_debug.cfs_rq:/.zero_vruntime.min
     12374 ±  4%     +37.1%      16971 ± 12%  sched_debug.cfs_rq:/.zero_vruntime.stddev
    167786 ± 52%     -90.2%      16371 ± 87%  sched_debug.cpu.avg_idle.min
    185374 ±  6%     +36.3%     252712 ±  8%  sched_debug.cpu.avg_idle.stddev
    751.10 ± 16%     +36.3%       1023 ±  6%  sched_debug.cpu.curr->pid.avg
      1868 ±  9%     +18.8%       2218 ±  3%  sched_debug.cpu.curr->pid.stddev
      0.14 ± 13%     +33.3%       0.19 ±  5%  sched_debug.cpu.nr_running.avg
      0.32 ±  7%     +21.6%       0.39 ±  2%  sched_debug.cpu.nr_running.stddev
      2590 ±  5%     -37.6%       1615 ± 12%  sched_debug.cpu.nr_switches.min
      1.76 ±  2%     +31.8%       2.32 ±  2%  perf-stat.i.MPKI
 2.835e+09           +71.5%  4.861e+09 ±  2%  perf-stat.i.branch-instructions
      1.45 ±  4%      -0.5        0.96        perf-stat.i.branch-miss-rate%
  45154700           +18.4%   53446259 ±  2%  perf-stat.i.branch-misses
     49.48            -9.1       40.33 ±  3%  perf-stat.i.cache-miss-rate%
  22146898 ±  2%    +125.0%   49827612 ±  4%  perf-stat.i.cache-misses
  48127106          +172.4%  1.311e+08 ±  4%  perf-stat.i.cache-references
      7085           -16.3%       5930 ±  3%  perf-stat.i.context-switches
      1.05 ±  3%     +41.7%       1.49 ±  4%  perf-stat.i.cpi
 1.657e+10          +113.5%  3.536e+10 ±  6%  perf-stat.i.cpu-cycles
    111.84           +25.8%     140.66 ±  2%  perf-stat.i.cpu-migrations
    777.39 ±  6%     -12.7%     678.78 ±  5%  perf-stat.i.cycles-between-cache-misses
   1.3e+10           +70.4%  2.216e+10 ±  2%  perf-stat.i.instructions
      1.15           -33.0%       0.77 ±  4%  perf-stat.i.ipc
      0.03 ± 55%    +309.6%       0.14 ± 56%  perf-stat.i.major-faults
      4320 ±  5%     +21.1%       5234 ±  4%  perf-stat.i.minor-faults
      4320 ±  5%     +21.2%       5234 ±  4%  perf-stat.i.page-faults
      1.70 ±  2%     +32.1%       2.25 ±  3%  perf-stat.overall.MPKI
      1.59            -0.5        1.10        perf-stat.overall.branch-miss-rate%
     46.00            -7.9       38.05 ±  4%  perf-stat.overall.cache-miss-rate%
      1.27           +25.0%       1.59 ±  4%  perf-stat.overall.cpi
      0.78           -19.8%       0.63 ±  4%  perf-stat.overall.ipc
  2.79e+09           +71.3%  4.781e+09 ±  2%  perf-stat.ps.branch-instructions
  44426777           +17.9%   52393373 ±  2%  perf-stat.ps.branch-misses
  21794608 ±  2%    +124.9%   49012738 ±  4%  perf-stat.ps.cache-misses
  47382298          +172.2%   1.29e+08 ±  4%  perf-stat.ps.cache-references
      6972           -16.3%       5837 ±  3%  perf-stat.ps.context-switches
 1.631e+10          +113.1%  3.477e+10 ±  6%  perf-stat.ps.cpu-cycles
    110.14           +26.2%     138.97 ±  2%  perf-stat.ps.cpu-migrations
  1.28e+10           +70.3%  2.179e+10 ±  2%  perf-stat.ps.instructions
      0.03 ± 55%    +308.7%       0.14 ± 56%  perf-stat.ps.major-faults
      4251 ±  5%     +20.9%       5141 ±  4%  perf-stat.ps.minor-faults
      4251 ±  5%     +20.9%       5141 ±  4%  perf-stat.ps.page-faults
 8.228e+11           +66.4%  1.369e+12 ±  2%  perf-stat.total.instructions
     29.61           -13.4       16.16 ±  4%  perf-profile.calltrace.cycles-pp.__mmap
     28.45           -12.9       15.52 ±  4%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     28.35           -12.9       15.47 ±  4%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     27.82           -12.6       15.18 ±  4%  perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     27.40           -12.4       14.97 ±  4%  perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     26.72           -12.1       14.58 ±  4%  perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     20.32            -9.2       11.14 ±  4%  perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     14.14            -6.1        8.06 ±  5%  perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     10.47 ±  2%      -4.5        6.01 ±  6%  perf-profile.calltrace.cycles-pp.__munmap
     10.15 ±  2%      -4.3        5.83 ±  5%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     10.12 ±  2%      -4.3        5.82 ±  5%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      6.75 ±  3%      -3.8        2.97 ±  4%  perf-profile.calltrace.cycles-pp.vma_interval_tree_insert.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      8.41 ±  2%      -3.5        4.88 ±  6%  perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      8.40 ±  2%      -3.5        4.87 ±  6%  perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      8.25 ±  2%      -3.5        4.80 ±  6%  perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.92            -3.3        4.63 ±  6%  perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      5.65            -3.2        2.47 ±  6%  perf-profile.calltrace.cycles-pp.open_last_lookups.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      5.26 ±  2%      -3.0        2.27 ±  6%  perf-profile.calltrace.cycles-pp.lookup_fast.open_last_lookups.path_openat.do_filp_open.do_sys_openat2
      5.82            -2.7        3.10 ±  4%  perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      5.61            -2.6        3.02 ±  4%  perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      5.34            -2.5        2.87 ±  5%  perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      5.31            -2.5        2.85 ±  5%  perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap
      4.55            -2.1        2.43 ±  4%  perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area
      2.66 ±  6%      -2.0        0.69 ±  7%  perf-profile.calltrace.cycles-pp.__d_lookup.lookup_fast.open_last_lookups.path_openat.do_filp_open
      3.52 ±  2%      -1.9        1.64 ±  4%  perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      3.45 ±  2%      -1.9        1.59 ±  4%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      3.50            -1.6        1.90 ±  4%  perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      4.71 ±  4%      -1.6        3.13 ±  5%  perf-profile.calltrace.cycles-pp.vfs_open.do_open.path_openat.do_filp_open.do_sys_openat2
      3.62 ±  4%      -1.5        2.08 ±  6%  perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      5.92            -1.4        4.57 ±  4%  perf-profile.calltrace.cycles-pp.getdents64
      2.28 ±  3%      -1.3        0.95 ±  6%  perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      2.93            -1.2        1.70 ±  5%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.26 ±  4%      -1.2        3.03 ±  5%  perf-profile.calltrace.cycles-pp.do_dentry_open.vfs_open.do_open.path_openat.do_filp_open
      2.82 ±  4%      -1.2        1.62 ±  6%  perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      5.51            -1.2        4.35 ±  5%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.getdents64
      5.47            -1.1        4.33 ±  5%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.getdents64
      5.33            -1.1        4.25 ±  5%  perf-profile.calltrace.cycles-pp.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe.getdents64
      2.37 ±  4%      -1.0        1.37 ±  6%  perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      5.09            -1.0        4.12 ±  5%  perf-profile.calltrace.cycles-pp.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe.getdents64
      2.22 ±  4%      -0.9        1.28 ±  6%  perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.29 ±  4%      -0.9        0.37 ± 71%  perf-profile.calltrace.cycles-pp.filemap_get_entry.__filemap_get_folio.freader_get_folio.freader_fetch.__build_id_parse
      1.32 ±  4%      -0.9        0.46 ± 45%  perf-profile.calltrace.cycles-pp.__filemap_get_folio.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event
      2.00 ±  3%      -0.8        1.20 ±  4%  perf-profile.calltrace.cycles-pp.common_startup_64
      1.39 ±  4%      -0.8        0.61 ±  7%  perf-profile.calltrace.cycles-pp.freader_fetch.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_region
      1.36 ±  4%      -0.8        0.59 ±  7%  perf-profile.calltrace.cycles-pp.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event.perf_event_mmap
      1.70            -0.7        0.96 ±  4%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      2.04 ±  3%      -0.7        1.31 ±  5%  perf-profile.calltrace.cycles-pp.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.60 ±  4%      -0.7        0.88 ±  5%  perf-profile.calltrace.cycles-pp.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.60            -0.7        0.90 ±  4%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.54 ±  4%      -0.7        0.85 ±  4%  perf-profile.calltrace.cycles-pp.task_work_run.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      3.20            -0.7        2.53 ±  6%  perf-profile.calltrace.cycles-pp.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.92 ±  3%      -0.7        0.26 ±100%  perf-profile.calltrace.cycles-pp.mas_split.mas_wr_bnode.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.92 ±  3%      -0.7        0.26 ±100%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.alloc_empty_file.path_openat.do_filp_open.do_sys_openat2
      1.44            -0.7        0.78 ±  5%  perf-profile.calltrace.cycles-pp.getname_flags.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.98 ±  3%      -0.6        0.35 ± 70%  perf-profile.calltrace.cycles-pp.clear_bhb_loop
      1.32 ±  2%      -0.6        0.73 ±  3%  perf-profile.calltrace.cycles-pp.alloc_empty_file.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      0.84 ±  3%      -0.6        0.27 ±100%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.99 ±  2%      -0.5        0.46 ± 44%  perf-profile.calltrace.cycles-pp.mas_wr_bnode.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      1.15 ±  5%      -0.5        0.62 ±  5%  perf-profile.calltrace.cycles-pp.__fput.task_work_run.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.15 ±  2%      -0.5        0.62 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      1.15 ±  2%      -0.5        0.62 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      1.15 ±  2%      -0.5        0.62 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      1.56 ±  4%      -0.5        1.05 ±  4%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      1.56 ±  4%      -0.5        1.05 ±  4%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      1.56 ±  4%      -0.5        1.04 ±  4%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      0.95 ±  2%      -0.5        0.46 ± 45%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.07 ±  4%      -0.5        0.59 ±  7%  perf-profile.calltrace.cycles-pp.unmap_region.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.09 ±  2%      -0.5        0.62 ±  6%  perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.03 ±  2%      -0.5        0.56 ±  5%  perf-profile.calltrace.cycles-pp.strncpy_from_user.getname_flags.do_sys_openat2.__x64_sys_openat.do_syscall_64
      1.22 ±  2%      -0.5        0.76 ±  7%  perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.47 ±  4%      -0.5        1.02 ±  4%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      1.06 ±  3%      -0.4        0.62 ±  2%  perf-profile.calltrace.cycles-pp.kernfs_fop_release.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.01 ±  2%      -0.4        0.58 ±  4%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      1.36 ±  5%      -0.4        0.97 ±  4%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      1.44 ±  2%      -0.4        1.05 ±  4%  perf-profile.calltrace.cycles-pp.kernfs_fop_open.do_dentry_open.vfs_open.do_open.path_openat
      1.36 ±  5%      -0.4        0.97 ±  4%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      1.34 ±  5%      -0.4        0.95 ±  4%  perf-profile.calltrace.cycles-pp.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      1.34 ±  5%      -0.4        0.95 ±  4%  perf-profile.calltrace.cycles-pp.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      1.34 ±  4%      -0.4        0.95 ±  4%  perf-profile.calltrace.cycles-pp.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter
      2.21            -0.3        1.95 ±  7%  perf-profile.calltrace.cycles-pp.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.77 ±  7%      -0.2        0.61 ±  5%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      0.88 ±  5%      -0.1        0.74 ±  5%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      0.77 ±  7%      +0.4        1.14 ± 14%  perf-profile.calltrace.cycles-pp.try_to_unlazy.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      0.69 ±  6%      +0.4        1.10 ± 15%  perf-profile.calltrace.cycles-pp.__legitimize_path.try_to_unlazy.link_path_walk.path_openat.do_filp_open
      6.98 ±  2%      +0.4        7.40 ±  4%  perf-profile.calltrace.cycles-pp.do_open.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      1.10 ±  2%      +0.6        1.67 ± 14%  perf-profile.calltrace.cycles-pp.scan_positives.dcache_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64
      5.34            +0.6        5.94 ±  8%  perf-profile.calltrace.cycles-pp.__fstat64
      0.00            +0.8        0.77 ± 18%  perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.__mmap_new_vma.__mmap_region.do_mmap
      0.45 ± 44%      +0.8        1.28 ± 18%  perf-profile.calltrace.cycles-pp._raw_spin_lock.scan_positives.dcache_readdir.iterate_dir.__x64_sys_getdents64
      0.10 ±223%      +0.9        0.96 ± 17%  perf-profile.calltrace.cycles-pp.lockref_get_not_dead.__legitimize_path.try_to_unlazy.link_path_walk.path_openat
      0.00            +0.9        0.89 ± 26%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.scan_positives.dcache_readdir.iterate_dir
      0.00            +0.9        0.89 ± 16%  perf-profile.calltrace.cycles-pp.down_write.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.59 ±  6%      +1.1        1.70 ± 16%  perf-profile.calltrace.cycles-pp.lockref_put_return.dput.step_into_slowpath.link_path_walk.path_openat
      0.00            +1.2        1.24 ±  8%  perf-profile.calltrace.cycles-pp.up_read.kernfs_iop_permission.inode_permission.may_open.do_open
      3.64            +1.4        5.09 ± 10%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__fstat64
      0.00            +1.5        1.48 ± 16%  perf-profile.calltrace.cycles-pp.down_read.kernfs_iop_permission.inode_permission.may_open.do_open
      3.51 ±  2%      +1.5        5.02 ± 10%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__fstat64
      0.78 ±  6%      +1.5        2.32 ± 10%  perf-profile.calltrace.cycles-pp.up_read.kernfs_dop_revalidate.lookup_fast.link_path_walk.path_openat
      0.00            +1.5        1.55 ±  9%  perf-profile.calltrace.cycles-pp.up_read.kernfs_iop_getattr.vfs_getattr_nosec.vfs_fstat.__do_sys_newfstat
      3.02 ±  2%      +1.7        4.74 ± 10%  perf-profile.calltrace.cycles-pp.__do_sys_newfstat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__fstat64
      1.33 ±  6%      +1.8        3.09 ± 11%  perf-profile.calltrace.cycles-pp.down_read.kernfs_dop_revalidate.lookup_fast.link_path_walk.path_openat
      1.37 ±  5%      +1.9        3.23 ± 17%  perf-profile.calltrace.cycles-pp.may_open.do_open.path_openat.do_filp_open.do_sys_openat2
      0.08 ±223%      +1.9        1.98 ± 20%  perf-profile.calltrace.cycles-pp.down_read.kernfs_iop_getattr.vfs_getattr_nosec.vfs_fstat.__do_sys_newfstat
      0.92 ±  5%      +1.9        2.86 ± 53%  perf-profile.calltrace.cycles-pp.__d_lookup.lookup_fast.link_path_walk.path_openat.do_filp_open
      0.56 ± 44%      +2.0        2.54 ± 59%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__d_lookup.lookup_fast.link_path_walk.path_openat
      2.06 ±  3%      +2.2        4.22 ± 12%  perf-profile.calltrace.cycles-pp.vfs_fstat.__do_sys_newfstat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__fstat64
      0.79 ±  5%      +2.2        3.01 ± 18%  perf-profile.calltrace.cycles-pp.inode_permission.may_open.do_open.path_openat.do_filp_open
      1.83 ±  3%      +2.3        4.10 ± 13%  perf-profile.calltrace.cycles-pp.vfs_getattr_nosec.vfs_fstat.__do_sys_newfstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.59 ±  6%      +2.3        2.87 ± 19%  perf-profile.calltrace.cycles-pp.kernfs_iop_permission.inode_permission.may_open.do_open.path_openat
      0.78 ±  6%      +2.4        3.15 ± 46%  perf-profile.calltrace.cycles-pp.dput.step_into_slowpath.link_path_walk.path_openat.do_filp_open
      0.94 ±  6%      +2.7        3.64 ± 15%  perf-profile.calltrace.cycles-pp.kernfs_iop_getattr.vfs_getattr_nosec.vfs_fstat.__do_sys_newfstat.do_syscall_64
      1.61 ±  5%      +2.9        4.46 ± 34%  perf-profile.calltrace.cycles-pp.step_into_slowpath.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      4.67 ±  2%      +2.9        7.53 ±  3%  perf-profile.calltrace.cycles-pp.__open64_nocancel
      4.46 ±  2%      +3.0        7.41 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      4.44 ±  2%      +3.0        7.40 ±  3%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      4.36 ±  2%      +3.0        7.33 ±  3%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      4.35 ±  2%      +3.0        7.32 ±  3%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
      2.49 ±  3%      +4.0        6.53 ± 11%  perf-profile.calltrace.cycles-pp.kernfs_dop_revalidate.lookup_fast.link_path_walk.path_openat.do_filp_open
      5.08 ±  2%      +5.3       10.38 ± 11%  perf-profile.calltrace.cycles-pp.lookup_fast.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      1.50 ±  6%      +9.5       11.04 ± 11%  perf-profile.calltrace.cycles-pp.down_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
      1.43 ±  8%     +10.5       11.92 ±  4%  perf-profile.calltrace.cycles-pp.up_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
     34.74           +19.9       54.66 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     34.52           +20.0       54.55 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.63 ± 12%     +20.5       24.18 ±  6%  perf-profile.calltrace.cycles-pp.kernfs_iop_permission.inode_permission.link_path_walk.path_openat.do_filp_open
      5.16 ±  5%     +20.7       25.89 ±  5%  perf-profile.calltrace.cycles-pp.inode_permission.link_path_walk.path_openat.do_filp_open.do_sys_openat2
     29.99           +21.2       51.20 ±  2%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.91           +21.2       51.15 ±  2%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     31.64           +25.4       57.06 ±  2%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     31.44           +25.5       56.95 ±  2%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
     15.29 ±  2%     +28.9       44.16 ±  4%  perf-profile.calltrace.cycles-pp.link_path_walk.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
     30.05           -13.7       16.38 ±  4%  perf-profile.children.cycles-pp.__mmap
     27.86           -12.7       15.20 ±  4%  perf-profile.children.cycles-pp.ksys_mmap_pgoff
     27.48           -12.5       15.00 ±  4%  perf-profile.children.cycles-pp.vm_mmap_pgoff
     26.78           -12.2       14.60 ±  4%  perf-profile.children.cycles-pp.do_mmap
     20.42            -9.2       11.19 ±  4%  perf-profile.children.cycles-pp.__mmap_region
     14.20            -6.1        8.09 ±  5%  perf-profile.children.cycles-pp.__mmap_new_vma
     10.59 ±  2%      -4.5        6.07 ±  6%  perf-profile.children.cycles-pp.__munmap
      6.76 ±  3%      -3.8        2.97 ±  4%  perf-profile.children.cycles-pp.vma_interval_tree_insert
      8.42 ±  2%      -3.5        4.88 ±  6%  perf-profile.children.cycles-pp.__x64_sys_munmap
      8.41 ±  2%      -3.5        4.88 ±  6%  perf-profile.children.cycles-pp.__vm_munmap
      8.26 ±  2%      -3.5        4.80 ±  6%  perf-profile.children.cycles-pp.do_vmi_munmap
      8.09 ±  2%      -3.4        4.71 ±  6%  perf-profile.children.cycles-pp.do_vmi_align_munmap
      5.68            -2.8        2.88 ±  6%  perf-profile.children.cycles-pp.open_last_lookups
      5.84            -2.7        3.11 ±  4%  perf-profile.children.cycles-pp.__get_unmapped_area
      5.65            -2.6        3.04 ±  4%  perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      5.37            -2.5        2.89 ±  5%  perf-profile.children.cycles-pp.vm_unmapped_area
      5.34            -2.5        2.87 ±  5%  perf-profile.children.cycles-pp.unmapped_area_topdown
      4.69            -2.2        2.51 ±  4%  perf-profile.children.cycles-pp.mas_empty_area_rev
      3.54 ±  2%      -1.9        1.64 ±  4%  perf-profile.children.cycles-pp.perf_event_mmap
      3.48 ±  2%      -1.9        1.61 ±  4%  perf-profile.children.cycles-pp.perf_event_mmap_event
      3.64            -1.7        1.96 ±  4%  perf-profile.children.cycles-pp.mas_rev_awalk
      3.70 ±  3%      -1.6        2.13 ±  6%  perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      6.05            -1.4        4.64 ±  5%  perf-profile.children.cycles-pp.getdents64
      3.08            -1.4        1.69 ±  3%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      4.81            -1.4        3.44 ±  5%  perf-profile.children.cycles-pp.vfs_open
      2.29 ±  3%      -1.3        0.95 ±  6%  perf-profile.children.cycles-pp.__build_id_parse
      3.08            -1.3        1.78 ±  5%  perf-profile.children.cycles-pp.mas_store_gfp
      4.65            -1.3        3.35 ±  5%  perf-profile.children.cycles-pp.do_dentry_open
      2.87 ±  4%      -1.2        1.65 ±  6%  perf-profile.children.cycles-pp.vms_clear_ptes
      2.47            -1.2        1.31 ±  4%  perf-profile.children.cycles-pp.clear_bhb_loop
      2.64 ±  3%      -1.1        1.53 ±  6%  perf-profile.children.cycles-pp.free_pgtables
      2.45 ±  2%      -1.1        1.35 ±  4%  perf-profile.children.cycles-pp.its_return_thunk
      5.34            -1.1        4.25 ±  5%  perf-profile.children.cycles-pp.__x64_sys_getdents64
      2.18 ±  2%      -1.0        1.14 ±  5%  perf-profile.children.cycles-pp.entry_SYSCALL_64
      5.11            -1.0        4.13 ±  5%  perf-profile.children.cycles-pp.iterate_dir
      2.23 ±  4%      -0.9        1.29 ±  6%  perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      3.66 ±  2%      -0.9        2.74 ±  5%  perf-profile.children.cycles-pp.__fput
      1.71            -0.9        0.81 ±  4%  perf-profile.children.cycles-pp.__d_lookup_rcu
      3.71            -0.9        2.84 ±  6%  perf-profile.children.cycles-pp.__x64_sys_close
      1.20 ±  5%      -0.9        0.34 ±  8%  perf-profile.children.cycles-pp.errseq_sample
      2.00 ±  3%      -0.8        1.20 ±  4%  perf-profile.children.cycles-pp.common_startup_64
      2.00 ±  3%      -0.8        1.20 ±  4%  perf-profile.children.cycles-pp.cpu_startup_entry
      2.00 ±  3%      -0.8        1.20 ±  4%  perf-profile.children.cycles-pp.do_idle
      1.73            -0.8        0.94 ±  4%  perf-profile.children.cycles-pp.getname_flags
      1.40 ±  4%      -0.8        0.61 ±  7%  perf-profile.children.cycles-pp.freader_fetch
      1.75 ±  3%      -0.8        0.96 ±  3%  perf-profile.children.cycles-pp.__cond_resched
      1.80 ±  2%      -0.8        1.02 ±  3%  perf-profile.children.cycles-pp.kmem_cache_free
      1.37 ±  4%      -0.8        0.59 ±  7%  perf-profile.children.cycles-pp.freader_get_folio
      1.89 ±  2%      -0.8        1.12 ±  4%  perf-profile.children.cycles-pp.mas_alloc_nodes
      1.74            -0.8        0.97 ±  4%  perf-profile.children.cycles-pp.mas_preallocate
      1.64            -0.8        0.88 ±  4%  perf-profile.children.cycles-pp.mas_wr_bnode
      1.91 ±  3%      -0.7        1.17 ±  4%  perf-profile.children.cycles-pp.cpuidle_idle_call
      2.07 ±  3%      -0.7        1.32 ±  5%  perf-profile.children.cycles-pp.kernfs_fop_readdir
      1.64            -0.7        0.92 ±  4%  perf-profile.children.cycles-pp.mas_store_prealloc
      1.54            -0.7        0.82 ±  4%  perf-profile.children.cycles-pp.mas_find
      1.36 ±  4%      -0.7        0.65 ±  6%  perf-profile.children.cycles-pp.__filemap_get_folio
      1.54 ±  2%      -0.7        0.84 ±  2%  perf-profile.children.cycles-pp.alloc_empty_file
      1.33 ±  4%      -0.7        0.63 ±  6%  perf-profile.children.cycles-pp.filemap_get_entry
      1.79 ±  4%      -0.7        1.12 ±  4%  perf-profile.children.cycles-pp.cpuidle_enter
      1.53            -0.7        0.86 ±  5%  perf-profile.children.cycles-pp.handle_softirqs
      1.78 ±  4%      -0.7        1.11 ±  4%  perf-profile.children.cycles-pp.cpuidle_enter_state
      1.76 ±  4%      -0.7        1.10 ±  4%  perf-profile.children.cycles-pp.acpi_idle_do_entry
      1.76            -0.7        1.10 ±  5%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      1.76 ±  4%      -0.7        1.10 ±  4%  perf-profile.children.cycles-pp.acpi_idle_enter
      1.76 ±  4%      -0.7        1.10 ±  4%  perf-profile.children.cycles-pp.acpi_safe_halt
      1.76 ±  4%      -0.7        1.10 ±  4%  perf-profile.children.cycles-pp.pv_native_safe_halt
      1.52 ±  2%      -0.6        0.91 ±  5%  perf-profile.children.cycles-pp.kmem_cache_prefill_sheaf
      1.84 ±  6%      -0.6        1.24 ±  5%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
      1.47 ±  2%      -0.6        0.89 ±  5%  perf-profile.children.cycles-pp.__prefill_sheaf_pfmemalloc
      1.80 ±  7%      -0.6        1.22 ±  5%  perf-profile.children.cycles-pp.task_work_run
      1.16 ±  2%      -0.6        0.59 ±  7%  perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.17            -0.6        0.61 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      1.21 ±  2%      -0.6        0.66 ±  4%  perf-profile.children.cycles-pp.strncpy_from_user
      1.16            -0.5        0.62 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      1.16            -0.5        0.62 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      1.15 ±  2%      -0.5        0.62 ±  2%  perf-profile.children.cycles-pp.kthread
      1.34            -0.5        0.81 ±  7%  perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      1.56 ±  4%      -0.5        1.05 ±  4%  perf-profile.children.cycles-pp.start_secondary
      1.14 ±  5%      -0.5        0.64 ±  5%  perf-profile.children.cycles-pp.mas_spanning_rebalance
      1.08 ±  4%      -0.5        0.60 ±  6%  perf-profile.children.cycles-pp.unmap_region
      0.76 ±  4%      -0.5        0.28 ±  6%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      1.09 ±  2%      -0.5        0.62 ±  6%  perf-profile.children.cycles-pp.vm_area_alloc
      0.79 ±  5%      -0.5        0.32 ±  6%  perf-profile.children.cycles-pp.generic_fillattr
      1.00 ±  3%      -0.5        0.54 ±  5%  perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      1.08 ±  3%      -0.4        0.64 ±  2%  perf-profile.children.cycles-pp.kernfs_fop_release
      1.06 ±  2%      -0.4        0.64 ±  5%  perf-profile.children.cycles-pp.rcu_core
      0.92 ±  2%      -0.4        0.48 ±  5%  perf-profile.children.cycles-pp.cp_new_stat
      0.93 ±  3%      -0.4        0.50 ±  5%  perf-profile.children.cycles-pp.mas_split
      1.05 ±  2%      -0.4        0.63 ±  5%  perf-profile.children.cycles-pp.rcu_do_batch
      0.93 ±  4%      -0.4        0.52 ±  5%  perf-profile.children.cycles-pp.unmap_vmas
      0.98 ±  2%      -0.4        0.57 ±  3%  perf-profile.children.cycles-pp.kvfree_call_rcu
      1.47 ±  2%      -0.4        1.07 ±  4%  perf-profile.children.cycles-pp.kernfs_fop_open
      0.85 ±  2%      -0.4        0.44 ±  4%  perf-profile.children.cycles-pp.filldir64
      0.98            -0.4        0.59 ±  6%  perf-profile.children.cycles-pp.mas_wr_node_store
      0.86 ±  5%      -0.4        0.48 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.75 ±  2%      -0.4        0.38 ±  3%  perf-profile.children.cycles-pp.mas_walk
      0.83 ±  3%      -0.4        0.47 ±  6%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.58 ±  5%      -0.4        0.22 ± 12%  perf-profile.children.cycles-pp.xas_load
      0.84            -0.3        0.50 ±  5%  perf-profile.children.cycles-pp.__close_nocancel
      0.83            -0.3        0.50 ±  4%  perf-profile.children.cycles-pp.___slab_alloc
      0.76 ±  6%      -0.3        0.43 ±  6%  perf-profile.children.cycles-pp.mas_wr_spanning_store
      0.72 ±  3%      -0.3        0.40 ±  5%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.78 ±  3%      -0.3        0.46 ±  6%  perf-profile.children.cycles-pp.rcu_free_sheaf
      0.68 ±  2%      -0.3        0.36 ±  6%  perf-profile.children.cycles-pp.mas_ascend
      0.59 ±  6%      -0.3        0.27 ±  3%  perf-profile.children.cycles-pp.rb_next
      0.73 ±  4%      -0.3        0.41 ±  2%  perf-profile.children.cycles-pp.stress_mmapfiles_dir
      0.51 ±  4%      -0.3        0.20 ±  5%  perf-profile.children.cycles-pp.sysvec_call_function_single
      0.68 ±  6%      -0.3        0.37 ±  5%  perf-profile.children.cycles-pp.rcu_all_qs
      0.70 ±  3%      -0.3        0.40 ±  5%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.67 ±  6%      -0.3        0.38 ±  8%  perf-profile.children.cycles-pp.vma_interval_tree_remove
      0.65 ±  3%      -0.3        0.35 ±  7%  perf-profile.children.cycles-pp.__check_object_size
      0.63 ±  4%      -0.3        0.33 ±  5%  perf-profile.children.cycles-pp.unmap_page_range
      0.68 ±  6%      -0.3        0.39 ±  5%  perf-profile.children.cycles-pp.mas_topiary_replace
      1.44 ±  3%      -0.3        1.15 ±  4%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.44 ±  6%      -0.3        0.15 ± 18%  perf-profile.children.cycles-pp.rest_init
      0.44 ±  6%      -0.3        0.15 ± 18%  perf-profile.children.cycles-pp.start_kernel
      0.44 ±  6%      -0.3        0.15 ± 18%  perf-profile.children.cycles-pp.x86_64_start_kernel
      0.44 ±  6%      -0.3        0.15 ± 18%  perf-profile.children.cycles-pp.x86_64_start_reservations
      0.68 ±  3%      -0.3        0.40 ±  6%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.44 ±  4%      -0.3        0.17 ± 12%  perf-profile.children.cycles-pp.xas_start
      0.59 ±  2%      -0.3        0.32 ±  7%  perf-profile.children.cycles-pp.mas_rebalance
      0.62 ±  3%      -0.3        0.35 ±  5%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.60 ± 11%      -0.3        0.34 ±  8%  perf-profile.children.cycles-pp.__rb_erase_color
      0.66 ±  4%      -0.3        0.40 ±  3%  perf-profile.children.cycles-pp.kernfs_unlink_open_file
      0.68 ±  2%      -0.3        0.43 ±  6%  perf-profile.children.cycles-pp.__slab_free
      0.56 ±  4%      -0.2        0.32 ±  7%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.58 ±  2%      -0.2        0.34 ±  5%  perf-profile.children.cycles-pp.mas_next_slot
      0.53 ±  4%      -0.2        0.28 ±  4%  perf-profile.children.cycles-pp.d_path
      0.53 ±  5%      -0.2        0.29 ±  6%  perf-profile.children.cycles-pp.__rb_insert_augmented
      0.50 ±  4%      -0.2        0.26 ±  4%  perf-profile.children.cycles-pp.prepend_path
      0.58 ±  3%      -0.2        0.34 ±  4%  perf-profile.children.cycles-pp.readdir64
      0.52 ±  4%      -0.2        0.28 ±  8%  perf-profile.children.cycles-pp.mas_prev_slot
      0.40 ±  6%      -0.2        0.17 ±  6%  perf-profile.children.cycles-pp.simple_getattr
      0.46 ±  3%      -0.2        0.24 ±  6%  perf-profile.children.cycles-pp._copy_to_user
      0.46 ±  2%      -0.2        0.25        perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.47 ±  5%      -0.2        0.25 ±  7%  perf-profile.children.cycles-pp.kfree
      0.36 ±  3%      -0.2        0.14 ±  7%  perf-profile.children.cycles-pp.kernfs_dir_pos
      0.37 ±  4%      -0.2        0.16 ±  5%  perf-profile.children.cycles-pp._nohz_idle_balance
      0.47 ±  2%      -0.2        0.26 ±  6%  perf-profile.children.cycles-pp.mas_data_end
      1.03 ±  5%      -0.2        0.82 ±  4%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.43 ±  4%      -0.2        0.24 ±  4%  perf-profile.children.cycles-pp.refill_obj_stock
      0.41 ±  5%      -0.2        0.22 ±  4%  perf-profile.children.cycles-pp.x64_sys_call
      0.41 ±  4%      -0.2        0.23 ±  8%  perf-profile.children.cycles-pp.mas_push_data
      0.36 ±  3%      -0.2        0.19 ±  5%  perf-profile.children.cycles-pp.fput
      0.37 ±  3%      -0.2        0.20 ±  9%  perf-profile.children.cycles-pp.worker_thread
      0.48 ±  6%      -0.2        0.31 ±  9%  perf-profile.children.cycles-pp.touch_atime
      0.35 ±  5%      -0.2        0.18 ±  7%  perf-profile.children.cycles-pp.check_heap_object
      0.38 ±  4%      -0.2        0.22 ±  5%  perf-profile.children.cycles-pp.__account_obj_stock
      0.36 ±  4%      -0.2        0.20 ±  7%  perf-profile.children.cycles-pp.__pi_memcpy
      0.35 ±  6%      -0.2        0.19 ±  5%  perf-profile.children.cycles-pp.seq_open
      0.35 ±  3%      -0.2        0.19 ±  4%  perf-profile.children.cycles-pp.alloc_fd
      0.34 ±  4%      -0.2        0.18 ±  6%  perf-profile.children.cycles-pp.zap_pmd_range
      0.36 ±  6%      -0.2        0.20 ± 10%  perf-profile.children.cycles-pp.path_init
      0.33 ±  5%      -0.2        0.18 ±  5%  perf-profile.children.cycles-pp.init_file
      0.32 ±  7%      -0.2        0.17 ±  8%  perf-profile.children.cycles-pp.prepend_copy
      0.33 ±  5%      -0.2        0.18 ±  5%  perf-profile.children.cycles-pp.mab_mas_cp
      0.30 ±  6%      -0.1        0.15 ±  3%  perf-profile.children.cycles-pp.strlen
      0.32 ±  8%      -0.1        0.18 ±  7%  perf-profile.children.cycles-pp.stress_time_now_timespec
      0.32 ±  3%      -0.1        0.17 ±  6%  perf-profile.children.cycles-pp.seq_release
      0.29 ±  8%      -0.1        0.15 ±  9%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.37 ±  9%      -0.1        0.23 ±  3%  perf-profile.children.cycles-pp.strcmp
      0.33 ± 11%      -0.1        0.19 ±  7%  perf-profile.children.cycles-pp.vma_interval_tree_augment_rotate
      0.30 ±  6%      -0.1        0.16 ±  6%  perf-profile.children.cycles-pp.mas_wr_store_type
      0.43 ±  3%      -0.1        0.29 ±  6%  perf-profile.children.cycles-pp.__vma_start_write
      0.42 ±  4%      -0.1        0.28 ± 22%  perf-profile.children.cycles-pp.eventfs_iterate
      0.28 ±  6%      -0.1        0.14 ±  5%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.29 ±  4%      -0.1        0.16 ±  6%  perf-profile.children.cycles-pp.perf_iterate_sb
      0.34 ±  6%      -0.1        0.21 ±  8%  perf-profile.children.cycles-pp.__legitimize_mnt
      0.33 ±  5%      -0.1        0.20 ±  5%  perf-profile.children.cycles-pp.allocate_slab
      0.39 ±  4%      -0.1        0.26 ±  9%  perf-profile.children.cycles-pp.generic_file_mmap_prepare
      0.22 ±  4%      -0.1        0.09 ±  9%  perf-profile.children.cycles-pp.sched_balance_rq
      0.29 ±  8%      -0.1        0.16 ±  4%  perf-profile.children.cycles-pp.file_close_fd
      0.19 ±  7%      -0.1        0.06 ±  7%  perf-profile.children.cycles-pp.__schedule
      0.18 ±  9%      -0.1        0.06 ± 15%  perf-profile.children.cycles-pp.ksys_read
      0.18 ±  9%      -0.1        0.06 ± 15%  perf-profile.children.cycles-pp.vfs_read
      0.25 ±  7%      -0.1        0.13 ±  6%  perf-profile.children.cycles-pp.zap_pte_range
      0.26 ±  4%      -0.1        0.14 ±  6%  perf-profile.children.cycles-pp.build_detached_freelist
      0.26 ±  7%      -0.1        0.15 ±  4%  perf-profile.children.cycles-pp.remove_vma
      0.24 ±  9%      -0.1        0.12 ±  8%  perf-profile.children.cycles-pp.security_file_post_open
      0.28 ±  7%      -0.1        0.16 ±  6%  perf-profile.children.cycles-pp.down_write_killable
      0.19            -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.sched_balance_domains
      0.23 ± 10%      -0.1        0.12 ±  8%  perf-profile.children.cycles-pp.mas_mab_cp
      0.24 ±  9%      -0.1        0.13 ± 10%  perf-profile.children.cycles-pp.nd_jump_root
      0.28 ±  6%      -0.1        0.17 ±  8%  perf-profile.children.cycles-pp.mas_update_gap
      0.15 ±  4%      -0.1        0.04 ± 45%  perf-profile.children.cycles-pp.seq_read_iter
      0.23 ±  3%      -0.1        0.12 ± 10%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.14 ±  9%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.schedule
      0.24 ±  5%      -0.1        0.14 ±  8%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.25 ±  3%      -0.1        0.14 ±  7%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.32 ±  5%      -0.1        0.22 ±  8%  perf-profile.children.cycles-pp.filp_flush
      0.23 ±  9%      -0.1        0.14 ± 10%  perf-profile.children.cycles-pp.get_partial_node
      0.20 ± 10%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.brk
      0.33 ±  6%      -0.1        0.24 ±  9%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.19 ± 12%      -0.1        0.10 ± 10%  perf-profile.children.cycles-pp.mas_prev
      0.19 ±  5%      -0.1        0.10 ±  8%  perf-profile.children.cycles-pp.fget
      0.16 ± 14%      -0.1        0.06 ±  7%  perf-profile.children.cycles-pp.asm_exc_page_fault
      0.16 ±  6%      -0.1        0.06 ±  7%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.15 ±  6%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.18 ± 11%      -0.1        0.09 ±  7%  perf-profile.children.cycles-pp.__do_sys_brk
      0.24 ±  6%      -0.1        0.15 ±  7%  perf-profile.children.cycles-pp.shuffle_freelist
      0.20 ±  4%      -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.get_state_synchronize_rcu_full
      0.18 ± 10%      -0.1        0.10 ± 11%  perf-profile.children.cycles-pp.ima_file_check
      0.17 ±  7%      -0.1        0.09 ±  7%  perf-profile.children.cycles-pp.tlb_finish_mmu
      0.11 ± 14%      -0.1        0.03 ±100%  perf-profile.children.cycles-pp.__handle_mm_fault
      0.25 ±  5%      -0.1        0.17 ± 12%  perf-profile.children.cycles-pp.process_one_work
      0.18 ± 10%      -0.1        0.10 ± 10%  perf-profile.children.cycles-pp.__virt_addr_valid
      0.23 ± 11%      -0.1        0.15 ±  9%  perf-profile.children.cycles-pp.security_inode_permission
      0.17 ±  7%      -0.1        0.09 ±  7%  perf-profile.children.cycles-pp.map_id_range_up
      0.14 ± 14%      -0.1        0.06 ± 13%  perf-profile.children.cycles-pp.exc_page_fault
      0.17 ±  5%      -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.verify_dirent_name
      0.13 ± 14%      -0.1        0.06 ± 13%  perf-profile.children.cycles-pp.do_user_addr_fault
      0.18 ±  3%      -0.1        0.10 ±  9%  perf-profile.children.cycles-pp.kernfs_refresh_inode
      0.15 ± 14%      -0.1        0.08 ±  7%  perf-profile.children.cycles-pp.stress_time_now
      0.12 ± 10%      -0.1        0.05 ±  7%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.14 ±  8%      -0.1        0.07 ±  9%  perf-profile.children.cycles-pp.current_time
      0.16 ± 10%      -0.1        0.08 ±  8%  perf-profile.children.cycles-pp.security_mmap_file
      0.16 ±  7%      -0.1        0.09 ± 11%  perf-profile.children.cycles-pp.fput_close_sync
      0.15 ±  9%      -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.memset_orig
      0.15 ±  8%      -0.1        0.08 ± 11%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.15 ±  4%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.mas_destroy
      0.15 ± 11%      -0.1        0.08 ± 13%  perf-profile.children.cycles-pp.set_root
      0.16 ±  6%      -0.1        0.09 ±  9%  perf-profile.children.cycles-pp.dnotify_flush
      0.14 ±  6%      -0.1        0.07 ± 14%  perf-profile.children.cycles-pp.locks_remove_file
      0.12 ± 14%      -0.1        0.05 ±  8%  perf-profile.children.cycles-pp.handle_mm_fault
      0.16 ± 12%      -0.1        0.09 ± 11%  perf-profile.children.cycles-pp.__check_heap_object
      0.15 ±  7%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.21 ±  6%      -0.1        0.14 ±  8%  perf-profile.children.cycles-pp.atime_needs_update
      0.13 ±  7%      -0.1        0.07 ± 10%  perf-profile.children.cycles-pp.fdget_pos
      0.13 ±  9%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.mast_fill_bnode
      0.14 ±  7%      -0.1        0.07 ±  6%  perf-profile.children.cycles-pp.memchr
      0.13 ±  5%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.security_file_release
      0.14 ±  6%      -0.1        0.08 ± 13%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.10 ±  3%      -0.1        0.04 ± 44%  perf-profile.children.cycles-pp.proc_pid_readdir
      0.13 ± 10%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.08 ± 11%      -0.1        0.02 ± 99%  perf-profile.children.cycles-pp.__d_alloc
      0.13 ±  8%      -0.1        0.07 ±  8%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.19 ± 11%      -0.1        0.14 ± 12%  perf-profile.children.cycles-pp.generic_update_time
      0.12 ±  7%      -0.1        0.07 ± 11%  perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
      0.10 ±  9%      -0.1        0.04 ± 44%  perf-profile.children.cycles-pp.build_open_flags
      0.13 ±  8%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.14 ±  6%      -0.1        0.09 ± 12%  perf-profile.children.cycles-pp.kfree_rcu_work
      0.11 ±  9%      -0.1        0.06 ± 13%  perf-profile.children.cycles-pp.__perf_event_header__init_id
      0.08 ± 10%      -0.1        0.03 ±100%  perf-profile.children.cycles-pp.setup_object
      0.10 ±  6%      -0.1        0.04 ± 45%  perf-profile.children.cycles-pp.fsnotify_find_mark
      0.08 ± 13%      -0.1        0.02 ± 99%  perf-profile.children.cycles-pp.make_vfsuid
      0.17 ±  2%      -0.1        0.12 ± 12%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      0.14 ± 10%      -0.1        0.09 ± 10%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.08 ± 16%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.fdget_raw
      0.09 ± 12%      -0.1        0.04 ± 71%  perf-profile.children.cycles-pp.__fput_deferred
      0.08 ±  6%      -0.1        0.02 ± 99%  perf-profile.children.cycles-pp.stress_mmapfiles_child
      0.17 ±  3%      -0.1        0.12 ± 13%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.10 ±  9%      -0.1        0.05 ± 47%  perf-profile.children.cycles-pp.mas_prev_setup
      0.12 ±  6%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.__fsnotify_parent
      0.10 ±  9%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.mas_next_sibling
      0.12 ± 10%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.get_unused_fd_flags
      0.11 ± 11%      -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.security_inode_getattr
      0.09 ±  9%      -0.0        0.04 ± 44%  perf-profile.children.cycles-pp.is_vmalloc_addr
      0.18 ±  7%      -0.0        0.13 ±  5%  perf-profile.children.cycles-pp.d_alloc_cursor
      0.10 ±  7%      -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.from_kuid_munged
      0.11 ± 10%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.07 ± 12%      -0.0        0.02 ± 99%  perf-profile.children.cycles-pp.kmem_cache_alloc_lru_noprof
      0.09 ±  7%      -0.0        0.05 ± 45%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.17 ±  8%      -0.0        0.13 ± 14%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.18 ±  7%      -0.0        0.14 ±  5%  perf-profile.children.cycles-pp.dcache_dir_open
      0.11 ±  9%      -0.0        0.07 ± 16%  perf-profile.children.cycles-pp.clock_gettime
      0.10 ±  6%      -0.0        0.06 ± 13%  perf-profile.children.cycles-pp.from_kgid_munged
      0.09 ± 10%      -0.0        0.04 ± 47%  perf-profile.children.cycles-pp.mntput
      0.13 ± 10%      -0.0        0.09 ±  8%  perf-profile.children.cycles-pp.unmap_single_vma
      0.10 ±  5%      -0.0        0.06 ± 11%  perf-profile.children.cycles-pp.d_lookup
      0.08 ±  9%      -0.0        0.05 ± 45%  perf-profile.children.cycles-pp.proc_sys_fill_cache
      0.10 ± 10%      +0.0        0.14 ±  8%  perf-profile.children.cycles-pp.pick_link
      0.12 ±  7%      +0.1        0.17 ± 12%  perf-profile.children.cycles-pp.event_hist_open
      0.02 ±141%      +0.1        0.11 ± 12%  perf-profile.children.cycles-pp.__page_get_link
      0.00            +0.1        0.09 ± 16%  perf-profile.children.cycles-pp.tracing_single_release_file_tr
      0.02 ±142%      +0.1        0.11 ±  8%  perf-profile.children.cycles-pp.page_get_link
      0.07 ± 22%      +0.1        0.16 ± 11%  perf-profile.children.cycles-pp.mutex_spin_on_owner
      0.21 ± 35%      +0.1        0.34 ± 12%  perf-profile.children.cycles-pp.vma_migratable
      0.25 ± 36%      +0.1        0.38 ± 12%  perf-profile.children.cycles-pp.task_numa_work
      0.04 ± 71%      +0.1        0.18 ± 13%  perf-profile.children.cycles-pp.tracing_release_file_tr
      0.38 ±  6%      +0.2        0.54 ± 12%  perf-profile.children.cycles-pp.lockref_get
      0.00            +0.2        0.17 ± 34%  perf-profile.children.cycles-pp.proc_sys_permission
      0.17 ± 11%      +0.2        0.36 ± 34%  perf-profile.children.cycles-pp.mon_text_release
      0.16 ±  8%      +0.2        0.39 ± 12%  perf-profile.children.cycles-pp.tracing_open_file_tr
      0.09 ±  9%      +0.3        0.36 ± 34%  perf-profile.children.cycles-pp.full_proxy_open_regular
      0.04 ± 45%      +0.3        0.33 ± 37%  perf-profile.children.cycles-pp.mon_text_open
      0.08 ± 14%      +0.3        0.41 ± 18%  perf-profile.children.cycles-pp.tracing_check_open_get_tr
      0.34 ±  8%      +0.3        0.68 ± 21%  perf-profile.children.cycles-pp.__traverse_mounts
      7.03 ±  2%      +0.4        7.42 ±  4%  perf-profile.children.cycles-pp.do_open
      1.08 ±  5%      +0.4        1.49 ± 13%  perf-profile.children.cycles-pp.try_to_unlazy
      1.04 ±  5%      +0.4        1.47 ± 13%  perf-profile.children.cycles-pp.__legitimize_path
      0.16 ± 29%      +0.5        0.64 ± 12%  perf-profile.children.cycles-pp.set_nlink
      0.74 ±  5%      +0.5        1.24 ± 12%  perf-profile.children.cycles-pp.down_write
      0.00            +0.6        0.56 ± 16%  perf-profile.children.cycles-pp.rwsem_spin_on_owner
      1.11 ±  2%      +0.6        1.67 ± 14%  perf-profile.children.cycles-pp.scan_positives
      0.68 ±  8%      +0.6        1.27 ± 14%  perf-profile.children.cycles-pp.lockref_get_not_dead
      0.00            +0.8        0.81 ± 17%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      0.08 ± 17%      +1.2        1.32 ± 15%  perf-profile.children.cycles-pp.__mutex_lock
      0.00            +1.3        1.25 ± 14%  perf-profile.children.cycles-pp.osq_lock
      2.22 ±  3%      +1.4        3.66 ± 14%  perf-profile.children.cycles-pp.lockref_put_return
      3.04            +1.7        4.75 ± 10%  perf-profile.children.cycles-pp.__do_sys_newfstat
      1.63 ±  4%      +2.0        3.61 ± 11%  perf-profile.children.cycles-pp.may_open
      2.08 ±  3%      +2.2        4.24 ± 12%  perf-profile.children.cycles-pp.vfs_fstat
      1.84 ±  3%      +2.3        4.10 ± 13%  perf-profile.children.cycles-pp.vfs_getattr_nosec
      3.02 ±  3%      +2.6        5.62 ± 23%  perf-profile.children.cycles-pp.dput
     10.45            +2.6       13.07 ±  9%  perf-profile.children.cycles-pp.lookup_fast
      2.16 ±  4%      +2.7        4.81 ± 29%  perf-profile.children.cycles-pp.step_into_slowpath
      0.96 ±  6%      +2.7        3.65 ± 14%  perf-profile.children.cycles-pp.kernfs_iop_getattr
      4.75 ±  2%      +2.8        7.57 ±  2%  perf-profile.children.cycles-pp.__open64_nocancel
      4.04 ±  3%      +3.9        7.93 ± 10%  perf-profile.children.cycles-pp.kernfs_dop_revalidate
      0.10 ±  7%      +4.1        4.22 ± 65%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      2.46 ±  2%      +4.1        6.60 ± 42%  perf-profile.children.cycles-pp._raw_spin_lock
     87.97            +5.5       93.44        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     87.47            +5.7       93.16        perf-profile.children.cycles-pp.do_syscall_64
      4.45 ±  5%     +14.8       19.20 ±  8%  perf-profile.children.cycles-pp.down_read
      3.42 ±  6%     +14.8       18.24 ±  3%  perf-profile.children.cycles-pp.up_read
      4.71 ±  5%     +22.7       27.44 ±  7%  perf-profile.children.cycles-pp.kernfs_iop_permission
      6.17 ±  4%     +23.1       29.30 ±  6%  perf-profile.children.cycles-pp.inode_permission
     34.38           +24.2       58.54 ±  2%  perf-profile.children.cycles-pp.__x64_sys_openat
     34.32           +24.2       58.50 ±  2%  perf-profile.children.cycles-pp.do_sys_openat2
     31.66           +25.4       57.07 ±  2%  perf-profile.children.cycles-pp.do_filp_open
     31.53           +25.5       57.00 ±  2%  perf-profile.children.cycles-pp.path_openat
     15.50 ±  2%     +28.8       44.28 ±  4%  perf-profile.children.cycles-pp.link_path_walk
      6.71 ±  3%      -3.8        2.95 ±  4%  perf-profile.self.cycles-pp.vma_interval_tree_insert
      2.77            -1.9        0.82 ± 14%  perf-profile.self.cycles-pp.__d_lookup
      3.14            -1.5        1.68 ±  4%  perf-profile.self.cycles-pp.mas_rev_awalk
      2.44            -1.1        1.29 ±  4%  perf-profile.self.cycles-pp.clear_bhb_loop
      1.68            -0.9        0.80 ±  5%  perf-profile.self.cycles-pp.__d_lookup_rcu
      1.17 ±  5%      -0.8        0.33 ±  8%  perf-profile.self.cycles-pp.errseq_sample
      1.25 ±  3%      -0.6        0.69 ±  5%  perf-profile.self.cycles-pp.its_return_thunk
      1.14 ±  2%      -0.6        0.58 ±  7%  perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.11            -0.5        0.58 ±  3%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.82 ±  3%      -0.5        0.32 ±  6%  perf-profile.self.cycles-pp.__build_id_parse
      0.90 ±  2%      -0.5        0.40 ±  4%  perf-profile.self.cycles-pp.do_dentry_open
      1.35 ±  2%      -0.5        0.86 ±  6%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      1.04 ±  2%      -0.5        0.57 ±  4%  perf-profile.self.cycles-pp.__fput
      0.95 ±  3%      -0.4        0.50 ±  4%  perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.67 ±  5%      -0.4        0.24 ±  7%  perf-profile.self.cycles-pp.may_open
      0.72 ±  5%      -0.4        0.29 ±  8%  perf-profile.self.cycles-pp.generic_fillattr
      0.88 ±  4%      -0.4        0.46 ±  5%  perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.87 ±  3%      -0.4        0.46 ±  4%  perf-profile.self.cycles-pp.do_syscall_64
      0.81 ±  6%      -0.4        0.40 ± 17%  perf-profile.self.cycles-pp.kernfs_dop_revalidate
      0.84 ±  4%      -0.4        0.46 ±  3%  perf-profile.self.cycles-pp.__cond_resched
      0.80 ±  3%      -0.4        0.43 ±  6%  perf-profile.self.cycles-pp.__mmap_region
      0.74 ±  2%      -0.4        0.37 ±  2%  perf-profile.self.cycles-pp.mas_walk
      0.76 ±  5%      -0.4        0.41 ±  4%  perf-profile.self.cycles-pp.filemap_get_entry
      0.50 ±  5%      -0.3        0.17 ±  4%  perf-profile.self.cycles-pp.dcache_readdir
      2.20 ±  3%      -0.3        1.86 ±  9%  perf-profile.self.cycles-pp.link_path_walk
      0.73 ±  3%      -0.3        0.40 ±  5%  perf-profile.self.cycles-pp.kmem_cache_free
      0.67            -0.3        0.35 ±  5%  perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.68 ±  3%      -0.3        0.36 ±  3%  perf-profile.self.cycles-pp.filldir64
      0.58 ±  6%      -0.3        0.27 ±  3%  perf-profile.self.cycles-pp.rb_next
      0.65 ±  2%      -0.3        0.34 ±  6%  perf-profile.self.cycles-pp.mas_ascend
      0.61 ±  2%      -0.3        0.32 ±  4%  perf-profile.self.cycles-pp.__mmap
      0.65 ±  6%      -0.3        0.37 ±  9%  perf-profile.self.cycles-pp.vma_interval_tree_remove
      0.62 ±  4%      -0.3        0.34 ±  4%  perf-profile.self.cycles-pp.stress_mmapfiles_dir
      0.67 ±  4%      -0.3        0.40 ±  5%  perf-profile.self.cycles-pp.pv_native_safe_halt
      0.43 ±  4%      -0.3        0.16 ± 13%  perf-profile.self.cycles-pp.xas_start
      0.57 ±  4%      -0.3        0.31 ±  5%  perf-profile.self.cycles-pp.strncpy_from_user
      0.67 ±  2%      -0.3        0.41 ±  5%  perf-profile.self.cycles-pp.__slab_free
      0.66 ±  4%      -0.3        0.41 ±  4%  perf-profile.self.cycles-pp.down_write
      0.55 ±  2%      -0.2        0.30 ±  6%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.53 ±  5%      -0.2        0.28 ±  7%  perf-profile.self.cycles-pp.__rb_insert_augmented
      0.48 ±  3%      -0.2        0.24 ±  6%  perf-profile.self.cycles-pp.scan_positives
      0.51 ±  4%      -0.2        0.28 ±  5%  perf-profile.self.cycles-pp.mas_preallocate
      0.50 ±  4%      -0.2        0.27 ±  5%  perf-profile.self.cycles-pp.__fstat64
      0.51 ±  6%      -0.2        0.28 ±  5%  perf-profile.self.cycles-pp.rcu_all_qs
      0.56 ±  2%      -0.2        0.33 ±  4%  perf-profile.self.cycles-pp.readdir64
      0.54 ± 12%      -0.2        0.31 ±  8%  perf-profile.self.cycles-pp.__rb_erase_color
      0.51 ±  3%      -0.2        0.29 ±  5%  perf-profile.self.cycles-pp.mas_next_slot
      0.35 ±  4%      -0.2        0.14 ±  5%  perf-profile.self.cycles-pp.kernfs_dir_pos
      0.45 ±  4%      -0.2        0.24 ±  6%  perf-profile.self.cycles-pp._copy_to_user
      0.46 ±  6%      -0.2        0.25 ±  5%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.51 ±  6%      -0.2        0.31 ± 13%  perf-profile.self.cycles-pp.step_into_slowpath
      0.44 ±  4%      -0.2        0.24 ±  8%  perf-profile.self.cycles-pp.mas_prev_slot
      0.45 ±  7%      -0.2        0.26 ±  4%  perf-profile.self.cycles-pp.mas_topiary_replace
      0.42 ±  2%      -0.2        0.24 ±  4%  perf-profile.self.cycles-pp.mas_data_end
      0.41 ±  5%      -0.2        0.23 ±  7%  perf-profile.self.cycles-pp.do_mmap
      0.41 ±  5%      -0.2        0.24 ±  4%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.38 ±  6%      -0.2        0.21 ±  6%  perf-profile.self.cycles-pp.kfree
      0.44 ±  5%      -0.2        0.28 ±  7%  perf-profile.self.cycles-pp.kernfs_fop_readdir
      0.34 ±  4%      -0.2        0.18 ±  7%  perf-profile.self.cycles-pp.__pi_memcpy
      0.31 ±  3%      -0.1        0.16 ±  5%  perf-profile.self.cycles-pp.fput
      0.38 ±  4%      -0.1        0.23 ±  7%  perf-profile.self.cycles-pp.lookup_fast
      0.36 ±  6%      -0.1        0.21 ±  4%  perf-profile.self.cycles-pp.kvfree_call_rcu
      0.33 ±  5%      -0.1        0.19 ±  2%  perf-profile.self.cycles-pp.x64_sys_call
      0.29 ±  6%      -0.1        0.15 ±  4%  perf-profile.self.cycles-pp.strlen
      0.30 ±  4%      -0.1        0.16 ±  8%  perf-profile.self.cycles-pp.mas_find
      0.30 ±  5%      -0.1        0.16 ±  2%  perf-profile.self.cycles-pp.__account_obj_stock
      0.32 ± 11%      -0.1        0.18 ±  8%  perf-profile.self.cycles-pp.vma_interval_tree_augment_rotate
      0.35 ± 11%      -0.1        0.22 ±  3%  perf-profile.self.cycles-pp.strcmp
      0.28 ±  7%      -0.1        0.15 ±  7%  perf-profile.self.cycles-pp.stress_time_now_timespec
      0.28 ±  3%      -0.1        0.14 ±  8%  perf-profile.self.cycles-pp.vfs_getattr_nosec
      0.29 ±  6%      -0.1        0.16 ±  6%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.30 ±  6%      -0.1        0.17 ±  9%  perf-profile.self.cycles-pp.mas_spanning_rebalance
      0.28 ±  5%      -0.1        0.14 ±  5%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.32 ±  4%      -0.1        0.19 ± 13%  perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.40 ±  3%      -0.1        0.28 ±  7%  perf-profile.self.cycles-pp.__vma_start_write
      0.27 ±  9%      -0.1        0.14 ±  5%  perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.26 ±  5%      -0.1        0.14 ±  8%  perf-profile.self.cycles-pp.mab_mas_cp
      0.25 ±  6%      -0.1        0.13 ±  9%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.31 ±  5%      -0.1        0.20 ±  8%  perf-profile.self.cycles-pp.__legitimize_mnt
      0.29 ±  3%      -0.1        0.17 ±  7%  perf-profile.self.cycles-pp.mas_wr_node_store
      0.25 ±  4%      -0.1        0.14 ±  5%  perf-profile.self.cycles-pp.build_detached_freelist
      0.28 ±  3%      -0.1        0.17 ±  6%  perf-profile.self.cycles-pp.dput
      0.25 ±  5%      -0.1        0.14 ±  5%  perf-profile.self.cycles-pp.init_file
      0.23 ±  3%      -0.1        0.12 ±  8%  perf-profile.self.cycles-pp.cp_new_stat
      0.22 ±  6%      -0.1        0.11 ± 10%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.22 ±  7%      -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.26 ±  6%      -0.1        0.15 ±  8%  perf-profile.self.cycles-pp.unmapped_area_topdown
      0.26 ±  6%      -0.1        0.15 ±  7%  perf-profile.self.cycles-pp.___slab_alloc
      0.23 ±  6%      -0.1        0.12 ±  5%  perf-profile.self.cycles-pp.refill_obj_stock
      0.20 ± 10%      -0.1        0.10 ± 10%  perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.21 ±  6%      -0.1        0.11 ±  9%  perf-profile.self.cycles-pp.mas_store_gfp
      0.24 ±  3%      -0.1        0.14 ±  8%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.20 ±  8%      -0.1        0.11 ±  6%  perf-profile.self.cycles-pp.unmap_page_range
      0.18 ±  5%      -0.1        0.09 ±  7%  perf-profile.self.cycles-pp.fget
      0.20 ±  4%      -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.get_state_synchronize_rcu_full
      0.22 ±  7%      -0.1        0.14 ±  7%  perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.17 ± 13%      -0.1        0.09 ±  8%  perf-profile.self.cycles-pp.mas_mab_cp
      0.19 ± 10%      -0.1        0.11 ±  7%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.16 ±  8%      -0.1        0.08 ±  6%  perf-profile.self.cycles-pp.do_open
      0.16 ±  7%      -0.1        0.08 ±  7%  perf-profile.self.cycles-pp.alloc_fd
      0.13 ± 11%      -0.1        0.06 ± 13%  perf-profile.self.cycles-pp.xas_load
      0.15 ±  6%      -0.1        0.08 ±  7%  perf-profile.self.cycles-pp.getname_flags
      0.16 ±  6%      -0.1        0.09 ±  5%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.16 ±  8%      -0.1        0.08 ±  8%  perf-profile.self.cycles-pp.path_openat
      0.18 ±  4%      -0.1        0.11 ±  9%  perf-profile.self.cycles-pp.down_write_killable
      0.15 ±  7%      -0.1        0.08 ±  9%  perf-profile.self.cycles-pp.mas_split
      0.19 ± 15%      -0.1        0.12 ±  8%  perf-profile.self.cycles-pp.security_inode_permission
      0.15 ±  8%      -0.1        0.08        perf-profile.self.cycles-pp.prepend_path
      0.14 ±  5%      -0.1        0.08 ±  9%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.16 ± 10%      -0.1        0.09 ± 10%  perf-profile.self.cycles-pp.fput_close_sync
      0.21 ±  6%      -0.1        0.14 ±  7%  perf-profile.self.cycles-pp.d_same_name
      0.15 ±  8%      -0.1        0.08 ±  8%  perf-profile.self.cycles-pp.map_id_range_up
      0.13 ± 12%      -0.1        0.07 ± 11%  perf-profile.self.cycles-pp.check_heap_object
      0.14 ±  8%      -0.1        0.08 ±  6%  perf-profile.self.cycles-pp.memset_orig
      0.18 ±  5%      -0.1        0.11 ±  7%  perf-profile.self.cycles-pp.shuffle_freelist
      0.14 ± 10%      -0.1        0.08 ±  6%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.09 ± 11%      -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.build_open_flags
      0.14 ±  7%      -0.1        0.07 ±  6%  perf-profile.self.cycles-pp.getdents64
      0.14 ± 10%      -0.1        0.08 ± 10%  perf-profile.self.cycles-pp.set_root
      0.16 ±  7%      -0.1        0.09 ±  9%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.15 ± 12%      -0.1        0.09 ±  7%  perf-profile.self.cycles-pp.__check_heap_object
      0.16 ± 10%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.get_partial_node
      0.16 ±  4%      -0.1        0.09 ± 11%  perf-profile.self.cycles-pp.kernfs_refresh_inode
      0.12 ±  7%      -0.1        0.06 ± 11%  perf-profile.self.cycles-pp.locks_remove_file
      0.12 ±  8%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.open_last_lookups
      0.24 ±  5%      -0.1        0.17 ± 17%  perf-profile.self.cycles-pp.kernfs_iop_permission
      0.14 ±  6%      -0.1        0.08 ± 13%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.13 ±  7%      -0.1        0.07 ±  7%  perf-profile.self.cycles-pp.memchr
      0.12 ±  9%      -0.1        0.06 ±  9%  perf-profile.self.cycles-pp.__munmap
      0.13 ± 11%      -0.1        0.07 ± 11%  perf-profile.self.cycles-pp.vm_area_alloc
      0.12 ± 10%      -0.1        0.07 ± 14%  perf-profile.self.cycles-pp.do_filp_open
      0.08 ± 14%      -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.12 ± 16%      -0.1        0.06 ± 11%  perf-profile.self.cycles-pp.mas_prev
      0.09 ± 14%      -0.1        0.04 ± 71%  perf-profile.self.cycles-pp.zap_pte_range
      0.12 ±  5%      -0.1        0.06 ±  7%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.11 ± 10%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.get_unused_fd_flags
      0.08 ±  6%      -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.unlink_anon_vmas
      0.11 ± 12%      -0.1        0.06 ± 11%  perf-profile.self.cycles-pp.security_inode_getattr
      0.11 ± 12%      -0.1        0.06 ± 13%  perf-profile.self.cycles-pp.__virt_addr_valid
      0.12 ±  6%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.__fsnotify_parent
      0.11 ± 13%      -0.0        0.06 ± 16%  perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.11 ± 11%      -0.0        0.06 ± 13%  perf-profile.self.cycles-pp.__check_object_size
      0.11 ± 14%      -0.0        0.06 ±  9%  perf-profile.self.cycles-pp.unmap_vmas
      0.10 ± 20%      -0.0        0.06 ±  9%  perf-profile.self.cycles-pp.stress_time_now
      0.11 ± 11%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.path_init
      0.10 ± 10%      -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.mas_next_sibling
      0.08 ± 16%      -0.0        0.04 ± 72%  perf-profile.self.cycles-pp.clock_gettime
      0.09 ±  7%      -0.0        0.05 ±  7%  perf-profile.self.cycles-pp.do_sys_openat2
      0.10 ±  7%      -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.mas_store_prealloc
      0.11 ±  6%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.free_pgtables
      0.12 ± 10%      -0.0        0.08 ±  9%  perf-profile.self.cycles-pp.unmap_single_vma
      0.08 ±  8%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.__legitimize_path
      0.09 ±  7%      -0.0        0.05 ±  7%  perf-profile.self.cycles-pp.alloc_empty_file
      0.08 ±  8%      -0.0        0.04 ± 45%  perf-profile.self.cycles-pp.mas_update_gap
      0.11 ± 14%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.kernfs_fop_open
      0.10 ± 12%      -0.0        0.07 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.07 ± 22%      +0.1        0.16 ± 11%  perf-profile.self.cycles-pp.mutex_spin_on_owner
      0.21 ± 34%      +0.1        0.34 ± 12%  perf-profile.self.cycles-pp.vma_migratable
      0.49 ±  5%      +0.2        0.66 ± 11%  perf-profile.self.cycles-pp.mutex_lock
      1.02 ±  4%      +0.5        1.47 ± 10%  perf-profile.self.cycles-pp.inode_permission
      0.15 ± 32%      +0.5        0.62 ± 12%  perf-profile.self.cycles-pp.set_nlink
      0.00            +0.6        0.55 ± 16%  perf-profile.self.cycles-pp.rwsem_spin_on_owner
      0.66 ±  9%      +0.6        1.24 ± 15%  perf-profile.self.cycles-pp.lockref_get_not_dead
      0.00            +1.2        1.24 ± 14%  perf-profile.self.cycles-pp.osq_lock
      2.17 ±  3%      +1.5        3.63 ± 14%  perf-profile.self.cycles-pp.lockref_put_return
      0.10 ±  5%      +4.1        4.20 ± 65%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      3.36 ±  6%     +14.8       18.16 ±  3%  perf-profile.self.cycles-pp.up_read
      3.94 ±  5%     +14.9       18.82 ±  9%  perf-profile.self.cycles-pp.down_read




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


