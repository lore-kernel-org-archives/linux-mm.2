Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1F6C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 06:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16806B0089; Fri,  8 Aug 2025 02:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C75C6B008A; Fri,  8 Aug 2025 02:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88ED26B008C; Fri,  8 Aug 2025 02:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7734B6B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 02:11:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A823F1414C4
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:11:07 +0000 (UTC)
X-FDA: 83752567374.26.7709DB7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 39B6918000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:11:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZiZ9guuU;
	spf=pass (imf24.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754633464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaZ6Ek+6rzIDnTX7P5wxzrhK/3/5agObd+aG+f7dIwg=;
	b=Xyob/D8vjVt028VQeSLtY/45ft0gzl3sqc1ETgVKvDiyPkQ1PS0Z2HXLjGXABL9UxvoRt2
	E7VutNL2qbex5ECmyXw1G+dLLfgW+UYceym+fVEasReZ6Yj+KfA+rLTQyXFDAt4HXsItCq
	GUadBcyPTnC/tXN7ir6tipbHD+B/mJ4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754633464; a=rsa-sha256;
	cv=fail;
	b=lbb8i8Dbiy8QMHy/LgD7g4pCeBqrNkqjP+1EQSGn+8QpGEGT0SKMdMf6O9m2OfQJiYAb1H
	s5jSuWqgBjWbd8tDT0POl4zCYMXYBGgaBY3y1ov+vlzyjF088NP49BsVaoju2L/CeWA9ur
	m5g9i+2xiGafA6fIr/541OEDX2+S5a0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZiZ9guuU;
	spf=pass (imf24.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754633463; x=1786169463;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4iLgY8IcTSvxkN+8Ipg/jvqxd1Skh6ZXkUCFJCdC0Lk=;
  b=ZiZ9guuU1D/AZR4r7qm6Oa/qE4BWT9ZQAijGO08HSMcwmVD/lGGbNoqd
   t2BlLyVZ3PI3KcF7J3o7XFUxd9tB+uE883X2uZ9718v/vJIrH6RRLiCH2
   pgzo/mO5Ri3S5piPby6EcEYJ1Z/E7/H23a6u/EEVxX5FJDl3pcx11t89Z
   KnlQHvI6KZXjHxmDJ6y5m1P1kahWlB1E+dEnOs6Ak8jE7xaXaTmrjqSdr
   1XmlXLplJHp2FxaB7Sfd3BJ8O5jKj9qd03Og/90cYwKHRbq0B/FYtvhei
   3cz0pt1gljvCteYeRg+85kev3SNFxMxA6q78mSvxn2m9s1E8Lu6iN/w5T
   w==;
X-CSE-ConnectionGUID: wCgVG/ESS2ORfoEWH+XMAQ==
X-CSE-MsgGUID: 1TphcBWKQROquwVFlritQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57110178"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="57110178"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 23:11:01 -0700
X-CSE-ConnectionGUID: qS86rPRZQCCsmnhBWt0ckw==
X-CSE-MsgGUID: YJuErNaNTe6UzXmAbf5OSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="165588086"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 23:11:01 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 23:11:00 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 7 Aug 2025 23:11:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.68)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 23:11:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOg91Ya1ncZFbs3cjVDO6/wdErh17drRheCg9+4n0pjUMVbirvYcSbVhodF2HeeeXUGhrwoszz6pXQfkhuPErvB9i7ojg6cDuHZSaBxa4DXD6BV+2Pr1pTJA27DwhZ+n0xgtuOEtQxnP98XhQ3/YyR16dTjXo89u2HZe2VKB/p811UgLeJ9ic0I/PU7mbswr0CL84cKYgluHpAefeAteP1UTRGSiR5nQhM1Mx9sBTFm/z377wv9cHT9xPpHLktoP/xz3ZF/WSAubWHwQGYHcTKywMurlYxyGQRaWD7MIc2C94wdb8KQ4rh7szy3G2tIcaFivs+2jgAOzaht6izWjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaZ6Ek+6rzIDnTX7P5wxzrhK/3/5agObd+aG+f7dIwg=;
 b=Qug1zITRTbR7w4XdXAUN3mlWAs/KP4heHJMuHz/UFU95fcMFEED952X62K7qWPQopP3zBrY+1y+a0sNzkORuVKSs6Po0BfRgn/4bm35UofvqYRyJmXT7PdPSujLXlGJ0C5JkGCYZPcxju3hypfPWLrJgaTeO8qCPDame11S6auGMU7EW/d0x8IMW4ornpghOy6qxjZ2W4gRjteHiNYFuZDOufBP8iUSaBMS08prEBlQDxZ6UMfIxxbbD1WZwkmz6uGvJN9PBXJIhiW2U1BEH9xRBq4ESGgRM0R4wZ7SVMwnPL63r12o9jSpK4zuxMHGnTxQIOXQmdf6ck6c6JVrwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10)
 by SA0PR11MB4640.namprd11.prod.outlook.com (2603:10b6:806:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 06:10:58 +0000
Received: from PH0PR11MB5674.namprd11.prod.outlook.com
 ([fe80::77d3:dfb2:3bd:e02a]) by PH0PR11MB5674.namprd11.prod.outlook.com
 ([fe80::77d3:dfb2:3bd:e02a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 06:10:58 +0000
Date: Fri, 8 Aug 2025 14:10:49 +0800
From: Philip Li <philip.li@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, kernel test robot
	<lkp@intel.com>, Suren Baghdasaryan <surenb@google.com>,
	<oe-kbuild-all@lists.linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>, Vlastimil Babka
	<vbabka@suse.cz>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references
 non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Message-ID: <aJWU6RA+t1XpJLY/@rli9-mobl>
References: <aJRS3iAcvITYGKxq@rli9-mobl>
 <20250807155805.25652-1-sj@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250807155805.25652-1-sj@kernel.org>
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5674:EE_|SA0PR11MB4640:EE_
X-MS-Office365-Filtering-Correlation-Id: de3cdd46-ba1a-439c-caae-08ddd6425796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0DEcZ2faGZXaSAbTkt4ld/dmJxcsCkpYyG9IoMyQjaewB9uyEsA4U85gGfr7?=
 =?us-ascii?Q?aZcRo1E7dKds7HfxA4/JtUpuUV6tsUU2+ET6cYVM88QrDnaLHiuR5+BW46nA?=
 =?us-ascii?Q?16U2gEDV14KtoYyMDNDPnMqBPxh+j7A/SrEzPCAIbN8+0Hx8HAplfW5Xe+wi?=
 =?us-ascii?Q?PEvuqlAAVpNQitNwGu947qLjjT+/Dfa4jS9BydAoNuLaOfWjwiFLW53JJJuE?=
 =?us-ascii?Q?LavDWLy9aAD2/8862Jcel0RwjxLqDlaSlqE5rcfcW9chexCLPBl5wB9k9lPJ?=
 =?us-ascii?Q?8scViMWMRn5DuWbQS+fV0e+Y3uF+wmBx7M/ikkLwU3KA8FAYj0AT9hdURx/t?=
 =?us-ascii?Q?gpGScZYKJC8P0P2S3WY/9U/KYI4I/j/nYy+hvNKT5y0HYLjnEzKkfEcsAxGm?=
 =?us-ascii?Q?oZKVCtBxpEvIcfVxkcsfHxdl3OplwzLjWoFJybUSWP6vLgAw6QveOA2szxRc?=
 =?us-ascii?Q?zx4XmC8kJw5cYIYqZMENkPPuiKAd0kr16wU5NQtr4BK5dsxeuYwCSNG4vzyl?=
 =?us-ascii?Q?K2wk+HnSKycGvqK0dHZamVMdnXV7WCtgusQ6/G/w6/lhDd9qAR+FKFPtf3c6?=
 =?us-ascii?Q?MthMlX1l/VomILzoOWZOL7w+QhuZUYscfgx079Yss53nW1lbfEpy8X47BlIl?=
 =?us-ascii?Q?Rd+eydmjdG17+s/MZ12M62SEOxiKfYHue91WO+70hKKcaa0dZgnPc1GFdw8u?=
 =?us-ascii?Q?GQ/F8fzuCTbr1o9Z9ZEqfXkcmgLQUQfXnJKNL78juo6eYWv4MyR0Mpr/z8R0?=
 =?us-ascii?Q?QPewk7FjqnWN5XuZysJwmiyfs9I4P5Oi0n4wRhDpE7XqiyxlWObMg5ocqR2Z?=
 =?us-ascii?Q?UGOZbNcFzev7tGWowu+20C1LJvaVzb7szW9FmW0oQLBrwLdS0CG02JogBEgx?=
 =?us-ascii?Q?oLAsV5v3yRz+byyLWTctYMvYGAJv+AQ68ww8ZkVH2ZaAWoKirX2RQkyHfV91?=
 =?us-ascii?Q?3Qa8LYZJExIvAewF95OGnBaw+10/wpr2y9lQeTuCnZifjgScQQztFUVsL8KT?=
 =?us-ascii?Q?Jd4xHOjkhiyhnGb2h1XYGFIUhjzaJ/0KNPY1vd4tvzwzaL5Ml7hJQSnilscQ?=
 =?us-ascii?Q?nnSIo8O9wdFBGofDczKZZFqp1zZ0l5ZoUcrTtD/SkC2Ri/HumQeFgmj6Sbg+?=
 =?us-ascii?Q?rf2DvIMK1V3tjMZpfxz7C6+JrCDQKlT+redIY4WuZcRFVDp2j/0IKRuFJDBJ?=
 =?us-ascii?Q?urrf/gv59soIwC1YDpR5sY3+BtDNmC+3UP9LO+cg3hIsFoTiSPrt4qdaguey?=
 =?us-ascii?Q?B6Vzfz9RdWKJtyNu36eP0J167yiQIHB79XfYVs7rrTVPPFjkKOXJTPbG0Akp?=
 =?us-ascii?Q?Vj/9UtrBLVpsZjpMe4Ziba85ny6w8NQZDROLikev2sd4dP5CuhL1F8KFA7Ce?=
 =?us-ascii?Q?4vGFVXBEEflzOoWktV7N3uIKoi4rLy8ZVRkLz7ySnIKTb0kXAENjO/8J1aKE?=
 =?us-ascii?Q?c3YQ6NK7ejo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5674.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzQTJBJQ+EhubYttdi4H1tuqdzgryGyBkDcgsz7d2X4DuvxakOi48sQXb5Bf?=
 =?us-ascii?Q?7fzN6e7UGJtl2HWrdCYffLetjv/Pequ5PvV5U98943R7h2qg0X2+sjGvGFDF?=
 =?us-ascii?Q?4+8JOdM8VW1hbCrTBo2Eih0iVPH/GZ5JL4XEpa22vWN5O9ZTqU6Q9GIr2l7p?=
 =?us-ascii?Q?AQ//whDckchMjquzJkBOtWc6o108bBwY27ryR0zR0mfYO1s8X9BD0XoeKGT4?=
 =?us-ascii?Q?zwZv7WgPYWtzhaw89qvWsfN/rWipwq6mb0DBRodscuNDHH1cAoFYSe0H2esB?=
 =?us-ascii?Q?IV9PrH1HO0HeWuROaQ5w8/Xr2vYaAk/VA5D/yMfN8nCmEX/4yiHtCSHs55tH?=
 =?us-ascii?Q?zoUQCmsqLkIJWOwlNTSoefEtEIhGDADJdqqYew1FB6Pgfh8wuADlbm44n1Et?=
 =?us-ascii?Q?JPIvOAoyQ12to8L6Wnx6/O9YU0g5PWqiIIAa/9cmINrT9XzL3PU4wguavsO6?=
 =?us-ascii?Q?/VYzwdFntdAcdqVwHkgoHx9DjtrjYUgpX9m8Hb31kRbeM2IydmTRT0t3RY9R?=
 =?us-ascii?Q?uqMmZbZmY4U4cleTgPeVPndX6oNJDsW3OxUcJj5Lwx9W5GGCzU12wAtQRMQG?=
 =?us-ascii?Q?hHMRouDIaG9p7fn1aEt13CP+4au70v5VIcxdptXVQz139zt/jXVZVAhOflpg?=
 =?us-ascii?Q?Z5dg+3NCIWSjDwt6xMhW8K90undMkxjBfB7Zk+ojVTcXHq1sUfuxhhpodVeX?=
 =?us-ascii?Q?xuu56g0WTcDbClQZITTjIC1ZOOV8xmi5IE9JEIFUuqjdHjHbeEMsAEGNK7r/?=
 =?us-ascii?Q?jf96t5OWJTIcSIP5xRM3gt7wSew9tu+pnjtG3TdmgSFVVNUiROYyf7bGSQ3B?=
 =?us-ascii?Q?lf2BaI7xTIMCZmQos46PaSHNH098tXO41VxDHb1CTgjO9L7IcYEeqQR1vgld?=
 =?us-ascii?Q?lVSfZjz65AGxFEHzOcvq4/w8jJnyk9cPEI91TW1JROwJf+dIWXo+6szQzDGH?=
 =?us-ascii?Q?coCRtOd3AR053WiULDOs5y3PR9FQ7l76F5jh2/Ri+so6LAGiBD05LjQrtPAD?=
 =?us-ascii?Q?qUv4DbrYE3cdAV8y0NcJmXPW0zuzCClhNM36aw0+fnBITveOehw6vZojUE3b?=
 =?us-ascii?Q?I65L3cLedywWk/LvnY1I8P9Bk3WBFJ8NeFo0BUjql8uzDhEmq5cbaBPIE/Fd?=
 =?us-ascii?Q?awzdIKZcGg2TEYxBBW0UOowuv/7GJf78C5+V7zRNx28ZCh9qqJf7eUDH84YN?=
 =?us-ascii?Q?UMxV6IF7hRD8RYDZapBhtjcGF8Im2iTuDimKNu4zOloWb9EkccnGYJLwjRJC?=
 =?us-ascii?Q?1PJWeF6bcV/WO8R822mpvxzHmhyEmSQJzUsHj/xLlEO7RF1hHdPtmZj9Zl5L?=
 =?us-ascii?Q?FZA0nuPfAq8TarLlWiebMdQxGm/QC3YvcfqALmoqfrDRAJUX+7YYFmDvmJAb?=
 =?us-ascii?Q?8y0T0jgVeSCndseTmHfiAH2aIhs16JPxJIczUPpFcNoJ1X2wG+QXKkhLpnnh?=
 =?us-ascii?Q?mwBnZoUXlPmiNRGysTrTfIBXRZ+PkgZhA6KdXHwot0l6md0X1n4QmLVNHqRl?=
 =?us-ascii?Q?8R3jGOGoAE32k4bx9+Rltu47ci+0HIcthO9ufv9nYoOmXSG0Xlt3TUZ6cFCv?=
 =?us-ascii?Q?e8v54a6MGtCKT0mZJ729jmCG6ivY4754ISuzchFn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de3cdd46-ba1a-439c-caae-08ddd6425796
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5674.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 06:10:58.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCMni6uJa7dKQj9b4KLKKfsTySZ6Y9ww/uvuXwJxVnYhb3kRdgAQm5do05MPg0QPGFHcFQgIE4JdJC+d4TLqsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4640
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 39B6918000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 67mxm4161hhpuk5aoz9uj43r5bey1qi3
X-HE-Tag: 1754633463-140019
X-HE-Meta: U2FsdGVkX1+WNPpX3ZXsF5m+sflTDOnuSnRk7m0FlMuKfW27Y38Ea5QP5Nr/AAyPJBBbHwg3ZKF/3qEEwC4Pc52kqFsQPlsY1goNxPIhRteLpoZnP8+CZ3+qpVD4frARAFRi2yuUDyKLYDlziNVLyWmtts/hvurrBhwAnROv37L/ElEX2ozBG91sEMyMZ1SQbNB1mMP3w7XOXnFhfcuz2DN2MXGH1KGJNZ3+f0SwIqWwLJoa1bcpUPEj+zDFMmSg/d/FqdqG0W86Xcl++Wy9zitLI4S/baXmJn3B3qLYXMoGMhv8kp6JFmIr+g9B8l87dMZC4qKKFFV4jm/QjiyMV3abUo8jJE7IJiN2y3LuYtNwiFUMzWVHJXNMd6jW7WQZUoVNqCdJPpev7v3AcPKCYCRHnSXlQpFIWEtHuS/Vo/oiQAl0CAia/e050AjnZzFCZmQgmPvbN2odBNA2Kg5Dh917cA5Jx1ARqRMBM00jGdi40LX9JJsZ13DMlgsPuTlcAUuKXmgK/HUPVTW4GyQFoRdlBgExFL0RwZdEeXxHOzJW97kYqOTsuUPrrEocr/yzNTIacSaH/2OALEnaecU/KNlvdtTTJDYW3QUZR0ns1PfTOyCtNgQ4sJi4yoZIFWSosZ1cI8yAx/JIoS58OmPOj/dg0KBv5lrrJQfgvd0TQTxQHW1E5yPK1BwEUFEGcAGzwMroNNVaKeB7ez3Z0cy9Ukn9e84PX22frlKYVT4W8qcaxEDK8fWan6Y8NJ+9FuGSoPYFxV0StDdZknBcn5DlLV40gSF/JcfAFgW2IHb4Ooh01EMpCAZuIMTwMpEBKqPIkFXkZHjNwiaU72ryimMADtp9clNuE8xwdYACkbLtR7WZeKs5sajddnsNelxag+0Yohny1Af1IjP5/GjkNdtsnhLmL+94A4TTKGbLf7dmJHYSbyjlsRtrJdT0W5Vq0PL/5j05N8WcltQJogQSfz5
 dFqbci6y
 /Y4gTK+5pwNUziNhB7IQNvOkk91KGUuph1/a7rkckZPv38YzfNuDkoF8GI+7hTs1UxlZaNH/Tt3WCTZjvGxTfE8MsjXEiv4K/lQpe2O1YAYqIy0dI3/GmiuMT6atFHIz5vq8+ukI7dBfw8pCRXQeJ3rWG1ko3r6Svoh5DE+1/X0jrm1ANHOL6xlUk5Br8kzuTpxdL9++CMcZvTkSo3H0oFhnRApMtZdABe2wqB+dQ9BqlX2aksyuQEdmQ7II3wYB8Sx+2LLyYwXkaKVc2gD+Ft6YOZqWswwuF+mHEyMAeogapfywJYimfLFemPM6FrHXiikyzX4udBqPJLiUoA20E8yELgTd3WRSxg4KFRX1RZpTdZsaIyNs+2twX8sAbemnwDPQlReW3JZDhAcdfdyQJSIiL/swCmM9chxN9/UC8TLZs/YZQIelwS9/PWWuj2zT/0ZZ2H2vFBX5f2QtRONErewTSF1/3oddJxNIj2iw6/aZhKjWX1J1fKdIJvK5Bmk5+U7Uf4xdLTX0blkfcNotxf7pq0aR0vh6vWQMHSubMbvfBpzYKlGW07dkH/QKVmb40Jq8iixKwP9CWVd0mJQBpTq/fLbvyU0rzuqRD7vzR5xsohx7AgBDVA27FiOJQ8Y87IOCMMQzXKDyCcsqNLlTN7oy3wR5q1IR+zL2vKqf/fbRbuBjs6FRlVABj4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:58:05AM -0700, SeongJae Park wrote:
> On Thu, 7 Aug 2025 15:16:46 +0800 Philip Li <philip.li@intel.com> wrote:
> 
> > On Wed, Aug 06, 2025 at 10:51:38PM -0700, SeongJae Park wrote:
> > > On Wed,  6 Aug 2025 22:43:49 -0700 SeongJae Park <sj@kernel.org> wrote:
> > > 
> > > > On Thu, 7 Aug 2025 06:31:25 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > > > 
> > > > > +cc SJ, as his tree :)
> > > > 
> > > > Thank you, Lorenzo!
> > > > 
> > > > > 
> > > > > On Thu, Aug 07, 2025 at 12:03:03PM +0800, kernel test robot wrote:
> > > > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
> > > > > 
> > > > > Not sure why SJ isn't cc'd when it's his tree?
> > > > > 
> > > > > Not sure how easy it would be for the scripts to figure this out.
> > > > 
> > > > As people might already realized, it is Andrew's mm-new branch.  I started
> > > > pushing Andrew's mm-{new,unstable,stable} branches to my tree for backup
> > > > purpose, since DAMON development branch (damon/next) is using mm-new as its
> > > > baseline.  Seems it caused confusion to kernel test robot and other people.
> > > > Sorry about that.
> > > > 
> > > > kernel test robot, is there a way to mark mm-{new,unstable,stable} branches on
> > > > my tree be ignored from your tests?  If there is no good way, I can remove the
> > > > branches from my tree.
> > > 
> > > To stop more confusion first rather than waiting for the answer, I just deleted
> > > the mm-{new,unstable,stable} branches from my tree.  I don't really depend on
> > > those branches on my tree since I can keep fetching Andrew's tree or using my
> > > trees outside of kernel.org.  So this is no problem for me.
> > > 
> > > kernel test robot, please let me know if there is a way to mark specific
> > > branches on my tree be ignored from your tests, though, if you get a time and
> > > have an idea.
> > 
> > Yes, the test bot supports this to ignore branches by pattern, for example,
> > 
> > 	branch_denylist: .*-wip|.*-v[0-9]*|.*-[0-9]*
> > 	branch_denylist: mirror/.*
> 
> Cool.
> 
> > 
> > Do you want to just ignore mm-{new,unstable,stable} branches, I can configure the
> > repo to handle this?
> 
> Great, could you please do so?

Got it, this is configured now.

> 
> 
> Thanks,
> SJ
> 
> [...]

