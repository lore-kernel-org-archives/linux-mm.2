Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2BD8CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183718E0007; Tue, 11 Nov 2025 02:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1343C8E0002; Tue, 11 Nov 2025 02:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0226D8E0007; Tue, 11 Nov 2025 02:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF4978E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:06:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 803C688BD6
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:06:10 +0000 (UTC)
X-FDA: 84097442100.11.00FFDDE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id B1B864000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:06:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G93jSm5o;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0KpC39WL8NM+3KQ+0I20JaGlgFMlTaXCwzd4LIoSovQ=;
	b=1LdM/44Ommkrk1/PTp/g/3J9tBQmrwXQoKk8OvRs4cVLblbps1Fh5Ghf9sp0K2gKQwzqlW
	NyvtYV5bZOEdQMl7IRsNcEDcppwhmNlRgS/W2pPTYnXFhA1tNdB7sAaPFdoAeLz/kcycRS
	+18Q0uu6UX5OAQ34a616cN6D0UfqjJM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762844767; a=rsa-sha256;
	cv=fail;
	b=izijJ2OzvxncWxFTeGCaOQkdfHHM7cwMVDjlcpoyk6JUVpp+Y85XYpGmFg183fKZLQ7h+W
	9FrsUV9luVWgE/8LpNUlETUWZXIijCyaF/kC4wORw2F2C4MSb+ogRRwlVf1DxahuNJbTtN
	XN0jem7ioaSM9tN7KzEY8taL2XyUL2E=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G93jSm5o;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762844767; x=1794380767;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=joJ8gqicDFmkO14QYXxSLjWLPbrTSwyZv+5vog5jFoA=;
  b=G93jSm5o+T4GsNakrzlX+vKy9xMnW2fgS/hnw2ct+qCnVzuJrT7mHvMa
   KPh5NKVAoA+S+kzcx2n+CBasF6H63F+rYfzMsfTexYzcWBO61nqhMhryu
   Gcd9TiuO0slrsF5KfFWjIqHxv1zcs1IWCme543YJphIgM/Zy+bV8521+N
   TreQPdmWcEcH4JibnM76vfDkpeeUYyL+egiSHZcZBAIhcClWN4cOj8K7X
   D+0epFH8slC6nAEdNX0ZsWl7MJYWFra0im2xPX5WF+sR+MExfKhmyi3r+
   YkPgukNeO5fjDuLrfZMk4nVqzm45NQ6fEs8tZ1+ABygDyXGQtcCjMIduR
   g==;
X-CSE-ConnectionGUID: Ouzkad4nTumuU7y0iTHDNA==
X-CSE-MsgGUID: k+hiATmrQOKB3E2bSz3W3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="65059380"
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="65059380"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 23:06:05 -0800
X-CSE-ConnectionGUID: TqOIBBvoSPiFmgnS1pXkMg==
X-CSE-MsgGUID: nMYD7pN2SkqRJAl7rH4C2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="189629992"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 23:06:04 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 23:06:03 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 23:06:03 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 23:06:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MB0QT2zgCTY/s9zkd8Om851AzLGxKftmKau5oblyjYP0nIGaW6tIMx2zBAvZZ9K0YghfdSBwx89f443bSvL4hxDG10KqG2voal55cwcknmBAgwYXMpmTOEIpbfkt/Jrkmh7Wl31D+jrGqmla6SQ2kxgPR8pw/HyWSaYaG7GTForN/EHAgZP8hhGR2mJ+gG8jlb60W39WtVkKM/2PW7Msm120LlSGQQZIYfKeghflDa5ozw+pxyrHmvObO8z2q26t+65RBkGzy7/7paz+JPF8akiNBkTsSoyD+24fdovRpnngdJXmIu2Y3cO1VvRiDlRGV/KcP42MuIUaVLHai711dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KpC39WL8NM+3KQ+0I20JaGlgFMlTaXCwzd4LIoSovQ=;
 b=XmFKHason+8AclvHjiJRQDPz1Eo8jXJ6C4LZEtw1efrh9TsvO5/sqMFlSBf888apRaEF3X6tEkgkE5oJKX/QmkKhAikXu34eVvq5YhNVuJq08J0IW4WYvyt7+mLhVl7cNygdOXkugMo/vj+/JiVcMvKDBDp8NEnpP6jZq5NMNrYVapdPj9by1IdoA7cwd9uEMndy5/hGbMmj4QkOp5KIRw5IjDgcq4mG3eDndJokX/nB+77WwiWVj5p8/s0+BoIQTc7zD3JWMpGg4IS8DY9n66XLIv+x4g7uLE0OQazANW2JYqsrSnPS49vkdBuMhuN0B8YoWWSkCR/LTf1U4rWlLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH3PPFF2B8F6C64.namprd11.prod.outlook.com (2603:10b6:518:1::d60) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 07:06:01 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 07:06:01 +0000
Date: Tue, 11 Nov 2025 15:05:49 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Matthew Wilcox <willy@infradead.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Christian Brauner
	<brauner@kernel.org>, David Hildenbrand <david@redhat.com>, Christoph Hellwig
	<hch@lst.de>, Hugh Dickins <hughd@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [mm]  60a70e6143: xfstests.generic.363.fail
Message-ID: <202511111513.2c44a63e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: KU1PR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:802:18::27) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH3PPFF2B8F6C64:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b6ce2c-8b2b-472f-0ce5-08de20f0c566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GKgBiaeIdJOh4v1jIKDHTQ5RpoiQhHf0jH8WScWbQ7EIy6XEsNrM5yPiXJiM?=
 =?us-ascii?Q?U+5/4dW/fmL13YW+F1KxQLCRNl4KLOUhfIZ+JRI/YQfj9Uffl0txMEnNDTIz?=
 =?us-ascii?Q?PJhk44Ewvmnt31aEBaASP9ljFsnEUs242pLotQFC1Ll+kOxXlOBk+vJPCqZC?=
 =?us-ascii?Q?1BfPym99EqEfJlyRDxJm8W/XeGe9R5pUuHjANrtBA0BzS6aiX7Rgr7qSN1LV?=
 =?us-ascii?Q?eXU2U+V4XJzr2RVV1RXA/5U9xYYIUx2auCzNoPZrgdChIdoCxlCrLCbfkqMZ?=
 =?us-ascii?Q?Tq3YU5bprs4euT026/rxecN3IWAdOAyAmrL1DVfkWfcXRF1pPeKjGGTK4iHI?=
 =?us-ascii?Q?mPgD2sA062Aet8q0YVYCsYsAf8o/RK9p604waFq6TQtQWIsJWFAmfh/Or6wi?=
 =?us-ascii?Q?t15uQI5+fodWkKUZDorXgUct5ckmVxvzDNSDqONyL3dcvqbtFW49wY1/j+EH?=
 =?us-ascii?Q?J7rUAmlj43gQosrPtYgqLiCn8vwycyqQhJmMiyEGWF36y9WoyNcnlnfPTQvq?=
 =?us-ascii?Q?dmVo+6FYPXQeu4UNLvs/ftKZ/phpzuWIZdTpwRY0Dc59zcNwGv1d1w84EvD7?=
 =?us-ascii?Q?0wGvnXVH6l2ibHJM48gigOmWxPOb0IOqRblv+AZqf5piJSW2JLCRuJUBPEsa?=
 =?us-ascii?Q?FDhjkeGNMklJMUACtr4oyeZH2VzHMkB4pdf7ppE/hZybLZYjlz5LkU1wNYgk?=
 =?us-ascii?Q?YocOo0ePdBuEYqJfMd+GVCt/Iq3MUWuxqjf0eq7Yuf5ZMZx+GCgtWGK1aK7G?=
 =?us-ascii?Q?6fwyH00kBDp/EN7ber8bNRjjoSr4e4EPLhwmU0zD4p9G68/E9Gg3EdT6vSlM?=
 =?us-ascii?Q?YCQDaQ+mTn7auMxSC3+sVbFZPrH/wJTZQJ3UxtLrnLAh2PwgDE4Zu+rZDN4i?=
 =?us-ascii?Q?MbyXmbWiSf0AFuKAhljCl3FSEkr0/C9xG95D3VS6bRcc8qH6Ejior8HniaJs?=
 =?us-ascii?Q?UDhPT0qtLchNXxhapXxr2SXo/GhIw2alTKkn9eyjGCCdN33rwwEuECHAPa9T?=
 =?us-ascii?Q?LcTMA2SPnWX8lWNHmB95tb+uyBQakRukbKRB/Fs43s0ONkIYuzNFxevPHtAR?=
 =?us-ascii?Q?zyPLMd1bjqt7R3TCzWt6pplIjXkRfAGoBvSdGayqvJhLQ90B8mVBYKyZMKxc?=
 =?us-ascii?Q?1yYfljRm+oBAUotJ4EAGSY2+C+WRMw3CwEAw2K1EY0q8Qq8zRTSksTKBNsyn?=
 =?us-ascii?Q?2ygMPxoV6Xwo3XY2U9NC1AIAY5pJ8NoyQ0/zAAz1KA3IwOmRvD+UzV/Ce0JR?=
 =?us-ascii?Q?yZW1vsYsYxsRG3BrDC/xzqybKOooGExNvMC0Xhs/mu7beh6LaKe1TqDuXULy?=
 =?us-ascii?Q?BLMV+rTfvZrYzcqUAUGWeZ+J4oJydQVqqExw14QNnBj0sUzQMIBShiF3hiXD?=
 =?us-ascii?Q?yD8TH+LbNKIDzeqMnuk47SLfp+5dVVCsKdrnEXwDsuT7a5QwPScGgdD08MDX?=
 =?us-ascii?Q?bcXLq2HO6m2/+oPi8jiofEXuYwKndlFTsrRQ1iYORUy18eZiJhN4KA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EADDwzhsS8SrJ5XA9OHzdh/e2UTR66gjQCHLyORwMrRdBLhP1xwYMuqQsiJG?=
 =?us-ascii?Q?6ml6mfqHrBWE/R+GW712hHmVA0agD4kXPhfRPTtdNLeKTLkbWeYI1T2EiopY?=
 =?us-ascii?Q?yqrIZCgTC4Q2oRCKauAMEM5kO80pOFL+c/+3UkRxJPoUBI9jewLza7/v/WB0?=
 =?us-ascii?Q?bSalu87EfnoX8at/4hqBi9otLUSZLzrfYFxTIX23LsxXXILtUeYqxPEMAhJl?=
 =?us-ascii?Q?e3No+drGSearfDL+Pozij5CQbNj4HVDKYvNM4KwRKpY3WbU+RXWtXExZ28TV?=
 =?us-ascii?Q?WlGqXcIbMBj4p+8vqSSGIZibQ+Rei+i3ejdw9BVeInWqqILpbWbDgodNyUFn?=
 =?us-ascii?Q?j1fveXwH04vHlDg4QFfoz9yrd+tAM/36fdmI8dMcgsEEEp4JeKCLrH8x0q+G?=
 =?us-ascii?Q?SFWIDXoQYA0TY94QUX9MGILfP1N3q8DUf9FA6iI6+HRZo8avuEd6L96NL7/+?=
 =?us-ascii?Q?rp3Ym59pGzToztGpvQDT4a15pYOlaH+9qLs/PU9FIAbtN6evh6Tz6X8avJ86?=
 =?us-ascii?Q?EFFqQgBMy3UDHP/A29DoYlXjqK1bk4glmwiMO5yBOzIA4e/uZQHkZhHWIH2I?=
 =?us-ascii?Q?VhQDH+HnDl1jawoutwEXYHZOkbtzRC6YtLczJxb7jEdxy+ZFfImOXeqt6B14?=
 =?us-ascii?Q?aU7Crvvsl5WmbPt28dlZkLlVE0CZg8e11/w1DmsNXgU3w5ydW5mLyTSClQa/?=
 =?us-ascii?Q?W/wZP/OXbFIWzASPRr6LxF3c3FU3Wket3pD4fMjIq63nr0+IHI4xWFqd4fUl?=
 =?us-ascii?Q?YBsrXt0wpGOEnBVFudAGGwiKTlzy5l+Bu9+TgZ55QhHcDxXtr+dkTUvcEBoq?=
 =?us-ascii?Q?twg+yHOYPVp+VbPDrtuxB4so5u9sFla82amzitzi5HV1BO9oPtQw8S/mtHzG?=
 =?us-ascii?Q?enzreMDzdYPq3rYjAd+DASWBX0+2gIdf/udhpYuA5H1Qn/8fexbecmcHKtYl?=
 =?us-ascii?Q?f+wctwTVLI7qWIjRQgXvSWMXwd57UXV+E5Joi2wteD2i7iXKR0+Rmd8O9hMu?=
 =?us-ascii?Q?4Hk/nPTrTe9pGyFKRvfw3iwfvps31Qb5hdAqfAgHdP3SR8Wg08bwURHCeFt+?=
 =?us-ascii?Q?D/3C87hbKZ8OegO4jwYr/Xr+2+rtMkXBRHJIq15CFNgJ21BTXLif7LnvCY1R?=
 =?us-ascii?Q?nc9zXHtGvhjPJIgR73f+xogH+zhxcdYgzpsllzh6NlyKg/wGxwqtqBLRg51x?=
 =?us-ascii?Q?/lWft/hmVatyfCqeL0ZrHe0ZVVTguyRXpvpWDbpYcAaNJGHvpMyTtSoumCJn?=
 =?us-ascii?Q?yEdYEphbF9OXdqmf3uShNdN1sazgGga4DvrxdKm0kJEkvPNoqYjAsXugCaPw?=
 =?us-ascii?Q?jSpNO5UVnsSby1+Ipuq9lnAsTbTV3l86fw2wiosWEp/wzedAz3gTv8OAcMuL?=
 =?us-ascii?Q?vouEHHwsfvCnJtGAXrT7f8bJHBv/FhCUga48ChHAe+2Fq2nObDygCtAtXMkT?=
 =?us-ascii?Q?rKSKUhqLk9Ge1iySC9ugRtkPEqdir5uo87J2neiShOiBAUCCrQq8pfRzsamO?=
 =?us-ascii?Q?25ggrkmylw2bBRzPRt6ZEhYRaaYMifH6y6o5dHNQHRMCkGFfpqDcMJE26WxL?=
 =?us-ascii?Q?Q0MJt3L/2PV2hYK4V7qvSF5zQowY0rEPKmU5GV8mhulzSM1QyCEPM5q8YoPV?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b6ce2c-8b2b-472f-0ce5-08de20f0c566
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 07:06:01.1240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1ff8YHT7ZHca+RkFTTTBkS0KbqVoJGOc1ALBUbvSbsdqijDb9YXjztkextMF9Q8QXUl5yy0CKgRrlYqhWQ9vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFF2B8F6C64
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1B864000A
X-Stat-Signature: 71w7g3ppkokq83p8mptgfr85ou3huezx
X-Rspam-User: 
X-HE-Tag: 1762844766-87199
X-HE-Meta: U2FsdGVkX1/GiiFeEWB1G4vwjl3+MXUC83FH2RyyuBp7aEatHxAdiPmVE2Ij5Gcef65L0Qw8KRGEYLNSZ6qYnzXMyzx6gTto6U74w+JCR160HuagpQZnO9UIxkeZiI0lgsvJQ1dwjpivY+XE1TV5hc3qH5SbyiqMbnAGGMNBs864cQ8ghpokLoX8kqiPPea9pltVUwiK210CqkWIAZH8Mf/jEVIeORAKhgwbp6zGWN9RfJGg399F2yF/vAIOPEyaObx8VZzdBlorl6Dzk5XVfkl10chkj0TaxVmSRH6I9C5BrCjRFNLgo/hAPxECg/EzfKdP2x0qKZ8cApyyne/AJLUsJBrYfjxvqIyfGWXZsBPEdCIP90uEf3sxbdBQK6wbKJp+GTl6y1EEaQ+mHqJNU6W+fQNtBTeHcbtIxR5LR/YtMY6uRkttEb42dJvgPqOCnzeuIx8H6heEEeBv8OV2DyIjRAW6HvefKaNkX/sLmKZYmntF1tcW4Vwdwmo8uSgwgsGtWLUkDBlvkK0ke/KAhF2N3BMSh4G22/qPypmLQRPIVuXUAuGqmObWwsyikGTXJnv9LRmbi+pWI5vNaXvogjzkgU8VzvW4yyHiq+6XaSIWJmOCrFvqsBJO4tEufWHHKvuKG+6fMjr1No+VXYo2VrwUKXljW4HwuvXj5TtnBukdiytgsMGweV9Psk7IwDGOpXXY8Lv1nmqeAODxVMQIamE3HRV1dngDqR8p3x51JXxkmIGslAvsj6+rq5M8ieh60a9uFWJ98VRlL3Hl6sZZBFzvqJJA8bAYYJm9lZgLFEPcjn8kQYe1a2qaOWh+RD9M9+FvEPUVoUUqr/T1pEt/D5IJqULvp18qFW/aciarq/oG01b4mtq39aBicb4Z3kRBZYm5Sl4ITWBrP+Zl+joqSdIS3nH/RZOwyGDomGP8ZJAeAb0dj6QsCa/YT5CyKv4Mcaqa4RAa9ZGM2JArqr6
 bHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "xfstests.generic.363.fail" on:

commit: 60a70e61430b2d568bc5e96f629c5855ee159ace ("mm: Use folio_next_pos()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 9c0826a5d9aa4d52206dd89976858457a2a8a7ed]

in testcase: xfstests
version: xfstests-x86_64-2cba4b54-1_20251020
with following parameters:

	disk: 4HDD
	fs: ext4
	test: generic-363



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511111513.2c44a63e-lkp@intel.com

2025-11-09 02:50:19 cd /lkp/benchmarks/xfstests
2025-11-09 02:50:19 export TEST_DIR=/fs/sda1
2025-11-09 02:50:19 export TEST_DEV=/dev/sda1
2025-11-09 02:50:19 export FSTYP=ext4
2025-11-09 02:50:19 export SCRATCH_MNT=/fs/scratch
2025-11-09 02:50:19 mkdir /fs/scratch -p
2025-11-09 02:50:19 export SCRATCH_DEV=/dev/sda4
2025-11-09 02:50:19 echo generic/363
2025-11-09 02:50:19 ./check -E tests/exclude/ext4 generic/363
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lkp-skl-d02 6.18.0-rc1-00010-g60a70e61430b #1 SMP PREEMPT_DYNAMIC Sun Nov  9 10:29:45 CST 2025
MKFS_OPTIONS  -- -F /dev/sda4
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda4 /fs/scratch

generic/363       [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/363.out.bad)
    --- tests/generic/363.out	2025-10-20 16:48:15.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/363.out.bad	2025-11-09 02:51:05.593092955 +0000
    @@ -1,2 +1,9399 @@
     QA output created by 363
     fsx -q -S 0 -e 1 -N 100000
    +READ BAD DATA: offset = 0x28db4, size = 0xed5, fname = /fs/sda1/junk
    +OFFSET      GOOD    BAD     RANGE
    +0x29a39     0x0000  0xa079  0x0
    +operation# (mod 256) for the bad data may be 121
    +0x29a3a     0x0000  0x79a6  0x1
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/363.out /lkp/benchmarks/xfstests/results//generic/363.out.bad'  to see the entire diff)
Ran: generic/363
Failures: generic/363
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251111/202511111513.2c44a63e-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


