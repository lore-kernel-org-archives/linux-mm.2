Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F99C2A073
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 06:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D75E6B008A; Tue,  6 Jan 2026 01:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186816B0093; Tue,  6 Jan 2026 01:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0596A6B0095; Tue,  6 Jan 2026 01:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E77926B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:41:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4349716041B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:41:48 +0000 (UTC)
X-FDA: 84300593496.24.04C8809
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 318F2180006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:41:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WCDBURLq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767681705; a=rsa-sha256;
	cv=fail;
	b=38Ruxa/b4LzmdQ1Y5U0SbMlojqc8rlEgycjvDUP2FXrj5arAYnR20QPDfByL0tTWQUT17r
	Di+gBYxlJMgUKhNaPynCWzeQKLonf/eGIoiZNv1cPQ/MNHJtrePxV2LE98ieyWfavjHp89
	Qt8Awg2FJtUxHJe9VHqvDrVjJQyAYbk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WCDBURLq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767681705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5lTd2dWBuJXrLeXKkUZrQKACrwlEv213S2CmxjwDenU=;
	b=pwUuLFbuXd4a6u/elB6vqbj5OEhpnEkNjr0ruYaigGWLZWKbwqMH+Qip3Ub1ZbUxIoyFCa
	e2eFmM/rEL0dHMzr33RzC0KnT4EO7QO4l3TUXXpQXqFLHjb/02ybK0qJFr7EjbyOj1sUXh
	4Zb97aog4ULThWjkK6A4Fdmp5lTkF0k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767681704; x=1799217704;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=gdr2Q5y3Z7pjsUlwKtFmDbEudQXQ+HDI9jEt56iRCGc=;
  b=WCDBURLq6CN6NfyEd2zGAYlWV7MX8PCzLN4ENRoWkfbdJOKK6Ztzei2A
   HmwzQPlp7ZhGYjip6C6MRIAxMAo8tI0d5ygUnHDnboeDOZd8mCRZjLC2O
   M3a4/JcVm5P9OMDe/oHvAuS3seNKK1yoiiEexDehemXvOrkSegnO3G4zE
   6UAGqOo6SuX2Ec5Eis0dQHh98fr+aq17cqfU2R+hHOc1U8G2N5ldvOPX2
   DXJno2ZbjSVABRv+LpcxZxLxgrSzuHViJXsmtvjOohQSmbxQAXnuEC1qv
   K4Dig2y+Xsd9UNtkHsTFKd9Matm2HnUHelr8EF3BJAbm60CP0LBAMHpS0
   w==;
X-CSE-ConnectionGUID: Vv02VbR/S8K/gnJY7NkHnQ==
X-CSE-MsgGUID: rpSIQf22TUi5ggDHbro2vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72677299"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72677299"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 22:41:42 -0800
X-CSE-ConnectionGUID: /O/GG21iRH2OgcelFoYz9g==
X-CSE-MsgGUID: E3rxn3uQSEqTBB/hgclxhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202205447"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 22:41:42 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 22:41:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 22:41:41 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 22:41:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x6I7sgamBJYXr9Wa3bEnVQpgs5xYvEO6sGiuXJscsv8+vYvZvgNfVLM0qlczo8Ay+HklxmzErUFpRm3rvWFUPBp0kyOmzQOeszlOsFH08Tsk4aWZm2S8czWy2q65FKhMLKEGj2p1mqXiyeb3P6sptoFuwLQ+M3j/OgE17xinayq3RdfvTEvRTChDb8a28hr63bakIt09y1KdjZ4a/JpUNi7nJAS+iDUXj8NpHVjtkuGamHLYyyvunC/fdSj+X5yBauc6rWSuWK536dh2V4H8hUYvIp23yJrMTAmzIU0pGXUKzy1sI4VoFEcLKf3FRzqaSh+DCzTLfRa+PslliuxHGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lTd2dWBuJXrLeXKkUZrQKACrwlEv213S2CmxjwDenU=;
 b=JpJllOMMiyZevRSklU0v4dINmkpAl6QaY+0Pkxwgly2hslNtNw2H6f/p6RKFlqWR01YxvMqyPJ9YRDwP+CEr+x6suQsiGoXfL+2quDIuaB8vu4yIMe3wqbhg32LJs+LerpGgfxvTQ7f6Cma5mA3gJ0BbiMWyNu0FwTZ/8dZUOoSt77Tk/1vO2GzCHyw8sXT1mHDEaK5tFpna2iFaWxmxE7EtNLwdHliNldSSf1c88laXAdD44s27AtYhj0m5bpYPucMua+ezW56a5Y2DxkngHL1HsFPYayii2ehf9mQ9MhKpkROBNMqWjgDqbvdUHM11f5MjppBOgEHVAgWDZkkuvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB8549.namprd11.prod.outlook.com (2603:10b6:510:308::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 06:41:34 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 06:41:34 +0000
Date: Tue, 6 Jan 2026 14:41:24 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <gutierrez.asier@huawei-partners.com>, <sj@kernel.org>,
	<akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <oliver.sang@intel.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Message-ID: <202601061219.9effe621-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251229145533.2437293-1-gutierrez.asier@huawei-partners.com>
X-ClientProxiedBy: SG2PR01CA0111.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB8549:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a84a68a-6b59-4f27-02df-08de4ceea26f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9amVqqHVGeS4Ih4zl9Y+YVwBK0XyOo3SFpB67AhsdNds3I8xbjTcjQOSuTeM?=
 =?us-ascii?Q?rLdfRqVSXtlsKdZdtFrkBcVkfaxUS8RLYIxMEiI2ctVp9dmXGxuUCbVdRVoG?=
 =?us-ascii?Q?nQpjnF5J/fulkcuIxKjNnhzFicMbRyAEaPG9quzHPj11E6QAlbk+nFK3MmLz?=
 =?us-ascii?Q?fBGT3RpTnPzNUgoOk8fMv5zTiCpY7fO5PMbQ+X+CRZx/7lcp2/vN2A3XvnSR?=
 =?us-ascii?Q?mKRvD6KYWw/SfuNt70d/TVrq5VUK+O0Z88OdFv2G3OA26oHwCYzStGHQYchn?=
 =?us-ascii?Q?PIfbaD8F8CHpAahjk6wjXTVoNxeloeRCvrAGwG/IODQ5Rh6IXu9dEJ7XQfG3?=
 =?us-ascii?Q?t0a5QO2VqXdX5sLnG2FBFUQA7itnC+4iPjVhygckVHSAw5fjk4G/ScHHqV9F?=
 =?us-ascii?Q?RsixJadfF7K4GSlqa/Mx20ErBR9UmU5Ssd4fam0xWINdl7P8nYi1V0RJHN3h?=
 =?us-ascii?Q?PQIFlVdv7gkp65x4BcsWvojx/VhzQZUTM+tSy54IHgUFqEie1/8VF0YjHw/6?=
 =?us-ascii?Q?o4YIykaJjYmqQUdcqkwbi4Fa82XdmpJBCNmBxAY5AMwM/IeZGOdpraI0T8Ur?=
 =?us-ascii?Q?i2D9YyCH6nbdIFQQgEmAmzVXZRSlVpwiBTkb7UsMxLH1WZqfytJ2NcAZB2MC?=
 =?us-ascii?Q?yUQD1fB2rDaff50chBaUvEYOFWpBQ+B1hM3rn8qPl0P0hbcjP5xulGDAhyDl?=
 =?us-ascii?Q?HoW+nDJnG28x9y1iRUkZKtesrcMa64aNx9E3cwSpV8VUn1e+wU5x10UzHWEO?=
 =?us-ascii?Q?sxvgGRahsfs/OTXWkgoeaf7L4nWfQ92r0i6fOeeE9ewAMVIuWDsSx2VG1PEy?=
 =?us-ascii?Q?GNiqc9FL/FgaxywxO4qgkooKjMK0IOw2omSlfUTbGNYW9dudsIyXUIzsFqkg?=
 =?us-ascii?Q?cTTjf5T3r7f9pIJ2Mg+cKq3ChbmSCYv69YsSw2gb9Nm6WOuuzmgZCVthg7WS?=
 =?us-ascii?Q?xNzfag3H3O25ZI2i0fkWwnTb9Pf1YwvQ8x6xgtUuchQECJNFDFJWlDC5DJHQ?=
 =?us-ascii?Q?umP3HUyd7D1v2t348+gOr84gzX2eS2zqr4lRBT0ni6n5HcmGH6mXnIuTMjPv?=
 =?us-ascii?Q?IkygAp0g9B08F3SJ7RaIF300pqGYICRv6EZyDyNkePLGzQHPBhHcN7XeXhAE?=
 =?us-ascii?Q?OjpBxGOloBRoyDK/psCBgOtcKAhCX4B5KKNi/WFd8bwTAbJmty9XdV8T8X0w?=
 =?us-ascii?Q?/w4UfsYi4W1aT7LWxHQtxozskKxrF+kmASv+w014ZmIMEvw7p7of4pjjOz1m?=
 =?us-ascii?Q?8iMU7Ralwiq8udQa5lnzpOIJLfo2Jj7YgC0TU3hQ3TQyL+UivaGlAfoAu8M3?=
 =?us-ascii?Q?gVCt6YoLT+7I48k0LjfTsmALMKS7X5+R/H9aVFHcZT3OnO1GpmHz+jMRM996?=
 =?us-ascii?Q?3N1drjeNGSm5nUAaC5Nzh8eGagup+/gGEL1EbE7GRLPUF5UnmElUrcTcJ+ia?=
 =?us-ascii?Q?uMwi83p62SACHYkrYBkyJrQAPzFJ/eoDpG4lPZ2sVA/TFsiAitozcg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lgPzNqlTPOSJ0nRrjd5EY9xJhMbDATofJEIpQ7fXAm+uSBimv5QVVQB8Lmnn?=
 =?us-ascii?Q?fEVRDQENxrKl/18KOaxgYhWIdJ/b8/4szDezLjWsCFVkXn0CFkFKKGdWtIIU?=
 =?us-ascii?Q?7Xcbu8dfWS2X3LFviVptrX/7DKvdLXuJzo28844V/v8vF627sicMFO64aL/K?=
 =?us-ascii?Q?G9UbbEN/JHXfcKQhdcFj8LeefFVdwLiOqScCREEQcTnEZuaMykvnwq/vjy5d?=
 =?us-ascii?Q?UE8qIrCcpK5k+iYWUGB5O0Ifnt63v/Tf4nT09z7rfx+kA///JHNigpbHFyxb?=
 =?us-ascii?Q?f88/DXUZwJv7QUnPxAaDLwshRL832MWpM0/ZLCGiRPR5sBU/vVJNzJ7wQ/Da?=
 =?us-ascii?Q?Z8XmHKgB1YMyiV5bwAcWM4atLAjxri16JmIbCVPnkELqM1S0hqSJ+JoJshFP?=
 =?us-ascii?Q?qR4YGoiU1O2wQHNAEwEkeqfh+B2khoBCV8Jld1PPNfbO+Z8gesl9X/Qz/LVB?=
 =?us-ascii?Q?Zvy5psKGGe65yGswfv9aHwjemdYWjoXROee8gLmSiUBvrbcBahNbaCqmiYLD?=
 =?us-ascii?Q?8wEpA2lGBJiwLC7xD1PB6GbW9CRFG7M+l2C0DaeU76SwJkFvn2kUtvW50yhv?=
 =?us-ascii?Q?ThrBuknkvoYS4jCbS5RPeVpRdqkkzLHHmqtkayB0DImBL+wXs+rv2R3HMn/B?=
 =?us-ascii?Q?mJKYkO8AOPryJ/4sJ9edfaHqFSQAsqfKBF6hyIYWeLxd6mzWzUqk6yGgFx6M?=
 =?us-ascii?Q?ZEGp/QOR74AtzSkKIHTyQ1ArHYQMsGqArj4kwlfmXOOIvdcSiFI+d+Ikk2rt?=
 =?us-ascii?Q?2rbSMTu2DrsWqKACBkY4wFGjB7bt27PFM7gWjbG1/TCvcr3qSpU/y7COIwvz?=
 =?us-ascii?Q?hWnhqn3G4Fe28EDyQvBFmBNLbaCplfoZBOiFVUDVB8KR8zRcB5GoN89+Cdw0?=
 =?us-ascii?Q?kilsfs7zHKSg+gtFL4IeDKE91vsWRj/vepnnZ5+qUbvrApixa4YkGIUY5YBC?=
 =?us-ascii?Q?ZYc94gea5oAKHAxrBtvOjbbCbbaNbbyICh29po7tj9Ih2obsWqjYhA4Cylec?=
 =?us-ascii?Q?3/U2HLeGtKzH1+07TkN7XKC985fvobFMVloe6a8+70XThIi5dXxRUW6xQZyK?=
 =?us-ascii?Q?jR4SLsz6yeu7qIcyNKzeikN/oF+64UizZuIm3KzgS64epOjnGbe38SInBYP4?=
 =?us-ascii?Q?x9kNb5QTDCMDYtWK955Nn3wZ64C4JXUoL//R6aZJUlEu+VDOc7yXZ9gmB9S7?=
 =?us-ascii?Q?FFsbVDloe2DWHtv0DCtt/Wd6DW+4z7l5ciY+udu0JE5pXvPVNNNRBZw745gk?=
 =?us-ascii?Q?F+ZCPWI2J3BjHSLfmxfkKgy7GF9HIfBsOLCsnl0jsqyyw1OUzCphksP/j55V?=
 =?us-ascii?Q?554ulYBtQIKesikSFTTmQucFKoTaM5ynYeIVwNzsuJiwUGeN3IfF9PWjyKLh?=
 =?us-ascii?Q?drbwM9gqcRPr8Y0boPXdpcHK8HvAb2vf+qQwoqe9y7EgQPLql8tpRn30OmFH?=
 =?us-ascii?Q?JRYGMOCcJz8gKeDVeWN05ipMGQuY/Khih/FP9pLSY9UWabXqKl2Cd7fTyKjT?=
 =?us-ascii?Q?zanLfoYjISkPncgM5+csQAXpfukcDHRxRb89oiuId0T4v/s9kBOE/02Yi43t?=
 =?us-ascii?Q?DP3ieqQFemlCUsKTnhjWsnKP0PZb2/8xbCEM2thhW7XRhy4odn50eLXqBDML?=
 =?us-ascii?Q?NB6OtzZkqUObx54SGW57MOyztPhh3k0XJd5uGRBQUEewPhj5B/ZKb5elelVS?=
 =?us-ascii?Q?d48y+cSX/za25p4phx8RVSyPW0PeWLfTg0pbZAMWv6qVyb1hr5dlFK/Pn+MC?=
 =?us-ascii?Q?hYkIpUiqzg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a84a68a-6b59-4f27-02df-08de4ceea26f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 06:41:34.5807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saaxwrJKGEfy1cKxi/iEgIuyvypb59Q3EVuWzMvC2U2vSZzNi5xqnHKFra3PyxPsElY+lV+Z++xfdHRPgyB7Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8549
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 318F2180006
X-Stat-Signature: 7xqb48xrr7knn11tier7sdfhc4gerw9f
X-Rspam-User: 
X-HE-Tag: 1767681703-605257
X-HE-Meta: U2FsdGVkX1+E560BISTR5zzwa0Kfm03TMJ2kK1qUZ5kYo5Xt+OR9pQ4VyLSSE7AWjIVnT+exD6Yr3IWtJ+y2lzhBhp9yFTcM7D4JEY26LhIaHgmFbtgzGP2ZlwxFV25RFqmBX5Qqh5RCLIiM4IiCMvE/Y23+kwlpTMGtIp9mzrZ90mEgvbm0OLqYhMaoNOnmp2Ycuv6OZCTBN+Iw734dcw+cQ2u0PMCZsYO1ySubwSPagETIFuMkn30ui+ESOMWzqM81rWSY9eCLo6fSu0z86N9kIcosSmsKgrZS19QtL13uWvqARRpwul9iJep+iw92JXbW/IDbhG4m+ig47aSJrS3cFxO7C2D4gpidk5hF8AXe1eNzzVc7g4t5QdbaEwWZ8FpyJI8OVLYha7a5qZKgahvdX3jSmAvdUUrrp+2jyx0Yq8KvVpQ+5kwqtDJPJa5Bw6b6o+ggutNbGyad5St9wPu1PqCvFlvSpoT31k9Ev+8/b+7zLHqj97MsLk4lpSg8CTU/AM4TpNfTqNeF/Haty6T5lBiWzMU/35pezo7ntRekTA2o9AmngaVRgG3FALiwajFkcmIG1WF/agbpV7SaX77g1iOh/Jxd/Wghv7HYcnwyvUKXJe8z6EK7j/3UvepKYfY2OLYL1SamHyknSckD2MZBaxCixkcLAPN7oQZFLlVIuOCLjHbAbtDF6UmaTt9VErt6ExeUH14gADuAmsp5p7UzucCaqRKdAVcmU2hlyvTjZypfAiqLRMu51yQUhXESWiILJ/Wfv1OSl4gzTDj0M407qV1cmAWZmy2cCreha5m4SaGTq/GHBzTwkNArvik+PrYpaDOgK+r1IVNhM4m0FSyX51w54Wck8qLlTjVfq12Db+1ppH6Trw3GNMu3EUvazGVigi/4tEyDBflVlDG2traWmpDdNo2+HGTkoWcdJSJMsM3YtvuUlwZGBsDI0AO6gvLkumjIqBy3VIdIrDQ
 bGIYelEs
 1LzNU/M0foJhkqCcxl56fh9JiYHw5C1lE+/vQHhn0ac1kCBj9J20nKA6cbfPpiDT60Dgj30hg3aDC817PjPJ5kl268GXw94ACOZJk61P/TXBe4JQ4g6Tf4cK5vkGb/Kj58FL/oJlhzZgfki341eibnvKoq9NyqbrKGhlMj46oeaVwYXRbTEpmg4yo3fg7NuOfuu++ZGCg56d8fbNpuAKBDFUjOmHVgRyDGwDnRCXAen0naaJ8i4QZNzgZ3fVtJuRsxwK2uTjdcUwaknmNDCL/mD9SX7ilNoX59Q+MfXK9gw7EPTlrzaQlu99MJaHqqhBq9R34PMzJuLfHS0PiW25blgKHT5Hh1qPBwYMxM4q2iLRSRez3LSqkiZ67CrvOcROS7kbeMXL8GvPbfuKTFa933vN3K6y5S0C2bLnNAtdy16wX01jUgz60vKB1VS0y2+VdWgXYFCQq1gM9JcYCXxjF2XVB3vLPnNoTk9FS6cBgfhz2KrM5J41AY9NeeEb/wSouNbhO72/sh/ZUxMQKfDCzfcLcnzHwWkWggAehij/Mqdgbl9KADJZVgbevtDRSebgvlGEJqK/t5ITKPXhJXFdQ648J+Z9N4UfKrXm7ihyE7p2HC5fIGMq3vcxzLo21ARnva3X8sBV2RoG86ESbphzU70V2yQU8q0wfWYZGyNRHmj+/gcEK4GI425qOGskP1qYPl5ulvJyx203QX2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "INFO:trying_to_register_non-static_key" on:

commit: d87e70902c77a5dc3a4fd4fe78c1172b4b644495 ("[RFC PATCH v1] mm: improve call_controls_lock")
url: https://github.com/intel-lab-lkp/linux/commits/Asier-Gutierrez/mm-improve-call_controls_lock/20251229-225805
base: v6.19-rc3
patch link: https://lore.kernel.org/all/20251229145533.2437293-1-gutierrez.asier@huawei-partners.com/
patch subject: [RFC PATCH v1] mm: improve call_controls_lock

in testcase: boot

config: i386-randconfig-005-20260101
compiler: gcc-14
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601061219.9effe621-lkp@intel.com


[    1.225255][    T1] INFO: trying to register non-static key.
[    1.226642][    T1] The code is fine but needs lockdep annotation, or maybe
[    1.227181][    T1] you didn't initialize this object before use?
[    1.227181][    T1] turning off the locking correctness validator.
[    1.227181][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.19.0-rc3-00001-gd87e70902c77 #1 VOLUNTARY  7c12528289a79a90bef93a94128a85da378fc562
[    1.227181][    T1] Tainted: [T]=RANDSTRUCT
[    1.227181][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    1.227181][    T1] Call Trace:
[    1.227181][    T1]  ? dump_stack_lvl (lib/dump_stack.c:122)
[    1.227181][    T1]  ? dump_stack (lib/dump_stack.c:130)
[    1.227181][    T1]  ? register_lock_class (kernel/locking/lockdep.c:985 kernel/locking/lockdep.c:1299)
[    1.227181][    T1]  ? sched_clock_noinstr (arch/x86/kernel/tsc.c:273)
[    1.227181][    T1]  ? damon_start (mm/damon/core.c:1372)
[    1.227181][    T1]  ? kvm_sched_clock_read (arch/x86/kernel/kvmclock.c:91 (discriminator 2))
[    1.227181][    T1]  ? __lock_acquire (kernel/locking/lockdep.c:5113)
[    1.227181][    T1]  ? lock_acquire (kernel/locking/lockdep.c:470 (discriminator 4) kernel/locking/lockdep.c:5870 (discriminator 4))
[    1.227181][    T1]  ? damon_call (mm/damon/core.c:1460)
[    1.227181][    T1]  ? damon_start (mm/damon/core.c:1372)
[    1.227181][    T1]  ? __mutex_unlock_slowpath (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-long.h:40 include/linux/atomic/atomic-instrumented.h:3189 kernel/locking/mutex.c:947)
[    1.227181][    T1]  ? hrtimer_nanosleep_restart (kernel/time/sleep_timeout.c:62)
[    1.227181][    T1]  ? _raw_spin_lock (include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154)
[    1.227181][    T1]  ? damon_call (mm/damon/core.c:1460)
[    1.227181][    T1]  ? damon_stat_start (mm/damon/stat.c:219)
[    1.227181][    T1]  ? damon_reclaim_init (mm/damon/stat.c:258)
[    1.227181][    T1]  ? damon_stat_init (mm/damon/stat.c:271)
[    1.227181][    T1]  ? do_one_initcall (init/main.c:1378)
[    1.227181][    T1]  ? do_initcalls (init/main.c:1439 (discriminator 3) init/main.c:1456 (discriminator 3))
[    1.227181][    T1]  ? kernel_init_freeable (init/main.c:1692)
[    1.227181][    T1]  ? rest_init (init/main.c:1570)
[    1.227181][    T1]  ? kernel_init (init/main.c:1580)
[    1.227181][    T1]  ? ret_from_fork (arch/x86/kernel/process.c:164)
[    1.227181][    T1]  ? rest_init (init/main.c:1570)
[    1.227181][    T1]  ? ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    1.227181][    T1]  ? entry_INT80_32 (arch/x86/entry/entry_32.S:945)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260106/202601061219.9effe621-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


