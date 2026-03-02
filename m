Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E1BEB3636
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B40E6B0158; Mon,  2 Mar 2026 16:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967AF6B0164; Mon,  2 Mar 2026 16:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FA16B0165; Mon,  2 Mar 2026 16:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0A26B0158
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:30:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14B7513A7C0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:30:42 +0000 (UTC)
X-FDA: 84502417524.29.A7F673D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C2E1C0007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:30:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ROFwQShB;
	spf=pass (imf28.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772487038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMOi5HlymbWJj6tCUM4Ti7hjcXsBR0sZQJOnanEmbws=;
	b=lmeaWVk1zfO/vaUtX6crFPtS6RnTuIX7qFpovmcuYuM/Yqhyk/Drxxr8615u6EKIc+bpfp
	86U9ZVLj12y4GBbMuccro+tZTEJf5nASDsoYtKInyBF8W54tiE74LK/WkUURDmRAAsEmSc
	hkvtXhi6E9xW+D013NbBdguauS3DrA4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ROFwQShB;
	spf=pass (imf28.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772487038; a=rsa-sha256;
	cv=fail;
	b=74b0QbHtxaYIwzpsmj6W0r5XikUwibCx9IwgqNXAkZb1z8eHsYufhaCRsWpOxlMg9sXLNW
	CD/jFJ94JkdhwVVNdBA7859ycgkZJXZ/BXlMRJ+otvlp22P7/0P8rnHyZDVX0BAFzp/PVd
	KCUf3cE2letSApiB/YlwCsmbRRFoz4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772487039; x=1804023039;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LzVECNvLV1NAi80S1McEWZB3RCWSpQ+IEkLaYo0wgAs=;
  b=ROFwQShBzRhueosS/k4N3mOfFNYV7Kyan5mGD93X5e1pmZrAHpRt7zU3
   fbQbEp6RL1JptXvdptJRq09+ogOGR4KtlI6qzcIARclsQmjGasAn6SdMH
   YZ3DIiW1UE+u5MegnQxEFnA/LHdxxtI9UtZofrvF9XpJEampWGPcpGvJo
   QPbGEMM4Xn3T2oNBIMv1B9s5PIE5kNzfg+Kz3wb73BkMYd7p8JRpHejv9
   T9DlVFvfIfkRgoZHLVOqNL/8y9Vgjwxs8hPvRX+YSAZoGmAHuPQWWQPuV
   IRIGlAjLFG3ofYx0MkNsdo68p48gJ1gdFT0aNMyaQAd6LBDvTr79AU2xg
   Q==;
X-CSE-ConnectionGUID: oxqyz2EOTLi92gNKlBWs1Q==
X-CSE-MsgGUID: odxyRssVQpmVRVA4Gc6/jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73212466"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73212466"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:30:30 -0800
X-CSE-ConnectionGUID: 7c/UjqNORZGvj/9xWaBgsg==
X-CSE-MsgGUID: 5efQcu7aT9mYLpaKTSOd3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="215369662"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:30:23 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 13:30:23 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 13:30:23 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.8) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 13:30:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DW1ZCqQjiyfxV4ru1cHBXd9i9KzOaRllb8Oh2Rd63uebsQ0vWD3SJNTGLgAk7l3cqUYAlDxDK6JEMciTcLyH8c/pw+8ML47GKcVZLyg+q1eqp2IL9kvOcmKiHqPFEbFcxIgy6LLfMJucO1Kc7ZTGmUEg/qXOE416IqIBx5rNaEUVT9ctTBiedmOc+rfleFGbjZnxXUCH1RjNDSJ5CO6Z9ZWwfP5Tl15ufW3HJVIxgkJsUL3TqkVvxYlDntbksLpyM1HCsz8iDY2W5w1g0msSgx5UYloVBXwNK47HfDk+MuKPfNAm0kMKIvpGD5gju63QKYSu3xh0vKoDnMUgWWZ6Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gpTp4QVGc/9juSQ+FOWB3tcRrUjvAuV38cCRwinmOo=;
 b=dz0mo+x+fuqsH7Agu003VyGL3Je//tmB+RriUJpiAroPdCnkQ0uctFx4Sz5p+RLTynaH+3pcVCTB3wFnYVIq8rrgJThr3zCCEmJWrBm8mrPSvNEV3IrGhnKCUPtFGJ/MxLRMaxXOv/E+1JilS7uwCiDVe31tNByQjeznX2Hlb2b5sISQcVjbDozxmjJoMgr9zG4wSSyKJOcHAKgFfsQYo+Jsg0rZO9b5w0svuQlGZxcGJT/NlVmzPXQEjV1hQFk62TBURep1/JHOFi8AzPw6a5qwk5PnpB3vp7VRfSvJpHVuIoo2xJdC8MsmvLgvaQq6O9accxg27DFklh+I+fC7pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 21:30:21 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 21:30:20 +0000
Date: Mon, 2 Mar 2026 13:30:17 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: <intel-xe@lists.freedesktop.org>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>, <dri-devel@lists.freedesktop.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, "Simona
 Vetter" <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>, "Alistair
 Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] drm/xe/userptr: Convert invalidation to two-pass
 MMU notifier
Message-ID: <aaYBaXuvvXk28gNx@lstrano-desk.jf.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
 <20260302163248.105454-3-thomas.hellstrom@linux.intel.com>
 <aaXdsiRlux/cZ6WC@lstrano-desk.jf.intel.com>
 <1722945c1b8a99bd9386b82a109e3308197fe914.camel@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1722945c1b8a99bd9386b82a109e3308197fe914.camel@linux.intel.com>
X-ClientProxiedBy: MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::28) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA2PR11MB5209:EE_
X-MS-Office365-Filtering-Correlation-Id: d872b507-2e41-4e13-b91e-08de78a2e817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: pi3Ytql9X17daqe2u/h3qBBDCP/QzVm/YCEgzJ5cENfnbh47Q2lBxYClbNA8kglxHXexn7q/ZM/zMUAmx7IVAdKvSsLWAfnyNxeIDMduVrTmtILLIX0uFTzTYdjAfzQmDl0mLUcLO11sX2szLesMvPMubLYGArTsKwjLHfLpzEXKdPVNg3Fl8ENI/XpBMrxVOJz6YrRABGUoTt2CVC/301nar9AZGRVarbIrER467k/ZEUo7A6uZgqsdoYLkQtuXdcY74HgAispl7pIDUrjoKWAg2K4SoltmSxLEmMA0t9uYY063MuAOvDTKMtL0/03F/Sp4OxU3TymWGIXgOTs1sclvoe0Z/u3qan5dFrr1c1XeBaNgx3eNlH40CUYYOOTH/xVoDWQeOnaBrbDPs90ZJLaxH5sTyAWgBjGKXaQO3/4E4GYj/QEpiHD6qjSpBiCWW0w5vGx/33kfcTykrbma8lumFOSvruyUu1QlwkHScUpEGLv7uZZGNU+qm1CcgzZgqHdtcjRFekz+3XXkPSuerjF+44xrF0umguugw/G1yi2gbGuj4FKesjISIqK+ajQmklVTcyCOilndiNty4C7j9tnA9t4B1yCp0PssjsSrMOxIoCWKeLi+2nhwbHYxVCuOXFALRjGrvt/4kE0tSFoRU2uKD00ePnPHelvHeMbSg2h2TYvhPkdsJNPR16Jgsx9NBx8f8OSypp/4Jxm9Uzwd176i1JK9Uvd2ptBp8CVu+eg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6IFGvje+35r6piO8Sfx1+Sjve2S0EMxY+Chwi7yatDw2hSgjWyz8sWDhsl?=
 =?iso-8859-1?Q?FCJ9TOja9vo1Xf+UZ/v3TtxNY5bVWrkScWwBKn2Mtb6jD1vBuMmXM2q4KI?=
 =?iso-8859-1?Q?uaPD8/HJHDD8duB4P9THLXLX/hIq+f1T4hSoQRHLSupirlPeXyF9gXLVX3?=
 =?iso-8859-1?Q?l9amecHwk0f/XH7VqLsu6SceEmefBZf/5LSIrMkOZTF+MB9Pen2F4cqD2C?=
 =?iso-8859-1?Q?xqfSG02N8VVKsrA6hXdnDsiBA0/rrq4XbFaiqEK0jvrFZP+PsxWuxZ7Gcf?=
 =?iso-8859-1?Q?/FKhzmWqugZI2A4tgTiZ38t67x4bmUcqp9FoQWSEaQDrE7eAqK12/xxjD6?=
 =?iso-8859-1?Q?AWV+dMTbPK0gvWAK+/vJyiky/Lr0rPrCyCx5l+9CjdwYlYghs6OkmuZnQ3?=
 =?iso-8859-1?Q?YKFM2wTw6/V0wHTGlQxI23KUDAmF1GGZSIgg3xjEfVpViCStlIX+C/+T1r?=
 =?iso-8859-1?Q?YQ0d2HQS//dIO4bU6yFTbgR9VvymUcuTp6k37yhuWFma3OQSnCD940d8IA?=
 =?iso-8859-1?Q?N/MFwLt5rYtMQWUXLbm4GnpZ1zb1d/d60K/dTf7YVvyt6oQVmb+ucLyCT5?=
 =?iso-8859-1?Q?N7WljylYywJdAYegh3c4mE+C5vh2FpE4LSLQi8vjgFLQWV1ToLr1ST3WRW?=
 =?iso-8859-1?Q?0d9MKDnV1ajxGf1861uHnzP4Y6zy39Lb8ZRx6tTBNjC0VyCj/va5fLw1oa?=
 =?iso-8859-1?Q?QmmgbN16Vdflzym6zXvf8qQn1ixfZSwOxiX6nWQoQlXlgOGdGPwB5ANkSz?=
 =?iso-8859-1?Q?biQTjibDLpUag9fn4mJJaq/d6pA+0BL52IKtoDvtopa9ysc6hkYG20qtDr?=
 =?iso-8859-1?Q?BR+cw5NfNmPJzW35hbnWuKvYo6UfndJKh0q99GElDJaeWe2MgjN7b1BNjG?=
 =?iso-8859-1?Q?3Ib/QMlqulRYR/aULNp60zrU6L0M296PxO+XZ24E6tFSPK8eywR7tqvyzv?=
 =?iso-8859-1?Q?C/ZXer6JK66wVSVGrPUnxmqc01Za/CrmFXoq7gNbezsCPeN6mySnG8YLUh?=
 =?iso-8859-1?Q?EawSFAA3n2vI1IQyLU/z7EBdPQcnn9fWjG9+PZFLQr4aFjPbM3J8/639mq?=
 =?iso-8859-1?Q?qJ7A9+X+Lcsusck9zp/nlHbe1hUsp+GMcFb+H40iJjBDQIebPWfstRkkGS?=
 =?iso-8859-1?Q?81ELznBh/p5iJRH9YGk1ioFIu3BB3xamiBlbsJu+MWpnjBgiaZfl8qmjWx?=
 =?iso-8859-1?Q?tjJnCGvMjRyzCT3Pxh8MKfJOd8evfx+BkJ5LlJJWREI2eon+tGvSYJ54M7?=
 =?iso-8859-1?Q?+rFrO2Dh+a+nZeIv5uV5oClZy5WS4pOlMPJc9P/8YakrH0HMBKE0EhVeNM?=
 =?iso-8859-1?Q?8gKPe3WCs5FKBFRR1uhnSW8No6QB1nJdHwq8xY81HPx+ViiT5dqDrSR0qb?=
 =?iso-8859-1?Q?bFL6haBMjsKtNqvoIrDVy/KUjjcTy6dWIDQyCWPKxvmlzSvO42agmNx5FH?=
 =?iso-8859-1?Q?1v59tHHbWdlMf/G6bh86PFA5DFFQyeOOtjobdUyAZRwX9xibNweqtDofmY?=
 =?iso-8859-1?Q?vOfu3JrdMlaUQ38nrrZlpML0KtPFu0ttwulEV4kgopGvpBHRL1Rmx9Rhj3?=
 =?iso-8859-1?Q?uSgJ4Cb8gd22ryf/4aT4vcTSVhoI5et9f+5IrLmW2aSOoYB7iuXrtN2eXV?=
 =?iso-8859-1?Q?0H2MrlChmJsfrNZU0Pb+dBk1L6XZIwv4dmKMmFSR4+LSJQCY3DyADM+3HI?=
 =?iso-8859-1?Q?7g0dvKyPNGhbUCcb3eTgnBbMoZClySFlCw7Y33GTKSXzMu6JguIByZ0T5n?=
 =?iso-8859-1?Q?Q3nxEEe2wVmskfB0EJv5Cu/ZG1/TapADswTURGNhFR4CqnWtpqslhrUPk3?=
 =?iso-8859-1?Q?dy1EvBwtSKpIOast1U5kn21awkeX1hA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d872b507-2e41-4e13-b91e-08de78a2e817
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:30:20.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDspoWw+AMJqMnlq+1UQZt6qh0L4HtnNeAKNUXsZosyCt/vkrllvEz9DzJMXVXgBG99U+B9429MkrPG2K/BEcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 2C2E1C0007
X-Stat-Signature: o64z4o6wje8d5mthfemjhzxge3qouurq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772487034-353707
X-HE-Meta: U2FsdGVkX1+/zTRS+5RBpejBR8gARl4OOgWO7VMkDuIGl9+/H3EDYUkN9FDD/smrS3bFWixyNtS8YE0d6/NWIsKIz4DKPKvqTeesDwW3v96iImxPDJT2Xc3lQ3CNoRPlm2YraUe4B17mygMTbALRnGmuFBHThc3TBKF6pxvxvwqtxU3aUogy5HlgQ1F1bc4MIEFrTY8Rq3AZDCY59y0moNkl2Nccwi7y9zqFLP/ucZnNdw60EtluwIRqsUXoZvF9baCEWhvBfWEz+TZoWhZ8MCFQenbzba9fdjXGd+xycxGVdKAI/r3J8SkKdGbVK8XtLo3E+GAZIzySOFenUzXVg5q6efYcV4nSW5YniEZXvbsNg2Tg7mu8MKf3hL5DgKfBsV5uzUS/R6gL6fnWBXvo0dQPy7WuFcjY8O+7yZHh2wgp4RfyB6rBZGPiL0rflwxR3mKSms8LftDibBbbiX3QxIzTmKH2YI9KIhh+ww6FR7/8reIFgZHdhI3aGcnev0nIEUcUA4h6OywHWnrSukH1N9PcgfWlsNvKJwR+RPynrw/IE/pgwkTuctiUPvqFpw6ec2tgvH7utdMUfrXGCef6uSevhzwHJ8hDFp+/qPAhbqESfTm3VV6Gw0y9SX2epVkCWsZK6l6gT5FAAqMRyiQUJkIAMbENnGwDluZo29pC7VQA0maOblgYQY0o4GSiV6UbXthZJmn1UT9H44wuXjTglgHa1u1ELKq3PlCqziDFhxfVXhhzG8z2tKCCwON6E4qgGy03BKOUZRaJsSioGvF/w1iv54ZWJuklazqlbpWf0PJeyeXoZOSGlIzMtzMtvAuGWSQ+BRyoFXIg1T3W4axrFP5Dmt8+0Cc+Kwc9zrE2691L47bDIrUSM5ULIWSuWy8aCmF7QxnRF/uHigawm3i78qoqHa4axCOOyQdi/aCMF3WBuaek598+ouIUxcBzWiXi7fF1gSqPJd8LscKItea
 qSwjmSAU
 pxoMgF0Ccaq/0fW7Ma+XV9/KPIH8plj0JTtsa9/P3RXAKyJvTZBzyM0MslHokwZvd+CmPpopsAgbUBCLKnbH/vJu6Z3NKoaNZgTcXceh4MfdNkdrEa0tX9AZ8d2okE04qRLT6twNVgfIBg7mRbjZ48Fe1u+H5c+iOFmg3x4LFD8EahSvHZAcILwzvJh8YqJ9olJkBQ8aMOl7PyZK8AnOYf3M97EGPjkNiUkxcaGszs3l/w5was5VMGcAAzk6XZDr6SCyAMyvr6H7eFz+e3sEvU9Y8zy68cv/CFkHvxYLNf+Hm2fTIggAzsyXcuku7MNbOLOK2PJWTrWqaO6ZrwEvWQGw9gBqMRY+BWu9Ko+7fY6TWyScz3ACzF62CwSW93R1Jmhnae/JlW+/89a9VDqq//GLgERj4oaim2wkDUFsAfGhAp8J3NHvSjcPKESVAphDKcFnmyWNYT2VOqJNzH2CuXX40Zn4PrZMSOFaUaTXwHeU5+rbCeWY8lXdTX8ME3NiEY4r7UvqRFL8WTJ27kTtWUlCZfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:22:13PM +0100, Thomas Hellström wrote:
> Hi,
> 
> On Mon, 2026-03-02 at 10:57 -0800, Matthew Brost wrote:
> 
> Thanks for reviewing,
> 
> > On Mon, Mar 02, 2026 at 05:32:46PM +0100, Thomas Hellström wrote:
> > > In multi-GPU scenarios, asynchronous GPU job latency is a
> > > bottleneck if
> > > each notifier waits for its own GPU before returning. The two-pass
> > > mmu_interval_notifier infrastructure allows deferring the wait to a
> > > second pass, so all GPUs can be signalled in the first pass before
> > > any of them are waited on.
> > > 
> > > Convert the userptr invalidation to use the two-pass model:
> > > 
> > > Use invalidate_start as the first pass to mark the VMA for repin
> > > and
> > > enable software signalling on the VM reservation fences to start
> > > any
> > > gpu work needed for signaling. Fall back to completing the work
> > > synchronously if all fences are already signalled, or if a
> > > concurrent
> > > invalidation is already using the embedded finish structure.
> > > 
> > > Use invalidate_finish as the second pass to wait for the
> > > reservation
> > > fences to complete, invalidate the GPU TLB in fault mode, and unmap
> > > the gpusvm pages.
> > > 
> > > Embed a struct mmu_interval_notifier_finish in struct xe_userptr to
> > > avoid dynamic allocation in the notifier callback. Use a
> > > finish_inuse
> > > flag to prevent two concurrent invalidations from using it
> > > simultaneously; fall back to the synchronous path for the second
> > > caller.
> > > 
> > 
> > A couple nits below. Also for clarity, I'd probably rework this
> > series...
> > 
> >  - Move patch #3 to 2nd to patch
> >  - Squash patch #2, #4 into a single patch, make thia the last patch
> > 
> > Let me know what you think on the reordering. I'm looking with the
> > series applied and aside from nits below everything in xe_userptr.c
> > looks good to me.
> 
> We could do that, but unless you insist, I'd like to keep the current
> ordering since patch #2 is a very simple example on how to convert and
> also since #4 makes the notifier rather complex so it'd be good to
> be able to bisect in between those two.
> 

I think it is fine the way you have it - I never have strong opinions of
stuff like this. For me to review, I just had to apply the series to a
branch to get a full picture / verify all flows were correct.

> >  
> > > Assisted-by: GitHub Copilot:claude-sonnet-4.6
> > > Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > > ---
> > >  drivers/gpu/drm/xe/xe_userptr.c | 96 +++++++++++++++++++++++++----
> > > ----
> > >  drivers/gpu/drm/xe/xe_userptr.h | 14 +++++
> > >  2 files changed, 88 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/xe/xe_userptr.c
> > > b/drivers/gpu/drm/xe/xe_userptr.c
> > > index e120323c43bc..440b0a79d16f 100644
> > > --- a/drivers/gpu/drm/xe/xe_userptr.c
> > > +++ b/drivers/gpu/drm/xe/xe_userptr.c
> > > @@ -73,18 +73,42 @@ int xe_vma_userptr_pin_pages(struct
> > > xe_userptr_vma *uvma)
> > >  				    &ctx);
> > >  }
> > >  
> > > -static void __vma_userptr_invalidate(struct xe_vm *vm, struct
> > > xe_userptr_vma *uvma)
> > > +static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct
> > > xe_userptr_vma *uvma,
> > > +				    bool is_deferred)
> > >  {
> > >  	struct xe_userptr *userptr = &uvma->userptr;
> > >  	struct xe_vma *vma = &uvma->vma;
> > > -	struct dma_resv_iter cursor;
> > > -	struct dma_fence *fence;
> > >  	struct drm_gpusvm_ctx ctx = {
> > >  		.in_notifier = true,
> > >  		.read_only = xe_vma_read_only(vma),
> > >  	};
> > >  	long err;
> > >  
> > 
> > xe_svm_assert_in_notifier(vm);
> 
> This actually reveals a pre-existing bug. Since this code
> is called with the notifier lock held in read mode, and
> the vm resv held in the userptr invalidation injection.
> That assert would hit.
> 
> 
> Also drm_gpusvm_unmap_pages() below will assert the same thing, (also
> affected by the bug)
> but for clarity I agree we might want to have an assert here, but then
> it would need to include the other mode as well, and I'd need to update
> the locking docs for the two-pass state.
> 

Right! I have pointed this out Auld as this popped in my testing
implementing the CPU bind / ULLS series as I enabled
DRM_XE_USERPTR_INVAL_INJECT in my testing. We should fixup
drm_gpusvm_unmap_pages soonish too + enable DRM_XE_USERPTR_INVAL_INJECT
in some CI runs too.

I think some lockdep assert would be good - even if it just the
non-write mode version with maybe a brief explaination the error
injection path can do this in read mode while the notifier path does
this in write mode.

Matt

> > 
> > > +	err = dma_resv_wait_timeout(xe_vm_resv(vm),
> > > +				    DMA_RESV_USAGE_BOOKKEEP,
> > > +				    false, MAX_SCHEDULE_TIMEOUT);
> > > +	XE_WARN_ON(err <= 0);
> > > +
> > > +	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> > > +		err = xe_vm_invalidate_vma(vma);
> > > +		XE_WARN_ON(err);
> > > +	}
> > > +
> > > +	if (is_deferred)
> > > +		userptr->finish_inuse = false;
> > > +	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma-
> > > >userptr.pages,
> > > +			       xe_vma_size(vma) >> PAGE_SHIFT,
> > > &ctx);
> > > +}
> > > +
> > > +static struct mmu_interval_notifier_finish *
> > > +xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct
> > > xe_userptr_vma *uvma)
> > > +{
> > > +	struct xe_userptr *userptr = &uvma->userptr;
> > > +	struct xe_vma *vma = &uvma->vma;
> > > +	struct dma_resv_iter cursor;
> > > +	struct dma_fence *fence;
> > > +	bool signaled = true;
> > > +
> > 
> > xe_svm_assert_in_notifier(vm);
> 
> Same here.
> 
> > 
> > >  	/*
> > >  	 * Tell exec and rebind worker they need to repin and
> > > rebind this
> > >  	 * userptr.
> > > @@ -105,27 +129,32 @@ static void __vma_userptr_invalidate(struct
> > > xe_vm *vm, struct xe_userptr_vma *uv
> > >  	 */
> > >  	dma_resv_iter_begin(&cursor, xe_vm_resv(vm),
> > >  			    DMA_RESV_USAGE_BOOKKEEP);
> > > -	dma_resv_for_each_fence_unlocked(&cursor, fence)
> > > +	dma_resv_for_each_fence_unlocked(&cursor, fence) {
> > >  		dma_fence_enable_sw_signaling(fence);
> > > +		if (signaled && !dma_fence_is_signaled(fence))
> > > +			signaled = false;
> > > +	}
> > >  	dma_resv_iter_end(&cursor);
> > >  
> > > -	err = dma_resv_wait_timeout(xe_vm_resv(vm),
> > > -				    DMA_RESV_USAGE_BOOKKEEP,
> > > -				    false, MAX_SCHEDULE_TIMEOUT);
> > > -	XE_WARN_ON(err <= 0);
> > > -
> > > -	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> > > -		err = xe_vm_invalidate_vma(vma);
> > > -		XE_WARN_ON(err);
> > > +	/*
> > > +	 * Only one caller at a time can use the multi-pass state.
> > > +	 * If it's already in use, or all fences are already
> > > signaled,
> > > +	 * proceed directly to invalidation without deferring.
> > > +	 */
> > > +	if (signaled || userptr->finish_inuse) {
> > > +		xe_vma_userptr_do_inval(vm, uvma, false);
> > > +		return NULL;
> > >  	}
> > >  
> > > -	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma-
> > > >userptr.pages,
> > > -			       xe_vma_size(vma) >> PAGE_SHIFT,
> > > &ctx);
> > > +	userptr->finish_inuse = true;
> > > +
> > > +	return &userptr->finish;
> > >  }
> > >  
> > > -static bool vma_userptr_invalidate(struct mmu_interval_notifier
> > > *mni,
> > > -				   const struct mmu_notifier_range
> > > *range,
> > > -				   unsigned long cur_seq)
> > > +static bool xe_vma_userptr_invalidate_start(struct
> > > mmu_interval_notifier *mni,
> > > +					    const struct
> > > mmu_notifier_range *range,
> > > +					    unsigned long cur_seq,
> > > +					    struct
> > > mmu_interval_notifier_finish **p_finish)
> > >  {
> > >  	struct xe_userptr_vma *uvma = container_of(mni,
> > > typeof(*uvma), userptr.notifier);
> > >  	struct xe_vma *vma = &uvma->vma;
> > > @@ -138,21 +167,40 @@ static bool vma_userptr_invalidate(struct
> > > mmu_interval_notifier *mni,
> > >  		return false;
> > >  
> > >  	vm_dbg(&xe_vma_vm(vma)->xe->drm,
> > > -	       "NOTIFIER: addr=0x%016llx, range=0x%016llx",
> > > +	       "NOTIFIER PASS1: addr=0x%016llx, range=0x%016llx",
> > >  		xe_vma_start(vma), xe_vma_size(vma));
> > >  
> > >  	down_write(&vm->svm.gpusvm.notifier_lock);
> > >  	mmu_interval_set_seq(mni, cur_seq);
> > >  
> > > -	__vma_userptr_invalidate(vm, uvma);
> > > +	*p_finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
> > > +
> > >  	up_write(&vm->svm.gpusvm.notifier_lock);
> > > -	trace_xe_vma_userptr_invalidate_complete(vma);
> > > +	if (!*p_finish)
> > > +		trace_xe_vma_userptr_invalidate_complete(vma);
> > >  
> > >  	return true;
> > >  }
> > >  
> > > +static void xe_vma_userptr_invalidate_finish(struct
> > > mmu_interval_notifier_finish *finish)
> > > +{
> > > +	struct xe_userptr_vma *uvma = container_of(finish,
> > > typeof(*uvma), userptr.finish);
> > > +	struct xe_vma *vma = &uvma->vma;
> > > +	struct xe_vm *vm = xe_vma_vm(vma);
> > > +
> > > +	vm_dbg(&xe_vma_vm(vma)->xe->drm,
> > > +	       "NOTIFIER PASS2: addr=0x%016llx, range=0x%016llx",
> > > +		xe_vma_start(vma), xe_vma_size(vma));
> > > +
> > > +	down_write(&vm->svm.gpusvm.notifier_lock);
> > > +	xe_vma_userptr_do_inval(vm, uvma, true);
> > > +	up_write(&vm->svm.gpusvm.notifier_lock);
> > > +	trace_xe_vma_userptr_invalidate_complete(vma);
> > > +}
> > > +
> > >  static const struct mmu_interval_notifier_ops
> > > vma_userptr_notifier_ops = {
> > > -	.invalidate = vma_userptr_invalidate,
> > > +	.invalidate_start = xe_vma_userptr_invalidate_start,
> > > +	.invalidate_finish = xe_vma_userptr_invalidate_finish,
> > >  };
> > >  
> > >  #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
> > > @@ -164,6 +212,7 @@ static const struct mmu_interval_notifier_ops
> > > vma_userptr_notifier_ops = {
> > >   */
> > >  void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
> > >  {
> > > +	static struct mmu_interval_notifier_finish *finish;
> > >  	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
> > >  
> > >  	/* Protect against concurrent userptr pinning */
> > > @@ -179,7 +228,10 @@ void xe_vma_userptr_force_invalidate(struct
> > > xe_userptr_vma *uvma)
> > >  	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
> > >  				     uvma-
> > > >userptr.pages.notifier_seq))
> > >  		uvma->userptr.pages.notifier_seq -= 2;
> > > -	__vma_userptr_invalidate(vm, uvma);
> > > +
> > > +	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
> > > +	if (finish)
> > > +		xe_vma_userptr_do_inval(vm, uvma, true);
> > >  }
> > >  #endif
> > >  
> > > diff --git a/drivers/gpu/drm/xe/xe_userptr.h
> > > b/drivers/gpu/drm/xe/xe_userptr.h
> > > index ef801234991e..4f42db61fd62 100644
> > > --- a/drivers/gpu/drm/xe/xe_userptr.h
> > > +++ b/drivers/gpu/drm/xe/xe_userptr.h
> > > @@ -57,12 +57,26 @@ struct xe_userptr {
> > >  	 */
> > >  	struct mmu_interval_notifier notifier;
> > >  
> > > +	/**
> > > +	 * @finish: MMU notifier finish structure for two-pass
> > > invalidation.
> > > +	 * Embedded here to avoid allocation in the notifier
> > > callback.
> > > +	 * Protected by @vm::svm.gpusvm.notifier_lock.
> > > +	 */
> > > +	struct mmu_interval_notifier_finish finish;
> > > +	/**
> > > +	 * @finish_inuse: Whether @finish is currently in use by
> > > an in-progress
> > > +	 * two-pass invalidation.
> > > +	 * Protected by @vm::svm.gpusvm.notifier_lock.
> > > +	 */
> > > +	bool finish_inuse;
> > > +
> > >  	/**
> > >  	 * @initial_bind: user pointer has been bound at least
> > > once.
> > >  	 * write: vm->svm.gpusvm.notifier_lock in read mode and
> > > vm->resv held.
> > >  	 * read: vm->svm.gpusvm.notifier_lock in write mode or vm-
> > > >resv held.
> > >  	 */
> > >  	bool initial_bind;
> > > +
> > 
> > Unrelated.
> 
> Sure. Will fix.
> 
> Thanks,
> Thomas
> 
> 
> 
> > 
> > Matt
> > 
> > >  #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
> > >  	u32 divisor;
> > >  #endif
> > > -- 
> > > 2.53.0
> > > 

