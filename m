Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27133CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814006B0007; Fri,  5 Sep 2025 11:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA136B000D; Fri,  5 Sep 2025 11:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1AA6B0010; Fri,  5 Sep 2025 11:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549076B0007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:53:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0350E5857C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:53:54 +0000 (UTC)
X-FDA: 83855642430.14.335561F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id 905F7C0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:53:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I0urkv4b;
	spf=pass (imf22.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757087631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+QmW9bDgQlMx81rM1brpJ78EEE+HZuOIle4mcgwK44=;
	b=am77IfBiDjWH6XEa5JBNVJwDqEcYN9uI6xrXIzkKSXq6Z3EhMPemQXZVoMQO6wgkOe1KmO
	g6evMc2PJlc0uO73vJfC9JJ4yRi821P4SbHfS8oy7K8/2cPeglJtHmAerIXb8cx9oi1raQ
	lPlwuo9cYdjwRPFT1Wciiu6FEtBpePM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I0urkv4b;
	spf=pass (imf22.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757087631; a=rsa-sha256;
	cv=fail;
	b=oK56tNJo1D86gGpnnj8rqBv77Y7zneaLclfo/hlTOapCikXsFwh8MZm6OPbHukIsOc7MLr
	Ouc8guksw+GyLg0lowv/EQ+SJRwyHKQSQ5XS+zXek/++xvFyxHYbTMNxM/cPGllewgPTBa
	zBRlKWpXwHjfWH/1ZCDeFcncL8vf36Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757087630; x=1788623630;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=NfcKKCV4WQMOP/hBmdpl3DgaCMRi7B21EHt7/LNMpWc=;
  b=I0urkv4bkWhz/LhUtIeUoBRuR1duSuvUsy0CRLMAgsY/RcMW1mZj6/te
   G3OdbcZwR8HVpQqle2EspfRMvNSpQY1CyPlR6sY47+EcvRHymJq9ksY9J
   GSU5w0wW/uMaVK3tJAmmoba7aC6wmkwNvgohYHxzgMDWUJG9F+eKIGCrh
   qz+fMTV7g7HZtABjCpx6gLvjE2veK6LCRBLD0CmLMB4SAKa4+ca9oKSiQ
   XzF0NlB/e25f4GGWj+yHwnFu3JbvybORm/v/7hEWyl9EAzSEO6t0xwUit
   60JghwOyGQMK1DV1qy2g/3XQ6OmoNgV8KrdCeQ30roL5/zuFj/1sjLyOO
   g==;
X-CSE-ConnectionGUID: IzXNNzteTqWtIA1K/Hzw8A==
X-CSE-MsgGUID: H490OB7jTbGhqsCSeBgh3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="59514630"
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="59514630"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 08:53:49 -0700
X-CSE-ConnectionGUID: 1PlC4iCuTnqYoTHe4eURqw==
X-CSE-MsgGUID: uZuV4EsgTFm3qjmnomem6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="176532499"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 08:53:49 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 08:53:48 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 08:53:48 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.73)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 08:53:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g94gFMMDCCm4WY7m/Zf6TegcDv7+3WgJPxW4is4S7TYYq9jljA3xPo7VWfOMznD2haYVP5fe6xshFHUmgPgEcLUFgi2XKDRgexMgChro0l/ReRKSqtOeOpPQ4pQ/gzV+/jHFuV0Ex+qs0zGNidSkw2fa2vCRGJifZ/fJvE4tIWn3uQk46Y7x7XlMc51IZlgH6ss9xlep7+TeRmr+sJIuO76fwn2L5J9mWntXJ4gC4bwUXWUi/iWQdihhyw+y70qg/CjjUzsMql75A2FkNQkA3ndSy1PbzE7AAfy9kqKJhpnoVC9NgaEl35StqiPhpANlY08hXxAu6lWxQTnojjOaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+QmW9bDgQlMx81rM1brpJ78EEE+HZuOIle4mcgwK44=;
 b=OsVFjDwB5hreybVD4w9Cd+TOcmi5tQ1PrrdQt91FzyjZrABZ5SlJNqvUZDjeZuHA1Mvaw0/K6dKBSXVG4N0UGmnsK6HPrUvloRsNDLoeXoqVkBL+f93jp9Kemb2hBMIAS3XBG8qXQZWTshgdPxR/beQBHO6xne+v0mjsR1oyinAdLiLjHdeopNCBEAKThz7QjK3melltGRsYFUyW7BMg5n/Lo7kCQd9NeidFsSsWffAu8iWsS2XIrWgapjT5nGQVPjhnvQTZOMXzh/grM5lgZNNCJ+7fevYF4mpXdsDVyIKmDIEZdLjYHAc90mjSFusym+Hs5EuQoPIVXRNIazJ6uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5216.namprd11.prod.outlook.com (2603:10b6:a03:2db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 15:53:45 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.015; Fri, 5 Sep 2025
 15:53:45 +0000
Date: Fri, 5 Sep 2025 08:53:43 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, <surenb@google.com>, "Anderson, Russ"
	<russ.anderson@hpe.com>, <rppt@kernel.org>, <osalvador@suse.de>,
	<nao.horiguchi@gmail.com>, <mhocko@suse.com>, <lorenzo.stoakes@oracle.com>,
	<linmiaohe@huawei.com>, <jiaqiyan@google.com>, <jane.chu@oracle.com>,
	<david@redhat.com>, <bp@alien8.de>, "Meyer, Kyle" <kyle.meyer@hpe.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>, <vbabka@suse.cz>,
	<linux-acpi@vger.kernel.org>, Shawn Fan <shawn.fan@intel.com>
Subject: [PATCH v2] ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Message-ID: <aLsHh70jI6BGHjaN@agluck-desk3>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
X-ClientProxiedBy: SJ0PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 181d0a1b-970f-4dfb-64d1-08ddec946533
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XdRMT74zdnvFaLfdkddxUffrGcd+3U/2Ty+wjzJICT6HMycYGqoWV4s0Y1pi?=
 =?us-ascii?Q?uHxWsU5gMRcoR2arnYpDg8zRc24HZDEWO62XNGq9/EYnr9WneLXR+Cg46osH?=
 =?us-ascii?Q?fnEzEfaThMl60GnfryeP+6wS77nSoMkUEEyGY0sioM76JNj6kbHLOG4sME1t?=
 =?us-ascii?Q?f1w1VTnGKrxUPANb6VnyfRlEZDBkOJDLwOnRtqStpGaGNmM1LG5THS3vmLE9?=
 =?us-ascii?Q?/zp5KQ1dPNbSIEIoc+Kg2m0REHHACL1GcFCr2u9RWRcjPn+NHE9Bifw/6KY4?=
 =?us-ascii?Q?s7qfwE0/rzd1tRL0+bsBBsxl12qX1XmSxlC5IbJQq69MopkpU1UFSEhFDP6G?=
 =?us-ascii?Q?mR17//2pcFpf26t6TzLapSJdbcoSDYIsGwcPkZS7Vr1D/ZwbBuVYXnvoq0F6?=
 =?us-ascii?Q?qvlpudzFcsaL+awCz4WKk2uROdLchai3MCzPrCIdZd1/zE0mZx5qCrteeBQz?=
 =?us-ascii?Q?NSako1zojB6U3CGbGIQx98NZYloL1zV/U7Hb3vByQwkHOCXKI5XGewqbHlcR?=
 =?us-ascii?Q?smepq5EWn2cOYApqbQUa7W4lPR3tskAjghP2rukb1CbVNaD+dIZ+q+eH92T/?=
 =?us-ascii?Q?YqBNcfIQk3TJeUsxVh0g2h0nSvcwpf/FiwU8B3v5R/FdK+TLs4qnepa2CTvt?=
 =?us-ascii?Q?t3SGiAb0QWcdaVmbJ8X1GaOr/5kbbxFn3HmnHM7LsxT+XX3knHukJ2m5EQ2g?=
 =?us-ascii?Q?s8gdYjQ5Ffzt/Wtj542820yFEzZ44/eDf4cMtHriRl2f8VV5zU+Izvn0Uf1A?=
 =?us-ascii?Q?7kKiPsQ002VcJsQ/hBysEj+4pmI1aYtdU+MJinwk3l69A5IEkkqdHHGEMkaK?=
 =?us-ascii?Q?LQQr/g2LLxR78Y8u/wimUriTR4KSyqFF+HU1IxVQnGn4Emjxbqb81zBWBQDO?=
 =?us-ascii?Q?9EjKpIf/0UC0g1jzKwhibMw+/If7S9HHOqNyxADuVm0nCSjxsc/hd1YDZaDj?=
 =?us-ascii?Q?tCJ1H14DVNLiprQRqDbr8rlr3xEscURYsfSPaErKTGjkdjv22Pkf7IZMfzPc?=
 =?us-ascii?Q?k75KrJU5uyFnrKKfyXxC50W49UB09MpbjlpcH1sFpdoMk6AoyG+ZsPpi6qdP?=
 =?us-ascii?Q?rXsri2w4asb/MwQw31okKoptohUINNyPzXmmvji9fsG3pLhlwIZxpm+YM2Rv?=
 =?us-ascii?Q?Lfq5oYlj7RlNtq3rgJyFcwvUM4th7YU1UmE/WSLr3qM6qpfxJZqK2s+fTD2O?=
 =?us-ascii?Q?0bHkT5a8KjK1kr5UbPvrhY6HuZmxhteTf8A38LrUt7IzlCJzs+fXSGBcjGft?=
 =?us-ascii?Q?9sampUNP1/sJr/6paKSpCNvWFA1fc/e8qy4ExcvIHIgik8nFSpFexq/bffzC?=
 =?us-ascii?Q?fvzrjuuYNbkDN+6sriaTt0y20B07VVkAWghr5nGoQBeGLIn8ZQ2R/bgJvhBx?=
 =?us-ascii?Q?UfcGRIfqYqIeA9fBE27bW6m9HZ4Py6PZyik3qu6WudnZOd035qqJiaa8d444?=
 =?us-ascii?Q?SahBtqd3NWrXrghUf5tbf+zbKaLz2uIsSB7ZfJmpA4E5TMF58D2M4A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0OB58gIA7TqtlPzk0eR64cd0dIvoXpFjEehF1y4oFu2mWqnBWs20khDI/ov?=
 =?us-ascii?Q?Ha6CfnwNUhzQvtQrHjndmdTEaR46LiICNbFDSpX+AwX/I0Lv59sXnesnlad9?=
 =?us-ascii?Q?MSeSAKEe7PA3X26U4M/xxDeDLBMnYqQRaMzOzgWw1QTF9MKGOw3wJilsEYOl?=
 =?us-ascii?Q?doTVDWMlmTAbc7k04vxfBs/yARRnUNulqaphdG2nd815XqPNqlF5MTa9u06r?=
 =?us-ascii?Q?63EjslW0bmrndL7BhKF24quiiUQF7YNd1o40gF+fvwLfrqYzJEbLD11BESX7?=
 =?us-ascii?Q?DkVZ+C/LOZ7O8Ovrmri8wOkyJoFz9abAVpUHv7q2hbDZUc9hKjN3dlx1lIpt?=
 =?us-ascii?Q?NU1E/j3hmgYvV4Spi3gcqYh9pQp9jMkBADlSRzkh/IrmSn5PRpVEktm3OjnM?=
 =?us-ascii?Q?oBjOnumszhwER85EgHthICZWjdsUdA1VnolgdHT/QlyJoFnMAngi7AFRqA0Z?=
 =?us-ascii?Q?drv7GoStt01Hp9Ro6YGAGD+KWaBsUJKN9QeA38RQs2vrWU9eQZ59yP87Qc+2?=
 =?us-ascii?Q?rxeOGcrHjbKD5K5AbkuDNreeSj51Sdx4FErf9vfk36ZJHrJw2qDfmc+x1fHg?=
 =?us-ascii?Q?YobECWuCqaCowUqApNAJaVTKckEKfx36HGcKsG25RSd6Zaij0PKKux+PaEyr?=
 =?us-ascii?Q?r7khthHD6JSWKf0E/k3hRb+CguGmG0pj/VUZamA4IMy8WL5+GmNTWgjLDt1G?=
 =?us-ascii?Q?8oJ+nBL1Oy+7rCvP7rG5VTYRBFp47BFDOJf/e+21SrkF6v6eThz2QFimgKnf?=
 =?us-ascii?Q?Hv2IdGht/r/saLQW+Aa5Z0WE1t8RjN6P9wcAFBar42iPCLrbE6E3ANxwggB8?=
 =?us-ascii?Q?ha/HhESPTIi6nAHxakKzYgor5sUq2SwYpm4pYs+KQbOkHvgMXY4cdKLjd07Q?=
 =?us-ascii?Q?T9d/8FYItr7UGjA7tt3r1k7bywHma2iW4XsJZoVDOgwWIWPC5NiMGAHNXWAl?=
 =?us-ascii?Q?hPnbWAdEFG3CPw7dM+Ax4pRkRRBOCgDAmuz6Dt4xwjz8Hj/+JwK9S2S4m1Xl?=
 =?us-ascii?Q?KKP9o5tn4hL3/mHS7/ZJbFKqRBy0cEccdgcsdHvEPWdMFAoh/80jgbuUNgY/?=
 =?us-ascii?Q?mjoxfk4QnBgLmP2fBxqqfRJm908qDoojN/KIhrxMRBpAi1LTKl7z8fboBzmK?=
 =?us-ascii?Q?Oc7j9RsPBLX44/VFHyCZRlf8rxa8Qu6dAPK4HEw4hLDWB8o7waANBgl0ajwn?=
 =?us-ascii?Q?GJSoWqefcACrUdlmuTUnNQPOhUuvtNqNaO8vYsm5NqfxEOsMHPbmQsMZkXhZ?=
 =?us-ascii?Q?9y6uS5SmjeVlm5VLQ+ZmfN3bJKdkp8BCri6gaGuyyjeHBRcbU9HkG2VSrjyt?=
 =?us-ascii?Q?uLA03MJkQUxX87QA1C8B8urtxCbEyFZBhtbzA2p7ElIAkvR/sfA3Ul0N+/p+?=
 =?us-ascii?Q?JYbPYzz6wChQZz20Km9hN0KZm+mzLrftf2l8Wg6PKNwpIngVigesEsKXy6py?=
 =?us-ascii?Q?Sz2uKtll00nbLqgbReuXmmy/UxW7DeuAmfpuWxKmeytfq3ABxgOVMgjeS2DX?=
 =?us-ascii?Q?AC6eHHFBGtokIZiv90Qn8VIltU3ZePBb724oBzb1kTxrvz9ZiUH2LsLv3vtc?=
 =?us-ascii?Q?D+lIVJVboGpAOoAzmrNaPVrl4RKBCJPWgpn/D4Tw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 181d0a1b-970f-4dfb-64d1-08ddec946533
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:53:45.5975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OWXGDRY8VCc685Lepcz2YsNbSrQBHiuaWWtTEtp5uESsce92T4Fy1sHvS6kN70JneQNpmlJutp2M+5Zq9pneA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5216
X-OriginatorOrg: intel.com
X-Stat-Signature: qmechc3i9xipa11phopux1j1pipn1cyb
X-Rspam-User: 
X-Rspamd-Queue-Id: 905F7C0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1757087630-352441
X-HE-Meta: U2FsdGVkX1/k4sYrWe96vpQ/hBOghvaCTxdqJm5ujBXfBhCiHASmZPFDsL7eWJiuE2A6pS0c9CKaBSfkkTE4RVWc77GyQYsI63/siOKZF5fqwOm9wF+0toIrUEqsakg5lPGDrYT+aQY5B58YYSwWunUEct7lJAL75cA37NXhWkKaMtP2w538vnzZYJ+rIQegYqRQ9aJOmEg145Qh+zUhSxIGHYIMnipEUI4P87qyOjzoncvGdufhRPvk42RWC7rzBHu8eOivLD5sTNKQHFdMohvP78EaHY8ynlciBPAlZ2m6kzxs5a6rYM5y1B5E953lpMAA+cZo1PWuGjg9xzBYExCICAbvwIAsizzOfvZdb1LxGK9xnJNBag5GKXE9PsFLLvn+m4xTKPSFyDp5fO7Mf8xmPNgh24zFfytooZxeC2WtkZ/dOf3TnMXT5zm9FQkPotjJ7f/lmieXW5FaKOqnc6KYAg2J1pKXpT5p+Dr+lHifT/mSNlGoqZNEBxtI14aSt+fM0n6DpuTbo5+lH42Sa0nqUKLmDqBcws+fkYx0r94p0m1pqUM+LelA3f1/4CLyqVTlU8wBwxzVGaq8cCOU8moqpvn3WE7zIVYHKMI8rFUxCWi5Ho/sBT3ZnCxk9TeryWrQ/bVOmJTB9z1cxtaIrle5PWY83tFjYu3+yEvwcR46TPuTZX2uOaAKXsJAM9AcEBXVTg8H3lv8Y4Q12n8mvzizMXwUBsBnI7/NEg5YvjiNgu3RTnbq4eQtGlZgKvga4dGxtXe9blZGm+GJ7H1Yv3hH0V3UZ1LU5DyEDY/ELuzn1x79d1lLmMCo24BXVmsPyyVOd7F3pihMiRntbB4rfR6ozTmuCTT3+6Ow0irg8ufFsCXZ2bqpA9q88wicqorM18LRDm7d7dznGJWzbqsb18boTgEVkO/KfLRWiPpYk/CBcBZMqHFSd5Zk4jYb5UHvro5wyts45vwDUhaGQjQ
 sawPhm/6
 ZgP7IDSZsvyvNcCLTr+rTX77jblLmQsW+1o0GHKcktg9Lvsix3xOcvq/wgUq6WYhQNb7f8TnETg4uY/KlrqRWOCyT1zjAk7fzP7ZKlAUze7TfNmPhT3HooT/E8PJ2paP/vmPkCstkQhInKhWQfA9i1pvu9xkVgACit5FailE3sdINhXxii4AOQgue7P44Ms3KJqiIOumsl6EZD76cRuHT+LmJC6d2BATpfXpTOKw2PgBiboE+q+6CdglGXbG7axzlUkRZzvFMQSp+KknkS1cyxV1rFMB8+3QxoYFm5dpV4ji9jNRbTitJMGKKlLrZqhhV0Ufl4/eYETHnfiaI3ryhhx4yjGwiL8DdOZ8LWjNTr7d+gdao8E5bcMI60tj0WI60ojqHAALQK1sNihDGiUxPoZGfKVKpnopfwKr5pXPm1EAntrEPb8FYab/L2imVAxo00U6SVEH/zsvFDucb7pMFwHEjCzz4hN8anpHmQE3KPecNchxIGOhLivN713Om5FLXJZ/BqY+sT/A/JEj9JI0LOWX35KD6p8EkOzRiYzpyX9Of728RRTeaeYH07iWQBvNjiw+k0hj2ksnjX+Pqc2STHgpXeqW2TOl1zETFHUTucBgNn/NDq/HvrnV5kPxrCFG7moBpjP8LWB9mYy4VPS/VsoVH2y9zdQtMHj58
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BIOS can supply a GHES error record that reports that the corrected
error threshold has been exceeded. Linux will attempt to soft offline
the page in response.

But "exceeded threshold" has many interpretations. Some BIOS versions
accumulate error counts per-rank, and then report threshold exceeded
when the number of errors crosses a threshold for the rank. Taking
a page offline in this case is unlikely to solve any problems. But
losing a 4KB page will have little impact on the overall system.

On the other hand, taking a huge page offline will have significant
impact (and still not solve any problems).

Check if the GHES record refers to a huge page. Skip the offline
process if the page is huge.

Reported-by: Shawn Fan <shawn.fan@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Changes since v1:

* Mike Rapoport: Save a line by using pfn_folio()

* Liam R. Howlett: Don't return false. Continue to rest of function.
  [Yes, code could use "else if" since "sec_sev" can't be both GHES_SEV_CORRECTED
   and GHES_SEV_RECOVERABLE. But I left that alone for now as unrelated to
   this change]

 drivers/acpi/apei/ghes.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..92a767fa7ca4 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -540,8 +540,14 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 
 	/* iff following two events can be handled properly by now */
 	if (sec_sev == GHES_SEV_CORRECTED &&
-	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
-		flags = MF_SOFT_OFFLINE;
+	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
+		unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
+		struct folio *folio = pfn_folio(pfn);
+
+		/* Only try to offline non-huge pages */
+		if (!folio_test_hugetlb(folio))
+			flags = MF_SOFT_OFFLINE;
+	}
 	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
 		flags = sync ? MF_ACTION_REQUIRED : 0;
 
-- 
2.51.0


