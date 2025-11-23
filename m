Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86693CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 06:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4136B00AE; Sun, 23 Nov 2025 01:53:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CF96B00AF; Sun, 23 Nov 2025 01:53:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FE16B00B0; Sun, 23 Nov 2025 01:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80A8D6B00AE
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:53:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39E601A0A81
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:53:53 +0000 (UTC)
X-FDA: 84140956746.17.F058AEF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3C98C180009
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:53:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QMF8eaad;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763880830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JFBiZrrJ7Aqm1lWlRd5g39C8SO9CDjKSgFNcHO57Zc0=;
	b=b+2D5v+QROe05iolVCFAJYt1ZoWkZktyIIgNfVpL/zjQ3RYkIsTgP9TxAjCcRZG6kbMy4K
	K+6ebiT3sZt+FK3ISspxEra2t2lb8+ww8GSwPSuqOobaNkkCeolyEd6dJQJTEKtE0lr22P
	0iMTIGHQzhiMdDuTho1fvH5IItae9Ic=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763880830; a=rsa-sha256;
	cv=fail;
	b=f0LPtVSgPFxXFYBtC7/dVu8wXQL3pGivHWckYUbZQYh1IYMU9u8ilJrXW0oCXaj6RUrRHI
	O8nisEntPrdTK1x4ZHRyEhLWhGNFHQEVTs7kRnd65ORU/XfZrhhqnx+eSsQI+NGFkukIDv
	0OtMqeGgk+sXo1OpG90kN+FaRVKl47A=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QMF8eaad;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763880829; x=1795416829;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SzpOmmbTbvF34pEaiRu4gJqMa8TGtBYTnB4uP+i6x7s=;
  b=QMF8eaad1JyN3aakdXMynhjLT5SHRDZnKvD8e9mrVRyLkEiNTHwCtUEc
   Jrt4XMfn9jEhxpvcO2ZAg29q8qqSkBXJZpxLcfOHiSRBxDD+Yt1U35mdj
   igLxv7MB/nbVdtPZYwHp3ZdJz/HZv1XCmlaLhfyjozlR05fAE+/bZAKqu
   n9ELbeODzDQK0TfrzDmDw5thuJj251Ik5BSQqqXAeNLCh7tuZi1KjjAOL
   Jb9nKGQ4duSBOnqYmVCueBcMsBgvY+hGnYX/bQVq/ChaThUFR2NGOoxR+
   +JakQ8/k6I0KjZClTBkOiXnPi9frOsDQ6Lv+xtS7Wy+zHv2hPUgSWeCEQ
   w==;
X-CSE-ConnectionGUID: ZZmXCVBqRF63175WK4paSw==
X-CSE-MsgGUID: dre7pK/yRbC8T6GpC0G5cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11621"; a="64918170"
X-IronPort-AV: E=Sophos;i="6.20,220,1758610800"; 
   d="scan'208";a="64918170"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 22:53:48 -0800
X-CSE-ConnectionGUID: SDClgL3yQOCVbN0RkKgJlg==
X-CSE-MsgGUID: C+zWz7/qS1aYPbk7sKB++Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,220,1758610800"; 
   d="scan'208";a="215404403"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 22:53:47 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 22:53:47 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 22 Nov 2025 22:53:47 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 22:53:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYskOH6XEHEqiuOEtpHBvRqCtSp2M7JZJN4Ff76P/dsqLtxMf2GHyqvG/rZg9kfbTHUq/Mg/tOsSagQOZ938F2VCQaEqIOWfUUW4dirZqRtC2l08VsQkr6YWK1DiJ9QLPLs4zA74UYcZ+8NQHHRB7EvzikzfF65C87/mY7jKJckuwLnUGkJYQ0XpzVbprcBjTOiU7x566toYumRcr3z3LJk7sVMZl36g81dttaXl3U4YKt4l4WqgjavzVbqbqAD5zD9ygdW3VQSo0Gnyq3X7B/nXTifdbjfdpmp6o3ZMmRyLgsKK1nUyjfyU1Jicms35wBDwV/Czk4gXnk6DeZc57A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFBiZrrJ7Aqm1lWlRd5g39C8SO9CDjKSgFNcHO57Zc0=;
 b=YtCYSUQbFqBuu/cYs6Mt49YCavlUxQV1zvWfgXqy8goL8ViiUhElwZaQQU4zDsjmLfnVuJEWMnCu70FlatgP9weDUQ37ns9Od1h4DT1Y1hz0yFSvxTl3/mjxbGxCPVsxVWccuzZgXqfNnC8aWb7+34ZFBJzpaqOu0cvrAcFuwBD8d6zefFWVo7iU1LNsYm6raNUwQkl9VhuX4/dkVZ1MT5pru8Ouovbt4CfVjMGUlgD6+jGlAuY5JONI1vsTqb8SXZBh/iYo5K5IZGFc++ZXcNzJY2qv0n/tfLCMhnQ2LPVS9fyzBnn56HglTAnb3knTI3KeElBeX3mSDm1WoFsANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4628.namprd11.prod.outlook.com (2603:10b6:5:28f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Sun, 23 Nov
 2025 06:53:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9343.011; Sun, 23 Nov 2025
 06:53:40 +0000
Date: Sun, 23 Nov 2025 14:53:32 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
CC: <oe-kbuild-all@lists.linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>
Subject: [akpm-mm:mm-nonmm-unstable 86/104] liveupdate.c:21:10: fatal error:
 errno.h: No such file or directory
Message-ID: <aSKvbLiFT0aParmU@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15)
 To MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5963:EE_|DM6PR11MB4628:EE_
X-MS-Office365-Filtering-Correlation-Id: 221ad72e-af62-450c-e914-08de2a5d08ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w6DIQgaxhd11myvPlY24y9M/WttHk3uBtIgHBDR0T7pEawbvXYpybqP7x9zX?=
 =?us-ascii?Q?Lx2/j+ycnIIleU7O1dOcXZpmv7fkrFQ6tO0ubwHf8yNjIn98I12nmNN7xcXQ?=
 =?us-ascii?Q?ON75I91dl6WDG3OQl3iJw2YeJyp/3ouUvDzYGoGhKmUJEe+uUHstYhJk60ba?=
 =?us-ascii?Q?ewf+2qw7w4y4kM2VazCztCtsFqmjXhMKiKiw0tE/dc1IYaF7T0kZDuUL50mn?=
 =?us-ascii?Q?h2vAmSNfi1Xe9ql/eHUn7hPhhxXAudLR28BWfaaWUarvnobARx3AYIX1BPSx?=
 =?us-ascii?Q?jpK8RXpe7AlxMjN8AfqUuVEUHTvQwmxNdI7I/CzYzHhfcI62AZKDOi+77+gu?=
 =?us-ascii?Q?uHDCumucdiLJoN+ct5yASM8EDdG7fUmMGRe1kG81/L9mgxWDKYYn9hOJpZY4?=
 =?us-ascii?Q?J4De55UxBNHNWvUdUIekg0rwdu9TeojQZRTLVFUTBFGVgBaPjRX+lPfBt8Tb?=
 =?us-ascii?Q?ghNHmzfKdtDj0ldiZeUwbG21EXocXSyQgRQaAG8Dj7HiMD7/BBLJy4GdhbwB?=
 =?us-ascii?Q?U02jNY0VJoF936uW2ZttMu61P/1aSKysY/plSKCiP3nbcpBzM9ITpXUFxQus?=
 =?us-ascii?Q?6Gpe8N2/GAVFkZvDSb3rAI23OlnScA4ZtQlubtR2HsQYO5EzbCX7vHgvciD/?=
 =?us-ascii?Q?vLqco5Jf6YgLDdd0V3Oa5HHRdPx09n3//RtH5NWktoc/LeM8pcJWObaAS7F5?=
 =?us-ascii?Q?C87EQMII+TE+6sFst7/uU14296EhCoMOPruXNOC050VsvyMRy7gfQkS2qzt1?=
 =?us-ascii?Q?OZhBPrkmDwc+2bADP0HzQyN3ZKHhWhEKnaNkzjidj4XLaN0DL8aybRTNYSgy?=
 =?us-ascii?Q?fjti0mlZelgvKxcg1ZvGRsUpr7u7sMrVZLj1ePKWDQxaGqioDCek0XJOqc+4?=
 =?us-ascii?Q?VYY99KjIedOKYhzbG8J0eofW+J1lkXmOQDUxGDo7CVZgY6qwkWx2QdEXvlHF?=
 =?us-ascii?Q?f0XgtiR1vDU7BQ4zSBX3tklnhj8rvdCwl5gFAtAcyaU8TfwkU8M/3SmMredB?=
 =?us-ascii?Q?euOKSKPNjzxmBWjdnfvemY+wY7Hy62pllcy/3eDeE1FXv4eZcIEISQQXf8wY?=
 =?us-ascii?Q?i1VtIYzwASsf9TH4dmaSvwIxwTX+sPktnwfruJU041uxB6sUkpXj3n+6qFQF?=
 =?us-ascii?Q?AUVtvnm17ylraWUaSEMBTk40rLhQtY0Q+rToYl8JEVag4hTTpLMRao2EharS?=
 =?us-ascii?Q?TGE/di+VtuG7My5kmUqR95OFAOPMpfDpB6tKB+O9ooTK3fyTyMMNycOnlvyR?=
 =?us-ascii?Q?l/Zks1w8q0NsgibLKL5Fm347qc4/ZLcBObrCKptTU0aSJNcPJspthTTSIh5g?=
 =?us-ascii?Q?ZpYT9G3ZB+DAft+ZFq89zZlqn76lNeVnwKxQK34XDNhicvWTL2ozPpx+5Foq?=
 =?us-ascii?Q?68R16Mdcmclq8HMVzDIioY1UWmlKtEQhHHdRUvSgDgAVk2JVIR6esontZctt?=
 =?us-ascii?Q?C02XUC4lPI9I98yre/YA+ReSXOqneKEBbDnzEqIhti687vDvjFS0iQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cYcPZmZPrBnMx6NOwEtrWoBGE03gituIw0kmiBvAQ0D7tOrU3OScnbutY2rG?=
 =?us-ascii?Q?rtFPGK4CEtfsPqdXpQSuFAMBHy6W3UgejjY0agzCcr1lG9QW9iqyy1q0Y5jq?=
 =?us-ascii?Q?/SExGF4F86zH96OfX65X8MD304S6RV4YHEOk7IrLcGkxuM/6udhZEBtioOEC?=
 =?us-ascii?Q?7mKB6jO11LhWeRK5kdWC6p9+gEKK4aE2m2flDOQmlfXyuJNFasOoabiuOocu?=
 =?us-ascii?Q?miLHpJvu0Q/MGdxgAWm2lbobepFX9/nOrAv4bcXURVKvSM5HVwlaZ49Xqv38?=
 =?us-ascii?Q?BmH057Ji/kPjYquNkc8i3MhrqaY5KwczE0QssZNUpYczT89ESMwFh6JlE/sX?=
 =?us-ascii?Q?2UxB7cWItdbp7ZviqyEYp7mfPmQt/yV7fEcpd7MkzNw3tI4HeymSnBaleMmI?=
 =?us-ascii?Q?RU7J8/vVmwDWyCZU067080APwURK11jw0B51qxmG/8XVXZCFIcvEV4sso28f?=
 =?us-ascii?Q?i4UAdqZYyS4ofCM8V4XeLoN3gm1SxAZiO+CZ3wEn5G2TCZru8en3biQPuGKH?=
 =?us-ascii?Q?sorF+OIHMCpCixPHR0jFcueBF/RK+V9SIbPoUUjxWmQFf3OYywwrcuZtode3?=
 =?us-ascii?Q?zt+2WzV4q+u2KqUu2HvW2JIchIzZCvxFXIQ5AHYjZ7IBuDtP5PiNwFBfqiv4?=
 =?us-ascii?Q?F/0SYc+R0CRP3INwkH2WOXg9zEM+R88aLOEfE47pdiPWSyIpIcUBu1PXt5f7?=
 =?us-ascii?Q?Xqti6EJgL3HYpTVvZ41UoWgfM3QJv44ioAaorkbsDt3K2W3dYaBDA2SIvIZ5?=
 =?us-ascii?Q?N8kZJS3+txgQ1czhxc/5NMyl3Jpm+lghnVkp0mLN4NmzppFckOavchmCW7Uw?=
 =?us-ascii?Q?0cEgB9ON2NJAyUpdLi8nC9JVRlNX9iEdNhcxkbsOLSiDPmZpqVejmo57Lm/O?=
 =?us-ascii?Q?Sc4N1Gtk6wdybelAfcoQT1MAPUb7mkIekKgMd9YrRx5skxmsxG+FJuPx48hw?=
 =?us-ascii?Q?pKZoTfxVyQPz3YWP6AJVZctYgsnUGNCDrFQElhmkBrKpZhO0yf5sgAA0FM+R?=
 =?us-ascii?Q?fR0E07tVkAMaKB/v1R6eC6ETGm0Fe28fJ9hxkiDH7FUtO7+PRvl+2K9jUiMh?=
 =?us-ascii?Q?tn4335BTGG/pwgpNmJ4nDHtB+GGKGyXlyWS6eknPNpg1BNcmnC10nQeZLQoO?=
 =?us-ascii?Q?r1kVbZXolX11JMAMNACnOotGBKwbZy6L6lAZCBywKWDHUxdSIYdT/F0ctPQs?=
 =?us-ascii?Q?VT47gjQb62NWKeERB01gcOx2nrzfGGGwE4GFrGY/48ADH1op/hEmQs18cCEW?=
 =?us-ascii?Q?pLXr8wYg0AIqRTBZOhK3iGVqu4ZkzGID7Ub2KK99U2Ta0ezXAyfe5QaqnOuj?=
 =?us-ascii?Q?rSLj4NPbizVfbNz6gYrBr5LR5EykzEF9KvvS5XGPCmBwaSm58vwHJmVvZLw4?=
 =?us-ascii?Q?t9olB33Dv3LP/pymvUXLXT3zaZ9oEq/lGpUzzP86RdgjBFxRRQxAw3M4c9ra?=
 =?us-ascii?Q?4AXx5inpYDW0okyW3AsY+u+VBlRqFiQbEPRk6E6h+0MXIQBhFpj6gW6dFNbP?=
 =?us-ascii?Q?gbI2UGUvB4FaIzIs3yKd7dZvrJd0zCRwtf3Vc7PuQwWPqqwrVpmXMrq3XPsr?=
 =?us-ascii?Q?NfldjUO8NVtst7D49/PC6HxffRu20N4FXniA8ZppR8+99OcJA+DJw8VTk/0R?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 221ad72e-af62-450c-e914-08de2a5d08ad
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2025 06:53:39.9947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6hsNGNzfw77Cecti27u/5LwQwmwdllcs5Jzik0NSxVAR2Qh2WhoKG+fgYL5PmxYMImVKMrR7Z57WXiSO/zMHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4628
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C98C180009
X-Stat-Signature: ypk7szsfs7xa9a13xt5uy8fr6mz7qju6
X-HE-Tag: 1763880829-208504
X-HE-Meta: U2FsdGVkX19GCxnWOHVTPr42Uhp1Yj7EHrtNaDwsxX7w3hoZYI1v3fXxcbinaSfp5abNdjYYe2RQS/nR7Paytv055sIKze/b55x7EWZBp2sYUXafJ9g5P4xGbNWW4AxGaWvwgwxbdDTJBvEgUJCvxQ7XtHYi29+jlyDJdMiBYjJUtIt2S4f1iWseLWGMm71nnBB/QliSkE8YJ5KzuVQF3We4bcQSiIr3WeATaBwNwG4OtWHw12Rf2pqkmLJUHj7/N4ujKk0n6lE4N0LhIv3DWG4Zc7Z9xVFsuDPAzffmZkAgOrAReF07stQ3dMc1gliVsXyCMLU3PsKFaxZ5oPRkjlDmNe007Yg02sV+GGPE2i+X3Mukkh19ocW8ihZ48SOFUzX7G0q5fsImI9Kbqum6+VKuGuxB4T20P1bJtd4v2Z1ntVhtehRvaWyBVAgxEkmwpaYfOyP0n0WFadoPb12W0vlITdVTMvlZTJCqbgHN+YMiWeF2fPBHOquiJXIBE0VDXs87yQOuq5PkOWjvavcjrSWbZLE7+lqvXWLcyeaBbvSAdyhnnGDcM2pzBn3x0mVK/F2iedupGNADsfqvt98Ffz72uTV9U1lkOTr578BMZoeCxNjjGkrmAHQ+dVh6cyQgqoNHf4FZ4UQIprprWXaZTlt/nldw/1MbHbTAyNAPB+071ZHAHD75cfRbS7AtPy553tl6iM0qen4YtpxQirn8MYrbIsL+Vy51f02QuJNzaVXoZ3rFBcirp3O5N+66iaazittq1zsZxJ9xp2OdrGodep2f4ake/L9yfFnVr435w4wxwiM+dpTQ8x2jwStGyDw0x92Mve3Duzmy51UmM5vU4e8diXdZfGuqv/fsRMFmLlgyfAYsBIpZ3sPaLnzT71qn6f7S+Xau1cV4ZK/L5MSgD2BRqNske+W2ptGx4XEYqtyVL3JvViHZ+Q9FD3zCAUJ6l4xc8+1RnzZ1w4BXEUD
 roOnwkSn
 SFaUxVqK2Vg7XSAAeLoav9i4YW7d4OQZIjmgjqRiruwQC09+LYqcpG2Q7T4iFMjxRRGupe7OXXeWR3fEVgo9eBcGv/AB9FfWznvXMT4UVAZwLPXwph545X6ugpCnQzuZNHQlTh8ea0UUhaVjSZfEnXeS8iPvb7HTsXf2bCa3Z72h9OtoIzrfWCEzTTxxBQ4/4GS8QOCv8h2d1Flw2lGYheH1LtozKBhbT1gR0GugLe0/Zmcxign41hvT1jhHaMApY4fEVgaGr1eSpy9ubKe6Yf5h/C1nDFAS4QThFVMVn9ckj2EnnljxEC3u5FDUhfxL6QlXl5HFBxxxJHttl1isAWSqLdp7oQ5NfgksqhlEX+ra5bgk9jXDj2qh0ezbYxOy5odkz6aKeXNIkhTKyVp4mOoXAxPnBLSr/B1G01++bbRvNkB8ljUQxPOeCgNCQnZtHx0AdjT7LIbbaGuYodM/RxJAE6m+nlzgfIm7kooYT08dmrXN7IzVC/9lpQWDpXWZRij255v5oERLhTRUi8aNPJrrfqyk0mJpfcycUPO7QTgsGt4ZfdVZOO8J6SlOWgdhopUorIKYs+GWvmjoPZ4l1xIweLviu7iOXwG2G9NJYnHXnbdW9BKqfT2PwDV6gRy5Kt1m9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   5b8dc8b45ebd9e7f3fea3adefeccd9ce94215103
commit: 2c55496371f19ce7570897a3d7b807d0a2b04dd9 [86/104] selftests/liveupdate: add userspace API selftests
config: riscv-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251123/202511231253.aLRTg9sG-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251123/202511231253.aLRTg9sG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202511231253.aLRTg9sG-lkp@intel.com/

Note: the akpm-mm/mm-nonmm-unstable HEAD 5b8dc8b45ebd9e7f3fea3adefeccd9ce94215103 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

>> liveupdate.c:21:10: fatal error: errno.h: No such file or directory
      21 | #include <errno.h>
         |          ^~~~~~~~~
   compilation terminated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


