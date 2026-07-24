Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BFFC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A386B0096; Fri, 24 Jul 2026 15:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021B16B0098; Fri, 24 Jul 2026 15:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1CB6B0099; Fri, 24 Jul 2026 15:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3DC06B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:50:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28C5AC0157
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:50:58 +0000 (UTC)
X-FDA: 85024713396.17.39E9B09
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf14.hostedemail.com (Postfix) with ESMTP id 46D63100008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:50:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZUztPgqm;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784922654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q74P0cA57URyZMErenKk/ut8EylY34OihwQkoPdNAk4=;
	b=Tp3P1o5gFZ4Pks5x2/KlMFvc3MGpDMFRe6+e8hJgkL2lPStFum/EjwD+lxjnOorqB1gHee
	rR2WFiFK3NWY31Ycq8+d45P+e2AModTEZ7wHYLyWm3gbwuQybOsycDgvXXK7XAFzvAwil/
	mtIHer6KiJkiWnOwwNfm6t2DPBTdDes=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784922654;
	b=WbJ8hpMy5RweBFh+Fk2puTq6DfiTlk/MJHOb81X6ndDjK1NpNEJ1vjpuRs7EXBay2dqViP
	4GVqdriVHAKIX6MDbjHsTtu9yh4dCPM0s9fH8swC3PrmUIoj5YzjuzoqvqAXanF6Y0S9dl
	9PSKlXQm+2QoAJEWlqC2E4THE6p74Os=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZUztPgqm;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784922655; x=1816458655;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FNAQTQ91hM6JF8TK8K7MqqqaiEoY56FsVctwcqnM0UM=;
  b=ZUztPgqmiyyx08QyUep82ZYzmj+SUr3KigR5KuF6Qwa3Pzi7zmz0Oxps
   A5n/831IgdDs0OXwfFHVg/KQCtZe6fylffDg+bv5Ua4lPMDBdaJZ903Uk
   /XCmmVtGIYLhXk4eF2fRcTGh5tQL/kDaEqxrFoKDmtjAQWaWguACk1zbK
   UnoEQX7aOPl8mmi92Ha/Qck7kA8OUoBKiZSveP3jiXqFPHayTggoVOFv7
   OeWTA6T1FKtZncq4Op8HaKpisQG6kBKKtus7vDRrm8gVUX0T+optmOxMk
   7pddUuQ6S1aGf/icL42K5mhy7O0CTq3FHxDGLPNMCcjazuzKxYX0pnvx1
   Q==;
X-CSE-ConnectionGUID: /DmQ5VaFTJu35t180ENWUg==
X-CSE-MsgGUID: Kqya96wWTE+xbMtCEXqhtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="85357216"
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="85357216"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 12:50:53 -0700
X-CSE-ConnectionGUID: 22LPMwKtSleYiLrEb/NFYw==
X-CSE-MsgGUID: O5tljnctTE6yJkcIIc34VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="263789831"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 12:50:52 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 24 Jul 2026 12:50:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 24 Jul 2026 12:50:52 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.39)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 24 Jul 2026 12:50:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5enEYGjNIGO2s3Ux4yJbwMbz/HfMv6rhPQDgtmhxIAaevDCU6OzYkrlAug2/b6ccwiYGMeS+H4V3rGbxWN8BhYCEqj98ByCk2TLuD6h8+jzVC/4lwNtps1g9uGS64+gRnmDx643G8jTSyIsowDyuMbikJGsnZbZk/ARdJHWAEHaSzo639us5d9QRC8PWOowfvR1U6VoFvlaNfoeSWHDl68muDsD5X84H4/3s7EzST3+SPkcw9JF+7laGWh93yOLhXla20kZMmW0l/63MdHyRblSbrC7ZoV+MYEhCksxevhr4+egGw+y9lFoR1dDJ+9Qpqx1dYdTlXLqZ1e3fbDPXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q74P0cA57URyZMErenKk/ut8EylY34OihwQkoPdNAk4=;
 b=MlsFFdVzKChcZCETvyROSiZmHnKxOZuvQYkndComL+w52DKeeatcdEtfsU02C+Eks1wK6ksTJ6bSecst6CKtfkr4yhAF2HIiz1xhmab4zZ3G1P8g8JPuQWvr5zm2vg9+pQ0T2HAjSvXukKncSiWiN3Mhr8bNSQDC67rEWH5T8U4SrumtJd7ZgDquZ0jpkHwhyM2QcXTM+btR2oR6BwWfSX7R7ULxgdGVQa8Vuc2Qd0TY9BOfMT7jpSqfYg4QnhmPZkXhnJDNqYQkyOMJTT+8IPtThu3m9mE6LunHVGjwcs8I5Z6JDPGSiY76bWa+KEq1ncmtITXWofY5OF5+2gF0iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by LVUPR11MB9590.namprd11.prod.outlook.com (2603:10b6:408:3a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 19:50:49 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 19:50:49 +0000
Date: Fri, 24 Jul 2026 12:50:46 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Nathan Chancellor <nathan@kernel.org>
CC: Mark Brown <broonie@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, Usama Arif <usama.arif@linux.dev>,
	<linux-mm@kvack.org>, <dri-devel@lists.freedesktop.org>,
	<linux-next@vger.kernel.org>
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <amPCFgiNkCIRuGk9@gsse-cloud1.jf.intel.com>
References: <20260722225605.GA1910198@ax162>
 <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
 <20260723212724.GA999236@ax162>
 <20260723160942.b58b065d771401aba117bc77@linux-foundation.org>
 <amKftG6NRZy0Ii2/@gsse-cloud1.jf.intel.com>
 <93289e91-ef9f-4786-bf49-e93d91afc1ad@sirena.org.uk>
 <20260724194808.GA1461047@ax162>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260724194808.GA1461047@ax162>
X-ClientProxiedBy: MW4PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:303:8e::33) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|LVUPR11MB9590:EE_
X-MS-Office365-Filtering-Correlation-Id: d9d15554-286c-4d25-b9dc-08dee9bcdc61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 85RV+AZo1QSk8ndQSAYMnzy5eYqz78mgsbEzPNaSXP3oAmCx90xlcfiTYzUuhwNfHLM5Kl6hMB8bd+30g7BmiD4Gxx6LPQioC91W24HaG2IoXDNxpf68D7Jkf+fVZkc6e0Cf5e2hlNWTPyrOE1p4fujzZfm1SGA6zUyBF+Y6i8B3lbnM8TtH02CPsfDMXg6H1fg10SfJnR+PHDexjNewTcHIXXelbEWo6dT7PvzEdhoqs/SaXl1DX7UZAVPKMfhdq32P7/QwY3EPD7Kh/mclIdrpEMwE4sGf/xoSPd4vFq0hrHOFWqzD5UT4UDmo20LkTGFhPqIX06TgCFEj4fFQtNCVtmpEJ8MopNX8Y5ZVupRGW3TzVUn3WhMJbBxnmffsskZPaR5VcQMhqrrrRzK1dIATXp4IoUqong92WJyTF5yHWEWAowsYkni3IvU9H5FIx+LVaOwTa2F27MVBucWaZ/Rzwkie9NtorPt/8VL3HWyC21eEiwCOkNzPrfgjt6wXbkatZJRC55CjrCO85KjC+qEqnRs53hZxQnnrpvcnejRnu5Bi529P8t6esHCTKIVW81Zgz5fr9Wt4e77qXPJNVy4o8vS4Nq6HR2x+oT37lBUDUUEjmJU1aUwS3zTiAe3Uczr8TpSly164A0Kiec1fxBvMZD7k/dQaM53oBKdj258=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NsKn0IjQqxp7AFhXasUxaR+b0xP1j8vWOp0ayAW+sNIDMZnMaZo3gOcvPaOr?=
 =?us-ascii?Q?sDSR/6CrhwcBcHKLcYmWmPrGaU3usVajBXci/RgxcZN0UAcKEp15TsTxm/7W?=
 =?us-ascii?Q?L+qcEWECpKHupvWJ+uvLsyAN3ePqTj5aIncE4X65JfY5rgHavwhxpFDLnmAc?=
 =?us-ascii?Q?oOu8oUH553LIv5bMOQ2DDxtEOAcqQRWMeeeRm8MHEdU1THqhHSJkv66Y0Jql?=
 =?us-ascii?Q?J5T0qtYh6tO4mVZbc//24Gzd/PeCAQ1F+O1OqM/g8T8pDyf5a1Nf11z2mCTC?=
 =?us-ascii?Q?IpkgbJXUYuq159C04/tZldimU4Iwk8yQl3QQZmX7WBHZvAm5TSur2MIMBw1T?=
 =?us-ascii?Q?PtuZEdWdd4VRvYICAx4tK9rwmJluJYGo4LKZYmEYZjEAVryePDyEJRueH6Ov?=
 =?us-ascii?Q?UbhdEvoi2h83pW3gj6pPo+Gigvgp0eIPKN9dZk88vlVNTf4/iWqxE8ZfsePq?=
 =?us-ascii?Q?mBlcI02RVRmNqhe5QlkSx2icmcUqKOe7CLEpuvtLEdiOmYr0SDLcaMHomjsh?=
 =?us-ascii?Q?/2XL0huKF7HMVBJI8Dpvgd/mA90jDnNDNcaZt0ALjIKW+XeVnbtaEN84h3lS?=
 =?us-ascii?Q?cSNSDfX/EQIPFwoOtN94HSBbL734T4R5TBYbtlNgN9y6afeVwXa3EJj3IMpL?=
 =?us-ascii?Q?wuZ1I51xtDGHPBMMZSV69XF181GdqtHvUkQYlTpiF5D8UAUTd2zZBzqU9QFm?=
 =?us-ascii?Q?+mcs4oFLxdxI2TmLt/t6IHRo1daaFnnkXdl/YL+w0shYX0waG8tOS7BK1SjO?=
 =?us-ascii?Q?XaESkXHDerWJfsr3CVZHThq81FPSVklKhyvVaep6CwKvw2ncrY0iP2R4iXOf?=
 =?us-ascii?Q?rpHicYELNYfVX5wQ5cYqpHY9NxYWnEuas+n4bMguC7o3gJFXc1rhHaS8C6qJ?=
 =?us-ascii?Q?bVyng9xErbhw8ipu1JQwBEVfTWERigCfZZWVGKZGVNGmuFNaV+GtbO4PL2v1?=
 =?us-ascii?Q?6bPa2xsIQFP9HiLxaIuVJhoWvFLWC+HH/H9QSHKhV10bGVgQNNYEpzAUTNHb?=
 =?us-ascii?Q?6dSKGg60IiDO/VGD2chLonGXo2e3y6KDK1aciU73dsCryxAyNeDaftq/hyG+?=
 =?us-ascii?Q?8PCMEb8EiZU94I8Qh44vpOHG2URbmq7AyoJpvY2P7BfQsCB41e89Rp/g3cbn?=
 =?us-ascii?Q?bhIT/WDjaxamK5GRsqpUULz2CdCrHnUBWe0zsXUnLi+qhFr60jlqGvu55U0Z?=
 =?us-ascii?Q?p+lV7fR0/RjDgBfgP8R6V929uQ+Jidh//m5iAJ8m7kHx6Y4O1fPpTsP7qjTC?=
 =?us-ascii?Q?io46lom3ToDgh4hMUsD2WHftRy4aE7HTZAKZU6in45EgetECr5Pg5qGZrxhU?=
 =?us-ascii?Q?l02Hdpx16KX5Cek9sGcV/zwBJjulw+0gzeSawfNn4sfXJGjlnGbhpzGJ3va1?=
 =?us-ascii?Q?Lo82AV+ErttiD56SwMhwPke9L+Y/Yhgb6zePOLTP5p8/YS9EhXKmmj4qiVpG?=
 =?us-ascii?Q?qS6cxe/HF1SxaxoCq6vkAgD9lZU3Fpv5dnRGX7z+ayuRhqk449k9c9pCFjAR?=
 =?us-ascii?Q?9zumSKC3ySbaW2jq2oDyiZmkmprTbW9S22S0unEpOthG62/l7LzfDnADr2lx?=
 =?us-ascii?Q?kQ0EbRjGp1ZeiOfh7ATt9iBQ0HD7I38A17Xp9XNkleXigkJTAeon+VloJIqZ?=
 =?us-ascii?Q?pZ9w91X2UUDKnbaxiIWvMZta8R8x3MzzM0opboDZBHgdhRoz30+gb/eWgBQs?=
 =?us-ascii?Q?HZusXtNbZiRCNOF8kLoNzv7M+Wfv3IJnRORI2aCRT0xarJtN+80BrlOAlBqp?=
 =?us-ascii?Q?CxnR5i4SpQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: YQ+wzOo72YpWv6xgWw8Qp34K9d5Hgta4zRK/wuMx63+slXISqDo9mafyfnZke4Rzc1NHJplTkqrtr2t6lUqOEJ7DzYmHjaA6Zw/qehetEcdFTwoeZe4yLNzCahJMpsvxOk5BzOCHD5HT7XuxsRyrI6XQ/Sz65OngfYMT0TvBQ86Z/DOYrKjVqXZ1Nbx+GQZ7YhhYtvZSqzYjjJW6MTwO0vcJkgYAGguRzOLJf0OJbnF4ULPkICeEY0l902QGwy4Pg+kMoCZSiBE5RWPH3emjdH2gk5Vhrt2EkE14VAAsfQqqM8nX/diP1GmnmQF0qWtLyl9tbebZXWXEA7iHHQgRog==
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d15554-286c-4d25-b9dc-08dee9bcdc61
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 19:50:49.5643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtLAotPJwNXIJmgpdg6a9/s8Nhrx06t1c+aK5jNz8ANXPy+T0tajB1Mg6DnSUxRRvwKhvX0W9DQXTuaqoKb0KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR11MB9590
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46D63100008
X-Stat-Signature: 8grwim1kcxkqxn63qtdyza4u6sm6k5wi
X-Rspam-User: 
X-HE-Tag: 1784922654-59986
X-HE-Meta: U2FsdGVkX1+rdd2hNmkN2muWqwWcpuwjP72O3DDrPoZONKScizVKtkFNnB3Yc64xFYUyy57OuyvTw4924nSH9UAW5wS9JtPs1MQA/t3GsjVxDhzV0PxBqgB3Nw1+fldmDNHcaJCDgajEWcUn1SKpArpu5p/YkF+Kml31u5nA0l+23Et+lxC0/Zu1wNz3gTX9z1JQ5dfhC9aBbPfyZg7ABXKBs2BCn7/eSopTgblMTjoH1eGtTEylz/Dut7UA2URuT0VRCbtIEVyaVDSDSDIYH60EuoA4y1FNmURlsIXWYLQowRQs979YfQmbMmnT4nMy6CKNwDmtcP/FsA2ZmyjfnumnZXQl+X9F2QhQJOEm1Po4WXCgnbWlfWFTIDOX7+K7KnIvH9Ud9Uqqa2NJ/iF7dN++zhcOpzx57XTcUpGBnVJtqQJOOaT+V0py+POdLPYwlmaVUVjVP5p6YMSjpKq4WNopspo4XKcUOfy1qGb4kUqyoqG+3UToSny0Va9qdkHgGS1OGm1oO4wF3blqjZlp47vI8i5qgg78SMjFUcfKr/YBK3ix57v+6KbYVI3orJikzIVeHLfDcpK9EY85L/LTqHcMScgGz9VxvmiRKpLEW3icGcXuWAaPwrx6XYsrDtcGb8v1jCVQTj7HZhzftwhgMDeMQLNkaA+gsWNivyo71MqApoX4BkWy0Gm6xViNIAx25pyN93X+nBQ0ukvzqxl+QlDJGaecDQvEt72c/n15MQjGxRSe5sxUj7tlyI7PdExnLaVDEPWAV02SzQl228Ms0Mt83hHgEFyNQRBm1hk89vk6rYDIXMVj1jvdXt2gd4YfAPD7JKCg72I6AIfHnAxjLJMDNeP7bo4o1Oqy/MmDwHmd7wYFsMDS4G1boaiyvtSXQnvBC3oqtnAcXgtsZ4xiaQLI9Y06wwKAiwa+iMJMBPS8eBJiMEy8xQEEErLLiEceZNlw6mNZy2Wy4Y6LbRX
 ZJM/G4HL
 UTsRt+A1E/dbWyS5FH/JXEQW/fyrELXJXhyN4Ce5lM6HkG+wRqWbyx+wzAx9s+L2LrPPTNfGTbND9rKEVFthgQ1T9wluPNtVMrcwQZAH0ze0b7PUyivuT8cMf+H8eD0kexKwY/8P+4lFdUvndK1nF3ll5InQJzlS7ZbaNRKlljcJHFx4mDkj+/ZlckUAZIGFVzqbYYM6PkiDFhG9HHRQNzTxTQUjap7snEfDii5P5faK5DaSgdsc18zvsp5Aq5HY93vX6DZlGjzcfqDDqNPqvtO8zUFF/72Q2UVfZGw0WsbxevkfUm4Ye1IKDrYhhI+JZkOSb38FaqtCpiO78+bfCoIt80WTASHUjOxkP7YICfRZm/JLQK9HAC5t8T9Pjet2tk1I9+rj8upnIwPuW5KOVCEqw5VX/przc8AVA392ZI85ZxzQu2MT9p4ECyF8gBksmg2OQpfChf6KwzDJXFW6Wh8KYWqyhW6gPAvzmP6KjfiTUbYTulNi5Ji0o79bgXS8nv+cS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 12:48:08PM -0700, Nathan Chancellor wrote:
> On Fri, Jul 24, 2026 at 01:13:42AM +0100, Mark Brown wrote:
> > On Thu, Jul 23, 2026 at 04:11:48PM -0700, Matthew Brost wrote:
> > > On Thu, Jul 23, 2026 at 04:09:42PM -0700, Andrew Morton wrote:
> > 
> > > > I'm fine the drm people changing things ;)
> > 
> > > I'll jump make a DRM change so this is all worked out when it gets to
> > > Linus.
> > 
> > So should I drop Nathan's fixup then?
> 
> As you may or may not have seen yet, the drm commit has been reverted in
> the drm-misc-fixes branch, so my change should no longer apply.

Yes, I asked to drm-misc-fixes maintainer to revert the change to avoid
sending to Linus and will post a non-conflicting follow up drm shortly.

Matt

> 
> -- 
> Cheers,
> Nathan

